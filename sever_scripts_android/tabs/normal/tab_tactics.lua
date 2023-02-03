--用于界面显示一般战术技能卡的排序
hVar.tab_tacticsEx =
{
	5001,5002,5003,5004,5005,5006,5007,5008,5010,5011,5012,5013,5014,
}



--用于界面显示特殊塔的排序
hVar.tab_tacticsSpecialEx =
{
	1020, --粮仓
	1022, --擂鼓塔
	1023, --地刺塔
}

--用于界面显示PVP兵种的排序-进攻
hVar.tab_tacticsArmyEx_Atk =
{
	1301, 1302, 1303, 1305, --孔明灯, 死士, 投石车, 自爆兵
	1304, 1306, 1307, --力士, 箭雨, 象兵,
	1309, 1312, 1314, --虎豹骑, 炎爆, 狗雨
	1315, 1316, --微笑力士, 爆裂力士
}

--用于界面显示PVP兵种的排序-防守
hVar.tab_tacticsArmyEx_Def =
{
	1308, --护城弩手
	1313, --护城卫士
	1317, --天网
	1318, --捕兽夹
}

hVar.tab_tactics = {}
local _tab_tactics = hVar.tab_tactics
_tab_tactics[1] = {
	icon = "MODEL:Default",
	name = "none",
	unqiue = 1,
	--growth = {},						--所有城池的生物生长数提升{{id,num_lv1,num_lv2,...},...} --zhenkira 注释。td不需要
	--playerdata = {},					--每日增加玩家属性{[lv] = {{attr,val},{attr,val}},} --zhenkira 注释。td不需要
	--pvpshow = 0,						--该卡片在pvp竞技场中不显示 --zhenkira 注释。td不需要
	--duration = 0,						--如果该卡片对某个单位产生加成，那么超过一定的回合数后将不会显示 --zhenkira 注释。td不需要
	level = 4,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = false,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 0,						--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	activeSkill =						--主动释放的技能
	{
		count = 0,						--(nil or -1)次数无限
		id = 8155,					--技能id
		cd = {0, 0, 0, 0},					--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型(hVar.CAST_TYPE.IMMEDIATE、hVar.CAST_TYPE.SKILL_TO_GROUND)
		effectRange = {100, 100, 100, 100},		--技能生效范围
		costMana = {0, 0, 0, 0},					--技能资源消耗
	},						
	goldPerWave =						--每回合额外增加金钱（这里只每回合额外发钱部分的增加值） --zhenkira 新增项
	{
		value = {10,10,10,10,10,10,10,10,10,10},	--增加值上限
		per = {10,10,10,10,10,10,10,10,10,10},		--增加百分比上限(填入实际值的100倍)
	},
	expAdd =						--每局游戏额外获得经验
	{
		value = {10,10,10,10,10,10,10,10,10,10},	--增加值上限
		per = {10,10,10,10,10,10,10,10,10,10},		--增加百分比上限(填入实际值的100倍)
	},
	scoreAdd =						--每局游戏额外获得积分
	{
		value = {10,10,10,10,10,10,10,10,10,10},	--增加值上限
		per = {10,10,10,10,10,10,10,10,10,10},		--增加百分比上限(填入实际值的100倍)
	},


	--建造消耗影响值
	remouldCost = 
	{
		baseTowerId = {69997,11007},
		targetId = {69994,69995},			--建造对象tab_unitId
		[1] = {value = -10, per = -10},			--1级影响
		[2] = {value = -10, per = -10},			--2级影响
		[3] = {value = -10, per = -10},			--3级影响
		[4] = {value = -10, per = -10},			--4级影响
		[5] = {value = -10, per = -10},			--5级影响
		[6] = {value = -10, per = -10},			--6级影响
		[7] = {value = -10, per = -10},			--7级影响
		[8] = {value = -10, per = -10},			--8级影响
		[9] = {value = -10, per = -10},			--9级影响
		[10] = {value = -10, per = -10},		--10级减免
	},
	
	--建造解锁
	remouldUnlock = 
	{
		baseTowerId = {69997,11007},
		[1] = {69001,69002},				--1级解锁建造目标
		[2] = {69001},					--2级解锁建造目标
		[3] = {69001},					--3级解锁建造目标
		[4] = {69001},					--4级解锁建造目标
		[5] = {69001},					--5级解锁建造目标
		[6] = {69001},					--6级解锁建造目标
		[7] = {69001},					--7级解锁建造目标
		[8] = {69001},					--8级解锁建造目标
		[9] = {69001},					--9级解锁建造目标
		[10] = {69001},					--10级解锁建造目标
	},
	
	--升级解锁新技能
	upgradeSkillUnlock = 
	{
		targetId = {69994},
		unlockSkillId = {9401, 9402},			--该类战术技能卡只设计成1级，所以目前表项只支持一个等级维度的解锁
	},

	--战术技能卡可交互单位点击释放技能解锁
	castSkillUnlock = 
	{
		targetId = {69994},
		unlockSkillId = {9401, 9402},			--该类战术技能卡只设计成1级，所以目前表项只支持一个等级维度的解锁
	},
	
	--升级消耗影响值
	upgradeSkillCost = 
	{
		targetId = {69994,69995},			--升级的对象tab_unitId（该角色所有技能升级消耗均相同）
		[1] = {value = -10, per = -10},			--1级影响
		[2] = {value = -10, per = -10},			--2级影响
		[3] = {value = -10, per = -10},			--3级影响
		[4] = {value = -10, per = -10},			--4级影响
		[5] = {value = -10, per = -10},			--5级影响
		[6] = {value = -10, per = -10},			--6级影响
		[7] = {value = -10, per = -10},			--7级影响
		[8] = {value = -10, per = -10},			--8级影响
		[9] = {value = -10, per = -10},			--9级影响
		[10] = {value = -10, per = -10},		--10级减免
	},
}






--===========================================================
--被动类一般战术技能卡

--威吓
_tab_tactics[1002] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x16y5",
	name = "威吓",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 14002,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--练兵
_tab_tactics[1003] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x11y6",
	name = "练兵",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	--每局游戏额外获得经验
	expAdd =
	{
		value	= {0,0,0,0,0,0,0,0,0,0},		--增加值上限
		per	= {50,100,150,200,250,},		--增加百分比上限(填入实际值的100倍)
	},
}

--征收
_tab_tactics[1004] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x12y2",
	name = "征收",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	--每回合额外增加金钱 
	goldPerWave =
	{
		value	= {10,20,30,40,50,60,70,80,90,100},	--增加值上限
		per	= {0,0,0,0,0,0,0,0,0,0},		--增加百分比上限(填入实际值的100倍)
	},
}

--桃园结义
_tab_tactics[1005] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x2y8",
	name = "桃园结义",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 2,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 14003,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--箭矢改良
_tab_tactics[1006] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x8y1",
	name = "箭矢改良",
	unqiue = 1,
	level = 10,						--可升级上限
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 14004,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--炮塔
_tab_tactics[1007] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x9y10",
	name = "炮塔",
	unqiue = 1,
	level = 10,						--可升级上限
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 0,						--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--箭雨
_tab_tactics[1008] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:skill_icon_x3y11",
	name = "箭雨",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 0,						--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	
	activeSkill =						--主动释放的技能
	{
		id = 14005,					--技能id
		cd = {20,20,20,20,20,20,20,20,20,20},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND,		--施法类型
		effectRange = {200,200,200,200,200,200,200,200,200,200},--技能生效范围
		costMana = {20,20,20,20,20,20,20,20,20,20},	--技能资源消耗
	},
}



--===========================================================
--敌人增益类战术卡

--敌人生命加强
_tab_tactics[1201] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_01",
	name = "敌人生命加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 805,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人攻击加强
_tab_tactics[1202] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_03",
	name = "敌人攻击加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 806,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人装甲加强(前哨阵地专用)
_tab_tactics[1203] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_02",
	name = "敌人装甲加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 818,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人速度加强(前哨阵地专用)
_tab_tactics[1204] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_04",
	name = "敌人速度加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 819,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--我方速度降低(前哨阵地专用)
_tab_tactics[1205] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_05",
	name = "我方速度降低",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 820,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--我方生命降低(前哨阵地专用)
_tab_tactics[1206] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_07",
	name = "我方生命降低",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 821,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人生命加强(前哨阵地专用)
_tab_tactics[1207] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_01",
	name = "敌人生命加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 822,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人攻击加强(前哨阵地专用)
_tab_tactics[1208] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_03",
	name = "敌人攻击加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 823,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--敌人放火电毒加强(前哨阵地专用)
_tab_tactics[1209] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "ICON:SKILL_SET05_06",
	name = "敌人放火电毒加强",
	negative = true, --是否为负面效果
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	
	skillId = 824,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}




---------------------- 战车塔战术卡 ----------------------

--机枪塔升级
_tab_tactics[2000] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25400,
}

--散弹枪塔升级
_tab_tactics[2001] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25401,
}

--喷火枪塔升级
_tab_tactics[2002] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25402,
}

--透射枪塔升级
_tab_tactics[2003] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25403,
}

--雷神之锤塔升级
_tab_tactics[2004] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25404,
}

--冲击波塔升级
_tab_tactics[2005] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25405,
}

--毒枪塔升级
_tab_tactics[2006] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25406,
}

--反弹光线塔升级
_tab_tactics[2007] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25407,
}

--反弹光球塔升级
_tab_tactics[2008] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25408,
}

--缩小枪塔升级
_tab_tactics[2009] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25409,
}


--宠物复活
_tab_tactics[2100] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "宠物",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 25046,
}


---------------------------------------------------
--大菠萝战术卡
--[[
--废料回收
_tab_tactics[3001] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "废料回收",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30043,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
}

--聚能装甲
_tab_tactics[3002] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill2.png",
	name = "聚能装甲",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30041,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30058,
}

--战术提升
_tab_tactics[3003] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill3.png",
	name = "战术提升",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30042,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30063,
}

--自动导弹
_tab_tactics[3004] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill4.png",
	name = "复仇",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30048,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30059,
}

--手雷冷却
_tab_tactics[3005] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill7.png",
	name = "装甲",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30001,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30060,
}

--移速
_tab_tactics[3006] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill6.png",
	name = "移速",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30003,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30061,
}

--伤害
_tab_tactics[3007] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill9.png",
	name = "伤害",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30004,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30065,
}

--暴击
_tab_tactics[3008] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill8.png",
	name = "暴击",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	skillId = 30005,					--给英雄，塔，敌方附加的各种效果,在添加角色是生效(技能类型必须是AUTO)  --zhenkira 修改注释
	removeskillId = 30062,
}
]]





---------------------- 战车道具战术卡 ----------------------
_tab_tactics[5001] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n4.png",
	name = "追踪导弹",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12013,
	debrisItemId = 15204,	--碎片道具id
}

_tab_tactics[5002] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n2.png",
	name = "召唤机枪塔",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12014,
	debrisItemId = 15202,	--碎片道具id
}

_tab_tactics[5003] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n5.png",
	name = "护盾",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12015,
	debrisItemId = 15205,	--碎片道具id
}

_tab_tactics[5004] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n1.png",
	name = "核爆",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12016,
	debrisItemId = 15201,	--碎片道具id
}

_tab_tactics[5005] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n3.png",
	name = "召唤导弹塔",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12017,
	debrisItemId = 15203,	--碎片道具id
}

_tab_tactics[5006] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n6.png",
	name = "十字炸弹",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12018,
	debrisItemId = 15206,	--碎片道具id
}

_tab_tactics[5007] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n7.png",
	name = "卫星炮",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12019,
	debrisItemId = 15207,	--碎片道具id
}

_tab_tactics[5008] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n10.png",
	name = "群体冰冻",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12020,
	debrisItemId = 15210,	--碎片道具id
}

--[[
_tab_tactics[5009] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "核爆",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12026,
}
]]

_tab_tactics[5010] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n9.png",
	name = "延时炸弹",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12021,
	debrisItemId = 15209,	--碎片道具id
}

_tab_tactics[5011] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n11.png",
	name = "弹射球",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12022,
	debrisItemId = 15211,	--碎片道具id
}

_tab_tactics[5012] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n12.png",
	name = "黑洞",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12023,
	debrisItemId = 15212,	--碎片道具id
}

_tab_tactics[5013] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n8.png",
	name = "缩小",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12024,
	debrisItemId = 15208,	--碎片道具id
}

_tab_tactics[5014] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "effect/buff_n13.png",
	name = "巨浪",
	unqiue = 1,
	level = 30,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12025,
	debrisItemId = 15213,	--碎片道具id
}






------------------------------------------------------------------------------------------------------------
_tab_tactics[5015] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "陷阱",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12026,
}

_tab_tactics[5016] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "变身",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12027,
}

_tab_tactics[5017] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "枪塔过载",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12028,
}

_tab_tactics[5018] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "召唤铁人",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12029,
}
_tab_tactics[5019] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "改变数字",
	unqiue = 1,
	level = 10,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12030,
}
---------------------------------------------------------------------------------



--高射塔
_tab_tactics[5100] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "高射塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12100,
}

--激光塔
_tab_tactics[5101] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "激光塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12101,
}

--机枪塔
_tab_tactics[5102] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "机枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12102,
}

--炮台塔
_tab_tactics[5103] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "炮台塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12103,
}

--射击塔
_tab_tactics[5104] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "射击塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12104,
}

---------------------------------------------------------------------------------

--机枪塔
_tab_tactics[5200] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "机枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12200,
}

--散弹枪塔
_tab_tactics[5201] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "散弹枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12201,
}

--喷火枪塔
_tab_tactics[5202] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "喷火枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12202,
}

--透射枪塔
_tab_tactics[5203] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "透射枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12203,
}

--雷神之锤塔
_tab_tactics[5204] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "雷神之锤塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12204,
}

--冲击波塔
_tab_tactics[5205] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "冲击波塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12205,
}

--毒枪塔
_tab_tactics[5206] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "毒枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12206,
}

--障碍塔
_tab_tactics[5207] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "障碍塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12207,
}

--金属障碍
_tab_tactics[5208] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "金属障碍",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12208,
}

--反弹光线塔
_tab_tactics[5209] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "反弹光线塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12209,
}

--反弹光球塔
_tab_tactics[5210] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "反弹光球塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12210,
}

--缩小枪塔
_tab_tactics[5211] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "缩小枪塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12211,
}

--兵营塔
_tab_tactics[5212] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "兵营塔",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 12212,
}

--[[
--普通机枪
_tab_tactics[5100] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "普通机枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11000,
}

--散弹枪
_tab_tactics[5101] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "散弹枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11001,
}

--弹射枪
_tab_tactics[5102] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "弹射枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11002,
}

--火焰枪
_tab_tactics[5103] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "火焰枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11003,
}

--射线枪
_tab_tactics[5104] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "射线枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11004,
}

--闪电枪
_tab_tactics[5105] = {
	type = hVar.TACTICS_TYPE.OTHER,
	icon = "icon/skill/skill1.png",
	name = "闪电枪",
	unqiue = 1,
	level = 5,						--可升级上限
	quality = 1,						--品质颜色显示
	norepeat = true,					--是否不重复生效（英雄战术技能类型不应该受该值影响。只有自动释放产生附加效果的受此项影响。默认为false即可以重复生效） 2016.08.10 zhenkira
	itemId = 11005,
}
]]

