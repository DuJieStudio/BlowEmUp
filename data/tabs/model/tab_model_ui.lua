local _tab_model = hVar.tab_model
_tab_model[10001] = {
	name = "UI:BTN_ButtonRed",
	image = "misc/ui_button.png",
	animation = {
		"normal",
		--"selected",
		"disable",
	},
	normal = {
		interval = 1000,
		[1] = {4,7,144,48},
	},
	--selected = {
		--interval = 1000,
		--[1] = {0,8,152,48},
	--},
	disable = {
		interval = 1000,
		[1] = {4,71,144,48},
	},
}

_tab_model[10002] = {
	name = "UI:Lock",
	image = "misc/minilock.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,32,32},
	},
}

_tab_model[10004] = {
	name = "UI:BTN_Close",
	image = "ui/btn_close.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[10007] = {
	name = "UI:MSGBOX",
	image = "ui/dlg.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,842,334},
	},
}

_tab_model[10008] = {
	name = "UI:BTN_ok",
	image = "ui/ok.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,66},
	},
}

_tab_model[10009] = {
	name = "UI:BTN_cancel",
	image = "ui/cancel.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,66},
	},
}

_tab_model[10018] = {
	name = "UI:BAR_talk_bg",
	image = "misc/bar_talk_bg.png",
	animation = {
		"normal",
		"L",
		"R",
		"M",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,22,140},
	},
	L = {
		interval = 1000,
		[1] = {0,0,22,140},
	},
	M = {
		interval = 1000,
		[1] = {22,0,18,140},
	},
	R = {
		interval = 1000,
		[1] = {40,0,22,140},
	},
}

_tab_model[10019] = {
	name = "UI:BAR_sepline",
	image = "misc/skillup/sepline.png",
	animation = {
		"normal",
		"L",
		"R",
		"M",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,260, 2},
	},
	L = {
		interval = 1000,
		[1] = {0,0,90, 2},
	},
	M = {
		interval = 1000,
		[1] = {90,0,80, 2},
	},
	R = {
		interval = 1000,
		[1] = {170,0,90, 2},
	},
}



_tab_model[10021] = {
	name = "UI:ArchAngel",
	image = "ui/character_000.png",
	animation = {
		"stand",
	},
	stand = {
		flipX = 1,
		interval = 1000,
		[1] = {1605,0,170,185},
	},
}

_tab_model[10022] = {
	name = "UI:Queen",
	image = "ui/character_000.png",
	animation = {
		"stand",
	},
	stand = {
		flipX = 1,
		interval = 1000,
		[1] = {1605,186,166,166},
	},
}

_tab_model[10023] = {
	name = "UI:Saber",
	image = "ui/character_000.png",
	animation = {
		"stand",
	},
	stand = {
		flipX = 1,
		interval = 1000,
		[1] = {1175,333,140,150},
	},
}

_tab_model[10024] = {
	name = "UI:Knight",
	image = "ui/character_000.png",
	animation = {
		"stand",
	},
	stand = {
		flipX = 1,
		interval = 1000,
		[1] = {1593,491,128,118},
	},
}

_tab_model[10025] = {
	name = "UI:choice_border",
	image = "misc/border.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,906,906},
	},
}

_tab_model[10029] = {
	name = "UI:BUY_UNITS",
	image = "ui/buy_unit.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,484,394},
	},
}

_tab_model[10031] = {
	name = "UI:NUM_BAR",
	image = "ui/numBar.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,274,96},
	},
}

_tab_model[10033] = {
	name = "UI:FLAG_PINK",
	image = "ui/flag_pink.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,256,256},
	},
}

_tab_model[10999] = {
	name = "UI:LOGIN_BG",
	image = "misc/addition/morizhanche.jpg",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,1560,720},
	},
}

-------------------------
-- 主面板UI

--_tab_model[11002] = {
	--name = "UI_frm:info_BG",
	--image = "ui/ui_frm.png",
	--animation = {
		--"normal",
		--"short",
	--},
	--normal = {
		--[1] = {807,1290,290,390},
	--},
	--short = {
		--[1] = {1102,1470,290,210},
	--},
--}

_tab_model[11003] = {
	name = "UI_frm:slot",
	image = "misc/slot.png",
	animation = {
		"normal",
		"light",
		"lightSlim",
	},
	normal = {
		[1] = {5,2,76,76},
	},
	light = {
		[1] = {89,2,85,85},
	},
	lightSlim = {
		[1] = {91,4,79,79},
	},
}



_tab_model[11006] = {
	name = "UI:ICON_main_frm_ResourceWood",
	image = "ui/res_wood.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11007] = {
	name = "UI:ICON_main_frm_ResourceFood",
	image = "ui/res_food.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11008] = {
	name = "UI:ICON_main_frm_ResourceStone",
	image = "ui/res_stone.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11009] = {
	name = "UI:ICON_main_frm_ResourceIron",
	image = "ui/res_metal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11011] = {
	name = "UI:ICON_main_frm_ResourceJewel",
	image = "ui/res_crystal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11012] = {
	name = "UI:ICON_ResourceGold",
	image = "ui/pvp/res_money.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}


--_tab_model[11013] = {
	--name = "UI:FRM_FrameMain",
	--image = "ui/ui_frm.png",
	--animation = {
		--"normal",
		--"L",
		--"M",
		--"R",
	--},
	--normal = {
		--flipX = 1,
		--[1] = {0,0,740,380},
	--},
	--L = {
		--[1] = {0,0,8,190},
	--},
	--M = {
		--[1] = {8,0,360,190},
	--},
	--R = {
		--flipX = 1,
		--[1] = {0,0,8,190},
	--},
--}

--_tab_model[11014] = {
	--name = "UI:FRM_FrameMain_Buttom",
	--image = "ui/ui_frm.png",
	--animation = {
		--"L",
		--"M",
		--"R",
	--},
	--L = {
		--[1] = {0,368,8,12},
	--},
	--M = {
		--[1] = {8,368,360,12},
	--},
	--R = {
		--flipX = 1,
		--[1] = {0,368,8,12},
	--},
--}

--_tab_model[11016] = {
	--name = "UI:BAR_FrameTittleBar",
	--image = "ui/ui_frm.png",
	--animation = {
		--"L",
		--"M",
		--"R",
	--},
	--L = {
		--[1] = {0,542,20,30},
	--},
	--M = {
		--[1] = {20,542,46,30},
	--},
	--R = {
		--[1] = {66,542,20,30},
	--},
--}

_tab_model[11019] = {
	name = "UI:DragHand",
	image = "ui/draghand.png",
	motion = {{0,-5,0.3},{0,0,0.3}},
	animation = {
		"normal",
		"hover",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,74,96},
	},
	hover = {
		interval = 400,
		[1] = {0,0,74,96},
		--[2] = {0,-4,74,96},
		--[3] = {0,-1,74,96},
		--[4] = {0,-4,74,96},
	},
}

_tab_model[11020] = {
	name = "ICON:ATTR_exp",
	image = "ui/heroattr.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}


--_tab_model[11021] = {
	--name = "UI:FRM_BF_ControlPanel",
	--image = "ui/ui_frm.png",
	--animation = {
		--"normal",
		--"back",
	--},
	--normal = {
		--[1] = {1783,1,265,200},
	--},
	--back = {
		--[1] = {1783,203,265,200},
	--},
--}

--_tab_model[11023] = {
	--name = "UI:BTN_ControlSlot",
	--image = "ui/ui_frm.png",
	--animation = {
		--"normal",
		--"blue",
		--"green",
		--"red",
		--"empty",
		--"skill",
	--},
	--normal = {
		--[1] = {1690,287,92,92},
	--},
	--blue = {
		--[1] = {1690,287,92,92},
	--},
	--green = {
		--[1] = {1690,194,92,92},
	--},
	--red = {
		--[1] = {1690,381,92,92},
	--},
	--empty = {
		--[1] = {1690,99,92,92},
	--},
	--skill = {
		--[1] = {1032,141,86,86},
	--},
--}

_tab_model[11024] = {
	name = "UI:BTN_ControlButton",
	image = "ui/cmd_wait.png",
	animation = {
		"wait",
		"guard",
		"surrender",
		"grid",
	},
	wait = {
		image = "ui/cmd_wait.png",
		--[1] = {1029,230,96,96},
		[1] = {0,0,80,80},
	},
	guard = {
		image = "ui/cmd_defend.png",
		[1] = {0,0,80,80},
	},
	surrender = {
		image = "ui/cmd_surrender.png",
		[1] = {0,0,64,64},
		--[1] = {1032,359,56,56},
	},
	grid = {
		image = "ui/cmd_showgrid.png",
		[1] = {0,0,64,64},
		--[1] = {1108,359,56,56},
	},
}

_tab_model[11025] = {
	name = "UI:BTN_DragableHint",
	image = "ui/btn_dragablehint.png",
	animation = {
		"L",
		"R",
		"U",
		"D",
	},
	L = {
		flipX = 1,
		[1] = {0,0,30,100},
	},
	R = {
		[1] = {0,0,30,100},
	},
	U = {
		roll = 270,
		[1] = {0,0,30,100},
	},
	D = {
		roll = 90,
		[1] = {0,0,30,100},
	},
}

_tab_model[11026] = {
	name = "UI:IMG_ValueBar",
	image = "misc/valuebar_old.png",
	animation =
	{
		"normal",
		--"green",
		"red",
		"blue",
		--"orange",
		"yellow",
	},
	normal =
	{
		[1] = {5, 36, 72, 9},
	},
	--green =
	--{
	--	[1] = {4, 15, 34, 4},
	--},
	red =
	{
		[1] = {4, 20, 62, 8},
	},
	blue =
	{
		[1] = {4, 46, 62, 8},
	},
	--orange =
	--{
	--	[1] = {4, 39, 34, 4},
	--},
	yellow =
	{
		[1] = {4, 33, 62, 8},
	},
}

_tab_model[11027] = {
	name = "UI:BAR_ValueBar_BG",
	image = "misc/valuebar_old.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {3, 5,64,10},
	},
	L = {
		[1] = {3,5,2,10},
	},
	M = {
		[1] = {5,5,60,10},
	},
	R = {
		[1] = {65,5,2,10},
	},
}

_tab_model[11028] = {
	name = "UI:FRM_TownFrame_BG",
	image = "ui/panel_town.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1022,92},
	},
}

_tab_model[11029] = {
	name = "UI:BTN_SkillSelector",
	--image = "ui/skillselector.png",
	image = "ui/battle_frame.png",
	animation = {
		"normal",
	},
	normal = {
		--[1] = {0,0,56,38},
		[1] = {0,0,72,72},
	},
}

_tab_model[11031] = {
	name = "UI:Button_SelectBorder_blue",
	image = "misc/addition/q_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,200,200},
	},
}

_tab_model[11032] = {
	name = "UI:Button_SelectBorder",
	image = "misc/photo_frame.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

--_tab_model[11033] = {
	--name = "UI:Button_MaxValue",
	--image = "button/MaxValue.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,67,34},
	--},
--}
_tab_model[11034] = {
	name = "UI:Button_Shake",
	image = "button/Shake.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,66,34},
	},
}

_tab_model[11035] = {
	name = "UI:UI_Arrow",
	image = "ui/update_arrow.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11043] = {
	name = "UI:MAPICON",
	image = "misc/map_icon.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11044] = {
	name = "UI:SHOW_BUILDINGNAME",
	image = "ui/building.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11045] = {
	name = "UI:LEAVETOWNBTN",
	image = "ui/door.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,68,68},
	},
}


_tab_model[11046] = {
	name = "UI:BAR_S1_ValueBar_BG",
	image = "misc/s1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,26},
	},
}

_tab_model[11047] = {
	name = "UI:IMG_S1_ValueBar",
	image = "misc/progress.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,16},
	},
}

--_tab_model[11048] = {
	--name = "UI:PANEL_INFO_S",
	--image = "ui/panel_info_s.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,554,462},
	--},
--}


--_tab_model[11049] = {
	--name = "UI:PANEL_INFO",
	--image = "ui/panel_large.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,652,548},
	--},
--}


_tab_model[11050] = {
	name = "BTN:PANEL_CLOSE",
	image = "ui/close.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11051] = {
	name = "UI:PANEL_INFO_MINI",
	image = "panel/panel_basic.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,420,270},
	},
}

--_tab_model[11052] = {
	--name = "UI:PANEL_INFO_L",
	--image = "panel/panel_info_l.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,652,548},
	--},
--}

_tab_model[11053] = {
	name = "UI:ValueBar_Back",
	image = "misc/valuebar_back.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0,0,530,48},
	},
	L = {
		[1] = {0,0,8,48},
	},
	M = {
		[1] = {20,0,344,48},
	},
	R = {
		[1] = {510,0,8,48},
	},
}

_tab_model[11054] = {
	name = "UI:ValueBar",
	image = "misc/valuebar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,476,18},
	},
}

_tab_model[11055] = {
	name = "UI:btnMinus",
	image = "ui/btnminus.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,32},
	},
}

_tab_model[11056] = {
	name = "UI:btnPlus",
	image = "ui/btnplus.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,32},
	},
}

_tab_model[11057] = {
	name = "UI:scrollBtn",
	image = "misc/scrollBtn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,20,44},
	},
}

_tab_model[11058] = {
	name = "UI:okBtn",
	image = "ui/okbtn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,98,66},
	},
}
--_tab_model[11059] = {
	--name = "UI:maxBtn",
	--image = "ui/maxbtn.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,98,66},
	--},
--}

--_tab_model[11060] = {
	--name = "UI:ConfimBtn",
	--image = "ui/confimbtn.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,76,46},
	--},
--}

_tab_model[11061] = {
	name = "UI:tip_item",
	image = "panel/tip_item.png",
	animation = {
		"L",
		"M",
		"R",
		"normal",
	},
	L = {
		[1] = {0,0,20,270},
	},
	M = {
		[1] = {20,0,254,270},
	},
	R = {
		[1] = {274,0,20,270},
	},
	normal = {
		[1] = {20,20,160,160},
	},
}

_tab_model[11062] = {
	name = "UI:frm_b",
	image = "misc/frm_b.png",
	animation = {
		"L",
		"M",
		"R",
		"normal",
	},
	L = {
		[1] = {0,0,4,12},
	},
	M = {
		[1] = {4,0,8,12},
	},
	R = {
		[1] = {8,0,12,12},
	},
	normal = {
		[1] = {0,0,12,12},
	},
}


_tab_model[11063] = {
	name = "UI:PHOTO_FRAME_BAR",
	image = "misc/photo_frame.png",
	animation = {
		"L",
		"M",
		"R",
	},
	L = {
		[1] = {0,0,6,72},
	},
	M = {
		[1] = {6,0,61,72},
	},
	R = {
		[1] = {67,0,5,72},
	},

}

_tab_model[11064] = {
	name = "UI:PANEL_CARD_01",
	image = "panel/panel_card_01.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,140,180},
	},
}

_tab_model[11065] = {
	name = "UI:HERO_STAR",
	image = "ui/hero_star.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,12,12},
	},
}

_tab_model[11066] = {
	name = "UI:button_card",
	image = "ui/button_card.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,46},
	},
}

_tab_model[11067] = {
	name = "UI:button_acv",
	image = "ui/button_acv.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,46},
	},
}

_tab_model[11068] = {
	name = "UI:button_back",
	image = "ui/button_back.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11069] = {
	name = "UI:button_return",
	image = "ui/button_return01.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11070] = {
	name = "ICON_world/level_hjzl",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_1",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11071] = {
	name = "ICON_world/level_qxfdz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_2",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11072] = {
	name = "ICON_world/level_bhzw",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_3",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11073] = {
	name = "level_territory",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_territory",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}



--_tab_model[8098] = {
--	name = "PHONE:OPENBFSFRM",
--	loadmode = "plist",
--	plist = "../xlobj/xlobjs_lobby.plist",
--	image = "../xlobj/xlobjs_lobby.png",
--	animation = {
--		"stand",
--	},
--	stand = {
--		anchor = {0.5,0.5},
--		interval = 1000,
--		pName = "data/xlobj/menu_cards",
--		pMode = 0,
--		[1] = {0,0,0,0,1},
--	},
--}
_tab_model[11074] = {
	name = "ICON_world/level_tyjy",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_0",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11075] = {
	name = "UI:LOCK",
	image = "ui/lock.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

--[[
_tab_model[11076] = {
	name = "UI:Card_slot",
	image = "panel/card_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,140,180},
	},
}
]]

_tab_model[11077] = {
	name = "UI:wall",
	image = "ui/wall.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[10078] = {
	name = "UI:STAR_YELLOW",
	image = "ui/star_yellow.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[11079] = {
	name = "UI:star_slot",
	image = "ui/star_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11080] = {
	name = "UI:star_half",
	image = "ui/star_half.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11081] = {
	name = "UI:finish",
	image = "ui/finish.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,52,40},
	},
}

_tab_model[11082] = {
	name = "UI:next_day",
	image = "ui/next_day.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,70},
	},
}


_tab_model[11083] = {
	name = "ICON_world/level_ccjq",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11084] = {
	name = "UI:game_coins",
	image = "misc/game_coins.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}

_tab_model[11085] = {
	name = "buy_coins",
	image = "misc/buy_coins.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,64},
	},
}


_tab_model[11086] = {
	name = "UI:ach_weathy",
	image = "ui/ach_weathy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}


_tab_model[11087] = {
	name = "UI:ach_weathy_slot",
	image = "ui/ach_weathy_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}


_tab_model[11088] = {
	name = "UI:ach_lightning",
	image = "ui/ach_lightning.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11089] = {
	name = "UI:ach_lightning_slot",
	image = "ui/ach_lightning_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11090] = {
	name = "UI:TileFrmBack",
	image = "panel/panel_part_00.png",
	animation = {
		"normal",
		"LT",
		"MT",
		"RT",
		"LC",
		"RC",
		"LB",
		"MB",
		"RB",
	},
	normal = {
		[1] = {0,0,256,256},
	},
	LT = {
		image = "panel/panel_part_05.png",
		[1] = {0,0,96,96},
	},
	MT = {
		image = "panel/panel_part_01.png",
		[1] = {0,0,48,48},
	},
	RT = {
		image = "panel/panel_part_06.png",
		[1] = {0,0,96,96},
	},
	LC = {
		image = "panel/panel_part_03.png",
		[1] = {0,0,48,48},
	},
	RC = {
		image = "panel/panel_part_04.png",
		[1] = {0,0,48,48},
	},
	LB = {
		image = "panel/panel_part_08.png",
		[1] = {0,0,96,96},
	},
	MB = {
		image = "panel/panel_part_02.png",
		[1] = {0,0,48,48},
	},
	RB = {
		image = "panel/panel_part_07.png",
		[1] = {0,0,96,96},
	},
}

_tab_model[11091] = {
	name = "UI:panel_part_09",
	image = "panel/panel_part_09.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,16},
	},
}

_tab_model[11092] = {
	name = "UI:score",
	image = "ui/score.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11093] = {
	name = "ICON_world/level_swbh",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_6",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11094] = {
	name = "UI:choose_level",
	image = "ui/choose_level.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11095] = {
	name = "ICON:outtown",
	image = "ui/outtown.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11096] = {
	name = "UI:GIFT",
	image = "ui/gift.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11097] = {
	name = "ICON_world/level_wczzx",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_wczzx",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11098] = {
	name = "ICON_world/level_xpzz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_xpzz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11099] = {
	name = "arrow_bottom",
	image = "ui/map_arrow_04.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11100] = {
	name = "map_arrow_02",
	image = "ui/map_arrow_02.png",
	animation = {
		"UL",
		"UR",
		"U",
		"RD",
		"LD",
		"RLD",
	},
	UL = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
	UR = {
		[1] = {0,0,64,64},
	},
	U = {
		roll=90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	RD = {
		roll=-90,
		[1] = {0,0,64,64},
	},
	LD = {
		roll=-90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	RLD = {
		roll=-150,
		[1] = {0,0,64,64},
	},
}

_tab_model[11101] = {
	name = "map_arrow_01",
	image = "ui/map_arrow_01.png",
	animation = {
		"L",
		"R",
		"U",
		"D",
		"DR",
		"LDR",
		"LFY",
	},
	L = {
		flipX = 1,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	R = {
		
		[1] = {0,0,64,64},
	},
	U = {
		roll=90,
		[1] = {0,0,64,64},
	},
	D = {
		roll=-90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	DR = {
		flipY = 1,
		[1] = {0,0,64,64},
	},

	LDR = {
		roll=-45,
		flipY = 1,
		[1] = {0,0,64,64},
	},

	LFY = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
}

_tab_model[11102] = {
	name = "ICON_world/level_yxwd",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_yxwd",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11103] = {
	name = "ICON_world/level_lcfj",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lcfj",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11104] = {
	name = "ICON_world/level_hmzl",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_hmzl",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}


_tab_model[11105] = {
	name = "UI:playerbag_bg",
	image = "ui/deposit.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11106] = {
	name = "UI:difficulty",
	image = "ui/difficulty.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11107] = {
	name = "UI:difficulty_slot",
	image = "ui/difficulty_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11108] = {
	name = "UI:add_exAttrPoint",
	image = "ui/add_exattrp.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,18,18},
	},
}

_tab_model[11109] = {
	name = "UI:player_bag_btn_open",
	image = "ui/player_locker_open.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11110] = {
	name = "UI:item_res_leather",
	image = "ui/item_res_leather.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}
_tab_model[11111] = {
	name = "UI:item_res_metal",
	image = "ui/item_res_metal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}
_tab_model[11112] = {
	name = "UI:item_res_gem",
	image = "ui/item_res_gem.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,40,40},
	},
}

_tab_model[11113] = {
	name = "UI:player_bag_btn_close",
	image = "ui/player_locker.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[1114] = {
	name = "UI:item_forge",
	image = "ui/item_forge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

--[[
_tab_model[11115] = {
	name = "UI:item_forge_undo",
	image = "ui/item_forge_undo.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}
]]

_tab_model[11116] = {
	name = "UI:hero_skillbook",
	image = "ui/hero_skillbook.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,224,530},
	},
}

_tab_model[11117] = {
	name = "UI:army_tray",
	image = "ui/army_tray.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11118] = {
	name = "UI:skillbook_close",
	image = "ui/skillbook.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11119] = {
	name = "UI:skillbook_open",
	image = "ui/skillbook_open.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11120] = {
	name = "UI:skill_back_01",
	image = "ui/skill_back_01.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11121] = {
	name = "UI:skill_back_02",
	image = "misc/skill_back_02.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}


_tab_model[11122] = {
	name = "UI:PANEL_CARD_02",
	image = "panel/panel_card_02.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,140,180},
	},
}

_tab_model[11123] = {
	name = "UI:PANEL_CARD_03",
	image = "panel/panel_card_03.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,140,180},
	},
}

_tab_model[11124] = {
	name = "UI:PANEL_CARD_04",
	image = "panel/panel_card_04.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,140,180},
	},
}

_tab_model[11125] = {
	name = "UI:diamond_slot",
	image = "misc/diamond_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}

_tab_model[11126] = {
	name = "UI:diamond",
	image = "misc/diamond.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}

_tab_model[11127] = {
	name = "UI:ach_king_slot",
	image = "ui/ach_king_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11128] = {
	name = "UI:ach_king",
	image = "ui/ach_king.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11129] = {
	name = "UI:discount_02_en",
	image = "misc/discount_02_en.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,72},
	},
}


_tab_model[11130] = {
	name = "ICON_world/level_zlzy",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_zlzy",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11131] = {
	name = "UI:button_medal",
	image = "ui/button_medal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,134,46},
	},
}

_tab_model[11132] = {
	name = "UI:chapter_01",
	image = "misc/chapter_01.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11133] = {
	name = "UI:MADEL_BANNER",
	image = "ui/medal_banner.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,300,60},
	},
}

_tab_model[11134] = {
	name = "UI:talent",
	image = "ui/talent.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11135] = {
	name = "UI:talent_slot",
	image = "ui/talent_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11136] = {
	name = "ICON_world/level_xsnd",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_xsnd",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11137] = {
	name = "ICON_world/level_hj12g",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_hj12g",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11138] = {
	name = "UI:map_collection",
	image = "misc/map_collection.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,160},
	},
}

_tab_model[11139] = {
	name = "UI:skill_point",
	image = "ui/skill_point.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,42,42},
	},
}

_tab_model[11140] = {
	name = "UI:skill_point_slot",
	image = "ui/skill_point_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,42,42},
	},
}

_tab_model[11141] = {
	name = "UI:portrait_mask",
	image = "misc/portrait_mask.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,118},
	},
}

_tab_model[11142] = {
	name = "UI:skillup",
	image = "ui/skillup.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,70},
	},
}

_tab_model[11143] = {
	name = "ICON_world/level_xlslc",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_mjsl",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11144] = {
	name = "UI:button_gift",
	image = "ui/button_gift.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,134,46},
	},
}

_tab_model[11145] = {
	name = "UI:giftkey",
	image = "ui/giftkey.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}


_tab_model[11146] = {
	name = "ICON_world/level_tqt",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tqt",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11147] = {
	name = "ICON_world/level_acsj",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tqt_01",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}
_tab_model[11148] = {
	name = "ICON_world/level_mrxj",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tqt_02",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}
_tab_model[11149] = {
	name = "ICON_world/level_qf",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tqt_03",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}
_tab_model[11150] = {
	name = "ICON_world/level_qxlz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tqt_04",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11151] = {
	name = "UI:button_talent",
	image = "ui/button_talent.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,134,46},
	},
}

_tab_model[11153] = {
	name = "UI:tactic_card_1",
	image = "panel/tactic_card_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}

_tab_model[11154] = {
	name = "UI:tactic_card_2",
	image = "panel/tactic_card_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}

_tab_model[11155] = {
	name = "UI:tactic_card_3",
	image = "panel/tactic_card_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}

_tab_model[11156] = {
	name = "UI:tactic_card_4",
	image = "panel/tactic_card_4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}

--[[
_tab_model[11157] = {
	name = "UI:tactic_slot",
	image = "panel/tactic_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}
]]

_tab_model[11158] = {
	name = "UI:button_resumeR",
	image = "ui/button_resume.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11159] = {
	name = "UI:button_resumeL",
	image = "ui/button_resume.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,48,48},
	},
}

_tab_model[11160] = {
	name = "UI:card2score",
	image = "ui/card2score.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,60},
	},
}


_tab_model[11161] = {
	name = "ICON_world/level_lbwz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lbwz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11162] = {
	name = "ICON_world/level_lvbu1",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lvbu1",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11163] = {
	name = "ICON_world/level_lvbu2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lvbu2",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11164] = {
	name = "ICON_world/level_lvbu3",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lvbu3",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11165] = {
	name = "ICON_world/level_lvbu4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_lvbu4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11166] = {
	name = "UI:card_forge",
	image = "panel/card_forge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,795,274},
	},
}

_tab_model[11167] = {
	name = "UI:vip1",
	image = "ui/vip_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11168] = {
	name = "UI:vip2",
	image = "ui/vip_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11169] = {
	name = "UI:vip3",
	image = "ui/vip_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11170] = {
	name = "UI:vip4",
	image = "ui/vip_4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11171] = {
	name = "UI:vip5",
	image = "ui/vip_5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11172] = {
	name = "UI:vip6",
	image = "ui/vip_6.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11173] = {
	name = "UI:vip7",
	image = "ui/vip_7.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11174] = {
	name = "UI:button_vip",
	image = "ui/button_vip.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,134,46},
	},
}

_tab_model[11175] = {
	name = "ICON_world/level_scs",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_scs",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11176] = {
	name = "ICON_world/level_scs1",
	image = "misc/level_wanted.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,92,100},
	},
}

_tab_model[11177] = {
	name = "ICON_world/level_scs2",
	image = "misc/level_wanted.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,92,100},
	},
}

_tab_model[11178] = {
	name = "ICON_world/level_scs3",
	image = "misc/level_wanted.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,92,100},
	},
}

_tab_model[11179] = {
	name = "ICON_world/level_scs4",
	image = "misc/level_wanted.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,92,100},
	},
}


_tab_model[11180] = {
	name = "UI:inputGUID",
	image = "misc/win_back.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,32},
	},
}


_tab_model[11181] = {
	name = "UI:card_back",
	image = "panel/card_back.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,150},
	},
}


_tab_model[11182] = {
	name = "UI:card_select_back",
	image = "misc/card_select_back.png",
	animation = {
		"L",
		"M",
		"R",
		"normal",
	},
	L = {
		[1] = {0,0,124,128},
	},
	M = {
		[1] = {124,0,264,128},
	},
	R = {
		[1] = {388,0,124,128},
	},
	normal = {
		[1] = {0,0,512,128},
	},
}

_tab_model[11183] = {
	name = "UI:RedEquip",
	image = "ui/red_index.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}

_tab_model[11184] = {
	name = "ICON_world/level_ydcs",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ydcs",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11185] = {
	name = "ICON_world/level_ydcs1",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ydcs1",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11186] = {
	name = "ICON_world/level_ydcs2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ydcs2",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11187] = {
	name = "ICON_world/level_ydcs3",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ydcs3",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11188] = {
	name = "ICON_world/level_ydcs4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ydcs4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11189] = {
	name = "UI:forge",
	image = "ui/forge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11190] = {
	name = "UI:forge_red",
	image = "ui/forge_red.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11191] = {
	name = "UI:forge_red_icon",
	image = "ui/forge_red_icon.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}

_tab_model[11192] = {
	name = "UI:chapter_02",
	image = "misc/chapter_02.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,0,0},
	},
}


_tab_model[11193] = {
	name = "ICON_world/level_bmzw",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_bmzw",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11194] = {
	name = "ICON_world/level_qlzdq",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_qlzdq",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11195] = {
	name = "ICON_world/level_gcjy",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_gcjy",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11196] = {
	name = "ICON_world/level_tswl",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_tswl",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11197] = {
	name = "ICON_world/level_qxwc",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_qxwc",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11198] = {
	name = "ICON_world/level_gdzz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_gdzz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}


_tab_model[11199] = {
	name = "level_territory2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_territory",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11200] = {
	name = "UI:chapter_011",
	image = "misc/chapter_01_unlock.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,256},
	},
}


_tab_model[11201] = {
	name = "UI:discount_01_en",
	image = "misc/discount_01_en.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,72},
	},
}

_tab_model[11202] = {
	name = "UI:explosive",
	image = "ui/explosive.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,148,96},
	},
}

_tab_model[11203] = {
	name = "UI:level_back",
	image = "ui/level_back.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,120},
	},
}

_tab_model[11204] = {
	name = "ICON_world/level_jdhy",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_jdhy",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11205] = {
	name = "ICON_world/level_clfm",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_clfm",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11206] = {
	name = "ICON_world/level_unfinished",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_unfinished",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11207] = {
	name = "UI:DIAO_CHAO_GIFT",
	image = "icon/portrait/hero_diaochan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,245,256},
	},
}

_tab_model[11208] = {
	name = "UI:FRM_HEROINFO_FRAM_PHONE",
	image = "panel/panel_hero_m.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,736,540},
	},
}

_tab_model[11209] = {
	name = "UI:win_back",
	image = "misc/win_back.png",
	animation = {
		"L",
		"M",
		"R",
		"normal",
	},
	L = {
		[1] = {0,0,7,32},
	},
	M = {
		[1] = {7,0,50,32},
	},
	R = {
		[1] = {57,0,7,32},
	},
	normal = {
		[1] = {0,0,64,32},
	},
}


_tab_model[11210] = {
	name = "UI:chapter_01_en",
	image = "misc/chapter_01_en.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,256,64},
	},
}

_tab_model[11211] = {
	name = "UI:map_collection_en",
	image = "misc/map_collection_en.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,256,64},
	},
}

_tab_model[11212] = {
	name = "UI:panel_part_03",
	image = "panel/panel_part_03.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11213] = {
	name = "ICON_world/level_hswk",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_hswk",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}


_tab_model[11214] = {
	name = "UI:XIAO_QIAO_GIFT",
	image = "icon/portrait/hero_xiaoqiao.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 300, 300},
	},
}

_tab_model[11215] = {
	name = "UI:equip_item",
	image = "ui/equip_item.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,46},
	},
}

_tab_model[11216] = {
	name = "UI:expendable_item",
	image = "ui/expendable_item.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,46},
	},
}

_tab_model[11217] = {
	name = "ICON_world/level_xcjh",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_xcjh",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11218] = {
	name = "UI:guandu_map",
	image = "misc/guandu_map.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,256},
	},
}

_tab_model[11219] = {
	name = "UI:map_extend",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_6",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11220] = {
	name = "UI:town_mainmenu",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_test_6",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11221] = {
	name = "UI:menu_achievements",
	image = "misc/menu_achievements.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,280,172},
	},
}

_tab_model[11222] = {
	name = "UI:menu_cards",
	image = "misc/menu_cards.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,226,178},
	},
}

_tab_model[11223] = {
	name = "UI:menu_heroes",
	image = "misc/menu_heroes.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,194,148},
	},
}

_tab_model[11224] = {
	name = "UI:menu_rewards",
	image = "misc/menu_rewards.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,286,192},
	},
}

_tab_model[11225] = {
	name = "UI:menu_talents",
	image = "misc/menu_talents.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,66,216},
	},
}


_tab_model[11226] = {
	name = "UI:menu_vip",
	image = "misc/menu_vip.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,190,128},
	},
}

_tab_model[11227] = {
	name = "map_arrowX_02",
	image = "ui/map_arrow_02.png",
	modelmode = "DIRECTIONx8",
	animation = {
		"DIRECTION:1_stand",
		"DIRECTION:2_stand",
		"DIRECTION:3_stand",
		"DIRECTION:4_stand",
		"DIRECTION:5_stand",
		"DIRECTION:6_stand",
		"DIRECTION:7_stand",
		"DIRECTION:8_stand",
	},
	["DIRECTION:1_stand"] = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:2_stand"] = {
		[1] = {0,0,64,64},
	},
	["DIRECTION:3_stand"] = {
		roll=90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:4_stand"] = {
		roll=-90,
		[1] = {0,0,64,64},
	},
	["DIRECTION:5_stand"] = {
		roll=-90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:6_stand"] = {
		roll=-150,
		[1] = {0,0,64,64},
	},
	["DIRECTION:7_stand"] = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:8_stand"] = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
}

_tab_model[11228] = {
	name = "map_arrowX_01",
	image = "ui/map_arrow_01.png",
	modelmode = "DIRECTIONx8",
	animation = {
		"DIRECTION:1_stand",
		"DIRECTION:2_stand",
		"DIRECTION:3_stand",
		"DIRECTION:4_stand",
		"DIRECTION:5_stand",
		"DIRECTION:6_stand",
		"DIRECTION:7_stand",
		"DIRECTION:8_stand",
	},
	["DIRECTION:1_stand"] = {
		flipX = 1,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:2_stand"] = {
		
		[1] = {0,0,64,64},
	},
	["DIRECTION:3_stand"] = {
		roll=90,
		[1] = {0,0,64,64},
	},
	["DIRECTION:4_stand"] = {
		roll=-90,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:5_stand"] = {
		flipY = 1,
		[1] = {0,0,64,64},
	},

	["DIRECTION:6_stand"] = {
		roll=-45,
		flipY = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:7_stand"] = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
	["DIRECTION:8_stand"] = {
		flipX = 1,
		[1] = {0,0,64,64},
	},
}


_tab_model[11229] = {
	name = "UI:explosive02",
	image = "ui/explosive.png",
	animation = {
		"normal",
	},
	normal = {
		anchor = {0.5,-1},
		[1] = {0,0,148,96},
	},
}

_tab_model[11230] = {
	name = "UI:hot_item",
	image = "ui/hot_item.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,46},
	},
}

_tab_model[11231] = {
	name = "UI:IMG_TipBar",
	image = "misc/tipMinBG.png",
	animation = {
		"L",
		"M",
		"R",
	},
	L = {
		[1] = {0,0,16,82},
	},
	M = {
		[1] = {16,0,128,82},
	},
	R = {
		[1] = {144,0,16,82},
	},
}

_tab_model[11232] = {
	name = "ICON_world/level_nnj",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_nnj",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11233] = {
	name = "ICON_world/level_nnj1",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_nnj1",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11234] = {
	name = "ICON_world/level_nnj2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_nnj2",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11235] = {
	name = "ICON_world/level_nnj3",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_nnj3",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11236] = {
	name = "ICON_world/level_nnj4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_nnj4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11237] = {
	name = "UI:shopItemBG",
	image = "ui/shopItemBG.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,190},
	},
}
_tab_model[11238] = {
	name = "UI:shopItemBGBuy",
	image = "ui/shopItembgbuy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,92,44},
	},
}
_tab_model[11239] = {
	name = "UI:loseframe1",
	image = "misc/loseframe1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,86,86},
	},
}

_tab_model[11241] = {
	name = "UI:shopitemhot",
	image = "ui/shopitemhot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,44,38},
	},
}
_tab_model[11242] = {
	name = "UI:shopitemnew",
	image = "ui/shopitemnew.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,44,38},
	},
}
_tab_model[11243] = {
	name = "UI:shopitemoff",
	image = "ui/shopitemoff.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,44,38},
	},
}
_tab_model[11244] = {
	name = "UI:shopitemxg",
	image = "ui/shopitemxg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,14},
	},
}

--[[
_tab_model[11245] = {
	name = "UI:rank_tab",
	image = "ui/pvp/tab.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,770,50},
	},
}
]]

_tab_model[11246] = {
	name = "UI:PVPButBack",
	image = "ui/pvp/pvpbutback.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,106,62},
	},
}

_tab_model[11248] = {
	name = "UI:PVPTabBack1",
	image = "ui/pvp/pvptabback1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,68},
	},
}

--_tab_model[11249] = {
	--name = "UI:rank_xiao",
	--image = "ui/pvp/xiao.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,750,42},
	--},
--}

--_tab_model[11250] = {
	--name = "UI:PVPArmyBackground",
	--image = "ui/pvp/pvparmybackground.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,770,566},
	--},
--}

_tab_model[11252] = {
	name = "UI:rank_title",
	image = "ui/pvp/rank_title.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,706,44},
	},
}
_tab_model[11253] = {
	name = "UI:PVP2v2",
	image = "ui/pvp/pvp2v2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,110,32},
	},
}
_tab_model[11254] = {
	name = "UI:rank_bottom",
	image = "ui/pvp/rank_bottom.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,98,28},
	},
}
_tab_model[11255] = {
	name = "UI:PVPSelect",
	image = "ui/pvp/pvpselect.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,28,30},
	},
}

_tab_model[11256] = {
	name = "UI:wdpm",
	image = "ui/pvp/wdpm.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,82,22},
	},
}
_tab_model[11257] = {
	name = "UI:zdl",
	image = "ui/pvp/zdl.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,22},
	},
}
_tab_model[11258] = {
	name = "UI:PVPLion",
	image = "ui/pvp/pvplion.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,64},
	},
}

_tab_model[11260] = {
	name = "UI:sx",
	image = "ui/pvp/sx.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,2,34},
	},
}

--_tab_model[11261] = {
	--name = "UI:PVPHeroLock",
	--image = "ui/pvp/PVPHeroLock.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,130,160},
	--},
--}

--_tab_model[11262] = {
	--name = "UI:PVPArmsBut",
	--image = "ui/pvp/pvparmsbut.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}
--_tab_model[11263] = {
	--name = "UI:PVPHeroBut",
	--image = "ui/pvp/pvpherobut.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}
_tab_model[11264] = {
	name = "UI:PVPRankBut",
	image = "ui/pvp/pvprankbut.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,68},
	},
}
--_tab_model[11265] = {
	--name = "UI:PVPTacticsBut",
	--image = "ui/pvp/pvptacticsbut.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}
--_tab_model[11266] = {
	--name = "UI:PVPArmsBut1",
	--image = "ui/pvp/pvparmsbut1.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}
--_tab_model[11267] = {
	--name = "UI:PVPHeroBut1",
	--image = "ui/pvp/pvpherobut1.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}
_tab_model[11268] = {
	name = "UI:PVPRankBut1",
	image = "ui/pvp/pvprankbut1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}
--_tab_model[11269] = {
	--name = "UI:PVPTacticsBut1",
	--image = "ui/pvp/pvptacticsbut1.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,90,68},
	--},
--}

--_tab_model[11270] = {
	--name = "UI:PVPTacPageNum",
	--image = "ui/pvp/pvptacpagenum.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,38,114},
	--},
--}
--_tab_model[11271] = {
	--name = "UI:PVPTacPageUp",
	--image = "ui/pvp/pvptacpageup.png",
	--animation = {
		--"normal",
		--"down",
	--},
	--normal = {
		--[1] = {0,0,42,42},
	--},

	--down = {
		--flipY = 1,
		--[1] = {0,0,42,42},
	--},
--}

_tab_model[11272] = {
	name = "UI:ConfimBtn1",
	image = "misc/confimbtn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,82,44},
	},
}
_tab_model[11273] = {
	name = "UI:ConfimBtn2",
	image = "misc/ConfimBtn2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,82,48},
	},
}


_tab_model[11274] = {
	name = "UI:PVPMate2",
	image = "ui/pvp/pvpmate2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,136,40},
	},
}
_tab_model[11275] = {
	name = "UI:PVPRecord",
	image = "ui/pvp/pvprecord.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,116,38},
	},
}

_tab_model[11276] = {
	name = "UI:slotBig",
	image = "ui/slotBig.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,84,84},
	},
}
_tab_model[11277] = {
	name = "UI:slotSmall",
	image = "ui/slotSmall.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}
_tab_model[11278] = {
	name = "UI:ButtonBack",
	image = "misc/buttonback.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,180,50},
	},
}
_tab_model[11279] = {
	name = "UI:hall",
	image = "ui/hall.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}
_tab_model[11280] = {
	name = "UI:ButtonBack2",
	image = "misc/buttonback2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,134,46},
	},
}

_tab_model[11281] = {
	name = "UI:maxbutton",
	image = "ui/maxbutton.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,82,44},
	},
}
_tab_model[11282] = {
	name = "UI:confirmbut",
	image = "ui/confirmbut.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,82,44},
	},
}
_tab_model[11283] =
{
	name = "UI:pvpprivatesb1",
	image = "ui/pvp/pvpprivatesb1.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}

--[[
_tab_model[11284] =
{
	name = "UI:pvpprivatesb2",
	image = "ui/pvp/pvpprivatesb2.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}
]]

--[[
_tab_model[11285] =
{
	name = "UI:pvpprivatesb3",
	image = "ui/pvp/pvpprivatesb3.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}
]]

_tab_model[11286] =
{
	name = "UI:pvpprivatesb4",
	image = "ui/pvp/pvpprivatesb4.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}

_tab_model[11288] = {
	name = "UI:PVPClose",
	image = "ui/pvp/pvpclose.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,42,40},
	},
}

_tab_model[11289] = {
	name = "UI:PVPMyMark",
	image = "ui/pvp/pvpmymark.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,668,408},
	},
}

_tab_model[11290] = {
	name = "UI:pvpmainwarl",
	image = "ui/pvp/pvpmainwarl.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}
_tab_model[11291] = {
	name = "UI:pvpmainwar",
	image = "ui/pvp/pvpmainwar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}
_tab_model[11292] = {
	name = "UI:pvpcj",
	image = "ui/pvp/pvpcj.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}
_tab_model[11293] = {
	name = "UI:pvpcja",
	image = "ui/pvp/pvpcja.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}
_tab_model[11294] = {
	name = "UI:pvpbxbing",
	image = "ui/pvp/pvpbxbing.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,88,42},
	},
}
_tab_model[11295] = {
	name = "UI:pvpbxbingan",
	image = "ui/pvp/pvpbxbingan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,78,38},
	},
}
_tab_model[11296] = {
	name = "UI:pvpbxhero",
	image = "ui/pvp/pvpbxhero.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,88,42},
	},
}
_tab_model[11297] = {
	name = "UI:pvpbxheroan",
	image = "ui/pvp/pvpbxheroan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,78,38},
	},
}
_tab_model[11298] = {
	name = "UI:pvpbxjn",
	image = "ui/pvp/pvpbxjn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,88,42},
	},
}
_tab_model[11299] = {
	name = "UI:pvpbxjnan",
	image = "ui/pvp/pvpbxjnan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,78,38},
	},
}
--_tab_model[11300] = {
	--name = "UI:pvpmainx",
	--image = "ui/pvp/pvpmainx.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,770,566},
	--},
--}
_tab_model[11301] = {
	name = "UI:pvpexptt",
	image = "ui/pvp/pvpexptt.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,18},
	},
}
--_tab_model[11302] = {
--	name = "UI:pvpbloodeenter",
--	image = "ui/pvp/pvpbloodeenter.png",
--	animation = {
--		"normal",
--	},
--	normal = {
--		[1] = {0,0,130,24},
--	},
--}
--_tab_model[11303] = {
	--name = "UI:pvpcxbb",
	--image = "ui/pvp/pvpcxbb.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,76,28},
	--},
--}
--_tab_model[11304] = {
	--name = "UI:pvpcxbba",
	--image = "ui/pvp/pvpcxbba.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,76,28},
	--},
--}
_tab_model[11305] = {
	name = "UI:pvpenter1",
	image = "ui/pvp/pvpenter1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,116,22},
	},
}
--_tab_model[11306] = {
	--name = "UI:pvpenter2",
	--image = "ui/pvp/pvpenter2.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,204,28},
	--},
--}

--_tab_model[11307] = {
	--name = "UI:pvpcutline",
	--image = "ui/pvp/pvpcutline.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,8,316},
	--},
--}

--_tab_model[11308] = {
	--name = "UI:pvpxyy",
	--image = "ui/pvp/pvpxyy.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,408,30},
	--},
--}
_tab_model[11309] = {
	name = "UI:banner",
	image = "ui/pvp/banner.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,102,124},
	},
}
_tab_model[11310] = {
	name = "UI:pvpenterbloode",
	image = "ui/pvp/pvpenterbloode.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,18},
	},
}

--_tab_model[11311] = {
--	name = "UI:pvpselbac2",
--	image = "ui/pvp/pvpselbac2.png",
--	animation = {
--		"normal",
--	},
--	normal = {
--		[1] = {0,0,120,146},
--	},
--}

_tab_model[11313] = {
	name = "ICON_world/level_rsdyz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_rsdyz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11314] = {
	name = "ICON_world/level_qyg",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_qyg",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11315] = {
	name = "UI:rank_n_1",
	image = "ui/rank_1st.png",
	animation = {
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 24},
	},
}

_tab_model[11316] = {
	name = "UI:rank_n_2",
	image = "ui/rank_2nd.png",
	animation = {
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 24},
	},
}

_tab_model[11317] = {
	name = "UI:rank_n_3",
	image = "ui/rank_3rd.png",
	animation = {
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 24},
	},
}

_tab_model[11318] = {
	name = "UI:rank_down",
	image = "ui/pvp/rank_down.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,8,22},
	},
}
_tab_model[11319] = {
	name = "UI:pvptlbackf",
	image = "ui/pvp/pvptlbackf.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,52,52},
	},
}

_tab_model[11320] = {
	name = "UI:pvptoken",
	image = "ui/pvp/pvptoken.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,28,34},
	},
}

_tab_model[11321] = {
	name = "UI:button_illustration",
	image = "ui/red_eq_show.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,98,48},
	},
}

--[[
_tab_model[11322] = {
	name = "UI:pvproombg",
	image = "misc/pvproombg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,956,574},
	},
}
]]

_tab_model[11323] = {
	name = "UI:pvproom1",
	image = "misc/pvp/pvproom1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,236,146},
	},
}

_tab_model[11324] = {
	name = "UI:pvproom2",
	image = "misc/pvp/pvproom2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,236,146},
	},
}

_tab_model[11325] = {
	name = "UI:rank_up",
	image = "ui/pvp/rank_up.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,8,22},
	},
}

_tab_model[11326] = {
	name = "UI:rsdyz_point",
	image = "ui/rsdyz_point.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,42,36},
	},
}

_tab_model[11327] = {
	name = "UI:army_tray2",
	image = "ui/pvp/standslot2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,64},
	},
}


--关卡文字描述图
--_tab_model[11331] = {
	--name = "UI:zz",
	--image = "ui/pvp/zz.png",
	--animation = {
		--"normal",
		--"selectlevel",
		--"netbattle",
		--"rsyz",
	--},
	--normal = {
		--[1] = {0,0,134,90},
	--},

	--selectlevel = {
		--[1] = {0,0,134,30},
	--},
	--netbattle = {
		--[1] = {0,30,134,30},
	--},
	--rsyz = {
		--[1] = {0,60,134,30},
	--},
--}

--
_tab_model[11332] = {
	name = "UI:Record",
	image = "ui/pvp/record.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}

_tab_model[11333] = {
	name = "UI:zjexp",
	image = "ui/pvp/zjexp.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,294,104},
	},
}

_tab_model[11334] = {
	name = "UI:cjkk",
	image = "ui/pvp/cjkk.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,220,84},
	},
}

_tab_model[11335] = {
	name = "UI:cjbt",
	image = "ui/pvp/cjbt.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,24},
	},
}

_tab_model[11336] = {
	name = "UI:zjdb",
	image = "ui/pvp/zjdb.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,244,228},
	},
}

-- PVP 等级数字
_tab_model[11337] = {
	name = "UI:pvp_num_1",
	image = "ui/pvp/pvp_num_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,16,30},
	},
}
_tab_model[11338] = {
	name = "UI:pvp_num_2",
	image = "ui/pvp/pvp_num_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}
_tab_model[11339] = {
	name = "UI:pvp_num_3",
	image = "ui/pvp/pvp_num_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,46,30},
	},
}

-- PVP 等级底板
-- 木
_tab_model[11340] = {
	name = "UI:pvp_wood",
	image = "ui/pvp/wood.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 铁
_tab_model[11341] = {
	name = "UI:pvp_iron",
	image = "ui/pvp/iron.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 铜
_tab_model[11342] = {
	name = "UI:pvp_copper",
	image = "ui/pvp/copper.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 银
_tab_model[11343] = {
	name = "UI:pvp_silver",
	image = "ui/pvp/silver.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 金
_tab_model[11344] = {
	name = "UI:pvp_gold",
	image = "ui/pvp/gold.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 水晶
_tab_model[11345] = {
	name = "UI:pvp_crystal",
	image = "ui/pvp/crystal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}

-- 木 1-3
_tab_model[11346] = {
	name = "UI:pvp_wood_1",
	image = "ui/pvp/wood_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}

_tab_model[11347] = {
	name = "UI:pvp_wood_2",
	image = "ui/pvp/wood_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}

_tab_model[11348] = {
	name = "UI:pvp_wood_3",
	image = "ui/pvp/wood_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
-- 铁 1-3
_tab_model[11349] = {
	name = "UI:pvp_iron_1",
	image = "ui/pvp/iron_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}

_tab_model[11350] = {
	name = "UI:pvp_iron_2",
	image = "ui/pvp/iron_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}

_tab_model[11351] = {
	name = "UI:pvp_iron_3",
	image = "ui/pvp/iron_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
-- 铜 1-3
_tab_model[11352] = {
	name = "UI:pvp_copper_1",
	image = "ui/pvp/copper_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11353] = {
	name = "UI:pvp_copper_2",
	image = "ui/pvp/copper_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11354] = {
	name = "UI:pvp_copper_3",
	image = "ui/pvp/copper_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
-- 银 1-3
_tab_model[11355] = {
	name = "UI:pvp_silver_1",
	image = "ui/pvp/silver_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11356] = {
	name = "UI:pvp_silver_2",
	image = "ui/pvp/silver_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11357] = {
	name = "UI:pvp_silver_3",
	image = "ui/pvp/silver_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
-- 金 1-3
_tab_model[11358] = {
	name = "UI:pvp_gold_1",
	image = "ui/pvp/gold_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11359] = {
	name = "UI:pvp_gold_2",
	image = "ui/pvp/gold_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
_tab_model[11360] = {
	name = "UI:pvp_gold_3",
	image = "ui/pvp/gold_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}
-- 水晶 1
_tab_model[11361] = {
	name = "UI:pvp_crystal_1",
	image = "ui/pvp/crystal_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,38},
	},
}

_tab_model[11362] = {
	name = "UI:shopitembg2",
	image = "ui/shopitembg2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,190},
	},
}

_tab_model[11363] = {
	name = "UI:stone_item",
	image = "ui/stone_item.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,98,48},
	},
}

_tab_model[11364] = {
	name = "UI:horn_open",
	image = "ui/horn_open.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11365] = {
	name = "UI:horn_close",
	image = "ui/horn_close.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11366] = {
	name = "UI:horn_open",
	image = "ui/horn_open.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11367] = {
	name = "UI:horn_close",
	image = "ui/horn_close.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11368] = {
	name = "UI:pvp_exp",
	image = "ui/pvp/pvp_exp.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,36,32},
	},
}

_tab_model[11369] = {
	name = "UI:pvp_elo",
	image = "ui/pvp/pvp_elo.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,36,32},
	},
}

_tab_model[11370] = {
	name = "UI:tip",
	image = "ui/tip.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

_tab_model[11371] = {
	name = "UI:sx1",
	image = "ui/pvp/sx1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,6,18},
	},
}

_tab_model[11372] = {
	name = "UI:wk",
	image = "ui/wk.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,306,68},
	},
}

--万用底纹2
_tab_model[11373] = {
	name = "UI:selectbg2",
	image = "misc/selectbg2.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0,0,112,32},
	},

	L = {
		[1] = {0,0,50,32},
	},
	M = {
		[1] = {50,0,12,32},
	},
	R = {
		[1] = {62,0,112,32},
	},
}

--万用底纹3
_tab_model[11374] = {
	name = "UI:selectbg3",
	image = "misc/selectbg3.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0,0,112,32},
	},

	L = {
		[1] = {0,0,50,32},
	},
	M = {
		[1] = {50,0,12,32},
	},
	R = {
		[1] = {62,0,112,32},
	},
}

_tab_model[11375] = {
	name = "UI:pvpplus",
	image = "ui/pvp/pvpplus.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,24,24},
	},
}

_tab_model[11376] = {
	name = "UI:ok",
	image = "misc/ok.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11377] = {
	name = "UI:close",
	image = "misc/close.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11378] = {
	name = "UI:ico_tactics_legend",
	image = "ui/ico_tactics_legend.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11379] = {
	name = "UI:ico_tactics_machine",
	image = "ui/ico_tactics_machine.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11380] = {
	name = "UI:ico_tactics_rider",
	image = "ui/ico_tactics_rider.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}


_tab_model[11381] = {
	name = "UI:ico_tactics_shooter",
	image = "ui/ico_tactics_shooter.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11382] = {
	name = "UI:ico_tactics_wizard",
	image = "ui/ico_tactics_wizard.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11383] = {
	name = "UI:ico_tactics_other",
	image = "ui/ico_tactics_other.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11384] = {
	name = "UI:ico_tactics_fighter",
	image = "ui/ico_tactics_fighter.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,30},
	},
}

_tab_model[11385] = {
	name = "UI:pvp_solt",
	image = "ui/pvp/pvp_solt.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,40,40},
	},
}

_tab_model[11386] = {
	name = "UI:vip8",
	image = "ui/vip_8.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[11387] = {
	name = "UI:BTN_GetHeroCard",
	image = "ui/herocard.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,34,34},
	},
}

_tab_model[11388] = {
	name = "UI:skillup2",
	image = "ui/skillup2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,86,82},
	},
}

_tab_model[11389] = {
	name = "UI:QuestBG",
	image = "ui/pvp/quest_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,744,128},
	},
}

_tab_model[11390] = {
	name = "UI:QuestTipBG1",
	image = "ui/pvp/quest_tipbg1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,226,34},
	},
}

_tab_model[11391] = {
	name = "UI:QuestTipBG2",
	image = "ui/pvp/quest_tipbg2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,226,34},
	},
}

_tab_model[11392] = {
	name = "UI:QuestTipBGLR",
	image = "ui/pvp/quest_tip_border.png",
	animation = {
		"normal",
		"L",
		"R",
	},
	normal = {
		[1] = {0,0,26,32},
	},
	L = {
		[1] = {0,0,26,32},
	},
	R = {
		flipX = 1,
		[1] = {0,0,26,32},
	},
}

_tab_model[11393] = {
	name = "UI:button_tiny",
	image = "misc/buttontiny.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,38},
	},
}

_tab_model[11394] = {
	name = "UI:RSDYZ_low_bar",
	image = "ui/pvp/lowbar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,74,24},
	},
}

_tab_model[11395] = {
	name = "UI:RSDYZ_high_bar",
	image = "ui/highbar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,74,24},
	},
}

_tab_model[11396] = {
	name = "UI:RSDYZ_top1",
	image = "ui/pvp/top1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,44},
	},
}

_tab_model[11397] = {
	name = "UI:RSDYZ_top2",
	image = "ui/pvp/top2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,44},
	},
}

_tab_model[11398] = {
	name = "UI:RSDYZ_top3",
	image = "ui/pvp/top3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,44},
	},
}

_tab_model[11399] = {
	name = "UI:RSDYZ_top4",
	image = "ui/pvp/top4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,44},
	},
}

_tab_model[11400] = {
	name = "UI:QuestTipBGLR2",
	image = "ui/pvp/quest_tip_border2.png",
	animation = {
		"normal",
		"L",
		"R",
	},
	normal = {
		[1] = {0,0,16,16},
	},
	L = {
		[1] = {0,0,16,16},
	},
	R = {
		flipX = 1,
		[1] = {0,0,16,16},
	},
}

_tab_model[11401] = {
	name = "UI:RSDYZ_exp",
	image = "ui/pvp/exp.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,17,12},
	},
}

_tab_model[11402] = {
	name = "UI:NewKuang",
	image = "ui/kuang.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,86,86},
	},
}

_tab_model[11403] = {
	name = "UI:shift_m",
	image = "misc/shift_m.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11404] = {
	name = "UI:tipfrm",
	image = "misc/tipfrm.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,126,90},
	},
}

_tab_model[11405] = {
	name = "UI:ExpBG",
	image = "ui/pvp/expbg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,68,10},
	},
}

_tab_model[11406] = {
	name = "UI:elite_mode",
	image = "misc/elite_mode.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,52,54},
	},
}

--万用底纹(黑)
_tab_model[11407] = {
	name = "UI:selectbg",
	image = "misc/selectbg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,36},
	},
}

_tab_model[11408] = {
	name = "UI:chapter_02_en",
	image = "misc/chapter_02_en.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,256,64},
	},
}

_tab_model[11409] = {
	name = "UI:first_top_up_coins",
	image = "misc/firsttopup.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,64},
	},
}

_tab_model[11410] = {
	name = "UI:PVPReward",
	image = "ui/pvp/pvp_reward.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,90,70},
	},
}

_tab_model[11411] = {
	name = "ICON_world/level_yxcs",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_yxcs",
		pMode = 0,
		[1] = {0,0,118,126,1},
	},
}


_tab_model[11412] = {
	name = "ICON_world/level_zhhm",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_zhhm",
		pMode = 0,
		[1] = {0,0,118,126,1},
	},
}

_tab_model[11413] = {
	name = "ICON_world/level_qlz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_qlz",
		pMode = 0,
		[1] = {0,0,118,126,1},
	},
}

_tab_model[11414] = {
	name = "UI:item_slot",
	image = "ui/item_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

_tab_model[11415] = {
	name = "UI:item_slot_big",
	image = "ui/item_slot_big.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,146,148},
	},
}

_tab_model[11416] = {
	name = "UI:item_slot_get",
	image = "misc/item_slot_get.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,68},
	},
}

_tab_model[11417] = {
	name = "UI:31c",
	image = "misc/31c.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,150},
	},
}

_tab_model[11418] = {
	name = "UI:52c",
	image = "misc/52c.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,150},
	},
}

_tab_model[11419] = {
	name = "UI:105c",
	image = "misc/105c.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,150},
	},
}

_tab_model[11420] = {
	name = "UI:CloudFly1",
	image = "misc/cloud_1.png",
	motion = {{2048,0,200},{-880,0,0}},
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,880,206},
	},
}

_tab_model[11421] = {
	name = "UI:CloudFly2",
	image = "misc/cloud_2.png",
	motion = {{1025,0,180},{-380-1024,0,0}},
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,380,154},
	},
}

_tab_model[11422] = {
	name = "UI:herocardfrm",
	image = "panel/herocardfrm.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,884,558},
	},
}


_tab_model[11424] = {
	name = "UI:playerBagD",
	image = "ui/down.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,48},
	},
}

_tab_model[11425] = {
	name = "UI:delete_slot",
	image = "ui/delete_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,84,82},
	},
}

_tab_model[11426] = {
	name = "UI:forged_slot",
	image = "ui/forged_slot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,84,82},
	},
}

_tab_model[11427] = {
	name = "UI:delete_btn",
	image = "ui/delete_btn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,52},
	},
}

_tab_model[11428] = {
	name = "UI:forged_btn",
	image = "ui/forged_btn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,52},
	},
}

_tab_model[11429] = {
	name = "UI:fountain_btn",
	image = "ui/fountain_btn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,52},
	},
}

_tab_model[11430] = {
	name = "UI:fountain_bg",
	image = "ui/fountain_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,226,192},
	},
}

_tab_model[11431] = {
	name = "UI:sBar",
	image = "ui/hero_level_up_sbar.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,222,6},
	},
}

_tab_model[11432] = {
	name = "UI:title_line",
	image = "misc/title_line.png",
	animation = {
		"L",
		"M",
		"R",
		"normal",
	},
	L = {
		[1] = {0,0,133,6},
	},
	M = {
		[1] = {133,0,15,6},
	},
	R = {
		[1] = {148,0,134,6},
	},
	normal = {
		[1] = {0,0,282,6},
	},
}

_tab_model[11433] = {
	name = "ICON:bag_slot",
	image = "ui/bag_slot.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,128,64},
	},
}

--_tab_model[11434] = {
	--name = "UI:PVPFramBottom",
	--image = "ui/pvp/pvpfrmbottom.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,62,20},
	--},
--}

--_tab_model[11435] = {
	--name = "UI:PVPFramRight",
	--image = "ui/pvp/pvpfrmright.png",
	--animation = {
		--"normal",
	--},
	--normal = {
		--[1] = {0,0,8,576},
	--},
--}

_tab_model[11436] = {
	name = "ICON:WeekStar",
	image = "misc/weekstar.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,48,48},
	},
}

_tab_model[11437] = {
	name = "UI:PvpDownFloor",
	image = "ui/pvp/pvpdownfloor.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,748,140},
	},
}

_tab_model[11438] = {
	name = "UI:shopItemBG1",
	image = "ui/shopitembg1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,190},
	},
}
_tab_model[11439] = {
	name = "UI:ItemLine",
	image = "ui/itemline.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,148,6},
	},
}

_tab_model[11440] = {
	name = "UI:wifi",
	image = "ui/wifi.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,34,26},
	},
}


_tab_model[11450] = {
	name = "ICON_world/level_cbzz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_cbzz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}


--_tab_model[11451] = {
	--name = "ICON_world/level_cbzz2",
	--loadmode = "plist",
	--plist = "../map/world/map_icon.plist",
	--image = "../map/world/map_icon.png",
	--animation = {
		--"stand",
	--},
	--stand = {
		--anchor = {0.5,0.5},
		--interval = 1000,
		--pName = "level_cbzz2",
		--pMode = 0,
		--[1] = {0,0,120,120,1},
	--},
--}

--_tab_model[11452] = {
	--name = "ICON_world/level_cbzz3",
	--loadmode = "plist",
	--plist = "../map/world/map_icon.plist",
	--image = "../map/world/map_icon.png",
	--animation = {
		--"stand",
	--},
	--stand = {
		--anchor = {0.5,0.5},
		--interval = 1000,
		--pName = "level_cbzz3",
		--pMode = 0,
		--[1] = {0,0,120,120,1},
	--},
--}

--_tab_model[11453] = {
	--name = "ICON_world/level_cbzz4",
	--loadmode = "plist",
	--plist = "../map/world/map_icon.plist",
	--image = "../map/world/map_icon.png",
	--animation = {
		--"stand",
	--},
	--stand = {
		--anchor = {0.5,0.5},
		--interval = 1000,
		--pName = "level_cbzz4",
		--pMode = 0,
		--[1] = {0,0,120,120,1},
	--},
--}

_tab_model[11454] = {
	name = "UI:chibi_map",
	image = "misc/chibi_map.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,332,94},
	},
}

_tab_model[11455] = {
	name = "ICON_world/level_ccz",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11456] = {
	name = "ICON_world/level_ccz1",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz1",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11457] = {
	name = "ICON_world/level_ccz2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz2",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11458] = {
	name = "ICON_world/level_ccz3",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz3",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11459] = {
	name = "ICON_world/level_ccz4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11460] = {
	name = "UI:chibi_map2",
	image = "misc/chibi_map2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,256},
	},
}

_tab_model[11461] = {
	name = "UI:button_return2",
	image = "ui/button_return01.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,72,72},
	},
}

_tab_model[11462] = {
	name = "UI:free",
	image = "misc/free.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,128,72},
	},
}

_tab_model[11463] = {
	name = "UI:yule_map1",
	image = "misc/yule_map1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,78},
	},
}

_tab_model[11464] = {
	name = "UI:yule_map2",
	image = "misc/yule_map2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,78},
	},
}

_tab_model[11465] = {
	name = "UI:yule_map3",
	image = "misc/yule_map3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,78},
	},
}

_tab_model[11466] = {
	name = "UI:yule_map4",
	image = "misc/yule_map4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,272,78},
	},
}
---------------------------------------------------
_tab_model[11467] = {
	name = "UI:pvproomrank",
	image = "misc/pvproomrank.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,236,146},
	},
}
_tab_model[11468] = {
	name = "UI:pvpfirstleft",
	image = "misc/pvpfirst.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}
_tab_model[11469] = {
	name = "UI:pvpfirstright",
	image = "misc/pvpfirst.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,60,66},
	},
}
_tab_model[11470] = {
	name = "UI:pvpsecondleft",
	image = "misc/pvpsecond.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}
_tab_model[11471] = {
	name = "UI:pvpsecondright",
	image = "misc/pvpsecond.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,60,66},
	},
}
_tab_model[11472] = {
	name = "UI:pvpthirdleft",
	image = "misc/pvpthird.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,60,66},
	},
}
_tab_model[11473] = {
	name = "UI:pvpthirdright",
	image = "misc/pvpthird.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,60,66},
	},
}


_tab_model[11474] = {
	name = "ICON_world/level_ccz5",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz5",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11475] = {
	name = "ICON_world/level_ccz6",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz6",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11476] = {
	name = "ICON_world/level_ccz7",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz7",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11477] = {
	name = "ICON_world/level_ccz8",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz8",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}



_tab_model[11478] = {
	name = "ICON_world/level_cczx",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_cczx",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11479] = {
	name = "UI:direction",
	image = "misc/direction.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,44},
	},
}
_tab_model[11480] = {
	name = "UI:marketfloor",
	image = "misc/marketfloor.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,168,64},
	},
}
_tab_model[11481] = {
	name = "UI:marketfloorpolishL",
	image = "misc/marketfloorpolish.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,156,64},
	},
}
_tab_model[11482] = {
	name = "UI:marketfloorpolishR",
	image = "misc/marketfloorpolish.png",
	animation = {
		"normal",
	},
	normal = {
		flipX = 1,
		[1] = {0,0,156,64},
	},
}
_tab_model[11483] = {
	name = "UI:bargain",
	image = "misc/bargain.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,96,52},
	},
}
_tab_model[11484] = {
	name = "UI:maxnumbutton",
	image = "misc/maxnumbutton.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,76,76},
	},
}
_tab_model[11485] = {
	name = "UI:subone",
	image = "ui/subone.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,56},
	},
}
_tab_model[11486] = {
	name = "UI:addone",
	image = "ui/addone.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,56},
	},
}

_tab_model[11487] = {
	name = "ICON_world/level_ccz9",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_ccz8",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

_tab_model[11488] = {
	name = "UI:lightline",
	image = "ui/pvp/lightline.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,292,14},
	},
}
_tab_model[11489] = {
	name = "UI:lightstar",
	image = "ui/pvp/lightstar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,362,118},
	},
}
_tab_model[11490] = {
	name = "UI:losee",
	image = "ui/pvp/losee.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,238,132},
	},
}
_tab_model[11491] = {
	name = "UI:losej",
	image = "ui/pvp/losej.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,200,104},
	},
}
_tab_model[11492] = {
	name = "UI:wine",
	image = "ui/pvp/wine.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,202,118},
	},
}
_tab_model[11493] = {
	name = "UI:winj",
	image = "ui/pvp/winj.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,192,100},
	},
}

_tab_model[11494] = {
	name = "UI:td_mui_gold",
	image = "ui/pvp/td_mui_gold.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11495] = {
	name = "UI:td_mui_life",
	image = "misc/td_mui_life.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11496] = {
	name = "UI:td_mui_mana",
	image = "misc/td_mui_mana.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11497] = {
	name = "UI:td_mui_toptxtbg",
	image = "ui/pvp/td_mui_toptxtbg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,79,41},
	},
}

_tab_model[11498] = {
	name = "UI:td_mui_rdbar",
	image = "ui/pvp/td_mui_rdbar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,20},
	},
}

_tab_model[11499] = {
	name = "UI:td_mui_blbar",
	image = "ui/pvp/td_mui_blbar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,20},
	},
}

_tab_model[11500] = {
	name = "UI:td_sui_tactic_num_bg",
	image = "ui/pvp/td_sui_tactic_num_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,24,24},
	},
}

_tab_model[11501] = {
	name = "UI:td_sui_tactic_tTower",
	image = "ui/pvp/td_sui_tactic_tTower.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,24,24},
	},
}

_tab_model[11502] = {
	name = "UI:td_sui_tactic_tskill",
	image = "ui/pvp/td_sui_tactic_tskill.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,24,24},
	},
}

_tab_model[11503] = {
	name = "UI:td_sui_tactic_thero",
	image = "ui/pvp/td_sui_tactic_thero.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,24,24},
	},
}

_tab_model[11504] = {
	name = "UI:td_mui_speed1x",
	image = "ui/pvp/td_mui_speed1x.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11505] = {
	name = "UI:td_mui_speed2x",
	image = "ui/pvp/td_mui_speed2x.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11506] = {
	name = "UI:td_mui_pause",
	image = "ui/pvp/td_mui_pause.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

_tab_model[11507] = {
	name = "UI:td_sui_tactic_cost_bg",
	image = "ui/pvp/td_sui_tactic_cost_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,24},
	},
}

_tab_model[11508] = {
	name = "UI:td_cost_bg",
	image = "ui/pvp/dbx.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,46,24},
	},
}

_tab_model[11509] = {
	name = "UI:td_remould_bar_bottom",
	image = "ui/pvp/xsj.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,30,18},
	},
}

_tab_model[11510] = {
	name = "UI:BAR_remould_bg",
	image = "misc/bar_remould_bg.png",
	animation = {
		"normal",
		"L",
		"R",
		"M",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,22,140},
	},
	L = {
		interval = 1000,
		[1] = {0,0,22,140},
	},
	M = {
		interval = 1000,
		[1] = {22,0,18,140},
	},
	R = {
		interval = 1000,
		[1] = {40,0,22,140},
	},
}

_tab_model[11511] =
{
	name = "UI:cardbg0",
	image = "ui/pvp/cardbg0.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}

_tab_model[11512] =
{
	name = "UI:cardbg1",
	image = "ui/pvp/cardbg1.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,146,180},
	},
}

_tab_model[11513] =
{
	name = "UI:pvpmate2",
	image = "ui/pvp/pvpmate2.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0, 136, 40},
	},
}

--[[
_tab_model[11514] =
{
	name = "UI:frame_corner01",
	image = "misc/frame_corner01.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,512,512},
	},
}
]]

--[[
_tab_model[11515] =
{
	name = "UI:frame_corner02",
	image = "ui/pvp/frame_corner02.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 270, 360},
	},
}
]]

--属性图标：近战攻击力
_tab_model[11516] =
{
	name = "UI:Attr_Atk_Melee",
	image = "misc/Attr_Atk_Melee.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 45, 45},
	},
}

--属性图标：远程攻击力
_tab_model[11517] =
{
	name = "UI:Attr_Atk_Ranged",
	image = "misc/Attr_Atk_Ranged.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 80, 80},
	},
}

--[[
--属性图标：血量
_tab_model[11518] =
{
	name = "UI:Attr_Hp",
	image = "ui/pvp/Attr_Hp.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 38, 31},
	},
}
]]

--属性图标：物理防御
_tab_model[11519] =
{
	name = "UI:Attr_PDef",
	image = "misc/Attr_PDef.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 196, 201},
	},
}

--属性图标：法术防御
_tab_model[11520] =
{
	name = "UI:Attr_MDef",
	image = "misc/Attr_MDef.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 192, 174},
	},
}

--属性图标：移动速度
_tab_model[11521] =
{
	name = "UI:Attr_MoveSpeed",
	image = "misc/Attr_MoveSpeed.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 102, 115},
	},
}

--属性图标：攻击速度
_tab_model[11522] =
{
	name = "UI:Attr_AtkSpeed",
	image = "misc/Attr_AtkSpeed.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 65, 69},
	},
}

--属性图标：攻击范围
_tab_model[11523] =
{
	name = "UI:Attr_AtkRange",
	image = "misc/Attr_AtkRange.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 60, 66},
	},
}


--属性图标：暴击几率
_tab_model[11524] =
{
	name = "UI:Attr_CritRate",
	image = "ui/critRate.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--属性图标：暴击倍数
_tab_model[11525] =
{
	name = "UI:Attr_CritValue",
	image = "ui/critValue.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

_tab_model[11526] =
{
	name = "UI:buttonredV",
	image = "ui/pvp/buttonredV.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 36, 114},
	},
}

_tab_model[11527] =
{
	name = "UI:HeroStarBG",
	image = "ui/xdb.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 35, 34},
	},
}

_tab_model[11528] =
{
	name = "UI:SoulStoneFlag",
	image = "misc/debris.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 32, 32},
	},
}

_tab_model[11529] =
{
	name = "UI:SoulStoneBar",
	image = "misc/jdt.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 22, 14},
	},
}

_tab_model[11530] =
{
	name = "UI:SoulStoneBarBg",
	image = "ui/jdd.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 200, 20},
	},
}

_tab_model[11531] =
{
	name = "UI:pvpboss_bg0",
	image = "misc/pvpboss_bg0.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,236,146},
	},
}

--箭头
_tab_model[11532] =
{
	name = "UI:jiantou",
	image = "misc/jiantou.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,241,128},
	},
}

_tab_model[11533] =
{
	name = "UI:BeginBattleBg",
	image = "ui/pvp/btnBattleBg.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,222,161},
	},
}

_tab_model[11534] =
{
	name = "UI:BeginBattleTxt",
	image = "ui/pvp/btnBattleTxt.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,55,112},
	},
}

_tab_model[11535] =
{
	name = "UI:BeginBattleBgLight",
	image = "ui/pvp/btnBattleBgLight.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,214,215},
	},
}

_tab_model[11536] =
{
	name = "UI:AttrBg",
	image = "ui/attr_bg.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0,0,171,33},
	},
}

_tab_model[11537] =
{
	name = "UI:SoulStoneBar1",
	image = "misc/jdt1.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 55, 16},
	},
}

_tab_model[11538] =
{
	name = "UI:SoulStoneBarBg1",
	image = "ui/jdd1.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 114, 24},
	},
}

_tab_model[11539] =
{
	name = "UI:mainmenu_slot",
	image = "ui/mainmenu_slot.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 104, 104},
	},
}

--[[
_tab_model[11540] =
{
	name = "UI:lvUpBg",
	image = "ui/lvupBg.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 516,140},
	},
}
]]

_tab_model[11541] =
{
	name = "UI:lvUpCostBg",
	image = "ui/lvUpCostBg.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 129,95},
	},
}
----------------------------------------------------

--战术技能卡背景底板
_tab_model[11542] =
{
	name = "UI:Tactic_Background",
	image = "panel/TacticBackground.jpg",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 748, 544},
	},
}

--战术技能卡按钮
_tab_model[11543] =
{
	name = "UI:Tactic_Button",
	image = "ui/Tactic/Button.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 116, 48},
	},
}

--战术技能卡竖线
_tab_model[11544] =
{
	name = "UI:Tactic_LineV",
	image = "ui/Tactic/Line_V.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 12, 20},
	},
}

--战术技能卡横线
_tab_model[11545] =
{
	name = "UI:Tactic_LineH",
	image = "ui/Tactic/Line_H.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 10, 10},
	},
}

--战术技能卡三叉线
_tab_model[11546] =
{
	name = "UI:Tactic_LineT",
	image = "ui/Tactic/Line_T.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 30, 16},
	},
}

--战术技能卡拐弯线条
_tab_model[11547] =
{
	name = "UI:Tactic_LineRJT",
	image = "ui/Tactic/Line_RJT.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 24, 28},
	},
}

--战术技能卡箭头线
_tab_model[11548] =
{
	name = "UI:Tactic_LineJT",
	image = "ui/Tactic/Line_JT.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 24, 20},
	},
}

--战术技能卡选中框
_tab_model[11549] =
{
	name = "UI:Tactic_Selected",
	image = "ui/Tactic/Selected.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 70, 70},
	},
}

--[[
--战术技能卡文字介绍背景框
_tab_model[11550] =
{
	name = "UI:Tactic_IntroBG",
	image = "ui/Tactic/IntroBG.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 320, 130},
	},
}
]]

--战术技能卡分割线
_tab_model[11552] =
{
	name = "UI:Tactic_SeparateLine",
	image = "ui/Tactic/SeparateLine.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 364, 4},
	},
}

--战术技能卡右箭头
_tab_model[11553] =
{
	name = "UI:Tactic_RPointer",
	image = "ui/Tactic/RPointer.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 30, 20},
	},
}

--战术技能卡技能槽背景图
_tab_model[11554] =
{
	name = "UI:Tactic_SlotBG",
	image = "ui/Tactic/SlotBG.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 70, 14},
	},
}

--战术技能卡技能单个槽
_tab_model[11555] =
{
	name = "UI:Tactic_Slot",
	image = "ui/Tactic/Slot.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 12, 10},
	},
}

--战术技能卡-箭塔
_tab_model[11556] =
{
	name = "UI:Tactic_JianTa",
	image = "ui/Tactic/JianTa.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--战术技能卡-法术塔
_tab_model[11557] =
{
	name = "UI:Tactic_FaShuTa",
	image = "ui/Tactic/FaShuTa.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--战术技能卡-炮塔
_tab_model[11558] =
{
	name = "UI:Tactic_PaoTa",
	image = "ui/Tactic/PaoTa.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--战术技能卡-特殊
_tab_model[11559] =
{
	name = "UI:Tactic_TeShu",
	image = "ui/Tactic/TeShu.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--战术技能卡-战术
_tab_model[11560] =
{
	name = "UI:Tactic_ZhanShu",
	image = "ui/Tactic/ZhanShu.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--道具边框
_tab_model[11561] =
{
	name = "UI:ItemSlot",
	image = "ui/tipslot.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 68, 68},
	},
}

--技能边框
_tab_model[11562] =
{
	name = "UI:SkillSlot",
	image = "ui/skill_slot.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--战术技能卡边框
_tab_model[11563] =
{
	name = "UI:TacTicFrame",
	image = "ui/tactic_frame.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 72, 72},
	},
}

--道具合成分页按钮图标
_tab_model[11564] =
{
	name = "UI:ItemMergePageIcon",
	image = "ui/icon01_x2y2.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 62, 62},
	},
}

--道具洗炼分页按钮图标
_tab_model[11565] =
{
	name = "UI:ItemXiLianPageIcon",
	image = "ui/icon01_x2y9.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 62, 62},
	},
}

--提示分页按钮
_tab_model[11566] =
{
	name = "UI:PageBtn",
	image = "ui/PageBtn.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 34, 86},
	},
}

--英雄战术技能的背景图
_tab_model[11567] =
{
	name = "UI:TacticImgBG",
	image = "ui/TacticImgBG.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 74, 74},
	},
}

--蒙版图
_tab_model[11568] =
{
	name = "UI:MengBan256",
	image = "panel/MengBan256.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 256, 256},
	},
}

--任务叹号图
_tab_model[11569] =
{
	name = "UI:TaskTanHao",
	image = "ui/TaskTanHao.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 45, 45},
	},
}

--任务选中框图
_tab_model[11570] =
{
	name = "UI:TaskSelectBG",
	image = "ui/TaskSelectBG.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 121, 43},
	},
}

--GameCenter图标
_tab_model[11571] =
{
	name = "UI:gamecenter",
	image = "ui/gamecenter.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 48, 48},
	},
}

--鼎
_tab_model[11572] =
{
	name = "UI:ResolveSkillCard2",
	image = "ui/resolveskillcard2.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 90, 94},
	},
}


--成就的灰色图
_tab_model[11573] =
{
	name = "UI:MedalDarkImg",
	image = "ui/cjwc.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 126, 38},
	},
}

--boss血条
_tab_model[11574] = {
	name = "UI:IMG_ValueBarBoss",
	image = "misc/bosshp.png",
	animation =
	{
		"normal",
		"red",
		"yellow",
		"blue",
	},
	normal =
	{
		[1] = {18, 41, 85, 13},
	},
	red =
	{
		[1] = {18, 41, 85, 13},
	},
	yellow =
	{
		[1] = {18, 62, 85, 12},
	},
	blue =
	{
		[1] = {18, 82, 85, 12},
	},
}

--boss血条背景图
_tab_model[11575] = {
	name = "UI:BAR_ValueBarBoss_BG",
	image = "misc/bosshp.png",
	animation =
	{
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0, 0, 120, 30},
	},
	L = {
		[1] = {0, 0, 20, 30},
	},
	M = {
		[1] = {20, 0, 80, 30},
	},
	R = {
		[1] = {80, 0, 20, 30},
	},
}

--新购买的底图
_tab_model[11576] =
{
	name = "UI:Purchase_BG",
	image = "ui/Purchase_BG.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 200, 174},
	},
}

--新购买的购买按钮
_tab_model[11577] =
{
	name = "UI:Purchase_Button",
	image = "ui/Purchase_Button.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 186, 44},
	},
}

--充值档1图标
_tab_model[11578] =
{
	name = "UI:Purchase_1",
	image = "ui/Purchase_1.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档2图标
_tab_model[11579] =
{
	name = "UI:Purchase_2",
	image = "ui/Purchase_2.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档3图标
_tab_model[11580] =
{
	name = "UI:Purchase_3",
	image = "ui/Purchase_3.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档4图标
_tab_model[11581] =
{
	name = "UI:Purchase_4",
	image = "ui/Purchase_4.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档5图标
_tab_model[11582] =
{
	name = "UI:Purchase_5",
	image = "ui/Purchase_5.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档6图标
_tab_model[11583] =
{
	name = "UI:Purchase_6",
	image = "ui/Purchase_6.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 100, 100},
	},
}

--充值档7图标
_tab_model[11584] =
{
	name = "UI:Purchase_7",
	image = "ui/Purchase_4.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 110, 80},
	},
}

--充值档光效底板
_tab_model[11585] =
{
	name = "UI:PurchaseLight",
	image = "ui/Purchase_ex.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 116, 116},
	},
}

--输入密码框键盘底板
_tab_model[11586] =
{
	name = "UI:login_an",
	image = "ui/login_an.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 84, 62},
	},
}


--输入密码框键盘按钮背景
_tab_model[11587] =
{
	name = "UI:login_lk",
	image = "ui/login_lk.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 64, 64},
	},
}

--输入密码框键盘退格按钮
_tab_model[11588] =
{
	name = "UI:backspace",
	image = "ui/backspace.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 32, 18},
	},
}

--输入密码框键盘清除所有按钮
_tab_model[11589] =
{
	name = "UI:backspaceall",
	image = "ui/backspaceall.png",
	animation =
	{
		"normal",
	},
	normal =
	{
		[1] = {0, 0, 30, 34},
	},
}

--排行榜图标
_tab_model[11590] = {
	name = "UI:phb",
	image = "ui/phb.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,100,90},
	},
}

--禁用图标
_tab_model[11591] = {
	name = "UI:ban",
	image = "ui/ban.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}

--策马三国志推广图
_tab_model[11592] = {
	name = "UI:cmstg",
	image = "misc/addition/cmstg.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,512,256},
	},
}

--策马三国志推广图
_tab_model[11593] = {
	name = "UI:toapp",
	image = "misc/addition/annn.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,222,91},
	},
}

_tab_model[11594] = {
	name = "UI:TaskImage_Btn",
	image = "ui/taskimage_btn.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 40, 40},
	},
}

_tab_model[11595] = {
	name = "UI:Top_Up",
	image = "ui/top_up.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 64, 64},
	},
}

--活动分页图标
_tab_model[11596] = {
	name = "UI:Activity_Box",
	image = "ui/activity_box.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 72, 72},
	},
}

_tab_model[11597] = {
	name = "UI:ActivityImage_Btn",
	image = "ui/activityimage_btn.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 40, 40},
	},
}

_tab_model[11598] = {
	name = "UI:Discount",
	image = "ui/discount.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 64, 64},
	},
}

_tab_model[11599] = {
	name = "UI:Tastd2",
	image = "ui/tastd2.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {4, 4, 56, 56},
	},
}

_tab_model[11600] = {
	name = "UI:ICON_CEMA",
	image = "misc/addition/icon_cema.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 180, 180},
	},
}

--活动: 进行中
_tab_model[11601] = {
	name = "UI:ACTIVITY_OPENING",
	image = "ui/opening.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 78, 26},
	},
}

--活动: 即将开始
_tab_model[11602] = {
	name = "UI:ACTIVITY_TOBEOPEN",
	image = "ui/tobeopen.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0, 0, 78, 26},
	},
}

--pvp: 胜利
_tab_model[11603] = {
	name = "UI:Pvp_Win",
	image = "ui/pvp/sl.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,146,76},
	},
}

--[[
--pvp: 失败
_tab_model[11604] = {
	name = "UI:Pvp_Lose",
	image = "ui/pvp/sb.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,146,76},
	},
}
]]

--pvp: 平局
_tab_model[11605] = {
	name = "UI:Pvp_Draw",
	image = "ui/pvp/pj.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,146,86},
	},
}

--竞技场图标
_tab_model[11606] = {
	name = "UI:JJC",
	image = "ui/jjc.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,98,70},
	},
}

--竞技场面板
_tab_model[11607] = {
	name = "UI:TileFrmBack_PVP",
	image = "panel/panel_part_pvp_00.png",
	animation = {
		"normal",
		"LT",
		"MT",
		"RT",
		"LC",
		"RC",
		"LB",
		"MB",
		"RB",
	},
	normal = {
		[1] = {0, 0, 90, 90},
	},
	LT = {
		image = "panel/panel_part_pvp_05.png",
		[1] = {0,0,96,96},
	},
	MT = {
		image = "panel/panel_part_pvp_01.png",
		[1] = {0,0,48,48},
	},
	RT = {
		image = "panel/panel_part_pvp_06.png",
		[1] = {0,0,96,96},
	},
	LC = {
		image = "panel/panel_part_pvp_03.png",
		[1] = {0,0,48,48},
	},
	RC = {
		image = "panel/panel_part_pvp_04.png",
		[1] = {0,0,48,48},
	},
	LB = {
		image = "panel/panel_part_pvp_08.png",
		[1] = {0,0,96,96},
	},
	MB = {
		image = "panel/panel_part_pvp_02.png",
		[1] = {0,0,48,48},
	},
	RB = {
		image = "panel/panel_part_pvp_07.png",
		[1] = {0,0,96,96},
	},
}

--竞技场的"战"字
_tab_model[11608] = {
	name = "UI:FONT_ZHAN",
	image = "misc/pvp/font_zhan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11609] = {
	name = "UI:uitoken",
	image = "ui/pvptoken.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,28,34},
	},
}

--竞技场的"战"字2
_tab_model[11610] = {
	name = "UI:FONT_ZHAN2",
	image = "misc/pvp/FONT_ZHAN2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,50},
	},
}

--竞技场的装备图标
_tab_model[11611] = {
	name = "UI:UI_EQUIP",
	image = "ui/EQUIP.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,58},
	},
}

--pvp称号-破营
_tab_model[11612] = {
	name = "PVP:Designation_1",
	image = "misc/pvp/designation_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-兵圣
_tab_model[11613] = {
	name = "PVP:Designation_2",
	image = "misc/pvp/designation_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-夺粮
_tab_model[11614] = {
	name = "PVP:Designation_3",
	image = "misc/pvp/designation_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-推阵
_tab_model[11615] = {
	name = "PVP:Designation_4",
	image = "misc/pvp/designation_4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-神将
_tab_model[11616] = {
	name = "PVP:Designation_5",
	image = "misc/pvp/designation_5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp红色底纹
_tab_model[11617] = {
	name = "UI:PVP_RedCover",
	image = "ui/RedCover.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 122, 32},
	},
}

--pvp蓝色底纹
_tab_model[11618] = {
	name = "UI:PVP_BlueCover",
	image = "ui/BlueCover.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 122, 32},
	},
}

--pvp开宝箱-底图1
_tab_model[11619] = {
	name = "UI:ChestBag_1",
	image = "ui/ChestBag_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 364, 124},
	},
}

--pvp开宝箱-底图2
_tab_model[11620] = {
	name = "UI:ChestBag_2",
	image = "ui/ChestBag_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 178, 54},
	},
}

--pvp开宝箱-兑换
_tab_model[11621] = {
	name = "UI:Btn_DH",
	image = "ui/ChestBag_dh.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 90, 90},
	},
}

--pvp开宝箱-打开
_tab_model[11622] = {
	name = "UI:Btn_DK",
	image = "ui/ChestBag_dk.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 90, 90},
	},
}

--pvp开宝箱-领取
_tab_model[11623] = {
	name = "UI:Btn_LQ",
	image = "ui/ChestBag_lq.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 90, 90},
	},
}

--pvp开宝箱-进度条底图
_tab_model[11624] = {
	name = "UI:ChestBag_ProgressBG",
	image = "ui/ChestBag_ProgressBG.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 54, 30},
	},
}

--pvp开宝箱-进度条
_tab_model[11625] = {
	name = "UI:ChestBag_Porgress",
	image = "ui/ChestBag_Porgress.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 24, 20},
	},
}

--pvp背景图左侧图片
_tab_model[11626] = {
	name = "UI:pvproombg_left",
	image = "ui/pvproombg_left.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 100, 34},
	},
}

--pvp称号-顽强
_tab_model[11627] = {
	name = "PVP:Designation_6",
	image = "misc/pvp/designation_6.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--emoji表情-001
_tab_model[11628] = {
	name = "PVP:emoji_001",
	image = "misc/addition/emoji_001.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--emoji表情-002
_tab_model[11629] = {
	name = "PVP:emoji_002",
	image = "misc/addition/emoji_002.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--emoji表情-003
_tab_model[11630] = {
	name = "PVP:emoji_003",
	image = "misc/addition/emoji_003.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--emoji表情-004
_tab_model[11631] = {
	name = "PVP:emoji_004",
	image = "misc/addition/emoji_004.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--竞技场的"擂"字
_tab_model[11632] = {
	name = "UI:FONT_LEITAI",
	image = "misc/pvp/font_leitai.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,100,100},
	},
}

--竞技场的"擂"字2
_tab_model[11633] = {
	name = "UI:FONT_LEITAI2",
	image = "misc/pvp/FONT_LEITAI2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,100,100},
	},
}

--pvp称号-对手逃跑
_tab_model[11634] = {
	name = "PVP:Designation_7",
	image = "misc/pvp/designation_7.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-对手投降
_tab_model[11635] = {
	name = "PVP:Designation_8",
	image = "misc/pvp/designation_8.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp称号-对手掉线
_tab_model[11636] = {
	name = "PVP:Designation_9",
	image = "misc/pvp/designation_9.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 188, 108},
	},
}

--pvp: 无效
_tab_model[11637] = {
	name = "UI:Pvp_Invalid",
	image = "ui/pvp/wx.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,146,76},
	},
}

--pvp: 竞技场专用
_tab_model[11638] = {
	name = "UI:PVP_ONLY",
	image = "ui/pvp_only.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

--推荐图片专用1
_tab_model[11639] = {
	name = "UI:Comment1",
	image = "misc/comment_1.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,440,540},
	},
}

--推荐图片专用2
_tab_model[11640] = {
	name = "UI:Comment2",
	image = "misc/comment_2.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,440,540},
	},
}

--推荐图片专用3
_tab_model[11641] = {
	name = "UI:Comment3",
	image = "misc/comment_3.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,440,540},
	},
}

--推荐图片专用4
_tab_model[11642] = {
	name = "UI:Comment4",
	image = "misc/comment_4.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,440,540},
	},
}

--推荐图片专用5
_tab_model[11643] = {
	name = "UI:Comment5",
	image = "misc/comment_5.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,440,540},
	},
}
_tab_model[11644] = {
	name = "UI:Photo_back",
	image = "misc/xiangkuang.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,150,150},
	},
}

_tab_model[11645] = {
	name = "UI:LocalPhoto",
	image = "ui/localphoto.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}

_tab_model[11646] = {
	name = "UI:TakePhoto",
	image = "ui/takephoto.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,32,32},
	},
}

--emoji表情-005
_tab_model[11647] = {
	name = "PVP:emoji_005",
	image = "misc/addition/emoji_005.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--emoji表情-006
_tab_model[11648] = {
	name = "PVP:emoji_006",
	image = "misc/addition/emoji_006.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--已领取
_tab_model[11649] = {
	name = "UI:FinishTag",
	image = "ui/finishtag.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 70, 60},
	},
}

--已购买
_tab_model[11650] = {
	name = "UI:FinishTag4",
	image = "ui/finishtag4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 70, 60},
	},
}

_tab_model[11651] = {
	name = "BTN:menu_button_activity",
	image = "misc/menu_button_activity.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,100},
	},
}

_tab_model[11652] = {
	name = "BTN:menu_button_arms",
	image = "misc/menu_button_arms.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,100},
	},
}

_tab_model[11653] = {
	name = "BTN:menu_button_hero",
	image = "misc/menu_button_hero.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,100},
	},
}

_tab_model[11654] = {
	name = "BTN:menu_button_mail",
	image = "misc/menu_button_mail.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,70,60},
	},
}

_tab_model[11655] = {
	name = "BTN:menu_button_store",
	image = "misc/menu_button_store.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11656] = {
	name = "BTN:menu_button_task",
	image = "misc/menu_button_task.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,100},
	},
}

_tab_model[11657] = {
	name = "BTN:menu_button_vip",
	image = "misc/menu_button_vip.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,100},
	},
}

--[[
_tab_model[11658] = {
	name = "UI:menu_image_challenge",
	image = "misc/menu_image_challenge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,430,296},
	},
}

_tab_model[11659] = {
	name = "UI:menu_image_multifb",
	image = "misc/menu_image_multifb.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,388,290},
	},
}

_tab_model[11660] = {
	name = "UI:menu_image_plot",
	image = "misc/menu_image_plot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,562,556},
	},
}

_tab_model[11661] = {
	name = "UI:menu_image_pvp",
	image = "misc/menu_image_pvp.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,694,282},
	},
}
]]

--[[
--主界面背景
_tab_model[11662] = {
	name = "UI:PANEL_MENU_NEW",
	image = "panel/panel_menu_new.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1280,768},
	},
}
]]

--主界面顶部栏
_tab_model[11663] = {
	name = "UI:PANEL_MENU_NEW_TOP",
	image = "panel/panel_menu_top.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1280,100},
	},
}

--主界面底部栏
_tab_model[11664] = {
	name = "UI:PANEL_MENU_NEW_BOTTOM",
	image = "panel/panel_menu_bottom.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1280,125},
	},
}

--主界面底部栏2
_tab_model[11665] = {
	name = "UI:PANEL_MENU_NEW_BOTTOM2",
	image = "panel/panel_menu_bottom2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1280,84},
	},
}

--大按钮
_tab_model[11666] = {
	name = "UI:PANEL_MENU_BTN_BIG",
	image = "panel/panel_menu_btn_big.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,213,64},
	},
}

--小按钮
_tab_model[11667] = {
	name = "UI:PANEL_MENU_BTN_NORMAL",
	image = "panel/panel_menu_btn_normal.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,147,64},
	},
}

_tab_model[11668] = {
	name = "ICON_world/level_hlg4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "level_hlg4",
		pMode = 0,
		[1] = {0,0,120,120,1},
	},
}

--红装背景1
_tab_model[11669] = {
	name = "UI:RedEquipmentBG1",
	image = "ui/redequipmergebg1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 310, 310},
	},
}

--红装背景2
_tab_model[11670] = {
	name = "UI:RedEquipmentBG2",
	image = "ui/redequipmergebg2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 194, 194},
	},
}

--红装背景3
_tab_model[11671] = {
	name = "UI:RedEquipmentBG3",
	image = "ui/redequipmergebg3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 194, 194},
	},
}

--VIP线条
_tab_model[11672] = {
	name = "UI:vipline",
	image = "ui/vipline.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 64, 4},
	},
}

--返回弯箭头
_tab_model[11673] = {
	name = "UI:return",
	image = "ui/return.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 64, 64},
	},
}

--锁的横条
_tab_model[11674] = {
	name = "UI:LockLine",
	image = "misc/lockline.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 494, 66},
	},
}

--底盘
_tab_model[11675] = {
	name = "UI:dipan",
	image = "ui/dipan.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 48, 54},
	},
}

--新道具底图
_tab_model[11676] = {
	name = "UI:item1",
	image = "ui/item1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 72, 72},
	},
}

--新道具底图
_tab_model[11677] = {
	name = "UI:jiantou_new",
	image = "ui/jiantou.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 74, 74},
	},
}

--神器分页图标
_tab_model[11678] = {
	name = "UI:shenqi",
	image = "ui/shenqi.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 64, 65},
	},
}

--VIP分页按钮
_tab_model[11679] = {
	name = "UI:vipbtn",
	image = "ui/vipbtn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 96, 64},
	},
}

--装备栏底图1
_tab_model[11680] = {
	name = "UI:bag1",
	image = "ui/bag1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 72, 72},
	},
}

--装备栏底图2
_tab_model[11681] = {
	name = "UI:bag2",
	image = "ui/bag2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 72, 72},
	},
}

--装备栏底图3
_tab_model[11682] = {
	name = "UI:bag3",
	image = "ui/bag3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 72, 72},
	},
}

--装备栏底图4
_tab_model[11683] = {
	name = "UI:bag4",
	image = "ui/bag4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 72, 72},
	},
}

--第1章图标
_tab_model[11684] = {
	name = "ICON_world/chapter1",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter1",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--第2章图标
_tab_model[11685] = {
	name = "ICON_world/chapter2",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter2",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--第3章图标
_tab_model[11686] = {
	name = "ICON_world/chapter3",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter3",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--第4章图标
_tab_model[11687] = {
	name = "ICON_world/chapter4",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter4",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--第5章图标
_tab_model[11688] = {
	name = "ICON_world/chapter5",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter5",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--第6章图标
_tab_model[11689] = {
	name = "ICON_world/chapter6",
	loadmode = "plist",
	plist = "../map/world/map_icon.plist",
	image = "../map/world/map_icon.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 1000,
		pName = "chapter6",
		pMode = 0,
		[1] = {0,0,130,130,1},
	},
}

--战术卡tip背景图
_tab_model[11690] = {
	name = "UI:TacticBG",
	image = "ui/TacticBG.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 128, 128},
	},
}

--PVP铜雀台标题背景
_tab_model[11691] = {
	name = "PVP:imgtitlebg",
	image = "misc/pvp/imgtitlebg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,348,82},
	},
}

--PVP铜雀台标题
_tab_model[11692] = {
	name = "PVP:txtmolongbaoku",
	image = "misc/pvp/txtmolongbaoku.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,154,44},
	},
}

--铜雀台抽奖卡背景
_tab_model[11693] = {
	name = "ICON:giftcard_bg",
	image = "misc/addition/giftcard_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,152,190},
	},
}

--铜雀台抽奖卡标题
_tab_model[11694] = {
	name = "ICON:giftcard_title",
	image = "misc/addition/giftcard_title.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,172,16},
	},
}

--铜雀台抽奖卡卡牌1
_tab_model[11695] = {
	name = "ICON:giftcard_1",
	image = "misc/addition/giftcard_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,148},
	},
}

--铜雀台抽奖卡卡牌3
_tab_model[11696] = {
	name = "ICON:giftcard_3",
	image = "misc/addition/giftcard_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,118,148},
	},
}

--iPhoneX的黑边
_tab_model[11697] = {
	name = "UI:BLACK_BORDER",
	image = "misc/black_border.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 120, 750},
	},
}

_tab_model[11700] = {
	name = "UI:num_blue",
	image = "misc/num_blue.png",
	animation =
	{
		"N0",
		"N1",
		"N2",
		"N3",
		"N4",
		"N5",
		"N6",
		"N7",
		"N8",
		"N9",
	},
	N0 = {
		[1] = {0, 0, 46, 52},
	},
	N1 = {
		[1] = {46, 0, 46, 52},
	},
	N2 = {
		[1] = {46 * 2, 0, 46, 52},
	},
	N3 = {
		[1] = {46 * 3, 0, 46, 52},
	},
	N4 = {
		[1] = {46 * 4, 0, 46, 52},
	},
	N5 = {
		[1] = {46 * 5, 0, 46, 52},
	},
	N6 = {
		[1] = {46 * 6, 0, 46, 52},
	},
	N7 = {
		[1] = {46 * 7, 0, 46, 52},
	},
	N8 = {
		[1] = {46 * 8, 0, 46, 52},
	},
	N9 = {
		[1] = {46 * 9, 0, 46, 52},
	},
}

_tab_model[11701] = {
	name = "ICON:floatnumber_bg",
	image = "misc/floatnumber_bg.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	L = {
		[1] = {0,0,16,38},
	},
	M = {
		[1] = {16,0,16,38},
	},
	R = {
		[1] = {32,0,16,38},
	},
	normal = {
		[1] = {0,0,48,38},
	},
}

_tab_model[11702] = {
	name = "UI:hpbar_red",
	image = "misc/hpbar/hpbar_red.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {42,0,430,128},
	},
}

_tab_model[11703] = {
	name = "UI:hpbar_green",
	image = "misc/hpbar/hpbar_green.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {42,0,430,128},
	},
}

_tab_model[11704] = {
	name = "UI:hpbar_yellow",
	image = "misc/hpbar/hpbar_yellow.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {42,0,430,128},
	},
}

_tab_model[11705] = {
	name = "UI:CKSystemNum",
	image = "misc/continuouskilling/continuouskilling.png",
	animation =
	{
		"ADD",
		"N0",
		"N1",
		"N2",
		"N3",
		"N4",
		"N5",
		"N6",
		"N7",
		"N8",
		"N9",
	},
	ADD = {
		[1] = {0, 0, 78, 78},
	},
	N0 = {
		[1] = {78, 0, 78, 78},
	},
	N1 = {
		[1] = {78 * 2, 0, 78, 78},
	},
	N2 = {
		[1] = {78 * 3, 0, 78, 78},
	},
	N3 = {
		[1] = {78 * 4, 0, 78, 78},
	},
	N4 = {
		[1] = {78 * 5, 0, 78, 78},
	},
	N5 = {
		[1] = {78 * 6, 0, 78, 78},
	},
	N6 = {
		[1] = {78 * 7, 0, 78, 78},
	},
	N7 = {
		[1] = {78 * 8, 0, 78, 78},
	},
	N8 = {
		[1] = {78 * 9, 0, 78, 78},
	},
	N9 = {
		[1] = {78 * 10, 0, 78, 78},
	},
}

_tab_model[11706] = {
	name = "UI:StageNum",
	image = "misc/addition/stage_number.png",
	animation =
	{
		"N0",
		"N1",
		"N2",
		"N3",
		"N4",
		"N5",
		"N6",
		"N7",
		"N8",
		"N9",
	},
	N0 = {
		[1] = {0, 0, 56, 70},
	},
	N1 = {
		[1] = {56, 0, 56, 70},
	},
	N2 = {
		[1] = {56 * 2, 0, 56, 70},
	},
	N3 = {
		[1] = {56 * 3, 0, 56, 70},
	},
	N4 = {
		[1] = {56 * 4, 0, 56, 70},
	},
	N5 = {
		[1] = {56 * 5, 0, 56, 70},
	},
	N6 = {
		[1] = {56 * 6, 0, 56, 70},
	},
	N7 = {
		[1] = {56 * 7, 0, 56, 70},
	},
	N8 = {
		[1] = {56 * 8, 0, 56, 70},
	},
	N9 = {
		[1] = {56 * 9, 0, 56, 70},
	},
}

_tab_model[11707] = {
	name = "UI:qrcode",
	image = "misc/share/qrcode.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,120,120},
	},
}

_tab_model[11708] = {
	name = "UI:sharebtn",
	image = "misc/share/sharebtn.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,160,60},
	},
}

_tab_model[11709] = {
	name = "UI:sharetacticsbg12029",
	image = "misc/share/sharetacticsbg12029.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,476,686},
	},
}

_tab_model[11710] = {
	name = "UI:sharetacticstitle12029",
	image = "misc/share/sharetacticstitle12029.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,180,50},
	},
}

_tab_model[11711] = {
	name = "UI:sharetacticsbg12029",
	image = "misc/chariotconfig/board_bg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,476,686},
	},
}

_tab_model[11712] = {
	name = "UI:bg_10",
	image = "misc/treasure/background.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1560,768},
	},
}

_tab_model[11713] = {
	name = "UI:backbtn",
	image = "misc/skillup/back.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,56,56},
	},
}

_tab_model[11714] = {
	name = "UI:cowbar",
	image = "misc/commonboard/cowbar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,1212,118},
	},
}

_tab_model[11715] = {
	name = "UI:line_blue",
	image = "misc/commonboard/line1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,2,720},
	},
}

_tab_model[11716] = {
	name = "UI:line_store",
	image = "misc/commonboard/line2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,14,720},
	},
}

_tab_model[11717] = {
	name = "UI:btn_inline1",
	image = "misc/commonboard/btn_inline1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,114,60},
	},
}

_tab_model[11718] = {
	name = "UI:btn_inline2",
	image = "misc/commonboard/btn_inline2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,101,56},
	},
}

_tab_model[11719] = {
	name = "UI:btn_inline3",
	image = "misc/commonboard/btn_inline3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,114,68},
	},
}

_tab_model[11720] = {
	name = "UI:btn_inline4",
	image = "misc/commonboard/btn_inline4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,104,62},
	},
}

_tab_model[11721] = {
	name = "UI:btn_incow1",
	image = "misc/commonboard/btn_incow1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,222,76},
	},
}

_tab_model[11722] = {
	name = "UI:btn_incow2",
	image = "misc/commonboard/btn_incow2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,212,76},
	},
}

_tab_model[11723] = {
	name = "UI:btn_incow3",
	image = "misc/commonboard/btn_incow3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,212,76},
	},
}

_tab_model[11724] = {
	name = "UI:btn_incow4",
	image = "misc/commonboard/btn_incow4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,222,76},
	},
}

_tab_model[11725] = {
	name = "UI:zhezhao",
	image = "misc/zhezhao.jpg",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[11054] = {
	name = "UI:ValueBar2",
	image = "misc/valuebar.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {32,18,636,46},
	},
}

_tab_model[11055] = {
	name = "UI:TV",
	image = "misc/commonboard/tv.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,316,250},
	},
}

_tab_model[11056] = {
	name = "UI:treasurebox",
	image = "misc/commonboard/treasurebox.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,300,200},
	},
}

_tab_model[11057] = {
	name = "UI:treasureboxbg",
	image = "misc/commonboard/treasureboxbg.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,340,300},
	},
}

_tab_model[11058] = {
	name = "UI:logintv1",
	image = "../map/other/logintv.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,768,1560,1},
	},
}

_tab_model[11059] = {
	name = "UI:logintv2",
	image = "../map/other/logintv2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,768,1560,1},
	},
}

_tab_model[11060] = {
	name = "UI:logintv_btn1",
	image = "misc/redbtn1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,166,118,1},
	},
}

_tab_model[11061] = {
	name = "UI:logintv_btn2",
	image = "misc/logintv_btn2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,180,118,1},
	},
}

--售罄
_tab_model[11062] = {
	name = "UI:FinishTag5_big",
	image = "ui/finishtag5_big.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 114, 81},
	},
}

--进度条3
_tab_model[11063] = {
	name = "UI:ValueBar3",
	image = "misc/addition/valuebar3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,368,44},
	},
}

--进度条3背景
_tab_model[11064] = {
	name = "UI:ValueBar_Back3",
	image = "misc/addition/valuebar_back3.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0,0,368,44},
	},
	L = {
		[1] = {0,0,16,44},
	},
	M = {
		[1] = {10,0,336,44},
	},
	R = {
		[1] = {350,0,16,44},
	},
}

--聊天按钮
_tab_model[11752] = {
	name = "UI:CHAT_N",
	image = "ui/chat_n.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,98,90,},
	},
}

--聊天龙王图标
_tab_model[11860] = {
	name = "UI:ICON_CHAT_DRAGON",
	image = "misc/chest/icon_chat_dragon.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72,},
	},
}

_tab_model[12028] = {
	name = "ICON:privacy1",
	image = "panel/icon_privacy1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,186,288},
	},
}

_tab_model[12029] = {
	name = "ICON:privacy2",
	image = "panel/icon_privacy2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,186,288},
	},
}

_tab_model[12030] = {
	name = "ICON:privacy3",
	image = "panel/icon_privacy3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,186,288},
	},
}

--碎片*1
_tab_model[12031] = {
	name = "ICON:debris_1",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*0,32*0,90,32},
	},
}

--碎片*2
_tab_model[12032] = {
	name = "ICON:debris_2",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*0,32*1,90,32},
	},
}

--碎片*5
_tab_model[12033] = {
	name = "ICON:debris_5",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*0,32*2,90,32},
	},
}

--碎片*10
_tab_model[12034] = {
	name = "ICON:debris_10",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*1,32*0,90,32},
	},
}

--碎片*50
_tab_model[12035] = {
	name = "ICON:debris_50",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*1,32*1,90,32},
	},
}

--碎片*88
_tab_model[12036] = {
	name = "ICON:debris_88",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*1,32*2,90,32},
	},
}

--芯片（破损）
_tab_model[12037] = {
	name = "ICON:CHIP_BROKEN",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*0,60*1,60,60},
	},
}

--芯片（蓝）
_tab_model[12038] = {
	name = "ICON:CHIP_BLUE",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*0,0,60,60},
	},
}

--芯片（黄）
_tab_model[12039] = {
	name = "ICON:CHIP_YELLOW",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*1,0,60,60},
	},
}

--芯片（红）
_tab_model[12040] = {
	name = "ICON:CHIP_RED",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*2,0,60,60},
	},
}

--芯片（紫）
_tab_model[12041] = {
	name = "ICON:CHIP_PURPLE",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*3,0,60,60},
	},
}

--芯片（孔槽）
_tab_model[12042] = {
	name = "ICON:CHIP_SLOT",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*1,60*1,60,60},
	},
}

--芯片（回收）
_tab_model[12043] = {
	name = "ICON:CHIP_RECYCLE",
	image = "misc/chariotconfig/chip_merge.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {60*2,60*1,60,60},
	},
}

--近战碎石图标
_tab_model[12044] = {
	name = "ICON:MELEE_STONE",
	image = "misc/chariotconfig/skill_trees.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {72*3,84*3,72,84},
	},
}

--碎片*100
_tab_model[12045] = {
	name = "ICON:debris_100",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*2,32*0,90,32},
	},
}

--碎片*188
_tab_model[12046] = {
	name = "ICON:debris_188",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*2,32*1,90,32},
	},
}

--碎片*300
_tab_model[12047] = {
	name = "ICON:debris_300",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*2,32*2,90,32},
	},
}

--碎片*500
_tab_model[12048] = {
	name = "ICON:debris_500",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*3,32*0,90,32},
	},
}

--碎片*888
_tab_model[12049] = {
	name = "ICON:debris_888",
	image = "misc/task/debris_multy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {90*3,32*1,90,32},
	},
}

--黑龙关闭
_tab_model[12050] =
{
	name = "ICON:DRAGON_EXIT",
	image = "misc/chest/dragon_exit_button2.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5,0.5},
		interval = 500,
		[1] = {0,0,84,92,2,},
	},
}

--黑龙开启
_tab_model[12051] =
{
	name = "ICON:DRAGON_OPEN",
	image = "misc/chest/dragon_exit_button.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5,0.5},
		interval = 500,
		[1] = {0,0,84,92,2,},
	},
}

_tab_model[12055] =
{
	name = "ICON:ACCOUNT_SET",
	image = "misc/account_set.png",
	animation =
	{
		"stand",
	},
	stand =
	{
		anchor = {0.5,0.5},
		interval = 1200,
		[1] = {0,0,102,162,2,},
	},
}

--血条（新）背景图
_tab_model[12056] = {
	name = "UI:BAR_ValueBar_BG_NEW",
	image = "misc/valuebar_new.png",
	animation = {
		"normal",
		"L",
		"M",
		"R",
	},
	normal = {
		[1] = {0, 0,64,20},
	},
	L = {
		[1] = {0,0,8,20},
	},
	M = {
		[1] = {8,0,60,20},
	},
	R = {
		[1] = {56,0,8,20},
	},
}

--血条（新）
_tab_model[12057] = {
	name = "UI:IMG_ValueBar_NEW",
	image = "misc/valuebar_new.png",
	animation =
	{
		"normal",
		"green",
		"yellow",
	},
	normal =
	{
		[1] = {0, 0, 64, 20},
	},
	green =
	{
		[1] = {0, 24, 56, 16},
	},
	yellow =
	{
		[1] = {0, 44, 56, 16},
	},
}

--闪避图标
_tab_model[12058] = {
	name = "ICON:DODGE",
	image = "misc/chariotconfig/skill_trees.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {72*4,84*3,72,84},
	},
}

--黑底
_tab_model[12059] = {
	name = "UI:BLACK",
	image = "ui/black.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,16,16},
	},
}

--已完成
_tab_model[12060] = {
	name = "UI:FinishTag2",
	image = "ui/finishtag2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0, 0, 70, 60},
	},
}

--月卡图标
_tab_model[12061] = {
	name = "UI:MONTHCARD_ICON",
	image = "ui/monthcardicon.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,96,96,},
	},
}

--月卡角标
_tab_model[12062] = {
	name = "UI:MONTHCARD_FLAG",
	image = "ui/month_card.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,68,60,},
	},
}

--微信分享
_tab_model[12063] = {
	name = "UI:WEIXIN_SHARE",
	image = "ui/wxshare.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,54,54,},
	},
}

