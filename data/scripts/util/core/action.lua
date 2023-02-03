-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的行为类
--@单位可以进行行为，比如技能就是一个行为
--@行为可以与单位有关也可以无关，可以认为是计时器
--@这玩意不需要保存
hClass.action = eClass:new("static enum")
local _ha = hClass.action
_ha.__static = {}
_ha.__static.actionCodeList = {}
_ha.__static.failToProcess = {}

---------------------------------------
-- 初始化
---------------------------------------
local __DefaultParam = {
	mode = "skill",
	areaMode = 0, --影响DamageArea和HealArea的作用方式(0:以目标格子为中心，半径内的格子，1:以释放者为中心，触及范围内的格子)
	damageType = 0, --技能伤害类型，决定了技能会造成什么伤害
	cast = 0,
	CastOrder = 0, --发出此技能的命令模式,某些特殊命令不触发任何额外流程(hVar.ORDER_TYPE)
	param = 0,
	skillId = 0,
	castId = 0, --该技能如果是由技能额外触发的，那么此id会被设置成施展时所用技能的Id
	released = 0, --是否已经脱离施放者(变成了buff)
	waitingFor = 0, --调用Wait后，此action将等待某些条件从而再次激活(buff类)
	--loopcount = {}, --碰到loop时自动初始化此count
	power = 100, --伤害比例，100%
	world = 0, --object
	ownerside = 0,
	owner = 0,
	unit = 0, --object
	unit_worldC = 0,
	target_worldC = 0, --geyachao: 新加数据 目标唯一id(防止目标死亡，打到新目标上)
	target = 0,		--object
	targetC = 0,		--object
	TempAttr = 0,		--__AnalyzeValueExpr()函数会用到，第一次调用此值后，英雄各种数值会在此处被记录下来，下面再次使用的话会使用此处记录的值
	--bindU = {0,0,0},
	--effect = {},
	--summons = {},
	--tempValue = {},
	gridX = 0,
	gridY = 0,
	castX = 0,
	castY = 0,
	castFacing = 0,
	worldX = 0,
	worldY = 0,
	group = 0, --用来保存一组单位信息
	rMin = 0,
	rMax = 0,
	dMin = 0,
	dMax = 0,
	oGridX = 0,
	oGridY = 0,
	template = 0,
	action = 0,
	manacost = 0, --施放此技能时消耗的魔法值
	targetCount = 0, --如果指定了此值为{}，则所有RandomTarget选择单位时会增加计数，每个单位至多被选择x次
	targetCond = 0, --特殊指定目标的单位信息
	IsNoTrigger = 0, --该技能禁止触发一些特殊处理
	IsAttack = 0, --如果是角色的攻击技能或反击技能，则此值为1
	IsInterrupt = 1, --该技能是否会被中断
	IsFlee = 0, --如果是攻击，且被闪避了，此值为1
	IsBuff = 0, --此技能物体已经转变为buff(此值为buffName!)
	IsCast = 0, --此技能物体是否来源于"施法"
	IsPaused = 0, --暂停，某些情况下会禁止self:doNextAction()
	IsFacingTo = 1, --此技能是否需要面向目标(光环类技能无需面向目标)
	IsShowPlus = 0, --显示攻击加成(如果一个技能显示过加成，那么其CastSkill创建的技能物体将都不显示攻击加成)
	IsQuickAction = 0, --如果世界是QuickBattlefield，那么跳过某些执行过程
	IsAura = 0, --如果此技能是光环，那么此数值大于0，且对应world.data.aura中的某一项
	IsAuraBuff = 0, --如果此技能是光环BUFF，那么此数值大于0，且对应world.data.aura中的某一项
	LastActiveRound = 0, --最后一次(UnitActive)激活的轮次,大部分技能的UnitActive每轮只能激活一次
	errorCount = 0,
	lockCount = 0, --如果此值大于0，则说明此技能物体将世界锁定了，在移除时需要使世界的actioncount - 1
	replaceTick = 0, --如果覆盖了另外一个buff,这个值会被设置成当前时间
	pLightingEffect = 0, --技能携带的闪电链特效(程序指针！)
	BuffState = 0, --如果技能携带了特殊状态,这个值会变成{}，并将特殊BuffState记入此处
	maxtime = math.huge, --geyachao: 技能物体最大存在时间(TD里面，buff设置了状态存在的时间， 该项会生效)
	skillTimes = 0, --geyachao: 技能释放的次数
	--gold_crit_rate = 0, --geyachao: 击杀小兵爆钱的几率（去掉百分号后的值）
	--gold_crit_value = 2.0, --geyachao: 击杀小兵爆钱的倍率（支持小数）
	
	buffTag = 0, --geyachao: 记录buff的标识符(例如: "#ICE")
	buffTick = -1, --geyachao: 记录buff的tick间隔
	buffTickDmg = 0, --geyachao: 记录bufftick触发的伤害
	buffTickDmgMode = 0, --geyachao: 记录bufftick触发的伤害类型
	buffTickSkillId = 0, --geyachao: 记录bufftick触发的释放技能
	buffTickSkillId_T = 0, --geyachao: 记录bufftick触发的释放技能（目标对角色施法）
	buffTickLv = 0, --geyachao: 记录bufftick触发的释放技能等级
	buffRemoveSkillId = 0, --geyachao: 记录bufftick移除时释放技能
	buffRemoveLv = 0, --geyachao: 记录bufftick移除时释放技能等级
	lastTick = 0, --geyachao: 上一次tick触发的时间（buff的）
	level = 1, --geyachao: 新加参数：等级（技能或者buff的）
	stack = 1, --geyachao: 新加参数：堆叠层数（buff的）
	
	FLYEFFECTS = 0, --飞行特效集
	
	buffState_Stun = 0, --geyachao: 新加参数：buff是否造成眩晕
	buffState_BianDa = 0, --geyachao: 新加参数：buff是否变大
	buffState_ImmuePhysic = 0, --geyachao: 新加参数：buff是否物理免疫
	buffState_ImmueMagic = 0, --geyachao: 新加参数：buff是否法术免疫
	buffState_ImmueWuDi = 0, --geyachao: 新加参数：buff是否无敌
	buffState_ImmueDamage = 0, --geyachao: 新加参数：buff是否免疫伤害
	buffState_ImmueDamageIce = 0, --geyachao: 新加参数：buff是否免疫冰伤害
	buffState_ImmueDamageThunder = 0, --geyachao: 新加参数：buff是否免疫雷伤害
	buffState_ImmueDamageFire = 0, --geyachao: 新加参数：buff是否免疫火伤害
	buffState_ImmueDamagePoison = 0, --geyachao: 新加参数：buff是否免疫毒伤害
	buffState_ImmueDamageBullet = 0, --geyachao: 新加参数：buff是否免疫子弹伤害
	buffState_ImmueDamageBoom = 0, --geyachao: 新加参数：buff是否免疫爆炸伤害
	buffState_ImmueDamageChuanci = 0, --geyachao: 新加参数：buff是否免疫穿刺伤害
	buffState_ImmueControl = 0, --geyachao: 新加参数：buff是否免控
	buffState_ImmueDebuff = 0, --geyachao: 新加参数：buff是否免疫负面属性效果
	buffState_SufferChaos = 0, --geyachao: 新加参数：buff是否混乱
	buffState_SufferBlow = 0, --geyachao: 新加参数：buff是否吹风
	buffState_SufferChuanCi = 0, --geyachao: 新加参数：buff是否穿刺
	buffState_SufferSleep = 0, --geyachao: 新加参数：buff是否沉睡
	buffState_SufferChenmo = 0, --geyachao: 新加参数：buff是否沉默
	buffState_SufferJinYan = 0, --geyachao: 新加参数：buff是否禁言（不能普通攻击）
	buffState_Ground = 0, --geyachao: 新加参数：buff是否变地面单位
	buffState_SufferTouMing = 0, --geyachao: 新加参数：buff是否透明（不能碰撞）
	
	cast_target_type = 0, --geyachao: 新加参数：技能可生效的目标类型（用于效率优化）
	cast_target_space_type = 0, --geyachao: 新加参数：技能可生效的控件类型（用于效率优化）
	
	ChainLastTarget = 0, --geyachao: 新加参数： 闪电链上一次的目标
	ChainTargetList = 0, ---geyachao: 新加 TD所有技能生效的目标列表(例如闪电链，技能对多个目标生效了)
}

local __StaticParam = {
	actionIndex = 0,
	processTag = "start",
	tick = 1,
	past = 0, --技能物体存在的时间
	loop = 0,
}

--geyachao: 添加眩晕状态
hApi.AddStunState = function(oUnit)
	local attr = oUnit.attr
	attr.stun_stack = attr.stun_stack + 1 --眩晕次数加1
	--print("hApi.AddStunState", oUnit.data.name, attr.stun_stack)
	if (attr.stun_stack == 1) then --首次进入眩晕
		--角色停下来
		hApi.UnitStop_TD(oUnit)
		
		--标记角色的AI状态为眩晕
		oUnit:setAIState(hVar.UNIT_AI_STATE.STUN)
		
		--角色当前不会锁定攻击单位
		local lockTarget = oUnit.data.lockTarget
		--oUnit.data.lockTarget = 0
		--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
		hApi.UnitTryToLockTarget(oUnit, 0, 0)
		--print("lockType", oUnit.data.name, 0)
		
		--检测锁定的目标，是否也解除对该单位的锁定
		if (lockTarget ~= 0) then
			if (lockTarget.data.lockTarget == oUnit) then
				if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
					--lockTarget.data.lockTarget = 0 --也解除锁定
					--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(lockTarget, 0, 0)
					--print("lockType", lockTarget.data.name, 0)
				end
			end
		end
	end
	
	--触发角色眩晕、僵直、混乱、沉睡状态变化事件
	hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
end

--geyachao: 添加变大状态
local __AddBigState = function(oUnit, oAction)
	local attr = oUnit.attr
	attr.big_stack = attr.big_stack + 1 --变大次数加1
	
	if (attr.big_stack == 1) then --首次进入变大
		--模型变大
		local scale = CCEaseSineIn:create(CCScaleTo:create(0.5, 1.3))
		oUnit.handle._n:runAction(scale)
	end
end

--geyachao: 添加物理免疫状态
local __AddImmuePhysicState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_physic_stack = attr.immue_physic_stack + 1 --物理免疫次数加1
	
	if (attr.immue_physic_stack == 1) then --首次进入物理免疫
		--添加物理免疫特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_physic_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加法术免疫状态
local __AddImmueMagicState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_magic_stack = attr.immue_magic_stack + 1 --法术免疫次数加1
	
	if (attr.immue_magic_stack == 1) then --首次进入法术免疫
		--[[
		--添加法术免疫特效
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.immue_magic_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加无敌状态
local __AddImmueWuDiState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_wudi_stack = attr.immue_wudi_stack + 1 --无敌次数加1
	
	if (attr.immue_wudi_stack == 1) then --首次进入无敌
		--添加无敌特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_wudi_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加免疫伤害状态
local __AddImmueDamageState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_damage_stack = attr.immue_damage_stack + 1 --免疫伤害次数加1
	
	if (attr.immue_damage_stack == 1) then --首次进入无敌
		--添加免疫伤害特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_damage_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加免疫指定类型的伤害状态
local __AddImmueDamageTypeState = function(oUnit, nDamageMode)
	local attr = oUnit.attr
	
	if (nDamageMode == hVar.DAMAGE_TYPE.ICE) then --冰伤害
		attr.immue_damage_ice_stack = attr.immue_damage_ice_stack + 1 --免疫伤害次数加1
	elseif (nDamageMode == hVar.DAMAGE_TYPE.THUNDER) then --雷伤害
		attr.immue_damage_thunder_stack = attr.immue_damage_thunder_stack + 1 --免疫伤害次数加1
	elseif (nDamageMode == hVar.DAMAGE_TYPE.FIRE) then --火伤害
		attr.immue_damage_fire_stack = attr.immue_damage_fire_stack + 1 --免疫伤害次数加1
		--print("immue_damage_fire_stack=", attr.immue_damage_fire_stack)
	elseif (nDamageMode == hVar.DAMAGE_TYPE.POISON) then --毒伤害
		attr.immue_damage_poison_stack = attr.immue_damage_poison_stack + 1 --免疫伤害次数加1
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BULLET) then --子弹伤害
		attr.immue_damage_bullet_stack = attr.immue_damage_bullet_stack + 1 --免疫伤害次数加1
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BOMB) then --爆炸伤害
		attr.immue_damage_boom_stack = attr.immue_damage_boom_stack + 1 --免疫伤害次数加1
	elseif (nDamageMode == hVar.DAMAGE_TYPE.CHUANCI) then --穿刺伤害
		attr.immue_damage_chuanci_stack = attr.immue_damage_chuanci_stack + 1 --免疫伤害次数加1
	end
	
	if (attr.immue_damage_stack == 1) then --首次进入无敌
		--添加免疫伤害特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_damage_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加免控状态
local __AddImmueControlState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_control_stack = attr.immue_control_stack + 1 --免控次数加1
	
	if (attr.immue_control_stack == 1) then --首次进入免控
		--添加免控特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_control_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加免疫负面属性状态
local __AddImmueDebuffState = function(oUnit)
	local attr = oUnit.attr
	attr.immue_debuff_stack = attr.immue_debuff_stack + 1 --免疫负面属性次数加1
	
	if (attr.immue_debuff_stack == 1) then --首次进入免疫负面属性
		--添加免疫负面属性特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.immue_debuff_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加混乱状态
local __AddSufferChaosState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_chaos_stack = attr.suffer_chaos_stack + 1 --混乱次数加1
	
	if (attr.suffer_chaos_stack == 1) then --首次进入混乱
		--添加混乱特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		--local offsetY = -(math.floor(cy - ch/2))
		local offsetY = -math.floor(cy)
		local offsetZ = 0
		local effectId = 568
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_chaos_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
		
		--单位开始进入混乱状态，随机移动到附近的某个坐标点
		hApi.UnitBeginChaos(oUnit)
		
		--触发角色眩晕、僵直、混乱、沉睡状态变化事件
		hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
	end
end

--单位开始进入混乱状态，随机移动到附近的某个坐标点
hApi.UnitBeginChaos = function(oUnit)
	--不在眩晕，不在僵直状态，不在沉睡状态
	if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_sleep_stack == 0) then
		--单位当前不在障碍物或者水里
		local world = oUnit:getworld()
		local cx, cy = hApi.chaGetPos(oUnit.handle)
		local result = xlScene_IsGridBlock(g_world, cx / 24, cy / 24) --某个坐标是否是障碍
		if (result == 1) or (hApi.IsPosInWater(cx, cy) == 1) then --寻路失败，或者在水里
			--如果角色此刻在障碍里，那么调用寻路会立即出发移动到达（失败）事件，然后AI继续混乱状态，直到stack overflow
			--停止移动
			hApi.UnitStop_TD(oUnit)
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--设置状态为闲置
			oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
		else --当前处在有效点
			--停止移动
			hApi.UnitStop_TD(oUnit)
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--随机一个附近坐标
			local rx = world:random(30, 90)
			local ry = world:random(30, 90)
			local sginx = ((world:random(1, 2) == 1) and (1) or (-1))
			local sginy = ((world:random(1, 2) == 1) and (1) or (-1))
			local tx = cx + rx * sginx
			local ty = cy + ry * sginy
			
			--开始移动
			--取消锁定的目标
			local lockTarget = oUnit.data.lockTarget
			hApi.UnitTryToLockTarget(oUnit, 0, 0)
			
			--检测目标是否也解除对其的锁定
			if (lockTarget ~= 0) then
				if (lockTarget.data.lockTarget == oUnit) then
					if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
						hApi.UnitTryToLockTarget(lockTarget, 0, 0)
					end
				end
			end
			
			--设置状态为移动混乱状态（单位无目的乱走）
			oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_CHAOS)
			
			--转向
			local facing = GetFaceAngle(cx, cy, tx, ty) --角色的朝向(角度制)
			hApi.ChaSetFacing(oUnit.handle, facing)
			oUnit.data.facing = facing
			
			--移动到该点
			hApi.UnitMoveToPoint_TD(oUnit, tx, ty, true, 60)
		end
	end
end

--人质单位开始进入混乱状态，随机移动到附近的某个坐标点，或者移动到坦克身边
hApi.UnitBeginHostageChaos = function(oUnit)
	--不在眩晕，不在僵直状态，不在沉睡状态
	if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_sleep_stack == 0) then
		--单位当前不在障碍物或者水里
		local world = oUnit:getworld()
		local cx, cy = hApi.chaGetPos(oUnit.handle)
		local result = xlScene_IsGridBlock(g_world, cx / 24, cy / 24) --某个坐标是否是障碍
		if (result == 1) or (hApi.IsPosInWater(cx, cy) == 1) then --寻路失败，或者在水里
			--如果角色此刻在障碍里，那么调用寻路会立即出发移动到达（失败）事件，然后AI继续混乱状态，直到stack overflow
			--停止移动
			hApi.UnitStop_TD(oUnit)
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--设置状态为闲置
			oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
		else --当前处在有效点
			--停止移动
			hApi.UnitStop_TD(oUnit)
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--开始移动
			--取消锁定的目标
			local lockTarget = oUnit.data.lockTarget
			hApi.UnitTryToLockTarget(oUnit, 0, 0)
			
			--检测目标是否也解除对其的锁定
			if (lockTarget ~= 0) then
				if (lockTarget.data.lockTarget == oUnit) then
					if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
						hApi.UnitTryToLockTarget(lockTarget, 0, 0)
					end
				end
			end
			
			--随机一个附近坐标
			local rx = world:random(50, 120)
			local ry = world:random(50, 120)
			local sginx = ((world:random(1, 2) == 1) and (1) or (-1))
			local sginy = ((world:random(1, 2) == 1) and (1) or (-1))
			local tx = cx + rx * sginx
			local ty = cy + ry * sginy
			
			local result = xlScene_IsGridBlock(g_world, tx / 24, ty / 24) --某个坐标是否是障碍
			if (result == 1) or (hApi.IsPosInWater(tx, ty) == 1) then
				--设置状态为闲置
				oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
			else
				--设置状态为人质移动混乱状态（单位无目的乱走）
				oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS)
				
				--检测人质和主角坦克的距离
				if (oUnit.data.id == hVar.MY_TANK_SCIENTST_ID) then
					local rpgunit_tank = world.data.rpgunit_tank
					if rpgunit_tank and (rpgunit_tank ~= 0) then
						local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
						local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --包围盒
						local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --中心点x位置
						local hero_center_y = hero_y + (hero_by + hero_bh / 2) --中心点y位置
						local dx = hero_center_x - cx
						local dy = hero_center_y - cy
						local dd = math.sqrt(dx * dx + dy * dy)
						--print(dd, hVar.HOSTAGE_FOLLOW_RADIUS)
						if (dd <= hVar.HOSTAGE_FOLLOW_RADIUS) then
							local angle = GetLineAngle(cx, cy, hero_center_x, hero_center_y)
							local fangle = angle * math.pi / 180 --弧度制
							fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
							local step = 48 --剩余的长度
							local tx_orin = tx
							local ty_orin = ty
							tx = cx + step * math.cos(fangle) --尝试到达的x坐标
							ty = cy + step * math.sin(fangle) --尝试到达的y坐标
							tx = math.floor(tx * 100) / 100  --保留2位有效数字，用于同步
							ty = math.floor(ty * 100) / 100  --保留2位有效数字，用于同步
							
							--设置状态为人质移动混乱状态（单位无目的乱走）
							oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK)
							
							local IsBolck = hApi.IsPathBlock(cx, cy, tx, ty)
							local result = xlScene_IsGridBlock(g_world, tx / 24, ty / 24) --某个坐标是否是障碍
							if  (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tx, ty) == 1) then
								tx = tx_orin
								ty = ty_orin
							end
						end
					end
				end
				
				--hVar.HOSTAGE_FOLLOW_RADIUS
				
				--移动到该点
				hApi.UnitMoveToPoint_TD(oUnit, tx, ty, true, 60)
			end
		end
	end
end

--单位停止混乱状态
hApi.UnitStopChaos = function(oUnit)
	--停止移动
	hApi.UnitStop_TD(oUnit)
	
	--先停掉角色原先的技能释放
	hApi.StopSkillCast(oUnit)
	
	--标记守卫点
	local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
	oUnit.data.defend_x = t_x
	oUnit.data.defend_y = t_y
	
	--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
	if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
		--设置状态为闲置
		oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
	end
end

--geyachao: 添加吹风状态
local __AddSufferBlowState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_blow_stack = attr.suffer_blow_stack + 1 --吹风次数加1
	
	--目标眩晕
	hApi.AddStunState(oUnit)
	
	if (attr.suffer_blow_stack == 1) then --首次进入吹风
		--添加吹风特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_blow_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
		
		--print("添加吹风状态")
		
		--先停掉之前的动画
		--oUnit.handle._n:stopAllActions()
		
		local ROT_TIME = (math.random(30, 40)) / 100
		local DIS = (math.random(300, 400)) / 10
		
		--图片上移动画
		local moveBy = CCMoveBy:create(0.2, ccp(0, 40))
		local scaleBy = CCScaleBy:create(0.2, 0.95)
		local spawn = CCSpawn:createWithTwoActions(moveBy, scaleBy) --同步
		local act1 = CCCallFunc:create(function(ctrl)
			--重置单位坐标
			local px, py = hApi.chaGetPos(oUnit.handle) --坐标
			oUnit.handle._n:setPosition(px + DIS / 2, -py + 40)
			
			--3D旋转
			local config = ccBezierConfig:new()
			config.controlPoint_1 = ccp(-DIS, DIS)     
			config.controlPoint_2 = ccp(-DIS, -DIS)
			config.endPosition = ccp(0, 0)
			local rot = CCBezierBy:create(ROT_TIME * 2, config)
			
			--翻转
			local ANG = (math.random(30, 60))
			local act8 = CCOrbitCamera:create(ROT_TIME, 1, 0, 0, ANG, 0, 0) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
			local act10 = CCOrbitCamera:create(ROT_TIME, 1, 0, 30, -ANG, 0, 0) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
			local a = CCArray:create()
			a:addObject(act8)
			a:addObject(act10)
			local sequence = CCSequence:create(a)
			
			--组合
			local spawn = CCSpawn:createWithTwoActions(rot, sequence) --同步
			local forever = CCRepeatForever:create(tolua.cast(spawn, "CCActionInterval"))
			
			--loop
			oUnit.handle._n:runAction(forever)
		end)
		local a = CCArray:create()
		a:addObject(spawn)
		a:addObject(act1)
		local sequence = CCSequence:create(a)
		oUnit.handle._n:runAction(sequence)
	end
end

--geyachao: 添加穿刺状态
local __AddSufferChuanCiState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_chuanci_stack = attr.suffer_chuanci_stack + 1 --穿刺次数加1
	
	--目标眩晕
	hApi.AddStunState(oUnit)
	
	if (attr.suffer_chuanci_stack == 1) then --首次进入穿刺
		--添加穿刺特效
		--[[
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 475
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_chuanci_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
		
		--print("添加穿刺状态")
		
		--先停掉之前的动画
		--oUnit.handle._n:stopAllActions()
		
		--动画
		local w = oUnit:getworld()
		local typeId = oUnit.data.id
		local WAITTIME = (w:random(10, 100)) / 1000 --等待时间 0.01~0.1秒
		local HEIGHT = 45 + ((typeId + w:random(1, 100)) % 36) --高度 45~80
		local TIME = (12 + ((typeId + w:random(1, 100)) % 14)) / 100 --飞上去的时间 0.12~0.25秒
		local act1 = CCDelayTime:create(WAITTIME)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(TIME, ccp(0, HEIGHT)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(TIME, ccp(0, -HEIGHT)))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		local sequence = CCSequence:create(a)
		oUnit.handle._n:runAction(sequence)
	else
		--先停掉之前的动画
		oUnit.handle._n:stopAllActions()
		
		--重置单位坐标
		local px, py = hApi.chaGetPos(oUnit.handle) --坐标
		oUnit.handle._n:setPosition(px, -py)
		
		--动画
		local typeId = oUnit.data.id
		local WAITTIME = (oUnit:getworld():random(1, 100)) / 1000
		local HEIGHT = 28 + (typeId % 22)
		local TIME = (9 + typeId % 11) / 100
		local act1 = CCDelayTime:create(WAITTIME)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(TIME, ccp(0, HEIGHT)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(TIME, ccp(0, -HEIGHT)))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		local sequence = CCSequence:create(a)
		oUnit.handle._n:runAction(sequence)
	end
end

--geyachao: 添加沉睡状态
local __AddSufferSleepState = function(oUnit)
	local attr = oUnit.attr
	
	--[[
	--原本有沉睡状态
	if (attr.suffer_sleep_stack > 0) then
		--遍历该单位身上存在的所有buff，移除沉睡标记
		local tt = oUnit.data["buffs"]
		if tt.index then
			for buff_key, n in pairs(tt.index) do
				if n and (n ~= 0) then
					local oID = tt[n]
					local oBuff = hClass.action:find(oID)
					if oBuff then --目标身上已有此buff
						--local buffId = oBuff.data.skillId --buff的技能id
						--print("目标身上已有此buff", oUnit.data.name, buffId)
						if (oBuff.data.buffState_SufferSleep == 1) then
							oBuff.data.buffState_SufferSleep = 0
						end
					end
				end
			end
		end
		
		--标记不在沉睡
		attr.suffer_sleep_stack = 0
	end
	]]
	
	attr.suffer_sleep_stack = attr.suffer_sleep_stack + 1 --沉睡次数加1
	
	--目标眩晕
	--hApi.AddStunState(oUnit)
	
	if (attr.suffer_sleep_stack == 1) then --首次进入沉睡免疫
		--[[
		--添加沉睡特效
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_chuanci_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
		
		--停止移动
		hApi.UnitStop_TD(oUnit)
		
		--先停掉角色原先的技能释放
		--hApi.StopSkillCast(oUnit)
		
		--标记单位当前的AI状态为沉睡
		oUnit:setAIState(hVar.UNIT_AI_STATE.SLEEP)
		--print("标记单位当前的AI状态为沉睡")
		
		--触发角色眩晕、僵直、混乱、沉睡状态变化事件
		hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
	end
end

--geyachao: 添加沉默状态
local __AddSufferChenmoState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_chenmo_stack = attr.suffer_chenmo_stack + 1 --沉默次数加1
	
	if (attr.suffer_chenmo_stack == 1) then --首次进入沉默状态
		--[[
		--添加沉默特效
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_chenmo_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
		
		--停掉角色原先的技能释放
		--hApi.StopSkillCast(oUnit)
		
		--沉默流程 本地战术卡处理
		local world = oUnit:getworld()
		local tOwner = oUnit:getowner()
		local oHero = oUnit:gethero()
		if oHero then
			if (tOwner == world:GetPlayerMe()) then
				local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
				for i = 1, #tacticCardCtrls, 1 do
					local cardi = tacticCardCtrls[i]
					if cardi and (cardi ~= 0) then
						if (cardi.data.bindHero == oHero) then --是绑定的该英雄
							--显示沉默的图标
							cardi.childUI["chenmo"].handle.s:setVisible(true)
							--print("沉默流程, 显示沉默的图标")
						end
					end
				end
			end
		end
		
		--触发角色眩晕、僵直、混乱、沉睡、沉默状态变化事件
		hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
	end
end

--geyachao: 添加禁言状态（不能普通攻击）
local __AddSufferJinYanState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_jinyan_stack = attr.suffer_jinyan_stack + 1 --禁言次数加1（不能普通攻击）
	
	if (attr.suffer_jinyan_stack == 1) then --首次进入禁言状态（不能普通攻击）
		--[[
		--添加禁言特效（不能普通攻击）
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_jinyan_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加变地面单位状态
local __AddSpaceGroundState = function(oUnit)
	local attr = oUnit.attr
	attr.space_ground_stack = attr.space_ground_stack + 1 --变地面单位次数加1
	
	if (attr.space_ground_stack == 1) then --首次进入变地面单位状态
		--[[
		--添加变地面单位特效
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.space_ground_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 添加透明状态（不能碰撞）
local __AddSufferTouMingState = function(oUnit)
	local attr = oUnit.attr
	attr.suffer_touming_stack = attr.suffer_touming_stack + 1 --透明次数加1（不能碰撞）
	
	if (attr.suffer_touming_stack == 1) then --首次进入透明状态（不能碰撞）
		--[[
		--添加碰撞特效（不能碰撞）
		local w = oUnit:getworld()
		local cx,cy,cw,ch = oUnit:getbox()
		local offsetX = math.floor(cx + cw/2)
		local offsetY = -math.floor(cy + ch/2)
		local offsetZ = 0
		local effectId = 144
		local loop = -1
		local skillId = -1
		oUnit.data.suffer_touming_effect = w:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
		]]
	end
end

--geyachao: 删除眩晕状态
hApi.RemoveStunState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.stun_stack > 0) then --防止不眩晕状态也调用
		attr.stun_stack = attr.stun_stack - 1 --眩晕次数减1
		
		--print("hApi.RemoveStunState", oUnit.data.name, attr.stun_stack)
		
		if (attr.stun_stack == 0) then --彻底摆脱眩晕
			--标记角色的AI状态为闲置
			oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
			
			--geyachao: 大菠萝，敌人标记为攻击状态
			if oUnit:getowner() and (oUnit:getowner():getforce() ~= hVar.FORCE_DEF.SHU) then
				--单位有普通攻击
				local atkId = oUnit.attr.attack[1]
				local dMax = oUnit.attr.attack[5]
				if (atkId > 0) and (dMax > 0) then
					local world = oUnit:getworld()
					local rpgunits = world.data.rpgunits
					for u, u_worldC in pairs(rpgunits) do
						if (u.data.id == hVar.MY_TANK_ID) then
							oUnit.data.lockTarget = u
							oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
							
							--geyachao: 大菠萝，减速蜘蛛，AI状态为释放技能
							if (oUnit.data.id == 11208) or (oUnit.data.id == 11247) or (oUnit.data.id == 11249) or (oUnit.data.id == 11253) then
								oUnit:setAIState(hVar.UNIT_AI_STATE.CAST_STATIC)
							end
						end
					end
				end
			end
		end
		
		--触发角色眩晕、僵直、混乱、沉睡状态变化事件
		hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
	else
		--当前仍然在眩晕状态
		--由滑行到达静止后，仍然中眩晕buff，此时标记ai状态为眩晕
		if (oUnit:getAIState() == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) and (oUnit.handle.UnitInMove == 0) then
			--设置状态为眩晕
			oUnit:setAIState(hVar.UNIT_AI_STATE.STUN)
		end
	end
end

--geyachao: 删除变大状态
local __RemoveBigState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.big_stack > 0) then --不重复删除
		attr.big_stack = attr.big_stack - 1 --变大次数减1
		
		if (attr.big_stack == 0) then --彻底摆脱变大
			--模型恢复
			local scale = CCEaseSineOut:create(CCScaleTo:create(0.5, 1.0))
			oUnit.handle._n:runAction(scale)
		end
	end
end

--geyachao: 删除物理免疫状态
local __RemoveImmuePhysicState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_physic_stack > 0) then --不重复删除
		attr.immue_physic_stack = attr.immue_physic_stack - 1 --物理免疫次数减1
		
		if (attr.immue_physic_stack == 0) then --彻底摆脱物理免疫
			--[[
			--移除物理免疫特效
			if (oUnit.data.immue_magic_effect ~= 0) then
				oUnit.data.immue_magic_effect:del()
				oUnit.data.immue_magic_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除法术免疫状态
local __RemoveImmueMagicState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_magic_stack > 0) then --不重复删除
		attr.immue_magic_stack = attr.immue_magic_stack - 1 --法术免疫次数减1
		
		if (attr.immue_magic_stack == 0) then --彻底摆脱法术免疫
			--[[
			--移除法术免疫特效
			if (oUnit.data.immue_physic_effect ~= 0) then
				oUnit.data.immue_physic_effect:del()
				oUnit.data.immue_physic_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除无敌状态
local __RemoveImmueWuDiState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_wudi_stack > 0) then --不重复删除
		attr.immue_wudi_stack = attr.immue_wudi_stack - 1 --无敌次数减1
		
		if (attr.immue_wudi_stack == 0) then --彻底摆脱无敌
			--[[
			--移除无敌特效
			if (oUnit.data.immue_wudi_effect ~= 0) then
				oUnit.data.immue_wudi_effect:del()
				oUnit.data.immue_wudi_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除免疫伤害状态
local __RemoveImmueDamageState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_damage_stack > 0) then --不重复删除
		attr.immue_damage_stack = attr.immue_damage_stack - 1 --免疫伤害次数减1
		
		if (attr.immue_damage_stack == 0) then --彻底摆脱免疫伤害
			--[[
			--移除免疫伤害特效
			if (oUnit.data.immue_damage_effect ~= 0) then
				oUnit.data.immue_damage_effect:del()
				oUnit.data.immue_damage_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除免疫指定类型伤害状态
local __RemoveImmueDamageTypeState = function(oUnit, nDamageMode)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (nDamageMode == hVar.DAMAGE_TYPE.ICE) then --冰伤害
		if (attr.immue_damage_ice_stack > 0) then --不重复删除
			attr.immue_damage_ice_stack = attr.immue_damage_ice_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.THUNDER) then --雷伤害
		if (attr.immue_damage_thunder_stack > 0) then --不重复删除
			attr.immue_damage_thunder_stack = attr.immue_damage_thunder_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.FIRE) then --火伤害
		if (attr.immue_damage_fire_stack > 0) then --不重复删除
			attr.immue_damage_fire_stack = attr.immue_damage_fire_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.POISON) then --毒伤害
		if (attr.immue_damage_poison_stack > 0) then --不重复删除
			attr.immue_damage_poison_stack = attr.immue_damage_poison_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BULLET) then --子弹伤害
		if (attr.immue_damage_bullet_stack > 0) then --不重复删除
			attr.immue_damage_bullet_stack = attr.immue_damage_bullet_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.BOMB) then --爆炸伤害
		if (attr.immue_damage_boom_stack > 0) then --不重复删除
			attr.immue_damage_boom_stack = attr.immue_damage_boom_stack - 1 --免疫伤害次数减1
		end
	elseif (nDamageMode == hVar.DAMAGE_TYPE.CHUANCI) then --穿刺伤害
		if (attr.immue_damage_chuanci_stack > 0) then --不重复删除
			attr.immue_damage_chuanci_stack = attr.immue_damage_chuanci_stack - 1 --免疫伤害次数减1
		end
	end
	
	--[[
	--移除免疫伤害特效
	if (oUnit.data.immue_damage_effect ~= 0) then
		oUnit.data.immue_damage_effect:del()
		oUnit.data.immue_damage_effect = 0
	end
	]]
end

--geyachao: 删除免控状态
local __RemoveImmueControlState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_control_stack > 0) then --不重复删除
		attr.immue_control_stack = attr.immue_control_stack - 1 --免控次数减1
		
		if (attr.immue_control_stack == 0) then --彻底摆脱免控
			--[[
			--移除免控特效
			if (oUnit.data.immue_control_effect ~= 0) then
				oUnit.data.immue_control_effect:del()
				oUnit.data.immue_control_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除免疫负面属性状态
local __RemoveImmueDebuffState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.immue_debuff_stack > 0) then --不重复删除
		attr.immue_debuff_stack = attr.immue_debuff_stack - 1 --免疫负面属性次数减1
		
		if (attr.immue_debuff_stack == 0) then --彻底摆脱免疫负面属性
			--[[
			--移除免疫负面属性特效
			if (oUnit.data.immue_debuff_effect ~= 0) then
				oUnit.data.immue_debuff_effect:del()
				oUnit.data.immue_debuff_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除混乱状态
local __RemoveSufferChaosState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_chaos_stack > 0) then --不重复删除
		attr.suffer_chaos_stack = attr.suffer_chaos_stack - 1 --混乱次数减1
		
		if (attr.suffer_chaos_stack == 0) then --彻底摆脱混乱
			--[[
			--移除混乱特效
			if (oUnit.data.suffer_chaos_effect ~= 0) then
				oUnit.data.suffer_chaos_effect:del()
				oUnit.data.suffer_chaos_effect = 0
			end
			]]
			
			--单位停止混乱状态
			hApi.UnitStopChaos(oUnit)
			
			--触发角色眩晕、僵直、混乱、沉睡状态变化事件
			hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
		end
	end
end

--geyachao: 删除吹风状态
local __RemoveSufferBlowState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_blow_stack > 0) then --不重复删除
		attr.suffer_blow_stack = attr.suffer_blow_stack - 1 --混乱次数减1
		
		--目标解除眩晕
		hApi.RemoveStunState(oUnit)
		
		if (attr.suffer_blow_stack == 0) then --彻底摆脱混乱
			--[[
			--移除吹风特效
			if (oUnit.data.suffer_blow_effect ~= 0) then
				oUnit.data.suffer_blow_effect:del()
				oUnit.data.suffer_blow_effect = 0
			end
			]]
			
			--print("删除吹风状态")
			
			--先停掉之前的动画
			oUnit.handle._n:stopAllActions()
			
			local ROT_TIME = (math.random(30, 40)) / 100
			local DIS = (math.random(100, 200)) / 10
			
			--图片下移动画
			local moveBy = CCMoveBy:create(0.08, ccp(0, -40))
			local scaleTo = CCScaleTo:create(0.08, 1.0)
			local spawn = CCSpawn:createWithTwoActions(moveBy, scaleTo) --同步
			local act1 = CCCallFunc:create(function(ctrl)
				--翻转
				local act10 = CCOrbitCamera:create(ROT_TIME, 1, 0, 30, -30, 0, 0) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
				
				--结束
				local act1 = CCCallFunc:create(function()
					--重置单位坐标
					local px, py = hApi.chaGetPos(oUnit.handle) --坐标
					oUnit.handle._n:setPosition(px, -py)
				end)
				
				--顺序
				local sequence = CCSequence:createWithTwoActions(act10, act1)
				oUnit.handle._n:runAction(sequence)
			end)
			local a = CCArray:create()
			a:addObject(spawn)
			a:addObject(act1)
			local sequence = CCSequence:create(a)
			oUnit.handle._n:runAction(sequence)
		end
	end
end

--geyachao: 删除穿刺状态
local __RemoveSufferChuanCiState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_chuanci_stack > 0) then --不重复删除
		attr.suffer_chuanci_stack = attr.suffer_chuanci_stack - 1 --穿刺次数减1
		
		--目标解除眩晕
		hApi.RemoveStunState(oUnit)
		
		if (attr.suffer_chuanci_stack == 0) then --彻底摆脱穿刺
			--[[
			--移除穿刺特效
			if (oUnit.data.suffer_chuanci_effect ~= 0) then
				oUnit.data.suffer_chuanci_effect:del()
				oUnit.data.suffer_chuanci_effect = 0
			end
			]]
			
			--print("删除穿刺状态")
			
			--先停掉之前的动画
			oUnit.handle._n:stopAllActions()
			
			--重置单位坐标
			local px, py = hApi.chaGetPos(oUnit.handle) --坐标
			oUnit.handle._n:setPosition(px, -py)
		end
	end
end

--geyachao: 删除沉睡状态
local __RemoveSufferSleepState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_sleep_stack > 0) then --不重复删除
		attr.suffer_sleep_stack = attr.suffer_sleep_stack - 1 --沉睡次数减1
		
		--目标解除眩晕
		--hApi.RemoveStunState(oUnit)
		
		if (attr.suffer_sleep_stack == 0) then --彻底摆脱沉睡
			--[[
			--移除沉睡特效
			if (oUnit.data.suffer_sleep_effect ~= 0) then
				oUnit.data.suffer_sleep_effect:del()
				oUnit.data.suffer_sleep_effect = 0
			end
			]]
			
			--[[
			--遍历该单位身上存在的所有buff，移除沉睡标记
			local tt = oUnit.data["buffs"]
			if tt.index then
				for buff_key, n in pairs(tt.index) do
					if n and (n ~= 0) then
						local oID = tt[n]
						local oBuff = hClass.action:find(oID)
						if oBuff then --目标身上已有此buff
							--local buffId = oBuff.data.skillId --buff的技能id
							--print("目标身上已有此buff", oUnit.data.name, buffId)
							if (oBuff.data.buffState_SufferSleep == 1) then
								oBuff.data.buffState_SufferSleep = 0
							end
						end
					end
				end
			end
			]]
			
			--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
			if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
				--设置状态为闲置
				oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
			end
			
			--触发角色眩晕、僵直、混乱、沉睡状态变化事件
			hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
			
			--print("删除沉睡状态")
		end
	end
end

--geyachao: 删除沉默状态
local __RemoveSufferChenmoState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_chenmo_stack > 0) then --不重复删除
		attr.suffer_chenmo_stack = attr.suffer_chenmo_stack - 1 --沉默次数减1
		
		if (attr.suffer_chenmo_stack == 0) then --彻底摆脱沉默
			--[[
			--移除沉默特效
			if (oUnit.data.suffer_chenmo_effect ~= 0) then
				oUnit.data.suffer_chenmo_effect:del()
				oUnit.data.suffer_chenmo_effect = 0
			end
			]]
			
			--沉默流程 本地战术卡处理
			local world = oUnit:getworld()
			local tOwner = oUnit:getowner()
			local oHero = oUnit:gethero()
			if oHero then
				if (tOwner == world:GetPlayerMe()) then
					local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
					for i = 1, #tacticCardCtrls, 1 do
						local cardi = tacticCardCtrls[i]
						if cardi and (cardi ~= 0) then
							if (cardi.data.bindHero == oHero) then --是绑定的该英雄
								--隐藏沉默的图标
								cardi.childUI["chenmo"].handle.s:setVisible(false)
								--print("取消沉默流程, 隐藏沉默的图标")
							end
						end
					end
				end
			end
			
			--触发角色眩晕、僵直、混乱、沉睡、沉默状态变化事件
			hGlobal.event:event("Event_UnitStunStaticState", oUnit, attr.stun_stack, 0, attr.suffer_chaos_stack, attr.suffer_sleep_stack, attr.suffer_chenmo_stack)
		end
	end
end

--geyachao: 删除禁言状态（不能普通攻击）
local __RemoveSufferJinYanState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_jinyan_stack > 0) then --不重复删除
		attr.suffer_jinyan_stack = attr.suffer_jinyan_stack - 1 --禁言次数减1（不能普通攻击）
		
		if (attr.suffer_jinyan_stack == 0) then --彻底摆脱禁言（不能普通攻击）
			--[[
			--移除禁言特效
			if (oUnit.data.suffer_jinyan_effect ~= 0) then
				oUnit.data.suffer_jinyan_effect:del()
				oUnit.data.suffer_jinyan_effect = 0
			end
			]]
		end
	end
end

--geyachao: 删除变地面单位状态
local __RemoveSpaceGroundState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.space_ground_stack > 0) then --不重复删除
		attr.space_ground_stack = attr.space_ground_stack - 1 --变地面单位次数减1
		
		if (attr.space_ground_stack == 0) then --彻底摆脱变地面单位
			--...
		end
	end
end

--geyachao: 删除透明状态（不能碰撞）
local __RemoveSufferTouMingState = function(oUnit)
	--死亡后不住处理
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	local attr = oUnit.attr
	if (attr.suffer_touming_stack > 0) then --不重复删除
		attr.suffer_touming_stack = attr.suffer_touming_stack - 1 --透明次数减1（不能不能碰撞）
		
		if (attr.suffer_touming_stack == 0) then --彻底摆脱透明（不能不能碰撞）
			--[[
			--移除透明特效
			if (oUnit.data.suffer_touming_effect ~= 0) then
				oUnit.data.suffer_touming_effect:del()
				oUnit.data.suffer_touming_effect = 0
			end
			]]
		end
	end
end


--初始化
_ha.init = function(self, p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.data = hApi.ReadParam(__StaticParam,nil,self.data)
	local d = self.data
	d.tick = 0
	
	--if (d.skillId == 14017) then
	--	print("ha.init")
	--end
	
	local u = d.unit
	if (u == nil) or (u == 0) then
		--print("self:del(1)")
		return self:del()
	end
	--local cx,cy = u:getXY() --geyachao: 用程序接口取坐标
	local cx,cy = hApi.chaGetPos(u.handle) --geyachao: 用程序接口取坐标
	d.castFacing = u.data.facing
	d.castX = cx
	d.castY = cy
	if type(p.power)=="number" then
		--复制的power
		d.power = p.power
	else
		if u.data.bossID>0 and u.attr.hp==-1 then
			--无生命的部件,伤害加成使用boss的
			local oUnitB = hClass.unit:find(u.data.bossID)
			if oUnitB then
				d.power = oUnitB.attr.power
				if d.IsCast==1 then
					d.power = d.power + oUnitB.attr.castpower
				end
				if d.CastOrder==hVar.ORDER_TYPE.COUNTER then
					d.power = d.power + oUnitB.attr.counterpower
				end
			end
		else
			--一般单位读取power
			d.power = u.attr.power
			if d.IsCast==1 then
				d.power = d.power + u.attr.castpower
			end
			if d.CastOrder==hVar.ORDER_TYPE.COUNTER then
				d.power = d.power + u.attr.counterpower
			end
		end
	end
	if (type(p.castId) == "number") then
		d.castId = p.castId
	else
		d.castId = d.skillId
	end
	d.ownerside = u:getowner() and u:getowner():getforce() or 1
	d.owner = u.data.owner
	d.power = math.max(1, d.power)
	d.errorCount = 0
	d.unit_worldC = u:getworldC()
	
	if d.target and (d.target ~= 0) then --geyachao: 新加 ，用于检测目标是否已被复用
		d.target_worldC = d.target:getworldC()
	end
	d.tempValue = {}
	--if (d.skillId == 14017) then
	--	print("tempValue 初始化")
	--end
	
	--存储等级
	if (p.level) then
		d.level = p.level --等级
		d.tempValue["@lv"] = p.level --等级
		--geyachao: print
		--print("技能等级", p.level, d.skillId)
	else
		--print("技能等级 无", 0, d.skillId)
		--print(debug.traceback())
		d.level = 0 --等级0
		d.tempValue["@lv"] = 0 --等级0
	end
	
	--存储堆叠层数
	if (p.stack) then
		d.stack = p.stack --堆叠层数
		d.tempValue["@stack"] = p.stack --堆叠层数
	else
		d.stack = 1 --堆叠层数
		d.tempValue["@stack"] = 1 --堆叠层数
	end
	
	--存储本次技能释放的次数
	if (p.skillTimes) then
		d.skillTimes = p.skillTimes
		d.tempValue["@skillTimes"] = p.skillTimes --技能释放的次数
	else
		d.skillTimes = 0
		d.tempValue["@skillTimes"] = 0 --技能释放的次数
	end
	
	--存储本次技能战车的运动状态
	if (p.runState) then
		d.tempValue["@runState"] = p.runState --战车的运动状态
	else
		d.tempValue["@runState"] = 0 --战车的运动状态
	end
	
	--存储击杀小兵爆钱的几率（去掉百分号后的值）
	--if (p.gold_crit_rate) then
	--	d.gold_crit_rate = p.gold_crit_rate --击杀小兵爆钱的几率（去掉百分号后的值）
	--	d.tempValue["gold_crit_rate"] = p.gold_crit_rate --击杀小兵爆钱的几率（去掉百分号后的值）
	--else
	--	d.gold_crit_rate = 0 --击杀小兵爆钱的几率（去掉百分号后的值）
	--	d.tempValue["gold_crit_rate"] = 0 --击杀小兵爆钱的几率（去掉百分号后的值）
	--end
	
	--存储击杀小兵爆钱的倍率（支持小数）
	--if (p.gold_crit_value) then
	--	d.gold_crit_value = p.gold_crit_value --击杀小兵爆钱的倍率（支持小数）
	--	d.tempValue["gold_crit_value"] = p.gold_crit_value --击杀小兵爆钱的倍率（支持小数）
	--else
	--	d.gold_crit_value = 2.0 --击杀小兵爆钱的倍率（支持小数）
	--	d.tempValue["gold_crit_value"] = 2.0 --击杀小兵爆钱的倍率（支持小数）
	--end
	
	--处理buff添加的状态
	--眩晕状态
	if (d.buffState_Stun == 1) then
		hApi.AddStunState(d.target)
		--print("+眩晕状态")
	end
	--变大状态
	if (d.buffState_BianDa == 1) then
		__AddBigState(d.target)
		--print("+变大状态")
	end
	--物理免疫状态
	if (d.buffState_ImmuePhysic == 1) then
		__AddImmuePhysicState(d.target)
		--print("+物理免疫状态")
	end
	--法术免疫状态
	if (d.buffState_ImmueMagic == 1) then
		__AddImmueMagicState(d.target)
		--print("+法术免疫状态")
	end
	--无敌状态
	if (d.buffState_ImmueWuDi == 1) then
		__AddImmueWuDiState(d.target)
		--print("+无敌状态")
	end
	--免疫伤害状态
	if (d.buffState_ImmueDamage == 1) then
		__AddImmueDamageState(d.target)
		--print("+免疫伤害状态")
	end
	--免疫冰伤害状态
	if (d.buffState_ImmueDamageIce == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.ICE)
		--print("+免疫冰伤害状态")
	end
	--免疫雷伤害状态
	if (d.buffState_ImmueDamageThunder == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.THUNDER)
		--print("+免疫雷伤害状态")
	end
	--免疫火伤害状态
	if (d.buffState_ImmueDamageFire == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.FIRE)
		--print("+免疫火伤害状态",d.target.data.name, hVar.DAMAGE_TYPE.FIRE)
	end
	--免疫毒伤害状态
	if (d.buffState_ImmueDamagePoison == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.POISON)
		--print("+免疫毒伤害状态")
	end
	--免疫子弹伤害状态
	if (d.buffState_ImmueDamageBullet == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.BULLET)
		--print("+免疫子弹伤害状态")
	end
	--免疫爆炸伤害状态
	if (d.buffState_ImmueDamageBoom == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.BOMB)
		--print("+免疫爆炸伤害状态")
	end
	--免疫穿刺伤害状态
	if (d.buffState_ImmueDamageChuanci == 1) then
		__AddImmueDamageTypeState(d.target, hVar.DAMAGE_TYPE.CHUANCI)
		--print("+免疫穿刺伤害状态")
	end
	--免控状态
	if (d.buffState_ImmueControl == 1) then
		__AddImmueControlState(d.target)
		--print("+免控状态")
	end
	--免疫负面属性状态
	if (d.buffState_ImmueDebuff == 1) then
		__AddImmueDebuffState(d.target)
		--print("+免疫负面属性状态")
	end
	--混乱状态
	if (d.buffState_SufferChaos == 1) then
		__AddSufferChaosState(d.target)
		--print("+混乱状态")
	end
	--吹风状态
	if (d.buffState_SufferBlow == 1) then
		__AddSufferBlowState(d.target)
		--print("+吹风状态")
	end
	--穿刺状态
	if (d.buffState_SufferChuanCi == 1) then
		__AddSufferChuanCiState(d.target)
		--print("+穿刺状态")
	end
	--沉睡状态
	if (d.buffState_SufferSleep == 1) then
		__AddSufferSleepState(d.target)
		--print("+沉睡状态", d.target.data.name, d.skillId)
	end
	--沉默状态
	if (d.buffState_SufferChenmo == 1) then
		__AddSufferChenmoState(d.target)
		--print("+沉默状态", d.target.data.name, d.skillId)
	end
	--禁言状态
	if (d.buffState_SufferJinYan == 1) then
		__AddSufferJinYanState(d.target)
		--print("+禁言状态", d.target.data.name, d.skillId)
	end
	--变地面单位状态
	if (d.buffState_Ground == 1) then
		__AddSpaceGroundState(d.target)
		--print("+变地面单位状态", d.target.data.name, d.skillId)
	end
	--透明状态
	if (d.buffState_SufferTouMing == 1) then
		__AddSufferTouMingState(d.target)
		--print("+透明状态", d.target.data.name, d.skillId)
	end
	
	--输出
	--print(d.skillTimes)
	
	d.effect = {}
	d.summons = {}
	d.loopcount = {}
	d.loopindex = {}
	d.bindU = {0,0,0}
	local w = u:getworld()
	if w~=nil then
		d.world = w
		if w.data.IsQuickBattlefield==1 then
			d.IsQuickAction = 1
		end
	end
	local tabS = hVar.tab_skill[d.skillId]
	--复制参数
	if p.tempValue and type(p.tempValue)=="table" then
		for k,v in pairs(p.tempValue)do
			d.tempValue[k] = v
		end
		if tabS and tabS.enhanceID then
			for i = 1,#tabS.enhanceID do
				local nId = tabS.enhanceID[i]
				if hVar.tab_skill[nId] and hVar.tab_skill[nId].enhanceParam then
					local s = u:getskill(nId)
					local tVal = hVar.tab_skill[nId].enhanceParam
					for n = 1,#tVal do
						if s and s[2]>0 then
							d.tempValue[tVal[1]] = tVal[2]
						else
							d.tempValue[tVal[1]] = 0
						end
					end
				end
			end
		end
	end
	--初始化坐标
	if not(type(p.gridX)=="number" and type(p.gridY)=="number") then
		if d.cast==hVar.OPERATE_TYPE.SKILL_TO_UNIT and d.target~=0 then
			--local ux,uy = u:getXY()
			local ux,uy = hApi.chaGetPos(u.handle) --geyachao: 用程序接口取坐标
			d.gridX,d.gridY = hApi.GetGridByUnitAndXY(d.target,"near",ux,uy)
		else
			d.gridX,d.gridY = u.data.gridX,u.data.gridY
		end
	end
	--初始化世界坐标(特效播放的位置)
	if not(type(p.worldX)=="number" and type(p.worldY)=="number") then
		if d.cast==hVar.OPERATE_TYPE.SKILL_TO_UNIT and d.target~=0 then
			--d.worldX,d.worldY = d.target:getXY() --geyachao: 用程序接口取坐标
			d.worldX,d.worldY = hApi.chaGetPos(d.target.handle)
		elseif tabS and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.AUTO) then
			d.worldX,d.worldY = d.castX,d.castY
		else
			d.worldX,d.worldY = w:grid2xy(d.gridX,d.gridY)
		end
	end
	
	--if (d.skillId == 14017) then
	--	print("w=", w)
	--	print("d.mode=", d.mode)
	--	print("tabS=", tabS)
	--end
	
	if w~=nil and d.mode=="skill" and tabS then
		if d.template==0 and tabS.template~=nil then
			d.template = tabS.template		--字符串
		end
		--需要读取技能等级
		if tabS.readlv and type(tabS.readlv)=="number" then
			if tabS.readlv==1 then
				local s = u:getskill(d.skillId)
				if s then
					d.tempValue["@lv"] = s[2]
				end
			else
				local s = u:getskill(tabS.readlv)
				if s then
					d.tempValue["@lv"] = s[2]
				end
			end
		end
		--多次激活模式
		local nActiveMode = tabS.activemode
		if nActiveMode==2 then
			--可无限激活(但nActiveMode==hVar.ROUND_DEFINE.ACTIVE_MODE.NONE的时候不激活)
			d.LastActiveRound = -1
		elseif nActiveMode==3 then
			--只要单位行动就可以激活
			d.LastActiveRound = -2
		end
		--区域模式
		if p.areaMode==nil and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.AUTO) then
			d.areaMode = 1
		end
		if tabS.area~=nil then
			d.rMin,d.rMax = tabS.area[1],tabS.area[2]
		end
		if d.action==0 and tabS.action~=nil and #tabS.action>0 then
			d.action = tabS.action
		end
		
		d.IsInterrupt = tabS.IsInterrupt or 1 --该技能是否会被中断
		
		d.cast_target_type = tabS.cast_target_type --geyachao: 新加参数：技能可生效的目标类型（用于效率优化）
		d.cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --geyachao: 新加参数：技能可生效的控件类型（用于效率优化）
		
		--if (d.skillId == 14017) then
		--	print("技能可生效的目标类型（用于效率优化）", d.skillId)
		--	print("tabS.cast_target_type=", tabS.cast_target_type)
		--	print("tabS.cast_target_space_type=", tabS.cast_target_space_type)
		--end
		
		--技能回蓝显示的特殊处理(此值仅作显示用)
		if d.IsQuickAction~=1 and d.manacost<0 then
			if hGlobal.LocalPlayer:getfocusworld()==w then
				hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,u,"mp",-1*d.manacost)
			end
		end
		hGlobal.event:call("Event_UnitCastSkill",u,d.skillId,self)
	end
	if d.action~=0 then
		return self:go("start",1)
	end
end

_ha.destroy = function(self)
	local d = self.data
	local u = d.unit
	local oWorld
	if d.world~=0 then
		oWorld = d.world
	end
	if d.lockCount~=0 and oWorld then
		oWorld.data.actioncount = oWorld.data.actioncount - d.lockCount		--激活技能计数-1
		d.lockCount = 0
	end
	self:removeAllControlEffect()
	self:removeAllControlUnit()
	if d.bindU[1]~=0 then
		hApi.unbind2Object(self,"bindU",hApi.GetObjectUnit(d.bindU),"buffs")
	end
	
	
	--移除目标身上的特效
	if (d.skillId == 31047) then
		if d.target and (d.target ~= 0) then
			d.target:RemoveTacingEffect()
		end
	end
	
	d.group = 0
	d.action = 0
	d.unit = 0
	d.target = 0
	d.unit_worldC = 0 --geyachao: 删除
	d.target_worldC = 0 --geyachao: 删除
	d.world = 0
	d.maxtime = math.huge --geyachao: 删除
	
	d.buffTag = 0 --geyachao: 删除 记录buff的标识符(例如: "#ICE")
	d.buffTick = -1 --geyachao: 删除
	d.buffTickDmg = 0 --geyachao: 删除
	d.buffTickDmgMode = 0 --geyachao: 删除
	d.buffTickSkillId = 0 --geyachao: 删除
	d.buffTickSkillId_T = 0 --geyachao: 记录bufftick触发的释放技能（目标对角色施法）
	d.buffTickLv = 0 --geyachao: 删除
	d.buffRemoveSkillId = 0 --geyachao: 记录bufftick移除时释放技能
	d.buffRemoveLv = 0 --geyachao: 记录bufftick移除时释放技能等级
	d.lastTick = 0 --geyachao: 删除
	d.level = 1 --geyachao: 重置等级
	d.stack = 1 --geyachao: 重置堆叠层数
	d.ChainLastTarget = 0 --geyachao: 新加参数： 闪电链上一次的目标 删除
	d.ChainTargetList = 0 --geyachao: 删除
	d.cast_target_type = 0 --geyachao: 新加参数：技能可生效的目标类型（用于效率优化）
	d.cast_target_space_type = 0 --geyachao: 新加参数：技能可生效的控件类型（用于效率优化）
	d.buffState_Stun = 0 --geyachao: 新加
	d.buffState_BianDa = 0 --geyachao: 新加
	d.buffState_ImmuePhysic = 0 --geyachao: 新加
	d.buffState_ImmueMagic = 0 --geyachao: 新加
	d.buffState_ImmueWuDi = 0 --geyachao: 新加参数：buff是否无敌
	d.buffState_ImmueDamage = 0 --geyachao: 新加参数：buff是否免疫伤害
	d.buffState_ImmueDamageIce = 0 --geyachao: 新加参数：buff是否免疫冰伤害
	d.buffState_ImmueDamageThunder = 0 --geyachao: 新加参数：buff是否免疫雷伤害
	d.buffState_ImmueDamageFire = 0 --geyachao: 新加参数：buff是否免疫火伤害
	d.buffState_ImmueDamagePoison = 0 --geyachao: 新加参数：buff是否免疫毒伤害
	d.buffState_ImmueDamageBullet = 0 --geyachao: 新加参数：buff是否免疫子弹伤害
	d.buffState_ImmueDamageBoom = 0 --geyachao: 新加参数：buff是否免疫爆炸伤害
	d.buffState_ImmueDamageChuanci = 0 --geyachao: 新加参数：buff是否免疫穿刺伤害
	d.buffState_ImmueControl = 0 --geyachao: 新加参数：buff是否免控
	d.buffState_ImmueDebuff = 0 --geyachao: 新加参数：buff是否免疫负面属性效果
	d.buffState_SufferChaos = 0 --geyachao: 新加参数：buff是否混乱
	d.buffState_SufferBlow = 0 --geyachao: 新加参数：buff是否吹风
	d.buffState_SufferChuanCi = 0 --geyachao: 新加参数：buff是否穿刺
	d.buffState_SufferSleep = 0 --geyachao: 新加参数：buff是否沉睡
	d.buffState_SufferChenmo = 0 --geyachao: 新加参数：buff是否沉默
	d.buffState_SufferJinYan = 0 --geyachao: 新加参数：buff是否禁言（不能普通攻击）
	d.buffState_Ground = 0 --geyachao: 新加参数：buff是否变地面单位
	d.buffState_SufferTouMing = 0 --geyachao: 新加参数：buff是否透明（不能碰撞）
	
	d.FLYEFFECTS = 0 --飞行特效集
	
	if d.pLightingEffect~=0 and type(d.pLightingEffect)=="userdata" then
		xlChainEffect_End(d.pLightingEffect)
		
	end
	d.pLightingEffect = 0
	if d.IsAura~=0 and oWorld then
		local nAuraUnique = d.IsAura
		d.IsAura = 0
		oWorld:removeaura(nAuraUnique)
	end
end

---------------------------------------
-- 功能函数
---------------------------------------
_ha.addControlEffect = function(self,oEffect)
	local t = self.data.effect
	local o = oEffect
	if o and o.ID~=0 then
		t[#t+1] = hApi.SetObjectEx({},o)
	end
end

_ha.removeAllControlEffect = function(self)
	local t = self.data.effect
	if #t>0 then
		for i = #t,1,-1 do
			local o = hApi.GetObjectEx(hClass.effect,t[i])
			if o then
				o:del()
			end
			t[i] = nil
		end
	end
end

_ha.addControlUnit = function(self,oUnit)
	local t = self.data.summons
	local o = oUnit
	if o and o.ID~=0 then
		t[#t+1] = hApi.SetObjectEx({},o)
	end
end

_ha.removeAllControlUnit = function(self)
	local d = self.data
	local t = self.data.summons
	if #t>0 then
		for i = #t,1,-1 do
			local o = hApi.GetObjectEx(hClass.unit,t[i])
			if o and o.ID~=d.bindU[1] then
				o:dead(hVar.OPERATE_TYPE.SKILL_TO_UNIT,d.unit,d.skillId,0, 0, 0)
			end
			t[i] = nil
		end
	end
end

local __ProcessTagConvert = {
	["start"] = "release",			--开始
	["continue"] = 1,			--继续
	["wakeup"] = "continue",		--延迟了xx毫秒,对应sleep
}
local __CODE__ProcessAction = function(self)
	local d = self.data
	--print("__CODE__ProcessAction", tostring(self), "processTag=" .. tostring(d.processTag))
	if d.errorCount==1 then
		_DEBUG_MSG("\n技能 id = "..tostring(d.skillId).." 执行出错，自我删除")
		--print("self:del(2)")
		return self:del("safe")
	end
	local oWorld = d.world
	d.errorCount = 1
	if oWorld~=0 then
		if __ProcessTagConvert[d.processTag]~=nil then
			if __ProcessTagConvert[d.processTag]~=1 then
				d.processTag = __ProcessTagConvert[d.processTag]
			end
			if d.lockCount>0 then
				oWorld.data.actioncount = oWorld.data.actioncount - d.lockCount
				d.lockCount = 0
			end
			if d.action~=0 then
				d.errorCount = 0
				local sNextStep,nWaitTick = self:doNextAction()
				--print("sNextStep=" .. sNextStep,nWaitTick)
				if oWorld.data.IsQuickBattlefield==1 then
					--快速战场处理流程
					--不能被暂停或等待
					if sNextStep==nil then
						--啥也不做
						--print("啥也不做啥也不做啥也不做2222222222222222222")
					elseif sNextStep=="release" then
						return self:go("release",1)
					elseif sNextStep=="wait" then
						return self:go("wait",0)
					elseif sNextStep=="sleep" then
						return self:go("wakeup",1)
					elseif d.errorCount==1 then
						_DEBUG_MSG("[LUA WARNING][快速战场]技能(id="..d.skillId..")执行出现问题，请检查逻辑",sNextStep)
						return self:go("release",1)
					else
						return self:go(sNextStep,1)
					end
				elseif sNextStep==nil then
					--啥也不做
					--print("sNextStep", sNextStep, "啥也不做啥也做啥也做啥也做啥也做啥也不做啥也不做")
					d.processTag = "wait"
					d.tick = 0
					d.errorCount = 0
				elseif sNextStep=="sleep" then
					d.lockCount = d.lockCount + 1
					oWorld.data.actioncount = oWorld.data.actioncount + 1
					return self:go("wakeup",math.max(1,nWaitTick or 1))
				elseif sNextStep=="wait" then
					return self:go("wait",0)
				else
					return self:go(sNextStep,math.max(1,nWaitTick or 1))
				end
			else
				d.errorCount = 0
			end
		elseif d.processTag=="missile" then
			--等待箭矢到达回调
			d.tick = 0
			d.errorCount = 0
		elseif d.processTag=="wait" then
			--等待其他东西触发
			d.tick = 0
			d.errorCount = 0
		elseif d.processTag=="release" then
			--什么都不做，结束了
			d.errorCount = 0
		end
	else
		d.processTag = "release"
		d.errorCount = 0
	end
	--print("d.tick2=" .. d.tick)
	if self.ID~=0 and d.processTag=="release" then
		--print("self:del(3)")
		return self:del()
	end
end

_ha.go = function(self,processTag, nWaitTick)
	local d = self.data
	d.tick = math.max(0, nWaitTick or 1)
	--print("d.tick1 = math.max(0,nWaitTick or 1)", d.tick, tostring(self), "processTag=" .. tostring(processTag))
	d.processTag = processTag or d.processTag
	if d.tick==1 then
		return __CODE__ProcessAction(self)
	end
end

--geyachao: 移除buff对属性的影响
local __RemoveBuffEffect = function(oAction)
	--取消buff设置的属性改变
	local tempValue = oAction.data.tempValue --临时数据存储表
	local target = oAction.data.target --目标
	if target and (target ~= 0) then --有效的目标
		local attr = target.attr --目标属性表
		
		--"hp_max"
		if tempValue["hp_max_buff"] then --血量
			--修改当前血量
			local olpHp = target.attr.hp
			local oldHpMax = target:GetHpMax()
			local oldPrecent = olpHp / oldHpMax
			local newHpMax = oldHpMax - tempValue["hp_max_buff"]
			
			--修改当前血量
			local newHp = hApi.floor(newHpMax * oldPrecent)
			if (newHp <= 0) and (oldPrecent > 0) then --例如原来为 1/1 的学，加buff变成 1001/1001, 被打成 500/1001之后还原, 应该保留1点血
				--newHp = 1
			end
			target.attr.hp = newHp
			
			--更新血条控件
			if target.chaUI["hpBar"] then
				target.chaUI["hpBar"]:setV(newHp, newHpMax)
				--print("oUnit.chaUI4()", newHp, newHpMax)
			end
			if target.chaUI["numberBar"] then
				target.chaUI["numberBar"]:setText(newHp .. "/" .. newHpMax)
			end
			
			attr["hp_max_buff"] = attr["hp_max_buff"] - tempValue["hp_max_buff"]
		end
		
		--"atk"
		if tempValue["atk_buff"] then --攻击力
			attr["atk_buff"] = attr["atk_buff"] - tempValue["atk_buff"]
		end
		
		--"atk_interval"
		if tempValue["atk_interval_buff"] then --攻击间隔
			attr["atk_interval_buff"] = attr["atk_interval_buff"] - tempValue["atk_interval_buff"]
		end
		
		--"atk_speed"
		if tempValue["atk_speed_buff"] then --攻击速度
			attr["atk_speed_buff"] = attr["atk_speed_buff"] - tempValue["atk_speed_buff"]
		end
		
		--"move_speed"
		if tempValue["move_speed_buff"] then --移动速度
			attr["move_speed_buff"] = attr["move_speed_buff"] - tempValue["move_speed_buff"]
			
			--取消附加移动速度
			hApi.chaAddMoveSpeed(target.handle)
		end
		
		--"atk_radius"
		if tempValue["atk_radius_buff"] then --攻击范围
			attr["atk_radius_buff"] = attr["atk_radius_buff"] - tempValue["atk_radius_buff"]
		end
		
		--"atk_radius_min"
		if tempValue["atk_radius_min_buff"] then --攻击范围
			attr["atk_radius_min_buff"] = attr["atk_radius_min_buff"] - tempValue["atk_radius_min_buff"]
		end
		
		--if tempValue["atk_search_radius_buff"] then --攻击搜敌范围
		--	attr["atk_search_radius_buff"] = attr["atk_search_radius_buff"] - tempValue["atk_search_radius_buff"]
		--end
		
		--"def_physic"
		if tempValue["def_physic_buff"] then --物防
			attr["def_physic_buff"] = attr["def_physic_buff"] - tempValue["def_physic_buff"]
		end
		
		--"def_magic"
		if tempValue["def_magic_buff"] then --法防
			attr["def_magic_buff"] = attr["def_magic_buff"] - tempValue["def_magic_buff"]
		end
		
		--"dodge_rate"
		if tempValue["dodge_rate_buff"] then --闪避几率（去百分号后的值）
			attr["dodge_rate_buff"] = attr["dodge_rate_buff"] - tempValue["dodge_rate_buff"]
		end
		
		--"hit_rate"
		if tempValue["hit_rate_buff"] then --命中几率（去百分号后的值）
			attr["hit_rate_buff"] = attr["hit_rate_buff"] - tempValue["hit_rate_buff"]
		end
		
		--"crit_rate"
		if tempValue["crit_rate_buff"] then --暴击几率（去百分号后的值）
			attr["crit_rate_buff"] = attr["crit_rate_buff"] - tempValue["crit_rate_buff"]
		end
		
		--"crit_value"
		if tempValue["crit_value_buff"] then --暴击倍数
			attr["crit_value_buff"] = attr["crit_value_buff"] - tempValue["crit_value_buff"]
		end
		
		--"kill_gold"
		if tempValue["kill_gold_buff"] then --击杀获得的金币
			attr["kill_gold_buff"] = attr["kill_gold_buff"] - tempValue["kill_gold_buff"]
		end
		
		--"escape_punish"
		if tempValue["escape_punish_buff"] then --逃怪惩罚
			attr["escape_punish_buff"] = attr["escape_punish_buff"] - tempValue["escape_punish_buff"]
		end
		
		--"hp_restore"
		if tempValue["hp_restore_buff"] then --回血速度
			attr["hp_restore_buff"] = attr["hp_restore_buff"] - tempValue["hp_restore_buff"]
			--print("移除回血速度", target.data.name, tempValue["hp_restore_buff"])
		end
		
		--"rebirth_time"
		if tempValue["rebirth_time_buff"] then --复活时间（毫秒）
			attr["rebirth_time_buff"] = attr["rebirth_time_buff"] - tempValue["rebirth_time_buff"]
		end
		
		--"suck_blood_rate"
		if tempValue["suck_blood_rate_buff"] then --吸血率（去百分号后的值）
			attr["suck_blood_rate_buff"] = attr["suck_blood_rate_buff"] - tempValue["suck_blood_rate_buff"]
		end
		
		--"active_skill_cd_delta"
		if tempValue["active_skill_cd_delta_buff"] then --主动技能冷却时间变化值（毫秒）
			attr["active_skill_cd_delta_buff"] = attr["active_skill_cd_delta_buff"] - tempValue["active_skill_cd_delta_buff"]
			
			--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
			local oHero = target:gethero()
			if oHero then
				local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
				local activeSkillCDMul = activeSkillCDOrigin * 1000
				local active_skill_cd_delta = target:GetActiveSkillCDDelta() --geyachao: cd附加改变值
				local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
				local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
				activeSkillCDMul = activeSkillCDMul + delta
				local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
				
				--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
				oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
				--print("-buff: 如果单位绑定了英雄，那么修改英雄数据的主动技能的cd", "value=", -tempValue["active_skill_cd_delta_buff"], "activeSkillCD=", activeSkillCD)
			end
		end
		
		--"passive_skill_cd_delta"
		if tempValue["passive_skill_cd_delta_buff"] then --被动技能冷却时间变化值（毫秒）
			attr["passive_skill_cd_delta_buff"] = attr["passive_skill_cd_delta_buff"] - tempValue["passive_skill_cd_delta_buff"]
		end
		
		--"active_skill_cd_delta_rate"
		if tempValue["active_skill_cd_delta_rate_buff"] then --主动技能冷却时间变化比例值（去百分号后的值）
			attr["active_skill_cd_delta_rate_buff"] = attr["active_skill_cd_delta_rate_buff"] - tempValue["active_skill_cd_delta_rate_buff"]
			
			--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
			local oHero = target:gethero()
			if oHero then
				local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
				local activeSkillCDMul = activeSkillCDOrigin * 1000
				local active_skill_cd_delta = target:GetActiveSkillCDDelta() --geyachao: cd附加改变值
				local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
				local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
				activeSkillCDMul = activeSkillCDMul + delta
				local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
				
				--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
				oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
				--print("-buff: 如果单位绑定了英雄，那么修改英雄数据的主动技能的cd", "value=", -tempValue["active_skill_cd_delta_rate_buff"], "activeSkillCD=", activeSkillCD)
			end
		end
		
		--"passive_skill_cd_delta_rate"
		if tempValue["passive_skill_cd_delta_rate_buff"] then --被动技能冷却时间变化比例值（去百分号后的值）
			attr["passive_skill_cd_delta_rate_buff"] = attr["passive_skill_cd_delta_rate_buff"] - tempValue["passive_skill_cd_delta_rate_buff"]
		end
		
		--"AI_attribute"
		if tempValue["AI_attribute_buff"] then --AI行为（0：被动怪 / 1:主动怪）
			attr["AI_attribute_buff"] = attr["AI_attribute_buff"] - tempValue["AI_attribute_buff"]
		end
		
		--"atk_ice"
		if tempValue["atk_ice_buff"] then --冰攻击力
			attr["atk_ice_buff"] = attr["atk_ice_buff"] - tempValue["atk_ice_buff"]
		end
		
		--"atk_thunder"
		if tempValue["atk_thunder_buff"] then --雷攻击力
			attr["atk_thunder_buff"] = attr["atk_thunder_buff"] - tempValue["atk_thunder_buff"]
		end
		
		--"atk_fire"
		if tempValue["atk_fire_buff"] then --火攻击力
			attr["atk_fire_buff"] = attr["atk_fire_buff"] - tempValue["atk_fire_buff"]
		end
		
		--"atk_poison"
		if tempValue["atk_poison_buff"] then --毒攻击力
			attr["atk_poison_buff"] = attr["atk_poison_buff"] - tempValue["atk_poison_buff"]
		end
		
		--"atk_bullet"
		if tempValue["atk_bullet_buff"] then --子弹攻击力
			attr["atk_bullet_buff"] = attr["atk_bullet_buff"] - tempValue["atk_bullet_buff"]
		end
		
		--"atk_bomb"
		if tempValue["atk_bomb_buff"] then --爆炸攻击力
			attr["atk_bomb_buff"] = attr["atk_bomb_buff"] - tempValue["atk_bomb_buff"]
		end
		
		--"atk_chuanci"
		if tempValue["atk_chuanci_buff"] then --穿刺攻击力
			attr["atk_chuanci_buff"] = attr["atk_chuanci_buff"] - tempValue["atk_chuanci_buff"]
		end
		
		--"def_ice"
		if tempValue["def_ice_buff"] then --冰防御
			attr["def_ice_buff"] = attr["def_ice_buff"] - tempValue["def_ice_buff"]
		end
		
		--"def_thunder"
		if tempValue["def_thunder_buff"] then --雷防御
			attr["def_thunder_buff"] = attr["def_thunder_buff"] - tempValue["def_thunder_buff"]
		end
		
		--"def_fire"
		if tempValue["def_fire_buff"] then --火防御
			attr["def_fire_buff"] = attr["def_fire_buff"] - tempValue["def_fire_buff"]
		end
		
		--"def_poison"
		if tempValue["def_poison_buff"] then --毒防御
			attr["def_poison_buff"] = attr["def_poison_buff"] - tempValue["def_poison_buff"]
		end
		
		--"def_bullet"
		if tempValue["def_bullet_buff"] then --子弹防御
			attr["def_bullet_buff"] = attr["def_bullet_buff"] - tempValue["def_bullet_buff"]
		end
		
		--"def_bomb"
		if tempValue["def_bomb_buff"] then --爆炸防御
			attr["def_bomb_buff"] = attr["def_bomb_buff"] - tempValue["def_bomb_buff"]
		end
		
		--"def_chuanci"
		if tempValue["def_chuanci_buff"] then --穿刺防御
			attr["def_chuanci_buff"] = attr["def_chuanci_buff"] - tempValue["def_chuanci_buff"]
		end
		
		--"bullet_capacity"
		if tempValue["bullet_capacity_buff"] then --携弹数量
			attr["bullet_capacity_buff"] = attr["bullet_capacity_buff"] - tempValue["bullet_capacity_buff"]
		end
		
		--"grenade_capacity"
		if tempValue["grenade_capacity_buff"] then --手雷数量
			attr["grenade_capacity_buff"] = attr["grenade_capacity_buff"] - tempValue["grenade_capacity_buff"]
		end
		
		--"grenade_child"
		if tempValue["grenade_child_buff"] then --子母雷数量
			attr["grenade_child_buff"] = attr["grenade_child_buff"] - tempValue["grenade_child_buff"]
		end
		
		--"grenade_fire"
		if tempValue["grenade_fire_buff"] then --手雷爆炸火焰
			attr["grenade_fire_buff"] = attr["grenade_fire_buff"] - tempValue["grenade_fire_buff"]
		end
		
		--"grenade_dis"
		if tempValue["grenade_dis_buff"] then --手雷投弹距离
			attr["grenade_dis_buff"] = attr["grenade_dis_buff"] - tempValue["grenade_dis_buff"]
		end
		
		--"grenade_cd"
		if tempValue["grenade_cd_buff"] then --手雷冷却时间
			attr["grenade_cd_buff"] = attr["grenade_cd_buff"] - tempValue["grenade_cd_buff"]
		end
		
		--"grenade_crit"
		if tempValue["grenade_crit_buff"] then --手雷暴击
			attr["grenade_crit_buff"] = attr["grenade_crit_buff"] - tempValue["grenade_crit_buff"]
		end
		
		--"grenade_multiply"
		if tempValue["grenade_multiply_buff"] then --手雷冷却前使用次数
			attr["grenade_multiply_buff"] = attr["grenade_multiply_buff"] - tempValue["grenade_multiply_buff"]
			
			--大菠萝，设置技能使用次数
			if (target.data.bind_weapon ~= 0) then
				local world = target:getworld()
				local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				if btn2 then
					local grenade_multiply = target:GetGrenadeMultiply()
					if (grenade_multiply > 1) then
						btn2.data.useCountMax = grenade_multiply
						btn2.data.useCount = grenade_multiply
						btn2.childUI["labSkillUseCount"].handle._n:setVisible(false) --改为都不显示次数了
						btn2.childUI["labSkillUseCount"]:setText(grenade_multiply)
						--手雷图标
						btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
					else
						btn2.data.useCountMax = grenade_multiply
						btn2.data.useCount = grenade_multiply
						btn2.childUI["labSkillUseCount"].handle._n:setVisible(false)
						--手雷图标
						btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
					end
				end
			end
		end
		
		--"inertia"
		if tempValue["inertia_buff"] then --惯性
			attr["inertia_buff"] = attr["inertia_buff"] - tempValue["inertia_buff"]
		end
		
		--"crystal_rate"
		if tempValue["crystal_rate_buff"] then --水晶收益率（去百分号后的值）
			attr["crystal_rate_buff"] = attr["crystal_rate_buff"] - tempValue["crystal_rate_buff"]
		end
		
		--"melee_bounce"
		if tempValue["melee_bounce_buff"] then --近战弹开
			attr["melee_bounce_buff"] = attr["melee_bounce_buff"] - tempValue["melee_bounce_buff"]
		end
		
		--"melee_fight"
		if tempValue["melee_fight_buff"] then --近战反击
			attr["melee_fight_buff"] = attr["melee_fight_buff"] - tempValue["melee_fight_buff"]
		end
		
		--"melee_stone"
		if tempValue["melee_stone_buff"] then --近战碎石
			attr["melee_stone_buff"] = attr["melee_stone_buff"] - tempValue["melee_stone_buff"]
		end
		
		--"pet_hp_restore"
		if tempValue["pet_hp_restore_buff"] then --宠物回血
			attr["pet_hp_restore_buff"] = attr["pet_hp_restore_buff"] - tempValue["pet_hp_restore_buff"]
		end
		
		--"pet_hp"
		if tempValue["pet_hp_buff"] then --宠物生命
			attr["pet_hp_buff"] = attr["pet_hp_buff"] - tempValue["pet_hp_buff"]
		end
		
		--"pet_atk"
		if tempValue["pet_atk_buff"] then --宠物攻击
			attr["pet_atk_buff"] = attr["pet_atk_buff"] - tempValue["pet_atk_buff"]
		end
		
		--"pet_atk_speed"
		if tempValue["pet_atk_speed_buff"] then --宠物攻速
			attr["pet_atk_speed_buff"] = attr["pet_atk_speed_buff"] - tempValue["pet_atk_speed_buff"]
		end
		
		--"pet_capacity"
		if tempValue["pet_capacity_buff"] then --宠物携带数量
			attr["pet_capacity_buff"] = attr["pet_capacity_buff"] - tempValue["pet_capacity_buff"]
		end
		
		--"trap_ground"
		if tempValue["trap_ground_buff"] then --陷阱时间（单位：毫秒）
			attr["trap_ground_buff"] = attr["trap_ground_buff"] - tempValue["trap_ground_buff"]
		end
		
		--"trap_groundcd"
		if tempValue["trap_groundcd_buff"] then --陷阱施法间隔（单位：毫秒）
			attr["trap_groundcd_buff"] = attr["trap_groundcd_buff"] - tempValue["trap_groundcd_buff"]
		end
		
		--"trap_groundenemy"
		if tempValue["trap_groundenemy_buff"] then --陷阱困敌时间（单位：毫秒）
			attr["trap_groundenemy_buff"] = attr["trap_groundenemy_buff"] - tempValue["trap_groundenemy_buff"]
		end
		
		--"trap_fly"
		if tempValue["trap_fly_buff"] then --天网时间（单位：毫秒）
			attr["trap_fly_buff"] = attr["trap_fly_buff"] - tempValue["trap_fly_buff"]
		end
		
		--"trap_flycd"
		if tempValue["trap_flycd_buff"] then --天网施法间隔（单位：毫秒）
			attr["trap_flycd_buff"] = attr["trap_flycd_buff"] - tempValue["trap_flycd_buff"]
		end
		
		--"trap_flyenemy"
		if tempValue["trap_flyenemy_buff"] then --天网困敌时间（单位：毫秒）
			attr["trap_flyenemy_buff"] = attr["trap_flyenemy_buff"] - tempValue["trap_flyenemy_buff"]
		end
		
		--"puzzle"
		if tempValue["puzzle_buff"] then --迷惑几率（去百分号后的值）
			attr["puzzle_buff"] = attr["puzzle_buff"] - tempValue["puzzle_buff"]
		end
		
		--"weapon_crit_shoot"
		if tempValue["weapon_crit_shoot_buff"] then --射击暴击
			attr["weapon_crit_shoot_buff"] = attr["weapon_crit_shoot_buff"] - tempValue["weapon_crit_shoot_buff"]
		end
		
		--"weapon_crit_frozen"
		if tempValue["weapon_crit_frozen_buff"] then --冰冻暴击
			attr["weapon_crit_frozen_buff"] = attr["weapon_crit_frozen_buff"] - tempValue["weapon_crit_frozen_buff"]
		end
		
		--"weapon_crit_fire"
		if tempValue["weapon_crit_fire_buff"] then --火焰暴击
			attr["weapon_crit_fire_buff"] = attr["weapon_crit_fire_buff"] - tempValue["weapon_crit_fire_buff"]
		end
		
		--"weapon_crit_equip"
		if tempValue["weapon_crit_equip_buff"] then --装备暴击
			attr["weapon_crit_equip_buff"] = attr["weapon_crit_equip_buff"] - tempValue["weapon_crit_equip_buff"]
		end
		
		--"weapon_crit_hit"
		if tempValue["weapon_crit_hit_buff"] then --击退暴击
			attr["weapon_crit_hit_buff"] = attr["weapon_crit_hit_buff"] - tempValue["weapon_crit_hit_buff"]
		end
		
		--"weapon_crit_blow"
		if tempValue["weapon_crit_blow_buff"] then --吹风暴击
			attr["weapon_crit_blow_buff"] = attr["weapon_crit_blow_buff"] - tempValue["weapon_crit_blow_buff"]
		end
		
		--"weapon_crit_poison"
		if tempValue["weapon_crit_poison_buff"] then --毒液暴击
			attr["weapon_crit_poison_buff"] = attr["weapon_crit_poison_buff"] - tempValue["weapon_crit_poison_buff"]
		end
		
		------------------------------------------------------------------------------------------------------
		--特殊状态的移除
		--处理buff添加的状态
		--移除眩晕状态
		if (oAction.data.buffState_Stun == 1) then
			hApi.RemoveStunState(target)
			--print("-眩晕状态")
		end
		--移除变大状态
		if (oAction.data.buffState_BianDa == 1) then
			__RemoveBigState(target)
			--print("-变大状态")
		end
		--移除物理免疫状态
		if (oAction.data.buffState_ImmuePhysic == 1) then
			__RemoveImmuePhysicState(target)
			--print("-物理免疫状态")
		end
		--移除法术免疫状态
		if (oAction.data.buffState_ImmueMagic == 1) then
			__RemoveImmueMagicState(target)
			--print("-法术免疫状态")
		end
		--移除无敌状态
		if (oAction.data.buffState_ImmueWuDi == 1) then
			__RemoveImmueWuDiState(target)
			--print("-无敌状态")
		end
		--移除免疫伤害状态
		if (oAction.data.buffState_ImmueDamage == 1) then
			__RemoveImmueDamageState(target)
			--print("-免疫伤害状态")
		end
		--移除免疫冰伤害状态
		if (oAction.data.buffState_ImmueDamageIce == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.ICE)
			--print("-免疫冰伤害状态")
		end
		--移除免疫雷伤害状态
		if (oAction.data.buffState_ImmueDamageThunder == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.THUNDER)
			--print("-免疫雷伤害状态")
		end
		--移除免疫火伤害状态
		if (oAction.data.buffState_ImmueDamageFire == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.FIRE)
			--print("-免疫火伤害状态")
		end
		--移除免疫毒伤害状态
		if (oAction.data.buffState_ImmueDamagePoison == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.POISON)
			--print("-免疫毒伤害状态")
		end
		--移除免疫子弹伤害状态
		if (oAction.data.buffState_ImmueDamageBullet == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.BULLET)
			--print("-免疫子弹伤害状态")
		end
		--移除免疫爆炸伤害状态
		if (oAction.data.buffState_ImmueDamageBoom == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.BOMB)
			--print("-免疫爆炸伤害状态")
		end
		--移除免疫穿刺伤害状态
		if (oAction.data.buffState_ImmueDamageChuanci == 1) then
			__RemoveImmueDamageTypeState(target, hVar.DAMAGE_TYPE.CHUANCI)
			--print("-免疫穿刺伤害状态")
		end
		--移除免控状态
		if (oAction.data.buffState_ImmueControl == 1) then
			__RemoveImmueControlState(target)
			--print("-免控状态")
		end
		--移除免疫负面属性状态
		if (oAction.data.buffState_ImmueDebuff == 1) then
			__RemoveImmueDebuffState(target)
			--print("-免疫负面属性状态")
		end
		--移除混乱状态
		if (oAction.data.buffState_SufferChaos == 1) then
			__RemoveSufferChaosState(target)
			--print("-混乱状态")
		end
		--移除吹风状态
		if (oAction.data.buffState_SufferBlow == 1) then
			__RemoveSufferBlowState(target)
			--print("-吹风状态")
		end
		--移除穿刺状态
		if (oAction.data.buffState_SufferChuanCi == 1) then
			__RemoveSufferChuanCiState(target)
			--print("-穿刺状态")
		end
		--移除沉睡状态
		if (oAction.data.buffState_SufferSleep == 1) then
			__RemoveSufferSleepState(target)
			--print("-沉睡状态", oAction.data.skillId)
		end
		--移除沉默状态
		if (oAction.data.buffState_SufferChenmo == 1) then
			__RemoveSufferChenmoState(target)
			--print("-沉默状态", oAction.data.skillId)
		end
		--移除禁言状态（不能普通攻击）
		if (oAction.data.buffState_SufferJinYan == 1) then
			__RemoveSufferJinYanState(target)
			--print("-禁言状态", oAction.data.skillId)
		end
		--移除变地面单位状态
		if (oAction.data.buffState_Ground == 1) then
			__RemoveSpaceGroundState(target)
			--print("-变地面单位状态", oAction.data.skillId)
		end
		--移除透明状态（不能碰撞）
		if (oAction.data.buffState_SufferTouMing == 1) then
			__RemoveSufferTouMingState(target)
			--print("-透明状态", oAction.data.skillId)
		end
		
		--检测是否有移除状态的触发事件
		local buffRemoveSkillId = oAction.data.buffRemoveSkillId
		if (buffRemoveSkillId > 0) then
			local buffRemoveLv = oAction.data.buffRemoveLv
			if (type(buffRemoveLv) == "string") then
				buffRemoveLv = oAction.data.tempValue[buffRemoveLv]
			end
			--print("检测是否有移除状态的触发事件-移除", buffRemoveSkillId, buffRemoveLv)
			
			local tCastParam = {level = buffRemoveLv,}
			hApi.CastSkill(oAction.data.unit, buffRemoveSkillId, 0, 100, target, nil, nil, tCastParam)
		end
	end
end

--geyachao: 删除buff action
_ha.del_buff = function(self)
	local d = self.data
	
	--删除buff带来的属性变化
	__RemoveBuffEffect(self)
	
	hApi.unbind2Object(self, "bindU", hApi.GetObjectUnit(d.bindU), "buffs")
	self.data.IsBuff = -1
	self.data.IsPaused = 0
	
	--删除buff，删除标记角色身上tag
	local u = hApi.GetObjectUnit(d.bindU)
	if u then
		--标记角色身上的tag
		local buff_tags = u.data.buff_tags
		if buff_tags then
			local buffTag = d.buffTag
			if (buffTag ~= 0) then
				if buff_tags[buffTag] then
					buff_tags[buffTag] = buff_tags[buffTag] - 1
				--else
				--	buff_tags[buffTag] = 0
				end
				--print("-", u.data.name .. "_" .. u:getworldC(), buffTag)
			end
		end
	end
	
	self:del()
end

--处理所有技能物体
local __ActionUpdate = function(oAction, nPastTick)
	--print(oAction)
	local d = oAction.data
	d.past = d.past + nPastTick --技能物体存在的时间叠加
	
	--处理buff的每一跳事件
	if (type(d.buffTick) == "string") then
		d.buffTick = oAction.data.tempValue[d.buffTick]
		--print("d.buffTick=", d.buffTick)
	end
	
	if (d.buffTick > 0) then
		local pasttick = d.past - d.lastTick
		if (pasttick >= d.buffTick) then
			--触发本次tick
			--print("maxtime=" .. d.maxtime)
			--print("buffTick=" .. d.buffTick)
			--print("buffTickDmg=" .. d.buffTickDmg)
			--print("buffTickDmgMode=" .. d.buffTickDmgMode)
			--print("buffTickSkillId=" .. d.buffTickSkillId)
			--print("buffTickLv=" .. d.buffTickLv)
			--print("past=" .. d.past)
			--print()
			
			--造成伤害
			--计算最终的伤害值
			local dMin = d.dMin --技能物体中 LoadAttack 的伤害值min
			local dMax = d.dMax --技能物体中 LoadAttack 的伤害值max
			local _dMin = math.min(dMin, dMax)
			local _dMax = math.max(dMin, dMax)
			
			--有效的施法者，传入攻击者
			local oAttacker = nil
			if (d.unit:getworldC() == d.unit_worldC) and (d.unit.data.IsDead ~= 1) and (d.unit.attr.hp > 0) then --施法者没被复用，活着
				oAttacker = d.unit
			end
			
			--如果施法者还活着，计算闪避、暴击、物防、法防等
			if oAttacker then
				local nPower = 100
				local dmgSumMin, dmgSumMax = oAttacker:calculate("CombatDamage", d.target, d.buffTickDmg + _dMin, d.buffTickDmg + _dMax, nPower, d.skillId, d.buffTickDmgMode, 0)
				local dmgSum = d.world:random(dmgSumMin, dmgSumMax)
				--print("如果施法者还活着，计算闪避、暴击、物防、法防等", dmgSum)
				if (dmgSum > 0) then
					--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb)
					hGlobal.event:call("Event_UnitDamaged", d.target, d.skillId, d.buffTickDmgMode, dmgSum, 0, oAttacker, nil, d.ownerside, d.owner)
				end
			else --施法者已不存在，改为由施法者的上帝对目标造成伤害，仍然会计算物防、法防等
				--local loadAtkDmg = d.world:random(_dMin, _dMax)
				--local dmgSum = d.buffTickDmg + loadAtkDmg
				local oAttackerGod = d.world:GetPlayer(d.owner):getgod()
				if oAttackerGod then
					local dmgSumMin, dmgSumMax = oAttackerGod:calculate("CombatDamage", d.target, d.buffTickDmg + _dMin, d.buffTickDmg + _dMax, nPower, d.skillId, d.buffTickDmgMode, 0)
					local dmgSum = d.world:random(dmgSumMin, dmgSumMax)
					--print("施法者已不存在，改为由施法者的上帝对目标造成伤害，仍然会计算物防、法防等", dmgSum)
					if (dmgSum > 0) then
						--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
						hGlobal.event:call("Event_UnitDamaged", d.target, d.skillId, d.buffTickDmgMode, dmgSum, 0, oAttackerGod, nil, d.ownerside, d.owner)
					end
				else
					--上帝都死了。。。。
					local dmgSumMin, dmgSumMax = d.target:calculate("CombatDamage", d.target, d.buffTickDmg + _dMin, d.buffTickDmg + _dMax, nPower, d.skillId, d.buffTickDmgMode, 0)
					local dmgSum = d.world:random(dmgSumMin, dmgSumMax)
					if (dmgSum > 0) then
						--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
						hGlobal.event:call("Event_UnitDamaged", d.target, d.skillId, d.buffTickDmgMode, dmgSum, 0, nil, nil, d.ownerside, d.owner)
					end
				end
			end
			
			--释放技能
			--print("处理buff的每一跳事件", d.unit.data.name, d.unit:getworldC(), d.unit_worldC)
			--print("buffTickSkillId=", d.buffTickSkillId)
			if (d.buffTickSkillId > 0) then
				if (d.unit:getworldC() == d.unit_worldC) then --防止施法者死了被复用
					--单位不在眩晕(滑行)中、不在隐身中、不在混乱中、不在沉睡中、不在沉默中
					--if (d.unit.attr.stun_stack == 0) and (d.unit:GetYinShenState() ~= 1) and (d.unit.attr.suffer_chaos_stack == 0) and (d.unit.attr.suffer_sleep_stack == 0) and (d.unit.attr.suffer_chenmo_stack == 0) then
						if (type(d.buffTickLv) == "string") then
							d.buffTickLv = d.tempValue[d.buffTickLv]
						end
						
						--print("处理buff的每一跳事件", d.unit.data.name, d.target.data.name)
						local tCastParam = {level = d.buffTickLv,}
						hApi.CastSkill(d.unit, d.buffTickSkillId, 0, 100, d.target, nil, nil, tCastParam)
					--end
				end
			end
			
			--print("buffTickSkillId_T=", d.buffTickSkillId_T)
			if (d.buffTickSkillId_T > 0) then
				if (d.unit:getworldC() == d.unit_worldC) then --防止施法者死了被复用
					if (type(d.buffTickLv) == "string") then
						d.buffTickLv = d.tempValue[d.buffTickLv]
					end
					
					--print("处理buff目标的每一跳事件", d.unit.data.name, d.target.data.name)
					local tCastParam = {level = d.buffTickLv,}
					hApi.CastSkill(d.target, d.buffTickSkillId_T, 0, 100, d.target, nil, nil, tCastParam)
				end
			end
			
			--记录上次tick的时间
			d.lastTick = d.past
		end
	end
	
	--geyachao: 新加TD流程
	--如果技能物体大于最大生存时间，那么删除该技能物体（用于buff流程）
	--print("__ActionUpdate", nPastTick, d.past, d.maxtime, tostring(oAction))
	if (d.past > d.maxtime) then
		--print("如果技能物体大于最大生存时间，那么删除该技能物体")
		--取消buff设置的属性改变
		__RemoveBuffEffect(oAction)
		
		--删除buff，删除标记角色身上tag
		local u = hApi.GetObjectUnit(d.bindU)
		if u then
			--标记角色身上的tag
			local buff_tags = u.data.buff_tags
			if buff_tags then
				local buffTag = d.buffTag
				if (buffTag ~= 0) then
					if buff_tags[buffTag] then
						buff_tags[buffTag] = buff_tags[buffTag] - 1
					--else
					--	buff_tags[buffTag] = 0
					end
					--print("-", u.data.name .. "_" .. u:getworldC(), buffTag)
				end
			end
		end
		
		--print("删除buff", target.__ID)
		--print("self:del(4)")
		return oAction:del()
	end
	
	--print("nPastTick=" .. nPastTick .. ", d.tick=" .. d.tick, tostring(oAction))
	
	--处理"sleep"等待一段时间
	if (d.tick > 0) then
		d.tick = math.max(1, d.tick - nPastTick)
		--print("d.tick3=" .. d.tick)
	end
	
	if (d.tick == 1) then
		return __CODE__ProcessAction(oAction)
	end
end

--遍历所有的技能物体
_ha.__updateAll = function(nPastTick) --geyachao: nPastTick由参数传进来
	--local nPastTick = math.ceil(1000/hApi.GetFrameCountByTick(1000))
	_ha:enum(__ActionUpdate, nPastTick)
end

local __aCodeList = hClass.action.__static.actionCodeList
local __MustProcessKey = {
	["Loop"] = 1,
	["AddAttr"] = 1,
	["SetAttr"] = 1,
	["RemoveAssist"] = 1,
}
_ha.doNextAction = function(self)
	local d = self.data
	if d.IsPaused==1 then
		return
	end
	--print("d.actionIndex=" .. d.actionIndex , tostring(self))
	d.actionIndex = d.actionIndex + 1
	local _ac = nil
	if (type(d.action) == "table") then
		_ac = d.action[d.actionIndex]
	end
	if _ac and _ac[1] and (d.actionIndex <= #d.action) then
		local processCode = __aCodeList[_ac[1]]
		if processCode then
			if d.IsBuff==-1 then
				--死亡的buff走特殊流程
				if __MustProcessKey[_ac[1]] then
					return processCode(self,unpack(_ac, 1, table.maxn(_ac)))
				elseif _ac[1]=="LoopEnd" then
					if d.loopcount[#d.loopcount]==0 then
						d.loopcount[#d.loopcount] = 1
					end
					return processCode(self,unpack(_ac, 1, table.maxn(_ac)))
				else
					return self:doNextAction()
				end
			else
				return processCode(self,unpack(_ac, 1, table.maxn(_ac)))
			end
		else
			--#xxxx为跳转用tag，不做任何处理
			if string.sub(_ac[1],1,1)~="#" then
				_DEBUG_MSG((d.mode=="skill" and "tab_skill["..d.skillId.."]" or "").."	- action["..d.actionIndex.."]:非法动作：",unpack(_ac, 1, table.maxn(_ac)))
			end
			return self:doNextAction()
		end
	else
		--geyachao: 针对buff做特殊处理, 如果标记了buff的生存时间, 那么不删除该技能物体
		--print("d.maxtime=" .. d.maxtime)
		if (d.maxtime ~= math.huge) then
			--print("针对buff做特殊处理, 不删除该技能物体 啥也不做", tostring(self))
			return nil, 1 --啥也不做
		else
			self:removebuffstate("all")
			--print("release", tostring(self))
			return "release", 1
		end
	end
end

--增加一个状态
_ha.addbuffstate = function(self,mode,StateName)
	local d = self.data
	if type(d.BuffState)~="table" then
		d.BuffState = {}
	end
	local tState = d.BuffState
	local findI
	for i = 1,#tState do
		if tState[i]==0 then
			findI = findI or i
		elseif tState[i][1]==mode and tState[i][2]==StateName then
			return hVar.RESULT_SUCESS
		end
	end
	findI = findI or (#tState+1)
	local IfShow = hGlobal.LocalPlayer:getfocusworld()==d.world
	local s = {mode,StateName}
	if hApi.AddBuffStateForAction(self,s,1,IfShow)==1 then
		tState[findI] = s
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_FAIL
	end
end

--移除一个状态
_ha.removebuffstate = function(self,mode,StateName)
	local d = self.data
	local tState = d.BuffState
	if tState~=0 and type(tState)=="table" and #tState>0 then
		local IfShow = hGlobal.LocalPlayer:getfocusworld()==d.world
		if mode=="all" then
			for i = 1,#tState do
				if tState[i]~=0 then
					hApi.AddBuffStateForAction(self,tState[i],-1,IfShow)
					tState[i] = 0
				end
			end
		else
			for i = 1,#tState do
				if tState[i]~=0 and tState[i][1]==mode and tState[i][2]==StateName then
					hApi.AddBuffStateForAction(self,tState[i],-1,IfShow)
					tState[i] = 0
					break
				end
			end
		end
	end
end

-----------------------------------------------------
-- hApi支持函数
-----------------------------------------------------
hApi.GetSkillRange = function(nSkillId,oUnit_Or_nUnitId)
	local tabS = hVar.tab_skill[nSkillId]
	if tabS==nil then
		return 0,0
	end
	local tAttr
	local case = type(oUnit_Or_nUnitId)
	if case=="table" then
		tAttr = oUnit_Or_nUnitId.attr
	elseif case=="number" then
		local tabU = hVar.tab_unit[oUnit_Or_nUnitId]
		if tabU then
			tAttr = tabU.attr
		end
	end
	if tabS.template=="UnitMove" then
		--移动类型
		if tAttr and tAttr.move then
			return 0,tAttr.move
		else
			return 0,0
		end
	elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
		--范围技能(全屏射程)
		return -1,-1
	elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
		--自身技能(使用作用半径作为射程)
		if tabS.area then
			local rMin = tabS.area[1] or 0
			local rMax = tabS.area[2] or 0
			return rMin,rMax
		else
			return 0,0
		end
	elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
		if tabS.template=="RangeAttack" then
			--远程施展(全屏射程)
			return -1,-1
		elseif tabS.range then
			--近战施展(指定射程)
			local rMin = tabS.range[1] or 0
			local rMax = tabS.range[2] or 0
			return rMin,rMax
		else
			--近战施展(未指定射程)
			if tAttr and tAttr.attack then
				local rMin = tAttr.attack[2] or 0
				local rMax = tAttr.attack[3] or 0
				return rMin,rMax
			else
				--其他情况视为射程0~1
				return 0,1
			end
		end
	else
		--光环类技能返回作用范围
		if tabS.aura and tabS.area then
			local rMin = tabS.area[1] or 0
			local rMax = tabS.area[2] or 0
			return rMin,rMax
		else
			--其他类型都是0~0
			return 0,0
		end
	end
end

hApi.GetSkillArea = function(u,nSkillId,nLv)
	local tabS = hVar.tab_skill[nSkillId]
	if tabS==nil then
		return 0,0
	end
	if tabS.area~=nil then
		return tabS.area[1],tabS.area[2]
	end
	return 0,0
end

hApi.IsSkillAvailable = function(u,nSkillId)
	if u:getskill(id)~=nil then
		return hVar.RESULT_SUCESS
	end
	local a = u.attr
	if nSkillId==0 or hVar.tab_skill[nSkillId]==nil then
		return hVar.RESULT_FAIL
	elseif nSkillId==a.attack[1] or nSkillId==a.attackID or nSkillId==a.encounterID then
		--合法的默认技能
		return hVar.RESULT_SUCESS
	elseif hVar.PUBLIC_SKILL_ID[nSkillId]~=nil then
		--特殊的公共技能
		return hVar.RESULT_SUCESS
	elseif nSkillId==hApi.GetDefaultSkill(u,"counter") then
		--合法的反击技能
		return hVar.RESULT_SUCESS
	--elseif #u.attr.replaceID>0 then
		----合法的替换技能
		----{key,replaceID}
		--for i = 1,#u.attr.replaceID do
			--if nSkillId==u.attr.replaceID[2] then
				--return hVar.RESULT_SUCESS
			--end
		--end
	end
	return hVar.RESULT_FAIL
end

hApi.GetDefaultSkill = function(oUnit,mode)
	local id = oUnit.attr.attack[1]
	local dMin = oUnit.attr.attack[4]
	local dMax = oUnit.attr.attack[5]
	if oUnit.attr.attackID~=0 then
		id = oUnit.attr.attackID
	end
	local tabAS = hVar.tab_skill[id]
	if id<=0 then
		tabAS = nil
	end
	if mode=="counter" then
		if oUnit.attr.counterID~=0 then
			--如果拥有反击id，那么将id转换为反击id
			id = oUnit.attr.counterID
		elseif tabAS and tabAS.counterID then
			--如果表格中填写了反击id，那么将id转换为反击id
			id = tabAS.counterID
		end
	end
	if id>0 and hVar.tab_skill[id] then
		return id
	else
		return 0
	end
end

hApi.GetSkillCastCount = function(oUnit,id,lv)
	local tabS = hApi.GetTableValue(hVar.tab_skill,id)
	if tabS.manacost and tabS.manacost>0 then
		local count = math.floor(oUnit.attr.mp/tabS.manacost)
		if count>0 then
			return count
		else
			return -1
		end
	end
	return 0
end

local __Area = {0,1}
hApi.GetSkilArea = function(u,skill)
	return unpack(skill.area or __Area)
end

hApi.GetSkillCastType = function(skillId)
	local IsHave = 0
	if hVar.tab_skill[skillId]~=nil then
		IsHave = 1
		if hVar.tab_skill[skillId].cast_type~=nil then
			return hVar.tab_skill[skillId].cast_type,IsHave
		end
	end
	return hVar.CAST_TYPE.NONE,IsHave
end

-----------------------------------------------------
--判断单位是否能被选择为技能目标
local __TARGET_Cond = {
	{
		--[1]属方必须填在这里！
		{"ENEMY"},								--默认
		["ALLY"] = function(u,t)
			return u.data.owner==t.data.owner
		end,
		["ENEMY"] = function(u,t)
			return u.data.owner~=t.data.owner
		end,
	},
	{
		["SELF"] = function(u,t)
			return u==t
		end,
		["OTHER"] = function(u,t)
			return u~=t
		end,
	},
	{
		{"UNIT"},								--默认
		["UNIT"] = function(u,t)
			return t.attr.IsBuilding<=0
		end,
		["BUILDING"] = function(u,t)
			return t.attr.IsBuilding>0
		end,
	},
	{
		["HERO"] = function(u,t)
			return t.attr.heroic>0
		end,
		["NON_HERO"] = function(u,t)
			return t.attr.heroic<=0
		end,
	},
	{
		["CREATURE"] = function(u,t)
			return t.attr.IsMachine<=0
		end,
		["MACHINE"] = function(u,t)
			return t.attr.IsMachine>0
		end,
	},
	{
		["DAMAGED"] = function(u,t)
			return not(t.attr.hp>=t.attr.mxhp and t.attr.stack>=t.attr.__stack)
		end,
		["NON_DAMAGED"] = function(u,t)
			return t.attr.hp>=t.attr.mxhp and t.attr.stack>=t.attr.__stack
		end,
	},
}
local __TARGET_Temp = {
	tDefault = {},
	tData = {},
	tFunc = {},
	tFuncI = {},
	init = function(self)
		local tData = self.tData
		local tFunc = self.tFunc
		local tFuncI = self.tFuncI
		local tDefault = self.tDefault
		for i = 1,#__TARGET_Cond do
			local v = __TARGET_Cond[i]
			tDefault[i] = 0
			tFunc[i] = {}
			tData[i] = {}
			for key,func in pairs(v) do
				if type(func)=="function" then
					local j = #tData[i]+1
					tData[i][j] = 0
					tFunc[i][j] = func
					tFuncI[key] = {i,j}
				end
			end
			if v[1] then
				tDefault[i] = {}
				for j = 1,#tData[i] do
					tDefault[i][j] = 0
				end
				for j = 1,#v[1] do
					tDefault[i][tFuncI[v[1][j]][2]] = 1
				end
			end
		end
	end,
	clear = function(self)
		local tData = self.tData
		for i = 1,#tData do
			for j = 1,#tData[i] do
				tData[i][j] = -1
			end
		end
	end,
	cond = function(self,k)
		local tData = self.tData
		local tFuncI = self.tFuncI
		if tFuncI[k] then
			local i = tFuncI[k][1]
			local j = tFuncI[k][2]
			if tData[i][j]==-1 then
				for n = 1,#tData[i] do
					tData[i][n] = 0
				end
			end
			tData[i][j] = 1
		end
	end,
	check = function(self,u,t)
		local tData = self.tData
		local tFunc = self.tFunc
		local tDefault = self.tDefault
		for i = 1,#tData do
			if tData[i][1]==-1 and tDefault[i]~=0 then
				for j = 1,#tDefault[i] do
					tData[i][j] = tDefault[i][j]
				end
			end
			if tData[i][1]~=-1 then
				local sus = 0
				for j = 1,#tData[i] do
					if tData[i][j]==1 then
						if tFunc[i][j](u,t) then
							sus = 1
							break
						end
					end
				end
				if sus~=1 then
					return
				end
			end
		end
		return 1
	end
}
__TARGET_Temp:init()

local __CODE__CheckTargetEx = function(oTarget,cond,nStart)
	if type(cond)=="table" and #cond>=nStart then
		local uId = oTarget.data.id
		if hVar.tab_unit[uId] then
			local tabU = hVar.tab_unit[uId]
			local type_ex = tabU.type_ex
			local condT = {}
			if type(type_ex)=="table" then
				for i = 1,#type_ex do
					local v = type_ex[i]
					condT[v] = 1
				end
			end
			for i = nStart,#cond do
				local v = cond[i]
				local typ = type(v)
				if typ=="number" then
					if uId==v then
						return hVar.RESULT_SUCESS
					end
				elseif typ=="table" then
					if #v>0 then
						local n = 0
						for c = 1,#v do
							if condT[v[c]]==1 then
								n = n + 1
							else
								break
							end
						end
						if n>=#v then
							return hVar.RESULT_SUCESS
						end
					end
				elseif condT[v]==1 then
					return hVar.RESULT_SUCESS
				end
			end
		end
		return hVar.RESULT_FAIL
	end
	return hVar.RESULT_SUCESS
end

local __COND__TargetStateEx = {
	["UNIT_NOT_SURROUNDED"] = function(oUnit,oTarget,tParam)
		local w = oUnit:getworld()
		if w then
			local count = 0
			w:enumunitUR(oUnit,0,1,function(t,p)
				if t.data.owner~=p and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
					count = count + 1
				end
			end,oUnit.data.owner)
			if count==0 then
				return hVar.RESULT_SUCESS
			else
				return hVar.RESULT_FAIL
			end
		else
			return hVar.RESULT_FAIL
		end
	end,
	["TARGET_IN_RANGE"] = function(oUnit,oTarget,tParam)
		local w = oUnit:getworld()
		if w then
			local v = w:distanceU(oUnit,oTarget,1)
			if v>=tParam[1] and v<=tParam[2] then
				return hVar.RESULT_SUCESS
			else
				return hVar.RESULT_FAIL
			end
		else
			return hVar.RESULT_FAIL
		end
	end,
	["TARGET_HAVE_BUFF"] = function(oUnit,oTarget,tParam)
		local nCount = oTarget:countbuff(tParam)
		if nCount>0 then
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end,
	["TARGET_MOVE_SLOW"] = function(oUnit,oTarget,tParam)
		if oUnit.attr.move<tParam[1] then
			return hVar.RESULT_FAIL
		elseif oTarget.attr.stun>0 then
			return hVar.RESULT_SUCESS
		elseif (oUnit.attr.move-oTarget.attr.move)>=tParam[1] then
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end,
}

hApi.CheckUnitTypeEx = function(oTarget,tCond)
	return __CODE__CheckTargetEx(oTarget,tCond,1)
end

hApi.CheckUnitAndTargetTypeEx = function(tCond,oUnit,oTarget)
	if tCond[1] and __COND__TargetStateEx[tCond[1]] then
		if type(tCond[3])=="table" then
			if __CODE__CheckTargetEx(oTarget,tCond[3],1)~=hVar.RESULT_SUCESS then
				return hVar.RESULT_FAIL
			end
		end
		return __COND__TargetStateEx[tCond[1]](oUnit,oTarget,tCond[2])
	else
		return __CODE__CheckTargetEx(oTarget,tCond,1)
	end
end

local __DefaultTarget = {"ENEMY"}
local __TokenTabS = {}
hApi.IsSafeTarget = function(u,id,t,oCenterUnit,nAnyAllience)
	if t==nil or t.data.IsDead==1 or t.attr.hp<0 then
		return hVar.RESULT_FAIL
	end
	if u~=nil and id~=nil then
		local tabT = __DefaultTarget
		local tabS = __TokenTabS
		local tabT_EX
		if type(id)=="table" then
			tabT = id
		elseif id~=0 then
			tabS = hVar.tab_skill[id]
			if tabS then
				if tabS.target~=nil then
					tabT = tabS.target
				end
				tabT_EX = tabS.targetEx
			end
		end
		if oCenterUnit~=nil and t.attr.EvadeArea>0 then
			if tabS.CanNotEvade==1 then
				--该技能无需判断范围闪避
			elseif oCenterUnit==t then
				--中心单位无法闪避
			elseif tabS.IsHarm~=1 and u.data.owner==t.data.owner then
				--非有害类技能，并且是友军施展的技能不能被闪避
			elseif (tabS._manacost or tabS.manacost or 0)>9 and t.attr.EvadeAreaEx<=0 then
				--法力消耗大于9的技能，如果此值小于等于0则无法闪避
			else
				return hVar.RESULT_FAIL
			end
		end
		if tabT then
			if #tabT==1 and tabT[1]=="SELF" then
				if u==t then
					return hVar.RESULT_SUCESS
				else
					return hVar.RESULT_FAIL
				end
			else
				local sus = 0
				__TARGET_Temp:clear()
				for i = 1,#tabT do
					local case = tabT[i]
					if case=="ALL" then
						sus = 1
						break
					else
						__TARGET_Temp:cond(case,u,t)
					end
				end
				if sus~=1 then
					--忽视目标属方
					if nAnyAllience==1 then
						for i = 1,#__TARGET_Temp.tData[1] do
							__TARGET_Temp.tData[1][i] = 1
						end
					end
					if not(__TARGET_Temp:check(u,t)) then
						return hVar.RESULT_FAIL
					end
				end
			end
		end
		if tabT_EX and __CODE__CheckTargetEx(t,tabT_EX,1)==hVar.RESULT_FAIL then
			return hVar.RESULT_FAIL
		end
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_SUCESS
	end
end

--是否合法的技能目标(施展时)
hApi.IsAvailableTarget = function(u,id,t,oCenterUnit,nAnyAllience)
	--潜行目标无法被选择
	if u~=nil and t~=nil and t.attr.stealth>0 and u.data.owner~=t.data.owner then
		return hVar.RESULT_FAIL
	end
	return hApi.IsSafeTarget(u,id,t,oCenterUnit,nAnyAllience)
end



hApi.IsUnitInRange = function(u,nSkillId,t)
	local rMin,rMax = hApi.GetSkillRange(nSkillId,u)
	if rMin<0 or rMax<0 then
		return hVar.RESULT_SUCESS,1
	else
		local w = u:getworld()
		local v = w:distanceU(u,t,1)
		local tabS = hVar.tab_skill[nSkillId]
		if tabS and tabS.template=="RangeAttack" then
			--远程攻击永远全屏
			if v>=rMin and v<=rMax then
				--在攻击范围内，且没有衰减
				return hVar.RESULT_SUCESS,1
			else
				--在攻击范围内，但有衰减
				return hVar.RESULT_SUCESS,0
			end
		elseif v>=rMin and v<=rMax then
			return hVar.RESULT_SUCESS,1
		end
	end
	return hVar.RESULT_FAIL,0
end

local __tGrid = {n=0}
hApi.GetGridByUnitAndXY = function(oUnit,mode,worldX,worldY)
	__tGrid.n = 0
	local g = oUnit:getgrid(__tGrid)
	local n = g.n
	if n==1 then
		return g[1].x,g[1].y
	elseif n>1 then
		local w = oUnit:getworld()
		local selectI = 1
		local disG
		for i = 1,n do
			local wx,wy = w:grid2xy(g[i].x,g[i].y)
			local dis = (wx-worldX)^2 + (wy-worldY)^2
			if disG==nil then
				disG = dis
				selectI = i
			elseif mode=="near" then
				if disG>dis then
					disG = dis
					selectI = i
				end
			elseif mode=="far" then
				if disG<dis then
					disG = dis
					selectI = i
				end
			end
		end
		return g[selectI].x,g[selectI].y
	else
		return oUnit.data.gridX,oUnit.data.gridY
	end
end