--购买新手礼包界面
hGlobal.UI.InitBuyItemFram = function(mode)
	local tInitEventName = {"LocalEvent_BuyGiftItem","_BuyGiftItem"}
	if mode~="include" then
		return tInitEventName
	end
	
	local _w,_h = 520,360
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2
	
	hGlobal.UI.BuyItemFram = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 4,
		w = _w,
		h = _h,
		z = 10001,
		--titlebar = 0,
		show = 0,
		--bgAlpha = 0,
		--bgMode = "tile",
		background = "misc/skillup/msgbox4.png",--"UI:Tactic_Background_No_Top",
		border = 0,
		autoactive = 0,
	})
	
	local _frm = hGlobal.UI.BuyItemFram
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--提示文字title
	_childUI["tipLab"] =  hUI.label:new({
		parent = _parent,
		x = _w/2,
		y = -60,
		text = hVar.tab_string["__TEXT_GetItem5"],
		size = 32,
		width = _w-70,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	--确定按钮
	local removeGiftUI = {}
	_childUI["btnClose"] =  hUI.button:new({
		parent = _frm,
		model = "misc/addition/cg.png",
		x = _w/2 -6,
		y = -_h + 60,
		scale = 0.8,
		scaleT = 0.95,
		label = {text = hVar.tab_string["Exit_Ack"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,}, --"确定"
		code = function()
			_frm:show(0,"fade")
			--if LuaCheckGiftBag() == 1 then
			--	if hGlobal.UI.SystemMenuBar then
			--		hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
			--	end
			--end
			for i = 1,#removeGiftUI do
				hApi.safeRemoveT(_childUI,removeGiftUI[i])
			end
			removeGiftUI = {}
			hGlobal.event:event("LocalEvent_ClickGiftOk") --geaychao: 为引导加的点击ok按钮事件
		end,
	})
	
	local _slotOffX = 150
	local _beginOffsetX = 0
	--成功购买礼品道具的事件
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(itemIDList,shopID,mode,isShow)
		--print("成功购买礼品道具的事件", "itemIDList", unpack(itemIDList[1]), "shopID=", shopID, "mode=", mode, "isShow=", isShow, debug.traceback())
		local tipText = ""
		if mode == nil or mode == 1 then
			tipText = hVar.tab_string["__TEXT_GetItem5"].."  "..hVar.tab_stringI[shopID][1]
		else
			tipText = hVar.tab_string["ios_prize_from_system"]
			
		end
		_childUI["tipLab"]:setText(tipText)
		for i = 1,#removeGiftUI do
			hApi.safeRemoveT(_childUI,removeGiftUI[i])
		end
		removeGiftUI = {}
		
		if type(itemIDList) == "table" then
			--如果数量大于3个，间距小点
			if (#itemIDList <= 3) then
				_slotOffX = 150
				_beginOffsetX = 0
			elseif (#itemIDList == 4) then
				_slotOffX = 120
				_beginOffsetX = 50
			elseif (#itemIDList >= 5) then
				_slotOffX = 104
				_beginOffsetX = 100
			end
			
			for i = 1,#itemIDList do
				local itemX,itemY = math.floor((_w/2+70) -#itemIDList *150/2 + (i-1)*_slotOffX) + _beginOffsetX,-166
				local itype,itemID,parmaN = unpack(itemIDList[i])
				--print("itype,itemID,parmaN", itype,itemID,parmaN)
				--道具
				if itype == "item" then
					local itemLv = hVar.tab_item[itemID].itemLv or 1
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					--if type(hVar.tab_item[itemID].elite) == "number" then
					--	RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[itemID].elite].NAMERGB
					--end
					
					local isEqu = 0
					if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
						isEqu = 1
					end
					
					_childUI["lv_bg_bg"..i] = hUI.image:new({
						parent = _parent,
						model = "UI:item1",
						
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "lv_bg_bg"..i
					
					local bgmodel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
					_childUI["lv_bg_"..i] = hUI.image:new({
						parent = _parent,
						model = bgmodel,
						
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
					
					_childUI["itemImage_"..i] =hUI.image:new({
						parent = _parent,
						model = hVar.tab_item[itemID].icon,
						x = itemX,
						y = itemY,
						w = 52,
					})
					removeGiftUI[#removeGiftUI+1] = "itemImage_"..i
					
					_childUI["itemBtnTip_"..i] =  hUI.button:new({
						parent = _frm,
						model = -1,
						x = itemX,
						y = itemY,
						w = 64,
						h = 64,
						code = function(self)
							hGlobal.event:event("LocalEvent_ShowItemTipFram",{{itemID,1,nil}},nil,1)
						end,
					})
					removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
					
					--if itemNum > 1 then
						----道具个数
						--_childUI["itemNum_"..i] =  hUI.label:new({
							--parent = _parent,
							--x = itemX+24,
							--y = itemY-4,
							--text = itemNum,
							--size = 18,
							--width = _w-64,
							--align = "RT",
							--border = 1,
							--z = 100
						--})
						--removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					--end
					
					--itemName
					_childUI["itemName_"..i] =  hUI.label:new({
						parent = _parent,
						x = itemX,
						y = itemY - 50,
						text = hVar.tab_stringI[itemID][1],
						size = 24,
						width = _w-64,
						font = hVar.FONTC,
						align = "MC",
						border = 1,
						RGB = RGB,
					})
					removeGiftUI[#removeGiftUI+1] = "itemName_"..i
					
					if isEqu == 1 then
					--						local rewardEx = -1
					--						if type(parmaN) == "number" then
					--							--如果孔数为0 则随机产生孔数字
					--							if parmaN == 0 then
					--								local nSlotNum = hApi.CalculateItemRewardEx(itemID)
					--								rewardEx = hApi.NumTable(nSlotNum+1)
					--								rewardEx[1] = nSlotNum
					--							--否则就是指定孔数
					--							elseif parmaN > 1 then
					--								rewardEx = hApi.NumTable(parmaN+1)
					--								rewardEx[1] = parmaN
					--							end
					--						elseif parmaN == nil then
					--							local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
					--							local MaxSlot = itemRulu[#itemRulu][2]
					--							rewardEx = hApi.NumTable(MaxSlot+1)
					--							rewardEx[1] = MaxSlot
					--						end
						
						if LuaAddItemToPlayerBag(itemID,nil, nil, parmaN or 0) == 1 then
							LuaAddGetGiftCount(itemID)
						end
					else
						--zhenkria新增英雄将魂碎片功能
						local iType = hVar.tab_item[itemID].type --道具类型
						local itemNum = parmaN
						if not parmaN or type(parmaN) ~= "number" or parmaN <= 0 then
							itemNum = 1
						end
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
										--道具名称显示碎片数量
										_childUI["itemName_"..i]:setText(hVar.tab_stringI[itemID][1] .. "+" .. itemNum)
										
										LuaAddGetGiftCount(itemID, itemNum)
										--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
										--安卓 保存玩家数据表
										--添加战术技能卡碎片
										local keyList = {"skill",}
										LuaSavePlayerData_Android(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog, keyList)
									end
								end
							end
						else
							if LuaAddItemToPlayerBag(itemID,{0}) == 1 then
								LuaAddGetGiftCount(itemID)
							end
						end
					end
					
				elseif itype == "card" then
					_childUI["card_image_"..i] = hUI.image:new({
						parent = _parent,
						model = hVar.tab_tactics[itemID].icon,
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "card_image_"..i

					_childUI["itemBtnTip_"..i] =  hUI.button:new({
						parent = _frm,
						model = -1,
						x = itemX,
						y = itemY,
						w = 64,
						h = 64,
						code = function(self)
							hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",itemID,parmaN,_x - 100,hVar.SCREEN.h/2 + 150)
						end,
					})
					removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
					
					--名字
					_childUI["card_lab_"..i] = hUI.label:new({
						parent = _parent,
						x = itemX,
						y = itemY - 50,

						size = 24,
						align = "MC",
						border = 1,
						font = hVar.FONTC,
						width = 400,
						text = hVar.tab_stringT[itemID][1],
					})
					removeGiftUI[#removeGiftUI+1] = "card_lab_"..i
					
					if LuaAddPlayerSkillBook(itemID,parmaN) == 1 then
						
					else
						print("add card erro")
					end
				--锻造材料
				elseif itype == "mat" then
					local itemLv = hVar.tab_item[itemID].itemLv or 1
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					if type(hVar.tab_item[itemID].elite) == "number" then
						RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[itemID].elite].NAMERGB
					end
					
					local bgmodel = hVar.ITEMLEVEL[itemLv].BACKMODEL
					if isShow ~= 2 then
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["itemImage_"..i] =hUI.image:new({
							parent = _parent,
							model = hVar.tab_item[itemID].icon,
							x = itemX,
							y = itemY,
							w = 46,
						})
						removeGiftUI[#removeGiftUI+1] = "itemImage_"..i
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								hGlobal.event:event("LocalEvent_ShowItemTipFram",{{itemID,1,nil}},nil,1,itemX + 100,hVar.SCREEN.h/2 + 150)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						--itemName
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = hVar.tab_stringI[itemID][1].." + "..parmaN,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
							--RGB = RGB,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
					end
					
					if itemID == 29 then
						LuaAddPlayerMaterial(1,parmaN)
					elseif itemID == 30 then
						LuaAddPlayerMaterial(2,parmaN)
					elseif itemID == 31 then
						LuaAddPlayerMaterial(3,parmaN)
					end
					
					hApi.OnSaveData("TEMP_PLAYER_MAT")
				elseif itype == "hero" then
					if isShow~= 2 then
						_childUI["itemImage_"..i] =hUI.image:new({
							parent = _parent,
							model = hVar.tab_unit[itemID].icon,
							x = itemX,
							y = itemY,
							w = 56,
						})
						removeGiftUI[#removeGiftUI+1] = "itemImage_"..i

						--itemName
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = hVar.tab_stringU[itemID][1],
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
							RGB = RGB,
						})
					end
					
					hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",itemID)
				--积分显示
				elseif itype == "score" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID == 25 and parmaN > 0 and
					   isShow~= 2 then
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["score"..i] = hUI.image:new({
							parent = _parent,
							model = hVar.tab_item[itemID].icon,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
						})
						removeGiftUI[#removeGiftUI+1] = "score"..i
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示积分介绍的tip
								hApi.ShowJiFennTip()
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = hVar.tab_stringI[itemID][1],
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..parmaN,
							size = 22,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--金币显示
				elseif itype == "coin" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID == 27 and parmaN > 0 and
					   isShow~= 2 then
					   --print("itemID=", itemID)
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["coin"..i] = hUI.image:new({
							parent = _parent,
							model = hVar.tab_item[itemID].icon, --游戏币图标
							x = itemX,
							y = itemY,
							w = 72,
							h = 72,
						})
						removeGiftUI[#removeGiftUI+1] = "coin"..i
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示游戏币介绍的tip
								hApi.ShowGameCoinTip()
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = hVar.tab_stringI[itemID][1],
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..parmaN,
							size = 22,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--神器晶石显示
				elseif itype == "eqcrystal" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   parmaN > 0 and
					   isShow~= 2 then
						local rewardT = {11, parmaN,}
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = tmpModel,
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["eqcrystal"..i] = hUI.image:new({
							parent = _parent,
							model = "icon/item/chip06.png",
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
						})
						removeGiftUI[#removeGiftUI+1] = "eqcrystal"..i
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = itemName,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..itemNum,
							size = 22,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--高级战术卡包显示
				elseif itype == "tacticalcardpack" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID > 0 and
					   isShow~= 2 then
						local itemId = 9102 --高级战术卡包id
						local rewardT = {9, itemId, itemID,}
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["tacticalcardpack"..i] = hUI.image:new({
							parent = _parent,
							model = tmpModel,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
						})
						removeGiftUI[#removeGiftUI+1] = "tacticalcardpack"..i
						
						--子控件
						if sub_tmpModel then
							_childUI["tacticalcardpack_sub"..i] = hUI.image:new({
								parent = _parent,
								model = sub_tmpModel,
								x = itemX,
								y = itemY,
								w = 56,
								h = 56,
							})
							removeGiftUI[#removeGiftUI+1] = "tacticalcardpack_sub"..i
						end
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = itemName,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..itemNum,
							size = 22,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--幸运神器锦囊包显示
				elseif itype == "redeqchest" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID > 0 and
					   isShow~= 2 then
						local itemId = 9919 --幸运神器锦囊id
						local rewardT = {15, itemId, itemID,}
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["redeqchest"..i] = hUI.image:new({
							parent = _parent,
							model = tmpModel,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
						})
						removeGiftUI[#removeGiftUI+1] = "redeqchest"..i
						
						--子控件
						if sub_tmpModel then
							_childUI["redeqchest_sub"..i] = hUI.image:new({
								parent = _parent,
								model = sub_tmpModel,
								x = itemX,
								y = itemY,
								w = 56,
								h = 56,
							})
							removeGiftUI[#removeGiftUI+1] = "redeqchest_sub"..i
						end
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = itemName,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..itemNum,
							size = 22,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--红装兑换券显示
				elseif itype == "redeqexchangebf" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID > 0 and
					   isShow~= 2 then
						local rewardT = {12, itemID,}
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["redeqexchangebf"..i] = hUI.image:new({
							parent = _parent,
							model = tmpModel,
							x = itemX,
							y = itemY,
							w = 58,
							h = 58,
						})
						removeGiftUI[#removeGiftUI+1] = "redeqexchangebf"..i
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = itemName,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..itemNum,
							size = 24,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				--战术卡碎片
				elseif itype == "tacticcarddebris" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID > 0 and
					   isShow~= 2 then
						local itemId = itemID --幸运神器锦囊id
						local rewardT = {6, itemId, parmaN,}
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						
						_childUI["lv_bg_"..i] = hUI.image:new({
							parent = _parent,
							model = "UI:ItemSlot",
							x = itemX,
							y = itemY,
						})
						removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
						
						_childUI["tacticcarddebris"..i] = hUI.image:new({
							parent = _parent,
							model = tmpModel,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
						})
						removeGiftUI[#removeGiftUI+1] = "tacticcarddebris"..i
						
						--子控件
						if sub_tmpModel then
							_childUI["tacticcarddebris_sub"..i] = hUI.image:new({
								parent = _parent,
								model = sub_tmpModel,
								x = itemX + sub_pos_x * 64 / itemWidth,
								y = itemY + sub_pos_y * 64 / itemHeight,
								w = sub_pos_w * 64 / itemWidth,
								h = sub_pos_h * 64 / itemHeight,
							})
							removeGiftUI[#removeGiftUI+1] = "tacticcarddebris_sub"..i
						end
						
						_childUI["itemBtnTip_"..i] =  hUI.button:new({
							parent = _frm,
							model = -1,
							x = itemX,
							y = itemY,
							w = 64,
							h = 64,
							code = function(self)
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
						
						_childUI["itemName_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 50,
							text = itemName,
							size = 20,
							width = _w-64,
							font = hVar.FONTC,
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemName_"..i
						
						--道具数量
						_childUI["itemNum_"..i] =  hUI.label:new({
							parent = _parent,
							x = itemX,
							y = itemY - 18,
							text = "+"..itemNum,
							size = 24,
							width = _w-64,
							font = "numWhite",
							align = "MC",
							border = 1,
						})
						removeGiftUI[#removeGiftUI+1] = "itemNum_"..i
					end
				end 
			end
		end
		
		_frm:show(1)
		_frm:active()
	end)
	
	--礼包增加积分
	hGlobal.event:listen("LocalEvent_BuyGiftAddScore","_BuyGiftItem",function(itemIDList)
		if type(itemIDList) == "table" then
			for i = 1,#itemIDList do
				local itype,itemID,parmaN = unpack(itemIDList[i])
				if itype == "score" then
					if type(itemID) == "number" and 
					   type(parmaN) == "number" and
					   itemID == 25 and parmaN > 0 then
						LuaAddPlayerScore(parmaN)
					end
				end
			end
		end
	end)
end
--[[
--创建界面
if hGlobal.UI.BuyItemFram then
	hGlobal.UI.BuyItemFram:del()
	hGlobal.UI.BuyItemFram = nil
end
hGlobal.UI.InitBuyItemFram("include")
local giftList = {{"score", 25, 50,},{"eqcrystal", 0,1,}}
hGlobal.event:event("LocalEvent_BuyGiftItem",giftList,nil,2)
]]








--新手礼包提示界面
hGlobal.UI.InitGiftItemTipFram = function(mode)
	local tInitEventName = {"LocalEvent_GiftItemTip","_GiftItemTip"}
	--if mode~="include" then
		--return tInitEventName
	--end
	
	local _w,_h = 520,330
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2
	local removeGiftUI = {}
	local _childUI = nil

	hGlobal.UI.GiftItemTipFram = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 3,
		w = _w,
		h = _h,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		--background = "UI:tip_item",
		border = "UI:TileFrmBasic_thin",
		autoactive = 0,
	})
	
	local _frm = hGlobal.UI.GiftItemTipFram
	_childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--边框
	_childUI["gift_image_Border"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "light",
		x = 70,
		y = -84,
		w = 70,
		h = 70,
	})
	
	--提示文字title
	_childUI["tipLab1"] =  hUI.label:new({
		parent = _parent,
		x = _w/2 + 20,
		y = -30,
		text = hVar.tab_string["__TEXT_GetItem5"],
		size = 30,
		width = _w-64,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	_childUI["tipLab2"] =  hUI.label:new({
		parent = _parent,
		x = 120,
		y = -64,
		text = hVar.tab_string["__TEXT_GetItem5"],
		size = 24,
		width = _w-140,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})

	--关闭按钮
	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = _w-10,
		y = -15,
		scaleT = 0.9,
		z = 2,
		code = function()
			_frm:show(0)
			if LuaCheckGiftBag() == 1 then
				if hGlobal.UI.SystemMenuBar then
					hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
				end
			end
			for i = 1,#removeGiftUI do
				hApi.safeRemoveT(_childUI,removeGiftUI[i])
			end
			removeGiftUI = {}
		end,
	})

	local _slotOffX = 150
	--打开礼品道具的事件
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(shopId)
		--print("open item")
		for i = 1,#removeGiftUI do
			hApi.safeRemoveT(_childUI,removeGiftUI[i])
		end
		removeGiftUI = {}
		local itemIDList = hVar.tab_item[shopId].gift
		
		--礼品icon
		_childUI["gift_image_"] = hUI.image:new({
			parent = _parent,
			model = hVar.tab_item[shopId].icon,
			x = 70,
			y = -84,
		})
		removeGiftUI[#removeGiftUI+1] = "gift_image_"
		
		local itemLv = hVar.tab_item[shopId].itemLv or 1
		local model = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		_childUI["gift_image_Border"]:setmodel(model)
		_childUI["tipLab1"]:setText(hVar.tab_stringI[shopId][1])
		
		local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
		if type(hVar.tab_item[shopId].elite) == "number" then
			RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[shopId].elite].NAMERGB
		end
		_childUI["tipLab1"].handle.s:setColor(ccc3(RGB[1],RGB[2],RGB[3]))
		_childUI["tipLab2"]:setText(hVar.tab_stringI[shopId][2])
		
		if type(itemIDList) == "table" then
			for i = 1,#itemIDList do
				local itemX,itemY = math.floor((_w/2+70) -#itemIDList *150/2 + (i-1)*_slotOffX),-200
				local itype,itemID,parmaN = unpack(itemIDList[i])
				--道具
				if itype == "item" then
					local itemLv = hVar.tab_item[itemID].itemLv or 1
					local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
					if type(hVar.tab_item[itemID].elite) == "number" then
						RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[itemID].elite].NAMERGB
					end
					
					local isEqu = 0
					if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
						isEqu = 1
					end
					
					_childUI["lv_bg_bg"..i] = hUI.image:new({
						parent = _parent,
						model = "UI:item1",
						
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "lv_bg_bg"..i
					
					local bgmodel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
					_childUI["lv_bg_"..i] = hUI.image:new({
						parent = _parent,
						model = bgmodel,
						
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "lv_bg_"..i
					
					_childUI["itemImage_"..i] =hUI.image:new({
						parent = _parent,
						model = hVar.tab_item[itemID].icon,
						x = itemX,
						y = itemY,
						w = 52,
					})
					removeGiftUI[#removeGiftUI+1] = "itemImage_"..i
					
					_childUI["itemBtnTip_"..i] =  hUI.button:new({
						parent = _frm,
						model = -1,
						x = itemX,
						y = itemY,
						w = 64,
						h = 64,
						code = function(self)
							hGlobal.event:event("LocalEvent_ShowItemTipFram",{{itemID,1,{parmaN,0,0,0}}},nil,1)
						end,
					})
					removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
					
					--itemName
					_childUI["itemName_"..i] =  hUI.label:new({
						parent = _parent,
						x = itemX,
						y = itemY - 50,
						text = hVar.tab_stringI[itemID][1],
						size = 24,
						width = _w-64,
						font = hVar.FONTC,
						align = "MC",
						border = 1,
						--RGB = RGB,
					})
					removeGiftUI[#removeGiftUI+1] = "itemName_"..i

					if isEqu == 1 then
--						local rewardEx = -1
--						if type(parmaN) == "number" then
--							--如果孔数为0 则随机产生孔数字
--							if parmaN == 0 then
--								local nSlotNum = hApi.CalculateItemRewardEx(itemID)
--								rewardEx = hApi.NumTable(nSlotNum+1)
--								rewardEx[1] = nSlotNum
--							--否则就是指定孔数
--							elseif parmaN > 1 then
--								rewardEx = hApi.NumTable(parmaN+1)
--								rewardEx[1] = parmaN
--							end
--						elseif parmaN == nil then
--							local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
--							local MaxSlot = itemRulu[#itemRulu][2]
--							rewardEx = hApi.NumTable(MaxSlot+1)
--							rewardEx[1] = MaxSlot
--						end
						
					else
					
					end
					
				elseif itype == "card" then
					
					_childUI["card_image_"..i] = hUI.image:new({
						parent = _parent,
						model = hVar.tab_tactics[itemID].icon,
						x = itemX,
						y = itemY,
					})
					removeGiftUI[#removeGiftUI+1] = "card_image_"..i
					
					_childUI["itemBtnTip_"..i] =  hUI.button:new({
						parent = _frm,
						model = -1,
						x = itemX,
						y = itemY,
						w = 64,
						h = 64,
						code = function(self)
							hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",itemID,parmaN,_x - 100,hVar.SCREEN.h/2 + 150)
						end,
					})
					removeGiftUI[#removeGiftUI+1] = "itemBtnTip_"..i
					
					--名字
					_childUI["card_lab_"..i] = hUI.label:new({
						parent = _parent,
						x = itemX,
						y = itemY - 50,

						size = 24,
						align = "MC",
						border = 1,
						font = hVar.FONTC,
						width = 400,
						text = hVar.tab_stringT[itemID][1],
					})
					removeGiftUI[#removeGiftUI+1] = "card_lab_"..i
				end
			end
		end
		
		_frm:show(1)
		_frm:active()
	end)
end