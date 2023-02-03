



------------
--查看所有的道具
------------
hGlobal.UI.InitPlayerGiftBagFrm_test = function(mode)
	local tInitEventName = {"localEvent_ShowPlayerGiftBagFrm_test","showthisFrm_test"}
	if mode~="include" then
		return tInitEventName
	end
	local _x,_y,_w,_h = hVar.SCREEN.w/2 - 460,hVar.SCREEN.h/2 + 300,920,600
	local _pageIdx = 1 --当前页码
	local PAGE_NUM = 45
	local PAGE_X_NUM = 9 --一行数量
	local _cur_index = 0
	local _tBagList = {} --列表
	hGlobal.UI.PlayerGiftBagFrm_test = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 2,
		w = _w,
		h = _h,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = 1,
		autoactive = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w-10,
		closebtnY = -14,
		codeOnClose = function()
			--每次关闭时都要检测一次是否还继续显示
			hGlobal.event:event("LocalEvent_setGiftBtnState",-1)
		end
	})
	
	local _frm = hGlobal.UI.PlayerGiftBagFrm_test
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--提示文字title
	_childUI["tipLab"] =  hUI.label:new({
		parent = _parent,
		x = _w/2,
		y = -50,
		text = hVar.tab_string["__TEXT_PleaseChoose"],
		size = 30,
		width = _w-64,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	--面板的结束方法
	local _RemoveList = {}
	local _btnState = {}
	local _exitFunc = function()
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		
		--初始化按钮状态
		for i = 1,#_btnState do 
			_btnState[i] = 0
		end
	end
	
	--确定按钮
	_childUI["confirmBtn"] =  hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		--model = "UI:ConfimBtn1",
		label = hVar.tab_string["__Get__"],
		x = _frm.data.w/2,
		y = -_frm.data.h + 30,
		scaleT = 0.9,
		code = function()
			_frm:show(0)
			_exitFunc()
			
			local oItem = _tBagList[_cur_index]
			if oItem then
				local itemId = oItem[1]
				if itemId then
					LuaAddItemToPlayerBag(itemId,nil,nil,0)
					
					--冒字
					local strText = "获得道具: " .. hVar.tab_stringI[itemId][1]
					local itemLv = hVar.tab_item[itemId].itemLv
					local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
					local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
					local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
					local ctrl = hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "sss",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
						RBG = {r, g, b,},
					})
					ctrl:addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
					
					--ctrl.handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
				end
			end
		end,
	})
	
	local _itemX,_itemY,_itemOffX,itemOffY,_itemW = 60,-120,100,90,60
	--选中框
	_childUI["giftSelectBox"] = hUI.image:new({
		parent = _parent,
		model = "UI:skillup",
		w = _itemW+20,
		h = _itemW+20,
		z = 10,
	})
	_childUI["giftSelectBox"].handle._n:setVisible(false)
	
	--创建45个道具槽子
	for i = 1, PAGE_NUM, 1 do
		_btnState[i] = 0
		_childUI["giftItem_bg_"..i] = hUI.button:new({
			parent = _parent,
			model = "UI_frm:slot",
			animation = "lightSlim",
			dragbox = _childUI["dragBox"],
			x = _itemX + (i-1)%PAGE_X_NUM*_itemOffX,
			y = _itemY - math.ceil((i-PAGE_X_NUM)/PAGE_X_NUM)*itemOffY,
			w = _itemW,
			h = _itemW,
			code = function(self)
				_cur_index = (_pageIdx - 1) * PAGE_NUM + i
				
				if _btnState[_cur_index] == 1 then
					local oItem = _tBagList[_cur_index]
					
					if (type(oItem) == "table") and (oItem[1]) then
						local tempX = 0
						--在左边显示
						if math.ceil(i/4) % 2 == 0 then
							tempX = 110
						--在右边显示
						elseif math.ceil(i/4) % 2 == 1 then
							tempX = 640
						end
						
						hGlobal.event:event("LocalEvent_ShowItemTipFram",{oItem},nil,1,tempX,_y)
					end
					
					_childUI["giftSelectBox"].handle._n:setPosition(self.data.x,self.data.y)
					_childUI["giftSelectBox"].handle._n:setVisible(true)
					_childUI["confirmBtn"]:setstate(1)
				end
			end,
		})
	end
	
	------------------------章节-----------------------------
	local CDX = 160
	local CDY = -560
	
	--章节翻页的底纹图
	_childUI["imgChapterBG"] = hUI.button:new({ --作为button是为了挡操作
		parent = _frm,
		model = "ui/TacticBG.png", --"UI:ItemSlot", --"UI:login_lk", --"UI:MedalDarkImg",
		x = 520 + CDX,
		y = CDY,
		w = 176,
		h = 56,
		scaleT = 1.0,
		code = function(self)
			--...
		end,
	})
	_childUI["imgChapterBG"].handle.s:setOpacity(128)
	
	--向左翻页的章节按钮控件（只用于控制，不显示）
	_childUI["btnChapter_L"] = hUI.button:new({
		parent = _frm,
		model = "misc/mask.png",
		x = 440 + CDX,
		y = CDY,
		w = 90,
		h = 64,
		scaleT = 0.95,
		code = function(self)
			--检测上一页是否有道具 
			if (_pageIdx <= 1) then
				return
			end
			
			--可以翻页
			_pageIdx = _pageIdx - 1
			
			--到上一页
			hGlobal.event:event("localEvent_ShowPlayerGiftBagFrm_test", _tBagList)
		end,
	})
	_childUI["btnChapter_L"].handle.s:setOpacity(0) --只作为控制用，不用于显示
	--章节翻页图片左
	_childUI["btnChapter_L"].childUI["icon"] = hUI.image:new({
		parent = _childUI["btnChapter_L"].handle._n,
		model = "UI:button_return", --"UI:PageBtn",
		x = 0,
		y = 0,
		scale = 1.05,
	})
	--_childUI["btnChapter_L"].childUI["icon"].handle._n:setRotation(90)
	local scaleBig = CCMoveTo:create(0.8, ccp(-3, 0))
	local scaleSmall = CCMoveTo:create(0.8, ccp(0, 0))
	local actSeq = CCSequence:createWithTwoActions(scaleBig, scaleSmall)
	_childUI["btnChapter_L"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
	--章节翻页图片左（灰色）
	_childUI["btnChapter_L"].childUI["iconGray"] = hUI.image:new({
		parent = _childUI["btnChapter_L"].handle._n,
		model = "UI:button_return", --"UI:PageBtn",
		x = 0,
		y = 0,
		scale = 1.05,
	})
	--hApi.AddShader(_childUI["btnChapter_L"].childUI["iconGray"].handle.s, "gray")
	_childUI["btnChapter_L"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
	_childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
	
	--向右翻页的章节按钮控件（只用于控制，不显示）
	_childUI["btnChapter_R"] = hUI.button:new({
		parent = _frm,
		model = "misc/mask.png",
		x = 600 + CDX,
		y = CDY,
		w = 90,
		h = 64,
		scaleT = 0.95,
		code = function(self)
			--检测下一页是否有道具
			local bagNum = #_tBagList
			local beginIdx = ((_pageIdx + 1) - 1) * PAGE_NUM + 1 
			if (beginIdx > bagNum) then
				return
			end
			
			--可以翻页
			_pageIdx = _pageIdx + 1
			
			--到下一页
			hGlobal.event:event("localEvent_ShowPlayerGiftBagFrm_test", _tBagList)
		end,
	})
	_childUI["btnChapter_R"].handle.s:setOpacity(0) --只作为控制用，不用于显示
	--章节翻页图片右
	_childUI["btnChapter_R"].childUI["icon"] = hUI.image:new({
		parent = _childUI["btnChapter_R"].handle._n,
		model = "UI:button_return", --"UI:PageBtn",
		x = 0,
		y = 0,
		scale = 1.05,
	})
	_childUI["btnChapter_R"].childUI["icon"].handle._n:setRotation(180)
	local scaleBig = CCMoveTo:create(0.8, ccp(3, 0))
	local scaleSmall = CCMoveTo:create(0.8, ccp(0, 0))
	local actSeq = CCSequence:createWithTwoActions(scaleBig, scaleSmall)
	_childUI["btnChapter_R"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
	--章节翻页图片右（灰色）
	_childUI["btnChapter_R"].childUI["iconGray"] = hUI.image:new({
		parent = _childUI["btnChapter_R"].handle._n,
		model = "UI:button_return", --"UI:PageBtn",
		x = 0,
		y = 0,
		scale = 1.05,
	})
	_childUI["btnChapter_R"].childUI["iconGray"].handle._n:setRotation(180)
	--hApi.AddShader(_childUI["btnChapter_R"].childUI["iconGray"].handle.s, "gray")
	_childUI["btnChapter_R"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
	_childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
	
	--章节名文本
	_childUI["labelChapterName"] =  hUI.label:new({
		parent = _parent,
		x = 520 + CDX,
		y = CDY - 5,
		size = 32,
		width = 500,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
		text = "第?页",
	})
	_childUI["labelChapterName"].handle.s:setColor(ccc3(236, 255, 236))
	
	--根据玩家礼品背包中的道具信息创建 道具图片
	local _createGiftBagInfo = function(itemList)
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		local tempID = 0
		local beginIdx = (_pageIdx - 1) * PAGE_NUM + 1
		for i = beginIdx, beginIdx + PAGE_NUM - 1, 1 do
			local idx = i - beginIdx + 1
			
			if (type(itemList[i]) == "table") and (itemList[i][1]) then
				_btnState[i] = 1
				tempID = itemList[i][1]
				
				if tempID then
					local itemLv = hVar.tab_item[tempID].itemLv or 1
					_childUI["giftItem_image_bg_"..i] = hUI.image:new({
						parent = _parent,
						model = hVar.ITEMLEVEL[itemLv].BORDERMODEL,
						x = _itemX + (idx-1)%PAGE_X_NUM*_itemOffX,
						y = _itemY - math.ceil((idx-PAGE_X_NUM)/PAGE_X_NUM)*itemOffY,
						w = _itemW,
						h = _itemW,
					})
					_RemoveList[#_RemoveList+1] = "giftItem_image_bg_"..i
					_childUI["giftItem_image_bg_"..i].handle.s:setOpacity(155)
					
					_childUI["giftItem_image_"..i] = hUI.image:new({
						parent = _parent,
						model = hVar.tab_item[tempID].icon,
						x = _itemX + (idx-1)%PAGE_X_NUM*_itemOffX,
						y = _itemY - math.ceil((idx-PAGE_X_NUM)/PAGE_X_NUM)*itemOffY,
						w = _itemW,
						h = _itemW,
					})
					_RemoveList[#_RemoveList+1] = "giftItem_image_"..i
					_childUI["giftItem_label_id"..i] = hUI.label:new({
						parent = _parent,
						text = tempID,
						x = _itemX + (idx-1)%PAGE_X_NUM*_itemOffX,
						y = _itemY - math.ceil((idx-PAGE_X_NUM)/PAGE_X_NUM)*itemOffY - 16,
						RGB = hVar.ITEMLEVEL[hVar.tab_item[tempID].itemLv].NAMERGB,--hVar.ITEM_ELITE_LEVEL[hVar.tab_item[tempID].elite].NAMERGB,
						size = 22,
						align = "MC",
						border = 1,
					})
					_RemoveList[#_RemoveList+1] = "giftItem_label_id"..i

				end
			end
		end
		
		--刷新页码
		_childUI["labelChapterName"]:setText("第" .. _pageIdx .. "页")
		
		--刷新按钮
		if (_pageIdx <= 1) then --翻页（左）当前是第一章
			_childUI["btnChapter_L"].childUI["icon"].handle._n:setVisible(false)
			_childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(true)
		else --翻页（左）当前大于第一章
			_childUI["btnChapter_L"].childUI["icon"].handle._n:setVisible(true)
			_childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(false)
		end
		
		if ((((_pageIdx + 1) - 1) * PAGE_NUM + 1) > (#_tBagList)) then
			_childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(false)
			_childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(true)
		else --已通过
			_childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(true)
			_childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(false)
		end
	end
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(giftList)
		_childUI["confirmBtn"]:setstate(0)
		_cur_index = 0
		_tBagList = giftList
		_childUI["giftSelectBox"].handle._n:setVisible(false)
		--创建礼品信息
		_createGiftBagInfo(giftList)
		
		_frm:show(1)
		_frm:active()
	end)
end


local PAGE_NUM = 45
local ttt = {}
local tItem = hVar.tab_item
for i = 11000, 13000, 1 do
	if tItem[i] then
		table.insert(ttt, {i})
	end
end
--排序
table.sort(ttt, function(t1, t2)
	local val1 = 0
	local val2 = 0
	local type1 = tItem[t1[1]].type
	local type2 = tItem[t2[1]].type
	
	--最优先级： 部位
	if (type1 == hVar.ITEM_TYPE.WEAPON) then
		val1 = val1 + 1000000000
	elseif (type1 == hVar.ITEM_TYPE.BODY) then
		val1 = val1 + 2000000000
	elseif (type1 == hVar.ITEM_TYPE.ORNAMENTS) then
		val1 = val1 + 3000000000
	elseif (type1 == hVar.ITEM_TYPE.MOUNT) then
		val1 = val1 + 4000000000
	end
	if (type2 == hVar.ITEM_TYPE.WEAPON) then
		val2 = val2 + 1000000000
	elseif (type2 == hVar.ITEM_TYPE.BODY) then
		val2 = val2 + 2000000000
	elseif (type2 == hVar.ITEM_TYPE.ORNAMENTS) then
		val2 = val2 + 3000000000
	elseif (type2 == hVar.ITEM_TYPE.MOUNT) then
		val2 = val2 + 4000000000
	end
	
	--次优先级: 品质
	local itemLv1 = tItem[t1[1]].itemLv * 10000000
	local itemLv2 = tItem[t2[1]].itemLv * 10000000
	val1 = val1 + itemLv1
	val2 = val2 + itemLv2
	
	--再次优先级: 需求等级
	local requireLv1 = tItem[t1[1]].require[1][2] * 1000000
	local requireLv2 = tItem[t2[1]].require[1][2] * 1000000
	val1 = val1 + requireLv1
	val2 = val2 + requireLv2
	
	--最后优先级: id
	val1 = val1 + t1[1]
	val2 = val2 + t2[1]
	
	return (val1 < val2)
end)

--武器插入空格
local lastWeaponIdx = 0
local weaponNum = 0
for i = PAGE_NUM * 0 + 1, #ttt, 1 do
	local type1 = tItem[ttt[i][1]].type
	if (type1 == hVar.ITEM_TYPE.WEAPON) then
		weaponNum = weaponNum + 1
		lastWeaponIdx = i
	end
end
for i = 1, (PAGE_NUM - weaponNum), 1 do
	table.insert(ttt, lastWeaponIdx + 1, {})
end

--防具插入空格
local lastBodyIdx = 0
local bodyNum = 0
for i = PAGE_NUM * 1 + 1, #ttt, 1 do
	local type1 = tItem[ttt[i][1]].type
	if (type1 == hVar.ITEM_TYPE.BODY) then
		bodyNum = bodyNum + 1
		lastBodyIdx = i
	end
end
for i = 1, (PAGE_NUM - bodyNum), 1 do
	table.insert(ttt, lastBodyIdx + 1, {})
end

--宝物插入空格
local lastOrnamentsIdx = 0
local ornamentsyNum = 0
for i = PAGE_NUM * 2 + 1, #ttt, 1 do
	local type1 = tItem[ttt[i][1]].type
	if (type1 == hVar.ITEM_TYPE.ORNAMENTS) then
		ornamentsyNum = ornamentsyNum + 1
		lastOrnamentsIdx = i
	end
end
for i = 1, (PAGE_NUM - ornamentsyNum), 1 do
	table.insert(ttt, lastOrnamentsIdx + 1, {})
end

if hGlobal.UI.PlayerGiftBagFrm_test then
	hGlobal.UI.PlayerGiftBagFrm_test:del()
end
hGlobal.UI.InitPlayerGiftBagFrm_test("include")
hGlobal.event:event("localEvent_ShowPlayerGiftBagFrm_test", ttt)