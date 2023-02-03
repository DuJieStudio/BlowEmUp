-----------------------------------
--手机地图信息面板
-----------------------------------

--[[
--解锁地图包 信息面板
hGlobal.UI.InitUnlockMapBagFrm = function()
	local _w,_h = 420,290
	hGlobal.UI.PhoneUnlockMapBagFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2-_w/2,
		y = hVar.SCREEN.h/2+_h/2,
		dragable = 2,
		w = _w,
		h = _h,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		--background = "UI:tip_item",
		border = 1,
		autoactive = 0,
	})
	local _frm = hGlobal.UI.PhoneUnlockMapBagFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--=title
	--_childUI["tipLab1"] =  hUI.label:new({
		--parent = _parent,
		--x = _frm.data.w/2,
		--y = -30,
		--text = hVar.tab_string["__TEXT_BuyMapPack"],
		--size = 26,
		--width = 300,
		--font = hVar.FONTC,
		--align = "MC",
		--border = 1,
	--})

	--提示文字1
	_childUI["tipLab2"] =  hUI.label:new({
		parent = _parent,
		x = 30,
		y = -74,
		text = "",
		size = 26,
		width = 390,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	--游戏币图标
	_childUI["game_coins_node"] = hUI.node:new({
		parent = _parent,
		x = _frm.data.w/2 - 120,
		y = -_frm.data.h + 112,
	})
	
	_childUI["game_coins_node"].childUI["image"] = hUI.image:new({
		parent = _childUI["game_coins_node"].handle._n,
		model = "UI:game_coins",
		scale = 0.8,
	})
	
	_childUI["game_coins_node"].childUI["lab"] = hUI.label:new({
		parent = _childUI["game_coins_node"].handle._n,
		size = 24,
		align = "LT",
		x = 20,
		y = 10,
		width = 500,
		border = 1,
		text = "",
	})

	--_childUI["tipLabEnd"] =  hUI.label:new({
		--parent = _parent,
		--x = _frm.data.w/2+ 70,
		--y = -_frm.data.h + 80,
		--text = hVar.tab_string["__TEXT_unlock"],
		--size = 26,
		--width = 380,
		--font = hVar.FONTC,
		--align = "MC",
		--border = 1,
	--})

	--确定按钮
	local _mapBagName = ""
	_childUI["confirmBtn"] =  hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		label = hVar.tab_string["__TEXT_Confirm"],
		x = _frm.data.w/2-90,
		y = -_frm.data.h + 66,
		scaleT = 0.9,
		w = 104,
		h = 42,
		border = 1,
		font = hVar.FONTC,
		code = function(self)
			self:setstate(0)
			if g_cur_net_state ~= 1 then return end
			_frm:show(0)
			local price = hVar.MAP_INFO[_mapBagName].price
			local itemID = hVar.MAP_INFO[_mapBagName].itemID

			--local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--if g_tTargetPlatform.kTargetWindows == TargetPlatform then
				--price = 1
			--end
			if price == nil then
				price = hVar.MAP_INFO[hVar.MAP_INFO[_mapBagName].DLCKey].price
				itemID = hVar.MAP_INFO[hVar.MAP_INFO[_mapBagName].DLCKey].itemID
			end
			--SendCmdFunc["buy_shopitem"](itemID,price,_mapBagName,0)
			SendCmdFunc["order_begin"](6,itemID,price,1,_mapBagName,0,0,nil)
		end,
	})

	--取消按钮
	_childUI["cancelBtn"] =  hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		w = 104,
		h = 42,
		font = hVar.FONTC,
		label = hVar.tab_string["__TEXT_Cancel"],
		x = _frm.data.w/2+84,
		y = -_frm.data.h + 66,
		scaleT = 0.9,
		border = 1,
		code = function()
			_frm:show(0)
		end,
	})
	
	--打开解锁地图界面
	hGlobal.event:listen("LocalEvent_Phone_ShowUnlockMapBagFrm","Phone_ShowUnlockMapBagFrm",function(mapName,mode)
		_mapBagName = mapName
		local unlockText = hVar.tab_stringM[mapName][4]
		_childUI["tipLab2"]:setText(unlockText)
		--if mode == 1 then
			--_childUI["tipLab1"]:setText(hVar.tab_string["__TEXT_BuyMapPack1"])
		--else
			--_childUI["tipLab1"]:setText(hVar.tab_string["__TEXT_BuyMapPack"])
		--end
		
		local price = hVar.MAP_INFO[mapName].price
		if price == nil then
			price = hVar.MAP_INFO[hVar.MAP_INFO[mapName].DLCKey].price
		end
		--local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--if g_tTargetPlatform.kTargetWindows == TargetPlatform then
			--price = 1
		--end
		
		_childUI["game_coins_node"].childUI["lab"]:setText("x "..tostring(price))
		_childUI["confirmBtn"]:setstate(1)
		_frm:show(1)
		_frm:active()
	end)
end
]]




--普通关卡信息面板
hGlobal.UI.InitMapInfoFrm = function()
	
	local _w, _h = 880, 590
	local _removeFunc = hApi.DoNothing
	local _switchPage = hApi.DoNothing
	local _refreshStarReward = hApi.DoNothing
	local _refreshSubPage = hApi.DoNothing
	local _refreshMapInfo = hApi.DoNothing
	
	--逻辑控制变量，当前选择关卡模式
	local __MAP_NAME = ""
	local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
	local __MAPDIFF = 0
	
	hGlobal.UI.PhoneMapInfoFrm = hUI.frame:new({
		dragable = 2,
		x = hVar.SCREEN.w/2 - 440,
		y = hVar.SCREEN.h/2 + 285,
		w = _w,
		h = _h,
		show = 0,
		background = "UI:tip_item",
		border = 1,
		codeOnTouch = function(self,x,y,sus)
			--在外部点击
			if (sus == 0) then
				local lastNamName = __MAP_NAME
				__MAP_NAME = ""
				__MAPMODE = hVar.MAP_TD_TYPE.NORMAL
				__MAPDIFF = 0
				self:show(0)
				_removeFunc()
				
				--geyachao: 通知事件: 关闭查看某一关介绍的面板
				hGlobal.event:event("LocalEvent_Phone_HideMapInfoFrm", lastNamName)
				--print("关闭查看某一关介绍的面板")
			end
		end,
	})
	
	local _frm = hGlobal.UI.PhoneMapInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--临时UI管理
	local removeList = {}
	--清空所有临时UI
	local _removeFunc = function()
		for i = 1,#removeList do
			hApi.safeRemoveT(_childUI,removeList[i]) 
		end
		removeList = {}
	end
	
	--面板的关闭方法
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w-12,
		y = -12,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		code = function()
			local lastNamName = __MAP_NAME
			__MAP_NAME = ""
			__MAPMODE = hVar.MAP_TD_TYPE.NORMAL
			__MAPDIFF = 0
			--FrmGB:show(0)
			_frm:show(0)
			_removeFunc()
			
			--geyachao: 通知事件: 关闭查看某一关介绍的面板
			hGlobal.event:event("LocalEvent_Phone_HideMapInfoFrm", lastNamName)
			--print("关闭查看某一关介绍的面板")
		end,
	})
	
	--关卡名称
	_childUI["mapName"] = hUI.node:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = 10,
	})
	
	_childUI["mapName"].childUI["img"] = hUI.image:new({
		parent = _childUI["mapName"].handle._n,
		model = "UI:MedalDarkImg",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = 0,
		w = 200,
		h = 41,
	})
	
	_childUI["mapName"].childUI["lab"] = hUI.label:new({
		parent = _childUI["mapName"].handle._n,
		x = 0,
		y = 0,
		text = "",
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,205,55},
		border = 1,
	})
	
	--[[
	--地图信息前缀
	_childUI["labMapInfoTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -120,
		text = hVar.tab_string["__TEXT_MAP_INFO"], --"地图信息"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	]]
	
	--地图信息内容
	_childUI["mapInfo"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -130,
		text = "",
		size = 26,
		width = 806,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	--分割线
	_childUI["imgLine"] = hUI.image:new({
		parent = _parent,
		model = "UI:title_line",
		x = 454,
		y = -120,
		w = 808,
		h = 4,
	})
	
	--模式选择前缀
	_childUI["labMapType"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -80 + 24,
		text = hVar.tab_string["__TEXT_SELECT_MAP_MODE"], --"模式选择"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--剧情模式按钮
	_childUI["btnPageNormal"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = 230,
		y = -70,
		w = 94,
		h = 120,
		scaleT = 0.95,
		font = hVar.FONTC,
		code = function(self)
			if (__MAPMODE ~= hVar.MAP_TD_TYPE.NORMAL) then
				_switchPage(hVar.MAP_TD_TYPE.NORMAL)
			end
		end,
	})
	_childUI["btnPageNormal"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--剧情模式背景图
	_childUI["btnPageNormal"].childUI["img"] = hUI.image:new({
		parent = _childUI["btnPageNormal"].handle._n,
		model = "ui/pvp/banner.png",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = -4,
		scale = 0.7,
	})
	
	--剧情模式文字
	_childUI["btnPageNormal"].childUI["labText"] = hUI.label:new({
		parent = _childUI["btnPageNormal"].handle._n,
		x = -15,
		y = 35 - 3,
		text = hVar.tab_string["__TEXT_BTN_STROY_MODE"], --"剧情"
		size = 26,
		width = 30,
		font = hVar.FONTC,
		border = 1,
		align = "LT",
	})
	
	--剧情模式选中的勾勾
	_childUI["btnPageNormal"].childUI["imgSelected"] = hUI.image:new({
		parent = _childUI["btnPageNormal"].handle._n,
		model = "UI:ok",
		--model = "misc/tipMinBG.png",
		x = 10,
		y = -15,
		scale = 0.8,
	})
	_childUI["btnPageNormal"].childUI["imgSelected"].handle._n:setVisible(true) --一开始隐藏剧情模式选中的勾勾
	
	--挑战难度模式提示按钮（未解锁时会显示）
	_childUI["btnPageDiffTipInfo"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = 325,
		y = -70,
		w = 94,
		h = 120,
		scaleT = 0.95,
		code = function(self)
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP"],{
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
		end,
	})
	_childUI["btnPageDiffTipInfo"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--挑战难度模式提示按钮（未解锁时会显示）背景图
	_childUI["btnPageDiffTipInfo"].childUI["img"] = hUI.image:new({
		parent = _childUI["btnPageDiffTipInfo"].handle._n,
		model = "ui/pvp/banner.png",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = -4,
		scale = 0.7,
	})
	
	--挑战模式按钮
	_childUI["btnPageDiff"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = 325,
		y = -70,
		z = 1,
		w = 94,
		h = 120,
		scaleT = 0.95,
		font = hVar.FONTC,
		border = 1,
		code = function(self)
			--如果未解锁则不能点击
			if self.data.diffLock then
				return
			end
			
			if (__MAPMODE ~= hVar.MAP_TD_TYPE.DIFFICULT) then
				_switchPage(hVar.MAP_TD_TYPE.DIFFICULT)
			end
		end,
	})
	_childUI["btnPageDiff"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--挑战模式背景图
	_childUI["btnPageDiff"].childUI["img"] = hUI.image:new({
		parent = _childUI["btnPageDiff"].handle._n,
		model = "ui/pvp/banner.png",
		x = 0,
		y = -4,
		scale = 0.7,
	})
	
	--挑战模式按钮文字
	_childUI["btnPageDiff"].childUI["labText"] = hUI.label:new({
		parent = _childUI["btnPageDiff"].handle._n,
		x = -15,
		y = 35 - 3,
		text = hVar.tab_string["__TEXT_BTN_DIFF_MODE"], --"挑战"
		size = 26,
		width = 30,
		font = hVar.FONTC,
		border = 1,
		align = "LT",
	})
	
	--挑战模式选中的勾勾
	_childUI["btnPageDiff"].childUI["imgSelected"] = hUI.image:new({
		parent = _childUI["btnPageDiff"].handle._n,
		model = "UI:ok",
		--model = "misc/tipMinBG.png",
		x = 10,
		y = -15,
		scale = 0.8,
	})
	_childUI["btnPageDiff"].childUI["imgSelected"].handle._n:setVisible(false) --一开始不显示挑战模式选中的勾勾
	
	--关卡奖励前缀
	_childUI["labScoreRewardTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -215 + 13,
		text = hVar.tab_string["__TEXT_ITEM_TYPE_REWARD"],--"奖励"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--积分响应区域按钮
	_childUI["btnScore"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = 280,
		y = -215,
		z = 1,
		w = 198,
		h = 50,
		scaleT = 0.95,
		code = function(self)
			--显示积分介绍的tip
			hApi.ShowJiFennTip()
		end,
	})
	_childUI["btnScore"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--积分图标
	_childUI["btnScore"].childUI["imgScoreRewardTip"] = hUI.image:new({
		parent = _childUI["btnScore"].handle._n,
		model = "UI:score",
		x = -50,
		y = 0,
		scale = 0.6,
	})
	
	--积分值
	_childUI["btnScore"].childUI["labScoreReward"] = hUI.label:new({
		parent = _childUI["btnScore"].handle._n,
		x = -20,
		y = 10,
		text = "+0",
		size = 20,
		--font = hVar.FONTC,
		font = "numGreen",
		align = "LT",
		--RGB = {0,255,0},
	})
	
	--经验响应区域按钮
	_childUI["btnExp"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = 480,
		y = -215,
		z = 1,
		w = 198,
		h = 50,
		scaleT = 0.95,
		code = function(self)
			--显示英雄经验值介绍的tip
			hApi.ShowHeroExpTip()
		end,
	})
	_childUI["btnExp"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--经验图标
	_childUI["btnExp"].childUI["imgExpRewardTip"] = hUI.image:new({
		parent = _childUI["btnExp"].handle._n,
		model = "ICON:HeroAttr",
		x = -50,
		y = -5,
		scale = 0.7,
	})
	
	--经验值
	_childUI["btnExp"].childUI["labExpReward"] = hUI.label:new({
		parent = _childUI["btnExp"].handle._n,
		x = -20,
		y = 6,
		text = "+0",
		size = 20,
		--font = hVar.FONTC,
		font = "num",
		align = "LT",
		--RGB = {0,255,0},
	})
	
	--首次通关奖励前缀
	_childUI["labFirstRewardTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -300,
		text = hVar.tab_string["__FirstTimeReward__"],--"首通奖励"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--星级奖励
	for i = 1, 3, 1 do
		--奖励节点（只用于控制，不显示）
		_childUI["starReward" .. tostring(i)] = hUI.button:new({
			parent = _frm,
			x = 240 + (i - 1) * (128 + 36),
			y = -310,
			scaleT = 0.95,
			w = 156,
			h = 128,
			model = "misc/mask.png",
			code = function(self)
				local rewardType = self.data.rewardType
				local rewardId = self.data.rewardId
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
				if (rewardType == 1) then --1:积分
					--显示积分介绍的tip
					hApi.ShowJiFennTip()
				elseif (rewardType == 2) then --2:战术技能卡
					--显示战术技能卡tip
					hApi.ShowTacticCardTip(rewardType, rewardId, 1)
				elseif (rewardType == 3) then --3:道具
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardId, 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 4) then --4:英雄
					--显示英雄tip
					local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_HeroCardInfo", rewardId)
				elseif (rewardType == 5) then --5:英雄将魂
					--
				elseif (rewardType == 6) then --6:战术技能卡碎片
					--显示战术技能卡碎片tip
					hApi.ShowTacticCardTip(rewardType, rewardId, 1)
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
		_childUI["starReward"..tostring(i)].data.rewardType = 0 --geyachao: 用于点击事件，查看奖励的东西的属性
		_childUI["starReward"..tostring(i)].data.rewardId = 0 --geyachao: 用于点击事件，查看奖励的东西的属性
		_childUI["starReward" .. tostring(i)].handle.s:setOpacity(0) --只响应事件，不显示
		
		--子节点
		local IconOffsetY = 0
		local rewardNode = _childUI["starReward"..tostring(i)]
		
		--背景
		rewardNode.childUI["imgBg"] = hUI.image:new({
			parent = rewardNode.handle._n,
			--model = "panel/card_back.png",
			model = -1,
			--model = "UI:slotBig",
			x = 0,
			y = 0 + IconOffsetY,
		})
		--rewardNode.childUI["imgBg"].handle._n:setVisible(false)
		
		rewardNode.childUI["imgBanner"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "UI:ico_tactics_other",
			x = -2,
			y = 48 + IconOffsetY,
		})
		rewardNode.childUI["imgBanner"].handle._n:setVisible(false)
		
		--边框
		rewardNode.childUI["imgSlot"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "UI_frm:slot",
			animation = "light",
			x = 1,
			y = -1 + IconOffsetY,
			w = 78,
			h = 78,
		})
		rewardNode.childUI["imgSlot"].handle._n:setVisible(false)
		
		--奖励图标
		rewardNode.childUI["img"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "ICON:skill_icon1_x3y3",
			x = 0,
			y = 0 + IconOffsetY,
			w = 72,
			h = 72,
		})
		
		--道具品质颜色
		rewardNode.childUI["itemQuality"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "ICON:skill_icon1_x3y3",
			x = 0,
			y = 0 + IconOffsetY,
			w = 72,
			h = 72,
		})
		rewardNode.childUI["itemQuality"].handle._n:setVisible(false)
		
		--碎片图标
		rewardNode.childUI["imgDebris"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "UI:SoulStoneFlag",
			x = 19,
			y = -10 + IconOffsetY,
			scale = 1.3,
		})
		rewardNode.childUI["imgDebris"].handle._n:setVisible(false)
		--rewardNode.childUI["imgDebris"].handle._n:setRotation(60)
		
		--[[
		--奖励名称
		rewardNode.childUI["name"] = hUI.label:new({
			parent = rewardNode.handle._n,
			x = 0,
			y = -50,
			text = "",
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			--RGB = {0,255,0},
			border = 1,
			width = 250,
		})
		]]
		
		--奖励名称
		rewardNode.childUI["name"] = hUI.label:new({
			parent = rewardNode.handle._n,
			x = 38,
			y = -20 + IconOffsetY,
			text = "",
			size = 20,
			font = "numWhite",
			align = "LC",
			--RGB = {0,255,0},
			border = 1,
			width = 250,
		})
		
		--三个星
		for j = 1, i, 1 do
			rewardNode.childUI["star_"..tostring(j)] = hUI.image:new({
				parent = rewardNode.handle._n,
				model = "UI:STAR_YELLOW",
				x = (i - 1) * (-10) + (j - 1) * 20,
				y = -85 + 35 + IconOffsetY,
				w = 24,
				h = 24,
			})
		end
		
		--是否已领取"(已领取)"
		rewardNode.childUI["flag"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "UI:FinishTag",
			x = 8,
			y = -11 + IconOffsetY,
			w = 70,
			h = 60,
		})
	end
	
	--难度选择前缀
	_childUI["labDiffSelectTip"] = hUI.label:new({
		parent = _parent,
		x = 450,
		y = -70 + 14,
		text = hVar.tab_string["__TEXT_SELECTDIFF"], --"难度选择"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--难度选择值
	_childUI["labDiff"] = hUI.label:new({
		parent = _parent,
		x = 680,
		y = -70 + 15,
		text = "1",
		size = 28,
		width = 340,
		font = "numWhite",
		align = "LT",
	})
	
	--翻页按钮左（只用于控制，不显示）
	_childUI["btnDiff_L"] = hUI.button:new({
		parent = _frm,
		model = "misc/mask.png",
		x = 625,
		y = -70,
		w = 90,
		h = 120,
		scaleT = 0.95,
		code = function(self)
			if (__MAPDIFF > 1) then
				__MAPDIFF = __MAPDIFF - 1
				_refreshSubPage(__MAP_NAME)
			end
		end,
	})
	_childUI["btnDiff_L"].handle.s:setOpacity(0) --只响应事件，不显示
	--翻页图片左
	_childUI["btnDiff_L"].childUI["icon"] = hUI.image:new({
		parent = _childUI["btnDiff_L"].handle._n,
		model = "UI:playerBagD",
		x = 15,
		y = 0,
		scale = 1.2,
	})
	_childUI["btnDiff_L"].childUI["icon"].handle.s:setFlipX(true)
	_childUI["btnDiff_L"].childUI["icon"].handle._n:setRotation(90)
	local moveLeft = CCMoveTo:create(0.5, ccp(11, 0))
	local moveRight = CCMoveTo:create(0.5, ccp(15, 0))
	local actSeq = CCSequence:createWithTwoActions(moveLeft, moveRight)
	_childUI["btnDiff_L"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
	
	--翻页图片左（灰）
	_childUI["btnDiff_L"].childUI["iconGray"] = hUI.image:new({
		parent = _childUI["btnDiff_L"].handle._n,
		model = "UI:playerBagD",
		x = 15,
		y = 0,
		scale = 1.2,
	})
	_childUI["btnDiff_L"].childUI["iconGray"].handle.s:setFlipX(true)
	_childUI["btnDiff_L"].childUI["iconGray"].handle._n:setRotation(90)
	--hApi.AddShader(_childUI["btnDiff_L"].childUI["iconGray"].handle.s, "gray")
	_childUI["btnDiff_L"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
	_childUI["btnDiff_L"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
	
	--翻页按钮右（只用于控制，不显示）
	_childUI["btnDiff_R"] = hUI.button:new({
		parent = _frm,
		model = "misc/mask.png",
		x = 755,
		y = -70,
		w = 90,
		h = 120,
		scaleT = 0.95,
		code = function(self)
			local mapTab = hVar.MAP_INFO[__MAP_NAME]
			local diffInfo = mapTab.DiffMode or {}
			local diffMax = diffInfo.maxDiff or 1
			if (__MAPDIFF < diffMax) then
				__MAPDIFF = __MAPDIFF + 1
				_refreshSubPage(__MAP_NAME)
			end
		end,
	})
	_childUI["btnDiff_R"].handle.s:setOpacity(0) --只响应事件，不显示
	--翻页图片右
	_childUI["btnDiff_R"].childUI["icon"] = hUI.image:new({
		parent = _childUI["btnDiff_R"].handle._n,
		model = "UI:playerBagD",
		x = -15,
		y = 0,
		scale = 1.2,
	})
	_childUI["btnDiff_R"].childUI["icon"].handle.s:setFlipX(true)
	_childUI["btnDiff_R"].childUI["icon"].handle._n:setRotation(-90)
	local moveRight = CCMoveTo:create(0.5, ccp(-11, 0))
	local moveLeft = CCMoveTo:create(0.5, ccp(-15, 0))
	local actSeq = CCSequence:createWithTwoActions(moveRight, moveLeft)
	_childUI["btnDiff_R"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
	
	--翻页图片右（灰）
	_childUI["btnDiff_R"].childUI["iconGray"] = hUI.image:new({
		parent = _childUI["btnDiff_R"].handle._n,
		model = "UI:playerBagD",
		x = -15,
		y = 0,
		scale = 1.2,
	})
	_childUI["btnDiff_R"].childUI["iconGray"].handle.s:setFlipX(true)
	_childUI["btnDiff_R"].childUI["iconGray"].handle._n:setRotation(-90)
	--hApi.AddShader(_childUI["btnDiff_R"].childUI["iconGray"].handle.s, "gray")
	_childUI["btnDiff_R"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
	_childUI["btnDiff_R"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
	
	--挑战关卡几率掉落前缀
	_childUI["labRadomDropTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -420,
		text = hVar.tab_string["__RandDrop__"],--"随机奖励"
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--挑战关卡几率掉落的道具
	for i = 1, 4, 1 do
		--奖励节点（只用于控制，不显示）
		_childUI["randDrop" .. i] = hUI.button:new({
			parent = _frm,
			x = 240 + (i - 1) * (128 + 36),
			y = -440,
			scaleT = 0.95,
			w = 156,
			h = 128,
			model = "misc/mask.png",
			code = function(self)
				local rewardType = self.data.rewardType
				local rewardId = self.data.rewardId
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
				if (rewardType == 1) then --1:积分
					--显示积分介绍的tip
					hApi.ShowJiFennTip()
				elseif (rewardType == 2) then --2:战术技能卡
					--显示战术技能卡tip
					hApi.ShowTacticCardTip(rewardType, rewardId, 1)
				elseif (rewardType == 3) then --3:道具
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardId, 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 4) then --4:英雄
					--显示英雄tip
					local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_HeroCardInfo", rewardId)
				elseif (rewardType == 5) then --5:英雄将魂
					--
				elseif (rewardType == 6) then --6:战术技能卡碎片
					--显示战术技能卡碎片tip
					hApi.ShowTacticCardTip(rewardType, rewardId, 1)
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
		_childUI["randDrop" .. i].handle.s:setOpacity(0) --只响应事件，不显示
		
		--子节点
		local IconOffsetY = 10
		local dropNode = _childUI["randDrop" .. i]
		
		--几率掉落边框
		dropNode.childUI["imgSlot"] = hUI.image:new({
			parent = dropNode.handle._n,
			model = "UI_frm:slot",
			animation = "light",
			x = 1,
			y = -1 + IconOffsetY,
			w = 78,
			h = 78,
		})
		dropNode.childUI["imgSlot"].handle._n:setVisible(false)
		
		--几率掉落背景
		dropNode.childUI["imgBg"] = hUI.image:new({
			parent = dropNode.handle._n,
			--model = "panel/card_back.png",
			model = -1,
			--model = "UI:slotBig",
			x = 0,
			y = 0 + IconOffsetY,
			w = 72,
			h = 72,
		})
		--dropNode.childUI["imgBg"].handle._n:setVisible(false)
		
		--几率掉落奖励图标
		dropNode.childUI["img"] = hUI.image:new({
			parent = dropNode.handle._n,
			model = "ICON:skill_icon1_x3y3",
			x = 0,
			y = 0 + IconOffsetY,
		})
		
		--几率掉落道具品质颜色
		dropNode.childUI["itemQuality"] = hUI.image:new({
			parent = dropNode.handle._n,
			model = "ICON:skill_icon1_x3y3",
			x = 0,
			y = 0 + IconOffsetY,
			w = 72,
			h = 72,
		})
		dropNode.childUI["itemQuality"].handle._n:setVisible(false)
		
		--几率掉落碎片图标
		dropNode.childUI["imgDebris"] = hUI.image:new({
			parent = dropNode.handle._n,
			model = "UI:SoulStoneFlag",
			x = 19,
			y = -10 + IconOffsetY,
			scale = 1.3,
		})
		dropNode.childUI["imgDebris"].handle._n:setVisible(false)
		--dropNode.childUI["imgDebris"].handle._n:setRotation(60)
		
		--几率掉落名称
		dropNode.childUI["name"] = hUI.label:new({
			parent = dropNode.handle._n,
			x = 38,
			y = -20 + IconOffsetY,
			text = "",
			size = 20,
			font = "numWhite",
			align = "LC",
			--RGB = {0,255,0},
			border = 1,
			width = 250,
		})
	end
	
	--进入地图按钮（关卡开始）
	_childUI["gameStart"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ICON:action_attack",
		iconWH = 32,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_EnterMap"], --"进入战役"
		x = _frm.data.w * 0.5,
		y = -550 + 5,
		scaleT = 0.9,
		font = hVar.FONTC,
		border = 1,
		code = function(self)
			--检测作弊
			local cheatflag = xlGetIntFromKeyChain("cheatflag")
			local userID = xlPlayer_GetUID()
			if (cheatflag == 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
					font = hVar.FONTC,
					ok = function()
						xlExit()
					end,
				})
				return
			end
			
			if LuaCheckPlayerBagCanUse() == 0 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL4"],{
					font = hVar.FONTC,
					ok = function()
						
					end,
				})
				return
			end
			
			if __MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT then
				local diffNow = LuaGetPlayerMapAchi(__MAP_NAME,hVar.ACHIEVEMENT_TYPE.Map_Difficult)
				
				--难度选择按钮状态设置
				if __MAPDIFF > diffNow then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP1"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
					return
				end
			end
			
			--检测本关是否可以进入（通关了前一关才能打）
			if (hApi.IsMapEnableEnter(__MAP_NAME, __MAPDIFF) ~= 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP2"],{
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
				return
			end
			
			--关闭返回按钮
			hGlobal.UI.ShowReturnContinueFrm:show(0)
			_frm:show(0)
			if hGlobal.WORLD.LastWorldMap then
				hGlobal.WORLD.LastWorldMap:del()
				hGlobal.WORLD.LastWorldMap = nil
				--print(""..abc)
			end
			
			--关闭同步日志文件（第二把游戏开始时）
			--hApi.SyncLogClose()
			--关闭非同步日志文件（第二把游戏开始时）
			--hApi.AsyncLogClose()
			xlScene_LoadMap(g_world, __MAP_NAME,__MAPDIFF,__MAPMODE)
			local pId = luaGetplayerDataID()
			--if not pId or pId == 0 then
				SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--end
			--SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			
			print("SendCmdFunc[send_RoleData]:".. tostring(g_curPlayerName).. "," .. tostring(LuaGetPlayerScore()))
			--print(""..nil)
			--有米统计用
			--if __MAP_NAME == "world/level_tyjy" then
			--	SendCmdFunc["send_YM_EnterMap"]()
			--end
			--if xlUpdateCustomTable then
			--	if g_vs_number <= 4 then
			--		local cur_rmb,cur_score = (xlGetGameCoinNum() or 0 ), LuaGetPlayerScore() or 0
			--		xlUpdateCustomTable(0,"gamecoin",cur_rmb)
			----		xlUpdateCustomTable(0,"gamescore",cur_score)
			---	else
			--		SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--		SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--	end
			--end
		end,
	})
	_childUI["gameStart"].childUI["label"].handle._n:setPosition(-45,15)
	_childUI["gameStart"].childUI["icon"].handle._n:setPosition(-65,1)
	
	--锁
	_childUI["imgLock"] = hUI.image:new({
		parent = _parent,
		model = "UI:Lock",
		x = _frm.data.w * 0.5 - 65,
		y = -542,
		scale = 1.5,
	})
	
	--切换分页(标准/挑战1/挑战2/挑战3)
	--（在第一次打开界面，点切换剧情/挑战按钮时调用此接口）
	_switchPage = function(mode)
		if (mode == hVar.MAP_TD_TYPE.NORMAL) then
			_childUI["btnPageNormal"].childUI["imgSelected"].handle._n:setVisible(true)
			_childUI["btnPageDiff"].childUI["imgSelected"].handle._n:setVisible(false)
			
			--不显示挑战掉落相关的控件
			_childUI["labRadomDropTip"].handle._n:setVisible(false)
			for i = 1, 4, 1 do
				_childUI["randDrop" .. i]:setstate(-1)
			end
		elseif (mode == hVar.MAP_TD_TYPE.DIFFICULT) then
			_childUI["btnPageNormal"].childUI["imgSelected"].handle._n:setVisible(false)
			_childUI["btnPageDiff"].childUI["imgSelected"].handle._n:setVisible(true)
			
			--显示挑战掉落相关的控件
			_childUI["labRadomDropTip"].handle._n:setVisible(true)
			for i = 1, 4, 1 do
				_childUI["randDrop" .. i]:setstate(1)
			end
		end
		
		__MAPMODE = mode
		
		--刷新地图信息(标准/挑战1/挑战2/挑战3)
		_refreshMapInfo(__MAP_NAME)
	end
	
	--通过地图名参数 设置 开始游戏按钮是否可以使用
	local _setGameStartBtnState = function(mapType,mapName,btnState)
		local rs = 0
		--设置进入地图按钮是否可以按下 源代码模式下 所有地图都可以进入
		if btnState == 1  then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		elseif hApi.CheckUnlockMap(mapName) == 1 then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		else
			_childUI["gameStart"]:setstate(0)
			rs = 0
		end
		
		--zhenkira 这里要重写
		--if g_lua_src == 1 then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		--end
		
		--娱乐地图的特殊判断 
		--local noTrialrule = hVar.MAP_INFO[mapName].noTrialrule
		if not mapType then --地图包界面关闭 进入地图按钮
			_childUI["gameStart"]:setstate(-1)
			rs = -1
		end
		
		return rs
	end
	
	--创建地图准入信息
	local _createEnterRequire = function(RequireList)
		if type(RequireList) ~= "table" then return 1 end
		local result,resText = 1,nil
		
		for k, v in pairs(RequireList) do
			if k == "map" then
				--判断通关地图
				result = LuaGetPlayerMapAchi(v,hVar.ACHIEVEMENT_TYPE.LEVEL)
				if LuaGetPlayerMapAchi(v,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
					result = 1
				else
					result = 0
					resText = hVar.MAP_INFO[v].name
				end
				
			else
				print("other K haven't analyse :"..tostring(k))
			end
		end
		return result, resText
	end
	
	--刷新星级奖励的内容
	--（在第一次打开界面，点切换剧情/挑战按钮，切换3个难度模式，调用此接口）
	_refreshStarReward = function(mapTab, starReward, showDiffDrop, starNow)
		--星级奖励
		for i = 1, 3, 1 do
			--子节点
			local rewardNode = _childUI["starReward" .. i]
			
			if rewardNode then
				--返回值: tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h
				local rewardT = starReward[i] or {0,}
				local itemType = tonumber(rewardT[1]) --奖励类型
				local itemID = tonumber(rewardT[2]) --奖励id
				local itemLv = rewardT[4] --品质
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				--geyachao: 存储奖励的东西的属性
				rewardNode.data.rewardType = itemType
				rewardNode.data.rewardId = itemID
				
				--检测是否存在
				if (not itemID) or (itemID <= 0) then
					rewardNode.handle._n:setVisible(false)
				else
					rewardNode.handle._n:setVisible(true)
					
					--[[
					local rewardModel = "misc/cancel.png"
					local bgModel = "UI:slotBig"
					local name = ""
					local newW, newH = 80, 80					--图标大小
					local newX, newY = 0, 10					--图标坐标
					local newXX, newYY = 0, -63					--道具名称坐标
					
					local showSlot = false
					local showDebris = false
					local showBanner = false
					
					if reward[1] == 1 then
						rewardModel = "UI:score"				--积分
						name = "+"..tostring(itemID)
					elseif reward[1] == 2 then
						rewardModel = "misc/td_mui_gold.png"			--战术技能卡
						if hVar.tab_tactics[itemID] then
							if (hVar.tab_tactics[itemID].type == hVar.TACTICS_TYPE.OTHER) then
								bgModel = "UI:tactic_card_1"
								newX, newY = 0, 0
								--newW, newH = 64, 64
								showBanner = true
							end
							rewardModel = hVar.tab_tactics[itemID].icon
							
							name = hVar.tab_stringT[itemID][1]
						end
					elseif reward[1] == 3 then
						rewardModel = "misc/gift.png"				--道具
						if hVar.tab_item[itemID] then
							rewardModel = hVar.tab_item[itemID].icon
						end
						name = hVar.tab_stringI[itemID][1]
						
						showSlot = true
					elseif reward[1] == 4 then
						rewardModel = "ui/revivehero.png"			--英雄
						bgModel = "UI:PANEL_CARD_01"
						newW, newH = 105, 105
						newX, newY = 0, 17
						newXX, newYY = 0, -63
						if hVar.tab_unit[itemID] then
							rewardModel = hVar.tab_unit[itemID].portrait
						end
						
						name = hVar.tab_stringU[itemID][1]
					elseif reward[1] == 5 then
						rewardModel = "misc/gift.png"				--将魂
						if hVar.tab_item[itemID] then
							rewardModel = hVar.tab_item[itemID].icon
						end
						
						name = hVar.tab_stringI[itemID][1].." *".. tostring(itemNum)
						showDebris = true
					elseif reward[1] == 6 then
						rewardModel = "misc/gift.png"				--战术技能卡碎片
						if hVar.tab_item[itemID] then
							rewardModel = hVar.tab_item[itemID].icon
						end
						
						name = hVar.tab_stringI[itemID][1].." *".. tostring(itemNum)
						showDebris = true
					end
					]]
					
					local rewardModel = tmpModel
					local bgModel = nil
					if (itemType == 3) then --3:道具
						--bgModel = tmpModel
						--rewardModel = sub_tmpModel
						bgModel = "UI:item1"
						rewardModel = sub_tmpModel
					end
					
					local name = "" --itemName
					local newW, newH = 72, 72					--图标大小
					local innerWH = 6
					if (itemType == 3) then --3:道具
						newW, newH = 76, 76					--图标大小
						innerWH = 12
					end
					--local newX, newY = 0, 10					--图标坐标
					--local newXX, newYY = 0, -63					--道具名称坐标
					
					local showSlot = false
					local showItemQuality = false
					local showDebris = false
					local showBanner = false
					
					--rewardNode.childUI["img"]:setXY(newX, newY)
					if (bgModel == nil) then
						rewardNode.childUI["img"]:setmodel(rewardModel, nil, nil, newW, newH)
						rewardNode.childUI["imgBg"].handle.s:setVisible(false)
					else
						rewardNode.childUI["img"]:setmodel(rewardModel, nil, nil, newW - innerWH, newH - innerWH)
						rewardNode.childUI["imgBg"].handle.s:setVisible(true)
						rewardNode.childUI["imgBg"].handle.s:setOpacity(155) --道具底纹透明度
						rewardNode.childUI["imgBg"]:setmodel(bgModel, nil, nil, newW, newH)
					end
					
					--道具为品质颜色
					if (rewardT[1] == 3) then --3:道具
						showItemQuality = true
						
						local itemLv = 1
						if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
							itemLv = hVar.tab_item[itemID].itemLv
						end
						local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
						
						local qualityModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
						rewardNode.childUI["itemQuality"]:setmodel(qualityModel, nil, nil, newW, newH)
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					--英雄将魂为品质颜色
					elseif (rewardT[1] == 5) then --5:英雄将魂
						showDebris = true
						
						name = name .. "+"..tostring(itemNum)
						
						local itemLv = 1
						if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
							itemLv = hVar.tab_item[itemID].itemLv
						end
						local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					--战术技能卡碎片为品质颜色
					elseif (rewardT[1] == 6) then --6:战术技能卡碎片
						showDebris = true
						
						name = name .. "+"..tostring(itemNum)
						
						local itemLv = 1
						if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
							itemLv = hVar.tab_item[itemID].itemLv
						end
						local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					--英雄为橙色
					elseif (rewardT[1] == 4) then --4:英雄
						showSlot = true
						
						local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.RED].NAMERGB
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					--战术技能卡为金色
					elseif (rewardT[1] == 2) then --2:战术技能卡
						local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.GOLD].NAMERGB
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					--积分为白色
					elseif rewardT[1] == 1 then
						name = name .. "+"..tostring(itemNum)
						
						local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.WHITE].NAMERGB
						--rewardNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
					end
					
					rewardNode.childUI["name"]:setText(name)
					--rewardNode.childUI["name"]:setXY(newXX, newYY)
					
					rewardNode.childUI["imgSlot"].handle._n:setVisible(showSlot)
					rewardNode.childUI["itemQuality"].handle._n:setVisible(showItemQuality)
					rewardNode.childUI["imgDebris"].handle._n:setVisible(showDebris)
					
					--rewardNode.childUI["imgBanner"].handle._n:setVisible(showBanner)
					
					if rewardNode.childUI and rewardNode.childUI["flag"] and (i <= starNow) then --已获得
						rewardNode.childUI["flag"].handle._n:setVisible(true)
					else --未获得
						rewardNode.childUI["flag"].handle._n:setVisible(false)
					end
				end
			end
		end
		
		--难度模式几率掉落的道具
		--如果当前页是挑战难度页面
		if (__MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT) then
			for i = 1, 4, 1 do
				--子节点
				local dropNode = _childUI["randDrop" .. i]
				
				if dropNode then
					--返回值: tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h
					local rewardT = showDiffDrop[i] or {0,}
					local itemType = tonumber(rewardT[1]) --奖励类型
					local itemID = tonumber(rewardT[2]) --奖励id
					local itemLv = rewardT[4] --品质
					local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
					
					--geyachao: 存储奖励的东西的属性
					dropNode.data.rewardType = itemType
					dropNode.data.rewardId = itemID
					
					--检测是否存在
					if (not itemID) or (itemID <= 0) then
						dropNode:setstate(-1)
					else
						dropNode:setstate(1)
						
						local rewardModel = tmpModel
						local bgModel = nil
						if (itemType == 3) then --3:道具
							--bgModel = tmpModel
							--rewardModel = sub_tmpModel
							bgModel = "UI:item1"
							rewardModel = sub_tmpModel
						end
						
						local name = "" --itemName
						local newW, newH = 72, 72					--图标大小
						local innerWH = 6
						if (itemType == 3) then --3:道具
							newW, newH = 76, 76					--图标大小
							innerWH = 12
						end
						--local newX, newY = 0, 0					--图标坐标
						--local newXX, newYY = 0, -63					--道具名称坐标
						
						local showSlot = false
						local showItemQuality = false
						local showDebris = false
						
						--dropNode.childUI["img"]:setXY(newX, newY)
						if (bgModel == nil) then
							dropNode.childUI["img"]:setmodel(rewardModel, nil, nil, newW, newH)
							dropNode.childUI["imgBg"].handle.s:setVisible(false)
						else
							dropNode.childUI["img"]:setmodel(rewardModel, nil, nil, newW - innerWH, newH - innerWH)
							dropNode.childUI["imgBg"].handle.s:setVisible(true)
							dropNode.childUI["imgBg"].handle.s:setOpacity(155) --道具底纹透明度
							dropNode.childUI["imgBg"]:setmodel(bgModel, nil, nil, newW, newH)
						end
						
						--道具为品质颜色
						if (rewardT[1] == 3) then --3:道具
							showItemQuality = true
							
							local itemLv = 1
							if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
								itemLv = hVar.tab_item[itemID].itemLv
							end
							local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
							
							local qualityModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
							dropNode.childUI["itemQuality"]:setmodel(qualityModel, nil, nil, newW, newH)
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						--英雄将魂为品质颜色
						elseif (rewardT[1] == 5) then --5:英雄将魂
							showDebris = true
							
							name = name .. "+"..tostring(itemNum)
							
							local itemLv = 1
							if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
								itemLv = hVar.tab_item[itemID].itemLv
							end
							local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
							
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						--战术技能卡碎片为品质颜色
						elseif (rewardT[1] == 6) then --6:战术技能卡碎片
							showDebris = true
							
							name = name .. "+"..tostring(itemNum)
							
							local itemLv = 1
							if hVar.tab_item[itemID] and hVar.tab_item[itemID].itemLv then
								itemLv = hVar.tab_item[itemID].itemLv
							end
							local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						--英雄为橙色
						elseif (rewardT[1] == 4) then --4:英雄
							showSlot = true
							
							local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.RED].NAMERGB
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						--战术技能卡为金色
						elseif (rewardT[1] == 2) then --2:战术技能卡
							local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.GOLD].NAMERGB
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						--积分为白色
						elseif rewardT[1] == 1 then
							name = name .. "+"..tostring(itemNum)
							
							local RGB = hVar.ITEMLEVEL[hVar.ITEM_QUALITY.WHITE].NAMERGB
							--dropNode.childUI["name"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
						end
						
						dropNode.childUI["name"]:setText(name)
						--dropNode.childUI["name"]:setXY(newXX, newYY)
						
						dropNode.childUI["imgSlot"].handle._n:setVisible(showSlot)
						dropNode.childUI["itemQuality"].handle._n:setVisible(showItemQuality)
						dropNode.childUI["imgDebris"].handle._n:setVisible(showDebris)
					end
				end
			end
		end
		
		--更新积分
		local score = mapTab.scoreV or 0
		if (__MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT) then --难度模式额外加经验
			score = score + math.floor(__MAPDIFF * 0.1 * score) --10％/20％/30％
		end
		_childUI["btnScore"].childUI["labScoreReward"]:setText("+" .. score)
		
		--更新经验值
		local exp = mapTab.exp or 0
		if (__MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT) then --难度模式额外加经验值
			exp = exp + math.floor(__MAPDIFF * 0.1 * exp) --10％/20％/30％
		end
		_childUI["btnExp"].childUI["labExpReward"]:setText("+" .. exp)
	end
	
	--创建/刷新 地图信息(标准/挑战1/挑战2/挑战3)
	--（在第一次打开界面，点切换剧情/挑战按钮时调用此接口）
	_refreshMapInfo = function(mapname)
		--删除上一次的残留内容
		_removeFunc()
		
		local mapTab = hVar.MAP_INFO[mapname]
		local mapType = mapTab.mapType			--地图等级
		local enterRequire = mapTab.EnterRequire	--进入地图的条件
		
		--地图名
		local name = mapTab.name..(hVar.tab_stringM[mapname][5] or "")
		_childUI["mapName"].childUI["lab"]:setText(name)
		
		--[[
		--更新积分
		local score = mapTab.scoreV or 0
		_childUI["btnScore"].childUI["labScoreReward"]:setText("+"..tostring(score))
		
		--更新经验值
		local exp = mapTab.exp or 0
		_childUI["btnExp"].childUI["labExpReward"]:setText("+"..tostring(exp))
		]]
		
		--普通关卡挑战关卡设定
		local diffLock = false --挑战关卡是否锁定
		local normalStar = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0) --普通关卡评价
		local diffMax = (LuaGetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0) --挑战难度关卡最高等级
		
		--异常检测,这是为了使老存档正常
		if (normalStar < 3) then
			diffLock = true
		elseif (normalStar >= 3) and (diffMax == 0) then
			LuaSetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.Map_Difficult, 1) --当前难度几
			LuaSetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.IMPERIAL, 0)--当前难度的星星
		end
		
		--如果当前页是挑战难度页面
		if (__MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT) then
			--首次打开本界面，读取存档的难度几
			if (__MAPDIFF == 0) then
				__MAPDIFF = LuaGetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.Map_Difficult) --当前难度几
			end
		elseif (__MAPMODE == hVar.MAP_TD_TYPE.NORMAL) then --普通模式难度为0
			__MAPDIFF = 0
		end
		--print("__MAPDIFF=", __MAPDIFF)
		
		--检测挑战模式是否解锁
		if diffLock then
			_childUI["btnPageDiff"]:setstate(0)
			_childUI["btnPageDiff"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
			_childUI["btnPageDiff"].data.diffLock = diffLock
		else
			_childUI["btnPageDiff"]:setstate(1)
			_childUI["btnPageDiff"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
			_childUI["btnPageDiff"].data.diffLock = diffLock
		end
		_childUI["btnPageDiffTipInfo"]:setstate(1)
		_childUI["btnPageDiffTipInfo"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
		
		local diffInfo = mapTab.DiffMode
		if (not diffInfo) then
			_childUI["btnPageDiff"]:setstate(-1)
			_childUI["btnPageDiff"].data.diffLock = false
			_childUI["btnPageDiffTipInfo"]:setstate(-1)
		else
			local diffMax = diffInfo.maxDiff or 0
			if (diffMax <= 0) then
				_childUI["btnPageDiff"]:setstate(-1)
				_childUI["btnPageDiff"].data.diffLock = false
				_childUI["btnPageDiffTipInfo"]:setstate(-1)
			end
		end
		
		--刷新子页面(标准/挑战1/挑战2/挑战3)
		_refreshSubPage(mapname)
		
		--local rs = _setGameStartBtnState(mapType,mapname,LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL))
		----设置地图信息框背景样式 如果是地图包，则是大面板
		--if not childmap or type(childmap) ~= "table" then
		--	
		--	--如果地图是不能进入的，并且是地图包的起始，则激活购买按钮
		--	if rs == 0 then
		--		local itemID = hVar.MAP_INFO[mapname].itemID
		--		local achiMap = "world/level_tyjy"
		--		if type(enterRequire) == "table" and EnterRequire.map then
		--			achiMap = EnterRequire.map
		--		end
		--
		--		if enterRequire then
		--			local requireState,requireTipText = _createEnterRequire(enterRequire)
		--			if requireState == 0 then
		--				if requireTipText ~= nil then
		--					--显示准入信息
		--				end
		--			end
		--		end
		--
		--		--判断是否是章节地图的起始
		--		if hApi.CheckMapBagEx(mapname,achiMap) == 1 then
		--			_childUI["gameStart"]:setstate(-1)
		--		else
		--			_childUI["gameStart"]:setstate(0)
		--		end
		--	else
		--		_childUI["gameStart"]:setstate(1)
		--	end
		--end
	end
	
	--刷新子页面(标准/挑战1/挑战2/挑战3)
	--（在第一次打开界面，点切换剧情/挑战按钮，切换3个难度模式，调用此接口）
	_refreshSubPage = function(mapname)
		local mapTab = hVar.MAP_INFO[mapname]
		
		--普通关卡挑战关卡设定
		local normalStar = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0) --普通关卡评价
		local diffStar = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0) --挑战难度关卡评价
		
		local starReward				--奖励
		local showDiffDrop = nil		--难度模式几率掉落
		local mapInfo					--关卡说明
		local starNow = 0				--当前获得的星级 (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
		
		if (__MAPMODE == hVar.MAP_TD_TYPE.NORMAL) then --普通模式
			starReward = mapTab.starReward or {{0,},{0,},{0,},}
			mapInfo = mapTab.info
			starNow = normalStar
			
			_childUI["labDiffSelectTip"].handle._n:setVisible(false)
			_childUI["labDiff"].handle._n:setVisible(false)
			_childUI["btnDiff_R"]:setstate(-1)
			_childUI["btnDiff_L"]:setstate(-1)
			--hApi.AddShader(_childUI["btnDiff_R"].childUI["icon"].handle.s, "gray")
			--hApi.AddShader(_childUI["btnDiff_L"].childUI["icon"].handle.s, "gray")
			_childUI["imgLock"].handle._n:setVisible(false)
			hApi.AddShader(_childUI["gameStart"].handle.s, "normal")
		elseif (__MAPMODE == hVar.MAP_TD_TYPE.DIFFICULT) then --挑战困难模式
			starNow = diffStar
			mapInfo = ""
			
			local diffInfo = mapTab.DiffMode or {}
			local diffMax = diffInfo.maxDiff or 1
			local diffNow = LuaGetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.Map_Difficult)
			--__MAPDIFF = math.min(math.min(diffNow,diffMax), __MAPDIFF)
			
			if (__MAPDIFF < diffNow) then
				starNow = 3
			elseif (__MAPDIFF > diffNow) then
				starNow = 0
			end
			
			--难度选择按钮
			_childUI["labDiffSelectTip"].handle._n:setVisible(true)
			_childUI["labDiff"]:setText(__MAPDIFF)
			_childUI["labDiff"].handle._n:setVisible(true)
			_childUI["btnDiff_R"]:setstate(1)
			_childUI["btnDiff_L"]:setstate(1)
			--hApi.AddShader(_childUI["btnDiff_R"].childUI["icon"].handle.s, "normal")
			--hApi.AddShader(_childUI["btnDiff_L"].childUI["icon"].handle.s, "normal")
			_childUI["imgLock"].handle._n:setVisible(true)
			hApi.AddShader(_childUI["gameStart"].handle.s,"gray")
			
			
			--难度选择按钮状态设置
			
			--if __MAPDIFF >= diffNow then
			if (__MAPDIFF >= diffMax) then
				--_childUI["btnDiff_R"]:setstate(0)
				--hApi.AddShader(_childUI["btnDiff_R"].childUI["icon"].handle.s, "gray")
				_childUI["btnDiff_R"].childUI["icon"].handle._n:setVisible(false)
				_childUI["btnDiff_R"].childUI["iconGray"].handle._n:setVisible(true)
			else
				--hApi.AddShader(_childUI["btnDiff_R"].childUI["icon"].handle.s, "normal")
				_childUI["btnDiff_R"].childUI["icon"].handle._n:setVisible(true)
				_childUI["btnDiff_R"].childUI["iconGray"].handle._n:setVisible(false)
			end
			
			if (__MAPDIFF <= 1) then
				--_childUI["btnDiff_L"]:setstate(0)
				--hApi.AddShader(_childUI["btnDiff_L"].childUI["icon"].handle.s, "gray")
				_childUI["btnDiff_L"].childUI["icon"].handle._n:setVisible(false)
				_childUI["btnDiff_L"].childUI["iconGray"].handle._n:setVisible(true)
			else
				--hApi.AddShader(_childUI["btnDiff_L"].childUI["icon"].handle.s, "normal")
				_childUI["btnDiff_L"].childUI["icon"].handle._n:setVisible(true)
				_childUI["btnDiff_L"].childUI["iconGray"].handle._n:setVisible(false)
			end
			
			--print("__MAPDIFF:"..__MAPDIFF..",diffNow:"..diffNow)
			if (__MAPDIFF >= 1) and (__MAPDIFF <= diffNow) then
				_childUI["imgLock"].handle._n:setVisible(false)
				hApi.AddShader(_childUI["gameStart"].handle.s, "normal")
			end
			
			--挑战难度模式关卡信息
			local modeInfo = diffInfo[__MAPDIFF]
			if modeInfo then
				starReward = modeInfo.starReward or {{0,},{0,},{0,},}
				showDiffDrop = diffInfo.chestPool[hVar.ITEM_QUALITY.BLUE + __MAPDIFF] or {}
				
				--难度模式的敌人增益buff战术卡
				if modeInfo.diffTactic then
					for i = 1, #modeInfo.diffTactic, 1 do
						local id = modeInfo.diffTactic[i][1] or 0
						local lv = modeInfo.diffTactic[i][2] or 1
						local str = "Tid["..id.."]["..lv.."]"
						if hVar.tab_stringT[id] and hVar.tab_stringT[id][lv + 1] then
							str = tostring(hVar.tab_stringT[id][lv + 1])
						end
						--mapInfo = mapInfo .. str .. ";  "
						mapInfo = mapInfo .. str .. "   "
					end
				end
				
				--难度模式禁用的塔
				if modeInfo.towerBan then
					if (#modeInfo.towerBan > 0) then
						local strBanTowers = "" --文字描述
						for i = 1, #modeInfo.towerBan, 1 do
							local towerId = modeInfo.towerBan[i] --塔卡id
							local strTowerName = hVar.tab_stringT[towerId] and hVar.tab_stringT[towerId][1] or ("未知塔" ..towerId)
							if (i == 1) then
								strBanTowers = ("%s%s"):format(strBanTowers, strTowerName)
							else
								strBanTowers = ("%s,%s"):format(strBanTowers, strTowerName)
							end
						end
						--mapInfo = mapInfo .. "\n禁用:" .. strBanTowers .. ";  " --language
						mapInfo = mapInfo .. "\n" .. hVar.tab_string["__TEXT_NOT_ALLOWE"] .. ":" .. strBanTowers .. ";  " --language
					end
				end
				
				--难度模式禁用的战术卡
				if modeInfo.tacticBan then
					if (#modeInfo.tacticBan > 0) then
						local strBanTactics = "" --文字描述
						for i = 1, #modeInfo.tacticBan, 1 do
							local tacticId = modeInfo.tacticBan[i] --战术卡id
							local strTowerName = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知战术卡" ..tacticId)
							if (i == 1) then
								strBanTactics = ("%s%s"):format(strBanTactics, strTowerName)
							else
								strBanTactics = ("%s,%s"):format(strBanTactics, strTowerName)
							end
						end
						--mapInfo = mapInfo.. "禁用:" .. strBanTactics .. ";  " --language
						mapInfo = mapInfo.. hVar.tab_string["__TEXT_NOT_ALLOWE"] .. ":" .. strBanTactics .. ";  " --language
					end
				end
			end
		end
		
		--地图信息
		_childUI["mapInfo"]:setText(mapInfo)
		
		--刷新奖励信息
		_refreshStarReward(mapTab, starReward, showDiffDrop, starNow)
	end
	
	hGlobal.event:listen("LocalEvent_Phone_ShowMapInfoFrm","Phone_showthisfrm1",function(map_name)					--监听剧情战役中的战役选择
		__MAP_NAME = map_name
		if map_name ~= nil then
			_switchPage(hVar.MAP_TD_TYPE.NORMAL)
			
			--add by pangyong 2015/3/25
			--初始默认设置
			--_frm.childUI["gameContinue"]:setstate(0)						--使按钮无效化
			--_frm.childUI["gameContinue"].handle._n:setVisible(fasle)				--使按钮不可视
			
			--检查是否有存档（新手没有）
			if hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
				local tempTable = LuaGetSaveTitle(g_curPlayerName)
				if type(hVar.MAP_INFO[tempTable[1]]) == "table" then
					if hVar.MAP_INFO[tempTable[1]].name == hVar.MAP_INFO[map_name].name then			--如果当前地图与存档地图同名，则显示按钮
						--_frm.childUI["gameContinue"]:setstate(1)						--使按钮有效
						--_frm.childUI["gameContinue"].handle._n:setVisible(true)					--使按钮可视
					end
				end
			else
				--print("您是新玩家，还没有存档")
			end
			
			--源代码模式、测试员、管理员，显示PVP联网对战图
			if _childUI["MapDropBtn"] then
				_childUI["MapDropBtn"]:del()
				--print("源代码模式、测试员、管理员，显示PVP联网对战图")
			end
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			if (g_lua_src == 1) or (g_is_account_test == 2) then --测试员不能进
				--显示PVP联网对战图
				_childUI["MapDropBtn"] = hUI.button:new({
					parent = _parent,
					model = "UI:ButtonBack",
					--icon = "ICON:PartArmy",
					--iconWH = 32,
					dragbox = _childUI["dragBox"],
					label = "掉落", --language
					--label = hVar.tab_string["__TEXT_EnterChallenge"], --language
					x = _frm.data.w * 0.5 + 350,
					y = -550 + 5,
					w = 120,
					h = 50,
					scaleT = 0.95,
					font = hVar.FONTC,
					border = 1,
					code = function(self)
						--关闭本界面
						hGlobal.UI.ShowReturnContinueFrm:show(0)
						_frm:show(0)
						
						--显示关卡掉落道具列表的面板
						hApi.ShowMapDropItemListPanel(__MAP_NAME)
					end,
				})
				
				if (g_is_account_test == 1) then --测试员
					--1颗星
					_childUI["MapDropBtn"].childUI["star1"] = hUI.image:new({
						parent = _childUI["MapDropBtn"].handle._n,
						x = 0,
						y = 50,
						model = "misc/weekstar.png",
						w = 48,
						h = 48,
					})
				else
					--2颗星
					_childUI["MapDropBtn"].childUI["star1"] = hUI.image:new({
						parent = _childUI["MapDropBtn"].handle._n,
						x = -20,
						y = 50,
						model = "misc/weekstar.png",
						w = 48,
						h = 48,
					})
					_childUI["MapDropBtn"].childUI["star2"] = hUI.image:new({
						parent = _childUI["MapDropBtn"].handle._n,
						x = 20,
						y = 50,
						model = "misc/weekstar.png",
						w = 48,
						h = 48,
					})
				end
			end
			
			_frm:show(1)
			_frm:active()
		end
	end)
	
	--切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__Phone_UI__HideMapInfoFrm",function(sSceneType,oWorld,oMap)
		__MAP_NAME = ""
		__MAPMODE = hVar.MAP_TD_TYPE.NORMAL
		__MAPDIFF = 0
		_frm:show(0)
		_removeFunc()
	end)
end
--[[
--测试 --test
if hGlobal.UI.PhoneMapInfoFrm then --删除上次界面
	hGlobal.UI.PhoneMapInfoFrm:del()
end
--创建普通关卡查看界面
hGlobal.UI.InitMapInfoFrm()
--模拟触发事件
hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm", "world/td_301_tswl")
]]







--挑战关卡详细信息界面
hGlobal.UI.InitChallengeMapInfoFrm = function()
	
	local __chapterId = 1
	local _createMapInfo = hApi.DoNothing
	
	--逻辑控制变量，当前选择关卡模式
	local __MAP_NAME = ""
	local __MAPMODE = hVar.MAP_TD_TYPE.PVP
	local __MAPDIFF = 0
	
	local _w,_h = 800,500
	hGlobal.UI.ChallengeMapInfoFrm = hUI.frame:new({
		dragable = 2,
		x = hVar.SCREEN.w/2 - 400,
		y = hVar.SCREEN.h/2 + 250,
		w = _w,
		h = _h,
		show = 0,
		background = "UI:tip_item",
		border = 1,
	})
	
	local _frm = hGlobal.UI.ChallengeMapInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--临时UI管理
	local removeList = {}
	--清空所有临时UI
	local _removeFunc = function()
		for i = 1,#removeList do
			hApi.safeRemoveT(_childUI,removeList[i]) 
		end
		removeList = {}
	end

	--面板的关闭方法
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w-12,
		y = -12,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		code = function()
			--FrmGB:show(0)
			_frm:show(0)
			_removeFunc()
		end,
	})

	--关卡名称
	_childUI["mapName"] = hUI.node:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = 10,
	})
	
	_childUI["mapName"].childUI["img"] = hUI.image:new({
		parent = _childUI["mapName"].handle._n,
		model = "UI:MedalDarkImg",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = 0,
		w = 400,
		h = 61,
	})

	_childUI["mapName"].childUI["lab"] = hUI.label:new({
		parent = _childUI["mapName"].handle._n,
		x = 0,
		y = 0,
		text = "",
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,205,55},
	})

	--上一关
	_childUI["lastChapterBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack",
		label = hVar.tab_string["__TEXT_LastChapter"],
		x = 150,
		y = -75,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		code = function(self)
			if __chapterId > 1 then
				__chapterId = __chapterId - 1
			end
			_createMapInfo(__chapterId)
		end,
	})
	
	--下一关
	_childUI["nextChapterBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack",
		label = hVar.tab_string["__TEXT_NextChapter"],
		x = 150,
		y = -440,
		scaleT = 0.9,
		code = function(self)
			local maxChapter = 0
			if hVar.tab_chapter then
				maxChapter = #hVar.tab_chapter
			end
			if __chapterId < maxChapter then
				__chapterId = __chapterId + 1
			end
			_createMapInfo(__chapterId)
		end,
	})

	--boss立绘
	_childUI["boss"] = hUI.node:new({
		parent = _parent,
		x = 150,
		y = -260,
	})
	
	_childUI["boss"].childUI["imgBg"] = hUI.image:new({
		parent = _childUI["boss"].handle._n,
		model = "misc/level_wanted_e.png",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = 0,
		w = 90,
		h = 120,
		scale = 2.5,
	})

	_childUI["boss"].childUI["img"] = hUI.image:new({
		parent = _childUI["boss"].handle._n,
		model = "icon/portrait/hero_caiwenji.png",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = -10,
		scale = 0.8,
	})
	
	--累计胜场
	_childUI["labFightCount"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w * 0.5 + 100,
		y = -120,
		text = hVar.tab_string["__TEXT_FIGHT_COUNT"].."0",
		size = 30,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,255,255},
	})
	
	--累计胜场提示内容
	_childUI["labFightTip"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w * 0.5 + 100,
		y = -200,
		text = hVar.tab_string["__TEXT_FIGHT_TIP"],
		size = 22,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,205,55},
		width = 160,
	})
	
	--普通奖励提示
	_childUI["labReward"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w * 0.5 + 50,
		y = -330,
		text = hVar.tab_string["__TEXT_ITEM_TYPE_REWARD"],
		size = 30,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,255,255},
	})

	--普通奖励
	for i = 1, 3 do
		--奖励节点
		_childUI["starReward"..tostring(i)] = hUI.node:new({
			parent = _parent,
			x = 540 + (i - 1) * 80,
			y = -325,
		})
		
		--子节点
		local rewardNode = _childUI["starReward"..tostring(i)]
		--背景
		rewardNode.childUI["imgBg"] = hUI.image:new({
			parent = rewardNode.handle._n,
			--model = "panel/card_back.png",
			model = "panel/tactic_card_1.png",
			x = 0,
			y = 0,
			w = 60,
			h = 80,
		})
		
		rewardNode.childUI["img"] = hUI.image:new({
			parent = rewardNode.handle._n,
			model = "misc/cancel.png",
			x = 0,
			y = -10,
			w = 32,
			h = 32,
		})
		
		rewardNode.childUI["lab"] = hUI.label:new({
			parent = rewardNode.handle._n,
			x = 0,
			y = -50,
			text = "",
			size = 18,
			font = hVar.FONTC,
			align = "MC",
			RGB = {255,205,55},
		})
	end
	
	--秘境按钮底部特效
	_childUI["imgSecretBg"] = hUI.image:new({
		parent = _parent,
		--model = "MODEL_EFFECT:Fire02",
		--model = "misc/tipMinBG.png",
		model = -1,
		x = 680,
		y = -160,
		scale = 2,
	})
	_childUI["imgSecretBg"].handle._n:setVisible(false)

	--秘境按钮
	_childUI["btnSecret"] = hUI.button:new({
		parent = _parent,
		model = "misc/weekstar.png",
		iconWH = 32,
		dragbox = _childUI["dragBox"],
		x = 680,
		y = -180,
		z = 1,
		scaleT = 0.9,
		scale = 2,
		font = hVar.FONTC,
		border = 1,
		code = function(self)
			_frm:show(0)
			_removeFunc()
			hGlobal.event:event("LocalEvent_Phone_ShowChallengeMapRewardFrm", __chapterId)
		end,
	})
	_childUI["btnSecret"]:setstate(-1)
	
	--进入地图按钮（秘境开始）
	local __MAP_NAME = ""
	_childUI["gameStart"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ICON:action_attack",
		iconWH = 32,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_EnterMap"],
		x = 600,
		y = -440,
		scaleT = 0.9,
		font = hVar.FONTC,
		border = 1,
		code = function(self)
			--检测作弊
			local cheatflag = xlGetIntFromKeyChain("cheatflag")
			local userID = xlPlayer_GetUID()
			if (cheatflag == 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
					font = hVar.FONTC,
					ok = function()
						xlExit()
					end,
				})
				return
			end

			if LuaCheckPlayerBagCanUse() == 0 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL4"],{
					font = hVar.FONTC,
					ok = function()
						
					end,
				})
				return
			end
			
			--检测本关是否可以进入（通关了前一关才能打）
			if (hApi.IsMapEnableEnter(__MAP_NAME, __MAPDIFF) ~= 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP2"],{
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
				return
			end
			
			--关闭返回按钮
			hGlobal.UI.ShowReturnContinueFrm:show(0)
			_frm:show(0)
			if hGlobal.WORLD.LastWorldMap then
				hGlobal.WORLD.LastWorldMap:del()
				hGlobal.WORLD.LastWorldMap = nil
				
			end
			local chapterInfo = hVar.tab_chapter[__chapterId]
			local bossMap = ""
			if chapterInfo then
				bossMap = chapterInfo.bossMap or ""
			end
			
			
			--关闭同步日志文件（第二把游戏开始时）
			--hApi.SyncLogClose()
			--关闭非同步日志文件（第二把游戏开始时）
			--hApi.AsyncLogClose()
			
			xlScene_LoadMap(g_world, bossMap,__MAPDIFF,__MAPMODE)
			
			--SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			local pId = luaGetplayerDataID()
			--if not pId or pId == 0 then
				SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--end
			--有米统计用
			--if __MAP_NAME == "world/level_tyjy" then
			--	SendCmdFunc["send_YM_EnterMap"]()
			--end
			--if xlUpdateCustomTable then
			--	if g_vs_number <= 4 then
			--		local cur_rmb,cur_score = (xlGetGameCoinNum() or 0 ), LuaGetPlayerScore() or 0
			--		xlUpdateCustomTable(0,"gamecoin",cur_rmb)
			--		xlUpdateCustomTable(0,"gamescore",cur_score)
			--	else
			--		SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--		SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--	end
			--end
		end,
	})
	_childUI["gameStart"].childUI["label"].handle._n:setPosition(-45,15)
	_childUI["gameStart"].childUI["icon"].handle._n:setPosition(-65,1)

	--通过地图名参数 设置 开始游戏按钮是否可以使用
	local _setGameStartBtnState = function(mapType,mapName,btnState)
		local rs = 0
		--设置进入地图按钮是否可以按下 源代码模式下 所有地图都可以进入
		if btnState == 1  then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		elseif hApi.CheckUnlockMap(mapName) == 1 then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		else
			_childUI["gameStart"]:setstate(0)
			rs = 0
		end
		
		--zhenkira 这里要重写
		--if g_lua_src == 1 then
			_childUI["gameStart"]:setstate(1)
			rs = 1
		--end
		
		--娱乐地图的特殊判断 
		--local noTrialrule = hVar.MAP_INFO[mapName].noTrialrule
		if not mapType then --地图包界面关闭 进入地图按钮
			_childUI["gameStart"]:setstate(-1)
			rs = -1
		end
		
		return rs
	end

	--创建地图准入信息
	local _createEnterRequire = function(RequireList)
		if type(RequireList) ~= "table" then return 1 end
		local result,resText = 1,nil

		for k,v in pairs(RequireList) do
			if k == "map" then
				--判断通关地图
				result = LuaGetPlayerMapAchi(v,hVar.ACHIEVEMENT_TYPE.LEVEL)
				if LuaGetPlayerMapAchi(v,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
					result = 1
				else
					result = 0
					resText = hVar.MAP_INFO[v].name
				end
				
			else
				print("other K haven't analyse :"..tostring(k))
			end
		end
		return result,resText
	end

	--创建地图信息
	_createMapInfo = function(chapterId)
		--删除上一次的残留内容
		_removeFunc()
		
		local chapterInfo = hVar.tab_chapter[chapterId]
		local bossMap = ""
		if chapterInfo then
			bossMap = chapterInfo.bossMap or ""
		end
		local mapTab = hVar.MAP_INFO[bossMap]
		local bossPortrait = ""
		local mapType = 4
		if mapTab then
			bossPortrait = mapTab.portrait or ""
			mapType = mapTab.mapType or 4
		end
		
		--地图名
		_childUI["mapName"].childUI["lab"]:setText(mapTab.name..(hVar.tab_stringM[bossMap][5] or ""))

		--boss半身像
		_childUI["boss"].childUI["img"]:setmodel(bossPortrait)
		_childUI["boss"].childUI["img"].handle._n:setScale(0.8)

		--累计胜场
		local fightCount = (LuaGetPlayerMapAchi(bossMap,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
		_childUI["labFightCount"]:setText(hVar.tab_string["__TEXT_FIGHT_COUNT"].. tostring(fightCount))
		
		--秘境按钮
		if fightCount > 0 then
			_childUI["imgSecretBg"].handle._n:setVisible(true)
			_childUI["btnSecret"]:setstate(1)
		end

		--上一关下一关按钮
		if chapterId > 1 then
			_childUI["lastChapterBtn"]:setstate(1)
		else
			_childUI["lastChapterBtn"]:setstate(0)
		end
		local maxChapter = 0
		if hVar.tab_chapter then
			maxChapter = #hVar.tab_chapter
		end
		if chapterId < maxChapter then
			_childUI["nextChapterBtn"]:setstate(1)
		else
			_childUI["nextChapterBtn"]:setstate(0)
		end

		--星级奖励
		local starReward = mapTab.starReward or {{0,},{0,},{0,},}
		for i = 1, 3 do
			--子节点
			local rewardNode = _childUI["starReward"..tostring(i)]
			
			if rewardNode then
				--奖励类型
				local reward = starReward[i] or {0,}
				local rewardModel = "misc/cancel.png"
				local rewardText = ""
				if reward[1] == 1 then
					rewardModel = "UI:score"			--积分
					rewardText = tostring(reward[2] or 0)
				elseif reward[1] == 2 then				--战术技能卡
					local tacticId = reward[2] or 0
					local tacticNum = reward[3] or 0
					local tacticLv = reward[4] or 1
					rewardModel = "UI:score"
					rewardText = "TId:".. tostring(tacticId)
					if tacticId > 0 and tacticNum > 0 and hVar.tab_tactics[tacticId] then
						rewardModel = hVar.tab_tactics[tacticId].icon or "UI:score"
						if hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] then
							rewardText = hVar.tab_stringT[tacticId][1]
						end
					end
				elseif reward[1] == 3 then				--道具
					local itemId = reward[2] or 0
					rewardModel = "misc/gift.png"
					rewardText = "IId:".. tostring(itemId)
					if itemId > 0 and hVar.tab_item[itemId] then
						rewardModel = hVar.tab_item[itemId].model or hVar.tab_item[itemId].icon or "UI:score"
						if hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] then
							rewardText = hVar.tab_stringI[itemId][1]
						end
					end
				elseif reward[1] == 4 then				--英雄
					local heroId = reward[2] or 0
					rewardModel = "UI:BTN_GetHeroCard"
					rewardText = "HId:".. tostring(heroId)
					if heroId > 0 and hVar.tab_unit[heroId] then
						rewardModel = hVar.tab_unit[heroId].icon or "UI:BTN_GetHeroCard"
						if hVar.tab_stringU[heroId] and hVar.tab_stringU[heroId][1] then
							rewardText = hVar.tab_stringU[heroId][1]
						end
					end
				elseif reward[1] == 5 then				--道具
					local itemId = reward[2] or 0
					rewardModel = "misc/gift.png"
					rewardText = "IId:".. tostring(itemId)
					if itemId > 0 and hVar.tab_item[itemId] then
						rewardModel = hVar.tab_item[itemId].model or hVar.tab_item[itemId].icon or "misc/gift.png"
						if hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] then
							rewardText = hVar.tab_stringI[itemId][1]
						end
					end
				elseif reward[1] == 6 then				--道具
					local itemId = reward[2] or 0
					rewardModel = "misc/gift.png"
					rewardText = "IId:".. tostring(itemId)
					if itemId > 0 and hVar.tab_item[itemId] then
						rewardModel = hVar.tab_item[itemId].model or hVar.tab_item[itemId].icon or "misc/gift.png"
						if hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] then
							rewardText = hVar.tab_stringI[itemId][1]
						end
					end
				end
				rewardNode.childUI["img"]:setmodel(rewardModel)
				rewardNode.childUI["lab"]:setText(rewardText)
			end
		end
		
		--开始按钮
		local rs = _setGameStartBtnState(mapType,bossMap,btnState)
		--设置地图信息框背景样式 如果是地图包，则是大面板
		if not childmap or type(childmap) ~= "table" then
			
			--如果地图是不能进入的，并且是地图包的起始，则激活购买按钮
			if rs == 0 then
				local itemID = hVar.MAP_INFO[bossMap].itemID
				local achiMap = "world/level_tyjy"
				if type(enterRequire) == "table" and EnterRequire.map then
					achiMap = EnterRequire.map
				end

				if enterRequire then
					local requireState,requireTipText = _createEnterRequire(enterRequire)
					if requireState == 0 then
						if requireTipText ~= nil then
							--显示准入信息
						end
					end
				end

				--判断是否是章节地图的起始
				if hApi.CheckMapBagEx(bossMap,achiMap) == 1 then
					_childUI["gameStart"]:setstate(-1)
				else
					_childUI["gameStart"]:setstate(0)
				end
			else
				_childUI["gameStart"]:setstate(1)
			end
		end
		
	end

	hGlobal.event:listen("LocalEvent_Phone_ShowChallengeMapInfoFrm","Phone_showthisfrm",function(chapterId)
		if chapterId and chapterId ~= 0 then
			__chapterId = chapterId
			_createMapInfo(__chapterId)
			
			_frm:show(1)
			_frm:active()
			
			--SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			local pId = luaGetplayerDataID()
			--if not pId or pId == 0 then
				SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--end
		else
			__chapterId = 1
			_frm:show(0)
			_removeFunc()
		end
	end)
	
	--切场景把自己藏起来
	local temp_map_difficult = 0
	local temp_map_enemy_num = 0
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__Phone_UI__HideChallengeMapInfoFrm",function(sSceneType,oWorld,oMap)
		__chapterId = 1
		_frm:show(0)
		_removeFunc()
	end)
end

--挑战关卡秘境界面
hGlobal.UI.InitChallengeMapRewardFrm = function()
	
	---------------------------------------------------------------------------------------------------
	--变量常量等注册
	
	--常量
	local ACTION_TIME = 0.2 --卡牌从上移动到下面的时间
	local ACTION_ROLL_DELT = 300 --roll期间动画间隔
	
	local MAX_SLOT = 3 --奖励槽数量
	
	--界面动画相关变量
	local ANIM_REWARD_FLY = 0 --是否在发牌动画中
	local ANIM_IN_ACTION = 0 --是否在动画中
	local ANIM_REWARD_IDXS = {} --播放动画的集合
	local ANIM_CARD = nil --当前抽到的卡
	local ANIM_SLOT = nil --当前要进去的槽

	--界面控制变量
	local __mapName = ""
	local __chapterId = 1
	local __storedReward = {}
	local __myReward = {}
	local __getEngryFlag = 0
	
	--界面逻辑函数
	local _aniLoop = hApi.DoNothing --动画循环
	local _rollBtnClick = hApi.DoNothing --点击重转按钮
	local _getFightCountLimit = hApi.DoNothing --获取通关次数限制
	local _randomReward = hApi.DoNothing --随机生成奖励
	local _sortReward = hApi.DoNothing --按解锁条件（通关次数限制）重新排列奖励
	local _createRewardInfo = hApi.DoNothing --创建奖励信息
	---------------------------------------------------------------------------------------------------
	--界面创建
	local _w,_h = 800,500
	hGlobal.UI.ChallengeMapRewardFrm = hUI.frame:new({
		dragable = 2,
		x = hVar.SCREEN.w/2 - 400,
		y = hVar.SCREEN.h/2 + 250,
		w = _w,
		h = _h,
		show = 0,
		background = "UI:tip_item",
		border = 1,
	})

	local _frm = hGlobal.UI.ChallengeMapRewardFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--临时UI管理
	local removeList = {}
	--清空所有临时UI
	local _removeFunc = function()
		for i = 1,#removeList do
			hApi.safeRemoveT(_childUI,removeList[i]) 
		end
		removeList = {}
	end
	
	--弹出警告文字
	local __popText = function(strText)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 - 20,
			y = hVar.SCREEN.h / 2 - 220,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText,hVar.FONTC,40,"MC",32,0)
	end
	
	--关卡名称
	_childUI["mapName"] = hUI.node:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = 10,
	})
	
	_childUI["mapName"].childUI["img"] = hUI.image:new({
		parent = _childUI["mapName"].handle._n,
		model = "UI:MedalDarkImg",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = 0,
		w = 400,
		h = 61,
	})

	_childUI["mapName"].childUI["lab"] = hUI.label:new({
		parent = _childUI["mapName"].handle._n,
		x = 0,
		y = 0,
		text = "",
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,205,55},
	})
	
	--面板的关闭方法
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack",
		label = hVar.tab_string["__TEXT_CHALLENGE_EXIT"],
		x = 120,
		y = -_frm.data.h + 60,
		scaleT = 0.9,
		code = function()
			--防止宝箱抽取过程中退出
			if __getEngryFlag == 1 then
				return
			end
			--清空动画标记
			ANIM_IN_ACTION = 0
			ANIM_REWARD_FLY = 0
			ANIM_REWARD_IDXS = {}
			ANIM_CARD = nil
			ANIM_SLOT = nil
			__getEngryFlag = 0
			--清空动画定时器
			hApi.clearTimer("__ChallengeRollRewardAni")
			--关闭界面
			_frm:show(0)
			_removeFunc()
			--重新打开关卡详细信息页面
			hGlobal.event:event("LocalEvent_Phone_ShowChallengeMapInfoFrm",__chapterId)
		end,
	})

	--重抽按钮
	_childUI["rollBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack",
		label = hVar.tab_string["__TEXT_CHALLENGE_ROLL_KEY"],
		x = _frm.data.w - 120,
		y = -_frm.data.h + 60,
		scaleT = 0.9,
		code = function(self)
			_rollBtnClick(self)
		end,
	})
	
	_childUI["keyNowlab"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w - 120,
		y = -_frm.data.h + 100,
		text = hVar.tab_string["RSDYZ_Rest"].. tostring(0),
		size = 22,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,55,55},
	})
	
	local rewardlockInfo = {0, 0, 0, 0,}
	--已抽到道具
	for i = 1, MAX_SLOT do
		--奖励节点
		_childUI["reward"..tostring(i)] = hUI.node:new({
			parent = _parent,
			x = 300 + (i - 1) * 100,
			y = -_frm.data.h + 60,
			z = 1,
		})
		
		--子节点
		local rewardSlot = _childUI["reward"..tostring(i)]
		--背景
		rewardSlot.childUI["imgBg"] = hUI.image:new({
			parent = rewardSlot.handle._n,
			model = "panel/tactic_slot.png",
			x = 0,
			y = 0,
			w = 60,
			h = 80,
		})

		--文字
		rewardSlot.childUI["labLock"] = hUI.label:new({
			parent = rewardSlot.handle._n,
			x = 0,
			y = 0,
			width = 40,
			text = hVar.tab_string["MyVIP"].. tostring(rewardlockInfo[i])..hVar.tab_string["__UNLOCK"],
			size = 18,
			font = hVar.FONTC,
			align = "MC",
			RGB = {255,0,0},
		})
		rewardSlot.childUI["labLock"].handle._n:setVisible(false)

		--锁
		rewardSlot.childUI["lock"] = hUI.image:new({
			parent = rewardSlot.handle._n,
			x = 20,
			y = -30,
			scale = 0.7,
			model = "UI:LOCK",
		})
	end

	--抽卡动画表现外框
	_childUI["cardOutline"] = hUI.image:new({
		parent = _parent,
		model = "MODEL_EFFECT:strengthen",
		x = 100 + math.mod(1 - 1 ,6) * 120,
		y = -150 - (math.floor((1 - 1) / 6) - 1) * 85,
		z = 2,
		w = 60,
		h = 80,
		scale = 2.2
	})

	---------------------------------------------------------------------------------------------------
	--私有函数
	
	--动画循环
	_aniLoop = function()
		
		--如果不在动画播放阶段，则退出
		if ANIM_IN_ACTION <= 0 then
			return
		end
		
		if hApi.gametime() - ANIM_IN_ACTION > ACTION_ROLL_DELT - (#ANIM_REWARD_IDXS * 10) then
			if #ANIM_REWARD_IDXS > 0 then
				--获取最后一个对应的idx
				local idx = ANIM_REWARD_IDXS[#ANIM_REWARD_IDXS]
				local card = _childUI["challengeReward"..tostring(idx)]
				_childUI["cardOutline"].handle._n:setVisible(true)
				_childUI["cardOutline"]:setXY(card.data.x, card.data.y)

				--从队列中删除最后一个
				table.remove(ANIM_REWARD_IDXS, #ANIM_REWARD_IDXS)
			else
				if ANIM_REWARD_FLY <= 0 then
					--本卡牌做向下位移移动
					local actMoveTo = CCMoveTo:create(ACTION_TIME, ccp(ANIM_SLOT.data.x, ANIM_SLOT.data.y))
					local actMoveTo1 = CCMoveTo:create(ACTION_TIME, ccp(ANIM_SLOT.data.x, ANIM_SLOT.data.y))
					local actCall = CCCallFunc:create(function(ctrl)
						--标记不在动画中
						ANIM_IN_ACTION = 0
						ANIM_REWARD_FLY = 0
						_childUI["cardOutline"].handle._n:setVisible(false)
					end)
					local actSeq = CCSequence:createWithTwoActions(actMoveTo, actCall)
					_childUI["cardOutline"].handle._n:runAction(actMoveTo1)
					ANIM_CARD.handle._n:runAction(actSeq)
					ANIM_REWARD_FLY = 1
				end
			end

			ANIM_IN_ACTION = hApi.gametime()
		end
	end
	
	--点击重转按钮
	_rollBtnClick = function(btn)
		--在动画中点击无效
		if ANIM_IN_ACTION > 0 then
			return
		end

		if __getEngryFlag == 1 then
			return
		end

		local limit = 3
		if #__myReward < limit then
			--判断钥匙数量
			--local key = 1 --todo
			--if key > 0 then
				__getEngryFlag = 1
				--发送扣key请求，先发送获取请求
				SendCmdFunc["ENMSG_SCRIPT_ID_CHA_GET"]("energy",0)
				--btn:setstate(0)
			--else
				--发送扣金币请求，这里暂时没有，就直接变灰啦
			--	_childUI["rollBtn"]:setstate(0)
			--end
		else
			__popText(hVar.tab_string["__TEXT_ITEMLISTISFULL"])
		end
	end
	
	--获得挑战次数限制
	_getFightCountLimit = function(countLimitBase)
		local ret = countLimitBase --todo: vip 减少部分 - vipCountLimit
		if ret < 0 then
			ret = 0
		end
		return ret
	end
	
	--随机产生奖励
	_randomReward = function()
		
		local fightCount = (LuaGetPlayerMapAchi(__mapName,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
		
		local maxRandom = 0
		--重新计算总权值
		for i = 1, #__storedReward do
			local tacticId = __storedReward[i][1]
			local fightCountLimit = _getFightCountLimit(__storedReward[i][3])
			local baseRandom = __storedReward[i][2]
			if tacticId and tacticId > 0 and fightCount >= fightCountLimit then
				maxRandom = maxRandom + baseRandom
				__storedReward[i][4] = maxRandom
			end
		end
		
		local r = hApi.random(1, maxRandom)
		local rewardId = nil
		local rewardIdx = 0
		for i = 1, #__storedReward do
			local tacticId = __storedReward[i][1]
			local fightCountLimit = _getFightCountLimit(__storedReward[i][3])
			if tacticId and tacticId > 0 and fightCount >= fightCountLimit then
				local maxValue = __storedReward[i][4]
				local minValue = __storedReward[i][4]
				
				if i > 1 then
					if __storedReward[i - 1] and __storedReward[i - 1][4] then
						minValue = __storedReward[i - 1][4]
					end
				else
					minValue = 0
				end
				
				--判断是否符合条件
				if r > minValue and r <= maxValue then
					rewardId = tacticId
					rewardIdx = i
					break
				end
			end
		end

		if rewardIdx > 0 then
			__storedReward[rewardIdx][1] = 0
		end

		--进一步校验，当前等级能随机到多少个道具
		local myVip = LuaGetPlayerVipLv()
		--local limit = 1
		local limit = 3
		if #__myReward < limit then
			table.insert(__myReward, {rewardIdx,rewardId})
			return rewardIdx, rewardId, #__myReward
		end
	end

	--获得的奖励排序
	_sortReward = function(chapterId)
		local ret = {}

		local chapterInfo = hVar.tab_chapter[chapterId]
		local bossMap = ""
		if chapterInfo then
			bossMap = chapterInfo.bossMap or ""
		end
		local mapTab = hVar.MAP_INFO[bossMap]
		local challengeReward = {}
		if mapTab and mapTab.challengeReward then
			challengeReward = mapTab.challengeReward
		end
		
		--简单的深度拷贝
		for i = 1, #challengeReward do
			table.insert(ret, {challengeReward[i][1], challengeReward[i][2], challengeReward[i][3]})
		end
		
		--重新排序
		table.sort(ret,function(a,b)
			return a[3]<b[3]
		end)
		
		return ret
	end
	
	--创建奖励信息
	_createRewardInfo = function(chapterId)
		--删除上一次的残留内容
		_removeFunc()
		
		local chapterInfo = hVar.tab_chapter[chapterId]
		local bossMap = ""
		if chapterInfo then
			bossMap = chapterInfo.bossMap or ""
		end
		local mapTab = hVar.MAP_INFO[bossMap]
		local bossPortrait = ""
		local mapType = 4
		if mapTab then
			bossPortrait = mapTab.portrait or ""
			mapType = mapTab.mapType or 4
		end
		__mapName = bossMap
		
		--地图名
		_childUI["mapName"].childUI["lab"]:setText(mapTab.name..(hVar.tab_stringM[bossMap][5] or "")..hVar.tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"])
		
		--当前vip等级
		local myVip = LuaGetPlayerVipLv()
		local fightCount = (LuaGetPlayerMapAchi(__mapName,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
		--奖励池
		for i = 1, #__storedReward do
			
			--奖励节点
			_childUI["challengeReward"..tostring(i)] = hUI.node:new({
				parent = _parent,
				x = 100 + math.mod(i - 1 ,6) * 120,
				y = -150 - (math.floor((i - 1) / 6) - 1) * 85,
				z = 1,
			})
			
			--子节点
			local rewardNode = _childUI["challengeReward"..tostring(i)]
			--背景
			rewardNode.childUI["imgBg"] = hUI.image:new({
				parent = rewardNode.handle._n,
				model = "panel/card_back.png",
				x = 0,
				y = 0,
				w = 60,
				h = 80,
			})
			
			local tacticId =  __storedReward[i][1] or 0
			if hVar.tab_tactics[tacticId] then
				local fightCountLimit = _getFightCountLimit(__storedReward[i][3])
				if fightCount >= fightCountLimit then
					local icon = hVar.tab_tactics[tacticId].icon or ""
					
					rewardNode.childUI["imgBg1"] = hUI.image:new({
						parent = rewardNode.handle._n,
						model = "panel/tactic_card_1.png",
						x = 0,
						y = 0,
						w = 60,
						h = 80,
					})
					
					rewardNode.childUI["img"] = hUI.image:new({
						parent = rewardNode.handle._n,
						model = icon,
						x = 0,
						y = -10,
						scale = 0.6,
					})
				end
			end
			
			removeList[#removeList+1] = "challengeReward"..tostring(i)
		end
		
		
		--已抽到道具
		for i = 1, MAX_SLOT do
			--子节点
			local rewardSlot = _childUI["reward"..tostring(i)]
			if rewardSlot then
				if myVip >= rewardlockInfo[i] then
					rewardSlot.childUI["labLock"].handle._n:setVisible(false)
					rewardSlot.childUI["lock"].handle._n:setVisible(false)
				else
					rewardSlot.childUI["labLock"].handle._n:setVisible(true)
					rewardSlot.childUI["lock"].handle._n:setVisible(true)
				end
			end
		end
		
		--判断重抽按钮显示
		--local key = 1
		--if key > 0 then
		--	_childUI["rollBtn"]:setText(hVar.tab_string["__TEXT_CHALLENGE_ROLL_KEY"])
		--else
		--	_childUI["rollBtn"]:setText(hVar.tab_string["__TEXT_CHALLENGE_ROLL_GOLD"])
		--end

		--隐藏抽卡动画外框
		_childUI["cardOutline"].handle._n:setVisible(false)
		
	end
	
	---------------------------------------------------------------------------------------------------
	--注册事件
	hGlobal.event:listen("LocalEvent_Phone_ShowChallengeMapRewardFrm","Phone_showthisfrm",function(chapterId)
		if chapterId and chapterId ~= 0 then
			--变量初始化
			__chapterId = chapterId
			__storedReward = _sortReward(__chapterId)
			__myReward = {}
			ANIM_IN_ACTION = 0
			ANIM_REWARD_FLY = 0
			ANIM_REWARD_IDXS = {}
			ANIM_CARD = nil
			ANIM_SLOT = nil
			__getEngryFlag = 0
			--动画定时器
			hApi.addTimerForever("__ChallengeRollRewardAni",hVar.TIMER_MODE.GAMETIME,100,_aniLoop)
			--刷新界面信息
			_createRewardInfo(__chapterId)
			--获取钥匙数据
			SendCmdFunc["ENMSG_SCRIPT_ID_CHA_GET"]("energy",0)
			--显示界面
			_frm:show(1)
			_frm:active()
		else
			--变量恢复默认值
			__chapterId = 1
			__storedReward = {}
			__myReward = {}
			ANIM_IN_ACTION = 0
			ANIM_REWARD_FLY = 0
			ANIM_REWARD_IDXS = {}
			ANIM_CARD = nil
			ANIM_SLOT = nil
			__getEngryFlag = 0
			--清空动画定时器
			hApi.clearTimer("__ChallengeRollRewardAni")
			--关闭界面
			_frm:show(0)
			_removeFunc()
		end
	end)

	--切场景把自己藏起来
	local temp_map_difficult = 0
	local temp_map_enemy_num = 0
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__Phone_UI__HideChallengeMapInfoFrm",function(sSceneType,oWorld,oMap)
		--变量恢复默认值
		__chapterId = 1
		__storedReward = {}
		__myReward = {}
		ANIM_IN_ACTION = 0
		ANIM_REWARD_FLY = 0
		ANIM_REWARD_IDXS = {}
		ANIM_CARD = nil
		ANIM_SLOT = nil
		__getEngryFlag = 0
		_frm:show(0)
		_removeFunc()
	end)
	
	--网络连接情况显示
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","challengeMapInfoFrm_net_state_change", function(connect_state)
		if connect_state == 1 then
			_childUI["rollBtn"]:setstate(1)
		else
			_childUI["rollBtn"]:setstate(0)
		end
	end)
	
	--获取当前key回调
	hGlobal.event:listen("LocalEvent_GetEnergy_Success", "challengeMapInfoFrm_get_energy", function(val)
		--刷新界面
		if val > 0 then
			_childUI["rollBtn"]:setstate(1)
			local engryNow = val
			if __getEngryFlag == 1 then
				engryNow = val - 1
				SendCmdFunc["ENMSG_SCRIPT_ID_CHA_SET"]("energy",0,engryNow)
			end
			_childUI["keyNowlab"]:setText(hVar.tab_string["RSDYZ_Rest"].. tostring(engryNow))
		else
			if __getEngryFlag == 1 then
				__getEngryFlag = 0
			end
			_childUI["rollBtn"]:setstate(0)
			_childUI["keyNowlab"]:setText(hVar.tab_string["RSDYZ_Rest"].. tostring(val))
		end
	end)
	
	--设置key回调
	hGlobal.event:listen("LocalEvent_SetEnergy_Return", "challengeMapInfoFrm_set_energy", function(iErrCode, key)
		print("__________________________LocalEvent_SetEnergy_Return0: ".. tostring(key).. ",".. tostring(__getEngryFlag))
		if __getEngryFlag == 1 then
			print("__________________________LocalEvent_SetEnergy_Return00")
			--返回成功
			if iErrCode == 0 then
				print("__________________________LocalEvent_SetEnergy_Return1")
				--随机产生动画播放序列
				local baseReward = {}
				--去掉队列中已经抽完的奖励
				local fightCount = (LuaGetPlayerMapAchi(__mapName,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
				for i = 1, #__storedReward do
					local tacticId = __storedReward[i][1]
					local fightCountLimit = _getFightCountLimit(__storedReward[i][3])
					if tacticId and tacticId > 0 and fightCount >= fightCountLimit then
						table.insert(baseReward, i)
					end
				end
				print("__________________________LocalEvent_SetEnergy_Return2")
				
				--生成随机列表
				for i = 1, 30 do
					local rIdx = hApi.random(1, #baseReward)
					table.insert(ANIM_REWARD_IDXS, baseReward[rIdx])
				end
				print("__________________________LocalEvent_SetEnergy_Return3")
				--生成奖励
				local rewardIdx, rewardId, rewardSlotIdx = _randomReward()
				print("__________________________LocalEvent_SetEnergy_Return4:".. tostring(rewardIdx).. ",".. tostring(rewardId)..",".. tostring(rewardSlotIdx))
				if rewardIdx and rewardId and rewardSlotIdx and rewardIdx > 0 and rewardId > 0 then
					print("__________________________LocalEvent_SetEnergy_Return5")
					--给战术技能卡
					LuaAddPlayerSkillBook(rewardId, 1, 1)
					
					--将抽到的卡牌索引插入到动画播放列表的第一个
					table.insert(ANIM_REWARD_IDXS, 1, rewardIdx)
					
					--界面表现
					ANIM_CARD = _childUI["challengeReward"..tostring(rewardIdx)]
					ANIM_SLOT = _childUI["reward"..tostring(rewardSlotIdx)]
					
					--开始播放动画
					ANIM_IN_ACTION = hApi.gametime()
				end
				__getEngryFlag = 0
			else --返回失败
				__getEngryFlag = 0
				print("__________________________LocalEvent_SetEnergy_Return000")
			end
		end
	end)
end




--无尽关卡信息界面
hGlobal.UI.InitEndlessMapInfoFrm = function()
	local _w, _h = 880, 590
	local _removeFunc = hApi.DoNothing
	local _refreshMapInfo = hApi.DoNothing --初始化无尽地图界面
	local on_receive_refresh_systime_event = hApi.DoNothing --收到获得系统时间的回调
	local on_receive_billboardT_event = hApi.DoNothing --收到排行榜静态数据模板的回调
	local refresh_combat_evalution_timer = hApi.DoNothing --刷新排行榜倒计时的timer
	local _closePanelListener = hApi.DoNothing --关闭本界面和监听
	local _showTodayBanDiffTip = hApi.DoNothing --显示今日的相关禁用、难度控制等信息tip
	
	--逻辑控制变量，当前选择关卡模式
	local __MAPMODE = hVar.MAP_TD_TYPE.ENDLESS --地图模式
	local __MAP_NAME = "" --地图名
	local __MAPDIFF = 0 --难度等级
	local __STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
	local __BillBoardT = nil --排行榜静态表
	local __lasHostTime = 0 --上次获取的服务器时间
	
	--无尽关卡信息主面板
	hGlobal.UI.PhoneEndlessMapInfoFrm = hUI.frame:new({
		dragable = 2,
		x = hVar.SCREEN.w/2 - 440,
		y = hVar.SCREEN.h/2 + 285,
		w = _w,
		h = _h,
		show = 0,
		background = "UI:tip_item",
		border = 1,
		codeOnTouch = function(self, x, y, sus)
			if (sus == 0) then
				--关闭本界面和监听
				_closePanelListener()
			end
		end,
	})
	
	local _frm = hGlobal.UI.PhoneEndlessMapInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--临时UI管理
	local removeList = {}
	--清空所有临时UI
	local _removeFunc = function()
		for i = 1,#removeList do
			hApi.safeRemoveT(_childUI, removeList[i]) 
		end
		removeList = {}
	end
	
	--关闭本界面和监听
	_closePanelListener = function()
		--清空数据
		__MAP_NAME = ""
		__MAPMODE = hVar.MAP_TD_TYPE.ENDLESS
		__MAPDIFF = 0
		--FrmGB:show(0)
		
		--取消监听
		--取消监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryComBatEvaluationTime", nil)
		--取消监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", nil)
		
		--取消本界面的timer
		hApi.clearTimer("__COMBAT_EVALUTION_TIMER_UPDATE__")
		
		--标记当前的状态为初始化
		__STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
		__BillBoardT = nil
		__lasHostTime = 0
		
		--隐藏界面并移除临时控件
		_frm:show(0)
		_removeFunc()
	end
	
	--面板的关闭方法
	--btnClose
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w-12,
		y = -12,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		code = function()
			--关闭本界面和监听
			_closePanelListener()
		end,
	})
	
	--关卡名称
	_childUI["mapName"] = hUI.node:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = 10,
	})
	
	_childUI["mapName"].childUI["img"] = hUI.image:new({
		parent = _childUI["mapName"].handle._n,
		model = "UI:MedalDarkImg",
		--model = "misc/tipMinBG.png",
		x = 0,
		y = 0,
		w = 200,
		h = 41,
	})
	
	_childUI["mapName"].childUI["lab"] = hUI.label:new({
		parent = _childUI["mapName"].handle._n,
		x = 0,
		y = 0,
		text = "",
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		RGB = {255,205,55},
		border = 1,
	})
	
	--"地图信息"标题
	_childUI["labMapInfoTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -40,
		text = hVar.tab_string["__TEXT_MAP_INFO"],
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--地图信息内容
	_childUI["mapInfo"] = hUI.label:new({
		parent = _parent,
		x = 210,
		y = -40,
		text = "",
		size = 26,
		width = 640,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	--"最高战绩"标题
	_childUI["labCombatEvaluationMaxTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -200,
		--text = "最高战绩", --language
		text = hVar.tab_string["PVPFightMarkMax"], --language
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--最高战绩图标
	_childUI["imgCombatEvaluation"] = hUI.image:new({
		parent = _parent,
		x = 230,
		y = -215,
		scale = 0.7,
		model = "ICON:icon01_x1y1",
	})
	
	--最高战绩值
	_childUI["labCombatEvaluationMax"] = hUI.label:new({
		parent = _parent,
		x = 255,
		y = -200,
		text = "0",
		size = 26,
		--font = hVar.FONTC,
		font = "numWhite",
		align = "LT",
		--RGB = {0,255,0},
	})
	
	--"今日限制"标题
	_childUI["labCombatEvaluationLimit"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -260,
		--text = "今日限制", --language
		text = hVar.tab_string["PVPFightLinit"], --language
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--今日限制正在获取的菊花
	_childUI["labCombatEvaluationLimitWaiting"] = hUI.image:new({
		parent = _parent,
		x = 230,
		y = -275,
		scale = 0.7,
		model = "MODEL_EFFECT:waiting",
	})
	
	--今日限制的内容
	_childUI["labCombatEvaluationLimitIntro"] = hUI.label:new({
		parent = _parent,
		x = 210,
		y = -260,
		text = "",
		size = 26,
		width = 640,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	--今日限制的内容的查看点击事件（只响应事件，不显示）
	_frm.childUI["btnLimitTip"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		x = 210 + 290,
		y = -260 - 50,
		w = 650,
		h = 150,
		model = "misc/mask.png",
		--animation = "normal",
		scaleT = 1.0,
		code = function()
			--显示今日的相关禁用、难度控制等信息tip
			_showTodayBanDiffTip()
		end,
	})
	_frm.childUI["btnLimitTip"].handle.s:setOpacity(0) --按钮点击区域，只作为控制用，不用于显示
	
	--"重刷时间"标题
	_childUI["labCombatEvaluationDaoJiShiTitle"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -525,
		--text = "重刷时间", --language
		text = hVar.tab_string["PVPDaoJiShi"], --language
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--倒计时的值
	_childUI["labCombatEvaluationDaoJiShi"] = hUI.label:new({
		parent = _parent,
		x = 210 - 1,
		y = -525 - 1, --数字字体有1像素偏差
		text = "--:--:--",
		size = 21,
		--font = hVar.FONTC,
		font = "numWhite",
		align = "LT",
		--RGB = {0,255,0},
	})
	_childUI["labCombatEvaluationDaoJiShi"].handle.s:setColor(ccc3(0, 255, 0))
	
	--"今日战绩"标题
	_childUI["labCombatEvaluationNowTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -380,
		--text = "今日战绩", --language
		text = hVar.tab_string["PVPFightMark"], --language
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--今日战绩值
	_childUI["labCombatEvaluationToday"] = hUI.label:new({
		parent = _parent,
		x = 210,
		y = -380,
		text = "0",
		size = 26,
		--font = hVar.FONTC,
		font = "numWhite",
		align = "LT",
		--RGB = {0,255,0},
	})
	
	--排行榜tip
	_childUI["labBoardTip"] = hUI.label:new({
		parent = _parent,
		x = 50,
		y = -440,
		text = hVar.tab_string["__TEXT_PVP_LADDER"],--..hVar.tab_string["ios_score"],
		size = 28,
		width = 340,
		font = hVar.FONTC,
		align = "LT",
		RGB = {255,205,55},
		border = 1,
	})
	
	--无尽地图排行榜（只接受控制，不显示）
	_frm.childUI["PageBillBoard"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		x = 240,
		y = -465,
		w = 90,
		h = 90,
		model = "misc/mask.png",
		--animation = "normal",
		scaleT = 0.95,
		code = function()
			--先关闭自身界面
			local lastMapName = __MAP_NAME
			_childUI["closeBtn"].data.code()
			
			--触发事件：显示排行榜面板
			hGlobal.event:event("LocalEvent_Phone_ShowRankBorad", lastMapName)
			--print("触发事件：显示排行榜面板")
		end,
	})
	_frm.childUI["PageBillBoard"].handle.s:setOpacity(0) --按钮点击区域，只作为控制用，不用于显示
	
	_frm.childUI["PageBillBoard"].childUI["image"] = hUI.image:new({
		parent = _frm.childUI["PageBillBoard"].handle._n,
		x = 0,
		y = 0,
		scale = 0.7,
		model = "UI:phb",
	})
	local act1 = CCScaleTo:create(1.2, 0.75)
	local act2 = CCScaleTo:create(1.2, 0.7)
	local a = CCArray:create()
	a:addObject(act1)
	a:addObject(act2)
	local sequence = CCSequence:create(a)
	_frm.childUI["PageBillBoard"].childUI["image"].handle.s:runAction(CCRepeatForever:create(sequence))
	
	--GameCenter按钮
	if (hApi.CheckGCShow() == 1) then
	--if true then
		--GameCenter接受事件的按钮
		local GGZJ_Tick_Time = -2001
		_frm.childUI["PageGameCenter"] = hUI.button:new({
			parent = _parent,
			dragbox = _frm.childUI["dragBox"],
			x = 250 + 90,
			y = -465,
			w = 90,
			h = 90,
			model = "misc/mask.png",
			--animation = "normal",
			scaleT = 0.95,
			code = function()
				--gamecenter
				--print("已领取" .. i)
				local t = hApi.gametime()
				if ((t - GGZJ_Tick_Time) < 2000) then
					--return
				else
					--gamecenter图片灰掉
					_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(false)
					_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(true)
					
					--显示gamecenter菊花
					_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(true)
					
					GGZJ_Tick_Time = t
					if(xlGameCenter_authenticateLocalUser) then
						xlGameCenter_authenticateLocalUser(1)
					end
					
					--模拟触发
					--hGlobal.event:event("Event_GameCenter_ConnectSuccess")
				end
			end,
		})
		_frm.childUI["PageGameCenter"].handle.s:setOpacity(0) --按钮点击区域，只作为控制用，不用于显示
		
		--gamecenter图片
		_frm.childUI["PageGameCenter"].childUI["image"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 0,
			scale = 1.2,
			model = "UI:gamecenter",
			animation = "normal",
		})
		local act1 = CCScaleTo:create(1.2, 1.3)
		local act2 = CCScaleTo:create(1.2, 1.2)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		local sequence = CCSequence:create(a)
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(true) --一开始显示
		
		--gamecenter灰色
		_frm.childUI["PageGameCenter"].childUI["imageGray"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 0,
			scale = 1.2,
			model = "UI:gamecenter",
			animation = "normal",
		})
		hApi.AddShader(_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s, "gray")
		_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(false) --一开始不显示
		
		--gamecenter转圈圈的图: 菊花
		_frm.childUI["PageGameCenter"].childUI["waiting"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			model = "MODEL_EFFECT:waiting",
			x = -10,
			y = 0,
			w = 56,
			h = 56,
		})
		_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(false) --一开始不显示
	end
	
	--正在查新的大菊花
	--今日限制正在获取的菊花
	_childUI["labCombatEvaluationBigWaiting"] = hUI.image:new({
		parent = _parent,
		x = _frm.data.w * 0.5 + 140,
		y = -540,
		scale = 1.0,
		model = "MODEL_EFFECT:waiting",
	})
	
	--进入无尽地图按钮
	_childUI["gameStart"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ICON:action_attack",
		iconWH = 32,
		dragbox = _childUI["dragBox"],
		--label = "进入挑战", --language
		label = hVar.tab_string["__TEXT_EnterChallenge"], --language
		x = _frm.data.w * 0.5,
		y = -540,
		scaleT = 0.95,
		font = hVar.FONTC,
		border = 1,
		code = function(self)
			--如果当前状态不是查询完毕，不能点开始按钮
			if (__STATE < 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			--if true then
				--提示文字
				--local strText = "正在连接中" --language
				local strText = hVar.tab_string["__TEXT_ConnetingNet"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = 200 + (hVar.SCREEN.h - 768) / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 36, "MC", 0, 0)
				
				return
			end
			
			--检测作弊
			local cheatflag = xlGetIntFromKeyChain("cheatflag")
			local userID = xlPlayer_GetUID()
			if (cheatflag == 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
					font = hVar.FONTC,
					ok = function()
						xlExit()
					end,
				})
				return
			end
			
			--检测本关是否可以进入（通关了前一关才能打）
			if (hApi.IsMapEnableEnter(__MAP_NAME, __MAPDIFF) ~= 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP2"],{
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
				return
			end
			
			--关闭返回不显示
			hGlobal.UI.ShowReturnContinueFrm:show(0)
			
			--隐藏本界面
			_frm:show(0)
			
			if hGlobal.WORLD.LastWorldMap then
				hGlobal.WORLD.LastWorldMap:del()
				hGlobal.WORLD.LastWorldMap = nil
			end
			 
			--关闭同步日志文件（第二把游戏开始时）
			--hApi.SyncLogClose()
			--关闭非同步日志文件（第二把游戏开始时）
			--hApi.AsyncLogClose()
			
			--存储无尽地图开始的时间戳
			--local localTime = os.time()
			--local intTimeNow = localTime - g_localDeltaTime --现在服务器时间戳(Local = Host + deltaTime)
			--g_endlessBeginTime = intTimeNow
			
			--print("__BillBoardT.info[1].prize=", __BillBoardT.info[1].prize)
			xlScene_LoadMap(g_world, __MAP_NAME,__MAPDIFF,__MAPMODE, nil, __BillBoardT.info[1].prize)
			local pId = luaGetplayerDataID()
			--if not pId or pId == 0 then
				SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--end
			--SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			
			print("SendCmdFunc[send_RoleData]:".. tostring(g_curPlayerName).. "," .. tostring(LuaGetPlayerScore()))
			--print(""..nil)
			--有米统计用
			--if __MAP_NAME == "world/level_tyjy" then
			--	SendCmdFunc["send_YM_EnterMap"]()
			--end
			--if xlUpdateCustomTable then
			--	if g_vs_number <= 4 then
			--		local cur_rmb,cur_score = (xlGetGameCoinNum() or 0 ), LuaGetPlayerScore() or 0
			--		xlUpdateCustomTable(0,"gamecoin",cur_rmb)
			----		xlUpdateCustomTable(0,"gamescore",cur_score)
			---	else
			--		SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
			--		SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--	end
			--end
			
			--关闭本界面和监听
			_closePanelListener()
		end,
	})
	_childUI["gameStart"].childUI["label"].handle._n:setPosition(-45, 15)
	_childUI["gameStart"].childUI["icon"].handle._n:setPosition(-65, 1)
	
	--初始化无尽地图信息
	_refreshMapInfo = function(mapname)
		--删除上一次的残留内容
		_removeFunc()
		
		local mapTab = hVar.MAP_INFO[mapname]
		local mapType = mapTab.mapType --地图等级
		
		--更新无尽地图名
		local name = mapTab.name..(hVar.tab_stringM[mapname][5] or "")
		_childUI["mapName"].childUI["lab"]:setText(name)
		
		--更新无尽地图信息
		local mapInfo = mapTab.info
		_childUI["mapInfo"]:setText(mapInfo)
		
		--更新最高战绩
		local score = LuaGetPlayerGamecenter_Challenge(mapname)
		_childUI["labCombatEvaluationMax"]:setText(tostring(score))
		
		--显示今日限制菊花显示，并隐藏掉文字
		_childUI["labCombatEvaluationLimitWaiting"].handle.s:setVisible(true)
		_childUI["labCombatEvaluationLimitIntro"]:setText("")
		
		--更新倒计时的值
		_childUI["labCombatEvaluationDaoJiShi"]:setText("--:--:--")
		
		--更新今日战绩
		_childUI["labCombatEvaluationToday"]:setText("--")
		
		--显示正在查询的大菊花，并禁用开始按钮
		_childUI["labCombatEvaluationBigWaiting"].handle.s:setVisible(true)
		hApi.AddShader(_childUI["gameStart"].handle.s, "gray")
		
		--添加监听只在本界面打开时的事件
		--监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryComBatEvaluationTime", on_receive_refresh_systime_event)
		--监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", on_receive_billboardT_event)
		
		--添加只有本界面打开才会有的timer
		hApi.addTimerForever("__COMBAT_EVALUTION_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_combat_evalution_timer)
		
		--标记当前的状态为正在查询服务器时间
		__STATE = 1 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
		__lasHostTime = 0
		
		--发起查询服务器系统时间
		SendCmdFunc["refresh_systime"]()
	end
	
	--收到服务器时间的时间
	on_receive_refresh_systime_event = function()
		--只处理正在查询服务器时间的状态
		if (__STATE == 1) then
			--标记当前状态为正在查询静态数据
			__STATE = 2 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			
			--标记上次获取的服务器时间
			--geyachao: 转化为北京时间再计算
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			__lasHostTime = hApi.GetNewDate(g_systime)
			__lasHostTime = __lasHostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--更新倒计时
			refresh_combat_evalution_timer()
			
			--更新今日战绩
			local bId = 0 --billId
			for i = 1, #hVar.BILL_BOARD_MAP, 1 do
				if (hVar.BILL_BOARD_MAP[i].mapName == __MAP_NAME) then
					bId = hVar.BILL_BOARD_MAP[i].bid
					break
				end
			end
			local scoreToday = LuaGetPlayerBillBoard(g_curPlayerName, bId)
			_childUI["labCombatEvaluationToday"]:setText(scoreToday)
			
			--查询排行榜静态数据模板
			SendCmdFunc["get_billboardT"](bId)
		end
	end
	
	--收到排行榜静态数据模板的回调
	on_receive_billboardT_event = function(billboardT)
		--只处理正在查询静态数据的状态
		if (__STATE == 2) then
			--标记当前状态为查询完毕
			__STATE = 3 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			__BillBoardT = billboardT
			
			--隐藏今日限制的菊花，显示文字
			_childUI["labCombatEvaluationLimitWaiting"].handle.s:setVisible(false)
			
			--隐藏正在查询的大菊花，可以使用开始按钮
			_childUI["labCombatEvaluationBigWaiting"].handle.s:setVisible(false)
			hApi.AddShader(_childUI["gameStart"].handle.s, "normal")
			
			--存储此刻的时间，为进入游戏的时间
			local localTime = os.time()
			local intTimeNow = localTime - g_localDeltaTime --现在服务器时间戳(Local = Host + deltaTime)
			--geyachao: 转化为北京时间再计算
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			intTimeNow = intTimeNow - delteZone * 3600 --服务器时间(北京时区)
			g_endlessBeginTime = os.date("%Y-%m-%d %H:%M:%S", intTimeNow) --（字符串）（北京时区）
			--print("游戏的时间", g_endlessBeginTime)
			
			--测试 --test
			--[[
			billboardT.info[1].prize.lv_tower = 2
			billboardT.info[1].prize.lv_tactic = 3
			billboardT.info[1].prize.ban_hero = {18001}
			billboardT.info[1].prize.ban_tower = {1018, 1019}
			billboardT.info[1].prize.ban_tactic = {1039, 1040}
			billboardT.info[1].prize.diff_tactic = {{1201, 4}, {1205, 2}}
			]]
			
			--显示今日限制的文字
			local bIsHaveLimit = false --是否存在限制
			local strLimit = "" --文字秒数
			local lv_tower = billboardT.info[1].prize.lv_tower --塔的最高等级
			local lv_tactic = billboardT.info[1].prize.lv_tactic --战术卡的最高等级
			if (lv_tower) and (lv_tower > 0) then
				bIsHaveLimit = true --存在限制
				--strLimit = strLimit .. "塔最高等级:" .. lv_tower .. "级" .. "        " --language
				strLimit = strLimit .. hVar.tab_string["__TEXT_SOLDIER_TOWER"] .. hVar.tab_string["__TEXT_MAX_LV"] .. ":" .. lv_tower .. hVar.tab_string["__TEXT_ji"] .. "        " --language
			end
			if (lv_tactic) and (lv_tactic > 0) then
				bIsHaveLimit = true --存在限制
				--strLimit = strLimit .. "战术卡最高等级:" .. lv_tactic .. "级" --language
				strLimit = strLimit .. hVar.tab_string["TacticCardPage"] .. hVar.tab_string["__TEXT_MAX_LV"] .. ":" .. lv_tactic .. hVar.tab_string["__TEXT_ji"] --language
			end
			_childUI["labCombatEvaluationLimitIntro"]:setText(strLimit)
			
			--显示禁用的相关图标
			local index = 0
			local offsetX = 58
			local offsetY = -330
			if (strLimit == "") then --如果没有英雄、塔、战术卡的等级限制，图标往上挪一些
				offsetY = -280
			end
			--禁用的英雄
			local ban_hero = billboardT.info[1].prize.ban_hero
			if (ban_hero) and (#ban_hero > 0) then
				bIsHaveLimit = true --存在限制
				
				for j = 1, #ban_hero, 1 do
					index = index + 1
					
					--英雄图标
					local heroId = ban_hero[j]
					if hVar.tab_unit[heroId] then
						_childUI["banHero" .. j] = hUI.button:new({ --作为button是为了显示正常
							parent = _parent,
							x = 230 + (index - 1) * offsetX,
							y = offsetY,
							model = hVar.tab_unit[heroId].portrait,
							w = 48,
							h = 48,
						})
						hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
						removeList[#removeList + 1] = "banHero" .. j
						
						--禁用图标
						_childUI["banHero" .. j].childUI["banicon"] = hUI.image:new({
							parent = _childUI["banHero" .. j].handle._n,
							x = 10,
							y = -10,
							model = "UI:ban",
							w = 24,
							h = 24,
						})
					end
				end
			end
			
			--禁用的塔
			local ban_tower = billboardT.info[1].prize.ban_tower
			if (ban_tower) and (#ban_tower > 0) then
				bIsHaveLimit = true --存在限制
				
				for j = 1, #ban_tower, 1 do
					index = index + 1
					
					--塔的图标
					local towerId = ban_tower[j]
					if hVar.tab_tactics[towerId] then
						_childUI["banTower" .. j] = hUI.button:new({ --作为button是为了显示正常
							parent = _parent,
							x = 230 + (index - 1) * offsetX,
							y = offsetY,
							model = hVar.tab_tactics[towerId].icon,
							w = 48,
							h = 48,
						})
						removeList[#removeList + 1] = "banTower" .. j
						
						--禁用图标
						_childUI["banTower" .. j].childUI["banicon"] = hUI.image:new({
							parent = _childUI["banTower" .. j].handle._n,
							x = 10,
							y = -10,
							model = "UI:ban",
							w = 24,
							h = 24,
						})
					end
				end
			end
			
			--禁用的战术卡
			local ban_tactic = billboardT.info[1].prize.ban_tactic
			if (ban_tactic) and (#ban_tactic > 0) then
				bIsHaveLimit = true --存在限制
				
				for j = 1, #ban_tactic, 1 do
					index = index + 1
					
					--战术卡图标
					local tacticId = ban_tactic[j]
					if hVar.tab_tactics[tacticId] then
						_childUI["banTactic" .. j] = hUI.button:new({ --作为button是为了显示正常
							parent = _parent,
							x = 230 + (index - 1) * offsetX,
							y = offsetY,
							model = hVar.tab_tactics[tacticId].icon,
							w = 48,
							h = 48,
						})
						removeList[#removeList + 1] = "banTactic" .. j
						
						--禁用图标
						_childUI["banTactic" .. j].childUI["banTactic"] = hUI.image:new({
							parent = _childUI["banTactic" .. j].handle._n,
							x = 10,
							y = -10,
							model = "UI:ban",
							w = 24,
							h = 24,
						})
					end
				end
			end
			
			--敌人增益buff
			local diff_tactic = billboardT.info[1].prize.diff_tactic
			if (diff_tactic) and (#diff_tactic > 0) then
				bIsHaveLimit = true --存在限制
				
				for j = 1, #diff_tactic, 1 do
					index = index + 1
					
					--增益buff等级背景图
					local tacticId = diff_tactic[j][1]
					local tacticLv = diff_tactic[j][2] or 1
					if hVar.tab_tactics[tacticId] then
						_childUI["diffTactic" .. j] = hUI.button:new({ --作为button是为了显示正常
							parent = _parent,
							x = 230 + (index - 1) * offsetX,
							y = offsetY,
							model = hVar.tab_tactics[tacticId].icon,
							w = 48,
							h = 48,
						})
						removeList[#removeList + 1] = "diffTactic" .. j
						
						--[[
						--等级的背景图
						_childUI["diffTactic" .. j].childUI["lvBG"] = hUI.image:new({
							parent = _childUI["diffTactic" .. j].handle._n,
							x = 18,
							y = 18,
							model = "ui/pvp/pvpselect.png",
							w = 28,
							h = 28,
						})
						
						--等级值
						_childUI["diffTactic" .. j].childUI["Lv"] = hUI.label:new({
							parent = _childUI["diffTactic" .. j].handle._n,
							x = 18,
							y = 18 - 1, --数字字体有1像素偏差
							text = tacticLv,
							size = 21,
							font = "numWhite",
							align = "MC",
							width = 200,
						})
						]]
						--勾勾图片
						_childUI["diffTactic" .. j].childUI["gougou"] = hUI.image:new({
							parent = _childUI["diffTactic" .. j].handle._n,
							x = 10,
							y = -10,
							model = "UI:finish",
							w = 26,
							h = 20,
						})
					end
				end
			end
			
			--如果以上全部没有限制，那么显示文字"无"
			if (not bIsHaveLimit) then
				--strLimit = "无" --language
				strLimit = hVar.tab_string["__TEXT_Nothing"] --languageh
				_childUI["labCombatEvaluationLimitIntro"]:setText(strLimit)
			end
		end
	end
	
	--刷新排行榜倒计时的timer
	refresh_combat_evalution_timer = function()
		--print("刷新排行榜倒计时的timer")
		--状态是初始化，那么直接返回
		if (__STATE <= 1) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			return
		end
		
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--客户端的时间
		local localTime = os.time()
		
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		--geyachao: 转化为北京时间再计算
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		--计算第二天0点的时间
		local tab = os.date("*t", hostTime)
		local year = tab.year
		local month = tab.month
		local szMonth = tostring(month)
		if (#szMonth < 2) then
			szMonth = "0" .. szMonth
		end
		local day = tab.day
		local szDay = tostring(day)
		if (#szDay < 2) then
			szDay = "0" .. szDay
		end
		local szTime = year .. "-" .. szMonth .. "-" .. szDay .. " 00:00:00"
		local nextDayTime = hApi.GetNewDate(szTime, "DAY", 1) --第二天0点的时间戳
		local deltaSeconds = nextDayTime - hostTime --秒数
		local hour = math.floor(deltaSeconds / 3600) --时
		local minute = math.floor((deltaSeconds - hour * 3600)/ 60) --分
		local second = deltaSeconds - hour * 3600 - minute * 60 --秒
		
		--拼接字符串
		local szHour = tostring(hour) --时(字符串)
		if (#szHour < 2) then
			szHour = "0" .. szHour
		end
		local szMinute = tostring(minute) --分(字符串)
		if (#szMinute < 2) then
			szMinute = "0" .. szMinute
		end
		local szSecond = tostring(second) --秒(字符串)
		if (#szSecond < 2) then
			szSecond = "0" .. szSecond
		end
		
		local text = szHour .. ":" .. szMinute .. ":" .. szSecond
		_childUI["labCombatEvaluationDaoJiShi"]:setText(text)
		
		--检测是否到了第二天，要重新获取
		local tab1 = os.date("*t", __lasHostTime)
		local tab2 = os.date("*t", hostTime)
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			--标记当前的状态为初始化
			__STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			__BillBoardT = nil
			
			--初始化界面控件
			_refreshMapInfo(__MAP_NAME)
			--print("初始化界面控件")
		end
	end
	
	--显示今日的相关禁用、难度控制等信息tip
	_showTodayBanDiffTip = function()
		--先清除上一次的tip
		if hGlobal.UI.BanDiffBoardInfoFrame then
			hGlobal.UI.BanDiffBoardInfoFrame:del()
			hGlobal.UI.BanDiffBoardInfoFrame = nil
		end
		
		--如果本地未获得排行榜静态数据，不显示tip
		if (not __BillBoardT) then
			return
		end
		
		--创建排行榜说明面板
		hGlobal.UI.BanDiffBoardInfoFrame = hUI.frame:new({
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
					--hGlobal.UI.ItemMergeInfoFrame:del()
					--hGlobal.UI.ItemMergeInfoFrame = nil
					--print("点击事件（有可能在控件外部点击）")
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.BanDiffBoardInfoFrame:active()
		
		local billboardT = __BillBoardT
		local lv_tower = billboardT.info[1].prize.lv_tower --塔的最高等级
		local lv_tactic = billboardT.info[1].prize.lv_tactic --战术卡的最高等级
		local ban_hero = billboardT.info[1].prize.ban_hero --禁用的英雄
		local ban_tower = billboardT.info[1].prize.ban_tower --禁用的塔
		local ban_tactic = billboardT.info[1].prize.ban_tactic --禁用的战术卡
		local diff_tactic = billboardT.info[1].prize.diff_tactic --敌人增益buff
		
		local _RankTipParent = hGlobal.UI.BanDiffBoardInfoFrame.handle._n
		local _BanDiffTipChildUI = hGlobal.UI.BanDiffBoardInfoFrame.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2
		local offsetX = 58
		
		--创建tip图片背景
		--[[
		_BanDiffTipChildUI["ItemBG_1"] = hUI.image:new({
			parent = _RankTipParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY,
			w = 680,
			h = 400,
		})
		_BanDiffTipChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY, 680, 400, hGlobal.UI.BanDiffBoardInfoFrame)
		img9:setOpacity(204)
		
		--创建tip-标题
		_BanDiffTipChildUI["BanDiffBoardName"] = hUI.label:new({
			parent = _RankTipParent,
			size = 32,
			x = _offX,
			y = _offY + 160,
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			--text = "今日限制", --language
			text = hVar.tab_string["PVPFightLinit"], --language
			border = 1,
		})
		_BanDiffTipChildUI["BanDiffBoardName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--当前的x, y位置
		local current_PosX = _offX - 310
		local current_PosY = _offY + 120
		
		--[[
		--创建tip-"英雄最高等级"标题
		_BanDiffTipChildUI["BanDiff_HeroMaxLv"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 310,
			y = _offY + 80,
			width = 650,
			align = "LT",
			font = hVar.FONTC,
			--text = "英雄最高等级", --language
			text = hVar.tab_string["hero"] .. hVar.tab_string["__TEXT_MAX_LV"], --language
			border = 1,
			RGB = {255,205,55},
		})
		
		--创建tip-英雄最高等级值
		_BanDiffTipChildUI["BanDiff_HeroMaxLv_Value"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 110,
			y = _offY + 80,
			width = 650,
			align = "LT",
			font = hVar.FONTC,
			--text = "无限制", --language
			text = hVar.tab_string["__TEXT_NO_LIMIT"], --language
			border = 1,
			RGB = {128, 128, 128},
		})
		]]
		
		local bIsHaveLimit = false --是否存在限制
		
		--塔有最高等级
		if (lv_tower) and (lv_tower > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"塔最高等级"标题
			_BanDiffTipChildUI["BanDiff_TowerMaxLv"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "塔最高等级", --language
				text = hVar.tab_string["__TEXT_SOLDIER_TOWER"] .. hVar.tab_string["__TEXT_MAX_LV"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--创建tip-"塔最高等级"值
			_BanDiffTipChildUI["BanDiffTowerMaxLv_Value"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX + 190,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "x级", --language
				text = lv_tower .. hVar.tab_string["__TEXT_ji"], --language
				border = 1,
				RGB = {255, 255, 255},
			})
			
			--x递增
			current_PosX = current_PosX + 350
			--current_PosY = current_PosY - 40
		end
		
		--战术卡有最高等级
		if (lv_tactic) and (lv_tactic > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"战术卡最高等级"标题
			_BanDiffTipChildUI["BanDiff_TacticMaxLv"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "战术卡最高等级", --language
				text = hVar.tab_string["TacticCardPage"] .. hVar.tab_string["__TEXT_MAX_LV"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--创建tip-"战术卡最高等级"值
			_BanDiffTipChildUI["BanDiffTacticMaxLv_Value"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX + 190,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "x级", --language
				text = lv_tactic .. hVar.tab_string["__TEXT_ji"], --language
				border = 1,
				RGB = {255, 255, 255},
			})
			
			--x恢复
			current_PosX = _offX - 310
			
			--y递减
			current_PosY = current_PosY - 40
		else
			--x恢复
			current_PosX = _offX - 310
			
			--y递减
			--如果存在塔的文字，才换行
			if (lv_tower) and (lv_tower > 0) then
				current_PosY = current_PosY - 40
			end
		end
		
		--禁止使用的英雄
		if (ban_hero) and (#ban_hero > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"禁用的英雄"标题
			_BanDiffTipChildUI["BanDiffBanHero"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY - 15,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "禁用的塔", --language
				text = hVar.tab_string["__TEXT_NOT_ALLOWED"] .. hVar.tab_string["hero"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--依次绘制禁用的英雄
			for j = 1, #ban_hero, 1 do
				local heroId = ban_hero[j]
				if hVar.tab_unit[heroId] then
					_BanDiffTipChildUI["BanDiffBanHero" .. j] = hUI.button:new({ --作为button是为了显示正常
						parent = _RankTipParent,
						x = current_PosX + 190 + offsetX / 2 + (j - 1) * offsetX,
						y = current_PosY - 25,
						model = hVar.tab_unit[heroId].portrait,
						w = 48,
						h = 48,
					})
					hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
					
					--禁用图标
					_BanDiffTipChildUI["BanDiffBanHero" .. j].childUI["banicon"] = hUI.image:new({
						parent = _BanDiffTipChildUI["BanDiffBanHero" .. j].handle._n,
						x = 10,
						y = -10,
						model = "UI:ban",
						w = 24,
						h = 24,
					})
				end
			end
			
			--y递减
			current_PosY = current_PosY - 40 - 20
		end
		
		--禁止使用的塔
		if (ban_tower) and (#ban_tower > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"禁用的塔"标题
			_BanDiffTipChildUI["BanDiffBanTower"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY - 15,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "禁用的塔", --language
				text = hVar.tab_string["__TEXT_NOT_ALLOWED"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--依次绘制禁用的塔
			for j = 1, #ban_tower, 1 do
				local towerId = ban_tower[j]
				if hVar.tab_tactics[towerId] then
					_BanDiffTipChildUI["BanDiffBanTower" .. j] = hUI.button:new({ --作为button是为了显示正常
						parent = _RankTipParent,
						x = current_PosX + 190 + offsetX / 2 + (j - 1) * offsetX,
						y = current_PosY - 25,
						model = hVar.tab_tactics[towerId].icon,
						w = 48,
						h = 48,
					})
					
					--禁用图标
					_BanDiffTipChildUI["BanDiffBanTower" .. j].childUI["banicon"] = hUI.image:new({
						parent = _BanDiffTipChildUI["BanDiffBanTower" .. j].handle._n,
						x = 10,
						y = -10,
						model = "UI:ban",
						w = 24,
						h = 24,
					})
				end
			end
			
			--y递减
			current_PosY = current_PosY - 40 - 20
		end
		
		--禁止使用的战术卡
		if (ban_tactic) and (#ban_tactic > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"禁用的战术卡"标题
			_BanDiffTipChildUI["BanDiffBanTactic"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY - 15,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "禁用的战术卡", --language
				text = hVar.tab_string["__TEXT_NOT_ALLOWED"] .. hVar.tab_string["TacticCardPage"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--依次绘制禁用的战术卡
			for j = 1, #ban_tactic, 1 do
				local tacticId = ban_tactic[j]
				if hVar.tab_tactics[tacticId] then
					_BanDiffTipChildUI["BanDiffBanTactic" .. j] = hUI.button:new({ --作为button是为了显示正常
						parent = _RankTipParent,
						x = current_PosX + 190 + offsetX / 2 + (j - 1) * offsetX,
						y = current_PosY - 25,
						model = hVar.tab_tactics[tacticId].icon,
						w = 48,
						h = 48,
					})
					
					--禁用图标
					_BanDiffTipChildUI["BanDiffBanTactic" .. j].childUI["banicon"] = hUI.image:new({
						parent = _BanDiffTipChildUI["BanDiffBanTactic" .. j].handle._n,
						x = 10,
						y = -10,
						model = "UI:ban",
						w = 24,
						h = 24,
					})
				end
			end
			
			--y递减
			current_PosY = current_PosY - 40 - 20
		end
		
		--敌人增强buff
		if (diff_tactic) and (#diff_tactic > 0) then
			bIsHaveLimit = true --存在限制
			
			--创建tip-"敌人增益"标题
			_BanDiffTipChildUI["EnemyBuff"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "敌人增益", --language
				text = hVar.tab_string["__TEXT_ENEMY_BUFF"], --language
				border = 1,
				RGB = {255,205,55},
			})
			
			--依次绘制敌人增益buff
			local diff_dy = 40
			for j = 1, #diff_tactic, 1 do
				local tacticId = diff_tactic[j][1]
				local tacticLv = diff_tactic[j][2] or 1
				if hVar.tab_tactics[tacticId] then
					_BanDiffTipChildUI["EnemyBuff" .. j] = hUI.button:new({ --作为button是为了显示正常
						parent = _RankTipParent,
						x = current_PosX + 190 + 22,
						y = current_PosY + 18 - (diff_dy - 1) * j,
						model = hVar.tab_tactics[tacticId].icon,
						w = 32,
						h = 32,
					})
					
					--[[
					--等级的背景图
					_BanDiffTipChildUI["EnemyBuff" .. j].childUI["lvBG"] = hUI.image:new({
						parent = _BanDiffTipChildUI["EnemyBuff" .. j].handle._n,
						x = 10,
						y = 10,
						model = "ui/pvp/pvpselect.png",
						w = 20,
						h = 20,
					})
					
					--等级值
					_BanDiffTipChildUI["EnemyBuff" .. j].childUI["Lv"] = hUI.label:new({
						parent = _BanDiffTipChildUI["EnemyBuff" .. j].handle._n,
						x = 10,
						y = 10 - 1, --数字字体有1像素偏差
						text = tacticLv,
						size = 16,
						font = "numWhite",
						align = "MC",
						width = 200,
					})
					]]
					
					--等级的勾勾图
					_BanDiffTipChildUI["EnemyBuff" .. j].childUI["lvBG"] = hUI.image:new({
						parent = _BanDiffTipChildUI["EnemyBuff" .. j].handle._n,
						x = 8,
						y = -8,
						model = "UI:finish",
						w = 22,
						h = 16,
					})
					
					--等级效果
					_BanDiffTipChildUI["EnemyBuff" .. j].childUI["lvIntro"] = hUI.label:new({
						parent = _BanDiffTipChildUI["EnemyBuff" .. j].handle._n,
						x = 30,
						y = 0,
						text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][tacticLv + 1] or ("未知战术卡" .. tacticId),
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						width = 500,
						border = 1,
					})
				end
			end
			
			--y递减
			current_PosY = current_PosY - 40 - 20
		end
		
		--如果以上全部没有限制，那么显示文字"无"
		if (not bIsHaveLimit) then
			--创建tip-"无"
			_BanDiffTipChildUI["BanDiff_None"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = current_PosX,
				y = current_PosY,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				--text = "无", --language
				text = hVar.tab_string["__TEXT_Nothing"], --language
				border = 1,
			})
		end
	end
	
	--监听：打开无尽地图界面事件，刷新界面
	hGlobal.event:listen("LocalEvent_Phone_ShowEndlessMapInfoFrm","Phone_showthisfrm1", function(map_name)
		--未联网，不能挑战无尽地图
		if (g_cur_net_state == -1) then
			--local srtText = "当前无可用网络，无法挑战无尽试炼" --language
			local srtText = hVar.tab_string["__TEXT_Can_tOpenEndlessMap"] --language
			hGlobal.UI.MsgBox(srtText, {
				font = hVar.FONTC,
				ok = function()
					--
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
		
		__MAP_NAME = map_name
		if (map_name ~= nil) then
			--标记当前的状态为初始化
			__STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			__BillBoardT = nil
			
			--初始化界面控件
			_refreshMapInfo(__MAP_NAME)
			
			--显示界面
			_frm:show(1)
			_frm:active()
			
			--连接pvp服务器
			if (Pvp_Server:GetState() ~= 1) then --未连接
				Pvp_Server:Connect()
			elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
				Pvp_Server:UserLogin()
			end
		end
	end)
	
	--监听：切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__Phone_UI__HideMapInfoFrm", function(sSceneType, oWorld, oMap)
		__MAP_NAME = ""
		__MAPMODE = hVar.MAP_TD_TYPE.ENDLESS
		__MAPDIFF = 0
		_frm:show(0)
		_removeFunc()
	end)
	
	--监听：登入gamecenter成功
	hGlobal.event:listen("Event_GameCenter_ConnectSuccess", "__EndlessMapGameCenter__", function()
		--gamecenter图片亮掉
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(true)
		_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(false)
		
		--不显示gamecenter菊花
		_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(false)
	end)
end
--[[
--测试 --test
if hGlobal.UI.PhoneEndlessMapInfoFrm then --删除上次界面
	hGlobal.UI.PhoneEndlessMapInfoFrm:del()
end
--创建无尽地图查看界面
hGlobal.UI.InitEndlessMapInfoFrm()
--模拟触发事件
hGlobal.event:event("LocalEvent_Phone_ShowEndlessMapInfoFrm", "world/td_wj_001")
--hGlobal.UI.PhoneRankBoardFrm:show(1)
--hGlobal.UI.PhoneSelectedTacticFrm_New:show(1)
--hGlobal.UI.PhoneTaskFrm:show(1)
]]







--[=[
--新的关卡选择界面
hGlobal.UI.InitMapSelectMainFrm = function()
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>选择关卡主操作界面")
	
	--frm只创建一次
	if hGlobal.UI.MapSelectMainFrm_New then
		hGlobal.UI.MapSelectMainFrm_New:del()
		hGlobal.UI.MapSelectMainFrm_New = nil
	end
	
	--创建frm
	hGlobal.UI.MapSelectMainFrm_New = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		z = -2,
		show = 0,
		dragable = 2,
		buttononly = 1,
		autoactive = 0,
		border = 0,
	})
	local _frm = hGlobal.UI.MapSelectMainFrm_New
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--当前操作的地图对象
	local __oMap
	local __isOpenSubFrm = false
	local __chapterId = 1 --当前的章节id
	__g_chapterId = 1 --全局记录
	
	--局部函数
	local _refreshMainFrm = nil
	local __refreshTacticSkillTaskNotes = nil
	local __mailstate = 0 --邮件是否有叹号提示
	local __switchChapter = hApi.DoNothing --章节切换
	local _OnClickPageBtn = nil --点击分页按钮
	
	--geyachao: 显示获得的总星数
	local STAR_DX = (hVar.SCREEN.w - 1024) / 2
	local STAR_DY = 0
	
	--星星控件的父控件
	_childUI["StarNode"] = hUI.node:new({
		parent = _parent,
		x = STAR_DX,
		y = STAR_DY,
	})
	
	--背景图底纹
	_childUI["StarNode"].childUI["TotalStarBG"] = hUI.image:new({
		parent = _childUI["StarNode"].handle._n,
		model = "UI:AttrBg",
		x = 470,
		y = hVar.SCREEN.h - 24,
		w = 290,
		h = 38,
	})
	_childUI["StarNode"].childUI["TotalStarBG"].handle.s:setOpacity(196)
	
	--星星图片
	_childUI["StarNode"].childUI["TotalStar"] = hUI.image:new({
		parent = _childUI["StarNode"].handle._n,
		model = "UI:STAR_YELLOW",
		x = 395,
		y = hVar.SCREEN.h - 24,
		scale = 0.4,
	})
	
	--当前星数 数量文字
	--local totlaStar = LuaGetPlayerCountVal(hVar.MEDAL_TYPE.starCount)
	_childUI["StarNode"].childUI["TotalStarLabel"] =  hUI.label:new({
		parent = _childUI["StarNode"].handle._n,
		x = 475,
		y = hVar.SCREEN.h - 27,
		text = "0",
		size = 23,
		width = 390,
		font = "numWhite",
		align = "RC",
		--border = 1,
	})
	_childUI["StarNode"].childUI["TotalStarLabel"].handle.s:setColor(ccc3(255, 212, 0))
	
	--分割符"/"
	_childUI["StarNode"].childUI["TotalStarSeparateLabel"] =  hUI.label:new({
		parent = _childUI["StarNode"].handle._n,
		x = 485,
		y = hVar.SCREEN.h - 27,
		text = "/",
		size = 23,
		width = 390,
		font = "numWhite",
		align = "MC",
		--border = 1,
	})
	_childUI["StarNode"].childUI["TotalStarSeparateLabel"].handle.s:setColor(ccc3(255, 212, 0))
	
	--本章总星数 数量文字
	_childUI["StarNode"].childUI["TotalStarMaxLabel"] =  hUI.label:new({
		parent = _childUI["StarNode"].handle._n,
		x = 495,
		y = hVar.SCREEN.h - 27,
		--text = hVar.MAX_STAR_NUM,
		text = "0",
		size = 23,
		width = 390,
		font = "numWhite",
		align = "LC",
		--border = 1,
	})
	_childUI["StarNode"].childUI["TotalStarMaxLabel"].handle.s:setColor(ccc3(255, 212, 0))
	
	--=======================================================
	------------------------章节-----------------------------
	
	--切换章节函数
	__switchChapter = function(chapterId)
		--print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrr\n__switchChapter", chapterId)
		--不重复切换章节
		if (chapterId ~= __chapterId) then
			--存储新的章节id
			__chapterId = chapterId
			
			--切换章节
			--print("%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%\n切换章节", chapterId, debug.traceback())
			hGlobal.LocalPlayer:setfocusworld(nil)
			hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
		end
		
		--print("开始刷新", debug.traceback())
		
		--如果当前是第1章，并且没有通关最后一关，那么不显示切换章节的界面
		--local lastMapName = hVar.tab_chapter[chapterId].lastmap --最后一关
		--local isFinishLast = LuaGetPlayerMapAchi(lastMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关最后一关
		
		--[[
		--测试 --test
		--geyachao: 测试期间可以点
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			isFinishLast = 1
		end
		]]
		
		--统计本章节已获得的总星数
		local currentStarSum = 0 --已获得的星数
		local totalStarSum = 0 --本章总星数
		local tabCh = hVar.tab_chapter[chapterId]
		local firstmap = tabCh.firstmap --本章的第一关
		local lastmap = tabCh.lastmap --本章的最后一关
		local lastmapDone = false --本章的最后一关是否计算过了
		local currentmap = firstmap
		while true do
			--附加常规模式的星数
			local star = (LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0) --本关的常规模式的星数
			currentStarSum = currentStarSum + star
			totalStarSum = totalStarSum + 12
			
			--附加挑战困难难度的星数
			local diffMax = (LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0) --当前挑战到了第几个难度
			for n = 1, diffMax - 1, 1 do
				currentStarSum = currentStarSum + 3 --过了前几个挑战，都是3行
				--print("+3")
			end
			
			local diffStar = (LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0) --读取当前难度的星星
			currentStarSum = currentStarSum + diffStar
			--print("currentmap=", currentmap, "star=", star, "diffMax=", diffMax, "diffStar=", diffStar)
			--print("currentStarSum=", currentStarSum)
			
			--跳转到下一个地图
			local tabM = hVar.MAP_INFO[currentmap]
			
			--下一个地图是否存在
			if (tabM == nil) then
				--调试错误信息
				local strText = "地图 " .. "\"" .. tostring(currentmap) .. "\" " .. " 未定义！"
				hGlobal.UI.MsgBox(strText, {
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
				
				break
			end
			
			local nextmap = tabM.nextmap[1] --下一张图
			
			--下一个地图是否有效
			if (nextmap == nil) or (nextmap == currentmap) then
				break
			end
			
			--如果最后一关是已经计算过了，跳出循环
			if lastmapDone then
				--print("如果最后一关是已经计算过了，跳出循环")
				break
			end
			
			--是否到最后一个地图
			if (nextmap == lastmap) then
				lastmapDone = true --标记最后一关是已经计算过了
				--print("标记最后一关是已经计算过了")
			end
			
			--loop
			currentmap = nextmap
		end
		
		--print("loop end")
		
		--更新总星数
		_childUI["StarNode"].childUI["TotalStarMaxLabel"]:setText(totalStarSum)
		
		--更新已获得的星星数量文字
		--local currentStarSum = LuaGetPlayerCountVal(hVar.MEDAL_TYPE.starCount)
		_childUI["StarNode"].childUI["TotalStarLabel"]:setText(currentStarSum)
		
		--_OnClickPageBtn(chapterId, false)
		
		--更新每章的按钮状态
		for i = 1, #hVar.tab_chapter, 1 do
			--本章第一关的前置关卡，是否已通关
			local tChapt = hVar.tab_chapter[i]
			local firstmap = tChapt. firstmap --本章第一关
			local tMap = hVar.MAP_INFO[firstmap]
			local unLock = tMap.unLock or {}
			local unLockMapName = unLock[1] or 0 --解锁的地图
			local isFinishPrevious = 1 --是否通关前置关卡
			if (unLockMapName ~= 0) then
				isFinishPrevious = LuaGetPlayerMapAchi(unLockMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关前置关卡
			end
			local isFinishFirstMap = LuaGetPlayerMapAchi(firstmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关本章第一关
			
			if (isFinishPrevious == 1) then --已通关前置关卡
				--隐藏锁
				_frm.childUI["PageBtn" .. i].childUI["PageLock"].handle.s:setVisible(false)
				
				if (isFinishFirstMap == 1) then --已通关本章第一关
					--隐藏新解锁的叹号
					_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false)
				else
					--显示新解锁的叹号
					_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(true)
				end
				
				--高亮按钮
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "normal")
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s, "normal")
			else --未通关前置关卡
				--显示锁
				_frm.childUI["PageBtn" .. i].childUI["PageLock"].handle.s:setVisible(true)
				
				--隐藏新解锁的叹号
				_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false)
				
				--灰掉按钮
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s, "gray")
			end
		end
	end
	
	------------------------章节按钮-----------------------------
	local _ScaleW = hVar.SCREEN.w / 1280
	local _ScaleH = hVar.SCREEN.h / 768
	--每个分页按钮
	local tPageIcons = {"ICON_world/chapter1", "ICON_world/chapter2", "ICON_world/chapter3", "ICON_world/chapter4", "ICON_world/chapter5", "ICON_world/chapter6"}
	--每个分页的文字
	local tTexts = {"", "", "", "", "", "",} --language
	
	--参数配置
	--iPad
	local nPageX = 0 --按钮x(距离右侧)
	local nPageY = hVar.SCREEN.h / _ScaleH + 42 --按钮y(距离下侧)
	local nPageW = 206 --按钮宽度
	local nPageWL = 290 --长按钮宽度
	local nPageH = 80 --按钮高度
	local nPageOffsetX = 8 --每个按钮间间距微调值
	local nIconX = 0 --图标x
	local nIconY = 22 --图标y
	local nIconW = 120 --图标宽
	local nIconH = 120 --图标高
	local nIconXL = 0 --长图标x
	local nIconYL = 27 --长图标y
	local nIconWL = 130 --长图标宽
	local nIconHL = 130 --长图标高
	
	if (g_phone_mode ~= 0) then --手机模式
		--参数配置
		--iPhone5
		nPageX = -105 --按钮x(距离右侧)
		nPageY = hVar.SCREEN.h / _ScaleH + 47 --按钮y(距离下侧)
		nPageW = 170 --按钮宽度
		nPageWL = 250 --长按钮宽度
		nPageH = 95 --按钮高度
		nPageOffsetX = 7 --每个按钮间间距微调值
		nIconX = 0 --图标x
		nIconY = 23 --图标y
		nIconW = 120 --图标宽
		nIconH = 120 --图标高
		nIconXL = 0 --长图标x
		nIconYL = 28 --长图标y
		nIconWL = 130 --长图标宽
		nIconHL = 130 --长图标高
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			--参数配置
			--iPhone4
			nPageX = -70 --按钮x(距离右侧)
			nPageY = hVar.SCREEN.h / _ScaleH + 45 --按钮y(距离下侧)
			nPageW = 180 --按钮宽度
			nPageWL = 280 --长按钮宽度
			nPageH = 92 --按钮高度
			nPageOffsetX = 7 --每个按钮间间距微调值
			nIconX = 0 --图标x
			nIconY = 18 --图标y
			nIconW = 120 --图标宽
			nIconH = 120 --图标高
			nIconXL = 0 --长图标x
			nIconYL = 23 --长图标y
			nIconWL = 130 --长图标宽
			nIconHL = 130 --长图标高
		end
	end
	
	--依次绘制
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW,
			y = -hVar.SCREEN.h + nPageY * _ScaleH,
			w = nPageW * _ScaleW,
			h = nPageH * _ScaleH,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			code = function(self, screenX, screenY, isInside)
				_OnClickPageBtn(i, true)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮的控制部分，用于处理响应，不显示
		
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:PANEL_MENU_BTN_NORMAL", --"UI:ChestBag_2", --"UI:Tactic_Button",
			x = 0,
			y = 0,
			w = nPageW * _ScaleW,
			h = nPageH * _ScaleH,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = nIconX * _ScaleW,
			y = nIconY * _ScaleH,
			w = nIconW * math.max(_ScaleW, _ScaleH),
			h = nIconH * math.max(_ScaleW, _ScaleH),
		})
		
		--分页按钮的锁
		_frm.childUI["PageBtn" .. i].childUI["PageLock"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:Lock",
			x = nPageW * _ScaleW / 2 - 30,
			y = nPageH * _ScaleH / 2 - 10,
			w = nIconW * math.max(_ScaleW, _ScaleH) / 3,
			h = nIconH * math.max(_ScaleW, _ScaleH) / 3,
		})
		_frm.childUI["PageBtn" .. i].childUI["PageLock"].handle.s:setVisible(false) --默认隐藏
		
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:TaskTanHao",
			x = nPageW * _ScaleW / 2 - 20,
			y = nPageH * _ScaleH / 2 - 10,
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
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 0,
			y = -22 * _ScaleH,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
			text = tTexts[i],
		})
	end
	
	--点击分页按钮函数
	_OnClickPageBtn = function(chapterId, bPlayAmin)
		--print("_OnClickPageBtn", chapterId, bPlayAmin)
		--检测本章是否可点击
		if (chapterId < 1) or (chapterId > (#hVar.tab_chapter)) then
			return
		end
		
		--检测本章是否已解锁
		local tChapt = hVar.tab_chapter[chapterId]
		local firstmap = tChapt. firstmap --本章第一关
		local tMap = hVar.MAP_INFO[firstmap]
		local unLock = tMap.unLock or {}
		local unLockMapName = unLock[1] or 0 --解锁的地图
		local isFinishPrevious = 1 --是否通关前置关卡
		if (unLockMapName ~= 0) then
			isFinishPrevious = LuaGetPlayerMapAchi(unLockMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关前置关卡
		end
		
		--[[
		--测试 --test
		--geyachao: 测试期间可以点
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			isFinishPrevious = 1
		end
		]]
		
		if (isFinishPrevious == 0) then
			--冒字
			--local strText = "您还未解锁本章！" --language
			local strText = hVar.tab_string["NotFinishChapter"] --language
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
		
		--检测是否已经分段更新完成
		if (chapterId > 1) then
			if (not (hApi.IsUpdate2Done())) then
				return
			end
		end
		
		--通过校验
		--切换章节
		__switchChapter(chapterId)
		
		--所有的按钮重算位置，并做动画
		for i = 1, #tPageIcons, 1 do
			local toX = 0
			local toY = -hVar.SCREEN.h + nPageY * _ScaleH
			local toW = nPageW * _ScaleW
			local toH = nPageH * _ScaleH
			local toModel = "UI:PANEL_MENU_BTN_NORMAL"
			local iconModel = tPageIcons[i]
			local iconX = nIconX * _ScaleW
			local iconY = nIconY * _ScaleH
			local iconW = nIconW * math.max(_ScaleW, _ScaleH)
			local iconH = nIconH * math.max(_ScaleW, _ScaleH)
			local labelVisible = false
			
			if (i < chapterId) then --左侧的
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i - 1) * nPageW * _ScaleW - nPageWL * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
			elseif (i == chapterId) then --自身
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageWL / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
				toW = nPageWL * _ScaleW
				toModel = "UI:PANEL_MENU_BTN_BIG"
				iconX = nIconXL * _ScaleW
				iconY = nIconYL * _ScaleH
				iconW = nIconWL * math.max(_ScaleW, _ScaleH)
				iconH = nIconHL * math.max(_ScaleW, _ScaleH)
				labelVisible = true
			else --右侧的
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
			end
			
			--_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
			_frm.childUI["PageBtn" .. i].childUI["PageImage"]:setmodel(toModel, nil, nil, toW, toH)
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"]:setmodel(iconModel, nil, nil, iconW, iconH)
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"]:setXY(iconX, iconY)
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle._n:setVisible(labelVisible)
			
			if bPlayAmin then
				--主界面底部栏往上做运动
				local act1 = CCCallFunc:create(function()
					_frm.childUI["PageBtn" .. i].data.x = toX
				end)
				local act2 = CCMoveTo:create(0.03, ccp(toX, toY))
				local act3 = CCCallFunc:create(function()
					_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				local sequence = CCSequence:create(a)
				_frm.childUI["PageBtn" .. i].handle._n:stopAllActions() --先停掉之前可能的动画
				_frm.childUI["PageBtn" .. i].handle._n:runAction(sequence)
			else
				_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
			end
		end
	end
	
	--刷新选择界面的按钮
	_refreshMainFrm = function(oMap)
		--刷新章节名称
		local chapterId = oMap.data.chapterId
		
		--存储当前打开的章节id，用于新主界面继续进来时，再次选中此章节
		__g_chapterId = chapterId
		
		--if hVar.tab_stringCH[chapterId] then
		--	_childUI["chapterName"].childUI["lab"]:setText(hVar.tab_stringCH[chapterId][1] or "")
		--else
		--	_childUI["chapterName"].childUI["lab"]:setText("")
		--end
		
		--点击章节切换
		--print("点击章节切换", chapterId)
		_OnClickPageBtn(chapterId)
		
		--检测是否有可升级的提示
		__refreshTacticSkillTaskNotes()
	end
	
	--局部函数
	--geyachao: 刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	__refreshTacticSkillTaskNotes = function()
		----------------------------------------------------------------------------
		--检测是否有可以升级的英雄技能、塔、战术技能卡
		local enableSkillUpdate = hApi.IsEnableUpgrateHeroSkill()
		local enableTacticUpdate = hApi.IsEnableUpgrateTacticCard()
		--_childUI[bottomMenuName[1]].childUI["lvup"].handle._n:setVisible(enableSkillUpdate or enableTacticUpdate)
		
		----------------------------------------------------------------------------
		--检测是否存在可以升级的战术技能卡和塔
		--local enableTacticUpdate = hApi.IsEnableUpgrateTacticCard()
		--_childUI[bottomMenuName[2]].childUI["lvup"].handle._n:setVisible(enableTacticUpdate)
		
		----------------------------------------------------------------------------
		--检测是否存在可以领取的成就、任务、活动
		local enableAchievementFinish = hApi.CheckMadel()
		local enableTaskFinish = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
		local enableActivityNew = hApi.CheckNewActivity()
		--print("enableTaskFinish", enableTaskFinish)
		--_childUI[bottomMenuName[3]].childUI["lvup"].handle._n:setVisible(enableTaskFinish or enableAchievementFinish or enableActivityNew)
		
		----------------------------------------------------------------------------
		--刷新pvp的测试期间的倒计时
		--竞技场测试期间
		--g_pvp_room_closetime
		--更新pvp是否有锦囊开启
		local enableArenaChestOpen = (g_myPvP_BaseInfo.arenachest > 0) --是否有擂台锦囊
		local enablePvpChestOpen = hApi.IsEnablePvpChestOpen() --是否有其它锦囊
		local enableChestOpen = (enableArenaChestOpen or enablePvpChestOpen)
		local enableHeroStarUp = hApi.IsEnableUpgrateHeroStar() --是否有英雄升星
		local enableArmyCardLvUp = hApi.IsEnableUpgrateArmyCard() --是否有兵种卡升级
		local enablePVPCardUp = (enableHeroStarUp or enableArmyCardLvUp)
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableChestOpen = false
			enablePVPCardUp = false
		end
		--_childUI[bottomMenuName[6]].childUI["lvup"].handle._n:setVisible(enableArenaChestOpen or enablePvpChestOpen)
		--_childUI["menu_pvp"].childUI["lvup"].handle._n:setVisible(enableChestOpen)
		
		----------------------------------------------------------------------------
		--检测是否到第二天刷新了商城出售的道具
		local enableQueryShop = true
		--读取存档里的今日商城商品列表数据
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--客户端的时间
			local localTime = os.time()
				
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			--客户端上次获取的时间
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime > 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableQueryShop = false
		end
		
		--检测VIP今日奖励是否领取
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		--_childUI[topMenuName[1]].childUI["lvup"].handle._n:setVisible(enableQueryShop or enableVIPDaliyReward)
		
		----------------------------------------------------------------------------
		--检测评价奖励是否完成
		--评价开关打开，没评价过，已通关"救援青州"
		local enableRateOpen = ((g_MyVip_Param.enable == 1) and (LuaGetPlayerGiftstate(3) == 0) and (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) > 0))
		--print(g_MyVip_Param.enable, LuaGetPlayerGiftstate(3), LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL))
		--_childUI[topMenuName[2]].childUI["lvup"].handle._n:setVisible(enableRateOpen)
		
		if (enableSkillUpdate or enableTacticUpdate) or (enablePVPCardUp) then --英雄令可升级、战术卡可升级、英雄升星、兵种卡升级
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(true) --显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(false) --不显示叹号
		elseif (enableTaskFinish or enableAchievementFinish or enableActivityNew) then --成就、任务、活动可升级
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(true) --显示叹号
		elseif (enableChestOpen) then --竞技场可开宝箱
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(true) --显示叹号
		elseif (enableQueryShop or enableVIPDaliyReward) then --商城新一批出售商品或领vip奖励
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(true) --显示叹号
		elseif (enableRateOpen) then --可评价
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(true) --显示叹号
		elseif (__mailstate == 1) then --邮件提示
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(true) --显示叹号
		else
			_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --不显示升级箭头
			_childUI["return"].childUI["tanhao"].handle._n:setVisible(false) --不显示叹号
		end
	end
	
	--顶部返回按钮
	_childUI["return"] = hUI.button:new({
		parent = _frm,
		model = "UI:return",
		--x = 50 + (i - 1) * 90,
		x = hVar.SCREEN.w - 52,
		--y = 93,
		y = hVar.SCREEN.h - 56,
		w = 80,
		h = 80,
		scaleT = 0.95,
		font = hVar.FONTC,
		border = 1,
		code = function()
			--返回主界面
			--hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
			hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
		end,
	})
	--顶部返回按钮的升级箭头提示
	_childUI["return"].childUI["jiantou"] = hUI.image:new({
		parent = _childUI["return"].handle._n,
		x = 22,
		y = -14,
		model = "ICON:image_jiantouV",
		w = 32,
		h = 32,
	})
	_childUI["return"].childUI["jiantou"].handle._n:setVisible(false) --一开始不显示升级箭头
	--顶部返回按钮的叹号提示
	_childUI["return"].childUI["tanhao"] = hUI.image:new({
		parent = _childUI["return"].handle._n,
		x = 22,
		y = -14,
		model = "UI:TaskTanHao",
		w = 32,
		h = 32,
	})
	_childUI["return"].childUI["tanhao"].handle._n:setVisible(false) --一开始不显示叹号
	local act1 = CCMoveBy:create(0.2, ccp(0, 5))
	local act2 = CCMoveBy:create(0.2, ccp(0, -5))
	local act3 = CCMoveBy:create(0.2, ccp(0, 5))
	local act4 = CCMoveBy:create(0.2, ccp(0, -5))
	local act5 = CCDelayTime:create(2.0)
	local a = CCArray:create()
	a:addObject(act1)
	a:addObject(act2)
	a:addObject(act3)
	a:addObject(act4)
	a:addObject(act5)
	local sequence = CCSequence:create(a)
	_childUI["return"].childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__MapSelectFrmShowOrHide", function(sSceneType ,oWorld, oMap)
		--print("LocalEvent_PlayerFocusWorld:".. tostring(oWorld).. ",".. tostring(oMap).. ",".. tostring(sSceneType))
		if oMap and (sSceneType == "chooselevel") then
			__oMap = oMap
			--local chapterId = oMap.data and oMap.data.chapterId or 1 --章节id
			if not hVar.OPTIONS.IS_TD_ENTER or hVar.OPTIONS.IS_TD_ENTER ~= 1 then
				_frm:show(1)
				_frm:active()
				_refreshMainFrm(oMap)
				
				--连接pvp服务器
				if (Pvp_Server:GetState() ~= 1) then --未连接
					Pvp_Server:Connect()
				elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
					Pvp_Server:UserLogin()
				end
			end
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		else
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			--print("显示顶条", "LocalEvent_PlayerFocusWorld", "__isOpenSubFrm = false")
			--__isOpenSubFrm = false
			__oMap = nil
			_frm:show(0)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_MainMenuSubFrmClose", "__Phone_UI__MapSelectFrmShopBtnCloseOrOpen", function()
		--__showTop()
		--发送获取当前提示的协议
		SendCmdFunc["get_NweVer"]()
		SendCmdFunc["get_NewWebView"]()
		--关闭界面的时候拉一次邮件列表
		--SendCmdFunc["get_prize_list"]()
		
		--gamecenter更新战斗力及战术卡等级
		LuaSetPlayerGamecenter_Hero(LuaCaculatePlayerHeroPower())
		LuaSetPlayerGamecenter_Tactics(LuaCaculatePlayerTacticPower())
		LuaSetPlayerGamecenter_DaFuWeng(LuaCaculatePlayerWealth())
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
			hApi.xlGameCenter_reportScore(LuaGetPlayerGamecenter_Hero(),"td.p.hero")
			hApi.xlGameCenter_reportScore(LuaGetPlayerGamecenter_Tactics(),"td.p.tactics")
			hApi.xlGameCenter_reportScore(LuaGetPlayerGamecenter_DaFuWeng(),"td.p.fortune")
		end
	end)
	
	--监听邮件变化判断，显示/隐藏邮件叹号
	hGlobal.event:listen("LocalEvent_NewWebAction", "__checkmailstate__", function(data_s, mode)
		--print("监听邮件变化判断", data_s, mode, debug.traceback())
		if (mode == 1) then
			__mailstate = 1
		elseif (mode == 0) then
			__mailstate = 0
		end
	end)
	
	--主界面timer2，用于主界面检测绿块
	hApi.addTimerForever("__MainFrame_Restore_UI_PVP_PLIST__", hVar.TIMER_MODE.GAMETIME, 15 * 1000, function()
		local w = hGlobal.WORLD.LastWorldMap
		if (w == nil) and (__oMap ~= nil) then
			--print("检测绿块", hApi.gametime())
			
			--geyachao: 检测ui.plist图的spriteframe是否被释放，如果被释放就恢复
			hApi.Restore_UI_PVP_PLIST()
		end
	end)
end
]=]

--[[
--测试 --test
if hGlobal.UI.MapSelectMainFrm_New then
	hGlobal.UI.MapSelectMainFrm_New:del()
	hGlobal.UI.MapSelectMainFrm_New = nil
end
hGlobal.UI.InitMapSelectMainFrm()
hGlobal.event:event("LocalEvent_PlayerFocusWorld", "chooselevel" , nil, __G_SelectMapWorld)
]]

