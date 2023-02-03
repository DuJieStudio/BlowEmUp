--�̳ǹ�����
local ShopMgr = class("ShopMgr")
	
	--�̵�����
	ShopMgr.TYPE = {
		NORMAL = 0,			--��ͨ�̵�
		AUTO_REFRESH = 1,		--�Զ�ˢ���̵꣨ÿ�����ˢ��3����Ʒ��ÿ����Ʒ�й���������ޣ�ÿ��̶�ʱ��ˢ�£�ÿ����ý��ˢ��n�Σ�
		SHOP_CANGBAOTU_NORMAL = 23,	--�ر�ͼ�̵�
		SHOP_CANGBAOTU_HIGH = 24,	--�߼��ر�ͼ�̵�
	}
	
	ShopMgr.RefreshSID = 349		--ˢ���̳� ��Ʒid
	
	--���̵�齱
	ShopMgr.CHOUJIANG_SHOP_ID = 2				--���̵���̵�id
	
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX = 7		--���������һ����Ʒ����
	ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX = 8		--���������ʮ����Ʒ����
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX = 9		--ս������һ����Ʒ����
	ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX = 10	--ս������ʮ����Ʒ����
	
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX = 11	--����������ѳ�һ����Ʒ����
	ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX = 12	--����������ѳ�ʮ����Ʒ����
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX = 13	--ս������ѳ�һ����Ʒ����
	ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX = 14	--ս������ѳ�ʮ����Ʒ����
	
	--��������ÿ����ѳ�һ�εĴ���
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_COUNT_DAILY = 1
	
	--ս������ÿ����ѳ�һ�εĴ���
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_COUNT_DAILY = 1
	
	ShopMgr.RED_CRYSTAL_EXCHANGE_ONCE_SHOPINDEX = 2		--������ʯ�һ�һ�ε���Ʒ����
	ShopMgr.RED_CRYSTAL_EXCHANGE_TENTH_SHOPINDEX = 15	--������ʯ�һ�ʮ�ε���Ʒ����
	ShopMgr.RED_CRYSTAL_EXCHANGE_FIFTY_SHOPINDEX = 16	--������ʯ�һ�50�ε���Ʒ����
	
	--���캯��
	function ShopMgr:ctor()
		--����
		return self
	end
	--��ʼ������
	function ShopMgr:Init()
		return self
	end
	
	--ˢ���̳ǵ���
	function ShopMgr:_refreshShopItem(shopId, vipLv)
		local ret
		local tShop = hVar.tab_shop[shopId]
		--�̵����ñ����
		if tShop then
			local shopType = tShop.type
			--�����̵����Զ�ˢ���̵�
			if shopType == ShopMgr.TYPE.NORMAL then
				local goods = tShop.goods
				if goods then
					local goodsNum = 0
					ret = ""
					for i = 1, #goods do
						local shopItemId = goods[i]
						local shopItem = hClass.ShopItem:create():Init(shopItemId)
						if shopItem then
							goodsNum = goodsNum + 1
							ret = ret..(shopItem:InfoToCmd())
						end
					end
					ret = goodsNum .. ";" .. ret
				end
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				--print("shopType1")
				--�����������
				--local quota = tShop.quota
				--������Ʒ�������
				local goodsNumMax = tShop.goodsNumMax
				--��Ʒ�б�
				local goods = tShop.goods
				--print("shopType2",goods)
				if goods then
					--print("shopType3")
					local goodsNum = 0
					ret = ""
					--print("shopType4:",goodsNumMax)
					--��Ʒ��������Ƕ��پ�������ٴ�
					for g = 1, #goods, 1 do
						if (goodsNum < goodsNumMax) then --δ����
							local totalValue = goods[g].totalValue
							local good = {} --������
							for n = 1, #goods[g], 1 do
								good[#good+1] = goods[g][n]
							end
							local rollCount = goods[g].rollCount --�������
							local loopCount = math.min(rollCount, goodsNumMax - goodsNum) --����������ܳ���ʣ�����
							--print("shopType5:",value)
							
							--����vipר���̳ǵ�����б�
							local vipShop = goods[g].vipShop
							if vipShop and vipShop[vipLv] then
								totalValue = totalValue + vipShop[vipLv].totalValue
								for n = 1, #vipShop[vipLv], 1 do
									good[#good+1] = vipShop[vipLv][n]
								end
							end
							--print("totalValue=", totalValue, "vipLv=", vipLv)
							--���n��
							for n = 1, loopCount, 1 do
								local value = math.random(1, totalValue)
								local initialValue = 0
								--��������Ȩ�������ĸ�����
								for i = 1, #good, 1 do
									if (value > initialValue) and (value <= (initialValue + good[i].value)) then
										--print("shopType6:")
										local shopItemId = good[i].shopItemId
										local quota = good[i].quota or 1
										local shopItem = hClass.ShopItem:create():Init(shopItemId,quota)
										--print("shopType7:",shopItem,shopItemId,quota)
										if shopItem then
											--print("shopType8:")
											goodsNum = goodsNum + 1
											ret = ret..(shopItem:InfoToCmd())
										end
										break
									end
									initialValue = initialValue + good[i].value
								end
							end
						end
					end
					ret = goodsNum .. ";" .. ret
				end
			end
		end

		return ret
	end

	--��ȡˢ��ʱ��(�̵�ÿ��ˢ��ʱ��)
	--����ֵ: �ַ���ʱ��
	function ShopMgr:_GetRefreshTime(sRefreshTime)
		--��ȡ��ǰʱ��
		local dbTime = hApi.GetTime()
		
		--�����Ƿ����ˢ��ʱ��
		local sDate = os.date("%Y-%m-%d", dbTime)
		
		--����
		local last_refresh_time = sDate .. " " .. sRefreshTime
		local nRefreshTime = hApi.GetNewDate(last_refresh_time)
		if dbTime <= nRefreshTime then
			--ǰһ��
			local yesterday = hApi.GetNewDate(last_refresh_time, "DAY", -1)
			last_refresh_time = os.date("%Y-%m-%d",yesterday) .. " " .. sRefreshTime
			--print("last_refresh_time:",last_refresh_time,yesterday)
		end
		
		return last_refresh_time
	end
	
	--��Ʒ�ַ���ת��
	function ShopMgr:_ConvertGoodsStr2Tab(goodsInfo)
		
		local ret = {}
		
		local tGoods = hApi.Split(goodsInfo, ";")
		local goodsNum = tonumber(tGoods[1]) or 0
		local infoIdx = 1
		
		--��������Ӣ��
		for i = 1, goodsNum do
			local goodsList = tGoods[infoIdx + i] or ""
			local tGoodsList = hApi.Split(goodsList,":")
			
			--��Ʒ����
			local id = tonumber(tGoodsList[1]) or 0
			local itemId = tonumber(tGoodsList[2]) or 0
			local num = tonumber(tGoodsList[3]) or 1
			local score = tonumber(tGoodsList[4]) or 0
			local rmb = tonumber(tGoodsList[5]) or 0
			local quota = tonumber(tGoodsList[6]) or 1
			local saledCount = tonumber(tGoodsList[7]) or 0
			
			if id > 0 and itemId > 0 then
				ret[#ret + 1] = hClass.ShopItem:create():Init(id,quota,itemId,num,score,rmb,saledCount)
			end
		end

		return ret
	end
	--��Ʒ�б��ת�ַ���
	function ShopMgr:_ConvertGoodsTab2Str(goodsList)
		local ret = ""

		local goodsNum = 0
		for i = 1, #goodsList do
			local shopItem = goodsList[i]
			if shopItem and type(shopItem) == "table" and shopItem:getCName() == "ShopItem" then
				goodsNum = goodsNum + 1
				ret = ret..(shopItem:InfoToCmd())
			end
		end
		ret = goodsNum .. ";" .. ret
		
		return ret
	end
	
	
	--��ȡ�̳��б�
	function ShopMgr:OpenShop(udbid, rid, shopId)

		local ret
		local tShop = hVar.tab_shop[shopId]
		
		--�̳Ǿ�̬��
		if tShop then
			local shopType = tShop.type
			
			--�������ͨ�̵�ֱ�ӷ�����Ʒ�����б�
			if shopType == ShopMgr.TYPE.NORMAL then
				
				local rmb_refresh_count = 0
				local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --���vip�ȼ�
				--print("udbid1=", udbid, "vipLv=", vipLv)
				local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
				ret = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
				
			--������Զ�ˢ���̵�
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				--�̵�ÿ��ˢ��ʱ��
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --����ʱ���
				
				local strGoods = ""
				local rmb_refresh_count = 0
				--local sql = string.format("SELECT `id`,`uid`,`shopid`,`goods`,`goods1`,`goods2`,`goods3`,`goods4`,`goods5`,`goods6`,`goods7`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`uid`,`shopid`,`goods`,`goods1`,`goods2`,`goods3`,`goods4`,`goods5`,`goods6`,`goods7`,`goods8`,`goods9`,`goods10`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id,uid,shopid,goods,goods1,goods2,goods3,goods4,goods5,goods6,goods7,goods8,goods9,goods10,rmbRefreshCount = xlDb_Query(sql)
				--print("OpenShop:",err,sql)
				if err == 0 then
					rmb_refresh_count = rmbRefreshCount
					if rmb_refresh_count == 0 then
						strGoods = goods
					elseif rmb_refresh_count == 1 then
						strGoods = goods1
					elseif rmb_refresh_count == 2 then
						strGoods = goods2
					elseif rmb_refresh_count == 3 then
						strGoods = goods3
					elseif rmb_refresh_count == 4 then
						strGoods = goods4
					elseif rmb_refresh_count == 5 then
						strGoods = goods5
					elseif rmb_refresh_count == 6 then
						strGoods = goods6
					elseif rmb_refresh_count == 7 then
						strGoods = goods7
					elseif rmb_refresh_count == 8 then
						strGoods = goods8
					elseif rmb_refresh_count == 9 then
						strGoods = goods9
					elseif rmb_refresh_count == 10 then
						strGoods = goods10
					else
						strGoods = goods
					end
				elseif err == 4 then
					local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --���vip�ȼ�
					--print("udbid2=", udbid, "vipLv=", vipLv)
					local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
					strGoods = goods
					local insertSql = string.format("INSERT INTO t_user_shop_product (`uid`,`shopid`,`goods`,`last_refresh_time`,`refresh_timestamp`) values (%d,%d,'%s','%s',%d)",udbid,shopId,goods,last_refresh_time,refresh_timestamp)
					xlDb_Execute(insertSql)
				end
				ret = shopId .. ";" .. rmb_refresh_count .. ";" .. strGoods
			end
		end
		
		return ret
	end
	
	--ˢ���̵�
	function ShopMgr:RefreshShop(udbid, rid, shopId)
		
		print("RefreshShop1:",udbid, rid, shopId)
		local ret,strShopItem
		local result = 0 --�������
		local tShop = hVar.tab_shop[shopId]
		print("RefreshShop2:",tShop)
		--�̳Ǿ�̬��
		if tShop then
			
			
			
			local shopType = tShop.type
			
			--�������ͨ�̵�ֱ�ӷ�����Ʒ�����б���ͨ�̵겻��Ҫˢ�£�
			if shopType == ShopMgr.TYPE.NORMAL then
			
			--������Զ�ˢ���̵�
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				print("RefreshShop3:",shopType)
				
				--rmb���ˢ�´���
				local rmbRefreshCountMax = tShop.rmbRefreshCount
				--�̵�ÿ��ˢ��ʱ��
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --����ʱ���
				
				print("RefreshShop4:",rmbRefreshCountMax,sRefreshTime,last_refresh_time)
				
				--local sql = string.format("SELECT `id`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id, rmb_refresh_count = xlDb_Query(sql)
				--print("RefreshShop5:",err, rmb_refresh_count, sql)
				if err == 0 then
					
					local vipFreeRefreshCount, vipLv = hGlobal.vipMgr:GetNetShopRefreshCount(udbid)
					
					print("RefreshShop6:",vipFreeRefreshCount, vipLv)
					
					--������㹻��ˢ�´����������ˢ��
					if rmb_refresh_count < math.max(rmbRefreshCountMax,vipFreeRefreshCount) then
						
						--print("RefreshShop7:",ShopMgr.RefreshSID)
						
						--�۷Ѵ���
						local shopItem = hClass.ShopItem:create():Init(ShopMgr.RefreshSID)
						
						print("RefreshShop8:",shopItem)
						
						--�������ˢ���̳ǵ���
						if shopItem then
							--ˢ��һ����Ʒ�б�
							--local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --���vip�ȼ�
							--print("udbid3=", udbid, "vipLv=", vipLv)
							local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
							local goodsCol = "goods"
							rmb_refresh_count = rmb_refresh_count + 1
							goodsCol = goodsCol..(rmb_refresh_count)
							local rmbCost = shopItem:GetRmbCost()
							local itemExt = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
							
							if vipFreeRefreshCount > 0 then
								--rmbCost = 0
								itemExt = itemExt..";vip"
							end
							
							print("RefreshShop9:",itemExt)
							
							--���Կ۷ѣ��ɹ��Ļ���������
							if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,rmbCost,0,itemExt) then
								local updateSql = string.format("UPDATE t_user_shop_product SET `%s`='%s',`rmb_refresh_count`=`rmb_refresh_count`+1 WHERE `id`=%d AND `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d", goodsCol,goods,id,udbid,shopId,refresh_timestamp)
								local abc = xlDb_Execute(updateSql)
								
								print("RefreshShop10:",abc,_DBUserPurchase)
								strShopItem = shopItem:InfoToCmd()
								ret = itemExt
								
								--����ÿ�������£�
								--ˢ���̵�
								local taskType = hVar.TASK_TYPE.TASK_REFRESH_SHOP --ˢ���̵�
								local addCount = 1
								local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, rid)
								taskMgr:AddTaskFinishCount(taskType, addCount)
								
								--�����ɹ�
								result = 1
							else
								result = -1 --��Ϸ�Ҳ���
							end
						else
							result = -2 --��Ʒ������
						end
					else
						result = -3 --ˢ�´�������
					end
				else
					result = -4 --�����쳣
				end
			end
		end
		
		return ret,strShopItem, result
	end
	
	--������Ʒ
	function ShopMgr:BuyItem(udbid, rid, shopId, itemIdx, cRedequipCrystal)
		local nRedequipCrystal = 0
		local ret, goodsInfo
		local nIsSuccess = 0 --�Ƿ�ɹ�
		local tShop = hVar.tab_shop[shopId]
		
		--���ʹ�ú�װ��ʯ�һ�
		if cRedequipCrystal then
			nRedequipCrystal = 1
		else
			nRedequipCrystal = 0
		end
		
		--�̳Ǿ�̬��
		if tShop then
			local shopType = tShop.type
			
			--�������ͨ�̵�ֱ�ӷ�����Ʒ�����б���ͨ�̵겻��Ҫˢ�£�
			if shopType == ShopMgr.TYPE.NORMAL then
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--���ʹ�ú�װ��ʯ�һ�
					if cRedequipCrystal then
						buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchange(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCrystalCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd())
						--if hGlobal.userCoinMgr:DBUserExchange(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCrystalCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd()) then
						--	buySucess = true
						--end
					else
						buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd())
						--if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd()) then
						--	buySucess = true
						--end
					end
					
					--���Կ۷ѣ��ɹ��Ļ���������
					if buySucess then
						--���ӵ�ǰ�Ѿ���������
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--�������ʧ����Ҫ���˽�һ��װ��ʯ
						if not result then
							if cRedequipCrystal then
								hGlobal.userCoinMgr:DBAddCrystal(udbid,shopItem:GetCrystalCost())
							else
								hGlobal.userCoinMgr:DBAddGamecoin(udbid,shopItem:GetRmbCost())
							end
							ret = "-5;"
							nIsSuccess = -5
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--���¶�����Ϣ
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						if cRedequipCrystal then
							--err:������ʯ����-6
							ret = "-6;"
							nIsSuccess = -6
						else
							--err:��Ϸ�Ҳ���-2
							ret = "-2;"
							nIsSuccess = -2
						end
					end
				else
					--err:��Ʒ������-1
					ret = "-1;"
					nIsSuccess = -1
				end
			elseif (shopType == ShopMgr.TYPE.SHOP_CANGBAOTU_NORMAL) then --�ر�ͼ�̵�
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--�ر�ͼ�һ�
					buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchangeCangBaoTu(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuCost(),0,shopItem:InfoToCmd())
					--if hGlobal.userCoinMgr:DBUserExchangeCangBaoTu(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuCost(),0,shopItem:InfoToCmd()) then
					--	buySucess = true
					--end
					
					--���Կ۷ѣ��ɹ��Ļ���������
					if buySucess then
						--���ӵ�ǰ�Ѿ���������
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--�������ʧ����Ҫ���˲ر�ͼ
						if not result then
							hGlobal.userCoinMgr:DBAddCangBaoTu(udbid,shopItem:GetCangBaoTuCost())
							ret = "-5;"
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--���¶�����Ϣ
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						--err:�ر�ͼ����-7
						ret = "-7;"
					end
				else
					--err:��Ʒ������-1
					ret = "-1;"
				end
			elseif (shopType == ShopMgr.TYPE.SHOP_CANGBAOTU_HIGH) then --�߼��ر�ͼ�̵�
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--�߼��ر�ͼ�һ�
					buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchangeCangBaoTuHigh(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuHighCost(),0,shopItem:InfoToCmd())
					--if hGlobal.userCoinMgr:DBUserExchangeCangBaoTuHigh(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuHighCost(),0,shopItem:InfoToCmd()) then
					--	buySucess = true
					--end
					
					--���Կ۷ѣ��ɹ��Ļ���������
					if buySucess then
						--���ӵ�ǰ�Ѿ���������
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--�������ʧ����Ҫ���˸߼��ر�ͼ
						if not result then
							hGlobal.userCoinMgr:DBAddCangBaoTuHigh(udbid,shopItem:GetCangBaoTuHighCost())
							ret = "-5;"
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--���¶�����Ϣ
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						--err:�߼��ر�ͼ����-8
						ret = "-8;"
					end
				else
					--err:��Ʒ������-1
					ret = "-1;"
				end
			--������Զ�ˢ���̵�
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				--�̵�ÿ��ˢ��ʱ��
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --����ʱ���
				
				--local sql = string.format("SELECT `id`,`rmb_refresh_count`, CASE `rmb_refresh_count` WHEN 0 THEN `goods` WHEN 1 THEN `goods1` WHEN 2 THEN `goods2` WHEN 3 THEN `goods3` WHEN 4 THEN `goods4` WHEN 5 THEN `goods5` WHEN 6 THEN `goods6` WHEN 7 THEN `goods7` ELSE `goods` END AS `shopgoods` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`rmb_refresh_count`, CASE `rmb_refresh_count` WHEN 0 THEN `goods` WHEN 1 THEN `goods1` WHEN 2 THEN `goods2` WHEN 3 THEN `goods3` WHEN 4 THEN `goods4` WHEN 5 THEN `goods5` WHEN 6 THEN `goods6` WHEN 7 THEN `goods7` WHEN 8 THEN `goods8` WHEN 9 THEN `goods9` WHEN 9 THEN `goods9` ELSE `goods` END AS `shopgoods` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id, rmb_refresh_count, strShopgoods = xlDb_Query(sql)
				if err == 0 then
					local shopgoods = self:_ConvertGoodsStr2Tab(strShopgoods)
					local shopItem = shopgoods[itemIdx]
					if shopItem then
						--���������
						local quota = shopItem:GetQuota()
						--��ǰ�ѹ������
						local saledCount = shopItem:GetSaledCount()
						--��������޹�����������ߵ�ǰ�ѹ�����С�ڹ����������
						if (quota == -1) or (quota > 0 and quota > saledCount) then
							local buySucess = false
							local ret_order_id = 0
							
							--���Կ۷ѣ��ɹ��Ļ���������
							buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),0,shopItem:InfoToCmd())
							--if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),0,shopItem:InfoToCmd()) then
							if buySucess then	
								--���ӵ�ǰ�Ѿ���������
								local result = shopItem:DBGetItem(udbid,rid)
								--��������ɹ���Ҫ��¼��־
								if result then
									--todo
									local goods = self:_ConvertGoodsTab2Str(shopgoods)
									local goodsCol = "goods"
									if rmb_refresh_count > 0 then
										goodsCol = goodsCol..rmb_refresh_count
									end
									local updateSql = string.format("UPDATE t_user_shop_product SET `%s`='%s' WHERE `id`=%d AND `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d", goodsCol,goods,id,udbid,shopId,refresh_timestamp)
									xlDb_Execute(updateSql)
									--ret = "1;"..shopItem:InfoToCmd()
									ret = "1;"..shopItem:InfoToCmd()..result
									nIsSuccess = 1
									
									--���¶�����Ϣ
									local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
									--print("sUpdate1:",sUpdate)
									xlDb_Execute(sUpdate)
									
									goodsInfo = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
								else
									hGlobal.userCoinMgr:DBAddGamecoin(udbid,shopItem:GetRmbCost())
									ret = "-5;"
								end
								
								
							else
								--err:��Ϸ�Ҳ���-2
								ret = "-2;"
							end
						else
							if quota > 0 and quota <= saledCount then
								--err:��������Ѵ�����-3
								ret = "-3;"
							end
						end
					else
						--err:��Ʒ������-1
						ret = "-1;"	
					end
				else
					--err:��Ʒ��Ϣ������-4
					ret = "-4;"
				end
			end
		else
			--err:�̵겻����
			ret = "-5;"
			nIsSuccess = -5
		end
		
		ret = tostring(nRedequipCrystal) .. ";" .. ret
		
		return ret, goodsInfo, nIsSuccess
	end
	
	--���̵��ѯ�齱��Ϣ
	function ShopMgr:_QueryChouJiangInfo(uid, rid, channelId)
		local nRedChestFree1Count = 0 --����������ѳ�һ�δ���
		local strRedChestFree1LastTime = "1990-01-01 00:00:00" --����������ѳ�һ���ϴ����ʹ��ʱ��
		local nRedChestFree10Count = 0 --����������ѳ�ʮ�δ���
		local nTacticcardFree1Count = 0 --ս������ѳ�һ�δ���
		local strTacticcardFree1LastTime = "1990-01-01 00:00:00" --ս������ѳ�һ���ϴ����ʹ��ʱ��
		local nTacticcardFree10Count = 0 --ս������ѳ�ʮ�δ���
		local nRedChest1RmbCost = 0 --���������һ����Ҫ��Ϸ��
		local nRedChest10RmbCost = 0 --���������ʮ����Ҫ��Ϸ��
		local nTacticcard1RmbCost = 0 --��ս������һ����Ҫ��Ϸ��
		local nTacticcard10RmbCost = 0 --ս������ʮ����Ҫ��Ϸ��
		local nRedChest1ItemId = 0 --���������һ�ε���Ʒid
		local nRedChest10ItemId = 0 --���������ʮ�ε���Ʒid
		local nTacticcard1ItemId = 0 --��ս������һ�ε���Ʒid
		local nTacticcard10ItemId = 0 --ս������ʮ�ε���Ʒid
		
		--��ѯ���ȯ����
		local sql = string.format("SELECT `redchest_freeticket1_num`, `redchest_freeticket1_lasttime`, `redchest_freeticket10_num`, `tacticcard_freeticket1_num`, `tacticcard_freeticket1_lasttime`, `tacticcard_freeticket10_num` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, redchest_freeticket1_num, redchest_freeticket1_lasttime, redchest_freeticket10_num, tacticcard_freeticket1_num, tacticcard_freeticket1_lasttime, tacticcard_freeticket10_num = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			nRedChestFree1Count = redchest_freeticket1_num
			strRedChestFree1LastTime = redchest_freeticket1_lasttime
			nRedChestFree10Count = redchest_freeticket10_num
			nTacticcardFree1Count = tacticcard_freeticket1_num
			strTacticcardFree1LastTime = tacticcard_freeticket1_lasttime
			nTacticcardFree10Count = tacticcard_freeticket10_num
			
			--����ʱ���
			local nTimestampNow = os.time()
			
			--���������һ��
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(strRedChestFree1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--���˵ڶ���
			if (nTimestampNow >= nTimestampTodayZero) then
				--���ô���
				nRedChestFree1Count = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_COUNT_DAILY
			end
			
			--ս��������һ��
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(strTacticcardFree1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--���˵ڶ���
			if (nTimestampNow >= nTimestampTodayZero) then
				--���ô���
				nTacticcardFree1Count = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_COUNT_DAILY
			end
		end
		
		--���������һ����Ҫ����Ϸ��
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
		if (nRedChestFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nRedChest1RmbCost = tabShopItem.rmb
		nRedChest1ItemId = tabShopItem.itemID
		
		
		--���������ʮ����Ҫ����Ϸ��
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
		if (nRedChestFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nRedChest10RmbCost = tabShopItem.rmb
		nRedChest10ItemId = tabShopItem.itemID
		
		--ս������һ����Ҫ��Ϸ��
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
		if (nTacticcardFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nTacticcard1RmbCost = tabShopItem.rmb
		nTacticcard1ItemId = tabShopItem.itemID
		
		--ս������ʮ����Ҫ��Ϸ��
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
		if (nTacticcardFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nTacticcard10RmbCost = tabShopItem.rmb
		nTacticcard10ItemId = tabShopItem.itemID
		
		return nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId
	end
	
	--���̵��ѯ�齱��Ϣ
	function ShopMgr:ShopQueryChouJiangInfo(uid, rid, channelId)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local sCmd = tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";" .. tostring(nTacticcardFree10Count) .. ";"
			.. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";" .. tostring(nTacticcard10RmbCost) .. ";"
		
		return sCmd
	end
	
	--���̵�ʹ�ó齱-���������һ��
	function ShopMgr:ShopUseChouJiangRedChestOnce(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
		if (nRedChestFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--�۳���Ѵ���
		if (nIsSuccess == 1) then
			if (nRedChestFree1Count > 0) then
				nRedChestFree1Count = nRedChestFree1Count - 1
				
				--�ָ�ԭ��
				if (nRedChestFree1Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nRedChest1RmbCost = tabShopItem.rmb
					nRedChest1ItemId = tabShopItem.itemID
				end
				
				--������nRedChestFree1Count��ֵΪ׼����Ϊÿ�մ���������
				--����
				local sUpdate = string.format("UPDATE `t_cha` SET `redchest_freeticket1_num` = %d, `redchest_freeticket1_lasttime` = now() WHERE `id`= %d", nRedChestFree1Count, rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--���̵�ʹ�ó齱-���������ʮ��
	function ShopMgr:ShopUseChouJiangRedChestTenth(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
		if (nRedChestFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--�۳���Ѵ���
		if (nIsSuccess == 1) then
			if (nRedChestFree10Count > 0) then
				nRedChestFree10Count = nRedChestFree10Count - 1
				
				--�ָ�ԭ��
				if (nRedChestFree10Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nRedChest10RmbCost = tabShopItem.rmb
					nRedChest10ItemId = tabShopItem.itemID
				end
				
				--����
				local sUpdate = string.format("UPDATE `t_cha` SET `redchest_freeticket10_num` = `redchest_freeticket10_num` - 1 WHERE `id`= %d", rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--���̵�ʹ�ó齱-ս��������һ��
	function ShopMgr:ShopUseChouJiangTacticCardOnce(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
		if (nTacticcardFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--�۳���Ѵ���
		if (nIsSuccess == 1) then
			if (nTacticcardFree1Count > 0) then
				nTacticcardFree1Count = nTacticcardFree1Count - 1
				
				--�ָ�ԭ��
				if (nTacticcardFree1Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nTacticcard1RmbCost = tabShopItem.rmb
					nTacticcard1ItemId = tabShopItem.itemID
				end
				
				--������nTacticcardFree1Count��ֵΪ׼����Ϊÿ�մ���������
				--����
				local sUpdate = string.format("UPDATE `t_cha` SET `tacticcard_freeticket1_num` = %d, `tacticcard_freeticket1_lasttime` = now() WHERE `id`= %d", nTacticcardFree1Count, rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--���̵�ʹ�ó齱-ս��������ʮ��
	function ShopMgr:ShopUseChouJiangTacticCardTenth(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
		if (nTacticcardFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--�۳���Ѵ���
		if (nIsSuccess == 1) then
			if (nTacticcardFree10Count > 0) then
				nTacticcardFree10Count = nTacticcardFree10Count - 1
				
				--�ָ�ԭ��
				if (nTacticcardFree10Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nTacticcard10RmbCost = tabShopItem.rmb
					nTacticcard10ItemId = tabShopItem.itemID
				end
				
				--����
				local sUpdate = string.format("UPDATE `t_cha` SET `tacticcard_freeticket10_num` = `tacticcard_freeticket10_num` - 1 WHERE `id`= %d", rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--ʹ��������ʯ�һ�һ��
	function ShopMgr:ShopUseRedCrystalExchangeOnce(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_ONCE_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--ʹ��������ʯ�һ�ʮ��
	function ShopMgr:ShopUseRedCrystalExchangeTenth(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_TENTH_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--ʹ��������ʯ�һ�50��
	function ShopMgr:ShopUseRedCrystalExchangeFifty(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_FIFTY_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--�̵��ѯ���տ���������Ϣ
	function ShopMgr:ShopQueryAdvViewInfo(uid, rid, channelId, iTag)
		local strAdvView1LastTime = "1990-01-01 00:00:00" --�ϴο����ʱ��
		local tAdvViewCount = {}
		for i = 1, #hVar.tab_advertise, 1 do
			tAdvViewCount[i] = 0
		end
		
		--��ѯ��������
		local sql = string.format("SELECT `adv_view_lasttime`, `adv_view` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, adv_view_lasttime, adv_view = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			strAdvView1LastTime = adv_view_lasttime
			
			--����ʱ���
			local nTimestampNow = os.time()
			
			--�����
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(strAdvView1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--δ���˵ڶ���
			if (nTimestampNow < nTimestampTodayZero) then
				--������������
				local tCount = hApi.Split(adv_view, ":")
				for i = 1, #tAdvViewCount, 1 do
					local count = tonumber(tCount[i]) or 0
					tAdvViewCount[i] = count
				end
			end
		end
		
		local szCount = ""
		for i = 1, #tAdvViewCount, 1 do
			szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
		end
		
		local sCmd = tostring(iTag) .. ";" .. tostring(#tAdvViewCount) .. ";" .. szCount .. ";"
		
		return sCmd
	end
	
	--�̵���տ������ȡ����
	function ShopMgr:ShopAdvViewTakeReward(uid, rid, channelId, nIndex, iTag)
		local ret = 0 --����ֵ
		local prizeId = 0 --����id
		local prizeContent = "" --��������
		
		local strAdvView1LastTime = "1990-01-01 00:00:00" --�ϴο����ʱ��
		local tAdvViewCount = {}
		for i = 1, #hVar.tab_advertise, 1 do
			tAdvViewCount[i] = 0
		end
		
		--��ѯ��������
		local sql = string.format("SELECT `adv_view_lasttime`, `adv_view` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, adv_view_lasttime, adv_view = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			strAdvView1LastTime = adv_view_lasttime
			
			--����ʱ���
			local nTimestampNow = os.time()
			
			--�����
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(strAdvView1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--δ���˵ڶ���
			if (nTimestampNow < nTimestampTodayZero) then
				--������������
				local tCount = hApi.Split(adv_view, ":")
				for i = 1, #tAdvViewCount, 1 do
					local count = tonumber(tCount[i]) or 0
					tAdvViewCount[i] = count
				end
			end
		end
		
		local tabAdv = hVar.tab_advertise[nIndex]
		if tabAdv then
			local count = tAdvViewCount[nIndex] or 0
			local reward = tabAdv.reward
			local reward1 = tabAdv.reward[1]
			local maxcount = tabAdv.maxcount or 0
			local leftcount = maxcount - count
			if (leftcount > 0) then
				--����
				local id = 20008
				local detail = string.format(hVar.tab_string["__TEXT_ADVVIEW_PRIZE"], reward1[1] or 0, reward1[2] or 0, reward1[3] or 0, reward1[4] or 0)
				local sInsert = string.format("insert into `prize`(uid,type,mykey,used) values (%d,%d,'%s',%d)",uid,id,detail,0)
				xlDb_Execute(sInsert)
				
				--����id
				local err1, pid = xlDb_Query("select last_insert_id()")
				if (err1 == 0) then
					--�洢������Ϣ
					prizeId = pid --����id
					prizeType = id --��������
					--prizeContent = detail --��������
					
					--����������
					--Ԥ���������ֱ�ӿ����ҵĽ��������ò�ͬ�Ľӿ�
					local fromIdx = 2
					prizeContent = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
					
					--���¹���콱����
					tAdvViewCount[nIndex] = tAdvViewCount[nIndex] + 1
					
					--�������ݿ�
					local szCount = ""
					for i = 1, #tAdvViewCount, 1 do
						szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
					end
					local updateSql = string.format("UPDATE `t_cha` SET `adv_view`= '%s',`adv_view_lasttime` = now() WHERE `id`=%d", szCount, rid)
					xlDb_Execute(updateSql)
					
					--�����ɹ�
					ret = 1
				end
			else
				ret = -1 --�����콱��������
			end
		end
		
		local szCount = ""
		for i = 1, #tAdvViewCount, 1 do
			szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
		end
		
		local sCmd = tostring(ret) .. ";" .. tostring(nIndex) .. ";" .. tostring(iTag) .. ";" .. tostring(#tAdvViewCount) .. ";" .. szCount .. ";" .. tostring(prizeContent)
		
		return sCmd
	end
	
return ShopMgr