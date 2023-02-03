--黑龙宝藏返回按钮
hGlobal.UI.InitMapDragonMainFrm = function(mode)
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>选择关卡主操作界面")
	
	local tInitEventName = {"LocalEvent_Phone_ShowPhone_SelecteMap", "__ShowMapDragonFrm",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local current_funcCallback = nil --回调函数
	
	--创建frm
	hGlobal.UI.MapDragonMainFrm_New = hUI.frame:new({
		x = 0,
		y = 0,
		w = 1,
		h = 1,
		z = 502,
		show = 0,
		dragable = 2,
		buttononly = 1,
		autoactive = 0,
		border = 0,
	})
	local _frm = hGlobal.UI.MapDragonMainFrm_New
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--当前操作的地图对象
	--局部函数
	local _createshMainFrm = nil
	
	_createshMainFrm = function()
		--iPhoneX黑边宽
		local iPhoneX_WIDTH = 0
		if (g_phone_mode == 4) then --iPhoneX
			if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
				iPhoneX_WIDTH = 80
			end
		end
		
		local vipLv = LuaGetPlayerVipLv()
		local totalMoney = LuaGetTopupCount()
		
		--背景图
		hApi.safeRemoveT(_childUI, "btnPanel")
		_childUI["btnPanel"] = hUI.button:new({
			parent = _frm,
			model = "misc/chest/dragon_panel.png",
			x = 294.5,
			--y = -34 * _ScaleH,
			y = 150.5,
			scale = 1.0,
		})
		--VIP等级前缀
		_childUI["btnPanel"].childUI["vip"] = hUI.label:new({
			parent = _childUI["btnPanel"].handle._n,
			width = 300,
			x = -200,
			y = -50,
			text = vipLv,
			size = 44,
			aligh = "MC",
			border = 0,
			font = "num",
			--RGB = {255, 255, 0},
		})
		if (vipLv == 0) then
			_childUI["btnPanel"].childUI["vip"]:setText("")
		end
		
		--累计充值金额
		local strpurchase = ""
		local nMoneyX = - 100
		local sMoneyAligh = "LC"
		local nMoneySize = 28
		if (totalMoney == 0) then
			strpurchase = hVar.tab_string["__TEXT_allRmb0"]
			nMoneyX = 0
			sMoneyAligh = "MC"
			nMoneySize = 36
		else
			strpurchase = string.format(hVar.tab_string["__TEXT_allRmb2"], totalMoney*10)
		end
		_childUI["btnPanel"].childUI["money"] = hUI.label:new({
			parent = _childUI["btnPanel"].handle._n,
			width = 500,
			x = nMoneyX,
			y = -64,
			text = strpurchase,
			size = nMoneySize,
			aligh = sMoneyAligh,
			border = 1,
			font = hVar.FONTC,
			RGB = {255, 255, 0},
		})
		
		local closex = hVar.SCREEN.w - 66
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			closex = 642
		end

		--顶部返回按钮
		--closeBtn
		hApi.safeRemoveT(_childUI, "return")
		_childUI["return"] = hUI.button:new({
			parent = _frm,
			model = "misc/mask.png",
			--x = hVar.SCREEN.w - iPhoneX_WIDTH - 40 * _ScaleW,
			x = closex,
			--y = -34 * _ScaleH,
			y = 68,
			w = 128,
			h = 128,
			scaleT = 0.95,
			font = hVar.FONTC,
			border = 1,
			code = function()
				--[[
				--连接pvp服务器
				if (Pvp_Server:GetState() ~= 1) then --未连接
					Pvp_Server:Connect()
				elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
					Pvp_Server:UserLogin()
				end
				]]
				
				_frm:show(0)
				
				--释放png, plist的纹理缓存
				--hApi.ReleasePngTextureCache()
				
				--禁用聊天按钮
				--_childUI["chatButton"]:setstate(-1)
				
				--返回主界面
				--hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
				--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				--hGlobal.LocalPlayer:focusworld(__G_MainMenuWorld)
				--hGlobal.WORLD.LastWorldMap:disableTimer()
				hGlobal.event:event("LocalEvent_Phone_CloasePhone_SelecteMap")
				
				--geyachao: 不重新加载map，只是switch scene
				--[[
				--进入坦克配置界面
				local mapname = hVar.MainBase
				local MapDifficulty = 0
				local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
				xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
				]]
				
				hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR = 1
				hGlobal.LocalPlayer:focusworld(hGlobal.WORLD.LastWorldMap)
				hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR = 0
				
				--退出黑龙scene，允许旋转
				hApi.RecoverScreenRotation()
				
				hGlobal.WORLD.LastWorldMap:resumeTimer()
				hGlobal.event:event("LocalEvent_RecoverBarrage")
				--hGlobal.event:event("LocalEvent_TD_NextWave") --主界面监听事件再加一遍
				
				--回调事件
				if (type(current_funcCallback) == "function") then
					current_funcCallback()
				end
			end,
		})
		_childUI["return"].handle.s:setOpacity(0) --只响应事件，不显示
		--图片
		_childUI["return"].childUI["icon"] = hUI.button:new({
			parent = _childUI["return"].handle._n,
			model = "ICON:DRAGON_EXIT",
			x = 0,
			y = 0,
			scale = 1.0,
		})
        
        -- 玩家拥有的装备表
        -- @param key number 装备itemId
        -- @param value boolean 是否拥有
        local ownedItemIdMap = {}
		-- 读取背包
		local storehouse = LuaGetStoreHouse()
		if (type(storehouse) == "table") then
			for index = 1,hVar.EquipMaxNum do
				local uid = storehouse[index]
				local _,oEquip = LuaFindEquipByUniqueId(uid)
                if type(oEquip) == "table" then
                    local itemId = oEquip[hVar.ITEM_DATA_INDEX.ID]
                    ownedItemIdMap[itemId] = true
                end
            end
        end

		--读取战车装备
		local oHero = hApi.GetHeroCardById(hVar.MY_TANK_ID)
		if type(oHero) == "table" then
			local equipment = oHero.equipment
			if type(equipment) == "table" then
				for i = 1,hVar.HERO_EQUIP_SIZE do
					local uniqueId = equipment[i]
					local _,oEquip = LuaFindEquipByUniqueId(uniqueId)
					if type(oEquip) == "table" then
						local itemId = oEquip[hVar.ITEM_DATA_INDEX.ID]
						ownedItemIdMap[itemId] = true
					end
				end
			end
		end
		
		--找到红装展示台
		local oMap = __G_SelectMapWorld --城镇地图
		--print("oMap=", oMap)
		local tAllChaHandle = oMap.data.chaHandle
		--print("tAllChaHandle=", tAllChaHandle)
		local townTypeId1 = 40010 --红装展示台1
		local townTypeId2 = 40011 --红装展示台2
		local townTypeId3 = 40012 --红装展示台3
		local townTypeId4 = 40013 --红装展示台4
		for i = 1, #tAllChaHandle, 1 do
			local tChaHandle = tAllChaHandle[i]
			local typeId = tChaHandle.data.id
			local worldX = tChaHandle.data.worldX
			local worldY = tChaHandle.data.worldY
			--print(typeId)
			if (typeId == townTypeId1) then --找到了1
				--依次绘制单位
				for i = 1, hVar.RedEquip_ROW, 1 do
					local itemId = hVar.RedEquip[i]
					if itemId then
						local tabI = hVar.tab_item[itemId]
						
						oMap.worldUI["item_"..itemId] = hUI.button:new({
							parent = tChaHandle._n,
							model = tabI.icon,
							x = 0,
							y = -330 + (i - 1) * 102,
							--scale = 1.0,
							w = 80,
							h = 80,
							--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
							scaleT = 0.95,
							code = function()
								local oEquip = {itemId, 1, nil, 0,"", 0, 0, 1,{{hVar.ITEM_FROMWHAT_TYPE.NET,0,0,0}},0,0,0,
										0,0,0,0,0,0,0,0,0,0,
										0,0,0,0,0,0,}
								hGlobal.event:event("localEvent_ShowItemTipFrm", oEquip, nil, nil, true)
							end,
						})
                        if not ownedItemIdMap[itemId] then
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "gray")
                        else
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "normal")
                        end
						
						--动画
						local delayTime1 = math.random(200, 500)
						local delayTime2 = math.random(500, 1500)
						local moveTime = math.random(1000, 2500)
						local moveDy = math.random(5, 12)
						local act1 = CCDelayTime:create(delayTime1/1000)
						local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
						local act3 = CCDelayTime:create(delayTime2/1000)
						local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						a:addObject(act4)
						local sequence = CCSequence:create(a)
						--oItem.handle.s:stopAllActions() --先停掉之前的动作
						oMap.worldUI["item_"..itemId].handle._n:runAction(CCRepeatForever:create(sequence))
					end
				end
				
				--地鼠币图标
				oMap.worldUI["item_dishucoin"] = hUI.button:new({
					parent = tChaHandle._n,
					model = "misc/task/gamecoin01.png",
					x = 0 - 550,
					y = -320 - 74,
					--scale = 1.0,
					w = 80,
					h = 80,
					--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
					scaleT = 0.95,
					code = function()
						--检测gameserver版本号是否为最新
						if (not hApi.CheckGameServerVersionControl()) then
							return
						end
						
						--挡操作
						hUI.NetDisable(30000)
						
						--领取VIP每日奖励
						SendCmdFunc["get_VIP_dailyReward"]()
					end,
				})
				--检测VIP领取1按钮是否显示
				local enableVIPDaliyReward = false
				if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励1
					enableVIPDaliyReward = true
				end
				if (not enableVIPDaliyReward) then
					oMap.worldUI["item_dishucoin"]:setstate(-1)
				end
				
				--顺丰快递
				local sfModel = "effect/sf3.png"
				if (LuaGetPlayerVipLv() >= 2) then
					sfModel = "effect/sf4.png"
				end
				oMap.worldUI["item_sf"] = hUI.button:new({
					parent = tChaHandle._n,
					model = sfModel,
					x = 0 - 740,
					y = -320 - 70,
					--scale = 1.0,
					w = 200,
					h = 200,
					--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
					scaleT = 0.95,
					code = function()
						--检测gameserver版本号是否为最新
						if (not hApi.CheckGameServerVersionControl()) then
							return
						end
						
						--挡操作
						hUI.NetDisable(30000)
						
						--领取VIP每日奖励
						SendCmdFunc["get_VIP_dailyReward2"]()
					end,
				})
				--检测VIP领取2按钮是否显示
				local enableVIPDaliyReward2 = false
				if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward2() == 0) then --是vip，没领取奖励2
					enableVIPDaliyReward2 = true
				end
				if (not enableVIPDaliyReward2) then
					oMap.worldUI["item_sf"]:setstate(-1)
				end
			end
			
			if (typeId == townTypeId2) then --找到了2
				--依次绘制单位
				for i = 1, hVar.RedEquip_ROW, 1 do
					local itemId = hVar.RedEquip[i+hVar.RedEquip_ROW]
					if itemId then
						local tabI = hVar.tab_item[itemId]
						
						oMap.worldUI["item_"..itemId] = hUI.button:new({
							parent = tChaHandle._n,
							model = tabI.icon,
							x = 0,
							y = -330 + (i - 1) * 102,
							--scale = 1.0,
							w = 80,
							h = 80,
							--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
							scaleT = 0.95,
							code = function()
								local oEquip = {itemId, 1, nil, 0,"", 0, 0, 1,{{hVar.ITEM_FROMWHAT_TYPE.NET,0,0,0}},0,0,0,
										0,0,0,0,0,0,0,0,0,0,
										0,0,0,0,0,0,}
								hGlobal.event:event("localEvent_ShowItemTipFrm", oEquip, nil, nil, true)
							end,
						})
                        if not ownedItemIdMap[itemId] then
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "gray")
                        else
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "normal")
                        end
						
						--动画
						local delayTime1 = math.random(200, 500)
						local delayTime2 = math.random(500, 1500)
						local moveTime = math.random(1000, 2500)
						local moveDy = math.random(5, 12)
						local act1 = CCDelayTime:create(delayTime1/1000)
						local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
						local act3 = CCDelayTime:create(delayTime2/1000)
						local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						a:addObject(act4)
						local sequence = CCSequence:create(a)
						--oItem.handle.s:stopAllActions() --先停掉之前的动作
						oMap.worldUI["item_"..itemId].handle._n:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
			
			if (typeId == townTypeId3) then --找到了3
				--依次绘制单位
				for i = 1, hVar.RedEquip_ROW, 1 do
					local itemId = hVar.RedEquip[i+hVar.RedEquip_ROW*2]
					if itemId then
						local tabI = hVar.tab_item[itemId]
						
						oMap.worldUI["item_"..itemId] = hUI.button:new({
							parent = tChaHandle._n,
							model = tabI.icon,
							x = 0,
							y = -330 + (i - 1) * 102,
							--scale = 1.0,
							w = 80,
							h = 80,
							--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
							scaleT = 0.95,
							code = function()
								local oEquip = {itemId, 1, nil, 0,"", 0, 0, 1,{{hVar.ITEM_FROMWHAT_TYPE.NET,0,0,0}},0,0,0,
										0,0,0,0,0,0,0,0,0,0,
										0,0,0,0,0,0,}
								hGlobal.event:event("localEvent_ShowItemTipFrm", oEquip, nil, nil, true)
							end,
						})
                        if not ownedItemIdMap[itemId] then
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "gray")
                        else
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "normal")
                        end
						
						--动画
						local delayTime1 = math.random(200, 500)
						local delayTime2 = math.random(500, 1500)
						local moveTime = math.random(1000, 2500)
						local moveDy = math.random(5, 12)
						local act1 = CCDelayTime:create(delayTime1/1000)
						local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
						local act3 = CCDelayTime:create(delayTime2/1000)
						local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						a:addObject(act4)
						local sequence = CCSequence:create(a)
						--oItem.handle.s:stopAllActions() --先停掉之前的动作
						oMap.worldUI["item_"..itemId].handle._n:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
			
			if (typeId == townTypeId4) then --找到了4
				--依次绘制单位
				for i = 1, hVar.RedEquip_ROW, 1 do
					local itemId = hVar.RedEquip[i+hVar.RedEquip_ROW*3]
					if itemId then
						local tabI = hVar.tab_item[itemId]
						
						oMap.worldUI["item_"..itemId] = hUI.button:new({
							parent = tChaHandle._n,
							model = tabI.icon,
							x = 0,
							y = -330 + (i - 1) * 102,
							--scale = 1.0,
							w = 80,
							h = 80,
							--dragbox = oMap.handle.__FrameUI.childUI["dragBox"],
							scaleT = 0.95,
							code = function()
								local oEquip = {itemId, 1, nil, 0,"", 0, 0, 1,{{hVar.ITEM_FROMWHAT_TYPE.NET,0,0,0}},0,0,0,
										0,0,0,0,0,0,0,0,0,0,
										0,0,0,0,0,0,}
								hGlobal.event:event("localEvent_ShowItemTipFrm", oEquip, nil, nil, true)
							end,
						})
                        if not ownedItemIdMap[itemId] then
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "gray")
                        else
                            hApi.AddShader(oMap.worldUI["item_"..itemId].handle.s, "normal")
                        end
						
						--动画
						local delayTime1 = math.random(200, 500)
						local delayTime2 = math.random(500, 1500)
						local moveTime = math.random(1000, 2500)
						local moveDy = math.random(5, 12)
						local act1 = CCDelayTime:create(delayTime1/1000)
						local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
						local act3 = CCDelayTime:create(delayTime2/1000)
						local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						a:addObject(act4)
						local sequence = CCSequence:create(a)
						--oItem.handle.s:stopAllActions() --先停掉之前的动作
						oMap.worldUI["item_"..itemId].handle._n:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
			
			--vip宝物动画效果
			local maxVipLv = hVar.Vip_Conifg.maxVipLv
			local mapUnit = hVar.Vip_Conifg.mapUnit
			for vip = 1, maxVipLv, 1 do
				local vipUnitId = mapUnit[vip]
				if (typeId == vipUnitId) then --找到了
					local tabU = hVar.tab_unit[typeId]
					local effect = tabU.effect
					if effect then
						oMap.worldUI["effect_"..effect] = hUI.image:new({
							parent = tChaHandle._n,
							model = effect,
							x = 0,
							y = 0,
							--w = w/2,
							--h = h/2,
						})
					end
				end
			end
		end
	end
	
	--横竖屏切换
	hGlobal.event:listen("LocalEvent_SpinScreen","__ShowMapDragonFrm",function()
		if (_frm.data.show == 1) then
			_createshMainFrm()
			--print("AAA")
		end
	end)
	
	--领取vip奖励事件
	hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "_SelectMap_VIP_REWARD", function(dailyRewardFlag, rewardIndex)
		if (_frm.data.show == 1) then
			if (dailyRewardFlag == 1) then --领取成功
				local oMap = __G_SelectMapWorld --城镇地图
				if oMap then
					local ctrli = nil
					
					if (rewardIndex == 1) then
						--地鼠币
						ctrli = oMap.worldUI["item_dishucoin"]
					elseif (rewardIndex == 2) then
						--顺丰快递
						ctrli = oMap.worldUI["item_sf"]
					elseif (rewardIndex == 3) then
						--
					end
					
					if ctrli then
						ctrli:setstate(-1)
					end
				end
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_ShowPhone_SelecteMap", "__ShowMapDragonFrm", function(chapterId, callback)
		print("LocalEvent_Phone_ShowPhone_SelecteMap", __ShowMapDragonFrm, chapterId, callback)
		
		--存储回调事件
		current_funcCallback = callback
		
		if (chapterId == 99) then
			_frm:show(1)
			_frm:active()
			_createshMainFrm()
		else
			_frm:show(0)
		end
		
		--设置镜头
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			xlSetViewNodeFocus(694, 864)
		else
			xlSetViewNodeFocus(936, 966)
		end
	end)
end

--[[
--测试 --test
if hGlobal.UI.MapDragonMainFrm_New then
	hGlobal.UI.MapDragonMainFrm_New:del()
	hGlobal.UI.MapDragonMainFrm_New = nil
end
hGlobal.UI.InitMapDragonMainFrm("include")
SendCmdFunc["get_VIP_Lv_New"]()

--hGlobal.LocalPlayer:setfocusworld(nil)
hGlobal.event:event("LocalEvent_HideBarrage")
hGlobal.WORLD.LastWorldMap:disableTimer()
hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 99)
--]]