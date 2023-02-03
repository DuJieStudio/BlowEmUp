hVar.tab_shop = {}
local _tab_shop = hVar.tab_shop

--shop_type
--NORMAL = 0,--普通商店：goods里是固定商品列表，有多少下发多少
--AUTO_REFRESH = 1,--自动刷新商店goods是商品池，需要随机

--DB商城分页
_tab_shop[1] = {
	
	type = 1,				--类型(自动刷新商店)
	
	goodsNumMax = 6,			--每个玩家刷新3个商品（目前最大支持8个）
	quota = 3,				--每个商品限购数量(废弃)
	refreshTime = "23:59:59",		--每天固定时间刷新
	rmbRefreshCount = 8,			--每天可用金币刷新n次
	goods = {
		
		--只出武器枪碎片
		[1] =
		{
			rollCount = 2, --掉落池掉落次数
			totalValue = 0+40+20,					--总权值（固定商品列表的普通商店中无意义）
			
			--[[
			{value = 10,	shopItemId = 449, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 普通机枪碎片
			{value = 10,	shopItemId = 450, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 散弹枪碎片
			{value = 10,	shopItemId = 451, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 弹射枪碎片
			{value = 10,	shopItemId = 452, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火焰枪碎片
			{value = 10,	shopItemId = 453, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 射线枪碎片
			{value = 10,	shopItemId = 454, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 闪电枪碎片
			{value = 10,	shopItemId = 455, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 毒液枪碎片
			{value = 10,	shopItemId = 456, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 缩小枪碎片
			{value = 10,	shopItemId = 457, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 镭射枪碎片
			{value = 10,	shopItemId = 458, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 冲击枪碎片
			{value = 10,	shopItemId = 459, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火箭枪碎片
			{value = 10,	shopItemId = 460, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 导弹枪碎片
			]]
			
			{value = 4,	shopItemId = 492, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 普通机枪碎片*10
			{value = 4,	shopItemId = 493, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 散弹枪碎片*10
			{value = 4,	shopItemId = 494, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 弹射枪碎片*10
			{value = 4,	shopItemId = 495, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火焰枪碎片*10
			{value = 4,	shopItemId = 496, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 射线枪碎片*10
			{value = 4,	shopItemId = 497, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 闪电枪碎片*10
			{value = 4,	shopItemId = 498, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 毒液枪碎片*10
			{value = 4,	shopItemId = 499, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 缩小枪碎片*10
			{value = 4,	shopItemId = 500, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 镭射枪碎片*10
			{value = 4,	shopItemId = 501, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 冲击枪碎片*10
			--{value = 4,	shopItemId = 502, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火箭枪碎片*10
			--{value = 4,	shopItemId = 503, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 导弹枪碎片*10
			
			{value = 2,	shopItemId = 522, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 普通机枪碎片*50
			{value = 2,	shopItemId = 523, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 散弹枪碎片*50
			{value = 2,	shopItemId = 524, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 弹射枪碎片*50
			{value = 2,	shopItemId = 525, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火焰枪碎片*50
			{value = 2,	shopItemId = 526, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 射线枪碎片*50
			{value = 2,	shopItemId = 527, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 闪电枪碎片*50
			{value = 2,	shopItemId = 528, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 毒液枪碎片*50
			{value = 2,	shopItemId = 529, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 缩小枪碎片*50
			{value = 2,	shopItemId = 530, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 镭射枪碎片*50
			{value = 2,	shopItemId = 531, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 冲击枪碎片*50
			--{value = 2,	shopItemId = 532, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 火箭枪碎片*50
			--{value = 2,	shopItemId = 533, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 导弹枪碎片*50
			
			--vip专属商店商品
			vipShop =
			{
				--vip5商城
				[5] =
				{
					totalValue = 6,	--总权值
					{value = 4,	shopItemId = 651, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 普通机枪碎片*10
					{value = 2,	shopItemId = 652, quota = 1},		--value 单个商品权值, shopItemId 商品id --武器枪碎片 普通机枪碎片*50
				},
			}
		},
		
		--宠物碎片
		[2] =
		{
			rollCount = 1, --掉落池掉落次数
			totalValue = 0+16+8,					--总权值（固定商品列表的普通商店中无意义）
			
			--[[
			{value = 10,	shopItemId = 461, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 瓦力宠物碎片
			{value = 10,	shopItemId = 462, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 尤达宠物碎片
			{value = 10,	shopItemId = 463, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 支援战机宠物碎片
			{value = 10,	shopItemId = 464, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 刺蛇宝宝宠物碎片
			]]
			
			{value = 4,	shopItemId = 504, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 瓦力宠物碎片*10
			{value = 4,	shopItemId = 505, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 尤达宠物碎片*10
			{value = 4,	shopItemId = 506, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 支援战机宠物碎片*10
			{value = 4,	shopItemId = 508, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 刺蛇宝宝宠物碎片*10
			
			{value = 2,	shopItemId = 534, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 瓦力宠物碎片*50
			{value = 2,	shopItemId = 535, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 尤达宠物碎片*50
			{value = 2,	shopItemId = 536, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 支援战机宠物碎片*50
			{value = 2,	shopItemId = 537, quota = 1},		--value 单个商品权值, shopItemId 商品id --宠物碎片 刺蛇宝宝宠物碎片*50
		},
		
		--战术卡碎片
		[3] =
		{
			rollCount = 3, --掉落池掉落次数
			totalValue = 0+52+26,					--总权值（固定商品列表的普通商店中无意义）
			
			--[[
			{value = 10,	shopItemId = 465, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 核爆碎片
			{value = 10,	shopItemId = 466, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤机枪塔碎片
			{value = 10,	shopItemId = 467, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤导弹塔碎片
			{value = 10,	shopItemId = 468, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 追踪导弹碎片
			{value = 10,	shopItemId = 469, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 护盾碎片
			{value = 10,	shopItemId = 470, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 十字炸弹碎片
			{value = 10,	shopItemId = 471, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 卫星炮碎片
			{value = 10,	shopItemId = 472, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 缩小碎片
			{value = 10,	shopItemId = 473, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 延时炸弹碎片
			{value = 10,	shopItemId = 474, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 冰冻碎片
			{value = 10,	shopItemId = 475, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 弹射球碎片
			{value = 10,	shopItemId = 476, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 黑洞碎片
			{value = 10,	shopItemId = 477, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 巨浪碎片
			]]
			
			{value = 4,	shopItemId = 509, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 核爆碎片*10
			{value = 4,	shopItemId = 510, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤机枪塔碎片*10
			{value = 4,	shopItemId = 511, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤导弹塔碎片*10
			{value = 4,	shopItemId = 512, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 追踪导弹碎片*10
			{value = 4,	shopItemId = 513, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 护盾碎片*10
			{value = 4,	shopItemId = 514, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 十字炸弹碎片*10
			{value = 4,	shopItemId = 515, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 卫星炮碎片*10
			{value = 4,	shopItemId = 516, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 缩小碎片*10
			{value = 4,	shopItemId = 517, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 延时炸弹碎片*10
			{value = 4,	shopItemId = 518, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 冰冻碎片*10
			{value = 4,	shopItemId = 519, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 弹射球碎片*10
			{value = 4,	shopItemId = 520, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 黑洞碎片*10
			{value = 4,	shopItemId = 521, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 巨浪碎片*10
			
			{value = 2,	shopItemId = 538, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 核爆碎片*50
			{value = 2,	shopItemId = 539, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤机枪塔碎片*50
			{value = 2,	shopItemId = 540, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 召唤导弹塔碎片*50
			{value = 2,	shopItemId = 541, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 追踪导弹碎片*50
			{value = 2,	shopItemId = 542, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 护盾碎片*50
			{value = 2,	shopItemId = 543, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 十字炸弹碎片*50
			{value = 2,	shopItemId = 544, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 卫星炮碎片*50
			{value = 2,	shopItemId = 545, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 缩小碎片*50
			{value = 2,	shopItemId = 546, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 延时炸弹碎片*50
			{value = 2,	shopItemId = 547, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 冰冻碎片*50
			{value = 2,	shopItemId = 548, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 弹射球碎片*50
			{value = 2,	shopItemId = 549, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 黑洞碎片*50
			{value = 2,	shopItemId = 550, quota = 1},		--value 单个商品权值, shopItemId 商品id --战术卡碎片 巨浪碎片*50
		},
	},
}

--普通网络商店
_tab_shop[2] = {
	
	type = 0,				--类型(普通商店)
	
	goods = {
		345,				--红装锦囊
		410,				--兑换神器晶石
		430,				--红装锦囊*5
		431,				--兑换神器晶石*5
		438,				--黄装锦囊
		439,				--黄装锦囊*5
		
		--新商店出售商品
		441,				--神器宝箱抽一次
		442,				--神器宝箱抽十次
		443,				--战术卡抽一次
		444,				--战术卡抽十次
		445,				--神器宝箱免费抽一次
		446,				--神器宝箱免费抽十次
		447,				--战术卡免费抽一次
		448,				--战术卡免费抽十次
		
		498,				--兑换神器晶石*10
		499,				--兑换神器晶石*50
	},
}

--藏宝图商店
_tab_shop[3] = {
	
	type = 23,				--类型(藏宝图商店)
	
	goods = {
		412,				--藏宝图抽一次
	},
}

--高级藏宝图商店
_tab_shop[4] = {
	
	type = 24,				--类型(高级藏宝图商店)
	
	goods = {
		413,				--高级藏宝图抽一次
	},
}
