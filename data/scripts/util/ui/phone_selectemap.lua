--local __G_SelectMapWorld = nil
__G_SelectMapWorld = nil --geyachao: 全局可以获取
hGlobal.UI.InitPhone_SelecteMap = function()
	local tTalkChaHandle
	local aniSet = {}

	--设置镜头聚焦位置
	local _setViewNodeFocus = function(chapterId)
		--geyachao: 读取本章的镜头偏移值
		local cameraDx = 0
		local cameraDy = 0
		local camera = hVar.tab_chapter[chapterId].camera --镜头控制
		if camera then
			for i = 1, #camera, 1 do
				local mapName = camera[i].mapName
				local pad = camera[i].pad
				local phone = camera[i].phone
				
				if (mapName == nil) or (mapName == 0) then --默认镜头位置
					if (g_phone_mode == 0) then --平板模式
						cameraDx = pad.dx
						cameraDy = pad.dy
					else --非平板模式
						cameraDx = phone.dx
						cameraDy = phone.dy
					end
				else --通关某地图后镜头的位置
					local isFinishMap = LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否解锁
					if (isFinishMap == 1) then --已通关
						if (g_phone_mode == 0) then --平板模式
							cameraDx = pad.dx
							cameraDy = pad.dy
						else --非平板模式
							cameraDx = phone.dx
							cameraDy = phone.dy
						end
					else --未通关
						--跳出循环
						break
					end
				end
			end
		end
		
		--设置镜头
		hApi.setViewNodeFocus(hVar.SCREEN.w / 2 + cameraDx, hVar.SCREEN.h / 2 + cameraDy)
	end
	
	--创建对话信息
	local _createTalk = function (tChaHandle, talkType, codeExit)
		local tMyTalk
		local id = tChaHandle.data.id
		local trigger = tChaHandle.data.triggerID or {}
		if trigger and type(trigger) == "table" and trigger.talk then
			for i = 1, #trigger.talk do
				if trigger.talk[i][1] == talkType then
					tMyTalk = trigger.talk[i]
				end
			end
		end
		
		if tMyTalk then
			local vTalk
			vTalk = {id = {id,id},}
			tTalkChaHandle = {tChaHandle,tMyTalk,vTalk,codeExit} --说完话之后显示该单位
		else
			if codeExit and type(codeExit) == "function" then
				codeExit()
			end
		end
	end
	
	--显示关卡解锁剧情对话信息
	local _showUnlockMapTalk = function(flag)
		if tTalkChaHandle then
			local tChaHandle = tTalkChaHandle[1]
			local tMyTalk = tTalkChaHandle[2]
			local vTalk = tTalkChaHandle[3]
			local codeExit = tTalkChaHandle[4]
			local oWorld = hClass.world:new({type="none"})
			local oUnit = oWorld:addunit(1,1)
			
			hApi.AnalyzeTalk(oUnit,oUnit,tMyTalk,vTalk)
			hApi.CreateUnitTalk(vTalk,function()
				oWorld:del()
				oUnit:del()
				if codeExit and type(codeExit) == "function" then
					codeExit()
					--触发引导
					if (__G_SelectMapWorld) then
						hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", flag)
					end
				end
			end)
			tTalkChaHandle = nil
		else
			--触发引导
			if (__G_SelectMapWorld) then
				hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", flag)
			end
		end
	end

	local __refreshStar = function(_oMap, _mapId, _tChaHandle)
			local star = (LuaGetPlayerMapAchi(_mapId,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
			if _tChaHandle.nChaCount then
				--显示关卡的星星数
				for k = 1, 3, 1 do
					if (k <= star) then --有星星
						_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(k)].handle._n:setVisible(true)
						_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(k)]:setXY(5 + (star - 1) * (-10) + (k - 1) * 20,- 45)
					else --没星星
						_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(k)].handle._n:setVisible(false)
					end
				end
				
				--挑战难度完成情况判定
				local diffMax = (LuaGetPlayerMapAchi(_mapId,hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0)
				for n = 1, 3, 1 do
					if (n < diffMax) then --前面的挑战难度，肯定是3星，所以这里描橙
						_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(n)].handle.s:setColor(ccc3(255, 140, 0))
					else
						local diffStar = (LuaGetPlayerMapAchi(_mapId,hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0)
						if (diffStar >= 3) then --三星通关挑战难度，描橙
							_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(n)].handle.s:setColor(ccc3(255, 140, 0))
						else --不是三星通关挑战难度，正常颜色
							_oMap.worldUI["MapStar_".. tostring(_tChaHandle.nChaCount).."_".. tostring(n)].handle.s:setColor(ccc3(255, 255, 255))
						end
					end
				end
				
				
			end
		end
	
	--刷新所有地图角色显示
	local _refreshAllMapUnit = function (oMap, tAllChaHandle)
		
		local chapterId = oMap.data.chapterId
		
		_setViewNodeFocus(chapterId)
		
		for k, v in pairs(oMap.worldUI) do
			if type(k) == "string" and (string.find(k, "UDaction_") or string.find(k, "CombatEva_") or string.find(k, "CombatEvaEx_")) then
				if (oMap.worldUI[k] ~= nil) then
					hApi.safeRemoveT(oMap.worldUI, k)
				end
			end
		end
		
		--[[
		for i = 1, #tAllChaHandle do
			local tChaHandle = tAllChaHandle[i]
			local id = tChaHandle.data.id
			local trigger = tChaHandle.data.triggerID or {}
			if hVar.tab_unit[id] and hVar.tab_unit[id].mapkey and hVar.MAP_INFO[hVar.tab_unit[id].mapkey] then
			else
				xlCha_Hide(tChaHandle._c,1)
			end
		end
		]]
		for i = 1, #tAllChaHandle do
			local tChaHandle = tAllChaHandle[i]
			local id = tChaHandle.data.id
			local trigger = tChaHandle.data.triggerID or {}
			xlCha_Hide(tChaHandle._c,0)
		end
		--[[
		for i = 1, #tAllChaHandle, 1 do
			local tChaHandle = tAllChaHandle[i]
			local id = tChaHandle.data.id
			local trigger = tChaHandle.data.triggerID or {}
			if hVar.tab_unit[id] and hVar.tab_unit[id].mapkey and hVar.MAP_INFO[hVar.tab_unit[id].mapkey] then
				local mapId = hVar.tab_unit[id].mapkey
				if hVar.MAP_INFO[mapId].mapType == 4 then
					local isFinish = LuaGetPlayerMapAchi(mapId, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
					--print("mapId=", mapId, "id=", id, "isFinish=", isFinish, "type(isFinish)=", type(isFinish))
					
					--第一章的第一关特殊处理
					if hVar.tab_unit[id].mapkey ~= hVar.tab_chapter[1].firstmap then
						--其他已完成关显示小星星
						__refreshStar(oMap, mapId, tChaHandle)
						if (isFinish == 0) then
							--如果不是第一张地图
							--如果没有完成的关卡，先设置成不显示状态
							oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(false)
							if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
								oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(false)
							end
							xlCha_Hide(tChaHandle._c,1)
						else
							oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
								oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							end
							xlCha_Hide(tChaHandle._c,0)
						end
						
					else
						if (isFinish > 0) then
							--第一关显示小星星
							__refreshStar(oMap, mapId, tChaHandle)
							oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
								oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							end
							
							xlCha_Hide(tChaHandle._c,0)
						else
							xlCha_Hide(tChaHandle._c,1)
							
							local _func = function()
								__refreshStar(oMap, mapId, tChaHandle)
								xlCha_Hide(tChaHandle._c,0)
								oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
								if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
									oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
								end
							end
							_createTalk(tChaHandle, "mapUnlock", _func)
						end
					end
					
					if (isFinish == 0) then
						--如果该关卡还没打，但已经解锁，则设置动画
						if hApi.CheckUnlockMap(mapId) == 1 then
							local _func = function()
								--将解锁路点，及该关卡插入到动画播放列表中
								if trigger and type(trigger) == "table" then
									if trigger.unlockPoint and type(trigger.unlockPoint) == "table" then
										--遍历解锁路点
										for i = 1, #trigger.unlockPoint do
											local chaHandle = oMap:tgrid2cha(trigger.unlockPoint[i])
											table.insert(aniSet, chaHandle)
											xlCha_Hide(chaHandle._c,0)
										end
									end
									if trigger.addEffect then
										local chaHandle = oMap:tgrid2cha(trigger.addEffect)
										
										if chaHandle then
											xlCha_Hide(chaHandle._c,0)
										end
									end
								end
								
								--将当前已解锁的关卡放入列表
								table.insert(aniSet, tChaHandle)
								
								--以下为表现效果，以后可以在动画表现结束之后做
								xlCha_Hide(tChaHandle._c,0)
								oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
								if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
									oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
								end
								
								local flag = true
								
								--如果是无尽关卡，创建战绩字样
								if mapId == hVar.tab_chapter[chapterId].endlessMap[1] or mapId == hVar.tab_chapter[chapterId].endlessMap[2] then
									local challenge = LuaGetPlayerGamecenter_Challenge(mapId)
									
									if challenge > 0 then
										flag = false
									end
									
									oMap.worldUI["CombatEva_"..(tChaHandle.nChaCount)] = hUI.image:new({
										parent = tChaHandle._tn,
										x = -45,
										y = -70,
										scale = 0.6,
										model = "ICON:icon01_x1y1",
										IsTemp = oMap.data.IsTemp,
									})
									oMap.worldUI["CombatEvaEx_"..(tChaHandle.nChaCount)] = hUI.label:new({
										parent = tChaHandle._tn,
										x = -25,
										y = -70,
										font = "numWhite",
										text = LuaGetPlayerGamecenter_Challenge(mapId).." ",
										size = 22,
										align = "LC",
										border = 1,
										IsTemp = oMap.data.IsTemp,
									})
									oMap.worldUI["CombatEvaEx_"..(tChaHandle.nChaCount)].handle.s:setColor(ccc3(230,180,50))
								elseif hVar.MAP_INFO[mapId].billboard or hVar.MAP_INFO[mapId].togameurl then		--暂时写死,2016.08.02
									flag = false
								end
								
								--创建顶部提示
								if flag then
									if oMap.worldUI["UDaction_"..id] ~= nil then
										hApi.safeRemoveT(oMap.worldUI, "UDaction_"..id)
									end
									oMap.worldUI["UDaction_"..id] = hUI.thumbImage:new({
										parent = tChaHandle._tn,
										y = 80,
										scale = 1,
										model = "Action:updown",
										animation = "updown",
										IsTemp = oMap.data.IsTemp,
									})
									
									local a = CCScaleBy:create(0.4,1.03,1.03)
									local aR = a:reverse()
									local seqA = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
									tChaHandle._n:runAction(CCRepeatForever:create(seqA))
								end
								
							end
							
							_createTalk(tChaHandle, "mapUnlock", _func)
						end
					else
						if type(trigger) == "table" then
							if trigger.unlockPoint then
								--显示已通关关卡的
								for i = 1, #trigger.unlockPoint do
									local chaHandle = oMap:tgrid2cha(trigger.unlockPoint[i])
									xlCha_Hide(chaHandle._c,0)
								end
							end
							if trigger.addEffect then
								local chaHandle = oMap:tgrid2cha(trigger.addEffect)
								if chaHandle then
									xlCha_Hide(chaHandle._c,0)
								end
							end
							oMap.worldUI["MapName"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							if oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)] then
								oMap.worldUI["MapNameBg"..(tChaHandle.nChaCount)].handle._n:setVisible(true)
							end
						end
						
						
						if hVar.tab_unit[id].mapkey == hVar.tab_chapter[chapterId].endlessMap[1] or hVar.tab_unit[id].mapkey == hVar.tab_chapter[chapterId].endlessMap[2] then
							--第一章挑战关卡创建ui
							oMap.worldUI["CombatEva_"..(tChaHandle.nChaCount)] = hUI.image:new({
								parent = tChaHandle._tn,
								x = -45,
								y = -70,
								scale = 0.6,
								model = "ICON:icon01_x1y1",
								IsTemp = oMap.data.IsTemp,
							})
							oMap.worldUI["CombatEvaEx_"..(tChaHandle.nChaCount)] = hUI.label:new({
								parent = tChaHandle._tn,
								x = -5,
								y = -70,
								font = "numWhite",
								text = LuaGetPlayerGamecenter_Challenge(mapId).." ",
								size = 22,
								align = "LC",
								border = 1,
								IsTemp = oMap.data.IsTemp,
							})
							oMap.worldUI["CombatEvaEx_"..(tChaHandle.nChaCount)].handle.s:setColor(ccc3(230,180,50))
						end
					end
				end
			end
		end
		]]
	end
	
	--创建选择关卡界面
	local _createSelectMapWorld = function(chapterId)
		print("创建选择关卡界面", chapterId)
		local cId = chapterId or 1
		local cMap = hVar.PHONE_SELECTLEVEL
		local cBg = "other/map_extend"
		if hVar.tab_chapter[cId] and hVar.tab_chapter[cId].map then
			cMap = hVar.tab_chapter[cId].map
			cBg =  hVar.tab_chapter[cId].background
		end
		
		if __G_SelectMapWorld then
			__G_SelectMapWorld:del()
			__G_SelectMapWorld = nil
		end
		
		local nChaCount = 0
		__G_SelectMapWorld = hClass.map:new({
			map = cMap,
			chapterId = cId,
			background = cBg,
			scenetype = "chooselevel",
			IsTemp = hVar.TEMP_HANDLE_TYPE.MAP_CHOOSE_LEVEL,
			--创建每一个cha的时候回调
			codeOnChaCreate = function(oMap,tChaHandle,id,owner,worldX,worldY,facing)
				--print("codeOnChaCreate", id,owner,worldX,worldY,facing)
				local trigger = tChaHandle.data.triggerID
				
				nChaCount = nChaCount + 1
				
				--设置不可见
				if g_editor ~= 1 then
					--xlCha_Hide(tChaHandle._c,1)
				end
				--print(id,hVar.tab_unit[id].mapkey)
				if not hVar.tab_unit[id] or not hVar.tab_unit[id].mapkey or not hVar.MAP_INFO[hVar.tab_unit[id].mapkey] then
					--print("return")
					return
				end
				
				local mapId = hVar.tab_unit[id].mapkey
				local model = hVar.tab_unit[id].model
				--[[
				if model == "ICON_world/level_cbzz" then
					oMap.worldUI["MapName"..nChaCount] = hUI.label:new({
						parent = tChaHandle._tn,
						x = 0,
						y = 34,
						font = hVar.FONTC,
						text = hVar.MAP_INFO[hVar.tab_unit[id].mapkey].name,
						size = 20,
						align = "MC",
						border = 1,
						--RGB = {230,180,50},
						IsTemp = oMap.data.IsTemp,
					})
				else
					oMap.worldUI["MapNameBg"..nChaCount] = hUI.image:new({
						parent = tChaHandle._tn,
						model = "UI:PVP_RedCover",
						x = 10,
						y = 44,
						IsTemp = oMap.data.IsTemp,
					})

					oMap.worldUI["MapName"..nChaCount] = hUI.label:new({
						parent = tChaHandle._tn,
						x = 0,
						y = 44,
						font = hVar.FONTC,
						text = hVar.MAP_INFO[hVar.tab_unit[id].mapkey].name,
						size = 20,
						align = "MC",
						border = 1,
						--RGB = {230,180,50},
						IsTemp = oMap.data.IsTemp,
					})
				end
				oMap.worldUI["MapName"..nChaCount].handle._n:setVisible(false)
				if oMap.worldUI["MapNameBg"..nChaCount] then
					oMap.worldUI["MapNameBg"..nChaCount].handle._n:setVisible(false)
				end
				
				--创建通关星星
				local star = (LuaGetPlayerMapAchi(mapId,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
				for k = 1, 3 do
					oMap.worldUI["MapStar_".. tostring(nChaCount).."_".. tostring(k)] = hUI.image:new({
						parent = tChaHandle._tn,
						model = "UI:STAR_YELLOW",
						align = "LT",
						x = 0,
						y = - 45,
						scale = 0.35,
						IsTemp = oMap.data.IsTemp,
					})
					oMap.worldUI["MapStar_".. tostring(nChaCount).."_".. tostring(k)].handle._n:setVisible(false)
				end
				]]
				
				tChaHandle.nChaCount = nChaCount
			end,
			
			--所有地图元素加载完毕后回调
			codeOnAllCreate = function(oMap, tAllChaHandle)
				--if not hVar.OPTIONS.IS_TD_ENTER or hVar.OPTIONS.IS_TD_ENTER ~= 1 then
					--print(""..abc)
					_refreshAllMapUnit(oMap, tAllChaHandle)
				--end
			end,
			
			codeOnTouchDown = function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
				--
			end,
			
			codeOnTouchUp = function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
				
				if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
						font = hVar.FONTC,
						ok = function()
							hApi.xlSetPlayerInfo(1)
						end,
					})
					return
				end
				
				local tChaHandle = oMap:hit2cha(nWorldX,nWorldY)
				--print("tChaHandle=", tChaHandle)
				if tChaHandle then
					--print("hit", tChaHandle.data.id)
					---------------------------------------------------------------------------------
					--提示玩家上次玩到的地图
					local mapId = hVar.tab_unit[tChaHandle.data.id].mapkey
					local isFinish = LuaGetPlayerMapAchi(mapId,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
					if mapId ~= nil then
						if hVar.MAP_INFO[mapId].mapType == 1  then
							if  isFinish == 0 then
								if hApi.CheckUnlockMap(mapId) == 1 then
									--if oMap.worldUI["arrow_bottom"..tChaHandle.data.id] ~= nil then
									--	oMap.worldUI["arrow_bottom"..tChaHandle.data.id].handle._n:setVisible(false)
									--end
									
									if oMap.worldUI["UDaction_"..tChaHandle.data.id] ~= nil then
										oMap.worldUI["UDaction_"..tChaHandle.data.id].handle._n:setVisible(false)
									end
									
								end
							end
						end
					end
					
					---------------------------------------------------------------------------------
					--如果角色boss地图，打开boss信息面板
					local _func = hApi.DoNothing
					if oMap.data.chapterId and hVar.tab_chapter[oMap.data.chapterId] then
						--如果mapid不存在
						if not mapId then
							print("selectmap: mapid is invalid!")
						--bossmap非常古老暂时弃用
						elseif mapId == hVar.tab_chapter[oMap.data.chapterId].bossMap then
							_func = function()
								hGlobal.event:event("LocalEvent_Phone_ShowChallengeMapInfoFrm",oMap.data.chapterId)
							end
						--无尽地图
						elseif mapId == hVar.tab_chapter[oMap.data.chapterId].endlessMap[1] or mapId == hVar.tab_chapter[oMap.data.chapterId].endlessMap[2] then
							_func = function()
								--[[
								--geyachao: pvp模式暂时不开放无尽地图
								hGlobal.UI.MsgBox("当前为测试版本，暂不开放无尽试炼！",{
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
								]]
								hGlobal.event:event("LocalEvent_Phone_ShowEndlessMapInfoFrm", mapId)
							end
						--普通
						else
							_func = function()
								local tabM = hVar.MAP_INFO[mapId]
								--如果是合法的地图dlc,则呼出dlc面板
								if tabM and tabM.dlc and hVar.tab_shopitem[tabM.dlc] then
									hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm",mapId)
								elseif tabM and tabM.billboard then
									--触发事件，显示排行榜界面
									hGlobal.event:event("LocalEvent_Phone_ShowRankBorad", 0)
								elseif tabM and tabM.togameurl then
									hGlobal.event:event("LocalEvent_ShowCMSTGTipFrm")
								else
									hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm", mapId)
								end
								
							end
						end
					else
						_func = function()
							--如果mapid存在
							if mapId then
								hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm",mapId)
							end
						end
					end
					
					--如果没有解锁并且当局没点过,则触发
					if isFinish == 0 and not tChaHandle.data.clickFlag then
						_createTalk(tChaHandle, "firstFight", _func)
						_showUnlockMapTalk(1)
						tChaHandle.data.clickFlag = true
					else
						_func()
					end
				end
				
				--检测是否点到了红装
				for i = 1, #hVar.RedEquip, 1 do
				--for i = 1, 1, 1 do
					local itemId = hVar.RedEquip[i]
					local ctrli = oMap.worldUI["item_"..itemId]
					if ctrli then
						local parent = ctrli.handle._n:getParent()
						local parentx, parenty = parent:getPosition()
						--print(parentx, parenty)
						--print(i, itemId,"nWorldX="..nWorldX,"nWorldY="..nWorldY,nScreenX,nScreenY)
						local bx, by = ctrli.data.x + parentx, -ctrli.data.y - parenty
						local w, h = ctrli.data.w, ctrli.data.h
						--print(bx,by,w,h)
						--print()
						local button_left = bx - w / 2 --英雄选中区域的最左侧
						local button_right = bx + w / 2 --英雄选中区域的最右侧
						local button_top = by - h / 2 --英雄选中区域的最上侧
						local button_bottom = by + h / 2 --英雄选中区域的最下侧
						
						--检测是否点击到了子按钮i
						if (nWorldX >= button_left) and (nWorldX <= button_right) and (nWorldY >= button_top) and (nWorldY <= button_bottom) then
							--print("点到了" .. i)
							--模拟点击后面的子按钮
							ctrli.data.code(ctrli)
						end
					end
				end
				
				--检测是否点到了地鼠币
				local ctrli = oMap.worldUI["item_dishucoin"]
				if ctrli then
					if (ctrli.data.state == 1) then --按钮可点状态
						local parent = ctrli.handle._n:getParent()
						local parentx, parenty = parent:getPosition()
						--print(parentx, parenty)
						--print(i, itemId,"nWorldX="..nWorldX,"nWorldY="..nWorldY,nScreenX,nScreenY)
						local bx, by = ctrli.data.x + parentx, -ctrli.data.y - parenty
						local w, h = ctrli.data.w, ctrli.data.h
						--print(bx,by,w,h)
						--print()
						local button_left = bx - w / 2 --英雄选中区域的最左侧
						local button_right = bx + w / 2 --英雄选中区域的最右侧
						local button_top = by - h / 2 --英雄选中区域的最上侧
						local button_bottom = by + h / 2 --英雄选中区域的最下侧
						
						--检测是否点击到了子按钮i
						if (nWorldX >= button_left) and (nWorldX <= button_right) and (nWorldY >= button_top) and (nWorldY <= button_bottom) then
							--print("点到了" .. i)
							--模拟点击后面的子按钮
							ctrli.data.code(ctrli)
						end
					end
				end
				
				--检测是否点到了顺丰快递
				local ctrli = oMap.worldUI["item_sf"]
				if ctrli then
					if (ctrli.data.state == 1) then --按钮可点状态
						local parent = ctrli.handle._n:getParent()
						local parentx, parenty = parent:getPosition()
						--print(parentx, parenty)
						--print(i, itemId,"nWorldX="..nWorldX,"nWorldY="..nWorldY,nScreenX,nScreenY)
						local bx, by = ctrli.data.x + parentx, -ctrli.data.y - parenty
						local w, h = ctrli.data.w, ctrli.data.h
						--print(bx,by,w,h)
						--print()
						local button_left = bx - w / 2 --英雄选中区域的最左侧
						local button_right = bx + w / 2 --英雄选中区域的最右侧
						local button_top = by - h / 2 --英雄选中区域的最上侧
						local button_bottom = by + h / 2 --英雄选中区域的最下侧
						
						--检测是否点击到了子按钮i
						if (nWorldX >= button_left) and (nWorldX <= button_right) and (nWorldY >= button_top) and (nWorldY <= button_bottom) then
							--print("点到了" .. i)
							--模拟点击后面的子按钮
							ctrli.data.code(ctrli)
						end
					end
				end
				
				--删除上一次的选中框
				if oMap.worldUI["effect_light"] then
					oMap.worldUI["effect_light"]:del()
					oMap.worldUI["effect_light"] = nil
				end
				
				--检测是否点到了vip宝物（一次只响应一个）
				local bClicked = false
				local tAllChaHandle = oMap.data.chaHandle
				for i = 1, #tAllChaHandle, 1 do
					local tChaHandle = tAllChaHandle[i]
					local typeId = tChaHandle.data.id
					local worldX = tChaHandle.data.worldX
					local worldY = tChaHandle.data.worldY
					--print(i,typeId)
					local maxVipLv = hVar.Vip_Conifg.maxVipLv
					local mapUnit = hVar.Vip_Conifg.mapUnit
					for vip = 1, maxVipLv, 1 do
						local vipUnitId = mapUnit[vip]
						if (typeId == vipUnitId) then --找到了
							local tabU = hVar.tab_unit[typeId]
							--print("typeId=", typeId)
							local bx, by = worldX, worldY
							local w, h = tabU.width, tabU.height
							--print(bx,by,w,h)
							--print()
							local button_left = bx - w / 2 --英雄选中区域的最左侧
							local button_right = bx + w / 2 --英雄选中区域的最右侧
							local button_top = by - h / 2 --英雄选中区域的最上侧
							local button_bottom = by + h / 2 --英雄选中区域的最下侧
							
							--检测是否点击到了子按钮i
							if (nWorldX >= button_left) and (nWorldX <= button_right) and (nWorldY >= button_top) and (nWorldY <= button_bottom) then
								bClicked = true
								--print("hit:", typeId)
								local effect_light = tabU.effect_light
								--print("effect_light=", effect_light)
								if effect_light then
									oMap.worldUI["effect_light"] = hUI.image:new({
										parent = tChaHandle._n,
										model = effect_light,
										x = 0,
										y = 0,
										--w = w/2,
										--h = h/2,
									})
									
									--创建vip的tip
									hApi.ShowGeneralVIPTip(vip)
								end
								
								break
							end
						end
					end
					
					if bClicked then
						break
					end
				end
			end,
		})
	end
	
	--显示关卡选择界面
	hGlobal.event:listen("LocalEvent_Phone_ShowPhone_SelecteMap","__Show_Phone_SelecteMap", function(chapterId, callback)
		local userID = xlPlayer_GetUID()
		local playerCardUid = LuaGetPlayerCardUid()
		if userID ~= playerCardUid and userID ~= 0 and playerCardUid ~= 0 then
			xlAppAnalysis("cheat_playercard",0,1,"info",tostring(userID).."-"..tostring(playerCardUid).."-T:"..tostring(os.date("%m%d%H%M%S")))
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenOtherPlayerList"].."\n-["..playerCardUid.."]-".."\n-["..userID.."]-",{
				font = hVar.FONTC,
				ok = function()
					--geyachao: 大菠萝不检测重复id
					--xlExit()
				end,
			})
			return
		end
		
		--检测作弊
		local cheatflag = xlGetIntFromKeyChain("cheatflag")
		if (cheatflag == 1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
			return
		end
		
		--进入黑龙scene，禁止旋转
		hApi.LockScreenRotation()
		
		_createSelectMapWorld(chapterId)
		local tabC = hVar.tab_chapter
		local scrollW = 1024
		local scrollH = 768
		if hVar.tab_chapter and hVar.tab_chapter[chapterId] then
			scrollW = hVar.tab_chapter[chapterId].scrollW or scrollW
			scrollH = hVar.tab_chapter[chapterId].scrollH or scrollH
		end
		
		--print("_______________________________LocalEvent_Phone_ShowPhone_SelecteMap", scrollW, scrollH, chapterId)
		xlScene_SetBound(g_chooselevel, hVar.SCREEN.w - scrollW,scrollW,hVar.SCREEN.h - scrollH,scrollH)
		xlView_SetScale(1.0)
		
		hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR = 1
		hGlobal.LocalPlayer:focusworld(__G_SelectMapWorld)
		hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR = 0
		
		--print("_createSelectMapWorld", chapterId)
		--geyachao: 调试时，打开
		--SSSSSSSSSSSS = 1
		--[[
		if SSSSSSSSSSSS then
			local old_ff = hApi.setViewNodeFocus
			
			hApi.setViewNodeFocus = function(x, y)
				local text = debug.traceback()
				print(text)
				old_ff(x, y)
			end
		end
		]]
		--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
		
		
		if hVar.OPTIONS.IS_TD_ENTER and hVar.OPTIONS.IS_TD_ENTER == 1 then
			--添加一个透明窗体，添加返回和继续游戏按钮 默认第一章
			if g_curPlayerName == nil then
				hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",LuaGetLastSwitchPlayer())
			else
				hGlobal.event:event("LocalEvent_PhoneShowPlayerCardFrm",g_curPlayerName)
			end
			
			--[[
			--发送获取当前提示的协议
			SendCmdFunc["refresh_systime"]() --获取服务器系统时间
			SendCmdFunc["get_NweVer"]()
			SendCmdFunc["get_NewWebView"]()
			SendCmdFunc["require_quest"]() --获取任务
			local langIdx = g_Cur_Language - 1
			SendCmdFunc["get_ActivityList"](langIdx) --获取活动
			]]
		else
			--[[
			--发送获取当前提示的协议
			SendCmdFunc["refresh_systime"]() --获取服务器系统时间
			SendCmdFunc["get_NweVer"]()
			SendCmdFunc["get_NewWebView"]()
			SendCmdFunc["require_quest"]() --获取任务
			local langIdx = g_Cur_Language - 1
			SendCmdFunc["get_ActivityList"](langIdx) --获取活动
			]]
			
			if __G_SelectMapWorld then
				local tAllChaHandle = __G_SelectMapWorld.data.chaHandle
				_refreshAllMapUnit(__G_SelectMapWorld, tAllChaHandle)
			end
			--显示关卡解锁剧情对话信息
			_showUnlockMapTalk(0)
		end
		
		hApi.PlaySoundBG(g_channel_town, "music/dragon_cave")
		
		--好像会设置不正常，需要再设置一下镜头
		_setViewNodeFocus(chapterId)
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_CloasePhone_SelecteMap","__Cloase_Phone_SelecteMap",function()
		if __G_SelectMapWorld then
			aniSet = {}
			--CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("data/map/world/map_icon.plist")
			tTalkChaHandle = nil
			__G_SelectMapWorld:del()
			__G_SelectMapWorld = nil
			hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.MAP_CHOOSE_LEVEL)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__release_SelecteMap_1-2",function(sSceneType,oWorld,oMap)
		if sSceneType == "worldmap" and type(oWorld) == "table" and oMap == nil then
			if __G_SelectMapWorld~=nil then
				aniSet = {}
				tTalkChaHandle = nil
				__G_SelectMapWorld:del()
				__G_SelectMapWorld = nil
				hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.MAP_CHOOSE_LEVEL)
				xlReleaseResourceFromPList("../map/world/map_icon.plist")
			end
			return 
		end
	end)
	
	--刷新一些其他的显示 isUDaction 是否需要 新手引导箭头
	hGlobal.event:listen("LocalEvent_FreshMapAllUI","SelectedMapFreshUI",function(isUDaction)
		--xlShowFPS(1)
		--xlUI_ShowMiniBar(1)
		if __G_SelectMapWorld then
			
			if hVar.OPTIONS.IS_TD_ENTER and hVar.OPTIONS.IS_TD_ENTER == 1 then
				
				--print("________________________________g_curPlayerName, LocalEvent_FreshMapAllUI:",g_curPlayerName)
				
				--提交申请产生角色id
				--if g_curPlayerName then
				--	SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--	SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
				
				--刷新
				local tAllChaHandle = __G_SelectMapWorld.data.chaHandle
				_refreshAllMapUnit(__G_SelectMapWorld, tAllChaHandle)
				
				--显示关卡解锁剧情对话信息
				_showUnlockMapTalk(0)
				
				--_AddLockFunc()
				--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
				
				
			end
			
		end
		
	end)
	
	hGlobal.event:listen("LocalEvent_afterPlayerCreate", "SelectedMapEnter", function()
		--提交申请产生角色id
		if g_curPlayerName then
			local pId = luaGetplayerDataID()
			--if not pId or pId == 0 then
				SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
				--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
			--end
		end
	end)
end













--创建第一次进入游戏引导
function CreateGuideFrame_MapMain()
	--一次进入游戏引导的状态集
	hGlobal.UI.GuideMapStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_JUQING_BTN = 1, --提示点击剧情战役按钮
		GUIDE_WAIT_JUQING_BTN = 2, --等待点击剧情战役按钮
		GUIDE_CLICK_MAP1 = 3, --提示点击第一关按钮
		GUIDE_WAIT_MAP1_BTN = 4, --等待点击第一关按钮
		GUIDE_INTRODUCE_STAR = 5, --介绍三星奖励信息
		GUIDE_CLICK_BATTLE = 6, --提示点击开始战役按钮
		GUIDE_END = 7, --引导结束
	}
	
	--特殊处理：因为新建账号触发2次引导事件，第二次退出
	if (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.NONE) then
		return
	end
	
	--引导的当前状态
	hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.NONE --一开始为初始状态 -- NONE GUIDE_END
	
	--隐藏的功能: 引导狂点屏幕右上角10次，会弹框提示是否关闭引导
	local _click_screen_count = 0
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideTownHandEffect then --点击剧情战役的手的特效
		hGlobal.UI.GuideTownHandEffect:del()
		hGlobal.UI.GuideTownHandEffect = nil
		--hApi.clearTimer("__UI_GUIDE_002__") --更新第二个箭塔的转圈圈特效的timer
	end
	--if hGlobal.UI.GuideTownRoundEffect then --点击剧情战役的转圈圈的特效
	--	hGlobal.UI.GuideTownRoundEffect:del()
	--	hGlobal.UI.GuideTownRoundEffect = nil
	--end
	if hGlobal.UI.GuideMap001HandEffect then --提示点击第一关按钮的手特效
		hGlobal.UI.GuideMap001HandEffect:del()
		hGlobal.UI.GuideMap001HandEffect = nil
	end
	if hGlobal.UI.GuideMap001RoundEffect then --引导点击第一关按钮的转圈圈特效
		hGlobal.UI.GuideMap001RoundEffect:del()
		hGlobal.UI.GuideMap001RoundEffect = nil
	end
	if hGlobal.UI.GuideStarIntroEffect then --提示三星介绍的特效
		hGlobal.UI.GuideStarIntroEffect:del()
		hGlobal.UI.GuideStarIntroEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.PhoneMapInfoFrm.childUI, "StarIntroduce") --介绍三星奖励的特效
	if hGlobal.UI.BeginBattleHandEffect then --提示开始战斗的手的特效
		hGlobal.UI.BeginBattleHandEffect:del()
		hGlobal.UI.BeginBattleHandEffect = nil
	end
	if hGlobal.UI.BeginBattleRoundEffect then --提示开始战斗的转圈圈特效
		hGlobal.UI.BeginBattleRoundEffect:del()
		hGlobal.UI.BeginBattleRoundEffect = nil
	end
	if hGlobal.UI.CoverInterface then --挡操作的界面
		hGlobal.UI.CoverInterface:del()
		hGlobal.UI.CoverInterface = nil
	end
	
	
	if hGlobal.UI.GuideFreshManMenuBar then --删除主界面
		hGlobal.UI.GuideFreshManMenuBar:del()
		hGlobal.UI.GuideFreshManMenuBar = nil
	end
	
	--创建引导点击剧情战役界面
	--创建父容器
	hGlobal.UI.GuideFreshManMenuBar = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		--z = -1,
		show = 1,
		dragable = 2,
		--buttononly = 1,
		autoactive = 0,
		--background = "UI:PANEL_INFO_MINI",
		background = -1,
		failcall = 1, --出按钮区域抬起也会响应事件
		
		--点击事件（有可能在控件外部点击）
		codeOnDragEx = function(screenX, screenY, touchMode)
			--print("codeOnDragEx", screenX, screenY, touchMode)
			if (touchMode == 0) then --按下
				--
			elseif (touchMode == 1) then --滑动
				--
			elseif (touchMode == 2) then --抬起
				--点击引导第一关界面事件
				OnClickGuideMainMapFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideFreshManMenuBar:active() --最前端显示
	
	--点击引导大地图的进入对战步骤
	function OnClickGuideMainMapFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导大地图的进入对战")
			
			--进入下个状态: 引导点击剧情战役按钮
			--print("进入下个状态: 引导点击剧情战役按钮")
			--print(nil .. nil)
			
			--hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_JUQING_BTN
			
			--显示对话框：引导点击剧情战役按钮
			--__Dialogue_GuideMap_ClickJuQingBtn()
			
			--进入下个状态: 提示点击第一关按钮
			hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_MAP1
			
			--显示对话框：引导点击第一关按钮
			__Dialogue_GuideMap_ClickMap01()
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_CLICK_JUQING_BTN) then --提示点击剧情战役按钮
			--找到剧情战役角色
			local oMap = __G_MainMenuWorld --主界面地图
			local tAllChaHandle = oMap.data.chaHandle
			local townTypeId = 60005 --剧情战役角色类型id
			local tChaJuQingHandle = nil --剧情战役单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == townTypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaJuQingHandle = tChaHandle
					break
				end
			end
			
			local towerScreenX, towerScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建提示点击剧情战役按钮的手特效
			hGlobal.UI.GuideTownHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideFreshManMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = towerScreenX,
				y = towerScreenY + 80,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideTownHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--剧情战役单位描边
			local program = hApi.getShader("outline")
			tChaJuQingHandle.s:setShaderProgram(program)
			local act1 = CCFadeTo:create(0.5, 168)
			local act2 = CCFadeTo:create(0.5, 255)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			tChaJuQingHandle.s:runAction(CCRepeatForever:create(sequence))
			--[[
			local act1 = CCDelayTime:create(0.5)
			local act2 = CCCallFunc:create(function()
				local program = hApi.getShader("outline")
				tChaJuQingHandle.s:setShaderProgram(program)
			end)
			local sequence12 = CCSequence:createWithTwoActions(act1, act2)
			local act3 = CCDelayTime:create(0.5)
			local act4 = CCCallFunc:create(function()
				local program = hApi.getShader("normal")
				tChaJuQingHandle.s:setShaderProgram(program)
			end)
			local sequence34 = CCSequence:createWithTwoActions(act3, act4)
			local sequence = CCSequence:createWithTwoActions(sequence12, sequence34)
			hGlobal.UI.GuideTownHandEffect.handle._n:runAction(CCRepeatForever:create(sequence))
			]]
			--进入下个状态: 等待点击剧情战役按钮
			hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_WAIT_JUQING_BTN
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_WAIT_JUQING_BTN) then --等待点击剧情战役按钮
			--检测是否点击到了剧情战役按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oMap = __G_MainMenuWorld --主界面地图
			local tChaJuQingHandle = oMap:hit2cha(worldX, worldY)
			local townTypeId = 60005 --剧情战役角色类型id
			if tChaJuQingHandle then
				if (tChaJuQingHandle.data.id == townTypeId) then
					--删除提示点击剧情战役按钮的手特效
					if hGlobal.UI.GuideTownHandEffect then --点击剧情战役的手的特效
						hGlobal.UI.GuideTownHandEffect:del()
						hGlobal.UI.GuideTownHandEffect = nil
					end
					
					--停止剧情战役单位的运动
					tChaJuQingHandle.s:stopAllActions()
					--剧情战役单位不描边
					local program = hApi.getShader("normal")
					tChaJuQingHandle.s:setShaderProgram(program)
					
					--进入下个状态: 提示点击第一关按钮
					hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_MAP1
					
					--模拟执行点击大地图事件
					oMap.data.codeOnTouchUp(oMap, worldX, worldY, clickScreenX, clickScreenY)
					
					--显示对话框：引导点击第一关按钮
					__Dialogue_GuideMap_ClickMap01()
				end
			end
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_CLICK_MAP1) then --提示点击第一关按钮
			--找到第一关角色
			local oSelectMap = __G_SelectMapWorld --选关卡地图
			local tAllChaHandle = oSelectMap.data.chaHandle
			local map001TypeId = 60100 --第一关角色类型id
			local tChaMap001Handle = nil --第一关角色单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == map001TypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaMap001Handle = tChaHandle
					break
				end
			end
			
			local map001ScreenX, map001ScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			--创建引导点击第一关按钮的转圈圈特效
			hGlobal.UI.GuideMap001RoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideFreshManMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = map001ScreenX,
				y = map001ScreenY - 5,
				--w = 128,
				--h = 128,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideMap001RoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideMap001RoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideMap001RoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击第一关按钮的手特效
			hGlobal.UI.GuideMap001HandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideFreshManMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = map001ScreenX,
				y = map001ScreenY + 20,
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideMap001HandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击第一关按钮
			hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_WAIT_MAP1_BTN
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_WAIT_MAP1_BTN) then --等待点击第一关按钮
			--检测是否点击到了第一关按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			if (worldX >= (hVar.SCREEN.w - 150)) and (worldY <= 150) then
				_click_screen_count = _click_screen_count + 1
				
				--弹框提示是否关闭引导
				if (_click_screen_count >= 10) then
					local guideFlag = 0
					
					--Ok的回调
					local function okCallback(checkboxState)
						--标记状态为引导结束
						hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_END
						
						--不在引导状态了
						hVar.IS_IN_GUIDE_STATE = 0
						
						--清除整个界面
						if hGlobal.UI.GuideFreshManMenuBar then --界面
							hGlobal.UI.GuideFreshManMenuBar:del()
							hGlobal.UI.GuideFreshManMenuBar = nil
						end
						
						--标记引导第一次进游戏引导完成（取消引导）
						LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
						
						--如果勾选了下次不再显示，那么存档本次设置
						if (checkboxState == 1) then
							--标记存档的新手引导标记
							LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
						end
					end
					
					--Cancel的回调
					local function cancelCallback(checkboxState)
						if (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.NONE) then --初始状态
							--hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_HERO
							OnClickGuideMainMapFrame_Event(0, 0)
						end
						
						--如果勾选了下次不再显示，那么存档本次设置
						if (checkboxState == 1) then
							--标记存档的新手引导标记
							LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
						end
					end
					
					--创建提示是否取消引导的框
					if (guideFlag == 0) then
						MsgBox_GuideSkip(okCallback, cancelCallback, "挑战第一关")
					elseif (guideFlag == -1) then --不需要引导
						okCallback()
					elseif (guideFlag == 1) then --需要引导
						cancelCallback()
					end
				end
			end
			
			local oSelectMap = __G_SelectMapWorld --选关卡地图
			local tChaMap001Handle = oSelectMap:hit2cha(worldX, worldY)
			local map001TypeId = 60100 --第一关角色类型id
			if tChaMap001Handle then
				if (tChaMap001Handle.data.id == map001TypeId) then
					--删除提示点击第一关按钮的手特效
					if hGlobal.UI.GuideMap001HandEffect then --点击第一关的手的特效
						hGlobal.UI.GuideMap001HandEffect:del()
						hGlobal.UI.GuideMap001HandEffect = nil
					end
					
					--删除提示点击第一关按钮的转圈圈特效
					if hGlobal.UI.GuideMap001RoundEffect then --点击第一关的转圈圈的特效
						hGlobal.UI.GuideMap001RoundEffect:del()
						hGlobal.UI.GuideMap001RoundEffect = nil
					end
					
					--模拟执行点击选择关卡事件
					oSelectMap.data.codeOnTouchUp(oSelectMap, worldX, worldY, clickScreenX, clickScreenY)
					
					--geyachao: 不需要三星介绍相关的了，直接提示点击开始按钮
					--[[
					--显示三星的边框提示特效
					local _frm = hGlobal.UI.PhoneMapInfoFrm
					local _parent = _frm.handle._n
					local _childUI = _frm.childUI
					
					--创建提示三星介绍的特效
					_childUI["StarIntroduce"] = hUI.image:new({
						parent = _parent,
						model = "MODEL:default",
						x = _frm.data.w * 0.5,
						y = -150,
						w = 300,
						h = 120,
						scale = 1.0,
						z = 100,
					})
					--_childUI["StarIntroduce"].handle.s:setColor(ccc3(255, 255, 0))
					
					--做淡入运动
					local act1 = CCFadeIn:create(0.5)
					local act2 = CCFadeOut:create(0.5)
					local sequence = CCSequence:createWithTwoActions(act1, act2)
					_childUI["StarIntroduce"].handle._n:runAction(CCRepeatForever:create(sequence))
					]]
					--进入下个状态: 介绍三星奖励信息
					hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_INTRODUCE_STAR
					
					--显示对话框：介绍三星奖励信息
					--__Dialogue_GuideMap_IntroduceStar()
					
					--显示对话框：提示点击进入战役按钮
					__Dialogue_GuideMap_ClickBattle()
				end
			end
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_INTRODUCE_STAR) then --介绍三星奖励信息
			--删除介绍三星奖励信息特效
			hApi.safeRemoveT(hGlobal.UI.PhoneMapInfoFrm.childUI, "StarIntroduce") --介绍三星奖励的特效
			
			--创建一个挡操作的界面
			hGlobal.UI.CoverInterface = hUI.frame:new({
				x = 0,
				y = 0,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
				--z = -1,
				show = 1,
				dragable = 2,
				--buttononly = 1,
				autoactive = 0,
				--background = "UI:PANEL_INFO_MINI",
				failcall = 1, --出按钮区域抬起也会响应事件
				
				--点击事件（有可能在控件外部点击）
				codeOnDragEx = function(screenX, screenY, touchMode)
					--print("codeOnDragEx", screenX, screenY, touchMode)
					if (touchMode == 0) then --按下
						--
					elseif (touchMode == 1) then --滑动
						--
					elseif (touchMode == 2) then --抬起
						--点击引导第二关界面事件
						OnClickGuideMainMapFrame_Event(screenX, screenY)
					end
				end
			})
			
			--创建提示点击开始战斗的转圈圈特效
			local _frm = hGlobal.UI.PhoneMapInfoFrm
			local begin_y = 140 - 10
			if (g_phone_mode ~= 0) then --非平板模式
				begin_y = 76 - 10
			end
			hGlobal.UI.BeginBattleRoundEffect = hUI.image:new({
				parent = hGlobal.UI.CoverInterface.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = _frm.data.x + _frm.data.w * 0.5,
				y = begin_y,
				--w = 400,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.BeginBattleRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.BeginBattleRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.BeginBattleRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击开始战斗的手特效
			hGlobal.UI.BeginBattleHandEffect = hUI.image:new({
				parent = hGlobal.UI.CoverInterface.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = _frm.data.x + _frm.data.w * 0.5,
				y = begin_y + 20,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.BeginBattleHandEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			
			--本界面最前端显示
			hGlobal.UI.CoverInterface:active()
			
			--进入下个状态: 提示点击进入战役按钮
			hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_BATTLE
			
			--显示对话框：提示点击进入战役按钮
			--__Dialogue_GuideMap_ClickBattle()
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_CLICK_BATTLE) then --介绍三星奖励信息
			--检测是否点到了开始战斗按钮里面
			local begin_y = 140 - 10
			if (g_phone_mode ~= 0) then --非平板模式
				begin_y = 76 - 10
			end
			local _frm = hGlobal.UI.PhoneMapInfoFrm
			local x = _frm.data.x + _frm.data.w * 0.5
			local y = begin_y
			local w = 400
			local h = 100
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--删除提示开始战斗的手的特效
				if hGlobal.UI.BeginBattleHandEffect then
					hGlobal.UI.BeginBattleHandEffect:del()
					hGlobal.UI.BeginBattleHandEffect = nil
				end
				
				--删除提示开始战斗的转圈圈特效
				if hGlobal.UI.BeginBattleRoundEffect then
					hGlobal.UI.BeginBattleRoundEffect:del()
					hGlobal.UI.BeginBattleRoundEffect = nil
				end
				
				--删除挡操作的界面
				if hGlobal.UI.CoverInterface then
					hGlobal.UI.CoverInterface:del()
					hGlobal.UI.CoverInterface = nil
				end
				
				--进入下个状态: 引导结束
				hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_END
				
				--无对话
				--...
				
				--强制触发下一状态
				OnClickGuideMainMapFrame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.GUIDE_END) then --引导结束状态
			--删除整个界面
			if hGlobal.UI.GuideFreshManMenuBar then --界面
				hGlobal.UI.GuideFreshManMenuBar:del()
				hGlobal.UI.GuideFreshManMenuBar = nil
			end
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导大地图的进入对战")
			
			--模拟点击开始战斗按钮
			local _frm = hGlobal.UI.PhoneMapInfoFrm
			local _parent = _frm.handle._n
			local _childUI = _frm.childUI
			_childUI["gameStart"].data.code(_childUI["gameStart"])
			
			--这里不标记引导结束（有可能异常退出，第二次登入，还要再引导）（第一关打成功，才标记这个引导结束）
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
		end
	end
	
	--开始引导第一次进游戏
	function BeginGuideMapMain()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideFreshManMenuBar then --界面
				hGlobal.UI.GuideFreshManMenuBar:del()
				hGlobal.UI.GuideFreshManMenuBar = nil
			end
			
			--标记引导第一次进游戏引导完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.GuideMapState == hGlobal.UI.GuideMapStateType.NONE) then --初始状态
				--hGlobal.UI.GuideMapState = hGlobal.UI.GuideMapStateType.GUIDE_CLICK_HERO
				OnClickGuideMainMapFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "挑战第一关")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建大地图对话
	local function __createMapTalk(flag, talkType, _func, ...)
		local arg = {...}
		local oWorld = hClass.world:new({type="none"})
		local oUnit = oWorld:addunit(1,1)
		
		local vTalk = hApi.AnalyzeTalk(oUnit, oUnit, {flag, talkType,}, {id = {townTypeId,townTypeId},})
		--print("vTalk", vTalk)
		if vTalk then
			oWorld:del()
			oUnit:del()
			hApi.CreateUnitTalk(vTalk,function()
				if _func and type(_func) == "function" then
					_func(unpack(arg))
				end
			end)
		else
			if _func and type(_func) == "function" then
				_func(unpack(arg))
			end
		end
	end
	
	--显示对话框：引导点击剧情战役按钮
	function __Dialogue_GuideMap_ClickJuQingBtn()
		print("显示对话框：引导点击剧情战役按钮")
		__createMapTalk("step1", "$MAP_GUIDE_001", OnClickGuideMainMapFrame_Event, 0, 0)
	end
	
	--显示对话框：引导点击第一关按钮
	function __Dialogue_GuideMap_ClickMap01()
		print("显示对话框：引导点击第一关按钮")
		if (hVar.SYS_IS_NEWTD_APP == 1) then --新塔防app程序
			__createMapTalk("step2", "$MAP_GUIDE_005", OnClickGuideMainMapFrame_Event, 0, 0)
		else
			__createMapTalk("step2", "$MAP_GUIDE_002", OnClickGuideMainMapFrame_Event, 0, 0)
		end
	end
	
	--显示对话框：介绍三星奖励信息
	function __Dialogue_GuideMap_IntroduceStar()
		print("显示对话框：介绍三星奖励信息")
		__createMapTalk("step3", "$MAP_GUIDE_003", OnClickGuideMainMapFrame_Event, 0, 0)
	end
	
	--显示对话框：提示进入战役
	function __Dialogue_GuideMap_ClickBattle()
		print("显示对话框：提示进入战役")
		__createMapTalk("step4", "$MAP_GUIDE_004", OnClickGuideMainMapFrame_Event, 0, 0)
	end
	
	--开始引导第一次进入游戏
	BeginGuideMapMain()
end

--test
--测试第一次进入游戏引导
--CreateGuideFrame_MapMain()
