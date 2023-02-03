

--充值操作面板
hGlobal.UI.InitDiabloChargeMoneyFrm = function(mode)
	--不重复创建
	if hGlobal.UI.PhoneDiabloChargeMoneyFrm then --充值面板
		return
	end

	--初始化广告参数
	do
		xlSetAdsTest(0)
		xlSetAdsDebug(0)
	end

	local BORAD_SCALE = 1
	if g_phone_mode == 2 then
		BORAD_SCALE = 0.9
	end

	local BOARD_WIDTH = 900 --充值面板的宽度
	local BOARD_HEIGHT = 540 --充值面板的高度
	local BOARD_OFFSETY = -20 --充值面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --充值面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --充值面板的y位置（最顶侧）

	local PRUCHASE_WIDTH = 194 --充值宽度
	local PRUCHASE_HEIGHT = 354 --充值高度
	
	local PRUCHASE_OFFSET_X = -2 --充值统一偏移x
	local PRUCHASE_OFFSET_Y = -2 --充值统一偏移y
	local PRUCHASE_BOARD_HEIGHT = 420 --充值高度

	local ACHIEVEMENT_X_NUM = 3 --充值x的数量
	local ACHIEVEMENT_Y_NUM = 1 --充值y的数量

	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

	--可变参数
	local current_Iap_max_num = 0 --最大的充值id
	local current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
	local current_IapList = {} --充值信息表
	local current_GiftList = {} --首充奖励表
	local current_deal_idx = 0 --正在交易的充值id
	local current_iType = 0 --支付类型(0:默认(苹果) / 1:苹果 / 2:支付宝 / 3:用户选择)

	local current_adstime = 999999 --广告剩余时间
	local _nNetTime = 0
	local _nDeltaTime = 900
	local _sDeltaTime = "t:900"
	local _bIsPlayAds = false
	local _bCanClickAds = false

	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
	
	--分页1：充值界面
	local OnCreateChargeMoneyFrame = hApi.DoNothing --创建充值界面
	local on_receive_IapList_event = hApi.DoNothing --收到充值信息列表回调
	local on_receive_purchase_event = hApi.DoNothing --收到充值成功或失败的回调
	local on_receive_gift_event = hApi.DoNothing --收到首充奖励的回调
	local OnSelectChargeMoneyButton = hApi.DoNothing --选中某个充值按钮
	local OnSelectPlayAdsButton = hApi.DoNothing --选中看广告按钮
	local Code_CreateProduct = hApi.DoNothing --创建产品
	local Code_InitUI = hApi.DoNothing --初始化界面
	local Code_GetAward = hApi.DoNothing --获得奖励
	local Code_SetTimeAction = hApi.DoNothing --设置时间动画
	local Code_CreatePurchaseSuccessFrm = hApi.DoNothing --创建充值成功界面
	local Code_GetTotalTime = hApi.DoNothing --获得需要等待的总时间
	local Code_ShowDisable = hApi.DoNothing
	local on_receive_GetAdsTime = hApi.DoNothing	--收到广告间隔时间的回调
	local on_receive_AdsOver = hApi.DoNothing	--收到广告结束的回调
	local on_receive_AdsFail = hApi.DoNothing	--收到广告失败的回调

	--暂时性的本地货币解决方案
	local _LOCALCOIN_EXCHANGE_INFO = {
		["playAds"] = {
			sIcon = "misc/skillup/mu_coin.png",		--图标
			sBg = "misc/purchase/play_get_mu.png",		--背景图
			nTotalCoin = 100,				--总货币
			sTotalAward = "s:100",
			--sTotalAward = "rw:{sc,23},{sc,27};",		--奖励
		},
		["tier01.ab.xingames.com"]={
			sIcon = "misc/skillup/mu_coin.png",		--图标
			sBg = "misc/purchase/purchase_600mu.png",	--背景图
			nTotalCoin = 2000,				--总货币
			--sTotalAward = "rw:{sc,255},{sc,945};",		--奖励
		},
		["tier02.ab.xingames.com"]={
			sIcon = "misc/skillup/mu_coin.png",		--图标
			sBg = "misc/purchase/purchase_2400mu.png",	--背景图
			nTotalCoin = 10000,				--总货币
			--sTotalAward = "rw:{sc,2399},{sc,2601};",		--奖励
		},
		[10001]={
			sIcon = "misc/skillup/mu_coin.png",		--图标
			sBg = "misc/purchase/purchase_600mu.png",	--背景图
			nTotalCoin = 2000,				--总货币
			--sTotalAward = "rw:{sc,255},{sc,945};",		--奖励
		},
		[10002]={
			sIcon = "misc/skillup/mu_coin.png",		--图标
			sBg = "misc/purchase/purchase_2400mu.png",	--背景图
			nTotalCoin = 10000,				--总货币
			--sTotalAward = "rw:{sc,2399},{sc,2601};",		--奖励
		},
	}

	hGlobal.UI.PhoneDiabloChargeMoneyFrm = hUI.frame:new({
		x = 0,
		y = 0,
		z = 5000,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		dragable = 4,
		autoactive = 0,
		failcall = 1, --出按钮区域抬起也会响应事件
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = 0,
		--background = "UI:herocardfrm",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})

	local _frm = hGlobal.UI.PhoneDiabloChargeMoneyFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	local offX = hVar.SCREEN.w/2
	local offY = hVar.SCREEN.h/2

	--分页内容的的父控件
	_childUI["PageNode"] = hUI.button:new({
		parent = _parent,
		--model = "UI_frm:slot",
		--animation = "normal",
		model = "misc/skillup/msgbox4.png",
		dragbox = _childUI["dragBox"],
		x = offX,
		y = offY,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		code = function(self, touchX, touchY, sus)
			if hApi.IsReviewMode() then
				Code_ShowDisable()
				return
			end
			print(touchX, touchY)
			--没有网络
			if (g_cur_net_state ~= 1) then
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext("NO NETWORK", hVar.FONTC, 32, "MC", 0, 0,nil,1)
				return
			end
			if _bIsPlayAds == true then
				return
			end
			local _frmNode = _frm.childUI["PageNode"]
			local sx,sy = _frmNode.data.x,_frmNode.data.y
			local playbtn = _frmNode.childUI["AchievementNode0"]
			if playbtn then
				local cx = playbtn.data.x
				local cy = playbtn.data.y
				if touchX > sx+cx - PRUCHASE_WIDTH/2 and touchX< sx+cx + PRUCHASE_WIDTH/2 then
					if touchY > sy + cy - PRUCHASE_HEIGHT/2 and touchY < sy + cy + PRUCHASE_HEIGHT/2 then
						--点击播放广告按钮
						OnSelectPlayAdsButton()
						return
					end
				end
			end
			local selectedEx_Idx = 0
			for i = 1, #current_IapList, 1 do
				local listI = current_IapList[i] --第i项
				if (listI) then --存在充值信息第i项表
					local ctrli = _frmNode.childUI["AchievementNode" .. i]
					if ctrli then
						local cx = ctrli.data.x
						local cy = ctrli.data.y
						if touchX > sx+cx - PRUCHASE_WIDTH/2 and touchX< sx+cx + PRUCHASE_WIDTH/2 then
							if touchY > sy + cy - PRUCHASE_HEIGHT/2 and touchY < sy + cy + PRUCHASE_HEIGHT/2 then
								selectedEx_Idx = i
							end
						end
					end
				end
			end
			selected_achievementEx_idx = selectedEx_Idx
			--选择充值档
			OnSelectChargeMoneyButton(selected_achievementEx_idx)
		end,
	})
	_childUI["PageNode"].handle._n:setScale(BORAD_SCALE)

	--关闭按钮区域
	_childUI["closebtn"] = hUI.button:new({
		parent = _parent,
		model = "misc/skillup/btn_close.png", --"UI:playerBagD"
		dragbox = _childUI["dragBox"],
		x = offX + 450*BORAD_SCALE - 42,
		y = offY + 270*BORAD_SCALE - 42,
		scale = 1.1*BORAD_SCALE,
		--scaleT = 0.95,
		code = function(self, screenX, screenY, isInside)
			--删除本界面
			_frm:show(0)

			--先清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--清空切换分页之后取消的监听事件
			--移除事件监听：充值信息列表回调
			hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapListBack", nil)
			--移除事件监听：充值成功或失败的回调
			hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseBack", nil)
			--移除事件监听：首充奖励的回调
			hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack", nil)
			--移除事件监听：收到广告间隔时间的回调
			hGlobal.event:listen("LocalEvent_AdsOver","AdsOver",nil)
			--移除事件监听：收到广告结束的回调
			hGlobal.event:listen("LocalEvent_AdsFail","AdsFail",nil)
			--移除事件监听：收到广告失败的回调
			hGlobal.event:listen("LocalEvent_GetAdsTime","_GetAdsTime",nil)

			current_Iap_max_num = 0 --最大的充值id
			current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
			current_IapList = {} --充值信息表
			current_GiftList = {} --首充奖励表
			current_deal_idx = 0 --正在交易的充值id
			current_iType = 0 --支付类型(0:默认(苹果) / 1:苹果 / 2:支付宝 / 3:用户选择)
			current_adstime = 99999
			_nNetTime = 0
			_bIsPlayAds = false
			
			--播放音效，关闭界面
			hApi.PlaySound("Button2")

			hGlobal.event:event("LocalEvent_EnableKeypad_mainbase")
		end,
	})

	OnCreateChargeMoneyFrame = function()
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n

		--初始化参数
		current_Iap_max_num = 0 --最大的充值id
		current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
		current_IapList = {} --充值信息表
		current_GiftList = {} --首充奖励表
		current_deal_idx = 0 --正在交易的充值id
		current_iType = 0 --初始化支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
		current_adstime = 999999
		_nNetTime = 0
		_bIsPlayAds = false
		
		if xlGetIapType then
			current_iType = xlGetIapType() --读取支付类型
			
			--默认是用苹果支付
			if (current_iType == 0) then
				current_iType = 1
			end
		end



		--OnRefreshAchievementFrame()
		--添加事件监听：充值信息列表回调
		hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapListBack", on_receive_IapList_event)
		
		--添加事件监听：充值成功或失败的回调
		hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseBack", on_receive_purchase_event)
		
		--添加事件监听：首充奖励的回调
		hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack", on_receive_gift_event)

		--添加事件监听：收到广告间隔时间的回调
		hGlobal.event:listen("LocalEvent_AdsOver","AdsOver",on_receive_AdsOver)

		--添加事件监听：收到广告结束的回调
		hGlobal.event:listen("LocalEvent_AdsFail","AdsFail",on_receive_AdsFail)

		--添加事件监听：收到广告失败的回调
		hGlobal.event:listen("LocalEvent_GetAdsTime","_GetAdsTime",on_receive_GetAdsTime)

		--发起查询，充值信息列表
		if xlRequestIapList then
			--如果类型是1或者2，那么直接发起查询
			if (current_iType == 1) or (current_iType == 2) then --支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
				xlRequestIapList(current_iType)
			else --用户选择或者其他异常情况
				--用户选择选哪一种
				local MsgSelections = nil
				MsgSelections = {
					style = "mini",
					select = 0,
					ok = function()
						--print("支付宝")
						current_iType = 2
						xlRequestIapList(current_iType)
					end,
					cancel = function()
						--print("苹果")
						current_iType = 1
						xlRequestIapList(current_iType)
					end,
					--cancelFun = cancelCallback, --点否的回调函数
					--textOk = "支付宝", --language
					textOk = hVar.tab_string["ios_payment_alipay"], --language
					textCancel = hVar.tab_string["ios_payment_apple"], --language
					userflag = 0, --用户的标记
				}
				--local showTitle = "请选择支付方式" --language
				local showTitle = hVar.tab_string["ios_payment_select_pay_mode"] --language
				local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
				msgBox:active()
				msgBox:show(1,"fade",{time=0.08})
			end
		end
		
		--发起查询，首充奖励信息
		SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")

		--测试 --test
		--模拟触发回调: 充值信息列表回调
		if (IAPServerIP == g_lrc_Ip) then --内网
			if xlGetChannelId() < 100 then
				current_iType = 1

				local localList = {
					[1] = {productId = "tier01.ab.xingames.com", productName = "游戏币1200", productPriceDesc = "￥6.00", productDesc = "获得游戏币1200。", productPrice = "6", productGameCoin = "1200",},
					[2] = {productId = "tier02.ab.xingames.com", productName = "游戏币5000", productPriceDesc = "￥18.00", productDesc = "获得游戏币5000。", productPrice = "18", productGameCoin = "5000",},
				}
				
				--模拟触发回调: 充值信息列表回调
				hGlobal.event:event("LocalEvent_OnIapList_Back", localList)
			end
		end
	end

	--清空所有分页右侧的UI
	_removeRightFrmFunc = function()
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end

	--清空所有分页左侧的UI
	_removeLeftFrmFunc = function()
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			print(leftRemoveFrmList[i])
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end

	--创建商品
	Code_CreateProduct = function(Info,idx,i)
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		local listI = Info --第i项
		local validIdx = idx
		local sUIName = ""
		if (listI) then --存在充值信息第i项表
			local productId = listI.productId --产品id
			local productName = listI.productName --产品名称
			local productPriceDesc = listI.productPriceDesc --产品价格描述
			local productDesc = listI.productDesc --产品描述
			local productPrice = tonumber(listI.productPrice) --产品价格
			local productGameCoin = tonumber(listI.productGameCoin) --获得的总游戏币
			local productIcon = "misc/skillup/mu_coin.png"

			local modelBg = ""
			local exchangeInfo = _LOCALCOIN_EXCHANGE_INFO[productId]
			if exchangeInfo then
				modelBg = exchangeInfo.sBg
				productIcon = exchangeInfo.sIcon
			
				local xn = (validIdx % ACHIEVEMENT_X_NUM) --xn
				if (xn == 0) then
					xn = ACHIEVEMENT_X_NUM
				end
				local yn = (validIdx - xn) / ACHIEVEMENT_X_NUM + 1 --yn
				if idx == 0 then
					xn = 0
					yn = 1
				end
				--充值的底板
				_frmNode.childUI["AchievementNode" .. i] = hUI.button:new({
					parent = _parentNode,
					model = modelBg,
					x = PRUCHASE_OFFSET_X + (xn - 1) * (PRUCHASE_WIDTH + 70),
					y = PRUCHASE_OFFSET_Y - (yn - 1) * (PRUCHASE_HEIGHT),
					w = PRUCHASE_WIDTH,
					h = PRUCHASE_HEIGHT,
				})

				if _LOCALCOIN_EXCHANGE_INFO[productId] then
					productGameCoin = _LOCALCOIN_EXCHANGE_INFO[productId].nTotalCoin
				end

				--充值获得的金币数量（原始数量）
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					x = 24,
					y = 126, --字体有1像素偏差
					size = 24,
					font = "numWhite",
					align = "MC",
					width = 300,
					--border = 1,
					text = productGameCoin,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"].handle.s:setColor(ccc3(255, 255, 224))
			
				--充值的金额
				_frmNode.childUI["AchievementNode" .. i].childUI["money"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					x = 0,
					y = -136, --字体有1像素偏差
					size = 26,
					font = hVar.FONTC,
					align = "MC",
					width = 300,
					border = 1,
					text = productPriceDesc,
					RGB = {255,200,50},
				})

				--本条目充值的菊花
				_frmNode.childUI["AchievementNode" .. i].childUI["waiting"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "MODEL_EFFECT:waiting",
					x = 0,
					y = 2,
					w = 64,
					h = 64,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["waiting"].handle.s:setVisible(false) --默认不显示菊花
			
				sUIName = "AchievementNode" .. i
			end
		end
		return sUIName
	end

	--初始化UI
	Code_InitUI = function(list)
		--默认本地数据
		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			local localList = {
				[0] = {productId = "playAds", productName = "游戏币50", productPriceDesc = "--:--", productDesc = "获得游戏币50。", productPrice = "0", productGameCoin = "50",},
				--[1] = {productId = "tier01.ab.xingames.com", productName = "游戏币600", productPriceDesc = "****", productDesc = "获得游戏币600。", productPrice = "6", productGameCoin = "600",},
				--[2] = {productId = "tier02.ab.xingames.com", productName = "游戏币2400", productPriceDesc = "****", productDesc = "获得游戏币2400。", productPrice = "18", productGameCoin = "2400",},
			}
			local sUIName = Code_CreateProduct(localList[0],0,0)
			if sUIName ~= "" then
				leftRemoveFrmList[#leftRemoveFrmList+1] = sUIName
			end
		else
			PRUCHASE_OFFSET_X = -2 - (PRUCHASE_WIDTH + 70)
		end
		--for i = 1,#localList do
			--sUIName = Code_CreateProduct(localList[i],i,i)
			--if sUIName ~= "" then
				--rightRemoveFrmList[#rightRemoveFrmList + 1] = sUIName
			--end
		--end
	end

	--函数：收到充值信息列表回调
	on_receive_IapList_event = function(list)
		print("on_receive_IapList_event")
		--先清空上次充值信息的界面相关控件
		_removeRightFrmFunc()
		
		--存储充值信息表
		current_IapList = list
		current_Iap_max_num = 0

		local validIdx = 0 --有效的索引
		for i = 1, #current_IapList, 1 do
			local listI = current_IapList[i] --第i项
			if (listI) then --存在充值信息第i项表
				local exchangeInfo = _LOCALCOIN_EXCHANGE_INFO[listI.productId]
				if exchangeInfo then
					--标记参数
					validIdx = validIdx + 1 --有效的索引加1
					current_Iap_max_num = validIdx --标记最大充值id
					local sName = Code_CreateProduct(listI,validIdx,i)
					if sName ~= "" then
						rightRemoveFrmList[#rightRemoveFrmList + 1] = sName
					end
				end
			end
		end
		--if (current_Iap_max_num == 0) then
			----充值的底板
			--_frmNode.childUI["DisabelConnectLabel"] = hUI.label:new({
				--parent = _parentNode,
				--size = 26,
				--x = 0,
				--y = 0,
				--width = 800,
				--align = "MC",
				--font = hVar.FONTC,
				----text = "连接AppStore失败，请检查您的网络设置。", --language
				--text = hVar.tab_string["ios_pruchase_connect"] .. hVar.tab_string["ios_pruchase_pay" .. current_iType] .. hVar.tab_string["ios_pruchase_fail"], --language
				--border = 1,
			--})
			--_frmNode.childUI["DisabelConnectLabel"].handle.s:setColor(ccc3(212, 212, 212))
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DisabelConnectLabel"
		--end
	end

	--选中看广告按钮
	OnSelectPlayAdsButton = function()
		print("OnSelectPlayAdsButton")
		local _frmNode = _frm.childUI["PageNode"]

		if _bCanClickAds == false then
			return
		end

		if (current_focus_achievementEx_idx > 0) then
			if (current_deal_idx ~= 0) then
				--冒字显示正在交易中
				local parent = _frmNode
				local ctrl = _frmNode.childUI["AchievementNode"..current_deal_idx]
				local ox, oy = _frm.data.x, _frm.data.y
				local px, py = parent.data.x, parent.data.y
				local cx, cy = ctrl.data.x, ctrl.data.y
				--local strText = "上一个交易正在处理中！" --language
				local strText = "being processed"--hVar.tab_string["ios_deal_ing"] --language
				hUI.floatNumber:new({
					x = ox + px + cx - 28,
					y = oy + py + cy - 13 + 110,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 32, 0)
				return
			end
		end

		--显示菊花
		_frmNode.childUI["AchievementNode0"].childUI["waiting"].handle.s:setVisible(true)
				
		--灰掉按钮
		hApi.AddShader(_frmNode.childUI["AchievementNode0"].handle.s, "gray") --灰色图片

		_bIsPlayAds = true
		_bCanClickAds = false

		SendCmdFunc["GetAdsTime"]()

		
		--显示广告
		xlShowAds()

		--内网模拟测试
		if (IAPServerIP == g_lrc_Ip) then --内网
			hApi.addTimerOnce("temp_adsover",5000,function()
				hGlobal.event:event("LocalEvent_AdsOver")
			end)
		end
	end

	--选中某个充值按钮
	OnSelectChargeMoneyButton = function(idxEx)
		print("OnSelectChargeMoneyButton")
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记选中哪个充值idx
		local last_achieve_idx = current_focus_achievementEx_idx
		current_focus_achievementEx_idx = idxEx
		
		--显示本次的
		if (current_focus_achievementEx_idx > 0) then
			--如果当前存在正在交易的购买，不能再次购买
			if (current_deal_idx == 0) then
				--标记当前正在交易的id
				current_deal_idx = current_focus_achievementEx_idx
				
				--显示菊花
				_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["waiting"].handle.s:setVisible(true)
				
				--灰掉按钮
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].handle.s, "gray") --灰色图片
				
				--弹出购买游戏币的窗口
				if xlIapBuyItem then
					--支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
					if (current_iType == 1) then --苹果
						local listI = current_IapList[idxEx] --第i项
						if (listI) and listI.custombuyindex then --存在充值信息第i项表
							local id = listI.custombuyindex - 1
							xlIapBuyItem(current_iType, id)
						else--内网
							local id = current_focus_achievementEx_idx - 1
							xlIapBuyItem(current_iType, id)
						end
					elseif (current_iType == 2) then --支付宝
						local listI = current_IapList[idxEx] --第i项
						if (listI) then --存在充值信息第i项表
							local productId = listI.productId --产品id
							xlIapBuyItem(current_iType, productId)
						end
					end
				end
				
				--测试 --test
				
				--if (IAPServerIP == g_lrc_Ip) then --内网
					----模拟触发回调: 充值成功
					----hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Topup_Success_Tip"],{
						----font = hVar.FONTC,
						----ok = function()
						----end,
					----})
					--hGlobal.event:event("LocalEvent_Purchase_Back", 1)
				--end
				
			else
				--冒字显示正在交易中
				local parent = _frmNode
				local ctrl = _frmNode.childUI["AchievementNode"..current_deal_idx]
				local ox, oy = _frm.data.x, _frm.data.y
				local px, py = parent.data.x, parent.data.y
				local cx, cy = ctrl.data.x, ctrl.data.y
				--local strText = "上一个交易正在处理中！" --language
				local strText = hVar.tab_string["ios_deal_ing"] --language
				hUI.floatNumber:new({
					x = ox + px + cx - 28,
					y = oy + py + cy - 13 + 110,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 32, 0)
			end
		end
	end

	Code_CreatePurchaseSuccessFrm = function(num)
		if hGlobal.UI.PurchaseSuccessFrm then
			hGlobal.UI.PurchaseSuccessFrm:del()
			hGlobal.UI.PurchaseSuccessFrm = nil
		end
		hGlobal.UI.PurchaseSuccessFrm = hUI.frame:new({
			x = hVar.SCREEN.w/2-200,
			y = hVar.SCREEN.h/2+120,
			w = 420,
			h = 300,
			dragable = 4,
			background = "misc/skillup/msgbox4.png",
			show = 1,
			z = 100000,
			closebtn = 0,
			autoactive = 1,
			border = 0,
		})

		local frm = hGlobal.UI.PurchaseSuccessFrm
		local parent = frm.handle._n
		local childUI = frm.childUI
		--hVar.tab_string["__TEXT_Topup_Success_Tip2"]

		childUI["img_score"] = hUI.image:new({
			parent = parent,
			model = "misc/skillup/mu_coin.png",
			x = 160,
			y = -80,
		})

		childUI["lab_score"] = hUI.label:new({
			parent = parent,
			x = 240,
			y = -80,
			font = hVar.FONTC,
			border = 0,
			width = 360,
			height = 40,
			align = "MC",
			size = 26,
			text = tostring(num),
		})

		childUI["lab_content"] = hUI.label:new({
			parent = parent,
			x = 210,
			y = -140,
			font = hVar.FONTC,
			border = 0,
			width = 360,
			height = 40,
			align = "MC",
			size = 28,
			text = hVar.tab_string["__TEXT_Topup_Success_Tip2"],
		})

		childUI["btn_ok"] = hUI.button:new({
			parent = parent,
			dragbox = childUI["dragBox"],
			model = "misc/addition/cg.png",
			font = hVar.FONTC,
			label = {text = "OK",size = 24,},
			x = 210,
			y = -300 + 70,
			border = 1,
			--scale = tData[4] or 1,
			scale = 0.8,
			w = 168,
			h = 60,
			align = "MC",
			scaleT = 0.9,
			code = function(self)
				frm:show(0)
				if hGlobal.UI.PurchaseSuccessFrm then
					hGlobal.UI.PurchaseSuccessFrm:del()
					hGlobal.UI.PurchaseSuccessFrm = nil
				end
			end,
		})
	end


	--函数：收到充值成功或失败的回调
	on_receive_purchase_event = function(nResult)
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果存在上一次交易的id，那么取消该交易的等待状态
		if (current_deal_idx > 0) then
			if nResult == 1 then
				--给奖励
				Code_GetAward(current_deal_idx)

				--获取邮箱  从邮箱中
				SendCmdFunc["get_prize_list"]()
			end
			--隐藏菊花
			_frmNode.childUI["AchievementNode" .. current_deal_idx].childUI["waiting"].handle.s:setVisible(false)
			
			--正常按钮
			hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_deal_idx].handle.s, "normal") --亮掉图片
			
			--标记当前正在交易的id为0
			current_deal_idx = 0
		end
	end

	local createGetScoreFloat = function(nScore)
		local text = "+ "..nScore.." "
		local num = #text
		local offx = 90+40*num/2
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 + offx/2 -25,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "RC", 0, 0,nil,offx)

		hUI.floatNumber:new({
			font = "numGreen",
			text = "",
			size = 16,
			x = hVar.SCREEN.w / 2 - 40*num/4 + 12,
			y = hVar.SCREEN.h / 2 - 4,
			align = "LC",
			icon = "misc/skillup/mu_coin.png",
			iconWH = 36,
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		})
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
	end

	--获得奖励
	Code_GetAward = function(index)
		local nScore = 0
		if index == 0 then
			local info = _LOCALCOIN_EXCHANGE_INFO["playAds"]
			if info then
				local sAward = info.sTotalAward
				local _,_,sScore = string.find(sAward,"s:(%d+)")
				--修改添加积分的同时加上来源以便统计
				LuaAddPlayerScoreByWay(tonumber(sScore),hVar.GET_SCORE_WAY.ADS)
				nScore = info.nTotalCoin
				--hGlobal.event:event("NetEvent_L2CReward",10000,"","",sAward, 1)
				
				local keyList = {"material",}
				LuaSavePlayerData_Android_Upload(keyList, "看广告奖励")
			end
			if nScore > 0 then
				createGetScoreFloat(nScore)
				_frm:active()
			end
		else
			--已修改流程 现在走邮箱
			local listI = current_IapList[index] --第i项
			if (listI) then --存在充值信息第i项表
				local productId = listI.productId
				local info = _LOCALCOIN_EXCHANGE_INFO[productId]
				if info then
					--local sAward = info.sTotalAward
					nScore = info.nTotalCoin
					--显示弹框
					Code_CreatePurchaseSuccessFrm(nScore)
					--hGlobal.event:event("NetEvent_L2CReward",10000,"","",sAward, 1)
				end
			end
		end
	end

	--获得需要等待的总时间
	Code_GetTotalTime = function()
		local _,_,checkTime = string.find(_sDeltaTime,"t:(%d+)")
		checkTime = tonumber(checkTime)
		--作弊就返回一个随机值
		if _nDeltaTime ~= checkTime then
			return math.random(30000,60000)
		else
			return math.max(_nDeltaTime,checkTime)
		end
	end

	--设置时间动画
	Code_SetTimeAction = function()
		local _frmNode = _frm.childUI["PageNode"]
		if _frmNode.childUI["AchievementNode0"] then
			_frmNode.childUI["AchievementNode0"].handle._n:stopAllActions()
			_removeLeftFrmFunc()
			Code_InitUI()
			local delay = CCDelayTime:create(1)
			local callback = CCCallFunc:create(function()
				local _frmNode = _frm.childUI["PageNode"]
				current_adstime = math.max(0,current_adstime - 1)
				_nNetTime = _nNetTime + 1
				if current_adstime <= 0 then
					_frmNode.childUI["AchievementNode0"].handle._n:stopAllActions()
					_removeLeftFrmFunc()
					Code_InitUI()
					_frmNode.childUI["AchievementNode0"].childUI["money"]:setText("PLAY")
				else
					local hour = math.floor(current_adstime / 3600) --小时（总）
					local minute = math.floor((current_adstime - hour * 3600) / 60) --分钟
					local second = current_adstime - hour * 3600 - minute * 60 --秒
					local sShowTime = string.format("%02d:%02d",minute,second)
					--_frmNode.childUI["AchievementNode0"].childUI["money"]:setText(minute..":"..second)
					_frmNode.childUI["AchievementNode0"].childUI["money"]:setText(sShowTime)
					hApi.AddShader(_frmNode.childUI["AchievementNode0"].handle.s, "gray")
				end
			end)
			local sequence = CCSequence:createWithTwoActions(delay,callback)
			_frmNode.childUI["AchievementNode0"].handle._n:runAction(CCRepeatForever:create(sequence))
		end
	end
	
	--收到广告结束的回调
	on_receive_AdsOver = function()
		--核实是否能获得奖励
		local totalTime = Code_GetTotalTime()
		if math.max(0,(totalTime-_nNetTime)) == 0 then
			SendCmdFunc["ResetAdsTime"]()
			_nNetTime = 0
			current_adstime = totalTime
			Code_SetTimeAction()
			Code_GetAward(0)
		else
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext("Waiting time is over", hVar.FONTC, 32, "MC", 0, 0,nil,1)
		end
		

		local _frmNode = _frm.childUI["PageNode"]
		if _frmNode.childUI["AchievementNode0"] then
			--隐藏菊花
			_frmNode.childUI["AchievementNode0"].childUI["waiting"].handle.s:setVisible(false)
			
			--正常按钮
			hApi.AddShader(_frmNode.childUI["AchievementNode0"].handle.s, "normal") --亮掉图片
		end

		_bIsPlayAds = false
	end

	--收到广告失败的回调
	on_receive_AdsFail = function()
		local _frmNode = _frm.childUI["PageNode"]
		if _frmNode.childUI["AchievementNode0"] then
			--隐藏菊花
			_frmNode.childUI["AchievementNode0"].childUI["waiting"].handle.s:setVisible(false)
			
			--正常按钮
			hApi.AddShader(_frmNode.childUI["AchievementNode0"].handle.s, "normal") --亮掉图片
		end
		_bIsPlayAds = false

		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext("PLAY FAIL", hVar.FONTC, 40, "MC", 0, 0,nil,1)
	end

	--收到广告间隔时间的回调
	on_receive_GetAdsTime = function(nPassTime)
		_nNetTime = nPassTime
		local totalTime = Code_GetTotalTime()
		current_adstime = math.max(0,totalTime - nPassTime)
		_bCanClickAds = true
		if _bIsPlayAds == false then
			Code_SetTimeAction()
		end
	end

	Code_ShowDisable = function()
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(hVar.tab_string["AndroidTestTip"], hVar.FONTC, 32, "MC", 0, 0,nil,1)
		hGlobal.event:event("LocalEvent_EnableKeypad_mainbase")
	end

	hGlobal.event:listen("LocalEvent_GetSystemMailScoreAward","getaward",function(score)
		--createGetScoreFloat(score)
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
	end)

	hGlobal.event:listen("LocalEvent_SetSystemMailData", "__setPurchaseData", function(proctol, uID, itag, dataTab)
		if type(dataTab) == "table" then
			for i = 1,#dataTab do
				local data = dataTab[i] or {}
				local prizeid = tonumber(dataTab[i].prizeid)
				local prizetype = tonumber(dataTab[i].prizetype)
				if prizetype == 11000 or prizetype == 11006 then
					print(prizeid,prizetype)
					SendCmdFunc["set_prize_list"](prizeid,luaGetplayerDataID())
					--return
				end
			end
		end
	end)

	local _xlSendIosReceipt_count = 0
	--监听打开任务、充值界面通知事件
	hGlobal.event:listen("LocalEvent_InitInAppPurchaseTipFrm_new", "__ShowChargeMoneyFrm", function()
		if hApi.IsReviewMode() then
			--审核模式显示界面
		else
			local iChannelId = xlGetChannelId()
			if iChannelId >= 100 then
				Code_ShowDisable()
				return
			end
		end
		--处理之前没有处理完毕的订单
		if xlSendIosReceipt and _xlSendIosReceipt_count == 0 then
			_xlSendIosReceipt_count = _xlSendIosReceipt_count +1
			xlSendIosReceipt()
		end
		--显示道具界面
		_frm:show(1)
		_frm:active()

		Code_InitUI()
		OnCreateChargeMoneyFrame()
		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			SendCmdFunc["GetAdsTime"]()
		end
	end)
end

--if hGlobal.UI.PhoneDiabloChargeMoneyFrm then
	--hGlobal.UI.PhoneDiabloChargeMoneyFrm:del()
	--hGlobal.UI.PhoneDiabloChargeMoneyFrm = nil
--end
--hGlobal.UI.InitDiabloChargeMoneyFrm()