--heroGameAITask = {}
--heroGameAITask.heroTask = {}
--heroGameAITask.heroSpecialTask = {}
--
--
--
--heroGameAITask.heroSpecialTask["hero_garrison"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["hero_garrison"].GetTask = function(u)
--	--_DEBUG_MSG('heroGameAITask.heroSpecialTask["hero_garrison"].GetTask()')
--	local task = {Priority = basePriority,Action = "Hero_Garrison",u = u,Target = nil}
--	return task
--end
--
--local get_city_enemy = function(city,r)
--	if nil == r then
--		r = heroGameAIExplore.CityGuardDis
--	end
--
--	local monsterTable = {}
--	local oPlayer = city:getowner()
--
--	for i = 1,#heroGameRule.players do
--		if oPlayer:allience(heroGameRule.players[i]) == hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
--			local heros = heroGameRule.players[i].heros
--			for i = 1,#heros do
--				local u = heros[i]:getunit()
--				local ai_task = heros[i].data.AIModeBasic
--				if type(u) == "table" and ai_task ~= hVar.AI_MODE.PASSIVE and heros[i].data.IsDefeated == 0 then
--					local dis = GetDistanceByDirect(u,city)
--					--heroGameAI.LogAi(string.format("get_city_enemy city.x:%d city.y:%d t.x:%d t.y:%d t.id:%d \n",city.data.gridX,city.data.gridY,u.data.gridX,u.data.gridY,u.data.id))
--					if dis <= r and dis >= 0 then
--						heroGameAI.LogAi(string.format("get_city_enemy hid:%d hname:%s dis:%d\n",u.data.id,tostring(u.data.name),dis))
--						monsterTable[#monsterTable + 1] = u
--					end
--				end
--			end
--		end
--	end
--
--	return monsterTable
--end
--
--heroGameAITask.heroSpecialTask["hero_cityguard"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["hero_cityguard"].GetTask = function(u)
--	heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask()\n')
--	local task = nil
--	local tu = hApi.GetObjectUnit(u:gethero().data.AIExtData)
--	if type(tu) == "table" then
--		if hVar.UNIT_TYPE.BUILDING == tu.data.type then
--			local id = tu.data.id
--			local subType = hApi.GetBuildingTypeExByID(id)
--			if hVar.BUILDING_TYPE_EX.TOWN == subType then
--				local city = tu
--				-- ���������Ƿ��Լ���
--				local relation = u:getowner():allience(city:getowner())
--				if relation == hVar.PLAYER_ALLIENCE_TYPE.NEUTRAL or relation == hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
--					local taskType = heroGameAIExplore.GetCityTaskType(u,city)
--					if "none" == taskType then
--						local oTown = hClass.town:find(u.data.curTown)
--						if oTown then
--							local g = oTown:getunit("guard")
--							if type(g) == "table" and g.data.id == u.data.id then
--								local v = oTown:getunit("visitor")
--								if type(v) == "table" then
--									if g.data.id == v.data.id then
--										oTown:setguard(nil)
--										oTown:setvisitor(u)
--										heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no enemy change 2 normal ai shiftVG error id:' .. g.data.id .. " \n")
--									else
--										oTown:shiftVG()
--									end
--								else
--									oTown:setguard(nil)
--									oTown:setvisitor(u)
--									heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no enemy change 2 normal ai setvisitor\n')
--								end
--							end
--						end
--						heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() city not belong to me act normal ai city:' .. tostring(city.data.id) .. "\n")
--						return "normal"
--					else
--						task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_occupy"].basePriority),Action = "Occupy",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--						task.Action = taskType
--						local oTown = hClass.town:find(u.data.curTown)
--						if oTown then
--							local g = oTown:getunit("guard")
--							if type(g) == "table" and g.data.id == u.data.id then
--								local v = oTown:getunit("visitor")
--								if type(v) == "table" then
--									if g.data.id == v.data.id then
--										oTown:setguard(nil)
--										oTown:setvisitor(u)
--										heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() shiftVG error 2222 id:' .. g.data.id .. " \n")
--									else
--										oTown:shiftVG()
--									end
--								else
--									oTown:setguard(nil)
--									oTown:setvisitor(u)
--								end
--							end
--						end
--						heroGameAI.LogAi(string.format("heroSpecialTask.GetTask() city not belong to me begin to do action:%s\n",taskType))
--						return task
--					end
--				elseif relation == hVar.PLAYER_ALLIENCE_TYPE.OWNER then
--					-- �Ƿ�����Ҫ�������
--					local heros = get_city_enemy(city)
--					if #heros > 0 then
--						local oTown = hClass.town:find(u.data.curTown)
--						if oTown then
--							if #heros > 1 then
--								local oGuard = oTown:getunit("guard")
--								if type(oGuard) == "table" then
--								else
--									oTown:setguard(u)
--									oTown:setvisitor(nil)
--								end
--								task = {Priority = basePriority,Action = "Hero_Garrison",u = u,Target = nil}
--								heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() Hero_Garrison so many monster\n')
--								return task
--							else
--								local monster = heros[1]
--								local uCombatSocre = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
--								local mCombatSocre = heroGameAI.CalculateSystem.Calculate(monster,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
--								if uCombatSocre >= 2 * mCombatSocre or uCombatSocre >= mCombatSocre + 5000 then
--									local g = oTown:getunit("guard")
--									if type(g) == "table" and g.data.id == u.data.id then
--										local v = oTown:getunit("visitor")
--										if type(v) == "table" then
--											if g.data.id == v.data.id then
--												oTown:setguard(nil)
--												oTown:setvisitor(u)
--												heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() shiftVG error 1111 id:' .. g.data.id .. " \n")
--											else
--												oTown:shiftVG()
--											end
--										else
--											oTown:setguard(nil)
--											oTown:setvisitor(u)
--										end
--									end
--									if monster.data.IsHide == 0 then -- ����
--										task = {Priority = GetPriority(u,hero,heroGameAITask.heroTask["hero_attack"].basePriority),Action = "Hero_Attack",u = u,Target = {x = monster.data.gridX,y = monster.data.gridY,u=monster}}
--										heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() attack hero from city\n')
--									else
--										local city_lrs = heroGameAI.CalculateSystem.Calculate(monster,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE)
--										local u_lrs = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE)
--										if u_lrs >= 100 and u_lrs >= city_lrs * 1.2 then
--											local oTown = hClass.town:find(monster.data.curTown)
--											local city = oTown:getunit()
--											task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_occupy"].basePriority),Action = "Attack_Player",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--											heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() attack city from city\n')
--										else
--											task = {Priority = basePriority,Action = "Hero_Garrison",u = u,Target = nil}
--											heroGameAI.LogAi(string.format('heroSpecialTask.GetTask() no long range Hero_Garrison 1 hero hid:%d hname:%s\n',monster.data.id,tostring(monster.data.name)))
--										end
--									end
--									return task
--								else
--									local oGuard = oTown:getunit("guard")
--									if type(oGuard) == "table" then
--									else
--										oTown:setguard(u)
--										oTown:setvisitor(nil)
--									end
--									task = {Priority = basePriority,Action = "Hero_Garrison",u = u,Target = nil}
--									heroGameAI.LogAi(string.format('heroSpecialTask.GetTask() Hero_Garrison 1 hero hid:%d hname:%s\n',monster.data.id,tostring(monster.data.name)))
--									return task
--								end
--							end
--						else
--							if #heros > 1 then
--								task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_defend"].basePriority),Action = "Guard_City",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--								heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() go to city so many monster\n')
--								return task
--							else
--								local monster = heros[1]
--								local uCombatSocre = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
--								local mCombatSocre = heroGameAI.CalculateSystem.Calculate(monster,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
--								if uCombatSocre >= 2 * mCombatSocre or uCombatSocre >= mCombatSocre + 5000 then
--									if monster.data.IsHide == 0 then -- ����
--										task = {Priority = GetPriority(u,hero,heroGameAITask.heroTask["hero_attack"].basePriority),Action = "Hero_Attack",u = u,Target = {x = monster.data.gridX,y = monster.data.gridY,u=monster}}
--										heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() attack hero outdoor\n')
--									else
--										local city_lrs = heroGameAI.CalculateSystem.Calculate(monster,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE)
--										local u_lrs = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE)
--										if u_lrs >= 100 and u_lrs >= city_lrs * 1.2 then
--											local oTown = hClass.town:find(monster.data.curTown)
--											local city = oTown:getunit()
--											task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_occupy"].basePriority),Action = "Attack_Player",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--											heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() attack city outdoor\n')
--										else
--											task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_defend"].basePriority),Action = "Guard_City",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--											heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no long range go to city 1 hero\n')
--										end
--									end
--									return task
--								else
--									task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_defend"].basePriority),Action = "Guard_City",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--									heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() go to city 1 hero\n')
--									return task
--								end
--							end
--						end
--					else 
--						local oTown = hClass.town:find(u.data.curTown)
--						if oTown then
--							local g = oTown:getunit("guard")
--							if type(g) == "table" and g.data.id == u.data.id then
--								local v = oTown:getunit("visitor")
--								if type(v) == "table" then
--									if g.data.id == v.data.id then
--										oTown:setguard(nil)
--										oTown:setvisitor(u)
--										heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no enemy change 2 normal ai shiftVG error id:' .. g.data.id .. " \n")
--									else
--										oTown:shiftVG()
--									end
--								else
--									oTown:setguard(nil)
--									oTown:setvisitor(u)
--									heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no enemy change 2 normal ai setvisitor\n')
--								end
--							end
--						end
--						heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() no enemy change 2 normal ai\n')
--						return "normal"
--					end
--				else
--					task = {Priority = basePriority,Action = "Hero_Garrison",u = u,Target = nil}
--					return task
--				end
--			end
--		end
--	else
--		heroGameAI.LogAi('heroSpecialTask["hero_cityguard"].GetTask() city nil\n')
--		heroGameAI.LogAi(string.format("heroSpecialTask.hero_cityguard() aiext_data:%s\n",tostring(u:gethero().data.AIExtData)))
--	end
--
--	return task
--end
--
--heroGameAITask.heroSpecialTask["hero_policy"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["hero_policy"].GetTask = function(u)
--	local task = nil
--	local oHero = u:gethero()
--	local ai_task = oHero.data.AIMode
--	local dis = 9
--
--	-- ���ȼ�1 �����ĵж�Ӣ��(����ս����)
--	local hero = heroGameAIExplore.GetHeroAttackTask(u,dis,true)
--	if type(hero) == "table" then
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_policy"].GetTask() hero_attack t.name:' .. hero.data.name .. "\n")
--		local task = {Priority = GetPriority(u,hero,heroGameAITask.heroTask["hero_attack"].basePriority),Action = "Hero_Attack",u = u,Target = {x = hero.data.gridX,y = hero.data.gridY,u=hero}}
--		return task
--	end
--
--	-- ���ȼ�2 �����ĳ���(����ս����)
--	local city = heroGameAIExplore.GetCityOccupyTask(u,dis,true)
--	if type(city) == "table" then
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_policy"].GetTask() city_occupy t.name:' .. city.data.name .. "\n")
--		local taskType = city.tempAiType
--		local task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_occupy"].basePriority),Action = "Occupy",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--		task.Action = taskType
--		return task	
--	end
--
--	-- ���ȼ�3 ��������(���ֲɼ���)
--	local town = heroGameAIExplore.GetTownOccupyTask(u,dis,true)
--	if type(town) == "table" then
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_policy"].GetTask() town_occupy t.name:' .. town.data.name .. "\n")
--		local task = {Priority = GetPriority(u,town,heroGameAITask.heroTask["town_occupy"].basePriority),Action = "Occupy",u = u,Target = {x = town.data.gridX,y = town.data.gridY,u=town}}
--		return task
--	end
--
--	-- ���ȼ�4 ִ�з���
--	local tu = hApi.GetObjectUnit(u:gethero().data.AIExtData)
--	if type(tu) == "table" then
--		task = heroGameAITask.heroSpecialTask["hero_chase"].GetTask(u)
--		if task == "normal" then
--			task = nil
--		elseif nil == task then
--			task = nil
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				heroGameAI.LogAi(string.format("���ȼ�4 ִ�з��� sametask id:%d \n",u.data.id))
--				task = nil
--			else
--				heroGameAI.LogAi(string.format("GetHeroUrgentTask CHASE notsametask id:%d task:%s\n",u.data.id,tostring(task)))
--				return task
--			end
--		end
--	end
--
--	-- ���ȼ�5 �����Ŀ�ʰȡ��
--	local item = heroGameAIExplore.GetGrabTask(u,dis,true)
--	if type(item) == "table" then
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_policy"].GetTask() GetGrabTask t.name:' .. item.data.name .. "\n")
--		local task = {Priority = GetPriority(u,item,heroGameAITask.heroTask["resource_grab"].basePriority),Action = "Grab",u = u,Target = {x = item.data.gridX,y = item.data.gridY,u=item}}
--		return task
--	end
--	-- ���ȼ�6 ������Ұ��
--	-- local monster = heroGameAIExplore.GetGrabTask(u,dis,true)
--	
--	return nil
--	
--end
--
--heroGameAITask.heroSpecialTask["hero_direct"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["hero_direct"].GetTask = function(u)
--	local task = nil
--	local oHero = u:gethero()
--	local tu = hApi.GetObjectUnit(oHero.data.AIExtData)
--	if type(tu) == "table" then
--		if hVar.UNIT_TYPE.HERO == tu.data.type then
--			task = {Priority = basePriority,Action = "Hero_Direct",u = u,Target = {x = tu.data.gridX,y = tu.data.gridY,u = tu}}
--			heroGameAI.LogAi(string.format("hero_direct id:%d tu:%s\n",u.data.id,tu.data.id))
--			return task
--		end
--	end
--	return nil
--end
--
--heroGameAITask.heroSpecialTask["guard_against"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["guard_against"].GetTask = function(u)
--	local task = nil
--	local oHero = u:gethero()
--	local dis = 24
--
--	local hero = heroGameAIExplore.GetHeroAttackTask(u,dis,true)
--	if type(hero) == "table" then
--		heroGameAI.LogAi('heroGameAITask.heroTask["guard_against"].GetTask() hero_attack t.name:' .. hero.data.name .. "\n")
--		task = {Priority = GetPriority(u,hero,heroGameAITask.heroTask["hero_attack"].basePriority),Action = "Hero_Attack",u = u,Target = {x = hero.data.gridX,y = hero.data.gridY,u=hero}}
--		return task
--	end
--
--	return task
--end
--
--heroGameAITask.heroSpecialTask["hero_chase"] = {basePriority = 0}
--heroGameAITask.heroSpecialTask["hero_chase"].GetTask = function(u)
--	local task = nil
--	local tu = hApi.GetObjectUnit(u:gethero().data.AIExtData)
--	if type(tu) == "table" then
--		heroGameAI.LogAi(string.format("heroSpecialTask hero_chase tid:%s \n",tostring(tu.data.id)))
--		if hVar.UNIT_TYPE.HERO == tu.data.type then
--			if tu.data.IsHide == 1 then
--				local isGuard = false
--
--				if tu.data.curTown and tu.data.curTown ~= 0 then
--					local oTown = hClass.town:find(tu.data.curTown)
--					if oTown then
--						local tw = oTown:getunit("guard")
--						if tw then
--							isGuard = true
--							tu = oTown:getunit()
--						end
--					end
--				end
--
--				if true == isGuard then
--					task = {Priority = basePriority,Action = "Hero_Chase",u = u,Target = {x = tu.data.gridX,y = tu.data.gridY,u = tu}}
--					heroGameAI.LogAi(string.format("heroSpecialTask hero_chase isGuard isGuard \n"))
--					return task
--				else
--					heroGameAI.LogAi(string.format("heroSpecialTask hero_chase return normal 2323232 \n"))
--					return "normal"
--				end
--
--			end
--
--			if tu.data.curTown and tu.data.curTown ~= 0 then
--				local oTown = hClass.town:find(tu.data.curTown)
--				if oTown then
--					local tw = oTown:getunit("guard")
--					if tw then
--						tu = oTown:getunit()
--					end
--				end
--			end
--			task = {Priority = basePriority,Action = "Hero_Chase",u = u,Target = {x = tu.data.gridX,y = tu.data.gridY,u = tu}}
--		elseif hVar.UNIT_TYPE.BUILDING == tu.data.type then
--			local id = tu.data.id
--			local subType = hApi.GetBuildingTypeExByID(id)
--			if hVar.BUILDING_TYPE_EX.TOWN == subType then
--				local city = tu
--				local ttype = heroGameAIExplore.GetSpecialCityTaskType(u,city)
--				if "none" == ttype then
--					u:gethero().data.AIMode = hVar.AI_MODE.NORMAL
--					return nil
--				else
--					local oTown = city:gettown()
--					local oVisitor = oTown:getunit("visitor")
--					if nil == oVisitor then
--					else
--						city = oVisitor
--					end
--					task = {Priority = basePriority,Action = "Occupy",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--					task.Action = ttype
--					return task
--				end
--			elseif hVar.BUILDING_TYPE_EX.PROVIDE == subType then
--
--			elseif hVar.BUILDING_TYPE_EX.VISIT == subType then
--
--			elseif hVar.BUILDING_TYPE_EX.HIRE == subType then
--
--			elseif hVar.BUILDING_TYPE_EX.SHOP == subType then
--
--			end
--		end
--	else
--		-- û��Ŀ��
--		return "normal"
--	end
--
--	return task
--end
--
--
--
----�������
--heroGameAITask.heroTask["city_defend"] = {basePriority = 0}
--heroGameAITask.heroTask["city_defend"].GetTask = function(h)
--	--_DEBUG_MSG('heroGameAITask.heroTask["city_defend"].GetTask()')
--	return nil
--end
--
--heroGameAITask.heroTask["city_occupy"] = {basePriority = 0}
--heroGameAITask.heroTask["city_occupy"].GetTask = function(u)
--	local city = heroGameAIExplore.GetCityOccupyTask(u)
--	if nil == city then
--		heroGameAI.LogAi('heroGameAITask.heroTask["city_occupy"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["city_occupy"].GetTask() t.name:' .. city.data.name .. "\n")
--		local taskType = city.tempAiType
--		local task = {Priority = GetPriority(u,city,heroGameAITask.heroTask["city_occupy"].basePriority),Action = "Occupy",u = u,Target = {x = city.data.gridX,y = city.data.gridY,u=city}}
--		task.Action = taskType
--		return task	
--	end
--	return nil
--end
--
--
--
--
--
--
----�������
--heroGameAITask.heroTask["town_occupy"] = {basePriority = 1}
--heroGameAITask.heroTask["town_occupy"].GetTask = function(u)
--	local res = heroGameAIExplore.GetTownOccupyTask(u)
--	if nil == res then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["town_occupy"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["town_occupy"].GetTask() t.name:' .. res.data.name .. "\n")
--		local task = {Priority = GetPriority(u,res,heroGameAITask.heroTask["town_occupy"].basePriority),Action = "Occupy",u = u,Target = {x = res.data.gridX,y = res.data.gridY,u=res}}
--		return task
--	end
--	return nil
--end
----Ұ�⽱�����
--heroGameAITask.heroTask["house_giving"] = {basePriority = 1}
--heroGameAITask.heroTask["house_giving"].GetTask = function(u)
--	local res = heroGameAIExplore.GetHouseGivingTask(u)
--	if nil == res then
--		heroGameAI.LogAi('heroGameAITask.heroTask["house_giving"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["house_giving"].GetTask() t.name:' .. res.data.name .. "\n")
--		local task = {Priority = GetPriority(u,res,heroGameAITask.heroTask["house_giving"].basePriority),Action = "Giving",u = u,Target = {x = res.data.gridX,y = res.data.gridY,u=res}}
--		return task
--	end
--	return nil
--end
----Ұ���Ӷ���
--heroGameAITask.heroTask["house_hire"] = {basePriority = 1}
--heroGameAITask.heroTask["house_hire"].GetTask = function(u)
--	local res = heroGameAIExplore.GetHouseHireTask(u)
--	if nil == res then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["house_hire"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["house_hire"].GetTask() t.name:' .. res.data.name .. "\n")
--		local task = {Priority = GetPriority(u,res,heroGameAITask.heroTask["house_hire"].basePriority),Action = "House_Hire",u = u,Target = {x = res.data.gridX,y = res.data.gridY,u=res}}
--		return task
--	end
--	return nil
--end
--
----Ұ���̵����
----[[
--heroGameAITask.heroTask["house_shopping"] = {basePriority = 1}
--heroGameAITask.heroTask["house_shopping"].GetTask = function(h)
--	_DEBUG_MSG('heroGameAITask.heroTask["house_shopping"].GetTask()')
--	local res = heroGameAIExplore.GetHouseShoppingTask(u)
--	if nil == res then 
--		return nil
--	else
--		local task = {Priority = heroGameAITask.heroTask["house_shopping"].basePriority,Action = "Shopping",u = u,Target = {x = res.data.gridX,y = res.data.gridY,u=res}}
--		return task
--	end
--	return nil
--end
----]]
--
----��Դ���
--heroGameAITask.heroTask["resource_grab"] = {basePriority = 1}
--heroGameAITask.heroTask["resource_grab"].GetTask = function(u)
--	local res = heroGameAIExplore.GetGrabTask(u)
--	if nil == res then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["resource_grab"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["resource_grab"].GetTask() t.name:' .. res.data.name .. "\n")
--		local task = {Priority = GetPriority(u,res,heroGameAITask.heroTask["resource_grab"].basePriority),Action = "Grab",u = u,Target = {x = res.data.gridX,y = res.data.gridY,u=res}}
--		return task
--	end
--end
--
--
--
--
----�������
--heroGameAITask.heroTask["monster_attack"] = {basePriority = 2}
--heroGameAITask.heroTask["monster_attack"].GetTask = function(u)
--	local monster = heroGameAIExplore.GetMonsterTask(u)
--	if nil == monster then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["monster_attack"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["monster_attack"].GetTask() t.name:' .. monster.data.name .. "\n")
--		local task = {Priority = GetPriority(u,monster,heroGameAITask.heroTask["monster_attack"].basePriority),Action = "Monster_Attack",u = u,Target = {x = monster.data.gridX,y = monster.data.gridY,u=monster}}
--		return task
--	end
--end
--
----ӵ��׷��Ŀ��ʱ��������
--heroGameAITask.heroTask["monster_attack"].GetTaskWithChase = function(u,t)
--	--���Ŀ����˻򲻴��ڣ���ô������Ҹ��ִ�
--	if t==nil or t.data.IsDead==1 or t.handle._c==nil then
--		return heroGameAITask.heroTask["monster_attack"].GetTask(u)
--	end
--	--�����Ҿ���Ŀ������Ŀ��Դ򵽵Ĺ��﹥��
--	local monster = heroGameAIExplore.GetMonsterTaskWithChase(u,t)
--	if nil == monster then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["monster_attack"].GetTaskWithChase() nil\n')
--		return nil
--	else
--		print(u.data.id.."����׷��Ŀ��"..monster.data.id,monster.handle.name)
--		heroGameAI.LogAi('heroGameAITask.heroTask["monster_attack"].GetTaskWithChase() t.name:' .. monster.data.name .. "\n")
--		local task = {Priority = GetPriority(u,monster,heroGameAITask.heroTask["monster_attack"].basePriority),Action = "Monster_Attack",u = u,Target = {x = monster.data.gridX,y = monster.data.gridY,u=monster}}
--		return task
--	end
--end
--
----Ӣ�����
--heroGameAITask.heroTask["hero_recruit"] = {basePriority = 1}
--heroGameAITask.heroTask["hero_recruit"].Run = function(h)
--	--_DEBUG_MSG('heroGameAITask.heroTask["hero_recruit"].Run()')
--end
--heroGameAITask.heroTask["hero_recruit"].GetTask = function(h)
--	--_DEBUG_MSG('heroGameAITask.heroTask["hero_recruit"].GetTask()')
--	return nil
--end
--
--heroGameAITask.heroTask["hero_attack"] = {basePriority = 0}
--heroGameAITask.heroTask["hero_attack"].Run = function(u)
--	--_DEBUG_MSG('heroGameAITask.heroTask["hero_attack"].Run()')
--end
--heroGameAITask.heroTask["hero_attack"].GetTask = function(u)
--	local hero = heroGameAIExplore.GetHeroAttackTask(u)
--	if nil == hero then 
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_attack"].GetTask() nil\n')
--		return nil
--	else
--		heroGameAI.LogAi('heroGameAITask.heroTask["hero_attack"].GetTask() t.name:' .. hero.data.name .. "\n")
--		local task = {Priority = GetPriority(u,hero,heroGameAITask.heroTask["hero_attack"].basePriority),Action = "Hero_Attack",u = u,Target = {x = hero.data.gridX,y = hero.data.gridY,u=hero}}
--		return task
--	end
--end
--
--
--
----��ͼ���
--heroGameAITask.heroTask["map_explore"] = {basePriority = 5}
--heroGameAITask.heroTask["map_explore"].Run = function(h)
--	--_DEBUG_MSG('heroGameAITask.heroTask["map_explore"].Run()')
--end
--heroGameAITask.heroTask["map_explore"].GetTask = function(h)
--	--_DEBUG_MSG('heroGameAITask.heroTask["map_explore"].GetTask()')
--	--return heroGameAITask.heroTask["map_explore"].basePriority
--	return nil
--end
--
--
--
----�ж��Ƿ�ͬһ������
--function heroGameAITask.HaveSameTask(u,task)
--	if u.localdata.lastTask and #u.localdata.lastTask > 0 then
--		for i=1,#u.localdata.lastTask do
--			if heroGameAITask.IsSameTask(u.localdata.lastTask[i],task) then
--				return true
--			end
--		end
--	end
--	
--	return false
--end
--
--function heroGameAITask.IsSameTask(task1,task2)
--	if nil == task1 or nil == task2 then
--		return false
--	end
--	
--	if task1.Action == task2.Action then
--		if task1.Target == task2.Target then
--			return true
--		elseif task1.Target and task2.Target then
--			if task1.Target.x == task2.Target.x and task1.Target.y == task2.Target.y then
--				return true
--			end
--		else
--			return false
--		end
--	end
--	
--	return false
--end
--
--
----ȡ���ȼ��ߵ�����
--function heroGameAITask.GetHeroUrgentTask(u)
--	local priority = 999
--	local task = nil
--	--���ָ��������Ͱ�������
--
--	local oHero = u:gethero()
--	heroGameAI.LogAi("GetHeroUrgentTask AIModeBasic:"..tostring(oHero.data.AIModeBasic).." AIMode:"..tostring(oHero.data.AIMode).."\n")
--	local ai_task = oHero.data.AIMode
--	if hVar.AI_MODE.GUARD_CITY == oHero.data.AIModeBasic then
--		ai_task = hVar.AI_MODE.GUARD_CITY
--	end
--
--	if hVar.AI_MODE.NORMAL == ai_task then
--		
--	elseif hVar.AI_MODE.GUARD == ai_task or hVar.AI_MODE.PASSIVE == ai_task then
--		task = heroGameAITask.heroSpecialTask["hero_garrison"].GetTask(u)
--		if heroGameAITask.HaveSameTask(u,task) then
--			return nil
--		else
--			u.localdata.lastTask = {task}
--			return task
--		end
--	elseif hVar.AI_MODE.CHASE == ai_task then
--		task = heroGameAITask.heroSpecialTask["hero_chase"].GetTask(u)
--		if task == "normal" then
--			task = nil
--		elseif nil == task then
--			return nil
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				--return nil
--				heroGameAI.LogAi(string.format("GetHeroUrgentTask CHASE sametask id:%d \n",u.data.id))
--				task = nil
--			else
--				heroGameAI.LogAi(string.format("GetHeroUrgentTask CHASE notsametask id:%d task:%s\n",u.data.id,tostring(task)))
--				u.localdata.lastTask = {task}
--				return task
--			end
--		end
--	elseif hVar.AI_MODE.GUARD_CITY == ai_task then
--		task = heroGameAITask.heroSpecialTask["hero_cityguard"].GetTask(u)
--		if task == "normal" then
--			task = nil
--		elseif nil == task then
--			return nil
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				task = nil
--				heroGameAI.LogAi('HaveSameTask true\n')
--			else
--				u.localdata.lastTask = {task}
--				heroGameAI.LogAi('HaveSameTask false\n')
--				return task
--			end
--		end
--	elseif hVar.AI_MODE.POLICY_CHASE == ai_task then
--		task = heroGameAITask.heroSpecialTask["hero_policy"].GetTask(u)
--		if nil == task then
--			return task
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				return nil
--			else
--				u.localdata.lastTask = {task}
--				return task
--			end
--		end
--	elseif hVar.AI_MODE.DIRECT_CHASE == ai_task then
--		task = heroGameAITask.heroSpecialTask["hero_direct"].GetTask(u)
--		if nil == task then
--			return task
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				return nil
--			else
--				u.localdata.lastTask = {task}
--				return task
--			end
--		end
--	elseif hVar.AI_MODE.GUARD_AGAINST == ai_task then
--		task = heroGameAITask.heroSpecialTask["guard_against"].GetTask(u)
--		if nil == task then
--			return task
--		else
--			if heroGameAITask.HaveSameTask(u,task) then
--				return nil
--			else
--				u.localdata.lastTask = {task}
--				return task
--			end
--		end
--	else
--		
--	end
--
--	--task = nil
--
--	for k,v in pairs(heroGameAITask.heroTask)do
--		local curTask = v.GetTask(u)
--		if nil ~= curTask and not heroGameAITask.HaveSameTask(u,curTask) then
--			if priority > curTask.Priority then
--				priority = curTask.Priority
--				task = curTask
--			end
--		end
--	end
--
--	if task then
--		u.localdata.lastTask[#u.localdata.lastTask + 1] = task
--	end
--	
--	return task
--end