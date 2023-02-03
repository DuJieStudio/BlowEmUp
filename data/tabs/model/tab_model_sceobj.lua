local _tab_model = hVar.tab_model
--[5000~7999建筑]--------------------------------
_tab_model[5000] = {
	--栅栏1
	name = "MODEL_SCENEOBJ:zhalan_1",
	image = "map/map_1.png",
	animation = {
		"stand_1",
		"stand_2",
		"stand_3",
	},
	stand_1 = {
		anchor = {0.54,0.58},
		interval = 0,
		[1] = {64,65,64,64},
	},
	stand_2 = {
		anchor = {0.54,0.58},
		interval = 0,
		[1] = {135,65,64,64},
	},
	stand_3 = {
		interval = 0,
		[1] = {390,138,64,68},
	},
}

_tab_model[5001] = {
	--水车
	name = "MODEL_SCENEOBJ:mill",
	image = "unit/sceneobj/mill.png",
		animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.8},
		interval = 0,
		[1] = {0,0,76,70,1},
	},
}

_tab_model[5002] = {
	--宝箱
	name = "MODEL_SCENEOBJ:chest",
	image = "unit/sceneobj/chest.png",
		animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.65},
		interval = 0,
		[1] = {0,0,42,48,1},
	},
}

-----------------------------------
-- 创建城墙的model
--5101~5300
local SIEGE_DATA = {
	index = 5100,
	style = {"default"},
	conv = {},
	[1] = {228,671,{0,0}},
}
local TOWER_ID = {[1]=1,[3]=1,[5]=1,[7]=1}--{[1]=1,[7]=1}
local DEST_ID = {[2]=1,[4]=1,[6]=1}--{[2]=1,[4]=1,[6]=1}
local GATE_ID = {[4]=1}
for k,v in pairs(hVar.SIEGE_STYLE)do
	if k=="default" then
		SIEGE_DATA.conv[k] = v
	else
		SIEGE_DATA.style[#SIEGE_DATA.style+1] = v
	end
end
for n = 1,#SIEGE_DATA.style do
	local styleName = SIEGE_DATA.style[n]
	local modelName = "MODEL_SCENEOBJ:SIEGE_"..SIEGE_DATA.style[n]
	local modelPath
	if SIEGE_DATA.conv[styleName]~=nil then
		modelPath = "../map/town/wall/"..SIEGE_DATA.conv[styleName]
	else
		modelPath = "../map/town/wall/"..styleName
	end
	for i = 1,7 do
		local v = SIEGE_DATA[1]
		local t = {
			name = modelName.."_"..i,
			image = modelPath.."/"..i..".png",
			animation = {
				"stand",
				"DAMAGED_stand",
				"RUIN_stand",
			},
			stand = {
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			},
			DAMAGED_stand = {
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			},
			RUIN_stand = {
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			},
		}
		SIEGE_DATA.index = SIEGE_DATA.index + 1
		_tab_model[SIEGE_DATA.index] = t
		if TOWER_ID[i] then
			t.animation[#t.animation+1] = "TOWER_stand"
			t.TOWER_stand = {
				image = modelPath.."/"..i.."t.png",
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			}
		end
		if GATE_ID[i] then
			t.animation[#t.animation+1] = "stand_opened"
			t.stand_opened = {
				image = modelPath.."/"..i.."g.png",
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			}
		end
		if DEST_ID[i] then
			t.DAMAGED_stand = {
				image = modelPath.."/"..i.."d.png",
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			}
			t.RUIN_stand = {
				image = modelPath.."/"..i.."r.png",
				anchor = v[3],
				roll = v[4],
				[1] = {0,0,v[1],v[2]},
			}
			if GATE_ID[i] then
				t.animation[#t.animation+1] = "DAMAGED_stand_opened"
				t.DAMAGED_stand_opened = {
					image = modelPath.."/"..i.."gd.png",
					anchor = v[3],
					roll = v[4],
					[1] = {0,0,v[1],v[2]},
				}
			end
		end
	end
end


_tab_model[5501] = {
	name = "MODEL_SCENEOBJ:bb_head",
	loadmode = "plist",
	plist = "unit/shengwu/battle_ship.plist",
	image = "unit/shengwu/battle_ship.pvr.ccz",
	animation = {
		"stand",
		"DAMAGED_stand",
		"RUIN_stand",
	},
	stand = {
		pMode = 0,
		pName = "unit/shengwu/bb_head",
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
	},
	DAMAGED_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_head_d",
	},
	RUIN_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_head_r",
	},
}

_tab_model[5502] = {
	name = "MODEL_SCENEOBJ:bb_def_d",
	loadmode = "plist",
	plist = "unit/shengwu/battle_ship.plist",
	image = "unit/shengwu/battle_ship.pvr.ccz",
	animation = {
		"stand",
		"DAMAGED_stand",
		"RUIN_stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_d",
	},
	DAMAGED_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_dd",
	},
	RUIN_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_dr",
	},
}

_tab_model[5503] = {
	name = "MODEL_SCENEOBJ:bb_def_u",
	loadmode = "plist",
	plist = "unit/shengwu/battle_ship.plist",
	image = "unit/shengwu/battle_ship.pvr.ccz",
	animation = {
		"stand",
		"DAMAGED_stand",
		"RUIN_stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_u",
	},
	DAMAGED_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_ud",
	},
	RUIN_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/bb_def_ur",
	},
}

_tab_model[5504] = {
	name = "MODEL_SCENEOBJ:mm_spu",
	loadmode = "plist",
	plist = "unit/shengwu/mountain_monster.plist",
	image = "unit/shengwu/mountain_monster.pvr.ccz",
	animation = {
		"stand",
		"RUIN_stand",
		"normal",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/mon_spt",
	},
	RUIN_stand = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/mon_sd",
	},
	normal = {
		anchor = {0.5,0.5},
		interval = 0,
		[1] = {0,0,0,0,1},
		pMode = 0,
		pName = "unit/shengwu/mon_spt",
	},
}