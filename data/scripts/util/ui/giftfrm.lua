---------------------
--奖励领取
--------------------
hGlobal.UI.InitGiftFrm = function()
	hGlobal.UI.GiftFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 324,
		y = hVar.SCREEN.h/2 + 183,
		dragable = 2,
		w = 648,
		h = 366,
		show = 0,
		autoactive = 0,
		background = "UI:tip_item",
		codeOnTouch = function()
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
		end,
	})
	
	local inAppC = -1 --审核时的ui布局
	
	local _frm = hGlobal.UI.GiftFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	_frm:showBorder(1)
	_frm:showBorder(0)
	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 640,
		y = -8,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showGriffinGiftFrm",0)
		end,
	})
	
	_childUI["btnClose"]:setstate(-1)
	_frm.handle._n:reorderChild(_frm.handle._bn,-10)
	_frm.handle._bn:setVisible(false)
	----------------------------------------------------礼包相关------------------------------------------------------
	local nowChoiceGift = 1
	local giftRemoveT = {}
	local choiceGift = nil
	
	_childUI["giftBG"] = hUI.image:new({
		parent = _parent,
		model = "UI:skillup",
		x = -70,
		y = -185,
		--z = -1,
		w = 80,
		h = 80,
	})
	--_childUI["giftBG"].handle._n:setVisible(false)

	_childUI["giftGetIcon"] = hUI.image:new({
		parent = _parent,
		model = "UI:finish",
		x = 370,
		y = -25,
		--z = -1,
		--w = 80,
		--h = 80,
	})
	_childUI["giftGetIcon"].handle._n:setVisible(false)
	
	for i = 1,6 do--生成底纹框
		_childUI["giftGetIcon"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:finish",
			x = 120 + (i-1)*80 - 65,
			y = -120,
			--z = -1,
			w = 27,
			h = 20,
		})
		_childUI["giftGetIcon"..i].handle._n:setVisible(false)
	end
	for i = 1, 5, 1 do
		_childUI["giftBtn"..i]= hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "UI:GIFT",
			x = -70+i*130,
			y = -250,
			code = function(self)
				nowChoiceGift = i
				choiceGift(nowChoiceGift)
			end,
		})
		_childUI["giftBtn"..i]:setstate(-1)
		
		_childUI["giftName"..i]= hUI.label:new({
			parent = _parent,
			x = -110+i*130,
			y = -285,
			w = 100,
			h = 100,
			text = hVar.tab_stringGIFT[i][1],
			font = hVar.FONTC,
			size = 20,
		})
		_childUI["giftName"..i].handle._n:setVisible(false)
	end
	
	_childUI["gift_name_title"]= hUI.label:new({--大面板礼包名字
		parent = _parent,
		x = 220,
		y = -15,
		w = 100,
		h = 40,
		text = hVar.tab_stringGIFT[1][1],
		font = hVar.FONTC,
		size = 30,
	})
	_childUI["gift_name_title"].handle._n:setVisible(false)
	--_childUI["gift_name_reward"]= hUI.label:new({--奖励
		--parent = _parent,
		--x = 20,
		--y = -75,
		--w = 100,
		--h = 40,
		--text = hVar.tab_string["__Reward__"],
		--font = hVar.FONTC,
		--size = 30,
	--})
	--_childUI["gift_name_reward"].handle._n:setVisible(false)
	_childUI["gift_get_info"]= hUI.label:new({
		parent = _parent,
		x = 20,
		y = -150,
		w = 100,
		h = 80,
		width = 420,
		text = hVar.tab_stringGIFT[1][2],
		font = hVar.FONTC,
		size = 24,
	})
	_childUI["gift_get_info"].handle._n:setVisible(false)
	
	--_childUI["200"]= hUI.label:new({
		--parent = _parent,
		--x = 20,
		--y = -150,
		--w = 100,
		--h = 80,
		--width = 420,
		--text = "",
		--RGB = {255,0,0},
		--font = hVar.FONTC,
		--size = 24,
	--})
	--_childUI["200"].handle._n:setVisible(false)
	
	_childUI["giftGetBtn"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		x = 320,
		y = -345,
		w = 180,
		h = 46,
		label = hVar.tab_stringGIFT[1][3],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			if nowChoiceGift >= 1 and nowChoiceGift <= 3 then
				if g_cur_net_state == 1 then
					self:setstate(0)
					if nowChoiceGift == 3 then
						hGlobal.event:event("LocalEvent_Phone_ShowRecommandInfoFrm")
					else
						Gift_Function["reward_"..nowChoiceGift]()
					end
				else
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tReceiveGift"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
				end
			elseif nowChoiceGift == 4 then
				xlShowRecommendDialog()
			elseif nowChoiceGift == 5 then
				hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
			end
		end,
	})
	_childUI["giftGetBtn"]:setstate(-1)
	_childUI["diaochan_portrait"] = hUI.image:new({
		parent = _parent,
		model = "UI:XIAO_QIAO_GIFT",
		animation = "lightSlim",
		x = 552,
		y = -102,
		w = 190,
		h = 200,
		z = -1,
	})
	_childUI["diaochan_portrait"].handle._n:setVisible(false)
	
	--分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 325,
		y = -201,
		w = 680,
		h = 8,
	})
	_childUI["apartline_back"].handle._n:setVisible(false)
	
	choiceGift = function(index)
		--print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; choiceGift(), index=", index, "inAppC=", inAppC)
		
		--_childUI["200"].handle._n:setVisible(false)
		_childUI["giftGetIcon"].handle._n:setVisible(false)
		for i = 1,6 do
			_childUI["giftGetIcon"..i].handle._n:setVisible(false)
		end
		
		for i = 1,#giftRemoveT do
			hApi.safeRemoveT(_childUI,giftRemoveT[i])
		end
		giftRemoveT = {}
		
		if index >= 1 and index <= 5 then
			if index >= 1 and index <= 3 then
				if LuaGetPlayerGiftstate(index) == 1 then
					_childUI["giftGetIcon"].handle._n:setVisible(true)
				end
			end
			
			if index == 5 then
				for i = 5,10 do
					if LuaGetPlayerGiftstate(i) == 1 then
						local ii = i - 4
						_childUI["giftGetIcon"..ii].handle._n:setVisible(true)
					end
				end
			end
			
			if index >=2 and index <= 3 then
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
			else
				_childUI["giftGetBtn"]:setstate(1)
			end
			_childUI["gift_name_title"]:setText(hVar.tab_stringGIFT[index][1])
			--_childUI["giftBG"..index].handle._n:setVisible(true)
			if inAppC == 1 or g_vs_number < g_next_vs_number then
				_childUI["giftBG"].handle._n:setPosition((index-1)*130+60,-245)
			elseif inAppC == -1 then
				if g_vs_number > 7 then
					if index == 1 or index == 5 then
						_childUI["giftBG"].handle._n:setPosition((index-1)*130+60,-245)
					elseif index == 2 then
						_childUI["giftBG"].handle._n:setPosition(330,-245)
					end
				else
					if index == 1 or index == 5 then
						_childUI["giftBG"].handle._n:setPosition((index-1)*130+60,-245)
					elseif index == 2 then
						_childUI["giftBG"].handle._n:setPosition(240,-245)
					elseif index == 4 then
						_childUI["giftBG"].handle._n:setPosition(420,-245)
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
			--if index == 1 and LuaGetPlayerScore() < g_DailyRewardScore then
				--_childUI["200"]:setText("       "..tostring(g_DailyRewardScore))
				--_childUI["200"].handle._n:setVisible(true)
			--end
			local gift_coin = tonumber(hVar.tab_stringGIFT[index][4]) or hVar.tab_stringGIFT[index][4]
			local gift_score = tonumber(hVar.tab_stringGIFT[index][5])
			local gift_item_count = #hVar.tab_stringGIFT[index] - 5
			local __x = 150
			local __y = -90
			if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" then
				if gift_score <= 0 then
					__x = 250
				end
				_childUI["gift_coin_icon"] = hUI.image:new({
					parent = _parent,
					model = "misc/game_coins.png",
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
					w = 100,
					h = 40,
					text = gift_coin,
					font = "numWhite",
					size = 24,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_coin_num"
			end
			
			if gift_score > 0 then
				if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" then
					__x = 330
				end
				_childUI["gift_score_icon"] = hUI.image:new({
					parent = _parent,
					model = "UI:score",
					x = __x,
					y = __y,
					w = 32,
					h = 32,
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
					size = 24,
				})
				giftRemoveT[#giftRemoveT+1] = "gift_score_num"
			end
			
			if gift_item_count > 0 then
					__x = 110
					__y = -85
				if (type(gift_coin) == "number" and gift_coin > 0) or type(gift_coin) == "string" or gift_score > 0 then
					__y = __y - 60
				end
				if g_vs_number > 5 then
					gift_item_count = 6
				else
					gift_item_count = 5
				end
				for i = 1,gift_item_count do
					
					local nId = g_TopupGiftItemList[i][1]
					local nNum = g_TopupGiftItemList[i][2]
					local sType = g_TopupGiftItemList[i][4] or "i"
					
					_childUI["gift_item_iconBg"..i]= hUI.image:new({
						parent = _parent,
						model = "UI_frm:slot",
						animation = "light",
						x = __x + (i-1)*100,
						y = __y,
						w = 56,
						h = 56,
					})
					giftRemoveT[#giftRemoveT+1] = "gift_item_iconBg"..i
					
					local model = ""
					if sType == "i" then
						model = hVar.tab_item[nId]["icon"]
						
						local tabI = hVar.tab_item[nId]
						
						if tabI then
							local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
							local tmpModel = hVar.ITEMLEVEL[1].BACKMODEL
							if tabM then
								tmpModel = tabM.BACKMODEL
							end
							_childUI["gift_item_iconTypeBg"..i]= hUI.image:new({
								parent = _parent,
								model = tmpModel,
								animation = "light",
								x = __x + (i-1)*100,
								y = __y,
								w = 51,
								h = 51,
							})
							giftRemoveT[#giftRemoveT+1] = "gift_item_iconTypeBg"..i
						end
						
					elseif sType == "H" then
						model = hVar.tab_unit[nId]["icon"]
					end
					_childUI["gift_item_iconBtn"..i]= hUI.button:new({
						parent = _parent,
						dragbox = _childUI["dragBox"],
						model = hVar.tab_item[nId]["icon"],
						x = __x + (i-1)*80 - 65,
						y = __y,
						w = 52,
						h = 52,
						smartWH = 1,
						codeOnTouch = function(self)
							if sType == "i" then
								hGlobal.event:event("LocalEvent_ShowItemTipFram",{{nId,1,{3,0,0,0}}},nil,1)
							elseif sType == "H" then
								hGlobal.event:event("LocalEvent_HeroCardInfo", nId)
							end
						end,
					})
					giftRemoveT[#giftRemoveT+1] = "gift_item_iconBtn"..i
					if nNum >= 2 then
						_childUI["gift_item_count"..i]= hUI.label:new({
							parent = _parent,
							x = __x + (i-1)*80 + 25 - 65,
							y = __y - 20,
							w = 100,
							h = 40,
							text = "X"..nNum,
							font = hVar.FONTC,
							size = 16,
						})
						giftRemoveT[#giftRemoveT+1] = "gift_item_count"..i
					end
					_childUI["gift_item_num"..i]= hUI.label:new({
						parent = _parent,
						x = __x + (i-1)*80 - 25 - 65,
						y = __y - 40,
						w = 100,
						h = 40,
						text = hVar.tab_stringGIFT[index][5 + i],
						font = hVar.FONTC,
						size = 18,
					})
					giftRemoveT[#giftRemoveT+1] = "gift_item_num"..i
				end
			end
		end
	end
	
	local showGiftFrame = function(bShow)
		--print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; showGiftFrame(), bShow=", bShow, "inAppC=", inAppC)
		if bShow == 1 then
			choiceGift(1)
			_childUI["gift_name_title"].handle._n:setVisible(true)
			--_childUI["gift_name_reward"].handle._n:setVisible(true)
			_childUI["gift_get_info"].handle._n:setVisible(true)
			nowChoiceGift = 1
			for i = 1,5 do
				_childUI["giftName"..i].handle._n:setVisible(true)
				_childUI["giftBtn"..i]:setstate(1)
			end
			_childUI["diaochan_portrait"].handle._n:setVisible(true)
			_childUI["giftGetBtn"]:setstate(0)
			_childUI["apartline_back"].handle._n:setVisible(true)
			
			--过审核暂时隐藏
			if inAppC == -1 and  g_vs_number > g_last_vs_number then
				if g_vs_number > 7 then
					_childUI["giftBtn"..2]:setXY(330,-250)
					_childUI["giftName"..2].handle._n:setPosition(290,-285)
					
					_childUI["giftBtn"..4]:setstate(-1)
					_childUI["giftName"..4].handle._n:setVisible(false)
					_childUI["giftBtn"..3]:setstate(-1)
					_childUI["giftName"..3].handle._n:setVisible(false)
				else
					_childUI["giftBtn"..2]:setXY(240,-250)
					_childUI["giftBtn"..4]:setXY(420,-250)
					_childUI["giftName"..2].handle._n:setPosition(200,-285)
					_childUI["giftName"..4].handle._n:setPosition(380,-285)
					
					_childUI["giftBtn"..3]:setstate(-1)
					_childUI["giftName"..3].handle._n:setVisible(false)
				end
			elseif inAppC == 1 then
				_childUI["giftBtn"..2]:setXY(190,-250)
				_childUI["giftBtn"..4]:setXY(450,-250)
				_childUI["giftName"..2].handle._n:setPosition(150,-285)
				_childUI["giftName"..4].handle._n:setPosition(410,-285)
				
				_childUI["giftBtn"..3]:setstate(1)
				_childUI["giftName"..3].handle._n:setVisible(true)
			end
		elseif bShow == 0 then
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			choiceGift(0)
			--_childUI["gift_name_title"].handle._n:setVisible(false)
			--_childUI["gift_name_reward"].handle._n:setVisible(false)
			--_childUI["gift_get_info"].handle._n:setVisible(false)
			--for i = 1,5 do
				--_childUI["giftName"..i].handle._n:setVisible(false)
				--_childUI["giftBtn"..i]:setstate(-1)
			--end
			--_childUI["diaochan_portrait"].handle._n:setVisible(false)
			--_childUI["giftGetBtn"]:setstate(-1)
			--_childUI["apartline_back"].handle._n:setVisible(false)
		end
	end
	
	hGlobal.event:listen("LocalEvent_showGriffinGiftFrm","__UI__showGriffinGiftFrm",function(bShow,x,y,nStyle)
		showGiftFrame(bShow)
		_frm:show(bShow)
		if bShow == 1 then
			SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")
			if x and y then
				_frm:setXY(x,y)
			end
			if nStyle==2 then
				_frm:active(2)
				_frm.childUI["btnClose"]:setstate(1)
				_frm:showBorder(1)
				_frm.handle._bn:setVisible(true)
			else
				_frm:active(1)
				_frm.childUI["btnClose"]:setstate(-1)
				_frm:showBorder(0)
				_frm.handle._bn:setVisible(false)
			end
			_childUI["dragBox"]:sortbutton()
		end
	end)
	
	--获得首充奖励时的弹出面板
	local tipFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 210,
		y = hVar.SCREEN.h/2 + 135,
		dragable = 2,
		w = 420,
		h = 270,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = 1,
		autoactive = 0,
	})
	
	--提示文字title
	tipFrm.childUI["tipLab"] =  hUI.label:new({
		parent = tipFrm.handle._n,
		x = tipFrm.data.w/2,
		y = -60,
		text = "",
		size = 26,
		width = tipFrm.data.w-64,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})

	--确定按钮
	local removeGiftUI = {}
	tipFrm.childUI["confirmBtn"] =  hUI.button:new({
		parent = tipFrm.handle._n,
		dragbox = tipFrm.childUI["dragBox"],
		model = "UI:ConfimBtn1",
		x = tipFrm.data.w/2,
		y = -tipFrm.data.h + 30,
		scale = 0.8,
		scaleT = 0.9,
		code = function()
			tipFrm:show(0)
			if LuaCheckGiftBag() == 1 then
				if hGlobal.UI.SystemMenuBar then
					hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
				end
			end
			for i = 1,#removeGiftUI do
				hApi.safeRemoveT(tipFrm.childUI,removeGiftUI[i])
			end
			removeGiftUI = {}
		end,
	})
	
	hGlobal.event:listen("LocalEvent_GetTopupGiftItem","_GetGiftItem",function(itemIDList,itemNumList,mode,paramA,score,oHero,holeNList,x,y,prizeid)
		for i = 1,#removeGiftUI do
			hApi.safeRemoveT(tipFrm.childUI,removeGiftUI[i])
		end
		removeGiftUI = {}
		tipFrm:setXY(x or hVar.SCREEN.w/2 - 210,y or hVar.SCREEN.h/2 + 135)
		--标题的修改 1 是官方推送奖励 nil 是默认的 充值奖励
		if mode == 1 then 
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string["__TEXT_GetItem2"])
		elseif mode == 2 then
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string["__TEXT_GetItem3"])
		elseif mode == 3 then
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string["__TEXT_GetItem4"])
		elseif mode == 4 and paramA then
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string[hVar.SHARTEXT[paramA]])
		elseif mode == 5 then
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string[hVar.RECOMMENDTEXT[paramA]])
		else	
			tipFrm.childUI["tipLab"]:setText(hVar.tab_string["__TEXT_GetItem1"])
		end
		
		local logid_uID = 0
		for i = 1,#itemIDList do
			local itemID = itemIDList[i]
			local itemNum = itemNumList[i] or 1
			local holeN = 0
			
			if type(holeNList) == "table" then
				holeN = holeNList[i]
			end
			
			local itemX,itemY = math.floor((tipFrm.data.w/2+60) -#itemIDList *125/2 + (i-1)*125),-150
			
			local itemLv = hVar.tab_item[itemID].itemLv or 1
			local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
			if type(hVar.tab_item[itemID].elite) == "number" then
				RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[itemID].elite].NAMERGB
			end
			
			local isEqu = 0
			if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
				isEqu = 1
			end
			
			local bgmodel = hVar.ITEMLEVEL[itemLv].BACKMODEL
			
			tipFrm.childUI["lv_bg_"..i] = hUI.image:new({
				parent = tipFrm.handle._n,
				model = bgmodel,
				w = 56,
				h = 56,
				x = itemX,
				y = itemY,
			})
			removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
			
			tipFrm.childUI["itemImage_"..i] =hUI.image:new({
				parent = tipFrm.handle._n,
				model = hVar.tab_item[itemID].icon,
				x = itemX,
				y = itemY,
				w = 52,
			})
			removeGiftUI[#removeGiftUI+1] = "itemImage_"..i
			
			if itemNum > 1 then
				--道具个数
				tipFrm.childUI["itemNum_"..i] =  hUI.label:new({
					parent = tipFrm.handle._n,
					x = itemX+24,
					y = itemY-4,
					text = itemNum,
					size = 18,
					width = tipFrm.data.w-64,
					align = "RT",
					border = 1,
					z = 100
				})
				removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
			end
			
			--itemName
			tipFrm.childUI["itemName_"..i] =  hUI.label:new({
				parent = tipFrm.handle._n,
				x = itemX,
				y = itemY - 40,
				text = hVar.tab_stringI[itemID][1],
				size = 24,
				width = tipFrm.data.w-64,
				font = hVar.FONTC,
				align = "MC",
				border = 1,
				RGB = RGB,
			})
			removeGiftUI[#removeGiftUI+1] = "itemName_"..i
			
			--当mode == 2 时 是 许愿
			if mode == 2 then
				--local focus_unit = hGlobal.LocalPlayer:getfocusunit()
				--if focus_unit then
				--	local h = focus_unit:gethero()
				--	if h then
				--		h:additembyID(itemID,-1,hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath),nil,nil,{hVar.ITEM_FROMWHAT_TYPE.WISHING,paramA[1],paramA[2]})
				--	end
				--elseif oHero then
				--	oHero:additembyID(itemID,-1,hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath),nil,nil,{hVar.ITEM_FROMWHAT_TYPE.WISHING,paramA[1],paramA[2]})
				--end
			elseif mode == 3 then
			elseif mode == 4 then
			else
				--if isEqu == 1 then
				--	local rewardEx = -1
				--	if type(holeN) == "number" then
				--		--如果孔数为0 则随机产生孔数字
				--		if holeN == 0 then
				--			local nSlotNum = hApi.CalculateItemRewardEx(itemID)
				--			rewardEx = hApi.NumTable(nSlotNum+1)
				--			rewardEx[1] = nSlotNum
				--		--否则就是指定孔数
				--		elseif holeN > 1 then
				--			rewardEx = hApi.NumTable(holeN+1)
				--			rewardEx[1] = holeN
				--		end
				--	elseif holeN == nil then
				--		local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
				--		local MaxSlot = itemRulu[#itemRulu][2]
				--		rewardEx = hApi.NumTable(MaxSlot+1)
				--		rewardEx[1] = MaxSlot
				--	end
				--	
				--	local rs = 0
				--	rs,logid_uID = LuaAddItemToPlayerBag(itemID,rewardEx)
				--	if rs == 1 then
				--		LuaAddGetGiftCount(itemID)
				--	end
				--else
				--	--如果是锻造材料
				--	if hVar.tab_item[itemID].type == hVar.ITEM_TYPE.PLAYERITEM then
				--		local matVal = hVar.tab_item[itemID].matVal
				--		--材料道具 直接增加玩家材料
				--		if matVal then
				--			LuaSetPlayerMaterial(matVal[1],LuaGetPlayerMaterial(matVal[1])+matVal[2]*itemNum)
				--		end
				--	else
				--		local rs = 0
				--		rs,logid_uID = LuaAddItemToPlayerBag(itemID,{0})
				--		if rs == 1 then
				--			LuaAddGetGiftCount(itemID)
				--		end
				--	end
				--end
				
				if isEqu == 1 then
					if LuaAddItemToPlayerBag(itemID,nil, nil, holeN or 0) == 1 then
						LuaAddGetGiftCount(itemID)
					end
				else
					--zhenkria新增英雄将魂碎片功能
					local iType = hVar.tab_item[itemID].type --道具类型
					--local itemNum = parmaN
					--if not parmaN or type(parmaN) ~= "number" or parmaN <= 0 then
					--	itemNum = 1
					--end
					--英雄将魂
					if iType == hVar.ITEM_TYPE.SOULSTONE then
						if itemID > 0 and hVar.tab_item[itemID] then
							local heroId = hVar.tab_item[itemID].heroID or 0
							if heroId > 0 and hVar.tab_unit[heroId] then
								--添加英雄将魂
								if LuaAddHeroCardSoulStone(heroId, itemNum) then
									LuaAddGetGiftCount(itemID, itemNum)
									LuaSaveHeroCard()
								end
							end
						end
						
					--战术技能卡碎片
					elseif iType == hVar.ITEM_TYPE.TACTICDEBRIS then
						if itemID > 0 and hVar.tab_item[itemID] then
							local tacticId = hVar.tab_item[itemID].tacticID or 0
							if tacticId > 0 and hVar.tab_tactics[tacticId] then
								--添加战术技能卡碎片
								if LuaAddPlayerTacticDebris(tacticId, itemNum) == 1 then
									LuaAddGetGiftCount(itemID, itemNum)
									LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
								end
							end
						end
					else
						if LuaAddItemToPlayerBag(itemID,{0}) == 1 then
							LuaAddGetGiftCount(itemID)
						end
					end
				end
			end
		end
		
		if type(score) == "number" and score ~= 0 then
			LuaAddPlayerScore(score)
		end
		
		tipFrm:show(1)
		tipFrm:active()
		
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--红装兑换的确认
		if (type(paramA) == "number") and (mode == 1) then
			SendCmdFunc["log_heroequip_finish"](paramA, 2, nil, tostring(logid_uID))
		--邮件领取奖励的确认
		elseif (type(prizeid) == "number") then
			SendCmdFunc["confirm_prize_list"](prizeid)
			hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)
		end
	end)
	
	--首重奖励信息
	hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "SetgiftFrmBtnState2", function(statelist)
		if (nowChoiceGift >= 1) and (nowChoiceGift <= 3) then
			if statelist[nowChoiceGift] == 1 then
				_childUI["giftGetIcon"].handle._n:setVisible(true)
			end
		end
		
		if (nowChoiceGift == 5) then 
			for i = 5, 10, 1 do
				if (statelist[i] == 1) then
					local ii = i - 4
					_childUI["giftGetIcon"..ii].handle._n:setVisible(true)
				end
			end
		end
	end)
	
	--登入天数信息
	hGlobal.event:listen("LocalEvent_LoginDays", "loginDays", function(iLoginDays)
		--存储登入的天数
		--print("=====> 登入天数: " .. iLoginDays)
	end)
	
	hGlobal.event:listen("LocalEvent_Setbtn_compensate", "appC", function(state) 
		--geyachao: 据研究代码，发现此标记已废弃，已挪到{"LocalEvent_Setbtn_compensate","Phone_appC"}参数监听
		if state == 1 then
			inAppC = 1
		else
			inAppC = -1
		end
	end)
	
----------------------------------------------------礼包相关------------------------------------------------------
end