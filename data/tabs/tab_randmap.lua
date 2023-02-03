hVar.tab_randmap = {}
local _tab_randmap = hVar.tab_randmap

_tab_randmap[1] = 
{
	[1] = {	--阶段1
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_001",
			"world/csys_001a",
			"world/csys_001b",
			"world/csys_001c",
		},
		extra_settings = {	--额外设定
			--额外战术信息
			tacticsInfo = {
				--{id,lv}, --战术卡ID 等级
			},
		}
	},
	[2] = {	--阶段2
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_002",
			"world/csys_002a",
			"world/csys_002b",
		},
	},
	[3] = {	--阶段3
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_003",
			"world/csys_003a",
			"world/csys_003b",
		},
	},
	[4] = {	--阶段4
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_004",
			"world/csys_004a",
			"world/csys_004b",
		},
	},
	[5] = {	--阶段5
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_005",
			"world/csys_005a",
			"world/csys_005b",
		},
	},
	[6] = {	--阶段6
		randmap ={		--随机地图列表 会从中选取地图
			"world/csys_006",
			"world/csys_006a",
			"world/csys_006b",
		},
	},
}