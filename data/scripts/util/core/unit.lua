-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的单位类
--@单位可以存在于战场和世界地图中
hClass.unit = eClass:new("static enum sync")
hClass.unit:sync("local",{"handle","chaUI","localdata"})		--设置这些表项下面的数据为本地数据，无需保存
hClass.unit:sync("simple",{"attack","team","skill"})		--简单的{1,2,3,{1,2,3}}表格,且i和n会被保存，其他的需要重新初始化
--------------------------------------------------------------
local _hu = hClass.unit
local __UNIT_ARRIVE_MODE = hVar.UNIT_ARRIVE_MODE

--设置单位参数用
_hu.__static = {}
_hu.__static.objIdByCha = {}

hApi.findUnitByCha = function(cha)
	return _hu:find(cha and _hu.__static.objIdByCha[cha] or 0)
end

local function UnitTouchCallBack(msg,tPos)
	return _hu.__static.__callback_touch(msg,hApi.view2world(unpack(tPos)))
end

---------------------------------------------------------
--刷新角色动画
local __ENUM__UpdateUnitAnimation = function(oUnit)
	hApi.ObjectUpdateAnimation(oUnit)
end

hApi.UpdateGameUnit = function()
	hClass.unit:enum(__ENUM__UpdateUnitAnimation)
end

----------------------------------------
--默认参数表
local __DefaultParam =
{
	userdata = 0,
	type = 0,
	name = 0,			--单位的名字(从tgrData中读取或tab_stringU中读取)
	hint = 0,			--单位的提示信息(从tgrData中读取或tab_stringU中读取)
	owner = 0,			--拥有者
	control = 0,			--控制者(一般来说和拥有者一样的)
	__control = 0,			--原始控制者
	id = 0,
	team = 0,			--携带的部队，格式必须合法
	model = 0,			--指定了特殊模型则不使用tab_unit里面的模型
	xlobj = 0,			--同上，优先级更高
	name = 0,
	effectsOnCreate = 0, --单位创建的时候的特效
	gridX = 0,
	gridY = 0,
	rfacing = 0,			--战场中每次行动开始前此数值会被设置为当前facing
	rgridX = 0,			--战场中每次行动开始前此数值会被设置为当前gridX
	rgridY = 0,			--战场中每次行动开始前此数值会被设置为当前gridY
	worldX = 0,			--如果在param中并未指定gridX,gridY,则会使用worldX和worldY来初始化单位的位置
	worldY = 0,
	standX = 0,			--单位在战场中站立的位置可能存在偏移(多格单位)
	standY = 0,
	facing = 180,
	scale = 0,			--单位的基础缩放
	editorID = 0,			--编辑器ID，一般没什么用但是要记下来
	triggerID = 0,			--单位的触发器ID，可以通过此值被触发器识别
	bossID = 0,			--如果单位是某个大型怪物的一部分，那么该ID为目标大型怪物的ID(如果此值为-1，那么此怪物视为大型怪物本体)
	partID = 0,			--如果单位是某个大型怪物的一部分，那么该ID为部分标识
	IsAi = 0,			--单位是否需要AI控制
	IsDead = 0,			--单位是否死了(不可被操作)(如果此值为-1，则认为该单位还未进入地图)
	IsDefeated = 0,			--单位被击败的模式(如果没死那么此值会等于0)
	IsDestroyed = 0,		--单位是否被删除了
	IsBusy = 0,			--单位是否正处于不可被攻击或访问的状态,战场中如果有任何单位处在这个非0的状态下则禁止跳过当前操作权
	IsGod = 0,			--单位是否上帝模式，上帝模式下的单位攻击会直接杀死单位
	IsHide = 0,
	IsGate = 0,			--单位是否是门(1:普通的门,2:打开的门)
	IsMoving = 0,			--单位是否正在移动
	curTown = 0,			--单位是否是访问者，如果是访问者的话，此数值将等同于正在访问的城镇(oTown)ObjectID
	reciveFacingEvent = 0,		--单位是否能接到朝向改变的回调，等于1才能接到，否则拒绝接受此事件
	reciveMoveStepEvent = 0,	--单位是否能接到每步移动的回调，等于1才能接到，否则拒绝接受此事件(目前仅大地图有此事件)
	roundState = hVar.UNIT_ROUND_STATE.ROUND_START,	--每轮的状态(回合开始时将被重置)
	movepoint = -1,			--单位剩余的移动力,-1为未初始化状态
	nOperate = 0,
	nOperateId = 0,
	nTarget = 0,
	cdtime = 0,			--记录冷却用的表
	unitlevel = 0,			--单位等级
	bindW = 0,			--和单位绑定的世界ID
	worldI = 0,			--单位在当前世界的顺序ID，仅系统用
	heroID = 0,			--英雄对象ID
	townID = 0,			--建筑对象ID
	itemID = 0,			--道具对象ID
	indexOfTown = 0,		--在城中的建筑编号，对应oTown.data.townData[i]
	indexOfCreate = 0,		--创建时的编号，和.dat文件中的id对应
	indexOfTeam = 0,		--战场中的单位拥有队伍编号，在受伤时会扣除队伍中相应的数量
	hireList = 0,			--一般只有建筑有雇用单位参数
	shopList = 0,			--一般只有建筑有出售物品参数
	loot = 0,			--可以被拾取/抢夺的物品:{}
	talkTag = 0,			--接下来使用的对话Tag --TD 敌人列表（用于优化）
	IsCovered = 0,			--完全站在城里时，此值将被设置为1
	IsEncountered = 0,		--1格附近存在敌人时，此值将变成大于0，数量等于敌军数量
	IsSummoned = 0,			--是否召唤单位
	IsPVP = 0,			--pvp模式下此变量为1
	auraCount = 0,			--如果携带任何光环，此值会+1
	chargeID = 0,			--单位冲锋时携带此ID，会触发对应actionobj后面的操作
	animation = 0,			--记录临时动画
	animationTag = 0,		--如果单位更改过动画标签，那么这个值会被设置为非0的值,如果是战场上的单位,此值会被用来记录单位当前所处的不同hp阶段对应的动画(只由damage事件触发)
	mapScorePec = 0,		--击杀该生物后获得积分的比率
	roadPoint = 0, --TD角色路点 --geyachao: 新加数据
	aiState = hVar.UNIT_AI_STATE.IDLE, --TD角色AI状态 --geyachao: 新加数据
	lastIdleTime = -10000, --上次进入空闲状态的时间
	--movespeed = hVar.UNIT_DEFAULT_SPEED, --TD角色移动速度 --zhenkira:新加数据
	atkTimes = 0, --geyachao: 新加数据 普通攻击的次数
	
	lockTarget = 0, --锁定攻击的目标 --geyachao: 新加数据
	lockType = 0, --锁定攻击的类型(0:被动锁定 / 1:主动锁定) --geyachao: 新加数据
	
	castskillLastTime = 0, --geyachao: 新加数据 上一次释放技能的时间
	castskillStaticTime = 0, --geyachao: 新加数据 技能释放完后僵直的时间
	
	castskillWaitTime = 0, --geyachao: 新加数据 技能释放完后允许下次释放技能的间隔时间
	
	JianTouEffect = 0, --geyachao: 新加数据 移动的箭头特效
	AttackEffect = 0, --geyachao: 新加数据 攻击目标的箭头特效
	
	AI_SKILL_SEQUENCE_LIST = 0, --geyachao: 新加数据 角色在释放的技能的序列
	AI_SKILL_SEQUENCE_INDEX = 0, --geyachao: 新加数据 角色在释放的技能的序列id
	
	buff_tags = 0, --geyachao: 新加数据 角色身上的buff的标记（用于效率优化）
	
	livetimeBegin = -1, --geyachao: 新加数据 生存时间开始值（毫秒）
	livetime = -1, --geyachao: 新加数据 生存时间（毫秒）
	livetimeMax = -1, --geyachao: 新加数据 生存时间最大值（毫秒）
	
	defend_x = 0, --守卫位置x
	defend_y = 0, --守卫的位置y
	defend_distance_max = -1, --最远能到达的守卫距离
	
	IsReachedRoad = 0, --是否到过终点（防止重复调用事件）
	
	adjust_direction = 0, --移动调整的方向（包围嘲讽单位用的）
	
	adjust_dx = 0, --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
	adjust_dy = 0, --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
	
	defend_x_walle = 0, --瓦力守卫位置x偏移
	defend_y_walle = 0, --瓦力守卫的位置y
	
	op_state = 0, --是否有缓存的操作
	op_target = 0, --等待操作的移动到达的目标
	op_target_worldC = 0, --等待操作的移动到达的目标唯一id
	op_point_x = 0, --等待操作的移动到达的目标点x
	op_point_y = 0, --等待操作的移动到达的目标点y
	op_tacticId = 0, --等待操作的移动到达目标点后释放的战术技能id
	op_itemId = 0, --等待操作的移动到达目标点后释放的道具技能id
	op_tacticX = 0, --等待操作的移动到达目标点后战术技能x坐标
	op_tacticY = 0, --等待操作的移动到达目标点后战术技能y坐标
	op_t_worldI = 0, --等待操作的移动到达目标点后战术技能目标worldI
	op_t_worldC = 0, --等待操作的移动到达目标点后战术技能目标worldC
	op_skillAction = 0, --等待操作的移动到达目标点后释放的技能action
	
	--immue_physic_effect = 0, --物理免疫的特效
	--immue_magic_effect = 0, --法术免疫的特效
	--immue_control_effect = 0, --免控的特效
	--immue_debuff_effect = 0, --免疫负面属性效果的特效
	--immue_wudi_effect = 0, --无敌的特效
	--suffer_chaos_effect = 0, --混乱的特效
	--suffer_blow_effect = 0, --吹风的特效
	--suffer_chuanci_effect = 0, --穿刺的特效
	--suffer_sleep_effect = 0, --沉睡的特效
	
	--td_upgrade = 0, --zhenkira
	--validTargetList = 0, --geyachao: 内存优化，寻找角色的有效目标列表，预先分配好内存，防止高频timer一直创建表
	--validTauntTargetList = 0, --geyachao: 内存优化，寻找角色的有效嘲讽目标列表，预先分配好内存，防止高频timer一直创建表
	--validSkillTargetList = 0, --geyachao: 内存优化，寻找角色的有效技能目标列表，预先分配好内存，防止高频timer一直创建表
	area_xn = 0, --geyachao: 角色属于的区域xn（用于搜敌优化）
	area_yn = 0, --geyachao: 角色属于的区域yn（用于搜敌优化）
	
	__worldC = 0, --单位在世界的创建计数
	
	appear_wave = 0, --TD添加该单位的波次
	
	is_summon = 0, --TD是否为召唤的单位
	is_fenshen = 0, --TD是否为召唤的分身单位（会受到额外伤害）
	summon_worldC = 0, --TD召唤者唯一id
	
	--bind_unit_in_attack = 0, --tank_test:测试用: 绑定的单位（坦克的炮口）是否正在攻击中（攻击时不跟随移动）
	bind_unit = 0, --tank: 绑定的单位（坦克的炮口）
	bind_weapon = 0, --tank: 绑定的单位（坦克的机枪）
	bind_lamp = 0, --tank: 绑定的单位（坦克的大灯）
	bind_light = 0, --tank: 绑定的单位（坦克的大灯光照）
	bind_wheel = 0, --tank: 绑定的单位（坦克的轮子）
	bind_shadow = 0, --tank: 绑定的单位（坦克的影子）
	bind_energy = 0, --tank: 绑定的单位（坦克的能量圈）
	
	bind_unit_owner = 0, --tank: 绑定的单位拥有者（坦克的炮口）
	bind_weapon_owner = 0, --tank: 绑定的单位拥有者（坦克的机枪）
	bind_lamp_owner = 0, --tank: 绑定的单位拥有者（坦克的大灯）
	bind_light_owner = 0, --tank: 绑定的单位拥有者（坦克的大灯光照）
	bind_wheel_owner = 0, --tank: 绑定的单位拥有者（坦克的轮子）
	bind_shadow_owner = 0, --tank: 绑定的单位拥有者（坦克的影子）
	bind_energy_owner = 0, --tank: 绑定的单位拥有者（坦克的能量圈）
	
	bind_tacingeffs = {}, --坦克绑定的追踪导弹特效
	
	--customData = {}, --用户自定义数据块
	--customDataPivot = 0, --用户自定义数据块可用索引（自增值）
	
	--geyachao: 移动的参数挪到角色身上，为了同步
	MOVE_valid = false, --移动是否有效（用于内存优化）
	MOVE_target = nil, --移动到达的目标（目标模式）
	MOVE_target_worldC = 0, --移动到达的目标唯一id（目标模式）
	MOVE_radius = nil, --移动到达的半径（相距一定的距离就认为移动到达）（目标模式）
	MOVE_pos_x = nil, --移动到达的半径（目标点模式）
	MOVE_pos_y = nil, --移动到达的半径（目标点模式）
	MOVE_move_speed = nil, --移动速度
	MOVE_bBlock = nil, --移动是否计算碰撞
	MOVE_waypoint = nil, --移动的程序返回的路点集（用于优化，目标点模式只计算一次程序路点，避免重复计算）
	
	equipState = 0,	--记录单位是否已经穿上装备（主要用于英雄装备刷新）
	
	waveBelong = 0, --记录单位所属波次（用于当前波次怪物全部死亡后提前发兵逻辑）
	
	growParam = 0, --生长动画参数
}

-- unit因为存档过大所以走特殊保存流程,
-- 只保存data中的这些数据
local __DefaultSyncData = {
	"type","id","owner","worldX","worldY","facing","movepoint",
	"bindW","worldI","indexOfCreate","triggerID","talkTag",
	"editorID","IsHide","nTarget","animationTag","mapScorePec",
}

local __DefalutTag = {}

--填充属性位 attr
local __CODE__UnitAttrInit = function(self, tDefaultAttr ,tabA, tAttr, id, sWorldType, lv, star)
	--test
	--lv = 3
	--star = 2
	
	local a = tAttr
	for k,v in pairs(tDefaultAttr)do
		a[k] = tabA and tabA[k] or tDefaultAttr[k]
	end
	if tabA~=tAttr then
		a.attack = {0,0,0,0,0}		--{id,rMin,rMax,dMin,dMax}
		if (sWorldType=="battlefield") or (sWorldType=="worldmap") then --geyachao: 大地图也支持
			a.replaceID = {} --如果tab_skill[id].replace为字符串，则会尝试从此处取出一个id替换此技能(战场专用)
			a.BeforeAttackID = {} --玩家在主动发起攻击前会先使用这个表格中的技能
			a.replaceNormalAtkID = {} --geyachao: 新加的有几率替换普通攻击
			a.BuffHint = {index={}} --玩家获得buff后会在这里显示{{id,lv,dur,param},...}
		else
			a.replaceID = 0
			a.BeforeAttackID = 0
			a.BuffHint = 0
		end
		if tabA and type(tabA.attack)=="table" then
			for i = 1,#a.attack do
				a.attack[i] = tabA.attack[i] or 0
			end
		end
		if not(a.skill and #a.skill==0 and a.i==0 and a.num==0) then
			a.skill = {i=0,num=0,index={}}
		end
		
		
		--设置角色的最大生命值
		a.mxhp = a.hp
		
		--设置角色初始的堆叠值
		a.stun_stack = 0 --眩晕的堆叠层数
		a.big_stack = 0 --变大的堆叠层数
		a.immue_physic_stack = 0 --物理免疫的堆叠层数
		a.immue_magic_stack = 0 --法术免疫的堆叠层数
		a.immue_wudi_stack = 0 --无敌的堆叠层数
		a.immue_control_stack = 0 --免控的堆叠层数
		a.immue_debuff_stack = 0 --免疫负面属性效果的堆叠层数
		a.suffer_chaos_stack = 0 --混乱的堆叠层数
		a.suffer_blow_stack = 0 --吹风的堆叠层数
		a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
		a.suffer_sleep_stack = 0 --沉睡的堆叠层数
		a.suffer_chenmo_stack = 0 --沉默的堆叠层数
		a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
		a.space_ground_stack = 0 --变地面单位堆叠层数
		a.suffer_touming_stack = 0 --透明的堆叠层数（不能碰撞）
		a.immue_damage_stack = 0 --免疫伤害堆叠层数
		a.immue_damage_ice_stack = 0 --免疫冰伤害堆叠层数
		a.immue_damage_thunder_stack = 0 --免疫雷伤害堆叠层数
		a.immue_damage_fire_stack = 0 --免疫火伤害堆叠层数
		a.immue_damage_poison_stack = 0 --免疫毒伤害堆叠层数
		a.immue_damage_bullet_stack = 0 --免疫子弹伤害堆叠层数
		a.immue_damage_boom_stack = 0 --免疫冰爆炸害堆叠层数
		a.immue_damage_chuanci_stack = 0 --免疫穿刺伤害堆叠层数
		
		a.yinshen_state = 0 --一开始不是隐身状态
		a.yinshen_effect = 0 --一开始没有隐身特效
		
		a.last_attack_time = 0 --上一次普攻的时间
		
		a.tracingNum = 0 --追踪导弹被追踪的次数
		
		--geyachao: 角色属性初始化
		if tabA then
			a.armor = tabA.armor
			a.armor_lasttime = 0
			
			--属性相关
			--存储单位的等级和星级
			a.lv = lv or tabA.level or 1 --等级（先读传进来的值，如果没传值读填表的值，如果没填表默认为1级）
			a.star = star or tabA.star or 1 --星级（先读传进来的值，如果没传值读填表的值，如果没填表默认为1级）
			a.pvp_lv = 1 --pvp等级（默认为pvp 1级）
			
			a.hp = self:GetHpMax()
			
			a.skill_AI_sequence = 0 --geyachao: 新加数据 技能释放AI规则表
		end
		
		--属性重算
		self:__AttrRecheckBasic()
		
		--print("name=" .. hVar.tab_unit[id].name .. ", level=" .. a.lv .. ", star=" .. a.star .. ", hp_max=" .. a.hp_max_basic .. ", atk_min=" .. a.attack[4] .. ", atk_max=" .. a.attack[5] .. ", hp_restore=" .. a.hp_restore_basic .. ", move_speed=" .. a.move_speed_basic .. ", atk_radius=" .. a.atk_radius_basic .. ", atk_interval=" .. a.atk_interval_basic .. ", def_physic=" .. a.def_physic_basic .. ", def_magic=" .. a.def_magic_basic .. ", dodge_rate=" .. a.dodge_rate_basic .. ", crit_rate=" .. a.crit_rate_basic .. ", crit_value=" .. a.crit_value_basic)
	end
	
	return tAttr
end

local __DefaultAttr =
{
	stack = 1,			--堆叠数量
	__stack = 0,			--初始堆叠数量
	counter = 1,			--每轮可反击的次数，开始补一次，后面每回合轮到自己行动时补充
	__counter = 0,			--基础反击次数
	siege = 1,			--攻城伤害
	attackID = 0,			--此值不为0时，会使用这个id的技能进行攻击
	counterID = 0,			--此值不为0时，会使用这个id的技能进行反击
	encounterID = 0,		--远程兵种遭遇敌人时，会使用这个技能进行攻击,如果此值为-1，则不能攻击,0的话使用默认反击技能hVar.ENCOUNTERED_ATTACK_ID
	power = 100,			--使用技能时，此数值会被读取到技能上
	healpower = 0,			--接受治疗时，效果提升为(100+healpower)
	counterpower = 0,		--使用反击技能时，此数值和英雄原有的伤害加成叠加
	countercount = 0,		--当前单位行动内进行过的反击次数(战场专用)
	summonpower = 0,		--召唤任何生物后，该生物的攻击力获得加成
	summonhp = 0,			--召唤任何生物后，该生物的生命值获得加成
	fearful = 0,			--此值大于0时单位,被攻击的目标不会反击
	attackHeal = 0,			--单位发动攻击或反击时会恢复等同于此数值的生命
	castpower = 0,			--使用技能时，此数值和英雄原有的伤害加成叠加
	movecount = 0,			--当前单位行动内移动过的距离
	exhp = 0,			--额外生命(护盾,可以吸收伤害)
	eliteDef = 0,			--承受来自精英(英雄)的伤害降低(x%)，上限75%
	meleeDef = 0,			--承受来自近战单位(非英雄)的伤害降低(x%)，上限75%
	rangeDef = 0,			--承受来自远程单位(非英雄)的伤害降低(x%)，上限75%
	def = 0,			--防御
	pen = 0,			--穿透，降低目标单位的护甲
	armor = hVar.ARMOR_TYPE.ARMOR,			--护甲类型，目前决定了单位飞出来的碎片
	armor_lasttime = 0, --上次播放的时间
	move = 0,
	passive = 0,			--被动:如果此值大于0，那么该单位不会出现在行动列表中
	IsFlyer = 0,			--是飞行单位
	IsBuilding = 0,			--是建筑(攻击目标选择)
	IsMachine = 0,			--是机械单位(攻击目标选择)
	hp = 1,
	mxhp = 0,
	__mxhp = 0,			--记录单位的基础最大生命值
	mp = 0,
	mxmp = 0,
	damaged = 0,			--此值代表单位的受伤程度，1~100%。用于技能物体的等待事件{"WaitingFor","UnitDamaged",%d},只有heroic==1并且__stack==1的单位才可以触发这个事件
	activity = 0,			--主动性(决定单位的行动顺序)
	lea = 0,			--单位受到英雄的统率*攻击加成，进战场时计算一次
	led = 0,			--单位受到英雄的统率*防御加成，进战场时计算一次
	activecount = 0,		--该单位本回合被激活的次数，每回合重置
	----------------------------------------
	hpSteal = 0,			--百分比吸血
	mpSteal = 0,			--百分比偷魔(目前完全没有用)
	----------------------------------------
	invincible = 0,			--特殊:无敌（无敌的单位不能成为技能的目标，也不会受到任何伤害）
	stun = 0,			--特殊:被眩晕（眩晕的单位不能行动，自动跳过当前回合）
	smash = 0,			--破击:如果此值大于0,你那么该单位在对非英雄单位造成眩晕效果时不会触发韧性
	toughness = 0,			--强韧:（控制抵抗，遭受控制效果后，根据此数值会获得一定时间的控制免疫）
	stunimmunity = 0,		--眩晕免疫（如果此值大于0，则免疫眩晕效果，非眩晕状态下每回合开始时-1）
	paralyzed = 0,			--特殊:被瘫痪（瘫痪的单位同时也会被眩晕，且不会由于受打击改变动画，颜色变灰，恢复时会自动播放一次stand）
	frozen = 0,			--特殊:被冻结（冻结的单位同时也会被眩晕，且不会由于受打击改变动画，颜色变蓝，恢复时会自动播放一次stand）
	silent = 0,			--特殊:被沉默（沉默的单位不能使用技能）
	block = 0,			--体型:等同于阻挡
	heroic = 0,			--英雄的:如果此值为1，则计算伤害时使用英雄减免
	stealth = 0,			--潜行，潜行的单位不能被选定为技能目标，并且会变透明
	flee = 0,			--伤害闪避,有一定几率闪避伤害
	fleecount = 0,			--伤害闪避(计数),一旦触发，那么在该次行动内都不会受到普通攻击伤害
	powerFrom = 0,			--对某些单位具有额外的攻击力加成(tab)
	powerTo = 0,			--承受来自其他单位的伤害减益(tab)
	BasicAttackID = 0,		--玩家在首回合设置的BasicAttackID会记录在这里，一般是武器附加特效
	ShootAttackID = 0,		--如果使用射击类技能，可以将此处填写的技能ID发射出去
	NextAttackID = 0,		--如果发动攻击时此id不为0，那么会使用此技能替代普通攻击
	AttackBounceEx = 0,		--计算攻击力时，额外附加(tab)
	DamageLink = 0,			--如果此值大于0，则将对自己的伤害转移到目标身上
	DamageTaken = 0,		--战场里面承受伤害后，会累加到此值上
	ManaUsed = 0,			--战场里面消耗法力后，会累加到此值上
	DamageCount = 0,		--战场里面造成伤害后，会累加到此值上
	HealCount = 0,			--战场里面造成治疗后，会累加到此值上
	EvadeArea = 0,			--如果此值大于0，那么不会受到范围伤害的影响(法力9或以下的技能才受到这个效果影响)
	EvadeAreaEx = 0,		--如果此值大于0，那么上面那个值会对法力9以上的技能也会生效
	duration = 0,			--召唤生物的剩余生存回合
	poisoned = 0,			--如果此值大于0，那么在其身上持续的毒素效果会自动延长时间

	--显示属性
	color = 0,
	color_origin = 0,
	colorInRender = 0,		--是否在变色中
	alpha = 0,
	
	--attackInterval = 500, --TD角色攻击间隔 --geyachao: 新加数据
	lastAttackTime_adjust = 0, --TD角色上次攻击的时间修正值（因为timer精度有误差） --geyachao: 新加数据
	lastAttackTime = -999999, --TD角色上次攻击的时间 --geyachao: 新加数据
	--gold = 0,	--TD角色击杀后获得金钱 --zhenkira: 新增数据
	--search_radius = 200, --TD自动攻击搜敌半径
	--costLife = 1, --TD角色逃跑后扣除生命 --zhenkira:新增数据
	
	skill_AI_sequence = 0, --geyachao: 新加数据 技能释放AI规则表
	
	onReachedCastSkillId = 0, --走完路点后，释放技能
	
	--该单位作为绑定单位，偏移值
	bind_offsetX = 0,
	bind_offsetY = 0,
	
	lv = 1,		--zhenkira unit等级
	star = 1,	--zhenkira unit星级
	pvp_lv = 1, --pvp等级
	pvp_exp = 0, --pvp经验值
	
	--每级成长值
	hp_lvup = 0, --血量每级成长值
	hp_restore_lvup = 0.0, --回血速度（每秒）每级成长值（支持小数）
	move_speed_lvup = 0, --移动速度每级成长值
	atk_min_lvup = 0, --最小攻击力每级成长值
	atk_max_lvup = 0, --最大攻击力每级成长值
	atk_ice_lvup = 0, --冰攻击力每级成长值
	atk_thunder_lvup = 0, --雷攻击力每级成长值
	atk_fire_lvup = 0, --火攻击力每级成长值
	atk_poison_lvup = 0, --毒攻击力每级成长值
	atk_bullet_lvup = 0, --子弹攻击力每级成长值
	atk_bomb_lvup = 0, --爆炸攻击力每级成长值
	atk_chuanci_lvup = 0, --穿刺攻击力每级成长值
	atk_radius_lvup = 0, --攻击范围每级成长值
	atk_interval_lvup = 0, --攻击间隔每级成长值
	atk_speed_lvup = 0, --攻击速度（去百分号后的值）每级成长值
	def_physic_lvup = 0, --物防每级成长值
	def_magic_lvup = 0, --法防每级成长值
	def_ice_lvup = 0, --冰防每级成长值
	def_thunder_lvup = 0, --雷防每级成长值
	def_fire_lvup = 0, --火防每级成长值
	def_poison_lvup = 0, --毒防每级成长值
	def_bullet_lvup = 0, --子弹防每级成长值
	def_bomb_lvup = 0, --爆炸防每级成长值
	def_chuanci_lvup = 0, --穿刺防每级成长值
	bullet_capacity_lvup = 0, --携弹数量每级成长值
	grenade_capacity_lvup = 0, --手雷数量每级成长值
	grenade_child_lvup = 0, --子母雷数量每级成长值
	grenade_fire_lvup = 0, --手雷爆炸火焰每级成长值
	grenade_dis_lvup = 0, --手雷投弹距离每级成长值
	grenade_cd_lvup = 0, --手雷冷却时间每级成长值
	grenade_crit_lvup = 0, --手雷暴击每级成长值
	grenade_multiply_lvup = 0, --手雷冷却前使用次数每级成长值
	inertia_lvup = 0, --惯性每级成长值
	crystal_rate_lvup = 0, --水晶收益率（去百分号后的值）每级成长值
	melee_bounce_lvup = 0, --近战弹开每级成长值
	melee_fight_lvup = 0, --近战反击每级成长值
	melee_stone_lvup = 0, --近战碎石每级成长值
	dodge_rate_lvup = 0, --闪避几率（去百分号后的值）每级成长值
	hit_rate_lvup = 0, --命中几率（去百分号后的值）每级成长值
	crit_value_lvup = 0.0, --暴击倍数每级成长值（支持小数）
	rebirth_time_lvup = 0, --复活时间每级成长值（毫秒）
	suck_blood_rate_lvup = 0, --吸血率每级成长值（去百分号后的值）
	active_skill_cd_delta_lvup = 0, --主动技能冷却时间变化值每级成长值（毫秒）
	passive_skill_cd_delta_lvup = 0, --被动技能冷却时间变化值每级成长值（毫秒）
	
	--pvp等级每级成长值
	pvp_hp_lvup = 0, --pvp等级血量每级成长值
	pvp_hp_restore_lvup = 0.0, --pvp等级回血速度（每秒）每级成长值（支持小数）
	pvp_move_speed_lvup = 0, --pvp等级移动速度每级成长值
	pvp_atk_min_lvup = 0, --pvp等级最小攻击力每级成长值
	pvp_atk_max_lvup = 0, --pvp等级最大攻击力每级成长值
	pvp_atk_ice_lvup = 0, --pvp冰攻击力每级成长值
	pvp_atk_thunder_lvup = 0, --pvp雷攻击力每级成长值
	pvp_atk_fire_lvup = 0, --pvp火攻击力每级成长值
	pvp_atk_poison_lvup = 0, --pvp毒攻击力每级成长值
	pvp_atk_bullet_lvup = 0, --pvp子弹攻击力每级成长值
	pvp_atk_bomb_lvup = 0, --pvp爆炸攻击力每级成长值
	pvp_atk_chuanci_lvup = 0, --pvp穿刺攻击力每级成长值
	pvp_atk_radius_lvup = 0, --pvp等级攻击范围每级成长值
	pvp_atk_interval_lvup = 0, --pvp等级攻击间隔每级成长值
	pvp_atk_speed_lvup = 0, --pvp等级攻击速度（去百分号后的值）每级成长值
	pvp_def_physic_lvup = 0, --pvp等级物防每级成长值
	pvp_def_magic_lvup = 0, --pvp等级法防每级成长值
	pvp_def_ice_lvup = 0, --pvp冰防每级成长值
	pvp_def_thunder_lvup = 0, --pvp雷防每级成长值
	pvp_def_fire_lvup = 0, --pvp火防每级成长值
	pvp_def_poison_lvup = 0, --pvp毒防每级成长值
	pvp_def_bullet_lvup = 0, --pvp子弹防每级成长值
	pvp_def_bomb_lvup = 0, --pvp爆炸防每级成长值
	pvp_def_chuanci_lvup = 0, --pvp穿刺防每级成长值
	pvp_bullet_capacity_lvup = 0, --pvp携弹数量每级成长值
	pvp_grenade_capacity_lvup = 0, --pvp手雷数量每级成长值
	pvp_grenade_child_lvup = 0, --pvp子母雷数量每级成长值
	pvp_grenade_fire_lvup = 0, --pvp手雷爆炸火焰每级成长值
	pvp_grenade_dis_lvup = 0, --pvp手雷投弹距离每级成长值
	pvp_grenade_cd_lvup = 0, --pvp手雷冷却时间每级成长值
	pvp_grenade_crit_lvup = 0, --pvp手雷暴击每级成长值
	pvp_grenade_multiply_lvup = 0, --手雷冷却前使用次数每级成长值
	pvp_inertia_lvup = 0, --pvp惯性每级成长值
	pvp_crystal_rate_lvup = 0, --pvp水晶收益率（去百分号后的值）每级成长值
	pvp_melee_bounce_lvup = 0, --pvp近战弹开每级成长值
	pvp_melee_fight_lvup = 0, --pvp近战反击每级成长值
	pvp_melee_stone_lvup = 0, --pvp近战碎石每级成长值
	pvp_dodge_rate_lvup = 0, --pvp等级闪避几率（去百分号后的值）每级成长值
	pvp_hit_rate_lvup = 0, --pvp等级命中几率（去百分号后的值）每级成长值
	pvp_crit_value_lvup = 0.0, --pvp等级暴击倍数每级成长值（支持小数）
	pvp_rebirth_time_lvup = 0, --pvp等级复活时间每级成长值（毫秒）
	pvp_suck_blood_rate_lvup = 0, --pvp等级吸血率每级成长值（去百分号后的值）
	pvp_active_skill_cd_delta_lvup = 0, --主动技能冷却时间变化值每级成长值（毫秒）
	pvp_passive_skill_cd_delta_lvup = 0, --被动技能冷却时间变化值每级成长值（毫秒）
	
	--属性相关
	hp_max_basic = 1, --基础血量
	hp_max_item = 0, --道具附加血量
	hp_max_buff = 0, --buff附加血量
	hp_max_aura = 0, --光环附加血量
	hp_max_tactic = 0, --战术技能卡附加血量
	
	hp = 100, --当前血量
	
	atk_basic = 0, --基础攻击力
	atk_item = 0, --道具附加攻击力
	atk_buff = 0, --buff附加攻击力
	atk_aura = 0, --光环附加攻击力
	atk_tactic = 0, --战术技能卡附加攻击力
	
	atk_ice_basic = 0, --基础冰攻击力
	atk_ice_item = 0, --道具附加冰攻击力
	atk_ice_buff = 0, --buff附加冰攻击力
	atk_ice_aura = 0, --光环附加冰攻击力
	atk_ice_tactic = 0, --战术技能卡附加冰攻击力
	
	atk_thunder_basic = 0, --基础雷攻击力
	atk_thunder_item = 0, --道具附加雷攻击力
	atk_thunder_buff = 0, --buff附加雷攻击力
	atk_thunder_aura = 0, --光环附加雷攻击力
	atk_thunder_tactic = 0, --战术技能卡附加雷攻击力
	
	atk_fire_basic = 0, --基础火攻击力
	atk_fire_item = 0, --道具附加火攻击力
	atk_fire_buff = 0, --buff附加火攻击力
	atk_fire_aura = 0, --光环附加火攻击力
	atk_fire_tactic = 0, --战术技能卡附加火攻击力
	
	atk_poison_basic = 0, --基础毒攻击力
	atk_poison_item = 0, --道具附加毒攻击力
	atk_poison_buff = 0, --buff附加毒攻击力
	atk_poison_aura = 0, --光环附加毒攻击力
	atk_poison_tactic = 0, --战术技能卡附加毒攻击力
	
	atk_bullet_basic = 0, --基础子弹攻击力
	atk_bullet_item = 0, --道具附加子弹攻击力
	atk_bullet_buff = 0, --buff附加子弹攻击力
	atk_bullet_aura = 0, --光环附加子弹攻击力
	atk_bullet_tactic = 0, --战术技能卡附加子弹攻击力
	
	atk_bomb_basic = 0, --基础爆炸攻击力
	atk_bomb_item = 0, --道具附加爆炸攻击力
	atk_bomb_buff = 0, --buff附加爆炸攻击力
	atk_bomb_aura = 0, --光环附加爆炸攻击力
	atk_bomb_tactic = 0, --战术技能卡附加爆炸攻击力
	
	atk_chuanci_basic = 0, --基础穿刺攻击力
	atk_chuanci_item = 0, --道具附加穿刺攻击力
	atk_chuanci_buff = 0, --buff附加穿刺攻击力
	atk_chuanci_aura = 0, --光环附加穿刺攻击力
	atk_chuanci_tactic = 0, --战术技能卡附加穿刺攻击力
	
	atk_interval_basic = 1000, --基础攻击间隔（毫秒）
	atk_interval_item = 0, --道具附加攻击间隔（毫秒）
	atk_interval_buff = 0, --buff附加攻击间隔（毫秒）
	atk_interval_aura = 0, --光环附加攻击间隔（毫秒）
	atk_interval_tactic = 0, --战术技能卡附加攻击间隔（毫秒）
	
	atk_speed_basic = 100, --基础攻击速度（去百分号后的值）
	atk_speed_item = 0, --道具附加攻击速度（去百分号后的值）
	atk_speed_buff = 0, --buff附加攻击速度（去百分号后的值）
	atk_speed_aura = 0, --光环附加攻击速度（去百分号后的值）
	atk_speed_tactic = 0, --战术技能卡附加攻击速度（去百分号后的值）
	
	move_speed_basic = 0, --基础移动速
	move_speed_item = 0, --道具附加移动速度
	move_speed_buff = 0, --buff附加移动速度
	move_speed_aura = 0, --光环附加移动速度
	move_speed_tactic = 0, --战术技能卡附加移动速度
	
	atk_radius_basic = 0, --基础攻击范围
	atk_radius_item = 0, --道具附加攻击范围
	atk_radius_buff = 0, --buff附加攻击范围
	atk_radius_aura = 0, --光环附加攻击范围
	atk_radius_tactic = 0, --战术技能卡附加攻击范围
	
	atk_radius_min_basic = 0, --基础攻击范围最小值
	atk_radius_min_item = 0, --道具附加攻击范围最小值
	atk_radius_min_buff = 0, --buff附加攻击范围最小值
	atk_radius_min_aura = 0, --光环附加攻击范围最小值
	atk_radius_min_tactic = 0, --战术技能卡附加攻击范围
	
	--atk_search_radius_basic = 0, --基础攻击搜敌范围
	--atk_search_radius_buff = 0, --buff攻击附加搜敌范围
	--atk_search_radius_aura = 0, --光环攻击附加搜敌范围
	--atk_search_radius_tactic = 0, --战术技能卡附加搜敌范围
	
	def_physic_basic = 0, --基础物防
	def_physic_item = 0, --道具附加物防
	def_physic_buff = 0, --buff附加物防
	def_physic_aura = 0, --光环附加物防
	def_physic_tactic = 0, --战术技能卡附加物防
	
	def_magic_basic = 0, --基础法防
	def_magic_item = 0, --道具附加法防
	def_magic_buff = 0, --buff附加法防
	def_magic_aura = 0, --光环附加法防
	def_magic_tactic = 0, --战术技能卡附加法防
	
	def_ice_basic = 0, --基础冰防御
	def_ice_item = 0, --道具附加冰防御
	def_ice_buff = 0, --buff附加冰防御
	def_ice_aura = 0, --光环附加冰防御
	def_ice_tactic = 0, --战术技能卡附加冰防御
	
	def_thunder_basic = 0, --基础雷防御
	def_thunder_item = 0, --道具附加雷防御
	def_thunder_buff = 0, --buff附加雷防御
	def_thunder_aura = 0, --光环附加雷防御
	def_thunder_tactic = 0, --战术技能卡附加雷防御
	
	def_fire_basic = 0, --基础火防御
	def_fire_item = 0, --道具附加火防御
	def_fire_buff = 0, --buff附加火防御
	def_fire_aura = 0, --光环附加火防御
	def_fire_tactic = 0, --战术技能卡附加火防御
	
	def_poison_basic = 0, --基础毒防御
	def_poison_item = 0, --道具附加毒防御
	def_poison_buff = 0, --buff附加毒防御
	def_poison_aura = 0, --光环附加毒防御
	def_poison_tactic = 0, --战术技能卡附加毒防御
	
	def_bullet_basic = 0, --基础子弹防御
	def_bullet_item = 0, --道具附加子弹防御
	def_bullet_buff = 0, --buff附加子弹防御
	def_bullet_aura = 0, --光环附加子弹防御
	def_bullet_tactic = 0, --战术技能卡附加子弹防御
	
	def_bomb_basic = 0, --基础爆炸防御
	def_bomb_item = 0, --道具附加爆炸防御
	def_bomb_buff = 0, --buff附加爆炸防御
	def_bomb_aura = 0, --光环附加爆炸防御
	def_bomb_tactic = 0, --战术技能卡附加爆炸防御
	
	def_chuanci_basic = 0, --基础穿刺防御
	def_chuanci_item = 0, --道具附加穿刺防御
	def_chuanci_buff = 0, --buff附加穿刺防御
	def_chuanci_aura = 0, --光环附加穿刺防御
	def_chuanci_tactic = 0, --战术技能卡附加穿刺防御
	
	bullet_capacity_basic = 0, --基础携弹数量
	bullet_capacity_item = 0, --道具附加携弹数量
	bullet_capacity_buff = 0, --buff附加携弹数量
	bullet_capacity_aura = 0, --光环附加携弹数量
	bullet_capacity_tactic = 0, --战术技能卡附加携弹数量
	
	grenade_capacity_basic = 0, --基础手雷数量
	grenade_capacity_item = 0, --道具附加手雷数量
	grenade_capacity_buff = 0, --buff附加手雷数量
	grenade_capacity_aura = 0, --光环附加手雷数量
	grenade_capacity_tactic = 0, --战术技能卡附加手雷数量
	
	grenade_child_basic = 0, --基础子母雷数量
	grenade_child_item = 0, --道具附加子母雷数量
	grenade_child_buff = 0, --buff附加子母雷数量
	grenade_child_aura = 0, --光环附加子母雷数量
	grenade_child_tactic = 0, --战术技能卡附加子母雷数量
	
	grenade_fire_basic = 0, --基础手雷爆炸火焰
	grenade_fire_item = 0, --道具附加手雷爆炸火焰
	grenade_fire_buff = 0, --buff附加手雷爆炸火焰
	grenade_fire_aura = 0, --光环附加手雷爆炸火焰
	grenade_fire_tactic = 0, --战术技能卡附加手雷爆炸火焰
	
	grenade_dis_basic = 100, --基础手雷投弹距离
	grenade_dis_item = 0, --道具附加手雷投弹距离
	grenade_dis_buff = 0, --buff附加手雷投弹距离
	grenade_dis_aura = 0, --光环附加手雷投弹距离
	grenade_dis_tactic = 0, --战术技能卡附加手雷投弹距离
	
	grenade_cd_basic = 0, --基础手雷冷却时间（单位：毫秒）
	grenade_cd_item = 0, --道具附加手雷冷却时间
	grenade_cd_buff = 0, --buff附加手雷冷却时间
	grenade_cd_aura = 0, --光环附加手雷冷却时间
	grenade_cd_tactic = 0, --战术技能卡附加手雷冷却时间
	
	grenade_crit_basic = 0, --基础手雷暴击
	grenade_crit_item = 0, --道具附加手雷暴击
	grenade_crit_buff = 0, --buff附加手雷暴击
	grenade_crit_aura = 0, --光环附加手雷暴击
	grenade_crit_tactic = 0, --战术技能卡附加手雷暴击
	
	grenade_multiply_basic = 1, --基础手雷冷却前使用次数
	grenade_multiply_item = 0, --道具附加手雷冷却前使用次数
	grenade_multiply_buff = 0, --buff附加手雷冷却前使用次数
	grenade_multiply_aura = 0, --光环附加手雷冷却前使用次数
	grenade_multiply_tactic = 0, --战术技能卡附加手雷冷却前使用次数
	
	inertia_basic = 0, --基础惯性
	inertia_item = 0, --道具附加惯性
	inertia_buff = 0, --buff附加惯性
	inertia_aura = 0, --光环附加惯性
	inertia_tactic = 0, --战术技能卡附加惯性
	
	crystal_rate_basic = 100, --基础水晶收益率（去百分号后的值）
	crystal_rate_item = 0, --道具附加水晶收益率（去百分号后的值）
	crystal_rate_buff = 0, --buff附加水晶收益率（去百分号后的值）
	crystal_rate_aura = 0, --光环附加水晶收益率（去百分号后的值）
	crystal_rate_tactic = 0, --战术附加技能卡水晶收益率（去百分号后的值）
	
	melee_bounce_basic = 0, --基础近战弹开
	melee_bounce_item = 0, --道具附加近战弹开
	melee_bounce_buff = 0, --buff附加近战弹开
	melee_bounce_aura = 0, --光环附加近战弹开
	melee_bounce_tactic = 0, --战术技能卡附加近战弹开
	
	melee_fight_basic = 0, --基础近战反击
	melee_fight_item = 0, --道具附加近战反击
	melee_fight_buff = 0, --buff附加近战反击
	melee_fight_aura = 0, --光环附加近战反击
	melee_fight_tactic = 0, --战术技能卡附加近战反击
	
	melee_stone_basic = 0, --基础近战碎石
	melee_stone_item = 0, --道具附加近战碎石
	melee_stone_buff = 0, --buff附加近战碎石
	melee_stone_aura = 0, --光环附加近战碎石
	melee_stone_tactic = 0, --战术技能卡附加近战反击
	
	dodge_rate_basic = 0, --基础闪避几率（去百分号后的值）
	dodge_rate_item = 0, --道具附加闪避几率（去百分号后的值）
	dodge_rate_buff = 0, --buff附加闪避几率（去百分号后的值）
	dodge_rate_aura = 0, --光环附加闪避几率（去百分号后的值）
	dodge_rate_tactic = 0, --战术技能卡附加闪避几率（去百分号后的值）
	
	hit_rate_basic = 0, --基础命中几率（去百分号后的值）
	hit_rate_item = 0, --道具附加命中几率（去百分号后的值）
	hit_rate_buff = 0, --buff附加命中几率（去百分号后的值）
	hit_rate_aura = 0, --光环附加命中几率（去百分号后的值）
	hit_rate_tactic = 0, --战术技能卡附加命中几率（去百分号后的值）
	
	crit_rate_basic = 0, --基础暴击几率（去百分号后的值）
	crit_rate_item = 0, --道具附加暴击几率（去百分号后的值）
	crit_rate_buff = 0, --buff附加暴击几率（去百分号后的值）
	crit_rate_aura = 0, --光环附加暴击几率（去百分号后的值）
	crit_rate_tactic = 0, --战术技能卡附加暴击几率（去百分号后的值）
	
	crit_value_basic = 2.0, --基础暴击倍数（支持小数）
	crit_value_item = 0.0, --道具附加暴击倍数（支持小数）
	crit_value_buff = 0.0, --buff附加暴击倍数（支持小数）
	crit_value_aura = 0.0, --光环附加暴击倍数（支持小数）
	crit_value_tactic = 0.0, --战术技能卡附加暴击倍数（支持小数）
	
	kill_gold_basic = 0, --基础击杀获得的金币
	kill_gold_item = 0, --道具附加击杀获得的金币
	kill_gold_buff = 0, --buff附加击杀获得的金币
	kill_gold_aura = 0, --光环附加击杀获得的金币
	kill_gold_tactic = 0, --战术技能卡附加击杀获得的金币
	
	escape_punish_basic = 0, --基础逃怪惩罚
	escape_punish_item = 0, --道具附加逃怪惩罚
	escape_punish_buff = 0, --buff附加逃怪惩罚
	escape_punish_aura = 0, --光环附加逃怪惩罚
	escape_punish_tactic = 0, --战术技能卡附加逃怪惩罚
	
	hp_restore_basic = 0.0, --基础回血速度（每秒）（支持小数）
	hp_restore_item = 0.0, --道具附加回血速度（每秒）（支持小数）
	hp_restore_buff = 0.0, --buff附加回血速度（每秒）（支持小数）
	hp_restore_aura = 0.0, --光环附加回血速度（每秒）（支持小数）
	hp_restore_tactic = 0.0, --战术技能卡附加回血速度（每秒）（支持小数）
	
	hp_restore_float_value = 0, --当前的回血小数值
	
	rebirth_time_basic = 10000, --基础复活时间（毫秒）
	rebirth_time_item = 0, --道具附加复活时间（毫秒）
	rebirth_time_buff = 0, --buff附加复活时间（毫秒）
	rebirth_time_aura = 0, --光环附加复活时间（毫秒）
	rebirth_time_tactic = 0, --战术技能卡附加复活时间（毫秒）
	
	suck_blood_rate_basic = 0, --基础吸血率（去百分号后的值）
	suck_blood_rate_item = 0, --道具吸血率（去百分号后的值）
	suck_blood_rate_buff = 0, --buff吸血率（去百分号后的值）
	suck_blood_rate_aura = 0, --光环吸血率（去百分号后的值）
	suck_blood_rate_tactic = 0, --战术技能卡吸血率（去百分号后的值）
	
	active_skill_cd_delta_basic = 0, --基础主动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_item = 0, --道具主动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_buff = 0, --buff主动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_aura = 0, --光环主动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_tactic = 0, --战术技能卡主动技能冷却时间变化值（毫秒）
	
	active_skill_cd_delta_rate_basic = 0, --基础主动技能冷却时间变化比例值（去百分号后的值）
	active_skill_cd_delta_rate_item = 0, --道具主动技能冷却时间变化比例值（去百分号后的值）
	active_skill_cd_delta_rate_buff = 0, --buff主动技能冷却时间变化比例值（去百分号后的值）
	active_skill_cd_delta_rate_aura = 0, --光环主动技能冷却时间变化比例值（去百分号后的值）
	active_skill_cd_delta_rate_tactic = 0, --战术技能卡主动技能冷却时间变化比例值（去百分号后的值）
	
	passive_skill_cd_delta_basic = 0, --基础被动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta_item = 0, --道具被动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta_buff = 0, --buff被动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta_aura = 0, --光环被动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta_tactic = 0, --战术技能卡被动技能冷却时间变化值（毫秒）
	
	passive_skill_cd_delta_rate_basic = 0, --基础被动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate_item = 0, --道具被动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate_buff = 0, --buff被动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate_aura = 0, --光环被动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate_tactic = 0, --战术技能卡被动技能冷却时间变化比例值（去百分号后的值）
	
	AI_attribute_basic = 0, --基础AI行为（0：被动怪 / 1:主动怪）
	AI_attribute_item = 0, --道具AI行为（0：被动怪 / 1:主动怪）
	AI_attribute_buff = 0, --buffAI行为（0：被动怪 / 1:主动怪）
	AI_attribute_aura = 0, --光环AI行为（0：被动怪 / 1:主动怪）
	AI_attribute_tactic = 0, --战术技能卡AI行为（0：被动怪 / 1:主动怪）
	
	rebirth_wudi_time_basic = 1000, --基础复活后无敌时间（毫秒）
	rebirth_wudi_time_item = 0, --道具复活后无敌时间（毫秒）
	rebirth_wudi_time_buff = 0, --buff复活后无敌时间（毫秒）
	rebirth_wudi_time_aura = 0, --光环复活后无敌时间（毫秒）
	rebirth_wudi_time_tactic = 0, --战术技能卡复活后无敌时间（毫秒）
	
	basic_weapon_level_basic = 1, --基础武器等级
	basic_weapon_level_item = 0, --道具武器等级
	basic_weapon_level_buff = 0, --buff武器等级
	basic_weapon_level_aura = 0, --光环武器等级
	basic_weapon_level_tactic = 0, --战术技能卡武器等级
	
	basic_skill_level_basic = 1, --基础技能等级
	basic_skill_level_item = 0, --道具技能等级
	basic_skill_level_buff = 0, --buff技能等级
	basic_skill_level_aura = 0, --光环技能等级
	basic_skill_level_tactic = 0, --战术技能卡技能等级
	
	basic_skill_usecount_basic = 1, --基础技能使用次数
	basic_skill_usecount_item = 0, --道具技能使用次数
	basic_skill_usecount_buff = 0, --buff技能使用次数
	basic_skill_usecount_aura = 0, --光环技能使用次数
	basic_skill_usecount_tactic = 0, --战术技能卡技能使用次数
	
	pet_hp_restore_basic = 0, --基础宠物回血
	pet_hp_restore_item = 0, --道具宠物回血
	pet_hp_restore_buff = 0, --buff宠物回血
	pet_hp_restore_aura = 0, --光环宠物回血
	pet_hp_restore_tactic = 0, --战术技能卡宠物回血
	
	pet_hp_basic = 0, --基础宠物生命
	pet_hp_item = 0, --道具宠物生命
	pet_hp_buff = 0, --buff宠物生命
	pet_hp_aura = 0, --光环宠物生命
	pet_hp_tactic = 0, --战术技能卡宠物生命
	
	pet_atk_basic = 0, --基础宠物攻击
	pet_atk_item = 0, --道具宠物攻击
	pet_atk_buff = 0, --buff宠物攻击
	pet_atk_aura = 0, --光环宠物攻击
	pet_atk_tactic = 0, --战术技能卡宠物攻击
	
	pet_atk_speed_basic = 0, --基础宠物攻速
	pet_atk_speed_item = 0, --道具宠物攻速
	pet_atk_speed_buff = 0, --buff宠物攻速
	pet_atk_speed_aura = 0, --光环宠物攻速
	pet_atk_speed_tactic = 0, --战术技能卡宠物攻速
	
	pet_capacity_basic = 1, --基础宠物携带数量
	pet_capacity_item = 0, --道具宠物携带数量
	pet_capacity_buff = 0, --buff宠物携带数量
	pet_capacity_aura = 0, --光环宠物携带数量
	pet_capacity_tactic = 0, --战术技能卡宠物携带数量
	
	trap_ground_basic = 0, --基础陷阱时间（单位：毫秒）
	trap_ground_item = 0, --道具陷阱时间（单位：毫秒）
	trap_ground_buff = 0, --buff陷阱时间（单位：毫秒）
	trap_ground_aura = 0, --光环陷阱时间（单位：毫秒）
	trap_ground_tactic = 0, --战术技能卡陷阱时间（单位：毫秒）
	
	trap_groundcd_basic = 2000, --基础陷阱施法间隔（单位：毫秒）
	trap_groundcd_item = 0, --道具陷阱施法间隔（单位：毫秒）
	trap_groundcd_buff = 0, --buff陷阱施法间隔（单位：毫秒）
	trap_groundcd_aura = 0, --光环陷阱施法间隔（单位：毫秒）
	trap_groundcd_tactic = 0, --战术技能卡陷阱施法间隔（单位：毫秒）
	
	trap_groundenemy_basic = 30000, --基础陷阱困敌时间（单位：毫秒）
	trap_groundenemy_item = 0, --道具陷阱困敌时间（单位：毫秒）
	trap_groundenemy_buff = 0, --buff陷阱困敌时间（单位：毫秒）
	trap_groundenemy_aura = 0, --光环陷阱困敌时间（单位：毫秒）
	trap_groundenemy_tactic = 0, --战术技能卡陷阱困敌时间（单位：毫秒）
	
	trap_fly_basic = 0, --基础天网时间（单位：毫秒）
	trap_fly_item = 0, --道具天网时间（单位：毫秒）
	trap_fly_buff = 0, --buff天网时间（单位：毫秒）
	trap_fly_aura = 0, --光环天网时间（单位：毫秒）
	trap_fly_tactic = 0, --战术技能卡天网时间（单位：毫秒）
	
	trap_flycd_basic = 30000, --基础天网施法间隔（单位：毫秒）
	trap_flycd_item = 0, --道具天网施法间隔（单位：毫秒）
	trap_flycd_buff = 0, --buff天网施法间隔（单位：毫秒）
	trap_flycd_aura = 0, --光环天网施法间隔（单位：毫秒）
	trap_flycd_tactic = 0, --战术技能卡天网施法间隔（单位：毫秒）
	
	trap_flyenemy_basic = 2000, --基础天网困敌时间（单位：毫秒）
	trap_flyenemy_item = 0, --道具天网困敌时间（单位：毫秒）
	trap_flyenemy_buff = 0, --buff天网困敌时间（单位：毫秒）
	trap_flyenemy_aura = 0, --光环天网困敌时间（单位：毫秒）
	trap_flyenemy_tactic = 0, --战术技能卡天网困敌时间（单位：毫秒）
	
	puzzle_basic = 0, --基础迷惑几率（去百分号后的值）
	puzzle_item = 0, --道具迷惑几率（去百分号后的值）
	puzzle_buff = 0, --buff迷惑几率（去百分号后的值）
	puzzle_aura = 0, --光环迷惑几率（去百分号后的值）
	puzzle_tactic = 0, --战术技能卡迷惑几率（去百分号后的值）
	
	weapon_crit_shoot_basic = 0, --基础射击暴击
	weapon_crit_shoot_item = 0, --道具射击暴击
	weapon_crit_shoot_buff = 0, --buff射击暴击
	weapon_crit_shoot_aura = 0, --光环射击暴击
	weapon_crit_shoot_tactic = 0, --战术技能卡射击暴击
	
	weapon_crit_frozen_basic = 0, --基础冰冻暴击
	weapon_crit_frozen_item = 0, --道具冰冻暴击
	weapon_crit_frozen_buff = 0, --buff冰冻暴击
	weapon_crit_frozen_aura = 0, --光环冰冻暴击
	weapon_crit_frozen_tactic = 0, --战术技能卡冰冻暴击
	
	weapon_crit_fire_basic = 0, --基础火焰暴击
	weapon_crit_fire_item = 0, --道具火焰暴击
	weapon_crit_fire_buff = 0, --buff火焰暴击
	weapon_crit_fire_aura = 0, --光环火焰暴击
	weapon_crit_fire_tactic = 0, --战术技能卡火焰暴击
	
	weapon_crit_equip_basic = 0, --基础装备暴击
	weapon_crit_equip_item = 0, --道具装备暴击
	weapon_crit_equip_buff = 0, --buff装备暴击
	weapon_crit_equip_aura = 0, --光环装备暴击
	weapon_crit_equip_tactic = 0, --战术技能卡装备暴击
	
	weapon_crit_hit_basic = 0, --基础击退暴击
	weapon_crit_hit_item = 0, --道具击退暴击
	weapon_crit_hit_buff = 0, --buff击退暴击
	weapon_crit_hit_aura = 0, --光环击退暴击
	weapon_crit_hit_tactic = 0, --战术技能卡击退暴击
	
	weapon_crit_blow_basic = 0, --基础吹风暴击
	weapon_crit_blow_item = 0, --道具吹风暴击
	weapon_crit_blow_buff = 0, --buff吹风暴击
	weapon_crit_blow_aura = 0, --光环吹风暴击
	weapon_crit_blow_tactic = 0, --战术技能卡吹风暴击
	
	weapon_crit_poison_basic = 0, --基础毒液暴击
	weapon_crit_poison_item = 0, --道具毒液暴击
	weapon_crit_poison_buff = 0, --buff毒液暴击
	weapon_crit_poison_aura = 0, --光环毒液暴击
	weapon_crit_poison_tactic = 0, --战术技能卡毒液暴击
	
	stun_stack = 0, --眩晕的堆叠层数
	big_stack = 0, --变大的堆叠层数
	immue_physic_stack = 0, --物理免疫的堆叠层数
	immue_magic_stack = 0, --法术免疫的堆叠层数
	immue_control_stack = 0, --免控的堆叠层数
	immue_debuff_stack = 0, --免疫负面属性效果的堆叠层数
	immue_wudi_stack = 0, --无敌的堆叠层数
	suffer_chaos_stack = 0, --混乱的堆叠层数
	suffer_blow_stack = 0, --吹风的堆叠层数
	suffer_chuanci_stack = 0, --穿刺的堆叠层数
	suffer_sleep_stack = 0, --沉睡的堆叠层数
	suffer_chenmo_stack = 0, --沉默的堆叠层数
	suffer_jinyan_stack = 0, --禁言的堆叠层数（不能普通攻击）
	space_ground_stack = 0, --变地面单位堆叠层数
	suffer_touming_stack = 0, --透明的堆叠层数（不能碰撞）
	immue_damage_stack = 0, --免疫伤害堆叠层数
	immue_damage_ice_stack = 0, --免疫冰伤害堆叠层数
	immue_damage_thunder_stack = 0, --免疫雷伤害堆叠层数
	immue_damage_fire_stack = 0, --免疫火伤害堆叠层数
	immue_damage_poison_stack = 0, --免疫毒伤害堆叠层数
	immue_damage_bullet_stack = 0, --免疫子弹伤害堆叠层数
	immue_damage_boom_stack = 0, --免疫冰爆炸害堆叠层数
	immue_damage_chuanci_stack = 0, --免疫穿刺伤害堆叠层数
	
	yinshen_state = 0, --是否是隐身状态（隐身状态的敌人不会被点击到、隐身的角色不会主动攻击别人）
	yinshen_effect = 0, --隐身特效
	
	last_attack_time = 0, --上一次普攻的时间
	
	tracingNum = 0, --追踪导弹被追踪的次数
	
	is_taunt = 0, --是否是嘲讽单位（敌人见到就打）
	taunt_need_collapse = 1, --嘲讽需要围成一圈
	taunt_radius = 0, --嘲讽半径
	
	space_type = 0, --单位的空间类型（0:地面单位 / 1:空中单位）
	atk_space_type = 0, --单位可攻击的目标空间的类型（0: 可攻击地面单位 / 1:可攻击地面单位和空中单位 / 2:可攻击空中单位）
	
	trap_ground_lasttime = 0, --陷阱上次施法的时间
	trap_fly_lasttime = 0, --天网上次施法的时间
	puzzle_lasttime = 0, --迷惑上次施法的时间
	
	atk_melee = 1, --单位是否为近战单位
	hideHpBar = 0, --是否隐藏血条
	hideLiveTimeBar = 0, --是否隐藏倒计时进度条
	tag = __DefalutTag, --tag标记
	role_sex = 0, --性别
	bullet = 0, --子弹16方向偏移表
	bulletTank = 0, --子弹16方向偏移表
	bulletEffect = 0, --子弹16方向偏移表
	
	AI_priorityList_ex = 0, --普攻AI搜集优先级表
	DamageType = 0, --普攻伤害类型
	regionIdBelong = 0, --单位所属的随机地图的小关数
	
	isInPoseAttack = 0, --是否在播放攻击动作（摇杆时不播走路动作）
	
	Trigger_OnUnitDead_SkillId = 0, --单位死后释放的技能（施法者为自己，目标为击杀者或其它人）
	Trigger_OnUnitDead_Tank_SkillId = 0, --单位死后，坦克释放的技能（施法者为坦克）
}

hVar.NB_UNIT_ATTR_SYNC_KEY = {}
for k,v in pairs(__DefaultAttr)do
	if type(v)=="number" then
		hVar.NB_UNIT_ATTR_SYNC_KEY[#hVar.NB_UNIT_ATTR_SYNC_KEY+1] = k
	end
end

--{unitId,beginNumber,maxNumber,price}
local __DefaultHire = {0,0,0,-1}
--{itemId,beginNumber,maxNumber,price}
local __DefaultSell = {0,0,0,-1}
-----------------------------------------
--初始化

local __DEBUG_meta = {
	__index = function(t,k)
		local v = rawget(t,"_T")
		if v[k]~=nil then
			return hApi.GetObjectEasy(v[k])
		end
	end,
	__newindex = function(t,k,v)
		local _t = rawget(t,"_T")
		if _t==nil then
			_t = {}
			rawset(t,"_T",_t)
		end
		if v~=nil then
			_t[k] = hApi.SetObjectEasy({},v)
		else
			_t[k] = nil
		end
	end,
}
local __DEBUG_shitch = 0
local __DEBUG_init_chaUI = function(t)
	if __DEBUG_shitch==1 then
		rawset(t,"_T",{})
		setmetatable(t,__DEBUG_meta)
	else
		--
	end
end

local __DEBUG_clear_chaUI = function(t)
	if __DEBUG_shitch==1 then
		local _t = rawget(t,"_T")
		if _t~=nil then
			for k,v in pairs(_t)do
				if v[1] and v[1]~=0 then
					if v[1].ID~=0 and v[1].__ID==v[2] then
						--xlLG("chaUI","清除chaUI"..k.."ID="..v[1].ID.."\n")
						v[1]:del()
						_t[k] = nil
					else
						xlLG("ui_error","角色身上的UI在移除前已经被删掉了,name="..tostring(k).."id="..tostring(v[1].ID).."\n")
					end
				end
			end
		end
	else
		--常规
		for k,v in pairs(t)do
			if (v ~= 0) and (v.ID) and (v.ID ~= 0) then
				v:del()
				v = nil
			end
			t[k] = nil
		end
	end
end

_hu.init = function(self, p)
	local tabU,_id = hApi.GetTableValue(hVar.tab_unit,p.id or 0)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.attr = rawget(self,"attr") or {}
	self.handle = hApi.clearTable(0,rawget(self,"handle") or {waypoint = {n=0,e=0,},sound = {},})
	self.chaUI = {}							--单位随身UI(非同步数据)	--hApi.clearTable(0,rawget(self,"chaUI"))
	self.localdata = {}						--本地专用数据,每次重新创建都会重置
	
	--检查单位id
	if self.data.id==0 or hVar.tab_unit[self.data.id]==nil then
		print("addunit error uid is not invalid:", self.data.id)
		self.data.id = 14001	--农民
	end
	
	local GridSelectMode
	local sBornAnimation
	local nBlockMode
	__DEBUG_init_chaUI(self.chaUI)
	
	if p.data and type(p.data)=="table" then
		sBornAnimation = p.data.animation
		GridSelectMode = p.data.GridSelectMode
		hApi.ReadParamWithDepth(p.data,nil,self.data,1)
	end
	
	--self.isinrect = {}
	local w = hClass.world:find(self.data.bindW)
	local mapInfo = w.data.tdMapInfo
	
	hApi.bindObjectWithParent("units", "worldI", w, self)
	--print(self.data.id, debug.traceback())
	local h = self.handle
	local d = self.data
	local a = self.attr
	
	--存储本单位在world的计数器
	w.data.__unitCounter = w.data.__unitCounter + 1
	d.__worldC = w.data.__unitCounter
	
	--单位创建的时候，身上的特效
	d.effectsOnCreate = {}
	
	d.talkTag = 0 --TD 敌人列表（用于优化）
	d.IsCovered = 0 --TD 是否标记过
	
	--zhenkira 显示属性
	if (type(tabU.color) == "table") then
		d.color = {tabU.color[1], tabU.color[2], tabU.color[3]}
		d.color_origin = {tabU.color[1], tabU.color[2], tabU.color[3]}
	else
		d.color =  {254,254,254}
		d.color_origin =  {254,254,254}
	end
	d.alpha = tabU.alpha or 254
	d.colorInRender = 0 --是否在变色中(1:正向变色/-1:反向变色/0:不变色)
	d.equipState = {}
	
	h.waypoint.n = 0
	h.waypoint.e = 0
	h.block = 0
	
	d.buffs = hApi.createObjectList()			--单位附带的buff(oAction)
	
	d.effectU = hApi.clearTable("I",d.effectU)	--单位随身特效
	d.nOperate = hVar.OPERATE_TYPE.NONE		--单位接受的下一个命令
	d.nOperateId = 0				--单位接受的下一个命令id
	d.nTarget = 0					--单位接受下一个命令的目标
	
	d.IsDead = -1					--此单位处于未进入地图的状态

	d.waveBelong = 0				--初始化所属波次
	d.growParam = 0					--生长动画参数
	d.IsHide = 0
	d.powerFrom = 0
	d.powerTo = 0
	if d.control==0 then
		d.control = d.owner
	end
	d.__control = d.control				--记录基本控制者
	
	--读取单位类型
	local name = "UNIT_"..d.id
	if hVar.tab_stringU[d.id] and hVar.tab_stringU[d.id][1] then
		name = hVar.tab_stringU[d.id][1]
	else
		if g_lua_src==1 and (tabU.type==hVar.UNIT_TYPE.UNIT or tabU.type==hVar.UNIT_TYPE.HERO) then
			_DEBUG_MSG("[tab_stringU]unit "..d.id.." have no name string!")
		end
	end
	d.type = tabU.type or 0
	if (d.name == 0) then
		d.name = name
	end
	--_DEBUG_MSG("	- createCha:	tab_unit["..d.id.."]	{"..name..","..d.gridX..","..d.gridY.."}")
	--h.name = "["..self.ID.."]"..d.name
	d.unitlevel = tabU.unitlevel or d.unitlevel

	--读取大门信息
	if tabU.IsGate==1 then
		d.IsGate = 1
	end
	--可访问单位会有这个冷却记录表
	if tabU.visit~=nil then
		d.cdtime = {}
	end
	
	--zhenkira 读取td数据
	--if tabU.isTower and tabU.isTower == 1 then
	--print("::::::::::::::::::::",self.data.id, self.data.type, hVar.UNIT_TYPE.TOWER)
	if (self.data.type == hVar.UNIT_TYPE.TOWER) or (self.data.type == hVar.UNIT_TYPE.BUILDING) or (self.data.type == hVar.UNIT_TYPE.NPC_TALK) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --geyachao: 已修改塔类型的读取方式
		self.td_upgrade = {}
		if tabU.td_upgrade then
			hApi.ReadParamWithDepth(tabU.td_upgrade,nil,self.td_upgrade,4)
		end
		
		d.allBuildCost = nil	--所有建造消耗
		d.baseTOwner = nil	--对应塔基所属位置
	elseif self.data.type == hVar.UNIT_TYPE.WAY_POINT then		--这里有特殊处理，战术技能生效的时候会将本单位生效解锁的信息复制一份给神角色。用于pvp中本势力方塔基建造时读取信息
		self.td_upgrade = {}
	end
	
	local w = self:getworld()
	self:settemptype(w.data.type)
	
	--初始化基本属性 attr
	__CODE__UnitAttrInit(self, __DefaultAttr, tabU.attr, self.attr, self.data.id, w.data.type, p.lv, p.star)
	self.data.defend_distance_max = tabU.attr and tabU.attr.atk_defend_radius or 0 --守卫半径
	self.data.IsReachedRoad = 0 --是否到过终点（防止重复调用事件）
	
	if (w:random(0, 1) == 1) then
		self.data.adjust_direction = 1
	else
		self.data.adjust_direction = -1
	end
	
	d.adjust_dx = 0 --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
	d.adjust_dy = 0 --大菠萝，有些关卡同一个怪围殴战车，为了不重叠会移动到战车周围再攻击
	
	d.defend_x_walle = 0 --瓦力守卫位置x偏移
	d.defend_y_walle = 0 --瓦力守卫的位置y
	
	--geyachao: 内存优化，寻找角色的有效目标列表，预先分配好内存，防止高频timer一直创建表
	if (h.validTargetList == nil) then
		local validTargetList = {num = 0} --角色的普通攻击有效目标列表
		h.validTargetList = validTargetList
		for i = 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTargetList[i] = {unit = 0, priority = {num = 0}, rand = 0}
		end
	else
		local validTargetList = h.validTargetList
		validTargetList.num = 0
	end
	
	--geyachao: 内存优化，寻找角色的有效嘲讽目标列表，预先分配好内存，防止高频timer一直创建表
	if (h.validTauntTargetList == nil) then
		local validTauntTargetList = {num = 0} --角色的普通攻击有效目标列表
		h.validTauntTargetList = validTauntTargetList
		for i = 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTauntTargetList[i] = {unit = 0, priority = {num = 0}, rand = 0}
		end
	else
		local validTauntTargetList = h.validTauntTargetList
		validTauntTargetList.num = 0
	end
	
	--geyachao: 内存优化，寻找角色的有效技能目标列表，预先分配好内存，防止高频timer一直创建表
	if (h.validSkillTargetList == nil) then
		local validSkillTargetList = {num = 0} --角色的普通攻击有效目标列表
		h.validSkillTargetList = validSkillTargetList
		for i = 1, hVar.ROLE_SEARCH_MAX, 1 do
			validSkillTargetList[i] = {unit = 0, priority = {num = 0}, rand = 0}
		end
	else
		local validSkillTargetList = h.validSkillTargetList
		validSkillTargetList.num = 0
	end

	--性能优化  添加事件单位列表  以便循环判断
	local tTab_EventUnit = hVar.EventUnitDefine[d.id]
	if type(tTab_EventUnit) == "table" then
		w.data.tdMapInfo.eventUnit[#w.data.tdMapInfo.eventUnit + 1] = {d.id,self,tTab_EventUnit.count}
	end
	
	d.effectsOnCreate = {} --单位创建的时候，身上的特效
	
	d.appear_wave = mapInfo.wave or 0 --TD添加该单位的波次
	--print(d.name, d.appear_wave)
	
	d.is_summon = 0 --TD是否为召唤的单位
	d.is_fenshen = 0 --TD是否为召唤的分身单位（会受到额外伤害）
	d.summon_worldC = 0 --TD召唤者唯一id
	
	d.roadPoint = 0 --TD路点
	d.lastIdleTime = -10000
	
	d.bind_unit = 0 --tank: 绑定的单位（坦克的炮口）
	d.bind_weapon = 0 --tank: 绑定的单位（坦克的机枪）
	d.bind_lamp = 0 --tank: 绑定的单位（坦克的大灯）
	d.bind_light = 0 --tank: 绑定的单位（坦克的大灯光照）
	d.bind_wheel = 0 --tank: 绑定的单位（坦克的轮子）
	d.bind_shadow = 0 --tank: 绑定的单位（坦克的影子）
	d.bind_energy = 0 --tank: 绑定的单位（坦克的能量圈）
	
	d.bind_unit_owner = 0 --tank: 绑定的单位拥有者（坦克的炮口）
	d.bind_weapon_owner = 0 --tank: 绑定的单位拥有者（坦克的机枪）
	d.bind_lamp_owner = 0 --tank: 绑定的单位拥有者（坦克的大灯）
	d.bind_light_owner = 0 --tank: 绑定的单位拥有者（坦克的大灯光照）
	d.bind_wheel_owner = 0 --tank: 绑定的单位拥有者（坦克的轮子）
	d.bind_shadow_owner = 0 --tank: 绑定的单位拥有者（坦克的影子）
	d.bind_energy_owner = 0 --tank: 绑定的单位拥有者（坦克的能量圈）
	
	d.bind_tacingeffs = {} --坦克绑定的追踪导弹特效
	
	--d.customData = {} --用户自定义数据块
	--d.customDataPivot = 0 --用户自定义数据块可用索引（自增值）
	
	--geyachao: 移动的参数挪到角色身上，为了同步
	d.MOVE_valid = false --移动是否有效（用于内存优化）
	d.MOVE_target = nil --移动到达的目标（目标模式）
	d.MOVE_target_worldC = 0 --移动到达的目标唯一id（目标模式）
	d.MOVE_radius = nil --移动到达的半径（相距一定的距离就认为移动到达）（目标模式）
	d.MOVE_pos_x = nil --移动到达的半径（目标点模式）
	d.MOVE_pos_y = nil --移动到达的半径（目标点模式）
	d.MOVE_move_speed = nil --移动速度
	d.MOVE_bBlock = nil --移动是否计算碰撞
	d.MOVE_waypoint = nil --移动的程序返回的路点集（用于优化，目标点模式只计算一次程序路点，避免重复计算）
	
	--读取载入属性
	if p.attr and type(p.attr)=="table" then
		nBlockMode = p.attr.block
		hApi.ReadParamWithDepth(p.attr,nil,self.attr,1)
	end
	--战场里面才读取这些东西
	if (w.data.type == "battlefield") or (w.data.type=="worldmap") then --geyachao: 大地图也读取
		self:loadattrBF(tabU)
		self:loadblock(nBlockMode) --提前读取障碍信息
		nBlockMode = -1 --后面就不再读取障碍了
	end
	
	local worldX, worldY = p.worldX,p.worldY
	
	--读取坐标
	if (type(worldX)=="number") and (type(worldY)=="number") then
		if p.gridX and p.gridY then
			d.gridX,d.gridY = p.gridX,p.gridY
		else
			d.gridX,d.gridY = w:xy2grid(worldX,worldY)
		end
	elseif p.gridX and p.gridY then
		worldX, worldY = w:grid2xy(d.gridX, d.gridY)
		d.worldX, d.worldY = worldX,worldY
	else
		worldX, worldY = 0, 0
	end
	
	d.atkTimes = 0 --geyachao: 新加数据 普通攻击的次数
	d.lockTarget = 0 --锁定攻击的目标 --geyachao: 新加数据
	d.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定) --geyachao: 新加数据
	
	d.castskillLastTime = 0 --geyachao: 新加数据 上一次释放技能的时间
	d.castskillStaticTime = 0 --geyachao: 新加数据 技能释放完后僵直的时间
	
	d.castskillWaitTime = 0 --geyachao: 新加数据 技能释放完后允许下次释放技能的间隔时间
	
	d.JianTouEffect = 0 --geyachao: 新加数据 移动的箭头特效
	d.AttackEffect = 0 --geyachao: 新加数据 攻击目标的箭头特效
	
	d.AI_SKILL_SEQUENCE_LIST = 0 --geyachao: 新加数据 角色在释放的技能的序列
	d.AI_SKILL_SEQUENCE_INDEX = 0 --geyachao: 新加数据 角色在释放的技能的序列id
	
	d.buff_tags = {} --geyachao: 新加数据 角色身上的buff的标记（用于效率优化）
	
	d.livetimeBegin = -1 --geyachao: 新加数据 生存时间开始值（毫秒）
	d.livetime = -1 --geyachao: 新加数据 生存时间（毫秒）
	d.livetimeMax = -1 --geyachao: 新加数据 生存时间最大值（毫秒）
	
	d.IsReachedRoad = 0 --是否到过终点（防止重复调用事件）
	
	--设置守卫点的坐标
	d.defend_x = worldX --出生的位置x
	d.defend_y = worldY --出生的位置y
	--d.defend_distance_max = -1 --最远能到达的守卫距离
	
	--（内存优化用）
	h.x = worldX
	h.y = worldY
	
	
	--self.data.area_xn = 0 --geyachao: 角色属于的区域xn（用于搜敌优化）
	--self.data.area_yn = 0 --geyachao: 角色属于的区域yn（用于搜敌优化）
	
	--geyachao: 存储区域信息（用于搜敌优化）
	w:addArea(self, worldX, worldY)
	
	--战场中需要计算多格单位站立坐标是否合法
	if w.data.type=="battlefield" and GridSelectMode~=nil then
		if GridSelectMode=="startpos" then
			if d.partID~=0 then
				--部件的话，不检测是否站立在合法格子
			else
				--普通单位检测是否站立在合法格子
				local IsWrongPos = 0
				local gx,gy = d.gridX,d.gridY
				hApi.enumNearGrid(gx,gy,self:getblock(),function(nx,ny)
					if not(w:IsSafeGrid(nx,ny)) then
						IsWrongPos = 1
					end
				end)
				--目前只有两格单位所以可以这么做
				if IsWrongPos==1 then
					local gx,gy = w:safeGrid(d.gridX,d.gridY)
					if gx~=0 then
						gx = gx-1
					end
					d.gridX = gx
					d.gridY = gy
					worldX,worldY = w:grid2xy(gx,gy)
				end
			end
		elseif type(GridSelectMode)=="table" then
			local gx,gy = w:standGridU(self,d.gridX,d.gridY,GridSelectMode.x,GridSelectMode.y)
			d.gridX = gx
			d.gridY = gy
			worldX,worldY = w:grid2xy(gx,gy)
		end
	end
	--编辑器模式下允许旋转
	if g_editor==1 then
		d.reciveFacingEvent = 1
	end
	if w.data.type=="worldmap" then
		d.reciveFacingEvent = 1
		if d.triggerID~=0 then
			local tgrData = w.data.triggerIndex[d.triggerID] 
			if type(tgrData)=="table" then
				tgrData[1] = self.ID
				--tgrData[2] = self.__ID
				tgrData[2] = self:getworldC()
			end
		end
	elseif w.data.type=="battlefield" then
		--如果是战场中的单位
		--读取自己受到英雄攻击和防御的加成
		hApi.LoadUnitBounceBF(w,self)
	end

	--注册城镇
	d.townID = 0
	if d.type==hVar.UNIT_TYPE.BUILDING and w.data.type=="worldmap" and (w.data.scenetype==0 or w.data.scenetype=="worldmap") then
		--如果该建筑是主城的话
		if tabU.map~=nil then
			local oTown = hClass.town:new({
				name = "town_"..d.id,
				map = tabU.map,
				unit = self,
			})
			d.townID = oTown.ID
			d.team = hApi.InitUnitTeam()
		end
		--世界地图才会从表格中读取出售列表
		if d.hireList==0 and tabU.interaction and type(tabU.hireList)=="table" then--and hApi.HaveValue(tabU.interaction,hVar.INTERACTION_TYPE.HIRE)
			d.hireList = hApi.ReadListParam(tabU.hireList,4)
		end
	end
	
	--注册道具
	--d.itemID = 0
	
	d.IsDead = 0	--标记为正常，已进入地图
	--这个模式下不加载模型的！
	if w.data.type=="none" then
		self.handle.removetime = 0	--记得这里把此值置成0，否则会被自动删掉
		return
	end
	local c = self:loadcha(worldX,worldY,sBornAnimation,nBlockMode)
	if c~=nil or self.handle.__manager=="DEBUG" or w.data.IsQuickBattlefield==1 then
		if a and a.hp and a.hp>=0 then
			if d.type==hVar.UNIT_TYPE.BUILDING then
				hGlobal.event:call("Event_BuildingCreated",self)
			elseif d.type==hVar.UNIT_TYPE.UNIT or d.type==hVar.UNIT_TYPE.HERO then
				hGlobal.event:call("Event_UnitCreated",self)
			elseif d.type==hVar.UNIT_TYPE.GROUP then
				if d.indexOfCreate~=0 then
					self:sethide(1)
				end
			end
		else
			--生命小于0的单位不会有单位创建事件
		end
	end
	
	--场景物件，强制设置z值为2
	if tabU and (tabU.type == hVar.UNIT_TYPE.NOT_USED) then
		xlChaSetZOrderOffset(self.handle._c, 2-worldY)
		--print(tabU and tabU.name, worldY, 2-worldY)
	end
	
	--添加单位动态障碍
	self:_addblock()
	
	--print("self.worldI", self.data.name, self.data.worldI)
	--
	--xlLG("RoadPoint", "AddUnit(), unit=" .. tostring(self.data.name) .. "_" .. tostring(self.__ID) .. ", self=" .. tostring(self) .. "\n")
end

--删除单位
--del = function(self)
_hu.destroy = function(self)
	local d = self.data
	local h = self.handle
	d.IsDestroyed = 1
	if h._c~=nil then
		_hu.__static.objIdByCha[h._c] = 0
	end
	
	--移除单位动态障碍
	self:_removeblock()
	
	self:cleardata()
	hApi.unbindObjectWithParent("units","worldI",hClass.world:find(d.bindW),self)
	h.removetime = 0
	hApi.ObjectReleaseSprite(h)
	
	--xlLG("RoadPoint", "destroy(), unit=" .. tostring(self.data.name) .. "_" .. tostring(self.__ID) .. "\n")
	
	--geyachao: 删除角色，移除单位所在的搜敌格子信息（用于内存优化）
	local oWorld = self:getworld()
	local mapInfo = oWorld.data.tdMapInfo
	
	d.__worldC = 0 --单位在世界的创建计数
	
	d.appear_wave = 0 --TD添加该单位的波次
	
	d.is_summon = 0 --TD是否为召唤的单位
	d.is_fenshen = 0 --TD是否为召唤的分身单位（会受到额外伤害）
	d.summon_worldC = 0 --TD召唤者唯一id
	
	d.roadPoint = 0 --TD是否为召唤的单位
	
	d.buff_tags = {} --geyachao: 新加数据 角色身上的buff的标记（用于效率优化）
	
	--geyachao: 标记移动无效
	d.MOVE_valid = false --移动是否有效（用于内存优化）
	
	--geyachao: 存储区域信息（用于搜敌优化）
	oWorld:removeArea(self)
	
	--移除主角
	--大菠萝
	if oWorld.data.rpgunits[self] then
		oWorld.data.rpgunits[self] = nil
	end
	
	--移除事件
	if (type(mapInfo) == "table") then
		if (type(mapInfo.eventUnit) == "table") then
			for i = 1,#mapInfo.eventUnit do
				local tInfo = mapInfo.eventUnit[i]
				local nId = tInfo[1]		--单位ID
				local oUnit = tInfo[2]		--单位
				local nCount = tInfo[3]		--剩余触发次数
				if (oUnit == self) then --找到了
					table.remove(mapInfo.eventUnit, i)
					--print("移除事件", oUnit.data.name, nId)
					break
				end
			end
		end
	end
	
	--tank: 删除坦克的身体，同时也删除坦克炮口
	if (d.bind_unit ~= 0) then
		d.bind_unit:del()
		d.bind_unit = 0
	end
	
	--tank: 删除坦克的身体，同时也删除坦克机枪
	if (d.bind_weapon ~= 0) then
		d.bind_weapon:del()
		d.bind_weapon = 0
	end
	
	--tank: 删除坦克的身体，同时也删除坦克大灯
	if (d.bind_lamp ~= 0) then
		d.bind_lamp:del()
		d.bind_lamp = 0
	end

	--tank: 删除坦克的身体，同时也删除坦克大灯光照
	if (d.bind_light ~= 0) then
		d.bind_light:del()
		d.bind_light = 0
	end
	
	--tank: 删除坦克的身体，同时也删除坦克轮子
	if (d.bind_wheel ~= 0) then
		d.bind_wheel:del()
		d.bind_wheel = 0
	end
	
	--tank: 删除坦克的身体，同时也删除坦克影子
	if (d.bind_shadow ~= 0) then
		d.bind_shadow:del()
		d.bind_shadow = 0
	end
	
	--tank: 删除坦克的身体，同时也删除坦克能量圈
	if (d.bind_energy ~= 0) then
		d.bind_energy:del()
		d.bind_energy = 0
	end
	
	d.bind_unit_owner = 0 --tank_: 绑定的单位拥有者（坦克的炮口）
	d.bind_weapon_owner = 0 --tank: 绑定的单位拥有者（坦克的机枪）
	d.bind_lamp_owner = 0 --tank: 绑定的单位拥有者（坦克的大灯）
	d.bind_light_owner = 0 --tank: 绑定的单位拥有者（坦克的大灯光照）
	d.bind_wheel_owner = 0 --tank: 绑定的单位拥有者（坦克的轮子）
	d.bind_shadow_owner = 0 --tank: 绑定的单位拥有者（坦克的影子）
	d.bind_energy_owner = 0 --tank: 绑定的单位拥有者（坦克的能量圈）
	
	d.bind_tacingeffs = {} --坦克绑定的追踪导弹特效
	
	--d.customData = {} --用户自定义数据块
	--d.customDataPivot = 0 --用户自定义数据块可用索引（自增值）
	
	local unitType = hVar.tab_unit[self.data.id].type
	if (unitType == hVar.UNIT_TYPE.UNIT) then
		--地图内单位的数量
		oWorld.data.unit_num = oWorld.data.unit_num - 1
		--print("-- unit_num=", oWorld.data.unit_num)
	end
end

--添加单位动态障碍
_hu._addblock = function(self)
	local world = self:getworld()
	local unitId = self.data.id
	if (unitId > 0) then
		--只处理可破坏物件、可破坏房子
		if (self.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
		or (self.data.type == hVar.UNIT_TYPE.UNITDOOR) then --UNITBROKEN, UNITBROKEN_HOUSE, UNITDOOR
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			
			local tabU = hVar.tab_unit[unitId]
			local box = tabU.box2 or tabU.box
			--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
			local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			for xi = eu_xl + hVar.ROLE_COLLISION_EDGE, eu_xr, hVar.ROLE_COLLISION_EDGE / 2 do
				for yi = eu_yl + hVar.ROLE_COLLISION_EDGE, eu_yr, hVar.ROLE_COLLISION_EDGE / 2 do
					local gx = math.floor(xi / hVar.ROLE_COLLISION_EDGE) - 1
					local gy = math.floor(yi / hVar.ROLE_COLLISION_EDGE) - 1
					--设置障碍
					xlScene_SetMapBlock(gx, gy, 1)
				end
			end
			
			--[[
			--标记是我方单位（用于搜敌优化）
			--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
			world.data.rpgunits[self] = self:getworldC()
			]]
		end
		
		--只处理矮墙
		if (self.data.type == hVar.UNIT_TYPE.UNITWALL) then
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			
			local tabU = hVar.tab_unit[unitId]
			local box_dynamic = tabU.box_dynamic
			if box_dynamic then
				for bx = 1, #box_dynamic, 1 do
					local box = box_dynamic[bx]
					--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
					local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
					--print(eu_bx, eu_by, eu_bw, eu_bh)
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
					local eu_xl = eu_center_x - eu_bw / 2
					local eu_xr = eu_center_x + eu_bw / 2
					local eu_yl = eu_center_y - eu_bh / 2
					local eu_yr = eu_center_y + eu_bh / 2
					for xi = eu_xl + hVar.ROLE_COLLISION_EDGE, eu_xr, hVar.ROLE_COLLISION_EDGE / 2 do
						for yi = eu_yl + hVar.ROLE_COLLISION_EDGE, eu_yr, hVar.ROLE_COLLISION_EDGE / 2 do
							local gx = math.floor(xi / hVar.ROLE_COLLISION_EDGE) - 1
							local gy = math.floor(yi / hVar.ROLE_COLLISION_EDGE) - 1
							--设置障碍
							xlScene_SetMapBlock(gx, gy, 1)
							--print("设置障碍", gx, gy)
							
							local key = tostring(gx) .. "_" .. tostring(gy)
							world.data.box_dynamic_points[key] = true
						end
					end
				end
			end
		end
	end
end

--删除单位动态障碍
_hu._removeblock = function(self)
	local world = self:getworld()
	local unitId = self.data.id
	if (unitId > 0) then
		--只处理可破坏物件、可破坏房子
		if (self.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
		or (self.data.type == hVar.UNIT_TYPE.UNITDOOR) then --UNITBROKEN, UNITBROKEN_HOUSE, UNITDOOR
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			local tabU = hVar.tab_unit[unitId]
			local box = tabU.box2 or tabU.box
			--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
			local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			for xi = eu_xl + hVar.ROLE_COLLISION_EDGE, eu_xr, hVar.ROLE_COLLISION_EDGE / 2 do
				for yi = eu_yl + hVar.ROLE_COLLISION_EDGE, eu_yr, hVar.ROLE_COLLISION_EDGE / 2 do
					local gx = math.floor(xi / hVar.ROLE_COLLISION_EDGE) - 1
					local gy = math.floor(yi / hVar.ROLE_COLLISION_EDGE) - 1
					--取消障碍
					xlScene_SetMapBlock(gx, gy, 0)
				end
			end
			
			--标记不是我方单位（用于搜敌优化）
			world.data.rpgunits[self] = nil
		end
		
		--只处理矮墙
		if (self.data.type == hVar.UNIT_TYPE.UNITWALL) then
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			local tabU = hVar.tab_unit[unitId]
			local box_dynamic = tabU.box_dynamic
			if box_dynamic then
				for bx = 1, #box_dynamic, 1 do
					local box = box_dynamic[bx]
					--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
					local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
					local eu_xl = eu_center_x - eu_bw / 2
					local eu_xr = eu_center_x + eu_bw / 2
					local eu_yl = eu_center_y - eu_bh / 2
					local eu_yr = eu_center_y + eu_bh / 2
					for xi = eu_xl + hVar.ROLE_COLLISION_EDGE, eu_xr, hVar.ROLE_COLLISION_EDGE / 2 do
						for yi = eu_yl + hVar.ROLE_COLLISION_EDGE, eu_yr, hVar.ROLE_COLLISION_EDGE / 2 do
							local gx = math.floor(xi / hVar.ROLE_COLLISION_EDGE) - 1
							local gy = math.floor(yi / hVar.ROLE_COLLISION_EDGE) - 1
							--取消障碍
							xlScene_SetMapBlock(gx, gy, 0)
							
							local key = tostring(gx) .. "_" .. tostring(gy)
							world.data.box_dynamic_points[key] = nil
						end
					end
				end
			end
		end
	end
end


--生成随机可破坏物件的四周物件
_hu._addBlockArount = function(self)
	local world = self:getworld()
	local unitId = self.data.id
	
	if (unitId > 0) then
		--只处理可破坏物件、可破坏房子
		if (self.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --UNITBROKEN, UNITBROKEN_HOUSE
			if (unitId == hVar.UNITBROKEN_STONE_GOLD_ID) then --4宫格
				self:__addBlockArount4()
			else --9宫格
				self:__addBlockArount9()
			end
		end
	end
end

--生成随机可破坏物件的四周物件(4宫格)
_hu.__addBlockArount4 = function(self)
	local world = self:getworld()
	local unitId = self.data.id
	
	if (unitId > 0) then
		--只处理可破坏物件、可破坏房子
		if (self.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --UNITBROKEN, UNITBROKEN_HOUSE
			--可破坏物件有几率变别的单位
			if (unitId == hVar.UNITBROKEN_STONE_GOLD_ID) then
				unitId = hVar.UNITBROKEN_STONE_ORINGIN_ID
			end
			
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			
			local tabU = hVar.tab_unit[unitId]
			local box = tabU.box2 or tabU.box
			--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
			local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			
			local facing = self.data.facing
			local owner = self.data.owner
			
			--是否往左生成1个
			local bGenerateLeft = (hApi.random(0, 1) == 1)
			--print("random bGenerateLeft =", bGenerateLeft)
			--检测左侧是否是障碍
			if bGenerateLeft then
				local left_x = eu_x - eu_bw
				local left_y = eu_y
				local result = xlScene_IsGridBlock(g_world, left_x / 24, left_y / 24) --某个坐标是否是障碍
				--print(bGenerateLeft, result)
				if (result == 1) or (hApi.IsPosInWater(left_x, left_y) == 1) then
					bGenerateLeft = false
				end
				
				--添加左侧障碍
				if bGenerateLeft then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					world:addunit(unitId_add, owner, nil, nil, facing, left_x, left_y)
				end
			end
			
			--是否往右生成1个
			local bGenerateRight = (hApi.random(0, 1) == 1)
			--左边生成了右边就不会有
			if bGenerateLeft then
				bGenerateRight = false
			end
			--print("random bGenerateRight =", bGenerateRight)
			--检测左侧是否是障碍
			if bGenerateRight then
				local right_x = eu_x + eu_bw
				local right_y = eu_y
				local result = xlScene_IsGridBlock(g_world, right_x / 24, right_y / 24) --某个坐标是否是障碍
				--print(bGenerateRight, result)
				if (result == 1) or (hApi.IsPosInWater(right_x, right_y) == 1) then
					bGenerateRight = false
				end
				
				--添加右侧障碍
				if bGenerateRight then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					world:addunit(unitId_add, owner, nil, nil, facing, right_x, right_y)
				end
			end
			
			--是否往上生成1个
			local bGenerateUp = (hApi.random(0, 1) == 1)
			--print("random bGenerateUp =", bGenerateUp)
			--检测上侧是否是障碍
			if bGenerateUp then
				local up_x = eu_x
				local up_y = eu_y - eu_bh
				local result = xlScene_IsGridBlock(g_world, up_x / 24, up_y / 24) --某个坐标是否是障碍
				--print(bGenerateUp, result)
				if (result == 1) or (hApi.IsPosInWater(up_x, up_y) == 1) then
					bGenerateUp = false
				end
				
				--添加上侧障碍
				if bGenerateUp then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					world:addunit(unitId_add, owner, nil, nil, facing, up_x, up_y)
				end
			end
			
			--是否往下生成1个
			local bGenerateDown = (hApi.random(0, 1) == 1)
			--上边生成了下边就不会有
			if bGenerateUp then
				bGenerateDown = false
			end
			--print("random bGenerateDown =", bGenerateDown)
			--检测下侧是否是障碍
			if bGenerateDown then
				local down_x = eu_x
				local down_y = eu_y + eu_bh
				local result = xlScene_IsGridBlock(g_world, down_x / 24, down_y / 24) --某个坐标是否是障碍
				--print(bGenerateDown, result)
				if (result == 1) or (hApi.IsPosInWater(down_x, down_y) == 1) then
					bGenerateDown = false
				end
				
				--添加下侧障碍
				if bGenerateDown then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					world:addunit(unitId_add, owner, nil, nil, facing, down_x, down_y)
				end
			end
			
			--左上
			if bGenerateLeft and bGenerateUp then
				if (hApi.random(0, 1) == 1) then
					local leftup_x = eu_x - eu_bw
					local leftup_y = eu_y - eu_bh
					local result = xlScene_IsGridBlock(g_world, leftup_x / 24, leftup_y / 24) --某个坐标是否是障碍
					--print("左上", result)
					if (result == 1) or (hApi.IsPosInWater(leftup_x, leftup_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						world:addunit(unitId_add, owner, nil, nil, facing, leftup_x, leftup_y)
					end
				end
			end
			
			--左下
			if bGenerateLeft and bGenerateDown then
				if (hApi.random(0, 1) == 1) then
					local leftdown_x = eu_x - eu_bw
					local leftdown_y = eu_y + eu_bh
					local result = xlScene_IsGridBlock(g_world, leftdown_x / 24, leftdown_y / 24) --某个坐标是否是障碍
					--print("左下", result)
					if (result == 1) or (hApi.IsPosInWater(leftdown_x, leftdown_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						world:addunit(unitId_add, owner, nil, nil, facing, leftdown_x, leftdown_y)
					end
				end
			end
			
			--右上
			if bGenerateRight and bGenerateUp then
				if (hApi.random(0, 1) == 1) then
					local rightup_x = eu_x + eu_bw
					local rightup_y = eu_y - eu_bh
					local result = xlScene_IsGridBlock(g_world, rightup_x / 24, rightup_y / 24) --某个坐标是否是障碍
					--print("右上", result)
					if (result == 1) or (hApi.IsPosInWater(rightup_x, rightup_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						world:addunit(unitId_add, owner, nil, nil, facing, rightup_x, rightup_y)
					end
				end
			end
			
			--右下
			if bGenerateRight and bGenerateDown then
				if (hApi.random(0, 1) == 1) then
					local rightdown_x = eu_x + eu_bw
					local rightdown_y = eu_y + eu_bh
					local result = xlScene_IsGridBlock(g_world, rightdown_x / 24, rightdown_y / 24) --某个坐标是否是障碍
					--print("右下", result)
					if (result == 1) or (hApi.IsPosInWater(rightdown_x, rightdown_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						world:addunit(unitId_add, owner, nil, nil, facing, rightdown_x, rightdown_y)
					end
				end
			end
		end
	end
end

--生成随机可破坏物件的四周物件(9宫格)
_hu.__addBlockArount9 = function(self)
	local world = self:getworld()
	local unitId = self.data.id
	
	if (unitId > 0) then
		--只处理可破坏物件、可破坏房子
		if (self.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (self.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --UNITBROKEN, UNITBROKEN_HOUSE
			local bChanged = false
			--可破坏物件有几率变别的单位
			if (unitId == hVar.UNITBROKEN_STONE_CHANGETO_ID) then
				unitId = hVar.UNITBROKEN_STONE_ORINGIN_ID
				bChanged = true
			end
			
			local eu_x, eu_y = hApi.chaGetPos(self.handle)
			
			local tabU = hVar.tab_unit[unitId]
			local box = tabU.box2 or tabU.box
			--local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
			local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			
			local facing = self.data.facing
			local owner = self.data.owner
			
			--是否往左生成1个
			local bGenerateLeft = (hApi.random(0, 1) == 1)
			--print("random bGenerateLeft =", bGenerateLeft)
			--检测左侧是否是障碍
			if bGenerateLeft then
				local left_x = eu_x - eu_bw
				local left_y = eu_y
				local result = xlScene_IsGridBlock(g_world, left_x / 24, left_y / 24) --某个坐标是否是障碍
				--print(bGenerateLeft, result)
				if (result == 1) or (hApi.IsPosInWater(left_x, left_y) == 1) then
					bGenerateLeft = false
				end
				
				--添加左侧障碍
				if bGenerateLeft then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					if (not bChanged) then
						if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
							local r = hApi.random(1, 100)
							if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
								unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
								bChanged = true
							end
						end
					end
					world:addunit(unitId_add, owner, nil, nil, facing, left_x, left_y)
				end
			end
			
			--是否往右生成1个
			local bGenerateRight = (hApi.random(0, 1) == 1)
			--print("random bGenerateRight =", bGenerateRight)
			--检测左侧是否是障碍
			if bGenerateRight then
				local right_x = eu_x + eu_bw
				local right_y = eu_y
				local result = xlScene_IsGridBlock(g_world, right_x / 24, right_y / 24) --某个坐标是否是障碍
				--print(bGenerateRight, result)
				if (result == 1) or (hApi.IsPosInWater(right_x, right_y) == 1) then
					bGenerateRight = false
				end
				
				--添加右侧障碍
				if bGenerateRight then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					if (not bChanged) then
						if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
							local r = hApi.random(1, 100)
							if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
								unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
								bChanged = true
							end
						end
					end
					world:addunit(unitId_add, owner, nil, nil, facing, right_x, right_y)
				end
			end
			
			--是否往上生成1个
			local bGenerateUp = (hApi.random(0, 1) == 1)
			--print("random bGenerateUp =", bGenerateUp)
			--检测上侧是否是障碍
			if bGenerateUp then
				local up_x = eu_x
				local up_y = eu_y - eu_bh
				local result = xlScene_IsGridBlock(g_world, up_x / 24, up_y / 24) --某个坐标是否是障碍
				--print(bGenerateUp, result)
				if (result == 1) or (hApi.IsPosInWater(up_x, up_y) == 1) then
					bGenerateUp = false
				end
				
				--添加上侧障碍
				if bGenerateUp then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					if (not bChanged) then
						if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
							local r = hApi.random(1, 100)
							if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
								unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
								bChanged = true
							end
						end
					end
					world:addunit(unitId_add, owner, nil, nil, facing, up_x, up_y)
				end
			end
			
			--是否往下生成1个
			local bGenerateDown = (hApi.random(0, 1) == 1)
			--print("random bGenerateDown =", bGenerateDown)
			--检测下侧是否是障碍
			if bGenerateDown then
				local down_x = eu_x
				local down_y = eu_y + eu_bh
				local result = xlScene_IsGridBlock(g_world, down_x / 24, down_y / 24) --某个坐标是否是障碍
				--print(bGenerateDown, result)
				if (result == 1) or (hApi.IsPosInWater(down_x, down_y) == 1) then
					bGenerateDown = false
				end
				
				--添加下侧障碍
				if bGenerateDown then
					--可破坏物件有几率变别的单位
					local unitId_add = unitId
					if (not bChanged) then
						if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
							local r = hApi.random(1, 100)
							if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
								unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
								bChanged = true
							end
						end
					end
					world:addunit(unitId_add, owner, nil, nil, facing, down_x, down_y)
				end
			end
			
			--左上
			if bGenerateLeft and bGenerateUp then
				if (hApi.random(0, 1) == 1) then
					local leftup_x = eu_x - eu_bw
					local leftup_y = eu_y - eu_bh
					local result = xlScene_IsGridBlock(g_world, leftup_x / 24, leftup_y / 24) --某个坐标是否是障碍
					--print("左上", result)
					if (result == 1) or (hApi.IsPosInWater(leftup_x, leftup_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						if (not bChanged) then
							if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
								local r = hApi.random(1, 100)
								if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
									unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
									bChanged = true
								end
							end
						end
						world:addunit(unitId_add, owner, nil, nil, facing, leftup_x, leftup_y)
					end
				end
			end
			
			--左下
			if bGenerateLeft and bGenerateDown then
				if (hApi.random(0, 1) == 1) then
					local leftdown_x = eu_x - eu_bw
					local leftdown_y = eu_y + eu_bh
					local result = xlScene_IsGridBlock(g_world, leftdown_x / 24, leftdown_y / 24) --某个坐标是否是障碍
					--print("左下", result)
					if (result == 1) or (hApi.IsPosInWater(leftdown_x, leftdown_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						if (not bChanged) then
							if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
								local r = hApi.random(1, 100)
								if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
									unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
									bChanged = true
								end
							end
						end
						world:addunit(unitId_add, owner, nil, nil, facing, leftdown_x, leftdown_y)
					end
				end
			end
			
			--右上
			if bGenerateRight and bGenerateUp then
				if (hApi.random(0, 1) == 1) then
					local rightup_x = eu_x + eu_bw
					local rightup_y = eu_y - eu_bh
					local result = xlScene_IsGridBlock(g_world, rightup_x / 24, rightup_y / 24) --某个坐标是否是障碍
					--print("右上", result)
					if (result == 1) or (hApi.IsPosInWater(rightup_x, rightup_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						if (not bChanged) then
							if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
								local r = hApi.random(1, 100)
								if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
									unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
									bChanged = true
								end
							end
						end
						world:addunit(unitId_add, owner, nil, nil, facing, rightup_x, rightup_y)
					end
				end
			end
			
			--右下
			if bGenerateRight and bGenerateDown then
				if (hApi.random(0, 1) == 1) then
					local rightdown_x = eu_x + eu_bw
					local rightdown_y = eu_y + eu_bh
					local result = xlScene_IsGridBlock(g_world, rightdown_x / 24, rightdown_y / 24) --某个坐标是否是障碍
					--print("右下", result)
					if (result == 1) or (hApi.IsPosInWater(rightdown_x, rightdown_y) == 0) then
						--可破坏物件有几率变别的单位
						local unitId_add = unitId
						if (not bChanged) then
							if (unitId_add == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
								local r = hApi.random(1, 100)
								if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
									unitId_add = hVar.UNITBROKEN_STONE_CHANGETO_ID
									bChanged = true
								end
							end
						end
						world:addunit(unitId_add, owner, nil, nil, facing, rightdown_x, rightdown_y)
					end
				end
			end
		end
	end
end

--取角色的worldI（用于同步，索引会被复用）
_hu.getworldI = function(self)
	return self.data.worldI
end

--取角色的worldC（用于校验角色是否是原来的，索引自增，不会重复）
_hu.getworldC = function(self)
	return self.data.__worldC
end

--通过worldI取角色
hClass.unit.getChaByWorldI = function(_self, worldI)
	return hApi.getObjectFromBind(hClass.unit, "units", "worldI", hGlobal.WORLD.LastWorldMap, worldI)
end

--geyachao: 接口
--获得角色最大血量
_hu.GetHpMax = function(self)
	local attr = self.attr --属性表
	
	local hp_max_basic = attr.hp_max_basic --基础血量
	local hp_max_item = attr.hp_max_item --道具附加血量
	local hp_max_buff = attr.hp_max_buff --buff附加血量
	local hp_max_aura = attr.hp_max_aura --光环附加血量
	local hp_max_tactic = attr.hp_max_tactic --战术技能卡血量
	
	local hp_max = hp_max_basic + hp_max_item + hp_max_buff + hp_max_aura + hp_max_tactic
	return hp_max
end

--geyachao: 接口
--获得角色攻击力
_hu.GetAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_basic = attr.atk_basic --基础攻击力
	local atk_item = attr.atk_item --道具附加攻击力
	local atk_buff = attr.atk_buff --buff附加攻击力
	local atk_aura = attr.atk_aura --光环附加攻击力
	local atk_tactic = attr.atk_tactic --战术技能卡附加攻击力
	
	local atk = atk_basic + atk_item + atk_buff + atk_aura + atk_tactic
	return atk
end

--geyachao: 接口
--获得角色冰攻击力
_hu.GetIceAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_ice_basic = attr.atk_ice_basic --基础冰攻击力
	local atk_ice_item = attr.atk_ice_item --道具附加冰攻击力
	local atk_ice_buff = attr.atk_ice_buff --buff附加冰攻击力
	local atk_ice_aura = attr.atk_ice_aura --光环附加冰攻击力
	local atk_ice_tactic = attr.atk_ice_tactic --战术技能卡附加冰攻击力
	
	local atk_ice = atk_ice_basic + atk_ice_item + atk_ice_buff + atk_ice_aura + atk_ice_tactic
	atk_ice = atk_ice + attr.atk_basic --附加基础攻击力
	
	return atk_ice
end

--geyachao: 接口
--获得角色雷攻击力
_hu.GetThunderAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_thunder_basic = attr.atk_thunder_basic --基础雷攻击力
	local atk_thunder_item = attr.atk_thunder_item --道具附加雷攻击力
	local atk_thunder_buff = attr.atk_thunder_buff --buff附加雷攻击力
	local atk_thunder_aura = attr.atk_thunder_aura --光环附加雷攻击力
	local atk_thunder_tactic = attr.atk_thunder_tactic --战术技能卡附加雷攻击力
	
	local atk_thunder = atk_thunder_basic + atk_thunder_item + atk_thunder_buff + atk_thunder_aura + atk_thunder_tactic
	atk_thunder = atk_thunder + attr.atk_basic --附加基础攻击力
	
	return atk_thunder
end

--geyachao: 接口
--获得角色火攻击力
_hu.GetFireAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_fire_basic = attr.atk_fire_basic --基础冰攻击力
	local atk_fire_item = attr.atk_fire_item --道具附加冰攻击力
	local atk_fire_buff = attr.atk_fire_buff --buff附加冰攻击力
	local atk_fire_aura = attr.atk_fire_aura --光环附加冰攻击力
	local atk_fire_tactic = attr.atk_fire_tactic --战术技能卡附加冰攻击力
	
	local atk_fire = atk_fire_basic + atk_fire_item + atk_fire_buff + atk_fire_aura + atk_fire_tactic
	atk_fire = atk_fire + attr.atk_basic --附加基础攻击力
	
	return atk_fire
end

--geyachao: 接口
--获得角色毒攻击力
_hu.GetPoisonAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_poison_basic = attr.atk_poison_basic --基础毒攻击力
	local atk_poison_item = attr.atk_poison_item --道具附加毒攻击力
	local atk_poison_buff = attr.atk_poison_buff --buff附加毒攻击力
	local atk_poison_aura = attr.atk_poison_aura --光环附加毒攻击力
	local atk_poison_tactic = attr.atk_poison_tactic --战术技能卡附加毒攻击力
	
	local atk_poison = atk_poison_basic + atk_poison_item + atk_poison_buff + atk_poison_aura + atk_poison_tactic
	atk_poison = atk_poison + attr.atk_basic --附加基础攻击力
	
	return atk_poison
end

--geyachao: 接口
--获得角色子弹攻击力
_hu.GetBulletAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_bullet_basic = attr.atk_bullet_basic --基础子弹攻击力
	local atk_bullet_item = attr.atk_bullet_item --道具附加子弹攻击力
	local atk_bullet_buff = attr.atk_bullet_buff --buff附加子弹攻击力
	local atk_bullet_aura = attr.atk_bullet_aura --光环附加子弹攻击力
	local atk_bullet_tactic = attr.atk_bullet_tactic --战术技能卡附加子弹攻击力
	
	local atk_bullet = atk_bullet_basic + atk_bullet_item + atk_bullet_buff + atk_bullet_aura + atk_bullet_tactic
	--atk_bullet = atk_bullet + attr.atk_basic --附加基础攻击力
	
	return atk_bullet
end

--geyachao: 接口
--获得角色爆炸攻击力
_hu.GetBombAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_bomb_basic = attr.atk_bomb_basic --基础爆炸攻击力
	local atk_bomb_item = attr.atk_bomb_item --道具附加爆炸攻击力
	local atk_bomb_buff = attr.atk_bomb_buff --buff附加爆炸攻击力
	local atk_bomb_aura = attr.atk_bomb_aura --光环附加爆炸攻击力
	local atk_bomb_tactic = attr.atk_bomb_tactic --战术技能卡附加爆炸攻击力
	
	local atk_bomb = atk_bomb_basic + atk_bomb_item + atk_bomb_buff + atk_bomb_aura + atk_bomb_tactic
	atk_bomb = atk_bomb + attr.atk_basic --附加基础攻击力
	
	return atk_bomb
end

--geyachao: 接口
--获得角色穿刺攻击力
_hu.GetChuanciAtk = function(self)
	local attr = self.attr --属性表
	
	local atk_chuanci_basic = attr.atk_chuanci_basic --基础穿刺攻击力
	local atk_chuanci_item = attr.atk_chuanci_item --道具附加穿刺攻击力
	local atk_chuanci_buff = attr.atk_chuanci_buff --buff附加穿刺攻击力
	local atk_chuanci_aura = attr.atk_chuanci_aura --光环附加穿刺攻击力
	local atk_chuanci_tactic = attr.atk_chuanci_tactic --战术技能卡附加穿刺攻击力
	
	local atk_chuanci = atk_chuanci_basic + atk_chuanci_item + atk_chuanci_buff + atk_chuanci_aura + atk_chuanci_tactic
	atk_chuanci = atk_chuanci + attr.atk_basic --附加基础攻击力
	
	return atk_chuanci
end

--geyachao: 接口
--获得角色物防
_hu.GetPhysicDef = function(self)
	local attr = self.attr --属性表
	
	local def_physic_basic = attr.def_physic_basic --基础物防
	local def_physic_item =  attr.def_physic_item --道具附加物防
	local def_physic_buff = attr.def_physic_buff --buff附加物防
	local def_physic_aura = attr.def_physic_aura --光环附加物防
	local def_physic_tactic = attr.def_physic_tactic --战术技能卡附加物防
	
	local def_physic = def_physic_basic + def_physic_item + def_physic_buff + def_physic_aura + def_physic_tactic
	return def_physic
end

--geyachao: 接口
--获得角色法防
_hu.GetMagicDef = function(self)
	local attr = self.attr --属性表
	
	local def_magic_basic = attr.def_magic_basic --基础法防
	local def_magic_item = attr.def_magic_item --道具附加法防
	local def_magic_buff = attr.def_magic_buff --buff附加法防
	local def_magic_aura = attr.def_magic_aura --光环附加法防
	local def_magic_tactic = attr.def_magic_tactic --战术技能卡附加法防
	
	local def_magic = def_magic_basic + def_magic_item + def_magic_buff + def_magic_aura + def_magic_tactic
	return def_magic
end

--geyachao: 接口
--获得角色冰防御
_hu.GetIceDef = function(self)
	local attr = self.attr --属性表
	
	local def_ice_basic = attr.def_ice_basic --基础冰防御
	local def_ice_item = attr.def_ice_item --道具附加冰防御
	local def_ice_buff = attr.def_ice_buff --buff附加冰防御
	local def_ice_aura = attr.def_ice_aura --光环附加冰防御
	local def_ice_tactic = attr.def_ice_tactic --战术技能卡附加冰防御
	
	local def_ice = def_ice_basic + def_ice_item + def_ice_buff + def_ice_aura + def_ice_tactic
	return def_ice
end

--geyachao: 接口
--获得角色雷防御
_hu.GetThunderDef = function(self)
	local attr = self.attr --属性表
	
	local def_thunder_basic = attr.def_thunder_basic --基础雷防御
	local def_thunder_item = attr.def_thunder_item --道具附加雷防御
	local def_thunder_buff = attr.def_thunder_buff --buff附加雷防御
	local def_thunder_aura = attr.def_thunder_aura --光环附加雷防御
	local def_thunder_tactic = attr.def_thunder_tactic --战术技能卡附加雷防御
	
	local def_thunder = def_thunder_basic + def_thunder_item + def_thunder_buff + def_thunder_aura + def_thunder_tactic
	return def_thunder
end

--geyachao: 接口
--获得角色火防御
_hu.GetFireDef = function(self)
	local attr = self.attr --属性表
	
	local def_fire_basic = attr.def_fire_basic --基础火防御
	local def_fire_item = attr.def_fire_item --道具附加火防御
	local def_fire_buff = attr.def_fire_buff --buff附加火防御
	local def_fire_aura = attr.def_fire_aura --光环附加火防御
	local def_fire_tactic = attr.def_fire_tactic --战术技能卡附加火防御
	
	local def_fire = def_fire_basic + def_fire_item + def_fire_buff + def_fire_aura + def_fire_tactic
	return def_fire
end

--geyachao: 接口
--获得角色毒防御
_hu.GetPoisonDef = function(self)
	local attr = self.attr --属性表
	
	local def_poison_basic = attr.def_poison_basic --基础毒防御
	local def_poison_item = attr.def_poison_item --道具附加毒防御
	local def_poison_buff = attr.def_poison_buff --buff附加毒防御
	local def_poison_aura = attr.def_poison_aura --光环附加毒防御
	local def_poison_tactic = attr.def_poison_tactic --战术技能卡附加毒防御
	
	local def_poison = def_poison_basic + def_poison_item + def_poison_buff + def_poison_aura + def_poison_tactic
	return def_poison
end

--geyachao: 接口
--获得角色子弹防御
_hu.GetBulletDef = function(self)
	local attr = self.attr --属性表
	
	local def_bullet_basic = attr.def_bullet_basic --基础子弹防御
	local def_bullet_item = attr.def_bullet_item --道具附加子弹防御
	local def_bullet_buff = attr.def_bullet_buff --buff附加子弹防御
	local def_bullet_aura = attr.def_bullet_aura --光环附加子弹防御
	local def_bullet_tactic = attr.def_bullet_tactic --战术技能卡附加子弹防御
	
	local def_bullet = def_bullet_basic + def_bullet_item + def_bullet_buff + def_bullet_aura + def_bullet_tactic
	return def_bullet
end

--geyachao: 接口
--获得角色爆炸防御
_hu.GetBombDef = function(self)
	local attr = self.attr --属性表
	
	local def_bomb_basic = attr.def_bomb_basic --基础爆炸防御
	local def_bomb_item = attr.def_bomb_item --道具附加爆炸防御
	local def_bomb_buff = attr.def_bomb_buff --buff附加爆炸防御
	local def_bomb_aura = attr.def_bomb_aura --光环附加爆炸防御
	local def_bomb_tactic = attr.def_bomb_tactic --战术技能卡附加爆炸防御
	
	local def_bomb = def_bomb_basic + def_bomb_item + def_bomb_buff + def_bomb_aura + def_bomb_tactic
	return def_bomb
end

--geyachao: 接口
--获得角色穿刺防御
_hu.GetChuanciDef = function(self)
	local attr = self.attr --属性表
	
	local def_chuanci_basic = attr.def_chuanci_basic --基础穿刺防御
	local def_chuanci_item = attr.def_chuanci_item --道具附加穿刺防御
	local def_chuanci_buff = attr.def_chuanci_buff --buff附加穿刺防御
	local def_chuanci_aura = attr.def_chuanci_aura --光环附加穿刺防御
	local def_chuanci_tactic = attr.def_chuanci_tactic --战术技能卡附加穿刺防御
	
	local def_chuanci = def_chuanci_basic + def_chuanci_item + def_chuanci_buff + def_chuanci_aura + def_chuanci_tactic
	return def_chuanci
end

--geyachao: 接口
--获得角色携弹数量
_hu.GetBulletCapacity = function(self)
	local attr = self.attr --属性表
	
	local bullet_capacity_basic = attr.bullet_capacity_basic --基础携弹数量
	local bullet_capacity_item = attr.bullet_capacity_item --道具附加携弹数量
	local bullet_capacity_buff = attr.bullet_capacity_buff --buff附加携弹数量
	local bullet_capacity_aura = attr.bullet_capacity_aura --光环附加携弹数量
	local bullet_capacity_tactic = attr.bullet_capacity_tactic --战术技能卡附加携弹数量
	
	local bullet_capacity = bullet_capacity_basic + bullet_capacity_item + bullet_capacity_buff + bullet_capacity_aura + bullet_capacity_tactic
	return bullet_capacity
end

--geyachao: 接口
--获得角色手雷数量
_hu.GetGrenadeCapacity = function(self)
	local attr = self.attr --属性表
	
	local grenade_capacity_basic = attr.grenade_capacity_basic --基础手雷数量
	local grenade_capacity_item = attr.grenade_capacity_item --道具附加手雷数量
	local grenade_capacity_buff = attr.grenade_capacity_buff --buff附加手雷数量
	local grenade_capacity_aura = attr.grenade_capacity_aura --光环附加手雷数量
	local grenade_capacity_tactic = attr.grenade_capacity_tactic --战术技能卡附加手雷数量
	
	local grenade_capacity = grenade_capacity_basic + grenade_capacity_item + grenade_capacity_buff + grenade_capacity_aura + grenade_capacity_tactic
	return grenade_capacity
end

--geyachao: 接口
--获得角色子母雷数量
_hu.GetGrenadeChild = function(self)
	local attr = self.attr --属性表
	
	local grenade_child_basic = attr.grenade_child_basic --基础子母雷数量
	local grenade_child_item = attr.grenade_child_item --道具附加子母雷数量
	local grenade_child_buff = attr.grenade_child_buff --buff附加子母雷数量
	local grenade_child_aura = attr.grenade_child_aura --光环附加子母雷数量
	local grenade_child_tactic = attr.grenade_child_tactic --战术技能卡附加子母雷数量
	
	local grenade_child = grenade_child_basic + grenade_child_item + grenade_child_buff + grenade_child_aura + grenade_child_tactic
	return grenade_child
end

--geyachao: 接口
--获得角色手雷爆炸火焰
_hu.GetGrenadeFire = function(self)
	local attr = self.attr --属性表
	
	local grenade_fire_basic = attr.grenade_fire_basic --基础手雷爆炸火焰
	local grenade_fire_item = attr.grenade_fire_item --道具附加手雷爆炸火焰
	local grenade_fire_buff = attr.grenade_fire_buff --buff附加手雷爆炸火焰
	local grenade_fire_aura = attr.grenade_fire_aura --光环附加手雷爆炸火焰
	local grenade_fire_tactic = attr.grenade_fire_tactic --战术技能卡附加手雷爆炸火焰
	
	local grenade_fire = grenade_fire_basic + grenade_fire_item + grenade_fire_buff + grenade_fire_aura + grenade_fire_tactic
	return grenade_fire
end

--geyachao: 接口
--获得角色手雷投弹距离
_hu.GetGrenadeDis = function(self)
	local attr = self.attr --属性表
	
	local grenade_dis_basic = attr.grenade_dis_basic --基础手雷投弹距离
	local grenade_dis_item = attr.grenade_dis_item --道具附加手雷投弹距离
	local grenade_dis_buff = attr.grenade_dis_buff --buff附加手雷投弹距离
	local grenade_dis_aura = attr.grenade_dis_aura --光环附加手雷投弹距离
	local grenade_dis_tactic = attr.grenade_dis_tactic --战术技能卡附加手雷投弹距离
	
	local grenade_dis = grenade_dis_basic + grenade_dis_item + grenade_dis_buff + grenade_dis_aura + grenade_dis_tactic
	return grenade_dis
end

--geyachao: 接口
--获得角色手雷冷却时间（单位：毫秒）
_hu.GetGrenadeCD = function(self)
	local attr = self.attr --属性表
	
	local grenade_cd_basic = attr.grenade_cd_basic --基础手雷冷却时间
	local grenade_cd_item = attr.grenade_cd_item --道具附加手雷冷却时间
	local grenade_cd_buff = attr.grenade_cd_buff --buff附加手雷冷却时间
	local grenade_cd_aura = attr.grenade_cd_aura --光环附加手雷冷却时间
	local grenade_cd_tactic = attr.grenade_cd_tactic --战术技能卡附加手雷冷却时间
	
	local grenade_cd = grenade_cd_basic + grenade_cd_item + grenade_cd_buff + grenade_cd_aura + grenade_cd_tactic
	
	--手雷冷却下限
	if (grenade_cd < hVar.ROLE_CD_GERENADER_RATE_MAX) then
		grenade_cd = hVar.ROLE_CD_GERENADER_RATE_MAX
	end
	
	return grenade_cd
end

--geyachao: 接口
--获得角色手雷暴击
_hu.GetGrenadeCrit = function(self)
	local attr = self.attr --属性表
	
	local grenade_crit_basic = attr.grenade_crit_basic --基础手雷暴击
	local grenade_crit_item = attr.grenade_crit_item --道具附加手雷暴击
	local grenade_crit_buff = attr.grenade_crit_buff --buff附加手雷暴击
	local grenade_crit_aura = attr.grenade_crit_aura --光环附加手雷暴击
	local grenade_crit_tactic = attr.grenade_crit_tactic --战术技能卡附加手雷暴击
	
	local grenade_crit = grenade_crit_basic + grenade_crit_item + grenade_crit_buff + grenade_crit_aura + grenade_crit_tactic
	return grenade_crit
end

--geyachao: 接口
--获得角色手雷冷却前使用次数
_hu.GetGrenadeMultiply = function(self)
	local attr = self.attr --属性表
	
	local grenade_multiply_basic = attr.grenade_multiply_basic --基础手雷冷却前使用次数
	local grenade_multiply_item = attr.grenade_multiply_item --道具附加手雷冷却前使用次数
	local grenade_multiply_buff = attr.grenade_multiply_buff --buff附加手雷冷却前使用次数
	local grenade_multiply_aura = attr.grenade_multiply_aura --光环附加手雷冷却前使用次数
	local grenade_multiply_tactic = attr.grenade_multiply_tactic --战术技能卡附加手雷冷却前使用次数
	
	local grenade_multiply = grenade_multiply_basic + grenade_multiply_item + grenade_multiply_buff + grenade_multiply_aura + grenade_multiply_tactic
	
	--手雷使用次数上限
	if (grenade_multiply > hVar.ROLE_GRENADE_MULTIPLY_MAX) then
		grenade_multiply = hVar.ROLE_GRENADE_MULTIPLY_MAX
	end
	
	return grenade_multiply
end

--geyachao: 接口
--获得角色惯性
_hu.GetInertia = function(self)
	local attr = self.attr --属性表
	
	local inertia_basic = attr.inertia_basic --基础惯性
	local inertia_item = attr.inertia_item --道具附加惯性
	local inertia_buff = attr.inertia_buff --buff附加惯性
	local inertia_aura = attr.inertia_aura --光环附加惯性
	local inertia_tactic = attr.inertia_tactic --战术技能卡附加惯性
	
	local inertia = inertia_basic + inertia_item + inertia_buff + inertia_aura + inertia_tactic
	return inertia
end

--geyachao: 接口
--获得角色水晶收益率（去百分号后的值）
_hu.GetCrystalRate = function(self)
	local attr = self.attr --属性表
	
	local crystal_rate_basic = attr.crystal_rate_basic --基础水晶收益率（去百分号后的值）
	local crystal_rate_item = attr.crystal_rate_item --道具附加水晶收益率（去百分号后的值）
	local crystal_rate_buff = attr.crystal_rate_buff --buff附加水晶收益率（去百分号后的值）
	local crystal_rate_aura = attr.crystal_rate_aura --光环附加水晶收益率（去百分号后的值）
	local crystal_rate_tactic = attr.crystal_rate_tactic --战术技能卡附加水晶收益率（去百分号后的值）
	
	local crystal_rate = crystal_rate_basic + crystal_rate_item + crystal_rate_buff + crystal_rate_aura + crystal_rate_tactic
	return crystal_rate
end

--geyachao: 接口
--获得角色近战弹开
_hu.GetMeleeBounce = function(self)
	local attr = self.attr --属性表
	
	local melee_bounce_basic = attr.melee_bounce_basic --基础近战弹开
	local melee_bounce_item = attr.melee_bounce_item --道具附加近战弹开
	local melee_bounce_buff = attr.melee_bounce_buff --buff附加近战弹开
	local melee_bounce_aura = attr.melee_bounce_aura --光环附加近战弹开
	local melee_bounce_tactic = attr.melee_bounce_tactic --战术技能卡附加近战弹开
	
	local melee_bounce = melee_bounce_basic + melee_bounce_item + melee_bounce_buff + melee_bounce_aura + melee_bounce_tactic
	return melee_bounce
end

--geyachao: 接口
--获得角色近战反击
_hu.GetMeleeFight = function(self)
	local attr = self.attr --属性表
	
	local melee_fight_basic = attr.melee_fight_basic --基础近战反击
	local melee_fight_item = attr.melee_fight_item --道具附加近战反击
	local melee_fight_buff = attr.melee_fight_buff --buff附加近战反击
	local melee_fight_aura = attr.melee_fight_aura --光环附加近战反击
	local melee_fight_tactic = attr.melee_fight_tactic --战术技能卡附加近战反击
	
	local melee_fight = melee_fight_basic + melee_fight_item + melee_fight_buff + melee_fight_aura + melee_fight_tactic
	return melee_fight
end

--geyachao: 接口
--获得角色近战碎石
_hu.GetMeleeStone = function(self)
	local attr = self.attr --属性表
	
	local melee_stone_basic = attr.melee_stone_basic --基础近战碎石
	local melee_stone_item = attr.melee_stone_item --道具附加近战碎石
	local melee_stone_buff = attr.melee_stone_buff --buff附加近战碎石
	local melee_stone_aura = attr.melee_stone_aura --光环附加近战碎石
	local melee_stone_tactic = attr.melee_stone_tactic --战术技能卡附加近战碎石
	
	local melee_stone = melee_stone_basic + melee_stone_item + melee_stone_buff + melee_stone_aura + melee_stone_tactic
	return melee_stone
end

--geyachao: 接口
--获得角色攻击间隔(单位: 毫秒)
_hu.GetAtkInterval = function(self)
	local attr = self.attr --属性表
	
	local atk_interval_basic = attr.atk_interval_basic --基础攻击间隔（毫秒）
	local atk_interval_item = attr.atk_interval_item --道具附加攻击间隔（毫秒）
	local atk_interval_buff = attr.atk_interval_buff --buff附加攻击间隔（毫秒）
	local atk_interval_aura = attr.atk_interval_aura --光环附加攻击间隔（毫秒）
	local atk_interval_tactic = attr.atk_interval_tactic --战术技能卡附加攻击间隔（毫秒）
	
	local atk_interval = atk_interval_basic + atk_interval_item + atk_interval_buff + atk_interval_aura + atk_interval_tactic
	
	local atk_speed_basic = attr.atk_speed_basic --基础攻击速度（去百分号后的值）
	local atk_speed_item = attr.atk_speed_item --道具附加攻击速度（去百分号后的值）
	local atk_speed_buff = attr.atk_speed_buff --buff附加攻击速度（去百分号后的值）
	local atk_speed_aura = attr.atk_speed_aura --光环附加攻击速度（去百分号后的值）
	local atk_speed_tactic = attr.atk_speed_tactic --战术技能卡附加攻击速度（去百分号后的值）
	
	local atk_speed = atk_speed_basic + atk_speed_item + atk_speed_buff + atk_speed_aura + atk_speed_tactic
	if (atk_speed < hVar.ROLE_ATK_SPEED_MIN) then --攻击速度（去百分号后的值）下限
		atk_speed = hVar.ROLE_ATK_SPEED_MIN
	end
	if (atk_speed > hVar.ROLE_ATK_SPEED_MAX) then --攻击速度（去百分号后的值）上限
		atk_speed = hVar.ROLE_ATK_SPEED_MAX
	end
	
	local atk_itvl = math.floor(atk_interval * (100 / atk_speed))
	--if (hVar.tab_unit[self.data.id].type == 1) then
	--	print(self.data.name, "atk_speed", atk_speed_basic, atk_speed_item, atk_speed_buff, atk_speed_aura, atk_speed_tactic, "atk_itvl=", atk_itvl)
	--end
	return atk_itvl
end

--geyachao: 接口
--获得角色移动速度
_hu.GetMoveSpeed = function(self)
	local attr = self.attr --属性表
	
	local move_speed_basic = attr.move_speed_basic --基础移动速
	local move_speed_item = attr.move_speed_item --道具附加移动速度
	local move_speed_buff = attr.move_speed_buff --buff附加移动速度
	local move_speed_aura = attr.move_speed_aura --光环附加移动速度
	local move_speed_tactic = attr.move_speed_tactic --战术技能卡附加移动速度
	
	local move_speed = move_speed_basic + move_speed_item + move_speed_buff + move_speed_aura + move_speed_tactic
	return move_speed
end

--geyachao: 接口
--获得角色攻击范围
_hu.GetAtkRange = function(self)
	local attr = self.attr --属性表
	
	local atk_radius_basic = attr.atk_radius_basic --基础攻击范围
	local atk_radius_item = attr.atk_radius_item --道具附加攻击范围
	local atk_radius_buff = attr.atk_radius_buff --buff附加攻击范围
	local atk_radius_aura = attr.atk_radius_aura --光环附加攻击范围
	local atk_radius_tactic = attr.atk_radius_tactic --战术技能卡附加攻击范围
	
	--print(atk_radius_basic, atk_radius_buff, atk_radius_aura, atk_radius_tactic)
	local atk_radius = atk_radius_basic + atk_radius_item + atk_radius_buff + atk_radius_aura + atk_radius_tactic
	return atk_radius
end

--geyachao: 接口
--获得角色攻击范围最小值
_hu.GetAtkRangeMin = function(self)
	local attr = self.attr --属性表
	
	local atk_radius_min_basic = attr.atk_radius_min_basic --基础攻击范围
	local atk_radius_min_item = attr.atk_radius_min_item --道具附加攻击范围
	local atk_radius_min_buff = attr.atk_radius_min_buff --buff附加攻击范围
	local atk_radius_min_aura = attr.atk_radius_min_aura --光环附加攻击范围
	local atk_radius_min_tactic = attr.atk_radius_min_tactic --战术技能卡附加攻击范围
	
	--print(atk_radius_basic, atk_radius_buff, atk_radius_aura, atk_radius_tactic)
	local atk_radius_min = atk_radius_min_basic + atk_radius_min_item + atk_radius_min_buff + atk_radius_min_aura + atk_radius_min_tactic
	return atk_radius_min
end

--geyachao: 接口
--获得角色攻击搜敌范围
--[[
_hu.GetAtkSearchRange = function(self)
	local attr = self.attr --属性表
	
	local atk_search_radius_basic = attr.atk_search_radius_basic --基础攻击搜敌范围
	local atk_search_radius_buff = attr.atk_search_radius_buff --buff附加攻击搜敌范围
	local atk_search_radius_aura = attr.atk_search_radius_aura --光环附加攻击搜敌范围
	local atk_search_radius_tactic = attr.atk_search_radius_tactic --战术技能卡附加攻击搜敌范围
	
	local atk_search_radius = atk_search_radius_basic + atk_search_radius_buff + atk_search_radius_aura + atk_search_radius_tactic
	
	--搜敌半径不小于攻击半径
	local atk_radius = self:GetAtkRange()
	if (atk_search_radius < atk_radius) then
		atk_search_radius = atk_radius
	end
	
	return atk_search_radius
end
]]

--geyachao: 接口
--获得角色闪避几率（去百分号后的值）
_hu.GetDodgeRate = function(self)
	local attr = self.attr --属性表
	
	local dodge_rate_basic = attr.dodge_rate_basic --基础闪避几率（去百分号后的值）
	local dodge_rate_item = attr.dodge_rate_item --道具附加闪避几率（去百分号后的值）
	local dodge_rate_buff = attr.dodge_rate_buff --buff附加闪避几率（去百分号后的值）
	local dodge_rate_aura = attr.dodge_rate_aura --光环附加闪避几率（去百分号后的值）
	local dodge_rate_tactic = attr.dodge_rate_tactic --战术技能卡附加闪避几率（去百分号后的值）
	
	local dodge_rate = dodge_rate_basic + dodge_rate_item + dodge_rate_buff + dodge_rate_aura + dodge_rate_tactic
	return dodge_rate
end

--geyachao: 接口
--获得角色命中几率（去百分号后的值）
_hu.GetHitRate = function(self)
	local attr = self.attr --属性表
	
	local hit_rate_basic = attr.hit_rate_basic --基础命中几率（去百分号后的值）
	local hit_rate_item = attr.hit_rate_item --道具附加命中几率（去百分号后的值）
	local hit_rate_buff = attr.hit_rate_buff --buff附加命中几率（去百分号后的值）
	local hit_rate_aura = attr.hit_rate_aura --光环附加命中几率（去百分号后的值）
	local hit_rate_tactic = attr.hit_rate_tactic --战术技能卡附加命中几率（去百分号后的值）
	
	local hit_rate = hit_rate_basic + hit_rate_item + hit_rate_buff + hit_rate_aura + hit_rate_tactic
	return hit_rate
end

--geyachao: 接口
--获得角色暴击几率（去百分号后的值）
_hu.GetCritRate = function(self)
	local attr = self.attr --属性表
	
	local crit_rate_basic = attr.crit_rate_basic --基础暴击几率（去百分号后的值）
	local crit_rate_item = attr.crit_rate_item --道具附加暴击几率（去百分号后的值）
	local crit_rate_buff = attr.crit_rate_buff --buff附加暴击几率（去百分号后的值）
	local crit_rate_aura = attr.crit_rate_aura --光环附加暴击几率（去百分号后的值）
	local crit_rate_tactic = attr.crit_rate_tactic --战术暴击卡附加闪避几率（去百分号后的值）
	
	local crit_rate = crit_rate_basic + crit_rate_item + crit_rate_buff + crit_rate_aura + crit_rate_tactic
	return crit_rate
end

--geyachao: 接口
--获得角色暴击倍数
_hu.GetCritValue = function(self)
	local attr = self.attr --属性表
	
	local crit_value_basic = attr.crit_value_basic --基础暴击倍数
	local crit_value_item = attr.crit_value_item --道具附加暴击倍数
	local crit_value_buff = attr.crit_value_buff --buff附加暴击倍数
	local crit_value_aura = attr.crit_value_aura --光环附加暴击倍数
	local crit_value_tactic = attr.crit_value_tactic --战术技能卡附加暴击倍数
	
	local crit_value = crit_value_basic + crit_value_item + crit_value_buff + crit_value_aura + crit_value_tactic
	return crit_value
end

--geyachao: 接口
--获得角色被击杀的奖励金币
_hu.GetKillGold = function(self)
	local attr = self.attr --属性表
	
	local kill_gold_basic = attr.kill_gold_basic --基础击杀获得的金币
	local kill_gold_item = attr.kill_gold_item --道具附加击杀获得的金币
	local kill_gold_buff = attr.kill_gold_buff --buff附加击杀获得的金币
	local kill_gold_aura = attr.kill_gold_aura --光环附加击杀获得的金币
	local kill_gold_tactic = attr.kill_gold_tactic --战术技能卡附加击杀获得的金币
	
	local kill_gold = kill_gold_basic + kill_gold_item + kill_gold_buff + kill_gold_aura + kill_gold_tactic
	return kill_gold
end

--geyachao: 接口
--获得角色被击杀的奖励金币
_hu.GetEscapePunish = function(self)
	local attr = self.attr --属性表
	
	local escape_punish_basic = attr.escape_punish_basic --基础逃怪惩罚
	local escape_punish_item = attr.escape_punish_item --道具附加逃怪惩罚
	local escape_punish_buff = attr.escape_punish_buff --buff附加逃怪惩罚
	local escape_punish_aura = attr.escape_punish_aura --光环附加逃怪惩罚
	local escape_punish_tactic = attr.escape_punish_tactic --战术技能卡附加逃怪惩罚
	
	local escape_punish = escape_punish_basic + escape_punish_item + escape_punish_buff + escape_punish_aura + escape_punish_tactic
	return escape_punish
end

--geyachao: 接口
--获得角色回血速度（每秒）
_hu.GetHpRestore = function(self)
	local attr = self.attr --属性表
	
	local hp_restore_basic = attr.hp_restore_basic --基础回血速度（每秒）
	local hp_restore_item = attr.hp_restore_item --道具附加回血速度（每秒）
	local hp_restore_buff = attr.hp_restore_buff --buff附加回血速度（每秒）
	local hp_restore_aura = attr.hp_restore_aura --光环附加回血速度（每秒）
	local hp_restore_tactic = attr.hp_restore_tactic --战术技能卡附加回血速度（每秒）
	
	local hp_restore = hp_restore_basic + hp_restore_item + hp_restore_buff + hp_restore_aura + hp_restore_tactic
	return hp_restore
end

--geyachao: 接口
--获得角色复活时间（毫秒）
_hu.GetRebirthTime = function(self)
	local attr = self.attr --属性表
	
	local rebirth_time_basic = attr.rebirth_time_basic --基础复活时间（毫秒）
	local rebirth_time_item = attr.rebirth_time_item --道具附加复活时间（毫秒）
	local rebirth_time_buff = attr.rebirth_time_buff --buff附加复活时间（毫秒）
	local rebirth_time_aura = attr.rebirth_time_aura --光环附加复活时间（毫秒）
	local rebirth_time_tactic = attr.rebirth_time_tactic --战术技能卡附加复活时间（毫秒）
	
	local rebirth_time = rebirth_time_basic + rebirth_time_item + rebirth_time_buff + rebirth_time_aura + rebirth_time_tactic
	return rebirth_time
end

--geyachao: 接口
--获得角色的吸血率（去百分号后的值）
_hu.GetSuckBloodRate = function(self)
	local attr = self.attr --属性表
	
	local suck_blood_rate_basic = attr.suck_blood_rate_basic --基础吸血率（去百分号后的值）
	local suck_blood_rate_item = attr.suck_blood_rate_item --道具吸血率（去百分号后的值）
	local suck_blood_rate_buff = attr.suck_blood_rate_buff --buff吸血率（去百分号后的值）
	local suck_blood_rate_aura = attr.suck_blood_rate_aura --光环吸血率（去百分号后的值）
	local suck_blood_rate_tactic = attr.suck_blood_rate_tactic --战术技能卡吸血率（去百分号后的值）
	
	local suck_blood_rate = suck_blood_rate_basic + suck_blood_rate_item + suck_blood_rate_buff + suck_blood_rate_aura + suck_blood_rate_tactic
	return suck_blood_rate
end

--geyachao: 接口
--获得角色的主动技能冷却时间变化值（毫秒）
_hu.GetActiveSkillCDDelta = function(self)
	local attr = self.attr --属性表
	
	local active_skill_cd_delta_basic = attr.active_skill_cd_delta_basic --基础主动技能冷却时间变化值（毫秒）
	local active_skill_cd_delta_item = attr.active_skill_cd_delta_item --道具主动技能冷却时间变化值（毫秒）
	local active_skill_cd_delta_buff = attr.active_skill_cd_delta_buff --buff主动技能冷却时间变化值（毫秒）
	local active_skill_cd_delta_aura = attr.active_skill_cd_delta_aura --光环主动技能冷却时间变化值（毫秒）
	local active_skill_cd_delta_tactic = attr.active_skill_cd_delta_tactic --战术技能卡主动技能冷却时间变化值（毫秒）
	
	local active_skill_cd_delta = active_skill_cd_delta_basic + active_skill_cd_delta_item + active_skill_cd_delta_buff + active_skill_cd_delta_aura + active_skill_cd_delta_tactic
	return active_skill_cd_delta
end

--geyachao: 接口
--获得角色的主动技能冷却时间变化比例值（去百分号后的值）
_hu.GetActiveSkillCDDeltaRate = function(self)
	local attr = self.attr --属性表
	
	local active_skill_cd_delta_rate_basic = attr.active_skill_cd_delta_rate_basic --基础主动技能冷却时间变化比例值（去百分号后的值）
	local active_skill_cd_delta_rate_item = attr.active_skill_cd_delta_rate_item --道具主动技能冷却时间变化比例值（去百分号后的值）
	local active_skill_cd_delta_rate_buff = attr.active_skill_cd_delta_rate_buff --buff主动技能冷却时间变化比例值（去百分号后的值）
	local active_skill_cd_delta_rate_aura = attr.active_skill_cd_delta_rate_aura --光环主动技能冷却时间变化比例值（去百分号后的值）
	local active_skill_cd_delta_rate_tactic = attr.active_skill_cd_delta_rate_tactic --战术技能卡主动技能冷却时间变化比例值（去百分号后的值）
	
	local active_skill_cd_delta_rate = active_skill_cd_delta_rate_basic + active_skill_cd_delta_rate_item + active_skill_cd_delta_rate_buff + active_skill_cd_delta_rate_aura + active_skill_cd_delta_rate_tactic
	
	--不低于下限
	if (active_skill_cd_delta_rate < hVar.ROLE_CD_REDUICE_RATE_MAX) then
		active_skill_cd_delta_rate = hVar.ROLE_CD_REDUICE_RATE_MAX
	end
	
	return active_skill_cd_delta_rate
end

--geyachao: 接口
--获得角色的被动技能冷却时间变化值（毫秒）
_hu.GetPassiveSkillCDDelta = function(self)
	local attr = self.attr --属性表
	
	local passive_skill_cd_delta_basic = attr.passive_skill_cd_delta_basic --基础主动技能冷却时间变化值（毫秒）
	local passive_skill_cd_delta_item = attr.passive_skill_cd_delta_item --道具主动技能冷却时间变化值（毫秒）
	local passive_skill_cd_delta_buff = attr.passive_skill_cd_delta_buff --buff主动技能冷却时间变化值（毫秒）
	local passive_skill_cd_delta_aura = attr.passive_skill_cd_delta_aura --光环主动技能冷却时间变化值（毫秒）
	local passive_skill_cd_delta_tactic = attr.passive_skill_cd_delta_tactic --战术技能卡主动技能冷却时间变化值（毫秒）
	
	--print("GetPassiveSkillCDDelta", passive_skill_cd_delta_basic, passive_skill_cd_delta_item, passive_skill_cd_delta_tactic)
	local passive_skill_cd_delta = passive_skill_cd_delta_basic + passive_skill_cd_delta_item + passive_skill_cd_delta_buff + passive_skill_cd_delta_aura + passive_skill_cd_delta_tactic
	return passive_skill_cd_delta
end

--geyachao: 接口
--获得角色的被动技能冷却时间变化比例值（去百分号后的值）
_hu.GetPassiveSkillCDDeltaRate = function(self)
	local attr = self.attr --属性表
	
	local passive_skill_cd_delta_rate_basic = attr.passive_skill_cd_delta_rate_basic --基础被动技能冷却时间变化比例值（去百分号后的值）
	local passive_skill_cd_delta_rate_item = attr.passive_skill_cd_delta_rate_item --道具被动技能冷却时间变化比例值（去百分号后的值）
	local passive_skill_cd_delta_rate_buff = attr.passive_skill_cd_delta_rate_buff --buff被动技能冷却时间变化比例值（去百分号后的值）
	local passive_skill_cd_delta_rate_aura = attr.passive_skill_cd_delta_rate_aura --光环被动技能冷却时间变化比例值（去百分号后的值）
	local passive_skill_cd_delta_rate_tactic = attr.passive_skill_cd_delta_rate_tactic --战术技能卡被动技能冷却时间变化比例值（去百分号后的值）
	
	local passive_skill_cd_delta_rate = passive_skill_cd_delta_rate_basic + passive_skill_cd_delta_rate_item + passive_skill_cd_delta_rate_buff + passive_skill_cd_delta_rate_aura + passive_skill_cd_delta_rate_tactic
	
	--不低于下限
	if (passive_skill_cd_delta_rate < hVar.ROLE_CD_REDUICE_RATE_MAX) then
		passive_skill_cd_delta_rate = hVar.ROLE_CD_REDUICE_RATE_MAX
	end
	
	return passive_skill_cd_delta_rate
end

--geyachao: 接口
--获得角色AI行为
_hu.GetAIAttribute = function(self)
	local attr = self.attr --属性表
	
	local AI_attribute_basic = attr.AI_attribute_basic --基础AI行为（0：被动怪 / 1:主动怪）
	local AI_attribute_item = attr.AI_attribute_item --道具附加AI行为（0：被动怪 / 1:主动怪）
	local AI_attribute_buff = attr.AI_attribute_buff --buff附加AI行为（0：被动怪 / 1:主动怪）
	local AI_attribute_aura = attr.AI_attribute_aura --光环附加AI行为（0：被动怪 / 1:主动怪）
	local AI_attribute_tactic = attr.AI_attribute_tactic --战术技能卡附加AI行为（0：被动怪 / 1:主动怪）
	
	local AI_attribute = AI_attribute_basic + AI_attribute_item + AI_attribute_buff + AI_attribute_aura + AI_attribute_tactic
	if (AI_attribute == 0) then
		return hVar.AI_ATTRIBUTE_TYPE.POSITIVE --被动怪
	else
		return hVar.AI_ATTRIBUTE_TYPE.ACTIVE --主动怪
	end
end

--geyachao: 接口
--获得角色空间类型
_hu.GetSpaceType = function(self)
	local attr = self.attr --属性表
	
	local space_type = attr.space_type --空间类型
	local space_ground_stack = attr.space_ground_stack --变地面单位堆叠层数
	
	local unit_space_type = space_type
	if (space_ground_stack > 0) then
		unit_space_type = hVar.UNIT_SPACE_TYPE.SPACE_GROUND
	end
	
	return unit_space_type
end

--geyachao: 接口
--获得角色的复活后无敌时间（毫秒）
_hu.GetRebirthWudiTime = function(self)
	local attr = self.attr --属性表
	
	local rebirth_wudi_time_basic = attr.rebirth_wudi_time_basic --基础复活后无敌时间（毫秒）
	local rebirth_wudi_time_item = attr.rebirth_wudi_time_item --道具复活后无敌时间（毫秒）
	local rebirth_wudi_time_buff = attr.rebirth_wudi_time_buff --buff复活后无敌时间（毫秒）
	local rebirth_wudi_time_aura = attr.rebirth_wudi_time_aura --光环复活后无敌时间（毫秒）
	local rebirth_wudi_time_tactic = attr.rebirth_wudi_time_tactic --战术技能卡复活后无敌时间（毫秒）
	
	--print("GetRebirthWudiTime", rebirth_wudi_time_basic, rebirth_wudi_time_item, rebirth_wudi_time_tactic)
	local rebirth_wudi_time = rebirth_wudi_time_basic + rebirth_wudi_time_item + rebirth_wudi_time_buff + rebirth_wudi_time_aura + rebirth_wudi_time_tactic
	return rebirth_wudi_time
end

--geyachao: 接口
--获得角色的基础武器等级
_hu.GetBasicWeaponLevel = function(self)
	local attr = self.attr --属性表
	
	local basic_weapon_level_basic = attr.basic_weapon_level_basic --基础武器等级
	local basic_weapon_level_item = attr.basic_weapon_level_item --道具武器等级
	local basic_weapon_level_buff = attr.basic_weapon_level_buff --buff武器等级
	local basic_weapon_level_aura = attr.basic_weapon_level_aura --光环武器等级
	local basic_weapon_level_tactic = attr.basic_weapon_level_tactic --战术技能卡武器等级
	
	--print("GetWeaponLevel", basic_weapon_level_basic, basic_weapon_level_item, basic_weapon_level_tactic)
	local basic_weapon_level = basic_weapon_level_basic + basic_weapon_level_item + basic_weapon_level_buff + basic_weapon_level_aura + basic_weapon_level_tactic
	return basic_weapon_level
end
	
--geyachao: 接口
--获得角色的基础武器等级
_hu.GetBasicSkillLevel = function(self)
	local attr = self.attr --属性表
	
	local basic_skill_level_basic = attr.basic_skill_level_basic --基础技能等级
	local basic_skill_level_item = attr.basic_skill_level_item --道具技能等级
	local basic_skill_level_buff = attr.basic_skill_level_buff --buff技能等级
	local basic_skill_level_aura = attr.basic_skill_level_aura --光环技能等级
	local basic_skill_level_tactic = attr.basic_skill_level_tactic --战术技能卡技能等级
	
	--print("GetSkillLevel", basic_skill_level_basic, basic_skill_level_item, basic_weapon_level_tactic)
	local basic_skill_level = basic_skill_level_basic + basic_skill_level_item + basic_skill_level_buff + basic_skill_level_aura + basic_skill_level_tactic
	return basic_skill_level
end

--geyachao: 接口
--获得角色的基础武器使用次数
_hu.GetBasicSkillUseCount = function(self)
	local attr = self.attr --属性表
	
	local basic_skill_usecount_basic = attr.basic_skill_usecount_basic --基础技能使用次数
	local basic_skill_usecount_item = attr.basic_skill_usecount_item --道具技能使用次数
	local basic_skill_usecount_buff = attr.basic_skill_usecount_buff --buff技能使用次数
	local basic_skill_usecount_aura = attr.basic_skill_usecount_aura --光环技能使用次数
	local basic_skill_usecount_tactic = attr.basic_skill_usecount_tactic --战术技能卡技能使用次数
	
	--print("GetBasicSkillUseCount", basic_skill_usecount_basic, basic_skill_usecount_item, basic_skill_usecount_tactic)
	local basic_skill_usecount = basic_skill_usecount_basic + basic_skill_usecount_item + basic_skill_usecount_buff + basic_skill_usecount_aura + basic_skill_usecount_tactic
	return basic_skill_usecount
end

--geyachao: 接口
--获得角色的宠物回血
_hu.GetPetHpRestore = function(self)
	local attr = self.attr --属性表
	
	local pet_hp_restore_basic = attr.pet_hp_restore_basic --基础宠物回血
	local pet_hp_restore_item = attr.pet_hp_restore_item --道具宠物回血
	local pet_hp_restore_buff = attr.pet_hp_restore_buff --buff宠物回血
	local pet_hp_restore_aura = attr.pet_hp_restore_aura --光环宠物回血
	local pet_hp_restore_tactic = attr.pet_hp_restore_tactic --战术技能卡宠物回血
	
	--print("GetPetHpRestore", pet_hp_restore_basic, pet_hp_restore_item, pet_hp_restore_tactic)
	local pet_hp_restore = pet_hp_restore_basic + pet_hp_restore_item + pet_hp_restore_buff + pet_hp_restore_aura + pet_hp_restore_tactic
	return pet_hp_restore
end

--geyachao: 接口
--获得角色的宠物生命
_hu.GetPetHp = function(self)
	local attr = self.attr --属性表
	
	local pet_hp_basic = attr.pet_hp_basic --基础宠物生命
	local pet_hp_item = attr.pet_hp_item --道具宠物生命
	local pet_hp_buff = attr.pet_hp_buff --buff宠物生命
	local pet_hp_aura = attr.pet_hp_aura --光环宠物生命
	local pet_hp_tactic = attr.pet_hp_tactic --战术技能卡宠物生命
	
	--print("GetPetHp", pet_hp_basic, pet_hp_item, pet_hp_tactic)
	local pet_hp = pet_hp_basic + pet_hp_item + pet_hp_buff + pet_hp_aura + pet_hp_tactic
	return pet_hp
end

--geyachao: 接口
--获得角色的宠物生命
_hu.GetPetAtk = function(self)
	local attr = self.attr --属性表
	
	local pet_atk_basic = attr.pet_atk_basic --基础宠物攻击
	local pet_atk_item = attr.pet_atk_item --道具宠物攻击
	local pet_atk_buff = attr.pet_atk_buff --buff宠物攻击
	local pet_atk_aura = attr.pet_atk_aura --光环宠物攻击
	local pet_atk_tactic = attr.pet_atk_tactic --战术技能卡宠物攻击
	
	--print("GetPetAtk", pet_atk_basic, pet_atk_item, pet_atk_tactic)
	local pet_atk = pet_atk_basic + pet_atk_item + pet_atk_buff + pet_atk_aura + pet_atk_tactic
	return pet_atk
end

--geyachao: 接口
--获得角色的宠物生命
_hu.GetPetAtkSpeed = function(self)
	local attr = self.attr --属性表
	
	local pet_atk_speed_basic = attr.pet_atk_speed_basic --基础宠物攻速
	local pet_atk_speed_item = attr.pet_atk_speed_item --道具宠物攻速
	local pet_atk_speed_buff = attr.pet_atk_speed_buff --buff宠物攻速
	local pet_atk_speed_aura = attr.pet_atk_speed_aura --光环宠物攻速
	local pet_atk_speed_tactic = attr.pet_atk_speed_tactic --战术技能卡宠物攻速
	
	--print("GetPetAtkSpeed", pet_atk_speed_basic, pet_atk_speed_item, pet_atk_speed_tactic)
	local pet_atk_speed = pet_atk_speed_basic + pet_atk_speed_item + pet_atk_speed_buff + pet_atk_speed_aura + pet_atk_speed_tactic
	return pet_atk_speed
end

--geyachao: 接口
--获得角色的宠物携带数量
_hu.GetPetCapacity = function(self)
	local attr = self.attr --属性表
	
	local pet_capacity_basic = attr.pet_capacity_basic --基础宠物携带数量
	local pet_capacity_item = attr.pet_capacity_item --道具宠物携带数量
	local pet_capacity_buff = attr.pet_capacity_buff --buff宠物携带数量
	local pet_capacity_aura = attr.pet_capacity_aura --光环宠物携带数量
	local pet_capacity_tactic = attr.pet_capacity_tactic --战术技能卡宠物携带数量
	
	--print("GetPetCapacity", pet_capacity_basic, pet_capacity_item, pet_capacity_buff, pet_capacity_aura, pet_capacity_tactic)
	local pet_capacity = pet_capacity_basic + pet_capacity_item + pet_capacity_buff + pet_capacity_aura + pet_capacity_tactic
	return pet_capacity
end

--geyachao: 接口
--获得角色的陷阱时间（单位：毫秒）
_hu.GetTrapGround = function(self)
	local attr = self.attr --属性表
	
	local trap_ground_basic = attr.trap_ground_basic --基础陷阱时间（单位：毫秒）
	local trap_ground_item = attr.trap_ground_item --道具陷阱时间（单位：毫秒）
	local trap_ground_buff = attr.trap_ground_buff --buff陷阱时间（单位：毫秒）
	local trap_ground_aura = attr.trap_ground_aura --光环陷阱时间（单位：毫秒）
	local trap_ground_tactic = attr.trap_ground_tactic --战术技能卡陷阱时间（单位：毫秒）
	
	--print("GetTrapGround", trap_ground_basic, trap_ground_item, trap_ground_buff, trap_ground_aura, trap_ground_tactic)
	local trap_ground = trap_ground_basic + trap_ground_item + trap_ground_buff + trap_ground_aura + trap_ground_tactic
	return trap_ground
end

--geyachao: 接口
--获得角色的陷阱施法间隔（单位：毫秒）
_hu.GetTrapGroundCD = function(self)
	local attr = self.attr --属性表
	
	local trap_groundcd_basic = attr.trap_groundcd_basic --基础陷阱施法间隔（单位：毫秒）
	local trap_groundcd_item = attr.trap_groundcd_item --道具陷阱施法间隔（单位：毫秒）
	local trap_groundcd_buff = attr.trap_groundcd_buff --buff陷阱施法间隔（单位：毫秒）
	local trap_groundcd_aura = attr.trap_groundcd_aura --光环陷阱施法间隔（单位：毫秒）
	local trap_groundcd_tactic = attr.trap_groundcd_tactic --战术技能卡陷阱施法间隔（单位：毫秒）
	
	--print("GetTrapGroundCD", trap_groundcd_basic, trap_groundcd_item, trap_groundcd_buff, trap_groundcd_aura, trap_groundcd_tactic)
	local trap_groundcd = trap_groundcd_basic + trap_groundcd_item + trap_groundcd_buff + trap_groundcd_aura + trap_groundcd_tactic
	return trap_groundcd
end

--geyachao: 接口
--获得角色的陷阱困敌时间（单位：毫秒）
_hu.GetTrapGroundEnemy = function(self)
	local attr = self.attr --属性表
	
	local trap_groundenemy_basic = attr.trap_groundenemy_basic --基础陷阱困敌时间（单位：毫秒）
	local trap_groundenemy_item = attr.trap_groundenemy_item --道具陷阱困敌时间（单位：毫秒）
	local trap_groundenemy_buff = attr.trap_groundenemy_buff --buff陷阱困敌时间（单位：毫秒）
	local trap_groundenemy_aura = attr.trap_groundenemy_aura --光环陷阱困敌时间（单位：毫秒）
	local trap_groundenemy_tactic = attr.trap_groundenemy_tactic --战术技能卡陷阱困敌时间（单位：毫秒）
	
	--print("GetTrapGroundEnemy", trap_groundenemy_basic, trap_groundenemy_item, trap_groundenemy_buff, trap_groundenemy_aura, trap_groundenemy_tactic)
	local trap_groundenemy = trap_groundenemy_basic + trap_groundenemy_item + trap_groundenemy_buff + trap_groundenemy_aura + trap_groundenemy_tactic
	return trap_groundenemy
end

--geyachao: 接口
--获得角色的天网时间（单位：毫秒）
_hu.GetTrapFly = function(self)
	local attr = self.attr --属性表
	
	local trap_fly_basic = attr.trap_fly_basic --基础天网时间（单位：毫秒）
	local trap_fly_item = attr.trap_fly_item --道具天网时间（单位：毫秒）
	local trap_fly_buff = attr.trap_fly_buff --buff天网时间（单位：毫秒）
	local trap_fly_aura = attr.trap_fly_aura --光环天网时间（单位：毫秒）
	local trap_fly_tactic = attr.trap_fly_tactic --战术技能卡天网时间（单位：毫秒）
	
	--print("GetTrapFly", trap_fly_basic, trap_fly_item, trap_fly_buff, trap_fly_aura, trap_fly_tactic)
	local trap_fly = trap_fly_basic + trap_fly_item + trap_fly_buff + trap_fly_aura + trap_fly_tactic
	return trap_fly
end

--geyachao: 接口
--获得角色的天网施法间隔（单位：毫秒）
_hu.GetTrapFlyCD = function(self)
	local attr = self.attr --属性表
	
	local trap_flycd_basic = attr.trap_flycd_basic --基础天网施法间隔（单位：毫秒）
	local trap_flycd_item = attr.trap_flycd_item --道具天网施法间隔（单位：毫秒）
	local trap_flycd_buff = attr.trap_flycd_buff --buff天网施法间隔（单位：毫秒）
	local trap_flycd_aura = attr.trap_flycd_aura --光环天网施法间隔（单位：毫秒）
	local trap_flycd_tactic = attr.trap_flycd_tactic --战术技能卡天网施法间隔（单位：毫秒）
	
	--print("GetTrapFlyCD", trap_flycd_basic, trap_flycd_item, trap_flycd_buff, trap_flycd_aura, trap_flycd_tactic)
	local trap_flycd = trap_flycd_basic + trap_flycd_item + trap_flycd_buff + trap_flycd_aura + trap_flycd_tactic
	return trap_flycd
end

--geyachao: 接口
--获得角色的天网施法间隔（单位：毫秒）
_hu.GetTrapFlyEnemy = function(self)
	local attr = self.attr --属性表
	
	local trap_flyenemy_basic = attr.trap_flyenemy_basic --基础天网困敌时间（单位：毫秒）
	local trap_flyenemy_item = attr.trap_flyenemy_item --道具天网困敌时间（单位：毫秒）
	local trap_flyenemy_buff = attr.trap_flyenemy_buff --buff天网困敌时间（单位：毫秒）
	local trap_flyenemy_aura = attr.trap_flyenemy_aura --光环天网困敌时间（单位：毫秒）
	local trap_flyenemy_tactic = attr.trap_flyenemy_tactic --战术技能卡天网困敌时间（单位：毫秒）
	
	--print("GetTrapFlyEnemy", trap_flyenemy_basic, trap_flyenemy_item, trap_flyenemy_buff, trap_flyenemy_aura, trap_flyenemy_tactic)
	local trap_flyenemy = trap_flyenemy_basic + trap_flyenemy_item + trap_flyenemy_buff + trap_flyenemy_aura + trap_flyenemy_tactic
	return trap_flyenemy
end

--geyachao: 接口
--获得角色的迷惑几率（去百分号后的值）
_hu.GetPuzzle = function(self)
	local attr = self.attr --属性表
	
	local puzzle_basic = attr.puzzle_basic --基础迷惑几率（去百分号后的值）
	local puzzle_item = attr.puzzle_item --道具迷惑几率（去百分号后的值）
	local puzzle_buff = attr.puzzle_buff --buff迷惑几率（去百分号后的值）
	local puzzle_aura = attr.puzzle_aura --光环迷惑几率（去百分号后的值）
	local puzzle_tactic = attr.puzzle_tactic --战术技能卡迷惑几率（去百分号后的值）
	
	--print("GetPuzzle", puzzle_basic, puzzle_item, puzzle_buff, puzzle_aura, puzzle_tactic)
	local puzzle = puzzle_basic + puzzle_item + puzzle_buff + puzzle_aura + puzzle_tactic
	return puzzle
end

--geyachao: 接口
--获得角色的射击暴击
_hu.GetWeaponCritShoot = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_shoot_basic = attr.weapon_crit_shoot_basic --基础射击暴击
	local weapon_crit_shoot_item = attr.weapon_crit_shoot_item --道具射击暴击
	local weapon_crit_shoot_buff = attr.weapon_crit_shoot_buff --buff射击暴击
	local weapon_crit_shoot_aura = attr.weapon_crit_shoot_aura --光环射击暴击
	local weapon_crit_shoot_tactic = attr.weapon_crit_shoot_tactic --战术技能卡射击暴击
	
	--print("GetWeaponCritShoot", weapon_crit_shoot_basic, weapon_crit_shoot_item, weapon_crit_shoot_buff, weapon_crit_shoot_aura, weapon_crit_shoot_tactic)
	local weapon_crit_shoot = weapon_crit_shoot_basic + weapon_crit_shoot_item + weapon_crit_shoot_buff + weapon_crit_shoot_aura + weapon_crit_shoot_tactic
	return weapon_crit_shoot
end

--geyachao: 接口
--获得角色的冰冻暴击
_hu.GetWeaponCritFrozen = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_frozen_basic = attr.weapon_crit_frozen_basic --基础冰冻暴击
	local weapon_crit_frozen_item = attr.weapon_crit_frozen_item --道具冰冻暴击
	local weapon_crit_frozen_buff = attr.weapon_crit_frozen_buff --buff冰冻暴击
	local weapon_crit_frozen_aura = attr.weapon_crit_frozen_aura --光环冰冻暴击
	local weapon_crit_frozen_tactic = attr.weapon_crit_frozen_tactic --战术技能卡冰冻暴击
	
	--print("GetWeaponCritFrozen", weapon_crit_frozen_basic, weapon_crit_frozen_item, weapon_crit_frozen_buff, weapon_crit_frozen_aura, weapon_crit_frozen_tactic)
	local weapon_crit_frozen = weapon_crit_frozen_basic + weapon_crit_frozen_item + weapon_crit_frozen_buff + weapon_crit_frozen_aura + weapon_crit_frozen_tactic
	return weapon_crit_frozen
end

--geyachao: 接口
--获得角色的火焰暴击
_hu.GetWeaponCritFire = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_fire_basic = attr.weapon_crit_fire_basic --基础火焰暴击
	local weapon_crit_fire_item = attr.weapon_crit_fire_item --道具火焰暴击
	local weapon_crit_fire_buff = attr.weapon_crit_fire_buff --buff火焰暴击
	local weapon_crit_fire_aura = attr.weapon_crit_fire_aura --光环火焰暴击
	local weapon_crit_fire_tactic = attr.weapon_crit_fire_tactic --战术技能卡火焰暴击
	
	--print("GetWeaponCritFire", weapon_crit_fire_basic, weapon_crit_fire_item, weapon_crit_fire_buff, weapon_crit_fire_aura, weapon_crit_fire_tactic)
	local weapon_crit_fire = weapon_crit_fire_basic + weapon_crit_fire_item + weapon_crit_fire_buff + weapon_crit_fire_aura + weapon_crit_fire_tactic
	return weapon_crit_fire
end

--geyachao: 接口
--获得角色的装备暴击
_hu.GetWeaponCritEquip = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_equip_basic = attr.weapon_crit_equip_basic --基础装备暴击
	local weapon_crit_equip_item = attr.weapon_crit_equip_item --道具装备暴击
	local weapon_crit_equip_buff = attr.weapon_crit_equip_buff --buff装备暴击
	local weapon_crit_equip_aura = attr.weapon_crit_equip_aura --光环装备暴击
	local weapon_crit_equip_tactic = attr.weapon_crit_equip_tactic --战术技能卡装备暴击
	
	--print("GetWeaponCritEquip", weapon_crit_equip_basic, weapon_crit_equip_item, weapon_crit_equip_buff, weapon_crit_equip_aura, weapon_crit_equip_tactic)
	local weapon_crit_equip = weapon_crit_equip_basic + weapon_crit_equip_item + weapon_crit_equip_buff + weapon_crit_equip_aura + weapon_crit_equip_tactic
	return weapon_crit_equip
end

--geyachao: 接口
--获得角色的击退暴击
_hu.GetWeaponCritHit = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_hit_basic = attr.weapon_crit_hit_basic --基础击退暴击
	local weapon_crit_hit_item = attr.weapon_crit_hit_item --道具击退暴击
	local weapon_crit_hit_buff = attr.weapon_crit_hit_buff --buff击退暴击
	local weapon_crit_hit_aura = attr.weapon_crit_hit_aura --光环击退暴击
	local weapon_crit_hit_tactic = attr.weapon_crit_hit_tactic --战术技能卡击退暴击
	
	--print("GetWeaponCritHit", weapon_crit_hit_basic, weapon_crit_hit_item, weapon_crit_hit_buff, weapon_crit_hit_aura, weapon_crit_hit_tactic)
	local weapon_crit_hit = weapon_crit_hit_basic + weapon_crit_hit_item + weapon_crit_hit_buff + weapon_crit_hit_aura + weapon_crit_hit_tactic
	return weapon_crit_hit
end

--geyachao: 接口
--获得角色的吹风暴击
_hu.GetWeaponCritBlow = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_blow_basic = attr.weapon_crit_blow_basic --基础吹风暴击
	local weapon_crit_blow_item = attr.weapon_crit_blow_item --道具吹风暴击
	local weapon_crit_blow_buff = attr.weapon_crit_blow_buff --buff吹风暴击
	local weapon_crit_blow_aura = attr.weapon_crit_blow_aura --光环吹风暴击
	local weapon_crit_blow_tactic = attr.weapon_crit_blow_tactic --战术技能卡吹风暴击
	
	--print("GetWeaponCritBlow", weapon_crit_blow_basic, weapon_crit_blow_item, weapon_crit_blow_buff, weapon_crit_blow_aura, weapon_crit_blow_tactic)
	local weapon_crit_blow = weapon_crit_blow_basic + weapon_crit_blow_item + weapon_crit_blow_buff + weapon_crit_blow_aura + weapon_crit_blow_tactic
	return weapon_crit_blow
end

--geyachao: 接口
--获得角色的毒液暴击
_hu.GetWeaponCritPoison = function(self)
	local attr = self.attr --属性表
	
	local weapon_crit_poison_basic = attr.weapon_crit_poison_basic --基础毒液暴击
	local weapon_crit_poison_item = attr.weapon_crit_poison_item --道具毒液暴击
	local weapon_crit_poison_buff = attr.weapon_crit_poison_buff --buff毒液暴击
	local weapon_crit_poison_aura = attr.weapon_crit_poison_aura --光环毒液暴击
	local weapon_crit_poison_tactic = attr.weapon_crit_poison_tactic --战术技能卡毒液暴击
	
	--print("GetWeaponCritPoison", weapon_crit_poison_basic, weapon_crit_poison_item, weapon_crit_poison_buff, weapon_crit_poison_aura, weapon_crit_poison_tactic)
	local weapon_crit_poison = weapon_crit_poison_basic + weapon_crit_poison_item + weapon_crit_poison_buff + weapon_crit_poison_aura + weapon_crit_poison_tactic
	return weapon_crit_poison
end

--geyachao: 新接口，属性重算英雄装备的属性，附加到单位身上
_hu.AttrRecheckItem = function(self, tempAttr)
	local a = self.attr
	
	--道具属性相关
	local hp_max_item_add = 0 --道具附加血量
	local atk_item_add = 0 --道具附加攻击力
	local atk_min_add = 0
	local atk_max_add = 0
	local atk_interval_item_add = 0 --道具附加攻击间隔（毫秒）
	local atk_speed_item_add = 0 --道具附加攻击速度（去百分号后的值）
	local move_speed_item_add = 0 --道具附加移动速度
	local atk_radius_item_add = 0 --道具附加攻击范围
	local atk_radius_min_item_add = 0 --道具附加攻击范围最小值
	local def_physic_item_add = 0 --道具附加物防
	local def_magic_item_add = 0 --道具附加法防
	local dodge_rate_item_add = 0 --道具附加闪避几率（去百分号后的值）
	local hit_rate_item_add = 0 --道具附加命中几率（去百分号后的值）
	local crit_rate_item_add = 0 --道具附加暴击几率（去百分号后的值）
	local crit_value_item_add = 0.0 --道具附加暴击倍数（支持小数）
	local kill_gold_item_add = 0 --道具附加击杀获得的金币
	local escape_punish_item_add = 0 --道具附加逃怪惩罚
	local hp_restore_item_add = 0.0 --道具附加回血速度（每秒）（支持小数）
	local rebirth_time_item_add = 0 --道具附加复活时间（毫秒）
	local suck_blood_rate_item_add = 0 --道具吸血率（去百分号后的值）
	local active_skill_cd_delta_item_add = 0 --主动技能冷却时间变化值（毫秒）
	local passive_skill_cd_delta_item_add = 0 --被动技能冷却时间变化值（毫秒）
	local active_skill_cd_delta_rate_item_add = 0 --主动技能冷却时间变化比例值（去百分号后的值）
	local passive_skill_cd_delta_rate_item_add = 0 --被动技能冷却时间变化比例值（去百分号后的值）
	local AI_attribute_item_add = 0 --道具AI行为（0：被动怪 / 1:主动怪）
	local rebirth_wudi_time_add = 0 --复活后无敌时间（毫秒）
	local basic_weapon_level_add = 0 --基础武器等级
	local basic_skill_level_add = 0 --基础技能等级
	local atk_ice_item_add = 0 --道具附加冰攻击力
	local atk_thunder_item_add = 0 --道具附加雷攻击力
	local atk_fire_item_add = 0 --道具附加火攻击力
	local atk_poison_item_add = 0 --道具附加毒攻击力
	local atk_bullet_item_add = 0 --道具附加子弹攻击力
	local atk_bomb_item_add = 0 --道具附加爆炸攻击力
	local atk_chuanci_item_add = 0 --道具附加穿刺攻击力
	local def_ice_item_add = 0 --道具附加冰防御
	local def_thunder_item_add = 0 --道具附加雷防御
	local def_fire_item_add = 0 --道具附加火防御
	local def_poison_item_add = 0 --道具附加毒防御
	local def_bullet_item_add = 0 --道具附加子弹防御
	local def_bomb_item_add = 0 --道具附加爆炸防御
	local def_chuanci_item_add = 0 --道具附加穿刺防御
	local bullet_capacity_item_add = 0 --道具附加携弹数量
	local grenade_capacity_item_add = 0 --道具附加手雷数量
	local grenade_child_item_add = 0 --道具附加子母雷数量
	local grenade_fire_item_add = 0 --道具附加手雷爆炸火焰
	local grenade_dis_item_add = 0 --道具附加手雷投弹距离
	local grenade_cd_item_add = 0 --道具附加手雷冷却时间
	local grenade_crit_item_add = 0 --道具附加手雷暴击
	local grenade_multiply_item_add = 0 --道具附加手雷冷却前使用次数
	local inertia_item_add = 0 --道具附加惯性
	local crystal_rate_item_add = 0 --道具附加水晶收益率（去百分号后的值）
	local melee_bounce_item_add = 0 --道具附加近战弹开
	local melee_fight_item_add = 0 --道具附加近战反击
	local melee_stone_item_add = 0 --道具附加近战碎石
	local pet_hp_restore_item_add = 0 --道具附加宠物回血
	local pet_hp_item_add = 0 --道具附加宠物生命
	local pet_atk_item_add = 0 --道具附加宠物攻击
	local pet_atk_speed_item_add = 0 --宠物攻速
	local pet_capacity_item_add = 0 --道具附加宠物携带数量
	local trap_ground_item_add = 0 --道具附加陷阱时间（单位：毫秒）
	local trap_groundcd_item_add = 0 --道具附加陷阱施法间隔（单位：毫秒）
	local trap_groundenemy_item_add = 0 --道具附加陷阱困敌时间（单位：毫秒）
	local trap_fly_item_add = 0 --道具附加天网时间（单位：毫秒）
	local trap_flycd_item_add = 0 --道具附加天网施法间隔（单位：毫秒）
	local trap_flyenemy_item_add = 0 --道具附加天网困敌时间（单位：毫秒）
	local puzzle_item_add = 0 --道具附加迷惑几率（去百分号后的值）
	local weapon_crit_shoot_item_add = 0 --道具附加射击暴击
	local weapon_crit_frozen_item_add = 0 --道具附加冰冻暴击
	local weapon_crit_fire_item_add = 0 --道具附加火焰暴击
	local weapon_crit_equip_item_add = 0 --道具附加装备暴击
	local weapon_crit_hit_item_add = 0 --道具附加击退暴击
	local weapon_crit_blow_item_add = 0 --道具附加吹风暴击
	local weapon_crit_poison_item_add = 0 --道具附加毒液暴击
	
	--附加属性
	for i = 1, #tempAttr, 1 do
		if (type(tempAttr[i]) == "table") then
			--属性类型、值
			local typ, num = unpack(tempAttr[i])
			--print(typ, num)
			
			--修改英雄单位的属性值
			--单位附加当前值
			if (typ == "hp_max") then --血量
				hp_max_item_add = hp_max_item_add + num
			elseif (typ == "atk") then --攻击力
				atk_min_add = atk_min_add + num[1]
				atk_max_add = atk_max_add + num[2]
			elseif (typ == "atk_min") then --最小攻击力
				atk_min_add = atk_min_add + num
			elseif (typ == "atk_max") then --最大攻击力
				atk_max_add = atk_max_add + num
			elseif (typ == "atk_interval") then --攻击间隔（毫秒）
				atk_interval_item_add = atk_interval_item_add + num
			elseif (typ == "atk_speed") then --攻击速度（去百分号后的值）
				atk_speed_item_add = atk_speed_item_add + num
			elseif (typ == "move_speed") then --移动速度
				move_speed_item_add = move_speed_item_add + num
			elseif (typ == "atk_radius") then --攻击范围
				atk_radius_item_add = atk_radius_item_add + num
			elseif (typ == "atk_radius_min") then --攻击范围最小值
				atk_radius_min_item_add = atk_radius_min_item_add + num
			elseif (typ == "def_physic") then --物理防御
				def_physic_item_add = def_physic_item_add + num
			elseif (typ == "def_magic") then --法术防御
				def_magic_item_add = def_magic_item_add + num
			elseif (typ == "dodge_rate") then --闪避几率（去百分号后的值）
				dodge_rate_item_add = dodge_rate_item_add + num
			elseif (typ == "hit_rate") then --命中几率（去百分号后的值）
				hit_rate_item_add = hit_rate_item_add + num
			elseif (typ == "crit_rate") then --暴击几率（去百分号后的值）
				crit_rate_item_add = crit_rate_item_add + num
			elseif (typ == "crit_value") then --暴击倍数（支持小数）
				crit_value_item_add = crit_value_item_add + num
			elseif (typ == "kill_gold") then --击杀获得的金币
				kill_gold_item_add = kill_gold_item_add + num
			elseif (typ == "escape_punish") then --逃怪惩罚
				escape_punish_item_add = escape_punish_item_add + num
			elseif (typ == "hp_restore") then --回血速度（每秒）（支持小数）
				hp_restore_item_add = hp_restore_item_add + num
			elseif (typ == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
				AI_attribute_item_add = AI_attribute_item_add + num
			elseif (typ == "rebirth_wudi_time") then --复活后无敌时间（毫秒）
				rebirth_wudi_time_add = rebirth_wudi_time_add + num
			elseif (typ == "basic_weapon_level") then --基础武器等级
				basic_weapon_level_add = basic_weapon_level_add + num
			elseif (typ == "basic_skill_level") then --基础技能等级
				basic_skill_level_add = basic_skill_level_add + num
			elseif (typ == "rebirth_time") then --复活时间（毫秒）
				rebirth_time_item_add = rebirth_time_item_add + num
			elseif (typ == "suck_blood_rate") then --吸血率（去百分号后的值）
				suck_blood_rate_item_add = suck_blood_rate_item_add + num
			elseif (typ == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
				active_skill_cd_delta_item_add = active_skill_cd_delta_item_add + num
				--print(self.data.name, "active_skill_cd_delta_item_add=", num)
			elseif (typ == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
				passive_skill_cd_delta_item_add = passive_skill_cd_delta_item_add + num
			elseif (typ == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
				active_skill_cd_delta_rate_item_add = active_skill_cd_delta_rate_item_add + num
			elseif (typ == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
				passive_skill_cd_delta_rate_item_add = passive_skill_cd_delta_rate_item_add + num
			elseif (typ == "hp_max_rate") then --血量（去百分号后的值）
				local value = math.floor(a.hp_max_basic * num / 100)
				hp_max_item_add = hp_max_item_add + value
			elseif (typ == "atk_rate") then --攻击力（去百分号后的值）
				local value = math.floor(a.atk_basic * num / 100)
				atk_min_add = atk_min_add + value
				atk_max_add = atk_max_add + value
			elseif (typ == "atk_radius_rate") then --攻击范围（去百分号后的值）
				local value = math.floor(a.atk_radius_basic * num / 100)
				atk_radius_item_add = atk_radius_item_add + value
			elseif (typ == "atk_ice") then --冰攻击力
				atk_ice_item_add = atk_ice_item_add + num
			elseif (typ == "atk_thunder") then --雷攻击力
				atk_thunder_item_add = atk_thunder_item_add + num
			elseif (typ == "atk_fire") then --火攻击力
				atk_fire_item_add = atk_fire_item_add + num
			elseif (typ == "atk_poison") then --毒攻击力
				atk_poison_item_add = atk_poison_item_add + num
			elseif (typ == "atk_bullet") then --子弹攻击力
				atk_bullet_item_add = atk_bullet_item_add + num
			elseif (typ == "atk_bomb") then --爆炸攻击力
				atk_bomb_item_add = atk_bomb_item_add + num
			elseif (typ == "atk_chuanci") then --穿刺攻击力
				atk_chuanci_item_add = atk_chuanci_item_add + num
			elseif (typ == "def_ice") then --冰防御
				def_ice_item_add = def_ice_item_add + num
			elseif (typ == "def_thunder") then --雷防御
				def_thunder_item_add = def_thunder_item_add + num
			elseif (typ == "def_fire") then --火防御
				def_fire_item_add = def_fire_item_add + num
			elseif (typ == "def_poison") then --毒防御
				def_poison_item_add = def_poison_item_add + num
			elseif (typ == "def_bullet") then --子弹防御
				def_bullet_item_add = def_bullet_item_add + num
			elseif (typ == "def_bomb") then --爆炸防御
				def_bomb_item_add = def_bomb_item_add + num
			elseif (typ == "def_chuanci") then --穿刺防御
				def_chuanci_item_add = def_chuanci_item_add + num
			elseif (typ == "bullet_capacity") then --携弹数量
				bullet_capacity_item_add = bullet_capacity_item_add + num
			elseif (typ == "grenade_capacity") then --手雷数量
				grenade_capacity_item_add = grenade_capacity_item_add + num
			elseif (typ == "grenade_child") then --子母雷数量
				grenade_child_item_add = grenade_child_item_add + num
			elseif (typ == "grenade_fire") then --手雷爆炸火焰
				grenade_fire_item_add = grenade_fire_item_add + num
			elseif (typ == "grenade_dis") then --手雷投弹距离
				grenade_dis_item_add = grenade_dis_item_add + num
			elseif (typ == "grenade_cd") then --手雷冷却时间
				grenade_cd_item_add = grenade_cd_item_add + num
			elseif (typ == "grenade_crit") then --手雷暴击
				grenade_crit_item_add = grenade_crit_item_add + num
			elseif (typ == "grenade_multiply") then --手雷冷却前使用次数
				grenade_multiply_item_add = grenade_multiply_item_add + num
			elseif (typ == "inertia") then --惯性
				inertia_item_add = inertia_item_add + num
			elseif (typ == "crystal_rate") then --水晶收益率（去百分号后的值）
				crystal_rate_item_add = crystal_rate_item_add + num
			elseif (typ == "melee_bounce") then --近战弹开
				melee_bounce_item_add = melee_bounce_item_add + num
			elseif (typ == "melee_fight") then --近战反击
				melee_fight_item_add = melee_fight_item_add + num
			elseif (typ == "melee_stone") then --近战碎石
				melee_stone_item_add = melee_stone_item_add + num
			elseif (typ == "pet_hp_restore") then --宠物回血
				pet_hp_restore_item_add = pet_hp_restore_item_add + num
			elseif (typ == "pet_hp") then --宠物生命
				pet_hp_item_add = pet_hp_item_add + num
			elseif (typ == "pet_atk") then --宠物攻击
				pet_atk_item_add = pet_atk_item_add + num
			elseif (typ == "pet_atk_speed") then --宠物攻速
				pet_atk_speed_item_add = pet_atk_speed_item_add + num
			elseif (typ == "pet_capacity") then --宠物携带数量
				pet_capacity_item_add = pet_capacity_item_add + num
			elseif (typ == "trap_ground") then --陷阱时间（单位：毫秒）
				trap_ground_item_add = trap_ground_item_add + num
			elseif (typ == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
				trap_groundcd_item_add = trap_groundcd_item_add + num
			elseif (typ == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
				trap_groundenemy_item_add = trap_groundenemy_item_add + num
			elseif (typ == "trap_fly") then --天网时间（单位：毫秒）
				trap_fly_item_add = trap_fly_item_add + num
			elseif (typ == "trap_flycd") then --天网施法间隔（单位：毫秒）
				trap_flycd_item_add = trap_flycd_item_add + num
			elseif (typ == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
				trap_flyenemy_item_add = trap_flyenemy_item_add + num
			elseif (typ == "puzzle") then --迷惑几率（去百分号后的值）
				puzzle_item_add = puzzle_item_add + num
			elseif (typ == "weapon_crit_shoot") then --射击暴击
				weapon_crit_shoot_item_add = weapon_crit_shoot_item_add + num
			elseif (typ == "weapon_crit_frozen") then --冰冻暴击
				weapon_crit_frozen_item_add = weapon_crit_frozen_item_add + num
			elseif (typ == "weapon_crit_fire") then --火焰暴击
				weapon_crit_fire_item_add = weapon_crit_fire_item_add + num
			elseif (typ == "weapon_crit_equip") then --装备暴击
				weapon_crit_equip_item_add = weapon_crit_equip_item_add + num
			elseif (typ == "weapon_crit_hit") then --击退暴击
				weapon_crit_hit_item_add = weapon_crit_hit_item_add + num
			elseif (typ == "weapon_crit_blow") then --吹风暴击
				weapon_crit_blow_item_add = weapon_crit_blow_item_add + num
			elseif (typ == "weapon_crit_poison") then --毒液暴击
				weapon_crit_poison_item_add = weapon_crit_poison_item_add + num
			end
		end
	end
	
	local typeId = self.data.id --角色类型id
	--local tabA = hVar.tab_unit[typeId].attr --静态表角色属性表项
	--a.attack[4] = (tabA.attack and tabA.attack[4] or 0) + ((a.lv - 1) * a.atk_min_lvup) --攻击力最小值
	--a.attack[5] = (tabA.attack and tabA.attack[5] or 0) + ((a.lv - 1) * a.atk_max_lvup) --攻击力最大值
	--print(a.attack[4], a.attack[5])
	a.hp_max_item = hp_max_item_add --道具附加血量
	a.atk_item = math.floor((atk_min_add + atk_max_add) / 2) --道具附加攻击力
	--a.attack[4] = a.attack[4] + atk_min_add --攻击力最小值
	--a.attack[5] = a.attack[5] + atk_max_add --攻击力最大值
	a.atk_interval_item = atk_interval_item_add --道具附加攻击间隔（毫秒）
	a.atk_speed_item = atk_speed_item_add --道具附加攻击速度（去百分号后的值）
	a.move_speed_item = move_speed_item_add --道具附加移动速度
	a.atk_radius_item = atk_radius_item_add --道具附加攻击范围
	a.atk_radius_min_item = atk_radius_min_item_add --道具附加攻击范围最小值
	a.def_physic_item = def_physic_item_add --道具附加物防
	a.def_magic_item = def_magic_item_add --道具附加法防
	a.dodge_rate_item = dodge_rate_item_add --道具附加闪避几率（去百分号后的值）
	a.hit_rate_item = hit_rate_item_add --道具附加命中几率（去百分号后的值）
	a.crit_rate_item = crit_rate_item_add --道具附加暴击几率（去百分号后的值）
	a.crit_value_item = crit_value_item_add --道具附加暴击倍数（支持小数）
	a.kill_gold_item = kill_gold_item_add --道具附加击杀获得的金币
	a.escape_punish_item = escape_punish_item_add --道具附加逃怪惩罚
	a.hp_restore_item = hp_restore_item_add --道具附加回血速度（每秒）（支持小数）
	a.rebirth_time_item = rebirth_time_item_add --道具附加复活时间（毫秒）
	a.suck_blood_rate_item = suck_blood_rate_item_add --道具吸血率（去百分号后的值）
	a.active_skill_cd_delta_item = active_skill_cd_delta_item_add --主动技能冷却时间变化值（毫秒）
	a.passive_skill_cd_delta_item = passive_skill_cd_delta_item_add --被技能冷却时间变化值（毫秒）
	a.active_skill_cd_delta_rate_item = active_skill_cd_delta_rate_item_add --主动技能冷却时间变化比例值（去百分号后的值）
	a.passive_skill_cd_delta_rate_item = passive_skill_cd_delta_rate_item_add --被动技能冷却时间变化比例值（去百分号后的值）
	a.AI_attribute_item = AI_attribute_item_add --道具AI行为（0：被动怪 / 1:主动怪）
	a.rebirth_wudi_time_item = rebirth_wudi_time_add --复活后无敌时间（毫秒）
	a.basic_weapon_level_item = basic_weapon_level_add --基础武器等级
	a.basic_skill_level_item = basic_skill_level_add --基础技能等级
	a.atk_ice_item = atk_ice_item_add --道具附加冰攻击力
	a.atk_thunder_item = atk_thunder_item_add --道具附加雷攻击力
	a.atk_fire_item = atk_fire_item_add --道具附加火攻击力
	a.atk_poison_item = atk_poison_item_add --道具附加毒攻击力
	a.atk_bullet_item = atk_bullet_item_add --道具附加子弹攻击力
	a.atk_bomb_item = atk_bomb_item_add --道具附加爆炸攻击力
	a.atk_chuanci_item = atk_chuanci_item_add --道具附加穿刺攻击力
	a.def_ice_item = def_ice_item_add --道具附加冰防御
	a.def_thunder_item = def_thunder_item_add --道具附加雷防御
	a.def_fire_item = def_fire_item_add --道具附加火防御
	a.def_poison_item = def_poison_item_add --道具附加毒防御
	a.def_bullet_item = def_bullet_item_add --道具附加子弹防御
	a.def_bomb_item = def_bomb_item_add --道具附加爆炸防御
	a.def_chuanci_item = def_chuanci_item_add --道具附加穿刺防御
	a.bullet_capacity_item = bullet_capacity_item_add --道具附加携弹数量
	a.grenade_capacity_item = grenade_capacity_item_add --道具附加手雷数量
	a.grenade_child_item = grenade_child_item_add --道具附加子母雷数量
	a.grenade_fire_item = grenade_fire_item_add --道具附加手雷爆炸火焰
	a.grenade_dis_item = grenade_dis_item_add --道具附加手雷投弹距离
	a.grenade_cd_item = grenade_cd_item_add --道具附加手雷冷却时间
	a.grenade_crit_item = grenade_crit_item_add --道具附加手雷暴击
	a.grenade_multiply_item = grenade_multiply_item_add --道具附加手雷冷却前使用次数
	a.inertia_item = inertia_item_add --道具附加惯性
	a.crystal_rate_item = crystal_rate_item_add --道具附加水晶收益率（去百分号后的值）
	a.melee_bounce_item = melee_bounce_item_add --道具附加近战弹开
	a.melee_fight_item = melee_fight_item_add --道具附加近战反击
	a.melee_stone_item = melee_stone_item_add --道具附加近战碎石
	a.pet_hp_restore_item = pet_hp_restore_item_add --道具附加宠物回血
	a.pet_hp_item = pet_hp_item_add --道具附加宠物生命
	a.pet_atk_item = pet_atk_item_add --道具附加宠物攻击
	a.pet_atk_speed_item = pet_atk_speed_item_add --道具附加宠物攻速
	a.pet_capacity_item = pet_capacity_item_add --道具附加宠物携带数量
	a.trap_ground_item = trap_ground_item_add --道具附加陷阱时间（单位：毫秒）
	a.trap_groundcd_item = trap_groundcd_item_add --道具附加陷阱施法间隔（单位：毫秒）
	a.trap_groundenemy_item = trap_groundenemy_item_add --道具附加陷阱困敌时间（单位：毫秒）
	a.trap_fly_item = trap_fly_item_add --道具附加天网时间（单位：毫秒）
	a.trap_flycd_item = trap_flycd_item_add --道具附加天网施法间隔（单位：毫秒）
	a.trap_flyenemy_item = trap_flyenemy_item_add --道具附加天网困敌时间（单位：毫秒）
	a.puzzle_item = puzzle_item_add --道具附加迷惑几率（去百分号后的值）
	a.weapon_crit_shoot_item = weapon_crit_shoot_item_add --道具附加射击暴击
	a.weapon_crit_frozen_item = weapon_crit_frozen_item_add --道具附加冰冻暴击
	a.weapon_crit_fire_item = weapon_crit_fire_item_add --道具附加火焰暴击
	a.weapon_crit_equip_item = weapon_crit_equip_item_add --道具附加装备暴击
	a.weapon_crit_hit_item = weapon_crit_hit_item_add --道具附加击退暴击
	a.weapon_crit_blow_item = weapon_crit_blow_item_add --道具附加吹风暴击
	a.weapon_crit_poison_item = weapon_crit_poison_item_add --道具附加毒液暴击
	
	--不在本函数内部修改当前血量
	--a.hp = self:GetHpMax()
	
	--print(self.data.name, "hp_max_basic=" .. a.hp_max_basic .. ", attack[4]=" .. a.attack[4] .. ", attack[5] = " .. a.attack[5])
	
	--刷新单位的血条
	--更新血条控件
	if self.chaUI["hpBar"] then
		self.chaUI["hpBar"]:setV(self.attr.hp, self:GetHpMax())
	end
	if self.chaUI["numberBar"] then
		self.chaUI["numberBar"]:setText(self.attr.hp .. "/" .. self:GetHpMax())
	end
end

--geyachao: 接口
--获得角色是否在隐身状态
--返回值: 1(隐身) / 0(不是隐身)
_hu.GetYinShenState = function(self)
	local attr = self.attr --属性表
	
	local yinshen_state = attr.yinshen_state
	return yinshen_state
end

--geyachao: 接口
--设置角色是否在隐身状态
--参数: 1(隐身) / 0(不是隐身)
_hu.SetYinShenState = function(self, yinshen_state)
	--geyachao: 同步日志: 设置隐身
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "SetYinShenState: oUnit=" .. self.data.id .. ",u_ID=" .. self:getworldC() .. ",state=" .. tostring(yinshen_state)
		hApi.SyncLog(msg)
	end
	
	local attr = self.attr --属性表
	
	--不会重复设置相同的值
	if (attr.yinshen_state ~= yinshen_state) then
		local world = self:getworld()
		
		--进入隐身状态
		if (yinshen_state == 1) then
			--添加隐身的特效
			local effect_id = 118 --特效id --57 --144
			local eu_bx, eu_by, eu_bw, eu_bh = self:getbox() --单位的包围盒
			local offsetX = eu_bx + eu_bw / 2 --单位的偏移值x位置
			local offsetY = eu_by + eu_bh / 2 --单位的偏移值y位置
			local offsetZ = 0
			--local effect = world:addeffect(effect_id, -1, {hVar.EFFECT_TYPE.UNIT, 0, self, offsetZ}, offsetX, -offsetY) --geyachao: 暂时不要特效
			
			--存储隐身特效
			--self.attr.yinshen_effect = effect --geyachao: 暂时不要特效
			
			--设置隐身的透明度
			--self.handle.s:setOpacity(96)
			self.handle.s:setOpacity(1)
			
			--设置单位特效
			for i = 1, #self.data.effectsOnCreate, 1 do
				self.data.effectsOnCreate[i].handle._n:setVisible(false)
			end
			
			--隐身的单位不显示血条和数字显血文字
			if self.chaUI["hpBar"] then
				self.chaUI["hpBar"].handle._n:setVisible(false)
			end
			if self.chaUI["numberBar"] then
				self.chaUI["numberBar"].handle._n:setVisible(false)
			end
			
			--如果有敌方单位锁定它，那么取消锁定
			world:enumunit(function(eu)
				--敌方单位、锁定了角色
				if (eu.data.lockTarget == self) and (eu:getowner():getforce() ~= world:GetPlayerMe():getforce()) then
					--取消锁定
					--eu.data.lockTarget = 0
					hApi.UnitTryToLockTarget(eu, 0, 0)
				end
			end)
			
			--自己也不锁定别人
			--self.data.lockTarget = 0
			hApi.UnitTryToLockTarget(self, 0, 0)
		else --取消隐身状态
			--删除隐身特效
			local effect = self.attr.yinshen_effect
			if (effect ~= 0) then
				effect:del()
			end
			
			--标记没有隐身特效
			self.attr.yinshen_effect = 0
			
			--设置不隐身的透明度
			self.handle.s:setOpacity(254)
			
			--设置单位特效
			for i = 1, #self.data.effectsOnCreate, 1 do
				self.data.effectsOnCreate[i].handle._n:setVisible(true)
			end
			
			--不隐身的单位显示血条和数字显血文字
			if self.chaUI["hpBar"] then
				self.chaUI["hpBar"].handle._n:setVisible(true)
			end
			if self.chaUI["numberBar"] then
				self.chaUI["numberBar"].handle._n:setVisible(true)
			end
		end
		
		--标记
		attr.yinshen_state = yinshen_state
	end
end

--geyachao: 角色属性重算
_hu.__AttrRecheckBasic = function(self, param_tabA)
	local a = self.attr --属性表
	
	local level = a.lv --等级
	local star = a.star --星级
	local pvp_level = a.pvp_lv --pvp等级
	
	--先记录血量的比例
	local hpPercent = math.floor(a.hp / self:GetHpMax() * 100) / 100 --保留2位有效数字，用于同步
	
	--角色属性初始化
	local typeId = self.data.id --角色类型id
	local tabU = hVar.tab_unit[typeId]
	local tabA = param_tabA or tabU.attr or {} --静态表角色属性表项
	if tabA then
		--------------------------------
		--基础属性每级成长值
		--血量每级成长值
		a.hp_lvup = 0
		if tabA.hp_lvup then
			if (type(tabA.hp_lvup) == "number") then --每个星级的成长值都一样
				a.hp_lvup = tabA.hp_lvup
			elseif (type(tabA.hp_lvup) == "table") then --每个星级对应不同的成长值
				a.hp_lvup = tabA.hp_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--回血速度（每秒）每级成长值（支持小数）
		a.hp_restore_lvup = 0
		if tabA.hp_restore_lvup then
			if (type(tabA.hp_restore_lvup) == "number") then --每个星级的成长值都一样
				a.hp_restore_lvup = tabA.hp_restore_lvup
			elseif (type(tabA.hp_restore_lvup) == "table") then --每个星级对应不同的成长值
				a.hp_restore_lvup = tabA.hp_restore_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--移动速度每级成长值
		a.move_speed_lvup = 0
		if tabA.move_speed_lvup then
			if (type(tabA.move_speed_lvup) == "number") then --每个星级的成长值都一样
				a.move_speed_lvup = tabA.move_speed_lvup
			elseif (type(tabA.move_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.move_speed_lvup = tabA.move_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--最小攻击力每级成长值
		a.atk_min_lvup = 0
		if tabA.atk_min_lvup then
			if (type(tabA.atk_min_lvup) == "number") then --每个星级的成长值都一样
				a.atk_min_lvup = tabA.atk_min_lvup
			elseif (type(tabA.atk_min_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_min_lvup = tabA.atk_min_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--最大攻击力每级成长值
		a.atk_max_lvup = 0
		if tabA.atk_max_lvup then
			if (type(tabA.atk_max_lvup) == "number") then --每个星级的成长值都一样
				a.atk_max_lvup = tabA.atk_max_lvup
			elseif (type(tabA.atk_max_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_max_lvup = tabA.atk_max_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--冰攻击力每级成长值
		a.atk_ice_lvup = 0
		if tabA.atk_ice_lvup then
			if (type(tabA.atk_ice_lvup) == "number") then --每个星级的成长值都一样
				a.atk_ice_lvup = tabA.atk_ice_lvup
			elseif (type(tabA.atk_ice_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_ice_lvup = tabA.atk_ice_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--雷攻击力每级成长值
		a.atk_thunder_lvup = 0
		if tabA.atk_thunder_lvup then
			if (type(tabA.atk_thunder_lvup) == "number") then --每个星级的成长值都一样
				a.atk_thunder_lvup = tabA.atk_thunder_lvup
			elseif (type(tabA.atk_thunder_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_thunder_lvup = tabA.atk_thunder_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--火攻击力每级成长值
		a.atk_fire_lvup = 0
		if tabA.atk_fire_lvup then
			if (type(tabA.atk_fire_lvup) == "number") then --每个星级的成长值都一样
				a.atk_fire_lvup = tabA.atk_fire_lvup
			elseif (type(tabA.atk_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_fire_lvup = tabA.atk_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--毒攻击力每级成长值
		a.atk_poison_lvup = 0
		if tabA.atk_poison_lvup then
			if (type(tabA.atk_poison_lvup) == "number") then --每个星级的成长值都一样
				a.atk_poison_lvup = tabA.atk_poison_lvup
			elseif (type(tabA.atk_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_poison_lvup = tabA.atk_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--子弹攻击力每级成长值
		a.atk_bullet_lvup = 0
		if tabA.atk_bullet_lvup then
			if (type(tabA.atk_bullet_lvup) == "number") then --每个星级的成长值都一样
				a.atk_bullet_lvup = tabA.atk_bullet_lvup
			elseif (type(tabA.atk_bullet_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_bullet_lvup = tabA.atk_bullet_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--爆炸攻击力每级成长值
		a.atk_bomb_lvup = 0
		if tabA.atk_bomb_lvup then
			if (type(tabA.atk_bomb_lvup) == "number") then --每个星级的成长值都一样
				a.atk_bomb_lvup = tabA.atk_bomb_lvup
			elseif (type(tabA.atk_bomb_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_bomb_lvup = tabA.atk_bomb_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--穿刺攻击力每级成长值
		a.atk_chuanci_lvup = 0
		if tabA.atk_chuanci_lvup then
			if (type(tabA.atk_chuanci_lvup) == "number") then --每个星级的成长值都一样
				a.atk_chuanci_lvup = tabA.atk_chuanci_lvup
			elseif (type(tabA.atk_chuanci_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_chuanci_lvup = tabA.atk_chuanci_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--攻击间隔每级成长值
		a.atk_interval_lvup = 0
		if tabA.atk_interval_lvup then
			if (type(tabA.atk_interval_lvup) == "number") then --每个星级的成长值都一样
				a.atk_interval_lvup = tabA.atk_interval_lvup
			elseif (type(tabA.atk_interval_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_interval_lvup = tabA.atk_interval_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--攻击速度每级成长值
		a.atk_speed_lvup = 0
		if tabA.atk_speed_lvup then
			if (type(tabA.atk_speed_lvup) == "number") then --每个星级的成长值都一样
				a.atk_speed_lvup = tabA.atk_speed_lvup
			elseif (type(tabA.atk_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_speed_lvup = tabA.atk_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--攻击范围每级成长值
		a.atk_radius_lvup = 0
		if tabA.atk_radius_lvup then
			if (type(tabA.atk_radius_lvup) == "number") then --每个星级的成长值都一样
				a.atk_radius_lvup = tabA.atk_radius_lvup
			elseif (type(tabA.atk_radius_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_radius_lvup = tabA.atk_radius_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--攻击范围最小值每级成长值
		a.atk_radius_min_lvup = 0
		if tabA.atk_radius_min_lvup then
			if (type(tabA.atk_radius_min_lvup) == "number") then --每个星级的成长值都一样
				a.atk_radius_min_lvup = tabA.atk_radius_min_lvup
			elseif (type(tabA.atk_radius_min_lvup) == "table") then --每个星级对应不同的成长值
				a.atk_radius_min_lvup = tabA.atk_radius_min_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--物防每级成长值
		a.def_physic_lvup = 0
		if tabA.def_physic_lvup then
			if (type(tabA.def_physic_lvup) == "number") then --每个星级的成长值都一样
				a.def_physic_lvup = tabA.def_physic_lvup
			elseif (type(tabA.def_physic_lvup) == "table") then --每个星级对应不同的成长值
				a.def_physic_lvup = tabA.def_physic_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--法防每级成长值
		a.def_magic_lvup = 0
		if tabA.def_magic_lvup then
			if (type(tabA.def_magic_lvup) == "number") then --每个星级的成长值都一样
				a.def_magic_lvup = tabA.def_magic_lvup
			elseif (type(tabA.def_magic_lvup) == "table") then --每个星级对应不同的成长值
				a.def_magic_lvup = tabA.def_magic_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--冰防每级成长值
		a.def_ice_lvup = 0
		if tabA.def_ice_lvup then
			if (type(tabA.def_ice_lvup) == "number") then --每个星级的成长值都一样
				a.def_ice_lvup = tabA.def_ice_lvup
			elseif (type(tabA.def_ice_lvup) == "table") then --每个星级对应不同的成长值
				a.def_ice_lvup = tabA.def_ice_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--雷防每级成长值
		a.def_thunder_lvup = 0
		if tabA.def_thunder_lvup then
			if (type(tabA.def_thunder_lvup) == "number") then --每个星级的成长值都一样
				a.def_thunder_lvup = tabA.def_thunder_lvup
			elseif (type(tabA.def_thunder_lvup) == "table") then --每个星级对应不同的成长值
				a.def_thunder_lvup = tabA.def_thunder_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--火防每级成长值
		a.def_fire_lvup = 0
		if tabA.def_fire_lvup then
			if (type(tabA.def_fire_lvup) == "number") then --每个星级的成长值都一样
				a.def_fire_lvup = tabA.def_fire_lvup
			elseif (type(tabA.def_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.def_fire_lvup = tabA.def_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--毒防每级成长值
		a.def_poison_lvup = 0
		if tabA.def_poison_lvup then
			if (type(tabA.def_poison_lvup) == "number") then --每个星级的成长值都一样
				a.def_poison_lvup = tabA.def_poison_lvup
			elseif (type(tabA.def_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.def_poison_lvup = tabA.def_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--子弹防每级成长值
		a.def_bullet_lvup = 0
		if tabA.def_bullet_lvup then
			if (type(tabA.def_bullet_lvup) == "number") then --每个星级的成长值都一样
				a.def_bullet_lvup = tabA.def_bullet_lvup
			elseif (type(tabA.def_bullet_lvup) == "table") then --每个星级对应不同的成长值
				a.def_bullet_lvup = tabA.def_bullet_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--爆炸防每级成长值
		a.def_bomb_lvup = 0
		if tabA.def_bomb_lvup then
			if (type(tabA.def_bomb_lvup) == "number") then --每个星级的成长值都一样
				a.def_bomb_lvup = tabA.def_bomb_lvup
			elseif (type(tabA.def_bomb_lvup) == "table") then --每个星级对应不同的成长值
				a.def_bomb_lvup = tabA.def_bomb_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--穿刺防每级成长值
		a.def_chuanci_lvup = 0
		if tabA.def_chuanci_lvup then
			if (type(tabA.def_chuanci_lvup) == "number") then --每个星级的成长值都一样
				a.def_chuanci_lvup = tabA.def_chuanci_lvup
			elseif (type(tabA.def_chuanci_lvup) == "table") then --每个星级对应不同的成长值
				a.def_chuanci_lvup = tabA.def_chuanci_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--携弹数量每级成长值
		a.bullet_capacity_lvup = 0
		if tabA.bullet_capacity_lvup then
			if (type(tabA.bullet_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.bullet_capacity_lvup = tabA.bullet_capacity_lvup
			elseif (type(tabA.bullet_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.bullet_capacity_lvup = tabA.bullet_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷数量每级成长值
		a.grenade_capacity_lvup = 0
		if tabA.grenade_capacity_lvup then
			if (type(tabA.grenade_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_capacity_lvup = tabA.grenade_capacity_lvup
			elseif (type(tabA.grenade_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_capacity_lvup = tabA.grenade_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--子母雷数量每级成长值
		a.grenade_child_lvup = 0
		if tabA.grenade_child_lvup then
			if (type(tabA.grenade_child_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_child_lvup = tabA.grenade_child_lvup
			elseif (type(tabA.grenade_child_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_child_lvup = tabA.grenade_child_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷爆炸火焰每级成长值
		a.grenade_fire_lvup = 0
		if tabA.grenade_fire_lvup then
			if (type(tabA.grenade_fire_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_fire_lvup = tabA.grenade_fire_lvup
			elseif (type(tabA.grenade_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_fire_lvup = tabA.grenade_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷投弹距离每级成长值
		a.grenade_dis_lvup = 0
		if tabA.grenade_dis_lvup then
			if (type(tabA.grenade_dis_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_dis_lvup = tabA.grenade_dis_lvup
			elseif (type(tabA.grenade_dis_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_dis_lvup = tabA.grenade_dis_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷冷却时间每级成长值
		a.grenade_cd_lvup = 0
		if tabA.grenade_cd_lvup then
			if (type(tabA.grenade_cd_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_cd_lvup = tabA.grenade_cd_lvup
			elseif (type(tabA.grenade_cd_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_cd_lvup = tabA.grenade_cd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷暴击每级成长值
		a.grenade_crit_lvup = 0
		if tabA.grenade_crit_lvup then
			if (type(tabA.grenade_crit_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_crit_lvup = tabA.grenade_crit_lvup
			elseif (type(tabA.grenade_crit_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_crit_lvup = tabA.grenade_crit_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--手雷冷却前使用次数每级成长值
		a.grenade_multiply_lvup = 0
		if tabA.grenade_multiply_lvup then
			if (type(tabA.grenade_multiply_lvup) == "number") then --每个星级的成长值都一样
				a.grenade_multiply_lvup = tabA.grenade_multiply_lvup
			elseif (type(tabA.grenade_multiply_lvup) == "table") then --每个星级对应不同的成长值
				a.grenade_multiply_lvup = tabA.grenade_multiply_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--惯性每级成长值
		a.inertia_lvup = 0
		if tabA.inertia_lvup then
			if (type(tabA.inertia_lvup) == "number") then --每个星级的成长值都一样
				a.inertia_lvup = tabA.inertia_lvup
			elseif (type(tabA.inertia_lvup) == "table") then --每个星级对应不同的成长值
				a.inertia_lvup = tabA.inertia_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--水晶收益率（去百分号后的值）每级成长值
		a.crystal_rate_lvup = 0
		if tabA.crystal_rate_lvup then
			if (type(tabA.crystal_rate_lvup) == "number") then --每个星级的成长值都一样
				a.crystal_rate_lvup = tabA.crystal_rate_lvup
			elseif (type(tabA.crystal_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.crystal_rate_lvup = tabA.crystal_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--近战弹开每级成长值
		a.melee_bounce_lvup = 0
		if tabA.melee_bounce_lvup then
			if (type(tabA.melee_bounce_lvup) == "number") then --每个星级的成长值都一样
				a.melee_bounce_lvup = tabA.melee_bounce_lvup
			elseif (type(tabA.melee_bounce_lvup) == "table") then --每个星级对应不同的成长值
				a.melee_bounce_lvup = tabA.melee_bounce_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--近战反击每级成长值
		a.melee_fight_lvup = 0
		if tabA.melee_fight_lvup then
			if (type(tabA.melee_fight_lvup) == "number") then --每个星级的成长值都一样
				a.melee_fight_lvup = tabA.melee_fight_lvup
			elseif (type(tabA.melee_fight_lvup) == "table") then --每个星级对应不同的成长值
				a.melee_fight_lvup = tabA.melee_fight_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--近战碎石每级成长值
		a.melee_stone_lvup = 0
		if tabA.melee_stone_lvup then
			if (type(tabA.melee_stone_lvup) == "number") then --每个星级的成长值都一样
				a.melee_stone_lvup = tabA.melee_stone_lvup
			elseif (type(tabA.melee_stone_lvup) == "table") then --每个星级对应不同的成长值
				a.melee_stone_lvup = tabA.melee_stone_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础闪避几率（去百分号后的值）每级成长值
		a.dodge_rate_lvup = 0
		if tabA.dodge_rate_lvup then
			if (type(tabA.dodge_rate_lvup) == "number") then --每个星级的成长值都一样
				a.dodge_rate_lvup = tabA.dodge_rate_lvup
			elseif (type(tabA.dodge_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.dodge_rate_lvup = tabA.dodge_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础命中几率（去百分号后的值）每级成长值
		a.hit_rate_lvup = 0
		--print("基础命中几率（去百分号后的值）每级成长值", self.data.name, a.hit_rate_lvup)
		if tabA.hit_rate_lvup then
			if (type(tabA.hit_rate_lvup) == "number") then --每个星级的成长值都一样
				a.hit_rate_lvup = tabA.hit_rate_lvup
			elseif (type(tabA.hit_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.hit_rate_lvup = tabA.hit_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础暴击几率（去百分号后的值）每级成长值
		a.crit_rate_lvup = 0
		if tabA.crit_rate_lvup then
			if (type(tabA.crit_rate_lvup) == "number") then --每个星级的成长值都一样
				a.crit_rate_lvup = tabA.crit_rate_lvup
			elseif (type(tabA.crit_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.crit_rate_lvup = tabA.crit_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础暴击倍数每级成长值（支持小数）
		a.crit_value_lvup = 0.0
		if tabA.crit_value_lvup then
			if (type(tabA.crit_value_lvup) == "number") then --每个星级的成长值都一样
				a.crit_value_lvup = tabA.crit_value_lvup
			elseif (type(tabA.crit_value_lvup) == "table") then --每个星级对应不同的成长值
				a.crit_value_lvup = tabA.crit_value_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础复活时间每级成长值（毫秒）
		a.rebirth_time_lvup = 0
		if tabA.rebirth_time_lvup then
			if (type(tabA.rebirth_time_lvup) == "number") then --每个星级的成长值都一样
				a.rebirth_time_lvup = tabA.rebirth_time_lvup
			elseif (type(tabA.rebirth_time_lvup) == "table") then --每个星级对应不同的成长值
				a.rebirth_time_lvup = tabA.rebirth_time_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础吸血率每级成长值（去百分号后的值）
		a.suck_blood_rate_lvup = 0
		if tabA.suck_blood_rate_lvup then
			if (type(tabA.suck_blood_rate_lvup) == "number") then --每个星级的成长值都一样
				a.suck_blood_rate_lvup = tabA.suck_blood_rate_lvup
			elseif (type(tabA.suck_blood_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.suck_blood_rate_lvup = tabA.suck_blood_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础主动技能冷却时间变化值每级成长值（毫秒）
		a.active_skill_cd_delta_lvup = 0
		if tabA.active_skill_cd_delta_lvup then
			if (type(tabA.active_skill_cd_delta_lvup) == "number") then --每个星级的成长值都一样
				a.active_skill_cd_delta_lvup = tabA.active_skill_cd_delta_lvup
			elseif (type(tabA.active_skill_cd_delta_lvup) == "table") then --每个星级对应不同的成长值
				a.active_skill_cd_delta_lvup = tabA.active_skill_cd_delta_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础被动技能冷却时间变化值每级成长值（毫秒）
		a.passive_skill_cd_delta_lvup = 0
		if tabA.passive_skill_cd_delta_lvup then
			if (type(tabA.passive_skill_cd_delta_lvup) == "number") then --每个星级的成长值都一样
				a.passive_skill_cd_delta_lvup = tabA.passive_skill_cd_delta_lvup
			elseif (type(tabA.passive_skill_cd_delta_lvup) == "table") then --每个星级对应不同的成长值
				a.passive_skill_cd_delta_lvup = tabA.passive_skill_cd_delta_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础宠物回血每级成长值
		a.pet_hp_restore_lvup = 0
		if tabA.pet_hp_restore_lvup then
			if (type(tabA.pet_hp_restore_lvup) == "number") then --每个星级的成长值都一样
				a.pet_hp_restore_lvup = tabA.pet_hp_restore_lvup
			elseif (type(tabA.pet_hp_restore_lvup) == "table") then --每个星级对应不同的成长值
				a.pet_hp_restore_lvup = tabA.pet_hp_restore_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础宠物生命每级成长值
		a.pet_hp_lvup = 0
		if tabA.pet_hp_lvup then
			if (type(tabA.pet_hp_lvup) == "number") then --每个星级的成长值都一样
				a.pet_hp_lvup = tabA.pet_hp_lvup
			elseif (type(tabA.pet_hp_lvup) == "table") then --每个星级对应不同的成长值
				a.pet_hp_lvup = tabA.pet_hp_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础宠物攻击每级成长值
		a.pet_atk_lvup = 0
		if tabA.pet_atk_lvup then
			if (type(tabA.pet_atk_lvup) == "number") then --每个星级的成长值都一样
				a.pet_atk_lvup = tabA.pet_atk_lvup
			elseif (type(tabA.pet_atk_lvup) == "table") then --每个星级对应不同的成长值
				a.pet_atk_lvup = tabA.pet_atk_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础宠物攻速每级成长值
		a.pet_atk_speed_lvup = 0
		if tabA.pet_atk_speed_lvup then
			if (type(tabA.pet_atk_speed_lvup) == "number") then --每个星级的成长值都一样
				a.pet_atk_speed_lvup = tabA.pet_atk_speed_lvup
			elseif (type(tabA.pet_atk_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.pet_atk_speed_lvup = tabA.pet_atk_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础宠物携带数量每级成长值
		a.pet_capacity_lvup = 0
		if tabA.pet_capacity_lvup then
			if (type(tabA.pet_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.pet_capacity_lvup = tabA.pet_capacity_lvup
			elseif (type(tabA.pet_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.pet_capacity_lvup = tabA.pet_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础陷阱时间（单位：毫秒）每级成长值
		a.trap_ground_lvup = 0
		if tabA.trap_ground_lvup then
			if (type(tabA.trap_ground_lvup) == "number") then --每个星级的成长值都一样
				a.trap_ground_lvup = tabA.trap_ground_lvup
			elseif (type(tabA.trap_ground_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_ground_lvup = tabA.trap_ground_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		
		--基础陷阱施法间隔（单位：毫秒）每级成长值
		a.trap_groundcd_lvup = 0
		if tabA.trap_groundcd_lvup then
			if (type(tabA.trap_groundcd_lvup) == "number") then --每个星级的成长值都一样
				a.trap_groundcd_lvup = tabA.trap_groundcd_lvup
			elseif (type(tabA.trap_groundcd_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_groundcd_lvup = tabA.trap_groundcd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础陷阱困敌时间（单位：毫秒）每级成长值
		a.trap_groundenemy_lvup = 0
		if tabA.trap_groundenemy_lvup then
			if (type(tabA.trap_groundenemy_lvup) == "number") then --每个星级的成长值都一样
				a.trap_groundenemy_lvup = tabA.trap_groundenemy_lvup
			elseif (type(tabA.trap_groundenemy_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_groundenemy_lvup = tabA.trap_groundenemy_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础天网时间（单位：毫秒）每级成长值
		a.trap_fly_lvup = 0
		if tabA.trap_fly_lvup then
			if (type(tabA.trap_fly_lvup) == "number") then --每个星级的成长值都一样
				a.trap_fly_lvup = tabA.trap_fly_lvup
			elseif (type(tabA.trap_fly_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_fly_lvup = tabA.trap_fly_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础天网施法间隔（单位：毫秒）每级成长值
		a.trap_flycd_lvup = 0
		if tabA.trap_flycd_lvup then
			if (type(tabA.trap_flycd_lvup) == "number") then --每个星级的成长值都一样
				a.trap_flycd_lvup = tabA.trap_flycd_lvup
			elseif (type(tabA.trap_flycd_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_flycd_lvup = tabA.trap_flycd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础天网困敌时间（单位：毫秒）每级成长值
		a.trap_flyenemy_lvup = 0
		if tabA.trap_flyenemy_lvup then
			if (type(tabA.trap_flyenemy_lvup) == "number") then --每个星级的成长值都一样
				a.trap_flyenemy_lvup = tabA.trap_flyenemy_lvup
			elseif (type(tabA.trap_flyenemy_lvup) == "table") then --每个星级对应不同的成长值
				a.trap_flyenemy_lvup = tabA.trap_flyenemy_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础迷惑几率（去百分号后的值）每级成长值
		a.puzzle_lvup = 0
		if tabA.puzzle_lvup then
			if (type(tabA.puzzle_lvup) == "number") then --每个星级的成长值都一样
				a.puzzle_lvup = tabA.puzzle_lvup
			elseif (type(tabA.puzzle_lvup) == "table") then --每个星级对应不同的成长值
				a.puzzle_lvup = tabA.puzzle_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础射击暴击每级成长值
		a.weapon_crit_shoot_lvup = 0
		if tabA.weapon_crit_shoot_lvup then
			if (type(tabA.weapon_crit_shoot_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_shoot_lvup = tabA.weapon_crit_shoot_lvup
			elseif (type(tabA.weapon_crit_shoot_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_shoot_lvup = tabA.weapon_crit_shoot_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础冰冻暴击每级成长值
		a.weapon_crit_frozen_lvup = 0
		if tabA.weapon_crit_frozen_lvup then
			if (type(tabA.weapon_crit_frozen_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_frozen_lvup = tabA.weapon_crit_frozen_lvup
			elseif (type(tabA.weapon_crit_frozen_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_frozen_lvup = tabA.weapon_crit_frozen_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础火焰暴击每级成长值
		a.weapon_crit_fire_lvup = 0
		if tabA.weapon_crit_fire_lvup then
			if (type(tabA.weapon_crit_fire_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_fire_lvup = tabA.weapon_crit_fire_lvup
			elseif (type(tabA.weapon_crit_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_fire_lvup = tabA.weapon_crit_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础装备暴击每级成长值
		a.weapon_crit_equip_lvup = 0
		if tabA.weapon_crit_equip_lvup then
			if (type(tabA.weapon_crit_equip_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_equip_lvup = tabA.weapon_crit_equip_lvup
			elseif (type(tabA.weapon_crit_equip_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_equip_lvup = tabA.weapon_crit_equip_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础击退暴击每级成长值
		a.weapon_crit_hit_lvup = 0
		if tabA.weapon_crit_hit_lvup then
			if (type(tabA.weapon_crit_hit_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_hit_lvup = tabA.weapon_crit_hit_lvup
			elseif (type(tabA.weapon_crit_hit_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_hit_lvup = tabA.weapon_crit_hit_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础吹风暴击每级成长值
		a.weapon_crit_blow_lvup = 0
		if tabA.weapon_crit_blow_lvup then
			if (type(tabA.weapon_crit_blow_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_blow_lvup = tabA.weapon_crit_blow_lvup
			elseif (type(tabA.weapon_crit_blow_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_blow_lvup = tabA.weapon_crit_blow_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--基础毒液暴击每级成长值
		a.weapon_crit_poison_lvup = 0
		if tabA.weapon_crit_poison_lvup then
			if (type(tabA.weapon_crit_poison_lvup) == "number") then --每个星级的成长值都一样
				a.weapon_crit_poison_lvup = tabA.weapon_crit_poison_lvup
			elseif (type(tabA.weapon_crit_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.weapon_crit_poison_lvup = tabA.weapon_crit_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--------------------------------
		--pvp属性每级成长值
		--pvp血量每级成长值
		a.pvp_hp_lvup = 0
		if tabA.pvp_hp_lvup then
			if (type(tabA.pvp_hp_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_hp_lvup = tabA.pvp_hp_lvup
			elseif (type(tabA.pvp_hp_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_hp_lvup = tabA.pvp_hp_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp回血速度（每秒）每级成长值（支持小数）
		a.pvp_hp_restore_lvup = 0
		if tabA.pvp_hp_restore_lvup then
			if (type(tabA.pvp_hp_restore_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_hp_restore_lvup = tabA.pvp_hp_restore_lvup
			elseif (type(tabA.pvp_hp_restore_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_hp_restore_lvup = tabA.pvp_hp_restore_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp移动速度每级成长值
		a.pvp_move_speed_lvup = 0
		if tabA.pvp_move_speed_lvup then
			if (type(tabA.pvp_move_speed_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_move_speed_lvup = tabA.pvp_move_speed_lvup
			elseif (type(tabA.pvp_move_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_move_speed_lvup = tabA.pvp_move_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp最小攻击力每级成长值
		a.pvp_atk_min_lvup = 0
		if tabA.pvp_atk_min_lvup then
			if (type(tabA.pvp_atk_min_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_min_lvup = tabA.pvp_atk_min_lvup
			elseif (type(tabA.pvp_atk_min_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_min_lvup = tabA.pvp_atk_min_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp最大攻击力每级成长值
		a.pvp_atk_max_lvup = 0
		if tabA.pvp_atk_max_lvup then
			if (type(tabA.pvp_atk_max_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_max_lvup = tabA.pvp_atk_max_lvup
			elseif (type(tabA.pvp_atk_max_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_max_lvup = tabA.pvp_atk_max_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp冰攻击力每级成长值
		a.pvp_atk_ice_lvup = 0
		if tabA.pvp_atk_ice_lvup then
			if (type(tabA.pvp_atk_ice_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_ice_lvup = tabA.pvp_atk_ice_lvup
			elseif (type(tabA.pvp_atk_ice_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_ice_lvup = tabA.pvp_atk_ice_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp雷攻击力每级成长值
		a.pvp_atk_thunder_lvup = 0
		if tabA.pvp_atk_thunder_lvup then
			if (type(tabA.pvp_atk_thunder_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_thunder_lvup = tabA.pvp_atk_thunder_lvup
			elseif (type(tabA.pvp_atk_thunder_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_thunder_lvup = tabA.pvp_atk_thunder_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp火攻击力每级成长值
		a.pvp_atk_fire_lvup = 0
		if tabA.pvp_atk_fire_lvup then
			if (type(tabA.pvp_atk_fire_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_fire_lvup = tabA.pvp_atk_fire_lvup
			elseif (type(tabA.pvp_atk_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_fire_lvup = tabA.pvp_atk_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp毒攻击力每级成长值
		a.pvp_atk_poison_lvup = 0
		if tabA.pvp_atk_poison_lvup then
			if (type(tabA.pvp_atk_poison_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_poison_lvup = tabA.pvp_atk_poison_lvup
			elseif (type(tabA.pvp_atk_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_poison_lvup = tabA.pvp_atk_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp子弹攻击力每级成长值
		a.pvp_atk_bullet_lvup = 0
		if tabA.pvp_atk_bullet_lvup then
			if (type(tabA.pvp_atk_bullet_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_bullet_lvup = tabA.pvp_atk_bullet_lvup
			elseif (type(tabA.pvp_atk_bullet_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_bullet_lvup = tabA.pvp_atk_bullet_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp爆炸攻击力每级成长值
		a.pvp_atk_bomb_lvup = 0
		if tabA.pvp_atk_bomb_lvup then
			if (type(tabA.pvp_atk_bomb_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_bomb_lvup = tabA.pvp_atk_bomb_lvup
			elseif (type(tabA.pvp_atk_bomb_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_bomb_lvup = tabA.pvp_atk_bomb_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp穿刺攻击力每级成长值
		a.pvp_atk_chuanci_lvup = 0
		if tabA.pvp_atk_chuanci_lvup then
			if (type(tabA.pvp_atk_chuanci_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_chuanci_lvup = tabA.pvp_atk_chuanci_lvup
			elseif (type(tabA.pvp_atk_chuanci_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_chuanci_lvup = tabA.pvp_atk_chuanci_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp攻击间隔每级成长值
		a.pvp_atk_interval_lvup = 0
		if tabA.pvp_atk_interval_lvup then
			if (type(tabA.pvp_atk_interval_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_interval_lvup = tabA.pvp_atk_interval_lvup
			elseif (type(tabA.pvp_atk_interval_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_interval_lvup = tabA.pvp_atk_interval_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp攻击速度每级成长值
		a.pvp_atk_speed_lvup = 0
		if tabA.pvp_atk_speed_lvup then
			if (type(tabA.pvp_atk_speed_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_speed_lvup = tabA.pvp_atk_speed_lvup
			elseif (type(tabA.pvp_atk_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_speed_lvup = tabA.pvp_atk_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp攻击范围每级成长值
		a.pvp_atk_radius_lvup = 0
		if tabA.pvp_atk_radius_lvup then
			if (type(tabA.pvp_atk_radius_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_radius_lvup = tabA.pvp_atk_radius_lvup
			elseif (type(tabA.pvp_atk_radius_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_radius_lvup = tabA.pvp_atk_radius_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--攻击范围最小值每级成长值
		a.pvp_atk_radius_min_lvup = 0
		if tabA.pvp_atk_radius_min_lvup then
			if (type(tabA.pvp_atk_radius_min_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_atk_radius_min_lvup = tabA.pvp_atk_radius_min_lvup
			elseif (type(tabA.pvp_atk_radius_min_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_atk_radius_min_lvup = tabA.pvp_atk_radius_min_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp物防每级成长值
		a.pvp_def_physic_lvup = 0
		if tabA.pvp_def_physic_lvup then
			if (type(tabA.pvp_def_physic_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_physic_lvup = tabA.pvp_def_physic_lvup
			elseif (type(tabA.pvp_def_physic_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_physic_lvup = tabA.pvp_def_physic_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp法防每级成长值
		a.pvp_def_magic_lvup = 0
		if tabA.pvp_def_magic_lvup then
			if (type(tabA.pvp_def_magic_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_magic_lvup = tabA.pvp_def_magic_lvup
			elseif (type(tabA.pvp_def_magic_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_magic_lvup = tabA.pvp_def_magic_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp冰防每级成长值
		a.pvp_def_ice_lvup = 0
		if tabA.pvp_def_ice_lvup then
			if (type(tabA.pvp_def_ice_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_ice_lvup = tabA.pvp_def_ice_lvup
			elseif (type(tabA.pvp_def_ice_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_ice_lvup = tabA.pvp_def_ice_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp雷防每级成长值
		a.pvp_def_thunder_lvup = 0
		if tabA.pvp_def_thunder_lvup then
			if (type(tabA.pvp_def_thunder_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_thunder_lvup = tabA.pvp_def_thunder_lvup
			elseif (type(tabA.pvp_def_thunder_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_thunder_lvup = tabA.pvp_def_thunder_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp火防每级成长值
		a.pvp_def_fire_lvup = 0
		if tabA.pvp_def_fire_lvup then
			if (type(tabA.pvp_def_fire_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_fire_lvup = tabA.pvp_def_fire_lvup
			elseif (type(tabA.pvp_def_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_fire_lvup = tabA.pvp_def_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp毒防每级成长值
		a.pvp_def_poison_lvup = 0
		if tabA.pvp_def_poison_lvup then
			if (type(tabA.pvp_def_poison_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_poison_lvup = tabA.pvp_def_poison_lvup
			elseif (type(tabA.pvp_def_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_poison_lvup = tabA.pvp_def_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp子弹防每级成长值
		a.pvp_def_bullet_lvup = 0
		if tabA.pvp_def_bullet_lvup then
			if (type(tabA.pvp_def_bullet_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_bullet_lvup = tabA.pvp_def_bullet_lvup
			elseif (type(tabA.pvp_def_bullet_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_bullet_lvup = tabA.pvp_def_bullet_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp爆炸防每级成长值
		a.pvp_def_bomb_lvup = 0
		if tabA.pvp_def_bomb_lvup then
			if (type(tabA.pvp_def_bomb_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_bomb_lvup = tabA.pvp_def_bomb_lvup
			elseif (type(tabA.pvp_def_bomb_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_bomb_lvup = tabA.pvp_def_bomb_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp穿刺防每级成长值
		a.pvp_def_chuanci_lvup = 0
		if tabA.pvp_def_chuanci_lvup then
			if (type(tabA.pvp_def_chuanci_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_def_chuanci_lvup = tabA.pvp_def_chuanci_lvup
			elseif (type(tabA.pvp_def_chuanci_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_def_chuanci_lvup = tabA.pvp_def_chuanci_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp携弹数量每级成长值
		a.pvp_bullet_capacity_lvup = 0
		if tabA.pvp_bullet_capacity_lvup then
			if (type(tabA.pvp_bullet_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_bullet_capacity_lvup = tabA.pvp_bullet_capacity_lvup
			elseif (type(tabA.pvp_bullet_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_bullet_capacity_lvup = tabA.pvp_bullet_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷数量每级成长值
		a.pvp_grenade_capacity_lvup = 0
		if tabA.pvp_grenade_capacity_lvup then
			if (type(tabA.pvp_grenade_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_capacity_lvup = tabA.pvp_grenade_capacity_lvup
			elseif (type(tabA.pvp_grenade_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_capacity_lvup = tabA.pvp_grenade_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp子母雷数量每级成长值
		a.pvp_grenade_child_lvup = 0
		if tabA.pvp_grenade_child_lvup then
			if (type(tabA.pvp_grenade_child_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_child_lvup = tabA.pvp_grenade_child_lvup
			elseif (type(tabA.pvp_grenade_child_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_child_lvup = tabA.pvp_grenade_child_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷爆炸火焰每级成长值
		a.pvp_grenade_fire_lvup = 0
		if tabA.pvp_grenade_fire_lvup then
			if (type(tabA.pvp_grenade_fire_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_fire_lvup = tabA.pvp_grenade_fire_lvup
			elseif (type(tabA.pvp_grenade_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_fire_lvup = tabA.pvp_grenade_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷投弹距离每级成长值
		a.pvp_grenade_dis_lvup = 0
		if tabA.pvp_grenade_dis_lvup then
			if (type(tabA.pvp_grenade_dis_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_dis_lvup = tabA.pvp_grenade_dis_lvup
			elseif (type(tabA.pvp_grenade_dis_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_dis_lvup = tabA.pvp_grenade_dis_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷冷却时间每级成长值
		a.pvp_grenade_cd_lvup = 0
		if tabA.pvp_grenade_cd_lvup then
			if (type(tabA.pvp_grenade_cd_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_cd_lvup = tabA.pvp_grenade_cd_lvup
			elseif (type(tabA.pvp_grenade_cd_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_cd_lvup = tabA.pvp_grenade_cd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷暴击每级成长值
		a.pvp_grenade_crit_lvup = 0
		if tabA.pvp_grenade_crit_lvup then
			if (type(tabA.pvp_grenade_crit_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_crit_lvup = tabA.pvp_grenade_crit_lvup
			elseif (type(tabA.pvp_grenade_crit_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_crit_lvup = tabA.pvp_grenade_crit_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp手雷冷却前使用次数每级成长值
		a.pvp_grenade_multiply_lvup = 0
		if tabA.pvp_grenade_multiply_lvup then
			if (type(tabA.pvp_grenade_multiply_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_grenade_multiply_lvup = tabA.pvp_grenade_multiply_lvup
			elseif (type(tabA.pvp_grenade_multiply_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_grenade_multiply_lvup = tabA.pvp_grenade_multiply_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp惯性每级成长值
		a.pvp_inertia_lvup = 0
		if tabA.pvp_inertia_lvup then
			if (type(tabA.pvp_inertia_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_inertia_lvup = tabA.pvp_inertia_lvup
			elseif (type(tabA.pvp_inertia_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_inertia_lvup = tabA.pvp_inertia_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp水晶收益率（去百分号后的值）每级成长值
		a.pvp_crystal_rate_lvup = 0
		if tabA.pvp_crystal_rate_lvup then
			if (type(tabA.pvp_crystal_rate_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_crystal_rate_lvup = tabA.pvp_crystal_rate_lvup
			elseif (type(tabA.pvp_crystal_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_crystal_rate_lvup = tabA.pvp_crystal_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp近战弹开每级成长值
		a.pvp_melee_bounce_lvup = 0
		if tabA.pvp_melee_bounce_lvup then
			if (type(tabA.pvp_melee_bounce_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_melee_bounce_lvup = tabA.pvp_melee_bounce_lvup
			elseif (type(tabA.pvp_melee_bounce_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_melee_bounce_lvup = tabA.pvp_melee_bounce_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp近战反击每级成长值
		a.pvp_melee_fight_lvup = 0
		if tabA.pvp_melee_fight_lvup then
			if (type(tabA.pvp_melee_fight_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_melee_fight_lvup = tabA.pvp_melee_fight_lvup
			elseif (type(tabA.pvp_melee_fight_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_melee_fight_lvup = tabA.pvp_melee_fight_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp近战碎石每级成长值
		a.pvp_melee_stone_lvup = 0
		if tabA.pvp_melee_stone_lvup then
			if (type(tabA.pvp_melee_stone_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_melee_stone_lvup = tabA.pvp_melee_stone_lvup
			elseif (type(tabA.pvp_melee_stone_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_melee_stone_lvup = tabA.pvp_melee_stone_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础闪避几率（去百分号后的值）每级成长值
		a.pvp_dodge_rate_lvup = 0
		if tabA.pvp_dodge_rate_lvup then
			if (type(tabA.pvp_dodge_rate_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_dodge_rate_lvup = tabA.pvp_dodge_rate_lvup
			elseif (type(tabA.pvp_dodge_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_dodge_rate_lvup = tabA.pvp_dodge_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础命中几率（去百分号后的值）每级成长值
		a.pvp_hit_rate_lvup = 0
		if tabA.pvp_hit_rate_lvup then
			if (type(tabA.pvp_hit_rate_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_hit_rate_lvup = tabA.pvp_hit_rate_lvup
			elseif (type(tabA.pvp_hit_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_hit_rate_lvup = tabA.pvp_hit_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础暴击几率（去百分号后的值）每级成长值
		a.pvp_crit_rate_lvup = 0
		if tabA.pvp_crit_rate_lvup then
			if (type(tabA.pvp_crit_rate_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_crit_rate_lvup = tabA.pvp_crit_rate_lvup
			elseif (type(tabA.pvp_crit_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_crit_rate_lvup = tabA.pvp_crit_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础暴击倍数每级成长值（支持小数）
		a.pvp_crit_value_lvup = 0.0
		if tabA.pvp_crit_value_lvup then
			if (type(tabA.pvp_crit_value_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_crit_value_lvup = tabA.pvp_crit_value_lvup
			elseif (type(tabA.pvp_crit_value_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_crit_value_lvup = tabA.pvp_crit_value_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础复活时间每级成长值（毫秒）
		a.pvp_rebirth_time_lvup = 0
		if tabA.pvp_rebirth_time_lvup then
			if (type(tabA.pvp_rebirth_time_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_rebirth_time_lvup = tabA.pvp_rebirth_time_lvup
			elseif (type(tabA.pvp_rebirth_time_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_rebirth_time_lvup = tabA.pvp_rebirth_time_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础吸血率每级成长值（去百分号后的值）
		a.pvp_suck_blood_rate_lvup = 0
		if tabA.pvp_suck_blood_rate_lvup then
			if (type(tabA.pvp_suck_blood_rate_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_suck_blood_rate_lvup = tabA.pvp_suck_blood_rate_lvup
			elseif (type(tabA.pvp_suck_blood_rate_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_suck_blood_rate_lvup = tabA.pvp_suck_blood_rate_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础主动技能冷却时间变化值每级成长值（毫秒）
		a.pvp_active_skill_cd_delta_lvup = 0
		if tabA.pvp_active_skill_cd_delta_lvup then
			if (type(tabA.pvp_active_skill_cd_delta_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_active_skill_cd_delta_lvup = tabA.pvp_active_skill_cd_delta_lvup
			elseif (type(tabA.pvp_active_skill_cd_delta_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_active_skill_cd_delta_lvup = tabA.pvp_active_skill_cd_delta_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础被动技能冷却时间变化值每级成长值（毫秒）
		a.pvp_passive_skill_cd_delta_lvup = 0
		if tabA.pvp_passive_skill_cd_delta_lvup then
			if (type(tabA.pvp_passive_skill_cd_delta_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_passive_skill_cd_delta_lvup = tabA.pvp_passive_skill_cd_delta_lvup
			elseif (type(tabA.pvp_passive_skill_cd_delta_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_passive_skill_cd_delta_lvup = tabA.pvp_passive_skill_cd_delta_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础宠物回血每级成长值
		a.pvp_pet_hp_restore_lvup = 0
		if tabA.pvp_pet_hp_restore_lvup then
			if (type(tabA.pvp_pet_hp_restore_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_pet_hp_restore_lvup = tabA.pvp_pet_hp_restore_lvup
			elseif (type(tabA.pvp_pet_hp_restore_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_pet_hp_restore_lvup = tabA.pvp_pet_hp_restore_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础宠物生命每级成长值
		a.pvp_pet_hp_lvup = 0
		if tabA.pvp_pet_hp_lvup then
			if (type(tabA.pvp_pet_hp_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_pet_hp_lvup = tabA.pvp_pet_hp_lvup
			elseif (type(tabA.pvp_pet_hp_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_pet_hp_lvup = tabA.pvp_pet_hp_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础宠物攻击每级成长值
		a.pvp_pet_atk_lvup = 0
		if tabA.pvp_pet_atk_lvup then
			if (type(tabA.pvp_pet_atk_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_pet_atk_lvup = tabA.pvp_pet_atk_lvup
			elseif (type(tabA.pvp_pet_atk_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_pet_atk_lvup = tabA.pvp_pet_atk_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础宠物攻速每级成长值
		a.pvp_pet_atk_speed_lvup = 0
		if tabA.pvp_pet_atk_speed_lvup then
			if (type(tabA.pvp_pet_atk_speed_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_pet_atk_speed_lvup = tabA.pvp_pet_atk_speed_lvup
			elseif (type(tabA.pvp_pet_atk_speed_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_pet_atk_speed_lvup = tabA.pvp_pet_atk_speed_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础宠物携带数量每级成长值
		a.pvp_pet_capacity_lvup = 0
		if tabA.pvp_pet_capacity_lvup then
			if (type(tabA.pvp_pet_capacity_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_pet_capacity_lvup = tabA.pvp_pet_capacity_lvup
			elseif (type(tabA.pvp_pet_capacity_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_pet_capacity_lvup = tabA.pvp_pet_capacity_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础陷阱时间（单位：毫秒）每级成长值
		a.pvp_trap_ground_lvup = 0
		if tabA.pvp_trap_ground_lvup then
			if (type(tabA.pvp_trap_ground_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_ground_lvup = tabA.pvp_trap_ground_lvup
			elseif (type(tabA.pvp_trap_ground_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_ground_lvup = tabA.pvp_trap_ground_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础陷阱施法间隔（单位：毫秒）每级成长值
		a.pvp_trap_groundcd_lvup = 0
		if tabA.pvp_trap_groundcd_lvup then
			if (type(tabA.pvp_trap_groundcd_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_groundcd_lvup = tabA.pvp_trap_groundcd_lvup
			elseif (type(tabA.pvp_trap_groundcd_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_groundcd_lvup = tabA.pvp_trap_groundcd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础陷阱困敌时间（单位：毫秒）每级成长值
		a.pvp_trap_groundenemy_lvup = 0
		if tabA.pvp_trap_groundenemy_lvup then
			if (type(tabA.pvp_trap_groundenemy_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_groundenemy_lvup = tabA.pvp_trap_groundenemy_lvup
			elseif (type(tabA.pvp_trap_groundenemy_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_groundenemy_lvup = tabA.pvp_trap_groundenemy_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础天网时间（单位：毫秒）每级成长值
		a.pvp_trap_fly_lvup = 0
		if tabA.pvp_trap_fly_lvup then
			if (type(tabA.pvp_trap_fly_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_fly_lvup = tabA.pvp_trap_fly_lvup
			elseif (type(tabA.pvp_trap_fly_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_fly_lvup = tabA.pvp_trap_fly_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础天网施法间隔（单位：毫秒）每级成长值
		a.pvp_trap_flycd_lvup = 0
		if tabA.pvp_trap_flycd_lvup then
			if (type(tabA.pvp_trap_flycd_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_flycd_lvup = tabA.pvp_trap_flycd_lvup
			elseif (type(tabA.pvp_trap_flycd_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_flycd_lvup = tabA.pvp_trap_flycd_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础天网困敌时间（单位：毫秒）每级成长值
		a.pvp_trap_flyenemy_lvup = 0
		if tabA.pvp_trap_flyenemy_lvup then
			if (type(tabA.pvp_trap_flyenemy_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_trap_flyenemy_lvup = tabA.pvp_trap_flyenemy_lvup
			elseif (type(tabA.pvp_trap_flyenemy_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_trap_flyenemy_lvup = tabA.pvp_trap_flyenemy_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础迷惑几率（去百分号后的值）每级成长值
		a.pvp_puzzle_lvup = 0
		if tabA.pvp_puzzle_lvup then
			if (type(tabA.pvp_puzzle_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_puzzle_lvup = tabA.pvp_puzzle_lvup
			elseif (type(tabA.pvp_puzzle_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_puzzle_lvup = tabA.pvp_puzzle_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础射击暴击每级成长值
		a.pvp_weapon_crit_shoot_lvup = 0
		if tabA.pvp_weapon_crit_shoot_lvup then
			if (type(tabA.pvp_weapon_crit_shoot_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_shoot_lvup = tabA.pvp_weapon_crit_shoot_lvup
			elseif (type(tabA.pvp_weapon_crit_shoot_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_shoot_lvup = tabA.pvp_weapon_crit_shoot_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础冰冻暴击每级成长值
		a.pvp_weapon_crit_frozen_lvup = 0
		if tabA.pvp_weapon_crit_frozen_lvup then
			if (type(tabA.pvp_weapon_crit_frozen_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_frozen_lvup = tabA.pvp_weapon_crit_frozen_lvup
			elseif (type(tabA.pvp_weapon_crit_frozen_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_frozen_lvup = tabA.pvp_weapon_crit_frozen_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础火焰暴击每级成长值
		a.pvp_weapon_crit_fire_lvup = 0
		if tabA.pvp_weapon_crit_fire_lvup then
			if (type(tabA.pvp_weapon_crit_fire_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_fire_lvup = tabA.pvp_weapon_crit_fire_lvup
			elseif (type(tabA.pvp_weapon_crit_fire_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_fire_lvup = tabA.pvp_weapon_crit_fire_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础装备暴击每级成长值
		a.pvp_weapon_crit_equip_lvup = 0
		if tabA.pvp_weapon_crit_equip_lvup then
			if (type(tabA.pvp_weapon_crit_equip_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_equip_lvup = tabA.pvp_weapon_crit_equip_lvup
			elseif (type(tabA.pvp_weapon_crit_equip_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_equip_lvup = tabA.pvp_weapon_crit_equip_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础击退暴击每级成长值
		a.pvp_weapon_crit_hit_lvup = 0
		if tabA.pvp_weapon_crit_hit_lvup then
			if (type(tabA.pvp_weapon_crit_hit_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_hit_lvup = tabA.pvp_weapon_crit_hit_lvup
			elseif (type(tabA.pvp_weapon_crit_hit_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_hit_lvup = tabA.pvp_weapon_crit_hit_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础吹风暴击每级成长值
		a.pvp_weapon_crit_blow_lvup = 0
		if tabA.pvp_weapon_crit_blow_lvup then
			if (type(tabA.pvp_weapon_crit_blow_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_blow_lvup = tabA.pvp_weapon_crit_blow_lvup
			elseif (type(tabA.pvp_weapon_crit_blow_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_blow_lvup = tabA.pvp_weapon_crit_blow_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--pvp基础毒液暴击每级成长值
		a.pvp_weapon_crit_poison_lvup = 0
		if tabA.pvp_weapon_crit_poison_lvup then
			if (type(tabA.pvp_weapon_crit_poison_lvup) == "number") then --每个星级的成长值都一样
				a.pvp_weapon_crit_poison_lvup = tabA.pvp_weapon_crit_poison_lvup
			elseif (type(tabA.pvp_weapon_crit_poison_lvup) == "table") then --每个星级对应不同的成长值
				a.pvp_weapon_crit_poison_lvup = tabA.pvp_weapon_crit_poison_lvup[star] or 0
			else --不合法的格式
				--
			end
		end
		
		--这里是设置角色等级的接口地方
		a.hp_max_basic = (tabA.hp or 1) + ((level - 1) * a.hp_lvup) + ((pvp_level - 1) * a.pvp_hp_lvup) --基础血量最大值
		a.attack[4] = (tabA.attack and tabA.attack[4] or 0) + ((level - 1) * a.atk_min_lvup) + ((pvp_level - 1) * a.pvp_atk_min_lvup) --攻击力最小值
		a.attack[5] = (tabA.attack and tabA.attack[5] or 0) + ((level - 1) * a.atk_max_lvup) + ((pvp_level - 1) * a.pvp_atk_max_lvup) --攻击力最大值
		--if self.data.id == 18101 then
		--	print("__AttrRecheckBasic", self.data.name, "a.hp_max_basic =" .. a.hp_max_basic .. ", a.attack[4]=" .. a.attack[4] .. ", a.attack[5]=" .. a.attack[5])
		--end
		a.attack[6] = (tabA.attack and tabA.attack[6] or 1) --攻击力的等级（默认是等级1）
		a.atk_basic = math.floor((a.attack[4] + a.attack[5]) / 2) --基础攻击力
		a.atk_ice_basic = (tabA.atk_ice or 0) + ((level - 1) * a.atk_ice_lvup) + ((pvp_level - 1) * a.pvp_atk_ice_lvup) --基础冰攻击力
		a.atk_thunder_basic = (tabA.atk_thunder or 0) + ((level - 1) * a.atk_thunder_lvup) + ((pvp_level - 1) * a.pvp_atk_thunder_lvup) --基础雷攻击力
		a.atk_fire_basic = (tabA.atk_fire or 0) + ((level - 1) * a.atk_fire_lvup) + ((pvp_level - 1) * a.pvp_atk_fire_lvup) --基础火攻击力
		a.atk_poison_basic = (tabA.atk_poison or 0) + ((level - 1) * a.atk_poison_lvup) + ((pvp_level - 1) * a.pvp_atk_poison_lvup) --基础毒攻击力
		a.atk_bullet_basic = (tabA.atk_bullet or 0) + ((level - 1) * a.atk_bullet_lvup) + ((pvp_level - 1) * a.pvp_atk_bullet_lvup) --基础子弹攻击力
		a.atk_bomb_basic = (tabA.atk_bomb or 0) + ((level - 1) * a.atk_bomb_lvup) + ((pvp_level - 1) * a.pvp_atk_bomb_lvup) --基础爆炸攻击力
		a.atk_chuanci_basic = (tabA.atk_chuanci or 0) + ((level - 1) * a.atk_chuanci_lvup) + ((pvp_level - 1) * a.pvp_atk_chuanci_lvup) --基础穿刺攻击力
		a.hp_restore_basic = (tabA.hp_restore or 0) + ((level - 1) * a.hp_restore_lvup) + ((pvp_level - 1) * a.pvp_hp_restore_lvup) --基础回血速度（每秒）（支持小数）
		a.move_speed_basic = (tabA.move_speed or hVar.BATTLEFIELD_MOVE_SPEED) + ((level - 1) * a.move_speed_lvup) + ((pvp_level - 1) * a.pvp_move_speed_lvup) --基础移动速度
		a.atk_radius_min_basic = (tabA.atk_radius_min or 0) + ((level - 1) * a.atk_radius_min_lvup) + ((pvp_level - 1) * a.pvp_atk_radius_min_lvup) --基础攻击范围最小值
		a.atk_radius_basic = (tabA.atk_radius or 0) + ((level - 1) * a.atk_radius_lvup) + ((pvp_level - 1) * a.pvp_atk_radius_lvup) --基础攻击范围
		--a.atk_search_radius_basic = tabA.atk_search_radius or 0 --基础攻击搜敌范围
		a.atk_interval_basic = (tabA.atk_interval or 1000) + ((level - 1) * a.atk_interval_lvup) + ((pvp_level - 1) * a.pvp_atk_interval_lvup) --基础攻击间隔（毫秒）
		a.atk_speed_basic = (tabA.atk_speed or 100) + ((level - 1) * a.atk_speed_lvup) + ((pvp_level - 1) * a.pvp_atk_speed_lvup) --基础攻击速度（去百分号后的值）
		a.def_physic_basic = (tabA.def_physic or 0) + ((level - 1) * a.def_physic_lvup) + ((pvp_level - 1) * a.pvp_def_physic_lvup) --基础物理防御
		a.def_magic_basic = (tabA.def_magic or 0) + ((level - 1) * a.def_magic_lvup) + ((pvp_level - 1) * a.pvp_def_magic_lvup) --基础法术防御
		a.def_ice_basic = (tabA.def_ice or 0) + ((level - 1) * a.def_ice_lvup) + ((pvp_level - 1) * a.pvp_def_ice_lvup) --基础冰防御
		a.def_thunder_basic = (tabA.def_thunder or 0) + ((level - 1) * a.def_thunder_lvup) + ((pvp_level - 1) * a.pvp_def_thunder_lvup) --基础雷防御
		a.def_fire_basic = (tabA.def_fire or 0) + ((level - 1) * a.def_fire_lvup) + ((pvp_level - 1) * a.pvp_def_fire_lvup) --基础火防御
		a.def_poison_basic = (tabA.def_poison or 0) + ((level - 1) * a.def_poison_lvup) + ((pvp_level - 1) * a.pvp_def_poison_lvup) --基础毒防御
		a.def_bullet_basic = (tabA.def_bullet or 0) + ((level - 1) * a.def_bullet_lvup) + ((pvp_level - 1) * a.pvp_def_bullet_lvup) --基础子弹防御
		a.def_bomb_basic = (tabA.def_bomb or 0) + ((level - 1) * a.def_bomb_lvup) + ((pvp_level - 1) * a.pvp_def_bomb_lvup) --基础爆炸防御
		a.def_chuanci_basic = (tabA.def_chuanci or 0) + ((level - 1) * a.def_chuanci_lvup) + ((pvp_level - 1) * a.pvp_def_chuanci_lvup) --基础穿刺防御
		a.bullet_capacity_basic = (tabA.bullet_capacity or 0) + ((level - 1) * a.bullet_capacity_lvup) + ((pvp_level - 1) * a.pvp_bullet_capacity_lvup) --基础携弹数量
		a.grenade_capacity_basic = (tabA.grenade_capacity or 0) + ((level - 1) * a.grenade_capacity_lvup) + ((pvp_level - 1) * a.pvp_grenade_capacity_lvup) --基础手雷数量
		a.grenade_child_basic = (tabA.grenade_child or 0) + ((level - 1) * a.grenade_child_lvup) + ((pvp_level - 1) * a.pvp_grenade_child_lvup) --基础子母雷数量
		a.grenade_fire_basic = (tabA.grenade_fire or 0) + ((level - 1) * a.grenade_fire_lvup) + ((pvp_level - 1) * a.pvp_grenade_fire_lvup) --基础手雷爆炸火焰
		a.grenade_dis_basic = (tabA.grenade_dis or 100) + ((level - 1) * a.grenade_dis_lvup) + ((pvp_level - 1) * a.pvp_grenade_dis_lvup) --基础手雷投弹距离
		a.grenade_cd_basic = (tabA.grenade_cd or 0) + ((level - 1) * a.grenade_cd_lvup) + ((pvp_level - 1) * a.pvp_grenade_cd_lvup) --基础手雷冷却时间
		a.grenade_crit_basic = (tabA.grenade_crit or 0) + ((level - 1) * a.grenade_crit_lvup) + ((pvp_level - 1) * a.pvp_grenade_crit_lvup) --基础手雷暴击
		a.grenade_multiply_basic = (tabA.grenade_multiply or 1) + ((level - 1) * a.grenade_multiply_lvup) + ((pvp_level - 1) * a.pvp_grenade_multiply_lvup) --基础手雷冷却前使用次数
		a.inertia_basic = (tabA.inertia or 0) + ((level - 1) * a.inertia_lvup) + ((pvp_level - 1) * a.pvp_inertia_lvup) --基础惯性
		a.crystal_rate_basic = (tabA.crystal_rate or 100) + ((level - 1) * a.crystal_rate_lvup) + ((pvp_level - 1) * a.pvp_crystal_rate_lvup) --基础水晶收益率（去百分号后的值）
		a.melee_bounce_basic = (tabA.melee_bounce or 0) + ((level - 1) * a.melee_bounce_lvup) + ((pvp_level - 1) * a.pvp_melee_bounce_lvup) --基础近战弹开
		a.melee_fight_basic = (tabA.melee_fight or 0) + ((level - 1) * a.melee_fight_lvup) + ((pvp_level - 1) * a.pvp_melee_fight_lvup) --基础近战反击
		a.melee_stone_basic = (tabA.melee_stone or 0) + ((level - 1) * a.melee_stone_lvup) + ((pvp_level - 1) * a.pvp_melee_stone_lvup) --基础碎石反击
		a.dodge_rate_basic = (tabA.dodge_rate or 0) + ((level - 1) * a.dodge_rate_lvup) + ((pvp_level - 1) * a.pvp_dodge_rate_lvup) --基础闪避几率（去百分号后的值）
		a.hit_rate_basic = (tabA.hit_rate or 0) + ((level - 1) * a.hit_rate_lvup) + ((pvp_level - 1) * a.pvp_hit_rate_lvup) --基础命中几率（去百分号后的值）
		a.crit_rate_basic = (tabA.crit_rate or 0) + ((level - 1) * a.crit_rate_lvup) + ((pvp_level - 1) * a.pvp_crit_rate_lvup) --基础暴击几率（去百分号后的值）
		a.crit_value_basic = (tabA.crit_value or 2.0) + ((level - 1) * a.crit_value_lvup) + ((pvp_level - 1) * a.pvp_crit_value_lvup) --基础暴击倍数（支持小数）
		a.escape_punish_basic = tabA.escape_punish or 0 --基础逃怪惩罚
		a.kill_gold_basic = tabA.kill_gold or 0 --基础击杀奖励金币
		a.rebirth_time_basic = (tabA.rebirth_time or 10000) + ((level - 1) * a.rebirth_time_lvup) + ((pvp_level - 1) * a.pvp_rebirth_time_lvup) --基础复活时间（毫秒）
		a.suck_blood_rate_basic = (tabA.suck_blood_rate or 0) + ((level - 1) * a.suck_blood_rate_lvup) + ((pvp_level - 1) * a.pvp_suck_blood_rate_lvup) --基础吸血率（去百分号后的值）
		a.active_skill_cd_delta_basic = (tabA.active_skill_cd_delta or 0) + ((level - 1) * a.active_skill_cd_delta_lvup) + ((pvp_level - 1) * a.pvp_active_skill_cd_delta_lvup) --基础主动技能冷却时间变化值（毫秒）
		a.passive_skill_cd_delta_basic = (tabA.passive_skill_cd_delta or 0) + ((level - 1) * a.passive_skill_cd_delta_lvup) + ((pvp_level - 1) * a.pvp_passive_skill_cd_delta_lvup) --基础被动技能冷却时间变化值（毫秒）
		
		a.AI_attribute_basic = tabA.AI_attribute or hVar.AI_ATTRIBUTE_TYPE.POSITIVE --AI行为类型
		
		a.rebirth_wudi_time_basic = tabA.rebirth_wudi_time or 1000 --基础复活后无敌时间（毫秒）
		a.basic_weapon_level_basic = tabA.basic_weapon_level_basic or 1 --基础武器等级
		a.basic_skill_level_basic = tabA.basic_skill_level_basic or 1 --基础技能等级
		a.basic_skill_usecount_basic = tabA.basic_skill_usecount_basic or 1 --基础技能使用次数
		a.pet_hp_restore_basic = (tabA.pet_hp_restore or 0) + ((level - 1) * a.pet_hp_restore_lvup) + ((pvp_level - 1) * a.pvp_pet_hp_restore_lvup) --基础宠物回血
		a.pet_hp_basic = (tabA.pet_hp or 0) + ((level - 1) * a.pet_hp_lvup) + ((pvp_level - 1) * a.pvp_pet_hp_lvup) --基础宠物生命
		a.pet_atk_basic = (tabA.pet_atk or 0) + ((level - 1) * a.pet_atk_lvup) + ((pvp_level - 1) * a.pvp_pet_atk_lvup) --基础宠物攻击
		a.pet_atk_speed_basic = (tabA.pet_atk_speed or 0) + ((level - 1) * a.pet_atk_speed_lvup) + ((pvp_level - 1) * a.pvp_pet_atk_speed_lvup) --基础宠物攻速
		
		--基础宠物携带数量支持表结构
		local pet_capacity = 1
		if tabA.pet_capacity then
			if (type(tabA.pet_capacity) == "number") then --每个星级的成长值都一样
				pet_capacity = tabA.pet_capacity
			elseif (type(tabA.pet_capacity) == "table") then --每个星级对应不同的成长值
				pet_capacity = tabA.pet_capacity[star] or 0
			else --不合法的格式
				--
			end
		end
		a.pet_capacity_basic = (pet_capacity or 1) + ((level - 1) * a.pet_capacity_lvup) + ((pvp_level - 1) * a.pvp_pet_capacity_lvup) --基础宠物携带数量
		
		--基础陷阱时间（单位：毫秒）支持表结构
		local trap_ground = 0
		if tabA.trap_ground then
			if (type(tabA.trap_ground) == "number") then --每个星级的成长值都一样
				trap_ground = tabA.trap_ground
			elseif (type(tabA.trap_ground) == "table") then --每个星级对应不同的成长值
				trap_ground = tabA.trap_ground[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_ground_basic = (trap_ground or 0) + ((level - 1) * a.trap_ground_lvup) + ((pvp_level - 1) * a.trap_ground_lvup) --基础陷阱时间（单位：毫秒）
		
		--基础陷阱施法间隔（单位：毫秒）支持表结构
		local trap_groundcd = 0
		if tabA.trap_groundcd then
			if (type(tabA.trap_groundcd) == "number") then --每个星级的成长值都一样
				trap_groundcd = tabA.trap_groundcd
			elseif (type(tabA.trap_groundcd) == "table") then --每个星级对应不同的成长值
				trap_groundcd = tabA.trap_groundcd[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_groundcd_basic = (trap_groundcd or 30000) + ((level - 1) * a.trap_groundcd_lvup) + ((pvp_level - 1) * a.trap_groundcd_lvup) --基础陷阱施法间隔（单位：毫秒）
		
		--基础陷阱困敌时间（单位：毫秒）支持表结构
		local trap_groundenemy = hVar.TRAP_GROUND_TRAPTIME
		if tabA.trap_groundenemy then
			if (type(tabA.trap_groundenemy) == "number") then --每个星级的成长值都一样
				trap_groundenemy = tabA.trap_groundenemy
			elseif (type(tabA.trap_groundenemy) == "table") then --每个星级对应不同的成长值
				trap_groundenemy = tabA.trap_groundenemy[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_groundenemy_basic = (trap_groundenemy or hVar.TRAP_GROUND_TRAPTIME) + ((level - 1) * a.trap_groundenemy_lvup) + ((pvp_level - 1) * a.trap_groundenemy_lvup) --基础陷阱困敌时间（单位：毫秒）
		
		--基础天网时间（单位：毫秒）支持表结构
		local trap_fly = 0
		if tabA.trap_fly then
			if (type(tabA.trap_fly) == "number") then --每个星级的成长值都一样
				trap_fly = tabA.trap_fly
			elseif (type(tabA.trap_fly) == "table") then --每个星级对应不同的成长值
				trap_fly = tabA.trap_fly[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_fly_basic = (trap_fly or 0) + ((level - 1) * a.trap_fly_lvup) + ((pvp_level - 1) * a.trap_fly_lvup) --基础天网时间（单位：毫秒）
		
		--基础天网施法间隔（单位：毫秒）支持表结构
		local trap_flycd = 0
		if tabA.trap_flycd then
			if (type(tabA.trap_flycd) == "number") then --每个星级的成长值都一样
				trap_flycd = tabA.trap_flycd
			elseif (type(tabA.trap_flycd) == "table") then --每个星级对应不同的成长值
				trap_flycd = tabA.trap_flycd[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_flycd_basic = (trap_flycd or 30000) + ((level - 1) * a.trap_flycd_lvup) + ((pvp_level - 1) * a.trap_flycd_lvup) --基础天网施法间隔（单位：毫秒）
		
		--基础天网困敌时间（单位：毫秒）支持表结构
		local trap_flyenemy = hVar.TRAP_FLY_TRAPTIME
		if tabA.trap_flyenemy then
			if (type(tabA.trap_flyenemy) == "number") then --每个星级的成长值都一样
				trap_flyenemy = tabA.trap_flyenemy
			elseif (type(tabA.trap_flyenemy) == "table") then --每个星级对应不同的成长值
				trap_flyenemy = tabA.trap_flyenemy[star] or 0
			else --不合法的格式
				--
			end
		end
		a.trap_flyenemy_basic = (trap_flyenemy or hVar.TRAP_FLY_TRAPTIME) + ((level - 1) * a.trap_flyenemy_lvup) + ((pvp_level - 1) * a.trap_flyenemy_lvup) --基础天网困敌时间（单位：毫秒）
		
		--基础迷惑几率（去百分号后的值）支持表结构
		local puzzle = 0
		if tabA.puzzle then
			if (type(tabA.puzzle) == "number") then --每个星级的成长值都一样
				puzzle = tabA.puzzle
			elseif (type(tabA.puzzle) == "table") then --每个星级对应不同的成长值
				puzzle = tabA.puzzle[star] or 0
			else --不合法的格式
				--
			end
		end
		a.puzzle_basic = (puzzle or 0) + ((level - 1) * a.puzzle_lvup) + ((pvp_level - 1) * a.puzzle_lvup) --基础迷惑几率（去百分号后的值）
		
		--基础射击暴击支持表结构
		local weapon_crit_shoot = 0
		if tabA.weapon_crit_shoot then
			if (type(tabA.weapon_crit_shoot) == "number") then --每个星级的成长值都一样
				weapon_crit_shoot = tabA.weapon_crit_shoot
			elseif (type(tabA.weapon_crit_shoot) == "table") then --每个星级对应不同的成长值
				weapon_crit_shoot = tabA.weapon_crit_shoot[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_shoot_basic = (weapon_crit_shoot or 0) + ((level - 1) * a.weapon_crit_shoot_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_shoot_lvup) --基础射击暴击
		
		--基础冰冻暴击支持表结构
		local weapon_crit_frozen = 0
		if tabA.weapon_crit_frozen then
			if (type(tabA.weapon_crit_frozen) == "number") then --每个星级的成长值都一样
				weapon_crit_frozen = tabA.weapon_crit_frozen
			elseif (type(tabA.weapon_crit_frozen) == "table") then --每个星级对应不同的成长值
				weapon_crit_frozen = tabA.weapon_crit_frozen[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_frozen_basic = (weapon_crit_frozen or 0) + ((level - 1) * a.weapon_crit_frozen_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_frozen_lvup) --基础冰冻暴击
		
		--基础火焰暴击支持表结构
		local weapon_crit_fire = 0
		if tabA.weapon_crit_fire then
			if (type(tabA.weapon_crit_fire) == "number") then --每个星级的成长值都一样
				weapon_crit_fire = tabA.weapon_crit_fire
			elseif (type(tabA.weapon_crit_fire) == "table") then --每个星级对应不同的成长值
				weapon_crit_fire = tabA.weapon_crit_fire[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_fire_basic = (weapon_crit_fire or 0) + ((level - 1) * a.weapon_crit_fire_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_fire_lvup) --基础火焰暴击
		
		a.weapon_crit_equip_basic = (tabA.weapon_crit_equip or 0) + ((level - 1) * a.weapon_crit_equip_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_equip_lvup) --基础装备暴击
		
		--基础击退暴击支持表结构
		local weapon_crit_hit = 0
		if tabA.weapon_crit_hit then
			if (type(tabA.weapon_crit_hit) == "number") then --每个星级的成长值都一样
				weapon_crit_hit = tabA.weapon_crit_hit
			elseif (type(tabA.weapon_crit_hit) == "table") then --每个星级对应不同的成长值
				weapon_crit_hit = tabA.weapon_crit_hit[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_hit_basic = (weapon_crit_hit or 0) + ((level - 1) * a.weapon_crit_hit_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_hit_lvup) --基础击退暴击
		
		--基础吹风暴击支持表结构
		local weapon_crit_blow = 0
		if tabA.weapon_crit_blow then
			if (type(tabA.weapon_crit_blow) == "number") then --每个星级的成长值都一样
				weapon_crit_blow = tabA.weapon_crit_blow
			elseif (type(tabA.weapon_crit_blow) == "table") then --每个星级对应不同的成长值
				weapon_crit_blow = tabA.weapon_crit_blow[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_blow_basic = (weapon_crit_blow or 0) + ((level - 1) * a.weapon_crit_blow_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_blow_lvup) --基础吹风暴击
		
		--基础毒液暴击支持表结构
		local weapon_crit_poison = 0
		if tabA.weapon_crit_poison then
			if (type(tabA.weapon_crit_poison) == "number") then --每个星级的成长值都一样
				weapon_crit_poison = tabA.weapon_crit_poison
			elseif (type(tabA.weapon_crit_poison) == "table") then --每个星级对应不同的成长值
				weapon_crit_poison = tabA.weapon_crit_poison[star] or 0
			else --不合法的格式
				--
			end
		end
		a.weapon_crit_poison_basic = (weapon_crit_poison or 0) + ((level - 1) * a.weapon_crit_poison_lvup) + ((pvp_level - 1) * a.pvp_weapon_crit_poison_lvup) --基础毒液暴击
		
		--如果是战车，附加天赋属性作为基础属性
		if (self.data.id == hVar.MY_TANK_ID) then --我的坦克
			local tTalentTree = LuaGetTalentTree()
			for it = 1, #tTalentTree, 1 do
				local tTalent = tTalentTree[it]
				local id = tTalent[1]
				local lv = tTalent[2]
				local tAttr = hVar.TANK_TAKENT_TREE[id]
				if tAttr then
					local attrType = tAttr.attrType --属性类型
					local attrValueAdd = tAttr.attrAdd[lv] or 0 --属性值
					local attrTypeAdd = attrType .. "_basic"
					if (attrType == "atk") then --攻击力存储到战术卡上
						attrTypeAdd = attrType .. "_tactic"
					end
					if attrTypeAdd then
						a[attrTypeAdd] = a[attrTypeAdd] + attrValueAdd
					end
				end
			end
		end
		
		--如果是战车，附加自身的天赋技能
		if (self.data.id == hVar.MY_TANK_ID) then --我的坦克
			--print("如果是战车，附加自身的天赋技能")
			local tTalentTree = tabU.talent_tree
			for skillIdx = 1, #tTalentTree, 1 do
				local talentid = tTalentTree[skillIdx]
				local skillLv = LuaGetHeroTalentSkillLv(self.data.id, talentid)
				local tTalent = hVar.tab_chariottalent[talentid]
				if tTalent and (skillLv > 0) then
					--print(skillIdx, skillLv)
					local attrAdd = tTalent.attrAdd
					if attrAdd then
						local tAttr = attrAdd[skillLv]
						if tAttr then
							for ai = 1, #tAttr, 1 do
								local tAttr_i = tAttr[ai]
								local attrType = tAttr_i[1] --属性类型
								local attrValue = tAttr_i[2] --属性值
								--print("attrType=", attrType)
								--print("attrValue=", attrValue)
								local attrTypeAdd = attrType .. "_basic"
								if (attrType == "atk") then --攻击力存储到战术卡上
									attrTypeAdd = attrType .. "_tactic"
								end
								if attrTypeAdd then
									a[attrTypeAdd] = a[attrTypeAdd] + attrValue
								end
							end
						end
					end
				end
			end
		end
		
		--print(self.data.name, "a.skill_AI_sequence=" .. tostring(a.skill_AI_sequence))
		--a.skill_AI_sequence = 0 --geyachao: 新加数据 技能释放AI规则表
		--防止后面被盖掉，第一次才初始化
		if (a.skill_AI_sequence == 0) then
			if tabA.skill_AI_sequence then
				a.skill_AI_sequence = {}
				for si = 1, #tabA.skill_AI_sequence, 1 do
					a.skill_AI_sequence[si] = tabA.skill_AI_sequence[si]
				end
			end
		end
		
		--该单位作为绑定单位，偏移值
		a.bind_offsetX = tabA.bind_offsetX or 0
		a.bind_offsetY = tabA.bind_offsetY or 0
		
		a.onReachedCastSkillId = tabA.onReachedCastSkillId or 0 --走完路点后，释放技能
		
		a.is_taunt = tabA.is_taunt or 0 --geyachao: 新加数据 是否是嘲讽单位（敌人见到就打）
		a.taunt_need_collapse = tabA.taunt_need_collapse or 1 --嘲讽需要围成一圈
		a.taunt_radius = tabA.taunt_radius or 0 --geyachao: 新加数据 嘲讽半径
		
		a.space_type = tabA.space_type or hVar.UNIT_SPACE_TYPE.SPACE_GROUND --单位的空间类型（0:地面单位 / 1:空中单位）
		a.atk_space_type = tabA.atk_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND --单位可攻击的目标空间的类型（0: 可攻击地面单位 / 1:可攻击地面单位和空中单位 / 2:可攻击空中单位）
		
		a.trap_ground_lasttime = 0 --陷阱上次施法的时间
		a.trap_fly_lasttime = 0 --天网上次施法的时间
		a.puzzle_lasttime = 0 --迷惑上次施法的时间
		
		a.atk_melee = tabA.atk_melee or 1 --单位是否为近战单位
		a.hideHpBar = tabU.hideHpBar or 0 --是否隐藏血条
		a.hideLiveTimeBar = tabU.hideLiveTimeBar or 0 --是否隐藏倒计时进度条
		a.tag = tabU.tag or __DefalutTag --tag标记
		a.role_sex = tabU.role_sex or hVar.ROLE_SEX.MALE --性别
		a.bullet = tabU.bullet or 0 --子弹16方向偏移表
		a.bulletTank = tabU.bulletTank or 0 --子弹16方向偏移表
		a.bulletEffect = tabU.bulletEffect or 0 --子弹16方向偏移表
		
		local tabS = hVar.tab_skill[a.attack[1]] or {}
		a.AI_priorityList_ex = tabS.AI_priorityList_ex or hVar.AI_PRIORITY_DEFAULT --普攻AI搜集优先级表
		a.DamageType = tabS.DamageType or 0 --普攻AI搜集优先级表
		a.regionIdBelong = 0 --单位所属的随机地图的小关数
		
		a.isInPoseAttack = 0 --是否在播放攻击动作（摇杆时不播走路动作）
		
		a.Trigger_OnUnitDead_SkillId = tabA.Trigger_OnUnitDead_SkillId or 0 --单位死后释放的技能（施法者为自己，目标为击杀者或其它人）
		a.Trigger_OnUnitDead_Tank_SkillId = tabA.Trigger_OnUnitDead_Tank_SkillId or 0 --单位死后，坦克释放的技能（施法者为坦克）
		
		--如果有死后释放的技能，将此单位加入列表
		if (a.Trigger_OnUnitDead_SkillId > 0) then
			local world = self:getworld()
			local cha_worldC = self:getworldC()
			world.data.Trigger_OnUnitDead_UnitList[cha_worldC] = a.Trigger_OnUnitDead_SkillId
			--print("有死后释放的技能", self.data.name, a.Trigger_OnUnitDead_SkillId)
		end
		
		--当前血量比例保持不变
		a.hp = math.floor(self:GetHpMax() * hpPercent)
		if (a.hp < 1) then --最少为1点血
			a.hp = 1
		end
		
		--因为血条比例没发生变化，所以不用更新血条
		--
		
		--更新数字血量
		if self.chaUI["numberBar"] then
			local hpMax = self:GetHpMax()
			if (hpMax <= 0) then
				hpMax = 1
			end
			self.chaUI["numberBar"]:setText(a.hp .. "/" .. hpMax)
		end
		
		--print("name=" .. hVar.tab_unit[typeId].name .. ", level=" .. a.lv .. ", star=" .. star .. ", hp_max=" .. a.hp_max_basic .. ", atk_min=" .. a.attack[4] .. ", atk_max=" .. a.attack[5] .. ", hp_restore=" .. a.hp_restore_basic .. ", move_speed=" .. a.move_speed_basic .. ", atk_radius=" .. a.atk_radius_basic .. ", atk_interval=" .. a.atk_interval_basic .. ", def_physic=" .. a.def_physic_basic .. ", def_magic=" .. a.def_magic_basic .. ", dodge_rate=" .. a.dodge_rate_basic .. ", hit_rate=" .. a.hit_rate_basic.. ", crit_rate=" .. a.crit_rate_basic .. ", crit_value=" .. a.crit_value_basic)
	end
end

--geyachao: 角色属性重算
_hu.AttrRecheckBasic = function(self)
	return self:__AttrRecheckBasic()
end

--geyachao: 重置角色的等级
_hu.SetLevel = function(self, level)
	local a = self.attr --属性表
	local oldLv = a.lv --原先的等级
	
	--不会重复设置相同的等级
	if (level == oldLv) then
		return
	end
	
	--存储单位的等级
	a.lv = level
	
	--检测tab_unit身上skills等级
	
	--属性重算
	self:__AttrRecheckBasic()
end

--geyachao: 重置角色的星级
_hu.SetStar = function(self, star)
	local a = self.attr --属性表
	local oldStar = a.star --原先的星级
	
	--不会重复设置相同的星级
	if (oldStar == star) then
		return
	end
	
	--存储单位的星级
	a.star = star
	
	--属性重算
	self:__AttrRecheckBasic()
end

--geyachao: 重置角色的pvp等级
_hu.SetPvpLevel = function(self, pvp_lv, pvp_exp)
	--print("SetPvpLevel()", self.data.name, pvp_lv, pvp_exp)
	local a = self.attr --属性表
	local oldPvpLv = a.pvp_lv --原先的pvp等级
	a.pvp_exp = pvp_exp --原先的pvp经验
	
	--不会重复设置相同的pvp等级
	if (oldPvpLv == pvp_lv) then
		return
	end
	
	--存储单位的pvp等级
	a.pvp_lv = pvp_lv
	
	--属性重算
	self:__AttrRecheckBasic()
end

--大菠萝
--添加追踪绑定的特效
_hu.AddTacingEffect = function(self, eff, effX, effY)
	local h = self.handle
	local d = self.data
	local a = self.attr
	
	if (self.attr.hp > 0) and (self.data.IsDead ~= 1) then
		local unit_pos_x, unit_pos_y = hApi.chaGetPos(self.handle)
		
		--坦克绑定的追踪导弹特效
		d.bind_tacingeffs[#d.bind_tacingeffs+1] = {eff = eff, effX = effX - unit_pos_x, effY = effY - unit_pos_y,}
	end
end

--大菠萝
--移除追踪绑定的特效
_hu.RemoveTacingEffect = function(self)
	local h = self.handle
	local d = self.data
	local a = self.attr
	
	for i = 1, #self.data.bind_tacingeffs, 1 do
		local tEff = self.data.bind_tacingeffs[i]
		local eff = tEff.eff
		local effX = tEff.effX
		local effY = tEff.effY
		eff:del()
	end
	
	self.data.bind_tacingeffs = {}
end

_hu.settemptype = function(self,sType)
	if sType=="worldmap" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.UNIT_WM
	elseif sType=="battlefield" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_BF
	elseif sType=="town" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_TN
	else
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.NORMAL
	end
end

_hu.getblock = function(self,gridX,gridY,nBlock)
	return hVar.UNIT_BLOCK[nBlock or self.attr.block]
end

_hu.cleardata = function(self)
	local h = self.handle
	local d = self.data
	local a = self.attr
	local _chaUI = rawget(self,"chaUI")
	__DEBUG_clear_chaUI(_chaUI)
	d.powerFrom = 0
	d.powerTo = 0
	--self:stopsound("all")
	h.__tEffectConvert = nil
	h.__tMemory = nil
	h.__uMoveX = nil
	h.__uMoveY = nil
	h.__UnitModelName = nil
	hApi.enumByClass(self,hClass.effect,d.effectU,hApi.removeObject)	--清除所有随身特效
	hApi.enumByClass(self,hClass.action,d.buffs,hApi.removeObject)		--清除所有自带buff
	if d.townID~=0 then							--清除绑定主城
		local oTown = hClass.town:find(d.townID)
		if oTown~=nil and oTown:getunit()==self then
			oTown:del()
			d.townID = 0
		else
			d.townID = 0
			_DEBUG_MSG("[LOGIC WARNING]oTown在删除时发现绑定错误:"..d.id.."["..d.indexOfCreate.."]")
		end
	end
	self:arrive(hClass.world:find(d.bindW),d.gridX,d.gridY,__UNIT_ARRIVE_MODE.DEAD)
end

hApi.IsUnitAlive = function(oUnit)
	return oUnit~=nil and oUnit.ID~=0 and oUnit.data.IsDead~=1
end
--------------------------------------------------------------
-- 特殊保存流程,只保存data中的这些数据
hClass.unit:sync("hook",function(index,v,rTab)			--保存object之前的检查函数
	if type(v)=="table" then
		--英雄和建筑照原样保存
		if v:gethero() then
			return
		elseif v:gettown() then
			return
		end
		local d = v.data
		local a = v.attr
		--说明是dat里面创建出来的，这种只记录team，朝向即可
		local _p = {v.ID,v.__ID}
		for i = 1,#__DefaultSyncData do
			local key = __DefaultSyncData[i]
			_p[i+2] = d[key] or 0
		end
		local s = "\n	["..index.."]={_p="..eClass.API.NumberTable2String(_p)..","
		local oItem = v:getitem()
		if oItem then
			s = s.."_itm={"..oItem.data.id..","..d.itemID.."},"
		else
			if d.team~=0 then
				s = s.."_t="..eClass.API.NumberTable2String(v.data.team)..","
			end
			if d.hireList~=0 then
				s = s.."_hl="..eClass.API.NumberTable2String(v.data.hireList)..","
			end
			if d.shopList~=0 then
				s = s.."_sl="..eClass.API.NumberTable2String(v.data.shopList)..","
			end
			if d.cdtime~=0 then
				local t = d.cdtime
				local cs = ""
				for k,v in pairs(t)do
					cs = cs.."["..k.."]="..v..","
				end
				s = s.."_cd={"..cs.."},"
			end
		end
		rTab[#rTab+1] = s.."},"
	else
		rTab[#rTab+1] = "\n	["..index.."]="..v..","
	end
	return 1
end)
----------------------------------------------
--特殊读取流程
local __GetV = function(t,k)
	local v = rawget(t,k)
	rawset(t,k,nil)
	return v
end
local __DefaultDataKey = {}
for k,v in pairs(__DefaultParam)do
	__DefaultDataKey[#__DefaultDataKey+1] = k
end
hClass.unit.__RecoverObjectFromSaveData = function(self)
	if rawget(self,"ID")~=nil then
		--读取完整存储的单位(英雄,主城)
		local tAttr = rawget(self,"attr") or {}
		self.attr = __CODE__UnitAttrInit(self, __DefaultAttr,tAttr,tAttr,"worldmap") --读取英雄
		local a = self.attr
		local d = self.data
		--恢复data数据
		for i = 1,#__DefaultDataKey do
			local key = __DefaultDataKey[i]
			d[key] = d[key] or 0
		end
		--重新初始化一下skill索引
		a.skill.index = {}
		for i = 1,a.skill.i do
			if a.skill[i]~=0 and a.skill[i][1]>0 and a.skill[i][2]>0 then
				a.skill.index[a.skill[i][1]] = i
			end
		end
		--恢复索引表:buffs
		d.buffs = hApi.indexForObjectList(d.buffs or {})
		--排错
		a.replaceID = a.replaceID or {}
	else
		--读取摘要存储的单位(大地图上的单位)
		local _p = __GetV(self,"_p")
		local ID,__ID = _p[1],_p[2]
		local p = {}
		for i = 1,#__DefaultSyncData do
			local key = __DefaultSyncData[i]
			p[key] = _p[i+2] or 0
		end
		local team = __GetV(self,"_t")
		local hireList = __GetV(self,"_hl")
		local shopList = __GetV(self,"_sl")
		local itemT = __GetV(self,"_itm")
		local cdtime = __GetV(self,"_cd")
		self.ID = ID or 0
		self.__ID = __ID or -1
		self.data = hApi.ReadParam(__DefaultParam,p,{})
		self.attr = __CODE__UnitAttrInit(self, __DefaultAttr,nil,{},"worldmap") --读取单位
		self.handle = {}
		self.chaUI = {}
		self.localdata = {}
		
		local h = self.handle
		local a = self.attr
		local d = self.data
		
		a.skill = {i=0,num=0,index={}}
		a.__stack = a.stack
		a.__counter = a.counter
		a.__mxhp = a.mxhp
		
		d.team = team or 0
		d.hireList = hireList or 0
		d.shopList = shopList or 0
		d.buffs = hApi.createObjectList()
		d.effectU = {i=0}
		d.cdtime = cdtime or 0
		
		--英雄在这里处理一下这些临时参数
		if d.type==hVar.UNIT_TYPE.HERO then
			d.IsBusy = 0	--这个值必须被重置,否则有可能导致角色不接受任何命令
		end
		
		local name
		local tabU = hVar.tab_unit[d.id]
		if tabU then
			d.unitlevel = tabU.unitlevel or 0
			d.IsGate = d.IsGate or 0
		end
		if itemT then
			name = 0
			local id,itemID = unpack(itemT)
			d.itemID = itemID or 0
			local tabI = hVar.tab_item[id]
			if tabI then
				d.model = tabI.model or 0
				d.xlobj = tabI.xlobj or 0
				d.scale = hApi.getint((tabI.scale or 1)*100)
			end
		else
			if hVar.tab_stringU[d.id] then
				name = hVar.tab_stringU[d.id][1] or "UNIT_"..d.id
			else
				name = "UNIT_"..d.id
			end
		end
		
		local w = self:getworld()
		if w then
			d.gridX,d.gridY = w:xy2grid(d.worldX,d.worldY)
			--如果是英雄，或者是摆上去的单位才需要设置triggerID
			--刷出来的怪和刷新点的triggerID是一样的，这个不要设置
			if d.type==hVar.UNIT_TYPE.HERO or d.editorID~=0 then
				local tgrT = w.data.triggerIndex[d.triggerID]
				if tgrT then
					tgrT[1] = ID
					tgrT[2] = __ID
					local tgrD = tgrT[3]
					if tgrD then
						d.name = tgrD.name or name
						d.hint = tgrD.hint or 0
					end
				end
			end
		end
	end
	--初始化系统信息
	self.handle.waypoint = {n=0,e=0,}
	self.handle.sound = {}
end
----------------------------------------------
--重新读取后，初始化数据
_hu.__InitAfterLoaded = function(self)
	--ptiny("_hu:__InitAfterLoaded")
	--print(nil..nil)
	self:__RecoverObjectFromSaveData()
	__DEBUG_init_chaUI(self.chaUI)
	local d = self.data
	local w = hClass.world:find(d.bindW)
	if w==nil then
		print("单位初始化出错，世界并不存在")
		return
	end
	if w.data.type~="worldmap" then
		print("警告:读取的单位并不在世界地图上")
		return self:del()
	end
	self:settemptype(w.data.type)
	if d.triggerID~=0 then
		d.name,d.hint = hApi.GetUnitName(self)
	end
	local worldX,worldY = d.worldX,d.worldY
	self:loadcha(worldX,worldY)
end

_hu.__DeadObjectAfterLoaded = function(self)
	local h = self.handle
	local d = self.data
	h.waypoint = {n=0,e=0,}
	h.sound = {}
end
----------------------------------------------
-- 战场属性
----------------------------------------------
_hu.loadattrBF = function(self, tabU)
	if type(tabU)~="table" then
		return
	end
	local a = self.attr
	local d = self.data
	--读取单位技能
	--print(self.data.name, tabU, tabU.attr)
	if tabU.attr~=nil and tabU.attr.skill~=nil then
		for i = 1,#tabU.attr.skill do
			local id, lv, cooldown = unpack(tabU.attr.skill[i])
			--不等于自己的基本攻击技能才真正为单位添加技能
			if id~=a.attack[1] then
				self:addskill(id,lv,nil, nil, nil, cooldown) --id,lv,count,cd, stack, cooldown
			end
		end
	end
	
	--zhenkira新增,如果单位是塔类型，需要检测升级列表中是否有直接释放的技能。并且不是升级和建造用的塔（目前是互斥的）
	
	local td_upgrade = self.td_upgrade
	if td_upgrade and td_upgrade.castSkill and not td_upgrade.upgradeSkill and not td_upgrade.remould then
		for skillId, skillInfo in pairs(td_upgrade.castSkill) do
			if skillId ~= "order" then
				local skillObj = self:getskill(skillId)
				local addFlag = false
				--判断是否已经添加过此技能
				if not skillObj then
					addFlag = true
				else
					if skillObj[1] ~= skillId and skillObj[2] ~= skillLv and skillObj[5] ~= skillCD then
						addFlag = true
					end
				end
				
				if addFlag and skillId ~= a.attack[1] then
					local lv = skillInfo.lv or 1
					local cd = skillInfo.cd or 10000
					local count = skillInfo.count or 1
					self:addskill(skillId,lv,count, nil, nil, cd, 0) --skillId,lv,count,cd, stack, cooldown
				end
			end
		end
	end
	
	--生命魔法点数
	if d.type==hVar.UNIT_TYPE.HERO then
		--a.hp = 100 --geyachao: 不需要修改默认值为100点血
		--a.mxhp = 100 --geyachao: 不需要修改默认值为100点血
		a.mxhp = a.hp --geyachao: 设定最大生命值
	else
		a.mxhp = a.mxhp==0 and a.hp or a.mxhp
		--a.hp = a.mxhp
		a.mxmp = a.mxmp==0 and a.mp or a.mxmp
		a.mp = a.mxmp
	end
	a.__stack = a.stack	--记录单位进入战场时候的初始数量，万一有单位可以复生的话，复生数量不会超过此数
	a.__counter = a.counter	--记录单位基础反击次数
	a.__mxhp = a.mxhp	--记录单位基础最大生命值
	
	--战场中设置建筑标记
	if d.type==hVar.UNIT_TYPE.BUILDING then
		a.IsBuilding = 1
	end
	--设置一些特殊类型
	if type(tabU.type_ex)=="table" then
		for i = 1,#tabU.type_ex do
			if tabU.type_ex[i]=="MACHINE" then
				d.IsMachine = 1
			end
		end
	end
end
----------------------------------------------
-- skill/buff
----------------------------------------------
--学习技能，并立即释放一次该技能
_hu.learnSkill = function(self, skillId, skillLv)
	--print("learnSkill", tostring(self), skillId, skillLv)
	self:addskill(skillId,skillLv)
	local tCastParam = {level = skillLv,}
	hApi.CastSkill(self, skillId, 0, 100, self, nil, nil, tCastParam)
end

--geyachao: 新加参数 cooldown（单位；毫秒）
--学习技能
--参数equipPos: 该技能所属装备的位置(属于人身上的技能，这里参数不传或传0，为了标识哪些技能是装备技能（装备技能不会减cd）)
_hu.addskill = function(self, id, lv, count, round, stackable, cooldown, equipPos)
	
	cooldown = cooldown or 1000 --geyachao: 默认值1秒（单位；毫秒）
	equipPos = equipPos or 0 --该技能所属装备的位置
	--print("addskill", self.data.name, id, hVar.tab_stringS[id] and hVar.tab_stringS[id][1], lv, count,round,stackable, cooldown, equipPos)
	local d = self.data
	local s = self.attr.skill
	local lasttime = -math.huge --hApi.gametime()  --geyachao: 上一次释放的时间，为了能让技能一开始放出来，这里填一个极小值
	local tabS = hVar.tab_skill[id]
	
	if tabS then
		lv = lv or 1
		
		--表达式
		if (type(lv) == "string") then
			local tmp_lv = 1
			local strExpress = tostring(lv)
			lv = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = tmp_lv,}, strExpress, 0)
		end
		
		round = round or 0
		count = count or tabS.count or 0
		
		stackable = stackable or 0
		local pos = s.index[id] or 0
		
		if (pos ~= 0) and (s[pos]) then --已存在
			if (lv > 0) then
				--[[
				if stackable>0 and s[pos][2]>0 then
					s[pos][2] = math.min(s[pos][2]+lv,math.max(stackable,lv))
				else
					s[pos][2] = lv
				end
				]]
				--geyachao: 如果学习同一个技能，并且可以堆叠，那么叠加等级
				if (stackable == true) or (stackable > 0) then
					s[pos][2] = s[pos][2] + lv --叠加等级
				else
					s[pos][2] = math.max(s[pos][2], lv)
				end
				
				return pos
			else
				s.index[id] = 0
				if s[pos][1]==id then
					s[pos][1] = 0
					s[pos][2] = 0
					s[pos][3] = 0
					s[pos][4] = 0
					s[pos][5] = cooldown --cooldown（单位；毫秒）
					s[pos][6] = lasttime --上次释放的时间
					s[pos][7] = equipPos --装备位置
					s.num = s.num - 1
				end
			end
		else --不存在
			if (lv > 0) then
				for i = 1, s.i, 1 do
					--{id,lv,round}
					if (s[i][1]== 0) then
						s[i][1] = id
						s[i][2] = lv
						s[i][3] = round
						s[i][4] = count
						s[i][5] = cooldown --cooldown（单位；毫秒）
						s[i][6] = lasttime --上次释放的时间
						s[i][7] = equipPos --装备位置
						s.index[id] = i
						s.num = s.num + 1
						return i
					end
				end
				s.i = s.i + 1
				s.num = s.num + 1
				pos = s.i
				s.index[id] = pos
				if type(s[pos])=="table" then
					s[pos][1] = id
					s[pos][2] = lv
					s[pos][3] = round
					s[pos][4] = count
					s[pos][5] = cooldown --cooldown（单位；毫秒）
					s[pos][6] = lasttime --上次释放的时间
					s[pos][7] = equipPos --装备位置
				else
					s[pos] = {id,lv,round,count, cooldown, lasttime, equipPos}
				end
				
				return pos
			end
		end
	end
end

--技能表中i用来计最大使用数 不会减少 num用来计数当前总共有多少技能 
--添加技能时会从1 到i遍历 如果有技能id为0则复用 如果不为0则继续累加
--所以删除是 把index中相关技能id的序号赋值0  且把skill中当前序号的数值全赋值为0 就可以了
_hu.removeskill = function(self,id)
	local d = self.data
	local s = self.attr.skill
	local tabS = hVar.tab_skill[id]
	if tabS then
		local pos = s.index[id] or 0
		if (pos ~= 0) and (s[pos]) then --已存在
			s.index[id] = 0
			if s[pos][1]==id then
				s[pos][1] = 0
				s[pos][2] = 0
				s[pos][3] = 0
				s[pos][4] = 0
				s[pos][5] = 0 --cooldown（单位；毫秒）
				s[pos][6] = 0 --上次释放的时间
				s[pos][7] = 0 --装备位置
				s.num = s.num - 1
			end
		end
	end
end

--{id,lv,round,count,cooldown, lasttime,aiDelegate}
_hu.getskill = function(self,id)
	local d = self.data
	local s = self.attr.skill
	local pos = s.index[id] or 0
	if s[pos]~=nil then
		return s[pos]
	end
end

_hu.enumskill = function(self,code,param,param2)
	--不要在这里面把技能删了
	local s = self.attr.skill
	if s.num>0 then
		for i = 1,s.i do
			if type(s[i])=="table" and s[i][1]~=0 then
				code(s[i],param,param2,self)
			end
		end
	end
end

--统一设置单位所有技能的等级为 newLevel
_hu.setAllSkillLv = function(self, newLevel)
	--不要在这里面把技能删了
	local s = self.attr.skill
	if s.num>0 then
		for i = 1,s.i do
			if type(s[i])=="table" and s[i][1]~=0 then
				s[i][2] = newLevel
			end
		end
	end
end

--技能升级
_hu.lvupskill = function(self, id, lvMax)
	local s = self.attr.skill
	local pos = s.index[id] or 0
	if (pos ~= 0) and (s[pos]) then --已存在
		s[pos][2] = s[pos][2] + 1
		if lvMax then
			s[pos][2] = math.min(s[pos][2], lvMax)
		end
	end
end

_hu.getbuff = function(self,key)
	return hApi.getBindObject(hClass.action,"bindU",self,"buffs",key)
end

local __InsertTempBuff = function(oAction,tTemp)
	tTemp.i = tTemp.i + 1
	tTemp[tTemp.i] = oAction
end
_hu.enumbuff = function(self,code,param,param2)
	local d = self.data
	if d.buffs.i>0 then
		local tTemp = {i=0}
		hApi.enumByClass(self,hClass.action,d.buffs,__InsertTempBuff,tTemp)
		if code then
			for i = 1,tTemp.i do
				code(tTemp[i],param,param2,self)
			end
		end
		return tTemp
	end
end
------------------------------------------------------------------
_hu.addimage = function(self,tEffect,RollByFacing)
	local d = self.data
	if tEffect and self.handle._c~=nil then
		local w = self:getworld()
		local tabU = self:gettab()
		local scaleN
		if tabU and (tabU.type==hVar.UNIT_TYPE.UNIT or tabU.type==hVar.UNIT_TYPE.HERO) then
			local s = (tabU.scaleB or 1)*100
			if s>0 and d.scale>0 then
				scaleN = d.scale/s
			end
		end
		scaleN = scaleN or 1
		for i = 1,#tEffect do
			local v = tEffect[i]
			local model,x,y,scale,facing,scaleByUnit, opacity = unpack(v)
			--print(model,x,y,scale,facing,scaleByUnit)
			
			--geyachao: 针对敌方单位特效做处理
			--414 绿
			--201 黄
			--425 红
			if (model == 414) then
				if (w:GetPlayerMe() == self:getowner()) then
					--print("自己")
				elseif (w:GetPlayerMe():getforce() == self:getowner():getforce()) then
					--print("友军")
					model = 201
				else
					--print("敌人")
					model = 425
				end
			end
			
			--geyachao: 针对敌方单位特效做处理
			--77 绿(0.5)
			--76 黄(0.5)
			--78 红(0.5)
			if (model == 77) then
				if (w:GetPlayerMe() == self:getowner()) then
					--print("自己 0.5")
				elseif (w:GetPlayerMe():getforce() == self:getowner():getforce()) then
					--print("友军 0.5")
					model = 76
				else
					--print("敌人 0.5")
					model = 78
				end
			end
			
			--if (d.owner == 2) then
			--	if (model == 414) then
			--		model = 425
			--	end
			--end
			
			if type(model)=="string" then
				facing = facing or d.facing
				x = x or 0
				y = y or 0
				scale = scale or 1
				local e ={handle={}}
				if RollByFacing==1 then
					if self.data.facing>=90 and self.data.facing<270 then
						x = -1*x
					end
				end
				if scaleByUnit==1 then
					x = x*scaleN
					y = y*scaleN
					scale = scale*scaleN
				end
				hApi.CreateEffectU(e,self,"none",model,scale,x,y,0,0,hApi.animationByFacing(model,"stand",facing),hVar.ZERO)
				--geyachao: 支持特效填透明度
				if opacity and (opacity >= 0) and (opacity <= 255) then
					e.handle.s:setOpacity(opacity)
				end
				d.effectsOnCreate[#d.effectsOnCreate+1] = e --单位创建的时候，身上的特效
			elseif w and hVar.tab_effect[model] then
				if w.data.IsLoading==2 then
					--读取中禁止添加特效
				else
					if scaleByUnit==1 then
						x = x*scaleN
						y = y*scaleN
						scale = scale*scaleN
					end
					local e = w:addeffect(model,0,{hVar.EFFECT_TYPE.UNIT,"EFF_"..i,self,0,RollByFacing},x,y,facing,(scale or 1)*100)
					--geyachao: 支持特效填透明度
					if opacity and (opacity >= 0) and (opacity <= 255) then
						e.handle.s:setOpacity(opacity)
					end
					d.effectsOnCreate[#d.effectsOnCreate+1] = e --单位创建的时候，身上的特效
				end
			end
		end
	end
end

_hu.loadblock = function(self,nBlockMode)
	local tabU = hVar.tab_unit[self.data.id]
	if tabU then
		if type(nBlockMode)~="number" then
			nBlockMode = tabU.block or hVar.UNIT_BLOCK_MODE.NORMAL
		end
		if nBlockMode~=nil and hVar.UNIT_BLOCK[nBlockMode]~=nil then
			self.handle.block = nBlockMode
			self.attr.block = nBlockMode
		else
			self.handle.block = hVar.UNIT_BLOCK_MODE.NONE
			self.attr.block = hVar.UNIT_BLOCK_MODE.NONE
		end
	end
end

--角色设置坐标
--参数 bForceSetPos: 是否强制设置坐标
_hu.setPos = function(self, to_x, to_y, facing, bForceSetPos)
	--防止单位不存在
	if (self.handle._n == nil) then
		return
	end
	
	local oWorld = self:getworld()
	--print("setPos", to_x, to_y, facing)
	--先停止移动
	hApi.UnitStop_TD(self)
	
	--设置角色的位置
	to_x = math.floor(to_x * 100) / 100 --geyachao: 保留2位有效数字，用于同步
	to_y = math.floor(to_y * 100) / 100 --geyachao: 保留2位有效数字，用于同步
	
	--检测该点是否可到达
	local to_x_valid = to_x
	local to_y_valid = to_y
	
	if bForceSetPos then
		--强制设置坐标
		--...
	else
		local result = xlScene_IsGridBlock(g_world, to_x_valid / 24, to_y_valid / 24) --某个坐标是否是障碍
		--print("result=", result)
		if (result == 0) then
			--不是障碍，检测是否在水里
			result = hApi.IsPosInWater(to_x_valid, to_y_valid)
		end
		
		--xlChaMoveToPoint(self.handle._c, ux, uy)
		if (result >= 1) then --不能到达
			--寻找最近的可以到达的点
			to_x_valid, to_y_valid = hApi.GetReachedPoint(self, to_x_valid, to_y_valid)
		end
	end
	
	--设置角色的转向
	local unit_pos_x, unit_pos_y = hApi.chaGetPos(self.handle)
	if (facing == nil) then
		facing = GetFaceAngle(unit_pos_x, unit_pos_y, to_x_valid, to_y_valid) --角色的朝向(角度制)
	end
	if (self.data.type ~= hVar.UNIT_TYPE.BUILDING) and (self.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (self.data.type ~= hVar.UNIT_TYPE.UNITGUN)
	and (self.data.type ~= hVar.UNIT_TYPE.UNITBROKEN) and (self.data.type ~= hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
	and (self.data.type ~= hVar.UNIT_TYPE.UNITDOOR) then --建筑、图腾、武器、可破坏物件、可破坏房子，移动不转向
		hApi.ChaSetFacing(self.handle, facing)
		self.data.facing = facing
		
		--tank: 同步更新绑定的单位的位置（炮口）
		if (self.data.bind_unit ~= 0) then
			local bu = self.data.bind_unit
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯光照）
		if (self.data.bind_light ~= 0) then
			local bu = self.data.bind_light
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯轮子）
		if (self.data.bind_wheel ~= 0) then
			local bu = self.data.bind_wheel
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯影子）
		if (self.data.bind_shadow ~= 0) then
			local bu = self.data.bind_shadow
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯能量圈）
		if (self.data.bind_energy ~= 0) then
			local bu = self.data.bind_energy
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（机枪）
		if (self.data.bind_weapon ~= 0) then
			local bu = self.data.bind_weapon
			if (bu:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
				--print(world:gametime() - bu.attr.last_attack_time)
				if ((oWorld:gametime() - bu.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
					hApi.ChaSetFacing(bu.handle, facing)
					bu.data.facing = facing
				end
			end
		end
		
		--tank: 同步更新绑定的单位的位置（大灯）
		if (self.data.bind_lamp ~= 0) then
			local bu = self.data.bind_lamp
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
	end
	
	self.data.worldX = to_x_valid
	self.data.worldY = to_y_valid
	self.data.gridX, self.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
	self.handle.x = to_x_valid
	self.handle.y = to_y_valid
	hApi.chaSetPos(self.handle, to_x_valid, to_y_valid)
	local node = self.handle._n
	node:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
	
	--[[
	--调试用
	--geyachao: 同步日志: 移动循环
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "moveLoop: oUnit=" .. self.data.id .. ",u_ID=" .. self:getworldC() .. ",to_x_valid=" .. tostring(to_x_valid) .. ",to_y_valid=" .. tostring(to_y_valid) .. ",moves=" .. moves
		hApi.SyncLog(msg)
	end
	]]
	
	--geyachao: 更新角色的区域信息（用于搜敌优化）
	oWorld:updateArea(self, to_x_valid, to_y_valid)
	
	--重置守卫点
	self.data.defend_x = to_x_valid
	self.data.defend_y = to_y_valid
	
	--tank: 同步更新绑定的单位的位置（炮口）
	if (self.data.bind_unit ~= 0) then
		self.data.bind_unit.data.worldX = to_x_valid
		self.data.bind_unit.data.worldX = to_y_valid
		self.data.bind_unit.data.gridX, self.data.bind_unit.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_unit.handle.x = to_x_valid
		self.data.bind_unit.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_unit.handle, to_x_valid, to_y_valid)
		self.data.bind_unit.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_unit.data.defend_x = to_x_valid
		self.data.bind_unit.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_unit, to_x_valid, to_y_valid)
	end
	
	--tank: 同步更新绑定的单位的位置（大灯光照）
	if (self.data.bind_light ~= 0) then
		self.data.bind_light.data.worldX = to_x_valid
		self.data.bind_light.data.worldX = to_y_valid
		self.data.bind_light.data.gridX, self.data.bind_light.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_light.handle.x = to_x_valid
		self.data.bind_light.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_light.handle, to_x_valid, to_y_valid)
		self.data.bind_light.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_light.data.defend_x = to_x_valid
		self.data.bind_light.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_light, to_x_valid, to_y_valid)
	end
	
	--tank: 同步更新绑定的单位的位置（大灯轮子）
	if (self.data.bind_wheel ~= 0) then
		self.data.bind_wheel.data.worldX = to_x_valid
		self.data.bind_wheel.data.worldX = to_y_valid
		self.data.bind_wheel.data.gridX, self.data.bind_wheel.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_wheel.handle.x = to_x_valid
		self.data.bind_wheel.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_wheel.handle, to_x_valid, to_y_valid)
		self.data.bind_wheel.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_wheel.data.defend_x = to_x_valid
		self.data.bind_wheel.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_wheel, to_x_valid, to_y_valid)
	end
	
	--tank: 同步更新绑定的单位的位置（大灯影子）
	if (self.data.bind_shadow ~= 0) then
		local to_x_valid_shadow = to_x_valid + self.data.bind_shadow.attr.bind_offsetX
		local to_y_valid_shadow = to_y_valid + self.data.bind_shadow.attr.bind_offsetY
		
		self.data.bind_shadow.data.worldX = to_x_valid_shadow
		self.data.bind_shadow.data.worldX = to_y_valid_shadow
		self.data.bind_shadow.data.gridX, self.data.bind_shadow.data.gridY = oWorld:xy2grid(to_x_valid_shadow, to_y_valid_shadow)
		self.data.bind_shadow.handle.x = to_x_valid_shadow
		self.data.bind_shadow.handle.y = to_y_valid_shadow
		hApi.chaSetPos(self.data.bind_shadow.handle, to_x_valid_shadow, to_y_valid_shadow)
		self.data.bind_shadow.handle._n:setPosition(to_x_valid_shadow, -to_y_valid_shadow) --设置角色的位置
		
		self.data.bind_shadow.data.defend_x = to_x_valid_shadow
		self.data.bind_shadow.data.defend_y = to_y_valid_shadow
		
		oWorld:updateArea(self.data.bind_shadow, to_x_valid_shadow, to_y_valid_shadow)
	end
	
	--tank: 同步更新绑定的单位的位置（大灯能量圈）
	if (self.data.bind_energy ~= 0) then
		self.data.bind_energy.data.worldX = to_x_valid
		self.data.bind_energy.data.worldX = to_y_valid
		self.data.bind_energy.data.gridX, self.data.bind_energy.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_energy.handle.x = to_x_valid
		self.data.bind_energy.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_energy.handle, to_x_valid, to_y_valid)
		self.data.bind_energy.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_energy.data.defend_x = to_x_valid
		self.data.bind_energy.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_energy, to_x_valid, to_y_valid)
	end
	
	--tank: 同步更新绑定的单位的位置（机枪）
	if (self.data.bind_weapon ~= 0) then
		self.data.bind_weapon.data.worldX = to_x_valid
		self.data.bind_weapon.data.worldX = to_y_valid
		self.data.bind_weapon.data.gridX, self.data.bind_weapon.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_weapon.handle.x = to_x_valid
		self.data.bind_weapon.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_weapon.handle, to_x_valid, to_y_valid)
		self.data.bind_weapon.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_weapon.data.defend_x = to_x_valid
		self.data.bind_weapon.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_weapon, to_x_valid, to_y_valid)
	end
	
	--tank: 同步更新绑定的单位的位置（大灯）
	if (self.data.bind_lamp ~= 0) then
		self.data.bind_lamp.data.worldX = to_x_valid
		self.data.bind_lamp.data.worldX = to_y_valid
		self.data.bind_lamp.data.gridX, self.data.bind_lamp.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
		self.data.bind_lamp.handle.x = to_x_valid
		self.data.bind_lamp.handle.y = to_y_valid
		hApi.chaSetPos(self.data.bind_lamp.handle, to_x_valid, to_y_valid)
		self.data.bind_lamp.handle._n:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		
		self.data.bind_lamp.data.defend_x = to_x_valid
		self.data.bind_lamp.data.defend_y = to_y_valid
		
		oWorld:updateArea(self.data.bind_lamp, to_x_valid, to_y_valid)
	end
	
	--同步更新绑定的追踪特效的位置
	for i = 1, #self.data.bind_tacingeffs, 1 do
		local tEff = self.data.bind_tacingeffs[i]
		local eff = tEff.eff
		local effX = tEff.effX
		local effY = tEff.effY
		eff.handle._n:setPosition(to_x_valid + effX, -to_y_valid - effY)
	end
end

--角色传送（需要该坐标能到移动到达）
_hu.setPosTransfer = function(self, to_x, to_y)
	local oWorld = self:getworld()
	
	--先停止移动
	hApi.UnitStop_TD(self)
	
	--设置角色的位置
	to_x = math.floor(to_x * 100) / 100 --geyachao: 保留2位有效数字，用于同步
	to_y = math.floor(to_y * 100) / 100 --geyachao: 保留2位有效数字，用于同步
	
	--检测该点是否可到达
	local to_x_valid = to_x
	local to_y_valid = to_y
	local waypoint = nil
	--不非法的坐标
	if (to_x_valid > 0) and (to_y_valid > 0) then
		waypoint = xlCha_MoveToGrid(self.handle._c, to_x_valid / 24, to_y_valid / 24, 0, nil)
	end
	--马上调用chaMoveToPoint(自己的点坐标),  就不会触发程序的走路了
	local ux, uy = hApi.chaGetPos(self.handle) --目标的位置
	--xlChaMoveToPoint(self.handle._c, ux, uy)
	if (to_x_valid <= 0) or (to_y_valid <= 0) or (waypoint[0] == 0) or (hApi.IsPosInWater(to_x_valid, to_y_valid) == 1) then --寻路失败，或者在水里
		--寻找最近的可以到达的点
		to_x_valid, to_y_valid = hApi.GetReachedPoint(self, to_x_valid, to_y_valid)
	end
	
	--设置角色的转向
	local unit_pos_x, unit_pos_y = hApi.chaGetPos(self.handle)
	local facing = GetFaceAngle(unit_pos_x, unit_pos_y, to_x_valid, to_y_valid) --角色的朝向(角度制)
	if (self.data.type ~= hVar.UNIT_TYPE.BUILDING) and (self.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (self.data.type ~= hVar.UNIT_TYPE.UNITGUN)
	and (self.data.type ~= hVar.UNIT_TYPE.UNITBROKEN) and (self.data.type ~= hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
	and (self.data.type ~= hVar.UNIT_TYPE.UNITDOOR) then --建筑、图腾、武器、可破坏物件、可破坏房子，移动不转向
		hApi.ChaSetFacing(self.handle, facing)
		self.data.facing = facing
	end
	
	self.data.worldX = to_x_valid
	self.data.worldY = to_y_valid
	self.data.gridX, self.data.gridY = oWorld:xy2grid(to_x_valid, to_y_valid)
	self.handle.x = to_x_valid
	self.handle.y = to_y_valid
	hApi.chaSetPos(self.handle, to_x_valid, to_y_valid)
	local node = self.handle._n
	node:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
	
	--[[
	--调试用
	--geyachao: 同步日志: 移动循环
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "moveLoop: oUnit=" .. self.data.id .. ",u_ID=" .. self:getworldC() .. ",to_x_valid=" .. tostring(to_x_valid) .. ",to_y_valid=" .. tostring(to_y_valid) .. ",moves=" .. moves
		hApi.SyncLog(msg)
	end
	]]
	
	--geyachao: 更新角色的区域信息（用于搜敌优化）
	oWorld:updateArea(self, to_x_valid, to_y_valid)
	
	--重置守卫点
	self.data.defend_x = to_x_valid
	self.data.defend_y = to_y_valid
end

--加载单位模型
_hu.loadcha = function(self,worldX,worldY,sBornAnimation,nBlockMode)
	local d = self.data
	local h = self.handle
	local w = self:getworld()
	if w==nil then
		return
	end
	if type(worldX)~="number" or type(worldY)~="number" then
		worldX,worldY = w:grid2xy(d.gridX,d.gridY)
	end
	h.name = "{"..d.id.."|"..self.ID.."}"..tostring(d.name)
	local tabU = hVar.tab_unit[d.id] or hVar.tab_unit[1]
	local xlPath,modelName
	local IsHideModel = 0
	if d.xlobj~=0 then
		xlPath = d.xlobj
	elseif d.model~=0 then
		modelName = d.model
	else
		xlPath = tabU.xlobj
		modelName = tabU.model
		if tabU.model==0 or (g_editor~=1 and tabU.model=="MODEL:default") then
			IsHideModel = 1
		end
		--类型是建筑的单位,且使用model而非xlobj则如此处理
		if xlPath=="gres_mask" and type(modelName)=="string" then
			xlPath = nil
		end
	end
	--初始化一些特别的数据
	if type(sBornAnimation)~="string" then
		sBornAnimation = "stand"
	end
	--加载障碍信息
	if nBlockMode~=-1 then
		self:loadblock(nBlockMode)
	end
	if w.data.type=="battlefield" then
		local tabU = hVar.tab_unit[d.id]
		if tabU and tabU.modelBF then
			if tabU.modelBF == -1 then
				IsHideModel = 1
				modelName = -1
			else
				modelName = tabU.modelBF
			end
		end
		--只有战场在用
		if tabU.standX~=nil or tabU.standY~=nil then
			d.standX = tabU.standX or 0
			d.standY = tabU.standY or 0
		else
			d.standX,d.standY = self:getstandXY()
		end
		--_DEBUG_MSG("创建单位，",d.name,d.id,"x="..d.standX..",y="..d.standY)
	end
	--加载单位
	if w.data.type=="battlefield" and w.data.IsQuickBattlefield==1 then
		--快速战场不加载cha，也看不见
		self.handle.__appear = 0
		self.handle.__manager = 0
		self.handle.removetime = 0	--如果没这个值会被莫名其妙删掉的
		self:setowner(d.owner,1)
		self:arrive(w,d.gridX,d.gridY,__UNIT_ARRIVE_MODE.BIRTH)
	elseif xlPath~=nil then
		local zOrder = 0
		if tabU.zOrder and type(tabU.zOrder)=="number" then
			zOrder = tabU.zOrder
		end
		self.handle.__appear = 1
		--创建模式:xlobj
		--此模式创建如果对应的文件不存在就挂掉
		--建筑物全部走此模式创建
		hApi.CreateUnitB(self.handle,w.handle.worldScene,xlPath,worldX+d.standX,worldY+d.standY,d.facing,zOrder,d.type)
		if self.handle._c then
			if d.IsHide==1 then
				self:sethide(2)
			end
			_hu.__static.objIdByCha[self.handle._c] = self.ID
			if (d.type==hVar.UNIT_TYPE.ITEM or tabU.sceneobj==1) and d.scale>0 and d.scale~=100 then
				--仅物品要处理缩放
				--print("hApi.SpriteLoadBoundingBox 5")
				hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",d.scale, xlPath)
				self.handle.s:setScale(d.scale/100)
			else
				--print("hApi.SpriteLoadBoundingBox 4")
				hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",100, xlPath)
			end
			self:setowner(d.owner,1)
			self:arrive(w,d.gridX,d.gridY,__UNIT_ARRIVE_MODE.BIRTH)
			if tabU.effectL and tabU.effectR then
				if self.data.facing>=90 and self.data.facing<270 then
					self:addimage(tabU.effectL,0)
				else
					self:addimage(tabU.effectR,0)
				end
			elseif tabU.effect then
				self:addimage(tabU.effect,1)
			elseif tabU.effectL then
				self:addimage(tabU.effectL,1)
			elseif tabU.effectM then --geyachao: 固定偏移，不翻转
				--print("tabU.effectM")
				self:addimage(tabU.effectM,0)
			end
			if tabU.effectW and w.data.type=="worldmap" then
				self:addimage(tabU.effectW,1)
			end
			--如果有强行设置过任何动画标签
			if d.animationTag~=0 and xlCha_ShiftBuildingFrame then
				if d.animationTag==1 then
					xlCha_ShiftBuildingFrame(self.handle._c,1)
				--else
					--xlCha_ShiftBuildingFrame(self.handle._c,0)
				end
			end
			if tabU.motion then
				hUI.setMotion(self.handle.s,0,0,tabU.motion)
			end
			
			--设置颜色
			if d.color and type(d.color) == "table" then
				self.handle.s:setColor(ccc3((d.color[1] or 254),(d.color[2] or 254),(d.color[2] or 254)))
			end
			--设置透明度
			if d.alpha and (d.alpha >= 0) then
				self.handle.s:setOpacity(d.alpha or 254)
			end
			
			return self.handle._c
		else
			_DEBUG_MSG("添加建筑失败！",modelName)
		end
	else
		--创建模式:model
		--此模式创建如果对应的模型不存在则创建一个绿块
		--如果data.scale==0(未初始化)那么就使用tab表格中的缩放，最小单位1%
		if d.scale<=0 then
			d.scale = math.floor((tabU.scale or 1)*100)
		end
		if w.data.type=="worldmap" then
			--(优化)世界地图上的东西刚创建出来是隐藏的
			self.handle.__appear = 1
		else
			self.handle.__appear = 1
		end
		local zOrder = 0
		if tabU.zOrder and type(tabU.zOrder)=="number" then
			zOrder = tabU.zOrder
		end
		if tabU.facing and type(tabU.facing)=="number" then
			--强制设置朝向
			d.facing = tabU.facing
		end
		if IsHideModel==1 then
			--不显示模型的单位
			hApi.CreateUnit(self.handle,w.handle.worldScene,nil,d.scale/100,worldX+d.standX,worldY+d.standY,zOrder,d.facing,sBornAnimation)
		else
			--[[
			--geyachao: 这里初始的英雄也要加载模型
			--省内存优化(EFF)
			--大地图英雄显示优化
			if g_editor~=1 and w.data.type=="worldmap" and d.type==hVar.UNIT_TYPE.HERO and w.data.IsLoading~=0 then
				h.__UnitModelName = modelName
				modelName = nil
			end
			]]
			--print("hApi.CreateUnit", d.id, modelName)
			hApi.CreateUnit(self.handle,w.handle.worldScene,modelName,d.scale/100,worldX+d.standX,worldY+d.standY,zOrder,d.facing,sBornAnimation)
		end
		if h._c~=nil then
			if d.IsHide==1 then
				self:sethide(2)
			end
			_hu.__static.objIdByCha[self.handle._c] = self.ID
			if d.type~=0 then
				xlCha_SetType(h._c,d.type)
			end
			if w.data.type=="worldmap" then
				if tabU and tabU.block==0 then
					xlChaSetBlockRadious(h._c,0)
				else
					xlChaSetBlockRadious(h._c,0) --geyachao : 0
				end
				--如果尚未初始化过移动力，那么读取默认值作为移动力
				if d.movepoint==-1 then
					d.movepoint = hVar.UNIT_DEFAULT_MOVEPOINT
				end
				self:setmovepoint(hVar.UNIT_DEFAULT_MOVEPOINT) --geyachao:修改d.movepoint
			end
			
			
			self.handle.__speed = w.data.speed or 100
			
			--设置移动
			--local movespeed = hVar.UNIT_DEFAULT_SPEED
			--战场内会调整该单位的移动速度
			--if w.data.type=="battlefield" then
				--if tabU.movespeed then
				--	movespeed = tabU.movespeed
				--end
				--movespeed = hApi.getint(movespeed*(w.data.movespeed or 100)/100)
				--movespeed = movespeed * hApi.GetTimeScale()		--by zhenkira:移动速度程序控制，这里要混合时间缩放参数
			--else
				--movespeed = movespeed * hApi.GetTimeScale()		--by zhenkira:移动速度程序控制，这里要混合时间缩放参数
			--end
			local move_speed = hVar.UNIT_DEFAULT_SPEED
			if tabU.move_speed then
				move_speed = tabU.move_speed
			end
			--move_speed = hApi.getint(move_speed*(w.data.movespeed or 100)/100)
			hApi.chaSetMoveSpeed(self.handle, move_speed)
			
			--设置绑定盒子
			local BoxScale = 100
			local tBox = tabU.box
			if d.scale>0 then
				if w.data.type=="battlefield" then
					if tabU.boxB then
						tBox = tabU.boxB
					else
						BoxScale = hApi.getint(d.scale/(tabU.scale or 1))
					end
				--else
					--if (tabU.scale or 1)~=1 then
						--BoxScale = hApi.getint(d.scale/(tabU.scale or 1))
					--end
				end
			end
			--print("hApi.SpriteLoadBoundingBox 3")
			hApi.SpriteLoadBoundingBox(self.handle,tBox,"UNIT",BoxScale, xlPath)
			--加的绑定盒log
			--if w.data.type=="worldmap" then
				--if self.handle._c and self.handle.__box then
					--local bx,by,bw,bh = unpack(self.handle.__box)
					--xlLG("cha_box","day:"..w.data.roundcount.." 设置单位["..d.id.."]("..worldX..","..worldY..")绑定盒["..bx..","..by..","..bw..","..bh..")\n")
				--end
			--end
			if tabU.effectL and tabU.effectR then
				if self.data.facing>=90 and self.data.facing<270 then
					self:addimage(tabU.effectL,0)
				else
					self:addimage(tabU.effectR,0)
				end
			elseif tabU.effect then
				self:addimage(tabU.effect,1)
			elseif tabU.effectL then
				self:addimage(tabU.effectL,1)
			elseif tabU.effectM then --geyachao: 固定偏移，不翻转
				--print("tabU.effectM")
				self:addimage(tabU.effectM,0)
			end
			if tabU.effectW and w.data.type=="worldmap" then
				self:addimage(tabU.effectW,1)
			end
			if tabU.motion then
				hUI.setMotion(self.handle.s,0,0,tabU.motion)
			end
			--设置颜色
			if d.color and type(d.color) == "table" then
				self.handle.s:setColor(ccc3((d.color[1] or 254),(d.color[2] or 254),(d.color[3] or 254)))
			end
			--设置透明度
			if d.alpha and d.alpha >= 0 then
				self.handle.s:setOpacity(d.alpha or 254)
			end
		end
		self:setowner(d.owner,1)
		self:arrive(w,d.gridX,d.gridY,__UNIT_ARRIVE_MODE.BIRTH)
		return self.handle._c
	end
end

local __findTeamIndex = function(t,matchValue,numMax)
	local findI
	for i = 1,#t do
		if type(t[i])=="table" then
			if t[i][1]==matchValue and t[i][2]<numMax then
				return i
			end
		elseif findI==nil then
			findI = i
		end
	end
	if findI then
		return findI
	else
		return #t+1
	end
end

local __IsSafeTeamIndex = function(i)
	return i>=1 and i<=hVar.TEAM_UNIT_MAX
end

local __insertUnitToTeam
__insertUnitToTeam = function(t,id,stack,nStackMax,tAvailableSlot,insertIndex)
	if stack<=0 then
		return false
	end
	local i = insertIndex
	if i~=nil and tAvailableSlot[i]~=1 then
		i = nil
	end
	if i==nil then
		i = __findTeamIndex(t,id,nStackMax,tAvailableSlot)
		
		if tAvailableSlot[i]~=1 then
			return false
		end
	end
	
	if type(t[i])=="table" then
		if t[i][1]~=id then
			return false
		end
		local newStack = math.min(t[i][2]+stack,nStackMax)
		stack = stack - (newStack - t[i][2])
		t[i][2] = newStack
		if stack>0 then
			if insertIndex==nil then
				return __insertUnitToTeam(t,id,stack,nStackMax,tAvailableSlot,nil)
			else
				return false
			end
		end
	else
		t[i] = {id,stack}
	end
	
	return true
end

--_hu.playsound = function(self,key,soundPath,IsLoop)
	--local sound = self.handle.sound
	--if sound[key]~=nil then
		--hApi.StopSound(sound[key])
		--sound[key] = nil
	--end
	--if IsLoop==1 then
		--sound[key] = hApi.PlaySound(soundPath,IsLoop)
	--end
	--xlLG("sound","start unit["..self.ID.."] sound("..key..") handle("..tostring(sound[key])..") loop:("..tostring(IsLoop)..")\n")
--end

--_hu.stopsound = function(self,key)
	--local sound = self.handle.sound
	--if key=="all" then
		--for k,v in pairs(sound)do
			--sound[k] = nil
			--hApi.StopSound(v)
		--end
	--else
		--xlLG("sound","close unit["..self.ID.."] sound("..key..") handle("..tostring(sound[key])..")\n")
		--if sound[key]~=nil then
			--hApi.StopSound(sound[key])
			--sound[key] = nil
		--end
	--end
--end

local __AvailableSlot = {{},{}}
for i = 1,hVar.TEAM_UNIT_MAX do
	__AvailableSlot[1][i] = 1
end
--建筑的兵槽比单位少1个
--for i = 1,hVar.TEAM_UNIT_MAX-1 do
	--__AvailableSlot[2][i] = 1
--end

_hu.teamaddunit = function(self,unitList)
	--{id,stack,insertIndex,MustInsert}
	local team = self.data.team
	if team==0 then
		return hVar.RESULT_FAIL
	else
		local tSlot = __AvailableSlot[1]
		local nStackMax = hVar.UNIT_STACK_MAX
		local teamCopy = hApi.ReadParamWithDepth(team,nil,{},1)
		for i = 1,#unitList do
			if type(unitList[i])=="table" then
				local id,stack,insertIndex,MustInsert = unpack(unitList[i])
				if stack>0 then
					if (insertIndex or 0)<=0 then
						insertIndex = nil
					end
					if not(__insertUnitToTeam(teamCopy,id,stack,nStackMax,tSlot,insertIndex)) then
						if MustInsert==1 and __insertUnitToTeam(teamCopy,id,stack,nStackMax,tSlot,nil) then
							--continue
						else
							return hVar.RESULT_FAIL
						end
					end
				end
			else
				_DEBUG_MSG("[LUA WARNING]unit:teamaddunit()向单位中添加非法的单位")
			end
		end
		if #teamCopy==0 or __IsSafeTeamIndex(#teamCopy) then
			for i = 1,hVar.TEAM_UNIT_MAX do
				self.data.team[i] = teamCopy[i] or 0
			end
			hGlobal.event:call("Event_TeamChange","add",self)
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end
end

_hu.teamgetunit = function(self,tIndex)
	local team = self.data.team
	if team~=0 and __IsSafeTeamIndex(tIndex) then
		if team[tIndex]~=0 then
			return team[tIndex],hVar.RESULT_SUCESS
		else
			return nil,hVar.RESULT_SUCESS
		end
	end
	return nil,hVar.RESULT_FAIL
end

_hu.teamremoveunit = function(self,tIndex,rNum,NoEvent)
	local team = self.data.team
	if team~=0 and __IsSafeTeamIndex(tIndex) then
		local teamU = team[tIndex]
		if teamU~=0 then
			if rNum and rNum>=0 then
				team[tIndex][2] = math.max(team[tIndex][2] - rNum,0)
			else
				team[tIndex][2] = 0
			end
			if team[tIndex][2]<=0 then
				team[tIndex] = 0
			end
			if teamU~=0 and NoEvent~=1 then
				if team[tIndex]==0 then
					hGlobal.event:call("Event_TeamChange","remove",self)
				else
					hGlobal.event:call("Event_TeamChange","add",self)
				end
			end
		end
	end
end

_hu.teamshift = function(self,oIndex,nIndex)
	if self.data.IsBusy==1 then
		_DEBUG_MSG("单位繁忙中，禁止变更队伍位置！")
		return hVar.RESULT_FAIL
	end
	local team = self.data.team
	if team~=0 and __IsSafeTeamIndex(oIndex) and __IsSafeTeamIndex(nIndex) then
		if #team~=hVar.TEAM_UNIT_MAX then
			for i = 1,hVar.TEAM_UNIT_MAX do
				team[i] = team[i] or 0
			end
		end
		local tOld,tNew = team[oIndex],team[nIndex]
		if tOld~=0 and tNew~=0 and tOld[1]==tNew[1] then
			--尝试堆叠单位
			local shiftNum = math.min(tOld[2]+tNew[2],hVar.UNIT_STACK_MAX) - tNew[2]
			tNew[2] = tNew[2] + shiftNum
			tOld[2] = tOld[2] - shiftNum
			if tOld[2]<=0 then
				--旧的已经被消耗干净了！
				team[oIndex] = 0
			end
			hGlobal.event:call("Event_TeamChange","shiftEX",self,tNew,tOld)
		else
			team[oIndex],team[nIndex] = tNew,tOld
			if tNew~=0 or tOld~=0 then
				hGlobal.event:call("Event_TeamChange","shift",self,tNew,tOld)
			end
		end
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_FAIL
	end
end

_hu.iscooldown = function(self,oUnitV)
	local t = self:gettab()
	local cdtime = self.data.cdtime
	if cdtime~=0 and t and type(t.visit) == "table" then
		local vTime,vType = unpack(t.visit)
		local oWorld = self:getworld()
		--非英雄永远无法访问
		local oHero = oUnitV:gethero()
		if oHero==nil then
			return false
		end
		if oWorld and vTime and vType then
			--cd模式
			local cdDay
			if 0 == vType then
				cdDay = cdtime[oHero.ID] or -1
			else
				cdDay = cdtime[0] or -1
			end
			--cd时间
			if vTime<=-1 then --不可再生
				if cdDay~=-1 then
					return false
				else
					return true
				end
			elseif vTime==0 then --无限再生（无CD）
				return true
			elseif vTime%7==0 then	--可以被7除尽的cd被认为是特殊的cd模式,N周
				local dayCount = oWorld.data.roundcount
				if cdDay~=-1 and (dayCount<=cdDay or math.floor(dayCount/7)<=math.floor(cdDay/7)) then
					return false
				else
					return true
				end
			else --按天数再生
				local dayCount = oWorld.data.roundcount
				if cdDay~=-1 and cdDay+vTime>dayCount then
					return false
				else
					return true
				end
			end
		end
	end
	return false
end

_hu.setcooldown = function(self,oUnitV)
	local t = self:gettab()
	local cdtime = self.data.cdtime
	if cdtime~=0 and t and type(t.visit) == "table" then
		local vTime,vType = unpack(t.visit)
		local oWorld = self:getworld()
		--非英雄永远无法访问
		local oHero = oUnitV:gethero()
		if oHero==nil then
			return
		end
		--vTime==0:无限再生（无CD）
		if oWorld and vTime and vType and vTime~=0 then
			if vType==0 then
				self.data.cdtime[oHero.ID] = oWorld.data.roundcount
			else
				self.data.cdtime[0] = oWorld.data.roundcount
			end
		end
	end
end

--_hu.setowner = function(self,nOwner,ForceSetting)
--	if type(nOwner)~="number" then
--		_DEBUG_MSG("[LUA WARNING] unit:setowner() #1 仅能接受number参数!")
--		return
--	end
--	if self.data.owner~=nOwner or (ForceSetting==1 or ForceSetting==2) then
--		self.data.owner = nOwner
--		if self.handle._c~=nil then
--			local w = self:getworld()
--			local withFlag = 0
--			if ForceSetting==2 then
--				withFlag = 1
--			elseif w and w.data.type=="worldmap" and self.data.type==hVar.UNIT_TYPE.BUILDING then
--				withFlag = 1
--			end
--			if w.data.type=="worldmap" then
--				if self:getowner()==hGlobal.LocalPlayer then
--					hApi.chaEnableClearFog(self.handle,1,-1)	--默认视野是14
--					if self.data.IsHide~=1 then
--						local cx,cy = self:getXY()
--						if cx and cy then
--							xlClearFogByPoint(cx,cy)
--						end
--					end
--				else
--					hApi.chaEnableClearFog(self.handle,0,-1)
--				end
--			end
--			return hApi.chaSetOwner(self.handle,nOwner,withFlag)
--		end
--	end
--end

_hu.setowner = function(self,nOwner,ForceSetting)
	if type(nOwner)~="number" then
		_DEBUG_MSG("[LUA WARNING] unit:setowner() #1 仅能接受number参数!")
		return
	end
	if self.data.owner~=nOwner or (ForceSetting==1 or ForceSetting==2) then
		self.data.owner = nOwner
		if self.handle._c~=nil then
			local w = self:getworld()
			local withFlag = 0
			if ForceSetting==2 then
				withFlag = 1
			--elseif w and w.data.type=="worldmap" and self.data.type==hVar.UNIT_TYPE.BUILDING then
				--withFlag = 1
			end
			if w.data.type=="worldmap" then
				--if self:getowner()==hGlobal.LocalPlayer then
				
				if not self:getowner() and self:getowner() == w:GetPlayerMe() then
					hApi.chaEnableClearFog(self.handle,1,-1)	--默认视野是14
					if self.data.IsHide~=1 then
						local cx,cy = self:getXY()
						if cx and cy then
							xlClearFogByPoint(cx,cy)
						end
					end
				else
					hApi.chaEnableClearFog(self.handle,0,-1)
				end
			end
			return hApi.chaSetOwner(self.handle,nOwner,withFlag)
		end
	end
end

_hu.setroundstate = function(self,nState)
	self.data.roundState = nState
end

local __ENUM__AddGrid = function(g,x,y)
	if g.n then
		g.n = g.n + 1
		local p = g[g.n] or {}
		g[g.n] = p
		p.x = x
		p.y = y
	else
		g[#g+1] = {x=x,y=y}
	end
end

_hu.getgrid = function(self,grid,gridX,gridY)
	if grid==nil then
		grid = {}
	end
	local w = self:getworld()
	if w then
		local gX,gY = gridX,gridY
		if not(gX and gY) then
			gX,gY = self.data.gridX,self.data.gridY
		end
		local tBlock = self:getblock(gX,gY)
		if type(tBlock)=="table" then
			for i = 1,#tBlock do
				local x,y = gX+tBlock[i][1],gY+tBlock[i][2]
				if w:IsSafeGrid(x,y) then
					__ENUM__AddGrid(grid,x,y)
				end
			end
		else
			local x,y = gX,gY
			__ENUM__AddGrid(grid,x,y)
		end
	end
	return grid
end

local __grid,__mGridEx,__mGridI
local __InsertMoveGrid = function(gx,gy,i)
	local mGridEx = __mGridEx
	local mGridI = __mGridI
	local v = __grid[i]
	if mGridI[gx.."|"..gy]==nil then
		local nIndex = #mGridEx+1
		mGridI[gx.."|"..gy] = nIndex
		mGridEx[nIndex] = {x=gx,y=gy,link={x=v.x,y=v.y}}
	end
end

_hu.__GetExMoveGrid = function(self,mGrid,mGridEx,mGridI)
	mGridEx = mGridEx or {}
	mGridI = mGridI or {}
	for i = 1,#mGrid do
		local v = mGrid[i]
		mGridI[v.x.."|"..v.y] = i
		mGridEx[#mGridEx+1] = {x=v.x,y=v.y}
	end
	local tBlock = self:getblock()
	if tBlock==nil or tBlock==0 then
		tBlock = 1
	end
	for i = 1,#mGrid do
		__grid,__mGridEx,__mGridI = mGrid,mGridEx,mGridI
		hApi.enumNearGrid(mGrid[i].x,mGrid[i].y,tBlock,__InsertMoveGrid,i)
	end
	return mGridEx,mGridI
end

_hu.getmovegrid = function(self,nMoveRange,IsFlyer,tGate)
	local pGrid = {
		grid = {},
		gridI = {},
		gridEx = {},
	}
	local mGrid = pGrid.grid
	local mGridEx = pGrid.gridEx
	local mGridI = pGrid.gridI
	local w = self:getworld()
	if w then
		if IsFlyer==nil then
			if self.attr.IsFlyer>0 then
				IsFlyer = 1
			else
				IsFlyer = 0
			end
		end
		nMoveRange = nMoveRange or self.attr.move
		if nMoveRange>0 then
			if tGate and #tGate>0 then
				for i = 1,#tGate do
					local v = tGate[i]
					if v.attr.block==hVar.UNIT_BLOCK_MODE.GATE then
						w:removeblockU(v,nil,nil,1)
					end
				end
				w:gridinunitreach(mGrid,self,nMoveRange,IsFlyer)
				for i = 1,#tGate do
					local v = tGate[i]
					if v.attr.block==hVar.UNIT_BLOCK_MODE.GATE then
						w:addblockU(v,nil,nil,1)
					end
				end
			else
				w:gridinunitreach(mGrid,self,nMoveRange,IsFlyer)
			end
			self:__GetExMoveGrid(mGrid,mGridEx,mGridI)
		else
			mGrid[#mGrid+1] = {x=self.data.gridX,y=self.data.gridY}
			self:__GetExMoveGrid(mGrid,mGridEx,mGridI)
			--w:gridinunitrange(mGrid,self,0,0)
		end
	end
	return mGrid,pGrid
end

_hu.getcrossgrid = function(self,mGrid,tGrid)
	local rGrid = {}
	local w = self:getworld()
	if w~=nil then
		local tBlock = self:getblock()
		if type(tBlock)~="table" then
			tBlock = 1
		end
		return hApi.GetCrossGrid(w,tBlock,mGrid,tGrid,rGrid,self.data.gridX,self.data.gridY)
	end
	return rGrid
end

_hu.gettalk = function(self)
	local tData = self:gettriggerdata()
	if tData and tData.talk~=nil then
		return tData.talk
	else
		local tabU = self:gettab()
		if tabU then
			return tabU.talk
		end
	end
end

_hu.settriggerID = function(self,triggerID)
	self.data.triggerID = triggerID
end

_hu.gettriggerdata = function(self)
	local d = self.data
	if d.triggerID~=0 then
		local w = self:getworld()
		if w~=nil then
			local u,d = w:tgrid2unit(d.triggerID)
			if u==self then
				return d
			elseif u~=nil then
				----如果返回了一个刷新点
				----那么判断下自己是不是刷新点刷出来的怪
				----是就返回这个tgrData
				--if u.data.type==hVar.UNIT_TYPE.GROUP and u.data.nTarget==self.ID then
				--	return d
				--end
			end
		end
	end
end

_hu.settriggerdata = function(self,tTriggerData,nTgrID)
	local d = self.data
	local oWorld = self:getworld()
	local oHero = self:gethero()
	nTgrID = nTgrID or d.triggerID
	if oWorld then
		if type(tTriggerData)~="table" then
			tTriggerData = nil
		end
		local tgrList = oWorld.data.triggerIndex
		if nTgrID==d.triggerID and nTgrID>0 and tgrList[nTgrID] then
			--替换triggerData
			tTriggerData = tTriggerData or {unqiueID = nTgrID}
			tgrList[nTgrID][3] = tTriggerData
		else
			if nTgrID>0 and tgrList[nTgrID]~=nil then
				--替换已有的tgrData
				local tData = self:gettriggerdata()
				if tData then
					tgrList[d.triggerID][1] = 0
					tgrList[d.triggerID][2] = 0
				end
				local oUnit = oWorld:tgrid2unit(nTgrID)
				if oUnit then
					oUnit.data.triggerID = 0
				end
				d.triggerID = nTgrID
				if oHero then
					oHero.data.triggerID = d.triggerID
				end
				tgrList[nTgrID][1] = self.ID
				--tgrList[nTgrID][2] = self.__ID
				tgrData[2] = self:getworldC()
				if tTriggerData then
					tgrList[nTgrID][3] = tTriggerData
				end
			else
				--添加新的tgrData
				d.triggerID = #tgrList + 1
				if oHero then
					oHero.data.triggerID = d.triggerID
				end
				tTriggerData = tTriggerData or {unqiueID = nTgrID}
				--tgrList[d.triggerID] = {self.ID,self.__ID,tTriggerData}
				tgrList[d.triggerID] = {self.ID,self:getworldC(),tTriggerData}
			end
		end
	end
end

_hu.getXY = function(self,mode)
	if mode==1 then
		--获得战场逻辑坐标
		local w = self:getworld()
		if w and w.ID~=0 then
			local cX,cY = self:getstandXY()
			local x,y = w:grid2xy(self.data.gridX,self.data.gridY)
			return x+cX,y+cY
		end
		return 0,0
	elseif self.handle._c then
		--获得站立点坐标
		return hApi.chaGetPos(self.handle)
	else
		--无站立点获得逻辑坐标
		local w = self:getworld()
		if w and w.ID~=0 then
			local cX,cY = self:getstandXY()
			local x,y = w:grid2xy(self.data.gridX,self.data.gridY)
			return x+cX,y+cY
		end
		return 0,0
	end
end

_hu.getXYByPos = function(self,gridX,gridY)
	local w = self:getworld()
	if not(gridX and gridY) then
		gridX,gridY = self.data.gridX,self.data.gridY
	end
	if w and w.ID~=0 then
		local cX,cY = self:getstandXY()
		local x,y = w:grid2xy(gridX,gridY)
		return x+cX,y+cY
	end
	return 0,0
end

_hu.getXYG = function(self)
	local w = self:getworld()
	if w then
		return w:xy2grid(self:getXY())
	end
	return 0,0
end

_hu.gethero = function(self)
	return hClass.hero:find(self.data.heroID)
end

_hu.gettown = function(self)
	return hClass.town:find(self.data.townID)
end
_hu.getitem = function(self)
	return hClass.item:find(self.data.itemID)
	--return self.data.itemID
end
_hu.getitemid = function(self)
	return self.data.itemID
end
_hu.setitemid = function(self,itemId)
	self.data.itemID = itemId
end
_hu.getworld = function(self)
	return hClass.world:find(self.data.bindW)
end

_hu.getvisit = function(self)
	local curtown = self.data.curTown
	if curtown ~= 0 then
		local oTown = hClass.town:find(curtown)
		if oTown then
			if oTown:getunit("guard")== self then
				return oTown,"guard"
			elseif oTown:getunit("visitor")== self then
				return oTown,"visitor"
			end
		end
	end
end

_hu.getteam = function(self)
	local t = self.data.team
	if t and t~=0 then
		return t
	end
end

_hu.gettab = function(self)
	return hVar.tab_unit[self.data.id]
end

_hu.getbox = function(self)
	if self.handle.__box~=nil then
		return unpack(self.handle.__box)
	end
	return 0,0,0,0
end

--获得单位身上指定buff_id的buff对象
_hu.getBuffById = function(self, skillId)
	local w = self:getworld()
	
	--[[
	--依次遍历目标是否有此buff
	local tt = self.data["buffs"]
	if tt.index then
		for buff_key, n in pairs(tt.index) do
			if n and (n ~= 0) then
				local oID = tt[n]
				local oBuff = hClass.action:find(oID)
				if oBuff then --目标身上已有此buff
					local buffId = oBuff.data.skillId --buff的技能id
					if (buffId == skillId) then --找到了
						return oBuff
					end
				end
			end
		end
	end
	]]
	local buff_key = "BUFF_" .. skillId
	local oBuff = self:getbuff(buff_key)
	if oBuff then
		return oBuff
	end
	
	--走到这里说明单位无此buff
	return nil
end

--单位死亡流程
_hu.dead = function(self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
	local oWorld = self:getworld()
	if self.handle.UnitInMove==1 then
		self.handle.UnitInMove = 0
		if oWorld~=nil then
			oWorld.data.unitcountM = oWorld.data.unitcountM - 1
		end
	end
	
	if (self.data.IsDead ~= 1) then
		--动画结束
		local OnActionEndFunc = function(bSpecialEvent)
			--获得单位所属波次(目前只有发兵需要检测)
			local wave = self:getWaveBelong()
			--设置波次角色被消灭或漏怪
			hApi.SetUnitInWaveKilled(wave)
			
			--geyachao: 死亡特殊处理函数
			if bSpecialEvent then
				if OnChaDie_Special_Event then
					--安全执行
					hpcall(OnChaDie_Special_Event, self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
					--OnChaDie_Special_Event(self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
				end
			end
			
			--geyachao: 死亡时，检测身上是否有移除buff执行的事件
			--检测目标身上的buff
			local tt = self.data["buffs"]
			if tt.index then
				for buff_key, n in pairs(tt.index) do
					if n and (n ~= 0) then
						local oID = tt[n]
						local oBuff = hClass.action:find(oID)
						if oBuff then --目标身上已有此buff
							--删除buff，删除标记角色身上tag
							--标记角色身上的tag
							local buff_tags = self.data.buff_tags
							if buff_tags then
								local buffTag = oBuff.data.buffTag
								if (buffTag ~= 0) then
									if buff_tags[buffTag] then
										buff_tags[buffTag] = buff_tags[buffTag] - 1
									--else
									--	buff_tags[buffTag] = 0
									end
									--print("-", self.data.name .. "_" .. self:getworldC(), buffTag)
								end
							end
						
							--移除buff触发的技能
							local buffRemoveSkillId = oBuff.data.buffRemoveSkillId
							if (buffRemoveSkillId > 0) then
								local buffRemoveLv = oBuff.data.buffRemoveLv
								if (type(buffRemoveLv) == "string") then
									buffRemoveLv = oBuff.data.tempValue[buffRemoveLv]
								end
								--print("检测是否有移除状态的触发事件-死亡", buffRemoveSkillId, buffRemoveLv)
								
								local tCastParam = {level = buffRemoveLv,}
								--print(oBuff.data.unit.data.name, buffRemoveSkillId, self.data.name, buffRemoveLv)
								hApi.CastSkill(oBuff.data.unit, buffRemoveSkillId, 0, 100, self, nil, nil, tCastParam)
							end
						end
					end
				end
			end
			
			--标记角色死了
			self.data.IsDead = 1
			self.data.IsDefeated = 1
			
			--print("oHero.data.IsDefeated = 1B")
			--self:setanimation({"dead","stand_corpse"})
			--大地图死亡的话就等500ms后移除
			if oWorld~=nil then
				local d = oWorld.data
				--if oWorld.data.type=="battlefield" then --zhenkira：删除
				if d.type=="worldmap" then
					--战场上的单位死亡后不会真正的移除，只是隐藏起来了而已
					local uBlock = self.attr.block
					oWorld:leavegridU(self)		--单位死亡时在这里移除碰撞
					--self.attr.block = 0		--已废弃,不再更改死亡单位的碰撞
					local tabU = hVar.tab_unit[self.data.id]
					if tabU==nil then
						--不知道什么东西死了
					else
						--怪物掉落
						local mapInfo = d.tdMapInfo
						if mapInfo then
							if mapInfo.dropFlag == -1  or (mapInfo.dropFlag > 0 and mapInfo.dropNum < mapInfo.dropFlag) then
								if tabU.drop then
									local dropNum = 1
									if tabU.drop.dropNum and type(tabU.drop.dropNum) == "table" then
										dropNum = oWorld:random(tabU.drop.dropNum[1] or 1,tabU.drop.dropNum[2] or 1)
									end

									local pools = {}
									local totalValue = 0

									--怪物特殊掉落池
									if tabU.drop.pool then
										pools[#pools + 1] = {pool = tabU.drop.pool, value = tabU.drop.totalValue}
										totalValue = totalValue + tabU.drop.totalValue
									end
									
									--公共掉落池
									if tabU.drop.publicDrop and hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].publicDrop then
										local publicDrop = hVar.MAP_INFO[d.map].publicDrop
										for i = 1, #tabU.drop.publicDrop do
											local publicDorpKey = tabU.drop.publicDrop[i]
											if publicDrop[publicDorpKey] then
												pools[#pools + 1] = {pool = publicDrop[publicDorpKey].pool,value = publicDrop[publicDorpKey].totalValue}
												totalValue = totalValue + publicDrop[publicDorpKey].totalValue
												
												--print("publicDrop:",i,publicDorpKey)
											end
										end
									end
									
									--计算掉落的数量
									for n = 1, dropNum do
										local rValue = oWorld:random(1, totalValue)
										local value = rValue
										local initialValue = 0
										local initialValue2 = 0
										local goods = nil
										for i = 1, #pools do
											if rValue > initialValue and rValue <= initialValue + pools[i].value then
												goods = pools[i].pool
												--print("drop:",value, i)
												break
											else
												value = math.max(value - pools[i].value, 1)
												initialValue = initialValue + pools[i].value
											end
										end
										
										--geyachao: 如果随机的数量，和池子的数量一致，那么每次就固定为第n个池子
										if tabU.drop.publicDrop and hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].publicDrop then
											if (tabU.drop.dropNum[1] == tabU.drop.dropNum[2]) and (dropNum == #tabU.drop.publicDrop) and (dropNum == #pools) then
												goods = pools[n].pool
											end
										end
										
										if goods and type(goods) == "table" then
											--initialValue2 = 0
											
											--print("drop value:",value)
											--遍历，看权重落在哪个区段
											for i = 1, #goods do
												if value > initialValue2 and value <= initialValue2 + goods[i].value then
													--print("shopType6:")
													local drop = goods[i].id
													local dropAll = goods[i].dropAll --是否全部掉落
													if drop then
														local drop_new = {}
														if (type(drop) == "number") then
															drop_new[#drop_new+1] = drop
														elseif type(drop) == "table" then
															if dropAll then
																for idx = 1, #drop, 1 do
																	drop_new[#drop_new+1] = drop[idx]
																end
															else
																local idx = oWorld:random(1, #drop)
																drop_new[#drop_new+1] = drop[idx]
															end
														end
														--if id and hVar.tab_unit[id] then
														
														for dr = 1, #drop_new, 1 do
															local id = drop_new[dr]
															--geyachao: 如果掉出来的是升级武器，并且武器已经升到顶了，替换为别的道具
															if (id == 12010) then
																--寻找坦克
																local myTank = nil
																oWorld:enumunit(function(eu)
																	if (eu.data.id == hVar.MY_TANK_ID) then --我的坦克
																		myTank = eu
																	end
																end)
																--存在我的坦克
																if myTank then
																	local bu = myTank.data.bind_weapon
																	if bu and (bu ~= 0) then
																		local lv = bu.attr.attack[6] --普通攻击的等级
																		if (lv >= hVar.ROLE_NORMALATK_MAXLV) then
																			local dropNew = {12008,12009,    12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025,}
																			--local dropNew = {12024,} --测试  --test
																			local idx = oWorld:random(1, #dropNew)
																			id = dropNew[idx]
																		end
																	end
																end
															end
															
															--如果是随机迷宫，读取本层的掉落倍率，决定本次是否掉落，或者掉落多个
															--仅针对BOSS
															local dropRatio = 1.0
															if (d.map == hVar.RandomMap) then
																if (self.data.type == hVar.UNIT_TYPE.HERO) then
																	local tabM = hVar.MAP_INFO[d.map]
																	local diffEnemyDropRatio = tabM.diffEnemyDropRatio
																	if diffEnemyDropRatio then
																		local stage = oWorld.data.randommapStage
																		dropRatio = diffEnemyDropRatio[stage] or 1.0
																		print("随机迷宫=", d.map)
																		print("stage=", stage)
																		print("dropRatio=", dropRatio)
																	end
																	
																	--小于1表示有几率不掉
																	if (dropRatio < 1) then
																		local probablity = dropRatio * 100
																		local randValue = oWorld:random(1, 100)
																		if (randValue > probablity) then
																			id = -1
																			print("本次不掉")
																		end
																	end
																end
															end
															
															if id and hVar.tab_item[id] then
																local itemtype = hVar.tab_item[id].type
																if itemtype ==  hVar.ITEM_TYPE.MAPITEM or itemtype ==  hVar.ITEM_TYPE.WEAPON
																or itemtype ==  hVar.ITEM_TYPE.HEAD or itemtype == hVar.ITEM_TYPE.BODY
																or itemtype == hVar.ITEM_TYPE.FOOT or itemtype == hVar.ITEM_TYPE.ORNAMENTS
																or (itemtype == hVar.ITEM_TYPE.WEAPON_GUN) or (itemtype == hVar.ITEM_TYPE.CHEST_WEAPON_GUN)
																or (itemtype == hVar.ITEM_TYPE.CHEST_TACTIC) or (itemtype == hVar.ITEM_TYPE.CHEST_PET)
																or (itemtype == hVar.ITEM_TYPE.TACTIC_USE) or (itemtype == hVar.ITEM_TYPE.TALK)
																or (itemtype == hVar.ITEM_TYPE.SAVEDATAPOINT) or (itemtype == hVar.ITEM_TYPE.CHEST_EQUIP) then
																	local DROPLOOP = 1
																	if (dropRatio > 1) then --大于1表示倍率掉落
																		DROPLOOP = math.floor(dropRatio)
																	end
																	
																	for droploop = 1, DROPLOOP, 1 do
																		local tabI = hVar.tab_item[id]
																		local uId = tabI.dropUnit or 20001
																		
																		local deadUnitX, deadUnitY = hApi.chaGetPos(self.handle) --死亡的单位的坐标
																		--local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
																		local gridX, gridY = deadUnitX, deadUnitY
																		
																		--大菠萝，不随机了，直接掉原地
																		local r = 0 --oWorld:random(12, radius) --随机偏移半径
																		
																		--掉落多个
																		if (dropNum > 1) then
																			--local radius = 64
																			--r = oWorld:random(12, radius) --随机偏移半径
																			r = n * 12
																		end
																		
																		--掉落全部
																		if dropAll then
																			r = oWorld:random(12, 48) --随机偏移半径
																		end
																		
																		local face = oWorld:random(0, 360)
																		local fangle = face * math.pi / 180 --弧度制
																		fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
																		local dx = r * math.cos(fangle) --随机偏移值x
																		local dy = r * math.sin(fangle) --随机偏移值y
																		dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
																		dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
																		
																		gridX = gridX + dx --随机x位置
																		gridY = gridY + dy --随机y位置
																		gridX, gridY = hApi.Scene_GetSpace(gridX, gridY, 60)
																		
																		local forcePlayer = oWorld:GetForce(oKillerSide)
																		local owner = forcePlayer:getpos()
																		
																		hApi.addTimerOnce("__UNIT_DROP_" .. self:getworldC() .. "_" .. n .. "_" .. dr .. "_" .. droploop, n * 16, function()
																			--print("oWorld:dropunit:",id,oKillerPos,face,gridX,gridY)
																			local oItem = oWorld:addunit(uId, oKillerPos,nil,nil,face,gridX,gridY,nil,nil)
																			oItem:setitemid(id)
																			mapInfo.dropNum = mapInfo.dropNum + 1
																			--local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.1), CCScaleTo:create(1.0, 1.0))
																			--oItem.handle._n:runAction(CCRepeatForever:create(towAction))
																			--print(oItem, oItem.data.name)
																			
																			--设置生存时间
																			local livetime = hVar.tab_item[id].dropUnitLivetime
																			if livetime and (livetime > 0) then
																				oItem:setLiveTime(livetime)
																			end
																			
																			--标识战术卡等级的特效
																			local tacticId = tabI.tacticId or 0
																			--print(tacticId)
																			if (tacticId > 0) then
																				local tacticLv = 1
																				local tTactics = LuaGetPlayerSkillBook()
																				if tTactics then
																					for i = 1, #tTactics, 1 do
																						if type(tTactics[i])=="table" then
																							local id, lv, num = unpack(tTactics[i])
																							if (id == tacticId) then --找到了
																								tacticLv = lv
																								break
																							end
																						end
																					end
																				end
																				if (tacticLv > 0) then
																					if (itemtype ~= hVar.ITEM_TYPE.WEAPON_GUN) then
																						--print(tacticId, tacticLv)
																						local COLORS = {120, 77, 79, 138, 78}
																						--76 黄色
																						--120 白色 ok
																						--77 绿色  ok
																						--79 蓝色  ok
																						--78 红色
																						--138 橙色 ok
																						--139 青色 ok
																						local effect = 
																						{
																							{COLORS[tacticLv],-8,-60,1,},
																							{COLORS[tacticLv],8,-60,1,},
																						}
																						oItem:addimage(effect,0)
																					end
																				end
																			end
																			
																			--淡入动画效果
																			if livetime and (livetime > 0) then
																				if oItem.handle.s then
																					local act1 = CCEaseSineOut:create(CCFadeIn:create(1.0)) --淡入
																					local actDelay = CCDelayTime:create(livetime/1000-5)
																					local act2 = CCFadeOut:create(0.5)
																					local act3 = CCFadeIn:create(0.5)
																					local act4 = CCFadeOut:create(0.5)
																					local act5 = CCFadeIn:create(0.5)
																					local act6 = CCFadeOut:create(0.5)
																					local act7 = CCFadeIn:create(0.5)
																					local act8 = CCFadeOut:create(0.5)
																					local act9 = CCFadeIn:create(0.5)
																					local a = CCArray:create()
																					a:addObject(act1)
																					a:addObject(actDelay)
																					a:addObject(act2)
																					a:addObject(act3)
																					a:addObject(act4)
																					a:addObject(act5)
																					a:addObject(act6)
																					a:addObject(act7)
																					a:addObject(act8)
																					a:addObject(act9)
																					local sequence = CCSequence:create(a)
																					oItem.handle.s:runAction(CCRepeatForever:create(sequence))
																				end
																			end
																			
																			--武器枪，在地面一直转动
																			if (itemtype == hVar.ITEM_TYPE.WEAPON_GUN) then
																				local DELTTIME = 0.06
																				local COUNT = 32
																				local ANGLE = 360 / 32
																				local a = CCArray:create()
																				for n = 1, COUNT, 1 do
																					local delayN = CCDelayTime:create(DELTTIME)
																					local rotN = CCCallFunc:create(function()
																						local facing = face + ANGLE * n
																						if (facing >= 360) then
																							facing =  facing - 360
																						end
																						hApi.ChaSetFacing(oItem.handle, facing)
																					end)
																					
																					a:addObject(delayN)
																					a:addObject(rotN)
																				end
																				local sequence = CCSequence:create(a)
																				--oItem.handle._n:stopAllActions()
																				oItem.handle._n:runAction(CCRepeatForever:create(sequence))
																			end
																			
																			--使用类战术卡，旋转
																			if (itemtype == hVar.ITEM_TYPE.TACTIC_USE) then
																				local time = math.random(600, 1000)
																				local t = time / 1000
																				local rot1 = CCOrbitCamera:create(t,-1,0,90,90,0,0)
																				local rot2 = CCOrbitCamera:create(t,1,0,0,90,0,0)
																				local rot3 = CCOrbitCamera:create(t,1,0,90,90,0,0)
																				local rot4 = CCOrbitCamera:create(t,-1,0,0,90,0,0)
																				local a = CCArray:create()
																				a:addObject(rot1)
																				a:addObject(rot2)
																				a:addObject(rot3)
																				a:addObject(rot4)
																				local sequence = CCSequence:create(a)
																				--oItem.handle.s:stopAllActions()
																				oItem.handle.s:runAction(CCRepeatForever:create(sequence))
																			end
																			
																			--宝箱类，上下跳动
																			if (itemtype == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) or (itemtype == hVar.ITEM_TYPE.CHEST_TACTIC) or (itemtype == hVar.ITEM_TYPE.CHEST_PET) or (itemtype == hVar.ITEM_TYPE.CHEST_EQUIP) then
																				local time = math.random(800, 1200)
																				--宝物图标随机动画
																				local delayTime1 = math.random(800, 1200)
																				local delayTime2 = math.random(900, 1500)
																				local moveTime = math.random(1000, 2500)
																				local moveDy = math.random(8, 16)
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
																				oItem.handle.s:runAction(CCRepeatForever:create(sequence))
																			end
																			
																			--如果是随机地图，那么将此特单位储起来，切换关卡时待删除
																			local regionId = oWorld.data.randommapIdx
																			if (regionId > 0) then
																				local regionData = oWorld.data.randommapInfo[regionId]
																				if regionData then
																					local drop_units = regionData.drop_units --掉落道具集
																					if drop_units then
																						drop_units[oItem] = oItem:getworldC()
																						--print("添加 drop_units", oItem.data.name, oItem:getworldC())
																					end
																				end
																			end
																		end)
																	end
																end
															end
														end
													end
													
													break
												end
												initialValue2 = initialValue2 + goods[i].value
											end
										end
									end
								end
							end
						end
						
						if tabU.type==hVar.UNIT_TYPE.UNIT or tabU.type==hVar.UNIT_TYPE.HERO then
							--亡语技能
							local oRound = oWorld:getround()
							if oRound then
								oRound:activeaction(oRound.data.wAction.UnitDead,self,hVar.ROUND_DEFINE.ACTIVE_MODE.ALL)
							end
							if self.data.bossID==-1 then
								--大型怪物主体，死亡后摧毁所有非装饰类part
								if vParam~="ex" then
									local bossID = self.ID
									oWorld:enumunit(function(u)
										if u.data.partID~=0 and u.data.bossID==bossID then
											local tabU_P = hVar.tab_unit[u.data.id]
											--摧毁所有属于我的部件，并且类型不等于怪物主体的单位
											if tabU_P and tabU_P.attr and tabU_P.attr.hp~=-1 then
												u:dead(nOperate,oKillerUnit,nId,"ex")
											end
										end
									end)
								end
							else
								--如果自己是大型怪物的一部分,并且主体是无敌的
								if vParam~="ex" then
									if self.data.bossID>0 then
										local bossID = self.data.bossID
										local oUnitB = hClass.unit:find(bossID)
										if oUnitB and oUnitB.attr.mxhp<0 then
											local nPartCount = 0
											oWorld:enumunit(function(u)
												if u.data.partID~=0 and u.data.bossID==bossID and u.attr.mxhp>0 and u.data.IsDead==0 then
													nPartCount = nPartCount + 1
												end
											end)
											if nPartCount<=0 then
												hApi.BFUnitDeadLog(oUnitB:getworld(),oUnitB,oKillerUnit,nId)
												oUnitB:dead(nOperate,oKillerUnit,nId,"ex")
											end
										end
									end
								end
							end
						end
					end
					local nDeadBlock = tabU.block_ex or 0
					if nDeadBlock==-1 or (nDeadBlock==0 and tabU.type==hVar.UNIT_TYPE.BUILDING) then
						--死亡后立刻移除
						self.handle.removetime = -1
					elseif nDeadBlock>0 then
						--死亡后仍然存在碰撞(城墙/城门/船怪部件)
						if hVar.UNIT_BLOCK[nDeadBlock] then
							self.attr.block = nDeadBlock
							oWorld:entergridU(self)
						end
						--print("hApi.SpriteLoadBoundingBox 2")
						hApi.SpriteLoadBoundingBox(self.handle,nil,"NONE",100)
					else
						--死亡后延迟
						hApi.SpriteShowDead(self.handle,"unit")
						self.handle.removetime = 450
					end
					
					--删除移动的箭头特效
					if (self.data.JianTouEffect ~= 0) then
						self.data.JianTouEffect:del()
						self.data.JianTouEffect = 0
					end
					
					--删除攻击箭头的特效
					if (self.data.AttackEffect ~= 0) then
						self.data.AttackEffect:del()
						self.data.AttackEffect = 0
					end
					
					--删除隐身特效
					if (self.attr.yinshen_effect ~= 0) then
						self.attr.yinshen_effect:del()
						self.attr.yinshen_effect = 0
					end
					
					--[[
					--删除物理免疫的特效
					if (self.data.immue_physic_effect ~= 0) then
						self.data.immue_physic_effect:del()
						self.data.immue_physic_effect = 0
					end
					]]
					
					--[[
					--删除法术免疫的特效
					if (self.data.immue_magic_effect ~= 0) then
						self.data.immue_magic_effect:del()
						self.data.immue_magic_effect = 0
					end
					]]
					
					--[[
					--删除免控的特效
					if (self.data.immue_control_effect ~= 0) then
						self.data.immue_control_effect:del()
						self.data.immue_control_effect = 0
					end
					]]
					
					--[[
					--删除免疫负面属性效果的特效
					if (self.data.immue_debuff_effect ~= 0) then
						self.data.immue_debuff_effect:del()
						self.data.immue_debuff_effect = 0
					end
					]]
					
					--[[
					--删除无敌的特效
					if (self.data.immue_wudi_effect ~= 0) then
						self.data.immue_wudi_effect:del()
						self.data.immue_wudi_effect = 0
					end
					]]
					
					--[[
					--删除混乱的特效
					if (self.data.suffer_chaos_effect ~= 0) then
						self.data.suffer_chaos_effect:del()
						self.data.suffer_chaos_effect = 0
					end
					]]
					
					--[[
					--删除吹风的特效
					if (self.data.suffer_blow_effect ~= 0) then
						self.data.suffer_blow_effect:del()
						self.data.suffer_blow_effect = 0
					end
					]]
					
					--[[
					--删除穿刺的特效
					if (self.data.suffer_chuanci_effect ~= 0) then
						self.data.suffer_chuanci_effect:del()
						self.data.suffer_chuanci_effect = 0
					end
					]]
					
					--[[
					--删除沉睡的特效
					if (self.data.suffer_sleep_effect ~= 0) then
						self.data.suffer_sleep_effect:del()
						self.data.suffer_sleep_effect = 0
					end
					]]
					
					--设置不隐身的透明度
					--self.handle.s:setOpacity(255)
					
					--锁定的目标为空
					--self.data.lockTarget = 0
					--self.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(self, 0, 0)
					--print("lockType 1", self.data.name, 0)
					
				--	if (nOperate or 0)>=0 then
				--		hApi.SpriteShowDead(self.handle,"unit")
				--		self.handle.removetime = hApi.gametime() + 500		--在500ms后移除这个单位
				--	else
				--		return self:del()
				--	end
				end
			end
			--if (nOperate or 0)>=1 then
			--geyachao: 都给回调
			--print("oKillerUnit=", oKillerUnit and oKillerUnit.data.name)
				return hGlobal.event:call("Event_UnitDead", self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
			--end
		end
		
		local aniKey = "dead"
		local md = hVar.tab_model[self.handle.modelIndex]
		local _,IsSafe = hResource.model:safeAnimation(self.handle,md,aniKey)
		
		--有死亡动作，播放死亡动作，再死亡
		if (IsSafe == hVar.RESULT_SUCESS) then
			--print("有死亡动作")
			hApi.UnitStop_TD(self)
			
			--geyachao: 死亡特殊处理函数
			if OnChaDie_Special_Event then
				--安全执行
				hpcall(OnChaDie_Special_Event, self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
				--OnChaDie_Special_Event(self, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
			end
			
			--标记角色死了
			self.data.IsDead = 1
			self.data.IsDefeated = 1
			self.attr.stun_stack = self.attr.stun_stack + 1 --加眩晕
			
			local repeatCount = 1
			local forceToPlay = true
			local animtime = hApi.SpritePlayAnimation(self.handle,aniKey,repeatCount,forceToPlay)
			--动画可能提前播完，这里少点时间
			if (animtime > 30) then
				animtime = animtime - 30
			end
			local act1 = CCDelayTime:create(animtime/1000)
			--print("time=", animtime/1000+1.1)
			local act2 = CCCallFunc:create(function()
				--self.data.IsDead = 0
				--self.data.IsDefeated = 0
				
				OnActionEndFunc(false)
			end)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			local sequence = CCSequence:create(a)
			self.handle._n:runAction(sequence)
		else
			--print("无死亡动作")
			--无死亡动作，直接死亡
			OnActionEndFunc(true)
		end
	end
end

--单位删除流程
--[[
_hu.__del = function(self)
	local oWorld = self:getworld()
	
	--geyachao: 标记移动无效
	self.data.MOVE_valid = false --移动是否有效（用于内存优化）
	
	--geyachao: 存储区域信息（用于搜敌优化）
	oWorld:removeArea(self)
end
]]

--单位掉落一件道具
_hu.dropItem = function(self, itemId, offsetX, offsetY, facing)
	local oWorld = hGlobal.WORLD.LastWorldMap
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	facing = facing or 0
	
	local unitX, unitY = hApi.chaGetPos(self.handle) --死亡的单位的坐标
	local itemX = unitX + offsetX
	local itemY = unitY + offsetY
	--itemX, itemY = hApi.Scene_GetSpace(itemX, itemY, 60)
	
	--print("oWorld:dropunit:",id,oKillerPos,face,unitX,unitY)
	local tabI = hVar.tab_item[itemId]
	local typeId = tabI.dropUnit or 0
	if (typeId > 0) then
		--local force = self:getowner():getforce()
		local side = self:getowner():getpos()
		local oItem = oWorld:addunit(typeId, side, nil, nil, facing, itemX, itemY, nil, nil)
		
		oItem:setitemid(itemId)
		--mapInfo.dropNum = mapInfo.dropNum + 1
		--local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.1), CCScaleTo:create(1.0, 1.0))
		--oItem.handle._n:runAction(CCRepeatForever:create(towAction))
		--print(oItem, oItem.data.name)
		
		--设置生存时间
		local livetime = tabI.dropUnitLivetime
		if livetime and (livetime > 0) then
			oItem:setLiveTime(livetime)
		end
		
		--淡入动画效果
		if livetime and (livetime > 0) then
			if oItem.handle.s then
				local act1 = CCEaseSineOut:create(CCFadeIn:create(1.0)) --淡入
				local actDelay = CCDelayTime:create(livetime/1000-5)
				local act2 = CCFadeOut:create(0.5)
				local act3 = CCFadeIn:create(0.5)
				local act4 = CCFadeOut:create(0.5)
				local act5 = CCFadeIn:create(0.5)
				local act6 = CCFadeOut:create(0.5)
				local act7 = CCFadeIn:create(0.5)
				local act8 = CCFadeOut:create(0.5)
				local act9 = CCFadeIn:create(0.5)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(actDelay)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				local sequence = CCSequence:create(a)
				oItem.handle.s:runAction(CCRepeatForever:create(sequence))
			end
		end
		return oItem
	else
		print("dropItem: itemId=" .. tostring(itemId) .. "未定义单位id！")
	end
end

local __TokenTab = {}
--复制一个sprite(image)
_hu.copyimage = function(self,parentNode,nX,nY,nZ)
	local h = self.handle
	local d = self.data
	local s = CCSprite:create()
	self:initmodel()
	local handleTable = hApi.CreateIllusion({s = s},h,facing)
	local parent
	local x,y,z = 0,0,0
	local facing = d.facing
	if parentNode~=nil and type(parentNode)=="userdata" then
		parent = parentNode
		x = nX or x
		y = nY or y
		z = nZ or z
	else
		if h._c~=nil then
			x,y = hApi.chaGetPos(h)
			if type(p)~="table" then
				p = __TokenTab
			end
			parent = p.parent or h._sce
			y = (parent==h._sce and -1 or 1)*(p.y or y)
			x = p.x or x
			z = p.z or (parent==h._sce and h._n:getZOrder() or 0)
		end
	end
	if type(parent)=="userdata" then
		--if parent==hGlobal.WORLD_LAYER["worldmap"] then
			--xlLG("ui_illusion","创建镜像成功，世界:worldmap\n")
		--else
			--xlLG("ui_illusion","创建镜像成功，自定义layer\n")
		--end
		s:setPosition(x,y)
		parent:addChild(s,z)
		return s,handleTable
	else
		--xlLG("ui_illusion","创建镜像失败\n")
		handleTable.s = nil
		return nil,nil
	end
end

--[[
_hu.setpos = function(self,x,y)
	
end
]]

_hu.setgridpos = function(self,gridX,gridY)
	
end

_hu.getowner = function(self)
	local w = self:getworld()
	if w then
		--print("getowner", self.data.name, self.data.owner)
		return w:GetPlayer(self.data.owner)
	end
	--if hGlobal.player then
	--	return hGlobal.player[self.data.owner]
	--end
end

_hu.getcontroller = function(self)
	if hGlobal.player then
		return hGlobal.player[self.data.control]
	end
end

_hu.operatable = function(self,oPlayer)
	if self:getowner()==oPlayer then
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_FAIL
	end
end

_hu.playanimation = function(self,aniKey,MustPlay)
	if self.handle.__manager=="lua" then
		--瘫痪、冻结状态(非强制播放的话)不可播放动作
		if MustPlay~=1 and (self.attr.paralyzed>0 or self.attr.frozen>0) then
			return 1
		end
		self:onAnimationChange()
		hApi.SpriteSetAnimationCount(self.handle,aniKey,1)
		return self.handle.animationtime
	else
		return -1
	end
end

local __CODE__GetMorphAnimation = function(sAnimation,tRecv)
	local case = type(sAnimation)
	if case=="string" then
		return sAnimation,sAnimation
	elseif case=="table" then
		local tAnimation = sAnimation
		if tRecv==nil then
			tRecv = {}
		end
		for i = 1,#tAnimation do
			tRecv[#tRecv+1] = tAnimation[i]
		end
		if type(tAnimation[#tAnimation])=="string" then
			return tAnimation[#tAnimation],tRecv
		else
			return 0,tRecv
		end
	else
		return 0,sAnimation
	end
end

_hu.setanimation = function(self,sAnimation,MustPlay)
	--print("         ", "setanimation", sAnimation, MustPlay)
	--if (self.data.id == 6000) then
	--	print(sAnimation)
	--	print(debug.traceback())
	--end
	--(优化)不稳定代码
	if self.handle.__appear==0 then
		return
	end
	if self.handle._c==nil then
		return -1
	end
	local d = self.data
	local h = self.handle
	if h.__manager=="lua" then
		--瘫痪、冻结状态不可播放动作
		if (self.attr.paralyzed>0 or self.attr.frozen>0) then
			return 1
		end
		--判断是否存在变化型动作
		local case = type(sAnimation)
		local tabU = hVar.tab_unit[d.id]
		if tabU and tabU.morph and h.s~=nil then
			local sMyAnimation = d.animation
			if d.animation==0 then
				sMyAnimation = "stand"
			end
			local x,y = h.s:getPosition()
			if y~=0 then
				sMyAnimation = "fly"
			end
			if tabU.morph[sMyAnimation] then
				local tMorph = tabU.morph[sMyAnimation]
				if case=="string" then
					if tMorph[sAnimation] then
						d.animation,sAnimation = __CODE__GetMorphAnimation(tMorph[sAnimation])
						case = type(sAnimation)
					end
				elseif case=="table" then
					d.animation = 0
					local tAnimation = sAnimation
					sAnimation = {}
					for i = 1,#tAnimation do
						local sAniName = tAnimation[i]
						if tMorph[sAniName] then
							d.animation = __CODE__GetMorphAnimation(tMorph[sAniName],sAnimation)
						else
							sAnimation[#sAnimation+1] = sAniName
						end
					end
				else
					d.animation = 0
				end
			end
		end
		if sAnimation=="arrive" then
			sAnimation = "stand"
		end
		self:onAnimationChange()
		if case=="table" then
			hApi.ChaSetAnimationByList(h,sAnimation)
			return h.animationtime
		elseif case=="string" then
			hApi.ChaSetAnimation(h,sAnimation,nil,MustPlay)
			return h.animationtime
		end
	elseif h.__manager=="xlobj" then
		if xlCha_ShiftBuildingFrame then
			if sAnimation==0 then
				self.data.animationTag = 0
				xlCha_ShiftBuildingFrame(h._c,0)
			else
				self.data.animationTag = 1
				xlCha_ShiftBuildingFrame(h._c,1)
			end
		end
		return 1
	else
		return -1
	end
end

_hu.getanimation = function(self)
	return tostring(self.handle.animation)
end

_hu.getanimationtime = function(self,aniKey)
	local m = hVar.tab_model[self.handle.modelIndex]
	aniKey = aniKey or self.handle.animation
	return m and m[aniKey] and m[aniKey].animationtime or 0
end

_hu.safeanimation = function(self,aniKey)
	local m = hVar.tab_model[self.handle.modelIndex]
	if m then
		return hResource.model:safeAnimation(self.handle,m,aniKey)
	else
		return nil,hVar.RESULT_FAIL
	end
end
----------------------------------------------------------
_hu.facetoXY = function(self,tx,ty,FacingBySkill)
	local d = self.data
	local h = self.handle
	local w = hClass.world:find(d.bindW)
	if w and tx and ty then
		local x,y = w:grid2xy(d.gridX,d.gridY)
		local facing = hApi.angleBetweenPoints(x+d.standX,y+d.standY,tx,ty)
		if h._c~=nil then
			--如果是施放技能的话，会被特殊处理掉
			if FacingBySkill==1 and h.modelmode==0 then
				if (facing>=75 and facing<=105) or (facing>=255 and facing<=285) then
					--两方向模型在这里有一些比较特殊的处理,朝向这些方向的时候是不转向的
					return
				end
			end
			hApi.ChaSetFacing(self.handle,facing)
		end
		d.facing = facing
	end
end

_hu.facetogrid = function(self,gridX,gridY)
	local d = self.data
	local h = self.handle
	local w = hClass.world:find(d.bindW)
	if w and gridX and gridY then
		local x,y = w:grid2xy(d.gridX,d.gridY)
		local tx,ty = w:grid2xy(gridX,gridY)
		d.facing = hApi.angleBetweenPoints(x+d.standX,y+d.standY,tx,ty)
		if h._c~=nil then
			hApi.ChaSetFacing(self.handle,d.facing)
		end
	end
end

--|1 2 3|--|135  90  45|
--|4 * 5|--|180  *    0|
--|6 7 8|--|225 270 305|
_hu.facingto = function(self,angle)
	local d = self.data
	local h = self.handle
	local w = hClass.world:find(d.bindW)
	if w and angle then
		d.facing = angle
		if h._c~=nil then
			hApi.ChaSetFacing(h,d.facing)
		end
		--改变坐骑方向
		local oImg = self.chaUI["MOUNT"]
		if oImg~=nil then
			--如果拥有坐骑
			hApi.ObjectSetFacing(oImg.handle,d.facing)
		end
	end
end

--单位转向列表中的下一个路点
_hu.nextway = function(self)
	local w = hClass.world:find(self.data.bindW)
	if w then
		local wp = self.handle.waypoint
		if wp.n<wp.e then
			wp.n = wp.n + 1
			local n = wp[wp.n]
			if n then
				return w:n2grid(n)
			end
		end
	end
end

--设置单位的路点（寻路）
_hu.setwayto = function(self,gridX,gridY,isContiune)
	local w = self:getworld()
	if w then
		return w:findunitwayto(self.handle.waypoint,self,gridX,gridY,isContiune)
	end
	return 0
end

-------------------------------------------
--@CALLBACK:开始移动方法
hClass.unit.__static.start_move = function(oUnit,oWorld,gridX,gridY,oTarget)
	local w = oWorld
	local u = oUnit
	local d = u.data
	if w.data.type=="worldmap" or w.data.type=="town" then
		local wx,wy = hApi.chaGetPos(u.handle)
		local gx,gy = w:xy2grid(wx,wy)
		d.gridX = gx
		d.gridY = gy
		d.worldX = wx
		d.worldY = wy
		--print("当前坐标",gx,gy)
		--print("目的地坐标",gridX,gridY)
		if gx==gridX and gy==gridY then
			if u.handle.UnitInMove~=1 then
				--不在移动状态才会调用开始行走事件
				u.handle.UnitInMove = 1
				oWorld.data.unitcountM = oWorld.data.unitcountM + 1
				hGlobal.event:call("Event_UnitStartMove",oWorld,oUnit,gridX,gridY,oTarget,nOperate)
			end
			--因为没有走程序的流程所以在这里把行走状态置为0，大地图行走回调其实也就干了这一件事
			u.handle.UnitInMove = 0
			oWorld.data.unitcountM = oWorld.data.unitcountM - 1
			return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.NORMAL,oTarget)
		else
			u.handle.UnitInMove = 1
			oWorld.data.unitcountM = oWorld.data.unitcountM + 1
			if hApi.chaGetMovePoint(u.handle)>0 and u:movetoworldG(gridX,gridY,oTarget)==hVar.RESULT_SUCESS then
				hGlobal.event:call("Event_UnitStartMove",oWorld,oUnit,gridX,gridY,oTarget,nOperate)
				u:startmove(oWorld,gridX,gridY,oTarget)		--worldMap上移动全部交给程序接管
				return hVar.RESULT_SUCESS
			else
				u.handle.UnitInMove = 0
				oWorld.data.unitcountM = oWorld.data.unitcountM - 1
				return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.NOT_MOVE,nil)
			end
		end
	elseif w.data.type=="battlefield" then
		u.handle.UnitInMove = 1
		--两方向模型有时候会屁股对着人，特殊调整
		if u.handle.modelmode==0 then
			if u.handle._c~=nil then
				u.handle.__uMoveX,u.handle.__uMmoveY = hApi.chaGetPos(u.handle)
			end
		end
		oWorld.data.unitcountM = oWorld.data.unitcountM + 1
		hGlobal.event:call("Event_UnitStartMove",w,u,gridX,gridY,oTarget,nOperate)
		u:startmove(oWorld,gridX,gridY,oTarget)
		return hClass.unit.__static.arrive_callback(u,w,gridX,gridY,oTarget)
	end
end

-------------------------------------------
--@CALLBACK:移动回调函数
hClass.unit.__static.arrive_callback = function(oUnit,oWorld,gridX,gridY,oTarget,vArriveMode)
	local w = oWorld
	local u = oUnit
	local d = u.data
	if w.data.type=="worldmap" or w.data.type=="town" then
		u.handle.UnitInMove = 0
		oWorld.data.unitcountM = oWorld.data.unitcountM - 1
		d.gridX = gridX
		d.gridY = gridY
		if vArriveMode=="outofmp" then
			--顺便把行动力设置空
			d.movepoint = 0
			hApi.chaSetMovePoint(u.handle,0)
			--和程序约定的，这是行动力用完的回调
			return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.STOP,oTarget)
		else
			d.movepoint = hApi.chaGetMovePoint(oUnit.handle)
			return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.NORMAL,oTarget)
		end
	elseif w.data.type=="battlefield" then
		local lastNode = w:grid2n(d.gridX,d.gridY)
		if not(gridX==d.gridX and gridY==d.gridY) then
			local lastNode = w:grid2n(d.gridX,d.gridY)
			w:leavegridU(u,d.gridX,d.gridY)		--设置地图障碍
			d.gridX = gridX
			d.gridY = gridY
			w:entergridU(u,d.gridX,d.gridY)
		end
		local nGridX,nGridY = u:nextway()
		if nGridX and nGridY then
			if nGridX == d.gridX and nGridY == d.gridY then
				return hClass.unit.__static.arrive_callback(oUnit,oWorld,gridX,gridY,oTarget)
			else
				u.attr.movecount = u.attr.movecount + 1
				local cx,cy = w:grid2xy(d.gridX,d.gridY)
				local tx,ty = w:grid2xy(nGridX,nGridY)
				u:facingto(hApi.angleBetweenPoints(cx,cy,tx,ty))
				--u:facetogrid(nGridX,nGridY)
				local worldX,worldY = oWorld:grid2xy(nGridX,nGridY)
				return u:movetoxy(worldX,worldY,oTarget)
			end
		else
			u.handle.UnitInMove = 0
			oWorld.data.unitcountM = oWorld.data.unitcountM - 1
			d.gridX = gridX
			d.gridY = gridY
			--两方向模型有时候会屁股对着人，特殊调整
			if u.handle.modelmode==0 then
				if u.handle._c and u.handle.__uMoveX and u.handle.__uMmoveY then
					local ox,oy = u.handle.__uMoveX,u.handle.__uMmoveY
					local cx,cy = hApi.chaGetPos(u.handle)
					u:facingto(hApi.angleBetweenPoints(ox,oy,cx,cy))
				end
			end
			return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.NORMAL)
		end
	end
end
-------------------------------------------------
--大地图移动专用!!!!
_hu.movetoworldG = function(self,gridX,gridY,oTarget)
	local d = self.data
	local pTarget
	if oTarget~=nil then
		pTarget = oTarget.handle._c
	end
	--记录一下当前worldX
	if self.handle._c then
		local wx,wy = hApi.chaGetPos(self.handle)
		d.worldX = wx
		d.worldY = wy
	end
	return hApi.chaMoveToGrid(self.handle,gridX,gridY,pTarget)
end
-------------------------------------------------
--移动到单位所在地图的x,y
_hu.movetoxy = function(self,worldX,worldY,oTarget)
	local d = self.data
	local pTarget
	if oTarget~=nil then
		pTarget = oTarget.handle._c
	end
	hApi.chaMoveTo(self.handle,worldX+d.standX,worldY+d.standY,pTarget)
	return hVar.RESULT_SUCESS
end
-------------------------------------------------
--战场内使用
local __ENUM__ImmediateSkill = function(oTarget,oUnit,tGrid,oWorld)
	local nSkillId = tGrid.nSkillId
	local TargetTab = tGrid.Target
	local rMin,rMax = tGrid.area[1],tGrid.area[2]
	if oTarget.data.IsDead~=1 and hApi.IsSafeTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
		if rMax<0 then
			TargetTab[oTarget.ID] = {type="InRange",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
		elseif oUnit==oTarget and rMin<=0 then
			--可以对自己使用
			TargetTab[oTarget.ID] = {type="InRange",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
		else
			local r = oWorld:distanceU(oUnit,oTarget,1)
			if r>=rMin and r<=rMax then
				TargetTab[oTarget.ID] = {type="InRange",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
			else
				TargetTab[oTarget.ID] = {type="OutOfRange",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
			end
		end
	end
end
local __ENUM__GridSkill = function(oTarget,oUnit,tGrid,oWorld)
	local nSkillId = tGrid.nSkillId
	local TargetTab = tGrid.Target
	if oTarget.data.IsDead~=1 and hApi.IsSafeTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
		TargetTab[oTarget.ID] = {type="InRange",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
	end
end
local __ENUM__RangeSkill = function(oTarget,oUnit,tGrid,oWorld)
	local nSkillId = tGrid.nSkillId
	local TargetTab = tGrid.Target
	if oTarget.data.IsDead~=1 and hApi.IsAvailableTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
		TargetTab[oTarget.ID] = {type="Attack",{x=oUnit.data.gridX,y=oUnit.data.gridY}}
	end
end
local __ENUM__MeleeSkill = function(oTarget,oUnit,tGrid,oWorld)
	local nSkillId = tGrid.nSkillId
	local TargetTab = tGrid.Target
	local rMin,rMax = tGrid.area[1],tGrid.area[2]
	if oTarget.data.IsDead~=1 and hApi.IsAvailableTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
		local RangeGrid = {}
		if rMax<0 then
			rMax = 999
		end
		oWorld:gridinunitrange(RangeGrid,oTarget,rMin,rMax)
		local g = oUnit:getcrossgrid(tGrid.MoveGrid,RangeGrid)
		--可以对自己使用的话，并且最小施法距离大于等于1的话，把自己当前站位的格子也加入
		if oUnit==oTarget and rMin>=1 then
			g[#g+1] = {x=oUnit.data.gridX,y=oUnit.data.gridY,move=0}
		end
		if #g>0 then
			g.type = "MoveAndAttack"
			TargetTab[oTarget.ID] = g
		else
			g.type = "Move"
			TargetTab[oTarget.ID] = g
			g.temp = RangeGrid
			tGrid.ReachCount = tGrid.ReachCount + 1
		end
	end
end
--计算单位的移动方格
hApi.CalculateMovePath = function(oUnit,nSkillId,MoveGrid,MoveGridEx,MoveGridU)
	if MoveGrid==nil then
		_,MoveGrid = oUnit:getmovegrid()
	end
	--AvailableGrid = {grid,gridEx,gridI}
	local tGrid = {MoveGrid = MoveGrid.grid,_MoveGrid = MoveGridU or MoveGrid,Target = {},nSkillId = nSkillId,opr = 0}
	if nSkillId==0 or nSkillId==hVar.MOVE_SKILL_ID then
		tGrid.opr = "Move"
		return tGrid
	end
	local TargetTab = tGrid.Target
	local rMin,rMax = hApi.GetSkillRange(nSkillId,oUnit)

	if rMin<0 then
		rMin = 0
	end
	local oWorld = oUnit:getworld()
	if oWorld~=nil then
		local cast = hApi.GetSkillCastType(nSkillId)
		if cast==hVar.CAST_TYPE.IMMEDIATE then
			local rMin,rMax = hApi.GetSkillArea(oUnit,nSkillId)
			tGrid.area = {rMin,rMax}
			tGrid.opr = "Self"
			oWorld:enumunit(__ENUM__ImmediateSkill,oUnit,tGrid)
		elseif cast==hVar.CAST_TYPE.SKILL_TO_GRID then
			local rMin,rMax = hApi.GetSkillArea(oUnit,nSkillId)
			tGrid.area = {rMin,rMax}
			tGrid.opr = "Ground"
			oWorld:enumunit(__ENUM__GridSkill,oUnit,tGrid)
		elseif cast==hVar.CAST_TYPE.SKILL_TO_UNIT then
			tGrid.area = {rMin,rMax}
			tGrid.ReachCount = 0
			if hVar.tab_skill[nSkillId].template=="RangeAttack" then
				tGrid.opr = "Attack"
				--是远程攻击技能，或者是全屏技能
				oWorld:enumunit(__ENUM__RangeSkill,oUnit,tGrid)
			else
				tGrid.opr = "MoveAndAttack"
				--近战攻击类型，动次大次
				oWorld:enumunit(__ENUM__MeleeSkill,oUnit,tGrid)
			end
			if tGrid.ReachCount>=1 then
				if MoveGridEx==nil then
					_,MoveGridEx = oUnit:getmovegrid(999)
				end
				local mGridEx = MoveGridEx.grid
				for k,v in pairs(TargetTab) do
					if v.type=="Move" then
						local g = oUnit:getcrossgrid(mGridEx,v.temp)
						if #g>0 then
							for i = 1,#g do
								v[#v+1] = g[i]
							end
						else
							v.type = "OutOfRange"
						end
					end
				end
			end
		end
	end
	return tGrid
end
------------------------------------------------
--多格单位的位置偏移量获取，目前只有战场里面在用
--用于处理多格单位的移动
_hu.getstandXY = function(self)
	local w = self:getworld()
	local x,y = 0,0
	if w~=nil then
		local bMode = self.attr.block
		if bMode==hVar.UNIT_BLOCK_MODE.RIDER then
			--两格单位
			x = hApi.getint(w.data.gridW/2)
		elseif bMode==hVar.UNIT_BLOCK_MODE.GATE then
			x = hApi.getint(w.data.gridW/2)
			y = 1
		elseif bMode==hVar.UNIT_BLOCK_MODE.WALL_UP then
			x = hApi.getint(w.data.gridW/2)
			y = 1
		elseif bMode==hVar.UNIT_BLOCK_MODE.WALL_DOWN then
			x = hApi.getint(w.data.gridW/2)
			y = -1
		end
	end
	return x,y
end

_hu.setgrid = function(self,gridX,gridY,nOperate)
	local d = self.data
	local w = self:getworld()
	local u = self
	if w and gridX and gridY then
		gridX,gridY = w:safeGrid(gridX,gridY)
		if gridX==d.gridX and gridY==d.gridY then
			hGlobal.event:call("Event_UnitNotMove",w,u,gridX,gridY)
			return hVar.RESULT_SUCESS
		else
			local oGridX,oGridY = d.gridX,d.gridY
			w:leavegridU(self,d.gridX,d.gridY)
			d.gridX = gridX
			d.gridY = gridY
			w:entergridU(self,d.gridX,d.gridY)
			local worldX,worldY = w:grid2xy(gridX,gridY)
			if self.handle._c then
				hApi.chaSetPos(self.handle,worldX+d.standX,worldY+d.standY)
			end
			nOperate = nOperate or hVar.OPERATE_TYPE.SKILL_TO_GRID
			hGlobal.event:call("Event_UnitArrive",w,u,gridX,gridY,nil,nOperate,hVar.ZERO,oGridX,oGridY)
			hGlobal.event:event("Event_AfterUnitArrive",w,u,gridX,gridY,nil,nOperate,hVar.ZERO,oGridX,oGridY)
			--战场内传送时，触发刷新光环效果
			if nOperate==hVar.OPERATE_TYPE.UNIT_TELEPORT and w.data.type=="battlefield" then
				w:unitarrive(self,d.gridX,d.gridY,nil,hVar.OPERATE_TYPE.UNIT_TELEPORT,0)
			end
			return hVar.RESULT_SUCESS
		end
	end
	return hVar.RESULT_FAIL
end


_hu.getstopXY = function(self)
	return hApi.chaGetStopPoint(self.handle)
end

_hu.movetogrid = function(self,gridX,gridY,oTarget,nOperate,nOperateId)
	local d = self.data
	local w = self:getworld()
	local u = self
	if w and gridX and gridY then
		d.nOperate = nOperate or hVar.OPERATE_TYPE.NONE
		if nOperateId~=nil and nOperateId~=0 and type(nOperateId)=="number" then
			d.nOperateId = nOperateId
		else
			d.nOperateId = 0
		end
		if w.data.type=="worldmap" or w.data.type=="town" then
			--在世界地图上移动就全部交给程序好了,咱们计算不寻路
			return hClass.unit.__static.start_move(u,w,gridX,gridY,oTarget)			--移动开始
		else
			if self:setwayto(gridX,gridY)>0 then
				if self.handle._c~=nil then
					return hClass.unit.__static.start_move(u,w,d.gridX,d.gridY,oTarget)			--移动开始
				else
					--如果没有handle._c，直接走到
					u.handle.UnitInMove = 1
					w.data.unitcountM = w.data.unitcountM + 1
					hGlobal.event:call("Event_UnitStartMove",w,u,gridX,gridY,oTarget,nOperate)
					if not(gridX==d.gridX and gridY==d.gridY) then
						w:leavegridU(u,d.gridX,d.gridY)
						d.gridX = gridX
						d.gridY = gridY
						w:entergridU(u,d.gridX,d.gridY)
					end
					u.handle.UnitInMove = 0
					w.data.unitcountM = w.data.unitcountM - 1
					return u:arrive(w,gridX,gridY,__UNIT_ARRIVE_MODE.NORMAL)
				end
			else
				return self:arrive(w,d.gridX,d.gridY,__UNIT_ARRIVE_MODE.NOT_MOVE)			--寻路失败，直接转到移动到达事件
			end
		end
	end
	return hVar.RESULT_FAIL
end

_hu.startmove = function(self,oWorld,gridX,gridY,oTarget)
	self.data.IsMoving = 1
	local oImg = self.chaUI["MOUNT"]
	if oImg then
		--如果拥有坐骑
		oImg:setmodel(oImg.data.model,"walk",self.data.facing,-1,-1,nil,1)
		local tabU = hVar.tab_unit[oImg.data.id]
		if type(tabU.movesound)=="table" and self:getowner()==hGlobal.LocalPlayer then
			local oImg__ID = oImg.__ID
			local sSoundName,nSoundDur = tabU.movesound[1],tabU.movesound[2]
			hApi.PlaySound(sSoundName)
			hApi.addTimer("__WM__ChaMoveSound",1,0,nSoundDur,function()
				if oImg__ID==oImg.__ID and oImg.data.animation=="walk" then
					hApi.PlaySound(sSoundName)
				else
					hApi.clearTimer("__WM__ChaMoveSound")
				end
			end)
		end
		
	else
		--一般
		self:setanimation("walk")	--startmove,walk
	end
end

_hu.endmove = function(self)
	self.data.IsMoving = 0
	local oImg = self.chaUI["MOUNT"]
	if oImg then
		--如果拥有坐骑
		oImg:setmodel(oImg.data.model,"stand",self.data.facing,-1,-1,nil,1)
	else
		self:setanimation("arrive")	--arrive,move --geyachao
	end
end

_hu.setscale = function(self,scale)
	local d = self.data
	if self.handle._c~=nil then
		local tabU = self:gettab()
		local scaleBase = d.scale
		local scaleCha = math.max(10,hApi.getint(scaleBase*scale))
		if self.handle.scale~=scaleCha then
			self.handle.scale = scaleCha
			--print("hApi.SpriteLoadBoundingBox 1")
			hApi.SpriteLoadBoundingBox(self.handle,tabU.box,"UNIT",scale*100)
			hApi.SpriteLoadFacing(self.handle)
		end
	end
end

_hu.arrive = function(self,oWorld,gridX,gridY,arriveMode,oTarget)
	local d = self.data
	local w = oWorld
	if w==nil then
		return
	end
	arriveMode = arriveMode or __UNIT_ARRIVE_MODE.NOT_MOVE
	if not(gridX~=nil and gridY~=nil) then
		--移动到未知的地点？
		gridX = d.gridX
		gridY = d.gridY
	end
	local u = self
	local nOperate = d.nOperate
	local nOperateId = d.nOperateId
	d.nOperate = hVar.OPERATE_TYPE.NONE	--保存的命令
	if oWorld.data.type=="worldmap" or oWorld.data.type=="town" then
		--设置为没有移动
		self.handle.UnitInMove = 0
		--_DEBUG_MSG("世界地图回调:到达"..arriveMode,gridX,gridY)
		--世界地图的到达回调
		if arriveMode==__UNIT_ARRIVE_MODE.BIRTH then
			--角色在大地图上出生（英雄登场!）
			d.gridX = gridX
			d.gridY = gridY
			if d.type==hVar.UNIT_TYPE.UNIT or d.type==hVar.UNIT_TYPE.HERO then
				self:facingto(d.facing)
			end
		elseif arriveMode==__UNIT_ARRIVE_MODE.DEAD then
			--角色在大地图上死亡（这不科学）
		else
			--_DEBUG_MSG("[LUA]到达目标地点",gridX,gridY)
			if arriveMode==__UNIT_ARRIVE_MODE.STOP then
				oTarget = nil
				nOperate = hVar.OPERATE_TYPE.NONE
				nOperateId = hVar.ZERO
			end
			if arriveMode==__UNIT_ARRIVE_MODE.NOT_MOVE then
				--没有移动
				hGlobal.event:call("Event_UnitNotMove",oWorld,self,gridX,gridY,false)
				return hVar.RESULT_FAIL
			else--if arriveMode==__UNIT_ARRIVE_MODE.NORMAL or arriveMode==__UNIT_ARRIVE_MODE.STOP then
				self:endmove()	--arrive,move,wm
				--正常到达
				d.gridX = gridX
				d.gridY = gridY
				hGlobal.event:call("Event_UnitArrive",oWorld,self,gridX,gridY,oTarget,nOperate,nOperateId,0,0)
				--oWorld:unitarrive(self,gridX,gridY,oTarget,nOperate,nOperateId)
				hGlobal.event:event("Event_AfterUnitArrive",oWorld,self,gridX,gridY,oTarget,nOperate,nOperateId)
				return hVar.RESULT_SUCESS
			end
		end
	elseif oWorld.data.type=="battlefield" then
		--设置为没有移动
		self.handle.UnitInMove = 0
		--战场地图的到达回调()
		if arriveMode==__UNIT_ARRIVE_MODE.BIRTH then
			--单位在战场上出生
			d.gridX = gridX
			d.gridY = gridY
			self:facingto(d.facing)
			oWorld:entergridU(self,gridX,gridY)
		elseif arriveMode==__UNIT_ARRIVE_MODE.DEAD then
			--单位死亡
			--oWorld:leavegridU(self)已知错误，该流程在unit:dead()中处理，会导致移除两次block
		else
			if arriveMode==__UNIT_ARRIVE_MODE.NOT_MOVE then
				--没有移动
				return hVar.RESULT_FAIL
			else--if arriveMode==__UNIT_ARRIVE_MODE.NORMAL or arriveMode==__UNIT_ARRIVE_MODE.STOP then
				--正常到达
				d.gridX = gridX
				d.gridY = gridY
				--冲锋技能(屎一样的机制)
				if d.chargeID~=0 then
					--冲锋结束后，恢复移动速度
					local tabU = hVar.tab_unit[d.id]
					if tabU and self.handle._c then
						local movespeed = hApi.getint(tabU.movespeed or hVar.UNIT_DEFAULT_SPEED*(oWorld.data.movespeed or 100)/100)
						hApi.chaSetMoveSpeed(u.handle,movespeed)
					end
					local oAction = hClass.action:find(d.chargeID)
					d.chargeID = 0
					if oWorld.data.IsQuickBattlefield~=1 then
						if oAction and oAction.data.unit==self and type(oAction.data.group)=="table" then
							if oAction.data.tick==0 or oAction.data.group.arrive==0 then
								oAction:go("continue",1)
							else
								oAction.data.group.arrive = 1
							end
						end
					end
				else
					self:endmove()	--arrive,move,bf
				end
				hGlobal.event:call("Event_UnitArrive",oWorld,self,gridX,gridY,oTarget,nOperate,nOperateId,0,0)
				oWorld:unitarrive(self,gridX,gridY,oTarget,nOperate,nOperateId)
				hGlobal.event:event("Event_AfterUnitArrive",oWorld,self,gridX,gridY,oTarget,nOperate,nOperateId)
				return hVar.RESULT_SUCESS
			end
		end
	end
end

-------------------------------------------------
-- 单位扩展函数:calculate
-- 计算单位的各种数值
-- 此函数在ai_calculate.lua中被重载了
_hu.calculate = function(self,mode,...)
	return 0
	--local d = self.data
	--if mode=="CombatScore" then
		--heroGameAI.CalculateSystem.Calculate(self,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
	--elseif mode=="CaptureUnit" then
		--heroGameAI.CalculateSystem.Calculate(self,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.CAPTUREUNIT)
	--end
end

--省内存优化(EFF)
--现在世界地图上的英雄刚出来的时候都不加载模型
local __CODE__InitHeroModelWM = function(oUnit)
	if oUnit.data.type==hVar.UNIT_TYPE.HERO and oUnit.data.IsHide~=1 then
		oUnit:initmodel()
		--编辑器模式。。。尝试显示船体
		if g_editor==1 then
			local oHero = oUnit:gethero()
			if oHero then
				local nMount = oHero:getGameVar("_MOUNT")
				if nMount>0 then
					oUnit:loadmount(nMount)
				end
			end
		end
	end
end
hApi.InitModelForHeroOnMap = function(oWorld)
	oWorld:enumunit(__CODE__InitHeroModelWM)
end

local __CODE__ReadPlistModelWM = function(oUnit,tPlistName)
	local mode,image,plist = hApi.getObjectModelPath(oUnit.handle)
	if mode=="plist" then
		tPlistName[plist] = 1
	end
end
hApi.ReleaseUnusedUnitPlist = function(oWorld)
	local tPlistName = {}
	oWorld:enumunit(__CODE__ReadPlistModelWM,tPlistName)
	hResource.model:releasePlist(hVar.TEMP_HANDLE_TYPE.UNIT_WM,tPlistName)
	if xlRemoveUnusedTextures then
		xlRemoveUnusedTextures()
	end
end

_hu.initmodel = function(self)
	if self.handle.__UnitModelName~=nil then
		local d = self.data
		local h = self.handle
		local modelName = h.__UnitModelName
		h.__UnitModelName = nil
		--print("-----初始化模型"..d.id.."----------")
		local nFacing = d.facing
		hApi.SpriteLoadFacingDefault(h,nil,"reset_clear")
		hApi.InitModelForUnit(h,modelName,d.scale/100,"stand",nFacing)
		hApi.ChaSetFacing(h,nFacing,1)
		if self.data.heroID~=0 then
			--坐骑（读取）
			local oHero = self:gethero()
			if oHero and oHero:getunit("world")==self then
				local nMount = oHero:getGameVar("_MOUNT")
				if nMount>0 then
					self:loadmount(nMount)
				end
			end
		end
	end
end

_hu.sethide = function(self,hide)
	if hide == 0 then
		if self.data.IsHide~=0 then
			self.data.IsHide = 0
			if self.handle._c~=nil then
				self:initmodel()
				xlCha_Hide(self.handle._c,0)
				self.handle._n:setVisible(true)
				if self.handle._tn then
					self.handle._tn:setVisible(true)
				end
			end
		end
	else
		if self.data.IsHide~=1 or hide==2 then
			self.data.IsHide = 1
			if self.handle._c~=nil then
				xlCha_Hide(self.handle._c,1)
				self.handle._n:setVisible(false)
				if self.handle._tn then
					self.handle._tn:setVisible(false)
				end
			end
		end
	end
end

_hu.loadmount = function(self,id)
	if self.handle._n==nil or self.handle._c==nil then
		return
	end
	if (id or 0)<=0 then
		--移除坐骑
		if self.chaUI["MOUNT"]~=nil then
			hApi.safeRemoveT(self.chaUI,"MOUNT")
			hApi.chaSetMoveSound(self.handle,1)
			local movespeed = hVar.UNIT_DEFAULT_SPEED	--by zhenkira:移动速度程序控制
			hApi.chaSetMoveSpeed(self.handle,movespeed)
			self:setmovepoint("unmount")
		end
	else
		--设置坐骑
		local tabU = hVar.tab_unit[id]
		if tabU then
			hApi.safeRemoveT(self.chaUI,"MOUNT")
			if tabU.movespeed then
				local movespeed = tabU.movespeed
				hApi.chaSetMoveSpeed(self.handle,movespeed)
			end
			if type(tabU.movesound)=="string" then
				hApi.chaSetMoveSound(self.handle,tabU.movesound)
			else
				hApi.chaSetMoveSound(self.handle,0)
			end
			local fScale = tabU.scale
			self.chaUI["MOUNT"] = hUI.thumbImage:new({
				parent = self.handle._n,
				id = id,
				x = tabU.standX,
				y = tabU.standY,
				z = -1,
				facing = self.data.facing,
				scale = fScale,
			})
			if fScale then
				self.chaUI["MOUNT"].handle.scale = math.floor(fScale*100)
			end
			hApi.ObjectSetFacing(self.chaUI["MOUNT"].handle,self.data.facing)
			self:setmovepoint("mount")
		end
	end
end

_hu.isTownGuard = function(self)
	local curtown = self.data.curTown
	if curtown ~= 0 then
		local oTown = hClass.town:find(curtown)
		if oTown then
			if oTown:getunit("guard")== self then
				return 1
			end
		end
	end
	return 0
end

_hu.isInScreen = function(self,nEdgeW,nEdgeH)
	local h = self.handle
	if h._c~=nil then
		local x,y = self:getXY()
		local sX,sY = hApi.world2view(x,y)
		nEdgeW = nEdgeW or 0
		nEdgeH = nEdgeH or 0
		if sX and sY and sX>=nEdgeW and sY>=nEdgeH and sX<=hVar.SCREEN.w-nEdgeW and sY<=hVar.SCREEN.h-nEdgeH then
			return hVar.RESULT_SUCESS
		end
	end
	return hVar.RESULT_FALSE
end

_hu.beforedead = function(self,oKillerUnit)
	local w = self:getworld()
	local oUnit = self
	if w.data.type=="worldmap" then
		local tData = oUnit:gettriggerdata()
		if tData and tData.quest then
			local num = tData.quest[3] or 1
			local id = tData.quest[4]
			if id==nil or id==0 then
				id = oUnit.data.id
			end
			--击杀指定怪物的任务
			--{nState,nMin,nMax,uUnique,text,reward}
			if num==1 and id==oUnit.data.id then
				local qList = w.data.QuestList
				if type(qList)=="table" then
					local IsQuestFail = 1
					if oKillerUnit then
						local oPlayerK = oKillerUnit:getowner()
						local oHeroK = oKillerUnit:gethero()
						--本地玩家才能完成任务,其他玩家击杀视为任务失败
						if oPlayerK==hGlobal.LocalPlayer then
							IsQuestFail = 0
						elseif oHeroK and hGlobal.LocalPlayer:allience(oPlayerK)==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
							--如果是友方英雄击杀,或队伍中有友军英雄
							if oHeroK:getGameVar("_ALLY")>0 then
								IsQuestFail = 0
							else
								oHeroK:enumteam(function(oHeroC)
									if oHeroC:getGameVar("_ALLY")>0 then
										IsQuestFail = 0
									end
								end)
							end
						end
					end
					local NeedUpdateQuest = 0
					for i = 1,#qList do
						local tQuest = qList[i]
						if type(tQuest)=="table" and tQuest[1]==1 and type(tQuest[4])=="table" then
							--兼容旧存档，待修改
							local u
							local tgrID = tQuest[4][4]
							local UniqueQuestID = tQuest[4][5]
							if tgrID~=nil then
								u = w:tgrid2unit(tgrID)
							else
								u = hClass.unit:find(tQuest[4][1])
								if u and u.__ID~=tQuest[4][2] then
									u = nil
								end
							end
							if u~=nil and u==self then
								NeedUpdateQuest = 1
								if IsQuestFail==1 then
									tQuest[1] = 0
								else
									tQuest[2] = tQuest[2] + 1
									if tQuest[2]>=tQuest[3] then
										tQuest[1] = 2
									end
								end
							end
						end
					end
					if NeedUpdateQuest==1 then
						hGlobal.event:event("LocalEvent_UpdateMapQuest",w,oUnit)
					end
				end
			end
		end
	end
end

_hu.setpowerex = function(self,mode,tType,nPower,nDur)
	local d = self.data
	if not(type(tType)=="table" and type(nPower)=="number" and nPower~=0) then
		return
	end
	nDur = nDur or 0
	if mode=="from" then
		if type(d.powerFrom)~="table" then
			d.powerFrom = {}
		end
		d.powerFrom[#d.powerFrom+1] = {tType,nPower,nDur}
	elseif mode=="to" then
		if type(d.powerTo)~="table" then
			d.powerTo = {}
		end
		d.powerTo[#d.powerTo+1] = {tType,nPower,nDur}
	end
end

local __TempX = {}
local __TempT
local __TempCount = 0
local __ENUM__CountBuff = function(oAction)
	for i = 1,#__TempT do
		local k = __TempT[i]
		if oAction.data.IsBuff==k then
			__TempCount = __TempCount + 1
			return
		else
			local a = oAction.data.action
			if type(a)=="table" then
				for n = 1,#a do
					if k==a[n][1] then
						__TempCount = __TempCount + 1
						return
					end
				end
			end
		end
	end
end

_hu.countbuff = function(self,buffName)
	if type(buffName)=="table" then
		__TempT = buffName
	else
		__TempX[1] = buffName
		__TempT = __TempX
	end
	__TempCount = 0
	self:enumbuff(__ENUM__CountBuff)
	return __TempCount
end

local __dur,__param
local __SetDurAndParam = function(t)
	t[3] = __dur
	t[4] = __param
end
_hu.setbuffhint = function(self,id,lv,dur,param)
	local tBuffHint = self.attr.BuffHint
	if tBuffHint~=0 then
		lv = lv or 0
		__dur = dur or 0
		__param = param
		hApi.insertIntoIndexTab(tBuffHint,id,lv,__SetDurAndParam)
	end
end

_hu.onRoundStart = function(self,nRound)
	local d = self.data
	local a = self.attr
	a.counter = a.__counter				--重置反击次数
	a.activecount = 0				--重置激活次数
	--首回合以外做的事情
	if nRound>1 then
		--减少眩晕免疫时间
		if a.stunimmunity>0 and a.stun<=0 then
			a.stunimmunity = a.stunimmunity - 1
		end
		--召唤生物持续时间
		if a.duration>0 then
			a.duration = a.duration - 1
			if a.duration==0 then
				a.duration = -1
			end
		end
		if d.type==hVar.UNIT_TYPE.UNIT or d.type==hVar.UNIT_TYPE.HERO then
			--技能冷却-1
			local s = a.skill
			if s.num>0 then
				for i = 1,s.i do
					if type(s[i])=="table" and s[i][3]>0 then
						s[i][3] = s[i][3] - 1
					end
				end
			end
			--重新计算额外伤害持续时间
			if type(d.powerTo)=="table" then
				for i = 1,#d.powerTo do
					local v = d.powerTo[i]
					if v[3]>0 and v[3]<nRound then
						v[3] = -1
					end
				end
			end
			if type(d.powerFrom)=="table" then
				for i = 1,#d.powerFrom do
					local v = d.powerFrom[i]
					if v[3]>0 and v[3]<nRound then
						v[3] = -1
					end
				end
			end
			
			--buff回合显示
			for i = 1,#a.BuffHint do
				local v = a.BuffHint[i]
				if v~=0 then
					if v[3]>0 then
						v[3] = v[3] - 1
						if v[3]<=0 then
							a.BuffHint.index[a.BuffHint[i][1]] = 0
							a.BuffHint[i] = 0
						end
					end
				end
			end
		end
	end
end

local __ENUM__RemoveFleeEffect = function(oAction)
	local tState = oAction.data.BuffState
	if type(tState)=="table" then
		for i = 1,#tState do
			if tState[i]~=0 and tState[i][2]=="flee" and type(oAction.data.tempValue)=="table" and oAction.data.tempValue["@flee"]==0 then
				oAction:removeAllControlEffect()
			end
		end
	end
end

_hu.onAnyUnitActive = function(self,oUnitCur)
	local a = self.attr
	local h = self.handle
	--重置当前行动阶段反击次数
	a.countercount = 0
	--重置单位移动计数
	a.movecount = 0
	--重置闪避计数
	if a.fleecount~=0 then
		a.fleecount = 0
		self:enumbuff(__ENUM__RemoveFleeEffect)		--成功闪避后，尝试移除闪避技能的特效
	end
end

--geyachao:新加
--设置角色的路点(参数: 路线,阵型,阵型位置(1~3),当前路点索引(可选))
_hu.setRoadPoint = function(self, pathInfo, formation, formationPos, rpIdx)
	
	if self.data.roadPoint == 0 then
		self.data.roadPoint = {}
	end
	
	local pathId = 0
	local pathEvent = false
	if type(pathInfo) == "number" then
		pathId = pathInfo
	else
		if pathInfo then
			local tPathInfo = hApi.String2Type(pathInfo, ":") or {}
			if tPathInfo[1] == "e" or tPathInfo[1] == "event" then
				pathId = tonumber(tPathInfo[2]) or 0
				if pathId > 0 then
					pathEvent = true
				end
			else
				pathId = tonumber(tPathInfo[1]) or 0
			end
		end
	end

	--路线索引
	self.data.roadPoint[1] = math.abs(pathId)
	--阵型
	self.data.roadPoint[2] = formation
	--阵型中所处位置
	self.data.roadPoint[3] = formationPos or 1
	
	--移动类型(到达后移除,站定不动,按路点循环)
	if pathId > 0 then
		if pathEvent then
			self.data.roadPoint[4] = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE_EVENT
		else
			self.data.roadPoint[4] = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE
		end
	elseif pathId == 0 then
		self.data.roadPoint[4] = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE
	else
		self.data.roadPoint[4] = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_CIRCLE
	end
	--当前路点索引
	self.data.roadPoint[5] = rpIdx or 1
end

--通过表直接设置角色的路点
_hu.setRoadPointByT = function(self, t)
	
	if self.data.roadPoint == 0 then
		self.data.roadPoint = {}
	end

	if type(t) == "table" then
		self.data.roadPoint = {}
		self.data.roadPoint[1] = t[1]	--路线索引
		self.data.roadPoint[2] = t[2]	--阵型
		self.data.roadPoint[3] = t[3]	--阵型中所处位置
		self.data.roadPoint[4] = t[4]	--移动类型(到达后移除,站定不动,按路点循环)
		self.data.roadPoint[5] = t[5]	--当前路点索引
	else
		self.data.roadPoint = 0
	end
end

--geyachao:新加
--获得角色的当前路点 0原地不动 -1到达路点删除 tab下一个路点
_hu.getRoadPoint = function(self)
	
	local ret = 0
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			if type(self.data.roadPoint) == "table" then
				local pathId = self.data.roadPoint[1]
				local formation = self.data.roadPoint[2]
				local formationPos = self.data.roadPoint[3]
				local rpType = self.data.roadPoint[4]
				local rpIdx = self.data.roadPoint[5]
				local dType = hVar.TD_DEPLOY_TYPE
				
				if formation == dType.THREE_RANDOM_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then
					formationPos = 1
				end
				
				--如果是原地型,不处理
				if rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE then
				else
					--直线型\环型
					local path = mapInfo.pathList[pathId]
					--如果存在路线,路线中有对应阵型,路线对应阵型中有对应位置
					if path and path[formation] and path[formation][formationPos] then
						local roadPointList = path[formation][formationPos]
						--如果是直线型
						if rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE or rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE_EVENT then
							local roadPoint = roadPointList[rpIdx]
							if roadPoint then
								--当前路点指向下一个
								--self.data.roadPoint[5] = self.data.roadPoint[5] + 1

								if formation == dType.THREE_RANDOM_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then
									local distancePer = (w:random(1, 100) / 100)
									local tmp = w:random(0, 1)
									if tmp == 1 then
										distancePer = -1 * distancePer
									end
									if self.data.roadPoint[3] == 1 then
										ret = hApi.ReturnPointByDistancePer(roadPoint, distancePer)
										ret.isHide = roadPoint.isHide
									elseif self.data.roadPoint[3] == 2 then
										ret = roadPoint
									elseif self.data.roadPoint[3] == 3 then
										ret = hApi.ReturnPointByDistancePer(roadPoint, -distancePer)
										ret.isHide = roadPoint.isHide
									end
								else
									ret = roadPoint
								end
							else
								ret = -1
							end
						
						--elseif rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE then
						
						--如果是环型
						elseif rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_CIRCLE then
							local roadPoint = roadPointList[rpIdx]
							if roadPoint then
								ret = roadPoint
								--当前路点指向下一个
								if rpIdx >= #roadPointList then
									--self.data.roadPoint[5] = 1
								else
									--self.data.roadPoint[5] = self.data.roadPoint[5] + 1
								end
							end
						end
					end
				end
			end
		end
	end

	return ret --0原地不动 -1到达路点删除 tab下一个路点
end

--将路点设置到下一个
_hu.setRoadPointNext = function(self)
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			if type(self.data.roadPoint) == "table" then
				local pathId = self.data.roadPoint[1]
				local formation = self.data.roadPoint[2]
				local formationPos = self.data.roadPoint[3]
				local rpType = self.data.roadPoint[4]
				local rpIdx = self.data.roadPoint[5]
				
				--如果是原地型,不处理
				if rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE then
				else
					local path = mapInfo.pathList[pathId]
					--如果存在路线,路线中有对应阵型,路线对应阵型中有对应位置
					if path and path[formation] and path[formation][formationPos] then
						local roadPointList = path[formation][formationPos]
						--如果是直线型
						if rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE or rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE_EVENT then
							--当前路点指向下一个
							self.data.roadPoint[5] = self.data.roadPoint[5] + 1
						
						--elseif rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE then
						
						--如果是环型
						elseif rpType == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_CIRCLE then
							--当前路点指向下一个
							if rpIdx >= #roadPointList then
								self.data.roadPoint[5] = 1
							else
								self.data.roadPoint[5] = self.data.roadPoint[5] + 1
							end
						end
					end
				end
			end
		end
	end
end

--设置生存时间（单位: 毫秒）
_hu.setLiveTime = function(self, livetime)
	if (livetime) and (livetime > 0) then
		local world = self:getworld()
		local currenttime = world:gametime()
		
		self.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
		self.data.livetime = livetime --新加数据 生存时间（毫秒）
		self.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
	else
		self.data.livetimeBegin = -1 --geyachao: 新加数据 生存时间开始值（毫秒）
		self.data.livetime = -1 --新加数据 生存时间（毫秒）
		self.data.livetimeMax = -1 --geyachao: 新加数据 生存时间最大值（毫秒）
	end
end

--拷贝原角色路线配置到新角色
_hu.copyRoadPoint = function(self, oUnit)
	if type(oUnit.data.roadPoint) == "table" then
		self.data.roadPoint = {}
		self.data.roadPoint[1] = oUnit.data.roadPoint[1]	--路线索引
		self.data.roadPoint[2] = oUnit.data.roadPoint[2]	--阵型
		self.data.roadPoint[3] = oUnit.data.roadPoint[3]	--阵型中所处位置
		self.data.roadPoint[4] = oUnit.data.roadPoint[4]	--移动类型(到达后移除,站定不动,按路点循环)
		self.data.roadPoint[5] = oUnit.data.roadPoint[5]	--当前路点索引
	else
		self.data.roadPoint = oUnit.data.roadPoint
	end
end

--拷贝一份角色路线配置并返回
_hu.copyRoadPointInfo = function(self)
	if type(self.data.roadPoint) == "table" then
		local ret = {}
		ret[1] = self.data.roadPoint[1]	--路线索引
		ret[2] = self.data.roadPoint[2]	--阵型
		ret[3] = self.data.roadPoint[3]	--阵型中所处位置
		ret[4] = self.data.roadPoint[4]	--移动类型(到达后移除,站定不动,按路点循环)
		ret[5] = self.data.roadPoint[5]	--当前路点索引
		return ret
	else
		return self.data.roadPoint
	end
end

--获取路点模式类型
_hu.getRoadPointType = function(self)
	local ret = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE
	if type(self.data.roadPoint) == "table" then
		ret = self.data.roadPoint[4]
	end
	return ret
end

--geyachao:新加
--设置角色的AI状态
_hu.setAIState = function(self, aiState)
	--[[
	local szAIState = "" --字符串
	if (aiState == hVar.UNIT_AI_STATE.IDLE) then --空闲状态
		szAIState = "IDLE"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE) then --移动状态
		szAIState = "MOVE"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --移动到坦克附近状态
		szAIState = "MOVE_TANK_NEARBY"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TANK) then --移动到坦克状态
		szAIState = "MOVE_TANK"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --移动调整状态
		szAIState = "MOVE_ADJUST"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --移动混乱状态（单位无目的乱走）
		szAIState = "MOVE_CHAOS"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --人质移动跟随坦克状态
		szAIState = "MOVE_HOSTAGE_TANK"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --人质移动混乱状态（单位无目的乱走）
		szAIState = "MOVE_HOSTAGE_ChAOS"
	elseif (aiState == hVar.UNIT_AI_STATE.ATTACK) then --攻击状态
		szAIState = "ATTACK"
	elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW) then --跟随单位状态
		szAIState = "FOLLOW"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --移动到达目标点后释放战术技能
		szAIState = "MOVE_TO_POINT"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --移动到达目标点后继续释放技能
		szAIState = "MOVE_TO_POINT_CASTSKILL"
	elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --移动到达目标后释放战术技能
		szAIState = "FOLLOW_TO_TARGET"
	elseif (aiState == hVar.UNIT_AI_STATE.SEARCH) then --搜敌状态
		szAIState = "SEARCH"
	elseif (aiState == hVar.UNIT_AI_STATE.CAST) then --施法状态
		szAIState = "CAST"
	elseif (aiState == hVar.UNIT_AI_STATE.CAST_STATIC) then --施法后僵直状态
		szAIState = "STATIC"
	elseif (aiState == hVar.UNIT_AI_STATE.STUN) then --眩晕状态
		szAIState = "STUN"
	elseif (aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --滑行状态
		szAIState = "MOVE_BY_TRACK"
	elseif (aiState == hVar.UNIT_AI_STATE.SLEEP) then --沉睡状态
		szAIState = "SLEEP"
	elseif (aiState == hVar.UNIT_AI_STATE.REACHED) then --到达终点
		szAIState = "REACHED"
	end
	print(self.data.name .. "_" ..  self.__ID, szAIState)
	]]
	if (aiState ~= self.data.aiState) then
		self.data.aiState = aiState
		
		--标记上次进入空闲状态的时间
		if (aiState == hVar.UNIT_AI_STATE.IDLE) then --空闲状态
			self.data.lastIdleTime = self:getworld():gametime()
		end
	end
	
	--调试
	--if (self.data.id == 16002) and (aiState == hVar.UNIT_AI_STATE.IDLE) then
	--	print(self.data.name .. "_" ..  self.__ID, szAIState, debug.traceback())
	--end
end

--geyachao:新加
--获得角色的AI状态
_hu.getAIState = function(self)
	return self.data.aiState
end

--zhenkira:新加
--获得角色AI类型
_hu.getAIType = function(self)
	return self.data.aiType
end

_hu.onAnimationChange = function(self)
	local h = self.handle
	--如果做出了动画位移，那么需要归位
	if h._c and h.s then
		local tick = h.__IsSpriteMoved or 0
		if tick~=0 and tick>hApi.gametime() then
			h.__IsSpriteMoved = 0
			h.s:setPosition(0,0)
		end
	end
end

_hu.setmovepoint = function(self,movepoint)
	local d = self.data
	local h = self.handle
	if h._c==nil then
		return
	end
	local nCurV = hApi.chaGetMovePoint(h)
	local nMaxV = hApi.chaGetMaxMovePoint(h)
	local nMyPoint = 0			--我的最大行动力
	if type(movepoint)=="number" then
		--直接指定行动力
		nMyPoint = movepoint
	else
		--特殊标识
		local key = movepoint
		local oHero = self:gethero()
		if oHero then
			--nMyPoint = math.max(0,oHero.attr.movepoint) --geyachao:注释
			nMyPoint = hVar.UNIT_DEFAULT_MOVEPOINT
		else
			nMyPoint = hVar.UNIT_DEFAULT_MOVEPOINT
		end
		if key=="newday" then
			--新的一天，恢复所有行动力
			nCurV = nMyPoint
			nMaxV = nMyPoint
		elseif key=="born" then
			--英雄出生
		elseif key=="mount" then
			--上船
		elseif key=="unmount" then
			--下船
		end
	end
	if self.chaUI["MOUNT"]~=nil then
		--水上行动力
		local nWaterMovePec = 100
		local oWorld = self:getworld()
		if oWorld then
			local tgrDataP = oWorld:getmapdata(self.data.owner)
			if tgrDataP and type(tgrDataP.WaterMovePec)=="number" then
				nWaterMovePec = math.max(1,tgrDataP.WaterMovePec)
			end
		end
		nMyPoint = math.floor((nMyPoint*nWaterMovePec*hVar.UNIT_DEFAULT_MOVEPOINT_W)/(100*hVar.UNIT_DEFAULT_MOVEPOINT))
	else
		--陆地行动力
		nMyPoint = nMyPoint
	end
	--设置角色行动力
	local nCurP = math.floor(nMyPoint*math.max(0,nCurV)/math.max(10,nMaxV))
	local nMaxP = math.max(10,nMyPoint)
	d.movepoint = nCurP
	hApi.chaSetMaxMovePoint(h,nMaxP)
	hApi.chaSetMovePoint(h,nCurP)
	--if d.type==hVar.UNIT_TYPE.HERO and d.id==5000 then
		--print("~~~~~~~~~~~~~~~~~~~",movepoint,self.ID,self.data.id,nCurP.."/"..nMaxP)
	--end
end

local _TEMP_FindEffect = nil
local _ENUM_FindEffectU = function(oEffect,nEffectId)
	if oEffect.data.id==nEffectId then
		_TEMP_FindEffect = oEffect
	end
end
--返回单位身上的指定特效id的特效
_hu.findeffect = function(self,nEffectId)
	local d = self.data
	_TEMP_FindEffect = nil
	hApi.enumByClass(self,hClass.effect,d.effectU,_ENUM_FindEffectU,nEffectId)
	local r =_TEMP_FindEffect
	_TEMP_FindEffect = nil
	return r
end

--geyachao: 回血timer
--地图上的所有角色回血
function TD_Unit_Hp_Restore()
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--依次遍历所有单位
	world:enumunit(function(eu)
		local hp_restore = eu:GetHpRestore() --回血速度（每秒）
		local hp_restore_show = hp_restore --UI显示的值
		local hp = eu.attr.hp --当前血量
		local hp_max = eu:GetHpMax() --最大血量
		
		if (hp_restore == 0) then --不回血
			--
		elseif (hp_restore > 0) then --回血
			if (hp < hp_max) then --血未回满
				--计算本次回血的整数部分
				local float_value = eu.attr.hp_restore_float_value --小数部分血量
				
				--本次的总回血量
				local hp_restore_sum = hp_restore + float_value
				
				--分情况处理小数部分
				if (hp_restore_sum >= 0) then --本次回血为正数或0
					--整数部分
					hp_restore = hApi.floor(hp_restore_sum)
					
					--小数部分
					float_value = hp_restore_sum - hp_restore
				else --本次回血为负数
					--因为是回血，所以不会扣除血量
					--整数部分
					hp_restore = 0
					
					--小数部分
					float_value = hp_restore_sum
				end
				
				--检测是否回满血
				local new_hp = hp + hp_restore
				if (new_hp > hp_max) then
					--当前血量为最大血量
					new_hp = hp_max
					
					--小数部分为0
					float_value = 0
				end
				
				--标记新的血量
				eu.attr.hp = new_hp
				
				--标记新的小数部分
				eu.attr.hp_restore_float_value = float_value
				
				--更新英雄头像的血条(+)
				local oHero = eu:gethero()
				if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
					--oHero.heroUI["hpBar"]:setV(new_hp, hp_max)
					--设置大菠萝的血条
					SetHeroHpBarPercent(oHero, new_hp, hp_max, true)
				end
				
				--更新血条控件
				if eu.chaUI["hpBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					eu.chaUI["hpBar"]:setV(new_hp, hp_max)
					--print("oUnit.chaUI5()", new_hp, hp_max)
				end
				if eu.chaUI["numberBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					eu.chaUI["numberBar"]:setText(new_hp .. "/" .. hp_max)
				end
				
				--[[
				--geyachao: 大菠萝不显示了
				--显示动画
				--显示在角色的头顶
				local cx, cy, cw, ch = eu:getbox()
				local offsetX = math.floor(cx + cw / 2)
				--local offsetY = math.floor(cy + ch)
				local offsetY = 0
				if (eu.data.type == hVar.UNIT_TYPE.HERO) then
					offsetY = 50
				end
				hUI.floatNumber:new(
				{
					parent = eu.handle._n,
					font = "numGreen",
					text = "+" .. hp_restore_show, --hp_restore_show
					size = 10,
					x = offsetX,
					y = offsetY + 57,
					align = "MB",
					moveY = 16,
					lifetime = 800,
					fadeout = 600,
				})
				]]
			end
		elseif (hp_restore < 0) then --掉血
			if (hp > 0) then --活着的角色
				--计算本次掉血的整数部分
				local float_value = eu.attr.hp_restore_float_value --小数部分血量
				
				--本次的总掉血量
				local hp_restore_sum = hp_restore + float_value
				
				--分情况处理小数部分
				if (hp_restore_sum >= 0) then --本次掉血为正数或0
					--因为掉回血，所以不会增加血量
					hp_restore = 0
					
					--小数部分
					float_value = hp_restore_sum
				else --本次掉血为负数
					--整数部分
					hp_restore = -hApi.floor(-hp_restore_sum)
					
					--小数部分
					float_value = hp_restore_sum - hp_restore
				end
				
				--处理伤害前特殊处理事件
				if On_Hp_Dmg_Before_Special_Event then
					--oDmgUnit, skillId, mode, dmg, oAttacker
					hp_restore = On_Hp_Dmg_Before_Special_Event(eu, -1, 0, -hp_restore, eu, eu:getowner():getforce(), eu:getowner():getpos())
					hp_restore = -hp_restore
				end
				
				--防止脏数据
				hp = eu.attr.hp
				
				--新的血量
				local new_hp = hp + hp_restore
				if (new_hp < 0) then
					new_hp = 0
				end
				
				--标记新的血量
				eu.attr.hp = new_hp
				
				--标记新的小数部分
				eu.attr.hp_restore_float_value = float_value
				
				--更新英雄头像的血条(-)
				local oHero = eu:gethero()
				if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
					--oHero.heroUI["hpBar"]:setV(new_hp, hp_max)
					--设置大菠萝的血条
					SetHeroHpBarPercent(oHero, new_hp, hp_max, true)
				end
				
				--更新血条控件
				if eu.chaUI["hpBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					eu.chaUI["hpBar"]:setV(new_hp, hp_max)
					--print("oUnit.chaUI6()", new_hp, hp_max)
				end
				if eu.chaUI["numberBar"] then
					if (hp_max <= 0) then
						hp_max = 1
					end
					eu.chaUI["numberBar"]:setText(new_hp .. "/" .. hp_max)
				end
				
				--[[
				--geyachao: 大菠萝不显示了
				--显示动画
				--显示在角色的头顶
				local cx, cy, cw, ch = eu:getbox()
				local offsetX = math.floor(cx + cw / 2)
				--local offsetY = math.floor(cy + ch)
				local offsetY = 0
				if (eu.data.type == hVar.UNIT_TYPE.HERO) then
					offsetY = 50
				end
				hUI.floatNumber:new(
				{
					parent = eu.handle._n,
					font = "numRed",
					text = hp_restore_show, --hp_restore_show
					size = 10,
					x = offsetX,
					y = offsetY + 57,
					align = "LB",
					moveY = 15,
					lifetime = 800,
					fadeout = 600,
				})
				]]
				
				--检测是否已死亡
				if (new_hp <= 0) then
					eu:dead()
				end
			end
		end
	end)
end

--野怪点参数初始化
_hu.WildInit = function(self)
	local d = self.data
	d.wildbirthTime = 0
	d.wildbirthDic = {}
	d.wildNum = 0
	d.wildPrecondition = true
	d.wildPreCDeadList = {}
end

--检测出怪前置条件是否满足
_hu.WildCheckPrecondition = function(self)
	local ret = false
	local d = self.data
	
	--单位是路点
	if d.type == hVar.UNIT_TYPE.WAY_POINT then
		local w = self:getworld()
		local mapInfo = w.data.tdMapInfo
		
		if not w or not mapInfo then
			return
		end
		
		--游戏暂停或结束，直接退出
		if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
			return
		end
		
		--如果回合还没开始，退出
		if mapInfo.wave <= 0 then
			return
		end
		
		local tgrData = self:gettriggerdata()
		--单位是野怪出生点
		if tgrData and tgrData.pointType and tgrData.pointType == 3 then
			local unitAliveSetting = tgrData.wildPreconditionUnitAlive
			--如果配置了单位生存前置条件，则要判定配置的单位是否存在
			if unitAliveSetting and type(unitAliveSetting) == "table" then
				for i = 1, #unitAliveSetting do
					local unitAliveTgrId = unitAliveSetting[i]
					if not d.wildPreCDeadList[unitAliveTgrId] then
						ret = true
						break
					end
				end
			else
				--如果没有配置，则默认认为可以一直生成单位
				ret = true
			end
		end
	end

	return ret
end

--野怪刷新
_hu.WildBirthUpdate = function(self)
	
	local d = self.data
	
	--单位是路点
	if d.type == hVar.UNIT_TYPE.WAY_POINT then
		local w = self:getworld()
		local mapInfo = w.data.tdMapInfo
		
		if not w or not mapInfo then
			return
		end
		
		--游戏暂停或结束，直接退出
		if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
			return
		end
		
		--如果回合还没开始，退出
		if mapInfo.wave <= 0 then
			return
		end
		
		if not self:WildCheckPrecondition() then
			return
		end
		
		local lv = 1
		local diff = w.data.MapDifficulty
		if mapInfo.isMapDiffEnemyLv then
			lv = mapInfo.mapDiffEnemyLv[diff] or 1
			--print("_hu.WildBirthUpdate lv:",diff,lv)
		end
		
		local tgrData = self:gettriggerdata()
		--单位是野怪出生点
		if tgrData and tgrData.pointType and tgrData.pointType == 3 then
			
			local wave = mapInfo.wave --当前波次
			local wildBeginWave = tgrData.wildBeginWave --野怪出现波次
			
			--如果野怪出现波次异常，则退出
			if not wildBeginWave or wildBeginWave <= 0 or wildBeginWave > mapInfo.totalWave then
				return
			end
			
			local wildBeginWaveDelay = tgrData.wildBeginWaveDelay or 0
			
			--如果当前波次已经大于野怪初始出生的波次，则开始逻辑
			if wave >= tgrData.wildBeginWave then
				
				local timeNow = w:gametime()
				
				--如果未初始化野怪出生时间则进行初始化（第一次出怪）
				if not d.wildbirthTime or d.wildbirthTime == 0 then
					d.wildbirthTime = timeNow + tgrData.wildBeginWaveDelay --当前时间+野怪出怪延时
				end
				
				--实际间隔时间是怪物全部死亡时设置的，所以一定会触发出野怪，只需要判定时间即可
				if timeNow >= d.wildbirthTime then
					local wildPerWave = tgrData.wildPerWave or {}
					--当前波次需要出的怪信息
					local wildListInfo = wildPerWave[wave]
					--如果有当前波次的出怪信息
					if wildListInfo and wildListInfo ~= "" then
						
						--野怪点
						local x, y = hApi.chaGetPos(self.handle) --坐标
						local wildNum = 0
						
						--分割字符串
						local tWildInfo = hApi.Split(wildListInfo,"|")
						--解析出的第一位为出怪时的坐标类型
						local coordinateType = tonumber(tWildInfo[1] or 0)
						--遍历后续怪物信息
						for i = 2, #tWildInfo do
							local wildInfo = tWildInfo[i]
							--出怪信息
							if wildInfo and wildInfo ~= "" and wildInfo ~= "nil" then
								--分割字符串
								local tWild = hApi.Split(wildInfo,"*")
								--怪物id
								local wildId = tWild[1]
								
								local _,_,rUIdx = string.find(wildId, "&(%d+)")
								if rUIdx then
									local rIdx = tonumber(rUIdx)
									wildId = mapInfo.randomUnitType[wave][rIdx] or 0
								else
									wildId = tonumber(tWild[1]) or 0
								end

								--怪物属方
								local wildOwner = 24
								local force = tonumber(tWild[2]) or 2
								if force == 0 then
									force = hVar.FORCE_DEF.SHU
								end
								local forcePlayer = w:GetForce(force)
								if forcePlayer then
									wildOwner = forcePlayer:getpos()
								else
									if force == hVar.FORCE_DEF.SHU then
										wildOwner = 21
									elseif force == hVar.FORCE_DEF.WEI then
										wildOwner = 22
									elseif force == hVar.FORCE_DEF.NEUTRAL then
										wildOwner = 23
									elseif force == hVar.FORCE_DEF.NEUTRAL_ENEMY then
										wildOwner = 24
									end
								end
								
								--出怪坐标
								local wildPosX = x
								local wildPosY = y
								local wildFace
								local ox,oy
								--如果是自己写死偏移
								if coordinateType == 0 then
									local face = tonumber(tWild[3])
									local dx = tonumber(tWild[4])
									local dy = tonumber(tWild[5])
									wildFace = face
									wildPosX = wildPosX + dx
									wildPosY = wildPosY + dy
									ox = wildPosX
									oy = wildPosY
									wildPosX, wildPosY = hApi.Scene_GetSpace(wildPosX, wildPosY, 60)
								--如果是随机偏移
								elseif  coordinateType == 1 then
									local radius = tonumber(tWild[3]) or 30
									
									local r = w:random(24, radius) --随机偏移半径
									
									local face = w:random(0, 360)
									local fangle = face * math.pi / 180 --弧度制
									fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
									local dx = r * math.cos(fangle) --随机偏移值x
									local dy = r * math.sin(fangle) --随机偏移值y
									dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
									dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
									
									wildFace = face
									wildPosX = wildPosX + dx --随机x位置
									wildPosY = wildPosY + dy --随机y位置
									--wildPosX, wildPosY = hApi.Scene_GetSpace(wildPosX, wildPosY, 60)
								end
								
								
								--添加角色
								local wildU = w:addunit(wildId,wildOwner,nil,nil,wildFace,wildPosX,wildPosY,nil,nil)
								--print("出生点:", x, y)
								--print("野怪：",wildId, ox, oy, wildPosX,wildPosY)
								
								if wildU then
									
									--如果是塔，查找塔的升级列表，并且将塔升到最高级
									local uType = wildU.data.type
									if uType == hVar.UNIT_TYPE.TOWER then
										local td_upgrade = wildU.td_upgrade
										if td_upgrade and td_upgrade.upgradeSkill then
											for skillId, skillInfo in pairs(td_upgrade.upgradeSkill) do
												if skillId ~= "order" then
													local skillLv = skillInfo.maxLv or 1
													if skillId > 0 then
														wildU:learnSkill(skillId, skillLv)
													end
												end
											end
										end
									end
									
									--野怪计数增加
									wildNum = wildNum + 1
									
									--设置角色AI状态
									--wildU:setAIState(hVar.UNIT_AI_STATE.IDLE)
									
									--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
									hGlobal.event:call("Event_UnitBorn", wildU)
									
									d.wildbirthDic[wildU:getworldC()] = true
									d.wildNum = wildNum
								end
							end
						end
						
						--如果野怪数量大于0
						if wildNum > 0 then

							local wildRebirthTime = tgrData.wildRebirthTime or 0
							local wildRefreshType = tgrData.wildRefreshType or 0
							
							--以上一波野怪死亡时间计算下一波出怪延时
							if wildRefreshType == 0 then
								--野怪产生后设置下一次发兵时间为无限大
								d.wildbirthTime = math.huge
							elseif wildRefreshType == 1 then
								d.wildbirthTime = timeNow + wildRebirthTime
							end
						end
					end
				end
			end
		end

	end
end

--怪物死亡事件刷新(只有野怪出生点角色会走进来)
_hu.WildDeathCheck = function(self, oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
	
	local d = self.data
	
	--单位是路点
	if d.type == hVar.UNIT_TYPE.WAY_POINT then
		
		local w = self:getworld()
		local mapInfo = w.data.tdMapInfo
		
		if not w or not mapInfo then
			return
		end
		
		--游戏暂停或结束，直接退出
		if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
			return
		end
		
		--如果回合还没开始，退出
		if mapInfo.wave <= 0 then
			return
		end
		
		local tgrData = self:gettriggerdata()
		--单位是野怪出生点
		if tgrData and tgrData.pointType and tgrData.pointType == 3 then
			
			local deadC = oDeadTarget:getworldC()
			
			--如果死亡的角色正好是出怪点添加的角色
			if d.wildbirthDic[deadC] then
				--设置怪物已经死亡
				d.wildbirthDic[deadC] = nil
				--出怪点剩余数量减少
				d.wildNum = d.wildNum - 1
				
				--如果出怪点数量已经为0，则重置时间
				if d.wildNum <= 0 then
					local wildRebirthTime = tgrData.wildRebirthTime or 0
					local wildRefreshType = tgrData.wildRefreshType or 0
					
					--以上一波野怪死亡时间计算下一波出怪延时
					if wildRefreshType == 0 then
						local timeNow = w:gametime()
						d.wildbirthTime = timeNow + wildRebirthTime

						--geyachao: 野怪刷新特殊事件处理函数
						if OnWildRelive_Special_Event then
							--安全执行
							hpcall(OnWildRelive_Special_Event, self, oDeadTarget.data.id, wildRebirthTime)
							--OnWildRelive_Special_Event(self, oDeadTarget.data.id, wildRebirthTime)
						end
					end
				end
			end
			
			--检测死亡角色是否是必须存活的角色
			local deadTgrId = oDeadTarget.data.triggerID
			if deadTgrId and deadTgrId ~= 0 then
				local unitAliveSetting = tgrData.wildPreconditionUnitAlive
				if unitAliveSetting and type(unitAliveSetting) == "table" then
					for i = 1, #unitAliveSetting do
						local unitAliveTgrId = unitAliveSetting[i]
						if unitAliveTgrId == deadTgrId then
							d.wildPreCDeadList[unitAliveTgrId] = true
							break
						end
					end
				end
			end
		end
	end

end

--设置装备状态（参数:装备位置，是否获得该装备技能）
_hu.SetEquipState = function(self,pos,state)
	local d = self.data
	d.equipState[pos] = state
end

--获取装备状态（参数:装备位置）
_hu.GetEquipState = function(self,pos)
	local d = self.data
	return d.equipState[pos]
end

--设置单位所属波次（目前只有发兵需要设置）
_hu.setWaveBelong = function(self,wave)
	if wave and wave > 0 then
		local d = self.data
		d.waveBelong = wave
	end
end

--获得单位所属波次(目前只有发兵需要检测)
_hu.getWaveBelong = function(self)
	local d = self.data
	return d.waveBelong
end