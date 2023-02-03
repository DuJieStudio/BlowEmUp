









g_activity_list = {}
g_NetShopData = {
	BuyLimit = {
		[9004] = 0,
		[9005] = 0,
		[9006] = 0,
	}
}

--所有商店的联网逻辑全部放在这里(收到网络回调时走这里)
hGlobal.UI.InitNetShopLogic = function()
	--通过监听设置活动表数据
	hGlobal.event:listen("LocalEvent_Set_activity_list","SetActivityList",function(activity_liset)
		g_activity_list = {}
		if type(activity_liset) == "table" and #activity_liset > 0 then
			g_activity_list = activity_liset
		end
		hGlobal.event:event("LocalEvent_Set_activity_refresh",1)
	end)
	
	--设置3种宝箱的购买上限数值
	hGlobal.event:listen("LocalEvent_getNetChestNum","_shop_get_n",function(NumTab)
		if type(NumTab) == "table" then
			g_NetShopData.BuyLimit[9004] = NumTab.chest_cuprum
			g_NetShopData.BuyLimit[9005] = NumTab.chest_silver
			g_NetShopData.BuyLimit[9006] = NumTab.chest_gold
		end
	end)
end

--特殊的图标大小
local __NSP__ItemIconXYWH = {
	[9004] = {0,0,64,64},	--青铜宝箱
	[9005] = {0,0,64,64},	--白银宝箱
	[9006] = {0,0,64,64},	--黄金宝箱
	[9007] = {0,0,32,32},	--皮革
	[9008] = {0,0,32,32},	--玄铁
	[9009] = {0,0,38,38},	--炎晶
	[9011] = {0,0,48,48},	--水晶
}

--红色装备图标偏移
local __NSP__EliteItemIconXYWH = {
	[8000] = {5,0,64,64},	--太平要术
	[8007] = {0,-4,64,64},	--麒麟心
	[8009] = {-4,0,64,64},	--白银狮子头
	[8203] = {-2,4,60,60},	--神鹰令
	[8013] = {5,0,64,64},	--雌雄双剑
	[8001] = {-4,0,64,64},	--七星刀
	[8015] = {-2,0,60,60},	--金乌落炎
	[8202] = {9,0,64,64},	--贪狼
	[8020] = {6,0,62,62},	--青龙偃月刀
	[8021] = {-5,0,60,60},	--丈八蛇矛
	[8002] = {-7,0,64,64},	--方天画戟
	[8005] = {0,-3,60,60},	--黑风双链

	[8018] = {5,0,64,64},	--恶鬼锤
	[8022] = {5,-5,60,60},	--倚天剑
	[8003] = {-10,0,60,60},	--九天
	[8012] = {-10,0,64,64},	--寒菲
	[8025] = {-10,-5,64,64},--龙胆枪
	[8026] = {8,-4,60,60},	--干将
	[8027] = {8,-4,60,60},	--莫邪

	[8041] = {0,-8,64,64},	--疾风靴
}

--VIP红装
local __NSP__VipEliteItem = {
	[8200] = 1,		--校尉重铠
	[8201] = 1,		--炎雀指环
	[8203] = 1,		--神鹰令
	[8202] = 1,		--贪狼
	[8204] = 1,		--绝影
	[8020] = 1,		--青龙刀
}

--即使没有网络这些也是人气商品
local __NSP__HotItemState = {
	--[9103] = 2,	--新手特惠包
	--[9105] = 2,		--横扫千军包
	[9917] = 2,		--红装锦囊
	
	[9006] = 1,		--黄金宝箱
	--[9017] = 1,		--吕布
}

local __NSP__tFunc = {
	GetExPrice = function(tActivityData,sPriceKey)
		if tActivityData and tActivityData[1] and tActivityData[1][sPriceKey]~=nil then
			return tActivityData[1][sPriceKey]
		end
		--return 999	--测试
	end,
}

local __NSP__UIFunc = {
	GetItemActvityData = function(nShopItemID,nItemID)
		if nShopItemID==0 then
			return
		end
		if g_cur_net_state~=1 then
			return
		end
		if type(g_activity_list)~="table" then
			return
		end
		if type(nItemID)~="number" then
			return
		end
		local tabSI = hVar.tab_shopitem[nShopItemID]
		local tActivityData
		for i = 1,#g_activity_list do
			local v = g_activity_list[i]
			
			if v.id==304 or v.id==305 or v.id==306 or v.id == 307 or v.id == 308 then
				--白银宝箱/黄金宝箱/炎晶打折专用活动
				if v.itemID==tabSI.itemID then
					tActivityData = tActivityData or {}
					tActivityData[1] = v
				end
			elseif v.id==303 then
				--活动图标
				if v.ShopItemID==tabSI.itemID then
					tActivityData = tActivityData or {}
					tActivityData[303] = v
				end
			end
		end
		return tActivityData
	end,
	GetItemIcon = function(nShopItemID,nItemID,tActivityData,mode)
		if type(nItemID)~="number" then
			return 0
		end
		local tabI = hVar.tab_item[nItemID]
		if tabI==nil then
			return 0
		elseif mode=="bg" then
			if tabI.type==hVar.ITEM_TYPE.HEROCARD then
				return 0
			end
			local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
			if tabM then
				return tabM.BORDERMODEL
			else
				return hVar.ITEMLEVEL[1].BORDERMODEL
			end
		else
			if tabI.icon~=nil then
				local p = __NSP__ItemIconXYWH[nItemID]
				if p then
					return tabI.icon,p[1],p[2],p[3],p[4]
				else
					return tabI.icon
				end
			end
		end
		return 0
	end,
	GetItemName = function(nShopItemID,nItemID)
		if type(nItemID)~="number" then
			return 0
		end
		local tabI = hVar.tab_item[nItemID]
		local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
		if tabM then
			local tabE = hVar.ITEM_ELITE_LEVEL[tabI.elite or 0]
			if tabE then
				return hVar.tab_stringI[nItemID][1] or tostring(nItemID),tabE.NAMERGB
			else
				return hVar.tab_stringI[nItemID][1] or tostring(nItemID),tabM.NAMERGB
			end
		else
			return hVar.tab_stringI[nItemID][1] or tostring(nItemID),hVar.ITEMLEVEL[1].NAMERGB
		end
	end,
	
	--获取price的图标或数字   changed by pangyong 2015/4/28
	GetItemPrice = function(nShopItemID,nItemID,tActivityData,tKeyParam,tResult)
		if nShopItemID == 0 or type(nItemID)~="number" then
			return 0
		end
		local sPriceKey = tKeyParam[1]
		local sPriceKeyII = tKeyParam[2]
		local tExResult = tKeyParam[3]
		--当KeyII指定的价格为0时，设置额外返回值(判断消耗积分或游戏币是否为0，为零则只显示一个价格，所以要进行位置调整)
		local p1,p2,p3,p4
		if sPriceKeyII and type(tExResult)=="table" and (hVar.tab_shopitem[nShopItemID][sPriceKeyII] or 0)==0 then
			p1,p2,p3,p4 = unpack(tExResult)
		end
		--获取基本数值
		local nNum = (hVar.tab_shopitem[nShopItemID][sPriceKey] or 0)
		local vRet = nil
		--根据模式进行扩展
		if (tResult or 0)~=0 then
			if tResult[1]==1 then
				--模式1,参考基本价格
				if nNum~=0 then
					vRet = tResult[2] or tostring(nNum)					--tResult[2]为nil,返回数值，创建label；	tResult[2]为字符串，则返回字符串，创建图标
				else
					vRet = tResult[3] or 0							--Result[3]如果有自定义的值，则返回值，否则返回0（nNum）
				end
			elseif tResult[1]==2 then
				--模式2,参考扩展价格
				if nNum~=0 then
					local nNumEx = __NSP__tFunc.GetExPrice(tActivityData,sPriceKey) or 0
					if nNumEx~=0 and nNumEx~=nNum then
						vRet = tResult[2] or tostring(nNumEx)
					else
						vRet = tResult[3] or tostring(nNumEx)
					end
				else
					--基本价格等于0的话，无论怎样都返回后面的
					vRet = tResult[3] or 0
				end
			end
		end
		if vRet~=nil then
			return vRet,p1,p2,p3,p4
		else
			return tostring(nNum),p1,p2,p3,p4
		end
	end,
	
	--geyachao: 获得该商品今日还可以购买的次数
	GetItemTodayLimit = function(nShopItemID, nItemID, tActivityData)
		local t = hVar.NET_SHOP_ITEM["Page_Item"] or {}
		for i = 1, #t, 1 do
			if (t[i][1] == nShopItemID) then --找到了
				local limitMax = t[i][2] or -1
				if (limitMax > 0) then
					--print("GetItemLimit", nShopItemID, limitMax)
					--读取今日某商品购买的次数限制
					local num = LuaGetTodayShopItemLimitCount(g_curPlayerName, nShopItemID, limitMax)
					--print(num)
					if (num < 9999) then --次数太长界面显示不下
						return ("x" .. num)
					else
						return ""
					end
				end
				
				break
			end
		end
		
		return ""
	end,
	
	GetItemHotIcon = function(nShopItemID,nItemID,tActivityData,tParam)
		if type(nItemID)~="number" then
			return 0
		end
		local nState = 0
		if tActivityData and tActivityData[303] then
			nState = tActivityData[303].ShopItemState
		else
			if __NSP__HotItemState[nItemID] then
				nState = __NSP__HotItemState[nItemID]
			end
		end
		if nState~=0 and tParam[nState] then
			return unpack(tParam[nState])
		else
			return 0
		end
	end,
	
	--获取英雄令购买锁
	GetItemLock = function(nShopItemID,nItemID,tActivityData,tParam)
		if nShopItemID==0 or type(nItemID)~="number" then
			return 0
		end

		--翻页到英雄令购买页
		if nItemID and hVar.tab_item[nItemID].type == hVar.ITEM_TYPE.HEROCARD then
			return tParam	--此处仅在英雄令页面无条件地设置购买锁，是否显示则在页面切换函数中进行设置
		else
			return 0
		end
	end,

	--获取积分与游戏币之间的分界线
	GetItemLines = function(nShopItemID,nItemID,tActivityData,tKeyParam,tResult)
		if nShopItemID==0 or type(nItemID)~="number" then
			return 0
		end
		local sPriceKey = tKeyParam[1]
		local sPriceKeyII = tKeyParam[2]
		if 0 == (hVar.tab_shopitem[nShopItemID][sPriceKey] or 0) or 0 == (hVar.tab_shopitem[nShopItemID][sPriceKeyII] or 0) then
			return tResult[2]
		else
			return tResult[1]
		end
	end,
}

--获得玩家的收集品
hApi.GetPlayerCollection = function(nItemID)
	
end

local __tCollectionMaxNum = {50,100,200}
local __tCollectionColor = {
	{0,{128,128,128}},
	{25,{60,220,60}},
	{50,{220,220,0}},
	{75,{255,0,0}},
}
local __tCollectionTab = {}
hApi.GetPlayerCollectionString = function(nItemID,sType)
	if __tCollectionTab[nItemID]==nil then
		__tCollectionTab[nItemID] = {}
		__tCollectionTab[nItemID].level = 1
		__tCollectionTab[nItemID].num = 0--hApi.random(0,__tCollectionMaxNum[__tCollectionTab[nItemID].level])
	end
	local tItemData = __tCollectionTab[nItemID]
	if sType=="progress" then
		local nMax = __tCollectionMaxNum[tItemData.level]
		local nNum = tItemData.num
		local nPec = math.floor(100*nNum/nMax)
		local s = nPec.."%["..nNum.."/"..nMax.."]"
		for i = #__tCollectionColor,1,-1 do
			if nPec>=__tCollectionColor[i][1] then
				return s,__tCollectionColor[i][2]
			end
		end
		return s
	elseif sType=="level" then
		return "lv"..tItemData.level
	end
end

hGlobal.UI.InitNetShopFramII = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowNetShopEx","__show"}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _NSP_TipTokenItem = {{0,1,{0,0}}}		--点了商店里面的东西以后显示这个物品
	local _NSP_ShopItemCoodown = {			--买了这个里面的东西会产生冷却，一段时间内无法在买东西
		tick = 0,
		[9101] = 1000,
		[9102] = 1000,
	}
	local _NSP_ShopItemBuyLock = {}			--购买道具的话会锁住这个按钮，直到购买成功才解锁(关闭商店界面也会解锁)
	local _NSP_EliteItemCount = {}			--统计玩家拥有的红装数量
	_CODE_SwitchItemPage = hApi.DoNothing --geyachao: todo local去掉了，在别的模块里也调用这个函数
	local _CODE_HitItemPage = hApi.DoNothing
	local _CODE_DragItemPage = hApi.DoNothing
	local _CODE_DropItemPage = hApi.DoNothing
	local _CODE_NewPageItemUI = hApi.DoNothing
	local _CODE_GetPageItemUI_ByItemID = hApi.DoNothing
	local _CODE_UpdateItemPageGridItem = hApi.DoNothing
	local _CODE_SkipUpdateItemPageGridItem = hApi.DoNothing
	local _CODE_EnableItemPageUI = hApi.DoNothing
	local _CODE_ClickBuyItemBtn = hApi.DoNothing
	local _CODE_ClickBuyItemBtn_Rune = hApi.DoNothing --点击购买每日商店出售的商品
	local _CODE_ItemPageGetItemID = hApi.DoNothing
	local _CODE_OnCloseShop = hApi.DoNothing --关闭商店
	local _CODE_RefreshItemTodayBuyTimesUI = hApi.DoNothing --刷新商品几日购买次数(page 1)
	local _CODE_EnableItemPageHeroLockUI = hApi.DoNothing --激活英雄令购买锁(page 2)
	local _CODE_RefreshItemPageRuneUI = hApi.DoNothing --刷新每日商店出售的商品(page 3)
	local _CODE_timer_refresh_PageRune = hApi.DoNothing --刷新每日商店倒计时timer
	local _CODE_CheckHintTanHaoVisible = hApi.DoNothing --检测提示今日商店商品刷新的叹号动态提示箭头是否显示
	local _CODE_OnClickRefreButton = hApi.DoNothing --点击刷新每日商店按钮
	
	local _CODE_HideShopItemTip = function()
		_NSP_TipTokenItem[1][1] = 0
		hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
	end
	local _NSP_FrmXYWH = {hVar.SCREEN.w/2 - 440,hVar.SCREEN.h/2 + 310,880,664}
	local _NSP_HeadXY = {10,-40}
	local _NSP_ItemPage_ClippingRect = {0,-132,880,528,0}
	local _NSP_ItemPage_DragRect = {80,-230,0,0}
	local _NSP_ItemPage_GridAlign = {"V","*",30,0,-30}
	local _NSP_ItemPage_Current = 0
	local _NSP_ItemPage = {}
	local _NSP_IsFlushed = 0
	local _cur_rmb = 0
	local tPage =
	{
		{"Page_Guide",		"ShopItem",	{model="UI:hot_item"}, hVar.tab_string["__TEXT_Page_Guide"],}, --geyachao: 引导专用出售的商品
		{"Page_Item",		"ShopItem",	{model="UI:equip_item"}, hVar.tab_string["__TEXT_Page_Item"],},
		{"Page_Equip",		"ShopItem",	{model="UI:expendable_item"}, hVar.tab_string["__TEXT_Page_Equip"],},
		{"Page_HeroCard",	"ShopItem",	{model="UI:button_card"}, hVar.tab_string["__TEXT_Page_HeroCard"],},
		{"Page_Rune",		"RuneItem",	{model="ui/bs_btn.png"}, hVar.tab_string["__TEXT_Page_Rune"],},
		{"Page_Elite",		"EliteItem",	{model="UI:button_illustration"}, hVar.tab_string["__TEXT_Page_Elite"],},
	}
	for i = 1,#tPage do
		if hVar.NET_SHOP_ITEM[tPage[i][1]]~=nil then
			_NSP_ItemPage[#_NSP_ItemPage+1] = tPage[i]
		end
	end
	local _NSP_PageItemUIHandle = {}
	local _NSP_MemoryWarning = 0			--内存警告时，会删掉更多的UI
	local _NSP_PageItemUI_ReloadOnUpdate = {	--如果活动发生了变更，这里面的UI会被删掉重新创建一遍
		["_itemScore_xg_Line"] = 1,
		["_itemScore_xg_Num"] = 1,
		["_itemRMB_xg_Line"] = 1,
		["_itemRMB_xg_Num"] = 1,
		["_itemHotIcon"] = 1,
		["_eliteSlot"] = 1,
		["_eliteItem"] = 1,
	}
	local Language_Shop_UI_fSize = {--不同语言版本字号修正
		["_itemName"] = {29,26}
	}
	local Language_Shop_UI_fPos = {--不同语言版本位置修正
		["_itemName"] = {{112,44},{106,50}}
	}
	local fSizeIndex = 1
	if LANGUAG_SITTING ~= nil then
		if LANGUAG_SITTING == 1 or LANGUAG_SITTING == 2 or LANGUAG_SITTING == 3 then
			fSizeIndex = 1
		elseif LANGUAG_SITTING == 4 then
			fSizeIndex = 2
		end
	end
	
	local _NSP_PageItemUI = {
		["ShopItem"] = {
			--基本参数
			data = {mode="shopitem",cols=3,ox=-80,oy=-4,grid={
				x = 80,
				y = -212,
				gridW = 289,
				gridH = 176,
			}},
			--背景槽
			{"image","_slotBG","UI:shopItemBG1",{62,-12,266,178}},
			--游戏币分界线
			{"image","_itemLine",{__NSP__UIFunc.GetItemLines,{"score", "rmb"},{"UI:ItemLine", 0}},{108,0,144,5}},
			--图标框
			{"image","_itemBG",{__NSP__UIFunc.GetItemIcon,"bg"},{0,0,66,66}},
			--图标
			{"image","_itemIcon",{__NSP__UIFunc.GetItemIcon,"icon"},{0,0,64,64}},
			--物品名字
			{"label","_itemName",{__NSP__UIFunc.GetItemName},{Language_Shop_UI_fPos["_itemName"][fSizeIndex][1],Language_Shop_UI_fPos["_itemName"][fSizeIndex][2],Language_Shop_UI_fSize["_itemName"][fSizeIndex],1,"MC",hVar.FONTC}},
			--物品消耗积分（"rmb"：用于检测游戏币的消耗量。0,-16：特定条件下位置调整参数）   changed by pangyong 2015/4/28
			{"label","_itemScore",{__NSP__UIFunc.GetItemPrice,		{"score","rmb",{nil,0,-16}},		{1,nil,0}},				{88,14,24,0,"LC"}},
			{"image","_itemScoreIcon",{__NSP__UIFunc.GetItemPrice,		{"score","rmb",{0,-16,24,24}},		{1,"UI:score",0}},			{63,14,24,24}},		--物品消耗积分图标
			{"image","_itemScore_xg_Line",{__NSP__UIFunc.GetItemPrice,	{"score","rmb",{0,-16,40,18}},		{2,"UI:shopitemxg",0}},			{102,14,40,18,9}},	--物品消耗RMB_xg_擦除线
			{"label","_itemScore_xg_Num",{__NSP__UIFunc.GetItemPrice,	{"score","rmb",{nil,0,-16}},		{2,nil,0}},				{138,14,24,0,"LC"}},		--物品消耗RMB_xg_数字
			--物品消耗RMB（"score"：用于检测游戏币的消耗量。0,16：特定条件下位置调整参数）
			{"label","_itemRMB",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{nil,0,16}},		{1,nil,0}},				{88,-18,24,0,"LC"}},
			{"image","_itemRMBIcon",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{0,16,40,40}},		{1,"UI:game_coins",0}},			{63,-18,40,40}},	--物品消耗RMB图标
			{"image","_itemRMB_xg_Line",{__NSP__UIFunc.GetItemPrice,	{"rmb","score",{0,16,40,18}},		{2,"UI:shopitemxg",0}},			{102,-18,40,18,9}},	--物品消耗RMB_xg_擦除线
			{"label","_itemRMB_xg_Num",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{nil,0,16}},		{2,nil,0}},				{138,-18,24,0,"LC"}},	--物品消耗RMB_xg_数字
			
			--物品活动图标
			{"image","_itemHotIcon",{__NSP__UIFunc.GetItemHotIcon,{{"UI:shopitemhot",-34,54,-1,42},{"UI:shopitemnew",-34,54,-1,42},{"UI:shopitemoff",-34,54,-1,42},{"UI:discount_02_en",-18,52,-1,56}}},{0,0,96,-1}},
			--物品购买按钮
			{"button","_itemBuyBtn","UI:shopItemBGBuy",{88,-58,-1,42,0.9},function(...) return _CODE_ClickBuyItemBtn(...) end},
			--设置道具锁（针对英雄卡）  added by pangyong 2015/3/5 
			{"image","_itemLock",{__NSP__UIFunc.GetItemLock,"UI:LOCK"},{185,-75,40,40,2}},
			{"label","_itemLimit",{__NSP__UIFunc.GetItemTodayLimit,		{"score","rmb",{nil,0,-16}},{nil,0,-16}},{-26,-60,22,0,"LC", "numWhite"}},
			
		},
		
		--每日商城商品
		["RuneItem"] = {			--*******现已作废，如有需要，需更改下面GetItemPrice的使用方式
			--基本参数
			data = {mode="shopitem",cols=3,ox=-80,oy=-4,grid={
				x = 80,
				y = -212,
				gridW = 289,
				gridH = 176,
			}},
			
			--背景图
			--{"image","_slotBG","UI:shopItemBG1",{62,-12,266,178}},
			{"image","_slotBG","UI:ChestBag_1", {62, -40, 303, 103}},
			
			--商品图标背景框
			{"imageX","_itemBGX", {__NSP__UIFunc.GetItemIcon, "bg"}, {-10, 20, 68, 68}},
			
			--商品图标
			{"imageX", "_itemIconX",{__NSP__UIFunc.GetItemIcon,"icon"}, {-10, 20, 64 ,64}},
			
			--碎片图标
			{"image", "_itemDebrisIcon", "UI:SoulStoneFlag", {10, 6, 38 ,55}},
			
			--商品名字
			{"labelX", "_itemNameX", "", {100, 33, 30, 1, "MC", hVar.FONTC}},
			{"labelX", "_itemName_SmallX", "", {110, 33, 26, 1, "MC", hVar.FONTC}},
			
			--商品碎片的数量
			{"labelX", "_itemDebrisNumX", "", {110 - 10, 0, 30, 1, "MC", hVar.FONTC}},
			
			--物品消耗积分（"rmb"：用于检测游戏币的消耗量。0,-16：特定条件下位置调整参数）   changed by pangyong 2015/4/28
			{"label","_itemScore",{__NSP__UIFunc.GetItemPrice,		{"score","rmb",{nil,0,-16}},		{1,nil,0}},				{88,14,24,0,"LC"}},
			{"image","_itemScoreIcon",{__NSP__UIFunc.GetItemPrice,		{"score","rmb",{0,-16,24,24}},		{1,"UI:score",0}},			{63,14,24,24}},		--物品消耗积分图标
			{"image","_itemScore_xg_Line",{__NSP__UIFunc.GetItemPrice,	{"score","rmb",{0,-16,40,18}},		{2,"UI:shopitemxg",0}},			{102,14,40,18,9}},	--物品消耗RMB_xg_擦除线
			{"label","_itemScore_xg_Num",{__NSP__UIFunc.GetItemPrice,	{"score","rmb",{nil,0,-16}},		{2,nil,0}},				{138,14,24,0,"LC"}},		--物品消耗RMB_xg_数字
			
			--物品消耗RMB（"score"：用于检测游戏币的消耗量。0,16：特定条件下位置调整参数）
			{"labelX","_itemRMBX",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{nil, 5 - 40, -76 - 1}},		{1,nil,0}},				{88,-18, 30, 1,"LC"}},
			{"image","_itemRMBIcon",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{5 - 40, -76, 48, 48}},		{1,"UI:game_coins",0}},			{63,-18,40,40}},	--物品消耗RMB图标
			{"image","_itemRMB_xg_Line",{__NSP__UIFunc.GetItemPrice,	{"rmb","score",{5 - 40, -76, 40, 18}},		{2,"UI:shopitemxg",0}},			{102,-18,40,18,9}},	--物品消耗RMB_xg_擦除线
			{"label","_itemRMB_xg_Num",{__NSP__UIFunc.GetItemPrice,		{"rmb","score",{nil, 5 - 40, -76}},		{2,nil,0}},				{138,-18,26,1,"LC"}},	--物品消耗RMB_xg_数字
			
			--物品活动图标
			{"image","_itemHotIcon",{__NSP__UIFunc.GetItemHotIcon,{{"UI:shopitemhot",-34,54,-1,42},{"UI:shopitemnew",-34,54,-1,42},{"UI:shopitemoff",-34,54,-1,42},{"UI:discount_02_en",-18,52,-1,56}}},{0,0,96,-1}},
			
			--商品购买按钮
			{"button" , "_itemBuyBtn", "UI:Btn_DH", {160, -83, 90, 90, 0.98}, function(...) return _CODE_ClickBuyItemBtn_Rune(...) end},
			
			--商品可购买次数
			{"label","_itemLimitPrefix", "可兑换次数：", {-50, -43 ,24, 1, "LC", hVar.FONTC}},
			{"labelX", "_itemLimitX", "", {110, -43 ,22, 0, "RC", "numWhite"}},
			
		},
		
		["EliteItem"] = {
			--基本参数
			data = {mode="item",cols=10,ox=-28,oy=-4,grid={
				x = 38,
				y = -190,
				gridW = 85,
				gridH = 130,
			}},
			--背景槽
			{"image","_pageflag",{function(_,nItemID)
				if nItemID<=10 then
					return "ui/itempageflag"..nItemID..".png"
				else
					return 0
				end
			end},{0,-146,-1,-1,0}},
			--底框
			{"image","_eliteSlot",{function(_,nItemID)
				if nItemID<=10 then
					_CODE_SkipUpdateItemPageGridItem()
					return 0
				else
					local nCount = _NSP_EliteItemCount[nItemID] or 0
					local nStyle = 1
					if __NSP__VipEliteItem[nItemID]==1 then
						nStyle = 3
					end
					if nCount<=0 then
						return "ui/itempageslot"..nStyle..".png"
					else
						return "ui/itempageslot"..(nStyle+1)..".png"
					end
				end
			end},{0,-26,-1,-1,0}},
			--图标
			{"image","_eliteItem",{function(_,nItemID,_,tRGBII)
				local icon = __NSP__UIFunc.GetItemIcon(0,nItemID,"icon")
				if icon~=0 then
					local tRGB
					local nCount = _NSP_EliteItemCount[nItemID] or 0
					if nCount<=0 then
						tRGB = tRGBII
					end
					local tabI = hVar.tab_item[nItemID]
					if __NSP__EliteItemIconXYWH[nItemID] then
						local x,y,w,h = unpack(__NSP__EliteItemIconXYWH[nItemID])
						return icon,x,y,w,h,1,tRGB
					elseif tabI.type==hVar.ITEM_TYPE.ORNAMENTS then
						--装饰品
						return icon,0,-4,64,64,1,tRGB
					elseif tabI.type==hVar.ITEM_TYPE.BODY then
						--衣服
						return icon,-2,-2,64,64,1,tRGB
					elseif tabI.type==hVar.ITEM_TYPE.FOOT then
						--鞋子
						return icon,0,-2,64,64,1,tRGB
					--elseif tabI.type==hVar.ITEM_TYPE.HEAD then
						--头盔
						--return icon,0,0,64,64,1,tRGB
					--elseif tabI.type==hVar.ITEM_TYPE.WEAPON then
						--武器
						--return icon,0,0,64,64,1,tRGB
					else
						return icon,0,0,64,64,1,tRGB
					end
				else
					return 0
				end
			end,{128,128,128}},{0,0,64,64,1}},
		},
	}

	--手机模式调整
	--if g_phone_mode~=0 then
		_NSP_FrmXYWH = {hVar.SCREEN.w/2 - 440,hVar.SCREEN.h/2 + 240,880,524}
		_NSP_ItemPage_ClippingRect = {0,-132,880,388,0}
		_NSP_PageItemUI["ShopItem"].data.ox = -82
		_NSP_PageItemUI["ShopItem"].data.oy = -4
		_NSP_PageItemUI["ShopItem"].data.grid = {
			x = 80,
			y = -224,
			gridW = 289,
			gridH = 188,
		}
		_NSP_PageItemUI["RuneItem"].data.ox = -82
		_NSP_PageItemUI["RuneItem"].data.oy = -4
		_NSP_PageItemUI["RuneItem"].data.grid = {
			x = 80,
			y = -224,
			gridW = 289,
			gridH = 188,
		}
		_NSP_PageItemUI["EliteItem"].data.grid={
			x = 38,
			y = -190,
			gridW = 85,
			gridH = 120,
		}
	--end
	
	
	local _NSP_DefaultNumString = "..."
	local _NSP_FrmChildUI = {
		--分界线
		{__UI="image",__NAME="ApartLine",x=439,y=-130,						model="UI:panel_part_09",w=928,h=8},
		--使用者头像(底座)
		{__UI="image",__NAME="HeroSlot",x=280,y=_NSP_HeadXY[2]-2,z=1,				model="UI_frm:slot",animation="lightSlim",w=68,h=68},
		--使用者头像
		{__UI="image",__NAME="HeroIcon",x=280,y=_NSP_HeadXY[2]-2,z=1,				model="UI:Default",w=66,h=66},
		
		--商城标题
		{__UI="label",__NAME="ShopTittle",x=350,y=_NSP_HeadXY[2]+6,z=1,				text=hVar.tab_string["__TEXT_NetShopTitle"],font=hVar.FONTC,size=38,align="LC",RGB={255,205,55}, border = 1,}, --"游戏商城"
		
		--商城副标题
		{__UI= "label", __NAME = "ShopTittleEx" ,x = 506, y = _NSP_HeadXY[2] + 4, z = 1, text = "", font = hVar.FONTC, size = 28, align = "LC", RGB = {255,205,55}, border = 1,}, --副标题
		
		--玩家uID
		--{__UI="label",__NAME="PlayerUserID",x=320,y=_NSP_HeadXY[2],z=1,				text=_NSP_DefaultNumString,size=24,align="LC",RGB={0,255,0}},
		--游戏币图标
		--{__UI="image",__NAME="PlayerCoinIcon",x=360,y=_NSP_HeadXY[2],z=1,			model="UI:game_coins"},
		--玩家拥有的游戏币
		--{__UI="label",__NAME="PlayerCoinNum",x=385,y=_NSP_HeadXY[2],z=2,			text=_NSP_DefaultNumString,size=28,align="LC"},
		--积分图标
		--{__UI="image",__NAME="PlayerScoreIcon",x=490,y=_NSP_HeadXY[2],z=1,			model="UI:score",w=35,h=35},
		--玩家拥有的金币
		--{__UI="label",__NAME="PlayerScoreNum",x=515,y=_NSP_HeadXY[2],z=2,			text=_NSP_DefaultNumString,size=28,align="LC"},
		--符石图标
		--{__UI="image",__NAME="PlayerFstoneIcon",x=660,y=_NSP_HeadXY[2],z=1,			model="UI:rsdyz_point",w=35,h=35},
		--符石数值
		--{__UI="label",__NAME="PlayerFstoneNum",x=700,y=_NSP_HeadXY[2],z=2,			text=_NSP_DefaultNumString,size=28,align="LC"},
		--充值按钮
		{__UI="button",__NAME="btnCoinMarket",x=_NSP_FrmXYWH[3]-64,y=_NSP_HeadXY[2]-62,z=1,	model="buy_coins",scale=0.9,scaleT=0.95,code=function()return hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")end},
		--VIP按钮
		{__UI="button",__NAME="btnVIPMarket",x=_NSP_FrmXYWH[3]-156,y=_NSP_HeadXY[2]-62,z=1,	model="UI:vipbtn",scale=0.9,scaleT=0.95,code=function()return hGlobal.event:event("localEvent_ShowMyVIPFrm", 0) end},
		--礼包按钮
		--{__UI="button",__NAME="btnGameGift",x=_NSP_FrmXYWH[3]-190,y=_NSP_HeadXY[2]-68,z = 1,	model = "UI:GIFT",scale = 0.9,scaleT = 0.9,code = function() if g_vs_number>4 then return hGlobal.event:event("LocalEvent_Phone_ShowMyGift")end end},
		--激活码按钮
		--{__UI="button",__NAME="btnNetGift",x=_NSP_FrmXYWH[3]-172,y=_NSP_HeadXY[2]-72,z=1,	model="UI:giftkey",scale=0.8,scaleT=0.9,code=function()return xlShowWithdrawGift()end},
	}
	hGlobal.UI.NetShopFramII = hUI.frame:new({
		x = _NSP_FrmXYWH[1],
		y = _NSP_FrmXYWH[2],
		w = _NSP_FrmXYWH[3],
		h = _NSP_FrmXYWH[4],
		closebtn = {
			model = "BTN:PANEL_CLOSE",
			x = _NSP_FrmXYWH[3] - 10,
			y = -10,
			code = function()
				hGlobal.UI.NetShopFramII:show(0)
				_CODE_SwitchItemPage(nil, 0)
				_NSP_ShopItemBuyLock = {}
				hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
				hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
				
				--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
				hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
				
				hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
				__SHOP_IN_OPENING = false
			end,
		},
		dragable = 2,
		titlebar = 0,
		show = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = 1,
		autoactive = 0,
		child = _NSP_FrmChildUI,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			local v = _NSP_ItemPage[_NSP_ItemPage_Current]
			if v and hApi.IsInBox(x,y,_NSP_ItemPage_ClippingRect) then
				local tPickParam = _CODE_HitItemPage(self,tTempPos,v[1])
				if tPickParam~=nil then
					return self:pick(tPickParam.sGridName,_NSP_ItemPage_DragRect,tTempPos,{_CODE_DragItemPage,_CODE_DropItemPage,tPickParam})
				end
			else
				_CODE_HideShopItemTip()
			end
		end,
	})
	local _FrmBG = hGlobal.UI.NetShopFramII
	local _childUI = _FrmBG.childUI
	--_childUI["btnGameGift"]:setstate(-1)		--礼包按钮不显示
	--_childUI["btnNetGift"]:setstate(-1)		--礼品码按钮不显示
	--设置礼品按钮是否显示
	--hGlobal.event:listen("LocalEvent_Setbtn_compensate","__ShowGiftBtn",function(state) 
		--_childUI["btnNetGift"]:setstate(state)
		--if g_vs_number>4 then
			--_childUI["btnGameGift"]:setstate(state)
		--else
			--_childUI["btnGameGift"]:setstate(-1)
		--end
	--end)
	
	--vip按钮的叹号
	_childUI["btnVIPMarket"].childUI["PageTanHao"] = hUI.image:new({
		parent = _childUI["btnVIPMarket"].handle._n,
		x = 30,
		y = 20,
		model = "UI:TaskTanHao",
		w = 36,
		h = 36,
	})
	_childUI["btnVIPMarket"].childUI["PageTanHao"].handle._n:setVisible(false) --一开始不显示VIP领取状态的跳动的叹号
	local act1 = CCMoveBy:create(0.2, ccp(0, 5))
	local act2 = CCMoveBy:create(0.2, ccp(0, -5))
	local act3 = CCMoveBy:create(0.2, ccp(0, 5))
	local act4 = CCMoveBy:create(0.2, ccp(0, -5))
	local act5 = CCDelayTime:create(2.0)
	local a = CCArray:create()
	a:addObject(act1)
	a:addObject(act2)
	a:addObject(act3)
	a:addObject(act4)
	a:addObject(act5)
	local sequence = CCSequence:create(a)
	_childUI["btnVIPMarket"].childUI["PageTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
	
	--内存快爆掉的时候，释放商店里面的东西
	hGlobal.event:listen("LocalEvent_MemoryWarning","__NSP__MEMFlush",function(nCount)
		if _FrmBG.data.show==1 then
			return
		end
		_NSP_IsFlushed = 1
		_NSP_MemoryWarning = 1
		for i = 1,#_NSP_ItemPage do
			local oGrid = _childUI[_NSP_ItemPage[i][1].."Grid"]
			if oGrid then
				oGrid:updateitem({})
			end
		end
		_NSP_MemoryWarning = 0
		hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_SHOP)
	end)
	
	--获得红装时刷新红装计数表
	local _NSP_IfUpdateElitePage = 1
	local _NSP_LastPlayerName = ""
	hGlobal.event:listen("Event_HeroGetItem","__IfUpdateShopItemPage",function(oHero,oItem,sBagName,nIndex)
		local tabI = hVar.tab_item[oItem[i]]
		if tabI and (tabI.itemLv or 0)>=4 then
			_NSP_IfUpdateElitePage = 1
		end
	end)
	
	local __SHOP_IN_OPENING = false
	--显示商城
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(DisplayStatus)
		local cheatflag = xlGetIntFromKeyChain("cheatflag")
		local userID = xlPlayer_GetUID()
		
		--检测作弊
		if (cheatflag == 1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
			return
		end
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oHero = hApi.GetLocalHero("choosed")
		local tabU
		if oWorld and oHero and oHero:getowner()==hGlobal.LocalPlayer then
			tabU = hVar.tab_unit[oHero.data.id]
			--if oHero and oHero.data.HeroCard ~=1 then
			if oHero then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_RequireHeroCardEx"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
		end
		
		if tabU and tabU.type==hVar.UNIT_TYPE.HERO and tabU.icon then
			--游戏内打开商店界面
			_childUI["HeroSlot"].handle._n:setVisible(true)
			_childUI["HeroIcon"].handle._n:setVisible(true)
			_childUI["HeroIcon"]:setmodel(tabU.icon)
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm","game")
		else
			--游戏外打开商店界面
			_childUI["HeroSlot"].handle._n:setVisible(false)
			_childUI["HeroIcon"].handle._n:setVisible(false)
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		end
		
		--检测每个分页按钮是否能点
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			for i = 2, #_NSP_ItemPage, 1 do
				local sPageName = _NSP_ItemPage[i] and _NSP_ItemPage[i][1]
				if _childUI[sPageName] then
					hApi.AddShader(_childUI[sPageName].handle.s, "gray")
				end
			end
		else
			for i = 2, #_NSP_ItemPage, 1 do
				local sPageName = _NSP_ItemPage[i] and _NSP_ItemPage[i][1]
				if _childUI[sPageName] then
					hApi.AddShader(_childUI[sPageName].handle.s, "normal")
				end
			end
		end
		
		--检测VIP领取按钮是否叹号
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		
		 --设置VIP领取状态的跳动的叹号
		_childUI["btnVIPMarket"].childUI["PageTanHao"].handle._n:setVisible(enableVIPDaliyReward)
		
		--设置VIP按钮是否显示
		if (LuaGetPlayerVipLv() > 0) then --是vip
			_childUI["btnVIPMarket"]:setstate(1) --显示vip按钮
		else
			_childUI["btnVIPMarket"]:setstate(-1) --隐藏vip按钮
		end
		
		--默认显示第一个分页
		_CODE_SwitchItemPage(_NSP_ItemPage[1][1], 1)
		
		if _childUI["Page_EliteGrid"] and (_NSP_LastPlayerName~=g_curPlayerName or _NSP_IfUpdateElitePage==1) then
			_NSP_IfUpdateElitePage = 0
			_NSP_LastPlayerName = g_curPlayerName
			_NSP_EliteItemCount = LuaGetPlayerDataItemCount()
			_childUI["Page_EliteGrid"]:updateitem({})
		end
		hUI.NetDisable(3000)
		SendCmdFunc["openNetShop"]()
		__SHOP_IN_OPENING = true
		hApi.addTimerOnce("closeTimer",3000,function()
			if __SHOP_IN_OPENING then
				hUI.NetDisable(0)
				
				hGlobal.UI.NetShopFramII:show(0)
				_CODE_SwitchItemPage(nil,0)
				_NSP_ShopItemBuyLock = {}
				
				hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
				__SHOP_IN_OPENING = false
			end
		end)
		
		--geyachao: 充值按钮由变量控制
		if (hVar.SHOW_PURCHASE_HOST == 1) and (hVar.SHOW_PURCHASE_CLIENT == 1) then
			hGlobal.UI.NetShopFramII.childUI["btnCoinMarket"]:setstate(1)
		else
			hGlobal.UI.NetShopFramII.childUI["btnCoinMarket"]:setstate(-1)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_ShowNetShopEx_Net","__shownetshop",function()
		
		if not __SHOP_IN_OPENING then
			hUI.NetDisable(0)
			
			hGlobal.UI.NetShopFramII:show(0)
			_CODE_SwitchItemPage(nil,0)
			_NSP_ShopItemBuyLock = {}
			
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			__SHOP_IN_OPENING = false
		end
		
		__SHOP_IN_OPENING = false
		SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)
		--SendCmdFunc["getShopState"]()
		hUI.NetDisable(0)
		--zhenkira 2015.11.30(12月版本回退)
		--local canOpen = 0
		--local ww = hGlobal.LocalPlayer:getfocusmap()
		
		--if ww and ww.data.map == "town/town_mainmenu" then
		--	canOpen = 1
		--end
		--if g_current_scene == g_world then
		--	canOpen = 1
		--end
		
		local canOpen = 1
		
		if canOpen == 1 then
			hGlobal.event:event("LocalEvent_ShowMapAllUI",false)
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oHero = hApi.GetLocalHero("choosed")
			local tabU
			--zhenkira 2015.11.30(12月版本回退)
			--if oWorld and oHero and oHero:getowner()==hGlobal.LocalPlayer then
			--	tabU = hVar.tab_unit[oHero.data.id]
			--	if oHero and oHero.data.HeroCard ~=1 then
			--		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_RequireHeroCardEx"],{
			--			font = hVar.FONTC,
			--			ok = function()
			--			end,
			--		})
			--		return
			--	end
			--end
			
			_FrmBG:show(1)
			_FrmBG:active()
			
			if tabU and tabU.type==hVar.UNIT_TYPE.HERO and tabU.icon then
				--游戏内打开商店界面
				hGlobal.event:event("LocalEvent_ShowGameCoinFrm","game")
			else
				--游戏外打开商店界面
				hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			end
		end
	end)
	
	--hGlobal.event:listen("LocalEvent_Phone_ShowNetShopEx_Page","__show",function(Page)
		--hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx","hall")
		--_CODE_SwitchItemPage(Page)
	--end)
	
	----刷新游戏币
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","__NSP__UpdateGameCoin",function(cur_rmb)
		if type(cur_rmb) == "number" then
			_cur_rmb = cur_rmb
		else
			_cur_rmb = 0
		end
		----从服务器获得游戏币后 显示
		--if type(cur_rmb) == "number" then
			--local s = tostring(cur_rmb)
			--if _childUI["PlayerCoinNum"].data.text~=s then
				--_childUI["PlayerCoinNum"]:setText(s,1)
				--if _FrmBG.data.show==1 then
					--_childUI["PlayerCoinIcon"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
				--end
			--end
		--else
			--_childUI["PlayerCoinNum"]:setText(_NSP_DefaultNumString,1)
		--end
	end)
	
	----刷新积分
	--hGlobal.event:listen("LocalEvent_SetCurGameScore","__NSP__UpdateGameScore",function()
		--local s = tostring(LuaGetPlayerScore())
		--if s~=_childUI["PlayerScoreNum"].data.text then
			--_childUI["PlayerScoreNum"]:setText(s,1)
			--if _FrmBG.data.show==1 then
				--_childUI["PlayerScoreIcon"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,0.8,0.8),CCScaleTo:create(0.08,0.5,0.5)))
			--end
		--end
	--end)
	
	----刷新符石
	----hGlobal.event:event("LocalEvent_SetCurFstoneNum",cur_num)
	--hGlobal.event:listen("LocalEvent_SetCurFstoneNum","__NSP__UpdateGameCoin",function(cur_num) 
		----从服务器获得游戏币后 显示
		--if type(cur_num) == "number" then
			--local s = tostring(cur_num)
			--if _childUI["PlayerFstoneNum"].data.text~=s then
				--_childUI["PlayerFstoneNum"]:setText(s,1)
				--if _FrmBG.data.show==1 then
					--_childUI["PlayerFstoneNum"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
				--end
			--end
		--else
			--_childUI["PlayerFstoneNum"]:setText(_NSP_DefaultNumString,1)
		--end
	--end)
	
	--收到了活动信息,设置部分道具状态刷新
	local _NSP_SpecialItemData = {}
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","__UpdateNetShopItem",function(connect_state)
		local update = {}
		local tSPData = _NSP_SpecialItemData
		for k,v in pairs(tSPData)do
			v.update = -1		--先设置为需要移除
		end
		--网络断开状态时无优惠信息
		if g_cur_net_state==1 then
			for i = 1,#g_activity_list do
				local v = g_activity_list[i]
				local nItemID,nScore,nRmb,nState
				if v.id==300 or v.id==301 or v.id==302 then
					nItemID = v.itemID
					nScore = v.score
					nRmb = v.rmb
				elseif v.id==303 then
					nItemID = v.ShopItemID
					nState = v.ShopItemState
				end
				if nItemID then
					local t = tSPData[nItemID]
					if t~=nil then
						if t.update==-1 then
							t.update = 0			--设置为无需刷新
						end
					else
						t = {update=1}				--新建数据需要刷新
						tSPData[nItemID] = t
					end
					if nState~=nil and t.nState~=nState then	--图标不一样
						t.update = 1
						t.nState = nState
					end
					if nScore~=nil and t.nScore~=nScore then	--积分不一样
						t.update = 1
						t.nScore = nScore
					end
					if nRmb~=nil and t.nRmb~=nRmb then		--游戏币不一样
						t.update = 1
						t.nRmb = nRmb
					end
				end
			end
		end
		for itemID,v in pairs(tSPData)do
			if v.update~=0 then
				update[#update+1] = itemID
			end
			if v.update==-1 then
				tSPData[itemID] = nil
			end
		end
		if #update>0 then
			--print("收到活动数据,以下物品数据刷新",unpack(update))
			for nIndex = 1,#_NSP_ItemPage do
				if _NSP_PageItemUI[_NSP_ItemPage[nIndex][2]].data.mode=="shopitem" then
					local tUIHandle = _NSP_PageItemUIHandle[nIndex]
					if type(tUIHandle.update)~="table" then
						tUIHandle.update = {}
					end
					local t = tUIHandle.update
					for i = 1,#update do
						t[#t+1] = update[i]
					end
				end
			end
			if _FrmBG.data.show==1 and _NSP_ItemPage[_NSP_ItemPage_Current]~=nil then
				_CODE_SwitchItemPage(_NSP_ItemPage[_NSP_ItemPage_Current][1],1)
			end
		end
	end)
	
	--------------------------------------------------------------------------------------------------------------------
	--购买成功后的监听
	hGlobal.event:listen("LocalEvent_BuyItemSucceed", "Phone_BuyItemSucceed", function(nShopItemID, nItemID, overage)
		--print("LocalEvent_BuyItemSucceed", nShopItemID, nItemID, overage)
		--geyachao: 对于今日限制购买次数的商品，购买次数减1
		local t = hVar.NET_SHOP_ITEM["Page_Item"]
		for i = 1, #t, 1 do
			if (t[i][1] == nShopItemID) then --找到了
				local limitMax = t[i][2] or -1
				if (limitMax > 0) then
					--print("LocalEvent_BuyItemSucceed", nShopItemID, limitMax)
					--今日某商品购买的次数限制减1
					local num = LuaGetTodayShopItemLimitCount(g_curPlayerName, nShopItemID, limitMax)
					LuaSetTodayShopItemLimitCount(g_curPlayerName, nShopItemID, num - 1)
					
					--刷新商品列表
					_CODE_RefreshItemTodayBuyTimesUI(1)
				end
				
				break
			end
		end
		
		_NSP_ShopItemBuyLock[nShopItemID] = 0
		SendCmdFunc["Fstone"]()
		SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)
		--SendCmdFunc["getShopState"]()
		--print("购买成功",nShopItemID,nItemID,overage)
		--购买成功的话显示UI
		local tItemUI,oGrid = _CODE_GetPageItemUI_ByItemID(nItemID)
		local tabI = hVar.tab_item[nItemID]
		if oGrid~=nil and tItemUI~=nil and tabI~=nil then
			--显示itemUI
			local nItemX,nItemY = tItemUI.data.x,tItemUI.data.y
			local nPlusVal = 1
			if tabI.type==hVar.ITEM_TYPE.PLAYERITEM then
				if type(tabI.matVal)=="table" and type(tabI.matVal[2])=="number" then
					nPlusVal = tabI.matVal[2]
				end
			elseif tabI.type==hVar.ITEM_TYPE.RESOURCES then
				if type(tabI.val)=="number" then
					nPlusVal = tabI.val
				end
			end
			local nIconWH = 66
			if __NSP__ItemIconXYWH[nItemID] then
				nIconWH = __NSP__ItemIconXYWH[nItemID][3]
			end
			hUI.floatNumber:new({
				parent = oGrid.handle._n,
				font = "numGreen",
				text = " +"..nPlusVal,
				size = 20,
				x = nItemX + nIconWH/2,
				y = nItemY + 12,
				align = "LB",
				moveY = 32,
				lifetime = 1000,
				fadeout = -330,
				icon = hVar.tab_item[nItemID].icon,
				iconWH = nIconWH,
			})
		end
		
		--任务：累计击购买N个指定道具
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, nShopItemID, 1)
	end)
	
	--购买失败
	hGlobal.event:listen("LocalEvent_BuyItemfail", "__ClearLock",function(result,nItemID)
		--收到消息后解除购买锁
		local tItemUI = _CODE_GetPageItemUI_ByItemID(nItemID)
		if tItemUI and tItemUI.data.shopItemID~=0 then
			_NSP_ShopItemBuyLock[tItemUI.data.shopItemID] = 0
		end
	end)
	
	--购买失败
	hGlobal.event:listen("LocalEvent_BuyGiftfail","__ClearLock",function(result,nItemID)
		--收到消息后解除购买锁
		local tItemUI = _CODE_GetPageItemUI_ByItemID(nItemID)
		if tItemUI and tItemUI.data.shopItemID~=0 then
			_NSP_ShopItemBuyLock[tItemUI.data.shopItemID] = 0
		end
	end)
	
	hGlobal.event:listen("localEvent_PreventClick","_PreventClick",function()
		print("暂时不准买")
		_NSP_ShopItemCoodown.tick = math.max(_NSP_ShopItemCoodown.tick,hApi.gametime() + 1000)
	end)
	
	--geyachao:
	--监听获得每日商品列表
	hGlobal.event:listen("localEvent_refresh_shopinfo", "_refresh_shopinfo", function(shopId, rmb_refresh_count, goods)
		--print("获得每日商品列表", shopId, rmb_refresh_count, goods, #goods)
		
		--设置存档里的今日商城商品列表数据
		LuaSetTodayNetShopGoods(g_curPlayerName, shopId, rmb_refresh_count, goods)
		
		--不在"Page_Rune"分页，不处理UI相关
		local sPageName = _NSP_ItemPage[_NSP_ItemPage_Current] and _NSP_ItemPage[_NSP_ItemPage_Current][1]
		if (sPageName ~= "Page_Rune") then
			return
		end
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--[[
		--隐藏挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(-1)
		end
		]]
		
		--for good_idx = 1, #goods, 1 do
		--	hVar.NET_SHOP_ITEM["Page_Rune"][good_idx] = {id}
		--end
		
		--_CODE_SwitchItemPage(_NSP_ItemPage[3][1],1)
		
		--刷新商品
		for good_idx = 1, #goods, 1 do
			local good = goods[good_idx]
			local id = good.id --tab_shopitem的id
			local itemId = good.itemId --tab_item的id
			local num = good.num --碎片数量
			local score = good.score --购买需要的积分
			local rmb = good.rmb --购买需要的游戏币
			local quota = good.quota --总购买次数
			local saledCount = good.saledCount --已购买次数
			--print("每日商品列表", id, itemId, num, score, rmb, quota, saledCount)
			
			--hVar.NET_SHOP_ITEM["Page_Rune"][good_idx] = {id}
			
			local nIndex = 3
			if _NSP_ItemPage[nIndex] then
				if _NSP_PageItemUIHandle[nIndex] then
					local sPageMode = _NSP_ItemPage[nIndex][2]				--ShopItem,RuneItem,EliteItem
					local tUIList = _NSP_PageItemUI[sPageMode]
					for k, tItemUIHandle in pairs(_NSP_PageItemUIHandle[nIndex].handle) do
						--print("tUIList:"..#tUIList)
						local ary = hApi.String2Array(k)
						local shopIdx = (ary[1] + 1) + (ary[2] * 3)
						--print(ary[1] + 1, ary[2] + 1)
						if (shopIdx == good_idx) then --找到了
							for i = 1, #tUIList, 1 do
								local sUIType = tUIList[i][1]				--button,image……………………
								local sUIName = tUIList[i][2]				--_itemBuyBtn， _itemLock………………
								
								--获得商品的品质颜色
								local tabI = hVar.tab_item[itemId]
								local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
								local NAMERGB = tabM.NAMERGB
								local BORDERMODEL = tabM.BORDERMODEL
								
								--修改商品图标背景图
								if (("_itemBGX") == sUIName) then
									local oImage = tItemUIHandle[sUIName]
									if oImage then
										local icon = tabI.icon
										oImage:setmodel(BORDERMODEL)
									end
								end
								
								--修改商品图标
								if (("_itemIconX") == sUIName) then
									local oImage = tItemUIHandle[sUIName]
									if oImage then
										local icon = tabI.icon
										oImage:setmodel(icon)
									end
								end
								
								--修改商品名
								if (("_itemNameX") == sUIName) then
									local oLabel = tItemUIHandle[sUIName]
									if oLabel then
										local name = hVar.tab_stringI[itemId][1]
										local nameSize = #name
										
										--字数超长
										if (nameSize <= 15) then
											oLabel:setText(name)
											oLabel.handle.s:setColor(ccc3(NAMERGB[1], NAMERGB[2], NAMERGB[3]))
										else
											oLabel:setText("")
										end
									end
								end
								
								--修改商品名（小号）
								if (("_itemName_SmallX") == sUIName) then
									local oLabel = tItemUIHandle[sUIName]
									if oLabel then
										local name = hVar.tab_stringI[itemId][1]
										local nameSize = #name
										
										--字数超长
										local nameSize = #name
										if (nameSize <= 15) then
											oLabel:setText("")
										else
											oLabel:setText(name)
											oLabel.handle.s:setColor(ccc3(NAMERGB[1], NAMERGB[2], NAMERGB[3]))
										end
									end
								end
								
								--修改商品碎片数量
								if (("_itemDebrisNumX") == sUIName) then
									local oLabel = tItemUIHandle[sUIName]
									if oLabel then
										local name = "+" .. num .. " " --程序bug，最后一个是数字只显示一半
										oLabel:setText(name)
										oLabel.handle.s:setColor(ccc3(NAMERGB[1], NAMERGB[2], NAMERGB[3]))
									end
								end
								
								--修改商品价格
								if (("_itemRMBX") == sUIName) then
									local oLabel = tItemUIHandle[sUIName]
									if oLabel then
										local rmb = rmb
										oLabel:setText(rmb)
									end
								end
								
								--修改商品可购买次数
								if (("_itemLimitX") == sUIName) then
									local oLabel = tItemUIHandle[sUIName]
									if oLabel then
										local leftNum = quota - saledCount
										oLabel:setText(leftNum)
									end
								end
								
								--修改按钮状态
								if (("_itemBuyBtn") == sUIName) then
									local oBtn = tItemUIHandle[sUIName]
									if oBtn then
										local leftNum = quota - saledCount
										if (leftNum > 0) then
											hApi.AddShader(oBtn.handle.s, "normal")
										else
											hApi.AddShader(oBtn.handle.s, "gray")
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		--显示重刷按钮
		if _childUI["PageRuneRefreshBtn"] then
			_childUI["PageRuneRefreshBtn"]:setstate(1)
			
			--刷新今日重刷次数
			local rmbRefreshCount = hVar.tab_shop[shopId].rmbRefreshCount --每天可用金币刷新n次
			local rmbCost = 20 --每次刷新消耗游戏币
			local vipLv = LuaGetPlayerVipLv()
			if (vipLv > 0) then --vip有额外刷新次数
				local netshopRefreshCount = hVar.Vip_Conifg.netshopRefreshCount[vipLv] --vip该等级可以免费重刷的次数
				if (netshopRefreshCount > 0) then
					rmbRefreshCount = netshopRefreshCount
					--rmbCost = 0
				end
			end
			
			local left_count = rmbRefreshCount - rmb_refresh_count --剩余次数
			if _childUI["PageRuneRefreshBtn"].childUI["num"] then
				_childUI["PageRuneRefreshBtn"].childUI["num"]:setText("x" .. left_count) --今日重刷次数
			end
			
			--今日重刷游戏币
			if _childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"] then
				_childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"]:setText(rmbCost)
			end
			
			--调整按钮亮暗
			if (left_count > 0) then
				if _childUI["PageRuneRefreshBtn"].childUI["image1"] then
					hApi.AddShader(_childUI["PageRuneRefreshBtn"].childUI["image1"].handle.s, "normal")
				end
			else
				if _childUI["PageRuneRefreshBtn"].childUI["image1"] then
					hApi.AddShader(_childUI["PageRuneRefreshBtn"].childUI["image1"].handle.s, "gray")
				end
			end
		end
		
		--立即刷新timer
		_CODE_timer_refresh_PageRune()
		
		--检测提示今日商店商品刷新的叹号动态提示箭头是否显示
		_CODE_CheckHintTanHaoVisible()
	end)
	
	--geyachao:
	--监听购买每日商品的购买结果返回
	hGlobal.event:listen("localEvent_buyitem_return",  "_buyitem_return", function(result, good, reward)
		--print("购买每日商品的购买结果返回", result, good, reward)
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记本商品可以买
		if (result == 1) then --成功1
			local nShopItemID = good.id
			--print(nShopItemID, _NSP_ShopItemBuyLock)
			_NSP_ShopItemBuyLock[nShopItemID] = 0
		end
		
		--[[
		--隐藏挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(-1)
		end
		]]
		
		local strText = nil
		if (result == 1) then --成功 1
			--strText = "购买成功！" --language
			strText = hVar.tab_string["ios_payment_success"] --language
		elseif (result == -1) then --商品不存在 -1
			strText = "商品不存在"
		elseif (result == -2) then --游戏币不足 -2
			--strText = "游戏币不足！" --language
			strText = hVar.tab_string["ios_not_enough_game_coin"] --language
		elseif (result == -3) then --购买次数已达上限 -3
			--strText = "该商品今日购买次数已用完！" --language
			strText = hVar.tab_string["__TEXT_TodayBuyItemUsedUp"] --language
		elseif (result == -4) then --商品信息不存在-4(需要触发服务器生成新的商品列表)
			strText = "商品信息不存在"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
		
		--购买碎片成功，pvp数据就需要刷新
		if (result == 1) then --成功1
			--标记pvp基础数据不是最新数据了
			g_myPvP_BaseInfo.updated = 0

			--任务：累计击购买N个指定道具
			LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, good.id, 1)
		end
	end)
	
	--监听获得VIP等级和领取状态事件，刷新商店的VIP叹号提示
	hGlobal.event:listen("LocalEvent_GetVipState_New", "_shop_vip_hint_", function(vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		
		 --设置VIP领取状态的跳动的叹号
		_childUI["btnVIPMarket"].childUI["PageTanHao"].handle._n:setVisible(enableVIPDaliyReward)
	end)
	
	--监听获得VIP领取状态事件，，刷新商店的VIP叹号提示
	hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "_shop_vip_hint_", function(dailyRewardFlag)
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		
		 --设置VIP领取状态的跳动的叹号
		_childUI["btnVIPMarket"].childUI["PageTanHao"].handle._n:setVisible(enableVIPDaliyReward)
	end)
	
	--第一次打开商店，发起查询
	--发送刷新每日商品的指令
	local shopId = 1
	--print("第一次打开商店，发起查询", shopId)
	SendCmdFunc["open_shop"](shopId)
	
	--接收到只能购买一次道具的返回
	--local _onlyonceTab = {}
	--local _ext_consuming = ""
	--hGlobal.event:listen("LocalEvent_GetBuyItmeState","getitemstate",function(ext_consuming)
		----print("asddddddddddddddddddddddddddddddddddddddddddddd   LocalEvent_GetBuyItmeState", "9106:1;")
		----_onlyonceTab = {}
		--_ext_consuming = ext_consuming
		--for v in string.gfind(ext_consuming,"([^%;]+);+") do
			--_onlyonceTab[#_onlyonceTab+1] = {tonumber(string.sub(v,1,string.find(v,":")-1)),tonumber(string.sub(v,string.find(v,":")+1),string.len(v))}
		--end
	--end)
	---------------------------
	--特殊支持函数
	---------------------------
	local _CODE_GetUIHandle = function(oUI)
		return oUI.handle._n
	end
	---------------------------
	--初始化商城页面
	---------------------------
	--创建page页,以及对应的itemGrid
	do
		local _NSP_pClipNode = hApi.CreateClippingNode(_FrmBG,_NSP_ItemPage_ClippingRect,99,_NSP_ItemPage_ClippingRect[5])
		local x = -30
		local plusX = 96
		for i = 1,#_NSP_ItemPage do
			_NSP_ItemPage_Current = i
			_NSP_PageItemUIHandle[_NSP_ItemPage_Current] = {index={},handle={},update=0}
			x = x + plusX + 2
			local sPageName = _NSP_ItemPage[i][1]
			local sPageMode = _NSP_ItemPage[i][2]
			local tPageParam = _NSP_ItemPage[i][3]
			local oBtn = hUI.button:new(hApi.ReadParam(tPageParam,nil,{
				parent = _FrmBG,
				x = x,
				y = _childUI["ApartLine"].data.y+25,
				scaleT = 0.9,
				code = function()
					--geyachao: 除了第一个分页，后面的需要通关第9关才能点
					if (i > 1) then
						--是否通关"剿灭黄巾"
						local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
						if (isFinishMap9 == 0) then
							--冒字
							--local strText = "通关【黄巾之乱】后，才能解锁商店分页！" --language
							local strText = hVar.tab_string["__TEXT_SHOP_archiLock"] --language
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							
							return
						else
							--检测是否已经分段更新完成
							if (not (hApi.IsUpdate2Done())) then
								return
							end
						end
					end
					
					--进入此分页
					_CODE_SwitchItemPage(sPageName)
				end,
			}))
			_childUI[sPageName] = oBtn
			oBtn.handle._border = hUI.deleteUIObject(hUI.image:new({
				parent = oBtn.handle._n,
				model = "UI:Button_SelectBorder",
				y = 1,
				w = oBtn.data.w+4,
				h = 48,
				z = -1,
			}),_CODE_GetUIHandle)
			oBtn.handle._border:setVisible(false)
			if plusX~=oBtn.data.w then
				oBtn:setXY(oBtn.data.x+math.floor(oBtn.data.w/2-plusX/2),oBtn.data.y)
				plusX = _childUI[sPageName].data.w
			end
			if hVar.NET_SHOP_ITEM[sPageName] then
				local tUIList = _NSP_PageItemUI[sPageMode]
				local nPageItemNum = #hVar.NET_SHOP_ITEM[sPageName]
				local ItemPageGrid = {}
				local ItemPageCol = hApi.NumTable(tUIList.data.cols)
				local nPageItemRow = math.ceil(nPageItemNum/tUIList.data.cols)
				for i = 1,nPageItemRow do
					ItemPageGrid[i] = ItemPageCol
				end
				_childUI[sPageName.."Grid"] = hUI.bagGrid:new(hApi.ReadParam(tUIList.data.grid,nil,{
					parent = _NSP_pClipNode,
					align = "MC",
					grid = ItemPageGrid,
					item = {},
					slot = 0,
					num = 0,
					uiExtra = {"ItemPlusUI"},
					codeOnImageCreate = function(oGrid,id,pSprite,gx,gy)
						pSprite:setVisible(false)
						local x,y = pSprite:getPosition()
						local sGridKey = gx.."|"..gy
						local nItemID,nShopItemID = _CODE_ItemPageGetItemID(sPageMode,id)
						if nItemID~=0 then
							return _CODE_UpdateItemPageGridItem(sPageMode,oGrid,gx,gy,x,y,nShopItemID,nItemID)
						end
					end,
				}))
				
				--叹号
				if (sPageName == "Page_Rune") then
					--子按钮3的叹号跳到提示
					oBtn.childUI["PageTanHao"] = hUI.image:new({
						parent = oBtn.handle._n,
						x = 30,
						y = 20,
						model = "UI:TaskTanHao",
						w = 36,
						h = 36,
					})
					oBtn.childUI["PageTanHao"].handle._n:setVisible(false) --一开始不显示今日商城商品的跳动的叹号
					local act1 = CCMoveBy:create(0.2, ccp(0, 5))
					local act2 = CCMoveBy:create(0.2, ccp(0, -5))
					local act3 = CCMoveBy:create(0.2, ccp(0, 5))
					local act4 = CCMoveBy:create(0.2, ccp(0, -5))
					local act5 = CCDelayTime:create(2.0)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(act2)
					a:addObject(act3)
					a:addObject(act4)
					a:addObject(act5)
					local sequence = CCSequence:create(a)
					oBtn.childUI["PageTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
				end
			end
		end
		_NSP_ItemPage_Current = 0
	end
	---------------------------
	--商店Page支持函数
	---------------------------
	_CODE_ItemPageGetItemID = function(sPageMode,nID)
		local nItemID = 0
		local nShopItemID = 0
		local mode = _NSP_PageItemUI[sPageMode].data.mode
		if mode=="shopitem" then
			if hVar.tab_shopitem[nID]~=nil then
				nShopItemID = nID
				nItemID = hVar.tab_shopitem[nID].itemID
			end
		elseif mode=="item" then
			nItemID = nID
		end
		if nItemID~=0 and hVar.tab_item[nItemID]~=nil then
			return nItemID,nShopItemID
		else
			return 0,0
		end
	end
	local _code_DeletePageItemUI = function(self)
		local h = self.handle
		local tUIList = _NSP_PageItemUI[self.data.mode]
		for i = 1,#tUIList do
			local sUIType = tUIList[i][1]
			local sUIName = tUIList[i][2]
			if h[sUIName]~=nil and (_NSP_MemoryWarning==1 or _NSP_PageItemUI_ReloadOnUpdate[sUIName]==1) then
				local _n = h[sUIName]
				h[sUIName] = nil
				if sUIType=="image" then
					_n:getParent():removeChild(_n,true)
				elseif sUIType=="label" then
					_n:getParent():removeChild(_n,true)
				end
			end
		end
	end
	_CODE_NewPageItemUI = function(sPageMode,oGrid,gx,gy,x,y,nShopItemID,nItemID)
		local sGridKey = gx.."|"..gy
		local tCurrentPage = _NSP_PageItemUIHandle[_NSP_ItemPage_Current]
		local tUIHandle = tCurrentPage.handle[sGridKey]
		tCurrentPage.index[nItemID] = sGridKey
		if tUIHandle==nil then
			tUIHandle = {}
			tCurrentPage.handle[sGridKey] = tUIHandle
		end
		local tItemUI = {handle=tUIHandle,data={itemID=nItemID,shopItemID=nShopItemID,x=x,y=y,mode=sPageMode},del=_code_DeletePageItemUI}
		oGrid.childUI[oGrid.data.uiExtra[1]..sGridKey] = tItemUI
		return tItemUI
	end
	_CODE_GetPageItemUI_ByItemID = function(nItemID)
		local tabI = hVar.tab_item[nItemID]
		local tCurrentPage = _NSP_PageItemUIHandle[_NSP_ItemPage_Current]
		if tabI==nil then
			return
		elseif tCurrentPage==nil then
			return
		end
		local oGrid = _childUI[_NSP_ItemPage[_NSP_ItemPage_Current][1].."Grid"]
		if oGrid==nil then
			return
		end
		local sGridKey = tCurrentPage.index[nItemID]
		if sGridKey~=nil then
			return oGrid.childUI[oGrid.data.uiExtra[1]..sGridKey],oGrid
		end
	end
	
	---------------------------
	--创建单个商店Page
	---------------------------
	local _NSP_UpdateUIParam = {
		IsEnd=0,
		dragbox = _FrmBG.childUI["dragBox"],
		ModelFunc = function(self,tData)
			return tData[1](self.nShopItemID,self.nItemID,self.tActivityData,tData[2],tData[3])
		end,
		BtnFunc = function(self, pCode)
			local nShopItemID = self.nShopItemID
			local nItemID = self.nItemID
			return function()
				pCode(nShopItemID, nItemID)
			end
		end,
		IsTemp = hVar.TEMP_HANDLE_TYPE.UI_SHOP,
	}
	_CODE_SkipUpdateItemPageGridItem = function()
		_NSP_UpdateUIParam.IsEnd = 1
	end
	_CODE_UpdateItemPageGridItem = function(sPageMode,oGrid,gx,gy,x,y,nShopItemID,nItemID)
		local tHandleTable = _CODE_NewPageItemUI(sPageMode,oGrid,gx,gy,x,y,nShopItemID,nItemID).handle
		local tActivityData = __NSP__UIFunc.GetItemActvityData(nShopItemID, nItemID)
		local tUIList = _NSP_PageItemUI[sPageMode]
		_NSP_UpdateUIParam.IsEnd = 0
		_NSP_UpdateUIParam.nShopItemID = nShopItemID
		_NSP_UpdateUIParam.nItemID = nItemID
		_NSP_UpdateUIParam.tActivityData = tActivityData
		_NSP_UpdateUIParam.ox = tUIList.data.grid.x
		_NSP_UpdateUIParam.oy = tUIList.data.grid.y
		hUI.CreateMultiUIByParam(oGrid.handle._n,x,y,tUIList,tHandleTable,_NSP_UpdateUIParam)
	end
	
	---------------------------
	--切换商店Page
	---------------------------
	_CODE_SwitchItemPage = function(sPageName,IsSystemCall)
		--print("_CODE_SwitchItemPage", sPageName, IsSystemCall)
		if IsSystemCall~=1 then
			_CODE_HideShopItemTip()
		end
		if sPageName~=nil then
			local nPageToSwitch = _NSP_ItemPage_Current
			for i = 1,#_NSP_ItemPage do
				if _NSP_ItemPage[i][1]==sPageName then
					nPageToSwitch = i                       --提取页的下标
					break
				end
			end
			local IsUpdateItemPage = 1
			if _NSP_ItemPage_Current==nPageToSwitch then
				if IsSystemCall~=1 then
					return
				else
					IsUpdateItemPage = 0
				end
			else
				_NSP_ItemPage_Current = nPageToSwitch            --页的下标，即第几页（1,2,3,4，……）
				for i = 1,#_NSP_ItemPage do
					if _NSP_ItemPage_Current==i then
						_childUI[_NSP_ItemPage[i][1]].handle._border:setVisible(true)
					else
						_childUI[_NSP_ItemPage[i][1]].handle._border:setVisible(false)
					end
				end
			end
			if hVar.NET_SHOP_ITEM[sPageName] then
				local sGridName = sPageName.."Grid"
				local oGrid = _childUI[sGridName]
				local sPageMode = _NSP_ItemPage[_NSP_ItemPage_Current][2]
				if type(_NSP_PageItemUIHandle[_NSP_ItemPage_Current].update)=="table" then
					local tUpdate = _NSP_PageItemUIHandle[_NSP_ItemPage_Current].update
					_NSP_PageItemUIHandle[_NSP_ItemPage_Current].update = 0
					local tPageUpdate = hApi.ReadParamWithDepth(hVar.NET_SHOP_ITEM[sPageName],nil,{},2)
					local tIndex = {}
					for i = 1,#tUpdate do
						tIndex[tUpdate[i]] = 1
					end
					
					for i = 1,#tPageUpdate do
						if tPageUpdate[i]~=0 then
							local nItemID = _CODE_ItemPageGetItemID(sPageMode,tPageUpdate[i][1])
							if nItemID>100 and tIndex[nItemID]==1 then
								tPageUpdate[i] = 0
							end
						end
					end
					oGrid:updateitem(tPageUpdate)				--创建英雄令卡片
				end
				oGrid:updateitem(hVar.NET_SHOP_ITEM[sPageName])			--创建英雄令卡片
				if _NSP_IsFlushed==1 or IsUpdateItemPage==1 then		--如果可以刷新，或者已经执行过清理，那么必须刷新
					local tUIList = _NSP_PageItemUI[sPageMode]
					local nGridV = math.ceil(#oGrid.data.item/tUIList.data.cols)*oGrid.data.gridH
					local nGridH = math.ceil(math.max(0,(nGridV-_NSP_ItemPage_ClippingRect[4]))/oGrid.data.gridH)*oGrid.data.gridH
					_NSP_ItemPage_GridAlign[2] = sGridName
					_NSP_ItemPage_DragRect[1] = tUIList.data.grid.x
					_NSP_ItemPage_DragRect[2] = tUIList.data.grid.y + nGridH - _NSP_ItemPage_GridAlign[5]
					_NSP_ItemPage_DragRect[3] = 0
					_NSP_ItemPage_DragRect[4] = nGridH - _NSP_ItemPage_GridAlign[5]*2
					_FrmBG:aligngrid(_NSP_ItemPage_GridAlign,_NSP_ItemPage_DragRect,0,1)
					for i = 1,#_NSP_ItemPage do
						if i==_NSP_ItemPage_Current then
							_CODE_EnableItemPageUI(i,1)				--i指定了需要显示的页的下标（1,2,3,4,5）,1指定了显示
							
							--修改副标题
							if _NSP_ItemPage[i] then
								if (_NSP_ItemPage[i][1] == sPageName) then
									--print(_NSP_ItemPage[i][4])
									_childUI["ShopTittleEx"]:setText("- " .. _NSP_ItemPage[i][4])
								end
							end
							
							--连接pvp服务器，获取碎片、将魂
							if (Pvp_Server:GetState() ~= 1) then --未连接
								Pvp_Server:Connect()
							elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
								Pvp_Server:UserLogin()
							end
							
							--特殊的分页
							if ("Page_Item") == sPageName then
								_CODE_RefreshItemTodayBuyTimesUI(i)
							elseif ("Page_HeroCard") == sPageName then			--当前页若为英雄令购买页
								_CODE_EnableItemPageHeroLockUI(i,1)             --激活英雄令购买锁
							elseif ("Page_Rune") == sPageName then
								--刷新每日商店出售的商品
								_CODE_RefreshItemPageRuneUI(i)
							end
						else
							_CODE_EnableItemPageUI(i,0)				--0指定了不显示
						end
					end
				end
			end
		else
			_NSP_ItemPage_Current = 0
			if IsSystemCall~=0 then
				for i = 1,#_NSP_ItemPage do
					_CODE_EnableItemPageUI(i,0)
				end
			end
			
			--关闭商店
			_CODE_OnCloseShop()
		end
	end
	
	--关闭商店
	_CODE_OnCloseShop = function()
		--移除timer
		hApi.clearTimer("__SHOP_TIMER_PAG_RUNE__")
	end
	
	--刷新商品今日购买的次数(page 1)
	_CODE_RefreshItemTodayBuyTimesUI = function(nIndex)
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--[[
		--隐藏挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(-1)
		end
		]]
		
		--隐藏重刷倒计时
		if _childUI["PageRuneTimeLabelPrefix"] then
			_childUI["PageRuneTimeLabelPrefix"].handle._n:setVisible(false)
		end
		
		--隐藏重刷倒计时的值
		if _childUI["PageRuneTimeLabel"] then
			_childUI["PageRuneTimeLabel"].handle._n:setVisible(false)
		end
		
		--隐藏重刷按钮
		if _childUI["PageRuneRefreshBtn"] then
			_childUI["PageRuneRefreshBtn"]:setstate(-1)
		end
		
		--移除timer
		hApi.clearTimer("__SHOP_TIMER_PAG_RUNE__")
		
		--检测提示今日商店商品刷新的叹号动态提示箭头是否显示
		_CODE_CheckHintTanHaoVisible()
		
		if _NSP_ItemPage[nIndex] then
			if _NSP_PageItemUIHandle[nIndex] then
				local sPageMode = _NSP_ItemPage[nIndex][2]				--ShopItem,RuneItem,EliteItem
				local tUIList = _NSP_PageItemUI[sPageMode]
				for k,tItemUIHandle in pairs(_NSP_PageItemUIHandle[nIndex].handle)do
					--print("tUIList:"..#tUIList)
					for i = 1,#tUIList do
						local sUIType = tUIList[i][1]				--button,image……………………
						local sUIName = tUIList[i][2]				--_itemBuyBtn， _itemLock………………
						if ("_itemLimit") == sUIName then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								--print("k=", k,"sUIType=", sUIType, "oLabel=", oLabel, oLabel.data)
								local ary = hApi.String2Array(k)
								local shopIdx = (ary[1] + 1) + (ary[2] * 3)
								--print(ary[1] + 1, ary[2] + 1)
								local nShopItemID = hVar.NET_SHOP_ITEM["Page_Item"][shopIdx][1]
								local limitMax = hVar.NET_SHOP_ITEM["Page_Item"][shopIdx][2] or -1
								if (limitMax > 0) then
									local num = LuaGetTodayShopItemLimitCount(g_curPlayerName, nShopItemID, limitMax)
									--print("LuaGetTodayShopItemLimitCount", nShopItemID, num)
									--oLabel:setText("x" .. num)
									if (num < 9999) then --次数太长界面显示不下
										oLabel:setString("x" .. num)
									else
										oLabel:setString("")
									end
								else
									oLabel:setString("")
								end
							end
						end
					end
				end
			end
		end
	end
	
	--激活商店Page中英雄令的购买锁(page 2)
	_CODE_EnableItemPageHeroLockUI = function(nIndex,nEnable)
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--[[
		--隐藏挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(-1)
		end
		]]
		
		--隐藏重刷倒计时
		if _childUI["PageRuneTimeLabelPrefix"] then
			_childUI["PageRuneTimeLabelPrefix"].handle._n:setVisible(false)
		end
		
		--隐藏隐藏重刷倒计时的值
		if _childUI["PageRuneTimeLabel"] then
			_childUI["PageRuneTimeLabel"].handle._n:setVisible(false)
		end
		
		--隐藏重刷按钮
		if _childUI["PageRuneRefreshBtn"] then
			_childUI["PageRuneRefreshBtn"]:setstate(-1)
		end
		
		--移除timer
		hApi.clearTimer("__SHOP_TIMER_PAG_RUNE__")
		
		--检测提示今日商店商品刷新的叹号动态提示箭头是否显示
		_CODE_CheckHintTanHaoVisible()
		
		if _NSP_ItemPage[nIndex] then
			if _NSP_PageItemUIHandle[nIndex] then
				local sPageMode = _NSP_ItemPage[nIndex][2]				--ShopItem,RuneItem,EliteItem
				local tUIList = _NSP_PageItemUI[sPageMode]
				for k,tItemUIHandle in pairs(_NSP_PageItemUIHandle[nIndex].handle)do
					--print("tUIList:"..#tUIList)
					for i = 1,#tUIList do
						local sUIType = tUIList[i][1]				--button,image……………………
						local sUIName = tUIList[i][2]				--_itemBuyBtn， _itemLock………………
						if ("_itemLock") == sUIName then
							local oImage = tItemUIHandle[sUIName]
							if 1 == nEnable then
								
								local _,_,nX,nY = string.find(k,"(%d+)|(%d+)")
								local nItemIndex = tonumber(nX)+1 + tonumber(nY)*(#_childUI["Page_HeroCardGrid"].data.grid[1])
								local nShopID = _childUI["Page_HeroCardGrid"].data.item[nItemIndex][1]
								local lockMap = hVar.NET_SHOP_ITEM_LIMIT[nShopID]
								local lockFlag = false
								if lockMap and type(lockMap) == "string" and LuaGetPlayerMapAchi(lockMap,hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then
									--锁定英雄令的购买
									lockFlag = true
								end
								oImage:setVisible(lockFlag)
								
							end
						end
					end
				end
			end
		end
	end
	
	--刷新每日商店出售的商品(page 3)
	_CODE_RefreshItemPageRuneUI = function(nIndex)
		--先重置所有商品为问号
		if _NSP_ItemPage[nIndex] then
			if _NSP_PageItemUIHandle[nIndex] then
				local sPageMode = _NSP_ItemPage[nIndex][2]				--ShopItem,RuneItem,EliteItem
				local tUIList = _NSP_PageItemUI[sPageMode]
				for k, tItemUIHandle in pairs(_NSP_PageItemUIHandle[nIndex].handle) do
					for i = 1, #tUIList, 1 do
						local sUIType = tUIList[i][1]				--button,image……………………
						local sUIName = tUIList[i][2]				--_itemBuyBtn， _itemLock………………
						
						--修改商品图标
						if (("_itemIconX") == sUIName) then
							local oImage = tItemUIHandle[sUIName]
							if oImage then
								local icon = "ICON:skill_icon1_x3y3"
								oImage:setmodel(icon)
							end
						end
						
						--修改商品名
						if (("_itemNameX") == sUIName) then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								local name = "正在获取..."
								oLabel:setText(name)
							end
						end
						
						--修改商品名（小号）
						if (("_itemName_SmallX") == sUIName) then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								local name = ""
								oLabel:setText(name)
							end
						end
						
						--修改商品碎片数量
						if (("_itemDebrisNumX") == sUIName) then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								local name = ""
								oLabel:setText(name)
							end
						end
						
						--修改商品价格
						if (("_itemRMBX") == sUIName) then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								local rmb = rmb
								oLabel:setText("??")
							end
						end
						
						--修改商品可购买次数
						if (("_itemLimitX") == sUIName) then
							local oLabel = tItemUIHandle[sUIName]
							if oLabel then
								oLabel:setText("-")
							end
						end
					end
				end
			end
		end
		
		--倒计时设置为"--:--:--"
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--[[
		--第一次绘制挡操作的按钮
		if (not _childUI["PageRuneCoverOpBtn"]) then
			_childUI["PageRuneCoverOpBtn"] = hUI.button:new({
				parent = _frm,
				x = 440,
				y = -325,
				z = 1000,
				model = "ui/login_lk.png",
				w = 872,
				h = 386,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.0,
				code = function()
					--print("DDD")
				end,
			})
			_childUI["PageRuneCoverOpBtn"].handle.s:setOpacity(0) --只挡操作，不显示
			
			--菊花
			_childUI["PageRuneCoverOpBtn"].childUI["WaitingImg"] = hUI.image:new({
				parent = _childUI["PageRuneCoverOpBtn"].handle._n,
				model = "MODEL_EFFECT:waiting",
				x = 0,
				y = 90,
				scale = 1.1,
			})
		end
		]]
		
		--第一次绘制重刷倒计时
		if (not _childUI["PageRuneTimeLabelPrefix"]) then
			_childUI["PageRuneTimeLabelPrefix"] = hUI.label:new({
				parent = _parent,
				x = 440 - 10,
				y = -410,
				--text = "重刷倒计时", --language
				text = hVar.tab_string["PVPChongShuaDaoJiShi"], --language
				align = "RC",
				border = 1,
				font = hVar.FONTC,
				size = 26,
				width = 500,
			})
			_childUI["PageRuneTimeLabelPrefix"].handle.s:setColor(ccc3(0, 255, 0))
		end
		
		--第一次绘制重刷倒计时的值
		if (not _childUI["PageRuneTimeLabel"]) then
			_childUI["PageRuneTimeLabel"] = hUI.label:new({
				parent = _parent,
				x = 440,
				y = -410 - 1, --字体有1像素偏差
				text = "",
				align = "LC",
				border = 0,
				size = 22,
				font = "numWhite",
				width = 500,
				
			})
			_childUI["PageRuneTimeLabel"].handle.s:setColor(ccc3(0, 255, 0))
		end
		
		--第一次绘制重刷按钮
		if (not _childUI["PageRuneRefreshBtn"]) then
			_childUI["PageRuneRefreshBtn"] = hUI.button:new({
				parent = _frm,
				x = 440,
				y = -460,
				z = 1000,
				model = "misc/mask.png",
				w = 180,
				h = 70,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--点击刷新今日商店按钮
					_CODE_OnClickRefreButton()
				end,
				
			})
			_childUI["PageRuneRefreshBtn"].handle.s:setOpacity(0) --只响应事件，不显示
			
			--图标1
			_childUI["PageRuneRefreshBtn"].childUI["image1"] = hUI.image:new({
				parent = _childUI["PageRuneRefreshBtn"].handle._n,
				x = 0,
				y = -4,
				model = "ui/buttonred.png",
				w = 140,
				h = 52,
			})
			
			--图标2
			_childUI["PageRuneRefreshBtn"].childUI["image2"] = hUI.image:new({
				parent = _childUI["PageRuneRefreshBtn"].handle._n,
				x = -28,
				y = 0,
				model = "ui/bimage_replay.png",
				w = 32,
				h = 32,
			})
			
			--刷新次数
			_childUI["PageRuneRefreshBtn"].childUI["num"] = hUI.label:new({
				parent = _childUI["PageRuneRefreshBtn"].handle._n,
				x = -2,
				y = -3,
				text = "x3",
				align = "LC",
				border = 0,
				font = "numWhite",
				size = 24,
				width = 500,
			})
			
			--游戏币图标
			_childUI["PageRuneRefreshBtn"].childUI["gamecoin"] = hUI.image:new({
				parent = _childUI["PageRuneRefreshBtn"].handle._n,
				x = 102,
				y = -1,
				model = "UI:game_coins",
				w = 46,
				h = 46,
			})
			
			--游戏币值
			_childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"] = hUI.label:new({
				parent = _childUI["PageRuneRefreshBtn"].handle._n,
				x = 120,
				y = -5,
				text = "--",
				align = "LC",
				border = 0,
				font = "numWhite",
				size = 22,
				width = 500,
			})
			_childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"].handle.s:setColor(ccc3(255, 255, 0
			))
		end
		
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--挡操作
		hUI.NetDisable(3000)
		--[[
		--显示挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(1)
			
			--防止长时间不响应
			local delay = CCDelayTime:create(10.0)
			local actCall = CCCallFunc:create(function(ctrl)
				_childUI["PageRuneCoverOpBtn"]:setstate(-1)
				
				--冒字
				--local strText = 连接超时，请稍后再试" --language
				local strText = hVar.tab_string["__TEXT_WattingPlease"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			end)
			local towAction = CCSequence:createWithTwoActions(delay, actCall)
			_childUI["PageRuneCoverOpBtn"].handle._n:runAction(towAction)
		end
		]]
		
		--显示重刷倒计时
		if _childUI["PageRuneTimeLabelPrefix"] then
			_childUI["PageRuneTimeLabelPrefix"].handle._n:setVisible(true)
		end
		
		--显示倒计时的值
		if _childUI["PageRuneTimeLabel"] then
			_childUI["PageRuneTimeLabel"].handle._n:setVisible(true)
			_childUI["PageRuneTimeLabel"]:setText("--:--:--")
		end
		
		--不响应重刷按钮点击事件
		if _childUI["PageRuneRefreshBtn"] then
			_childUI["PageRuneRefreshBtn"]:setstate(0)
			
			--今日重刷次数
			if _childUI["PageRuneRefreshBtn"].childUI["num"] then
				_childUI["PageRuneRefreshBtn"].childUI["num"]:setText("x?")
			end
			
			--今日重刷游戏币
			if _childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"] then
				_childUI["PageRuneRefreshBtn"].childUI["gamecoinNum"]:setText("--")
			end
		end
		
		--只有在本分页才会有的timer
		hApi.addTimerForever("__SHOP_TIMER_PAG_RUNE__", hVar.TIMER_MODE.GAMETIME, 1000, _CODE_timer_refresh_PageRune)
		
		--挡操作
		--hUI.NetDisable(3000)
		
		--是否要重新查询
		local enableQueryShop = true
		
		--读取存档里的今日商城商品列表数据
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		
		if list then
			--客户端的时间
			local localTime = os.time()
				
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime > 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableQueryShop = false
		end
		
		--需要查询每日商品列表
		if enableQueryShop then
			--print("查询每日商品列表")
			SendCmdFunc["open_shop"](shopId)
		else
			--模拟触发回调
			--print("模拟触发回调")
			hGlobal.event:event("localEvent_refresh_shopinfo", list.shopId, list.rmb_refresh_count, list.goods)
		end
	end
	
	--点击刷新今日商店按钮
	_CODE_OnClickRefreButton = function()
		--如果本地未联网，那么提示没联网
		if (g_cur_net_state == -1) then --未联网
			--local strText = 购买商品需要联网" --language
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion12_Net"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local version_control = tostring(g_version_control) --1.0.070502-v018-018-app
		local vbpos = string.find(version_control, "-")
		if vbpos then
			version_control = string.sub(version_control, 1, vbpos - 1)
		end
		if (local_srcVer < version_control) then
			--弹系统框
			local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
				msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. version_control .. ")"
			end
			hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			return
		end
		
		--检测今日刷新商店次数是否用光
		local leftRefreshCount = 0
		local shopId = 1
		local rmbCost = 20 --每次刷新消耗游戏币
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--刷新今日重刷次数
			local rmbRefreshCount = hVar.tab_shop[shopId].rmbRefreshCount --每天可用金币刷新n次
			local vipLv = LuaGetPlayerVipLv()
			if (vipLv > 0) then --vip有额外刷新次数
				local netshopRefreshCount = hVar.Vip_Conifg.netshopRefreshCount[vipLv] --vip该等级可以免费重刷的次数
				if (netshopRefreshCount > 0) then
					rmbRefreshCount = netshopRefreshCount
					--rmbCost = 0
				end
			end
			
			leftRefreshCount = rmbRefreshCount - list.rmb_refresh_count --剩余刷新商店次数
		end
		if (leftRefreshCount <= 0) then
			--local strText = 今日刷新次数已用完！" --language
			local strText = hVar.tab_string["__TEXT_TodayRefreshCountUsedUp"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--弹框
		local onclickevent = nil
		local MsgSelections = nil
		MsgSelections = {
			style = "mini",
			select = 0,
			ok = function()
				onclickevent()
			end,
			cancel = function()
				--
			end,
			--cancelFun = cancelCallback, --点否的回调函数
			--textOk = "确定", --language
			textOk = hVar.tab_string["Exit_Ack"], --language
			--textCancel = "取消", --language
			textCancel = hVar.tab_string["__TEXT_Cancel"], --language
			userflag = 0, --用户的标记
		}
		local showTitle = "是否消耗20游戏币立即刷新商品列表？"
		if (rmbCost == 0) then
			showTitle = "是否立即刷新商品列表？"
		end
		local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})
		
		--点击事件
		onclickevent = function()
			--挡操作
			--hUI.NetDisable(3000)
			
			--检测游戏币是否足够
			--local rmb = 20
			if (LuaGetPlayerRmb() < rmbCost) then
				--[[
				--弹系统框
				--local msgTitle = "游戏币不足" --language
				local msgTitle = hVar.tab_string["ios_not_enough_game_coin"] --language
				hGlobal.UI.MsgBox(msgTitle,{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				]]
				
				--弹出游戏币不足并提示是否购买的框
				hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
				
				return
			end
			
			--挡操作
			hUI.NetDisable(3000)
			
			--[[
			--显示挡操作按钮
			if _childUI["PageRuneCoverOpBtn"] then
				_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
				_childUI["PageRuneCoverOpBtn"]:setstate(1)
				
				--防止长时间不响应
				local delay = CCDelayTime:create(10.0)
				local actCall = CCCallFunc:create(function(ctrl)
					_childUI["PageRuneCoverOpBtn"]:setstate(-1)
					
					--冒字
					--local strText = 连接超时，请稍后再试" --language
					local strText = hVar.tab_string["__TEXT_WattingPlease"] --language
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				end)
				local towAction = CCSequence:createWithTwoActions(delay, actCall)
				_childUI["PageRuneCoverOpBtn"].handle._n:runAction(towAction)
			end
			]]
			
			--不响应重刷按钮点击事件
			if _childUI["PageRuneRefreshBtn"] then
				_childUI["PageRuneRefreshBtn"]:setstate(0)
			end
			
			--发送刷新每日商品的指令
			--print("发送刷新每日商品的指令", shopId)
			SendCmdFunc["refresh_shop"](shopId)
		end
	end
	
	--刷新每日商店倒计时timer
	_CODE_timer_refresh_PageRune = function()
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--客户端的时间
		local localTime = os.time()
			
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		local tabNow = os.date("*t", hosttime)
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		local hourNow = tabNow.hour
		local minNow = tabNow.min
		local secNow = tabNow.sec
		
		--[[
		--刷新倒计时
		local hourLeft = 23 - hourNow
		local minLeft = 59 - minNow
		local secLeft = 60 - secNow
		if (secLeft == 60) then --处理60秒
			secLeft = 0
			minLeft = minLeft + 1
		end
		if (minLeft == 60) then --处理60分
			minLeft = 0
			hourNow = hourNow + 1
		end
		
		local strHour = tostring(hourLeft) --小时(字符串)
		if (hourLeft < 10) then
			strHour = "0" .. strHour
		end
		local strMinute = tostring(minLeft) --分钟(字符串)
		if (minLeft < 10) then
			strMinute = "0" .. strMinute
		end
		local strSecond = tostring(secLeft) --秒(字符串)
		if (secLeft < 10) then
			strSecond = "0" .. strSecond
		end
		local strTime = ("%s:%s:%s"):format(strHour, strMinute, strSecond)
		]]
		--print(strTime)
		
		--读取存档的上次刷新的时间
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--客户端上次获取的时间
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--超过24小时
			if (deltatime <= 0) then
				deltatime = 0
				
				--发送刷新每日商品的指令
				--print("发送刷新每日商品的指令", shopId)
				SendCmdFunc["open_shop"](shopId)
			end
			
			--刷新倒计时
			local hour = math.floor(deltatime / 3600) --小时（总）
			local minute = math.floor((deltatime - hour * 3600) / 60) --分钟
			local second = deltatime - hour * 3600 - minute * 60 --秒
			
			local strHour = tostring(hour) --小时(字符串)
			if (hour < 10) then
				strHour = "0" .. strHour
			end
			local strMinute = tostring(minute) --分钟(字符串)
			if (minute < 10) then
				strMinute = "0" .. strMinute
			end
			local strSecond = tostring(second) --秒(字符串)
			if (second < 10) then
				strSecond = "0" .. strSecond
			end
			
			local strTime = ("%s:%s:%s"):format(strHour, strMinute, strSecond)
			if _childUI["PageRuneTimeLabel"] then
				_childUI["PageRuneTimeLabel"]:setText(strTime)
			end
		else
			if _childUI["PageRuneTimeLabel"] then
				_childUI["PageRuneTimeLabel"]:setText("--:--:--")
			end
		end
	end
	
	--检测提示今日商店商品刷新的叹号动态提示箭头是否显示
	_CODE_CheckHintTanHaoVisible = function()
		local _frm = hGlobal.UI.NetShopFramII
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--检测是否到第二天刷新了商城出售的道具
		local enableQueryShop = true
		
		--读取存档里的今日商城商品列表数据
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		
		if list then
			--客户端的时间
			local localTime = os.time()
				
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime > 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableQueryShop = false
		end
		
		local oBtn = _childUI["Page_Rune"]
		if oBtn then
			if oBtn.childUI["PageTanHao"] then
				oBtn.childUI["PageTanHao"].handle._n:setVisible(enableQueryShop)
			end
		end
	end
	
	---------------------------
	--激活商店Page购买按钮
	---------------------------
	_CODE_EnableItemPageUI = function(nIndex,nEnable)
		if _NSP_ItemPage[nIndex] then
			local oGrid = _childUI[_NSP_ItemPage[nIndex][1].."Grid"]
			
			if nEnable==1 then
				oGrid.handle._n:setVisible(true)			--使指定的页的内容可视
			else
				oGrid.handle._n:setVisible(false)
			end
			
			if _NSP_PageItemUIHandle[nIndex] then
				local sPageMode = _NSP_ItemPage[nIndex][2]		--ShopItem,RuneItem,EliteItem
				local tUIList = _NSP_PageItemUI[sPageMode]
				for k,tItemUIHandle in pairs(_NSP_PageItemUIHandle[nIndex].handle)do
					for i = 1,#tUIList do
						local sUIType = tUIList[i][1]		--button,image……………………
						local sUIName = tUIList[i][2]		--_itemBuyBtn， _itemLock………………
						if sUIType=="button" then
							local oBtn = tItemUIHandle[sUIName]
							if oBtn then
								if nEnable==1 and hApi.IsInBox(oBtn.data.x+oGrid.data.x,oBtn.data.y+oGrid.data.y,_NSP_ItemPage_ClippingRect) then
									--print("page="..nIndex,"grid="..k,"enable")
									oBtn.data.state = 1
									oBtn.data.ox = oGrid.data.x
									oBtn.data.oy = oGrid.data.y
									oBtn:setXY(oBtn.data.x,oBtn.data.y)
								else
									--print("page="..nIndex,"grid="..k,"disable")
									oBtn.data.state = 0
								end
							end
						end
					end
				end
			end
		end
	end
	
	---------------------------------------------------
	--点击商品页面的处理
	---------------------------------------------------
	--点击商品页(按下)
	_CODE_HitItemPage = function(self,tTempPos,sPageName)
		local sGridName = sPageName.."Grid"
		local oGrid = self.childUI[sGridName]
		if oGrid~=nil and type(oGrid.data.item)=="table" then
			local tPickParam = {state=0,itemID=0,sGridName=sGridName}
			if _NSP_ItemPage[_NSP_ItemPage_Current] then
				local sPageMode = _NSP_ItemPage[_NSP_ItemPage_Current][2]
				local tUIList = _NSP_PageItemUI[sPageMode]
				local nOffsetX = -1*tUIList.data.ox - oGrid.data.gridW/2
				local nOffsetY = -1*tUIList.data.oy
				local _,_,oItem = oGrid:xy2grid(tTempPos.tx-_FrmBG.data.x+nOffsetX,tTempPos.ty-_FrmBG.data.y+nOffsetY,"parent")
				if type(oItem)=="table" and type(oItem[hVar.ITEM_DATA_INDEX.ID])=="number" then
					local nItemID = _CODE_ItemPageGetItemID(_NSP_ItemPage[_NSP_ItemPage_Current][2],oItem[hVar.ITEM_DATA_INDEX.ID])
					if nItemID<=100 then
						--所有id大于100的物品才视为普通物品
					elseif _NSP_TipTokenItem[1][1]~=nItemID then
						tPickParam.itemID = nItemID
					else
						_CODE_HideShopItemTip()
					end
				end
			end
			return tPickParam
		end
	end
	
	--拖动商品页
	_CODE_DragItemPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then
				tPickParam.state = 1
				tTempPos.tx = tTempPos.x
				tTempPos.ty = tTempPos.y
			else
				return 0
			end
		end
	end
	
	--抬起商品页(松开鼠标)
	_CODE_DropItemPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==1 then
			self:aligngrid(_NSP_ItemPage_GridAlign,_NSP_ItemPage_DragRect,tTempPos)
			_CODE_EnableItemPageUI(_NSP_ItemPage_Current,1)
			_CODE_HideShopItemTip()
		elseif tPickParam.itemID~=0 then
			local nItemID = tPickParam.itemID
			
			--geyachao: 针对每日商城道具的特殊转换
			if (nItemID == 1998) then
				--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][1][1]
				local itemIdx = 1
				local shopId = 1
				local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
				if list then
					local goods = list.goods
					if goods then
						local good = goods[itemIdx]
						if good then
							nItemID = good.itemId --tab_item的id
						end
					end
				end
			elseif (nItemID == 1999) then
				--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][2][1]
				local itemIdx = 2
				local shopId = 1
				local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
				if list then
					local goods = list.goods
					if goods then
						local good = goods[itemIdx]
						if good then
							nItemID = good.itemId --tab_item的id
						end
					end
				end
			elseif (nItemID == 2000) then
				--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][3][1]
				local itemIdx = 3
				local shopId = 1
				local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
				if list then
					local goods = list.goods
					if goods then
						local good = goods[itemIdx]
						if good then
							nItemID = good.itemId --tab_item的id
						end
					end
				end
			end
			
			--print(nItemID)
			
			_NSP_TipTokenItem[1][1] = nItemID
			local tabI = hVar.tab_item[nItemID]
			local oItem = _NSP_TipTokenItem[1]
			if hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=nil then
				--是装备，一孔
				oItem[hVar.ITEM_DATA_INDEX.ID] = nItemID
				oItem[hVar.ITEM_DATA_INDEX.SLOT][1] = 1
			else
				if tabI.type==hVar.ITEM_TYPE.HEROCARD then
					oItem[hVar.ITEM_DATA_INDEX.ID] = 0
					--英雄卡片，显示购买卡片页面
					for i = 1,199 do
						local v = hVar.tab_shopitem[i]
						if v and v.itemID == nItemID then
							return hGlobal.event:event("LocalEvent_ShowBuyHeroCardFrm",nil,i,nil,tabI.heroID, tabI.heroStar, tabI.heroLv)
						end
					end
				else
					--不是装备，没有孔
					oItem[hVar.ITEM_DATA_INDEX.ID] = nItemID
					oItem[hVar.ITEM_DATA_INDEX.SLOT][1] = 0
				end
			end
			if oItem[hVar.ITEM_DATA_INDEX.ID]~=0 then
				hGlobal.event:event("LocalEvent_HitOnShopItem",nItemID,tTempPos.tx,tTempPos.ty)
				if tabI.type==hVar.ITEM_TYPE.GIFTITEM then
					hGlobal.event:event("LocalEvent_GiftItemTip",oItem[hVar.ITEM_DATA_INDEX.ID])
					_CODE_HideShopItemTip()
					return
				end
				if tTempPos.tx>hVar.SCREEN.w*1/2 then
					--在左边显示
					hGlobal.event:event("LocalEvent_ShowItemTipFram",_NSP_TipTokenItem,nil,1, 30,620)
				else
					--在右边显示
					hGlobal.event:event("LocalEvent_ShowItemTipFram",_NSP_TipTokenItem,nil,1,hVar.SCREEN.w-350,620)
				end
			end
		else
			_CODE_HideShopItemTip()
		end
	end
	
	---------------------------------------------------
	--点击购买按钮的处理
	---------------------------------------------------
	_CODE_ClickBuyItemBtn = function(nShopItemID, nItemID)
		--print("_CODE_ClickBuyItemBtn", nShopItemID, nItemID)
		local nDisableTick = _NSP_ShopItemCoodown.tick - hApi.gametime()
		if nDisableTick>0 then
			_DEBUG_MSG("[NET SHOP]购买ui冷却中，剩余"..nDisableTick)
			--不准买！
			return
		end
		--if g_cur_net_state~=1 then
			--_DEBUG_MSG("[NET SHOP]无网络状态不能买东西!")
			--return
		--end
		local tabSI = hVar.tab_shopitem[nShopItemID]
		if tabSI==nil then
			return
		end
		--如果存在购买锁
		local nBuyLockTick = (_NSP_ShopItemBuyLock[nShopItemID] or 0)
		local sBuyLockHint = hVar.tab_string["ios_tip_network_waiting_server_response"]
		if g_cur_net_state~=1 then
			--如果断网了，不让买东西，并且修改提示为无法连接服务器
			if nBuyLockTick==0 then
				nBuyLockTick = 1
				_NSP_ShopItemBuyLock[nShopItemID] = 1
			end
			sBuyLockHint = hVar.tab_string["ios_err_network_cannot_conn_server"]
		end
		if nBuyLockTick>0 then
			if hApi.gametime()-nBuyLockTick>0 then
				_NSP_ShopItemBuyLock[nShopItemID] = hApi.gametime() + 500
				hUI.floatNumber:new({
					x = hVar.SCREEN.w/2,
					y = hVar.SCREEN.h/2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -500,
					moveY = 32,
				}):addtext(sBuyLockHint,hVar.FONTC,48,"MC",32,0)
			end
			return
		end
		local nItemID = tabSI.itemID
		local nCostScore = tabSI.score
		local nCostRMB = tabSI.rmb
		local sItemName = hVar.tab_stringI[nItemID][1]
		if type(sItemName)=="string" and type(nItemID)=="number" and hVar.tab_item[nItemID]~=nil and type(nCostScore)=="number" and type(nCostRMB)=="number" then
			--合法的道具购买
		else
			_DEBUG_MSG("[NET SHOP]("..tostring(nShopItemID)..","..tostring(nItemID)..")非法的道具购买！")
			return
		end
		--指向item
		local tabI = hVar.tab_item[nItemID]
		-- 如果联网状态 并且活动开启 则修改商品价格 活动价格表 在 netshop 中生命 以前是 local 现在是全局表
		for i = 1,#g_activity_list do
			if g_activity_list[i].itemID == nItemID then
				nCostRMB = g_activity_list[i].rmb
				nCostScore = g_activity_list[i].score
			end
		end
		
		--购买判断
		local CanBuy = 0
		local CanNotBuyHint = 0
		
		--检测该道具今日是否已购买到上限
		local num = LuaGetTodayShopItemLimitCount(g_curPlayerName, nShopItemID, hVar.NET_SHOP_ITEM_DAY_LIMIT)
		--print(num)
		if (num <= 0) then
			--今天不能买了
			--"该商品今日购买次数已用完！"
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_TodayBuyItemUsedUp"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			return
		end
		
		if (tabI.type == hVar.ITEM_TYPE.HEROCARD) then
			--print("分支 1")
			--英雄卡弹出另外个界面买
			return hGlobal.event:event("LocalEvent_ShowBuyHeroCardFrm",nil,nShopItemID,nil,tabI.heroID, tabI.heroStar, tabI.heroLv)
		--elseif tabI.type == hVar.ITEM_TYPE.GIFTITEM then
			--return hGlobal.event:event("LocalEvent_BuyGiftItem",hVar.tab_item[itemID].gift)
		elseif tabI.type==hVar.ITEM_TYPE.RESOURCES then
			--print("分支 2")
			local nNowScore = LuaGetPlayerScore()
			local nAddScore = 0
			if tabI.resource and type(tabI.resource) == "table" then
				if tabI.resource[1] == "score" then
					nAddScore = tabI.resource[2] or 0
				end
			end
			--如果购买的积分超上限则提示
			if (math.max((nNowScore - nCostScore),0) + nAddScore) <= LuaGetMaxScore() then
				CanBuy = 1
			else
				CanBuy = 0
				CanNotBuyHint = hVar.tab_string["__TEXT_ScoreRangeOut"]
			end
			
			--资源，只允许在查看世界地图的时候买
			--local oWorld = hGlobal.WORLD.LastWorldMap
			--if oWorld and hGlobal.LocalPlayer:getfocusworld()==oWorld then
			--	CanBuy = 1
			--else
			--	CanBuy = 0
			--	CanNotBuyHint = hVar.tab_string["__TEXT_ITEMLISTISFULL_GAME"]
			--end
		elseif tabI.type == hVar.ITEM_TYPE.PLAYERITEM then
			--print("分支 3")
			--不知道是啥，让你买
			CanBuy = 1
		elseif hApi.CheckEntityItem(nItemID) ~= 0 then
			--print("分支 4")
			--特殊，让你买
			if hApi.CheckEntityItemMaxN(nItemID,g_NetShopData.BuyLimit[nItemID]) == 1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BuyItemMaxN"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return 
			end
			CanBuy = 1
		else
			--print("分支 5")
			--外面的大厅购买
			local tPlayerBag = LuaGetPlayerBag()
			if tPlayerBag then
				for i = 1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
					if tPlayerBag[i] == 0 then
						CanBuy = 1
						break
					end
				end
				
				--检测新手特惠包裹
				if tabI.type==hVar.ITEM_TYPE.GIFTITEM and type(tabI.bagN) == "number" then
					local bagN = tabI.bagN or 2
					local m_slotn = 0
					for i=1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
						if tPlayerBag[i] == 0 then
							m_slotn = m_slotn + 1
						end
					end
					if m_slotn >= bagN then
						CanBuy = 1
					else
						CanBuy = 0
					end
				end
				--print("走进来了")
			end
			
			if CanBuy~=1 then
				CanBuy = 0
				CanNotBuyHint = hVar.tab_string["__TEXT_BAGLISTISFULL1"]
			end
		end
		
		if CanBuy == 1 then
			hApi.PlaySound("pay_gold")
			--hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,nItemID)
			--买带有冷却时间的道具的话，会有一段时间无法点击按钮
			if _NSP_ShopItemCoodown[nItemID]~=nil then
				_NSP_ShopItemCoodown.tick = hApi.gametime() + _NSP_ShopItemCoodown[nItemID]
			end
			if LuaGetPlayerScore() >= nCostScore and _cur_rmb >= nCostRMB then
				--增加购买锁
				_NSP_ShopItemBuyLock[nShopItemID] = 1
				--LuaAddPlayerScore(-nCostScore)
				--如果不消耗游戏币 也发送一条 用来做统计
				--上传玩家积分
				local update_score_count = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_update_score_count")
				if update_score_count > 10 then
					SendCmdFunc["update_cur_score"](g_curPlayerName,LuaGetPlayerScore())
					CCUserDefault:sharedUserDefault():setIntegerForKey("xl_update_score_count",0)
					CCUserDefault:sharedUserDefault():flush()
				else
					CCUserDefault:sharedUserDefault():setIntegerForKey("xl_update_score_count",update_score_count+1)
					CCUserDefault:sharedUserDefault():flush()
				end
				
				--if tabI.onlyonce==1 or tabSI.onlyonce==1 then
					----限购道具购买流程
					--if tabSI.confirmBox == 1 then
						--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_confirmBuyTip"].."\n"..hVar.tab_string["["]..sItemName..hVar.tab_string["]"].."?",{
							--font = hVar.FONTC,
							--ok = function()
								--g_NetShopData.MyShopRecord = g_NetShopData.MyShopRecord..nItemID..":1;"
								--SendCmdFunc["setShopState"](g_NetShopData.MyShopRecord,nShopItemID,g_NetShopData.MyShopRecord)
							--end,
							--cancel = function()
								--_NSP_ShopItemBuyLock[nShopItemID] = 0
							--end,
						--})
					--else
						--g_NetShopData.MyShopRecord = g_NetShopData.MyShopRecord..nItemID..":1;"
						--SendCmdFunc["setShopState"](g_NetShopData.MyShopRecord,nShopItemID,g_NetShopData.MyShopRecord)
					--end
				--else
					----一般道具购买流程
					--if tabSI.confirmBox == 1 then
						--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_confirmBuyTip"].."\n"..hVar.tab_string["["]..sItemName..hVar.tab_string["]"].."?",{
							--font = hVar.FONTC,
							--ok = function()
								----SendCmdFunc["buy_shopitem"](nItemID,nCostRMB,sItemName,nCostScore,"sc:"..nCostScore)
								--SendCmdFunc["order_begin"](hVar.ORDER_SYS_TYPE[nItemID] or 6,nItemID,nCostRMB,1,sItemName,nCostScore,0,"sc:"..nCostScore)
							--end,
							--cancel = function()
								--_NSP_ShopItemBuyLock[nShopItemID] = 0
							--end,
						--})
					--else
						----SendCmdFunc["buy_shopitem"](nItemID,nCostRMB,sItemName,nCostScore,"sc:"..nCostScore)
						--SendCmdFunc["order_begin"](hVar.ORDER_SYS_TYPE[nItemID] or 6,nItemID,nCostRMB,1,sItemName,nCostScore,0,"sc:"..nCostScore)
					--end
				--end
				
				if (nShopItemID == 345) then --红装锦囊
					--挡操作
					hUI.NetDisable(3000)
					
					--[[
					--身上所有的背包都满了
					if (LuaCheckPlayerBagCanUse() == 0) then
						--local strText = "背包已满，不能再开启锦囊" --language
						local strText = hVar.tab_string["__TEXT_Cant_BagItemChstFull_Net"] --language
						--冒字
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					]]
					
					--连接pvp服务器，获取碎片、将魂
					if (Pvp_Server:GetState() ~= 1) then --未连接
						Pvp_Server:Connect()
					end
					if (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
						Pvp_Server:UserLogin()
					end
					
					--购买红装
					local pageIdx_host = 2
					local index_host = 1
					local bIsRedEquipDebris = false
					SendCmdFunc["buyitem"](pageIdx_host, index_host, bIsRedEquipDebris)
				else
					--一般道具购买流程(限购道具流程已经修改，不在此处进行限购，而是改为在购买成功时，记录到存档中)
					if tabSI.confirmBox == 1 then
						--print("分支 7")
						hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_confirmBuyTip"].."\n"..hVar.tab_string["["]..sItemName..hVar.tab_string["]"].."?",{
							font = hVar.FONTC,
							ok = function()
								--SendCmdFunc["buy_shopitem"](nItemID,nCostRMB,sItemName,nCostScore,"sc:"..nCostScore)
								SendCmdFunc["order_begin"](hVar.ORDER_SYS_TYPE[nItemID] or 6,nItemID,nCostRMB,1,sItemName,nCostScore,0,"sc:"..nCostScore)
							end,
							cancel = function()
								_NSP_ShopItemBuyLock[nShopItemID] = 0
							end,
						})
					else
						--print("分支 8")
						--SendCmdFunc["buy_shopitem"](nItemID,nCostRMB,sItemName,nCostScore,"sc:"..nCostScore)
						SendCmdFunc["order_begin"](hVar.ORDER_SYS_TYPE[nItemID] or 6,nItemID,nCostRMB,1,sItemName,nCostScore,0,"sc:"..nCostScore)
					end
				end
			else
				--print("分支 9")
				
				if _cur_rmb < nCostRMB then
					--漂浮文字："游戏币不足"
					hUI.floatNumber:new({
						text = "",
						font = "numRed",
						moveY = 64,
					}):addtext(hVar.tab_string["ios_not_enough_game_coin"],hVar.FONTC,36,"MC",_FrmBG.data.x+420,_FrmBG.data.y-252)
					
				elseif LuaGetPlayerScore() < nCostScore then
					--漂浮文字："积分不足"
					hUI.floatNumber:new({
						text = "",
						font = "numRed",
						moveY = 64,
					}):addtext(hVar.tab_string["__TEXT_ScoreNotEnough"],hVar.FONTC,36,"MC",_FrmBG.data.x+420,_FrmBG.data.y-252)
				end
			end
			
		else
			--print("分支 10")
			if CanNotBuyHint==0 then
				CanNotBuyHint = hVar.tab_string["__TEXT_ITEMLISTISFULL"]		--【道具栏已满】
			end
			
			--漂浮文字："仓库已满，无法购买道具..."
			hUI.floatNumber:new({
				text = "",
				font = "numRed",
				moveY = 64,
			}):addtext(CanNotBuyHint,hVar.FONTC,36,"MC",_FrmBG.data.x+420,_FrmBG.data.y-252)
		end
	end
	
	--点击购买按钮每日商品的处理
	_CODE_ClickBuyItemBtn_Rune = function(nShopItemID, nItemID)
		local itemIdx = 0
		if (nShopItemID == 198) then
			--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][1][1]
			itemIdx = 1
		elseif (nShopItemID == 199) then
			--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][2][1]
			itemIdx = 2
		elseif (nShopItemID == 200) then
			--nShopItemID = hVar.NET_SHOP_ITEM["Page_Rune"][3][1]
			itemIdx = 3
		end
		
		--print("itemIdx=", itemIdx, "nShopItemID=" .. nShopItemID)
		
		--如果本地未联网，那么提示没联网
		if (g_cur_net_state == -1) then --未联网
			--local strText = 购买商品需要联网" --language
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion12_Net"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local version_control = tostring(g_version_control) --1.0.070502-v018-018-app
		local vbpos = string.find(version_control, "-")
		if vbpos then
			version_control = string.sub(version_control, 1, vbpos - 1)
		end
		if (local_srcVer < version_control) then
			--弹系统框
			local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
				msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. version_control .. ")"
			end
			hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			return
		end
		
		--检测购买次数是否用光
		local leftCount = 0
		local requireRmb = 0
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			local goods = list.goods
			if goods then
				local good = goods[itemIdx]
				if good then
					leftCount = good.quota - good.saledCount --总购买次数 - 已购买次数
					requireRmb = good.rmb
				end
			end
		end
		if (leftCount <= 0) then
			--local strText = 该商品今日购买次数已用完！" --language
			local strText = hVar.tab_string["__TEXT_TodayBuyItemUsedUp"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测游戏币是否足够
		if (LuaGetPlayerRmb() < requireRmb) then
			--local strText = 游戏币不足！" --language
			local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--挡操作
		hUI.NetDisable(3000)
		
		--[[
		--显示挡操作按钮
		if _childUI["PageRuneCoverOpBtn"] then
			_childUI["PageRuneCoverOpBtn"].handle._n:stopAllActions()
			_childUI["PageRuneCoverOpBtn"]:setstate(1)
			
			--防止长时间不响应
			local delay = CCDelayTime:create(10.0)
			local actCall = CCCallFunc:create(function(ctrl)
				_childUI["PageRuneCoverOpBtn"]:setstate(-1)
				
				--冒字
				--local strText = 连接超时，请稍后再试" --language
				local strText = hVar.tab_string["__TEXT_WattingPlease"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			end)
			local towAction = CCSequence:createWithTwoActions(delay, actCall)
			_childUI["PageRuneCoverOpBtn"].handle._n:runAction(towAction)
		end
		]]
		
		--不响应重刷按钮点击事件
		if _childUI["PageRuneRefreshBtn"] then
			_childUI["PageRuneRefreshBtn"]:setstate(0)
		end
		
		--发送购买每日商品的指令
		local shopId = 1
		--print("发送购买每日商品的指令", shopId, itemIdx)
		SendCmdFunc["buyitem"](shopId, itemIdx)
	end
end
--[[
--测试
LuaClearTodayNetShopGoods(g_curPlayerName)
if hGlobal.UI.NetShopFramII then
	hGlobal.UI.NetShopFramII.data.closebtn.code() --关闭上一次的
end
hGlobal.UI.InitNetShopFramII("include")
hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx", "hall")
]]


















--创建主城开商店买东西引导流程
function CreateGuideFrame_ShopBuy()
	--主城开商店买东西引导状态集
	hGlobal.UI.GuideShopBuyStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_SHOP = 1, --提示点击商店
		GUIDE_WAIT_CLICK_SHOP = 2, --等待点击商店按钮
		GUIDE_CLICK_PAGE1 = 3, --提示点击第一个分页按钮
		WAIT_CLICK_PAGE1 = 4, --等待点击第一个分页按钮
		GUIDE_CLICK_NEW_ITEM_BTN = 5, --提示点击新手礼包按钮
		WAIT_CLICK_NEW_ITEM_BTN = 6, --等待点击新手礼包按钮
		WAIT_MSG_BOX_STATE = 7, --对话框操作界面状态
		GUIDE_CLICK_CLOSE_BTN = 8, --提示点击关闭按钮
		GUIDE_WAIT_CLOSE_BTN = 9, --等待点击关闭按钮
		GUIDE_END = 10, --引导结束
	}
	
	--引导的当前状态
	hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideShopHandEffect then --提示点击商店的手的特效
		hGlobal.UI.GuideShopHandEffect:del()
		hGlobal.UI.GuideShopHandEffect = nil
	end
	if hGlobal.UI.GuideShopRoundEffect then --提示点击商店的转圈圈特效
		hGlobal.UI.GuideShopRoundEffect:del()
		hGlobal.UI.GuideShopRoundEffect = nil
	end
	if hGlobal.UI.GuideShopPageHandEffect then --提示点击商店第一个分页的手的特效
		hGlobal.UI.GuideShopPageHandEffect:del()
		hGlobal.UI.GuideShopPageHandEffect = nil
	end
	if hGlobal.UI.GuideShopPageRoundEffect then --提示点击商店第一个分页的转圈圈特效
		hGlobal.UI.GuideShopPageRoundEffect:del()
		hGlobal.UI.GuideShopPageRoundEffect = nil
	end
	if hGlobal.UI.GuideShopGiftHandEffect then --提示点击新手礼包按钮的手的特效
		hGlobal.UI.GuideShopGiftHandEffect:del()
		hGlobal.UI.GuideShopGiftHandEffect = nil
	end
	if hGlobal.UI.GuideShopGiftRoundEffect then --提示点击新手礼包按钮的转圈圈特效
		hGlobal.UI.GuideShopGiftRoundEffect:del()
		hGlobal.UI.GuideShopGiftRoundEffect = nil
	end
	if hGlobal.UI.GuideShopCloseHandEffect then --提示点击关闭按钮的手的特效
		hGlobal.UI.GuideShopCloseHandEffect:del()
		hGlobal.UI.GuideShopCloseHandEffect = nil
	end
	if hGlobal.UI.GuideShopCloseRoundEffect then --提示点击关闭按钮的转圈圈特效
		hGlobal.UI.GuideShopCloseRoundEffect:del()
		hGlobal.UI.GuideShopCloseRoundEffect = nil
	end
	
	--删除主界面
	if hGlobal.UI.GuideShopBuyMenuBar then --引导开商店买东西的主界面
		hGlobal.UI.GuideShopBuyMenuBar:del()
		hGlobal.UI.GuideShopBuyMenuBar = nil
	end
	
	--创建引导开商店买东西的主界面
	--创建父容器
	hGlobal.UI.GuideShopBuyMenuBar = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		--z = -1,
		show = 1,
		dragable = 2,
		--buttononly = 1,
		autoactive = 0,
		--background = "UI:PANEL_INFO_MINI",
		background = -1,
		failcall = 1, --出按钮区域抬起也会响应事件
		
		--点击事件（有可能在控件外部点击）
		codeOnDragEx = function(screenX, screenY, touchMode)
			--print("codeOnDragEx", screenX, screenY, touchMode)
			if (touchMode == 0) then --按下
				--
			elseif (touchMode == 1) then --滑动
				--
			elseif (touchMode == 2) then --抬起
				--点击引导第二关界面事件
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				OnClickGuideShopBuyFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideShopBuyMenuBar:active() --最前端显示
	
	--点击引导开商店买东西的主界面的事件
	function OnClickGuideShopBuyFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导开商店买东西的主界面")
			
			--进入下个状态: 开场简介
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_SHOP
			
			--显示对话框：引导提示商店
			__Dialogue_GuideShopBuy_ShopIntroduce()
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_SHOP) then --提示点击商店
			--[[
			--geyachao: 有主城模式的流程
			--找到商店角色
			local oMap = __G_MainMenuWorld --主界面地图
			local tAllChaHandle = oMap.data.chaHandle
			local shopTypeId = 60012 --商店角色类型id
			local tChaShopHandle = nil --商店单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == shopTypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaShopHandle = tChaHandle
					break
				end
			end
			
			local towerScreenX, towerScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建提示点击商店按钮的手特效
			hGlobal.UI.GuideShopHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = towerScreenX - 10,
				y = towerScreenY + 85,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideShopHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--商店单位描边
			local program = hApi.getShader("outline")
			tChaShopHandle.s:setShaderProgram(program)
			local act1 = CCFadeTo:create(0.5, 168)
			local act2 = CCFadeTo:create(0.5, 255)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			tChaShopHandle.s:runAction(CCRepeatForever:create(sequence))
			]]
			
			--geyachao: 无主城模式的流程
			--创建提示点击商店按钮的转圈圈特效
			local guideDy = -55
			if (g_phone_mode ~= 0) then --手机模式
				guideDy = -45
			end
			hGlobal.UI.GuideShopRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = hVar.SCREEN.w - 60,
				y = hVar.SCREEN.h + guideDy,
				--w = 220,
				--h = 220,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideShopRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideShopRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideShopRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(2.3)
			
			--创建提示点击商店按钮的手特效
			hGlobal.UI.GuideShopHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = hVar.SCREEN.w - 60,
				y = hVar.SCREEN.h + guideDy - 40,
				scale = 1.5,
				z = 100,
			})
			hGlobal.UI.GuideShopHandEffect.handle._n:setRotation(180)
			
			--进入下个状态: 等待点击商店按钮
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_WAIT_CLICK_SHOP
			
			--显示对话框：引导主城开商店点击商店按钮
			__Dialogue_GuideShopBuy_Click_Shop()
			
			
			--监听点击商城按钮事件，也进入下个状态（因为有时候莫名其妙的商店按钮在最顶层，只能监听到该点击事件）
			hGlobal.event:listen("LocalEvent_Click_Guide_ShopButton", "ClickShopButton", function()
				--删除监听
				hGlobal.event:listen("LocalEvent_Click_Guide_ShopButton", "ClickShopButton", nil)
				--print("--删除监听--删除监听--删除监听--删除监听")
				local x = hVar.SCREEN.w - 60
				local y = hVar.SCREEN.h + guideDy
				local w = 220
				local h = 220
				local left = x - w / 2
				local right = x + w / 2
				local top = y - h / 2
				local bottom = y + h / 2
				
				--强制跳转到下一个状态
				OnClickGuideShopBuyFrame_Event((left + right) / 2, (top + bottom) / 2)
			end)
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_WAIT_CLICK_SHOP) then --提示点击商店按钮
			--[[
			--geyachao: 有主城模式的流程
			--检测是否点击到了商店按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oMap = __G_MainMenuWorld --主界面地图
			local tChaShopHandle = oMap:hit2cha(worldX, worldY)
			local shopTypeId = 60012 --商店角色类型id
			if tChaShopHandle then
				if (tChaShopHandle.data.id == shopTypeId) then
					--删除提示点击商店按钮的手特效
					if hGlobal.UI.GuideShopHandEffect then --点击商店的手的特效
						hGlobal.UI.GuideShopHandEffect:del()
						hGlobal.UI.GuideShopHandEffect = nil
					end
					
					--停止商店单位的运动
					tChaShopHandle.s:stopAllActions()
					--剧情战役单位不描边
					local program = hApi.getShader("normal")
					tChaShopHandle.s:setShaderProgram(program)
			]]
			--检测是否点击到了商店按钮
			local x = hVar.SCREEN.w - 60
			local y = hVar.SCREEN.h - 50
			local w = 220
			local h = 220
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--删除提示点击商店按钮的手特效
				if hGlobal.UI.GuideShopHandEffect then --点击商店的手的特效
					hGlobal.UI.GuideShopHandEffect:del()
					hGlobal.UI.GuideShopHandEffect = nil
				end
				
				--删除提示点击商店按钮的转圈圈特效
				if hGlobal.UI.GuideShopRoundEffect then --点击商店的转圈圈特效
					hGlobal.UI.GuideShopRoundEffect:del()
					hGlobal.UI.GuideShopRoundEffect = nil
				end
				
				--删除监听
				hGlobal.event:listen("LocalEvent_Click_Guide_ShopButton", "ClickShopButton", nil)
				
				--监听商城打开游戏币界面事件
				hGlobal.event:listen("LocalEvent_ShowGameCoinFrm", "GuideShopView", function(Page)
					--print("监听商城打开事件 LocalEvent_ShowGameCoinFrm")
					--删除监听事件
					hGlobal.event:listen("LocalEvent_ShowGameCoinFrm", "GuideShopView", nil)
					
					--主界面最前端显示
					hGlobal.UI.GuideShopBuyMenuBar:active() --最前端显示
				end)
				
				--模拟执行点击大地图事件
				--oMap.data.codeOnTouchUp(oMap, worldX, worldY, clickScreenX, clickScreenY)
				--hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx","hall")
				--geyachao: 为了防止没有网络不能打开商店，这里改为直接暴力打开商店
				--模拟打开商店，并显示第一个分页
				hVar.NET_SHOP_ITEM_TMP = hVar.NET_SHOP_ITEM --缓存商店卖的东西
				hVar.NET_SHOP_ITEM = {["Page_Guide"] = {{96},},}--网络商店里面卖的东西（仅供新手引导）
				hGlobal.UI.InitNetShopFramII("include")
				_CODE_SwitchItemPage("Page_Guide", nil)
				hGlobal.UI.NetShopFramII:show(1)
				
				hVar.NET_SHOP_ITEM = hVar.NET_SHOP_ITEM_TMP --还原商店卖的东西
				hVar.NET_SHOP_ITEM_TMP = nil
				
				--模拟打开金币界面
				local _frm = hGlobal.UI.NetShopFramII
				local _parent = _frm.handle._n
				local _childUI = _frm.childUI
				_childUI["HeroSlot"].handle._n:setVisible(false)
				_childUI["HeroIcon"].handle._n:setVisible(false)
				hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
				
				--进入下个状态: 提示点击第一个分页按钮
				hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_PAGE1
				
				--无对话
				--...
				
				--强制跳转到下一个状态
				OnClickGuideShopBuyFrame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_PAGE1) then --提示点击第一个分页按钮
			--创建提示点击商店第一个分页的转圈圈特效
			local PAGE1_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local PAGE1_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			hGlobal.UI.GuideShopPageRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = 138 + PAGE1_DX,
				y = 523 + PAGE1_DY,
				--w = 224,
				--h = 108,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideShopPageRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideShopPageRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideShopPageRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 34, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击商店第一个分页的手的特效
			hGlobal.UI.GuideShopPageHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = 140 + PAGE1_DX,
				y = 550 + PAGE1_DY,
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideShopPageHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击第一个分页按钮
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.WAIT_CLICK_PAGE1
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.WAIT_CLICK_PAGE1) then --等待点击第一个分页按钮
			--检测是否点到了商城第一个分页按钮里面
			local PAGE1_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local PAGE1_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			local x = 138 + PAGE1_DX
			local y = 523 + PAGE1_DY
			local w = 100
			local h = 50
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--删除提示点击商店第一个分页的手的特效
				if hGlobal.UI.GuideShopPageHandEffect then
					hGlobal.UI.GuideShopPageHandEffect:del()
					hGlobal.UI.GuideShopPageHandEffect = nil
				end
				
				--删除提示点击商店第一个分页的转圈圈特效
				if hGlobal.UI.GuideShopPageRoundEffect then
					hGlobal.UI.GuideShopPageRoundEffect:del()
					hGlobal.UI.GuideShopPageRoundEffect = nil
				end
				
				--进入下个状态: 提示点击新手礼包按钮
				hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_NEW_ITEM_BTN
				
				--无对话
				--...
				
				--强制跳转到下一个状态
				OnClickGuideShopBuyFrame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_NEW_ITEM_BTN) then --提示点击新手礼包按钮
			--创建提示点击新手礼包按钮的转圈圈特效
			local GIFT_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local GIFT_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			hGlobal.UI.GuideShopGiftRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = 240 + GIFT_DX,
				y = 344 + GIFT_DY,
				--w = 200,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideShopGiftRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideShopGiftRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideShopGiftRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击新手礼包按钮的手的特效
			hGlobal.UI.GuideShopGiftHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = 240 + GIFT_DX,
				y = 370 + GIFT_DY,
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideShopGiftHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 提示点击新手礼包按钮
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.WAIT_CLICK_NEW_ITEM_BTN
			
			--无对话
			--...
			
			--强制跳转到下一个状态
			OnClickGuideShopBuyFrame_Event(0, 0)
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.WAIT_CLICK_NEW_ITEM_BTN) then --等待点击新手礼包按钮
			--检测是否点到了开始战斗按钮里面
			local GIFT_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local GIFT_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			local x = 240 + GIFT_DX
			local y = 344 + GIFT_DY
			local w = 100
			local h = 50
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--print("是否点到了新手礼包按钮里面")
				--删除提示点击新手礼包按钮的手的特效
				if hGlobal.UI.GuideShopGiftHandEffect then
					hGlobal.UI.GuideShopGiftHandEffect:del()
					hGlobal.UI.GuideShopGiftHandEffect = nil
				end
				
				--删除提示点击新手礼包按钮的转圈圈特效
				if hGlobal.UI.GuideShopGiftRoundEffect then
					hGlobal.UI.GuideShopGiftRoundEffect:del()
					hGlobal.UI.GuideShopGiftRoundEffect = nil
				end
				
				--模拟实际的购买流程，创建一个假的对话框
				local nItemID = 9106
				local sItemName = hVar.tab_stringI[nItemID][1]
				local funcOnClickOK = nil --点击确定的事件调用函数
				local msgbox2 = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_confirmBuyTip"].."\n"..hVar.tab_string["["]..sItemName..hVar.tab_string["]"].."?",
				{
					font = hVar.FONTC,
					
					--点击确定按钮
					ok = function()
						funcOnClickOK()
					end,
					
					--点击取消按钮
					cancel = function()
						--进入下个状态: 提示点击新手礼包按钮
						hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_NEW_ITEM_BTN
						
						--无对话
						--...
						
						--强制跳转到下一个状态
						OnClickGuideShopBuyFrame_Event(0, 0)
					end,
				})
				
				--在msgbox上加转圈圈和手的特效
				--创建msgbox的手的特效
				local _frm = msgbox2
				local _parent = _frm.handle._n
				local okBtn = msgbox2.childUI["btnOk"]
				--print(okBtn)
				msgbox2.childUI["hand"] = hUI.image:new({
					parent = _parent,
					model = "MODEL_EFFECT:Hand",
					x = okBtn.data.x,
					y = okBtn.data.y + 30,
					scale = 1.3,
					z = 100,
				})
				--msgbox2.childUI["hand"].handle.s:setColor(ccc3(255, 255, 0))
				
				--创建msgbox的转圈圈特效
				msgbox2.childUI["round"] = hUI.image:new({
					parent = _parent,
					model = "MODEL_EFFECT:strengthen",
					x = okBtn.data.x,
					y = okBtn.data.y + 2,
					--w = 260,
					--h = 90,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				msgbox2.childUI["round"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
				msgbox2.childUI["round"].handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = msgbox2.childUI["round"].handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.4)
				
				--点击确定按钮事件
				funcOnClickOK = function()
					--扣除积分
					local curScore = LuaGetPlayerScore()
					local costScore = 100 --消耗的积分
					if (curScore >= costScore) then
						LuaAddPlayerScore(-costScore)
					else
						LuaAddPlayerScore(-curScore)
					end
					
					--模拟购买新手礼包成功事件
					local nShopItemID = 96
					local item_id = 9106
					local overage = 0
					hGlobal.event:event("LocalEvent_BuyItemSucceed", nShopItemID, item_id, overage)
					
					--模拟获得新手礼品道具事件
					local itemIDList = hVar.tab_item[9106].gift
					local shopID = 9106
					hGlobal.event:event("LocalEvent_BuyGiftItem", itemIDList, shopID)
					
					--模拟该礼包只能购买一次事件
					local ext_consuming = "9106:1;"
					hGlobal.event:event("LocalEvent_GetBuyItmeState", ext_consuming)
					
					--新手礼包购买成功就标记此引导完成（防止买完东西叫直接关窗口）
					--标记主城引导商店界面完成
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5)
					
					--创建提示点击确定ok的特效
					local _frm = hGlobal.UI.BuyItemFram
					local _parent = _frm.handle._n
					local _childUI = _frm.childUI
					local btnClose = _childUI["btnClose"]
					
					--手特效
					_childUI["hand"] = hUI.image:new({
						parent = _parent,
						model = "MODEL_EFFECT:Hand",
						x = btnClose.data.x,
						y = btnClose.data.y + 30,
						scale = 1.3,
						z = 100,
					})
					
					--转圈圈特效
					_childUI["round"] = hUI.image:new({
						parent = _parent,
						model = "MODEL_EFFECT:strengthen",
						x = btnClose.data.x,
						y = btnClose.data.y + 2,
						--w = 200,
						--h = 90,
						w = 100,
						h = 100,
						scale = 1.0,
						z = 100,
					})
					_childUI["round"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
					_childUI["round"].handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
					local decal, count = 11, 0 --光晕效果
					local r, g, b, parent = 150, 128, 64
					local parent = _childUI["round"].handle._n
					local offsetX, offsetY, duration, scale = 32, 32, 0.4, 1.05
					local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
					nnn:setScale(1.4)
					
					--监听点击ok事件
					hGlobal.event:listen("LocalEvent_ClickGiftOk", "GuideGiftOk", function()
						--删除监听
						hGlobal.event:listen("LocalEvent_ClickGiftOk", "GuideGiftOk", nil)
						
						--删除控件
						hApi.safeRemoveT(_childUI, "hand")
						hApi.safeRemoveT(_childUI, "round")
						
						--进入下个状态: 提示点击关闭按钮
						hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_CLOSE_BTN
						
						--无对话
						--...
						
						--强制跳转到下一个状态
						OnClickGuideShopBuyFrame_Event(0, 0)
					end)
				end
				
				--模拟点击按钮
				--_CODE_ClickBuyItemBtn(96)
				
				--进入下个状态: 对话框操作界面
				hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.WAIT_MSG_BOX_STATE
				
				--无对话
				--...
				
				--强制跳转到下一个状态
				--OnClickGuideShopBuyFrame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.WAIT_MSG_BOX_STATE) then --对话框操作界面
			--该状态会在按钮点击事件里处理，跳出该状态
			--不需要处理
			--...
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_CLOSE_BTN) then --提示点击关闭按钮
			local CLOSE_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local CLOSE_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			local closeX = 940 + CLOSE_DX
			local cloxeY = 616 + CLOSE_DY
			--创建提示点击关闭按钮的转圈圈特效
			hGlobal.UI.GuideShopCloseRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = closeX,
				y = cloxeY,
				--w = 120,
				--h = 120,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideShopCloseRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideShopCloseRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64

			local parent = hGlobal.UI.GuideShopCloseRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 31, 31, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击关闭按钮的手的特效
			hGlobal.UI.GuideShopCloseHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideShopBuyMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = closeX + 20,
				y = cloxeY - 30,
				scale = 1.3,
				z = 100,
			})
			hGlobal.UI.GuideShopCloseHandEffect.handle._n:setRotation(150)
			
			--进入下个状态: 等待点击关闭按钮
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_WAIT_CLOSE_BTN
				
			--无对话
			--...
			
			--强制跳转到下一个状态
			OnClickGuideShopBuyFrame_Event(0, 0)
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_WAIT_CLOSE_BTN) then --等待点击关闭按钮
			--检测是否点到了关闭按钮里面
			local CLOSE_DX = 0 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率 --偏移值x
			local CLOSE_DY = 0 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率 --偏移值y
			local closeX = 940 + CLOSE_DX
			local cloxeY = 616 + CLOSE_DY
			local x = closeX
			local y = cloxeY
			local w = 120
			local h = 120
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--删除提示点击关闭按钮的手的特效
				if hGlobal.UI.GuideShopCloseHandEffect then
					hGlobal.UI.GuideShopCloseHandEffect:del()
					hGlobal.UI.GuideShopCloseHandEffect = nil
				end
				
				--删除提示点击关闭按钮的转圈圈特效
				if hGlobal.UI.GuideShopCloseRoundEffect then
					hGlobal.UI.GuideShopCloseRoundEffect:del()
					hGlobal.UI.GuideShopCloseRoundEffect = nil
				end
				
				--模拟点击关闭按钮
				local closebtn = hGlobal.UI.NetShopFramII.data.closebtn
				closebtn.code(closebtn)
				
				--geaychao:因为商店缓存表被修改，这里必须触发重创建事件，来刷新商店界面内部存储的数据
				hGlobal.UI.InitNetShopFramII("include")
				hGlobal.UI.NetShopFramII.data.closebtn.code(closebtn)
				
				--进入下个状态: 引导结束
				hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_END
				
				--无对话
				--...
				
				--强制跳转到下一个状态
				OnClickGuideShopBuyFrame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideShopBuyMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideShopBuyMenuBar:del()
				hGlobal.UI.GuideShopBuyMenuBar = nil
			end
			
			--新手礼包购买成功就标记此引导完成（防止买完东西叫直接关窗口）
			--标记主城引导商店界面完成
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5)
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导开商店买东西的主界面")
			
			--因为要触发下一个主城的引导战术技能卡界面事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
		end
	end
	
	--开始引导主城查看英雄界面和穿装、升级技能
	function BeginGuideShopBuy()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideShopBuyMenuBar then --界面
				hGlobal.UI.GuideShopBuyMenuBar:del()
				hGlobal.UI.GuideShopBuyMenuBar = nil
			end
			
			--标记主城引导商店界面完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5)
			
			--因为要触发下一个主城的引导战术技能卡界面事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map", 0)
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.GuideShopBuyState == hGlobal.UI.GuideShopBuyStateType.NONE) then --初始状态
				--hGlobal.UI.GuideShopBuyState = hGlobal.UI.GuideShopBuyStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideShopBuyFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "商店操作指导")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建大地图对话
	local function __createMapTalkShopBuy(flag, talkType, _func, ...)
		local arg = {...}
		local oWorld = hClass.world:new({type="none"})
		local oUnit = oWorld:addunit(1,1)
		
		local vTalk = hApi.AnalyzeTalk(oUnit, oUnit, {flag, talkType,}, {id = {townTypeId,townTypeId},})
		if vTalk then
			oWorld:del()
			oUnit:del()
			hApi.CreateUnitTalk(vTalk,function()
				if _func and type(_func) == "function" then
					_func(unpack(arg))
				end
			end)
		else
			if _func and type(_func) == "function" then
				_func(unpack(arg))
			end
		end
	end
	
	--显示对话框：引导主城商店购买介绍
	function __Dialogue_GuideShopBuy_ShopIntroduce()
		print("显示对话框：引导主城商店购买介绍")
		__createMapTalkShopBuy("step1", "$_001_lsc_40", OnClickGuideShopBuyFrame_Event, 0, 0)
	end
	
	--显示对话框：引导主城点击商店按钮
	function __Dialogue_GuideShopBuy_Click_Shop()
		print("显示对话框：引导主城点击商店按钮")
		__createMapTalkShopBuy("step2", "$_001_lsc_41", OnClickGuideShopBuyFrame_Event, 0, 0)
	end
	
	
	--显示对话框：引导主城开商店引导完成
	function __Dialogue_GuideShopBuy_Introduce_GuideEnd()
		print("显示对话框：引导主城开商店引导完成")
		__createMapTalkShopBuy("step3", "$_001_lsc_29", OnClickGuideShopBuyFrame_Event, 0, 0)
	end
	
	--开始引导主城开商店买东西
	BeginGuideShopBuy()
end

--test
--测试主城引导开商店买东西
--CreateGuideFrame_ShopBuy()


