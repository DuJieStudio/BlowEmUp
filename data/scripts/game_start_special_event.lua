
--======================= event ==========================
--TD游戏开始特殊处理回调
function On_TDGameBegin_Special_Event(oMap, oWorld)
	local mapName = oWorld.data.map --地图名
	
	if (mapName == "world/td_dlc_50_1") then --吕布传第1关
		--晕我方英雄
		--...
	end
end


--======================= event ==========================
--添加单位事件特殊处理函数
function On_AddUnit_Special_Event(oUnit, unitId, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
	local world = hGlobal.WORLD.LastWorldMap
	local uOwner = oUnit:getowner()
	local posUnit = uOwner and uOwner:getpos() --位置
	local forceUnit = uOwner and uOwner:getforce() --势力
	
	--print(oUnit.data.name, unitId, "posUnit=" .. tostring(posUnit), "forceUnit=" .. tostring(forceUnit))
	
	--[[
	--大菠萝暂时不无敌
	--坦克出生就无敌
	if (unitId == hVar.MY_TANK_ID) then
		local rebirth_wudi_time = oUnit:GetRebirthWudiTime()
		if (rebirth_wudi_time > 0) then
			print("rebirth_wudi_time=", rebirth_wudi_time)
			--释放技能
			local skillId = 16044 --无敌技能id
			local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
			local gridX, gridY = world:xy2grid(targetX, targetY)
			local tCastParam =
			{
				level = rebirth_wudi_time, --等级
				--skillTimes = oUnit.data.atkTimes, --普通攻击的次数
			}
			hApi.CastSkill(oUnit, skillId, 0, 100, oUnit, gridX, gridY, tCastParam) --无敌技能
		end
	end
	]]
	
	--大菠萝。屠夫防止叠一起打战车
	if (unitId == hVar.MY_TANK_ID) then
		oUnit.data.adjust_dx = world:random(-20, 20) --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
		oUnit.data.adjust_dy = world:random(-20, 20) --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
	end
	
	--瓦力设置守卫点偏移
	--if (unitId == hVar.MY_TANK_FOLLOW_ID) then
	for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
		if (unitId == walle_id) then
			oUnit.data.defend_x_walle = world:random(-80, 80)
			oUnit.data.defend_y_walle = world:random(-80, 80)
		end
	end
	
	--战车成就相关：同时携带的宠物数量+1
	local bIsPet = false
	for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
		if (unitId == walle_id) then
			bIsPet = true
		end
	end
	if bIsPet then
		local me = world:GetPlayerMe()
		if uOwner.dbid == me.dbid then
			-- 跟随宠物数量
			world.data.statistics_current_pet_follow = world.data.statistics_current_pet_follow + 1
			if world.data.statistics_current_pet_follow > world.data.statistics_max_pet_follow then
				world.data.statistics_max_pet_follow = world.data.statistics_current_pet_follow

				print("current:", world.data.statistics_current_pet_follow)
				print("max:", world.data.statistics_max_pet_follow)
				print("me.dbid:", me.dbid, "me.rid:", me.rid)

				--更新任务
				--宠物跟随
				SendCmdFunc["task_type_finish"](hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT, world.data.statistics_max_pet_follow)
			end
		end
		
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if tInfo.stageInfo == nil then
			tInfo.stageInfo = {}
		end
		if tInfo.stageInfo[nStage] == nil then
			tInfo.stageInfo[nStage] = {}
		end
		
		if (tInfo.stageInfo[nStage]["maxtocarry_pet"] == nil) then
			tInfo.stageInfo[nStage]["maxtocarry_pet"] = 0
		end
		
		tInfo.stageInfo[nStage]["maxtocarry_pet"] = tInfo.stageInfo[nStage]["maxtocarry_pet"] + 1
		
		LuaUpdateRandMapSingleBestRecord("maxtocarry_pet", tInfo.stageInfo[nStage]["maxtocarry_pet"])  --最大携带宠物
	end
	
	--[[
	--pvp-夺塔奇兵，敌方的塔基，加个红色特效
	if (unitId == 11007) then
		local me = world:GetPlayerMe()
		local foeceMe = me:getforce()
		local forceUnit = uOwner and uOwner:getforce()
		if (me ~= uOwner) and (foeceMe ~= forceUnit) then
			--print("On_AddUnit_Special_Event", unitId, owner)
			--local w = oUnit:getworld()
			local cx,cy,cw,ch = oUnit:getbox()
			local offsetX = math.floor(cx + cw/2)
			local offsetY = -math.floor(cy + ch/2)
			local offsetZ = 0
			local effectId = 539 --499 --塔基禁用的特效
			local loop = -1
			local skillId = -1
			local effect = world:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
			effect.handle.s:setRotation(0)
			effect.handle.s:setOpacity(192)
		end
	end
	]]
	
	--pvp-铜雀台，塔基、超级塔基，加个红色特效
	if (unitId == 69997) or (unitId == 14393) then
		--不是自己位置的塔基，加个红色特效
		local me = world:GetPlayerMe()
		local posMe = me:getpos()
		local posUnit = uOwner and uOwner:getpos()
		if (me ~= uOwner) and (posMe ~= posUnit) then
			--print("On_AddUnit_Special_Event", unitId, owner)
			--local w = oUnit:getworld()
			local cx,cy,cw,ch = oUnit:getbox()
			local offsetX = math.floor(cx + cw/2)
			local offsetY = -math.floor(cy + ch/2)
			local offsetZ = 0
			local effectId = 539 --499 --塔基禁用的特效
			local loop = -1
			local skillId = -1
			local effect = world:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
			effect.handle.s:setRotation(0)
			effect.handle.s:setOpacity(192)
		end
	end
end


--======================= event ==========================
--单位死亡事件特殊处理函数
function OnChaDie_Special_Event(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
	local world = hGlobal.WORLD.LastWorldMap
	local tOwner = oDeadTarget:getowner() --死亡的单位的阵营
	local tForce = tOwner:getforce() --死亡的单位的势力
	local uOwner = 0 --击杀者的阵营
	if oKillerUnit then
		uOwner = oKillerUnit:getowner()
	end
	local skill_id = id or 0 --击杀的技能id
	local deadUnitX, deadUnitY = hApi.chaGetPos(oDeadTarget.handle) --死亡的单位的坐标
	local killerUnitX, killerUnitY = 0, 0 --击杀者的坐标
	if oKillerUnit then
		killerUnitX, killerUnitY = hApi.chaGetPos(oKillerUnit.handle)
	end
	local deadUnitTypeId = oDeadTarget.data.id --死亡的人的类型id
	local killerUnitTypeId = 0 --杀人者的类型id
	if oKillerUnit then
		killerUnitTypeId = oKillerUnit.data.id --杀人者的类型id
	end
	
	--print("OnChaDie_Special_Event", oDeadTarget.data.name, oKillerUnit and oKillerUnit.data.name)
	--print(debug.traceback())
	
	--------------------------------------------------------------
	--地上的一滩血（地面特效）
	local effIdMin = 3032
	local effIdMax = 3034
	local randValue = world:random(effIdMin, effIdMax)
	local effect_id = randValue --特效id 3032 3033 3034
	local tabU = hVar.tab_unit[deadUnitTypeId] or {}
	
	local aniKey = "dead"
	local md = hVar.tab_model[oDeadTarget.handle.modelIndex]
	local _,IsSafe = hResource.model:safeAnimation(oDeadTarget.handle,md,aniKey)
	
	--有死亡动作，飙血特效固定
	if (IsSafe == hVar.RESULT_SUCESS) then
		--effect_id = 3033
		effect_id = 3050
	end
	
	--优先读表
	if (tabU.deadEffectId) then
		if (type(tabU.deadEffectId) == "number") then
			effect_id = tabU.deadEffectId
		elseif (type(tabU.deadEffectId) == "table") then
			local randomIdx = world:random(1, #tabU.deadEffectId)
			effect_id = tabU.deadEffectId[randomIdx]
		end
	end
	
	--不是小兵或者英雄或可破坏物件、可破坏房子，不表现
	if (tabU.type ~= hVar.UNIT_TYPE.HERO) and (tabU.type ~= hVar.UNIT_TYPE.UNIT) and (tabU.type ~= hVar.UNIT_TYPE.UNITBROKEN)
	and (tabU.type ~= hVar.UNIT_TYPE.UNITBROKEN_HOUSE) and (tabU.type ~= hVar.UNIT_TYPE.UNITDOOR) then
		effect_id = 0
	end
	
	--地上的一滩血特效
	--print("effect_id=", effect_id, "deadUnitTypeId=", deadUnitTypeId)
	if effect_id and (effect_id ~= 0) then
		--geyachao: 查bug临时去掉，待恢复
		
		if (hVar.IS_SHOW_HIT_EFFECT_FLAG == 1) then --开关控制
			local bloodX = deadUnitX
			local bloodY = deadUnitY
			
			--有死亡动作，飙血特效固定
			if (IsSafe == hVar.RESULT_SUCESS) then
				--bloodX = bloodX
				bloodY = bloodY - 30
			end
			
			local eff = world:addeffect(effect_id, 1.0 ,nil, bloodX, bloodY) --56
			local angle = 0
			if (oKillerUnit) then
				local kx, ky = hApi.chaGetPos(oKillerUnit.handle)
				angle = GetLineAngle(kx, ky, deadUnitX, deadUnitY)
			end
			if eff then
				if (deadUnitTypeId ~= 11009) then --盒子
					if (effect_id >= effIdMin) and (effect_id <= effIdMax) then
						eff.handle._n:setRotation(angle + 45)
						eff.handle.s:setOpacity(168)
					end
					
					--重置z值
					local zOrder = bloodY - 50
					eff.handle._n:getParent():reorderChild(eff.handle._n, zOrder)
					
					--如果是随机地图，那么将此特效存储起来，切换关卡时待删除
					local regionId = world.data.randommapIdx
					if (regionId > 0) then
						local regionData = world.data.randommapInfo[regionId]
						if regionData then
							local blood_effects = regionData.blood_effects --飙血特效集
							if blood_effects then
								blood_effects[#blood_effects+1] = eff
							end
						end
					end
				end
			end
		end
		
	end
	
	--------------------------------------------------------------
	--死了飙血（随身特效）
	if (deadUnitTypeId ~= 11009) and (deadUnitTypeId ~= 13000) then --盒子，敌人子弹
		 --geyachao: 查bug临时去掉，待恢复
		
		if (tabU.type == hVar.UNIT_TYPE.HERO) or (tabU.type == hVar.UNIT_TYPE.UNIT) then
			local aniKey = "dead"
			local md = hVar.tab_model[oDeadTarget.handle.modelIndex]
			local _,IsSafe = hResource.model:safeAnimation(oDeadTarget.handle,md,aniKey)
			
			--有死亡动作，播放死亡动作，不需要再飙血
			if (IsSafe == hVar.RESULT_SUCESS) then
				--
			else
				local eff2 = world:addeffect(3035, 1.0 ,nil, deadUnitX, deadUnitY) --56
				if eff2 then
					eff2.handle.s:setOpacity(168)
				end
			end
		end
		
	end
	
	--print(oDeadTarget.data.name, oKillerUnit and oKillerUnit.data.name, skill_id, "d", deadUnitX, deadUnitY, "k", killerUnitX, killerUnitY, "type", deadUnitTypeId)
	
	--盒子播放音效
	if (deadUnitTypeId == 11009) then --盒子
		hApi.PlaySound("sword3")
	end
	
	--坦克播放音效
	if (deadUnitTypeId == 6000) or (deadUnitTypeId == 6012) then --坦克
		hApi.PlaySound("GyrocopterImpactHit1")
	end
	
	--坦克播放碎裂动画
	if (deadUnitTypeId == 6000) or (deadUnitTypeId == 6012) then --坦克
		--local oUnit = world:GetPlayerMe().heros[1]:getunit()
		local w = oDeadTarget:getworld()
		--播放物理特效
		--
		local hero_x, hero_y = hApi.chaGetPos(oDeadTarget.handle) --我方小兵的坐标
		local hero_bx, hero_by, hero_bw, hero_bh = oDeadTarget:getbox() --我方小兵的包围盒
		local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --我方小兵的中心点x位置
		local hero_center_y = hero_y + (hero_by + hero_bh / 2) --我方小兵的中心点y位置
		local tx, ty = hero_center_x, hero_center_y
		ty = ty - 25
		--local ox,oy = oAttacker:getXY()
		local ox = tx + 100 -- -100, 100 右上
		local oy = ty + 100 -- +100, 100 左上
		
		--geyachao: 查bug临时去掉，待恢复
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx + 0, ty + 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx + 0, ty - 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx - 100, ty + 0, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx - 100, ty - 0, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx + 100, ty + 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx + 100, ty - 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx - 100, ty + 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		xlAddPhyBrokenEffect(w.handle.worldScene,"hit_wall","wall", tx, ty, tx - 100, ty - 100, (w:random(8, 15) / 10)) --1.5 --geyachao修改时间
		
		--"hit_armor","armor"
		--"hit_body","body"
		--"hit_wall","wall"
	end
	
	local tCastParam =
	{
		level = 1, --技能的等级
	}
	
	--[[
	if (skill_id == 10061) then		--狙击塔杀人加buff
		local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		hApi.CastSkill(oKillerUnit, 10064, 0, nil, nil, gridX, gridY, tCastParam)
	end
	--]]
	
	--print("killerUnitTypeId=", killerUnitTypeId, oKillerUnit and oKillerUnit.data.bind_weapon_owner.data.id)
	--击杀者是战车，检测是否需要回血
	if oKillerUnit then
		if(killerUnitTypeId == hVar.MY_TANK_ID) or ((oKillerUnit.data.bind_weapon_owner ~= 0) and (oKillerUnit.data.bind_weapon_owner.data.id == hVar.MY_TANK_ID)) then --是战车，或者战车的武器
			local oRestoreUnit = oKillerUnit --回血者
			if (oKillerUnit.data.bind_weapon_owner ~= 0) and (oKillerUnit.data.bind_weapon_owner.data.id == hVar.MY_TANK_ID) then
				oRestoreUnit = oKillerUnit.data.bind_weapon_owner
			end
			
			--检测是否有杀敌回血技能
			local stealSkillId = 30043 --废料回收
			local skillObj = oRestoreUnit:getskill(stealSkillId)
			--print(skillObj)
			if skillObj then
				local stealSkillLv = skillObj[2]
				local hpRate = stealSkillLv * 2 --回血比例
				--local hpMax2 = oDeadTarget:GetHpMax()
				local hp_max = oRestoreUnit:GetHpMax()
				local hp = oRestoreUnit.attr.hp --当前血量
				local hp_restore = math.floor(hp_max * hpRate / 100)
				--print("hpRate=", hpRate, "hp_restore=", hp_restore)
				
				--检测是否回满血
				local new_hp = hp + hp_restore
				if (new_hp > hp_max) then
					--当前血量为最大血量
					new_hp = hp_max
				end
				
				oRestoreUnit.attr.hp = new_hp
				
				--更新英雄头像的血条(+)
				local oHero = oRestoreUnit:gethero()
				if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
					local curP = new_hp
					local maxP = hp_max
					local precent = math.ceil(curP / maxP * 100)
					--print("precent=", precent)
					
					--设置大菠萝的血条
					SetHeroHpBarPercent(oHero, curP, maxP, true)
				end
				
				--更新血条控件
				if oRestoreUnit.chaUI["hpBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					oRestoreUnit.chaUI["hpBar"]:setV(new_hp, hp_max)
					--print("oUnit.chaUI5()", new_hp, hp_max)
				end
				if oRestoreUnit.chaUI["numberBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					oRestoreUnit.chaUI["numberBar"]:setText(new_hp .. "/" .. hp_max)
				end
				
				--数字显血
				if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --显血模式
					hApi.ShowDmgNumber(0, 0, oRestoreUnit, 0, 0, 0, 0, "+" .. hp_restore, "numGreen")
				end
				
				--头顶冒字
				--绿色
				hApi.ShowLabelBubble(oRestoreUnit, "HP+" .. hp_restore, ccc3(0, 255, 0), 0, 0, 24, 2000)
			end
		end
	end
	
	--if (deadUnitTypeId == 11011) then		--分裂1
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16050, 0, nil, nil, gridX, gridY, tCastParam)
	--end
	--if (deadUnitTypeId == 11012) then		--分裂1
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16051, 0, nil, nil, gridX, gridY, tCastParam)
	--end
	--if (deadUnitTypeId == 11013) then		--分裂1
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16052, 0, nil, nil, gridX, gridY, tCastParam)
	--end
	--if (deadUnitTypeId == 11014) then		--分裂1
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16053, 0, nil, nil, gridX, gridY, tCastParam)
	--end
	
	--if (deadUnitTypeId == 12100) then		--电浆蜘蛛第二形态
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16066, 0, nil, nil, gridX, gridY, tCastParam)
	--end
	
	if (deadUnitTypeId == 11210) then		--看守所
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16084, 0, nil, nil, gridX, gridY, tCastParam)
		
		--召唤友军人质(科学家)
		for i = 1, 3, 1 do
			--创建单位
			local typeId = hVar.MY_TANK_SCIENTST_ID --人质(科学家)
			local nOwner = 21
			local facing = world:random(0, 360)
			local nLv = 1
			local nStar = 1
			local radius = 60
			local dx = world:random(-radius, radius) --随机偏移值
			local dy = world:random(-radius, radius)
			local randPosX = deadUnitX + dx --随机x位置
			local randPosY = deadUnitY + dy --随机y位置
			randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			
			--添加人质
			local oUnit = world:addunit(typeId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
			--print("添加人质")
			
			--人质进入混乱
			hApi.UnitBeginHostageChaos(oUnit)
			
			--标记是我方单位（用于搜敌优化）
			world.data.rpgunits[oUnit] = oUnit:getworldC()
		end
	end
	
	if (deadUnitTypeId == 19012) then		--宠物召唤
		--local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
		--hApi.CastSkill(oDeadTarget, 16084, 0, nil, nil, gridX, gridY, tCastParam)
		
		--召唤宠物NPC对话
		--创建单位
		local typeId = 15504 --宠物NPC对话
		local nOwner = 21
		local facing = world:random(0, 360)
		local nLv = 1
		local nStar = 1
		local radius = 60
		local dx = world:random(-radius, radius) --随机偏移值
		local dy = world:random(-radius, radius)
		local randPosX = deadUnitX + dx --随机x位置
		local randPosY = deadUnitY + dy --随机y位置
		randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
		
		--添加宠物NPC对话
		local oUnit = world:addunit(typeId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
		--print("添加宠物NPC对话")
	end
	
	--战车成就相关：同时携带的宠物数量-1
	local bIsPet = false
	for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
		if (deadUnitTypeId == walle_id) then
			bIsPet = true
		end
	end
	if bIsPet then
		-- 跟随宠物数量
		world.data.statistics_current_pet_follow = world.data.statistics_current_pet_follow - 1
		
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if tInfo.stageInfo == nil then
			tInfo.stageInfo = {}
		end
		if tInfo.stageInfo[nStage] == nil then
			tInfo.stageInfo[nStage] = {}
		end
		
		if (tInfo.stageInfo[nStage]["maxtocarry_pet"] == nil) then
			tInfo.stageInfo[nStage]["maxtocarry_pet"] = 0
		end
		
		tInfo.stageInfo[nStage]["maxtocarry_pet"] = tInfo.stageInfo[nStage]["maxtocarry_pet"] - 1
		
		if (tInfo.stageInfo[nStage]["maxtocarry_pet"] > 0) then
			LuaUpdateRandMapSingleBestRecord("maxtocarry_pet", tInfo.stageInfo[nStage]["maxtocarry_pet"])  --最大携带宠物
		end
	end
	
	
	--geyachao: 这里的位置过早，很多游戏结束写在这里面，导致无法计算击杀boss的经验和统计杀敌数，所以挪到底层
	--触发器，检测死亡者是否有死亡后释放的技能
	local Trigger_OnUnitDead_SkillId = oDeadTarget.attr.Trigger_OnUnitDead_SkillId
	if Trigger_OnUnitDead_SkillId and (Trigger_OnUnitDead_SkillId > 0) then
		--死亡者不是沉默状态
		--if (oDeadTarget.attr.suffer_chenmo_stack == 0) then
			--寻找施法目标
			local oTarget = nil
			local tabS = hVar.tab_skill[Trigger_OnUnitDead_SkillId]
			local target = tabS.target and tabS.target[1]
			if (target == "ENEMY") then
				if oKillerUnit and tabS.cast_target_type[oKillerUnit.data.type] then --能对目标施法
					oTarget = oKillerUnit
				else
					--找附近的敌人
					world:enumunitAreaEnemy(tForce, deadUnitX, deadUnitY, 500, function(eu)
						if (oTarget == nil) then
							if tabS.cast_target_type[eu.data.type] then
								oTarget = eu
							end
						end
					end)
				end
			elseif (target == "SELF") then
				oTarget = oDeadTarget
			elseif (target == "ALLY") then
				--找附近的友军
				world:enumunitAreaAlly(tForce, deadUnitX, deadUnitY, 500, function(eu)
					if (oTarget == nil) then
						if (eu ~= oDeadTarget) then --不是自己
							if tabS.cast_target_type[eu.data.type] then
								oTarget = eu
							end
						end
					end
				end)
				
				--实在找不到友军，对自己施法
				if (oTarget == nil) then
					oTarget = oDeadTarget
				end
			elseif (target == "ALL") then
				--找附近的人
				world:enumunitArea(tForce, deadUnitX, deadUnitY, 500, function(eu)
					if (oTarget == nil) then
						if (eu ~= oDeadTarget) then --不是自己
							if tabS.cast_target_type[eu.data.type] then
								oTarget = eu
							end
						end
					end
				end)
				
				--实在找不到人，对自己施法
				if (oTarget == nil) then
					oTarget = oDeadTarget
				end
			end
			
			--避免死循环
			oDeadTarget.attr.Trigger_OnUnitDead_SkillId = 0
			
			--清除世界检测
			--local world = self:getworld()
			local cha_worldC = oDeadTarget:getworldC()
			world.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
			
			local tCastParam =
			{
				level = 1, --技能的等级
			}
			local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
			print("检测死亡者是否有死亡后释放的技能", oDeadTarget.data.name, Trigger_OnUnitDead_SkillId, oTarget.data.name)
			hApi.CastSkill(oDeadTarget, Trigger_OnUnitDead_SkillId, 0, 100, oTarget, gridX, gridY, tCastParam) --固定时间的眩晕（避免滑行提前到达）
			
			--避免死循环
			--oDeadTarget.attr.Trigger_OnUnitDead_SkillId = 0
		--end
	end
	
	
	
	--geyachao: 这里的位置过早，很多游戏结束写在这里面，导致无法计算击杀boss的经验和统计杀敌数，所以挪到底层
	--触发器，检测死亡者是否有死亡后，战车释放的技能
	local Trigger_OnUnitDead_Tank_SkillId = oDeadTarget.attr.Trigger_OnUnitDead_Tank_SkillId
	if Trigger_OnUnitDead_Tank_SkillId and (Trigger_OnUnitDead_Tank_SkillId > 0) then
		--避免死循环
		oDeadTarget.attr.Trigger_OnUnitDead_Tank_SkillId = 0
		
		--寻找坦克
		local myTank = nil
		world:enumunit(function(eu)
			if (eu.data.id == hVar.MY_TANK_ID) then --我的坦克
				myTank = eu
			end
		end)
		--存在坦克
		if myTank then
			local tCastParam =
			{
				level = 1, --技能的等级
			}
			local gridX, gridY = world:xy2grid(deadUnitX, deadUnitY)
			hApi.CastSkill(myTank, Trigger_OnUnitDead_Tank_SkillId, 0, 100, myTank, gridX, gridY, tCastParam) --固定时间的眩晕（避免滑行提前到达）
			
			--避免死循环
			--oDeadTarget.attr.Trigger_OnUnitDead_Tank_SkillId = 0
		end
	end
	
	
	--随机地图模式，检测本波发兵是否有此目标
	local regionId = world.data.randommapIdx
	if (regionId > 0) then
		local regionData = world.data.randommapInfo[regionId]
		if regionData then
			local roomgroupSendArmyList = regionData.roomgroupSendArmyList --房间组发兵表 --{[n] = {groupId = XXX, x = XXX, y = XXX, beginTick = XXX, currentWave = XXX, unitperWave = {[1] = {...}, [2] = {...}, ...}, ...}
			if roomgroupSendArmyList then
				for r = 1, #roomgroupSendArmyList, 1 do
					local tSendArmyList = roomgroupSendArmyList[r]
					local currentWave = tSendArmyList.currentWave --当前波次
					if (currentWave > 0) then
						local unitperWave = tSendArmyList.unitperWave --每波单位表
						local tPreWave = unitperWave[currentWave]
						if tPreWave then
							if (tPreWave.num > 0) then
								if tPreWave[oDeadTarget] then --找到了
									tPreWave[oDeadTarget] = nil
									tPreWave.num = tPreWave.num - 1
									print("随机组[" .. r .. "]的波次[" .. currentWave .. "]的单位 " .. oDeadTarget.data.name .. " 死亡，本组剩余" .. tPreWave.num)
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	--统计本局死亡的单位次数+1
	world.data.unitdeathcounts[tForce][deadUnitTypeId] = world.data.unitdeathcounts[tForce][deadUnitTypeId] or 0
	world.data.unitdeathcounts[tForce][deadUnitTypeId] = world.data.unitdeathcounts[tForce][deadUnitTypeId] + 1
end


--======================= event ==========================
--召唤单位到时间消失特殊处理函数
function OnChaLiveTimeEnd_Special_Event(oUnit)
	local world = hGlobal.WORLD.LastWorldMap
	local tOwner = oUnit:getowner() --死亡的单位的阵营
	--local tForce = tOwner:getforce() --死亡的单位的势力
	
	--战车，自爆蜘蛛消失时自爆
	if (oUnit.data.id == 11214) then --自爆蜘蛛
		--对坦克放技能
		local me = world:GetPlayerMe()
		local heros = me.heros
		local oHero = heros[1]
		local oTarget = oHero:getunit()
		if oTarget then
			local tCastParam =
			{
				level = 1, --技能的等级
			}
			hApi.CastSkill(oUnit, 16036, 0, 100, oTarget, nil, nil, tCastParam)
		end
	end
	
	--战车，坦克变回来
	if (oUnit.data.id == hVar.MY_TANK_ID) then --坦克
		local oHero = oUnit:gethero()
		if oHero then
			local rebirthX, rebirthY = hApi.chaGetPos(oUnit.handle)
			local gridX, gridY = world:xy2grid(rebirthX, rebirthY)
			local angle = oUnit.data.facing
			local cha = oHero:enterworld(world, gridX, gridY, angle) --复活英雄
			--local oPlayer = unit:getowner()
			local oPlayerMe = world:GetPlayerMe()
			
			--重绘英雄头像控件
			if (tOwner == oPlayerMe) then
				hGlobal.event:event("LocalEvent_UpdateAllHeroIcon")
			end
			
			--播放音效
			if (tOwner == oPlayerMe) then
				hApi.PlaySound("Thunder4")
			end
			
			--替换战术技能(图标)
			--替换攻击技能
			local tabU = hVar.tab_unit[oUnit.data.id]
			local btni = world.data.tacticCardCtrls[hVar.NORMALATK_IDX]
			--local weaponItemIdOld = btni.data.itemId --道具id
			--local normalatkItemlId = tabU.normalatkItemlId
			local weaponIdx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID) --当前选中的武器索引值
			local weaponUnitId = hVar.tab_unit[hVar.MY_TANK_ID].weapon_unit[weaponIdx].unitId
			local normalatkItemlId = hVar.tab_unit[weaponUnitId].skillItemlId
			--print("normalatkItemlId=", normalatkItemlId)
			hGlobal.event:event("Event_ResetSingleTactic", hVar.NORMALATK_IDX, 0, normalatkItemlId, 1, -1, hVar.MY_TANK_ID)
			--替换英雄存储的道具技能相关参数
			local oPlayer = world:GetPlayerMe()
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					local k = hVar.NORMALATK_IDX - hVar.TANKSKILL_EMPTY
					
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
					
					--print(k, activeItemId, weaponItemIdOld)
					--print("找到了")
					itemSkillT[k].activeItemId = normalatkItemlId
					itemSkillT[k].activeItemCD = hVar.tab_item[normalatkItemlId].activeSkill.cd[activeItemLv]
				end
			end
			
			--替换扔手雷技能
			local btni = world.data.tacticCardCtrls[hVar.TANKSKILL_IDX]
			--local weaponItemIdOld = btni.data.itemId --道具id
			local weaponItemId = tabU.skillItemlId
			--print("weaponItemId=", weaponItemId)
			hGlobal.event:event("Event_ResetSingleTactic", hVar.TANKSKILL_IDX, 0, weaponItemId, 1, -1, hVar.MY_TANK_ID)
			--替换英雄存储的道具技能相关参数
			local oPlayer = world:GetPlayerMe()
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					local k = hVar.TANKSKILL_IDX - hVar.TANKSKILL_EMPTY
					
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
					
					--print(k, activeItemId, weaponItemIdOld)
					--print("找到了")
					itemSkillT[k].activeItemId = weaponItemId
					itemSkillT[k].activeItemCD = hVar.tab_item[weaponItemId].activeSkill.cd[activeItemLv]
				end
			end
			
			--刷新手雷附魔
			hGlobal.event:event("LocalEvent_ShowTacticsBuffIconFrm")
		end
	end
	
	--迷惑单位变回去
	local puzzleSkillId = 31137 --迷惑回收
	local skillObj = oUnit:getskill(puzzleSkillId)
	--print("skillObj=", skillObj)
	if skillObj then
		local puzzleSkillLv = skillObj[2]
		
		local hp = oUnit.attr.hp
		local hpMax = oUnit:GetHpMax()
		local hpRate = math.floor(hp / hpMax * 100)
		
		--替换单位
		--(oUnit, toTypeId, toOwner, effectId, strSound, pathId, delCha, lv)
		local cha = hApi.ChangeUnit(oUnit, oUnit.data.id, 22, 96, "Thunder4", nil, true, oUnit.attr.lv)
		
		--刷新单位的血条
		cha.attr.hp = math.floor(cha:GetHpMax() * hpRate / 100)
		
		--更新血条控件
		if cha.chaUI["hpBar"] then
			cha.chaUI["hpBar"]:setV(cha.attr.hp, cha:GetHpMax())
		end
		if cha.chaUI["numberBar"] then
			cha.chaUI["numberBar"]:setText(cha.attr.hp .. "/" .. cha:GetHpMax())
		end
	end
end

--======================= event ==========================
--野怪重生事件特殊处理
function OnWildRelive_Special_Event(oWildUnit, deadUnitTypeId, wildRebirthTime)
	local world = hGlobal.WORLD.LastWorldMap
	local tOwner = oWildUnit:getowner() --野怪的阵营
	local wildX, wildY = hApi.chaGetPos(oWildUnit.handle)
	local tgrData = oWildUnit:gettriggerdata()
	--@wildShowRebirthTime %是否显示野怪刷新时间
	
	--铜雀台-黄龙（左）、黄龙（右）
	if (deadUnitTypeId == 30003) or (deadUnitTypeId == 30005) then
		--插个旗子，显示复活倒计时
		--在原地创建一个倒计时的单位
		--复活专用旗子角色
		local type_id = 55556 --魏国
		local facing = hVar.UNIT_DEFAULT_FACING
		local deadoUint = world:addunit(type_id, 1, nil, nil, facing, wildX, wildY)
		local rebirthtime = wildRebirthTime --复活时间（毫秒）
		--print(oUnit.data.name, rebirthtime, deadoUint)
		
		--复活倒计时进度条
		local dx = -30
		local dy = 50
		deadoUint.chaUI["rebirthProgress"] = hUI.valbar:new({
			parent = deadoUint.handle._n,
			x = dx,
			y = dy,
			w = 34,
			h = 4,
			align = "LC",
			back = {model = "UI:BAR_ValueBar_BG", x = -2},
			model = "UI:IMG_ValueBar",
			animation = "blue",
			v = 1,
			max = 1,
			show = 1,
		})
		
		--复活倒计时文字
		deadoUint.chaUI["numberBar"] = hUI.label:new({
			parent = deadoUint.handle._n,
			font = hVar.DEFAULT_FONT,
			--text = math.ceil(rebirthtime / 1000) .. "秒后复活", --language
			--text = math.ceil(rebirthtime / 1000) .. hVar.tab_string["__SecondToRelive"], --language
			text = math.ceil(rebirthtime / 1000),
			size = 16,
			align = "MC",
			x = dx + 15,
			y = dy + 15,
			border = 1,
		})
		deadoUint.chaUI["numberBar"].handle.s:setColor(ccc3(255, 0, 0))
		
		--加入到表中
		local t =
		{
			oDeadHero = 0, --死亡的英雄
			deadoUint = deadoUint,
			roadPoint = 0, --把该英雄的路点存下来，复活时继续沿路点走路
			
			beginTick = world:gametime(), --当前时间
			rebithTime = rebirthtime,
			progressUI = deadoUint.chaUI["rebirthProgress"],
			labelUI = deadoUint.chaUI["numberBar"],
			--CDLabel = CDLabel, --头像栏显示复活数字倒计时
		}
		table.insert(world.data.rebirthT, t)
		--print("添加对应的复活表", #oWorld.data.rebirthT)
	end
end

--======================= event ==========================
--碰撞类飞行特效，碰到单位回调事件特殊处理函数
function OnFlyeff_Collision_Unit_Event(effectId, skillId, coll_x, coll_y, fly_angle, fly_begin_x, fly_begin_y, caster_unsafe, caster_worldC, caster_side, caster_pos, caster_typeId, oTarget, oAction_unsafe, oAction_tempValue)
	local world = hGlobal.WORLD.LastWorldMap
	
	--施法者
	local oCaster = nil
	if (caster_unsafe:getworldC() == caster_worldC) then --caster_unsafe为不安全施法者，可能此时已死，或被复用，需要进一步检测
		oCaster = caster_unsafe
	end
	
	--技能物体temp表
	--local tempValue = oAction.data.tempValue
	local tempValue = oAction_tempValue
	--tempValue[]
	
	--print("飞行特效命中", "effectId=" .. effectId, "skillId=" .. skillId, "fly_angle=" .. fly_angle, fly_begin_x, fly_begin_y, oCaster and oCaster.data.name, caster_worldC, caster_side, caster_pos, caster_typeId, oTarget.data.name, oAction_unsafe, oAction_tempValue)
	
	--滚石塔的滚石命中单位的回调
	if (effectId == 511) and (skillId == 10071) then
		if (oTarget.data.type == hVar.UNIT_TYPE.UNIT) and (oTarget:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then --只击退普通单位、地面单位
			--目标不在隐身状态
			if (oTarget:GetYinShenState() ~= 1) then --是否在隐身状态
				--学习击退技能的等级
				local jituiLv = tempValue["@jituiLv"] or 0
				--print(jituiLv)
				if (jituiLv > 0) then
					local t_x, t_y = hApi.chaGetPos(oTarget.handle)
					local dis = 20 + jituiLv * 20 --40, 60, 80, 100, 120
					local fangle = fly_angle * math.pi / 180 --弧度制
					local x = t_x + dis * math.cos(fangle)
					local y = t_y + dis * math.sin(fangle)
					hApi.ChaMoveByTrack(oTarget, x, y, 100)
					
					local tCastParam =
					{
						level = jituiLv, --技能的等级
					}
					hApi.CastSkill(oCaster, 10076, 0, 100, oTarget, nil, nil, tCastParam) --固定时间的眩晕（避免滑行提前到达）
				end
				
				--pvp模式，如果是骑兵，造成额外伤害
				if world and world.data.tdMapInfo and (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
					--是否是骑兵
					local bIsRider = (hVar.tab_unit[oTarget.data.id].tag and hVar.tab_unit[oTarget.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_RIDER])
					if bIsRider then
						--对骑兵造成额外的伤害
						if oCaster then
							local nDmgMode = 1 --伤害类型(0:真实伤害 / 1:物理伤害 / 2:法术伤害)
							local nDmg = oCaster:GetAtk() * 2 --施法者2倍攻击力的额外伤害
							hGlobal.event:call("Event_UnitDamaged", oTarget, skillId, nDmgMode,nDmg, 0, oCaster, nil, caster_side, caster_pos)
						end
					end
				end
			end
		end
	elseif (skillId == 31075) then   ---超级滚石塔
		if (oTarget.data.type == hVar.UNIT_TYPE.UNIT) and (oTarget:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then --只击退普通单位、地面单位
			--目标不在隐身状态
			if (oTarget:GetYinShenState() ~= 1) then --是否在隐身状态
				--学习击退技能的等级
				local jituiLv = tempValue["@jituiLv"] or 0
				--print(jituiLv)
				if (jituiLv > 0) then
					local t_x, t_y = hApi.chaGetPos(oTarget.handle)
					local dis = 20 + jituiLv * 20 --40, 60, 80, 100, 120
					local fangle = fly_angle * math.pi / 180 --弧度制
					local x = t_x + dis * math.cos(fangle)
					local y = t_y + dis * math.sin(fangle)
					hApi.ChaMoveByTrack(oTarget, x, y, 1000)
					hApi.CastSkill(oCaster, 31078, 0, 100, oTarget, nil, nil, nil) --固定时间的眩晕（避免滑行提前到达）
				end
			end
		end
	end
	
	--print("skillId", skillId)
	if (skillId == 12031) or (skillId == 22031) then --大菠萝离子炮
		if oCaster then --施法者存在
			--释放技能
			--12032
			local castskillId = 12032
			local gridX, gridY = world:xy2grid(coll_x, coll_y)
			local tCastParam =
			{
				level = 1, --技能等级
			}
			hApi.CastSkill(oCaster, castskillId, 0, 100, nil, gridX, gridY, tCastParam)
		else --施法者死亡
			--取阵营的上帝
			local oAttackerGod = world:GetPlayer(caster_pos):getgod()
			if oAttackerGod then
				--释放技能
				--12032
				local castskillId = 12032
				local gridX, gridY = world:xy2grid(coll_x, coll_y)
				local tCastParam =
				{
					level = 1, --技能等级
				}
				hApi.CastSkill(oAttackerGod, castskillId, 0, 100, nil, gridX, gridY, tCastParam)
			end
		end
	end
end


--======================= event ==========================
--伤害前事件特殊处理函数
function On_Hp_Dmg_Before_Special_Event(oDmgUnit, skillId, mode, dmg, oAttacker, oAttackerSide, oAttackerPos)
	local world = hGlobal.WORLD.LastWorldMap
	local hpNow = oDmgUnit.attr.hp --单位的当前血量
	local hpMax = oDmgUnit:GetHpMax() --最大血量
	
	local unit_id = oDmgUnit.data.id --死亡的人的类型id
	
	--[[
	--典韦狂暴处理，免疫致死伤
	if (unit_id == 18016) or (unit_id == 18116) then
		if (hpNow <= dmg) then
			local buff = oDmgUnit:getBuffById(14055)
			if (buff ~= nil) then
				dmg = 0
			end
		end
	end
	]]
	
	--检测是否有宠物+1的属性
	if (unit_id == 12217) or (unit_id == 13051) or (unit_id == 13052) or (unit_id == 13053) or (unit_id == 13054) then
		local AttackBounceEx = oDmgUnit.attr.AttackBounceEx
		if (AttackBounceEx > 0) then
			--本次免伤，并且血量回满
			if (hpNow <= dmg) then
				local hpMax = oDmgUnit:GetHpMax()
				
				--标记新的血量
				oDmgUnit.attr.hp = hpMax
				
				--扣掉一次
				oDmgUnit.attr.AttackBounceEx = AttackBounceEx - 1
				
				--更新血条控件
				if oDmgUnit.chaUI["hpBar"] then
					oDmgUnit.chaUI["hpBar"]:setV(hpMax, hpMax)
					--print("oUnit.chaUI5()", hpMax, hpMax)
				end
				if oDmgUnit.chaUI["numberBar"] then
					oDmgUnit.chaUI["numberBar"]:setText(hpMax .. "/" .. hpMax)
				end
				
				--抵挡伤害
				hApi.ShowLabelBubble(oDmgUnit, "Resist injury", ccc3(0, 255, 0), 0, 0, 24, 2000)
				
				dmg = 0
			end
		end
	end
	
	--可破坏房子，每次固定伤害1/N
	if (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then
		if (dmg > 0) then
			local hp_max = oDmgUnit:GetHpMax()
			dmg = math.ceil(hp_max / hVar.UNITBROKEN_DEADCOUNT)
		end
	end
	
	--受伤害的是战车，检测是否抵挡伤害
	if (unit_id == hVar.MY_TANK_ID) then
		--依次遍历目标是否有此buff
		local skillId = 30047
		local oBuff = oDmgUnit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			--删除buff
			oBuff:del_buff()
			
			--头顶冒字
			--绿色
			--抵挡伤害
			--hApi.ShowLabelBubble(oDmgUnit, "Resist injury", ccc3(0, 255, 0), 0, 0, 24, 2000)
			
			--伤害为0
			dmg = 0
		end
	end
	
	--检测是否有伤害变治疗buff
	--if (unit_id == hVar.MY_TANK_ID) then
		--依次遍历目标是否有此buff
		local skillId = 802
		local oBuff = oDmgUnit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			--删除buff
			--oBuff:del_buff()
			
			--伤害变治疗
			local hp_restore = dmg
			
			--检测是否回满血
			local new_hp = hpNow + hp_restore
			if (new_hp > hpMax) then
				--当前血量为最大血量
				new_hp = hpMax
			end
			
			--标记新的血量
			oDmgUnit.attr.hp = new_hp
			--print(oDmgUnit.data.name, "hpNow=", hpNow, "hp_restore=", hp_restore, "new_hp=", new_hp)
			
			--更新英雄头像的血条(+)
			local oHero = oDmgUnit:gethero()
			if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
				--oHero.heroUI["hpBar"]:setV(new_hp, hpMax)
				--设置大菠萝的血条
				SetHeroHpBarPercent(oHero, new_hp, hpMax, true)
			end
			
			--更新血条控件
			if oDmgUnit.chaUI["hpBar"] then
				if (hpMax <= 0) then
					hpMax = 1
				end
				oDmgUnit.chaUI["hpBar"]:setV(new_hp, hpMax)
				--print("oUnit.chaUI5()", new_hp, hpMax)
			end
			if oDmgUnit.chaUI["numberBar"] then
				if (hpMax <= 0) then
					hpMax = 1
				end
				oDmgUnit.chaUI["numberBar"]:setText(new_hp .. "/" .. hpMax)
			end
			
			--伤害为0
			dmg = 0
		end
	--end
	
	--受伤害的是战车，检测是否是禁止操作的状态，此时战车是无敌的
	if (unit_id == hVar.MY_TANK_ID) then
		--禁止响应事件，战车不受伤害
		if (world.data.keypadEnabled ~= true) then
			dmg = 0
		end
	end
	
	return dmg
end


--======================= event ==========================
--非pvp模式，单位到达终点前特殊处理函数
function On_Unit_Reached_Special_Event(oUnit)
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	local owner = oUnit:getowner()
	local me = world:GetPlayerMe()
	local unitX, unitY = hApi.chaGetPos(oUnit.handle) --单位的坐标
	local typeId = oUnit.data.id --类型id
	local forceMe = me:getforce() --我的势力
	local bIsEnemy = (me and (owner:getforce() ~= forceMe)) --是否和我为敌人
	local forcePlayerMe = world:GetForce(forceMe)
	local life = forcePlayerMe:getresource(hVar.RESOURCE_TYPE.LIFE) --我的生命点数
	local costLife = oUnit:GetEscapePunish() --漏怪惩罚扣除的点数
	if (costLife < 0) then
		costLife = 0
	end
	
	if (typeId == 14192) then --运粮车
		if (not bIsEnemy) then --非敌人
			--头顶冒字，加生命点数
			--绿色
			hApi.ShowLabelBubble(oUnit, "+1", ccc3(0, 255, 0), 15, 20, nil, 2500, {model = "ui/Attr_Hp.png", x = -32, y = 1, w = 22, h = 18,})
			
			--加生命点数
			local lifeAdd = 1
			forcePlayerMe:addresource(hVar.RESOURCE_TYPE.LIFE, lifeAdd)
			--刷新界面
			hGlobal.event:event("Event_TdLifeChangeRefresh")
		end
	end
end


--======================= event ==========================
--闪避伤害后事件特殊处理函数
function On_Unit_Dodge_Dmg_Event(oUnit, oAttaker, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
	--print("On_Unit_Dodge_Dmg_Event", oUnit.data.name, oAttaker.data.name, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
	local world = hGlobal.WORLD.LastWorldMap
	local owner = oUnit:getowner()
	local me = world:GetPlayerMe()
	local unitX, unitY = hApi.chaGetPos(oUnit.handle) --单位的坐标
	local typeId = oUnit.data.id --类型id
	local forceMe = me:getforce() --我的势力
	local bIsEnemy = (me and (owner:getforce() ~= forceMe)) --是否和我为敌人
	
	--
end

--======================= event ==========================
--设置游戏的层数回调函数
function On_SetGameRound_Special_Event(world, stage)
	--local mapName = world.data.map --地图名
	local mapInfo = world.data.tdMapInfo
	

end

--======================= event ==========================
--单位地图内传送后回调函数
function On_UnitTransport_Special_Event(world, stage, oUnit, toX, toY)
	local unitId = oUnit.data.id
	--print(unitId, stage)
	
end

--======================= event ==========================
--本地选中单位特殊处理事件
function On_Local_TDUnitActived_Special_Event(world, oUnit)
	if world and oUnit then
		local mapInfo = world.data.tdMapInfo
		--
	end
end

--======================= event ==========================
--游戏内造塔完成特殊处理事件
function On_BuildTower_Special_Event(oPlayer, oUnit)
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	local uOwner = oUnit:getowner()
	
	--只处理属于玩家的单位
	--if (oPlayer == uOwner) then
		--只处理塔
		--oPlayer:tower_addonesTakeEffect(world, oUnit)
	--end
end

--======================= event ==========================
--弹射前特殊处理回调
function On_Effect_Tanshe_Before_Special_Event(effectId, oUnit, skillId, skillLv, tansheCount, tansheMaxCount)
	--print("弹射前特殊处理回调", effectId, oUnit.data.name, skillId, skillLv, tansheCount, tansheMaxCount)
	
	--if (effectId == 3152) then
		--effectId = 3068
	--elseif (effectId == 3068) then
		--effectId = 3152
	--end
	
	--print(effectId)
	return effectId
end

--======================= event ==========================
--游戏内波次发生变化特殊处理事件
function OnGameWaveChanged_Special_Event(wave)
	local world = hGlobal.WORLD.LastWorldMap
	local mapName = world.data.map --地图名
	local mapInfo = world.data.tdMapInfo
	local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	
	--print("OnGameWaveChanged_Special_Event", wave)
	
	--自由造塔模式，第1波创建查看按钮
	if (mapInfo.freeBuildTowerMode == 1) then --自由造塔模式
		if (wave == 1) then
			--iPhoneX黑边宽
			local iPhoneX_WIDTH = 0
			if (g_phone_mode == 4) then --iPhoneX
				iPhoneX_WIDTH = 80
			end
			local _frm = hGlobal.UI.TDSystemMenuBar
			--print("_frm=", _frm)
			if _frm then
				--创建查看科技点按钮
				_frm.childUI["btnTechnology"] = hUI.button:new({
					parent = _frm.handle._n,
					x = 35 + iPhoneX_WIDTH,
					y = hVar.SCREEN.h - 110,
					align = "MC",
					dragbox = _frm.childUI["dragBox"],
					model = "misc/skillup/talk_2.png",
					w = 36*0.01,
					h = 36*0.01,
					scaleT = 0.95,
					code = function()
						--...
					end,
				})
			end
		end
	end
	
	--自由造塔模式下，每波加1次科技次数
	if (mapInfo.freeBuildTowerMode == 1) then
		--找到科技单位（可能存在多个）
		local oUnitList = {}
		world:enumunit(function(eu)
			if (eu.data.id == 17002) or (eu.data.id == 17019) then --找我的 科技单位
				--if (eu:getowner() == oPlayerMe) then --我方
					oUnitList[#oUnitList+1] = eu
				--end
			end
		end)
		
		--存在科技单位
		for i = 1, #oUnitList, 1 do
			local oUnit = oUnitList[i]
			if oUnit then
				local activeSkillId = oUnit.td_upgrade.castSkill.order[1]
				local skillObj = oUnit:getskill(activeSkillId)
				--local castSkillInfo = oUnit.td_upgrade.castSkill[activeSkillId]
				if skillObj then
					--改到动画完了再加点数
					--skillObj[4] = skillObj[4] + 1
					
					--头顶冒字
					--local addNum = 1
					--hApi.ShowLabelBubble(oUnit, "+" .. addNum, ccc3(255, 255, 255), 16, 5, 20, 3000, {model = "ICON:skill_icon3_x1y1", x = -32, y = 2, w = 28, h = 28,})
					
					--动画表现加科技点数
					local _frm = hGlobal.UI.TDSystemMenuBar
					--print("_frm=", _frm)
					if _frm then
						local btnTechnology = _frm.childUI["btnTechnology"] or _frm.childUI["TopBar"]
						if btnTechnology then
							--if hVar._button then
							--	hVar._button:del()
							--	hVar._button = nil
							--end
							hApi.clearTimer("__TD__ENDLESS_WAVE_ADD_AMNIM_")
							--print("btnTechnology=", btnTechnology)
							--创建一个动画
							local ctrlX = _frm.data.x + btnTechnology.data.x
							local ctrlY = _frm.data.y + btnTechnology.data.y
							--print("ctrlX=", ctrlX)
							--print("ctrlY=", ctrlY)
							local fromX, fromY = hApi.view2world(ctrlX, hVar.SCREEN.h - ctrlY)
							--print("fromX=", fromX)
							--print("fromY=", fromY)
							
							local eu_x, eu_y = hApi.chaGetPos(oUnit.handle)
							local eu_bx, eu_by, eu_bw, eu_bh = oUnit:getbox() --单位的包围盒
							local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
							local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
							--local csx, csy = hApi.world2view(eu_center_x, eu_center_y) --中心点的屏幕坐标
							--local lsx, lsy = hApi.world2view(eu_x, eu_y) --脚底板的屏幕坐标
							local toX = eu_center_x
							local toY = eu_center_y
							
							local ctrl1 = hUI.button:new({
								parent = oUnit:getworld().handle.worldLayer,
								model = "misc/skillup/talk_2.png",
								x = fromX,
								y = -fromY,
								z = 10000,
								w = 12,
								h = 12,
							})
							--hVar._button = ctrl1
							
							--地上的buff动画
							local ACTTIME = 1.6
							local config = ccBezierConfig:new()
							config.controlPoint_1 = ccp(fromX, -fromY)
							config.controlPoint_2 = ccp(fromX + (toX - fromX) / 10, (-fromY + ((-toY) - (-fromY)) / 2))
							config.endPosition = ccp(toX, -toY)
							local moveto = CCEaseSineInOut:create(CCBezierTo:create(ACTTIME, config))
							
							local scaleToSmall = CCScaleTo:create(ACTTIME, 1.5) --变大
							local rot = CCRotateBy:create(ACTTIME, 720) --旋转
							local spawn1 = CCSpawn:createWithTwoActions(scaleToSmall, rot) --同步1
							local spawn2 = CCSpawn:createWithTwoActions(moveto, spawn1) --同步1
							--local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
							
							local callback1 = CCCallFunc:create(function()
								ctrl1:setstate(-1)
							end)
							local delay1 = CCDelayTime:create(0.2)
							local callback2 = CCCallFunc:create(function()
								--头顶冒字
								local addNum = 1
								hApi.ShowLabelBubble(oUnit, "+" .. addNum, ccc3(255, 255, 255), 25, 5, 20, 2000, {model = "misc/skillup/talk_2.png", x = -46, y = 2, w = 28, h = 28,})
								
								--播放音效
								hApi.PlaySound("build4")
							end)
							local delay2 = CCDelayTime:create(0.1)
							local callback3 = CCCallFunc:create(function()
								--发送指令加科技点数
								local t_worldI = oUnit:getworldI()
								local t_worldC = oUnit:getworldC()
								hApi.AddCommand(hVar.Operation.UpgrateTowerCount,t_worldI, t_worldC, skillObj[1], skillObj[4])
								
								ctrl1:del()
							end)
							local a = CCArray:create()
							a:addObject(spawn2)
							a:addObject(callback1)
							a:addObject(delay1)
							a:addObject(callback2)
							a:addObject(delay2)
							a:addObject(callback3)
							ctrl1.handle._n:runAction(CCSequence:create(a))
						end
					end
				end
			end
		end
	end
	
	--前哨阵低地图，当前波次发送到排行榜
	if (world.data.map == hVar.QianShaoZhenDiMap) then
		--更新排名（前哨阵地）
		local bId = 2
		SendCmdFunc["update_billboard_rank"](bId, wave)
	end
end

--======================= event ==========================
--改变建筑的使用次数的特殊处理事件
function On_BuildingSkillCountChanged_Special_Event(oPlayer, oTarget, skillId)
	local world = hGlobal.WORLD.LastWorldMap
	
	--铁人科技发光效果
	if (oTarget.data.id == 17002) or (oTarget.data.id == 17019) then
		local skillObj = oTarget:getskill(skillId)
		if skillObj then
			local skillCount = skillObj[4]
			
			if (skillCount > 0) then
				oTarget:setanimation("stand")
			elseif (skillCount == 0) then
				oTarget:setanimation("stand2")
			end
		end
	end
end

--======================= event ==========================
--使用战术(道具)技能特殊事件
function On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, oTarget, activeSkillBindHero, activeIndex)
	print("On_UseTacticCard_Special_Event", oPlayer.data.name, tacticId, itemId, worldX, worldY, oUnit.data.name, oTarget, activeSkillBindHero, activeIndex)
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	
	if (world == nil) then
		return
	end
	
	--本局从未使用一次战术卡模式
	if (world.data.tactic_use_state == 0) then
		--使用的是战术卡
		if (activeIndex > hVar.NORMALATK_IDX) then
			--删除全部战术卡的描边特效动画
			local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
			for i = 1, #tacticCardCtrls, 1 do
				local btn = tacticCardCtrls[i]
				if btn and (btn ~= 0) then
					if btn.childUI["bolder_amin"] then
						btn.childUI["bolder_amin"]:del()
						btn.childUI["bolder_amin"] = nil
					end
				end
			end
			
			--标记本局已使用过战术卡
			world.data.tactic_use_state = 1
		end
	end
end

--======================= event ==========================
--添加战术(道具)技能特殊事件
function On_AddacticCard_Special_Event(oPlayer, tacticId, itemId, oHero, activeIndex)
	--print("On_AddacticCard_Special_Event", oPlayer, tacticId, itemId, oHero, activeIndex)
	local world = hGlobal.WORLD.LastWorldMap
	
	if (world == nil) then
		return
	end
	
	--引导图
	if (world.data.map == hVar.GuideMap) then
		if (activeIndex > hVar.NORMALATK_IDX) then
			local map0GuideState = LuaGetPlayerGuideState(g_curPlayerName, "world/csys_000", 1) --玩家第一次玩第0关
			--print("map0GuideState=", map0GuideState)
			if (map0GuideState == 0) then
				--CreateGuideFrame_Map001() --geyachao: 应王总要求，这里的引导去掉
			end
		end
	end
end