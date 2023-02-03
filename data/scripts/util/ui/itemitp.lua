





--创建道具说明面板
hGlobal.UI.InitItemInfoFram = function()
	--iPhoneX黑边宽
	local iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then --iPhoneX
		iPhoneX_WIDTH = 80
	end
	
	--道具说明面板
	local RemoveList = {}
	local RemoveList_1 = {}
	hGlobal.UI.ItemInfoFram = hUI.frame:new({
		x = 730,
		y = 660,
		background = -1,
		--dragable = 0,
		--background = "UI:pvproombg",
		dragable = 2,
		h = 0,
		w = 330,
		titlebar = 0,
		show = 0,
		z = 100009,
		
		--阵营 side
		--单位类型 subtype type_id
		--空间类型 space_type
		--
		--全部事件
		codeOnDragEx = function(touchX, touchY, touchMode)
			if (touchMode == 0) then --按下
				--print("按下")
			elseif (touchMode == 1) then --滑动
				--print("滑动")
			elseif (touchMode == 2) then --抬起
				--print("抬起")
				--geyachao: 原tip删除流程到这里
				hGlobal.UI.ItemInfoFram:show(0)
				
				for i = 1,#RemoveList_1 do
					hApi.safeRemoveT(hGlobal.UI.ItemInfoFram.childUI, RemoveList_1[i])
				end
				RemoveList_1 = {}
				
				for i = 1,#RemoveList do
					hApi.safeRemoveT(hGlobal.UI.ItemInfoFram.childUI, RemoveList[i])
				end
				RemoveList = {}
			end
		end
	})
	
	--[[
	--另外一个道具信息面板
	local itemInfoFrm = hUI.frame:new({
		x = 330,
		y = 560,
		w = 480,
		h = 330,
		dragable = 2,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 470,
		closebtnY = -14,
		show = 0,
		z = 502,
	})
	
	hGlobal.UI.ItemInfoFram2 = itemInfoFrm
	]]
	local UnitItemInfoFram = hGlobal.UI.ItemInfoFram
	local _ItemchildUI = UnitItemInfoFram.childUI
	local _offX = 580
	local _offY = 10
	
	--道具图片底板1
	_ItemchildUI["ItemBan_1"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI:item1",
		x = 44 + 4,
		y = -60 + _offY,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBan_1"].handle._n:setVisible(false)
	
	--道具品质颜色背景1
	_ItemchildUI["ItemBG_1"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI_frm:slot",
		animation = "lightSlim",
		x = 44 + 4,
		y = -60 + _offY,
		z = 1,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBG_1"].handle._n:setVisible(false)
	
	--道具品质颜色背景1-颜色背景1
	_ItemchildUI["ItemBG_1_color"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI_frm:slot",
		animation = "lightSlim",
		x = 44 + 4,
		y = -60 + _offY,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBG_1_color"].handle._n:setVisible(false)
	
	--道具名字1
	_ItemchildUI["itmeName_1"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 32,
		align = "MC",
		font = hVar.FONTC,
		x = 160 + 30,
		y = -35 - 8 + _offY,
		width = 500,
		text = "",
	})
	
	--装备部位类型
	_ItemchildUI["itmetype_1"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = 160 + 30,
		y = -80 + _offY,
		width = 160,
		text = "",
	})
	
	--道具说明
	_ItemchildUI["itmehint_1"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 10,
		y = 0 + _offY,
		width = 312,
		text = "",
		RGB = {196, 196, 196},
	})
	
	--道具的附加说明
	_ItemchildUI["itmehintEx_1"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 10,
		y = 0 + _offY,
		width = 305,
		text = "",
		RGB = {230,180,50},
	})
	
	--道具图片底板
	_ItemchildUI["ItemBan_2"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI:item1",
		x = 44 + 4,
		y = -60 + _offY,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBan_2"].handle._n:setVisible(false)
	
	--图片品质颜色背景2
	_ItemchildUI["ItemBG_2"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI_frm:slot",
		animation = "lightSlim",
		x = 44 + 4 - _offX,
		y = -60 + _offY,
		z = 1,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBG_2"].handle._n:setVisible(false)
	
	--道具品质颜色背景2-颜色背景1
	_ItemchildUI["ItemBG_2_color"] = hUI.image:new({
		parent = UnitItemInfoFram.handle._n,
		model = "UI_frm:slot",
		animation = "lightSlim",
		x = 44 + 4 - _offX,
		y = -60 + _offY,
		w = 72,
		h = 72,
	})
	_ItemchildUI["ItemBG_2_color"].handle._n:setVisible(false)
	
	--道具名字2
	_ItemchildUI["itmeName_2"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 32,
		align = "MC",
		font = hVar.FONTC,
		x = 160 + 20 - _offX,
		y = -35 - 8 + _offY,
		width = 160,
		text = "",
	})
	
	--_ItemchildUI["itmeyzb"] = hUI.label:new({
		--parent = UnitItemInfoFram.handle._n,
		--size = 24,
		--align = "MC",
		--font = hVar.FONTC,
		--x = 160 - _offX,
		--y = -58 + _offY,
		--width = 160,
		--RGB = {0,255,0},
		--text = hVar.tab_string["__TEXT_ISQuipment"],
	--})
	
	--勾勾1
	_ItemchildUI["ItemBG_2"].childUI["itmeyzb"] = hUI.image:new({
		parent = _ItemchildUI["ItemBG_2"].handle._n,
		--size = 24,
		model = "UI:finish",
		x = 72 - 15,
		y = 0 + 10 + _offY,
		z = 1000,
		scale = 0.8,
	})
	
	--装备部位类型2
	_ItemchildUI["itmetype_2"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = 160 + 20 - _offX,
		y = -80 + _offY,
		width = 160,
		text = "",
	})
	
	--道具说明
	_ItemchildUI["itmehint_2"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 10 -_offX,
		y = 0 + _offY,
		width = 312,
		text = "",
		RGB = {196, 196, 196},
	})
	
	--道具的附加说明
	_ItemchildUI["itmehintEx_2"] = hUI.label:new({
		parent = UnitItemInfoFram.handle._n,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 10,
		y = 0 + _offY,
		width = 305,
		text = "",
		RGB = {230,180,50},
	})
	
	--szOpType: 道具的位置类型 ("equipage" "playerbag" "gamebag")
	local _textInfoOffY = 26
	local _createItemInfoFram = function(itenIDlist, fram, offx, mapBagMode, szOpType, oHero, parent)
		--geyachao: 支持可以从外部传入父控件，将道具tip绘制在别的界面上
		local _parent = hGlobal.UI.ItemInfoFram
		local _ItemchildUI = UnitItemInfoFram.childUI
		if parent then
			_parent = parent
			_ItemchildUI = parent.childUI
		end
		
		for i = 1, #RemoveList, 1 do
			hApi.safeRemoveT(UnitItemInfoFram.childUI, RemoveList[i]) --也删除通用tip的数据
			hApi.safeRemoveT(_ItemchildUI, RemoveList[i])
		end
		RemoveList = {}
		
		for i = 1, #itenIDlist, 1 do
			--显示道具图片的背景
			_ItemchildUI["ItemBG_"..i].handle._n:setVisible(true)
			_ItemchildUI["ItemBG_"..i .. "_color"].handle._n:setVisible(false)
			_ItemchildUI["ItemBan_"..i].handle._n:setVisible(true)
			
			local oItemID = itenIDlist[i][hVar.ITEM_DATA_INDEX.ID]
			--设置道具名字,道具说明
			local temptext = ""
			if hVar.tab_stringI[oItemID] then
				temptext = hVar.tab_stringI[oItemID][1]
			else
				temptext = hVar.tab_item[oItemID].name
			end
			
			_ItemchildUI["itmeName_"..i]:setText(temptext)
			
			_ItemchildUI["itmeName_"..i].handle._n:setVisible(true)
			if i == 2 then
				--_ItemchildUI["itmeyzb"].handle._n:setVisible(true)
			end
			--更改字体颜色
			local itemLv = (hVar.tab_item[oItemID].itemLv or 1)
			local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
			if type(hVar.tab_item[oItemID].elite) == "number" then
				RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[oItemID].elite].NAMERGB
			end
			
			--设置道具的品质背景图
			local ITEMMODEL = hVar.ITEMLEVEL[itemLv].ITEMMODEL
			_ItemchildUI["ItemBG_"..i]:setmodel(ITEMMODEL, nil, nil, _ItemchildUI["ItemBG_"..i].data.w, _ItemchildUI["ItemBG_"..i].data.h)
			--_ItemchildUI["ItemBG_"..i].handle.s:setOpacity(155) --设置道具颜色背景默认灰度
			if (hVar.tab_item[oItemID].isArtifact == 1) then
				--如果是神器，背景图是单独的
				_ItemchildUI["ItemBG_"..i]:setmodel("ICON:Back_red3", nil, nil, _ItemchildUI["ItemBG_"..i].data.w, _ItemchildUI["ItemBG_"..i].data.h)
				--_ItemchildUI["ItemBG_"..i].handle.s:setOpacity(255) --设置道具颜色背景全量
			end
			
			--道具的孔的属性的倍数
			local slotAttrRatio = hVar.tab_item[oItemID].slotAttrRatio or 1 --孔的属性倍数
			
			--消耗品、碎片、将魂，显示颜色底板
			local itemType = hVar.tab_item[oItemID].type
			--print("itemType=", itemType)
			if (itemType == hVar.ITEM_TYPE.PLAYERITEM) --or (itemType == hVar.ITEM_TYPE.RESOURCES)
				or (itemType == hVar.ITEM_TYPE.REWARD) or (itemType == hVar.ITEM_TYPE.GIFTITEM)
				or (itemType == hVar.ITEM_TYPE.SOULSTONE) or (itemType == hVar.ITEM_TYPE.TACTICDEBRIS)
				or (itemType == hVar.ITEM_TYPE.DEPLETION) then
				_ItemchildUI["ItemBG_"..i].handle._n:setVisible(false)
				_ItemchildUI["ItemBG_"..i .. "_color"].handle._n:setVisible(true)
				--设置道具的品质背景图
				local ITEMMODEL = hVar.ITEMLEVEL[itemLv].BORDERMODEL
				_ItemchildUI["ItemBG_"..i .. "_color"]:setmodel(ITEMMODEL, nil, nil, _ItemchildUI["ItemBG_"..i .. "_color"].data.w, _ItemchildUI["ItemBG_"..i .. "_color"].data.h)
			end
			
			--资源类型道具，不显示底板
			if (itemType == hVar.ITEM_TYPE.RESOURCES) then
				_ItemchildUI["ItemBG_"..i].handle._n:setVisible(false)
				_ItemchildUI["ItemBG_"..i .. "_color"].handle._n:setVisible(false)
				_ItemchildUI["ItemBan_"..i].handle._n:setVisible(false)
			end
			
			local R,G,B = unpack(RGB)
			_ItemchildUI["itmeName_"..i].handle.s:setColor(ccc3(R,G,B))
			
			temptext = hVar.tab_string[hVar.ItemTypeStr[hVar.tab_item[oItemID].type]]
			_ItemchildUI["itmetype_"..i]:setText(temptext)
			
			_ItemchildUI["itmetype_"..i].handle._n:setVisible(true)
			
			--道具图片
			local tempItemiamgeH =  64
			if hVar.tab_item[oItemID].type == hVar.ITEM_TYPE.PLAYERITEM or hVar.tab_item[oItemID].type == hVar.ITEM_TYPE.REWARD then
				tempItemiamgeH = 32
			end
			
			local oNode = hUI.node:new({
				parent = _parent.handle._n,
				x = 44 + 4 -(i-1)*(offx or _offX),
				y = -59 + _offY,
			})
			_ItemchildUI["Itemiamge_"..i] = oNode
			RemoveList[#RemoveList+1] = "Itemiamge_"..i
			local v = hUI.GetUITemplate("bagitem")
			hUI.CreateMultiUIByParam(oNode.handle._n,0,0,v[1],{},v[2].GetParam({"it",oItemID},{bg=0,h=tempItemiamgeH}))
			--神器的特别背景图
			if (hVar.tab_item[oItemID].isArtifact == 1) then
				--如果是神器，背景图是单独的
				--_ItemchildUI["ItemBG_"..i]:setmodel("ICON:Back_red3", nil, nil, _ItemchildUI["ItemBG_"..i].data.w, _ItemchildUI["ItemBG_"..i].data.h)
				--_ItemchildUI["ItemBG_"..i].handle.s:setOpacity(255) --设置道具颜色背景全量
				
				--_ItemchildUI["ItemBG_"..i].handle._n:setVisible(false)
				_ItemchildUI["ItemBan_"..i].handle._n:setVisible(false)
				
				--道具品质颜色背景1
				_ItemchildUI["itemColorBG" .. i] = hUI.image:new({
					parent = _parent.handle._n,
					model = hVar.tab_item[oItemID].icon,
					x = 44 + 4 - (i - 1) * (offx or _offX),
					y = -60 + _offY,
					z = 1,
					w = 64,
					h = 64,
				})
				RemoveList[#RemoveList+1] = "itemColorBG" .. i
			end
			
			--碎片、将魂显示碎片图标
			local itemType = hVar.tab_item[oItemID].type
			--print("itemType=", itemType)
			if (itemType == hVar.ITEM_TYPE.SOULSTONE) or (itemType == hVar.ITEM_TYPE.TACTICDEBRIS) then
				--碎片图标
				_ItemchildUI["itemDerbirs" .. i] = hUI.image:new({
					parent = _parent.handle._n,
					model = "UI:SoulStoneFlag",
					x = 44 + 4 - (i - 1) * (offx or _offX) + 19,
					y = -60 + _offY - 11,
					z = 1,
					w = 38,
					h = 55,
				})
				RemoveList[#RemoveList+1] = "itemDerbirs" .. i
			end
			
			local tempH,tempY = 0, _offY
			local itemreward = hVar.tab_item[oItemID].reward or {}
			local nRequireLv = hApi.GetItemRequire(oItemID,"level")
			
			if (nRequireLv > 0) and (nRequireLv < 99) then
				tempH = tempH + 1 
				tempY = -114-0*_textInfoOffY
				--需求等级
				_ItemchildUI["itemrequireLv" .. i] = hUI.label:new({
					parent = _parent.handle._n,
					size = 24,
					align = "LT",
					font = hVar.FONTC,
					x = 10-(i-1)*(offx or _offX),
					y = tempY,
					width = 305,
					--text = "需求等级", --language
					text = hVar.tab_string["__Item_Require_Level"], --language
				})
				_ItemchildUI["itemrequireLv" .. i].handle.s:setColor(ccc3(255, 212, 196))
				RemoveList[#RemoveList+1] = "itemrequireLv" .. i
				
				--需求等级值
				_ItemchildUI["itemrequireLvValue" .. i] = hUI.label:new({
					parent = _parent.handle._n,
					size = 24,
					align = "LT",
					font = hVar.FONTC,
					x = 10-(i-1)*(offx or _offX) + 170,
					y = tempY,
					width = 305,
					--text = nRequireLv .. "级", --language
					text = nRequireLv .. hVar.tab_string["__TEXT_ji"], --language
				})
				_ItemchildUI["itemrequireLvValue" .. i].handle.s:setColor(ccc3(255, 212, 196))
				RemoveList[#RemoveList+1] = "itemrequireLvValue" .. i
			end
			
			--如果是 限时道具 则增加提示信息
			if hVar.tab_item[oItemID].continuedays ~= nil and itenIDlist[i][hVar.ITEM_DATA_INDEX.PICK] and type(itenIDlist[i][hVar.ITEM_DATA_INDEX.PICK]) == "table" then
				tempY = tempY - _textInfoOffY
				temptext = hVar.tab_string["__TEXT_YouCanKeep"]..(itenIDlist[i][hVar.ITEM_DATA_INDEX.PICK][2] - (g_game_days - itenIDlist[i][hVar.ITEM_DATA_INDEX.PICK][1]))..hVar.tab_string["__TEXT_Dat"]
				_ItemchildUI["itmehint_keepday_"..i] = hUI.label:new({
					parent = _parent.handle._n,
					size = 24,
					align = "LT",
					font = hVar.FONTC,
					x = 10-(i-1)*(offx or _offX),
					y = tempY,
					width = 305,
					text = temptext,
					RGB = {213,173,65},
				})
				RemoveList[#RemoveList+1] = "itmehint_keepday_"..i
				tempY = tempY - _textInfoOffY
				
			end
			
			if (#itemreward > 0) then
				local tRewardSort = {}
				local tSortI = hVar.ITEM_ATTR_SORT[hVar.tab_item[oItemID].type]
				local tSortII = hVar.ITEM_ATTR_SORT
				if type(tSortI)~="table" then
					tSortI = tSortII
				end
				for j = 1, #itemreward, 1 do
					local sAttr = itemreward[j][1]
					local nSortC = tSortI[sAttr] or tSortII[sAttr] or 0
					local nInsert = #tRewardSort+1
					for n = 1,#tRewardSort do
						local sAttrP = tRewardSort[n][1]
						if nSortC>(tSortI[sAttrP] or tSortII[sAttrP] or 0) then
							nInsert = n
							break
						end
					end
					hApi.InsertValueIntoTab(tRewardSort,nInsert,itemreward[j])
				end
				
				--属性附加
				for j = 1, #tRewardSort, 1 do
					local v = tRewardSort[j]
					--print("v", v)
					local temptextName = hVar.tab_string[hVar.ItemRewardStr[v[1]]]
					--print("temptextName", temptextName)
					local temptext = ""
					if v[1] == "Atk" then
						local miniAtk,maxAtk = v[2][1],v[2][2]
						temptext = miniAtk.." - "..maxAtk
					elseif (v[1] == "atk") then --geyachao: TD道具属性
						local atk_min, atk_max = v[2][1], v[2][2]
						temptext = atk_min .. " - " .. atk_max
					else
						local sign = nil --正负号
						
						local lv = 1
						local quality = itenIDlist[i][hVar.ITEM_DATA_INDEX.QUALITY] --品质
						local strExpress = tostring(v[2])
						local v2 = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = lv, ["@quality"] = quality,}, strExpress, 0)
						
						local u_value = math.abs(v2) --无符号的值
						if (v2 >= 0) then
							sign = "＋"
						else
							sign = "－"
						end
						
						if (v[1] == "atk_interval") then --攻击间隔
							local floorvalue = u_value / 1000
							local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
							--temptext = sign .. szfloorvalue .. "秒" --language
							temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
						elseif (v[1] == "rebirth_time") then --复活时间
							local floorvalue = u_value / 1000
							--local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
							local szfloorvalue = math.floor(floorvalue)
							--temptext = sign .. szfloorvalue .. "秒" --language
							temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
						elseif (v[1] == "AI_attribute") then --AI行为
							if (v2 == 1) then
								--temptext = "主动攻击" --language
								temptext = hVar.tab_string["__Attr_Hint_active_attack"] --language
							else
								--temptext = "不主动攻击" --language
								temptext = hVar.tab_string["__Attr_Hint_passive_attack"] --language
							end
						elseif (v[1] == "kill_gold") then --击杀奖励金币
							--temptext = sign .. u_value .. "金" --language
							temptext = sign .. u_value .. hVar.tab_string["gold"] --language
						elseif (v[1] == "escape_punish") then --逃怪惩罚
							--temptext = sign .. u_value .. "生命" --language
							temptext = sign .. u_value .. hVar.tab_string["blood"] --language
						elseif (v[1] == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
							local floorvalue = u_value / 1000
							--local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
							local szfloorvalue = math.floor(floorvalue)
							--temptext = sign .. szfloorvalue .. "秒" --language
							temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
						elseif (v[1] == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
							local floorvalue = u_value / 1000
							local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
							--temptext = sign .. szfloorvalue .. "秒" --language
							temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
						elseif (v[1] == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
							temptext = sign .. u_value
						elseif (v[1] == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
							temptext = sign .. u_value
						elseif (v[1] == "hp_restore_delta_rate") then --回血倍率比例值（去百分号后的值）
							temptext = sign .. u_value
						elseif (v[1] == "crit_value") then --暴击倍数（支持小数）
							--temptext = sign .. u_value .. "倍" --language
							--local szfloorvalue = string.format("%.1f", u_value) --保留1位有效数字
							local szfloorvalue = u_value * 100
							temptext = sign .. szfloorvalue .. hVar.tab_string["__Rate"] --language
						elseif (v[1] == "crit_immue") then --暴击免伤
							temptext = sign .. u_value
						else
							temptext = sign .. u_value
						end
						
						--百分比显示
						if (hVar.ItemRewardStrMode[v[1]] == 1) then
							temptext = temptext .. "%"
						end
					end
					tempY = tempY - _textInfoOffY
					tempH = tempH + 1
					--属性名
					_ItemchildUI["itemreward_" .. i .. j] = hUI.label:new({
						parent = _parent.handle._n,
						size = 24,
						align = "LT",
						font = hVar.FONTC,
						x = 10-(i-1)*(offx or _offX),
						y = tempY,
						width = 305,
						text = temptextName,
					})
					RemoveList[#RemoveList + 1] = "itemreward_" .. i .. j
					
					--属性值
					_ItemchildUI["itemreward_Value_" .. i .. j] = hUI.label:new({
						parent = _parent.handle._n,
						size = 24,
						align = "LT",
						font = hVar.FONTC,
						x = 10-(i-1)*(offx or _offX) + 170,
						y = tempY,
						width = 305,
						text = temptext,
					})
					--[[
					--属性值的颜色
					local colorSign = hVar.ItemAttrPositiveSign[v[1] ] or 1
					local valueSign = 0
					if (v[1] == "Atk") then
						valueSign = v2[1]
					elseif (v[1] == "atk") then --geyachao: TD道具属性
						valueSign = v2[1]
					else
						valueSign = v2
					end
					if (colorSign > 0) and (valueSign >= 0) then
						--_ItemchildUI["itemreward_Value_" .. i .. j].handle.s:setColor(ccc3(255, 255, 255)) --正面属性
					elseif (colorSign < 0) and (valueSign < 0) then
						--_ItemchildUI["itemreward_Value_" .. i .. j].handle.s:setColor(ccc3(255, 255, 255)) --正面属性
					else
						_ItemchildUI["itemreward_Value_" .. i .. j].handle.s:setColor(ccc3(255, 168, 168)) --负面属性
					end
					]]
					
					
					RemoveList[#RemoveList + 1] = "itemreward_Value_" .. i .. j
					
					--[[
					--geyachao: 如果复活时间有最小值，这里显示tip
					if (hVar.ROLE_REBIRTH_MIN_TIME > 0) then
						if (v[1] == "rebirth_time") then --复活时间
							--占用多行的再换行
							--tempY = tempY - _textInfoOffY
							--tempH = tempH + 1 
							
							--local postfix = "(最低" .. (hVar.ROLE_REBIRTH_MIN_TIME / 1000) .. "秒)" --language
							local postfix = "(" .. hVar.tab_string["__RebirthMinValue"] .. (hVar.ROLE_REBIRTH_MIN_TIME / 1000) .. hVar.tab_string["__Second"] .. ")" --language
							
							_ItemchildUI["itemrewardhint_" .. i .. j] = hUI.label:new({
								parent = _parent.handle._n,
								size = 24,
								align = "LT",
								font = hVar.FONTC,
								x = 10-(i-1)*(offx or _offX) + 226,
								y = tempY,
								width = 540,
								text = postfix,
							})
							RemoveList[#RemoveList + 1] = "itemrewardhint_" .. i .. j
							_ItemchildUI["itemrewardhint_" .. i .. j].handle.s:setColor(ccc3(128, 128, 128))
						end
					end
					]]
				end
			end
			
			--额外属性系列
			local rewardEx = itenIDlist[i][hVar.ITEM_DATA_INDEX.SLOT]
			local upCount = 0 --有效的孔的数量
			local MaxCount = 0 --该品质道具的孔的数量上限 --最大孔的数量
			--如果是装备，才算孔
			if hApi.CheckItemIsEquip(oItemID) then
				--计算出当前的空槽子
				if rewardEx and type(rewardEx) == "table" then
					--MaxCount = #rewardEx
					for j = 1,#rewardEx do
						if rewardEx[j] and type(rewardEx[j]) == "string" and hVar.ITEM_ATTR_VAL[rewardEx[j]] then
							upCount = upCount + 1
						end
					end
				end
				
				--该品质道具的孔的数量上限 --最大孔的数量
				MaxCount = hVar.ITEM_ATTR_EX_LIMIT[itemLv]
				
				--如果是神器，孔的上限就是当前已获得的数量
				if (hVar.tab_item[oItemID].isArtifact == 1) then
					MaxCount = upCount
				end
			end
			
			tempY = tempY - _textInfoOffY
			
			--如果是可升级装备
			if (MaxCount > 0) then
				--tempY = tempY - _textInfoOffY
				--tempY = tempY - _textInfoOffY
				
				--先绘制已获得的孔（红色钻石）
				for j = 1, upCount, 1 do
					_ItemchildUI["item_star_"..i..j] = hUI.thumbImage:new({
						parent = _parent.handle._n,
						model = "MODEL_EFFECT:diamond",
						x = 22 +(j-1)*24 - (i-1)*(offx or _offX),
						--y = -109,
						y = tempY - 12,
						w = 24,
						h = 24,
					})
					RemoveList[#RemoveList+1] = "item_star_"..i..j
				end
				
				--再绘制孔的孔（灰色钻石）
				for j = upCount + 1, MaxCount, 1 do
					_ItemchildUI["item_star_slot_"..i..j] =hUI.image:new({
						parent = _parent.handle._n,
						model =  "UI:diamond_slot",
						x = 22 +(j-1)*24 - (i-1)*(offx or _offX),
						--y = -109,
						y = tempY - 12,
						w = 24,
						h = 24,
					})
					--_ItemchildUI["item_star_slot_"..i..j].handle.s:setColor(ccc3(0,0,0))
					RemoveList[#RemoveList+1] = "item_star_slot_"..i..j
				end
				
				tempY = tempY - _textInfoOffY
			end
			
			--显示 孔的额外属性
			if rewardEx and type(rewardEx) == "table" then
				local rname = "..."
				for j = 1, #rewardEx, 1 do
					local attr = rewardEx[j]
					if rewardEx[j] ~= 0 then
						local attrVal = hVar.ITEM_ATTR_VAL[attr]
						if attrVal and attrVal.attrAdd then
							if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
								local miniAtk, maxAtk = attrVal.value1, attrVal.value2
								temptext = miniAtk .. " - " .. maxAtk
							else --其它属性，只读第一个数值
								temptext = attrVal.value1
								
								local sign = nil --正负号
								local u_value = math.abs(attrVal.value1) --无符号的值
								if (attrVal.value1 >= 0) then
									sign = "＋"
								else
									sign = "－"
								end
								
								if (attrVal.attrAdd == "atk_interval") then --攻击间隔
									local floorvalue = u_value / 1000
									local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
									--temptext = sign .. szfloorvalue .. "秒" --language
									temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
								elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
									local floorvalue = u_value / 1000
									--local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
									local szfloorvalue = math.floor(floorvalue)
									--temptext = sign .. szfloorvalue .. "秒" --language
									temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
								elseif (attrVal.attrAdd == "AI_attribute") then --AI行为
									if (attrVal.value1 == 1) then
										--temptext = "主动攻击" --language
										temptext = hVar.tab_string["__Attr_Hint_active_attack"] --language
									else
										--temptext = "不主动攻击" --language
										temptext = hVar.tab_string["__Attr_Hint_passive_attack"] --language
									end
								elseif (attrVal.attrAdd == "kill_gold") then --击杀奖励金币
									--temptext = sign .. u_value .. "金" --language
									temptext = sign .. u_value .. hVar.tab_string["gold"] --language
								elseif (attrVal.attrAdd == "escape_punish") then --逃怪惩罚
									--temptext = sign .. u_value .. "生命" --language
									temptext = sign .. u_value .. hVar.tab_string["blood"] --language
								elseif (attrVal.attrAdd == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
									local floorvalue = u_value / 1000
									local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
									--temptext = sign .. szfloorvalue .. "秒" --language
									temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
								elseif (attrVal.attrAdd == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
									local floorvalue = u_value / 1000
									local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
									--temptext = sign .. szfloorvalue .. "秒" --language
									temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
								elseif (attrVal.attrAdd == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
									temptext = sign .. u_value
								elseif (attrVal.attrAdd == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
									temptext = sign .. u_value
								elseif (attrVal.attrAdd == "hp_restore_delta_rate") then --回血倍率比例值（去百分号后的值）
									temptext = sign .. u_value
								elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
									--temptext = sign .. u_value .. "倍" --language
									--local szfloorvalue = string.format("%.1f", u_value) --保留1位有效数字
									local szfloorvalue = u_value * 100
									temptext = sign .. szfloorvalue .. hVar.tab_string["__Rate"] --language
								elseif (attrVal.attrAdd == "crit_immue") then --暴击免伤
									temptext = sign .. u_value
								else
									temptext = sign .. u_value
								end
								
								--百分比显示
								if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
									temptext = temptext .. "％"
								end
							end
							
							rname = hVar.tab_string[attrVal.strTip]
							local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB
							
							--孔的属性条目名称
							_ItemchildUI["rewardEx_name_"..i..j] = hUI.label:new({
								parent = _parent.handle._n,
								size = 24,
								align = "LT",
								font = hVar.FONTC,
								x = 10-(i-1)*(offx or _offX),
								y = tempY,
								border = 1,
								width = 305,
								--text = hVar.tab_string["["]..rname..hVar.tab_string["]"],
								text = rname,
								RGB = rgb,
							})
							RemoveList[#RemoveList+1] = "rewardEx_name_"..i..j
							
							--孔的属性值
							_ItemchildUI["rewardEx_Value_"..i..j] = hUI.label:new({
								parent = _parent.handle._n,
								size = 24,
								align = "LT",
								font = hVar.FONTC,
								x = 10-(i-1)*(offx or _offX) + 170,
								y = tempY,
								border = 1,
								width = 305,
								text = (temptext),
								RGB = rgb,
							})
							RemoveList[#RemoveList+1] = "rewardEx_Value_"..i..j
							
							--[[
							--geyachao: 如果复活时间有最小值，这里显示tip
							if (hVar.ROLE_REBIRTH_MIN_TIME > 0) then
								if (attrVal.attrAdd == "rebirth_time") then --复活时间额外描述
									--local temptext = temptext .. "(最低" .. (hVar.ROLE_REBIRTH_MIN_TIME / 1000) .. "秒)" --language
									local temptext = "(" .. hVar.tab_string["__RebirthMinValue"] .. (hVar.ROLE_REBIRTH_MIN_TIME / 1000) .. hVar.tab_string["__Second"] .. ")" --language
									
									--属性条目名称
									_ItemchildUI["rewardEx_hint_" .. i .. j] = hUI.label:new({
										parent = _parent.handle._n,
										size = 24,
										align = "LT",
										font = hVar.FONTC,
										x = 10-(i-1)*(offx or _offX) + 226,
										y = tempY,
										border = 1,
										width = 540,
										--text = hVar.tab_string["["]..rname..hVar.tab_string["]"],
										text = temptext,
										--RGB = rgb,
									})
									RemoveList[#RemoveList+1] = "rewardEx_hint_" .. i .. j
									_ItemchildUI["rewardEx_hint_" .. i .. j].handle.s:setColor(ccc3(128, 128, 128))
									
									--额外换行
									--tempY = tempY - _textInfoOffY
								end
							end
							]]
							
							--孔的属性翻倍
							if (slotAttrRatio > 1) then
								_ItemchildUI["rewardEx_Double_"..i..j] = hUI.image:new({
									parent = _parent.handle._n,
									model = "misc/chest/upgradable.png",
									align = "MC",
									x = 10-(i-1)*(offx or _offX) + 280,
									y = tempY - 12,
									w = 25,
									h = 31,
								})
								RemoveList[#RemoveList+1] = "rewardEx_Double_"..i..j
								
								--孔的属性翻倍值
								_ItemchildUI["rewardEx_Double_Value_"..i..j] = hUI.label:new({
									parent = _parent.handle._n,
									size = 24,
									align = "LT",
									font = hVar.FONTC,
									x = 10-(i-1)*(offx or _offX) + 296,
									y = tempY,
									border = 1,
									width = 305,
									text = "x" .. slotAttrRatio,
									RGB = {81, 225, 242,},
								})
								RemoveList[#RemoveList+1] = "rewardEx_Double_Value_"..i..j
							end
							
							tempY = tempY - _textInfoOffY
						end
					end
				end
			end
			
			local fuckH, lh = 0, 0
			--技能信息,蓝颜色字的
			local skillList = {}
			local skillId = 0
			if hVar.tab_item[oItemID].skillId and type(hVar.tab_item[oItemID].skillId) == "number" then
				--skillList = {}
				table.insert(skillList, {id =  hVar.tab_item[oItemID].skillId, lv = 1, cd = 1000})
			elseif hVar.tab_item[oItemID].skillId and type(hVar.tab_item[oItemID].skillId) == "table" then
				skillList = hVar.tab_item[oItemID].skillId
			elseif hVar.tab_item[oItemID].activeSkill and type(hVar.tab_item[oItemID].activeSkill) == "table" then --道具主动技能
				table.insert(skillList, hVar.tab_item[oItemID].activeSkill)
			else
				--skillList = {}
			end
			--if (hVar.tab_item[oItemID].skillId or 0)~=0 then
			for n = 1, #skillList do
				--local skillid = hVar.tab_item[oItemID].skillId
				local skillid = skillList[n].id or 0
				if skillid > 0 then
					if hVar.tab_stringS[skillid] and hVar.tab_stringS[skillid][1] then
						temptext = hVar.tab_stringS[skillid][1]
					else
						temptext = hVar.tab_skill[skillid].name 
					end
					tempH = tempH + 1
					tempY = tempY - _textInfoOffY
					_ItemchildUI["itmeskill_name_"..i.."_"..n] = hUI.label:new({
						parent = _parent.handle._n,
						size = 23,
						align = "LT",
						font = hVar.FONTC,
						border = 1,
						x = 10-(i-1)*(offx or _offX),
						y = tempY,
						width = 305,
						text = temptext,
						RGB = {100,200,255},
					})
					RemoveList[#RemoveList+1] = "itmeskill_name_"..i.."_"..n
					
					--显示物品技能属性需求
					local tAttrRequire = hApi.GetItemAttrRequire(oItemID)
					if #tAttrRequire>0 then
						local t = {hVar.tab_string["["],hVar.tab_string["__TEXT_NEED"]}
						for n = 1,#tAttrRequire do
							if n~=1 then
								t[#t+1] = " "
							end
							local k,v = tAttrRequire[n][1],tAttrRequire[n][2]
							t[#t+1] = hVar.tab_string[hVar.ItemRewardStr[k] or k]
							t[#t+1] = tostring(v)
						end
						t[#t+1] = hVar.tab_string["]"]
						temptext = table.concat(t)
						local size = 24
						local curX = 0
						local nNum = #tAttrRequire
						if nNum==1 then
							size = 24
						elseif nNum==2 then
							size = 20
						else
							size = 18
							curX = -10
						end
						tempH = tempH + 1
						tempY = tempY - _textInfoOffY
						_ItemchildUI["itmeskill_require_"..i.."_"..n] = hUI.label:new({
							parent = _parent.handle._n,
							size = size,
							align = "LT",
							font = hVar.FONTC,
							border = 1,
							x = 10-(i-1)*(offx or _offX)+curX,
							y = tempY,
							width = 320,
							text = temptext,
							RGB = {100,200,255},
						})
						RemoveList[#RemoveList+1] = "itmeskill_require_"..i.."_"..n
					end
					--显示物品技能
					if hVar.tab_stringS[skillid] and hVar.tab_stringS[skillid][2] then
						temptext = hVar.tab_stringS[skillid][2]
					else
						temptext = hVar.tab_string["__TEXT_noUnderstand"]
					end
					
					tempH = tempH+1
					tempY = tempY - _textInfoOffY
					_ItemchildUI["itmeskill_info_"..i.."_"..n] = hUI.label:new({
						parent = _parent.handle._n,
						size = 22,
						align = "LT",
						font = hVar.FONTC,
						x = 10-(i-1)*(offx or _offX),
						y = tempY,
						border = 1,
						width = 330,
						text = temptext,
						RGB = {100,200,255},
					})
					RemoveList[#RemoveList+1] = "itmeskill_info_"..i.."_"..n
					
					_,lh = _ItemchildUI["itmeskill_info_"..i.."_"..n]:getWH()
					lh = lh -_textInfoOffY
				end
			end
			
			--道具说明
			if hVar.tab_stringI[oItemID] and hVar.tab_stringI[oItemID][3] then
				temptext = hVar.tab_stringI[oItemID][3]
			else
				temptext = hVar.tab_string["__TEXT_noAppraise"]
			end
			
			if hVar.tab_item[oItemID].type > hVar.ITEM_TYPE.NONE and hVar.tab_item[oItemID].type < hVar.ITEM_TYPE.HEROCARD then
				tempY = tempY-_textInfoOffY
			else
				tempY = tempY-120
			end
			
			--针对月饼、献祭之石特殊处理
			if (nRequireLv >= 99) then
				tempY = tempY+_textInfoOffY-120
			end
			
			_ItemchildUI["itmehint_"..i]:setText(temptext)
			_ItemchildUI["itmehint_"..i].handle._n:setPosition(10-(i-1)*(offx or _offX), tempY - lh)
			_ItemchildUI["itmehint_"..i].handle._n:setVisible(true)
			
			local _,fuckH2 = _ItemchildUI["itmehint_"..i]:getWH()
			tempY = tempY - fuckH2
			
			--只能在关卡中使用的道具的特殊说明提示
			if (mapBagMode == 1) and (g_current_scene == g_world) then
				local gold = hVar.ITEMLEVEL[itemLv].MAPGOLD
				_ItemchildUI["itmehintEx_"..i]:setText(hVar.tab_string["__TEXT_UserdInCruMap"].." "..gold.." "..hVar.tab_string["__Resource_Hint_Gold"])
				_ItemchildUI["itmehintEx_"..i].handle._n:setPosition(10-(i-1)*(offx or _offX),tempY - lh)
				_ItemchildUI["itmehintEx_"..i].handle._n:setVisible(true)
			else
				_ItemchildUI["itmehintEx_"..i]:setText("")
				_ItemchildUI["itmehintEx_"..i].handle._n:setPosition(10-(i-1)*(offx or _offX),tempY - lh)
				_ItemchildUI["itmehintEx_"..i].handle._n:setVisible(false)
			end
			
			local _, fuckExH2 = _ItemchildUI["itmehintEx_"..i]:getWH()
			tempY = tempY - fuckExH2
			
			--背包或装备的第一件道具显示合成、洗炼功能
			if (hVar.IS_IN_GUIDE_STATE ~= 1) then --geyachao: 在引导中，不能显示合成和洗炼按钮
				if (szOpType == "equipage") or (szOpType == "playerbag") or (szOpType == "gamebag") then
					if (i == 1) then
						--找到道具所在的索引位置
						local itemIdx = 0
						
						if (szOpType == "equipage") then --在人身上的装备
							for it = 1, hVar.HERO_EQUIP_SIZE, 1 do
								--print(it, oHero.data.equipment[it])
								if (oHero.data.equipment[it]) and (oHero.data.equipment[it] ~= 0) then
									if (oHero.data.equipment[it][1] == itenIDlist[i][1]) then
										itemIdx = it
										break
									end
								end
							end
						elseif (szOpType == "playerbag") then --背包的道具
							local BAG_PGAE_NUM = hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()] --玩家当前的背包页数
							local MAXNUM = BAG_PGAE_NUM * 4 * 7
							for it = 1, MAXNUM, 1 do
								if (Save_PlayerData.bag[it] == itenIDlist[i]) then
									itemIdx = it
									break
								end
							end
						elseif (szOpType == "gamebag") then --游戏里的道具
							local equipment = oHero.data.equipment
							for it = 1, 6, 1 do
								if (type(equipment[it]) == "table") then
									--print("it="..it, equipment[it][1], itenIDlist[i][1])
									if (equipment[it][1] == itenIDlist[i][1]) then
										itemIdx = it
										break
									end
								end
							end
						end
						--print("itemIdx=", itemIdx)
						
						--找到该装备
						local oItem = nil
						if (szOpType == "equipage") then --人身上的装备
							--删除英雄装备存档
							local saveHeroData = hApi.GetHeroCardById(oHero.data.id)
							--saveHeroData.equipment[itemIdx] = 0
							oItem = saveHeroData.equipment[itemIdx]
						elseif (szOpType == "playerbag") then --背包的道具
							--删除背包道具存档
							--Save_PlayerData.bag[itemIdx] = 0
							oItem = Save_PlayerData.bag[itemIdx]
						elseif (szOpType == "gamebag") then --游戏里的道具
							oItem = oHero.data.equipment[itemIdx]
						end
						
						--如果该装备是橙装、红装，那么不能合成
						--检查主合成道具是否为装备
						local itemIdMain =  oItem[1] --主合成道具id
						local itemLvMain = hVar.tab_item[itemIdMain].itemLv or 1 --道具等级
						
						--绘制合成和洗炼的按钮
						local btnWidth = 124
						local btnHeight = 50
						--local _, fuckExH2 = _ItemchildUI["itmehintEx_"..i]:getWH()
						tempH = tempH+1
						tempY = tempY - _textInfoOffY - 15
						
						local sellOffX = 80 --洗炼的偏移值x
						_ItemchildUI["ItemMergeBtn" .. i] = hUI.button:new({
							parent = _parent.handle._n,
							dragbox = _parent.childUI["dragBox"],
							x = -(i-1)*(offx or _offX) + sellOffX,
							y = tempY - btnHeight - lh + 63 - 5,
							w = btnWidth,
							h = btnHeight,
							size = 28,
							--label = "合成", --language
							label = {text = hVar.tab_string["__ITEM_PANEL__PAGE_MERGE"], font = hVar.FONTC, x = 0, y = -2, border = 1, size = 28, align = "MC"}, --language
							font = hVar.FONTC,
							border = 1,
							model = "UI:BTN_ButtonRed",
							animation = "normal",
							scaleT = 0.95,
							scale = 1.0,
							code = function()
								if (szOpType == "gamebag") then --游戏里的道具
									--发送指令，出售道具
									local oUnit = oHero:getunit()
									if oUnit then
										hApi.AddCommand(hVar.Operation.SellItemEquipment, oUnit:getworldI(), oUnit:getworldC(), itemIdx)
									end
									
									return
								end
								
								--合成道具逻辑
								--未联网不能合成道具
								if (g_cur_net_state == -1) then
									--local strText = "必须联网才能合成道具" --language
									local strText = hVar.tab_string["__TEXT_Cant_MergeItem_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--该道具不是装备
								if (not hApi.CheckItemIsEquip(itemIdMain)) then
									--弹框
									--local strText = "只有装备才能进行合成" --language
									local strText = hVar.tab_string["__TEXT_Cant_MergeItem2_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--检查主合成道具的品质是否可以合成（除了橙装、神器可以合成）
								if (not hVar.ITEM_MERGE_LIMIT[itemLvMain]) and (itemLvMain ~= hVar.ITEM_QUALITY.RED) and (hVar.tab_item[oItemID].isArtifact ~= 1) then
									--弹框
									--local strText = "红装、橙装不能进行合成" --language
									local strText = hVar.tab_string["__TEXT_Cant_MergeItem3_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--主合成道具不能是合成材料(普通装备的合成)
								local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
								if (nRequireLv >= 99) and (hVar.tab_item[oItemID].isArtifact ~= 1) then
									--弹框
									--local strText = "合成材料不能用于主合成道具" --language
									local strText = hVar.tab_string["__TEXT_Cant_MergeItem4_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--未知错误
								if (itemIdx <= 0) then
									--弹框
									hGlobal.UI.MsgBox("未知错误", {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--如果该装备是英雄身上的，要进行合成，必须先脱下来，放到背包
								local bIsEquip = false --是否是装备
								if (szOpType == "equipage") then --人身上的装备
									--是装备
									bIsEquip = true
									
									--找出第一个背包的空位置
									local emptyBagIdx = 0 --空背包位置
									
									--玩家当前的背包页数
									local BAG_PGAE_NUM = hVar.VIP_BAG_LEN[LuaGetPlayerVipLv()] --玩家当前的背包页数
									local bagItemCount = hVar.PLAYERBAG_X_NUM * hVar.PLAYERBAG_Y_NUM * BAG_PGAE_NUM --背包道具总数量
									for i = 1, bagItemCount, 1 do
										if (Save_PlayerData.bag[i] == 0) then
											emptyBagIdx = i --找到了
											break
										end
									end
									
									--身上所有的背包都满了
									if (emptyBagIdx == 0) then
									--local strText = "背包已满，装备无法放到背包中" --language
									local strText = hVar.tab_string["__TEXT_Cant_BagItemIsFull_Net"] --language
										hGlobal.UI.MsgBox(strText, {
											font = hVar.FONTC,
											ok = function()
											end,
										})
										
										return
									end
									
									--将角色身上的装备脱下来，放到背包中
									local saveHeroData = hApi.GetHeroCardById(oHero.data.id)
									saveHeroData.equipment[itemIdx] = 0
									Save_PlayerData.bag[emptyBagIdx] = oItem
									--存档
									LuaSaveHeroCard() --存档英雄
									LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
									
									--标记装备脱下来之后的索引位置
									itemIdx = emptyBagIdx
									
									--重刷界面
									oHero:load(oHero.data.id, 1)
								end
								
								--弹出合成界面
								--计算应该切换到哪个分页
								local BAG_PGAE_NUM = hVar.VIP_BAG_LEN[LuaGetPlayerVipLv()] --玩家当前的背包页数
								local pageElements = hVar.PLAYERBAG_X_NUM * hVar.PLAYERBAG_Y_NUM --背包一页的数量
								local modV = itemIdx % pageElements
								if (modV == 0) then
									modV = pageElements
								end
								local pageIdx = (itemIdx - modV) / pageElements + 1
								hApi.ShowHeroBagIdx(pageIdx)
								--print(pageIdx)
								--开启道具分页界面
								if (hVar.tab_item[oItemID].isArtifact == 1) then --红装
									hGlobal.event:event("localEvent_ShowPhone_ItemFrame_RedEquip", 2, oHero, pageIdx, itemIdx, bIsEquip) --指定只显示第2个分页（合成）
								elseif (hVar.tab_item[oItemID].itemLv == hVar.ITEM_QUALITY.RED) then --橙装
									hGlobal.event:event("localEvent_ShowPhone_ItemFrame_OrangeEquip", 2, oHero, pageIdx, itemIdx, bIsEquip) --指定只显示第2个分页（合成）
								else
									hGlobal.event:event("localEvent_ShowPhone_ItemFrame", 2, oHero, pageIdx, itemIdx, bIsEquip) --指定只显示第2个分页（合成）
								end
								--[[
								--统计出售的总积分获得
								local sellJiFen = itemLv * 10
								
								--弹框，告知是否要出售
								local MsgSelections = nil
								MsgSelections = {
									style = "mini",
									select = 0,
									
									--确认出售的流程
									ok = function()
										--删除该道具
										if (szOpType == "equipage") then --人身上的装备
											--删除英雄装备存档
											local saveHeroData = hApi.GetHeroCardById(oHero.data.id)
											saveHeroData.equipment[itemIdx] = 0
										elseif (szOpType == "playerbag") then --背包的道具
											--删除背包道具存档
											Save_PlayerData.bag[itemIdx] = 0
										end
										
										--获得出售的积分
										LuaAddPlayerScore(sellJiFen)
										
										--存储存档
										--保存存档
										if (szOpType == "equipage") then
											LuaSaveHeroCard()
										end
										LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
										
										--播放出售音效
										hApi.PlaySound("pay_gold")
										
										--触发事件：出售道具
										hGlobal.event:event("Local_Event_ItemSell_Result")
										
										--更新界面
										oHero:load(oHero.data.id, 1)
									end,
									cancel = function()
										--print("cancel")
									end,
									--cancelFun = cancelCallback, --点否的回调函数
									--textOk = "跳过引导",
									textCancel = hVar.tab_string["__TEXT_Cancel"],
									userflag = 0, --用户的标记
								}
								local itemName = hVar.tab_stringI[oItemID] and hVar.tab_stringI[oItemID][1] or ("未知道具" .. oItemID)
								local showTitle = "出售：" .. itemName .. "\n获得积分：" .. sellJiFen
								local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
								end,
								]]
							end,
						})
						RemoveList[#RemoveList+1] = "ItemMergeBtn" .. i
						
						--以下情况装备的合成按钮要灰掉
						--该道具不是装备
						if (not hApi.CheckItemIsEquip(itemIdMain)) then
							hApi.AddShader(_ItemchildUI["ItemMergeBtn" .. i].handle.s, "gray") --灰掉
						end
						--检查主合成道具的品质是否可以合成(橙装可以合成)
						if (not hVar.ITEM_MERGE_LIMIT[itemLvMain]) and (itemLvMain ~= hVar.ITEM_QUALITY.RED) then
							hApi.AddShader(_ItemchildUI["ItemMergeBtn" .. i].handle.s, "gray") --灰掉
						end
						--合成材料不能洗炼
						local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
						if (nRequireLv >= 99) then
							hApi.AddShader(_ItemchildUI["ItemMergeBtn" .. i].handle.s, "gray") --灰掉
						end
						
						--如果是神器，可以合成，改文字
						if (hVar.tab_item[oItemID].isArtifact == 1) then
							hApi.AddShader(_ItemchildUI["ItemMergeBtn" .. i].handle.s, "normal") --正常
							--_ItemchildUI["ItemMergeBtn" .. i].childUI["label"]:setText("祭坛") --language
							_ItemchildUI["ItemMergeBtn" .. i].childUI["label"]:setText(hVar.tab_string["__TEXT_Wishing"]) --language
						end
						
						if (szOpType == "gamebag") then --游戏里的道具
							hApi.AddShader(_ItemchildUI["ItemMergeBtn" .. i].handle.s, "normal") --正常
							--_ItemchildUI["ItemMergeBtn" .. i].childUI["label"]:setText("回收") --language
							_ItemchildUI["ItemMergeBtn" .. i].childUI["label"]:setText(hVar.tab_string["__ITEM_PANEL__PAGE_RESELL"]) --language
						end
						
						--洗炼
						_ItemchildUI["ItemXiLianBtn" .. i] = hUI.button:new({
							parent = _parent.handle._n,
							dragbox = _parent.childUI["dragBox"],
							x = -(i-1)*(offx or _offX) + sellOffX + 160,
							y = tempY - btnHeight - lh + 63 - 5,
							w = btnWidth,
							h = btnHeight,
							size = 28,
							--label = "洗炼", --language
							label = {text = hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"], font = hVar.FONTC, x = 0, y = -2, border = 1, size = 28, align = "MC"}, --language
							font = hVar.FONTC,
							border = 1,
							model = "UI:BTN_ButtonRed",
							animation = "normal",
							scaleT = 0.95,
							scale = 1.0,
							code = function()
								if (szOpType == "gamebag") then --游戏里的道具
									--发送指令，打孔道具
									local oUnit = oHero:getunit()
									if oUnit then
										hApi.AddCommand(hVar.Operation.SlotItemEquipment, oUnit:getworldI(), oUnit:getworldC(), itemIdx)
									end
									
									return
								end
								
								--洗炼道具逻辑
								--未联网不能洗炼道具
								if (g_cur_net_state == -1) then
									--local strText = "必须联网才能洗炼道具" --language
									local strText = hVar.tab_string["__TEXT_Cant_XiLianItem_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--该道具不是装备
								if (not hApi.CheckItemIsEquip(itemIdMain)) then
									--弹框
									--local strText = "只有装备才能进行洗炼" --language
									local strText = hVar.tab_string["__TEXT_Cant_XiLianItem2_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--白装不能洗炼
								if(hVar.ITEM_ATTR_EX_LIMIT[itemLv] <= 0) then
									--弹框
									--local strText = "白装不能洗炼" --language
									local strText = hVar.tab_string["__TEXT_Cant_XiLianItem3_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--合成材料不能洗炼
								local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
								if (nRequireLv >= 99) then
									--弹框
									--local strText = "合成材料不能用于洗炼" --language
									local strText = hVar.tab_string["__TEXT_Cant_XiLianItem4_Net"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--未知错误
								if (itemIdx <= 0) then
									--弹框
									hGlobal.UI.MsgBox("未知错误", {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									
									return
								end
								
								--创建洗炼道具简易界面
								--打开洗炼迷你面板
								if (szOpType == "equipage") then --在人身上的装备
									if (hVar.tab_item[oItemID].isArtifact == 1) then --神器
										hGlobal.event:event("localEvent_ShowPhone_ItemMini_XiLian_RedEquip", oHero, itemIdx)
									else
										hGlobal.event:event("localEvent_ShowPhone_ItemMini", oHero, itemIdx)
									end
								elseif (szOpType == "playerbag") then --背包的道具
									if (hVar.tab_item[oItemID].isArtifact == 1) then --神器
										hGlobal.event:event("localEvent_ShowPhone_ItemMini_XiLian_RedEquip", 0, itemIdx)
									else
										hGlobal.event:event("localEvent_ShowPhone_ItemMini", 0, itemIdx)
									end
								end
							end,
						})
						RemoveList[#RemoveList+1] = "ItemXiLianBtn" .. i
						--以下情况装备的洗炼按钮要灰掉
						--该道具不是装备
						if (not hApi.CheckItemIsEquip(itemIdMain)) then
							hApi.AddShader(_ItemchildUI["ItemXiLianBtn" .. i].handle.s, "gray") --灰掉
						end
						--白装不能洗炼
						if(hVar.ITEM_ATTR_EX_LIMIT[itemLv] <= 0) then
							hApi.AddShader(_ItemchildUI["ItemXiLianBtn" .. i].handle.s, "gray") --灰掉
						end
						--合成材料不能洗炼
						local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
						if (nRequireLv >= 99) then
							hApi.AddShader(_ItemchildUI["ItemXiLianBtn" .. i].handle.s, "gray") --灰掉
						end
						
						--[[
						if (szOpType == "gamebag") then --游戏里的道具
							--hApi.AddShader(_ItemchildUI["ItemXiLianBtn" .. i].handle.s, "normal") --正常
							--_ItemchildUI["ItemXiLianBtn" .. i].childUI["label"]:setText("打孔") --language
							_ItemchildUI["ItemXiLianBtn" .. i].childUI["label"]:setText(hVar.tab_string["__TEXT__AddSlot"]) --language
						end
						]]
					end
				end
			end
			
			--获取方式
			--不是身上的装备（没有孔）的tip
			local lh222 = 0
			if (szOpType ~= "equipage") and (szOpType ~= "playerbag") and (szOpType ~= "gamebag") then
				if (upCount == 0) or (rewardEx[1] == "unknwon") then
					--道具说明
					if hVar.tab_stringI[oItemID] and hVar.tab_stringI[oItemID][4] then
						--显示获取途径
						tempH = tempH + 1
						tempY = tempY - _textInfoOffY - _textInfoOffY
						
						_ItemchildUI["itemgetmethod_" .. i] = hUI.label:new({
							parent = _parent.handle._n,
							size = 22,
							align = "LT",
							font = hVar.FONTC,
							x = 10-(i-1)*(offx or _offX),
							y = tempY,
							border = 1,
							width = 330,
							text = hVar.tab_stringI[oItemID][4],
							RGB = {255, 168,0},
						})
						RemoveList[#RemoveList+1] = "itemgetmethod_" .. i
						
						_, lh222 = _ItemchildUI["itemgetmethod_" .. i]:getWH()
						lh222 = lh222 -_textInfoOffY
						--tempY = tempY - lh222
						
						_ItemchildUI["itemgetmethod_"..i].handle._n:setPosition(10-(i-1)*(offx or _offX), tempY - lh + lh222)
					end
				end
			end
			
			--最后的包围框
			--local _,fuckExH2 = _ItemchildUI["itmehintEx_"..i]:getWH()
			fuckH = -(tempY - lh - lh222) + _textInfoOffY
			local bw = _parent.data.w + 14
			local bx = 0-(i-1)*(offx or _offX) + (bw) / 2
			local bOpacity = 204
			if (bw < 100) then --宽度太小，说明原面板不规则
				bw = 356
				bx = 0-(i-1)*(offx or _offX) + (bw) / 2 - 10
				bOpacity = 168
			end
			_ItemchildUI["barFuck" .. i] = hUI.button:new({
				parent = _parent.handle._n,
				model = "misc/mask.png", --"UI:tip_item",
				--align = "LT",
				w = bw,
				h = fuckH,
				x = bx,
				y = -fuckH / 2,
				z = -1,
			})
			_ItemchildUI["barFuck" .. i].handle.s:setOpacity(0) --只用作父控件，不显示
			RemoveList[#RemoveList+1] = "barFuck" .. i
			--九宫格
			local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, bw, fuckH, _ItemchildUI["barFuck" .. i])
			img9:setOpacity(bOpacity) --道具tip背景图片透明度为204
		end
		if fram then
			for i = 1,hVar.HERO_EQUIP_SIZE do
				if i == hApi.GetHeroEquipmentIndexType(hVar.tab_item[itenIDlist[1][1]].type) then
					local _HeroOffX = 30
					local _HeroOffY = -100
					if (g_phone_mode == 1) then --iPhone4
						_HeroOffX = 10
						_HeroOffY = -35
					elseif (g_phone_mode == 2) then --iPhone5
						_HeroOffX = 90
						_HeroOffY = -35
					elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
						_HeroOffX = 120
						_HeroOffY = -60
					elseif (g_phone_mode == 4) then --iPhoneX
						_HeroOffX = iPhoneX_WIDTH + 120
						_HeroOffY = -60
					elseif (g_phone_mode == 5) then --安卓宽屏
						_HeroOffX = 120
						_HeroOffY = -60
					elseif (g_phone_mode == 6) then --平板宽屏
						_HeroOffX = 30
						_HeroOffY = -100
					end
					--装备类型提示框
					_ItemchildUI["SelectBorder"..i] = hUI.image:new({
						parent = fram.handle._n,
						model = "UI:Button_SelectBorder",
						align = "MC",
						w = 72,
						h = 72,
						x = _HeroOffX + hVar.NEW_EQUIPAGE_POS[1][i][1],
						y = _HeroOffY + hVar.NEW_EQUIPAGE_POS[1][i][2],
					})
					
					RemoveList_1[#RemoveList_1+1] = "SelectBorder"..i
				end
			end
		end
	end
	
	--切地图隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideItemTipFrm",function(sSceneType,oWorld,oMap)
		UnitItemInfoFram:show(0)
	end)
	
	--[[
	--点击UI时隐藏
	hGlobal.event:listen("LocalEvent_UITouchBegin","__UI__HideItemTipFrm",function()
		if UnitItemInfoFram.data.show~=0 then
			UnitItemInfoFram:show(0)
			
			for i = 1,#RemoveList_1 do
				hApi.safeRemoveT(_ItemchildUI,RemoveList_1[i])
			end
			RemoveList_1 = {}
			
			for i = 1,#RemoveList do
				hApi.safeRemoveT(_ItemchildUI,RemoveList[i])
			end
			RemoveList = {}
		end
	end)
	]]
	
	--事件：显示道具tip
	hGlobal.event:listen("LocalEvent_ShowItemTipFram", "_ItemTipFram", function(itemIDlist, fram, isshow, x, y, offx, mapBagMode, szOpType, oHero, parent)
		--print("事件：显示道具tip", itemIDlist,fram,isshow,x,y,offx,mapBagMode)
		--if (itemIDlist) then
		--	print("#itemIDlist=", #itemIDlist)
		--	print("itemIDlist:", itemIDlist[1][1], itemIDlist[1][2], itemIDlist[1][3],itemIDlist[1][4])
		--end
		
		--geyachao: 支持可以从外部传入父控件，将道具tip绘制在别的界面上
		local _parent = hGlobal.UI.ItemInfoFram
		local _ItemchildUI = UnitItemInfoFram.childUI
		if parent then
			_parent = parent
			_ItemchildUI = parent.childUI
		end
		
		--如果自己已经是隐藏的，那么不管他
		if isshow==0 and _parent.data.show==0 then
			--print("如果自己已经是隐藏的，那么不管他")
			return
		end
		for i = 1, #RemoveList_1, 1 do
			hApi.safeRemoveT(UnitItemInfoFram.childUI, RemoveList_1[i]) --也删除通用tip的数据
			hApi.safeRemoveT(_ItemchildUI, RemoveList_1[i])
		end
		--_ItemchildUI["itmeyzb"].handle._n:setVisible(false)
		RemoveList_1 = {}
		for i = 1, 2, 1 do
			_ItemchildUI["ItemBan_"..i].handle._n:setVisible(false)
			_ItemchildUI["ItemBG_"..i].handle._n:setVisible(false)
			_ItemchildUI["itmeName_"..i].handle._n:setVisible(false)
			_ItemchildUI["itmetype_"..i].handle._n:setVisible(false)
			_ItemchildUI["itmehint_"..i].handle._n:setVisible(false)
			_ItemchildUI["itmehintEx_"..i].handle._n:setVisible(false)
		end
		
		--参数合法性检测
		local result = 0
		if itemIDlist ~= nil and type(itemIDlist) == "table" then
			for i = 1,#itemIDlist do
				if hVar.tab_item[itemIDlist[i][1]] == nil then
					result = 1
				end
			end
		else
			result = 1
		end
		
		if result == 0 then
			_createItemInfoFram(itemIDlist, fram, offx, mapBagMode, szOpType, oHero, parent)
			--将一些需要offx 的控件按照原来的位置摆放
			_ItemchildUI["ItemBan_2"].handle._n:setPosition(44 + 4 -(offx or _offX), -50)
			_ItemchildUI["ItemBG_2"].handle._n:setPosition(44 + 4 -(offx or _offX), -50)
			_ItemchildUI["itmeName_2"].handle._n:setPosition((80 + 20 -(offx or _offX)), -20 + 4)
			--_ItemchildUI["itmeyzb"].handle._n:setPosition((80-(offx or _offX)),-50)
			_ItemchildUI["itmetype_2"].handle._n:setPosition((80 + 20 -(offx or _offX)), -65 + 4)
		end
		if x and y then
			--if g_phone_mode ~= 0 then
				_parent:setXY(x,y-20)
			--else
				--_parent:setXY(x,y)
			--end
		else
			--if g_phone_mode ~= 0 then
				local posX = 670
				local posY = 720
				if (g_phone_mode == 1) then --iPhone4
					posX = 610
					posY = 640
				elseif (g_phone_mode == 2) then --iPhone5
					posX = 720
					posY = 640
				elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
					posX = 860
					posY = 690
				elseif (g_phone_mode == 4) then --iPhoneX
					posX = 990
					posY = 690
				elseif (g_phone_mode == 5) then --安卓宽屏
					posX = 920
					posY = 690
				elseif (g_phone_mode == 6) then --平板宽屏
					posX = 670+54
					posY = 720
				end
				_parent:setXY(posX, posY)
			--else
				--_parent:setXY(730,660)
			--end
		end
		if _parent.show then
			_parent:show(isshow)
		end
		if isshow == 1 then
			if _parent.active then
				_parent:active()
			end
		end
	end)
	
	--[[
	--道具图片背景框
	itemInfoFrm.childUI["itemInfoFrmBG"] = hUI.image:new({
		parent = itemInfoFrm.handle._n,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 68,
		h = 68,
		x = 95,
		y = -80,
	})
	
	--道具名字
	itemInfoFrm.childUI["itemInfoFrm_Name"] = hUI.label:new({
		parent = itemInfoFrm.handle._n,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		x = itemInfoFrm.data.w/2,
		y = -80,
		width = 160,
		text = "",
		border = 1,
	})
	
	--道具的简单信息
	itemInfoFrm.childUI["itemInfoFrm_info"] = hUI.label:new({
		parent = itemInfoFrm.handle._n,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 60,
		y = -160,
		width = 380,
		text = "",
		border = 1,
	})
	
	--打开后显示内容
	hGlobal.event:listen("LocalEvent_ShowItemInfoFrm","_ItemTipFram",function(itemID)
		if itemID then
			hApi.safeRemoveT(itemInfoFrm.childUI,"itemInfoFrmImage")
			itemInfoFrm.childUI["itemInfoFrmImage"] = hUI.image:new({
				parent = itemInfoFrm.handle._n,
				model = hVar.tab_item[itemID].icon,
				w = 64,
				h = 64,
				x = 95,
				y = -80,
			})
			
			itemInfoFrm.childUI["itemInfoFrm_Name"]:setText(hVar.tab_stringI[itemID][1])
			itemInfoFrm.childUI["itemInfoFrm_info"]:setText(hVar.tab_stringI[itemID][3])
			
			itemInfoFrm:show(1,"appear")
			itemInfoFrm:active()
		else
			itemInfoFrm:show(0)
		end
	end)
	]]
end
--[[
--测试 --test
if hGlobal.UI.ItemInfoFram then
	hGlobal.UI.ItemInfoFram:del()
	hGlobal.UI.ItemInfoFram = nil
end
if hGlobal.UI.ItemInfoFram2 then
	hGlobal.UI.ItemInfoFram2:del()
	hGlobal.UI.ItemInfoFram2 = nil
end
hGlobal.UI.InitItemInfoFram() --创建道具说明面板
--显示道具tip
local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
local itemtipY = 700 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
hGlobal.event:event("LocalEvent_ShowItemTipFram", {{12404, 1}}, nil, 1, itemtipX, itemtipY, 0)
]]

