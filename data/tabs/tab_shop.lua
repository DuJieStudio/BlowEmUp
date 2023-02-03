hVar.tab_shop = {}
local _tab_shop = hVar.tab_shop

--shop_type
--NORMAL = 0,--普通商店：goods里是固定商品列表，有多少下发多少
--AUTO_REFRESH = 1,--自动刷新商店goods是商品池，需要随机

--DB商城分页
_tab_shop[1] = {
	
	type = 1,				--类型(自动刷新商店)
	
	goodsNumMax = 6,			--每个玩家刷新3个商品（目前最大支持6个）
	quota = 3,				--每个商品限购数量(废弃)
	refreshTime = "23:59:59",		--每天固定时间刷新
	rmbRefreshCount = 8,			--每天可用金币刷新n次
	goods = {
		--客户端不需要此数据
		--[[
		totalValue = 135,					--总权值（固定商品列表的普通商店中无意义）
		{value = 7,	shopItemId = 351, quota = 2},		--value 单个商品权值, shopItemId 商品id --象兵10507
		{value = 7,	shopItemId = 352, quota = 2},		--value 单个商品权值, shopItemId 商品id --虎豹骑10509
		{value = 7,	shopItemId = 353, quota = 2},		--value 单个商品权值, shopItemId 商品id --爆炎10512
		{value = 7,	shopItemId = 354, quota = 2},		--value 单个商品权值, shopItemId 商品id --力士10504
		{value = 7,	shopItemId = 355, quota = 2},		--value 单个商品权值, shopItemId 商品id --自爆兵10505
		{value = 7,	shopItemId = 356, quota = 2},		--value 单个商品权值, shopItemId 商品id --箭雨10506
		{value = 7,	shopItemId = 357, quota = 2},		--value 单个商品权值, shopItemId 商品id --护城弩手10508
		{value = 7,	shopItemId = 358, quota = 2},		--value 单个商品权值, shopItemId 商品id --护城卫士10513
		{value = 7,	shopItemId = 359, quota = 2},		--value 单个商品权值, shopItemId 商品id --狗雨10514
		{value = 7,	shopItemId = 360, quota = 2},		--value 单个商品权值, shopItemId 商品id --表情力士10515
		{value = 7,	shopItemId = 361, quota = 2},		--value 单个商品权值, shopItemId 商品id --天网10517
		{value = 7,	shopItemId = 362, quota = 2},		--value 单个商品权值, shopItemId 商品id --捕兽夹10518
		{value = 3,	shopItemId = 363, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 刘备10201
		{value = 3,	shopItemId = 364, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 关羽10202
		{value = 3,	shopItemId = 365, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 张飞10203
		{value = 3,	shopItemId = 366, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 赵云10208
		{value = 3,	shopItemId = 367, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 曹操10205
		{value = 3,	shopItemId = 368, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 夏侯惇10210
		{value = 3,	shopItemId = 369, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 郭嘉10207
		{value = 3,	shopItemId = 370, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 太史慈10206
		--{value = 3,	shopItemId = 371, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 甘宁10217
		{value = 3,	shopItemId = 372, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 吕布10211
		{value = 3,	shopItemId = 373, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 貂蝉10212
		{value = 3,	shopItemId = 375, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 张辽10214
		{value = 3,	shopItemId = 376, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 许褚10215
		{value = 3,	shopItemId = 377, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 典韦10216
		{value = 3,	shopItemId = 374, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 孙策10218
		{value = 3,	shopItemId = 378, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 周瑜10219
		{value = 3,	shopItemId = 379, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 徐庶10220
		{value = 3,	shopItemId = 380, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 诸葛亮10221
		--{value = 3,	shopItemId = 381, quota = 1},		--value 单个商品权值, shopItemId 商品id --英雄将魂 小乔10222
		]]
		
	},
}

--普通网络商店
_tab_shop[2] = {
	
	type = 0,				--类型(普通商店)
	
	goods = {
		345,				--红装锦囊
	},
}