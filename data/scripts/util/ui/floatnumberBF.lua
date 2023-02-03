hGlobal.UI.InitFloadNumberBF = function()
	local FloatNumberTemp = {}
	--只有查看战场的时候才会有这个变量
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__BF__ClearFloatNumberTemp",function(sSceneType,oWorld,oMap)
		if sSceneType=="battlefield" then
			FloatNumberTemp = {}
		else
			FloatNumberTemp = nil
		end
	end)

	local _FN_NumSize = 12
	local _FN_TextSize = 18
	local _FN_DmgNumSize = 14
	if g_phone_mode~=0 then
		_FN_NumSize = 16
		_FN_TextSize = 20
		_FN_DmgNumSize = 16
	end
	local __ShowFloatNumber = hApi.DoNothing
	local PercentAttr = {
		hpSteal = 1,
		power = 1,
		counterpower = 1,
		healpower = 1,
		castpower = 1,
		eliteDef = 1,
		meleeDef = 1,
		rangeDef = 1,
	}
	local NotShowAttr = {
		attackHeal = 1,
		fearful = 1,
	}
	--改变属性时显示头顶漂浮文字
	hGlobal.event:listen("LocalEvent_UnitAddAttrByAction","__BF__ShowAttrValue",function(oAction,oUnit,sAttr,nVal,sVal,sIcon,tPos)
		if FloatNumberTemp==nil then
			return
		end
		if nVal==0 then
			return
		end
		if NotShowAttr[sAttr]==1 then
			return
		end
		local d = oAction.data
		if type(sIcon)~="string" then
			sIcon = 0
		end
		if type(tPos)~="table" then
			tPos = 0
		end
		--单位死亡，或buff消失时不显示漂浮文字
		--buff覆盖时也不显示漂浮文字
		if d.IsBuff~=-1 and d.replaceTick~=hApi.gametime() then
			local tTab = FloatNumberTemp[oUnit.ID]
			if not(type(tTab)=="table" and tTab.__ID==oUnit.__ID) then
				tTab = {__ID=oUnit.__ID,tick=0}
				FloatNumberTemp[oUnit.ID] = tTab
			end
			if type(nVal)=="number" then
				if sVal and type(sVal)=="string" then
					--如果指定了显示特殊的数字
					local sAttrName = rawget(hVar.tab_string,"__ATTR__"..sAttr) or sAttr
					if nVal>0 then
						if sAttr=="mp" then
							tTab[#tTab+1] = {"numBlue","+"..sVal,tostring(sAttrName),sIcon,tPos}
						else
							tTab[#tTab+1] = {"numGreen","+"..sVal,tostring(sAttrName),sIcon,tPos}
						end
					else
						tTab[#tTab+1] = {"numRed",sVal,tostring(sAttrName),sIcon,tPos}
					end
				else
					local sHint
					local sAttrName
					--一般的数值显示
					if sAttr=="counter" then
						--超过+/-30次的反击次数不显示
						if nVal>30 then
							sHint = hVar.tab_string["__SUPER_COUNTER__"]
						elseif nVal<-30 then
							return
						end
					elseif sAttr=="cooldown" then
						--冷却时间，使用icon把！
						sAttrName = hVar.tab_string["__Attr_cooldown"]
					elseif sAttr=="duration" then
						--持续时间，使用icon把！
						sAttrName = hVar.tab_string["__Attr_duration"]
					end
					if sHint~=nil then
						tTab[#tTab+1] = {0,"",sHint,sIcon,tPos}
					else
						if sAttrName==nil then
							sAttrName = rawget(hVar.tab_string,"__ATTR__"..sAttr) or sAttr
						end
						local nValT = ""
						if PercentAttr[sAttr]==1 then
							nValT = "%"
						end
						if nVal>0 then
							if sAttr=="mp" then
								tTab[#tTab+1] = {"numBlue","+"..nVal,tostring(sAttrName),sIcon,tPos}
							else
								tTab[#tTab+1] = {"numGreen","+"..nVal..nValT,tostring(sAttrName),sIcon,tPos}
							end
						else
							tTab[#tTab+1] = {"numRed",tostring(nVal)..nValT,tostring(sAttrName),sIcon,tPos}
						end
					end
				end
			else
				--自定义属性显示
				local sAttrName = rawget(hVar.tab_string,sAttr) or sAttr
				tTab[#tTab+1] = {0,"",tostring(sAttrName),sIcon,tPos}
			end
			local tick = hApi.gametime()
			if tTab.tick<=tick then
				__ShowFloatNumber(oUnit,tTab,tick)
			end
		end
	end)
	
	__ShowFloatNumber = function(oUnit,tTab,curTick)
		if #tTab>0 then
			local curI
			for i = 1,#tTab do
				local v = tTab[i]
				if v~=0 then
					tTab[i] = 0
					curI = i
					tTab.tick = curTick + 300
					if oUnit.handle._n then
						local sIcon
						if v[4]~=0 then
							sIcon = v[4]
						end
						local parent = oUnit.handle._n
						local x,y = 0,0
						if v[5]~=0 then
							local oWorld = oUnit:getworld()
							if oWorld then
								parent = oWorld.handle.worldLayer
								x = v[5][1]
								y = -1*v[5][2]
							end
						end
						if v[1]==0 then
							hUI.floatNumber:new({
								parent = parent,
								font = "numWhite",
								text = v[2],
								textII = {v[3],hVar.FONTC,_FN_TextSize,"MC",0,2,{0,255,0}},
								size = _FN_NumSize,
								x = x,
								y = y+64,
								align = "LC",
								moveY = 32,
								lifetime = 1000,
								fadeout = -330,
								icon = sIcon,
								iconWH = 24,
								iconX = 6,
								iconY = 4,
							})
						else
							hUI.floatNumber:new({
								parent = parent,
								font = v[1],
								text = v[2],
								textII = {v[3],hVar.FONTC,_FN_TextSize,"RC",-1*(_FN_NumSize+8),2,{0,255,0}},
								size = _FN_NumSize,
								x = x+string.len(v[3])*4-16,
								y = y+64,
								align = "LC",
								moveY = 32,
								lifetime = 1000,
								fadeout = -330,
								icon = sIcon,
								iconWH = 24,
								iconX = 6,
								iconY = 4,
							})
						end
					end
					break
				end
			end
			if curI==#tTab then
				for i = #tTab,1,-1 do
					tTab[i] = nil
				end
			end
			return 1
		else
			return 0
		end
	end

	hApi.addTimerForever("__BF__FloatNumberOnCha",hVar.TIMER_MODE.GAMETIME,1,function(tick)
		if FloatNumberTemp~=nil and type(FloatNumberTemp)=="table" then
			for uID,tTab in pairs(FloatNumberTemp)do
				local u = hClass.unit:find(uID)
				if u and u.__ID==tTab.__ID then
					if tTab.tick<=tick then
						if __ShowFloatNumber(u,tTab,tick)==0 then
							FloatNumberTemp[uID] = nil
						end
					end
				else
					FloatNumberTemp[uID] = nil
				end
			end
		end
	end,1)
	
	hGlobal.event:listen("Event_BattlefieldRoundStart","__BF__ShowRoundCount",function(oWorld,oRound)
		if oWorld.data.IsQuickBattlefield~=1 then
			hUI.floatNumber:new({
				x = hVar.SCREEN.w/2+64,
				y = hVar.SCREEN.h/2+64,
				lifetime = 1500,
			}):addtext(hVar.tab_string["__TEXT_Round"]..oWorld.data.roundcount,hVar.FONTC,48,"RC",0,0):runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1),CCFadeOut:create(0.5)))
		end
	end)
	
	local _code_ShowDmgNumber = function(x,y,oUnit,nSkillId,nDmgMode,nDmg,nLost,sDmg,sDmgFont, floatScale, nTime, nHeight)
		--geyachao: 修正报错
		if (not oUnit) then
			return
		end
		
		--黄色特殊处理
		local bSetColor = false --是否充重置颜色
		if (sDmgFont == "numYellow") then
			sDmgFont = "numWhite"
			bSetColor = true
		end
		
		nHeight = nHeight or 10 --geyachao:改值 10
		local moveY = nHeight
		local jumpH = 2 --geyachao:改值 10
		local floatMode = "boom"
		floatScale = floatScale or 1.3
		nTime = nTime or 1100
		
		local floatSize = _FN_DmgNumSize
		local ctrl = nil
		if type(nDmg) == "number" and nDmg<=0 and nLost<=0 then
			ctrl = hUI.floatNumber:new({
				unit = oUnit,
				font = sDmgFont,
				mode = floatMode,
				scale = floatScale,
				size = floatSize,
				text = sDmg,
				RGB = {255,0,255},
				lifetime = nTime, --geyachao:改值 1500
				fadeout = -500,
				x = x,
				y = 75 + y, --geyachao:改值 32+y
				moveY = moveY,
				jumpH = jumpH,
			})
		elseif oUnit:gethero()~=nil then
			ctrl = hUI.floatNumber:new({
				unit = oUnit,
				font = sDmgFont,
				mode = floatMode,
				scale = floatScale,
				size = floatSize,
				text = sDmg,
				lifetime = nTime, --geyachao:改值 1500
				fadeout = -500,
				x = x,
				y = 75 + y, --geyachao:改值 32+y
				moveY = moveY,
				jumpH = jumpH,
			})
		else
			if nLost>0 then
				--[=[
				--geyachao
				hUI.floatNumber:new({
					unit = oUnit,
					font = "numWhite",
					size = floatSize,
					text = "-"..tostring(nLost),
					lifetime = nTime, --geyachao:改值 1500
					fadeout = -500,
					x = 10+x,
					y = 75 + y, --geyachao:改值 32+y
					icon = "ICON:icon01_x3y5",
					iconScale = 0.4,
					moveY = 96,
					--jumpH = 10,
				})
				]=]
			end
			ctrl = hUI.floatNumber:new({
				unit = oUnit,
				font = sDmgFont,
				mode = floatMode,
				scale = floatScale,
				size = floatSize,
				text = sDmg,
				lifetime = nTime, --geyachao:改值 1500
				fadeout = -500,
				x = x,
				y = 75 + y, --geyachao:改值 32+y
				moveY = moveY,
				jumpH = jumpH,
			})
		end
		
		--设置特殊的颜色
		if ctrl then
			if bSetColor then
				ctrl.handle.s:setColor(ccc3(255, 255, 0))
			end
		end
		
		--[[
		--geyachao: 注释掉
		if nLost~=0 and oUnit.chaUI["number"] then
			oUnit.chaUI["number"]:setText(tostring(oUnit.attr.stack))
		end
		if oUnit.chaUI["hp"] then
			oUnit.chaUI["hp"]:setV(oUnit.attr.hp,oUnit.attr.mxhp)
		end
		if oUnit.attr.stack<=0 then
			hApi.safeRemoveT(oUnit.chaUI,"hp") 
			hApi.safeRemoveT(oUnit.chaUI,"number")
		end
		]]
	end
	
	--geyachao: 显示冒字
	hApi.ShowDmgNumber = _code_ShowDmgNumber
	
	--数字显伤害显示
	local lastHitTime = 0
	hGlobal.event:listen("Event_UnitDamaged","__BF__ShowChaDamaged",function(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
		--geyachao: 当创建太多数量的碎片特效时，程序会crash（200个特效？），目前的解决办法是，1帧只能创建1个碎片特效
		local w = oUnit:getworld()
		local currenttime = w:gametime()
		if (lastHitTime == currenttime) then
			return
		end
		
		lastHitTime = currenttime
		
		--geyachao:不要物理特效
		if (hVar.IS_SHOW_HIT_EFFECT_FLAG == 1) then --开关控制
			if oUnit and oAttacker then
				if oUnit.attr.armor then
					--local w = oUnit:getworld()
					--播放物理特效
					--
					local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --我方小兵的坐标
					local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --我方小兵的包围盒
					local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --我方小兵的中心点x位置
					local hero_center_y = hero_y + (hero_by + hero_bh / 2) --我方小兵的中心点y位置
					local tx, ty = hero_center_x, hero_center_y
					
					--local ox,oy = oAttacker:getXY()
					local ox, oy = 0, 0
					local ax, ay = hApi.chaGetPos(oAttacker.handle)
					if (tx <= ax) then
						-- -100, 100 右上
						-- +100, 100 左上
						ox = tx + 100
						oy = ty + 100
					else
						ox = tx - 100
						oy = ty + 100
					end
					
					local t = (w:random(8, 15) / 10)
					local armor_lasttime = oUnit.attr.armor_lasttime
					--local currenttime = w:gametime()
					local deltatime = currenttime - armor_lasttime
					if (deltatime > 500) then
						
						--geyachao: 查bug临时去掉，待恢复
						if (oUnit.attr.armor == hVar.ARMOR_TYPE.ARMOR) then
							xlAddPhyBrokenEffect(w.handle.worldScene,"hit_armor","armor", tx, ty, ox, oy, t) --1.5 --geyachao修改时间
							oUnit.attr.armor_lasttime = currenttime --标记时间
						elseif (oUnit.attr.armor == hVar.ARMOR_TYPE.BODY) then
							xlAddPhyBrokenEffect(w.handle.worldScene,"hit_body","body", tx, ty, ox, oy, t)
							oUnit.attr.armor_lasttime = currenttime --标记时间
						elseif (oUnit.attr.armor == hVar.ARMOR_TYPE.WALL) then
							xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx ,ty, ox, oy, t)
							oUnit.attr.armor_lasttime = currenttime --标记时间
						elseif (oUnit.attr.armor == hVar.ARMOR_TYPE.ARMOR2) then
							xlAddPhyBrokenEffect(w.handle.worldScene,"hit_armor2","armor2", tx ,ty, ox, oy, t)
							oUnit.attr.armor_lasttime = currenttime --标记时间
						end
						
					end
				end
			end
		end
		
		if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --显血模式
			--print(dd .. dd)
			local w = oUnit:getworld()
			--if w~=nil and w.data.type=="battlefield" and w.data.IsQuickBattlefield~=1 then --geyachao:注释掉
				
				local sDmg,sDmgFont
				if (type(nDmg) ~= "number") then --geyachao: 添加字符串处理
					sDmg = "!"
					sDmgFont = "numGreen"
				else
					if nDmg<=0 and nLost<=0 then
						sDmg = "0" --geyachao:不要感叹号
						sDmgFont = "numWhite"
					else
						sDmg = "-" .. tostring(nDmg) --geyachao: 加个减号
						sDmgFont = "numRed"
					end
				end
				if nAbsorb>0 then
					if nDmg>0 then
						_code_ShowDmgNumber(0,0,oUnit,nSkillId,nDmgMode,nDmg,0,tostring(nAbsorb),"numBlue")
						_code_ShowDmgNumber(0,24,oUnit,nSkillId,nDmgMode,nDmg,nLost,tostring(nDmg),"numRed")
					else
						_code_ShowDmgNumber(0,0,oUnit,nSkillId,nDmgMode,nDmg,0,tostring(nAbsorb),"numBlue")
					end
				else
					_code_ShowDmgNumber(0,0,oUnit,nSkillId,nDmgMode,nDmg,nLost,sDmg,sDmgFont)
				end
			--end
		end
	end)
	
	--敌方单位被击杀事件
	hGlobal.event:listen("Event_UnitDead_Bubble", "__UNIT_DEAD_BUBBLE_EVENT", function(oUnit, gold, bIsCritGold)
		local w = oUnit:getworld()
		
		--地图胜利/失败的状态下点不到这些按钮
		if w and oUnit then
			local mapInfo = w.data.tdMapInfo
			if mapInfo then
				if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then
					return
				end
				
				--敌方单位才显示
				local unitSide = oUnit:getowner()
				if (unitSide:getforce() ~= w:GetPlayerMe():getforce()) then
					if (gold > 0) then --击杀大于0才显示文字
						local bIsGoldUnit = (hVar.tab_unit[oUnit.data.id].tag and hVar.tab_unit[oUnit.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_GOLDUNIT])
						
						if bIsGoldUnit then --金钱怪
							hApi.ShowComboGoldBubble(oUnit, gold)
						else
							hApi.ShowGoldBubble(oUnit, gold, bIsCritGold)
						end
					end
				end
			end
		end
	end)
end