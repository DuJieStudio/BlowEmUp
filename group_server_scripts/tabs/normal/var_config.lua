
--=======================================================道具配置=======================================================
--道具品质
hVar.ITEM_QUALITY = {
	WHITE = 1,					--白色
	BLUE = 2,					--蓝色
	GOLD = 3,					--金色
	RED = 4,					--红色
	ORANGE = 5,					--橙色
	
	MAX = 5,					--最高品质
}

--道具类型定义
hVar.ITEM_TYPE = {
	NONE = 1,
	HEAD = 2,
	BODY = 3,
	WEAPON = 4,
	ORNAMENTS = 5,
	MOUNT = 6,
	FOOT = 7,
	HEROCARD = 8,
	PLAYERITEM = 9,
	DEPLETION = 10, --消耗品
	RESOURCES = 11,
	MAPBAG = 12,
	REWARD = 13,
	GIFTITEM = 14,
	SOULSTONE = 15,
	TACTICDEBRIS = 16,
	MAPITEM = 17,
	TREASUREDEBRIS = 18, --宝物碎片
	CANGBAOTU_NORMAL = 19, --藏宝图
	CANGBAOTU_HIGH = 20, --高级藏宝图
	WEAPON_GUN = 21, --武器枪
	
	CHEST_WEAPON_GUN = 22, --武器枪宝箱
	CHEST_TACTIC = 23, --战术卡宝箱
	CHEST_PET = 24, --宠物宝箱
	CHEST_EQUIP = 25, --装备宝箱
	
	TACTIC_USE = 26, --使用类战术卡
	
	WEAPONGUNDEBRIS = 27, --武器枪碎片
	PETDEBRIS = 28, --宠物碎片
	SAVEDATAPOINT = 29, --存盘点
	
	TALK = 30, --对话类道具
	CHEST_REDEQUIP = 31, --神器宝箱
}

--道具品质
hVar.ITEM_QUALITY = {
	WHITE = 1,					--白色
	BLUE = 2,					--蓝色
	GOLD = 3,					--金色
	RED = 4,					--红色
	ORANGE = 5,					--橙色
	
	MAX = 5,					--最高品质
}

--道具孔的属性定义
hVar.ITEM_ATTR_DEF = {
	UNKNWON = "unknwon",			--未知
	
	ATK1 = "atk1",					--攻击 1
	ATK2 = "atk2",					--攻击 2
	ATK3 = "atk3",					--攻击 3
	ATK4 = "atk4",					--攻击 4
	ATK5 = "atk5",					--攻击 5
	
	ATK_BULLET1 = "atk_bullet1",			--武器攻击 1
	ATK_BULLET2 = "atk_bullet2",			--武器攻击 2
	ATK_BULLET3 = "atk_bullet3",			--武器攻击 3
	ATK_BULLET4 = "atk_bullet4",			--武器攻击 4
	ATK_BULLET5 = "atk_bullet5",			--武器攻击 5
	
	HP1 = "hp1",					--血量 1
	HP2 = "hp2",					--血量 2
	HP3 = "hp3",					--血量 3
	HP4 = "hp4",					--血量 4
	HP5 = "hp5",					--血量 5
	
	DP1 = "dp1",					--物理防御 1
	DP2 = "dp2",					--物理防御 2
	DP3 = "dp3",					--物理防御 3
	DP4 = "dp4",					--物理防御 4
	DP5 = "dp5",					--物理防御 5
	
	DM1 = "dm1",					--法术防御 1
	DM2 = "dm2",					--法术防御 2
	DM3 = "dm3",					--法术防御 3
	DM4 = "dm4",					--法术防御 4
	DM5 = "dm5",					--法术防御 5
	
	DR1 = "dr1",					--物理闪避 1
	DR2 = "dr2",					--物理闪避 2
	DR3 = "dr3",					--物理闪避 3
	DR4 = "dr4",					--物理闪避 4
	DR5 = "dr5",					--物理闪避 5
	
	HR1 = "hr1",					--命中几率 1
	HR2 = "hr2",					--命中几率 2
	HR3 = "hr3",					--命中几率 3
	HR4 = "hr4",					--命中几率 4
	HR5 = "hr5",					--命中几率 5
	
	CR1 = "cr1",					--暴击几率 1
	CR2 = "cr2",					--暴击几率 2
	CR3 = "cr3",					--暴击几率 3
	CR4 = "cr4",					--暴击几率 4
	CR5 = "cr5",					--暴击几率 5
	
	CV1 = "cv1",					--暴击倍率 1
	CV2 = "cv2",					--暴击倍率 2
	CV3 = "cv3",					--暴击倍率 3
	CV4 = "cv4",					--暴击倍率 4
	CV5 = "cv5",					--暴击倍率 5
	
	HPR3 = "hpr3",					--回血 3
	HPR4 = "hpr4",					--回血 4
	HPR5 = "hpr5",					--回血 5
	
	RT3 = "rt3",					--复活时间 3
	RT4 = "rt4",					--复活时间 4
	RT5 = "rt5",					--复活时间 5
	
	AS1 = "as1",					--攻击速度 1
	AS2 = "as2",					--攻击速度 2
	AS3 = "as3",					--攻击速度 3
	AS4 = "as4",					--攻击速度 4
	AS5 = "as5",					--攻击速度 5
	
	PCD1 = "pcd1",					--被动技能CD 1
	PCD2 = "pcd2",					--被动技能CD 2
	PCD3 = "pcd3",					--被动技能CD 3
	PCD4 = "pcd4",					--被动技能CD 4
	PCD5 = "pcd5",					--被动技能CD 5
	
	LS4 = "ls4",					--吸血4
	LS5 = "ls5",					--吸血5
	
	
	THUNDER_DEF1 = "thunder_def1",			--雷防御1
	THUNDER_DEF2 = "thunder_def2",			--雷防御2
	THUNDER_DEF3 = "thunder_def3",			--雷防御3
	THUNDER_DEF4 = "thunder_def4",			--雷防御4
	THUNDER_DEF5 = "thunder_def5",			--雷防御5
	
	FIRE_DEF1 = "fire_def1",			--火防御1
	FIRE_DEF2 = "fire_def2",			--火防御2
	FIRE_DEF3 = "fire_def3",			--火防御3
	FIRE_DEF4 = "fire_def4",			--火防御4
	FIRE_DEF5 = "fire_def5",			--火防御5
	
	POISON_DEF1 = "poison_def1",			--毒防御1
	POISON_DEF2 = "poison_def2",			--毒防御2
	POISON_DEF3 = "poison_def3",			--毒防御3
	POISON_DEF4 = "poison_def4",			--毒防御4
	POISON_DEF5 = "poison_def5",			--毒防御5
	
	CRYSTAL_RATE1 = "crystal1",			--水晶收益率1
	CRYSTAL_RATE2 = "crystal2",			--水晶收益率2
	CRYSTAL_RATE3 = "crystal3",			--水晶收益率3
	CRYSTAL_RATE4 = "crystal4",			--水晶收益率4
	CRYSTAL_RATE5 = "crystal5",			--水晶收益率5
	
	GENADE_CD1 = "genade_cd1",			--手雷冷却1
	GENADE_CD2 = "genade_cd2",			--手雷冷却2
	GENADE_CD3 = "genade_cd3",			--手雷冷却3
	GENADE_CD4 = "genade_cd4",			--手雷冷却4
	GENADE_CD5 = "genade_cd5",			--手雷冷却5
	
	MELEE_BOUNCE1 = "melee_bounce1",		--近战弹开1
	MELEE_BOUNCE2 = "melee_bounce2",		--近战弹开2
	MELEE_BOUNCE3 = "melee_bounce3",		--近战弹开3
	MELEE_BOUNCE4 = "melee_bounce4",		--近战弹开4
	MELEE_BOUNCE5 = "melee_bounce5",		--近战弹开5
	
	MELEE_FIGHT1 = "melee_fight1",			--近战反击1
	MELEE_FIGHT2 = "melee_fight2",			--近战反击2
	MELEE_FIGHT3 = "melee_fight3",			--近战反击3
	MELEE_FIGHT4 = "melee_fight4",			--近战反击4
	MELEE_FIGHT5 = "melee_fight5",			--近战反击5
	
	MELEE_STONE1 = "melee_stone1",			--近战碎石1
	MELEE_STONE2 = "melee_stone2",			--近战碎石2
	MELEE_STONE3 = "melee_stone3",			--近战碎石3
	MELEE_STONE4 = "melee_stone4",			--近战碎石4
	MELEE_STONE5 = "melee_stone5",			--近战碎石5
	
	PET_HR1 = "pet_hr1",				--宠物回血1
	PET_HR2 = "pet_hr2",				--宠物回血2
	PET_HR3 = "pet_hr3",				--宠物回血3
	PET_HR4 = "pet_hr4",				--宠物回血4
	PET_HR5 = "pet_hr5",				--宠物回血5
	
	PET_HP1 = "pet_hp1",				--宠物生命1
	PET_HP2 = "pet_hp2",				--宠物生命2
	PET_HP3 = "pet_hp3",				--宠物生命3
	PET_HP4 = "pet_hp4",				--宠物生命4
	PET_HP5 = "pet_hp5",				--宠物生命5
	
	PET_ATK1 = "pet_atk1",				--宠物攻击1
	PET_ATK2 = "pet_atk2",				--宠物攻击2
	PET_ATK3 = "pet_atk3",				--宠物攻击3
	PET_ATK4 = "pet_atk4",				--宠物攻击4
	PET_ATK5 = "pet_atk5",				--宠物攻击5
	
	PET_AS1 = "pet_as1",				--宠物攻速1
	PET_AS2 = "pet_as2",				--宠物攻速2
	PET_AS3 = "pet_as3",				--宠物攻速3
	PET_AS4 = "pet_as4",				--宠物攻速4
	PET_AS5 = "pet_as5",				--宠物攻速5
	
	TRAP_GCD1 = "trap_gcd1",			--陷阱施法间隔1
	TRAP_GCD2 = "trap_gcd2",			--陷阱施法间隔2
	TRAP_GCD3 = "trap_gcd3",			--陷阱施法间隔3
	TRAP_GCD4 = "trap_gcd4",			--陷阱施法间隔4
	TRAP_GCD5 = "trap_gcd5",			--陷阱施法间隔5
	
	TRAP_GE1 = "trap_ge1",				--陷阱困敌时间1
	TRAP_GE2 = "trap_ge2",				--陷阱困敌时间2
	TRAP_GE3 = "trap_ge3",				--陷阱困敌时间3
	TRAP_GE4 = "trap_ge4",				--陷阱困敌时间4
	TRAP_GE5 = "trap_ge5",				--陷阱困敌时间5
	
	FLY_GCD1 = "fly_gcd1",				--天网施法间隔1
	FLY_GCD2 = "fly_gcd2",				--天网施法间隔2
	FLY_GCD3 = "fly_gcd3",				--天网施法间隔3
	FLY_GCD4 = "fly_gcd4",				--天网施法间隔4
	FLY_GCD5 = "fly_gcd5",				--天网施法间隔5
	
	FLY_GE1 = "fly_ge1",				--天网困敌时间1
	FLY_GE2 = "fly_ge2",				--天网困敌时间2
	FLY_GE3 = "fly_ge3",				--天网困敌时间3
	FLY_GE4 = "fly_ge4",				--天网困敌时间4
	FLY_GE5 = "fly_ge5",				--天网困敌时间5
	
	PUZZLE1 = "puzzle1",				--迷惑几率1
	PUZZLE2 = "puzzle2",				--迷惑几率2
	PUZZLE3 = "puzzl3",				--迷惑几率3
	PUZZLE4 = "puzzle4",				--迷惑几率4
	PUZZLE5 = "puzzle5",				--迷惑几率5
	
	--兵种卡附加的属性类型
	HP_RATE5 = "hp_rate5",			--血量+5％
	ATK_RATE5 = "atk_rate5",		--攻击+5％
	AR5 = "ar5",					--射程+50
	DMG5 = "dmg5",					--伤害+5％
	--DP5 = "dp5",					--物防+5
	--DM5 = "dm5",					--法防+5
	--DR5 = "dr5",					--闪避+5％
	--CR5 = "cr5",					--暴率+5％
	--CV5 = "cv5",					--暴倍+0.5
	HPR7 = "hpr7",					--回血+5
	--AS1 = "as1",					--攻速+5％
	MS_RATE5 = "ms_rate5",			--移速+5％
	LS8 = "ls8",					--吸血+5％
	LT5 = "lt5",					--存活+5％
	DSCT5 = "dsct5",				--价格-5％
	CD1S = "cd1s",					--冷却-1秒
	SKILL_CD1S = "skill_cd1s",		--技能冷却-1秒
	SKILL_DMG5 = "skill_dmg5",		--技能伤害+5％
	SKILL_RNG5 = "skill_rng5",		--技能范围+5％
	SKILL_COS5 = "skill_cos5",		--技能混乱+1秒
	SKILL_NUM5 = "skill_num5",		--技能数量+5％
	SKILL_POI5 = "skill_poi5",		--技能中毒+1层
	SKILL_LT1 = "skill_lt1",		--技能时间+1秒
}

local __I_Q = hVar.ITEM_QUALITY
local __I_A_D = hVar.ITEM_ATTR_DEF



--洗炼能洗出的属性
--道具属性品质分类池
hVar.ITEM_ATTR_QUALITY_DEF = {
	
	--{攻击        , 血量       , 物理防御   , 法术防御   , 物理闪避   , 暴击几率   , 暴击倍率   , 回血        , 复活时间   , 攻击速度   , 被动技能CD  , 吸血       },
	[__I_Q.WHITE]	= {__I_A_D.ATK_BULLET1, __I_A_D.HP1, __I_A_D.DP1, __I_A_D.THUNDER_DEF1, __I_A_D.FIRE_DEF1, __I_A_D.POISON_DEF1, __I_A_D.CRYSTAL_RATE1, __I_A_D.GENADE_CD1, __I_A_D.MELEE_BOUNCE1, __I_A_D.MELEE_FIGHT1, __I_A_D.PET_HR1, __I_A_D.PET_HP1, __I_A_D.PET_ATK1, __I_A_D.PET_AS1, __I_A_D.TRAP_GCD1, __I_A_D.TRAP_GE1, __I_A_D.FLY_GCD1, __I_A_D.FLY_GE1, __I_A_D.PUZZLE1,},
	[__I_Q.BLUE]	= {__I_A_D.ATK_BULLET2, __I_A_D.HP2, __I_A_D.DP2, __I_A_D.THUNDER_DEF2, __I_A_D.FIRE_DEF2, __I_A_D.POISON_DEF2, __I_A_D.CRYSTAL_RATE2, __I_A_D.GENADE_CD2, __I_A_D.MELEE_BOUNCE2, __I_A_D.MELEE_FIGHT2, __I_A_D.PET_HR2, __I_A_D.PET_HP2, __I_A_D.PET_ATK2, __I_A_D.PET_AS2, __I_A_D.TRAP_GCD2, __I_A_D.TRAP_GE2, __I_A_D.FLY_GCD2, __I_A_D.FLY_GE2, __I_A_D.PUZZLE2,},
	[__I_Q.GOLD]	= {__I_A_D.ATK_BULLET3, __I_A_D.HP3, __I_A_D.DP3, __I_A_D.THUNDER_DEF3, __I_A_D.FIRE_DEF3, __I_A_D.POISON_DEF3, __I_A_D.CRYSTAL_RATE3, __I_A_D.GENADE_CD3, __I_A_D.MELEE_BOUNCE3, __I_A_D.MELEE_FIGHT3, __I_A_D.PET_HR3, __I_A_D.PET_HP3, __I_A_D.PET_ATK3, __I_A_D.PET_AS3, __I_A_D.TRAP_GCD3, __I_A_D.TRAP_GE3, __I_A_D.FLY_GCD3, __I_A_D.FLY_GE3, __I_A_D.PUZZLE3,},
	[__I_Q.RED]	= {__I_A_D.ATK_BULLET4, __I_A_D.HP4, __I_A_D.DP4, __I_A_D.THUNDER_DEF4, __I_A_D.FIRE_DEF4, __I_A_D.POISON_DEF4, __I_A_D.CRYSTAL_RATE4, __I_A_D.GENADE_CD4, __I_A_D.MELEE_BOUNCE4, __I_A_D.MELEE_FIGHT4, __I_A_D.PET_HR4, __I_A_D.PET_HP4, __I_A_D.PET_ATK4, __I_A_D.PET_AS4, __I_A_D.TRAP_GCD4, __I_A_D.TRAP_GE4, __I_A_D.FLY_GCD4, __I_A_D.FLY_GE4, __I_A_D.PUZZLE4,},
	[__I_Q.ORANGE]	= {__I_A_D.ATK_BULLET5, __I_A_D.HP5, __I_A_D.DP5, __I_A_D.THUNDER_DEF5, __I_A_D.FIRE_DEF5, __I_A_D.POISON_DEF5, __I_A_D.CRYSTAL_RATE5, __I_A_D.GENADE_CD5, __I_A_D.MELEE_BOUNCE5, __I_A_D.MELEE_FIGHT5, __I_A_D.PET_HR5, __I_A_D.PET_HP5, __I_A_D.PET_ATK5, __I_A_D.PET_AS5, __I_A_D.TRAP_GCD5, __I_A_D.TRAP_GE5, __I_A_D.FLY_GCD5, __I_A_D.FLY_GE5, __I_A_D.PUZZLE5,},
}

--道具属性配置（属性值, 显示用的品质颜色）
hVar.ITEM_ATTR_VAL = {
	[__I_A_D.UNKNWON] = {value1 = 0, value2 = 0, quality = __I_Q.WHITE, strTip = "__TEXT_TemporaryNone", attrAdd = nil}, --未知
	
	[__I_A_D.ATK1] = {value1 = 1, value2 = 3, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK2] = {value1 = 3, value2 = 6, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK3] = {value1 = 5, value2 = 9, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK4] = {value1 = 7, value2 = 12, quality = __I_Q.RED, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK5] = {value1 = 9, value2 = 15, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	
	[__I_A_D.ATK_BULLET1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	
	[__I_A_D.HP1] = {value1 = 40, quality = __I_Q.WHITE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP2] = {value1 = 80, quality = __I_Q.BLUE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP3] = {value1 = 120, quality = __I_Q.GOLD, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP4] = {value1 = 160, quality = __I_Q.RED, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP5] = {value1 = 200, quality = __I_Q.ORANGE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	
	[__I_A_D.DP1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	
	[__I_A_D.DM1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	
	[__I_A_D.DR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	
	[__I_A_D.HR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	
	[__I_A_D.CR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	
	[__I_A_D.CV1] = {value1 = 0.1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV2] = {value1 = 0.2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV3] = {value1 = 0.3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV4] = {value1 = 0.4, quality = __I_Q.RED, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV5] = {value1 = 0.5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	
	[__I_A_D.HPR3] = {value1 = 4, quality = __I_Q.GOLD, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	[__I_A_D.HPR4] = {value1 = 6, quality = __I_Q.RED, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	[__I_A_D.HPR5] = {value1 = 8, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	
	[__I_A_D.RT3] = {value1 = -1000, quality = __I_Q.GOLD, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	[__I_A_D.RT4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	[__I_A_D.RT5] = {value1 = -3000, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	
	[__I_A_D.AS1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	
	[__I_A_D.PCD1] = {value1 = -1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD2] = {value1 = -2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD3] = {value1 = -3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD4] = {value1 = -4, quality = __I_Q.RED, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD5] = {value1 = -5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	
	[__I_A_D.LS4] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血
	[__I_A_D.LS5] = {value1 = 2, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血
	
	[__I_A_D.THUNDER_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御1
	[__I_A_D.THUNDER_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御2
	[__I_A_D.THUNDER_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御3
	[__I_A_D.THUNDER_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御4
	[__I_A_D.THUNDER_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御5
	
	[__I_A_D.FIRE_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御1
	[__I_A_D.FIRE_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御2
	[__I_A_D.FIRE_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御3
	[__I_A_D.FIRE_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御4
	[__I_A_D.FIRE_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御5
	
	[__I_A_D.POISON_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御1
	[__I_A_D.POISON_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御2
	[__I_A_D.POISON_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御3
	[__I_A_D.POISON_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御4
	[__I_A_D.POISON_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御5
	
	[__I_A_D.CRYSTAL_RATE1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率1
	[__I_A_D.CRYSTAL_RATE2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率2
	[__I_A_D.CRYSTAL_RATE3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率3
	[__I_A_D.CRYSTAL_RATE4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率4
	[__I_A_D.CRYSTAL_RATE5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率5
	
	[__I_A_D.GENADE_CD1] = {value1 = -20, quality = __I_Q.WHITE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却1
	[__I_A_D.GENADE_CD2] = {value1 = -40, quality = __I_Q.BLUE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却2
	[__I_A_D.GENADE_CD3] = {value1 = -60, quality = __I_Q.GOLD, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却3
	[__I_A_D.GENADE_CD4] = {value1 = -80, quality = __I_Q.RED, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却4
	[__I_A_D.GENADE_CD5] = {value1 = -100, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却5
	
	[__I_A_D.MELEE_BOUNCE1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开1
	[__I_A_D.MELEE_BOUNCE2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开2
	[__I_A_D.MELEE_BOUNCE3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开3
	[__I_A_D.MELEE_BOUNCE4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开4
	[__I_A_D.MELEE_BOUNCE5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开5
	
	[__I_A_D.MELEE_FIGHT1] = {value1 = 60, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击1
	[__I_A_D.MELEE_FIGHT2] = {value1 = 120, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击2
	[__I_A_D.MELEE_FIGHT3] = {value1 = 180, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击3
	[__I_A_D.MELEE_FIGHT4] = {value1 = 240, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击4
	[__I_A_D.MELEE_FIGHT5] = {value1 = 300, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击5
	
	[__I_A_D.MELEE_STONE1] = {value1 = 60, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石1
	[__I_A_D.MELEE_STONE2] = {value1 = 120, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石2
	[__I_A_D.MELEE_STONE3] = {value1 = 180, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石3
	[__I_A_D.MELEE_STONE4] = {value1 = 240, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石4
	[__I_A_D.MELEE_STONE5] = {value1 = 300, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石5
	
	[__I_A_D.PET_HR1] = {value1 = 10, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血1
	[__I_A_D.PET_HR2] = {value1 = 20, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血2
	[__I_A_D.PET_HR3] = {value1 = 30, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血3
	[__I_A_D.PET_HR4] = {value1 = 40, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血4
	[__I_A_D.PET_HR5] = {value1 = 50, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血5
	
	[__I_A_D.PET_HP1] = {value1 = 200, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命1
	[__I_A_D.PET_HP2] = {value1 = 400, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命2
	[__I_A_D.PET_HP3] = {value1 = 600, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命3
	[__I_A_D.PET_HP4] = {value1 = 800, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命4
	[__I_A_D.PET_HP5] = {value1 = 1000, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命5
	
	[__I_A_D.PET_ATK1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击1
	[__I_A_D.PET_ATK2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击2
	[__I_A_D.PET_ATK3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击3
	[__I_A_D.PET_ATK4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击4
	[__I_A_D.PET_ATK5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击5
	
	[__I_A_D.PET_AS1] = {value1 = 2, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速1
	[__I_A_D.PET_AS2] = {value1 = 4, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速2
	[__I_A_D.PET_AS3] = {value1 = 6, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速3
	[__I_A_D.PET_AS4] = {value1 = 8, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速4
	[__I_A_D.PET_AS5] = {value1 = 10, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速5
	
	[__I_A_D.TRAP_GCD1] = {value1 = -500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔1
	[__I_A_D.TRAP_GCD2] = {value1 = -1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔2
	[__I_A_D.TRAP_GCD3] = {value1 = -1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔3
	[__I_A_D.TRAP_GCD4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔4
	[__I_A_D.TRAP_GCD5] = {value1 = -2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔5
	
	[__I_A_D.TRAP_GE1] = {value1 = 500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间1
	[__I_A_D.TRAP_GE2] = {value1 = 1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间2
	[__I_A_D.TRAP_GE3] = {value1 = 1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间3
	[__I_A_D.TRAP_GE4] = {value1 = 2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间4
	[__I_A_D.TRAP_GE5] = {value1 = 2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间5
	
	[__I_A_D.FLY_GCD1] = {value1 = -500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔1
	[__I_A_D.FLY_GCD2] = {value1 = -1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔2
	[__I_A_D.FLY_GCD3] = {value1 = -1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔3
	[__I_A_D.FLY_GCD4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔4
	[__I_A_D.FLY_GCD5] = {value1 = -2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔5
	
	[__I_A_D.FLY_GE1] = {value1 = 500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间1
	[__I_A_D.FLY_GE2] = {value1 = 1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间2
	[__I_A_D.FLY_GE3] = {value1 = 1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间3
	[__I_A_D.FLY_GE4] = {value1 = 2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间4
	[__I_A_D.FLY_GE5] = {value1 = 2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间5
	
	[__I_A_D.PUZZLE1] = {value1 = 0.3, quality = __I_Q.WHITE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率1
	[__I_A_D.PUZZLE2] = {value1 = 0.6, quality = __I_Q.BLUE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率2
	[__I_A_D.PUZZLE3] = {value1 = 0.9, quality = __I_Q.GOLD, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率3
	[__I_A_D.PUZZLE4] = {value1 = 1.2, quality = __I_Q.RED, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率4
	[__I_A_D.PUZZLE5] = {value1 = 1.5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率5
	
	--兵种卡附加的属性类型
	[__I_A_D.HP_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__ATTR__hp_max", attrAdd = "hp_max_rate"}, --血量+5％
	[__I_A_D.ATK_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_atk", attrAdd = "atk_rate"}, --攻击+5％
	[__I_A_D.AR5] = {value1 = 50, quality = __I_Q.RED, strTip = "__Attr_Atk_Range", attrAdd = "atk_radius"}, --射程+50
	[__I_A_D.DMG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__ATTR__power", attrAdd = "army_damage"}, --伤害+5％
	--DP5 = "dp5",					--物防+5
	--DM5 = "dm5",					--法防+5
	--DR5 = "dr5",					--闪避+5％
	--CR5 = "cr5",					--暴率+5％
	--CV5 = "cv5",					--暴倍+0.5
	[__I_A_D.HPR7] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血+5
	--AS1 = "as1",					--攻速+5％
	[__I_A_D.MS_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_move_speed", attrAdd = "move_speed"}, --移速+5％
	[__I_A_D.LS8] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血+5％
	[__I_A_D.LT5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_LiveTime", attrAdd = "live_time"}, --存活+5％
	[__I_A_D.DSCT5] = {value1 = -5, quality = __I_Q.RED, strTip = "__Attr_Hint_army_discount", attrAdd = "army_discount"}, --价格-5％
	[__I_A_D.CD1S] = {value1 = -1, quality = __I_Q.RED, strTip = "__Attr_Hint_army_cooldown", attrAdd = "army_cooldown"}, --冷却-1秒
	[__I_A_D.SKILL_CD1S] = {value1 = -1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_cooldown", attrAdd = "skill_cooldown"}, --技能冷却-1秒
	[__I_A_D.SKILL_DMG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_damage", attrAdd = "skill_damage"}, --技能伤害+5％
	[__I_A_D.SKILL_RNG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_range", attrAdd = "skill_range"}, --技能范围+5％
	[__I_A_D.SKILL_COS5] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_chaos", attrAdd = "skill_chaos"}, --技能混乱+1秒
	[__I_A_D.SKILL_NUM5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_num", attrAdd = "skill_num"}, --技能数量+5％
	[__I_A_D.SKILL_POI5] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_poison", attrAdd = "skill_poison"}, --技能中毒+1层
	[__I_A_D.SKILL_LT1] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_lasttime", attrAdd = "skill_lasttime"}, --技能时间+1秒
}

--道具洗练信息
hVar.ITEM_XILIAN_INFO = 
{
	--锁孔后的外信息
	lockInfo = {
		maxLockCountDay = 999, --每日最多洗炼的次数
		maxLock = 3,
		--[孔数] = {金币消耗，对应的道具id}   (备注：这里的金币消耗和数据库道具id对应的金币消耗需要一致)
		[0] = {0, 9902},
		[1] = {10, 9903},
		[2] = {30, 9904},
		[3] = {60, 9905},
	},
	--品质1
	[__I_Q.WHITE]	= {
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 1,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 0,				--蓝色孔属性
			[__I_Q.GOLD] = 0,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-蓝装
	[__I_Q.BLUE]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 2,
			[2] = 2,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 85,				--蓝色孔属性
			[__I_Q.GOLD] = 15,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-黄装
	[__I_Q.GOLD]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 3,
			[2] = 3,
			[3] = 3,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 80,				--蓝色孔属性
			[__I_Q.GOLD] = 15,				--黄色孔属性
			[__I_Q.RED] = 5,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-橙装
	[__I_Q.RED]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 0,				--蓝色孔属性
			[__I_Q.GOLD] = 0,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-红装
	[__I_Q.ORANGE]	={
		--cost = 200,						--积分消耗
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 60,				--蓝色孔属性
			[__I_Q.GOLD] = 25,				--黄色孔属性
			[__I_Q.RED] = 10,				--红色孔属性
			[__I_Q.ORANGE] = 5,				--紫色孔属性
		},		
	},
}

--道具分解神器晶石-芯片材料
hVar.ITEM_SELL_CRYSTAL = {
	[__I_Q.WHITE] = 1,				--白色装备
	[__I_Q.BLUE] = 3,				--蓝色装备分解芯片
	[__I_Q.GOLD] = 9,				--黄色装备分解芯片
	[__I_Q.RED] = 0,				--橙色装备
	[__I_Q.ORANGE] = 30,				--红色装备分解芯片
}


--道具合成出孔概率
hVar.ITEM_MERGE_SLOT_PROB = 
{
	totalValue = 100,			--总权值
	--{value = 0, reward = 1},		--1孔(value权值 reward孔数)
	{value = 60, reward = 2},		--2孔(value权值 reward孔数)
	{value = 35, reward = 3},		--3孔(value权值 reward孔数)
	{value = 5, reward = 4},		--4孔(value权值 reward孔数)
}

--道具开神器锦囊出孔概率
hVar.ITEM_CHEST_SLOT_PROB =
{
	[__I_Q.WHITE] =					--白色开孔几率
	{
		totalValue = 100,			--总权值
		{value = 100, reward = 0},		--1孔(value权值 reward孔数)
	},
	
	[__I_Q.BLUE] =					--蓝色开孔几率
	{
		totalValue = 100,			--总权值
		{value = 95, reward = 1},		--1孔(value权值 reward孔数)
		{value = 5, reward = 2},		--2孔(value权值 reward孔数)
	},
	
	[__I_Q.GOLD] =					--黄色开孔几率
	{
		totalValue = 100,			--总权值
		{value = 82, reward = 1},		--1孔(value权值 reward孔数)
		{value = 15, reward = 2},		--2孔(value权值 reward孔数)
		{value = 3, reward = 3},		--3孔(value权值 reward孔数)
	},
	
	[__I_Q.RED] =					--橙色开孔几率
	{
		totalValue = 0,				--总权值
		{value = 0, reward = 1},		--1孔(value权值 reward孔数)
		{value = 0, reward = 2},		--2孔(value权值 reward孔数)
		{value = 0, reward = 3},		--3孔(value权值 reward孔数)
	},
	
	[__I_Q.ORANGE] =				--红色开孔几率
	{
		totalValue = 100,			--总权值
		{value = 70, reward = 2},		--2孔(value权值 reward孔数)
		{value = 26, reward = 3},		--3孔(value权值 reward孔数)
		{value = 4, reward = 4},		--4孔(value权值 reward孔数)
	},
}

--神器晶石兑换出孔概率
hVar.ITEM_DEBRIS_EXCHANGE_SLOT_PROB = 
{
	totalValue = 100,			--总权值
	{value = 88, reward = 2},		--2孔(value权值 reward孔数)
	{value = 10, reward = 3},		--3孔(value权值 reward孔数)
	{value = 2, reward = 4},		--4孔(value权值 reward孔数)
}

--道具品质几率
hVar.ITEM_QUALITY_PROB =
{
	maxQuality = 10,			--最高品质
	
	totalValue = 100,			--总权值
	{value = 20, quality = 1,},		--品质1
	{value = 18, quality = 2,},		--品质2
	{value = 15, quality = 3,},		--品质3
	{value = 13, quality = 4,},		--品质4
	{value = 11, quality = 5,},		--品质5
	{value = 8, quality = 6,},		--品质6
	{value = 5, quality = 7,},		--品质7
	{value = 5, quality = 8,},		--品质8
	{value = 3, quality = 9,},		--品质9
	{value = 2, quality = 10,},		--品质10
}

--神器祭坛合成池
hVar.ITEM_MERGE_POOL = 
{
	totalValue = 2,				--总权重(后续所有权重和一定要等于总权重)
	{value = 1, reward = {10,12202,-1}},	--10: 炽魂战衣（类型10是神装道具，服务器计算） 孔数(默认0):-1随机0孔1孔2孔3孔4孔
	{value = 1, reward = {10,12203,-1}},	--10: 玄冰魔衣（类型10是神装道具，服务器计算） 孔数(默认0):-1随机0孔1孔2孔3孔4孔
}

--红装锦囊未开出红装的最大保底次数（累计未抽到红装必定给一件红装）
hVar.NOTGAIN_REDEQUIP_MAX = 100

--红装卷轴可兑换红装列表
hVar.SCROLL_TO_EQUIP_POOL = 
{
	12202,	--炽魂战衣
	12203,	--玄冰魔衣
}


--=======================================================战术卡配置=======================================================
--战术技能卡的分类
hVar.TACTICS_TYPE =
{
	FIGHTER = 1,	--战士
	SHOOTER = 2,	--射手
	RIDER = 3,		--骑兵
	WIZARD = 4,		--法师
	LEGEND = 5,		--圣兽
	MACHINE = 6,	--机械
	OTHER = 7,		--一般战术卡
	TOWER = 8,		--塔
	SPECIAL = 9,	--特殊塔
	ARMY = 10,		--PVP兵种卡
}

--战术技能卡升级消耗
hVar.TACTIC_LVUP_INFO =
{
	--除了兵种卡外的等级上限
	maxTacticLv = 30,
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升级下一级需要消耗的碎片数}
	[0] =	{shopItemId = 201,		toDebris = 0,		costDebris = 0},
	[1] =	{shopItemId = 202,		toDebris = 0,		costDebris = 10},
	[2] =	{shopItemId = 203,		toDebris = 30,		costDebris = 20},
	[3] =	{shopItemId = 204,		toDebris = 60,		costDebris = 30},
	[4] =	{shopItemId = 205,		toDebris = 110,		costDebris = 50},
	[5] =	{shopItemId = 206,		toDebris = 180,		costDebris = 70},
	[6] =	{shopItemId = 207,		toDebris = 270,		costDebris = 90},
	[7] =	{shopItemId = 208,		toDebris = 380,		costDebris = 110},
	[8] =	{shopItemId = 209,		toDebris = 510,		costDebris = 130},
	[9] =	{shopItemId = 210,		toDebris = 660,		costDebris = 150},
	[10] =	{shopItemId = 211,		toDebris = 830,		costDebris = 170},
	[11] =	{shopItemId = 212,		toDebris = 1020,	costDebris = 190},
	[12] =	{shopItemId = 213,		toDebris = 1230,	costDebris = 210},
	[13] =	{shopItemId = 214,		toDebris = 1460,	costDebris = 230},
	[14] =	{shopItemId = 215,		toDebris = 1720,	costDebris = 260},
	[15] =	{shopItemId = 216,		toDebris = 2010,	costDebris = 290},
	[16] =	{shopItemId = 217,		toDebris = 2330,	costDebris = 320},
	[17] =	{shopItemId = 218,		toDebris = 2680,	costDebris = 350},
	[18] =	{shopItemId = 219,		toDebris = 3060,	costDebris = 380},
	[19] =	{shopItemId = 220,		toDebris = 3470,	costDebris = 410},
	[20] =	{shopItemId = 221,		toDebris = 3910,	costDebris = 440},
	[21] =	{shopItemId = 222,		toDebris = 4380,	costDebris = 470},
	[22] =	{shopItemId = 223,		toDebris = 4880,	costDebris = 500},
	[23] =	{shopItemId = 224,		toDebris = 5410,	costDebris = 530},
	[24] =	{shopItemId = 225,		toDebris = 5980,	costDebris = 570},
	[25] =	{shopItemId = 226,		toDebris = 6600,	costDebris = 620},
	[26] =	{shopItemId = 227,		toDebris = 7300,	costDebris = 700},
	[27] =	{shopItemId = 228,		toDebris = 8100,	costDebris = 800},
	[28] =	{shopItemId = 229,		toDebris = 9000,	costDebris = 900},
	[29] =	{shopItemId = 230,		toDebris = 10000,	costDebris = 1000},
	[30] =	{shopItemId = nil,		toDebris = 0,		costDebris = nil},
	
	--兵种卡的等级上限（升级信息在兵种卡tab中配置）
	maxArmyLv = 1,
	--兵种卡升级所需材料种类上限
	maxMaterialType = 3,
}

--=======================================================VIP配置=======================================================
--vip配置 zhenkira
hVar.Vip_Conifg =
{
	maxVipLv = 5,		--当前开放vip最大等级
	condition = {		--达成vip所需条件
		rmb = {
			[0] = 0,
			[1] = 10,
			[2] = 50,
			[3] = 100,
			[4] = 200,
			[5] = 500,
			[6] = 1000,
			[7] = 2000,
			[8] = 4000,
		},
		coin = {--充值多少金币变vip
			[0] = 0,
			[1] = 100,
			[2] = 500,
			[3] = 1000,
			[4] = 2000,
			[5] = 5000,
			[6] = 10000,
			[7] = 20000,
			[8] = 40000,
		},
	},
	
	--每日领取
	dailyReward = {
		[0] = nil,
		[1] = {
			--每日奖励1
			[1] = {
				{114,3}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,5}, --武器枪宝箱
				{11,10}, --锻造材料
			},
		},
		[2] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[3] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[4] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[5] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[6] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[7] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[8] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
	},
	
	--一次性奖励
	oneoffReward = {
		[0] = nil,
		[1] = nil,
		[2] = nil,
		[3] = {
			{6,15211,2000,1,},		--类型，数量，等级
		},
		[4] = {
			{6,15213,2000,1,},		--类型，数量，等级
		},
		[5] = {
			{101,15013,380,1,},		--类型，数量，等级
		},
		[6] = {
			{4,18022,2,1,},		--类型,英雄ID，星级，等级 (小乔2星)
		},
		[7] = {
			{12,2,0,0,},		--红装兑换券
			{22,10824,260,0,},		--宝物碎片
		},
		[8] = {
			{4,18037,1,1,},		--类型,英雄ID，星级，等级 (大乔1星)
		},
	},
	
	--vip7以上额外奖励，每充2000rmb，得奖励
	vip7ExtraReward = {
		rmb = 2000,				--每充n游戏币
		reward = {				--获得奖励, 红装兑换券
			{12,1,0,0,},
		},
	},
	
	--背包容量
	bagPageNum = {
		[0] = 5,
		[1] = 6,
		[2] = 7,
		[3] = 8,
		[4] = 9,
		[5] = 10,
		[6] = 11,
		[7] = 12,
		[8] = 13,
	},
	
	--免费刷新碎片商店次数
	netshopRefreshCount = {
		[0] = 0,
		[1] = 6,
		[2] = 7,
		[3] = 8,
		[4] = 9,
		[5] = 10,
		[6] = 10,
		[7] = 10,
		[8] = 10,
	},
	
	--锁孔洗练限制次数
	xilianLockCount = {
		[0] = -1, --50,
		[1] = -1, --50,
		[2] = -1, --50,
		[3] = -1,
		[4] = -1,
		[5] = -1,
		[6] = -1,
		[7] = -1,
		[8] = -1,
	},
	
	--开启竞技场锦囊是否不需要等待直接开
	openChestFree = {
		[0] = false,
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
		[5] = false,
		[6] = true,
		[7] = true,
		[8] = true,
	},
	
	--游戏内加速倍率
	playSpeed = {
		[0] = 2,
		[1] = 2,
		[2] = 3,
		[3] = 3,
		[4] = 3,
		[5] = 3,
		[6] = 3,
		[7] = 3,
		[8] = 3,
	},
	
	--世界聊天每日最大次数(-1表示无限制)
	chatWorldMsgNum = {
		[0] = -1, --10,
		[1] = -1, --20,
		[2] = -1, --30,
		[3] = -1,
		[4] = -1,
		[5] = -1,
		[6] = -1,
		[7] = -1,
		[8] = -1,
	},
	
	--创建军团权限
	createGroup = {
		[0] = false,
		[1] = false,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
	},
	
	--军团兑换碎片每日次数
	groupExchageDebrisCount = {
		[0] = 1,
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4,
		[5] = 5,
		[6] = 6,
		[7] = 7,
		[8] = 8,
	},
	
	--军团发红包每日次数
	groupSendRedpacketCount = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 1,
		[4] = 2,
		[5] = 3,
		[6] = 4,
		[7] = 5,
		[8] = 6,
	},
	
	--每日可扫荡次数
	dailySaoDangCount = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 10,
		[4] = 15,
		[5] = 20,
		[6] = 25,
		[7] = 30,
		[8] = 35,
	},
	
	--宠物可派遣数量
	petSendMaxCount = {
		[0] = 2,
		[1] = 2,
		[2] = 2,
		[3] = 2,
		[4] = 3,
		[5] = 4,
		[6] = 4,
		[7] = 4,
		[8] = 4,
	},
	
	--每日体力上限
	tiliDailyMax = {
		[0] = 60,
		[1] = 70,
		[2] = 80,
		[3] = 90,
		[4] = 100,
		[5] = 110,
		[6] = 120,
		[7] = 130,
		[8] = 140,
	},
	
	--每日体力补给
	tiliDailySupply = {
		[0] = 60,
		[1] = 70,
		[2] = 80,
		[3] = 90,
		[4] = 100,
		[5] = 110,
		[6] = 120,
		[7] = 130,
		[8] = 140,
	},
	
	--每日体力购买次数上限
	tiliDailyBuyCount = {
		[0] = 2,
		[1] = 3,
		[2] = 4,
		[3] = 5,
		[4] = 6,
		[5] = 7,
		[6] = 8,
		[7] = 9,
		[8] = 10,
	},
	
	--战车经验额外加成
	tankExpAddRate = {
		[0] = 0,
		[1] = 0.1,
		[2] = 0.15,
		[3] = 0.2,
		[4] = 0.25,
		[5] = 0.3,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	},
	
	--vip地图内摆放的单位
	mapUnit = {
		[0] = 0,
		[1] = 40008,
		[2] = 40007,
		[3] = 40000,
		[4] = 40001,
		[5] = 40003,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	},
	
	--战斗开始雕像数量
	ironmanItemSkillNum = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 1,
		[6] = 1,
		[7] = 1,
		[8] = 1,
	},
}

--=======================================================其他配置=======================================================
--微信充值额外奖励
hVar.WX_TOPUP_EX_REWARD = 
{
	--塔防微信充值(6元)送50神器晶石
	[1] = "11:50:0:0",
	--塔防微信充值(18元)送100神器晶石
	[2] = "11:100:0:0",
	--塔防微信充值(30元)送150神器晶石(废弃)
	--[3] = "11:150:0:0",
	--塔防微信充值(68元)送200神器晶石
	[4] = "11:200:0:0",
	--塔防微信充值(98元)送350神器晶石
	[5] = "11:350:0:0",
	--塔防微信充值(198元)送600个献祭之石
	[6] = "11:600:0:0",
	--塔防微信充值(388元)送1个献祭之石
	[7] = "10:12406:0:0;",
}

--[[
--大菠萝，充值奖励
hVar.TANK_TOPUP_REWARD = 
{
	[1] = "s:2000;", --战车充值(6元)
	[2] = "s:10000;", --战车充值(18元)
	--[3] = "11:150:0:0", --战车充值(30元)
	[4] = "11:200:0:0", --战车充值(68)
	[5] = "11:350:0:0", --战车充值(98元)
	[6] = "11:600:0:0", --战车充值(198元)
	[7] = "10:12406:0:0;", --战车充值(388元)
}
]]

hVar.CAST_TYPE = {
	NONE = 0,
	MOVE = 1,
	IMMEDIATE = 2, --对自己生效（立即生效）
	SKILL_TO_GRID = 3,
	SKILL_TO_UNIT = 4, --对单位生效
	BUFF_TO_GRID = 5,
	BUFF_TO_UNIT = 6,
	SKILL_TO_GROUND = 7, --geyachao: TD对地面
	SKILL_TO_GROUND_BLOCK = 8, --geyachao: TD对地面有效的地方
	AUTO = 9,		--进入战场时会自动作用在自己身上一次
	SKILL_TO_GROUND_MOVE_TO_POINT = 10, --geyachao: TD移动到技能范围后，再对地面生效
	SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK = 11, --geyachao: TD移动到技能范围后，再对有效地面生效
}