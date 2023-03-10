hGlobal.UI.InitRecastFrm = function(mode)
	local tInitEventName = {"LocalEvent_showRecastFrmC","__UI__showRecastFrmC"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.RecastFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 500/2,
		y = hVar.SCREEN.h/2 + 550/2,
		dragable = 3,
		w = 500,
		h = 550,
		--z = -1,
		show = 0,
		--autoactive = 1,
		--background = "UI:tip_item",
	})

	local _frm = hGlobal.UI.RecastFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	local RemoveList = {}
	local _textInfoOffY = 66
	local keepT = {}
	local keepC = 0--保留数
	local MaxKeepC = 1--最多保留1孔
	local canRecastVipLevel = 4    --开放锁孔重铸的vip等级
	local rt = {}--重铸哪些孔
	local upCount,MaxCount = 0,0
	local nowMoney = 0
	local needMoney = 0

	local touthKeep = nil

	local __forgedbaglist = nil
	local _oHero = nil
	local _oUnit = nil
	local dzCount = 0 --锻造计数
	
	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w - 10,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0,"fade")
		end,
	})

	_childUI["frmName"] = hUI.label:new({
		parent = _parent,
		size = 32,
		align = "MC",
		font = hVar.FONTC,
		x = _frm.data.w/2 ,
		y = -50,
		width = 160,
		text = hVar.tab_string["__TEXT_RECAST"],
	})

	_childUI["ItemBG_1"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 68,
		h = 68,
		x = 65,
		y = -130,
	})

	_childUI["itmeName_1"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = 177 ,
		y = -105,
		width = 160,
		text = "",
	})

	_childUI["itmetype_1"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = 177 ,
		y = -155,
		width = 160,
		text = "",
	})

	_childUI["recast_lose"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LC",
		font = hVar.FONTC,
		x = 30 ,
		y = -215,
		width = 300,
		text = hVar.tab_string["__TEXT_Recast_Lose"],
	})

	_childUI["recast_keep"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LC",
		font = hVar.FONTC,
		x = 350 ,
		y = -215,
		width = 300,
		text = hVar.tab_string["__TEXT_Recast_Keep"],
	})

	--_childUI["gift_coin_icon_now"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/game_coins.png",
		----scale = 1.3,
		--x = 70 ,
		--y = -406,
		--w = 50,
		--h = 50,
	--})

	--_childUI["money_now_l"] = hUI.label:new({
		--parent = _parent,
		--size = 24,
		--align = "LC",
		----font = "numWhite",
		--x = 100 ,
		--y = -406,
		--width = 300,
		--text = "...",
	--})

	_childUI["gift_coin_icon_need"] = hUI.image:new({
		parent = _parent,
		model = "misc/game_coins.png",
		--scale = 1.3,
		x = 384 ,
		y = -471,
		w = 50,
		h = 50,
	})

	_childUI["need_net"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LC",
		font = hVar.FONTC,
		x = _frm.data.w/2 + 60,
		y = -315,
		width = 200,
		text = hVar.tab_string["__TEXT_RECAST_NET"],
	})

	_childUI["money_need_l"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LC",
		--font = "numWhite",
		x = 404 ,
		y = -469,
		width = 300,
		text = "X 0",
	})

	_childUI["recast"] = hUI.button:new({
		parent = _frm,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		label = {text = hVar.tab_string["__TEXT_RECAST_Cfm"],size = 24,font = hVar.FONTC,},
		font = hVar.FONTC,
		x = _frm.data.w/2,
		y = -469,
		w = 120,
		h = 40,
		scaleT = 0.9,
		code = function(self)
			_childUI["recast"]:setstate(0)
			rt = {}
			for i = 1,#keepT do
				if keepT[i] == 0 then
					rt[#rt + 1] = i
					recStr = recStr..":"..i
				end
			end

			if g_cur_net_state == 1 then--有网络
				--SendCmdFunc["buy_shopitem"](14,needMoney,hVar.tab_string["__TEXT_RECAST_KEEP"],0,recStr)
				if hVar.tab_item[_itemID] then
					local itemLv = hVar.tab_item[_itemID].itemLv or 1
					if itemLv > 2 then
						SendCmdFunc["order_begin"](6,14,needMoney,1,hVar.tab_string["__TEXT_RECAST_KEEP"],0,0,recStr)
					else
						local item_uid,slotN = tonumber(string.sub(recStr,1,string.find(recStr,":")-1)),string.sub(recStr,string.find(recStr,":")+1,string.len(recStr))
						local m_rt = {}
						for v in string.gfind(slotN..":","([^%:]+):+") do
							m_rt[#m_rt+1] = tonumber(v)
						end

						hApi.RecastItem(_oHero,{item_uid,m_rt})
						_frm:show(0,"fade")
					end
				end
				
			else
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tSendNetForged"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			end
		end,
	})

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isShow,_forgedbaglist,oHero,oUnit)
		
		_oHero = oHero
		_oUnit = oUnit
		_frm:show(isShow)
		if isShow == 1 then
			__forgedbaglist = {}
			__forgedbaglist[1],__forgedbaglist[2] = _forgedbaglist.from , _forgedbaglist.fromIndex
			SendCmdFunc["gamecoin"]()
			_childUI["recast"]:setstate(1)
			--_childUI["money_now_l"]:setText("...")
			--if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("x 0") end
			--if _childUI["money_need_l"] then _childUI["money_need_l"].handle.s:setColor(ccc3(255,255,255)) end
			nowMoney = 0
			needMoney = 0
			for i = 1,#RemoveList do
				hApi.safeRemoveT(_childUI,RemoveList[i])
			end
			RemoveList = {}
			keepT = {}
			keepC = 0
			local tItem = oHero:getbagitem(_forgedbaglist.from,_forgedbaglist.fromIndex)
			if tItem and type(tItem) == "table" then
				local oItemID = tItem[hVar.ITEM_DATA_INDEX.ID]--id
				local temptext = ""
				if hVar.tab_stringI[oItemID] then
					temptext = hVar.tab_stringI[oItemID][1]
				else
					temptext = hVar.tab_item[oItemID].name
				end
				_childUI["itmeName_1"]:setText(temptext)
				local itemLv = (hVar.tab_item[oItemID].itemLv or 1)
				local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
				if type(hVar.tab_item[oItemID].elite) == "number" then
					RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[oItemID].elite].NAMERGB
				end
				local R,G,B = unpack(RGB)
				_childUI["itmeName_1"].handle.s:setColor(ccc3(R,G,B))
				temptext = hVar.tab_string[hVar.ItemTypeStr[hVar.tab_item[oItemID].type]]
				_childUI["itmetype_1"]:setText(temptext)
				local tempItemiamgeH =  64
				if hVar.tab_item[oItemID].type == hVar.ITEM_TYPE.PLAYERITEM then
					tempItemiamgeH = 32
				end
				_childUI["Itemiamge_1"] = hUI.thumbImage:new({
					parent =  _parent,
					model = hVar.tab_item[oItemID].icon, 
					animation = "normal",
					w = tempItemiamgeH,
					h = tempItemiamgeH,
					x = 65,
					y = -129,
				})
				RemoveList[#RemoveList+1] = "Itemiamge_1"

				local tempH,tempY = 0,-100
				local itemreward = hVar.tab_item[oItemID].reward or {}

				--如果是 限时道具 则增加提示信息
				if hVar.tab_item[oItemID].continuedays ~= nil and tItem[4] and type(tItem[4]) == "table" then
					tempY = tempY - _textInfoOffY
					temptext = hVar.tab_string["__TEXT_YouCanKeep"]..(tItem[4][2] - (g_game_days - tItem[4][1]))..hVar.tab_string["__TEXT_Dat"]
					_childUI["itmehint_keepday_1"] = hUI.label:new({
						parent = _parent,
						size = 24,
						align = "LT",
						font = hVar.FONTC,
						x = 35,
						y = tempY,
						width = 240,
						text = temptext,
						RGB = {213,173,65},
					})
					RemoveList[#RemoveList+1] = "itmehint_keepday_1"
					tempY = tempY - _textInfoOffY
				end

				--属性附加 暂时不显示

				--额外属性系列
				local rewardEx = tItem[3]
				upCount,MaxCount = 0,0
				--计算出当前的空槽子
				if rewardEx and type(rewardEx) == "table" then
					MaxCount = rewardEx[1]
					for j = 2,#rewardEx do
						keepT[#keepT + 1] = 0
						if rewardEx[j] ~= 0 then
							upCount = upCount+1
						end
					end
				end
				--如果是可升级装备
				if MaxCount > 0  then
					--槽
					for j = 1,MaxCount do
						_childUI["item_star_slot_"..j] =hUI.image:new({
							parent = _parent,
							model =  "UI:diamond_slot",
							x = 40 +(j-1)*20,
							y = -175,
							w = 20,
							h = 20,
						})
						RemoveList[#RemoveList+1] = "item_star_slot_"..j
					end
					--宝石
					for j = 1,upCount do
						_childUI["item_star_"..j] =hUI.thumbImage:new({
							parent = _parent,
							model = "MODEL_EFFECT:diamond",
							x = 40 +(j-1)*20,
							y = -175,
							w = 20,
							h = 20,
						})
						RemoveList[#RemoveList+1] = "item_star_"..j
					end
				end
				dzCount = 0
				--显示 现在的额外属性
				if rewardEx and type(rewardEx) == "table" then
					tempY = -80
					local rname = "..."
					for j = 2,#rewardEx do
						if rewardEx[j] ~= 0 then
							dzCount = dzCount + 1
						end
					end
					local dx = 0
					if dzCount <= 1 then
						dx = 100
					end
					
					for j = 2,#rewardEx do
						if rewardEx[j] ~= 0 then
							
							local v = hVar.tab_enhance[rewardEx[j]].reward[1]
							tempH = tempH+1
							tempY = tempY - _textInfoOffY
							rname = hVar.tab_stringIE[rewardEx[j]][1]

							if v[1] == "Atk" then
								local miniAtk,maxAtk = v[2][1],v[2][2]
								temptext = hVar.tab_string[hVar.ItemRewardStr[v[1]]].."  "..miniAtk.." - "..maxAtk
							else
								if v[2] > 0 then
									--吸血要加个百分号
									if v[1] == "hpSteal" then
										temptext = hVar.tab_string[hVar.ItemRewardStr[v[1]]].." +"..v[2].."%"
									else
										temptext = hVar.tab_string[hVar.ItemRewardStr[v[1]]].." +"..v[2]
									end
								else
									temptext = hVar.tab_string[hVar.ItemRewardStr[v[1]]].." "..v[2]
								end
							end

							_childUI["ds"..j] =hUI.thumbImage:new({
								parent = _parent,
								model =  "UI:diamond_slot",
								x = 40 + dx,
								y = tempY - 117,
								w = 32,
								h = 32,
							})
							RemoveList[#RemoveList+1] = "ds"..j

							_childUI["ls"..j] =hUI.thumbImage:new({
								parent = _parent,
								model =  "MODEL_EFFECT:diamond",
								x = 40 + dx,
								y = tempY - 117,
								w = 32,
								h = 32,
							})
							_childUI["ls"..j].handle._n:setVisible(false)
							RemoveList[#RemoveList+1] = "ls"..j

							_childUI["imglocak"..j] = hUI.image:new({
								parent = _parent,
								model = "UI:Lock",
								x = 48 + dx,
								y = tempY - 125,
								w = 24,
								h = 24,
							})
							_childUI["imglocak"..j].handle._n:setVisible(false)
							RemoveList[#RemoveList+1] = "imglocak"..j

							_childUI["rewardEx_name_"..j] = hUI.label:new({
								parent = _parent,
								size = 24,
								align = "LT",
								font = hVar.FONTC,
								x = 50 + dx,
								y = tempY - 105,
								border = 1,
								width = 240,
								text = hVar.tab_string["["]..rname..hVar.tab_string["]"],
								RGB = {175,0,0},
							})
							RemoveList[#RemoveList+1] = "rewardEx_name_"..j
							
							_childUI["rewardEx_info_"..j] = hUI.label:new({
								parent = _parent,
								size = 24,
								align = "LT",
								font = hVar.FONTC,
								x = 146 + dx,
								y = tempY - 105,
								border = 1,
								width = 240,
								text = temptext,
								RGB = {175,0,0},
							})
							RemoveList[#RemoveList+1] = "rewardEx_info_"..j

							_childUI["keepB"..j] = hUI.button:new({
								parent = _frm,
								model = -1,
								x = _frm.data.w/2,
								y = tempY - 115,
								w = _frm.data.w,
								h = 48,
								scaleT = 0.9,
								code = function(self)
									touthKeep(j - 1)
								end,
							})
							RemoveList[#RemoveList+1] = "keepB"..j
							
							_childUI["keep"..j] = hUI.thumbImage:new({
								parent = _parent,
								model = "UI:Button_SelectBorder",
								x = _frm.data.w - 96,
								y = tempY - 115,
								w = 32,
								h = 32,
								scaleT = 0.9,
							})
							RemoveList[#RemoveList+1] = "keep"..j
							
							_childUI["keep_right"..j] =hUI.thumbImage:new({
								parent = _parent,
								model = "UI:finish",
								x = _frm.data.w - 88,
								y = tempY - 107,
								w = 56,
								h = 56,
							})
							_childUI["keep_right"..j].handle._n:setVisible(false)
							RemoveList[#RemoveList+1] = "keep_right"..j
						end
					end
				end

				if type(tItem) == "table" and type(tItem[3]) == "table" then

				end
				if g_cur_net_state == 1 then--有网络
					for j = 2,#rewardEx do
						if (_childUI["keepB"..j]) then _childUI["keepB"..j]:setstate(1) end
						if (_childUI["keep"..j]) then _childUI["keep"..j].handle.s:setColor(ccc3(255,255,255)) end
					end
				else
					for j = 2,#rewardEx do
						if (_childUI["keepB"..j]) then _childUI["keepB"..j]:setstate(0) end
						if (_childUI["keep"..j]) then _childUI["keep"..j].handle.s:setColor(ccc3(127,127,127)) end
					end
				end
				
				--print(dzCount,"count")
				if dzCount <= 1 or LuaGetPlayerVipLv() < canRecastVipLevel then
					for j = 2,4 do
						if (_childUI["keepB"..j]) then _childUI["keepB"..j]:setstate(0) end
						if(_childUI["keep"..(j)]) then _childUI["keep"..(j)].handle._n:setVisible(false) end
					end
					_childUI["recast_keep"]:setText("")
					_childUI["gift_coin_icon_need"].handle._n:setVisible(false)
					_childUI["money_need_l"]:setText("")
					if LuaGetPlayerVipLv() < canRecastVipLevel then
						_childUI["need_net"]:setText(hVar.tab_string["__TEXT_RECAST_NET"])
					else
						_childUI["need_net"]:setText("")
					end

					if dzCount <= 1 then
						_childUI["need_net"]:setText("")
					end
				else
					for j = 2,4 do
						if (_childUI["keepB"..j]) then _childUI["keepB"..j]:setstate(1) end
						if(_childUI["keep"..(j)]) then _childUI["keep"..(j)].handle._n:setVisible(true) end
					end
					_childUI["recast_keep"]:setText(hVar.tab_string["__TEXT_Recast_Keep"])
					_childUI["gift_coin_icon_need"].handle._n:setVisible(true)
					_childUI["money_need_l"]:setText("x 0")
					_childUI["need_net"]:setText("")
				end
				_frm:active()
			else

			end
		end
		
	end)
	
	--模拟保留花费计算
	local keepNeedMoney = function(i)
		if i == 1 then
			return 20
		elseif i == 2 then
			return 60
		elseif i == 3 then
			return 10000
		end
	end

	touthKeep = function(i)
		needMoney = 0
		_childUI["recast"]:setstate(1)
		if keepT[i] == 0 then
			for j = 1,#keepT do
				keepT[j] = 0
			end
			keepT[i] = 1
			keepC = 1
		else
			keepT[i] = 0
			keepC = 0
		end
	
		for j = 1,#keepT do
			if keepT[j] == 0 then
				if(_childUI["keep_right"..(j+1)]) then _childUI["keep_right"..(j+1)].handle._n:setVisible(false) end
				if(_childUI["imglocak"..(j+1)]) then _childUI["imglocak"..(j+1)].handle._n:setVisible(false) end
				if(_childUI["ls"..(j+1)])then _childUI["ls"..(j+1)].handle._n:setVisible(false) end
			else
				if(_childUI["keep_right"..(j+1)]) then _childUI["keep_right"..(j+1)].handle._n:setVisible(true) end
				if(_childUI["imglocak"..(j+1)]) then _childUI["imglocak"..(j+1)].handle._n:setVisible(true) end
				if(_childUI["ls"..(j+1)]) then _childUI["ls"..(j+1)].handle._n:setVisible(true) end
			end
		end
		if keepC > 0 then
			for i = 1,keepC do
				needMoney = needMoney + keepNeedMoney(i)
				if dzCount > 1 and LuaGetPlayerVipLv() >= canRecastVipLevel then
					if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("x "..tostring(needMoney)) end
					_childUI["need_net"]:setText("")
				else
					if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("") end
					if LuaGetPlayerVipLv() < canRecastVipLevel then
						_childUI["need_net"]:setText(hVar.tab_string["__TEXT_RECAST_NET"])
					else
						_childUI["need_net"]:setText("")
					end

					if dzCount <= 1 then
						_childUI["need_net"]:setText("")
					end
				end

				if type(nowMoney) == "number" then
					if needMoney > nowMoney then
						if _childUI["money_need_l"] then _childUI["money_need_l"].handle.s:setColor(ccc3(255,0,0)) end
						_childUI["recast"]:setstate(0)
					else
						if _childUI["money_need_l"] then _childUI["money_need_l"].handle.s:setColor(ccc3(255,255,255)) end
						_childUI["recast"]:setstate(1)
					end
				else
					_childUI["recast"]:setstate(0)
				end
			end
		else
			needMoney = 0
			if dzCount > 1 and LuaGetPlayerVipLv() >= canRecastVipLevel then
				if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("x "..tostring(needMoney)) end
				_childUI["need_net"]:setText("")
			else
				if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("") end
				if LuaGetPlayerVipLv() < canRecastVipLevel then
					_childUI["need_net"]:setText(hVar.tab_string["__TEXT_RECAST_NET"])
				else
					_childUI["need_net"]:setText("")
				end
				if dzCount <= 1 then
					_childUI["need_net"]:setText("")
				end
			end
			if _childUI["money_need_l"] then _childUI["money_need_l"].handle.s:setColor(ccc3(255,255,255)) end
		end
		if keepC >= upCount then
			needMoney = 0
			if dzCount > 1 and LuaGetPlayerVipLv() >= canRecastVipLevel then
				if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("x "..tostring(needMoney)) end
				_childUI["need_net"]:setText("")
			else
				if _childUI["money_need_l"] then _childUI["money_need_l"]:setText("") end
				if LuaGetPlayerVipLv() < canRecastVipLevel then
					_childUI["need_net"]:setText(hVar.tab_string["__TEXT_RECAST_NET"])
				else
					_childUI["need_net"]:setText("")
				end
				if dzCount <= 1 then
					_childUI["need_net"]:setText("")
				end
			end
			if _childUI["money_need_l"] then _childUI["money_need_l"].handle.s:setColor(ccc3(255,255,255)) end
			_childUI["recast"]:setstate(0)	
		end
	end

	hGlobal.event:listen("LocalEvent_SetCurGameCoin","griffin_recastFrm",function(cur_rmb)
		nowMoney = cur_rmb
		--_childUI["money_now_l"]:setText(tostring(nowMoney))
	end)

	hGlobal.event:listen("localEvent_afterRecastItemSucceed","griffin_recastFrm",function(restMoney)
		--print(restMoney)
		--hGlobal.event:event("LocalEvent_Recastbtn_Down",__forgedbaglist,_oHero,_oUnit,rt)
		
		hApi.RecastItem(_oHero,{__forgedbaglist[1],__forgedbaglist[2],rt})
		_frm:show(0,"fade")
	end)
end