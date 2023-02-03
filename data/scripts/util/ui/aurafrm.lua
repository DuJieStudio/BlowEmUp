
local GetListWithOutList = function(tList1,tList2)
	local tListNew = {}
	local t = {}
	if type(tList2) == "table" then
		for i = 1,#tList2 do
			local id = tList2[i][1]
			t[id] = 1
		end
	end
	for i = 1,#tList1 do
		local id = tList1[i][1]
		if id and t[id] ~= 1 then
			tListNew[#tListNew + 1] = hApi.ReadParamWithDepth(tList1[i],nil,{},3)
		end
	end
	return tListNew
end
--随机出卡牌组
hVar.GetRandAuraList = function(nGroupID)
	--print("nGroupID=", nGroupID)
	local tList = {}
	local tGroup = hVar.AuraRandGroupDefine[nGroupID]
	if type(tGroup) == "table" then
		--先按照权重决定池子
		local tWeights = {}
		for i = 1,#tGroup do
			tWeights[#tWeights + 1] = tGroup[i].weights + (tWeights[#tWeights] or 0)
		end
		local weightrand = hApi.random(1,tWeights[#tWeights])
		local poolIndex = 0
		for i = 1,#tWeights do
			poolIndex = i
			if weightrand <= tWeights[i] then
				break
			end
		end
		local tPool = tGroup[poolIndex]
		--print("poolIndex",poolIndex)
		if type(tPool) == "table" then
			local pool = tPool.pool or {}
			local norepeat = tPool.norepeat or 0
			for i = 1,#pool do
				local index,num = unpack(pool[i])
				local info = hVar.AuraPoolDefine[index]
				if info then
					local infonew
					if norepeat == 1 then
						infonew = GetListWithOutList(info,tList)
					else
						infonew = GetListWithOutList(info,nil)
					end
					local tIndex = hApi.randomEx(nil,1,#infonew,num)
					for j = 1,#tIndex do
						local t = infonew[tIndex[j]]
						local id = t[1]
						local lv = 1
						if type(t[2]) == "table" then
							lv = hApi.random(t[2][1],t[2][2] or t[2][1])
						elseif type(t[2]) == "number" then
							lv = t[2]
						end
						tList[#tList + 1] = {id, lv,}
						--print(id,lv)
					end
				end
			end
		end
	end
	--table_print(tList)
	return tList
end

--四选一界面
hGlobal.UI.InitSelectAuraFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowSelectAuraFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	--local _boardW,_boardH = 540,540
	local _boardW,_boardH = 620,660
	local _chooseWH = 200

	local _frm,_parent,_childUI = nil,nil,nil
	local _tCallback = nil
	local _tList = {}
	local _nShowNum = 4
	local _nCurrentSelect = 0
	local _nIsShow = 0
	local _nMoveW = 600
	local _nIndex = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateInfo = hApi.DoNothing
	local _CODE_SelectChoose = hApi.DoNothing
	local _CODE_ClickSelect = hApi.DoNothing
	local _CODE_MoveFrmAction = hApi.DoNothing
	
	_CODE_ClickSelect = function()
		local info = _tList[_nCurrentSelect]
		if info then
			local aura_id,lv = unpack(info)
			local tabA = hVar.tab_aura[aura_id]
			if tabA then
				local skill_id = tabA.skill
				local requireGold = tabA.crystal or 0
				print(_nCurrentSelect,skill_id,lv,requireGold)
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					local me = world:GetPlayerMe()
					if me then
						local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
						if (goldNow >= requireGold) then
							local heros = me.heros
							local oHero = heros[1]
							if oHero then
								local oUnit = oHero:getunit()
								if oUnit then
									if (oUnit.data.IsDead ~= 1) then --活着的单位
										--扣除金币
										me:addresource(hVar.RESOURCE_TYPE.GOLD, -requireGold)
										--本地刷新界面
										hGlobal.event:event("Event_TacticCastCostRefresh")
										
										local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
										local gridX, gridY = world:xy2grid(targetX, targetY)
										local tCastParam =
										{
											level = lv, --等级
										}
										hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
										
										--统计雕像buff
										local tInfo = GameManager.GetGameInfo("auraInfo")
										
										print("@@@@@@@@ 统计雕像buff", _nIndex, "id=", aura_id, "lv=", lv)
										
										--存储
										--local tData = {_nIndex, {id = aura_id, lv = lv,}}
										--GameManager.SetGameInfo("auraInfo", {tData,})
										
										local tData = {id = aura_id, lv = lv}
										--table_print(tData)
										GameManager.AddGameInfo("auraInfo",tData) 
										hGlobal.event:event("LocalEvent_RefreshTacticsBuffIcon")
										
										return true
									end
								end
							end
						else --金币不足
							--[[
							local strText = hVar.tab_string["__TEXT_NoPlayerDisabelEnter"] --language
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							]]
							hApi.NotEnoughResource("coin")
							
							return false
						end
					end
				end
			end
		end
	end
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.SelectAuraFrm then
			hGlobal.UI.SelectAuraFrm:del()
			hGlobal.UI.SelectAuraFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tList = {}
		_nCurrentSelect = 0
		_nIsShow = 0
		_nIndex = 0
		_tCallback = nil
		g_DisableShowOption = 0
	end
	
	_CODE_SelectChoose = function(index)
		if _nCurrentSelect ~= index then
			_nCurrentSelect = index
		else
			_nCurrentSelect = 0
		end
		
		for i = 1,_nShowNum do
			local btnChildUI = _childUI["btn_choose"..i].childUI
			if _nCurrentSelect == i then
				btnChildUI["img_choose"].handle._n:setVisible(true)
				btnChildUI["img_bar"].handle._n:setVisible(true)
			else
				btnChildUI["img_choose"].handle._n:setVisible(false)
				btnChildUI["img_bar"].handle._n:setVisible(false)
			end
		end
		
		if _nCurrentSelect == 0 then
			hApi.AddShader(_childUI["btn_select"].handle.s, "gray")
		else
			hApi.AddShader(_childUI["btn_select"].handle.s, "normal")
		end
	end
	
	_CODE_MoveFrmAction = function(nMoveX,nDeltyTime)
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	_CODE_CreateInfo = function()
		local offX = hVar.SCREEN.w - _boardW/2 - 20
		local offY = -hVar.SCREEN.h/2
		--local offw = (_boardW - _chooseWH * _nShowNum)/(_nShowNum + 1)
		
		for i = 1,_nShowNum do
			local info = _tList[i]
			if info then
				local auraid,lv = unpack(info)
				local requireGold = hVar.tab_aura[auraid].crystal or 0
				_childUI["btn_choose"..i] = hUI.button:new({
					parent = _parent,
					model = "misc/mask.png",
					--model = "",
					dragbox = _childUI["dragBox"],
					w = _boardW ,
					h = 100,
					--x = offX - _boardW/2 + offw/2 + (_chooseWH + offw)*(i-0.5),
					x = offX,
					--y = offY + 40,
					y = offY + _boardH/2 - 128 - 122 * (i-1)- 1.0,
					code = function()
						_CODE_SelectChoose(i)
					end,
				})
				_childUI["btn_choose"..i].handle.s:setOpacity(0) --只挂载子控件，不显示
				
				local model = ""
				local tabA = hVar.tab_aura[auraid]
				if tabA then
					model = tabA.showmodel
				end

				local btnChildUI = _childUI["btn_choose"..i].childUI
				local btnParent = _childUI["btn_choose"..i].handle._n
				
				--图标
				btnChildUI["img_aura"] = hUI.image:new({
					parent = btnParent,
					model = model,
					x = -150,
					y = 0- 1.0,
					scale = 1.5,
				})
				
				--需要的金币
				if (requireGold > 0) then
					--金币图标
					btnChildUI["img_gold"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/mu_coin.png",
						x = 90,
						y = -2,
						scale = 1.0,
					})
					
					--金币数值
					btnChildUI["label_gold"] = hUI.label:new({
						parent = btnParent,
						font = "numBlue",
						x = 130,
						y = -2,
						align = "LC",
						size = 28,
						--text = "- " .. tostring(requireGold),
						text = tostring(requireGold),
						border = 0,
					})
				else
					
					--[[
					btnChildUI["lab_lv"] = hUI.label:new({
						parent = btnParent,
						text = "level "..lv,
						align = "LC",
						size = 26,
						x = -40,
						y = 36,
						font = hVar.FONTC,
					})
					--]]
					
					local labx = 0
					local sicon = tabA.showicon
					if sicon then
						btnChildUI["lab_icon"] = hUI.image:new({
							parent = btnParent,
							model = sicon,
							x = 40,
							y = 3,
						})
						labx = 80
					end
					
					local sinfo = ""
					if hVar.tab_stringA[auraid] then
						sinfo = hVar.tab_stringA[auraid][lv+1]
					end
					if sinfo == nil or sinfo == "" then
						sinfo = "Aura"..tostring(auraid).." lv"..tostring(lv)
					end
					
					btnChildUI["lab_info"] = hUI.label:new({
						parent = btnParent,
						text = sinfo,
						align = "LC",
						size = 26,
						x = labx,
						y = 3,
						font = hVar.FONTC,
					})
				end
				
				--选中框
				btnChildUI["img_bar"] = hUI.image:new({
					parent = btnParent,
					model = "misc/gopherboom/bar.png",
					x = 0,
					y = 0- 1.0,
					z = -2,
					w = 560,
					h = 110,
				})
				btnChildUI["img_bar"].handle._n:setVisible(false)
				
				--勾勾
				btnChildUI["img_choose"] = hUI.image:new({
					parent = btnParent,
					model = "misc/gopherboom/gou.png",
					x = - 112,
					y = - 24- 1.0,
				})
				btnChildUI["img_choose"].handle._n:setVisible(false)
			end
		end
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.SelectAuraFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			buttononly = 1,
		})
		_frm = hGlobal.UI.SelectAuraFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - _boardW/2 - 20
		local offY = -hVar.SCREEN.h/2
		
		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/addition/construction_panel.png", --"misc/skillup/msgbox4.png",
			--dragbox = _childUI["dragBox"],
			x = offX,
			y = offY + 36,
			w = _boardW,
			h = _boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--[[
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _boardW/2 - 38,
			y = offY + _boardH/2 - 38,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_ClearFunc()
			end,
		})
		--]]
		
		--创建挡操作的界面
		_childUI["btn_disableop"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			--model = "",
			dragbox = _childUI["dragBox"],
			x = 0,
			y = 0,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				print("XXXXXX")
			end,
		})
		_childUI["btn_disableop"].handle.s:setOpacity(0) --不显示
		
		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			--text = "select one",
			align = "MC",
			size = 32,
			x = offX,
			y = offY + _boardH/2 - 50,
		})
		
		--关闭按钮
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _boardW / 2 - 34,
			y = offY + _boardH / 2 - 34,
			scaleT = 0.95,
			code = function()
				--print(_tCallback)
				if type(_tCallback) == "table" then
					--print(_tCallback[1], _tCallback[2])
					hGlobal.event:event("LocalEvent_CloseAuraBack", _tCallback[2])
				end
				
				_CODE_ClearFunc()
			end,
		})
		
		_childUI["btn_select"] = hUI.button:new({
			parent = _parent,
			--model = "misc/addition/cg.png",
			model = "misc/addition/c_hammer.png",
			dragbox = _childUI["dragBox"],
			--label = {text = "选择", size = 28, font = hVar.FONTC, x = 0, y = 4, border = 1,},
			scaleT = 0.95,
			x = offX + 230,
			y = offY - _boardH/2 + 84 - 6,
			z = 1,
			--scale = 0.76,
			scale = 1.0,
			code = function()
				if (_nCurrentSelect > 0) then
					local ret = _CODE_ClickSelect()
					if ret then
						if type(_tCallback) == "table" then
							hGlobal.event:event(_tCallback[1],_tCallback[2])
						end
						_CODE_ClearFunc()
					end
				end
			end,
		})
		hApi.AddShader(_childUI["btn_select"].handle.s, "gray")
		
		_CODE_CreateInfo()
		
		_frm:setXY(_frm.data.x + _nMoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		
		_CODE_MoveFrmAction(-_nMoveW,0.5)
	end

	hGlobal.event:listen("LocalEvent_CloseSelectAuraFrm","closefrm",function(index)
		if _nIndex == index then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","ShowSelectAuraFrm",function()
		if _frm and _frm.data.show == 1 then
			local index = _nIndex
			local list = _tList
			local tCallback = _tCallback
			_CODE_ClearFunc()
			hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,list,tCallback)
		end
	end)
	
	--"LocalEvent_ShowSelectAuraFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(index,list,tCallback)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _nIsShow == 0 and oWorld and oWorld.data.map ~= hVar.LoginMap then
			_CODE_ClearFunc()
			g_DisableShowOption = 1
			_nIsShow = 1
			_nIndex = index
			_tCallback = tCallback
			_tList = list
			_CODE_CreateFrm()
		end
	end)
end
--[[
--测试 --test
if hGlobal.UI.SelectAuraFrm then
	hGlobal.UI.SelectAuraFrm:del()
	hGlobal.UI.SelectAuraFrm = nil
end
hGlobal.UI.InitSelectAuraFrm("include")

local heros = world:GetPlayerMe().heros
local oHero = heros[1]
local oUnit = oHero:getunit()
local mapInfo = world.data.tdMapInfo
local index = 17205
local tInfo = mapInfo.eventUnit[index] or {}
world:pause(1, "TD_PAUSE")
mapInfo.mapLastState = mapInfo.mapState
mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
if type(tInfo.list) ~= "table" then
	local id = 17205 --oUnit.data.id
	local groupindex = hVar.UnitAuraGroupDefine[id] or 1
	tInfo.list = hVar.GetRandAuraList(groupindex)
end
local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit}}
hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
]]



--创建选择宠物界面
hGlobal.UI.InitSelectPetFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowSelectPetFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _boardW,_boardH = 540,540
	local _chooseWH = 200

	local _frm,_parent,_childUI = nil,nil,nil
	local _tCallback = nil
	local _nPetUnitId = 0
	local _nCostScore = 0
	local _nIsShow = 0
	local _nMoveW = 600
	local _nIndex = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	--local _CODE_CreateInfo = hApi.DoNothing
	local _CODE_SelectChoose = hApi.DoNothing
	local _CODE_ClickSelect = hApi.DoNothing
	local _CODE_MoveFrmAction = hApi.DoNothing
	
	--选择宠物
	_CODE_ClickSelect = function()
		local ret = false
		
		--local nCurScore = LuaGetPlayerScore()
		--[[
		local nCurScore = 0
		local score = GameManager.GetGameInfo("scoreingame")
		if type(score) == "number" then
			nCurScore = score
		end
		]]
		--geyachao:改为金币
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			local me = world:GetPlayerMe()
			if me then
				local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
				
				--if (nCurScore >= _nCostScore) then
				if (goldNow >= _nCostScore) then
					--[[
					--扣除积分
					--LuaAddPlayerScoreByWay(-_nCostScore,hVar.GET_SCORE_WAY.BUYPETFOLLOW)
					GameManager.AddGameInfo("scoreingame", -_nCostScore)
					hGlobal.event:event("LocalEvent_RefreshCurGameScore")
					]]
					--geyachao:改为金币
					--扣除金币
					me:addresource(hVar.RESOURCE_TYPE.GOLD, -_nCostScore)
					--本地刷新界面
					hGlobal.event:event("Event_TacticCastCostRefresh")
					
					--添加宠物
					local heros = me.heros
					local oHero = heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							if (oUnit.data.IsDead ~= 1) then --活着的单位
								local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
								--local gridX, gridY = world:xy2grid(targetX, targetY)
								
								--添加宠物
								local radius = 80
								local angle = world:random(0, 360) --随机角度
								local r = world:random(30, radius) --随机偏移半径
								local fangle = angle * math.pi / 180 --弧度制
								local dx = r * math.cos(fangle) --随机偏移值x
								local dy = r * math.sin(fangle) --随机偏移值y
								local randPosX = targetX + dx --随机x位置
								local randPosY = targetY + dy --随机y位置
								randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
								local unitForce = oUnit:getowner():getpos()
								local unitLv = 1
								local unitStar = 1
								local cha = world:addunit(_nPetUnitId, unitForce, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
								--print("SummonUnit_Point:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
								if cha then
									--设置目标AI状态
									--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
									
									--geyachao: 标记该单位是召唤单位
									cha.data.is_summon = 1
									
									hGlobal.event:call("Event_UnitBorn", cha)
									
									--是否为rpgunits
									world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
								end
							end
						end
					end
				else
					--积分不足
					hApi.NotEnoughResource("coin")
				end
				
				--返回成功
				ret = true
			else
				--积分不足
				hApi.NotEnoughResource("coin")
			end
		end
		
		return ret
	end
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.SelectPetFrm then
			hGlobal.UI.SelectPetFrm:del()
			hGlobal.UI.SelectPetFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tList = {}
		_nCurrentSelect = 0
		_nIsShow = 0
		_nIndex = 0
		_tCallback = nil
		g_DisableShowOption = 0
	end

	_CODE_SelectChoose = function(index)
		if _nCurrentSelect ~= index then
			_nCurrentSelect = index
		else
			_nCurrentSelect = 0
		end

		for i = 1,_nShowNum do
			local btnChildUI = _childUI["btn_choose"..i].childUI
			if _nCurrentSelect == i then
				btnChildUI["img_choose"].handle._n:setVisible(true)
				btnChildUI["img_bar"].handle._n:setVisible(true)
			else
				btnChildUI["img_choose"].handle._n:setVisible(false)
				btnChildUI["img_bar"].handle._n:setVisible(false)
			end
		end

		if _nCurrentSelect == 0 then
			hApi.AddShader(_childUI["btn_select"].handle.s, "gray")
		else
			hApi.AddShader(_childUI["btn_select"].handle.s, "normal")
		end
	end

	_CODE_MoveFrmAction = function(nMoveX,nDeltyTime)
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	--创建选择宠物对话框界面
	_CODE_CreateFrm = function()
		hGlobal.UI.SelectPetFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			buttononly = 1,
		})
		_frm = hGlobal.UI.SelectPetFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - _boardW/2 - 20
		local offY = -hVar.SCREEN.h/2
		
		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			--dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = _boardW,
			h = _boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--[[
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _boardW/2 - 38,
			y = offY + _boardH/2 - 38,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_ClearFunc()
			end,
		})
		--]]
		
		--创建挡操作的界面
		_childUI["btn_disableop"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			--model = "",
			dragbox = _childUI["dragBox"],
			x = 0,
			y = 0,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				print("XXXXXX PET XXXXXX")
			end,
		})
		_childUI["btn_disableop"].handle.s:setOpacity(0) --不显示
		
		--标题
		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			text = string.format(hVar.tab_string["__TEXT_BUY_PET_HINT"], _nCostScore) , --"收取" .. _nCostScore .. "矿石，获得帮手"
			align = "MC",
			size = 28,
			x = offX,
			y = offY + _boardH/2 - 150,
		})
		
		--宠物模型
		_childUI["img_pet_model"] = hUI.image:new({
			parent = _parent,
			model = hVar.tab_unit[_nPetUnitId].model,
			scale = 1.0,
			x = offX,
			y = offY + _boardH/2 - 300,
		})
		
		--关闭按钮
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _boardW / 2 - 34,
			y = offY + _boardH / 2 - 34,
			scaleT = 0.95,
			code = function()
				--print(_tCallback)
				if type(_tCallback) == "table" then
					--print("取消", _tCallback[1], _tCallback[2])
					hGlobal.event:event("LocalEvent_ClosePetBack", _tCallback[2])
				end
				
				_CODE_ClearFunc()
			end,
		})
		
		--确定按钮
		_childUI["btn_select"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["confirm"], size = 28, font = hVar.FONTC, x = 0, y = 4, border = 1,}, --"确认"
			scaleT = 0.95,
			x = offX + 6 + 110,
			y = offY - _boardH/2 + 84,
			z = 1,
			scale = 0.76,
			code = function()
				if _CODE_ClickSelect() then
					if type(_tCallback) == "table" then
						hGlobal.event:event(_tCallback[1],_tCallback[2])
					end
					
					_CODE_ClearFunc()
				end
			end,
		})
		--当前此英雄升星需要的游戏币文字前缀
		_childUI["btn_select"].childUI["heroStarUpRmbPrefix"] = hUI.label:new({
			parent = _childUI["btn_select"].handle._n,
			size = 22,
			align = "RC",
			--border = 1,
			x = -36,
			y = 50,
			font = hVar.FONTC,
			width = 300,
			--text = "消耗", --language
			text = hVar.tab_string["__TEXT_CONSUME"], --language
			border = 1,
		})
		_childUI["btn_select"].childUI["heroStarUpRmbPrefix"].handle.s:setColor(ccc3(255, 236, 0))
		
		--当前此英雄升星需要的游戏币图标
		_childUI["btn_select"].childUI["heroStarUpRmbIcon"] = hUI.image:new({
			parent = _childUI["btn_select"].handle._n,
			model = "misc/skillup/mu_coin.png",
			x = 0,
			y = 50,
			w = 32,
			h = 32,
		})
		
		--当前此英雄升星需要的游戏币值
		_childUI["btn_select"].childUI["heroStarUpRmbValue"] = hUI.label:new({
			parent = _childUI["btn_select"].handle._n,
			size = 20,
			align = "LC",
			--border = 1,
			x = 24,
			y = 50 - 1,
			font = "num",
			width = 300,
			text = _nCostScore,
		})
		--_childUI["btn_select"].childUI["heroStarUpRmbValue"].handle.s:setColor(ccc3(255, 236, 0))
		
		--水晶不足，按钮不能点击
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
		if (goldNow < _nCostScore) then
			_childUI["btn_select"]:setstate(0)
		end
		
		--取消按钮
		_childUI["btn_cancel"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_TEMPORARY_NO"], size = 26, font = hVar.FONTC, x = 0, y = 4, border = 1,}, --"暂时不用"
			scaleT = 0.95,
			x = offX + 6 - 110,
			y = offY - _boardH/2 + 84,
			z = 1,
			scale = 0.76,
			code = function()
				if type(_tCallback) == "table" then
					--print("取消按钮", _tCallback[1], _tCallback[2])
					hGlobal.event:event("LocalEvent_ClosePetBack", _tCallback[2])
				end
				
				_CODE_ClearFunc()
			end,
		})
		
		--_CODE_CreateInfo()
		
		_frm:setXY(_frm.data.x + _nMoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		
		_CODE_MoveFrmAction(-_nMoveW,0.5)
	end

	hGlobal.event:listen("LocalEvent_CloseSelectPetFrm","closefrm",function(index)
		if _nIndex == index then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","ShowSelectPetFrm",function()
		if _frm and _frm.data.show == 1 then
			local index = _nIndex
			local petUnitId = _nPetUnitId
			local costScore = _nCostScore
			local tCallback = _tCallback
			_CODE_ClearFunc()
			hGlobal.event:event("LocalEvent_ShowSelectPetFrm", index, petUnitId, costScore, tCallback)
		end
	end)
	
	--"LocalEvent_ShowSelectPetFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(index, petUnitId, costScore, tCallback)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _nIsShow == 0 and oWorld and oWorld.data.map ~= hVar.LoginMap then
			_CODE_ClearFunc()
			g_DisableShowOption = 1
			_nIsShow = 1
			_nIndex = index
			_tCallback = tCallback
			_nPetUnitId = petUnitId
			_nCostScore = costScore
			_CODE_CreateFrm()
		end
	end)
end
--[[
--测试 --test
--删除上一次的
if hGlobal.UI.SelectPetFrm then
	hGlobal.UI.SelectPetFrm:del()
	hGlobal.UI.SelectPetFrm = nil
end
hGlobal.UI.InitSelectPetFrm("include")
hGlobal.event:event("LocalEvent_ShowSelectPetFrm", 1, 12217, 500)
]]


