hGlobal.UI.InitContinuousKillingEffect = function()
	local floatnumberList = {}
	local _tCountUnitAward = {}
	--local _nLimitTimes = 30		--限制次数
	local _nlastTime = 0
	local _nlastShakeTime = 0
	local _nlastEffecttime = 0
	local _nDelayTime = 0.5
	local _bDelay = false
	local _CSYNode = nil
	local _nContinuedTime = 0.5	--连斩有效时间 单位为秒
	
	--不掉水晶
	local _tInvalidUnitList = {	--无效的单位列表
		[5108] = 1,
		[6000] = 1,
		[11209] = 1,
		[11214] = 1,
		[11360] = 1,
		[12216] = 1,
		[12218] = 1,
		[12801] = 1,
		[13011] = 1,
		[19016] = 1,
		[19023] = 1,
		[19026] = 1,
		[13005] = 1,
	}
	
	--限制单位列表 连斩数照算  单局可获得奖励个数受限
	local _tLimitUnitList = {
		[11202] = 30,	--【单位id】= 单局可获得奖励个数
	}
	local _tAwardList = {
		[2] = {13000,},
		[3] = {13001,},
		[4] = {13001,},
		[5] = {13002,},
		[6] = {13002,},
		[7] = {13003},
		[8] = {13003},
		[9] = {13004},
		[10] = {13003,13004},
	}
	--单位收益系数
	local _tUnitScoreModulus = {
		[11361] = 0.2,
	}
	local _tContinuousKillingList = {}				--记录上一次击杀单位ID 时间
	local _Code_CountContinuousKilling = hApi.DoNothing		--统计连续击杀
	local _Code_CreateContinuousKillingFloatNumber = hApi.DoNothing	--创建连斩漂浮文字
	local _Code_CreateContinuousKillingEffect = hApi.DoNothing	--创建连斩特效
	local _Code_CreateContinuousKillingEffect2 = hApi.DoNothing	--创建连斩特效
	local _Code_PlayShakeView = hApi.DoNothing			--播放屏幕震动效果
	local _Code_ShowContinuousEffect = hApi.DoNothing
	local _Code_Clear = hApi.DoNothing				--清理数据
	local _Code_RecordBestContinuousKilling = hApi.DoNothing	--记录最大连斩数
	local _nCount = 0

	_Code_ShowContinuousEffect = function(oUnit,curNum)
		local curTime = os.clock()
		--print(curTime,_nlastEffecttime)
		local haveshake = 0
		if (curNum <= 20 and curNum % 5 == 0) or (curNum > 20 and curNum < 40 and curNum % 10 == 0) or (curNum >=40 and curNum % 20 == 0) then
			_Code_PlayShakeView(curNum)
			haveshake = 1
		end
		if curNum < 10 or curTime - _nlastEffecttime > 0.5 or haveshake == 1 then
			_Code_CreateContinuousKillingEffect2(oUnit,curNum)
			_nlastEffecttime = curTime
		end
	end
	_Code_PlayShakeView = function()
		--[[
		if num >= 4 then
			local curTime = os.clock()
			--if curTime - _nlastShakeTime > 0.25 or num% 10 == 0 then
			if num% 10 == 0 then
				_nlastShakeTime = curTime
				--取消镜头跟随
				
				
			end
		end]]
		local oWorld = hGlobal.WORLD.LastWorldMap
		oWorld.data.shaketick = 0.3
		oWorld.data.shakestarttime = 0
	end

	--记录最大连斩数
	_Code_RecordBestContinuousKilling = function(num)
		--成就中最大连斩
		--local oldBest = LuaGetPlayerCountVal(hVar.MEDAL_TYPE.bestContinuousKilling) or 0
		--if num > oldBest then
			--LuaSetPlayerCountVal(hVar.MEDAL_TYPE.bestContinuousKilling,num)
		--end
		--当前进度最大连斩
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = 1
		if tInfo then
			nStage = tInfo.nStage or 1
			local oldBest1 = tInfo.bestCK or 0
			if num > oldBest1 then
				local tInfos = {
					{"bestCK",num},
				}
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
			end
		end
		LuaUpdateRandMapSingleBestRecord("bestCK",{num,nStage}, true)
	end
	
	--统计连续击杀
	_Code_CountContinuousKilling = function(oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
		--print("_Code_CountContinuousKilling", oUnit.data.id,nOperate,oKillerUnit.data.id,nId,vParam,oKillerSide,oKillerPos)
		local tabU = hVar.tab_unit[oUnit.data.id]
		local tabS = hVar.tab_skill[nId]
		--自己被击杀  被不名技能击杀  皆不做判断
		if (tabS == nil) or (tabU == nil) or (_tInvalidUnitList[oUnit.data.id] == 1) or (oUnit.data.type == hVar.UNIT_TYPE.UNITBOX)
		   or (oUnit.data.type == hVar.UNIT_TYPE.UNITCAN) or (oUnit.data.type == hVar.UNIT_TYPE.TOWER)
		   or (oUnit.data.type == hVar.UNIT_TYPE.BUILDING) or (oUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN)
		   or (oUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (oUnit.data.type == hVar.UNIT_TYPE.UNITDOOR) then
			return
		end
		local countkill = tabS.countkill or 0
		--print("_Code_CountContinuousKilling",oUnit.data.id,oUnit.data.type,oKillerSide,countkill,nId)
		if oKillerSide == 1 or (oKillerSide == 2 and countkill == 1) then
			local num = #_tContinuousKillingList
			local cur_time = os.clock()

			local bIsContinuousKilling = 0
			--计算连斩
			if num > 0 then
				local lasttime = _tContinuousKillingList[num][2]
				if cur_time - lasttime <= _nContinuedTime then
					bIsContinuousKilling = 1
				else
					--超时重新计算
					_tContinuousKillingList = {}
				end
			end

			_tContinuousKillingList[#_tContinuousKillingList + 1] = {oUnit.data.id,cur_time}
			if bIsContinuousKilling == 1 then
				--print("bIsContinuousKilling == 1")
				--local x = math.random(20,40) * (math.random(0,2) - 1)
				--local y = math.random(40,60)

				--local oItem = oUnit:dropItem(13000,x,-y)
				--if oItem then
					--oItem.data.ContinuousKillNum = #_tContinuousKillingList
				--end
				--取表
				local curNum = #_tContinuousKillingList

				--记录最大连斩记录
				_Code_RecordBestContinuousKilling(curNum)

				local tab = _tAwardList[curNum]
				if type(tab) == "table" then
					--限制怪列表
					if _tLimitUnitList[oUnit.data.id] then
						if type(_tCountUnitAward[oUnit.data.id]) ~= "number" then
							_tCountUnitAward[oUnit.data.id] = 0
						end
						for i = 1,#tab do
							local itemId = tab[i]
							if type(itemId) == "number" and _tCountUnitAward[oUnit.data.id] < _tLimitUnitList[oUnit.data.id] then
								local x = math.random(20,60) * (math.random(0,2) - 1)
								local y = math.random(30,80)
								local oItem = oUnit:dropItem(itemId,x,-y)
								_tCountUnitAward[oUnit.data.id] = _tCountUnitAward[oUnit.data.id] + 1
								if oItem and oItem.data then
									if _tUnitScoreModulus[oUnit.data.id] then
										oItem.data.ScoreModulus = _tUnitScoreModulus[oUnit.data.id]
										--print(oUnit.data.id,oItem.data.id,oItem.data.ScoreModulus)
									end
								end
							end
						end
					else
						for i = 1,#tab do
							local itemId = tab[i]
							if type(itemId) == "number" then
								local x = math.random(20,60) * (math.random(0,2) - 1)
								local y = math.random(30,80)
								local oItem = oUnit:dropItem(itemId,x,-y)
								if oItem and oItem.data then
									if _tUnitScoreModulus[oUnit.data.id] then
										oItem.data.ScoreModulus = _tUnitScoreModulus[oUnit.data.id]
									end
								end
							end
						end
					end
				end

				_Code_ShowContinuousEffect(oUnit,curNum)
				--_Code_CreateContinuousKillingEffect(oUnit,curNum)
				--_Code_CreateContinuousKillingFloatNumber()
			end
		end
	end

	--显示漂浮文字
	local showFloatNumber = function(str)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(str, hVar.FONTC, 32, "MC", 0, 0,nil,1)
	end

	--创建连斩特效 漂浮文字
	_Code_CreateContinuousKillingFloatNumber = function()
		local curTime = os.clock()
		local str = tostring(#_tContinuousKillingList).." KILL"
		--没有累计且时间满足 直接显示
		--print(#floatnumberList,curTime - _nlastTime)
		if #floatnumberList == 0 and curTime - _nlastTime > _nDelayTime then
			--print("1111111111111")
			showFloatNumber(str)
			_bDelay = false
			hApi.clearTimer("ShowContinuousKillingFloatNumber")
		else
			if _bDelay == false then
				hApi.addTimerForever("ShowContinuousKillingFloatNumber",hVar.TIMER_MODE.GAMETIME,_nDelayTime * 1000,function(tick)
					local str1 = floatnumberList[1]
					showFloatNumber(str1)
					table.remove(floatnumberList,1)
					if #floatnumberList  == 0 then
						_bDelay = false
						hApi.clearTimer("ShowContinuousKillingFloatNumber")
					end
				end)
			end
			floatnumberList[#floatnumberList + 1] = str
			--print(#floatnumberList)
			_bDelay = true
		end
		_nlastTime = os.clock()
	end

	--创建连斩特效 显示在怪物头上
	_Code_CreateContinuousKillingEffect = function(oUnit,num)
		local model = "misc/continuouskilling/continuouskilling"
		if num < 2 then
			return
		elseif num > 10 then
			num = 10
		end
		model = model .. tostring(num) .. ".png"

		local offsetX = 0
		local offsetY = 40
		if (g_phone_mode ~= 0) then --手机模式
			offsetY = offsetY * 1.2
		end
		local fontSize = 20 --字体大小
		local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --坐标
		local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --包围盒
		local tx = hero_x + (hero_bx + hero_bw / 2) --中心点x位置
		local ty = hero_y + (hero_by + hero_bh) --上部y
		local display_x = tx + offsetX
		local display_y = -ty + hero_bh + 18 + offsetY
		if (oUnit.data.type == hVar.UNIT_TYPE.HERO) then
			display_y = display_y + 30
		end
		
		--父控件
		local ctrl = hUI.button:new({
			parent = oUnit:getworld().handle.worldLayer,
			x = display_x,
			y = display_y,
			z = 100000,
			align = "MC",
			w = 1,
			h = 1,
			model = "misc/masc.png",
		})
		ctrl.handle.s:setOpacity(0) --只用于挂载子控件，不显示

		if model then
			local image = hUI.image:new({
				parent = ctrl.handle._n,
				x = 0,
				y = 0,
				--scale = 0.5,
				model = model,
			})
		end
		ctrl.handle._n:setScale(0.3)

		local array = CCArray:create()
		local scale1 = CCEaseSineOut:create(CCScaleTo:create(0.5, 1))
		local waitScale = CCDelayTime:create(2)
		local callback = CCCallFunc:create(function() --回调
			ctrl:del()
			---print("DDDDD")
		end)
		--local scale2 = CCScaleTo:create(0.1, 1.0)
		array:addObject(scale1)
		array:addObject(waitScale)
		--array:addObject(scale2)
		--local sequecne = CCSequence:create(array) --同步1：变大又变小
		array:addObject(callback)
		ctrl.handle._n:runAction(CCSequence:create(array)) --action
		
		--_nCount = _nCount + 1
	
		--print("_Code_CreateContinuousKillingEffect",#_tContinuousKillingList)

		--_Code_CreateContinuousKillingFloatNumber()
	end

	--创建连斩特效 屏幕效果 加上气泡
	_Code_CreateContinuousKillingEffect2 = function(oUnit,num)
		local w = oUnit:getworld()
		local offsetX = 0
		local offsetY = 50
		local effectnum = math.min(num,10)
		if (g_phone_mode ~= 0) then --手机模式
			offsetY = offsetY * 1.2
		end
		local fontSize = 20 --字体大小
		local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --坐标
		local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --包围盒
		local tx = hero_x + (hero_bx + hero_bw / 2) --中心点x位置
		local ty = hero_y + (hero_by + hero_bh) --上部y
		local display_x = tx + offsetX
		local display_y = -ty + hero_bh + 18 + offsetY
		if (oUnit.data.type == hVar.UNIT_TYPE.HERO) then
			display_y = display_y + 30
		end
		
		local nodename ="CSYnode"
		if _CSYNode then
			_CSYNode:del()
			_CSYNode = nil
		end
		--父控件
		_CSYNode = hUI.button:new({
			parent = oUnit:getworld().handle.worldLayer,
			x = display_x,
			y = display_y,
			z = 100000,
			align = "MC",
			w = 1,
			h = 1,
			model = "misc/masc.png",
		})
		local node = _CSYNode
		node.handle.s:setOpacity(0) --只用于挂载子控件，不显示

		node.childUI["lab_kill"] = hUI.image:new({
			parent = node.handle._n,
			x = 0,
			y = 26,
			--scale = 0.3,
			model = "misc/continuouskilling/kill.png",
		})
		node.childUI["lab_add"] = hUI.image:new({
			parent = node.handle._n,
			model = "UI:CKSystemNum",
			animation = "ADD",
			x = -20,
			y = - 26,
		})
		local sNum = tostring(num)
		local length = #sNum
		for j = 1,length do
			local n = math.floor(num / (10^(length-j)))% 10
			node.childUI["lab_n"..j] = hUI.image:new({
				parent = node.handle._n,
				model = "UI:CKSystemNum",
				animation = "N"..n,
				x = 45 * j - 10,
				y = - 26,
			})
		end
		do
			local array = CCArray:create()
			local waitTime = CCDelayTime:create(1)
			local fadeout = CCFadeOut:create(0.5)
			local callback = CCCallFunc:create(function() --回调
				if _CSYNode then
					_CSYNode:del()
					_CSYNode = nil
				end
			end)
			array:addObject(waitTime)
			array:addObject(fadeout)
			array:addObject(callback)
			_CSYNode.handle._n:runAction(CCSequence:create(array)) --action
		end

		local bloodtype = 1
		local tabU = hVar.tab_unit[oUnit.data.id]
		if type(tabU) == "table" and type(tabU.bloodtype) == "number" and hVar.CKSYSTEM_EFFECTBLOOD[tabU.bloodtype] then
			bloodtype = tabU.bloodtype
		end
		

		--气泡
		for i = 1,3 do
			local x = math.random(25,60) * (math.random(0,2) - 1)
			local y = math.random(20,50) * (math.random(0,2) - 1)
			local name = "blood"..i
			node.childUI[name] = hUI.image:new({
				parent = node.handle._n,
				x = x,
				y = y,
				scale = 0.3,
				model = hVar.CKSYSTEM_EFFECTBLOOD[bloodtype],
				z = - 10,
			})
			local array = CCArray:create()
			local waittime = CCDelayTime:create(0.08 * math.random(0,10))
			local scale1 = CCEaseSineOut:create(CCScaleTo:create(math.random(20,50)/100, math.random(70 + effectnum * 5,120+ effectnum * 10)/100))
			local waitScale = CCDelayTime:create(1)
			local fadeout = CCFadeOut:create(0.5)
			local callback = CCCallFunc:create(function() --回调
				node.childUI[name]:del()
				---print("DDDDD")
			end)
			--array:addObject(waittime)
			array:addObject(scale1)
			array:addObject(waitScale)
			array:addObject(fadeout)
			array:addObject(callback)
			node.childUI[name].handle._n:runAction(CCSequence:create(array)) --action
		end
		_CSYNode.handle._n:setScale(0.5 + effectnum *7/100)
	end

	_Code_Clear = function()
		_nCount = 0
		_nlastTime = 0
		_nlastShakeTime = 0
		floatnumberList = {}
		_tContinuousKillingList = {}
		_tCountUnitAward = {}
		_bDelay = false
		hApi.clearTimer("ShowContinuousKillingFloatNumber")
	end
	
	--获取连斩奖励流程
	hGlobal.event:listen("GetContinuousKillingAward","getaward",function(oUnit, oTarget)
		if oUnit then
			local nItemId = oUnit:getitemid()
			--local nKillNum = oUnit.data.ContinuousKillNum
			local nX = oUnit.data.worldX
			local nY = oUnit.data.worldY
			local showX,showY = hApi.world2view(nX,nY)
			local Modulus = oUnit.data.ScoreModulus or 1
			--print("GetContinuousKillingAward",nItemId,Modulus)
			--if nItemId == 13000 and type(nKillNum) == "number" then
			if type(hVar.ContinuousKillingItemAward[nItemId]) == "table" then 
				local totalNum = 0
				for i = 1,#hVar.ContinuousKillingItemAward[nItemId] do
					local nType,num =  unpack(hVar.ContinuousKillingItemAward[nItemId][i])
					if nType == "score" then 
						if type(num) == "number" and num > 0 then
							local crystalRate = oTarget:GetCrystalRate() --单位水晶收益率（去百分号后的值）
							--print(oTarget.data.name, "crystalRate=", crystalRate)
							local scoreNum = math.floor(num * Modulus * crystalRate / 100)
							totalNum = totalNum + scoreNum
							
							--修改添加积分的同时加上来源以便统计
							--[[
							LuaAddPlayerScoreByWay(scoreNum,hVar.GET_SCORE_WAY.CK)
							hGlobal.event:event("LocalEvent_RefreshCurGameScore")
							GameManager.AddGameInfo("ckscore",scoreNum)
							--]]
							--GameManager.AddGameInfo("scoreingame",scoreNum)
							--hGlobal.event:event("LocalEvent_RefreshCurGameScore")
							--geyachao: 改为游戏内加金币
							local oPlayer = oTarget:getowner()
							if oPlayer then
								oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, scoreNum)
								
								local world = hGlobal.WORLD.LastWorldMap
								local me = world:GetPlayerMe()
								if me and (me == oPlayer) then
									hGlobal.event:event("Event_TacticCastCostRefresh")
								end
							end
							
							strText = "x " .. tostring(scoreNum)
							local offW = #strText * 12 - 5
							hUI.floatNumber:new({
								x = showX + offW,
								y = showY,
								align = "LC",
								text = strText,
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
								font = "numBlue",
								size = 24,
							})

							hUI.floatNumber:new({
								font = "numGreen",
								text = "",
								size = 16,
								x = showX - 5,
								y = showY,
								align = "LC",
								icon = "misc/skillup/mu_coin.png",
								iconWH = 36,
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							})
						end
					end
				end
				if totalNum > 0 then
					--[[
					local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
					local ckscore = (tInfo.ckscore or 0)+ totalNum
					local tInfos = {
						{"ckscore",ckscore},
					}
					LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
					]]
					--geyachao: 改为游戏内加金币
				end
			end
		end
	end)
	
	--切换地图事件
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "continuouskilling",function(sSceneType,oWorld,oMap)
		--父控件world已经删了，子控件也被删了
		_CSYNode = nil
	end)
	
	--开启/关闭连斩系统
	hGlobal.event:listen("OpenContinuousKillingSystem","OpenSystem",function(bSwitch)
		
		--geyachao: 查bug临时去掉，待恢复
		if hVar.IS_SHOW_HIT_EFFECT_FLAG == 1 then
			--开启
			if bSwitch then
				hGlobal.event:listen("Event_UnitDead", "Diable_ContinuousKillingSystem", _Code_CountContinuousKilling)
			else
				_Code_Clear()
				hGlobal.event:listen("Event_UnitDead", "Diable_ContinuousKillingSystem", nil)
			end
		end
		
	end)
end