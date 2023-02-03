



--道具操作面板
hGlobal.UI.InitMyItemFrm = function(mode)
	--不重复创建道具操作面板
	if hGlobal.UI.PhoneItemFrm then --道具操作面板
		return
	end
	
	local BOARD_WIDTH = 910 --道具操作面板的宽度
	local BOARD_HEIGHT = 558 --道具操作面板的高度
	local BOARD_OFFSETY = -20 --道具操作面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --道具操作面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --道具操作面板的y位置（最顶侧）
	local BOARD_ACTIVE_WIDTH = 508 --道具操作面板活动宽度（卡牌显示的宽度）
	
	local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的x偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	--背包相关部分
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
	local OnCreateItemBagFrame = hApi.DoNothing --创建道具背包界面
	local OnCreateBagItemBtn = hApi.DoNothing --创建背包道具图标按钮
	local GetTouchFocusBagIndex = hApi.DoNothing --获得触控当前聚焦的背包的索引值
	local GetBagIndexTouchFocus = hApi.DoNothing --获得指定背包索引值的控件中心点的屏幕坐标
	
	--宝箱相关部分
	--local OnCreateChestFrame = hApi.DoNothing --创建宝箱界面
	--local RefreshChestFrame = hApi.DoNothing --更新宝箱界面
	
	--分页1：出售道具函数部分
	local OnCreateShopSellFrame = hApi.DoNothing --创建道具出售界面
	local OnCollectItemFunc = hApi.DoNothing --一键添加道具逻辑
	local OnSellItemFunc = hApi.DoNothing --出售道具逻辑
	local OnCreateSellItemBtn = hApi.DoNothing --创建出售的道具图标按钮
	local RefreshSellItemNoteFrm = hApi.DoNothing --刷新出售道具价格和按钮控件
	local OnCreateItemSellTipFrame = hApi.DoNothing --查看道具出售分页说明tip
	
	--分页2：合成道具函数部分
	local OnCreateMainMergeItemBtn = hApi.DoNothing --创建主合成道具图标按钮
	local OnMergeItemFunc = hApi.DoNothing --合成道具逻辑
	local OnCreateMaterialMergeItemBtn = hApi.DoNothing --创建辅合成道具图标按钮
	local OnCreateShopMergeFrame = hApi.DoNothing --创建道具合成界面
	local RefreshMergeItemNoteFrm = hApi.DoNothing --刷新合成道具价格和按钮控件
	local OnCreateItemMergeTipFrame = hApi.DoNothing --查看装备合成分页说明tip
	local PlayMergeAnimationSuccess = hApi.DoNothing --播放道具合成成功动画
	local PlayMergeAnimationFail = hApi.DoNothing --播放道具合成失败动画
	
	--分页3：洗炼道具函数部分
	local OnCreateXiLianItemBtn = hApi.DoNothing --创建洗炼道具图标按钮
	local OnXiLianItemFunc = hApi.DoNothing --洗炼道具逻辑
	local OnCreateShopXiLianFrame = hApi.DoNothing --创建道具洗炼界面
	local OnCreateItemXiLianTipFrame = hApi.DoNothing --查看装备洗炼分页说明tip
	local RefreshXiLianItemNoteFrm = hApi.DoNothing --刷新洗炼道具价格和按钮控件
	local OnClickShowLockXiLianItemSlotTip = hApi.DoNothing --显示锁孔按钮的tip
	local OnClickLockXiLianItemSlot = hApi.DoNothing --点击锁孔按钮的逻辑
	local RefreshXilianItemInfo = hApi.DoNothing --刷新洗炼道具的信息
	local PlayItemXiLianAnimation = hApi.DoNothing --道具洗炼动画
	local PlayItemRebuildAnimation = hApi.DoNothing --道具重铸动画
	
	local ITEM_ICON_EDGE = 64 --道具图标的边长
	local ITEM_BAG_OFFSET_X = 657 --道具背包统一偏移x
	local ITEM_BAG_OFFSET_Y = -116 --道具背包统一偏移y
	
	local BAG_X_NUM = hVar.PLAYERBAG_X_NUM --背包x方向的个数
	local BAG_Y_NUM = hVar.PLAYERBAG_Y_NUM --背包y方向的个数
	local bag_touch_dx = 0 --背包触控点的偏移值x
	local bag_touch_dy = 0 --背包触控点的偏移值y
	
	--页码相关参数
	local BAG_PGAE_NUM = 2 --背包的总页数（默认是2页，会员会更多）
	local current_bag_page = 1 --当前背包的页码（默认显示第一页）
	
	--网络宝箱相关
	local current_NumTab = {chest_gold = 0, chest_silver = 0, chest_cuprum = 0, prize_code = 0}
	
	--分页1：出售道具相关参数
	local SELL_ITEM_X_NUM = 6 --一次最多卖出的道具的x数量
	local SELL_ITEM_Y_NUM = 2 --一次最多卖出的道具的y数量
	local current_sell_num = 0 --当前售出的数量
	
	--分页2：合成道具相关参数
	local current_main_itemIdx = 0 --当前主合成道具在背包索引位置
	local current_material_itemIdxList = {0, 0, 0, 0, 0} --当前辅合成道具id在背包索引位置列表
	
	--分页3：洗炼道具相关参数
	local current_xilian_itemIdx = 0 --当前洗炼道具的背包索引位置
	local current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	--指定只显示某个分页
	local SpecifyShowPageIdx = 0 --指定分页
	local SpecifyOHero = 0 --指定英雄
	local SpecifyEquip = 0 --指定的英雄要穿戴的装备对象
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__TACTIC_FRAME_UPDATE__")
	
	--创建道具操作面板
	hGlobal.UI.PhoneItemFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		--background = "UI:Tactic_Background",
		--background = "UI:herocardfrm",
		background = "UI:Tactic_Background",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneItemFrm
	local _parent = _frm.handle._n
	
	--关闭按钮
	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	if (g_phone_mode ~= 0) then
		closeDx = 0
		closeDy = -20
	end
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--不显示道具操作面板
			hGlobal.UI.PhoneItemFrm:show(0)
			
			--关闭界面后不需要监听的事件
			--取消监听：收到网络宝箱数量的事件
			hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
			--取消监听：更新背包数据
			hGlobal.event:listen("Local_EventReflashPlayerBag", "__ItemReflashplayerBag_Frm", nil)
			--取消监听：道具洗炼结果刷新本界面
			hGlobal.event:listen("Local_Event_ItemXiLian_Result", "__ItemXiLianSuccess_Frm", nil)
			--取消监听：道具重铸结果刷新本界面
			hGlobal.event:listen("Local_Event_ItemRebuild_Result", "__ItemRebuildSuccess_Frm", nil)
			
			--hApi.clearTimer("__TACTIC_FRAME_UPDATE__")
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--如果非只显示指定的分页模式，才会通知关闭主菜单按钮（只显示指定的分页模式，关闭后后续还在主菜单某个界面中）
			if (SpecifyShowPageIdx > 0) then
				--刷新英雄查看界面
				if (SpecifyOHero ~= 0) then
					--如果存在需要关闭界面时要穿戴的装备，那么检测是否能给英雄穿上
					if (SpecifyEquip ~= 0) then
						local itemIdx = 0
						local uniqueId = SpecifyEquip[hVar.ITEM_DATA_INDEX.UNIQUE] --新合成的道具的唯一id
						for i = 1, #Save_PlayerData.bag, 1 do
							local item = Save_PlayerData.bag[i]
							if (type(item) == "table") then
								local uid = item[hVar.ITEM_DATA_INDEX.UNIQUE]
								--print(i, "uid=", uid)
								if (uid == uniqueId) then
									itemIdx = i
									break
								end
							end
						end
						
						--找到了背包的索引位置
						if (itemIdx > 0) then
							local itemId = SpecifyEquip[1]
							--检测该道具是否是装备
							if (hApi.CheckItemIsEquip(itemId)) then --是装备
								--检测英雄等级是否可以穿该装备
								local heroLv = SpecifyOHero.attr.level --英雄的等级
								local requireLv = 0 --需要的等级
								local require = hVar.tab_item[itemId].require
								if require and (type(require) == "table") then
									for i = 1, #require, 1 do
										local requireT = require[i]
										if (type(requireT) == "table") then
											if (requireT[1] == "level") then
												requireLv = requireT[2]
												break
											end
										end
									end
								end
								
								--英雄等级够穿
								--print("requireLv", requireLv, "heroLv", heroLv)
								if (requireLv <= heroLv) then
									--检测英雄对应位置是否有装备
									local nType = hVar.tab_item[itemId].type
									for i = 1, hVar.HERO_EQUIP_SIZE, 1 do
										if (hApi.GetHeroEquipmentIndexType(nType)== i) then
											local oItemE = SpecifyOHero:getbagitem("equip", i)
											if (not oItemE) or (oItemE == 0) then --没装备
												--将角色身上的装备穿上来，从背包移除
												local saveHeroData = hApi.GetHeroCardById(SpecifyOHero.data.id)
												saveHeroData.equipment[i] = SpecifyEquip
												Save_PlayerData.bag[itemIdx] = 0
												
												--存档
												LuaSaveHeroCard() --存档英雄
												LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
												
												break
											end
										end
									end
								end
							end
						end
					end
					
					SpecifyOHero:load(SpecifyOHero.data.id, 1)
				end
			else
				--关闭金币界面
				hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
				
				--触发事件：关闭了主菜单按钮
				hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			end
		end,
	})
	
	--每个分页按钮
	--出售、合成、洗炼
	local tPageIcons = {"ICON:TRADE", "UI:talent", "UI:ItemXiLianPageIcon"}
	--local tTexts = {"出售", "合成", "洗炼"} --language
	local tTexts = {hVar.tab_string["__ITEM_PANEL__PAGE_SELL"], hVar.tab_string["__ITEM_PANEL__PAGE_MERGE"], hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"]} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X,
			y = PAGE_BTN_LEFT_Y,
			w = 130,
			h = 60,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:Tactic_Button",
			x = 0,
			y = 0,
			w = 116,
			h = 48,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = -40,
			y = 5,
			w = 32,
			h = 32,
		})
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 10,
			y = 3,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
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
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--点击分页按钮函数
	OnClickPageBtn = function(pageIndex)
		--不重复显示同一个分页
		if (CurrentSelectRecord.pageIdx == pageIndex) then
			return
		end
		
		--如果只显示指定的分页，那么隐藏掉全部的按钮
		if (SpecifyShowPageIdx > 0) then
			--禁用全部的按钮
			for i = 1, #tPageIcons, 1 do
				_frm.childUI["PageBtn" .. i]:setstate(-1) --按钮不可用
				_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(false) --隐藏图片
				_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(false) --隐藏图标
				_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(false) --隐藏文字
			end
		else --正常的装备入口
			--启用全部的按钮
			for i = 1, #tPageIcons, 1 do
				_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
				_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
				_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
				_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
			end
			
			--当前按钮高亮
			hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
			
			--其它按钮灰掉
			for i = 1, #tPageIcons, 1 do
				if (i ~= pageIndex) then
					hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
				end
			end
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：道具出售
			--创建道具背包界面
			OnCreateItemBagFrame(pageIndex, current_bag_page)
			
			--创建宝箱界面
			--OnCreateChestFrame(pageIndex)
			
			--创建道具出售界面
			OnCreateShopSellFrame(pageIndex)
		elseif (pageIndex == 2) then --分页2：道具合成
			--创建道具背包界面
			OnCreateItemBagFrame(pageIndex, current_bag_page)
			
			--创建宝箱界面
			--OnCreateChestFrame(pageIndex)
			
			--创建道具合成分页
			OnCreateShopMergeFrame(pageIndex)
		elseif (pageIndex == 3) then --分页3：道具洗炼
			--创建道具背包界面
			OnCreateItemBagFrame(pageIndex, current_bag_page)
			
			--创建宝箱界面
			--OnCreateChestFrame(pageIndex)
			
			--创建道具洗炼分页
			OnCreateShopXiLianFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
		
		
	end
	
	--函数：创建道具背包界面
	OnCreateItemBagFrame = function(pageIdx, bagPage)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储当前页码
		BAG_PGAE_NUM = hVar.VIP_BAG_LEN[LuaGetPlayerVipLv()] --玩家当前的背包页数
		
		--最小为第1页
		if (bagPage < 1) then
			return
		end
		
		--最大为第N页
		if (bagPage > BAG_PGAE_NUM) then
			return
		end
		
		current_bag_page = bagPage
		--[[
		--依次绘制底板（底板图是2个格子拼一起的）
		for xi = 1, BAG_X_NUM / 2, 1 do
			for yi = 1, BAG_Y_NUM, 1 do
				if (not _frmNode.childUI["ItemBG" .. xi .. "_" .. yi]) then --不重复绘制
					_frmNode.childUI["ItemBG" .. xi .. "_" .. yi] = hUI.image:new({
						parent = _parentNode,
						model = "ICON:bag_slot",
						x = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 * 2,
						y = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1,
						w = ITEM_ICON_EDGE * 2,
						h = ITEM_ICON_EDGE,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "ItemBG" .. xi .. "_" .. yi
				end
			end
		end
		]]
		
		--依次绘制背包背景图
		for xi = 1, BAG_X_NUM, 1 do
			for yi = 1, BAG_Y_NUM, 1 do
				local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
				local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
			
				if (not _frmNode.childUI["ItemBG_" .. xi .. "_" .. yi]) then --不重复绘制
					_frmNode.childUI["ItemBG_" .. xi .. "_" .. yi] = hUI.button:new({
						parent = _parentNode,
						model = "UI:item1",
						x = posX,
						y = posY,
						w = ITEM_ICON_EDGE,
						h = ITEM_ICON_EDGE,
					})
				end
			end
		end
		
		--依次绘制背包道具
		local bagItemCount = BAG_X_NUM * BAG_Y_NUM * BAG_PGAE_NUM --背包道具总数量
		for i = 1, bagItemCount, 1 do
			--依次绘制背包道具
			OnCreateBagItemBtn(pageIdx, i)
		end
		
		--只显示当前分页的按钮，其它分页的按钮隐藏
		local previoisPage = current_bag_page - 1
		local postPage = current_bag_page + 1
		for p = 1, previoisPage, 1 do
			local begin = (p - 1) * BAG_X_NUM * BAG_Y_NUM
			for i = begin + 1, begin + (BAG_X_NUM * BAG_Y_NUM), 1 do
				if _frmNode.childUI["Item" .. i] then
					_frmNode.childUI["Item" .. i]:setstate(-1)
				end
			end
		end
		for p = postPage, BAG_PGAE_NUM, 1 do
			local begin = (p - 1) * BAG_X_NUM * BAG_Y_NUM
			for i = begin + 1, begin + (BAG_X_NUM * BAG_Y_NUM), 1 do
				if _frmNode.childUI["Item" .. i] then
					_frmNode.childUI["Item" .. i]:setstate(-1)
				end
			end
		end
		local begin = (current_bag_page - 1) * BAG_X_NUM * BAG_Y_NUM
		for i = begin + 1, begin + (BAG_X_NUM * BAG_Y_NUM), 1 do
			if _frmNode.childUI["Item" .. i] then
				_frmNode.childUI["Item" .. i]:setstate(1)
			end
		end
		
		--背包翻页按钮上
		if (not _frmNode.childUI["pagUpBtn"]) then --不重复绘制
			_frmNode.childUI["pagUpBtn"] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png", --"UI:playerBagD"
				x = ITEM_BAG_OFFSET_X + 236,
				y = ITEM_BAG_OFFSET_Y - 79,
				w = 40 + 40,
				h = 150,
				scaleT = 0.98,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--绘制背包上一页
					if (current_bag_page > 1) then
						--绘制前一页
						OnCreateItemBagFrame(pageIdx, current_bag_page - 1)
						
						--如果存在英雄背包，那么同步更新背包的分页
						if (SpecifyShowPageIdx > 0) then
							hGlobal.UI.HeroCardNewFrm.childUI["playerbag_table_L"].data.code()
						end
					end
				end,
			})
			_frmNode.childUI["pagUpBtn"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "pagUpBtn"
			
			--背包翻页按钮上子控件
			_frmNode.childUI["pagUpBtn"].childUI["img"] = hUI.image:new({
				parent = _frmNode.childUI["pagUpBtn"].handle._n,
				model = "UI:playerBagD",
				x = -20,
				y = -40,
			})
			_frmNode.childUI["pagUpBtn"].childUI["img"] .handle.s:setFlipX(true)
			_frmNode.childUI["pagUpBtn"].childUI["img"].handle.s:setRotation(180)
		end
		--检测翻页上按钮是否可用
		if (current_bag_page == 1) then
			--_frmNode.childUI["pagUpBtn"]:setstate(0)
			_frmNode.childUI["pagUpBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
		else
			--_frmNode.childUI["pagUpBtn"]:setstate(1)
			_frmNode.childUI["pagUpBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
		end
		
		--背包翻页按钮下
		if (not _frmNode.childUI["pageDownBtn"]) then --不重复绘制
			_frmNode.childUI["pageDownBtn"] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png", --"UI:playerBagD"
				x = ITEM_BAG_OFFSET_X + 236,
				y = ITEM_BAG_OFFSET_Y - 239,
				w = 40 + 40,
				h = 150,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					if (current_bag_page < BAG_PGAE_NUM) then
						--绘制背包下一页
						OnCreateItemBagFrame(pageIdx, current_bag_page + 1)
						
						--如果存在英雄背包，那么同步更新背包的分页
						if (SpecifyShowPageIdx > 0) then
							hGlobal.UI.HeroCardNewFrm.childUI["playerbag_table_R"].data.code()
						end
					end
				end,
			})
			_frmNode.childUI["pageDownBtn"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "pageDownBtn"
			
			--背包翻页按钮下子控件
			_frmNode.childUI["pageDownBtn"].childUI["img"] = hUI.image:new({
				parent = _frmNode.childUI["pageDownBtn"].handle._n,
				model = "UI:playerBagD",
				x = -20,
				y = 40,
			})
		end
		--检测翻页下按钮是否可用
		if (current_bag_page == BAG_PGAE_NUM) then
			--_frmNode.childUI["pageDownBtn"]:setstate(0)
			_frmNode.childUI["pageDownBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
		else
			--_frmNode.childUI["pageDownBtn"]:setstate(1)
			_frmNode.childUI["pageDownBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
		end
		
		--页码文字
		if (not _frmNode.childUI["pageLabel"]) then
			_frmNode.childUI["pageLabel"] = hUI.label:new({
				parent = _parentNode,
				size = 26,
				align = "MT",
				border = 1,
				x = ITEM_BAG_OFFSET_X + 216,
				y = ITEM_BAG_OFFSET_Y - 144,
				font = hVar.DEFAULT_FONT,
				width = 300,
				text = "?/?",
			})
			_frmNode.childUI["pageLabel"].handle.s:setColor(ccc3(255, 255, 255))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "pageLabel"
		end
		_frmNode.childUI["pageLabel"]:setText(current_bag_page .. "/" .. BAG_PGAE_NUM) --设置当前的背包页码
	end
	
	--函数：创建背包道具图标按钮
	OnCreateBagItemBtn = function(pageIdx, bagIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local item = Save_PlayerData.bag[bagIdx]
		if item and (item ~= 0) and type(item) == "table" then
			local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
			if (modBagIdx == 0) then
				modBagIdx = BAG_X_NUM * BAG_Y_NUM
			end
			local xi = modBagIdx % BAG_X_NUM --xi
			if (xi == 0) then
				xi = BAG_X_NUM
			end
			local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
			local itemId = item[1] --道具id
			
			--绘制道具图标（按钮响应）
			local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
			local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			local nRequireLv = hApi.GetItemRequire(itemId, "level") --需求等级
			local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL --模型
			if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
				itemModel = "ICON:Back_red2_item"
			end
			if (not _frmNode.childUI["Item" .. bagIdx]) then --不重复绘制
				_frmNode.childUI["Item" .. bagIdx] = hUI.button:new({
					parent = _parentNode,
					--model = "UI:SkillSlot",
					model = itemModel,
					x = posX,
					y = posY,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
					dragbox = _frm.childUI["dragBox"],
					scaleT = 1.0,
					failcall = 1,
					
					--按下道具图标事件
					codeOnTouch = function(self, touchX, touchY, sus)
						--创建选中框
						_frmNode.childUI["box"] = hUI.image:new({
							parent = _parentNode,
							model = "UI:Tactic_Selected",
							x = posX,
							y = posY,
							w = ITEM_ICON_EDGE,
							h = ITEM_ICON_EDGE,
							align = "MC",
						})
						
						--记录初始的偏移值
						bag_touch_dx = posX - touchX --触屏的偏移值x
						bag_touch_dy = posY - touchY --触屏的偏移值y
						
						--显示道具tip
						local itemtipX = 350 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
						local itemTipY = 724 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
						hGlobal.event:event("LocalEvent_ShowItemTipFram", {item}, nil, 1, itemtipX, itemTipY, 0)
					end,
					
					--滑动道具图标事件
					codeOnDrag = function(self, touchX, touchY, sus)
						--如果该背包道具不是待出售状态，那么创建道具拷贝对象
						if (self.data.tosell ~= 1) then
							if (not _frmNode.childUI["copyItem"]) then
								--创建背包道具拷贝对象（背景框）
								local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
								if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
									itemModel = "ICON:Back_red2_item"
								end
								_frmNode.childUI["copyItem"] = hUI.button:new({
									parent = _parentNode,
									--model = "UI:SkillSlot",
									model = itemModel,
									x = self.data.x,
									y = self.data.y,
									w = self.data.w,
									h = self.data.h,
									z = 102, --拷贝对象z值较高
								})
								_frmNode.childUI["copyItem"].handle.s:setOpacity(90) --拖动时，淡掉拷贝道具底纹
								
								--创建背包道具拷贝对象
								_frmNode.childUI["copyItem"].childUI["icon"] = hUI.image:new({
									parent = _frmNode.childUI["copyItem"].handle._n,
									model = hVar.tab_item[itemId].icon,
									x = 0,
									y = 0,
									w = ITEM_ICON_EDGE - 12,
									h = ITEM_ICON_EDGE - 12,
								})
							end
							_frmNode.childUI["copyItem"]:setXY(touchX + bag_touch_dx, touchY + bag_touch_dy)
							
							--自身道具图标变淡
							self.handle.s:setOpacity(30) --拖动时，淡掉自身道具的底纹
						end
						
						--检测当前触控点在哪个背包上
						local coverXi, coverYi = GetTouchFocusBagIndex(touchX, touchY, pageIdx)
						local coverBagIdx = (coverYi - 1) * BAG_X_NUM + coverXi + (BAG_X_NUM * BAG_Y_NUM) * (current_bag_page - 1)
						if (coverXi > 0) then --绘制即将替换的栏位标识
							--如果是自己的栏位，那么不显示标识
							if (coverXi == xi) and (coverYi == yi) then
								--删除替换栏位标识
								hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
								
								--删除替换栏位标识（特殊池子）
								hApi.safeRemoveT(_frmNode.childUI, "replaceBoxSpecial")
								
								--不删除道具tip
								--...
							elseif (coverXi == 10001) and (coverYi == 10001) then --选中了出售池子
								--删除替换栏位标识
								hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
								
								--该道具不能是待出售状态
								--创建替换的栏位标识（特殊池子）
								if (self.data.tosell ~= 1) then
									if (not _frmNode.childUI["replaceBoxSpecial"]) then
										local sellCtrl = _frmNode.childUI["SellChip"]
										local sell_x = sellCtrl.data.x
										local sell_y = sellCtrl.data.y
										local sell_w = sellCtrl.data.w
										local sell_h = sellCtrl.data.h
										
										--[[
										--创建替换的栏位标识（特殊池子）
										_frmNode.childUI["replaceBoxSpecial"] = hUI.button:new({
											parent = _parentNode,
											model = "misc/y_mask_16.png", --"UI:Tactic_Selected",
											x = sell_x,
											y = sell_y,
											w = sell_w,
											h = sell_h,
											z = 101,
										})
										--_frmNode.childUI["replaceBoxSpecial"].handle.s:setColor(ccc3(255, 0, 0))
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setOpacity(0) --提示出售道具区域的包围盒，现在不显示
										]]
										--创建替换的栏位标识（特殊池子）
										local sell1_x = _frmNode.childUI["SellItemBG1"].data.x
										local sell1_y = _frmNode.childUI["SellItemBG1"].data.y
										local sellIdx = current_sell_num + 1
										local to_x = sell1_x + (sellIdx - 1) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2
										local to_y = sell1_y
										if (current_sell_num >= SELL_ITEM_X_NUM) then --换行
											to_x = sell1_x + (current_sell_num - 1 - SELL_ITEM_X_NUM) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2 + ITEM_ICON_EDGE
											to_y = sell1_y - ITEM_ICON_EDGE
										end
										if (sellIdx <= (SELL_ITEM_X_NUM * SELL_ITEM_Y_NUM)) then --没满
											_frmNode.childUI["replaceBoxSpecial"] = hUI.button:new({
												parent = _parentNode,
												model = "UI:Tactic_Selected",
												x = to_x,
												y = to_y,
												w = ITEM_ICON_EDGE,
												h = ITEM_ICON_EDGE,
												z = 101,
											})
											
											--创建说明，提示该道具可以卖多少积分
											local __parent = _frmNode.childUI["replaceBoxSpecial"]
											local __parentHandle = __parent.handle._n
											local xOffset = 0
											local yOffset = 150
											--道具卖出说明背景框
											--[[
											__parent.childUI["imgBg"] = hUI.image:new({
												parent = __parentHandle,
												model = "UI:TacticBG", --"UI:ExpBG",
												x = xOffset,
												y = yOffset,
												w = 380,
												h = 110,
												align = "MC",
											})
											__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
											]]
											local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 380, 110, __parent)
											img9:setOpacity(214)
											
											--道具底框
											local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
											if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
												itemModel = "ICON:Back_red2_item"
											end
											__parent.childUI["imgIconBG"] = hUI.image:new({
												parent = __parentHandle,
												model = itemModel,
												x = xOffset - 148,
												y = yOffset,
												w = 68,
												h = 68,
												align = "MC",
											})
											__parent.childUI["imgIconBG"].handle.s:setOpacity(255) --设置道具背景默认灰度
											if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
												__parent.childUI["imgIconBG"].handle.s:setOpacity(255) --神器更亮些
											end
											
											--道具图标
											__parent.childUI["imgIcon"] = hUI.image:new({
												parent = __parentHandle,
												model = hVar.tab_item[itemId].icon,
												x = xOffset - 148,
												y = yOffset,
												w = 64,
												h = 64,
												align = "MC",
											})
											
											--出售道具名称
											local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId)
											__parent.childUI["labName"] = hUI.label:new({
												parent = __parentHandle,
												size = 28,
												align = "LT",
												border = 1,
												x = xOffset - 100,
												y = yOffset + 32,
												--font = hVar.FONTC,
												font = hVar.FONTC,
												width = 290,
												text = name,
											})
											local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
											local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
											local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
											__parent.childUI["labName"].handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
											
											--道具出售获得的积分说明
											local sellJiFen = itemLv * 10
											__parent.childUI["labSellHint"] = hUI.label:new({
												parent = __parentHandle,
												size = 28,
												align = "LT",
												border = 1,
												x = xOffset - 100,
												y = yOffset - 5,
												--font = hVar.FONTC,
												font = hVar.FONTC,
												width = 290,
												--text = "出售将获得" .. sellJiFen .."积分", --language
												text = hVar.tab_string["__ITEM_PANEL__SELL_PREFIX"] .. sellJiFen .. hVar.tab_string["ios_score"], --language
											})
											__parent.childUI["labSellHint"].handle.s:setColor(ccc3(255, 255, 255))
											--红装、橙装不能出售
											if (not hVar.ITEM_ENABLE_SELL[itemLv]) then --不能出售的
												--__parent.childUI["labSellHint"]:setText("红装、橙装不能出售！") --language
												__parent.childUI["labSellHint"]:setText(hVar.tab_string["__ITEM_PANEL__SELL_DISABLE"]) --language
												__parent.childUI["labSellHint"].handle.s:setColor(ccc3(255, 0, 0))
											end
											if (nRequireLv >= 99) then --合成材料不能出售
												--__parent.childUI["labSellHint"]:setText("合成材料不能出售！") --language
												__parent.childUI["labSellHint"]:setText(hVar.tab_string["__ITEM_PANEL__SELL_MATERIAL_DISABLE"]) --language
												__parent.childUI["labSellHint"].handle.s:setColor(ccc3(255, 0, 0))
											end
										end
									end
								end
								
								--删除道具tip
								hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
							elseif (coverXi == 20000) and (coverYi == 20000) then --选中了主合成道具
								--删除替换栏位标识
								hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
								
								--该道具不能是待出售状态
								--创建替换的栏位标识（特殊池子）
								if (self.data.tosell ~= 1) then
									local mainItemCtrl = _frmNode.childUI["MainItemImg"]
									local mainItem_x = mainItemCtrl.data.x
									local mainItem_y = mainItemCtrl.data.y
									local mainItem_w = mainItemCtrl.data.w
									local mainItem_h = mainItemCtrl.data.h
									if (not _frmNode.childUI["replaceBoxSpecial"]) then
										local mainItemCtrl = _frmNode.childUI["MainItemImg"]
										--创建替换的栏位标识（特殊池子）
										_frmNode.childUI["replaceBoxSpecial"] = hUI.button:new({
											parent = _parentNode,
											--model = "UI:Tactic_Selected",
											model = "UI:Button_SelectBorder",
											x = mainItem_x,
											y = mainItem_y,
											w = mainItem_w,
											h = mainItem_h,
											z = 101,
										})
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setColor(ccc3(255, 0, 0))
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setOpacity(0) --特效表现，所以这里不显示该控件
										local decal, count = 11, 0 --光晕效果
										local r, g, b, parent = 150, 128, 64
										local parent = _frmNode.childUI["replaceBoxSpecial"].handle._n
										local offsetX, offsetY, duration, scale = 0, 2, 0.7, 1.05
										local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
										nnn:setScale(4.2)
										
										--创建说明，提示该主合成道具简介
										local __parent = _frmNode.childUI["replaceBoxSpecial"]
										local __parentHandle = __parent.handle._n
										local xOffset = 0
										local yOffset = 150
										--道具主合成道具简介背景框
										--[[
										__parent.childUI["imgBg"] = hUI.image:new({
											parent = __parentHandle,
											model = "UI:TacticBG", --"UI:ExpBG",
											x = xOffset,
											y = yOffset,
											w = 380,
											h = 110,
											align = "MC",
										})
										__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
										]]
										local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 380, 110, __parent)
										img9:setOpacity(214)
										
										--道具底框
										local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
										if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
											itemModel = "ICON:Back_red2_item"
										end
										__parent.childUI["imgIconBG"] = hUI.image:new({
											parent = __parentHandle,
											model = itemModel,
											x = xOffset - 148,
											y = yOffset,
											w = 68,
											h = 68,
											align = "MC",
										})
										
										--道具图标
										__parent.childUI["imgIcon"] = hUI.image:new({
											parent = __parentHandle,
											model = hVar.tab_item[itemId].icon,
											x = xOffset - 148,
											y = yOffset,
											w = 64,
											h = 64,
											align = "MC",
										})
										
										--主合成道具名称
										local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId)
										__parent.childUI["labName"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset + 32,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											text = name,
										})
										local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
										local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
										local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
										__parent.childUI["labName"].handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
										
										--创建主合成道具的说明
										local jifenGet = 10
										__parent.childUI["labMainItemHint"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset - 5,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											--text = "将该道具放在主合成栏", --language
											text = hVar.tab_string["__ITEM_PANEL__MERGE_MAIN_ITEM"], --language
										})
										__parent.childUI["labMainItemHint"].handle.s:setColor(ccc3(255, 255, 255))
										--如果该道具不是装备，那么提示不能再放入该位置
										if (not hApi.CheckItemIsEquip(itemId)) then
											--__parent.childUI["labMainItemHint"]:setText("非装备道具不能合成") --language
											__parent.childUI["labMainItemHint"]:setText(hVar.tab_string["__ITEM_PANEL__MERGE_BAN1"]) --language
											__parent.childUI["labMainItemHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
										--如果该品质的道具不能合成，那么提示不能再放入该位置
										if (not hVar.ITEM_MERGE_LIMIT[itemLv]) then
											--__parent.childUI["labMainItemHint"]:setText("该品质道具不能合成") --language
											__parent.childUI["labMainItemHint"]:setText(hVar.tab_string["__ITEM_PANEL__MERGE_BAN2"]) --language
											__parent.childUI["labMainItemHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
									end
									
									--设置坐标
									_frmNode.childUI["replaceBoxSpecial"]:setXY(mainItem_x, mainItem_y)
								end
								
								--删除道具tip
								hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
							elseif ((coverXi >= 20001) and (coverXi <= 20005)) and ((coverYi >= 20001) and (coverYi <= 20005)) then --选中了辅合成道具
								--删除替换栏位标识
								hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
								
								--该道具不能是待出售状态
								--创建替换的栏位标识（特殊池子）
								if (self.data.tosell ~= 1) then
									local mergePos = coverXi - 20000
									local matItemCtrli = _frmNode.childUI["MaterialItemImg" .. mergePos]
									local matItem_x = matItemCtrli.data.x
									local matItem_y = matItemCtrli.data.y
									local matItem_w = matItemCtrli.data.w
									local matItem_h = matItemCtrli.data.h
									if (not _frmNode.childUI["replaceBoxSpecial"]) then
										--创建替换的栏位标识（特殊池子）
										_frmNode.childUI["replaceBoxSpecial"] = hUI.button:new({
											parent = _parentNode,
											model = "UI:Tactic_Selected",
											x = matItem_x,
											y = matItem_y,
											w = matItem_w,
											h = matItem_h,
											z = 101,
										})
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setColor(ccc3(255, 0, 0))
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setOpacity(0) --特效表现，所以这里不显示该控件
										local decal, count = 11, 0 --光晕效果
										local r, g, b, parent = 150, 128, 64, _frmNode.childUI["replaceBoxSpecial"].handle._n
										local offsetX, offsetY, duration, scale = 0, 2, 0.7, 1.05
										local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
										nnn:setScale(4.2)
										
										--创建说明，提示该道具放到辅合成栏
										local __parent = _frmNode.childUI["replaceBoxSpecial"]
										local __parentHandle = __parent.handle._n
										local xOffset = 0
										local yOffset = 150
										--[[
										--道具卖出说明背景框
										__parent.childUI["imgBg"] = hUI.image:new({
											parent = __parentHandle,
											model = "UI:TacticBG", --"UI:ExpBG",
											x = xOffset,
											y = yOffset,
											w = 380,
											h = 110,
											align = "MC",
										})
										__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
										]]
										local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 380, 110, __parent)
										img9:setOpacity(214)
										
										--道具底框
										local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
										if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
											itemModel = "ICON:Back_red2_item"
										end
										__parent.childUI["imgIconBG"] = hUI.image:new({
											parent = __parentHandle,
											model = itemModel,
											x = xOffset - 148,
											y = yOffset,
											w = 68,
											h = 68,
											align = "MC",
										})
										
										--道具图标
										__parent.childUI["imgIcon"] = hUI.image:new({
											parent = __parentHandle,
											model = hVar.tab_item[itemId].icon,
											x = xOffset - 148,
											y = yOffset,
											w = 64,
											h = 64,
											align = "MC",
										})
										
										--辅合成道具名称
										--local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId) --language
										local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or (hVar.tab_string["__ITEM_UKNOWN"] .. itemId) --language
										__parent.childUI["labName"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset + 32,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											text = name,
										})
										local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
										local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
										local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
										__parent.childUI["labName"].handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
										
										--创建辅合成道具的说明
										local jifenGet = 10
										__parent.childUI["labMeterialHint"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset - 5,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											--text = "将该道具放在辅合成栏", --language
											text = hVar.tab_string["__ITEM_PANEL__MERGE_METERIAL_ITEM"], --language
										})
										__parent.childUI["labMeterialHint"].handle.s:setColor(ccc3(255, 255, 255))
										--如果该道具不是装备，那么提示不能再放入该位置
										if (not hApi.CheckItemIsEquip(itemId)) then
											--__parent.childUI["labMeterialHint"]:setText("非装备道具不能合成") --language
											__parent.childUI["labMeterialHint"]:setText(hVar.tab_string["__ITEM_PANEL__MERGE_BAN1"]) --language
											__parent.childUI["labMeterialHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
										--如果该品质的道具不能合成，那么提示不能再放入该位置
										if (not hVar.ITEM_MERGE_LIMIT[itemLv]) then
											--__parent.childUI["labMeterialHint"]:setText("该品质道具不能合成") --language
											__parent.childUI["labMeterialHint"]:setText(hVar.tab_string["__ITEM_PANEL__MERGE_BAN2"]) --language
											__parent.childUI["labMeterialHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
									end
									
									--设置坐标
									_frmNode.childUI["replaceBoxSpecial"]:setXY(matItem_x, matItem_y)
								end
								
								--删除道具tip
								hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
							elseif (coverXi == 30000) and (coverYi == 30000) then --选中了洗炼道具
								--删除替换栏位标识
								hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
								
								--该道具不能是待出售状态
								--创建替换的栏位标识（特殊池子）
								if (self.data.tosell ~= 1) then
									local xilianChipCtrl = _frmNode.childUI["XiLianChip"]
									local xilianChip_x = xilianChipCtrl.data.x
									local xilianChip_y = xilianChipCtrl.data.y
									local xilianChip_w = xilianChipCtrl.data.w
									local xilianChip_h = xilianChipCtrl.data.h
									if (not _frmNode.childUI["replaceBoxSpecial"]) then
										local xilianChipCtrl = _frmNode.childUI["XiLianChip"]
										--创建替换的栏位标识（特殊池子）
										_frmNode.childUI["replaceBoxSpecial"] = hUI.button:new({
											parent = _parentNode,
											--model = "UI:Tactic_Selected",
											model = "UI:Button_SelectBorder",
											x = xilianChip_x,
											y = xilianChip_y,
											w = xilianChip_w,
											h = xilianChip_h,
											z = 101,
										})
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setColor(ccc3(255, 0, 0))
										_frmNode.childUI["replaceBoxSpecial"].handle.s:setOpacity(0) --特效表现，所以这里不显示该控件
										local decal, count = 11, 0 --光晕效果
										local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
										local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
										local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
										local parent = _frmNode.childUI["replaceBoxSpecial"].handle._n
										local offsetX, offsetY, duration, scale = 0, 2, 0.7, 1.05
										local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
										nnn:setScale(4.5)
										
										--创建说明，提示该洗炼道具简介
										local __parent = _frmNode.childUI["replaceBoxSpecial"]
										local __parentHandle = __parent.handle._n
										local xOffset = 0
										local yOffset = 150
										--洗炼道具简介背景框
										--[[
										__parent.childUI["imgBg"] = hUI.image:new({
											parent = __parentHandle,
											model = "UI:TacticBG", --"UI:ExpBG",
											x = xOffset,
											y = yOffset,
											w = 380,
											h = 110,
											align = "MC",
										})
										__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
										]]
										local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 380, 110, __parent)
										img9:setOpacity(214)
										
										--道具底框
										local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
										if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
											itemModel = "ICON:Back_red2_item"
										end
										__parent.childUI["imgIconBG"] = hUI.image:new({
											parent = __parentHandle,
											model = itemModel,
											x = xOffset - 148,
											y = yOffset,
											w = 68,
											h = 68,
											align = "MC",
										})
										
										--道具图标
										__parent.childUI["imgIcon"] = hUI.image:new({
											parent = __parentHandle,
											model = hVar.tab_item[itemId].icon,
											x = xOffset - 148,
											y = yOffset,
											w = 64,
											h = 64,
											align = "MC",
										})
										
										--洗炼道具名称
										--local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId) --language
										local name = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or (hVar.tab_string["__ITEM_UKNOWN"] .. itemId) --language
										__parent.childUI["labName"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset + 32,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											text = name,
										})
										local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
										local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
										local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
										__parent.childUI["labName"].handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
										
										--创建洗炼道具的说明
										local jifenGet = 10
										__parent.childUI["labxilianChipHint"] = hUI.label:new({
											parent = __parentHandle,
											size = 28,
											align = "LT",
											border = 1,
											x = xOffset - 100,
											y = yOffset - 5,
											--font = hVar.FONTC,
											font = hVar.FONTC,
											width = 290,
											--text = "将该道具放在洗炼池", --language
											text = hVar.tab_string["__ITEM_PANEL__XILIAN_OP"], --language
										})
										__parent.childUI["labxilianChipHint"].handle.s:setColor(ccc3(255, 255, 255))
										--如果该道具不是装备，那么提示不能再放入该位置
										if (not hApi.CheckItemIsEquip(itemId)) then
											--__parent.childUI["labxilianChipHint"]:setText("非装备道具不能洗炼") --language
											__parent.childUI["labxilianChipHint"]:setText(hVar.tab_string["__ITEM_PANEL__XILIAN_BAN1"]) --language
											__parent.childUI["labxilianChipHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
										--如果该品质的道具不能洗炼，那么提示不能再放入该位置
										if(hVar.ITEM_ATTR_EX_LIMIT[itemLv] <= 0) then
											--__parent.childUI["labxilianChipHint"]:setText("该品质道具不能洗炼") --language
											__parent.childUI["labxilianChipHint"]:setText(hVar.tab_string["__ITEM_PANEL__XILIAN_BAN2"]) --language
											__parent.childUI["labxilianChipHint"].handle.s:setColor(ccc3(255, 0, 0))
										end
									end
									
									--设置坐标
									_frmNode.childUI["replaceBoxSpecial"]:setXY(xilianChip_x, xilianChip_y)
								end
								
								--删除道具tip
								hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
							else --选中了别的背包栏位
								--删除替换的栏位标识（特殊池子）
								hApi.safeRemoveT(_frmNode.childUI, "replaceBoxSpecial")
								
								--该道具不能是待出售状态，也不能是交换待出售的道具栏位
								--创建替换的栏位标识
								if (self.data.tosell ~= 1) then
									local coverCtrl = _frmNode.childUI["Item" .. coverBagIdx]
									if (coverCtrl) and (coverCtrl.data.tosell == 1) then --要交换的位置是待出售的，不能交换，也不能进行提示
										--创建替换的栏位标识
										hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
									else --可以交换的位置
										--创建替换的栏位标识
										if (not _frmNode.childUI["replaceBox"]) then
											_frmNode.childUI["replaceBox"] = hUI.image:new({
												parent = _parentNode,
												model = "UI:Tactic_Selected",
												x = 0,
												y = 0,
												w = ITEM_ICON_EDGE,
												h = ITEM_ICON_EDGE,
											})
										end
										
										local replaceX = ITEM_BAG_OFFSET_X + (coverXi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
										local replaceY = ITEM_BAG_OFFSET_Y - (coverYi - 1) * (ITEM_ICON_EDGE - 1) - 1
										_frmNode.childUI["replaceBox"]:setXY(replaceX, replaceY)
										_frmNode.childUI["replaceBox"].handle.s:setColor(ccc3(0, 255, 0))
										_frmNode.childUI["replaceBox"].handle.s:setOpacity(168) --提示交换道具区域的包围盒透明度为168
									end
								end
								
								--删除道具tip
								hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
							end
						else --删除替换栏位标识
							--删除替换栏位标识（特殊池子）
							hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
							
							--删除替换栏位标识
							hApi.safeRemoveT(_frmNode.childUI, "replaceBoxSpecial")
							
							--删除道具tip
							hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
						end
					end,
					
					--抬起道具图标事件
					code = function(self, touchX, touchY, sus, bNoAction)
						--删除选中框
						hApi.safeRemoveT(_frmNode.childUI, "box")
						
						--删除道具拷贝对象
						hApi.safeRemoveT(_frmNode.childUI, "copyItem")
						
						--删除替换栏位标识
						hApi.safeRemoveT(_frmNode.childUI, "replaceBox")
						hApi.safeRemoveT(_frmNode.childUI, "replaceBoxSpecial")
						
						--删除道具tip
						hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
						
						--自身道具图标还原透明度
						if (self.data.tosell ~= 1) then --待出售的道具不用还原
							self.handle.s:setOpacity(255) --道具底纹透明度
						end
						
						--检测是否要将道具放到新的背包栏里
						local coverXi, coverYi = GetTouchFocusBagIndex(touchX, touchY, pageIdx)
						local coverBagIdx = (coverYi - 1) * BAG_X_NUM + coverXi + (BAG_X_NUM * BAG_Y_NUM) * (current_bag_page - 1)
						if (coverXi > 0) then --将替换的栏位
							if (coverXi == xi) and (coverYi == yi) then --同一个位置
								--
							elseif (coverXi == 10001) and (coverYi == 10001) then --出售道具
								--该道具不是待出售的道具
								if (self.data.tosell ~= 1) then
									if hVar.ITEM_ENABLE_SELL[itemLv] then --非不能出售的
										if (nRequireLv < 99) then--非合成材料
											--还未出售满
											if (current_sell_num < SELL_ITEM_X_NUM * SELL_ITEM_Y_NUM) then
												--标记当前出售的数量
												current_sell_num = current_sell_num + 1
												
												--创建出售商品图标，并飞到指定的位置
												local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
												if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
													itemModel = "ICON:Back_red2_item"
												end
												_frmNode.childUI["sellItemAction"] = hUI.button:new({
													parent = _parentNode,
													--model = "UI:SkillSlot",
													model = itemModel,
													x = touchX + bag_touch_dx,
													y = touchY + bag_touch_dy,
													w = ITEM_ICON_EDGE - 6,
													h = ITEM_ICON_EDGE - 6,
													z = 100,
												})
												_frmNode.childUI["sellItemAction"].handle.s:setOpacity(255) --出售商品道具动画底纹透明度
												_frmNode.childUI["sellItemAction"].childUI["icon"] = hUI.image:new({
													parent = _frmNode.childUI["sellItemAction"].handle._n,
													model = hVar.tab_item[itemId].icon,
													x = 0,
													y = 0,
													w = ITEM_ICON_EDGE - 12,
													h = ITEM_ICON_EDGE - 12,
												})
												
												--要到达的目标点的坐标
												local sell1_x = _frmNode.childUI["SellItemBG1"].data.x
												local sell1_y = _frmNode.childUI["SellItemBG1"].data.y
												local to_x = sell1_x + (current_sell_num - 1) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2
												local to_y = sell1_y
												if (current_sell_num > SELL_ITEM_X_NUM) then --换行
													to_x = sell1_x + (current_sell_num - 1 - SELL_ITEM_X_NUM) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2
													to_y = sell1_y - ITEM_ICON_EDGE
												end
												local moveTo = CCMoveTo:create(0.05, ccp(to_x, to_y)) --移动
												local callbackfunc = function() --回调
													--删除自身
													hApi.safeRemoveT(_frmNode.childUI, "sellItemAction")
													
													--创建出售商品图标（用于点击）
													OnCreateSellItemBtn(pageIdx, bagIdx, current_sell_num)
													
													--刷新出售价格和按钮控件
													RefreshSellItemNoteFrm()
												end
												local callback = CCCallFunc:create(function() --回调
													callbackfunc()
												end)
												local sequence = CCSequence:createWithTwoActions(moveTo, callback)
												
												if bNoAction then
													callbackfunc()
												else
													_frmNode.childUI["sellItemAction"].handle._n:runAction(sequence) --action
												end
												
												--为原道具加个角标，标记是待出售状态
												self.childUI["flag"] = hUI.image:new({
													parent = self.handle._n,
													model = "UI:finish",
													x = ITEM_ICON_EDGE - 50,
													y = -12,
													w = 39,
													h = 30,
												})
												
												--原道具变淡
												self.handle.s:setOpacity(90) --道具底纹变淡
												self.childUI["icon"].handle.s:setOpacity(204) --道具变淡
												
												--标记原道具是待出售状态
												self.data.tosell = 1
											end
										end
									end
									
									--红装、橙装不能出售
									if (not hVar.ITEM_ENABLE_SELL[itemLv]) then --不能出售的
										--local strText = "红装、橙装不能出售！" --language
										local strText = hVar.tab_string["__ITEM_PANEL__SELL_DISABLE"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
									if (nRequireLv >= 99) then --合成材料不能出售
										--local strText = "合成材料不能出售！" --language
										local strText = hVar.tab_string["__ITEM_PANEL__SELL_MATERIAL_DISABLE"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								end
							elseif (coverXi == 20000) and (coverYi == 20000) then --主合成道具
								--该道具不是待出售的道具
								if (self.data.tosell ~= 1) then
									--该道具是装备、该道具品质可以合成
									if (hApi.CheckItemIsEquip(itemId)) and (hVar.ITEM_MERGE_LIMIT[itemLv]) then
										--如果主合成栏存在道具，先取消原先的主合成栏道具
										if (current_main_itemIdx ~= 0) then
											--删除自身控件
											local idx = self.data.index
											hApi.safeRemoveT(_frmNode.childUI, "MainItem")
											
											--标记背包栏当前不是待出售状态
											local bagItem = _frmNode.childUI["Item" .. current_main_itemIdx]
											bagItem.data.tosell = 0
											
											--删除背包栏主合成道具标记
											hApi.safeRemoveT(bagItem.childUI, "flag")
											hApi.safeRemoveT(bagItem.childUI, "star")
											
											--原道具变亮
											bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
											bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
										end
										
										--创建主合成道具
										OnCreateMainMergeItemBtn(pageIdx, bagIdx)
										
										--为原道具加个角标，标记是主合成道具状态
										self.childUI["star"] = hUI.image:new({
											parent = self.handle._n,
											model = "UI:explosive", --"UI:shopitemnew", --"UI:finish",
											x = ITEM_ICON_EDGE - ITEM_ICON_EDGE,
											y = -12,
											w = 74,
											h = 48,
										})
										
										--为原道具加个角标，标记是主合成道具状态
										self.childUI["flag"] = hUI.image:new({
											parent = self.handle._n,
											model = "UI:finish",
											x = ITEM_ICON_EDGE - 50,
											y = -12,
											w = 39,
											h = 30,
										})
										
										--原道具变淡
										self.handle.s:setOpacity(90) --道具底纹变淡
										self.childUI["icon"].handle.s:setOpacity(204) --道具变淡
										
										--标记原道具是待出售状态
										self.data.tosell = 1
									end
									
									--如果该道具不是装备，那么提示不能再放入该位置
									if (not hApi.CheckItemIsEquip(itemId)) then
										--local strText = "非装备道具不能合成" --language
										local strText = hVar.tab_string["__ITEM_PANEL__MERGE_BAN1"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
									
									--如果该品质的道具不能合成，那么提示不能再放入该位置
									if (not hVar.ITEM_MERGE_LIMIT[itemLv]) then
										--local strText = "该品质道具不能合成" --language
										local strText = hVar.tab_string["__ITEM_PANEL__MERGE_BAN2"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								end
							elseif ((coverXi >= 20001) and (coverXi <= 20005)) and ((coverYi >= 20001) and (coverYi <= 20005)) then --选中了辅合成道具
								--该道具不是待出售的道具
								if (self.data.tosell ~= 1) then
									local mergePos = coverXi - 20000
									
									--该道具是装备、该道具品质可以合成
									if (hApi.CheckItemIsEquip(itemId)) and (hVar.ITEM_MERGE_LIMIT[itemLv]) then
										--如果辅合成栏存在道具，先取消原先的辅合成栏道具
										if (current_material_itemIdxList[mergePos] ~= 0) then
											--删除自身控件
											hApi.safeRemoveT(_frmNode.childUI, "MaterialItem" .. mergePos)
											
											--标记背包栏当前不是待出售状态
											local bagItem = _frmNode.childUI["Item" .. current_material_itemIdxList[mergePos]]
											bagItem.data.tosell = 0
											
											--删除背包栏主合成道具标记
											hApi.safeRemoveT(bagItem.childUI, "flag")
											
											--原道具变亮
											bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
											bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
										end
										
										--创建辅合成道具
										OnCreateMaterialMergeItemBtn(pageIdx, bagIdx, mergePos)
										
										--为原道具加个角标，标记是待出售状态
										self.childUI["flag"] = hUI.image:new({
											parent = self.handle._n,
											model = "UI:finish",
											x = ITEM_ICON_EDGE - 50,
											y = -12,
											w = 39,
											h = 30,
										})
										
										--原道具变淡
										self.handle.s:setOpacity(90) --道具底纹变淡
										self.childUI["icon"].handle.s:setOpacity(204) --道具变淡
										
										--标记原道具是待出售状态
										self.data.tosell = 1
									end
									
									--如果该道具不是装备，那么提示不能再放入该位置
									if (not hApi.CheckItemIsEquip(itemId)) then
										--local strText = "非装备道具不能合成" --language
										local strText = hVar.tab_string["__ITEM_PANEL__MERGE_BAN1"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
									
									--如果该品质的道具不能合成，那么提示不能再放入该位置
									if (not hVar.ITEM_MERGE_LIMIT[itemLv]) then
										--local strText = "该品质道具不能合成" --language
										local strText = hVar.tab_string["__ITEM_PANEL__MERGE_BAN2"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								end
							elseif (coverXi == 30000) and (coverYi == 30000) then --洗炼道具
								--该道具不是待出售的道具
								if (self.data.tosell ~= 1) then
									--该道具是装备、该道具品质可以洗炼
									if (hApi.CheckItemIsEquip(itemId)) and (hVar.ITEM_ATTR_EX_LIMIT[itemLv] > 0) then
										--如果洗炼池存在道具，先取消原先的洗炼池道具
										if (current_xilian_itemIdx ~= 0) then
											--删除自身控件
											local idx = self.data.index
											hApi.safeRemoveT(_frmNode.childUI, "XiLianItem")
											
											--标记背包栏当前不是待出售状态
											local bagItem = _frmNode.childUI["Item" .. current_xilian_itemIdx]
											bagItem.data.tosell = 0
											
											--删除背包栏洗炼道具标记
											hApi.safeRemoveT(bagItem.childUI, "flag")
											hApi.safeRemoveT(bagItem.childUI, "xilianMark")
											
											--原道具变亮
											bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
											bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
										end
										
										--创建洗炼道具
										OnCreateXiLianItemBtn(pageIdx, bagIdx)
										
										--为原道具加个角标，标记是洗炼道具状态
										self.childUI["xilianMark"] = hUI.image:new({
											parent = self.handle._n,
											model = "MODEL_EFFECT:Roar01", --"UI:shopitemnew", --"UI:finish",
											x = ITEM_ICON_EDGE - ITEM_ICON_EDGE,
											y = 13,
											scale = 0.8,
										})
										
										--为原道具加个角标，标记是洗炼道具状态
										self.childUI["flag"] = hUI.image:new({
											parent = self.handle._n,
											model = "UI:finish",
											x = ITEM_ICON_EDGE - 50,
											y = -12,
											w = 39,
											h = 30,
										})
										
										--原道具变淡
										self.handle.s:setOpacity(90) --道具底纹变淡
										self.childUI["icon"].handle.s:setOpacity(204) --道具变淡
										
										--标记原道具是待出售状态
										self.data.tosell = 1
									end
									
									--如果该道具不是装备，那么提示不能再放入该位置
									if (not hApi.CheckItemIsEquip(itemId)) then
										--local strText = "非装备道具不能洗炼" --language
										local strText = hVar.tab_string["__ITEM_PANEL__XILIAN_BAN1"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
									
									--如果该品质的道具不能洗炼，那么提示不能再放入该位置
									if (hVar.ITEM_ATTR_EX_LIMIT[itemLv] <= 0) then
										--local strText = "该品质道具不能洗炼" --language
										local strText = hVar.tab_string["__ITEM_PANEL__XILIAN_BAN2"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								end
							else --有效的交换栏位
								--该道具不是待出售的道具，也不能和待出售的道具栏位交换
								if (self.data.tosell ~= 1) then
									local coverCtrl = _frmNode.childUI["Item" .. coverBagIdx]
									if (coverCtrl) and (coverCtrl.data.tosell == 1) then --要交换的位置是待出售的，不能交换，也不能进行提示
										--
									else --可以交换的位置
										--交换背包栏位
										local bag = Save_PlayerData.bag
										local tmp = bag[bagIdx]
										bag[bagIdx] = bag[coverBagIdx]
										bag[coverBagIdx] = tmp
										
										--存储存档
										--保存存档
										LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
										
										--交换界面显示
										hApi.safeRemoveT(_frmNode.childUI, "Item" .. bagIdx)
										hApi.safeRemoveT(_frmNode.childUI, "Item" .. coverBagIdx)
										OnCreateBagItemBtn(pageIdx, bagIdx)
										OnCreateBagItemBtn(pageIdx, coverBagIdx)
									end
								end
							end
						end
					end,
				})
				_frmNode.childUI["Item" .. bagIdx].handle.s:setOpacity(255) --设置道具背景默认灰度
				if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
					_frmNode.childUI["Item" .. bagIdx].handle.s:setOpacity(255) --神器更亮些
				end
				
				_frmNode.childUI["Item" .. bagIdx].data.tosell = 0 --默认标记不是待出售
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "Item" .. bagIdx
				
				--绘制道具图标
				_frmNode.childUI["Item" .. bagIdx].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["Item" .. bagIdx].handle._n,
					model = hVar.tab_item[itemId].icon,
					x = 1,
					y = 1,
					w = ITEM_ICON_EDGE - 16,
					h = ITEM_ICON_EDGE - 16,
				})
			end
		end
		
		--如果只显示指定的分页，那么加个返回的按钮
		hApi.safeRemoveT(_frmNode.childUI, "returnBackBtn")
		if (SpecifyShowPageIdx > 0) then
			_frmNode.childUI["returnBackBtn"] = hUI.button:new({
				parent = _frm,
				model = "misc/mask.png", --"UI:playerBagD"
				x = 820,
				y = -507,
				w = 60,
				h = 60,
				scaleT = 0.95,
				dragbox = _frmNode.childUI["dragBox"],
				--font = hVar.FONTC,
				--border = 1,
				--align = "MC",
				--label = hVar.tab_string["__TEXT_Back"],
				code = function()
					_frm.childUI["closeBtn"].data.code()
				end,
			})
			_frmNode.childUI["returnBackBtn"].handle.s:setOpacity(0) --只用于控制，不显示
			
			--道具回收箱图标
			_frmNode.childUI["returnBackBtn"].childUI["imgRecycleBin"] = hUI.image:new({
				parent = _frmNode.childUI["returnBackBtn"].handle._n,
				model = "UI:button_return", 
				x = 0,
				y = 0,
				scale = 0.8,
			})
		end
		
		--如果只显示指定的
	end
	
	--[[
	--函数：创建宝箱界面
	OnCreateChestFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--创建黄金宝箱tip
		local __createGoldTip = function()
			--不重复创建tip
			if (not _frmNode.childUI["net_depletion_gold_tip"]) then
				local PDX = -270
				local PDY = 60
				_frmNode.childUI["net_depletion_gold_tip"] = hUI.button:new({
					parent = _parentNode,
					--model = "UI:Tactic_Selected",
					model = "UI:TacticBG",
					x = ITEM_BAG_OFFSET_X + PDX,
					y = ITEM_BAG_OFFSET_Y + PDY,
					w = 350,
					h = 80,
					z = 101,
				})
				_frmNode.childUI["net_depletion_gold_tip"].handle.s:setOpacity(214) --黄金宝箱tip透明度为214
				
				--父控件
				local __parent = _frmNode.childUI["net_depletion_gold_tip"]
				local __parentHandle = __parent.handle._n
				
				--黄金宝箱底纹
				__parent.childUI["imgIconBG"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:delete_slot",
					x = -135,
					y = -5,
					w = 72,
					h = 72,
					align = "MC",
				})
				
				--黄金宝箱图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "icon/item/random_lv3.png",
					x = -135,
					y = -1,
					w = 56,
					h = 56,
					align = "MC",
				})
				
				--黄金宝箱名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = -100,
					y = 28,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "黄金宝箱", --language
					text = hVar.tab_stringI[9006][1], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(255, 128, 0)) --黄金宝箱的颜色
				
				--黄金宝箱数量
				__parent.childUI["labNum"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = 35,
					y = 28 + 3, --字体额外偏移值
					font = hVar.DEFAULT_FONT,
					width = 290,
					text = "x" .. current_NumTab.chest_gold,
				})
				__parent.childUI["labNum"].handle.s:setColor(ccc3(255, 128, 0)) --黄金宝箱的颜色
				
				--黄金宝箱的说明
				__parent.childUI["labNote"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = -100,
					y = -5,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "点击开启黄金宝箱。", --language
					text = hVar.tab_string["__ITEM_PANEL__GOLD_CHEST_TIP"], --language
				})
				if (current_NumTab.chest_gold == 0) then
					__parent.childUI["labNote"]:setText("您还未获得黄金宝箱。") --language 
					__parent.childUI["labNote"]:setText(hVar.tab_string["__ITEM_PANEL__GOLD_CHEST_NOTGET"]) --language 
					__parent.childUI["labNote"].handle.s:setColor(ccc3(128, 128, 128)) --未获得宝箱
				end
			end
		end
		
		--黄金宝箱底纹（响应按钮事件）
		_frmNode.childUI["net_depletion_gold"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:delete_slot",
			x = ITEM_BAG_OFFSET_X - 34,
			y = ITEM_BAG_OFFSET_Y + 74,
			w = 56,
			h = 56,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下黄金宝箱事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示黄金宝箱选中框
				_frmNode.childUI["net_depletion_gold"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
				
				--创建黄金宝箱tip
				__createGoldTip()
			end,
			
			--滑动黄金宝箱事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在按钮区域内
					--显示黄金宝箱选中框
					_frmNode.childUI["net_depletion_gold"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
					
					--创建黄金宝箱tip
					__createGoldTip()
				else --如果出了按钮区域，那儿隐藏tip
					--不显示黄金宝箱选中框
					_frmNode.childUI["net_depletion_gold"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
					
					--删除黄金宝箱tip
					hApi.safeRemoveT(_frmNode.childUI, "net_depletion_gold_tip")
				end
			end,
			
			--抬起黄金宝箱事件
			code = function(self, touchX, touchY, sus)
				--不显示黄金宝箱选中框
				_frmNode.childUI["net_depletion_gold"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
				
				--删除黄金宝箱tip
				hApi.safeRemoveT(_frmNode.childUI, "net_depletion_gold_tip")
				
				--在按钮区域内部点击到
				if (sus == 1) then
					if (current_NumTab.chest_gold > 0) then --存在黄金宝箱
						self:setstate(0)
						if (g_cur_net_state == -1) then --未联网
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
								font = hVar.FONTC,
								ok = function()
								end,
							})
						else --已联网
							if LuaCheckPlayerBagCanUse() == 0 then
								hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
									font = hVar.FONTC,
									ok = function()
										
									end,
								})
								self:setstate(1)
								return
							end
							
							--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9006,hVar.tab_stringI[9006][1])
							SendCmdFunc["order_begin"](4,9006,0,1,hVar.tab_stringI[9006][1],0,0,nil)
						end
					end
				end
			end,
		})
		_frmNode.childUI["net_depletion_gold"].handle.s:setOpacity(0) --用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_gold"
		
		--黄金宝箱图片
		_frmNode.childUI["net_depletion_gold"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_gold"].handle._n,
			model = "icon/item/random_lv3.png",
			x = 0,
			y = 0,
			w = 48,
			h = 48,
		})
		if (current_NumTab.chest_gold == 0) then
			--hApi.AddShader(_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s, "gray") --灰色
			_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s:setVisible(false) --不显示
		end
		
		--黄金宝箱选中框
		_frmNode.childUI["net_depletion_gold"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_gold"].handle._n,
			model = "UI:Tactic_Selected",
			x = 0,
			y = 0,
			w = 64,
			h = 64,
		})
		_frmNode.childUI["net_depletion_gold"].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
		
		--黄金宝箱的数量文字
		_frmNode.childUI["net_depletion_gold_lab"] = hUI.label:new({
			parent = _parentNode,
			size = 16,
			align = "MC",
			font = "numWhite",
			x = ITEM_BAG_OFFSET_X - 34 + 20,
			y = ITEM_BAG_OFFSET_Y + 74 - 22,
			width = 100,
			text = current_NumTab.chest_gold,
		})
		if (current_NumTab.chest_gold == 0) then
			_frmNode.childUI["net_depletion_gold_lab"].handle.s:setVisible(false) --不显示文字
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_gold_lab"
		
		--创建白银宝箱tip
		local __createSilverTip = function()
			--不重复创建tip
			if (not _frmNode.childUI["net_depletion_silver_tip"]) then
				local PDX = -270
				local PDY = 60
				_frmNode.childUI["net_depletion_silver_tip"] = hUI.button:new({
					parent = _parentNode,
					--model = "UI:Tactic_Selected",
					model = "UI:TacticBG",
					x = ITEM_BAG_OFFSET_X + PDX,
					y = ITEM_BAG_OFFSET_Y + PDY,
					w = 350,
					h = 80,
					z = 101,
				})
				_frmNode.childUI["net_depletion_silver_tip"].handle.s:setOpacity(214) --白银宝箱tip透明度为214
				
				--父控件
				local __parent = _frmNode.childUI["net_depletion_silver_tip"]
				local __parentHandle = __parent.handle._n
				
				--白银宝箱底纹
				__parent.childUI["imgIconBG"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:delete_slot",
					x = -135,
					y = -5,
					w = 72,
					h = 72,
					align = "MC",
				})
				
				--白银宝箱图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "icon/item/random_lv2.png",
					x = -135,
					y = -1,
					w = 56,
					h = 56,
					align = "MC",
				})
				
				--白银宝箱名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = -100,
					y = 28,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "白银宝箱", --language
					text = hVar.tab_stringI[9005][1], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(212, 212, 212)) --白银宝箱的颜色
				
				--白银宝箱数量
				__parent.childUI["labNum"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = 35,
					y = 28 + 3, --字体额外偏移值
					font = hVar.DEFAULT_FONT,
					width = 290,
					text = "x" .. current_NumTab.chest_silver,
				})
				__parent.childUI["labNum"].handle.s:setColor(ccc3(212, 212, 212)) --白银宝箱的颜色
				
				--白银宝箱的说明
				__parent.childUI["labNote"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = -100,
					y = -5,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "点击开启白银宝箱。", --language
					text = hVar.tab_string["__ITEM_PANEL__SILVER_CHEST_TIP"], --language
				})
				if (current_NumTab.chest_silver == 0) then
					__parent.childUI["labNote"]:setText("您还未获得白银宝箱。") --language 
					__parent.childUI["labNote"]:setText(hVar.tab_string["__ITEM_PANEL__SILVER_CHEST_NOTGET"]) --language 
					__parent.childUI["labNote"].handle.s:setColor(ccc3(128, 128, 128)) --未获得宝箱
				end
			end
		end
		
		--白银宝箱底纹（响应按钮事件）
		_frmNode.childUI["net_depletion_silver"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:delete_slot",
			x = ITEM_BAG_OFFSET_X + 31,
			y = ITEM_BAG_OFFSET_Y + 74,
			w = 56,
			h = 56,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下白银宝箱事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示白银宝箱选中框
				_frmNode.childUI["net_depletion_silver"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
				
				--创建白银宝箱tip
				__createSilverTip()
			end,
			
			--滑动白银宝箱事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在按钮区域内
					--显示白银宝箱选中框
					_frmNode.childUI["net_depletion_silver"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
					
					--创建白银宝箱tip
					__createSilverTip()
				else --如果出了按钮区域，那儿隐藏tip
					--不显示白银宝箱选中框
					_frmNode.childUI["net_depletion_silver"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
					
					--删除白银宝箱tip
					hApi.safeRemoveT(_frmNode.childUI, "net_depletion_silver_tip")
				end
			end,
			
			--抬起白银宝箱事件
			code = function(self, touchX, touchY, sus)
				--不显示白银宝箱选中框
				_frmNode.childUI["net_depletion_silver"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
				
				--删除白银宝箱tip
				hApi.safeRemoveT(_frmNode.childUI, "net_depletion_silver_tip")
				
				--在按钮区域内部点击到
				if (sus == 1) then
					if (current_NumTab.chest_silver > 0) then --存在白银宝箱
						--self:setstate(0)
						
						if g_cur_net_state == -1 then
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
								font = hVar.FONTC,
								ok = function()
								end,
							})
						elseif g_cur_net_state == 1 then
							if LuaCheckPlayerBagCanUse() == 0 then
								hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
									font = hVar.FONTC,
									ok = function()
										
									end,
								})
								
								--self:setstate(1)
								return
							end
							
							--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9005,hVar.tab_stringI[9005][1])
							SendCmdFunc["order_begin"](4,9005,0,1,hVar.tab_stringI[9005][1],0,0,nil)
						end
					end
				end
			end,
		})
		_frmNode.childUI["net_depletion_silver"].handle.s:setOpacity(0) --用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_silver"
		
		--白银宝箱按钮
		_frmNode.childUI["net_depletion_silver"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_silver"].handle._n,
			model = "icon/item/random_lv2.png",
			x = 0,
			y = 0,
			w = 48,
			h = 48,
		})
		if (current_NumTab.chest_silver == 0) then
			--hApi.AddShader(_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s, "gray") --灰色
			_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s:setVisible(false) --不显示
		end
		
		--白银宝箱选中框
		_frmNode.childUI["net_depletion_silver"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_silver"].handle._n,
			model = "UI:Tactic_Selected",
			x = 0,
			y = 0,
			w = 64,
			h = 64,
		})
		_frmNode.childUI["net_depletion_silver"].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
		
		--白银宝箱数量文字
		_frmNode.childUI["net_depletion_silver_lab"] = hUI.label:new({
			parent = _parentNode,
			size = 16,
			align = "MC",
			font = "numWhite",
			x = ITEM_BAG_OFFSET_X + 31 + 20,
			y = ITEM_BAG_OFFSET_Y + 74 - 22,
			width = 100,
			text = current_NumTab.chest_silver,
		})
		if (current_NumTab.chest_silver == 0) then
			_frmNode.childUI["net_depletion_silver_lab"].handle.s:setVisible(false) --不显示文字
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_silver_lab"
		
		--创建青铜宝箱tip
		local __createBronzeTip = function()
			--不重复创建tip
			if (not _frmNode.childUI["net_depletion_bronze_tip"]) then
				local PDX = -270
				local PDY = 60
				_frmNode.childUI["net_depletion_bronze_tip"] = hUI.button:new({
					parent = _parentNode,
					--model = "UI:Tactic_Selected",
					model = "UI:TacticBG",
					x = ITEM_BAG_OFFSET_X + PDX,
					y = ITEM_BAG_OFFSET_Y + PDY,
					w = 350,
					h = 80,
					z = 101,
				})
				_frmNode.childUI["net_depletion_bronze_tip"].handle.s:setOpacity(214) --青铜宝箱tip透明度为214
				
				--父控件
				local __parent = _frmNode.childUI["net_depletion_bronze_tip"]
				local __parentHandle = __parent.handle._n
				
				--青铜宝箱底纹
				__parent.childUI["imgIconBG"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:delete_slot",
					x = -135,
					y = -5,
					w = 72,
					h = 72,
					align = "MC",
				})
				
				--青铜宝箱图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "icon/item/random_lv1.png",
					x = -135,
					y = -1,
					w = 56,
					h = 56,
					align = "MC",
				})
				
				--青铜宝箱名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = -100,
					y = 28,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "青铜宝箱", --language
					text = hVar.tab_stringI[9004][1], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(0, 192, 128)) --青铜宝箱的颜色
				
				--青铜宝箱数量
				__parent.childUI["labNum"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = 35,
					y = 28 + 3, --字体额外偏移值
					font = hVar.DEFAULT_FONT,
					width = 290,
					text = "x" .. current_NumTab.chest_cuprum,
				})
				__parent.childUI["labNum"].handle.s:setColor(ccc3(0, 192, 128)) --青铜宝箱的颜色
				
				--青铜宝箱的说明
				__parent.childUI["labNote"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = -100,
					y = -5,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "点击开启青铜宝箱。", --language
					text = hVar.tab_string["__ITEM_PANEL__BRONZE_CHEST_TIP"], --language
				})
				if (current_NumTab.chest_cuprum == 0) then
					__parent.childUI["labNote"]:setText("您还未获得青铜宝箱。") --language 
					__parent.childUI["labNote"]:setText(hVar.tab_string["__ITEM_PANEL__BRONZE_CHEST_NOTGET"]) --language 
					__parent.childUI["labNote"].handle.s:setColor(ccc3(128, 128, 128)) --未获得宝箱
				end
			end
		end
		
		--青铜宝箱底纹（响应按钮事件）
		_frmNode.childUI["net_depletion_bronze"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:delete_slot",
			x = ITEM_BAG_OFFSET_X + 96,
			y = ITEM_BAG_OFFSET_Y + 74,
			w = 56,
			h = 56,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下青铜宝箱事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示青铜宝箱选中框
				_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
				
				--创建青铜宝箱tip
				__createBronzeTip()
			end,
			
			--滑动青铜宝箱事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在按钮区域内
					--显示青铜宝箱选中框
					_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
					
					--创建青铜宝箱tip
					__createBronzeTip()
				else --如果出了按钮区域，那儿隐藏tip
					--不显示青铜宝箱选中框
					_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
					
					--删除青铜宝箱tip
					hApi.safeRemoveT(_frmNode.childUI, "net_depletion_bronze_tip")
				end
			end,
			
			--抬起青铜宝箱事件
			code = function(self, touchX, touchY, sus)
				--不显示青铜宝箱选中框
				_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
				
				--删除青铜宝箱tip
				hApi.safeRemoveT(_frmNode.childUI, "net_depletion_bronze_tip")
				
				--在按钮区域内部点击到
				if (sus == 1) then
					if (current_NumTab.chest_cuprum > 0) then --存在青铜宝箱
						--self:setstate(0)
						
						if g_cur_net_state == -1 then
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
								font = hVar.FONTC,
								ok = function()
								end,
							})
						elseif g_cur_net_state == 1 then
							if LuaCheckPlayerBagCanUse() == 0 then
								hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
									font = hVar.FONTC,
									ok = function()
										
									end,
								})
								
								--self:setstate(1)
								return
							end
							
							--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9004,hVar.tab_stringI[9004][1])
							SendCmdFunc["order_begin"](4,9004,0,1,hVar.tab_stringI[9004][1],0,0,nil)
						end
					end
				end
			end,
		})
		
		_frmNode.childUI["net_depletion_bronze"].handle.s:setOpacity(0) --用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_bronze"
		
		--青铜宝箱图标
		_frmNode.childUI["net_depletion_bronze"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_bronze"].handle._n,
			model = "icon/item/random_lv1.png",
			x = 0,
			y = 0,
			w = 48,
			h = 48,
		})
		if (current_NumTab.chest_cuprum == 0) then
			--hApi.AddShader(_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s, "gray") --灰色
			_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s:setVisible(false) --不显示
		end
		
		--青铜宝箱选中框
		_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_bronze"].handle._n,
			model = "UI:Tactic_Selected",
			x = 0,
			y = 0,
			w = 64,
			h = 64,
		})
		_frmNode.childUI["net_depletion_bronze"].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
		
		--青铜宝箱数量文字
		_frmNode.childUI["net_depletion_bronze_lab"] = hUI.label:new({
			parent = _parentNode,
			size = 16,
			align = "MC",
			font = "numWhite",
			x = ITEM_BAG_OFFSET_X + 96 + 20,
			y = ITEM_BAG_OFFSET_Y + 74 - 22,
			width = 100,
			text = current_NumTab.chest_cuprum,
		})
		if (current_NumTab.chest_cuprum == 0) then
			_frmNode.childUI["net_depletion_bronze_lab"].handle.s:setVisible(false) --不显示文字
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_bronze_lab"
		
		--创建装备获取令tip
		local __createDepletionBbTip = function()
			--不重复创建tip
			if (not _frmNode.childUI["net_depletion_fb_tip"]) then
				local PDX = -270
				local PDY = 60
				_frmNode.childUI["net_depletion_fb_tip"] = hUI.button:new({
					parent = _parentNode,
					--model = "UI:Tactic_Selected",
					model = "UI:TacticBG",
					x = ITEM_BAG_OFFSET_X + PDX,
					y = ITEM_BAG_OFFSET_Y + PDY,
					w = 350,
					h = 80,
					z = 101,
				})
				_frmNode.childUI["net_depletion_fb_tip"].handle.s:setOpacity(214) --装备获取令tip透明度为214
				
				--父控件
				local __parent = _frmNode.childUI["net_depletion_fb_tip"]
				local __parentHandle = __parent.handle._n
				
				--装备获取令底纹
				__parent.childUI["imgIconBG"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:delete_slot",
					x = -135,
					y = -5,
					w = 72,
					h = 72,
					align = "MC",
				})
				
				--装备获取令图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "ICON:BF",
					x = -135,
					y = -1,
					w = 48,
					h = 48,
					align = "MC",
				})
				
				--装备获取令名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = -100,
					y = 28,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "装备获取令", --language
					text = hVar.tab_stringI[9100][1], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(212, 64, 64)) --装备获取令的颜色
				
				--装备获取令数量
				__parent.childUI["labNum"] = hUI.label:new({
					parent = __parentHandle,
					size = 28,
					align = "LT",
					border = 1,
					x = 65,
					y = 28 + 3, --字体额外偏移值
					font = hVar.DEFAULT_FONT,
					width = 290,
					text = "x" .. current_NumTab.prize_code,
				})
				__parent.childUI["labNum"].handle.s:setColor(ccc3(212, 64, 64)) --装备获取令的颜色
				
				--装备获取令的说明
				__parent.childUI["labNote"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = -100,
					y = -5,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "点击开启装备获取令。", --language
					text = hVar.tab_string["__ITEM_PANEL__JIFEN_CHEST_TIP"], --language
				})
				if (current_NumTab.prize_code == 0) then
					--__parent.childUI["labNote"]:setText("您还未获得装备获取令。") --language 
					__parent.childUI["labNote"]:setText(hVar.tab_string["__ITEM_PANEL__JIFEN_CHEST_NOTGET"]) --language 
					__parent.childUI["labNote"].handle.s:setColor(ccc3(128, 128, 128)) --未获得宝箱
				end
			end
		end
		
		--装备获取令底纹（响应按钮事件）
		_frmNode.childUI["net_depletion_fb"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:delete_slot",
			x = ITEM_BAG_OFFSET_X + 160,
			y = ITEM_BAG_OFFSET_Y + 74,
			w = 56,
			h = 56,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下装备获取令事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示装备获取令选中框
				_frmNode.childUI["net_depletion_fb"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
				
				--创建装备获取令tip
				__createDepletionBbTip()
			end,
			
			--滑动装备获取令事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在按钮区域内
					--显示装备获取令选中框
					_frmNode.childUI["net_depletion_fb"].childUI["selectbox"].handle.s:setVisible(true) --显示选中框
					
					--创建装备获取令tip
					__createDepletionBbTip()
				else --如果出了按钮区域，那儿隐藏tip
					--不显示装备获取令选中框
					_frmNode.childUI["net_depletion_fb"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
					
					--删除装备获取令tip
					hApi.safeRemoveT(_frmNode.childUI, "net_depletion_fb_tip")
				end
			end,
			
			--抬起装备获取令事件
			code = function(self, touchX, touchY, sus)
				--不显示装备获取令选中框
				_frmNode.childUI["net_depletion_fb"].childUI["selectbox"].handle.s:setVisible(false) --不显示选中框
				
				--删除装备获取令tip
				hApi.safeRemoveT(_frmNode.childUI, "net_depletion_fb_tip")
				
				--在按钮区域内部点击到
				if (sus == 1) then
					if (current_NumTab.prize_code > 0) then --存在装备获取令
						self:setstate(0)
						if g_cur_net_state == -1 then
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion2_Net"],{
								font = hVar.FONTC,
								ok = function()
								end,
							})
						elseif g_cur_net_state == 1 then
							if LuaCheckPlayerBagCanUse() == 0 then
								hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL3"],{
									font = hVar.FONTC,
									ok = function()
										
									end,
								})
								self:setstate(1)
								return
							end
							
							hGlobal.event:event("LocalEvent_Phone_ShowHeroEquip")
							self:setstate(1)
						end
					end
				end
			end,
		})
		_frmNode.childUI["net_depletion_fb"].handle.s:setOpacity(0) --用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_fb"
		
		--装备获取令图标
		_frmNode.childUI["net_depletion_fb"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_fb"].handle._n,
			model = "ICON:BF",
			x = 0,
			y = -4,
			scale = 0.9,
		})
		if (current_NumTab.prize_code == 0) then
			--hApi.AddShader(_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s, "gray") --灰色
			_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s:setVisible(false) --不显示
		end
		
		--装备获取选中框
		_frmNode.childUI["net_depletion_fb"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["net_depletion_fb"].handle._n,
			model = "UI:Tactic_Selected",
			x = 0,
			y = 0,
			w = 64,
			h = 64,
		})
		_frmNode.childUI["net_depletion_fb"].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
		
		--装备获取令数量文字
		_frmNode.childUI["net_depletion_fb_lab"] = hUI.label:new({
			parent = _parentNode,
			size = 16,
			align = "MC",
			font = "numWhite",
			x = ITEM_BAG_OFFSET_X - ITEM_ICON_EDGE / 2 + ITEM_ICON_EDGE * 3 + 22,
			y = ITEM_BAG_OFFSET_Y + 48,
			width = 100,
			text = current_NumTab.prize_code,
		})
		if (current_NumTab.prize_code == 0) then
			_frmNode.childUI["net_depletion_fb_lab"].handle.s:setVisible(false) --不显示文字
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "net_depletion_fb_lab"
	end
	]]
	
	--[[
	--函数：更新宝箱界面
	RefreshChestFrame = function(NumTab)
		if (type(NumTab) == "table") then
			--存储本地数据
			current_NumTab = NumTab
			
			--print("更新宝箱界面", current_NumTab.chest_gold, current_NumTab.chest_silver, current_NumTab.chest_cuprum, current_NumTab.prize_code)
			
			--更新宝箱界面
			local _frm = hGlobal.UI.PhoneItemFrm
			local _frmNode = _frm.childUI["PageNode"]
			local _parentNode = _frmNode.handle._n
			
			--黄金宝箱
			_frmNode.childUI["net_depletion_gold_lab"]:setText(current_NumTab.chest_gold)
			if (current_NumTab.chest_gold <= 0) then
				_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s:setVisible(false)
				--hApi.AddShader(_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s, "gray")
				_frmNode.childUI["net_depletion_gold_lab"].handle.s:setVisible(false)
			else
				_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s:setVisible(true)
				--hApi.AddShader(_frmNode.childUI["net_depletion_gold"].childUI["image"].handle.s, "normal")
				_frmNode.childUI["net_depletion_gold_lab"].handle.s:setVisible(true)
			end
			
			--白银宝箱数量
			_frmNode.childUI["net_depletion_silver_lab"]:setText(current_NumTab.chest_silver)
			if (current_NumTab.chest_silver <= 0) then
				_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s:setVisible(false)
				--hApi.AddShader(_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s, "gray")
				_frmNode.childUI["net_depletion_silver_lab"].handle.s:setVisible(false)
			else
				--_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s:setVisible(true)
				hApi.AddShader(_frmNode.childUI["net_depletion_silver"].childUI["image"].handle.s, "normal")
				_frmNode.childUI["net_depletion_silver_lab"].handle.s:setVisible(true)
			end
			
			--青铜宝箱数量
			_frmNode.childUI["net_depletion_bronze_lab"]:setText(current_NumTab.chest_cuprum)
			if (current_NumTab.chest_cuprum <= 0) then
				_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s:setVisible(false)
				--hApi.AddShader(_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s, "gray")
				_frmNode.childUI["net_depletion_bronze_lab"].handle.s:setVisible(false)
			else
				_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s:setVisible(true)
				--hApi.AddShader(_frmNode.childUI["net_depletion_bronze"].childUI["image"].handle.s, "normal")
				_frmNode.childUI["net_depletion_bronze_lab"].handle.s:setVisible(true)
			end
			
			--装备获取令数量
			_frmNode.childUI["net_depletion_fb_lab"]:setText(current_NumTab.prize_code)
			if (current_NumTab.prize_code <= 0) then
				_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s:setVisible(false)
				--hApi.AddShader(_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s, "gray")
				_frmNode.childUI["net_depletion_fb_lab"].handle.s:setVisible(false)
			else
				_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s:setVisible(true)
				--hApi.AddShader(_frmNode.childUI["net_depletion_fb"].childUI["image"].handle.s, "normal")
				_frmNode.childUI["net_depletion_fb_lab"].handle.s:setVisible(true)
			end
		end
	end
	]]
	
	--函数：创建出售道具图标按钮
	OnCreateSellItemBtn = function(pageIdx, bagIdx, sellIdx)
		--print("OnCreateSellItemBtn", pageIdx, bagIdx, sellIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local itemId = Save_PlayerData.bag[bagIdx][1]
		local sell1_x = _frmNode.childUI["SellItemBG1"].data.x
		local sell1_y = _frmNode.childUI["SellItemBG1"].data.y
		local to_x = sell1_x + (sellIdx - 1) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2
		local to_y = sell1_y
		if (sellIdx > SELL_ITEM_X_NUM) then --换行
			to_x = sell1_x + (sellIdx - 1 - SELL_ITEM_X_NUM) * ITEM_ICON_EDGE - ITEM_ICON_EDGE / 2
			to_y = sell1_y - ITEM_ICON_EDGE
		end
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		
		--绘制出售道具图标（按钮响应）
		local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			itemModel = "ICON:Back_red2_item"
		end
		_frmNode.childUI["sellItem" .. sellIdx] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:SkillSlot",
			model = itemModel,
			x = to_x,
			y = to_y,
			w = ITEM_ICON_EDGE - 6,
			h = ITEM_ICON_EDGE - 6,
			z = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下出售道具图标事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示选中框
				self.childUI["selectbox"] = hUI.image:new({
					parent = self.handle._n,
					model = "UI:Tactic_Selected",
					x = 0,
					y = 0,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
				})
			end,
			
			--滑动出售道具图标事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在内部，显示选中框
					self.childUI["selectbox"].handle.s:setVisible(true)
				else --在外部，不显示选中框
					self.childUI["selectbox"].handle.s:setVisible(false)
				end
			end,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus, bNoAction)
				--删除选中框
				hApi.safeRemoveT(self.childUI, "selectbox") --选中框
				
				--如果在内部，那么将按钮飞到原背包的位置
				if (sus == 1) then
					local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
					if (modBagIdx == 0) then
						modBagIdx = BAG_X_NUM * BAG_Y_NUM
					end
					local xi = modBagIdx % BAG_X_NUM --xi
					if (xi == 0) then
						xi = BAG_X_NUM
					end
					local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
					
					--飞到的位置
					local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
					local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
					
					local actionNum = current_sell_num - self.data.index --影响的数量
					local finishNum = 0 --完成动画的数量
					
					--全部动画完成之后的回调
					local OnActionEnd = function() --所有的道具都挪好了位置
						--删除自身控件
						local idx = self.data.index
						hApi.safeRemoveT(_frmNode.childUI, "sellItem" .. idx)
						
						--标记背包栏当前不是待出售状态
						local bagItem = _frmNode.childUI["Item" .. bagIdx]
						bagItem.data.tosell = 0
						
						--删除背包栏出售标记
						hApi.safeRemoveT(bagItem.childUI, "flag")
						
						--原道具变亮
						bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
						bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
						
						--重绘出售道具按钮
						for i = idx + 1, current_sell_num, 1 do
							--print("重绘出售道具按钮", i)
							local ctrlI = _frmNode.childUI["sellItem" .. i]
							local ctrlI_bagIdx = ctrlI.data.bagIndex
							local ctrlI_index = ctrlI.data.index
							hApi.safeRemoveT(_frmNode.childUI, "sellItem" .. i)
							
							OnCreateSellItemBtn(pageIdx, ctrlI_bagIdx, ctrlI_index - 1)
						end
						
						--标记出售道具数量减1
						current_sell_num = current_sell_num - 1
						
						--for i = 1, current_sell_num, 1 do
						--	print(i, _frmNode.childUI["sellItem" .. i].data.index)
						--end
						
						--刷新出售价格和按钮控件
						RefreshSellItemNoteFrm()
					end
					
					--动画1：出售的道具飞到原背包栏
					local moveTo = CCMoveTo:create(0.1, ccp(posX, posY)) --移动
					local callback = CCCallFunc:create(function() --回调
						--这里
						if (actionNum == 0) then
							--print("OnActionEnd1")
							OnActionEnd()
						end
					end)
					local sequence = CCSequence:createWithTwoActions(moveTo, callback)
					
					if bNoAction then --无动画
						OnActionEnd()
					else
						self.handle._n:runAction(sequence) --action
					end
					
					--动画2：后面出售的道具都往前挪一格
					--print("当前位置", self.data.index)
					for i = self.data.index + 1, current_sell_num, 1 do
						local ctrlI = _frmNode.childUI["sellItem" .. i]
						local toXI = _frmNode.childUI["sellItem" .. (i - 1)].data.x
						local toYI = _frmNode.childUI["sellItem" .. (i - 1)].data.y
						local movetoI = CCMoveTo:create(0.1, ccp(toXI, toYI)) --移动
						local callbackI = CCCallFunc:create(function() --回调
							--设置逻辑位置
							--print("重置位置", i, toXI)
							--ctrlI:setXY(toXI, toYI)
							
							--标记自己动画完成
							finishNum = finishNum + 1
							if (finishNum == actionNum) then
								--print("OnActionEnd2")
								OnActionEnd()
							end
						end)
						local sequenceI = CCSequence:createWithTwoActions(movetoI, callbackI)
						ctrlI.handle._n:runAction(sequenceI) --action
					end
				end
			end,
		})
		
		_frmNode.childUI["sellItem" .. sellIdx].handle.s:setOpacity(255) --设置道具背景默认灰度
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			_frmNode.childUI["sellItem" .. sellIdx].handle.s:setOpacity(255) --神器更亮些
		end
		_frmNode.childUI["sellItem" .. sellIdx].data.index = sellIdx --标记它自身的索引值
		_frmNode.childUI["sellItem" .. sellIdx].data.bagIndex = bagIdx --标记背包的索引值
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "sellItem" .. sellIdx
		
		--绘制出售道具图标
		_frmNode.childUI["sellItem" .. sellIdx].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["sellItem" .. sellIdx].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE - 12,
			h = ITEM_ICON_EDGE - 12,
		})
	end
	
	--函数：刷新出售道具价格和按钮控件
	RefreshSellItemNoteFrm = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--统计出售的总积分获得
		local jifenGetSum = 0
		for i = 1, current_sell_num, 1 do
			local ctrlI = _frmNode.childUI["sellItem" .. i]
			local ctrlI_bagIdx = ctrlI.data.bagIndex --出售道具的背包索引值
			local itemId = Save_PlayerData.bag[ctrlI_bagIdx][1]
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			local sellJiFen = itemLv * 10
			
			jifenGetSum = jifenGetSum + sellJiFen
		end
		
		_frmNode.childUI["JiFenSellAward"]:setText("+" .. jifenGetSum)
		
		--判断按钮是否可点
		if (current_sell_num == 0) then
			hApi.AddShader(_frmNode.childUI["btnSell"].handle.s, "gray")
		else
			hApi.AddShader(_frmNode.childUI["btnSell"].handle.s, "normal")
		end
	end
	
	--函数：创建道具出售界面（第1个分页）
	OnCreateShopSellFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 110 --统一偏移x
		local OFFSET_Y = -70 --统一偏移y
		
		--初始化当前出售数量
		current_sell_num = 0
		
		--如果是只显示指定该分页，那么背景加蒙版铺满
		if (SpecifyShowPageIdx > 0) then
			--[[
			--mengban10
			_frmNode.childUI["mengban10"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 176,
				y = PAGE_BTN_LEFT_Y - 256,
				w = 580,
				h = 536,
				--model = "misc/mask.png",
				model = "UI:Tactic_Background",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban10"
			]]
		end
		
		--如果是只显示指定该分页，显示标题
		if (SpecifyShowPageIdx > 0) then
			--加上标题
			_frmNode.childUI["PageTiele"] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + 190,
				y = OFFSET_Y + 47,
				size = 36,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 300,
				--text = "道具" .. tTexts[SpecifyShowPageIdx], --language
				text = hVar.tab_string["__TEXT_MAINUI_BTN_ITEM"] .. tTexts[SpecifyShowPageIdx], --language
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "PageTiele"
		end
		
		--提示出售道具的说明文字
		_frmNode.childUI["SellIntro"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 30,
			y = OFFSET_Y - 10,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 380,
			border = 1,
			--text = "将道具拖拽到此处以出售", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_HINT"], --language
		})
		_frmNode.childUI["SellIntro"].handle.s:setColor(ccc3(192, 192, 192))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SellIntro"
		
		--出售规则介绍按钮（响应区域）
		_frmNode.childUI["btnSellIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 400,
			y = OFFSET_Y - 20,
			w = 70,
			h = 70,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建出售介绍tip
				OnCreateItemSellTipFrame()
			end,
		})
		_frmNode.childUI["btnSellIntro"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSellIntro"
		--出售规则介绍图标
		_frmNode.childUI["btnSellIntro"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnSellIntro"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 10,
			w = 45,
			h = 45,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.02, 1.02) ,CCScaleTo:create(1.0, 0.98, 0.98))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnSellIntro"].childUI["icon"].handle._n:runAction(forever)
		
		--出售池子
		_frmNode.childUI["SellChip"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 185,
			y = OFFSET_Y - 150,
			w = 540,
			h = 500,
		})
		_frmNode.childUI["SellChip"].handle.s:setOpacity(0) --出售池子的底纹，只用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SellChip"
		
		--依次绘制出售的底板（底板图是2个格子拼一起的）
		for xi = 1, SELL_ITEM_X_NUM / 2, 1 do
			for yi = 1, SELL_ITEM_Y_NUM, 1 do
				local idx = (yi - 1) * SELL_ITEM_X_NUM / 2 + xi
				--print(idx)
				_frmNode.childUI["SellItemBG" .. idx] = hUI.image:new({
					parent = _parentNode,
					model = "ICON:bag_slot",
					x = OFFSET_X + 50 + (xi - 1) * ITEM_ICON_EDGE * 2,
					y = OFFSET_Y - 100 - (yi - 1) * ITEM_ICON_EDGE,
					w = ITEM_ICON_EDGE * 2,
					h = ITEM_ICON_EDGE,
				})
				leftRemoveFrmList[#leftRemoveFrmList + 1] = "SellItemBG" .. idx
			end
		end
		
		--出售的图片
		_frmNode.childUI["Sell_BG_Img"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:AttrBg",
			x = OFFSET_X + 190,
			y = OFFSET_Y - 350,
			w = 380,
			h = 40,
		})
		--_frmNode.childUI["Sell_BG_Img"].handle._n:setVisible(false) --默认不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Sell_BG_Img"
		
		--提示本次一共出售以下道具文本
		_frmNode.childUI["SellItemListTip"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 170,
			y = OFFSET_Y - 350 - 3,
			size = 26,
			font = hVar.FONTC,
			align = "RC",
			width = 500,
			border = 1,
			--text = "出售后可得", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_NOTE"], --language
		})
		_frmNode.childUI["SellItemListTip"].handle.s:setColor(ccc3(255, 255, 255))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SellItemListTip"
		
		--出售获得的积分图标
		_frmNode.childUI["JiFenIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 200,
			y = OFFSET_Y - 350 - 1,
			w = 28,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenIcon"
		
		--出售获得的积分数值
		_frmNode.childUI["JiFenSellAward"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 220,
			y = OFFSET_Y - 350 - 1 - 2, --numWhite字体偏移2像素
			size = 24,
			font = "numWhite",
			align = "LC",
			width = 200,
			text = "+0",
		})
		_frmNode.childUI["JiFenSellAward"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenSellAward"
		
		--一键添加按钮
		_frmNode.childUI["btnCollect"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 180 - 120,
			y = OFFSET_Y - 435,
			w = 160,
			h = 50,
			--label = "一键添加", --language
			--label = hVar.tab_string["__ITEM_PANEL__PAGE_COLLECT"], --language
			--font = hVar.FONTC,
			--border = 1,
			label = {text = hVar.tab_string["__ITEM_PANEL__PAGE_COLLECT"], size = 29, font = hVar.FONTC, border = 1, x = 0, y = -1,},
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--一键添加道具逻辑
				OnCollectItemFunc()
			end,
		})
		--hApi.AddShader(_frmNode.childUI["btnCollect"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnCollect"
		
		--确定出售按钮
		_frmNode.childUI["btnSell"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 180 + 120,
			y = OFFSET_Y - 435,
			w = 160,
			h = 50,
			--label = "出售", --language
			--label = hVar.tab_string["__ITEM_PANEL__PAGE_SELL"], --language
			label = {text = hVar.tab_string["__ITEM_PANEL__PAGE_SELL"], size = 31, font = hVar.FONTC, border = 1, x = 0, y = -1,},
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--出售道具逻辑
				OnSellItemFunc()
			end,
		})
		hApi.AddShader(_frmNode.childUI["btnSell"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSell"
	end
	
	--函数：获得触控当前聚焦的背包的索引值
	GetTouchFocusBagIndex = function(touchX, touchY, pageIdx)
		local centerX = touchX + bag_touch_dx --触控的道具的实际中心点x
		local centerY = touchY + bag_touch_dy --触控的道具的实际中心点y
		
		local bagIdxX = 0 --背包的索引值x
		local bagIdxY = 0 --背包的索引值y
		
		--依次检测在哪个背包格子里
		for xi = 1, BAG_X_NUM, 1 do
			for yi = 1, BAG_Y_NUM, 1 do
				local bx = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
				local by = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
				local bw = ITEM_ICON_EDGE
				local bh = ITEM_ICON_EDGE
				local left = bx - bw / 2
				local right = bx + bw / 2
				local top = by - bh / 2
				local bottom = by + bh / 2
				
				if (centerX >= left) and (centerX < right) and (centerY >= top) and (centerY < bottom) then
					bagIdxX = xi --背包的索引值x
					bagIdxY = yi --背包的索引值y
					
					break
				end
			end
			
			--是否已找到了
			if (bagIdxX > 0) then
				break
			end
		end
		
		--如果还是没有找到
		if (bagIdxX == 0) then
			local _frm = hGlobal.UI.PhoneItemFrm
			local _frmNode = _frm.childUI["PageNode"]
			local _parentNode = _frmNode.handle._n
			
			if (pageIdx == 1) then --在第1个分页：出售分页
				--检测是否在出售池范围内
				local sellCtrl = _frmNode.childUI["SellChip"]
				local sell_x = sellCtrl.data.x
				local sell_y = sellCtrl.data.y
				local sell_w = sellCtrl.data.w
				local sell_h = sellCtrl.data.h
				--print(sell_x, sell_y, sell_w, sell_h)
				
				local sell_left = sell_x - sell_w / 2
				local sell_right = sell_x + sell_w / 2
				local sell_top = sell_y - sell_h / 2
				local sell_bottom = sell_y + sell_h / 2
				--print(centerX, centerY)
				--print(sell_left, sell_right, sell_top, sell_bottom)
				--print()
				if (centerX >= sell_left) and (centerX < sell_right) and (centerY >= sell_top) and (centerY < sell_bottom) then
					bagIdxX = 10001 --背包的索引值x（特殊值，用于表示是出售）
					bagIdxY = 10001 --背包的索引值y（特殊值，用于表示是出售）
				end
			elseif (pageIdx == 2) then --在第2个分页：合成分页
				--检测是否在主合成道具范围内
				local mainItemCtrl = _frmNode.childUI["MainItemImg"]
				local mainItem_x = mainItemCtrl.data.x
				local mainItem_y = mainItemCtrl.data.y
				local mainItem_w = mainItemCtrl.data.w
				local mainItem_h = mainItemCtrl.data.h
				
				local mainItem_left = mainItem_x - mainItem_w / 2
				local mainItem_right = mainItem_x + mainItem_w / 2
				local mainItem_top = mainItem_y - mainItem_h / 2
				local mainItem_bottom = mainItem_y + mainItem_h / 2
				
				if (centerX >= mainItem_left) and (centerX < mainItem_right) and (centerY >= mainItem_top) and (centerY < mainItem_bottom) then
					bagIdxX = 20000 --背包的索引值x（特殊值，用于表示是主合成道具）
					bagIdxY = 20000 --背包的索引值y（特殊值，用于表示是主合成道具）
				end
				
				--检查是否在辅合成道具范围内
				if (bagIdxX == 0) then --还是没找到
					for i = 1, hVar.ITEM_MERGE_LIMIT_COUNT, 1 do
						local matItemCtrli = _frmNode.childUI["MaterialItemImg" .. i]
						local matItem_x = matItemCtrli.data.x
						local matItem_y = matItemCtrli.data.y
						local matItem_w = matItemCtrli.data.w
						local matItem_h = matItemCtrli.data.h
						
						local matItem_left = matItem_x - matItem_w / 2
						local matItem_right = matItem_x + matItem_w / 2
						local matItem_top = matItem_y - matItem_h / 2
						local matItem_bottom = matItem_y + matItem_h / 2
						
						if (centerX >= matItem_left) and (centerX < matItem_right) and (centerY >= matItem_top) and (centerY < matItem_bottom) then
							bagIdxX = 20000 + i --背包的索引值x（特殊值，用于表示是辅合成道具）
							bagIdxY = 20000 + i --背包的索引值y（特殊值，用于表示是辅合成道具）
							break
						end
					end
				end
			elseif (pageIdx == 3) then --在第3个分页：洗炼分页
				--检测是否在洗炼道具范围内
				local xilianChipCtrl = _frmNode.childUI["XiLianChip"]
				local xilianChip_x = xilianChipCtrl.data.x
				local xilianChip_y = xilianChipCtrl.data.y
				local xilianChip_w = xilianChipCtrl.data.w
				local xilianChip_h = xilianChipCtrl.data.h
				
				local xilianChip_left = xilianChip_x - xilianChip_w / 2
				local xilianChip_right = xilianChip_x + xilianChip_w / 2
				local xilianChip_top = xilianChip_y - xilianChip_h / 2
				local xilianChip_bottom = xilianChip_y + xilianChip_h / 2
				
				if (centerX >= xilianChip_left) and (centerX < xilianChip_right) and (centerY >= xilianChip_top) and (centerY < xilianChip_bottom) then
					bagIdxX = 30000 --背包的索引值x（特殊值，用于表示是洗炼道具）
					bagIdxY = 30000 --背包的索引值y（特殊值，用于表示是洗炼道具）
				end
			end
		end
		
		--print(bagIdxX, bagIdxY)
		return bagIdxX, bagIdxY
	end
	
	--函数：获得指定背包索引值的控件中心点的屏幕坐标
	GetBagIndexTouchFocus = function(bagIdx)
		local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
		if (modBagIdx == 0) then
			modBagIdx = BAG_X_NUM * BAG_Y_NUM
		end
		local xi = modBagIdx % BAG_X_NUM --xi
		if (xi == 0) then
			xi = BAG_X_NUM
		end
		local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
		
		--位置
		local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
		local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
		
		return posX, posY
	end
	
	--函数：创建主合成道具图标按钮
	OnCreateMainMergeItemBtn = function(pageIdx, bagIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local itemId = Save_PlayerData.bag[bagIdx][1]
		local mainItem_x = _frmNode.childUI["MainItemImg"].data.x
		local mainItem_y = _frmNode.childUI["MainItemImg"].data.y
		local to_x = mainItem_x
		local to_y = mainItem_y
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		
		--绘制主合成道具图标（按钮响应）
		local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			itemModel = "ICON:Back_red2_item"
		end
		_frmNode.childUI["MainItem"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:SkillSlot",
			model = itemModel,
			x = to_x,
			y = to_y,
			w = ITEM_ICON_EDGE - 6,
			h = ITEM_ICON_EDGE - 6,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			z = 100,
			
			--按下出售道具图标事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示选中框
				self.childUI["selectbox"] = hUI.image:new({
					parent = self.handle._n,
					model = "UI:Tactic_Selected",
					x = 0,
					y = 0,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
				})
			end,
			
			--滑动出售道具图标事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在内部，显示选中框
					self.childUI["selectbox"].handle.s:setVisible(true)
				else --在外部，不显示选中框
					self.childUI["selectbox"].handle.s:setVisible(false)
				end
			end,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus)
				--删除选中框
				hApi.safeRemoveT(self.childUI, "selectbox") --选中框
				
				--如果在内部，那么将按钮飞到原背包的位置
				if (sus == 1) then
					local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
					if (modBagIdx == 0) then
						modBagIdx = BAG_X_NUM * BAG_Y_NUM
					end
					local xi = modBagIdx % BAG_X_NUM --xi
					if (xi == 0) then
						xi = BAG_X_NUM
					end
					local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
					
					--飞到的位置
					local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
					local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
					
					--全部动画完成之后的回调
					local OnActionEnd = function() --所有的道具都挪好了位置
						--删除自身控件
						hApi.safeRemoveT(_frmNode.childUI, "MainItem")
						
						--标记背包栏当前不是待出售状态
						local bagItem = _frmNode.childUI["Item" .. bagIdx]
						bagItem.data.tosell = 0
						
						--删除背包栏主合成道具标记
						hApi.safeRemoveT(bagItem.childUI, "flag")
						hApi.safeRemoveT(bagItem.childUI, "star")
						
						--原道具变亮
						bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
						bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
						
						--标记主合成栏的道具为0
						current_main_itemIdx = 0
						
						--刷新合成道具价格和按钮控件
						RefreshMergeItemNoteFrm()
					end
					
					--动画1：出售的道具飞到原背包栏
					local moveTo = CCMoveTo:create(0.1, ccp(posX, posY)) --移动
					local callback = CCCallFunc:create(function() --回调
						OnActionEnd()
					end)
					local sequence = CCSequence:createWithTwoActions(moveTo, callback)
					self.handle._n:runAction(sequence) --action
				end
			end,
		})
		
		_frmNode.childUI["MainItem"].handle.s:setOpacity(255) --设置道具背景默认灰度
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			_frmNode.childUI["MainItem"].handle.s:setOpacity(255) --神器更亮些
		end
		_frmNode.childUI["MainItem"].data.index = sellIdx --标记它自身的索引值
		_frmNode.childUI["MainItem"].data.bagIndex = bagIdx --标记背包的索引值
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MainItem"
		
		--绘制主合成道具图标
		_frmNode.childUI["MainItem"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["MainItem"].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE - 12,
			h = ITEM_ICON_EDGE - 12,
		})
		
		--标记主合成栏的道具索引值
		current_main_itemIdx = bagIdx
		
		--刷新合成道具价格和按钮控件
		RefreshMergeItemNoteFrm()
	end
	
	--函数：创建辅合成道具图标按钮
	OnCreateMaterialMergeItemBtn = function(pageIdx, bagIdx, mergePos)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local itemId = Save_PlayerData.bag[bagIdx][1]
		local matItem_x = _frmNode.childUI["MaterialItemImg" .. mergePos].data.x
		local matItem_y = _frmNode.childUI["MaterialItemImg" .. mergePos].data.y
		local to_x = matItem_x
		local to_y = matItem_y
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		
		--绘制辅合成道具图标（按钮响应）
		_frmNode.childUI["MaterialItem" .. mergePos] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			--model = hVar.ITEMLEVEL[itemLv].ITEMMODEL,
			x = to_x,
			y = to_y,
			w = ITEM_ICON_EDGE - 6,
			h = ITEM_ICON_EDGE - 6,
			z = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			
			--按下出售道具图标事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示选中框
				self.childUI["selectbox"] = hUI.image:new({
					parent = self.handle._n,
					model = "UI:Tactic_Selected",
					x = 0,
					y = 0,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
				})
			end,
			
			--滑动出售道具图标事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在内部，显示选中框
					self.childUI["selectbox"].handle.s:setVisible(true)
				else --在外部，不显示选中框
					self.childUI["selectbox"].handle.s:setVisible(false)
				end
			end,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus)
				--删除选中框
				hApi.safeRemoveT(self.childUI, "selectbox") --选中框
				
				--如果在内部，那么将按钮飞到原背包的位置
				if (sus == 1) then
					local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
					if (modBagIdx == 0) then
						modBagIdx = BAG_X_NUM * BAG_Y_NUM
					end
					local xi = modBagIdx % BAG_X_NUM --xi
					if (xi == 0) then
						xi = BAG_X_NUM
					end
					local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
					
					--飞到的位置
					local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
					local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
					
					--全部动画完成之后的回调
					local OnActionEnd = function() --所有的道具都挪好了位置
						--删除自身控件
						hApi.safeRemoveT(_frmNode.childUI, "MaterialItem" .. mergePos)
						
						--标记背包栏当前不是待出售状态
						local bagItem = _frmNode.childUI["Item" .. bagIdx]
						bagItem.data.tosell = 0
						
						--删除背包栏出售标记
						hApi.safeRemoveT(bagItem.childUI, "flag")
						
						--原道具变亮
						bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
						bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
						
						--标记辅合成栏的道具为0
						current_material_itemIdxList[mergePos] = 0
						
						--刷新合成道具价格和按钮控件
						RefreshMergeItemNoteFrm()
					end
					
					--动画1：出售的道具飞到原背包栏
					local moveTo = CCMoveTo:create(0.1, ccp(posX, posY)) --移动
					local callback = CCCallFunc:create(function() --回调
						OnActionEnd()
					end)
					local sequence = CCSequence:createWithTwoActions(moveTo, callback)
					self.handle._n:runAction(sequence) --action
				end
			end,
		})
		
		_frmNode.childUI["MaterialItem" .. mergePos].handle.s:setOpacity(0) --辅助合成道具只用于响应事件，不显示
		
		_frmNode.childUI["MaterialItem" .. mergePos].data.index = sellIdx --标记它自身的索引值
		_frmNode.childUI["MaterialItem" .. mergePos].data.bagIndex = bagIdx --标记背包的索引值
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MaterialItem" .. mergePos
		
		--绘制辅合成道具图标
		_frmNode.childUI["MaterialItem" .. mergePos].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["MaterialItem" .. mergePos].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE - 12,
			h = ITEM_ICON_EDGE - 12,
		})
		
		--绘制辅合成道具名字
		_frmNode.childUI["MaterialItem" .. mergePos].childUI["itemName"] = hUI.label:new({
			parent = _frmNode.childUI["MaterialItem" .. mergePos].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = -ITEM_ICON_EDGE / 2 - 20,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 380,
			border = 1,
			text = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId),
		})
		local r = hVar.ITEMLEVEL[itemLv].NAMERGB[1]
		local g = hVar.ITEMLEVEL[itemLv].NAMERGB[2]
		local b = hVar.ITEMLEVEL[itemLv].NAMERGB[3]
		_frmNode.childUI["MaterialItem" .. mergePos].childUI["itemName"].handle.s:setColor(ccc3(r, g, b)) --对应品质的颜色
		
		--标记辅合成栏的道具索引值
		current_material_itemIdxList[mergePos] = bagIdx
		
		--刷新合成道具价格和按钮控件
		RefreshMergeItemNoteFrm()
	end
	
	--函数：创建合成道具价格和按钮控件
	RefreshMergeItemNoteFrm = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_main_itemIdx == 0) then --如果没有主合成道具，合成价格为0，也不能合成
			_frmNode.childUI["JiFenMergeRequire"]:setText(0)
			_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(false)
			_frmNode.childUI["Merge_PossibleLabel"]:setText("")
			hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "gray")
		else
			local materialCount = 0 --辅合成道具的有效数量
			for i = 1, #current_material_itemIdxList, 1 do
				if (current_material_itemIdxList[i] ~= 0) then
					materialCount = materialCount + 1
				end
			end
			
			--主合成道具的等级、价值
			local itemMain = Save_PlayerData.bag[current_main_itemIdx]
			local itemIdMain =  itemMain[1] --主合成道具id
			local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
			
			if (materialCount == 0) then --如果没有辅合成道具，合成价格为0，也不能合成
				_frmNode.childUI["JiFenMergeRequire"]:setText(0)
				_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(false)
				_frmNode.childUI["Merge_PossibleLabel"]:setText("")
				hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "gray")
			elseif (nRequireLv >= 99) then --需求等级太高，该道具不能进行合成
				_frmNode.childUI["JiFenMergeRequire"]:setText(0)
				_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(false)
				_frmNode.childUI["Merge_PossibleLabel"]:setText("")
				hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "gray")
			else --可以合成
				--计算合成需要的积分
				--local itemMain = Save_PlayerData.bag[current_main_itemIdx]
				--local itemIdMain =  itemMain[1] --主合成道具id
				local itemLvMain = hVar.tab_item[itemIdMain].itemLv or 1 --道具等级
				local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --道具需求等级
				--local jifenMain = hVar.ITEM_MERGE_INFO[itemLvMain][itemLvMain][2] --主合成道具的价格
				local mergeItemMergeInfo = hApi.GetItemMergeInfo(itemLvMain, itemLvMain) --主道具合成信息
				local jifenMain = mergeItemMergeInfo[2] --主合成道具的价格
				local ratioMain = mergeItemMergeInfo[1] --主合成道具的价值
				local jifenRequire = jifenMain --总价格
				local ratioSum = ratioMain --总价值
				for i = 1, #current_material_itemIdxList, 1 do
					if (current_material_itemIdxList[i] ~= 0) then
						local itemi = Save_PlayerData.bag[current_material_itemIdxList[i]]
						local itemIdi =  itemi[1] --主合成道具id
						local itemLvi = hVar.tab_item[itemIdi].itemLv or 1 --道具等级
						--local jifeni = hVar.ITEM_MERGE_INFO[itemLvMain][itemLvi][2] --辅合成道具的价格
						
						local maerialItemMergeInfo = hApi.GetItemMergeInfo(itemLvMain, itemLvi) --辅道具合成信息
						
						local jifeni = maerialItemMergeInfo[2] --辅合成道具的价格
						jifenRequire = jifenRequire + jifeni
						
						local ratio = maerialItemMergeInfo[1] --辅合成道具的价值
						ratioSum = ratioSum + ratio
					end
				end
				
				local currentScore = LuaGetPlayerScore() --玩家当前的积分
				
				--更新积分
				_frmNode.childUI["JiFenMergeRequire"]:setText(jifenRequire)
				
				--更新几率
				local nextLv = itemLvMain + 1
				if (nextLv > hVar.ITEM_QUALITY.GOLD) then --最高合成到黄色
					nextLv = hVar.ITEM_QUALITY.GOLD
				end
				local rate = math.floor(ratioSum / hVar.ITEM_MERGE_VALUE[nextLv] * 100)
				if (rate > 100) then
					rate = 100
				end
				local qualityStr = hVar.ITEMLEVEL[nextLv].label
				local bodyType = hVar.tab_item[itemIdMain].type
				local eqipBodyStr = hVar.ItemTypeStr[bodyType]
				--有??％的几率合成?-?级??品质[??]
				_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(true)
				local lvMin = 1
				local lvMax = 6
				if (nRequireLv > 6) then
					lvMin = 7
					lvMax = 10
				end
				_frmNode.childUI["Merge_PossibleLabel"]:setText("有" .. rate .. "％的几率合成" .. lvMin .. "-" .. lvMax .. "级" .. hVar.tab_string[qualityStr] .. "品质[" .. (hVar.tab_string[eqipBodyStr]) .. "]")
				
				--积分足够，并且放2件辅合成装备，才能进行合成
				if (currentScore >= jifenRequire) and (materialCount >= hVar.ITEM_MERGE_LIMIT_COUNT) then
					--_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(true)
					hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "normal")
				else
					--_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(false)
					hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "gray")
				end
			end
		end
	end
	
	--函数：查看道具出售分页说明tip
	OnCreateItemSellTipFrame = function()
		--先清除上一次的道具合成说明面板
		if hGlobal.UI.ItemSellInfoFrame then
			hGlobal.UI.ItemSellInfoFrame:del()
		end
		
		--创建道具出售说明面板
		hGlobal.UI.ItemSellInfoFrame = hUI.frame:new({
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
		hGlobal.UI.ItemSellInfoFrame:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		local _SkillParent = hGlobal.UI.ItemSellInfoFrame.handle._n
		local _ItemSellChildUI = hGlobal.UI.ItemSellInfoFrame.childUI
		local _offX = BOARD_POS_X + 295
		local _offY = BOARD_POS_Y - 45
		
		--创建道具出售说明tip图片背景
		--[[
		_ItemSellChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 380,
			h = 450,
		})
		_ItemSellChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 380, 450, hGlobal.UI.ItemSellInfoFrame)
		img9:setOpacity(204)
		
		--创建道具出售介绍tip-标题
		_ItemSellChildUI["ItemMergeName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 100,
			y = _offY - 45,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "道具出售介绍", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_TIP_TITLE"], --language
			border = 1,
		})
		_ItemSellChildUI["ItemMergeName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--创建道具出售介绍tip-内容1
		_ItemSellChildUI["ItemMergeContent1"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 75,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "1、出售的装备品质越高，兑换的积分越多。", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_TIP_1"], --language
			border = 1,
		})
		
		--创建道具出售介绍tip-内容2
		_ItemSellChildUI["ItemMergeContent2"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 145,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "2、一键添加会自动补齐白色、蓝色装备到出售栏。", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_TIP_2"], --language
			border = 1,
		})
		
		--创建道具出售介绍tip-内容3
		_ItemSellChildUI["ItemMergeContent3"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 215,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "3、红装、橙装不能出售。", --language
			text = hVar.tab_string["__ITEM_PANEL__SELL_TIP_3"], --language
			border = 1,
		})
	end
	
	--函数：播放道具合成成功动画
	PlayMergeAnimationSuccess = function(mergeBagIdx, retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--播放道具合成的音效
		hApi.PlaySound("burning1")
		
		--主合成道具
		local ctrlM = _frmNode.childUI["MainItem"]
		
		local OnMaterialDone = nil --所有辅动画完成之后的逻辑
		local OnNewItemShow = nil --新道具显示的动画
		local OnItemMoveToBag = nil --新道具飞到背包栏的动画
		local OnAllActionEnd = nil --所有的动画完成事件
		
		local actionNum = 0 --动画的数量
		local finishNum = 0 --动画完成的数量
		
		--所有的辅合成道具向主合成道具运动
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				actionNum = actionNum + 1 --动画数量加1
				local ctrlI = _frmNode.childUI["MaterialItem" .. i]
				
				local toX = ctrlM.data.x
				local toY = ctrlM.data.y
				local moveTo = CCMoveTo:create(0.4, ccp(toX, toY)) --移动
				local callback = CCCallFunc:create(function() --回调
					--删除自身控件
					hApi.safeRemoveT(_frmNode.childUI, "MaterialItem" .. i)
					
					--标记动画完成数量加1
					finishNum = finishNum + 1
					
					--所有辅动画完成，进入下一阶段
					if (actionNum == finishNum) then
						OnMaterialDone()
					end
				end)
				local sequence = CCSequence:createWithTwoActions(moveTo, callback) --播放动画
				ctrlI.handle._n:runAction(sequence) --action
			end
		end
		
		--所有辅动画完成之后的逻辑
		OnMaterialDone = function()
			--动画1：自身主合成道具淡入
			ctrlM.childUI["effect"] = hUI.image:new({
				parent = ctrlM.handle._n,
				model = "MODEL_EFFECT:symbol", --"MODEL_EFFECT:Summon_1",
				x = 0,
				y = -25,
			})
			
			--底纹淡入
			local fadeTime = 0.7 --不能大于0.8
			local fadeOutBG = CCFadeOut:create(fadeTime) --淡入BG
			ctrlM.childUI["icon"].handle.s:runAction(fadeOutBG) --action
			
			local fadeOut = CCFadeOut:create(fadeTime) --淡入
			local callback = CCCallFunc:create(function() --回调
				--删除自身控件
				hApi.safeRemoveT(_frmNode.childUI, "MainItem")
			end)
			local sequence = CCSequence:createWithTwoActions(fadeOut, callback) --播放动画
			ctrlM.handle.s:runAction(sequence) --action
			
			--动画2：新道具产生
			local itemId = Save_PlayerData.bag[mergeBagIdx][1]
			local mainItem_x = _frmNode.childUI["MainItemImg"].data.x
			local mainItem_y = _frmNode.childUI["MainItemImg"].data.y
			local to_x = mainItem_x
			local to_y = mainItem_y
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			
			--绘制新生成的道具
			local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
			if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
				itemModel = "ICON:Back_red2_item"
			end
			_frmNode.childUI["NewItem"] = hUI.button:new({
				parent = _parentNode,
				--model = "UI:SkillSlot",
				model = itemModel,
				x = to_x,
				y = to_y,
				w = ITEM_ICON_EDGE - 6,
				h = ITEM_ICON_EDGE - 6,
				z = 100,
			})
			_frmNode.childUI["NewItem"].handle.s:setOpacity(0) --一开始不显示
			--绘制新生成的道具图标
			_frmNode.childUI["NewItem"].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["NewItem"].handle._n,
				model = hVar.tab_item[itemId].icon,
				x = 0,
				y = 0,
				w = ITEM_ICON_EDGE - 12,
				h = ITEM_ICON_EDGE - 12,
			})
			_frmNode.childUI["NewItem"].childUI["icon"].handle.s:setOpacity(0) --一开始不显示
			
			local ctrlNew = _frmNode.childUI["NewItem"]
			local delayNew1 = CCDelayTime:create(0.6) --等待1
			local callbackNew1 = CCCallFunc:create(function() --回调1
				--冒火特效
				ctrlNew.childUI["effect"] = hUI.image:new({
					parent = ctrlNew.handle._n,
					model = "MODEL_EFFECT:Summon_1",
					x = 0,
					y = -10,
					scale = 1.5,
				})
			end)
			local delayNew2 = CCDelayTime:create(0.6) --等待2
			local callbackNew2 = CCCallFunc:create(function() --回调2
				--删除冒火特效
				hApi.safeRemoveT(ctrlNew.childUI, "effect")
				
				--新道具显示动画
				OnNewItemShow(ctrlNew)
			end)
			local array = CCArray:create()
			array:addObject(delayNew1) --等待1
			array:addObject(callbackNew1) --回调1
			array:addObject(delayNew2) --回调2
			array:addObject(callbackNew2) --回调2
			ctrlNew.handle.s:runAction(CCSequence:create(array)) --action
		end
		
		--新道具显示动画
		OnNewItemShow = function(ctrlNew)
			--播放新道具生成的音效
			hApi.PlaySound("itemupgrade")
			
			local BIGTIME = 0.1 --变大时间
			local SCALE = 4.0 --变大倍率
			local SMALLTIME = 0.1 --变小时间
			
			--燃烧特效
			ctrlNew.childUI["effect"] = hUI.image:new({
				parent = ctrlNew.handle._n,
				--model = "MODEL_EFFECT:Fire02",
				model = -1,
				x = 0,
				y = 5,
				scale = 1.2,
				z = -1,
			})
			
			--新道具动画
			local fadeTo = CCFadeTo:create(0.05, 100) --新道具的底纹透明度为100
			local scaleToBig = CCScaleTo:create(BIGTIME, SCALE) --变大
			local spawn = CCSpawn:createWithTwoActions(fadeTo, scaleToBig) --同步
			local scaleToSmall = CCScaleTo:create(SMALLTIME, 1.0) --变小
			local delay = CCDelayTime:create(1.0) --等待
			local callback = CCCallFunc:create(function() --回调
				--燃烧特效越来越淡
				ctrlNew.childUI["effect"].handle.s:runAction(CCFadeOut:create(0.1)) --action
				
				--新道具飞到背包栏
				OnItemMoveToBag(ctrlNew)
			end)
			
			local array = CCArray:create()
			array:addObject(spawn) --同步
			array:addObject(scaleToSmall) --变小
			array:addObject(delay) --等待
			array:addObject(callback) --回调
			ctrlNew.handle.s:runAction(CCSequence:create(array)) --action
			
			--新道具底纹动画
			local fadeToI = CCFadeTo:create(0.05, 255) --新道具图标变亮
			local scaleToBigI = CCScaleTo:create(BIGTIME, SCALE) --变大
			local spawnI = CCSpawn:createWithTwoActions(fadeToI, scaleToBigI) --同步
			local scaleToSmallI = CCScaleTo:create(SMALLTIME, 1.0) --变小
			local sequenceI = CCSequence:createWithTwoActions(spawnI, scaleToSmallI) --顺序
			ctrlNew.childUI["icon"].handle.s:runAction(sequenceI) --action
		end
		
		--新道具飞到背包栏的动画
		OnItemMoveToBag = function(ctrlNew)
			local modBagIdx = mergeBagIdx % (BAG_X_NUM * BAG_Y_NUM)
			if (modBagIdx == 0) then
				modBagIdx = BAG_X_NUM * BAG_Y_NUM
			end
			local xi = modBagIdx % BAG_X_NUM --xi
			if (xi == 0) then
				xi = BAG_X_NUM
			end
			local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
			local itemId = Save_PlayerData.bag[mergeBagIdx][1] --道具id
			local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
			local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
			
			local moveTo = CCMoveTo:create(0.2, ccp(posX, posY)) --移动
			local callback = CCCallFunc:create(function() --回调
				--删除自身
				hApi.safeRemoveT(_frmNode.childUI, "NewItem")
				
				--在背包栏创建新合成道具
				OnCreateBagItemBtn(2, mergeBagIdx)
				
				--新道具加上"New"的标识
				_frmNode.childUI["Item" .. mergeBagIdx].childUI["new"] = hUI.image:new({
					parent = _frmNode.childUI["Item" .. mergeBagIdx].handle._n,
					model = "UI:shopitemnew",
					x = ITEM_ICON_EDGE - 71,
					y = 8,
					w = 44,
					h = 40,
				})
				
				--如果该道具不在当前分页，那么隐藏显示
				local bagPage = (mergeBagIdx - modBagIdx) / (BAG_X_NUM * BAG_Y_NUM) + 1 --新道具所属的分页页码
				if (bagPage ~= current_bag_page) then
					_frmNode.childUI["Item" .. mergeBagIdx]:setstate(-1)
				end
				
				--所有的动画都已完成
				OnAllActionEnd()
			end)
			
			local array = CCArray:create()
			array:addObject(moveTo) --移动
			array:addObject(callback) --回调
			ctrlNew.handle._n:runAction(CCSequence:create(array)) --action
		end
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--函数：播放道具合成失败动画
	PlayMergeAnimationFail = function(mergeBagIdx, retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--播放道具合成的音效
		hApi.PlaySound("burning1")
		
		--主合成道具
		local ctrlM = _frmNode.childUI["MainItem"]
		
		local OnMaterialDone = nil --所有辅动画完成之后的逻辑
		local OnNewItemShow = nil --新道具显示的动画
		local OnItemMoveToBag = nil --新道具飞到背包栏的动画
		local OnAllActionEnd = nil --所有的动画完成事件
		
		local actionNum = 0 --动画的数量
		local finishNum = 0 --动画完成的数量
		
		--所有的辅合成道具向主合成道具运动
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				actionNum = actionNum + 1 --动画数量加1
				local ctrlI = _frmNode.childUI["MaterialItem" .. i]
				
				local toX = ctrlM.data.x
				local toY = ctrlM.data.y
				local moveTo = CCMoveTo:create(0.4, ccp(toX, toY)) --移动
				local callback = CCCallFunc:create(function() --回调
					--删除自身控件
					hApi.safeRemoveT(_frmNode.childUI, "MaterialItem" .. i)
					
					--标记动画完成数量加1
					finishNum = finishNum + 1
					
					--所有辅动画完成，进入下一阶段
					if (actionNum == finishNum) then
						OnNewItemShow(ctrlM)
					end
				end)
				local sequence = CCSequence:createWithTwoActions(moveTo, callback) --播放动画
				ctrlI.handle._n:runAction(sequence) --action
			end
		end
		
		--新道具显示动画
		OnNewItemShow = function(ctrlNew)
			--播放合成失败的音效
			hApi.PlaySound("FrostBoltLaunch1")
			
			--黑烟特效
			ctrlNew.childUI["effect"] = hUI.image:new({
				parent = ctrlNew.handle._n,
				model = "MODEL_EFFECT:blackfog",
				x = 0,
				y = 5,
				scale = 0.9,
				z = -1,
			})
			ctrlNew.childUI["effect"].handle.s:setOpacity(192)
			
			local delay = CCDelayTime:create(1.5) --等待
			local callback = CCCallFunc:create(function() --回调
				--燃烧特效越来越淡
				ctrlNew.childUI["effect"].handle.s:runAction(CCFadeOut:create(0.1)) --action
				
				--新道具飞到背包栏
				OnItemMoveToBag(ctrlNew)
			end)
			
			local array = CCArray:create()
			array:addObject(delay) --等待
			array:addObject(callback) --回调
			ctrlNew.handle.s:runAction(CCSequence:create(array)) --action
		end
		
		--新道具飞到背包栏的动画
		OnItemMoveToBag = function(ctrlNew)
			local modBagIdx = mergeBagIdx % (BAG_X_NUM * BAG_Y_NUM)
			if (modBagIdx == 0) then
				modBagIdx = BAG_X_NUM * BAG_Y_NUM
			end
			local xi = modBagIdx % BAG_X_NUM --xi
			if (xi == 0) then
				xi = BAG_X_NUM
			end
			local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
			local itemId = Save_PlayerData.bag[mergeBagIdx][1] --道具id
			local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
			local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
			
			local moveTo = CCMoveTo:create(0.2, ccp(posX, posY)) --移动
			local callback = CCCallFunc:create(function() --回调
				--删除自身
				hApi.safeRemoveT(_frmNode.childUI, "MainItem")
				
				--在背包栏创建新合成道具
				OnCreateBagItemBtn(2, mergeBagIdx)
				
				--[[
				--新道具加上"New"的标识
				_frmNode.childUI["Item" .. mergeBagIdx].childUI["new"] = hUI.image:new({
					parent = _frmNode.childUI["Item" .. mergeBagIdx].handle._n,
					model = "UI:shopitemnew",
					x = ITEM_ICON_EDGE - 71,
					y = 8,
					w = 44,
					h = 40,
				})
				]]
				
				--如果该道具不在当前分页，那么隐藏显示
				local bagPage = (mergeBagIdx - modBagIdx) / (BAG_X_NUM * BAG_Y_NUM) + 1 --新道具所属的分页页码
				if (bagPage ~= current_bag_page) then
					_frmNode.childUI["Item" .. mergeBagIdx]:setstate(-1)
				end
				
				--所有的动画都已完成
				OnAllActionEnd()
			end)
			
			local array = CCArray:create()
			array:addObject(moveTo) --移动
			array:addObject(callback) --回调
			ctrlNew.handle._n:runAction(CCSequence:create(array)) --action
		end
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--函数：创建道具合成界面（第2个分页）
	OnCreateShopMergeFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 110 --统一偏移x
		local OFFSET_Y = -70 --统一偏移y
		local _frm = hGlobal.UI.PhoneItemFrm
		
		--重置参数
		--当前主合成道具在背包索引位置
		current_main_itemIdx = 0
		
		--当前辅合成道具id在背包索引位置列表
		current_material_itemIdxList = {0, 0, 0, 0, 0}
		
		--如果是只显示指定该分页，那么背景加蒙版铺满
		if (SpecifyShowPageIdx > 0) then
			--[[
			--mengban1
			_frmNode.childUI["mengban1"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15,
				y = PAGE_BTN_LEFT_Y - 115,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban1"
			
			--mengban2
			_frmNode.childUI["mengban2"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 256,
				y = PAGE_BTN_LEFT_Y - 115,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban2"
			
			--mengban3
			_frmNode.childUI["mengban3"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 323,
				y = PAGE_BTN_LEFT_Y - 115,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban3"
			
			--mengban4
			_frmNode.childUI["mengban4"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15,
				y = PAGE_BTN_LEFT_Y - 115 - 256,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban4"
			
			--mengban5
			_frmNode.childUI["mengban5"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 256,
				y = PAGE_BTN_LEFT_Y - 115 - 256,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban5"
			
			--mengban6
			_frmNode.childUI["mengban6"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 323,
				y = PAGE_BTN_LEFT_Y - 115 - 256,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban6"
			
			--mengban7
			_frmNode.childUI["mengban7"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15,
				y = PAGE_BTN_LEFT_Y - 115 - 256 - 24,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban7"
			
			--mengban8
			_frmNode.childUI["mengban8"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 256,
				y = PAGE_BTN_LEFT_Y - 115 - 256 - 24,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban8"
			
			--mengban9
			_frmNode.childUI["mengban9"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 15 + 323,
				y = PAGE_BTN_LEFT_Y - 115 - 256 - 24,
				w = 256,
				h = 256,
				--model = "misc/mask.png",
				model = "UI:MengBan256", --"misc/mask.png",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban9"
			]]
			
			--[[
			--mengban10
			_frmNode.childUI["mengban10"] = hUI.button:new({
				parent = _parentNode,
				x = PAGE_BTN_LEFT_X + 176,
				y = PAGE_BTN_LEFT_Y - 256,
				w = 580,
				h = 536,
				--model = "misc/mask.png",
				model = "UI:Tactic_Background",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "mengban10"
			]]
		end
		
		--如果是只显示指定该分页，显示标题
		if (SpecifyShowPageIdx > 0) then
			--加上标题
			_frmNode.childUI["PageTiele"] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + 190,
				y = OFFSET_Y + 47,
				size = 36,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 300,
				--text = "道具" .. tTexts[SpecifyShowPageIdx], --language
				text = hVar.tab_string["__TEXT_MAINUI_BTN_ITEM"] .. tTexts[SpecifyShowPageIdx], --language
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "PageTiele"
		end
		
		--提示合成道具的说明文字
		_frmNode.childUI["SellIntro"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 30,
			y = OFFSET_Y - 10,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 380,
			border = 1,
			--text = "将道具拖拽到此处以合成", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_HINT"], --language
		})
		_frmNode.childUI["SellIntro"].handle.s:setColor(ccc3(192, 192, 192))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SellIntro"
		
		--合成规则介绍按钮（响应区域）
		_frmNode.childUI["btnMergeIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 400,
			y = OFFSET_Y - 20,
			w = 70,
			h = 70,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建合成介绍tip
				OnCreateItemMergeTipFrame()
			end,
		})
		_frmNode.childUI["btnMergeIntro"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnMergeIntro"
		--合成规则介绍图标
		_frmNode.childUI["btnMergeIntro"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnMergeIntro"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 10,
			w = 45,
			h = 45,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.02, 1.02) ,CCScaleTo:create(1.0, 0.98, 0.98))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnMergeIntro"].childUI["icon"].handle._n:runAction(forever)
		
		--主物品的背景图
		local main_x = OFFSET_X + 180 --主物品位置x
		local main_y = OFFSET_Y - 200 --主物品位置y
		_frmNode.childUI["MainItemImg"] = hUI.image:new({
			parent = _parentNode,
			x = main_x,
			y = main_y,
			w = 120,
			h = 120,
			model = "UI:item_slot_big",
			--model = "misc/mask.png",
		})
		_frmNode.childUI["MainItemImg"].handle.s:setOpacity(255) --主物品的背景图透明度为255
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MainItemImg"
		
		--辅助合成道具的背景图
		--[[
		local merge_marerial_posList = 
		{
			{x = main_x, y = main_y + 135,}, --正上
			{x = main_x - 130, y = main_y + 40,},
			{x = main_x + 130, y = main_y + 40,},
			{x = main_x - 90, y = main_y - 95,},
			{x = main_x + 90, y = main_y - 95,},
		}
		]]
		local merge_marerial_posList = 
		{
			{x = main_x - 130, y = main_y + 110,},
			{x = main_x + 130, y = main_y + 110,},
		}
		for i = 1, #merge_marerial_posList, 1 do
			--辅合成道具的响应区域控件
			_frmNode.childUI["MaterialItemImg" .. i] = hUI.button:new({
				parent = _parentNode,
				x = merge_marerial_posList[i].x,
				y = merge_marerial_posList[i].y,
				w = 100,
				h = 100,
				model = "misc/mask.png",
			})
			_frmNode.childUI["MaterialItemImg" .. i].handle.s:setOpacity(0) --辅物品的背景图只用于响应事件，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "MaterialItemImg" .. i
			
			--辅合成道具的界面显示小圆圈圈图片
			_frmNode.childUI["MaterialItemImg" .. i].childUI["circle"] = hUI.image:new({
				parent = _frmNode.childUI["MaterialItemImg" .. i].handle._n,
				x = 0,
				y = 0,
				w = 80,
				h = 80,
				model = "UI:item_slot", --"UI:item_slot"
			})
		end
		
		--合成的几率介绍文字图片
		_frmNode.childUI["Merge_Possible_Img"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:AttrBg",
			x = OFFSET_X + 190,
			y = OFFSET_Y - 310,
			w = 450,
			h = 33,
		})
		_frmNode.childUI["Merge_Possible_Img"].handle._n:setVisible(false) --默认不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Merge_Possible_Img"
		
		--合成的几率介绍文字
		_frmNode.childUI["Merge_PossibleLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 180,
			y = OFFSET_Y - 310 - 2, --numWhite字体偏移2像素
			align = "MC",
			width = 700,
			font = hVar.FONTC,
			size = 22,
			text = "",
			--text = "有??％的几率合成?-?级??品质[??]", --language
			--text = hVar.tab_string["__TEXT_CONSUME"], --language
			border = 1,
			z = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Merge_PossibleLabel"
		
		--合成需要的积分前缀"消耗"
		_frmNode.childUI["Merge_JiFenLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 90,
			y = OFFSET_Y - 380 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "LC",
			width = 200,
			font = hVar.FONTC,
			--text = "消耗", --language
			text = hVar.tab_string["__TEXT_CONSUME"], --language
			border = 1,
		})
		_frmNode.childUI["Merge_JiFenLabel"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Merge_JiFenLabel"
		
		--合成需要的积分图标
		_frmNode.childUI["Merge_JiFenIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 160,
			y = OFFSET_Y - 380,
			w = 28,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Merge_JiFenIcon"
		
		--合成需要的积分数值
		_frmNode.childUI["JiFenMergeRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 190,
			y = OFFSET_Y - 380 - 2, --numWhite字体偏移2像素
			size = 24,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "0",
		})
		_frmNode.childUI["JiFenMergeRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenMergeRequire"
		
		--道具合成按钮
		_frmNode.childUI["btnMerge"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 180,
			y = OFFSET_Y - 435,
			w = 160,
			h = 50,
			--label = "合成", --language
			label = hVar.tab_string["__ITEM_PANEL__PAGE_MERGE"], --language
			font = hVar.FONTC,
			border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--合成道具逻辑
				OnMergeItemFunc()
			end,
		})
		hApi.AddShader(_frmNode.childUI["btnMerge"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnMerge"
	end
	
	--函数：合成道具逻辑
	OnMergeItemFunc = function()
		--未联网不能合成道具
		if (g_cur_net_state == -1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_MergeItem_Net"], {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
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
		
		--开始判断，是否可以合成
		
		--如果主合成道具不存在，那么不能合成
		if (current_main_itemIdx == 0) then
			--弹框
			--local strText = "没有主合成道具" --language
			local strText = hVar.tab_string["__TEXT_Cant_NoMainMergeItem_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--如果辅合成道具不存在，那么不能合成
		local materialCount = 0 --辅合成道具的数量
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				materialCount = materialCount + 1
			end
		end
		if (materialCount == 0) then
			--弹框
			--local strText = "没有辅合成道具" --language
			local strText = hVar.tab_string["__TEXT_Cant_NoMaterialMergeItem_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--检查主合成道具是否为装备
		local itemMain = Save_PlayerData.bag[current_main_itemIdx]
		local itemIdMain =  itemMain[1] --主合成道具id
		local itemLvMain = hVar.tab_item[itemIdMain].itemLv or 1 --道具等级
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
		
		--检查主合成道具的品质是否可以合成
		if (not hVar.ITEM_MERGE_LIMIT[itemLvMain]) then
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
		
		--检查辅合成道具的品质是否可以合成
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				local itemi = Save_PlayerData.bag[current_material_itemIdxList[i]]
				local itemIdi =  itemi[1] --主合成道具id
				local itemLvi = hVar.tab_item[itemIdi].itemLv or 1 --道具等级
				if (not hVar.ITEM_MERGE_LIMIT[itemLvi]) then
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
			end
		end
		
		--检查主合成道具的等级是否可以合成
		local nRequireLv = hApi.GetItemRequire(itemIdMain, "level") --需求等级
		if (nRequireLv >= 99) then
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
		
		--计算合成需要的积分
		--local jifenMain = hVar.ITEM_MERGE_INFO[itemLvMain][itemLvMain][2] --主合成道具的价格
		local mergeItemMergeInfo = hApi.GetItemMergeInfo(itemLvMain, itemLvMain) --主道具合成信息
		local jifenMain = mergeItemMergeInfo[2] --主合成道具的价格
		local ratioMain = mergeItemMergeInfo[1] --主合成道具的价值
		local jifenRequire = jifenMain --总价格
		local ratioSum = ratioMain --总价值
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				local itemi = Save_PlayerData.bag[current_material_itemIdxList[i]]
				local itemIdi =  itemi[1] --主合成道具id
				local itemLvi = hVar.tab_item[itemIdi].itemLv or 1 --道具等级
				--local jifeni = hVar.ITEM_MERGE_INFO[itemLvMain][itemLvi][2] --辅合成道具的价格
				
				local maerialItemMergeInfo = hApi.GetItemMergeInfo(itemLvMain, itemLvi) --辅道具合成信息
				
				local jifeni = maerialItemMergeInfo[2] --辅合成道具的价格
				jifenRequire = jifenRequire + jifeni
				
				local ratio = maerialItemMergeInfo[1] --辅合成道具的价值
				ratioSum = ratioSum + ratio
			end
		end
		
		--检测辅合成道具数量是否足够
		if (materialCount < hVar.ITEM_MERGE_LIMIT_COUNT) then
			--弹框
			--local strText = "辅合成道具数量不足" --language
			local strText = hVar.tab_string["__TEXT_Cant_MergeItem5_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		local currentScore = LuaGetPlayerScore() --玩家当前的积分
		if (currentScore < jifenRequire) then
			--弹框
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ScoreNotEnough"], {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			return
		end
		
		--触发事件：合成道具事件
		local mainItemIdx = current_main_itemIdx --主合成道具索引值
		local materialItemIdxist = {} --辅合成道具索引值列表
		for i = 1, #current_material_itemIdxList, 1 do
			if (current_material_itemIdxList[i] ~= 0) then
				table.insert(materialItemIdxist, current_material_itemIdxList[i])
			end
		end
		hGlobal.event:event("Event_ItemMergeEvent", mainItemIdx, materialItemIdxist)
	end
	
	--函数：查看道具合成分页说明tip
	OnCreateItemMergeTipFrame = function()
		--先清除上一次的道具合成说明面板
		if hGlobal.UI.ItemMergeInfoFrame then
			hGlobal.UI.ItemMergeInfoFrame:del()
		end
		
		--创建技能说明面板
		hGlobal.UI.ItemMergeInfoFrame = hUI.frame:new({
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
		hGlobal.UI.ItemMergeInfoFrame:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		local _SkillParent = hGlobal.UI.ItemMergeInfoFrame.handle._n
		local _ItemMergeChildUI = hGlobal.UI.ItemMergeInfoFrame.childUI
		local _offX = BOARD_POS_X + 295
		local _offY = BOARD_POS_Y - 45
		
		--创建技能tip图片背景
		--[[
		_ItemMergeChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 380,
			h = 450,
		})
		_ItemMergeChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 380, 450, hGlobal.UI.ItemMergeInfoFrame)
		img9:setOpacity(204)
		
		--创建道具合成介绍tip-标题
		_ItemMergeChildUI["ItemMergeName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 100,
			y = _offY - 45,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "装备合成介绍", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_TITLE"], --language
			border = 1,
		})
		_ItemMergeChildUI["ItemMergeName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--创建道具合成介绍tip-内容1
		_ItemMergeChildUI["ItemMergeContent1"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 75,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "1、合成时有几率将装备提升到更高品质。", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_1"], --language
			border = 1,
		})
		
		--创建道具合成介绍tip-内容2
		_ItemMergeChildUI["ItemMergeContent2"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 145,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "2、主合成栏为你想要合成出的装备部位。", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_2"], --language
			border = 1,
		})
		
		--创建道具合成介绍tip-内容3
		_ItemMergeChildUI["ItemMergeContent3"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 215,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "3、辅合成栏为该装备提供的材料，需放入2件。", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_3"], --language
			border = 1,
		})
		
		--创建道具合成介绍tip-内容4
		_ItemMergeChildUI["ItemMergeContent4"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 285,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "4、主合成栏放入7级以下装备时，无法合出7级以上装备。", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_4"], --language
			border = 1,
		})
		
		--创建道具合成介绍tip-内容5
		_ItemMergeChildUI["ItemMergeContent5"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 385,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "5、合成失败后，主道具不消失，合成材料会消失。", --language
			text = hVar.tab_string["__ITEM_PANEL__MERGE_TIP_5"], --language
			border = 1,
		})
	end
	
	--函数：更新绘制当前查看的卡牌的信息
	RefreshSelectedCardFrame = function()
		--如果当前未选中分页，不需要更新绘制
		--print("CurrentSelectRecord.pageIdx=", CurrentSelectRecord.pageIdx)
		if (CurrentSelectRecord.pageIdx == 0) then
			return
		end
		
		--重新绘制该分页
		local pageIdx = CurrentSelectRecord.pageIdx
		local contentIdx = CurrentSelectRecord.contentIdx
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		
		--重新绘制该分页
		OnClickPageBtn(pageIdx) --重绘当前分页
		--print("OnClickPageBtn", pageIdx, contentIdx, cardId)
		
		--如果当前未选中页面内的卡牌索引，不需要更新绘制
		if (contentIdx == 0) then
			return
		end
		
		--如果当前未选中卡牌，不需要更新绘制
		if (cardId == 0) then
			return
		end
		
		--[[
		--选中该卡牌
		if (pageIdx == 1) or (pageIdx == 2) or (pageIdx == 3) then --塔的分页
			--点击塔的按钮
			OnClickTowerBtn(pageIdx, contentIdx)
		elseif (pageIdx == 4) then --特殊
			--
		elseif (pageIdx == 5) then --战术技能卡
			--点击战术技能卡的按钮
			OnClickTacticBtn(pageIdx, contentIdx)
		end
		]]
	end
	
	--函数：出售道具逻辑
	OnSellItemFunc = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果当前没有要出售的道具，不需要走出售流程
		if (current_sell_num == 0) then
			return
		end
		
		--未联网不能出售道具
		if (g_cur_net_state == -1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_SellItem_Net"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--统计出售的总积分获得
		local jifenGetSum = 0
		for i = 1, current_sell_num, 1 do
			local ctrlI = _frmNode.childUI["sellItem" .. i]
			local ctrlI_bagIdx = ctrlI.data.bagIndex --出售道具的背包索引值
			local itemId = Save_PlayerData.bag[ctrlI_bagIdx][1]
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			local sellJiFen = itemLv * 10
			
			jifenGetSum = jifenGetSum + sellJiFen
		end
		
		--删除背包内对应的道具和界面
		for i = 1, current_sell_num, 1 do
			local ctrlI = _frmNode.childUI["sellItem" .. i]
			local bagIdx = ctrlI.data.bagIndex
			
			--删除背包控件
			hApi.safeRemoveT(_frmNode.childUI, "Item" .. bagIdx)
			
			--删除存档
			Save_PlayerData.bag[bagIdx] = 0
		end
		
		--删除所有的出售道具界面
		for i = 1, current_sell_num, 1 do
			hApi.safeRemoveT(_frmNode.childUI, "sellItem" .. i)
		end
		
		--获得出售的积分
		LuaAddPlayerScore(jifenGetSum)
		
		--重置出售道具的数量
		current_sell_num = 0
		
		--刷新出售价格和按钮控件
		RefreshSellItemNoteFrm()
		
		--存储存档
		--保存存档
		LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
		
		--播放出售音效
		hApi.PlaySound("pay_gold")
		
		--触发事件：出售道具
		hGlobal.event:event("Local_Event_ItemSell_Result")
	end
	
	--函数：一键添加道具逻辑
	OnCollectItemFunc = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--[[
		--首先将原先待出售的道具都取消，并放回背包
		for i = current_sell_num, 1, -1 do
			_frmNode.childUI["sellItem" .. i].data.code(_frmNode.childUI["sellItem" .. i], 0, 0, 1, true)
		end
		]]
		
		--待一键添加的背包索引id集
		local selllist = {}
		--先筛选白装
		local bagItemCount = BAG_X_NUM * BAG_Y_NUM * BAG_PGAE_NUM --背包道具总数量
		--print(bagItemCount)
		--白装
		for i = 1, bagItemCount, 1 do
			local item = Save_PlayerData.bag[i]
			if item and (item ~= 0) and type(item) == "table" then
				local itemId = item[1] --道具id
				--print(itemId)
				local itemLv = hVar.tab_item[itemId].itemLv or 1
				local nRequireLv = hApi.GetItemRequire(itemId, "level") --需求等级
				if (itemLv == hVar.ITEM_QUALITY.WHITE) then --白色
					if (nRequireLv < 99) then --非合成材料
						if (_frmNode.childUI["Item" .. i].data.tosell ~= 1) then --不在出售中
							selllist[#selllist+1] = i
						end
					end
				end
			end
		end
		
		--蓝装
		for i = 1, bagItemCount, 1 do
			local item = Save_PlayerData.bag[i]
			if item and (item ~= 0) and type(item) == "table" then
				local itemId = item[1] --道具id
				local itemLv = hVar.tab_item[itemId].itemLv or 1
				local nRequireLv = hApi.GetItemRequire(itemId, "level") --需求等级
				if (itemLv == hVar.ITEM_QUALITY.BLUE) then --蓝色
					if (nRequireLv < 99) then --非合成材料
						if (_frmNode.childUI["Item" .. i].data.tosell ~= 1) then --不在出售中
							selllist[#selllist+1] = i
						end
					end
				end
			end
		end
		
		--要操作的数量
		local collectNum = #selllist
		local maxnum = SELL_ITEM_X_NUM * SELL_ITEM_Y_NUM - current_sell_num
		if (collectNum > maxnum) then
			collectNum = maxnum
		end
		--print(collectNum)
		--依次操作
		local touchX = _frmNode.childUI["SellChip"].data.x
		local touchY = _frmNode.childUI["SellChip"].data.y
		for i = 1, collectNum, 1 do
			local bagIdx = selllist[i]
			--print(bagIdx, _frmNode.childUI["Item" .. bagIdx])
			_frmNode.childUI["Item" .. bagIdx].data.code(_frmNode.childUI["Item" .. bagIdx], touchX, touchY, 1, true)
		end
	end
	
	--函数：创建道具洗炼界面（第3个分页）
	OnCreateShopXiLianFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 60 --统一偏移x
		local OFFSET_Y = -70 --统一偏移y
		
		--重置参数
		current_xilian_itemIdx = 0 --当前洗炼道具的背包索引位置
		current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
		
		--提示洗炼道具的说明文字
		_frmNode.childUI["XiLianIntro"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 30,
			y = OFFSET_Y - 10,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 380,
			border = 1,
			--text = "将道具拖拽到此处以洗炼", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_HINT"], --language
		})
		_frmNode.childUI["XiLianIntro"].handle.s:setColor(ccc3(192, 192, 192))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianIntro"
		
		--洗炼规则介绍按钮（响应区域）
		_frmNode.childUI["btnXiLianIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 400,
			y = OFFSET_Y - 20,
			w = 70,
			h = 70,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建洗炼介绍tip
				OnCreateItemXiLianTipFrame()
			end,
		})
		_frmNode.childUI["btnXiLianIntro"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnXiLianIntro"
		
		--合成规则介绍图标
		_frmNode.childUI["btnXiLianIntro"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnXiLianIntro"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 10,
			w = 45,
			h = 45,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.02, 1.02) ,CCScaleTo:create(1.0, 0.98, 0.98))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnXiLianIntro"].childUI["icon"].handle._n:runAction(forever)
		
		--洗炼池子（响应区域）
		_frmNode.childUI["XiLianChip"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 170,
			y = OFFSET_Y - 90,
			w = 120,
			h = 120,
		})
		_frmNode.childUI["XiLianChip"].handle.s:setOpacity(0) --不显示，只用于响应事件
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianChip"
		
		--洗炼池子图片
		_frmNode.childUI["XiLianChip"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianChip"].handle._n,
			model = "UI:forged_slot",
			x = 0,
			y = 0,
			w = 100,
			h = 100,
		})
		
		--洗炼属性区域的很淡的底纹区域背景图
		_frmNode.childUI["XiLianAttrBG"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 185,
			y = OFFSET_Y - 250,
			w = 430,
			h = 210,
		})
		_frmNode.childUI["XiLianAttrBG"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianAttrBG"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 430, 210, _frmNode.childUI["XiLianAttrBG"])
		img9:setOpacity(32) --很淡的颜色
		
		--依次绘制每条洗炼属性
		local _off_x = 20 --dx
		local _off_y = -175 --dy
		local _off_dy = 50 --每个间隔y
		for i = 1, 4, 1 do
			--该属性条的背景图
			_frmNode.childUI["XiLian_ImageBG" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:MedalDarkImg",
				x = OFFSET_X + 130,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 300,
				h = 40,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_ImageBG" .. i
			
			--钻石图标
			_frmNode.childUI["XiLian_Diamond" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "MODEL_EFFECT:diamond",
				x = OFFSET_X + _off_x - 15,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 2,
				w = 24,
				h = 24,
			})
			_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Diamond" .. i
			
			--卡槽的属性文字
			_frmNode.childUI["XiLian_Attr" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 10,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 3,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				text = "",
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Attr" .. i
			
			--锁定的选择框图片
			_frmNode.childUI["XiLian_SelectBox" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Button_SelectBorder",
				x = OFFSET_X + _off_x + 290,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 36,
				h = 36,
			})
			_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_SelectBox" .. i
			
			--锁定的选中的勾勾图片
			_frmNode.childUI["XiLian_GouGou" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:finish",
				x = OFFSET_X + _off_x + 290,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				scale = 0.01,
			})
			_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_GouGou" .. i
			
			--锁定的锁的图标
			_frmNode.childUI["XiLian_Lock" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:LOCK",
				x = OFFSET_X + _off_x + 235,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 32,
				h = 32,
			})
			_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Lock" .. i
			
			--“锁定”文字
			_frmNode.childUI["XiLian_LockLabel" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 315,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 100,
				text = "",
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_LockLabel" .. i
			
			--洗炼锁定按钮（响应事件）
			_frmNode.childUI["XiLian_LockBtn" .. i] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				model = "misc/mask.png",
				x = OFFSET_X + _off_x + 300,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 150,
				h = 45,
				failcall = 1,
				
				--按下锁孔事件
				codeOnTouch = function(self, touchX, touchY, sus)
					--显示锁孔按钮的tip
					OnClickShowLockXiLianItemSlotTip(i)
				end,
				
				--滑动锁孔事件
				codeOnDrag = function(self, touchX, touchY, sus)
					if (sus == 1) then --在内部，显示选中框
						if _frmNode.childUI["XiLianSlotTip"] then
							_frmNode.childUI["XiLianSlotTip"]:setstate(1)
						end
					else --在外部，不显示选中框
						if _frmNode.childUI["XiLianSlotTip"] then
							_frmNode.childUI["XiLianSlotTip"]:setstate(-1)
						end
					end
				end,
				
				--点击锁孔事件
				code = function(self, touchX, touchY, sus)
					--删除锁孔tip
					hApi.safeRemoveT(_frmNode.childUI, "XiLianSlotTip")
					
					--在内部点击
					if (sus == 1) then
						--点击锁孔按钮的逻辑
						OnClickLockXiLianItemSlot(i)
					end
				end,
			})
			_frmNode.childUI["XiLian_LockBtn" .. i].handle.s:setOpacity(0) --不显示，只用于响应事件
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_LockBtn" .. i
		end
		
		--洗炼需要的积分前缀"消耗"
		_frmNode.childUI["XiLian_JiFenLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 50,
			y = OFFSET_Y - 380 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "LC",
			width = 200,
			font = hVar.FONTC,
			--text = "消耗", --language
			text = hVar.tab_string["__TEXT_CONSUME"], --language
		})
		_frmNode.childUI["XiLian_JiFenLabel"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_JiFenLabel"
		
		--洗炼需要的积分图标
		_frmNode.childUI["XiLian_JiFenIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 125,
			y = OFFSET_Y - 380,
			w = 28,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_JiFenIcon"
		
		--洗炼需要的积分数值
		_frmNode.childUI["JiFenXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 145,
			y = OFFSET_Y - 380 - 2, --numWhite字体偏移2像素
			size = 24,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "0",
		})
		_frmNode.childUI["JiFenXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenXiLianRequire"
		
		--洗炼需要的金币图标
		_frmNode.childUI["XiLian_GoldIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:game_coins",
			x = OFFSET_X + 245,
			y = OFFSET_Y - 380,
			w = 48,
			h = 48,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_GoldIcon"
		
		--洗炼需要的金币数值
		_frmNode.childUI["GoldXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 265,
			y = OFFSET_Y - 380 - 2, --numWhite字体偏移2像素
			size = 24,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "0",
		})
		_frmNode.childUI["GoldXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GoldXiLianRequire"
		
		--道具洗炼按钮
		_frmNode.childUI["btnXiLian"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 180,
			y = OFFSET_Y - 435,
			w = 160,
			h = 50,
			--label = "洗炼", --language
			label = hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"], --language
			font = hVar.FONTC,
			border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--洗炼道具逻辑
				OnXiLianItemFunc()
			end,
		})
		hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnXiLian"
	end
	
	--函数：创建洗炼道具价格和按钮控件
	RefreshXiLianItemNoteFrm = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果没有洗炼道具，积分、金币都为0，洗炼按钮不能用
		if (current_xilian_itemIdx == 0) then
			_frmNode.childUI["JiFenXiLianRequire"]:setText(0)
			_frmNode.childUI["GoldXiLianRequire"]:setText(0)
			hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
		else --有洗炼的道具
			--检查当前拥有的孔的数量
			local item = Save_PlayerData.bag[current_xilian_itemIdx]
			local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
			local upCount = 0 --有效的孔的数量
			if rewardEx and (type(rewardEx) == "table") then
				for j = 1, #rewardEx, 1 do
					local attr = rewardEx[j] --孔的属性（字符串）
					local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
					if attrVal then
						--本条是有效的孔数据
						upCount = upCount + 1
					end
				end
			end
			
			if (upCount == 0) then --0孔道具不能洗炼
				_frmNode.childUI["JiFenXiLianRequire"]:setText(0)
				_frmNode.childUI["GoldXiLianRequire"]:setText(0)
				hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
			else --可以洗炼的道具
				--计算消耗的积分
				local itemId = Save_PlayerData.bag[current_xilian_itemIdx][1]
				local itemLv = hVar.tab_item[itemId].itemLv or 1
				local JifenRequire = hVar.ITEM_XILIAN_INFO[itemLv].cost
				
				--锁孔消耗金币
				local lockSlotSum = 0 --当前锁孔的数量和
				for i = 1, #current_xilian_item_lock_state, 1 do
					lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
				end
				local goldRequire = hApi.GetItemLockInfo(lockSlotSum)
				
				--是否可以洗炼
				local currentScore = LuaGetPlayerScore() --玩家当前的积分
				local currentGold = LuaGetPlayerRmb() --玩家当前游戏币
				
				--更新界面
				_frmNode.childUI["JiFenXiLianRequire"]:setText(JifenRequire)
				_frmNode.childUI["GoldXiLianRequire"]:setText(goldRequire)
				if (currentScore >= JifenRequire) and (currentGold >= goldRequire) then
					hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "normal")
				else
					hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
				end
			end
		end
	end
	
	--显示锁孔按钮的tip
	OnClickShowLockXiLianItemSlotTip = function(slotPos)
		--如果没有洗炼道具，不响应操作
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--如果点击的孔的位置超出该道具的孔的数量，不响应操作
		local item = Save_PlayerData.bag[current_xilian_itemIdx]
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		if (slotPos > upCount) then
			return
		end
		
		--如果当前是锁孔操作，并且没有剩余的锁孔了，那么也不响应操作
		if (current_xilian_item_lock_state[slotPos] == 0) then
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then
				--洗炼需要至少一条属性
				return
			end
		end
		
		--点击的孔的位置是有效的
		--开始显示锁孔的tip
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		local xilianBoxCtrl = _frmNode.childUI["XiLian_SelectBox" .. slotPos]
		local xilianBox_x = xilianBoxCtrl.data.x
		local xilianBox_y = xilianBoxCtrl.data.y
		_frmNode.childUI["XiLianSlotTip"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:Tactic_Selected",
			model = "UI:Button_SelectBorder",
			x = xilianBox_x,
			y = xilianBox_y,
			w = 1,
			h = 1,
			z = 101,
		})
		_frmNode.childUI["XiLianSlotTip"].handle.s:setOpacity(0) --作为父控件用，不显示
		
		--创建说明，提示该洗炼道具锁孔简介
		local __parent = _frmNode.childUI["XiLianSlotTip"]
		local __parentHandle = __parent.handle._n
		local xOffset = 0
		local yOffset = 100
		
		--洗炼道具简介背景框
		--[[
		__parent.childUI["imgBg"] = hUI.image:new({
			parent = __parentHandle,
			model = "UI:TacticBG",
			x = xOffset,
			y = yOffset,
			w = 320,
			h = 60,
			align = "MC",
		})
		__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 320, 60, __parent)
		img9:setOpacity(204)
		
		--创建洗炼锁孔的说明
		__parent.childUI["labxilianSlotHint"] = hUI.label:new({
			parent = __parentHandle,
			size = 26,
			align = "LT",
			border = 1,
			x = xOffset - 150,
			y = yOffset + 10,
			--font = hVar.FONTC,
			font = hVar.FONTC,
			width = 600,
			--text = "锁定本条属性，不被重洗。", --language
			text = hVar.tab_string["__ITEM_PANEL__LOCK_THIS_SLOT"], --language
		})
		__parent.childUI["labxilianSlotHint"].handle.s:setColor(ccc3(255, 255, 255))
		if (current_xilian_item_lock_state[slotPos] == 1) then
			--__parent.childUI["labxilianSlotHint"]:setText("取消锁定本条属性。") --language
			__parent.childUI["labxilianSlotHint"]:setText(hVar.tab_string["__ITEM_PANEL__UNLOCK_THIS_SLOT"]) --language
			__parent.childUI["labxilianSlotHint"].handle.s:setColor(ccc3(212, 212, 212))
		end
	end
	
	--函数：点击锁孔按钮的逻辑
	OnClickLockXiLianItemSlot = function(slotPos)
		--如果没有洗炼道具，不响应操作
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--如果点击的孔的位置超出该道具的孔的数量，不响应操作
		local item = Save_PlayerData.bag[current_xilian_itemIdx]
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		if (slotPos > upCount) then
			return
		end
		
		--如果当前是锁孔操作，并且没有剩余的锁孔了，那么也不响应操作
		if (current_xilian_item_lock_state[slotPos] == 0) then
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then
				--洗炼需要至少一条属性
				return
			end
		end
		
		--点击的孔的位置是有效的
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_xilian_item_lock_state[slotPos] == 0) then --当前未锁孔
			current_xilian_item_lock_state[slotPos] = 1
			
			--动画表现
			local act1 = CCCallFunc:create(function()
				_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:setVisible(true)
				
				--更新洗炼道具信息
				RefreshXilianItemInfo()
				
				--更新洗炼道具价格和按钮控件
				RefreshXiLianItemNoteFrm()
			end)
			local act2 = CCScaleTo:create(0.03, 0.9)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:runAction(sequence)
		else --当前是锁孔
			current_xilian_item_lock_state[slotPos] = 0
			
			--动画表现
			local act1 = CCScaleTo:create(0.03, 0.01)
			local act2 = CCCallFunc:create(function()
				_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:setVisible(false)
				
				--更新洗炼道具信息
				RefreshXilianItemInfo()
				
				--更新洗炼道具价格和按钮控件
				RefreshXiLianItemNoteFrm()
			end)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:runAction(sequence)
		end
	end
	
	--函数：刷新洗炼道具的信息
	RefreshXilianItemInfo = function()
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_xilian_itemIdx == 0) then --没有洗炼道具
			--隐藏所有的洗炼属性控件
			for i = 1, 4, 1 do
				_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(true) --显示属性条的背景图
				
				_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --不显示钻石图标
				_frmNode.childUI["XiLian_Attr" .. i]:setText("") --不显示卡槽的属性文字
				_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --不显示锁定的选择框图片
				_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
				_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --不显示锁定的锁的图标
				_frmNode.childUI["XiLian_LockLabel" .. i]:setText("") --不显示“锁定”文字
			end
			
			--删除重铸按钮
			hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
		else --存在洗炼道具
			local item = Save_PlayerData.bag[current_xilian_itemIdx]
			local itemId = item[1] --道具id
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
			local upCount = 0 --有效的孔的数量
			
			--绘制出当前的有效孔
			if rewardEx and (type(rewardEx) == "table") then
				for j = 1, #rewardEx, 1 do
					local attr = rewardEx[j] --孔的属性（字符串）
					local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
					if attrVal then
						local temptext = "" --要显示的属性字符串描述
						
						if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
							local miniAtk, maxAtk = attrVal.value1, attrVal.value2
							temptext = miniAtk .. " - " .. maxAtk
						else --其它属性，只读第一个数值
							temptext = attrVal.value1
							
							local sign = nil --正负号
							local u_value = math.abs(attrVal.value1) --无符号的值
							if (attrVal.value1 >= 0) then
								sign = "+"
							else
								sign = "-"
							end
							
							if (attrVal.attrAdd == "atk_interval") then --攻击间隔
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
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
							elseif (attrVal.attrAdd == "active_skill_cd_delta_rate") then --主动技能冷却时间变化值（毫秒）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化值（毫秒）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
								--temptext = sign .. u_value .. "倍" --language
								temptext = sign .. u_value .. hVar.tab_string["__Rate"] --language
							else
								temptext = sign .. u_value
							end
							
							--百分比显示
							if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
								temptext = temptext .. "％"
							end
						end
						
						--本条是有效的孔数据
						upCount = upCount + 1
						
						local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
						local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
							
						--更新绘制本条孔属性
						_frmNode.childUI["XiLian_ImageBG" .. upCount].handle.s:setVisible(true) --显示属性条的背景图
						
						_frmNode.childUI["XiLian_Diamond" .. upCount].handle.s:setVisible(true) --显示钻石图标
						_frmNode.childUI["XiLian_Attr" .. upCount]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
						_frmNode.childUI["XiLian_Attr" .. upCount].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
						_frmNode.childUI["XiLian_SelectBox" .. upCount].handle.s:setVisible(true) --显示锁定的选择框图片
						
						--如果该条属性被锁定，那么显示锁定标识
						if (current_xilian_item_lock_state[upCount] == 1) then --已锁定
							_frmNode.childUI["XiLian_GouGou" .. upCount].handle._n:setVisible(true) --显示锁定的选中的勾勾图片
							_frmNode.childUI["XiLian_Lock" .. upCount].handle._n:setVisible(true) --显示锁定的锁的图标
							--_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText("锁定") --显示“锁定”文字 --language
							_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText(hVar.tab_string["__ITEM_PANEL__LOCK"]) --显示“锁定”文字 --language
						else --未锁定
							_frmNode.childUI["XiLian_GouGou" .. upCount].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
							_frmNode.childUI["XiLian_Lock" .. upCount].handle._n:setVisible(false) --不显示锁定的锁的图标
							_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText("") --不显示“锁定”文字
						end
					end
				end
			end
			
			--后面的孔，不显示
			for i = upCount + 1, 4, 1 do
				_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(false) --不显示属性条的背景图
				
				_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --不显示钻石图标
				_frmNode.childUI["XiLian_Attr" .. i]:setText("") --不显示卡槽的属性文字
				_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --不显示锁定的选择框图片
				_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
				_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --不显示锁定的锁的图标
				_frmNode.childUI["XiLian_LockLabel" .. i]:setText("") --不显示“锁定”文字
			end
			
			--删除旧的重铸按钮
			hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
			
			--如果当前已经不能再锁孔了，那么第一个未锁孔的位置的盒子图标，也不显示
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then --只剩一条属性未锁了，这条属性的边框不显示
				local notShowPos = 0 --不显示的位置
				for i = 1, #current_xilian_item_lock_state, 1 do
					if (current_xilian_item_lock_state[i] == 0) then
						notShowPos = i
						break
					end
				end
				_frmNode.childUI["XiLian_SelectBox" .. notShowPos].handle.s:setVisible(false) --不显示锁定的选择框图片
			end
			
			--检查孔的数量是否到达了本道具品质的上限数量
			--没到上限，后面的空孔显示背景图，并且第一条空孔可以重铸
			local slotMaxNum = hVar.ITEM_ATTR_EX_LIMIT[itemLv] --该品质道具的孔的数量上限
			if (upCount < slotMaxNum) then
				--后面的空孔显示背景图
				for i = upCount + 1, slotMaxNum, 1 do
					_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(true) --显示属性条的背景图
					_frmNode.childUI["XiLian_Attr" .. i]:setText("无") --显示卡槽的属性文字
					_frmNode.childUI["XiLian_Attr" .. i].handle.s:setColor(ccc3(96, 96, 96))
				end
				
				--显示重铸按钮
				_frmNode.childUI["btnRebuild"] = hUI.button:new({
					parent = _parentNode,
					dragbox = _frm.childUI["dragBox"],
					x = 398,
					y = -296 - (upCount - 1) * 50,
					w = 110,
					h = 48,
					--label = "打孔", --language
					label = hVar.tab_string["__ITEM_PANEL__PAGE_CHONGZHU"], --language
					font = hVar.FONTC,
					border = 1,
					model = "UI:BTN_ButtonRed",
					animation = "normal",
					scaleT = 0.95,
					scale = 1.0,
					code = function()
						--弹框，告知是否要重铸
						local MsgSelections = nil
						MsgSelections = {
							style = "mini",
							select = 0,
							ok = function()
								--print("ok")
								--判断本地游戏币是否足够
								local rebuildGold = hApi.GetItemRebuildInfo(upCount + 1)
								local rmbNow = LuaGetPlayerRmb() --当前游戏币
								if (rmbNow < rebuildGold) then
									--弹框
									--[[
									--local strText = "游戏币不足" --language
									local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
									hGlobal.UI.MsgBox(strText, {
										font = hVar.FONTC,
										ok = function()
										end,
									})
									]]
									--弹出游戏币不足并提示是否购买的框
									hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
								else
									hGlobal.event:event("Event_ItemRebuildEvent", 0, current_xilian_itemIdx)
								end
							end,
							cancel = function()
								--print("cancel")
							end,
							--cancelFun = cancelCallback, --点否的回调函数
							--textOk = "跳过引导",
							textCancel = hVar.tab_string["__TEXT_Cancel"],
							userflag = 0, --用户的标记
						}
						local rebuildGold = hApi.GetItemRebuildInfo(upCount + 1)
						--local showTitle = "是否花费" .. rebuildGold .. "游戏币新加一个孔？" --language
						local showTitle = hVar.tab_string["__ITEM_PANEL__CHONGZHU_Msg1"] .. rebuildGold .. hVar.tab_string["ios_gamecoin"] .. hVar.tab_string["__ITEM_PANEL__CHONGZHU_Msg2"] --language
						local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					end,
				})
				leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnRebuild"
			end
		end
	end
	
	--函数：创建洗炼道具图标按钮
	OnCreateXiLianItemBtn = function(pageIdx, bagIdx)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local itemId = Save_PlayerData.bag[bagIdx][1]
		local xilianChip_x = _frmNode.childUI["XiLianChip"].data.x
		local xilianChip_y = _frmNode.childUI["XiLianChip"].data.y
		local to_x = xilianChip_x
		local to_y = xilianChip_y
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		
		--绘制洗炼道具图标（按钮响应）
		local itemModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			itemModel = "ICON:Back_red2_item"
		end
		_frmNode.childUI["XiLianItem"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:SkillSlot",
			model = itemModel,
			x = to_x,
			y = to_y + 5,
			w = ITEM_ICON_EDGE,
			h = ITEM_ICON_EDGE,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			z = 100,
			
			--按下出售道具图标事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示选中框
				self.childUI["selectbox"] = hUI.image:new({
					parent = self.handle._n,
					model = "UI:Tactic_Selected",
					x = 0,
					y = 0,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
				})
			end,
			
			--滑动出售道具图标事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在内部，显示选中框
					self.childUI["selectbox"].handle.s:setVisible(true)
				else --在外部，不显示选中框
					self.childUI["selectbox"].handle.s:setVisible(false)
				end
			end,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus)
				--删除选中框
				hApi.safeRemoveT(self.childUI, "selectbox") --选中框
				
				--如果在内部，那么将按钮飞到原背包的位置
				if (sus == 1) then
					local modBagIdx = bagIdx % (BAG_X_NUM * BAG_Y_NUM)
					if (modBagIdx == 0) then
						modBagIdx = BAG_X_NUM * BAG_Y_NUM
					end
					local xi = modBagIdx % BAG_X_NUM --xi
					if (xi == 0) then
						xi = BAG_X_NUM
					end
					local yi = (modBagIdx - xi) / BAG_X_NUM + 1 --yi
					
					--飞到的位置
					local posX = ITEM_BAG_OFFSET_X + (xi - 1) * (ITEM_ICON_EDGE + 0) - 1 - ITEM_ICON_EDGE / 2
					local posY = ITEM_BAG_OFFSET_Y - (yi - 1) * (ITEM_ICON_EDGE - 1) - 1
					
					--全部动画完成之后的回调
					local OnActionEnd = function() --所有的道具都挪好了位置
						--删除自身控件
						hApi.safeRemoveT(_frmNode.childUI, "XiLianItem")
						
						--标记背包栏当前不是待出售状态
						local bagItem = _frmNode.childUI["Item" .. bagIdx]
						bagItem.data.tosell = 0
						
						--删除背包栏主合成道具标记
						hApi.safeRemoveT(bagItem.childUI, "flag")
						hApi.safeRemoveT(bagItem.childUI, "xilianMark")
						
						--原道具变亮
						bagItem.handle.s:setOpacity(255) --道具底纹默认透明度
						bagItem.childUI["icon"].handle.s:setOpacity(255) --道具还原
						
						--标记洗炼道具为0
						current_xilian_itemIdx = 0
						current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
						
						--刷新洗炼道具信息界面
						RefreshXilianItemInfo()
						
						--刷新洗炼道具价格和按钮控件
						RefreshXiLianItemNoteFrm()
					end
					
					--动画1：出售的道具飞到原背包栏
					local moveTo = CCMoveTo:create(0.1, ccp(posX, posY)) --移动
					local callback = CCCallFunc:create(function() --回调
						OnActionEnd()
					end)
					local sequence = CCSequence:createWithTwoActions(moveTo, callback)
					self.handle._n:runAction(sequence) --action
				end
			end,
		})
		
		_frmNode.childUI["XiLianItem"].handle.s:setOpacity(255) --设置道具背景默认灰度
		if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
			_frmNode.childUI["XiLianItem"].handle.s:setOpacity(255) --神器更亮些
		end
		_frmNode.childUI["XiLianItem"].data.index = sellIdx --标记它自身的索引值
		_frmNode.childUI["XiLianItem"].data.bagIndex = bagIdx --标记背包的索引值
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianItem"
		
		--绘制洗炼道具图标
		_frmNode.childUI["XiLianItem"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianItem"].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE - 6,
			h = ITEM_ICON_EDGE - 6,
		})
		
		--标记洗炼道具的索引值
		current_xilian_itemIdx = bagIdx
		current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
		
		--刷新洗炼道具信息界面
		RefreshXilianItemInfo()
		
		--刷新洗炼道具价格和按钮控件
		RefreshXiLianItemNoteFrm()
	end
	
	--函数：洗炼道具逻辑
	OnXiLianItemFunc = function()
		--如果没有洗炼道具，直接返回
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--未联网不能使用道具洗炼功能
		if (g_cur_net_state == -1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_XiLianItem_Net"], {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
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
		
		--检查洗炼道具是否为装备
		local item = Save_PlayerData.bag[current_xilian_itemIdx]
		local itemId =  item[1] --洗炼道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1 --道具等级
		if (not hApi.CheckItemIsEquip(itemId)) then
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
		
		--检查该品质的道具是否可以洗炼
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
		
		--检查是否有可以洗炼的孔
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		local lockSlotSum = 0 --当前锁孔的数量和
		for i = 1, #current_xilian_item_lock_state, 1 do
			lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
		end
		if (lockSlotSum >= upCount) then
			--弹框
			--local strText = "洗炼需要至少一条属性" --language
			local strText = hVar.tab_string["__TEXT_Cant_XiLianRequireAtLeastOneSlot_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--计算积分是否足够
		local itemId = Save_PlayerData.bag[current_xilian_itemIdx][1]
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local JifenRequire = hVar.ITEM_XILIAN_INFO[itemLv].cost
		local currentScore = LuaGetPlayerScore() --玩家当前的积分
		if (currentScore < JifenRequire) then
			--弹框
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ScoreNotEnough"], {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--计算金币是否足够
		local goldRequire = hApi.GetItemLockInfo(lockSlotSum)
		local currentGold = LuaGetPlayerRmb() --玩家当前游戏币
		if (currentGold < goldRequire) then
			--弹框
			hGlobal.UI.MsgBox(hVar.tab_string["ios_not_enough_game_coin"], {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--触发洗炼事件
		local xilianItemIdx = current_xilian_itemIdx --洗炼的道具
		local slotPosList = {} --要洗炼的位置列表
		local slotLockList = {} --要锁定的位置列表
		local s_num_i = 0 --孔的数量i
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do --j代表实际的孔的表的索引位置
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					s_num_i = s_num_i + 1
					if (current_xilian_item_lock_state[s_num_i] == 1) then --已锁定
						table.insert(slotLockList, j)
					else --未锁定
						table.insert(slotPosList, j)
					end
				end
			end
		end
		
		--如果不消耗金币，直接洗炼
		if (goldRequire == 0) then
			hGlobal.event:event("Event_ItemXiLianEvent", 0, xilianItemIdx, slotPosList, slotLockList)
		else
			--弹框，告知是否要洗炼
			local MsgSelections = nil
			MsgSelections = {
				style = "mini",
				select = 0,
				ok = function()
					--print("ok")
					--判断本地游戏币是否足够
					local rmbNow = LuaGetPlayerRmb() --当前游戏币
					if (rmbNow < goldRequire) then
						--弹框
						--[[
						--local strText = "游戏币不足" --language
						local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
							end,
						})
						]]
						--弹出游戏币不足并提示是否购买的框
						hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
					else
						hGlobal.event:event("Event_ItemXiLianEvent", 0, xilianItemIdx, slotPosList, slotLockList)
					end
				end,
				cancel = function()
					--print("cancel")
				end,
				--cancelFun = cancelCallback, --点否的回调函数
				--textOk = "跳过引导",
				textCancel = hVar.tab_string["__TEXT_Cancel"],
				userflag = 0, --用户的标记
			}
			--local showTitle = "是否花费" .. goldRequire .. "游戏币洗炼？" --language
			local showTitle = hVar.tab_string["__ITEM_PANEL__CHONGZHU_Msg1"] .. goldRequire .. hVar.tab_string["ios_gamecoin"] .. hVar.tab_string["__ITEM_PANEL__CHONGZHU_Msg3"] --language
			local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		end
	end
	
	--函数：查看道具洗炼分页说明tip
	OnCreateItemXiLianTipFrame = function()
		--先清除上一次的道具洗炼说明面板
		if hGlobal.UI.ItemXiLiannfoFrame then
			hGlobal.UI.ItemXiLiannfoFrame:del()
		end
		
		--创建技能说明面板
		hGlobal.UI.ItemXiLiannfoFrame = hUI.frame:new({
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
					--hGlobal.UI.ItemXiLiannfoFrame:del()
					--hGlobal.UI.ItemXiLiannfoFrame = nil
					--print("点击事件（有可能在控件外部点击）")
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.ItemXiLiannfoFrame:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		local _SkillParent = hGlobal.UI.ItemXiLiannfoFrame.handle._n
		local _ItemXiLianChildUI = hGlobal.UI.ItemXiLiannfoFrame.childUI
		local _offX = BOARD_POS_X + 295
		local _offY = BOARD_POS_Y - 45
		
		--创建技能tip图片背景
		--[[
		_ItemXiLianChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 380,
			h = 450,
		})
		_ItemXiLianChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 380, 450, hGlobal.UI.ItemXiLiannfoFrame)
		img9:setOpacity(204)
		
		--创建道具洗炼介绍tip-标题
		_ItemXiLianChildUI["ItemMergeName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 100,
			y = _offY - 45,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "装备洗炼介绍", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_TITLE"], --language
			border = 1,
		})
		_ItemXiLianChildUI["ItemMergeName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--创建道具洗炼介绍tip-内容1
		_ItemXiLianChildUI["ItemMergeContent1"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 75,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "1、装备洗炼，重洗装备孔的属性。", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_1"], --language
			border = 1,
		})
		
		--创建道具洗炼介绍tip-内容2
		_ItemXiLianChildUI["ItemMergeContent2"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 145,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "2、锁定某条属性后，该条属性不会被重洗。", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_2"], --language
			border = 1,
		})
		
		--创建道具洗炼介绍tip-内容3
		_ItemXiLianChildUI["ItemMergeContent3"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 215,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "3、装备打孔，为本装备新加一个孔。", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_3"], --language
			border = 1,
		})
		
		--创建道具洗炼介绍tip-内容4
		_ItemXiLianChildUI["ItemMergeContent4"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 285,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "4、装备品质越高，孔的数量上限越多。", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_4"], --language
			border = 1,
		})
		
		--创建道具洗炼介绍tip-内容5
		_ItemXiLianChildUI["ItemMergeContent5"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 150,
			y = _offY - 355,
			width = 300,
			align = "LT",
			font = hVar.FONTC,
			--text = "5、孔属性档次依次为：", --language
			text = hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_5"], --language
			border = 1,
		})
		
		--每个价值颜色
		for i = 1, #hVar.ITEMLEVEL, 1 do
			--创建道具洗炼介绍tip-内容5
			local quality = i
			local label =  hVar.ITEMLEVEL[quality].label
			_ItemXiLianChildUI["ItemMergeContentQuality" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 26,
				x = _offX - 150 + ((i - 1) * 63),
				y = _offY - 390,
				width = 300,
				align = "LT",
				font = hVar.FONTC,
				--text = "白色", --language
				text = hVar.tab_string[label], --language
				border = 1,
			})
			local rgb = hVar.ITEMLEVEL[quality].NAMERGB --属性颜色
			_ItemXiLianChildUI["ItemMergeContentQuality" .. i].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
		end
	end
	
	--函数：道具洗炼动画
	PlayItemXiLianAnimation = function(retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--动画相关参数
		local OnAllActionEnd = nil --动画完成的回调
		local actionNum = 0 --动画的总数量
		local actionFinishNum = 0 --动画完成的数量
		
		--找出哪些属性是重洗的
		local item = Save_PlayerData.bag[current_xilian_itemIdx]
		local itemId = item[1] --道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		
		--绘制出变化了孔的属性
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
					local currentIdx = upCount
					
					--本条未被锁定，才是属性发生变化、需要动画显示的
					if (current_xilian_item_lock_state[currentIdx] == 0) then
						--动画的数量加1
						actionNum = actionNum + 1
						
						local temptext = "" --要显示的属性字符串描述
						
						if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
							local miniAtk, maxAtk = attrVal.value1, attrVal.value2
							temptext = miniAtk .. " - " .. maxAtk
						else --其它属性，只读第一个数值
							temptext = attrVal.value1
							
							local sign = nil --正负号
							local u_value = math.abs(attrVal.value1) --无符号的值
							if (attrVal.value1 >= 0) then
								sign = "+"
							else
								sign = "-"
							end
							
							if (attrVal.attrAdd == "atk_interval") then --攻击间隔
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
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
							elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
								--temptext = sign .. u_value .. "倍" --language
								temptext = sign .. u_value .. hVar.tab_string["__Rate"] --language
							else
								temptext = sign .. u_value
							end
							
							--百分比显示
							if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
								temptext = temptext .. "％"
							end
						end
						
						local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
						local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
						
						--表现动画
						local fadeTo = CCFadeTo:create(0.2, 0) --原属性变淡
						
						local delay1 = CCDelayTime:create(0.1 * currentIdx) --延时1
						
						local callback1 = CCCallFunc:create(function() --回调1
							_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setOpacity(255) --文字重新变亮
							_frmNode.childUI["XiLian_Attr" .. currentIdx]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
							_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
						end)
						
						--同步动画1：变大+偏移
						local spwan1Time = 0.1
						local scaleToBig = CCScaleTo:create(spwan1Time, 1.3) --变大
						local movebyLeft = CCMoveBy:create(spwan1Time, ccp(-10, 4)) --偏移左
						local spawn1 = CCSpawn:createWithTwoActions(scaleToBig, movebyLeft) --同步1
						
						local delay2 = CCDelayTime:create(0.02) --延时2
						
						--同步动画2：变小+偏移
						local spwan2Time = 0.05
						local scaleToSmall = CCScaleTo:create(spwan2Time, 1.0) --变小
						local movebyRight = CCMoveBy:create(spwan2Time, ccp(10, -4)) --偏移左
						local spawn2 = CCSpawn:createWithTwoActions(scaleToSmall, movebyRight) --同步2
						
						local callback2 = CCCallFunc:create(function() --回调2
							--动画完成的数量加1
							actionFinishNum = actionFinishNum + 1
							
							--所有动画完成，进入结束
							if (actionFinishNum == actionNum) then
								OnAllActionEnd()
							end
						end)
						
						--播放动画
						local array = CCArray:create()
						array:addObject(fadeTo) --原属性变淡
						array:addObject(delay1) --延时1
						array:addObject(callback1) --回调1
						array:addObject(spawn1) --同步1
						array:addObject(delay2) --延时2
						array:addObject(spawn2) --同步2
						array:addObject(callback2) --回调2
						_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:runAction(CCSequence:create(array)) --action
					end
				end
			end
		end
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--函数：道具重铸动画
	PlayItemRebuildAnimation = function(retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除原先的重铸按钮
		hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--动画相关参数
		local OnAllActionEnd = nil --动画完成的回调
		
		--找出重铸的位置
		local item = Save_PlayerData.bag[current_xilian_itemIdx]
		local itemId = item[1] --道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		local lastSlotIdx = 0 --最后一个孔的索引位置
		
		--绘制出变化了孔的属性
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
					lastSlotIdx = j
				end
			end
		end
		
		--重铸的位置（这里已经是重铸后的位置了，所以是最后一个孔的索引位置
		local currentIdx = upCount
		
		--显示钻石图标
		_frmNode.childUI["XiLian_Diamond" .. currentIdx].handle.s:setVisible(true) --显示钻石图标
		
		--新的属性
		local temptext = "" --要显示的属性字符串描述
		local attrVal = hVar.ITEM_ATTR_VAL[rewardEx[lastSlotIdx]]
		if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
			local miniAtk, maxAtk = attrVal.value1, attrVal.value2
			temptext = miniAtk .. " - " .. maxAtk
		else --其它属性，只读第一个数值
			temptext = attrVal.value1
			
			local sign = nil --正负号
			local u_value = math.abs(attrVal.value1) --无符号的值
			if (attrVal.value1 >= 0) then
				sign = "+"
			else
				sign = "-"
			end
			
			if (attrVal.attrAdd == "atk_interval") then --攻击间隔
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
				--temptext = sign .. szfloorvalue .. "秒" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
			elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
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
			elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
				--temptext = sign .. u_value .. "倍" --language
				temptext = sign .. u_value .. hVar.tab_string["__Rate"] --language
			else
				temptext = sign .. u_value
			end
			
			--百分比显示
			if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
				temptext = temptext .. "％"
			end
		end
		
		local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
		local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
		
		--表现动画
		local fadeTo = CCFadeTo:create(0.2, 0) --原属性变淡
		
		local delay1 = CCDelayTime:create(0.1) --延时1
		
		local callback1 = CCCallFunc:create(function() --回调1
			_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setOpacity(255) --文字重新变亮
			_frmNode.childUI["XiLian_Attr" .. currentIdx]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
			_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
		end)
		
		--同步动画1：变大+偏移
		local spwan1Time = 0.1
		local scaleToBig = CCScaleTo:create(spwan1Time, 1.3) --变大
		local movebyLeft = CCMoveBy:create(spwan1Time, ccp(-10, 4)) --偏移左
		local spawn1 = CCSpawn:createWithTwoActions(scaleToBig, movebyLeft) --同步1
		
		local delay2 = CCDelayTime:create(0.02) --延时2
		
		--同步动画2：变小+偏移
		local spwan2Time = 0.05
		local scaleToSmall = CCScaleTo:create(spwan2Time, 1.0) --变小
		local movebyRight = CCMoveBy:create(spwan2Time, ccp(10, -4)) --偏移左
		local spawn2 = CCSpawn:createWithTwoActions(scaleToSmall, movebyRight) --同步2
		
		local callback2 = CCCallFunc:create(function() --回调2
			--动画完成
			OnAllActionEnd()
		end)
		
		--播放动画
		local array = CCArray:create()
		array:addObject(fadeTo) --原属性变淡
		array:addObject(delay1) --延时1
		array:addObject(callback1) --回调1
		array:addObject(spawn1) --同步1
		array:addObject(delay2) --延时2
		array:addObject(spawn2) --同步2
		array:addObject(callback2) --回调2
		_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:runAction(CCSequence:create(array)) --action
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--购买失败``````````+-
	hGlobal.event:listen("LocalEvent_BuyItemfail", "__ItemUpClearLock", function(result, nItemID)
		--收到消息后解除购买锁
		--如果道具升级失败，解除按钮锁定
		--if (nItemID >= 9901) and (nItemID <= 9909) then
			hUI.NetDisable(0)
		--end
	end)
	
	--网络断开`````````+-
	hGlobal.event:listen("LocalEvent_Set_activity_refresh", "__ItemUpClearLock", function(connect_state)
		--如果断开网络则恢复不可使用重铸状态
		if (connect_state == -1) then
			--重铸等状态恢复
			hUI.NetDisable(0)
		end
	end)
	
	--监听合成道具事件（点击合成按钮事件）
	hGlobal.event:listen("Event_ItemMergeEvent", "__ItemMerge_Event", function(mergeItemIdx, materialItemIdxList)
		--print("mergeItemIdx=", mergeItemIdx, "\nmaterialItemIdxList=", unpack(materialItemIdxList))
		
		--print("Merge Item begin:----------------------------------------")
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--获取合成主道具
		local mergeItem = Save_PlayerData.bag[mergeItemIdx]
		--如果主合成道具存在，则继续
		if mergeItem and type(mergeItem) == "table" then
			
			--基础概率
			local baseRatio = 0
			--合成材料价值
			local totalItemValue = 0
			--合成消耗积分
			local costScore = 0
			
			local mergeItemId = mergeItem[hVar.ITEM_DATA_INDEX.ID]			--主道具id
			local mergeItemSlot = mergeItem[hVar.ITEM_DATA_INDEX.SLOT]		--主道具属性
			local mergeItemTabI = hVar.tab_item[mergeItemId]			--主道具tab表
			
			--如果主道具tab表存在，主道具是装备
			if mergeItemTabI and hApi.CheckItemIsEquip(mergeItemId) then
				
				--计算主道具tab基础倍率
				local mergeItemItemLv = mergeItemTabI.itemLv or hVar.ITEM_QUALITY.WHITE				--主道具道具品质
				--当前品质的主道具是否可以参与合成
				if hVar.ITEM_MERGE_LIMIT[mergeItemItemLv] then
					local mergeItemMergeInfo = hApi.GetItemMergeInfo(mergeItemItemLv, mergeItemItemLv)	--主道具合成信息
					baseRatio = math.min(baseRatio + mergeItemMergeInfo[1],100)				--主道具概率权值
					costScore = costScore + mergeItemMergeInfo[2]						--主道具积分消耗
					totalItemValue = totalItemValue + hApi.CaculateItemValue(mergeItem)			--主道具价值
					
					--获取材料道具
					local materialItemList = {}
					for i = 1, #materialItemIdxList do
						local material = Save_PlayerData.bag[materialItemIdxList[i]]
						if material and type(material) == "table" then
							
							local materialId = material[hVar.ITEM_DATA_INDEX.ID]			--材料道具id
							local materialSlot = material[hVar.ITEM_DATA_INDEX.SLOT]		--材料道具属性
							local materialTabI = hVar.tab_item[materialId]				--材料道具tab表
							--如果材料道具tab表存在，材料道具是装备
							if materialTabI and hApi.CheckItemIsEquip(materialId) then
								--计算基础倍率
								local materialItemLv = materialTabI.itemLv or hVar.ITEM_QUALITY.WHITE	--材料道具品质
								--当前品质的素材是否可以参与合成
								if hVar.ITEM_MERGE_LIMIT[materialItemLv] then
									local materialMergeInfo = hApi.GetItemMergeInfo(mergeItemItemLv, materialItemLv)	--材料道具合成信息
									baseRatio = math.min(baseRatio + materialMergeInfo[1],100)				--材料道具概率权值
									costScore = costScore + materialMergeInfo[2]						--材料道具积分消耗
									totalItemValue = totalItemValue + hApi.CaculateItemValue(material)			--材料道具价值
									
									materialItemList[#materialItemList + 1] = material
									
									--print("Merge Item: material info: itemId = ".. tostring(materialId).. ",itemLv = ".. tostring(materialItemLv))
								end
							end
						end
					end
					
					local rItemItemLv = mergeItemItemLv					--合成后道具的品质
					local rItemLvLimitLevel = hApi.GetItemLvLimitLevel(mergeItemId)		--合成后道具的穿戴等级限制层级
					local rItemType = mergeItemTabI.type					--合成后道具的类型（武器，衣服，饰品，马）
					
					--print("Merge Item: main item info: itemId = ".. tostring(mergeItemId).. ",itemLv = ".. tostring(mergeItemItemLv) .. ", equipLv = ".. tostring(rItemLvLimitLevel) .. ", type = ".. tostring(mergeItemTabI.type))
					
					--如果材料道具存在则继续
					if #materialItemList > 0 then
						
						--baseRatio = math.floor(baseRatio / hVar.ITEM_MERGE_VALUE[mergeItemItemLv] * 100)
						local rRatio = hApi.random(1, hVar.ITEM_MERGE_VALUE[math.min(mergeItemItemLv + 1, hVar.ITEM_QUALITY.GOLD)])
						local okFlag = 0
						--成功
						--print("Merge Item: main item info:rRatio,baseRatio",rRatio,baseRatio,hVar.ITEM_MERGE_VALUE[mergeItemItemLv])
						if rRatio <= baseRatio then
							okFlag = 1
							rItemItemLv = math.min(mergeItemItemLv + 1, hVar.ITEM_QUALITY.GOLD)
						end
						
						--判断合成道具池是否存在
						--print("Merge Item: final Item info: itemLv = ".. tostring(rItemItemLv)..", equipLv = ".. tostring(rItemLvLimitLevel)..", type = ".. tostring(rItemType))
						local itemPool = hApi.GetItemMergePool(rItemItemLv, rItemLvLimitLevel, rItemType)
						if #itemPool > 0 then
							local rIdx = hApi.random(1, #itemPool)
							local rItemId = itemPool[rIdx]
							if hVar.tab_item[rItemId] then
								--新道具基础价值
								local rItemValue = hVar.tab_item[rItemId].itemValue or 1
								local rItemExValueRatio = math.floor(totalItemValue / rItemValue)
								
								local rItemRewardEx = hApi.CreateItemAttrEx(rItemItemLv, rItemValue, rItemExValueRatio or 0)
								
								--print("Merge Item: final Item ExValue: baseValue".. tostring(rItemValue).. ",totalValue = ".. tostring(totalItemValue).. ",exValueRatio = ".. tostring(rItemExValueRatio))
								
								if LuaGetPlayerScore() >= costScore then
									hUI.NetDisable(30000)
									--slotStr:cost, itemId, slot:num,slot attr1,……
									
									local strTag = "sc:"..costScore..";ii:"..rItemId..";fg:"..okFlag
									if rItemRewardEx and type(rItemRewardEx) == "table" then
										strTag = strTag..";an:"..#rItemRewardEx
										for i = 1, #rItemRewardEx do
											strTag = strTag..";a"..i..":"..(rItemRewardEx[i])
										end
									else
										strTag = strTag..";an:0"
									end
									strTag = strTag..";"
									--print("Merge Item: SendCmdFunc[order_begin]:",strTag," ,forgeCount = ".. tostring(LuaGetForgeCount()))
									
									SendCmdFunc["order_begin"](1,9901,0,1,hVar.tab_stringI[9901][1],costScore,LuaGetForgeCount(),strTag)
									--SendCmdFunc["order_begin"](6,9901,0,1,hVar.tab_stringI[9901][1],costScore,0,strTag)
									
									ret = true
								else
									--积分不足
									strRet = hVar.tab_string["__TEXT_ScoreNotEnough"]
								end 
							else
								--todo:error 合成道具id不存在
								strRet = "合成道具失败.ri_valid"
							end
						else
							--todo:error 合成道具池道具为空
							strRet = "合成道具失败.p_null"
						end

						--[[
						--随机品质，如果成功，则生成新道具的品质增加
						local rRatio = hApi.random(1, 100)
						if rRatio <= baseRatio then
							rItemItemLv = math.min(mergeItemItemLv + 1, hVar.ITEM_QUALITY.MAX)
						end
						
						print("Merge Item: ratio info: rRatio = ".. tostring(rRatio).. ",baseRatio = ".. tostring(baseRatio))
						
						--判断合成道具池是否存在
						print("Merge Item: final Item info: itemLv = ".. tostring(rItemItemLv)..", equipLv = ".. tostring(rItemLvLimitLevel)..", type = ".. tostring(rItemType))
						local itemPool = hApi.GetItemMergePool(rItemItemLv, rItemLvLimitLevel, rItemType)
						if #itemPool > 0 then
							local rIdx = hApi.random(1, #itemPool)
							local rItemId = itemPool[rIdx]
							if hVar.tab_item[rItemId] then
								--新道具基础价值
								local rItemValue = hVar.tab_item[rItemId].itemValue or 1
								local rItemExValueRatio = math.floor(totalItemValue / rItemValue)
								
								local rItemRewardEx = hApi.CreateItemAttrEx(rItemItemLv, rItemValue, rItemExValueRatio or 0)
								
								print("Merge Item: final Item ExValue: baseValue".. tostring(rItemValue).. ",totalValue = ".. tostring(totalItemValue).. ",exValueRatio = ".. tostring(rItemExValueRatio))
								
								if LuaGetPlayerScore() >= costScore then
									hUI.NetDisable(30000)
									--slotStr:cost, itemId, slot:num,slot attr1,……
									
									local strTag = "sc:"..costScore..";ii:"..rItemId
									if rItemRewardEx and type(rItemRewardEx) == "table" then
										strTag = strTag..";an:"..#rItemRewardEx
										for i = 1, #rItemRewardEx do
											strTag = strTag..";a"..i..":"..(rItemRewardEx[i])
										end
									else
										strTag = strTag..";an:0"
									end
									strTag = strTag..";"
									print("Merge Item: SendCmdFunc[order_begin]:",strTag," ,forgeCount = ".. tostring(LuaGetForgeCount()))
									
									SendCmdFunc["order_begin"](1,9901,0,1,hVar.tab_stringI[9901][1],costScore,LuaGetForgeCount(),strTag)
									--SendCmdFunc["order_begin"](6,9901,0,1,hVar.tab_stringI[9901][1],costScore,0,strTag)
									
									ret = true
								else
									--积分不足
									strRet = hVar.tab_string["__TEXT_ScoreNotEnough"]
								end 
							else
								--todo:error 合成道具id不存在
								strRet = "合成道具失败.ri_valid"
							end
						else
							--todo:error 合成道具池道具为空
							strRet = "合成道具失败.p_null"
						end
						--]]
					else
						--todo:error 材料道具不存在
						strRet = "合成道具失败.m_null"
					end
				else
					--todo:error 该品质的主道具不能合成
					strRet = "合成道具失败.miq_valid"
				end
			else
				--todo:error 主合成道具不存在
				strRet = "合成道具失败.mi_null"
			end
		else
			--todo:error 主合成道具不存在
			strRet = "合成道具失败.mi_null"
		end
		
		--print("Merge Item end:----------------------------------------")
		
		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--通过订单系统 合成道具处理函数
	hGlobal.event:listen("LocalEvent_order_forge", "__ItemMergeEvent", function(SC,order_type,order_id,strTag)
		--去掉菊花
		hUI.NetDisable(0)
		
		--据说要更新下作弊检测用的计数标记
		LuaSetForgeCount(SC)
		--print("LuaSetForgeCount:",SC)
		
		local ret = false
		local ret_oItem = nil --新合成的道具对象
		local strRet = hVar.tab_string["ios_err_unknow"]
		local nOkFlag = 0 --是否合成成功变成另一件装备（几率不足，会失败）
		
		--print("merge item receive strtag:",strTag)
		
		if type(strTag) == "string" and string.find(strTag,"sc:") and string.find(strTag,"ii:") and string.find(strTag,"an:") and string.find(strTag,"fg:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
				--print("tempStr[#tempStr]:",#tempStr,strTag)
			end
			
			--升级积分消耗
			local costScore = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"sc:")+3,string.len(tempStr[1])))
			--获得的道具Id
			local nItemId = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"ii:")+3,string.len(tempStr[2])))
			--获得合成是否成功标识
			nOkFlag = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"fg:")+3,string.len(tempStr[3])))
			--获得的道具扩展属性数量
			local nAttrNum = tonumber(string.sub(tempStr[4],string.find(tempStr[4],"an:")+3,string.len(tempStr[4])))
			
			--获得道具的扩展属性
			local rewardEx
			if nAttrNum > 0 then
				rewardEx = {}
				for i = 1, nAttrNum do
					local idx = i + 4
					local attr = (string.sub(tempStr[idx],string.find(tempStr[idx],"a"..i..":")+3,string.len(tempStr[idx])))
					rewardEx[#rewardEx + 1] = attr
				end
			end
			
			--缓存道具数组
			local restoreItem = {}
			local rs, oItem
			
			--如果合成成功替换主道具
			if nOkFlag == 1 then
				--缓存主道具
				restoreItem[current_main_itemIdx] = Save_PlayerData.bag[current_main_itemIdx]
				--删除主道具
				Save_PlayerData.bag[current_main_itemIdx] = 0
				--替换道具
				rs, _, oItem = LuaAddItemToPlayerBag(nItemId, rewardEx)
				
			else	--合成失败主道具不变
				rs = 1
				oItem = Save_PlayerData.bag[current_main_itemIdx]
			end
			
			--删除材料道具
			for i = 1, #current_material_itemIdxList do
				local idx = current_material_itemIdxList[i]
				if idx and (idx > 0) then
					--删除材料道具之前先缓存道具
					restoreItem[idx] = Save_PlayerData.bag[idx]
					
					--删除材料道具
					Save_PlayerData.bag[idx] = 0
				end
			end
			
			if (rs == 1) and oItem then
				ret = true
				ret_oItem = oItem
				
				--扣除积分
				LuaAddPlayerScore(-costScore)
				
				--统计合成道具
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.mergeN)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.mergeN)
				
				--存储存档
				--保存存档
				LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
				
				--如果存在有关闭本界面的时候，给英雄穿戴的装备，那么检测，该装备是否是主合成道具或者辅合成道具
				if (SpecifyEquip ~= 0) then
					if (restoreItem[current_main_itemIdx] == SpecifyEquip) and nOkFlag == 1 then
						--标记新的英雄要穿戴的装备
						SpecifyEquip = oItem
					else
						--是否是辅合成道具的素材
						for i = 1, #current_material_itemIdxList do
							local idx = current_material_itemIdxList[i]
							if idx and (idx > 0) then
								if (restoreItem[idx] == SpecifyEquip) then
									--标记该英雄要穿戴的装备已经没了
									SpecifyEquip = 0
									break
								end
							end
						end
					end
				end
			else
				--道具进包失败
				
				--恢复道具
				for idx, oItem in pairs(restoreItem) do
					if (type(idx) == "number") then
						Save_PlayerData.bag[idx] = oItem
					end
				end
				
				--恢复后不用save，因为都是修改内存
				--...
				
				strRet = hVar.tab_string["__TEXT_BAGLISTISFULL"]
			end
			
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end
		
		if (not ret) then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";f"),order_type)
		else
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";t"),order_type)
		end
		
		--返回事件：本地合成道具结果
		hGlobal.event:event("Local_Event_ItemMerge_Result", ret, ret_oItem, nOkFlag)
	end)
	
	--本界面：监听合成道具结果返回
	--本界面：监听合成道具返回结果
	hGlobal.event:listen("Local_Event_ItemMerge_Result", "__ItemMerge_Result", function(ret, ret_oItem, nOkFlag)
		local mergeBagIdx = 0 --背包的位置
		
		--如果合成成功，检测是存在哪个背包位置
		if ret then
			local uniqueId = ret_oItem[hVar.ITEM_DATA_INDEX.UNIQUE] --新合成的道具的唯一id
			--print("uniqueId=", uniqueId)
			
			for i = 1, #Save_PlayerData.bag, 1 do
				local item = Save_PlayerData.bag[i]
				if (type(item) == "table") then
					local uid = item[hVar.ITEM_DATA_INDEX.UNIQUE]
					--print(i, "uid=", uid)
					if (uid == uniqueId) then
						mergeBagIdx = i
						break
					end
				end
			end
			
			local _frm = hGlobal.UI.PhoneItemFrm
			local _frmNode = _frm.childUI["PageNode"]
			local _parentNode = _frmNode.handle._n
			
			--先删除原背包界面里的主、辅合成道具图标
			hApi.safeRemoveT(_frmNode.childUI, "Item" .. current_main_itemIdx)
			for i = 1, #current_material_itemIdxList, 1 do
				if (current_material_itemIdxList[i] ~= 0) then
					hApi.safeRemoveT(_frmNode.childUI, "Item" .. current_material_itemIdxList[i])
				end
			end
			
			--合成动画结束后的回调函数
			local retCallback = function()
				--重置主、辅合成道具信息
				current_main_itemIdx = 0
				current_material_itemIdxList = {0, 0, 0, 0, 0}
				
				--刷新合成道具价格和按钮控件
				RefreshMergeItemNoteFrm()
			end
			
			--播放合成成功动画
			if (nOkFlag == 1) then --成功变成另一件装备
				PlayMergeAnimationSuccess(mergeBagIdx, retCallback)
			else
				PlayMergeAnimationFail(mergeBagIdx, retCallback)
			end
		end
	end)
	
	--监听洗炼道具事件（点击洗炼按钮事件）
	hGlobal.event:listen("Event_ItemXiLianEvent", "__ItemXiLian_Event", function(oHero, xilianItemIdx, slotPosList, slotLockList)
		
		print("oHero=", oHero, "xilianItemIdx=", xilianItemIdx, "\n slotPosList=", unpack(slotPosList))
		
		--xilianItemIdx: 要洗炼道具的背包索引位置
		--slotPosList: 要洗炼道具的槽的位置集
		
		print("XiLian Item begin:----------------------------------------")
		
		--开始洗炼
		--...
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--获取需要洗练的道具
		local oItem
		local heroId = 0
		if oHero and type(oHero) == "table" then
			oItem = oHero.data.equipment[xilianItemIdx]
			heroId = oHero.data.id
		else
			oItem = Save_PlayerData.bag[xilianItemIdx]
		end
		
		--如果主合成道具存在，则继续
		if oItem and type(oItem) == "table" then
			--基础概率
			local baseRatio = 0
			--合成材料价值
			local totalItemValue = 0
			--合成消耗积分
			local costScore = 0
			
			local itemId = oItem[hVar.ITEM_DATA_INDEX.ID]			--洗练道具id
			local itemSlot = oItem[hVar.ITEM_DATA_INDEX.SLOT]		--洗练道具属性
			local itemUId = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]		--道具唯一Id
			local itemTabI = hVar.tab_item[itemId]				--洗练道具tab表
			
			--如果主道具tab表存在，主道具是装备
			if itemTabI and hApi.CheckItemIsEquip(itemId) and itemSlot and type(itemSlot) == "table" then
				--计算主道具tab基础倍率
				local itemLv = itemTabI.itemLv or hVar.ITEM_QUALITY.WHITE				--主道具道具品质
				local itemMaxSlot = hVar.ITEM_ATTR_EX_LIMIT[itemLv]
				
				--如果需要洗练的属性数目小于等于最大属性数目则开始洗练，否则作为出错处理
				if #slotPosList <= itemMaxSlot then
					
					--用于存放已随出的属性，下次随机时排除该属性
					local excludeAttr = {}
					local lockNum = 0
					
					--先把装备上已经有的属性丢入排除列表
					for i = 1, #slotLockList do
						local attrIdx = slotLockList[i]
						local attr = itemSlot[attrIdx]
						if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
							excludeAttr[#excludeAttr + 1] = attr
							lockNum = lockNum + 1
						end
					end
					
					local slotNum = 0
					local strTag = ""
					
					--遍历洗练的属性位
					for i = 1, #slotPosList do
						local attrIdx = slotPosList[i]
						local attr = itemSlot[attrIdx]
						if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
							--根据道具等级随机一个属性等级
							local attrLv = hApi.MakeItemXiLianAttrLv(itemLv)
							local newAttr = hApi.GetItemRandomAttr(attrLv, excludeAttr)
							slotNum = slotNum + 1
							
							--填充数据
							strTag = strTag..";s"..slotNum..":"..(attrIdx)	--孔的位置
							strTag = strTag..";a"..slotNum..":"..(newAttr)	--孔里的新属性
						end
					end
					
					--判断孔的数量
					if slotNum > 0 then
						
						--填充数据
						strTag = ";an:"..slotNum..strTag..";"
						
						--消耗积分
						local costScore = hApi.GetItemXiLianScore(itemLv)
						local rmb, sendItemId = hApi.GetItemLockInfo(lockNum)
						--判断积分或游戏币是否足够
						if (LuaGetPlayerScore() >= costScore) and (LuaGetPlayerRmb() >= rmb) then
							
							hUI.NetDisable(30000)
							
							strTag = "sc:"..costScore..";ui:"..itemUId..";hi:"..heroId..strTag
							
							if type(rmb) == "number" then
								print("xilian xxx:", rmb, sendItemId)
							end
							
							--暂时使用6,等程序修改服务器流程
							--SendCmdFunc["order_begin"](1,sendItemId,rmb,1,hVar.tab_stringI[sendItemId][1],costScore,LuaGetForgeCount(),strTag)
							SendCmdFunc["order_begin"](6,sendItemId,rmb,1,hVar.tab_stringI[sendItemId][1],costScore,0,strTag)
											
							ret = true
						elseif (LuaGetPlayerScore() < costScore) then
							--strRet = "积分不足" --language
							strRet = hVar.tab_string["__TEXT_ScoreNotEnough"] --language
						else
							--strRet = "游戏币不足" --language
							strRet = hVar.tab_string["ios_not_enough_game_coin"] --language
						end
					else
						--todo:error 没有需要洗练的孔
						strRet = "没有需要洗练的孔"
					end
					
					
				else
					--todo:error 洗练道具孔数非法
					strRet = "洗练道具失败.s_max"
				end
				
			else
				--todo:error 主合成道具不存在
				strRet = "洗练道具失败.itab_null"
			end
			
		else
			--todo: error 洗练道具不存在
			strRet = "洗练道具失败.i_null"
		end
		
		print("XiLian Item end:----------------------------------------")
		
		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--通过订单系统 洗练道具成功返回
	hGlobal.event:listen("LocalEvent_order_xilian", "__ItemXiLianEvent", function(SC,order_type,order_id,strTag)
		--去掉菊花
		hUI.NetDisable(0)
		
		--据说要更新下作弊检测用的计数标记
		--等使用1的时候去掉注释
		--LuaSetForgeCount(SC)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		print("xilian item receive strtag:",strTag)
		
		if type(strTag) == "string" and string.find(strTag,"sc:") and string.find(strTag,"ui:") and string.find(strTag, "hi:") and string.find(strTag,"an:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end
			
			--升级积分消耗
			local costScore = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"sc:")+3,string.len(tempStr[1])))
			local itemUId = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"ui:")+3,string.len(tempStr[2])))
			local heroId = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"hi:")+3,string.len(tempStr[3])))
			
			local oItem
			--如果英雄id存在，则遍历英雄装备取得uid相等的道具
			if heroId > 0 then
				local oHero = hApi.GetHeroCardById(heroId)
				--print("oHero=", oHero, heroId)
				if oHero and oHero.equipment and type(oHero.equipment) == "table" then
					for i, tmpOItem in pairs(oHero.equipment) do
						--print("oHero.data.equipment", i, tmpOItem, itemUId)--, (tmpOItem and tmpOItem[hVar.ITEM_DATA_INDEX.UNIQUE]))
						if tmpOItem and type(tmpOItem) == "table" and tmpOItem[hVar.ITEM_DATA_INDEX.UNIQUE] == itemUId then
							oItem = tmpOItem
							break
						end
					end
				end
			else --如果英雄id不存在，则遍历背包uid相等的道具
				if Save_PlayerData.bag and type(Save_PlayerData.bag) == "table" then
					for i = 1, #Save_PlayerData.bag do
						local tmpOItem = Save_PlayerData.bag[i]
						if tmpOItem and type(tmpOItem) == "table" and tmpOItem[hVar.ITEM_DATA_INDEX.UNIQUE] == itemUId then
							oItem = Save_PlayerData.bag[i]
							break
						end
					end
				end
			end
			if oItem and type(oItem) == "table" then
				local slot = oItem[hVar.ITEM_DATA_INDEX.SLOT]
				local uid = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]
				
				if slot and type(slot) == "table" and uid == itemUId then
					
					ret = true
					
					--获得的道具扩展属性数量
					local nAttrNum = tonumber(string.sub(tempStr[4],string.find(tempStr[4],"an:")+3,string.len(tempStr[4])))
					
					--获得道具的扩展属性
					if nAttrNum > 0 then
						local k = 1 + 4
						for i = 1, nAttrNum do
							local attrIdx = tonumber((string.sub(tempStr[k],string.find(tempStr[k],"s"..i..":")+3,string.len(tempStr[k]))))
							k = k + 1
							local attr = (string.sub(tempStr[k],string.find(tempStr[k],"a"..i..":")+3,string.len(tempStr[k])))
							k = k + 1
							if slot[attrIdx] then
								slot[attrIdx] = attr
							end
						end
					end
					
					--扣除积分
					LuaAddPlayerScore(-costScore)
					
					--统计合成道具
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.xilianN)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.xilianN)
					
					--存储存档
					--保存存档
					if (heroId > 0) then
						LuaSaveHeroCard()
					end
					LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
				else
					--todo:error 道具不存在
					strRet = "操作的道具异常"
				end
			else
				--todo:error 道具不存在
				strRet = "道具不存在"
			end
			
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end
		
		if (not ret) then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";f"),order_type)
		else
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";t"),order_type)
		end
		
		--返回事件：本地洗炼道具结果
		hGlobal.event:event("Local_Event_ItemXiLian_Result", ret)
	end)
	
	--监听重铸道具事件（点击扩孔重铸按钮事件）
	hGlobal.event:listen("Event_ItemRebuildEvent", "__ItemRebuild_Event", function(oHero, rebuildItemIdx)
		print("oHero=", oHero, "rebuildItemIdx=", rebuildItemIdx)
		
		--rebuildItemIdx: 要重铸扩孔道具的背包索引位置
		
		print("Rebuild Item begin:----------------------------------------")
		
		--开始重铸
		--...
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--获取需要重铸的道具
		local oItem
		local heroId = 0
		if oHero and type(oHero) == "table" then
			oItem = oHero.data.equipment[rebuildItemIdx]
			heroId = oHero.data.id
		else
			oItem = Save_PlayerData.bag[rebuildItemIdx]
			heroId = 0
		end
		
		--如果主合成道具存在，则继续
		if oItem and type(oItem) == "table" then
			
			local itemId = oItem[hVar.ITEM_DATA_INDEX.ID]			--重铸道具id
			local itemSlot = oItem[hVar.ITEM_DATA_INDEX.SLOT]		--重铸道具属性
			local itemUId = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]		--道具唯一Id
			local itemTabI = hVar.tab_item[itemId]				--重铸道具tab表
			
			--如果主道具tab表存在，主道具是装备
			if itemTabI and hApi.CheckItemIsEquip(itemId) then
				
				--计算主道具tab基础倍率
				local itemLv = itemTabI.itemLv or hVar.ITEM_QUALITY.WHITE				--主道具道具品质
				local itemMaxSlot = hVar.ITEM_ATTR_EX_LIMIT[itemLv]
				
				--已有属性
				local excludeAttr = {}
				local attrNum = 0
				
				--有扩展属性的装备才能计算原有属性数量
				if itemSlot and type(itemSlot) == "table" then
					--遍历已有孔里的属性，计算实际属性数并将属性置入排除属性列表
					for i = 0, math.min(#itemSlot, itemMaxSlot) do
						local attr = itemSlot[i]
						if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
							excludeAttr[#excludeAttr + 1] = attr
							attrNum = attrNum + 1
						end
					end
				end
				
				local finalNum = attrNum + 1			--扩孔后的属性数
				--当最终孔数小于该品质最大孔数时处理扩孔
				if finalNum <= itemMaxSlot then
					
					local strTag = "ui:"..itemUId..";hi:"..heroId
					
					--根据道具等级随机一个属性等级
					--local attrLv = hApi.random(1, 5)	--这里纯随机了-。- old
					local attrLv = hApi.MakeItemXiLianAttrLv(itemLv) --new
					local newAttr = hApi.GetItemRandomAttr(attrLv, excludeAttr)
					
					--填充数据
					strTag = strTag..";s1:"..(finalNum)	--孔的位置
					strTag = strTag..";a1:"..(newAttr)	--孔里的新属性
					strTag = strTag..";"
					
					local rmb, sendItemId = hApi.GetItemRebuildInfo(finalNum)
					--判断游戏币是否足够
					if (LuaGetPlayerRmb() >= rmb) then
						
						hUI.NetDisable(30000)
						--暂时使用6,等程序修改服务器流程
						--SendCmdFunc["order_begin"](1,sendItemId,rmb,1,hVar.tab_stringI[sendItemId][1],0,LuaGetForgeCount(),strTag)
						SendCmdFunc["order_begin"](6,sendItemId,rmb,1,hVar.tab_stringI[sendItemId][1],0,0,strTag)
										
						ret = true
					else
						--strRet = "游戏币不足" --language
						strRet = hVar.tab_string["ios_not_enough_game_coin"] --language
					end
					
				else
					strRet = "该品质装备扩展属性已满"
				end
			else
				--todo:error 重铸道具不存在
				strRet = "重铸道具失败.itab_null"
			end
			
		else
			--todo: error 重铸扩孔道具不存在
			strRet = "重铸道具失败.i_null"
		end
		
		print("Rebuild Item end:----------------------------------------")
		
		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--通过订单系统 重铸道具成功返回
	hGlobal.event:listen("LocalEvent_order_rebuild", "__ItemRebuildEvent", function(SC, order_type, order_id, strTag)
		--去掉菊花
		hUI.NetDisable(0)
		
		--据说要更新下作弊检测用的计数标记
		--等使用1的时候去掉注释
		--LuaSetForgeCount(SC)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		print("rebuild item receive strtag:",strTag)
		
		if type(strTag) == "string" and string.find(strTag,"ui:") and string.find(strTag,"hi:") and string.find(strTag,"s1:") and string.find(strTag,"a1:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end
			
			--升级积分消耗
			local itemUId = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"ui:")+3,string.len(tempStr[1])))
			local heroId = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"hi:")+3,string.len(tempStr[2])))
			local attrIdx = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"s1:")+3,string.len(tempStr[3])))
			local attr = string.sub(tempStr[4],string.find(tempStr[4],"a1:")+3,string.len(tempStr[4]))
			
			local oItem
			--如果英雄id存在，则遍历英雄装备取得uid相等的道具
			if heroId > 0 then
				local oHero = hApi.GetHeroCardById(heroId)
				if oHero and (oHero.equipment) and (type(oHero.equipment) == "table") then
					for i, tmpOItem in pairs(oHero.equipment) do
						if tmpOItem and (type(tmpOItem) == "table") and (tmpOItem[hVar.ITEM_DATA_INDEX.UNIQUE] == itemUId) then
							oItem = tmpOItem
							break
						end
					end
				end
			else --如果英雄id不存在，则遍历背包uid相等的道具
				if Save_PlayerData.bag and (type(Save_PlayerData.bag) == "table") then
					for i = 1, #Save_PlayerData.bag, 1 do
						local tmpOItem = Save_PlayerData.bag[i]
						if tmpOItem and (type(tmpOItem) == "table") and (tmpOItem[hVar.ITEM_DATA_INDEX.UNIQUE] == itemUId) then
							oItem = Save_PlayerData.bag[i]
							break
						end
					end
				end
			end
			
			if oItem and type(oItem) == "table" then
				local slot = oItem[hVar.ITEM_DATA_INDEX.SLOT]
				local uid = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]
				
				--如果本身没有扩展属性，则重新设置为空表
				if not slot or type(slot) ~= "table" then
					oItem[hVar.ITEM_DATA_INDEX.SLOT] = {}
					--Save_PlayerData.bag[current_xilian_itemIdx][hVar.ITEM_DATA_INDEX.SLOT] = {}
					slot = oItem[hVar.ITEM_DATA_INDEX.SLOT]
				end
				
				if slot and type(slot) == "table" and uid == itemUId then
					
					ret = true
					slot[attrIdx] = attr
					
					print("attrIdx:", attrIdx, ",attr:",attr)
					
					--统计重铸
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.rebuidlN)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.rebuidlN)
					
					--存储存档
					--保存存档
					--保存存档
					if heroId > 0 then
						LuaSaveHeroCard()
					end
					LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
				else
					--todo:error 道具不存在
					strRet = "操作的道具异常"
				end
			else
				--todo:error 道具不存在
				strRet = "道具不存在"
			end
			
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end
		
		if (not ret) then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";f"),order_type)
		else
			--修改日志
			SendCmdFunc["order_update"](order_id,1,(strTag..";t"),order_type)
		end
		
		--返回事件：本地重铸道具结果
		hGlobal.event:event("Local_Event_ItemRebuild_Result", ret)
	end)
	
	--监听打开道具界面通知事件
	hGlobal.event:listen("localEvent_ShowPhone_ItemFrame", "__ShowItemFrm", function(showPageIdx, oHero, bagPage, bagOpItemIdx, bIsEquip)
		--print("localEvent_ShowPhone_ItemFrame", showPageIdx, oHero, bagPage, bagOpItemIdx, bIsEquip)
		--触发事件，显示金币界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneItemFrm:show(1)
		hGlobal.UI.PhoneItemFrm:active()
		
		--存储指定只显示的分页
		SpecifyShowPageIdx = showPageIdx or 0
		SpecifyOHero = oHero or 0
		SpecifyEquip = 0
		
		--存储背包的分页
		if (bagPage) then
			current_bag_page = bagPage
		else
			current_bag_page = 1 --默认显示背包第一个分页
		end
		
		--待操作的背包索引值
		bagOpItemIdx = bagOpItemIdx or 0
		
		--打开上一次的分页（默认显示第一个分页）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 3
		end
		if (SpecifyShowPageIdx > 0) then --如果传入参数指定只显示某个分页，那么只显示该分页
			lastPageIdx = showPageIdx
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--第2页的特殊处理
		if (bagOpItemIdx > 0) and (showPageIdx == 2) then
			local _frm = hGlobal.UI.PhoneItemFrm
			local _frmNode = _frm.childUI["PageNode"]
			local px, py = GetBagIndexTouchFocus(bagOpItemIdx) --获得背包对应位置的屏幕坐标
			local mainItemCtrl = _frmNode.childUI["MainItemImg"]
			local mainItem_x = mainItemCtrl.data.x
			local mainItem_y = mainItemCtrl.data.y
			local _frm = hGlobal.UI.PhoneItemFrm
			local _frmNode = _frm.childUI["PageNode"]
			local ctrl = _frmNode.childUI["Item" .. bagOpItemIdx]
			ctrl.data.codeOnTouch(ctrl, px, py, 1)
			ctrl.data.code(ctrl, mainItem_x, mainItem_y, 1)
			
			--如果该合成道具，是指定要给英雄穿上的，那么先存储这件装备
			if bIsEquip then
				SpecifyEquip = Save_PlayerData.bag[bagOpItemIdx]
			end
		end
			
		--只有在打开界面时才会监听的事件
		--监听：收到网络宝箱数量的事件
		hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
			--更新网络宝箱的数量和界面
			--RefreshChestFrame(NumTab)
		end)
		
		--监听：更新背包数据
		hGlobal.event:listen("Local_EventReflashPlayerBag", "__ItemReflashplayerBag_Frm", function()
			--更新本页背包
			OnCreateItemBagFrame(CurrentSelectRecord.pageIdx, current_bag_page)
		end)
		
		--监听：道具洗炼结果刷新本界面
		hGlobal.event:listen("Local_Event_ItemXiLian_Result", "__ItemXiLianSuccess_Frm", function(ret)
			--洗炼道具成功
			if ret then
				--播放道具洗炼的音效
				hApi.PlaySound("magic4")
				
				--播放洗炼成功动画
				PlayItemXiLianAnimation(function()
					--更新洗炼道具信息
					RefreshXilianItemInfo()
					
					--更新洗炼道具价格和按钮控件
					RefreshXiLianItemNoteFrm()
				end)
			end
		end)
		
		--监听：道具重铸结果刷新本界面
		hGlobal.event:listen("Local_Event_ItemRebuild_Result", "__ItemRebuildSuccess_Frm", function(ret)
			--重铸道具成功
			if ret then
				--播放道具重铸的音效
				hApi.PlaySound("magic3")
				
				--播放重铸成功动画
				PlayItemRebuildAnimation(function()
					--更新洗炼道具信息
					RefreshXilianItemInfo()
					
					--更新洗炼道具价格和按钮控件
					RefreshXiLianItemNoteFrm()
				end)
			end
		end)
		
		--查询网络宝箱的数量
		SendCmdFunc["get_chest_net_num"](0, luaGetplayerDataID(), 0)
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneItemFrm then --删除上一次的道具界面
	hGlobal.UI.PhoneItemFrm:del()
	hGlobal.UI.PhoneItemFrm = nil
end
hGlobal.UI.InitMyItemFrm() --测试创建道具界面
--触发事件，显示道具界面
hGlobal.event:event("localEvent_ShowPhone_ItemFrame", 1, nil, nil, nil, nil)
]]
