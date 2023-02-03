--全局变量
g_MyVip_Param = {enable=0,stateListenerName={"LocalEvent_SetgiftFrmBtnState","SetgiftFrmBtnState"}}
hGlobal.UI.InitMyGiftFrmLogic = function()
	--审核的时候隐藏的按钮
	hGlobal.event:listen("LocalEvent_Setbtn_compensate","Phone_appC",function(state) 
		if (state == 1) then
			--geyachao: 审核先去掉推荐，过了审核就开启
			g_MyVip_Param.enable = 1
			
			--[[
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				g_MyVip_Param.enable = 1
			else
				g_MyVip_Param.enable = 0
			end
			]]
		else
			g_MyVip_Param.enable = 0
		end
		
		--print("LocalEvent_Setbtn_compensate", "state=", state)
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
	end)
	
	hGlobal.event:listen(g_MyVip_Param.stateListenerName[1],g_MyVip_Param.stateListenerName[2],function(statelist)
		g_MyVip_Param.statelist = hApi.ReadParamWithDepth(statelist,nil,{},3)
	end)
end

hGlobal.UI.InitMyGiftFrm = function(mode)
	--local tInitEventName = {"LocalEvent_Phone_ShowMyGift","ShowMyGift"}
	--if mode~="include" then
		--return tInitEventName
	--end
	
	local AwardHideChild = {}		--我的奖励_隐藏子控件
	local giftRemoveT = {}			--我的奖励_清除奖励按钮产生的子窗体
	
	--hVar.SCREEN.w/2 - 440,hVar.SCREEN.h/2 + 240,880,524
	
	hGlobal.UI.Phone_MyGiftFrm =hUI.frame:new({
			x = hVar.SCREEN.w/2 - 440,
			y = hVar.SCREEN.h/2 + 240,
			h = 524,
			w = 880,
			show = 0,
			dragable = 2,
			titlebar = 0,
			bgAlpha = 0,
			bgMode = "tile",
			background = "UI:tip_item",
			border = 1,
			autoactive = 0,
			codeOnTouch = function()
				hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			end,
	})
	
	
	local _frm = hGlobal.UI.Phone_MyGiftFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	local nowChoiceGift = 1
	
	--分界线
	_childUI["apartline_back3"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 440,
		y = -260,
		w = 932,
		h = 8,
	})
	_childUI["apartline_back3"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["apartline_back3"]
	
	_childUI["xiaoqiao_portrait"] = hUI.image:new({
		parent = _parent,
		model = "icon/portrait/hero_xiaoqiao.png",
		animation = "lightSlim",
		x = 750,
		y = -130,
		w = 256,
		h = 256,
	})
	_childUI["xiaoqiao_portrait"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["xiaoqiao_portrait"]

	--选中礼品的框
	_childUI["giftBG"] = hUI.image:new({
		parent = _parent,
		model = "UI:skillup",
		w = 84,
		h = 84,
	})
	_childUI["giftBG"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["giftBG"]

	--对号
	_childUI["giftGetIcon"] = hUI.image:new({
		parent = _parent,
		model = "UI:finish",
		x = 520,
		y = -28,
		scale = 1.4,
	})
	_childUI["giftGetIcon"].handle._n:setVisible(true)
	AwardHideChild[#AwardHideChild+1] = _childUI["giftGetIcon"]
	
	for i = 1,6 do--生成底纹框
		_childUI["giftGetIcon"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:finish",
			x = 148 + (i-1)*100 - 70,
			y = -140,
			z = 3,
			w = 27,
			h = 20,
		})
		_childUI["giftGetIcon"..i].handle._n:setVisible(false)
	end
	
	local choiceGift = nil
	for i = 1, 5, 1 do --生成底纹框
		_childUI["giftBtn"..i]= hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "UI:GIFT",
			x = 120+(i-1)*160,
			y = -332,
			w = 72,
			h = 72,
			code = function(self)
				nowChoiceGift = i
				choiceGift(nowChoiceGift)
			end,
		})
		_childUI["giftBtn"..i]:setstate(0)
		_childUI["giftBtn"..i].handle._n:setVisible(false)
		--_childUI["giftBtn"..i].data.ox,_childUI["giftBtn"..i].data.oy = 300,300
		--_childUI["giftBtn"..i]:update()
		AwardHideChild[#AwardHideChild+1] = _childUI["giftBtn"..i]
		
		--名字
		_childUI["giftName"..i]= hUI.label:new({
			parent = _parent,
			x = 65+(i-1)*160,
			y = -410,
			w = 100,
			h = 100,
			text = hVar.tab_stringGIFT[i][1],
			font = hVar.FONTC,
			size = 26,
		})
		_childUI["giftName"..i].handle._n:setVisible(false)
		AwardHideChild[#AwardHideChild+1] = _childUI["giftName"..i]
		
		--"评价礼包"加个叹号
		if (i == 3) then
			_childUI["giftBtn"..i].childUI["PageTanHao"] = hUI.image:new({
				parent = _childUI["giftBtn"..i].handle._n,
				x = 20,
				y = 30 - 2,
				model = "UI:TaskTanHao",
				w = 36,
				h = 36,
			})
			_childUI["giftBtn"..i].childUI["PageTanHao"].handle._n:setVisible(false) --一开始不显示评价礼包的跳动的叹号
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
			_childUI["giftBtn"..i].childUI["PageTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
		end
	end
	
	_childUI["gift_name_title"]= hUI.label:new({--大面板礼包名字
		parent = _parent,
		x = 330,
		y = -15,
		text = hVar.tab_stringGIFT[1][1],
		font = hVar.FONTC,
		size = 40,
	})
	_childUI["gift_name_title"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["gift_name_title"]
	
	--奖励
	_childUI["gift_name_reward"]= hUI.label:new({--奖励
		parent = _parent,
		x = 15,
		y = -110,
		text = hVar.tab_string["__Reward__"], --language
		--text = "奖励", --language
		font = hVar.FONTC,
		size = 40,
	})
	_childUI["gift_name_reward"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["gift_name_reward"]
	
	--奖励描述
	_childUI["gift_get_info"]= hUI.label:new({
		parent = _parent,
		x = 20,
		y = -193,
		--w = 100,
		--h = 80,
		width = 590,
		text = hVar.tab_stringGIFT[1][2],
		font = hVar.FONTC,
		size = 28,
	})
	_childUI["gift_get_info"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["gift_get_info"]
	
	--按钮
	_childUI["giftGetBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		x = 430,
		y = -460,
		w = 158,
		h = 53,
		label = hVar.tab_stringGIFT[1][3],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			if nowChoiceGift >= 1 and nowChoiceGift <= 3 then
				if (g_cur_net_state == 1) then
					--通关救援青州才能评价
					if (nowChoiceGift == 3) and (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) == 0) then
						hGlobal.UI.MsgBox(hVar.tab_string["recomm_level_jyqz_pingjia"],{
							font = hVar.FONTC,
							ok = function()
								--self:setstate(1)
							end,
						})
					else
						self:setstate(0)
						if nowChoiceGift == 3 then
							_frm:show(0)
							hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
							hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
							hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
							hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
							hGlobal.event:event("LocalEvent_Phone_ShowRecommandInfoFrm")
						else
							Gift_Function["reward_"..nowChoiceGift]()
						end
					end
				else --未联网
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tReceiveGift"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
				end
				
			elseif nowChoiceGift == 4 then
				--通关救援青州才能推荐
				if (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) == 0) then
					hGlobal.UI.MsgBox(hVar.tab_string["recomm_level_jyqz_tuijian"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
				elseif (g_loginDays < 3) then --登入不满3天，不能推荐
					--"登入天数达到3天才能推荐"
					hGlobal.UI.MsgBox(hVar.tab_string["recomm_level_jyqz_dengru"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
				else
					if g_vs_number <= 10 then
						xlShowRecommendDialog()
					elseif g_vs_number >= 11 then
						hGlobal.event:event("LocalEvent_showRecommendFrm", 1) --推荐
					end
				end
			elseif nowChoiceGift == 5 then
				hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
			end
		end,
	})

	--_childUI["giftGetBtn_friend"]= hUI.button:new({
		--parent = _parent,
		--dragbox = _childUI["dragBox"],
		--model = "UI:BTN_ButtonRed",
		--x = 330,
		--y = -460,
		--w = 158,
		--h = 53,
		--label = hVar.tab_string["__TEXT_share"],
		--font = hVar.FONTC,
		--scaleT = 0.9,
		--code = function(self)
			--hGlobal.event:event("LocalEvent_showRecommendFrm",1)
		--end,
	--})
	--_childUI["giftGetBtn"].childUI["label"].handle.s:setScale(0.85)
	--_childUI["giftGetBtn"].childUI["label"].handle.s:setPositionX(9)
	--_childUI["giftGetBtn"].childUI["label"].handle.s:setPositionY(-5)
	_childUI["giftGetBtn"]:setstate(0)
	_childUI["giftGetBtn"].handle._n:setVisible(false)
	AwardHideChild[#AwardHideChild+1] = _childUI["giftGetBtn"]
	
	choiceGift = function(index)
		_childUI["giftGetIcon"].handle._n:setVisible(false)
		for i = 1,6 do
			_childUI["giftGetIcon"..i].handle._n:setVisible(false)
		end
		
		for i = 1,#giftRemoveT do
			hApi.safeRemoveT(_childUI,giftRemoveT[i])
		end
		giftRemoveT = {}
		
		if (index >= 1) and (index <= 5) then
			--评价开关打开，没评价过，已通关"救援青州"
			local enableRateOpen = ((g_MyVip_Param.enable == 1) and (LuaGetPlayerGiftstate(3) == 0) and (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) > 0))
			--print("评价开关打开，没评价过，已通关救援青州")
			--print(g_MyVip_Param.enable, LuaGetPlayerGiftstate(3), LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL))
			_childUI["giftBtn3"].childUI["PageTanHao"].handle._n:setVisible(enableRateOpen)
			
			if index >= 1 and index <= 3 then
				if LuaGetPlayerGiftstate(index) == 1 then
					_childUI["giftGetIcon"].handle._n:setVisible(true)
				end
			end
			
			if (index == 5) then
				for i = 5,10 do
					if LuaGetPlayerGiftstate(i) == 1 then
						local ii = i - 4
						_childUI["giftGetIcon"..ii].handle._n:setVisible(true)
					end
				end
			end
			
			if index == 2 then
				if LuaGetPlayerGiftstate(index) == 0 then
					_childUI["giftGetBtn"]:setstate(1)
				else
					_childUI["giftGetBtn"]:setstate(0)
				end
			elseif index == 1 then
				if LuaGetPlayerScore() >= g_DailyRewardScore then
					if LuaGetPlayerGiftstate(index) == 0 then
						_childUI["giftGetBtn"]:setstate(1)
					else
						_childUI["giftGetBtn"]:setstate(0)
					end
				else
					_childUI["giftGetBtn"]:setstate(0)
				end
			elseif index == 3 then --评价
				if LuaGetPlayerGiftstate(index) == 0 then
					if (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) <= 0) then
						_childUI["giftGetBtn"]:setstate(0)
					else
						_childUI["giftGetBtn"]:setstate(1)
					end
				else
					_childUI["giftGetBtn"]:setstate(0)
				end
			elseif index == 4 then --推荐
				--print("推荐", LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL), g_loginDays)
				if (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) <= 0) then
					_childUI["giftGetBtn"]:setstate(0)
				elseif (g_loginDays < 3) then --登入不满3天，不能推荐
					_childUI["giftGetBtn"]:setstate(0)
				else
					_childUI["giftGetBtn"]:setstate(1)
				end
			else
				_childUI["giftGetBtn"]:setstate(1)
			end
			
			_childUI["gift_name_title"]:setText(hVar.tab_stringGIFT[index][1])
			
			if ((g_MyVip_Param.enable == 1)) or (g_vs_number < g_next_vs_number) then
				--显示推荐
				_childUI["giftBG"].handle._n:setPosition((index-1)*160+121,-325)
				--不显示推荐
				--[[
				if index > 3 then
					_childUI["giftBG"].handle._n:setPosition((index-2)*210+121,-325)
				else
					_childUI["giftBG"].handle._n:setPosition((index-1)*210+121,-325)
				end
				]]
			else
				if g_vs_number > 7 then
					if index == 1 then
						_childUI["giftBG"].handle._n:setPosition((index-1)*210+121,-325)
					elseif index == 2 then
						_childUI["giftBG"].handle._n:setPosition((index-0.5)*210+121,-325)
					elseif index == 5 then
						_childUI["giftBG"].handle._n:setPosition((index-2)*210+121,-325)
					end
				else
					if index > 2 then
						_childUI["giftBG"].handle._n:setPosition((index-2)*210+121,-325)
					else
						_childUI["giftBG"].handle._n:setPosition((index-1)*210+121,-325)
					end
				end
				
			end
			
			_childUI["giftGetBtn"]:setText(hVar.tab_stringGIFT[index][3])
			
			--如果 index == 1 每日领取游戏币， 那么进行默认值判定 
			if index == 1 then
				--是默认的 那么就直接取值
				if g_DailyRewardScore == 500 then
					_childUI["gift_get_info"]:setText(hVar.tab_stringGIFT[index][2])
				else
					_childUI["gift_get_info"]:setText(hVar.tab_string["__TEXT_Use"]..tostring(g_DailyRewardScore)..hVar.tab_string["__TEXT_ChangeGameCoin"])
				end
			else
				_childUI["gift_get_info"]:setText(hVar.tab_stringGIFT[index][2])
			end
			
			local gift_coin = tonumber(hVar.tab_stringGIFT[index][4]) or hVar.tab_stringGIFT[index][4]
			local gift_score = tonumber(hVar.tab_stringGIFT[index][5]) or 0
			local gift_item_count = #hVar.tab_stringGIFT[index] - 5
			local __x = 210
			local __y = -130
			if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" then
				if gift_score <= 0 then
					__x = 380
				end
				_childUI["gift_coin_icon"] = hUI.image:new({
					parent = _parent,
					model = "misc/game_coins.png",
					scale = 1.3,
					x = __x,
					y = __y,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_coin_icon"
				
				if g_DailyRewardCoin and index == 1 then
					gift_coin = g_DailyRewardCoin
				end
				
				_childUI["gift_coin_num"]= hUI.label:new({
					parent = _parent,
					x = __x + 40,
					y = __y + 10,
					--w = 100,
					--h = 40,
					text = gift_coin,
					font = "numWhite",
					size = 30,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_coin_num"
			end
			
			if gift_score > 0 then
				if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" then
					__x = 485
				end
				_childUI["gift_score_icon"] = hUI.image:new({
					parent = _parent,
					model = "UI:score",
					x = __x,
					y = __y,
					w = 40,
					h = 40,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_score_icon"
				_childUI["gift_score_num"]= hUI.label:new({
					parent = _parent,
					x = __x + 40,
					y = __y + 10,
					w = 100,
					h = 40,
					text = gift_score,
					font = "numWhite",
					size = 30,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_score_num"
			end
			
			_childUI["gift_name_reward"].handle._n:setVisible(true)
			
			--首充奖励
			if gift_item_count > 0 then
				_childUI["gift_name_reward"].handle._n:setVisible(false) --隐藏奖励文字
				
					__x = 130
					__y = -120
				if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" or gift_score > 0 then
					__y = __y - 60
				end
				for i = 1,gift_item_count do
					local nId = g_TopupGiftItemList[i][1]
					local nNum = g_TopupGiftItemList[i][2]
					local sType = g_TopupGiftItemList[i][4] or "i"
					
					local model = ""
					if sType == "i" then --道具
						model = hVar.tab_item[nId]["icon"]
						
						local tabI = hVar.tab_item[nId]
						if tabI then
							local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
							local tmpModel = hVar.ITEMLEVEL[1].ITEMMODEL
							if tabM then
								tmpModel = tabM.ITEMMODEL
							end
							
							--底板
							local tmpModelBG = "UI:item1" --道具底图
							if (hVar.tab_item[nId].isArtifact == 1) then --神器边框换个图
								tmpModelBG = "ICON:Back_red3"
							end
							_childUI["gift_item_iconBg"..i]= hUI.image:new({
								parent = _parent,
								model = tmpModelBG,
								x = __x + (i-1)*100 - 70,
								y = __y,
								w = 60,
								h = 60,
							})
							giftRemoveT[#giftRemoveT+1] = "gift_item_iconBg"..i
							
							if (hVar.tab_item[nId].isArtifact ~= 1) then --神器不需要额外标识品质颜色
								_childUI["gift_item_iconTypeBg"..i]= hUI.image:new({
									parent = _parent,
									model = tmpModel,
									x = __x + (i-1)*100 - 70,
									y = __y,
									w = 60,
									h = 60,
								})
								giftRemoveT[#giftRemoveT+1] = "gift_item_iconTypeBg"..i
							end
						end
						
					elseif sType == "H" then --英雄
						model = hVar.tab_unit[nId]["icon"]
						
						--底板
						_childUI["gift_item_iconBg"..i]= hUI.image:new({
							parent = _parent,
							model = "UI_frm:slot",
							animation = "light",
							x = __x + (i-1)*100 - 70,
							y = __y,
							w = 60,
							h = 60,
						})
						giftRemoveT[#giftRemoveT+1] = "gift_item_iconBg"..i
						
					end
					
					--奖励道具按钮（只响应事件，不显示）
					_childUI["gift_item_iconBtn"..i] = hUI.button:new({
						parent = _parent,
						dragbox = _childUI["dragBox"],
						model = "misc/mask.png",
						x = __x + (i-1)*100 - 70,
						y = __y,
						w = 72,
						h = 72,
						scaleT = 0.95,
						smartWH = 1,
						codeOnTouch = function(self)
							if sType == "i" then
								hGlobal.event:event("LocalEvent_ShowItemTipFram",{{nId,1,{3,0,0,0}}},nil,1)
							elseif sType == "H" then
								hGlobal.event:event("LocalEvent_HeroCardInfo", nId)
							end
						end,
					})
					_childUI["gift_item_iconBtn"..i].handle.s:setOpacity(0) --只响应事件，不显示
					giftRemoveT[#giftRemoveT+1] = "gift_item_iconBtn"..i
					_childUI["gift_item_iconBtn"..i].childUI["icon"] = hUI.image:new({ --奖励道具图标
						parent = _childUI["gift_item_iconBtn"..i].handle._n,
						x = 0,
						y = 0,
						model = model,
						w = 52,
						h = 52,
					})
					if nNum >= 2 then
						_childUI["gift_item_count"..i]= hUI.label:new({
							parent = _parent,
							x = __x + (i-1)*100 + 25 - 70,
							y = __y - 20,
							w = 100,
							h = 40,
							text = "X"..nNum,
							font = hVar.FONTC,
							size = 25,
						})
						giftRemoveT[#giftRemoveT+1] = "gift_item_count"..i
					end
					
					--档位
					_childUI["gift_item_num"..i]= hUI.label:new({
						parent = _parent,
						x = __x + (i-1)*100 - 25 - 70 - 5,
						y = __y - 40,
						w = 100,
						h = 40,
						text = hVar.tab_stringGIFT[index][5 + i],
						font = hVar.FONTC,
						size = 21,
					})
					giftRemoveT[#giftRemoveT+1] = "gift_item_num"..i
				end
			end
		end
		
		--if nowChoiceGift == 4 then
			--_childUI["giftGetBtn"]:setXY(600,-460)
			--_childUI["giftGetBtn_friend"]:setstate(1)
		--else
			--_childUI["giftGetBtn"]:setXY(430,-460)
			--_childUI["giftGetBtn_friend"]:setstate(-1)
		--end
	end
	
	--是否显示玩家奖励
	local function Phone_PlayerAwardFrm(Judge)
		for i = 1,#AwardHideChild do
			AwardHideChild[i].handle._n:setVisible(Judge)
		end
		
		if Judge == false then
			for j = 1,5 do
				_childUI["giftBtn"..j]:setstate(0)
			end
			_childUI["giftGetBtn"]:setstate(0)
		else
			for j = 1,5 do
				_childUI["giftBtn"..j]:setstate(1)
			end
			_childUI["giftGetBtn"]:setstate(1)
		end
	end

	--退出按钮
	_childUI["btnClose1"] = hUI.button:new({
		parent = _parent,
		model = "BTN:PANEL_CLOSE",
		dragbox = _childUI["dragBox"],
		scaleT = 0.9,
		x = 870,
		y = -12,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		code = function()
			_frm:show(0)
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		end,
	})
	
	local function HideButton()
		--print("HideButton", g_MyVip_Param.enable, g_vs_number, g_next_vs_number)
		if ((g_MyVip_Param.enable == 1)) or (g_vs_number < g_next_vs_number) then
			--显示推荐
			for i = 1, 5, 1 do
				_childUI["giftBtn"..i]:setstate(1)
				_childUI["giftName"..i].handle._n:setVisible(true)
				_childUI["giftBtn"..i]:setXY(120+(i-1)*160,-332)
				_childUI["giftName"..i].handle._n:setPosition(65+(i-1)*160,-370)
			end
			
			--充值的特殊标记控制是否显示
			if (hVar.SHOW_PURCHASE_HOST == 1) and (hVar.SHOW_PURCHASE_CLIENT == 1) then
				_childUI["giftBtn5"]:setstate(1)
				_childUI["giftName5"].handle._n:setVisible(true)
			else
				_childUI["giftBtn5"]:setstate(-1)
				_childUI["giftName5"].handle._n:setVisible(false)
			end
			
			--[[
			--不显示推荐
			local HideIndex = 1
			for i = 1,5 do
				if i ~= 4 then
					_childUI["giftBtn"..i]:setXY(120+(HideIndex-1)*210,-332)
					_childUI["giftName"..i].handle._n:setPosition(65+(HideIndex-1)*210,-370)
					HideIndex = HideIndex + 1
				end
				
			end
			
			_childUI["giftBtn4"]:setstate(-1)
			_childUI["giftName4"].handle._n:setVisible(false)
			]]
		else
			if g_vs_number > 7 then
				_childUI["giftBtn3"]:setstate(-1)
				_childUI["giftName3"].handle._n:setVisible(false)
				_childUI["giftBtn4"]:setstate(-1)
				_childUI["giftName4"].handle._n:setVisible(false)
				
				_childUI["giftBtn"..1]:setXY(120+(1-1)*210,-332)
				_childUI["giftName"..1].handle._n:setPosition(65+(1-1)*210,-370)
				
				_childUI["giftBtn"..2]:setXY(120+(2.5-1)*210,-332)
				_childUI["giftName"..2].handle._n:setPosition(65+(2.5-1)*210,-370)
				
				_childUI["giftBtn"..5]:setXY(120+(4-1)*210,-332)
				_childUI["giftName"..5].handle._n:setPosition(65+(4-1)*210,-370)
				
				--充值的特殊标记控制是否显示
				if (hVar.SHOW_PURCHASE_HOST == 1) and (hVar.SHOW_PURCHASE_CLIENT == 1) then
					_childUI["giftBtn5"]:setstate(1)
					_childUI["giftName5"].handle._n:setVisible(true)
				else
					_childUI["giftBtn5"]:setstate(-1)
					_childUI["giftName5"].handle._n:setVisible(false)
				end
			else
				local HideIndex = 1
				for i = 1,5 do
					if i ~= 3 then
						_childUI["giftBtn"..i]:setXY(120+(HideIndex-1)*210,-332)
						_childUI["giftName"..i].handle._n:setPosition(65+(HideIndex-1)*210,-370)
						HideIndex = HideIndex + 1
					end
					
				end
				_childUI["giftBtn3"]:setstate(-1)
				_childUI["giftName3"].handle._n:setVisible(false)
			end
		end
	end
	
	--显示"奖励"界面
	hGlobal.event:listen("LocalEvent_Phone_ShowMyGift", "ShowMyGift", function()
		--print("显示奖励界面")
		nowChoiceGift = 1
		SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")
		Phone_PlayerAwardFrm(true)
		choiceGift(1)
		HideButton()
		
		_frm:show(1)
		_frm:active()
		
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
	end)
	
	hGlobal.event:listen("LocalEvent_choiceGriffinGiftFrm","__UI__choiceGriffinGiftFrm",function(index)
		nowChoiceGift = index
		choiceGift(index)
	end)
	--重载logic里面的stateListener
	hGlobal.event:listen(g_MyVip_Param.stateListenerName[1],g_MyVip_Param.stateListenerName[2],function(statelist)
		if nowChoiceGift >= 1 and nowChoiceGift <= 3 then
			if statelist[nowChoiceGift] == 1 then
				_childUI["giftGetIcon"].handle._n:setVisible(true)
			end
		end
		if nowChoiceGift == 5 then 
			for i = 5,10 do
				if statelist[i] == 1 then
					local ii = i - 4
					_childUI["giftGetIcon"..ii].handle._n:setVisible(true)
				end
			end
		end
	end)
	if type(g_MyVip_Param.statelist)== "table"then
		local tStateList = g_MyVip_Param.statelist
		g_MyVip_Param.statelist = nil
		hGlobal.event:getfunc(g_MyVip_Param.stateListenerName[1],g_MyVip_Param.stateListenerName[2])(tStateList)
	end
end