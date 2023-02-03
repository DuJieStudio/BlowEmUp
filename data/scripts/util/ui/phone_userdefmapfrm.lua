




--创建GM领取资源界面
hGlobal.UI.InitPlayerGMResourceFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowGMResourceFrm", "GMResourceFrm"}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _x,_y,_w,_h = hVar.SCREEN.w/2 - 480, hVar.SCREEN.h/2 + 600/2 - 15, 960, 600
	--local _pageIdx = 1 --当前页码
	local PAGE_X_NUM = {} --一行数量
	PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] = 4
	PAGE_X_NUM[hVar.ITEM_TYPE.BODY] = 3
	PAGE_X_NUM[hVar.ITEM_TYPE.ORNAMENTS] = 4
	PAGE_X_NUM[hVar.ITEM_TYPE.MOUNT] = 4
	--local PAGE_NUM = PAGE_X_NUM * 4
	local _cur_index = {[hVar.ITEM_TYPE.WEAPON] = 0, [hVar.ITEM_TYPE.BODY] = 0, [hVar.ITEM_TYPE.ORNAMENTS] = 0, [hVar.ITEM_TYPE.MOUNT] = 0,}
	local _cur_wall_type = 0 --墙面类型
	local _tRedBagListOrigin = {} --红装原始列表
	--local _tRedBagList = {} --红装列表（排序后）
	
	--神器界面相关参数
	local current_equiptypenum = {} --每个类型的神器的总数量
	local current_funCallbackOK = nil --回调函数
	local current_funCallbackCancel = nil --回调函数
	
	local current_inshow_itemtip = false --是否在显示道具tip
	
	--参数
	local MAX_SPEED_REDEQUIP = {} --神器最大速度
	local click_pos_x_redequip = {} --神器开始按下的坐标x
	local click_pos_y_redequip = {} --神器开始按下的坐标y
	local last_click_pos_x_redequip = {} --神器上一次按下的坐标x
	local last_click_pos_y_redequip = {} --神器上一次按下的坐标y
	local draggle_speed_x_redequip = {} --神器当前滑动的速度x
	local selected_redequip_idx = {} --神器选中的索引
	local click_scroll_redequip = {} --神器是否在滑动中
	local b_need_auto_fixing_redequip = {} --神器是否需要自动修正
	local friction_redequip = {} --阻力
	--武器
	MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON] = 50 --神器最大速度(武器)
	click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --神器开始按下的坐标x(武器)
	click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --神器开始按下的坐标y(武器)
	last_click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --神器上一次按下的坐标x(武器)
	last_click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --神器上一次按下的坐标y(武器)
	draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --神器当前滑动的速度x(武器)
	selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0 --神器选中的索引(武器)
	click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] = false --神器是否在滑动中(武器)
	b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = false --神器是否需要自动修正(武器)
	friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --阻力(武器)
	--防具
	MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY] = 50 --神器最大速度(防具)
	click_pos_x_redequip[hVar.ITEM_TYPE.BODY] = 0 --神器开始按下的坐标x(防具)
	click_pos_y_redequip[hVar.ITEM_TYPE.BODY] = 0 --神器开始按下的坐标y(防具)
	last_click_pos_x_redequip[hVar.ITEM_TYPE.BODY] = 0 --神器上一次按下的坐标x(防具)
	last_click_pos_y_redequip[hVar.ITEM_TYPE.BODY] = 0 --神器上一次按下的坐标y(防具)
	draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0 --神器当前滑动的速度x(防具)
	selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0 --神器选中的索引(防具)
	click_scroll_redequip[hVar.ITEM_TYPE.BODY] = false --神器是否在滑动中(防具)
	b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = false --神器是否需要自动修正(防具)
	friction_redequip[hVar.ITEM_TYPE.BODY] = 0 --阻力(防具)
	--宝物
	MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS] = 50 --神器最大速度(宝物)
	click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器开始按下的坐标x(宝物)
	click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器开始按下的坐标y(宝物)
	last_click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器上一次按下的坐标x(宝物)
	last_click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器上一次按下的坐标y(宝物)
	draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器当前滑动的速度x(宝物)
	selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器选中的索引(宝物)
	click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false --神器是否在滑动中(宝物)
	b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false --神器是否需要自动修正(宝物)
	friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --阻力(宝物)
	--坐骑
	MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT] = 50 --神器最大速度(坐骑)
	click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --神器开始按下的坐标x(坐骑)
	click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --神器开始按下的坐标y(坐骑)
	last_click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --神器上一次按下的坐标x(坐骑)
	last_click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --神器上一次按下的坐标y(坐骑)
	draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --神器当前滑动的速度x(坐骑)
	selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0 --神器选中的索引(坐骑)
	click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] = false --神器是否在滑动中(坐骑)
	b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = false --神器是否需要自动修正(坐骑)
	friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --阻力(坐骑)
	
	local on_receive_systime_gmresource = hApi.DoNothing --收到系统时间回调
	local _createRedGiftBagInfo = hApi.DoNothing --根据红装道具信息创建 道具图片
	local _createRedGiftBagClickAreaInfo = hApi.DoNothing --创建响应区域
	local getLeftRightOffset_RedEquip = hApi.DoNothing --获得神器第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
	local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	local OnClickedEquipBtn = hApi.DoNothing --点击神器按钮
	local refresh_redequip_UI_scroll_loop_weapon = hApi.DoNothing --自动调整神器控件的滑动(武器)
	local refresh_redequip_UI_scroll_loop_body = hApi.DoNothing --自动调整神器控件的滑动(防具)
	local refresh_redequip_UI_scroll_loop_ornaments = hApi.DoNothing --自动调整神器控件的滑动(宝物)
	local refresh_redequip_UI_scroll_loop_mount = hApi.DoNothing --自动调整神器控件的滑动(坐骑)
	local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动(整个面板)
	local get_btn_state = hApi.DoNothing --获得按钮的状态
	
	--控制参数(整个面板)
	local click_pos_x_dlcmapinfo = 0 --开始按下的坐标x
	local click_pos_y_dlcmapinfo = 0 --开始按下的坐标y
	local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标x
	local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标y
	local draggle_speed_y_dlcmapinfo = 0 --当前滑动的速度x
	local selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
	local click_scroll_dlcmapinfo = false --是否在滑动DLC地图面板中
	local b_need_auto_fixing_dlcmapinfo = false --是否需要自动修正
	local friction_dlcmapinfo = 0 --阻力
	
	local MAX_SPEED = 50 --最大速度
	
	--删除上一次的领取神器界面
	if hGlobal.UI.PlayerGMResourceFrm then
		hGlobal.UI.PlayerGMResourceFrm:del()
		hGlobal.UI.PlayerGMResourceFrm = nil
	end
	
	--删除上一次的刷新界面滚动的timer
	hApi.clearTimer("__GMRESOURCE_WEAPON_SELECT_TIMER_UPDATE__")
	hApi.clearTimer("__GMRESOURCE_BODY_SELECT_TIMER_UPDATE__")
	hApi.clearTimer("__GMRESOURCE_ORNAMENTS_SELECT_TIMER_UPDATE_")
	hApi.clearTimer("__GMRESOURCE_MOUNT_SELECT_TIMER_UPDATE__")
	hApi.clearTimer("__GMRESOURCE_ALLPANEL_SELECT_TIMER_UPDATE__")
	
	--移除事件监听：收到系统时间回调
	hGlobal.event:listen("localEvent_refresh_Systime", "showsystime", nil)
	
	--领取神器界面
	hGlobal.UI.PlayerGMResourceFrm = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 2,
		w = _w,
		h = _h,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		--bgMode = "tile",
		background = "misc/billboard/msgbox5.png", --"UI:Tactic_Background",
		border = 0,
		autoactive = 0,
	})
	
	local _frm = hGlobal.UI.PlayerGMResourceFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	local _itemX, _itemY = 160, -175
	local _itemOffX, _itemOffY = 160, 170
	local _itemW = 64
	
	--左侧裁剪区域-红装神器
	local _BTC_PageClippingRect_RedEquip = {100, -80, 610, _h - 170, 0,}
	local _BTC_pClipNode_RedEquip = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_RedEquip, 99, _BTC_PageClippingRect_RedEquip[5], "_BTC_pClipNode_RedEquip")
	
	--[[
	--标题底图
	_childUI["titleBG"] = hUI.image:new({
		parent = _parent,
		model = "misc/chest/get_new_hero_bar.png",
		x = 480,
		y = -6,
		w = 395,
		h = 73,
	})
	
	local strTitleName = ""
	if (current_rewardType == 4) then --英雄
		strTitleName = hVar.tab_string["hero"]
	elseif (current_rewardType == 5) then --英雄将魂
		strTitleName = hVar.tab_string["hero"] .. hVar.tab_string["__TEXT_ITEM_TYPE_SOULSTONE"]
	elseif (current_rewardType == 6) then --战术卡碎片
		strTitleName = hVar.tab_string["__TEXT_MAINUI_BTN_TACITC"] .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"]
	end
	]]
	
	--[[
	--标题文字
	_childUI["titleBG"] = hUI.label:new({
		parent = _parent,
		align = "MC",
		border = 1,
		font = hVar.FONTC,
		x = 480,
		y = -6+9,
		text = hVar.tab_string["__TEXT_SELECT"] .. strTitleName, --"选择XXX"
		size = 26,
		width = 500,
		RGB = {255, 255, 0,},
	})
	]]
	
	--面板的结束方法
	local _RemoveList = {}
	local _RemoveList_Stable = {}
	--local _btnState = {}
	local _exitFunc = function()
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		
		for i = 1,#_RemoveList_Stable do
			hApi.safeRemoveT(_childUI,_RemoveList_Stable[i])
		end
		_RemoveList_Stable = {}
		
		--移除刷新界面滚动的timer
		hApi.clearTimer("__GMRESOURCE_WEAPON_SELECT_TIMER_UPDATE__")
		hApi.clearTimer("__GMRESOURCE_BODY_SELECT_TIMER_UPDATE__")
		hApi.clearTimer("__GMRESOURCE_ORNAMENTS_SELECT_TIMER_UPDATE_")
		hApi.clearTimer("__GMRESOURCE_MOUNT_SELECT_TIMER_UPDATE__")
		hApi.clearTimer("__GMRESOURCE_ALLPANEL_SELECT_TIMER_UPDATE__")
		
		--移除事件监听：收到系统时间回调
		hGlobal.event:listen("localEvent_refresh_Systime", "showsystime", nil)
		
		--初始化按钮状态
		--for i = 1,#_btnState do 
		--	_btnState[i] = 0
		--end
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
	end
	
	--关闭按钮
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/purchase/close.png", --"BTN:PANEL_CLOSE",
		x = _frm.data.w - 4,
		y = -8,
		scaleT = 0.95,
		code = function()
			--隐藏本界面
			_frm:show(0)
			_exitFunc()
			
			--回调函数
			if (type(current_funCallbackCancel) == "function") then
				current_funCallbackCancel()
			end
		end,
	})
	
	--[[
	--选中框
	_childUI["giftSelectBox"] = hUI.button:new({ --作为按钮只是为了挂载子控件
		parent = _parent,
		model = -1,
		w = 1,
		h = 1,
		z = 100,
	})
	_childUI["giftSelectBox"]:setstate(-1) --一开始不显示
	--选中框
	_childUI["giftSelectBox"].childUI["border"] = hUI.button:new({ --作为按钮只是为了挂载子控件
		parent = _childUI["giftSelectBox"].handle._n,
		model = "UI:skillup",
		x = 0,
		y = 16,
		w = _itemW + 40,
		h = _itemW + 40,
	})
	--勾勾
	_childUI["giftSelectBox"].childUI["border"] = hUI.button:new({ --作为按钮只是为了挂载子控件
		parent = _childUI["giftSelectBox"].handle._n,
		model = "UI:ok",
		x = 20,
		y = -6,
		w = 40,
		h = 40,
	})
	]]
	--收到系统时间回调
	on_receive_systime_gmresource = function()
		--取消挡操作
		hUI.NetDisable(0)
		
		--[[
		--按照武器、防具、宝物、马的顺序，重新排列表
		--local redEquipIdList = {}
		local redWeapon = {}
		local redBody = {}
		local redOrnamesnts = {}
		local redHorse = {}
		for i = 1, #redList, 1 do
			local itemId = redList[i]
			local tabI = hVar.tab_item[itemId]
			if tabI then
				local itemType = tabI.type
				if (itemType == hVar.ITEM_TYPE.WEAPON) then --武器
					redWeapon[#redWeapon+1] = itemId
				elseif (itemType == hVar.ITEM_TYPE.BODY) then --防具
					redBody[#redBody+1] = itemId
					--print(itemId)
				elseif (itemType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
					redOrnamesnts[#redOrnamesnts+1] = itemId
				elseif (itemType == hVar.ITEM_TYPE.MOUNT) then --马
					redHorse[#redHorse+1] = itemId
				end
			end
		end
		
		--统计每个分类总数量
		current_equiptypenum[hVar.ITEM_TYPE.WEAPON] = #redWeapon --武器
		current_equiptypenum[hVar.ITEM_TYPE.BODY] = #redBody --防具
		current_equiptypenum[hVar.ITEM_TYPE.ORNAMENTS] = #redOrnamesnts --宝物
		current_equiptypenum[hVar.ITEM_TYPE.MOUNT] = #redHorse --马
		
		--按照等级排序
		local sortFun = function(a, b)
			local tItem1 = hVar.tab_item[a]
			local tItem2 = hVar.tab_item[b]
			
			if (tItem1.require[1][2] ~= tItem2.require[1][2]) then
				return (tItem1.require[1][2]< tItem2.require[1][2]) --等级低的
			else
				return (a < b) --id小的
			end
		end
		
		--每个部位排序
		table.sort(redWeapon, sortFun)
		table.sort(redBody, sortFun)
		table.sort(redOrnamesnts, sortFun)
		table.sort(redHorse, sortFun)
		
		--每个部位补足7件
		if (#redWeapon < PAGE_X_NUM) then
			for i = 1, (PAGE_X_NUM - #redWeapon), 1 do
				redWeapon[#redWeapon+1] = 0
			end
		end
		if (#redBody < PAGE_X_NUM) then
			for i = 1, (PAGE_X_NUM - #redBody), 1 do
				redBody[#redBody+1] = 0
			end
		end
		if (#redOrnamesnts < PAGE_X_NUM) then
			for i = 1, (PAGE_X_NUM - #redOrnamesnts), 1 do
				redOrnamesnts[#redOrnamesnts+1] = 0
			end
		end
		if (#redHorse < PAGE_X_NUM) then
			for i = 1, (PAGE_X_NUM - #redHorse), 1 do
				redHorse[#redHorse+1] = 0
			end
		end
		
		--_childUI["confirmBtn"]:setstate(0)
		]]
		
		--按照武器、防具、宝物、马的顺序，重新排列表
		--local redEquipIdList = {}
		local redWeapon = {"maze/space_back_01_small.png", "maze/space_back_02_small.png","maze/space_back_03_small.png","maze/space_back_04_small.png","maze/space_back_05_small.png","maze/space_back_06_small.png",}
		local redBody = {"maze/mazeskin_001_small.png", "maze/mazeskin_002_small.png","maze/mazeskin_003_small.png","maze/mazeskin_004_small.png","maze/mazeskin_005_small.png","maze/mazeskin_006_small.png",}
		local redOrnamesnts = {}
		local redHorse = {}
		
		--统计每个分类总数量
		current_equiptypenum[hVar.ITEM_TYPE.WEAPON] = #redWeapon --武器
		current_equiptypenum[hVar.ITEM_TYPE.BODY] = #redBody --防具
		current_equiptypenum[hVar.ITEM_TYPE.ORNAMENTS] = #redOrnamesnts --宝物
		current_equiptypenum[hVar.ITEM_TYPE.MOUNT] = #redHorse --马
		
		_cur_index = {[hVar.ITEM_TYPE.WEAPON] = 0, [hVar.ITEM_TYPE.BODY] = 0, [hVar.ITEM_TYPE.ORNAMENTS] = 0, [hVar.ITEM_TYPE.MOUNT] = 0,}
		_cur_wall_type = 0 --墙面类型初始化
		_tRedBagListOrigin[hVar.ITEM_TYPE.WEAPON] = redWeapon --红装原始列表
		_tRedBagListOrigin[hVar.ITEM_TYPE.BODY] = redBody --红装原始列表
		_tRedBagListOrigin[hVar.ITEM_TYPE.ORNAMENTS] = redOrnamesnts --红装原始列表
		_tRedBagListOrigin[hVar.ITEM_TYPE.MOUNT] = redHorse --红装原始列表
		--_tRedBagList = redEquipIdList
		--_childUI["giftSelectBox"]:setstate(-1)
		
		--创建红装信息
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		for i = 1,#_RemoveList_Stable do
			hApi.safeRemoveT(_childUI,_RemoveList_Stable[i])
		end
		_RemoveList_Stable = {}
		
		_createRedGiftBagInfo(redWeapon, hVar.ITEM_TYPE.WEAPON)
		_createRedGiftBagInfo(redBody, hVar.ITEM_TYPE.BODY)
		_createRedGiftBagInfo(redOrnamesnts, hVar.ITEM_TYPE.ORNAMENTS)
		_createRedGiftBagInfo(redHorse, hVar.ITEM_TYPE.MOUNT)
		_createRedGiftBagClickAreaInfo()
		
		--创建timer，刷新神器滚动
		hApi.addTimerForever("__GMRESOURCE_WEAPON_SELECT_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_redequip_UI_scroll_loop_weapon)
		hApi.addTimerForever("__GMRESOURCE_BODY_SELECT_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_redequip_UI_scroll_loop_body)
		hApi.addTimerForever("__GMRESOURCE_ORNAMENTS_SELECT_TIMER_UPDATE_", hVar.TIMER_MODE.GAMETIME, 30, refresh_redequip_UI_scroll_loop_ornaments)
		hApi.addTimerForever("__GMRESOURCE_MOUNT_SELECT_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_redequip_UI_scroll_loop_mount)
		hApi.addTimerForever("__GMRESOURCE_ALLPANEL_SELECT_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_loop)
		
	end
	
	--根据红装道具信息创建 道具图片
	_createRedGiftBagInfo = function(redEquipIdList, equipType)
		for i = 1, #redEquipIdList, 1 do
			local imgName = redEquipIdList[i]
			if imgName then
				--标记该位置有效
				--_btnState[i] = 1
				
				local itemPosX = _itemX + (i - 1) * _itemOffX
				local itemPosY = 0
				local itemWH = 96
				if (equipType == hVar.ITEM_TYPE.WEAPON) then --武器
					itemPosX = _itemX + 10 + (i - 1) * (_itemOffX - 16)
					itemPosY = _itemY - 10 - _itemOffY * 0
					itemWH = 120
				elseif (equipType == hVar.ITEM_TYPE.BODY) then --防具
					itemPosX = _itemX + 30 + (i - 1) * (_itemOffX + 30)
					itemPosY = _itemY - 62 - _itemOffY * 1
					itemWH = 160
				elseif (equipType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
					itemPosY = _itemY - _itemOffY * 2
				elseif (equipType == hVar.ITEM_TYPE.MOUNT) then --马
					itemPosY = _itemY - _itemOffY * 3
				end
				
				--神器父控件
				_childUI["RedEquip_" .. equipType .. "_" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _BTC_pClipNode_RedEquip,
					model = "misc/mask.png",
					--model = -1,
					x = itemPosX,
					y = itemPosY,
					w = itemWH,
					h = itemWH,
				})
				_childUI["RedEquip_" .. equipType .. "_" .. i].handle.s:setOpacity(0) --只响应事件，不显示
				_childUI["RedEquip_" .. equipType .. "_" .. i].data.itemId = imgName --标记道具id
				_childUI["RedEquip_" .. equipType .. "_" .. i].data.equipType = equipType --标记道具类型
				_childUI["RedEquip_" .. equipType .. "_" .. i].data.selectstate = 0 --标记不是选中状态
				_RemoveList[#_RemoveList+1] = "RedEquip_" .. equipType .. "_" .. i
				
				
				--道具背景图
				_childUI["RedEquip_" .. equipType .. "_" .. i].childUI["bg"] = hUI.image:new({
					parent = _childUI["RedEquip_" .. equipType .. "_" .. i].handle._n,
					model = "misc/mask_white.png",
					x = 0,
					y = 0,
					w = itemWH,
					h = itemWH,
				})
				
				--道具图标
				_childUI["RedEquip_" .. equipType .. "_" .. i].childUI["icon"] = hUI.image:new({
					parent = _childUI["RedEquip_" .. equipType .. "_" .. i].handle._n,
					model = imgName,
					x = 0,
					y = 0,
					w = itemWH - 12,
					h = itemWH - 12,
				})
				
				--选中框
				_childUI["RedEquip_" .. equipType .. "_" .. i].childUI["selectbox"] = hUI.button:new({ --选中框
					parent = _childUI["RedEquip_" .. equipType .. "_" .. i].handle._n,
					model = -1,
					x = 0,
					y = 0,
					w = 1,
					h = 1,
				})
				_childUI["RedEquip_" .. equipType .. "_" .. i].childUI["selectbox"]:setstate(-1) --默认不显示选中框
				local s9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/tactic_frame.png", 0, 0, itemWH, itemWH, _childUI["RedEquip_" .. equipType .. "_" .. i].childUI["selectbox"])
				--s9:setOpacity(128)
				--s9:setColor(ccc3(144, 144, 144))
				
				--勾勾
				_childUI["RedEquip_" .. equipType .. "_" .. i].childUI["selectbox"].childUI["border"] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _childUI["RedEquip_" .. equipType .. "_" .. i].childUI["selectbox"].handle._n,
					model = "UI:ok",
					x = itemWH/2 - 24,
					y = -itemWH/2+24,
					w = 36,
					h = 36,
				})
			end
		end
	end
	
	--创建响应区域
	_createRedGiftBagClickAreaInfo = function()
		--[[
		--标题
		local strTitleName = ""
		if (current_rewardType == 3) then --道具
			strTitleName = hVar.tab_string["__TEXT_MAINUI_BTN_ITEM"]
		elseif (current_rewardType == 4) then --英雄
			strTitleName = hVar.tab_string["hero"]
		elseif (current_rewardType == 5) then --英雄将魂
			strTitleName = hVar.tab_string["hero"] .. hVar.tab_string["__TEXT_ITEM_TYPE_SOULSTONE"]
		elseif (current_rewardType == 6) then --战术卡碎片
			strTitleName = hVar.tab_string["__TEXT_MAINUI_BTN_TACITC"] .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"]
		elseif (current_rewardType == 10) then --神器
			strTitleName = hVar.tab_string["__TEXT_ShenQi"]
		end
		
		--各部位图腾
		local strImgWeapon = ""
		local strImgBody = ""
		local strImgOrnamesnts = ""
		local strImgHorce = ""
		local nScale = 1
		if (current_rewardType == 3) then --道具
			strImgWeapon = "ui/itempageflag4.png"
			strImgBody = "ui/itempageflag3.png"
			strImgOrnamesnts = "ui/itempageflag5.png"
			strImgHorce = "ui/itempageflag6.png"
			nScale = 0.6
		elseif (current_rewardType == 4) then --英雄
			strImgWeapon = "misc/legion/flag_shu_s.png"
			strImgBody = "misc/legion/flag_wei_s.png"
			strImgOrnamesnts = "misc/legion/flag_wu_s.png"
			strImgHorce = "misc/legion/flag_qun_s.png"
			nScale = 1
		elseif (current_rewardType == 5) then --英雄将魂
			strImgWeapon = "misc/legion/flag_shu_s.png"
			strImgBody = "misc/legion/flag_wei_s.png"
			strImgOrnamesnts = "misc/legion/flag_wu_s.png"
			strImgHorce = "misc/legion/flag_qun_s.png"
			nScale = 1
		elseif (current_rewardType == 6) then --战术卡碎片
			strImgWeapon = "UI:QIANGHUA_FREE_TICKET"
			strImgBody = "icon/item/card_lv1.png"
			strImgOrnamesnts = "icon/item/card_lv2.png"
			strImgHorce = "icon/item/card_lv3.png"
			nScale = 0.8
		elseif (current_rewardType == 10) then --神器
			strImgWeapon = "ui/itempageflag4.png"
			strImgBody = "ui/itempageflag3.png"
			strImgOrnamesnts = "ui/itempageflag5.png"
			strImgHorce = "ui/itempageflag6.png"
			nScale = 0.6
		end
		]]
		
		--标记第一个控件
		_childUI["title"] = hUI.label:new({
			parent = _parent,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			x = 150,
			y = -100,
			text = "", --"选择XXXX"
			size = 26,
			width = 500,
			RGB = {255, 255, 0,},
		})
		_RemoveList[#_RemoveList+1] = "title"
		
		--选择背景
		_childUI["tipLab1"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			align = "LT",
			border = 1,
			font = hVar.FONTC,
			x = 110,
			y = -84,
			text = "选择背景", --"选择XXXX"
			size = 26,
			width = 500,
			RGB = {255, 255, 0,},
		})
		_RemoveList[#_RemoveList+1] = "tipLab1"
		
		--选择地形
		_childUI["tipLab2"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			align = "LT",
			border = 1,
			font = hVar.FONTC,
			x = 110,
			y = -284,
			text = "选择地形", --"选择XXXX"
			size = 26,
			width = 500,
			RGB = {255, 255, 0,},
		})
		_RemoveList[#_RemoveList+1] = "tipLab2"
		
		--选择墙面
		_childUI["tipLab3"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			align = "LT",
			border = 1,
			font = hVar.FONTC,
			x = 110,
			y = -528,
			text = "选择墙面", --"选择XXXX"
			size = 26,
			width = 500,
			RGB = {255, 255, 0,},
		})
		_RemoveList[#_RemoveList+1] = "tipLab3"
		
		--分界线
		_childUI["apartline_1"] = hUI.image:new({
			parent = _parent,
			model = "UI:panel_part_09",
			x = _w/2,
			y = -80,
			w = _w+20,
			h = 8,
		})
		_RemoveList_Stable[#_RemoveList_Stable+1] = "apartline_1"
		
		--绘制每各部位的图腾
		local totenX = 45
		local _totenY = _itemY + 110
		
		--[[
		--武器图腾
		_childUI["giftItem_image_weapon"] = hUI.image:new({
			parent = _parent,
			model = strImgWeapon,
			x = totenX,
			y = _totenY - _itemOffY * 1,
			scale = nScale,
		})
		_RemoveList[#_RemoveList+1] = "giftItem_image_weapon"
		
		--防具图腾
		_childUI["giftItem_image_body"] = hUI.image:new({
			parent = _parent,
			model = strImgBody,
			x = totenX,
			y = _totenY - _itemOffY * 2,
			scale = nScale,
		})
		_RemoveList[#_RemoveList+1] = "giftItem_image_body"
		
		--宝物图腾
		_childUI["giftItem_image_ornamesnts"] = hUI.image:new({
			parent = _parent,
			model = strImgOrnamesnts,
			x = totenX,
			y = _totenY - _itemOffY * 3,
			scale = nScale,
		})
		_RemoveList[#_RemoveList+1] = "giftItem_image_ornamesnts"
		
		--马图腾
		_childUI["giftItem_image_horce"] = hUI.image:new({
			parent = _parent,
			model = strImgHorce,
			x = totenX,
			y = _totenY - _itemOffY * 4,
			scale = nScale,
		})
		_RemoveList[#_RemoveList+1] = "giftItem_image_horce"
		]]
		
		--神器左侧提示左翻页的图片(武器)
		_childUI["RedEquipPageLeft_Weapon"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX - 90 - 1000,
			y = _itemY - 4, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageLeft_Weapon"].handle.s:setRotation(0)
		_childUI["RedEquipPageLeft_Weapon"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(false) --默认不显示左分翻页提示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Weapon"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageLeft_Weapon"].handle._n:runAction(forever)
		
		--神器右侧提示右翻页的图片(武器)
		_childUI["RedEquipPageRight_Weapon"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _w - 220 + 1000, --非对称式
			y = _itemY + 0, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageRight_Weapon"].handle.s:setRotation(180)
		_childUI["RedEquipPageRight_Weapon"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		--if (#hVar.RedEquip <= PAGE_X_NUM) then
		_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--end
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Weapon"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageRight_Weapon"].handle._n:runAction(forever)
		
		--[[
		--按钮
		--向左翻页的按钮的接受左点击事件的响应区域(武器)
		_childUI["RedEquipPageLeft_Btn_Weapon"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _itemX - 110,
			y = _itemY,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) then
					--print("向左滚屏", screenY)
					--向左滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = true
					friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON] / 2.0 --左速度
				end
			end,
		})
		_childUI["RedEquipPageLeft_Btn_Weapon"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Btn_Weapon"
		
		--按钮
		--向右翻页的按钮的接受左点击事件的响应区域(武器)
		_childUI["RedEquipPageRight_Btn_Weapon"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _w - 200, --非对称式
			y = _itemY,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) then
					--print("向右滚屏", screenY)
					--向右滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = true
					friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON] / 2.0 --右速度
				end
			end,
		})
		_childUI["RedEquipPageRight_Btn_Weapon"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Btn_Weapon"
		]]
		
		--神器左侧提示左翻页的图片(防具)
		_childUI["RedEquipPageLeft_Body"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX - 90 - 1000,
			y = _itemY - _itemOffY - 64, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageLeft_Body"].handle.s:setRotation(0)
		_childUI["RedEquipPageLeft_Body"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(false) --默认不显示左分翻页提示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Body"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageLeft_Body"].handle._n:runAction(forever)
		
		--神器右侧提示右翻页的图片(防具)
		_childUI["RedEquipPageRight_Body"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _w - 220 + 1000, --非对称式
			y = _itemY - _itemOffY - 60, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageRight_Body"].handle.s:setRotation(180)
		_childUI["RedEquipPageRight_Body"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		--if (#hVar.RedEquip <= PAGE_X_NUM) then
		_childUI["RedEquipPageRight_Body"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--end
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Body"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageRight_Body"].handle._n:runAction(forever)
		
		--[[
		--按钮
		--向左翻页的按钮的接受左点击事件的响应区域(防具)
		_childUI["RedEquipPageLeft_Btn_Body"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _itemX - 110,
			y = _itemY - _itemOffY - 60,
			w = 80,
			h = _itemOffY - 2+40,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.BODY --防具
				local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.BODY]) then
					--print("向左滚屏", screenY)
					--向左滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = true
					friction_redequip[hVar.ITEM_TYPE.BODY] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY] / 2.0 --左速度
				end
			end,
		})
		_childUI["RedEquipPageLeft_Btn_Body"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Btn_Body"
		
		--按钮
		--向右翻页的按钮的接受左点击事件的响应区域(防具)
		_childUI["RedEquipPageRight_Btn_Body"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _w - 200, --非对称式
			y = _itemY - _itemOffY - 60,
			w = 80,
			h = _itemOffY - 2+40,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.BODY --防具
				local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.BODY]) then
					--print("向右滚屏", screenY)
					--向右滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = true
					friction_redequip[hVar.ITEM_TYPE.BODY] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY] / 2.0 --右速度
				end
			end,
		})
		_childUI["RedEquipPageRight_Btn_Body"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Btn_Body"
		]]
		
		--[[
		--神器左侧提示左翻页的图片(宝物)
		_childUI["RedEquipPageLeft_Ornaments"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX - 80,
			y = _itemY - _itemOffY * 2 - 4, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageLeft_Ornaments"].handle.s:setRotation(0)
		_childUI["RedEquipPageLeft_Ornaments"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(false) --默认不显示左分翻页提示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Ornaments"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageLeft_Ornaments"].handle._n:runAction(forever)
		
		--神器右侧提示右翻页的图片(宝物)
		_childUI["RedEquipPageRight_Ornaments"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _w - 10, --非对称式
			y = _itemY - _itemOffY * 2 + 0, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageRight_Ornaments"].handle.s:setRotation(180)
		_childUI["RedEquipPageRight_Ornaments"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		--if (#hVar.RedEquip <= PAGE_X_NUM) then
		_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--end
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Ornaments"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageRight_Ornaments"].handle._n:runAction(forever)
		
		--按钮
		--向左翻页的按钮的接受左点击事件的响应区域(宝物)
		_childUI["RedEquipPageLeft_Btn_Ornaments"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _itemX - 120,
			y = _itemY - _itemOffY * 2,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.ORNAMENTS]) then
					--print("向左滚屏", screenY)
					--向左滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = true
					friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS] / 2.0 --左速度
				end
			end,
		})
		_childUI["RedEquipPageLeft_Btn_Ornaments"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Btn_Ornaments"
		
		--按钮
		--向右翻页的按钮的接受左点击事件的响应区域(宝物)
		_childUI["RedEquipPageRight_Btn_Ornaments"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _w  - 200, --非对称式
			y = _itemY - _itemOffY * 2,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.ORNAMENTS]) then
					--print("向右滚屏", screenY)
					--向右滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = true
					friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS] / 2.0 --右速度
				end
			end,
		})
		_childUI["RedEquipPageRight_Btn_Ornaments"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Btn_Ornaments"
		
		--神器左侧提示左翻页的图片(坐骑)
		_childUI["RedEquipPageLeft_Mount"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX - 80,
			y = _itemY - _itemOffY * 3 - 4, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageLeft_Mount"].handle.s:setRotation(0)
		_childUI["RedEquipPageLeft_Mount"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(false) --默认不显示左分翻页提示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Mount"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageLeft_Mount"].handle._n:runAction(forever)
		
		--神器右侧提示右翻页的图片(坐骑)
		_childUI["RedEquipPageRight_Mount"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _w - 10, --非对称式
			y = _itemY - _itemOffY * 3 + 0, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["RedEquipPageRight_Mount"].handle.s:setRotation(180)
		_childUI["RedEquipPageRight_Mount"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		--if (#hVar.RedEquip <= PAGE_X_NUM) then
		_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--end
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Mount"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["RedEquipPageRight_Mount"].handle._n:runAction(forever)
		]]
		
		--神器上侧提示左翻页的图片(整个面板)
		_childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2 + 5,
			y = _itemY + 114, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["DLCMapInfoPageUp"].handle.s:setRotation(90)
		_childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		_RemoveList_Stable[#_RemoveList_Stable+1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--神器右侧提示下翻页的图片(整个面板)
		_childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2 + 5,
			y = _itemY - _itemOffY * 2 - 10, --非对称式
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_childUI["DLCMapInfoPageDown"].handle.s:setRotation(270)
		_childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		--if (#hVar.RedEquip <= PAGE_X_NUM) then
		--_childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--end
		_RemoveList_Stable[#_RemoveList_Stable+1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		
		--按钮
		--[[
		--向左翻页的按钮的接受左点击事件的响应区域(坐骑)
		_childUI["RedEquipPageLeft_Btn_Mount"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _itemX - 100,
			y = _itemY - _itemOffY * 3,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.MOUNT --坐骑
				local equiptypenum = current_equiptypenum[equipType] --坐骑分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.MOUNT]) then
					--print("向左滚屏", screenY)
					--向左滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = true
					friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT] / 2.0 --左速度
				end
			end,
		})
		_childUI["RedEquipPageLeft_Btn_Mount"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageLeft_Btn_Mount"
		
		--按钮
		--向右翻页的按钮的接受左点击事件的响应区域(坐骑)
		_childUI["RedEquipPageRight_Btn_Mount"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = _w + 10, --非对称式
			y = _itemY - _itemOffY * 3,
			w = 80,
			h = _itemOffY - 2,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				local equipType = hVar.ITEM_TYPE.MOUNT --坐骑
				local equiptypenum = current_equiptypenum[equipType] --坐骑分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--超过一页的数量才滑屏
				if (equiptypenum > PAGE_X_NUM[hVar.ITEM_TYPE.MOUNT]) then
					--print("向右滚屏", screenY)
					--向右滚屏
					b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = true
					friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT] / 2.0 --右速度
				end
			end,
		})
		_childUI["RedEquipPageRight_Btn_Mount"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipPageRight_Btn_Mount"
		]]
		
		--左侧用于检测滑动事件的控件(武器)
		_childUI["RedEquipDragPanel_Weapon"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2 + 5,
			y = _itemY,
			w = _itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] - 2 - 10,
			h = _itemOffY - 2,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					--current_inshow_itemtip = false
					
					return
				end
				
				click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] = touchX --开始按下的坐标x
				click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON] = touchY --开始按下的坐标y
				last_click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] = touchX --上一次按下的坐标x
				last_click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON] = touchY --上一次按下的坐标y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --当前速度为0
				selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0 --神器选中的索引
				click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] = true --是否滑动神器
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = false --不需要自动修正位置
				friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.WEAPON]=", click_scroll_redequip[hVar.ITEM_TYPE.WEAPON])
				
				--如果神器数量未铺满一页，那么不需要滑动
				--左面对其左顶线，右面在在右底线之左
				if (delta1_lx == 0) and (deltNa_rx <= 0) then
					click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] = false --不需要滑动神器
				end
				
				--清除神器选中状态
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				--OnClickedEquipBtn(equipType, 0)
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON]
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] > MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON]
				end
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] < -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.WEAPON]
				end
				
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最左侧的x坐标
				local deltNa_rx = 0 --最后一个DLC地图面板最右侧的x坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.WEAPON]=", click_scroll_redequip[hVar.ITEM_TYPE.WEAPON])
				--在滑动过程中才会处理滑动
				if click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] then
					local deltaX = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] --与开始按下的位置的偏移值x
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + deltaX) >= 0) then --防止走过
						deltaX = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
						
						_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(false) --左分翻页不显示
					else
						_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(true) --左分翻页显示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(false) --右分翻页显示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(true) --右分翻页不显示
					end
					
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x + deltaX, ctrli.data.y)
						ctrli.data.x = ctrli.data.x + deltaX
						ctrli.data.y = ctrli.data.y
					end
				end
				
				--存储本次的位置
				last_click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON] = touchX
				last_click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON] = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] then
					--if (touchX ~= click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON]) or (touchY ~= click_pos_y_redequip[hVar.ITEM_TYPE.WEAPON]) then --不是点击事件
						b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = true
						friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					--end
				end
				
				local equipType = hVar.ITEM_TYPE.WEAPON --武器
				local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--检测
				--检测点击到了哪个神器框内
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = i
						
						break
						--print("点击到了哪个神器的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_redequip[hVar.ITEM_TYPE.WEAPON]) and (math.abs(touchX - click_pos_x_redequip[hVar.ITEM_TYPE.WEAPON]) > 40) then
					selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0
				end
				--print("selected_redequip_idx[hVar.ITEM_TYPE.WEAPON]", selected_redequip_idx[hVar.ITEM_TYPE.WEAPON])
				
				--之前选中了某个神器
				if (selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] > 0) then
					--selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0
					--点击了神器按钮
					--点击神器按钮
					OnClickedEquipBtn(equipType, selected_redequip_idx[hVar.ITEM_TYPE.WEAPON])
				else
					--未点击到神器按钮
					--OnClickedEquipBtn(equipType, 0)
				end
				
				--标记不用滑动
				click_scroll_redequip[hVar.ITEM_TYPE.WEAPON] = false
			end,
		})
		_childUI["RedEquipDragPanel_Weapon"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipDragPanel_Weapon"
		
		--左侧用于检测滑动事件的控件(防具)
		_childUI["RedEquipDragPanel_Body"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2 + 5,
			y = _itemY - _itemOffY - 60,
			w = _itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] - 2 - 10,
			h = _itemOffY - 2+40,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				
				local equipType = hVar.ITEM_TYPE.BODY --防具
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					--current_inshow_itemtip = false
					
					return
				end
				
				click_pos_x_redequip[hVar.ITEM_TYPE.BODY] = touchX --开始按下的坐标x
				click_pos_y_redequip[hVar.ITEM_TYPE.BODY] = touchY --开始按下的坐标y
				last_click_pos_x_redequip[hVar.ITEM_TYPE.BODY] = touchX --上一次按下的坐标x
				last_click_pos_y_redequip[hVar.ITEM_TYPE.BODY] = touchY --上一次按下的坐标y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0 --当前速度为0
				selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0 --神器选中的索引
				click_scroll_redequip[hVar.ITEM_TYPE.BODY] = true --是否滑动神器
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = false --不需要自动修正位置
				friction_redequip[hVar.ITEM_TYPE.BODY] = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.BODY]=", click_scroll_redequip[hVar.ITEM_TYPE.BODY])
				
				--如果神器数量未铺满一页，那么不需要滑动
				--左面对其左顶线，右面在在右底线之左
				if (delta1_lx == 0) and (deltNa_rx <= 0) then
					click_scroll_redequip[hVar.ITEM_TYPE.BODY] = false --不需要滑动神器
				end
				
				--清除神器选中状态
				local equipType = hVar.ITEM_TYPE.BODY --防具
				--OnClickedEquipBtn(equipType, 0)
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.BODY]
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] > MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY]
				end
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] < -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.BODY]
				end
				
				local equipType = hVar.ITEM_TYPE.BODY --防具
				local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最左侧的x坐标
				local deltNa_rx = 0 --最后一个DLC地图面板最右侧的x坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.BODY]=", click_scroll_redequip[hVar.ITEM_TYPE.BODY])
				--在滑动过程中才会处理滑动
				if click_scroll_redequip[hVar.ITEM_TYPE.BODY] then
					local deltaX = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.BODY] --与开始按下的位置的偏移值x
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + deltaX) >= 0) then --防止走过
						deltaX = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
						
						_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(false) --左分翻页不显示
					else
						_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(true) --左分翻页显示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						_childUI["RedEquipPageRight_Body"].handle.s:setVisible(false) --右分翻页显示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						_childUI["RedEquipPageRight_Body"].handle.s:setVisible(true) --右分翻页不显示
					end
					
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x + deltaX, ctrli.data.y)
						ctrli.data.x = ctrli.data.x + deltaX
						ctrli.data.y = ctrli.data.y
					end
				end
				
				--存储本次的位置
				last_click_pos_x_redequip[hVar.ITEM_TYPE.BODY] = touchX
				last_click_pos_y_redequip[hVar.ITEM_TYPE.BODY] = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_redequip[hVar.ITEM_TYPE.BODY] then
					--if (touchX ~= click_pos_x_redequip[hVar.ITEM_TYPE.BODY]) or (touchY ~= click_pos_y_redequip[hVar.ITEM_TYPE.BODY]) then --不是点击事件
						b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = true
						friction_redequip[hVar.ITEM_TYPE.BODY] = 0
					--end
				end
				
				local equipType = hVar.ITEM_TYPE.BODY --防具
				local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--检测
				--检测点击到了哪个神器框内
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_redequip_idx[hVar.ITEM_TYPE.BODY] = i
						
						break
						--print("点击到了哪个神器的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_redequip[hVar.ITEM_TYPE.BODY]) and (math.abs(touchX - click_pos_x_redequip[hVar.ITEM_TYPE.BODY]) > 40) then
					selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0
				end
				--print("selected_redequip_idx[hVar.ITEM_TYPE.BODY]", selected_redequip_idx[hVar.ITEM_TYPE.BODY])
				
				--之前选中了某个神器
				if (selected_redequip_idx[hVar.ITEM_TYPE.BODY] > 0) then
					--selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0
					--点击了神器按钮
					--点击神器按钮
					OnClickedEquipBtn(equipType, selected_redequip_idx[hVar.ITEM_TYPE.BODY])
				else
					--未点击到神器按钮
					--OnClickedEquipBtn(equipType, 0)
				end
				
				--标记不用滑动
				click_scroll_redequip[hVar.ITEM_TYPE.BODY] = false
			end,
		})
		_childUI["RedEquipDragPanel_Body"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipDragPanel_Body"
		
		--左侧用于检测滑动事件的控件(宝物)
		_childUI["RedEquipDragPanel_Ornaments"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2,
			y = _itemY - _itemOffY * 2 - 200,
			w = _itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] - 2,
			h = _itemOffY - 2,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					--current_inshow_itemtip = false
					
					return
				end
				
				click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchX --开始按下的坐标x
				click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchY --开始按下的坐标y
				last_click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchX --上一次按下的坐标x
				last_click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchY --上一次按下的坐标y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --当前速度为0
				selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0 --神器选中的索引
				click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] = true --是否滑动神器
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false --不需要自动修正位置
				friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS]=", click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS])
				
				--如果神器数量未铺满一页，那么不需要滑动
				--左面对其左顶线，右面在在右底线之左
				if (delta1_lx == 0) and (deltNa_rx <= 0) then
					click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false --不需要滑动神器
				end
				
				--清除神器选中状态
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				--OnClickedEquipBtn(equipType, 0)
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] > MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS]
				end
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] < -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.ORNAMENTS]
				end
				
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最左侧的x坐标
				local deltNa_rx = 0 --最后一个DLC地图面板最右侧的x坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS]=", click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS])
				--在滑动过程中才会处理滑动
				if click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] then
					local deltaX = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] --与开始按下的位置的偏移值x
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + deltaX) >= 0) then --防止走过
						deltaX = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
						
						_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(false) --左分翻页不显示
					else
						_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(true) --左分翻页显示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(false) --右分翻页显示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(true) --右分翻页不显示
					end
					
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x + deltaX, ctrli.data.y)
						ctrli.data.x = ctrli.data.x + deltaX
						ctrli.data.y = ctrli.data.y
					end
				end
				
				--存储本次的位置
				last_click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchX
				last_click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS] = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] then
					--if (touchX ~= click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]) or (touchY ~= click_pos_y_redequip[hVar.ITEM_TYPE.ORNAMENTS]) then --不是点击事件
						b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = true
						friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					--end
				end
				
				local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--检测
				--检测点击到了哪个神器框内
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = i
						
						break
						--print("点击到了哪个神器的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS]) and (math.abs(touchX - click_pos_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]) > 40) then
					selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0
				end
				--print("selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS]", selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS])
				
				--之前选中了某个神器
				if (selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] > 0) then
					--selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0
					--点击了神器按钮
					--点击神器按钮
					OnClickedEquipBtn(equipType, selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS])
				else
					--未点击到神器按钮
					--OnClickedEquipBtn(equipType, 0)
				end
				
				--标记不用滑动
				click_scroll_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false
			end,
		})
		_childUI["RedEquipDragPanel_Ornaments"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipDragPanel_Ornaments"
		
		--左侧用于检测滑动事件的控件(坐骑)
		_childUI["RedEquipDragPanel_Mount"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2,
			y = _itemY - _itemOffY * 3,
			w = _itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] - 2,
			h = _itemOffY - 2,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				
				local equipType = hVar.ITEM_TYPE.MOUNT --宝物
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					--current_inshow_itemtip = false
					
					return
				end
				
				click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] = touchX --开始按下的坐标x
				click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT] = touchY --开始按下的坐标y
				last_click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] = touchX --上一次按下的坐标x
				last_click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT] = touchY --上一次按下的坐标y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --当前速度为0
				selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0 --神器选中的索引
				click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] = true --是否滑动神器
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = false --不需要自动修正位置
				friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.MOUNT]=", click_scroll_redequip[hVar.ITEM_TYPE.MOUNT])
				
				--如果神器数量未铺满一页，那么不需要滑动
				--左面对其左顶线，右面在在右底线之左
				if (delta1_lx == 0) and (deltNa_rx <= 0) then
					click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] = false --不需要滑动神器
				end
				
				--清除神器选中状态
				local equipType = hVar.ITEM_TYPE.MOUNT --宝物
				--OnClickedEquipBtn(equipType, 0)
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT]
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] > MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT]
				end
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] < -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT]) then
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = -MAX_SPEED_REDEQUIP[hVar.ITEM_TYPE.MOUNT]
				end
				
				local equipType = hVar.ITEM_TYPE.MOUNT --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最左侧的x坐标
				local deltNa_rx = 0 --最后一个DLC地图面板最右侧的x坐标
				delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_redequip[hVar.ITEM_TYPE.MOUNT]=", click_scroll_redequip[hVar.ITEM_TYPE.MOUNT])
				--在滑动过程中才会处理滑动
				if click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] then
					local deltaX = touchX - last_click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] --与开始按下的位置的偏移值x
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + deltaX) >= 0) then --防止走过
						deltaX = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
						
						_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(false) --左分翻页不显示
					else
						_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(true) --左分翻页显示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(false) --右分翻页显示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(true) --右分翻页不显示
					end
					
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x + deltaX, ctrli.data.y)
						ctrli.data.x = ctrli.data.x + deltaX
						ctrli.data.y = ctrli.data.y
					end
				end
				
				--存储本次的位置
				last_click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT] = touchX
				last_click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT] = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] then
					--if (touchX ~= click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT]) or (touchY ~= click_pos_y_redequip[hVar.ITEM_TYPE.MOUNT]) then --不是点击事件
						b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = true
						friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					--end
				end
				
				local equipType = hVar.ITEM_TYPE.MOUNT --宝物
				local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
				
				--正在查看tip状态中，不响应事件
				if current_inshow_itemtip then
					--清除tip
					--OnClickedEquipBtn(equipType, 0)
					
					--标记不是查看tip状态
					current_inshow_itemtip = false
					
					return
				end
				
				--检测
				--检测点击到了哪个神器框内
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = i
						
						break
						--print("点击到了哪个神器的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_redequip[hVar.ITEM_TYPE.MOUNT]) and (math.abs(touchX - click_pos_x_redequip[hVar.ITEM_TYPE.MOUNT]) > 40) then
					selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0
				end
				--print("selected_redequip_idx[hVar.ITEM_TYPE.MOUNT]", selected_redequip_idx[hVar.ITEM_TYPE.MOUNT])
				
				--之前选中了某个神器
				if (selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] > 0) then
					--selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0
					--点击了神器按钮
					--点击神器按钮
					OnClickedEquipBtn(equipType, selected_redequip_idx[hVar.ITEM_TYPE.MOUNT])
				else
					--未点击到神器按钮
					--OnClickedEquipBtn(equipType, 0)
				end
				
				--标记不用滑动
				click_scroll_redequip[hVar.ITEM_TYPE.MOUNT] = false
			end,
		})
		_childUI["RedEquipDragPanel_Mount"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList[#_RemoveList+1] = "RedEquipDragPanel_Mount"
		
		------------------------------------------------------------------------------
		--墙体1选中框
		_childUI["DLCMapInfo_SC1_Selectbox"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 70,
			y = _itemY - 170 - 1 - 50*5,
			scale = 0.5,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC1_Selectbox"
		
		--墙体1文字
		_childUI["DLCMapInf_SC1_Label"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 100,
			y = _itemY - 170 - 1 - 50*5 + 19,
			text = "高墙",
			width = 500,
			align = "LT",
			border = 1,
			size = 30,
			font = hVar.FONTC,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInf_SC1_Label"
		
		--墙体1选中的特效
		_childUI["DLCMapInfo_SC1_Selectbox_Finish"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			x = _itemX - 80 + 70,
			y = _itemY - 170 - 1 - 50*5,
			scale = 1.0,
			model = "UI:finish",
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC1_Selectbox_Finish"
		_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false) --默认隐藏选中框
		
		--墙体1事件按钮
		_childUI["DLCMapInfo_SC1_Btn"] = hUI.button:new({
			parent = _BTC_pClipNode_RedEquip,
			dragbox = _frm.childUI["dragBox"],
			model = -1,
			--model = "misc/mask.png",
			x = _itemX - 80 + 110,
			y = _itemY - 170 - 1 - 50*5,
			w = 180,
			h = 50,
			code = function(self)
				if (_cur_wall_type ~= 1) then
					--显示选中框1
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(true)
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.8,0.8),CCScaleTo:create(0.05,1.0,1.0)))
					
					--隐藏其他选中框
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记选择墙面1
					_cur_wall_type = 1
					
					--领取按钮高亮
					local btnOk = get_btn_state()
					if btnOk then
						hApi.AddShader(_childUI["confirmBtn"].handle.s, "normal")
					end
				else
					--隐藏全部选中框
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记未选择墙面
					_cur_wall_type = 0
					
					--灰调按钮
					hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
				end
			end,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC1_Btn"
		
		------------------------------------------------------------------------------
		--墙体2选中框
		_childUI["DLCMapInfo_SC2_Selectbox"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 70 + 200*1,
			y = _itemY - 170 - 1 - 50*5,
			scale = 0.5,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC2_Selectbox"
		
		--墙体2文字
		_childUI["DLCMapInf_SC2_Label"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 100 + 200*1,
			y = _itemY - 170 - 1 - 50*5 + 19,
			text = "低墙",
			width = 500,
			align = "LT",
			border = 1,
			size = 30,
			font = hVar.FONTC,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInf_SC2_Label"
		
		--墙体2选中的特效
		_childUI["DLCMapInfo_SC2_Selectbox_Finish"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			x = _itemX - 80 + 70 + 200*1,
			y = _itemY - 170 - 1 - 50*5,
			scale = 1.0,
			model = "UI:finish",
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC2_Selectbox_Finish"
		_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false) --默认隐藏选中框
		
		--墙体2事件按钮
		_childUI["DLCMapInfo_SC2_Btn"] = hUI.button:new({
			parent = _BTC_pClipNode_RedEquip,
			dragbox = _frm.childUI["dragBox"],
			model = -1,
			--model = "misc/mask.png",
			x = _itemX - 80 + 110 + 200*1,
			y = _itemY - 170 - 1 - 50*5,
			w = 180,
			h = 50,
			code = function(self)
				if (_cur_wall_type ~= 2) then
					--显示选中框2
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(true)
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.8,0.8),CCScaleTo:create(0.05,1.0,1.0)))
					
					--隐藏其他选中框
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记选择墙面2
					_cur_wall_type = 2
					
					--领取按钮高亮
					local btnOk = get_btn_state()
					if btnOk then
						hApi.AddShader(_childUI["confirmBtn"].handle.s, "normal")
					end
				else
					--隐藏全部选中框
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记未选择墙面
					_cur_wall_type = 0
					
					--灰调按钮
					hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
				end
			end,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC2_Btn"
		
		------------------------------------------------------------------------------
		--墙体3选中框
		_childUI["DLCMapInfo_SC3_Selectbox"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 70 + 200*2,
			y = _itemY - 170 - 1 - 50*5,
			scale = 0.5,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC3_Selectbox"
		
		--墙体3文字
		_childUI["DLCMapInf_SC3_Label"] = hUI.label:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "UI:Button_SelectBorder",
			x = _itemX - 80 + 100 + 200*2,
			y = _itemY - 170 - 1 - 50*5 + 19,
			text = "无墙",
			width = 500,
			align = "LT",
			border = 1,
			size = 30,
			font = hVar.FONTC,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInf_SC3_Label"
		
		--墙体3选中的特效
		_childUI["DLCMapInfo_SC3_Selectbox_Finish"] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			x = _itemX - 80 + 70 + 200*2,
			y = _itemY - 170 - 1 - 50*5,
			scale = 1.0,
			model = "UI:finish",
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC3_Selectbox_Finish"
		_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false) --默认隐藏选中框
		
		--墙体3事件按钮
		_childUI["DLCMapInfo_SC3_Btn"] = hUI.button:new({
			parent = _BTC_pClipNode_RedEquip,
			dragbox = _frm.childUI["dragBox"],
			model = -1,
			--model = "misc/mask.png",
			x = _itemX - 80 + 110 + 200*2,
			y = _itemY - 170 - 1 - 50*5,
			w = 180,
			h = 50,
			code = function(self)
				if (_cur_wall_type ~= 3) then
					--显示选中框3
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(true)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.8,0.8),CCScaleTo:create(0.05,1.0,1.0)))
					
					--隐藏其他选中框
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记选择墙面3
					_cur_wall_type = 3
					
					--领取按钮高亮
					local btnOk = get_btn_state()
					if btnOk then
						hApi.AddShader(_childUI["confirmBtn"].handle.s, "normal")
					end
				else
					--隐藏全部选中框
					_childUI["DLCMapInfo_SC1_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC2_Selectbox_Finish"].handle._n:setVisible(false)
					_childUI["DLCMapInfo_SC3_Selectbox_Finish"].handle._n:setVisible(false)
					
					--标记未选择墙面
					_cur_wall_type = 0
					
					--灰调按钮
					hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
				end
			end,
		})
		_RemoveList[#_RemoveList+1] = "DLCMapInfo_SC3_Btn"
		
		-------
		--左侧用于检测滑动事件的控件(整个面板)
		_childUI["RedEquipDragPanel_AllPanel"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = _itemX + (_itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON]) / 2 - _itemOffX / 2 + 5,
			y = -_h/2 + 5,
			w = _itemOffX * PAGE_X_NUM[hVar.ITEM_TYPE.WEAPON] - 2 - 10,
			h = _h - 170,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_dlcmapinfo = touchX --开始按下的坐标x
				click_pos_y_dlcmapinfo = touchY --开始按下的坐标y
				last_click_pos_y_dlcmapinfo = touchX --上一次按下的坐标x
				last_click_pos_y_dlcmapinfo = touchY --上一次按下的坐标y
				draggle_speed_y_dlcmapinfo = 0 --当前速度为0
				selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
				click_scroll_dlcmapinfo = true --是否滑动DLC地图面板
				b_need_auto_fixing_dlcmapinfo = false --不需要自动修正位置
				friction_dlcmapinfo = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				
				--不满一页
				--上面对其上顶线，下面在在下底线之上
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				end
				
				--事件穿透
				local ctrli = _childUI["RedEquipDragPanel_Weapon"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.codeOnTouch(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				local ctrli = _childUI["RedEquipDragPanel_Body"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.codeOnTouch(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
				
				--处理移动速度y
				draggle_speed_y_dlcmapinfo = touchY - last_click_pos_y_dlcmapinfo
				
				if (draggle_speed_y_dlcmapinfo > MAX_SPEED) then
					draggle_speed_y_dlcmapinfo = MAX_SPEED
				end
				if (draggle_speed_y_dlcmapinfo < -MAX_SPEED) then
					draggle_speed_y_dlcmapinfo = -MAX_SPEED
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				--第一个DLC地图面板的坐标不能跑到最上侧的下边去
				if ((delta1_ly + deltaY) <= 0) then --防止走过
					deltaY = -delta1_ly
					delta1_ly = 0
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					_childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					end
				end
				
				--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
				if ((deltNa_ry + deltaY) >= 0) then --防止走过
					deltaY = -deltNa_ry
					deltNa_ry = 0
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
					--current_in_scroll_down = true
					_childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提
					end
				end
				
				--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
					local current_DLCMap_max_num = #_RemoveList
					for i = 1, current_DLCMap_max_num, 1 do
						local DLCMapInfoNode_i = _RemoveList[i]
						local ctrli = _childUI[DLCMapInfoNode_i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
				
				--事件穿透
				local ctrli = _childUI["RedEquipDragPanel_Weapon"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.codeOnDrag(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				local ctrli = _childUI["RedEquipDragPanel_Body"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.codeOnDrag(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
					--end
				end
				
				--是否选中某个DLC地图面板查看区域内查看tip
				local selectTipIdx = 0
				--[[
				local current_DLCMap_max_num = #_RemoveList
				for i = 1, current_DLCMap_max_num, 1 do
					local DLCMapInfoNode_i = _RemoveList[i]
					local ctrli = _childUI[DLCMapInfoNode_i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, ly, ry, touchX, touchY)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selectTipIdx = i
						
						break
						--print("点击到了哪个DLC地图面板tip的框内" .. i)
					end
				end
				]]
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 48) then
					selectTipIdx = 0
				end
				
				if (selectTipIdx > 0) then
					--显示tip
					--print(selectTipIdx)
					--OnCreateGameCoinChangeInfoFrame_RightPart(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
				
				--事件穿透
				local ctrli = _childUI["RedEquipDragPanel_Weapon"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.code(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				local ctrli = _childUI["RedEquipDragPanel_Body"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.code(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				--选择墙体1
				local ctrli = _childUI["DLCMapInfo_SC1_Btn"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.code(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				--选择墙体2
				local ctrli = _childUI["DLCMapInfo_SC2_Btn"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.code(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
				
				--选择墙体3
				local ctrli = _childUI["DLCMapInfo_SC3_Btn"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				local cw, ch = ctrli.data.w, ctrli.data.h
				local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
				local rx, ry = lx + cw, ly + ch --最右下角坐标
				--print(i, lx, rx, ly, ry, touchX, touchY)
				if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
					ctrli.data.code(self, touchX, touchY, sus)
					--print("点击到了哪个DLC地图面板tip的框内" .. i)
				end
			end,
		})
		_childUI["RedEquipDragPanel_AllPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		_RemoveList_Stable[#_RemoveList_Stable+1] = "RedEquipDragPanel_AllPanel"
		
		--向右翻页按钮默认是否显示
		local equipType = hVar.ITEM_TYPE.WEAPON --武器
		local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
		--超过一页的数量才滑屏
		if (equiptypenum > PAGE_X_NUM[equipType]) then
			_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(true)
		end
		local equipType = hVar.ITEM_TYPE.BODY --防具
		local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
		--超过一页的数量才滑屏
		if (equiptypenum > PAGE_X_NUM[equipType]) then
			_childUI["RedEquipPageRight_Body"].handle.s:setVisible(true)
		end
		local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
		local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
		--超过一页的数量才滑屏
		if (equiptypenum > PAGE_X_NUM[equipType]) then
			_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(true)
		end
		local equipType = hVar.ITEM_TYPE.MOUNT --坐骑
		local equiptypenum = current_equiptypenum[equipType] --坐骑分类的总数量
		--超过一页的数量才滑屏
		if (equiptypenum > PAGE_X_NUM[equipType]) then
			_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(true)
		end
		
		--创建领取按钮
		_childUI["confirmBtn"] =  hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_back.png",
			label = {text = "生成", font = hVar.FONTC, size = 30, border = 1, x = 0, y = 2,}, --"确定"
			x = _frm.data.w/2,
			y = -_frm.data.h + 50,
			--scale = 1.08,
			w = 160,
			h = 54,
			scaleT = 0.95,
			code = function()
				--没选中卡牌不处理
				if (_cur_index[hVar.ITEM_TYPE.WEAPON] == 0) or (_cur_index[hVar.ITEM_TYPE.BODY] == 0) then
					--[[
					--冒字
					local strText = hVar.tab_string["ios_tip_prize_reward_redequip"] --"请选择要领取的神器"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
					]]
					
					return
				end
				
				--是否联网
				if (g_cur_net_state == -1) then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_UseDepletion13_Net"],{ --"领取神器需要联网"
						font = hVar.FONTC,
						ok = function()
						end,
					})
					
					return
				end
				
				local btnOk = get_btn_state()
				if btnOk then
					--隐藏本界面
					_frm:show(0)
					_exitFunc()
					
					--回调函数
					if (type(current_funCallbackOK) == "function") then
						current_funCallbackOK(_cur_index[hVar.ITEM_TYPE.WEAPON], _cur_index[hVar.ITEM_TYPE.BODY], _cur_wall_type)
					end
				end
			end,
		})
		_RemoveList_Stable[#_RemoveList_Stable+1] = "confirmBtn"
		hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
	end
	
	--函数：获得神器第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
	getLeftRightOffset_RedEquip = function(equipType)
		local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _childUI["RedEquip_" .. equipType .. "_" .. "1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_lx = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_lx = 0 --第一个DLC地图面板距离上侧边界的距离
		--print(DLCMapInfoBtn1)
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_lx = btn1_cx + _itemOffX / 2 --第一个DLC地图面板最左侧的x坐标
			delta1_lx = btn1_lx - 210 - 40 --第一个DLC地图面板距离左侧边界的距离
			
			if (equipType == hVar.ITEM_TYPE.WEAPON) then --武器
				delta1_lx = btn1_lx - 210 - 40
			elseif (equipType == hVar.ITEM_TYPE.BODY) then --防具
				delta1_lx = btn1_lx - 210 - 60
			elseif (equipType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
				--
			elseif (equipType == hVar.ITEM_TYPE.MOUNT) then --马
				--
			end
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _childUI["RedEquip_" .. equipType .. "_" .. equiptypenum]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_rx = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_rx = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_rx = btnN_cx - _itemOffX / 2 --最后一个DLC地图面板最右侧的x坐标
			deltNa_rx = btnN_rx - 810 + 260 --最后一个DLC地图面板距离右侧边界的距离
			
			if (equipType == hVar.ITEM_TYPE.WEAPON) then --武器
				deltNa_rx = btnN_rx - 810 + 250
			elseif (equipType == hVar.ITEM_TYPE.BODY) then --防具
				deltNa_rx = btnN_rx - 810 + 272
			elseif (equipType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
				--
			elseif (equipType == hVar.ITEM_TYPE.MOUNT) then --马
				--
			end
		end
		
		--print("delta1_lx, deltNa_rx", delta1_lx, deltNa_rx)
		
		return delta1_lx, deltNa_rx
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _childUI["title"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_ly = btn1_cy --第一个DLC地图面板最上侧的x坐标
			delta1_ly = btn1_ly + 102
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _childUI["title"]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry - 210 - 32 --最后一个DLC地图面板距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：点击神器按钮
	OnClickedEquipBtn = function(equipType, selectedIdx)
		--print("OnClickedEquipBtn", equipType, selectedIdx)
		
		--存储
		selected_redequip_idx[equipType] = selectedIdx
		
		--_childUI["RedEquip_" .. equipType .. "_" .. i].data.itemId = tempID --标记道具id
		--			_childUI["RedEquip_" .. equipType .. "_" .. i].data.selectstate = 0 --标记不是选中状态
		
		--取消其他神器的选中状态
		--[[
		--取消武器
		local eqType = hVar.ITEM_TYPE.WEAPON --武器
		local equiptypenum = current_equiptypenum[eqType] --武器分类的总数量
		for i = 1, equiptypenum, 1 do
			if (eqType ~= equipType) or (i ~= selectedIdx) then
				local ctrli = _childUI["RedEquip_" .. eqType .. "_" .. i]
				ctrli.childUI["selectbox"]:setstate(-1) --不显示
				
				ctrli.data.selectstate = 0 --标记不是选中状态
			end
		end
		
		--取消防具
		local eqType = hVar.ITEM_TYPE.BODY --防具
		local equiptypenum = current_equiptypenum[eqType] --防具分类的总数量
		for i = 1, equiptypenum, 1 do
			if (eqType ~= equipType) or (i ~= selectedIdx) then
				local ctrli = _childUI["RedEquip_" .. eqType .. "_" .. i]
				ctrli.childUI["selectbox"]:setstate(-1) --不显示
				
				ctrli.data.selectstate = 0 --标记不是选中状态
			end
		end
		
		--取消宝物
		local eqType = hVar.ITEM_TYPE.ORNAMENTS --宝物
		local equiptypenum = current_equiptypenum[eqType] --宝物分类的总数量
		for i = 1, equiptypenum, 1 do
			if (eqType ~= equipType) or (i ~= selectedIdx) then
				local ctrli = _childUI["RedEquip_" .. eqType .. "_" .. i]
				ctrli.childUI["selectbox"]:setstate(-1) --不显示
				
				ctrli.data.selectstate = 0 --标记不是选中状态
			end
		end
		
		--取消坐骑
		local eqType = hVar.ITEM_TYPE.MOUNT --坐骑
		local equiptypenum = current_equiptypenum[eqType] --坐骑分类的总数量
		for i = 1, equiptypenum, 1 do
			if (eqType ~= equipType) or (i ~= selectedIdx) then
				local ctrli = _childUI["RedEquip_" .. eqType .. "_" .. i]
				ctrli.childUI["selectbox"]:setstate(-1) --不显示
				
				ctrli.data.selectstate = 0 --标记不是选中状态
			end
		end
		]]
		local eqType = equipType --坐骑
		local equiptypenum = current_equiptypenum[eqType] --坐骑分类的总数量
		for i = 1, equiptypenum, 1 do
			if (eqType ~= equipType) or (i ~= selectedIdx) then
				local ctrli = _childUI["RedEquip_" .. eqType .. "_" .. i]
				ctrli.childUI["selectbox"]:setstate(-1) --不显示
				
				ctrli.data.selectstate = 0 --标记不是选中状态
			end
		end
		
		--取消选中状态
		--_childUI["giftSelectBox"].handle._n:setPosition(self.data.x,self.data.y)
		--_childUI["giftSelectBox"]:setstate(-1)
		
		--点击了神器按钮
		if (selectedIdx > 0) then
			--显示选中框
			local crtlI = _childUI["RedEquip_" .. equipType .. "_" .. selectedIdx]
			
			if (crtlI.data.selectstate == 1) then
				crtlI.childUI["selectbox"]:setstate(-1) --不显示
				
				crtlI.data.selectstate = 0 --标记不是选中状态
				
				--未选中道具
				_cur_index[equipType] = 0
				
				--领取按钮灰色
				hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
			else
				crtlI.childUI["selectbox"]:setstate(1) --显示
				
				crtlI.data.selectstate = 1 --标记是选中状态
				
				--选中道具
				local itemId = crtlI.data.itemId
				for i = 1, #_tRedBagListOrigin[equipType], 1 do
					if (_tRedBagListOrigin[equipType][i] == itemId) then --找到了
						_cur_index[equipType] = i
						break
					end
				end
				
				--领取按钮高亮
				local btnOk = get_btn_state()
				if btnOk then
					hApi.AddShader(_childUI["confirmBtn"].handle.s, "normal")
				end
			end
			
			--_childUI["giftSelectBox"]:setstate(1)
			--_childUI["giftSelectBox"].handle._n:setPosition(crtlI.data.x,crtlI.data.y)
			
			--显示神器tip
			
			--local itemId = crtlI.data.itemId
			--OnCreateRedEquipTip(equipType, itemId)
		else
			--清空全部右侧控件
			--_removeRightFrmFunc()
			--未选中道具
			_cur_index[equipType] = 0
			
			--领取按钮灰色
			hApi.AddShader(_childUI["confirmBtn"].handle.s, "gray")
		end
	end
	
	--函数：获得按钮的状态
	get_btn_state = function()
		if (_cur_index[hVar.ITEM_TYPE.WEAPON] > 0) and (_cur_index[hVar.ITEM_TYPE.BODY] > 0) and (_cur_wall_type > 0) then
			return true
		else
			return false
		end
	end
	
	--函数：刷新神器界面的滚动(武器)
	refresh_redequip_UI_scroll_loop_weapon = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		
		local SPEED = 50 --速度
		
		local equipType = hVar.ITEM_TYPE.WEAPON --武器
		local equiptypenum = current_equiptypenum[equipType] --武器分类的总数量
		
		--print(b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON])
		
		if b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] then
			--检测是否滑动到了最左部或最右部
			local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_rx = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
			--print(delta1_lx, deltNa_rx)
			--delta1_lx +:在左底线之右 /-:在左底线之左
			--deltNa_rx +:在右底线之右 /-:在右底线之左
			
			--print("delta1_lx=" .. delta1_lx, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个DLC地图面板的头像跑到右边，那么优先将第一个DLC地图面板头像贴边
			if (delta1_lx > 0) then
				--print("优先将第一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
				
				local speed = -SPEED
				if ((delta1_lx + speed) < 0) then --防止走过
					speed = -delta1_lx
					delta1_lx = 0
				end
				
				--每个按钮向左侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(false) --上翻页提示
				_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_lx ~= 0) and (deltNa_rx < 0) then --第一个头像没有贴左侧，并且最后一个头像没有贴右侧，那么再将最后一个DLC地图面板头像贴边
				--print("将最后一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
				
				local speed = SPEED
				if ((deltNa_rx + speed) > 0) then --防止走过
					speed = -deltNa_rx
					deltNa_rx = 0
				end
				
				--每个按钮向右侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(true) --上分翻页提示
				_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON])
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.WEAPON] = 0 --选中的神器索引
				--print("    ->   draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON]=", draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON])
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] > 0) then --朝右运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.WEAPON] = friction_redequip[hVar.ITEM_TYPE.WEAPON] - 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] + friction_redequip[hVar.ITEM_TYPE.WEAPON] --衰减（正）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] < 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					end
					
					--第一个神器面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + speed) > 0) then --防止走过
						speed = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					end
					
					--每个按钮向右侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] < 0) then --朝左运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.WEAPON] = friction_redequip[hVar.ITEM_TYPE.WEAPON] + 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] + friction_redequip[hVar.ITEM_TYPE.WEAPON] --衰减（负）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] > 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
					end
					
					--最后一个神器面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + speed) < 0) then --防止走过
						speed = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.WEAPON] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向左侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_lx == 0) then
					_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(false) --上分翻页提示
				else
					_childUI["RedEquipPageLeft_Weapon"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(false) --下分翻页提示
				else
					_childUI["RedEquipPageRight_Weapon"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.WEAPON] = false
				friction_redequip[hVar.ITEM_TYPE.WEAPON] = 0
			end
		end
	end
	
	--函数：刷新神器界面的滚动(防具)
	refresh_redequip_UI_scroll_loop_body = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		
		local SPEED = 50 --速度
		
		local equipType = hVar.ITEM_TYPE.BODY --防具
		local equiptypenum = current_equiptypenum[equipType] --防具分类的总数量
		
		--print(b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY])
		
		if b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] then
			--检测是否滑动到了最左部或最右部
			local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_rx = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
			--print(delta1_lx, deltNa_rx)
			--delta1_lx +:在左底线之右 /-:在左底线之左
			--deltNa_rx +:在右底线之右 /-:在右底线之左
			
			--print("delta1_lx=" .. delta1_lx, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个DLC地图面板的头像跑到右边，那么优先将第一个DLC地图面板头像贴边
			if (delta1_lx > 0) then
				--print("优先将第一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
				
				local speed = -SPEED
				if ((delta1_lx + speed) < 0) then --防止走过
					speed = -delta1_lx
					delta1_lx = 0
				end
				
				--每个按钮向左侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(false) --上翻页提示
				_childUI["RedEquipPageRight_Body"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_lx ~= 0) and (deltNa_rx < 0) then --第一个头像没有贴左侧，并且最后一个头像没有贴右侧，那么再将最后一个DLC地图面板头像贴边
				--print("将最后一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
				
				local speed = SPEED
				if ((deltNa_rx + speed) > 0) then --防止走过
					speed = -deltNa_rx
					deltNa_rx = 0
				end
				
				--每个按钮向右侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(true) --上分翻页提示
				_childUI["RedEquipPageRight_Body"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY])
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.BODY] = 0 --选中的神器索引
				--print("    ->   draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY]=", draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY])
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] > 0) then --朝右运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.BODY] = friction_redequip[hVar.ITEM_TYPE.BODY] - 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] + friction_redequip[hVar.ITEM_TYPE.BODY] --衰减（正）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] < 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
					end
					
					--第一个神器面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + speed) > 0) then --防止走过
						speed = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
					end
					
					--每个按钮向右侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] < 0) then --朝左运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.BODY] = friction_redequip[hVar.ITEM_TYPE.BODY] + 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] + friction_redequip[hVar.ITEM_TYPE.BODY] --衰减（负）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] > 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
					end
					
					--最后一个神器面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + speed) < 0) then --防止走过
						speed = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.BODY] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向左侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_lx == 0) then
					_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(false) --上分翻页提示
				else
					_childUI["RedEquipPageLeft_Body"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					_childUI["RedEquipPageRight_Body"].handle.s:setVisible(false) --下分翻页提示
				else
					_childUI["RedEquipPageRight_Body"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.BODY] = false
				friction_redequip[hVar.ITEM_TYPE.BODY] = 0
			end
		end
	end
	
	--函数：刷新神器界面的滚动(宝物)
	refresh_redequip_UI_scroll_loop_ornaments = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		
		local SPEED = 50 --速度
		
		local equipType = hVar.ITEM_TYPE.ORNAMENTS --宝物
		local equiptypenum = current_equiptypenum[equipType] --宝物分类的总数量
		
		--print(b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS])
		
		if b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] then
			--检测是否滑动到了最左部或最右部
			local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_rx = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
			--print(delta1_lx, deltNa_rx)
			--delta1_lx +:在左底线之右 /-:在左底线之左
			--deltNa_rx +:在右底线之右 /-:在右底线之左
			
			--print("delta1_lx=" .. delta1_lx, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个DLC地图面板的头像跑到右边，那么优先将第一个DLC地图面板头像贴边
			if (delta1_lx > 0) then
				--print("优先将第一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
				
				local speed = -SPEED
				if ((delta1_lx + speed) < 0) then --防止走过
					speed = -delta1_lx
					delta1_lx = 0
				end
				
				--每个按钮向左侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(false) --上翻页提示
				_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_lx ~= 0) and (deltNa_rx < 0) then --第一个头像没有贴左侧，并且最后一个头像没有贴右侧，那么再将最后一个DLC地图面板头像贴边
				--print("将最后一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
				
				local speed = SPEED
				if ((deltNa_rx + speed) > 0) then --防止走过
					speed = -deltNa_rx
					deltNa_rx = 0
				end
				
				--每个按钮向右侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(true) --上分翻页提示
				_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS])
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.ORNAMENTS] = 0 --选中的神器索引
				--print("    ->   draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]=", draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS])
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] > 0) then --朝右运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] - 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] + friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] --衰减（正）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] < 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					end
					
					--第一个神器面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + speed) > 0) then --防止走过
						speed = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					end
					
					--每个按钮向右侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] < 0) then --朝左运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] + 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] + friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] --衰减（负）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] > 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
					end
					
					--最后一个神器面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + speed) < 0) then --防止走过
						speed = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向左侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_lx == 0) then
					_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(false) --上分翻页提示
				else
					_childUI["RedEquipPageLeft_Ornaments"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(false) --下分翻页提示
				else
					_childUI["RedEquipPageRight_Ornaments"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.ORNAMENTS] = false
				friction_redequip[hVar.ITEM_TYPE.ORNAMENTS] = 0
			end
		end
	end
	
	--函数：刷新神器界面的滚动(坐骑)
	refresh_redequip_UI_scroll_loop_mount = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		
		local SPEED = 50 --速度
		
		local equipType = hVar.ITEM_TYPE.MOUNT --坐骑
		local equiptypenum = current_equiptypenum[equipType] --坐骑分类的总数量
		
		--print(b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT])
		
		if b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] then
			--检测是否滑动到了最左部或最右部
			local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_rx = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_lx, deltNa_rx = getLeftRightOffset_RedEquip(equipType)
			--print(delta1_lx, deltNa_rx)
			--delta1_lx +:在左底线之右 /-:在左底线之左
			--deltNa_rx +:在右底线之右 /-:在右底线之左
			
			--print("delta1_lx=" .. delta1_lx, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个DLC地图面板的头像跑到右边，那么优先将第一个DLC地图面板头像贴边
			if (delta1_lx > 0) then
				--print("优先将第一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
				
				local speed = -SPEED
				if ((delta1_lx + speed) < 0) then --防止走过
					speed = -delta1_lx
					delta1_lx = 0
				end
				
				--每个按钮向左侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(false) --上翻页提示
				_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_lx ~= 0) and (deltNa_rx < 0) then --第一个头像没有贴左侧，并且最后一个头像没有贴右侧，那么再将最后一个DLC地图面板头像贴边
				--print("将最后一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
				
				local speed = SPEED
				if ((deltNa_rx + speed) > 0) then --防止走过
					speed = -deltNa_rx
					deltNa_rx = 0
				end
				
				--每个按钮向右侧做运动
				for i = 1, equiptypenum, 1 do
					local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(true) --上分翻页提示
				_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT])
				--不会选中神器
				selected_redequip_idx[hVar.ITEM_TYPE.MOUNT] = 0 --选中的神器索引
				--print("    ->   draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT]=", draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT])
				
				if (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] > 0) then --朝右运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.MOUNT] = friction_redequip[hVar.ITEM_TYPE.MOUNT] - 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] + friction_redequip[hVar.ITEM_TYPE.MOUNT] --衰减（正）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] < 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					end
					
					--第一个神器面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + speed) > 0) then --防止走过
						speed = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					end
					
					--每个按钮向右侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				elseif (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] < 0) then --朝左运动
					local speed = (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT]) * 1.0 --系数
					friction_redequip[hVar.ITEM_TYPE.MOUNT] = friction_redequip[hVar.ITEM_TYPE.MOUNT] + 0.5
					draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] + friction_redequip[hVar.ITEM_TYPE.MOUNT] --衰减（负）
					
					if (draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] > 0) then
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
					end
					
					--最后一个神器面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + speed) < 0) then --防止走过
						speed = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_redequip[hVar.ITEM_TYPE.MOUNT] = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向左侧做运动
					for i = 1, equiptypenum, 1 do
						local ctrli = _childUI["RedEquip_" .. equipType .. "_" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_lx == 0) then
					_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(false) --上分翻页提示
				else
					_childUI["RedEquipPageLeft_Mount"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(false) --下分翻页提示
				else
					_childUI["RedEquipPageRight_Mount"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_redequip[hVar.ITEM_TYPE.MOUNT] = false
				friction_redequip[hVar.ITEM_TYPE.MOUNT] = 0
			end
		end
	end
	
	--函数：刷新DLC地图面板界面的滚动
	refresh_dlcmapinfo_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_dlcmapinfo then
			---第一个DLC地图面板的数据
			local DLCMapInfoBtn1 = _childUI["title"]
			if DLCMapInfoBtn1 then
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--print("delta1_ly=" .. delta1_ly, ", deltNa_ry=" .. deltNa_ry)
				
				--如果第一个DLC地图面板的头像跑到下边，那么优先将第一个DLC地图面板头像贴边
				if (delta1_ly < 0) then
					--print("优先将第一个DLC地图面板头像贴边")
					--需要修正
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					local speed = SPEED
					if ((delta1_ly + speed) > 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
					end
					
					--每个按钮向上侧做运动
					local current_DLCMap_max_num = #_RemoveList
					for i = 1, current_DLCMap_max_num, 1 do
						local DLCMapInfoNode_i = _RemoveList[i]
						local ctrli = _childUI[DLCMapInfoNode_i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
					
					--上滑动翻页不显示，下滑动翻页显示
					_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
				elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个DLC地图面板头像贴边
					--print("将最后一个DLC地图面板头像贴边")
					--需要修正
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					local speed = SPEED
					if ((deltNa_ry - speed) < 0) then --防止走过
						speed = deltNa_ry
						deltNa_ry = 0
					end
					
					--每个按钮向下侧做运动
					local current_DLCMap_max_num = #_RemoveList
					for i = 1, current_DLCMap_max_num, 1 do
						local DLCMapInfoNode_i = _RemoveList[i]
						local ctrli = _childUI[DLCMapInfoNode_i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y - speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
					
					--上滑动翻页显示，下滑动翻页不显示
					_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
				elseif (draggle_speed_y_dlcmapinfo ~= 0) then --沿着当前的速度方向有惯性地运动一会
					--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_dlcmapinfo)
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					--print("    ->   draggle_speed_y_dlcmapinfo=", draggle_speed_y_dlcmapinfo)
					
					if (draggle_speed_y_dlcmapinfo > 0) then --朝上运动
						local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
						friction_dlcmapinfo = friction_dlcmapinfo - 0.5
						draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（正）
						
						if (draggle_speed_y_dlcmapinfo < 0) then
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
						if ((deltNa_ry + speed) > 0) then --防止走过
							speed = -deltNa_ry
							deltNa_ry = 0
							
							--没有惯性
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--每个按钮向上侧做运动
						local current_DLCMap_max_num = #_RemoveList
						for i = 1, current_DLCMap_max_num, 1 do
							local DLCMapInfoNode_i = _RemoveList[i]
							local ctrli = _childUI[DLCMapInfoNode_i]
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
						end
					elseif (draggle_speed_y_dlcmapinfo < 0) then --朝下运动
						local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
						friction_dlcmapinfo = friction_dlcmapinfo + 0.5
						draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（负）
						
						if (draggle_speed_y_dlcmapinfo > 0) then
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--第一个DLC地图面板的坐标不能跑到最上侧的下边去
						if ((delta1_ly + speed) < 0) then --防止走过
							speed = -delta1_ly
							delta1_ly = 0
							
							--没有惯性
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--每个按钮向下侧做运动
						local current_DLCMap_max_num = #_RemoveList
						for i = 1, current_DLCMap_max_num, 1 do
							local DLCMapInfoNode_i = _RemoveList[i]
							local ctrli = _childUI[DLCMapInfoNode_i]
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
						end
					end
					
					--上滑动翻页显示，下滑动翻页显示
					if (delta1_ly == 0) then
						_childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					else
						_childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					end
					if (deltNa_ry == 0) then
						_childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
					else
						_childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
					end
				else --停止运动
					b_need_auto_fixing_dlcmapinfo = false
					friction_dlcmapinfo = 0
				end
			end
		end
	end
	
	--监听收到红装卷轴可兑换的所有红装信息
	hGlobal.event:listen("LocalEvent_Phone_ShowGMResourceFrm", "GMResourceFrm", function(callbackOK, callbackCancel)
		--显示本界面
		_frm:show(1)
		_frm:active()
		
		--存储奖励类型
		current_funCallbackOK = callbackOK
		current_funCallbackCancel = callbackCancel
		
		--添加事件监听：收到系统时间回调
		hGlobal.event:listen("localEvent_refresh_Systime", "showsystime", on_receive_systime_gmresource)
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起查询服务器系统时间
		SendCmdFunc["refresh_systime"]()
		
		--[[
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		]]
	end)
end

--[[
--测试 --test
--删除上一次的GM领取资源界面
if hGlobal.UI.PlayerGMResourceFrm then
	hGlobal.UI.PlayerGMResourceFrm:del()
	hGlobal.UI.PlayerGMResourceFrm = nil
end
hGlobal.UI.InitPlayerGMResourceFrm("include") --创建GM领取资源界面
--触发事件
local callbackOK = function(backgroundId, avaterId, wallId)
	print(backgroundId, avaterId, wallId)
	
	--开始生成用户自定义地图的配置
	local regionPoint = 1001
	local tConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[regionPoint]
	
	--拷贝宇宙层
	local tUniverseConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[1]
	tConfig.farobj = --地球远景层
	{
		img = {tUniverseConfig.farobj.img[backgroundId],},
		num = 1,
		scale = 1.0,
	}
	tConfig.middleobj = tUniverseConfig.middleobj
	tConfig.nearobj = tUniverseConfig.nearobj
	print(tConfig.farobj.img[1])
	--拷贝背景图
	local tBackgroundConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[avaterId]
	tConfig.wallimg = tBackgroundConfig.wallimg
	tConfig.renders = tBackgroundConfig.renders
	
	--拷贝墙面
	local wallCfgId = 0
	if (wallId == 1) then --高墙
		wallCfgId = 1
	elseif (wallId == 2) then --矮墙
		wallCfgId = 3
	elseif (wallId == 3) then --无墙
		wallCfgId = 4
	end
	local tWallConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[wallCfgId]
	tConfig.ground = tWallConfig.ground --地板
	tConfig.wall_l = tWallConfig.wall_l
	tConfig.wall_r = tWallConfig.wall_r
	tConfig.wall_t = tWallConfig.wall_t
	tConfig.wall_b = tWallConfig.wall_b
	tConfig.corner_lt = tWallConfig.corner_lt
	tConfig.corner_rt = tWallConfig.corner_rt
	tConfig.corner_lb = tWallConfig.corner_lb
	tConfig.corner_rb = tWallConfig.corner_rb
	tConfig.corner_lt1 = tWallConfig.corner_lt1
	tConfig.corner_rt1 = tWallConfig.corner_rt1
	tConfig.corner_lb1 = tWallConfig.corner_lb1
	tConfig.corner_rb1 = tWallConfig.corner_rb1
	tConfig.door_v = tWallConfig.door_v
	tConfig.door_h = tWallConfig.door_h
	tConfig.swall_v = tWallConfig.swall_v
	tConfig.swall_h = tWallConfig.swall_h
	tConfig.blocks = tWallConfig.blocks
	
	--大菠萝数据初始化
	hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
	xlScene_LoadMap(g_world, "world/csys_random_test_userdef",0,hVar.MAP_TD_TYPE.NORMAL)
end
local callbackCancel = function(...) print(...) end
hGlobal.event:event("LocalEvent_Phone_ShowGMResourceFrm", callbackOK, callbackCancel)
]]


