local _cur_rmb = 0
local _can_use_forged = 0	--是否可以使用锻造
local _net_forged_count = 0	--DB数据库中记录的锻造次数
local _net_wishing_count = 0	--DB中记录的许愿次数

local _btn_use_state = 0	--锻造动画状态
local _g_chest_state = 0	--网络宝箱开启状态

--通过网络协议设置是否可以使用锻造
--hGlobal.event:listen("LocalEvent_Cheat_Get_NetMSG","_newgetCheatVal",function(data,tag,tradeid,isFix)
--	for k,v in pairs(data) do
--		--查询 是否同步过keyChain 的值如果没有同步过则上传
--		if k == "cheat_fcstatus"  then
--			if v == 0 then
--				local nNum = LuaGetForgeCount()
--				SendCmdFunc["set_cheat_count"](0,luaGetplayerDataID(),0,"cheat_fc",nNum,0)
--				SendCmdFunc["set_cheat_count"](0,luaGetplayerDataID(),0,k,1,0)
--			elseif v == 1 then
--				SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),1,"cheat_fc",LuaGetForgeCount())
--			end
--		--DB中记录的锻造次数
--		elseif k == "cheat_fc" then
--			_net_forged_count = v
--			if isFix == 1 then
--				LuaSetForgeCount(_net_forged_count)
--			end
--
--			local nNum = LuaGetForgeCount()
--			--数据过度
--			if nNum == 0 then
--				LuaSetForgeCount(_net_forged_count)
--				nNum = _net_forged_count
--			end
--			if nNum == _net_forged_count then
--				_can_use_forged = 1
--				if hGlobal.UI.ForgedResultFrm and hGlobal.UI.ForgedResultFrm.data.show == 0 then
--					hGlobal.event:event("LocalEvent_setForgedFrm",false)
--				end
--			else
--				--print("检测到锻造数据不一致- S:"..nNum.." - N:".._net_forged_count)
--				SendCmdFunc["set_cheat_count"](0,luaGetplayerDataID(),0,"cheat_forge_flag",1,0)
--				_can_use_forged = 0
--				hGlobal.event:event("LocalEvent_setForgedFrm",true,hVar.tab_string["__TEXT_Can'tForgedItemCheat"].."\n".."S:"..nNum.." - N:".._net_forged_count)
--			end
--		elseif k == "cheat_wishing" then
--			_net_wishing_count = v
--			--数据过度
--			if LuaGetWisingCount() == 0 then
--				LuaSetWisingCount(_net_wishing_count)
--			end
--
--			if isFix == 1 then
--				LuaSetWisingCount(_net_wishing_count)
--			end
--		end
--	end
--end)

--hGlobal.event:listen("LocalEvent_Set_activity_refresh","_newforgedCheatVal",function(connect_state)
--	--如果断开网络则恢复不可使用锻造状态
--	if connect_state == -1 then
--		hGlobal.event:event("LocalEvent_setForgedFrm",true,hVar.tab_string["__TEXT_Can'tSendNetForged"])
--		_can_use_forged = 0
--		
--		--技能升级等状态恢复
--		hUI.NetDisable(0)
--	end
--end)


hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","_newPhoneSetCurGameCoin51",function(cur_rmb) 
	_cur_rmb = cur_rmb
end)

hGlobal.event:listen("LocalEvent_Phone_HeroCardNewFrm_ClearListener","_clearListener", function()
	--显示英雄详细信息
	hGlobal.event:listen("LocalEvent_showHeroCardFrm","newHeroCardNewFrm",nil)
	--拾取道具后的监听
	hGlobal.event:listen("Event_HeroGetItem","__newPhoneHeroGetItem",nil)
	--交换道具后的监听
	hGlobal.event:listen("Event_HeroSortItem","__newPhoneHeroSortItem",nil)
	--点击技能按钮
	hGlobal.event:listen("LocalEvent_ShowSkillInfo", "__newPhoneHeroSkillInfo",nil)
	--技能升级
	hGlobal.event:listen("LocalEvent_SkillLevelUp", "__newPhoneskillLevelUp",nil)
	--只是刷新玩家仓库
	hGlobal.event:listen("Local_EventReflashPlayerBag","__reflashplayerBag",nil)
	--得经验监听
	hGlobal.event:listen("Local_EventHeroGetExp","__newINFOFRM__PhoneHeroGetExp",nil)
	--升级监听
	hGlobal.event:listen("Event_HeroLevelUp","__newINFOFRM__PhoneHeroLevelUp",nil)
	--英雄交换道具后的监听
	hGlobal.event:listen("Event_HeroSortItem","__newINFOFRM__PhoneHeroSetEquipment",nil)
	--刷新卡片
	hGlobal.event:listen("LocalEvent_RefreshHeroInfoByCard","__newPhoneRefreshHeroInfo",nil)
	----为了解决效率问题 非 3 4 级道具不走订单系统
	--hGlobal.event:listen("LocalEvent_order_forge_lv12","forge12",nil)
	----订单系统锻造命令的返回值
	--hGlobal.event:listen("LocalEvent_order_forge","_newSetCheatVal_rs",nil)
	--星级提升
	hGlobal.event:listen("LocalEvent_StarLevelUp","__newPhoneHeroStarUp",nil)
	--使用过兑换券后的刷新
	hGlobal.event:listen("LocalEvent_setNetChest_redNum","_set_cheat_code",nil)
	--设置网络宝箱个数
	hGlobal.event:listen("LocalEvent_getNetChestNum","_getChestNum",nil)
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","_setChestNum",nil)
	--使用各种宝箱的返回
	hGlobal.event:listen("LocalEvent_Use_Net_chest","_uesNetChestRs",nil)
	--通过订单系统 使用各种宝箱的返回
	hGlobal.event:listen("LocalEvent_order_Use_Net_chest","_uesNetChestRs",nil)
	----购买失败
	hGlobal.event:listen("LocalEvent_BuyItemfail", "_herocardfrmUnlock",nil)
	--通过订单系统 技能升级返回
	hGlobal.event:listen("localEvent_afterSkillLvUpSucceed","_heroSkillLvUp",nil)
	--通过订单系统 升星返回
	hGlobal.event:listen("localEvent_afterHeroStarUpSucceed","_heroStarLvUp",nil)
end)

--英雄卡片界面
hGlobal.UI.InitHeroCardNewFrm = function(mode)
	local _w,_h = 892, 558
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 20
	
	local _can_use_grid = 1
	local _HCF_CurrentMode = 0
	local _gridList = {}
	local _oCurHero = {}
	local _oCurUnit = {}
	
	hGlobal.UI.HeroCardNewFrm = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		dragable = 2,
		show = 0,
		autorelease = hVar.TEMP_HANDLE_TYPE.UI_IMAGE_AUTO_RELEASE,
		background = "UI:herocardfrm",
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			--移动距离
			hGlobal.UI.UnitInfoFram:show(0)
			--主界面
			hGlobal.UI.SkillInfoFram:show(0)

			if _can_use_grid ~= 0 then
				for i = 1, #_gridList do
					if _gridList[i].handle._n:isVisible() then
						local item,sprite = _gridList[i]:selectitem(relTouchX,relTouchY,relTouchX+self.data.x,relTouchY+self.data.y)
						if sprite then
							if g_phone_mode ~= 0 then
								sprite:setScale(1.6)
							end
							break
						end
					end
				end
			end
			
			--打开后显示内容--另外一个道具信息面板
			--把一些弹出窗口隐藏
			hGlobal.event:event("LocalEvent_ShowItemInfoFrm",nil)
			hGlobal.event:event("LocalEvent_ShowUseItemFrm",nil,nil,nil)
			if hGlobal.UI.ItemInfoFram.data.show == 1 then
				hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			end
		end,
	})
	
	local _frm = hGlobal.UI.HeroCardNewFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--当前查看的英雄ID
	--分页定义
	local _playerBag_table_state = 1
	-----------------------------------------
	-- 临时锁定单位定义
	local _nCurHeroCardID = 0
	hApi.GetEquipFrmHeroID = function()
		return _nCurHeroCardID
	end
	local _tTokenHero = {
		data = {id=0,academySkill={0},HeroCard = 1,owner = 1,equipment={},item={}},
		attr = {level=0,exp=0},
		__attr = {},
		load = function(self,id,IsRefreshUI, flag)
			local d = self.data
			local a = self.attr
			d.id = id
			d.talent = 0
			d.talentlv = 0
			d.HeroCard = 1
			d.item = hApi.NumTable(hVar.HERO_BAG_SIZE)
			d.equipment = hApi.NumTable(hVar.HERO_EQUIP_SIZE)
			hApi.LoadDefaultHeroAttr(self)
			local tCard = hApi.GetHeroCardById(id)
			if tCard then
				a.exp = tCard.attr.exp
				a.level = hApi.GetLevelByExp(tCard.attr.exp)
				a.star = tCard.attr.star
				a.soulstone = tCard.attr.soulstone
				hClass.hero.__loadattr(self)
				hClass.hero.updatebag(self)
				local tempAttr = {}
				for i = 1,#d.equipment do
					local oItem = d.equipment[i]
					if type(oItem)=="table" then
						hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tempAttr,1,oItem[hVar.ITEM_DATA_INDEX.QUALITY],oItem)
					end
				end
				hClass.hero.__loadattr(self,tempAttr)
				hClass.hero.loadtalent(self)
			else
				a.exp = 0
				a.level = 1
				a.star = 1
				a.soulstone = 0
				
				hClass.hero.__loadattr(self)
				hClass.hero.loadtalent(self)
			end
			if IsRefreshUI==1 then
				hGlobal.event:event("LocalEvent_RefreshHeroInfoByCard",self, flag)
			end
		end,
		getbagitem = function(self,key,index,mode)
			local oItem = hApi.GetItemFromBag(self,key,index,mode)
			if type(oItem)=="table" then
				return oItem
			end
		end,
		loadattr = function(self,tAddAttr)
			local d = self.data
			local cAttr = self.attr
			local bAttr = self.__attr
			
			local hpPerCon = 20		--每点体质增加生命
			local mpPerInt = 1		--每点智力增加魔法
			local atkPerStr = 2		--每点力量增加攻击
			local defPerCon = 0.1		--每点体质增加防御
			
			local hpPec,mpPec = 1,1
			if d.cmxhp>0 then
				hpPec = d.chp/d.cmxhp
			end
			if d.cmxmp>0 then
				mpPec = d.cmp/d.cmxmp
			end
			
			local ReloadNewLevelAttr = 0
			
			--清除属性攻击力/生命/魔法附加
			cAttr.mxhp = cAttr.mxhp - hApi.floor(cAttr.con*hpPerCon)
			cAttr.mxmp = cAttr.mxmp - hApi.floor(cAttr.int*mpPerInt)
			--清除属性防御力附加
			cAttr.def = cAttr.def - hApi.floor(cAttr.con*defPerCon)
			
			cAttr.minAtk = cAttr.minAtk - hApi.floor(cAttr.str*atkPerStr)
			cAttr.maxAtk = cAttr.maxAtk - hApi.floor(cAttr.str*atkPerStr)
			
			if tAddAttr and type(tAddAttr)=="table" then
				ReloadNewLevelAttr = hApi.AddAttrByTab(self,tAddAttr)
			end
			
			--等级不同的话，需要重新读取升级数据
			if d.clevel~=cAttr.level then
				d.clevel = cAttr.level
				ReloadNewLevelAttr = 1
			end
			
			if ReloadNewLevelAttr==1 then
				--读取升级数据
				hApi.LoadBaseAttr(self)
			end
			
			--添加属性攻击力/生命/魔法附加
			cAttr.mxhp = cAttr.mxhp + hApi.floor(cAttr.con*hpPerCon)
			cAttr.mxmp = cAttr.mxmp + hApi.floor(cAttr.int*mpPerInt)
			--添加属性防御力附加
			cAttr.def = cAttr.def + hApi.floor(cAttr.con*defPerCon)
			
			cAttr.minAtk = cAttr.minAtk + hApi.floor(cAttr.str*atkPerStr)
			cAttr.maxAtk = cAttr.maxAtk + hApi.floor(cAttr.str*atkPerStr)
			
			cAttr.hp = math.min(cAttr.mxhp,math.max(1,hApi.floor(cAttr.mxhp*hpPec)))
			cAttr.mp = math.min(cAttr.mxmp,math.max(0,hApi.floor(cAttr.mxmp*mpPec)))
			
			--记录保存的生命血量值
			if d.chp==0 and d.cmxhp==0 then
				d.chp = cAttr.hp
				d.cmxhp = cAttr.mxhp
			end
			if d.cmp==0 and d.cmxmp==0 then
				d.cmp = cAttr.mp
				d.cmxmp = cAttr.mxmp
			end
		end,
		updatebag = function(self,tUpdateSlot)
			local d = self.data
			local tCard = hApi.GetHeroCardById(d.id)
			if tCard~=nil then
				if type(tUpdateSlot)=="table" then
					for i = 1,#tUpdateSlot do
						local v = tUpdateSlot[i]
						hApi.CopyItemFromCardToGameHero(tCard,self,v[1],v[2])
					end
				else
					for i = 1,#d.item do
						hApi.CopyItemFromCardToGameHero(tCard,self,"bag",i)
					end
					for i = 1,#d.equipment do
						hApi.CopyItemFromCardToGameHero(tCard,self,"equip",i)
					end
				end
			end
		end,
		
		shiftitem = function(self,fromKey,fromI,toKey,toI)
			--print("shiftitem", fromKey,fromI,toKey,toI)
			--判断是否合法的道具交换
			if hApi.IsSafeItemShift(self,fromKey,fromI,toKey,toI)~=1 then
				return hVar.RESULT_FAIL,0,0
			end
			--交换流程开始
			local oItemF
			if type(fromI)=="table" and type(fromI[hVar.ITEM_DATA_INDEX.ID])=="number" then
				if hVar.tab_item[fromI[hVar.ITEM_DATA_INDEX.ID]]~=nil then
					oItemF = fromI
				end
				fromI = 0
			else
				oItemF = hApi.GetItemFromBag(self,fromKey,fromI)
			end
			local oItemT = hApi.GetItemFromBag(self,toKey,toI)
			if type(oItemF)=="table" then
				local nItemID_F = oItemF[hVar.ITEM_DATA_INDEX.ID] or 0
				local nItemID_T = 0
				local oItemR
				--完全相同不做操作
				if fromKey==toKey and fromI==toI then
					return hVar.RESULT_FAIL,nItemID_F,nItemID_F
				end
				--如果目标栏位是装备栏，进行合法性检测
				if toKey=="equip" then
					if hApi.IfHeroCanEquipItem(oItemF[hVar.ITEM_DATA_INDEX.ID],toI,self.attr)~=1 then
						return hVar.RESULT_FAIL,0,0
					end
				end
				--如果是来自物品栏的替换，那么也进行合法性检测
				if fromKey=="equip" and type(oItemT)=="table" then
					if hApi.IfHeroCanEquipItem(oItemT[hVar.ITEM_DATA_INDEX.ID],fromI,self.attr)~=1 then
						return hVar.RESULT_FAIL,0,0
					end
				end
				if type(oItemT)=="table" then
					nItemID_T = oItemT[hVar.ITEM_DATA_INDEX.ID] or 0
				else
					oItemT = 0
				end
				local IsUpdateAttr = 0
				--交换物品，某些情况下要重算属性
				if (fromKey=="equip" or toKey=="equip") and fromKey~=toKey then --geyachao: 英雄穿（换）装备代码在这里
					local tTempAttr = {}
					hApi.AddEQAttrByIndex(self.data.equipment,fromKey,fromI,-1,tTempAttr)
					hApi.AddEQAttrByIndex(self.data.equipment,toKey,toI,-1,tTempAttr)
					hApi.PutItemToBag(self,fromKey,fromI,oItemT)
					oItemR = hApi.PutItemToBag(self,toKey,toI,oItemF)
					hApi.AddEQAttrByIndex(self.data.equipment,fromKey,fromI,1,tTempAttr)
					hApi.AddEQAttrByIndex(self.data.equipment,toKey,toI,1,tTempAttr)
					if #tTempAttr>0 then
						IsUpdateAttr = 1
						self:loadattr(tTempAttr)
					end
				else
					hApi.PutItemToBag(self,fromKey,fromI,oItemT)
					oItemR = hApi.PutItemToBag(self,toKey,toI,oItemF)
				end
				hGlobal.event:call("Event_HeroSortItem",self,IsUpdateAttr,hVar.OPERATE_TYPE.HERO_SORTITEM)
				
				return hVar.RESULT_SUCESS,nItemID_F,nItemID_T,oItemR
			else
				return hVar.RESULT_FAIL,0,0
			end
		end,
		useitem = function(self,sBagName,nBagIndex,tradeid)
			
			if self.data.HeroCard~=1 and sBagName~="playerbag" then
				--禁止无卡片英雄使用仓库栏以外的道具
				return
			end
			local oItem = self:getbagitem(sBagName,nBagIndex)
			if oItem then
				local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
				local tabI = hVar.tab_item[itemID]
				if tabI==nil then
					return
				end
				local getDay = -1
				local cDay = -1
				if type(oItem[hVar.ITEM_DATA_INDEX.PICK]) == "table" then
					getDay = oItem[hVar.ITEM_DATA_INDEX.PICK][1]
					cDay = oItem[hVar.ITEM_DATA_INDEX.PICK][2]
				end
				if getDay>=g_game_days and cDay~=999 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenItem"],{
						font = hVar.FONTC,
						ok = function()
						end,
					})
				else
					--oItem[2] = oItem[2] - 1
					--if oItem[2]<=0 then
						--self:shiftitem(sBagName,nBagIndex,"use",0)
					--end

					--先把该消耗道具移除
					if self:shiftitem(sBagName,nBagIndex,"use",0)~=hVar.RESULT_SUCESS then
						print("使用物品失败！",sBagName,nBagIndex,"id = "..oItem[hVar.ITEM_DATA_INDEX.ID])
						return
					end
					
					--如果该物品拥有使用效果
					if type(tabI.used)=="table" then
						local typ,ex,val = unpack(hVar.tab_item[itemID].used)
						--如果是黄金宝箱则设置可以重转
						if itemID == 9006 then
							hApi.UnitGetLoot(self,typ,ex,val,nil,1,sBagName,nBagIndex,oItem,nil,tradeid)
						else
							hApi.UnitGetLoot(self,typ,ex,val,nil,0,sBagName,nBagIndex,oItem,nil,tradeid)
						end
					end
					--LuaAddPlayerCountVal("useitem",itemID,1)
					LuaSaveHeroCard()
					--针对宝箱做keyChain
					local new_Key_UsedItemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID))
					if new_Key_UsedItemCount == 0 then
						local UseCount = LuaGetPlayerCountVal("useitem",itemID)
						xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID),UseCount)
					else
						xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID),new_Key_UsedItemCount+1)
					end
					--记录消耗类道具的使用
					local new_itemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."UseDepletionItem"..itemID) + 1
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."UseDepletionItem"..itemID,new_itemCount)
				end
			end
		end,
		getunit = function(self)
		end,
		gethero = function(self)
			return self
		end,
		getowner = function(self)
			return hGlobal.player[self.data.owner]
		end,
		additembyID = hApi.GiveItemToHeroByID,
	}
	setmetatable(_tTokenHero.attr,{
		__index = function(t,k)
			return 0
		end,
	})
	
	local _SK_SELECTED_ID
	
	local function CreateSkillLvUpMessageBox(oHero, idx, bType, btnType)
		
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		local nHeroId = oHero.data.id
		local tSkill = {}
		if bType == 0 then
			local tabU = hVar.tab_unit[nHeroId]
			if tabU and tabU.talent then
				tSkill = tabU.talent
			end
		elseif bType == 1 then
			tSkill = hApi.GetHeroTactic(nHeroId)
		end
		
		if tSkill and idx and tSkill[idx] then
			
			local skillId = 0
			local skillLv = 0
			
			if bType == 0 then
				skillId =  tSkill[idx][1]
				skillLv = 0
				if oHero.data.talent and oHero.data.talent[idx] then
					skillLv = oHero.data.talent[idx].lv or 0
				end
			elseif bType == 1 then
				local tactics = hApi.GetHeroTactic(nHeroId)
				if tactics and tactics[idx] then
					skillId =  tactics[idx].id or 0
					skillLv = tactics[idx].lv or 1
				end
			end
			
			local star = oHero.attr.star
			local starInfo = hVar.HERO_STAR_INFO[nHeroId][star]
			local maxLv = starInfo.maxLv					--等级上限
			local unlockSkillNum = starInfo.unlockSkillNum			--解锁技能数量
			
			local costRmb = 0
			local costScore = 0
			local nowScore = LuaGetPlayerScore()
			local shopItemId = hVar.SKILL_LVUP_COST[skillLv] or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			local itemId = 0
			if tabShopItem then
				costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0
				itemId = tabShopItem.itemID or 0
			end
				
			local ok = function()
				hGlobal.event:event("LocalEvent_SkillLevelUp", oHero, idx, bType, btnType)
			end
			
			--技能图标
			local sIcon
			local sName
			local sLvInfoB
			if bType == 0 then
				sIcon = hVar.tab_skill[skillId].icon
				sName = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][1] or ("未知技能" .. skillId)
				sLvInfoB = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][skillLv + 1] or ("未知技能描述" .. skillId)
			elseif bType == 1 then
				sIcon = hVar.tab_tactics[skillId].icon
				sName = hVar.tab_stringT[skillId] and hVar.tab_stringT[skillId][1] or ("未知战术技能" .. skillId)
				sLvInfoB = hVar.tab_stringT[skillId] and hVar.tab_stringT[skillId][skillLv + 1] or ("未知战术技能描述" .. skillId)
			end
		
			local cost
			local costNow
			local costIcon
			local costError
			if "Score" == btnType then --积分
				cost = costScore
				costNow = nowScore
				costIcon = "UI:score"
				costError = hVar.tab_string["__TEXT_ScoreNotEnough"]
			elseif "Rmb" ==  btnType then --金币
				cost = costRmb
				costNow = 0
				if type(_cur_rmb) == "number" then
					costNow = _cur_rmb
				end
				costIcon = "UI:game_coins"
				costError = hVar.tab_string["ios_not_enough_game_coin"]
			end
			
			local sLvInfoN = ""
			if idx > unlockSkillNum or skillLv <= 0 then
				
			--elseif skillLv >= maxLv or skillLv >= oHero.attr.level then --geyachao: 应王总要求，这里改为就算不能升级，也显示下一级效果
			elseif skillLv >= maxLv then
				sLvInfoN = "已升到顶级"
			else
				if bType == 0 then --天赋技能
					sLvInfoN =  hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][skillLv + 2] or ("未知战术技能描述" .. skillId)
				elseif bType == 1 then --战术技能
					sLvInfoN = hVar.tab_stringT[skillId] and hVar.tab_stringT[skillId][skillLv + 2] or ("未知技能描述" .. skillId)
				end
			end
			
			local isMax = false --是否到顶级
			if skillLv >= maxLv or skillLv >= oHero.attr.level then --geyachao: 应王总要求，这里改为就算不能升级，也显示下一级效果
				isMax = true
			end
			
			--local lvNext = math.min(math.min((skillLv + 1), oHero.attr.level),maxLv)
			local lvNext = math.min(skillLv + 1, maxLv) --geyachao: 应王总要求，这里改为就算不能升级，也显示下一级效果
			--参数列表
			local setting = {
				name = sName,									--名称
				icon = sIcon,									--图标
				
				lv = skillLv,									--当前等级
				lvNext = lvNext,								--下一等级
				lvMaxErr = hVar.tab_string["hero_skilllevelMax"],				--等级满时的错误提示
				isMax = isMax, --是否到顶级
				
				info = sLvInfoB,								--当前等级信息
				infoNext = sLvInfoN,									--下一等级信息
				
				requireList = {									--需求资源列表
					[1] = {
						icon = costIcon,						--资源图标
						cost = cost,							--资源消耗
						now = costNow,							--当前资源
						err = costError,						--资源不足提示
						flag = false,							--是否有材料
					},
				},
				
				func = ok,									--按钮点击函数
			}
			hGlobal.event:event("LocalEvent_showGeneralLvUpFrm", setting)
			
		end
	end
	
	--技能名
	_childUI["skillName"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 35,
		y = -448,
		width = 265,
		text = "",
		RGB = {255, 255, 0},
	})
	
	--技能类型
	_childUI["skillType"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 170,
		y = -448 - 2,
		width = 300,
		--text = "战术技能", --language
		text = "", --language
	})
	
	--技能冷却的图标
	_childUI["skillCDIcon"] = hUI.image:new({
		parent = _parent,
		model = "ui/bimage_replay.png",
		x = 280 + 18,
		y = -448 - 2 - 10,
		scale = 0.45,
	})
	_childUI["skillCDIcon"].handle.s:setColor(ccc3(168, 168, 168))
	
	--技能冷却的时间
	_childUI["skillCDLabel"] = hUI.label:new({
		parent = _parent,
		size = 17,
		align = "RT",
		font = "numWhite",
		--border = 1,
		x = 340,
		y = -448 - 2,
		width = 300,
		text = "",
	})
	_childUI["skillCDLabel"].handle.s:setColor(ccc3(168, 168, 168))
	
	--技能冷却"秒"
	_childUI["skillCDSecond"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 340,
		y = -448 - 2,
		width = 320,
		--text = "秒", --language
		text = hVar.tab_string["__Second"], --language
	})
	_childUI["skillCDSecond"].handle.s:setColor(ccc3(168, 168, 168))
	
	--技能介绍
	_childUI["skillInfo"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 35,
		y = -480,
		width = 360,
		--height = 120,
		text = "",
	})
	
	--技能升级按钮(积分)
	_childUI["btnSkillLvUp"] = hUI.button:new({
		parent = _parent,
		--model = "MODEL:default",
		--model = "UI:confirmbut",
		--model = "UI:ButtonBack2",
		--x = 495,
		model = "UI:BTN_ButtonRed", 
		animation = "normal",
		dragbox = _childUI["dragBox"],
		font = hVar.FONTC,
		border = 1,
		align = "MC",
		label = hVar.tab_string["__UPGRADE"],
		--y = -455,
		--scale = 1,
		x = 465,
		y = -490,
		scale = 1,
		scaleT = 0.95,
		--zhenkira: geyachao 老版本升级引导的地方，需要修改
		--code = function(self)
		--	if g_cur_net_state == -1 then
		--		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion5_Net"],{
		--			font = hVar.FONTC,
		--			ok = function()
		--				--self:setstate(1)
		--			end,
		--		})
		--	elseif g_cur_net_state == 1 then
		--		hGlobal.event:event("LocalEvent_SkillLevelUp", self.oHero, self.idx, self.type, "Score")
		--	end
		--	
		--	print("LocalEvent_SkillLevelUpLocalEvent_SkillLevelUpLocalEvent_SkillLevelUpLocalEvent_SkillLevelUpLocalEvent_SkillLevelUp")
		--	--geyachao: 为引导加的事件，点击升级按钮事件
		--	hGlobal.event:event("LocalEvent_ClickSkillLevelUp")
		--end,
		code = function(self)
			
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion5_Net"],{
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
			elseif g_cur_net_state == 1 then
				--hGlobal.event:event("LocalEvent_SkillLevelUp", self.oHero, self.idx, self.type, "Score")
				CreateSkillLvUpMessageBox(self.oHero, self.idx, self.type, "Score")
			end
		end,
	})
	local _btnSkillLvUpScore = _childUI["btnSkillLvUp"]
	_btnSkillLvUpScore.childUI["UI_Arrow"] = hUI.image:new({
		parent = _btnSkillLvUpScore.handle._n,
		model = "UI:UI_Arrow",
		scale = 0.7,
		roll = 90,
		x = 85,
	})
	_btnSkillLvUpScore.childUI["UI_Arrow"].handle._n:setRotation(-90)

	--技能升级消耗图标(积分)
	--_btnSkillLvUpScore.childUI["imgFlag"] = hUI.image:new({
	--	--parent = _parent,
	--	parent = _btnSkillLvUpScore.handle._n,
	--	model = "UI:score",
	--	x = -30,
	--	y = 2,
	--	scale = 0.45,
	--})
	----技能升级消耗(积分)
	--_btnSkillLvUpScore.childUI["labCost"] = hUI.label:new({
	--	--parent = _parent,
	--	parent = _btnSkillLvUpScore.handle._n,
	--	size = 24,
	--	align = "MC",
	--	border = 1,
	--	x = 25,
	--	--y = -468,
	--	width = 265,
	--	--height = 120,
	--	text = "0",
	--})
	----------------------------------------------------------------
	--技能升级按钮(rmb)
	_childUI["btnSkillLvUpRmb"] = hUI.button:new({
		parent = _parent,
		--model = "MODEL:default",
		--model = "UI:confirmbut",
		model = "UI:ButtonBack2",
		dragbox = _childUI["dragBox"],
		x = 475,
		y = -515,
		scale = 1,
		scaleT = 0.9,
		code = function(self)
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion5_Net"],{
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
			elseif g_cur_net_state == 1 then
				hGlobal.event:event("LocalEvent_SkillLevelUp", self.oHero, self.idx, self.type, "Rmb")
			end
		end,
	})
	local _btnSkillLvUpRmb = _childUI["btnSkillLvUpRmb"]
	--技能升级消耗图标(rmb)
	_btnSkillLvUpRmb.childUI["imgFlag"] = hUI.image:new({
		--parent = _parent,
		parent = _btnSkillLvUpRmb.handle._n,
		model = "UI:game_coins",
		x = -30,
		y = 2,
		scale = 0.8,
	})
	----技能升级消耗(rmb)
	_btnSkillLvUpRmb.childUI["labCost"] = hUI.label:new({
		--parent = _parent,
		parent = _btnSkillLvUpRmb.handle._n,
		size = 24,
		align = "MC",
		border = 1,
		x = 25,
		--y = -468,
		width = 265,
		--height = 120,
		text = "123",
	})
	_btnSkillLvUpRmb:setstate(-1)
	
	----------------------------------------------------------------
	local _SK_UIHandle = {}
	local _SK_UIParam = {
		IsEnd = 0,
		dragbox = _frm.childUI["dragBox"],
		ModelFunc = function(self,param)
			local id = self.id
			local lv = self.lv
			local upgrade = self.upgrade
			local require = self.require
			local type = self.type
			return param[1](id,lv,upgrade,require,param[2],type)
		end,
		BtnFunc = function(self,pCode)
			local heroID = self.heroID
			local id = self.id
			local lv = self.lv
			local upgrade = self.upgrade
			local idx = self.idx
			local oHero = self.oHero
			local type = self.type
			local tIdx = self.tIdx
			return function()
				return pCode(heroID,id,lv,upgrade,idx,oHero,type,tIdx)
			end
		end,
		heroID = 0,
		require = 0,
		id = 0,
		lv = 0,
		upgrade = 0,
		idx = 0,  --数据中的idx
		oHero = 0,
		type = 0,
		tIdx = 0,  --ui的实际idx
	}
	local _SK_UIBtnList = {
		{"button","btnSkill",
			{
				function(id,lv,upgrade,require,param,type)
					local model = ""
					if type == 1 then
						model = hVar.tab_tactics[id].icon 
					elseif type == 0 then
						model = hVar.tab_skill[id].icon 
					end
					return model
				end
			},
			{0, 0, 72, 72,0.9}, --英雄技能图标的大小
			function(nHeroID,id,lv,upgrade,idx,oHero,type,tIdx)
				--return hGlobal.event:event("LocalEvent_ShowSkillInfoFram",nHeroID,id,_x,_y)
				hGlobal.event:event("LocalEvent_ShowSkillInfo",oHero,nHeroID,idx, type, tIdx)
			end
		},
		{"image","imgUpgrade", {"UI:skillup"}, {1, 2, 88, 88, 2}}, --选中英雄技能图标的边框
		{"labelX","numRequire",{function(id, lv, upgrade, require)
			if lv<=0 then
				return ""
			else
				return tostring(lv)
			end
		end},{0, -50, 20, 0, "MC", "numWhite"}}, --英雄技能图标等级文字
		{"labelX", "numRequirePreifx", hVar.tab_string["__Attr_Hint_Lev"], {0 - 35, 0 - 50, 22, 1, "LC", hVar.FONTC}}, --英雄技能图标等级文字前缀
	}
	local _createSkillIcon = function(oHero, nHeroID)
		for n = 1,#_SK_UIHandle do
			if _SK_UIHandle[n]~=0 then
				local v = _SK_UIHandle[n]
				for i = 1,#_SK_UIBtnList do
					local k = _SK_UIBtnList[i][2]
					local case = type(v[k])
					if case=="table" then
						v[k]:del()
					elseif case=="userdata" then
						_frm.handle._n:removeChild(v[k],true)
					end
				end
				_SK_UIHandle[n] = 0
			end
		end
		--print(oHero, oHero.data.skill, oHero.data.name, oHero.data.id)
		_frm.childUI["dragBox"]:sortbutton()
		--local tSkill = oHero.data.skill
		local tSkill = {}
		local tabU = hVar.tab_unit[nHeroID]
		if tabU and tabU.talent then
			tSkill = tabU.talent
		end
		--每个星级开放一个技能，这里使用当前开放的星级上限
		local tactics = hApi.GetHeroTactic(nHeroID)
		local NSKILL_DX = 120 + (#tactics - 1) * 85 --普通技能的偏移
		local TSKILL_DX = -75 --战术技能的偏移
		local idx = 1
		local skillNum = math.min(hVar.HERO_STAR_INFO.maxStarLv, #tSkill)
		for i = 1, skillNum, 1 do
			_SK_UIHandle[i] = 0
			--local skillId = tSkill[i]
			local skillId = tSkill[i][1]
			local skillLv = 0
			--print("每个星级开放一个技能", skillId)
			if oHero.data.talent and oHero.data.talent[i] and (oHero.data.talent[i].id ~= 0) then
				skillLv = oHero.data.talent[i].lv or 0
			end
			if skillId and hVar.tab_skill[skillId] then
				_SK_UIParam.heroID = oHero.data.id
				--_SK_UIParam.require = hVar.HERO_SKILL_REQUIRE[i] or hVar.HERO_SKILL_REQUIRE[#hVar.HERO_SKILL_REQUIRE]
				_SK_UIParam.id = skillId
				_SK_UIParam.lv,_SK_UIParam.upgrade = skillLv, skillId
				_SK_UIParam.idx = i
				_SK_UIParam.tIdx = i
				_SK_UIParam.oHero = oHero
				_SK_UIParam.type = 0
				_SK_UIHandle[i] = {}
				--创建英雄被动技能图标
				--print("创建英雄被动技能图标", 62 + (i - 1) * 85)
				hUI.CreateMultiUIByParam(_frm.handle._n, 62 + (i - 1) * 85 + NSKILL_DX, -380, _SK_UIBtnList,_SK_UIHandle[i], _SK_UIParam)
				idx = i
				
				--创建提示升级技能的动态箭头
				if (not _SK_UIHandle[idx]["btnSkill"].childUI["lvup"]) then
					_SK_UIHandle[idx]["btnSkill"].childUI["lvup"] = hUI.image:new({
						parent = _SK_UIHandle[idx]["btnSkill"].handle._n,
						model = "ICON:image_jiantouV",
						x = 15,
						y = -11,
						scale = 0.8,
						z = 100,
					})
				end
				_SK_UIHandle[idx]["btnSkill"].childUI["lvup"].handle.s:setVisible(false) --一开始默认隐藏
			end
		end
		
		--创建英雄战术技能卡图标
		--英雄战术技能
		local tactics = hApi.GetHeroTactic(nHeroID)
		for j = 1, #tactics do
			_SK_UIHandle[idx + j] = 0
			
			local tactic = tactics[j]
			if tactic then
				local tacticId = tactic.id or 0
				--print("英雄战术技能", tacticId)
				local tacticLv = tactic.lv or 1
				if tacticId > 0 and tacticLv > 0 then
					_SK_UIParam.heroID = oHero.data.id
					--_SK_UIParam.require = hVar.HERO_SKILL_REQUIRE[i] or hVar.HERO_SKILL_REQUIRE[#hVar.HERO_SKILL_REQUIRE]
					_SK_UIParam.id = tacticId
					_SK_UIParam.lv,_SK_UIParam.upgrade = tacticLv, tacticLv
					_SK_UIParam.idx = j
					_SK_UIParam.tIdx = idx + j
					_SK_UIParam.oHero = oHero
					_SK_UIParam.type = 1
					_SK_UIHandle[idx + j] = {}
					--print("英雄战术技能", 62 + (idx + j - 1) * 85 + TSKILL_DX)
					hUI.CreateMultiUIByParam(_frm.handle._n, 62 + (1 + j - 1) * 85 + TSKILL_DX, -380, _SK_UIBtnList, _SK_UIHandle[idx + j], _SK_UIParam)
					idx = idx + j
					
					--创建战术技能卡特别的背景
					--print("创建战术技能卡特别的背景")
					if (not _frm.childUI["tacticBG" .. idx]) then
						_frm.childUI["tacticBG" .. idx] = hUI.image:new({
							parent = _frm.handle._n,
							model = "UI:TacticImgBG",
							x = 0 + 62 + (1 + j - 1) * 85 + TSKILL_DX,
							y = 0 - 380,
							scale = 1.15,
							z = 0,
						})
						
						local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.8, 1.17), CCScaleTo:create(0.8, 1.13))
						local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
						_frm.childUI["tacticBG" .. idx].handle._n:runAction(forever)
					end
					
					--创建提示升级技能的动态箭头
					if (not _SK_UIHandle[idx]["btnSkill"].childUI["lvup"]) then
						_SK_UIHandle[idx]["btnSkill"].childUI["lvup"] = hUI.image:new({
							parent = _SK_UIHandle[idx]["btnSkill"].handle._n,
							model = "ICON:image_jiantouV",
							x = 15,
							y = -11,
							scale = 0.8,
							z = 100,
						})
					end
					_SK_UIHandle[idx]["btnSkill"].childUI["lvup"].handle.s:setVisible(false) --一开始默认隐藏
				end
			end
		end
	end
	
	--刷新英雄的所有技能图标
	local _reflashSkillIcon = function(oHero)
		if not(oHero and type(oHero.data.talent)=="table") then
			return
		end
		
		local star = oHero.attr.star
		local starInfo = hVar.HERO_STAR_INFO[oHero.data.id][star]
		local maxLv = starInfo.maxLv					--等级上限
		local unlockSkillNum = starInfo.unlockSkillNum			--解锁技能数量
		
		--local tTalent = oHero.data.talent
		local tTalent = {}
		local tabU = hVar.tab_unit[oHero.data.id]
		if tabU and tabU.talent then
			tTalent = tabU.talent
		end
		
		local idx = 1
		--每个星级开放一个被动技能，这里使用当前开放的星级上限
		local OringSkillNum = math.min(hVar.HERO_STAR_INFO.maxStarLv,#tTalent)
		for i = 1, OringSkillNum, 1 do
			local skillObj = tTalent[i]
			local skillId = tTalent[i][1]
			local skillLv = 0
			if oHero.data.talent and oHero.data.talent[i] and (oHero.data.talent[i].id ~= 0) then
				skillLv = oHero.data.talent[i].lv or 0
			end
			--print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$skillLv:",skillLv)
			
			--显示被动技能
			if (v ~= 0) and ((_SK_UIHandle[i] or 0) ~= 0) then
				_SK_UIHandle[i]["imgUpgrade"]:setVisible(false)
				if (i > unlockSkillNum) then
					local program = hApi.getShader("gray")
					_SK_UIHandle[i]["btnSkill"].handle.s:setColor(ccc3(255,255,255))
					_SK_UIHandle[i]["btnSkill"].handle.s:setShaderProgram(program)
					_SK_UIHandle[i]["numRequire"].handle.s:setVisible(false)
					--_SK_UIHandle[i]["numRequirePreifx"]:setText("未解锁") --language
					_SK_UIHandle[i]["numRequirePreifx"]:setText(hVar.tab_string["UnLock"]) --language
					_SK_UIHandle[i]["numRequirePreifx"].handle.s:setColor(ccc3(244, 8, 8)) --193, 43, 43
				else
					if (skillLv > 0) and (skillLv < maxLv) then --有效的等级
						local program = hApi.getShader("normal")
						_SK_UIHandle[i]["btnSkill"].handle.s:setShaderProgram(program)
						_SK_UIHandle[i]["btnSkill"].handle.s:setColor(ccc3(255,255,255))
						_SK_UIHandle[i]["numRequire"].handle.s:setVisible(true)
						_SK_UIHandle[i]["numRequire"]:setText(tostring(skillLv))
						--_SK_UIHandle[i]["numRequirePreifx"]:setText("等级") --language
						_SK_UIHandle[i]["numRequirePreifx"]:setText(hVar.tab_string["__Attr_Hint_Lev"]) --language
						_SK_UIHandle[i]["numRequirePreifx"].handle.s:setColor(ccc3(255, 255, 255))
					elseif (skillLv >= maxLv) then --技能等级已到顶级
						local program = hApi.getShader("normal")
						_SK_UIHandle[i]["btnSkill"].handle.s:setShaderProgram(program)
						_SK_UIHandle[i]["btnSkill"].handle.s:setColor(ccc3(128,128,128))
						_SK_UIHandle[i]["numRequire"].handle.s:setVisible(true)
						_SK_UIHandle[i]["numRequire"]:setText(tostring(skillLv))
						--_SK_UIHandle[i]["numRequirePreifx"]:setText("15级解锁") --language
						_SK_UIHandle[i]["numRequirePreifx"]:setText(hVar.tab_string["__Attr_Hint_Lev"]) --language
						_SK_UIHandle[i]["numRequirePreifx"].handle.s:setColor(ccc3(255, 255, 255))
					elseif (skillLv <= 0) then --未解锁的被动技能
						local program = hApi.getShader("gray")
						_SK_UIHandle[i]["btnSkill"].handle.s:setColor(ccc3(255,255,255))
						_SK_UIHandle[i]["btnSkill"].handle.s:setShaderProgram(program)
						_SK_UIHandle[i]["numRequire"].handle.s:setVisible(false)
						--_SK_UIHandle[i]["numRequirePreifx"]:setText("15级解锁") --language
						_SK_UIHandle[i]["numRequirePreifx"]:setText(hVar.tab_string["UnLock"]) --language
						_SK_UIHandle[i]["numRequirePreifx"].handle.s:setColor(ccc3(244, 8, 8)) --193, 43, 43
					end
				end
				idx = i
				
				--检测本技能是否可以升级
				--如果技能未到顶级，并且小于英雄的等级，并且积分足够，那么提示升级
				local costScore = 0 --升级需要的积分
				local nowScore = LuaGetPlayerScore() --当前积分
				local shopItemId = hVar.SKILL_LVUP_COST[skillLv] or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0
				end
				
				if (i <= unlockSkillNum) and (skillLv > 0) and (skillLv < maxLv) and (skillLv < oHero.attr.level) and (nowScore >= costScore) then --技能可以升级
					_SK_UIHandle[idx]["btnSkill"].childUI["lvup"].handle.s:setVisible(true)
					--print(idx)
					--print("技能可以升级", idx)
				else --技能不能升级
					_SK_UIHandle[idx]["btnSkill"].childUI["lvup"].handle.s:setVisible(false)
					--print("技能不能升级", idx)
				end
			end
		end
		
		--英雄战术技能
		local tactics = hApi.GetHeroTactic(oHero.data.id)
		for j = 1, #tactics do
			local tactic = tactics[j]
			if tactic and (_SK_UIHandle[idx + j] or 0)~=0 then
				_SK_UIHandle[idx + j]["imgUpgrade"]:setVisible(false)
				local tacticId = tactic.id or 0
				local tacticLv = tactic.lv or 1
				if (tacticLv > 0) and (tacticLv < maxLv) then --有效的等级
					local program = hApi.getShader("normal")
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setShaderProgram(program)
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setColor(ccc3(255,255,255))
					_SK_UIHandle[idx + j]["numRequire"].handle.s:setVisible(true)
					_SK_UIHandle[idx + j]["numRequire"]:setText(tostring(tacticLv))
					--_SK_UIHandle[idx + j]["numRequirePreifx"]:setText("等级") --language
					_SK_UIHandle[idx + j]["numRequirePreifx"]:setText(hVar.tab_string["__Attr_Hint_Lev"]) --language
					_SK_UIHandle[idx + j]["numRequirePreifx"].handle.s:setColor(ccc3(255, 255, 255))
				elseif (tacticLv >= maxLv) then --技能等级已到顶级
					local program = hApi.getShader("normal")
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setShaderProgram(program)
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setColor(ccc3(128,128,128))
					_SK_UIHandle[idx + j]["numRequire"].handle.s:setVisible(true)
					_SK_UIHandle[idx + j]["numRequire"]:setText(tostring(tacticLv))
					--_SK_UIHandle[idx + j]["numRequirePreifx"]:setText("等级") --language
					_SK_UIHandle[idx + j]["numRequirePreifx"]:setText(hVar.tab_string["__Attr_Hint_Lev"]) --language
					_SK_UIHandle[idx + j]["numRequirePreifx"].handle.s:setColor(ccc3(255, 255, 255))
				elseif (tacticLv <= 0) then --未解锁的战术技能
					local program = hApi.getShader("gray")
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setColor(ccc3(255,255,255))
					_SK_UIHandle[idx + j]["btnSkill"].handle.s:setShaderProgram(program)
					_SK_UIHandle[idx + j]["numRequire"].handle.s:setVisible(false)
					--_SK_UIHandle[idx + j]["numRequirePreifx"]:setText("15级解锁") --language
					_SK_UIHandle[idx + j]["numRequirePreifx"]:setText(hVar.tab_string["UnLock"]) --language
					_SK_UIHandle[idx + j]["numRequirePreifx"].handle.s:setColor(ccc3(244, 8, 8)) --193, 43, 43
				end
				
				--检测本技能是否可以升级
				--如果技能未到顶级，并且小于英雄的等级，并且积分足够，那么提示升级
				local costScore = 0 --升级需要的积分
				local nowScore = LuaGetPlayerScore() --当前积分
				local shopItemId = hVar.SKILL_LVUP_COST[tacticLv] or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0
				end
				
				if (tacticLv > 0) and (tacticLv < maxLv) and (tacticLv < oHero.attr.level) and (nowScore >= costScore) then --技能可以升级
					_SK_UIHandle[idx + j]["btnSkill"].childUI["lvup"].handle.s:setVisible(true)
					--print("技能可以升级", (idx + j))
				else --技能不能升级
					_SK_UIHandle[idx + j]["btnSkill"].childUI["lvup"].handle.s:setVisible(false)
					--print("技能不能升级", (idx + j))
				end
			end
		end
		
		if not _SK_SELECTED_ID then
			--type: 0:普通技能 / 1:战术技能
			hGlobal.event:event("LocalEvent_ShowSkillInfo",oHero,oHero.data.id, 1, 1, OringSkillNum + 1) --geyachao: 默认选中第一个战术技能
		else
			hGlobal.event:event("LocalEvent_ShowSkillInfo",oHero,oHero.data.id,_SK_SELECTED_ID.idx, _SK_SELECTED_ID.type, _SK_SELECTED_ID.tIdx)
		end
	end
	
	--用以显示和刷新 英雄属性的数字
	local _HeroInfoNumber = {}
	--基础属性的 坐标
	local _attr_x,_attr_y = 184,-42
	
	local _conf_Icon = hApi.CreateConf("image","icon","MT",-26,-154,65,0)
	local _conf_Label = hApi.CreateConf("label","aLabel","MT",-26,-184,65,0)
	local _conf_Val = hApi.CreateConf("label","attr","MT",-26,-212,65,0)
	local OFFY = -10 --每个属性偏移值y
	
	--属性背景
	for i = 1,#hVar.HeroAttrInfo do
		local x = _attr_x - 83
		local y = _attr_y - 60 - (i - 1) * 38 + OFFY * (i - 1) + 48
		_childUI["HeroBaseAttrBg_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:AttrBg",
			x = x,
			y = y,
			alpha = 160,
		})
	end
	
	local _HeroLabel = {
		--英雄的名字
		--姓名
		hApi._add_Label("LableName", "null", _attr_x + 155, _attr_y - 262, 1, "MC", 38), --英雄名控件
		
		--等级
		--hApi._add_Val("attrLevel","numWhite",_attr_x + 134,_attr_y,"1","LC",22, 1),
		--hApi._add_Val("attrLevelLV","numRed",_attr_x - 70,_attr_y,"lv","LC",22, 1),
		
		--英雄经验值
		--经验
		--hApi._add_Label("LabelExp",hVar.tab_string["__Attr_Hint_Exp"],_attr_x - 133,_attr_y -70),
		--hApi._add_Bar("barExp", _attr_x - 155, _attr_y -30, nil, 140),
		--hApi._add_Val("attrExp", "numWhite", _attr_x-80, _attr_y-30, "0/0", "MC"),
		--hApi._add_Icon("attrExpIcon","ICON:ATTR_exp","normal",_attr_x-150,_attr_y-66),
		
		--生命
		hApi._add_Icon("imgFlagHp","ICON:HeroAttr","hp_pec",_attr_x-150,_attr_y-62 - OFFY * 5,30),
		--hApi._add_Label("LabelHp",hVar.tab_string["__Attr_Hint_Hp:"],_attr_x-162,_attr_y-112),
		hApi._add_Val("attrHp", "numWhite",_attr_x-130,_attr_y-63 - OFFY * 5,nil,"LC",20),
		
		--攻击
		hApi._add_Icon("imgFlagAtk","ICON:action_attack","normal",_attr_x-150,_attr_y-100 - OFFY * 4,30),
		--hApi._add_Label("LabelAtk",hVar.tab_string["__Attr_Atk"],_attr_x-162,_attr_y-139),
		hApi._add_Val("attrAtk", "numWhite",_attr_x-130,_attr_y-101 - OFFY * 4,"28-100","LC",20),
		
		--物防
		--hApi._add_Label("LabelDef",hVar.tab_string["__Attr_Def"],_attr_x-162,_attr_y-166),
		hApi._add_Icon("imgFlagDef","ICON:DETICON","normal",_attr_x-150,_attr_y-137 - OFFY * 3,30),
		hApi._add_Val("attrDef", "numWhite",_attr_x-130,_attr_y-138 - OFFY * 3,"200","LC",20),

		--法防 striking distance type
		--hApi._add_Label("LabelStrtype",hVar.tab_string["__Attr_Toughness"],_attr_x-162,_attr_y-193),
		hApi._add_Icon("imgFlagStrType","ICON:icon01_x1y1","normal",_attr_x-150,_attr_y-175 - OFFY * 2,30),
		hApi._add_Val("attrStrType", "numWhite",_attr_x-130,_attr_y-176 - OFFY * 2,"100","LC",20),
		
		--速度
		--hApi._add_Label("LabelMovePoint",hVar.tab_string["__Attr_Hint_MovePoint"],_attr_x-162,_attr_y-220),
		hApi._add_Icon("imgFlagMovePoint","ICON:Item_Horse01","normal",_attr_x-150,_attr_y-213 - OFFY * 1,30),
		hApi._add_Val("attrMovePoint", "numWhite",_attr_x-130,_attr_y-214 - OFFY * 1,"1","LC",20),
		
		--攻速
		--hApi._add_Label("LabelSpeed",hVar.tab_string["__Attr_Speed"],_attr_x-162,_attr_y-247),
		hApi._add_Icon("imgFlagSpeed","ICON:MOVESPEED","normal",_attr_x-150,_attr_y-252 - OFFY * 0,30),
		hApi._add_Val("attrAtkSpeed", "numWhite",_attr_x-130,_attr_y-253 - OFFY * 0,"20","LC",20),
	}
	
	_childUI["heroAttr"] = hUI.node:new({
		parent = _parent,
		child = _HeroLabel,
	})
	
	--英雄属性
	for i = 1,#hVar.HeroAttrInfo do
		--local x,y = hVar.HeroAttrInfo[i].x,hVar.HeroAttrInfo[i].y
		local x = _attr_x - 83
		local y = _attr_y - 60 - (i - 1) * 38 + OFFY * (i - 1) + 48
		
		_childUI["HeroBaseAttr_"..i] = hUI.button:new({
			parent = _parent,
			--model = "MODEL:default",
			model = -1,
			dragbox =_childUI["dragBox"],
			w = 180,
			h = 36 + 10,
			x = x,
			y = y,
			z = 0,
			codeOnTouch = function()
				hGlobal.event:event("LocalEvent_showAttributeInfoFrm",nil,nil,i,hVar.HeroAttrInfo,1,_HeroInfoNumber)
			end,
			code = function()
				hGlobal.event:event("LocalEvent_closeAttributeInfoFrm")
			end,
			codeOnDrag = function(self,x,y,sus)
				if sus ~= 1 then
					hGlobal.event:event("LocalEvent_closeAttributeInfoFrm")
				end
			end,
		})
	end

	------------------------------------------------------------------------------------------------
	--英雄星级相关
	--暗色的星
	--[[
	--geyachao: 不显示升星
	for i = 1, 5 do
		_childUI["imgStarBg_".. tostring(i)] = hUI.image:new({
			parent = _parent,
			model = "UI:HeroStarBG",
			x = 215 + (i - 1) * 32,
			y = -295,
			z = 1,
			scale = 1,
		})
	end
	]]
	--星
	for i = 1, hVar.HERO_STAR_INFO.maxStarLv do
		_childUI["imgStar_".. tostring(i)] = hUI.image:new({
			parent = _parent,
			model = "UI:STAR_YELLOW",
			x = 215 + (i - 1) * 32,
			y = -295,
			z = 2,
			scale = 0.5,
		})
		_childUI["imgStar_".. tostring(i)].handle._n:setVisible(false)
	end

	--灵魂石图标
	--_childUI["imgSoulStoneFlag"] = hUI.image:new({
	--	parent = _parent,
	--	model = "UI:SoulStoneFlag",
	--	x = 205,
	--	y = -310,
	--	scale = 1,
	--})
	--灵魂石经验条
	_childUI["barSoulStoneExp"] = hUI.valbar:new({
		parent = _parent,
		x = 220,
		y = -300,
		w = 149,
		h = 14,
		align = "LC",
		back = {model = "UI:SoulStoneBarBg", x = -4,y= 0,w=155,h=20},
		model = "UI:SoulStoneBar",
		--model = "misc/progress.png",
		v = 100,
		max = 100,

	})
	_childUI["barSoulStoneExp"].handle._n:setVisible(false)
	--灵魂石所需经验显示
	_childUI["labSoulStoneExp"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = "numWhite",
		x = 300,
		y = -300,
		text = "",
	})
	_childUI["labSoulStoneExp"].handle._n:setVisible(false)
	
	--升星按钮
	_childUI["btnStarLvUp"] = hUI.button:new({
		parent = _parent,
		--model = "MODEL:default",
		--model = "UI:maxbutton",
		model = "UI:ButtonBack2",
		dragbox = _frm.childUI["dragBox"],
		x = 410,
		y = -298,
		w = 90,font = hVar.FONTC,
		border = 1,
		align = "MC",
		label = hVar.tab_string["__UPGRADESTAR"],
		scale = 0.9,
		scaleT = 0.95,
		code = function(self)
			
			--
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DemoInfo3"],{
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
			
			--todo: zhenkira 多模式时候再开放功能，要重新做个界面
			--if g_cur_net_state == -1 then
			--	hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion6_Net"],{
			--		font = hVar.FONTC,
			--		ok = function()
			--			--self:setstate(1)
			--		end,
			--	})
			--elseif g_cur_net_state == 1 then
			--	hGlobal.event:event("LocalEvent_StarLevelUp", self.oHero)
			--end
		end,
	})
	
	--向左翻页的按钮
	_childUI["heroPageLeft"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 236,
		y = -235,
		w = 120,
		h = 180,
		scaleT = 0.95,
		dragbox = _frm.childUI["dragBox"],
		code = function()
			--绘制英雄前一页
			--找出当前的英雄是第几项
			local currentIdx = 0
			for i = 1, #Save_PlayerData.herocard, 1 do
				if (Save_PlayerData.herocard[i].id == _tTokenHero.data.id) then
					currentIdx = i --找到了
					break
				end
			end
			
			--加载新英雄界面
			if (currentIdx > 1) then
				hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, Save_PlayerData.herocard[currentIdx - 1].id, 0)
				--_tTokenHero:load(Save_PlayerData.herocard[currentIdx - 1].id, 1)
			else
				hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, Save_PlayerData.herocard[#Save_PlayerData.herocard].id, 0)
			end
		end,
	})
	_childUI["heroPageLeft"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--向左翻页的按钮的图片
	_childUI["heroPageLeft"].childUI["img"] = hUI.image:new({
		parent = _childUI["heroPageLeft"].handle._n,
		model = "UI:PageBtn",
		x = -40,
		y = -45,
		scale = 1.0
	})
	_childUI["heroPageLeft"].childUI["img"].handle.s:setRotation(0)
	_childUI["heroPageLeft"].childUI["img"].handle.s:setOpacity(224) --提示左翻页图片透明度为224
	local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(2, 0)), CCMoveBy:create(0.5, ccp(-2, 0)))
	local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
	_childUI["heroPageLeft"].childUI["img"].handle._n:runAction(forever)
	
	--向右翻页的按钮
	_childUI["heroPageRight"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 433,
		y = -235,
		w = 120,
		h = 180,
		scaleT = 0.95,
		dragbox = _frm.childUI["dragBox"],
		code = function()
			--绘制英雄后一页
			--找出当前的英雄是第几项
			local currentIdx = 0
			for i = 1, #Save_PlayerData.herocard, 1 do
				if (Save_PlayerData.herocard[i].id == _tTokenHero.data.id) then
					currentIdx = i --找到了
					break
				end
			end
			
			--加载新英雄界面
			if (currentIdx < #Save_PlayerData.herocard) then
				hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, Save_PlayerData.herocard[currentIdx + 1].id, 0)
				--_tTokenHero:load(Save_PlayerData.herocard[currentIdx + 1].id, 1)
			else
				hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, Save_PlayerData.herocard[1].id, 0)
			end
		end,
	})
	_childUI["heroPageRight"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--向右翻页的按钮的图片
	_childUI["heroPageRight"].childUI["img"] = hUI.image:new({
		parent = _childUI["heroPageRight"].handle._n,
		model = "UI:PageBtn",
		x = 40,
		y = -45,
		scale = 1.0
	})
	_childUI["heroPageRight"].childUI["img"].handle.s:setRotation(180)
	_childUI["heroPageRight"].childUI["img"].handle.s:setOpacity(224) --提示右翻页图片透明度为224
	local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-2, 0)), CCMoveBy:create(0.5, ccp(2, 0)))
	local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
	_childUI["heroPageRight"].childUI["img"].handle._n:runAction(forever)
	
	--道具回收箱响应事件（不显示，只用于控制）
	_childUI["btnRecycleBin"] = hUI.button:new({
		parent = _parent,
		x = 820,
		y = -507,
		model = "misc/mask.png", --"UI:playerBagD"
		w = 60,
		h = 60,
		scaleT = 0.95,
		dragbox = _frm.childUI["dragBox"],
		--font = hVar.FONTC,
		--border = 1,
		--align = "MC",
		--label = "出售道具",
		code = function()
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				return
			end
			
			--关闭本界面
			--_frm:show(0)
			--hApi.safeRemoveT(_childUI,"HeroInfoiconImg")
			--hApi.safeRemoveT(_childUI,"HeroInfoiconImg_mask")
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--开启道具分页界面
			hGlobal.event:event("localEvent_ShowPhone_ItemFrame", 1, _tTokenHero, _playerBag_table_state, nil, nil) --指定只显示第1个分页（出售）
		end,
	})
	_childUI["btnRecycleBin"].handle.s:setOpacity(0) --只用于控制，不显示
	
	--道具回收箱图标
	_childUI["btnRecycleBin"].childUI["imgRecycleBin"] = hUI.image:new({
		parent = _childUI["btnRecycleBin"].handle._n,
		model = "UI:ResolveSkillCard2", 
		x = -2,
		y = 0,
		scale = 0.6,
	})
	
	--[[
	local decal, count = 11, 0 --光晕效果
	local r, g, b = 150, 128, 64
	local parent = _childUI["ItemMergeBtn"].handle._n
	local offsetX, offsetY, duration, scale = -1, 1, 0.7, 1.08
	local nnn = xlAddNormalLightEffect(decal, count, offsetX, offsetY, duration, scale, r, g, b, parent)
	nnn:setScale(2.2)
	]]
	
	--灵魂石足够时提示发光特效
	local starBlink1 = nil
	------------------------------------------------------------------------------------------------
	
	--显示玩家仓库
	local _showplayerbag = function(bool)
		_childUI["playbag_current_page"]:setText(_playerBag_table_state.."/"..hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()])
		_childUI["playbag_current_page"].handle._n:setVisible(bool)
		
		if bool then
			if (_playerBag_table_state == 1) then
				_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(255, 255, 255)) --亮掉
			else
				_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
			end
			
			_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
		else
			_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
			_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
		end
	end
	
	--不能继续的tip
	_childUI["CanForgingTip"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = hVar.FONTC,
		x = 840,
		y = -416,
		width = 150,
		text = hVar.tab_string["__TEXT_Can'tForgedItemAgain"],
	})
	_childUI["CanForgingTip"].handle._n:setVisible(false)
	
	--物品栏操作函数
	local _BGV_OprItem = {}
	local _LastHitTick = 0
	local _BGF_IsOprItemConfirm = function(gridX,gridY)
		return _BGV_OprItem.x == gridX and _BGV_OprItem.y == gridY
	end
	local _BGF_GetItemName = function(itemID)
		if type(itemID)~="number" then
			return "unknown"
		end
		if hVar.tab_stringI[itemID][1] then
			return hVar.tab_stringI[itemID][1]
		else
			return "Item_"..itemID
		end
	end
	local _BGF_DrawOprItemIconBG = function(self,itemID,gridX,gridY,pSprite)
		if not(gridX and gridY)then
			gridX = _BGV_OprItem.x
			gridY = _BGV_OprItem.y
		end
		if gridX and gridX and type(self.data.iconBGKey)=="string" then
			local sImageKey = self.data.iconBGKey..gridX.."|"..gridY
			hApi.safeRemoveT(self.childUI,sImageKey)
			if itemID~=0 and hVar.tab_item[itemID] then
				local x,y = self:grid2xy(gridX,gridY,"parent")
				local itemLv = hVar.tab_item[itemID].itemLv or 1
				self.childUI[sImageKey] = hUI.image:new({
					parent = self.handle._n,
					model = hVar.ITEMLEVEL[itemLv].BORDERMODEL,
					mode = "image",
					align = "MC",
					w = 54,
					h = 54,
					x = x-1,
					y = y-1,
					z = -1,
				})
				self.childUI[sImageKey].handle.s:setOpacity(143) --geyachao: 统一设置道具品质的透明度
				--如果是栏，则需要判断是否激活，处理一下颜色
				if self==_childUI["equipage"] then
					local oHero = hApi.GetObjectEx(hClass.hero,_oCurHero)
					if oHero then
						local oItem = oHero.data.equipment[gridX+1]
						if type(oItem)=="table" and hApi.CheckItemAvailable(oItem)==0 then
							self.childUI[sImageKey].handle.s:setColor(ccc3(143,143,143))
							if pSprite~=nil then
								pSprite:setColor(ccc3(143,143,143))
							end
						end
					end
				end
			end
		end
	end
	local _BGF_PickOprItem = function(self,gridX,gridY,nBagIndex)
		local sBagName = 0
		local sBagUI = 0
		if self==_childUI["equipage"] then
			sBagName = "equip"
			sBagUI = "equipage"
		elseif self==_childUI["playerbag"] then
			sBagName = "playerbag"
			sBagUI = "playerbag"
		end
		_LastHitTick = hApi.gametime()
		_BGV_OprItem = {x = gridX,y = gridY,bag = sBagName,bagI = nBagIndex,bagUI = sBagUI}
		if self~=nil then
			_BGF_DrawOprItemIconBG(self,0,gridX,gridY)
		end
		hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
	end

	local _BGF_GetOprItem = function()
		if _HCF_CurrentMode==1 then
			--锁定英雄模式
			local oHero = hApi.GetObjectEx(hClass.hero,_oCurHero)
			if oHero then
				return oHero:getbagitem(_BGV_OprItem.bag,_BGV_OprItem.bagI)
			end
		elseif _HCF_CurrentMode==2 then
			--ID，英雄卡片模式
			if _nCurHeroCardID~=0 then
				return hApi.GetItemFromHeroCard(_nCurHeroCardID, _BGV_OprItem.bag, _BGV_OprItem.bagI)
			end
		end
	end
	
	--szOpType: 道具的位置类型 ("equipage" "playerbag")
	local _BGF_OprItemToUse = function(self,oUnit,oHero,oItem,relX,relY,eUIX,eUIY,eUIoffX, szOpType)
		--print("szOpType", szOpType)
		local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
		--非法道具什么都不做
		if hVar.tab_item[itemID]==nil then
			return 0
		end
		
		local gx,gy,_,pItemSprite = self:xy2grid(relX-_frm.data.x,relY-_frm.data.y,"parent")
		--如果是单击包内某物品，则视为使用消耗类物品流程
		if _BGF_IsOprItemConfirm(gx,gy) then
			local IsClickOnItem = hApi.gametime()-_LastHitTick<350
			_LastHitTick = 0
			if oItem then
				--游戏内英雄模式
				local CanUseItem = 0
				if oHero and oHero.data.HeroCard==1 then
					--允许处理使用道具命令
					CanUseItem = 1
				elseif _BGV_OprItem.bag=="playerbag" then
					--非英雄不可玩家栏以外的道具
					CanUseItem = 1
				end
				if hVar.tab_item[itemID].type==hVar.ITEM_TYPE.DEPLETION and CanUseItem==1 and IsClickOnItem then
					--使用类道具
					if hGlobal.UI.UseItemFrm.data.show==0 then
						hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
						hGlobal.event:event("LocalEvent_ShowUseItemFrm", oUnit, itemID, _BGV_OprItem.bag, _BGV_OprItem.bagI, oHero)
						return 1
					end
				else
					local tItemToShow = {oItem}
					--显示英雄身上的道具tip
					if eUIX and eUIY then
						local nType = hVar.tab_item[itemID].type
						for i = 1,hVar.HERO_EQUIP_SIZE do
							if hApi.GetHeroEquipmentIndexType(nType)== i then
								local oItemE = oHero:getbagitem("equip",i)
								if oItemE then
									tItemToShow[2] = oItemE
									break
								end
							end
						end
					end
					if eUIX==0 and eUIY==0 then
						eUIX = nil
						eUIY = nil
					end
					
					--显示英雄界面的道具tip在这里
					--print("111111")
					--print(oHero, _oCurHero, _tTokenHero)
					hGlobal.event:event("LocalEvent_ShowItemTipFram", tItemToShow, _frm, 1, eUIX, eUIY, eUIoffX, nil, szOpType, _tTokenHero)
				end
			end
			return 1
		end
	end
	
	--移动道具到栏
	local _BGF_OprItemMoveToEquip = function(self,oUnit,oHero,oItem,relX,relY)
		--print("_BGF_OprItemMoveToEquip", oUnit,oHero,oItem,relX,relY)
		--向栏拖动
		local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
		local gx,gy = _childUI["equipage"]:xy2grid(relX+self.data.pickX -_frm.data.x,relY+self.data.pickY-_frm.data.y,"parent")
		--print("relX, relY", relX, relY, "gx,gy", gx,gy)
		
		--geyachao: 只要在装备范围内，都算是选中了装备
		--if (not gx) or (not gy) then
		--print(hVar.SCREEN.w, hVar.SCREEN.h)
		local left = 300 + (hVar.SCREEN.w - 1024) / 2
		local right = 650 + (hVar.SCREEN.w - 1024) / 2
		local top = 300 + (hVar.SCREEN.h - 768) / 2
		local bottom = 630 + (hVar.SCREEN.h - 768) / 2
		--print(left, right ,top ,bottom)
		if (relX >= left) and (relX <= right) and (relY >= top) and (relY <= bottom) then
			local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
			local itemType = hVar.tab_item[itemID].type
			if (itemType == hVar.ITEM_TYPE.WEAPON) then --武器
				gx = 0
				gy = 0
			elseif (itemType == hVar.ITEM_TYPE.BODY) then --防具
				gx = 1
				gy = 0
			elseif (itemType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
				gx = 3
				gy = 0
			elseif (itemType == hVar.ITEM_TYPE.MOUNT) then --马
				gx = 2
				gy = 0
			end
		end
		--end
		
		if _childUI["equipage"].handle._n:isVisible() and gx and gy then
			if oHero then
				--游戏内英雄模式
				if gx+1==hApi.GetHeroEquipmentIndexType(hVar.tab_item[itemID].type) and hApi.IsAttrMeetEquipRequire(oHero.attr,itemID)==1 then
					--允许才发命令
					if oUnit then
						local EquipParam = {_BGV_OprItem.bag,_BGV_OprItem.bagI,"equip",gx+1}
						hGlobal.LocalPlayer:order(oUnit:getworld(),hVar.OPERATE_TYPE.HERO_SORTITEM,oUnit,EquipParam,nil)
					end
				end
			else
				--print(_nCurHeroCardID)
				--游戏外卡片模式
				if _nCurHeroCardID~=0 then
					local result = hApi.ShiftItemByHeroCard(_nCurHeroCardID,_BGV_OprItem.bag,_BGV_OprItem.bagI,"equip",gx+1,_tTokenHero.attr)
					_tTokenHero:load(_nCurHeroCardID,1,"equip")
					
					--穿装备失败，说明装备等级不够
					if (result ~= hVar.RESULT_SUCESS) then
						--print(_BGV_OprItem.bag)
						if (_BGV_OprItem.bag ~= "equip") then --geyachao: 只处理来自背包的穿装备失败事件
							local strText = "英雄等级不够！"
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText,hVar.FONTC,40,"MC",32,0)
						end
					end
				end
			end
			return 1
		end
	end
	--移动道具到玩家仓库
	local _BGF_OprItemMoveToPlayerBag = function(self,oUnit,oHero,oItem,relX,relY)
		local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
		local gx,gy = _childUI["playerbag"]:xy2grid(relX+self.data.pickX -_frm.data.x,relY+self.data.pickY-_frm.data.y,"parent")
		
		if _childUI["playerbag"].handle._n:isVisible() and gx and gy then
			
			if oHero then
				--游戏内英雄模式
				if oUnit then
					--如果正在进行新手引导 则不能移动到自己的道具栏上
					if oUnit:getworld().worldUI["GUIDE_UI"] then
						return 
					end
					local SortParam = {_BGV_OprItem.bag,_BGV_OprItem.bagI,"playerbag",hApi.PlayerBagItemGrid2Index(gx,gy,_playerBag_table_state)}
					hGlobal.LocalPlayer:order(oUnit:getworld(),hVar.OPERATE_TYPE.HERO_SORTITEM,oUnit,SortParam,nil)
				end
			else
				--游戏外卡片模式
				if _nCurHeroCardID~=0 then
					hApi.ShiftItemByHeroCard(_nCurHeroCardID,_BGV_OprItem.bag,_BGV_OprItem.bagI,"playerbag",hApi.PlayerBagItemGrid2Index(gx,gy,_playerBag_table_state),_tTokenHero.attr)
					_tTokenHero:load(_nCurHeroCardID,1,"playerbag")
				end
			end
			return 1
		end
	end
	
	--geyachao: 移动道具到回收站（出售）
	local _BGF_OprItemMoveToRecycleBin = function(self, oUnit, oHero, oItem, relX, relY, szOpType)
		--geyachao: 在引导中，不能打开该界面
		if (hVar.IS_IN_GUIDE_STATE == 1) then
			return
		end
		
		--print("_BGF_OprItemMoveToRecycleBin", self, oUnit, oHero, oItem, relX, relY, szOpType)
		--geyachao: 只要在装备范围内，都算是选中了装备
		--if (not gx) or (not gy) then
		--print(hVar.SCREEN.w, hVar.SCREEN.h)
		local left = 680 + (hVar.SCREEN.w - 1024) / 2
		local right = 915 + (hVar.SCREEN.w - 1024) / 2
		local top = 90 + (hVar.SCREEN.h - 768) / 2
		local bottom = 145 + (hVar.SCREEN.h - 768) / 2
		--print(left, right ,top ,bottom)
		if (relX >= left) and (relX <= right) and (relY >= top) and (relY <= bottom) then
			local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
			local itemType = hVar.tab_item[itemID].type
			local itemLv = hVar.tab_item[itemID].itemLv or 1 --道具等级
			
			--找到道具所在的索引位置
			local itemIdx = 0
			if (szOpType == "equipage") then --在人身上的装备
				for it = 1, hVar.HERO_EQUIP_SIZE, 1 do
					--print(it, _tTokenHero.data.equipment[it])
					if (_tTokenHero.data.equipment[it]) and (_tTokenHero.data.equipment[it] ~= 0) then
						if (_tTokenHero.data.equipment[it][1] == itemID) then
							itemIdx = it
							break
						end
					end
				end
			elseif (szOpType == "playerbag") then --背包的道具
				local BAG_PGAE_NUM = hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()] --玩家当前的背包页数
				local MAXNUM = BAG_PGAE_NUM * 4 * 7
				for it = 1, MAXNUM, 1 do
					if (Save_PlayerData.bag[it] == oItem) then
						itemIdx = it
						break
					end
				end
			end
			
			--找到该装备
			local oItem = nil
			if (szOpType == "equipage") then --人身上的装备
				--删除英雄装备存档
				local saveHeroData = hApi.GetHeroCardById(_tTokenHero.data.id)
				--saveHeroData.equipment[itemIdx] = 0
				oItem = saveHeroData.equipment[itemIdx]
			elseif (szOpType == "playerbag") then --背包的道具
				--删除背包道具存档
				--Save_PlayerData.bag[itemIdx] = 0
				oItem = Save_PlayerData.bag[itemIdx]
			end
			
			--红装、橙装不能出售
			if (not hVar.ITEM_ENABLE_SELL[itemLv]) then --不能出售的
				hGlobal.UI.MsgBox("红装、橙装不能出售！", {
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
			else --可以出售
				--统计出售的总积分获得
				local sellJiFen = itemLv * 10
				
				--弹框，告知是否要出售
				local MsgSelections = nil
				MsgSelections = {
					style = "mini",
					select = 0,
					
					--确认出售的流程
					ok = function()
						--删除该道具
						if (szOpType == "equipage") then --人身上的装备
							--删除英雄装备存档
							local saveHeroData = hApi.GetHeroCardById(_tTokenHero.data.id)
							saveHeroData.equipment[itemIdx] = 0
						elseif (szOpType == "playerbag") then --背包的道具
							--删除背包道具存档
							Save_PlayerData.bag[itemIdx] = 0
						end
						
						--获得出售的积分
						LuaAddPlayerScore(sellJiFen)
						
						--存储存档
						--保存存档
						if (szOpType == "equipage") then
							LuaSaveHeroCard()
						end
						LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
						
						--播放出售音效
						hApi.PlaySound("pay_gold")
						
						--触发事件：出售道具
						hGlobal.event:event("Local_Event_ItemSell_Result")
						
						--更新界面
						_tTokenHero:load(_tTokenHero.data.id, 1)
					end,
					cancel = function()
						--print("cancel")
					end,
					--cancelFun = cancelCallback, --点否的回调函数
					--textOk = "跳过引导",
					textCancel = hVar.tab_string["__TEXT_Cancel"],
					userflag = 0, --用户的标记
				}
				local itemName = hVar.tab_stringI[itemID] and hVar.tab_stringI[itemID][1] or ("未知道具" .. itemID)
				local showTitle = "出售：" .. itemName .. "\n获得积分：" .. sellJiFen
				local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
			end
		end
	end
	
	--检测参数表数据项全都是 表结构
	local _checkTabDataAllT = function(tab) 
		for i = 1,#tab do
			if type(tab[i]) ~= "table" then
				return 0
			end
		end
		return 1
	end

	local _equipage = {{}}
	for i = 1,hVar.HERO_EQUIP_SIZE do
		_equipage[i] = 0
	end
	
	--装备栏
	_childUI["equipage"] = hUI.bagGrid:new({
		parent = _parent,
		tab = hVar.tab_item,
		tabModelKey = "icon",
		animation = function(id,model,gridX,gridY)
			return hApi.animationByFacing(model,"stand",0)
		end,
		align = "MC",
		grid = _equipage,
		gridPos = hVar.NEW_EQUIPAGE_POS,
		iconBGKey = "BG_",
		item = {},
		slot = 0,--{model = "UI_frm:slot",animation = "lightSlim"},
		num = 0,
		gridW = 64,
		gridH = 64,
		iconW = 48,
		iconH = 48,
		pickX = -20,
		pickY = 20,
		smartWH = 1,
		
		--按下装备栏的事件
		codeOnItemSelect = function(self,item,relX,relY,gridX,gridY)
			local bagI = gridX + 1
			_BGF_PickOprItem(self,gridX,gridY,bagI)
			
			--创建提示装备出售的闪烁的边框
			_childUI["remarkSellImage"] = hUI.button:new({
				parent = _parent,
				model = "misc/y_mask_16.png", --"UI:Tactic_Selected",
				x = 720,
				y = -507,
				w = 256,
				h = 78,
			})
			_childUI["remarkSellImage"].handle.s:setOpacity(64)
			local act1 = CCFadeTo:create(1.0, 168)
			local act2 = CCFadeTo:create(1.0, 64)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_childUI["remarkSellImage"].handle.s:runAction(CCRepeatForever:create(sequence))
		end,
		
		--抬起装备栏的事件
		codeOnItemDrop = function(self,item,relX,relY,screenX,screenY,Sprite)
			--删除提示装备出售的闪烁的边框
			hApi.safeRemoveT(_childUI, "remarkSellImage")
			
			_BGF_DrawOprItemIconBG(self,item[1],nil,nil,Sprite)
			local oUnit = hApi.GetObjectEx(hClass.unit,_oCurUnit)
			local oHero = hApi.GetObjectEx(hClass.hero,_oCurHero)
			local oItem = _BGF_GetOprItem()
			if _can_use_grid == 1 then
				if oItem==nil then
				--物品非法则什么都不做
				elseif _BGF_OprItemToUse(self,oUnit,oHero,oItem,relX,relY, nil, nil, nil, "equipage")  then
					--判断下是否使用了该物品(或者丢到了自己的格子上)
				elseif _BGF_OprItemMoveToEquip(self,oUnit,oHero,oItem,relX,relY) then
					--判断下是否装备了该物品
				elseif _BGF_OprItemMoveToPlayerBag(self,oUnit,oHero,oItem,relX,relY)  then
					--判断下有没有往玩家里放
				elseif _BGF_OprItemMoveToRecycleBin(self,oUnit,oHero,oItem,relX,relY, "equipage")  then
					--判断下有没有往回收站（出售）里放
					
				end
			elseif _can_use_grid == 2 then
				if oItem==nil then
					--物品非法则什么都不做
				elseif _BGF_OprItemToUse(self,oUnit,oHero,oItem,relX,relY, nil, nil, nil, "equipage") then
				end
			end
			
		end,
		codeOnImageCreate = function(self,id,sprite,gx,gy)
			_BGF_DrawOprItemIconBG(self,id,gx,gy,sprite)
		end,
		codeOnAutoRelease = {_frm},
	})
	_gridList[#_gridList + 1] = _childUI["equipage"]
	
	local _playerbag = {{},{},{},{},{},{},{}}
	for i = 1, hVar.PLAYERBAG_X_NUM, 1 do
		for j = 1, hVar.PLAYERBAG_Y_NUM, 1 do
			_playerbag[j][i] = 1
		end
	end
	
	--玩家grid 可以互相拖动
	_childUI["playerbag"] = hUI.bagGrid:new({
		parent = _parent,
		tab = hVar.tab_item,
		tabModelKey = "icon",
		animation = function(id,model,gridX,gridY)
			return hApi.animationByFacing(model,"stand",0)
		end,
		align = "MC",
		grid = _playerbag,
		gridPos = hVar.NEW_PLAYERBAG_POS,
		iconBGKey = "BG_",
		item = {},
		slot = 0,--{model = "UI_frm:slot",animation = "lightSlim"},
		num = 0,
		gridW = 64,
		gridH = 64,
		iconW = 48,
		iconH = 48,
		pickX = -20,
		pickY = 20,
		smartWH = 1,
		codeOnItemSelect = function(self,item,relX,relY,gridX,gridY)
			--geyachao: 点击背包栏后，装备对应的位置高亮
			local itemID = item[hVar.ITEM_DATA_INDEX.ID]
			local itemType = hVar.tab_item[itemID].type
			local idx = nil
			if (itemType == hVar.ITEM_TYPE.WEAPON) then --武器
				idx = 1
			elseif (itemType == hVar.ITEM_TYPE.BODY) then --防具
				idx = 2
			elseif (itemType == hVar.ITEM_TYPE.ORNAMENTS) then --宝物
				idx = 4
			elseif (itemType == hVar.ITEM_TYPE.MOUNT) then --马
				idx = 3
			end
			
			--是装备
			if idx then
				local px = hVar.NEW_EQUIPAGE_POS[1][idx][1]
				local py = hVar.NEW_EQUIPAGE_POS[1][idx][2]
				
				--创建提示装备位置的闪烁的边框
				_childUI["remarkPosImage"] = hUI.button:new({
					parent = _parent,
					model = "UI:Tactic_Selected",
					x = px,
					y = py,
					w = 64,
					h = 64,
				})
				_childUI["remarkPosImage"].handle.s:setOpacity(64)
				local act1 = CCFadeTo:create(1.0, 168)
				local act2 = CCFadeTo:create(1.0, 64)
				local sequence = CCSequence:createWithTwoActions(act1, act2)
				_childUI["remarkPosImage"].handle.s:runAction(CCRepeatForever:create(sequence))
				--
				--[[
				local decal, count = 11, 0 --光晕效果
				local r, g, b = 75, 64, 32
				local parent = _childUI["remarkPosImage"].handle._n
				local offsetX, offsetY, duration, scale = 0, 0, 0.7, 1.08
				local nnn = xlAddNormalLightEffect(decal, count, offsetX, offsetY, duration, scale, r, g, b, parent)
				nnn:setScale(2.2)
				]]
			end
			--print("codeOnItemSelect", item,relX,relY,gridX,gridY)
			local bagI = hApi.PlayerBagItemGrid2Index(gridX, gridY, _playerBag_table_state)--item[3] + (_playerBag_table_state-1)*16
			_BGF_PickOprItem(self,gridX,gridY,bagI)
			
			
			--创建提示装备出售的闪烁的边框
			_childUI["remarkSellImage"] = hUI.button:new({
				parent = _parent,
				model = "misc/y_mask_16.png", --"UI:Tactic_Selected",
				x = 720,
				y = -507,
				w = 256,
				h = 78,
			})
			_childUI["remarkSellImage"].handle.s:setOpacity(64)
			local act1 = CCFadeTo:create(1.0, 168)
			local act2 = CCFadeTo:create(1.0, 64)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_childUI["remarkSellImage"].handle.s:runAction(CCRepeatForever:create(sequence))
		end,
		
		--抬起背包控件事件
		codeOnItemDrop = function(self,item,relX,relY,screenX,screenY,Sprite)
			--print("codeOnItemDrop", item,relX,relY,screenX,screenY,Sprite)
			--删除提示装备位置的闪烁的边框
			hApi.safeRemoveT(_childUI, "remarkPosImage")
			
			--删除提示装备出售的闪烁的边框
			hApi.safeRemoveT(_childUI, "remarkSellImage")
			
			_BGF_DrawOprItemIconBG(self,item[1])
			local oUnit = hApi.GetObjectEx(hClass.unit,_oCurUnit)
			local oHero = hApi.GetObjectEx(hClass.hero,_oCurHero)
			local oItem = _BGF_GetOprItem()
			--print("oItem=", oItem and oItem[1])
			if _can_use_grid == 1 then
				if oItem==nil then
					--物品非法则什么都不做
				elseif _BGF_OprItemToUse(self,oUnit,(oHero or _tTokenHero),oItem,relX,relY,550,660,380, "playerbag")  then
					--判断下是否使用了该物品(或者丢到了自己的格子上)
					--print("A判断下是否使用了该物品(或者丢到了自己的格子上)")
				elseif _BGF_OprItemMoveToEquip(self,oUnit,oHero,oItem,relX,relY)  then
					--判断下是否装备了该物品
					--print("B判断下是否装备了该物品")
				elseif _BGF_OprItemMoveToPlayerBag(self,oUnit,oHero,oItem,relX,relY)  then
					--判断下有没有往玩家背包里放
					--print("C判断下有没有往玩家背包里放")
				elseif _BGF_OprItemMoveToRecycleBin(self,oUnit,oHero,oItem,relX,relY, "playerbag")  then
					--判断下有没有往回收站（出售）里放
				end
			elseif _can_use_grid == 2 then
				if oItem==nil then
					--物品非法则什么都不做
				elseif _BGF_OprItemToUse(self,oUnit,oHero,oItem,relX,relY, nil, nil, nil, "playerbag") then
				end
			end
		end,
		codeOnImageCreate = function(self,id,sprite,gx,gy)
			--print("codeOnImageCreate", id,sprite,gx,gy)
			_BGF_DrawOprItemIconBG(self,id,gx,gy)
		end,
		codeOnAutoRelease = {_frm},
	})
	_gridList[#_gridList + 1] = _childUI["playerbag"]
	
	--背包向下翻页按钮
	_childUI["playerbag_table_R"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 873 + 20,
		y = -355,
		w = 40 + 40,
		h = 150,
		scaleT = 0.98,
		dragbox = _frm.childUI["dragBox"],
		code = function()
			--页数加1
			if (_playerBag_table_state < hVar.VIP_BAG_LEN[LuaGetPlayerVipLv()]) then
				_playerBag_table_state = _playerBag_table_state + 1
				_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(255, 255, 255)) --亮掉
				if _playerBag_table_state == hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()] then
					_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
				end
			end
			_childUI["playbag_current_page"]:setText(_playerBag_table_state.."/"..hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()])
			_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		end,
	})
	_childUI["playerbag_table_R"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--翻页按钮下图片
	_childUI["playerbag_table_R"].childUI["image"] = hUI.image:new({
		parent = _childUI["playerbag_table_R"].handle._n,
		model = "UI:playerBagD",
		x = -20,
		y = 40,
		scale = 1.0,
	})
	
	--背包向上翻页按钮
	_childUI["playerbag_table_L"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 873 + 20,
		y = -195,
		w = 40 + 40,
		h = 150,
		scaleT = 0.98,
		dragbox = _frm.childUI["dragBox"],
		code = function()
			--页数减1
			if (_playerBag_table_state > 1) then
				_playerBag_table_state = _playerBag_table_state - 1
				_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(255, 255, 255)) --亮掉
				--当翻至第一页时 变为不可点击
				if (_playerBag_table_state == 1) then
					_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
				end
			end
			_childUI["playbag_current_page"]:setText(_playerBag_table_state.."/"..hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()])
			_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		end,
	})
	_childUI["playerbag_table_L"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--翻页按钮上图片
	_childUI["playerbag_table_L"].childUI["image"] = hUI.image:new({
		parent = _childUI["playerbag_table_L"].handle._n,
		model = "UI:playerBagD",
		x = -20,
		y = -40,
		scale = 1.0,
	})
	_childUI["playerbag_table_L"].childUI["image"] .handle.s:setFlipX(true)
	_childUI["playerbag_table_L"].childUI["image"] .handle._n:setRotation(180)
	
	--翻页按钮当前的页号
	_childUI["playbag_current_page"] = hUI.label:new({
		parent = _parent,
		size = 26,
		font = hVar.DEFAULT_FONT,
		align = "MT",
		x = 873,
		y = -260,
		width = 300,
		text = _playerBag_table_state.."/"..hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()],
	})
	_childUI["playbag_current_page"].handle._n:setVisible(false)

	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	if (g_phone_mode ~= 0) then
		closeDx = 0
		closeDy = -20
	end
	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		--x = _w - 20,
		x = _w + closeDx,
		y = closeDy,
		z = 5,
		scaleT = 0.95,
		code = function(self)
			_frm:show(0)
			hApi.safeRemoveT(_childUI,"HeroInfoiconImg")
			--hApi.safeRemoveT(_childUI,"HeroInfoiconImg_mask")
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			hGlobal.event:event("LocalEvent_Phone_ShowMyHerocar")
		end,
	})
	
	--新功能控制是否显示网络宝箱的函数
	local _showNetChestUI
	
	--显示英雄详细信息
	hGlobal.event:listen("LocalEvent_showHeroCardFrm","newHeroCardNewFrm",function(oHero,nHeroId,mapbag,can_use_grid,isAtcive)
		if g_editor == 1 then return end
		_can_use_grid = can_use_grid or 1
		local oHeroToUpdate
		local tabU,tAttr
		local tBag,tEquip
		local NExp,CExp,MExp,LExp  = 0,0,0,0
		
		local _HeroOffX = 0
		local _HeroOffY = -0
		
		if type(oHero) == "table" then
			_HCF_CurrentMode = 1
			_nCurHeroCardID = oHero.data.id
			oHeroToUpdate = oHero
			NExp,CExp,MExp,LExp = oHero:getexp()
			hApi.SetObjectEx(_oCurHero,oHero)
			hApi.SetObjectEx(_oCurUnit,oHero:getunit())
		elseif type(nHeroId) == "number" then
			_HCF_CurrentMode = 2
			_nCurHeroCardID = nHeroId
			oHeroToUpdate = _tTokenHero
			_tTokenHero:load(_nCurHeroCardID,0)
			NExp,CExp,MExp,LExp = hClass.hero.getexp(_tTokenHero)
			hApi.SetObjectEx(_oCurHero,nil)
			hApi.SetObjectEx(_oCurUnit,nil)
		else
			_HCF_CurrentMode = 0
			_nCurHeroCardID = 0
			hApi.SetObjectEx(_oCurHero,nil)
			hApi.SetObjectEx(_oCurUnit,nil)
		end
		
		_showplayerbag(true)
		
		tabU = hVar.tab_unit[_nCurHeroCardID]
		tAttr = oHeroToUpdate.attr
		tEquip = oHeroToUpdate.data.equipment
		tBag = oHeroToUpdate.data.item
		
		--_childUI["ItemBga"]:updateitem(tBag)
		_childUI["equipage"]:updateitem({})
		_childUI["equipage"]:updateitem(tEquip)
		--_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		hApi.ShowHeroBagIdx(_playerBag_table_state) --geyachao: 改为接口调用
		hGlobal.event:event("LocalEvent_Phone_SetPlayMatVal",g_curPlayerName,nil)
		
		--设置单位左上图标
		hApi.safeRemoveT(_childUI,"HeroInfoiconImg")
		_childUI["HeroInfoiconImg"] = hUI.thumbImage:new({
			parent = _parent,
			id = _nCurHeroCardID,
			mode = "portrait",
			x = 335,
			y = -137,
			w = 225,
			h = 225,
			z = 0,
		})
		
		--设置单位的经验值条
		hApi.safeRemoveT(_childUI, "barExp")
		_childUI["barExp"] = hUI.valbar:new({
			parent =  _parent,
			model = "ui/iap_item_background.png",
			x = 224,
			y = -270,
			w = 221,
			h = 16,
			back = {model = "UI:BAR_S1_ValueBar_BG", x = -2, y = 0, w = 226, h = 20},
			model = "UI:IMG_S1_ValueBar",
			v = 0,
			max = 100,
		})
		
		--设置单位的经验值文字
		hApi.safeRemoveT(_childUI, "attrExp")
		_childUI["attrExp"] = hUI.label:new({
			parent =  _parent,
			x = 334,
			y = -270 - 1, --字体有1像素的偏差
			size = 16,
			align = "MC",
			--font = hVar.FONTC,
			font = "numWhite",
			text = "0/0",
			width = 500,
		})
		
		
		--设置单位的等级背景图
		hApi.safeRemoveT(_childUI, "attrLevelBg")
		_childUI["attrLevelBg"] = hUI.image:new({
			parent =  _parent,
			model = "UI:MedalDarkImg",
			x = _HeroOffX + 334,
			y = _HeroOffY - 230,
			w = 226,
			h = 42,
		})
		_childUI["attrLevelBg"].handle.s:setOpacity(128)
		
		--设置单位的等级文字
		hApi.safeRemoveT(_childUI, "attrLevel")
		_childUI["attrLevel"] = hUI.label:new({
			parent = _parent,
			size = 28,
			align = "RC",
			font = "num",
			x = _HeroOffX + 334,
			y = _HeroOffY - 234,
			width = 400,
			text = "1",
		})
		--_childUI["attrLevel"].handle.s:setColor(ccc3(255, 255, 0))
		
		--设置单位的等级文字后缀
		hApi.safeRemoveT(_childUI, "attrLevelPostfix")
		_childUI["attrLevelPostfix"] = hUI.label:new({
			parent = _parent,
			size = 34,
			align = "LC",
			font = hVar.FONTC,
			x = _HeroOffX + 334 + 1,
			y = _HeroOffY - 234,
			width = 400,
			--text = "级", --language
			text = hVar.tab_string["__TEXT_ji"], --language
			border = 1,
		})
		_childUI["attrLevelPostfix"].handle.s:setColor(ccc3(255, 212, 0))
		
		--显示星级
		local star = oHeroToUpdate.attr.star
		--print(star, type(star), nHeroId)
		local soulstone = oHeroToUpdate.attr.soulstone
		local starInfo = hVar.HERO_STAR_INFO[nHeroId][star]
		local costSoulStone = starInfo.costSoulStone			--升至下一级需要灵魂石数量
		local maxLv = starInfo.maxLv					--最大等级
		
		--local tHeroAttr = 
		
		_HeroInfoNumber = {}
		--设置英雄名字
		_childUI["heroAttr"].childUI["LableName"]:setText(tostring(hVar.tab_stringU[_nCurHeroCardID][1]))
		_childUI["heroAttr"].childUI["LableName"].handle.s:setColor(ccc3(255, 255, 0))
		
		--设置等级
		_childUI["attrLevel"]:setText(tostring(tAttr.level))
		
		--设置经验
		_childUI["attrExp"]:setText(tostring(CExp.."/"..MExp))
		_childUI["barExp"]:setV(CExp, MExp)
		-----------
		--_nCurHeroCardID
		local a = hApi.GetUnitAttrsByHeroCard(_nCurHeroCardID)
		
		--设置生命
		_childUI["heroAttr"].childUI["attrHp"]:setText(tostring(a.hp_max))
		_HeroInfoNumber[#_HeroInfoNumber+1] = ""
		--设置攻击
		_childUI["heroAttr"].childUI["attrAtk"]:setText(tostring(math.floor(a.atk_min or 0).."-"..math.floor(a.atk_max or 0)))
		_HeroInfoNumber[#_HeroInfoNumber+1] = ""
		--设置物防 
		_childUI["heroAttr"].childUI["attrDef"]:setText(math.floor(a.def_physic))
		_HeroInfoNumber[#_HeroInfoNumber+1] = math.floor(a.def_physic)
		--设置法防
		_childUI["heroAttr"].childUI["attrStrType"]:setText(math.floor(a.def_magic))
		_HeroInfoNumber[#_HeroInfoNumber+1] = math.floor(a.def_magic)
		--设置速度
		_childUI["heroAttr"].childUI["attrMovePoint"]:setText(tostring(a.move_speed))
		_HeroInfoNumber[#_HeroInfoNumber+1] = tostring(a.move_speed)
		--设置攻速
		_childUI["heroAttr"].childUI["attrAtkSpeed"]:setText(a.atk_interval / 1000)
		
		_HeroInfoNumber[#_HeroInfoNumber+1] = ""
		-----------
		
		--显示星
		for i = 1, hVar.HERO_STAR_INFO.maxStarLv do
			--[[
			--geyachao: 不显示升星
			if i > star then
				_childUI["imgStar_".. tostring(i)].handle._n:setVisible(false)
			else
				_childUI["imgStar_".. tostring(i)].handle._n:setVisible(true)
			end
			]]
		end
		
		if star < hVar.HERO_STAR_INFO.maxStarLv then
			--显示星级进度条
			_childUI["barSoulStoneExp"]:setV(soulstone, costSoulStone)
			_childUI["labSoulStoneExp"]:setText(tostring(soulstone).. "/".. tostring(costSoulStone))
			--_childUI["btnStarLvUp"]:setstate(1)
			_childUI["btnStarLvUp"]:setstate(-1) --geyachao: 隐藏升星按钮
		else
			_childUI["barSoulStoneExp"]:setV(1, 1)
			_childUI["labSoulStoneExp"]:setText(hVar.tab_string["hero_starMax"])
			--_childUI["btnStarLvUp"]:setstate(0)
			_childUI["btnStarLvUp"]:setstate(-1) --geyachao: 隐藏升星按钮
		end
		
		--升星特效相关
		--灵魂石足够时提示发光特效
		--按钮发光
		if not starBlink1 then
			starBlink1 = xlAddGroundEffect(0,-1,0,0,1.2,0.3,255,255,0,1)
		end
		if starBlink1 then
			starBlink1:getParent():removeChild(starBlink1,false)
			_childUI["btnStarLvUp"].handle._n:addChild(starBlink1)
			if star >= hVar.HERO_STAR_INFO.maxStarLv or soulstone < costSoulStone then
				starBlink1:setVisible(false)
			else
				starBlink1:setVisible(true)
			end
		end
		
		
		--攻击类型
		local _,attackType = hApi.GetUnitAttackTypeById(_nCurHeroCardID)
		
		--技能相关
		--第一次显示的时候初始化
		_SK_SELECTED_ID = nil
		_createSkillIcon(oHeroToUpdate, _nCurHeroCardID)
		_reflashSkillIcon(oHeroToUpdate)
		
		--设置网络宝箱
		_showNetChestUI(false,"gold")
		_showNetChestUI(false,"silver")
		_showNetChestUI(false,"bronze")
		_showNetChestUI(false,"fb")
		SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)
		
		--升星
		_childUI["btnStarLvUp"].oHero = oHeroToUpdate
		
		_frm:show(1)
		isAtcive = isAtcive or 1
		if isAtcive == 1 then
			_frm:active()
		end
		
		--检测按钮是否可用
		local currentIdx = 0
		for i = 1, #Save_PlayerData.herocard, 1 do
			if (Save_PlayerData.herocard[i].id == _tTokenHero.data.id) then
				currentIdx = i --找到了
				break
			end
		end
		if (currentIdx == 1) and(currentIdx == #Save_PlayerData.herocard) then --第一个英雄，也是最后一个英雄，不能向左、向右翻页
			_childUI["heroPageLeft"].childUI["img"].handle.s:setOpacity(0) --不显示向左翻页图片
			_childUI["heroPageRight"].childUI["img"].handle.s:setOpacity(0) --不显示向右翻页图片
		elseif (currentIdx == 1) then --第一个英雄，能向左翻页
			_childUI["heroPageLeft"].childUI["img"].handle.s:setOpacity(224) --提示左翻页图片透明度为224
			_childUI["heroPageRight"].childUI["img"].handle.s:setOpacity(224) --提示右翻页图片透明度为224
		elseif (currentIdx == #Save_PlayerData.herocard) then --最后一个英雄，能向右翻页
			_childUI["heroPageLeft"].childUI["img"].handle.s:setOpacity(224) --提示左翻页图片透明度为224
			_childUI["heroPageRight"].childUI["img"].handle.s:setOpacity(224) --提示右翻页图片透明度为224
		else --都可以翻页
			_childUI["heroPageLeft"].childUI["img"].handle.s:setOpacity(224) --提示左翻页图片透明度为224
			_childUI["heroPageRight"].childUI["img"].handle.s:setOpacity(224) --提示右翻页图片透明度为224
		end
		
		--游戏外打开商店界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	end)
	
	--显示指定的英雄界面背包分页
	hApi.ShowHeroBagIdx = function(bagIdx)
		_playerBag_table_state = bagIdx
		_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		_childUI["playbag_current_page"]:setText(_playerBag_table_state.."/"..hVar.VIP_BAG_LEN [LuaGetPlayerVipLv()])
		
		--翻页按钮
		if (_playerBag_table_state > 1) then
			_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(255, 255, 255)) --亮掉
		else
			_childUI["playerbag_table_L"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
		end
		
		if (_playerBag_table_state < hVar.VIP_BAG_LEN[LuaGetPlayerVipLv()]) then
			_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(255, 255, 255)) --亮掉
		else
			_childUI["playerbag_table_R"].childUI["image"].handle.s:setColor(ccc3(128, 128, 128)) --灰掉
		end
	end
	
	--拾取道具后的监听
	hGlobal.event:listen("Event_HeroGetItem","__newPhoneHeroGetItem",function(oHero,gridIndex,itemID,mode)
		if _frm.data.show==1 and oHero==hApi.GetObjectEx(hClass.hero,_oCurHero) then
			if mode == "item" then
				--_childUI["ItemBga"]:updateitem(oHero.data.item)
				
			elseif mode == "equipment" then
				_childUI["equipage"]:updateitem(oHero.data.equipment)
				
			end
		end
	end)
	
	--交换道具后的监听
	hGlobal.event:listen("Event_HeroSortItem","__newPhoneHeroSortItem",function(oHero,IsUpdateAttr,ByWhatOperate)
		if _frm.data.show==1 and (oHero==hApi.GetObjectEx(hClass.hero,_oCurHero) or oHero == _tTokenHero) then
			--交换或道具的话，刷新道具栏(交换和是同一个operate)
			if ByWhatOperate==hVar.OPERATE_TYPE.HERO_SORTITEM then
				_childUI["equipage"]:updateitem(oHero.data.equipment)
				--_childUI["ItemBga"]:updateitem(oHero.data.item)
				--_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
				hApi.ShowHeroBagIdx(_playerBag_table_state) --geyachao: 改为接口调用
			end
		end
	end)

	--点击技能按钮
	hGlobal.event:listen("LocalEvent_ShowSkillInfo", "__newPhoneHeroSkillInfo", function(oHero, nHeroId, idx, bType, tIdx)
		--print("点击技能按钮")
		--print(debug.traceback())
		local flag = true
		local temptext_info = ""
		local temptext_name = ""
		local skillLvUp = 0
		
		--如果是普通技能
		if (bType == 0) then
			local tSkill = {}
			local tabU = hVar.tab_unit[nHeroId]
			if tabU and tabU.talent then
				tSkill = tabU.talent
			end
			if tSkill and idx and tSkill[idx] then
				local skillId =  tSkill[idx][1]
				local skillLv = 0
				if oHero.data.talent and oHero.data.talent[idx] then
					skillLv = oHero.data.talent[idx].lv or 0
				end
				
				if hVar.tab_stringS[skillId] then
					temptext_name = hVar.tab_stringS[skillId][1] or "tab_stringS["..skillId.."] is null"
					temptext_info = hVar.tab_stringS[skillId][skillLv + 1] or ""
				else
					temptext_name = "tab_stringS["..skillId.."] is null"
					temptext_info = "this skill haven't info "..skillId
				end
				
				--刷新技能信息
				local star = oHero.attr.star
				local starInfo = hVar.HERO_STAR_INFO[star]
				local unlockSkillNum = starInfo.unlockSkillNum			--解锁技能数量
				
				--print("costInfo = hVar.SKILL_LVUP_COST[skillLv]:".. tostring(skillLv)..",".. tostring(star).. ",".. tostring(idx).. ",".. tostring(skillId))
				
				if (idx > unlockSkillNum) or (skillLv <= 0) then
					_btnSkillLvUpScore:setstate(-1) --技能升级按钮
					--_btnSkillLvUpRmb:setstate(-1)
				end
				
				skillLvUp = skillLv
			else
				flag = false
			end
		elseif (bType == 1) then --战术技能
			local tactics = hApi.GetHeroTactic(nHeroId)
			if tactics and idx and tactics[idx] and tactics[idx].id and (tactics[idx].id > 0) then
				local tacticId =  tactics[idx].id or 0
				local tacticLv = tactics[idx].lv or 1
				
				if hVar.tab_stringT[tacticId] then
					temptext_name = hVar.tab_stringT[tacticId][1] or "tab_stringT["..tacticId.."] is null"
					temptext_info = hVar.tab_stringT[tacticId][tacticLv + 1] or ""
				else
					temptext_name = "tab_stringT["..tacticId.."] is null"
					temptext_info = "this tactic haven't info "..tacticId
				end
				
				skillLvUp = tacticLv
			else
				flag = false
			end
		end
		
		if skillLvUp and (skillLvUp > 0) then
			local costRmb = 0
			local costScore = 0
			local shopItemId = hVar.SKILL_LVUP_COST[skillLvUp] or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0
			end
			
			local star = oHero.attr.star
			local starInfo = hVar.HERO_STAR_INFO[nHeroId][star]
			local maxLv = starInfo.maxLv					--等级上限
			local unlockSkillNum = starInfo.unlockSkillNum			--解锁技能数量
			
			--设置积分升级按钮
			if (skillLvUp > 0) and (skillLvUp < maxLv) and (skillLvUp < oHero.attr.level) and (LuaGetPlayerScore() >= costScore) then --技能可以升级
				--_btnSkillLvUpScore:setstate(1) --技能可以升级按钮
				hApi.AddShader(_btnSkillLvUpScore.handle.s, "normal")
				hApi.AddShader(_btnSkillLvUpScore.childUI["UI_Arrow"].handle.s, "normal")
				--print("可以升级")
			else
				--_btnSkillLvUpScore:setstate(0) --技能不能升级按钮
				hApi.AddShader(_btnSkillLvUpScore.handle.s, "gray")
				hApi.AddShader(_btnSkillLvUpScore.childUI["UI_Arrow"].handle.s, "gray")
				--print("不能升级")
			end
			--_btnSkillLvUpScore.childUI["labCost"]:setText(costScore)
			
			----设置rmb升级按钮
			--if type(_cur_rmb) == "number" and _cur_rmb >= costRmb then
			--	_btnSkillLvUpRmb:setstate(1) --技能升级按钮
			--else
			--	_btnSkillLvUpRmb:setstate(0) --技能升级按钮
			--end
			--_btnSkillLvUpRmb.childUI["labCost"]:setText(costRmb)
		else
			flag = false
		end
		
		if flag then --存在技能
			--刷新技能信息
			_childUI["skillName"].handle._n:setVisible(true)
			_childUI["skillType"].handle._n:setVisible(true) --技能类型
			_childUI["skillInfo"].handle._n:setVisible(true)
			_childUI["skillCDIcon"].handle._n:setVisible(true) --技能冷却的图标
			_childUI["skillCDLabel"].handle._n:setVisible(true) --技能冷却的时间
			_childUI["skillCDSecond"].handle._n:setVisible(true) --技能冷却"秒"
			
			--设置技能名
			_childUI["skillName"]:setText(temptext_name)
			
			--设置技能类型
			if (bType == 0) then --天赋技能
				--_childUI["skillType"]:setText("自动释放") --被动技能 --language
				_childUI["skillType"]:setText(hVar.tab_string["__AutoRelease__"]) --被动技能 --language
				_childUI["skillType"].handle.s:setColor(ccc3(168, 168, 168))
				
				--如果技能释放类型是auto，说明是被动技能
				local tSkill = {}
				local tabU = hVar.tab_unit[nHeroId]
				if tabU and tabU.talent then
					tSkill = tabU.talent
				end
				if tSkill and idx and tSkill[idx] then
					local skillId =  tSkill[idx][1]
					local castType = hVar.tab_skill[skillId].cast_type
					if (castType == hVar.CAST_TYPE.NONE) or (castType == hVar.CAST_TYPE.AUTO) then --无, 自动
						_childUI["skillType"]:setText(hVar.tab_string["__PassSkil__"]) --被动技能 --language
						_childUI["skillCDIcon"].handle._n:setVisible(false) --技能冷却的图标
						_childUI["skillCDLabel"].handle._n:setVisible(false) --技能冷却的时间
						_childUI["skillCDSecond"].handle._n:setVisible(false) --技能冷却"秒"
					end
				end
			elseif (bType == 1) then --战术技能
				--_childUI["skillType"]:setText("战术技能") --language
				_childUI["skillType"]:setText(hVar.tab_string["__MAStERY__"]) --language
				_childUI["skillType"].handle.s:setColor(ccc3(0, 224, 0))
			end
			
			--设置技能描述
			_childUI["skillInfo"]:setText(temptext_info)
			
			--设置技能的冷却时间
			local cdTime = 0
			if (bType == 0) then --天赋技能
				local tSkill = {}
				local tabU = hVar.tab_unit[nHeroId]
				if tabU and tabU.talent then
					tSkill = tabU.talent
				end
				if tSkill and idx and tSkill[idx] then
					cdTime = tSkill[idx][3] or 0 --读取角色表中填写的cd时间(毫秒)
					cdTime = math.ceil(cdTime / 1000) --向上取整
				end
			elseif (bType == 1) then --战术技能
				local tactics = hApi.GetHeroTactic(nHeroId)
				if tactics and idx and tactics[idx] and tactics[idx].id and (tactics[idx].id > 0) then
					local tacticId =  tactics[idx].id or 0
					local tacticLv = tactics[idx].lv or 1
					
					if hVar.tab_tactics[tacticId] and hVar.tab_tactics[tacticId].activeSkill and hVar.tab_tactics[tacticId].activeSkill.cd then
						cdTime = hVar.tab_tactics[tacticId].activeSkill.cd[tacticLv] --读取战术技能表中填写的cd时间
					end
				end
			end
			_childUI["skillCDLabel"]:setText(cdTime)
		else
			_childUI["skillName"].handle._n:setVisible(false)
			_childUI["skillType"].handle._n:setVisible(false) --技能类型
			_childUI["skillInfo"].handle._n:setVisible(false)
			_childUI["skillCDIcon"].handle._n:setVisible(false) --技能冷却的图标
			_childUI["skillCDLabel"].handle._n:setVisible(false) --技能冷却的时间
			_childUI["skillCDSecond"].handle._n:setVisible(false) --技能冷却"秒"
			
			_btnSkillLvUpScore:setstate(-1) --技能升级按钮
			--_btnSkillLvUpRmb:setstate(-1)
		end
		
		if _SK_SELECTED_ID and _SK_SELECTED_ID.tIdx and _SK_UIHandle[_SK_SELECTED_ID.tIdx] then
			_SK_UIHandle[_SK_SELECTED_ID.tIdx]["imgUpgrade"]:setVisible(false)
		end
		if tIdx and _SK_UIHandle[tIdx] then
			_SK_UIHandle[tIdx]["imgUpgrade"]:setVisible(true)
		end
		
		--重新设置当前选中
		_SK_SELECTED_ID = {idx = idx, type = bType, tIdx = tIdx}
		
		--将当前英雄信息，及选定升级的技能槽信息扔给技能按钮的临时数据
		--zhenkira 这里的做法略奇葩，但我也无能为力呐
		_btnSkillLvUpScore.oHero = oHero
		_btnSkillLvUpScore.idx = idx
		_btnSkillLvUpScore.type = bType
		_btnSkillLvUpScore.tIdx = tIdx

		_btnSkillLvUpRmb.oHero = oHero
		_btnSkillLvUpRmb.idx = idx
		_btnSkillLvUpRmb.type = bType
		_btnSkillLvUpRmb.tIdx = tIdx
	end)
	
	--技能升级（发起）
	hGlobal.event:listen("LocalEvent_SkillLevelUp", "__newPhoneskillLevelUp", function(oHero, idx, bType, btnType)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		if _tTokenHero and oHero == _tTokenHero then
			
			local nHeroId = oHero.data.id
			local tSkill = {}
			if bType == 0 then
				local tabU = hVar.tab_unit[nHeroId]
				if tabU and tabU.talent then
					tSkill = tabU.talent
				end
			elseif bType == 1 then
				tSkill = hApi.GetHeroTactic(nHeroId)
			end
			
			if tSkill and idx and tSkill[idx] then
				local skillId = 0
				local skillLv = 0
				
				if bType == 0 then
					skillId =  tSkill[idx][1]
					skillLv = 0
					if oHero.data.talent and oHero.data.talent[idx] then
						skillLv = oHero.data.talent[idx].lv or 0
					end
				elseif bType == 1 then
					local tactics = hApi.GetHeroTactic(nHeroId)
					if tactics and tactics[idx] then
						skillId =  tactics[idx].id or 0
						skillLv = tactics[idx].lv or 1
					end
				end
				
				local star = oHero.attr.star or 1
				local starInfo = hVar.HERO_STAR_INFO[nHeroId][star]
				local maxLv = starInfo.maxLv					--等级上限
				local unlockSkillNum = starInfo.unlockSkillNum			--解锁技能数量
				
				local costRmb = 0
				local costScore = 0
				local shopItemId = hVar.SKILL_LVUP_COST[skillLv] or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				local itemId = 0
				if tabShopItem then
					costRmb = tabShopItem.rmb or 0
					costScore = tabShopItem.score or 0
					itemId = tabShopItem.itemID or 0
				end
				
				if idx > unlockSkillNum or skillLv <= 0 then
					strRet = hVar.tab_string["__Attr_Have't_Skill"]
				elseif skillLv >= maxLv or skillLv >= oHero.attr.level then
					strRet = hVar.tab_string["hero_skilllevelMax"]
				else
					--local strTag = "id:".._skillID..";ml:".._conMaxLv..";lv:".._conLv..";sc:"..score..";"
					
					if "Score" == btnType then --积分
						if LuaGetPlayerScore() >= costScore then
							--hUI.NetDisable(30000)
							--发送扣费请求
							local strTag = "hi:"..nHeroId..";si:"..skillId..";st:"..bType..";sp:"..idx..";sc:"..costScore..";"
							--print(strTag)
							--SendCmdFunc["order_begin"](6,itemId,0,1,hVar.tab_stringI[itemId][1],costScore,0,strTag)
							ret = true
						else
							strRet = hVar.tab_string["__TEXT_ScoreNotEnough"]
						end
					elseif "Rmb" ==  btnType then --金币
						if type(_cur_rmb) == "number" and _cur_rmb >= costRmb then
							hUI.NetDisable(30000)
							--发送扣费请求
							local strTag = "hi:"..nHeroId..";si:"..skillId..";st:"..bType..";sp:"..idx..";sc:0;"
							SendCmdFunc["order_begin"](6,itemId,costRmb,1,hVar.tab_stringI[itemId][1],0,0,strTag)
							ret = true
						else
							strRet = hVar.tab_string["__TEXT_not_enough_money"]
						end
					end
				end
			end
		end
		
		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--只是刷新玩家仓库
	hGlobal.event:listen("Local_EventReflashPlayerBag","__reflashplayerBag",function()
		--_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		hApi.ShowHeroBagIdx(_playerBag_table_state) --geyachao: 改为接口调用
	end)
	
	local _UPDATE_HeroInfoFrm = function(oHero, flag)
		--print("_UPDATE_HeroInfoFrm", flag .. nil)
		local tAttr = oHero.attr
		if flag and (flag == "equip" or flag == "playerbag") then
			
		else
			_reflashSkillIcon(oHero)
		end
		
		local NExp,CExp,MExp  = 0,0,0
		NExp,CExp,MExp,LExp = hClass.hero.getexp(oHero)
		
		--显示星级
		local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
		local star = math.min(oHero.attr.star, maxStarLv)
		local soulstone = oHero.attr.soulstone
		local starInfo = hVar.HERO_STAR_INFO[oHero.data.id][star]
		local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
		local maxLv = starInfo.maxLv					--最大等级
		
		--设置等级
		_childUI["attrLevel"]:setText(tostring(tAttr.level))
		--设置经验
		--_childUI["heroAttr"].childUI["attrExp"]:setText(tostring(NExp.."/"..(MExp + LExp)))
		_childUI["attrExp"]:setText(tostring(CExp.."/"..MExp))
		_childUI["barExp"]:setV(CExp, MExp)
		
		-----------
		--geyachao: 获得角色的属性列表
		--oHero.data.id
		local a = hApi.GetUnitAttrsByHeroCard(oHero.data.id)
		--设置生命
		_childUI["heroAttr"].childUI["attrHp"]:setText(tostring(a.hp_max))
		_HeroInfoNumber[1] = tostring(a.hp_max)
		--设置攻击
		_childUI["heroAttr"].childUI["attrAtk"]:setText(tostring(math.floor(a.atk_min or 0).."-"..math.floor(a.atk_max or 0)))
		local tt = {}
		tt[#tt+1] = tostring(math.floor(a.atk_min or 0).."-"..math.floor(a.atk_max or 0))
		tt[#tt+1] = hVar.tab_string["__Attr_Hint_crit_rate"] .. ": " .. (a.crit_rate or 0) .. "%" --"暴击几率"
		tt[#tt+1] = hVar.tab_string["__Attr_Hint_crit_value"] .. ": " .. (a.crit_value or 0) --"暴击倍数"
		_HeroInfoNumber[2] = tt
		--设置物防 
		_childUI["heroAttr"].childUI["attrDef"]:setText(math.floor(a.def_physic))
		_HeroInfoNumber[3] = math.floor(a.def_physic)
		--设置法防 
		_childUI["heroAttr"].childUI["attrStrType"]:setText(math.floor(a.def_magic))
		_HeroInfoNumber[4] = math.floor(a.def_magic)
		--设置速度
		_childUI["heroAttr"].childUI["attrMovePoint"]:setText(tostring(a.move_speed))
		_HeroInfoNumber[5] = tostring(a.move_speed)
		--设置攻速
		_childUI["heroAttr"].childUI["attrAtkSpeed"]:setText(string.format("%.2f", a.atk_interval / 1000))
		
		_HeroInfoNumber[6] = string.format("%.2f", a.atk_interval / 1000)
		-----------
		
		--显示星
		for i = 1, hVar.HERO_STAR_INFO.maxStarLv do
			
			--geyachao: 不显示升星
			if (i > star) then
				_childUI["imgStar_".. tostring(i)].handle.s:setVisible(false) --不显示
			else
				_childUI["imgStar_".. tostring(i)].handle.s:setVisible(true) --显示
			end
			
		end
		
		if (star < hVar.HERO_STAR_INFO.maxStarLv) then
			--显示星级进度条
			_childUI["labSoulStoneExp"]:setText(soulstone .. "/" .. costSoulStone)
			--_childUI["btnStarLvUp"]:setstate(1)
			_childUI["btnStarLvUp"]:setstate(-1) --geyachao: 不显示升星
		else
			_childUI["labSoulStoneExp"]:setText(soulstone .. "/" .. costSoulStone)
			--_childUI["btnStarLvUp"]:setstate(0)
			_childUI["btnStarLvUp"]:setstate(-1) --geyachao: 不显示升星
		end
		
		--升星特效相关
		--将魂足够时提示发光特效
		--按钮发光
		if not starBlink1 then
			starBlink1 = xlAddGroundEffect(0,-1,0,0,1.2,0.3,255,255,0,1)
		end
		if starBlink1 then
			starBlink1:getParent():removeChild(starBlink1,false)
			_childUI["btnStarLvUp"].handle._n:addChild(starBlink1)
			if star >= hVar.HERO_STAR_INFO.maxStarLv or soulstone < costSoulStone then
				starBlink1:setVisible(false)
			else
				starBlink1:setVisible(true)
			end
		end
	end
	
	--得经验监听
	hGlobal.event:listen("Local_EventHeroGetExp","__newINFOFRM__PhoneHeroGetExp",function(oHero)
		if _frm.data.show==1 and oHero==hApi.GetObjectEx(hClass.hero,_oCurHero) then
			local tAttr = oHero.attr
			--设置经验等级
			_childUI["attrLevel"]:setText(tostring(tAttr.level))
			local _,CExp,MExp = oHero:getexp()
			--_childUI["heroAttr"].childUI["attrExp"]:setText(tostring(CExp.."/"..MExp))
			--_childUI["heroAttr"].childUI["barExp"]:setV(CExp,MExp)
			_childUI["attrExp"]:setText(tostring(CExp.."/"..MExp))
			_childUI["barExp"]:setV(CExp,MExp)
		end
	end)
	
	--升级监听
	hGlobal.event:listen("Event_HeroLevelUp","__newINFOFRM__PhoneHeroLevelUp",function(oHero)
		if _frm.data.show==1 and oHero==hApi.GetObjectEx(hClass.hero,_oCurHero) then
			--英雄无敌模式下，需要重新刷新装备栏中的道具图标
			if oHero.data.playmode==1 then
				_childUI["equipage"]:updateitem({})
				_childUI["equipage"]:updateitem(oHero.data.equipment)
			end
			_UPDATE_HeroInfoFrm(oHero)
		end
	end)
	
	--英雄交换道具后的监听
	hGlobal.event:listen("Event_HeroSortItem","__newINFOFRM__PhoneHeroSetEquipment",function(oHero,IsUpdateAttr,ByWhatOperate)
		if _frm.data.show==1 and (oHero==hApi.GetObjectEx(hClass.hero,_oCurHero) or oHero == _tTokenHero) then
			if IsUpdateAttr==1 then
				_UPDATE_HeroInfoFrm(oHero, "equip")
			end
			--在大厅界面需要重新load否则在没有游戏世界时 英雄属性不刷新 而且技能点亮不现实 但是在游戏里 不能 这么做 否则会导致 访问的属性不生效
			if _tTokenHero and  g_current_scene ~= g_world then 
				_tTokenHero:load(_nCurHeroCardID,1, "equip")
			end
		end
	end)

	--刷新卡片
	hGlobal.event:listen("LocalEvent_RefreshHeroInfoByCard","__newPhoneRefreshHeroInfo",function(tTokenHero, flag)
		_UPDATE_HeroInfoFrm(tTokenHero, flag)
		_childUI["equipage"]:updateitem(tTokenHero.data.equipment)
		--_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
		hApi.ShowHeroBagIdx(_playerBag_table_state) --geyachao: 改为接口调用
	end)
	
	--为了解决效率问题 非 3 4 级道具不走订单系统
	--hGlobal.event:listen("LocalEvent_order_forge_lv12","forge12",function()
	--	local u = hApi.GetObjectEx(hClass.unit,_oCurUnit)
	--	local oHero = nil
	--	if u then
	--		oHero = u:gethero()
	--	end
	--	hApi.ForgeItem((oHero or _tTokenHero),{_forgedbaglist.from,_forgedbaglist.fromIndex})
	--end)
	
	--订单系统锻造命令的返回值
	--hGlobal.event:listen("LocalEvent_order_forge","_newSetCheatVal_rs",function(cheat_fc,tag,tradeid)
	--	if tag ~= 1 then return end
	--	LuaSetForgeCount(cheat_fc)
	--	--SendCmdFunc["send_forged_finish"](luaGetplayerDataID(),tag,tradeid,"",3,tostring("LC:"..LuaGetForgeCount().."-SC:"..cheat_fc))
	--	SendCmdFunc["order_update"](tradeid,1,tostring("LC:"..LuaGetForgeCount().."-SC:"..cheat_fc))
	--	--SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),1,"cheat_fc",LuaGetForgeCount())
	--	local u = hApi.GetObjectEx(hClass.unit,_oCurUnit)
	--	local oHero = nil
	--	if u then
	--		oHero = u:gethero()
	--	end
	--	hApi.ForgeItem((oHero or _tTokenHero),{_forgedbaglist.from,_forgedbaglist.fromIndex},tradeid)
	--end)

	--星级提升
	hGlobal.event:listen("LocalEvent_StarLevelUp","__newPhoneHeroStarUp",function(oHero)

		local ret = false
		local strRet = hVar.tab_string["hero_lessSoulstone"]
		
		local nHeroId = oHero.data.id
		if _tTokenHero and oHero == _tTokenHero then
			local abc = 0
			while(1) do
				--判断星级
				local tHeroCard = hApi.GetHeroCardById(nHeroId)
				--英雄卡不存在返回失败
				if not tHeroCard then
					abc = 1
					break
				end

				local star = tHeroCard.attr.star
				local soulstone = LuaGetHeroCardSoulStone(nHeroId)
				
				--星级已经大于当前设定的最大等级，返回失败
				if star >= hVar.HERO_STAR_INFO.maxStarLv then
					abc = 2
					break
				end

				local starInfo = hVar.HERO_STAR_INFO[star]
				local costSoulStone = starInfo.costSoulStone			--升至下一级需要灵魂石数量
				
				--如果当前灵魂石小于需要消耗的灵魂石，返回失败
				if soulstone < costSoulStone then
					abc = 3
					break
				end
				
				local starNow = tHeroCard.attr.star + 1
				local talent = tHeroCard.talent
				if not talent then
					abc = 4
					break
				end
				
				local skillObj = talent[starNow]
				if skillObj and skillObj.id then
					skillObj.lv = 1
				else
					local tabU = hVar.tab_unit[nHeroId]
					--tab_unit非法
					if not tabU then
						abc = 5
						break
					end
					local talentU = tabU.talent
					--tab_unit没有talent
					if not talentU then
						abc = 6
						break
					end
				end
				abc = 7
				ret = true
				break
			end
			
			----发送升星请求
			if ret then
				
				local tHeroCard = hApi.GetHeroCardById(nHeroId)
				local star = tHeroCard.attr.star
				local starInfo = hVar.HERO_STAR_INFO[star]
				local shopItemId = starInfo.shopItemId
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				local itemId = 0
				if tabShopItem then
					itemId = tabShopItem.itemID or 0
				end

				hUI.NetDisable(30000)
				local strTag = "hi:"..nHeroId..";"
				SendCmdFunc["order_begin"](6,itemId,0,1,hVar.tab_stringI[itemId][1],0,0,strTag)

			else
				strRet = hVar.tab_string["["]..tostring(hVar.tab_stringU[nHeroId][1])..hVar.tab_string["]"]..strRet
			end
		end

		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)

	-- 新功能 网络宝箱 
	--黄金宝箱按钮
	local ITEM_BAG_OFFSET_X = 657 --道具背包统一偏移x
	local ITEM_BAG_OFFSET_Y = -116 --道具背包统一偏移y
	_childUI["net_depletion_gold"] = hUI.button:new({
		parent = _frm,
		model = "icon/item/random_lv3.png",
		x = ITEM_BAG_OFFSET_X - 34,
		y = ITEM_BAG_OFFSET_Y + 74,
		w = 48,
		h = 48,
		scaleT = 0.95,
		code = function(self)
			self:setstate(0)
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			elseif g_cur_net_state == 1 then
				if LuaCheckPlayerBagCanUse() == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
						font = hVar.FONTC,
						ok = function()
							
						end,
					})
					self:setstate(1)
					return
				end
				local num = tonumber(_childUI["net_depletion_gold_lab"].data.text)
				if num and num > 0 then
					--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9006,hVar.tab_stringI[9006][1])
					SendCmdFunc["order_begin"](4,9006,0,1,hVar.tab_stringI[9006][1],0,0,nil)
				end
			end
		end,
	})
	
	_childUI["net_depletion_gold_lab"] = hUI.label:new({
		parent = _parent,
		size = 16,
		align = "MC",
		font = "numWhite",
		x = ITEM_BAG_OFFSET_X - 34 + 20,
		y = ITEM_BAG_OFFSET_Y + 74 - 22,
		width = 100,
		text = "0",
	})
	
	--白银宝箱按钮
	_childUI["net_depletion_silver"] = hUI.button:new({
		parent = _frm,
		model = "icon/item/random_lv2.png",
		x = ITEM_BAG_OFFSET_X + 31,
		y = ITEM_BAG_OFFSET_Y + 74,
		w = 48,
		h = 48,
		scaleT = 0.95,
		code = function(self)
			self:setstate(0)
			
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			elseif g_cur_net_state == 1 then
				if LuaCheckPlayerBagCanUse() == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
						font = hVar.FONTC,
						ok = function()
							
						end,
					})
					
					self:setstate(1)
					return
				end
				local num = tonumber(_childUI["net_depletion_silver_lab"].data.text)
				if num and num > 0 then
					--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9005,hVar.tab_stringI[9005][1])
					SendCmdFunc["order_begin"](4,9005,0,1,hVar.tab_stringI[9005][1],0,0,nil)
				end
			end
		end,
	})
	
	_childUI["net_depletion_silver_lab"] = hUI.label:new({
		parent = _parent,
		size = 16,
		align = "MC",
		font = "numWhite",
		x = ITEM_BAG_OFFSET_X + 31 + 20,
		y = ITEM_BAG_OFFSET_Y + 74 - 22,
		width = 100,
		text = "0",
	})
	
	--青铜宝箱按钮
	_childUI["net_depletion_bronze"] = hUI.button:new({
		parent = _frm,
		model = "icon/item/random_lv1.png",
		x = ITEM_BAG_OFFSET_X + 96,
		y = ITEM_BAG_OFFSET_Y + 74,
		w = 48,
		h = 48,
		scaleT = 0.95,
		code = function(self)
			self:setstate(0)
			
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion_Net"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			elseif g_cur_net_state == 1 then
				if LuaCheckPlayerBagCanUse() == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL2"],{
						font = hVar.FONTC,
						ok = function()
							
						end,
					})
					
					self:setstate(1)
					return
				end
				local num = tonumber(_childUI["net_depletion_bronze_lab"].data.text)
				if num and num > 0 then
					--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),4,9004,hVar.tab_stringI[9004][1])
					SendCmdFunc["order_begin"](4,9004,0,1,hVar.tab_stringI[9004][1],0,0,nil)
				end
			end
		end,
		
	})
	
	_childUI["net_depletion_bronze_lab"] = hUI.label:new({
		parent = _parent,
		size = 16,
		align = "MC",
		font = "numWhite",
		x = ITEM_BAG_OFFSET_X + 96 + 20,
		y = ITEM_BAG_OFFSET_Y + 74 - 22,
		width = 100,
		text = "0",
	})
	
	--装备获取令
	_childUI["net_depletion_fb"] = hUI.button:new({
		parent = _frm,
		model = "ICON:BF",
		x = ITEM_BAG_OFFSET_X + 160,
		y = ITEM_BAG_OFFSET_Y + 70,
		scaleT = 0.95,
		scale = 0.9,
		code = function(self)
			self:setstate(0)
			if g_cur_net_state == -1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion2_Net"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			elseif g_cur_net_state == 1 then
				if LuaCheckPlayerBagCanUse() == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL3"],{
						font = hVar.FONTC,
						ok = function()
							
						end,
					})
					self:setstate(1)
					return
				end
				local num = tonumber(_childUI["net_depletion_fb_lab"].data.text)
				if num and num > 0 then
					hGlobal.event:event("LocalEvent_Phone_ShowHeroEquip")
					self:setstate(1)
				end
			end
		end,
	})
	
	_childUI["net_depletion_fb_lab"] = hUI.label:new({
		parent = _parent,
		size = 16,
		align = "MC",
		font = "numWhite",
		x = 839,
		y = -64,
		width = 100,
		text = "0",
	})
	
	_showNetChestUI = function(bool,mode)
		if mode == "gold" then
			if bool then
				_childUI["net_depletion_gold"]:setstate(1)
			else
				_childUI["net_depletion_gold"]:setstate(-1)
			end
			_childUI["net_depletion_gold_lab"].handle._n:setVisible(bool)
		elseif mode == "silver" then
			if bool then
				_childUI["net_depletion_silver"]:setstate(1)
			else
				_childUI["net_depletion_silver"]:setstate(-1)
			end
			_childUI["net_depletion_silver_lab"].handle._n:setVisible(bool)
		elseif mode == "bronze" then
			if bool then
				_childUI["net_depletion_bronze"]:setstate(1)
			else
				_childUI["net_depletion_bronze"]:setstate(-1)
			end
			_childUI["net_depletion_bronze_lab"].handle._n:setVisible(bool)
		elseif mode == "fb" then
			if bool then
				_childUI["net_depletion_fb"]:setstate(1)
			else
				_childUI["net_depletion_fb"]:setstate(-1)
			end
			_childUI["net_depletion_fb_lab"].handle._n:setVisible(bool)
		end
	end
	
	--使用过兑换券后的刷新
	hGlobal.event:listen("LocalEvent_setNetChest_redNum","_set_cheat_code",function(num,strTag,logid)
		--刷新显示
		_childUI["net_depletion_fb_lab"]:setText(tostring(num),1)
		
		if num <= 0 then
			_showNetChestUI(false,"fb")
		else
			_showNetChestUI(true,"fb")
		end
		
		--增加红装
		hUI.NetDisable(0)
		local itemID = tonumber(strTag)
		if type(itemID) == "number" then
			SendCmdFunc["log_heroequip_finish"](logid,1)
			hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{1},1,logid,nil,nil,{3})
			--_childUI["playerbag"]:updateitem(LuaGetPlayerBagFromTableIndex(_playerBag_table_state))
			hApi.ShowHeroBagIdx(_playerBag_table_state) --geyachao: 改为接口调用
		end
	end)
	
	--设置网络宝箱个数
	hGlobal.event:listen("LocalEvent_getNetChestNum","_getChestNum",function(NumTab)
		if type(NumTab) == "table" then
			
			_childUI["net_depletion_gold_lab"]:setText(tostring(NumTab.chest_gold),1)
			_childUI["net_depletion_silver_lab"]:setText(tostring(NumTab.chest_silver),1)
			_childUI["net_depletion_bronze_lab"]:setText(tostring(NumTab.chest_cuprum),1)
			_childUI["net_depletion_fb_lab"]:setText(tostring(NumTab.prize_code),1)

			if NumTab.chest_gold <= 0 then
				_showNetChestUI(false,"gold")
			else
				_showNetChestUI(true,"gold")
			end
			if NumTab.chest_silver <= 0 then
				_showNetChestUI(false,"silver")
			else
				_showNetChestUI(true,"silver")
			end

			if NumTab.chest_cuprum <= 0 then
				_showNetChestUI(false,"bronze")
			else
				_showNetChestUI(true,"bronze")
			end

			if NumTab.prize_code <= 0 then
				_showNetChestUI(false,"fb")
			else
				_showNetChestUI(true,"fb")
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","_setChestNum",function(connect_state)
		--如果断开网络则恢复不可使用锻造状态
		if connect_state == -1 then
			_childUI["net_depletion_gold_lab"]:setText("~",1)
			_childUI["net_depletion_silver_lab"]:setText("~",1)
			_childUI["net_depletion_bronze_lab"]:setText("~",1)
			_childUI["net_depletion_fb_lab"]:setText("~",1)
			--技能升级等状态恢复
			hUI.NetDisable(0)
		elseif connect_state == 1 and _frm.data.show == 1 then
			SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)
		end
	end)
	
	--使用各种宝箱的返回
	--hGlobal.event:listen("LocalEvent_Use_Net_chest","_uesNetChestRs",function(itemID,tradeid)
	--	local rewardlist = hApi.UseChestItem(itemID)
	--	local ResetCount = 0
	--	local ResetVal = 0
	--	if itemID == 9006 then
	--		ResetCount = 1
	--		ResetVal = 10
	--	end
	--	hGlobal.event:event("localEvent_ShowRewardExFrm",rewardlist,ResetCount,ResetVal,itemID,tradeid)
	--	
	--	
	--	_g_chest_state = 0
	--	SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)
	--end)
	
	--通过订单系统 使用各种宝箱的返回
	hGlobal.event:listen("LocalEvent_order_Use_Net_chest","_uesNetChestRs",function(itemID,tradeid)
		local rewardlist = hApi.UseChestItem(itemID)
		local ResetCount = 0
		local ResetVal = 0
		if itemID == 9006 then
			ResetCount = 1
			ResetVal = 10
		end
		hGlobal.event:event("localEvent_ShowRewardExFrm",rewardlist,ResetCount,ResetVal,itemID,tradeid)

		SendCmdFunc["get_chest_net_num"](0,luaGetplayerDataID(),0)

		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.openChest)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.openChest)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end)

	----购买失败
	hGlobal.event:listen("LocalEvent_BuyItemfail", "_herocardfrmUnlock", function(result, nItemID)
		--收到消息后解除购买锁
		--如果技能升级失败，解除按钮锁定
		--if (nItemID >= 10101 and nItemID <= 10110) or nItemID >= 10191 and nItemID <= 10200 then
			hUI.NetDisable(0)
		--end
	end)
	
	--通过订单系统 技能升级返回
	hGlobal.event:listen("localEvent_afterSkillLvUpSucceed","_heroSkillLvUp",function(overage, strTag, order_id)
		--print("localEvent_afterSkillLvUpSucceed", type(overage), type(strTag), type(order_id), overage, strTag, order_id)
		hUI.NetDisable(0)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--保留字符串 如果存在 则进行解析 这块功能必须要等外网服务器更新以后才能生效
		--local strTag = "hi:"..nHeroId..";si:"..skillId..";st:"..type..";sp:"..idx..";sc:"..costScore..";"
		if type(strTag) == "string" and string.find(strTag,"hi:") and string.find(strTag,"si:") and string.find(strTag,"st:") and string.find(strTag, "sp:") and string.find(strTag,"sc:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end
			
			--英雄Id
			local nHeroId = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"hi:")+3,string.len(tempStr[1])))
			--升级技能Id
			local skillId = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"si:")+3,string.len(tempStr[2])))
			--升级技能类型（普通技能，战术技能）
			local bType = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"st:")+3,string.len(tempStr[3])))
			--升级技能位置索引
			local idx = tonumber(string.sub(tempStr[4],string.find(tempStr[4],"sp:")+3,string.len(tempStr[4])))
			--升级积分消耗
			local cost = tonumber(string.sub(tempStr[5],string.find(tempStr[5],"sc:")+3,string.len(tempStr[5])))
			
			local retex = 0
			if bType == 0 then
				--英雄技能升级
				retex = LuaHeroSkillLevelUp(nHeroId, idx, skillId)
			elseif bType == 1 then
				--英雄战术技能升级
				retex = LuaHeroTacticLevelUp(nHeroId, idx, skillId)
			end
			if retex > 0 then
				ret = true
				--扣除积分
				LuaAddPlayerScore(-cost)
				--保存英雄
				LuaSaveHeroCard()	--这里不传参数，因为不需要保存经验
				_tTokenHero:load(nHeroId, 1)
				
				--触发事件：英雄技能升级返回
				hGlobal.event:event("Local_Event_HeroSkill_LvUp_Result", nHeroId, bType, idx, skillId)
				
				--geyachao: 只要英雄技能升级过，就认为不需要引导英雄操作界面
				--标记主城引导英雄界面完成
				LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			else
				ret = false
				if retex == -3 or retex == -4 then
					strRet = hVar.tab_string["hero_skilllevelMax"]	--走到这里说明界面中的技能对象存储的相关值，与技能卡中出现了不一致
				else
					strRet = hVar.tab_string["hero_skilllevelFalid"]
				end
			end
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end
		
		if (not ret) then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--通过订单系统 升星返回
	hGlobal.event:listen("localEvent_afterHeroStarUpSucceed","_heroStarLvUp",function(overage,strTag,order_id)
		
		hUI.NetDisable(0)
		local ret = false
		local strRet = hVar.tab_string["hero_lessSoulstone"]
		
		if type(strTag) == "string" and string.find(strTag,"hi:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end

			--英雄Id
			local nHeroId = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"hi:")+3,string.len(tempStr[1])))

			--英雄升星
			ret = LuaHeroStarLevelUp(nHeroId)

			if ret then
				--保存英雄
				LuaSaveHeroCard()	--这里不传参数，因为不需要保存经验
				--todo: 做点界面表现效果
				--重新刷新页面
				_tTokenHero:load(nHeroId,1)
			else
				strRet = hVar.tab_string["["]..tostring(hVar.tab_stringU[nHeroId][1])..hVar.tab_string["]"]..strRet
			end
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end

		if not ret then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--打开
	local _Btnlasttouchtimes = 0
	_childUI["↑↑↓↓←←→→"] = hUI.button:new({
		parent = _frm,
		model = -1,
		w = 100,
		h = 100,
		z = 10,
		x = 340,
		y = -69,
		codeOnTouch = function()
			_Btnlasttouchtimes = _Btnlasttouchtimes + 1
			if _Btnlasttouchtimes >= 10 then
				--ShowDebugWindow(1 - g_show_debug_win)
				hGlobal.event:event("LocalEvent_OpenDebugFrm")
				_Btnlasttouchtimes = 0
				--cheat01()
			end
		end,
	})
	_childUI["↑↑↓↓←←→→"].handle._n:setVisible(false)
end

--属性查看面板
hGlobal.UI.InitAttributeInfoFrm = function()
	
	local _x,_y = hVar.SCREEN.w/2 - 138,hVar.SCREEN.h/2 + 126

	hGlobal.UI.AttributeInfoFrm = hUI.frame:new({
			x = _x,
			y = _y,
			background = -1,
			dragable = 0,
			h = 0,
			w = 280,
			show = 0,
			titlebar = 0,
	})
	
	local _frm = hGlobal.UI.AttributeInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--属性名称
	_childUI["attrName_"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MT",
		font = hVar.FONTC,
		x = 150 ,
		y = -26,
		width = 160,
		text = "",
	})
	
	_childUI["attr_info"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LT",
		font = hVar.FONTC,
		x = 10 ,
		y = -120,
		width = 240,
		text = "",
	})

	local RemoveListEx = {}
	local _create_attribute_info = function(index,tab,state,HeroInfoNumber)
		for i = 1,#RemoveListEx do
			hApi.safeRemoveT(_childUI,RemoveListEx[i])
		end
		RemoveListEx = {}
		--属性图片
		_childUI["attriamge_"] = hUI.thumbImage:new({
			parent =  _parent,
			model = tab[index].icon, 
			animation = tab[index].animation or "normal",
			w = 64,
			h = 64,
			x = 44,
			y = -59,
		})
		RemoveListEx[#RemoveListEx+1] = "attriamge_"
		_childUI["attrName_"]:setText(hVar.tab_string[tab[index].name])
		
		local temptext = ""
		if state == 1 then
			temptext = hVar.tab_string[tab[index].info]
			_childUI["attr_info"]:setText(temptext)
			local _AttrInfoX,_AttrInfoY = 0,0
			_AttrInfoX = 10 + 26*((string.len(hVar.tab_string[tab[index].info])/3)%9)
			_AttrInfoY = -120 - 27*math.floor(string.len(hVar.tab_string[tab[index].info])/27)
			if index == 10 then
				_AttrInfoX = _AttrInfoX + 20
			end
		else
			temptext = hVar.tab_string[tab[index].info]
			_childUI["attr_info"]:setText(temptext)
		end

		local size = _childUI["attr_info"].handle.s:getContentSize()
		_childUI["barFuck"] = hUI.bar:new({
			parent = _parent,
			model = "UI:tip_item",
			align = "LT",
			w = _frm.data.w,
			h = size.height + 140,
			z = -1,
		})
		RemoveListEx[#RemoveListEx+1] = "barFuck"
	end
	
	--创建其他提示信息
	local _create_other_info = function(index,pamaA,pamaB)
		for i = 1,#RemoveListEx do
			hApi.safeRemoveT(_childUI,RemoveListEx[i])
		end
		RemoveListEx = {}
		
		if index == "forged" then
			--属性图片
			_childUI["attriamge_"] = hUI.image:new({
				parent =  _parent,
				model = "UI:forged_slot", 
				w = 64,
				h = 64,
				x = 44,
				y = -59,
			})
			RemoveListEx[#RemoveListEx+1] = "attriamge_"
			_childUI["attrName_"]:setText(hVar.tab_string["__TEXT_FORGED"])
			
			_childUI["attr_info"]:setText(hVar.tab_string["__TEXT_FORGED_ITP"])
			
			local size = _childUI["attr_info"].handle.s:getContentSize()
			_childUI["barFuck"] = hUI.bar:new({
				parent = _parent,
				model = "UI:tip_item",
				align = "LT",
				w = _frm.data.w,
				h = size.height + 140,
				z = -1,
			})
			RemoveListEx[#RemoveListEx+1] = "barFuck"
		elseif index == "Decompos" then
			--属性图片
			_childUI["attriamge_"] = hUI.image:new({
				parent =  _parent,
				model = "UI:card2score", 
				w = 64,
				h = 64,
				x = 44,
				y = -59,
			})
			RemoveListEx[#RemoveListEx+1] = "attriamge_"
			_childUI["attrName_"]:setText(hVar.tab_string["__TEXT_DeleteBFSCard"])
			
			_childUI["attr_info"]:setText(hVar.tab_string["__TEXT_Decompos_Tip"])
			
			local size = _childUI["attr_info"].handle.s:getContentSize()
			_childUI["barFuck"] = hUI.bar:new({
				parent = _parent,
				model = "UI:tip_item",
				align = "LT",
				w = _frm.data.w,
				h = size.height + 140,
				z = -1,
			})
			RemoveListEx[#RemoveListEx+1] = "barFuck"
		elseif index == "Stuff" then
			--属性图片
			_childUI["attriamge_"] = hUI.image:new({
				parent =  _parent,
				model = "UI:delete_slot",
				w = 64,
				h = 64,
				x = 44,
				y = -59,
			})
			RemoveListEx[#RemoveListEx+1] = "attriamge_"
			_childUI["attrName_"]:setText(hVar.tab_string["__TEXT_Stuff_Name"])

			_childUI["attr_info"]:setText(hVar.tab_string["__TEXT_Stuff_Tip"])
			
			local size = _childUI["attr_info"].handle.s:getContentSize()
			_childUI["barFuck"] = hUI.bar:new({
				parent = _parent,
				model = "UI:tip_item",
				align = "LT",
				w = _frm.data.w,
				h = size.height + 140,
				z = -1,
			})
			RemoveListEx[#RemoveListEx+1] = "barFuck"
		elseif index == "mapVar" then

			_childUI["attrName_"]:setText(hVar.tab_string[pamaA])

			_childUI["attr_info"]:setText(hVar.tab_string[pamaB])

			local size = _childUI["attr_info"].handle.s:getContentSize()
			_childUI["barFuck"] = hUI.bar:new({
				parent = _parent,
				model = "UI:tip_item",
				align = "LT",
				w = _frm.data.w,
				h = size.height + 140,
				z = -1,
			})
			RemoveListEx[#RemoveListEx+1] = "barFuck"
		end
	end
	
	hGlobal.event:listen("LocalEvent_showAttributeInfoFrm","_newshowAttributeInfoFrm",function(x,y,index,tab,state,HeroInfoNumber)
		if type(index) == "number" then
			_frm:setXY(x or (_x + 2),y or (_y - 10))
			_create_attribute_info(index,tab,state,HeroInfoNumber)
		elseif type(index) == "string" then
			_frm:setXY(x or (_x + 86),y or (_y - 70))
			_create_other_info(index,tab,state)
		end
		_frm:show(1)
		_frm:active()
	end)
	
	hGlobal.event:listen("LocalEvent_closeAttributeInfoFrm","_newcloseAttributeInfoFrm",function(oHero,oItem)
		_frm:show(0)
		for i = 1,#RemoveListEx do
			hApi.safeRemoveT(_childUI,RemoveListEx[i])
		end
		RemoveListEx = {}
	end)
	
end

--通用升级信息面板
hGlobal.UI.InitGeneralLvUpInfoFrm = function()
	local _w,_h = 600, 540
	local _x,_y = hVar.SCREEN.w/2 - _w / 2, hVar.SCREEN.h/2 + _h / 2 - 10
	
	local _scoreLabX = 10
	local _scoreLabY = -200
	
	local _frm
	hGlobal.UI.GeneralLvUpInfoFrm = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		dragable = 2,
		show = 0,
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			if IsInside == 0 then
				self:show(0)
			end
		end,
		closebtn = {
			model = "BTN:PANEL_CLOSE",
			x = _w - 14,
			y = -14,
			z = 10,
			code = function(self)
				_frm:show(0)
				
				--删除监听
				--删除herocardfrm.png,目前方法比较暴力 zhenkira
				hGlobal.event:event("LocalEvent_Phone_HeroCardNewFrm_ClearListener")
				
				--geyachao: 这里弹框了，因为没创建控件？
				if hGlobal.UI.HeroCardNewFrm then
					hGlobal.UI.HeroCardNewFrm:del()
					hGlobal.UI.HeroCardNewFrm = nil
				end
			end,
		},
	})
	
	_frm = hGlobal.UI.GeneralLvUpInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local _func
	local _parmaL
	
	--确认技能升级的确定按钮
	_childUI["btnOk"] =  hUI.button:new({
		parent	= _parent,
		dragbox = _frm.childUI["dragBox"],
		--model	= "BTN:PANEL_CLOSE",
		x = _w / 2,
		y = -_h + 50,
		z = 1,
		font = hVar.FONTC,
		border = 1,
		align = "MC",
		label = hVar.tab_string["__UPGRADE"],
		scaleT	= 0.9,
		code = function()
			if _func then
				local a,b,c,d,e,f = unpack(_parmaL or {})
				_func(a,b,c,d,e,f)
				_frm:show(0)
				
				--播放升级的音效
				hApi.PlaySound("level_up")
			end
		end,
	})
	
	--通用名称
	_childUI["labName"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "MC",
		font = hVar.FONTC,
		x = 140,
		y = -35,
		width = 300,
		border = 1,
		text = "name",
	})
	
	--通用图标
	_childUI["imgIcon"] = hUI.image:new({
		parent = _parent,
		model = "",
		x = 140,
		y = -95,
		scale = 1.2,
	})
	
	--通用素材条
	_childUI["barMaterial"] = hUI.valbar:new({
		parent = _parent,
		x = 92,
		y = -150,
		w = 99,
		h = 14,
		align = "LC",
		back = {model = "UI:SoulStoneBarBg1",x=-4,y=0,w=105,h=20},
		model = "UI:SoulStoneBar1",
		--model = "misc/progress.png",
		v = 100,
		max = 100,
	})
	
	--通用素材当前及拥有值
	_childUI["labSoulStoneExp"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "MC",
		--font = hVar.FONTC,
		font = hVar.DEFAULT_FONT,
		x = 140,
		y = -150,
		border = 1,
		text = "1/2", --"NA", --geyachao: 这里不显示等级文字了
	})
	
	--通用当前Lv
	_childUI["labLv"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "LC",
		font = hVar.FONTC,
		x = 250,
		y = -95,
		width = 300,
		border = 1,
		text = "",
	})
	
	--通用升级等级箭头
	_childUI["imgLvArrow"] = hUI.image:new({
		parent = _parent,
		model = "UI:UI_Arrow",
		x = 375,
		y = -93,
	})
	
	--通用下一级Lv
	_childUI["labLvNext"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "LC",
		font = hVar.FONTC,
		x = 420,
		y = -95,
		width = 300,
		border = 1,
		text = "",
	})
	
	--[[
	--升级背景
	_childUI["imgLvUpBg"] = hUI.image:new({
		parent = _parent,
		model = "UI:lvUpBg", --"misc/pvp/SkillBG.png", --"UI:frame_corner02",
		x = _scoreLabX + 290, --卡牌大头像区域的x位置
		y = _scoreLabY - 50,
		w = 516 + 40,
		h = 140,
	})
	]]
	local imgLvUpBg9 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/cjwc.png")
	if imgLvUpBg9 then
		imgLvUpBg9:setPosition(ccp(_scoreLabX + 290, _scoreLabY - 37))
		imgLvUpBg9:setContentSize(CCSizeMake(580, 186))
		--imgLvUpBg9:setScaleX(ACTIVITY_WIDTH / 121)
		--imgLvUpBg9:setScaleY(ACTIVITY_HEIGHT / 43)
		_parent:addChild(imgLvUpBg9)
	end
	
	--升级前文字提示"当前等级效果"
	_childUI["labBeforeLvUpTip"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LC",
		font = hVar.FONTC,
		x = _scoreLabX + 63,
		y = _scoreLabY + 23,
		width = 300,
		border = 1,
		text = hVar.tab_string["__LvNowAttr"],
	})
	_childUI["labBeforeLvUpTip"].handle.s:setColor(ccc3(0, 255, 0))
	
	--升级后文字提示"下一等级效果"
	_childUI["labAfterLvUpTip"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LC",
		font = hVar.FONTC,
		x = _scoreLabX + 347,
		y = _scoreLabY + 23,
		width = 300,
		border = 1,
		text = hVar.tab_string["__LvNextAttr"],
	})
	_childUI["labAfterLvUpTip"].handle.s:setColor(ccc3(0, 255, 0))
	
	--当前等级效果-升级前文字
	_childUI["labBeforeLvUp"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "LC",
		font = hVar.FONTC,
		x = _scoreLabX + 20,
		y = _scoreLabY - 55,
		width = 250,
		border = 1,
		text = "",
	})
	
	--下一等级效果-升级后文字
	_childUI["labAfterLvUp"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "LC",
		font = hVar.FONTC,
		x = _scoreLabX + 312,
		y = _scoreLabY - 55,
		width = 250,
		border = 1,
		text = "",
	})
	
	--升级文字箭头
	_childUI["imgArrorIcon"] = hUI.image:new({
		parent = _parent,
		model = "UI:Tactic_RPointer",
		x = _scoreLabX + 290,
		y = _scoreLabY - 55,
	})
	--_childUI["imgArrorIcon"].handle._n:setRotation(90)
	
	--技能需要的素材背景框
	_childUI["imgcostBG"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:lvUpCostBg", --"UI:ExpBG",
		x = _scoreLabX + 305,
		y = _scoreLabY - 195,
		w = 640, --236
		h = 110, --146
		align = "MC",
		color = {0,0,0},
	})
	_childUI["imgcostBG"].handle.s:setOpacity(128)
	
	--“需要”文字
	_childUI["labRequireTip"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "MC",
		font = hVar.FONTC,
		x = _scoreLabX + 290,
		y = _scoreLabY - 170,
		width = 360,
		border = 1,
		text = hVar.tab_string["__TEXT_NEED"],
	})
	_childUI["labRequireTip"].handle.s:setColor(ccc3(255, 255, 0))
	
	--需要的资源
	for i = 1, 2, 1 do
		_childUI["imgRequire"..i] = hUI.image:new({
			parent = _parent,
			model = "",
			x = _scoreLabX + 250,
			y = _scoreLabY - 215,
			w = 32,
			h = 32,
			
		})
		_childUI["imgRequire"..i].handle._n:setVisible(false)
		
		_childUI["labRequire"..i] = hUI.label:new({
			parent = _parent,
			size = 26,
			align = "LC",
			font = hVar.FONTC,
			x = _scoreLabX + 300,
			y = _scoreLabY - 215,
			width = 300,
			border = 1,
			text = "num",
		})
		_childUI["labRequire"..i].handle._n:setVisible(false)
		
	end
	
	hGlobal.event:listen("LocalEvent_showGeneralLvUpFrm", "__showGeneralLvUpfrm", function(setting)
		
		--参数列表
		--setting = {
		--	name = "",				--名称
		--	icon = "",				--图标
		--
		--	lv = 1,					--当前等级
		--	lvNext = 2,				--下一等级
		--	lvMaxErr = "",				--等级满时的错误提示
		--
		--	info = "",				--当前等级信息
		--	infoNext = "",				--下一等级信息
		--
		--	requireList = {				--需求资源列表
		--		[1] = {
		--			icon = "",		--资源图标
		--			cost = 1,		--资源消耗
		--			now = 1,		--当前资源
		--			err = "",		--资源不足提示
		--			flag = false,		--是否有材料
		--		},
		--		[2] = {
		--			icon = "",
		--			cost = 1,
		--			now = 1,
		--			err = "",
		--			flag = false,
		--		},
		--	},
		--
		--	func = hApi.DoNothing,			--按钮点击函数
		--	parmaL = parmaL,			--按钮点击函数参数，一维表，目前支持6个参数
		--}
		
		_frm:show(1)
		_frm:active()
		
		_func = setting.func
		_parmaL = setting.parmaL
		
		--名字
		_childUI["labName"]:setText(setting.name)
		--图标
		_childUI["imgIcon"]:setmodel(setting.icon, nil, nil, 64, 64)
		
		
		_childUI["labLv"]:setText(hVar.tab_string["__Attr_Hint_Lev"]..tostring(setting.lv))
		_childUI["labLvNext"]:setText(hVar.tab_string["__Attr_Hint_Lev"]..tostring(setting.lvNext))
		_childUI["labLvNext"].handle.s:setColor(ccc3(255,255,255))
		
		_childUI["labBeforeLvUp"]:setText(setting.info)
		_childUI["labAfterLvUp"]:setText(setting.infoNext)
		--print(#setting.info)
		_childUI["labAfterLvUp"].handle.s:setColor(ccc3(255,255,255))
		
		local isMax = setting.isMax
		
		local canLvUp = true
		local strErr =""
		for i = 1, #setting.requireList do
			local requireInfo = setting.requireList[i] --icon, cost, now, errInfo
			
			if _childUI["imgRequire"..i] then
				_childUI["imgRequire"..i]:setmodel(requireInfo.icon, nil, nil, 30, 30)
				_childUI["imgRequire"..i].handle._n:setVisible(true)
			end
			if _childUI["labRequire"..i] then
				_childUI["labRequire"..i]:setText(requireInfo.cost)
				_childUI["labRequire"..i].handle._n:setVisible(true)
				if requireInfo.now < requireInfo.cost then
					_childUI["labRequire"..i].handle.s:setColor(ccc3(255,0,0))
					if canLvUp then
						strErr = requireInfo.err
					end
					canLvUp = false
				else
					_childUI["labRequire"..i].handle.s:setColor(ccc3(255,255,255))
				end
			end
			
			if requireInfo.flag then
				--通用素材条
				_childUI["barMaterial"].handle._n:setVisible(true)
				--通用素材当前及拥有值
				_childUI["labSoulStoneExp"].handle._n:setVisible(true)
				_childUI["barMaterial"]:setV(townTacticDebrisNum, costDebris)
			else
				--通用素材条
				_childUI["barMaterial"].handle._n:setVisible(false)
				--通用素材当前及拥有值
				_childUI["labSoulStoneExp"].handle._n:setVisible(false)
			end
			
		end
		
		if isMax then
			strErr = setting.lvMaxErr
			canLvUp = false
			
			--_childUI["labLvNext"]:setText(hVar.tab_string["__Attr_Hint_Lev"].."Max")
			_childUI["labLvNext"].handle.s:setColor(ccc3(255,0,0))
			
			--_childUI["labAfterLvUp"]:setText(strErr)
			_childUI["labAfterLvUp"].handle.s:setColor(ccc3(255,0,0))
		end
		
		if canLvUp then
			_childUI["labRequireTip"].handle.s:setColor(ccc3(255,255,255))
			_childUI["labRequireTip"]:setText(hVar.tab_string["__TEXT_NEED"])
			_childUI["btnOk"]:setstate(1)
		else
			_childUI["labRequireTip"].handle.s:setColor(ccc3(255,0,0))
			_childUI["labRequireTip"]:setText(strErr)
			_childUI["btnOk"]:setstate(0)
		end
	end)
end




--创建第一关的引导
function CreateGuideFrame_Map001()
	local GUIDE_CLICK_POINT_X = 725 --点击地面的x坐标
	local GUIDE_CLICK_POINT_Y = 641 --点击地面的y坐标
	local GUIDE_TOWER1_POS_X = 564 --第一个塔基x坐标
	local GUIDE_TOWER1_POS_Y = 564 --第一个塔基y坐标
	local GUIDE_TOWER2_POS_X = 468 --第二个塔基x坐标
	local GUIDE_TOWER2_POS_Y = 564 --第二个塔基y坐标
	local GUIDE_CLICK_TACTIC_X = 578 --点击战术技能卡的x坐标
	local GUIDE_CLICK_TACTIC_Y = 648 --点击战术技能卡的y坐标
	
	local __activeSkillNum = hVar.NORMALATK_IDX + 1
	
	--iPhoneX黑边宽
	local iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then --iPhoneX
		iPhoneX_WIDTH = 80
	end
	
	--第一关引导的状态集
	hGlobal.UI.Guide001StateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_HERO = 1, --提示点击英雄
		GUIDE_CLICK_POINT = 2, --提示点击目的地点
		GUIDE_CLICK_TOWER1 = 3, --提示点击第一个塔基
		GUIDE_CLICK_TOWER1_BUILD = 4, --提示点击第一个塔基的建造按钮
		GUIDE_CLICK_TOWER2 = 5, --提示点击第二个塔基
		GUIDE_CLICK_TOWER2_UPDATE = 6, --提示点击第二个箭塔的升级按钮
		GUIDE_CLICK_TACTIC = 7, --提示点击战术技能卡
		GUIDE_CLICK_TACTIC_CAST_SKILL = 8, --提示使用战术技能地面释放技能
		GUIDE_CLICK_TACTIC_CAST_CD = 9, --提示战术技能卡的CD
		GUIDE_CLICK_GOLD_LIFE = 10, --提示生命、金钱、波次的说明 
		GUIDE_CLICK_WAVE = 11, --提示点击出兵按钮
		GUIDE_END = 12, --引导结束
	}

	--引导的当前状态
	hGlobal.UI.Guide001State = hGlobal.UI.Guide001StateType.NONE --一开始为初始状态
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideTacticEffect then --提示点击战术技能卡的箭头
		hGlobal.UI.GuideTacticEffect:del()
		hGlobal.UI.GuideTacticEffect = nil
	end
	if hGlobal.UI.GuideTacticButton then --点击战术技能卡地面的箭头
		hGlobal.UI.GuideTacticButton:del()
		hGlobal.UI.GuideTacticButton = nil
	end
	
	if hGlobal.UI.GuideSystemMenuBar then --主界面
		hGlobal.UI.GuideSystemMenuBar:del()
		hGlobal.UI.GuideSystemMenuBar = nil
	end
	
	--创建引导的界面
	--创建父容器
	hGlobal.UI.GuideSystemMenuBar = hUI.frame:new({
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
		border = 0,
		--点击事件（有可能在控件外部点击）
		codeOnDragEx = function(screenX, screenY, touchMode)
			--print("codeOnDragEx", screenX, screenY, touchMode)
			if (touchMode == 0) then --按下
				--
			elseif (touchMode == 1) then --滑动
				--
			elseif (touchMode == 2) then --抬起
				--点击引导界面事件
				local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				local world = hGlobal.WORLD.LastWorldMap
				local oUnit = world:GetPlayerMe().heros[1]:getunit()
				OnClickGuide001Frame_Event(oUnit, worldX, worldY)
			end
		end
	})
	hGlobal.UI.GuideSystemMenuBar:active() --最前端显示
	
	local _frm = hGlobal.UI.GuideSystemMenuBar
	
	--点击引导第一关界面的事件
	function OnClickGuide001Frame_Event(oUnit, clickWorldX, clickWorldY)
		if (hGlobal.UI.Guide001State == hGlobal.UI.Guide001StateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导第一关界面")
			
			--找到战术卡的坐标
			local world = hGlobal.WORLD.LastWorldMap
			local ctrlI = world.data.tacticCardCtrls[__activeSkillNum]
			--print(btni)
			local btniX, btniY = ctrlI.data.x, ctrlI.data.y
			
			--提示点击战术技能卡
			--创建点击战术技能卡的箭头
			hGlobal.UI.GuideTacticEffect = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = hGlobal.UI.GuideSystemMenuBar.handle._n,
				x = btniX,
				y = btniY,
				model = "misc/mask.png",
				w = 160,
				h = 160,
			})
			hGlobal.UI.GuideTacticEffect.handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--创建战术技能卡的边框转动效果
			local SCALE_T = 2.8
			if (g_phone_mode ~= 0) then
				SCALE_T = 3.0
			end
			local btn = hGlobal.UI.GuideTacticEffect
			--手
			btn.childUI["cardHand"] = hUI.image:new({
				parent = btn.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = -70,
				y = 40,
				scale = 1.3,
			})
			btn.childUI["cardHand"].handle._n:setRotation(-30)
			--边框
			btn.childUI["cardOutline"] = hUI.image:new({
				parent = btn.handle._n,
				model = "MODEL_EFFECT:strengthen2",
				x = 0,
				y = 10,
				z = 2,
				w = 64,
				h = 64,
				scale = SCALE_T,
			})
			
			--进入下个状态: 提示点击战术技能卡
			hGlobal.UI.Guide001State = hGlobal.UI.Guide001StateType.GUIDE_CLICK_TACTIC
			
			--显示对话框：引导点击战术技能卡
			--__Dialogue_Guide001_ClickTacticCard()
		elseif (hGlobal.UI.Guide001State == hGlobal.UI.Guide001StateType.GUIDE_CLICK_TACTIC) then --提示点击战术技能卡状态
			--wait
			--检测是否点到了战术卡的区域内
			local world = hGlobal.WORLD.LastWorldMap
			local touchX, touchY = hApi.world2view(clickWorldX, clickWorldY)
			local ctrlI = world.data.tacticCardCtrls[__activeSkillNum]
			local cx = 0
			local cy = 0
			local bcx = ctrlI.data.x --中心点x坐标
			local bcy = ctrlI.data.y --中心点y坐标
			local bcw, bch = ctrlI.data.w, ctrlI.data.h
			local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
			local brx, bry = blx + bcw, bly + bch --最右下角坐标
			--print(i, lx, rx, ly, ry, touchX, touchY)
			if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
				--print("点击到了哪个DLC地图面板tip的框内" .. i, m)
				--缩小再放大
				local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
				local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				ctrlI.handle._n:stopAllActions()
				ctrlI.handle._n:runAction(sequence)
				
				--使用战术技能卡
				local world = hGlobal.WORLD.LastWorldMap
				local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
				--施法
				local idx = 1
				--local world = hGlobal.WORLD.LastWorldMap
				--local oUnit = world:GetPlayerMe().heros[1]:getunit()
				--hApi.UseLocalTacticCard(hGlobal.WORLD.LastWorldMap:GetPlayerMe(), tacticCardCtrls[idx], GUIDE_CLICK_TACTIC_X, GUIDE_CLICK_TACTIC_Y)
				--玩家使用战术(道具)技能卡（同步）
				local me = world:GetPlayerMe()
				local oHero = me.heros[1]
				local itemSkillT = oHero.data.itemSkillT
				local itemIdx = __activeSkillNum - hVar.TANKSKILL_EMPTY
				local itemId = itemSkillT[itemIdx].activeItemId
				hApi.UsePlayerTacticCard(hGlobal.WORLD.LastWorldMap:GetPlayerMe(), 0, itemId, GUIDE_CLICK_TACTIC_X, GUIDE_CLICK_TACTIC_Y, 0, 0)
				
				--清除提示点击战术技能卡的箭头
				if hGlobal.UI.GuideTacticEffect then
					hGlobal.UI.GuideTacticEffect:del()
					hGlobal.UI.GuideTacticEffect = nil
				end
				
				--删除引导的战术技能卡图标
				if hGlobal.UI.GuideTacticButton then --界面
					hGlobal.UI.GuideTacticButton:del()
					hGlobal.UI.GuideTacticButton = nil
				end
				
				--清除整个界面
				if hGlobal.UI.GuideSystemMenuBar then --界面
					hGlobal.UI.GuideSystemMenuBar:del()
					hGlobal.UI.GuideSystemMenuBar = nil
				end
				
				--geyachao: 标记当前不在引导中
				hVar.IS_IN_GUIDE_STATE = 0
				--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导第一关界面")
				
				--这里不标记第一关开始的引导结束（有可能异常退出，再登入还要继续引导（在第一关胜利后标记引导完成）
				--LuaSetPlayerGuideState(g_curPlayerName, "world/csys_000", 1)
				--所有的建造引导塔已经完成了
				--进入下一状态: 提示点击出兵按钮
				hGlobal.UI.Guide001State = hGlobal.UI.Guide001StateType.GUIDE_END
				
				--标记第一关开始的引导结束
				LuaSetPlayerGuideState(g_curPlayerName, "world/csys_000", 1)
			end
		elseif (hGlobal.UI.Guide001State == hGlobal.UI.Guide001StateType.GUIDE_END) then --引导结束状态
			--删除引导的战术技能卡图标
			if hGlobal.UI.GuideTacticButton then --界面
				hGlobal.UI.GuideTacticButton:del()
				hGlobal.UI.GuideTacticButton = nil
			end
			
			--清除整个界面
			if hGlobal.UI.GuideSystemMenuBar then --界面
				hGlobal.UI.GuideSystemMenuBar:del()
				hGlobal.UI.GuideSystemMenuBar = nil
			end
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导第一关界面")
			
			--标记第一关开始的引导结束
			LuaSetPlayerGuideState(g_curPlayerName, "world/csys_000", 1)
		end
	end
	
	--开始引导第一关开始
	function BeginGuide001()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.Guide001State = hGlobal.UI.Guide001StateType.GUIDE_END
			
			--清除提示点击战术技能卡的箭头
			if hGlobal.UI.GuideTacticEffect then
				hGlobal.UI.GuideTacticEffect:del()
				hGlobal.UI.GuideTacticEffect = nil
			end
			
			--清除战术技能卡按钮
			if hGlobal.UI.GuideTacticButton then
				hGlobal.UI.GuideTacticButton:del()
				hGlobal.UI.GuideTacticButton = nil
			end
			--清除整个界面
			if hGlobal.UI.GuideSystemMenuBar then --界面
				hGlobal.UI.GuideSystemMenuBar:del()
				hGlobal.UI.GuideSystemMenuBar = nil
			end
			
			--标记第一关进游戏的引导完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "world/csys_000", 1)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.Guide001State == hGlobal.UI.Guide001StateType.NONE) then --初始状态
				--hGlobal.UI.Guide001State = hGlobal.UI.Guide001StateType.GUIDE_CLICK_HERO
				local world = hGlobal.WORLD.LastWorldMap
				local oUnit = world:GetPlayerMe().heros[1]:getunit()
				OnClickGuide001Frame_Event(oUnit, 0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "游戏基本操作指导")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建对话
	local function __createTalkMap001(talkType, _func, ...)
		local arg = {...}
		local world = hGlobal.WORLD.LastWorldMap
		local mapInfo = world.data.tdMapInfo
		--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,talkType)
		
		local vTalk = hApi.InitUnitTalk(world:GetPlayerGod():getgod(), world:GetPlayerGod():getgod(), nil, talkType)
		--print("world:GetPlayerGod():getgod()", world:GetPlayerGod():getgod(), talkType, vTalk)
		if vTalk then
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
	
	--显示对话框：引导点击英雄
	function __Dialogue_Guide001_ClickHero()
		--print("显示对话框：引导点击英雄")
		--__createTalkMap001("mapGuid1")
	end
	
	--开始第一关的引导
	BeginGuide001()
end

--test
--测试第一关新手引导
--CreateGuideFrame_Map001()





--创建第一关的引导游戏结束退出
function CreateGuideFrame_Map001End()
	local GUIDE_TOWER1_POS_X = 900 --第一个塔基x坐标
	local GUIDE_TOWER1_POS_Y = 516 --第一个塔基y坐标

	--第一关结束引导退出和穿装备的状态集
	hGlobal.UI.Guide001EndStateType =
	{
		NONE = 0, --初始状态
		GUIDE_INTRODUCE = 1, --开场简介
		GUIDE_CLICK_CLOSE_BUTTON = 2, --提示点击关闭按钮
		GUIDE_END = 3, --引导结束
		GUIDE_DELETE = 4, --本界面已删除
	}

	--引导的当前状态
	hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideCloseButton then --关闭按钮
		hGlobal.UI.GuideCloseButton:del()
		hGlobal.UI.GuideCloseButton = nil
	end
	if hGlobal.UI.GuideClickCloseEffect then --提示关闭按钮的手的特效
		hGlobal.UI.GuideClickCloseEffect:del()
		hGlobal.UI.GuideClickCloseEffect = nil
	end
	if hGlobal.UI.GuideClickCloseRoundEffect then --提示关闭按钮的转圈圈特效
		hGlobal.UI.GuideClickCloseRoundEffect:del()
		hGlobal.UI.GuideClickCloseRoundEffect = nil
	end
	if hGlobal.UI.GuideDJTHandEffect then --提示点击点将台的手的特效
		hGlobal.UI.GuideDJTHandEffect:del()
		hGlobal.UI.GuideDJTHandEffect = nil
	end
	
	if hGlobal.UI.GuideSelectEndMenuBar then --引导升级塔高级技能的
		hGlobal.UI.GuideSelectEndMenuBar:del()
		hGlobal.UI.GuideSelectEndMenuBar = nil
	end
	
	--创建引导第一关结束的界面
	--创建父容器
	hGlobal.UI.GuideSelectEndMenuBar = hUI.frame:new({
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
				OnClickGuide001EndFrame_Event(screenX, screenY)
			end
		end
	})
	--hGlobal.UI.GuideSelectEndMenuBar:active() --最前端显示
	
	--点击引导第一关结束的事件
	function OnClickGuide001EndFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导第一关结束")
			
			--进入下个状态: 开场简介
			hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_INTRODUCE
			
			--显示对话框：引导第一关结束升级塔高级技能介绍
			__Dialogue_Guide001End_Introduce()
		elseif (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.GUIDE_INTRODUCE) then --提示第一关结束简介
			local w, h = hVar.SCREEN.w+10, hVar.SCREEN.h
			local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
			local scale = 1
			local btnScale = 0.9							--按钮缩放
			local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
			
			local nScreenY = 0							--根据机器类型（手机，平板）调正整体位置
			if 0 == g_phone_mode then
				nScreenY = -70
			end
			local nButtonX, nButtonY  = x + w/2, y + nScreenY-410
			--“主界面”关闭按钮
			hGlobal.UI.GuideCloseButton = hUI.button:new({
				parent = nil,
				dragbox = hGlobal.UI.GuideSelectEndMenuBar.childUI["dragBox"],
				model = "UI:ButtonBack",
				icon = "ui/hall.png",
				iconWH = 28,
				label = " "..hVar.tab_string["__TEXT_MainInterface"],
				font = hVar.FONTC,
				border = 1,
				align = "MC",
				scaleT = 0.99,
				x = nButtonX + 140,
				y = nButtonY - 200 + 25,
				z = 100,
				scale = btnScale,
				code = function(self)
					--删除控件
					--删除关闭按钮
					if hGlobal.UI.GuideCloseButton then
						hGlobal.UI.GuideCloseButton:del()
						hGlobal.UI.GuideCloseButton = nil
					end
					
					--删除提示关闭按钮的手的特效
					if hGlobal.UI.GuideClickCloseEffect then
						hGlobal.UI.GuideClickCloseEffect:del()
						hGlobal.UI.GuideClickCloseEffect = nil
					end
					
					--删除提示关闭按钮的转圈圈特效
					if hGlobal.UI.GuideClickCloseRoundEffect then
						hGlobal.UI.GuideClickCloseRoundEffect:del()
						hGlobal.UI.GuideClickCloseRoundEffect = nil
					end
					
					--进入下个状态: 引导结束
					hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_END
					
					--无对话
					--...
					
					--强制到下一状态
					OnClickGuide001EndFrame_Event(0, 0)
				end,
			})
			--_childUI["btnOk"]:setstate(-1)
			hGlobal.UI.GuideCloseButton.childUI["label"].handle._n:setPosition(-35,12)
			hGlobal.UI.GuideCloseButton.childUI["icon"].handle._n:setPosition(-60,1)
		
			--创建点击关闭按钮的手特效
			hGlobal.UI.GuideClickCloseEffect = hUI.image:new({
				parent = nil,
				x = nButtonX + 140,
				y = nButtonY - 200 + 55,
				model = "MODEL_EFFECT:Hand",
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideClickCloseEffect.handle.s:setRotation(-30)
			
			--创建关闭按钮转圈圈特效
			hGlobal.UI.GuideClickCloseRoundEffect = hUI.image:new({
				parent = nil,
				model = "MODEL_EFFECT:strengthen",
				x = nButtonX + 140,
				y = nButtonY - 200 + 27,
				--w = 180,
				--h = 50,
				--scale = 2.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideClickCloseRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideClickCloseRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideClickCloseRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--进入下个状态: 提示点击关闭按钮
			hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_CLICK_CLOSE_BUTTON
			
			--无对话
			--...
		elseif (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.GUIDE_CLICK_CLOSE_BUTTON) then --提示点击关闭按钮
			--在按钮点击事件中处理，这里不做处理
			--...
		
		elseif (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideSelectEndMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideSelectEndMenuBar:del()
				hGlobal.UI.GuideSelectEndMenuBar = nil
			end
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导第一关结束")
			
			--注意：这三个标记在第一关第一次胜利的时候已经标记过了
			--标记第一关第一次结束引导完成（同时标记登入引导、第一关开始引导完成）
			--LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2)
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
			--LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1)
			
			--隐藏胜利界面
			hGlobal.UI.__GameOverPanel:show(0)
			hUI.Disable(0, "离开游戏")
			
			--删除world
			--zhenkira 注释
			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
				--	print(".."..nil)
				--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				--end
				hGlobal.WORLD.LastWorldMap:del()
			end
			
			--zhenkira 新增
			hGlobal.LocalPlayer:setfocusworld(nil)
			--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
			
			--进入下一个状态: 本界面已删除
			hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_DELETE
		elseif (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.GUIDE_DELETE) then --本界面已删除
			--...
		end
	end
	
	--开始引导第一关结束
	function BeginGuide001End()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideSelectEndMenuBar then --界面
				hGlobal.UI.GuideSelectEndMenuBar:del()
				hGlobal.UI.GuideSelectEndMenuBar = nil
			end
			
			--标记引导第一关结束完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.Guide001EndState == hGlobal.UI.Guide001EndStateType.NONE) then --初始状态
				--hGlobal.UI.Guide001EndState = hGlobal.UI.Guide001EndStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuide001EndFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "挑战第一关完成")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建游戏内的对话
	local function __createTalkMap001End(talkType, _func, ...)
		local arg = {...}
		local world = hGlobal.WORLD.LastWorldMap
		local mapInfo = world.data.tdMapInfo
		local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,talkType)
		if vTalk then
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
	
	--显示对话框：引导第一关结束的简介
	function __Dialogue_Guide001End_Introduce()
		print("显示对话框：引导第一关结束升级塔高级技能简介")
		__createTalkMap001End("mapGuid21", OnClickGuide001EndFrame_Event, 0, 0)
	end
	
	--开始引导第一关结束的介绍
	BeginGuide001End()
end

--test
--测试第一关的引导游戏结束退出
--CreateGuideFrame_Map001End()































--创建主城引导点将台、穿装备、升级技能
function CreateGuideFrame_HeroFrm()
	local GUIDE_TOWER1_POS_X = 900 --第一个塔基x坐标
	local GUIDE_TOWER1_POS_Y = 516 --第一个塔基y坐标
	
	--主城引导点将台、穿装备、升级技能
	hGlobal.UI.GuideHeroFrmStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_DIANJIANGTAI = 1, --提示点击点将台
		GUIDE_WAIT_CLICK_DIANJIANGTAI = 2, --等待点击点将台按钮
		GUIDE_HERO_UI_INTRODUCE = 3, --提示英雄界面介绍
		GUIDE_HERO_EQIPMENT_INTRODUCE = 4, --提示英雄穿装备
		GUIDE_CLICK_SKILL_BUTTON = 5, --提示点击第一个技能按钮
		GUIDE_CLICK_LVUP_BUTTON = 6, --提示点击技能升级按钮
		GUIDE_CLICK_CLOSE_HERO_UI = 7, --提示关闭英雄界面
		GUIDE_END = 8, --引导结束
	}

	--引导的当前状态
	hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideDJTHandEffect then --提示点击点将台的手的特效
		hGlobal.UI.GuideDJTHandEffect:del()
		hGlobal.UI.GuideDJTHandEffect = nil
	end
	if hGlobal.UI.GuideDJTRoundEffect then --提示点击点将台的转圈圈特效
		hGlobal.UI.GuideDJTRoundEffect:del()
		hGlobal.UI.GuideDJTRoundEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardHandEffect then --提示点击英雄卡片的手的特效
		hGlobal.UI.GuideClickHeroCardHandEffect:del()
		hGlobal.UI.GuideClickHeroCardHandEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardRoundEffect then --提示点击英雄卡片的转圈圈特效
		hGlobal.UI.GuideClickHeroCardRoundEffect:del()
		hGlobal.UI.GuideClickHeroCardRoundEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnStarLvUp_Fake") --英雄详细界面升星按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake") --英雄详细界面关闭按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_R_Fake") --英雄详细界面翻页按钮下（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_L_Fake") --英雄详细界面翻页按钮上（假的）（挡操作用）
	if hGlobal.UI.GuideClickItemRoundEffect then --提示选取道具转圈圈特效
		hGlobal.UI.GuideClickItemRoundEffect:del()
		hGlobal.UI.GuideClickItemRoundEffect = nil
	end
	if hGlobal.UI.GuideClickItemHandEffect then --提示选取道具的手的特效
		hGlobal.UI.GuideClickItemHandEffect:del()
		hGlobal.UI.GuideClickItemHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnItem_Fake") --英雄详细界面道具按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkill_Fake") --英雄详细界面技能按钮（假的）（挡操作用）
	if hGlobal.UI.GuideClickSkillRoundEffect then --提示点击第一个技能图标的转圈圈特效
		hGlobal.UI.GuideClickSkillRoundEffect:del()
		hGlobal.UI.GuideClickSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideClickSkillHandEffect then --提示点击第一个技能图标的手特效
		hGlobal.UI.GuideClickSkillHandEffect:del()
		hGlobal.UI.GuideClickSkillHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_FakeGuide") --英雄详细界面积分升级按钮（假的）（引导用）
	if hGlobal.UI.GuideLvUpSkillRoundEffect then --提示点击技能升级按钮的转圈圈特效
		hGlobal.UI.GuideLvUpSkillRoundEffect:del()
		hGlobal.UI.GuideLvUpSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideLvUpSkillHandEffect then --提示点击技能升级按钮的手的特效
		hGlobal.UI.GuideLvUpSkillHandEffect:del()
		hGlobal.UI.GuideLvUpSkillHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake2") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake2") --英雄详细界面关闭按钮（假的）（引导用）
	if hGlobal.UI.GuideCloseHeroRoundEffect then --提示点击关闭按钮的转圈圈特效
		hGlobal.UI.GuideCloseHeroRoundEffect:del()
		hGlobal.UI.GuideCloseHeroRoundEffect = nil
	end
	if hGlobal.UI.GuideCloseHeroHandEffect then --提示点击关闭按钮的手的特效
		hGlobal.UI.GuideCloseHeroHandEffect:del()
		hGlobal.UI.GuideCloseHeroHandEffect = nil
	end
	
	if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
		hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
		hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
	end
	
	--创建引导英雄界面的引导主界面
	--创建父容器
	hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
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
				OnClickGuideHeroFrmFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
	
	--点击引导英雄界面的事件
	function OnClickGuideHeroFrmFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导英雄界面")
			
			--进入下个状态: 开场简介
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_DIANJIANGTAI
			
			--显示对话框：引导提示点将台
			__Dialogue_GuideHeroFrm_DianJiangTaiIntroduce()
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_DIANJIANGTAI) then --提示点击点将台
			--[[
			--找到点将台角色
			local oMap = __G_MainMenuWorld --主界面地图
			local tAllChaHandle = oMap.data.chaHandle
			local djtTypeId = 60001 --点将台角色类型id
			local tChaDianJiangTaiHandle = nil --点将台单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == djtTypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaDianJiangTaiHandle = tChaHandle
					break
				end
			end
			
			local towerScreenX, towerScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建提示点击点将台按钮的手特效
			hGlobal.UI.GuideDJTHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = towerScreenX + 35,
				y = towerScreenY + 95,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideDJTHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			
			--点将台单位描边
			local program = hApi.getShader("outline")
			tChaDianJiangTaiHandle.s:setShaderProgram(program)
			local act1 = CCFadeTo:create(0.5, 168)
			local act2 = CCFadeTo:create(0.5, 255)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			tChaDianJiangTaiHandle.s:runAction(CCRepeatForever:create(sequence))
			]]
			--创建提示点击点将台按钮的转圈圈特效
			hGlobal.UI.GuideDJTRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = hVar.SCREEN.w - 60,
				y = 75,
				--w = 90,
				--h = 90,
				--scale = 2.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideDJTRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideDJTRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideDJTRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(2.3)
			
			--创建提示点击点将台按钮的手特效
			hGlobal.UI.GuideDJTHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = hVar.SCREEN.w - 60,
				y = 75 + 40,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideDJTHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击点将台按钮
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_DIANJIANGTAI
			
			--显示对话框：引导主城英雄界面点击点将台按钮
			__Dialogue_GuideHeroFrm_Click_DianJiangTai()
			
			--geyachao: 无主城模式（因为有可能不响应frame点击事件，按钮在最顶层，只能监听到按钮点击事件，所以这里特殊处理一下）
			--监听英雄界面打开事件
			hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", function()
				--print("删除引导主界面")
				--删除监听事件
				hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", nil)
				
				--强制跳转到下个状态
				local bx = hVar.SCREEN.w - 60
				local by = 75
				local w = 90
				local h = 90
				local button_left = bx - w / 2 --英雄选中区域的最左侧
				local button_right = bx + w / 2 --英雄选中区域的最右侧
				local button_top = by - h / 2 --英雄选中区域的最上侧
				local button_bottom = by + h / 2 --英雄选中区域的最下侧
				OnClickGuideHeroFrmFrame_Event((button_left + button_right) / 2, (button_top + button_bottom) / 2)
			end)
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_DIANJIANGTAI) then --提示点击点将台按钮
			--[[
			--检测是否点击到了点将台按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oMap = __G_MainMenuWorld --主界面地图
			local tChaDianJiangTaiHandle = oMap:hit2cha(worldX, worldY)
			local djtTypeId = 60001 --点将台角色类型id
			if tChaDianJiangTaiHandle then
				if (tChaDianJiangTaiHandle.data.id == djtTypeId) then
			]]
			local bx = hVar.SCREEN.w - 60
			local by = 75
			local w = 90
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			if true then
				--检测是否点击到了点将台按钮
				if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
					--删除提示点击点将台按钮的手特效
					if hGlobal.UI.GuideDJTHandEffect then --点击点将台的手的特效
						hGlobal.UI.GuideDJTHandEffect:del()
						hGlobal.UI.GuideDJTHandEffect = nil
					end
					
					--删除提示点击点将台按钮的转圈圈特效
					if hGlobal.UI.GuideDJTRoundEffect then --点击点将台的手的特效
						hGlobal.UI.GuideDJTRoundEffect:del()
						hGlobal.UI.GuideDJTRoundEffect = nil
					end
					
					--[[
					--geyachao: 旧版有主城模式
					--停止点将台单位的运动
					tChaDianJiangTaiHandle.s:stopAllActions()
					--剧情战役单位不描边
					local program = hApi.getShader("normal")
					tChaDianJiangTaiHandle.s:setShaderProgram(program)
					
					
					--在显示完英雄卡牌后再重新创建主界面（为了覆盖到最前面）
					--监听显示英雄列表面板事件
					hGlobal.event:listen("LocalEvent_Phone_ShowMyHerocar", "GuideShowPhoneMyHerocar", function()
						--print("删除引导主界面")
						--删除监听事件
						hGlobal.event:listen("LocalEvent_Phone_ShowMyHerocar", "GuideShowPhoneMyHerocar", nil)
					]]
						--geyachao: 无主城模式的新流程
						hGlobal.event:event("LocalEvent_Phone_ShowMyHerocar")
						
						--删除监听事件
						hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", nil)
						
						--删除引导主界面
						if hGlobal.UI.GuideSelectHeroFrmMenuBar then
							hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
							hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
						end
						
						--重新创建父容器
						hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
							x = 0,
							y = 0,
							z = 100,
							w = hVar.SCREEN.w,
							h = hVar.SCREEN.h,
							--z = -1,
							show = 1,
							dragable = 2,
							--buttononly = 1,
							autoactive = 0,
							--background = "UI:PANEL_INFO_MINI",
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
									OnClickGuideHeroFrmFrame_Event(screenX, screenY)
								end
							end
						})
						--hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
						
						--创建提示点击英雄卡牌的转圈圈特效
						hGlobal.UI.GuideClickHeroCardRoundEffect = hUI.image:new({
							parent = nil,
							model = "MODEL_EFFECT:strengthen",
							x = hVar.SCREEN.w / 2 - 440 + 120,
							y = hVar.SCREEN.h / 2 + 240 - 167,
							--w = 150,
							--h = 200,
							--scale = 2.2,
							w = 100,
							h = 100,
							scale = 1.0,
							z = 100,
						})
						hGlobal.UI.GuideClickHeroCardRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
						hGlobal.UI.GuideClickHeroCardRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
						local decal, count = 11, 0 --光晕效果
						local r, g, b, parent = 150, 128, 64
						local parent = hGlobal.UI.GuideClickHeroCardRoundEffect.handle._n
						local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
						local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
						nnn:setScale(2.0)
						
						--创建提示点击英雄卡牌的手特效
						hGlobal.UI.GuideClickHeroCardHandEffect = hUI.image:new({
							parent = nil,
							model = "MODEL_EFFECT:Hand",
							x = hVar.SCREEN.w / 2 - 440 + 115,
							y = hVar.SCREEN.h / 2 + 240 - 167 + 40,
							scale = 1.5,
							z = 100,
						})
						--hGlobal.UI.GuideClickHeroCardHandEffect.handle.s:setColor(ccc3(255, 255, 0))
						
						--监听点击英雄卡片事件
						hGlobal.event:listen("LocalEvent_showHeroCardFrm", "GuideShowPhoneHeroInfo", function()
							--删除监听事件
							hGlobal.event:listen("LocalEvent_showHeroCardFrm", "GuideShowPhoneHeroInfo", nil)
							--print("删除监听事件删除监听事件删除监听事件")
							--删除提示点击英雄卡片的手的特效
							if hGlobal.UI.GuideClickHeroCardHandEffect then
								hGlobal.UI.GuideClickHeroCardHandEffect:del()
								hGlobal.UI.GuideClickHeroCardHandEffect = nil
							end
							
							--删除提示点击英雄卡片的转圈圈特效
							if hGlobal.UI.GuideClickHeroCardRoundEffect then
								hGlobal.UI.GuideClickHeroCardRoundEffect:del()
								hGlobal.UI.GuideClickHeroCardRoundEffect = nil
							end
							
							--创建
							--删除引导主界面
							if hGlobal.UI.GuideSelectHeroFrmMenuBar then
								hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
								hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
							end
							
							--重新创建父容器
							hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
								x = 0,
								y = 0,
								z = 100,
								w = hVar.SCREEN.w,
								h = hVar.SCREEN.h,
								--z = -1,
								show = 1,
								dragable = 2,
								--buttononly = 1,
								autoactive = 0,
								--background = "UI:PANEL_INFO_MINI",
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
										OnClickGuideHeroFrmFrame_Event(screenX, screenY)
									end
								end
							})
							--hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
							
							local _frm = hGlobal.UI.HeroCardNewFrm
							local _parent = _frm.handle._n
							local _childUI = _frm.childUI
							
							--英雄详细界面积分升级按钮（假的）（挡操作用）
							_childUI["btnSkillLvUp_Fake"] = hUI.button:new({
								parent = _parent,
								model = "UI:BTN_ButtonRed", 
								animation = "normal",
								dragbox = _childUI["dragBox"],
								font = hVar.FONTC,
								border = 1,
								align = "MC",
								label = hVar.tab_string["__UPGRADE"],
								--y = -455,
								--scale = 1,
								x = 465,
								y = -490,
								scale = 1,
								scaleT = 0.99,
								code = function(self)
									--
								end,
							})
							local _btnSkillLvUpScore = _childUI["btnSkillLvUp_Fake"]
							
							--英雄详细界面关闭按钮（假的）（挡操作用）
							local _w,_h = 892, 558
							local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 20
							
							local closeDx = -5
							local closeDy = -5
							if (g_phone_mode ~= 0) then
								closeDx = 0
								closeDy = -20
							end
							_childUI["btnClose_Fake"] = hUI.button:new({
								parent = _frm,
								model = "BTN:PANEL_CLOSE",
								x = _w + closeDx,
								y = closeDy,
								z = 5,
								scaleT = 0.99,
								code = function(self)
									--
								end,
							})
							
							---英雄详细界面翻页按钮下（假的）（挡操作用）
							_childUI["playerbag_table_R_Fake"] = hUI.button:new({
								parent = _frm,
								model = "misc/mask.png",
								x = 873 + 20,
								y = -355,
								w = 40 + 40,
								h = 150,
								scaleT = 0.99,
								code = function(self)
									--
								end,
							})
							_childUI["playerbag_table_R_Fake"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
							--翻页按钮下图片
							_childUI["playerbag_table_R_Fake"].childUI["image"] = hUI.image:new({
								parent = _childUI["playerbag_table_R_Fake"].handle._n,
								model = "UI:playerBagD",
								x = -20,
								y = 40,
								scale = 1.0,
							})
							---英雄详细界面翻页按钮上（假的）（挡操作用）
							_childUI["playerbag_table_L_Fake"] = hUI.button:new({
								parent = _frm,
								model = "misc/mask.png",
								x = 873 + 20,
								y = -195,
								w = 40 + 40,
								h = 150,
								scaleT = 0.99,
								code = function(self)
									--
								end,
							})
							_childUI["playerbag_table_L_Fake"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
							--翻页按钮上图片
							_childUI["playerbag_table_L_Fake"].childUI["image"] = hUI.image:new({
								parent = _childUI["playerbag_table_L_Fake"].handle._n,
								model = "UI:playerBagD",
								x = -20,
								y = -40,
								scale = 1.0,
							})
							_childUI["playerbag_table_L_Fake"].childUI["image"] .handle.s:setFlipX(true)
							_childUI["playerbag_table_L_Fake"].childUI["image"] .handle._n:setRotation(180)
							
							--获得英雄当前装备了几个装备
							local heroEquippedNum = 0
							local HeroCard = hApi.GetHeroCardById(18001)
							if HeroCard and (type(HeroCard) == "table") and HeroCard.equipment and (type(HeroCard.equipment) == "table") then
								for k = 1, #HeroCard.equipment, 1 do
									--存档里的装备表
									local item = HeroCard.equipment[k]
									
									if (type(item) == "table") then
										local item_id = item[1] --道具id
										
										if (item_id ~= 0) then
											heroEquippedNum = heroEquippedNum + 1
										end
									end
								end
							end
							
							--获取道具在哪个位置
							--创建提示滑动道具的手的特效
							local xIdx = 0 --x索引值
							local yIdx = 0 --y索引值
							local itemIdx = 0 --获取第一个道具在哪个位置
							local item = LuaGetPlayerBagFromTableIndex(1)
							for k = 1, 28, 1 do
								if item[k] and (item[k] ~= 0) then
									itemIdx = k
									break
								end
							end
							if (itemIdx > 0) then
								xIdx = itemIdx % 4
								if (xIdx == 0) then
									xIdx = 4
								end
								yIdx = (itemIdx - xIdx) / 4 + 1
							end
							
							--函数：引导点击第一个技能图标的流程（因为后面有分支）
							local _CODE_GuideNext_Skill = function()
								--英雄详细界面道具按钮（假的）（挡操作用）
								_childUI["btnItem_Fake"] = hUI.button:new({
									parent = _parent,
									model = "misc/mask.png",
									dragbox = _childUI["dragBox"],
									x = _w - 267 - 87,
									y = -114 + 63,
									scale = 0.9,
									scaleT = 1.0,
									w = 200,
									h = 200,
									z = 100,
									code = function(self)
										--
									end,
								})
								_childUI["btnItem_Fake"].handle.s:setOpacity(0)
								
								--英雄详细界面技能按钮（假的）（挡操作用）
								_childUI["btnSkill_Fake"] = hUI.button:new({
									parent = _parent,
									model = "misc/mask.png",
									dragbox = _childUI["dragBox"],
									x = _w - 713 + 220 - 92,
									y = -379 + 5,
									scale = 0.9,
									scaleT = 1.0,
									w = 400,
									h = 100,
									z = 100,
									code = function(self)
										--
									end,
								})
								_childUI["btnSkill_Fake"].handle.s:setOpacity(0)
								
								--创建提示点击第一个技能图标的转圈圈特效
								hGlobal.UI.GuideClickSkillRoundEffect = hUI.image:new({
									parent = _parent,
									model = "MODEL_EFFECT:strengthen",
									x = _w - 713 - 96,
									y = -379 + 11,
									--w = 180,
									--h = 180,
									--scale = 1.0,
									w = 100,
									h = 100,
									scale = 1.0,
									z = 100,
								})
								hGlobal.UI.GuideClickSkillRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
								hGlobal.UI.GuideClickSkillRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
								local decal, count = 11, 0 --光晕效果
								local r, g, b, parent = 150, 128, 64
								local parent = hGlobal.UI.GuideClickSkillRoundEffect.handle._n
								local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
								local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
								nnn:setScale(1.6)
								
								--创建点击第一个技能图标的手特效
								hGlobal.UI.GuideClickSkillHandEffect = hUI.image:new({
									parent = _parent,
									x = _w - 713 - 96,
									y = -330,
									model = "MODEL_EFFECT:Hand",
									scale = 1.3,
									z = 100,
								})
								
								--监听点击英雄技能按钮事件
								hGlobal.event:listen("LocalEvent_ShowSkillInfo", "GuideClickSkillBtn", function(oHero, nHeroId, idx, bType, tIdx)
									--其它按钮都被挡住了，只能点到第一个按钮
									--删除监听事件
									hGlobal.event:listen("LocalEvent_ShowSkillInfo", "GuideClickSkillBtn", nil)
									
									--删除控件
									--删除提示点击第一个技能图标的转圈圈特效
									if hGlobal.UI.GuideClickSkillRoundEffect then
										hGlobal.UI.GuideClickSkillRoundEffect:del()
										hGlobal.UI.GuideClickSkillRoundEffect = nil
									end
									
									--删除点击第一个技能图标的手特效
									if hGlobal.UI.GuideClickSkillHandEffect then
										hGlobal.UI.GuideClickSkillHandEffect:del()
										hGlobal.UI.GuideClickSkillHandEffect = nil
									end
									
									--删除英雄详细界面积分升级按钮（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake")
									
									--新建一个新的英雄详细界面积分升级按钮（假的）（引导用）
									local clickSkillLvUp_Guide = nil --点击积分升级按钮（引导）的回调函数
									_childUI["btnSkillLvUp_FakeGuide"] = hUI.button:new({
										parent = _parent,
										model = "UI:BTN_ButtonRed", 
										animation = "normal",
										dragbox = _childUI["dragBox"],
										font = hVar.FONTC,
										border = 1,
										align = "MC",
										label = hVar.tab_string["__UPGRADE"],
										--y = -455,
										--scale = 1,
										x = 465,
										y = -490,
										scale = 1,
										scaleT = 0.95,
										code = function(self)
											clickSkillLvUp_Guide()
										end,
									})
									
									--创建提示点击技能升级按钮的转圈圈特效
									hGlobal.UI.GuideLvUpSkillRoundEffect = hUI.image:new({
										parent = _parent,
										model = "MODEL_EFFECT:strengthen",
										x = 405 + 65,
										y = -489,
										--w = 170,
										--h = 60,
										--scale = 2.0,
										w = 100,
										h = 100,
										scale = 1.0,
										z = 100,
									})
									hGlobal.UI.GuideLvUpSkillRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
									hGlobal.UI.GuideLvUpSkillRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
									local decal, count = 11, 0 --光晕效果
									local r, g, b, parent = 150, 128, 64
									local parent = hGlobal.UI.GuideLvUpSkillRoundEffect.handle._n
									local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
									local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
									nnn:setScale(1.8)
									
									--创建提示点击技能升级按钮的手的特效
									hGlobal.UI.GuideLvUpSkillHandEffect = hUI.image:new({
										parent = _parent,
										x = 405 + 65,
										y = -490 + 30,
										model = "MODEL_EFFECT:Hand",
										scale = 1.3,
										z = 100,
									})
									
									--点击升级英雄技能按钮事件（引导用）
									clickSkillLvUp_Guide = function()
										--模拟直接升级
										local overage = 0
										local strTag = "hi:18001;si:1103;st:1;sp:1;sc:100;"
										local order_id = 0
										--模拟英雄技能升级成功事件
										hGlobal.event:event("localEvent_afterSkillLvUpSucceed", overage, strTag, order_id)
										
										--删除控件
										--删除英雄详细界面积分升级按钮（假的）（引导用）
										hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_FakeGuide")
									
										--删除提示点击技能升级按钮的转圈圈特效
										if hGlobal.UI.GuideLvUpSkillRoundEffect then
											hGlobal.UI.GuideLvUpSkillRoundEffect:del()
											hGlobal.UI.GuideLvUpSkillRoundEffect = nil
										end
										
										--删除提示点击技能升级按钮的手的特效
										if hGlobal.UI.GuideLvUpSkillHandEffect then
											hGlobal.UI.GuideLvUpSkillHandEffect:del()
											hGlobal.UI.GuideLvUpSkillHandEffect = nil
										end
										
										--创建英雄详细界面积分升级按钮（假的）（挡操作用）
										_childUI["btnSkillLvUp_Fake2"] = hUI.button:new({
											parent = _parent,
											model = "UI:BTN_ButtonRed", 
											animation = "normal",
											dragbox = _childUI["dragBox"],
											font = hVar.FONTC,
											border = 1,
											align = "MC",
											label = hVar.tab_string["__UPGRADE"],
											--y = -455,
											--scale = 1,
											x = 465,
											y = -490,
											scale = 1,
											scaleT = 0.99,
											code = function(self)
												--
											end,
										})
										
										--删除之前的关闭按钮
										hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake") --英雄详细界面关闭按钮（假的）（挡操作用）
										
										--创建新的关闭按钮
										--英雄详细界面关闭按钮（假的）（引导用）
										local _w,_h = 892, 558
										local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 20
										
										local closeDx = -5
										local closeDy = -5
										if (g_phone_mode ~= 0) then
											closeDx = 0
											closeDy = -20
										end
										_childUI["btnClose_Fake2"] = hUI.button:new({
											parent = _frm,
											model = "BTN:PANEL_CLOSE",
											x = _w + closeDx,
											y = closeDy,
											z = 5,
											scaleT = 0.99,
											code = function(self)
												--点击关闭英雄界面按钮
												--关闭英雄界面
												_frm:show(0)
												hApi.safeRemoveT(_childUI, "HeroInfoiconImg")
												hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
												
												--触发事件：关闭了主菜单按钮
												hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
												
												--删除控件
												--删除之前的关闭按钮
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake2") --英雄详细界面关闭按钮（假的）（引导用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnStarLvUp_Fake") --英雄详细界面升星按钮（假的）（挡操作用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_R_Fake") --英雄详细界面翻页按钮下（假的）（挡操作用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_L_Fake") --英雄详细界面翻页按钮上（假的）（挡操作用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnItem_Fake") --英雄详细界面道具按钮（假的）（挡操作用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkill_Fake") --英雄详细界面技能按钮（假的）（挡操作用）
												hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake2") --英雄详细界面积分升级按钮（假的）（挡操作用）
												
												--删除提示点击关闭按钮的转圈圈特效
												if hGlobal.UI.GuideCloseHeroRoundEffect then
													hGlobal.UI.GuideCloseHeroRoundEffect:del()
													hGlobal.UI.GuideCloseHeroRoundEffect = nil
												end
												
												--删除提示点击关闭按钮的手的特效
												if hGlobal.UI.GuideCloseHeroHandEffect then
													hGlobal.UI.GuideCloseHeroHandEffect:del()
													hGlobal.UI.GuideCloseHeroHandEffect = nil
												end
												
												--进入下个状态: 引导结束
												hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_END
												
												--对话：英雄界面引导完成
												__Dialogue_GuideHeroFrm_Introduce_GuideEnd()
											end,
										})
										
										--创建提示点击关闭按钮的转圈圈特效
										hGlobal.UI.GuideCloseHeroRoundEffect = hUI.image:new({
											parent = _parent,
											model = "MODEL_EFFECT:strengthen",
											x = _w + closeDx,
											y = closeDy,
											--w = 60,
											--h = 60 + 10,
											--scale = 2.0,
											w = 100,
											h = 100,
											scale = 1.0,
											z = 100,
										})
										hGlobal.UI.GuideCloseHeroRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
										hGlobal.UI.GuideCloseHeroRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
										local decal, count = 11, 0 --光晕效果
										local r, g, b, parent = 150, 128, 64
										local parent = hGlobal.UI.GuideCloseHeroRoundEffect.handle._n
										local offsetX, offsetY, duration, scale = 30, 33, 0.4, 1.05
										local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
										nnn:setScale(1.6)
										
										--创建提示点击关闭按钮的手的特效
										hGlobal.UI.GuideCloseHeroHandEffect = hUI.image:new({
											parent = _parent,
											x = _w + closeDx,
											y = closeDy - 30,
											model = "MODEL_EFFECT:Hand",
											scale = 1.3,
											z = 100,
										})
										hGlobal.UI.GuideCloseHeroHandEffect.handle.s:setRotation(180)
										
										--在升级技能后就标记引导英雄界面完成（防止升级后直接关闭窗口）
										--标记主城引导英雄界面完成
										LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
										
										--进入下个状态: 提示关闭英雄界面
										hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_CLOSE_HERO_UI
										
										--无对话
										--...
									end
									
									--进入下个状态: 提示点击技能升级按钮
									hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_LVUP_BUTTON
									
									--无对话
									--...
								end)
								
								--进入下个状态: 提示点击第一个技能按钮
								hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_SKILL_BUTTON
								
								--无对话
								--...
							end
							
							--如果存在道具，并且英雄身上没有道具，才会引导穿装备
							if (itemIdx > 0) and (heroEquippedNum == 0) then
								--创建提示选取道具转圈圈特效
								local orientRx = _w - 267 + 105
								if (g_phone_mode ~= 1) then --非平板模式
									orientRx = orientRx - 105
								end
								local orientRy = -114
								local OFFSET_X = 64
								local OFFSET_Y = -64
								hGlobal.UI.GuideClickItemRoundEffect = hUI.image:new({
									parent = _parent,
									model = "MODEL_EFFECT:strengthen",
									x = orientRx + (xIdx - 1) * OFFSET_X,
									y = orientRy + (yIdx - 1) * OFFSET_Y,
									--w = 60,
									--h = 60,
									--scale = 2.2,
									w = 100,
									h = 100,
									scale = 1.0,
									z = 100,
								})
								hGlobal.UI.GuideClickItemRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
								hGlobal.UI.GuideClickItemRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
								local decal, count = 11, 0 --光晕效果
								local r, g, b, parent = 150, 128, 64
								local parent = hGlobal.UI.GuideClickItemRoundEffect.handle._n
								local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
								local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
								nnn:setScale(1.5)
								
								local orientHx, orientHy = _w - 267 + 105, -114 --第一个背包格子的位置
								if (g_phone_mode ~= 1) then --非平板模式
									orientHx = orientHx - 105
								end
								local toHx, toHy  = orientHx - 87, orientHy + 63 --目标应该放到的位置
								local curHx = orientHx + (xIdx - 1) * OFFSET_X
								local curHy = orientHy + (yIdx - 1) * OFFSET_Y
								hGlobal.UI.GuideClickItemHandEffect = hUI.image:new({
									parent = _parent,
									model = "MODEL_EFFECT:HandStatic",
									x = curHx,
									y = curHy,
									scale = 1.0,
									z = 100,
								})
								hGlobal.UI.GuideClickItemHandEffect.handle.s:setRotation(180)
								--创建动画
								local aArray = CCArray:create()
								aArray:addObject(CCDelayTime:create(0.8))
								aArray:addObject(CCMoveTo:create(0.4, ccp(toHx, toHy)))
								aArray:addObject(CCDelayTime:create(0.6))
								aArray:addObject(CCMoveTo:create(0.01, ccp(curHx, curHy)))
								local seq = tolua.cast(CCSequence:create(aArray), "CCActionInterval")
								local node = hGlobal.UI.GuideClickItemHandEffect.handle._n
								node:runAction(CCRepeatForever:create(seq))
								
								--监听穿装备成功事件（不一定穿成功，有可能只是挪背包位置或者穿错栏位）
								hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", function()
									--检查刘备身上是否有装备，有装备才认为是成功
									local equipNum = 0
									local type_id = 18001 --刘备
									local HeroCard = hApi.GetHeroCardById(type_id)
									if HeroCard and (type(HeroCard) == "table") and HeroCard.equipment and (type(HeroCard.equipment) == "table") then
										for k = 1, #HeroCard.equipment, 1 do
											--存档里的装备表
											local item = HeroCard.equipment[k]
											
											if (type(item) == "table") then
												local item_id = item[1] --道具id
												
												if (item_id ~= 0) then
													equipNum = equipNum + 1
												end
											end
										end
									end
									
									--英雄身上有装备
									if (equipNum > 0) then --装备道具成功
										--移除监听出售道具事件
										hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
										--移除监听合成道具事件
										hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
										--删除监听排序道具事件
										hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
											
										--删除提示选取道具转圈圈特效
										if hGlobal.UI.GuideClickItemRoundEffect then
											hGlobal.UI.GuideClickItemRoundEffect:del()
											hGlobal.UI.GuideClickItemRoundEffect = nil
										end
										
										--删除提示选取道具的手的特效
										if hGlobal.UI.GuideClickItemHandEffect then
											hGlobal.UI.GuideClickItemHandEffect:del()
											hGlobal.UI.GuideClickItemHandEffect = nil
										end
										
										_CODE_GuideNext_Skill()
									else
										--因为挪动了背包，放到别的格子，所以刷新新的背包的位置并提示引导特效
										--删除提示选取道具转圈圈特效
										if hGlobal.UI.GuideClickItemRoundEffect then
											hGlobal.UI.GuideClickItemRoundEffect:del()
											hGlobal.UI.GuideClickItemRoundEffect = nil
										end
										
										--删除提示选取道具的手的特效
										if hGlobal.UI.GuideClickItemHandEffect then
											hGlobal.UI.GuideClickItemHandEffect:del()
											hGlobal.UI.GuideClickItemHandEffect = nil
										end
										
										--获取道具在哪个位置
										--创建提示滑动道具的手的特效
										local xIdx = 0 --x索引值
										local yIdx = 0 --y索引值
										local itemIdx = 0
										local item = LuaGetPlayerBagFromTableIndex(1)
										for k = 1, 28, 1 do
											if item[k] and (item[k] ~= 0) then
												itemIdx = k
												break
											end
										end
										if (itemIdx > 0) then
											xIdx = itemIdx % 4
											if (xIdx == 0) then
												xIdx = 4
											end
											yIdx = (itemIdx - xIdx) / 4 + 1
										end
										
										--创建提示选取道具转圈圈特效
										local orientRx = _w - 267 + 105
										if (g_phone_mode ~= 1) then --非平板模式
											orientRx = orientRx - 105
										end
										local orientRy = -114
										local OFFSET_X = 64
										local OFFSET_Y = -64
										hGlobal.UI.GuideClickItemRoundEffect = hUI.image:new({
											parent = _parent,
											model = "MODEL_EFFECT:strengthen",
											x = orientRx + (xIdx - 1) * OFFSET_X,
											y = orientRy + (yIdx - 1) * OFFSET_Y,
											--w = 60,
											--h = 60,
											--scale = 2.2,
											w = 100,
											h = 100,
											scale = 1.0,
											z = 100,
										})
										hGlobal.UI.GuideClickItemRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
										hGlobal.UI.GuideClickItemRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
										local decal, count = 11, 0 --光晕效果
										local r, g, b, parent = 150, 128, 64
										local parent = hGlobal.UI.GuideClickItemRoundEffect.handle._n
										local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
										local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
										nnn:setScale(1.5)
										
										local orientHx, orientHy = _w - 267 + 105, -114  --第一个背包格子的位置
										if (g_phone_mode ~= 1) then --非平板模式
											orientHx = orientHx - 105
										end
										local toHx, toHy  = orientHx - 87, orientHy + 63 --目标应该放到的位置
										local curHx = orientHx + (xIdx - 1) * OFFSET_X
										local curHy = orientHy + (yIdx - 1) * OFFSET_Y
										hGlobal.UI.GuideClickItemHandEffect = hUI.image:new({
											parent = _parent,
											model = "MODEL_EFFECT:HandStatic",
											x = curHx,
											y = curHy,
											scale = 1.0,
											z = 100,
										})
										hGlobal.UI.GuideClickItemHandEffect.handle.s:setRotation(180)
										--创建动画
										local aArray = CCArray:create()
										aArray:addObject(CCDelayTime:create(0.8))
										aArray:addObject(CCMoveTo:create(0.4, ccp(toHx, toHy)))
										aArray:addObject(CCDelayTime:create(0.6))
										aArray:addObject(CCMoveTo:create(0.01, ccp(curHx, curHy)))
										local seq = tolua.cast(CCSequence:create(aArray), "CCActionInterval")
										local node = hGlobal.UI.GuideClickItemHandEffect.handle._n
										node:runAction(CCRepeatForever:create(seq))
									end
								end)
								
								--监听出售道具事件，也进入下个流程
								hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", function()
									--移除监听出售道具事件
									hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
									--移除监听合成道具事件
									hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
									--删除监听排序道具事件
									hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
									
									--删除提示选取道具转圈圈特效
									if hGlobal.UI.GuideClickItemRoundEffect then
										hGlobal.UI.GuideClickItemRoundEffect:del()
										hGlobal.UI.GuideClickItemRoundEffect = nil
									end
									
									--删除提示选取道具的手的特效
									if hGlobal.UI.GuideClickItemHandEffect then
										hGlobal.UI.GuideClickItemHandEffect:del()
										hGlobal.UI.GuideClickItemHandEffect = nil
									end
									
									_CODE_GuideNext_Skill()
								end)
								
								--监听合成道具事件，也进入下个流程
								hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", function()
									--移除监听出售道具事件
									hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
									--移除监听合成道具事件
									hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
									--删除监听排序道具事件
									hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
									
									--删除提示选取道具转圈圈特效
									if hGlobal.UI.GuideClickItemRoundEffect then
										hGlobal.UI.GuideClickItemRoundEffect:del()
										hGlobal.UI.GuideClickItemRoundEffect = nil
									end
									
									--删除提示选取道具的手的特效
									if hGlobal.UI.GuideClickItemHandEffect then
										hGlobal.UI.GuideClickItemHandEffect:del()
										hGlobal.UI.GuideClickItemHandEffect = nil
									end
									
									_CODE_GuideNext_Skill()
								end)
								
								--进入下个状态: 提示英雄穿装备
								hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_EQIPMENT_INTRODUCE
								
								--无对话
								--...
							else --无道具（说明之前已经引导过了）（上次意外退出）
								_CODE_GuideNext_Skill()
							end
						end)
						
						--进入下个状态: 提示英雄界面介绍
						hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE
						
						--无对话
						--...
					--[[
					--geyachao: 旧版有主城模式
					end)
					
					--模拟执行点击大地图事件
					
					oMap.data.codeOnTouchUp(oMap, worldX, worldY, clickScreenX, clickScreenY)
					]]
					
					--进入下个状态: 提示英雄界面介绍
					hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE
					
					--无对话
					--...
				end
			end
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE) then --提示英雄界面介绍
			--该状态会监听英雄卡片点击事件后，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_EQIPMENT_INTRODUCE) then --提示英雄穿装备
			--该状态会监听英雄穿装备事件后，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_SKILL_BUTTON) then --提示点击第一个英雄技能按钮
			--该状态会监听点击英雄技能事件里，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_LVUP_BUTTON) then --提示点击技能升级按钮
			--该状态会监听点击技能升级事件里，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_CLOSE_HERO_UI) then --提示点击关闭英雄界面
			--该状态会监听关闭按钮点击事件，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--在升级技能后就标记引导英雄界面完成（防止升级后直接关闭窗口）
			--标记主城引导英雄界面完成
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导英雄界面")
			
			--因为要触发下一个主城的引导任务成就的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
		end
	end
	
	--开始引导主城查看英雄界面和穿装、升级技能
	function BeginGuideHeroFrm()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --界面
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--标记主城引导英雄界面完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			
			--因为要触发下一个主城的引导任务成就的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.NONE) then --初始状态
				--hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideHeroFrmFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "点将台操作指导")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建大地图对话
	local function __createMapTalkHeroFrm(flag, talkType, _func, ...)
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
	
	--显示对话框：引导主城英雄界面点将台介绍
	function __Dialogue_GuideHeroFrm_DianJiangTaiIntroduce()
		print("显示对话框：引导主城英雄界面点将台介绍")
		__createMapTalkHeroFrm("step1", "$_001_lsc_27", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	--显示对话框：引导主城英雄界面点击点将台按钮
	function __Dialogue_GuideHeroFrm_Click_DianJiangTai()
		print("显示对话框：引导主城英雄界面点击点将台按钮")
		__createMapTalkHeroFrm("step2", "$_001_lsc_28", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	
	--显示对话框：引导主城英雄界面引导完成
	function __Dialogue_GuideHeroFrm_Introduce_GuideEnd()
		print("显示对话框：引导主城英雄界面引导完成")
		__createMapTalkHeroFrm("step3", "$_001_lsc_29", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	--开始引导第二关升级塔高级技能
	BeginGuideHeroFrm()
end

--test
--测试主城引导点将台、穿装备、升级技能
--CreateGuideFrame_HeroFrm()




























--创建主城引导点击第二关战斗
function CreateGuideMap002_Frm()
	--主城引导点击第二关战斗状态集
	hGlobal.UI.GuideMap002StateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_INTRODUCE_MAP02 = 1, --提示介绍开始第二关
		GUIDE_WAIT_JUQING_BTN = 2, --等待点击主城的剧情按钮
		GUIDE_CLICK_MAP02 = 3, --提示点击第二关按钮
		GUIDE_WAIT_MAP2_BTN = 4, --等待点击第二关按钮
		GUIDE_CLICK_BATTLE = 5, --提示点击开始战斗按钮
		GUIDE_END = 6, --引导结束
	}

	--引导的当前状态
	hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideDJTHandEffect then --提示点击点将台的手的特效
		hGlobal.UI.GuideDJTHandEffect:del()
		hGlobal.UI.GuideDJTHandEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardHandEffect then --提示点击英雄卡片的手的特效
		hGlobal.UI.GuideClickHeroCardHandEffect:del()
		hGlobal.UI.GuideClickHeroCardHandEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardRoundEffect then --提示点击英雄卡片的转圈圈特效
		hGlobal.UI.GuideClickHeroCardRoundEffect:del()
		hGlobal.UI.GuideClickHeroCardRoundEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnStarLvUp_Fake") --英雄详细界面升星按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake") --英雄详细界面关闭按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_R_Fake") --英雄详细界面翻页按钮下（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_L_Fake") --英雄详细界面翻页按钮上（假的）（挡操作用）
	if hGlobal.UI.GuideClickItemRoundEffect then --提示选取道具转圈圈特效
		hGlobal.UI.GuideClickItemRoundEffect:del()
		hGlobal.UI.GuideClickItemRoundEffect = nil
	end
	if hGlobal.UI.GuideClickItemHandEffect then --提示选取道具的手的特效
		hGlobal.UI.GuideClickItemHandEffect:del()
		hGlobal.UI.GuideClickItemHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnItem_Fake") --英雄详细界面道具按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkill_Fake") --英雄详细界面技能按钮（假的）（挡操作用）
	if hGlobal.UI.GuideClickSkillRoundEffect then --提示点击第一个技能图标的转圈圈特效
		hGlobal.UI.GuideClickSkillRoundEffect:del()
		hGlobal.UI.GuideClickSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideClickSkillHandEffect then --提示点击第一个技能图标的手特效
		hGlobal.UI.GuideClickSkillHandEffect:del()
		hGlobal.UI.GuideClickSkillHandEffect = nil
	end
	if hGlobal.UI.GuideLvUpSkillRoundEffect then --提示点击技能升级按钮的转圈圈特效
		hGlobal.UI.GuideLvUpSkillRoundEffect:del()
		hGlobal.UI.GuideLvUpSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideLvUpSkillHandEffect then --提示点击技能升级按钮的手的特效
		hGlobal.UI.GuideLvUpSkillHandEffect:del()
		hGlobal.UI.GuideLvUpSkillHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake2") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake2") --英雄详细界面关闭按钮（假的）（引导用）
	if hGlobal.UI.GuideCloseHeroRoundEffect then --提示点击关闭按钮的转圈圈特效
		hGlobal.UI.GuideCloseHeroRoundEffect:del()
		hGlobal.UI.GuideCloseHeroRoundEffect = nil
	end
	if hGlobal.UI.GuideCloseHeroHandEffect then --提示点击关闭按钮的手的特效
		hGlobal.UI.GuideCloseHeroHandEffect:del()
		hGlobal.UI.GuideCloseHeroHandEffect = nil
	end
	if hGlobal.UI.GuideTownHandEffect then --点击剧情战役的手的特效
		hGlobal.UI.GuideTownHandEffect:del()
		hGlobal.UI.GuideTownHandEffect = nil
	end
	if hGlobal.UI.GuideMap002RoundEffect then --点击第二关的手的特效
		hGlobal.UI.GuideMap002RoundEffect:del()
		hGlobal.UI.GuideMap002RoundEffect = nil
	end
	if hGlobal.UI.BeginBattleHandEffect2 then --提示点击开始战斗的手的特效
		hGlobal.UI.BeginBattleHandEffect2:del()
		hGlobal.UI.BeginBattleHandEffect2 = nil
	end
	if hGlobal.UI.BeginBattleRoundEffect2 then --提示开始战斗的转圈圈特效
		hGlobal.UI.BeginBattleRoundEffect2:del()
		hGlobal.UI.BeginBattleRoundEffect2 = nil
	end
	if hGlobal.UI.CoverInterface2 then --挡操作界面
		hGlobal.UI.CoverInterface2:del()
		hGlobal.UI.CoverInterface2 = nil
	end
	
	if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
		hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
		hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
	end
	
	--创建引导英雄界面的引导主界面
	--创建父容器
	hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
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
				OnClickGuideMap002Frame_Event(screenX, screenY)
			end
		end
	})
	--hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
	
	--点击引导第二关升级塔高级技能的事件
	function OnClickGuideMap002Frame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导第二关升级塔高级技能")
			
			--geyachao: 旧版主城模式的引导
			--[[
			
			--进入下个状态: 提示开始第二关
			hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_INTRODUCE_MAP02
			
			
			--显示对话框：提示点击第二关的对话
			__Dialogue_GuideMap002_Click_Map002()
			]]
			
			--进入下个状态: 提示点击第二关按钮
			hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_MAP02
			
			
			--显示对话框：提示点击第二关的对话
			__Dialogue_GuideMap002_Click_Map002()
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_INTRODUCE_MAP02) then --介绍开始第二关
			--找到剧情战役角色
			local oMap = __G_MainMenuWorld --主界面地图
			local tAllChaHandle = oMap.data.chaHandle
			local townTypeId = 60005 --剧情战役角色类型id
			local tChaJuQingHandle = nil --剧情战役单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == townTypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaJuQingHandle = tChaHandle
					break
				end
			end
			
			local towerScreenX, towerScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建提示点击剧情战役按钮的手特效
			hGlobal.UI.GuideTownHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = towerScreenX,
				y = towerScreenY + 80,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideTownHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--剧情战役单位描边
			local program = hApi.getShader("outline")
			tChaJuQingHandle.s:setShaderProgram(program)
			local act1 = CCFadeTo:create(0.5, 168)
			local act2 = CCFadeTo:create(0.5, 255)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			tChaJuQingHandle.s:runAction(CCRepeatForever:create(sequence))
			--[[
			local act1 = CCDelayTime:create(0.5)
			local act2 = CCCallFunc:create(function()
				local program = hApi.getShader("outline")
				tChaJuQingHandle.s:setShaderProgram(program)
			end)
			local sequence12 = CCSequence:createWithTwoActions(act1, act2)
			local act3 = CCDelayTime:create(0.5)
			local act4 = CCCallFunc:create(function()
				local program = hApi.getShader("normal")
				tChaJuQingHandle.s:setShaderProgram(program)
			end)
			local sequence34 = CCSequence:createWithTwoActions(act3, act4)
			local sequence = CCSequence:createWithTwoActions(sequence12, sequence34)
			hGlobal.UI.GuideTownHandEffect.handle._n:runAction(CCRepeatForever:create(sequence))
			]]
			--进入下个状态: 等待点击剧情战役按钮
			hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_WAIT_JUQING_BTN
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_WAIT_JUQING_BTN) then --等待点击剧情战役按钮
			--检测是否点击到了剧情战役按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oMap = __G_MainMenuWorld --主界面地图
			local tChaJuQingHandle = oMap:hit2cha(worldX, worldY)
			local townTypeId = 60005 --剧情战役角色类型id
			if tChaJuQingHandle then
				if (tChaJuQingHandle.data.id == townTypeId) then
					--删除提示点击剧情战役按钮的手特效
					if hGlobal.UI.GuideTownHandEffect then --点击剧情战役的手的特效
						hGlobal.UI.GuideTownHandEffect:del()
						hGlobal.UI.GuideTownHandEffect = nil
					end
					
					--停止剧情战役单位的运动
					tChaJuQingHandle.s:stopAllActions()
					--剧情战役单位不描边
					local program = hApi.getShader("normal")
					tChaJuQingHandle.s:setShaderProgram(program)
					
					--进入下个状态: 提示点击第二关按钮
					hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_MAP02
					
					--模拟执行点击大地图事件
					oMap.data.codeOnTouchUp(oMap, worldX, worldY, clickScreenX, clickScreenY)
					
					--强制跳转到下个状态
					OnClickGuideMap002Frame_Event(0, 0)
				end
			end
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_MAP02) then --提示点击第二关按钮
			--找到第二关角色
			local oSelectMap = __G_SelectMapWorld --选关卡地图
			local tAllChaHandle = oSelectMap.data.chaHandle
			local map002TypeId = 60101 --第二关角色类型id
			local tChaMap001Handle = nil --第一关角色单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == map002TypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaMap001Handle = tChaHandle
					break
				end
			end
			
			local map002ScreenX, map002ScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建引导点击第二关按钮的转圈圈特效
			hGlobal.UI.GuideMap002RoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = map002ScreenX,
				y = map002ScreenY - 5,
				--w = 128,
				--h = 128,
				--scale = 1.0,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideMap002RoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideMap002RoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideMap002RoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--创建提示点击第二关按钮的手特效
			hGlobal.UI.GuideMap002HandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = map002ScreenX,
				y = map002ScreenY + 40,
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideMap001HandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击第二关按钮
			hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_WAIT_MAP2_BTN
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_WAIT_MAP2_BTN) then --等待点击第二关按钮
			--检测是否点击到了第二关按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oSelectMap = __G_SelectMapWorld --选关卡地图
			local tChaMap001Handle = oSelectMap:hit2cha(worldX, worldY)
			local map002TypeId = 60101 --第二关角色类型id
			if tChaMap001Handle then
				if (tChaMap001Handle.data.id == map002TypeId) then
					--删除提示点击第二关按钮的手特效
					if hGlobal.UI.GuideMap002HandEffect then --点击第二关的手的特效
						hGlobal.UI.GuideMap002HandEffect:del()
						hGlobal.UI.GuideMap002HandEffect = nil
					end
					
					--删除提示点击第二关按钮的转圈圈特效
					if hGlobal.UI.GuideMap002RoundEffect then --点击第二关的转圈圈的特效
						hGlobal.UI.GuideMap002RoundEffect:del()
						hGlobal.UI.GuideMap002RoundEffect = nil
					end
					
					--模拟执行点击选择关卡事件
					oSelectMap.data.codeOnTouchUp(oSelectMap, worldX, worldY, clickScreenX, clickScreenY)
					
					--创建一个挡操作的界面
					hGlobal.UI.CoverInterface2 = hUI.frame:new({
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
								OnClickGuideMap002Frame_Event(screenX, screenY)
							end
						end
					})
					
					--本界面最前端显示
					hGlobal.UI.CoverInterface2:active()
					
					--创建提示点击开始战斗的转圈圈特效
					local _frm = hGlobal.UI.PhoneMapInfoFrm
					local begin_y = 140
					if (g_phone_mode ~= 0) then --非平板模式
						begin_y = 76
					end
					hGlobal.UI.BeginBattleRoundEffect2 = hUI.image:new({
						parent = hGlobal.UI.CoverInterface2.handle._n,
						model = "MODEL_EFFECT:strengthen",
						x = _frm.data.x + _frm.data.w * 0.5,
						y = begin_y,
						--w = 400,
						w = 100,
						h = 100,
						scale = 1.0,
						z = 100,
					})
					hGlobal.UI.BeginBattleRoundEffect2.handle.s:setColor(ccc3(0, 255, 0)) --绿色
					hGlobal.UI.BeginBattleRoundEffect2.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
					local decal, count = 11, 0 --光晕效果
					local r, g, b, parent = 150, 128, 64
					local parent = hGlobal.UI.BeginBattleRoundEffect2.handle._n
					local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
					local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
					nnn:setScale(1.5)
					
					--创建提示点击开始战斗的手特效
					hGlobal.UI.BeginBattleHandEffect2 = hUI.image:new({
						parent = hGlobal.UI.CoverInterface2.handle._n,
						model = "MODEL_EFFECT:Hand",
						x = _frm.data.x + _frm.data.w * 0.5,
						y = begin_y + 40,
						scale = 1.5,
						z = 100,
					})
					--hGlobal.UI.BeginBattleHandEffect2.handle.s:setColor(ccc3(0, 255, 0)) --绿色
					
					--进入下个状态: 提示点击进入战役按钮
					hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_BATTLE
					
					--无对话
					--...
				end
			end
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_BATTLE) then --提示点击进入战役按钮
			--检测是否点到了开始战斗按钮里面
			local _frm = hGlobal.UI.PhoneMapInfoFrm
			local begin_y = 140
			if (g_phone_mode ~= 0) then --非平板模式
				begin_y = 76
			end
			local x = _frm.data.x + _frm.data.w * 0.5
			local y = begin_y
			local w = 400
			local h = 100
			local left = x - w / 2
			local right = x + w / 2
			local top = y - h / 2
			local bottom = y + h / 2
			if (clickScreenX >= left) and (clickScreenX <= right) and (clickScreenY >= top) and (clickScreenY <= bottom) then
				--删除提示开始战斗的手的特效
				if hGlobal.UI.BeginBattleHandEffect2 then
					hGlobal.UI.BeginBattleHandEffect2:del()
					hGlobal.UI.BeginBattleHandEffect2 = nil
				end
				
				--删除提示开始战斗的转圈圈特效
				if hGlobal.UI.BeginBattleRoundEffect2 then
					hGlobal.UI.BeginBattleRoundEffect2:del()
					hGlobal.UI.BeginBattleRoundEffect2 = nil
				end
				
				--删除挡操作的界面
				if hGlobal.UI.CoverInterface2 then
					hGlobal.UI.CoverInterface2:del()
					hGlobal.UI.CoverInterface2 = nil
				end
				
				--进入下个状态: 引导结束
				hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_END
				
				--无对话
				--...
				
				--强制触发下一状态
				OnClickGuideMap002Frame_Event(0, 0)
			end
		elseif (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导第二关升级塔高级技能")
			
			--模拟点击开始战斗按钮
			local _frm = hGlobal.UI.PhoneMapInfoFrm
			local _parent = _frm.handle._n
			local _childUI = _frm.childUI
			_childUI["gameStart"].data.code(_childUI["gameStart"])
			
			--这里在第二关打完了再统一设置状态完成
			--标记主城引导英雄界面完成
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4)
		end
	end
	
	--开始引导第二关
	function BeginGuideMap002()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --界面
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--标记引导挑战第二关完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.GuideMap002State == hGlobal.UI.GuideMap002StateType.NONE) then --初始状态
				--hGlobal.UI.GuideMap002State = hGlobal.UI.GuideMap002StateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideMap002Frame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "挑战第二关")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建大地图对话
	local function __createMapTalkHeroFrm(flag, talkType, _func, ...)
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
	
	--显示对话框：提示点击第二关的对话
	function __Dialogue_GuideMap002_Click_Map002()
		print("显示对话框：提示点击第二关的对话")
		__createMapTalkHeroFrm("step4", "$_001_lsc_30", OnClickGuideMap002Frame_Event, 0, 0)
	end
	
	--开始引导第二关开始
	BeginGuideMap002()
end

--test
--测试主城引导点击第二关
--CreateGuideMap002_Frm()











--创建第二关的引导游戏结束退出
function CreateGuideFrame_Map002End()
	--第二关结束引导退出和穿装备的状态集
	hGlobal.UI.Guide002EndStateType =
	{
		NONE = 0, --初始状态
		GUIDE_INTRODUCE = 1, --开场简介
		GUIDE_CLICK_CLOSE_BUTTON = 2, --提示点击关闭按钮
		GUIDE_END = 3, --引导结束
		GUIDE_DELETE = 4, --本界面已删除
	}

	--引导的当前状态
	hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideCloseButton then --关闭按钮
		hGlobal.UI.GuideCloseButton:del()
		hGlobal.UI.GuideCloseButton = nil
	end
	if hGlobal.UI.GuideClickCloseEffect then --提示关闭按钮的手的特效
		hGlobal.UI.GuideClickCloseEffect:del()
		hGlobal.UI.GuideClickCloseEffect = nil
	end
	if hGlobal.UI.GuideClickCloseRoundEffect then --提示关闭按钮的转圈圈特效
		hGlobal.UI.GuideClickCloseRoundEffect:del()
		hGlobal.UI.GuideClickCloseRoundEffect = nil
	end
	if hGlobal.UI.GuideDJTHandEffect then --提示点击点将台的手的特效
		hGlobal.UI.GuideDJTHandEffect:del()
		hGlobal.UI.GuideDJTHandEffect = nil
	end
	
	if hGlobal.UI.GuideSelect002EndMenuBar then --引导升级塔高级技能的
		hGlobal.UI.GuideSelect002EndMenuBar:del()
		hGlobal.UI.GuideSelect002EndMenuBar = nil
	end
	
	--创建引导升级塔高级技能的界面
	--创建父容器
	hGlobal.UI.GuideSelect002EndMenuBar = hUI.frame:new({
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
				OnClickGuide002EndFrame_Event(screenX, screenY)
			end
		end
	})
	--hGlobal.UI.GuideSelect002EndMenuBar:active() --最前端显示
	
	--点击引导第二关升级塔高级技能的事件
	function OnClickGuide002EndFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导第二关升级塔高级技能")
			
			--进入下个状态: 开场简介
			hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_INTRODUCE
			
			--显示对话框：引导第二关结束升级塔高级技能介绍
			__Dialogue_Guide002End_Introduce()
		elseif (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.GUIDE_INTRODUCE) then --提示第二关结束简介
			local w, h = hVar.SCREEN.w+10, hVar.SCREEN.h
			local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
			local scale = 1
			local btnScale = 0.9							--按钮缩放
			local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
			
			local nScreenY = 0							--根据机器类型（手机，平板）调正整体位置
			if 0 == g_phone_mode then
				nScreenY = -70
			end
			local nButtonX, nButtonY  = x + w/2, y + nScreenY-410
			--“主界面”关闭按钮
			hGlobal.UI.GuideCloseButton = hUI.button:new({
				parent = nil,
				dragbox = hGlobal.UI.GuideSelect002EndMenuBar.childUI["dragBox"],
				model = "UI:ButtonBack",
				icon = "ui/hall.png",
				iconWH = 28,
				label = " "..hVar.tab_string["__TEXT_MainInterface"],
				font = hVar.FONTC,
				border = 1,
				align = "MC",
				scaleT = 0.99,
				x = nButtonX + 140,
				y = nButtonY - 200 + 25,
				z = 100,
				scale = btnScale,
				code = function(self)
					--删除控件
					--删除关闭按钮
					if hGlobal.UI.GuideCloseButton then
						hGlobal.UI.GuideCloseButton:del()
						hGlobal.UI.GuideCloseButton = nil
					end
					
					--删除提示关闭按钮的手的特效
					if hGlobal.UI.GuideClickCloseEffect then
						hGlobal.UI.GuideClickCloseEffect:del()
						hGlobal.UI.GuideClickCloseEffect = nil
					end
					
					--删除提示关闭按钮的转圈圈特效
					if hGlobal.UI.GuideClickCloseRoundEffect then
						hGlobal.UI.GuideClickCloseRoundEffect:del()
						hGlobal.UI.GuideClickCloseRoundEffect = nil
					end
					
					--进入下个状态: 引导结束
					hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_END
					
					--无对话
					--...
					
					--强制到下一状态
					OnClickGuide002EndFrame_Event(0, 0)
				end,
			})
			--_childUI["btnOk"]:setstate(-1)
			hGlobal.UI.GuideCloseButton.childUI["label"].handle._n:setPosition(-35,12)
			hGlobal.UI.GuideCloseButton.childUI["icon"].handle._n:setPosition(-60,1)
		
			--创建点击关闭按钮的手特效
			hGlobal.UI.GuideClickCloseEffect = hUI.image:new({
				parent = nil,
				x = nButtonX + 140,
				y = nButtonY - 200 + 55,
				model = "MODEL_EFFECT:Hand",
				scale = 1.3,
				z = 100,
			})
			--hGlobal.UI.GuideClickCloseEffect.handle.s:setRotation(-30)
			
			--创建关闭按钮转圈圈特效
			hGlobal.UI.GuideClickCloseRoundEffect = hUI.image:new({
				parent = nil,
				model = "MODEL_EFFECT:strengthen",
				x = nButtonX + 140,
				y = nButtonY - 200 + 27,
				--w = 180,
				--h = 50,
				--scale = 2.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideClickCloseRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideClickCloseRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideClickCloseRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.5)
			
			--进入下个状态: 提示点击关闭按钮
			hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_CLICK_CLOSE_BUTTON
			
			--无对话
			--...
		elseif (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.GUIDE_CLICK_CLOSE_BUTTON) then --提示点击关闭按钮
			--在按钮点击事件中处理，这里不做处理
			--...
		
		elseif (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideSelect002EndMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideSelect002EndMenuBar:del()
				hGlobal.UI.GuideSelect002EndMenuBar = nil
			end
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导第二关升级塔高级技能")
			
			--注意：这4个标记在第二关第一次胜利的时候已经标记过了
			--引导打第二关、第二关开始前引导、第二关开始引导、第二关结束引导
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
			--LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
			--LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
			--LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3)
			
			--隐藏胜利界面
			hGlobal.UI.__GameOverPanel:show(0)
			hUI.Disable(0,"离开游戏")
			
			--删除world
			--zhenkira 注释
			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
				--	print(".."..nil)
				--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				--end
				hGlobal.WORLD.LastWorldMap:del()
			end
			
			--zhenkira 新增
			hGlobal.LocalPlayer:setfocusworld(nil)
			--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
			
			--进入下个状态: 本界面已删除
			hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_DELETE
		elseif (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.GUIDE_DELETE) then --本界面已删除
			--...
		end
	end
	
	--开始引导第二关结束
	function BeginGuide002End()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideSelect002EndMenuBar then --界面
				hGlobal.UI.GuideSelect002EndMenuBar:del()
				hGlobal.UI.GuideSelect002EndMenuBar = nil
			end
			
			--标记引导第二关结束后的操作完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.Guide002EndState == hGlobal.UI.Guide002EndStateType.NONE) then --初始状态
				--hGlobal.UI.Guide002EndState = hGlobal.UI.Guide002EndStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuide002EndFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "挑战第二关完成")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建游戏内的对话
	local function __createTalkMap002End(talkType, _func, ...)
		local arg = {...}
		local world = hGlobal.WORLD.LastWorldMap
		local mapInfo = world.data.tdMapInfo
		local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,talkType)
		if vTalk then
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
	
	--显示对话框：引导第二关结束的简介
	function __Dialogue_Guide002End_Introduce()
		print("显示对话框：引导第二关结束的简介")
		__createTalkMap002End("mapGuid27", OnClickGuide002EndFrame_Event, 0, 0)
	end
	
	--开始引导第二关结束的介绍
	BeginGuide002End()
end

--test
--测试第二关的引导游戏结束退出
--CreateGuideFrame_Map002End()




