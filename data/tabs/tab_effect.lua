--hVar.EFFECT_TYPE = {
	--NONE = 0,
	--NORMAL = 1,		--随坐标偏移
	--OVERHEAD = 2,		--永远在头顶
	--GROUND = 3,		--永远处在地面
	--UNIT = 4,		--{_,bindKey,oUnit}
	--MISSILE = 5,		--{_,oLaunchUnit,launchX,launchX,speed}
	--ARROW = 6,		--{_,worldX,worldY,speed}
--}
hVar.tab_effect = {}
local _tab_effect = hVar.tab_effect
_tab_effect[1] =
{
	type = hVar.EFFECT_TYPE.OVERHEAD,
	model = "MODEL_EFFECT:way_arrow",
	name = "默认特效:箭头",
	height = 100,
}

_tab_effect[2] = {
	model = "MODEL_EFFECT:chat",
	name = "聊天",
}

_tab_effect[3] = {
	model = "MODEL:pSword",
	name = "攻击箭头",
	height = 9999,
}

_tab_effect[4] = {
	model = "MODEL_EFFECT:select_cycle",
	name = "选择圈",
	height = 5000,
	scale = 1.2,
}

--TD攻击特效
_tab_effect[5] = {
	model = "MODEL:pSword",
	name = "TD攻击箭头",
	height = 100,
	scale = 0.7,
}

--_tab_effect[5] = {
	--type = hVar.EFFECT_TYPE.GROUND,
	--model = "MODEL_EFFECT:way_arrows",
	--name = "带朝向的箭头特效",
	--height = 0,
--}

_tab_effect[6] = {
	model = "MODEL_EFFECT:LightningHit_1",
	xlblink = {image=2,scale = 6.0,dur = 100,RGB = {0,0,255},},
	name = "闪电打击_1",
	scale = 1.5,
	height = 0,
}

_tab_effect[7] = {
	model = "MODEL_EFFECT:Defend_1",
	name = "防御_1",
	height = 10,
	scale = 0.5,
}

_tab_effect[8] = {
	model = "MODEL_EFFECT:Blood_1",
	name = "喷血",
	height = 0,
	scale = 0.5,
}

_tab_effect[9] = {
	model = "MODEL_EFFECT:Acid_1",
	name = "酸液",
	height = 0,
	scale = 1.0,
}

_tab_effect[10] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "加速",
	height = 0,
	scale = 0.5,
}

_tab_effect[11] = {
	model = "MODEL_EFFECT:Aura_2",
	xlblink = {scale = 4.0,dur = 100,RGB = {0,0,255},},
	name = "复苏",
	height = 0,
	scale = 0.5,
}

_tab_effect[12] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {scale = 4.0,dur = 100,RGB = {255,255,0},},
	name = "召唤",
	height = 100,
	scale = 1,
}

_tab_effect[13] = {
	model = "MODEL_EFFECT:Arrow_1",
	name = "箭矢",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {125,125,125},},
	height = 0,
	scale = 0.7,
}

_tab_effect[14] = {
	model = "MODEL_EFFECT:LightningHit_2",
	name = "闪电打击_2",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {75,75,255},},
	height = 0,
	scale = 2,
}

_tab_effect[15] = {
	model = "MODEL_EFFECT:MoveCircle",
	name = "当前行动单位选中圈",
	height = 0,
}

_tab_effect[16] = {
	model = "MODEL_EFFECT:burst_1",
	xlblink = {image=12,scale = 6.0,dur = 100,RGB = {255,150,0},},
	name = "炎爆_1",
	scale = 2.7,
	height = 0,
}

_tab_effect[17] = {
	model = "MODEL_EFFECT:HealArea2",
	xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "群疗",
	height = 0,
	scale = 2.5,
}

_tab_effect[18] = {
	model = "MODEL_EFFECT:HealArea2",
	xlblink = {image=0,scale = 1.0,dur = 300,RGB = {100,255,0},},
	name = "单体治疗",
	height = 0,
	scale = 0.6,
}

_tab_effect[19] = {
	model = "MODEL_EFFECT:GlacialSpike",
	xlblink = {light = 1,image=10,scale = 3.0,dur = 400,RGB = {50,50,255},},
	name = "冰锥",
	height = 0,
	scale = 2.7,
}

_tab_effect[20] = {
	model = "MODEL_EFFECT:GlacialSpike",
	--xlblink = {light = 1,image=10,scale = 3.0,dur = 400,RGB = {50,50,255},},
	name = "冰锥2",
	height = 0,
	scale = 1.3,
}

_tab_effect[21] = {
	model = "MODEL_EFFECT:WarStomp",
	xlblink = {scale = 2.0,dur = 150,RGB = {255,255,255},},
	name = "战争践踏",
	height = 0,
	scale = 2.7,
}


_tab_effect[22] = {
	model = "MODEL_EFFECT:Aura_1",
	xlblink = {image= 10 ,scale = 6.0,dur = 1000,RGB = {50,50,255}},
	name = "加速",
	height = 20,
	scale = 2.5,
}

_tab_effect[23] = {
	model = "MODEL_EFFECT:burst_1",
	xlblink = {image=0,scale = 3.0,dur = 100,RGB = {255,150,0},},
	name = "炎爆_小",
	scale = 1.3,
	height = 20,
}

_tab_effect[24] = {
	model = "MODEL_EFFECT:Z_raid",
	--xlblink = {image=0,scale = 7.0,dur = 200,RGB = {50,50,255},},
	name = "Z突袭",
	scale = 0.6,
	height = 20,
}

_tab_effect[25] = {
	model = "MODEL_EFFECT:fireball",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {255,150,0},},
	name = "火球",
	scale = 1.2,
	height = 0,
}

_tab_effect[26] = {
	model = "MODEL_EFFECT:Sword_drop",
	--xlblink = {image=0,scale = 3.0,dur = 200,RGB = {50,255,50},},
	name = "落剑",
	scale = 1.5,
	height = 20,
}

_tab_effect[27] = {
	model = "MODEL_EFFECT:Summon_2",
	xlblink = {image=0,scale = 1.0,dur = 200,RGB = {50,255,50},},
	name = "召唤2",
	scale = 1.6,
	height = 20,

}

_tab_effect[28] = {
	model = "MODEL_EFFECT:stone",
	xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "投石",
	height = 0,
	scale = 0.7,
}

_tab_effect[29] = {
	model = "MODEL_EFFECT:symbol",
	xlblink = {image=0,scale = 5.0,dur = 500,RGB = {50,50,255},},
	name = "定身符",
	scale = 1,
	height = 20,
}

_tab_effect[30] = {
	xlblink = {image=0,scale = 4.0,dur = 450,RGB = {255,50,50},},
	name = "定身符2",
	scale = 1,
	height = 20,
}

_tab_effect[31] = {
	xlblink = {image=0,scale = 3.0,dur = 400,RGB = {50,255,50},},
	name = "定身符3",
	scale = 1,
	height = 20,
}

_tab_effect[32] = {
	model = "MODEL_EFFECT:ice_spike_01",
	xlblink = {light = 1,image=0,scale = 1.2,dur = 300,RGB = {50,50,255},},
	name = "冰弹攻击",
	scale = 1,
	height = 20,
	box = {20, 0, 80, 30},
}
_tab_effect[33] = {
	model = "MODEL_EFFECT:shadowball",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {255,50,255},},
	name = "暗影弹攻击",
	scale = 1,
	height = 20,
}

_tab_effect[34] = {
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,75,0},},
	name = "投石爆炸",
	scale = 2.5,
	height = 20,
}

_tab_effect[35] = {
	model = "MODEL_EFFECT:seal_1",
	name = "封印",
	scale = 0.6,
	height = 20,
}

_tab_effect[36] = {
	model = "MODEL_EFFECT:ice_shell",
	xlblink = {image=0,scale = 1,dur = 300,RGB = {75,75,255}},
	name = "冰封",
	scale = 1,
	height = 20,
}

_tab_effect[37] = {
	model = "MODEL_EFFECT:MoveCircle2",
	name = "眩晕",
	scale = 1,
	height = 20,
}

_tab_effect[38] = {
	model = "MODEL_EFFECT:fear",
	name = "恐惧",
	scale = 0.5,
	height = 20,
}

_tab_effect[39] = {
	model = "MODEL_EFFECT:whirlwind",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255}},
	name = "旋风",
	scale = 1.5,
	height = 20,
}

_tab_effect[40] = {
	model = "MODEL_EFFECT:unparalleled",
	name = "无双",
	scale = 1,
	height = 20,
}

_tab_effect[41] = {
	model = "MODEL_EFFECT:Aura_1",
	xlblink = {image=0,scale = 3.0,dur = 1000,RGB = {75,75,255},},
	name = "加攻",
	height = 0,
	scale = 0.5,
}
_tab_effect[42] = {
	model = "MODEL_EFFECT:seal_2",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,75,0},},
	name = "诛杀",
	scale = 0.7,
	height = 20,
}

_tab_effect[43] = {
	model = "MODEL:duest",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {125,125,125},},
	name = "建造",
	scale = 1.7,
	height = 20,
}

_tab_effect[44] = {
	model = "MODEL_EFFECT:LifeSteal",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,100,100},},
	name = "嗜血爪",
	scale = 1.5,
	height = 20,
}

_tab_effect[45] = {
	model = "MODEL_EFFECT:LightningHit_3",
	xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {10,10,255},},
	name = "闪电光效",
	scale = 1.5,
	height = 20,
}

_tab_effect[46] = {
	model = "MODEL_EFFECT:unparalleled2",
	name = "无双2",
	scale = 1,
	height = 20,
}

_tab_effect[47] = {
	model = "MODEL_EFFECT:teleport",
	xlblink = {image=0,scale = 1.4,dur = 1000,RGB = {0,50,255},},
	name = "传送",
	scale = 0.5,
	height = 9999,
}

_tab_effect[48] = {
	model = "MODEL_EFFECT:firewall",
	name = "燃烧",
}

_tab_effect[49] = {
	model = "MODEL_EFFECT:teleport",
	--xlblink = {image=0,scale = 1.6,dur = 500,RGB = {255,0,0},},
	name = "传送",
	scale = 1.0,
	height = 20,
}

_tab_effect[50] = {
	model = "MODEL_EFFECT:stone_f",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {255,150,0},},
	name = "霹雳弹",
	scale = 0.7,
	height = 20,
}

_tab_effect[51] = {
	model = "MODEL_EFFECT:stone_f",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {255,150,0},},
	name = "霹雳弹碎片",
	scale = 0.5,
	height = 20,
}

_tab_effect[52] = {
	model = "MODEL_EFFECT:Arrow_2",
	name = "弩车箭矢",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {125,125,125},},
	height = 0,
	scale = 0.9,
}

_tab_effect[53] = {
	model = "MODEL_EFFECT:Z_raid_red",
	xlblink = {image=0,scale = 7.0,dur = 200,RGB = {50,50,255},},
	name = "Z突袭——红色",
	scale = 1.4,
	height = 20,
}

_tab_effect[54] = {
	model = "MODEL_EFFECT:burst_3",
	xlblink = {image=0,scale = 0.5,dur = 100,RGB = {200,150,50},}, --scale 2.0
	name = "受击特效1",
	scale = 0.5,
	height = 999,
}

_tab_effect[55] = {
	model = "MODEL_EFFECT:Arrow_1",
	xlblink = {light = 0,image=15,scale = 1,dur = 200,RGB = {0,0,0},},
	name = "箭雨落下",
	scale = 0.5,
	height = 20,
}

_tab_effect[56] = {
	model = "MODEL_EFFECT:teleport",
	--xlblink = {image=0,scale = 1.6,dur = 500,RGB = {255,0,0},},
	name = "传送大",
	scale = 1.5,
	height = 20,
}

_tab_effect[57] = {
	model = "MODEL_EFFECT:charge",
	name = "冲锋尘土",
	scale = 1,
	height = -1,
}

--_tab_effect[45] = {
	--model = "MODEL_EFFECT:LightningHit_4",
	--xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {10,10,255},},
	--name = "闪电光效",
	--scale = 0.6,
	--height = 20,
--}

_tab_effect[58] = {
	model = "MODEL_EFFECT:burst_3",
	xlblink = {image=0,scale = 1.7,dur = 150,RGB = {200,150,50},},
	name = "受击特效--大",
	scale = 1.1,
	height = 999,
}

_tab_effect[59] = {
	model = "MODEL_EFFECT:magic_dark_Lord_Ball",
	name = "法术攻击---投射",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {125,125,125},},
	height = 0,
	scale = 1.2,
}
_tab_effect[60] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,75,0},},
	name = "场景光效--红",
	scale = 0.5,
	height = 200,
	box = {-10,0,30,20},
}

_tab_effect[61] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,255,0},},
	name = "场景光效--黄",
	scale = 0.5,
	height = 20,
}
_tab_effect[62] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,255,255},},
	name = "场景光效--白",
	scale = 0.5,
	height = 20,
}
_tab_effect[63] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "人物光效--红",
	scale = 1,
	height = 20,
}

-------------------套装特效---幼麟-----------------------------------------
_tab_effect[64] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,150,0},x=0,y=70},
	name = "人物光效--土黄",
	scale = 1,
	height = 20,
}
_tab_effect[65] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.5,dur = 700,RGB = {255,255,0},x=0,y=40},
	name = "人物光效--金黄",
	scale = 1,
	height = 20,
}
_tab_effect[66] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,150,0},x=0,y=10},
	name = "人物光效--土黄",
	scale = 1,
	height = 20,
}
-------------------套装特效--------------------------------------------------
-------------------组合特效---黑风-----------------------------------------
_tab_effect[67] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,0,0},x=0,y=70},
	name = "人物光效--土黄",
	scale = 1,
	height = 20,
}
_tab_effect[68] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.5,dur = 700,RGB = {255,0,0},x=0,y=40},
	name = "人物光效--金黄",
	scale = 1,
	height = 20,
}
_tab_effect[69] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,0,0},x=0,y=10},
	name = "人物光效--土黄",
	scale = 1,
	height = 20,
}
_tab_effect[70] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {255,0,255},x=0,y=10},
	name = "人物光效--紫",
	scale = 1,
	height = 20,
}

_tab_effect[71] = {
	model = "MODEL_EFFECT:ice_shell2",
	xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰封",
	scale = 1,
	height = 20,
}

_tab_effect[72] = {
	model = "MODEL_EFFECT:ice_shell201",
	xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰封",
	scale = 1,
	height = 20,
}

_tab_effect[73] = {
	model = "MODEL_EFFECT:ice_explosion2",
	xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰碎裂",
	scale = 1.5,
	height = 20,
}

_tab_effect[74] = {
	model = "MODEL_EFFECT:ice_explosion_jiansu",
--	xlblink = {image=0,scale = 0.6,dur = 300,RGB = {75,75,255}},
	name = "冰冻减速",
	scale = 1.2,
	height = 20,
}

_tab_effect[75] = {
	model = "MODEL_EFFECT:cobweb01",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰蛛网",
	scale = 1.3,
	height = 50,
}

_tab_effect[76] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,255,0},},
	name = "场景光效--黄2",
	scale = 0.5,
	height = 20,
}

_tab_effect[77] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {0,255,0},},
	name = "场景光效--绿",
	scale = 0.5,
	height = 20,
}

_tab_effect[78] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,0,0},},
	name = "场景光效--红",
	scale = 0.5,
	height = 20,
}
_tab_effect[79] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {0,0,255},},
	name = "场景光效--蓝",
	scale = 0.5,
	height = 20,
}
-------------------特效--------------------------------------------------
_tab_effect[80] = {
	model = "MODEL_EFFECT:FireAura",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环",
	scale = 1,
	height = 20,
}

_tab_effect[81] = {
	model = "MODEL_EFFECT:ForceShield",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,255,0},},
	name = "护盾",
	scale = 0.85,
	height = 20,
}

_tab_effect[82] = {
	model = "MODEL_EFFECT:Arrow_1",
	xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "火球",
	scale = 0.9,
	height = 0,
}

_tab_effect[83] = {
	model = "MODEL_EFFECT:laserball_explosion",
	--xlblink = {image=0,scale = 0.5,dur = 1600,RGB = {255,255,255},x=0,y=0},
	name = "透射枪光效1",
	scale = 1.0,
	height = 20,
}
_tab_effect[84] = {
	model = "MODEL_EFFECT:laserball_explosion",
	--xlblink = {image=0,scale = 0.5,dur = 1600,RGB = {255,100,150},},
	name = "透射枪光效2",
	scale = 1.0,
	height = 20,
	RGB = {255,100,150},
}
_tab_effect[85] = {
	model = "MODEL_EFFECT:laserball_explosion",
	--xlblink = {image=0,scale = 0.5,dur = 1600,RGB = {255,150,0},},
	name = "透射枪光效3",
	scale = 1.0,
	height = 20,
	RGB = {255,150,0},
}

_tab_effect[86] = {
	model = "MODEL_EFFECT:laserball_explosion",
	--xlblink = {image=0,scale = 0.5,dur = 1600,RGB = {255,150,150},},
	name = "透射枪光效4",
	scale = 1.0,
	height = 20,
	RGB = {255,150,150},
}
_tab_effect[87] = {
	model = "MODEL_EFFECT:laserball_explosion",
	--xlblink = {image=0,scale = 0.5,dur = 1600,RGB = {255,100,0},},
	name = "透射枪光效5",
	scale = 1.0,
	height = 20,
	RGB = {255,100,0},
}
_tab_effect[88] = {
	model = "MODEL_EFFECT:Flower6",
	name = "花6",
	scale = 1,
	height = 20,
}

_tab_effect[89] = {
	xlblink = {image=0,scale = 1.6,dur = 100,RGB = {255,255,255},},
	name = "白色闪光",
	scale = 1,
	height = 20,
}
_tab_effect[90] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {128,128,0},},
	name = "场景光效--黄2",
	scale = 0.5,
	height = 20,
}

_tab_effect[91] = {
	model = "MODEL_EFFECT:fire_star",
	name = "燃烧的火",
	scale = 1,
	height = 20,
}
_tab_effect[92] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "火焰旋风",
	scale = 0.8,
	height = 20,
}

_tab_effect[93] = {
	model = "MODEL_EFFECT:wushuang1",
	name = "吕布无双",
	scale = 1.7,
	height = 80,
}
_tab_effect[94] = {
	model = "MODEL_EFFECT:wushang1-1",
	name = "吕布无双",
	scale = 1,
	height = 80,
}

_tab_effect[95] = {
	model = "MODEL_EFFECT:WarStomp",
	xlblink = {scale = 2.0,dur = 150,RGB = {255,100,0},},
	name = "战争践踏",
	height = 0,
	scale = 2.7,
}

_tab_effect[96] = {
	model = "MODEL_EFFECT:dust2",
	name = "粉尘",
	scale = 1.3,
	height = 80,
}

_tab_effect[97] = {
	model = "MODEL_EFFECT:burst01",
	name = "蓝色爆裂特效",
	scale = 1.5,
	height = 80,
}

_tab_effect[98] = {
	model = "MODEL_EFFECT:Arrow_3",
	name = "箭矢3",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,255,0},},
	height = 0,
	scale = 0.85,
	box = {0, 0, 60, 30},
}

_tab_effect[99] = {
	model = "MODEL_EFFECT:Arrow_4",
	name = "箭矢4",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,255},},
	height = 0,
	scale = 1,
}

_tab_effect[100] = {
	model = "MODEL_EFFECT:Roar01",
	name = "咆哮1",
	height = 999,
	scale = 3,
}

_tab_effect[101] = {
	model = "MODEL_EFFECT:Fire01",
	name = "火焰1",
	height = -100,
	scale = 2,
}

_tab_effect[102] = {
	model = "MODEL_EFFECT:Fire02",
	name = "火焰2",
	height = 0,
	scale = 1,
}

_tab_effect[103] = {
	model = "MODEL_EFFECT:Fire03",
	name = "火焰3",
	height = 0,
	scale = 0.7,
}

_tab_effect[104] = {
	model = "MODEL_EFFECT:Fire04",
	name = "火焰4",
	height = 0,
	scale = 1,
}

_tab_effect[105] = {
	model = "MODEL_EFFECT:Fire05",
	name = "火焰5",
	height = 0,
	scale = 0.7,
}

_tab_effect[106] = {
	model = "MODEL_EFFECT:Acid01",
	name = "毒素1",
	height = 30,
	scale = 1.5,
}

_tab_effect[107] = {
	model = "MODEL_EFFECT:Mana01",
	name = "魔法1",
	height = 0,
	scale = 1,
}

_tab_effect[108] = {
	model = "MODEL_EFFECT:Smoke01",
	name = "烟雾1",
	height = 0,
	scale = 4,
}

_tab_effect[109] = {
	model = "MODEL_EFFECT:Heal01",
	name = "治疗1",
	height = 0,
	scale = 1,
}

_tab_effect[110] = {
	model = "MODEL_EFFECT:Smoke01",
	name = "烟雾1小",
	height = 0,
	scale = 1,
}

_tab_effect[111] = {
	model = "MODEL_EFFECT:Fire06",
	name = "天火",
	height = 0,
	scale = 1.5,
}

_tab_effect[112] = {
	model = "MODEL_EFFECT:Ground01",
	name = "地面01",
	height = -100,
	scale = 1.5,
}

_tab_effect[113] = {
	model = "MODEL_EFFECT:Ground02",
	name = "地面02",
	height = -100,
	scale = 1.4,
}

_tab_effect[114] = {
	model = "MODEL_EFFECT:Summon_1",
	name = "地面03",
	height = -100,
	scale = 2.7,
}

_tab_effect[115] = {
	model = "MODEL_EFFECT:fear",
	name = "地面04",
	height = 100,
	scale = 1,
}

_tab_effect[116] = {
	model = "MODEL_EFFECT:Arrow05",
	name = "箭矢05（花瓣）",
	height = 0,
	scale = 0.75,
}

_tab_effect[117] = {
	model = "MODEL_EFFECT:Aura04",
	name = "随身特效-绿色护盾",
	height = 20,
}

_tab_effect[118] = {
	model = "MODEL_EFFECT:Smoke03",
	name = "随身特效-薄雾",
	scale = 1.3,
	height = 20,
}

_tab_effect[119] = {
	model = "MODEL_EFFECT:AuraSakula",
	name = "随身特效-薄雾",
	scale = 0.6,
	height = 20,
}

_tab_effect[120] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,255,255},},
	name = "场景光效--白",
	scale = 0.5,
	height = 20,
}

_tab_effect[121] = {
	model = "MODEL_EFFECT:Skybook",
	name = "封印",
	scale = 0.7,
}

_tab_effect[122] = {
	name = "影子",
	xlblink = {light = 0,image=0,scale = 1.3,dur = 750,RGB = {110,110,110},},
	height = 0,
	scale = 0.7,
}

_tab_effect[123] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {light = 0,image=0,scale = 0.8,dur = 1600,RGB = {0,0,0},},
	name = "场景光效--黑",
	scale = 0.5,
	height = 20,
}

_tab_effect[124] = {
	model = "MODEL_EFFECT:ForceShield",
	name = "护盾(小)",
	scale = 0.4,
	height = 20,
}

_tab_effect[125] = {
	model = "MODEL_EFFECT:fireball",
	xlblink = {image=0,scale = 1.2,dur = 500,RGB = {255,150,0},},
	name = "火球-极小",
	scale = 0.7,
	height = 0,
}

_tab_effect[126] = {
	model = "MODEL_EFFECT:Daoguang02",
	name = "刀光02",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {125,125,125},},
	height = 20,
	scale = 1.5,
}

_tab_effect[127] = {
	model = "MODEL_EFFECT:Liehuo",
	name = "天火",
	height = 0,
	scale = 1,
}

_tab_effect[128] = {
	model = "MODEL_EFFECT:ForceShield",
	name = "结界",
	scale = 1,
	height = 20,
}

_tab_effect[129] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.4,dur = 700,RGB = {255,75,0},},
	name = "爆炸光效--红",
	scale = 0.1,
	height = 20,
}

_tab_effect[130] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {image=0,scale = 45,dur = 700,RGB = {255,255,255},},
	name = "爆炸光效--红2",
	scale = 0.01,
	height = 20,
}

_tab_effect[131] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "火焰旋风（大）",
	scale = 2,
	height = 20,
}

_tab_effect[132] = {
	name = "火光",
	xlblink = {image=0,scale = 1.1,dur = 750,RGB = {255,75,0},},
	height = 0,
	scale = 1,
}

_tab_effect[133] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {light = 0,image=0,scale = 18,dur = 500,RGB = {0,0,0},},
	name = "爆炸光效--黑",
	scale = 0.8,
	height = 20,
}

_tab_effect[134] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "火焰旋风（大）",
	scale = 2.5,
	height = 20,
}

_tab_effect[135] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "火焰旋风（大）",
	scale = 3,
	height = 20,
}

_tab_effect[136] = {
	model = "MODEL_EFFECT:whirlwind",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "旋风（小）",
	scale = 1,
	height = 20,
}

_tab_effect[137] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {image=0,scale = 45,dur = 700,RGB = {50,50,255},},
	name = "爆炸光效--蓝1",
	scale = 0.01,
	height = 20,
}

_tab_effect[138] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,153,0},},
	name = "场景光效--橙",
	scale = 0.5,
	height = 20,
}

_tab_effect[139] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {102,255,255},},
	name = "场景光效--青",
	scale = 0.5,
	height = 20,
}

_tab_effect[140] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {102,51,153},},
	name = "场景光效--紫",
	scale = 0.5,
	height = 20,
}

_tab_effect[141] = {
	model = "MODEL_EFFECT:whirlwind2",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "旋风(透明)",
	scale = 1,
	height = 20,
}

_tab_effect[142] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,100,255},},
	name = "人物光效--淡蓝",
	scale = 1,
	height = 20,
}

_tab_effect[143] = {
	model = "MODEL_EFFECT:laserball",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {0,50,255},x=148,y=18,dummy=1},
	name = "卧龙光线",
	scale = 1.5,
	height = 20,
}

_tab_effect[144] = {
	model = "MODEL_EFFECT:shield01",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,100,255},x=0,y=42},
	name = "寒冰护盾",
	scale = 2,
	height = 20,
}

_tab_effect[145] = {
	name = "战场-薄雾",
	model = "MODEL_EFFECT:Smoke03",
	scale = 24,
	height = 999,
	action = {
		{
			{"move",0.6,0,640},
		},
		{
			{"delay",0.8},
			{"fade",-0.3},
		},
	},
}

_tab_effect[146] = {
	name = "战场-大雪",
	model = "MODEL_EFFECT:ice_shell",
	scale = 28,
	height = 999,
	xlblink = {image=0,scale = 90,dur = 300,RGB = {0,100,255},},
	action = {
		{
			{"move",0.4,120,-200},
		},
		{
			{"fade",-0.8},
		},
	},
}
_tab_effect[147] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {light = 0,image=0,scale = 3000,dur = 1400,RGB = {0,0,0},},
	name = "必杀光效--黑--长",
	scale = 10,
	height = 20,
}

_tab_effect[148] = {
	xlblink = {light = 0,image=0,scale = 3000,dur = 400,RGB = {0,0,0},},
	name = "必杀光效--黑--短",
	scale = 10,
	height = 21,
}

_tab_effect[149] = {
	model = "MODEL_EFFECT:laserball",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {50,80,255},},
	name = "卧龙蛋攻击",
	scale = 1.3,
	height = 20,
}

_tab_effect[150] = {
	model = "MODEL_EFFECT:laserball",
	xlblink = {light = 1,image=0,scale = 0.2,dur = 300,RGB = {0,50,255},x=24,y=48},
	name = "徐庶剑气",
	scale = 1.5,
	height = 999,
}

_tab_effect[151] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {image=0,scale = 2000,dur = 150,RGB = {255,255,255},},
	name = "爆炸光效--红2",
	scale = 0.01,
	height = 20,
}

_tab_effect[152] = {
	model = "MODEL_EFFECT:symbo2",
	name = "定身符",
	scale = 1,
	height = 20,
}

_tab_effect[153] = {
	model = "MODEL_EFFECT:Fire04",
	name = "火焰4",
	height = -99,
	scale = 1,
}

_tab_effect[154] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 400,RGB = {255,0,0},},
	name = "场景光效--红",
	scale = 0.5,
	height = 20,
}

_tab_effect[155] = {
	model = "MODEL_EFFECT:battleshipopenmouth",
	name = "船怪张嘴",
	height = 0,
	--scale = 0.7,
}

_tab_effect[156] = {
	model = "MODEL_EFFECT:battleshipopenmouth_ani",
	name = "船怪闭嘴",
	height = 0,
	--scale = 0.7,
}


_tab_effect[157] = {
	model = "MODEL_EFFECT:bomb",
	xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {10,10,255},},
	name = "炸弹",
	scale = 0.4,
	height = 20,
}

_tab_effect[158] = {
	model = "MODEL_EFFECT:bomb",
	xlblink = {light = 1,image=0,scale = 5.0,dur = 100,RGB = {255,10,10},},
	name = "船怪邪火炸弹",
	scale = 0.6,
	height = 20,
}

_tab_effect[159] = {
	model = "MODEL_EFFECT:bb_fire",
	name = "船怪喷火",
	height = 0,
	scale = 1.5,
}

_tab_effect[160] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.2,dur = 1500,RGB = {255,0,0},},
	name = "场景光效--红",
	scale = 0.5,
	height = 20,
}

_tab_effect[161] = {
	model = "MODEL_EFFECT:laserball2",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {255,0,0},x=148,y=18,dummy=1},
	name = "红色卧龙光线",
	scale = 1.5,
	height = 20,
}

_tab_effect[162] = {
	model = "MODEL_EFFECT:bb_fire_ani",
	name = "船怪喷火_反",
	height = 0,
	scale = 1.5,
}

_tab_effect[163] = {
	model = "MODEL_EFFECT:bb_energy_anim",
	--name = "船怪能量块特效",
	name = "散弹子弹1",
	height = 0,
	scale = 0.1,
	box = {0,0,20,10},
	RGB = {255,128,0},
}

_tab_effect[164] = {
	--model = "MODEL_EFFECT:blackfog1",
	--name = "黑烟1",
	--height = 0,
	--scale = 1.0,
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "散弹子弹2",
	height = 0,
	scale = 0.12,
	box = {0,0,20,10},
	RGB = {255,128,0},
}

_tab_effect[165] = {
	--model = "MODEL_EFFECT:bb_fire_can",
	--name = "船怪喷火_炮管",
	--height = 0,
	--scale = 1,
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "散弹子弹3",
	height = 0,
	scale = 0.14,
	box = {0,0,20,10},
	RGB = {255,128,0},
}

_tab_effect[166] = {
	--model = "MODEL_EFFECT:bb_fire_ani_can",
	--name = "船怪喷火_炮管_反序",
	--height = 0,
	--scale = 1.0,
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "散弹子弹4",
	height = 0,
	scale = 0.15,
	box = {0,0,20,10},
	RGB = {255,128,0},
}

_tab_effect[167] = {
	--model = "MODEL_EFFECT:bb_lz",
	--name = "船怪激光_炮管",
	--height = 0,
	--scale = 1,
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "散弹子弹5",
	height = 0,
	scale = 0.17,
	box = {0,0,20,10},
	RGB = {255,128,0},
}

_tab_effect[168] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.9,dur = 600,RGB = {255,0,0},},
	name = "场景光效--红",
	scale = 0.6,
	height = 20,
}

_tab_effect[169] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.3,dur = 600,RGB = {255,0,0},},
	name = "场景光效--红",
	scale = 0.3,
	height = 20,
}

_tab_effect[170] = {
	model = "MODEL_EFFECT:Fire01",
	name = "神牛自爆火",
	height = -100,
	scale = 1.6,
}


_tab_effect[171] = {
	model = "MODEL_EFFECT:Mana01",
	name = "黑洞",
	height = -999,
	scale = 1,
	RGB = {0,0,0},
}

_tab_effect[172] = {
	shader = {image="data/image/misc/mask.png",shaderName = "heartbeat",w = 66,h=66,paramTab = {{"resolution",66,66}},},
	name = "测试shader特效",
	scale = 1.0,
	--height = 20,
}

_tab_effect[173] = {
	model = "MODEL_EFFECT:mon_stone",
	--xlblink = {light = 1,image=0,scale = 5.0,dur = 100,RGB = {255,10,10},},
	name = "山怪_落石",
	scale = 1.0,
	height = 0,
}

_tab_effect[174] = {
	shader = {image="data/image/misc/mask.png",shaderName = "galaxy1",w = 66,h=66,paramTab = {{"resolution",66,66}},},
	name = "测试shader特效",
	scale = 1.5,
	--height = 20,
}

_tab_effect[175] = {
	model = "MODEL_EFFECT:Fire06_r",
	name = "黑炎(天照)",
	height = 0,
	scale = 3.0,
	RGB = {0,0,0},
	extra = {
		{model="MODEL_EFFECT:Fire06_r",scale=2.2,RGB={255,0,0},x=0,y=6},
	},
}

_tab_effect[176] = {
	model = "MODEL_EFFECT:Fire04",
	name = "黑炎附身",
	height = 0,
	scale = 2.0,
	RGB = {0,0,0},
	extra = {
		{model="MODEL_EFFECT:Fire04",scale=1.2,RGB={255,0,0},x=0,y=0},
	},
}

_tab_effect[177] = {
	model = "MODEL_EFFECT:burst_1",
	name = "黑炎爆_1",
	scale = 2.2,
	height = 0,
	RGB = {0,0,0},
	extra = {
		{model="MODEL_EFFECT:burst_1",scale=1.6,RGB={255,0,0},x=-4,y=16},
	},
}

_tab_effect[178] = {
	model = "MODEL_EFFECT:teleport",
	xlblink = {image=0,scale = 1.4,dur = 300,RGB = {255,0,0},},
	name = "传送(天照)",
	scale = 1.0,
	height = 20,
	RGB = {0,0,0},
}

_tab_effect[179] = {
	model = "MODEL_EFFECT:magic_dark_Lord_Ball",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {128,0,0},},
	name = "黑炎弹",
	scale = 1.8,
	height = 20,
	RGB = {96,0,0},
}

_tab_effect[180] = {
	model = "MODEL_EFFECT:DownStone_MM",
	--xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {128,0,0},},
	name = "落石灰尘",
	scale = 1.0,
	height = 2000,
	--RGB = {96,0,0},
}

_tab_effect[181] = {
	model = "MODEL_EFFECT:Dust_MM",
	--xlblink = {image=12,scale = 6.0,dur = 100,RGB = {255,150,0},},
	name = "落石爆裂",
	scale = 1.0,
	height = 0,
}

_tab_effect[182] = {
	model = "MODEL_EFFECT:Sword_drop",
	animation = "hold",
	name = "剑光持续",
	scale = 1.5,
	height = 20,
}

_tab_effect[183] = {
	model = "MODEL_EFFECT:Sword_drop",
	animation = "drop",
	name = "剑光持续",
	scale = 1.5,
	height = 20,
}

_tab_effect[184] = {
	model = "MODEL_EFFECT:LightningHit_1",
	name = "圣雷(治疗)",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,255,0},},
	height = 0,
	scale = 1.4,
}

_tab_effect[185] = {
	model = "MODEL_EFFECT:shield01",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,180,0}},
	name = "圣光庇护",
	scale = 1.4,
	height = 20,
	RGB = {255,255,96},
}

_tab_effect[186] = {
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 1.6,dur = 300,RGB = {255,75,0},},
	name = "爆裂攻击(爆炸)",
	scale = 1.6,
	height = 20,
	RGB = {255,180,0},
}

_tab_effect[187] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {170,170,170},},
	name = "场景光效--银",
	scale = 0.5,
	height = 20,
}

_tab_effect[188] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {light = 0,image=0,scale = 3,dur = 4000,RGB = {0,0,0},},
	name = "场景光效--黑--长",
	scale = 3,
	height = 20,
}

_tab_effect[189] = {
	model = "MODEL_EFFECT:bomb",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {10,10,255},},
	name = "炸弹(小)",
	scale = 0.3,
	height = 20,
}

_tab_effect[190] = {
	model = "MODEL_EFFECT:Fire01",
	name = "巨大火圈",
	height = -100,
	scale = 3,
}

_tab_effect[191] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 45,dur = 700,RGB = {255,0,0},},
	name = "必杀光效--红--长",
	scale = 10,
	height = 20,
}

_tab_effect[192] = {
	model = "MODEL_EFFECT:ForceShield",
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,0},x=0,y=42},
	name = "巨大护盾",
	scale = 1.8,
	height = 20,
	RGB = {255,10,10},
}

_tab_effect[193] = {
	model = "MODEL_EFFECT:stone",
	xlblink = {light = 0,image=14, scale = 0.35, dur = 100,RGB = {125,125,125},},
	name = "小型投石",
	height = 0,
	scale = 0.5,
}

_tab_effect[194] = {
	model = "MODEL_EFFECT:HealArea2",
	xlblink = {image=0,scale = 1.0,dur = 200,RGB = {100,255,0},},
	name = "箭塔升级",
	height = 20,
	scale = 0.9,
}





_tab_effect[195] = {
	model = "MODEL_EFFECT:Smoke03",
	name = "随身特效-薄雾",
	scale = 0.7,
	height = 20,
	RGB = {150,255,100},
}


_tab_effect[196] = {
	model = "MODEL_EFFECT:FireAura",
--	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	RGB = {250,0,0},
	name = "火焰光环（大）",
	height = -20,
	scale = 0.8,
}

_tab_effect[197] = {
	model = "MODEL_EFFECT:FireAura",
--	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	RGB = {250,0,0},
	name = "火焰光环（小）",
	height = -20,
	scale = 0.5,
}


_tab_effect[198] = {
	model = "MODEL_EFFECT:whirlwind",
	--xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "带碰撞盒的旋风",
	height = 0,
	scale = 0.7,
	--RGB = {250,0,0},
	box = {0,-10,60,40},
}


--反向大火球（龙息）
_tab_effect[199] = {
	model = "MODEL_EFFECT:fireball",
	xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 2,
	height = 30,
	box = {0,-10,80,50},
}

--反向大火球（小）
_tab_effect[200] = {
	model = "MODEL_EFFECT:fireball",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 1.2,
	height = 30,
	box = {20,0,60,20},
}

_tab_effect[201] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {240,185,40},},
	name = "场景灯光--黄",
	scale = 1.0,
	--height = 20,
}

_tab_effect[202] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {0,255,255},},
	name = "场景灯光--天蓝",
	scale = 1.0,
	--height = 20,
}

_tab_effect[203] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {255,255,255},},
	name = "场景灯光--白",
	scale = 1.0,
	--height = 20,
}

_tab_effect[204] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {255,128,64},},
	name = "场景灯光--橙",
	scale = 1.0,
	--height = 20,
}

_tab_effect[205] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {255,255,255},},
	name = "场景灯光--白2",
	scale = 1.0,
	height = -10,
}

_tab_effect[206] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {198,83,204},},
	name = "场景灯光--紫",
	scale = 1.0,
	--height = 20,
}

_tab_effect[207] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {255,0,0},},
	name = "场景灯光--红",
	scale = 1.0,
	height = -10,
}

_tab_effect[208] = {
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {255,0,0}, rot = 90,},
	name = "地雷光效--红",
	scale = 1.0,
	height = 0,
}

_tab_effect[209] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {0,255,0},},
	name = "宠物光效--绿",
	scale = 1.0,
	height = -10,
}

_tab_effect[210] = {
	xlblink = {image=0,scale = 1.0,dur = 0,RGB = {255,0,0},roll = 90,},
	name = "场景灯光--红(竖)",
	scale = 1.0,
	height = -10,
}

_tab_effect[211] = {
	xlblink = {image=0,scale = 1.5,dur = 500,RGB = {0,255,255},},
	name = "能源水晶台子光效--天蓝",
	scale = 1.0,
	--height = 20,
}



_tab_effect[301] = {
	model = "MODEL_EFFECT:Arrow_2",
	name = "弩矢",
--	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {125,125,125},},
	height = 0,
	scale = 0.6,
}


_tab_effect[302] = {
	model = "MODEL_EFFECT:laserball2",
	name = "箭矢1",
--	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {255,0,0},},
	height = 100,
	scale = 0.6,
--	RGB = {255,100,100},

}

_tab_effect[303] = {
	model = "MODEL_EFFECT:fireball_01",
	xlblink = {image=0,scale = 1.2,dur = 500,RGB = {255,150,0},},
	name = "火弹攻击",
	scale = 1,
	height = 30,
}

_tab_effect[304] = {
	model = "MODEL_EFFECT:ice_spike_01",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {50,50,255},},
	name = "冰弹攻击",
	scale = 0.8,
	height = 20,
}

--td-连弩塔箭矢
_tab_effect[401] = {
	model = "MODEL_EFFECT:JIANTA_BULLET",
	name = "连弩塔箭矢",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {127,127,0},},
	height = 100,
	scale = 0.3,
}

--基础箭塔底座
_tab_effect[402] = {
	model = "MODEL_EFFECT:JIANTA_BASE",
	name = "基础箭塔底座",
	height = -5,
	scale = 0.7,
}

--巨炮塔普通攻击的子弹（小）
_tab_effect[403] = {
	model = "MODEL_EFFECT:PAOTA1_BULLET",
	name = "巨炮塔普通攻击的子弹（小）",
	xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	height = 40,
	scale = 1,
}

--基础炮塔底座
_tab_effect[404] = {
	model = "MODEL_EFFECT:PAOTA_BASE",
	name = "基础炮塔底座",
	height = -5,
	scale = 0.6,
}

_tab_effect[410] = {
	model = "MODEL_EFFECT:banner3",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "旗帜（董卓）",
	scale = 1,
	height = -100,
}



_tab_effect[411] = {
	model = "MODEL_EFFECT:bolang",
	name = "减速",
	height = 0,
	scale = 5,
}

--塔基
_tab_effect[412] = {
	model = "MODEL_EFFECT:TD_Base",
	name = "塔基",
	height = -5,
	scale = 0.8,
}

--手
_tab_effect[413] =
{
	type = hVar.EFFECT_TYPE.OVERHEAD,
	model = "MODEL_EFFECT:Hand",
	name = "手",
	height = 100,
}

_tab_effect[414] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,255,128},},
	name = "场景光效--绿",
	scale = 0.8,
	height = 20,
}

--塔基2
_tab_effect[415] = {
	model = "MODEL_EFFECT:TD_Base2",
	name = "塔基2",
	height = -5,
	scale = 0.7,
}

--蓝色flag
_tab_effect[416] = {
	model = "MODEL_EFFECT:flag",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "旗帜",
	scale = 1,
	height = 20,
}

--火塔爆炸
_tab_effect[417] = {
	model = "MODEL_EFFECT:burst_2",
	name = "炎爆_小",
	scale = 1,
	height = 20,
}

_tab_effect[418] =
{
	--type = hVar.EFFECT_TYPE.OVERHEAD,
	model = "MODEL_EFFECT:way_not_arrow",
	name = "移动不能到达提示:箭头",
	height = 999,
}

--巨炮塔普通攻击的子弹（大）
_tab_effect[419] = {
	model = "MODEL_EFFECT:PAOTA1_BULLET",
	name = "巨炮塔普通攻击的子弹（大）",
	xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {255,125,125},},
	height = 30,
	scale = 1.2,
	RGB = {255,125,125},
}

--不能施法特效
_tab_effect[420] =
{
	--type = hVar.EFFECT_TYPE.OVERHEAD,
	model = "MODEL_EFFECT:banned",
	name = "等待转圈圈特效",
	height = 0,
	scale = 0.55,
}

_tab_effect[421] = {
	model = "MODEL_EFFECT:WarStomp",
	xlblink = {scale = 1.4,dur = 150,RGB = {255,255,255},},
	name = "战争践踏(小)",
	height = 0,
	scale = 1.8,
}

_tab_effect[422] = {
	model = "MODEL_EFFECT:FireAura",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环（大）",
	scale = 2,
	height = 20,
}

_tab_effect[423] = {
	model = "MODEL_EFFECT:Fire05",
	name = "火焰（较大）",
	height = 0,
	scale = 1,
}

_tab_effect[424] = {
	model = "MODEL_EFFECT:Fire05",
	name = "火焰（很大）",
	height = 0,
	scale = 1.3,
}

_tab_effect[425] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {255,75,0},},
	name = "场景光效--红",
	scale = 0.8,
	height = 20,
}

_tab_effect[426] = {
	model = "MODEL_EFFECT:DownStone_MM",
	--xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {128,0,0},},
	name = "落石灰尘",
	scale = 0.6,
	height = 3000,
	--RGB = {96,0,0},
}

_tab_effect[427] = {
	model = "MODEL_EFFECT:banner2",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "旗帜（黄巾）",
	scale = 1,
	height = -100,
}

--基础炮塔普通攻击子弹
_tab_effect[428] = {
	name = "基础炮塔普通攻击子弹",
	model = "MODEL_EFFECT:PAOTA_BULLET",
	xlblink = {light = 0, image=7, scale = 2, dur = 100,RGB = {125,125,125},},
	height = 30,
	scale = 0.7,
}

--震地塔普通攻击子弹
_tab_effect[429] = {
	name = "震地塔普通攻击子弹",
	model = "MODEL_EFFECT:PAOTA2_BULLET",
	xlblink = {light = 0,image=7,scale = 0.5, dur = 100,RGB = {125,125,125},},
	height = 30,
	scale = 0.9,
}

_tab_effect[430] = {
	name = "LV1 炮塔爆炸",
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0, scale = 1.5, dur = 200, RGB = {255,100,0},},
	height = 15,
	scale = 2,
}

_tab_effect[431] = {
	name = "LV1 炮塔爆炸",
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 2,dur = 200,RGB = {255,100,0},},
	height = 15,
	scale = 2.5,
}

_tab_effect[432] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "破胆一喝",
	scale = 1.2,
	height = 20,
}


_tab_effect[433] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 5,dur = 700,RGB = {255,0,0},},
	name = "必杀光效--红--长",
	scale = 10,
	height = 20,
}

--青龙乱舞
_tab_effect[435] = {
	model = "MODEL_EFFECT:whirlwind",
	name = "青龙乱舞",
	scale = 1.5,
	height = 20,
}

_tab_effect[436] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,255,0},},
	name = "人物光效--绿--脚底",
	scale = 1,
	height = 20,
}

_tab_effect[437] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "程远志攻击",
	height = 0,
	scale = 1.5,
	RGB = {255,0,0},
}

_tab_effect[438] = {
	model = "MODEL_EFFECT:Z_raid_red",
	name = "Z突袭——红色",
	scale = 0.6,
	height = 100,
}

--塔基2
_tab_effect[439] = {
	model = "MODEL_EFFECT:td_h1",
	name = "火塔1",
	height = -5,
	scale = 0.7,
}
--塔基2
_tab_effect[440] = {
	model = "MODEL_EFFECT:td_h2",
	name = "火塔2",
	height = -5,
	scale = 0.7,
}

_tab_effect[441] = {
	model = "MODEL_EFFECT:Aura_2",
	name = "liannu",
	height = 0,
	scale = 0.5,
}


_tab_effect[442] = {
	model = "MODEL_EFFECT:Acid01",
	name = "毒塔",
	height = 50,
	scale = 1,
	box = {0,0,12,12},
}

_tab_effect[443] = {
	model = "MODEL_EFFECT:Fire02",
	name = "燃烧的火",
	scale = 0.4,
	height = 50,
}


--td毒塔箭矢
_tab_effect[444] = {
	model = "MODEL_EFFECT:JIANTA2_BULLET",
	name = "毒塔箭矢",
	xlblink = {light = 0,image=15,scale = 0.2,dur = 100,RGB = {0,255,0},},
	height = 100,
	scale = 0.4,
	RGB = {0,255,0},
}

_tab_effect[445] = {
	model = "MODEL_EFFECT:blackfog1",
	name = "炮塔发射",
	scale = 0.4,
	height = 50,
}

_tab_effect[446] = {
	model = "MODEL_EFFECT:Arrow_1",
	name = "箭矢3",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,0},},
	height = 0,
	scale = 0.85,
}

--塔基2
_tab_effect[447] = {
	model = "MODEL_EFFECT:td_d2",
	name = "雷塔2",
	height = -5,
	scale = 0.7,
}

_tab_effect[448] = {
	model = "MODEL_EFFECT:LightningHit_3",
	xlblink = {light = 1,image=0,scale = 1.5,dur = 300,RGB = {10,10,255},},
	name = "闪电光效",
	scale = 1,
	height = 30,
}

_tab_effect[449] = {
	model = "MODEL_EFFECT:LightningHit_3",
	--xlblink = {light = 1,image=0,scale = 1.5,dur = 300,RGB = {10,255,10},},
	name = "缩小光效",
	scale = 1,
	height = 30,
	RGB = {185,255,185},
}

_tab_effect[450] = {
	model = "MODEL_EFFECT:shadowball",
	xlblink = {light = 1,image=0,scale = 0.8,dur = 300,RGB = {255,50,255},},
	name = "法术塔攻击",
	scale = 0.8,
	height = 20,
}

_tab_effect[451] = {
	model = "MODEL_EFFECT:shadowball_explosion",
	name = "闪电光效",
	scale = 1,
	height = 30,
}


_tab_effect[452] = {
	model = "MODEL_EFFECT:laserball",
	name = "箭矢1",
	xlblink = {light = 1,image=0,scale = 0.1,dur = 200,RGB = {0,0,255},},
	height = 100,
	scale = 1.5,
--	RGB = {255,100,100},
}

_tab_effect[453] = {
	model = "UI:explosive02",
	name = "关卡底座",
	scale = 1.15,
	height = 999,
}

_tab_effect[454] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "人物光效(小)--红",
	scale = 0.5,
	height = 20,
}

--冰塔
_tab_effect[455] = {
	model = "MODEL_EFFECT:td_b2",
	name = "冰塔",
	height = -5,
	scale = 0.7,
}

_tab_effect[456] = {
	model = "MODEL_EFFECT:bolang",
	name = "减速",
	height = 0,
	scale = 2,
}

--绿色旗子
_tab_effect[457] = {
	model = "MODEL_EFFECT:flag_green",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "绿色旗子",
	scale = 1,
	height = 20,
}

--红色旗子
_tab_effect[458] = {
	model = "MODEL_EFFECT:flag_red",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "绿色旗子",
	scale = 1,
	height = 20,
}

--_tab_effect[998] = {
--	model = "MODEL_EFFECT:EndPoint",
--	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
--	name = "终点",
--	scale = 1,
--	height = -100,
--}

--连弩塔底座
_tab_effect[459] = {
	model = "MODEL_EFFECT:JIANTA1_BASE",
	name = "连弩塔底座",
	height = -5,
	scale = 0.7,
}

--大火球
_tab_effect[460] = {
	model = "MODEL_EFFECT:fireball_01",
	xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "火弹攻击",
	scale = 2,
	height = 30,
	box = {0,0,45,45},
}

_tab_effect[461] = {
	model = "MODEL_EFFECT:Fire02",
	name = "燃烧的火",
	scale = 1.0,
	height = 50,
}

--毒塔底座
_tab_effect[462] = {
	model = "MODEL_EFFECT:JIANTA2_BASE",
	name = "毒塔底座",
	height = -5,
	scale = 0.7,
}

--巨炮塔底座
_tab_effect[463] = {
	model = "MODEL_EFFECT:PAOTA2_BASE",
	name = "巨炮塔底座",
	height = -5,
	scale = 0.6,
}

--滚石塔底座
_tab_effect[464] = {
	model = "MODEL_EFFECT:PAOTA1_BASE",
	name = "滚石塔底座",
	height = -5,
	scale = 0.6,
}

--狙击塔底座
_tab_effect[465] = {
	model = "MODEL_EFFECT:JIANTA3_BASE",
	name = "狙击塔底座",
	height = -5,
	scale = 0.7,
}

--爆弹兵子弹
_tab_effect[466] = {
	model = "MODEL_EFFECT:PAOTA2_BULLET",
	name = "爆弹兵子弹",
	xlblink = {light = 0,image=0,scale = 0.3,dur = 1000,RGB = {0,0,0},},
	height = 40,
	scale = 1.0,
	--RGB = {250,200,100},
}


_tab_effect[467] = {
	model = "MODEL_EFFECT:HealArea2",
	xlblink = {image=0,scale = 1.0,dur = 300,RGB = {150,0,255},},
	name = "望梅止渴",
	height = 0,
	scale = 1.5,
	RGB = {150,0,255},
}

_tab_effect[468] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {image=0,scale = 4,dur = 700,RGB = {50,50,255},},
	name = "爆炸光效--蓝1",
	scale = 0.01,
	height = 20,
}

_tab_effect[469] = {
	name = "LV1 炮塔爆炸",
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 1,dur = 200,RGB = {255,100,0},},
	height = 15,
	scale = 1,
}

--巨大冰锥
_tab_effect[470] = {
	model = "MODEL_EFFECT:ice_spike_01",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {50,50,255},},
	name = "巨大冰锥",
	scale = 1.3,
	height = 20,
}


_tab_effect[471] = {
	model = "MODEL_EFFECT:GlacialSpike",
--	xlblink = {light = 1,image=10,scale = 4.0,dur = 400,RGB = {50,50,255},},
	name = "冰锥3",
	height = 0,
	scale = 0.8,
}

--爆弹兵子弹
_tab_effect[472] = {
	model = "MODEL_EFFECT:PAOTA1_BULLET",
	name = "爆弹兵子弹",
	xlblink = {image=14,scale = 0.5,dur = 1000,RGB = {30,30,30},},
	--xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,255,0},},
	height = 40,
	scale = 1.0,
	RGB = {160,160,160},
}

--青釭
_tab_effect[473] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "青釭",
	height = 0,
	scale = 1.3,
	RGB = {0,150,250},
}


_tab_effect[474] = {
	model = "MODEL_EFFECT:MoveCircle2",
	name = "破甲",
	height = 10,
	scale = 1,
	RGB = {100,0,255},
}

_tab_effect[475] = {
	model = "MODEL_EFFECT:Defend_1",
	name = "双龙护体",
	height = 30,
	scale = 0.7,
}

_tab_effect[476] = {
	model = "MODEL_EFFECT:wushuang1",
	name = "吕布无双",
	scale = 1.5,
	height = 80,
}

_tab_effect[477] = {
	model = "MODEL_EFFECT:laserballX",
	name = "箭矢1",
--	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {255,0,0},},
	height = 100,
	scale = 1.3,
	RGB = {255,0,0},
}

_tab_effect[478] = {
	model = "MODEL_EFFECT:laserballX",
	name = "箭矢1",
--	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {255,0,0},},
	height = 100,
	scale = 1.3,
	RGB = {100,150,250},
}


_tab_effect[479] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "轮斩",
	height = 0,
	scale = 1.3,
	RGB = {250,0,0},
}


_tab_effect[480] = {
	model = "MODEL_EFFECT:kmd",
	name = "孔明灯",
--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 1,
--	RGB = {120,200,0},
}


_tab_effect[481] = {
	--model = "MODEL_EFFECT:dust2",
	xlblink = {image=0,scale = 0.8,dur = 1600,RGB = {200,150,50},},
	name = "场景光效--红",
	scale = 0.5,
	height = 20,
}




--孔明灯爆炸
_tab_effect[482] = {
	model = "MODEL_EFFECT:burst_2",
	name = "孔明灯爆炸",
	scale = 0.5,
	height = 20,
}


_tab_effect[483] = {
	model = "MODEL_EFFECT:burst01",
	name = "孔明灯爆炸2",
	scale = 1.1,
	height = 80,
}

--td-连弩塔箭矢
_tab_effect[484] = {
	model = "MODEL_EFFECT:JIANTA_BULLET",
	name = "连弩塔箭矢",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {127,127,0},},
	height = 100,
	scale = 0.5,
}

_tab_effect[485] = {
	model = "MODEL_EFFECT:seal_2",
--	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,75,0},},
	name = "诛杀",
	scale = 0.5,
	height = 20,
}

_tab_effect[486] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "血月斩",
	height = 0,
	scale = 0.8,
	RGB = {250,0,0},
	box = {0,-10,60,40},
}

_tab_effect[487] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "轮斩",
	height = 0,
	scale = 0.8,
	box = {0,-10,60,40},
}

--td打塔的投石车特效
_tab_effect[488] = {
	model = "MODEL_EFFECT:stoneTD",
	xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "投石",
	height = 0,
	scale = 0.5,
}


_tab_effect[489] = {
	model = "MODEL_EFFECT:unparalleled",
--	xlblink = {image=0,scale = 0.8,dur = 1000,RGB = {200,200,0},},
	name = "加攻",
	height = 0,
	scale = 0.8,
	RGB = {200,50,50},
}


_tab_effect[490] = {
	model = "MODEL_EFFECT:Fire06",
	name = "天火",
	height = 0,
	scale = 1.1,
}

_tab_effect[491] = {
	model = "MODEL_EFFECT:Fire01",
	name = "巨大火圈",
	height = 0,
	scale = 1.5,
}

_tab_effect[492] = {
	model = "MODEL_EFFECT:FireAura",
--	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环（大）",
	height = -20,
	scale = 0.8,
}

_tab_effect[493] = {
	model = "MODEL_EFFECT:FireAura",
--	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环（小）",
	height = -20,
	scale = 0.5,
}

_tab_effect[494] = {
	model = "MODEL_EFFECT:Z_raid",
--	xlblink = {light = 1,image=0,scale = 1.2,dur = 300,RGB = {255,100,255},},
	name = "鞭影",
	scale = 0.5,
	height = 50,
	RGB = {255,100,255},
}

_tab_effect[495] = {
	model = "MODEL_EFFECT:Fire03",
	name = "狼毒花",
	scale = 0.4,
	height = 50,
	RGB = {255,0,0},
}

_tab_effect[496] = {
	model = "MODEL_EFFECT:Fire03",
	name = "陈宫 聚毒",
	scale = 0.6,
	height = 50,
	RGB = {255,255,0},
}


_tab_effect[497] = {
	model = "MODEL_EFFECT:Ground02",
	name = "地面02",
	height = -100,
	scale = 0.6,
	RGB = {255,255,0},
}


_tab_effect[498] = {
	model = "MODEL_EFFECT:lc",
	name = "粮仓",
	height = -20,
	scale = 0.8,
}

_tab_effect[499] = {
	model = "MODEL_EFFECT:fx",
	name = "废墟",
	height = 50,
	scale = 0.7,
}

_tab_effect[500] = {
	model = "MODEL_EFFECT:LifeSteal",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,100,100},},
	name = "嗜血爪",
	scale = 1.5,
	height = 20,
}


_tab_effect[501] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "陈到飞矛",
	height = 0,
	scale = 0.7,
	box = {0,-10,50,30},
	RGB = {255,0,0},
}

_tab_effect[502] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "陈到飞矛",
	height = 0,
	scale = 1.2,
	box = {0,-10,60,40},
	RGB = {255,0,0},
}

_tab_effect[503] = {
	model = "MODEL_EFFECT:laserball2",
	name = "陈登 飞箭",
	height = 0,
	scale = 1.4,
	box = {0,-10,40,20},
}

--青龙乱舞
_tab_effect[504] = {
	model = "MODEL_EFFECT:whirlwind",
	name = "青龙乱舞",
	scale = 1.5,
	height = 20,
	box = {0,40,120,100},
}



_tab_effect[505] = {
	model = "MODEL_EFFECT:ForceShield",
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,0},x=0,y=42},
	name = "蜉蝣",
	scale = 0.4,
	height = 20,
--	RGB = {255,10,10},
}


_tab_effect[506] = {
	model = "MODEL_EFFECT:Arrow05",
	name = "月下美人",
	height = 0,
	scale = 0.5,
}

_tab_effect[507] = {
	model = "MODEL_EFFECT:Arrow05",
	name = "月下美人",
	height = 0,
	scale = 1.5,
}

_tab_effect[508] = {
	model = "MODEL_EFFECT:banner4",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "旗帜（曹）",
	scale = 1,
	height = -100,
}

_tab_effect[509] = {
	model = "MODEL_EFFECT:dust2",
--	xlblink = {scale = 1.0,dur = 150,RGB = {255,255,255},},
	name = "战争践踏(小)",
	height = 0,
	scale = 1,
}
_tab_effect[510] = {
	name = "LV1 炮塔爆炸",
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 1,dur = 200,RGB = {255,100,0},},
	height = 15,
	scale = 1.2,
}

--滚石塔 - 滚石
_tab_effect[511] = {
	model = "MODEL_EFFECT:gunshi",
	name = "滚石塔 - 滚石",
	height = 0,
	scale = 0.5,
	box = {10, 0, 55, 55},
}

--纪灵旋风
_tab_effect[512] = {
	model = "MODEL_EFFECT:whirlwind",
	name = "纪灵旋风",
	scale = 0.8,
	height = 20,
	box = {0,-20,100,80},
	RGB = {255,0,0},
}

--纪灵大旋风
_tab_effect[513] = {
	model = "MODEL_EFFECT:whirlwind",
	name = "纪灵旋风",
	scale = 1.3,
	height = 20,
	box = {0,-20,100,80},
	RGB = {255,0,0},
}

_tab_effect[514] = {
	model = "MODEL_EFFECT:banner5",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "旗帜（袁）",
	scale = 1,
	height = -100,
}


_tab_effect[515] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "袁术剑气",
	height = 0,
	scale = 0.7,
	box = {0,-10,50,30},
	RGB = {255,50,255},
}

_tab_effect[516] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "袁术剑气（大）",
	height = 0,
	scale = 1.2,
	box = {0,-10,60,40},
	RGB = {255,0,200},
}


_tab_effect[517] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "袁术攻击",
	height = 0,
	scale = 1.5,
	RGB = {255,0,200},
}

_tab_effect[518] = {
	model = "MODEL_EFFECT:Z_raid",
	name = "Z突袭——红色",
	scale = 0.6,
	height = 100,
	RGB = {255,0,200},
}

_tab_effect[519] = {
	model = "MODEL_EFFECT:ForceShield",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,255,0},},
	name = "护盾",
	scale = 0.5,
	height = 20,
	RGB = {0,255,0},
}


--td-连弩塔箭矢
_tab_effect[520] = {
	model = "MODEL_EFFECT:JIANTA_BULLET",
	name = "连弩塔箭矢",
	--xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {127,127,0},},
	height = 100,
	scale = 0.3,
	--RGB = {255,255,0},
}

--滚石塔底座
_tab_effect[521] = {
	model = "MODEL_EFFECT:td_gs",
	name = "滚石塔底座",
	height = -5,
	scale = 0.6,
}

_tab_effect[522] = {
	model = "MODEL_EFFECT:Mana01",
	name = "黑洞",
	height = -999,
	scale = 3.6,
	RGB = {0,0,0},
}

--盾牌
_tab_effect[523] = {
	model = "MODEL_EFFECT:dd",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "盾牌",
	scale = 1.3,
	height = 20,
}

_tab_effect[524] = {
	model = "MODEL_EFFECT:gunshi",
	xlblink = {light = 0,image=7,scale = 0.5, dur = 100,RGB = {255,255,255},},
	name = "小型投石",
	height = 0,
	scale = 0.1,
}

_tab_effect[525] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "许褚攻击",
	scale = 0.8,
	height = 20,
	RGB = {0,0,0},
}

_tab_effect[526] = {
	model = "MODEL_EFFECT:FireAura",
--	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环（大）",
	height = -20,
	scale = 0.7,
	RGB = {0,0,0},
}

_tab_effect[527] = {
	model = "MODEL_EFFECT:charge",
	name = "冲锋尘土",
	scale = 2,
	height = -1,
}

_tab_effect[528] = {
	model = "MODEL_EFFECT:Smoke01",
	name = "烟雾1小",
	height = 0,
	scale = 1,
}

_tab_effect[529] = {
	model = "MODEL_EFFECT:LifeSteal",
--	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,100,100},},
	name = "嗜血爪",
	scale = 1.5,
	height = 20,
}
_tab_effect[530] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "dianwei",
	scale = 0.8,
	height = 20,
	RGB = {50,0,0},
}

_tab_effect[531] = {
	model = "MODEL_EFFECT:break_down",
	name = "dianwei",
	scale = 1.4,
	height = 20,
	--RGB = {200,150,0},
}

_tab_effect[532] = {
	model = "MODEL_EFFECT:Fire04",
	name = "火焰4",
	height = -20,
	scale = 0.8,
	RGB = {255,150,0},
}

_tab_effect[533] = {
	model = "MODEL:UNIT_Phoenix",
	xlblink = {image=0,scale = 2,dur = 1000,RGB = {255,150,0},},
	name = "凤凰飞行",
	scale = 1.3,
	height = 20,
	RGB = {255,150,0},
	box = {0, 30, 100, 100},
}


_tab_effect[534] = {
	model = "MODEL_EFFECT:Fire06",
	xlblink = {image=0,scale = 1.5,dur = 450,RGB = {255,150,0},},
	name = "天火",
	height = 0,
	scale = 2,
}

_tab_effect[535] = {
	model = "MODEL_EFFECT:Summon_1",
	xlblink = {image=0,scale = 5,dur = 300,RGB = {255,150,0},},
	name = "爆炸光效--红2",
	scale = 2.6,
	height = 5,
}

_tab_effect[536] = {
	model = "MODEL_EFFECT:Smoke01",
	name = "烟雾1小",
	height = 0,
	scale = 2,
}

_tab_effect[537] = {
	model = "MODEL_EFFECT:burst_1",
	xlblink = {image=0,scale = 1.5,dur = 450,RGB = {255,150,0},},
	name = "天火",
	height = 30,
	scale = 2.8,
}

_tab_effect[538] = {
	model = "MODEL_EFFECT:whirlwind_f",
	name = "dianwei",
	scale = 1.1,
	height = 20,
	RGB = {50,0,0},
}

--塔基禁用的特效
_tab_effect[539] = {
	model = "MODEL_EFFECT:TAJI_BAN",
	name = "dianwei",
	scale = 0.4,
	height = 50,
	--RGB = {0,0,0},
}

--PVP-箭雨（普通箭）
_tab_effect[540] = {
	model = "MODEL_EFFECT:Arrow_1",
	--xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "PVP-箭雨（普通箭）",
	scale = 1,
	height = 20,
	--RGB = {255,100,0},
}

--爆炎
_tab_effect[541] = {
	model = "MODEL_EFFECT:fireball2",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "爆炎",
	scale = 1,
	height = 30,
}

_tab_effect[542] = {
	model = "MODEL_EFFECT:shield01",
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,0},x=0,y=42},
	name = "张飞护盾",
	scale = 1,
	height = 20,
	RGB = {0,0,0},
}

_tab_effect[543] = {
	model = "MODEL_EFFECT:ForceShield",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "红球",
	scale = 0.5,
	height = 20,
	RGB = {255,0,0},
}

--PVP-狗雨（蜀国）
_tab_effect[544] = {
	model = "MODEL_EFFECT:Arrow_emoji",
	--xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "狗雨",
	scale = 1,
	height = 20,
	--RGB = {255,100,0},
}


_tab_effect[545] = {
	model = "MODEL_EFFECT:emoji_1",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "表情1",
	scale = 1,
	height = 10,
}

--PVP-狗雨（魏国）
_tab_effect[546] = {
	model = "MODEL_EFFECT:Arrow_emojiex",
	--xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "狗雨",
	scale = 1,
	height = 20,
	--RGB = {255,100,0},
}

_tab_effect[547] = {
	model = "MODEL_EFFECT:dd2",
	name = "减防1",
	height = 0,
	scale =	0.6,

}

_tab_effect[548] = {
	model = "MODEL_EFFECT:xianjing_1",
	name = "陷阱1",
	height = 0,
	scale =	0.65,

}

_tab_effect[549] = {
	model = "MODEL_EFFECT:xianjing_2",
	name = "陷阱2",
	height = 20,
	scale =	1,

}

_tab_effect[550] = {
	model = "MODEL_EFFECT:xianjing_2_1",
	name = "陷阱2—阴影",
	height = 0,
	scale =	1,

}


_tab_effect[551] = {
	model = "MODEL_EFFECT:xianjing_1",
	name = "陷阱1(准备状态)",
	height = 0,
	scale =	0.65,
	--RGB = {0,0,0},

}


_tab_effect[552] = {
	model = "MODEL_EFFECT:MoveCircle2",
	name = "中陷阱",
	scale = 1.0,
	height = 100,
	--RGB = {255,0,0},
}

_tab_effect[553] = {
	model = "MODEL_EFFECT:fear",
	name = "恐惧",
	scale = 0.5,
	height = 20,
	RGB = {255,0,0},
}


--滚石塔 - 滚石
_tab_effect[554] = {
	model = "MODEL_EFFECT:gunshi",
	name = "滚石塔 - 滚石",
	height = 0,
	scale = 0.3,
	box = {10, 0, 55, 55},
	RGB = {255,0,0},
}

_tab_effect[555] = {
	model = "MODEL_EFFECT:whirlwind",
	--xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "带碰撞盒的旋风（小）",
	height = 0,
	scale = 0.6,
	--RGB = {250,0,0},
	box = {0,-10,40,20},
}


_tab_effect[556] = {
	model = "MODEL_EFFECT:burst_3",
	--xlblink = {image=0,scale = 1.7,dur = 150,RGB = {200,150,50},},
	name = "受击特效--红色大",
	scale = 1.3,
	height = 999,
	RGB = {255,0,0},
}


_tab_effect[557] = {
	model = "MODEL_EFFECT:burst_3",
	--xlblink = {image=0,scale = 1.7,dur = 150,RGB = {200,150,50},},
	name = "受击特效--黑色大",
	scale = 1.0,
	height = 999,
	RGB = {0,0,0},
}

_tab_effect[558] = {
	model = "MODEL_EFFECT:whirlwind",
	--xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "带碰撞盒的旋风（小）",
	height = 0,
	scale = 0.9,
	--RGB = {250,0,0},
	box = {0,-10,40,20},
}

_tab_effect[559] = {
	model = "MODEL_EFFECT:bolang",
	name = "踏浪",
	height = 0,
	scale = 0.9,
	--RGB = {0,0,255},
}


_tab_effect[560] = {
	model = "MODEL_EFFECT:Fire04",
	name = "火焰4",
	height = -15,
	scale = 1.05,
	RGB = {255,150,0},
}


_tab_effect[561] = {
	model = "MODEL_EFFECT:Fire04",
	name = "火焰4",
	height = -12,
	scale = 1.3,
	RGB = {255,150,0},
}

_tab_effect[562] = {
	model = "MODEL_EFFECT:teleport2",
	xlblink = {image=0,scale = 1.4,dur = 1000,RGB = {0,50,255},},
	name = "闪现",
	scale = 1.5,
	height = 20,
}


_tab_effect[563] = {
	model = "MODEL_EFFECT:Defend_1",
	name = "防御_1",
	height = -1,
	scale = 0.7,
	--RGB = {0,0,0},
}


_tab_effect[564] = {
	model = "MODEL_EFFECT:bolang",
	name = "水潭",
	height = 0,
	scale = 2.5,
	--RGB = {0,0,255},
}

_tab_effect[565] = {
	model = "MODEL_EFFECT:Arrow_1",
	name = "炮轰箭矢",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {125,125,125},},
	height = 0,
	scale = 0.7,
	box = {0,-10,30,20},
}

_tab_effect[566] = {
	model = "MODEL_EFFECT:shield01",
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,0},x=0,y=42},
	name = "孙策护盾",
	scale = 1,
	height = 20,
	--RGB = {255,255,255},
}

--表情（碰撞）
_tab_effect[567] = {
	model = "MODEL_EFFECT:Arrow_emojiex",
	--xlblink = {image=0,scale = 2.0,dur = 500,RGB = {0,0,0},},
	name = "表情（碰撞）",
	scale = 1.1,
	height = 20,
	box = {0,0,40,40},
}

--随身特效-绿色护盾
_tab_effect[568] = {
	model = "MODEL_EFFECT:Aura04",
	name = "随身特效-绿色护盾",
	height = 0,
	scale = 0.8,
}

--黑圈
_tab_effect[569] = {
	model = "MODEL_EFFECT:hit",
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,0},x=0,y=42},
	name = "黑圈",
	height = 20,
	scale = 0.5,
}


--混乱特效
_tab_effect[570] = {
	model = "MODEL_EFFECT:Arrow_emojiex",
	--xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "混乱特效",
	scale = 0.8,
	height = 20,
	--RGB = {255,100,0},
}

--PVP-箭雨（毒箭）
_tab_effect[571] = {
	model = "MODEL_EFFECT:Arrow_3",
	--xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "PVP-箭雨（毒箭）",
	scale = 1,
	height = 20,
	--RGB = {255,100,0},
}


_tab_effect[572] = {
	model = "MODEL_EFFECT:Acid_1",
	name = "酸液",
	height = 0,
	scale = 0.5,
	RGB = {255,0,0},
}


--黄龙勾连
_tab_effect[573] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "黄龙勾连",
	height = 0,
	scale = 1.3,
	RGB = {255,255,0},
}

--吹风特效
_tab_effect[574] = {
	model = "MODEL_EFFECT:whirlwind2",
	name = "吹风特效",
	scale = 0.5,
	height = 20,
}

_tab_effect[575] = {
	model = "MODEL_EFFECT:JIANTA_BULLET",
	name = "高级炮轰箭矢",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {125,125,125},},
	height = 0,
	scale = 0.3,
	box = {0,-10,30,20},
}

_tab_effect[576] = {
	model = "MODEL_EFFECT:WarStomp",
	xlblink = {scale = 2.0,dur = 150,RGB = {255,255,255},},
	name = "红色战争践踏",
	height = 0,
	scale = 2.7,
	RGB = {120,10,10},
}

_tab_effect[577] = {
	model = "MODEL_EFFECT:burst_1",
	xlblink = {image=0,scale = 3.0,dur = 100,RGB = {255,150,0},},
	name = "炎爆_中",
	scale = 1.8,
	height = 20,
}

_tab_effect[578] = {
	model = "MODEL_EFFECT:atk_buff",
	name = "进攻1",
	scale =	0.7,
	height = 20,

}

--防御
_tab_effect[579] = {
	model = "MODEL_EFFECT:dd",
	xlblink = {image=0,scale = 2.0,dur = 300,RGB = {0,0,255},x=0,y=-20},
	name = "防御",
	scale = 0.5,
	height = 20,
}

_tab_effect[580] = {
	model = "MODEL_EFFECT:Fire04",
	name = "巨大火焰",
	height = -12,
	scale = 1.5,
	RGB = {255,0,0},
}


_tab_effect[581] = {
	model = "MODEL_EFFECT:PAOTA1_BULLET",
	xlblink = {image=0,scale = 1.5,dur = 500,RGB = {255,150,0},},
	name = "巨大炮弹",
	height = 30,
	scale = 1.8,
	RGB = {255,125,125},
}

_tab_effect[582] = {
	model = "MODEL_EFFECT:atk_buff",
	name = "进攻1",
	height = 0,
	scale =	1,
	height = 20,
	RGB = {255,0,0},
}

_tab_effect[583] = {
	model = "MODEL_EFFECT:JIANTA_BULLET",
	name = "狙击塔战术卡--穿云箭",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {127,127,0},},
	height = 0,
	scale = 0.5,
	box = {0,-10,30,20},
}

_tab_effect[584] = {
	model = "MODEL_EFFECT:atk_buff",
	name = "进攻（绿）",
	height = 0,
	scale =	0.7,
	height = 20,
	RGB = {0,255,0},
}

_tab_effect[585] = {
	name = "冲锋尘土",
	height = 0,
	scale = 1,
	box = {0,0,60,60},
}


_tab_effect[586] = {
	model = "MODEL_EFFECT:fireball_02",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林2-1",
	scale = 1.0,
	height = 30,
	box = {0,-15,20,10},
}

_tab_effect[587] = {
	model = "MODEL_EFFECT:fireball_01",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林",
	scale = 0.3,
	height = 30,
	box = {0,0,20,10},
}

_tab_effect[588] = {
	model = "MODEL_EFFECT:fireball_03",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林2-2",
	scale = 1.0,
	height = 30,
	box = {0,15,20,10},
}

_tab_effect[589] = {
	model = "MODEL_EFFECT:fireball_01",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林",
	scale = 0.6,
	height = 30,
	box = {0,0,20,10},
}

_tab_effect[590] = {
	model = "MODEL_EFFECT:Fire02",
	name = "巨眼受击",
	scale = 1,
	height = 50,
}

_tab_effect[591] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "红色激光",
--	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {125,125,125},},
	scale = 1,
	height = 1,
	box = {0,0,20,20},
	RGB = {255,0,0},
}

_tab_effect[592] = {
	model = "MODEL_EFFECT:bomb2_01",
	--xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {10,10,255},},
	name = "炸弹",
	scale = 0.4,
	height = 20,
}


--燃烧
_tab_effect[593] = {
	model = "MODEL_EFFECT:fireball-buff",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "燃烧",
	scale = 0.6,
	height = 30,
	box = {35,-60,130,50},
}

_tab_effect[594] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "红色激光-大",
--	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {125,125,125},},
	scale = 3,
	height = 0,
	box = {0,0,30,30},
	RGB = {255,0,0},
}

_tab_effect[595] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "激光--蓝色",
	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {128,255,255},},
	scale = 3.0,
	height = 999,
	box = {0,-10,10,10},
}


_tab_effect[596] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "激光--蓝色大",
--	xlblink = {image=0,scale = 2.0,dur = 500,RGB = {125,125,125},},
	scale = 4,
	height = 0,
	box = {0,-10,60,40},
}


_tab_effect[597] = {
	model = "MODEL_EFFECT:teleport",
	xlblink = {image=0,scale = 1.4,dur = 1000,RGB = {0,50,255},},
	name = "传送--红",
	scale = 1,
	height = 20,
	RGB = {255,0,0},
}

_tab_effect[598] = {
	model = "MODEL_EFFECT:flycannon_huojian",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "导弹",
	scale = 0.3,
	height = 30,
	box = {70,0,10,10},
}

_tab_effect[599] = {
	name = "子弹无特效",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.1,
	box = {0,0,50,50},
}

_tab_effect[600] = {
	model = "MODEL_EFFECT:laserball",
	name = "扔蛋1",
	xlblink = {light = 1,image=0,scale = 0.1,dur = 200,RGB = {255,0,0},},
	height = 100,
	scale = 1.5,
	RGB = {255,0,0},
	box = {0,0,50,50},
}

_tab_effect[601] = {
	model = "MODEL_EFFECT:bomb3",
	xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "投石",
	height = 0,
	scale = 1,
}

_tab_effect[602] = {
	model = "MODEL_EFFECT:timg",
	name = "眼",
	height = 0,
	scale = 0.5,
}

_tab_effect[603] = {
	model = "MODEL_EFFECT:fireball_02",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林2-1",
	scale = 0.5,
	height = 30,
	box = {0,-15,20,10},
}

_tab_effect[604] = {
	model = "MODEL_EFFECT:fireball_03",
	--xlblink = {image=0,scale = 0.5,dur = 500,RGB = {200,150,100},},
	name = "加特林2-2",
	scale = 0.5,
	height = 30,
	box = {0,15,20,10},
}

_tab_effect[605] = {
	model = "MODEL:UNIT_JEEP_SPIDER",
	name = "机械蜘蛛",
	height = 0,
	scale = 0.3,
}

_tab_effect[606] = {
	model = "MODEL:UNIT_ROBOT",
	name = "机器人",
	height = 0,
	scale = 1,
}
_tab_effect[607] = {
	model = "MODEL:UNIT_BALL_ROBOT",
	name = "球形机器人",
	height = 0,
	scale = 1,
}
_tab_effect[608] = {
	model = "MODEL:UNIT_RAMIEL",
	name = "菱形机器人",
	height = 0,
	scale = 1,
}

_tab_effect[609] = {
	model = "MODEL:SUPER_ROBOT",
	name = "超级机器人",
	height = 0,
	scale = 1,
}
_tab_effect[610] = {
	model = "MODEL:UNIT_YODA",
	name = "尤达",
	height = 0,
	scale = 1,
	RGB = {125,125,125},
}

_tab_effect[611] = {
	model = "MODEL:UNIT_YODA",
	name = "尤达BOSS",
	height = 0,
	scale = 1,
}

--弹弹蛋爆炸
_tab_effect[612] = {
	model = "MODEL_EFFECT:baozha",
	name = "弹弹蛋大爆炸",
	height = 99,
	scale = 1,
	--box = {0,0,40,40},
}

_tab_effect[613] = {
	model = "MODEL_EFFECT:Roar01",
	name = "咆哮1",
	height = 999,
	scale = 2.0,
}
_tab_effect[614] = {
	model = "MODEL_EFFECT:Roar02",
	name = "咆哮1",
	height = 999,
	scale = 2.0,
}
_tab_effect[615] = {
	model = "MODEL_EFFECT:Roar03",
	name = "咆哮1",
	height = 999,
	scale = 2.0,
}
_tab_effect[616] = {
	model = "MODEL_EFFECT:Roar04",
	name = "咆哮1",
	height = 999,
	scale = 2.0,
}

--毒烟大
_tab_effect[617] = {
	model = "MODEL_EFFECT:smoke06",
	name = "毒烟大",
	scale = 2.0,
	height = 99,
}

_tab_effect[618] = {
	model = "MODEL_EFFECT:Roar01",
	name = "咆哮1",
	height = 999,
	scale = 3.5,
}
_tab_effect[619] = {
	model = "MODEL_EFFECT:Roar02",
	name = "咆哮1",
	height = 999,
	scale = 3.5,
}
_tab_effect[620] = {
	model = "MODEL_EFFECT:Roar03",
	name = "咆哮1",
	height = 999,
	scale = 3.5,
}
_tab_effect[621] = {
	model = "MODEL_EFFECT:Roar04",
	name = "咆哮1",
	height = 999,
	scale = 3.5,
}

_tab_effect[622] = {
	model = "MODEL_EFFECT:ice_explosion2",
	xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰碎裂",
	scale = 0.5,
	height = 20,
	box = {20, 0, 80, 30},
}

_tab_effect[623] = {
	model = "MODEL_EFFECT:shield02",
	--xlblink = {image=0,scale = 1.0,dur = 1200,RGB = {255,0,0},},
	name = "护盾",
	scale = 0.7,
	height = 100,
}

_tab_effect[624] = {
	model = "MODEL_EFFECT:koushui",
	name = "紫色口水",
	height = 20,
	--roll=180,
	scale = 1.0,
	box = {0,0,2,2},
	RGB = {255,0,255},
}

--刺蛇紫色毒液
_tab_effect[625] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "紫色毒液",
	scale = 0.4,
	height = 10,
	box = {0,0,5,5},
	RGB = {255,0,255},
}

_tab_effect[626] = {
	model = "MODEL_EFFECT:shield04",
	--xlblink = {image=0,scale = 1.0,dur = 1200,RGB = {255,0,0},},
	name = "护盾",
	scale = 1.0,
	height = 100,
}

--最后一项
_tab_effect[999] =
{
	model = "MODEL:default",
	name = "特写",
}

_tab_effect[3001] = {
	model = "MODEL_EFFECT:electronic2",
	name = "缩小范围1",
	height = 20,
	scale = 6.3,
}

_tab_effect[3002] = {
	model = "MODEL_EFFECT:electronic2",
	name = "缩小范围2",
	height = 20,
	scale = 7.3,
}

_tab_effect[3003] = {
	model = "MODEL_EFFECT:electronic2",
	name = "缩小范围3",
	height = 20,
	scale = 8.3,
}

_tab_effect[3004] = {
	model = "MODEL_EFFECT:electronic2",
	name = "缩小范围4",
	height = 20,
	scale = 9.3,
}

_tab_effect[3005] = {
	model = "MODEL_EFFECT:electronic2",
	name = "缩小范围5",
	height = 20,
	scale = 10.3,
}


_tab_effect[3006] = {
	model = "MODEL_EFFECT:Roar01",
	name = "咆哮1",
	height = 999,
	scale = 1.4,
}

_tab_effect[3007] = {
	model = "MODEL_EFFECT:HealArea2",
	xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "群疗",
	height = 0,
	scale = 0.8,
}

_tab_effect[3008] = {
	model = "MODEL_EFFECT:mini_dici",
	--xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "地刺",
	height = 0,
	scale = 1.0,
}

_tab_effect[3009] = {
	model = "MODEL_EFFECT:mini_dici",
	--xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "地刺",
	height = 100,
	scale = 1.5,
}

_tab_effect[3010] = {
	model = "MODEL_EFFECT:TD_T3",
	--xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "新塔特效",
	height = 5,
	scale = 1,
}

_tab_effect[3011] = {
	model = "MODEL_EFFECT:FireAura",
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	name = "火焰光环",
	scale = 1,
	height = 20,
}

_tab_effect[3012] = {
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,150,255},},
	model = "MODEL_EFFECT:biaoji",
	name = "BING BING BING",
	height = 999,
	scale = 1.1,
}

_tab_effect[3013] = {
	--xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,150,255},},
	model = "MODEL_EFFECT:xuanfeng",
	name = "龙卷风",
	height = 999,
	scale = 1.0,
	box = {20, 0, 80, 30},
}

_tab_effect[3014] = {
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {255,0,0},},
	model = "MODEL_EFFECT:xuanfeng",
	name = "火焰龙卷风",
	height = 999,
	scale = 1.0,
	RGB = {200,0,0},
}

--冰弹
_tab_effect[3015] = {
	model = "MODEL_EFFECT:ice_spike_01",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {50,50,255},},
	name = "冰弹攻击",
	scale = 0.8,
	height = 20,
	box = {20, 0, 80, 30},
}

_tab_effect[3016] = {
	xlblink = {image=0,scale = 1.2,dur = 700,RGB = {0,0,155},},
	model = "MODEL_EFFECT:xuanfeng",
	name = "冰霜龙卷风",
	height = 999,
	scale = 1.0,
	RGB = {0,100,100},
}

_tab_effect[3017] = {
	model = "MODEL_EFFECT:bomb",
	--xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {10,10,255},},
	name = "炸弹",
	scale = 1,
	height = 20,
}

_tab_effect[3018] = {
	model = "MODEL_EFFECT:dicita",
	--xlblink = {image=7,scale = 3.0,dur = 600,RGB = {100,255,0},},
	name = "新塔特效",
	height = 5,
	scale = 1,
}

_tab_effect[3019] = {
	model = "MODEL_EFFECT:Aura_1",
	name = "雷电阵",
	height = 0,
	scale = 0.5,
}

_tab_effect[3020] = {
	model = "MODEL_EFFECT:LightningHit_1",
	xlblink = {image=2,scale = 6.0,dur = 100,RGB = {0,0,255},},
	name = "雷击",
	scale = 1,
	height = 0,
}

_tab_effect[3021] = {
	model = "MODEL_EFFECT:jianzhen",
	--xlblink = {image=2,scale = 6.0,dur = 100,RGB = {0,0,255},},
	name = "剑落魁斗",
	scale = 1.2,
	height = 20,
}

_tab_effect[3022] = {
	model = "MODEL_EFFECT:shixue2",
	xlblink = {image=0,scale = 0.5,dur = 700,RGB = {0,0,255},},
	name = "冰冷血脉",
	scale = 1.5,
	height = 20,
}

_tab_effect[3023] = {
	model = "MODEL_EFFECT:Aura04_2",
	name = "雷达范围1",
	height = 20,
	scale = 7.5,
	RGB = {238,190,64},
}

_tab_effect[3024] = {
	model = "MODEL_EFFECT:Aura04_2",
	name = "雷达范围2",
	height = 20,
	scale = 8.0,
	RGB = {238,190,64},
}

_tab_effect[3025] = {
	model = "MODEL_EFFECT:Aura04_2",
	name = "雷达范围3",
	height = 20,
	scale = 8.5,
	RGB = {238,190,64},
}

_tab_effect[3026] = {
	model = "MODEL_EFFECT:Aura04_2",
	name = "雷达范围4",
	height = 20,
	scale = 9.0,
	RGB = {238,190,64},
}

_tab_effect[3027] = {
	model = "MODEL_EFFECT:Aura04_2",
	name = "雷达范围5",
	height = 20,
	scale = 9.5,
	RGB = {238,190,64},
}

_tab_effect[3028] = {
	model = "MODEL_EFFECT:ice_explosion3",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰碎裂",
	scale = 30,
	height = 40,
}

_tab_effect[3029] = {
	model = "MODEL_EFFECT:bindong",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "冰冻",
	scale = 0.5,
	height = 40,
}

_tab_effect[3030] = {
	model = "MODEL_EFFECT:huofeng",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "火旋风",
	scale = 1.2,
	height = 40,
}

_tab_effect[3031] = {
	model = "MODEL_EFFECT:NPC1",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "npc1",
	scale = 1.2,
	height = 40,
}

_tab_effect[3032] = {
	model = "MODEL_EFFECT:Blood_New1",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New1",
	scale = 1.0,
	height = 0,
}

_tab_effect[3033] = {
	model = "MODEL_EFFECT:Blood_New2",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New2",
	scale = 1.0,
	height = 0,
}

_tab_effect[3034] = {
	model = "MODEL_EFFECT:Blood_New3",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New3",
	scale = 1.0,
	height = 0,
}


_tab_effect[3035] = {
	model = "MODEL_EFFECT:Blood_2",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_2",
	scale = 1.3,
	height = 0,
}

_tab_effect[3036] = {
	model = "MODEL_EFFECT:Blood_3",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_3",
	scale = 1.1,
	height = 0,
}

_tab_effect[3037] = {
	model = "MODEL_EFFECT:dust",
	xlblink = {image=0,scale = 3.0,dur = 300,RGB = {255,75,0},},
	name = "投石爆炸",
	scale = 1.0,
	height = 0,
}

_tab_effect[3038] = {
	model = "MODEL_EFFECT:Blood_1",
	name = "喷血2",
	height = 0,
	scale = 1.0,
}

--箱子
_tab_effect[3039] = {
	model = "MODEL_EFFECT:BOX",
	--animation = "stand",
	name = "箱子",
	scale = 1.0,
	height = 0,
	box = {0,0,1,1},
}

--箱子爆裂
_tab_effect[3040] = {
	model = "MODEL_EFFECT:BOX_BOOB",
	animation = "stand",
	name = "箱子爆裂",
	scale = 1.2,
	height = 0,
}

--手雷
_tab_effect[3042] = {
	model = "MODEL_EFFECT:shoulei",
	xlblink = {light = 0,image=0,scale = 0.3,dur = 1000,RGB = {0,0,0},},
	name = "手雷",
	height = 0,
	scale = 0.5,
	box = {0, 0, 32, 32},
}

--激光拖尾特效
_tab_effect[3043] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.8,
	box = {0,0,5,5},
	--	RGB = {120,200,0},
}


_tab_effect[3045] = {
	name = "子弹无特效",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.1,
	box = {0,0,20,10},
}

--激光拖尾特效--红色
_tab_effect[3046] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 1,
	box = {0,0,30,30},
	RGB = {255,0,0},
}

_tab_effect[3047] = {
	model = "MODEL_EFFECT:laserball_explosion",
	name = "红色光圈",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 1,
	RGB = {255,128,0},
}

_tab_effect[3048] = {
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "加速",
	height = 0,
	scale = 0.3,
}
--新爆炸特效
_tab_effect[3049] = {
	model = "MODEL_EFFECT:behit_jiguanpao_b",
	name = "behit_jiguanpao_b",
	height = 99,
	scale = 3.0,
}

--蜘蛛死亡特效--小
_tab_effect[3050] = {
	model = "MODEL_EFFECT:Blood_New5",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New5",
	scale = 0.4,
	height = 0,
}

--蜘蛛死亡特效--中
_tab_effect[3051] = {
	model = "MODEL_EFFECT:Blood_New5",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New5",
	scale = 0.75,
	scale = 0.7,
	height = 0,
}

--蜘蛛死亡特效--大
_tab_effect[3052] = {
	model = "MODEL_EFFECT:Blood_New5",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New5",
	scale = 1.25,
	height = 0,
}
--平放的手雷
_tab_effect[3053] = {
	model = "MODEL_EFFECT:shoulei2",
	--xlblink = {light = 0,image=0,scale = 0.3,dur = 1000,RGB = {0,0,0},},
	name = "手雷",
	height = 0,
	scale = 1,
	--box = {0, 0, 32, 32},
}

--新爆炸特效2
_tab_effect[3054] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 1.0,
}

--新爆炸特效(破土而出)
_tab_effect[3055] = {
	model = "MODEL_EFFECT:dusty",
	name = "dusty",
	height = 99,
	scale = 1.0,
}

--新爆炸特效（空中爆炸）
_tab_effect[3056] = {
	model = "MODEL_EFFECT:testbump_a",
	name = "testbump_a",
	height = 99,
	scale = 1.0,
}

--新爆炸特效（破甲弹）
_tab_effect[3057] = {
	model = "MODEL_EFFECT:pjdbz",
	name = "pjdbz",
	height = 99,
	scale = 1.5,
}

_tab_effect[3058] = {
	model = "MODEL_EFFECT:dj_2",
	xlblink = {light = 1,image=0,scale = 3.0,dur = 300,RGB = {50,80,255},},
	name = "卧龙蛋攻击",
	scale = 1,
	height = 20,
	box = {0, 0, 32, 32},
}

_tab_effect[3059] = {
	model = "MODEL_EFFECT:dj_1",
	name = "dj_1",
	height = 99,
	scale = 1.0,
}

--_tab_effect[3060] = {
	--model = "MODEL_EFFECT:bb_energy_anim",
	--name = "BOSS高能子弹1",
	--height = 0,
	--scale = 0.6,
	--box = {0,0,30,30},
	----RGB = {50,50,255},
--}

_tab_effect[3060] = {
	model = "MODEL_EFFECT:pjdbz",
	name = "pjdbz",
	height = 99,
	scale = 1.0,
}

_tab_effect[3061] = {
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "BOSS高能子弹1",
	height = 0,
	scale = 0.3,
	box = {0,0,30,30},
	--RGB = {50,50,255},
}

--生化蜘蛛网弹
_tab_effect[3062] = {
	model = "MODEL_EFFECT:mofadan",
	name = "蛛网弹",
	height = 0,
	scale = 1.2,
	box = {20, 0, 25, 25},
}

--Blood_New6
_tab_effect[3063] = {
	model = "MODEL_EFFECT:Blood_New6",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New6",
	scale = 1.0,
	height = 0,
}

--Blood_New7
_tab_effect[3064] = {
	model = "MODEL_EFFECT:Blood_New7",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "Blood_New6",
	scale = 1.0,
	height = 0,
}

_tab_effect[3065] = {
	model = "MODEL_EFFECT:bb_energy_anim",
	name = "高能子弹（绿色）",
	height = 0,
	scale = 0.45,
	box = {0,0,25,25},
	RGB = {50,255,50},

}

--tnt
_tab_effect[3066] = {
	model = "MODEL_EFFECT:tnt",
	name = "tnt",
	height = 0,
	scale = 0.7,
	box = {0,0,5,5},
}

--大火球
_tab_effect[3067] = {
	model = "MODEL_EFFECT:fireball_02",
	xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "火弹攻击-三发",
	scale = 0.6,
	height = 30,
	box = {0,0,20,10},
}

--圆子弹
_tab_effect[3068] = {
	model = "MODEL_EFFECT:zidan1",
	name = "圆子弹",
	scale = 1.0,
	height = 30,
	box = {0,0,8,8},
}

--飞镖弹
_tab_effect[3069] = {
	model = "MODEL_EFFECT:zidan2",
	name = "飞镖弹",
	scale = 1.0,
	height = 30,
	box = {0,0,11,11},
}


--细子弹
_tab_effect[3070] = {
	model = "MODEL_EFFECT:zidan3",
	name = "细子弹",
	scale = 1.0,
	height = 30,
	box = {0,0,2,8},
}

--胖子弹
_tab_effect[3071] = {
	model = "MODEL_EFFECT:zidan4",
	name = "胖子弹",
	scale = 1.0,
	height = 30,
	box = {0,0,11,11},
}

--圆子弹(小)
_tab_effect[3072] = {
	model = "MODEL_EFFECT:zidan1",
	name = "圆子弹(小)",
	scale = 0.6,
	height = 30,
	box = {0,0,5,5},
}

--闪电圈
_tab_effect[3073] = {
	model = "MODEL_EFFECT:electronic",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "闪电圈",
	scale = 1.0,
	--height = 20,
}

--卡通子弹
_tab_effect[3074] = {
	model = "MODEL_EFFECT:zidan5",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "卡通子弹",
	scale = 1.0,
	--height = 20,
	box = {0,0,5,5},
}

--卡通爆炸效果
_tab_effect[3075] = {
	model = "MODEL_EFFECT:katongbaozha",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "卡通爆炸效果",
	scale = 0.4,
	--height = 20,
}

--卡通爆炸效果
_tab_effect[3076] = {
	model = "MODEL_EFFECT:katongbaozha",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "开枪的火星",
	scale = 0.25,
	--height = 20,
}

--投掷炸弹1
_tab_effect[3077] = {
	model = "MODEL_EFFECT:zhadan",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "投掷炸弹1",
	scale = 0.8,
	height = -20,
}

--投掷炸弹2
_tab_effect[3078] = {
	model = "MODEL_EFFECT:zhadan2",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "投掷炸弹2",
	scale = 1.3,
	height = -20,
}

--新爆炸特效--1级手雷
_tab_effect[3079] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 0.45,
}

--新爆炸特效--2级手雷
_tab_effect[3080] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 0.55,
}

--新爆炸特效--3级手雷
_tab_effect[3081] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 0.6,
}

--新爆炸特效--4级手雷
_tab_effect[3082] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 0.7,
}

--新爆炸特效--5级手雷
_tab_effect[3083] = {
	model = "MODEL_EFFECT:behit_tegong_c",
	name = "behit_tegong_c",
	height = 99,
	scale = 0.8,
}

--光波特效2
_tab_effect[3084] = {
	model = "MODEL_EFFECT:laser2",
	name = "laser2",
	height = 99,
	scale = 0.8,
	box = {0,0,5,5},
}

--光波特效3
_tab_effect[3085] = {
	model = "MODEL_EFFECT:laser3",
	name = "laser2",
	height = 0,
	scale = 1.0,
	box = {0,0,8,8},
}

--光波特效4
_tab_effect[3086] = {
	model = "MODEL_EFFECT:laser4",
	name = "laser2",
	height = 0,
	scale = 1.0,
	box = {0,0,8,8},
}

--光波特效5
_tab_effect[3087] = {
	model = "MODEL_EFFECT:laser5",
	name = "laser2",
	height = 0,
	scale = 1.0,
	box = {0,0,8,8},
}

--光波特效5
_tab_effect[3088] = {
	model = "MODEL_EFFECT:laser7",
	name = "laser7",
	height = 0,
	scale = 1.0,
	box = {0,0,8,8},
}

--闪电特效 蓝
_tab_effect[3089] = {
	model = "MODEL_EFFECT:dinji",
	name = "dinji",
	height = 99,
	scale = 0.8,
	--box = {0,0,40,40},
}

--闪电特效 蓝(大)
_tab_effect[3090] = {
	model = "MODEL_EFFECT:dinji",
	name = "dinji",
	height = 99,
	scale = 1.5,
	--box = {0,0,40,40},
}

--一束闪电
_tab_effect[3091] = {
	model = "MODEL_EFFECT:shandian",
	name = "dinji",
	height = 99,
	scale = 1.0,
	box = {0,0,40,40},
}

--紫闪电圈
_tab_effect[3092] = {
	model = "MODEL_EFFECT:electronic3",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "紫闪电圈",
	scale = 1.0,
	--height = 20,
}

_tab_effect[3093] = {
	model = "MODEL_EFFECT:power_tower",
	name = "能量塔充能",
	--height = 99,
	scale = 1.0,
	--box = {0,0,40,40},
}

--强化台子灯
_tab_effect[3094] = {
	model = "MODEL_EFFECT:guang2",
	name = "强化台子灯",
	--height = 99,
	scale = 1,
	--box = {0,0,40,40},
}


--透明
_tab_effect[3095] = {
	model = "MODEL_EFFECT:touming",
	name = "透明",
	--height = 99,
	scale = 1,
	--box = {0,0,40,40},
}

--导弹
_tab_effect[3096] = {
	model = "MODEL_EFFECT:dadan",
	name = "导弹",
	--height = 99,
	scale = 0.7,
	box = {20,0,20,10},
}

--导弹爆炸
_tab_effect[3097] = {
	model = "MODEL_EFFECT:katongzha",
	name = "导弹爆炸",
	height = 99,
	scale = 1,
	--box = {0,0,40,40},
}


--子弹6
_tab_effect[3098] = {
	model = "MODEL_EFFECT:zidan6",
	name = "小飞镖弹",
	scale = 1.0,
	height = 30,
	box = {0,0,11,11},
}

--子弹7
_tab_effect[3099] = {
	model = "MODEL_EFFECT:zidan7",
	name = "弹7",
	scale = 1.0,
	height = 30,
	box = {0,0,7,7},
}

--卡通开炮
_tab_effect[3100] = {
	model = "MODEL_EFFECT:katongbaozha2",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "开枪的火星",
	scale = 0.45,
	--height = 20,
}

--蓝闪电圈
_tab_effect[3101] = {
	model = "MODEL_EFFECT:electronic2",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "蓝闪电圈",
	scale = 1.0,
	--height = 20,
}

--冰壳
_tab_effect[3102] = {
	model = "MODEL_EFFECT:iced",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "冰壳",
	scale = 1.0,
	--height = 20,
}

--飞机场开口
_tab_effect[3103] = {
	model = "MODEL_EFFECT:airfield_2",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "飞机场",
	scale = 1.0,
	--height = 20,
}

--高射导弹特效
_tab_effect[3104] = {
	model = "MODEL_EFFECT:TK_ATTACK3",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "高射导弹特效",
	scale = 1.0,
	--height = 20,
}

--追踪导弹特效
_tab_effect[3105] = {
	model = "MODEL_EFFECT:DAODAN_TEST",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "追踪导弹特效",
	scale = 0.6,
	height = 2000,
}

--追踪导弹起飞特效
_tab_effect[3106] = {
	model = "MODEL_EFFECT:DAODAN_TEST_UP",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "追踪导弹起飞特效",
	scale = 0.6,
	height = 2000,
}

--绿箭头弹
_tab_effect[3107] = {
	model = "MODEL_EFFECT:zidan12",
	name = "绿箭头弹",
	scale = 1.0,
	height = 30,
	--box = {{11,0,7,7},{4,16,7,7},{4,-16,7,7},{-7,30,7,7},{-7,-30,7,7},},
	box = {0,0,5,5},
}

_tab_effect[3108] = {
	model = "MODEL_EFFECT:hanqi",
	--xlblink = {light = 1,image=0,scale = 5.0,dur = 300,RGB = {0,0,155},},
	name = "寒气",
	scale = 1.5,
	height = 20,
}

--子弹11
_tab_effect[3109] = {
	model = "MODEL_EFFECT:zidan11",
	name = "弹11",
	scale = 0.5,
	height = 30,
	box = {0,0,12,12},
}

--新爆炸特效（空中爆炸） xiao
_tab_effect[3110] = {
	model = "MODEL_EFFECT:burst_2",
	name = "testbump_a",
	height = 99,
	scale = 1.5,
}

--反向大火球（小）黄
_tab_effect[3111] = {
	model = "MODEL_EFFECT:fireball-buff4",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 1.2,
	height = 30,
	box = {20,0,60,20},
}

--反向大火球（小）紫
_tab_effect[3112] = {
	model = "MODEL_EFFECT:fireball-buff3",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 1.2,
	height = 30,
	box = {100,5,100,20},
}

--反向大火球（小）红
_tab_effect[3113] = {
	model = "MODEL_EFFECT:fireball",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 1.2,
	height = 30,
	box = {20,0,60,20},
	RGB = {255,84,11},
}

--反向大火球（小）超级
_tab_effect[3114] = {
	model = "MODEL_EFFECT:fireball-buff5",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "反向大火球（龙息）",
	scale = 1.2,
	height = 30,
	box = {100,5,100,20},
}

--子弹8
_tab_effect[3115] = {
	model = "MODEL_EFFECT:zidan8",
	xlblink = {image=0,scale = 1,dur = 500,RGB = {200,150,100},},
	name = "子弹8",
	scale = 0.55,
	height = 30,
	box = {0,0,5,5},
}


--弹弹蛋爆炸
_tab_effect[3116] = {
	model = "MODEL_EFFECT:baozha",
	name = "弹弹蛋爆炸",
	height = 99,
	scale = 0.4,
	--box = {0,0,40,40},
}

--子弹9
_tab_effect[3117] = {
	model = "MODEL_EFFECT:zidan9",
	xlblink = {image=0,scale = 1,dur = 500,RGB = {200,150,100},},
	name = "子弹8",
	scale = 0.55,
	height = 30,
	box = {0,0,5,5},
}

--子弹10
_tab_effect[3118] = {
	model = "MODEL_EFFECT:zidan10",
	xlblink = {image=0,scale = 1,dur = 500,RGB = {200,150,100},},
	name = "子弹8",
	scale = 0.3,
	height = 30,
	box = {0,0,5,5},
}

--卡通子弹 --高级的
_tab_effect[3119] = {
	model = "MODEL_EFFECT:zidan13",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "卡通子弹",
	scale = 1.0,
	--height = 20,
	box = {0,0,5,5},
}

--卡通子弹 --超级的
_tab_effect[3120] = {
	model = "MODEL_EFFECT:zidan14",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "卡通子弹",
	scale = 1.0,
	--height = 20,
	box = {0,0,5,5},
}

--警告特效
_tab_effect[3121] = {
	model = "MODEL_EFFECT:warning",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "警告特效",
	scale = 0.5,
	--height = 20,
}

--光晕弹
_tab_effect[3122] = {
	model = "MODEL_EFFECT:zidan15",
	name = "光晕弹",
	scale = 1.0,
	--height = 30,
	--box = {{11,0,7,7},{4,16,7,7},{4,-16,7,7},{-7,30,7,7},{-7,-30,7,7},},
	box = {0,0,5,5},
}

_tab_effect[3123] = {
	model = "MODEL_EFFECT:Arrow_07",
	name = "红色激光小",
	scale = 1,
	height = 1,
	box = {0,0,1,1},
	RGB = {255,0,0},
}

--蓝色方形弹
_tab_effect[3124] = {
	model = "MODEL_EFFECT:zidan21",
	name = "蓝色方形弹",
	scale = 1.0,
	--height = 30,
	--box = {{11,0,7,7},{4,16,7,7},{4,-16,7,7},{-7,30,7,7},{-7,-30,7,7},},
	box = {0,0,10,10},
}

_tab_effect[3125] = {
	model = "MODEL_EFFECT:zidan16",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,255,0},},
	name = "毒泡",
	scale = 0.5,
	--height = 20,
	RGB = {180,255,0},
	box = {0,0,10,10},
}


_tab_effect[3126] = {
	model = "MODEL_EFFECT:jiantou",
	name = "箭头光效",
	scale = 1,
	height = 1,
}

--激光拖尾特效1
_tab_effect[3127] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.8,
	box = {0,0,5,5},
	RGB = {200,200,0},
}

--激光拖尾特效2
_tab_effect[3128] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.8,
	box = {0,0,5,5},
	RGB = {200,200,100},
}

--激光拖尾特效3
_tab_effect[3129] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.8,
	box = {0,0,5,5},
	RGB = {255,200,150},
}

--激光拖尾特效4
_tab_effect[3130] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.8,
	box = {0,0,5,5},
	RGB = {255,255,255},
}

_tab_effect[3131] = {
	model = "MODEL_EFFECT:guang",
	name = "光",
	scale = 1,
	height = 1,
}

_tab_effect[3132] = {
	model = "MODEL_EFFECT:dust2",
	name = "导弹粉尘",
	scale = 0.75,
	height = 80,
}

--警告特效
_tab_effect[3133] = {
	model = "MODEL_EFFECT:warning2",
	name = "警告特效2",
	scale = 0.7,
}

_tab_effect[3134] = {
	model = "MODEL_EFFECT:leishe_u",
	name = "镭射向下",
	scale = 1,
}

_tab_effect[3135] = {
	model = "MODEL_EFFECT:leishe_d",
	name = "镭射向上",
	scale = 1,
}

_tab_effect[3136] = {
	model = "MODEL_EFFECT:leishe_l",
	name = "镭射向右",
	scale = 1,
}

_tab_effect[3137] = {
	model = "MODEL_EFFECT:jiantou2",
	name = "箭头光效2",
	scale = 1,
	height = 1,
}

_tab_effect[3138] = {
	model = "MODEL_EFFECT:leishe_r",
	name = "镭射向左",
	scale = 1,
}

_tab_effect[3139] = {
	model = "MODEL_EFFECT:dust2",
	name = "尘土",
	scale = 1.0,
	height = 80,
}

_tab_effect[3140] = {
	model = "MODEL_EFFECT:dusty",
	name = "破土而出",
	height = 99,
	scale = 0.8,
}

_tab_effect[3141] = {
	model = "MODEL_EFFECT:zidan17",
	--xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,255,0},},
	name = "子弹17",
	scale = 1.3,
	--height = 20,
	box = {0,0,10,10},
}

_tab_effect[3142] = {
	model = "MODEL_EFFECT:dusty",
	name = "破土而出-大",
	height = 999,
	scale = 3.0,
}

--提示
_tab_effect[3143] = {
	model = "MODEL_EFFECT:tishi",
	name = "tishi",
	height = 99,
	scale = 0.65,
	box = {0,0,7,7},
}

_tab_effect[3144] = {
	model = "MODEL_EFFECT:zidan19",
	--xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,255,0},},
	name = "子弹17",
	scale = 1.3,
	--height = 20,
	box = {0,0,7,3},
}

_tab_effect[3145] = {
	model = "MODEL_EFFECT:fantanpao",
	name = "fantanpao",
	height = 99,
	scale = 1.0,
	box = {0,0,7,7},
}

_tab_effect[3146] = {
	model = "MODEL_EFFECT:stone01",
	--xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "碎石1",
	scale = 1,
}

_tab_effect[3147] = {
	model = "MODEL_EFFECT:stone02",
	--xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "碎石2",
	scale = 1,
}

_tab_effect[3148] = {
	model = "MODEL_EFFECT:mguncbase000",
	--xlblink = {light = 0,image=14,scale = 0.5,dur = 100,RGB = {125,125,125},},
	name = "碎石2",
	height = -999,
	scale = 1.0,
}

_tab_effect[3149] = {
	model = "MODEL_EFFECT:circle2",
	name = "防护罩",
	scale = 0.6,
	height = 80,
}

_tab_effect[3150] = {
	model = "MODEL_EFFECT:zha",
	name = "TNT boom",
	scale = 1.0,
	height = 80,
}

_tab_effect[3151] = {
	model = "MODEL_EFFECT:fireball2",
	--xlblink = {image=0,scale = 1.2,dur = 500,RGB = {255,150,0},},
	name = "火球-极小",
	scale = 0.7,
	height = 0,
}

_tab_effect[3152] = {
	model = "MODEL_EFFECT:zidan16",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,0,128},},
	name = "毒泡(蓝)",
	scale = 0.5,
	--height = 20,
	--RGB = {255,255,128},
	box = {0,0,10,10},
}

_tab_effect[3153] = {
	model = "MODEL_EFFECT:yingzi",
	--xlblink = {image=0,scale = 0.6,dur = 700,RGB = {0,0,128},},
	name = "影子",
	scale = 1.0,
	height = -200,
	--RGB = {255,255,128},
	box = {0,0,10,10},
}

_tab_effect[3154] = {
	model = "MODEL_EFFECT:fireball8_x",
	name = "十字炸弹火球(小)",
	scale = 0.7,
	RGB = {255,120,255},
	alpha = 150,
}

_tab_effect[3155] = {
	model = "MODEL_EFFECT:circle3",
	name = "吸收罩",
	scale = 0.8,
	height = 80,
}

_tab_effect[3156] = {
	model = "MODEL_EFFECT:circle3",
	name = "吸收罩",
	scale = 0.6,
	height = 80,
}

_tab_effect[3157] = {
	model = "MODEL_EFFECT:burst_3",
	name = "喷血2",
	height = 0,
	scale = 0.5,
}

_tab_effect[3158] = {
	model = "MODEL_EFFECT:burst_3",
	name = "喷血2",
	height = 0,
	scale = 0.8,
}

_tab_effect[3159] = {
	model = "MODEL_EFFECT:burst_3",
	name = "喷血2",
	height = 0,
	scale = 0.95,
}

_tab_effect[3160] = {
	model = "MODEL_EFFECT:burst_3",
	name = "喷血2",
	height = 0,
	scale = 1.05,
}

--测试导弹尘土
_tab_effect[3161] = {
	model = "MODEL_EFFECT:testbump_a",
	name = "测试导弹尘土",
	scale = 0.2,
	height = 80,
}

--导弹发射黑烟
_tab_effect[3162] = {
	model = "MODEL_EFFECT:dust3",
	name = "导弹发射黑烟",
	scale = 1.2,
	height = 80,
}

_tab_effect[3163] = {
	model = "MODEL_EFFECT:jiantou4",
	name = "箭头光效4",
	scale = 1,
	height = 1,
}

--准星
_tab_effect[3164] = {
	model = "MODEL_EFFECT:miaozhun",
	name = "准星",
	height = 80,
	scale = 1.0,
}

--雷神之锤
_tab_effect[3165] = {
	model = "MODEL_EFFECT:thunder",
	name = "雷神之锤",
	height = 80,
	scale = 1.0,
}

--冰壳
_tab_effect[3166] = {
	model = "MODEL_EFFECT:iced",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "冰壳",
	scale = 1.0,
	--height = 20,
}

--十字炸弹火球
_tab_effect[3167] = {
	model = "MODEL_EFFECT:fireball8_x",
	--xlblink = {image=0,scale = 2,dur = 500,RGB = {200,150,100},},
	name = "十字炸弹火球",
	scale = 1.0,
	RGB = {255,120,255},
	--height = 30,
	--box = {0,-10,80,50},
}

_tab_effect[3168] = {
	model = "MODEL_EFFECT:feibiao",
	name = "飞镖",
	scale = 1.0,
	height = 80,
	box = {0,0,7,3},
}

--子弹11
_tab_effect[3169] = {
	model = "MODEL_EFFECT:zidan18",
	name = "弹11",
	scale = 0.5,
	height = 30,
	box = {0,0,12,12},
}

--集装箱1碎片1
_tab_effect[3170] = {
	model = "MODEL_EFFECT:container01_d1",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container01_d1",
	scale = 1.0,
	height = 0,
}

--集装箱1碎片2
_tab_effect[3171] = {
	model = "MODEL_EFFECT:container01_d2",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container01_d2",
	scale = 1.0,
	height = 0,
}

--集装箱1碎片3
_tab_effect[3172] = {
	model = "MODEL_EFFECT:container01_d3",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container01_d3",
	scale = 1.0,
	height = 0,
}

--集装箱2碎片1
_tab_effect[3173] = {
	model = "MODEL_EFFECT:container02_d1",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container02_d1",
	scale = 1.0,
	height = 0,
}

--集装箱2碎片2
_tab_effect[3174] = {
	model = "MODEL_EFFECT:container02_d2",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container02_d2",
	scale = 1.0,
	height = 0,
}

--集装箱2碎片3
_tab_effect[3175] = {
	model = "MODEL_EFFECT:container02_d3",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "container02_d3",
	scale = 1.0,
	height = 0,
}

--刺蛇毒液
_tab_effect[3176] = {
	model = "MODEL_EFFECT:ice_spike_01",
	name = "毒液",
	scale = 0.4,
	height = 10,
	box = {0,0,5,5},
	RGB = {0,255,100},
}

--传送1
_tab_effect[3177] = {
	model = "MODEL_EFFECT:transport1",
	name = "传送1",
	height = -100,
	scale = 1.0,
	--RGB = {0,0,0},
}

--黑色追踪导弹特效
_tab_effect[3178] = {
	model = "MODEL_EFFECT:DAODAN_FLY_BLACK",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "黑色追踪导弹特效",
	scale = 0.6,
	height = 2000,
}

--黑色追踪导弹起飞特效
_tab_effect[3179] = {
	model = "MODEL_EFFECT:DAODAN_UP_BLACK",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "黑色追踪导弹起飞特效",
	scale = 0.6,
	height = 2000,
}

--黑色追踪导弹命中特效
_tab_effect[3180] = {
	model = "MODEL_EFFECT:DAODAN_HIT_BLACK",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "黑色追踪导弹命中特效",
	scale = 0.9,
	height = 2000,
}

_tab_effect[3181] = {
	model = "MODEL_EFFECT:guang3",
	name = "物品光效",
	height = 80,
	scale = 1.0,
}

--测试延时炸弹尘土
_tab_effect[3182] = {
	model = "MODEL_EFFECT:Smoke01",
	name = "延时炸弹",
	scale = 0.5,
	height = 80,
}

--看守所碎片
_tab_effect[3183] = {
	model = "MODEL_EFFECT:prison05",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "prison05",
	scale = 1.0,
	height = 0,
}

_tab_effect[3184] = {
	model = "MODEL_EFFECT:zhua",
	name = "抓",
	height = 20,
	--roll=180,
	scale = 1.0,
}

_tab_effect[3185] = {
	model = "MODEL_EFFECT:koushui",
	name = "口水",
	height = 20,
	--roll=180,
	scale = 1.0,
	box = {0,0,2,2},
}

--看守所墙碎片
_tab_effect[3186] = {
	model = "MODEL_EFFECT:prison_wall03",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "prison_wall03",
	scale = 1.0,
	height = 0,
}

--导弹
_tab_effect[3187] = {
	model = "MODEL_EFFECT:dadan_min",
	name = "导弹",
	--height = 99,
	scale = 0.7,
	box = {20,0,10,10},
}

_tab_effect[3187] = {
	model = "MODEL_EFFECT:Daoguang02",
	name = "刀光02",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,255},},
	height = 20,
	scale = 2.5,
}




_tab_effect[3188] = {
	model = "MODEL_EFFECT:laser6",
	name = "镭射6",
	height = 99,
	--scale = 0.4,
	box = {0,0,10,10},
}

_tab_effect[3189] = {
	model = "MODEL_EFFECT:jiantou3",
	name = "箭头光效3",
	scale = 1,
	height = 1,
}


_tab_effect[3190] = {
	model = "MODEL_EFFECT:Julang",
	name = "巨浪",
	--xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,255},},
	height = 20,
	scale = 1.0,
}

_tab_effect[3191] = {
	model = "MODEL_EFFECT:T_heal",
	name = "红十字",
	--xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,255},},
	height = 20,
	scale = 1.0,
}

_tab_effect[3192] = {
	model = "MODEL_EFFECT:timer01",
	--xlblink = {image=0,scale = 1.0,dur = 1200,RGB = {255,0,0},},
	name = "延时炸弹计时1",
	scale = 0.5,
	height = 3500,
}

_tab_effect[3193] = {
	model = "MODEL_EFFECT:timer02",
	--xlblink = {image=0,scale = 1.0,dur = 1200,RGB = {255,0,0},},
	name = "延时炸弹计时2",
	scale = 0.5,
	height = 3600,
}

_tab_effect[3194] = {
	model = "MODEL_EFFECT:mofadan",
	name = "红色蛛网弹",
	height = 0,
	scale = 1.2,
	box = {20, 0, 25, 25},
	RGB = {250,0,0},
}

_tab_effect[3195] = {
	model = "MODEL_EFFECT:cobweb01",
	--xlblink = {image=0,scale = 1.3,dur = 300,RGB = {75,75,255}},
	name = "红蛛网",
	scale = 1,
	height = 20,
	RGB = {250,0,0},
}

_tab_effect[3196] = {
	model = "MODEL_EFFECT:shield02",
	--xlblink = {image=0,scale = 1.0,dur = 1200,RGB = {255,0,0},},
	name = "护盾",
	scale = 1.0,
	height = 100,
}

_tab_effect[3197] = {
	model = "MODEL_EFFECT:shadow",
	name = "阴影",
	scale = 1.0,
	--height = 100,
}

--子弹19
_tab_effect[3198] = {
	model = "MODEL_EFFECT:zidan19",
	name = "弹19",
	scale = 0.5,
	height = 30,
	box = {0,0,12,12},
}

--子弹20
_tab_effect[3199] = {
	model = "MODEL_EFFECT:zidan20",
	name = "弹20",
	scale = 0.4,
	height = 30,
	box = {0,0,7,7},
}

_tab_effect[3200] = {
	model = "MODEL_EFFECT:boss_laser",
	name = "boss激光",
	height = 99,
	scale = 1,
	box = {0,0,5,5},
}

_tab_effect[3201] = {
	model = "MODEL_EFFECT:zhadan4",
	name = "大炸弹",
	height = 0,
	scale = 0.5,
	box = {0,0,5,5},
}

_tab_effect[3202] = {
	model = "MODEL_EFFECT:shipcore",
	name = "核心",
	height = 100,
	scale = 1.0,
	box = {0,0,5,5},
}

_tab_effect[3203] = {
	model = "MODEL_EFFECT:bossgun_fire1",
	name = "核心",
	height = 10,
	scale = 1.0,
	box = {0,0,5,5},
}

--高射塔底座
_tab_effect[3204] = {
	model = "MODEL_EFFECT:GAOSHETA_BASE",
	name = "高射塔底座",
	height = -5,
	scale = 1.0,
}

--机枪塔底座
_tab_effect[3205] = {
	model = "MODEL_EFFECT:JIQIANGTA_BASE",
	name = "机枪塔底座",
	height = -5,
	scale = 1.0,
}

--炮台塔底座
_tab_effect[3206] = {
	model = "MODEL_EFFECT:PAOTAITA_BASE",
	name = "炮台塔底座",
	height = -5,
	scale = 1.0,
}

--射击塔底座
_tab_effect[3207] = {
	model = "MODEL_EFFECT:SHEJITA_BASE",
	name = "射击塔底座",
	height = -5,
	scale = 1.0,
}

_tab_effect[3208] = {
	model = "MODEL_EFFECT:zhadan4",
	name = "大炸弹(小)",
	height = 0,
	scale = 0.3,
	box = {0,0,5,5},
}

_tab_effect[3209] = {
	model = "MODEL_EFFECT:burst_2",
	name = "火花_小",
	scale = 0.2,
	height = 20,
}

_tab_effect[3210] = {
	model = "MODEL_EFFECT:dust4",
	name = "瓦斯气",
	scale = 1.0,
	height = 80,
}

_tab_effect[3211] = {
	model = "MODEL_EFFECT:shuijing",
	name = "采集水晶",
	scale = 0.7,
	height = 80,
}

_tab_effect[3212] = {
	model = "MODEL_EFFECT:shuijing",
	name = "采集瓦斯",
	scale = 0.7,
	height = 80,
	RGB = {0,255,0},
}

_tab_effect[3213] = {
	model = "MODEL_EFFECT:spark",
	name = "建造火花",
	scale = 1,
	height = 30,
}

_tab_effect[3214] = {
	model = "MODEL_EFFECT:nuclear",
	name = "核爆",
	scale = 1.5,
	height = 99,
}

_tab_effect[3215] = {
	model = "MODEL_EFFECT:spark2",
	name = "挖矿火花",
	height = 30,
	scale = 1.5,
}

_tab_effect[3216] = {
	model = "MODEL_EFFECT:smoke04",
	name = "烟汽",
	height = 99,
	scale = 1.5,
}

_tab_effect[3217] = {
	model = "MODEL_EFFECT:smoke05",
	name = "烟汽2",
	scale = 2,
	height = 99,
}

_tab_effect[3218] = {
	model = "MODEL_EFFECT:blink",
	name = "闪烁",
	height = 30,
	scale = 1.0,
}

_tab_effect[3219] = {
	model = "MODEL_EFFECT:shadow2",
	name = "龙阴影",
	height = -10,
	scale = 1.0,
}

--子母弹
_tab_effect[3220] = {
	model = "MODEL_EFFECT:zhadan",
	name = "子母弹",
	scale = 0.4,
	height = -20,
}

_tab_effect[3221] = {
	model = "MODEL_EFFECT:coin",
	name = "金币",
	scale = 1.0,
	height = 30,
	box = {0,0,5,5},
}

_tab_effect[3222] = {
	model = "MODEL_EFFECT:shuijing2",
	name = "水晶堆",
	scale = 1.0,
	height = 20,
}

--单石头maze3_11
_tab_effect[3223] = {
	model = "MODEL_EFFECT:maze3_11",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "单石头maze3_11",
	scale = 1.0,
	height = 20,
}

--透明-大
_tab_effect[3224] = {
	model = "MODEL_EFFECT:touming2",
	name = "透明",
	--height = 99,
	scale = 1,
}

--飞碟影子
_tab_effect[3225] = {
	model = "MODEL_EFFECT:plate_shadow",
	name = "飞碟影子",
	scale = 1.0,
	height = 30,
}

_tab_effect[3226] = {
	model = "MODEL_EFFECT:zidan11",
	name = "弹11-小",
	scale = 0.3,
	height = 30,
	box = {0,0,5,5},
}

_tab_effect[3227] = {
	model = "MODEL_EFFECT:mine",
	name = "地雷",
	scale = 1.0,
	height = 30,
}

_tab_effect[3228] = {
	model = "MODEL_EFFECT:T_save",
	name = "停机坪",
	scale = 1.0,
	height = 30,
}

_tab_effect[3229] = {
	model = "MODEL_EFFECT:smoke04",
	name = "烟汽(小)",
	height = 99,
	scale = 1.0,
}

--平房X碎片
_tab_effect[3230] = {
	model = "MODEL_EFFECT:prison_x_04",
	name = "碎片",
	scale = 1.0,
	height = 0,
}

_tab_effect[3231] = {
	model = "MODEL_EFFECT:prison_wall_x_03",
	name = "碎片",
	scale = 1.0,
	height = 0,
}

_tab_effect[3232] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "激光--蓝色",
	scale = 1.0,
	height = 0,
	box = {0,0,8,8},
}

_tab_effect[3233] = {
	model = "MODEL_EFFECT:Arrow_06",
	name = "激光--紫色",
	scale = 1.0,
	height = 0,
	box = {0,0,8,8},
	RGB = {255,0,255},
}

--火球黄
_tab_effect[3234] = {
	model = "MODEL_EFFECT:fireball-buff4",
	name = "火球黄",
	scale = 0.8,
	height = 30,
	box = {10,0,30,10},
}

--投掷炸弹（无命中）
_tab_effect[3235] = {
	model = "MODEL_EFFECT:zhadan_nohit",
	--xlblink = {image=0,scale = 0.5,dur = 700,RGB = {255,0,0},},
	name = "投掷炸弹（无命中）",
	scale = 0.4,
	height = -20,
}

--毒泡
_tab_effect[3236] = {
	model = "MODEL_EFFECT:dupao",
	name = "毒泡",
	scale = 1.0,
	height = 30,
	--box = {0,0,8,8},
	RGB = {0,255,0},
}

--毒烟
_tab_effect[3237] = {
	model = "MODEL_EFFECT:smoke06",
	name = "毒烟",
	scale = 1.0,
	height = 99,
}

_tab_effect[3238] = {
	model = "MODEL_EFFECT:laser8",
	name = "laser8",
	height = 0,
	scale = 1.0,
	box = {0,0,8,8},
}

--核弹飞行特效（无命中）
_tab_effect[3239] = {
	model = "MODEL_EFFECT:zhadan6",
	name = "油桶飞行特效（无命中）",
	scale = 0.6,
	height = 99,
}

_tab_effect[3240] = {
	model = "MODEL_EFFECT:zhadan5",
	name = "投弹",
	height = 0,
	scale = 1.0,
}

_tab_effect[3241] = {
	model = "MODEL_EFFECT:impulse",
	name = "冲击波",
	height = 0,
	scale = 0.3,
	box = {0,0,8,20},
}

_tab_effect[3242] = {
	model = "MODEL_EFFECT:impulse",
	name = "冲击波2",
	height = 0,
	scale = 0.6,
	box = {0,0,8,30},
}

_tab_effect[3243] = {
	model = "MODEL_EFFECT:shuijing2",
	name = "水晶堆2",
	scale = 0.6,
	height = 20,
}

--钢铁气球影子
_tab_effect[3244] = {
	model = "MODEL_EFFECT:metal_balloon_shadow",
	name = "飞碟影子",
	scale = 1.0,
	height = 30,
}

_tab_effect[3245] = {
	model = "MODEL_EFFECT:shield02",
	name = "护盾（大）",
	scale = 1.5,
	height = 100,
}

_tab_effect[3246] = {
	model = "MODEL_EFFECT:luoxuan",
	name = "螺旋",
	height = 0,
	scale = 1.0,
	box = {0,0,10,10},
}

_tab_effect[3247] = {
	model = "MODEL_EFFECT:ice_ball",
	name = "熔岩球",
	scale = 0.7,
	height = 0,
	box = {0,0,8,8},
	RGB = {255,128,64},
}

_tab_effect[3248] = {
	model = "MODEL_EFFECT:nuclear",
	name = "核爆(小)",
	scale = 1.0,
	height = 99,
}

_tab_effect[3249] = {
	model = "MODEL_EFFECT:fireball8_x2",
	name = "火箭火球1",
	scale = 0.8,
}

_tab_effect[3250] = {
	model = "MODEL_EFFECT:fireball8_x2",
	name = "火箭火球2",
	scale = 1.5,
}

--金属箱碎片1
_tab_effect[3251] = {
	model = "MODEL_EFFECT:container03_d1",
	name = "container03_d1",
	scale = 1.0,
	height = 0,
}

--金属箱碎片2
_tab_effect[3252] = {
	model = "MODEL_EFFECT:container03_d2",
	name = "container03_d2",
	scale = 1.0,
	height = 0,
}

_tab_effect[3253] = {
	model = "MODEL_EFFECT:taizi_ex",
	name = "枪塔台子",
	scale = 1.0,
	height = -5,
}

_tab_effect[3254] = {
	model = "MODEL_EFFECT:spark3",
	name = "挖矿火花2",
	height = 30,
	scale = 1.5,
}

_tab_effect[3255] = {
	model = "MODEL_EFFECT:shuijing3",
	name = "采集氪石",
	scale = 0.7,
	height = 80,
}

--雷神之锤A
_tab_effect[3256] = {
	model = "MODEL_EFFECT:thunder_A",
	name = "雷神之锤A",
	height = 80,
	scale = 1.0,
}

--雷神之锤B
_tab_effect[3257] = {
	model = "MODEL_EFFECT:thunder_B",
	name = "雷神之锤B",
	height = 80,
	scale = 1.0,
}

_tab_effect[3258] = {
	model = "MODEL_EFFECT:zidan22",
	xlblink = {image=0,scale = 0.6,dur = 700,RGB = {240,185,40},},
	name = "毒泡(透明黄)",
	scale = 0.5,
	height = 20,
	box = {0,0,10,10},
}

--冰冻暴击飞行特效
_tab_effect[3259] = {
	model = "MODEL_EFFECT:zidan12",
	name = "冰冻暴击飞行特效",
	scale = 3.2,
	height = 30,
	--box = {{11,0,7,7},{4,16,7,7},{4,-16,7,7},{-7,30,7,7},{-7,-30,7,7},},
	box = {0,0,45,45},
}

--火焰暴击飞行特效
_tab_effect[3260] = {
	model = "MODEL_EFFECT:zidan6",
	name = "火焰暴击飞行特效",
	scale = 2.3,
	height = 30,
	box = {0,0,45,45},
}

--击退暴击飞行特效
_tab_effect[3261] = {
	model = "MODEL_EFFECT:zidan11",
	name = "击退暴击飞行特效",
	scale = 1.0,
	height = 30,
	box = {0,0,45,45},
}

--毒液暴击飞行特效
_tab_effect[3262] = {
	model = "MODEL_EFFECT:koushui",
	name = "毒液暴击飞行特效",
	scale = 2.0,
	height = 30,
	box = {0,0,45,45},
}

--战役图标1
_tab_effect[3263] = {
	model = "MODEL_EFFECT:boss_01",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

--战役图标2
_tab_effect[3264] = {
	model = "MODEL_EFFECT:boss_02",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

--战役图标3
_tab_effect[3265] = {
	model = "MODEL_EFFECT:boss_03",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

--战役图标4
_tab_effect[3266] = {
	model = "MODEL_EFFECT:boss_04",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

--漩涡
_tab_effect[3267] = {
	model = "MODEL_EFFECT:XuanWo",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

_tab_effect[3268] = {
	model = "MODEL_EFFECT:zidan23",
	name = "剑气子弹",
	scale = 1.0,
	height = 20,
	box = {12,0,10,50},
}

_tab_effect[3269] = {
	model = "MODEL_EFFECT:Dust_MM",
	name = "boss_01",
	height = 80,
	scale = 1.0,
}

--集装箱4碎片1
_tab_effect[3270] = {
	model = "MODEL_EFFECT:container04_d1",
	name = "container04_d1",
	scale = 1.0,
	height = 0,
}

--集装箱4碎片2
_tab_effect[3271] = {
	model = "MODEL_EFFECT:container04_d2",
	name = "container04_d2",
	scale = 1.0,
	height = 0,
}

--集装箱4碎片3
_tab_effect[3272] = {
	model = "MODEL_EFFECT:container04_d3",
	name = "container04_d3",
	scale = 1.0,
	height = 0,
}

_tab_effect[3273] = {
	model = "MODEL_EFFECT:zidan23",
	name = "巨型剑气-红",
	scale = 3.0,
	height = 30,
	box = {12,0,50,150},
	RGB = {255,0,0},
}

--扫描线
_tab_effect[3274] = {
	model = "MODEL_EFFECT:scan",
	name = "扫描线",
	height = -10,
	scale = 1.0,
}

--聚气
_tab_effect[3275] = {
	model = "MODEL_EFFECT:juqi",
	name = "聚气",
	--xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,0},},
	height = 20,
	scale = 1.0,
	--box = {0,0,20,20},
}

_tab_effect[3276] = {
	model = "MODEL_EFFECT:Arrow_13",
	--xlblink = {image=0,scale = 1.0,dur = 500,RGB = {255,150,0},},
	name = "爪击-激光",
	scale = 0.6,
	height = 0,
	box = {0,0,40,20},
	--RGB = {255,100,100},
}

_tab_effect[3277] = {
	model = "MODEL_EFFECT:touming",
	name = "透明子弹",
	scale = 1.0,
	height = 20,
	box = {12,0,10,70},
}

_tab_effect[3278] = {
	model = "MODEL_EFFECT:fragment",
	name = "碎片1",
	scale = 1,
}

_tab_effect[3279] = {
	model = "MODEL_EFFECT:fragment",
	name = "碎片2",
	scale = 0.5,
}

_tab_effect[3280] = {
	model = "MODEL_EFFECT:Dust_MM",
	name = "粉尘",
	scale = 2.5,
	height = 80,
}

_tab_effect[3281] = {
	model = "MODEL_EFFECT:creep01",
	name = "菌毯",
	scale = 1,
	height = -10,
}

_tab_effect[3282] = {
	xlblink = {image=0,scale = 1.0,dur = 500,RGB = {255,0,0},},
	name = "吕布无双",
	scale = 4,
	height = 80,
}

_tab_effect[3283] = {
	model = "MODEL_EFFECT:Band_aid",
	name = "创可贴",
	scale = 1,
}

_tab_effect[3284] = {
	model = "MODEL_EFFECT:zidan23",
	name = "巨型剑气-蓝",
	scale = 3.0,
	height = 30,
	box = {12,0,50,150},
	RGB = {255,255,255},
}

_tab_effect[3333] = {
	model = "MODEL_EFFECT:Summon_3",
	xlblink = {scale = 4.0,dur = 100,RGB = {255,255,0},},
	name = "升级",
	height = 100,
	scale = 1,
}

_tab_effect[3334] = {
	model = "MODEL_EFFECT:zidan6",
	name = "火焰暴击飞行特效",
	scale = 1.5,
	height = 30,
	box = {0,0,30,30},
}

--漩涡
_tab_effect[3335] = {
	model = "MODEL_EFFECT:teleport",
	name = "boss_01",
	height = 80,
	scale = 1.0,
	RGB = {255,0,0},
}

_tab_effect[3336] = {
	model = "MODEL_EFFECT:shadow2",
	name = "龙阴影-小",
	height = -10,
	scale = 0.3,
}

_tab_effect[3337] = {
	model = "MODEL_EFFECT:shield03",
	name = "紫色护罩",
	height = 10,
	scale = 1.0,
}

_tab_effect[3338] = {
	model = "MODEL_EFFECT:zhadan7",
	name = "大炮弹",
	height = 0,
	scale = 1.0,
	box = {0,0,5,5},
}

_tab_effect[3339] = {
	xlblink = {light = 1,image=0,scale = 1.8,dur = 500,RGB = {255,50,0},},
	name = "火坑红光",
	scale = 0.5,
	height = 80,
}

_tab_effect[3340] = {
	model = "MODEL_EFFECT:Fire06",
	xlblink = {light = 1,image=0,scale = 1.5,dur = 1500,RGB = {255,50,0},},
	name = "火坑火",
	height = 80,
	scale = 1.6,
}

_tab_effect[3341] = {
	model = "MODEL_EFFECT:shadow3",
	name = "天网阴影",
	height = 0,
	scale = 1.0,
	--RGB = {0,0,0},
}

_tab_effect[3342] = {
	model = "MODEL_EFFECT:treasure002",
	name = "三叉戟",
	height = 20,
	scale = 0.6,
}

_tab_effect[3343] = {
	model = "MODEL_EFFECT:obstacle3",
	name = "水晶台闪烁",
	height = 20,
	scale = 0.7,
}

_tab_effect[3344] = {
	model = "MODEL_EFFECT:zidan25",
	name = "王尼玛",
	scale = 1.0,
	height = 20,
	box = {12,0,10,50},
}

--终结者枪子弹1
_tab_effect[3345] = {
	model = "MODEL_EFFECT:zidan5_t1",
	name = "偏移子弹",
	scale = 1.0,
	box = {0,25,5,5},
}

--终结者枪子弹2
_tab_effect[3346] = {
	model = "MODEL_EFFECT:zidan5_t2",
	name = "偏移子弹",
	scale = 1.0,
	box = {0,-25,5,5},
}

--终结者枪子弹3
_tab_effect[3347] = {
	model = "MODEL_EFFECT:zidan13_t1",
	name = "偏移子弹",
	scale = 1.0,
	box = {40,25,5,5},
}

--终结者枪子弹4
_tab_effect[3348] = {
	model = "MODEL_EFFECT:zidan13_t2",
	name = "偏移子弹",
	scale = 1.0,
	box = {40,-25,5,5},
}

--终结者枪子弹3
_tab_effect[3349] = {
	model = "MODEL_EFFECT:zidan14_t1",
	name = "偏移子弹",
	scale = 1.0,
	box = {40,20,5,5},
}

--终结者枪子弹4
_tab_effect[3350] = {
	model = "MODEL_EFFECT:zidan14_t2",
	name = "偏移子弹",
	scale = 1.0,
	box = {40,-20,5,5},
}

--顺丰箱子5
_tab_effect[3351] = {
	model = "MODEL_EFFECT:sf5",
	name = "顺丰箱子5",
	scale = 0.7,
	height = 80,
}

--投雷提示
_tab_effect[3352] =
{
	type = hVar.EFFECT_TYPE.OVERHEAD,
	model = "MODEL_EFFECT:blowit_sign",
	name = "投雷提示",
	height = 100,
}

--激光拖尾特效
_tab_effect[3353] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.2,
	box = {0,0,10,10},
	--	RGB = {120,200,0},
}
_tab_effect[3354] = {
	model = "MODEL_EFFECT:laser",
	name = "激光拖尾",
	--	xlblink = {light = 0,image=0,scale = 1,dur = 100,RGB = {0,0,0},},
	height = 30,
	scale = 0.4,
	box = {0,0,10,10},
	--	RGB = {120,200,0},
}

_tab_effect[3355] = {
	--model = "MODEL_EFFECT:LightningHit_3",
	xlblink = {light = 1,image=0,scale = 1.5,dur = 300,RGB = {10,10,255},},
	name = "蓝光",
	scale = 1,
	height = 30,
}
_tab_effect[3356] = {
	model = "MODEL_EFFECT:LightningHit_3",
	name = "闪电光效",
	scale = 1,
	height = 30,
}

_tab_effect[3357] = {
	model = "MODEL_EFFECT:Daoguang02x",
	name = "刀光02",
	xlblink = {light = 0,image=15,scale = 0.1,dur = 100,RGB = {0,0,255},},
	height = 20,
	scale = 2.5,
	box = {0,0,10,10},
}

_tab_effect[3358] = {
	model = "MODEL_EFFECT:zidan23",
	name = "中型剑气-蓝",
	scale = 1.5,
	height = 30,
	box = {12,0,25,75},
	RGB = {255,255,255},
}
return _tab_effect