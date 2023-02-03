hVar.tab_aura = {}
local _tab_aura = hVar.tab_aura

--战车属性类（黄卡）
_tab_aura[1000] = {
	showmodel = "ICON:SKILL_SET01_04",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25000,---手雷暴击
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_CRIT,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1001] = {
	showmodel = "ICON:SKILL_SET01_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25001,---手雷火焰+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_FIRE,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1002] = {
	showmodel = "ICON:SKILL_SET01_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25002,--子母雷+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_CHILD,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1003] = {
	showmodel = "ICON:SKILL_SET02_01",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25003,--普通防御+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_PHYSICAL,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1004] = {
	showmodel = "ICON:SKILL_SET02_04",
	skill = 25004,--动力+10
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	--bufftype = hVar.AuraBuffType.DEF_BOMB,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1005] = {
	showmodel = "ICON:SKILL_SET02_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25005,--电光防御+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_THUNDER,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1006] = {
	showmodel = "ICON:SKILL_SET02_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25006,--火焰防御+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_FIRE,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1007] = {
	showmodel = "ICON:SKILL_SET02_06",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25007,--毒防御+1
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_POISON,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1008] = {
	showmodel = "ICON:IRONBUFF_SET03_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25041,---宠物回血
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1009] = {
	showmodel = "ICON:SKILL_SET01_02",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25010,---双雷
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_NUM,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[1010] = {
	showmodel = "effect/lvup_attack.png",
	skill = 25011,---枪升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1011] = {
	showmodel = "ICON:SKILL_SET01_01",
	skill = 25047,---手雷杀伤+10
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1012] = {
	showmodel = "ICON:SKILL_SET02_02",
	skill = 25048,---轮刀+200
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1013] = {
	showmodel = "ICON:SKILL_SET03_03",
	skill = 25049,---迷惑几率+1%
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1014] = {
	showmodel = "ICON:IRONBUFF_SET02_08",
	skill = 25056,---手雷距离+50
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}






--战术卡类（白卡）
_tab_aura[1100] = {
	showmodel = "effect/buff_n6.png",
	skill = 25100,--十字火
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1101] = {
	showmodel = "effect/buff_n11.png",
	skill = 25101,--弹射球
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1102] = {
	showmodel = "effect/buff_n4.png",
	skill = 25102,--追踪弹
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1103] = {
	showmodel = "effect/buff_n9.png",
	skill = 25103,--延时炸弹
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1104] = {
	showmodel = "effect/buff_n5.png",
	skill = 25104,--护盾
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1105] = {
	showmodel = "effect/buff_n10.png",
	skill = 25105,--冰冻
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1106] = {
	showmodel = "effect/buff_n7.png",
	skill = 25106,--卫星炮
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1107] = {
	showmodel = "effect/buff_n2.png",
	skill = 25107,--机枪台
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1108] = {
	showmodel = "effect/buff_n3.png",
	skill = 25108,--导弹塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1109] = {
	showmodel = "effect/buff_n12.png",
	skill = 25109,--黑洞
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1110] = {
	showmodel = "effect/buff_n1.png",
	skill = 25110,--核爆
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1111] = {
	showmodel = "effect/buff_n13.png",
	skill = 25111,--巨浪
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

_tab_aura[1112] = {
	showmodel = "effect/buff_n8.png",
	skill = 25112,--缩小
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
}

--战术卡类（紫卡）
_tab_aura[1120] = {
	showmodel = "effect/buff_n6.png",
	skill = 25120,--十字火
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1121] = {
	showmodel = "effect/buff_n11.png",
	skill = 25121,--弹射球
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1122] = {
	showmodel = "effect/buff_n4.png",
	skill = 25122,--追踪弹
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1123] = {
	showmodel = "effect/buff_n9.png",
	skill = 25123,--延时炸弹
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1124] = {
	showmodel = "effect/buff_n5.png",
	skill = 25124,--护盾
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1125] = {
	showmodel = "effect/buff_n10.png",
	skill = 25125,--冰冻
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1126] = {
	showmodel = "effect/buff_n7.png",
	skill = 25126,--卫星炮
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1127] = {
	showmodel = "effect/buff_n2.png",
	skill = 25127,--机枪台
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1128] = {
	showmodel = "effect/buff_n3.png",
	skill = 25128,--导弹塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1129] = {
	showmodel = "effect/buff_n12.png",
	skill = 25129,--黑洞
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1130] = {
	showmodel = "effect/buff_n1.png",
	skill = 25130,--核爆
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1131] = {
	showmodel = "effect/buff_n13.png",
	skill = 25131,--巨浪
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}

_tab_aura[1132] = {
	showmodel = "effect/buff_n8.png",
	skill = 25132,--缩小
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
	crystal = 3000, --需要的水晶
}




--召唤类（黄卡）
_tab_aura[1200] = {
	showmodel = "icon/hero/pet_01.png",
	skill = 25200,--瓦力
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1201] = {
	showmodel = "icon/hero/pet_02.png",
	skill = 25201,--刺蛇
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1202] = {
	showmodel = "icon/hero/pet_03.png",
	skill = 25202,--飞机
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[1203] = {
	showmodel = "icon/hero/pet_04.png",
	skill = 25203,--尤达
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}


----塔防地图

_tab_aura[2000] = {
	showmodel = "misc/skillup/mu_coin_world_l.png",
	skill = 26000,--500水晶
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2001] = {
	showmodel = "effect/buff_n14.png",
	skill = 26001,--陷阱
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2002] = {
	showmodel = "ICON:IRONBUFF_SET01_06",
	skill = 26002,--精炼厂回血25%
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2003] = {
	showmodel = "effect/buff_n17.png",
	skill = 26004,--短时间塔攻速翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2100] = {
	showmodel = "icon/item/towergun_1.png",
	skill = 26100,--机枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 200, --需要的水晶
}

_tab_aura[2101] = {
	showmodel = "icon/item/towergun_2.png",
	skill = 26101,--散弹枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 300, --需要的水晶
}

_tab_aura[2102] = {
	showmodel = "icon/item/towergun_3.png",
	skill = 26102,--喷火枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 600, --需要的水晶
}

_tab_aura[2103] = {
	showmodel = "icon/item/towergun_4.png",
	skill = 26103,--透射枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 600, --需要的水晶
}

_tab_aura[2104] = {
	showmodel = "icon/item/towergun_5.png",
	skill = 26104,--雷神之锤塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 700, --需要的水晶
}

_tab_aura[2105] = {
	showmodel = "icon/item/towergun_6.png",
	skill = 26105,--冲击波塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 800, --需要的水晶
}

_tab_aura[2106] = {
	showmodel = "icon/item/towergun_7.png",
	skill = 26106,--毒液枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 600, --需要的水晶
}

_tab_aura[2107] = {
	showmodel = "icon/item/tower_container.png",
	skill = 26107,--障碍塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 100, --需要的水晶
}

_tab_aura[2108] = {
	showmodel = "icon/item/towergun_8.png",
	skill = 26108,--反弹光线塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 400, --需要的水晶
}

_tab_aura[2109] = {
	showmodel = "icon/item/towergun_9.png",
	skill = 26109,--反弹光球塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 400, --需要的水晶
}

_tab_aura[2110] = {
	showmodel = "icon/item/towergun_10.png",
	skill = 26110,--缩小枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 1000, --需要的水晶
}

_tab_aura[2111] = {
	showmodel = "icon/item/tower_01.png",
	skill = 26111,--巨塔-高射塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
	crystal = 2000, --需要的水晶
}

_tab_aura[2112] = {
	showmodel = "icon/item/tower_02.png",
	skill = 26112,--巨塔-激光塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
	crystal = 2000, --需要的水晶
}

_tab_aura[2113] = {
	showmodel = "icon/item/tower_03.png",
	skill = 26113,--巨塔-机枪塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
	crystal = 2000, --需要的水晶
}

_tab_aura[2114] = {
	showmodel = "icon/item/tower_04.png",
	skill = 26114,--巨塔-炮台塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
	crystal = 2000, --需要的水晶
}

_tab_aura[2115] = {
	showmodel = "icon/item/tower_05.png",
	skill = 26115,--巨塔-射击塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
	crystal = 2000, --需要的水晶
}

_tab_aura[2116] = {
	showmodel = "icon/item/tower_bunker.png",
	skill = 26116,--兵营塔
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 1000, --需要的水晶
}


_tab_aura[2200] = {
	showmodel = "icon/item/towergun_1.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25300,---机枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2201] = {
	showmodel = "icon/item/towergun_2.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25301,---散弹枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2202] = {
	showmodel = "icon/item/towergun_3.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25302,---喷火枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2203] = {
	showmodel = "icon/item/towergun_4.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25303,---透射枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2204] = {
	showmodel = "icon/item/towergun_5.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25304,---雷神之锤塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2205] = {
	showmodel = "icon/item/towergun_6.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25305,---冲击波塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2206] = {
	showmodel = "icon/item/towergun_7.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25306,---毒枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2207] = {
	showmodel = "icon/item/towergun_8.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25307,---反弹光线塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2208] = {
	showmodel = "icon/item/towergun_9.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25308,---反弹光球塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}

_tab_aura[2209] = {
	showmodel = "icon/item/towergun_10.png",
	showicon = "misc/tactics/tac14.png",
	skill = 25309,---缩小枪塔升级
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
}



----红卡类
_tab_aura[3000] = {
	showmodel = "ICON:SKILL_SET02_01",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25012,--普通防御+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_PHYSICAL,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3001] = {
	showmodel = "ICON:SKILL_SET02_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25013,--电光防御+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_THUNDER,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3002] = {
	showmodel = "ICON:SKILL_SET02_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25014,--火焰防御+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_FIRE,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3003] = {
	showmodel = "ICON:SKILL_SET02_06",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25015,--毒防御+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.DEF_POISON,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3004] = {
	showmodel = "ICON:SKILL_SET01_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25017,---手雷火焰+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_FIRE,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3005] = {
	showmodel = "ICON:SKILL_SET01_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25018,--子母雷+2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_CHILD,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3006] = {
	showmodel = "ICON:SKILL_SET03_04",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25028,--陷阱时间翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3007] = {
	showmodel = "ICON:SKILL_SET03_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25030,--天网时间翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3008] = {
	showmodel = "ICON:IRONBUFF_SET02_01",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25032,--死亡引爆
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3009] = {
	showmodel = "ICON:IRONBUFF_SET02_03",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25039,--迷惑范围翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_CHILD,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}

_tab_aura[3010] = {
	showmodel = "ICON:IRONBUFF_SET03_06",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25043,---宠物克隆
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.RED, --红卡
}



---紫卡类
_tab_aura[4000] = {
	showmodel = "ICON:SKILL_SET01_04",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25016,---手雷暴击+20%
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	bufftype = hVar.AuraBuffType.GRENADE_CRIT,
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4001] = {
	showmodel = "ICON:SKILL_SET01_03",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25019,---手雷冷却最小
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4002] = {
	showmodel = "ICON:IRONBUFF_SET04_07",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25020,---手雷十字火
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4003] = {
	showmodel = "ICON:IRONBUFF_SET01_02",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25022,---手雷导弹
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4004] = {
	showmodel = "ICON:IRONBUFF_SET02_06",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25024,---手雷旋涡
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4005] = {
	showmodel = "ICON:SKILL_SET01_06",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25026,--惯性翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4006] = {
	showmodel = "ICON:SKILL_SET04_01",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25008,---最大生命翻倍
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

--生命+1
_tab_aura[4007] = {
	showmodel = "ICON:IRONBUFF_SET01_05",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25035,--增加一条命
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

--火焰免伤
_tab_aura[4008] = {
	showmodel = "ICON:IRONBUFF_SET04_02",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25036,---火焰免伤
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4009] = {
	showmodel = "ICON:SKILL_SET03_03",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25038,--迷惑+6
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.POSITIVE, --被动添加技能
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}

_tab_aura[4010] = {
	showmodel = "ICON:IRONBUFF_SET04_04",
	showicon = "misc/skillup/btnicon_upgrade.png",
	skill = 25045,---宠物复活
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.PURPLE, --紫卡
}


--兵营类

--yxys_yoda_02发兵
_tab_aura[5000] = {
	showmodel = "icon/hero/soldier_01.png",
	skill = 25500,--克隆机枪士兵
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
	crystal = 400, --需要的水晶
}

_tab_aura[5001] = {
	showmodel = "icon/hero/soldier_02.png",
	skill = 25501,--克隆打拳士兵
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 300, --需要的水晶
}

_tab_aura[5002] = {
	showmodel = "icon/hero/soldier_03.png",
	skill = 25502,--克隆爆破士兵
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 600, --需要的水晶
}

_tab_aura[5003] = {
	showmodel = "icon/hero/truck.png",
	skill = 25503,--矿车
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 200, --需要的水晶
}

_tab_aura[5004] = {
	showmodel = "icon/hero/soldier_02.png",
	skill = 25504,--克隆打拳士兵路线2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 300, --需要的水晶
}

_tab_aura[5005] = {
	showmodel = "icon/hero/soldier_03.png",
	skill = 25505,--克隆爆破士兵路线2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 600, --需要的水晶
}

_tab_aura[5006] = {
	showmodel = "icon/hero/truck.png",
	skill = 25506,--矿车路线2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.YELLOW, --黄卡
	crystal = 200, --需要的水晶
}

_tab_aura[5007] = {
	showmodel = "icon/hero/soldier_01.png",
	skill = 25507,--克隆机枪士兵路线2
	skillAttrbuteType = hVar.AI_ATTRIBUTE_TYPE.ACTIVE, --主动释放类
	quality = hVar.ENDLESS_TACTICCARD_COLOR.WHITE, --白卡
	crystal = 400, --需要的水晶
}



--光环池子定义
hVar.AuraPoolDefine = {
	[1] = {---------白卡
		{1010,1},
		{1100,2},
		{1101,2},
		{1102,2},
		{1103,2},
		{1104,2},
		{1105,2},
		{1106,2},
		{1107,2},
		{1108,2},
		{1109,2},
		{1110,2},
		{1111,2},
		{1112,2},
	},
	[2] = {---------黄卡
		{1000,1},
		{1001,1},
		{1002,1},
		{1003,1},
		{1005,1},
		{1006,1},
		{1007,1},
		{1009,1},
		--{1004,1},
		--{1008,1},
	},
	[3] = {---------红卡
		{3000,1},
		{3001,1},
		{3002,1},
		{3003,1},
		{3004,1},
		{3005,1},
		{3006,1},
		{3007,1},
		{3008,1},
	},
	[4] = {---------紫卡
		{4000,1},
		{4001,1},
		{4002,1},
		{4003,1},
		{4004,1},
		{4005,1},
		{4006,1},
	},
	[5] = {---------塔防图:车属性
		{1000,1},
		{1001,1},
		{1002,1},
		--{1008,1},
		{1009,1},
		{1010,1},
		{2000,1},
		{2001,1},
	},
	[6] = {---------塔防图:道具卡
		{1100,1},
		{1101,1},
		{1102,1},
		{1103,1},
		{1104,1},
		{1105,1},
		{1106,1},
		{1107,1},
		{1108,1},
		{1109,1},
		{1110,1},
		{1111,1},
		{1112,1},
	},
	[7] = {---------塔防图:枪塔
		{2100,1,},
		{2101,1,},
		{2102,1,},
		{2103,1,},
		{2104,1,},
		{2105,1,},
		{2106,1,},
		{2108,1,},
		{2109,1,},
		{2116,1,},
	},
	[8] = {---------塔防图:塔强化
		{2200,1},
		{2201,1},
		{2202,1},
	},
	[9] = {---------抢滩图:枪塔
		{2100,1,},
		{2101,1,},
		{2102,1,},
		{2103,1,},
		{2104,1,},
		{2105,1,},
		{2106,1,},
		{2107,1,},
		{2108,1,},
		{2109,1,},
		{2116,1,},
	},
	[10] = {---------宠物
		{1200,1},
		{1201,1},
		{1202,1},
		{1203,1},
	},
	[11] = {---------巨塔
		{2111,1,},
		{2112,1,},
		{2113,1,},
		{2114,1,},
		{2115,1,},
	},
	[12] = {---------兵营
		{5000,1},
		--{5001,1},
		{5002,1},
		{5003,1},
		{2100,1,},
	},
	[13] = {---------兵营2
		--{5004,1},
		{5005,1},
		{5006,1},
		{5007,1},
		{2100,1,},
	},
}

--光环随即组定义
hVar.AuraRandGroupDefine = {
	[1] = {
		[1] = {
			pool = {{1,3}},
			weights = 40,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[2] = {
			pool = {{2,3}},
			weights = 15,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[3] = {
			pool = {{3,3}},
			weights = 20,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[4] = {
			pool = {{4,3}},
			weights = 10,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[5] = {
			pool = {{2,2},{10,1}},
			weights = 15,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		--[5] = {
			--pool = {{1,1},{2,1},{3,1}},	--池子1号1个 2号1个 3号1个
			--weights = 5,			--权重5
			--norepeat = 1,		--技能id不重复(不考虑等级)
		--},
	},
	[2] = {
		[1] = {
			pool = {{5,2},{6,1}},
			weights = 40,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[2] = {
			pool = {{5,1},{6,2}},
			weights = 40,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
		[3] = {
			pool = {{5,1},{6,1},{8,1},},
			weights = 20,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
	},
	[3] = {
		[1] = {
			pool = {{7,3},{11,1}},
			weights = 100,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
	},
	[4] = {
		[1] = {
			pool = {{9,3},{11,1}},
			weights = 100,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
	},
	[5] = {
		[1] = {
			pool = {{12,4}},
			weights = 100,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
	},
	[6] = {
		[1] = {
			pool = {{13,4}},
			weights = 100,
			norepeat = 1,		--技能id不重复(不考虑等级)
		},
	},
}

--如果用旧的抽卡界面，就在这里面定义池子
hVar.UnitAuraGroupDefine = {
	--[17002] = 2,
	[17019] = 3, --母巢之战的选塔
	--[17204] = 2,
	[17205] = 4, --前哨阵地的选塔
	[12232] = 5, --yxys_yoda_02兵营
	[12245] = 6, --yxys_yoda_02兵营2
}



------------------------------------------------------------------------------------------------------------------------
--雕像单位抽卡卡池（新）
hVar.UnitAuraGroupDefine_New = {}

--3选1铁人（随机迷宫）
hVar.UnitAuraGroupDefine_New[5171] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
		{id = 1010, lv = 1, maxcount = 999,},--武器等级+2
		{id = 1100, lv = 2, maxcount = 999,},
		{id = 1101, lv = 2, maxcount = 999,},
		{id = 1102, lv = 2, maxcount = 999,},
		{id = 1103, lv = 2, maxcount = 999,},
		{id = 1104, lv = 2, maxcount = 999,},
		{id = 1105, lv = 2, maxcount = 999,},
		{id = 1106, lv = 2, maxcount = 999,},
		{id = 1107, lv = 2, maxcount = 999,},
		{id = 1108, lv = 2, maxcount = 999,},
		{id = 1109, lv = 2, maxcount = 999,},
		{id = 1110, lv = 2, maxcount = 999,},
		{id = 1111, lv = 2, maxcount = 999,},
		{id = 1112, lv = 2, maxcount = 999,},
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 1000, lv = 1, maxcount = 999,},--手雷暴击+5%
		{id = 1001, lv = 1, maxcount = 999,},--手雷燃烧+1
		{id = 1002, lv = 1, maxcount = 999,},--子母雷+1
		{id = 1003, lv = 1, maxcount = 999,},--装甲+5
		{id = 1004, lv = 1, maxcount = 999,},--动力+10
		{id = 1005, lv = 1, maxcount = 999,},--防电+5
		{id = 1006, lv = 1, maxcount = 999,},--防火+5
		{id = 1007, lv = 1, maxcount = 999,},--防毒+5
		{id = 1008, lv = 1, maxcount = 999,},--治疗所有宠物
		{id = 1011, lv = 1, maxcount = 999,},--手雷杀伤+10
		{id = 1012, lv = 1, maxcount = 999,},--轮刀+200
		{id = 1013, lv = 1, maxcount = 999,},--迷惑几率+1%
		{id = 1014, lv = 1, maxcount = 999,},--手雷距离+50
		{id = 1200, lv = 1, maxcount = 999,},--召唤瓦力
		{id = 1201, lv = 1, maxcount = 999,},--召唤刺蛇
		{id = 1202, lv = 1, maxcount = 999,},--召唤钛战机
		{id = 1203, lv = 1, maxcount = 999,},--召唤尤达
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
		{id = 1009, lv = 1, maxcount = 1,},--双雷
		{id = 3000, lv = 1, maxcount = 999,},--装甲+10
		{id = 3001, lv = 1, maxcount = 999,},--防电+10
		{id = 3002, lv = 1, maxcount = 999,},--防火+10
		{id = 3003, lv = 1, maxcount = 999,},--防毒+10
		{id = 3004, lv = 1, maxcount = 3,},--手雷燃烧+2
		{id = 3005, lv = 1, maxcount = 3,},--子母雷+2
		{id = 3006, lv = 1, maxcount = 1,},--陷阱时间翻倍
		{id = 3007, lv = 1, maxcount = 1,},--天网时间翻倍
		{id = 3008, lv = 1, maxcount = 999,},--战车死亡后自爆
		{id = 3009, lv = 1, maxcount = 1,},--迷惑范围翻倍
		{id = 3010, lv = 1, maxcount = 1,},--克隆当前所有宠物
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
		{id = 4000, lv = 1, maxcount = 5,},--手雷暴击+20%
		{id = 4001, lv = 1, maxcount = 1,},--手雷冷却-1000
		{id = 4002, lv = 1, maxcount = 1,},--手雷爆炸后产生十字火焰
		{id = 4003, lv = 1, maxcount = 1,},--手雷爆炸后产生飞弹
		{id = 4004, lv = 1, maxcount = 1,},--手雷爆炸后产生旋涡
		{id = 4005, lv = 1, maxcount = 1,},--手雷惯性翻倍
		{id = 4006, lv = 1, maxcount = 1,},--战车最大生命翻倍
		{id = 4007, lv = 1, maxcount = 999,},--复活次数+1
		{id = 4008, lv = 1, maxcount = 1,},--火焰免伤
		{id = 4009, lv = 1, maxcount = 1,},--迷惑+6
		{id = 4010, lv = 1, maxcount = 999,},--宠物复活次数+1
	},
}

--3选1铁人（塔防图）
hVar.UnitAuraGroupDefine_New[17002] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
		{id = 1010, lv = 1, maxcount = 999,},
		{id = 1100, lv = 2, maxcount = 999,},
		{id = 1101, lv = 2, maxcount = 999,},
		{id = 1102, lv = 2, maxcount = 999,},
		{id = 1103, lv = 2, maxcount = 999,},
		{id = 1104, lv = 2, maxcount = 999,},
		{id = 1105, lv = 2, maxcount = 999,},
		{id = 1106, lv = 2, maxcount = 999,},
		{id = 1107, lv = 2, maxcount = 999,},
		{id = 1108, lv = 2, maxcount = 999,},
		{id = 1109, lv = 2, maxcount = 999,},
		{id = 1110, lv = 2, maxcount = 999,},
		{id = 1111, lv = 2, maxcount = 999,},
		{id = 1112, lv = 2, maxcount = 999,},
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 2000, lv = 1, maxcount = 999,},--水晶+500
		{id = 2001, lv = 1, maxcount = 999,},--超级天网陷阱
		{id = 2002, lv = 1, maxcount = 999,},--建筑回血25%
		{id = 2003, lv = 1, maxcount = 999,},--枪塔攻速翻倍
		{id = 2200, lv = 1, maxcount = 999,},--机枪塔升级
		{id = 2201, lv = 1, maxcount = 999,},--散弹枪塔升级
		{id = 2202, lv = 1, maxcount = 999,},--喷火枪塔升级
		{id = 2203, lv = 1, maxcount = 999,},--透射枪塔升级
		{id = 2204, lv = 1, maxcount = 999,},--雷神之锤塔升级
		{id = 2205, lv = 1, maxcount = 999,},--冲击波塔升级
		{id = 2206, lv = 1, maxcount = 999,},--毒液枪塔升级
		{id = 2207, lv = 1, maxcount = 999,},--反弹光线塔升级
		{id = 2208, lv = 1, maxcount = 999,},--反弹光球塔升级
		--{id = 2209, lv = 1, maxcount = 999,},--缩小枪塔升级
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
		{id = 3000, lv = 1, maxcount = 999,},--装甲+10
		{id = 3001, lv = 1, maxcount = 999,},--防电+10
		{id = 3002, lv = 1, maxcount = 999,},--防火+10
		{id = 3003, lv = 1, maxcount = 999,},--防毒+10
		{id = 3004, lv = 1, maxcount = 3,},--手雷燃烧+2
		{id = 3005, lv = 1, maxcount = 3,},--子母雷+2
		{id = 3006, lv = 1, maxcount = 1,},--陷阱时间翻倍
		{id = 3007, lv = 1, maxcount = 1,},--天网时间翻倍
		{id = 3008, lv = 1, maxcount = 999,},--战车死亡后自爆
		{id = 3009, lv = 1, maxcount = 1,},--迷惑范围翻倍
		{id = 3010, lv = 1, maxcount = 1,},--克隆当前所有宠物
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
		{id = 4000, lv = 1, maxcount = 5,},--手雷暴击+20%
		{id = 4001, lv = 1, maxcount = 1,},--手雷冷却-1000
		{id = 4002, lv = 1, maxcount = 1,},--手雷爆炸后产生十字火焰
		{id = 4003, lv = 1, maxcount = 1,},--手雷爆炸后产生飞弹
		{id = 4004, lv = 1, maxcount = 1,},--手雷爆炸后产生旋涡
		{id = 4005, lv = 1, maxcount = 1,},--手雷惯性翻倍
		{id = 4006, lv = 1, maxcount = 1,},--战车最大生命翻倍
		{id = 4007, lv = 1, maxcount = 999,},--复活次数+1
		{id = 4008, lv = 1, maxcount = 1,},--火焰免伤
		{id = 4009, lv = 1, maxcount = 1,},--迷惑+6
		{id = 4010, lv = 1, maxcount = 999,},--宠物复活次数+1
	},
}

--科技中心
hVar.UnitAuraGroupDefine_New[17019] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 2100, lv = 1, maxcount = 999,},
		{id = 2101, lv = 1, maxcount = 999,},
		{id = 2102, lv = 1, maxcount = 999,},
		{id = 2103, lv = 1, maxcount = 999,},
		{id = 2104, lv = 1, maxcount = 999,},
		{id = 2105, lv = 1, maxcount = 999,},
		{id = 2106, lv = 1, maxcount = 999,},
		{id = 2108, lv = 1, maxcount = 999,},
		{id = 2109, lv = 1, maxcount = 999,},
		{id = 2110, lv = 1, maxcount = 999,},
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
	},
}

--3选1铁人（抢滩地图）
hVar.UnitAuraGroupDefine_New[17204] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
		{id = 1010, lv = 1, maxcount = 999,},--武器等级+2
		{id = 1100, lv = 2, maxcount = 999,},
		{id = 1101, lv = 2, maxcount = 999,},
		{id = 1102, lv = 2, maxcount = 999,},
		{id = 1103, lv = 2, maxcount = 999,},
		{id = 1104, lv = 2, maxcount = 999,},
		{id = 1105, lv = 2, maxcount = 999,},
		{id = 1106, lv = 2, maxcount = 999,},
		{id = 1107, lv = 2, maxcount = 999,},
		{id = 1108, lv = 2, maxcount = 999,},
		{id = 1109, lv = 2, maxcount = 999,},
		{id = 1110, lv = 2, maxcount = 999,},
		{id = 1111, lv = 2, maxcount = 999,},
		{id = 1112, lv = 2, maxcount = 999,},
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 2000, lv = 1, maxcount = 999,},--水晶+500
		{id = 2001, lv = 1, maxcount = 999,},--超级天网陷阱
		{id = 2002, lv = 1, maxcount = 999,},--建筑回血25%
		{id = 2003, lv = 1, maxcount = 999,},--枪塔攻速翻倍
		{id = 2200, lv = 1, maxcount = 999,},--机枪塔升级
		{id = 2201, lv = 1, maxcount = 999,},--散弹枪塔升级
		{id = 2202, lv = 1, maxcount = 999,},--喷火枪塔升级
		{id = 2203, lv = 1, maxcount = 999,},--透射枪塔升级
		{id = 2204, lv = 1, maxcount = 999,},--雷神之锤塔升级
		{id = 2205, lv = 1, maxcount = 999,},--冲击波塔升级
		{id = 2206, lv = 1, maxcount = 999,},--毒液枪塔升级
		{id = 2207, lv = 1, maxcount = 999,},--反弹光线塔升级
		{id = 2208, lv = 1, maxcount = 999,},--反弹光球塔升级
		--{id = 2209, lv = 1, maxcount = 999,},--缩小枪塔升级
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
		{id = 3000, lv = 1, maxcount = 999,},--装甲+10
		{id = 3001, lv = 1, maxcount = 999,},--防电+10
		{id = 3002, lv = 1, maxcount = 999,},--防火+10
		{id = 3003, lv = 1, maxcount = 999,},--防毒+10
		{id = 3004, lv = 1, maxcount = 3,},--手雷燃烧+2
		{id = 3005, lv = 1, maxcount = 3,},--子母雷+2
		{id = 3006, lv = 1, maxcount = 1,},--陷阱时间翻倍
		{id = 3007, lv = 1, maxcount = 1,},--天网时间翻倍
		{id = 3008, lv = 1, maxcount = 999,},--战车死亡后自爆
		{id = 3009, lv = 1, maxcount = 1,},--迷惑范围翻倍
		{id = 3010, lv = 1, maxcount = 1,},--克隆当前所有宠物
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
		{id = 4000, lv = 1, maxcount = 5,},--手雷暴击+20%
		{id = 4001, lv = 1, maxcount = 1,},--手雷冷却-1000
		{id = 4002, lv = 1, maxcount = 1,},--手雷爆炸后产生十字火焰
		{id = 4003, lv = 1, maxcount = 1,},--手雷爆炸后产生飞弹
		{id = 4004, lv = 1, maxcount = 1,},--手雷爆炸后产生旋涡
		{id = 4005, lv = 1, maxcount = 1,},--手雷惯性翻倍
		{id = 4006, lv = 1, maxcount = 1,},--战车最大生命翻倍
		{id = 4007, lv = 1, maxcount = 999,},--复活次数+1
		{id = 4008, lv = 1, maxcount = 1,},--火焰免伤
		{id = 4009, lv = 1, maxcount = 1,},--迷惑+6
		{id = 4010, lv = 1, maxcount = 999,},--宠物复活次数+1
	},
}

--科技中心（抢滩地图）
hVar.UnitAuraGroupDefine_New[17205] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 2100, lv = 1, maxcount = 999,},
		{id = 2101, lv = 1, maxcount = 999,},
		{id = 2102, lv = 1, maxcount = 999,},
		{id = 2103, lv = 1, maxcount = 999,},
		{id = 2104, lv = 1, maxcount = 999,},
		{id = 2105, lv = 1, maxcount = 999,},
		{id = 2106, lv = 1, maxcount = 999,},
		{id = 2107, lv = 1, maxcount = 999,},--【障碍塔】
		{id = 2108, lv = 1, maxcount = 999,},
		{id = 2109, lv = 1, maxcount = 999,},
		{id = 2110, lv = 1, maxcount = 999,},
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
	},
}

--水晶商店（随机迷宫）
hVar.UnitAuraGroupDefine_New[13006] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
		{id = 1120, lv = 1, maxcount = 999,},
		{id = 1121, lv = 1, maxcount = 999,},
		{id = 1122, lv = 1, maxcount = 999,},
		{id = 1123, lv = 1, maxcount = 999,},
		{id = 1124, lv = 1, maxcount = 999,},
		{id = 1125, lv = 1, maxcount = 999,},
		{id = 1126, lv = 1, maxcount = 999,},
		{id = 1127, lv = 1, maxcount = 999,},
		{id = 1128, lv = 1, maxcount = 999,},
		{id = 1129, lv = 1, maxcount = 999,},
		{id = 1130, lv = 1, maxcount = 999,},
		{id = 1131, lv = 1, maxcount = 999,},
		{id = 1132, lv = 1, maxcount = 999,},
	},
}

--3选1铁人（vip）
hVar.UnitAuraGroupDefine_New[13018] =
{
	--白卡
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE] =
	{
		{id = 1010, lv = 1, maxcount = 999,},--武器等级+2
		{id = 1100, lv = 2, maxcount = 999,},
		{id = 1101, lv = 2, maxcount = 999,},
		{id = 1102, lv = 2, maxcount = 999,},
		{id = 1103, lv = 2, maxcount = 999,},
		{id = 1104, lv = 2, maxcount = 999,},
		{id = 1105, lv = 2, maxcount = 999,},
		{id = 1106, lv = 2, maxcount = 999,},
		{id = 1107, lv = 2, maxcount = 999,},
		{id = 1108, lv = 2, maxcount = 999,},
		{id = 1109, lv = 2, maxcount = 999,},
		{id = 1110, lv = 2, maxcount = 999,},
		{id = 1111, lv = 2, maxcount = 999,},
		{id = 1112, lv = 2, maxcount = 999,},
	},
	
	--黄卡
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW] =
	{
		{id = 1000, lv = 1, maxcount = 999,},--手雷暴击+5%
		{id = 1001, lv = 1, maxcount = 999,},--手雷燃烧+1
		{id = 1002, lv = 1, maxcount = 999,},--子母雷+1
		{id = 1003, lv = 1, maxcount = 999,},--装甲+5
		{id = 1004, lv = 1, maxcount = 999,},--动力+10
		{id = 1005, lv = 1, maxcount = 999,},--防电+5
		{id = 1006, lv = 1, maxcount = 999,},--防火+5
		{id = 1007, lv = 1, maxcount = 999,},--防毒+5
		{id = 1008, lv = 1, maxcount = 999,},--治疗所有宠物
		{id = 1011, lv = 1, maxcount = 999,},--手雷杀伤+10
		{id = 1012, lv = 1, maxcount = 999,},--轮刀+200
		{id = 1013, lv = 1, maxcount = 999,},--迷惑几率+1%
		{id = 1014, lv = 1, maxcount = 999,},--手雷距离+50
		{id = 1200, lv = 1, maxcount = 999,},--召唤瓦力
		{id = 1201, lv = 1, maxcount = 999,},--召唤刺蛇
		{id = 1202, lv = 1, maxcount = 999,},--召唤钛战机
		{id = 1203, lv = 1, maxcount = 999,},--召唤尤达
	},
	
	--红卡
	[hVar.ENDLESS_TACTICCARD_COLOR.RED] =
	{
		{id = 1009, lv = 1, maxcount = 1,},--双雷
		{id = 3000, lv = 1, maxcount = 999,},--装甲+10
		{id = 3001, lv = 1, maxcount = 999,},--防电+10
		{id = 3002, lv = 1, maxcount = 999,},--防火+10
		{id = 3003, lv = 1, maxcount = 999,},--防毒+10
		{id = 3004, lv = 1, maxcount = 3,},--手雷燃烧+2
		{id = 3005, lv = 1, maxcount = 3,},--子母雷+2
		{id = 3006, lv = 1, maxcount = 1,},--陷阱时间翻倍
		{id = 3007, lv = 1, maxcount = 1,},--天网时间翻倍
		{id = 3008, lv = 1, maxcount = 999,},--战车死亡后自爆
		{id = 3009, lv = 1, maxcount = 1,},--迷惑范围翻倍
		{id = 3010, lv = 1, maxcount = 1,},--克隆当前所有宠物
	},
	
	--紫卡
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE] =
	{
		{id = 4000, lv = 1, maxcount = 5,},--手雷暴击+20%
		{id = 4001, lv = 1, maxcount = 1,},--手雷冷却-1000
		{id = 4002, lv = 1, maxcount = 1,},--手雷爆炸后产生十字火焰
		{id = 4003, lv = 1, maxcount = 1,},--手雷爆炸后产生飞弹
		{id = 4004, lv = 1, maxcount = 1,},--手雷爆炸后产生旋涡
		{id = 4005, lv = 1, maxcount = 1,},--手雷惯性翻倍
		{id = 4006, lv = 1, maxcount = 1,},--战车最大生命翻倍
		{id = 4007, lv = 1, maxcount = 999,},--复活次数+1
		{id = 4008, lv = 1, maxcount = 1,},--火焰免伤
		{id = 4009, lv = 1, maxcount = 1,},--迷惑+6
		{id = 4010, lv = 1, maxcount = 999,},--宠物复活次数+1
	},
}