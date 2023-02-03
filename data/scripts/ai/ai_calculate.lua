heroGameAI = {}

heroGameAI.CalculateSystem = {}
heroGameAI.CalculateSystem.CALC_TYPE_DEF = {COMBATSCORE = "CombatScore",CAPTUREUNIT = "CaptureUnit",LONGRANGESCORE = "LongRangeScore"}
heroGameAI.CalculateSystem.FUNC_TAB = {}
heroGameAI.CalculateSystem.enableLog = false

local function CalcSysLog(filename,info)
	if heroGameAI.CalculateSystem.enableLog then
		xlLG(filename,info)
	end 
end

local function CalculateCombatScore(self,mode)
	--print("CalculateCombatScore ")
	if self and self.data then
		local d = self.data
		if d.team==0 then
			return -1
		else
			local unitScore = 0
			local heroScore = 0
			local heroLea = 0
			local heroLed = 0
			for i = 1,hVar.TEAM_UNIT_MAX do
				if type(d.team[i])=="table" then
					if d.team[i][1]~=0 then
						--print("CalculateCombatScore " .. hVar.tab_unit[d.team[i][1]].name)
						local tTab = hVar.tab_unit[d.team[i][1]]
						if nil == tTab then
							--print("errorerrorerrorerrorerrorerrorerrorerrorerror BOSSname:" .. self.data.name .. " BOSSid:" .. self.data.id .. " id:" .. d.team[i][1] .. " num:" .. d.team[i][2])
							break
						end
						local nScoreBasic = (hVar.UNIT_COMBAT_SCORE[tTab.unitlevel or 0] or hVar.UNIT_COMBAT_SCORE[#hVar.UNIT_COMBAT_SCORE])[1] + (tTab.combat_score or 0)
						local num = d.team[i][2]
						if d.team[i][1] == d.id then
							local oHero = self:gethero()
							if oHero then
								--local heroLevel = (hVar.HERO_EXP[oHero.attr.level] or 0)+50
								--30 + oHero.attr.level
								local a = oHero.attr
								local mxhp = math.max(a.hp,a.mxhp)
								local nHeroScore = hApi.floor((a.lea+a.led+a.str*3+a.int*3+mxhp/3)*(a.hp/mxhp)*(4+a.level)/40+a.level*20)
								heroLea = math.max(heroLea,a.lea)
								heroLed = math.max(heroLea,a.led)
								if self.data.IsAi==1 then
									--AI英雄基础战斗力/2
									nHeroScore = hApi.floor(nHeroScore/2)
								end
								heroScore = heroScore + nHeroScore
								local tgrData = self:gettriggerdata()
								if tgrData and type(tgrData.HeroCombatScore)=="number" then
									heroScore = heroScore + tgrData.HeroCombatScore
								end
							else
								heroScore = heroScore + nScoreBasic * num
							end
						elseif d.team[i][1]==10008 then
							--投石车的战斗力只有3
							unitScore = unitScore + 3 * num
						else
							unitScore = unitScore + nScoreBasic * num
						end
					end
				end
			end
			if mode=="Basic" then
				return unitScore + heroScore
			else
				local exScore = 0
				local exPec = 0
				if d.curTown and d.curTown~=0 then
					local oTown = hClass.town:find(d.curTown)
					if oTown and oTown:getunit("guard")==self then
						--如果守城的话，认为增加了10%的战斗实力,且每级城防+25战斗力，每个箭塔+50战斗力
						exPec = exPec + 10
						local tLv = oTown:gettech("towerlevel")
						local dLv = oTown:gettech("deflevel")
						exScore = exScore + tLv*25 + dLv*50
					end
				end
				--单位的战斗力获得英雄攻防的加成
				exScore = exScore + hApi.floor(unitScore*(100+(heroLea+heroLed)/4+exPec)/100)
				if mode=="All" then
					return heroScore + exScore,heroScore + unitScore
				else
					return heroScore + exScore
				end
			end
		end
	end
end

local function CalculateCaptureUnit(self)
	--print("CalculateCaptureUnit ")
	if self and self.data then
		local d = self.data
		if d.team==0 then
			return
		else
			local num
			for i = 1,hVar.TEAM_UNIT_MAX do
				if type(d.team[i])=="table" and d.team[i][1]==self.data.id and d.team[i][2]~=0 then
					num = (num or 0)+d.team[i][2]
				end
			end
			if num and num>0 then
				return self.data.id,num
			else
				return
			end
		end
	end
end

local function isLongRangeUnit(tTab)
	if type(tTab) == "table" then
		local type_ex = tTab.type_ex
		if type(type_ex) == "table" then
			for i =1,#type_ex do
				if (type_ex[i] == "RANGE") or (type_ex[i] == "WIZARD") or (type_ex[i] == "LEGEND") then
					return true
				end
			end
		end
	end

	return false
end

local function CalculateLongRangeScore(self)
	if self and self.data then
		local d = self.data
		if d.team==0 then
			return -1
		else
			local unitScore = 0
			local heroScore = 0
			local heroLea = 0
			local heroLed = 0
			for i = 1,hVar.TEAM_UNIT_MAX do
				if type(d.team[i])=="table" then
					if d.team[i][1]~=0 then
						--print("CalculateCombatScore " .. hVar.tab_unit[d.team[i][1]].name)
						local tTab = hVar.tab_unit[d.team[i][1]]
						if nil == tTab then
							--print("errorerrorerrorerrorerrorerrorerrorerrorerror BOSSname:" .. self.data.name .. " BOSSid:" .. self.data.id .. " id:" .. d.team[i][1] .. " num:" .. d.team[i][2])
							break
						end
						local nScoreBasic = (hVar.UNIT_COMBAT_SCORE[tTab.unitlevel or 0] or hVar.UNIT_COMBAT_SCORE[#hVar.UNIT_COMBAT_SCORE])[1] + (tTab.combat_score or 0)
						local num = d.team[i][2]
						if d.team[i][1] == d.id then
							if isLongRangeUnit(tTab) == true then
								heroScore = heroScore + nScoreBasic * num
							end
						elseif d.team[i][1] == 10008 then
							--投石车的战斗力只有3
							unitScore = unitScore + 3 * num
						else
							if isLongRangeUnit(tTab) == true then
								unitScore = unitScore + nScoreBasic * num
							end
						end
					end
				end
			end
			
			return unitScore + heroScore
		end
	end	
end

function heroGameAI.CalculateSystem.Calculate(self,target,calcType)
	if calcType == heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE then
		return CalculateCombatScore(self)
	elseif calcType == heroGameAI.CalculateSystem.CALC_TYPE_DEF.CAPTUREUNIT then
		return CalculateCaptureUnit(self)
	elseif calcType == heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE then
		return CalculateLongRangeScore(self)
	end
end

heroGameAI.CalculateSystem.FUNC_TAB["CombatScore"] = CalculateCombatScore
heroGameAI.CalculateSystem.FUNC_TAB["CaptureUnit"] = CalculateCaptureUnit
heroGameAI.CalculateSystem.FUNC_TAB["LongRangeScore"] = CalculateLongRangeScore

-------------------------------
--计算战斗伤害(self,目标，伤害值，技能id，伤害类型)
--返回:最大伤害，最小伤害
heroGameAI.CalculateSystem.FUNC_TAB["CombatDamage"] = function(self, oTarget, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
	--geyahao
	--print("计算战斗伤害, oTarget=" .. oTarget.data.name .. ",dMin=" .. dMin .. ", dMax=" .. dMax .. ", nSkillId=" .. nSkillId .. ", nDamageMode=" .. tostring(nDamageMode) .. ", IsAttack=" .. tostring(IsAttack))
	
	--geyachao: 同步日志: 伤害
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "dmg: oUnit=" .. self.data.id .. ",u_ID=" .. self:getworldC() .. ",oTarget=" .. oTarget.data.id .. ",t_ID=" .. oTarget:getworldC() .. ",dMin=" .. dMin .. ",dMax=" .. dMax .. ",nPower=" .. tostring(nPower) .. ",nSkillId=" .. tostring(nSkillId) .. ",nDamageMode=" .. tostring(nDamageMode) .. ",IsAttack=" .. tostring(IsAttack)
		hApi.SyncLog(msg)
	end
	
	local d = self.data
	local a = self.attr
	local world = self:getworld()
	
	--print("dMin=" .. dMin, "dMax=" .. dMax)
	--[[
	--建筑物承受伤害流程(攻城)
	if oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
		--造成攻城伤害
		return a.siege*a.stack,a.siege*a.stack
	end

	--nPower以100为标准
	
	--local u_lea = math.floor(self.attr.lea*4/5)	--自己的统率攻击(1点统帅相当于削减了目标0.8护甲)
	local u_lea = self.attr.lea
	local u_led = self.attr.led	--自己的统率防御
	local u_pen = self.attr.pen	--自己的穿透
	local t_lea = oTarget.attr.lea	--目标的统率攻击
	local t_led = oTarget.attr.led	--目标的统率防御
	local t_def = oTarget.attr.def	--目标的护甲
	local nPercent = 100		--掩护伤害百分比
	local nPowerEx = 100		--额外伤害百分比
	local dmgPecPerAtk = 1		--每点统率影响攻击改这里
	local rAtk = 0
	if t_def>=0 then
		--我方拥有正的护甲的时候,最终护甲=我方防御+我方护甲-攻方统帅-攻方破甲
		local nDef = hApi.NumBetween(t_led + t_def - u_lea - u_pen,0,150)
		if nDef>0 then
			rAtk = -1*nDef
		end
	else
		--我方拥有负数的护甲的时候,最终护甲=我方防御-攻方统帅-攻方破甲
		local nDef = t_led - u_lea - u_pen
		if nDef>0 then
			--抵消后仍然拥有正数的护甲
			rAtk = -1*math.min(150,nDef + t_def)
		else
			--完全抵消后负数护甲被视作伤害加成
			rAtk = -1*t_def
		end
		rAtk = math.min(400,rAtk)	--最多获得400%加成
	end
	--非英雄单位对英雄单位造成的治疗超过(Var.UNIT_DAMAGE_TO_HERO_NORMAL)只便开始递减,至多造成(hVar.UNIT_DAMAGE_TO_HERO_MAX)只单位的伤害
	local nStp = hVar.UNIT_DAMAGE_TO_HERO_NORMAL
	local nCap = hVar.UNIT_DAMAGE_TO_HERO_MAX + hVar.UNIT_DAMAGE_TO_HERO_BY_LEVEL
	if self.attr.heroic==0 and oTarget.attr.heroic~=0 then
		local oHero = oTarget:gethero()
		if oHero then
			nCap = nCap + (math.max(1,oHero.attr.level)-1)*hVar.UNIT_DAMAGE_TO_HERO_BY_LEVEL
		end
	end
	
	-- -1模式的伤害不计算减免
	if nDamageMode==-1 then
		rAtk = 0
		nPower = 100
	else
		--对自己造成伤害是一种特殊的情况,任何大于0的攻击力将被忽略
		--并且伤害比率超过100%的部分对自己不生效
		if self==oTarget then
			if rAtk>0 then
				rAtk = 0
			end
			if nPower>100 then
				nPower = 100
			end
		end
		
		local cBase = 100000
		local cPower = cBase
		--判断额外伤害加成
		if self~=oTarget and (self.data.powerTo~=0 or oTarget.data.powerFrom~=0) then
			if type(self.data.powerTo)=="table" then
				local pT = self.data.powerTo
				for i = 1,#pT do
					local tType = pT[i][1]
					local nPower = pT[i][2]
					local nDur = pT[i][3]
					if nDur~=-1 and nPower~=0 and hApi.CheckUnitAndTargetTypeEx(tType,self,oTarget)==hVar.RESULT_SUCESS then
						cPower = hApi.floor(cPower*math.max(1,nPower+100)/100)
					end
				end
			end
			if type(oTarget.data.powerFrom)=="table" then
				local pF = oTarget.data.powerFrom
				for i = 1,#pF do
					local tType = pF[i][1]
					local nPower = pF[i][2]
					local nDur = pF[i][3]
					if nDur~=-1 and nPower~=0 and hApi.CheckUnitAndTargetTypeEx(tType,oTarget,self)==hVar.RESULT_SUCESS then
						cPower = hApi.floor(cPower*math.max(1,nPower+100)/100)
					end
				end
			end
			
		end
		
		--精英/非精英减伤(最高75%)
		if self~=oTarget then
			if self.attr.heroic~=0 then
				if oTarget.attr.eliteDef>0 then
					cPower = hApi.floor(cPower*(100-math.min(75,oTarget.attr.eliteDef))/100)
				end
			elseif oTarget.attr.meleeDef>0 or oTarget.attr.rangeDef>0 then
				local tabUT = hVar.tab_unit[oTarget.data.id]
				local nMyDef = 0
				local IsMelee = 0
				local IsRange = 0
				if tabUT and tabUT.type_ex then
					for i = 1,#tabUT.type_ex do
						if tabUT.type_ex[i]=="MELEE" then
							IsMelee = 1
						elseif tabUT.type_ex[i]=="RANGE" then
							IsRange = 1
						end
					end
				end
				if IsMelee==1 and IsRange==1 then
					--是近战也是远程
					nMyDef = math.max(oTarget.attr.meleeDef,oTarget.attr.rangeDef)
				elseif IsMelee==0 and IsRange==1 then
					--是远程
					nMyDef = oTarget.attr.rangeDef
				elseif IsMelee==1 and IsRange==0 then
					--是近战
					nMyDef = oTarget.attr.meleeDef
				end
				if nMyDef>0 then
					cPower = hApi.floor(cPower*(100-math.min(75,nMyDef))/100)
				end
			end
		end
		
		--最终统计
		if cPower~=cBase then
			nPowerEx = math.max(1,hApi.floor(nPowerEx*cPower/cBase))
		end
	end
	
	local nNum = math.max(1,self.attr.stack)
	if rAtk==0 then
		--无攻击力加成的情况
		if nNum>nStp and self.attr.heroic==0 and oTarget.attr.heroic~=0 then
			local nNumX = nNum-nStp
			local nLen = nCap-nStp
			dMin = hApi.getint(dMin*(nStp+nLen*nNumX/(nNumX+nLen)))
			dMax = hApi.getint(dMax*(nStp+nLen*nNumX/(nNumX+nLen)))
		else
			dMin = hApi.getint(dMin*nNum)
			dMax = hApi.getint(dMax*nNum)
		end
	elseif rAtk>0 then
		--攻击力大于等于防御力的情况
		--每点攻击力提升%dmgPecPerAtk点伤害
		if nNum>nStp and self.attr.heroic==0 and oTarget.attr.heroic~=0 then
			local nNumX = nNum-nStp
			local nLen = nCap-nStp
			dMin = hApi.getint(dMin*(nStp+nLen*nNumX/(nNumX+nLen))*(100+dmgPecPerAtk*rAtk)/100)
			dMax = hApi.getint(dMax*(nStp+nLen*nNumX/(nNumX+nLen))*(100+dmgPecPerAtk*rAtk)/100)
		else
			dMin = hApi.getint(dMin*nNum*(100+dmgPecPerAtk*rAtk)/100)
			dMax = hApi.getint(dMax*nNum*(100+dmgPecPerAtk*rAtk)/100)
		end
	else
		--攻击力小于防御力的情况
		--至多150点，总伤害至多降低75%
		local rDef = -1*rAtk
		local rDef_I = 0
		local rDef_II = 0
		local rDef_III = 0
		if rDef<=25 then
			--1~25：每点降低1%		max(25%)
			rDef_I = rDef
		elseif rDef<=75 then
			--26~75：每2点降低1%		max(25%)
			rDef_I = 25
			rDef_II = rDef - 25
		elseif rDef<=150 then
			--76~150：每3点降低1%		max(25%)
			rDef_I = 25
			rDef_II = 50
			rDef_III = rDef - 75
		else
			--150+：75%减伤
			rDef_I = 25
			rDef_II = 50
			rDef_III = 75
		end
		if nNum>nStp and self.attr.heroic==0 and oTarget.attr.heroic~=0 then
			local nNumX = nNum-nStp
			local nLen = nCap-nStp
			dMin = hApi.getint(dMin*(nStp+nLen*nNumX/(nNumX+nLen))*(100-rDef_I-rDef_II/2-rDef_III/3)/100)
			dMax = hApi.getint(dMax*(nStp+nLen*nNumX/(nNumX+nLen))*(100-rDef_I-rDef_II/2-rDef_III/3)/100)
		else
			dMin = hApi.getint(dMin*nNum*(100-rDef_I-rDef_II/2-rDef_III/3)/100)
			dMax = hApi.getint(dMax*nNum*(100-rDef_I-rDef_II/2-rDef_III/3)/100)
		end
	end
	
	--一般攻击敌人的流程
	--计算掩护百分比
	--站在城外面打城里伤害减免
	--建筑不参与掩体计算
	if self~=oTarget and d.type~=hVar.UNIT_TYPE.BUILDING and IsAttack==1 then	--如果打开这里的话，就只有攻击伤害减半了
		local oWorld = self:getworld()
		if oWorld then
			local vCover = oWorld.data.cover.pec
			if vCover~=100 then
				local oUnit = self
				if oUnit.ID>0 and oUnit.data.IsDead~=1 then
					if oUnit.data.IsCovered==0 and oTarget.data.IsCovered==1 then
						nPercent = vCover
					end
				else
					if oTarget.data.IsCovered==1 then
						nPercent = vCover
					end
				end
			end
		end
	end
	
	if nPower~=100 or nPercent~=100 or nPowerEx~=100 then
		nPower = math.max(1,nPower)
		nPercent = math.max(1,nPercent)
		nPowerEx = math.max(1,nPowerEx)
		dMin = hApi.floor(dMin*nPower*nPowerEx*nPercent/1000000)
		dMax = hApi.floor(dMax*nPower*nPowerEx*nPercent/1000000)
	end
	]]
	--[[
	local nIsNormalAtk = 0 --是否为普通攻击
	local tabSkill = hVar.tab_skill[nSkillId]
	if tabSkill then
		if (tabSkill.IsAttack == 1) then
			nIsNormalAtk = 1 --普通攻击
		end
	end
	]]
	
	if (nDamageMode == 0) then --真实伤害
		dMin = hApi.floor(dMin)
		dMax = hApi.floor(dMax)
		
		--目标无敌，不受真实伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		
		--目标免疫伤害，不受真实伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
		
		--print("真实伤害", self.data.name, oTarget.data.name, "dmg=" .. dMin .. "~" .. dMax)
		--
	elseif (nDamageMode == 1) then --物理伤害
		--计算物防
		local physic_def = oTarget:GetPhysicDef()
		--print("物理伤害", self.data.name, oTarget.data.name, "dodge_rate=" .. oTarget:GetDodgeRate())
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会闪避、暴击
				local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
				if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
					local randInt2 = world:random(0, 100)
					if (randInt2 < crit_rate) then --暴击
						local crit_value = self:GetCritValue() --攻击者暴击倍数
						if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
							crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
						end
						
						dMin = hApi.floor(dMin * crit_value)
						dMax = hApi.floor(dMax * crit_value)
						
						--geyachao: 暴击冒字
						--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
						--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
						--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
					end
				end
			end
		end
		
		--【减伤公式计算】
		--物理防御最低为-100, 最高为100
		if (physic_def < hVar.ROLE_DEF_PHYSIC_MIN) then
			physic_def = hVar.ROLE_DEF_PHYSIC_MIN
		end
		
		if (physic_def > hVar.ROLE_DEF_PHYSIC_MAX) then
			physic_def = hVar.ROLE_DEF_PHYSIC_MAX
		end
		
		if (physic_def >= 0) then
			dMin = dMin * (1 - (physic_def / (physic_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (physic_def / (physic_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-physic_def) / ((-physic_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-physic_def) / ((-physic_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标物理免疫，不受物理伤害
		if (oTarget.attr.immue_physic_stack > 0) then
			dMin = 0
			dMax = 0
		end
		
		--目标无敌，不受物理伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受物理伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == 2) then --法术伤害
		--计算法防
		local magic_def = oTarget:GetMagicDef()
		--print("法术伤害", self.data.name, oTarget.data.name, "magic_def=" .. magic_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--法术防御最低为-100, 最高为100
		if (magic_def < hVar.ROLE_DEF_MAGIC_MIN) then
			magic_def = hVar.ROLE_DEF_MAGIC_MIN
		end
		
		if (magic_def > hVar.ROLE_DEF_MAGIC_MAX) then
			magic_def = hVar.ROLE_DEF_MAGIC_MAX
		end
		
		if (magic_def >= 0) then
			dMin = dMin * (1 - (magic_def / (magic_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (magic_def / (magic_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-magic_def) / ((-magic_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-magic_def) / ((-magic_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标法术免疫，不受法术伤害
		if (oTarget.attr.immue_magic_stack > 0) then
			dMin = 0
			dMax = 0
		end
		
		--目标无敌，不受法术伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受法术伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.ICE) then --冰伤害
		--计算冰防
		local ice_def = oTarget:GetIceDef()
		--print("冰伤害", self.data.name, oTarget.data.name, "ice_def=" .. ice_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--冰防御最低为-100, 最高为100
		if (ice_def < hVar.ROLE_DEF_ICE_MIN) then
			ice_def = hVar.ROLE_DEF_ICE_MIN
		end
		
		if (ice_def > hVar.ROLE_DEF_ICE_MAX) then
			ice_def = hVar.ROLE_DEF_ICE_MAX
		end
		
		if (ice_def >= 0) then
			dMin = dMin * (1 - (ice_def / (ice_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (ice_def / (ice_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-ice_def) / ((-ice_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-ice_def) / ((-ice_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标冰免疫，不受冰伤害
		if (oTarget.attr.immue_damage_ice_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受冰伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受冰伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.THUNDER) then --雷伤害
		--计算雷防
		local thunder_def = oTarget:GetThunderDef()
		--print("雷伤害", self.data.name, oTarget.data.name, "thunder_def=" .. thunder_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--雷防御最低为-100, 最高为100
		if (thunder_def < hVar.ROLE_DEF_THUNDER_MIN) then
			thunder_def = hVar.ROLE_DEF_THUNDER_MIN
		end
		
		if (thunder_def > hVar.ROLE_DEF_THUNDER_MAX) then
			thunder_def = hVar.ROLE_DEF_THUNDER_MAX
		end
		
		if (thunder_def >= 0) then
			dMin = dMin * (1 - (thunder_def / (thunder_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (thunder_def / (thunder_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-thunder_def) / ((-thunder_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-thunder_def) / ((-thunder_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标雷免疫，不受雷伤害
		if (oTarget.attr.immue_damage_thunder_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受雷伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受雷伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.FIRE) then --火伤害
		--计算火防
		local fire_def = oTarget:GetFireDef()
		--print("火伤害", self.data.name, oTarget.data.name, "fire_def=" .. fire_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--火防御最低为-100, 最高为100
		if (fire_def < hVar.ROLE_DEF_FIRE_MIN) then
			fire_def = hVar.ROLE_DEF_FIRE_MIN
		end
		
		if (fire_def > hVar.ROLE_DEF_FIRE_MAX) then
			fire_def = hVar.ROLE_DEF_FIRE_MAX
		end
		
		if (fire_def >= 0) then
			dMin = dMin * (1 - (fire_def / (fire_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (fire_def / (fire_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-fire_def) / ((-fire_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-fire_def) / ((-fire_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标火免疫，不受火伤害
		if (oTarget.attr.immue_damage_fire_stack > 0) then
			--print("目标火免疫，不受火伤害", oTarget.data.name)
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受火伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受火伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.POISON) then --毒伤害
		--计算毒防
		local poison_def = oTarget:GetPoisonDef()
		--print("毒伤害", self.data.name, oTarget.data.name, "poison_def=" .. poison_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--毒防御最低为-100, 最高为100
		if (poison_def < hVar.ROLE_DEF_POISON_MIN) then
			poison_def = hVar.ROLE_DEF_POISON_MIN
		end
		
		if (poison_def > hVar.ROLE_DEF_POISON_MAX) then
			poison_def = hVar.ROLE_DEF_POISON_MAX
		end
		
		if (poison_def >= 0) then
			dMin = dMin * (1 - (poison_def / (poison_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (poison_def / (poison_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-poison_def) / ((-poison_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-poison_def) / ((-poison_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标毒免疫，不受毒伤害
		if (oTarget.attr.immue_damage_poison_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受毒伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受毒伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BULLET) then --子弹伤害
		--计算子弹防
		local bullet_def = oTarget:GetBulletDef()
		--print("子弹伤害", self.data.name, oTarget.data.name, "bullet_def=" .. bullet_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--子弹防御最低为-100, 最高为100
		if (bullet_def < hVar.ROLE_DEF_BULLET_MIN) then
			bullet_def = hVar.ROLE_DEF_BULLET_MIN
		end
		
		if (bullet_def > hVar.ROLE_DEF_BULLET_MAX) then
			bullet_def = hVar.ROLE_DEF_BULLET_MAX
		end
		
		if (bullet_def >= 0) then
			dMin = dMin * (1 - (bullet_def / (bullet_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (bullet_def / (bullet_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-bullet_def) / ((-bullet_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-bullet_def) / ((-bullet_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标子弹免疫，不受子弹伤害
		if (oTarget.attr.immue_damage_bullet_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受子弹伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受子弹伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BOMB) then --爆炸伤害
		--计算爆炸防
		local bomb_def = oTarget:GetBombDef()
		--print("爆炸伤害", self.data.name, oTarget.data.name, "bomb_def=" .. bomb_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--爆炸防御最低为-100, 最高为100
		if (bomb_def < hVar.ROLE_DEF_BOMB_MIN) then
			bomb_def = hVar.ROLE_DEF_BOMB_MIN
		end
		
		if (bomb_def > hVar.ROLE_DEF_BOMB_MAX) then
			bomb_def = hVar.ROLE_DEF_BOMB_MAX
		end
		
		if (bomb_def >= 0) then
			dMin = dMin * (1 - (bomb_def / (bomb_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (bomb_def / (bomb_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-bomb_def) / ((-bomb_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-bomb_def) / ((-bomb_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标爆炸免疫，不受爆炸伤害
		if (oTarget.attr.immue_damage_boom_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受爆炸伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受爆炸伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.CHUANCI) then --穿刺伤害
		--计算穿刺防
		local chuanci_def = oTarget:GetChuanciDef()
		--print("穿刺伤害", self.data.name, oTarget.data.name, "chuanci_def=" .. chuanci_def)
		
		--计算是否闪避本次普通攻击
		local dodge_rate = oTarget:GetDodgeRate() --目标闪避几率（去百分号后的值）
		if (dodge_rate > hVar.ROLE_DODGE_RATE_MAX) then
			dodge_rate = hVar.ROLE_DODGE_RATE_MAX --闪避几率的上限
		end
		
		local randInt = world:random(0, 100)
		if (randInt < dodge_rate) then --闪避攻击
			dMin = 0
			dMax = 0
			
			--geyachao: 闪避冒字
			--hApi.ShowLabelBubble(oTarget, "闪避", ccc3(255, 96, 0)) --language
			--hApi.ShowLabelBubble(oTarget, hVar.tab_string["dodge"], ccc3(255, 96, 0)) --language
			hApi.ShowLabelBubble(oTarget, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_dodge_physic.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagDodgePhysic")
			
			--触发闪避伤害后事件处理回调
			if On_Unit_Dodge_Dmg_Event then
				--安全执行
				hpcall(On_Unit_Dodge_Dmg_Event, oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
				--On_Unit_Dodge_Dmg_Event(oTarget, self, dMin, dMax, nPower, nSkillId, nDamageMode, IsAttack)
			end
		else --未闪避攻击
			--是否暴击
			--对于法术伤害，只有技能id为施法者的普通攻击，才会有暴击
			if (self ~= oTarget) then --自己对自己造成伤害，不会暴击
				--if (self.attr.attack and (self.attr.attack[1] == nSkillId)) or (nSkillId == 11362) then --普通攻击(11362:小乔特殊处理)
					--print(self.data.name, "法术普通攻击")
					local crit_rate = self:GetCritRate() --攻击者暴击几率（去百分号后的值）
					if (crit_rate > 0) then --优化，避免无暴击的也多调用一次逻辑
						local randInt2 = world:random(0, 100)
						if (randInt2 < crit_rate) then --暴击
							local crit_value = self:GetCritValue() --攻击者暴击倍数
							if (crit_value > hVar.ROLE_CRIT_VALUE_MAX) then
								crit_value = hVar.ROLE_CRIT_VALUE_MAX --暴击倍数的上限
							end
							
							dMin = hApi.floor(dMin * crit_value)
							dMax = hApi.floor(dMax * crit_value)
							
							--geyachao: 暴击冒字
							--hApi.ShowLabelBubble(self, "暴击", ccc3(255, 96, 0)) --language
							--hApi.ShowLabelBubble(self, hVar.tab_string["__Attr_Crit"], ccc3(255, 0, 0)) --language
							--hApi.ShowLabelBubble(self, nil, nil, 15, 20, nil, 2000, {model = "ui/bubble_crit_value.png", x = -14, y = -18, w = 48, h = 24,}, nil, "flagCritValue")
						end
					end
				--end
			end
		end
		
		--穿刺防御最低为-100, 最高为100
		if (chuanci_def < hVar.ROLE_DEF_CHUANCI_MIN) then
			chuanci_def = hVar.ROLE_DEF_CHUANCI_MIN
		end
		
		if (chuanci_def > hVar.ROLE_DEF_CHUANCI_MAX) then
			chuanci_def = hVar.ROLE_DEF_CHUANCI_MAX
		end
		
		if (chuanci_def >= 0) then
			dMin = dMin * (1 - (chuanci_def / (chuanci_def + hVar.DAMAGE_DEF_MODULUS)))
			dMax = dMax * (1 - (chuanci_def / (chuanci_def + hVar.DAMAGE_DEF_MODULUS)))
			if (dMin <= 0.05) then
				dMin = 0
			else
				dMin = hApi.ceil(dMin)
			end
			if (dMax <= 0.05) then
				dMax = 0
			else
				dMax = hApi.ceil(dMax)
			end
		else
			dMin = hApi.ceil(dMin * (1 + ((-chuanci_def) / ((-chuanci_def) + hVar.DAMAGE_DEF_MODULUS))))
			dMax = hApi.ceil(dMax * (1 + ((-chuanci_def) / ((-chuanci_def) + hVar.DAMAGE_DEF_MODULUS))))
		end
		
		--目标穿刺免疫，不受穿刺伤害
		if (oTarget.attr.immue_damage_chuanci_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标无敌，不受穿刺伤害
		if (oTarget.attr.immue_wudi_stack > 0) then
			dMin = 0
			dMax = 0
		end
		--目标免疫伤害，不受穿刺伤害
		if (oTarget.attr.immue_damage_stack > 0) then
			dMin = 0
			dMax = 0
		end
	end
	
	--启动图，不受伤害
	if (world.data.map == hVar.LoginMap) then
		dMin = 0
		dMax = 0
	end
	
	--print(dMin, dMax)
	return dMin, dMax
end

-------------------------------
--计算战斗伤害(self,目标，伤害值，技能id，伤害类型)
--返回:最大伤害，最小伤害
heroGameAI.CalculateSystem.FUNC_TAB["HealDamage"] = function(self,oTarget,dMin,dMax,nPower,nSkillId,nDamageMode)
	local d = self.data
	local a = self.attr

	--建筑物承受治疗流程(攻城)
	if oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
		--建筑怎么可能被修复
		return 0,0
	end

	--非英雄单位对英雄单位造成的治疗超过(Var.UNIT_DAMAGE_TO_HERO_NORMAL)只便开始递减,至多造成(hVar.UNIT_DAMAGE_TO_HERO_MAX)只单位的伤害
	local nStp = hVar.UNIT_DAMAGE_TO_HERO_NORMAL or 9999
	local nCap = hVar.UNIT_DAMAGE_TO_HERO_MAX or 10000
	local nNum = math.max(1,self.attr.stack)
	if nNum>nStp and self:gethero()==nil and oTarget:gethero()~=nil then
		local nNumX = nNum-nStp
		local nLen = nCap-nStp
		dMin = hApi.getint(dMin*(nStp+nLen*nNumX/(nNumX+nLen)))
		dMax = hApi.getint(dMax*(nStp+nLen*nNumX/(nNumX+nLen)))
	else
		dMin = hApi.getint(dMin*nNum)
		dMax = hApi.getint(dMax*nNum)
	end

	--nPower以100为标准
	if nPower~=100 and nPower>=0 then
		dMin = hApi.getint(dMin*nPower/100)
		dMax = hApi.getint(dMax*nPower/100)
	end
	return dMin,dMax
end

-------------------------------
--计算战斗伤害(self,攻击者，伤害值，技能id，伤害类型)
--返回:调整hp(扣除),调整数量(扣除)
heroGameAI.CalculateSystem.FUNC_TAB["SufferDamage"] = function(self,oAttacker,nDmg,nSkillId,nDamageMode)
	--print("SufferDamage", "oAttacker=" .. oAttacker.data.name .. ", nDmg=" .. nDmg .. ", nSkillId=" .. nSkillId .. ", nDamageMode=" .. tostring(nDamageMode)) --geyachao: print
	local d = self.data
	local a = self.attr
	if nDmg==0 then
		return 0,0
	elseif nDmg>0 then
		--扣血
		local rDmg = nDmg
		local nLost = 0
		if self:gethero()==nil then
			--print("a.mxhp=" .. a.mxhp)
			if a.mxhp>0 then
				rDmg = nDmg %(self:GetHpMax()) --geyachao: 修改写法
				--rDmg = nDmg%a.mxhp
				--nLost = hApi.getint((nDmg-rDmg)/a.mxhp)
				nLost = hApi.getint((nDmg-rDmg) / (self:GetHpMax())) --geyachao: 修改写法
				--print("rDmg=" .. rDmg, "nLost=" .. nLost, "a.hp=" .. a.hp)
				--geyachao: 以下这段逻辑有问题，如果造成的伤害大于当前血量，就成了回血了？？？？
				--[[
				if rDmg>=a.hp then
					nLost = nLost + 1
					rDmg = rDmg - a.mxhp
				end
				]]
			else
				rDmg = 0
				nLost = nDmg
			end
		else
			rDmg = hApi.NumBetween(nDmg,0,a.hp)
		end
		return rDmg,nLost
	elseif nDmg<0 then
		--补血
		local nHeal = -1*nDmg
		local rHeal = nHeal
		local nRevive = 0--(实际上治疗的话，此值是负数)
		local mStack = a.__stack
		if self:gethero()==nil then
			if a.mxhp>0 then
				--必须多1点血才能加回来的
				nRevive = math.max(0,hApi.floor((nHeal+a.hp-1)/a.mxhp))
				rHeal = math.min(a.mxhp - a.hp,rHeal - nRevive*a.mxhp)
				if nRevive>mStack-a.stack then
					nRevive = mStack - a.stack
					rHeal = a.mxhp - a.hp
				end
			else
				rHeal = 0
				nRevive = hApi.NumBetween(mStack-a.stack,0,rHeal)
			end
		else
			rHeal = hApi.NumBetween(rHeal,0,a.mxhp-a.hp)
		end
		return -1*rHeal,-1*nRevive
	end
end

--------------------------------------------------------
-- 计算经验值的表格
---------------------------------------------------------
local __CalLevelByExp = function(nOldLv,nExp,tExp)
	local lv = nOldLv
	for i = nOldLv+1,#tExp,1 do
		if nExp<tExp[i] then
			return lv
		else
			lv = i
		end
	end
	return lv
end

hApi.GetLevelByExp = function(exp)
	--zhenkira 2015.12.3
	--return __CalLevelByExp(1,nExp,hVar.HERO_EXP)

	local lv = 1

	for i = 2, #hVar.HERO_EXP do
		local expInfo = hVar.HERO_EXP[i]
		if exp < expInfo.minExp then
			break
		end
		lv = i
	end

	return lv
end

hApi.GetLevelMinExp = function(lv)
	--zhenkira 2015.12.29
	if lv then
		local expInfo = hVar.HERO_EXP[lv]
		if expInfo then
			return expInfo.minExp
		end
	end
end

--获取当前等级解锁的战术技能的数量
hApi.GetUnlockTalentNum = function(lv)
	local ret = 0

	local expInfo = hVar.HERO_EXP[lv]
	if expInfo then
		ret = expInfo.unlockTalentNum or 0
	end
	
	return ret
end

--获取pvp局内升级等级
hApi.PvpGetLevelByExp = function(exp)
	--zhenkira 2015.12.3
	--return __CalLevelByExp(1,nExp,hVar.HERO_EXP)

	local lv = 1

	for i = 2, #hVar.HERO_PVP_EXP do
		local expInfo = hVar.HERO_PVP_EXP[i]
		if exp < expInfo.minExp then
			break
		end
		lv = i
	end

	return lv
end
--获取pvp局内升级当前等级的最小经验值
hApi.PvpGetLevelMinExp = function(lv)
	--zhenkira 2015.12.29
	if lv then
		local expInfo = hVar.HERO_PVP_EXP[lv]
		if expInfo then
			return expInfo.minExp
		end
	end
end

--hClass.hero.addexp = function(self,num,IsWithEffect)
--	local a = self.attr
--	local tExp = self:__exptab()
--	local expMax = tExp[100] or 0
--	if hVar.HERO_LEVEL_LIMIT and hVar.HERO_LEVEL_LIMIT>0 then
--		expMax = tExp[hVar.HERO_LEVEL_LIMIT] or 0
--	end
--	if expMax>0 and a.exp>=expMax and num>=0 then
--		--已经超过了经验上限则什么都不做
--		return
--	end
--	local oldExp = math.max(0,a.exp)
--	local oldLv = math.max(1,a.level)
--	a.exp = a.exp + num
--	if expMax>0 and expMax<a.exp then
--		a.exp = expMax
--	end
--	local newLv
--	if num>=0 then
--		newLv = __CalLevelByExp(oldLv,a.exp,tExp)
--	else
--		newLv = __CalLevelByExp(1,a.exp,tExp)
--	end
--	if newLv~=a.level then
--		self:levelup(newLv,IsWithEffect)
--	end
--	return hGlobal.event:event("Local_EventHeroGetExp",self,num,oldLv)
--end
-------------------------------------------------
-- 单位扩展函数:calculate
-- 计算单位的各种数值
-- 重载unit.lua函数
local __CAL_FUNC_TAB = heroGameAI.CalculateSystem.FUNC_TAB
hClass.unit.calculate = function(self,mode,...)
	if __CAL_FUNC_TAB[mode] then
		return __CAL_FUNC_TAB[mode](self,...)
	end
end

-------------------------------------------------
-- 获得胜利函数
hApi.GetVictoryFuncBF = function(oWorld,nPlayerV,nReason)		--当一方人全部死完了，调用此函数
	nReason = nReason or 0
	if type(oWorld.data.netdata)=="table" then
		return function()
			print("网络战场结束")
			oWorld:pause(1,"Victory")
			local oUnitV = oWorld:getlordU(nPlayerV)
			local oUnitD
			local tPlayerDefeat = {}
			for nOwner,nUnitNum in pairs(oWorld.data.unitcount)do
				if nOwner~=nPlayerV and type(nOwner)=="number" and type(nUnitNum)=="number" and hGlobal.player[nOwner] then
					tPlayerDefeat[#tPlayerDefeat+1] = nOwner
					if oUnitD==nil then
						oUnitD = oWorld:getlordU(nOwner)
					end
				end
			end
			if oUnitV~=nil and oUnitD~=nil then
				hApi.BattlefieldUnitVictory(oWorld,oUnitV)
				return hGlobal.event:event("LocalEvent_ShowNetBattlefieldResultFrm",oWorld,oUnitV,oUnitD,nReason)	--显示网络对战战果结算面板
			else
				--发生了什么？
				_DEBUG_MSG("到底发生了神马啊啊啊没有胜利者")
			end
		end
	else
		return function()
			oWorld:pause(1,"Victory")
			local oUnitV = oWorld:getlordU(nPlayerV)
			local oUnitD
			local tPlayerDefeat = {}
			for nOwner,nUnitNum in pairs(oWorld.data.unitcount)do
				if nOwner~=nPlayerV and type(nOwner)=="number" and type(nUnitNum)=="number" and hGlobal.player[nOwner] then
					tPlayerDefeat[#tPlayerDefeat+1] = nOwner
					if oUnitD==nil then
						oUnitD = oWorld:getlordU(nOwner)
					end
				end
			end
			if oUnitV~=nil and oUnitD~=nil then
				hApi.BattlefieldUnitVictory(oWorld,oUnitV)		--对战场单位胜利的处理
				hApi.CalculateBattle(oWorld,oUnitV,oUnitD)		--对战斗结果进行结算
				hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Victory")
				for i = 1,#tPlayerDefeat do
					local nOwner = tPlayerDefeat[i]
					local oUnitD = oWorld:getlordU(nOwner)
					if oUnitD then
						hApi.BattlefieldUnitDefeat(oWorld,oUnitD)
						hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Defeat")
					end
				end
				for i = 1,#tPlayerDefeat do
					local nOwner = tPlayerDefeat[i]
					oWorld:setlordU(nOwner,nil)
				end
			else
				--发生了什么？
				_DEBUG_MSG("到底发生了神马啊啊啊没有胜利者")
			end
		end
	end
end

-------------------------------------------------
-- 战场胜利结算
hApi.CalculateUnitDeadBF = function(oUnit,oUnitK,nId,vParam)	--每死一个人都会进行结算
	local IsEnd = 0
	local nPlayerV
	local nPlayerD
	local oWorld = oUnit:getworld()
	if oWorld==nil then
		--如果世界为空那么返回
		return
	elseif oWorld.data.IsQuickBattlefield==1 then
		--快速战场不走这个流程
		return
	end
	if oWorld.data.unitcount[oUnit.data.owner]<=0 then
		nPlayerD = oUnit.data.owner
		local tPlayerLeft = {}
		for nOwner,nUnitNum in pairs(oWorld.data.unitcount)do
			if type(nOwner)=="number" and type(nUnitNum)=="number" and nUnitNum>0 and hGlobal.player[nOwner] then
				tPlayerLeft[#tPlayerLeft+1] = nOwner
			end
		end
		if #tPlayerLeft==0 then
			--人没了？啥情况
			IsEnd = 1
		elseif #tPlayerLeft==1 then
			--胜利了,且仅剩1名玩家
			IsEnd = 1
			nPlayerV = tPlayerLeft[1]
		else
			IsEnd = 1
			nPlayerV = tPlayerLeft[1]
			local oPlayerI = hGlobal.player[nPlayerV]
			for nOwner = 2,#tPlayerLeft do
				local case = oPlayerI:allience(hGlobal.player[nOwner])
				if case==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
					IsEnd = 0
					break
				end
			end
		end
	end
	if IsEnd==1 then
		return hApi.GetVictoryFuncBF(oWorld,nPlayerV,0)		--当一方人死完了（结束了本场战斗），调用此函数
	end
end


-------------------------------
--计算AI自动使用的技能
--返回:AIGrid
--选择施放何种的优先级和概率
--首先对角色的技能根据此表进行排列
--然后依次从高到低，从指定优先度的技能中随机选择一项
--判断概率，若成功则确定施放此技能
--最后从技能可选目标中选择一个目标优先度最高的单位施放
local __SpecialSkillTypeKey = {
	["ChargeTo"] = "Charge",
	["IceWall"] = "IceWall",
	["Teleport"] = "Teleport",
	["DoActionToTargetWithDirection"] = "Wave",
}
local __SkillTypeKey = {
	["BecomeBuff"] = "Buff",
	["SweepAttack"] = "Damage",
	["Damage"] = "Damage",
	["DamageArea"] = "Damage",
	["MeleeDamage"] = "Damage",
	["ShootDamage"] = "Damage",
	["CombatDamage"] = "Damage",
	["RangeDamage"] = "Damage",
	["Heal"] = "Heal",
	["HealArea"] = "Heal",
	["TargetArea"] = "Damage",
}
local __DamageSkillAreaKey = {
	["RandomTarget"] = 1,
	["TargetArea"] = 1,
	["DamageArea"] = 1,
	["HealArea"] = 1,
}
local __BuffSkillAreaKey = {
	["RandomTarget"] = 1,
	["TargetArea"] = 1,
}
--hVar.SKILL_AI_TYPE = {
	--["Default"] = {1,100},
	--["Damage"] = {4,75},
	--["Heal"] = {3,75},
	--["DamageArea"] = {4,50},
	--["HealArea"] = {2,50},
	--["Buff"] = {2,50},
	--["Debuff"] = {2,50},
	--["BuffArea"] = {3,20},
	--["DebuffArea"] = {3,20},
--}
local __IsAreaSkill
__IsAreaSkill = function(tabS,tabF,nDepth)
	nDepth = nDepth or 0
	if nDepth>1 then
		return
	elseif tabS.action then
		local IsArea
		for i = 1,#tabS.action do
			local v = tabS.action[i]
			if v[1]=="CastSkill" and hVar.tab_skill[v[2]] then
				IsArea = __IsAreaSkill(hVar.tab_skill[v[2]],tabF,nDepth+1)
			else
				IsArea = tabF[v[1]]
			end
			if IsArea then
				return 1
			end
		end
	end
end

local __GetSkillAIType
__GetSkillAIType = function(tabS,nDepth)
	nDepth = nDepth or 0
	if nDepth>1 then
		return
	elseif tabS.ai_type then
		return tabS.ai_type
	elseif tabS.action then
		local sType = "none"
		local sTypeSecond
		local IsBuff = 0
		local IsSpecialType = 0
		for i = 1,#tabS.action do
			local v = tabS.action[i]
			local sTypeCur
			if v[1]=="CastSkill" then
				if hVar.tab_skill[v[2]] then
					sTypeSecond = __GetSkillAIType(hVar.tab_skill[v[2]],nDepth+1)
				end
			else
				if __SpecialSkillTypeKey[v[1]] then
					IsSpecialType = 1
					sTypeCur = __SpecialSkillTypeKey[v[1]]
				else
					sTypeCur = __SkillTypeKey[v[1]]
				end
			end
			if sTypeCur=="Buff" then
				IsBuff = 1
			elseif sTypeCur then
				sType = sTypeCur
				break
			end
		end
		if sType=="none" and sTypeSecond and sTypeSecond~="none" then
			sType = sTypeSecond
		end
		--自身施放类的技能，如果不存在伤害的话，则认为buff类技能
		if sType=="none" and (IsBuff==1 or tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE) then
			sType = "Buff"
		end
		--判断技能是否具有范围效果，并且不是强制特殊指定的AI类型
		if IsSpecialType~=1 and sType~="none" then
			if sType=="Buff" then
				if __IsAreaSkill(tabS,__BuffSkillAreaKey,nDepth) then
					sType = sType.."Area"
				end
			elseif __IsAreaSkill(tabS,__DamageSkillAreaKey,nDepth) then
				sType = sType.."Area"
			end
		end
		tabS.ai_type = sType
		return tabS.ai_type
	end
	tabS.ai_type = "none"
	return tabS.ai_type
end
hApi.GetSkillAIType = function(id)
	if hVar.tab_skill[id] then
		return __GetSkillAIType(hVar.tab_skill[id])
	else
		return "none"
	end
end
local __ChanceByAIType = hVar.SKILL_AI_TYPE
local __CalculateSkillByAI = function(sPool,oUnit,id,mode,tGrid)
	if id~=nil and id~=0 and hVar.tab_skill[id]~=nil then
		local sTab = hVar.tab_skill[id]
		if mode==nil then
			mode = __GetSkillAIType(sTab)
		end
		if type(mode)=="string" and(type(sTab.ai_cast)=="table" or mode~="none") then
			local aTab
			if type(sTab.ai_cast)=="table" then
				aTab = sTab.ai_cast
			elseif type(__ChanceByAIType[mode])=="table" then
				aTab = __ChanceByAIType[mode]
			else
				aTab = __ChanceByAIType["Damage"]
			end
			local v,chance = unpack(aTab)
			if oUnit.data.IsEncountered>0 and id==hVar.ENCOUNTERED_ATTACK_ID then
				v = 0		--优先度超低,遭遇攻击
			end
			--print("技能 "..tostring(sTab.name).." 类型 "..tostring(mode).."优先级"..v)
			sPool[v] = sPool[v] or {}
			sPool[v][#sPool[v]+1] = {id,mode,chance,0,tGrid}
			sPool.max = math.max(sPool.max,v)
		end
	end
end
local __CalculateUnitSkillByAI = function(sPool,oUnit)
	--判断应该使用什么技能
	local skill = oUnit.attr.skill
	if skill.num>0 then
		for i = 1,skill.i do
			local v = skill[i]
			if v and v~=0 and v[1]~=0 and v[2]~=0 then
				local id,lv,cd,count = unpack(v)
				local cast = hApi.GetSkillCastType(id)
				if cd<=0 and count>=0 and cd<=0 and (cast==hVar.CAST_TYPE.SKILL_TO_UNIT or cast==hVar.CAST_TYPE.SKILL_TO_GRID or cast==hVar.CAST_TYPE.IMMEDIATE) then
					local count = hApi.GetSkillCastCount(oUnit,id,lv)
					if count>=0 and hApi.IsSkillDisabled(oUnit,id)~=1 then
						__CalculateSkillByAI(sPool,oUnit,id)
					end
				end
			end
		end
	end
	if sPool.max<=0 and sPool[0]==nil and oUnit.attr.move>0 then
		sPool[0] = {{hVar.MOVE_SKILL_ID,"Move",100}}
	end
end

local __SORT__SkillPool = function(a,b)
	return a~=0 and b==0
end
local __CalculateUnitSkillByAIEx = function(sPool,oUnit,attackId)
	local oWorld = oUnit:getworld()
	local tInsert,tempT
	for i = sPool.max,0,-1 do
		if sPool[i] and #sPool[i]>0 then
			local RemoveCount = 0
			local v = sPool[i]
			for n = 1,#v do
				local id,mode,chance,tCode,tGrid = unpack(v[n])
				local AIKey = hVar.tab_skill[id].cast_ai or id
				local AICode = hGlobal.CastAI[AIKey] or hGlobal.CastAI[mode]
				if AICode and type(AICode)=="function" then
					if tempT==nil then
						tempT = {}
					end
					local nLevel,nChance,nCode = AICode(oUnit,tempT,id,mode)
					if nLevel~=nil and nLevel~=i then
						nLevel = math.min(nLevel,30)
						if id==attackId and nLevel>0 then
							--如果是攻击技能，且nLevel大于0，那么不会移除此技能的基本AI判断
						else
							--其他情况都移除此技能的基本AI判断
							v[n] = 0
							RemoveCount = RemoveCount + 1
						end
						if nLevel>=0 then
							if tInsert==nil then
								tInsert = {max=0}
							end
							local vInsert = tInsert[nLevel]
							if vInsert==nil then
								vInsert = {}
								tInsert[nLevel] = vInsert
							end
							tInsert.max = math.max(tInsert.max,nLevel)
							vInsert[#vInsert+1] = {id,mode,nChance or chance,nCode or tCode,tGrid}
						end
					elseif nChance~=nil or nCode~=nil then
						--赋值
						v[n][3] = nChance or v[n][3]
						v[n][4] = nCode or v[n][4]
					end
				end
			end
			if RemoveCount>0 then
				table.sort(v,__SORT__SkillPool)
				for n = #v,#v-RemoveCount,-1 do
					v[n] = nil
				end
			end
		end
	end
	if tInsert then
		for i = 0,tInsert.max,1 do
			if tInsert[i] then
				if sPool[i]==nil then
					sPool[i] = tInsert[i]
				else
					local v = sPool[i]
					for n = 1,#tInsert[i] do
						v[#v+1] = tInsert[i][n]
					end
				end
			end
		end
		sPool.max = math.max(sPool.max,tInsert.max)
	end
end

--计算受伤单位数量
--local __ENUM__IsAnyUnitDamaged = function(t,u,sPool,oWorld)
	--if t.data.IsDead~=1 and t.data.owner==u.data.owner then
		--if t.data.type==hVar.UNIT_TYPE.UNIT then
			--if t.attr.__stack>t.attr.stack then
				--sPool.HealCount = sPool.HealCount + 1
			--end
		--elseif t.data.type==hVar.UNIT_TYPE.HERO then
			--if t.attr.hp>=hApi.floor(t.attr.mxhp*4/5) then
				--sPool.HealCount = sPool.HealCount + 1
			--end
		--end
	--end
--end

------------------------------------------
--对单位威胁度进行排序
local __CalTargetHarm = function(u)
	local a = u.attr
	if a.mxhp>0 then
		return math.floor((a.attack[4]+a.attack[5])*100/a.mxhp)
	else
		return math.floor((a.attack[4]+a.attack[5])*100)
	end
end

local __SORT__ByUnitHarm = function(a,b)
	if a and b then
		local IsB1 = a.data.type==hVar.UNIT_TYPE.BUILDING
		local IsB2 = b.data.type==hVar.UNIT_TYPE.BUILDING
		if IsB1 and not(IsB2) then
			return true
		elseif IsB1 and IsB2 then
			return false
		else
			return __CalTargetHarm(a)>__CalTargetHarm(b)
		end
	end
end

--heroGameAI.CalculateSystem.FUNC_TAB["AiTarget"] = function(self,mode)
--	if self.attr.stun>0 then
--		return nil
--	end
--	local oWorld = self:getworld()
--	if oWorld~=nil then
--		local sPool = {max=0,HealCount=0}
--		local defaultId = hApi.GetDefaultSkill(self)
--		local s = self.attr.skill
--		__CalculateSkillByAI(sPool,self,defaultId,"Default")
--		__CalculateUnitSkillByAI(sPool,self)
--		local _,MoveGrid,MoveGridEx
--		if mode=="rush" then
--			--rush型的电脑会冲出来
--			local oPlayer = self:getowner()
--			local gTab = {}
--			oWorld:opengateT(oPlayer,1,gTab)
--			_,MoveGrid = self:getmovegrid()
--			_,MoveGridEx = self:getmovegrid(999)
--			oWorld:opengateT(oPlayer,0,gTab)
--		else
--			--一般的电脑死活不出城
--			_,MoveGrid = self:getmovegrid()
--			_,MoveGridEx = self:getmovegrid(999)
--		end
--		--print("Unit["..self.data.id.."]开始行动")
--		--重新计算一次技能的优先级(特殊AI计算)
--		__CalculateUnitSkillByAIEx(sPool,self,defaultId)
--		local SecondChooise
--		if hVar.OPTIONS.BF_AI_LOG==1 then
--			_DEBUG_MSG("----------------AI"..self.data.id.."("..self.ID..")-----------------------")
--		end
--		for i = sPool.max,0,-1 do
--			if sPool[i] and #sPool[i]>0 then
--				local v = sPool[i][hApi.random(1,#sPool[i])]
--				local id,mode,chance,tCode,tGrid = unpack(v)
--				local tabS = hVar.tab_skill[id]
--				if hVar.OPTIONS.BF_AI_LOG==1 then
--					_DEBUG_MSG("choose skill "..id.." from "..i.."#"..#sPool[i])
--				end
--				if tabS and (hApi.random(1,100)<=chance or (i==1 and type(sPool[0])==nil) or i==0) then
--					if i==0 then
--						--说明是远程单位被近战靠近了，会尝试逃跑
--						if id==hVar.MOVE_SKILL_ID or hApi.random(1,100)<70 then
--							tGrid = hApi.CalculateMovePath(self,hVar.MOVE_SKILL_ID,MoveGrid,MoveGridEx)
--							tGrid.TargetList = {}
--							return tGrid
--						end
--					end
--					if tGrid~=nil then
--						return tGrid
--					else
--						--print("判断技能！优先级"..i,id,hVar.tab_skill[id].name)
--						tGrid = hApi.CalculateMovePath(self,id,MoveGrid,MoveGridEx)
--						tGrid.TargetList = {}
--						if tCode~=0 and type(tCode)=="function" then
--							--特殊函数来计算技能目标
--							tCode(self,tGrid,id,mode)
--						else
--							if tabS.ai_type=="Wave" and type(tabS.range)=="table" and type(tabS.range[2])=="number" and tabS.range[2]>0 then
--								--"Wave"的AI特殊处理(有射程的)
--								local rMin,rMax = tabS.range[1],tabS.range[2]
--								--常规AI选择流程
--								for ID,v in pairs(tGrid.Target)do
--									if v.type~="OutOfRange" and v.type~="Immune" then
--										local t = hClass.unit:find(ID)
--										if t and oWorld:distanceU(self,t,1)<=rMax then
--											--非法目标不计算在可用目标内
--											tGrid.TargetList[#tGrid.TargetList+1] = hClass.unit:find(ID)
--										end
--									end
--								end
--							else
--								--常规AI选择流程
--								for ID,v in pairs(tGrid.Target)do
--									if v.type~="OutOfRange" and v.type~="Immune" then
--										tGrid.TargetList[#tGrid.TargetList+1] = hClass.unit:find(ID)
--									end
--								end
--							end
--							--如果是攻击技能，那么使用排序模式选择技能目标
--							if mode=="Damage" or mode=="DamageArea" then
--								tGrid.TargetList.SortCode = __SORT__ByUnitHarm
--							end
--						end
--						local tar = tGrid.TargetList
--						local tarData = tGrid.Target
--						local CanCast = 0
--						local IsSummonSkill = 0
--						if #tar>0 then
--							CanCast = 1
--						end
--						if type(tabS.summons)=="table" then
--							CanCast = 1
--							IsSummonSkill = 1
--						end
--						if CanCast==1 then
--							if tGrid.opr=="Attack" then
--								return tGrid
--							elseif tGrid.opr=="MoveAndAttack" then
--								for n = 1,#tar do
--									if tarData[tar[n].ID].type=="MoveAndAttack" then
--										return tGrid
--									end
--								end
--							elseif tGrid.opr=="Ground" then
--								return tGrid
--							elseif tGrid.opr=="Self" then
--								--召唤技能直接施展
--								if IsSummonSkill==1 then
--									return tGrid
--								elseif i==hVar.SKILL_AI_TYPE["Buff"][1] then
--									return tGrid
--								else
--									local count = 0
--									for n = 1,#tar do
--										if tarData[tar[n].ID].type=="InRange" then
--											count = count + 1
--										end
--									end
--									if count>=2 then
--										return tGrid
--									elseif count==1 then
--										local tabS = hVar.tab_skill[id]
--										--对自己使用的技能，一个就一个吧
--										if tabS and type(tabS.target)=="table" and #tabS.target==1 and tabS.target[1]=="SELF" then
--											return tGrid
--										else
--											__CalculateSkillByAI(sPool,self,tGrid.nSkillId,"Buff",tGrid)
--										end
--									end
--								end
--							end
--						end
--						if tGrid.opr=="MoveAndAttack" and CanCast==1 then
--							SecondChooise = SecondChooise or tGrid
--						end
--					end
--				end
--			end
--		end
--		--如果走到这里说明操蛋了
--		return SecondChooise
--	end
--end

local __tTemp,__pCode
local __pSortFunc = function()
	table.sort(__tTemp,__pCode)
end

--AI选择一个攻击目标
--hApi.AISelectT = function(oUnit,tChoosen,pSortFunc,nSelectChance)
--	if #tChoosen<=0 then
--		return nil,nil
--	elseif #tChoosen==1 then
--		return tChoosen[1][1],tChoosen[1][2]
--	elseif type(pSortFunc)=="function" then
--		nSelectChance = nSelectChance or 50
--		local temp = {}
--		local tempI = {}
--		for i = 1,#tChoosen do
--			temp[i] = tChoosen[i][1]
--			tempI[temp[i].ID] = i
--		end
--		__tTemp = temp
--		__pCode = pSortFunc
--		xpcall(__pSortFunc,print)
--		for i = 1,#temp do
--			if hApi.random(1,100)<=nSelectChance then
--				return temp[i],tChoosen[tempI[temp[i].ID]][2]
--			end
--		end
--	end
--	local v = tChoosen[hApi.random(1,#tChoosen)]
--	return v[1],v[2]
--end

--命令AI行动
--hApi.AIMove = function(oUnit,AIGrid,tMemory)
--	local AIPlayer = oUnit:getowner()
--	local oWorld = oUnit:getworld()
--	if AIGrid~=nil then
--		--_DEBUG_MSG(oUnit.data.name.." 选择技能,操作",hVar.tab_skill[AIGrid.nSkillId].name,AIGrid.opr)
--		local nSkillId = AIGrid.nSkillId
--		local oTarget
--		if AIGrid.opr=="Attack" or AIGrid.opr=="MoveAndAttack" then
--			local pSortFunc = AIGrid.TargetList.SortCode
--			local nSelectChance = AIGrid.TargetList.SelectChance
--			local AttackTemp = {}
--			local MoveTemp = {}
--			local IsFind = 0
--			for i = 1,#AIGrid.TargetList do
--				local t = AIGrid.TargetList[i]
--				local v = AIGrid.Target[t.ID]
--				
--				if v == nil then
--					xlAppAnalysis("skill_error",0,1,"info-","uID:"..tostring(xlPlayer_GetUID())..";t.id="..tostring(t.data.id)..";oUnit.id="..tostring(oUnit.data.id)..";")
--					return
--				end
--				if v.type=="Attack" then
--					--可直接攻击的敌人
--					AttackTemp[#AttackTemp+1] = {t,v}
--				elseif v.type=="MoveAndAttack" then
--					--移动后攻击的敌人
--					AttackTemp[#AttackTemp+1] = {t,v}
--				elseif v.type=="Move" then
--					--只能移动靠近的敌人
--					MoveTemp[#MoveTemp+1] = {t,v}
--				end
--			end
--			--local AttackTemp = {}
--			--local MoveTemp = {}
--			--local IsFind = 0
--			--if #AttackTemp==0 then
--				--for k,v in pairs(AIGrid.Target)do
--					--if v.type=="Attack" then
--						----可直接攻击的敌人
--						--AttackTemp[#AttackTemp+1] = {hClass.unit:find(k),v}
--					--elseif v.type=="MoveAndAttack" then
--						----移动后攻击的敌人
--						--AttackTemp[#AttackTemp+1] = {hClass.unit:find(k),v}
--					--elseif v.type=="Move" then
--						----只能移动靠近的敌人
--						--MoveTemp[#MoveTemp+1] = {hClass.unit:find(k),v}
--					--end
--				--end
--			--end
--			local tChoosen
--			if #AttackTemp>0 then
--				tChoosen = AttackTemp
--			elseif #MoveTemp>0 then
--				tChoosen = MoveTemp
--			end
--			if tMemory and tMemory.target==nil then
--				tMemory.target = {}
--			end
--			if tChoosen then
--				local oTargetL
--				if tMemory then
--					oTargetL = hApi.GetObjectEx(hClass.unit,tMemory.target)
--				end
--				local IsKeeped = 0
--				if oTargetL~=nil and oTargetL.data.IsDead==0 then
--					--50%几率不更换目标
--					if oTargetL.data.IsSummoned~=0 and oTargetL.attr.duration==1 then
--						--会在本回合消失的生物无需攻击
--						oTargetL = nil
--					elseif hApi.random(1,100)<=50 then
--						for i = 1,#tChoosen do
--							local t,g = unpack(tChoosen[i])
--							if oTargetL==t then
--								IsKeeped = 1
--								oTarget = t
--								tGrid = g
--								break
--							end
--						end
--					end
--				end
--				--如果有特殊选择目标函数，那么使用此函数选择目标
--				if tMemory and type(tMemory.AITargetFunc)=="function" then
--					local fCode = tMemory.AITargetFunc
--					tMemory.AITargetFunc = nil
--					local t,g = rpcall(fCode,oUnit,nSkillId,tChoosen,oTargetL,IsKeeped)
--					if t and g then
--						oTarget,tGrid = t,g
--					end
--				end
--				if #tChoosen>0 then
--					--选择技能生效目标
--					if oTarget==nil then
--						local nSummonCount = 0
--						for i = 1,#tChoosen do
--							if tChoosen[i][1].data.IsSummoned~=0 then
--								nSummonCount = nSummonCount + 1
--							end
--						end
--						if nSummonCount>0 and nSummonCount<#tChoosen then
--							--不攻击会在本回合消失的生物
--							local tTemp = {}
--							for i = 1,#tChoosen do
--								if not(tChoosen[i][1].attr.duration==1) then
--									tTemp[#tTemp+1] = tChoosen[i]
--								end
--							end
--							tChoosen = tTemp
--						end
--						oTarget,tGrid = hApi.AISelectT(oUnit,tChoosen,pSortFunc,nSelectChance)
--					end
--				end
--			end
--			if oTarget==nil then
--				if tMemory then
--					hApi.SetObjectEx(tMemory.target,nil)
--					tMemory.opr = "NONE"
--				end
--			else
--				if tMemory then
--					hApi.SetObjectEx(tMemory.target,oTarget)
--					tMemory.opr = tGrid.type
--				end
--				if tGrid.type=="Attack" then
--					local tX,tY = oTarget.data.gridX,oTarget.data.gridY
--					if AIGrid.castXY then
--						tX,tY = AIGrid.castXY[1],AIGrid.castXY[2]
--					end
--					return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,nSkillId,oTarget,tX,tY)
--				elseif #tGrid>0 then
--					local v = tGrid[hApi.random(1,#tGrid)]
--					local moveX,moveY = v.x,v.y
--					if tGrid.type=="MoveAndAttack" then
--						if moveX==oUnit.data.gridX and moveY==oUnit.data.gridY then
--							return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,nSkillId,oTarget,moveX,moveY)
--						else
--							return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT_WITH_MOVE,oUnit,nSkillId,oTarget,moveX,moveY)
--						end
--					else
--						local tX,tY = hApi.FindUnitMoveGrid(oUnit,moveX,moveY)
--						if not(tX and tY) then
--							local gTab = {}
--							oWorld:opengateT(AIPlayer,1,gTab)
--							tX,tY = hApi.FindUnitMoveGrid(oUnit,moveX,moveY)
--							oWorld:opengateT(AIPlayer,0,gTab)
--						end
--						if tX and tY then
--							--移动到最近的可到达地点
--							return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,tX,tY)
--						else
--							--不可移动的话，进行防御
--							return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,hVar.GUARD_SKILL_ID,nil,oUnit.data.gridX,oUnit.data.gridY)
--						end
--					end
--				end
--			end
--		elseif AIGrid.opr=="Ground" then
--			if tMemory then
--				tMemory.opr = "GROUND"
--			end
--			local tX,tY = oUnit.data.gridX,oUnit.data.gridY
--			if AIGrid.castXY then
--				tX,tY = AIGrid.castXY[1],AIGrid.castXY[2]
--			else
--				if #AIGrid.TargetList>0 then
--					local oTarget = AIGrid.TargetList[hApi.random(1,#AIGrid.TargetList)]
--					tX,tY = oTarget.data.gridX,oTarget.data.gridY
--				end
--			end
--			return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_GRID,oUnit,nSkillId,nil,tX,tY)
--		elseif AIGrid.opr=="Self" then
--			if tMemory then
--				tMemory.opr = "SELF"
--			end
--			return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,nSkillId,nil,oUnit.data.gridX,oUnit.data.gridY)
--		elseif AIGrid.opr=="Move" then
--			if #AIGrid.MoveGrid>0 then
--				if tMemory then
--					tMemory.opr = "MOVE"
--				end
--				local MoveGrid = AIGrid.MoveGrid
--				--如果单位的默认攻击方式是远程,并且攻击方式被替换了,那么尝试远离附近的敌人
--				local nAttackId = oUnit.attr.attack[1]
--				local tabS = hVar.tab_skill[nAttackId]
--				if tabS and tabS.template=="RangeAttack" and nAttackId~=hApi.GetDefaultSkill(oUnit) then
--					local DangerGrid = {}
--					local DangerGridIndex = {}
--					local DangerUnit = {}
--					local SafeGrid = {}
--					oWorld:enumunitUR(oUnit,1,oUnit.attr.move,function(t)
--						if t.data.owner~=oUnit.data.owner and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
--							DangerUnit[#DangerUnit+1] = t
--						end
--					end)
--					for i = 1,#DangerUnit do
--						oWorld:gridinunitrange(DangerGrid,DangerUnit[i],1,1)
--					end
--					for i=1,#DangerGrid do
--						local v = DangerGrid[i]
--						DangerGridIndex[v.x.."|"..v.y] = 1
--					end
--					for i = 1,#AIGrid.MoveGrid do
--						local v = AIGrid.MoveGrid[i]
--						if DangerGridIndex[v.x.."|"..v.y]~=1 then
--							SafeGrid[#SafeGrid+1] = v
--						end
--					end
--					if #SafeGrid>0 then
--						MoveGrid = SafeGrid
--					end
--				end
--				if #MoveGrid>0 then
--					local v = MoveGrid[hApi.random(1,#MoveGrid)]
--					local tX,tY = v.x,v.y
--					if not(tX==oUnit.data.gridX and tY==oUnit.data.gridY) then
--						return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,tX,tY)
--					end
--				end
--			end
--		end
--	end
--	--当没有任何事情做的时候，怎么办呢
--	if tMemory then
--		if oUnit.attr.stun>0 then
--			tMemory.opr = "STUN"
--		elseif oUnit.attr.move<=0 then
--			tMemory.opr = "IMMOBILIZE"
--		else
--			tMemory.opr = "GUARD"
--		end
--	end
--	return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,hVar.GUARD_SKILL_ID,nil,oUnit.data.gridX,oUnit.data.gridY)
--end

--------------------------------
--EFF 小战场AI
--------------------------------
local __BF__LastAIMemory
hApi.UpdateAIMemory = function(oUnit)
	if oUnit=="init" then
		__BF__LastAIMemory = {}
	elseif oUnit=="release" then
		__BF__LastAIMemory = nil
	else
		if __BF__LastAIMemory==nil then
			__BF__LastAIMemory = {}
		end
		if __BF__LastAIMemory[oUnit.data.owner]==nil then
			__BF__LastAIMemory[oUnit.data.owner] = {
				roundcount = 0,
				mode = 0,
			}
		end
		if __BF__LastAIMemory[oUnit.data.owner][oUnit.ID]==nil then
			__BF__LastAIMemory[oUnit.data.owner][oUnit.ID] = {
				target = {},
				--opr = "NONE",
			}
		end
		local tPlayerAI,tUnitAI = __BF__LastAIMemory[oUnit.data.owner],__BF__LastAIMemory[oUnit.data.owner][oUnit.ID]
		tPlayerAI.mode = "rush"
		local oWorld = oUnit:getworld()
		--新一回合的AI统计
		if oWorld then
			--print("-----AI-----------")
			--攻城单位的特殊AI
			if oUnit.attr.siege>=3 and oUnit.data.type==hVar.UNIT_TYPE.UNIT and hApi.GetDefaultSkill(oUnit)~=0 then
				local nAllyCount = 0
				local nBuildingCount = 0
				local tGuardUnits = {}
				oWorld:enumunit(function(u)
					if u.data.IsDead==0 and u.data.owner==oUnit.data.owner and (oUnit.data.type==hVar.UNIT_TYPE.UNIT or oUnit.data.type==hVar.UNIT_TYPE.HERO) then
						nAllyCount = nAllyCount + 1
						local tAI = tPlayerAI[u.ID]
						if tAI~=nil and tAI.opr=="GUARD" and hApi.GetDefaultSkill(u)~=0 then
							tGuardUnits[#tGuardUnits+1] = u
						end
					end
				end)
				if oWorld.data.cover.pec<100 then
					--攻城单位选择目标时使用这个特殊的函数
					tUnitAI.AITargetFunc = hGlobal.AI_COMMON_FUNC.SiegeUnitSelectBuilding
				elseif #tGuardUnits>=1 then
					--有单位被挡住了也使用这个特殊的函数
					tUnitAI.AITargetFunc = hGlobal.AI_COMMON_FUNC.GetSiegeUnitHelpFunc(tGuardUnits)
				else
					--其他情况不优先攻击建筑
					tUnitAI.AITargetFunc = hGlobal.AI_COMMON_FUNC.SiegeUnitSelectUnit
				end
			end
		end
		return tPlayerAI,tUnitAI
	end
end
hGlobal.event:listen("Event_BattlefieldStart","__BFAI__InitMemory",function()
	hApi.UpdateAIMemory("init")
end)
hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BFAI__ClearMemory",function()
	hApi.UpdateAIMemory("release")
end)

--------------------------------
--公用AI函数
hGlobal.AI_COMMON_FUNC = {}
--------------------------------
--攻城单位优先攻击建筑
--hGlobal.AI_COMMON_FUNC.SiegeUnitSelectBuilding = function(oUnit,nSkillId,tChoosen,oTargetL,IsKeeped)
--	local tTemp = {}
--	for i = 1,#tChoosen do
--		local t = tChoosen[i][1]
--		if t.attr.duration==1 then
--			--自动忽略会在本回合消失的生物
--		elseif t==oTargetL then
--			--会连续攻击同一个目标的
--			return unpack(tChoosen[i])
--		elseif t.data.type==hVar.UNIT_TYPE.BUILDING then
--			tTemp[#tTemp+1] = tChoosen[i]
--		end
--	end
--	if #tTemp>0 then
--		local nIndex = nil
--		local nGateCount = 0
--		for i = 1,#tTemp do
--			if tTemp[i][1].data.IsGate==1 then
--				nGateCount = nGateCount + 1
--				nIndex = i
--			end
--		end
--		if nGateCount~=1 then
--			nIndex = nil
--			if nGateCount>1 then
--				local nMnHp = 9999999
--				for i = 1,#tTemp do
--					if tTemp[i][1].data.IsGate==1 and tTemp[i][1].attr.hp<nMnHp then
--						nMnHp = tTemp[i][1].attr.hp
--						nIndex = i
--					end
--				end
--			else
--				nIndex = nil
--				local nMnHp = 9999999
--				for i = 1,#tTemp do
--					if tTemp[i][1].attr.hp<nMnHp then
--						nMnHp = tTemp[i][1].attr.hp
--						nIndex = i
--					end
--				end
--			end
--		end
--		if nIndex~=nil then
--			return unpack(tTemp[nIndex])
--		end
--	end
--end
----------------------------------
----攻城单位优先攻击障碍(防御者)
--hGlobal.AI_COMMON_FUNC.GetSiegeUnitHelpFunc = function(tGuardUnits)
--	return function(oUnit,nSkillId,tChoosen,oTargetL,IsKeeped)
--		local tTemp = {}
--		for i = 1,#tGuardUnits do
--			local t = tGuardUnits[i]
--			if t.data.IsDead==0 then
--				tTemp[#tTemp+1] = t
--			end
--		end
--		if #tTemp>0 then
--			local oWorld = oUnit:getworld()
--			local cu = tTemp[hApi.random(1,#tTemp)]
--			for i = 1,#tChoosen do
--				tTemp[i] = oWorld:distanceU(cu,tChoosen[i][1],1)
--			end
--			local nIndex
--			local nMin = 999999
--			for i = 1,#tChoosen do
--				local t = tChoosen[i][1]
--				if t.attr.duration==1 then
--					--自动忽略会在本回合消失的生物
--				elseif t.data.type==hVar.UNIT_TYPE.BUILDING then
--					--t.chaUI["abc"] = hUI.label:new({
--						--font = "num",
--						--parent = t.handle._n,
--						--text = tostring(tTemp[i]),
--					--})
--					if tTemp[i]<nMin then
--						nMin = tTemp[i]
--						nIndex = i
--					end
--					if t==oTargetL then
--						nIndex = i
--						break
--					end
--				end
--			end
--			if nIndex then
--				local v = tChoosen[nIndex]
--				tChoosen[1] = v
--				for i = #tChoosen,2,-1 do
--					tChoosen[i] = nil
--				end
--			end
--			return hGlobal.AI_COMMON_FUNC.SiegeUnitSelectBuilding(oUnit,nSkillId,tChoosen,oTargetL,IsKeeped)
--		end
--	end
--end
----------------------------------
----攻城单位优先攻击单位
--hGlobal.AI_COMMON_FUNC.SiegeUnitSelectUnit = function(oUnit,nSkillId,tChoosen,oTargetL,IsKeeped)
--	--不变更目标
--	if IsKeeped==1 then
--		return
--	end
--	--使攻城单位不主动攻击城墙
--	local tTemp = {}
--	for i = 1,#tChoosen do
--		local t = tChoosen[i][1]
--		if t.data.type~=hVar.UNIT_TYPE.BUILDING then
--			tTemp[#tTemp+1] = tChoosen[i]
--		end
--	end
--	if #tTemp>0 then
--		for i = #tChoosen,1,-1 do
--			tChoosen[i] = nil
--		end
--		for i = 1,#tTemp do
--			tChoosen[i] = tTemp[i]
--		end
--	end
--end