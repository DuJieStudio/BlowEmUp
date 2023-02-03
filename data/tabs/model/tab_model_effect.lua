local _tab_model = hVar.tab_model
--[8000~8999特效]--------------------------------
_tab_model[8000] = {
	name = "MODEL_EFFECT:hit",
	image = "effect/hit.png",
	animation = {
		"stand_1",
		"stand_2",
	},
	stand_1 = {
		interval = 27,
		[1] = {0,0,63,299,8},
	},
	stand_2 = {
		interval = 27,
		[1] = {0,0,63,299,8},
	},
}

--移动的提示特效
_tab_model[8001] =
{
	name = "MODEL_EFFECT:way_arrow",
	image = "effect/way_arrow.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5,1},
		interval = 100,
		[1] = {0,0,39,39},
		[2] = {0,-3,39,39},
		[3] = {0,-5,39,39},
		[4] = {0,-2,39,39},
		[5] = {0,0,39,39},
	},
}

_tab_model[8002] = {
	name = "MODEL_EFFECT:chat",
	image = "misc/chat_icon.png",
	animation = {
		"stand",
	},
	stand = {
		interval = 500,
		[1] = {0,0,20,20,3},
	},
}

_tab_model[8003] = {
	name = "MODEL_EFFECT:rush",
	image = "effect/rush.png",
	animation = {
		"stand",
	},
	stand = {
		interval = 100,
		[1] = {0,0,141,106,8},
	},
}

_tab_model[8004] = {
	name = "MODEL_EFFECT:select_cycle",
	image = "ui/ui_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {329,91,56,56,1},
		[2] = {329,93,56,56,1},
		[3] = {329,94,56,56,1},
		[4] = {329,93,56,56,1},
		[5] = {329,91,56,56,1},
	},
}

_tab_model[8005] = {
	name = "MODEL_EFFECT:LightningHit_1",
	image = "effect/LightningHit_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.72},
		interval = 100,
		[1] = {0,0,96,135,4},
		[2] = {0,135,96,135,4},
	},
}

_tab_model[8006] = {
	name = "MODEL_EFFECT:Defend_1",
	image = "effect/Defend_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 100,
		[1] = {0,0,137,109,3},
	},
}

_tab_model[8007] = {
	name = "MODEL_EFFECT:Blood_1",
	image = "effect/Blood_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8008] = {
	name = "MODEL_EFFECT:Aura_1",
	image = "effect/Aura_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,176,93,4},
		[2] = {0,93,176,93,2},
	},
}


_tab_model[8009] = {
	name = "MODEL_EFFECT:Aura_1",
	image = "effect/Aura_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,176,93,4},
		[2] = {0,93,176,93,2},
	},
}

_tab_model[8010] = {
	name = "MODEL_EFFECT:Aura_2",
	image = "effect/Aura_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.6},
		interval = 100,
		[1] = {0,0,144,174,4},
		[2] = {0,174,144,174,4},
	},
}

_tab_model[8011] = {
	name = "MODEL_EFFECT:Summon_1",
	image = "effect/Summon_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.75},
		interval = 100,
		[1] = {0,0,76,145,4},
		[2] = {0,145,76,145,4},
		[3] = {0,145*2,76,145,2},
	},
}

_tab_model[8012] = {
	name = "MODEL_EFFECT:Arrow_1",
	image = "effect/arrow_1.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,42,43,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}


_tab_model[8013] = {
	name = "MODEL_EFFECT:MoveCircle",
	image = "effect/circle1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 100,
		[1] = {0,96*3,96,96,5},
		[2] = {0,96*4,96,96,5},
		--[3] = {0,192*5,192,192,3},
	},
}

_tab_model[8014] = {
	name = "MODEL_EFFECT:SelectCircle",
	image = "misc/blue_circle.png",--"circle.png",
	animation = {
		"stand",
		"blue",
		"red",
		"loop_blue",
		"loop_yello",
	},
	stand = {
		image = "misc/blue_circle.png",
		[1] = {0,0,96,64},
	},
	blue = {
		image = "misc/blue_circle.png",
		[1] = {0,0,96,64},
	},
	red = {
		image = "misc/red_circle.png",
		[1] = {0,0,96,64},
	},
	range = {
		image = "misc/atkRange.png",
		[1] = {0,0,64,64},
	},
	loop_blue = {
		anchor = {0.5,0.75},
		image = "misc/loop_circle.png",
		interval = 100,
		[1] = {0,0,256,256,8},
	},
	loop_yello = {
		anchor = {0.5,0.75},
		image = "misc/loop_circle.png",
		interval = 100,
		[1] = {0,256,256,256,8},
	},
}
_tab_model[8015] = {
	name = "MODEL_EFFECT:burst_1",
	image = "effect/burst_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 50,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
		[3] = {0,192*2,192,192,5},
		[4] = {0,192*3,192,192,5},
		--[5] = {0,192*4,192,192,5},
		--[6] = {0,192*5,192,192,5},
	},
}

_tab_model[8016] = {
	name = "MODEL_EFFECT:HealArea",
	image = "effect/HealArea.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		interval = 35,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
		[3] = {0,192*2,192,192,5},
		[4] = {0,192*3,192,192,5},
		[5] = {0,192*4,192,192,5},
		[6] = {0,192*5,192,192,5},
		[7] = {0,192*6,192,192,5},
		[8] = {0,192*7,192,192,5},
	},
}

_tab_model[8017] = {
	name = "MODEL_EFFECT:GlacialSpike",
	image = "effect/GlacialSpike.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
	},
}

_tab_model[8018] = {
	name = "MODEL_EFFECT:WarStomp",
	image = "effect/WarStomp.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 30,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
		[3] = {0,100*2,100,100,5},
	},
}

_tab_model[8019] = {
	name = "MODEL_EFFECT:Z_raid",
	image = "effect/Z_raid.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		interval = 25,
		[1] = {0,0,192,96,2},
		[2] = {0,96,192,96,2},
	},
}


_tab_model[8020] = {
	name = "MODEL_EFFECT:HealArea2",
	image = "effect/HealArea2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
		[3] = {0,192*2,192,192,5},
	},
}


_tab_model[8021] = {
	name = "MODEL_EFFECT:fireball",
	image = "effect/fireball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -90,
		--flipX = 1,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.5},
		interval = 50,
		height = 1,
		scale = 1.6,
		[1] = {0,0,64,64,6},
	},
}

_tab_model[8022] = {
	name = "MODEL_EFFECT:Sword_drop",
	image = "effect/Sword_drop.png",
	animation = {
		"stand",
		"hold",
		"drop",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,192,192,3},
		[2] = {192*2,0,192,192,1},
		[3] = {192*3,0,192,192,1},
		[4] = {0,192,192,192,4},
		[5] = {0,192*2,192,192,4},
	},
	hold = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,192,192,3},
		[2] = {192*2,0,192,192,1},
		[3] = {192*2,0,192,192,1},
		[4] = {192*2,0,192,192,1},
		[5] = {192*2,0,192,192,1},
		[6] = {192*2,0,192,192,1},
		[7] = {192*2,0,192,192,1},
		[8] = {192*2,0,192,192,1},
		[9] = {192*2,0,192,192,1},
		[10] = {192*2,0,192,192,1},
		[11] = {192*2,0,192,192,1},
		[12] = {192*2,0,192,192,1},
	},
	drop = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {192*2,0,192,192,1},
		[2] = {192*3,0,192,192,1},
		[3] = {0,192,192,192,4},
		[4] = {0,192*2,192,192,4},
	},
}

_tab_model[8023] = {
	name = "MODEL_EFFECT:Summon_2",
	image = "effect/Summon_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.6},
		interval = 100,
		[1] = {0,0,192,192,6},
		[2] = {0,192,192,192,6},
		[3] = {0,192*2,192,192,6},
	},
}

_tab_model[8024] = {
	name = "MODEL_EFFECT:stone",
	image = "effect/stone.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8025] = {
	name = "MODEL_EFFECT:symbol",
	image = "effect/symbol.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		interval = 50,
		[1] = {0,0,128,128,4},
		[2] = {0,128,128,128,4},
		[3] = {0,128*2,128,128,4},
		[4] = {0,128*3,128,128,4},
	},
}


_tab_model[8026] = {
	name = "MODEL_EFFECT:ice_spike_01",
	image = "effect/ice_spike_01.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,128,32,4},
	},
	dead = {
		image = "effect/ice_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1.6,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
	},
}

_tab_model[8027] = {
	name = "MODEL_EFFECT:shadowball",
	image = "effect/shadowball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,62,22,4},
	},
	dead = {
		image = "effect/shadowball_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 30,
		scale = 1.2,
		[1] = {0,0,30,32,5},
	},
}

_tab_model[8028] = {
	name = "MODEL_EFFECT:LightningHit_2",
	image = "effect/LightningHit_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 30,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
		[3] = {0,192*2,192,192,5},
	},
}

_tab_model[8029] = {
	name = "MODEL_EFFECT:Acid_1",
	image = "effect/Acid_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,148,122,4},
		[2] = {0,122,148,122,3},
	},
}

_tab_model[8030] = {
	name = "MODEL_EFFECT:magic_dark_Lord_Ball",
	image = "effect/magic_dark_Lord_Ball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 200,
		[1] = {0,0,24,24,4},
	},
	dead = {
		image = "effect/shadowball_explosion.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}






_tab_model[8031] = {
	name = "MODEL_EFFECT:dust",
	image = "effect/dust.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
	},
}

_tab_model[8032] = {
	name = "MODEL_EFFECT:seal_1",
	image = "effect/seal_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8033] = {
	name = "MODEL_EFFECT:ice_shell",
	image = "effect/ice_shell.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,100,100,4},
		[2] = {0,100,100,100,4},
	},
}

_tab_model[8034] = {
	name = "MODEL_EFFECT:MoveCircle2",
	image = "effect/circle1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 50,
		[1] = {0,0,96,96,5},
		[2] = {0,96,96,96,5},
		--[3] = {0,96*2,96,96,1},
	},
}

_tab_model[8035] = {
	name = "MODEL_EFFECT:fear",
	image = "effect/fear.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 150,
		[1] = {0,0,38,79,4},
		[2] = {0,79,38,79,4},
	},
}

_tab_model[8036] = {
	name = "MODEL_EFFECT:whirlwind",
	image = "effect/whirlwind.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 120,
		[1] = {0,0,128,96,4},
		[2] = {0,96,128,96,4},
	},
}

_tab_model[8037] = {
	name = "MODEL_EFFECT:unparalleled",
	image = "effect/unparalleled.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 100,
		[1] = {0,0,93,115,5},
		[2] = {0,115,93,115,5},
		[3] = {0,115*2,93,115,5},
		[4] = {0,115*3,93,115,5},
	},
}

_tab_model[8038] = {
	name = "MODEL_EFFECT:seal_2",
	image = "effect/seal_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,1},
	},
}


_tab_model[8039] = {
	name = "MODEL_EFFECT:LifeSteal",
	image = "effect/LifeSteal.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.6},
		interval = 150,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
		[3] = {0,100*2,100,100,5},
	},
}

_tab_model[8040] = {
	name = "MODEL_EFFECT:LightningHit_3",
	image = "effect/LightningHit_3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,50,52,4},
		[2] = {0,52,50,52,3},
	},
}

_tab_model[8041] = {
	name = "MODEL_EFFECT:LightningHit_4",
	image = "effect/LightningHit_4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,192,192,5},
		[2] = {0,192,192,192,5},
		[3] = {0,192*2,192,192,5},
		[4] = {0,192*3,192,192,5},
	},
}

_tab_model[8042] = {
	name = "MODEL_EFFECT:unparalleled2",
	image = "effect/unparalleled2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 100,
		[1] = {0,0,93,115,5},
		[2] = {0,115,93,115,5},
		[3] = {0,115*2,93,115,5},
		[4] = {0,115*3,93,115,5},
	},
}

_tab_model[8043] = {
	name = "MODEL_EFFECT:teleport",
	image = "effect/teleport.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
	},
}

_tab_model[8044] = {
	name = "MODEL_EFFECT:firewall",
	image = "effect/firewall.png",
	animation = {
		"fire",
	},
	fire = {
		anchor = {0.5,0.8},
		interval = 100,
		[1] = {0,0,44,132,10},
		--[2] = {44,0,44,132,5},
		--[3] = {88,0,44,132,5},
		--[4] = {132,0,44,132,5},
		--[5] = {176,0,44,132,5},
		--[6] = {220,0,44,132,5},
		--[7] = {264,0,44,132,5},
		--[8] = {308,0,44,132,5},
		--[9] = {352,0,44,132,5},
		--[10] = {396,0,44,132,5},
	},
}

_tab_model[8045] = {
	name = "MODEL_EFFECT:stone_f",
	image = "effect/stone_f.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8046] = {
	name = "MODEL_EFFECT:stone_shard",
	image = "effect/stone_shard.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8047] = {
	name = "MODEL_EFFECT:Arrow_2",
	image = "effect/arrow_2.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8048] = {
	name = "MODEL_EFFECT:Z_raid_red",
	image = "effect/Z_raid_red.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		interval = 25,
		[1] = {0,0,192,96,2},
		[2] = {0,96,192,96,2},
	},
}

_tab_model[8049] = {
	name = "MODEL_EFFECT:fire_star",
	image = "effect/fire_star.png",
	animation = {
		"fire",
	},
	fire = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,10},
		--[1] = {0,0,64,64,10},
		--[2] = {64,0,64,64,5},
		--[3] = {128,0,64,64,5},
		--[4] = {192,0,64,64,5},
		--[5] = {256,0,64,64,5},
		--[6] = {320,0,64,64,5},
		--[7] = {384,0,64,64,5},
		--[8] = {448,0,64,64,5},
		--[9] = {512,0,64,64,5},
		--[10] = {576,0,64,64,5},
	},
}

_tab_model[8050] = {
	name = "MODEL_EFFECT:burst_3",
	image = "effect/burst_3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -90,
		--flipX = 1,
		interval = 60,
		height = 1,
		scale = 1.6,
		[1] = {0,0,64,64,3},
	},
}


_tab_model[8051] = {
	name = "MODEL_EFFECT:diamond",
	image = "effect/diamond.png",
	animation = {
		"blink",
	},
	blink = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,32,32,4},
	},
}


--插一些空白帧
for i = 2,40 do
	_tab_model[8051].blink[i] = {0,0,32,32,1}
end

_tab_model[8052] = {
	name = "MODEL_EFFECT:banner",
	image = "effect/banner.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,128,128,1},
	},
	dead = {
		image = "effect/burst_3.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,3},
	},
}

_tab_model[8053] = {
	name = "MODEL_EFFECT:charge",
	image = "effect/smoke.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,96,96,8},
	},
}

_tab_model[8054] = {
	name = "MODEL_EFFECT:break_down",
	image = "effect/break_down.png",
	autorelease = 1,
	animation = {
		"break_down",
	},
	break_down = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
		[3] = {0,128,64,64,4},
		[4] = {0,192,64,64,4},
	},
}

_tab_model[8055] = {
	name = "MODEL_EFFECT:strengthen",
	image = "effect/strengthen.png",
	autorelease = 1,
	animation = {
		"strengthen",
	},
	strengthen = {
		anchor = {0.5,0.5},
		interval = 20,
	},
}
for i = 1,8 do
	_tab_model[8055].strengthen[i] = {0,0+(i-1)*64,64,64,8}
end

_tab_model[8056] = {
	name = "MODEL_EFFECT:upgrade",
	image = "effect/upgrade.png",
	animation = {
		"upgrade",
	},
	autorelease = 1,
	upgrade = {
		anchor = {0.5,0.5},
		interval = 100,
	},
}

for i = 1,4 do
	_tab_model[8056].upgrade[i] = {0,0+(i-1)*85.5,85.5,85.5,4}
end


_tab_model[8057] = {
	name = "MODEL_EFFECT:ice_shell2",
	image = "effect/ice_shell2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		[1] = {0,0,192,192,3},
		[2] = {192*2,0,192,192,1},
		[3] = {192*2,0,192,192,1},
		[4] = {192*2,0,192,192,1},
		[5] = {192*2,0,192,192,1},
		[6] = {192*2,0,192,192,1},
	},
}

_tab_model[8058] = {
	name = "MODEL_EFFECT:ice_shell201",
	image = "effect/ice_shell2.png",
	animation = {
		"stand_1",
		"stand_2",
		"stand_3",
		"stand_4",
		"stand_5",
		"stand_6",
		"stand_7",
		"stand_8",
	},
	stand_1 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {0,0,100,100,1},
	},
	stand_2 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {100,0,100,100,1},
	},
	stand_3 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {200,0,100,100,1},
	},
	stand_4 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {300,0,100,100,1},
	},
	stand_5 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {0,100,100,100,1},
	},
	stand_6 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {100,100,100,100,1},
	},
	stand_7 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {200,100,100,100,1},
	},
	stand_8 = {
		anchor = {0.5,0.7},
		interval = 100,
		[1] = {300,100,100,100,1},
	},
}

_tab_model[8059] = {
	name = "MODEL_EFFECT:flag",
	image = "effect/flag.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,54,50,1},
	},
}

_tab_model[8060] = {
	name = "MODEL_EFFECT:EndPoint",
	image = "effect/dbk.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,114,62,1},
	},
}



_tab_model[8061] = {
	name = "MODEL_EFFECT:jt_1",
	image = "effect/jt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,79,40,1},
		[2] = {0,40,79,40,1},
		[3] = {0,80,79,40,1},
		[4] = {0,120,79,40,1},
	},
}

_tab_model[8062] = {
	name = "MODEL_EFFECT:jt_2",
	image = "effect/jt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		roll = 90,
		[1] = {0,0,79,40,1},
		[2] = {0,40,79,40,1},
		[3] = {0,80,79,40,1},
		[4] = {0,120,79,40,1},
	},
}

_tab_model[8063] = {
	name = "MODEL_EFFECT:jt_3",
	image = "effect/jt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		roll = 180,
		[1] = {0,0,79,40,1},
		[2] = {0,40,79,40,1},
		[3] = {0,80,79,40,1},
		[4] = {0,120,79,40,1},
	},
}

_tab_model[8064] = {
	name = "MODEL_EFFECT:jt_4",
	image = "effect/jt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		roll = 270,
		[1] = {0,0,79,40,1},
		[2] = {0,40,79,40,1},
		[3] = {0,80,79,40,1},
		[4] = {0,120,79,40,1},
	},
}

_tab_model[8066] = {
	name = "MODEL_EFFECT:ice_explosion2",
	image = "effect/ice_explosion2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,64,64,64,4},
	},
}

_tab_model[8067] = {
	name = "MODEL_EFFECT:ice_explosion_jiansu",
	image = "effect/ice_explosion.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 800,
		[1] = {128,64,64,64,2},
	},
}

_tab_model[8068] = {
	name = "MODEL_EFFECT:cobweb01",
	image = "effect/cobweb01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,100,50,5},
		[2] = {0,50,100,50,5},
		[3] = {0,50*2,100,50,5},
		[4] = {0,50*3,100,50,5},
		[5] = {0,50*4,100,50,1},
	},
}

_tab_model[8069] = {
	name = "MODEL_EFFECT:waiting",
	image = "effect/waiting.png",
	animation = {
		"waiting",
	},
	waiting = {
		anchor = {0.5,0.5},
		interval = 100,
	},
}

for i = 1,4 do
	_tab_model[8069].waiting[i] = {0,0+(i-1)*64,64,64,4}
end


_tab_model[8070] = {
	name = "MODEL_EFFECT:FireAura",
	loadmode = "plist",
	plist = "effect/fire_aura.plist",
	image = "effect/fire_aura.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.9},
		interval = 100,
		pName = "data/image/effect/fire_aura_",
		pMode = 2,
		[1] = {0,0,0,0,15},
	},
}

_tab_model[8071] = {
	name = "MODEL_EFFECT:ForceShield",
	loadmode = "plist",
	plist = "effect/force_shield.plist",
	image = "effect/force_shield.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.6},
		interval = 100,
		pName = "data/image/effect/force_shield_",
		pMode = 2,
		[1] = {0,0,0,0,8},
	},
}


_tab_model[8072] = {
	name = "MODEL_EFFECT:Flower1",
	image = "effect/flower1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8073] = {
	name = "MODEL_EFFECT:Flower2",
	image = "effect/flower2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8074] = {
	name = "MODEL_EFFECT:Flower3",
	image = "effect/flower3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8075] = {
	name = "MODEL_EFFECT:Flower4",
	image = "effect/flower4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}
_tab_model[8076] = {
	name = "MODEL_EFFECT:Flower5",
	image = "effect/flower5.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8077] = {
	name = "MODEL_EFFECT:Flower6",
	image = "effect/flower6.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8078] = {
	name = "MODEL_EFFECT:whirlwind_f",
	image = "effect/whirlwind_f.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,202,32,2},
		[2] = {0,32,202,32,2},
		[3] = {0,32*2,202,32,2},
		[4] = {0,32*3,202,32,2},
		[5] = {0,32*4,202,32,2},
	},
}

_tab_model[8079] = {
	name = "MODEL_EFFECT:wushuang1",
	loadmode = "plist",
	plist = "effect/wushuang1.plist",
	image = "effect/wushuang1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		pName = "data/image/effect/1164-",
		pMode = 3,
		[1] = {0,0,0,0,17},
	},
}

_tab_model[8080] = {
	name = "MODEL_EFFECT:wushang1-1",
	loadmode = "plist",
	plist = "effect/wushang1-1.plist",
	image = "effect/wushang1-1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		pName = "data/image/effect/1801-",
		pMode = 3,
		[1] = {0,0,0,0,15},
	},
}


_tab_model[8081] = {
	name = "MODEL_EFFECT:dust2",
	loadmode = "plist",
	plist = "effect/dust2.plist",
	image = "effect/dust2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		pName = "data/image/effect/1636-",
		pMode = 3,
		[1] = {0,0,0,0,11},
	},
}

_tab_model[8082] = {
	name = "MODEL_EFFECT:burst01",
	loadmode = "plist",
	plist = "effect/burst01.plist",
	image = "effect/burst01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		pName = "effect/burst01/1254-",
		pMode = 3,
		[1] = {0,0,0,0,11},
	},
}


_tab_model[8083] = {
	name = "MODEL_EFFECT:Arrow_3",
	image = "effect/arrow_3.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,42,43,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}








_tab_model[8084] = {
	name = "MODEL_EFFECT:Arrow_4",
	loadmode = "plist",
	plist = "effect/arrow_04.plist",
	image = "effect/arrow_04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		pName = "effect/arrow04/1499-",
		pMode = 3,
		[1] = {0,0,0,0,9},
	},
}

_tab_model[8085] = {
	name = "MODEL_EFFECT:Roar01",
	loadmode = "plist",
	plist = "effect/roar01.plist",
	image = "effect/roar01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		pName = "effect/roar01/1715-",
		pMode = 3,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8086] = {
	name = "MODEL_EFFECT:Fire01",
	loadmode = "plist",
	plist = "effect/fire01.plist",
	image = "effect/fire01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/fire01/1584-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8087] = {
	name = "MODEL_EFFECT:Fire02",
	loadmode = "plist",
	plist = "effect/fire02.plist",
	image = "effect/fire02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/fire02/1427-",
		pMode = 3,
		[1] = {0,0,0,0,7},
	},
}

_tab_model[8088] = {
	name = "MODEL_EFFECT:Fire03",
	loadmode = "plist",
	plist = "effect/fire03.plist",
	image = "effect/fire03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/fire03/1705-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8089] = {
	name = "MODEL_EFFECT:Fire04",
	loadmode = "plist",
	plist = "effect/fire04.plist",
	image = "effect/fire04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/fire04/1754-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8090] = {
	name = "MODEL_EFFECT:Fire05",
	loadmode = "plist",
	plist = "effect/fire05.plist",
	image = "effect/fire05.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/fire05/1190-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}


_tab_model[8091] = {
	name = "MODEL_EFFECT:Acid01",
	loadmode = "plist",
	plist = "effect/acid01.plist",
	image = "effect/acid01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "effect/acid01/1769-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8092] = {
	name = "MODEL_EFFECT:Mana01",
	loadmode = "plist",
	plist = "effect/mana01.plist",
	image = "effect/mana01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "effect/mana01/7763-",
		pMode = 3,
		[1] = {0,0,0,0,12},
	},
}

_tab_model[8093] = {
	name = "MODEL_EFFECT:Smoke01",
	loadmode = "plist",
	plist = "effect/smoke01.plist",
	image = "effect/smoke01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1},
		interval = 150,
		roll = -45,
		pName = "effect/smoke01/1487-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8094] = {
	name = "MODEL_EFFECT:Heal01",
	loadmode = "plist",
	plist = "effect/heal01.plist",
	image = "effect/heal01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/heal01/1798-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8095] = {
	name = "MODEL_EFFECT:Fire06",
	--loadmode = "plist",
	--plist = "effect/fire06.plist",
	image = "effect/fire06.png",
	animation = {
		"stand",
	},
	stand = {
		--anchor = {0.5,1},
		--interval = 90,
		--pName = "effect/fire06/1696-",
		--pMode = 3,
		--[1] = {0,0,0,0,9},
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,50,70,8},
	},
}

_tab_model[8096] = {
	name = "MODEL_EFFECT:Ground01",
	loadmode = "plist",
	plist = "effect/ground02.plist",
	image = "effect/ground02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1},
		interval = 90,
		pName = "effect/ground02/1221-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}



_tab_model[8097] = {
	name = "MODEL_EFFECT:Ground02",
	loadmode = "plist",
	plist = "effect/ground02.plist",
	image = "effect/ground02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1},
		interval = 90,
		pName = "effect/ground02/1221-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8098] = {
	name = "MODEL_EFFECT:Arrow05",
	loadmode = "plist",
	plist = "effect/arrow05.plist",
	image = "effect/arrow05.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/arrow05/1832-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8099] = {
	name = "MODEL_EFFECT:Aura04",
	loadmode = "plist",
	plist = "effect/aura04.plist",
	image = "effect/aura04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/aura04/1957-",
		pMode = 3,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8100] = {
	name = "MODEL_EFFECT:Smoke03",
	loadmode = "plist",
	plist = "effect/smoke03.plist",
	image = "effect/smoke03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		pName = "effect/smoke03/1417-",
		pMode = 3,
		[1] = {0,0,0,0,4},
	},
}

_tab_model[8101] = {
	name = "MODEL_EFFECT:Aura04_2",
	loadmode = "plist",
	plist = "effect/aura04.plist",
	image = "effect/aura04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 40,
		pName = "effect/aura04/1957-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8102] = {
	name = "MODEL_EFFECT:Skybook",
	image = "effect/skybook.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 250,
		[1] = {0,0,64,64,4},
		[2] = {128,0,64,64,1},
		[3] = {64,0,64,64,1},
	},
}

_tab_model[8103] = {
	name = "MODEL_EFFECT:Daoguang02",
	loadmode = "plist",
	plist = "effect/daoguang02.plist",
	image = "effect/daoguang02.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 30,
		pName = "effect/daoguang02/997-",
		pMode = 3,
		[1] = {0,0,0,0,11},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}


_tab_model[8104] = {
	name = "MODEL_EFFECT:Liehuo",
	loadmode = "plist",
	plist = "effect/fire06.plist",
	image = "effect/fire06.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1},
		interval = 90,
		pName = "effect/fire06/1696-",
		pMode = {1,2,3},
		[1] = {0,0,0,0,9},
	},
}

_tab_model[8105] = {
	name = "MODEL_EFFECT:whirlwind2",
	image = "effect/whirlwind2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 120,
		[1] = {0,0,128,96,4},
		[2] = {0,96,128,96,4},
	},
}

_tab_model[8106] = {
	name = "MODEL_EFFECT:shield01",
	loadmode = "plist",
	plist = "effect/shield01.plist",
	image = "effect/shield01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 80,
		pName = "effect/shield01/",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

_tab_model[8107] = {
	name = "MODEL_EFFECT:laserball",
	image = "effect/laserball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,62,22,4},
	},
	dead = {
		image = "effect/laserball_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1.6,
		[1] = {0,0,30,32,5},
	},
}

_tab_model[8108] = {
	name = "MODEL_EFFECT:symbo2",
	image = "effect/symbol.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		interval = 50,
		[1] = {178,170,32,42,1},
		--[2] = {46,297,32,48,1},
	},
}

_tab_model[8109] = {
	name = "MODEL_EFFECT:bomb",
	image = "effect/bomb.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,1},
	},
}


_tab_model[8110] = {
	name = "MODEL_EFFECT:blackfog",
	loadmode = "plist",
	plist = "effect/blackfog.plist",
	image = "effect/blackfog.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "effect/blackfog/yw000",
		pMode = 3,
		[1] = {0,0,0,0,7},
	},
}

_tab_model[8111] = {
	name = "MODEL_EFFECT:battleshipopenmouth",
	loadmode = "plist",
	plist = "effect/battleshipopenmouth.plist",
	image = "effect/battleshipopenmouth.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/battleshipopenmouth/bom",
		pMode = 3,
		[1] = {0,0,0,0,13},
	},
}

_tab_model[8112] = {
	name = "MODEL_EFFECT:battleshipopenmouth_ani",
	loadmode = "plist",
	plist = "effect/battleshipopenmouth.plist",
	image = "effect/battleshipopenmouth.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/battleshipopenmouth/bom",
		pMode = 3,
		[1] = {0,0,0,0,-13},
	},
}

_tab_model[8113] = {
	name = "MODEL_EFFECT:bb_fire",
	loadmode = "plist",
	plist = "effect/bb_fire.plist",
	image = "effect/bb_fire.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		pName = "effect/bb_fire/fire000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8114] = {
	name = "MODEL_EFFECT:laserball2",
	image = "effect/laserball2.png",
	animation = {
		"stand",
--		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,62,22,4},
	},
	--[[
	dead = {
		image = "effect/laserball_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1.6,
		[1] = {0,0,30,32,5},
	},
	--]]
}

_tab_model[8115] = {
	name = "MODEL_EFFECT:bb_fire_ani",
	loadmode = "plist",
	plist = "effect/bb_fire.plist",
	image = "effect/bb_fire.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		pName = "effect/bb_fire/fire000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,-16},
	},
}

_tab_model[8116] = {
	name = "MODEL_EFFECT:bb_energy_anim",
	loadmode = "plist",
	plist = "effect/bb_energy.plist",
	image = "effect/bb_energy.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 85,
		pName = "effect/bb_energy/z1000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,5},
	},
}

_tab_model[8117] = {
	name = "MODEL_EFFECT:blackfog1",
	loadmode = "plist",
	plist = "effect/blackfog1.plist",
	image = "effect/blackfog1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 85,
		pName = "effect/blackfog1/yw000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,7},
	},
}


_tab_model[8118] = {
	name = "MODEL_EFFECT:bb_fire_can",
	image = "effect/bb_fire_eff.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,16,54,4},
		[2] = {0,54,16,54,4},
		[3] = {64,54,16,54,1},
		[4] = {64,54,16,54,1},
		[5] = {64,54,16,54,1},
		[6] = {48,54,16,54,1},
		[7] = {32,54,16,54,1},
		[8] = {16,54,16,54,1},
		[9] = {0,54,16,54,1},
	},
}

_tab_model[8119] = {
	name = "MODEL_EFFECT:bb_lz",
	image = "effect/bb_lz_eff.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,16,54,4},
		[2] = {0,54,16,54,4},
		[3] = {64,54,16,54,1},
		[4] = {64,54,16,54,1},
		[5] = {64,54,16,54,1},
		[6] = {64,54,16,54,1},
		[7] = {64,54,16,54,1},
		[8] = {32,54,16,54,1},
		[9] = {0,54,16,54,1},
	},
}

_tab_model[8120] = {
	name = "MODEL_EFFECT:bolang",
	loadmode = "plist",
	plist = "effect/bolang.plist",
	image = "effect/bolang.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 110,
		pName = "effect/bolang/sh000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,9},
	},
}


_tab_model[8121] = {
	name = "MODEL_EFFECT:Fire06_r",
	loadmode = "plist",
	plist = "effect/fire06.plist",
	image = "effect/fire06.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1},
		interval = 90,
		pName = "effect/fire06/1696-",
		pMode = 3,
		[1] = {0,0,0,0,-9},
	},
}


_tab_model[8122] = {
	name = "MODEL_EFFECT:mon_stone",
	loadmode = "plist",
	plist = "effect/mountain_monster.plist",
	image = "effect/mountain_monster.pvr.ccz",
	animation = {
		"stand",
	},
	stand = {
		interval = 500,
		[1] = {0,0,91,91,1},
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "unit/shengwu/mon_stone",
		pMode = 0,
		[1] = {0,0,0,0,1},
	},
}


_tab_model[8123] = {
	name = "MODEL_EFFECT:DownStone_MM",
	loadmode = "plist",
	plist = "effect/downstone_mm.plist",
	image = "effect/downstone_mm.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		pName = "effect/downstone_mm/downstone_mm",
		pMode = 3,
		[1] = {0,0,0,0,9},
	},
}

_tab_model[8124] = {
	name = "MODEL_EFFECT:Dust_MM",
	loadmode = "plist",
	plist = "effect/duest_mm.plist",
	image = "effect/duest_mm.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.4},
		interval = 100,
		pName = "effect/duest_mm/hc000",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

--闪现
_tab_model[8125] = {
	name = "MODEL_EFFECT:teleport2",
	image = "effect/teleport.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.65},
		interval = 60,
		[1] = {300,0,100,100,3},
		[2] = {0,100,100,100,5},
	},
}


_tab_model[8126] = {
	name = "MODEL_EFFECT:Roar02",
	loadmode = "plist",
	plist = "effect/roar01.plist",
	image = "effect/roar01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		roll = 45,
		pName = "effect/roar01/1715-",
		pMode = 3,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8127] = {
	name = "MODEL_EFFECT:Roar03",
	loadmode = "plist",
	plist = "effect/roar01.plist",
	image = "effect/roar01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		roll = 90,
		pName = "effect/roar01/1715-",
		pMode = 3,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8128] = {
	name = "MODEL_EFFECT:Roar04",
	loadmode = "plist",
	plist = "effect/roar01.plist",
	image = "effect/roar01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		roll = 135,
		pName = "effect/roar01/1715-",
		pMode = 3,
		[1] = {0,0,0,0,16},
	},
}

_tab_model[8129] = {
	name = "MODEL_EFFECT:Daoguang02x",
	loadmode = "plist",
	plist = "effect/daoguang02.plist",
	image = "effect/daoguang02.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 180,
		interval = 30,
		pName = "effect/daoguang02/997-",
		pMode = 3,
		[1] = {0,0,0,0,11},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

-------------------------------------------------------TD-------------------------------------------------------
--td毒塔的箭矢
_tab_model[8401] = {
	name = "MODEL_EFFECT:JIANTA2_BULLET",
	image = "effect/td_jianta2_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,75,75,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

--基础箭塔底座
_tab_model[8402] = {
	name = "MODEL_EFFECT:JIANTA_BASE",
	image = "effect/tdjianta_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,128,128,1},
	},
}

--基础炮塔的子弹
_tab_model[8403] = {
	name = "MODEL_EFFECT:PAOTA_BULLET",
	image = "effect/td_paota_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,32,32,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8404] = {
	name = "MODEL_EFFECT:PAOTA_BASE",
	image = "effect/tdpaota_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0, 0, 165, 165, 1},
	},
}

_tab_model[8405] = {
	name = "MODEL_EFFECT:fireball_01",
	image = "effect/fireball_01.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,64,32,4},
	},
	--[[
	dead = {
		image = "effect/blood_new.png",
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,100,32,4},
	},
	]]
}



_tab_model[8406] = {
	name = "MODEL_EFFECT:fireball_02",
	image = "effect/fireball_02.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,39,45,4},
	},
}

--手
_tab_model[8407] = {
	name = "MODEL_EFFECT:Hand",
	image = "effect/draghand.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5, 1},
		interval = 160,
		scale = 1.0,
		[1] = {0, 0, 40, 71},
		[2] = {0, 9, 40, 71},
		[3] = {0, 12, 40, 71},
		[4] = {0, 6, 40, 71},
		[5] = {0, 0, 40, 71},
	},
}

_tab_model[8408] = {
	name = "MODEL_EFFECT:fireball_03",
	image = "effect/fireball_03.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,39,45,4},
	},
}

_tab_model[8409] = {
	name = "MODEL_EFFECT:burst_2",
	image = "effect/burst_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,6},
	},
}

_tab_model[8410] = {
	name = "MODEL_EFFECT:zhua",
	image = "effect/zhua.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 160,
		[1] = {0,0,150,150,3},
	},
}

_tab_model[8411] = {
	name = "MODEL_EFFECT:banner2",
	image = "effect/banner2.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,128,1},
	},
	dead = {
		image = "effect/burst_3.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,3},
	},
}

_tab_model[8413] = {
	name = "MODEL_EFFECT:td_h1",
	image = "effect/td_h1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,15,86,144,1},
	},
}

_tab_model[8414] = {
	name = "MODEL_EFFECT:td_h2",
	image = "effect/td_h2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,86,144,1},
	},
}


_tab_model[8415] = {
	name = "MODEL_EFFECT:koushui",
	image = "effect/koushui.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}


_tab_model[8416] = {
	name = "MODEL_EFFECT:Judian2",
	image = "effect/judian2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,160,135,1},
	},
}


_tab_model[8417] = {
	name = "MODEL_EFFECT:td_d2",
	image = "effect/td_d2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,86,144,1},
	},
}

_tab_model[8418] = {
	name = "MODEL_EFFECT:td_p1",
	image = "effect/td_p1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,15,86,144,1},
	},
}

_tab_model[8419] = {
	name = "MODEL_EFFECT:shadowball_explosion",
	image = "effect/shadowball_explosion.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 30,
		[1] = {0,0,30,32,5},
	},
}


_tab_model[8420] = {
	name = "MODEL_EFFECT:banner3",
	image = "effect/banner3.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,128,1},
	},
	dead = {
		image = "effect/burst_3.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,3},
	},
}

_tab_model[8421] = {
	name = "MODEL_EFFECT:td_b2",
	image = "effect/td_b2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,86,144,1},
	},
}

_tab_model[8422] = {
	name = "MODEL_EFFECT:kmd",
	image = "effect/kmd.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,76,96,1},
	},
}

--粮仓
_tab_model[8423] = {
	name = "MODEL_EFFECT:lc",
	image = "effect/lc.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,106,132,1},
	},
}

--废墟
_tab_model[8424] = {
	name = "MODEL_EFFECT:fx",
	image = "effect/fx.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,94,52,1},
	},
}

_tab_model[8425] = {
	name = "MODEL_EFFECT:td_slt",
	image = "effect/td_slt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,240,272,1},
	},
}




--反向火球
_tab_model[8426] = {
	name = "MODEL_EFFECT:fireball-fan",
	image = "effect/fireball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.9,0.9},
		roll = 115,
		--flipX = 1,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.5},
		interval = 50,
		height = 1,
		scale = 1.6,
		[1] = {0,0,64,64,6},
	},
}


_tab_model[8427] = {
	name = "MODEL_EFFECT:banner4",
	image = "effect/banner4.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,128,1},
	},
	dead = {
		image = "effect/burst_3.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,3},
	},
}



_tab_model[8428] = {
	name = "MODEL_EFFECT:banner5",
	image = "effect/banner5.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,128,1},
	},
	dead = {
		image = "effect/burst_3.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,3},
	},
}


_tab_model[8429] = {
	name = "MODEL_EFFECT:td_gs",
	image = "effect/td_gs.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0, 0, 108, 90, 1},
	},
}


_tab_model[8430] = {
	name = "MODEL_EFFECT:dd",
	image = "effect/dd.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,56,58,1},
	},
}


--_tab_model[8431] = {
	--name = "MODEL_EFFECT:fireball2",
	--image = "effect/fireball.png",
	--animation = {
		--"stand",
		--"dead",
	--},
	--stand = {
		--anchor = {0.5,0.5},
		--roll = -90,
		----flipX = 1,
		--interval = 50,
		--[1] = {0,128*0,64,128,8},
		--[2] = {0,128*1,64,128,8},
		--[3] = {0,128*2,64,128,8},
		--[4] = {0,128*3,64,128,8},
	--},
	--dead = {
		--image = "effect/Blood_1.png",
		--anchor = {0.5,0.5},
		--interval = 100,
		--[1] = {0,0,37,43,5},
	--},
--}

_tab_model[8432] = {
	name = "MODEL_EFFECT:Arrow_emoji",
	image = "effect/arrow_emoji.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}



_tab_model[8433] = {
	name = "MODEL_EFFECT:emoji_1",
	image = "effect/emoji_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,1},
	},
}


_tab_model[8434] = {
	name = "MODEL_EFFECT:Arrow_emojiex",
	image = "effect/arrow_emoji.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -135,
		flipX = 1,
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}


_tab_model[8435] = {
	name = "MODEL_EFFECT:dd2",
	image = "effect/dd2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,35,35,1},
	},
}

_tab_model[8436] = {
	name = "MODEL_EFFECT:xianjing_1",
	image = "effect/xianjing_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,55,40,1},
	},
}

_tab_model[8437] = {
	name = "MODEL_EFFECT:xianjing_2",
	image = "effect/xianjing_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,2.1},
		interval = 300,
		[1] = {0,0,187,81,1},
	},
}

_tab_model[8438] = {
	name = "MODEL_EFFECT:xianjing_2_1",
	image = "effect/xianjing_2_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,1.1},
		interval = 300,
		[1] = {0,0,148,64,1},
	},
}

--红发底座
_tab_model[8439] = {
	name = "MODEL_EFFECT:TD_T",
	image = "effect/TD_T.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,140,170,1},
	},
}


----辅助塔攻击特效----
_tab_model[8440] = {
	name = "MODEL_EFFECT:mofadan",
	image = "effect/mofadan.png",
	animation = {
		"stand",
		 "dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 150,
		[1] = {0,0,100,50,3},
		[2] = {0,50,100,50,3},
		[3] = {0,100,100,50,1},
	},
	dead = {
		image = "effect/ice_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1.4,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
	},
}

---辅助塔 塔基
_tab_model[8441] = {
	name = "MODEL_EFFECT:TD_FZ",
	image = "effect/TD_FZ.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,113,113,1},
	},
}


--白发塔底座
_tab_model[8442] = {
	name = "MODEL_EFFECT:TD_T2",
	image = "effect/TD_T2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,140,170,1},
	},
}

--红法状态特效
_tab_model[8443] = {
	name = "MODEL_EFFECT:shixue",
	image = "effect/shixue.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,70,70,4},
		[2] = {0,70,70,70,4},
	},
}

--迷你地刺特效
_tab_model[8444] = {
	name = "MODEL_EFFECT:mini_dici",
	image = "effect/mini_dici.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,70,60,6},
		[2] = {0,60,70,70,6},
	},
}




---新塔特效
_tab_model[8445] = {
	name = "MODEL_EFFECT:TD_T3",
	image = "effect/TD_T3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,102,144,1},
	},
}

--攻击特效
_tab_model[8446] = {
	name = "MODEL_EFFECT:atk_buff",
	image = "effect/atk_buff.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,32,32,1},
	},
}

_tab_model[8447] = {
	name = "MODEL_EFFECT:biaoji",
	image = "effect/biaoji.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 80,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
	},
}

--炒鸡无敌龙卷风
_tab_model[8448] = {
	name = "MODEL_EFFECT:xuanfeng",
	image = "effect/xuanfeng.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 80,
		[1] = {0,0,150,150,4},
		[2] = {0,150,150,150,4},
	},
}

---新塔特效
_tab_model[8449] = {
	name = "MODEL_EFFECT:dicita",
	image = "effect/dicita.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,128,192,1},
	},
}


---徐庶剑阵特效
_tab_model[8450] = {
	name = "MODEL_EFFECT:jianzhen",
	image = "effect/jianzhen.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 52,
		[1] = {0,0,230,190,4},
		[2] = {0,190,230,190,5},
		[3] = {0,380,230,190,5},
		[4] = {0,570,230,190,5},
		[5] = {0,760,230,190,4},
	},
}

--徐庶状态特效
_tab_model[8451] = {
	name = "MODEL_EFFECT:shixue2",
	image = "effect/shixue2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,70,70,4},
		[2] = {0,70,70,70,4},
	},
}

--栅栏
_tab_model[8452] = {
	name = "MODEL_EFFECT:zhalan",
	image = "effect/zhalan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000000,
		[1] = {0,0,143,117,1},
	},
}

---辅助塔 塔基
_tab_model[8453] = {
	name = "MODEL_EFFECT:td_d4",
	image = "effect/td_d4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,86,144,1},
	},
}

---15级小乔特效
_tab_model[8454] = {
	name = "MODEL_EFFECT:taohua",
	image = "effect/taohua.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,80,75,5},
		[2] = {0,75,80,75,5},
		[3] = {0,150,80,75,5},
		[4] = {0,225,80,75,5},
	},
}

---15级小乔特效2
_tab_model[8455] = {
	name = "MODEL_EFFECT:smtaohua",
	image = "effect/smtaohua.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		[1] = {0,0,70,70,4},
		[2] = {0,70,70,70,4},
	},
}

_tab_model[8456] = {
	name = "MODEL_EFFECT:timg",
	image = "effect/timg.png",
	animation = {
		"stand",
	},
	stand = {
		interval = 100,
		[1] = {0,0,113,96,6},
	},
}


_tab_model[8457] = {
	name = "MODEL_EFFECT:bomb2",
	image = "effect/bomb2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,64,64,1},
	},
}



_tab_model[8458] = {
	name = "MODEL_EFFECT:mubei",
	image = "effect/mubei.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 1000,
		[1] = {0,0,105,207,1},
	},
}


_tab_model[8459] = {
	name = "MODEL_EFFECT:Arrow_06",
	image = "effect/arrow_06.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,16,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8460] = {
	name = "MODEL_EFFECT:bomb2_01",
	image = "effect/bomb2_01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 75,
		[1] = {0,0,85,81,1},
	},
}


--反向火球
_tab_model[8461] = {
	name = "MODEL_EFFECT:fireball-buff",
	image = "effect/fireball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--flipX = 1,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

_tab_model[8462] = {
	name = "MODEL_EFFECT:flycannon_huojian",
	loadmode = "plist",
	plist = "effect/flycannon_huojian.plist",
	image = "effect/flycannon_huojian.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 180, --初始旋转
		interval = 50,
		pName = "flycannon_huojian_0",
		pMode = 2,
		[1] = {0,0,0,0,4}, --数量
	},
}


_tab_model[8463] = {
	name = "MODEL_EFFECT:bomb3",
	image = "effect/bomb3.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,32,32,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}
--平放的手雷
_tab_model[8464] = {
	name = "MODEL_EFFECT:shoulei2",
	image = "effect/td_paota4_bullet.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,32,32,1},
	},
}

_tab_model[8465] = {
	name = "MODEL_EFFECT:mubei2",
	image = "effect/mubei2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,105,207,1},
	},
}

--_tab_model[8466] = {
	--name = "MODEL_EFFECT:fireball_02",
	--image = "effect/fireball_02.png",
	--animation = {
		--"stand",
		----"dead",
	--},
	--stand = {
		--anchor = {0.5,0.5},
		--roll = -180,
		--interval = 50,
		--[1] = {0,0,97,89,1},
	--},
	----[[
	--dead = {
		--image = "effect/blood_new.png",
		--anchor = {0.5,0.5},
		--interval = 300,
		--[1] = {0,0,100,32,4},
	--},
	--]]
--}
_tab_model[8467] = {
	name = "MODEL_EFFECT:zidan1",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan1-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}
	
_tab_model[8468] = {
	name = "MODEL_EFFECT:zidan2",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan2-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8469] = {
	name = "MODEL_EFFECT:zidan3",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		roll = 90,
		pName = "zidan3-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8470] = {
	name = "MODEL_EFFECT:zidan4",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan4-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8471] = {
	name = "MODEL_EFFECT:power_tower",
	image = "effect/power_tower.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 300,
		[1] = {0,0,85,112,6},
	},
}

_tab_model[8472] = {
	name = "MODEL_EFFECT:enemy_tower",
	image = "effect/enemy_tower.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,89,77,1},
	},
}

_tab_model[8473] = {
	name = "MODEL_EFFECT:electronic",
	image = "effect/electronic.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,2},
		[2] = {0,64,64,64,2},
	},
}

_tab_model[8474] = {
	name = "MODEL_EFFECT:zidan5",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan5-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}

_tab_model[8475] = {
	name = "MODEL_EFFECT:enemy_tower2",
	image = "effect/enemy_tower2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,89,77,1},
	},
}

_tab_model[8476] = {
	name = "MODEL_EFFECT:katongbaozha",
	image = "effect/katongbaozha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
		},
}

_tab_model[8477] = {
	name = "MODEL_EFFECT:zhadan",
	image = "effect/zhadan.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,42,42,3},
		[2] = {0,0,42,42,3},
		[3] = {0,0,42,42,3},
		},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,1},
	},
}

_tab_model[8478] = {
	name = "MODEL_EFFECT:zha",
	image = "effect/zha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,1},
		},
}

_tab_model[8479] = {
	name = "MODEL_EFFECT:zhadan2",
	image = "effect/zhadan2.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,42,42,3},
		[2] = {0,0,42,42,3},
		[3] = {0,0,42,42,3},
		},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,1},
	},
}

_tab_model[8480] = {
	name = "MODEL_EFFECT:enemy_tower3",
	image = "effect/enemy_tower3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,80,80,1},
	},
}

_tab_model[8481] = {
	name = "MODEL_EFFECT:enemy_tower4",
	image = "effect/enemy_tower4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,80,112,1},
	},
}

_tab_model[8482] = {
	name = "MODEL_EFFECT:attack_point",
	image = "effect/attack_point.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 500,
		[1] = {0,0,74,27,1},
	},
}
--NEW BOX
_tab_model[8483] = {
	name = "MODEL_EFFECT:box2",
	image = "effect/box2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 5000000,
		[1] = {0,0,68,69,1},
	},
}

_tab_model[8484] = {
	name = "MODEL_EFFECT:stone01",
	image = "effect/stone01.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8485] = {
	name = "MODEL_EFFECT:barrel",
	image = "effect/barrel.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,80,112,1},
	},
}

_tab_model[8486] = {
	name = "MODEL_EFFECT:stone02",
	image = "effect/stone02.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,64,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8487] = {
	name = "MODEL_EFFECT:bomb4",
	image = "effect/bomb4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,80,80,1},
	},
}

_tab_model[8488] = {
	name = "MODEL_EFFECT:iced",
	image = "effect/iced.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,128,128,1},
	},
}

_tab_model[8489] = {
	name = "MODEL_EFFECT:electronic2",
	image = "effect/electronic2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,2},
		[2] = {0,64,64,64,2},
	},
}

_tab_model[8490] = {
	name = "MODEL_EFFECT:obstacle",
	image = "effect/obstacle.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
}

_tab_model[8491] = {
	name = "MODEL_EFFECT:obstacle2",
	image = "effect/obstacle2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
}

_tab_model[8492] = {
	name = "MODEL_EFFECT:obstacle3",
	image = "effect/obstacle3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 500,
		[1] = {0,0,96,96,2},
	},
}

_tab_model[8493] = {
	name = "MODEL_EFFECT:electronic3",
	image = "effect/electronic3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,2},
		[2] = {0,64,64,64,2},
	},
}

_tab_model[8494] = {
	name = "MODEL_EFFECT:zidan12",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		roll = 90,
		pName = "zidan12-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8495] = {
	name = "MODEL_EFFECT:hanqi",
	image = "effect/hanqi.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		[1] = {0,0,50,80,7},
		[2] = {0,80,50,80,6},
	},
}

_tab_model[8496] = {
	name = "MODEL_EFFECT:boss6",
	image = "effect/boss6.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,320,320,1},
	},
}

_tab_model[8497] = {
	name = "MODEL_EFFECT:zidan8",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan8-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8498] = {
	name = "MODEL_EFFECT:zidan9",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan9-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8499] = {
	name = "MODEL_EFFECT:zidan10",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan10-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8500] = {
	name = "MODEL_EFFECT:zidan11",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		roll = -90,
		pName = "zidan11-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8501] = {
	name = "MODEL_EFFECT:boss6_s",
	image = "effect/boss6_s.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
}


--反向火球-红
_tab_model[8503] = {
	name = "MODEL_EFFECT:fireball-buff2",
	image = "effect/fireball5.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--flipX = 1,
		roll = -90,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

--反向火球-紫
_tab_model[8504] = {
	name = "MODEL_EFFECT:fireball-buff3",
	image = "effect/fireball6.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.3,0.5},
		roll = 180,
		interval = 50,
		[1] = {0,0,300,150,4},
		[2] = {0,150,300,150,4},
		[3] = {0,150*2,300,150,4},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

--反向火球-黄
_tab_model[8505] = {
	name = "MODEL_EFFECT:fireball-buff4",
	image = "effect/fireball8.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -90,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

--反向火球-超级
_tab_model[8506] = {
	name = "MODEL_EFFECT:fireball-buff5",
	image = "effect/fireball9.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.3,0.5},
		roll = 180,
		interval = 50,
		[1] = {0,0,300,150,4},
		[2] = {0,150,300,150,4},
		[3] = {0,150*2,300,150,4},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

_tab_model[8507] = {
	name = "MODEL_EFFECT:baozha",
	image = "effect/baozha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 90,
		[1] = {0,0,250,200,3},
		[2] = {0,200,250,200,3},
		[3] = {0,400,250,200,3},
		[4] = {0,600,250,200,1},
		},
}

_tab_model[8508] = {
	name = "MODEL_EFFECT:zidan13",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan13-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8509] = {
	name = "MODEL_EFFECT:zidan14",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan14-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8510] = {
	name = "MODEL_EFFECT:zidan15",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan15-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8511] = {
	name = "MODEL_EFFECT:Arrow_07",
	image = "effect/arrow_07.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,64,8,1},
	},
}

_tab_model[8512] = {
	name = "MODEL_EFFECT:shop2",
	image = "../xlobj/shop2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,123,155,1},
	},
}

_tab_model[8513] = {
	name = "MODEL_EFFECT:zidan16",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan16-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8514] = {
	name = "MODEL_EFFECT:jiantou",
	image = "effect/jiantou.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 300,
		[1] = {0,0,48,34,6},
	},
}

_tab_model[8515] = {
	name = "MODEL_EFFECT:guang",
	image = "effect/guang.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 150,
		[1] = {0,0,25,25,5},
	},
}

_tab_model[8516] = {
	name = "MODEL_EFFECT:circle",
	image = "effect/circle.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 500,
		[1] = {0,0,256,256,1},
	},
}

_tab_model[8517] = {
	name = "MODEL_EFFECT:jiantou2",
	image = "effect/jiantou2.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 300,
		[1] = {0,0,48,34,6},
	},
}

_tab_model[8518] = {
	name = "MODEL_EFFECT:zidan17",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan17-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8519] = {
	name = "MODEL_EFFECT:tishi",
	image = "effect/tishi.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {1,1},
		--roll = 90,
		interval = 5000000,
		[1] = {0,0,3200,69,1},
	},
}

--大炸弹
_tab_model[8520] = {
	name = "MODEL_EFFECT:zhadan4",
	image = "effect/zhadan4.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 1000,
		[1] = {0,0,128,128,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

_tab_model[8521] = {
	name = "MODEL_EFFECT:zhadan5",
	image = "effect/zhadan5.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -90,
		interval = 150,
		[1] = {0,0,40,50,5},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,1},
	},
}

_tab_model[8522] = {
	name = "MODEL_EFFECT:boss3",
	image = "effect/boss3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,347,256,1},
	},
}

_tab_model[8523] = {
	name = "MODEL_EFFECT:shop3",
	image = "../xlobj/shop3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,164,152,1},
	},
}

_tab_model[8524] = {
	name = "MODEL_EFFECT:prison01",
	image = "../xlobj/prison01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,112,1},
	},
}

_tab_model[8525] = {
	name = "MODEL_EFFECT:prison02",
	image = "../xlobj/prison02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,112,1},
	},
}

_tab_model[8526] = {
	name = "MODEL_EFFECT:mguncbase000",
	image = "effect/mguncbase000.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,41,44,1},
	},
}

_tab_model[8527] = {
	name = "MODEL_EFFECT:circle2",
	image = "effect/circle2.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 999999,
		[1] = {0,0,256,256,1},
	},
}

_tab_model[8528] = {
	name = "MODEL_EFFECT:yingzi",
	image = "effect/yingzi.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 999999,
		[1] = {0,0,82,81,1},
	},
}

_tab_model[8529] = {
	name = "MODEL_EFFECT:daodan2",
	image = "effect/daodan2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 999999,
		--roll = 180,
		[1] = {0,0,26,26,1},
	},
}

_tab_model[8530] = {
	name = "MODEL_EFFECT:circle3",
	image = "effect/circle3.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 999999,
		[1] = {0,0,256,256,1},
	},
}

_tab_model[8531] = {
	name = "MODEL_EFFECT:dust3",
	image = "effect/dust3.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 100,
		[1] = {0,0,100,60,7},
	},
}

_tab_model[8532] = {
	name = "MODEL_EFFECT:jiantou4",
	image = "effect/jiantou.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 300,
		[1] = {0,0,48,34,6},
	},
}

--竖火球-黄
_tab_model[8533] = {
	name = "MODEL_EFFECT:fireball8_x",
	image = "effect/fireball8.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.8},
		interval = 50,
		height = 1,
		scale = 1,
		[1] = {0,0,64,64,6},
	},
}

--准星
_tab_model[8534] = {
	name = "MODEL_EFFECT:miaozhun",
	image = "effect/miaozhun.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		[1] = {0,0,150,150,3},
		[2] = {0,150,150,150,3},
		[3] = {0,300,150,150,2},
	},
}

--集装箱01
_tab_model[8535] = {
	name = "MODEL_EFFECT:container01",
	image = "../xlobj/container01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱01（损1）
_tab_model[8536] = {
	name = "MODEL_EFFECT:container01_a",
	image = "../xlobj/container01_a.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱01（损2）
_tab_model[8537] = {
	name = "MODEL_EFFECT:container01_b",
	image = "../xlobj/container01_b.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱01（损3）
_tab_model[8538] = {
	name = "MODEL_EFFECT:container01_c",
	image = "../xlobj/container01_c.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱01（坏1）
_tab_model[8539] = {
	name = "MODEL_EFFECT:container01_d1",
	image = "../xlobj/container01_d1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱01（坏2）
_tab_model[8540] = {
	name = "MODEL_EFFECT:container01_d2",
	image = "../xlobj/container01_d2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱01（坏3）
_tab_model[8541] = {
	name = "MODEL_EFFECT:container01_d3",
	image = "../xlobj/container01_d3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱02
_tab_model[8542] = {
	name = "MODEL_EFFECT:container02",
	image = "../xlobj/container02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱02（损1）
_tab_model[8543] = {
	name = "MODEL_EFFECT:container02_a",
	image = "../xlobj/container02_a.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱02（损2）
_tab_model[8544] = {
	name = "MODEL_EFFECT:container02_b",
	image = "../xlobj/container02_b.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱02（损3）
_tab_model[8545] = {
	name = "MODEL_EFFECT:container02_c",
	image = "../xlobj/container02_c.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱02（坏1）
_tab_model[8546] = {
	name = "MODEL_EFFECT:container02_d1",
	image = "../xlobj/container02_d1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱02（坏2）
_tab_model[8547] = {
	name = "MODEL_EFFECT:container02_d2",
	image = "../xlobj/container02_d2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱02（坏3）
_tab_model[8548] = {
	name = "MODEL_EFFECT:container02_d3",
	image = "../xlobj/container02_d3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--升级
_tab_model[8549] = {
	name = "MODEL_EFFECT:upgrade",
	image = "effect/upgrade.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,59,64,5},
	},
}

--毒泡
_tab_model[8550] = {
	name = "MODEL_EFFECT:posion_ball",
	image = "effect/posion_ball.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,4},
	},
}

_tab_model[8551] = {
	name = "MODEL_EFFECT:guang3",
	image = "effect/guang3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 130,
		[1] = {0,0,70,70,5},
	},
}

_tab_model[8552] = {
	name = "MODEL_EFFECT:prison03",
	image = "../xlobj/prison03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,112,1},
	},
}

_tab_model[8553] = {
	name = "MODEL_EFFECT:prison04",
	image = "../xlobj/prison04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,96,112,1},
	},
}

_tab_model[8554] = {
	name = "MODEL_EFFECT:prison05",
	image = "../xlobj/prison05.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,96,112,1},
		[2] = {0,0,96,112,1},
	},
}

_tab_model[8555] = {
	name = "MODEL_EFFECT:prison_wall01",
	image = "../xlobj/prison_wall01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,254,264,1},
	},
}

_tab_model[8556] = {
	name = "MODEL_EFFECT:prison_wall02",
	image = "../xlobj/prison_wall02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,254,264,1},
	},
}

_tab_model[8557] = {
	name = "MODEL_EFFECT:prison_wall03",
	image = "../xlobj/prison_wall03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,254,264,1},
		[2] = {0,0,254,264,1},
	},
}

_tab_model[8558] = {
	name = "MODEL_EFFECT:track13_ex",
	image = "../xlobj/track13_ex.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,37,77,1},
	},
}

_tab_model[8559] = {
	name = "MODEL_EFFECT:taizi_ex",
	image = "effect/taizi_ex.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,111,111,1},
	},
}

_tab_model[8560] = {
	name = "MODEL_EFFECT:zidan19",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		roll = -90,
		pName = "zidan19-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8561] = {
	name = "MODEL_EFFECT:zidan20",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		roll = -90,
		pName = "zidan20-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[8562] = {
	name = "MODEL_EFFECT:zidan21",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan21-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

--瓦斯
_tab_model[8563] = {
	name = "MODEL_EFFECT:dust4",
	image = "effect/dust4.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 180,
		interval = 100,
		[1] = {0,0,100,60,7},
	},
}

_tab_model[8564] = {
	name = "MODEL_EFFECT:shuijing",
	image = "effect/shuijing.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 180,
		interval = 100,
		[1] = {0,0,64,64,1},
	},
}

--火花
_tab_model[8565] = {
	name = "MODEL_EFFECT:spark",
	loadmode = "plist",
	plist = "effect/spark.plist",
	image = "effect/spark.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "1857-",
		pMode = 3,
		[1] = {0,0,0,0,15},
	},
}

--核爆
_tab_model[8566] = {
	name = "MODEL_EFFECT:nuclear",
	loadmode = "plist",
	plist = "effect/nuclear.plist",
	image = "effect/nuclear.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "nuclear",
		pMode = 3,
		[1] = {0,0,0,0,15},
	},
}

--火花2
_tab_model[8567] = {
	name = "MODEL_EFFECT:spark2",
	loadmode = "plist",
	plist = "effect/spark2.plist",
	image = "effect/spark2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "1808-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

--烟汽
_tab_model[8568] = {
	name = "MODEL_EFFECT:smoke04",
	loadmode = "plist",
	plist = "effect/smoke04.plist",
	image = "effect/smoke04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "1821-",
		pMode = 3,
		[1] = {0,0,0,0,12},
	},
}

--烟汽2
_tab_model[8569] = {
	name = "MODEL_EFFECT:smoke05",
	loadmode = "plist",
	plist = "effect/smoke05.plist",
	image = "effect/smoke05.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "1811-",
		pMode = 3,
		[1] = {0,0,0,0,13},
	},
}

--闪烁
_tab_model[8570] = {
	name = "MODEL_EFFECT:blink",
	loadmode = "plist",
	plist = "effect/blink.plist",
	image = "effect/blink.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "1196-",
		pMode = 3,
		[1] = {0,0,0,0,11},
	},
}

_tab_model[8571] = {
	name = "MODEL_EFFECT:shadow2",
	image = "effect/shadow2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,264,116,1},
	},
}

_tab_model[8572] = {
	name = "MODEL_EFFECT:coin",
	image = "effect/coin.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,32,32,8},
	},
}

_tab_model[8573] = {
	name = "MODEL_EFFECT:fan1",
	image = "effect/fan1.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 120,
		[1] = {0,0,198,200,5},
	},
}

_tab_model[8574] = {
	name = "MODEL_EFFECT:fan2",
	image = "effect/fan2.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 120,
		[1] = {0,0,198,215,5},
	},
}

_tab_model[8575] = {
	name = "MODEL_EFFECT:shuijing2",
	image = "effect/shuijing2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,90,78,1},
	},
}

_tab_model[8576] = {
	name = "MODEL_EFFECT:plate",
	loadmode = "plist",
	plist = "effect/plate.plist",
	image = "effect/plate.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "plate",
		pMode = 3,
		[1] = {0,0,0,0,6},
	},
}

--单石头maze3_11
_tab_model[8577] = {
	name = "MODEL_EFFECT:maze3_11",
	image = "effect/maze3_11.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,70,88,1},
	},
}

--菌毯1
_tab_model[8578] = {
	name = "MODEL_EFFECT:creep01",
	image = "../xlobj/creep_01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

--菌毯2
_tab_model[8579] = {
	name = "MODEL_EFFECT:creep02",
	image = "../xlobj/creep_02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

--菌毯3
_tab_model[8580] = {
	name = "MODEL_EFFECT:creep03",
	image = "../xlobj/creep_03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

--菌毯4
_tab_model[8581] = {
	name = "MODEL_EFFECT:creep04",
	image = "../xlobj/creep_04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

--冰球
_tab_model[8582] = {
	name = "MODEL_EFFECT:ice_ball",
	image = "effect/ice_ball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,1},
	},
}

--菌毯网
_tab_model[8583] = {
	name = "MODEL_EFFECT:creep_net",
	image = "../xlobj/creep_net.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,82,51,1},
	},
}

--地雷
_tab_model[8584] = {
	name = "MODEL_EFFECT:mine",
	image = "effect/mine.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,95,70,1},
	},
}

_tab_model[8585] = {
	name = "MODEL_EFFECT:T_save",
	image = "effect/T_save.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,74,67,1},
	},
}

--铁轨
_tab_model[8586] = {
	name = "MODEL_EFFECT:rail01",
	image = "../xlobj/rail01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,144,96,1},
	},
}

--飞碟阴影
_tab_model[8587] = {
	name = "MODEL_EFFECT:plate_shadow",
	image = "effect/plate_shadow.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,256,256,1},
	},
}

--平房X
_tab_model[8588] = {
	name = "MODEL_EFFECT:prison_x_01",
	image = "../xlobj/prison_x.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 250,
		[1] = {0,0,154,178,4},
	},
}

_tab_model[8589] = {
	name = "MODEL_EFFECT:prison_x_02",
	image = "../xlobj/prison_x.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {154,178,154,178,1},
	},
}

_tab_model[8590] = {
	name = "MODEL_EFFECT:prison_x_03",
	image = "../xlobj/prison_x.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {308,178,154,178,1},
	},
}

_tab_model[8591] = {
	name = "MODEL_EFFECT:prison_x_04",
	image = "../xlobj/prison_x.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {462,178,154,178,1},
		[2] = {462,178,154,178,1},
	},
}

_tab_model[8592] = {
	name = "MODEL_EFFECT:prison_wall_x_01",
	image = "../xlobj/prison_wall_x_01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,254,264,1},
	},
}

_tab_model[8593] = {
	name = "MODEL_EFFECT:prison_wall_x_02",
	image = "../xlobj/prison_wall_x_02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,254,264,1},
	},
}

_tab_model[8594] = {
	name = "MODEL_EFFECT:prison_wall_x_03",
	image = "../xlobj/prison_wall_x_03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 9999999,
		[1] = {0,0,254,264,1},
		[2] = {0,0,254,264,1},
	},
}

--金属箱
_tab_model[8595] = {
	name = "MODEL_EFFECT:container03",
	image = "../xlobj/container03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

_tab_model[8596] = {
	name = "MODEL_EFFECT:dupao",
	loadmode = "plist",
	plist = "effect/dupao.plist",
	image = "effect/dupao.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "dupao-",
		pMode = 3,
		[1] = {0,0,0,0,4},
	},
}

_tab_model[8597] = {
	name = "MODEL_EFFECT:smoke06",
	loadmode = "plist",
	plist = "effect/smoke06.plist",
	image = "effect/smoke06.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "1319-",
		pMode = 3,
		[1] = {0,0,0,0,10},
	},
}

--冲击
_tab_model[8598] = {
	name = "MODEL_EFFECT:impulse",
	image = "effect/impulse.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		roll = 180,
		[1] = {0,0,51,114,1},
	},
}

--钢铁气球影子
_tab_model[8599] = {
	name = "MODEL_EFFECT:metal_balloon_shadow",
	loadmode = "plist",
	plist = "effect/metal_balloon_shadow.plist",
	image = "effect/metal_balloon_shadow.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "1000",
		pMode = 2,
		[1] = {0,0,0,0,16},
	},
}

--螺旋
_tab_model[8600] = {
	name = "MODEL_EFFECT:luoxuan",
	image = "effect/luoxuan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		roll = 0,
		[1] = {0,0,64,64,1},
	},
}

_tab_model[8601] = {
	name = "MODEL_EFFECT:nuclear_barrel",
	image = "../xlobj/nuclear_barrel.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,152,144,1},
	},
}

--朝下竖火球-黄
_tab_model[8602] = {
	name = "MODEL_EFFECT:fireball8_x2",
	image = "effect/fireball8.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 180,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
}

--金属箱（损1）
_tab_model[8603] = {
	name = "MODEL_EFFECT:container03_a",
	image = "../xlobj/container03_a.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--金属箱（损2）
_tab_model[8604] = {
	name = "MODEL_EFFECT:container03_b",
	image = "../xlobj/container03_b.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--金属箱（损3）
_tab_model[8605] = {
	name = "MODEL_EFFECT:container03_c",
	image = "../xlobj/container03_c.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--金属箱（坏1）
_tab_model[8606] = {
	name = "MODEL_EFFECT:container03_d1",
	image = "../xlobj/container03_d1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--金属箱（坏2）
_tab_model[8607] = {
	name = "MODEL_EFFECT:container03_d2",
	image = "../xlobj/container03_d2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--火花3
_tab_model[8608] = {
	name = "MODEL_EFFECT:spark3",
	loadmode = "plist",
	plist = "effect/spark3.plist",
	image = "effect/spark3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "1808x-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8609] = {
	name = "MODEL_EFFECT:shuijing3",
	image = "effect/shuijing3.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 180,
		interval = 100,
		[1] = {0,0,64,64,1},
	},
}

--雷神之锤A
_tab_model[8610] = {
	name = "MODEL_EFFECT:thunder_A",
	loadmode = "plist",
	plist = "effect/thunder2.plist",
	image = "effect/thunder2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "thunder2-",
		pMode = 3,
		[1] = {0,0,0,0,32},
	},
}

--雷神之锤B
_tab_model[8611] = {
	name = "MODEL_EFFECT:thunder_B",
	loadmode = "plist",
	plist = "effect/thunder3.plist",
	image = "effect/thunder3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "thunder3-",
		pMode = 3,
		[1] = {0,0,0,0,32},
	},
}

--陷阱
_tab_model[8612] = {
	name = "MODEL_EFFECT:trap",
	image = "effect/trap.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 50,
		[1] = {0,0,367,283,1},
	},
}

_tab_model[8613] = {
	name = "MODEL_EFFECT:zidan22",
	image = "effect/zidan22.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,60,60,1},
	},
}

--传送门
_tab_model[8614] = {
	name = "MODEL_EFFECT:gate",
	image = "effect/gate.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 100,
		[1] = {0,0,130,134,4},
		[2] = {0,134,130,134,4},
		[3] = {0,268,130,134,4},
	},
}

_tab_model[8615] = {
	name = "MODEL_EFFECT:gas_barrel",
	image = "../xlobj/gas_barrel.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

--战役图标2
_tab_model[8616] = {
	name = "MODEL_EFFECT:boss_02",
	image = "../image/icon/hero/boss_02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,180,180,1},
	},
}

--战役图标3
_tab_model[8617] = {
	name = "MODEL_EFFECT:boss_03",
	image = "../image/icon/hero/boss_03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,180,137,1},
	},
}

--战役图标4
_tab_model[8618] = {
	name = "MODEL_EFFECT:boss_04",
	image = "../image/icon/hero/boss_04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,180,134,1},
	},
}

--传送天梯
_tab_model[8619] = {
	name = "MODEL_EFFECT:space_ladder",
	image = "effect/space_ladder.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,200,290,4},
		[2] = {0,290,200,290,4},
		[3] = {0,580,200,290,4},
	},
}

--售货机
_tab_model[8620] = {
	name = "MODEL_EFFECT:automat",
	loadmode = "plist",
	plist = "effect/automat.plist",
	image = "effect/automat.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		pName = "automat_",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

_tab_model[8621] = {
	name = "MODEL_EFFECT:zidan23",
	image = "effect/zidan23.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,75,77,1},
	},
}

--集装箱04
_tab_model[8622] = {
	name = "MODEL_EFFECT:container04",
	image = "../xlobj/container04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱04（损1）
_tab_model[8623] = {
	name = "MODEL_EFFECT:container04_a",
	image = "../xlobj/container04_a.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱04（损2）
_tab_model[8624] = {
	name = "MODEL_EFFECT:container04_b",
	image = "../xlobj/container04_b.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱04（损3）
_tab_model[8625] = {
	name = "MODEL_EFFECT:container04_c",
	image = "../xlobj/container04_c.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.75,0.5},
		interval = 1000,
		[1] = {0,0,48,96,1},
	},
}

--集装箱04（坏1）
_tab_model[8626] = {
	name = "MODEL_EFFECT:container04_d1",
	image = "../xlobj/container04_d1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱04（坏2）
_tab_model[8627] = {
	name = "MODEL_EFFECT:container04_d2",
	image = "../xlobj/container04_d2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

--集装箱04（坏3）
_tab_model[8628] = {
	name = "MODEL_EFFECT:container04_d3",
	image = "../xlobj/container04_d3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 9999999,
		[1] = {0,0,48,96,1},
		[2] = {0,0,48,96,1},
	},
}

_tab_model[8629] = {
	name = "MODEL_EFFECT:scan",
	loadmode = "plist",
	plist = "effect/scan.plist",
	image = "effect/scan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "scan-",
		pMode = 3,
		[1] = {0,0,0,0,8},
	},
}

--迷宫生成器
_tab_model[8630] = {
	name = "MODEL_EFFECT:map_editor",
	image = "../xlobj/map_editor.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,106,106,1},
	},
}

--氪石碎片
_tab_model[8631] = {
	name = "MODEL_EFFECT:fragment",
	image = "effect/fragment.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,32,32,1},
	},
}

--显示器
_tab_model[8632] = {
	name = "MODEL_EFFECT:ranktv",
	image = "effect/ranktv.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,110,110,1},
	},
}

_tab_model[8633] = {
	name = "MODEL_EFFECT:ditai2",
	image = "../xlobj/ditai2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,118,138,1},
	},
}

--创可贴
_tab_model[8634] = {
	name = "MODEL_EFFECT:Band_aid",
	image = "effect/Band_aid.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		[1] = {0,0,48,48,1},
	},
}

--激光门
_tab_model[8635] = {
	name = "MODEL_EFFECT:laser_door",
	image = "effect/laser_door.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,50,70,4},
	},
}

--激光开关
_tab_model[8636] = {
	name = "MODEL_EFFECT:laser_control",
	image = "effect/laser_control.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 800,
		[1] = {0,0,60,100,2},
	},
}

--竖激光门
_tab_model[8637] = {
	name = "MODEL_EFFECT:laser_door2",
	image = "effect/laser_door2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,50,70,3},
	},
}

--充能塔
_tab_model[8638] = {
	name = "MODEL_EFFECT:charge_tower",
	image = "effect/charge_tower.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 800,
		[1] = {0,0,54,114,2},
	},
}

--雷云
_tab_model[8639] = {
	name = "MODEL_EFFECT:thunder_storm",
	image = "effect/thunder_storm.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,331,189,4},
		[2] = {0,189,331,189,4},
		[3] = {0,378,331,189,4},
		[4] = {0,567,331,189,4},
		[5] = {0,756,331,189,4},
		[6] = {0,945,331,189,4},
		[7] = {0,1134,331,189,4},
		[8] = {0,1323,331,189,4},
		[9] = {0,1512,331,189,4},
	},
}

_tab_model[8640] = {
	name = "MODEL_EFFECT:warning2",
	image = "effect/warning2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,64,64,2},
	},
}

---工程师车库装饰
_tab_model[8641] = {
	name = "MODEL_EFFECT:garage_01",
	image = "../xlobj/garage_01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,190,140,1},
	},
}

_tab_model[8642] = {
	name = "MODEL_EFFECT:garage_02",
	image = "../xlobj/garage_02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,190,1},
	},
}

_tab_model[8643] = {
	name = "MODEL_EFFECT:garage_03",
	image = "../xlobj/garage_03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,280,200,1},
	},
}

_tab_model[8644] = {
	name = "MODEL_EFFECT:garage_04",
	image = "../xlobj/garage_04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,430,180,1},
	},
}

_tab_model[8645] = {
	name = "MODEL_EFFECT:juqi",
	image = "effect/juqi.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,120,90,5},
		[2] = {0,90,120,90,5},
		[3] = {0,90*2,120,90,5},
		[4] = {0,90*3,120,90,5},
		[5] = {0,90*4,120,90,3},
	},
}

_tab_model[8646] = {
	name = "MODEL_EFFECT:shield03",
	image = "effect/shield03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,356,356,1},
	},
}

_tab_model[8647] = {
	name = "MODEL_EFFECT:zhadan7",
	image = "effect/zhadan7.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 1000,
		[1] = {0,0,21,73,1},
	},
}

---残骸车库装饰
_tab_model[8648] = {
	name = "MODEL_EFFECT:remains_01",
	image = "../xlobj/remains_01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,131,74,1},
	},
}

_tab_model[8649] = {
	name = "MODEL_EFFECT:remains_02",
	image = "../xlobj/remains_02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,136,92,1},
	},
}

_tab_model[8650] = {
	name = "MODEL_EFFECT:remains_03",
	image = "../xlobj/remains_03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,171,110,1},
	},
}

_tab_model[8651] = {
	name = "MODEL_EFFECT:remains_04",
	image = "../xlobj/remains_04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,192,117,1},
	},
}

_tab_model[8652] = {
	name = "MODEL_EFFECT:remains_05",
	image = "../xlobj/remains_05.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,238,133,1},
	},
}

_tab_model[8653] = {
	name = "MODEL_EFFECT:fire_hole",
	image = "../xlobj/fire_hole.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,112,112,1},
	},
}

_tab_model[8654] = {
	name = "MODEL_EFFECT:ditai3",
	image = "../xlobj/ditai3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,152,124,1},
	},
}

_tab_model[8655] = {
	name = "MODEL_EFFECT:bunker",
	image = "../xlobj/bunker.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,163,138,1},
	},
}

_tab_model[8656] = {
	name = "MODEL_EFFECT:zidan5_t1",
	image = "effect/zidan5_t1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,28,60,1},
	},
}

_tab_model[8657] = {
	name = "MODEL_EFFECT:zidan5_t2",
	image = "effect/zidan5_t2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,28,60,1},
	},
}

_tab_model[8658] = {
	name = "MODEL_EFFECT:zidan13_t1",
	image = "effect/zidan13_t1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,96,60,1},
	},
}

_tab_model[8659] = {
	name = "MODEL_EFFECT:zidan13_t2",
	image = "effect/zidan13_t2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,96,60,1},
	},
}

_tab_model[8660] = {
	name = "MODEL_EFFECT:zidan14_t1",
	image = "effect/zidan14_t1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,103,60,1},
	},
}

_tab_model[8661] = {
	name = "MODEL_EFFECT:zidan14_t2",
	image = "effect/zidan14_t2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,103,60,1},
	},
}

_tab_model[8662] = {
	name = "MODEL_EFFECT:net_sky01",
	loadmode = "plist",
	plist = "effect/net_sky01.plist",
	image = "effect/net_sky01.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "net_sky01-",
		pMode = 3,
		[1] = {0,0,0,0,20},
	},
}

_tab_model[8663] = {
	name = "MODEL_EFFECT:net_sky02",
	loadmode = "plist",
	plist = "effect/net_sky02.plist",
	image = "effect/net_sky02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.54},
		interval = 60,
		pName = "net_sky02-",
		pMode = 3,
		[1] = {0,0,0,0,20},
	},
}

_tab_model[8664] = {
	name = "MODEL_EFFECT:net_sky03",
	loadmode = "plist",
	plist = "effect/net_sky03.plist",
	image = "effect/net_sky03.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.56},
		interval = 120,
		pName = "net_sky03-",
		pMode = 3,
		[1] = {0,0,0,0,20},
	},
}

_tab_model[8665] = {
	name = "MODEL_EFFECT:net_sky04",
	loadmode = "plist",
	plist = "effect/net_sky04.plist",
	image = "effect/net_sky04.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.56},
		interval = 60,
		pName = "net_sky04-",
		pMode = 3,
		[1] = {0,0,0,0,20},
	},
}

_tab_model[8666] = {
	name = "MODEL_EFFECT:shadow3",
	image = "effect/shadow3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,160,30,1},
	},
}

_tab_model[8667] = {
	name = "MODEL_EFFECT:Acid_2",
	image = "effect/Acid_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,148,122,4},
		[2] = {0,122,148,122,3},
	},
}

_tab_model[8668] =
{
	name = "MODEL_EFFECT:blowit_sign",
	image = "effect/blowit_sign.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,89,99},
		[2] = {0,-3,89,99},
		[3] = {0,-5,89,99},
		[4] = {0,-2,89,99},
		[5] = {0,0,89,99},
	},
}

_tab_model[8669] = {
	name = "MODEL_EFFECT:bunker2",
	image = "../xlobj/bunker2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,200,1},
	},
}

_tab_model[8670] = {
	name = "MODEL_EFFECT:hole_fire",
	image = "effect/hole_fire.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,112,112,5},
	},
}

_tab_model[8671] = {
	name = "MODEL_EFFECT:hole_lighting",
	image = "effect/hole_lighting.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,112,112,5},
	},
}

_tab_model[8672] = {
	name = "MODEL_EFFECT:hole_poison",
	image = "effect/hole_poison.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		[1] = {0,0,112,112,4},
		[2] = {0,112,112,112,4},
		[3] = {0,224,112,112,2},
	},
}

_tab_model[8673] = {
	name = "MODEL_EFFECT:bunker_x",
	image = "../xlobj/bunker.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,163,138},
		[2] = {0,-2,163,138},
		[3] = {0,-4,163,138},
		[4] = {0,-2,163,138},
		[5] = {0,0,163,138},
	},
}
_tab_model[8674] = {
	name = "MODEL_EFFECT:ZWYB",
	image = "effect/zwyb.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,80,80,1},
	},
}
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------



_tab_model[8999] = {
	name = "MODEL_EFFECT:way_arrows",
	image = "effect/way_arrows.png",
	animation = {
		"0",
	},

	--------------------------------
	["0"] = {{48*16,0,48,48},},
}

local direction = {
	["+3-3"] = {{48*0,0,48,48},},
	["-3+3"] = {{48*1,0,48,48},},
	["+1-1"] = {{48*2,0,48,48},},
	["-1+1"] = {{48*3,0,48,48},},
	["-2+2"] = {{48*4,0,48,48},},
	["-4+4"] = {{48*5,0,48,48},},
	["+4-4"] = {{48*6,0,48,48},},
	["+2-2"] = {{48*7,0,48,48},},
	--------------------------------
	["-2+3"] = {{48*8,0,48,48},},
	["+1+2"] = {{48*8,0,48,48},},

	["-3+2"] = {{48*9,0,48,48},},
	["-2-1"] = {{48*9,0,48,48},},

	["-3-4"] = {{48*10,0,48,48},},
	["-4+1"] = {{48*10,0,48,48},},

	["-4+3"] = {{48*11,0,48,48},},
	["-1+4"] = {{48*11,0,48,48},},

	["+1-4"] = {{48*12,0,48,48},},
	["+4-3"] = {{48*12,0,48,48},},

	["+4-1"] = {{48*13,0,48,48},},
	["+3-4"] = {{48*13,0,48,48},},

	["+2+1"] = {{48*14,0,48,48},},
	["+3-2"] = {{48*14,0,48,48},},

	["+2-3"] = {{48*15,0,48,48},},
	["-1-2"] = {{48*15,0,48,48},},
}

--|1 2 3|--|135  90  45|
--|4 * 5|--|180  *    0|
--|6 7 8|--|225 270 305|
local direction = {
	["stand_0"] = {{48*16,0,48,48},},
	["stand_2"] = {{48*0,0,48,48},},
	["stand_7"] = {{48*1,0,48,48},},
	["stand_4"] = {{48*2,0,48,48},},
	["stand_5"] = {{48*3,0,48,48},},
	["stand_6"] = {{48*4,0,48,48},},
	["stand_8"] = {{48*5,0,48,48},},
	["stand_1"] = {{48*6,0,48,48},},
	["stand_3"] = {{48*7,0,48,48},},
}
for k,v in pairs(direction)do
	table.insert(_tab_model[8999].animation,k)
	_tab_model[8999][k] = v
end


--[9000~9999场景]--------------------------------
--[[
_tab_model[9998] = {
	name = "MODEL_EFFECT:kna_ex1",
	image = "effect/kna_ex1.png",
	animation = {
		"birth",
	},
	birth = {
		interval = 100,
		anchor = {0,1},
		[1] = {0,0,640,480,20},
	},
}]]

_tab_model[9000] = {
	name = "MODEL_EFFECT:arrow",
	image = "misc/chapter_arrow.png",
	animation = {
		"arrow",
	},
	arrow = {
		interval = 120,
		anchor = {0.5,0.5},
		[1] = {0,0,46,16,1},
		[2] = {46,0,46,16,1},
		[3] = {92,0,46,16,1},
		[4] = {138,0,46,16,1},
		[5] = {92,0,46,16,1},
		[6] = {46,0,46,16,1},
	},
}

--移动不能到达的提示特效
_tab_model[9001] =
{
	name = "MODEL_EFFECT:way_not_arrow",
	image = "effect/way_not_arrow.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5, 0.5},
		interval = 170,
		[1] = {0,0,39,39},
		[2] = {39,0,39,39},
	},
}

--不能施法特效
_tab_model[9002] = {
	name = "MODEL_EFFECT:banned",
	image = "effect/waiting.png",
	animation = {
		"waiting",
	},
	waiting = {
		anchor = {0.5,0.5},
		interval = 30,
	},
}
for i = 1, 4, 1 do
	_tab_model[9002].waiting[i] = {0,0+(i-1)*64,64,64,4}
end

--静态手
_tab_model[9004] = {
	name = "MODEL_EFFECT:HandStatic",
	image = "effect/draghand.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5, 1},
		interval = 1000,
		scale = 1.0,
		[1] = {0, 0, 40, 71},
	},
}

--巨炮塔底座
_tab_model[9005] = {
	name = "MODEL_EFFECT:PAOTA2_BASE",
	image = "effect/tdpaota2_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0, 165, 165,1},
	},
}

--绿色旗子
_tab_model[9006] = {
	name = "MODEL_EFFECT:flag_green",
	image = "effect/flag_green.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,54,50,1},
	},
}

--红色旗子
_tab_model[9007] = {
	name = "MODEL_EFFECT:flag_red",
	image = "effect/flag_red.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.7},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,54,50,1},
	},
}

--连弩塔底座
_tab_model[9008] = {
	name = "MODEL_EFFECT:JIANTA1_BASE",
	image = "effect/tdjianta1_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,145,145,1},
	},
}

--毒塔底座
_tab_model[9009] = {
	name = "MODEL_EFFECT:JIANTA2_BASE",
	image = "effect/tdjianta2_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5, 0.5},
		interval = 1000,
		[1] = {0, 0, 145, 145, 1},
	},
}

--滚石塔底座
_tab_model[9010] = {
	name = "MODEL_EFFECT:PAOTA1_BASE",
	image = "effect/tdpaota1_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0, 165, 165,1},
	},
}

--轰天塔的子弹
_tab_model[9011] = {
	name = "MODEL_EFFECT:PAOTA2_BULLET",
	image = "effect/td_paota1_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,17,47,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

--榴弹
_tab_model[9012] = {
	name = "MODEL_EFFECT:PAOTA1_BULLET",
	image = "effect/td_paota1_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 1000,
		[1] = {0,0,17,47,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

--狙击塔底座
_tab_model[9013] = {
	name = "MODEL_EFFECT:JIANTA3_BASE",
	image = "effect/tdjianta3_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5, 0.5},
		interval = 1000,
		[1] = {0, 0, 145, 145, 1},
	},
}

--td连弩塔的箭矢
_tab_model[9014] = {
	name = "MODEL_EFFECT:JIANTA_BULLET",
	image = "effect/td_jianta_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,128,128,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}


_tab_model[9015] = {
	name = "MODEL_EFFECT:laserballX",
	image = "effect/laserball.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 50,
		[1] = {0,0,62,22,4},
	},
}

--td投石车
_tab_model[9016] = {
	name = "MODEL_EFFECT:stoneTD",
	image = "effect/stone.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,96,96,1},
	},
	dead = {
		plist = "effect/blackfog1.plist",
		image = "effect/blackfog1.png",
		anchor = {0.5,0.5},
		interval = 85,
		pName = "effect/blackfog1/yw000",
		pMode = 3,
		flipX = 1,
		[1] = {0,0,0,0,7},
	},
}

_tab_model[9017] = {
	name = "MODEL_EFFECT:gunshi",
	image = "effect/td_paota3_bullet.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,91,91,1},
	},
}

_tab_model[9018] = {
	name = "MODEL_EFFECT:TAJI_BAN",
	image = "misc/close.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,48,48,1},
	},
}

_tab_model[9019] = {
	name = "MODEL_EFFECT:jidi",
	image = "effect/jidi.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,256,224,1},
	},
}

_tab_model[9020] = {
	name = "MODEL_EFFECT:bingdan",
	image = "effect/bingdan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -180,
		interval = 200,
		[1] = {0,0,150,125,6},
		[1] = {0,125,150,125,6},
	},
}

_tab_model[9021] = {
	name = "MODEL_EFFECT:ice_explosion3",
	image = "effect/ice_explosion2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,64,64,4},
		[2] = {0,64,64,64,4},
	},
}

_tab_model[9022] = {
	name = "MODEL_EFFECT:bindong",
	image = "effect/bindong.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 10000,
		[1] = {0,0,253,151,1},
	},
}

_tab_model[9023] = {
	name = "MODEL_EFFECT:huofeng",
	image = "effect/huofeng.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,150,150,5},
		[2] = {0,0,150,150,5},
	},
}

--大法师
_tab_model[9024] = {
	name = "MODEL_EFFECT:NPC1",
	image = "effect/NPC1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,128,128,4},
	},
}

--blood_new1
_tab_model[9025] = {
	name = "MODEL_EFFECT:Blood_New1",
	image = "effect/blood_new.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,0,112,80,4},
		[2] = {112*3,0,112,80,1},
		[3] = {112*3,0,112,80,1},
		[4] = {112*3,0,112,80,1},
		[5] = {112*3,0,112,80,1},
		[6] = {112*3,0,112,80,1},
		[7] = {112*3,0,112,80,1},
		[8] = {112*3,0,112,80,1},
		[9] = {112*3,0,112,80,1},
		[10] = {112*3,0,112,80,1},
		[11] = {112*3,0,112,80,1},
		[12] = {112*3,0,112,80,1},
		[13] = {112*3,0,112,80,1},
		[14] = {112*3,0,112,80,1},
		[15] = {112*3,0,112,80,1},
		[16] = {112*3,0,112,80,1},
		[17] = {112*3,0,112,80,1},
		[18] = {112*3,0,112,80,1},
		[19] = {112*3,0,112,80,1},
		[20] = {112*3,0,112,80,1},
		[21] = {112*3,0,112,80,1},
		[22] = {112*3,0,112,80,1},
		[23] = {112*3,0,112,80,1},
		[24] = {112*3,0,112,80,1},
		[25] = {112*3,0,112,80,1},
		[26] = {112*3,0,112,80,1},
		[27] = {112*3,0,112,80,1},
		[28] = {112*3,0,112,80,1},
		[29] = {112*3,0,112,80,1},
		[30] = {112*3,0,112,80,1},
		[31] = {112*3,0,112,80,1},
		[32] = {112*3,0,112,80,1},
		[33] = {112*3,0,112,80,1},
		[34] = {112*3,0,112,80,1},
		[35] = {112*3,0,112,80,1},
		[36] = {112*3,0,112,80,1},
		[37] = {112*3,0,112,80,1},
		[38] = {112*3,0,112,80,1},
		[39] = {112*3,0,112,80,1},
		[40] = {112*3,0,112,80,1},
		[41] = {112*3,0,112,80,1},
		[42] = {112*3,0,112,80,1},
		[43] = {112*3,0,112,80,1},
		[44] = {112*3,0,112,80,1},
		[45] = {112*3,0,112,80,1},
		[46] = {112*3,0,112,80,1},
		[47] = {112*3,0,112,80,1},
		[48] = {112*3,0,112,80,1},
		[49] = {112*3,0,112,80,1},
		[50] = {112*3,0,112,80,1},
		[51] = {112*3,0,112,80,1},
		[52] = {112*3,0,112,80,1},
		[53] = {112*3,0,112,80,1},
		[54] = {112*3,0,112,80,1},
		[55] = {112*3,0,112,80,1},
		[56] = {112*3,0,112,80,1},
		[57] = {112*3,0,112,80,1},
		[58] = {112*3,0,112,80,1},
		[59] = {112*3,0,112,80,1},
		[60] = {112*3,0,112,80,1},
		[61] = {112*3,0,112,80,1},
		[62] = {112*3,0,112,80,1},
		[63] = {112*3,0,112,80,1},
		[64] = {112*3,0,112,80,1},
		[65] = {112*3,0,112,80,1},
		[66] = {112*3,0,112,80,1},
		[67] = {112*3,0,112,80,1},
		[68] = {112*3,0,112,80,1},
		[69] = {112*3,0,112,80,1},
		[70] = {112*3,0,112,80,1},
		[71] = {112*3,0,112,80,1},
		[72] = {112*3,0,112,80,1},
		[73] = {112*3,0,112,80,1},
		[74] = {112*3,0,112,80,1},
		[75] = {112*3,0,112,80,1},
		[76] = {112*3,0,112,80,1},
		[77] = {112*3,0,112,80,1},
		[78] = {112*3,0,112,80,1},
		[79] = {112*3,0,112,80,1},
		[80] = {112*3,0,112,80,1},
		[81] = {112*3,0,112,80,1},
		[82] = {112*3,0,112,80,1},
		[83] = {112*3,0,112,80,1},
		[84] = {112*3,0,112,80,1},
		[85] = {112*3,0,112,80,1},
		[86] = {112*3,0,112,80,1},
		[87] = {112*3,0,112,80,1},
		[88] = {112*3,0,112,80,1},
		[89] = {112*3,0,112,80,1},
		[90] = {112*3,0,112,80,1},
		[91] = {112*3,0,112,80,1},
		[92] = {112*3,0,112,80,1},
		[93] = {112*3,0,112,80,1},
		[94] = {112*3,0,112,80,1},
		[95] = {112*3,0,112,80,1},
		[96] = {112*3,0,112,80,1},
		[97] = {112*3,0,112,80,1},
		[98] = {112*3,0,112,80,1},
		[99] = {112*3,0,112,80,1},
		[100] = {112*3,0,112,80,1},
		[101] = {112*3,0,112,80,1},
		[102] = {112*3,0,112,80,1},
		[103] = {112*3,0,112,80,1},
		[104] = {112*3,0,112,80,1},
		[105] = {112*3,0,112,80,1},
		[106] = {112*3,0,112,80,1},
		[107] = {112*3,0,112,80,1},
		[108] = {112*3,0,112,80,1},
		[109] = {112*3,0,112,80,1},
		[110] = {112*3,0,112,80,1},
		[111] = {112*3,0,112,80,1},
		[112] = {112*3,0,112,80,1},
		[113] = {112*3,0,112,80,1},
		[114] = {112*3,0,112,80,1},
		[115] = {112*3,0,112,80,1},
		[116] = {112*3,0,112,80,1},
		[117] = {112*3,0,112,80,1},
		[118] = {112*3,0,112,80,1},
		[119] = {112*3,0,112,80,1},
		[120] = {112*3,0,112,80,1},
		[121] = {112*3,0,112,80,1},
		[122] = {112*3,0,112,80,1},
		[123] = {112*3,0,112,80,1},
		[124] = {112*3,0,112,80,1},
		[125] = {112*3,0,112,80,1},
		[126] = {112*3,0,112,80,1},
		[127] = {112*3,0,112,80,1},
		[128] = {112*3,0,112,80,1},
		[129] = {112*3,0,112,80,1},
		[130] = {112*3,0,112,80,1},
		[131] = {112*3,0,112,80,1},
		[132] = {112*3,0,112,80,1},
		[133] = {112*3,0,112,80,1},
		[134] = {112*3,0,112,80,1},
		[135] = {112*3,0,112,80,1},
		[136] = {112*3,0,112,80,1},
		[137] = {112*3,0,112,80,1},
		[138] = {112*3,0,112,80,1},
		[139] = {112*3,0,112,80,1},
		[140] = {112*3,0,112,80,1},
		[141] = {112*3,0,112,80,1},
		[142] = {112*3,0,112,80,1},
		[143] = {112*3,0,112,80,1},
		[144] = {112*3,0,112,80,1},
		[145] = {112*3,0,112,80,1},
		[146] = {112*3,0,112,80,1},
		[147] = {112*3,0,112,80,1},
		[148] = {112*3,0,112,80,1},
		[149] = {112*3,0,112,80,1},
		[150] = {112*3,0,112,80,1},
		[151] = {112*3,0,112,80,1},
		[152] = {112*3,0,112,80,1},
		[153] = {112*3,0,112,80,1},
		[154] = {112*3,0,112,80,1},
		[155] = {112*3,0,112,80,1},
		[156] = {112*3,0,112,80,1},
		[157] = {112*3,0,112,80,1},
		[158] = {112*3,0,112,80,1},
		[159] = {112*3,0,112,80,1},
		[160] = {112*3,0,112,80,1},
		[161] = {112*3,0,112,80,1},
		[162] = {112*3,0,112,80,1},
		[163] = {112*3,0,112,80,1},
		[164] = {112*3,0,112,80,1},
		[165] = {112*3,0,112,80,1},
		[166] = {112*3,0,112,80,1},
		[167] = {112*3,0,112,80,1},
		[168] = {112*3,0,112,80,1},
		[169] = {112*3,0,112,80,1},
		[170] = {112*3,0,112,80,1},
		[171] = {112*3,0,112,80,1},
		[172] = {112*3,0,112,80,1},
		[173] = {112*3,0,112,80,1},
		[174] = {112*3,0,112,80,1},
		[175] = {112*3,0,112,80,1},
		[176] = {112*3,0,112,80,1},
		[177] = {112*3,0,112,80,1},
		[178] = {112*3,0,112,80,1},
		[179] = {112*3,0,112,80,1},
		[180] = {112*3,0,112,80,1},
		[181] = {112*3,0,112,80,1},
		[182] = {112*3,0,112,80,1},
		[183] = {112*3,0,112,80,1},
		[184] = {112*3,0,112,80,1},
		[185] = {112*3,0,112,80,1},
		[186] = {112*3,0,112,80,1},
		[187] = {112*3,0,112,80,1},
		[188] = {112*3,0,112,80,1},
		[189] = {112*3,0,112,80,1},
		[190] = {112*3,0,112,80,1},
		[191] = {112*3,0,112,80,1},
		[192] = {112*3,0,112,80,1},
		[193] = {112*3,0,112,80,1},
		[194] = {112*3,0,112,80,1},
		[195] = {112*3,0,112,80,1},
		[196] = {112*3,0,112,80,1},
		[197] = {112*3,0,112,80,1},
		[198] = {112*3,0,112,80,1},
		[199] = {112*3,0,112,80,1},
		[200] = {112*3,0,112,80,1},
		
		[201] = {112*4,0,112,80,1},
		[202] = {112*4,0,112,80,1},
		[203] = {112*4,0,112,80,1},
		[204] = {112*4,0,112,80,1},
		[205] = {112*4,0,112,80,1},
		[206] = {112*4,0,112,80,1},
		[207] = {112*4,0,112,80,1},
		[208] = {112*4,0,112,80,1},
		[209] = {112*4,0,112,80,1},
		[210] = {112*4,0,112,80,1},
		[211] = {112*4,0,112,80,1},
		[212] = {112*4,0,112,80,1},
		[213] = {112*4,0,112,80,1},
		[214] = {112*4,0,112,80,1},
		[215] = {112*4,0,112,80,1},
		[216] = {112*4,0,112,80,1},
		[217] = {112*4,0,112,80,1},
		[218] = {112*4,0,112,80,1},
		[219] = {112*4,0,112,80,1},
		[220] = {112*4,0,112,80,1},
		
		[221] = {112*5,0,112,80,1},
		[222] = {112*5,0,112,80,1},
		[223] = {112*5,0,112,80,1},
		[224] = {112*5,0,112,80,1},
		[225] = {112*5,0,112,80,1},
		[226] = {112*5,0,112,80,1},
		[227] = {112*5,0,112,80,1},
		[228] = {112*5,0,112,80,1},
		[229] = {112*5,0,112,80,1},
		[230] = {112*5,0,112,80,1},
		[231] = {112*5,0,112,80,1},
		[232] = {112*5,0,112,80,1},
		[233] = {112*5,0,112,80,1},
		[234] = {112*5,0,112,80,1},
		[235] = {112*5,0,112,80,1},
		[236] = {112*5,0,112,80,1},
		[237] = {112*5,0,112,80,1},
		[238] = {112*5,0,112,80,1},
		[239] = {112*5,0,112,80,1},
		[240] = {112*5,0,112,80,1},
		
		[241] = {112*6,0,112,80,1},
	},
}

--blood_new2
_tab_model[9026] = {
	name = "MODEL_EFFECT:Blood_New2",
	image = "effect/blood_new.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,80*1,112,80,4},
		[2] = {112*3,80*1,112,80,1},
		[3] = {112*3,80*1,112,80,1},
		[4] = {112*3,80*1,112,80,1},
		[5] = {112*3,80*1,112,80,1},
		[6] = {112*3,80*1,112,80,1},
		[7] = {112*3,80*1,112,80,1},
		[8] = {112*3,80*1,112,80,1},
		[9] = {112*3,80*1,112,80,1},
		[10] = {112*3,80*1,112,80,1},
		[11] = {112*3,80*1,112,80,1},
		[12] = {112*3,80*1,112,80,1},
		[13] = {112*3,80*1,112,80,1},
		[14] = {112*3,80*1,112,80,1},
		[15] = {112*3,80*1,112,80,1},
		[16] = {112*3,80*1,112,80,1},
		[17] = {112*3,80*1,112,80,1},
		[18] = {112*3,80*1,112,80,1},
		[19] = {112*3,80*1,112,80,1},
		[20] = {112*3,80*1,112,80,1},
		[21] = {112*3,80*1,112,80,1},
		[22] = {112*3,80*1,112,80,1},
		[23] = {112*3,80*1,112,80,1},
		[24] = {112*3,80*1,112,80,1},
		[25] = {112*3,80*1,112,80,1},
		[26] = {112*3,80*1,112,80,1},
		[27] = {112*3,80*1,112,80,1},
		[28] = {112*3,80*1,112,80,1},
		[29] = {112*3,80*1,112,80,1},
		[30] = {112*3,80*1,112,80,1},
		[31] = {112*3,80*1,112,80,1},
		[32] = {112*3,80*1,112,80,1},
		[33] = {112*3,80*1,112,80,1},
		[34] = {112*3,80*1,112,80,1},
		[35] = {112*3,80*1,112,80,1},
		[36] = {112*3,80*1,112,80,1},
		[37] = {112*3,80*1,112,80,1},
		[38] = {112*3,80*1,112,80,1},
		[39] = {112*3,80*1,112,80,1},
		[40] = {112*3,80*1,112,80,1},
		[41] = {112*3,80*1,112,80,1},
		[42] = {112*3,80*1,112,80,1},
		[43] = {112*3,80*1,112,80,1},
		[44] = {112*3,80*1,112,80,1},
		[45] = {112*3,80*1,112,80,1},
		[46] = {112*3,80*1,112,80,1},
		[47] = {112*3,80*1,112,80,1},
		[48] = {112*3,80*1,112,80,1},
		[49] = {112*3,80*1,112,80,1},
		[50] = {112*3,80*1,112,80,1},
		[51] = {112*3,80*1,112,80,1},
		[52] = {112*3,80*1,112,80,1},
		[53] = {112*3,80*1,112,80,1},
		[54] = {112*3,80*1,112,80,1},
		[55] = {112*3,80*1,112,80,1},
		[56] = {112*3,80*1,112,80,1},
		[57] = {112*3,80*1,112,80,1},
		[58] = {112*3,80*1,112,80,1},
		[59] = {112*3,80*1,112,80,1},
		[60] = {112*3,80*1,112,80,1},
		[61] = {112*3,80*1,112,80,1},
		[62] = {112*3,80*1,112,80,1},
		[63] = {112*3,80*1,112,80,1},
		[64] = {112*3,80*1,112,80,1},
		[65] = {112*3,80*1,112,80,1},
		[66] = {112*3,80*1,112,80,1},
		[67] = {112*3,80*1,112,80,1},
		[68] = {112*3,80*1,112,80,1},
		[69] = {112*3,80*1,112,80,1},
		[70] = {112*3,80*1,112,80,1},
		[71] = {112*3,80*1,112,80,1},
		[72] = {112*3,80*1,112,80,1},
		[73] = {112*3,80*1,112,80,1},
		[74] = {112*3,80*1,112,80,1},
		[75] = {112*3,80*1,112,80,1},
		[76] = {112*3,80*1,112,80,1},
		[77] = {112*3,80*1,112,80,1},
		[78] = {112*3,80*1,112,80,1},
		[79] = {112*3,80*1,112,80,1},
		[80] = {112*3,80*1,112,80,1},
		[81] = {112*3,80*1,112,80,1},
		[82] = {112*3,80*1,112,80,1},
		[83] = {112*3,80*1,112,80,1},
		[84] = {112*3,80*1,112,80,1},
		[85] = {112*3,80*1,112,80,1},
		[86] = {112*3,80*1,112,80,1},
		[87] = {112*3,80*1,112,80,1},
		[88] = {112*3,80*1,112,80,1},
		[89] = {112*3,80*1,112,80,1},
		[90] = {112*3,80*1,112,80,1},
		[91] = {112*3,80*1,112,80,1},
		[92] = {112*3,80*1,112,80,1},
		[93] = {112*3,80*1,112,80,1},
		[94] = {112*3,80*1,112,80,1},
		[95] = {112*3,80*1,112,80,1},
		[96] = {112*3,80*1,112,80,1},
		[97] = {112*3,80*1,112,80,1},
		[98] = {112*3,80*1,112,80,1},
		[99] = {112*3,80*1,112,80,1},
		[100] = {112*3,80*1,112,80,1},
		[101] = {112*3,80*1,112,80,1},
		[102] = {112*3,80*1,112,80,1},
		[103] = {112*3,80*1,112,80,1},
		[104] = {112*3,80*1,112,80,1},
		[105] = {112*3,80*1,112,80,1},
		[106] = {112*3,80*1,112,80,1},
		[107] = {112*3,80*1,112,80,1},
		[108] = {112*3,80*1,112,80,1},
		[109] = {112*3,80*1,112,80,1},
		[110] = {112*3,80*1,112,80,1},
		[111] = {112*3,80*1,112,80,1},
		[112] = {112*3,80*1,112,80,1},
		[113] = {112*3,80*1,112,80,1},
		[114] = {112*3,80*1,112,80,1},
		[115] = {112*3,80*1,112,80,1},
		[116] = {112*3,80*1,112,80,1},
		[117] = {112*3,80*1,112,80,1},
		[118] = {112*3,80*1,112,80,1},
		[119] = {112*3,80*1,112,80,1},
		[120] = {112*3,80*1,112,80,1},
		[121] = {112*3,80*1,112,80,1},
		[122] = {112*3,80*1,112,80,1},
		[123] = {112*3,80*1,112,80,1},
		[124] = {112*3,80*1,112,80,1},
		[125] = {112*3,80*1,112,80,1},
		[126] = {112*3,80*1,112,80,1},
		[127] = {112*3,80*1,112,80,1},
		[128] = {112*3,80*1,112,80,1},
		[129] = {112*3,80*1,112,80,1},
		[130] = {112*3,80*1,112,80,1},
		[131] = {112*3,80*1,112,80,1},
		[132] = {112*3,80*1,112,80,1},
		[133] = {112*3,80*1,112,80,1},
		[134] = {112*3,80*1,112,80,1},
		[135] = {112*3,80*1,112,80,1},
		[136] = {112*3,80*1,112,80,1},
		[137] = {112*3,80*1,112,80,1},
		[138] = {112*3,80*1,112,80,1},
		[139] = {112*3,80*1,112,80,1},
		[140] = {112*3,80*1,112,80,1},
		[141] = {112*3,80*1,112,80,1},
		[142] = {112*3,80*1,112,80,1},
		[143] = {112*3,80*1,112,80,1},
		[144] = {112*3,80*1,112,80,1},
		[145] = {112*3,80*1,112,80,1},
		[146] = {112*3,80*1,112,80,1},
		[147] = {112*3,80*1,112,80,1},
		[148] = {112*3,80*1,112,80,1},
		[149] = {112*3,80*1,112,80,1},
		[150] = {112*3,80*1,112,80,1},
		[151] = {112*3,80*1,112,80,1},
		[152] = {112*3,80*1,112,80,1},
		[153] = {112*3,80*1,112,80,1},
		[154] = {112*3,80*1,112,80,1},
		[155] = {112*3,80*1,112,80,1},
		[156] = {112*3,80*1,112,80,1},
		[157] = {112*3,80*1,112,80,1},
		[158] = {112*3,80*1,112,80,1},
		[159] = {112*3,80*1,112,80,1},
		[160] = {112*3,80*1,112,80,1},
		[161] = {112*3,80*1,112,80,1},
		[162] = {112*3,80*1,112,80,1},
		[163] = {112*3,80*1,112,80,1},
		[164] = {112*3,80*1,112,80,1},
		[165] = {112*3,80*1,112,80,1},
		[166] = {112*3,80*1,112,80,1},
		[167] = {112*3,80*1,112,80,1},
		[168] = {112*3,80*1,112,80,1},
		[169] = {112*3,80*1,112,80,1},
		[170] = {112*3,80*1,112,80,1},
		[171] = {112*3,80*1,112,80,1},
		[172] = {112*3,80*1,112,80,1},
		[173] = {112*3,80*1,112,80,1},
		[174] = {112*3,80*1,112,80,1},
		[175] = {112*3,80*1,112,80,1},
		[176] = {112*3,80*1,112,80,1},
		[177] = {112*3,80*1,112,80,1},
		[178] = {112*3,80*1,112,80,1},
		[179] = {112*3,80*1,112,80,1},
		[180] = {112*3,80*1,112,80,1},
		[181] = {112*3,80*1,112,80,1},
		[182] = {112*3,80*1,112,80,1},
		[183] = {112*3,80*1,112,80,1},
		[184] = {112*3,80*1,112,80,1},
		[185] = {112*3,80*1,112,80,1},
		[186] = {112*3,80*1,112,80,1},
		[187] = {112*3,80*1,112,80,1},
		[188] = {112*3,80*1,112,80,1},
		[189] = {112*3,80*1,112,80,1},
		[190] = {112*3,80*1,112,80,1},
		[191] = {112*3,80*1,112,80,1},
		[192] = {112*3,80*1,112,80,1},
		[193] = {112*3,80*1,112,80,1},
		[194] = {112*3,80*1,112,80,1},
		[195] = {112*3,80*1,112,80,1},
		[196] = {112*3,80*1,112,80,1},
		[197] = {112*3,80*1,112,80,1},
		[198] = {112*3,80*1,112,80,1},
		[199] = {112*3,80*1,112,80,1},
		[200] = {112*3,80*1,112,80,1},
		
		[201] = {112*4,80*1,112,80,1},
		[202] = {112*4,80*1,112,80,1},
		[203] = {112*4,80*1,112,80,1},
		[204] = {112*4,80*1,112,80,1},
		[205] = {112*4,80*1,112,80,1},
		[206] = {112*4,80*1,112,80,1},
		[207] = {112*4,80*1,112,80,1},
		[208] = {112*4,80*1,112,80,1},
		[209] = {112*4,80*1,112,80,1},
		[210] = {112*4,80*1,112,80,1},
		[211] = {112*4,80*1,112,80,1},
		[212] = {112*4,80*1,112,80,1},
		[213] = {112*4,80*1,112,80,1},
		[214] = {112*4,80*1,112,80,1},
		[215] = {112*4,80*1,112,80,1},
		[216] = {112*4,80*1,112,80,1},
		[217] = {112*4,80*1,112,80,1},
		[218] = {112*4,80*1,112,80,1},
		[219] = {112*4,80*1,112,80,1},
		[220] = {112*4,80*1,112,80,1},
		
		[221] = {112*5,80*1,112,80,1},
		[222] = {112*5,80*1,112,80,1},
		[223] = {112*5,80*1,112,80,1},
		[224] = {112*5,80*1,112,80,1},
		[225] = {112*5,80*1,112,80,1},
		[226] = {112*5,80*1,112,80,1},
		[227] = {112*5,80*1,112,80,1},
		[228] = {112*5,80*1,112,80,1},
		[229] = {112*5,80*1,112,80,1},
		[230] = {112*5,80*1,112,80,1},
		[231] = {112*5,80*1,112,80,1},
		[232] = {112*5,80*1,112,80,1},
		[233] = {112*5,80*1,112,80,1},
		[234] = {112*5,80*1,112,80,1},
		[235] = {112*5,80*1,112,80,1},
		[236] = {112*5,80*1,112,80,1},
		[237] = {112*5,80*1,112,80,1},
		[238] = {112*5,80*1,112,80,1},
		[239] = {112*5,80*1,112,80,1},
		[240] = {112*5,80*1,112,80,1},
		
		[241] = {112*6,80*1,112,80,1},
	},
}

--blood_new3
_tab_model[9027] = {
	name = "MODEL_EFFECT:Blood_New3",
	image = "effect/blood_new.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,80*2,112,80,4},
		[2] = {112*3,80*2,112,80,1},
		[3] = {112*3,80*2,112,80,1},
		[4] = {112*3,80*2,112,80,1},
		[5] = {112*3,80*2,112,80,1},
		[6] = {112*3,80*2,112,80,1},
		[7] = {112*3,80*2,112,80,1},
		[8] = {112*3,80*2,112,80,1},
		[9] = {112*3,80*2,112,80,1},
		[10] = {112*3,80*2,112,80,1},
		[11] = {112*3,80*2,112,80,1},
		[12] = {112*3,80*2,112,80,1},
		[13] = {112*3,80*2,112,80,1},
		[14] = {112*3,80*2,112,80,1},
		[15] = {112*3,80*2,112,80,1},
		[16] = {112*3,80*2,112,80,1},
		[17] = {112*3,80*2,112,80,1},
		[18] = {112*3,80*2,112,80,1},
		[19] = {112*3,80*2,112,80,1},
		[20] = {112*3,80*2,112,80,1},
		[21] = {112*3,80*2,112,80,1},
		[22] = {112*3,80*2,112,80,1},
		[23] = {112*3,80*2,112,80,1},
		[24] = {112*3,80*2,112,80,1},
		[25] = {112*3,80*2,112,80,1},
		[26] = {112*3,80*2,112,80,1},
		[27] = {112*3,80*2,112,80,1},
		[28] = {112*3,80*2,112,80,1},
		[29] = {112*3,80*2,112,80,1},
		[30] = {112*3,80*2,112,80,1},
		[31] = {112*3,80*2,112,80,1},
		[32] = {112*3,80*2,112,80,1},
		[33] = {112*3,80*2,112,80,1},
		[34] = {112*3,80*2,112,80,1},
		[35] = {112*3,80*2,112,80,1},
		[36] = {112*3,80*2,112,80,1},
		[37] = {112*3,80*2,112,80,1},
		[38] = {112*3,80*2,112,80,1},
		[39] = {112*3,80*2,112,80,1},
		[40] = {112*3,80*2,112,80,1},
		[41] = {112*3,80*2,112,80,1},
		[42] = {112*3,80*2,112,80,1},
		[43] = {112*3,80*2,112,80,1},
		[44] = {112*3,80*2,112,80,1},
		[45] = {112*3,80*2,112,80,1},
		[46] = {112*3,80*2,112,80,1},
		[47] = {112*3,80*2,112,80,1},
		[48] = {112*3,80*2,112,80,1},
		[49] = {112*3,80*2,112,80,1},
		[50] = {112*3,80*2,112,80,1},
		[51] = {112*3,80*2,112,80,1},
		[52] = {112*3,80*2,112,80,1},
		[53] = {112*3,80*2,112,80,1},
		[54] = {112*3,80*2,112,80,1},
		[55] = {112*3,80*2,112,80,1},
		[56] = {112*3,80*2,112,80,1},
		[57] = {112*3,80*2,112,80,1},
		[58] = {112*3,80*2,112,80,1},
		[59] = {112*3,80*2,112,80,1},
		[60] = {112*3,80*2,112,80,1},
		[61] = {112*3,80*2,112,80,1},
		[62] = {112*3,80*2,112,80,1},
		[63] = {112*3,80*2,112,80,1},
		[64] = {112*3,80*2,112,80,1},
		[65] = {112*3,80*2,112,80,1},
		[66] = {112*3,80*2,112,80,1},
		[67] = {112*3,80*2,112,80,1},
		[68] = {112*3,80*2,112,80,1},
		[69] = {112*3,80*2,112,80,1},
		[70] = {112*3,80*2,112,80,1},
		[71] = {112*3,80*2,112,80,1},
		[72] = {112*3,80*2,112,80,1},
		[73] = {112*3,80*2,112,80,1},
		[74] = {112*3,80*2,112,80,1},
		[75] = {112*3,80*2,112,80,1},
		[76] = {112*3,80*2,112,80,1},
		[77] = {112*3,80*2,112,80,1},
		[78] = {112*3,80*2,112,80,1},
		[79] = {112*3,80*2,112,80,1},
		[80] = {112*3,80*2,112,80,1},
		[81] = {112*3,80*2,112,80,1},
		[82] = {112*3,80*2,112,80,1},
		[83] = {112*3,80*2,112,80,1},
		[84] = {112*3,80*2,112,80,1},
		[85] = {112*3,80*2,112,80,1},
		[86] = {112*3,80*2,112,80,1},
		[87] = {112*3,80*2,112,80,1},
		[88] = {112*3,80*2,112,80,1},
		[89] = {112*3,80*2,112,80,1},
		[90] = {112*3,80*2,112,80,1},
		[91] = {112*3,80*2,112,80,1},
		[92] = {112*3,80*2,112,80,1},
		[93] = {112*3,80*2,112,80,1},
		[94] = {112*3,80*2,112,80,1},
		[95] = {112*3,80*2,112,80,1},
		[96] = {112*3,80*2,112,80,1},
		[97] = {112*3,80*2,112,80,1},
		[98] = {112*3,80*2,112,80,1},
		[99] = {112*3,80*2,112,80,1},
		[100] = {112*3,80*2,112,80,1},
		[101] = {112*3,80*2,112,80,1},
		[102] = {112*3,80*2,112,80,1},
		[103] = {112*3,80*2,112,80,1},
		[104] = {112*3,80*2,112,80,1},
		[105] = {112*3,80*2,112,80,1},
		[106] = {112*3,80*2,112,80,1},
		[107] = {112*3,80*2,112,80,1},
		[108] = {112*3,80*2,112,80,1},
		[109] = {112*3,80*2,112,80,1},
		[110] = {112*3,80*2,112,80,1},
		[111] = {112*3,80*2,112,80,1},
		[112] = {112*3,80*2,112,80,1},
		[113] = {112*3,80*2,112,80,1},
		[114] = {112*3,80*2,112,80,1},
		[115] = {112*3,80*2,112,80,1},
		[116] = {112*3,80*2,112,80,1},
		[117] = {112*3,80*2,112,80,1},
		[118] = {112*3,80*2,112,80,1},
		[119] = {112*3,80*2,112,80,1},
		[120] = {112*3,80*2,112,80,1},
		[121] = {112*3,80*2,112,80,1},
		[122] = {112*3,80*2,112,80,1},
		[123] = {112*3,80*2,112,80,1},
		[124] = {112*3,80*2,112,80,1},
		[125] = {112*3,80*2,112,80,1},
		[126] = {112*3,80*2,112,80,1},
		[127] = {112*3,80*2,112,80,1},
		[128] = {112*3,80*2,112,80,1},
		[129] = {112*3,80*2,112,80,1},
		[130] = {112*3,80*2,112,80,1},
		[131] = {112*3,80*2,112,80,1},
		[132] = {112*3,80*2,112,80,1},
		[133] = {112*3,80*2,112,80,1},
		[134] = {112*3,80*2,112,80,1},
		[135] = {112*3,80*2,112,80,1},
		[136] = {112*3,80*2,112,80,1},
		[137] = {112*3,80*2,112,80,1},
		[138] = {112*3,80*2,112,80,1},
		[139] = {112*3,80*2,112,80,1},
		[140] = {112*3,80*2,112,80,1},
		[141] = {112*3,80*2,112,80,1},
		[142] = {112*3,80*2,112,80,1},
		[143] = {112*3,80*2,112,80,1},
		[144] = {112*3,80*2,112,80,1},
		[145] = {112*3,80*2,112,80,1},
		[146] = {112*3,80*2,112,80,1},
		[147] = {112*3,80*2,112,80,1},
		[148] = {112*3,80*2,112,80,1},
		[149] = {112*3,80*2,112,80,1},
		[150] = {112*3,80*2,112,80,1},
		[151] = {112*3,80*2,112,80,1},
		[152] = {112*3,80*2,112,80,1},
		[153] = {112*3,80*2,112,80,1},
		[154] = {112*3,80*2,112,80,1},
		[155] = {112*3,80*2,112,80,1},
		[156] = {112*3,80*2,112,80,1},
		[157] = {112*3,80*2,112,80,1},
		[158] = {112*3,80*2,112,80,1},
		[159] = {112*3,80*2,112,80,1},
		[160] = {112*3,80*2,112,80,1},
		[161] = {112*3,80*2,112,80,1},
		[162] = {112*3,80*2,112,80,1},
		[163] = {112*3,80*2,112,80,1},
		[164] = {112*3,80*2,112,80,1},
		[165] = {112*3,80*2,112,80,1},
		[166] = {112*3,80*2,112,80,1},
		[167] = {112*3,80*2,112,80,1},
		[168] = {112*3,80*2,112,80,1},
		[169] = {112*3,80*2,112,80,1},
		[170] = {112*3,80*2,112,80,1},
		[171] = {112*3,80*2,112,80,1},
		[172] = {112*3,80*2,112,80,1},
		[173] = {112*3,80*2,112,80,1},
		[174] = {112*3,80*2,112,80,1},
		[175] = {112*3,80*2,112,80,1},
		[176] = {112*3,80*2,112,80,1},
		[177] = {112*3,80*2,112,80,1},
		[178] = {112*3,80*2,112,80,1},
		[179] = {112*3,80*2,112,80,1},
		[180] = {112*3,80*2,112,80,1},
		[181] = {112*3,80*2,112,80,1},
		[182] = {112*3,80*2,112,80,1},
		[183] = {112*3,80*2,112,80,1},
		[184] = {112*3,80*2,112,80,1},
		[185] = {112*3,80*2,112,80,1},
		[186] = {112*3,80*2,112,80,1},
		[187] = {112*3,80*2,112,80,1},
		[188] = {112*3,80*2,112,80,1},
		[189] = {112*3,80*2,112,80,1},
		[190] = {112*3,80*2,112,80,1},
		[191] = {112*3,80*2,112,80,1},
		[192] = {112*3,80*2,112,80,1},
		[193] = {112*3,80*2,112,80,1},
		[194] = {112*3,80*2,112,80,1},
		[195] = {112*3,80*2,112,80,1},
		[196] = {112*3,80*2,112,80,1},
		[197] = {112*3,80*2,112,80,1},
		[198] = {112*3,80*2,112,80,1},
		[199] = {112*3,80*2,112,80,1},
		[200] = {112*3,80*2,112,80,1},
		
		[201] = {112*4,80*2,112,80,1},
		[202] = {112*4,80*2,112,80,1},
		[203] = {112*4,80*2,112,80,1},
		[204] = {112*4,80*2,112,80,1},
		[205] = {112*4,80*2,112,80,1},
		[206] = {112*4,80*2,112,80,1},
		[207] = {112*4,80*2,112,80,1},
		[208] = {112*4,80*2,112,80,1},
		[209] = {112*4,80*2,112,80,1},
		[210] = {112*4,80*2,112,80,1},
		[211] = {112*4,80*2,112,80,1},
		[212] = {112*4,80*2,112,80,1},
		[213] = {112*4,80*2,112,80,1},
		[214] = {112*4,80*2,112,80,1},
		[215] = {112*4,80*2,112,80,1},
		[216] = {112*4,80*2,112,80,1},
		[217] = {112*4,80*2,112,80,1},
		[218] = {112*4,80*2,112,80,1},
		[219] = {112*4,80*2,112,80,1},
		[220] = {112*4,80*2,112,80,1},
		
		[221] = {112*5,80*2,112,80,1},
		[222] = {112*5,80*2,112,80,1},
		[223] = {112*5,80*2,112,80,1},
		[224] = {112*5,80*2,112,80,1},
		[225] = {112*5,80*2,112,80,1},
		[226] = {112*5,80*2,112,80,1},
		[227] = {112*5,80*2,112,80,1},
		[228] = {112*5,80*2,112,80,1},
		[229] = {112*5,80*2,112,80,1},
		[230] = {112*5,80*2,112,80,1},
		[231] = {112*5,80*2,112,80,1},
		[232] = {112*5,80*2,112,80,1},
		[233] = {112*5,80*2,112,80,1},
		[234] = {112*5,80*2,112,80,1},
		[235] = {112*5,80*2,112,80,1},
		[236] = {112*5,80*2,112,80,1},
		[237] = {112*5,80*2,112,80,1},
		[238] = {112*5,80*2,112,80,1},
		[239] = {112*5,80*2,112,80,1},
		[240] = {112*5,80*2,112,80,1},
		
		[241] = {112*6,80*2,112,80,1},
	},
}

_tab_model[9028] = {
	name = "MODEL_EFFECT:Blood_2",
	image = "effect/Blood_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,5},
	},
}

--Blood_3
_tab_model[9029] = {
	name = "MODEL_EFFECT:Blood_3",
	image = "effect/blood_new.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		[1] = {0,80*3,112,80,7},
	},
}

--箱子
_tab_model[9030] = {
	name = "MODEL_EFFECT:BOX",
	image = "effect/box.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		roll = -90,
		[1] = {0,0,48,96,1},
	},
}

--箱子爆裂
_tab_model[9031] = {
	name = "MODEL_EFFECT:BOX_BOOB",
	image = "effect/box.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,256 * 0,256,256,4},
		[2] = {0,256 * 1,256,256,4},
		[3] = {0,256 * 2,256,256,4},
		[4] = {0,256 * 3,256,256,4},
		[5] = {256 * 3,256 * 3,256,256,1},
		[6] = {256 * 3,256 * 3,256,256,1},
		[7] = {256 * 3,256 * 3,256,256,1},
		[8] = {256 * 3,256 * 3,256,256,1},
		[9] = {256 * 3,256 * 3,256,256,1},
		[10] = {256 * 3,256 * 3,256,256,1},
		[11] = {256 * 3,256 * 3,256,256,1},
		[12] = {256 * 3,256 * 3,256,256,1},
		[13] = {256 * 3,256 * 3,256,256,1},
		[14] = {256 * 3,256 * 3,256,256,1},
		[15] = {256 * 3,256 * 3,256,256,1},
		[16] = {256 * 3,256 * 3,256,256,1},
		[17] = {256 * 3,256 * 3,256,256,1},
		[18] = {256 * 3,256 * 3,256,256,1},
		[19] = {256 * 3,256 * 3,256,256,1},
		[20] = {256 * 3,256 * 3,256,256,1},
		[21] = {256 * 3,256 * 3,256,256,1},
		[22] = {256 * 3,256 * 3,256,256,1},
		[23] = {256 * 3,256 * 3,256,256,1},
		[24] = {256 * 3,256 * 3,256,256,1},
		[25] = {256 * 3,256 * 3,256,256,1},
		[26] = {256 * 3,256 * 3,256,256,1},
		[27] = {256 * 3,256 * 3,256,256,1},
		[28] = {256 * 3,256 * 3,256,256,1},
		[29] = {256 * 3,256 * 3,256,256,1},
		[30] = {256 * 3,256 * 3,256,256,1},
		[31] = {256 * 3,256 * 3,256,256,1},
		[32] = {256 * 3,256 * 3,256,256,1},
		[33] = {256 * 3,256 * 3,256,256,1},
		[34] = {256 * 3,256 * 3,256,256,1},
		[35] = {256 * 3,256 * 3,256,256,1},
		[36] = {256 * 3,256 * 3,256,256,1},
		[37] = {256 * 3,256 * 3,256,256,1},
		[38] = {256 * 3,256 * 3,256,256,1},
		[39] = {256 * 3,256 * 3,256,256,1},
	},
}

--手雷
_tab_model[9032] = {
	name = "MODEL_EFFECT:shoulei",
	image = "effect/td_paota4_bullet.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -45,
		interval = 1000,
		[1] = {0,0,32,32,1},
	},
	dead = {
		image = "effect/Blood_1.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,37,43,1},
	},
}

--激光拖尾效果
_tab_model[9033] = {
	name = "MODEL_EFFECT:laser",
	image = "effect/laser.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,200,32,1},
	},
}

_tab_model[9034] = {
	name = "MODEL_EFFECT:laserball_explosion",
	image = "effect/laserball_explosion.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 30,
		[1] = {0,0,30,32,5},
	},
}

_tab_model[9035] = {
	name = "MODEL_EFFECT:behit_jiguanpao_b",
	loadmode = "plist",
	plist = "effect/behit_jiguanpao_b.plist",
	image = "effect/behit_jiguanpao_b.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 90, --初始旋转
		interval = 50,
		pName = "behit_jiguanpao_b_0",
		pMode = 2,
		[1] = {0,0,0,0,7}, --数量
	},
}



--blood_new5
_tab_model[9036] = {
	name = "MODEL_EFFECT:Blood_New5",
	image = "effect/blood_new5.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,155*0,160,155,4},
		[2] = {160*3,155*0,160,155,1},
		[3] = {160*3,155*0,160,155,1},
		[4] = {160*3,155*0,160,155,1},
		[5] = {160*3,155*0,160,155,1},
		[6] = {160*3,155*0,160,155,1},
		[7] = {160*3,155*0,160,155,1},
		[8] = {160*3,155*0,160,155,1},
		[9] = {160*3,155*0,160,155,1},
		[10] = {160*3,155*0,160,155,1},
		[11] = {160*3,155*0,160,155,1},
		[12] = {160*3,155*0,160,155,1},
		[13] = {160*3,155*0,160,155,1},
		[14] = {160*3,155*0,160,155,1},
		[15] = {160*3,155*0,160,155,1},
		[16] = {160*3,155*0,160,155,1},
		[17] = {160*3,155*0,160,155,1},
		[18] = {160*3,155*0,160,155,1},
		[19] = {160*3,155*0,160,155,1},
		[20] = {160*3,155*0,160,155,1},
		[21] = {160*3,155*0,160,155,1},
		[22] = {160*3,155*0,160,155,1},
		[23] = {160*3,155*0,160,155,1},
		[24] = {160*3,155*0,160,155,1},
		[25] = {160*3,155*0,160,155,1},
		[26] = {160*3,155*0,160,155,1},
		[27] = {160*3,155*0,160,155,1},
		[28] = {160*3,155*0,160,155,1},
		[29] = {160*3,155*0,160,155,1},
		[30] = {160*3,155*0,160,155,1},
		[31] = {160*3,155*0,160,155,1},
		[32] = {160*3,155*0,160,155,1},
		[33] = {160*3,155*0,160,155,1},
		[34] = {160*3,155*0,160,155,1},
		[35] = {160*3,155*0,160,155,1},
		[36] = {160*3,155*0,160,155,1},
		[37] = {160*3,155*0,160,155,1},
		[38] = {160*3,155*0,160,155,1},
		[39] = {160*3,155*0,160,155,1},
		[40] = {160*3,155*0,160,155,1},
		[41] = {160*3,155*0,160,155,1},
		[42] = {160*3,155*0,160,155,1},
		[43] = {160*3,155*0,160,155,1},
		[44] = {160*3,155*0,160,155,1},
		[45] = {160*3,155*0,160,155,1},
		[46] = {160*3,155*0,160,155,1},
		[47] = {160*3,155*0,160,155,1},
		[48] = {160*3,155*0,160,155,1},
		[49] = {160*3,155*0,160,155,1},
		[50] = {160*3,155*0,160,155,1},
		[51] = {160*3,155*0,160,155,1},
		[52] = {160*3,155*0,160,155,1},
		[53] = {160*3,155*0,160,155,1},
		[54] = {160*3,155*0,160,155,1},
		[55] = {160*3,155*0,160,155,1},
		[56] = {160*3,155*0,160,155,1},
		[57] = {160*3,155*0,160,155,1},
		[58] = {160*3,155*0,160,155,1},
		[59] = {160*3,155*0,160,155,1},
		[60] = {160*3,155*0,160,155,1},
		[61] = {160*3,155*0,160,155,1},
		[62] = {160*3,155*0,160,155,1},
		[63] = {160*3,155*0,160,155,1},
		[64] = {160*3,155*0,160,155,1},
		[65] = {160*3,155*0,160,155,1},
		[66] = {160*3,155*0,160,155,1},
		[67] = {160*3,155*0,160,155,1},
		[68] = {160*3,155*0,160,155,1},
		[69] = {160*3,155*0,160,155,1},
		[70] = {160*3,155*0,160,155,1},
		[71] = {160*3,155*0,160,155,1},
		[72] = {160*3,155*0,160,155,1},
		[73] = {160*3,155*0,160,155,1},
		[74] = {160*3,155*0,160,155,1},
		[75] = {160*3,155*0,160,155,1},
		[76] = {160*3,155*0,160,155,1},
		[77] = {160*3,155*0,160,155,1},
		[78] = {160*3,155*0,160,155,1},
		[79] = {160*3,155*0,160,155,1},
		[80] = {160*3,155*0,160,155,1},
		[81] = {160*3,155*0,160,155,1},
		[82] = {160*3,155*0,160,155,1},
		[83] = {160*3,155*0,160,155,1},
		[84] = {160*3,155*0,160,155,1},
		[85] = {160*3,155*0,160,155,1},
		[86] = {160*3,155*0,160,155,1},
		[87] = {160*3,155*0,160,155,1},
		[88] = {160*3,155*0,160,155,1},
		[89] = {160*3,155*0,160,155,1},
		[90] = {160*3,155*0,160,155,1},
		[91] = {160*3,155*0,160,155,1},
		[92] = {160*3,155*0,160,155,1},
		[93] = {160*3,155*0,160,155,1},
		[94] = {160*3,155*0,160,155,1},
		[95] = {160*3,155*0,160,155,1},
		[96] = {160*3,155*0,160,155,1},
		[97] = {160*3,155*0,160,155,1},
		[98] = {160*3,155*0,160,155,1},
		[99] = {160*3,155*0,160,155,1},
		[100] = {160*3,155*0,160,155,1},
		[101] = {160*3,155*0,160,155,1},
		[102] = {160*3,155*0,160,155,1},
		[103] = {160*3,155*0,160,155,1},
		[104] = {160*3,155*0,160,155,1},
		[105] = {160*3,155*0,160,155,1},
		[106] = {160*3,155*0,160,155,1},
		[107] = {160*3,155*0,160,155,1},
		[108] = {160*3,155*0,160,155,1},
		[109] = {160*3,155*0,160,155,1},
		[110] = {160*3,155*0,160,155,1},
		[111] = {160*3,155*0,160,155,1},
		[112] = {160*3,155*0,160,155,1},
		[113] = {160*3,155*0,160,155,1},
		[114] = {160*3,155*0,160,155,1},
		[115] = {160*3,155*0,160,155,1},
		[116] = {160*3,155*0,160,155,1},
		[117] = {160*3,155*0,160,155,1},
		[118] = {160*3,155*0,160,155,1},
		[119] = {160*3,155*0,160,155,1},
		[120] = {160*3,155*0,160,155,1},
		[121] = {160*3,155*0,160,155,1},
		[122] = {160*3,155*0,160,155,1},
		[123] = {160*3,155*0,160,155,1},
		[124] = {160*3,155*0,160,155,1},
		[125] = {160*3,155*0,160,155,1},
		[126] = {160*3,155*0,160,155,1},
		[127] = {160*3,155*0,160,155,1},
		[128] = {160*3,155*0,160,155,1},
		[129] = {160*3,155*0,160,155,1},
		[130] = {160*3,155*0,160,155,1},
		[131] = {160*3,155*0,160,155,1},
		[132] = {160*3,155*0,160,155,1},
		[133] = {160*3,155*0,160,155,1},
		[134] = {160*3,155*0,160,155,1},
		[135] = {160*3,155*0,160,155,1},
		[136] = {160*3,155*0,160,155,1},
		[137] = {160*3,155*0,160,155,1},
		[138] = {160*3,155*0,160,155,1},
		[139] = {160*3,155*0,160,155,1},
		[140] = {160*3,155*0,160,155,1},
		[141] = {160*3,155*0,160,155,1},
		[142] = {160*3,155*0,160,155,1},
		[143] = {160*3,155*0,160,155,1},
		[144] = {160*3,155*0,160,155,1},
		[145] = {160*3,155*0,160,155,1},
		[146] = {160*3,155*0,160,155,1},
		[147] = {160*3,155*0,160,155,1},
		[148] = {160*3,155*0,160,155,1},
		[149] = {160*3,155*0,160,155,1},
		[150] = {160*3,155*0,160,155,1},
		[151] = {160*3,155*0,160,155,1},
		[152] = {160*3,155*0,160,155,1},
		[153] = {160*3,155*0,160,155,1},
		[154] = {160*3,155*0,160,155,1},
		[155] = {160*3,155*0,160,155,1},
		[156] = {160*3,155*0,160,155,1},
		[157] = {160*3,155*0,160,155,1},
		[158] = {160*3,155*0,160,155,1},
		[159] = {160*3,155*0,160,155,1},
		[160] = {160*3,155*0,160,155,1},
		[161] = {160*3,155*0,160,155,1},
		[162] = {160*3,155*0,160,155,1},
		[163] = {160*3,155*0,160,155,1},
		[164] = {160*3,155*0,160,155,1},
		[165] = {160*3,155*0,160,155,1},
		[166] = {160*3,155*0,160,155,1},
		[167] = {160*3,155*0,160,155,1},
		[168] = {160*3,155*0,160,155,1},
		[169] = {160*3,155*0,160,155,1},
		[170] = {160*3,155*0,160,155,1},
		[171] = {160*3,155*0,160,155,1},
		[172] = {160*3,155*0,160,155,1},
		[173] = {160*3,155*0,160,155,1},
		[174] = {160*3,155*0,160,155,1},
		[175] = {160*3,155*0,160,155,1},
		[176] = {160*3,155*0,160,155,1},
		[177] = {160*3,155*0,160,155,1},
		[178] = {160*3,155*0,160,155,1},
		[179] = {160*3,155*0,160,155,1},
		[180] = {160*3,155*0,160,155,1},
		[181] = {160*3,155*0,160,155,1},
		[182] = {160*3,155*0,160,155,1},
		[183] = {160*3,155*0,160,155,1},
		[184] = {160*3,155*0,160,155,1},
		[185] = {160*3,155*0,160,155,1},
		[186] = {160*3,155*0,160,155,1},
		[187] = {160*3,155*0,160,155,1},
		[188] = {160*3,155*0,160,155,1},
		[189] = {160*3,155*0,160,155,1},
		[190] = {160*3,155*0,160,155,1},
		[191] = {160*3,155*0,160,155,1},
		[192] = {160*3,155*0,160,155,1},
		[193] = {160*3,155*0,160,155,1},
		[194] = {160*3,155*0,160,155,1},
		[195] = {160*3,155*0,160,155,1},
		[196] = {160*3,155*0,160,155,1},
		[197] = {160*3,155*0,160,155,1},
		[198] = {160*3,155*0,160,155,1},
		[199] = {160*3,155*0,160,155,1},
		[200] = {160*3,155*0,160,155,1},
		
		[201] = {160*4,155*0,160,155,1},
		[202] = {160*4,155*0,160,155,1},
		[203] = {160*4,155*0,160,155,1},
		[204] = {160*4,155*0,160,155,1},
		[205] = {160*4,155*0,160,155,1},
		[206] = {160*4,155*0,160,155,1},
		[207] = {160*4,155*0,160,155,1},
		[208] = {160*4,155*0,160,155,1},
		[209] = {160*4,155*0,160,155,1},
		[210] = {160*4,155*0,160,155,1},
		[211] = {160*4,155*0,160,155,1},
		[212] = {160*4,155*0,160,155,1},
		[213] = {160*4,155*0,160,155,1},
		[214] = {160*4,155*0,160,155,1},
		[215] = {160*4,155*0,160,155,1},
		[216] = {160*4,155*0,160,155,1},
		[217] = {160*4,155*0,160,155,1},
		[218] = {160*4,155*0,160,155,1},
		[219] = {160*4,155*0,160,155,1},
		[220] = {160*4,155*0,160,155,1},
		
		[221] = {160*5,155*0,160,155,1},
		[222] = {160*5,155*0,160,155,1},
		[223] = {160*5,155*0,160,155,1},
		[224] = {160*5,155*0,160,155,1},
		[225] = {160*5,155*0,160,155,1},
		[226] = {160*5,155*0,160,155,1},
		[227] = {160*5,155*0,160,155,1},
		[228] = {160*5,155*0,160,155,1},
		[229] = {160*5,155*0,160,155,1},
		[230] = {160*5,155*0,160,155,1},
		[231] = {160*5,155*0,160,155,1},
		[232] = {160*5,155*0,160,155,1},
		[233] = {160*5,155*0,160,155,1},
		[234] = {160*5,155*0,160,155,1},
		[235] = {160*5,155*0,160,155,1},
		[236] = {160*5,155*0,160,155,1},
		[237] = {160*5,155*0,160,155,1},
		[238] = {160*5,155*0,160,155,1},
		[239] = {160*5,155*0,160,155,1},
		[240] = {160*5,155*0,160,155,1},
		
		[241] = {160*6,155*0,160,155,1},
	},
}

_tab_model[9037] = {
	name = "MODEL_EFFECT:behit_tegong_c",
	loadmode = "plist",
	plist = "effect/behit_tegong_c.plist",
	image = "effect/behit_tegong_c.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 60, --初始旋转
		interval = 50,
		pName = "behit_tegong_c_0",
		pMode = 2,
		[1] = {0,0,0,0,12}, --数量
	},
}

--塔出生
_tab_model[9038] = {
	name = "MODEL_EFFECT:dusty",
	loadmode = "plist",
	plist = "effect/dusty.plist",
	image = "effect/dusty.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		pName = "dusty0",
		pMode = 2,
		[1] = {0,0,0,0,9}, --数量
	},
}
--导弹爆炸
_tab_model[9039] = {
	name = "MODEL_EFFECT:testbump_a",
	loadmode = "plist",
	plist = "effect/testbump_a.plist",
	image = "effect/testbump_a.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		pName = "testbump_a_0",
		pMode = 2,
		[1] = {0,0,0,0,6}, --数量
	},
}
--车爆炸
_tab_model[9040] = {
	name = "MODEL_EFFECT:pjdbz",
	loadmode = "plist",
	plist = "effect/pojiadanbaozha.plist",
	image = "effect/pojiadanbaozha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.4,0.5},
		roll = 90, --初始旋转
		interval = 150,
		pName = "pjdbz_00",
		pMode = 2,
		[1] = {0,0,0,0,5}, --数量
	},
}

_tab_model[9041] = {
	name = "MODEL_EFFECT:dj_2",
	image = "effect/dj_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = -90,
		--flipX = 1,
		interval = 100,
		[1] = {0,0,240,150,4},
		[2] = {0,150,240,150,4},
		--[3] = {0,150*2,240,150,4},
	},
}

_tab_model[9042] = {
	name = "MODEL_EFFECT:dj_1",
	image = "effect/dj_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,240,130,3},
		[2] = {0,130,240,130,3},
		[3] = {0,260,240,130,3},
	},
}

--blood_new6
_tab_model[9043] = {
	name = "MODEL_EFFECT:Blood_New6",
	image = "effect/blood_new6.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {124*0,66*0,124,66,1},
		[2] = {124*0,66*0,124,66,1},
		[3] = {124*0,66*0,124,66,1},
		[4] = {124*0,66*0,124,66,1},
		[5] = {124*0,66*0,124,66,1},
		[6] = {124*0,66*0,124,66,1},
		[7] = {124*0,66*0,124,66,1},
		[8] = {124*0,66*0,124,66,1},
		[9] = {124*0,66*0,124,66,1},
		[10] = {124*0,66*0,124,66,1},
		[11] = {124*0,66*0,124,66,1},
		[12] = {124*0,66*0,124,66,1},
		[13] = {124*0,66*0,124,66,1},
		[14] = {124*0,66*0,124,66,1},
		[15] = {124*0,66*0,124,66,1},
		[16] = {124*0,66*0,124,66,1},
		[17] = {124*0,66*0,124,66,1},
		[18] = {124*0,66*0,124,66,1},
		[19] = {124*0,66*0,124,66,1},
		[20] = {124*0,66*0,124,66,1},
		[21] = {124*0,66*0,124,66,1},
		[22] = {124*0,66*0,124,66,1},
		[23] = {124*0,66*0,124,66,1},
		[24] = {124*0,66*0,124,66,1},
		[25] = {124*0,66*0,124,66,1},
		[26] = {124*0,66*0,124,66,1},
		[27] = {124*0,66*0,124,66,1},
		[28] = {124*0,66*0,124,66,1},
		[29] = {124*0,66*0,124,66,1},
		[30] = {124*0,66*0,124,66,1},
		[31] = {124*0,66*0,124,66,1},
		[32] = {124*0,66*0,124,66,1},
		[33] = {124*0,66*0,124,66,1},
		[34] = {124*0,66*0,124,66,1},
		[35] = {124*0,66*0,124,66,1},
		[36] = {124*0,66*0,124,66,1},
		[37] = {124*0,66*0,124,66,1},
		[38] = {124*0,66*0,124,66,1},
		[39] = {124*0,66*0,124,66,1},
		[40] = {124*0,66*0,124,66,1},
		[41] = {124*0,66*0,124,66,1},
		[42] = {124*0,66*0,124,66,1},
		[43] = {124*0,66*0,124,66,1},
		[44] = {124*0,66*0,124,66,1},
		[45] = {124*0,66*0,124,66,1},
		[46] = {124*0,66*0,124,66,1},
		[47] = {124*0,66*0,124,66,1},
		[48] = {124*0,66*0,124,66,1},
		[49] = {124*0,66*0,124,66,1},
		[50] = {124*0,66*0,124,66,1},
		[51] = {124*0,66*0,124,66,1},
		[52] = {124*0,66*0,124,66,1},
		[53] = {124*0,66*0,124,66,1},
		[54] = {124*0,66*0,124,66,1},
		[55] = {124*0,66*0,124,66,1},
		[56] = {124*0,66*0,124,66,1},
		[57] = {124*0,66*0,124,66,1},
		[58] = {124*0,66*0,124,66,1},
		[59] = {124*0,66*0,124,66,1},
		[60] = {124*0,66*0,124,66,1},
		
		[61] = {124*1,66*0,124,66,1},
		[62] = {124*1,66*0,124,66,1},
		[63] = {124*1,66*0,124,66,1},
		[64] = {124*1,66*0,124,66,1},
		[65] = {124*1,66*0,124,66,1},
		[66] = {124*1,66*0,124,66,1},
		[67] = {124*1,66*0,124,66,1},
		[68] = {124*1,66*0,124,66,1},
		[69] = {124*1,66*0,124,66,1},
		[70] = {124*1,66*0,124,66,1},
		[71] = {124*1,66*0,124,66,1},
		[72] = {124*1,66*0,124,66,1},
		[73] = {124*1,66*0,124,66,1},
		[74] = {124*1,66*0,124,66,1},
		[75] = {124*1,66*0,124,66,1},
		[76] = {124*1,66*0,124,66,1},
		[77] = {124*1,66*0,124,66,1},
		[78] = {124*1,66*0,124,66,1},
		[79] = {124*1,66*0,124,66,1},
		[80] = {124*1,66*0,124,66,1},
		[81] = {124*1,66*0,124,66,1},
		[82] = {124*1,66*0,124,66,1},
		[83] = {124*1,66*0,124,66,1},
		[84] = {124*1,66*0,124,66,1},
		[85] = {124*1,66*0,124,66,1},
		[86] = {124*1,66*0,124,66,1},
		[87] = {124*1,66*0,124,66,1},
		[88] = {124*1,66*0,124,66,1},
		[89] = {124*1,66*0,124,66,1},
		[90] = {124*1,66*0,124,66,1},
		[91] = {124*1,66*0,124,66,1},
		[92] = {124*1,66*0,124,66,1},
		[93] = {124*1,66*0,124,66,1},
		[94] = {124*1,66*0,124,66,1},
		[95] = {124*1,66*0,124,66,1},
		[96] = {124*1,66*0,124,66,1},
		[97] = {124*1,66*0,124,66,1},
		[98] = {124*1,66*0,124,66,1},
		[99] = {124*1,66*0,124,66,1},
		[100] = {124*1,66*0,124,66,1},
		[101] = {124*1,66*0,124,66,1},
		[102] = {124*1,66*0,124,66,1},
		[103] = {124*1,66*0,124,66,1},
		[104] = {124*1,66*0,124,66,1},
		[105] = {124*1,66*0,124,66,1},
		[106] = {124*1,66*0,124,66,1},
		[107] = {124*1,66*0,124,66,1},
		[108] = {124*1,66*0,124,66,1},
		[109] = {124*1,66*0,124,66,1},
		[110] = {124*1,66*0,124,66,1},
		[111] = {124*1,66*0,124,66,1},
		[112] = {124*1,66*0,124,66,1},
		[113] = {124*1,66*0,124,66,1},
		[114] = {124*1,66*0,124,66,1},
		[115] = {124*1,66*0,124,66,1},
		[116] = {124*1,66*0,124,66,1},
		[117] = {124*1,66*0,124,66,1},
		[118] = {124*1,66*0,124,66,1},
		[119] = {124*1,66*0,124,66,1},
		[120] = {124*1,66*0,124,66,1},
		
		[121] = {124*2,66*0,124,66,1},
		[122] = {124*2,66*0,124,66,1},
		[123] = {124*2,66*0,124,66,1},
		[124] = {124*2,66*0,124,66,1},
		[125] = {124*2,66*0,124,66,1},
		[126] = {124*2,66*0,124,66,1},
		[127] = {124*2,66*0,124,66,1},
		[128] = {124*2,66*0,124,66,1},
		[129] = {124*2,66*0,124,66,1},
		[130] = {124*2,66*0,124,66,1},
		[131] = {124*2,66*0,124,66,1},
		[132] = {124*2,66*0,124,66,1},
		[133] = {124*2,66*0,124,66,1},
		[134] = {124*2,66*0,124,66,1},
		[135] = {124*2,66*0,124,66,1},
		[136] = {124*2,66*0,124,66,1},
		[137] = {124*2,66*0,124,66,1},
		[138] = {124*2,66*0,124,66,1},
		[139] = {124*2,66*0,124,66,1},
		[140] = {124*2,66*0,124,66,1},
		[141] = {124*2,66*0,124,66,1},
		[142] = {124*2,66*0,124,66,1},
		[143] = {124*2,66*0,124,66,1},
		[144] = {124*2,66*0,124,66,1},
		[145] = {124*2,66*0,124,66,1},
		[146] = {124*2,66*0,124,66,1},
		[147] = {124*2,66*0,124,66,1},
		[148] = {124*2,66*0,124,66,1},
		[149] = {124*2,66*0,124,66,1},
		[150] = {124*2,66*0,124,66,1},
		[151] = {124*2,66*0,124,66,1},
		[152] = {124*2,66*0,124,66,1},
		[153] = {124*2,66*0,124,66,1},
		[154] = {124*2,66*0,124,66,1},
		[155] = {124*2,66*0,124,66,1},
		[156] = {124*2,66*0,124,66,1},
		[157] = {124*2,66*0,124,66,1},
		[158] = {124*2,66*0,124,66,1},
		[159] = {124*2,66*0,124,66,1},
		[160] = {124*2,66*0,124,66,1},
		[161] = {124*2,66*0,124,66,1},
		[162] = {124*2,66*0,124,66,1},
		[163] = {124*2,66*0,124,66,1},
		[164] = {124*2,66*0,124,66,1},
		[165] = {124*2,66*0,124,66,1},
		[166] = {124*2,66*0,124,66,1},
		[167] = {124*2,66*0,124,66,1},
		[168] = {124*2,66*0,124,66,1},
		[169] = {124*2,66*0,124,66,1},
		[170] = {124*2,66*0,124,66,1},
		[171] = {124*2,66*0,124,66,1},
		[172] = {124*2,66*0,124,66,1},
		[173] = {124*2,66*0,124,66,1},
		[174] = {124*2,66*0,124,66,1},
		[175] = {124*2,66*0,124,66,1},
		[176] = {124*2,66*0,124,66,1},
		[177] = {124*2,66*0,124,66,1},
		[178] = {124*2,66*0,124,66,1},
		[179] = {124*2,66*0,124,66,1},
		[180] = {124*2,66*0,124,66,1},
	},
}


--blood_new7
_tab_model[9044] = {
	name = "MODEL_EFFECT:Blood_New7",
	image = "effect/blood_new7.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {132*0,80*0,132,80,1},
		[2] = {132*0,80*0,132,80,1},
		[3] = {132*0,80*0,132,80,1},
		[4] = {132*0,80*0,132,80,1},
		[5] = {132*0,80*0,132,80,1},
		[6] = {132*0,80*0,132,80,1},
		[7] = {132*0,80*0,132,80,1},
		[8] = {132*0,80*0,132,80,1},
		[9] = {132*0,80*0,132,80,1},
		[10] = {132*0,80*0,132,80,1},
		[11] = {132*0,80*0,132,80,1},
		[12] = {132*0,80*0,132,80,1},
		[13] = {132*0,80*0,132,80,1},
		[14] = {132*0,80*0,132,80,1},
		[15] = {132*0,80*0,132,80,1},
		[16] = {132*0,80*0,132,80,1},
		[17] = {132*0,80*0,132,80,1},
		[18] = {132*0,80*0,132,80,1},
		[19] = {132*0,80*0,132,80,1},
		[20] = {132*0,80*0,132,80,1},
		[21] = {132*0,80*0,132,80,1},
		[22] = {132*0,80*0,132,80,1},
		[23] = {132*0,80*0,132,80,1},
		[24] = {132*0,80*0,132,80,1},
		[25] = {132*0,80*0,132,80,1},
		[26] = {132*0,80*0,132,80,1},
		[27] = {132*0,80*0,132,80,1},
		[28] = {132*0,80*0,132,80,1},
		[29] = {132*0,80*0,132,80,1},
		[30] = {132*0,80*0,132,80,1},
		[31] = {132*0,80*0,132,80,1},
		[32] = {132*0,80*0,132,80,1},
		[33] = {132*0,80*0,132,80,1},
		[34] = {132*0,80*0,132,80,1},
		[35] = {132*0,80*0,132,80,1},
		[36] = {132*0,80*0,132,80,1},
		[37] = {132*0,80*0,132,80,1},
		[38] = {132*0,80*0,132,80,1},
		[39] = {132*0,80*0,132,80,1},
		[40] = {132*0,80*0,132,80,1},
		[41] = {132*0,80*0,132,80,1},
		[42] = {132*0,80*0,132,80,1},
		[43] = {132*0,80*0,132,80,1},
		[44] = {132*0,80*0,132,80,1},
		[45] = {132*0,80*0,132,80,1},
		[46] = {132*0,80*0,132,80,1},
		[47] = {132*0,80*0,132,80,1},
		[48] = {132*0,80*0,132,80,1},
		[49] = {132*0,80*0,132,80,1},
		[50] = {132*0,80*0,132,80,1},
		[51] = {132*0,80*0,132,80,1},
		[52] = {132*0,80*0,132,80,1},
		[53] = {132*0,80*0,132,80,1},
		[54] = {132*0,80*0,132,80,1},
		[55] = {132*0,80*0,132,80,1},
		[56] = {132*0,80*0,132,80,1},
		[57] = {132*0,80*0,132,80,1},
		[58] = {132*0,80*0,132,80,1},
		[59] = {132*0,80*0,132,80,1},
		[60] = {132*0,80*0,132,80,1},
		
		[61] = {132*1,80*0,132,80,1},
		[62] = {132*1,80*0,132,80,1},
		[63] = {132*1,80*0,132,80,1},
		[64] = {132*1,80*0,132,80,1},
		[65] = {132*1,80*0,132,80,1},
		[66] = {132*1,80*0,132,80,1},
		[67] = {132*1,80*0,132,80,1},
		[68] = {132*1,80*0,132,80,1},
		[69] = {132*1,80*0,132,80,1},
		[70] = {132*1,80*0,132,80,1},
		[71] = {132*1,80*0,132,80,1},
		[72] = {132*1,80*0,132,80,1},
		[73] = {132*1,80*0,132,80,1},
		[74] = {132*1,80*0,132,80,1},
		[75] = {132*1,80*0,132,80,1},
		[76] = {132*1,80*0,132,80,1},
		[77] = {132*1,80*0,132,80,1},
		[78] = {132*1,80*0,132,80,1},
		[79] = {132*1,80*0,132,80,1},
		[80] = {132*1,80*0,132,80,1},
		[81] = {132*1,80*0,132,80,1},
		[82] = {132*1,80*0,132,80,1},
		[83] = {132*1,80*0,132,80,1},
		[84] = {132*1,80*0,132,80,1},
		[85] = {132*1,80*0,132,80,1},
		[86] = {132*1,80*0,132,80,1},
		[87] = {132*1,80*0,132,80,1},
		[88] = {132*1,80*0,132,80,1},
		[89] = {132*1,80*0,132,80,1},
		[90] = {132*1,80*0,132,80,1},
		[91] = {132*1,80*0,132,80,1},
		[92] = {132*1,80*0,132,80,1},
		[93] = {132*1,80*0,132,80,1},
		[94] = {132*1,80*0,132,80,1},
		[95] = {132*1,80*0,132,80,1},
		[96] = {132*1,80*0,132,80,1},
		[97] = {132*1,80*0,132,80,1},
		[98] = {132*1,80*0,132,80,1},
		[99] = {132*1,80*0,132,80,1},
		[100] = {132*1,80*0,132,80,1},
		[101] = {132*1,80*0,132,80,1},
		[102] = {132*1,80*0,132,80,1},
		[103] = {132*1,80*0,132,80,1},
		[104] = {132*1,80*0,132,80,1},
		[105] = {132*1,80*0,132,80,1},
		[106] = {132*1,80*0,132,80,1},
		[107] = {132*1,80*0,132,80,1},
		[108] = {132*1,80*0,132,80,1},
		[109] = {132*1,80*0,132,80,1},
		[110] = {132*1,80*0,132,80,1},
		[111] = {132*1,80*0,132,80,1},
		[112] = {132*1,80*0,132,80,1},
		[113] = {132*1,80*0,132,80,1},
		[114] = {132*1,80*0,132,80,1},
		[115] = {132*1,80*0,132,80,1},
		[116] = {132*1,80*0,132,80,1},
		[117] = {132*1,80*0,132,80,1},
		[118] = {132*1,80*0,132,80,1},
		[119] = {132*1,80*0,132,80,1},
		[120] = {132*1,80*0,132,80,1},
		
		[121] = {132*2,80*0,132,80,1},
		[122] = {132*2,80*0,132,80,1},
		[123] = {132*2,80*0,132,80,1},
		[124] = {132*2,80*0,132,80,1},
		[125] = {132*2,80*0,132,80,1},
		[126] = {132*2,80*0,132,80,1},
		[127] = {132*2,80*0,132,80,1},
		[128] = {132*2,80*0,132,80,1},
		[129] = {132*2,80*0,132,80,1},
		[130] = {132*2,80*0,132,80,1},
		[131] = {132*2,80*0,132,80,1},
		[132] = {132*2,80*0,132,80,1},
		[133] = {132*2,80*0,132,80,1},
		[134] = {132*2,80*0,132,80,1},
		[135] = {132*2,80*0,132,80,1},
		[136] = {132*2,80*0,132,80,1},
		[137] = {132*2,80*0,132,80,1},
		[138] = {132*2,80*0,132,80,1},
		[139] = {132*2,80*0,132,80,1},
		[140] = {132*2,80*0,132,80,1},
		[141] = {132*2,80*0,132,80,1},
		[142] = {132*2,80*0,132,80,1},
		[143] = {132*2,80*0,132,80,1},
		[144] = {132*2,80*0,132,80,1},
		[145] = {132*2,80*0,132,80,1},
		[146] = {132*2,80*0,132,80,1},
		[147] = {132*2,80*0,132,80,1},
		[148] = {132*2,80*0,132,80,1},
		[149] = {132*2,80*0,132,80,1},
		[150] = {132*2,80*0,132,80,1},
		[151] = {132*2,80*0,132,80,1},
		[152] = {132*2,80*0,132,80,1},
		[153] = {132*2,80*0,132,80,1},
		[154] = {132*2,80*0,132,80,1},
		[155] = {132*2,80*0,132,80,1},
		[156] = {132*2,80*0,132,80,1},
		[157] = {132*2,80*0,132,80,1},
		[158] = {132*2,80*0,132,80,1},
		[159] = {132*2,80*0,132,80,1},
		[160] = {132*2,80*0,132,80,1},
		[161] = {132*2,80*0,132,80,1},
		[162] = {132*2,80*0,132,80,1},
		[163] = {132*2,80*0,132,80,1},
		[164] = {132*2,80*0,132,80,1},
		[165] = {132*2,80*0,132,80,1},
		[166] = {132*2,80*0,132,80,1},
		[167] = {132*2,80*0,132,80,1},
		[168] = {132*2,80*0,132,80,1},
		[169] = {132*2,80*0,132,80,1},
		[170] = {132*2,80*0,132,80,1},
		[171] = {132*2,80*0,132,80,1},
		[172] = {132*2,80*0,132,80,1},
		[173] = {132*2,80*0,132,80,1},
		[174] = {132*2,80*0,132,80,1},
		[175] = {132*2,80*0,132,80,1},
		[176] = {132*2,80*0,132,80,1},
		[177] = {132*2,80*0,132,80,1},
		[178] = {132*2,80*0,132,80,1},
		[179] = {132*2,80*0,132,80,1},
		[180] = {132*2,80*0,132,80,1},
	},
}

_tab_model[9045] = {
	name = "MODEL_EFFECT:laser2",
	image = "effect/laser2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100000,
		[1] = {0,0,203,31,1},
	},
}

_tab_model[9046] = {
	name = "MODEL_EFFECT:laser3",
	image = "effect/laser3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,64,8,1},
	},
}

_tab_model[9047] = {
	name = "MODEL_EFFECT:laser4",
	image = "effect/laser4.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,64,16,1},
	},
}

_tab_model[9048] = {
	name = "MODEL_EFFECT:laser5",
	image = "effect/laser5.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,64,8,1},
	},
}

_tab_model[9049] = {
	name = "MODEL_EFFECT:k_boom",
	image = "effect/k_boom.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,170,140,3},
		[2] = {0,140,170,140,3},
		},
}

_tab_model[9050] = {
	name = "MODEL_EFFECT:dinji",
	image = "effect/dinji.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
		[2] = {0,200,100,100,2},
		},
}

_tab_model[9051] = {
	name = "MODEL_EFFECT:dinji2",
	image = "effect/dinji2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,100,100,5},
		[2] = {0,100,100,100,5},
		[2] = {0,200,100,100,2},
		},
}

_tab_model[9052] = {
	name = "MODEL_EFFECT:shandian",
	image = "effect/shandian.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 50,
		[1] = {0,0,260,90,1},
		[2] = {0,90,260,90,1},
		[3] = {0,180,260,90,1},
		[4] = {0,270,260,90,1},
		},
}

--强化台子灯
_tab_model[9053] = {
	name = "MODEL_EFFECT:guang2",
	image = "effect/guang2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,12,44,1},
	},
}


--镭射塔左
_tab_model[9054] = {
	name = "MODEL_EFFECT:leishe_l",
	image = "effect/leishe.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 5000000,
		[1] = {0,0,96,80,1},
	},
}

--导弹
_tab_model[9055] = {
	name = "MODEL_EFFECT:dadan",
	image = "effect/dadan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 200,
		[1] = {0 + 0,50*0 + 0 + 10,160,38,1},
		[2] = {0 + 0,50*1 + 1 + 10,160,38,1},
		[3] = {0 + 0,50*3 + 4 + 10,160,38,1},
		[4] = {0 + 1,50*4 + 3 + 10,160,38,1},
		[5] = {0 + 0,50*5 + 4 + 10,160,38,1},
		[6] = {0 + 0,50*6 + 6 + 10,160,38,1},
	},
}

--导弹爆炸
_tab_model[9056] = {
	name = "MODEL_EFFECT:katongzha",
	image = "effect/katongzha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 100,
		[1] = {0,0,78,94,4},
		[2] = {0,94,78,94,4},
		},
}

--透明
_tab_model[9057] = {
	name = "MODEL_EFFECT:touming",
	image = "effect/touming.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,2,2,1},
	},
}

--透明-大
_tab_model[9058] = {
	name = "MODEL_EFFECT:touming2",
	image = "effect/touming2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,300,300,1},
	},
}

--子弹6
_tab_model[9059] = {
	name = "MODEL_EFFECT:zidan6",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan6-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

--子弹7
_tab_model[9060] = {
	name = "MODEL_EFFECT:zidan7",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan7-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

_tab_model[9061] = {
	name = "MODEL_EFFECT:katongbaozha2",
	image = "effect/katongbaozha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
		[2] = {0,128,128,128,2},
		},
}

--飞机场部件1
_tab_model[9062] = {
	name = "MODEL_EFFECT:airfield_1",
	image = "effect/airfield_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,160,128,1},
	},
}

--飞机场部件2
_tab_model[9063] = {
	name = "MODEL_EFFECT:airfield_2",
	image = "effect/airfield_2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		[1] = {0,0,100,80,6},
		[2] = {0,80,100,80,6},
	},
}

--高射导弹特效
_tab_model[9064] = {
	name = "MODEL_EFFECT:TK_ATTACK3",
	image = "effect/eff_tile_TK_atk3.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 100,
		[1] = {0,0,27,58,5},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}
--[[
--测试导弹
_tab_model[9065] = {
	name = "MODEL_EFFECT:DAODAN_TEST",
	image = "effect/daodan_test.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		roll = 180,
		interval = 100,
		[1] = {0,0,166,43,6},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}
]]

--测试导弹
_tab_model[9065] = {
	name = "MODEL_EFFECT:DAODAN_TEST",
	image = "effect/dadan_fly.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,42*0,150,42,1},
		[2] = {0,42*1,150,42,1},
		[3] = {0,42*2,150,42,1},
		[4] = {0,42*3,150,42,1},
		[5] = {0,42*4,150,42,1},
		[6] = {0,42*5,150,42,1},
		[7] = {0,42*6,150,42,1},
		[8] = {0,42*7,150,42,1},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}


--测试导弹起飞
_tab_model[9066] = {
	name = "MODEL_EFFECT:DAODAN_TEST_UP",
	image = "effect/daodan_up.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,42*0,150,42,1},
		[2] = {0,42*0,150,42,1},
		[3] = {0,42*1,150,42,1},
		[4] = {0,42*1,150,42,1},
		[5] = {0,42*2,150,42,1},
		[6] = {0,42*2,150,42,1},
		[7] = {0,42*3,150,42,1},
		[8] = {0,42*3,150,42,1},
		[9] = {0,42*4,150,42,1},
		[0] = {0,42*4,150,42,1},
		[10] = {0,42*5,150,42,1},
		[11] = {0,42*5,150,42,1},
		[12] = {0,42*6,150,42,1},
		[13] = {0,42*6,150,42,1},
		[14] = {0,42*7,150,42,1},
		[15] = {0,42*7,150,42,1},
		[16] = {0,42*8,150,42,1},
		[17] = {0,42*8,150,42,1},
		[18] = {0,42*8,150,42,1},
		[19] = {0,42*8,150,42,1},
		[20] = {0,42*8,150,42,1},
		[21] = {0,42*8,150,42,1},
		[22] = {0,42*8,150,42,1},
		[23] = {0,42*8,150,42,1},
		[24] = {0,42*8,150,42,1},
		[25] = {0,42*8,150,42,1},
		[26] = {0,42*8,150,42,1},
		[27] = {0,42*8,150,42,1},
		[28] = {0,42*8,150,42,1},
		[29] = {0,42*8,150,42,1},
		[30] = {0,42*8,150,42,1},
		[31] = {0,42*8,150,42,1},
		[32] = {0,42*8,150,42,1},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}

--警告特效
_tab_model[9067] = {
	name = "MODEL_EFFECT:warning",
	image = "effect/warning.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 300,
		[1] = {0,0,64,64,2},
	},
}

--飞机场部件3
_tab_model[9068] = {
	name = "MODEL_EFFECT:airfield_3",
	image = "effect/airfield_3.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,160,128,1},
	},
}

--镭射塔右
_tab_model[9069] = {
	name = "MODEL_EFFECT:leishe_r",
	image = "effect/leishe.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 5000000,
		roll = 180,
		[1] = {0,0,96,80,1},
	},
}

--镭射塔上
_tab_model[9070] = {
	name = "MODEL_EFFECT:leishe_u",
	image = "effect/leishe.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 5000000,
		roll = -90,
		[1] = {0,0,96,80,1},
	},
}

--镭射塔上
_tab_model[9071] = {
	name = "MODEL_EFFECT:leishe_d",
	image = "effect/leishe.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 5000000,
		roll = 90,
		[1] = {0,0,96,80,1},
	},
}

--弹射物器
_tab_model[9072] = {
	name = "MODEL_EFFECT:fantanpao",
	image = "effect/fantanpao.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 60,
		[1] = {0,0,256,256,4},
		[2] = {0,256,256,256,2},
		},
}

_tab_model[9073] = {
	name = "MODEL_EFFECT:tnt",
	image = "effect/tnt.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 999999,
		[1] = {0,0,54,82,1},
		},
}

_tab_model[9074] = {
	name = "MODEL_EFFECT:huoyou",
	image = "effect/huoyou.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 999999,
		[1] = {0,0,54,84,1},
		},
}

_tab_model[9075] = {
	name = "MODEL_EFFECT:zha",
	image = "effect/zha.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 70,
		[1] = {0,0,54,82,10},
		},
}

_tab_model[9076] = {
	name = "MODEL_EFFECT:fireball2",
	image = "effect/fireball.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--flipX = 1,
		interval = 50,
		[1] = {0,0,64,128,8},
		[2] = {0,128,64,128,8},
		[3] = {0,128*2,64,128,8},
		[4] = {0,128*3,64,128,8},
	},
	dead = {
		image = "effect/burst_2.png",
		anchor = {0.5,0.5},
		interval = 50,
		height = 1,
		scale = 1.6,
		[1] = {0,0,64,64,6},
	},
}

--雷神之锤
_tab_model[9077] = {
	name = "MODEL_EFFECT:thunder",
	loadmode = "plist",
	plist = "effect/thunder.plist",
	image = "effect/thunder.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "thunder-",
		pMode = 3,
		[1] = {0,0,0,0,32},
	},
}

--雷神之锤（单帧）
_tab_model[9078] = {
	name = "MODEL_EFFECT:thunder_x",
	image = "effect/thunder.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 50,
		[1] = {0,0,256,256,1},
	},
}

--雷神之锤2
_tab_model[9079] = {
	name = "MODEL_EFFECT:thunder2",
	image = "effect/thunder.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.3},
		interval = 50,
		[1] = {0,256*0,256,256,6},
		[2] = {0,256*1,256,256,6},
		[3] = {0,256*2,256,256,6},
		[4] = {0,256*3,256,256,6},
		[5] = {0,256*4,256,256,6},
		[6] = {0,256*5,256,256,2},
	},
}

_tab_model[9080] = {
	name = "MODEL_EFFECT:feibiao",
	image = "effect/feibiao.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1,
		[1] = {0,0,80,50,6},
	},

}

_tab_model[9081] = {
	name = "MODEL_EFFECT:zidan18",
	loadmode = "plist",
	plist = "effect/zidan.plist",
	image = "effect/zidan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		pName = "zidan18-",
		pMode = 3,
		[1] = {0,0,0,0,1},
	},
}

--传送1
_tab_model[9082] = {
	name = "MODEL_EFFECT:transport1",
	image = "effect/transport1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5, 0.5,},
		interval = 100,
		[1] = {0,154*0,213,154,4},
		[2] = {0,154*1,213,154,4},
		[3] = {0,154*2,213,154,4},
		[4] = {0,154*3,213,154,4},
	},
}

--自动攻击特效
_tab_model[9083] = {
	name = "MODEL_EFFECT:AutoCast",
	image = "effect/autocast.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 90,
		interval = 50,
		[1] = {0,0,198,198,1},
	},
}

--黑色追踪导弹
_tab_model[9084] = {
	name = "MODEL_EFFECT:DAODAN_FLY_BLACK",
	image = "effect/dadan_fly_black.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,42*0,150,42,1},
		[2] = {0,42*1,150,42,1},
		[3] = {0,42*2,150,42,1},
		[4] = {0,42*3,150,42,1},
		[5] = {0,42*4,150,42,1},
		[6] = {0,42*5,150,42,1},
		[7] = {0,42*6,150,42,1},
		[8] = {0,42*7,150,42,1},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}

--黑色追踪导弹起飞
_tab_model[9085] = {
	name = "MODEL_EFFECT:DAODAN_UP_BLACK",
	image = "effect/daodan_up_black.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,42*0,150,42,1},
		[2] = {0,42*0,150,42,1},
		[3] = {0,42*1,150,42,1},
		[4] = {0,42*1,150,42,1},
		[5] = {0,42*2,150,42,1},
		[6] = {0,42*2,150,42,1},
		[7] = {0,42*3,150,42,1},
		[8] = {0,42*3,150,42,1},
		[9] = {0,42*4,150,42,1},
		[0] = {0,42*4,150,42,1},
		[10] = {0,42*5,150,42,1},
		[11] = {0,42*5,150,42,1},
		[12] = {0,42*6,150,42,1},
		[13] = {0,42*6,150,42,1},
		[14] = {0,42*7,150,42,1},
		[15] = {0,42*7,150,42,1},
		[16] = {0,42*8,150,42,1},
		[17] = {0,42*8,150,42,1},
		[18] = {0,42*8,150,42,1},
		[19] = {0,42*8,150,42,1},
		[20] = {0,42*8,150,42,1},
		[21] = {0,42*8,150,42,1},
		[22] = {0,42*8,150,42,1},
		[23] = {0,42*8,150,42,1},
		[24] = {0,42*8,150,42,1},
		[25] = {0,42*8,150,42,1},
		[26] = {0,42*8,150,42,1},
		[27] = {0,42*8,150,42,1},
		[28] = {0,42*8,150,42,1},
		[29] = {0,42*8,150,42,1},
		[30] = {0,42*8,150,42,1},
		[31] = {0,42*8,150,42,1},
		[32] = {0,42*8,150,42,1},
	},
	dead = {
		image = "effect/katongbaozha.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,128,128,2},
	},
}

--黑色追踪命中
_tab_model[9086] = {
	name = "MODEL_EFFECT:DAODAN_HIT_BLACK",
	image = "effect/dadan_hit_black.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,40,28,1},
	},
}

--导弹
_tab_model[9087] = {
	name = "MODEL_EFFECT:dadan_min",
	image = "effect/dadan.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.32},
		interval = 200,
		[1] = {0 + 0,50*0 + 0 + 10,160,38,1},
		[2] = {0 + 0,50*1 + 1 + 10,160,38,1},
		[3] = {0 + 0,50*3 + 4 + 10,160,38,1},
		[4] = {0 + 1,50*4 + 3 + 10,160,38,1},
		[5] = {0 + 0,50*5 + 4 + 10,160,38,1},
		[6] = {0 + 0,50*6 + 6 + 10,160,38,1},
	},

}



_tab_model[9088] = {
	name = "MODEL_EFFECT:laser6",
	image = "effect/laser6.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {1.0,0.5},
		interval = 1000,
		[1] = {0,0,60,28,1},
	},
}

_tab_model[9089] = {
	name = "MODEL_EFFECT:jiantou3",
	image = "effect/jiantou.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = -90,
		interval = 300,
		[1] = {0,0,48,34,6},
	},

}

--巨浪
_tab_model[9090] = {
	name = "MODEL_EFFECT:Julang",
	image = "effect/julang.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		[1] = {0,0,402,114,5},
		[2] = {0,114,402,114,4},
	},
}

_tab_model[9091] = {
	name = "MODEL_EFFECT:T_heal",
	image = "effect/T_heal.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,80,80,1},
	},
}

_tab_model[9092] = {
	name = "MODEL_EFFECT:timer01",
	image = "effect/timer01.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,90,90,1},
	},
}

_tab_model[9093] = {
	name = "MODEL_EFFECT:timer02",
	image = "effect/timer02.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 400,
		[1] = {0,0,90,90,4},
	},
}

_tab_model[9094] = {
	name = "MODEL_EFFECT:shield02",
	image = "effect/shield02.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,137,126,1},
	},
}

_tab_model[9095] = {
	name = "MODEL_EFFECT:shadow",
	image = "effect/shadow.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,74,27,2},
		[2] = {0,27,74,27,2},
	},
}

_tab_model[9096] = {
	name = "MODEL_EFFECT:boss_laser",
	loadmode = "plist",
	plist = "effect/boss_laser.plist",
	image = "effect/boss_laser.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		roll = 90, --初始旋转
		interval = 100,
		pName = "boss_laser_0",
		pMode = 2,
		[1] = {0,0,0,0,8}, --数量
	},
}

_tab_model[9097] = {
	name = "MODEL_EFFECT:shipcore",
	image = "effect/shipcore.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0, --初始旋转
		interval = 100,
		[1] = {0,0,115,107,5}, --数量
	},
}

_tab_model[9098] = {
	name = "MODEL_EFFECT:bossgun_fire1",
	image = "effect/bossgun_fire1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0, --初始旋转
		interval = 100,
		[1] = {0,0,92,92,7}, --数量
	},
}

--高射塔底座
_tab_model[9099] = {
	name = "MODEL_EFFECT:GAOSHETA_BASE",
	image = "effect/tdgaosheta_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,300,300,1},
	},
}

--机枪塔底座
_tab_model[9100] = {
	name = "MODEL_EFFECT:JIQIANGTA_BASE",
	image = "effect/tdjiqiangta_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,350,350,1},
	},
}

--炮台塔底座
_tab_model[9101] = {
	name = "MODEL_EFFECT:PAOTAITA_BASE",
	image = "effect/tdpaotaita_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,350,350,1},
	},
}

--射击塔底座
_tab_model[9102] = {
	name = "MODEL_EFFECT:SHEJITA_BASE",
	image = "effect/tdshejita_base.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,350,350,1},
	},
}

--宇宙中 太阳
_tab_model[9103] = {
	name = "MODEL_EFFECT:SPACE_SUN",
	image = "effect/space_sun.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 800,
		[1] = {0,0,200,200,6},
		[2] = {200 * 5,0,200,200,1},
		[3] = {200 * 4,0,200,200,1},
		[4] = {200 * 3,0,200,200,1},
		[5] = {200 * 2,0,200,200,1},
		[6] = {200 * 1,0,200,200,1},
	},
}

_tab_model[9104] = {
	name = "MODEL_EFFECT:SPACE_STAR",
	image = "effect/space_star.png",
	animation = {
		"stand1",
		"stand2",
		"stand3",
	},
	stand1 = {
		anchor = {0.5,0.5},
		interval = 360,
		[1] = {0,0,220,220,3},
		[2] = {220 * 1,0,220,220,1},
		[3] = {220 * 1,0,220,220,1},
	},
	stand2 = {
		anchor = {0.5,0.5},
		interval = 360,
		[1] = {220 * 3,0,220,220,3},
		[2] = {220 * 4,0,220,220,1},
		[3] = {220 * 4,0,220,220,1},
	},
	stand3 = {
		anchor = {0.5,0.5},
		interval = 360,
		[1] = {220 * 6,0,220,220,3},
		[2] = {220 * 7,0,220,220,1},
		[3] = {220 * 7,0,220,220,1},
	},
}

--手雷飞行特效（无命中）
_tab_model[9105] = {
	name = "MODEL_EFFECT:zhadan_nohit",
	image = "effect/zhadan.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,85,85,3},
		[2] = {0,0,85,85,3},
		[3] = {0,0,85,85,3},
	},
	dead = {
		image = "effect/touming.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,2,2,1},
	},
}

_tab_model[9106] = {
	name = "MODEL_EFFECT:laser7",
	image = "effect/laser7.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,64,16,1},
	},
}

_tab_model[9107] = {
	name = "MODEL_EFFECT:laser8",
	image = "effect/laser8.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		interval = 1000,
		[1] = {0,0,64,16,1},
	},
}

--核弹飞行特效（无命中）
_tab_model[9108] = {
	name = "MODEL_EFFECT:zhadan6",
	image = "effect/zhadan6.png",
	animation = {
		"stand",
		"dead",
		},
	stand = {
		anchor = {0.5,0.5},
		roll = 90,
		interval = 100,
		[1] = {0,0,128,128,1},
	},
	dead = {
		image = "effect/touming.png",
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,2,2,1},
	},
}

--圆形按钮
_tab_model[9109] = {
	name = "MODEL_EFFECT:circlebutton",
	loadmode = "plist",
	plist = "effect/circlebutton.plist",
	image = "effect/circlebutton.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "circle_0",
		pMode = 3,
		[1] = {0,0,0,0,12},
	},
}

--技能冷却完毕特效
_tab_model[9110] = {
	name = "MODEL_EFFECT:strengthen2",
	image = "effect/strengthen2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,64*0,64,64,6},
		[2] = {0,64*1,64,64,6},
		[3] = {0,64*2,64,64,6},
		[4] = {0,64*3,64,64,6},
		[5] = {0,64*4,64,64,6},
	},
}

--沉默特效
_tab_model[9111] =
{
	name = "MODEL_EFFECT:way_not_arrow",
	image = "effect/chenmo.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5, 0.5},
		interval = 250,
		[1] = {0,0,48,48},
		[2] = {48,0,48,48},
	},
}

--漩涡特效
_tab_model[9112] = {
	name = "MODEL_EFFECT:XuanWo",
	loadmode = "plist",
	plist = "effect/xuanwo.plist",
	image = "effect/xuanwo.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 150,
		pName = "xuanwo_",
		pMode = 2,
		[1] = {0,0,0,0,45},
	},
}

--点击按钮1
_tab_model[9113] = {
	name = "MODEL_EFFECT:StartAmin1",
	loadmode = "plist",
	plist = "effect/start1.plist",
	image = "effect/start1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "start1_",
		pMode = 2,
		[1] = {0,0,0,0,10},
	},
}

--点击按钮2
_tab_model[9114] = {
	name = "MODEL_EFFECT:StartAmin2",
	loadmode = "plist",
	plist = "effect/start2.plist",
	image = "effect/start2.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "start2_",
		pMode = 2,
		[1] = {0,0,0,0,10},
	},
}

--爪击
_tab_model[9115] = {
	name = "MODEL_EFFECT:Arrow_13",
	image = "effect/arrow_13.png",
	animation = {
		"stand",
		"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		roll = 0,
		--flipX = 1,
		interval = 1000,
		[1] = {0,0,150,70,1},
	},
	dead = {
		image = "effect/laserball_explosion.png",
		anchor = {0.5,0.5},
		interval = 30,
		height = 1,
		scale = 1.6,
		[1] = {0,0,30,32,5},
	},
}

--开宝箱
_tab_model[9116] = {
	name = "MODEL_EFFECT:OpenChest",
	loadmode = "plist",
	plist = "effect/openchest.plist",
	image = "effect/openchest.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "openchest_0",
		pMode = 2,
		[1] = {0,0,0,0,9},
	},
}

--开宝箱0
_tab_model[9117] =
{
	name = "MODEL_EFFECT:OpenChest0",
	image = "effect/openchest0.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5, 0.5},
		interval = 250,
		[1] = {0,0,324,308},
	},
}

--升级
_tab_model[9118] = {
	name = "MODEL_EFFECT:Summon_3",
	image = "effect/Summon_1.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.75},
		interval = 60,
		[1] = {0,0,76,145,4},
		[2] = {0,145,76,145,4},
		[3] = {0,145*2,76,145,2},
	},
}

--芯片洗炼
_tab_model[9119] = {
	name = "MODEL_EFFECT:ChipForge",
	loadmode = "plist",
	plist = "effect/chip.plist",
	image = "effect/chip.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 80,
		pName = "chip00",
		pMode = 2,
		[1] = {0,0,0,0,6},
	},
}

--宝物001-动图
_tab_model[9120] = {
	name = "MODEL_EFFECT:treasure001",
	loadmode = "plist",
	plist = "misc/treasure/treasure001.plist",
	image = "misc/treasure/treasure001.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "treasure001_a",
		pMode = 2,
		[1] = {0,0,0,0,7},
	},
}

--宝物001-高亮
_tab_model[9121] = {
	name = "MODEL_EFFECT:treasure001_light",
	image = "misc/treasure/treasure001-02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,491,556,1},
	},
}

--宝物002-动图
_tab_model[9122] = {
	name = "MODEL_EFFECT:treasure002",
	loadmode = "plist",
	plist = "misc/treasure/treasure002.plist",
	image = "misc/treasure/treasure002.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "treasure002_a",
		pMode = 2,
		[1] = {0,0,0,0,10},
	},
}

--宝物002-高亮
_tab_model[9123] = {
	name = "MODEL_EFFECT:treasure002_light",
	image = "misc/treasure/treasure002-02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,229,626,1},
	},
}

--宝物004-动图
_tab_model[9124] = {
	name = "MODEL_EFFECT:treasure004",
	loadmode = "plist",
	plist = "misc/treasure/treasure004.plist",
	image = "misc/treasure/treasure004.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "treasure004_a",
		pMode = 2,
		[1] = {0,0,0,0,9},
	},
}

--宝物004-高亮
_tab_model[9125] = {
	name = "MODEL_EFFECT:treasure004_light",
	image = "misc/treasure/treasure004-02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,269,267,1},
	},
}

--宝物008-动图
_tab_model[9126] = {
	name = "MODEL_EFFECT:treasure008",
	loadmode = "plist",
	plist = "misc/treasure/treasure008.plist",
	image = "misc/treasure/treasure008.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "treasure008_a",
		pMode = 2,
		[1] = {0,0,0,0,7},
	},
}

--宝物008-高亮
_tab_model[9127] = {
	name = "MODEL_EFFECT:treasure008_light",
	image = "misc/treasure/treasure008-02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,327,333,1},
	},
}

--宝物009-动图
_tab_model[9128] = {
	name = "MODEL_EFFECT:treasure009",
	loadmode = "plist",
	plist = "misc/treasure/treasure009.plist",
	image = "misc/treasure/treasure009.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		pName = "treasure009_a",
		pMode = 2,
		[1] = {0,0,0,0,7},
	},
}

--宝物009-高亮
_tab_model[9129] = {
	name = "MODEL_EFFECT:treasure009_light",
	image = "misc/treasure/treasure009-02.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		[1] = {0,0,336,296,1},
	},
}

--王尼玛
_tab_model[9130] = {
	name = "MODEL_EFFECT:zidan25",
	image = "effect/zidan25.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 50,
		[1] = {0,0,80,80,1},
	},
}

--顺丰箱子5
_tab_model[9131] = {
	name = "MODEL_EFFECT:sf5",
	image = "effect/sf5.png",
	animation = {
		"stand",
		--"dead",
	},
	stand = {
		anchor = {0.5,0.5},
		--roll = 180,
		interval = 100,
		[1] = {0,0,90,95,1},
	},
}


_tab_model[9132] = {
	name = "MODEL_EFFECT:shield04",
	image = "effect/shield04.png",
	animation = {
		"stand",
		},
	stand = {
		anchor = {0.5,0.5},
		interval = 200,
		[1] = {0,0,137,126,1},
	},
}

--战术卡描边
_tab_model[9133] = {
	name = "MODEL_EFFECT:TacticUsing",
	loadmode = "plist",
	plist = "effect/tactic.plist",
	image = "effect/tactic.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 120,
		pName = "tactic00",
		pMode = 2,
		[1] = {0,0,0,0,4},
	},
}