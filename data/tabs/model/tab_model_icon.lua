local _tab_model = hVar.tab_model

--===========================================
-- 卡片
local baseID = 19000
for i = 1,95 do
	_tab_model[baseID+i] = {
		name = "ICON:hero_card_"..i,
		--image = "icon/card/card_lg_"..i..".png",
		image = "icon/hero/heros2_"..i..".png",
		animation = {
			"normal",
		},
		normal = {
			interval = 1000,
			--[1] = {0,0,256,384},
			[1] = {0,0,96,96},
		},
	}
end

--===========================================
-- 图标
local baseID = 19000
for i = 1,95 do
	_tab_model[baseID+i] = {
		name = "ICON:hero_"..i,
		--image = "icon/card/card_lg_"..i..".png",
		image = "icon/hero/heros2_"..i..".png",
		animation = {
			"normal",
		},
		normal = {
			interval = 1000,
			[1] = {0,0,96,96},
		},
	}
end

--===========================================
-- 图标
-- Icon_1 icon 62*62,slot 64*64 w 16 h 16
--local baseID = 19500
--local i = 0
--for h = 1,16 do
	--for w = 1,16 do
		--i = i + 1
		--_tab_model[baseID+i] = {
			--name = "ICON:icon01_x"..w.."y"..h,
			--image = "ui/icon01.png",
			--animation = {
				--"normal",
			--},
			--normal = {
				--interval = 1000,
				--[1] = {(w-1)*63,(h-1)*62,62,62},
			--},
		--}
	--end
--end

--从整图解析并定义一批图片
function _Code_AutoAnalyzeImg(imgPath,nameFormat,startId,num,cow,line,w,h,spacew,spaceh,startx,starty)
	local idx = 1
	for j = 1,line do
		for i = 1,cow do
			--local idx = (j-1)*cow + i
			if type(num) == "number" then
				if idx > num then
					return
				end
			elseif type(num) == "table" then
				local cowlimit = num[j]
				if i > cowlimit then
					break
				end
			else
				return
			end
			spacew = spacew or 0
			spaceh = spaceh or 0
			startx = startx or 0
			starty = starty or 0
			local realidx =  idx + startId - 1
			local finalname = string.format(nameFormat,j,i)
			--print("finalname",finalname,idx)
			--print(idx,realidx,finalname)
			local x = (i-1)*(w+spacew)+startx
			local y = (j-1)*(h+spaceh)+starty
			_tab_model[realidx] = {
				name = finalname,
				image = imgPath,
				animation = {
					"normal",
				},
				normal = {
					interval = 1000,
					[1] = {x,y,w,h},
				},
			}
			idx = idx + 1
		end
	end
end
--参数 1.图片路径  2.自定义名字 3.起始id 4.创建数量 5.列数(数字就是连续的   table可以设置每一行) 6.行数 7.横 8.宽 9.横向间隔 10.纵向间隔 11.起始x 12 起始y
--9-12可不填 主要是用来根据不同图片调整图片选取区域的参数 默认都是0
--9 横向间隔 如果每一列当中都有1-2像素的缝隙 那么就需要此参数
--10 纵向间隙 如果每一行当中都有1-2像素的缝隙 那么就需要此参数
--举例ICON:SKILL_SET%02d_%02d 2行3列的图片最终名字为  ICON:SKILL_SET02_03  %02d的意思为保留2位数自动填0 如不需要可以直接填%d
--_Code_AutoAnalyzeImg("misc/chariotconfig/skill_trees.png","ICON:SKILL_SET%02d_%02d",19100,19,7,4,72,84)
			---不规则填发，定义一行一列有多少个图标
_Code_AutoAnalyzeImg("misc/chariotconfig/skill_trees.png","ICON:SKILL_SET%02d_%02d",19100,{7,7,5,4,7},7,5,72,84)
			---规则填发，一共48个图标
_Code_AutoAnalyzeImg("misc/chariotconfig/skill_ironbuff.png","ICON:IRONBUFF_SET%02d_%02d",19150,48,8,6,72,84)

_tab_model[19500] = {
	name = "ICON:icon01_x1y1",
	image = "ui/icon01_x1y1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19501] = {
	name = "ICON:icon01_x1y10",
	image = "ui/icon01_x1y10.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19502] = {
	name = "ICON:icon01_x2y2",
	image = "ui/icon01_x2y2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19503] = {
	name = "ICON:icon01_x2y4",
	image = "ui/icon01_x2y4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19504] = {
	name = "ICON:icon01_x2y9",
	image = "ui/icon01_x2y9.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19505] = {
	name = "ICON:icon01_x3y5",
	image = "ui/icon01_x3y5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}

_tab_model[19506] = {
	name = "ICON:icon01_x4y3",
	image = "ui/icon01_x4y3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19507] = {
	name = "ICON:icon01_x6y1",
	image = "ui/icon01_x6y1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}
_tab_model[19508] = {
	name = "ICON:icon01_x6y5",
	image = "ui/icon01_x6y5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}

_tab_model[19509] = {
	name = "ICON:icon01_x14y13",
	image = "ui/icon01_x14y13.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}

_tab_model[19511] = {
	name = "ICON:icon01_x14y3",
	image = "ui/icon01_x14y3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,62,62},
	},
}

local baseID = 19512
local i = 0
for h = 1,16 do
	for w = 1,16 do
		i = i + 1
		_tab_model[baseID+i] = {
			name = "ICON:skill_icon_x"..w.."y"..h,
			image = "icon/skill/skill_icon.png",
			animation = {
				"normal",
			},
			normal = {
				interval = 1000,
				[1] = {(w-1)*64,(h-1)*64,64,64},
			},
		}
	end
end

local baseID = 19512+256
local i = 0
for h = 1,16 do
	for w = 1,16 do
		i = i + 1
		_tab_model[baseID+i] = {
			name = "ICON:skill_icon1_x"..w.."y"..h,
			image = "icon/skill/skill_icon1.png",
			animation = {
				"normal",
			},
			normal = {
				interval = 1000,
				[1] = {(w-1)*64,(h-1)*64,64,64},
			},
		}
	end
end


_tab_model[20105] = {
	name = "ICON:action_attack",
	image = "ui/attack.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[20106] = {
	name = "ICON:action_info",
	image = "ui/question.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,48,48},
	},
}
_tab_model[20107] = {
	name = "ICON:action_loot",
	image = "ui/loot.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}
_tab_model[20108] = {
	name = "ICON:action_move",
	image = "ui/move.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[20109] = {
	name = "ICON:action_enter",
	image = "ui/door.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,68,68},
	},
}

_tab_model[20110] = {
	name = "ICON:action_talk",
	image = "ui/talk.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}


_tab_model[20111] = {
	name = "ICON:action_join",
	image = "ui/join.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[20112] = {
	name = "ICON:action_look",
	image = "ui/look.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[20115] = {
	name = "ICON:action_occupy",
	image = "misc/flag.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,40,40},
		--[2] = {355,950,64,72},
		--[3] = {355,952,64,72},
		--[4] = {355,950,64,72},
		--[5] = {355,949,64,72},
	},
	LEGION = {
	},
}

for i = 1,9 do
	_tab_model[20115+i] = {
		name = "ICON:player_legion_"..i,
		image = "misc/flag.png",
		animation = {
			"normal",
		},
		normal = {
			[1] = {0 + (i-1)%3*40 ,0 + math.ceil((i-3)/3)*40 ,40,40},
		},
	}
end


	

------------------------------------------
-- 技能图标
-- 30000~32000

_tab_model[30031] = {
	name = "ICON:HeroAttr",
	image = "ui/hp_pec.png",
	animation = {
		"exp",
		"hp_pec",
		"mp_pec",
	},
	exp = {
		image = "ui/heroattr.png",
		[1] = {0,0,64,64},
	},
	hp_pec = {
		image = "ui/hp_pec.png",
		[1] = {0,0,70,70},
	},
	mp_pec = {
		image = "ui/mp_pec.png",
		[1] = {0,0,70,70},
	},
}

_tab_model[30032] = {
	name = "ICON:Hammer",
	image = "ui/hammer.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[30033] = {
	name = "ICON:ReviveHero",
	image = "ui/revivehero.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[30034] = {
	name = "ICON:UnitUpGrade",
	image = "ui/unitupgrade.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[30035] = {
	name = "ICON:PartArmy",
	image = "ui/partarmy.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[30036] = {
	name = "ICON:UpgradeHit",
	image = "ui/hero_star.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,12,12},
	},
}

_tab_model[30037] = {
	name = "ICON:DETICON",
	image = "effect/blocks1.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[30038] = {
	name = "ICON:MOVERANGE",
	image = "ui/range.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,58},
	},
}
_tab_model[30039] = {
	name = "ICON:MOVESPEED",
	image = "misc/speed.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,62,62},
	},
}

_tab_model[30040] = {
	name = "ICON:PICK",
	image = "ui/pickup.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,40,40},
	},
}

_tab_model[30041] = {
	name = "ICON:TechnologyUpgrade",
	image = "ui/technology.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}


_tab_model[30047] = {
	name = "ICON:Back_blue",
	image = "icon/icon_back_blue.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[30048] = {
	name = "ICON:Back_white",
	image = "icon/icon_back_white.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[30049] = {
	name = "ICON:Back_red",
	image = "icon/icon_back_red.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[30050] = {
	name = "ICON:Back_gold",
	image = "icon/icon_back_gold.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

_tab_model[30051] = {
	name = "ICON:TRADE",
	image = "ui/trade.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,64,64},
	},
}

_tab_model[30052] = {
	name = "ICON:Back_orange",
	image = "icon/icon_back_orange.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--神器
_tab_model[30053] = {
	name = "ICON:Back_red2",
	image = "icon/icon_back_red2.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--神器
_tab_model[30054] = {
	name = "ICON:Back_red3",
	image = "icon/icon_back_red3.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

--道具白色底纹
_tab_model[30055] = {
	name = "ICON:Back_white_item",
	image = "ui/icon_item_white.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--道具蓝色底纹
_tab_model[30056] = {
	name = "ICON:Back_blue_item",
	image = "ui/icon_item_blue.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--道具黄色底纹
_tab_model[30057] = {
	name = "ICON:Back_yellow_item",
	image = "ui/icon_item_yellow.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--道具橙色底纹
_tab_model[30058] = {
	name = "ICON:Back_orange_item",
	image = "ui/icon_item_orange.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--道具红色底纹
_tab_model[30059] = {
	name = "ICON:Back_red_item",
	image = "ui/icon_item_red.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

--道具红色底纹2
_tab_model[30060] = {
	name = "ICON:Back_red2_item",
	image = "ui/icon_item_red2.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,72,72},
	},
}

---------------------装备图标-------------------
--通用
-----------------32000~32199武器
----------------头盔32200---32399------------
--------------盔甲/衣服32400---32599----------
---------------鞋子32600---32799
---------------宝物32800---32999
---------------坐骑33000---33199
-------------消耗33200------33399--------------
local __ICON__Item = {
	{"ICON:Item_Medic","icon/item/item_medic","00",0,0},
	{"ICON:Item_Axe","icon/item/item_axe","0",0,3},----斧
	{"ICON:Item_Weapon","icon/item/item_weapon","00",1,99},--武器
	{"ICON:Item_Spear","icon/item/item_spear","00",0,7},---长矛
	{"ICON:Item_Sword","icon/item/item_sword","00",1,99},----剑
	{"ICON:Item_Cudgel","icon/item/item_cudgel","00",1,4},----锤
	{"ICON:Item_Katar","icon/item/item_katar","00",1,1},----环
	{"ICON:Item_Fan","icon/item/item_fan","00",1,3},----扇子
	{"ICON:Item_Bow","icon/item/item_bow","00",1,3},----弓
	{"ICON:Item_Helmet","icon/item/item_helmet","00",1,99},---头盔
	{"ICON:Item_Armor","icon/item/item_armor","0",0,99},----衣服
	{"ICON:Item_Shoe","icon/item/item_shoe","00",1,99},----鞋子
	{"ICON:Item_Book","icon/item/item_book","00",1,7},----书
	{"ICON:Item_Ring","icon/item/item_ring","00",0,4},----戒指
	{"ICON:Item_Hand","icon/item/item_hand","00",0,4},----手套
	{"ICON:Item_Sachet","icon/item/item_sachet","0",1,2},
	{"ICON:Item_Treasure","icon/item/item_treasure","00",1,99},---宝物
	{"ICON:Item_Horse","icon/item/item_horse","00",1,99},----坐骑
}
local nItemIconID = 32000
local tAnimList = {"normal"}
local tAnim = {
	interval = 1000,
	[1] = {0,0,64,64},
}
for n = 1,#__ICON__Item do
	local name,path,mode,nMin,nMax = unpack(__ICON__Item[n])
	for i = nMin,nMax do
		local plus
		if i==0 then
			plus = ""
		else
			if mode=="00" then
				plus = string.format("%02d",i)
			else
				plus = tostring(i)
			end
			key = name..plus
		end
		nItemIconID = nItemIconID + 1
		_tab_model[nItemIconID] = {
			name = name..plus,
			image = path..plus..".png",
			animation = tAnimList,
			normal = tAnim,
		}
	end
end



--新的英雄基础属性图标
_tab_model[33400] = {
	name = "ICON:HeroAttr_str",
	image = "ui/attr_attack.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33401] = {
	name = "ICON:HeroAttr_con",
	image = "ui/attr_con.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33402] = {
	name = "ICON:HeroAttr_defense",
	image = "ui/attr_defense.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33403] = {
	name = "ICON:HeroAttr_int",
	image = "ui/attr_int.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33404] = {
	name = "ICON:HeroAttr_leadship",
	image = "ui/attr_leadship.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33405] = {
	name = "ICON:Imperial_Academy",
	image = "ui/academy.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,50,50},
	},
}

_tab_model[33406] = {
	name = "ICON:/battle_attack03",
	image = "ui/battle_attack03.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,72},
	},
}

_tab_model[33407] = {
	name = "ICON:Defense",
	image = "ui/attr_defense.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

_tab_model[33408] = {
	name = "ICON:power",
	image = "ui/combat_power.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,132,38},
	},
}

_tab_model[33409] = {
	name = "ICON:line",
	image = "misc/rank_line.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,2},
	},
}

_tab_model[33410] = {
	name = "ICON:image_frame",
	image = "ui/image_frame.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,54,54},
	},
}

_tab_model[33411] = {
	name = "ICON:image_update",
	image = "ui/image_update.png",
	motion = {{0,-3,0.3},{0,0,0.3}},
	animation = {
		"normal",
		"hover",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,38,38},
	},
	hover = {
		interval = 400,
		[1] = {0,0,38,38},
	},
}

_tab_model[33412] = {
	name = "ICON:BF",
	image = "ui/bf.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,52,44},
	},
}

--手
_tab_model[33413] = {
	name = "ICON:HAND",
	image = "ui/draghand.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,72,96},
	},
}

_tab_model[33414] = {
	name = "ICON:BeginPoint",
	image = "effect/jt.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,66,30},
	},
}

_tab_model[33415] = {
	name = "ICON:image_jiantou",
	image = "ui/image_update.png",
	motion = {{-3,0,0.3},{0,0,0.3}},
	animation = {
		"normal",
		"hover",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,38,38},
	},
	hover = {
		interval = 400,
		[1] = {0,0,38,38},
	},
}

_tab_model[33416] = {
	name = "ICON:image_jiantouV",
	image = "ui/image_update.png",
	motion = {{0,-3,0.3},{0,0,0.3}},
	animation = {
		"normal",
		"hover",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,38,38},
	},
	hover = {
		interval = 400,
		[1] = {0,0,38,38},
	},
}

--道具白色边框
_tab_model[33417] = {
	name = "ICON:Border_white_item",
	image = "ui/icon_border_white.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

--道具蓝色边框
_tab_model[33418] = {
	name = "ICON:Border_blue_item",
	image = "ui/icon_border_blue.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

--道具黄色边框
_tab_model[33419] = {
	name = "ICON:Border_yellow_item",
	image = "ui/icon_border_gold.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

--道具橙色边框
_tab_model[33420] = {
	name = "ICON:Border_orange_item",
	image = "ui/icon_border_orange.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}

--道具红色边框
_tab_model[33421] = {
	name = "ICON:Border_red_item",
	image = "ui/icon_border_red.png",
	animation = {
		"normal",
	},
	normal = {
		interval = 1000,
		[1] = {0,0,64,64},
	},
}


--天赋分类按钮图标
_tab_model[33422] = {
	name = "ICON:SKILL_rune_1001",
	image = "misc/chariotconfig/ws_tab02_selected.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,101,112},
	},
}


--天赋分类按钮图标
_tab_model[33423] = {
	name = "ICON:SKILL_rune_1002",
	image = "misc/chariotconfig/ws_tab03_selected.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,101,112},
	},
}


--天赋分类按钮图标
_tab_model[33424] = {
	name = "ICON:SKILL_rune_1003",
	image = "misc/chariotconfig/ws_tab04_selected.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,101,112},
	},
}

--体力图标
_tab_model[33426] = {
	name = "ICON:ICON_tili_oil",
	image = "icon/item/tili_oil.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--瓦力图标
_tab_model[33427] = {
	name = "ICON:ICON_pet_01",
	image = "icon/item/pet_01.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--刺蛇图标
_tab_model[33428] = {
	name = "ICON:ICON_pet_02",
	image = "icon/item/pet_02.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--X战机图标
_tab_model[33429] = {
	name = "ICON:ICON_pet_03",
	image = "icon/item/pet_03.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--光剑使者图标
_tab_model[33430] = {
	name = "ICON:ICON_pet_04",
	image = "icon/item/pet_04.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}



--抽奖图标1
_tab_model[33431] = {
	name = "ICON:ICON_chest_1",
	image = "icon/item/chest_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

--抽奖图标2
_tab_model[33432] = {
	name = "ICON:ICON_chest_2",
	image = "icon/item/chest_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

--抽奖图标3
_tab_model[33433] = {
	name = "ICON:ICON_chest_3",
	image = "icon/item/chest_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

--抽奖图标4
_tab_model[33434] = {
	name = "ICON:ICON_chest_4",
	image = "icon/item/chest_4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

--抽奖图标5
_tab_model[33435] = {
	name = "ICON:ICON_chest_5",
	image = "icon/item/chest_5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标1
_tab_model[33441] = {
	name = "ICON:ICON_gun_1",
	image = "icon/item/gun_1.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}

--武器图标2
_tab_model[33442] = {
	name = "ICON:ICON_gun_2",
	image = "icon/item/gun_2.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标3
_tab_model[33443] = {
	name = "ICON:ICON_gun_3",
	image = "icon/item/gun_3.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标4
_tab_model[33444] = {
	name = "ICON:ICON_gun_4",
	image = "icon/item/gun_4.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标5
_tab_model[33445] = {
	name = "ICON:ICON_gun_5",
	image = "icon/item/gun_5.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标6
_tab_model[33446] = {
	name = "ICON:ICON_gun_6",
	image = "icon/item/gun_6.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标7
_tab_model[33447] = {
	name = "ICON:ICON_gun_7",
	image = "icon/item/gun_7.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标8
_tab_model[33448] = {
	name = "ICON:ICON_gun_8",
	image = "icon/item/gun_8.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标9
_tab_model[33449] = {
	name = "ICON:ICON_gun_9",
	image = "icon/item/gun_9.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标10
_tab_model[33450] = {
	name = "ICON:ICON_gun_10",
	image = "icon/item/gun_10.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标11
_tab_model[33451] = {
	name = "ICON:ICON_gun_11",
	image = "icon/item/gun_11.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标12
_tab_model[33452] = {
	name = "ICON:ICON_gun_12",
	image = "icon/item/gun_12.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标13
_tab_model[33453] = {
	name = "ICON:ICON_gun_13",
	image = "icon/item/gun_13.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}


--武器图标14
_tab_model[33454] = {
	name = "ICON:ICON_gun_14",
	image = "icon/item/gun_14.png",
	animation = {
		"normal",
	},
	normal = {
		[1] = {0,0,80,80},
	},
}



