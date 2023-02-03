--*************************************************************
-- Copyright (c) 2016, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏充值模块
---------------------------------------------------------------
local iChannelId = xlGetChannelId()
if iChannelId < 100 then
	return
end
local iap_control = {}
iap_control.func = {}
local funcs = iap_control.func
iap_control.state = {}
local states = iap_control.state
states.bLog = true

--*************************************************************
-- view模块接口声明
---------------------------------------------------------------
-- 1 获取view单件
-- getIapView()
local iap_view = {}
function getIapView() return iap_view end

-- 2 显示隐藏view 0 hide 1 show
-- getIapView().Show(iShow)
function iap_view.Show(iShow)
	hGlobal.event:event("LocalEvent_Phone_ShowIAP",iShow)
end

-- 3 更新view的界面 list = {} list[1] = {iItemId,iCoin,iMoney} ...
-- getIapView().UpdateList(iIapType,tList)
function iap_view.UpdateList(iIapType,tList)
	hGlobal.event:event("updata_iap",iIapType,tList)
end

--hGlobal.event:event("LocalEvent_Phone_ShowIAP",1) -- 1显示  0不显示
--hGlobal.event:event("updata_iap",1,{{1,12,345}})  1--支付方式 表-list


--*************************************************************
-- 外部接口
---------------------------------------------------------------

-- 1 获取单件
function getIapMgr() return iap_control end

-- 2 显示列表
function iap_control.OnShowList(iIapType)
	local sInfo = string.format("iap_control.OnShowList iaptype:%d \n",iIapType)
	funcs.Log(sInfo)
	funcs.RequestList(iIapType)
end

-- 3 购买物品
function iap_control.OnBuyItem(iIapType,iItemId)
	local sInfo = string.format("iap_control.OnBuyItem iaptype:%d itemid:%d \n",iIapType,iItemId)
	funcs.Log(sInfo)
	funcs.OrderStart(iIapType,iItemId)
end




--*************************************************************
-- 回调接口
---------------------------------------------------------------
-- 获取到商品列表的回调
function iap_control.OnGetItemList(iIapType,list)
	local sInfo = string.format("iap_control.OnGetItemList iaptype:%d listnum:%d \n",iIapType,#list)
	for i = 1,#list do
		sInfo = sInfo .. string.format("list[%d] itemid:%d coin:%d money:%d \n",i,list[i].itemid,list[i].coin,list[i].money)
	end
	funcs.Log(sInfo)
	getIapView().Show(1)
	getIapView().UpdateList(iIapType,list)
end

function iap_control.OnGetItemOrder(iIapType,iItemId,sOrderId,sOrderData,sPrice)
	local sInfo = string.format("iap_control.OnGetItemList iaptype:%d itemid:%d orderid:%s orderdata:%s \n",iIapType,iItemId,sOrderId,sOrderData)
	funcs.Log(sInfo)

	if hVar.IAP_TYPE.ALI == iIapType then
		xlPayAliOrder(sOrderData)
	elseif hVar.IAP_TYPE.WEIXIN == iIapType then
		local uid = xlPlayer_GetUID() or 0 --我的uid
		xlPayWxOrder(uid, iItemId, sOrderData)
	elseif hVar.IAP_TYPE.MI == iIapType then
        local sProductCode = string.format("mi%d",iItemId)
        xlPayMiOrder(sOrderId,sProductCode)
    elseif hVar.IAP_TYPE.HW == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)--getProductInfo(iItemId)
        xlPayHwOrder(sOrderId,sProductCode,sProductInfo,sPrice)
    elseif hVar.IAP_TYPE.JY == iIapType then
        local sProductCode = string.format("%d",iItemId)
        xlPay9YOrder(sOrderId,sProductCode,sOrderData,sPrice)
    elseif hVar.IAP_TYPE.TX == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        xlPayTxOrder(sOrderId,sProductCode,sProductInfo,sPrice)
    elseif hVar.IAP_TYPE.OP == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        local iPrice = tonumber(sPrice)
        xlPayOpOrder(sOrderId,sProductCode,sProductInfo,iPrice,sOrderData)
    elseif hVar.IAP_TYPE.VV == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        local iPrice = tonumber(sPrice)
        xlPayVvOrder(sOrderId,sProductCode,sProductInfo,iPrice)
    elseif hVar.IAP_TYPE.LHH == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        xlPayLhhOrder(sOrderId,sProductCode,sProductInfo,sPrice)
    elseif hVar.IAP_TYPE.ZL == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        local iPrice = tonumber(sPrice)
        xlPayZlOrder(sOrderId,sProductCode,sProductInfo,iPrice,sOrderData)
    elseif hVar.IAP_TYPE.GG == iIapType then	
	local sProductCode = string.format("%d",iItemId)
	local tInfo = hApi.GetGoogleTopupInfo("id",iItemId)
	if type(tInfo) == "table" then
		sProductCode = tInfo.key
	end
	xlPayGlOrder(sProductCode,sOrderId)
    elseif hVar.IAP_TYPE.YZYZ == iIapType then
        xlPayAliOrder(sOrderData)
    elseif hVar.IAP_TYPE.HYKB == iIapType then
        xlPayAliOrder(sOrderData)
    elseif hVar.IAP_TYPE.TXN == iIapType then
        local sProductCode = string.format("%d",iItemId)
        local sProductInfo = hApi.GetProductInfoById(iItemId)
        xlPayTxOrder(sOrderId,sProductCode,sProductInfo,sPrice)
    else
		print("OnGetItemOrder error \n")
	end
end


--*************************************************************
-- 内部私有方法定义
---------------------------------------------------------------

-- 1 内部log函数
function funcs.Log(sInfo)
	if true == states.bLog then
		print(sInfo)
	end
end

function funcs.IsValidType(iIapType)
	if hVar.IAP_TYPE.ALI == iIapType or hVar.IAP_TYPE.MI == iIapType or hVar.IAP_TYPE.HW == iIapType
	or hVar.IAP_TYPE.JY == iIapType or hVar.IAP_TYPE.TX == iIapType or hVar.IAP_TYPE.OP == iIapType
	or hVar.IAP_TYPE.VV == iIapType or hVar.IAP_TYPE.LHH == iIapType or hVar.IAP_TYPE.ZL == iIapType
	or hVar.IAP_TYPE.YZYZ == iIapType or hVar.IAP_TYPE.GG == iIapType or hVar.IAP_TYPE.HYKB == iIapType
	or hVar.IAP_TYPE.TXN == iIapType or (hVar.IAP_TYPE.WEIXIN == iIapType) then
		return true
	else
		return false
	end
end

-- 2 请求列表
function funcs.RequestList(iIapType)
	local sInfo = string.format("funcs.RequestList iaptype:%d \n",iIapType)
	funcs.Log(sInfo)
	if funcs.IsValidType(iIapType) then
		SendCmdFunc["iap_itemlist"](iIapType)
	else
		print("funcs.RequestList error \n")
	end
end

-- 3 收到列表
function funcs.ReceiveList(iIapType,tList)
	local sInfo = string.format("funcs.ReceiveList iaptype:%d itemlist:%d \n",iIapType,#tList)
	funcs.Log(sInfo)
	if funcs.IsValidType(iIapType) then
		if tList and #tList >= 0 then
		else
			getIapView().UpdateList(iIapType,tList)
		end
	else
		print("funcs.RequestList error \n")
	end
end

-- 4 订单开始
function funcs.OrderStart(iIapType,iItemId)
	local sInfo = string.format("funcs.OrderStart iaptype:%d itemid:%d \n",iIapType,iItemId)
	funcs.Log(sInfo)	
	if funcs.IsValidType(iIapType) then
		SendCmdFunc["iap_requestorder"](iIapType,iItemId)
	else
		print("funcs.OrderStart error \n")
	end
end

-- 5 订单结束
function funcs.OrderEnd(iIapType,iItemId)
	--cpp_iapstart(iIapType,iItemId)
end


function xlGetIapType()
	if nil == g_iIapType then
		g_iIapType = 2
		if xlGetChannelId then
			local iChannelId = xlGetChannelId()
			if "number" == type(iChannelId) then 
				if iChannelId == 1 then
					g_iIapType = 1
				elseif 1003 <= iChannelId then 
					g_iIapType = iChannelId - 900 
				end
			end
		end
	end
	return g_iIapType
end

--if nil == xlRequestIapList then
function xlRequestIapList(iIapType)
    print(string.format("xlRequestIapList type:%d \n",iIapType))
    if xlGetIapType() == 112 and xlRequestGoogleIapList then	--谷歌
	    xlRequestGoogleIapList()
    else
	    if funcs.IsValidType(iIapType) then
		SendCmdFunc["iap_itemlistnew"](iIapType)
	    else
		local list = {}        
		xlLuaEvent_OnIapList(list)
	    end
    end
end
--end

--if nil == xlIapBuyItem then
function xlIapBuyItem(iIapType,iIndexOrItemId)
	print(string.format("xlIapBuyItem type:%d id:%d \n",iIapType,iIndexOrItemId))
	
	if funcs.IsValidType(iIapType) then
		local iChannelId = getChannelInfo()
		if (iChannelId == 100) or (iChannelId == 106) or (iChannelId == 1002) then --taptap
			if (iIapType == 4) then --微信支付
				local uid = xlPlayer_GetUID() or 0 --我的uid
				local sOrderId = 0
				xlPayWxOrder(uid, iIndexOrItemId, sOrderId)
			else
				SendCmdFunc["iap_requestorder"](iIapType,iIndexOrItemId)
			end
		else
			SendCmdFunc["iap_requestorder"](iIapType,iIndexOrItemId)
		end
	else
		xlLuaEvent_Topup_Failed(1)
	end
end
--end





