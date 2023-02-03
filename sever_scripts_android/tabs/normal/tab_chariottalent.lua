--战车天赋
hVar.tab_chariottalent = {}
local _tab_chariottalent = hVar.tab_chariottalent

_tab_chariottalent[1] = {
	model = "misc/chariotconfig/crit.png",
	icon = "ICON:SKILL_SET01_04",
	talenttype = hVar.ChariotTalentType.BOMB,
	--tacticId = 3007, --手雷概率2次
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_crit", 2,},
		},
		[2] = {
			{"grenade_crit", 4,},
		},
		[3] = {
			{"grenade_crit", 6,},
		},
		[4] = {
			{"grenade_crit", 8,},
		},
		[5] = {
			{"grenade_crit", 10,},
		},
		[6] = {
			{"grenade_crit", 12,},
		},
	}
}

_tab_chariottalent[2] = {
	model = "misc/chariotconfig/burn.png",
	icon = "ICON:SKILL_SET01_07",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_fire", 1,},
		},
		[2] = {
			{"grenade_fire", 2,},
		},
		[3] = {
			{"grenade_fire", 3,},
		},
		[4] = {
			{"grenade_fire", 4,},
		},
		[5] = {
			{"grenade_fire", 5,},
		},
		[6] = {
			{"grenade_fire", 6,},
		},
	}
}

_tab_chariottalent[3] = {
	model = "misc/chariotconfig/doublegrenade.png",
	icon = "ICON:SKILL_SET01_05",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_child", 1,},
		},
		[2] = {
			{"grenade_child", 2,},
		},
		[3] = {
			{"grenade_child", 3,},
		},
		[4] = {
			{"grenade_child", 4,},
		},
		[5] = {
			{"grenade_child", 5,},
		},
		[6] = {
			{"grenade_child", 6,},
		},
	}
}

_tab_chariottalent[4] = {
	model = "misc/chariotconfig/damage.png",
	icon = "ICON:SKILL_SET01_01",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"atk", 10,},
		},
		[2] = {
			{"atk", 20,},
		},
		[3] = {
			{"atk", 30,},
		},
		[4] = {
			{"atk", 40,},
		},
		[5] = {
			{"atk", 50,},
		},
		[6] = {
			{"atk", 60,},
		},
	}
}

_tab_chariottalent[5] = {
	model = "misc/chariotconfig/shootrange.png",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_dis", 10,},
		},
		[2] = {
			{"grenade_dis", 20,},
		},
		[3] = {
			{"grenade_dis", 30,},
		},
		[4] = {
			{"grenade_dis", 40,},
		},
		[5] = {
			{"grenade_dis", 50,},
		},
		[6] = {
			{"grenade_dis", 60,},
		},
	}
}

_tab_chariottalent[6] = {
	model = "misc/chariotconfig/shootspeed.png",
	icon = "ICON:SKILL_SET01_03",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_cd", -100,},
		},
		[2] = {
			{"grenade_cd", -200,},
		},
		[3] = {
			{"grenade_cd", -300,},
		},
		[4] = {
			{"grenade_cd", -400,},
		},
		[5] = {
			{"grenade_cd", -500,},
		},
		[6] = {
			{"grenade_cd", -600,},
		},
	}
}

_tab_chariottalent[7] = {
	model = "misc/chariotconfig/inertia.png",
	icon = "ICON:SKILL_SET01_06",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 3, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 4,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"inertia", 15,},
		},
		[2] = {
			{"inertia", 30,},
		},
		[3] = {
			{"inertia", 50,},
		},
	}
}

_tab_chariottalent[8] = {
	model = "misc/chariotconfig/twogrenade.png",
	icon = "ICON:SKILL_SET01_02",
	talenttype = hVar.ChariotTalentType.BOMB,
	attrPointMaxLv = 1, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 12,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"grenade_multiply", 1,},
		},
	}
}


_tab_chariottalent[21] ={
	model = "misc/chariotconfig/armor.png",
	icon = "ICON:SKILL_SET02_01",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"def_physic", 10,},
		},
		[2] = {
			{"def_physic", 20,},
		},
		[3] = {
			{"def_physic", 30,},
		},
		[4] = {
			{"def_physic", 40,},
		},
		[5] = {
			{"def_physic", 50,},
		},
		[6] = {
			{"def_physic", 60,},
		},
	}
}

_tab_chariottalent[22] ={
	model = "misc/chariotconfig/fireproof.png",
	icon = "ICON:SKILL_SET02_05",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"def_fire", 10,},
		},
		[2] = {
			{"def_fire", 20,},
		},
		[3] = {
			{"def_fire", 30,},
		},
		[4] = {
			{"def_fire", 40,},
		},
		[5] = {
			{"def_fire", 50,},
		},
		[6] = {
			{"def_fire", 60,},
		},
	}
}

_tab_chariottalent[23] ={
	model = "misc/chariotconfig/preservative.png",
	icon = "ICON:SKILL_SET02_06",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"def_poison", 10,},
		},
		[2] = {
			{"def_poison", 20,},
		},
		[3] = {
			{"def_poison", 30,},
		},
		[4] = {
			{"def_poison", 40,},
		},
		[5] = {
			{"def_poison", 50,},
		},
		[6] = {
			{"def_poison", 60,},
		},
	}
}

_tab_chariottalent[24] ={
	model = "misc/chariotconfig/armor.png",
	icon = "ICON:SKILL_SET02_07",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"def_thunder", 10,},
		},
		[2] = {
			{"def_thunder", 20,},
		},
		[3] = {
			{"def_thunder", 30,},
		},
		[4] = {
			{"def_thunder", 40,},
		},
		[5] = {
			{"def_thunder", 50,},
		},
		[6] = {
			{"def_thunder", 60,},
		},
	}
}

_tab_chariottalent[25] ={
	model = "misc/chariotconfig/power.png",
	icon = "ICON:SKILL_SET02_04",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"move_speed", 10,},
		},
		[2] = {
			{"move_speed", 20,},
		},
		[3] = {
			{"move_speed", 30,},
		},
		[4] = {
			{"move_speed", 40,},
		},
		[5] = {
			{"move_speed", 50,},
		},
		[6] = {
			{"move_speed", 60,},
		},
	}
}

_tab_chariottalent[26] ={
	model = "misc/chariotconfig/shield.png",
	icon = "ICON:SKILL_SET02_03",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"melee_bounce", 10,},
		},
		[2] = {
			{"melee_bounce", 20,},
		},
		[3] = {
			{"melee_bounce", 30,},
		},
		[4] = {
			{"melee_bounce", 40,},
		},
		[5] = {
			{"melee_bounce", 50,},
		},
		[6] = {
			{"melee_bounce", 60,},
		},
	}
}

_tab_chariottalent[27] ={
	model = "misc/chariotconfig/shield.png",
	icon = "ICON:SKILL_SET02_02",
	talenttype = hVar.ChariotTalentType.SURVIVE,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"melee_fight", 200,},
		},
		[2] = {
			{"melee_fight", 400,},
		},
		[3] = {
			{"melee_fight", 600,},
		},
		[4] = {
			{"melee_fight", 800,},
		},
		[5] = {
			{"melee_fight", 1000,},
		},
		[6] = {
			{"melee_fight", 1200,},
		},
	}
}


_tab_chariottalent[41] ={
	model = "misc/chariotconfig/recharge.png",
	icon = "ICON:SKILL_SET03_01",
	talenttype = hVar.ChariotTalentType.HUNTER,
	attrPointMaxLv = 3, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 4,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"pet_capacity", 1,},
		},
		[2] = {
			{"pet_capacity", 2,},
		},
		[3] = {
			{"pet_capacity", 3,},
		},
	}
}

_tab_chariottalent[42] ={
	model = "misc/chariotconfig/damage.png",
	icon = "ICON:SKILL_SET03_02",
	talenttype = hVar.ChariotTalentType.HUNTER,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"pet_hp_restore", 30,},
		},
		[2] = {
			{"pet_hp_restore", 60,},
		},
		[3] = {
			{"pet_hp_restore", 90,},
		},
		[4] = {
			{"pet_hp_restore", 120,},
		},
		[5] = {
			{"pet_hp_restore", 150,},
		},
		[6] = {
			{"pet_hp_restore", 180,},
		},
	}
}

_tab_chariottalent[43] ={
	model = "misc/chariotconfig/damage.png",
	icon = "ICON:SKILL_SET03_03",
	talenttype = hVar.ChariotTalentType.HUNTER,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"puzzle", 1,},
		},
		[2] = {
			{"puzzle", 2,},
		},
		[3] = {
			{"puzzle", 3,},
		},
		[4] = {
			{"puzzle", 4,},
		},
		[5] = {
			{"puzzle", 5,},
		},
		[6] = {
			{"puzzle", 6,},
		},
	}
}

_tab_chariottalent[44] ={
	model = "misc/chariotconfig/communication.png",
	icon = "ICON:SKILL_SET03_04",
	talenttype = hVar.ChariotTalentType.HUNTER,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"trap_ground", 10000,},
		},
		[2] = {
			{"trap_ground", 10000,},
			{"trap_groundcd", -5000,},
		},
		[3] = {
			{"trap_ground", 10000,},
			{"trap_groundcd", -5000,},
			{"trap_groundenemy", 1500,},
		},
		[4] = {
			{"trap_ground", 20000,},
			{"trap_groundcd", -5000,},
			{"trap_groundenemy", 1500,},
		},
		[5] = {
			{"trap_ground", 20000,},
			{"trap_groundcd", -10000,},
			{"trap_groundenemy", 1500,},
		},
		[6] = {
			{"trap_ground", 20000,},
			{"trap_groundcd", -10000,},
			{"trap_groundenemy", 3000,},
		},
	}
}

_tab_chariottalent[45] ={
	model = "misc/chariotconfig/space.png",
	icon = "ICON:SKILL_SET03_05",
	talenttype = hVar.ChariotTalentType.HUNTER,
	attrPointMaxLv = 6, --天赋等级上限
	attrPointUpgrade = --天赋升级材料表
	{
		requireAttrPoint = 2,requireScore = 0, --需要的天赋点数、每点所需要的积分
	},
	attrPointRestore = --天赋重置材料表
	{
		requireScore = 0, --每点所需要的积分
	},
	attrAdd = --每点增加的属性
	{
		[1] = {
			{"trap_fly", 10000,},
		},
		[2] = {
			{"trap_fly", 10000,},
			{"trap_flycd", -5000,},
		},
		[3] = {
			{"trap_fly", 10000,},
			{"trap_flycd", -5000,},
			{"trap_flyenemy", 1500,},
		},
		[4] = {
			{"trap_fly", 20000,},
			{"trap_flycd", -5000,},
			{"trap_flyenemy", 1500,},
		},
		[5] = {
			{"trap_fly", 20000,},
			{"trap_flycd", -10000,},
			{"trap_flyenemy", 1500,},
		},
		[6] = {
			{"trap_fly", 20000,},
			{"trap_flycd", -10000,},
			{"trap_flyenemy", 3000,},
		},
	}
}











------------------------------------------------------------------------------------------------------------
---天赋分类按钮，弹幕里的图标

_tab_chariottalent[1001] ={
	icon = "ICON:SKILL_rune_1001",
}

_tab_chariottalent[1002] ={
	icon = "ICON:SKILL_rune_1002",
}

_tab_chariottalent[1003] ={
	icon = "ICON:SKILL_rune_1003",
}


