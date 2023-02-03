





--新的选择战术技能卡面板
hGlobal.UI.InitTacticCardFrm_New = function(mode)
	--不重复创建
	if hGlobal.UI.PhoneSelectedTacticFrm_New then --新的选择战术技能卡面板
		return
	end
	
	local BOARD_WIDTH = 840 --战术技能卡面板的宽度
	local BOARD_HEIGHT = 550 --战术技能卡面板的高度
	local BOARD_OFFSETY = -20 --战术技能卡面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --战术技能卡面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --战术技能卡面板的y位置（最顶侧）
	local BOARD_ACTIVE_WIDTH = 508 --战术技能卡面板活动宽度（卡牌显示的宽度）
	
	local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的y偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local GetFirstLvUpTowerCardIdx = hApi.DoNothing --获得第一个可以升级的塔的索引
	local OnCreateTowerArchyDiagramFrame = hApi.DoNothing --创建分支类塔的升级图界面（第1、2、3个分页）
	local OnClickTowerBtn = hApi.DoNothing --点击塔的按钮
	local OnCreateSpecialDiagramFrame = hApi.DoNothing --创建特殊塔的升级图界面（第4个分页）
	local OnCreateSingleSpecialCard = hApi.DoNothing --创建单个特殊塔控件
	local refresh_special_UI_scroll_loop = hApi.DoNothing --自动调整特殊塔控件的滑动
	local GetFirstLvUpSpecialTowerIdx = hApi.DoNothing --获得第一个可以升级的特殊塔的索引
	local OnClickSpecialTowerBtn = hApi.DoNothing --点击特殊塔的按钮
	local CalSpecialCardIndex = hApi.DoNothing --计算某个特殊塔的索引值
	local OnCreateTacticDiagramFrame = hApi.DoNothing --创建战术技能卡的升级图界面（第5个分页）
	local GetFirstLvUpTacticCardIdx = hApi.DoNothing --获得第一个可以升级的战术技能卡的索引
	local OnCreateSingleTacticCard = hApi.DoNothing --创建单个战术技能卡控件
	local refresh_tacitc_UI_scroll_loop = hApi.DoNothing --自动调整战术技能卡控件的滑动
	local CalTacticCardIndex = hApi.DoNothing --计算某个一般战术技能卡的索引值
	local OnClickTacticBtn = hApi.DoNothing --点击一般战术技能卡的按钮
	local OnClickLvUpButton = hApi.DoNothing --点击升级战术技能卡按钮
	local OnCreateSkillTipFrame = hApi.DoNothing --查看塔的技能说明tip
	local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
	local RefreshGuideUpgratePage = hApi.DoNothing --更新提示当前哪个分页可以升级了
	
	--参数
	--箭塔配置参数
	local baseTowercardId_jianta = 10001 --箭塔的最原始塔的类型id
	local mediumTowetcardId_jianta = 10002 --箭塔第一次升级的塔的类型id
	local archyTacticCardList_jianta = hVar.TACTIC_UPDATE_JIANTA --箭塔升级的分支战术技能卡
	--法术塔配置信息
	local baseTowercardId_fashu = 10201 --法术塔的最原始塔的类型id
	local mediumTowetcardId_fashu = 10202 --法术塔第一次升级的塔的类型id
	local archyTacticCardList_fashu = hVar.TACTIC_UPDATE_FASHUTA --法术塔升级的分支战术技能卡
	--炮塔配置信息
	local baseTowercardId_paota = 10101 --炮塔的最原始塔的类型id
	local mediumTowetcardId_paota = 10102 --炮塔第一次升级的塔的类型id
	local archyTacticCardList_paota = hVar.TACTIC_UPDATE_PAOTA --炮塔升级的分支战术技能卡
	
	--特殊塔界面相关参数
	local SPECIAL_CARD_WIDTH = 80 --特殊塔卡的宽度
	local SPECIAL_CARD_HEIGHT = 92 --特殊塔的高度
	local SPECIAL_X_NUM = 4 --特殊塔x方向数量
	local SPECIAL_Y_NUM = 3 --特殊塔y方向数量
	local SPECIAL_CARD_OSSSET_XL = PAGE_BTN_LEFT_X - 35 --第一个特殊塔的x位置
	local SPECIAL_CARD_OSSSET_Y = PAGE_BTN_LEFT_Y - 107 --第一个特殊塔的y位置
	local SPECIAL_CARD_DISTANCE_X = 90
	local SPECIAL_CARD_DISTANCE_Y = 105
	local SPECIAL_PANEL_HEIGHT = 316 --特殊塔面板的高度
	local MAX_SPEED_SPECIAL = 50 --特殊塔最大速度
	
	local click_pos_x_special = 0 --特殊塔开始按下的坐标x
	local click_pos_y_special = 0 --特殊塔开始按下的坐标y
	local last_click_pos_x_special = 0 --特殊塔上一次按下的坐标x
	local last_click_pos_y_special = 0 --特殊塔上一次按下的坐标y
	local draggle_speed_y_special = 0 --特殊塔当前滑动的速度x
	local selected_specialEx_idx = 0 --特殊塔选中的成就ex索引
	local click_scroll_special = false --特殊塔是否在滑动成就中
	local b_need_auto_fixing_special = false --特殊塔是否需要自动修正
	local friction_special = 0 --阻力
	
	--一般战术卡界面相关参数
	local TACTIC_CARD_WIDTH = 80 --战术技能卡的宽度
	local TACTIC_CARD_HEIGHT = 100 --战术技能卡的高度
	local TACTIC_X_NUM = 4 --战术卡x方向数量
	local TACTIC_Y_NUM = 4 --战术卡y方向数量
	local TACTIC_CARD_OSSSET_XL = PAGE_BTN_LEFT_X - 35 --第一个战术技能卡的x位置
	local TACTIC_CARD_OSSSET_Y = PAGE_BTN_LEFT_Y - 105 --第一个战术技能卡的y位置
	local TACTIC_CARD_DISTANCE_X = 90
	local TACTIC_CARD_DISTANCE_Y = 110
	local TACTIC_PANEL_HEIGHT = 440 --一般战术技能卡面板的高度
	local MAX_SPEED_TACTIC = 50 --战术卡最大速度
	
	local click_pos_x_tactic = 0 --战术卡开始按下的坐标x
	local click_pos_y_tactic = 0 --战术卡开始按下的坐标y
	local last_click_pos_x_tactic = 0 --战术卡上一次按下的坐标x
	local last_click_pos_y_tactic = 0 --战术卡上一次按下的坐标y
	local draggle_speed_y_tactic = 0 --战术卡战术卡当前滑动的速度x
	local selected_tacticEx_idx = 0 --战术卡选中的成就ex索引
	local click_scroll_tactic = false --战术卡是否在滑动成就中
	local b_need_auto_fixing_tactic = false --战术卡是否需要自动修正
	local friction_tactic = 0 --战术卡阻力
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页索引、数据项索引，卡牌id的信息记录
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	hApi.clearTimer("__SPECIAL_TIMER_UPDATE__")
	hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
	
	--创建战术技能卡父控件（新）
	hGlobal.UI.PhoneSelectedTacticFrm_New = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		background = "UI:Tactic_Background",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
	local _parent = _frm.handle._n
	
	--左侧裁剪区域-特殊塔
	local _BTC_PageClippingRect_Special = {0, -72, 1000, 318, 0}
	local _BTC_pClipNode_Special = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Special, 99, _BTC_PageClippingRect_Special[5], "_BTC_pClipNode_Special")
	
	--左侧裁剪区域-一般战术卡
	local _BTC_PageClippingRect_Tactic = {0, -74, 1000, 438, 0}
	local _BTC_pClipNode_Tactic = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Tactic, 99, _BTC_PageClippingRect_Tactic[5], "_BTC_pClipNode_Tactic")
	
	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	if (g_phone_mode ~= 0) then
		closeDx = 0
		closeDy = -20
	end
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		w = 64,
		h = 64,
		scaleT = 0.95,
		code = function()
			--不显示金币界面
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--不显示战术技能卡面板
			hGlobal.UI.PhoneSelectedTacticFrm_New:show(0)
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--删除特殊塔自动调整滑动的timer
			hApi.clearTimer("__SPECIAL_TIMER_UPDATE__")
			
			--删除战术技能卡自动调整滑动的timer
			hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
			
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		end,
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
		--text = "战术卡", --language
		text = hVar.tab_string["__TEXT_MAINUI_BTN_TACITC"], --language
	})
	]]
	
	--每个分页按钮
	--箭塔、法术塔、炮塔、特殊、战术技能卡
	local tPageIcons = {"UI:Tactic_JianTa", "UI:Tactic_FaShuTa", "UI:Tactic_PaoTa", "UI:Tactic_TeShu", "UI:Tactic_ZhanShu",}
	--local tTexts = {"箭塔", "法术塔", "炮塔", "特殊塔", "战术卡",} --language
	local tTexts = {hVar.tab_string["JianTaPage"], hVar.tab_string["FashuTaPage"], hVar.tab_string["PaoTaPage"], hVar.tab_string["TeShuTaPage"], hVar.tab_string["TacticCardPage"],} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X,
			y = PAGE_BTN_LEFT_Y,
			w = 130,
			h = 60,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮的控制部分，用于处理响应，不显示
		
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:Tactic_Button",
			x = 0,
			y = 0,
			w = 116,
			h = 48,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = -40,
			y = 5,
			w = 32,
			h = 32,
		})
		
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "ICON:image_jiantouV",
			x = -40,
			y = 5 + 3,
			w = 32,
			h = 32,
		})
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 10,
			y = 3,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
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
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--点击分页按钮函数
	OnClickPageBtn = function(pageIndex)
		--不重复显示同一个分页
		if (CurrentSelectRecord.pageIdx == pageIndex) then
			return
		end
		
		--当前按钮高亮
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			end
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--
		--移除timer
		hApi.clearTimer("__SPECIAL_TIMER_UPDATE__")
		hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Special", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Tactic", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：箭塔
			--创建分支类塔的升级图界面
			OnCreateTowerArchyDiagramFrame(pageIndex, baseTowercardId_jianta, mediumTowetcardId_jianta, archyTacticCardList_jianta)
		elseif (pageIndex == 2) then --分页2：法术塔
			--创建分支类塔的升级图界面
			OnCreateTowerArchyDiagramFrame(pageIndex, baseTowercardId_fashu, mediumTowetcardId_fashu, archyTacticCardList_fashu)
		elseif (pageIndex == 3) then --分页3：炮塔
			--炮塔配置信息
			--创建分支类塔的升级图界面
			OnCreateTowerArchyDiagramFrame(pageIndex, baseTowercardId_paota, mediumTowetcardId_paota, archyTacticCardList_paota)
		elseif (pageIndex == 4) then --分页4：特殊
			--创建特殊塔的升级图界面
			OnCreateSpecialDiagramFrame(pageIndex)
		elseif (pageIndex == 5) then --分页5：战术技能卡
			--创建战术技能卡的升级图界面
			OnCreateTacticDiagramFrame(pageIndex)
		end
		
		--标记当前选择的分页、页内的第几个、卡牌id
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
		CurrentSelectRecord.cardId = 0
		
		--默认选中第一个按钮
		if (pageIndex == 1) or (pageIndex == 2) or (pageIndex == 3) then --塔的分页
			--默认点击第一个可升级的塔（没有返回左下角的塔）
			local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(pageIndex)
			OnClickTowerBtn(pageIndex, firstLvUpTowerIdx)
		elseif (pageIndex == 4) then --特殊
			--默认点击第一个可升级的特殊塔（没有返回第一项）
			local firstLvUpSpecialIdx = GetFirstLvUpSpecialTowerIdx()
			OnClickSpecialTowerBtn(pageIndex, firstLvUpSpecialIdx)
		elseif (pageIndex == 5) then --战术技能卡
			--默认点击第一个可升级的战术技能卡（没有返回第一项）
			local firstLvUpTacticIdx = GetFirstLvUpTacticCardIdx()
			OnClickTacticBtn(pageIndex, firstLvUpTacticIdx)
		end
	end
	
	--函数：获得第一个可以升级的塔的索引
	GetFirstLvUpTowerCardIdx =  function(pageIndex)
		local towerList = nil --塔的列表
		if (pageIndex == 1) then --箭塔分页
			towerList = archyTacticCardList_jianta
		elseif (pageIndex == 2) then --法术塔分页
			towerList = archyTacticCardList_fashu
		elseif (pageIndex == 3) then --炮塔分页
			towerList = archyTacticCardList_paota
		end
		
		--塔的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--获得所有塔类战术卡
		local towerDictionary = {} --塔类战术技能卡
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.TOWER) then --此类专属于塔类战术技能卡，放在此处
							--检测是否重复
							if (towerDictionary[id]) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerDictionary[j].skillLV) then
									towerDictionary[j].skillLV = lv
									towerDictionary[j].num = num
								end
							else --不存在
								towerDictionary[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		for i = 1, #towerList, 1 do
			local towerId = towerList[i] --塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if towerDictionary[towerId] then
				tacticLv = towerDictionary[towerId].skillLV
				tacticDebrisNum = towerDictionary[towerId].num
			end
			
			--检测是否可以升级
			local lvNow = tacticLv or 0
			if (lvNow >= maxLv) then
				lvNow = maxLv
			end
			local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
			local costScore = 0 --需要的积分
			local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				costScore = tabShopItem.score or 0 --需要的积分
			end
			
			if (lvNow > 0) then --已获得的
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return (2 + i) --前2个是基础塔和高级塔
					end
				end
			else --未获得的
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return (2 + i)
				end
			end
		end
		
		--走到这里说明没有能升级的塔
		return 3 --前2个是基础塔和高级塔
	end
	
	--函数：创建分支类塔的升级图界面（第1、2、3个分页）
	--参数：页面索引值，父控件，基础塔类型id，升级一次后的塔类型id，升级的战术技能卡列表
	OnCreateTowerArchyDiagramFrame = function(pageIndex, baseTowercardId, mediumTowetcardId, archyTacticCardList)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local BTN_EDGE = 64 --按钮的边长
		local lineVHeight1 = 50 --第一条竖线高度
		local lineVHeight2 = 40 --第二条竖线高度
		local lineHWidth = 80 --横线的宽度
		
		local OFFSET_X = 215 --统一偏移x
		local OFFSET_Y = -95 --统一偏移y
		local Scale0 = BTN_EDGE / 70
		
		--绘制初级塔
		_frmNode.childUI["BaseTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = hVar.tab_unit[baseTowercardId].icon,
			x = OFFSET_X,
			y = OFFSET_Y,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(pageIndex, 1)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BaseTowerIcon"
		
		--初级塔的按钮选中框
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["BaseTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第一条竖线
		_frmNode.childUI["LineV1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE / 2 - lineVHeight1 / 2,
			w = 12,
			h = lineVHeight1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV1"
		
		--中间升级的塔图标
		_frmNode.childUI["mediumTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = hVar.tab_unit[mediumTowetcardId].icon,
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(pageIndex, 2)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "mediumTowerIcon"
		
		--中间升级的塔的按钮选中框
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["mediumTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第二条竖线
		_frmNode.childUI["LineV2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 / 2 - 1, --1像素偏差
			w = 12,
			h = lineVHeight2,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV2"
		
		--三叉线
		_frmNode.childUI["LineThree"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineT",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8,
			w = 30,
			h = 16,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineThree"
		
		--左侧横线
		_frmNode.childUI["LineHL"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X - 15 - lineHWidth / 2 - 3, --3像素偏差
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHL"
		
		--左侧拐弯线
		_frmNode.childUI["LineRJT_L"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X - 15 - lineHWidth - 12,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		--_frmNode.childUI["LineRJT_L"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_L"
		
		--右侧横线
		_frmNode.childUI["LineHR"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X + 15 + lineHWidth / 2 - 3,--3像素偏差
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHR"
		
		--右侧拐弯线
		_frmNode.childUI["LineRJT_R"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X + 15 + lineHWidth + 12,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		_frmNode.childUI["LineRJT_R"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_R"
		
		--中间的竖线箭头
		_frmNode.childUI["LineJT_M"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineJT",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 24,
			w = 24,
			h = 20,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineJT_M"
		
		--第一个改造塔的分支
		local tacticCardId1 = archyTacticCardList[1] --第一个战术技能卡分支的id
		local model1 = "UI:LOCK"
		if tacticCardId1 and (tacticCardId1 ~= 0) then
			model1 = hVar.tab_tactics[tacticCardId1].icon
		end
		_frmNode.childUI["archyTowerIcon1"] = hUI.button:new({
			parent = _parentNode,
			model = model1,
			x = OFFSET_X - 15 - lineHWidth - 12,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(pageIndex, 3)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon1"
		
		--第二个改造塔的分支
		local tacticCardId2 = archyTacticCardList[2] --第二个战术技能卡分支的id
		local model2 = "UI:LOCK"
		if tacticCardId2 and (tacticCardId2 ~= 0) then
			model2 = hVar.tab_tactics[tacticCardId2].icon
		end
		_frmNode.childUI["archyTowerIcon2"] = hUI.button:new({
			parent = _parentNode,
			model = model2,
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			z = 1,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(pageIndex, 4)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon2"
		
		--第三个改造塔的分支
		local tacticCardId3 = archyTacticCardList[3] --第三个战术技能卡分支的id
		local model3 = "UI:LOCK"
		if tacticCardId3 and (tacticCardId3 ~= 0) then
			model3 = hVar.tab_tactics[tacticCardId3].icon
		end
		_frmNode.childUI["archyTowerIcon3"] = hUI.button:new({
			parent = _parentNode,
			model = model3,
			x = OFFSET_X + 15 + lineHWidth + 12,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(pageIndex, 5)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon3"
		
		--获得所有的塔类战术技能卡
		local towerDictionary = {} --塔类战术技能卡
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.TOWER) then --此类专属于塔类战术技能卡，放在此处
							--检测是否重复
							if (towerDictionary[id]) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerDictionary[j].skillLV) then
									towerDictionary[j].skillLV = lv
									towerDictionary[j].num = num
								end
							else --不存在
								towerDictionary[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--依次绘制每个改造塔的子控件
		for i = 1, 3, 1 do
			local button = _frmNode.childUI["archyTowerIcon" .. i]
			local towerLv = 0 --塔的等级
			local towerNum = 0 --塔类碎片的数量
			local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
			local requireDebriNum = hVar.TACTIC_LVUP_INFO[1].costDebris --升级需要的碎片的数量
			local nowScore = LuaGetPlayerScore() --当前的积分
			local costScore = 0 --升级需要的积分
			
			local tacticCardId = archyTacticCardList[i] --战术技能卡id
			if (towerDictionary[tacticCardId]) then
				towerLv = towerDictionary[tacticCardId].skillLV --塔的等级
				towerNum = towerDictionary[tacticCardId].num --塔类碎片的数量
				
				--当前等级不超过最大等级
				if (towerLv > towerLvMax) then
					towerLv = towerLvMax
				end
				
				local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
				requireDebriNum = tacticLvUpInfo.costDebris --升级需要的碎片的数量
				local shopItemId = tacticLvUpInfo.shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
			end
			
			--塔的按钮选中框
			button.childUI["selectbox"] = hUI.image:new({
				parent = button.handle._n,
				model = "UI:Tactic_Selected",
				align = "MC",
				x = 0,
				y = 0,
				scale = Scale0,
			})
			button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
			local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
			button.childUI["selectbox"].handle.s:runAction(forever)
			
			if (tacticCardId ~= 0) then
				--塔的的等级的背景图
				button.childUI["LvBG"]= hUI.image:new({
					parent = button.handle._n,
					model = "ui/pvp/pvpselect.png",
					x = BTN_EDGE - 38,
					y = 28,
					w = 34,
					h = 34,
				})
				
				--塔的等级文字
				local fontSize = 26
				if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
					fontSize = 18
				end
				button.childUI["Lv"] = hUI.label:new({
					parent = button.handle._n,
					x = BTN_EDGE - 38,
					y = 27,
					text = towerLv,
					size = fontSize,
					font = "numWhite",
					align = "MC",
					width = 200,
				})
				
				--塔的将魂经验条
				button.childUI["barSoulStoneExp"] = hUI.valbar:new({
					parent = button.handle._n,
					x = -31,
					y = -42,
					w = BTN_EDGE,
					h = 15,
					align = "LC",
					back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = BTN_EDGE + 4, h = 18},
					model = "UI:SoulStoneBar1",
					--model = "misc/progress.png",
					v = 0,
					max = 100,
				})
				
				--将魂可以升级的箭头提示
				--塔的升级的动态箭头
				button.childUI["towerSoulStonejianTou"] = hUI.image:new({
					parent = button.handle._n,
					model = "ICON:image_jiantouV",
					x = 15,
					y = -11,
					w = 26, --236
					h = 26, --146
					align = "MC",
				})
				--_frm.childUI["towerSoulStonejianTou"].handle._n:setRotation(0)
				button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
				
				--print(towerLv ,towerLvMax,towerNum,requireDebriNum)
				--根据碎片和当前等级的不同，来绘制一些控件的数值或颜色
				if (towerLv <= 0) then --还没有获得这个塔
					--灰掉
					hApi.AddShader(button.handle.s, "gray")
					
					--设置碎片进度
					button.childUI["barSoulStoneExp"]:setV(towerNum, requireDebriNum)
					
					--可升级的提示
					--碎片足够、积分足够
					local nowScore = LuaGetPlayerScore() --当前的积分
					local itemId = 0 --商品道具id
					local tacticInfo = LuaGetPlayerTacticById(cardId)
					if tacticInfo then
						local id, lv, num = unpack(tacticInfo)
						nowDebris = num --当前的碎片数量
					end
					
					--未升满级
					--碎片足够、积分足够，才提示可升级
					if (towerNum >= requireDebriNum) and (nowScore >= costScore) then
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
					else
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
					end
				else --已经获得这个塔
					--正常
					hApi.AddShader(button.handle.s,"normal")
					
					if (towerLv >= towerLvMax) then --塔的等级已经升到最高级
						--设置碎片进度为0
						button.childUI["barSoulStoneExp"]:setV(0, 100)
						--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
						
						--隐藏可升级的提示
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
						
						--创建一个进度条满了的特别进度条
						button.childUI["towerMaxLvProgressImg"] = hUI.image:new({
							parent = button.handle._n,
							model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
							x = -31 + BTN_EDGE / 2,
							y = -42,
							w = BTN_EDGE, --236
							h = 15, --146
							align = "MC",
						})
					else --还可以升级
						--设置碎片进度
						button.childUI["barSoulStoneExp"]:setV(towerNum, requireDebriNum)
						--button.childUI["labSoulStoneExp"]:setText(tostring(towerNum).. "/".. tostring(requireDebriNum))
						
						--可升级的提示
						--碎片足够、积分足够，才提示可升级
						if (towerNum >= requireDebriNum) and (nowScore >= costScore) then
							button.childUI["towerSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
						else
							button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
						end
					end
				end
			end
		end
		
		--塔的名字、介绍部分的底板
		_frmNode.childUI["TowerIntroBG"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 159 - BTN_EDGE / 2,
			w = 320,
			h = 130,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerIntroBG"
		
		--塔的名字文字
		_frmNode.childUI["TowerNameLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 30,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerNameLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerNameLabel"
		
		--塔的等级文字
		_frmNode.childUI["TowerLvLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 55,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerLvLabel"
		
		--塔的简介文字
		_frmNode.childUI["TowerIntroLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X - 148,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 24,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 300,
			text = "",
			border = 1,
		})
		_frmNode.childUI["TowerIntroLabel"].handle.s:setColor(ccc3(255, 255, 255)) --白色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerIntroLabel"
		
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickTower"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 400,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 330,
			--text = "点击左侧塔查看详情。", --language
			text = hVar.tab_string["ClickTowerSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickTower"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickTower"
	end
	
	--函数：点击塔的按钮的执行逻辑
	OnClickTowerBtn = function(pageIndex, contentIndex)
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		
		--print(pageIndex, cardId, bIsUnit, bIsBaseTower)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = nil --按钮控件
		local bIsUnit = nil --是否是单位塔
		local bIsBaseTower = nil --是否是最原始的塔
		local cardId = nil --卡牌id
		if (contentIndex == 1) then --最初级塔
			button = _frmNode.childUI["BaseTowerIcon"]
			bIsUnit = true
			bIsBaseTower = true
			
			if (pageIndex == 1) then --箭塔
				cardId = baseTowercardId_jianta
			elseif (pageIndex == 2) then --法术塔
				cardId = baseTowercardId_fashu
			elseif (pageIndex == 3) then --炮塔
				cardId = baseTowercardId_paota
			end
		elseif (contentIndex == 2) then --升后的高级塔
			button = _frmNode.childUI["mediumTowerIcon"]
			bIsUnit = true
			bIsBaseTower = false
			
			if (pageIndex == 1) then --箭塔
				cardId = mediumTowetcardId_jianta
			elseif (pageIndex == 2) then --法术塔
				cardId = mediumTowetcardId_fashu
			elseif (pageIndex == 3) then --炮塔
				cardId = mediumTowetcardId_paota
			end
		elseif (contentIndex == 3) then --分支1塔
			button = _frmNode.childUI["archyTowerIcon1"]
			bIsUnit = false
			bIsBaseTower = false
			
			if (pageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[1]
			elseif (pageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[1]
			elseif (pageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[1]
			end
		elseif (contentIndex == 4) then --分支2塔
			button = _frmNode.childUI["archyTowerIcon2"]
			bIsUnit = false
			bIsBaseTower = false
			
			if (pageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[2]
			elseif (pageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[2]
			elseif (pageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[2]
			end
		elseif (contentIndex == 5) then --分支3塔
			button = _frmNode.childUI["archyTowerIcon3"]
			bIsUnit = false
			bIsBaseTower = false
			
			if (pageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[3]
			elseif (pageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[3]
			elseif (pageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[3]
			end
		end
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--其它塔的选中框灰掉
		if (button ~= _frmNode.childUI["BaseTowerIcon"]) then
			_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
		end
		if (button ~= _frmNode.childUI["mediumTowerIcon"]) then
			_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
		end
		for i = 1, 3, 1 do
			if (button ~= _frmNode.childUI["archyTowerIcon" .. i]) then
				_frmNode.childUI["archyTowerIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		
		--塔的等级
		local towerLv = 0 --等级
		
		--显示塔的名称和说明
		local towerName = "" --塔的名字
		local towerIntro = "" --塔的简介
		local szTowerLv = "" --塔的等级文字描述
		local towerLvColor = nil --塔的等级文字的颜色
		if bIsUnit then --是单位
			--显示单位的名字
			towerName = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][1] or ("未知塔" .. cardId)
			
			--不显示等级文字
			szTowerLv = ""
			towerLvColor = ccc3(255, 255, 0) --橙色
			
			--显示单位的简介
			towerIntro = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][2] or ("未知单位说明" .. cardId)
		else --是塔类战术技能卡
			if (cardId ~= 0) then --已开放的塔类战术技能卡分支
				--显示塔类战术技能卡的名字
				towerName = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				
				--显示塔类战术技能卡的简介
				local tTactics = LuaGetPlayerSkillBook()
				if tTactics then
					for i = 1,#tTactics, 1 do
						if type(tTactics[i])=="table" then
							local id, lv, num = unpack(tTactics[i])
							
							--是否一致
							if (id == cardId) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerLv) then
									towerLv = lv
								end
							end
						end
					end
				end
				
				local showTowerLv = towerLv --显示文字的塔的等级
				if (showTowerLv == 0) then
					showTowerLv = 1
				end
				--显示不超过最大等级
				local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
				if (showTowerLv > maxLv) then
					showTowerLv = maxLv
				end
				if (towerLv > 0) then --已获得的塔
					--szTowerLv = showTowerLv .. "级" --language
					szTowerLv = showTowerLv .. hVar.tab_string["__TEXT_ji"] --language
					towerLvColor = ccc3(255, 255, 128) --黄色
				else --未获得的塔
					--szTowerLv = "未获得" --language
					szTowerLv = hVar.tab_string["CurrentNotGet"] --language
					towerLvColor = ccc3(255, 0, 0) --红色
				end
				
				towerIntro = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][showTowerLv + 1] or ("未知战术技能卡说明" .. cardId)
			else --还未开放的战术技能卡分支
				--未开放的战术技能卡的名字
				towerName = ""
				
				--未开放的战术技能卡的等级
				szTowerLv = ""
				towerLvColor = ccc3(255, 255, 0) --橙色
				
				--未开放的战术技能卡的简介
				towerIntro = ""
			end
		end
		
		--更新说明
		_frmNode.childUI["TowerNameLabel"]:setText(towerName)
		_frmNode.childUI["TowerLvLabel"]:setText(szTowerLv)
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(towerLvColor)
		_frmNode.childUI["TowerIntroLabel"]:setText(towerIntro)
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔的单位
		local towerUnitId = cardId --塔的单位的类型id
		if (not bIsUnit)and (cardId ~= 0) then
			if (towerLv == 0) then
				towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[1][1]
			else
				towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv][1]
			end
		end
		
		--print("towerUnitId", towerUnitId, towerLv)
		
		--第一个文字的偏移值
		local FONT_OFFSET_X = 435 --第一个文字的偏移值x
		local FONT_UNIT_DX = 0 --单位类型的塔的额外偏移值x
		local FONT_LV0_DX = 0 --0级塔的额外偏移值x
		if bIsUnit then
			FONT_UNIT_DX = 90
		elseif (towerLv <= 0) then
			FONT_LV0_DX = 90
		end
		local FONT_OFFSET_Y = -80 --第一个文字的偏移值y
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--读取塔单位的属性
		if (cardId ~= 0) then --已解锁的塔
			local attr = hVar.tab_unit[towerUnitId].attr --属性表
			local atk_min = attr.attack[4] --最小攻击力
			local atk_max = attr.attack[5] --最大攻击力
			local atk_speed = attr.atk_interval --攻击速度
			local atk_range = attr.atk_radius --射程
			
			local atkSpeed = atk_speed / 1000
			local divValue = math.floor(atkSpeed)
			local modValue = (atkSpeed - divValue) * 100
			local szAtkSpeed = ("%d.%s"):format(divValue, tostring(modValue)) --保留2位小数
			
			--显示“攻击”文字
			_frmNode.childUI["AtkPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻击", --language
				text = hVar.tab_string["__Attr_Hint_atk"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkPrefix"
			
			--显示攻击力
			local atkValueTotal = atk_min .. "-" .. atk_max
			if (atk_min == atk_max) then --如果两个攻击力一样大，那么合并
				atkValueTotal = tostring(atk_min)
			end
			local atkSize = 24
			if (#atkValueTotal > 6) then --如果攻击力文字过长，缩小字体
				atkSize = 20
			end
			_frmNode.childUI["AtkValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70,
				y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
				size = atkSize,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = atkValueTotal,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkValue"
			
			--显示“攻速”文字
			_frmNode.childUI["AtkSpeedPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y - FONT_DELTA_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻速", --language
				text = hVar.tab_string["__Attr_Speed"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedPrefix"
			
			--显示攻击速度
			_frmNode.childUI["AtkSpeedValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70,
				y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = szAtkSpeed,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedValue"
			
			--显示“射程”文字
			_frmNode.childUI["AtkRangePrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "射程", --language
				text = hVar.tab_string["__Attr_Atk_Range"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangePrefix"
			
			--显示射程
			_frmNode.childUI["AtkRangeValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = atk_range,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeValue"
			
			--显示分割线1
			_frmNode.childUI["SeparateLine1"] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SeparateLine",
				x = FONT_OFFSET_X + 172,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 45,
				w = 364,
				h = 4,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine1"
			
			--分支：基础塔显示基本描述，战术技能卡显示技能和升级按钮
			if bIsUnit then --是基础塔
				--基础塔，显示一些辅助信息
				if bIsBaseTower then --最初级的塔
					--显示最初始的塔的辅助信息
					_frmNode.childUI["BaseTowerHint"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 10,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 120,
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						width = 330,
						--text = "最初始的塔，可在游戏局中通过塔基建造。", --language
						text = hVar.tab_string["Tower_Base_Intro"], --language
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "BaseTowerHint"
				else --第一次升级后的塔
					--显示最初始的塔的辅助信息
					_frmNode.childUI["BaseTowerHint"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 10,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 120,
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						width = 330,
						--text = "在游戏局中通过初始塔升级而成，并可选择某个分支再次升级。（需要在游戏中携带该分支的卡牌）", --language
						text = hVar.tab_string["Tower_Medium_Intro"], --language
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "BaseTowerHint"
				end
			else --是战术技能卡塔
				--显示下一级塔的属性
				local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
				
				--如果该塔不是0级才显示下一级的属性
				--print(towerLv)
				if (towerLv > 0) then
					local next_font = nil --下一级的文字字体
					local next_color = nil --下一级的文字颜色
					local next_szAtk = nil --攻击力
					local next_szAtkSpeed = nil --攻击速度
					local next_atk_range = nil --射程
					
					--print("towerLv=", towerLv, "towerLvMax=", towerLvMax)
					if (towerLv >= towerLvMax) then --塔已升到顶级
						next_font = hVar.FONTC --下一级的文字字体
						next_color = ccc3(255, 64, 0) --下一级的文字颜色
						--next_szAtk = "已到顶级" --攻击力 --language
						--next_szAtkSpeed = "已到顶级" --攻击速度 --language
						--next_atk_range = "已到顶级" --射程 --language
						next_szAtk = hVar.tab_string["UpToMaxLv"] --攻击力 --language
						next_szAtkSpeed = hVar.tab_string["UpToMaxLv"] --攻击速度 --language
						next_atk_range = hVar.tab_string["UpToMaxLv"] --射程 --language
					else
						--读取下一级塔单位的属性
						local next_towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1]
						next_font = "numWhite" --下一级的文字字体
						next_color = ccc3(0, 255, 0) --下一级的文字颜色
						next_szAtk = "?-?" --攻击力
						next_szAtkSpeed = "?" --攻击速度
						next_atk_range = "?" --射程
						
						local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
						
						if tUnit then
							local next_attr = tUnit.attr --属性表
							local next_atk_min = next_attr.attack[4] --最小攻击力
							local next_atk_max = next_attr.attack[5] --最大攻击力
							local next_atk_speed = next_attr.atk_interval --攻击速度
							next_szAtk = next_atk_min .. "-" .. next_atk_max
							if (next_atk_min == next_atk_max) then --如果下一级两个攻击力一样大，那么合并
								next_szAtk = tostring(next_atk_min)
							end
							next_atk_range = next_attr.atk_radius --射程
							
							local next_atkSpeed = next_atk_speed / 1000
							local next_divValue = math.floor(next_atkSpeed)
							local next_modValue = (next_atkSpeed - next_divValue) * 100
							next_szAtkSpeed = ("%d.%s"):format(next_divValue, tostring(next_modValue)) --保留2位小数
						end
					end
					
					--显示“攻击”的箭头
					_frmNode.childUI["AtkJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkJianTou"
					
					--显示“攻速”的箭头
					_frmNode.childUI["AtkSpeedJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedJianTou"
					
					--显示“射程”的箭头
					_frmNode.childUI["AtkRangeJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeJianTou"
					
					--显示下一级攻击力
					local next_atkSize = 24
					local next_atkShowBorder = 0
					if (#next_szAtk > 6) then --如果下一级攻击力文字过长，缩小字体
						next_atkSize = 20
					end
					if (towerLv >= towerLvMax) then --塔已升到顶级
						next_atkSize = 24 --这里是中文，可以显示的下
						next_atkShowBorder = 1
					end
					
					_frmNode.childUI["AtkNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
						size = next_atkSize,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_szAtk,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkNextValue"
					
					--显示下一级攻击速度
					_frmNode.childUI["AtkSpeedNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
						size = 24,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_szAtkSpeed,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkSpeedNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedNextValue"
					
					--显示下一级攻击射程
					_frmNode.childUI["AtkRangeNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
						size = 24,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_atk_range,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkRangeNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeNextValue"
				end
				
				--显示塔的技能
				local order = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill.order --塔的技能列表
				for i = 1, #order, 1 do
					--响应技能点击事件的按钮区域
					local skill_id = order[i] --技能id
					_frmNode.childUI["SkillButton" .. i] = hUI.button:new({
						parent = _parentNode,
						model = "misc/mask.png",
						x = FONT_OFFSET_X + 160,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
						w = 360,
						h = 68,
						dragbox = _frm.childUI["dragBox"],
						scaleT = 1.00,
						codeOnTouch = function(self, screenX, screenY, isInside)
							--显示塔的技能说明
							OnCreateSkillTipFrame(towerUnitId, skill_id, i)
						end,
					})
					_frmNode.childUI["SkillButton" .. i].handle.s:setOpacity(0) --用于响应点击事件，不显示
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillButton" .. i
					
					--创建技能图标
					_frmNode.childUI["SkillIcon" .. i] = hUI.image:new({
						parent = _parentNode,
						model = hVar.tab_skill[skill_id].icon,
						x = FONT_OFFSET_X + FONT_LV0_DX + 32,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
						w = 64,
						h = 64,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillIcon" .. i
					
					--创建技能选中框
					local Scale0 = 64 / 70
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"] = hUI.image:new({
						parent = _frmNode.childUI["SkillIcon" .. i].handle._n,
						model = "UI:Tactic_Selected",
						x = 32,
						y = 32,
						scale = Scale0,
					})
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
					local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
					local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:runAction(forever)
					
					--创建技能名称
					_frmNode.childUI["SkillName" .. i] = hUI.label:new({
						parent = _parentNode,
						size = 26,
						x = FONT_OFFSET_X + FONT_LV0_DX + 75,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 85 - (i - 1) * 72,
						w = 300,
						align = "LC",
						font = hVar.FONTC,
						text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillName" .. i
					
					--创建当前技能的卡槽背景框
					_frmNode.childUI["SlotBG" .. i] = hUI.image:new({
						parent = _parentNode,
						model = "UI:Tactic_SlotBG",
						x = FONT_OFFSET_X + FONT_LV0_DX + 110,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 70,
						h = 14,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBG" .. i
					
					--创建本技能可以升级到的卡槽的数量
					local slotNum = 0
					local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if tab then
						if tab.isUnlock then
							slotNum = tab.maxLv
						end
					end
					
					for slot = 1, slotNum, 1 do
						--创建当前技能的单个卡槽条
						_frmNode.childUI["Slot" .. i .. slot] = hUI.image:new({
							parent = _parentNode,
							model = "UI:Tactic_Slot",
							x = FONT_OFFSET_X + FONT_LV0_DX + 110 + (slot - 1) * 13 - 26,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 11,
							h = 10,
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "Slot" .. i .. slot
					end
				end
				
				--如果该塔不是0级，才显示下一级的技能信息
				if (towerLv <= 0) then --0级
					--
				elseif (towerLv >= towerLvMax) then --已到顶级
					for i = 1, #order, 1 do
						--显示“下一级技能”的箭头
						_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
							parent = _parentNode,
							x = FONT_OFFSET_X + 210,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 30,
							h = 20,
							model = "UI:Tactic_RPointer",
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
						
						--显示已升到顶级的文字
						_frmNode.childUI["SkillToTopLabel" .. i] = hUI.label:new({
							parent = _parentNode,
							x = FONT_OFFSET_X + 250,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 300,
							align = "LC",
							font = hVar.FONTC,
							--text = "已到顶级", --language
							text = hVar.tab_string["UpToMaxLv"], --language
							border = 1,
						})
						_frmNode.childUI["SkillToTopLabel" .. i].handle.s:setColor(ccc3(255, 64, 0))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillToTopLabel" .. i
					end
				else --有下一级的技能
					local next_towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1]
					local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
					if tUnit then
						local next_order = tUnit.td_upgrade.upgradeSkill.order --下一级塔的技能列表
						for i = 1, #next_order, 1 do
							local skill_id = next_order[i] --技能id
							
							--显示“下一级技能”的箭头
							_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
								parent = _parentNode,
								x = FONT_OFFSET_X + 210,
								y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
								w = 30,
								h = 20,
								model = "UI:Tactic_RPointer",
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
							
							--创建下一级技能的卡槽背景框
							_frmNode.childUI["SlotBGNext" .. i] = hUI.image:new({
								parent = _parentNode,
								model = "UI:Tactic_SlotBG",
								x = FONT_OFFSET_X + FONT_LV0_DX + 290,
								y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
								w = 70,
								h = 14,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBGNext" .. i
							
							--创建下一级技能可以升级到的卡槽的数量
							local next_slotNum = 0
							local next_tab = hVar.tab_unit[next_towerUnitId].td_upgrade.upgradeSkill[skill_id]
							if next_tab then
								if next_tab.isUnlock then
									next_slotNum = next_tab.maxLv
								end
							end
							
							--本次的数量（用于对比）
							local slotNum = 0
							local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
							if tab then
								if tab.isUnlock then
									slotNum = tab.maxLv
								end
							end
							for slot = 1, next_slotNum, 1 do
								--创建下一级技能的单个卡槽条
								_frmNode.childUI["SlotNext" .. i .. slot] = hUI.image:new({
									parent = _parentNode,
									model = "UI:Tactic_Slot",
									x = FONT_OFFSET_X + FONT_LV0_DX + 290 + (slot - 1) * 13 - 26,
									y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
									w = 11,
									h = 10,
								})
								if (slot > slotNum) then
									_frmNode.childUI["SlotNext" .. i .. slot].handle.s:setColor(ccc3(0, 255, 0))
								end
								rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotNext" .. i .. slot
							end
						end
					end
				end
				
				--显示分割线2
				_frmNode.childUI["SeparateLine2"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_SeparateLine",
					x = FONT_OFFSET_X + 172,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 230,
					w = 364,
					h = 4,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine2"
				
				--升级塔需要的碎片数量
				--local towerLv = 0 --等级
				local costDebris = 0 --需要的碎片数量
				local nowDebris = 0 --当前的碎片数量
				local costScore = 0 --需要的积分
				local nowScore = LuaGetPlayerScore() --当前的积分
				local itemId = 0 --商品道具id
				local tacticInfo = LuaGetPlayerTacticById(cardId)
				if tacticInfo then
					local id, lv, num = unpack(tacticInfo)
					nowDebris = num --当前的碎片数量
				end
				
				--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
				--if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
					local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
					costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
					local shopItemId = tacticLvUpInfo.shopItemId or 0
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					if tabShopItem then
						--costRmb = tabShopItem.rmb or 0
						costScore = tabShopItem.score or 0 --需要的积分
						itemId = tabShopItem.itemID or 0 --商品道具id
					end
				--else --到顶级了
					--
				--end
				
				--升级需要的塔卡图标
				_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
					parent = _parentNode,
					model = hVar.tab_tactics[cardId].icon,
					x = FONT_OFFSET_X + 30,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 36,
					h = 36,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
				
				--碎片图标
				_frmNode.childUI["DebrisIcon"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:SoulStoneFlag",
					x = FONT_OFFSET_X + 39,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
					w = 30,
					h = 40,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
				
				--碎片进度条
				local progressV = nowDebris / costDebris * 100 --进度
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					progressV = 0
				end
				_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 55,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
					w = 150,
					h = 25,
					align = "LC",
					back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
					model = "UI:SoulStoneBar1",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
				
				--创建一个进度条满了的特别进度条
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
						parent = _parentNode,
						model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
						x = FONT_OFFSET_X + 55 + (150) / 2,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
						w = 150,
						h = 25,
						align = "LC",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
				end
				
				--塔类卡牌
				--升级需要的碎片的数量文字
				local showNumText = nowDebris .. "/" .. costDebris
				local towerFont = "numWhite"
				local towerColor = ccc3(255, 255, 255)
				local towerBorder = 0
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					--showNumText = "无" --language
					--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
					--towerFont = hVar.FONTC
					towerColor = ccc3(255, 64, 0)
					--towerBorder = 1
				end
				
				--local showNumText = "49999/500000"
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
				_frmNode.childUI["DebrisNum"] = hUI.label:new({
					parent = _parentNode,
					size = 24,
					x = FONT_OFFSET_X + 128,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
					w = 300,
					align = "MC",
					font = towerFont,
					text = showNumText,
					border = towerBorder,
					scale = scaleText,
				})
				_frmNode.childUI["DebrisNum"].handle.s:setColor(towerColor)
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
				
				--升级需要的积分图标
				_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:score",
					x = FONT_OFFSET_X + 260,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 32,
					h = 32,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
				
				--塔类卡牌
				--升级需要的积分的数量文字
				local showJFText = tostring(costScore)
				local JFFont = "numWhite"
				local JFColor = ccc3(255, 255, 255)
				local JFBorder = 0
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					showJFText = "无" --language
					showJFText = hVar.tab_string["__TEXT_Nothing"] --language
					JFFont = hVar.FONTC
					--showJFText = "N/A"
					JFColor = ccc3(255, 64, 0)
					JFBorder = 1
				end
				--local showJFText = "499999"
				local scaleJFText = 1.0
				local showJFTextLength = #showJFText
				if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
					scaleJFText = 0.7
				elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
					scaleJFText = 0.8
				elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
					scaleJFText = 0.9
				else --可以显示下
					scaleJFText = 1.0
				end
				_frmNode.childUI["ScoreNum"] = hUI.label:new({
					parent = _parentNode,
					size = 24,
					x = FONT_OFFSET_X + 280,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
					w = 300,
					align = "LC",
					font = JFFont,
					text = showJFText,
					border = JFBorder,
					scale = scaleJFText
				})
				_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
				
				--事件响应控件
				--碎片用于点击的区域
				_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
					parent = _parentNode,
					model = "misc/mask.png",
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 110,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 220,
					h = 68,
					scaleT = 1.0,
					--[[
					failcall = 1,
					
					--按下碎片图标区域事件，显示碎片说明
					codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
						local __parent = _frmNode.childUI["RequireCardTouchBtn"]
						local __parentHandle = __parent.handle._n
						local offset = 75
						local yOffset = 100
						
						--选中框
						__parent.childUI["box"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:Tactic_Selected",
							x = -80,
							y = 0,
							w = 36,
							h = 36,
							align = "MC",
						})
						
						--技能背景框
						__parent.childUI["imgBg"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:TacticBG", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 380,
							h = 110,
							align = "MC",
						})
						__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
						
						--图标
						__parent.childUI["imgIcon"] = hUI.image:new({
							parent = __parentHandle,
							model = hVar.tab_tactics[cardId].icon,
							x = offset - 148,
							y = yOffset - 2,
							w = 64,
							h = 64,
							align = "MC",
						})
						
						--碎片图标
						__parent.childUI["imgSoleStone"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:SoulStoneFlag",
							x = offset - 148 + 20,
							y = yOffset - 17,
							w = 40,
							h = 54,
							align = "MC",
						})
						
						--碎片名称
						local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
						__parent.childUI["labName"] = hUI.label:new({
							parent = __parentHandle,
							size = 30,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 43,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							--text = name .. "碎片", --language
							text = name .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
						})
						__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
						
						--碎片介绍
						--local intro = "升级" .. name .. "需要消耗一定数量的该碎片。"
						local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeDebris"] --language
						__parent.childUI["labIntro"] = hUI.label:new({
							parent = __parentHandle,
							size = 26,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 8,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							text = intro,
						})
						__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
					end,
					
					--抬起碎片图标区域事件，删除该战术技能卡的说明
					code = function(self)
						local __parent = _frmNode.childUI["RequireCardTouchBtn"]
						hApi.safeRemoveT(__parent.childUI, "box") --选中框
						hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
						hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
						hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
						hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
					end,
					]]
					--抬起碎片图标区域事件，删除该战术技能卡的说明
					code = function(self)
						--显示战术技能卡的tip
						local rewardType = 6 --碎片类型
						local tacticLv = 1
						hApi.ShowTacticCardTip(rewardType, cardId, tacticLv, cardId)
					end,
				})
				_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --用于响应点击事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
				
				--事件响应控件
				--积分用于点击的区域
				_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
					parent = _parentNode,
					model = "misc/mask.png",
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 310,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 160,
					h = 68,
					scaleT = 1.0,
					--[[
					failcall = 1,
					
					--按下积分图标区域事件，显示碎片说明
					codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
						local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
						local __parentHandle = __parent.handle._n
						local offset = -125
						local yOffset = 100
						
						--选中框
						__parent.childUI["box"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:Tactic_Selected",
							x = -50,
							y = 0,
							w = 36,
							h = 36,
							align = "MC",
						})
						
						--技能背景框
						__parent.childUI["imgBg"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:TacticBG", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 380,
							h = 110,
							align = "MC",
						})
						__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
						
						--图标
						__parent.childUI["imgIcon"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:score",
							x = offset - 148,
							y = yOffset - 2,
							w = 64,
							h = 64,
							align = "MC",
						})
						
						--积分名称
						__parent.childUI["labName"] = hUI.label:new({
							parent = __parentHandle,
							size = 30,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 43,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							--text = "积分", --language
							text = hVar.tab_string["ios_score"], --language
						})
						__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
						
						--积分介绍
						local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
						--local intro = "升级" .. name .. "需要消耗一定数量的积分。" --language
						local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeJiFen"] --language
						__parent.childUI["labIntro"] = hUI.label:new({
							parent = __parentHandle,
							size = 26,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 8,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							text = intro,
						})
						__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
					end,
					
					--抬起积分图标区域事件，删除该战术技能卡的说明
					code = function(self)
						local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
						hApi.safeRemoveT(__parent.childUI, "box") --选中框
						hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
						hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
						hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
					end,
					]]
					--抬起积分图标区域事件，删除该战术技能卡的说明
					code = function(self)
						--显示积分介绍的tip
						hApi.ShowJiFennTip()
					end,
				})
				_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
				
				--塔类卡牌的升级按钮
				--升级或者解锁塔的按钮
				local updateText = hVar.tab_string["__UPGRADE"]
				if (towerLv == 0) then
					updateText = hVar.tab_string["__UNLOCK"]
				end
				_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
					parent = _parentNode,
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 180,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 340,
					w = 160,
					h = 50,
					label = updateText,
					font = hVar.FONTC,
					border = 1,
					model = "UI:BTN_ButtonRed",
					animation = "normal",
					scaleT = 0.95,
					scale = 1.0,
					code = function()
						--点击用积分升级塔按钮
						if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔未到顶级
							OnClickLvUpButton(cardId, towerLv, costDebris, nowDebris, costScore, nowScore, itemId)
						end
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔已到顶级
					_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
				end
				
				--积分升级按钮的升级小箭头
				_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
					parent = _frmNode.childUI["btnCostJiFen"].handle._n,
					model = "UI:UI_Arrow",
					scale = 0.7,
					roll = 90,
					x = 90,
				})
				_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
				
				--如果不符合升级的条件，按钮灰掉
				if (nowDebris < costDebris) or (nowScore < costScore) or (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
					hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
					hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
				end
				
				--...
			end
		else --未解锁的战术技能卡
			--显示未解锁塔的辅助信息
			_frmNode.childUI["UnlockHint"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 60,
				y = -278,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 330,
				text = "该分支塔暂未开放。",
				border = 1,
			})
			_frmNode.childUI["UnlockHint"].handle.s:setColor(ccc3(255, 0, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "UnlockHint"
		end
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
	end
	
	--函数：查看塔的技能说明tip
	OnCreateSkillTipFrame = function(towerUnitId, skill_id, skillIdx)
		--先清除上一次塔的技能说明面板
		if hGlobal.UI.TacticSkillInfoFram then
			hGlobal.UI.TacticSkillInfoFram:del()
		end
		
		--显示塔的技能的选中框
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		_frmNode.childUI["SkillIcon" .. skillIdx].childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--创建技能说明面板
		hGlobal.UI.TacticSkillInfoFram = hUI.frame:new({
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
			background = -1, --无底图
			border = 0, --无边框
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.TacticSkillInfoFram:del()
					--hGlobal.UI.TacticSkillInfoFram = nil
					--print("点击事件（有可能在控件外部点击）")
					--隐藏技能选中框
					_frmNode.childUI["SkillIcon" .. skillIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.TacticSkillInfoFram:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		--本技能可以升级到的技能次数
		local slotNum = 0
		local cost = nil --消耗的金币
		local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
		if tab then
			if tab.isUnlock then
				slotNum = tab.maxLv
			end
			cost = tab.cost
		end
		
		local _SkillParent = hGlobal.UI.TacticSkillInfoFram.handle._n
		local _SkillChildUI = hGlobal.UI.TacticSkillInfoFram.childUI
		local _offX = BOARD_POS_X + 200
		local _offY = BOARD_POS_Y - 40
		
		--创建技能tip图片背景
		_SkillChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 460,
			h = 580,
		})
		_SkillChildUI["ItemBG_1"].handle.s:setOpacity(232) --技能背景图片透明度为232
		
		--创建技能tip-技能图标
		--print(hVar.tab_skill[skill_id].icon)
		_SkillChildUI["SkillIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = hVar.tab_skill[skill_id].icon,
			x = _offX - 180,
			y = _offY + 15,
			w = 56,
			h = 56,
		})
		
		--创建技能tip-技能名称
		_SkillChildUI["SkillName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 145,
			y = _offY + 15 - 3,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
			border = 1,
		})
		
		--绘制现在已有的效果前缀
		_SkillChildUI["SkillLv0"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 150,
			y = _offY - 25,
			width = 120,
			align = "MT",
			font = hVar.FONTC,
			--text = "技能升级后效果", --language
			text = hVar.tab_string["SkillUpgrateEffect"], --language
			border = 1,
		})
		_SkillChildUI["SkillLv0"].handle.s:setColor(ccc3(0, 255, 0))
		
		--创建技能tip初始等级的效果
		_SkillChildUI["SkillIntro0"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 60,
			y = _offY - 25,
			width = 280,
			align = "LT",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skill_id][2],
			border = 1,
		})
		_SkillChildUI["SkillIntro0"].handle.s:setColor(ccc3(0, 255, 0))
		
		
		--创建技能tip最高可升级的次数
		--local showCountsText = "游戏局中最高可升级" .. slotNum .. "次" --language
		local showCountsText = hVar.tab_string["InBattle"] .. hVar.tab_string["CanLvUpMax"] .. slotNum .. hVar.tab_string["__TEXT_YouCanForgedCount1"] --language
		if (slotNum == 0) then
			--showCountsText = "游戏局中未解锁升级该技能" --language
			showCountsText = hVar.tab_string["InBattle"] .. hVar.tab_string["CanNotLvUp"]  .. hVar.tab_string["ThisSkill"] --language
		end
		_SkillChildUI["SkillCounts"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 210,
			y = _offY - 200,
			width = 500,
			align = "LC",
			font = hVar.FONTC,
			text = showCountsText,
			border = 1,
		})
		if (slotNum > 0) then
			_SkillChildUI["SkillCounts"].handle.s:setColor(ccc3(0, 255, 255))
		else
			_SkillChildUI["SkillCounts"].handle.s:setColor(ccc3(255, 0, 0))
		end
		
		--依次绘制每一级的效果
		local skill_maxlv = 0 --最大等级
		if hVar.tab_stringS[skill_id] then
			skill_maxlv = #hVar.tab_stringS[skill_id] - 2 --第一个是技能名，第二个是技能总体描述
		end
		for i = 1, skill_maxlv, 1 do
			--创建技能tip每个等级
			_SkillChildUI["SkillLv" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 180,
				y = _offY - 225 - (i - 1) * 60,
				width = 80,
				align = "MT",
				font = hVar.FONTC,
				--text = "第" .. i .. "次升级", --language
				text = hVar.tab_string["__TEXT_WORD_DI"] .. i .. hVar.tab_string["__TEXT_YouCanForgedCount1"] .. hVar.tab_string["__UPGRADE"], --language
				border = 1,
			})
			if (i > slotNum) then --未解锁的技能等级
				_SkillChildUI["SkillLv" .. i].handle.s:setColor(ccc3(64, 64, 64))
			else
				_SkillChildUI["SkillLv" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个金币图标
			_SkillChildUI["SkillGoldIcon" .. i] = hUI.image:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 107 + 1,
				y = _offY - 241 - (i - 1) * 60,
				scale = 0.45,
				model = "ui/res_money.png",
			})
			if (i > slotNum) then --未解锁的技能等级
				_SkillChildUI["SkillGoldIcon" .. i].handle.s:setColor(ccc3(64, 64, 64))
				--hApi.AddShader(_SkillChildUI["SkillGoldIcon" .. i].handle.s,"gray")
				--_SkillChildUI["SkillGoldIcon" .. i].handle.s:setOpacity(0)
			else
				--_SkillChildUI["SkillGoldIcon" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个等级的升级需要金钱
			local strShowGoldValue = cost[i]
			if (i > slotNum) then --未解锁的技能等级的详细效果
				strShowGoldValue = "--"
			end
			_SkillChildUI["SkillGoldValue" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 14,
				x = _offX - 107,
				y = _offY - 253 - (i - 1) * 60,
				width = 500,
				align = "MT",
				font = "numWhite",
				text = strShowGoldValue,
				border = 0,
			})
			if (i > slotNum) then --未解锁的技能等级的详细效果
				_SkillChildUI["SkillGoldValue" .. i].handle.s:setColor(ccc3(64, 64, 0))
			else
				_SkillChildUI["SkillGoldValue" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个等级的详细效果
			_SkillChildUI["SkillIntro" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 60,
				y = _offY - 225 - (i - 1) * 60,
				width = 280,
				align = "LT",
				font = hVar.FONTC,
				text = hVar.tab_stringS[skill_id][i + 2],
				border = 1,
			})
			if (i > slotNum) then --未解锁的技能等级的详细效果
				_SkillChildUI["SkillIntro" .. i].handle.s:setColor(ccc3(64, 64, 64))
			else
				_SkillChildUI["SkillIntro" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
		end
	end
	
	--函数：点击战术技能卡升级按钮
	OnClickLvUpButton = function(tacticId, tacticLv, costDebris, nowDebris, costScore, nowScore, itemId)
		local errorMsg = "" --失败的原因
		local bEnableUpdate = true --是否可以升级
		
		if (g_cur_net_state == -1) then --未联网模式
			errorMsg = hVar.tab_string["__TEXT_Cant'UseDepletion4_Net"]
			bEnableUpdate = false
		elseif (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --战术技能卡升到顶级
			errorMsg = hVar.tab_string["__UPGRADEBFSKILL_CANT"]
			bEnableUpdate = false
		elseif (nowDebris < costDebris) then --碎片不足
			errorMsg = hVar.tab_string["tactic_lessDebris"]
			bEnableUpdate = false
		elseif (nowScore < costScore) then --积分不足
			errorMsg = hVar.tab_string["__TEXT_ScoreNotEnough"]
			bEnableUpdate = false
		end
		
		if (not bEnableUpdate) then --不能升级
			hGlobal.UI.MsgBox(errorMsg, {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
		else --可以升级
			hUI.NetDisable(30000)
			--发送扣费请求
			local strTag = "ci:" .. tacticId .. ";cd:" .. costDebris ..";sc:".. costScore .. ";"
			SendCmdFunc["order_begin"](6, itemId, 0, 1, hVar.tab_stringI[itemId][1], costScore, 0, strTag)
		end
	end
	
	--函数：创建单个特殊塔控件
	OnCreateSingleSpecialCard = function(pageIndex, index, tacticId, tacticHashList)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % SPECIAL_X_NUM) --xi
		if (xi == 0) then
			xi = SPECIAL_X_NUM
		end
		local yi = (index - xi) / SPECIAL_X_NUM + 1 --yi
		local tacticLv = 0 --特殊塔卡等级
		local tacticDebrisNum = 0 --特殊塔卡碎片的数量
		
		if tacticHashList[tacticId] then
			tacticLv = tacticHashList[tacticId].skillLV
			tacticDebrisNum = tacticHashList[tacticId].num
			
			--显示不超过最大等级
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (tacticLv > maxLv) then
				tacticLv = maxLv
			end
		end
		
		--特殊塔控件
		local qLv = math.min((hVar.tab_tactics[tacticId].quality or 1), 4) --图片最多只有4张
		_frmNode.childUI["SpecialCard" .. index] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_Special,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"],
			model = "UI:slotBig", --"UI:tactic_card_" .. qLv,
			x = SPECIAL_CARD_OSSSET_XL + (xi - 1) *  SPECIAL_CARD_DISTANCE_X,
			y = SPECIAL_CARD_OSSSET_Y - (yi - 1) * SPECIAL_CARD_DISTANCE_Y + 2,
			w = SPECIAL_CARD_WIDTH,
			h = SPECIAL_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
			--	--点击战术技能卡按钮
			--	OnClickTacticBtn(pageIndex, index)
			--end,
		})
		_frmNode.childUI["SpecialCard" .. index].data.tacticId = tacticId --存储战术技能卡id
		_frmNode.childUI["SpecialCard" .. index].data.tacticLv = tacticLv --存储战术技能卡等级
		_frmNode.childUI["SpecialCard" .. index].data.tacticDebrisNum = tacticDebrisNum --存储战术技能卡碎片数量
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialCard" .. index
		
		local button = _frmNode.childUI["SpecialCard" .. index]
		local BTN_EDGE = 64 --按钮的边长
		--[[
		--战术技能卡类型图标
		button.childUI["typeicon"] = hUI.image:new({
			parent = button.handle._n,
			model = hApi.GetTacticsCardTypeIcon(tacticId, "model"),
			x = -2,
			y = 37,
			w = 26,
			h = 26,
		})
		--button.childUI["typeicon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		]]
		
		--特殊塔图标
		button.childUI["skillIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 10,
			w = BTN_EDGE,
			h = BTN_EDGE,
		})
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--特殊塔碎片经验条
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -32,
			y = -32,
			w = SPECIAL_CARD_WIDTH - 14,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = SPECIAL_CARD_WIDTH - 10, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = 100,
			max = 100,
		})
		
		--特殊塔碎片所需经验显示
		button.childUI["labSoulStoneExp"] = hUI.label:new({
			parent = button.handle._n,
			size = 26,
			align = "MC",
			--font = hVar.FONTC,
			font = hVar.DEFAULT_FONT,
			x = 0,
			y = -35,
			text = "", --"NA", --geyachao: 这里不显示等级文字了
		})
		
		--碎片可以升级的箭头提示
		--特殊塔升级的动态箭头
		button.childUI["tacticSoulStonejianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 18,
			y = -5,
			w = 26, --236
			h = 26, --146
			align = "MC",
		})
		--_frm.childUI["tacticSoulStonejianTou"].handle._n:setRotation(0)
		button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
		
		--特殊塔按钮选中框
		local scaleX = (SPECIAL_CARD_WIDTH + 4) / 72
		local scaleY = (SPECIAL_CARD_HEIGHT + 6) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame", --"UI:PHOTO_FRAME_BAR",
			align = "MC",
			x = 0,
			y = 0,
			w = SPECIAL_CARD_WIDTH + 4,
			h = SPECIAL_CARD_HEIGHT + 6,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)

		--特殊塔的等级背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = BTN_EDGE - 38,
			y = 38,
			w = 34,
			h = 34,
		})
		
		--特殊塔的等级
		local fontSize = 26
		if tacticLv and (tacticLv >= 10) then --如果等级是2位数的，那么缩一下文字
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = BTN_EDGE - 38,
			y = 37,
			text = tacticLv,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		local lvNow = tacticLv or 0
		if (lvNow >= maxLv) then
			lvNow = maxLv
		end
		local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
		local costScore = 0 --需要的积分
		local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			costScore = tabShopItem.score or 0 --需要的积分
		end
		
		--未获得特殊塔
		if (lvNow <= 0) then
			hApi.AddShader(button.handle.s,"gray")
			hApi.AddShader(button.childUI["skillIcon"].handle.s,"gray")
			--hApi.AddShader(button.childUI["typeicon"].handle.s,"gray")
			button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
			--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
			
			--可升级的提示
			if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
			else
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
			end
		else
			if (lvNow >= maxLv) then --战术技能卡已到顶级
				button.childUI["barSoulStoneExp"]:setV(0, 100)
				--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
				
				--不能升级的提示
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				
				--创建一个进度条满了的特别进度条
				button.childUI["tacticMaxLvProgressImg"] = hUI.image:new({
					parent = button.handle._n,
					model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
					x = -32 + (SPECIAL_CARD_WIDTH - 14) / 2,
					y = -32,
					w = SPECIAL_CARD_WIDTH - 14,
					h = 15, --146
					align = "MC",
				})
			else --还可以升级
				button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
				--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
				else
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				end
			end
		end
	end
	
	--函数：创建特殊塔的升级图界面（第4个分页）
	OnCreateSpecialDiagramFrame = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Special", 1)
		
		--[[
		--特殊塔暂未开放
		_frmNode.childUI["SpecialNotOpenLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PAGE_BTN_LEFT_X + 285,
			y = PAGE_BTN_LEFT_Y - 210,
			size = 28,
			font = hVar.FONTC,
			align = "MT",
			width = 700,
			--text = "解锁更多关卡后，将有几率获特殊战术卡和塔。", --language
			text = hVar.tab_string["SpecialTacticIntro"], --language
			border = 1,
		})
		_frmNode.childUI["SpecialNotOpenLabel"].handle.s:setColor(ccc3(255, 128, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialNotOpenLabel"
		]]
		
		--左侧特殊塔列表底板
		_frmNode.childUI["SpecialListBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = SPECIAL_CARD_OSSSET_XL + 135,
			y = SPECIAL_CARD_OSSSET_Y - 101,
			w = 375 + 4,
			h = SPECIAL_PANEL_HEIGHT + 2 + 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialListBG2"
		
		--左侧特殊塔列表底板
		_frmNode.childUI["SpecialListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = SPECIAL_CARD_OSSSET_XL + 135,
			y = SPECIAL_CARD_OSSSET_Y - 101,
			w = 375,
			h = SPECIAL_PANEL_HEIGHT + 2,
		})
		_frmNode.childUI["SpecialListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["AchievementListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialListBG"
		
		--左侧提示上翻页的图片
		_frmNode.childUI["SpecialPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = SPECIAL_CARD_OSSSET_XL + 133,
			y = SPECIAL_CARD_OSSSET_Y + 72,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["SpecialPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["SpecialPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["SpecialPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["SpecialPageUp"].handle._n:runAction(forever)
		
		--左侧提示下翻页的图片
		_frmNode.childUI["SpecialPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = SPECIAL_CARD_OSSSET_XL + 133 + 7, --非对称的翻页图
			y = SPECIAL_CARD_OSSSET_Y - 273,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["SpecialPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["SpecialPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果成就未铺满第一页，那么不显示下翻页提示
		if (#hVar.tab_tacticsSpecialEx <= (SPECIAL_X_NUM * SPECIAL_Y_NUM)) then
			_frmNode.childUI["SpecialPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["SpecialPageDown"].handle._n:runAction(forever)
		
		--特殊塔左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["SpecialPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = SPECIAL_CARD_OSSSET_XL + 133,
			y = SPECIAL_CARD_OSSSET_Y + 72,
			w = 200,
			h = 27,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsSpecialEx > (SPECIAL_X_NUM * SPECIAL_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_special = true
					friction_special = 0
					draggle_speed_y_special = -MAX_SPEED_SPECIAL / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["SpecialPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialPageUp_Btn"
		
		--特殊塔左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["SpecialPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = SPECIAL_CARD_OSSSET_XL + 133,
			y = SPECIAL_CARD_OSSSET_Y - 287,
			w = 200,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsSpecialEx > (SPECIAL_X_NUM * SPECIAL_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_special = true
					friction_special = 0
					draggle_speed_y_special = MAX_SPEED_SPECIAL / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["SpecialPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["SpecialDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = SPECIAL_CARD_OSSSET_XL + 135,
			y = SPECIAL_CARD_OSSSET_Y - 101,
			w = 380,
			h = SPECIAL_PANEL_HEIGHT,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_special = touchX --开始按下的坐标x
				click_pos_y_special = touchY --开始按下的坐标y
				last_click_pos_y_special = touchX --上一次按下的坐标x
				last_click_pos_y_special = touchY --上一次按下的坐标y
				selected_specialEx_idx = 0 --特殊塔选中的成就ex索引
				draggle_speed_y_special = 0 --当前速度为0
				click_scroll_special = true --是否滑动成就
				b_need_auto_fixing_special = false --不需要自动修正位置
				friction_special = 0 --无阻力
				
				--如果特殊塔数量未铺满一页，那么不需要滑动
				if (#hVar.tab_tacticsSpecialEx <= (SPECIAL_X_NUM * SPECIAL_Y_NUM)) then
					click_scroll_special = false --不需要滑动成就
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_special = touchY - last_click_pos_y_special
				
				if (draggle_speed_y_special > MAX_SPEED_SPECIAL) then
					draggle_speed_y_special = MAX_SPEED_SPECIAL
				end
				if (draggle_speed_y_special < -MAX_SPEED_SPECIAL) then
					draggle_speed_y_special = -MAX_SPEED_SPECIAL
				end
				
				--print("click_scroll_special=", click_scroll_special)
				--在滑动过程中才会处理滑动
				if click_scroll_special then
					local deltaY = touchY - last_click_pos_y_special --与开始按下的位置的偏移值x
					for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
						local ctrli = _frmNode.childUI["SpecialCard" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_special = touchX
				last_click_pos_y_special = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_special then
					--if (touchX ~= click_pos_x_special) or (touchY ~= click_pos_y_special) then --不是点击事件
						b_need_auto_fixing_special = true
						friction_special = 0
					--end
				end
				
				--检测
				--检测点击到了哪个特殊塔框内
				for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
					local ctrli = _frmNode.childUI["SpecialCard" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_specialEx_idx = i
						
						break
						--print("点击到了哪个成就的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（成就数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_special) and (math.abs(touchY - click_pos_y_special) > 40) then
					selected_specialEx_idx = 0
				end
				--print("selected_specialEx_idx", selected_specialEx_idx)
				
				--之前选中了某个特殊塔
				if (selected_specialEx_idx > 0) then
					--OnRefreshAchievementFrame(selected_specialEx_idx)
					--点击特殊塔按钮
					OnClickSpecialTowerBtn(pageIndex, selected_specialEx_idx)
					
					--selected_specialEx_idx = 0
				end
				
				--标记不用滑动
				click_scroll_special = false
			end,
		})
		_frmNode.childUI["SpecialDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialDragPanel"
		
		--找出所有已获得的特殊塔
		local tacticHashList = {} --特殊塔键值表
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特殊塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先绘制每一个已获得的特殊塔（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特殊塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				--创建单个特殊塔控件已获得的（等级大于0）
				OnCreateSingleSpecialCard(pageIndex, indexHave, tacticId, tacticHashList)
			end
		end
		
		--再绘制每一个未获得的特殊塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--创建单个特殊塔控件未获得的（等级等于0或者不存在）
				OnCreateSingleSpecialCard(pageIndex, indexNotHave, tacticId, tacticHashList)
			end
		end
		
		local BTN_EDGE = 64 --按钮的边长
		local lineVHeight1 = 50 --第一条竖线高度
		local lineVHeight2 = 40 --第二条竖线高度
		local lineHWidth = 80 --横线的宽度
		
		local OFFSET_X2 = 215 --统一偏移x
		local OFFSET_Y2 = -95 --统一偏移y
		
		--特殊塔的名字、介绍部分的底板
		_frmNode.childUI["SpecialTowerIntroBG"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = OFFSET_X2,
			y = OFFSET_Y2 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 159 - BTN_EDGE / 2,
			w = 320,
			h = 130,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialTowerIntroBG"
		
		--特殊塔的名字文字
		_frmNode.childUI["SpecialTowerNameLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X2,
			y = OFFSET_Y2 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 30,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["SpecialTowerNameLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialTowerNameLabel"
		
		--特殊塔的等级文字
		_frmNode.childUI["SpecialTowerLvLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X2 + 55,
			y = OFFSET_Y2 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["SpecialTowerLvLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialTowerLvLabel"
		
		--特殊塔的简介文字
		_frmNode.childUI["SpecialTowerIntroLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X2 - 148,
			y = OFFSET_Y2 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 24,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 300,
			text = "",
			border = 1,
		})
		_frmNode.childUI["SpecialTowerIntroLabel"].handle.s:setColor(ccc3(255, 255, 255)) --白色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialTowerIntroLabel"
		
		--介绍点击特殊塔的文字
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickSpecial"] = hUI.label:new({
			parent = _parentNode,
			x = 615,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 250,
			--text = "点击左侧特殊塔查看详情。", --language
			text = hVar.tab_string["ClickSpecialTowerSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickSpecial"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickSpecial"
		
		--只在本分页有效
		--创建timer，刷新战术技能卡滚动
		hApi.addTimerForever("__SPECIAL_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_special_UI_scroll_loop)
	end
	
	--函数：获得第一个可以升级的特殊塔的索引
	GetFirstLvUpSpecialTowerIdx = function()
		--print("GetFirstLvUpTacticCardIdx")
		--特殊塔的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--特殊塔键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特殊塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先查找每一个已获得的特殊塔（等级大于0）
		local indexHave = 0 --已获得的特殊塔（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特殊塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return indexHave
					end
				end
			end
		end
		
		--再绘制每一个未获得的特殊塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的特殊塔（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--print("indexNotHave", indexNotHave)
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return indexNotHave
				end
			end
		end
		
		--走到这里说明没有一个是能升级的，返回第一项
		return 1
	end
	
	--函数：计算某个特殊塔的索引值
	CalSpecialCardIndex = function(tacticCardId)
		--特殊塔键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特殊塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先检测每一个已获得的特殊塔（等级大于0）
		local indexHave = 0 --已获得的特殊塔（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHave
				end
			end
		end
		
		--再检测每一个未获得的特殊塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的特殊塔（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexNotHave
				end
			end
		end
		
		return 0
	end
	
	--函数：点击特殊塔的按钮的执行逻辑
	OnClickSpecialTowerBtn = function(pageIndex, contentIndex)
		--print("OnClickTacticBtn")
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		--print("OnClickTacticBtn2")
		
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = _frmNode.childUI["SpecialCard" .. contentIndex]
		local cardId = button.data.tacticId --特殊塔战术技能卡id
		local towerLv = button.data.tacticLv --特殊塔战术技能卡的等级
		local nowDebris = button.data.tacticDebrisNum --战术技能卡碎片数量
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--上一次选中的特殊塔取消选中
		if (CurrentSelectRecord.contentIdx ~= 0) then
			_frmNode.childUI["SpecialCard" .. CurrentSelectRecord.contentIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
		end
		
		--显示塔的名称和说明
		local towerName = "" --塔的名字
		local towerIntro = "" --塔的简介
		local szTowerLv = "" --塔的等级文字描述
		local towerLvColor = nil --塔的等级文字的颜色
		--显示塔类战术技能卡的名字
		towerName = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
		
		--显示塔类战术技能卡的简介
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					
					--是否一致
					if (id == cardId) then --已存在
						--如果等级更大，用大等级的
						if (lv > towerLv) then
							towerLv = lv
						end
					end
				end
			end
		end
		
		local showTowerLv = towerLv --显示文字的塔的等级
		if (showTowerLv == 0) then
			showTowerLv = 1
		end
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (showTowerLv > maxLv) then
			showTowerLv = maxLv
		end
		if (towerLv > 0) then --已获得的特殊塔
			--szTowerLv = showTowerLv .. "级" --language
			szTowerLv = showTowerLv .. hVar.tab_string["__TEXT_ji"] --language
			towerLvColor = ccc3(255, 255, 0) --橙色
		else --未获得的特殊塔
			--szTowerLv = "未获得" --language
			szTowerLv = hVar.tab_string["CurrentNotGet"] --language
			towerLvColor = ccc3(255, 0, 0) --红色
		end
		
		towerIntro = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][showTowerLv + 1] or ("未知战术技能卡说明" .. cardId)
		
		--更新说明
		_frmNode.childUI["SpecialTowerNameLabel"]:setText(towerName)
		_frmNode.childUI["SpecialTowerLvLabel"]:setText(szTowerLv)
		_frmNode.childUI["SpecialTowerLvLabel"].handle.s:setColor(towerLvColor)
		_frmNode.childUI["SpecialTowerIntroLabel"]:setText(towerIntro)
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔的单位
		local towerUnitId = cardId --塔的单位的类型id
		if (towerLv == 0) then
			towerUnitId = hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[1][1]
		else
			towerUnitId = hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv][1]
		end
		--print("towerUnitId", towerUnitId, towerLv)
		
		--特殊塔第一个文字的偏移值
		local FONT_OFFSET_X = 435 --第一个文字的偏移值x
		local FONT_UNIT_DX = 0 --单位类型的塔的额外偏移值x
		local FONT_LV0_DX = 0 --0级塔的额外偏移值x
		if bIsUnit then
			FONT_UNIT_DX = 90
		elseif (towerLv <= 0) then
			FONT_LV0_DX = 90
		end
		local FONT_OFFSET_Y = -80 --第一个文字的偏移值y
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--读取塔单位的属性
		local attr = hVar.tab_unit[towerUnitId] and hVar.tab_unit[towerUnitId].attr or {} --属性表
		local atk_min = attr.attack and attr.attack[4] or 0 --最小攻击力
		local atk_max = attr.attack and attr.attack[5] or 0 --最大攻击力
		local atk_speed = attr.atk_interval or 0 --攻击速度
		local atk_range = attr.atk_radius or 0 --射程
		
		local atkSpeed = atk_speed / 1000
		local divValue = math.floor(atkSpeed)
		local modValue = (atkSpeed - divValue) * 100
		local szAtkSpeed = ("%d.%s"):format(divValue, tostring(modValue)) --保留2位小数
		
		--显示“攻击”文字
		_frmNode.childUI["AtkPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "攻击", --language
			text = hVar.tab_string["__Attr_Hint_atk"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkPrefix"
		
		--显示攻击力
		local atkFont = "numWhite"
		local atkValueTotal = atk_min .. "-" .. atk_max
		local atkSize = 24
		local atkShowBorder = 0
		local atkExtaDx = 0 --额外的偏移值x
		if (#atkValueTotal > 6) then --如果攻击力文字过长，缩小字体
			atkSize = 20
		end
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkSize = 26
			--atkValueTotal = "无" --language
			atkValueTotal = hVar.tab_string["__TEXT_Nothing"] --language
			atkFont = hVar.FONTC
			atkShowBorder = 1
			atkExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkExtaDx,
			y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
			size = atkSize,
			font = atkFont,
			align = "LC",
			width = 300,
			text = atkValueTotal,
			border = atkShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkValue"
		
		--显示“攻速”文字
		_frmNode.childUI["AtkSpeedPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y - FONT_DELTA_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "攻速", --language
			text = hVar.tab_string["__Attr_Speed"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedPrefix"
		
		--显示攻击速度值
		local atkSpeedFont = "numWhite"
		local atkSpeedSize = 24
		local atkSpeedShowBorder = 0
		local atkSpeedExtaDx = 0 --额外的偏移值x
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkSpeedSize = 26
			--szAtkSpeed = "无" --language
			szAtkSpeed = hVar.tab_string["__TEXT_Nothing"] --language
			atkSpeedFont = hVar.FONTC
			atkSpeedShowBorder = 1
			atkSpeedExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkSpeedValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkSpeedExtaDx,
			y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
			size = atkSpeedSize,
			font = atkSpeedFont,
			align = "LC",
			width = 300,
			text = szAtkSpeed,
			border = atkSpeedShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedValue"
		
		--显示“射程”文字
		_frmNode.childUI["AtkRangePrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "射程", --language
			text = hVar.tab_string["__Attr_Atk_Range"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangePrefix"
		
		--显示射程值
		local atkRangeFont = "numWhite"
		local atkRangeSize = 24
		local atkRangeShowBorder = 0
		local atkRangeExtaDx = 0 --额外的偏移值x
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkRangeSize = 26
			--atk_range = "无" --language
			atk_range = hVar.tab_string["__TEXT_Nothing"] --language
			atkRangeFont = hVar.FONTC
			atkRangeShowBorder = 1
			atkRangeExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkRangeValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkRangeExtaDx,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
			size = 24,
			font = atkRangeFont,
			align = "LC",
			width = 300,
			text = atk_range,
			border = atkRangeShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeValue"
		
		--显示分割线1
		_frmNode.childUI["SeparateLine1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_SeparateLine",
			x = FONT_OFFSET_X + 172,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 45,
			w = 364,
			h = 4,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine1"
		
		--是战术技能卡塔
		--显示下一级塔的属性
		local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
		
		--如果该塔不是0级才显示下一级的属性
		--print(towerLv)
		if (towerLv > 0) then
			local next_font = nil --下一级的文字字体
			local next_color = nil --下一级的文字颜色
			local next_szAtk = nil --攻击力
			local next_szAtkSpeed = nil --攻击速度
			local next_atk_range = nil --射程
			local next_atk_max = 1 --下一级的最大攻击力
			
			--print("towerLv=", towerLv, "towerLvMax=", towerLvMax)
			if (towerLv >= towerLvMax) then --塔已升到顶级
				next_font = hVar.FONTC --下一级的文字字体
				next_color = ccc3(255, 64, 0) --下一级的文字颜色
				--next_szAtk = "已到顶级" --攻击力 --language
				--next_szAtkSpeed = "已到顶级" --攻击速度 --language
				--next_atk_range = "已到顶级" --射程 --language
				next_szAtk = hVar.tab_string["UpToMaxLv"] --攻击力 --language
				next_szAtkSpeed = hVar.tab_string["UpToMaxLv"] --攻击速度 --language
				next_atk_range = hVar.tab_string["UpToMaxLv"] --射程 --language
			else
				--读取下一级塔单位的属性
				local next_towerUnitId = hVar.tab_tactics[cardId] and hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1] or 0
				next_font = "numWhite" --下一级的文字字体
				next_color = ccc3(0, 255, 0) --下一级的文字颜色
				next_szAtk = "?-?" --攻击力
				next_szAtkSpeed = "?" --攻击速度
				next_atk_range = "?" --射程
				
				local tUnit = hVar.tab_unit[next_towerUnitId] or {} --下一级的表项
				
				if tUnit then
					local next_attr = tUnit.attr or {} --属性表
					local next_atk_min = next_attr.attack and next_attr.attack[4] or 0 --最小攻击力
					local next_atk_max_val = next_attr.attack and next_attr.attack[5] or 0 --最大攻击力
					local next_atk_speed = next_attr.attack and next_attr.atk_interval or 0 --攻击速度
					next_atk_max = next_atk_max_val --存储
					next_szAtk = next_atk_min .. "-" .. next_atk_max_val
					next_atk_range = next_attr.atk_radius --射程
					
					local next_atkSpeed = next_atk_speed / 1000
					local next_divValue = math.floor(next_atkSpeed)
					local next_modValue = (next_atkSpeed - next_divValue) * 100
					next_szAtkSpeed = ("%d.%s"):format(next_divValue, tostring(next_modValue)) --保留2位小数
				end
			end
			
			--显示“攻击”的箭头
			_frmNode.childUI["AtkJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkJianTou"
			
			--显示“攻速”的箭头
			_frmNode.childUI["AtkSpeedJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y - FONT_DELTA_Y,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedJianTou"
			
			--显示“射程”的箭头
			_frmNode.childUI["AtkRangeJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeJianTou"
			
			--显示下一级攻击力值
			local next_atkSize = 24
			local next_atkShowBorder = 0
			if (#next_szAtk > 6) then --如果下一级攻击力文字过长，缩小字体
				next_atkSize = 20
			end
			if (towerLv >= towerLvMax) then --塔已升到顶级
				next_atkSize = 24 --这里是中文，可以显示的下
				next_atkShowBorder = 1
			end
			
			local next_atkExtaDx = 0 --额外的偏移值x
			if (next_atk_max <= 0) then --如果该单位下一级没有攻击力，那么显示"无"
				next_atkSize = 26
				--next_szAtk = "无" --language
				next_szAtk = hVar.tab_string["__TEXT_Nothing"] --language
				--next_szAtkSpeed = "无" --language
				next_szAtkSpeed = hVar.tab_string["__TEXT_Nothing"] --language
				--next_atk_range = "无" --language
				next_atk_range = hVar.tab_string["__TEXT_Nothing"] --language
				next_font = hVar.FONTC
				next_atkShowBorder = 1
				next_atkExtaDx = 30 --额外的偏移值x
			end
			_frmNode.childUI["AtkNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
				size = next_atkSize,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_szAtk,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkNextValue"
			
			--显示下一级攻击速度
			_frmNode.childUI["AtkSpeedNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
				size = 24,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_szAtkSpeed,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkSpeedNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedNextValue"
			
			--显示下一级攻击射程
			_frmNode.childUI["AtkRangeNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_atk_range,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkRangeNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeNextValue"
		end
		
		--显示特殊塔的技能
		local order = hVar.tab_unit[towerUnitId] and hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill.order or {} --塔的技能列表
		for i = 1, #order, 1 do
			--响应技能点击事件的按钮区域
			local skill_id = order[i] --技能id
			_frmNode.childUI["SkillButton" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = FONT_OFFSET_X + 160,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
				w = 360,
				h = 68,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.00,
				codeOnTouch = function(self, screenX, screenY, isInside)
					--print(towerUnitId, skill_id, i)
					OnCreateSkillTipFrame(towerUnitId, skill_id, i)
				end,
			})
			_frmNode.childUI["SkillButton" .. i].handle.s:setOpacity(0) --用于响应点击事件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillButton" .. i
			
			--创建技能图标
			_frmNode.childUI["SkillIcon" .. i] = hUI.image:new({
				parent = _parentNode,
				model = hVar.tab_skill[skill_id].icon,
				x = FONT_OFFSET_X + FONT_LV0_DX + 32,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
				w = 64,
				h = 64,
				--z = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillIcon" .. i
			
			--创建技能选中框
			local Scale0 = 64 / 70
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"] = hUI.image:new({
				parent = _frmNode.childUI["SkillIcon" .. i].handle._n,
				model = "UI:Tactic_Selected",
				x = 32,
				y = 32,
				scale = Scale0,
			})
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
			local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:runAction(forever)
			
			--创建技能名称
			_frmNode.childUI["SkillName" .. i] = hUI.label:new({
				parent = _parentNode,
				size = 26,
				x = FONT_OFFSET_X + FONT_LV0_DX + 75,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 85 - (i - 1) * 72,
				w = 300,
				align = "LC",
				font = hVar.FONTC,
				text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillName" .. i
			
			--创建当前技能的卡槽背景框
			_frmNode.childUI["SlotBG" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SlotBG",
				x = FONT_OFFSET_X + FONT_LV0_DX + 110,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
				w = 70,
				h = 14,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBG" .. i
			
			--创建本技能可以升级到的卡槽的数量
			local slotNum = 0
			local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
			if tab then
				if tab.isUnlock then
					slotNum = tab.maxLv
				end
			end
			
			for slot = 1, slotNum, 1 do
				--创建当前技能的单个卡槽条
				_frmNode.childUI["Slot" .. i .. slot] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_Slot",
					x = FONT_OFFSET_X + FONT_LV0_DX + 110 + (slot - 1) * 13 - 26,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 11,
					h = 10,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "Slot" .. i .. slot
			end
		end
		
		--如果该塔不是0级，才显示下一级的技能信息
		if (towerLv <= 0) then --0级
			--
		elseif (towerLv >= towerLvMax) then --已到顶级
			for i = 1, #order, 1 do
				--显示“下一级技能”的箭头
				_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 210,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 30,
					h = 20,
					model = "UI:Tactic_RPointer",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
				
				--显示已升到顶级的文字
				_frmNode.childUI["SkillToTopLabel" .. i] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 250,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 300,
					align = "LC",
					font = hVar.FONTC,
					--text = "已到顶级", --language
					text = hVar.tab_string["UpToMaxLv"], --language
					border = 1,
				})
				_frmNode.childUI["SkillToTopLabel" .. i].handle.s:setColor(ccc3(255, 64, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillToTopLabel" .. i
			end
		else --有下一级的技能
			local next_towerUnitId = hVar.tab_tactics[cardId] and hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1] or 0
			local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
			if tUnit then
				local next_order = tUnit.td_upgrade.upgradeSkill.order --下一级塔的技能列表
				for i = 1, #next_order, 1 do
					local skill_id = next_order[i] --技能id
					
					--显示“下一级技能”的箭头
					_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
					
					--创建下一级技能的卡槽背景框
					_frmNode.childUI["SlotBGNext" .. i] = hUI.image:new({
						parent = _parentNode,
						model = "UI:Tactic_SlotBG",
						x = FONT_OFFSET_X + FONT_LV0_DX + 290,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 70,
						h = 14,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBGNext" .. i
					
					--创建下一级技能可以升级到的卡槽的数量
					local next_slotNum = 0
					local next_tab = hVar.tab_unit[next_towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if next_tab then
						if next_tab.isUnlock then
							next_slotNum = next_tab.maxLv
						end
					end
					
					--本次的数量（用于对比）
					local slotNum = 0
					local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if tab then
						if tab.isUnlock then
							slotNum = tab.maxLv
						end
					end
					for slot = 1, next_slotNum, 1 do
						--创建下一级技能的单个卡槽条
						_frmNode.childUI["SlotNext" .. i .. slot] = hUI.image:new({
							parent = _parentNode,
							model = "UI:Tactic_Slot",
							x = FONT_OFFSET_X + FONT_LV0_DX + 290 + (slot - 1) * 13 - 26,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 11,
							h = 10,
						})
						if (slot > slotNum) then
							_frmNode.childUI["SlotNext" .. i .. slot].handle.s:setColor(ccc3(0, 255, 0))
						end
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotNext" .. i .. slot
					end
				end
			end
		end
		
		--显示分割线2
		_frmNode.childUI["SeparateLine2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_SeparateLine",
			x = FONT_OFFSET_X + 172,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 230,
			w = 364,
			h = 4,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine2"
		
		--升级塔需要的碎片数量
		--local towerLv = 0 --等级
		local costDebris = 0 --需要的碎片数量
		local nowDebris = 0 --当前的碎片数量
		local costScore = 0 --需要的积分
		local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		local tacticInfo = LuaGetPlayerTacticById(cardId)
		if tacticInfo then
			local id, lv, num = unpack(tacticInfo)
			nowDebris = num --当前的碎片数量
		end
		
		--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
		--if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
			costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tacticLvUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
		--else --到顶级了
			--
		--end
		
		--升级需要的塔卡图标
		_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
			parent = _parentNode,
			model = hVar.tab_tactics[cardId].icon,
			x = FONT_OFFSET_X + 30,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 36,
			h = 36,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
		
		--碎片图标
		_frmNode.childUI["DebrisIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:SoulStoneFlag",
			x = FONT_OFFSET_X + 39,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
			w = 30,
			h = 40,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
		
		--碎片进度条
		local progressV = nowDebris / costDebris * 100 --进度
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			progressV = 0
		end
		_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 55,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
			w = 150,
			h = 25,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = progressV,
			max = 100,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
		
		--创建一个进度条满了的特别进度条
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
				parent = _parentNode,
				model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
				x = FONT_OFFSET_X + 55 + (150) / 2,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
				w = 150,
				h = 25,
				align = "LC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
		end
		
		--塔类卡牌
		--升级需要的碎片的数量文字
		local showNumText = nowDebris .. "/" .. costDebris
		local towerFont = "numWhite"
		local towerColor = ccc3(255, 255, 255)
		local towerBorder = 0
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			--showNumText = "无" --language
			--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
			--towerFont = hVar.FONTC
			towerColor = ccc3(255, 64, 0)
			--towerBorder = 1
		end
		
		--local showNumText = "49999/500000"
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
		_frmNode.childUI["DebrisNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 128,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
			w = 300,
			align = "MC",
			font = towerFont,
			text = showNumText,
			border = towerBorder,
			scale = scaleText,
		})
		_frmNode.childUI["DebrisNum"].handle.s:setColor(towerColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
		
		--升级需要的积分图标
		_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = FONT_OFFSET_X + 260,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 32,
			h = 32,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
		
		--塔类卡牌
		--升级需要的积分的数量文字
		local showJFText = tostring(costScore)
		local JFFont = "numWhite"
		local JFColor = ccc3(255, 255, 255)
		local JFBorder = 0
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			showJFText = "无" --language
			showJFText = hVar.tab_string["__TEXT_Nothing"] --language
			JFFont = hVar.FONTC
			--showJFText = "N/A"
			JFColor = ccc3(255, 64, 0)
			JFBorder = 1
		end
		--local showJFText = "499999"
		local scaleJFText = 1.0
		local showJFTextLength = #showJFText
		if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
			scaleJFText = 0.7
		elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
			scaleJFText = 0.8
		elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
			scaleJFText = 0.9
		else --可以显示下
			scaleJFText = 1.0
		end
		_frmNode.childUI["ScoreNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 280,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
			w = 300,
			align = "LC",
			font = JFFont,
			text = showJFText,
			border = JFBorder,
			scale = scaleJFText
		})
		_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
		
		--事件响应控件
		--碎片用于点击的区域
		_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 110,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 220,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下碎片图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = 75
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -80,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--技能背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = hVar.tab_tactics[cardId].icon,
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--碎片图标
				__parent.childUI["imgSoleStone"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:SoulStoneFlag",
					x = offset - 148 + 20,
					y = yOffset - 17,
					w = 40,
					h = 54,
					align = "MC",
				})
				
				--碎片名称
				local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = name .. "碎片", --language
					text = name .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
				
				--碎片介绍
				--local intro = "升级" .. name .. "需要消耗一定数量的该碎片。"
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeDebris"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
				hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
			end,
			]]
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示战术技能卡的tip
				local rewardType = 6 --碎片类型
				local tacticLv = 1
				hApi.ShowTacticCardTip(rewardType, cardId, tacticLv, cardId)
			end,
		})
		_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --用于响应点击事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
		
		--事件响应控件
		--积分用于点击的区域
		_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 310,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 160,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下积分图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = -125
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -50,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--技能背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:score",
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--积分名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "积分", --language
					text = hVar.tab_string["ios_score"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
				
				--积分介绍
				local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				--local intro = "升级" .. name .. "需要消耗一定数量的积分。" --language
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeJiFen"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
			end,
			]]
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示积分介绍的tip
				hApi.ShowJiFennTip()
			end,
		})
		_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
		
		--塔类卡牌的升级按钮
		--升级或者解锁塔的按钮
		local updateText = hVar.tab_string["__UPGRADE"] --"升级"
		if (towerLv == 0) then
			updateText = hVar.tab_string["__UNLOCK"] --"解锁"
		end
		_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 180,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 340,
			w = 160,
			h = 50,
			label = updateText,
			font = hVar.FONTC,
			border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--点击用积分升级塔按钮
				if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔未到顶级
					OnClickLvUpButton(cardId, towerLv, costDebris, nowDebris, costScore, nowScore, itemId)
				end
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔已到顶级
			_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
		end
		
		--积分升级按钮的升级小箭头
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			model = "UI:UI_Arrow",
			scale = 0.7,
			roll = 90,
			x = 90,
		})
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
		
		--如果不符合升级的条件，按钮灰掉
		if (nowDebris < costDebris) or (nowScore < costScore) or (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
		end
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
	end
	
	--函数：自动调整特殊塔控件的滑动
	refresh_special_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_special)
		
		if b_need_auto_fixing_special then
			---第一个特殊塔的数据
			local SpecialBtn1 = _frmNode.childUI["SpecialCard1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个成就中心点位置
			local btn1_ly = 0 --第一个成就最上侧的x坐标
			local delta1_ly = 0 --第一个成就距离上侧边界的距离
			btn1_cx, btn1_cy = SpecialBtn1.data.x, SpecialBtn1.data.y --第一个成就中心点位置
			btn1_ly = btn1_cy + SPECIAL_CARD_HEIGHT / 2 --第一个成就最上侧的x坐标
			delta1_ly = btn1_ly + 82 --第一个成就距离上侧边界的距离
			
			--最后一个特殊塔的数据
			local SpecialBtnN = _frmNode.childUI["SpecialCard" .. (#hVar.tab_tacticsSpecialEx)]
			local btnN_cx, btnN_cy = 0, 0 --最后一个成就中心点位置
			local btnN_ry = 0 --最后一个成就最下侧的x坐标
			local deltNa_ry = 0 --最后一个成就距离下侧边界的距离
			btnN_cx, btnN_cy = SpecialBtnN.data.x, SpecialBtnN.data.y --最后一个成就中心点位置
			btnN_ry = btnN_cy - SPECIAL_CARD_HEIGHT / 2 --最后一个成就最下侧的x坐标
			deltNa_ry = btnN_ry + 384 --最后一个成就距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个成就的头像跑到下边，那么优先将第一个成就头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_specialEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_special = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
					local ctrli = _frmNode.childUI["SpecialCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["SpecialPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["SpecialPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个成就头像贴边
				--print("将最后一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_specialEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_special = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
					local ctrli = _frmNode.childUI["SpecialCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["SpecialPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["SpecialPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_special ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_special)
				--不会选中成就
				selected_specialEx_idx = 0 --选中的成就索引
				--print("    ->   draggle_speed_y_special=", draggle_speed_y_special)
				
				if (draggle_speed_y_special > 0) then --朝上运动
					local speed = (draggle_speed_y_special) * 1.0 --系数
					friction_special = friction_special - 0.5
					draggle_speed_y_special = draggle_speed_y_special + friction_special --衰减（正）
					
					if (draggle_speed_y_special < 0) then
						draggle_speed_y_special = 0
					end
					
					--最后一个成就的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_special = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
						local ctrli = _frmNode.childUI["SpecialCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				elseif (draggle_speed_y_special < 0) then --朝下运动
					local speed = (draggle_speed_y_special) * 1.0 --系数
					friction_special = friction_special + 0.5
					draggle_speed_y_special = draggle_speed_y_special + friction_special --衰减（负）
					
					if (draggle_speed_y_special > 0) then
						draggle_speed_y_special = 0
					end
					
					--第一个成就的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_special = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
						local ctrli = _frmNode.childUI["SpecialCard" .. i]
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
					_frmNode.childUI["SpecialPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["SpecialPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["SpecialPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["SpecialPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_special = false
				friction_special = 0
			end
		end
	end
	
	--函数：创建战术技能卡的升级图界面（第5个分页）
	OnCreateTacticDiagramFrame = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Tactic", 1)
		
		--左侧战术技能卡列表底板
		_frmNode.childUI["TacticListBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = TACTIC_CARD_OSSSET_XL + 135,
			y = TACTIC_CARD_OSSSET_Y - 165,
			w = 375 + 4,
			h = TACTIC_PANEL_HEIGHT + 2 + 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticListBG2"
		
		--左侧战术技能卡列表底板
		_frmNode.childUI["TacticListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = TACTIC_CARD_OSSSET_XL + 135,
			y = TACTIC_CARD_OSSSET_Y - 165,
			w = 375,
			h = TACTIC_PANEL_HEIGHT + 2,
		})
		_frmNode.childUI["TacticListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["TacticListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticListBG"
		
		--左侧提示上翻页的图片
		_frmNode.childUI["TacticPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TACTIC_CARD_OSSSET_XL + 133,
			y = TACTIC_CARD_OSSSET_Y + 72,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TacticPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["TacticPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TacticPageUp"].handle._n:runAction(forever)
		
		--左侧提示下翻页的图片
		_frmNode.childUI["TacticPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TACTIC_CARD_OSSSET_XL + 133 + 7, --非对称的翻页图
			y = TACTIC_CARD_OSSSET_Y - 402,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TacticPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["TacticPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果成就未铺满第一页，那么不显示下翻页提示
		if (#hVar.tab_tacticsEx <= (TACTIC_X_NUM * TACTIC_Y_NUM)) then
			_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TacticPageDown"].handle._n:runAction(forever)
		
		--战术卡左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TacticPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + 133,
			y = TACTIC_CARD_OSSSET_Y + 72,
			w = 200,
			h = 27,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsEx > (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_tactic = true
					friction_tactic = 0
					draggle_speed_y_tactic = -MAX_SPEED_TACTIC / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["TacticPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageUp_Btn"
		
		---战术卡左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TacticPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + 133,
			y = TACTIC_CARD_OSSSET_Y - 412,
			w = 200,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsEx > (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_tactic = true
					friction_tactic = 0
					draggle_speed_y_tactic = MAX_SPEED_TACTIC / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["TacticPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["TacticDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + 135,
			y = TACTIC_CARD_OSSSET_Y - 165,
			w = 380,
			h = TACTIC_PANEL_HEIGHT,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_tactic = touchX --开始按下的坐标x
				click_pos_y_tactic = touchY --开始按下的坐标y
				last_click_pos_y_tactic = touchX --上一次按下的坐标x
				last_click_pos_y_tactic = touchY --上一次按下的坐标y
				selected_tacticEx_idx = 0 --战术卡选中的成就ex索引
				draggle_speed_y_tactic = 0 --当前速度为0
				click_scroll_tactic = true --是否滑动成就
				b_need_auto_fixing_tactic = false --不需要自动修正位置
				friction_tactic = 0 --无阻力
				
				--如果一般战术技能卡数量未铺满一页，那么不需要滑动
				if (#hVar.tab_tacticsEx <= (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					click_scroll_tactic = false --不需要滑动成就
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_tactic = touchY - last_click_pos_y_tactic
				
				if (draggle_speed_y_tactic > MAX_SPEED_TACTIC) then
					draggle_speed_y_tactic = MAX_SPEED_TACTIC
				end
				if (draggle_speed_y_tactic < -MAX_SPEED_TACTIC) then
					draggle_speed_y_tactic = -MAX_SPEED_TACTIC
				end
				
				--print("click_scroll_tactic=", click_scroll_tactic)
				--在滑动过程中才会处理滑动
				if click_scroll_tactic then
					local deltaY = touchY - last_click_pos_y_tactic --与开始按下的位置的偏移值x
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_tactic = touchX
				last_click_pos_y_tactic = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_tactic then
					--if (touchX ~= click_pos_x_tactic) or (touchY ~= click_pos_y_tactic) then --不是点击事件
						b_need_auto_fixing_tactic = true
						friction_tactic = 0
					--end
				end
				
				--检测
				--检测点击到了哪个战术卡框内
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_tacticEx_idx = i
						
						break
						--print("点击到了哪个成就的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（成就数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_tactic) and (math.abs(touchY - click_pos_y_tactic) > 40) then
					selected_tacticEx_idx = 0
				end
				--print("selected_tacticEx_idx", selected_tacticEx_idx)
				
				--之前选中了某个成就
				if (selected_tacticEx_idx > 0) then
					--点击战术技能卡按钮
					OnClickTacticBtn(pageIndex, selected_tacticEx_idx)
					
					--selected_tacticEx_idx = 0
				end
				
				--标记不用滑动
				click_scroll_tactic = false
			end,
		})
		_frmNode.childUI["TacticDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticDragPanel"
		
		--找出所有已获得的一般战术技能卡
		local tacticHashList = {} --一般类战术技能键值表
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先绘制每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				--创建单个战术技能卡控件已获得的（等级大于0）
				OnCreateSingleTacticCard(pageIndex, indexHave, tacticId, tacticHashList)
			end
		end
		
		--再绘制每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--创建单个战术技能卡控件未获得的（等级等于0或者不存在）
				OnCreateSingleTacticCard(pageIndex, indexNotHave, tacticId, tacticHashList)
			end
		end
		
		--介绍点击战术技能卡的文字
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickTactic"] = hUI.label:new({
			parent = _parentNode,
			x = 600,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 250,
			--text = "点击左侧战术技能卡查看详情。", --language
			text = hVar.tab_string["ClickTacticCardSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickTactic"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickTactic"
		
		--只在本分页有效
		--创建timer，刷新战术技能卡滚动
		hApi.addTimerForever("__TACTIC_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_tacitc_UI_scroll_loop)
	end
	
	--函数：获得第一个可以升级的战术技能卡的索引
	GetFirstLvUpTacticCardIdx = function()
		--print("GetFirstLvUpTacticCardIdx")
		--战术卡的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--一般类战术技能键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先绘制每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return indexHave
					end
				end
			end
		end
		
		--再绘制每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--print("indexNotHave", indexNotHave)
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return indexNotHave
				end
			end
		end
		
		--走到这里说明没有一个是能升级的，返回第一项
		return 1
	end
	
	--函数：创建单个战术技能卡控件
	OnCreateSingleTacticCard = function(pageIndex, index, tacticId, tacticHashList)
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % TACTIC_X_NUM) --xi
		if (xi == 0) then
			xi = TACTIC_X_NUM
		end
		local yi = (index - xi) / TACTIC_X_NUM + 1 --yi
		local tacticLv = 0 --战术技能卡等级
		local tacticDebrisNum = 0 --战术技能卡碎片的数量
		
		if tacticHashList[tacticId] then
			tacticLv = tacticHashList[tacticId].skillLV
			tacticDebrisNum = tacticHashList[tacticId].num
			
			--显示不超过最大等级
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (tacticLv > maxLv) then
				tacticLv = maxLv
			end
		end
		
		--战术技能卡控件
		local qLv = math.min((hVar.tab_tactics[tacticId].quality or 1), 4) --图片最多只有4张
		_frmNode.childUI["TacticCard" .. index] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_Tactic,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"],
			model = "UI:tactic_card_" .. qLv,
			x = TACTIC_CARD_OSSSET_XL + (xi - 1) *  TACTIC_CARD_DISTANCE_X,
			y = TACTIC_CARD_OSSSET_Y - (yi - 1) * TACTIC_CARD_DISTANCE_Y,
			w = TACTIC_CARD_WIDTH,
			h = TACTIC_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
			--	--点击战术技能卡按钮
			--	OnClickTacticBtn(pageIndex, index)
			--end,
		})
		_frmNode.childUI["TacticCard" .. index].data.tacticId = tacticId --存储战术技能卡id
		_frmNode.childUI["TacticCard" .. index].data.tacticLv = tacticLv --存储战术技能卡等级
		_frmNode.childUI["TacticCard" .. index].data.tacticDebrisNum = tacticDebrisNum --存储战术技能卡碎片数量
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticCard" .. index
		
		--战术技能卡类型图标
		local button = _frmNode.childUI["TacticCard" .. index]
		button.childUI["typeicon"] = hUI.image:new({
			parent = button.handle._n,
			model = hApi.GetTacticsCardTypeIcon(tacticId, "model"),
			x = -2,
			y = 37,
			w = 26,
			h = 26,
		})
		--button.childUI["typeicon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--战术技能卡技能图标
		button.childUI["skillIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 0,
			w = 56,
			h = 56,
		})
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--一般战术技能卡的技能背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = TACTIC_CARD_WIDTH - 55,
			y = 36,
			w = 34,
			h = 34,
		})
		
		--一般战术技能卡的等级
		local fontSize = 26
		if tacticLv and (tacticLv >= 10) then --如果等级是2位数的，那么缩一下文字
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = TACTIC_CARD_WIDTH - 55,
			y = 35,
			text = tacticLv,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		
		--一般战术技能卡将魂经验条
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -32,
			y = -37,
			w = TACTIC_CARD_WIDTH - 14,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = TACTIC_CARD_WIDTH - 10, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = 100,
			max = 100,
		})
		
		--一般战术技能卡将魂所需经验显示
		button.childUI["labSoulStoneExp"] = hUI.label:new({
			parent = button.handle._n,
			size = 26,
			align = "MC",
			--font = hVar.FONTC,
			font = hVar.DEFAULT_FONT,
			x = 0,
			y = -35,
			text = "", --"NA", --geyachao: 这里不显示等级文字了
		})
		
		--将魂可以升级的箭头提示
		--一般战术技能卡升级的动态箭头
		button.childUI["tacticSoulStonejianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 14,
			y = -10,
			w = 26, --236
			h = 26, --146
			align = "MC",
		})
		--_frm.childUI["tacticSoulStonejianTou"].handle._n:setRotation(0)
		button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
		
		--一般战术技能卡按钮选中框
		local scaleX = (TACTIC_CARD_WIDTH + 4) / 72
		local scaleY = (TACTIC_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame", --"UI:PHOTO_FRAME_BAR",
			align = "MC",
			x = 0,
			y = 0,
			w = TACTIC_CARD_WIDTH + 4,
			h = TACTIC_CARD_HEIGHT + 4,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		local lvNow = tacticLv or 0
		if (lvNow >= maxLv) then
			lvNow = maxLv
		end
		local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
		local costScore = 0 --需要的积分
		local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			costScore = tabShopItem.score or 0 --需要的积分
		end
		
		--未获得战术技能卡
		if (lvNow <= 0) then
			hApi.AddShader(button.handle.s,"gray")
			hApi.AddShader(button.childUI["skillIcon"].handle.s,"gray")
			hApi.AddShader(button.childUI["typeicon"].handle.s,"gray")
			button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
			--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
			
			--可升级的提示
			if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
			else
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
			end
		else
			if (lvNow >= maxLv) then --战术技能卡已到顶级
				button.childUI["barSoulStoneExp"]:setV(0, 100)
				--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
				
				--不能升级的提示
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				
				--创建一个进度条满了的特别进度条
				button.childUI["tacticMaxLvProgressImg"] = hUI.image:new({
					parent = button.handle._n,
					model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
					x = -32 + (TACTIC_CARD_WIDTH - 14) / 2,
					y = -37,
					w = TACTIC_CARD_WIDTH - 14,
					h = 15, --146
					align = "MC",
				})
			else --还可以升级
				button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
				--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
				else
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				end
			end
		end
	end
	
	--函数：自动调整战术技能卡控件的滑动
	refresh_tacitc_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_tactic)
		
		if b_need_auto_fixing_tactic then
			---第一个战术卡的数据
			local TacticBtn1 = _frmNode.childUI["TacticCard1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个成就中心点位置
			local btn1_ly = 0 --第一个成就最上侧的x坐标
			local delta1_ly = 0 --第一个成就距离上侧边界的距离
			btn1_cx, btn1_cy = TacticBtn1.data.x, TacticBtn1.data.y --第一个成就中心点位置
			btn1_ly = btn1_cy + TACTIC_CARD_HEIGHT / 2 --第一个成就最上侧的x坐标
			delta1_ly = btn1_ly + 78 --第一个成就距离上侧边界的距离
			
			--最后一个战术卡的数据
			local TacticBtnN = _frmNode.childUI["TacticCard" .. (#hVar.tab_tacticsEx)]
			local btnN_cx, btnN_cy = 0, 0 --最后一个成就中心点位置
			local btnN_ry = 0 --最后一个成就最下侧的x坐标
			local deltNa_ry = 0 --最后一个成就距离下侧边界的距离
			btnN_cx, btnN_cy = TacticBtnN.data.x, TacticBtnN.data.y --最后一个成就中心点位置
			btnN_ry = btnN_cy - TACTIC_CARD_HEIGHT / 2 --最后一个成就最下侧的x坐标
			deltNa_ry = btnN_ry + 509 --最后一个成就距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个成就的头像跑到下边，那么优先将第一个成就头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_tactic = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["TacticPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个成就头像贴边
				--print("将最后一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_tactic = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["TacticPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_tactic ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_tactic)
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				--print("    ->   draggle_speed_y_tactic=", draggle_speed_y_tactic)
				
				if (draggle_speed_y_tactic > 0) then --朝上运动
					local speed = (draggle_speed_y_tactic) * 1.0 --系数
					friction_tactic = friction_tactic - 0.5
					draggle_speed_y_tactic = draggle_speed_y_tactic + friction_tactic --衰减（正）
					
					if (draggle_speed_y_tactic < 0) then
						draggle_speed_y_tactic = 0
					end
					
					--最后一个成就的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_tactic = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				elseif (draggle_speed_y_tactic < 0) then --朝下运动
					local speed = (draggle_speed_y_tactic) * 1.0 --系数
					friction_tactic = friction_tactic + 0.5
					draggle_speed_y_tactic = draggle_speed_y_tactic + friction_tactic --衰减（负）
					
					if (draggle_speed_y_tactic > 0) then
						draggle_speed_y_tactic = 0
					end
					
					--第一个成就的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_tactic = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
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
					_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["TacticPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["TacticPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_tactic = false
				friction_tactic = 0
			end
		end
	end
	
	--函数：计算某个一般战术技能卡的索引值
	CalTacticCardIndex = function(tacticCardId)
		--一般类战术技能键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先检测每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHave
				end
			end
		end
		
		--再检测每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexNotHave
				end
			end
		end
		
		return 0
	end
	
	--函数：点击战术技能卡的按钮的执行逻辑
	OnClickTacticBtn = function(pageIndex, contentIndex)
		--print("OnClickTacticBtn")
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		--print("OnClickTacticBtn2")
		
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = _frmNode.childUI["TacticCard" .. contentIndex]
		local tacticId = button.data.tacticId --战术技能卡id
		local tacticLv = button.data.tacticLv --战术技能卡的等级
		local nowDebris = button.data.tacticDebrisNum --战术技能卡碎片数量
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--上一次选中的战术技能卡取消选中
		if (CurrentSelectRecord.contentIdx ~= 0) then
			_frmNode.childUI["TacticCard" .. CurrentSelectRecord.contentIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
		end
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--战术卡第一个文字的偏移值
		local FONT_OFFSET_X = 435 --第一个文字的偏移值x
		local FONT_LV0_DX = 0 --0级战术技能卡的额外偏移值x
		local FONT_OFFSET_Y = -80 --第一个文字的偏移值y
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--显示战术技能卡的名称和说明
		local showTacticLv = tacticLv --显示文字的战术技能卡的等级
		if (showTacticLv == 0) then
			showTacticLv = 1
		end
		local tacticName = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知" .. tacticId) --战术技能卡的名字
		local tacticIntro = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showTacticLv + 1] or ("未知战术技能卡说明" .. tacticId) --战术技能卡的简介
		
		--显示战术技能卡的名字
		_frmNode.childUI["TacticCardName"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X,
			y = FONT_OFFSET_Y,
			size = 32,
			font = hVar.FONTC,
			align = "LC",
			width = 340,
			text = tacticName,
			border = 1,
		})
		_frmNode.childUI["TacticCardName"].handle.s:setColor(ccc3(255, 255, 0))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardName"
		
		--分支：等级大于0的战术技能卡显示等级，等级为0的战术技能卡显示未获得
		if (tacticLv > 0) then --已获得
			--显示战术技能卡“等级”文字
			_frmNode.childUI["TacticCardLvPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 190,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				--text = "等级", --language
				text = hVar.tab_string["__Attr_Hint_Lev"], --language
				border = 1,
			})
			_frmNode.childUI["TacticCardLvPrefix"].handle.s:setColor(ccc3(255, 255, 128))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvPrefix"
			
			--显示战术技能卡的等级数值
			--显示不超过最大等级
			local showTacticLv = tacticLv
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (showTacticLv > maxLv) then
				showTacticLv = maxLv
			end
			_frmNode.childUI["TacticCardLvValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 260,
				y = FONT_OFFSET_Y - 1,
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 340,
				text = showTacticLv,
				--border = 1,
			})
			_frmNode.childUI["TacticCardLvValue"].handle.s:setColor(ccc3(255, 255, 128))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvValue"
		else --未获得
			--显示战术技能卡“未获得”文字
			_frmNode.childUI["TacticCardUnGet"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 190,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				--text = "未获得", --language
				text = hVar.tab_string["CurrentNotGet"], --language=
				border = 1,
			})
			_frmNode.childUI["TacticCardUnGet"].handle.s:setColor(ccc3(255, 0, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardUnGet"
		end
		
		--显示战术技能卡当前等级效果的背景图
		_frmNode.childUI["TacticCardSkillBG"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = FONT_OFFSET_X + 183,
			y = FONT_OFFSET_Y - 85,
			w = 366,
			h = 130,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardSkillBG"
		
		--显示战术技能卡“当前效果”的文字
		local currentLvEffectText = nil
		--分支：等级大于0的战术技能卡显示等级，等级为0的战术技能卡显示未获得
		if (tacticLv > 0) then --已获得
			--currentLvEffectText = "当前效果" --language
			currentLvEffectText = hVar.tab_string["CurrentEffect"] --language
		else --未获得
			--currentLvEffectText = "解锁后效果" --language
			currentLvEffectText = hVar.tab_string["UnLockEffect"] --language
		end
		_frmNode.childUI["TacticCardIntroPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 15,
			y = FONT_OFFSET_Y - 45,
			size = 28,
			font = hVar.FONTC,
			align = "LC",
			width = 340,
			text = currentLvEffectText,
			border = 1,
		})
		_frmNode.childUI["TacticCardIntroPrefix"].handle.s:setColor(ccc3(0, 255, 0))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroPrefix"
		
		--显示战术技能卡的本级效果
		_frmNode.childUI["TacticCardIntro"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 15,
			y = FONT_OFFSET_Y - 58,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 340,
			text = tacticIntro,
			border = 1,
		})
		if (tacticLv <= 0) then --未获得
			--暗淡当前效果的标题
			_frmNode.childUI["TacticCardIntroPrefix"].handle.s:setColor(ccc3(212, 0, 0))
			
			--暗淡当前效果的说明
			_frmNode.childUI["TacticCardIntro"].handle.s:setColor(ccc3(168, 168, 168))
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntro"
		
		--只有获得该战术技能卡，才会显示升级后的对比效果
		if (tacticLv > 0) then --已获得
			--显示下一级升级的动态箭头
			_frmNode.childUI["TacticCardLvUpJianTou"] = hUI.image:new({
				parent = _parentNode,
				--model = "ICON:image_jiantouV",
				model = "UI:Tactic_RPointer",
				x = FONT_OFFSET_X + 176,
				y = FONT_OFFSET_Y - 167,
				w = 30, --32
				h = 20, --28
				align = "MC",
			})
			_frmNode.childUI["TacticCardLvUpJianTou"].handle._n:setRotation(90)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvUpJianTou"
			
			local tacticLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --战术技能卡的最大等级
			if (showTacticLv >= tacticLvMax) then --战术技能卡已升到顶级
				--战术技能卡已到顶级的文字
				_frmNode.childUI["TacticCardIntroToTop"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 116,
					y = FONT_OFFSET_Y - 45 - 155,
					size = 28,
					font = hVar.FONTC,
					align = "LC",
					width = 340,
					--text = "已到顶级", --language
					text = hVar.tab_string["UpToMaxLv"], --language
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroToTop"].handle.s:setColor(ccc3(255, 64, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroToTop"
			else --可以升级
				--显示战术技能卡下一等级效果的背景图
				_frmNode.childUI["TacticCardSkillNextBG"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_IntroBG",
					x = FONT_OFFSET_X + 183,
					y = FONT_OFFSET_Y - 85 - 165,
					w = 366,
					h = 130,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardSkillNextBG"
				
				--显示战术技能卡“下一等级效果”的文字
				_frmNode.childUI["TacticCardIntroNextPrefix"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 15,
					y = FONT_OFFSET_Y - 45 - 165,
					size = 28,
					font = hVar.FONTC,
					align = "LC",
					width = 340,
					--text = "下一等级效果", --language
					text = hVar.tab_string["NextLvEffect"], --language
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroNextPrefix"].handle.s:setColor(ccc3(0, 212, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroNextPrefix"
				
				--显示战术技能卡的下一等级效果
				_frmNode.childUI["TacticCardIntroNext"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 15,
					y = FONT_OFFSET_Y - 58 - 165,
					size = 26,
					font = hVar.FONTC,
					align = "LT",
					width = 340,
					text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showTacticLv + 2] or ("未知战术技能卡说明" .. tacticId),
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroNext"].handle.s:setColor(ccc3(168, 168, 168))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroNext"
			end
		end
		
		--升级战术技能卡需要的碎片数量
		local costDebris = 0 --需要的碎片数量
		--local nowDebris = 0 --当前的碎片数量
		local costScore = 0 --需要的积分
		local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		--local tacticInfo = LuaGetPlayerTacticById(tacticId)
		--if tacticInfo then
		--	local id, lv, num = unpack(tacticInfo)
		--	nowDebris = num --当前的碎片数量
		--end
		
		--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
		--if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
			costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tacticLvUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
		--else --到顶级了
			--
		--end
		
		--升级需要的战术技能卡图标
		_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
			parent = _parentNode,
			model = hVar.tab_tactics[tacticId].icon,
			x = FONT_OFFSET_X + 30,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 36,
			h = 36,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
		
		--碎片图标
		_frmNode.childUI["DebrisIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:SoulStoneFlag",
			x = FONT_OFFSET_X + 39,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
			w = 30,
			h = 40,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
		
		--碎片进度条
		local progressV = nowDebris / costDebris * 100 --进度
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			progressV = 0
		end
		_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 55,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
			w = 150,
			h = 25,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = progressV,
			max = 100,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
		
		--创建一个进度条满了的特别进度条
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
				parent = _parentNode,
				model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
				x = FONT_OFFSET_X + 55 + (150) / 2,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
				w = 150,
				h = 25,
				align = "LC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
		end
		
		--战术技能卡
		--升级需要的碎片的数量文字
		local showNumText = nowDebris .. "/" .. costDebris
		local tacticFont = "numWhite"
		local tacticColor = ccc3(255, 255, 255)
		local tacticBorder = 0
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			--showNumText = "无" --language
			--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
			--tacticFont = hVar.FONTC
			tacticColor = ccc3(255, 64, 0)
			--tacticBorder = 1
		end
		--local showNumText = "49999/500000"
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
		_frmNode.childUI["DebrisNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 128,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
			w = 300,
			align = "MC",
			font = tacticFont,
			text = showNumText,
			border = tacticBorder,
			scale = scaleText,
		})
		_frmNode.childUI["DebrisNum"].handle.s:setColor(tacticColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
		
		--升级需要的积分图标
		_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = FONT_OFFSET_X + 260,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 32,
			h = 32,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
		
		--战术技能卡
		--升级需要的积分的数量文字
		local showJFText = tostring(costScore)
		local JFFont = "numWhite"
		local JFColor = ccc3(255, 255, 255)
		local JFBorder = 0
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			showJFText = "无" --language
			showJFText = hVar.tab_string["__TEXT_Nothing"] --language
			JFFont = hVar.FONTC
			--showJFText = "N/A"
			JFColor = ccc3(255, 64, 0)
			JFBorder = 1
		end
		--local showJFText = "499999"
		local scaleJFText = 1.0
		local showJFTextLength = #showJFText
		if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
			scaleJFText = 0.7
		elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
			scaleJFText = 0.8
		elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
			scaleJFText = 0.9
		else --可以显示下
			scaleJFText = 1.0
		end
		_frmNode.childUI["ScoreNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 280,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
			w = 300,
			align = "LC",
			font = JFFont,
			text = showJFText,
			border = JFBorder,
			scale = scaleJFText,
		})
		_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
		
		--事件响应控件
		--碎片用于点击的区域
		_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 110,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 220,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下碎片图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = 75
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -80,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--碎片背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --碎片背景图片透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = hVar.tab_tactics[tacticId].icon,
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--碎片图标
				__parent.childUI["imgSoleStone"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:SoulStoneFlag",
					x = offset - 148 + 20,
					y = yOffset - 17,
					w = 40,
					h = 54,
					align = "MC",
				})
				
				--碎片名称
				local name = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知战术技能卡" .. tacticId)
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = name .. "卡碎片", --language
					text = name .. hVar.tab_string["Card"] .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
				
				--碎片介绍
				--local intro = "升级" .. name .. "卡需要消耗一定数量的该碎片。" --language
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["Card"] .. hVar.tab_string["RequireCostSomeDebris"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
				hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
			end,
			]]
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示战术技能卡的tip
				local rewardType = 6 --碎片类型
				local tacticLv = 1
				hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv, tacticId)
			end,
		})
		_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --需要卡牌的响应点击事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
		
		--事件响应控件
		--积分用于点击的区域
		_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 310,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 160,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下积分图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = -125
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -50,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--积分背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --积分背景图片透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:score",
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--积分名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "积分", --language
					text = hVar.tab_string["ios_score"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
				
				--积分介绍
				local name = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知塔" .. tacticId)
				--local intro = "升级" .. name .. "卡需要消耗一定数量的积分。"
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["Card"] .. hVar.tab_string["RequireCostSomeJiFen"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
			end,
			]]
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示积分介绍的tip
				hApi.ShowJiFennTip()
			end,
		})
		_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
		
		--战术技能卡升级按钮
		--升级或者解锁战术技能卡的按钮
		--local updateText = "升级" --language
		local updateText = hVar.tab_string["__UPGRADE"] --language
		if (tacticLv == 0) then
			--updateText = "解锁" --language
			updateText = hVar.tab_string["__UNLOCK"] --language
		end
		_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 180,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 340,
			w = 160,
			h = 50,
			label = updateText,
			font = hVar.FONTC,
			border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--点击用积分升级战术卡按钮
				if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡未到顶级
					OnClickLvUpButton(tacticId, tacticLv, costDebris, nowDebris, costScore, nowScore, itemId)
				end
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡已到顶级
			_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
		end
		
		--积分升级按钮的升级小箭头
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			model = "UI:UI_Arrow",
			scale = 0.7,
			roll = 90,
			x = 90,
		})
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
		
		--如果不符合升级的条件，按钮灰掉
		if (nowDebris < costDebris) or (nowScore < costScore) or (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
		end
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = tacticId
	end
	
	--函数：更新绘制当前查看的卡牌的信息
	RefreshSelectedCardFrame = function()
		--print("--函数：更新绘制当前查看的卡牌的信息", CurrentSelectRecord.pageIdx)
		--如果当前未选中分页，不需要更新绘制
		--print("CurrentSelectRecord.pageIdx=", CurrentSelectRecord.pageIdx)
		if (CurrentSelectRecord.pageIdx == 0) then
			return
		end
		
		--重新绘制该分页
		local pageIdx = CurrentSelectRecord.pageIdx
		local contentIdx = CurrentSelectRecord.contentIdx
		local cardId = CurrentSelectRecord.cardId
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		CurrentSelectRecord.contentIdx = cardId
		
		--重新绘制该分页
		OnClickPageBtn(pageIdx) --重绘当前分页
		--print("OnClickPageBtn", pageIdx, contentIdx, cardId)
		
		--如果当前未选中页面内的卡牌索引，不需要更新绘制
		if (contentIdx == 0) then
			return
		end
		
		--如果当前未选中卡牌，不需要更新绘制
		if (cardId == 0) then
			return
		end
		
		--选中该卡牌
		if (pageIdx == 1) or (pageIdx == 2) or (pageIdx == 3) then --塔的分页
			--点击塔的按钮
			OnClickTowerBtn(pageIdx, contentIdx)
		elseif (pageIdx == 4) then --特殊
			--点击特殊塔的按钮
			--geyachao: 对于特殊塔要特殊处理，因为可能升级后，新解锁卡牌，排序发生了变化，这里以cardId为准，重新找contentIdx
			contentIdx = CalSpecialCardIndex(cardId)
			OnClickSpecialTowerBtn(pageIdx, contentIdx)
		elseif (pageIdx == 5) then --战术技能卡
			--点击战术技能卡的按钮
			--geyachao: 对于战术技能卡要特殊处理，因为可能升级后，新解锁卡牌，排序发生了变化，这里以cardId为准，重新找contentIdx
			contentIdx = CalTacticCardIndex(cardId)
			OnClickTacticBtn(pageIdx, contentIdx)
		end
	end
	
	--函数：更新提示当前哪个分页可以升级了
	RefreshGuideUpgratePage = function()
		local tTactics = LuaGetPlayerSkillBook()
		local nowScore = LuaGetPlayerScore() --当前的积分
		
		--不存在战术技能卡，直接返回
		if (not tTactics) then
			return
		end
		
		local pageNoteResult = {} --每个分页是否需要提示升级的表
		for i = 1, #tPageIcons, 1 do
			pageNoteResult[i] = false --默认都不需要提示升级
		end
		
		--遍历所有的战术技能卡
		for i = 1, #tTactics, 1 do
			if (type(tTactics[i]) == "table") then
				local id, lv, num = unpack(tTactics[i])
				--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
				
				--存在表项
				if hVar.tab_tactics[id] then
					local type = hVar.tab_tactics[id].type --战术技能卡类型
					if (type == hVar.TACTICS_TYPE.OTHER) or (type == hVar.TACTICS_TYPE.TOWER)  or (type == hVar.TACTICS_TYPE.SPECIAL) then --只处理塔类战术技能卡、一般战术技能卡、特殊塔
						--升级战术技能卡需要的碎片数量
						local tacticLv = lv --战术技能卡的等级
						local costDebris = 0 --需要的碎片数量
						local nowDebris = num --当前的碎片数量
						local costScore = 0 --需要的积分
						
						--未升满级
						if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
							local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
							costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
							local shopItemId = tacticLvUpInfo.shopItemId or 0
							local tabShopItem = hVar.tab_shopitem[shopItemId]
							if tabShopItem then
								--costRmb = tabShopItem.rmb or 0
								costScore = tabShopItem.score or 0 --需要的积分
								
								--积分、碎片数量都符合，并且等级未到顶级
								if (nowDebris >= costDebris) and (nowScore >= costScore) and (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
									--可以升级了，检测这个属于哪个分页的卡牌
									--检测分页1：箭塔分支
									for i = 1, #archyTacticCardList_jianta, 1 do
										if (archyTacticCardList_jianta[i] == id) then
											pageNoteResult[1] = true --分页1：箭塔分页是否提示
										end
									end
									
									--检测分页2：法术塔分支
									for i = 1, #archyTacticCardList_fashu, 1 do
										if (archyTacticCardList_fashu[i] == id) then
											pageNoteResult[2] = true --分页2：法术塔分页是否提示
										end
									end
									
									--检测分页3：炮塔分支
									for i = 1, #archyTacticCardList_paota, 1 do
										if (archyTacticCardList_paota[i] == id) then
											pageNoteResult[3] = true --分页3：炮塔分页是否提示
										end
									end
									
									--检测分页4：特殊塔分支
									if (type == hVar.TACTICS_TYPE.SPECIAL) then
										pageNoteResult[4] = true --分页4：特殊塔分页是否提示
									end
									
									--检测分页5：一般战术技能卡
									if (type == hVar.TACTICS_TYPE.OTHER) then
										pageNoteResult[5] = true --分页5：一般战术技能卡分页是否提示
									end
								end
							end
						else --到顶级了
							--
						end
						
					end
				end
			end
		end
		
		--全部遍历完毕
		--更新绘制
		local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
		local _parent = _frm.handle._n
		for i = 1, #tPageIcons, 1 do
			_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(pageNoteResult[i]) --是否显示提示该分页升级的动态箭头
		end
	end
	
	--通过订单系统 战术技能卡升级
	hGlobal.event:listen("localEvent_afterTacticLvUpSucceed", "_TacticSkillLvUp", function(overage, strTag, order_id)
		--print("localEvent_afterTacticLvUpSucceed", overage, strTag, order_id)
		
		hUI.NetDisable(0)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--保留字符串 如果存在 则进行解析 这块功能必须要等外网服务器更新以后才能生效
		--local strTag = "hi:"..nHeroId..";si:"..skillId..";st:"..type..";sp:"..idx..";sc:"..costScore..";"
		if type(strTag) == "string" and string.find(strTag,"ci:") and string.find(strTag,"sc:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end
			
			--卡牌Id
			local cardId = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"ci:")+3,string.len(tempStr[1])))
			--升级消耗材料
			local costDebris = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"cd:")+3,string.len(tempStr[2])))
			--升级积分消耗
			local cost = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"sc:")+3,string.len(tempStr[3])))
			
			--local retex = LuaAddPlayerTacticDebris(cardId,-costDebris) --错误流程
			local retex = LuaLvUpPlayerTactic(cardId)
			--print("retex=", retex)
			if (retex == 1) then
				ret = true
				--扣除积分
				LuaAddPlayerScore(-cost)
				LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
				
				--播放升级战术技能卡的音效
				hApi.PlaySound("getcard")
				
				--geyachao: 如果玩家升级了战术技能卡，那么就认为战术技能卡界面的引导完成
				--标记主城引导战术技能卡界面完成
				LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6)
				
				--更新当前选中的战术技能卡分页界面
				RefreshSelectedCardFrame()
				
				--更新提示当前哪个分页可以升级了
				RefreshGuideUpgratePage()
			else
				ret = false
				--卡牌不存在
				if retex == 2 then
					strRet = hVar.tab_string["ios_err_unknow"]
				--等级已满
				elseif retex == 3 then
					strRet = hVar.tab_string["__UPGRADEBFSKILL_CANT"]
				--碎片不足
				elseif retex == 4 then
					strRet = hVar.tab_string["tactic_lessDebris"]
				end
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
	end)
	
	--购买失败
	hGlobal.event:listen("LocalEvent_BuyItemfail", "__TacticLvUpClearLock", function(result, nItemID)
		--收到消息后解除购买锁
		--如果技能升级失败，解除按钮锁定
		hUI.NetDisable(0)
	end)
	
	--网络断开
	hGlobal.event:listen("LocalEvent_Set_activity_refresh", "__TacticLvUpClearLock", function(connect_state)
		--如果断开网络则恢复不可使用锻造状态
		if (connect_state == -1) then
			hUI.NetDisable(0)
		end
	end)
	
	--监听打开战术技能卡通知事件
	hGlobal.event:listen("localEvent_ShowPhone_BattlefieldSkillBook", "__SelectTacticFrm", function()
		--触发事件，显示游戏币界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示信的战术技能卡界面
		hGlobal.UI.PhoneSelectedTacticFrm_New:show(1)
		hGlobal.UI.PhoneSelectedTacticFrm_New:active()
		
		--打开上次分页（默认显示第一个分页）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--更新提示当前哪个分页可以升级了
		RefreshGuideUpgratePage()
	end)
end


--test
--[[
--测试代码
if hGlobal.UI.PhoneSelectedTacticFrm_New then --上半部分
	hGlobal.UI.PhoneSelectedTacticFrm_New:del()
	hGlobal.UI.PhoneSelectedTacticFrm_New = nil
end
hGlobal.UI.InitTacticCardFrm_New() --测试
--触发事件，显示战术技能卡界面
hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook", 1, "playercard")
--LuaAddPlayerScore(30000)
--LuaAddPlayerTacticDebris(1044, 1200)
]]

