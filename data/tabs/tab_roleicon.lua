hVar.tab_roleicon = {}
local _tab_roleicon = hVar.tab_roleicon

--用于界面展示排序
hVar.tab_roleiconEx =
{
	1, 2, 3, 4, 27, --刘备,关羽,张飞,赵云,马超,
	28, 22, 23, 21, 34, 35, 25, 5, --黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,
	36, 6, 7, 9, 10, 11, --曹丕,夏侯敦,郭嘉,张辽,典韦,许褚,
	32, 14, 15, 33, 12, 13, --司马懿,贾诩,荀彧,甄姬,吕布,貂蝉,
	26, 30, 16, 31, 19, --董卓,孙坚,孙策,大乔,孙权,
	17, 18, 20, 8, 29, --周瑜,小乔,孙尚香,太史慈,陆逊,
	24, --甘宁,
}


--默认头像
_tab_roleicon[0] = {
	name = "默认头像",
	icon = "icon/head/tank_touxiang.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18001}, --需要获得指定英雄
	--unlockCondition = {"vip", 7}, --需要达到指定vip等级
}

--默认评论头像
_tab_roleicon[1] =
{
	name = "默认评论头像",
	icon = "misc/addition/tank_touxiang02.png",
	width = 72,
	height = 72,
}

--[[
--刘备头像
_tab_roleicon[1] =
{
	name = "刘备头像",
	icon = "icon/portrait/hero_liubei_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18001},
}

--关羽头像
_tab_roleicon[2] =
{
	name = "关羽头像",
	icon = "icon/portrait/hero_guanyu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18002},
}

--张飞头像
_tab_roleicon[3] =
{
	name = "张飞头像",
	icon = "icon/portrait/hero_zhangfei_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18003},
}

--赵云头像
_tab_roleicon[4] =
{
	name = "赵云头像",
	icon = "icon/portrait/hero_zhaoyun_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18008},
}

--曹操头像
_tab_roleicon[5] =
{
	name = "曹操头像",
	icon = "icon/portrait/hero_caocao_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18005},
}

--夏侯敦头像
_tab_roleicon[6] =
{
	name = "夏侯敦头像",
	icon = "icon/portrait/hero_xiahoudun_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18010},
}

--郭嘉头像
_tab_roleicon[7] =
{
	name = "郭嘉头像",
	icon = "icon/portrait/hero_guojia_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18007},
}

--太史慈头像
_tab_roleicon[8] =
{
	name = "太史慈头像",
	icon = "icon/portrait/hero_taishici_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18006},
}

--张辽头像
_tab_roleicon[9] =
{
	name = "张辽头像",
	icon = "icon/portrait/hero_zhangliao_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18014},
}

--典韦头像
_tab_roleicon[10] =
{
	name = "典韦头像",
	icon = "icon/portrait/hero_dianwei_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18016},
}

--许褚头像
_tab_roleicon[11] =
{
	name = "许褚头像",
	icon = "icon/portrait/hero_xuchu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18015},
}

--吕布头像
_tab_roleicon[12] =
{
	name = "吕布头像",
	icon = "icon/portrait/hero_lvbu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18011},
}

--貂蝉头像
_tab_roleicon[13] =
{
	name = "貂蝉头像",
	icon = "icon/portrait/hero_diaochan_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18012},
}

--贾诩头像
_tab_roleicon[14] =
{
	name = "贾诩头像",
	icon = "icon/portrait/hero_jiaxu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18029},
}

--荀彧头像
_tab_roleicon[15] =
{
	name = "荀彧头像",
	icon = "icon/portrait/hero_xunyu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18028},
}

--孙策头像
_tab_roleicon[16] =
{
	name = "孙策头像",
	icon = "icon/portrait/hero_sunce_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18018},
}

--周瑜头像
_tab_roleicon[17] =
{
	name = "周瑜头像",
	icon = "icon/portrait/hero_zhouyu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18019},
}

--小乔头像
_tab_roleicon[18] =
{
	name = "小乔头像",
	icon = "icon/portrait/hero_xiaoqiao_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18022},
}

--孙权头像
_tab_roleicon[19] =
{
	name = "孙权头像",
	icon = "icon/portrait/hero_sunquan_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18024},
}

--孙尚香头像
_tab_roleicon[20] =
{
	name = "孙尚香头像",
	icon = "icon/portrait/hero_sunshangxiang_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18031},
}

--徐庶头像
_tab_roleicon[21] =
{
	name = "徐庶头像",
	icon = "icon/portrait/hero_xushu_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18020},
}

--诸葛亮头像
_tab_roleicon[22] =
{
	name = "诸葛亮头像",
	icon = "icon/portrait/hero_zhugeliang_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18021},
}

--黄月英头像
_tab_roleicon[23] =
{
	name = "黄月英头像",
	icon = "icon/portrait/hero_huangyueying_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18023},
}

--甘宁头像
_tab_roleicon[24] =
{
	name = "甘宁头像",
	icon = "icon/portrait/hero_ganning_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18017},
}

--庞统头像
_tab_roleicon[25] =
{
	name = "庞统头像",
	icon = "icon/portrait/hero_pangtong_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18025},
}

--董卓头像
_tab_roleicon[26] =
{
	name = "董卓头像",
	icon = "icon/portrait/hero_dongzhuo_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18027},
}

--马超头像
_tab_roleicon[27] =
{
	name = "马超头像",
	icon = "icon/portrait/hero_machao_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18033},
}

--黄忠头像
_tab_roleicon[28] =
{
	name = "黄忠头像",
	icon = "icon/portrait/hero_huangzhong_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18032},
}

--陆逊头像
_tab_roleicon[29] =
{
	name = "陆逊头像",
	icon = "icon/portrait/hero_luxun_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18035},
}

--孙坚头像
_tab_roleicon[30] =
{
	name = "孙坚头像",
	icon = "icon/portrait/hero_sunjian_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18034},
}

--大乔头像
_tab_roleicon[31] =
{
	name = "大乔头像",
	icon = "icon/portrait/hero_daqiao_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18037},
}

--司马懿头像
_tab_roleicon[32] =
{
	name = "司马懿头像",
	icon = "icon/portrait/hero_simayi_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18036},
}

--甄姬头像
_tab_roleicon[33] =
{
	name = "甄姬头像",
	icon = "icon/portrait/hero_zhengji_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18046},
}

--孟获头像
_tab_roleicon[34] =
{
	name = "孟获头像",
	icon = "icon/portrait/hero_menghuo_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18041},
}

--祝融夫人头像
_tab_roleicon[35] =
{
	name = "祝融夫人头像",
	icon = "icon/portrait/hero_zhurongfuren_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18045},
}

--曹丕头像
_tab_roleicon[36] =
{
	name = "曹丕头像",
	icon = "icon/portrait/hero_caopi_s.png",
	width = 96,
	height = 96,
	unlockCondition = {"hero", 18038},
}
]]












--系统消息头像
_tab_roleicon[1000] =
{
	name = "系统消息头像",
	icon = "icon/head/broadcast_n.png",
	width = 56,
	height = 56,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏1）
_tab_roleicon[1001] =
{
	name = "系统军团头像（魏1）",
	icon = "icon/hero/boss_06.png",
	width = 180,
	height = 180,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏2）
_tab_roleicon[1002] =
{
	name = "系统军团头像（魏2）",
	icon = "icon/hero/pet_01.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀1）
_tab_roleicon[1003] =
{
	name = "系统军团头像（蜀1）",
	icon = "icon/hero/pet_02.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀2）
_tab_roleicon[1004] =
{
	name = "系统军团头像（蜀2）",
	icon = "icon/hero/pet_03.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴1）
_tab_roleicon[1005] =
{
	name = "系统军团头像（吴1）",
	icon = "icon/hero/pet_04.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--[[
--系统军团头像（吴2）
_tab_roleicon[1006] =
{
	name = "系统军团头像（吴2）",
	icon = "icon/hero/heros2_100.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏3）
_tab_roleicon[1007] =
{
	name = "系统军团头像（魏3）",
	icon = "icon/hero/heros2_83.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏4）
_tab_roleicon[1008] =
{
	name = "系统军团头像（魏4）",
	icon = "icon/hero/heros2_95.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀3）
_tab_roleicon[1009] =
{
	name = "系统军团头像（蜀3）",
	icon = "icon/hero/heros2_74.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀4）
_tab_roleicon[1010] =
{
	name = "系统军团头像（蜀4）",
	icon = "icon/hero/heros2_36.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴3）
_tab_roleicon[1011] =
{
	name = "系统军团头像（吴3）",
	icon = "icon/hero/heros2_39.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴4）
_tab_roleicon[1012] =
{
	name = "系统军团头像（吴4）",
	icon = "icon/hero/heros2_4.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏5）
_tab_roleicon[1013] =
{
	name = "系统军团头像（魏5）",
	icon = "icon/hero/heros2_85.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏6）
_tab_roleicon[1014] =
{
	name = "系统军团头像（魏6）",
	icon = "icon/hero/heros2_97.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀5）
_tab_roleicon[1015] =
{
	name = "系统军团头像（蜀5）",
	icon = "icon/hero/heros2_14.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀6）
_tab_roleicon[1016] =
{
	name = "系统军团头像（蜀6）",
	icon = "icon/hero/heros2_96.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴5）
_tab_roleicon[1017] =
{
	name = "系统军团头像（吴5）",
	icon = "icon/hero/heros1_30.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴6）
_tab_roleicon[1018] =
{
	name = "系统军团头像（吴6）",
	icon = "icon/hero/heros2_98.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏7）
_tab_roleicon[1019] =
{
	name = "系统军团头像（魏7）",
	icon = "icon/hero/heros2_90.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（魏8）
_tab_roleicon[1020] =
{
	name = "系统军团头像（魏8）",
	icon = "icon/hero/heros2_12.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀7）
_tab_roleicon[1021] =
{
	name = "系统军团头像（蜀7）",
	icon = "icon/hero/heros2_80.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（蜀8）
_tab_roleicon[1022] =
{
	name = "系统军团头像（蜀8）",
	icon = "icon/hero/heros2_10.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴7）
_tab_roleicon[1023] =
{
	name = "系统军团头像（吴7）",
	icon = "icon/hero/heros2_9.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}

--系统军团头像（吴8）
_tab_roleicon[1024] =
{
	name = "系统军团头像（吴8）",
	icon = "icon/hero/heros2_101.png",
	width = 96,
	height = 96,
	--unlockCondition = {"hero", 18027},
}
]]



