



--铜雀台战斗结束抽奖界面
--打开窗口（监听）
hGlobal.event:listen("localEvent_ShowChoiceAwardFrm_PVP", "ShowChoiceAwardFrm", function(rewardInfo, parent)
	--如果父控件不存在了，不处理
	if (parent == nil) then
		return
	end
	
	local w,h = hVar.SCREEN.w+10, hVar.SCREEN.h
	local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
	local nScreenY = 0							--根据机器类型（手机，平板）调正整体位置
	if 0 == g_phone_mode then
		nScreenY = -70
	end
	local nGameDescribeX, nGameDescribeY = w/2, nScreenY-79
	local nBackGroundX, nBackGroundY = w/2, nScreenY-110
	
	--没有奖励
	if (rewardInfo == nil) or (rewardInfo.getRewardNum == 0) then
		local _CA_Frm = parent
		local _CA_Parent = _CA_Frm.handle._n
		local _childUI = _CA_Frm.childUI
		local world = hGlobal.WORLD.LastWorldMap
		
		--显示奖励背景
		if _childUI["Resource_background1"] then
			_childUI["Resource_background1"].handle._n:setVisible(true)
		end
		
		--通关时间
		_childUI["labDefProgress"] = hUI.label:new({
			parent = _CA_Parent,
			--align  = "MC",
			x = nGameDescribeX - 185 + 80,
			y = nBackGroundY - 283,
			text = hVar.tab_string["PVP_CostTime"] .. ":", --"通关时间"
			font = hVar.FONTC,
			border = 1,
			width = 300,
		})
		
		--通关时间值
		local gametime = math.ceil(world:gametime() / 1000)
		local minute = math.floor((gametime) / 60) --分
		local second = gametime - minute * 60 --秒
		local strSecond = tostring(second)
		if (#strSecond < 2) then
			strSecond = "0" .. strSecond
		end
		_childUI["labDefProgressNum"] = hUI.label:new({
			parent = _CA_Parent,
			align  = "LC",
			x = nGameDescribeX - 66 + 80,
			y = nBackGroundY - 296,
			text = (minute .. ":" .. strSecond),
			size = 20,
			font = "numWhite",
			border = 1,
			width = 300,
		})
		
		--今日可领奖次数已用完
		_childUI["labTodayRewardFinish"] = hUI.label:new({
			parent = _CA_Parent,
			align  = "MC",
			x = nGameDescribeX,
			y = nBackGroundY - 382,
			text = hVar.tab_string["__TodayRewardFinish"], --"今日可领奖次数已用完"
			font = hVar.FONTC,
			border = 1,
			width = 500,
			size = 28,
			RGB = {255,205,55},
		})
		
		return
	end
	
	--参数
	local _CA_W, _CA_H = hVar.SCREEN.w, 400
	local _CA_Y = -210
	local nScreenY = -5							--根据机器类型（手机，平板）调正整体位置
	if (0 == g_phone_mode) then --平板模式
		_CA_H = 410
		_CA_Y = -300
	end
	local _CA_Frm
	local _CA_Parent
	local _childUI
	local world = hGlobal.WORLD.LastWorldMap
	
	local _CA_nCanChoseNum = 0				--可抽取的数量
	local _CA_nCardNum = 0					--卡片总数量
	local _CA_GotLoots = {}					--获得的奖励
	local _CA_tLeftLoots = {}				--剩余奖励
	
	--local _CA_CallbackName = ""				--回调事件的名字
	local _CA_UsedCardIndexList = {}		--已抽中的索引号表
	local _CA_MissCardIndexList = {}		--未抽中的索引号表
	local _CA_NowChoseIndex = 0				--当前抽中的卡片索引号
	
	local _CA_WillBeRemove = {}				--每次会被更新的部件
	
	local _CA_bInAction = false --是否在动画中（播动画的时候屏蔽点击事件）
	
	--函数
	local _CODE_CreateGiftCard = hApi.DoNothing			--创建卡片
	local _CODE_CreateGift = hApi.DoNothing				--创建奖品
	local _CODE_OnClickCardBtn = hApi.DoNothing			--点击卡牌按钮后执行的逻辑
	local _CODE_RemoveSomeChild = hApi.DoNothing		--清理部分部件
	local _CODE_ActionOfCards = hApi.DoNothing			--翻转卡片
	local _CODE_AfterCardActionRest = hApi.DoNothing	--翻转卡片结束后的回调
	
	--主框
	--[[
	hGlobal.UI.ChoiceAwardFrm = hUI.frame:new({
		x = _CA_X,
		y = _CA_Y,
		z = 99,
		w = _CA_W,
		h = _CA_H,
		background = "UI:tip_item",
		border = 1,
		dragable = 4,
		show = 0,
	})
	]]
	_CA_Frm = parent
	_CA_Parent = _CA_Frm.handle._n
	_childUI = _CA_Frm.childUI
	
	--------------------------------------------------------------------------------------V-控件
	--领取按钮
	_childUI["button_Close"] = hUI.button:new({
		parent = _CA_Parent,
		model = "UI:ButtonBack2",
		dragbox = _childUI["dragBox"],
		label = {text = hVar.tab_string["__Get__"], size = 28, border = 1, font = hVar.FONTC}, --"领取"
		y = _CA_Y-_CA_H + 10,
		x = math.ceil(_CA_W/2),
		w = 130,
		h = 46,
		scaleT = 0.95,
		code = function(self)
			--显示领奖
			local reward = _CA_GotLoots
			--hApi.BubbleGiftAnim(_CA_GotLoots, #_CA_GotLoots, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
			
			--清理
			_CODE_RemoveSomeChild()			--奖励UI名表
			
			_CA_NowChoseIndex = 0			--当前卡片索引号
			_CA_nCanChoseNum = 0			--可抽取的数量
			_CA_nCardNum = 0			--卡片总数量
			_CA_tLoots = {}				--所有奖励表
			_CA_UsedCardIndexList = {}			--已经抽中的卡片索引表
			_CA_MissCardIndexList = {}			--未经抽中的卡片索引表
			
			--回调
			--hGlobal.event:event(_CA_CallbackName, _CA_GotLoots)
			_CA_GotLoots = {}			--抽中的奖励
			--_CA_CallbackName = ""			--回调名字
			
			_CA_bInAction = false --是否在动画中
			
			--关闭窗口
			--_CA_Frm:show(0)
			--显示闭按钮
			if _childUI["btnOk"] then
				_childUI["btnOk"]:setstate(1)
			end
			
			--显示奖励背景
			if _childUI["Resource_background1"] then
				_childUI["Resource_background1"].handle._n:setVisible(true)
			end
			
			--通关时间
			_childUI["labDefProgress"] = hUI.label:new({
				parent = _CA_Parent,
				--align  = "MC",
				x = nGameDescribeX - 185 + 80,
				y = nBackGroundY - 283,
				text = hVar.tab_string["PVP_CostTime"] .. ":", --"通关时间"
				font = hVar.FONTC,
				border = 1,
				width = 300,
			})
			
			--通关时间值
			local gametime = math.ceil(world:gametime() / 1000)
			local minute = math.floor((gametime) / 60) --分
			local second = gametime - minute * 60 --秒
			local strSecond = tostring(second)
			if (#strSecond < 2) then
				strSecond = "0" .. strSecond
			end
			_childUI["labDefProgressNum"] = hUI.label:new({
				parent = _CA_Parent,
				align  = "LC",
				x = nGameDescribeX - 66 + 80,
				y = nBackGroundY - 296,
				text = (minute .. ":" .. strSecond),
				size = 20,
				font = "numWhite",
				border = 1,
				width = 300,
			})
			
			--绘制奖励
			for i = 1, #reward, 1 do
				local rewardT = reward[i]
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				local offsetX = 110
				local scale = 1.3
				
				if (rewardT[1] == 3) then --3:道具
					--bgModel = tmpModel
					--rewardModel = sub_tmpModel
					tmpModel = "UI:item1"
					sub_tmpModel = sub_tmpModel
					itemWidth = itemWidth + 4
					itemHeight = itemHeight + 4
				end
				
				--绘制奖励控件图标
				_childUI["SubPVPMapRewardItem" .. i] = hUI.button:new({
					parent = _CA_Parent,
					model = tmpModel,
					x = nGameDescribeX - 140 + (i - 1) * offsetX * scale,
					y = nBackGroundY - 363,
					w = itemWidth * scale,
					h = itemHeight * scale,
					scaleT = 0.99,
					dragbox = _CA_Frm.childUI["dragBox"],
					code = function()
						local rewardType = rewardT[1] or 0 --获取类型
						
						--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
						if (rewardType == 1) then --1:积分
							--显示积分介绍的tip
							hApi.ShowJiFennTip()
						elseif (rewardType == 2) then --2:战术技能卡
							--显示战术技能卡tip
							local tacticId = rewardT[2] or 0
							local tacticNum = rewardT[3] or 0
							local tacticLv = rewardT[4] or 1
							hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
						elseif (rewardType == 3) then --3:道具
							--显示道具tip
							local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
						elseif (rewardType == 4) then --4:英雄
							--显示英雄tip
							local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							hGlobal.event:event("LocalEvent_HeroCardInfo", rewardT[2])
						elseif (rewardType == 5) then --5:英雄将魂
							--
						elseif (rewardType == 6) then --6:战术技能卡碎片
							--显示战术技能卡碎片tip
							local tacticId = rewardT[2] or 0
							local tacticNum = rewardT[3] or 0
							local tacticLv = rewardT[4] or 1
							hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
						elseif (rewardType == 7) then --7:游戏币(服务器处理，客户端只拼日志)
							--显示游戏币介绍的tip
							hApi.ShowGameCoinTip()
						elseif (rewardType == 8) then --8:网络宝箱(服务器处理，客户端只拼日志)
							--显示道具tip
							local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
						elseif (rewardType == 9) then --9:抽奖类战术技能卡
							--显示道具tip
							local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
						elseif (rewardType == 10) then --10:红装神器
							--显示道具tip
							local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
						elseif (rewardType == 11) then --11:神器晶石
							--显示神器晶石介绍的tip
							hApi.ShowRedEquipDeribsTip()
						end
					end,
				})
				
				--绘制奖励控件图标的子控件
				if sub_tmpModel then
					_childUI["SubPVPMapRewardItem" .. i].childUI["subIcon"] = hUI.image:new({
						parent = _childUI["SubPVPMapRewardItem" .. i].handle._n,
						model = sub_tmpModel,
						x = sub_pos_x * scale,
						y = sub_pos_y * scale,
						w = sub_pos_w * scale,
						h = sub_pos_h * scale,
					})
				end
				
				if (rewardT[1] == 3) then --3:道具
					local itemLv = 1
					local itemID = rewardT[2]
					if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
						itemLv = hVar.tab_item[itemID].itemLv
					end
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					
					local qualityModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
					
					--绘制奖励道具的品质
					_childUI["SubPVPMapRewardItem" .. i].childUI["qualityIcon"] = hUI.image:new({
						parent = _childUI["SubPVPMapRewardItem" .. i].handle._n,
						model = qualityModel,
						x = 0,
						y = 0,
						w = itemWidth * scale,
						h = itemHeight * scale,
					})
				end
				
				--绘制奖励名字
				_childUI["SubPVPMapRewardItem" .. i].childUI["name"] = hUI.label:new({
					parent = _childUI["SubPVPMapRewardItem" .. i].handle._n,
					x = 0,
					y = -43,
					size = 24,
					align = "MT",
					border = 1,
					font = hVar.FONTC,
					width = 300,
					text = itemName,
				})
				--道具为品质颜色
				if (rewardT[1] == 3) then --3:道具
					local itemID = rewardT[2]
					local itemLv = 1
					if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
						itemLv = hVar.tab_item[itemID].itemLv
					end
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				--英雄将魂为品质颜色
				elseif (rewardT[1] == 5) then --5:英雄将魂
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				--战术技能卡碎片为品质颜色
				elseif (rewardT[1] == 6) then --6:战术技能卡碎片
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				--英雄为橙色
				elseif (rewardT[1] == 4) then --4:英雄
					local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.RED].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				--战术技能卡为金色
				elseif (rewardT[1] == 2) then --2:战术技能卡
					local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.GOLD].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				--积分为白色
				elseif rewardT[1] == 1 then
					local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.WHITE].NAMERGB
					_childUI["SubPVPMapRewardItem" .. i].childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
				end
				
				--绘制奖励数量
				local sizeNum = 16
				local strNum = ("+" .. itemNum)
				if (#strNum >= 5) then
					sizeNum = 12
				end
				_childUI["SubPVPMapRewardItem" .. i].childUI["num"] = hUI.label:new({
					parent = _childUI["SubPVPMapRewardItem" .. i].handle._n,
					x = 26,
					y = -18,
					size = sizeNum,
					align = "RC",
					border = 1,
					font = "numWhite",
					width = 300,
					text = strNum,
				})
			end
			
			--浮动文字
			--冒字
			--local strText = "本次奖励已发放到邮箱！" --language
			local strText = hVar.tab_string["ios_tip_prize_reward_multy_pve_success"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
		end,
	})
	_CA_WillBeRemove[#_CA_WillBeRemove+1] = "button_Close"
	
	--头条
	_childUI["image_TitleLebar"] = hUI.image:new({
		parent = _CA_Parent,
		model = "ICON:giftcard_title",
		x = math.ceil(_CA_W/2),
		y = _CA_Y - 100,
		w = _CA_W - 80,
		h = 16,
	})
	_CA_WillBeRemove[#_CA_WillBeRemove+1] = "image_TitleLebar"
	
	--[[
	--标题
	_childUI["label_TitleName"] = hUI.label:new({
		parent = _CA_Parent,
		border = 1,
		align = "MC",
		size = 44,
		font = hVar.FONTC,
		text = hVar.tab_string["__NTEXT_ChoseGift"], --"选择奖励"
		x = _childUI["image_TitleLebar"].data.x,
		y = _childUI["image_TitleLebar"].data.y,
		RGB = {255,205,55},
	})
	_CA_WillBeRemove[#_CA_WillBeRemove+1] = "label_TitleName"
	]]
	
	--"请抽取n张奖励片"
	_childUI["label_ChoseTip"] = hUI.label:new({
		parent = _CA_Parent,
		border = 1,
		align = "MC",
		size = 44,
		font = hVar.FONTC,
		text = "", --"请抽取n张奖励片"
		RGB = {255,205,55},
		x = _childUI["image_TitleLebar"].data.x,
		y = _childUI["image_TitleLebar"].data.y,
	})
	_CA_WillBeRemove[#_CA_WillBeRemove+1] = "label_ChoseTip"
	
	--卡片背景
	_childUI["image_CardBg"] = hUI.image:new({
		parent = _CA_Parent,
		model = "ICON:giftcard_bg",
		x = math.ceil(_CA_W/2),
		y = _CA_Y - 240,
		w = _CA_W,
		h = 190,
	})
	_CA_WillBeRemove[#_CA_WillBeRemove+1] = "image_CardBg"
	
	--------------------------------------------------------------------------------------V-函数
	--清理部件
	_CODE_RemoveSomeChild = function()
		for i =1, #_CA_WillBeRemove do
			hApi.safeRemoveT(_childUI, _CA_WillBeRemove[i])
		end
		_CA_WillBeRemove = {}
	end

	--抽卡结束后的处理
	_CODE_AfterCardActionRest = function()
		--抽卡已完成
		if (#_CA_UsedCardIndexList >= _CA_nCanChoseNum) then
			--显示剩余的未抽中的卡牌
			for i = 1, _CA_nCardNum, 1 do
				local _reward = _childUI["button_Card"..i].data._reward
				if (_reward == 0) then --未处理的
					--保存到玩家未抽中的片列表中
					_CA_MissCardIndexList[#_CA_MissCardIndexList+1] = i
					
					--显示本次未抽中结果
					_CODE_CreateGift(i, _CA_tLeftLoots, #_CA_MissCardIndexList)
					
					--动画翻转卡牌
					_CODE_ActionOfCards(i, _CODE_AfterCardActionMiss)
				end
			end
		end
		
		--放开触摸
		_CA_bInAction = false --是否在动画中
	end
	
	--未抽中结束后的处理
	_CODE_AfterCardActionMiss = function()
		--打开关闭按钮
		_childUI["button_Close"]:setstate(1)
	end
	
	--创建卡牌的奖品
	_CODE_CreateGift = function(index, t, tIdx)
		--print("显示本次抽卡结果")
		--创建卡片
		local nCardY = -240
		local i = index
		local tAward = t[tIdx]
		--print(unpack(tAward))
		--打开后的卡片
		_childUI["node_ShowCard"..i] = hUI.node:new({
			parent = _CA_Parent,
			x = _childUI["image_CardCap"..i].data.x,
			y = _childUI["image_CardCap"..i].data.y,
		})
		_childUI["node_ShowCard"..i].handle._n:setVisible(false)
		
		_CA_WillBeRemove[#_CA_WillBeRemove+1] = "node_ShowCard"..i
		
		--底板
		_childUI["node_ShowCard"..i].childUI["image_CardBgBig"] = hUI.image:new({
			parent = _childUI["node_ShowCard"..i].handle._n,
			model = "ICON:giftcard_3",
			x = 0,
			y = 0,
			w = -1,
			h = -1,
		})
		
		local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(tAward)
		
		--图标
		local scale = 1.6
		_childUI["node_ShowCard"..i].childUI["icon_Card"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _childUI["node_ShowCard"..i].handle._n,
			border = 1,
			model = tmpModel,
			x = 0,
			y = 20,
			w = itemWidth * scale,
			h = itemHeight * scale,
		})
		--绘制奖励图标的子控件
		if sub_tmpModel then
			_childUI["node_ShowCard"..i].childUI["icon_Card"].childUI["subIcon"] = hUI.image:new({
				parent = _childUI["node_ShowCard"..i].childUI["icon_Card"].handle._n,
				model = sub_tmpModel,
				x = sub_pos_x * scale,
				y = sub_pos_y * scale,
				w = sub_pos_w * scale,
				h = sub_pos_h * scale,
			})
		end
		
		--名字
		local nameSize = 22
		if (#itemName >= 14) then
			nameSize = 18
		end
		local tRGB = {255,255,255}
		_childUI["node_ShowCard"..i].childUI["label_CardName"] = hUI.label:new({
			parent = _childUI["node_ShowCard"..i].handle._n,
			border = 1,
			align = "MC",
			size = nameSize,
			font = hVar.FONTC,
			text = itemName,
			RGB = tRGB,
			x = 0,
			y = -42,
		})
		
		--数量
		local numSize = 20
		local strNum = "+" .. itemNum
		if (#strNum >= 5) then
			numSize = 16
		end
		_childUI["node_ShowCard"..i].childUI["label_CardNum"] = hUI.label:new({
			parent = _childUI["node_ShowCard"..i].handle._n,
			border = 0,
			align = "RC",
			size = numSize,
			font = "numWhite",
			text = strNum,
			x = 31,
			y = -1,
		})
		
		--存储抽卡结果
		_childUI["button_Card"..i].data._reward = tAward
	end
	
	--翻转此卡片
	_CODE_ActionOfCards = function(index, callback)
		local i = index
		
		if _childUI["node_ShowCard"..i] then
			--旋转
			local nextstep = function()
				_childUI["image_CardCap"..i].handle._n:setVisible(false)
				_childUI["node_ShowCard"..i].handle._n:setVisible(true)
				
				--设置暗颜色
				local nIsSetNameC = 1
				for j =1, #_CA_UsedCardIndexList do
					if i == _CA_UsedCardIndexList[j] then
						nIsSetNameC = 0 
						break
					end
				end
				if 1 == nIsSetNameC then
					--未抽中的灰掉
					
					--图标
					if _childUI["node_ShowCard"..i].childUI["icon_Card"] then
						_childUI["node_ShowCard"..i].childUI["icon_Card"].handle.s:setColor(ccc3(192, 192, 192))
						
						--子控件
						if _childUI["node_ShowCard"..i].childUI["icon_Card"].childUI["subIcon"] then
							_childUI["node_ShowCard"..i].childUI["icon_Card"].childUI["subIcon"].handle.s:setColor(ccc3(192, 192, 192))
						end
					end
					
					--名字
					if _childUI["node_ShowCard"..i].childUI["label_CardName"] then
						_childUI["node_ShowCard"..i].childUI["label_CardName"].handle.s:setColor(ccc3(192, 192, 192))
					end
					
					--数量
					if _childUI["node_ShowCard"..i].childUI["label_CardNum"] then
						_childUI["node_ShowCard"..i].childUI["label_CardNum"].handle.s:setColor(ccc3(192, 192, 192))
					end
				end
				_childUI["node_ShowCard"..i].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,-1,0,90,90,0,0),CCCallFunc:create(callback)))
			end
			
			--将第一片翻转一半
			_childUI["image_CardCap"..i].handle.s:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,1,0,0,90,0,0),CCCallFunc:create(nextstep)))
		end
	end
	
	--完成一次抽卡展示
	local _CODE_CompleteSelection = function()
		--显示本次抽卡结果
		_CODE_CreateGift(_CA_NowChoseIndex, _CA_GotLoots, #_CA_UsedCardIndexList)
		
		--各种动画效果
		_childUI["break_down_eff_".._CA_NowChoseIndex] =hUI.image:new({
			parent = _CA_Parent,
			model = "MODEL_EFFECT:break_down",
			x = _childUI["image_CardCap".._CA_NowChoseIndex].data.x,
			y = _childUI["image_CardCap".._CA_NowChoseIndex].data.y,
			w = 180,
			h = 180,
		})
		hApi.addTimerOnce("break_down_eff", 250,function()
			hApi.safeRemoveT(_childUI,"break_down_eff_".._CA_NowChoseIndex)
		end)
		
		--动画翻转卡牌
		_CODE_ActionOfCards(_CA_NowChoseIndex, _CODE_AfterCardActionRest)
		
		--播放音效
		hApi.PlaySound("eff_pickup")
	end
	
	--创建卡片
	_CODE_CreateGiftCard = function()
		--设置可选择数量
		local sText = string.gsub(hVar.tab_string["__NTEXT_PleaseChoseXCard"], "n", _CA_nCanChoseNum)
		_childUI["label_ChoseTip"]:setText(sText)
		
		--清除上次界面
		--_CODE_RemoveSomeChild()
		
		--创建卡片
		local tCardX = hApi.GetCenterAlignmentPosition(_CA_W/2, 140)
		local nCardY = _CA_Y - 240
		for i = 1, _CA_nCardNum, 1 do
			--卡片
			_childUI["image_CardCap"..i] = hUI.image:new({
				parent = _CA_Parent,
				model = "ICON:giftcard_1",
				x = tCardX[_CA_nCardNum][i],
				y = nCardY,
				w = -1,
				h = -1,
			})
			_CA_WillBeRemove[#_CA_WillBeRemove+1] = "image_CardCap"..i
			
			--透明按钮
			_childUI["button_Card"..i] = hUI.button:new({
				parent = _CA_Parent,
				model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				x = tCardX[_CA_nCardNum][i],
				y = nCardY,
				w = 118,
				h = 148,
				code = function(self)
					--点击卡牌
					_CODE_OnClickCardBtn(self, i)
				end,
			})
			_childUI["button_Card"..i].handle.s:setOpacity(0) --只响应事件，不显示
			_CA_WillBeRemove[#_CA_WillBeRemove+1] = "button_Card"..i
			
			--标记此卡牌对应的奖励
			_childUI["button_Card"..i].data._reward = 0
		end
	end
	
	--点击卡片按钮
	_CODE_OnClickCardBtn = function(btn, index)
		if _CA_bInAction then
			--print("禁止触摸中...")
			return
		end
		
		local i = index
		
		--判断是否已被抽中
		local _reward = _childUI["button_Card"..i].data._reward
		
		--抽取卡片
		if (_reward == 0) then --没抽中
			--禁止触摸
			_CA_bInAction = true --是否在动画中
			
			--记录
			_CA_NowChoseIndex = i					--记录当前抽中的卡片索引号
			_CA_UsedCardIndexList[#_CA_UsedCardIndexList+1] = i		--保存到玩家已抽中的片列表中
			
			--移动位置
			_childUI["button_Card"..i]:setXY(_childUI["button_Card"..i].data.x, _childUI["button_Card"..i].data.y+40)
			_childUI["image_CardCap"..i].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2, ccp(_childUI["image_CardCap"..i].data.x, _childUI["image_CardCap"..i].data.y+40)),CCCallFunc:create(_CODE_CompleteSelection)))
			_childUI["image_CardCap"..i].data.y = _childUI["image_CardCap"..i].data.y +40
		else --显示Tip
			local rewardT = _reward
			
			if rewardT then
				local rewardType = rewardT[1]
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
				if (rewardType == 1) then --1:积分
					--显示积分介绍的tip
					hApi.ShowJiFennTip()
				elseif (rewardType == 2) then --2:战术技能卡
					--显示战术技能卡tip
					local tacticId = rewardT[2] or 0
					local tacticNum = rewardT[3] or 0
					local tacticLv = rewardT[4] or 1
					hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
				elseif (rewardType == 3) then --3:道具
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 4) then --4:英雄
					--显示英雄tip
					local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_HeroCardInfo", rewardT[2])
				elseif (rewardType == 5) then --5:英雄将魂
					--
				elseif (rewardType == 6) then --6:战术技能卡碎片
					--显示战术技能卡碎片tip
					local tacticId = rewardT[2] or 0
					local tacticNum = rewardT[3] or 0
					local tacticLv = rewardT[4] or 1
					hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
				elseif (rewardType == 7) then --7:游戏币(服务器处理，客户端只拼日志)
					--显示游戏币介绍的tip
					hApi.ShowGameCoinTip()
				elseif (rewardType == 8) then --8:网络宝箱(服务器处理，客户端只拼日志)
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 9) then --9:抽奖类战术技能卡
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 10) then --10:红装神器
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 11) then --11:神器晶石
					--显示神器晶石介绍的tip
					hApi.ShowRedEquipDeribsTip()
				end
			end
		end
	end

	local getRewardNum = rewardInfo.getRewardNum --奖励的数量
	local getIdxList = rewardInfo.getIdxList --奖励的索引列表
	local allRewardNum = rewardInfo.allRewardNum --所有抽奖数量
	local allReward = rewardInfo.allReward --所有奖励表
	
	--存储可抽取的数量
	_CA_nCanChoseNum = getRewardNum
	
	--存储卡片总数
	_CA_nCardNum = allRewardNum
	
	--存储获得的奖励
	_CA_GotLoots = {}
	for j = 1, getRewardNum, 1 do
		local rewardIdx = getIdxList[j]
		_CA_GotLoots[j] = allReward[rewardIdx]
	end
	
	--存储剩余奖励
	_CA_tLeftLoots = {}
	for i = 1, allRewardNum, 1 do
		--检测次索引是不是发奖的idx
		local bIsReward = false
		for j = 1, getRewardNum, 1 do
			local rewardIdx = getIdxList[j]
			if (rewardIdx == i) then
				bIsReward = true
				break
			end
		end
		if (not bIsReward) then
			_CA_tLeftLoots[#_CA_tLeftLoots+1] = allReward[i]
		end
	end
	
	--创建卡
	_CODE_CreateGiftCard(getRewardNum, allRewardNum)
	
	--隐藏关闭按钮
	_childUI["button_Close"]:setstate(0)
	
	--显示本界面
	_CA_Frm:show(1, "fade")
	_CA_Frm:active()
	
	--先隐藏关闭按钮
	if _childUI["btnOk"] then
		_childUI["btnOk"]:setstate(-1)
	end
	
	--创建奖品
	--_CODE_CreateGift(tItem)
	
	--翻转所有的卡片
	--_CODE_ActionOfCards()
end)

--[[
--测试 --test
if hGlobal.UI.ChoiceAwardFrm then
	hGlobal.UI.ChoiceAwardFrm:del()
	hGlobal.UI.ChoiceAwardFrm = nil
end
local rewardInfo = 
{
	getRewardNum = 3,
	getIdxList = {2, 5, 1},
	allRewardNum = 5,
	allReward = 
	{
		{1,1000,},
		{2,1005,1,1,},
		{3,11024,1,},
		{6,10402,30,1},
		{11, 20,},
	},
}
hGlobal.event:event("localEvent_ShowChoiceAwardFrm", rewardInfo, hGlobal.UI.__GameOverPanel_pvp)
]]
