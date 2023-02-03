



--推荐信息面板
hGlobal.UI.InitRecommandInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowRecommandInfoFrm", "__ShowRecommandFrm"}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	--不重复创建推荐信息面板
	if hGlobal.UI.PhoneRecommandInfoFrm then --推荐信息面板
		return
	end
	
	local BOARD_WIDTH = 720 --推荐面板面板的宽度
	local BOARD_HEIGHT = 720 --推荐面板面板的高度
	local BOARD_OFFSETY = -20 --推荐面板面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --推荐面板面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --推荐面板面板的y位置（最顶侧）
	
	local PAGE_BTN_LEFT_X = 290 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -21 --第一个分页按钮的x偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	--local RandomCommentHistory = hApi.DoNothing --刷新历史评论记录的图片
	local OnClickComment = hApi.DoNothing --点击评价按钮
	
	--分页1：显推荐界面
	local OnCreateRecommandInfoFrame = hApi.DoNothing --创建推荐界面（第1个分页）
	local OnClickPageLeftBtn = hApi.DoNothing --点击左分页按钮
	--local OnClickPageRightBtn = hApi.DoNothing --点击左分页按钮
	
	--分页1：推荐的参数
	local RECOMMANDINFO_WIDTH = 120 --推荐宽度
	local RECOMMANDINFO_HEIGHT = 120 --推荐高度
	local RECOMMANDINFO_OFFSET_X = -350 --推荐统一偏移x
	local RECOMMANDINFO_OFFSET_Y = -50 --推荐统一偏移y
	local RECOMMANDINFO_BOARD_HEIGHT = 500 --推荐高度
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0, commentIdx = 0} --当前选择的分页、数据项的信息记录、

	--配置信息
	--游戏图标
	local gameIcon = "ui/icon108.png"
	--游戏评价信息介绍
	--local commentInfo = hVar.tab_string["commentInfo"]
	--游戏历史评论(随机显示一张图)
	local commentHistory = {"UI:Comment1","UI:Comment2","UI:Comment3","UI:Comment4","UI:Comment5"}
	
	local current_strFrom = 0 --打开此界面的来源方式
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--创建推荐信息面板
	hGlobal.UI.PhoneRecommandInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = "misc/task/ironbuf_panel.png", --"panel/panel_part_00.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.PhoneRecommandInfoFrm
	local _parent = _frm.handle._n
	
	--关闭按钮
	local closeDx = -44
	local closeDy = -116
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "BTN:PANEL_CLOSE2",
		model = -1,
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		w = 96,
		h = 96,
		code = function()
			--不显示推荐信息面板
			hGlobal.UI.PhoneRecommandInfoFrm:show(0)
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--关闭界面后不需要监听的事件
			--取消监听：
			--...
			
			--触发事件：关闭了主菜单按钮
			--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--退出评价界面，允许旋转
			hApi.RecoverScreenRotation()
		end,
	})
	--图片
	_frm.childUI["closeBtn"].childUI["icon"] = hUI.button:new({
		parent = _frm.childUI["closeBtn"].handle._n,
		model = "BTN:PANEL_CLOSE",
		x = 0,
		y = 0,
		scale = 1.0,
	})
	
	--每个分页按钮
	--推荐面板
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"推荐",} --language
	--local tTexts = {hVar.tab_string["__TEXT_shareEx"],} --language
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
		local _frm = hGlobal.UI.PhoneRecommandInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRecommandInfoFrm
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
			--RandomCommentHistory()
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
		--...
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：推荐信息
			--创建推荐信息分页
			OnCreateRecommandInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：刷新历史评论记录的图片
	--RandomCommentHistory = function()
	--	
	--	local _frm = hGlobal.UI.PhoneRecommandInfoFrm
	--	local _frmNode = _frm.childUI["PageNode"]
	--	
	--	local commentHistoryModel = "misc/mask.png"
	--	local lastIdx = CurrentSelectRecord.commentIdx
	--	
	--	if commentHistory and type(commentHistory) == "table" and #commentHistory > 0 then
	--		local r = lastIdx
	--		while (r == lastIdx) do --不重复
	--			r = math.random(1, #commentHistory)
	--		end
	--		
	--		commentHistoryModel = commentHistory[r]
	--		CurrentSelectRecord.commentIdx = r
	--	end
	--	
	--	if lastIdx > 0 and lastIdx ~= CurrentSelectRecord.commentIdx then
	--		local tabM = hApi.GetModelByName(commentHistory[lastIdx])
	--		if tabM then
	--			
	--			local tRelease = {}
	--			local path = tabM.image
	--			tRelease[path] = 1
	--			hResource.model:releasePng(tRelease)
	--			
	--			local pngPath = "data/image/"..(tabM.image)
	--			local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
	--			
	--			if texture then
	--				CCTextureCache:sharedTextureCache():removeTexture(texture)
	--			end
	--		end
	--	end
	--	
	--end
	
	 --函数：点击评价按钮
	OnClickComment = function(btn)
		
		--请求领取评价奖励（新）
		Gift_Function["reward_3"]()
		
		--安卓，因为不发奖了，所以只能本次存储是否点过此按钮，避免一直提示叹号
		--LuaSetCommentState(g_curPlayerName, 1)
		
		--不显示推荐信息面板
		hGlobal.UI.PhoneRecommandInfoFrm:show(0)
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--显示gift页面
		--hGlobal.event:event("LocalEvent_Phone_ShowMyGift")
	end
	
	--函数：创建推荐信息界面（第1个分页）
	OnCreateRecommandInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneRecommandInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--[[
		--左侧推荐列表提示下翻页的图片
		_frmNode.childUI["RecommandInfoPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = RECOMMANDINFO_OFFSET_X + 500, --非对称的翻页图
			y = RECOMMANDINFO_OFFSET_Y - 360,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["RecommandInfoPageDown"].handle.s:setRotation(180)
		_frmNode.childUI["RecommandInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--_frmNode.childUI["RecommandInfoPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["RecommandInfoPageDown"].handle._n:runAction(forever)
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["RecommandInfoPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = RECOMMANDINFO_OFFSET_X + 570,
			y = RECOMMANDINFO_OFFSET_Y - 360,
			w = 220,
			h = 350,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--点击右分页按钮
				--OnClickPageRightBtn()
			end,
		})
		_frmNode.childUI["RecommandInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoPageDown_Btn"
		
		--左侧特殊塔列表底板
		_frmNode.childUI["RecommandInfoBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = RECOMMANDINFO_OFFSET_X + 245,
			y = RECOMMANDINFO_OFFSET_Y - 350,
			w = 440 + 6,
			h = 540 + 6,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoBG2"
		
		--左侧特殊塔列表底板
		_frmNode.childUI["RecommandInfoBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = RECOMMANDINFO_OFFSET_X + 245,
			y = RECOMMANDINFO_OFFSET_Y - 350,
			w = 440,
			h = 540 + 2,
		})
		_frmNode.childUI["RecommandInfoBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["AchievementListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoBG"
		--]]
		
		
		----推荐信息图片
		--_frmNode.childUI["RecommandInfo"] = hUI.image:new({
		--	parent = _parentNode,
		--	model = "misc/mask.png",
		--	x = RECOMMANDINFO_OFFSET_X + 245,
		--	y = RECOMMANDINFO_OFFSET_Y - 350,
		--	w = 440,
		--	h = 540,
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfo"
		
		
		--------------------------------------------------------------------------------------------------------
		
		--欢迎对游戏发表评论
		_frmNode.childUI["RecommandInfoTitle2"] = hUI.label:new({
			parent = _parentNode,
			size = 32,
			align = "MC",
			--font = hVar.FONTC,
			x = RECOMMANDINFO_OFFSET_X + 745,
			y = RECOMMANDINFO_OFFSET_Y - 120,
			width = 520,
			border = 1,
			font = hVar.FONTC,
			text = hVar.tab_string["commentTitle2"],
			RGB = {255, 255, 0,},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoTitle2"
		
		--标题分割线1
		_frmNode.childUI["RecommandTitle2Separate"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/line.png",
			x = RECOMMANDINFO_OFFSET_X + 745,
			y = RECOMMANDINFO_OFFSET_Y - 145,
			w = 360,
			h = 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandTitle2Separate"
		
		--游戏图标图片
		_frmNode.childUI["RecommandGameIcon"] = hUI.image:new({
			parent = _parentNode,
			--model = "ui/icon_cema.png",
			--model = "misc/icon-76@2x.png",
			model = gameIcon,
			x = RECOMMANDINFO_OFFSET_X + 560,
			y = RECOMMANDINFO_OFFSET_Y - 115,
			w = 64,
			h = 64,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandGameIcon"
		
		--评论信息1
		_frmNode.childUI["RecommandInfoLabel1"] = hUI.label:new({
			parent = _parentNode,
			size = 26,
			align = "LT",
			font = hVar.FONTC,
			x = RECOMMANDINFO_OFFSET_X + 460,
			y = RECOMMANDINFO_OFFSET_Y - 190,
			width = 560,
			border = 1,
			--text = "你是三国迷么，我们的剧情战役够三国么？", --language
			text = hVar.tab_string["__TEXT_commentInfo1"], --language
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoLabel1"
		
		--评论信息2
		_frmNode.childUI["RecommandInfoLabel2"] = hUI.label:new({
			parent = _parentNode,
			size = 26,
			align = "LT",
			font = hVar.FONTC,
			x = RECOMMANDINFO_OFFSET_X + 460,
			y = RECOMMANDINFO_OFFSET_Y - 170 - 100,
			width = 560,
			border = 1,
			--text = "这款很讲究策略的塔防是不是你玩过的最特别的塔防游戏？", --language
			text = hVar.tab_string["__TEXT_commentInfo2"], --language
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoLabel2"
		
		--评论信息3
		_frmNode.childUI["RecommandInfoLabel3"] = hUI.label:new({
			parent = _parentNode,
			size = 26,
			align = "LT",
			font = hVar.FONTC,
			x = RECOMMANDINFO_OFFSET_X + 460,
			y = RECOMMANDINFO_OFFSET_Y - 170 - 150,
			width = 560,
			border = 1,
			--text = "是否喜欢这种三国名将在塔防战场上冲锋陷阵的感觉？最喜欢哪个三国英雄？还想要更多玩法多样的防守塔么？", --language
			text = hVar.tab_string["__TEXT_commentInfo3"], --language
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoLabel3"
		
		--评论信息4
		_frmNode.childUI["RecommandInfoLabel4"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			align = "LC",
			font = hVar.FONTC,
			x = RECOMMANDINFO_OFFSET_X + 530,
			y = RECOMMANDINFO_OFFSET_Y - 170 - 430,
			width = 560,
			border = 1,
			--text = "竞技场的公平对战有没有给你带来MOBA+皇室战争的刺激？", --language
			text = hVar.tab_string["__TEXT_commentInfo4"], --language
			RGB = {236, 236, 236},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoLabel4"
		
		--氪石图标
		_frmNode.childUI["RecommandInfoIcon"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/keshi.png",
			x = RECOMMANDINFO_OFFSET_X + 500,
			y = RECOMMANDINFO_OFFSET_Y - 600,
			--scale = 1.2,
			w = 48,
			h = 48,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandInfoIcon"
		
		--去评论按钮实际响应区域
		_frmNode.childUI["RecommandBtn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = RECOMMANDINFO_OFFSET_X + 706,
			y = RECOMMANDINFO_OFFSET_Y - 530,
			--scale = 1.2,
			w = 360,
			h = 120,
			scaleT = 0.95,
			z = 100000, --最前端显示
			--label = {text = "前往苹果商店评论", size = 24, border = 1, x = 0, y = -1,},
			code = function(self, screenX, screenY, isInside)
				OnClickComment(self)
			end,
		})
		_frmNode.childUI["RecommandBtn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RecommandBtn"
		--去评价叹号
		_frmNode.childUI["RecommandBtn"].childUI["tanhao"] = hUI.image:new({
			parent = _frmNode.childUI["RecommandBtn"].handle._n,
			model = "UI:TaskTanHao",
			x = 60,
			y = 30,
			--x = 15,
			--y = 25 - 5,
			z = 100,
			scale = 1.0,
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
		_frmNode.childUI["RecommandBtn"].childUI["tanhao"].handle._n:runAction(CCRepeatForever:create(sequence))
		--_frmNode.childUI["RecommandBtn"].childUI["tanhao"].handle._n:setVisible(false) --默认隐藏
		--已经评价过了，隐藏叹号
		if (LuaGetPlayerGiftstate(3) == 1) then
			_frmNode.childUI["RecommandBtn"].childUI["tanhao"].handle._n:setVisible(false)
		end
		
		--去评论按钮闪烁图片
		_frmNode.childUI["RecommandBtn"].childUI["btnimg"] = hUI.image:new({
			parent = _frmNode.childUI["RecommandBtn"].handle._n,
			x = 0,
			y = 0,
			model = "misc/chest/itembtn2.png",
			scale = 1.5,
		})
		--_frmNode.childUI["RecommandBtn"].childUI["btnimg"].handle.s:setOpacity(144)
		--local towAction = CCSequence:createWithTwoActions(CCFadeTo:create(1.0, 255), CCFadeTo:create(1.0, 144))
		--local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		--_frmNode.childUI["RecommandBtn"].childUI["btnimg"].handle.s:runAction(forever)
		
		--去评论按钮文本
		_frmNode.childUI["RecommandBtn"].childUI["btntext"] = hUI.label:new({
			parent = _frmNode.childUI["RecommandBtn"].handle._n,
			x = 0,
			y = 0,
			--scale = 1.2,
			align = "MC",
			size = 28,
			width = 300,
			text = hVar.tab_string["__TEXT_App_Comment"], --language "前往评论"
			font = hVar.FONTC,
			border = 1,
		})
		
		--RandomCommentHistory()
		
		--添加事件监听：xxxx
		--...
	end
	
	--函数：点击左分页按钮
	OnClickPageLeftBtn = function()
		--print("left")
	end
	
	--函数：点击右分页按钮
	OnClickPageRightBtn = function()
		--print("right")
		--RandomCommentHistory()
	end
	
	--监听打开推荐信息界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowRecommandInfoFrm", "__ShowRecommandFrm", function(strFrom)
		--打开推荐信息界面，禁止旋转
		hApi.LockScreenRotation()
		
		--显示推荐界面
		hGlobal.UI.PhoneRecommandInfoFrm:show(1)
		hGlobal.UI.PhoneRecommandInfoFrm:active()
		
		--存储来源渠道
		current_strFrom = strFrom
		
		--打开上一次的分页（默认显示第1个分页:推荐面板）
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
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneRecommandInfoFrm then --删除上一次的推荐界面
	hGlobal.UI.PhoneRecommandInfoFrm:del()
	hGlobal.UI.PhoneRecommandInfoFrm = nil
end
hGlobal.UI.InitRecommandInfoFrm("include") --测试创建推荐界面
--触发事件，显示推荐界面
hGlobal.event:event("LocalEvent_Phone_ShowRecommandInfoFrm", 0)
]]
