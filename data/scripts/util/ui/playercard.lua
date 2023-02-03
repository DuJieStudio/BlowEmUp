--积分存取功能函数 来自互联网
local bit={data32={}}
for i=1,32 do
    bit.data32[i]=2^(32-i)
end

function bit:d2b(arg)
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end   --bit:d2b

function bit:b2d(arg)
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end   --bit:b2d

--------------------------------
-- 玩家卡片 数据结构定义 以及相关数据的操作
--------------------------------
local _MapName = 1		--玩家信息成就中的 地图名 index
local _Achievement = 2		--玩家信息成就中的 成就列表 index
local _matLen = 3		--玩家材料背包数据长度
--local _ItemLen = 96		--玩家仓库总长度
--local _ItemMiniLen = 16		--每一个分页的背包长度
local _ItemMiniLen = hVar.PLAYERBAG_X_NUM * hVar.PLAYERBAG_Y_NUM --每一个分页的背包长度
local _ItemLen = 30 * 5 --玩家仓库总长度
local _medalLen = 100		--玩家勋章长度
local _giftLen = 10		--玩家礼品长度
local _giftbagLen = 40		--玩家礼品背包的长度 超出这个长度的 道具会丢失
local _MaxPlayerScore = 999999	--玩家的最大积分上限
local _MaxMatVal = 9999		--玩家的最大材料数
local _MaxItemLevel =	5	--物品等级最大值
local _MaxActiveBattlefieldSkill = 3	--玩家可以激活的最大战术技能个数

local _AchievementList = {}
for k,v in pairs(hVar.ACHIEVEMENT_TYPE) do
	_AchievementList[v] = 0
end


--存档等兼容函数
SaveModifyFunc = {}
--替换地图名字
SaveModifyFunc["mapName"] = function(oldName,lv)
	for k,v in pairs(hVar.MAP_INFO) do
		if v.level then
			if v.oldname == oldName or lv == v.level then
				oldName = k
			end
		end
	end
	return oldName
end
SaveModifyFunc["medalTab"] = function(medalTab)
	--如果初始长度小于的情况
	if #medalTab < _medalLen then
		for i = #medalTab,_medalLen do
			medalTab[#medalTab+1] = 0
		end
	end

end


--英雄表数据格式升级函数
SaveModifyFunc["herolist_EXATTR"] = function(heroInfo)
	--额外升级点数
	if heroInfo.ex_AttrPoint == nil then
		heroInfo.ex_AttrPoint = 0
	end
	--额外升级点数表
	if heroInfo.ex_Attr == nil then
		heroInfo.ex_Attr = {
			lea=0,
			led=0,
			str=0,
			int=0,
			con=0,
		}
	end
end

--英雄表数据格式升级函数 - 卡片等级
SaveModifyFunc["herolist_cardLv"] = function(heroInfo)
	--额外升级点数
	if heroInfo.cardLv == nil or heroInfo.cardLv == 0 then
		heroInfo.cardLv = 1
	end
end

--升级战术技能表数据 第三项 战术技能个数
SaveModifyFunc["battlefieldskillbook_Num"] = function(battlefieldskillbook)
	if type(battlefieldskillbook) == "table" then
		for i = 1,#battlefieldskillbook do
			if battlefieldskillbook[i][3] == nil then 
				battlefieldskillbook[i][3] = 1
			end
		end
	end
end

--修改试炼地图的成就长度 从原来的 3 扩展至 15
SaveModifyFunc["ACHIEVEMENTEX"] = function(achievementEx)
	if type(achievementEx) == "table" then
		for i = 1,#achievementEx do
			for j = 1,#achievementEx[i][_Achievement] do
				if type(achievementEx[i][_Achievement][j]) == "table" then
					achievementEx[i][_Achievement][j] = 1
				end
			end
			--判断试炼地图长度
			if #achievementEx[i][_Achievement] < #_AchievementList then
				for j = #achievementEx[i][_Achievement]+1,#_AchievementList do
					achievementEx[i][_Achievement][j] = 0
				end
			end
		end
	end
end

SaveModifyFunc["ACHIEVEMENT"] = function(achievement)
	if type(achievement) == "table" then
		for i = 1,#achievement do
			for j = 1,#achievement[i][_Achievement] do
				if type(achievement[i][_Achievement][j]) == "table" then
					achievement[i][_Achievement][j] = 1
				end
			end
		end
	end
end

--修改试炼地图的成就长度 从原来的 3 扩展至 18
--SaveModifyFunc["ACHI"] = function(achievementEx)
--	if type(achievementEx) == "table" then
--		for i = 1,#achievementEx do
--			--判断试炼地图长度
--			if type(achievementEx[i]) == "table" then
--				if #achievementEx[i][_Achievement] < #_AchievementList then
--					for j = #achievementEx[i][_Achievement]+1,#_AchievementList do
--						achievementEx[i][_Achievement][j] = 0
--					end
--				end
--			end
--		end
--	end
--end

--格式化地图成就的总入口，格式判断 添删改
SaveModifyFunc["ACHI"] = function(achievement)
	if type(achievement) == "table" then
		for i = 1,#achievement do
			if type(achievement[i]) == "table" then
				--对地图成就格式进行判断 如果第一个值是 地图名首先进行格式转换否则 则直接对成就长短进行判断增加新增内容
				if type(achievement[i][_MapName]) == "string" then
					local tempAchi = hApi.ReadParamWithDepth(achievement[i][_Achievement],nil,{},3)
					achievement[i] = {}
					achievement[i] = tempAchi
				end
				--增加缺少的地图成就
				if #achievement[i] < #_AchievementList then
					for j = #achievement[i]+1,#_AchievementList do
						achievement[i][j] = 0
					end
				end
			end
		end
	end
end

--从传入的表中删除 9004 9005 9006 宝箱道具
local _RemoveItemFromTab = function(ItemIDList,tab)
	if type(tab) == "table" then
		for i = 1,#tab do
			for j = 1,#ItemIDList do
				if type(tab[i]) == "table" and tab[i][1] == ItemIDList[j] then
					tab[i] = 0
				end
			end
		end
	end
end

--在各种作弊监测中，可被使用类以及删除存档时需要用到的 可实用类道具表
--分析tab_item表找出所有能使用的道具，并且删除
hVar.ConstItemIDList = {}
for k,v in pairs(hVar.tab_item) do
	if type(v.used) == "table" then
		hVar.ConstItemIDList[#hVar.ConstItemIDList+1] = k
	end
end

--删除所有宝箱类道具
hApi.ReomveAllConstItem = function()
	if Save_PlayerData and Save_PlayerData.bag and Save_PlayerData.herocard then
		_RemoveItemFromTab(hVar.ConstItemIDList,LuaGetPlayerBag())
		for i = 1,#Save_PlayerData.herocard do
			local v = Save_PlayerData.herocard[i]
			if type(v) == "table" and v.item then
				_RemoveItemFromTab(hVar.ConstItemIDList,v.item)
			end
		end
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--检测宝箱合法性，如果不合法则删除
LuaCheckPlayerChestLegal = function()
	--如果是windows版 则不检验
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows == TargetPlatform then
		return 0
	end

	for i = 1,#hVar.ConstItemIDList do
		local new_Key_UsedItemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(hVar.ConstItemIDList[i]))
		local UseCount = LuaGetPlayerCountVal("useitem",hVar.ConstItemIDList[i])

		--玩家数据表中的此道具使用次数与keyChain中的记录不符 则判定为非法道具，删除所有宝箱
		if new_Key_UsedItemCount ~= UseCount then
			xlLG("cheat_chest","new_Key_UsedItemCount = "..new_Key_UsedItemCount.."UseCount = "..UseCount.."\n")
			local synchronous_used_val = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_usd_"..tostring(hVar.ConstItemIDList[i]))
			xlAppAnalysis("cheat_chest",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-Nmae:"..g_curPlayerName.."-Iid:"..tostring(hVar.ConstItemIDList[i]).."-KC"..new_Key_UsedItemCount.."-SC"..UseCount.."-syncV"..tostring(synchronous_used_val).."-T:"..tostring(os.date("%m%d%H%M%S")))
			--当key中的值小于存档中的值时，进行一次数据匹配 并且跳出作弊检测机制，此行为根据 synchronous_used_val 值只会发生一次
			if new_Key_UsedItemCount < UseCount then
				if synchronous_used_val == 0 then
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_usd_"..tostring(hVar.ConstItemIDList[i]),1)
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(hVar.ConstItemIDList[i]),UseCount)
					return
				end
			end

			if Save_PlayerData then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_GameDataIllegalTip1"],
					{
					font = hVar.FONTC,
					ok = function()
					end,
				})

				if hGlobal.WORLD.LastWorldMap then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
				end
				
				_RemoveItemFromTab(hVar.ConstItemIDList,LuaGetPlayerBag())
				
				for j = 1,#Save_PlayerData.herocard do
					local v = Save_PlayerData.herocard[j]
					if type(v) == "table" and v.item then
						_RemoveItemFromTab(hVar.ConstItemIDList,v.item)
					end
				end
				
				--LuaSetPlayerCountVal("useitem",hVar.ConstItemIDList[i],new_Key_UsedItemCount)
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
			--最后同步key中的值
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(hVar.ConstItemIDList[i]),UseCount)
		end

	end
end

LuaDeleteIllegalItem = function()
	--如果是windows版 则不检验
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows == TargetPlatform then
		return 0
	end
	
	local new_Key_ForgedCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."forged")
	local SaveDataForged = LuaGetForgeCount()
	--如果发现 锻造次数 和 存档中的 锻造次数 数值不匹配时 进行根据材料类型的惩罚
	if new_Key_ForgedCount ~= SaveDataForged then
		local synchronous_forged_val = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_forged_val")
		--xlAppAnalysis("log_forget_diff",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-N:"..g_curPlayerName.."-KC:"..tostring(new_Key_ForgedCount).."-SC"..tostring(SaveDataForged).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--不同的情况有2种 如果key值小于存档值，则视为迁移过设备的用户
		if new_Key_ForgedCount < SaveDataForged then
			--针对这个用户只做一次数据同步 然后就跳出检测
			
			if synchronous_forged_val == 0 then
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."forged",SaveDataForged)
				return 
			else
				--xlAppAnalysis("log_forget_diff",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-N:"..g_curPlayerName.."-KC:"..tostring(new_Key_ForgedCount).."<<-SC"..tostring(SaveDataForged).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end
		end

		--作弊状态 删除所有 未锁定的道具
		if Save_PlayerData then
			if hGlobal.WORLD.LastWorldMap then
				hGlobal.WORLD.LastWorldMap:del()
				hGlobal.WORLD.LastWorldMap = nil
				
			end

			--玩家背包道具清理
			if Save_PlayerData.bag then
				for i = 1,#Save_PlayerData.bag do
					local item = Save_PlayerData.bag[i]
					if hApi.CheckItemForgedLock(item) == 0 and type(item) == "table" then
						for j = 1,item[3][1] do
							item[3][1+j] = 0
						end
					end
				end
			end
			
			--玩家卡片道具清理
			if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
				for i = 1,#Save_PlayerData.herocard do
					local hero = Save_PlayerData.herocard[i]
					if hero and type(hero) == "table" and hero.equipment and type(hero.equipment) == "table" then
						for j = 1,#hero.equipment do
							local item = hero.equipment[j]
							if hApi.CheckItemForgedLock(item) == 0 and type(item) == "table" then
								for k = 1,item[3][1] do
									item[3][1+k] = 0
								end
							end
						end
					end

					if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" then
						for j = 1,#hero.item do
							local item = hero.item[j]
							if hApi.CheckItemForgedLock(item) == 0 and type(item) == "table" then
								for k = 1,item[3][1] do
									item[3][1+k] = 0
								end
							end
						end
					end
				end
			end
		end

		local itemMat = hVar.ITEMLEVEL[4].DEPLETE
		local val = 0
		for i = 1,3 do
			local val = LuaGetPlayerMaterial(i) - (itemMat[i] or 0) * (new_Key_ForgedCount - SaveDataForged)
			LuaSetPlayerMaterial(i,val)
		end

		--LuaSetPlayerCountVal("forged",nil,new_Key_ForgedCount)
		xlAppAnalysis("cheat_forged",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."uNmae:"..g_curPlayerName.."-Key:"..tostring(new_Key_ForgedCount).."-save:"..tostring(SaveDataForged).."-syncV"..tostring(synchronous_forged_val).."-T:"..tostring(os.date("%m%d%H%M%S")))
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_GameDataIllegalTip2"],
			{
			font = hVar.FONTC,
			ok = function()
			end,
		})	
	end
end

--作弊玩家存档表
local _cheat_UID_list = {
	77598440,		--frog2a , 阴小湿大,
}

--针对作弊表，删除玩家非法道具
LuaDelete_cheat_UID_Item = function()
	local _cur_uid = xlPlayer_GetUID()
	for i = 1,#_cheat_UID_list do
		--只有满足在作弊表中的玩家进行清理
		if _cur_uid == _cheat_UID_list[i] then
			local nDeleteCount = 0
			--删除玩家背包
			if Save_PlayerData and Save_PlayerData.bag then
				for j = 1,#Save_PlayerData.bag do
					local item = Save_PlayerData.bag[j]
					if type(item) == "table" and type(item[9]) == "table" then
						--针对限时道具红装祭坛出来的装备进行清理
						if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
							Save_PlayerData.bag[j] = 0
							nDeleteCount = nDeleteCount + 1
						end
					end
				end
			end
			
			--删除玩家卡牌
			if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
				for j = 1,#Save_PlayerData.herocard do
					local hero = Save_PlayerData.herocard[j]
					if hero and type(hero) == "table" and hero.equipment and type(hero.equipment) == "table" then
						for k = 1,#hero.equipment do
							local item = hero.equipment[k]
							if type(item) == "table" and type(item[9]) == "table" then
								if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
									hero.equipment[k] = 0
									nDeleteCount = nDeleteCount +1
								end
							end
						end
					end
					
					if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" then
						for k = 1,#hero.item do
							local item = hero.item[k]
							--针对限时道具红装祭坛出来的装备进行清理
							if type(item) == "table" and type(item[9]) == "table" then
								if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
									hero.item[k] = 0
									nDeleteCount = nDeleteCount +1
								end
							end
						end
					end
				end
			end
			
			if nDeleteCount > 0 then
				xlAppAnalysis("log_clearIllegalItem",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-N:"..g_curPlayerName.."-C"..tostring(nDeleteCount).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end
		end
	end
end

--删除非法道具 2号
LuaDeleteIllegalItemEx = function()
	if Save_PlayerData then
		--玩家背包道具清理
		if Save_PlayerData.bag then
			for i = 1,#Save_PlayerData.bag do
				local item = Save_PlayerData.bag[i]
				--针对测试地图泄漏到外网的 非法道具删除流程， 主要针对道具追溯 为 拾取，并且有坐标的道具
				if type(item) == "table" and type(item[9]) == "table" and type(item[9][1]) == "table" then
					--如果是从测试地图拾取的话 则删除掉
					if item[9][1][1] == hVar.ITEM_FROMWHAT_TYPE.PICK and item[9][1][2] == 0 then
						Save_PlayerData.bag[i] = 0
					end
				end
				
				if type(item) == "table" and type(item[9]) == "table" then
					--针对限时道具红装祭坛出来的装备进行清理
					if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
						local wishI_1 = item[9][2]
						local wishI_2 = item[9][3]
						if hVar.tab_item[wishI_1].continuedays or hVar.tab_item[wishI_2].continuedays then
							Save_PlayerData.bag[i] = 0
						end
					end
				end
			end
		end
		
		--玩家卡片道具清理
		if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
			for i = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[i]
				if hero and type(hero) == "table" and hero.equipment and type(hero.equipment) == "table" then
					for j = 1,#hero.equipment do
						local item = hero.equipment[j]
						--针对测试地图泄漏到外网的 非法道具删除流程， 主要针对道具追溯 为 拾取，并且有坐标的道具
						if type(item) == "table" and type(item[9]) == "table" and type(item[9][1]) == "table" then
							--如果是从测试地图拾取的话 则删除掉
							if item[9][1][1] == hVar.ITEM_FROMWHAT_TYPE.PICK and item[9][1][2] == 0 then
								hero.equipment[j] = 0
							end
						end
						
						--针对限时道具红装祭坛出来的装备进行清理
						if type(item) == "table" and type(item[9]) == "table" then
							if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
								local wishI_1 = item[9][2]
								local wishI_2 = item[9][3]
								if hVar.tab_item[wishI_1].continuedays or hVar.tab_item[wishI_2].continuedays then
									hero.equipment[j] = 0
								end
							end
						end
					end
				end
				
				if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" then
					for j = 1,#hero.item do
						local item = hero.item[j]
						if type(item) == "table" and type(item[9]) == "table" and type(item[9][1]) == "table" then
							--如果是从测试地图拾取的话 则删除掉
							if item[9][1][1] == hVar.ITEM_FROMWHAT_TYPE.PICK and item[9][1][2] == 0 then
								hero.item[j] = 0
							end
							
							
						end
						
						--针对限时道具红装祭坛出来的装备进行清理
						if type(item) == "table" and type(item[9]) == "table" then
							if item[9][1] == hVar.ITEM_FROMWHAT_TYPE.WISHING then
								local wishI_1 = item[9][2]
								local wishI_2 = item[9][3]
								if hVar.tab_item[wishI_1].continuedays or hVar.tab_item[wishI_2].continuedays then
									hero.item[j] = 0
								end
							end
						end
					end
				end
			end
		end
		
		--李宁的清除同道具唯一ID 的作弊道具
		local tItemCountByUniqueID = {}
		local nDeleteCount = 0
		hApi.EnumAllMyItem(function(oItem,_,_,sBagName,nIndex)
			local nUnique = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]
			if nUnique==0 then
				--print("发现道具id为0的道具,id="..oItem[hVar.ITEM_DATA_INDEX.ID])
			elseif type(nUnique) == "number" then
				tItemCountByUniqueID[nUnique] = (tItemCountByUniqueID[nUnique] or 0) + 1
				if tItemCountByUniqueID[nUnique]>1 then
					nDeleteCount = nDeleteCount + 1
					--print("发现复制的道具"..sBagName.."["..nIndex.."],删除!")
					xlAppAnalysis("log_clearIllegalItem",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-N:"..g_curPlayerName.."-I:"..tostring(oItem[hVar.ITEM_DATA_INDEX.ID]).."-V:"..tostring(oItem[hVar.ITEM_DATA_INDEX.VERSION]).."-C"..tostring(nDeleteCount).."-T:"..tostring(os.date("%m%d%H%M%S")))
					return 0
				end
			end
			
			
		end)
	end
	
	--针对 _cheat_UID_list 表中记录的作弊玩家UID，删除相关 非法所得道具
	--特殊作弊删除道具机制
	LuaDelete_cheat_UID_Item()
end

--modify 英雄背包 装备 玩家仓库中 的 道具表，增加 第8项是否 锁定 为了 防止刷锻造
SaveModifyFunc["ItemDataForgedLock"] = function(playerData)
	local item = nil
	if playerData then 
		--玩家背包
		if playerData.bag then
			for i = 1,#playerData.bag do
				hApi.FormatItemObject(playerData.bag[i])
			end
		end
		
		--英雄卡片
		if playerData.herocard and type(playerData.herocard) == "table" then
			local hero = nil
			for i = 1,#playerData.herocard do
				hero = playerData.herocard[i]
				--每个卡片数据的 装备栏
				if hero and type(hero) == "table" and hero.equipment and type(hero.equipment) == "table" then 
					for j = 1,#hero.equipment do
						hApi.FormatItemObject(hero.equipment[j])
					end
				end
				
				--每个卡片数据的 道具栏
				if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" then 
					for j = 1,#hero.item do
						hApi.FormatItemObject(hero.item[j])
					end
				end
			end
		end
	end
end

--修改积分格式
SaveModifyFunc["herolist_score"] = function(playerData)
	if type(playerData.score) == "number" then
		if _MaxPlayerScore < playerData.score then
			playerData.score = _MaxPlayerScore
		end
		playerData.score = bit:d2b(playerData.score)
	end
end

--把数据表中的积分存储至keyChina 
SaveModifyFunc["score2keyChina"] = function(playerData,playerName)
	local new_score = 0
	local isScore2KeyChina = 0
	--判断设备
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	--IOS
	if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
		new_score = xlGetIntFromKeyChain("xl_"..playerName.."_playerScore")
		isScore2KeyChina = xlGetIntFromKeyChain("xl_"..playerName.."_isScore2KeyChina")
	--windows
	else
		new_score = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..playerName.."_playerScore")
		isScore2KeyChina = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..playerName.."_isScore2KeyChina")
	end
	
	--keyChina 中的积分数据为0 那么必然会做一次转换
	if new_score == 0 and isScore2KeyChina == 0 then
		local old_score = 0
		if playerData then
			if type(playerData.score) == "number" then
				old_score = playerData.score
			elseif type(playerData.score) == "table" then
				old_score = bit:b2d(playerData.score)
			end
		end
		
		--IOS
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			xlSaveIntToKeyChain("xl_"..playerName.."_playerScore",old_score)
			xlSaveIntToKeyChain("xl_"..playerName.."_isScore2KeyChina",1)
		--windows
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..playerName.."_playerScore",old_score)
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..playerName.."_isScore2KeyChina",1)
			CCUserDefault:sharedUserDefault():flush()
		end

	end
end

--修改材料格式
SaveModifyFunc["playerData_mat"] = function(playerData) 
	if playerData and playerData.mat and type(playerData.mat) == "table" then
		for i = 1,_matLen do
			if type(playerData.mat[i]) == "number" then
				if playerData.mat[i] > _MaxMatVal then
					playerData.mat[i] = _MaxMatVal
				end
				playerData.mat[i] = bit:d2b(playerData.mat[i])
			end
		end
	end
end

SaveModifyFunc["playerData_Bag"] = function(playerData)
	if playerData and playerData.bag and type(playerData.bag) == "table" then
		if #playerData.bag <= hVar.EquipMaxNum then
			for i = #playerData.bag,hVar.EquipMaxNum do
				playerData.bag[#playerData.bag+1] = 0
			end
		end
		--[[
		--清除过长的背包
		if #playerData.bag > _ItemLen then
			for i = _ItemLen+1,#playerData.bag do
				playerData.bag[i] = nil
			end
		end
		--]]
	end
end

--修改 玩家表中 记录的创建新玩家的内容
SaveModifyFunc["playerList_name"] = function(playerInfo)
	if playerInfo and playerInfo.name == hVar.tab_string["__TEXT_CreateNewPlayer"] then
		playerInfo.name = "__TEXT_CreateNewPlayer"
	end
end

--把自动存档中的继续游戏地图相关数据 加入 playerList 表中 
SaveModifyFunc["playerList_saveTitle"] = function(playerInfo)
	if #LuaGetSaveTitle(playerInfo)>0 then
		--如果 玩家表中 数据为空 但是 存在存档文件
		if hApi.FileExists(g_localfilepath..playerInfo.name..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
			local tempTable = LuaGetSavedGameDetail(g_localfilepath..playerInfo.name..hVar.SAVE_DATA_PATH.MAP_SAVE)
			LuaSetSaveTitle(playerInfo.name,tempTable.map,tempTable.day,tempTable.mapUniqueID,tempTable.userID,tempTable.save_version)
		end
	end
end

--玩家表 dlc 移动至 玩家数据表
SaveModifyFunc["DLC"] = function(playerlist,playerData)
	--参数判断
	if playerlist and playerlist.dlc and playerData and playerData.dlc then
		--两个参数都为 表结构时
		if type(playerlist.dlc) == "table" and type(playerData.dlc) == "table" then
			--如果玩家数据表中的dlc 长度为0 时 进行判断 数据同步方式为 按照长的一方 为标准
			if #playerlist.dlc < #playerData.dlc then
				playerlist.dlc = {}
				for i = 1,#playerData.dlc do
					playerlist.dlc[#playerlist.dlc+1] = playerData.dlc[i]
				end
			elseif #playerlist.dlc > #playerData.dlc then
				playerData.dlc = {}
				for i = 1,#playerlist.dlc do
					playerData.dlc[#playerData.dlc+1] = playerlist.dlc[i]
				end
			end
		end
	end
end

--格式化材料表 避免获取不到数值
SaveModifyFunc["MAT"] = function(playerData)
	if playerData and playerData.mat then
		if #playerData.mat == 0 then
			for i = 1,3 do
				playerData.mat[i] = 0
			end
		end
	end
end

--扩容giftbag 为2015年3月版本中 最大英雄数量 * 2  20*2 包括董卓
SaveModifyFunc["giftbag"] = function(playerData)
	if playerData and playerData.giftbag then
		if #playerData.giftbag == 10 then
			-- 20*2 包括董卓
			for i = 11,40 do
				playerData.giftbag[i] = 0
			end
		end
	end
end

--缩减英雄卡牌 item 表长度 从 12 降低至10 为了配合新界面
SaveModifyFunc["heroCardItemListFormat"] = function(playerData)
	local item = nil
	if playerData then 
		--英雄卡片
		if playerData.herocard and type(playerData.herocard) == "table" then
			local hero = nil
			for i = 1,#playerData.herocard do
				hero = playerData.herocard[i]
				--每个卡片数据的 道具栏
				if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" and #hero.item == 12 then 
					for j = 11,#hero.item do
						if type(hero.item[j]) == "table" then
							LuaAddItemToGiftBag(hero.item[j])
						end
						hero.item[j] = nil
					end
				end
			end
		end
	end
end

--格式化 地图进度表 变成 地图id:是否完成 
Checkpoint_Record = function(playerLog,mode)
	if playerLog then
		local checkpoint = ""
		for k,v in pairs(hVar.MAP_INFO) do
			if v.level and v.level > 0 then
				checkpoint = checkpoint..v.uniqueID..":"..LuaGetPlayerMapAchi(k,hVar.ACHIEVEMENT_TYPE.LEVEL)..";"
			end
		end

		if playerLog.checkpoint_record == nil then 
			playerLog.checkpoint_record = {checkpoint,0} 
		else
			playerLog.checkpoint_record[1] = checkpoint
		end
		
		if type(mode) == "number" then
			playerLog.checkpoint_record[2] = mode 
		end
	end
end

--玩家数据模板表
local templet_playerdata = {
	score = 0,		--当前积分
	totalScore = 0,		--获得过的最高积分
	itemUniqueID = 0,	--道具唯一ID
	mapUniqueID = 0,	--通过地图唯一ID
	--forgedcount = 0,	--锻造次数统计		已移至 playerLog 表中
	baseline = 0,		--转宝箱保底机制
	playerDataID = 0,	--玩家数据库唯一ID
	playerUniqueID = 0,	--本地玩家创建角色的唯一ID

	--[1] = {"level_tyjy",{0,0,0,0}}, --桃园结义成就列表 [1],地图名，[2].1通关信息，[2].评价信息，[2].3富可敌国，[2].4闪电战 [2].5 战斗场次 [2].6 通关天数 [2].7 获得过的金钱数 [2].8 皇冠 [2].9 击杀了某些BOSS [2].10 特殊记录成就 [2].11-15 每张地图上 最多拥有5个只能完成一次的任务 [2].16 通关次数 [2].19 通关时获得的积分
	-- ...
	achievement = {},	--成就 通关信息
	--bag = {},		--{itemID,itemNum,}, 玩家背包 废弃
	bag = {},		--{{oequip},{oequip},}, 装备背包
	storehouse = {},	--装备仓库
	mat = {0,0,0},		--material 玩家材料表
	medal={},		--勋章系统（td成就记录）
	achievementEx = {},	--娱乐地图统计
	--killcount = {},		--击杀统计	已移至 playerLog 表中
	--useitemcount = {},		--使用道具统计  已移至 playerLog 表中
	herocard = {
	},			--英雄卡片表
	assistant = {},		--副将数据表
	giftstate = {},		--礼品按钮的状态 本地缓存 需要连接服务器 同步
	battlefieldskillbook = {
		--{1001, 1, 0},
	},	--战术技能收集表
	activebattlefieldskill = {},	--已激活的战术技能
	giftbag = {},		--礼品背包
	getitem = {},		--获得
	deleteitem = {},	--删除掉的物品记录
	depletionCount = {},	--针对宝箱，宝箱获得 和 宝箱使用的 统计，
	--item_statistics = {},	--删除掉的红色装备的计数器	已移至 playerLog 表中
	dlc = {},		--把曾经在playerlist 表中存放的 dlc 信息保存至 玩家数据表中 避免在数据迁移时 造成的 数据丢失
	vip = 0,		--vip等级
	borderId = 0,		--玩家边框id
	iconId = 0,		--玩家头像id
	championId = 0,		--玩家称号id
	leaderId = 0,		--玩家会长权限
	dragonId = 0,		--玩家聊天龙王id
	headId = 0,		--玩家头衔id
	lineId = 0,		--玩家线索id
	championNum = 0,	--玩家已拥有的称号数量
	groupId = 0,		--玩家所在军团id
	groupName = 0,		--玩家所在军团名称
	groupAuthen = 0,	--玩家所在军团职务
	topupcount = 0,		--充值rmb记录
	topupcoincount = 0,	--充值游戏币数
	dailyReward = 0,	--今日vip奖励1是否领取
	dailyReward2 = 0,	--今日vip奖励2是否领取
	dailyReward3 = 0,	--今日vip奖励3是否领取
	wishingcount = 0,	--许愿次数
	--ticketNum = 0,	--购买东西的订单号 一般是年月日时间		--移至log 表中并且修改结构
	mapAchi = {},		--地图成就表 新
	pvp_last_rankNum = 0,	--排行榜的上一次排名 只有在排行榜排名发生变化时 才会变动
	pvp_cur_rankNum = 0,		
	pvp_last_elo = 0,		
	pvp_cur_elo = 0,		
	resolvebfskillcount = 0,	--删除卡牌计数器
	BFSkillCardCount = 0,		--获得卡牌计数器
	guiderecode = {},
	guideFlag = 1, --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）--geyachao: 王总说都不要了
	treasurebook = {},	--宝物表
	treasureattr = {},	--宝物属性位表
	talenttree = {},	--天赋树表
	tankIdx = 1,		--在使用的战车索引
	
	medal_statistical = {},		--td成就统计
	forgeCount = 0,
	tank_comment_click_time = 0, --战车点击评价按钮的时间戳
	tank_yesterday_rank = 0, --战车昨日排名名次
	tank_lowconfigmode_flag = 0, --战车低配模式开关
	
	weapongunChestNum = 0, --武器枪宝箱数量
	tacticChestNum = 0, --战术卡宝箱数量
	petChestNum = 0, --宠物宝箱数量
	equipChestNum = 0, --装备宝箱数量
	scientistNum = 0, --营救科学家数量
	tankDeadthNum = 0, --战车死亡数量
	scientistAchievnemtn1 = 0, --科学家成就1
	scientistAchievnemtn2 = 0, --科学家成就2
	scientistAchievnemtn3 = 0, --科学家成就3
	scientistAchievnemtn4 = 0, --科学家成就4
	dishuCoin = 0, --地鼠币数量
	tankDeadthAchievnemtn1 = 0, --垃圾堆成就1
	tankDeadthAchievnemtn2 = 0, --垃圾堆成就2
	tankDeadthAchievnemtn3 = 0, --垃圾堆成就3
	tankDeadthAchievnemtn4 = 0, --垃圾堆成就4
	tankDeadthAchievnemtn5 = 0, --垃圾堆成就5
	
	tank_guide_clickbtn_count = 0, --战车引导点击按钮的次数
	
	giftInfo = {},			--礼包数据
	
	gamecenter_DaFuWeng = 0,	--大富翁
	gamecenter_Challenge = {},	--挑战关卡最佳战绩
	gamecenter_hero = 0,		--英雄战斗力
	gamecenter_tactics = 0,		--战术等级榜
	--gamecenter_ZhuangBei = 0,
	--gamecenter_TongGuan = 0,
	--gamecenter_95 = 0,
	
	
}
--一些表数据的初始化 
--新的地图数据成就表 
local _mapAchi = {}
for k,v in pairs(hVar.MAP_INFO) do
	if type(v.mapType) == "number" then
		if v.uniqueID then
			hVar.MAP_UID2NAME[v.uniqueID] = k
			_mapAchi[v.uniqueID] = hApi.ReadParamWithDepth(_AchievementList,nil,{},3)
		end
	end
end

--templet_playerdata.achievement = __achi
--templet_playerdata.achievementEx = __achiEx
templet_playerdata.mat = hApi.NumTable(_matLen)						--材料
templet_playerdata.medal = hApi.NumTable(_medalLen)					--勋章
--templet_playerdata.medal = {}								--成就
templet_playerdata.bag = hApi.NumTable(hVar.EquipMaxNum)					--仓库
templet_playerdata.giftstate = hApi.NumTable(_giftLen)					--礼品状态
templet_playerdata.giftbag = hApi.NumTable(_giftbagLen)					--礼品背包
templet_playerdata.getitem = hApi.NumTable(_MaxItemLevel)				--得到的道具count
templet_playerdata.deleteitem = hApi.NumTable(_MaxItemLevel)				--删除的道具count
templet_playerdata.activebattlefieldskill = hApi.NumTable(_MaxActiveBattlefieldSkill)	--已激活的战术卡
templet_playerdata.getGiftCount = {}			--收到的网络礼物表
--templet_playerdata.BehaviorList = {}			--玩家行为ID表 二维,1是是否发送过,2是行为ID{}			--移动至log 表

--新的地图成就数据表
templet_playerdata.mapAchi = _mapAchi							--地图成就

--为了精简英雄卡牌数据表 故需要临时表来做废弃属性筛选
local __unuserAttrT = {
	"str",
	"tactics",
	"activity",
	"hp",
	"con",
	"int",
	"mp",
	"minAtk",
	"move",
	"hpRecover",
	"hpSteal",
	"mpRecover",
	"movepoint",
	"mxmp",
	"def",
	"maxAtk",
	"mxhp",
	"lea",
	"led",
}

--玩家list的模板表 只保留名字 和 autosavelist 信息 因为这些信息不需要上传到服务器
local templet_playerList = {
	name = "__TEXT_CreateNewPlayer",
	autosavelist = {	--自动存档表
	},
	lootfromunit = {
	},
	ListMapUniqueID = 0,
	usedbook = 0,
	curExmapname = 0,
	saveTitle = {		--存档信息标题
	},
	userID = 0,		--设备ID
	roleID = 0,		--角色ID
	useing_roldid = {},
	dlc = {},
	selectconfig = {lastindex = 1,}, --本地选人的配置信息
	systemmail_title = "", --最近一次已阅读的系统邮件的标题
	task_finish_flag = 0, --任务是否有完成提示
	task_pvp_freechest_flag = 0, --夺塔奇兵免费锦囊今日是否可免费
	activity_aid_list = "", --活动已经查看过的aid列表
	chat_invite_group_id_list = "", --聊天军团邀请函已处理的id列表
	chat_msg_recent_list = {}, --聊天信息表（防刷屏）
	chat_notice_log = {}, --聊天的提示记录 {world = {read_msgid = xxx, receive_msgid = xxx,}, private = {{[touid] = {read_msgid = xxx, receive_msgid = xxx,}, group = {read_msgid = xxx, receive_msgid = xxx,}, ...,}
	pvp_battle_user_info = {}, --pvp今日对战的玩家信息列表
	pvp_show_guide = 1, --pvp是否显示引导
	billboardRecord = {}, --本玩家今日本地排行榜数据
	xilian_lock_today_limit_info = {}, --锁孔洗炼今日限制购买的次数
	net_shop_today_goods = {}, --每日商城商品列表
	rand_map_info = {},--随机地图信息
	current_select_tank = {},	--选择的坦克列表
	activity_signin_list = {}, --新玩家14日签到活动完成进度
	is_monthcard_state = 0, --是否有月卡状态
	randommap_info = {}, --随机迷宫的缓存信息（防止闪退记录的第n-1小关的进度信息）
}

--玩家log 模板表
local templet_playerLog = {
	killcount = {},			--添加击杀kount
	item_statistics = {},		--添加红装获取日志
	useitemcount = {},		--使用道具count
	forgedcount = 0,		--锻造count
	BehaviorList = {},		--玩家行为表
	ticketNum = {0,0,0,0,0},	--玩家购买消息存根
	shop_card_list = {},		--商品 卡牌列表
	checkpoint_record = {},		--玩家的通关记录表
	webviewN = 0,			--公告版本号
	useDepletion = 0,		--存档中使用过的宝箱数量
	wisingCount = 0,		--许愿次数
	forgeCount = 0,			--新的锻造次数
	quest = {},			--td任务
	gamelog = {},			--游戏过程日志
	scoresource = {},		--积分在各途径的统计
	Cheatlog = {},			--作弊日志
}
--格式化玩家数据表
FormatPlayerData = function(filepath,playerName,playerList,playerData)
	if playerData then
		--如果 返回的DATA 数据表没有模版数据项 则添加 根据模板表 新建data 数据表格式
		for k,v in pairs(templet_playerdata) do
			if playerData[k] == nil then
				if type(v) == "table" then
					playerData[k] = hApi.ReadParamWithDepth(v,nil,{},3)
				elseif type(v) == "number" or type(v) == "string" then
					playerData[k] = v
				end
			end
		end

------------------------------------------------------------------存档数据格式转换逻辑，请不要动-------------------------------------------------------------------------

		--修改材料表
		SaveModifyFunc["MAT"](playerData)
		--修改积分数据项 从 数字变成二进制 表
		SaveModifyFunc["herolist_score"](playerData)
		SaveModifyFunc["playerData_mat"](playerData)

		SaveModifyFunc["score2keyChina"](playerData,playerName)

		--将playerlist 中的 历史数据导入新的 data表中
		for k,_ in pairs(templet_playerdata) do
			if playerList[k] then
				if type(playerList[k]) == "table" then
					playerData[k] = hApi.ReadParamWithDepth(playerList[k],nil,{},3)
				elseif type(playerList[k]) == "number" then
					playerData[k] = playerList[k]
				end
				playerList[k] = nil
			end
		end

		--增加新的地图成就表
		if playerData.mapAchi == nil then
			playerData.mapAchi = hApi.ReadParamWithDepth(templet_playerdata.mapAchi,nil,{},3)
		end

		--如果老的数据表有一项还存在
		if playerData.achievement or playerData.achievementEx then
			--剧情地图的成就数据表还存在
			if playerData.achievement then
				for k,v in pairs(playerData.mapAchi) do
					local tempAchi = LuaGetAchievementByMapName(playerData.achievement,v[_MapName])
					if tempAchi then
						v[_Achievement] = hApi.ReadParamWithDepth(tempAchi,nil,{},3)
					end
				end
				playerData.achievement = nil
			end
			
			--试炼地图的成就数据表还存在
			if playerData.achievementEx then
				for k,v in pairs(playerData.mapAchi) do
					local tempAchi = LuaGetAchievementByMapName(playerData.achievementEx,v[_MapName])
					if tempAchi then
						--首先是数据覆盖一次
						v[_Achievement] = hApi.ReadParamWithDepth(tempAchi,nil,{},3)

						--只针对 1,2,3 做数据迁移
						if tempAchi[hVar.ACHIEVEMENTEX_TYPE.Map_Difficult] ~= 0 then
							v[_Achievement][hVar.ACHIEVEMENT_TYPE.Map_Difficult] = tempAchi[hVar.ACHIEVEMENTEX_TYPE.Map_Difficult]
							v[_Achievement][hVar.ACHIEVEMENTEX_TYPE.Map_Difficult] = 0
						end

						if tempAchi[hVar.ACHIEVEMENTEX_TYPE.Enemy_Num] ~= 0 then
							v[_Achievement][hVar.ACHIEVEMENT_TYPE.Enemy_Num] = tempAchi[hVar.ACHIEVEMENTEX_TYPE.Enemy_Num]
							v[_Achievement][hVar.ACHIEVEMENTEX_TYPE.Enemy_Num] = 0
						end

						if tempAchi[hVar.ACHIEVEMENTEX_TYPE.LEVEL] ~= 0 then
							v[_Achievement][hVar.ACHIEVEMENT_TYPE.LEVEL] = tempAchi[hVar.ACHIEVEMENTEX_TYPE.LEVEL]
							v[_Achievement][hVar.ACHIEVEMENTEX_TYPE.LEVEL] = 0
						end
					end
				end
				playerData.achievementEx = nil
			end
		end
		
		SaveModifyFunc["ACHI"](playerData.mapAchi)

		--有新地图
		if #playerData.mapAchi < #templet_playerdata.mapAchi then
			for i = #playerData.mapAchi+1,#templet_playerdata.mapAchi do
				playerData.mapAchi[i] = hApi.ReadParamWithDepth(_AchievementList,nil,{},3)
			end
		end

		SaveModifyFunc["medalTab"](playerData.medal)

		--从英雄卡片数据表中把英雄卡信息保存至 玩家数据表
		if hApi.FileExists(filepath..playerName..hVar.SAVE_DATA_PATH.HERO_LIST,"full") then
			LuaLoadSavedGameData(filepath..playerName..hVar.SAVE_DATA_PATH.HERO_LIST)
			playerData.herocard = Save_heroList
			xlDeleteFileWithFullPath(filepath..playerName..hVar.SAVE_DATA_PATH.HERO_LIST)
			Save_heroList = nil
		end
		
		--把原来保存在英雄卡上的背包数据 保存到玩家数据表中
		if playerData.herocard.bag then
			playerData.bag = hApi.ReadParamWithDepth(playerData.herocard.bag,nil,{},3)
			playerData.herocard.bag = nil
		end

		--清除掉英雄卡牌数据
		if playerData.herocard and type(playerData.herocard) == "table" then
			for i = 1,#playerData.herocard do
				local tHero = playerData.herocard[i]
				--清除多余的attr属性
				for k,_ in pairs(tHero.attr) do
					for j = 1,#__unuserAttrT do
						if __unuserAttrT[j] == k then
							tHero.attr[k] = nil
						end
					end
				end
				--清除不用的额外点数
				if tHero.ex_AttrPoint then tHero.ex_AttrPoint = nil end
				if tHero.ex_Attr then tHero.ex_Attr = nil end
				
				--zhenkira 根据存档初始化talent表
				if not tHero.talent then
					tHero.talent = {}
				end
				
				local nHeroId = tHero.id
				local star = tHero.attr and tHero.attr.star or 1
				if hVar.tab_unit[nHeroId] and hVar.tab_unit[nHeroId].talent then
					local tabTalent = hVar.tab_unit[nHeroId].talent
					for i = 1, (math.min(#tabTalent, hVar.HERO_TACTIC_SIZE)) do
						local skillObj = tabTalent[i]
						local skillId = skillObj[i] or 0
						if i <= star and skillId > 0 and hVar.tab_skill[skillId] then
							if not tHero.talent[i] then
								tHero.talent[i] = {}
								tHero.talent[i].id = skillId
								tHero.talent[i].lv = 1
							else
								if not tHero.talent[i].id or tHero.talent[i].id == 0 then
									tHero.talent[i].id = skillId
									--写在里面是为了防止正常的0级解锁被重设
									if not tHero.talent[i].lv or tHero.talent[i].lv <= 0 then
										tHero.talent[i].lv = 1
									end
								end
								
							end
						end
					end
					--for idx = 1, hVar.HERO_TALENT_SIZE do
					--	local skillId = 0
					--	local skillLv = 0
					--	if tabTalent[idx] then
					--		skillId = tabTalent[idx][1] or 0
					--	end
					--	--目前逻辑写死，每颗星级开放一个技能
					--	if skillId > 0 and idx <= nStar then
					--		skillLv = 1
					--	end
					--	talent[idx] = {id = skillId, lv = skillLv}
					--end
				end
				--zhenkira 根据存档初始化talent表
				
				--清除不用的卡牌等级
				if playerData.herocard[i].cardLv then playerData.herocard[i].cardLv = nil end
			end
		end
		
		--把原来记录在 playerData 中的 红装获得 以及 删除 日志 , 玩家击杀小怪种类以个数 移动到 playerLog中
		local playerLog = LuaGetPlayerLogByName(playerName,filepath)
		if playerLog == nil then
			--并不存在新的 log 文件 故创建
			playerLog = {userID = xlPlayer_GetUID()}
		end
		--补充数据项
		for k,v in pairs(templet_playerLog) do
			if playerLog[k] == nil then
				if type(v) == "table" then
					playerLog[k] = hApi.ReadParamWithDepth(v,nil,{},3)
				elseif type(v) == "number" or type(v) == "string" then
					playerLog[k] = v
				end
			end
		end
		
		playerLog.ticketNum = {0,0,0,0,0}	--玩家购买消息存根
		playerLog.shop_card_list = {}		--玩家购买卡牌
		
		--把存档中的击杀个数转移至 玩家log 表
		if playerData.killcount then
			playerLog.killcount = playerData.killcount
			playerData.killcount = nil
		end
		
		--把存档中的道具获取数转移至 玩家log 表
		if playerData.item_statistics then
			playerLog.item_statistics = playerData.item_statistics
			playerData.item_statistics = nil
		end
		
		--吧存档中的道具使用次数转移 玩家log 表
		if playerData.useitemcount then
			playerLog.useitemcount = playerData.useitemcount
			playerData.useitemcount = nil
		end
		
		--锻造次数
		--if playerData.forgedcount then
		--	playerLog.forgedcount = playerData.forgedcount
		--	playerData.forgedcount = nil
		--end
		--老的锻造次数，modify by zhenkira
		if playerData.forgedcount then
			playerData.forgedcount = nil
		end
		if playerLog.forgedcount then
			playerLog.forgedcount = nil
		end
		
		--add by zhenkira 2016.4.6
		--存档中使用过的宝箱数量(log中的数据搬回save)
		if playerLog.useDepletion and playerLog.useDepletion > 0 then
			playerData.useDepletion = playerLog.useDepletion
			playerLog.useDepletion = nil
		end

		--存档中许愿次数(log中的数据搬回save)
		if playerLog.wisingCount and playerLog.wisingCount > 0 then
			playerData.wisingCount = playerLog.wisingCount
			playerLog.wisingCount = nil
		end

		--存档中新的锻造次数(log中的数据搬回save)
		if playerLog.forgeCount and playerLog.forgeCount > 0 then
			playerData.forgeCount = playerLog.forgeCount
			playerLog.forgeCount = nil
		end
		--add by zhenkira 2016.4.6
		
		--玩家行为统计
		if playerData.BehaviorList then
			playerLog.BehaviorList = playerData.BehaviorList
			playerData.BehaviorList = nil
		end
		
		--购买道具存根已移动至 log 表
		if playerData.ticketNum then
			playerData.ticketNum = nil
		end
		
		--补充log表中的 玩家购买道具存根 结构是 时间戳 + 道具 ID 初始化为 0 number
		if playerLog.ticketNum == nil then
			playerLog.ticketNum = {0,0,0,0,0}
		end
		
		--如果没有uid数据则补充
		if playerData.userID == nil or playerData.userID == 0 then
			playerData.userID = xlPlayer_GetUID()
		end
		
		--增加地图进度表
		Checkpoint_Record(playerLog)

		SaveModifyFunc["ItemDataForgedLock"](playerData)
		SaveModifyFunc["playerData_Bag"](playerData)
		SaveModifyFunc["battlefieldskillbook_Num"](playerData.battlefieldskillbook)
		SaveModifyFunc["DLC"](Save_playerList,playerData)
		SaveModifyFunc["giftbag"](playerData)
		SaveModifyFunc["heroCardItemListFormat"](playerData)

		--如果当前数据表里有 rid 则向对应的 玩家表中 添加
		if playerList.roleID and playerList.roleID == 0 and playerData.playerDataID and playerData.playerDataID ~= 0 then
			playerList.roleID = playerData.playerDataID
		end
		LuaSavePlayerData(filepath,playerName,playerData,playerLog)
	end
end

--获取当前客户端公告版本号
LuaGetWebViewN = function()
	if Save_PlayerLog and Save_PlayerLog.webviewN then
		return Save_PlayerLog.webviewN
	end
	return 0
end

--设置当前客户端公告版本号
LuaSetWebViewN = function(n)
	if Save_PlayerLog and n ~= 0 then
		Save_PlayerLog.webviewN = n
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		return 1
	end
	return 0
end
--向本地log表中添加购买战术卡牌信息的服务器返回消息 处理同时受到若干消息结果	向表中添加 itemID，票号，已经是否使用的状态
LuaAddBuyCardInfo = function(itemID,ticketNum)
	if Save_PlayerLog and Save_PlayerLog.shop_card_list then
		Save_PlayerLog.shop_card_list[#Save_PlayerLog.shop_card_list+1] = {itemID,ticketNum}
		--for k,v in pairs(Save_PlayerLog.shop_card_list) do
		--end
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--检测本地是否还有没有处理完的购买战术卡牌的回执信息
LuaCheckBuyCardList = function()
	if G_UI_ReverseCardFrmState == 1 then return end
	if Save_PlayerLog and Save_PlayerLog.shop_card_list then
		if #Save_PlayerLog.shop_card_list > 0 then
			for i=1,#Save_PlayerLog.shop_card_list do
				if type(Save_PlayerLog.shop_card_list[i]) == "table" then
					--如果存在表元素 就做一次拾取
					local itemID,ticketNum = unpack(Save_PlayerLog.shop_card_list[i])
					--if type(itemID) == "number" and hVar.tab_item[itemID] then
						local typ,ex,val = unpack(hVar.tab_item[itemID].used)
						hApi.UnitGetLoot(nil,typ,ex,val,nil,nil,nil,nil,{itemID})
						Save_PlayerLog.shop_card_list[i] = 0
						
						--重新做一次排序
						local temp = {}
						for j = 1,#Save_PlayerLog.shop_card_list do
							if type(Save_PlayerLog.shop_card_list[j]) == "table" then
								local iid,iticketnum = unpack(Save_PlayerLog.shop_card_list[j])
								temp[#temp+1] = {iid,iticketnum}
							end
						end
						Save_PlayerLog.shop_card_list = temp
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						return 1
					--end
				end
			end
		end
		return 0
	end
	return nil
end

--根据输入的路径读取 玩家信息 并且对 玩家卡 以及玩家数据 进行格式化
xlLoadPlayerInfo = function(filepath,mode,online_name)
	if filepath ~= nil and hApi.FileExists(filepath..hVar.SAVE_DATA_PATH.PLAYER_LIST,"full") == true then
		LuaLoadSavedGameData(filepath..hVar.SAVE_DATA_PATH.PLAYER_LIST)
		--每次读档后都会跟 模板表中的数据进行一次匹配 如果存档中没有 模板中的数据，则自动初始化新数据，保证存档的兼容性
		if Save_playerList then
			--兼容模式
			for i = 1,3 do
				--格式化 玩家表
				local playerinfo = LuaGetPlayerByIndex(i) --玩家表中存储的句柄
				
				if playerinfo then
					SaveModifyFunc["playerList_name"](playerinfo)
					
					for k,v in pairs(templet_playerList) do
						if playerinfo and playerinfo[k] == nil then
							if type(v) == "table" then
								playerinfo[k] = hApi.ReadParamWithDepth(v,nil,{},3)
							elseif type(v) == "number" or type(v) == "string" then
								playerinfo[k] = v
							end
						end
					end
					
					--增加地图title 相关信息
					SaveModifyFunc["playerList_saveTitle"](playerinfo)
					
					--格式化玩家数据表
					if playerinfo then
						local playerData = LuaGetPlayerDataByName(playerinfo.name,filepath)
						FormatPlayerData(filepath,playerinfo.name,playerinfo,playerData)
					end
				else
					if mode == "local" or mode == nil then
						--如果是本地玩家表，则通过玩家模板数据 创建3个默认数据项
						Save_playerList[i] = templet_playerList
					end
					Save_playerList.userID = xlPlayer_GetUID()
					Save_playerList.LastSwitchPlayer = 1
					
					Save_playerList.SaveBackName = ""
					Save_playerList.SaveBackRid = 0
					Save_playerList.SaveBackTime = ""
					Save_playerList.SaveBackGameScore = 0
					Save_playerList.SaveBackLastFrmShow = 0
					Save_playerList.dlc = {}
				end
			end
			
			--兼容老数据表
			if Save_playerList.userID == nil or Save_playerList.userID == 0 then
				Save_playerList.userID = xlPlayer_GetUID()
			end
			
			if Save_playerList.dlc == nil then
				Save_playerList.dlc = {}
			end
			if Save_playerList.LastSwitchPlayer == nil then
				Save_playerList.LastSwitchPlayer = 1
			end

			if Save_playerList.useing_roldid == nil then
				Save_playerList.useing_roldid = {}
			end

			if Save_playerList.SaveBackName == nil then
				Save_playerList.SaveBackName = ""
			end
			
			if Save_playerList.SaveBackRid == nil then
				Save_playerList.SaveBackRid = 0
			end
			
			if Save_playerList.SaveBackTime == nil then
				Save_playerList.SaveBackTime = ""
			end
			
			if Save_playerList.SaveBackGameScore == nil then
				Save_playerList.SaveBackGameScore = 0
			end
			
			if Save_playerList.SaveBackLastFrmShow == nil then
				Save_playerList.SaveBackLastFrmShow = 0
			end
			
			--if Save_playerList.selectconfig == nil then
			--	Save_playerList.selectconfig = {lastindex = 1,} --本地选人的配置信息
			--end
			
			--if Save_playerList.systemmail_title == nil then
			--	Save_playerList.systemmail_title = "" --最近一次已阅读的系统邮件的标题
			--en
			
			--if Save_playerList.task_finish_flag == nil then
			--	Save_playerList.task_finish_flag = 0 --任务是否有完成提示
			--end
			
			--if Save_playerList.task_pvp_freechest_flag == nil then
			--	Save_playerList.task_pvp_freechest_flag = 0 --夺塔奇兵免费锦囊今日是否可免费
			--end
			
			--if Save_playerList.activity_aid_list == nil then
			--	Save_playerList.activity_aid_list = "" --活动已经查看过的aid列表
			--end
			
			--if Save_playerList.pvp_battle_user_info == nil then
			--	Save_playerList.pvp_battle_user_info = {} --本玩家今日本地排行榜数据
			--end
			
			--if Save_playerList.pvp_show_guide == nil then
			--	Save_playerList.pvp_show_guide = 1 --pvp是否显示引导
			--end
			
			--if Save_playerList.billboardRecord == nil then
			--	Save_playerList.billboardRecord = {} --本玩家今日本地排行榜数据
			--end
			
			--if Save_playerList.xilian_lock_today_limit_info == nil then
			--	Save_playerList.xilian_lock_today_limit_info = {} --锁孔洗炼今日限制购买的次数
			--end
			
			--if Save_playerList.net_shop_today_goods == nil then
			--	Save_playerList.net_shop_today_goods = {} --每日商城商品列表
			--end
		else
			--当没有玩家表文件时 创建空的玩家表
			Save_playerList = {}
			if mode == "local" or mode == nil then
				--如果是本地玩家表，则通过玩家模板数据 创建3个默认数据项
				for i = 1,3 do
					Save_playerList[i] = templet_playerList
				end
			elseif mode == "online" then
				Save_playerList[#Save_playerList+1] = hApi.ReadParamWithDepth(templet_playerList,nil,{},3) 
				Save_playerList[#Save_playerList].name = online_name
			end
			Save_playerList.userID = xlPlayer_GetUID()
			Save_playerList.LastSwitchPlayer = 1
			
			Save_playerList.SaveBackName = ""
			Save_playerList.SaveBackRid = 0
			Save_playerList.SaveBackTime = ""
			Save_playerList.SaveBackGameScore = 0
			Save_playerList.SaveBackLastFrmShow = 0
			Save_playerList.dlc = {}
		end
	else
		--当没有玩家表文件时 创建空的玩家表
		Save_playerList = {}
		if mode == "local" or mode == nil then
			--如果是本地玩家表，则通过玩家模板数据 创建3个默认数据项
			for i = 1,3 do
				Save_playerList[i] = templet_playerList
			end
		elseif mode == "online" then
			Save_playerList[#Save_playerList+1] = hApi.ReadParamWithDepth(templet_playerList,nil,{},3) 
			Save_playerList[#Save_playerList].name = online_name
		end
		Save_playerList.userID = xlPlayer_GetUID()
		Save_playerList.LastSwitchPlayer = 1
		Save_playerList.SaveBackName = ""
		Save_playerList.SaveBackRid = 0
		Save_playerList.SaveBackTime = ""
		Save_playerList.SaveBackGameScore = 0
		Save_playerList.SaveBackLastFrmShow = 0
		Save_playerList.dlc = {}
	end
	
	LuaSavePlayerList()
	
	if hVar.OPTIONS.IS_TD_ENTER and hVar.OPTIONS.IS_TD_ENTER == 1 then
		hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
	else
		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
		--显示新主界面
		--hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
	end
	
	
end

--返回上一次自动面板的出现时间 30分钟内不再出现
LuaGetLastSaveBackFrmTime = function()
	if Save_playerList.SaveBackLastFrmShow then
		return Save_playerList.SaveBackLastFrmShow
	end
	return 0
end

LuaSetLastSaveBackFrmTime = function(Time)
	if Save_playerList.SaveBackLastFrmShow then
		Save_playerList.SaveBackLastFrmShow = Time
		LuaSavePlayerList()
		return 1
	end
	return 0
end

LuaResetSaveBackInfo = function()
	if Save_playerList.SaveBackName then
		Save_playerList.SaveBackName = ""
	end

	if Save_playerList.SaveBackRid then
		Save_playerList.SaveBackRid = 0
	end

	if Save_playerList.SaveBackTime then
		Save_playerList.SaveBackTime = ""
	end

	if Save_playerList.SaveBackGameScore then
		Save_playerList.SaveBackGameScore = 0
	end
end

--设置排行榜上一次的排名 （你永远也不会相信，这个东西的作用是为了一个UI 效果 ╮(╯_╰)╭...）
LuaPVP_SetRankNum = function(RankNum,mode)
	if Save_PlayerData 
		and Save_PlayerData.pvp_last_rankNum 
		and Save_PlayerData.pvp_cur_rankNum 
		and Save_PlayerData.pvp_last_elo
		and Save_PlayerData.pvp_cur_elo
		and type(RankNum) == "number" and RankNum > 0 then
		if mode == "lastN" then
			Save_PlayerData.pvp_last_rankNum = RankNum
		elseif mode == "curN" then
			Save_PlayerData.pvp_cur_rankNum = RankNum
		elseif mode == "lastE" then
			Save_PlayerData.pvp_last_elo = RankNum
		elseif mode == "curE" then
			Save_PlayerData.pvp_cur_elo = RankNum
		end
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		return 1
	end
	return 0
end

LuaPVP_GetRankNum = function(mode)
	if Save_PlayerData 
		and Save_PlayerData.pvp_last_rankNum 
		and Save_PlayerData.pvp_cur_rankNum 
		and Save_PlayerData.pvp_cur_elo 
		and Save_PlayerData.pvp_last_elo then
		if mode == "lastN" then
			return Save_PlayerData.pvp_last_rankNum
		elseif mode == "curN" then
			return Save_PlayerData.pvp_cur_rankNum
		elseif mode == "lastE" then
			return Save_PlayerData.pvp_last_elo
		elseif mode == "curE" then
			return Save_PlayerData.pvp_cur_elo
		end
	end
	return 0
end

hVar.LOCAL_SAVE_VERSION = 2		--修改这里就不能兼容老版本了(禁止读取老版本存档，直接黑掉)

--重置存档标题文字
LuaResetSaveTitle = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist then
		playlist.saveTitle = 0
		playlist.LocalSaveInfo = {}
	end
end

--保存存档文件顶上的
LuaSetSaveTitle = function(playerName,mapName,daycount,mapUniqueID,userID,save_version)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist then
		playlist.saveTitle = 0
		playlist.LocalSaveInfo = {mapName,daycount,mapUniqueID,userID,save_version}
	end
end

--返回记录在玩家列表中的存档信息相关数据(如果这个选项不返回表，那么直接弹框)
LuaGetSaveTitle = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist then
		if (playlist.saveVersion or 0)>hVar.LOCAL_SAVE_VERSION then
			hGlobal.UI.MsgBox("404",{ok=function()
				xlExit()
			end,cancel = 0,})
			return {}
		end
		playlist.saveVersion = hVar.LOCAL_SAVE_VERSION
		if type(playlist.saveTitle)=="table" then
			playlist.LocalSaveInfo = playlist.saveTitle
		end
		playlist.saveTitle = 0		--修改这里就不能兼容老版本了
		if playlist.LocalSaveInfo==nil then
			playlist.LocalSaveInfo = {}
		end
		return playlist.LocalSaveInfo
	end
	--return 0
	return {}
end

--增加正在使用的角色id
LuaAddUseingRoldID = function(rold_id)
	if Save_playerList and type(Save_playerList.useing_roldid) == "table" and rold_id ~= 0 then
		for i = 1,#Save_playerList.useing_roldid do
			if Save_playerList.useing_roldid[i] == rold_id then
				--如果此id 存在 则不再写入
				return 0
			end
		end
		Save_playerList.useing_roldid[#Save_playerList.useing_roldid + 1] = rold_id
		LuaSavePlayerList()
		return 1
	end
	return 2
end

--当发生删除帐号事件时，也从新 对 正在使用的角色 id 表进行初始化
LuaDeleteUseingRoldID = function(rold_id)
	if Save_playerList and type(Save_playerList.useing_roldid) == "table" and rold_id ~= 0 then
		local tempList = {}
		for i = 1,#Save_playerList.useing_roldid do
			--如果删除的id 在表中，则不添加至临时表
			if Save_playerList.useing_roldid[i] ~= rold_id and Save_playerList.useing_roldid[i] ~= 0 then
				tempList[#tempList+1] = Save_playerList.useing_roldid[i]
			end
		end

		Save_playerList.useing_roldid = {}
		for i = 1,#tempList do
			Save_playerList.useing_roldid[i] = tempList[i]
		end
		LuaSavePlayerList()
		return 1
	end
	return 0
end

--返回常用角色ID数据表
LuaGetUseingRoldIDList = function()
	if Save_playerList and type(Save_playerList.useing_roldid) == "table"  then
		return Save_playerList.useing_roldid
	end
	return nil
end

--增加 玩家行为ID
LuaAddBehaviorID = function(id, notSaveFlag)
	if Save_PlayerLog and Save_PlayerLog.BehaviorList then
		for i = 1,#Save_PlayerLog.BehaviorList do
			if Save_PlayerLog.BehaviorList[i][1] == id then
				return 2
			end
		end
		Save_PlayerLog.BehaviorList[#Save_PlayerLog.BehaviorList+1] = {id,0}
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
		--如果是联网状态则直接发送标记
		if g_cur_net_state == 1 then
			SendCmdFunc["send_UserBehavior"](id)
		end
		return 1
	end
	return 0
end

--设置每种行为标记的上传状态
LuaSetBehaviorState = function(id,state)
	if Save_PlayerLog and type(Save_PlayerLog.BehaviorList) == "table" then
		for i = 1,#Save_PlayerLog.BehaviorList do
			if Save_PlayerLog.BehaviorList[i][1] == id then
				Save_PlayerLog.BehaviorList[i][2] = state
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				return 1
			end
		end
		return 2
	end
	return 0
end

--返回玩家的行为记录表
LuaGetBehaviorList = function()
	if Save_PlayerLog and Save_PlayerLog.BehaviorList then
		return	Save_PlayerLog.BehaviorList
	end
	return 0
end

LuaDelBeviorByList = function(tList)
	local newList = {}
	if Save_PlayerLog and Save_PlayerLog.BehaviorList then
		for i = 1,#Save_PlayerLog.BehaviorList do
			local id = Save_PlayerLog.BehaviorList[i][1]
			if tList[id] ~= 1 then
				newList[#newList + 1] = {Save_PlayerLog.BehaviorList[i][1],Save_PlayerLog.BehaviorList[i][2]}
			end
		end
		Save_PlayerLog.BehaviorList = newList
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--检查是否有作弊log
LuaCheckCheatLog = function()
	if Save_PlayerLog and Save_PlayerLog.Cheatlog then
		local cheatLog = Save_PlayerLog.Cheatlog
		if type(cheatLog) == "table" then
			for i = 1,#cheatLog do
				local v = cheatLog[i]
				if v[3] == 0 then
					SendCmdFunc["send_CheatLog"](99,v[1],v[2])
				end
			end
		end
	end
end

--添加作弊日志
LuaAddCheatLog = function(ntype,slog)
	if Save_PlayerLog then
		if Save_PlayerLog.Cheatlog == nil then
			print("Save_PlayerLog.Cheatlog == nil")
			Save_PlayerLog.Cheatlog = {}
		end
		--if type(Save_PlayerLog.Cheatlog[1]) == "table" and ntype >= 10 then
			--return
		--end
		--只存一份不累加  暂无需求
		Save_PlayerLog.Cheatlog[1] = {ntype,slog,0}
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		--如果是联网状态则直接发送作弊标记
		if g_cur_net_state == 1 then
			SendCmdFunc["send_CheatLog"](99,ntype,slog)
		end
	end
end

--清除作弊日志
LuaDelCheatLog = function()
	if Save_PlayerLog and Save_PlayerLog.Cheatlog then
		Save_PlayerLog.Cheatlog = {}
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--返回当前玩家购买道具票号的索引 客户端目前只保留5条
LuaGetNextTicketNumIndex = function()
	--当游戏启动时 做一次初始化
	if Save_PlayerLog and Save_PlayerLog.ticketNum then
		for i = 1,#Save_PlayerLog.ticketNum do
			if type(Save_PlayerLog.ticketNum[i]) == "table" then
				local _,_,state = unpack(Save_PlayerLog.ticketNum[i])
				if state == 1 then
					return i
				end
			else
				return i
			end
		end
		return 0
	end
	return -1
end

--清理本地购买道具存根表
LuaClearTicketNumList = function(index)
	if Save_PlayerLog and Save_PlayerLog.ticketNum then
		Save_PlayerLog.ticketNum[index] = 0
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--设置玩家数据 购买道具的订单号
LuaSetPlayerTicketNum = function(itemID)
	if Save_PlayerLog and Save_PlayerLog.ticketNum then
		--首先验证本地 购买存根是否满足 5个都没有处理过
		local ticketNum = tonumber(os.date("%m%d%H%M%S"))
		local next_index = LuaGetNextTicketNumIndex()
		--只有有空位时
		if next_index > 0 then
			Save_PlayerLog.ticketNum[next_index] = {ticketNum,itemID,0}
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			return ticketNum
		elseif next_index == 0 then	--本地存根表中没有一个空位 也就是说 前5调记录 都没有处理完毕
			xlAppAnalysis("check_ticketNum",0,1,"info",tostring(xlPlayer_GetUID()).."-Iid:"..tostring(itemID).."-net:"..tostring(ticketNum).."-T:"..tostring(os.date("%m%d%H%M%S")))
			return -1
		end
	end
	return 0
end
--得到玩家当前的订单号表
LuaGetPlayerTicketNum = function()
	if Save_PlayerLog and Save_PlayerLog.ticketNum then
		return Save_PlayerLog.ticketNum
	end
	return 0
end

--设置玩家数据库唯一ID
luaSetplayerDataID = function(ID)
	if Save_PlayerData and Save_PlayerData.playerDataID and type(ID) == "number" then
		
		Save_PlayerData.playerDataID = ID
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

		local playerinfo,index = LuaGetPlayerByName(g_curPlayerName)
		if playerinfo and type(playerinfo.roleID) == "number" and playerinfo.roleID == 0 then
			playerinfo.roleID = ID

			LuaSavePlayerList()
		end
	end
end

luaGetplayerDataID = function()
	if Save_PlayerData and Save_PlayerData.playerDataID then
		return Save_PlayerData.playerDataID
	end
	return 0
end

--设置玩家创建角色的唯一ID
luaSetplayerUniqueID = function(ID)
	if Save_PlayerData and Save_PlayerData.playerUniqueID and type(ID) == "number" then
		Save_PlayerData.playerUniqueID = ID
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

luaGetplayerUniqueID = function()
	if Save_PlayerData and Save_PlayerData.playerUniqueID then
		--给没有唯一ID 的角色进行初始化
		if Save_PlayerData.playerUniqueID == 0 then
			--判断设备
			local playerCount = 0
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
				playerCount = xlGetIntFromKeyChain("xl_NewPlayerCount")
				playerCount = playerCount + 1 
				xlSaveIntToKeyChain("xl_NewPlayerCount",playerCount)
			--windows
			else
				playerCount = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_NewPlayerCount")
				playerCount = playerCount + 1 
				CCUserDefault:sharedUserDefault():setIntegerForKey("xl_NewPlayerCount",playerCount)
				CCUserDefault:sharedUserDefault():flush()
			end
			
			Save_PlayerData.playerUniqueID = playerCount
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
		return Save_PlayerData.playerUniqueID
	end
	return 0
end

--增加删除道具的计数器 目前只针对红装 mode "A" 是 道具的获得， "D" 是 道具的删除
LuaAddItemStatisticsLog = function(itemID,mode)
	if Save_PlayerLog and Save_PlayerLog.item_statistics then
		Save_PlayerLog.item_statistics[#Save_PlayerLog.item_statistics+1] = "T:"..os.date("%m%d%H%M").."I:"..itemID..mode
		return 1
	end
	return 0
end

--获得玩家卡片的Uid
LuaGetPlayerCardUid = function()
	--[[
	--geyachao: 大菠萝不检测重复id
	--大菠萝，这里有问题
	if Save_playerList then
		return Save_playerList.userID or 0
	end
	]]
	return 0
end

--获得玩家数据表的Uid
LuaGetPlayerDataUid = function()
	--[[
	--geyachao: 大菠萝不检测重复id
	if Save_PlayerData and Save_PlayerData.userID then
		return Save_PlayerData.userID
	end
	]]
	
	return 0
end

--设置玩家是否使用过战术技能书
LuaSetUsedBookState = function(playerName,state)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and playlist.usedbook then
		playlist.usedbook = state
	end
	LuaSavePlayerList()
end

--修改最后一次选中玩家的值
LuaSetLastSwitchPlayer = function(PlayerIndex)
	if Save_playerList then
		Save_playerList.LastSwitchPlayer = PlayerIndex
		LuaSavePlayerList()
	end
end

--获取上次退出游戏时玩家的序号
LuaGetLastSwitchPlayer = function()
	if Save_playerList then
		return Save_playerList.LastSwitchPlayer or 1
	end
	return 1
end

--返回玩家是否使用过战术技能书
LuaGetUsedBookState = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and playlist.usedbook then
		return playlist.usedbook
	end
	return 0
end

--设置礼品按钮状态
LuaSetPlayerGiftState = function(index,val)
	if Save_PlayerData and Save_PlayerData.giftstate then
		Save_PlayerData.giftstate[index] = val
	end
end

--拿到按钮状态
LuaGetPlayerGiftstate = function(index)
	if Save_PlayerData and Save_PlayerData.giftstate then
		return Save_PlayerData.giftstate[index]
	end
	return 0
end

LuaSetPlayerListMapUniqueID = function(playerName,val)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and playlist.ListMapUniqueID then
		playlist.ListMapUniqueID = val
	end
end

LuaClearGuiderecodeList = function(playerName)
	--local playlist = LuaGetPlayerByName(playerName)
	local playlist = LuaGetPlayerData()
	if playlist and playlist.guiderecode then
		playlist.guiderecode = {}
		playlist.guideFlag = 1
	end
	--if playlist and playlist.selectconfig then
	--	selectconfig = {lastindex = 1,} --本地选人的配置信息
	--end
end

LuaClearRidByName = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and playlist.roleID then
		playlist.roleID = 0
	end
end

--设置当前正在进行的特殊地图
LuaSetCurExmMpName = function(playerName,mapName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and playlist.curExmapname then
		playlist.curExmapname = mapName
	end
end

--返回当前正在进行的 特殊地图的 名字
LuaGetCurExmMpName = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	return playlist.curExmapname or 0
end

--检测 autosave 玩家表 数据表 中的 地图唯一ID 是否匹配
LuaCheckPamUniqueID = function(playerName)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and Save_PlayerData then
		if playlist.ListMapUniqueID == Save_PlayerData.mapUniqueID then
			--local tempTable = LuaGetSavedGameDetail(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
			local tempTable = LuaGetSaveTitle(g_curPlayerName)
			--playerlist 和 playerdata中的数据一致，但是没有存档 或者 与 玩家表 和 玩家存档 中合法 返回1 合法 
			if tempTable[3] == 0 or (tempTable[3] == playlist.ListMapUniqueID and tempTable[3] == Save_PlayerData.mapUniqueID)then
				return 1
			else
				--玩家表和数据表一致 但是 autosave 不一致 返回0
				return 0
			end
		else
			--玩家表和 数据表 不一致 返回2
			return 2
		end
	end
	--表不存在 返回3 这种情况不可能 除非... 
	return 3
end
------------------------------------礼品背包相关-------------------------------------------------------
--向礼物背包中添加道具 返回参数 1 添加成功 2 礼品背包已满 0 数据表不存在
LuaAddItemToGiftBag = function(item)
	if Save_PlayerData and Save_PlayerData.giftbag then
		local playergiftbag = Save_PlayerData.giftbag
		if #playergiftbag < _giftbagLen then
			for i = #playergiftbag +1 , _giftbagLen do
				playergiftbag[i] = 0
			end
		end
		for i = 1,#playergiftbag do
			if playergiftbag[i] == 0 then
				playergiftbag[i] = item
				return 1
			end
		end
		return 2
	end
	return 0
end

--检测玩家仓库是否可用
LuaCheckPlayerBagCanUse = function()
	if Save_PlayerData and Save_PlayerData.bag then
		for i = 1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
			if Save_PlayerData.bag[i] == 0 then
				return 1
			end
		end
		return 0
	end
	return 2
end

--从玩家礼品背包中将目标道具尝试移动至玩家背包中，如果失败则返回0，成功返回1,-1为数据不存在
LuaGetItemFromPlayerGiftBag = function(index)
	local oItem = luaGetItemOBJByPlayerGiftBag(index)
	if type(oItem)=="table" then
		if Save_PlayerData and Save_PlayerData.bag then
			for i = 1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
				if Save_PlayerData.bag[i] == 0 then
					local tempI = hApi.ReadParamWithDepth(oItem,nil,{},3)
					local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
					Save_PlayerData.bag[i] = tempI
					Save_PlayerData.giftbag[index] = 0
					local itemLv = hVar.tab_item[itemID].itemLv or 1
					if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
						LuaAddItemStatisticsLog(itemID,"A")
					end
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					return 1
				end
			end
		end
	end
	return 0
end

--获得玩家礼品背包内的 index 道具
luaGetItemOBJByPlayerGiftBag = function(index)
	if Save_PlayerData and Save_PlayerData.bag and Save_PlayerData.giftbag then
		local oItem = Save_PlayerData.giftbag[index]
		if type(oItem)=="table" then
			return oItem
		end
	end
	return 0
end

--获得玩家礼品背包
LuaGetPlayerGiftBag = function()
	if Save_PlayerData and  Save_PlayerData.giftbag then
		return Save_PlayerData.giftbag
	end
	return 0
end

--检测礼品背包中是否有道具
LuaCheckGiftBag = function()
	if Save_PlayerData and  Save_PlayerData.giftbag then
		for i = 1,#Save_PlayerData.giftbag do
			if type(Save_PlayerData.giftbag[i]) == "table" then
				return 1
			end
		end
	end
	return 0
end
-------------------------------------vip-------------------------------------------------
LuaSetPlayerVipLv = function(Lv)
	if Save_PlayerData and Save_PlayerData.vip then
		Save_PlayerData.vip = Lv
	end
	
	--geyachao: 发现存档的背包里，有些空位置没置成0，道具操作会出错
	if Save_PlayerData and Save_PlayerData.bag then
		if (Lv > 0) then
			local SUM = hVar.PLAYERBAG_X_NUM * hVar.PLAYERBAG_Y_NUM * Lv
			for i = 1, SUM, 1 do
				if (Save_PlayerData.bag[i] == nil) then
					Save_PlayerData.bag[i] = 0
				end
			end
		end
	end
	
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaGetPlayerVipLv = function()
	if Save_PlayerData and Save_PlayerData.vip then
		return Save_PlayerData.vip
	end
	return 0
end

-------------------------------------玩家头像边框称号-------------------------------------------------
--头像
LuaSetPlayerBorderID = function(borderId, dontSave)
	if Save_PlayerData and Save_PlayerData.borderId then
		if (Save_PlayerData.borderId ~= borderId) then
			Save_PlayerData.borderId = borderId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--头像
LuaGetPlayerBorderID = function()
	if Save_PlayerData and Save_PlayerData.borderId then
		return Save_PlayerData.borderId
	end
	return 0
end

--边框
LuaSetPlayerIconID = function(iconId, dontSave)
	if Save_PlayerData and Save_PlayerData.iconId then
		if (Save_PlayerData.iconId ~= iconId) then
			Save_PlayerData.iconId = iconId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--边框
LuaGetPlayerIconID = function()
	if Save_PlayerData and Save_PlayerData.iconId then
		return Save_PlayerData.iconId
	end
	return 0
end

--称号
LuaSetPlayerChampionID = function(championId, dontSave)
	if Save_PlayerData and Save_PlayerData.championId then
		if (Save_PlayerData.championId ~= championId) then
			Save_PlayerData.championId = championId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--称号
LuaGetPlayerChampionID = function()
	if Save_PlayerData and Save_PlayerData.championId then
		return Save_PlayerData.championId
	end
	return 0
end

--聊天龙王
LuaSetPlayerDragonID = function(dragonId, dontSave)
	if Save_PlayerData and Save_PlayerData.dragonId then
		if (Save_PlayerData.dragonId ~= dragonId) then
			Save_PlayerData.dragonId = dragonId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--聊天龙王
LuaGetPlayerDragonID = function()
	if Save_PlayerData and Save_PlayerData.dragonId then
		return Save_PlayerData.dragonId
	end
	return 0
end

--头衔
LuaSetPlayerHeadID = function(headId, dontSave)
	if Save_PlayerData and Save_PlayerData.headId then
		if (Save_PlayerData.headId ~= headId) then
			Save_PlayerData.headId = headId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--头衔
LuaGetPlayerHeadID = function()
	if Save_PlayerData and Save_PlayerData.headId then
		return Save_PlayerData.headId
	end
	return 0
end

--线索
LuaSetPlayerLineID = function(lineId, dontSave)
	if Save_PlayerData and Save_PlayerData.lineId then
		if (Save_PlayerData.lineId ~= lineId) then
			Save_PlayerData.lineId = lineId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--线索
LuaGetPlayerLineID = function()
	if Save_PlayerData and Save_PlayerData.lineId then
		return Save_PlayerData.lineId
	end
	return 0
end

--已拥有的称号数量
LuaSetPlayerChampionNum = function(championNum, dontSave)
	if Save_PlayerData and Save_PlayerData.championNum then
		if (Save_PlayerData.championNum ~= championNum) then
			Save_PlayerData.championNum = championNum
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--已拥有的称号数量
LuaGetPlayerChampionNum = function()
	if Save_PlayerData and Save_PlayerData.championNum then
		return Save_PlayerData.championNum
	end
	return 0
end

--会长权限
LuaSetPlayerLeaderID = function(leaderId, dontSave)
	if Save_PlayerData and Save_PlayerData.leaderId then
		if (Save_PlayerData.leaderId ~= leaderId) then
			Save_PlayerData.leaderId = leaderId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--会长权限
LuaGetPlayerLeaderID = function()
	if Save_PlayerData and Save_PlayerData.leaderId then
		return Save_PlayerData.leaderId
	end
	return 0
end

--所属军团id
LuaSetPlayerGroupID = function(groupId, dontSave)
	if Save_PlayerData and Save_PlayerData.groupId then
		if (Save_PlayerData.groupId ~= groupId) then
			Save_PlayerData.groupId = groupId
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--所属军团id
LuaGetPlayerGroupID = function()
	if Save_PlayerData and Save_PlayerData.groupId then
		return Save_PlayerData.groupId
	end
	return 0
end

--所属军团名称
LuaSetPlayerGroupName = function(groupName, dontSave)
	if Save_PlayerData and Save_PlayerData.groupName then
		if (Save_PlayerData.groupName ~= groupName) then
			Save_PlayerData.groupName = groupName
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--所属军团名称
LuaGetPlayerGroupName = function()
	if Save_PlayerData and Save_PlayerData.groupName then
		return Save_PlayerData.groupName
	end
	return 0
end

--所属军团职务
LuaSetPlayerGroupAuthen = function(groupAuthen, dontSave)
	if Save_PlayerData and Save_PlayerData.groupAuthen then
		if (Save_PlayerData.groupAuthen ~= groupAuthen) then
			Save_PlayerData.groupAuthen = groupAuthen
			
			--存档
			if (not dontSave) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--所属军团职务
LuaGetPlayerGroupAuthen = function()
	if Save_PlayerData and Save_PlayerData.groupAuthen then
		return Save_PlayerData.groupAuthen
	end
	return 0
end
-------------------------------------------------------

LuaSetPlayerGamecenter_DaFuWeng = function(gamecenter_DaFuWeng)
	if Save_PlayerData and Save_PlayerData.gamecenter_DaFuWeng then
		Save_PlayerData.gamecenter_DaFuWeng = gamecenter_DaFuWeng
	end
	--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaGetPlayerGamecenter_DaFuWeng = function()
	if Save_PlayerData and Save_PlayerData.gamecenter_DaFuWeng then
		return Save_PlayerData.gamecenter_DaFuWeng
	end
	return 0
end

LuaSetPlayerGamecenter_Hero = function(gamecenter_hero)
	if Save_PlayerData and Save_PlayerData.gamecenter_hero then
		Save_PlayerData.gamecenter_hero = gamecenter_hero
	end
	--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaGetPlayerGamecenter_Hero = function()
	if Save_PlayerData and Save_PlayerData.gamecenter_hero then
		return Save_PlayerData.gamecenter_hero
	end
	return 0
end

LuaSetPlayerGamecenter_Tactics = function(gamecenter_tactics)
	if Save_PlayerData and Save_PlayerData.gamecenter_tactics then
		Save_PlayerData.gamecenter_tactics = gamecenter_tactics
	end
	--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaGetPlayerGamecenter_Tactics = function()
	if Save_PlayerData and Save_PlayerData.gamecenter_tactics then
		return Save_PlayerData.gamecenter_tactics
	end
	return 0
end

LuaSetPlayerGamecenter_Challenge = function(mapId, combatEva)
	
	local tmp = hApi.Split(mapId, "/")
	--print("LuaSetPlayerGamecenter_Challenge:", tmp[#tmp], combatEva)
	if Save_PlayerData and Save_PlayerData.gamecenter_Challenge then
		local oldCombatEva = Save_PlayerData.gamecenter_Challenge[tmp[#tmp]] or 0
		Save_PlayerData.gamecenter_Challenge[tmp[#tmp]] = math.max(oldCombatEva, combatEva)
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaGetPlayerGamecenter_Challenge = function(mapId)
	
	local tmp = hApi.Split(mapId, "/")
	--print("LuaGetPlayerGamecenter_Challenge:", tmp[#tmp])
	if Save_PlayerData and Save_PlayerData.gamecenter_Challenge and Save_PlayerData.gamecenter_Challenge[tmp[#tmp]] then
		return Save_PlayerData.gamecenter_Challenge[tmp[#tmp]]
	end
	return 0
end

--读取今日某装备洗炼的次数限制
LuaGetTodayXilianLimitCout = function(oItem)
	--每天最大锁孔洗炼的次数
	local maxLockCountDay = hVar.ITEM_XILIAN_INFO.lockInfo.maxLockCountDay
	
	--vip可以有更多的锁孔洗炼的次数
	local vipLv = LuaGetPlayerVipLv()
	if (vipLv >= 0) then --vip有额外刷新次数
		local xilianLockCount = hVar.Vip_Conifg.xilianLockCount[vipLv] --vip该等级可以洗炼的次数
		maxLockCountDay = xilianLockCount
		
		if (maxLockCountDay < 0) then --负数表示无次数限制
			return maxLockCountDay
		end
	end
	
	local xl_count = oItem[hVar.ITEM_DATA_INDEX.XILIAN_COUNT] --今日锁孔洗炼次数
	local xl_date = oItem[hVar.ITEM_DATA_INDEX.XILIAN_DATE] --今日锁孔洗炼次数最后一次的日期（字符串）（北京时间）
	
	--客户端的时间
	local localTime = os.time()
		
	--服务器的时间
	local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
	
	--转化为北京时间
	local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
	local delteZone = localTimeZone - 8 --与北京时间的时差
	hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
	
	--此刻的年月日（北京时间）
	local tabNow = os.date("*t", hosttime)
	local yearNow = tabNow.year
	local monthNow = tabNow.month
	local dayNow = tabNow.day
	
	if (type(xl_date) ~= "string") or (type(xl_count) ~= "number") then --格式不对
		--格式不对，重置数据
		xl_count = maxLockCountDay
	else
		local intTimeOld = hApi.GetNewDate(xl_date) --上一次存档的时间戳
		local tabOld = os.date("*t", intTimeOld)
		local yearOld = tabOld.year
		local monthOld = tabOld.month
		local dayOld = tabOld.day
		
		--print("strDateTimeNow=" .. os.date("%Y-%m-%d %H:%M:%S", intTimeNow), "strOldDateTime=" .. strOldDateTime)
		--print("year", yearNow, yearOld, "month", monthNow, monthOld, "day", dayNow, dayOld)
		if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
			--不是今天，重置数据
			xl_count = maxLockCountDay
		end
	end
	
	return xl_count
end

--设置今日某装备洗炼的次数限制
LuaSetTodayXilianLimitCout = function(oItem, num)
	--每天最大锁孔洗炼的次数
	local maxLockCountDay = hVar.ITEM_XILIAN_INFO.lockInfo.maxLockCountDay
	
	--vip可以有更多的锁孔洗炼的次数
	local vipLv = LuaGetPlayerVipLv()
	if (vipLv > 0) then --vip有额外刷新次数
		local xilianLockCount = hVar.Vip_Conifg.xilianLockCount[vipLv] --vip该等级可以洗炼的次数
		maxLockCountDay = xilianLockCount
	end
	
	--客户端的时间
	local localTime = os.time()
		
	--服务器的时间
	local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
	
	--转化为北京时间
	local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
	local delteZone = localTimeZone - 8 --与北京时间的时差
	hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
	
	oItem[hVar.ITEM_DATA_INDEX.XILIAN_COUNT] = math.min(num, maxLockCountDay) --今日锁孔洗炼次数
	oItem[hVar.ITEM_DATA_INDEX.XILIAN_DATE] = os.date("%Y-%m-%d %H:%M:%S", hostTime) --今日锁孔洗炼次数最后一次的日期（字符串）（北京时间）
	
	--存档
	LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
end

--读取今日某商店道具购买的次数限制
LuaGetTodayShopItemLimitCount = function(playerName, itemId, limitMax)
	local xilian_lock_today_limit_info = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	local l_count = limitMax --今日剩余购买次数
	
	if player then
		xilian_lock_today_limit_info = player.xilian_lock_today_limit_info or {} --锁孔洗炼今日限制购买的次数
		local itemTable = xilian_lock_today_limit_info[itemId]
		
		if itemTable then
			l_count = itemTable.num
			--print("l_count=", l_count)
			local l_date = itemTable.date
			
			--客户端的时间
			local localTime = os.time()
				
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--此刻的年月日（北京时间）
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			if (type(l_date) ~= "string") or (type(l_count) ~= "number") then --格式不对
				--格式不对，重置数据
				l_count = limitMax
			else
				local intTimeOld = hApi.GetNewDate(l_date) --上一次存档的时间戳
				local tabOld = os.date("*t", intTimeOld)
				local yearOld = tabOld.year
				local monthOld = tabOld.month
				local dayOld = tabOld.day
				
				--print("strDateTimeNow=" .. os.date("%Y-%m-%d %H:%M:%S", intTimeNow), "strOldDateTime=" .. strOldDateTime)
				--print("year", yearNow, yearOld, "month", monthNow, monthOld, "day", dayNow, dayOld)
				if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
					--不是今天，重置数据
					l_count = limitMax
				end
			end
		end
	end
	
	return l_count
end

--设置今日某商店道具购买的次数限制
LuaSetTodayShopItemLimitCount = function(playerName, itemId, num)
	local xilian_lock_today_limit_info = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	local l_count = limitMax --今日剩余购买次数
	
	if player then
		xilian_lock_today_limit_info = player.xilian_lock_today_limit_info or {} --锁孔洗炼今日限制购买的次数
		xilian_lock_today_limit_info[itemId] = xilian_lock_today_limit_info[itemId] or {}
		
		--客户端的时间
		local localTime = os.time()
			
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		xilian_lock_today_limit_info[itemId].num = num --今日锁孔洗炼次数
		xilian_lock_today_limit_info[itemId].date = os.date("%Y-%m-%d %H:%M:%S", hostTime)--今日锁孔洗炼次数最后一次的日期（字符串）（北京时间）
		
		player.xilian_lock_today_limit_info = xilian_lock_today_limit_info
		
		--本地存档
		LuaSavePlayerList()
	end
end

--清空玩家的今日商店道具的次数
LuaClearTodayShopItemLimitCount = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.xilian_lock_today_limit_info = {} --锁孔洗炼今日限制购买的次数
	end
end

--读取今日商城商品列表
LuaGetTodayNetShopGoods = function(playerName, shopId)
	local net_shop_today_goods = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		net_shop_today_goods = player.net_shop_today_goods or {} --每日商城商品列表
		local list = net_shop_today_goods[shopId]
		
		return list
	end
	
	return nil
end

--设置今日商城商品列表
LuaSetTodayNetShopGoods = function(playerName, shopId, rmb_refresh_count, goods)
	local xilian_lock_today_limit_info = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		net_shop_today_goods = player.net_shop_today_goods or {} --每日商城商品列表
		net_shop_today_goods[shopId] = net_shop_today_goods[shopId] or {}
		
		--客户端的时间
		local localTime = os.time()
			
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		local tabNow = os.date("*t", hostTime)
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		
		--标记为起始时间
		local strMonth = tostring(monthNow) --月(字符串)
		if (monthNow < 10) then
			strMonth = "0" .. strMonth
		end
		local strDay = tostring(dayNow) --日(字符串)
		if (dayNow < 10) then
			strDay = "0" .. strDay
		end
		local hhmmdd = hVar.tab_shop[shopId].refreshTime --"21:00:00"
		local strStandardRecordTime = yearNow .. "-" .. strMonth .. "-" .. strDay .. " " .. hhmmdd --标准记录的时间
		if (os.date("%Y-%m-%d %H:%M:%S", hostTime) < strStandardRecordTime) then
			local hostTime_yesterday = hostTime - 3600 * 24
			local tabYesterday = os.date("*t", hostTime_yesterday)
			if tabYesterday then
				local yearYesterday = tabYesterday.year
				local monthYesterday = tabYesterday.month
				local dayYesterday = tabYesterday.day
				
				--标记为起始时间
				local strMonth = tostring(monthYesterday) --月(字符串)
				if (monthYesterday < 10) then
					strMonth = "0" .. strMonth
				end
				local strDay = tostring(dayYesterday) --日(字符串)
				if (dayYesterday < 10) then
					strDay = "0" .. strDay
				end
				strStandardRecordTime = yearYesterday .. "-" .. strMonth .. "-" .. strDay .. " " .. hhmmdd --标准记录的时间
			end
		end
		
		net_shop_today_goods[shopId].shopId = shopId --商店id
		net_shop_today_goods[shopId].rmb_refresh_count = rmb_refresh_count --剩余可刷新次数
		net_shop_today_goods[shopId].goods = goods --商品信息
		net_shop_today_goods[shopId].date = strStandardRecordTime --现在时间（字符串）（北京时间）
		
		player.net_shop_today_goods = net_shop_today_goods
		
		--本地存档
		LuaSavePlayerList()
	end
end

--清空玩家的今日商城商品列表
LuaClearTodayNetShopGoods = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.net_shop_today_goods = {} --每日商城商品列表
	end
end

--充值rmb
LuaSetTopupCount = function(num)
	if Save_PlayerData then
		Save_PlayerData.topupcount = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--充值rmb
LuaGetTopupCount = function()
	if Save_PlayerData and Save_PlayerData.topupcount then
		return Save_PlayerData.topupcount
	end
	return 0
end

--充值游戏币数
LuaSetTopupCoinCount = function(num)
	if Save_PlayerData then
		Save_PlayerData.topupcoincount = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--充值游戏币数
LuaGetTopupCoinCount = function()
	if Save_PlayerData and Save_PlayerData.topupcoincount then
		return Save_PlayerData.topupcoincount
	end
	return 0
end

--------------------------------------------------------------------------------------------------------------
--vip领取状态1
LuaSetDailyReward = function(state)
	if Save_PlayerData then
		Save_PlayerData.dailyReward = state
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--vip领取状态1
LuaGetDailyReward = function()
	if Save_PlayerData and Save_PlayerData.dailyReward then
		return Save_PlayerData.dailyReward
	end
	return 0
end

--vip领取状态2
LuaSetDailyReward2 = function(state)
	if Save_PlayerData then
		Save_PlayerData.dailyReward2 = state
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--vip领取状态2
LuaGetDailyReward2 = function()
	if Save_PlayerData and Save_PlayerData.dailyReward2 then
		return Save_PlayerData.dailyReward2
	end
	return 0
end

--vip领取状态3
LuaSetDailyReward3 = function(state)
	if Save_PlayerData then
		Save_PlayerData.dailyReward3 = state
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--vip领取状态3
LuaGetDailyReward3 = function()
	if Save_PlayerData and Save_PlayerData.dailyReward3 then
		return Save_PlayerData.dailyReward3
	end
	return 0
end
--------------------------------------------------------------------------------------------------------------

LuaSetWishingCount = function(num)
	if Save_PlayerData and Save_PlayerData.wishingcount then
		Save_PlayerData.wishingcount = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

LuaAddWishingCount = function(num)
	LuaSetWishingCount(LuaGetWishingCount()+num)
end

LuaGetWishingCount = function()
	if Save_PlayerData and Save_PlayerData.wishingcount then
		return Save_PlayerData.wishingcount
	end
	return 0
end

--设置存档中使用箱子的次数
LuaSetUseDepletion = function(num)
	if Save_PlayerData and Save_PlayerData.useDepletion then
		Save_PlayerData.useDepletion = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--增加使用各种箱子次数
LuaAddUseDepletion = function(num)
	LuaSetUseDepletion(LuaGetUseDepletion()+num)
end

--返回存档中使用箱子次数
LuaGetUseDepletion = function()
	if Save_PlayerData and Save_PlayerData.useDepletion then
		return Save_PlayerData.useDepletion
	end
	return 0
end

LuaSetWisingCount = function(num)
	if Save_PlayerData and Save_PlayerData.wisingCount then
		Save_PlayerData.wisingCount = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--增加使用各种箱子次数
LuaAddWisingCount = function(num)
	LuaSetWisingCount(LuaGetWisingCount()+num)
end

--返回存档中使用箱子次数
LuaGetWisingCount = function()
	if Save_PlayerData and Save_PlayerData.wisingCount then
		return Save_PlayerData.wisingCount
	end
	return 0
end

LuaSetForgeCount = function(num)
	if Save_PlayerData and Save_PlayerData.forgeCount then
		Save_PlayerData.forgeCount = num
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--增加使用各种箱子次数
LuaAddForgeCount = function(num)
	LuaSetForgeCount(LuaGetForgeCount()+num)
end

--返回存档中使用箱子次数
LuaGetForgeCount = function()
	if Save_PlayerData and Save_PlayerData.forgeCount then
		return Save_PlayerData.forgeCount
	end
	return 0
end

-------------------------------------------------------------------------------------------------------
------------------------------------地图引导相关-------------------------------------------------------
LuaSetPlayerGuideState = function(playName,map_name,ptype)
	--返回地图名相关的 引导状态
	--local player = LuaGetPlayerByName(playName)
	local player = LuaGetPlayerData()
	if player then
		if type(player.guiderecode) == "table" then
			local guide = nil
			for i = 1,#player.guiderecode do
				guide = player.guiderecode[i]
				if guide[_MapName] == map_name then
					for k,v in pairs(guide[_Achievement]) do
						if k == ptype then 
							return 2 
						end
					end
					
					guide[_Achievement][ptype] = 1
					--LuaSavePlayerList()
					LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
					return 1
					
				end
			end
			player.guiderecode[#player.guiderecode+1] = {map_name,{[ptype] = 1}}
			--LuaSavePlayerList()
			LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
			return 1
		end
		return 0
	end
	return 0
end

LuaGetPlayerGuideState = function(playName,map_name,key)
	--local player = LuaGetPlayerByName(playName)
	local player = LuaGetPlayerData()
	if player then
		if type(player.guiderecode) == "table" then
			local guide = nil
			for i = 1,#player.guiderecode do
				guide = player.guiderecode[i]
				if guide[_MapName] == map_name then
					if guide[_Achievement][key] == 1 then
						return 1
					else
						return 0
					end
				end
			end
			return 0
		end
		return 0
	end
end


--设置玩家的第i个选卡配置信息
LuaSetPlayerSelectConfig = function(playName, i, config)
	--返回地图名相关的 引导状态
	local player = LuaGetPlayerByName(playName)
	--local player = LuaGetPlayerData()
	if player then
		if (type(player.selectconfig) == "table") then
			player.selectconfig.lastindex = i
			player.selectconfig[i] = config
			
			--LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
			LuaSavePlayerList()
			return 1
		end
		return 0
	end
	return 0
end

--读取玩家的第i个配置信息
LuaGetPlayerSelectIndex = function(playName, i)
	local lastindex = 1
	local player = LuaGetPlayerByName(playName)
	--local player = LuaGetPlayerData()
	if player then
		if (type(player.selectconfig) == "table") then
			lastindex = player.selectconfig.lastindex or 1
		end
	end
	
	return lastindex
end

--读取玩家的第i个配置信息
LuaGetPlayerSelectConfig = function(playName, i)
	local config = {}
	local player = LuaGetPlayerByName(playName)
	--local player = LuaGetPlayerData()
	if player then
		if (type(player.selectconfig) == "table") then
			config = player.selectconfig[i] or {}
		end
	end
	
	return config
end

--清空玩家的配置信息
LuaClearSelectConfig = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.selectconfig = {lastindex = 1,} --本地选人的配置信息
	end
end

--读取玩家最近一次已阅读的系统邮件的标题
LuaGetSystemMailTitle = function(playerName)
	local systemmail_title = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		systemmail_title = player.systemmail_title or "" --最近一次已阅读的系统邮件的标题
	end
	
	return systemmail_title
end

--设置玩家最近一次已阅读的系统邮件的标题
LuaSetSystemMailTitle = function(playerName, title)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		if (player.systemmail_title ~= title) then
			player.systemmail_title = title --最近一次已阅读的系统邮件的标题
			LuaSavePlayerList()
		end
	end
end

--清空玩家最近一次已阅读的系统邮件的标题
LuaClearSystemMailTitle = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.systemmail_title = "" --最近一次已阅读的系统邮件的标题
	end
end

--读取玩家已查看的活动aid列表
LuaGetActivityAidList = function(playerName)
	local activity_aid_list = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		activity_aid_list = player.activity_aid_list or "" --已查看的活动aid列表
	end
	
	--转为一维数组表
	local t = hApi.String2Array(activity_aid_list)
	return t
end

--添加玩家已查看的活动aid
LuaAddActivityAid = function(playerName, aid)
	local activity_aid_list = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		activity_aid_list = player.activity_aid_list or "" --已查看的活动aid列表
	
		--转为一维数组表
		local t = hApi.String2Array(activity_aid_list)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的aid是否已存在
		for i = 1, #t, 1 do
			if (t[i] == aid) then
				--直接返回
				return
			end
		end
		
		--插入一条数据
		table.insert(t, aid)
		
		--转化为字符串
		activity_aid_list = hApi.Array2String(t)
		player.activity_aid_list = activity_aid_list --已查看的活动aid列表
		LuaSavePlayerList()
	end
end

--清空玩家已查看的活动aid列表
LuaClearActivityAidList = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.activity_aid_list = "" --已查看的活动aid列表
		LuaSavePlayerList()
	end
end

--读取玩家pvp玩家本局对战的对手信息
LuaGetPVPUserInfo = function(playerName)
	local pvp_battle_user_info = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		pvp_battle_user_info = player.pvp_battle_user_info or {} --玩家今日对战的玩家信息
	end
	
	return pvp_battle_user_info
end

--添加一条pvp玩家本局对战的对手信息
LuaAddPVPUserInfo = function(playerName, session_dbId, userId, userName, bUseEquip, pvpcoinCost, gametime)
	local pvp_battle_user_info = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		pvp_battle_user_info = player.pvp_battle_user_info or {} --玩家今日对战的玩家信息
		
		--获得当前时间(北京时区)
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hosttime = hosttime - delteZone * 3600 --GMT+8时区
		local tabNow = os.date("*t", hosttime)
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		
		--算出校验和
		local nUseEquip = bUseEquip and 1 or 0
		local checksum = (session_dbId + userId + (#userName) + hosttime + nUseEquip + pvpcoinCost + gametime) % 9973
		
		--找到一个有效位置
		local max_len = 30
		local pivot = -1 --待插入的位置
		
		--检测是否有 session_dbId 一样的，覆盖本位置
		for i = 1, #pvp_battle_user_info, 1 do
			local session_dbId_i = pvp_battle_user_info[i].session_dbId
				
			if (session_dbId_i == session_dbId) then
				pivot = i
				break
			end
		end
		
		--未找到，检测是否有旧日期的（非今天）
		if (pivot == -1) then
			for i = 1, #pvp_battle_user_info, 1 do
				local strBattleTime_i = pvp_battle_user_info[i].strBattleTime
				local hosttime_i = hApi.GetNewDate(strBattleTime_i) --GMT+8时区
				
				local tabOld = os.date("*t", hosttime_i)
				local yearOld = tabOld.year
				local monthOld = tabOld.month
				local dayOld = tabOld.day
				
				--print("idx=" .. i)
				--print("strDateTimeNow=" .. os.date("%Y-%m-%d %H:%M:%S", hosttime), "strOldDateTime=" .. strBattleTime_i)
				--print("year=", yearNow, yearOld, "month=", monthNow, monthOld, "day=", dayNow, dayOld)
				
				if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
					--print("如果日期不是同一天，那么本条记录已过期")
					pivot = i
					break
				end
			end
		end
		
		--未找到，插入末尾
		if (pivot == -1) then
			pivot = (#pvp_battle_user_info) + 1
		end
		
		--表长度超过最大长度，删除第一项，插入末尾
		if (pivot > max_len) then
			table.remove(pvp_battle_user_info, 1)
			pivot = max_len
		end
		
		--插入一条数据
		pvp_battle_user_info[pivot] =
		{
			session_dbId = session_dbId,
			userId = userId,
			userName = userName,
			strBattleTime = os.date("%Y-%m-%d %H:%M:%S", hosttime), --GMT+8时区
			bUseEquip = bUseEquip,
			pvpcoinCost = pvpcoinCost,
			gametime = gametime,
			checksum = checksum,
		}
		
		--存储
		player.pvp_battle_user_info = pvp_battle_user_info
		LuaSavePlayerList()
	end
end

--清空pvp玩家本局对战的对手信息
LuaClearPVPUserInfo = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	if player then
		player.pvp_battle_user_info = {} --玩家今日对战的玩家信息
		LuaSavePlayerList()
	end
end

--读取玩家pvp是否显示引导
LuaGetPVPIsShowGuide = function(playerName)
	local pvp_show_guide = 1
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		pvp_show_guide = player.pvp_show_guide or 1 --玩家pvp是否显示引导
	end
	
	return pvp_show_guide
end

--设置pvp是否显示引导
LuaSetPVPIsShowGuide = function(playerName, nIsShow)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	if player then
		player.pvp_show_guide = nIsShow --玩家pvp是否显示引导
		LuaSavePlayerList()
	end
end

--清空pvp是否显示引导
LuaClearPVPIsShowGuide = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	if player then
		player.pvp_show_guide = 1 --玩家pvp是否显示引导
		LuaSavePlayerList()
	end
end

--读取玩家某个排行榜的得分
LuaGetPlayerBillBoard = function(playName, bid)
	local player = LuaGetPlayerByName(playName)
	--local player = LuaGetPlayerData()
	
	local retScore = 0 --返回值
	
	if player then
		if (player.billboardRecord) then
			local billboardT = player.billboardRecord[bid] --本玩家今日本地排行榜数据
			if billboardT then
				local score = billboardT.score
				local strOldDateTime = billboardT.date
				local chesksum = billboardT.chesksum --chesksum = (score + date + 时区差) % 9973
				
				--与北京时间的时差
				local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
				local delteZone = localTimeZone - 8 --与北京时间的时差
				
				--暂时取存档的得分
				retScore = score
				
				--如果校验不一致，那么本条记录无效
				local sum = (score + hApi.GetNewDate(strOldDateTime) + delteZone * 3600) % 9973
				--print("LuaGetPlayerBillBoard 检验是否一致", "sum=" .. sum, "chesksum=" .. chesksum)
				if (chesksum ~= sum) then
					--print("如果校验不一致，那么本条记录无效")
					retScore = 0
				end
				
				--如果日期不是同一天，那么本条记录无效
				--取服务器当前时间
				local localTime = os.time()
				local intTimeNow = localTime - g_localDeltaTime --现在服务器时间戳(Local = Host + deltaTime)
				intTimeNow = intTimeNow - delteZone * 3600 --服务器时间(北京时区)
				local tabNow = os.date("*t", intTimeNow)
				local yearNow = tabNow.year
				local monthNow = tabNow.month
				local dayNow = tabNow.day
				
				local intTimeOld = hApi.GetNewDate(strOldDateTime) --上一次存档的时间戳
				local tabOld = os.date("*t", intTimeOld)
				local yearOld = tabOld.year
				local monthOld = tabOld.month
				local dayOld = tabOld.day
				
				--print("strDateTimeNow=" .. os.date("%Y-%m-%d %H:%M:%S", intTimeNow), "strOldDateTime=" .. strOldDateTime)
				--print("year", yearNow, yearOld, "month", monthNow, monthOld, "day", dayNow, dayOld)
				if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
					--print("如果日期不是同一天，那么本条记录无效")
					retScore = 0
				end
			end
		end
	end
	
	return retScore
end

--设置玩家某个排行榜的得分
LuaSetPlayerBillBoard = function(playName, bid, score)
	local player = LuaGetPlayerByName(playName)
	--local player = LuaGetPlayerData()
	
	if player then
		if (player.billboardRecord) then
			player.billboardRecord[bid] = player.billboardRecord[bid] or {} --本玩家今日本地排行榜数据
			local billboardT = player.billboardRecord[bid]
			
			--取挑战开始的时间
			local localTime = os.time()
			--local intTimeNow = localTime - g_localDeltaTime --现在服务器时间戳(Local = Host + deltaTime)
			local intTimeNow = hApi.GetNewDate(g_endlessBeginTime) --北京时区
			local strDateTimeNow = g_endlessBeginTime --北京时区
			--print("LuaSetPlayerBillBoard 挑战开始的时间=", strDateTimeNow)
			
			--与北京时间的时差
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			
			--取之前的得分
			local oldScore = billboardT.score or 0
			local strOldDateTime = billboardT.date or 0
			local oldChesksum = billboardT.chesksum or 0 --chesksum = (score + date + 时区差) % 9973
			--print("之前的得分=", oldScore, strOldDateTime, oldChesksum)
			--print("本次得分=", score)
			
			--是否要更新本条数据
			local requieUpdate = false
			
			--如果旧数据无效，那么需要更新
			local oldSum = (oldScore + hApi.GetNewDate(strOldDateTime) + delteZone * 3600) % 9973
			if (oldChesksum ~= oldSum) then
				oldScore = 0
				requieUpdate = true --需要更新
				--print("如果旧数据无效，那么需要更新")
			end
			
			--如果日期不是同一天，那么需要更新
			local tabNow = os.date("*t", intTimeNow)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local intTimeOld = hApi.GetNewDate(strOldDateTime) --上一次存档的时间戳
			local tabOld = os.date("*t", intTimeOld)
			local yearOld = tabOld.year
			local monthOld = tabOld.month
			local dayOld = tabOld.day
			
			if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
				requieUpdate = true --需要更新
				--print("如果日期不是同一天，那么需要更新")
			end
			
			--如果本次得分更高，那么需要更新
			if (score > oldScore) then
				requieUpdate = true --需要更新
				--print("如果本次得分更高，那么需要更新")
			end
			
			--更新本条记录
			if requieUpdate then
				--print("更新本条记录", score, strDateTimeNow, "delteZone=" .. delteZone)
				billboardT.score = score
				billboardT.date = strDateTimeNow
				billboardT.chesksum = (score + hApi.GetNewDate(strDateTimeNow) + delteZone * 3600) % 9973 --chesksum = (score + date) % 9973
			else
				--print("不更新本条记录")
			end
		end
	end
end

--清空玩家玩家排行榜的得分
LuaClearPlayerBillBoard = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.billboardRecord = {} --本玩家今日本地排行榜数据
	end
end

--读取存档里是否需要新手引导（0:未设置 / -1:不需要引导 /1:需要引导）
LuaGetPlayerGuideFlag = function(playName)
	local guideFlag = 0
	--local playlist = LuaGetPlayerByName(playName)
	local playlist = LuaGetPlayerData()
	if playlist and playlist.guideFlag then
		guideFlag = playlist.guideFlag --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
	end
	
	return guideFlag
end

--设置存档里是否需要新手引导（0:未设置 / -1:不需要引导 /1:需要引导）
LuaSetPlayerGuideFlag = function(playName, guideFlag)
	--local playlist = LuaGetPlayerByName(playName)
	local playlist = LuaGetPlayerData()
	--标记存档的新手引导标记
	if playlist and playlist.guideFlag then
		playlist.guideFlag = guideFlag --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
		--LuaSavePlayerList()
		LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
		--print("--------------------------------- LuaSetPlayerGuideFlag()", playName, guideFlag)
	end
end

--更新随机地图最好的记录
--LuaUpdateRandMapBestRecord = function(playerName,tRecord)
	----local tRecord = {
		----stage = clearStage,
		----tankID = nTankID,
		----weaponID = nWeaponId,
		----gametime = nTime,
		----rescueNum = _nRescueNum,
		----score = _nScore,
		----bestCK = nBestCK,
	----}
	--local player = LuaGetPlayerByName(playerName)
	
	--if player then
		--local record = player.rand_map_record
		--if type(record) == "table" and type(record.stage) == "number" and type(record.gametime) == "number" then
			--if tRecord.stage > record.stage or (tRecord.stage == record.stage and tRecord.gametime < record.gametime) then
				--player.rand_map_record = hApi.ReadParamWithDepth(tRecord,nil,{},3)
				--LuaSavePlayerList()
			--end
		--else
			--player.rand_map_record = hApi.ReadParamWithDepth(tRecord,nil,{},3)
			--LuaSavePlayerList()
		--end
	--end
--end

----获取随机地图最好的记录
--LuaGetRandMapBestRecord = function(playerName)
	--local tRecord = {}
	--local player = LuaGetPlayerByName(playerName)
	
	--if player then
		--tRecord = player.rand_map_record or {}
	--end
	--return tRecord
--end

LuaUpdateRandMapBestRecord = function(playerName,tRecord)
	--local tRecord = {
		--stage = clearStage,
		--tankID = nTankID,
		--weaponID = nWeaponId,
		--gametime = nTime,
		--rescueNum = _nRescueNum,
		--score = _nScore,
		--bestCK = nBestCK,
	--}
	if Save_PlayerLog then
		local record = Save_PlayerLog.rand_map_record
		if type(record) == "table" and type(record.stage) == "number" and type(record.gametime) == "number" then
			if tRecord.stage > record.stage or (tRecord.stage == record.stage and tRecord.gametime < record.gametime) then
				Save_PlayerLog.rand_map_record = hApi.ReadParamWithDepth(tRecord,nil,{},3)
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		else
			if type(tRecord) == "table" then 
				Save_PlayerLog.rand_map_record = hApi.ReadParamWithDepth(tRecord,nil,{},3)
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

LuaGetRandMapBestRecord = function()
	--print("LuaGetRandMapBestRecord")
	local tRecord = {}
	local player = LuaGetPlayerByName(g_curPlayerName)
	
	--因恢复存档需要 所以把最佳纪录转入log中
	if player and type(player.rand_map_record) == "table" then
		--table_print(player.rand_map_record)
		tRecord = hApi.ReadParamWithDepth(player.rand_map_record,nil,{},3)
		player.rand_map_record = nil
		LuaSavePlayerList()
	end

	if Save_PlayerLog then
		if type(Save_PlayerLog.rand_map_record) ~= "table" then
			--print("no table")
			Save_PlayerLog.rand_map_record = tRecord
			--table_print(tRecord)
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		else
			--print("table")
			tRecord = Save_PlayerLog.rand_map_record
		end
	end
	return tRecord
end

--读取玩家随机地图信息(准备废弃)
LuaGetPlayerRandMapInfo = function(playerName)
	local info = {}
	local player = LuaGetPlayerByName(playerName)
	
	if player then
		info = player.rand_map_info or {}
	end
	
	return info
end

--设置随机地图信息(准备废弃)
LuaSetPlayerRandMapInfos = function(playerName,tData)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		if (player.rand_map_info) and type(tData) == "table" then
			for i = 1,#tData do
				local sKey = tData[i][1]
				local data = tData[i][2]
				player.rand_map_info[sKey] = data
			end
		end
		LuaSavePlayerList()
	end
end

--清空玩家随机地图信息(准备废弃)
LuaClearPlayerRandMapInfo = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.rand_map_info = {}
		LuaSavePlayerList()
	end
end

--获取玩家临时游戏信息
LuaGetPlayerTempGameInfo = function(playerName)
	local info = {}
	local player = LuaGetPlayerByName(playerName)
	
	if player and player.game_info then
		info = player.game_info.curInfo or {}
	end
	
	return info
end

--设置玩家临时游戏信息
LuaSetPlayerTempGameInfo = function(playerName,tData)
	local player = LuaGetPlayerByName(playerName)
	if player and type(tData) == "table" then
		if player.game_info == nil then
			player.game_info = {}
		end
		if player.game_info.curInfo == nil then
			player.game_info.curInfo = {}
		end
		for i = 1,#tData do
			local sKey = tData[i][1]
			local data = tData[i][2]
			player.game_info.curInfo[sKey] = data
		end
		LuaSavePlayerList()
	end
end

--获得玩家临时游戏信息(通过类型)
LuaGetPlayerTempGameInfoByType = function(playerName,nType)
	local info = {}
	local player = LuaGetPlayerByName(playerName)
	
	if player and player.game_info and player.game_info.typeinfo and player.game_info.typeinfo[nType] then
		info = player.game_info.typeinfo[nType] or {}
	end
	
	return info
end

--设置玩家临时游戏信息(通过类型)
LuaSetPlayerTempGameInfoByType = function(playerName,nType,tData)
	local player = LuaGetPlayerByName(playerName)
	if player and type(tData) == "table" then
		if player.game_info == nil then
			player.game_info = {}
		end
		if player.game_info.typeinfo == nil then
			player.game_info.typeinfo = {}
		end
		if player.game_info.typeinfo[nType] == nil then
			player.game_info.typeinfo[nType] = {}
		end
		for i = 1,#tData do
			local sKey = tData[i][1]
			local data = tData[i][2]
			player.game_info.typeinfo[nType][sKey] = data
		end
		LuaSavePlayerList()
	end
end

--清空玩家临时游戏信息
LuaClearPlayerTempGameInfo = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	if player then
		player.game_info = {}
		LuaSavePlayerList()
	end
end

--读取玩家当前选择的坦克
LuaGetPlayerSelectTank = function(playerName)
	local list = {}
	local player = LuaGetPlayerByName(playerName)
	
	if player then
		list = player.current_select_tank
	end
	if #list == 0 then
		list[1] = hVar.MY_TANK_ID
	end
	
	return list
end

--设置玩家当前选择的坦克
LuaSetPlayerSelectTanks = function(playerName,tData)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		if type(tData) == "table" then
			player.current_select_tank = tData
		end
		LuaSavePlayerList()
	end
end


-------------------------------------------------------------------------------------------------------
------------------------------------玩家背包相关-------------------------------------------------------
-- 由于对玩家背包操作都是在游戏内进行的，所以 全局变量 当前玩家以及 当前的游戏存档路径 是已经被初始化过的数据 所以直接拿来使用
--设置玩家背包中存放的道具
LuaSetPlayerBag = function(index,item)
	if Save_PlayerData and Save_PlayerData.bag then
		Save_PlayerData.bag[index] = item
	end
end

--向获得礼物道具计数表中添加 count 信息
LuaAddGetGiftCount = function(itemID, itemNum)
	local num = itemNum or 1
	if Save_PlayerData and Save_PlayerData.getGiftCount then
		xlAppAnalysis("log_getgift",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-T:"..os.date("%m%d%H%M").."-itemID:"..tostring(itemID).."-playerName:"..tostring(g_curPlayerName))
		for i = 1,#Save_PlayerData.getGiftCount do
			if Save_PlayerData.getGiftCount[i][1] == itemID then
				Save_PlayerData.getGiftCount[i][2] = Save_PlayerData.getGiftCount[i][2] + num
				return 1
			end
		end
		Save_PlayerData.getGiftCount[#Save_PlayerData.getGiftCount+1] = {itemID,num}
	end
end

LuaGetPlayerBagPageNum = function(vipLv)
	local pagenum = 5
	local vipcfg = hVar.Vip_Conifg
	local bagPageNum = vipcfg.bagPageNum
	if bagPageNum[vipLv] then
		pagenum = bagPageNum[vipLv]
	end
	return pagenum
end

--根据当前VIP 获取背包长度
LuaGetPlayerBagLenByVipLv = function(vipLv)
	if vipLv then
		local vipcfg = hVar.Vip_Conifg
		local pageNum = 2
		local bagPageNum = vipcfg.bagPageNum
		pageNum = bagPageNum[vipLv or 0]
		return pageNum * _ItemMiniLen
	end
	return 0
end

--向玩家背包中添加道具
LuaAddItemToPlayerBag = function(itemID,rewardEx,tFromType,exValueRatio,entity,quality)
	if rewardEx == nil then
		rewardEx = -1
	end
	
	if (exValueRatio == nil) then
		exValueRatio = 0
	end
	
	if Save_PlayerData and Save_PlayerData.bag then
		if type(tFromType)~="table" then
			tFromType = {hVar.ITEM_FROMWHAT_TYPE.GIFT,itemID,0,0}
		end
		
		local tabI = hVar.tab_item[itemID]
		if tabI and (tabI.type == hVar.ITEM_TYPE.RESOURCES or tabI.type == hVar.ITEM_TYPE.GIFTITEM or tabI.type == hVar.ITEM_TYPE.PLAYERITEM) then 
			return 1,0
		end
		
		local oItem = hApi.CreateItemObjectByID(itemID,rewardEx,nil,{tFromType},exValueRatio,entity,quality)
		return 1,oItem[hVar.ITEM_DATA_INDEX.UNIQUE],oItem
		--[[
		for i = 1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
			if Save_PlayerData.bag[i] == 0 then
				Save_PlayerData.bag[i] = oItem
				local itemLv = hVar.tab_item[itemID].itemLv or 1
				if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
					LuaAddItemStatisticsLog(itemID,"A")
				end
				return 1,oItem[hVar.ITEM_DATA_INDEX.UNIQUE],oItem
			end
		end
		
		--如果 没有位置 则添加到 临时背包
		if LuaAddItemToGiftBag(oItem) == 1 then
			if hGlobal.UI.SystemMenuBar then
				hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
			end
			local itemLv = hVar.tab_item[itemID].itemLv or 1
			if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
				LuaAddItemStatisticsLog(itemID,"A")
			end
			return 1,oItem[hVar.ITEM_DATA_INDEX.UNIQUE],oItem
		end
		]]
	end
	return 0,0
end

LuaGetPlayerBag = function()
	if Save_PlayerData and Save_PlayerData.bag then
		return Save_PlayerData.bag
	end
end

LuaGetPlayerBagFromTableIndex = function(index)
	local endN = index*_ItemMiniLen
	local beginN = endN - _ItemMiniLen +1
	local tempBagList = {}
	if Save_PlayerData and Save_PlayerData.bag then
		for i = beginN,endN do
			tempBagList[#tempBagList+1] = Save_PlayerData.bag[i]
		end
	end
	return tempBagList
end
--向英雄卡片上添加道具
LuaAddItemToHeroCardBag = function(itemID,rewardEx)
	local playerData = LuaGetPlayerData()
	if playerData and playerData.herocard then
		local v = nil
		for i = 1,#playerData.herocard do
			v = playerData.herocard[i]
			for j = 1,#v.item do
				if v.item[j] == 0 then
					if rewardEx == nil then
						rewardEx = -1
					end
					v.item[j] = hApi.CreateItemObjectByID(itemID,rewardEx,nil,nil)
					return 1
				end
			end
		end
	end
	return 0
end

------------------------------------------------------------------------------------------------------------
------------------------------宝箱保底机制数据相关----------------------------------------------------------
--获得转宝箱未获得红色装备的底线值
LuaGetRollBaseLine = function()
	if Save_PlayerData and Save_PlayerData.baseline then
		return Save_PlayerData.baseline
	end
	return 0
end
--设置转宝箱未获得红色装备的底线值
LuaSetRollBaseLine = function(val)
	if Save_PlayerData and Save_PlayerData.baseline then
		Save_PlayerData.baseline = val
	end
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

--设置 得到各等级道具的count
--得到的道具的个数
LuaSetgetItemCount = function(itemLevel,Val)
	if Save_PlayerData and Save_PlayerData.getitem then
		Save_PlayerData.getitem[itemLevel] = Val
	end
end

LuaGetgetItemCount = function(itemLevel)
	if Save_PlayerData and Save_PlayerData.getitem then
		return Save_PlayerData.getitem[itemLevel] or 0
	end
end

--增啊得到某等级道具的次数
LuaAddGetItemCount = function(itemLevel,Val)
	if itemLevel == 0 then itemLevel = 1 end
	LuaSetgetItemCount(itemLevel,LuaGetgetItemCount(itemLevel) + Val)
end

LuaSetDeleteItemCount = function(itemLevel,Val)
	if Save_PlayerData and Save_PlayerData.deleteitem then
		Save_PlayerData.deleteitem[itemLevel] = Val
	end
end

LuaGetDeleteItemCount = function(itemLevel)
	if Save_PlayerData and Save_PlayerData.deleteitem then
		return Save_PlayerData.deleteitem[itemLevel] or 0
	end
end
--增加删除某等级道具的次数
LuaAddDeleteItemCount = function(itemLevel,Val,itemID)
	if itemLevel == 0 then itemLevel = 1 end
	
	--记录品质4的 道具ID mode == 2 记录删除道具的 count
	if itemLevel == 4 then LuaAddItemStatisticsLog(itemID,"D") end

	LuaSetDeleteItemCount(itemLevel,LuaGetDeleteItemCount(itemLevel) + Val)
end
-------------------------------------------------------------------------------------------------------------

--检测用户名是否合法
LuaCheckPlayerName = function(playName)
	--判断名字是否为空
	if (not playName) or (playName == "") then
		return hVar.STRING_TRIM_MODE.NAME_NULL, g_input_erro_info[2] --"您还没有输入名字"
	end
	
	--geyachao: 最长只有15
	--mazheng: 2022/09/13 现在变21了
	if (#playName > 21) then
		return hVar.STRING_TRIM_MODE.TOOLONG, g_input_erro_info[4] --"名字最长支持15个英文或5个汉字"
	end
	
	--判断名字中是否有 空格
	if (string.find(playName, " ") ~= nil) then
		return hVar.STRING_TRIM_MODE.BLANK, g_input_erro_info[3] --"名字不能包含空格"
	end
	
	--判断是否有同名
	if Save_playerList then
		for i = 1, #Save_playerList, 1 do
			if (string.upper(Save_playerList[i].name) == string.upper(playName)) then
				return hVar.STRING_TRIM_MODE.SAME_NAME, g_input_erro_info[1] --"名字与已有存档同名"
			end
		end
	end
	
	--禁止使用的一些字符串
	--单个字符(除 ^$()%.[]*+-? 外): 与该字符自身配对
	local banStrs = {"<", ">", "/", "\\", "|", ":", "\"", "%*", "%?", ";", "computer", "电脑", ",", "%%", "`", "'", "!", "@", "#", "%$", "%^", "&", "%.", "%[", "%]", "%(", "%)", "%+", "%-",}
	for i = 1, #banStrs, 1 do
		local pos = string.find(playName, banStrs[i])
		if (pos ~= nil) then
			--print(banStrs[i])
			return hVar.STRING_TRIM_MODE.ILLEGAL_SIGN, g_input_erro_info[5] --"名字不能使用特殊字符"
		end
	end
	
	--不能以数字和特殊符号开头
	local banBeggingStrs = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "{", "}", "~", "_", "=",}
	for i = 1, #banBeggingStrs, 1 do
		local char1 = string.sub(playName, 1, 1)
		if (char1 == banBeggingStrs[i]) then
			return hVar.STRING_TRIM_MODE.ILLEGAL_BEGGING, g_input_erro_info[7] --"名字不能以数字和标点符号开头"
		end
	end
	
	--禁止使用敏感词
	local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
	for i = 1, #GLOBAL_FILTER_TEXT, 1 do
		local PLAYNAME = string.upper(playName) --转大写
		local pos = string.find(PLAYNAME, GLOBAL_FILTER_TEXT[i])
		if (pos ~= nil) then
			--print(playName, GLOBAL_FILTER_TEXT[i])
			return hVar.STRING_TRIM_MODE.ILLEGAL_TEXT, (g_input_erro_info[6] .. " \"" .. GLOBAL_FILTER_TEXT[i] .. "\" ") --"你输入的内容含有敏感词汇XXX"
		end
	end
	
	return hVar.STRING_TRIM_MODE.SUCCEED
end

-------------------------自动存档相关-----------------------------------------------------
--添加自动存档文件名至玩家表接口
LuaAddPlayerAutoSaveName = function(playerName,fileName) 
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo and type(playerInfo.autosavelist) == "table" then
		playerInfo.autosavelist[#playerInfo.autosavelist+1] = fileName
	end
end

--删除玩家的自动存档
LuaDeletePlayerAutoSave = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo and type(playerInfo.autosavelist) == "table" then
		for k,v in pairs(playerInfo.autosavelist) do
			if hApi.FileExists(v..".sav","full") then
				xlDeleteFileWithFullPath(v..".sav")
			end
			if hApi.FileExists(v..".fog","full") then
				xlDeleteFileWithFullPath(v..".fog")
			end
		end
		playerInfo.autosavelist = {}
	end
	
	--一些其他的删除
	for i = 0,99 do
		if playerName then
			if hApi.FileExists(g_localfilepath..playerName.."autosave"..i..".sav","full") then
				xlDeleteFileWithFullPath(g_localfilepath..playerName.."autosave"..i..".sav")
			end
			if hApi.FileExists(g_localfilepath..playerName.."autosave"..i..".fog","full") then
				xlDeleteFileWithFullPath(g_localfilepath..playerName.."autosave"..i..".fog")
			end
		end
	end
end
---------------------------------------------------------------------------------------------
--设置玩家DLC地图 
--检测玩家是否拥有此DLC地图 返回1 表示 有 返回 0 表示没有 返回2 表示数据表不存在
LuaCheckPlayerDLCMap = function(mapName)
	if Save_PlayerData and Save_PlayerData.dlc and Save_playerList and Save_playerList.dlc then
		for _,v in pairs(Save_PlayerData.dlc) do
			if v[_MapName] == mapName then return 1 end
		end

		for _,v in pairs(Save_playerList.dlc) do
			if v[_MapName] == mapName then return 1 end
		end

		return 0
	end
	return 2
end

--向玩家数据表中添加DLC地图 返回1 表示添加成功 返回2 表示数据表不存在 返回0 表示无需添加 已存在
LuaAddPlayerDLCMap = function(mapName)
	if Save_PlayerData and Save_PlayerData.dlc then
		for _,v in pairs(Save_PlayerData.dlc) do
			if v[_MapName] == mapName then return 0 end
		end
		Save_PlayerData.dlc[#Save_PlayerData.dlc+1] = {mapName}
		Save_playerList.dlc[#Save_playerList.dlc+1] = {mapName}
		return 1
	end
	return 2
end

---------------------------------------------------------------------------------------------
--添加掉落信息
LuaAddLootRecordFromUnit = function(playerName,oUnitOrSKey,TAG)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		if LuaCheckPamUniqueID(playerName) ~= 1 then
			return 0
		end
		local sLootKey
		if type(oUnitOrSKey)=="string" then
			sLootKey = oUnitOrSKey
		else
			local oUnit = oUnitOrSKey
			if oUnit.data.triggerID~=0 then
				sLootKey = "tgrID_"..oUnit.data.triggerID
			elseif oUnit.data.editorID~=0 then
				sLootKey = "edtID_"..oUnit.data.editorID
			else
				local oHero = oUnit:gethero()
				if oHero then
					sLootKey = "heroID_"..oHero.ID
				else
					sLootKey = "unit__ID_"..oUnit.__ID
				end
			end
		end
		if sLootKey then
			local tLootList = playerInfo.lootfromunit
			for i = 1,#tLootList do
				if tLootList[i][1] == sLootKey then
					for j = 2,#tLootList[i] do
						if tLootList[i][j]==TAG then
							return 0
						end
					end
					tLootList[i][#tLootList[i]+1] = TAG
					LuaSavePlayerList()
					return 1
				end
			end
			tLootList[#tLootList+1] = {sLootKey,TAG}
			LuaSavePlayerList()
			return 1
		end
	end
	return 2
end

LuaGetBFSkillCardCount = function()
	if Save_PlayerData and Save_PlayerData.BFSkillCardCount then
		return Save_PlayerData.BFSkillCardCount
	end
	return 0
end

LuaSetBFSkillCardCount = function(num)
	if Save_PlayerData and Save_PlayerData.BFSkillCardCount then
		Save_PlayerData.BFSkillCardCount = num
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	return 0
end


LuaClearLootFromUnit = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.lootfromunit = {}
		LuaSavePlayerList()
	end
	
end

--对战术技能书 按照 tab_tactics 进行排序
local _sequenceBFSkillBoos = function(tab)
	local tempList = {}
	for k,v in pairs(hVar.tab_tactics) do
		for i = 0,(v.level or 0) do
			for j = 1,#tab do
				if k == tab[j][1] and i == tab[j][2] then
					tempList[#tempList+1] = {tab[j][1],tab[j][2],tab[j][3]}
				end
			end
		end
	end

	return tempList
end

--设置玩家的战术技能书技能
LuaAddPlayerSkillBook = function(skillID, Lv, num, unSaveFlag)
	
	local unSaveFlag = unSaveFlag
	
	--判断战术技能卡计数器 是否正常
	if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then return 2 end
	
	--存档中记录的玩家获得的卡片count 此值必须要与 keyChain 中的一致 获得卡片流程才生效
	local BFSkillCardCount = LuaGetBFSkillCardCount()
	local new_CardCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount")
	
	--存档和keyChain同步+1
	xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount",new_CardCount+1)
	LuaSetBFSkillCardCount(BFSkillCardCount+1)
	
	--实际增加卡牌的流程
	local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO
	local tLv = Lv or 0
	if tLv > tacticLvUpInfo.maxTacticLv then
		tLv = tacticLvUpInfo.maxTacticLv
	end
	local toDebris = 0
	local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tLv]
	if tacticLvUpInfo then
		toDebris = tacticLvUpInfo.toDebris or 0
	end
	local tNum = (num or 1)
	
	--已存在战术技能卡，转化成碎片
	for _,v in pairs(Save_PlayerData.battlefieldskillbook) do
		if (skillID == v[1]) then
			--根据等级兑换成数量
			v[3] = (v[3] or 1) + (tNum or 1) * toDebris
			if v[3] < 0 then
				v[3] = 0
			end
			
			--local tab = _sequenceBFSkillBoos(Save_PlayerData.battlefieldskillbook)
			--Save_PlayerData.battlefieldskillbook = {}
			--Save_PlayerData.battlefieldskillbook = tab
			
			if not unSaveFlag then
				--存档
				--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				--安卓 保存玩家数据表
				--战术技能卡升级
				local keyList = {"skill", "material",}
				LuaSavePlayerData_Android(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog, keyList)
			end
			
			--触发事件：获得战术技能卡（碎片）
			hGlobal.event:event("Event_PlayerGetTacticCard", skillID, (tNum or 1) * toDebris)
			
			return 1
		end
	end
	
	--走到这个流程说明还没有卡，没有卡的情况下数量不可能小于0
	if (tNum > 0) then
		Save_PlayerData.battlefieldskillbook[#Save_PlayerData.battlefieldskillbook+1] = {skillID, Lv, (tNum - 1 or 0) * toDebris}
		local tab = _sequenceBFSkillBoos(Save_PlayerData.battlefieldskillbook)
		Save_PlayerData.battlefieldskillbook = {}
		Save_PlayerData.battlefieldskillbook = tab
		
		--统计获得战术技能卡
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.tacticNum)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.tacticNum)
		
		if not unSaveFlag then
			--存档
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			--安卓 保存玩家数据表
			--战术技能卡升级
			local keyList = {"skill", "material",}
			LuaSavePlayerData_Android(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog, keyList)
		end
		
		--触发事件：获得战术技能卡（碎片）
		hGlobal.event:event("Event_PlayerGetTacticCard", skillID, (tNum - 1 or 0) * toDebris)
		
		return 1
	else
		return 2
	end
end

--增加玩家的战术技能书碎片
LuaAddPlayerTacticDebris = function(skillID, num, unSaveFlag)
	
	--判断战术技能卡计数器 是否正常
	--if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then return 2 end
	
	--存档中记录的玩家获得的卡片count 此值必须要与 keyChain 中的一致 获得卡片流程才生效
	--local BFSkillCardCount = LuaGetBFSkillCardCount()
	--local new_CardCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount")
	
	--存档和keyChain同步+1
	--xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount",new_CardCount+1)
	--LuaSetBFSkillCardCount(BFSkillCardCount+1)
	
	for _,v in pairs(Save_PlayerData.battlefieldskillbook) do
		if skillID == v[1] then
			local result = (v[3] or 1) + (num or 1)
			if result < 0 then
				return 2
			end
			--根据等级兑换成数量
			v[3] = result
			if v[3] < 0 then
				v[3] = 0
			end
			
			--local tab = _sequenceBFSkillBoos(Save_PlayerData.battlefieldskillbook)
			--Save_PlayerData.battlefieldskillbook = {}
			--Save_PlayerData.battlefieldskillbook = tab
			
			--存档
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			if not unSaveFlag then
				--保存战术卡碎片
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				
				--获得战术卡碎片
				local keyList = {"skill",}
				LuaSavePlayerData_Android_Upload(keyList, "获得战术卡碎片")
			end
			
			--触发事件：获得战术技能卡（碎片）
			hGlobal.event:event("Event_PlayerGetTacticCard", skillID, (num or 1))
			
			return 1
		end
	end
	
	--走到这个流程说明还没有卡，没有卡的情况下数量不可能小于0
	local tNum = (num or 0)
	if (tNum >= 0) then
		Save_PlayerData.battlefieldskillbook[#Save_PlayerData.battlefieldskillbook+1] = {skillID, 0, (tNum or 1)}
		local tab = _sequenceBFSkillBoos(Save_PlayerData.battlefieldskillbook)
		Save_PlayerData.battlefieldskillbook = {}
		Save_PlayerData.battlefieldskillbook = tab
		
		--存档
		--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		if not unSaveFlag then
			--保存战术卡碎片
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--获得战术卡碎片
			local keyList = {"skill",}
			LuaSavePlayerData_Android_Upload(keyList, "获得战术卡碎片")
		end
		
		--触发事件：获得战术技能卡（碎片）
		hGlobal.event:event("Event_PlayerGetTacticCard", skillID, (tNum or 1))
		return 1
	else
		return 2
	end
	
end

--返回当前玩家的战术技能书数据指针
LuaGetPlayerSkillBook = function()
	if Save_PlayerData and Save_PlayerData.battlefieldskillbook then 
		return Save_PlayerData.battlefieldskillbook
	end
	return nil
end

--返回玩家战术技能卡数据指针
LuaGetPlayerTacticById = function(skillID)
	local skillBook = LuaGetPlayerSkillBook()
	if skillBook then
		for _,v in pairs(skillBook) do
			--print("__v[1]".. tostring(v[1]))
			if skillID == v[1] then
				return v
			end
		end
	end
end

--战术技能卡升级
LuaLvUpPlayerTactic = function(skillID)
	--判断战术技能卡计数器 是否正常
	if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then return 2 end
	
	--存档中记录的玩家获得的卡片count 此值必须要与 keyChain 中的一致 获得卡片流程才生效
	local BFSkillCardCount = LuaGetBFSkillCardCount()
	local new_CardCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount")
	
	--存档和keyChain同步+1
	xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount",new_CardCount+1)
	LuaSetBFSkillCardCount(BFSkillCardCount+1)
	
	local tacticInfo
	for _,v in pairs(Save_PlayerData.battlefieldskillbook) do
		if skillID == v[1] then
			tacticInfo = v
			break
			--local tab = _sequenceBFSkillBoos(Save_PlayerData.battlefieldskillbook)
			--Save_PlayerData.battlefieldskillbook = {}
			--Save_PlayerData.battlefieldskillbook = tab
		end
	end

	--如果存在
	if tacticInfo then
		local id, lv, num = unpack(tacticInfo)

		if lv >= hVar.TACTIC_LVUP_INFO.maxTacticLv then
			return 3
		end

		local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[lv]
		local costDebris = tacticLvUpInfo.costDebris or 0

		if costDebris > num then
			return 4
		else
			tacticInfo[2] = tacticInfo[2] + 1
			tacticInfo[3] = tacticInfo[3] - costDebris
			if tacticInfo[3] < 0 then
				tacticInfo[3] = 0
			end
			
			--如果大于0级是统计升级，否则统计获得新卡
			if lv > 0 then
				--统计战术技能卡升级
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.tLvUp)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.tLvUp)
			else
				--统计获得战术技能卡
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.tacticNum)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.tacticNum)
			end
			
			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			return 1
		end
	else
		return 2
	end
end

--获得战术技能ID，LV 的个数 如果激活技能中有 则排除 至少1个
LuaGetBFSkillCount = function(skillID,skillLv,mode)
	local count = 0
	local battlefieldskillbook = LuaGetPlayerSkillBook()	--返回当前玩家的战术技能书数据指针
	local activeSkill = LuaGetActiveBattlefieldSkill()
	if battlefieldskillbook and type(battlefieldskillbook) == "table" then
		for i = 1, #battlefieldskillbook do
			local id,lv,num = unpack(battlefieldskillbook[i])
			if skillID == id and skillLv == lv then
				count = num
				--对激活的技能的判断 如果 有相同ID 和相同等级的 则 对技能个数 做减一 处理
				if mode == 1 then
					for j = 1,#activeSkill do
						if type(activeSkill[j]) == "table" and skillID == activeSkill[j][1] and skillLv == activeSkill[j][2] then
							count = count - 1
						end
					end
				end
				return count
			end
		end
	end
	return count 
end



--同步存档中的兵种碎片
LuaSyncArmyTactic = function(tacticInfo)
	if Save_PlayerData and Save_PlayerData.battlefieldskillbook and tacticInfo then
		local tab_tacticsArmyEx = {}
		for i = 1, #hVar.tab_tacticsArmyEx_Atk, 1 do --兵种-进攻
			table.insert(tab_tacticsArmyEx, hVar.tab_tacticsArmyEx_Atk[i])
		end
		for i = 1, #hVar.tab_tacticsArmyEx_Def, 1 do --兵种-防守
			table.insert(tab_tacticsArmyEx, hVar.tab_tacticsArmyEx_Def[i])
		end
		
		--遍历所有已经开放的兵种卡
		for i = 1, #tab_tacticsArmyEx do
			local tacticId = tab_tacticsArmyEx[i]
			local tactic = tacticInfo[tacticId]
			local saveTactic = LuaGetPlayerTacticById(tacticId)
			if tactic then
				if saveTactic then
					saveTactic[2] = tactic.lv or 0
					saveTactic[3] = tactic.debris or 0
				else
					local unSave = true
					--添加一个
					LuaAddPlayerSkillBook(tacticId,tactic.lv,tactic.debris)
				end
			else
				if saveTactic then
					--删除一个
					saveTactic[2] = 0
					saveTactic[3] = 0
				end
			end
		end
	end
end

--在总战术卡片技能表中寻找目标卡片
local _FindSkillFromBFSkillBook = function(skillID,skillLv)
	if Save_PlayerData and Save_PlayerData.battlefieldskillbook then
		for i = 1,#Save_PlayerData.battlefieldskillbook do
			if Save_PlayerData.battlefieldskillbook[i][1] == skillID and Save_PlayerData.battlefieldskillbook[i][2] == skillLv then
				return 1,Save_PlayerData.battlefieldskillbook[i][3]
			end
		end
		return 0
	end
	return 2
end


LuaGetResolveBFSkillCount = function()
	if Save_PlayerData and Save_PlayerData.resolvebfskillcount then
		return Save_PlayerData.resolvebfskillcount
	end
	return 0
end

--设置存档里的删除卡牌计数器
LuaSetResolveBFSkillCount = function(count)
	if Save_PlayerData and Save_PlayerData.resolvebfskillcount then
		Save_PlayerData.resolvebfskillcount = count
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

LuaAddResolveBFSkillCount = function(num)
	LuaSetResolveBFSkillCount(LuaGetResolveBFSkillCount()+num)
end

--删除一张战术技能卡 
LuaResolveBFSkillCount = function(skillID,skillLv,num)
	local cur_num = LuaGetBFSkillCount(skillID,skillLv)

	local saveResolveBFSkillCount = LuaGetResolveBFSkillCount()
	local ResolveBFSkillCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."ResolveBFSkillCount")
	
	--玩家在作弊 存档中 和 key中只不等
	if saveResolveBFSkillCount ~= ResolveBFSkillCount then
		local synchronous_resolvebfskill_val = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_resolvebfskill_val")
		xlAppAnalysis("cheat_resolvebfskill",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-Nmae:"..g_curPlayerName.."-KC:"..tostring(ResolveBFSkillCount).."-SC:"..tostring(saveResolveBFSkillCount).."-syncV"..tostring(synchronous_resolvebfskill_val).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--只做一次兼容判断
		if synchronous_resolvebfskill_val == 0 then
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_resolvebfskill_val",1)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."ResolveBFSkillCount",saveResolveBFSkillCount)
		else
			local score = hVar.BFSKILL2SOCRE[10][10]
			local cur_score = LuaGetPlayerScore()
			local punishScore = -score*math.abs(ResolveBFSkillCount-saveResolveBFSkillCount)
			if math.abs(punishScore) > cur_score then
				punishScore = -cur_score
			end
			LuaAddPlayerScore(punishScore)
			LuaSetResolveBFSkillCount(ResolveBFSkillCount)
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_GameDataIllegalTip5"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			return
		end
	end

	if cur_num >= num and num > 0 then
		for _,v in pairs(Save_PlayerData.battlefieldskillbook) do
			if skillID == v[1] and skillLv == v[2] then
				v[3] = (cur_num - num)
				local temT = {}
				for i = 1,#Save_PlayerData.battlefieldskillbook do
					if Save_PlayerData.battlefieldskillbook[i][3] ~= 0 then
						temT[#temT + 1 ] = {Save_PlayerData.battlefieldskillbook[i][1],Save_PlayerData.battlefieldskillbook[i][2],Save_PlayerData.battlefieldskillbook[i][3]}
					end
				end
				Save_PlayerData.battlefieldskillbook = {}
				Save_PlayerData.battlefieldskillbook = temT

				--对已激活的战术技能 进行处理 如果 在删除卡片时，已经有激活的卡片数据，则进行删除
				for i = 1,#Save_PlayerData.activebattlefieldskill do
					if type(Save_PlayerData.activebattlefieldskill[i]) == "table" then
						local rs,num = 0,0
						rs,num = _FindSkillFromBFSkillBook(Save_PlayerData.activebattlefieldskill[i][1],Save_PlayerData.activebattlefieldskill[i][2])
						if rs == 0 then
							Save_PlayerData.activebattlefieldskill[i] = {0,0}
						end
					end
				end

				--成功删除时 统计删除次数
				LuaAddResolveBFSkillCount(1)
				ResolveBFSkillCount = ResolveBFSkillCount + 1
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."ResolveBFSkillCount",ResolveBFSkillCount)
				return 1
			end
		end
	else
		print("pama erro")
	end
	return 0
end

--设置玩家当前激活的战术技能
LuaSetActiveBattlefieldSkill = function(index,skillID,skillLV)
	if Save_PlayerData and Save_PlayerData.activebattlefieldskill then
		if skillID > 0 and skillLV > 0 then
			local nOldIndex = 0
			for i = 1,#Save_PlayerData.activebattlefieldskill do
				if Save_PlayerData.activebattlefieldskill[i] ~= 0 then
					if Save_PlayerData.activebattlefieldskill[i][1] == skillID then
						nOldIndex = i
						break
					end
				end
			end
			if nOldIndex>0 then
				Save_PlayerData.activebattlefieldskill[nOldIndex] = 0
				hGlobal.event:event("LocalEvent_Phone_afterSetSkillBook_Game",nOldIndex,0,0)
			end
			Save_PlayerData.activebattlefieldskill[index] = {skillID,skillLV}
			hGlobal.event:event("LocalEvent_Phone_afterSetSkillBook_Game",index,skillID,skillLV)
			return 1
		else
			Save_PlayerData.activebattlefieldskill[index] = 0
			hGlobal.event:event("LocalEvent_Phone_afterSetSkillBook_Game",index,0,0)

			return 1
		end
	end
	return 0
end

--清除玩家所有的已激活的战术技能
LuaClearActiveBattlefieldSkill = function()
	for i = 1,3 do
		LuaSetActiveBattlefieldSkill(i,0,0)
	end
	LuaSetUsedBookState(g_curPlayerName,0)
	hGlobal.event:event("LocalEvent_ReloadTacticsCard",0)
end

--返回玩家当前已激活的战术技能
LuaGetActiveBattlefieldSkill = function()
	if Save_PlayerData and Save_PlayerData.activebattlefieldskill then 
		return Save_PlayerData.activebattlefieldskill
	end
	return nil
end
---------------------------------------------------------------------------------------------
----设置玩家统计值
--LuaSetPlayerCountVal = function(mode,id,val)
--	if Save_PlayerLog and Save_PlayerData then
--		if mode == "useitem" then
--			for _,v in pairs(Save_PlayerLog.useitemcount) do
--				if id == v[1] and val>0 then
--					v[2] = val
--					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					return
--				end
--			end
--			Save_PlayerLog.useitemcount[#Save_PlayerLog.useitemcount+1] = {id,val}
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--		elseif mode == "killunit" then
--			for _,v in pairs(Save_PlayerLog.killcount) do
--				if id == v[1] and val>0 then
--					v[2] = val
--					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					return
--				end
--			end
--			Save_PlayerLog.killcount[#Save_PlayerLog.killcount+1] = {id,val}
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--		elseif mode == "forged" then
--			Save_PlayerLog.forgedcount = val
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--		end
--		
--	else
--		print("LuaSetPlayerCountVal erro")
--	end
--end

----设置玩家统计值
--LuaAddPlayerCountVal = function(mode,id,val)
--	if Save_PlayerLog and Save_PlayerData then
--		if mode == "useitem" then
--			for _,v in pairs(Save_PlayerLog.useitemcount) do
--				if id == v[1] and val>0 then
--					v[2] = v[2] + val
--					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					return
--				end
--			end
--			Save_PlayerLog.useitemcount[#Save_PlayerLog.useitemcount+1] = {id,val}
--		elseif mode == "killunit" then
--			for _,v in pairs(Save_PlayerLog.killcount) do
--				if id == v[1] and val>0 then
--					v[2] = v[2] + val
--					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					return
--				end
--			end
--			Save_PlayerLog.killcount[#Save_PlayerLog.killcount+1] = {id,val}
--		elseif mode == "forged" then
--			Save_PlayerLog.forgedcount = val + Save_PlayerLog.forgedcount
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--		end
--		
--	else
--		print("LuaSetPlayerCountVal erro")
--	end
--end


----获取玩家统计值
--LuaGetPlayerCountVal = function(mode,id)
--	if Save_PlayerLog then
--		if mode == "useitem" then
--			for _,v in pairs(Save_PlayerLog.useitemcount) do
--				if id == v[1] then
--					return v[2]
--				end
--			end
--			return 0
--		elseif mode == "killunit" then
--			for _,v in pairs(Save_PlayerLog.killcount) do
--				if id == v[1] then
--					return v[2]
--				end
--			end
--			return 0
--		elseif mode == "forged" then
--			return Save_PlayerLog.forgedcount or 0
--		end
--	else
--		print("LuaGetPlayerCountVal erro")
--		return 0
--	end
--end

--zhenkira 新增
--获取日常任务时间戳
LuaGetDailyQuestTimeStamp = function()
	local sTimeStamp = ""
	if Save_PlayerLog and Save_PlayerLog.quest and Save_PlayerLog.quest.daily then
		sTimeStamp = Save_PlayerLog.quest.daily.timeStamp or ""
	end
	return sTimeStamp
end

--设置日常任务时间戳
LuaSetDailyQuestTimeStamp = function(sTimeStamp)
	local ret = false
	if Save_PlayerLog and type(sTimeStamp) == "string" then
		if not Save_PlayerLog.quest then
			Save_PlayerLog.quest = {}
		end
		if not Save_PlayerLog.quest.daily then
			Save_PlayerLog.quest.daily = {}
		end
		
		Save_PlayerLog.quest.daily.timeStamp = sTimeStamp
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		ret = true
	end
	return ret
end

--获取日常任务完成情况
LuaGetDailyQuestCompletion = function(idx)
	local id, state, val, param, condition = 0,0,0,0,{}
	if Save_PlayerLog and Save_PlayerLog.quest and Save_PlayerLog.quest.daily and idx and idx > 0 and Save_PlayerLog.quest.daily[idx] then
		local questInfo = Save_PlayerLog.quest.daily[idx]
		id = questInfo[1] or 0
		state = questInfo[2] or 0
		val = questInfo[3] or 0
		param = questInfo[4] or 0
		condition = questInfo.condition or {}
	end
	return id, state, val, param, condition
end

--设置日常任务完成情况
LuaSetDailyQuestCompletion = function(idx, questInfo)
	local ret = false
	if Save_PlayerLog and type(questInfo) == "table" and idx and idx > 0 then
		if not Save_PlayerLog.quest then
			Save_PlayerLog.quest = {}
		end
		if not Save_PlayerLog.quest.daily then
			Save_PlayerLog.quest.daily = {}
		end
		if not Save_PlayerLog.quest.daily[idx] then
			Save_PlayerLog.quest.daily[idx] = {}
		end
		
		for i = 1, 4 do
			Save_PlayerLog.quest.daily[idx][i] = questInfo[i] or 0
		end
		
		if not Save_PlayerLog.quest.daily[idx]["condition"] then
			Save_PlayerLog.quest.daily[idx]["condition"] = {}
		end
		Save_PlayerLog.quest.daily[idx]["condition"][1] = questInfo["condition"][1] or hVar.MEDAL_TYPE.none
		Save_PlayerLog.quest.daily[idx]["condition"][2] = questInfo["condition"][2] or 0
		Save_PlayerLog.quest.daily[idx]["condition"][3] = questInfo["condition"][3] or 0
		
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		ret = true
	end
	return ret
end

--获取日常任务属性
LuaGetDailyQuestCompletionAttr = function(idx, valIdx)
	local ret = 0
	if Save_PlayerLog and Save_PlayerLog.quest and Save_PlayerLog.quest.daily and idx and idx > 0 and Save_PlayerLog.quest.daily[idx] then
		local questInfo = Save_PlayerLog.quest.daily[idx]
		
		if valIdx then
			if type(valIdx) == "number" and valIdx > 0 then
				ret = questInfo[valIdx] or 0
			elseif type(valIdx) == "string" and valIdx == "condition" then
				ret = questInfo[valIdx] or {}
			end
		end
	end
	return ret
end

--设置日常任务属性
LuaSetDailyQuestCompletionAttr = function(idx, valIdx, val)
	local ret = false
	if Save_PlayerLog and idx and idx > 0 then
		if not Save_PlayerLog.quest then
			Save_PlayerLog.quest = {}
		end
		if not Save_PlayerLog.quest.daily then
			Save_PlayerLog.quest.daily = {}
		end
		if not Save_PlayerLog.quest.daily[idx] then
			Save_PlayerLog.quest.daily[idx] = {}
		end

		if valIdx then 
			if type(valIdx) == "number" and valIdx > 0 then
				Save_PlayerLog.quest.daily[idx][valIdx] = val or 0
			elseif type(valIdx) == "string" and valIdx == "condition" then
				if not Save_PlayerLog.quest.daily[idx][valIdx] then
					Save_PlayerLog.quest.daily[idx][valIdx] = {}
				end
				Save_PlayerLog.quest.daily[idx][valIdx][1] = val[1] or hVar.MEDAL_TYPE.none
				Save_PlayerLog.quest.daily[idx][valIdx][2] = val[2] or 0
				Save_PlayerLog.quest.daily[idx][valIdx][3] = val[3] or 0
			end
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			ret = true
		end
	end
	return ret
end

--设置玩家统计值
LuaSetDailyQuestCountVal = function(mode,val1,val2)
	local timeStamp = LuaGetDailyQuestTimeStamp()
	--如果时间戳不存在，则非法
	if timeStamp ~= "" then

		--遍历3个任务
		for i = 1, 3 do
			local id, state, val, param, conditions = LuaGetDailyQuestCompletion(i)
			--如果任务id存在，并且任务当前未完成
			if id > 0 and state == 0 then
				local flag = false
				local condition = conditions[1] 
				local cval1 = conditions[2]
				local cval2 = conditions[3]
				if mode == condition then
					--地图通关信息
					if condition == hVar.MEDAL_TYPE.map then
						if val1 == cval1 then
							LuaSetDailyQuestCompletionAttr(i, 3, 1)
						end
					elseif condition == hVar.MEDAL_TYPE.mapCondition or condition == hVar.MEDAL_TYPE.chapterCondition then
						if hApi.CheckMapCondition and hApi.CheckMapCondition(condition,val1,cval1) then
							--print("LuaSetDailyQuestCompletionAttr(i, 3, 1)")
							--LuaAddDailyQuestCompletionAttr(i, 3, 1)
							LuaAddDailyQuestCompletionAttr(i, 3, val or 0)
						end
					elseif condition == hVar.MEDAL_TYPE.killUT or condition == hVar.MEDAL_TYPE.buildTT or condition == hVar.MEDAL_TYPE.killUS or condition == hVar.MEDAL_TYPE.buyItem then
						if val1 == cval1 then
							LuaSetDailyQuestCompletionAttr(i, 3, val2 or 0)
						end
					elseif condition == hVar.MEDAL_TYPE.td_wj_001 or condition == hVar.MEDAL_TYPE.td_wj_002 then
						--设置成当前最高值
						LuaSetDailyQuestCompletionAttr(i, 3, math.max((val1 or 0),val))
					else
						LuaSetDailyQuestCompletionAttr(i, 3, val1 or 0)
					end
				end
			end
		end
	else
		print("LuaSetDailyQuestCountVal erro")
	end
end

--玩家统计值增加（如果没有填值，自动+1）
LuaAddDailyQuestCountVal = function(mode,val1,val2)
	

	local timeStamp = LuaGetDailyQuestTimeStamp()

	--如果时间戳不存在，则非法
	if timeStamp ~= "" then
		

		--遍历3个任务
		for i = 1, 3 do
			local id, state, val, param, conditions = LuaGetDailyQuestCompletion(i)
			--如果任务id存在，并且任务当前未完成
			if id > 0 and state == 0 then
				local flag = false
				local condition = conditions[1] 
				local cval1 = conditions[2]
				local cval2 = conditions[3]
				if mode == condition then
					--地图通关信息
					if condition == hVar.MEDAL_TYPE.map then
						if val1 == cval1 then
							LuaSetDailyQuestCompletionAttr(i, 3, 1)
						end
					elseif condition == hVar.MEDAL_TYPE.mapCondition or condition == hVar.MEDAL_TYPE.chapterCondition then
						if hApi.CheckMapCondition and hApi.CheckMapCondition(condition,val1,cval1) then
							--print("LuaSetDailyQuestCompletionAttr(i, 3, 1)")
							LuaSetDailyQuestCompletionAttr(i, 3, val + 1)
						end
					elseif condition == hVar.MEDAL_TYPE.killUT or condition == hVar.MEDAL_TYPE.buildTT or condition == hVar.MEDAL_TYPE.killUS or condition == hVar.MEDAL_TYPE.buyItem then
						if val1 == cval1 then
							LuaSetDailyQuestCompletionAttr(i, 3, (val + (val2 or 1)))
						end
					elseif condition == hVar.MEDAL_TYPE.td_wj_001 or condition == hVar.MEDAL_TYPE.td_wj_002 then
						--设置成当前最高值
						LuaSetDailyQuestCompletionAttr(i, 3, math.max((val1 or 0),val))
					else
						LuaSetDailyQuestCompletionAttr(i, 3, (val + (val1 or 1)))
					end
				end
			end
		end
	else
		--print("LuaAddDailyQuestCountVal erro")
	end
end

--设置玩家统计值
LuaSetPlayerCountVal = function(mode,val1,val2)
	if Save_PlayerData then
		if not Save_PlayerData.medal_statistical then
			Save_PlayerData.medal_statistical = {}
		end
		
		--地图通关信息
		if mode == hVar.MEDAL_TYPE.map or mode == hVar.MEDAL_TYPE.mapCondition or mode == hVar.MEDAL_TYPE.chapterCondition then
		--击杀特殊单位
		--or 累计建造N个塔(箭塔，炮塔，法术塔，毒塔，连弩塔，狙击塔，巨炮塔，地震塔，滚石塔，火塔，电塔，冰塔)
		elseif mode == hVar.MEDAL_TYPE.mapCondition or mode == hVar.MEDAL_TYPE.chapterCondition then
			
		elseif mode == hVar.MEDAL_TYPE.killUT or mode == hVar.MEDAL_TYPE.buildTT or mode == hVar.MEDAL_TYPE.killUS then
			if not Save_PlayerData.medal_statistical[mode] then
				Save_PlayerData.medal_statistical[mode] = {}
			end
			
			--防止存档中有错误数据
			if type(Save_PlayerData.medal_statistical[mode]) == "number" then
				Save_PlayerData.medal_statistical[mode] = {}
			end
			
			if val1 then
				Save_PlayerData.medal_statistical[mode][val1] =  val2 or 0
				--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			else
				print("LuaSetPlayerCountVal erro val1:", val1)
				return
			end
		--累计充值
		elseif mode == hVar.MEDAL_TYPE.deposit then
			LuaSetTopupCoinCount(val1 or 0)
		--开宝箱总数
		elseif mode == hVar.MEDAL_TYPE.openChest then
			--LuaSetUseDepletion(val1 or 0)
			Save_PlayerData.medal_statistical[mode] = val1 or 0
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		else
			Save_PlayerData.medal_statistical[mode] = val1 or 0
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

			if mode == hVar.MEDAL_TYPE.apNum then
				if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
					hApi.xlGameCenter_reportScore(Save_PlayerData.medal_statistical[mode],"td.p.achievement")
				end
			end
		end
		
		hGlobal.event:event("LocalEvent_PlayerCountValChange", mode,val1,val2)
	else
		print("LuaSetPlayerCountVal erro")
		return
	end
end

--玩家统计值增加（如果没有填值，自动+1）
LuaAddPlayerCountVal = function(mode,val1,val2)
	if Save_PlayerData then
		if not Save_PlayerData.medal_statistical then
			Save_PlayerData.medal_statistical = {}
		end
		
		--地图通关信息
		if mode == hVar.MEDAL_TYPE.map or mode == hVar.MEDAL_TYPE.mapCondition or mode == hVar.MEDAL_TYPE.chapterCondition then
		--击杀特殊单位
		--or 累计建造N个塔(箭塔，炮塔，法术塔，毒塔，连弩塔，狙击塔，巨炮塔，地震塔，滚石塔，火塔，电塔，冰塔)
		elseif mode == hVar.MEDAL_TYPE.killUT or mode == hVar.MEDAL_TYPE.buildTT or mode == hVar.MEDAL_TYPE.killUS then
			if not Save_PlayerData.medal_statistical[mode] then
				Save_PlayerData.medal_statistical[mode] = {}
			end
			
			--防止存档中有错误数据
			if type(Save_PlayerData.medal_statistical[mode]) == "number" then
				Save_PlayerData.medal_statistical[mode] = {}
			end
			
			if val1 then
				Save_PlayerData.medal_statistical[mode][val1] =  (Save_PlayerData.medal_statistical[mode][val1] or 0) + (val2 or 1)
				--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			else
				print("LuaSetPlayerCountVal erro val1:", val1)
				return
			end
		--累计充值
		elseif mode == hVar.MEDAL_TYPE.deposit then
			LuaSetTopupCoinCount(LuaGetTopupCoinCount() + (val1 or 1))
		--开宝箱总数
		elseif mode == hVar.MEDAL_TYPE.openChest then
			--LuaAddUseDepletion(val1 or 0)
			Save_PlayerData.medal_statistical[mode] = (Save_PlayerData.medal_statistical[mode] or 0) + (val1 or 1)
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		else
			Save_PlayerData.medal_statistical[mode] = (Save_PlayerData.medal_statistical[mode] or 0) + (val1 or 1)
			--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			if mode == hVar.MEDAL_TYPE.apNum then
				--上传成就到排行榜
				if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
					hApi.xlGameCenter_reportScore(Save_PlayerData.medal_statistical[mode],"td.p.achievement")
				end
			end
		end
		
		hGlobal.event:event("LocalEvent_PlayerCountValChange", mode,val1,val2)
	else
		print("LuaAddPlayerCountVal erro")
		return
	end
end

----获取玩家统计值
LuaGetPlayerCountVal = function(mode,id)
	if Save_PlayerData and Save_PlayerData.medal_statistical then
		if Save_PlayerData.medal_statistical[mode] then
			
			--地图通关信息
			if mode == hVar.MEDAL_TYPE.map or mode == hVar.MEDAL_TYPE.mapCondition or mode == hVar.MEDAL_TYPE.chapterCondition then
			--击杀特殊单位
			--or 累计建造N个塔(箭塔，炮塔，法术塔，毒塔，连弩塔，狙击塔，巨炮塔，地震塔，滚石塔，火塔，电塔，冰塔)
			elseif mode == hVar.MEDAL_TYPE.killUT or mode == hVar.MEDAL_TYPE.buildTT or mode == hVar.MEDAL_TYPE.killUS then
				return Save_PlayerData.medal_statistical[mode][id] or 0
			--累计充值
			elseif mode == hVar.MEDAL_TYPE.deposit then
				return LuaGetTopupCoinCount()
			--开宝箱总数
			elseif mode == hVar.MEDAL_TYPE.openChest then
				--return LuaGetUseDepletion()
				return Save_PlayerData.medal_statistical[mode] or 0
			else
				return Save_PlayerData.medal_statistical[mode] or 0
			end
		else
			--print("LuaGetPlayerCountVal error1 mode:", mode)
			return 0
		end
	
	else
		--print("LuaGetPlayerCountVal error2")
		return 0
	end
end

--获取玩家累计获得的星星
LuaGetPlayerStarCountVal = function()
	local tStars = {}
	local totalStar = 0
	
	--依次遍历每个章节
	for i = 1, #hVar.tab_chapter, 1 do
		local tChapter = hVar.tab_chapter[i]
		local firstmap = tChapter.firstmap --第一关
		local lastmap = tChapter.lastmap --最后一关
		
		tStars[i] = 0
		
		--依次读取地图获得的星星
		local currentmap = firstmap
		while true do
			--[[
			local normalStar = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0 --普通模式的星星
			local diffMax = (LuaGetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0) --挑战模式的难度
			local diffStar = (LuaGetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0) --挑战模式的星星
			
			--计算本关总星星
			local star = normalStar
			if (diffMax > 0) then
				star = normalStar + (diffMax - 1) * 3 + diffStar
			end
			--print(currentmap, star)
			]]
			local normalStar = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0 --普通模式的星星
			local star1 = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.RICHMAN) or 0 --难度1的星星
			local star2 = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.BLITZ) or 0 --难度2的星星
			local star3 = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0 --难度3的星星
			local star = normalStar + star1 + star2 + star3
			
			--统计总值
			totalStar = totalStar + star
			tStars[i] = tStars[i] + star
			
			if (currentmap == lastmap) then
				break
			end
			
			currentmap = hVar.MAP_INFO[currentmap].nextmap[1]
		end
	end
	
	return totalStar, tStars
end




---------------------------------------------------------------------------------------------------------------------------------------
--设置战车点击评价按钮的时间戳
LuaSetCommentClickTime = function(count)
	if Save_PlayerData then
		--获得当前时间(北京时区)
		local clienttime = count
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hosttime = hosttime - delteZone * 3600 --GMT+8时区
		
		Save_PlayerData.tank_comment_click_time = hosttime
		
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--上传存档
		local keyList = {"material"}
		LuaSavePlayerData_Android_Upload(keyList, "战车点击评价按钮")
	else
		print("LuaSetCommentClickCount erro")
		return
	end
end

--读取战车点击评价按钮的时间戳
LuaGetCommentClickTime = function()
	local count = 0
	
	if Save_PlayerData then
		count = Save_PlayerData.tank_comment_click_time or 0
	end
	
	return count
end

--设置战车昨日排名名次
LuaSetTankYesterdayRank = function(rank)
	if Save_PlayerData then
		Save_PlayerData.tank_yesterday_rank = rank
		
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	else
		print("LuaSetTankYesterdayRank erro")
		return
	end
end

--读取战车昨日排名名次
LuaGetTankYesterdayRank = function()
	local rank = 0
	
	if Save_PlayerData then
		rank = Save_PlayerData.tank_yesterday_rank or 0
	end
	
	return rank
end

--设置战车低配模式开关
LuaSetTankLowConfigMode = function(flag, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tank_lowconfigmode_flag = flag
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	else
		print("LuaSetTankLowConfigMode erro")
		return
	end
end

--读取战车低配模式开关
LuaGetTankLowConfigMode = function()
	local flag = 0
	
	if Save_PlayerData then
		flag = Save_PlayerData.tank_lowconfigmode_flag or 0
	end
	
	return flag
end


--------------------------------------------------------------------------
--设置战车武器枪宝箱数量
LuaSetTankWeaponGunChestNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.weapongunChestNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车武器枪宝箱数量
LuaGetTankWeaponGunChestNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.weapongunChestNum or 0
	end
	
	return num
end

--增加战车武器枪宝箱数量
LuaAddTankWeaponGunChestNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.weapongunChestNum = Save_PlayerData.weapongunChestNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置战车战术卡宝箱数量
LuaSetTankTacticChestNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tacticChestNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车战术卡宝箱数量
LuaGetTankTacticChestNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tacticChestNum or 0
	end
	
	return num
end

--增加战车战术卡宝箱数量
LuaAddTankTacticChestNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tacticChestNum = Save_PlayerData.tacticChestNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置战车宠物宝箱数量
LuaSetTankPetChestNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.petChestNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车宠物宝箱数量
LuaGetTankPetChestNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.petChestNum or 0
	end
	
	return num
end

--增加战车宠物宝箱数量
LuaAddTankPetChestNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.petChestNum = Save_PlayerData.petChestNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------




--------------------------------------------------------------------------
--设置战车装备宝箱数量
LuaSetTankEquipChestNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.equipChestNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车装备宝箱数量
LuaGetTankEquipChestNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.equipChestNum or 0
	end
	
	return num
end

--增加战车装备宝箱数量
LuaAddTankEquipChestNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.equipChestNum = Save_PlayerData.equipChestNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置战车营救科学家数量
LuaSetTankScientistNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车营救科学家宝箱数量
LuaGetTankScientistNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.scientistNum or 0
	end
	
	return num
end

--增加战车营救科学家数量
LuaAddTankScientistNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistNum = Save_PlayerData.scientistNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置战车死亡数量
LuaSetTankDeadthNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthNum = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车死亡数量
LuaGetTankDeadthNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthNum or 0
	end
	
	return num
end

--增加战车死亡数量
LuaAddTankDeadthNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthNum = Save_PlayerData.tankDeadthNum + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置战地鼠币数量
LuaSetTankDiShuCoinNum = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.dishuCoin = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取战车地鼠币数量
LuaGetTankDiShuCoinNum = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.dishuCoin or 0
	end
	
	return num
end

--增加战车地鼠币数量
LuaAddTankDiShuCoinNum = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.dishuCoin = Save_PlayerData.dishuCoin + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置科学家成就1
LuaSetScientistAchievnemtn1 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn1 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取科学家成就1
LuaGetScientistAchievnemtn1 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.scientistAchievnemtn1 or 0
	end
	
	return num
end

--增加科学家成就1
LuaAddScientistsAchievnemtn1 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn1 = Save_PlayerData.scientistAchievnemtn1 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置科学家成就2
LuaSetScientistAchievnemtn2 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn2 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取科学家成就2
LuaGetScientistAchievnemtn2 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.scientistAchievnemtn2 or 0
	end
	
	return num
end

--增加科学家成就2
LuaAddScientistsAchievnemtn2 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn2 = Save_PlayerData.scientistAchievnemtn2 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置科学家成就3
LuaSetScientistAchievnemtn3 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn3 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取科学家成就3
LuaGetScientistAchievnemtn3 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.scientistAchievnemtn3 or 0
	end
	
	return num
end

--增加科学家成就3
LuaAddScientistsAchievnemtn3 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn3 = Save_PlayerData.scientistAchievnemtn3 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置科学家成就4
LuaSetScientistAchievnemtn4 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn4 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取科学家成就4
LuaGetScientistAchievnemtn4 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.scientistAchievnemtn4 or 0
	end
	
	return num
end

--增加科学家成就4
LuaAddScientistsAchievnemtn4 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.scientistAchievnemtn4 = Save_PlayerData.scientistAchievnemtn4 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置垃圾堆成就1
LuaSetTankDeadthAchievnemtn1 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn1 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取垃圾堆成就1
LuaGetTankDeadthAchievnemtn1 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthAchievnemtn1 or 0
	end
	
	return num
end

--增加垃圾堆成就1
LuaAddTankDeadthsAchievnemtn1 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn1 = Save_PlayerData.tankDeadthAchievnemtn1 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置垃圾堆成就2
LuaSetTankDeadthAchievnemtn2 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn2 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取垃圾堆成就2
LuaGetTankDeadthAchievnemtn2 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthAchievnemtn2 or 0
	end
	
	return num
end

--增加垃圾堆成就2
LuaAddTankDeadthsAchievnemtn2 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn2 = Save_PlayerData.tankDeadthAchievnemtn2 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置垃圾堆成就3
LuaSetTankDeadthAchievnemtn3 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn3 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取垃圾堆成就3
LuaGetTankDeadthAchievnemtn3 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthAchievnemtn3 or 0
	end
	
	return num
end

--增加垃圾堆成就3
LuaAddTankDeadthsAchievnemtn3 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn3 = Save_PlayerData.tankDeadthAchievnemtn3 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置垃圾堆成就4
LuaSetTankDeadthAchievnemtn4 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn4 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取垃圾堆成就4
LuaGetTankDeadthAchievnemtn4 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthAchievnemtn4 or 0
	end
	
	return num
end

--增加垃圾堆成就4
LuaAddTankDeadthsAchievnemtn4 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn4 = Save_PlayerData.tankDeadthAchievnemtn4 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--设置垃圾堆成就5
LuaSetTankDeadthAchievnemtn5 = function(num, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn5 = num
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--读取垃圾堆成就5
LuaGetTankDeadthAchievnemtn5 = function()
	local num = 0
	
	if Save_PlayerData then
		num = Save_PlayerData.tankDeadthAchievnemtn5 or 0
	end
	
	return num
end

--增加垃圾堆成就5
LuaAddTankDeadthsAchievnemtn5 = function(addnum, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankDeadthAchievnemtn5 = Save_PlayerData.tankDeadthAchievnemtn5 + addnum
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end
--------------------------------------------------------------------------


--设置战车引导点击按钮的次数
LuaSetTankClickGuideBtnCount = function(count)
	if Save_PlayerData then
		Save_PlayerData.tank_guide_clickbtn_count = count
		
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	else
		print("LuaSetTankClickGuideBtnCount erro")
		return
	end
end

------------------------------------------------
---------------装备新接口-----------------------
g_TempUidPosInfo = {}
g_TempUidIndexInfo = {}

LuaGetStoreHouse = function()
	if Save_PlayerData and Save_PlayerData.storehouse then
		return Save_PlayerData.storehouse
	end
end

--通过uid获取装备信息
LuaFindEquipByUniqueId = function(nUniqueId)
	local tPos,oEquip = nil,0
	if type(nUniqueId) == "number" and nUniqueId > 0 then
		if g_TempUidPosInfo[nUniqueId] then
			tPos = g_TempUidPosInfo[nUniqueId]
		end
		if g_TempUidIndexInfo[nUniqueId] then
			local index = g_TempUidIndexInfo[nUniqueId]
			local playerbag = LuaGetPlayerBag()
			oEquip = playerbag[index]
		end
		--测试代码  进行检测
		local bPosFlag = LuaCheckUidByEquipPosInfo(nUniqueId,tPos)
		local equipuid = 0
		if type(oEquip) == "table" then
			equipuid = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
		end
		local bUidFlag = (equipuid == nUniqueId)
		--print(nUniqueId,bPosFlag,bUidFlag)
	end
	return tPos,oEquip
end

LuaFindEquipByPos = function(tPos)
	local uid,oEquip = 0,0
	if type(tPos) == "table" then
		local swhere = tPos[1]
		if swhere == "hero" then
			local heroid = tPos[2]
			local index = tPos[3]
			local tHeroCard = hApi.GetHeroCardById(heroid)
			if tHeroCard then
				local equipment = tHeroCard.equipment
				if type(equipment) == "table" then
					uid = equipment[index] or 0
				end
			else
				uid = -1
			end
		elseif swhere == "storehouse" then
			local index = tPos[2]
			local storehouse = Save_PlayerData.storehouse
			if type(storehouse) == "table" then
				local unique = storehouse[index]
				uid = storehouse[index] or 0
			end
		end
		if type(uid) == "number" and uid > 0 then
			_,oEquip = LuaFindEquipByUniqueId(uid)
		else
			uid = 0
		end
	end
	return uid,oEquip
end

--清理装备位置信息
LuaClearEquipPosInfo = function()
	g_TempUidPosInfo = {}
	g_TempUidIndexInfo = {}
end

--记录装备位置信息
LuaRecordEquipPosInfo = function(nUniqueId,tPos)
	--print("LuaRecordEquipPosInfo",nUniqueId)
	local lastPos
	if type(nUniqueId) == "number" then
		if g_TempUidPosInfo[nUniqueId] then
			lastPos = g_TempUidPosInfo[nUniqueId]
		end
		if type(lastPos) == "table" and type(tPos) == "table" then
			local ischange = 0
			for i = 1,#lastPos do
				if lastPos[i] ~= tPos[i] then
					ischange = 1
					break
				end
			end
			if ischange == 0 then
				return
			end
		end
		--table_print(tPos)
		if type(tPos) == "table" then
			local swhere = tPos[1]
			if swhere == "hero" then
				local heroid = tPos[2]
				local index = tPos[3]
				local tHeroCard = hApi.GetHeroCardById(heroid)
				if tHeroCard then
					local equipment = tHeroCard.equipment
					if type(equipment) == "table" then
						equipment[index] = nUniqueId
					end
				end
			elseif swhere == "storehouse" then
				local index = tPos[2] or 0
				local storehouse = Save_PlayerData.storehouse
				if type(storehouse) == "table" then
					--table_print(storehouse)
					if index == 0 then
						for i = 1,#storehouse do
							local uid = storehouse[i]
							if type(uid) ~= "number" or uid == 0 then
								storehouse[i] = nUniqueId
								tPos[2] = i
								break
							end
						end
					else
						storehouse[index] = nUniqueId
					end
				end
			end
			g_TempUidPosInfo[nUniqueId] = tPos
		else
			if g_TempUidPosInfo[nUniqueId] then
				local oldPos = g_TempUidPosInfo[nUniqueId]
				table_print(oldPos)
				LuaClearUidByEquipPosInfo(nUniqueId,oldPos)
			end
			g_TempUidPosInfo[nUniqueId] = nil
		end
	end
	
	
	return lastPos
end

LuaClearUidByEquipPosInfo = function(nUniqueId,tPos)
	if type(nUniqueId) == "number" then
		if type(tPos) == "table" then
			local swhere = tPos[1]
			if swhere == "hero" then
				local heroid = tPos[2]
				local index = tPos[3]
				local tHeroCard = hApi.GetHeroCardById(heroid)
				if tHeroCard then
					local equipment = tHeroCard.equipment
					if type(equipment) == "table" then
						local unique = equipment[index]
						if type(unique) == "number" and unique ~= 0 and unique == nUniqueId then
							equipment[index] = 0
						end
					end
				end
			elseif swhere == "storehouse" then
				local index = tPos[2]
				local storehouse = Save_PlayerData.storehouse
				if type(storehouse) == "table" then
					local unique = storehouse[index]
					print(unique,index,nUniqueId)
					if type(unique) == "number" and unique ~= 0 and unique == nUniqueId then
						storehouse[index] = 0
					end
				end
			end
		else
			--清理仓库
			local storehouse = Save_PlayerData.storehouse
			if type(storehouse) == "table" then
				for i = 1,#storehouse do
					local unique = storehouse[index]
					if type(unique) == "number" and unique ~= 0 and unique == nUniqueId then
						--print("11111111111111")
						storehouse[index] = 0
						break
					end
				end
			end
		end
	end
end

LuaCheckUidByEquipPosInfo = function(nUniqueId,tPos)
	local bFlag = false
	if type(tPos) == "table" and type(nUniqueId) == "number" then
		local swhere = tPos[1]
		if swhere == "hero" then
			local heroid = tPos[2]
			local index = tPos[3]
			local tHeroCard = hApi.GetHeroCardById(heroid)
			if tHeroCard then
				local equipment = tHeroCard.equipment
				if type(equipment) == "table" then
					local unique = equipment[index]
					if type(unique) == "number" and unique ~= 0 and unique == nUniqueId then
						bFlag = true
					end
				end
			end
		elseif swhere == "storehouse" then
			local index = tPos[2]
			local storehouse = Save_PlayerData.storehouse
			if type(storehouse) == "table" then
				local unique = storehouse[index]
				if type(unique) == "number" and unique ~= 0 and unique == nUniqueId then
					bFlag = true
				end
			end
		end
	end
	return bFlag
end

LuaTidyStorehouse = function()
	local equipinfo = {}
	local storehouse = LuaGetStoreHouse()
	if (type(storehouse) == "table") then
		for index = 1,hVar.EquipMaxNum do
			local uid = storehouse[index]
			local _,oEquip = LuaFindEquipByUniqueId(uid)
			if type(oEquip) == "table" then
				local itemid = oEquip[hVar.ITEM_DATA_INDEX.ID]
				local itemuid = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
				local level = (hVar.tab_item[itemid] or {}).itemLv
				equipinfo[#equipinfo + 1] = {itemid,itemuid,level}
			end
		end
	end
	table.sort(equipinfo,function(equip1,equip2)
		local itemid1,uid1,level1 = unpack(equip1)
		local itemid2,uid2,level2 = unpack(equip2)
		if level1 == level2 then
			if itemid1 == itemid2 then
				return uid1 < uid2
			else
				return itemid1 < itemid2
			end
		else
			return level1 > level2
		end
	end)
	--table_print(equipinfo)
	g_TempUidPosInfo = {}
	Save_PlayerData.storehouse = hApi.NumTable(hVar.PLAYERBAG_NAXNUM)
	for i = 1,#equipinfo do
		local uid = equipinfo[i][2]
		local tPos = {"storehouse",i}
		LuaRecordEquipPosInfo(uid,tPos)
	end
	local keyList = {"material"}
	LuaSavePlayerData_Android_Upload(keyList, "整理装备")
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

---------------------------------------------------------------------------------------------------
--读取玩家是否有已完成的任务标记
LuaGetTaskFinishFlag = function(playerName)
	local task_finish_flag = 0
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		task_finish_flag = player.task_finish_flag or 0 --任务是否有完成提示
	end
	
	return task_finish_flag
end

--设置玩家是否有已完成的任务标记
LuaSetTaskFinishFlag = function(playerName, flag, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.task_finish_flag = flag --任务是否有完成提示
		
		--本地存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--清除玩家是否有已完成的任务标记
LuaClearTaskFinishFlag = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.task_finish_flag = 0 --任务是否有完成提示
		
		--本地存档
		LuaSavePlayerList()
	end
end

---------------------------------------------------------------------------------------------------
--读取玩家夺塔奇兵免费锦囊今日是否可免费
LuaGetTaskPVPFreeChestFlag = function(playerName)
	local task_pvp_freechest_flag = 0
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		task_pvp_freechest_flag = player.task_pvp_freechest_flag or 0 --夺塔奇兵免费锦囊今日是否可免费
	end
	
	return task_pvp_freechest_flag
end

--设置玩家夺塔奇兵免费锦囊今日是否可免费
LuaSetTaskPVPFreeChestFlag = function(playerName, flag, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.task_pvp_freechest_flag = flag --夺塔奇兵免费锦囊今日是否可免费
		
		--本地存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--清除玩家夺塔奇兵免费锦囊今日是否可免费
LuaClearTaskPVPFreeChestFlag = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.task_pvp_freechest_flag = 0 --夺塔奇兵免费锦囊今日是否可免费
		
		--本地存档
		LuaSavePlayerList()
	end
end

--获取最后使用的用户位
xlGetRepairOldEquipState = function()
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("RepairOldEquipState")
	--PC版
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("RepairOldEquipState")
	end
end

xlSetRepairOldEquipState = function(state)
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("RepairOldEquipState",state)
	--PC版
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("RepairOldEquipState",state)
		CCUserDefault:sharedUserDefault():flush()
	end
end

LuaRepairOldEquipData = function()
	local state = xlGetRepairOldEquipState()
	if state == 0 then
		if Save_PlayerData.herocard then
			for i = 1,#Save_PlayerData.herocard do
				local tHeroCard = Save_PlayerData.herocard[i]
				if tHeroCard then
					local heroid = tHeroCard.id
					local equipment = tHeroCard.equipment
					if type(equipment) == "table" then
						for i = 1,#equipment do
							local oEquip = equipment[i]
							if type(oEquip) == "table" then
								local unique = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
								LuaGainNewEquip(oEquip)
								equipment[i] = unique
							end
						end
					end
					--print("LuaRepairOldEquipData",heroid)
					--table_print(tHeroCard.equipment)
				end
				
			end
		end
	end
	xlSetRepairOldEquipState(1)
end

--初始化装备数据
LuaInitEquipData = function()
	--清空
	LuaClearEquipPosInfo()
	--修复老存档的装备数据
	LuaRepairOldEquipData()
	
	if Save_PlayerData then
		Save_PlayerData.storehouse = hApi.NumTable(hVar.PLAYERBAG_NAXNUM)
		--先保英雄存现有的装备uid位置信息
		if Save_PlayerData.herocard then
			for i = 1,#Save_PlayerData.herocard do
				local tHeroCard = Save_PlayerData.herocard[i]
				if tHeroCard then
					local heroid = tHeroCard.id
					local equipment = tHeroCard.equipment
					if type(equipment) == "table" then
						for i = 1,#equipment do
							local nUid = equipment[i]
							if type(nUid) == "number" and nUid > 0 then
								local tPos = {"hero",heroid,i}
								local lastPos = LuaRecordEquipPosInfo(nUid,tPos)
								if lastPos then
									--同一个uid存放到了多个位置  需要清理
									LuaClearUidByEquipPosInfo(nUid,lastPos)
								end
							end
						end
					end
				end
			end
		end
		--再保存仓库装备uid位置信息
		if Save_PlayerData.storehouse then
			for i = 1,#Save_PlayerData.storehouse do
				local nUid = Save_PlayerData.storehouse[i]
				if type(nUid) == "number" and nUid > 0 then
					local tPos = {"storehouse",i}
					local lastPos = LuaRecordEquipPosInfo(nUid,tPos)
					if lastPos then
						--同一个uid存放到了多个位置  需要清理
						LuaClearUidByEquipPosInfo(nUid,lastPos)
					end
				end
			end
		end
		--然后补上未关联的装备位置
		local checkuidlist = {}
		if Save_PlayerData.bag then
			local num = 0
			for i = 1,#Save_PlayerData.bag do
				local oEquip = Save_PlayerData.bag[i]
				if type(oEquip) == "table" then
					local unique = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
					local tPos = LuaFindEquipByUniqueId(unique)
					if tPos == nil then
						--print("tPos nil",i,unique)
						--没找到装备被关联  自动塞入仓库
						LuaAutoMoveEquipToStorehouse(unique)
					end
					checkuidlist[unique] = 1
					g_TempUidIndexInfo[unique] = i
					num = num + 1
				end
			end
			Save_PlayerData.bag.num = num
		end
		--再删除无效的uid位置
		for uid,posinfo in pairs(g_TempUidPosInfo) do
			if checkuidlist[uid] ~= 1 then
				--该uid已不存在 需要清理
				LuaClearUidByEquipPosInfo(uid,posinfo)
				g_TempUidPosInfo[uid] = nil
			end
		end
		--print("Save_PlayerData.storehouse")
		--table_print(Save_PlayerData.storehouse)
		--table_print(Save_PlayerData.bag)
		--table_print(g_TempUidPosInfo)
		--table_print(g_TempUidIndexInfo)
		local keyList = {"card","bag","material"}
		LuaSavePlayerData_Android_Upload(keyList, "登录自检装备数据")
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

LuaAutoMoveEquipToStorehouse = function(nUniqueId)
	if Save_PlayerData and Save_PlayerData.storehouse then
		for i = 1,hVar.EquipMaxNum do
			local nUid = Save_PlayerData.storehouse[i]
			if type(nUid) ~= "number" or  nUid == 0 then
				local tPos = {"storehouse",i}
				LuaRecordEquipPosInfo(nUniqueId,tPos)
				Save_PlayerData.storehouse[i] = nUniqueId
				break
			end
		end
	end
end

--获得新装备 统一塞到bag里 仓库和英雄装备栏只存uid 
--uid对应英雄装备栏 或者仓库的序号  会在初始化时候存到临时内存 以便以后抓作弊 或者增加获取效率
LuaGainNewEquip = function(oEquip)
	local bFlag = false
	if Save_PlayerData and type(oEquip) == "table" then
		local bag = Save_PlayerData.bag
		if (type(bag) == "table") then
			for i = 1,hVar.EquipMaxNum do
				local Equip = bag[i]
				if Equip == 0 or Equip == nil then
					Save_PlayerData.bag[i] = oEquip
					local unique = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
					bFlag = true
					Save_PlayerData.bag.num = 1 + (Save_PlayerData.bag.num or 0)
					g_TempUidIndexInfo[unique] = i
					--uid塞入仓库中
					LuaAutoMoveEquipToStorehouse(unique)
					break
				end
			end
		end
	end
	return bFlag
end

LuaDeleteEquip = function(nUnique)
	local bFlag = false
	if Save_PlayerData and type(nUnique) == "number" and nUnique > 0 then
		local bag = Save_PlayerData.bag
		if (type(bag) == "table") then
			for i = 1,hVar.EquipMaxNum do
				local oEquip = bag[i]
				if type(oEquip) == "table" then
					local unique = oEquip[hVar.ITEM_DATA_INDEX.UNIQUE]
					if nUnique == unique then
						bFlag = true
						Save_PlayerData.bag[i] = 0
						--获取临时内存中该uid所对应的位置  删除uid
						Save_PlayerData.bag.num = Save_PlayerData.bag.num - 1
						g_TempUidIndexInfo[unique] = nil
						break
					end
				end
			end
		end
	end
	return bFlag
end

--移动装备 只要两个uid不都是0  即可交换
LuaMoveEquip = function(tPos1,tPos2)
	--print("LuaMoveEquip")
	local uid1 = LuaFindEquipByPos(tPos1)
	local uid2 = LuaFindEquipByPos(tPos2)
	print(uid1,tPos1)
	print(uid2,tPos1)
	if uid1 == -1 or uid2 == -1 then
		return
	end
	if not(uid1 == 0 and uid2 == 0) then
		--print("cccccc")
		LuaRecordEquipPosInfo(uid2,tPos1)
		LuaRecordEquipPosInfo(uid1,tPos2)
	end
end

--读取战车引导点击按钮的次数
LuaGetTankClickGuideBtnCount = function()
	local rank = 0
	
	if Save_PlayerData then
		rank = Save_PlayerData.tank_guide_clickbtn_count or 0
	end
	
	return rank
end

---------------------------------------------------------------------------------------------------------------------------------------




--增加某个材料
LuaAddPlayerMaterial = function(matType,Val)
	if Save_PlayerData and Save_PlayerData.mat then
		local cur_m = LuaGetPlayerMaterial(matType)
		Save_PlayerData.mat[matType] = bit:d2b(cur_m+Val)
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--设置玩家的分解材料
LuaSetPlayerMaterial = function(matType,Val)
	if Save_PlayerData and Save_PlayerData.mat then
		Save_PlayerData.mat[matType] = bit:d2b(Val)
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--根据材料类型获得分解材料
LuaGetPlayerMaterial =  function(matType)
	if Save_PlayerData and Save_PlayerData.mat then
		local val = 0
		if type(Save_PlayerData.mat[matType]) == "number" then
			val = Save_PlayerData.mat[matType]
		elseif type(Save_PlayerData.mat[matType]) == "table" then
			val = bit:b2d(Save_PlayerData.mat[matType])
		end

		return val
	else
		return 0
	end
end

--设置玩家勋章
LuaSetPlayerMedal = function(MedalId,Val, notSaveFlag)
	if Save_PlayerData and Save_PlayerData.medal then
		Save_PlayerData.medal[MedalId] = Val
		
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
		--print("设置玩家勋章", MedalId, Val)
		--print(debug.traceback())
	end
end

--勋章的获取方法
LuaGetPlayerMedal = function(MedalId)
	if Save_PlayerData and Save_PlayerData.medal then
		return Save_PlayerData.medal[MedalId] or 0
	else
		return 0
	end
end

--设置本地玩家表
LuaSetPlayerList = function(index,playName,roleID)
	--必须有玩家表才可以进行设置
	if hApi.FileExists(g_localfilepath..hVar.SAVE_DATA_PATH.PLAYER_LIST,"full") then
		LuaLoadSavedGameData(g_localfilepath..hVar.SAVE_DATA_PATH.PLAYER_LIST)

		--设置名字
		if type(playName) == "string" and index >0 and index < 4 then
			Save_playerList[index].name = playName
		end
		
		--设置角色id
		if type(roleID) == "number" then
			Save_playerList[index].roleID = roleID
		end

		--排序
		for i = 1,#Save_playerList do
			if Save_playerList[i].name == "__TEXT_CreateNewPlayer" then
				for j = i+1,3 do
					if Save_playerList[j].name ~= "__TEXT_CreateNewPlayer" then
						local temp = Save_playerList[i]
						Save_playerList[i] = Save_playerList[j]
						Save_playerList[j] = temp
					end
				end
			end
		end
		
		--只有非转移设备时 才会重新打开
		if g_SyncDataTicketNum == 0 and g_SyncDataState == 0 then
			--hGlobal.event:event("LocalEvent_ShowPhone_PlayerListFram",Save_playerList,g_game_mode)
		end
	else
		--当没有玩家表文件时 创建空的玩家表
		Save_playerList = {}

		Save_playerList[1] = templet_playerList


		Save_playerList.userID = xlPlayer_GetUID()
		Save_playerList.LastSwitchPlayer = 1
		Save_playerList.SaveBackName = ""
		Save_playerList.SaveBackRid = 0
		Save_playerList.SaveBackTime = ""
		Save_playerList.SaveBackGameScore = 0
		Save_playerList.SaveBackLastFrmShow = 0
		--Save_playerList.dlc = {}
		--设置名字
		if type(playName) == "string" and index >0 and index < 4 then
			Save_playerList[index].name = playName
		end
		
		--设置角色id
		if type(roleID) == "number" then
			Save_playerList[index].roleID = roleID
		end

		--排序
		for i = 1,3 do
			if Save_playerList[i] and Save_playerList[i].name == "__TEXT_CreateNewPlayer" then
				for j = i+1,3 do
					if Save_playerList[j].name ~= "__TEXT_CreateNewPlayer" then
						local temp = Save_playerList[i]
						Save_playerList[i] = Save_playerList[j]
						Save_playerList[j] = temp
					end
				end
			end
		end

	end
	LuaSavePlayerList()
end

--保存玩家表
LuaSavePlayerList = function()
	if Save_playerList == nil then return end
	--local local_id = xlPlayer_GetUID()
	--local save_id = 0

	--if type(Save_playerList.userID) == "number" then
		--save_id = Save_playerList.userID
	--end

	Save_playerList.userID = xlPlayer_GetUID()
	----存档时 进行 uid 效验
	----xlLG("fufucckk","2-local_id = "..local_id.."-save_id = "..save_id.."\n")
	--if save_id ~= local_id and save_id ~= 0 and local_id ~= 0  then
		--xlAppAnalysis("cheat_savefile",0,1,"info-UID:",tostring(local_id).."-L_ID:-"..tostring(save_id).."-T:"..tostring(os.date("%m%d%H%M%S")))
			--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tUseOtherPlayerData"].."\n-["..save_id.."]-".."\n-["..local_id.."]-",{
			--font = hVar.FONTC,
			--ok = function()
				--xlExit()
			--end,
		--})
		--return
	--end

	--玩家表
	local saveEx = {
		"--"..(g_curPlayerName or 0).."\n",
		"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
		"Save_playerList",
	}
	local rTab = hApi.SaveTable(Save_playerList,saveEx,{getCount="n",LocalSaveInfo="kn",dlc = "n",guiderecode = "kn"})
	LuaSaveGameData(g_localfilepath..hVar.SAVE_DATA_PATH.PLAYER_LIST,rTab)

end

--保存玩家数据表
LuaSavePlayerData = function(filepath,PlayerName,save_tab,log_tab)
	--print("LuaSavePlayerData()", filepath)
	
	if PlayerName ~= "__TEXT_CreateNewPlayer" and PlayerName ~= nil then
		local local_id = xlPlayer_GetUID()
		--local save_id = 0
		
		--如果存档坏了不处理
		if (save_tab == nil) then
			return
		end
		
		--if type(save_tab.userID) == "number" then
			--save_id = save_tab.userID
		--end
		
		----xlLG("fufucckk","1-local_id = "..local_id.."-save_id = "..save_id.."\n")
		----存档时 进行 uid 效验
		--if save_id ~= local_id and save_id ~= 0 and local_id ~= 0  then
			--xlAppAnalysis("cheat_savefile",0,1,"info-UID:",tostring(local_id).."-S_ID:-"..tostring(save_id).."-T:"..tostring(os.date("%m%d%H%M%S")))
			--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tUseOtherPlayerData"].."\n-["..save_id.."]-".."\n-["..local_id.."]-",{
				--font = hVar.FONTC,
				--ok = function()
					--xlExit()
				--end,
			--})
			--return
		--end
		
		--保存玩家data 表
		local saveEx = {
			"--"..(PlayerName or 0).."\n",
			"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
			"--"..os.date("%X").."\n",
			"Save_PlayerData",
		}
		
		local rTab = hApi.SaveTable(save_tab,saveEx,{activebattlefieldskill = "kn",mapAchi="n", score= 0 ,mat = 0,medal = 0,equipment="kn",item="kn",bag= "kn",battlefieldskillbook = "kn",giftstate = 0,giftbag = "kn", dlc = "kn" ,assistant = "kn",getGiftCount = "kn"})
		LuaSaveGameData(filepath..PlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,rTab)
		
		--保存玩家log 表
		if log_tab then
			saveEx = {
				"--"..(PlayerName or 0).."\n",
				"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
				"--"..os.date("%X").."\n",
				"Save_PlayerLog",
			}
			
			rTab = hApi.SaveTable(log_tab,saveEx,{item_statistics = "kn",killcount = "kn",useitemcount = "kn",killcount = "kn",BehaviorList = "kn",ticketNum = "kn"})
			LuaSaveGameData(filepath..PlayerName..hVar.SAVE_DATA_PATH.PLAYER_LOG,rTab)
		end
		
	end
	
	--冒字显示io操作
	if (hVar.IS_CLIENT_NET_UI == 1) then --geyachao: 是否显示客户端网络状态界面（等待服务器、追帧）
		local strText = "保存玩家存档表"
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
	end
end


--安卓 保存玩家数据表
LuaSavePlayerData_Android_Upload = function(keyList, notice)
	local PlayerName = g_curPlayerName
	if (PlayerName ~= "__TEXT_CreateNewPlayer") and (PlayerName ~= nil) then
		if (type(keyList) == "table") then
			local num = #keyList
			if (num > 0) then
				local saveDataList = {}
				
				for i = 1, num, 1 do
					local key = keyList[i]
					local tResult = {}
					
					if (key == "card") then --英雄
						tResult = Save_PlayerData.herocard
					elseif (key == "skill") then --战术卡
						tResult = Save_PlayerData.battlefieldskillbook
					elseif (key == "bag") then --背包
						tResult = Save_PlayerData.bag
					elseif (key == "map") then --地图
						tResult = Save_PlayerData.mapAchi
					elseif (key == "material") then --杂项
						tResult = {}
						
						for k, v in pairs(Save_PlayerData) do
							if (k ~= "herocard") and (k ~= "battlefieldskillbook") and (k ~= "bag") and (k ~= "mapAchi") then
								tResult[k] = v
							end
						end
					elseif (key == "log") then --日志
						tResult = Save_PlayerLog
					end
					
					local strCfg = hApi.serialize_table(tResult)
					saveDataList[#saveDataList+1] = strCfg
				end
				
				--设置本地的存档号
				local uid = LuaGetPlayerDataUid()
				local oldsnapshotID = xlPlayer_GetSnapShotID(uid)
				local snapshotID = oldsnapshotID + 1
				xlPlayer_SetSnapShotID(uid, snapshotID)
				
				--安卓，上传存档接口
				--上传数据的总入口
				GluaSendNetCmd[hVar.ONLINECMD.CMD_SAVE_NEWDIC](keyList, saveDataList, snapshotID)
				
				--同时本地也存档
				--LuaSavePlayerData(filepath, PlayerName, save_tab, log_tab)
				
				--发送日志
				local block = ""
				for i = 1, #keyList, 1 do
					block = block .. keyList[i] .. ","
				end
				SendCmdFunc["android_savelog"](block, notice)
				
				--[[
				if (g_is_account_test == 2) then
					--冒字
					local strText = block .. " " .. notice
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2500 + 2500,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				end
				]]
				
				--管理员可查看日志
				hGlobal.event:event("localEvent_SaveDataChangeLog", {
					time = os.date("%Y-%m-%d %H:%M:%S", os.time()),
					content = "发起存档操作！ " .. notice .. ", snapshotID:" .. snapshotID .. ", data:" .. block,
					color = {255, 255, 255,},
				})
			end
		end
	end
end


--切换玩家
LuaSwitchPlayer = function(playerinfo)
	--对当前玩家进行赋值
	g_lastPlayerName = g_curPlayerName
	g_curPlayerName = playerinfo.name
	
	--if g_lastPlayerName == g_curPlayerName then return end
	--只有上一个用户和当前用户不同时 才会清理世界...
	if hGlobal.WORLD.LastWorldMap and g_lastPlayerName~= g_curPlayerName then
		hGlobal.WORLD.LastWorldMap:del()
		hGlobal.WORLD.LastWorldMap = nil
	end
	
	--显示用内存清理，日常任务
	if g_lastPlayerName~= g_curPlayerName then
		g_dailyQuestInfo = nil
	end
	
	--首先是log 文件
	if hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_LOG,"full") then
		LuaLoadSavedGameData(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)
	
	else
		--并不存在新的 log 文件 故创建
		Save_PlayerLog = {userID = xlPlayer_GetUID()}
		for k,v in pairs(templet_playerLog) do
			if Save_PlayerLog[k] == nil then
				if type(v) == "table" then
					Save_PlayerLog[k] = hApi.ReadParamWithDepth(v,nil,{},3)
				elseif type(v) == "number" or type(v) == "string" then
					Save_PlayerLog[k] = v
				end
			end
		end
	end
	
	if hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,"full") then
		--读取已经存在的英雄列表
		LuaLoadSavedGameData(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
		
		local userID = xlPlayer_GetUID()
		local playerCardUid = LuaGetPlayerDataUid()
		local playerDataID = luaGetplayerDataID()
		if userID ~= playerCardUid and userID ~= 0 and playerCardUid ~= 0 then
			xlAppAnalysis("cheat_playercard",0,1,"info",tostring(userID).."-"..tostring(playerCardUid).."-T:"..tostring(os.date("%m%d%H%M%S")))
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenOtherPlayerList"].."\n-["..playerCardUid.."]-".."\n-["..userID.."]-",{
				font = hVar.FONTC,
				ok = function()
					--geyachao: 大菠萝不检测重复id
					--xlExit()
				end,
			})
			return
		end
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		
		FormatPlayerData(g_localfilepath,g_curPlayerName,playerInfo,Save_PlayerData)
		
		LuaCheckPlayerChestLegal()
		LuaDeleteIllegalItem()
		LuaDeleteIllegalItemEx()
		LuaAddUseingRoldID(luaGetplayerDataID())
		hApi.CheckBFSCardIllegal(g_curPlayerName)
		
		
		SendCmdFunc["Login_RoldID"](playerDataID)
		
		if type(Save_PlayerData) == "table" and type(Save_PlayerData.herocard) == "table" then
			return Save_PlayerData.herocard
		else
			hApi.SeeYou()
			return
		end
	else
		--如果数据文件不存在 则返回一个空表 以及 日志表
		Save_PlayerData = {}
		for k,v in pairs(templet_playerdata) do
			if Save_PlayerData[k] == nil then
				if type(v) == "table" then
					Save_PlayerData[k] = hApi.ReadParamWithDepth(v,nil,{},3)
				elseif type(v) == "number" then
					Save_PlayerData[k] = v
				end
			end
		end
		Save_PlayerData.userID = xlPlayer_GetUID()
		--修改积分数据项 从 数字变成二进制 表
		SaveModifyFunc["herolist_score"](Save_PlayerData)
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		return Save_PlayerData.herocard
	end
end
------------------------------------zhenkira 英雄相关----------------------------------------------
--检测 unitID 是否在玩家数据表英雄卡片中存在 返回1 存在 返回0 不存在 返回2 数据表不存在
LuaCheckUnitIDInHeroCard = function(unitID)
	if Save_PlayerData and Save_PlayerData.herocard then
		for i=1,#Save_PlayerData.herocard do
			if unitID == Save_PlayerData.herocard[i].id then
				return 1
			end
		end
	else
		return 2
	end
	return 0
end
--获得英雄卡
LuaGetHeroCardInfoByUnitID = function(unitID)
	if Save_PlayerData and Save_PlayerData.herocard then
		for i=1,#Save_PlayerData.herocard do
			if unitID == Save_PlayerData.herocard[i].id then
				return Save_PlayerData.herocard[i]
			end
		end
	else
		return 2
	end
	return 0
end

--增加（减少）英雄卡的将魂 --zhenkira 2015.11.25
LuaAddHeroCardSoulStone = function(id, val)
	local tHeroCard = hApi.GetHeroCardById(id)
	if tHeroCard then
		tHeroCard.attr.soulstone = tHeroCard.attr.soulstone + (val or 0)
		if tHeroCard.attr.soulstone < 0 then
			tHeroCard.attr.soulstone = 0
			return true
		end
	end
	return false
end

--获取当前英雄卡的将魂 --zhenkira 2015.11.25
LuaGetHeroCardSoulStone = function(id)
	local ret = 0
	local tHeroCard = hApi.GetHeroCardById(id)
	if tHeroCard then
		ret = tHeroCard.attr.soulstone or 0
	end

	return ret
end

--同步存档中的星级和将魂
LuaSyncHeroStarAndSoulStone = function(tHero)
	if Save_PlayerData and Save_PlayerData.herocard then
		for i = 1,#Save_PlayerData.herocard do
			local tHeroCard = Save_PlayerData.herocard[i]
			if tHeroCard then
				local heroId = tHeroCard.id
				--如果有服务器数据，则无脑覆盖。否则英雄一定是1星
				if tHero[heroId] then
					tHeroCard.attr.star = tHero[heroId].star
					tHeroCard.attr.soulstone = tHero[heroId].soulstone
				else
					tHeroCard.attr.star = 1
					tHeroCard.attr.soulstone = 0
				end
				
				--检测英雄等级经验是否正常
				local star = tHeroCard.attr.star
				--print("heroId", heroId, "star", star, "hVar.HERO_STAR_INFO[heroId]", hVar.HERO_STAR_INFO[heroId])
				if hVar.HERO_STAR_INFO[heroId] then
					local starInfo = hVar.HERO_STAR_INFO[heroId][star]
					local expNow = LuaGetHeroExp(heroId)			--当前经验值
					local lvNow = hApi.GetLevelByExp(expNow)
					
					if lvNow > starInfo.maxLv then
						--如果不正常则检测覆盖
						expNow = hApi.GetLevelMinExp(starInfo.maxLv)
						tHeroCard.attr.exp = expNow
						tHeroCard.attr.level = hApi.GetLevelByExp(expNow)
					end
					
					--检测英雄天赋技能是否正常
					local unlockNum = hApi.GetUnlockTalentNum(tHeroCard.attr.level)
					local talent = tHeroCard.talent
					if talent then
						for idx = 1, #talent do
							--如果是已经解锁的技能，检测技能不能超过最大星级对应的等级
							if idx <= unlockNum then
								local skillObj = talent[idx]
								if skillObj then
									if skillObj.lv and skillObj.lv > starInfo.maxLv then
										skillObj.lv = starInfo.maxLv
									end
								end
							--如果出现未解锁的技能直接设置成，0级
							else
								local skillObj = talent[idx]
								if skillObj and skillObj.lv then
									skillObj.lv = 0
								end
							end
						end
					end
					local tactic = tHeroCard.tactic
					if tactic then
						for idx = 1, #tactic do
							local skillObj = tactic[idx]
							if skillObj then
								if skillObj.lv and skillObj.lv > starInfo.maxLv then
									skillObj.lv = starInfo.maxLv
								end
							end
						end
					end
				end
			end
		end
	end
end

--英雄升星（废弃）
--LuaHeroStarLevelUp = function(id)
--	local ret = false
--	local tHeroCard = hApi.GetHeroCardById(id)
--	--英雄卡不存在返回失败
--	if not tHeroCard then
--		return ret
--	end
--
--	local star = tHeroCard.attr.star
--	local soulstone = LuaGetHeroCardSoulStone(id)
--	
--	--星级已经大于当前设定的最大等级，返回失败
--	if star >= hVar.HERO_STAR_INFO.maxStarLv then
--		return ret
--	end
--
--	local starInfo = hVar.HERO_STAR_INFO[id][star]
--	local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
--	
--	--如果当前将魂小于需要消耗的将魂，返回失败
--	if soulstone < costSoulStone then
--		return ret
--	end
--
--	--扣除将魂
--	LuaAddHeroCardSoulStone(id, -costSoulStone)
--	--星级提高
--	tHeroCard.attr.star = tHeroCard.attr.star + 1
--	
--	local starNow = tHeroCard.attr.star
--	local talent = tHeroCard.talent
--	if not talent then
--		return ret
--	end
--
--	local skillObj = talent[starNow]
--	if skillObj and skillObj.id then
--		skillObj.lv = 1
--	else
--		local tabU = hVar.tab_unit[id]
--		--tab_unit非法
--		if not tabU then
--			return ret
--		end
--		local talentU = tabU.talent
--		--tab_unit没有talent
--		if not talentU then
--			return ret
--		end
--
--		local SkillObjU = talentU[starNow]
--		--tab_unit的talent没有对应星级的技能，或者对应星级技能id不合法
--		if not SkillObjU or not SkillObjU[1] or not hVar.tab_skill[SkillObjU[1]] then
--			--如果没填，则认为没有技能
--		else
--			talent[starNow] = {id = SkillObjU[1], lv = 1}
--		end
--	end
--
--	ret = true
--
--	return ret
--end

--英雄技能升级
LuaHeroSkillLevelUp = function(id, idx, skillId)
	local ret = 0
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		ret = -1
		return ret
	end
	
	local star = tHeroCard.attr.star
	local level = tHeroCard.attr.level
	local starInfo = hVar.HERO_STAR_INFO[id][star]
	local maxLv = starInfo.maxLv					--等级上限
	

	local talent = tHeroCard.talent
	if not talent then
		ret = -2
		return ret
	end
	for i = 1, #talent do
		local skillObj = talent[i]
		if i == idx and i <= star and skillObj and skillObj.id and skillObj.id == skillId then
			skillObj.lv = skillObj.lv or 0
			if skillObj.lv < maxLv and skillObj.lv < level then
				
				skillObj.lv = skillObj.lv + 1
				
				--统计技能升级次数
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
				
				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				
				ret = 1
				break
			elseif skillObj.lv >= maxLv then
				ret = -3
			elseif skillObj.lv >= level then
				ret = -4
			end
		end
	end

	return ret
end

--英雄战术技能升级
LuaHeroTacticLevelUp = function(id, idx, skillId)
	local ret = 0
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		ret = -1
		return ret
	end
	
	local star = tHeroCard.attr.star
	local level = tHeroCard.attr.level
	local starInfo = hVar.HERO_STAR_INFO[id][star]
	local maxLv = starInfo.maxLv					--等级上限
	

	local tactic = tHeroCard.tactic
	if not tactic then
		ret = -2
		return ret
	end

	for i = 1, #tactic do
		local skillObj = tactic[i]
		if i == idx and skillObj and skillObj.id and skillObj.id == skillId then
			skillObj.lv = skillObj.lv or 0
			if skillObj.lv < maxLv and skillObj.lv < level then
				
				skillObj.lv = skillObj.lv + 1

				--统计技能升级次数
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
				
				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				
				ret = 1
				break
			elseif skillObj.lv >= maxLv then
				ret = -3
			elseif skillObj.lv >= level then
				ret = -4
			end
		end
	end

	return ret
end

--英雄当前经验值
LuaGetHeroExp = function(id)
	local exp = 0
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return exp
	end
	
	exp = tHeroCard.attr.exp or 0
	
	return exp
end

--获取英雄当前星级
LuaGetHeroStar = function(id)
	local star = 1
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return star
	end
	
	star = tHeroCard.attr.star or 1
	return star
end

--获取英雄当前皮肤
LuaGetHeroAvaterIdx = function(id)
	local avaterIdx = 1
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return 1
	end
	
	avaterIdx = tHeroCard.attr.avaterIdx or 1
	return avaterIdx
end

--设置英雄当前皮肤
LuaSetHeroAvaterIdx = function(id, avaterIdx)
	local tHeroCard = hApi.GetHeroCardById(id)
	if tHeroCard then
		tHeroCard.attr.avaterIdx  = avaterIdx
	else
		local notSaveFlag = true
		LuaAddNewHeroCard(id, 1, 1, notSaveFlag)
		tHeroCard = hApi.GetHeroCardById(id)
		tHeroCard.attr.avaterIdx  = avaterIdx
	end
	
	--存档
	--设置英雄当前皮肤
	local keyList = {"card",}
	LuaSavePlayerData_Android_Upload(keyList, "设置英雄当前皮肤")
	
	return avaterIdx
end

--获取英雄当前等级
LuaGetHeroLevel = function(id)
	local lv = 1
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return lv
	end
	
	local exp = tHeroCard.attr.exp
	lv = hApi.GetLevelByExp(exp)
	return lv
end

--英雄增加经验(自动升级流程)
LuaAddHeroExp = function(id, exp)
	--print(debug.traceback())
	local ret = false
	
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return ret
	end
	
	local expNow = LuaGetHeroExp(id)			--当前经验值
	local lvNow = LuaGetHeroLevel(id)			--当前等级
	local star = LuaGetHeroStar(id)				--当前星级
	local maxStar = hVar.HERO_STAR_INFO.maxStarLv		--版本最大星级
	
	
	--人物可升级到当前星级所限定的最大等级。（如果未达到版本最大等级，升级经验可以超出，但不能升至下一级）
	local maxLvByStar = hVar.HERO_STAR_INFO[id][star].maxLv
	local maxLv = hVar.HERO_STAR_INFO[id][maxStar].maxLv
	
	--初步计算增加经验可提升的等级
	local tmpExp = expNow + exp
	local tmpLv = hApi.GetLevelByExp(tmpExp)
	--print("expNow=", expNow,"exp=", exp)
	--print("tmpExp=", tmpExp,"tmpLv=", tmpLv)
	--print("maxLvByStar=", maxLvByStar,"maxLv=", maxLv)
	--print("lvNow=", lvNow)
	--if tmpLv <= maxLvByStar then
	--	--如果小于等于星级所对应的最大等级，则直接修改经验及等级
	--	tHeroCard.attr.exp = tmpExp
	--	tHeroCard.attr.level = tmpLv
	--elseif tmpLv > maxLvByStar and tmpLv < maxLv then
	--	--如果大于星级所对应的最大等级，但小于版本等级，等级为为星级对应最大等级，经验设置为下一等级-1
	--	local expInfo = hVar.HERO_EXP[maxLvByStar]
	--	tHeroCard.attr.exp = expInfo.minExp + expInfo.nextExp - 1
	--	tHeroCard.attr.level = maxLvByStar
	--elseif tmpLv >= maxLv then
	--	--如果大于版本等级，等级为版本等级，经验值为版本等级所对应的最小经验值
	--	local expInfo = hVar.HERO_EXP[maxLv]
	--	tHeroCard.attr.exp = expInfo.minExp
	--	tHeroCard.attr.level = maxLv
	--end
	
	if tmpLv <= maxLvByStar then
		--如果小于等于星级所对应的最大等级，则直接修改经验及等级
		tHeroCard.attr.exp = tmpExp
		tHeroCard.attr.level = tmpLv
	elseif tmpLv > maxLvByStar then
		--如果大于星级所对应的最大等级，但小于版本等级，等级为为星级对应最大等级，经验设置为下一等级-1
		local expInfo = hVar.HERO_EXP[maxLvByStar]
		tHeroCard.attr.exp = expInfo.minExp + expInfo.nextExp - 1
		tHeroCard.attr.level = maxLvByStar
	end
	
	--如果升级了(lvNow升钱等级,tHeroCard.attr.level升后等级)
	if lvNow < tHeroCard.attr.level then
		hGlobal.event:event("LocalEvent_TankLvUp")
		local unlockNum = hApi.GetUnlockTalentNum(tHeroCard.attr.level)
		
		local talent = tHeroCard.talent
		if not talent then
			return ret
		end
		
		local tabU = hVar.tab_unit[id]
		--tab_unit非法
		if not tabU then
			return ret
		end
		local talentU = tabU.talent
		--tab_unit没有talent
		if not talentU then
			return ret
		end
		
		for idx = 1, unlockNum do
			local SkillObjU = talentU[idx]
			--tab_unit的talent没有对应星级的技能，或者对应星级技能id不合法
			if not SkillObjU or not SkillObjU[1] or not hVar.tab_skill[SkillObjU[1]] then
				--如果没填，则认为没有技能
				talent[idx] = {}
			else
				if not talent[idx] then
					talent[idx] = {}
				end
				talent[idx].id = SkillObjU[1]
				if not talent[idx].lv or talent[idx].lv == 0 then
					talent[idx].lv = 1
				end
			end
		end
	end
	
	--大菠萝，升级等级会获得天赋点
	tHeroCard.talent_point = (tHeroCard.talent_point or 0) + (tHeroCard.attr.level - lvNow)
	
	ret = true
	
	return ret
	
end

--添加一张英雄卡片
LuaAddNewHeroCard = function(nHeroId, nStar, nLv, dontSave)
	if Save_PlayerData and type(Save_PlayerData.herocard)=="table" then
		
		local flag = LuaCheckUnitIDInHeroCard(nHeroId)
		--如果卡不存在，则产生新卡
		if flag==0 then
			local tItem = hApi.NumTable(hVar.HERO_BAG_SIZE)
			local tEquip = hApi.NumTable(hVar.HERO_EQUIP_SIZE)
			local tTalentTree = hApi.NumTable(hVar.HERO_TALENT_TREE_SIZE) --大菠萝天赋树
			local tWeaponUnit = hApi.NumTable(hVar.HERO_WEAPON_UNIT_SIZE) --大菠萝武器列表
			local tPetUnit = hApi.NumTable(hVar.HERO_PET_UNIT_SIZE) --大菠萝宠物列表
			local talent = {}
			local tactics = {}
			
			local hLv = nLv or 1
			local hExp = hApi.GetLevelMinExp(hLv) or 0
			
			--初始化英雄卡的天赋技能和战术技能
			if hVar.tab_unit[nHeroId] then
				if hVar.tab_unit[nHeroId].talent then
					local tabTalent = hVar.tab_unit[nHeroId].talent
					for idx = 1, hVar.HERO_TALENT_SIZE do
						local skillId = 0
						local skillLv = 0
						if tabTalent[idx] then
							skillId = tabTalent[idx][1] or 0
						end
						----目前逻辑写死，每颗星级开放一个技能
						--if skillId > 0 and idx <= nStar then
						--	skillLv = 1
						--end
						--目前逻辑写死，固定等级开放技能
						local unlockNum = hApi.GetUnlockTalentNum(hLv)
						if skillId > 0 and idx <= unlockNum then
							skillLv = 1
						end
						talent[idx] = {id = skillId, lv = skillLv}
					end
				end
				
				if hVar.tab_unit[nHeroId].tactics then
					local tabTactic = hVar.tab_unit[nHeroId].tactics
					for idx = 1, hVar.HERO_TACTIC_SIZE do
						local tacticId = 0
						local tacticLv = 0
						if tabTactic[idx] then
							tacticId = tabTactic[idx] or 0
						end
						--目前逻辑写死，每颗星级开放一个技能
						if tacticId > 0 then
							tacticLv = 1
						end
						tactics[idx] = {id = tacticId, lv = tacticLv}
					end
				end
			end
			
			local tHeroCard = {
				id = nHeroId,
				attr = {level=hLv,exp=hExp,star = nStar or 1, soulstone = 0,},
				item = tItem,
				equipment = tEquip,
				--ex_AttrPoint = 0,		--精简存档 去除不必要的数据项
				--ex_Attr = {},
				talent = talent,
				tactic = tactics,
				talent_tree = tTalentTree, --大菠萝天赋树
				talent_point = 0, --大菠萝天赋点数
				weapon_unit = tWeaponUnit, --大菠萝武器列表
				weapon_index = 1, --大菠萝选择的武器索引值
				pet_unit = tPetUnit, --大菠萝宠物列表
				pet_index = 0, --大菠萝选择的宠物列索引值
				pet_index2 = 0, --大菠萝选择的宠物列索引值2
				pet_index3 = 0, --大菠萝选择的宠物列索引值3
				pet_index4 = 0, --大菠萝选择的宠物列索引值4
			}
			Save_PlayerData.herocard[#Save_PlayerData.herocard+1] = tHeroCard
			
			--统计获得一个新英雄
			LuaAddPlayerCountVal(hVar.MEDAL_TYPE.heroN)
			LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.heroN)
			
			if dontSave then
				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
			
			return 1
		elseif flag == 1 then --zhenkira 2015.11.25
			--zhenkira 2017.1.18不再有英雄转化成将魂这个流程
			----如果卡已经存在，转化成将魂
			--local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv
			--local star = nStar or 1
			--if nStar <= maxStarLv then
			--	local val = 0
			--	if hVar.HERO_STAR_INFO[nHeroId][star] then
			--		val = hVar.HERO_STAR_INFO[nHeroId][star].toSoulStone or 0
			--	end
			--	
			--	LuaAddHeroCardSoulStone(nHeroId, val)
			--end
			return 0
		end
	end
	return 0
end

--大菠萝
--获得天赋点数
LuaGetHeroTalentPoint = function(nHeroId)
	local tp = 0
	
	--传入默认战车的id，改为读取当前选中的战车id
	if (nHeroId == hVar.MY_TANK_ID) then
		local tankIdx = Save_PlayerData.tankIdx or 1
		nHeroId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	end
	
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		tp = tHeroCard.talent_point or 0
	end
	
	return tp
end

--大菠萝
--设置天赋点数
LuaSetHeroTalentPoint = function(nHeroId, tp, notSaveFlag)
	
	--传入默认战车的id，改为读取当前选中的战车id
	if (nHeroId == hVar.MY_TANK_ID) then
		local tankIdx = Save_PlayerData.tankIdx or 1
		nHeroId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	end
	
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.talent_point = tp
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--大菠萝获取天赋技能等级
LuaGetHeroTalentSkillLv = function(nHeroId, talentId)
	
	--传入默认战车的id，改为读取当前选中的战车id
	if (nHeroId == hVar.MY_TANK_ID) then
		local tankIdx = Save_PlayerData.tankIdx or 1
		nHeroId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	end
	
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local talent_tree = tHeroCard.talent_tree
		if talent_tree then
			lv = talent_tree[talentId] or 0
		end
	end
	
	return lv
end

--大菠萝设置天赋技能等级
LuaSetHeroTalentSkillLv = function(nHeroId, talentId, lv, notSaveFlag)
	
	--传入默认战车的id，改为读取当前选中的战车id
	if (nHeroId == hVar.MY_TANK_ID) then
		local tankIdx = Save_PlayerData.tankIdx or 1
		nHeroId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	end
	
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local talent_tree = tHeroCard.talent_tree
		if talent_tree then
			talent_tree[talentId] = lv
		else
			tHeroCard.talent_tree = {[talentId] = lv,}
		end
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
	
	return lv
end

--大菠萝清除天赋技能数据
LuaClearTalent = function(nHeroId, notSaveFlag)
	
	--传入默认战车的id，改为读取当前选中的战车id
	if (nHeroId == hVar.MY_TANK_ID) then
		local tankIdx = Save_PlayerData.tankIdx or 1
		nHeroId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	end
	
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.talent_tree = nil
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--[[
--大菠萝获取指定天赋id的索引值
LuaGetHeroTalentIndexById = function(nHeroId, talentId)
	local talentIdx = 0
	
	local tabU = hVar.tab_unit[nHeroId]
	if tabU then
		local tabTTree = tabU.talent_tree
		if tabTTree then
			for i = 1, #tabTTree, 1 do
				local tid = tabTTree[i]
				if (tid == talentId) then --找到了
					talentIdx = i
					break
				end
			end
		end
	end
	
	return talentIdx
end
]]

--大菠萝
--获得战车在使用的索引值
LuaGetHeroTankIdx = function()
	local idx = 1
	if Save_PlayerData then
		idx = Save_PlayerData.tankIdx or 1
	end
	
	return idx
end

--大菠萝
--设置战车在使用的索引值
LuaSetHeroTankIdx = function(idx, notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.tankIdx = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--存档
			--设置战车在使用的索引值
			local keyList = {"material",}
			LuaSavePlayerData_Android_Upload(keyList, "设置战车在使用的索引值")
		end
	end
end

---------------------------------------------------------------------------
--大菠萝
--获得武器索引值
LuaGetHeroWeaponIdx = function(nHeroId)
	local idx = 1
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		idx = tHeroCard.weapon_index or 1
	end
	
	return idx
end

--大菠萝
--设置武器索引值
LuaSetHeroWeaponIdx = function(nHeroId, idx, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.weapon_index = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--大菠萝获取武器等级
LuaGetHeroWeaponLv = function(nHeroId, weaponIdx)
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local weapon_unit = tHeroCard.weapon_unit
		if (type(weapon_unit) == "table") then
			if (type(weapon_unit[weaponIdx]) == "table") then
				lv = weapon_unit[weaponIdx][2] or 0
			end
		end
	end
	
	--读取武器是否初始已解锁
	if (lv <= 0) then
		local tabU = hVar.tab_unit[nHeroId]
		if tabU then
			local tabUW = tabU.weapon_unit
			if tabUW then
				local tabUWI = tabUW[weaponIdx]
				if tabUWI then
					local unlock = tabUWI.unlock
					if (unlock == true) then
						lv = 1
					end
				end
			end
		end
	end
	
	return lv
end

--大菠萝获取武器碎片数量
LuaGetHeroWeaponDebrisNum = function(nHeroId, weaponIdx)
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local weapon_unit = tHeroCard.weapon_unit
		if (type(weapon_unit) == "table") then
			if (type(weapon_unit[weaponIdx]) == "table") then
				lv = weapon_unit[weaponIdx][3] or 0
			end
		end
	end
	
	return lv
end

--大菠萝获取武器经验值
LuaGetHeroWeaponExp = function(nHeroId, weaponIdx)
	local exp = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local weapon_unit = tHeroCard.weapon_unit
		if (type(weapon_unit) == "table") then
			if (type(weapon_unit[weaponIdx]) == "table") then
				exp = weapon_unit[weaponIdx][4] or 0
			end
		end
	end
	
	return exp
end

--大菠萝设置武器等级
LuaSetHeroWeaponLv = function(nHeroId, weaponIdx, lv, notSaveFlag)
	if (weaponIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		if tHeroCard then
			local weapon_unit = tHeroCard.weapon_unit
			if (type(weapon_unit) ~= "table") then
				weapon_unit = {}
				tHeroCard.weapon_unit = weapon_unit
			end
			
			if (type(weapon_unit[weaponIdx]) == "table") then
				weapon_unit[weaponIdx][2] = lv --替换
			else
				--读取武器id
				local weaponId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.weapon_unit
					if tabUW then
						weaponId = tabUW[weaponIdx] and tabUW[weaponIdx].unitId or 0
					end
				end
				weapon_unit[weaponIdx] = {weaponId,lv,0,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置武器碎片数量（叠加）
LuaAddHeroWeaponDebrisNum = function(nHeroId, weaponIdx, debrisNum, notSaveFlag)
	if (weaponIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		if tHeroCard then
			local weapon_unit = tHeroCard.weapon_unit
			if (type(weapon_unit) ~= "table") then
				weapon_unit = {}
				tHeroCard.weapon_unit = weapon_unit
			end
			
			if (type(weapon_unit[weaponIdx]) == "table") then
				weapon_unit[weaponIdx][3] = (weapon_unit[weaponIdx][3] or 0) + debrisNum --叠加
			else
				--读取武器id
				local weaponId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.weapon_unit
					if tabUW then
						weaponId = tabUW[weaponIdx] and tabUW[weaponIdx].unitId or 0
					end
				end
				
				--读取武器是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.weapon_unit
					if tabUW then
						local tabUWI = tabUW[weaponIdx]
						if tabUWI then
							local unlock = tabUWI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				weapon_unit[weaponIdx] = {weaponId,lv,debrisNum,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置武器经验值
LuaSetHeroWeaponExp = function(nHeroId, weaponIdx, exp, notSaveFlag)
	if (weaponIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		if tHeroCard then
			local weapon_unit = tHeroCard.weapon_unit
			if (type(weapon_unit) ~= "table") then
				weapon_unit = {}
				tHeroCard.weapon_unit = weapon_unit
			end
			
			--print(weapon_unit, weaponIdx, weapon_unit[weaponIdx])
			if (type(weapon_unit[weaponIdx]) == "table") then
				weapon_unit[weaponIdx][4] = exp --替换
			else
				--读取武器id
				local weaponId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.weapon_unit
					if tabUW then
						weaponId = tabUW[weaponIdx] and tabUW[weaponIdx].unitId or 0
					end
				end
				
				--读取武器是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.weapon_unit
					if tabUW then
						local tabUWI = tabUW[weaponIdx]
						if tabUWI then
							local unlock = tabUWI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				weapon_unit[weaponIdx] = {weaponId,lv,0,exp,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝清除武器数据
LuaClearWeapon = function(nHeroId, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.weapon_unit = nil
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--大菠萝获得指定武器id的索引值
LuaGetHeroWeaponIndexById = function(nHeroId, weaponId)
	local weaponIdx = 0
	
	local tabU = hVar.tab_unit[nHeroId]
	if tabU then
		local tabUW = tabU.weapon_unit
		if tabUW then
			for i = 1, #tabUW, 1 do
				local tabUWI = tabUW[i]
				if (tabUWI.unitId == weaponId) then --找到了
					weaponIdx = i
					break
				end
			end
		end
	end
	
	return weaponIdx
end



---------------------------------------------------------------------------
--大菠萝
--获得携带的宠物索引
LuaGetHeroPetIdx = function(nHeroId)
	local idx = 1
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		idx = tHeroCard.pet_index or 0
	end
	
	return idx
end

--大菠萝
--设置携带的宠物索引
LuaSetHeroPetIdx = function(nHeroId, idx, notSaveFlag)
	print("LuaSetHeroPetIdx", nHeroId, idx, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.pet_index = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--获得携带的宠物索引2
LuaGetHeroPetIdx2 = function(nHeroId)
	local idx = 1
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		idx = tHeroCard.pet_index2 or 0
	end
	
	return idx
end

--大菠萝
--设置携带的宠物索引2
LuaSetHeroPetIdx2 = function(nHeroId, idx, notSaveFlag)
	print("LuaSetHeroPetIdx2", nHeroId, idx, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.pet_index2 = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--获得携带的宠物索引3
LuaGetHeroPetIdx3 = function(nHeroId)
	local idx = 1
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		idx = tHeroCard.pet_index3 or 0
	end
	
	return idx
end

--大菠萝
--设置携带的宠物索引3
LuaSetHeroPetIdx3 = function(nHeroId, idx, notSaveFlag)
	print("LuaSetHeroPetIdx3", nHeroId, idx, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.pet_index3 = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--获得携带的宠物索引4
LuaGetHeroPetIdx4 = function(nHeroId)
	local idx = 1
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		idx = tHeroCard.pet_index4 or 0
	end
	
	return idx
end

--大菠萝
--设置携带的宠物索引4
LuaSetHeroPetIdx4 = function(nHeroId, idx, notSaveFlag)
	print("LuaSetHeroPetIdx4", nHeroId, idx, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.pet_index4 = idx
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--大菠萝获得某个索引宠物等级（0级是未解锁）
LuaGetHeroPetLv = function(nHeroId, petIdx)
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local pet_unit = tHeroCard.pet_unit
		if (type(pet_unit) == "table") then
			if (type(pet_unit[petIdx]) == "table") then
				lv = pet_unit[petIdx][2] or 0
			end
		end
	end
	
	--读取宠物是否初始已解锁
	if (lv <= 0) then
		local tabU = hVar.tab_unit[nHeroId]
		if tabU then
			local tabUP = tabU.pet_unit
			if tabUP then
				local tabUPI = tabUP[petIdx]
				if tabUPI then
					local unlock = tabUPI.unlock
					if (unlock == true) then
						lv = 1
					end
				end
			end
		end
	end
	
	return lv
end

LuaDeductCost = function(costlist)
	if type(costlist) == "table" then
		for i = 1,#costlist do
			local stype = costlist[i][1]
			local nvalue = costlist[i][2]
			if stype == "score" then
				LuaAddPlayerScore(-nvalue)
			elseif stype == "weapondebir" then
				local nHeroId = costlist[i][4]
				local weaponIdx = costlist[i][5]
				LuaAddHeroWeaponDebrisNum(nHeroId, weaponIdx, -nvalue)
			elseif stype == "petdebir" then
				local nHeroId = costlist[i][4]
				local petIdx = costlist[i][5]
				LuaAddHeroPetDebrisNum(nHeroId, petIdx, -nvalue)
			end
		end
	end
end

--大菠萝获取宠物碎片数量
LuaGetHeroPetDebrisNum = function(nHeroId, petIdx)
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local pet_unit = tHeroCard.pet_unit
		if (type(pet_unit) == "table") then
			if (type(pet_unit[petIdx]) == "table") then
				lv = pet_unit[petIdx][3] or 0
			end
		end
	end
	
	return lv
end

--大菠萝获取宠物经验值
LuaGetHeroPetExp = function(nHeroId, petIdx)
	local lv = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local pet_unit = tHeroCard.pet_unit
		if (type(pet_unit) == "table") then
			if (type(pet_unit[petIdx]) == "table") then
				lv = pet_unit[petIdx][4] or 0
			end
		end
	end
	
	return lv
end

--大菠萝获取宠物是否挖矿
LuaGetHeroPetInWaKuang = function(nHeroId, petIdx)
	local wakaung = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local pet_unit = tHeroCard.pet_unit
		if (type(pet_unit) == "table") then
			if (type(pet_unit[petIdx]) == "table") then
				wakaung = pet_unit[petIdx][5] or 0
			end
		end
	end
	
	return wakaung
end

--大菠萝获取宠物是否挖体力
LuaGetHeroPetInWaTiLi = function(nHeroId, petIdx)
	local watili = 0
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	
	if tHeroCard then
		local pet_unit = tHeroCard.pet_unit
		if (type(pet_unit) == "table") then
			if (type(pet_unit[petIdx]) == "table") then
				watili = pet_unit[petIdx][6] or 0
			end
		end
	end
	
	return watili
end

--大菠萝设置宠物等级
LuaSetHeroPetLv = function(nHeroId, petIdx, lv, notSaveFlag)
	if (petIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		--print("tHeroCard=", tHeroCard, "nHeroId, petIdx, lv, notSaveFlag=", nHeroId, petIdx, lv, notSaveFlag)
		if tHeroCard then
			local pet_unit = tHeroCard.pet_unit
			if (type(pet_unit) ~= "table") then
				pet_unit = {}
				tHeroCard.pet_unit = pet_unit
			end
			--print("pet_unit[petIdx]=", pet_unit[petIdx])
			if (type(pet_unit[petIdx]) == "table") then
				pet_unit[petIdx][2] = lv --替换
				--print("替换", petIdx, lv)
			else
				--读取宠物id
				local petId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.pet_unit
					if tabUW then
						petId = tabUW[petIdx] and tabUW[petIdx].unitId or 0
					end
				end
				
				--[[
				--读取宠物是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUP = tabU.pet_unit
					if tabUP then
						local tabUPI = tabUP[petIdx]
						if tabUPI then
							local unlock = tabUPI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				]]
				
				pet_unit[petIdx] = {petId,lv,0,0,0,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置宠物碎片数量（叠加）
LuaAddHeroPetDebrisNum = function(nHeroId, petIdx, debrisNum, notSaveFlag)
	if (petIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		
		if tHeroCard then
			local pet_unit = tHeroCard.pet_unit
			if (type(pet_unit) ~= "table") then
				pet_unit = {}
				tHeroCard.pet_unit = pet_unit
			end
			
			if (type(pet_unit[petIdx]) == "table") then
				pet_unit[petIdx][3] = (pet_unit[petIdx][3] or 0) + debrisNum --叠加
			else
				--读取宠物id
				local petId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.pet_unit
					if tabUW then
						petId = tabUW[petIdx] and tabUW[petIdx].unitId or 0
					end
				end
				
				--读取宠物是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUP = tabU.pet_unit
					if tabUP then
						local tabUPI = tabUP[petIdx]
						if tabUPI then
							local unlock = tabUPI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				pet_unit[petIdx] = {petId,lv,debrisNum,0,0,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置宠物经验值
LuaSetHeroPetExp = function(nHeroId, petIdx, exp, notSaveFlag)
	if (petIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		
		if tHeroCard then
			local pet_unit = tHeroCard.pet_unit
			if (type(pet_unit) ~= "table") then
				pet_unit = {}
				tHeroCard.pet_unit = pet_unit
			end
			
			if (type(pet_unit[petIdx]) == "table") then
				pet_unit[petIdx][4] = exp --覆盖
			else
				--读取宠物id
				local petId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.pet_unit
					if tabUW then
						petId = tabUW[petIdx] and tabUW[petIdx].unitId or 0
					end
				end
				
				--读取宠物是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUP = tabU.pet_unit
					if tabUP then
						local tabUPI = tabUP[petIdx]
						if tabUPI then
							local unlock = tabUPI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				pet_unit[petIdx] = {petId,lv,0,exp,0,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置宠物是否挖矿
LuaSetHeroPetInWaKuang = function(nHeroId, petIdx, wakuang, notSaveFlag)
	if (petIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		
		if tHeroCard then
			local pet_unit = tHeroCard.pet_unit
			if (type(pet_unit) ~= "table") then
				pet_unit = {}
				tHeroCard.pet_unit = pet_unit
			end
			
			if (type(pet_unit[petIdx]) == "table") then
				pet_unit[petIdx][5] = wakuang --覆盖
				--print("大菠萝设置宠物是否挖矿", wakuang)
			else
				--读取宠物id
				local petId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.pet_unit
					if tabUW then
						petId = tabUW[petIdx] and tabUW[petIdx].unitId or 0
					end
				end
				
				--读取宠物是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUP = tabU.pet_unit
					if tabUP then
						local tabUPI = tabUP[petIdx]
						if tabUPI then
							local unlock = tabUPI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				pet_unit[petIdx] = {petId,lv,0,0,wakuang,0,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝设置宠物是否挖体力
LuaSetHeroPetInWaTiLi = function(nHeroId, petIdx, watili, notSaveFlag)
	if (petIdx > 0) then
		local tHeroCard = hApi.GetHeroCardById(nHeroId)
		
		if tHeroCard then
			local pet_unit = tHeroCard.pet_unit
			if (type(pet_unit) ~= "table") then
				pet_unit = {}
				tHeroCard.pet_unit = pet_unit
			end
			
			if (type(pet_unit[petIdx]) == "table") then
				pet_unit[petIdx][6] = watili --覆盖
			else
				--读取宠物id
				local petId = 0
				local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUW = tabU.pet_unit
					if tabUW then
						petId = tabUW[petIdx] and tabUW[petIdx].unitId or 0
					end
				end
				
				--读取宠物是否初始已解锁
				local lv = 0
				--local tabU = hVar.tab_unit[nHeroId]
				if tabU then
					local tabUP = tabU.pet_unit
					if tabUP then
						local tabUPI = tabUP[petIdx]
						if tabUPI then
							local unlock = tabUPI.unlock
							if (unlock == true) then
								lv = 1
							end
						end
					end
				end
				
				pet_unit[petIdx] = {petId,lv,0,0,0,watili,}
			end
			
			--存档
			if (not notSaveFlag) then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		end
	end
end

--大菠萝清除宠物数据
LuaClearPet = function(nHeroId, notSaveFlag)
	local tHeroCard = hApi.GetHeroCardById(nHeroId)
	if tHeroCard then
		tHeroCard.pet_unit = nil
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--大菠萝通过宠物id 获取宠物对应的序号
LuaGetHeroPetIndexById = function(nHeroId, petId)
	local petIndex = 0
	
	local tabU = hVar.tab_unit[nHeroId]
	if (type(tabU) == "table") then
		local tabUP = tabU.pet_unit
		if (type(tabUP) == "table") then
			for i = 1, #tabUP, 1 do
				local tabUPI = tabUP[i]
				if (type(tabUPI) == "table") then
					if (tabUPI.unitId == petId) then --找到了
						petIndex = i
						break
					end
				end
			end
		end
	end
	
	return petIndex
end

LuaGetHeroPetId = function(nHeroId)
	local nPetId = 0
	local tabU = hVar.tab_unit[nHeroId]
	if type(tabU) == "table" and type(tabU.pet_unit) == "table" then
		local nPetIdx = LuaGetHeroPetIdx(nHeroId)
		if type(tabU.pet_unit[nPetIdx]) == "table" then 
			nPetId = tabU.pet_unit[nPetIdx].unitId or 0
		end
	end
	return nPetId
end


------------------------------------------------------------------------------------------------------------
--检测宠物是否可以 升级/升星
LuaCheckHeroPetCanUpgrade = function(nHeroId, petIdx, showfloat)
	local bFlag = false
	local tabU = hVar.tab_unit[nHeroId]
	local costlist = {}
	local sTag = "" --tag
	local showf = showfloat or 0
	if tabU then
		local tabUW = tabU.pet_unit
		if tabUW then
			local star = LuaGetHeroPetLv(nHeroId, petIdx) --当前星级
			local level = LuaGetHeroPetExp(nHeroId, petIdx) --当前等级
			
			--等级未到顶级
			if (level < hVar.PET_LVUP_INFO_NEW.maxPetLv) then
				--优先读取升级表
				local tLevelUpInfo = hVar.PET_LVUP_INFO_NEW[level]
				local reqiureStar = tLevelUpInfo.reqiureStar --需要的星级
				
				if (star >= reqiureStar) then --星级足够，进行升级操作
					--tag
					sTag = "levelup"
					
					local shopItemId = tLevelUpInfo.shopItemId or 0
					local requireDebris = tLevelUpInfo.costDebris or 100
					local tShopItem = hVar.tab_shopitem[shopItemId] or {}
					local requireScore = tShopItem.score or 0 --升级需要的积分
					local requireRmb = tShopItem.rmb or 0 --升级需要的游戏币
					
					local enough = true
					
					if (requireScore > 0) then
						local nowScore = LuaGetPlayerScore() --当前的积分
						local font = "num"
						if nowScore < requireScore then
							font = "numRed"
							enough = false
							if showf == 1 then
								hApi.NotEnoughResource("coin")
								showf = 0
							end
						end
						costlist[#costlist + 1] = {"score",requireScore,font}
					end
					
					local nowRmb = LuaGetPlayerRmb() --当前的游戏币
					local font = "num"
					if nowRmb < requireRmb then
						font = "numRed"
						enough = false
						if showf == 1 then
							hApi.NotEnoughResource("keshi")
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"rmb",requireRmb,font}
					
					local debrisNum = LuaGetHeroPetDebrisNum(nHeroId,petIdx)
					local font = "numWhite"
					if debrisNum < requireDebris then
						font = "numRed"
						enough = false
						if showf == 1 then
							local strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 2000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"petdebir",requireDebris,font,nHeroId, petIdx}
					
					if enough == true then
						bFlag = true
					end
				else --星级不够，进行升星操作
					--tag
					sTag = "starup"
					
					local tStarUpInfo = hVar.PET_STAR_INFO_NEW[star]
					local shopItemId = tStarUpInfo.shopItemId or 0
					local requireDebris = tStarUpInfo.costDebris or 100
					local tShopItem = hVar.tab_shopitem[shopItemId] or {}
					local requireScore = tShopItem.score or 0 --升星需要的积分
					local requireRmb = tShopItem.rmb or 0 --升星需要的游戏币
					
					local enough = true
					
					if (requireScore > 0) then
						local nowScore = LuaGetPlayerScore() --当前的积分
						local font = "num"
						if nowScore < requireScore then
							font = "numRed"
							enough = false
							if showf == 1 then
								hApi.NotEnoughResource("coin")
								showf = 0
							end
						end
						costlist[#costlist + 1] = {"score",requireScore,font}
					end
					
					local nowRmb = LuaGetPlayerRmb() --当前的游戏币
					local font = "num"
					if nowRmb < requireRmb then
						font = "numRed"
						enough = false
						if showf == 1 then
							hApi.NotEnoughResource("keshi")
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"rmb",requireRmb,font}
					
					local debrisNum = LuaGetHeroPetDebrisNum(nHeroId,petIdx)
					local font = "numWhite"
					if debrisNum < requireDebris then
						font = "numRed"
						enough = false
						if showf == 1 then
							local strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 2000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"petdebir",requireDebris,font,nHeroId, petIdx}
					
					if enough == true then
						bFlag = true
					end
				end
			else --等级已满
				--只展示当前碎片数量
				--local debrisNum = LuaGetHeroPetDebrisNum(nHeroId,petIdx)
				local font = "numWhite"
				costlist[#costlist + 1] = {"petdebir",0,font,nHeroId, petIdx}
				
				if showf == 1 then
					local strText = hVar.tab_string["__UPGRADEBFLEVEL_CANT"] --"已升到最大等级"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
					showf = 0
				end
			end
		end
	end
	return bFlag,costlist,sTag
end

------------------------------------------------------------------------------------------------------------
--检测武器枪是否可以 升级/升星
LuaCheckHeroWeaponCanUpgrade = function(nHeroId, weaponIdx , showfloat)
	local bFlag = false
	local tabU = hVar.tab_unit[nHeroId]
	local costlist = {}
	local sTag = "" --tag
	local showf = showfloat or 0
	if tabU then
		local tabUW = tabU.weapon_unit
		if tabUW then
			local weaponId = tabUW[weaponIdx] and tabUW[weaponIdx].unitId or 0
			local star = LuaGetHeroWeaponLv(nHeroId, weaponIdx) --当前星级
			local level = LuaGetHeroWeaponExp(nHeroId, weaponIdx) --当前等级
			
			--等级未到顶级
			if (level < hVar.WEAPON_LVUP_INFO.maxWeaponLv) then
				--优先读取升级表
				local tLevelUpInfo = hVar.WEAPON_LVUP_INFO[level]
				local reqiureStar = tLevelUpInfo.reqiureStar --需要的星级
				
				if (star >= reqiureStar) then --星级足够，进行升级操作
					--tag
					sTag = "levelup"
					
					local shopItemId = tLevelUpInfo.shopItemId or 0
					local requireDebris = tLevelUpInfo.costDebris or 100
					local tShopItem = hVar.tab_shopitem[shopItemId] or {}
					local requireScore = tShopItem.score or 0 --升级需要的积分
					local requireRmb = tShopItem.rmb or 0 --升级需要的游戏币
					
					local enough = true
					
					if (requireScore > 0) then
						local nowScore = LuaGetPlayerScore() --当前的积分
						local font = "num"
						if nowScore < requireScore then
							font = "numRed"
							enough = false
							if showf == 1 then
								hApi.NotEnoughResource("coin")
								showf = 0
							end
						end
						costlist[#costlist + 1] = {"score",requireScore,font}
					end
					
					local nowRmb = LuaGetPlayerRmb() --当前的游戏币
					local font = "num"
					if nowRmb < requireRmb then
						font = "numRed"
						enough = false
						if showf == 1 then
							hApi.NotEnoughResource("keshi")
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"rmb",requireRmb,font}
					
					local debrisNum = LuaGetHeroWeaponDebrisNum(nHeroId,weaponIdx)
					local font = "numWhite"
					if debrisNum < requireDebris then
						font = "numRed"
						enough = false
						if showf == 1 then
							local strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 2000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"weapondebir",requireDebris,font,nHeroId, weaponIdx}
					
					if enough == true then
						bFlag = true
					end
				else --星级不够，进行升星操作
					--tag
					sTag = "starup"
					
					local tStarUpInfo = hVar.WEAPON_STARUP_INFO[star]
					local shopItemId = tStarUpInfo.shopItemId or 0
					local requireDebris = tStarUpInfo.costDebris or 100
					local tShopItem = hVar.tab_shopitem[shopItemId] or {}
					local requireScore = tShopItem.score or 0 --升星需要的积分
					local requireRmb = tShopItem.rmb or 0 --升星需要的游戏币
					
					local enough = true
					
					if (requireScore > 0) then
						local nowScore = LuaGetPlayerScore() --当前的积分
						local font = "num"
						if nowScore < requireScore then
							font = "numRed"
							enough = false
							if showf == 1 then
								hApi.NotEnoughResource("coin")
								showf = 0
							end
						end
						costlist[#costlist + 1] = {"score",requireScore,font}
					end
					
					local nowRmb = LuaGetPlayerRmb() --当前的游戏币
					local font = "num"
					if nowRmb < requireRmb then
						font = "numRed"
						enough = false
						if showf == 1 then
							hApi.NotEnoughResource("keshi")
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"rmb",requireRmb,font}
					
					local debrisNum = LuaGetHeroWeaponDebrisNum(nHeroId,weaponIdx)
					local font = "numWhite"
					if debrisNum < requireDebris then
						font = "numRed"
						enough = false
						if showf == 1 then
							local strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 2000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
							showf = 0
						end
					end
					costlist[#costlist + 1] = {"weapondebir",requireDebris,font,nHeroId, weaponIdx}
					
					if enough == true then
						bFlag = true
					end
				end
			else --等级已满
				--只展示当前碎片数量
				--local debrisNum = LuaGetHeroWeaponDebrisNum(nHeroId,weaponIdx)
				local font = "numWhite"
				costlist[#costlist + 1] = {"weapondebir",0,font,nHeroId, weaponIdx}
				
				if showf == 1 then
					local strText = hVar.tab_string["__UPGRADEBFLEVEL_CANT"] --"已升到最大等级"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
					showf = 0
				end
			end
		end
	end
	return bFlag,costlist,sTag
end



---------------------------------------------------------------------
--读取是否是月卡状态
LuaGetIsMonthCardState = function(playerName, index)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		return player.is_monthcard_state or 0
	end
	
	return 0
end

--设置是否是月卡状态
LuaSetIsMonthCardState = function(playerName, state)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.is_monthcard_state = state
		
		--print("设置是否是月卡状态", state)
		--本地存档
		LuaSavePlayerList()
	end
end

--清空是否是月卡状态
LuaClearIsMonthCardState = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.is_monthcard_state = 0 --是否月卡状态
	end
end
---------------------------------------------------------------------


---------------------------------------------------------------------
--读取随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
LuaGetRandommapInfo = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		return player.randommap_info --随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
	end
	
	return
end

--设置随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
LuaSetRandommapInfo = function(playerName, tInfo)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		player.randommap_info = tInfo --随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
		
		--本地存档
		LuaSavePlayerList()
	end
end

--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
LuaClearRandommapInfo = function(playerName, notSaveFlag)
	--print(debug.traceback())
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.randommap_info = {} --随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
	end
	
	if (not notSaveFlag) then
		--本地存档
		LuaSavePlayerList()
	end
end
---------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------
--四个危险的测试代码
--英雄星级重置
LuaHeroStarReset = function(id)
	local tHeroCard = hApi.GetHeroCardById(id)
	--英雄卡不存在返回失败
	if not tHeroCard then
		return
	end
	
	tHeroCard.attr.star = 1
	tHeroCard.attr.soulstone = 0
	
	LuaHeroLevelReset(id)
end

--英雄经验等级清0
LuaHeroLevelReset = function(id)
	local tHeroCard = hApi.GetHeroCardById(id)
	--英雄卡不存在返回失败
	if not tHeroCard then
		return
	end
	
	tHeroCard.attr.level = 1
	tHeroCard.attr.exp = 0
	
	LuaHeroSkilReset(id)
	LuaHeroTacticReset(id)
end

--英雄技能等级清0
LuaHeroSkilReset = function(id)
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return
	end
	
	local star = tHeroCard.attr.star
	local level = tHeroCard.attr.level
	local starInfo = hVar.HERO_STAR_INFO[id][star]
	local maxLv = starInfo.maxLv					--等级上限
	
	tHeroCard.talent = {}
	for i = 1, #hVar.HERO_STAR_INFO do
		tHeroCard.talent[i] = {}
	end
	local talent = tHeroCard.talent
	
	local tabU = hVar.tab_unit[id]
	local talentU = tabU.talent or {}
	
	for i = 1, #talentU do
		local skillObj = talent[i]
		if talentU[i] and talentU[i][1] then
			skillObj.id = talentU[i][1]
			if i <= star then
				skillObj.lv = 1
			else
				skillObj.lv = 0
			end
		end
	end
end

--英雄战术技能清0
LuaHeroTacticReset = function(id)
	local tHeroCard = hApi.GetHeroCardById(id)
	if not tHeroCard then
		return
	end
	
	local star = tHeroCard.attr.star
	local level = tHeroCard.attr.level
	local starInfo = hVar.HERO_STAR_INFO[id][star]
	local maxLv = starInfo.maxLv					--等级上限
	
	tHeroCard.tactic = {}
	for i = 1, #hVar.HERO_STAR_INFO do
		tHeroCard.tactic[i] = {}
	end
	local tactic = tHeroCard.tactic
	
	local tabU = hVar.tab_unit[id]
	local tacticU = tabU.tactics or {}
	
	for i = 1, #tacticU do
		local skillObj = tactic[i]
		if tacticU[i] and tacticU[i] then
			skillObj.id = tacticU[i]
			skillObj.lv = 1
		end
	end
end

------------------------------------zhenkira 英雄相关----------------------------------------------
--返回游戏中当前玩家的英雄数据表
local _MakeHeroData = function(player)
	local tempT = {}
	if type(player) == "table" then
		for i = 1,#player.heros do
			local oHero = player.heros[i]
			if type(oHero)=="table" and oHero.data.HeroCard==1 then
				if oHero.attr.exp>=oHero.data.cexp then
					oHero.data.cexp = oHero.attr.exp
					tempT[oHero.data.id] = oHero.data.cexp
				end
			end
		end
	end
	return tempT
end

--检测英雄数据的合法性 -EXP
local _CheckHeroExpData = function(HeroCardData,tempHero)
	if type(HeroCardData) ~= "table" or type(tempHero) ~= "table" then return end
	for i = 1,#HeroCardData do
		local tHeroCard = HeroCardData[i]
		if tempHero[tHeroCard.id] and tHeroCard.attr.exp<tempHero[tHeroCard.id] then
			tHeroCard.attr.exp = tempHero[tHeroCard.id]
			tHeroCard.attr.level = hApi.GetLevelByExp(tHeroCard.attr.exp)
		end
	end
end

LuaSaveHeroCard = function(SaveTag)
	--zhenkira 2015.12.3注释掉该部分。目前只有游戏结束会产出经验并且和oworld不挂钩，直接调用新的addexp接口改变经验和等级
	--新的存储英雄卡片流程
	--if Save_PlayerData and type(Save_PlayerData.herocard)=="table" then
		--某些情况下需要同步卡片中的经验值
	--	if SaveTag=="SaveMap" or SaveTag=="Victory" then
	--		local tHeroExp = _MakeHeroData(hGlobal.LocalPlayer)
	--		_CheckHeroExpData(Save_PlayerData.herocard,tHeroExp)
			--游戏中不会产生英雄技能的变化，所以地图保存时只操作exp --zhenkira 2015.11.27
	--	end
	--end

	if not SaveTag then
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	
end

---------------------------------------------------------------------------------------------------
--获取当前玩家表的版本号
LuaGetPlayerListVersion = function(filepath)
	local version = 0
	if hApi.FileExists(filepath) then
		local s = {xlLoadGameData(filepath,2,0)}
		if type(s[2])=="string" then
			version = tonumber(string.sub(s[2],3,string.len(s[2])) or 0)
		end
	end
	return version
end

------------------------------------------------积分相关--------------------------------------------

--设置当前游戏玩家积分
LuaSetPlayerScore = function(score,notSaveFlag)
	if score > _MaxPlayerScore then
		score = _MaxPlayerScore
	elseif score < 0 then
		score = 0
	end
	
	
	----判断设备
	--local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	----IOS
	--if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
		--xlSaveIntToKeyChain("xl_"..g_curPlayerName.."_playerScore",score)
	----windows
	--else
		--CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..g_curPlayerName.."_playerScore",score)
		--CCUserDefault:sharedUserDefault():flush()
	--end
	
	if Save_PlayerData then
		local tab_score = bit:d2b(score)
		if type(tab_score) == "table" then
			Save_PlayerData.score = tab_score
			if not notSaveFlag then
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
		else
			if not notSaveFlag then
				xlAppAnalysis("b2d_score_error",0,1,"info:",tostring(xlPlayer_GetUID()).."-"..tostring(score).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end
		end
		
	end
end

LuaGetPlayerScoreFromFile = function(fileStr,playName)
	local score = 0
	local scoreStr = string.sub(fileStr,string.find(fileStr,"score=")+6,string.find(fileStr,"score=")+71)
	local luafunc = function(luaStr)
		local str = "do local scoreT = " .. luaStr .. " return scoreT end"
		local f = loadstring(str)
		if f then
			return f()
		end
	end
	local temp = luafunc(scoreStr)
	if type(temp) == "table" then
		score = bit:b2d(temp)
	end
	
	--判断设备
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	--IOS
	if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
		xlSaveIntToKeyChain("xl_"..playName.."_playerScore",score)
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..playName.."_playerScore",score)
		CCUserDefault:sharedUserDefault():flush()
	end
	
	return score
end

--输入玩家名字获取该玩家的积分(参数是否从内存中读取)
LuaGetPlayerScore = function(fromMem)
	
	if not fromMem then
		--判断设备
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--IOS
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			if g_curPlayerName then
				return xlGetIntFromKeyChain("xl_"..g_curPlayerName.."_playerScore")
			else
				return 0
			end
		--windows
		else
			if g_curPlayerName then
				return CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..g_curPlayerName.."_playerScore")
			else
				return 0
			end
		end
	else

		if Save_PlayerData then
			if type(Save_PlayerData.score) == "number" then
				old_score = Save_PlayerData.score
			elseif type(Save_PlayerData.score) == "table" then
				old_score = bit:b2d(Save_PlayerData.score)
			end
			return old_score
		end
		return 0
	end
end

--增加玩家积分
LuaAddPlayerScore = function(score, notSaveFlag)
	--判断设备
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	--IOS
	if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
		local keyChain_score = xlGetIntFromKeyChain("xl_"..g_curPlayerName.."_playerScore")
		keyChain_score = keyChain_score + score
		
		if keyChain_score > _MaxPlayerScore then
			keyChain_score = _MaxPlayerScore
		elseif keyChain_score < 0 then
			keyChain_score = 0
		end
		
		xlSaveIntToKeyChain("xl_"..g_curPlayerName.."_playerScore",keyChain_score)
		
		--存储存档里的总积分
		if Save_PlayerData then
			Save_PlayerData.totalScore = keyChain_score
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	--windows
	else
		local CCUser_score = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..g_curPlayerName.."_playerScore")
		
		if CCUser_score > _MaxPlayerScore then
			CCUser_score = _MaxPlayerScore
		elseif CCUser_score < 0 then
			CCUser_score = 0
		end
		
		CCUser_score = CCUser_score + score
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..g_curPlayerName.."_playerScore",CCUser_score)
		CCUserDefault:sharedUserDefault():flush()
		
		--存储存档里的总积分
		if Save_PlayerData then
			Save_PlayerData.totalScore = CCUser_score
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
	
	if Save_PlayerData and type(score) == "number" then
		if score > 0 then
			--
		else
			LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.costScore,-score)
		end
		
		LuaSetPlayerScore(LuaGetPlayerScore(notSaveFlag)+score,notSaveFlag)
		hGlobal.event:event("LocalEvent_SetCurGameScore")
	end
end

--获得积分上限
LuaGetMaxScore = function()
	return _MaxPlayerScore
end

--获得当前玩家的游戏币
LuaGetPlayerRmb = function()
	return hVar.ROLE_PLAYER_GOLD
end

--获得当前玩家的芯片
LuaGetPlayerChip = function()
	return hVar.ROLE_PLAYER_CHIP
end

---------------------------------------------------------------------------------------------------------
--根据地图名字找到此地图成就项
LuaGetAchievementByMapName = function(AchiLsit,mapName)
	if mapName == 0 or type(AchiLsit) ~= "table" then return nil end
	for i = 1,#AchiLsit do
		if AchiLsit[i][_MapName] == mapName then
			return AchiLsit[i][_Achievement]
		end
	end
end

----------------------------------------------------------------------------------------------------------
--设置玩家地图成就
LuaSetPlayerAchievementByMapName = function(mapName,achiType,state)
	if Save_PlayerData then
		local achi = Save_PlayerData.achievement
		local mapachi = LuaGetAchievementByMapName(achi,mapName)
		if mapachi then
			mapachi[achiType] = state
		end
	end
end

--设置玩家试炼地图成就
LuaSetPlayerAchievementEx = function(mapName,achiType,Val)
	if Save_PlayerData then
		local achiEx = Save_PlayerData.achievementEx
		local mapachiEx = LuaGetAchievementByMapName(achiEx,mapName)
		if mapachiEx then
			mapachiEx[achiType] = Val
		end
	end
end

--获取玩家试炼地图成就
LuaGetPlayerAchievementEx = function(mapName,achiType)
	if hVar.MAP_SCORE[mapName] == nil then return -1 end
	if Save_PlayerData then
		local achiEx = Save_PlayerData.achievementEx
		local mapachiEx = LuaGetAchievementByMapName(achiEx,mapName)
		if mapachiEx then
			return mapachiEx[achiType]
		end
	end
	return 0
end

--根据名字和地图名字找到此地图成就项
LuaGetPlayerAchievementByMapName = function(mapName,achiType)
	if hVar.MAP_SCORE[mapName] == nil then return -1 end
	if Save_PlayerData then
		local achi = Save_PlayerData.achievement
		local mapachi = LuaGetAchievementByMapName(achi,mapName)
		if mapachi then
			return mapachi[achiType]
		end
	end
	return 0
end

--因为一个bug所以出现了这个终极解决方案(fuckTJ)
LuaGetPlayerMapAchievement = function(mapName,nIndex)
	--这个接口是任务专用，不允许操作这个位置之前的任何数据
	--等陶晶解决前面的兼容问题以后再改这里
	if nIndex<hVar.ACHIEVEMENT_TYPE.UNIQUE_QUEST_1 then
		return -1
	end
	if Save_PlayerData and hVar.MAP_INFO[mapName] then
		local v = hVar.MAP_INFO[mapName]
		if (v.level or 0)>0 then
			--正式地图
			local tAch = LuaGetAchievementByMapName(Save_PlayerData.achievement,mapName)
			if tAch then
				return tAch[nIndex]
			end
		else
			--娱乐地图
			local tAch = LuaGetAchievementByMapName(Save_PlayerData.achievementEx,mapName)
			if tAch then
				return tAch[nIndex]
			end
		end
	end
	return -1
end

--同上
LuaSetPlayerMapAchievement = function(mapName,nIndex,v)
	--这个接口是任务专用，不允许操作这个位置之前的任何数据
	--等陶晶解决前面的兼容问题以后再改这里
	if nIndex<hVar.ACHIEVEMENT_TYPE.UNIQUE_QUEST_1 then
		return -1
	end
	if Save_PlayerData and hVar.MAP_INFO[mapName] then
		local x = hVar.MAP_INFO[mapName]
		if (x.level or 0)>0 then
			--正式地图
			local tAch = LuaGetAchievementByMapName(Save_PlayerData.achievement,mapName)
			if tAch then
				tAch[nIndex] = v
				return 1
			else
				return -1
			end
		else
			--娱乐地图
			local tAch = LuaGetAchievementByMapName(Save_PlayerData.achievementEx,mapName)
			if tAch then
				tAch[nIndex] = v
				return 1
			else
				return -1
			end
		end
	end
	return -1
end

----新的获取地图成就信息的相关接口
--LuaGetPlayerMapAchi = function(mapName,achiType)
--	--if hVar.MAP_SCORE[mapName] == nil then return -1 end
--	if Save_PlayerData and Save_PlayerData.mapAchi then
--		for i = 1,#Save_PlayerData.mapAchi do
--			if Save_PlayerData.mapAchi[i][_MapName] == mapName then
--				return Save_PlayerData.mapAchi[i][_Achievement][achiType]
--			end
--		end
--		return 0
--	end
--	return 2
--end

--获取地图成就信息的相关接口
LuaGetPlayerMapAchi = function(mapName,achiType)
	local uid = hApi.GetIDByName(mapName)
	if Save_PlayerData and Save_PlayerData.mapAchi and type(Save_PlayerData.mapAchi[uid]) == "table" then
		return Save_PlayerData.mapAchi[uid][achiType]
	end
	return 0
end

----设置地图成就
--LuaSetPlayerMapAchi = function(mapName,achiType,Val)
--	if Save_PlayerData and Save_PlayerData.mapAchi then
--		for i = 1,#Save_PlayerData.mapAchi do
--			if Save_PlayerData.mapAchi[i][_MapName] == mapName then
--				Save_PlayerData.mapAchi[i][_Achievement][achiType] = Val
--				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--				return 1
--			end
--		end
--		return 0
--	end
--	return 2
--end
--设置地图成就
LuaSetPlayerMapAchi = function(mapName,achiType,Val,notSaveFlag)
	local uid = hApi.GetIDByName(mapName)
	if Save_PlayerData and Save_PlayerData.mapAchi and type(Save_PlayerData.mapAchi[uid]) == "table" then
		Save_PlayerData.mapAchi[uid][achiType] = Val
		if not notSaveFlag then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
		return 1
	end
	return 2
end

--根据地图名字返回地图唯一ID
hApi.GetIDByName = function(MapName)
	if hVar.MAP_INFO[MapName] and type(hVar.MAP_INFO[MapName].uniqueID) == "number" then
		return hVar.MAP_INFO[MapName].uniqueID
	end
	return nil 
end

--根据地图ID返回地图名
hApi.GetNameByUid = function(MapUid)
	if type(hVar.MAP_UID2NAME[MapUid]) == "string" then
		return hVar.MAP_UID2NAME[MapUid]
	end
	return nil
end

---------------------------------------------------------------------------

--根据输入的索引返回玩家信息
LuaGetPlayerByIndex = function(index)
	if index >0 and index < 4 and Save_playerList then
		return Save_playerList[index]
	end
end

--根据输入的玩家名字 找到该条玩家的信息项
LuaGetPlayerByName = function(playername)
	if Save_playerList then
		for i = 1,#Save_playerList do
			if Save_playerList[i].name == playername then
				return Save_playerList[i],i
			end
		end
	end
	return nil
end

--返回当前内存中的玩家数据表
LuaGetPlayerData = function()
	if Save_PlayerData then
		return Save_PlayerData
	end
end

--根据玩家列表中的名字获取玩家数据
LuaGetPlayerDataByName = function(playerName,filepath)
	--如果输入的名字是创建新玩家
	if playerName == nil then return nil end
	--如果 输入的名字合法 判断是否拥有玩家数据的物理文件 如果有则 加载并且返回 如果没有 则创建一个空的 全局表
	if filepath ~= nil and hApi.FileExists(filepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,"full") then
		LuaLoadSavedGameData(filepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
		return Save_PlayerData
	else
		return nil
	end
end

--根据玩家名字获取玩家log
LuaGetPlayerLogByName = function(playerName,filepath)
	if playerName == nil then return nil end
	if filepath ~= nil and hApi.FileExists(filepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG,"full") then
		LuaLoadSavedGameData(filepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)
		return Save_PlayerLog
	else
		return nil
	end
end

Lua_UIShow_PlayerInfoFram = function(index)
	if index >0 and index < 4 and Save_playerList ~= nil then
		index = math.floor(index)
		hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",index)
		
		--如果创建一个新玩家则 此值+1
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--app
		local playerCount = 0
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			playerCount = xlGetIntFromKeyChain("xl_NewPlayerCount")
			playerCount = playerCount + 1
			xlSaveIntToKeyChain("xl_NewPlayerCount",playerCount)
			
		--windows 如果创建一个新玩家则 此值+1
		else
			playerCount = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_NewPlayerCount")
			playerCount = playerCount + 1
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_NewPlayerCount",playerCount)
			CCUserDefault:sharedUserDefault():flush()
		end
		
		luaSetplayerUniqueID(playerCount)
		
		--zhenkira 新增流程，用于处理新建角色后自动创建uid
		hGlobal.event:event("LocalEvent_afterPlayerCreate")
	end
end

--关闭面板函数
function Lua_ClosePlayerListFrm()
	if hGlobal.UI.SelectedPlayerFram then
		hGlobal.UI.SelectedPlayerFram:show(0)
	end
end


--上传玩家数据
Lua_SendPlayerData = function(orderid)
	--玩家数据表 只有当 当前玩家存在时 发送
	if type(g_curPlayerName) == "string" then
		if Save_PlayerData and Save_PlayerData.herocard and #Save_PlayerData.herocard > 2 then
			local saveEx = {
				"--"..(g_curPlayerName or 0).."\n",
				"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
				"--"..os.date("%X").."\n",
				"Save_PlayerData",
			}
			local rTab = hApi.SaveTable(Save_PlayerData,saveEx,{mapAchi="n", score= 0 ,mat = 0,medal = 0,equipment="kn",item="kn",bag= "kn",battlefieldskillbook = "kn",giftstate = 0,giftbag = "kn", dlc = "kn" ,assistant = "kn",getGiftCount = "kn",activebattlefieldskill = "kn"})
			local data_s = ""
			if type(rTab) == "table" then
				for i = 1,#rTab do
					data_s = data_s..rTab[i]
					--print("rTab[i]:",rTab[i])
				end
			end
			
			--数据log表
			--local savelogEx = {
				--"--"..(g_curPlayerName or 0).."\n",
				--"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
				--"--"..os.date("%X").."\n",
				--"Save_PlayerLog",
			--}
				
			--local logTab = hApi.SaveTable(Save_PlayerLog,savelogEx,{deleteitem = "kn",getitem = "kn",item_statistics = "kn",killcount = "kn",useitemcount = "kn",killcount = "kn",BehaviorList = "kn",getGiftCount="kn",})
			--local log_s = ""
			--if type(logTab) == "table" then
				--for i = 1,#logTab do
					--log_s = log_s..logTab[i]
				--end
			--end
			SendCmdFunc["send_playdata_new"](g_curPlayerName,luaGetplayerDataID(),1,orderid,data_s)
			--if modeInt == 99 then
				--local text = debug.traceback()
				--xlLG("Lua_SendPlayerData",text.."\n")
			--end
			xlUpdateCustomTable(0,"customS1",tostring(g_curPlayerName))
		end
	end

end

--增加 副将至玩家数据表
luaAddAssistantHero = function(heroID)
	if Save_PlayerData and type(Save_PlayerData.assistant) == "table" then
		for i = 1,#Save_PlayerData.assistant do
			if Save_PlayerData.assistant[i].id == heroID then
				print("you have this hero")
				return 0
			end
		end
		Save_PlayerData.assistant[#Save_PlayerData.assistant+1] = {id = heroID,attr = {level = 1}}
		return 1
	end
end

luaGetAssistantHero = function()
	local temp = {}
	if Save_PlayerData and type(Save_PlayerData.assistant) == "table" then
		return Save_PlayerData.assistant
	end
	return temp
end

--根据 rid 设置玩家名字
LuaSetPlayerShowName = function(rid,showName)
	if Save_playerList then
		for i = 1,3 do
			if Save_playerList[i].roleID == rid then
				Save_playerList[i].showName = showName
				LuaSavePlayerList()
			end
		end
	end
end
--只有在迁移流程中会使用到的接口，请不要随便调用 谢谢 如有疑问 可以找陶晶 
LuaDeletePlayerDataAll = function(orderid,newuid)
	if Save_playerList then
		for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
			local playerName = Save_playerList[i].name
			if playerName ~= "__TEXT_CreateNewPlayer" then
				local playerData = LuaGetPlayerDataByName(playerName,g_localfilepath)
				if playerData then
					local UniqueID = playerData.playerUniqueID
					--重置玩家的 keyChain 值
					for i = 1,#hVar.ConstItemIDList do
						xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName..tostring(hVar.ConstItemIDList[i]),0)
					end
					
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."SkillCardCount",0)
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."WishingCount",0)
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."ResolveBFSkillCount",0)

					xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
					xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.FOG)
					xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
					xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)
					
					--设置当前玩家为创建新用户
					if Save_PlayerData then 
						Save_PlayerData = {}
						Save_PlayerData = nil
					end
					
					if Save_PlayerLog then
						Save_PlayerLog = {}
						Save_PlayerLog = nil
					end
				end
			end
		end
		
		if hGlobal.WORLD.LastWorldMap then
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
			hApi.clearCurrentWorldScene()
		end
		
		Save_playerList = {}
		--如果是本地玩家表，则通过玩家模板数据 创建3个默认数据项
		for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
			Save_playerList[i] = templet_playerList
		end
		Save_playerList.userID = newuid or xlPlayer_GetUID()
		print("Save_playerList.userID",Save_playerList.userID)
		Save_playerList.LastSwitchPlayer = 1
		Save_playerList.SaveBackName = ""
		Save_playerList.SaveBackRid = 0
		Save_playerList.SaveBackTime = ""
		Save_playerList.SaveBackGameScore = 0
		Save_playerList.SaveBackLastFrmShow = 0
		Save_playerList.dlc = {}
		LuaSavePlayerList()
		--xlLG("fucici","g_SyncDataTicketNum = "..g_SyncDataTicketNum.."\n")
		if type(orderid) == "number" then
			SendCmdFunc["setWormHoleState"](orderid,3)
		end
		
	end
	return 0
end

--一个恐怖的接口 小心哦...
LuaDeletePlayerDataByName = function(orderid)
	--清除掉全部的成就信息
	for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
		if Save_playerList[i].name ~= "__TEXT_CreateNewPlayer" then
			local playerName = Save_playerList[i].name
			LuaDeletePlayerAutoSave(playerName)
			LuaClearLootFromUnit(playerName)
			LuaClearSelectConfig(playerName) --清空本地选人配置
			LuaClearSystemMailTitle(playerName) --清空玩家最近一次已阅读的系统邮件的标题
			LuaClearTaskFinishFlag(playerName) --清除玩家是否有已完成的任务标记
			LuaClearTaskPVPFreeChestFlag(playerName) --清除玩家夺塔奇兵免费锦囊今日是否可免费
			LuaClearActivityAidList(playerName)--清空玩家已查看的活动aid列表
			LuaClearPVPUserInfo(playerName) --清空pvp玩家本局对战的对手信息
			LuaClearPVPIsShowGuide(playerName)--清空玩家pvp是否显示引导
			LuaClearPlayerBillBoard(playerName) --清空玩家今日本地排行榜的数据
			LuaClearTodayShopItemLimitCount(playerName) --清空玩家今日锁孔洗炼购买次数数据
			LuaClearTodayNetShopGoods(playerName) --清空玩家的今日商城商品列表
			LuaClearIsMonthCardState(playerName) --清空月卡状态
			LuaClearRandommapInfo(playerName) --清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
			LuaSetPlayerListMapUniqueID(playerName, 0)
			LuaClearGuiderecodeList(playerName)
			LuaResetSaveTitle(playerName)
			LuaClearRidByName(playerName)
			
			LuaSavePlayerList()
			
			local playerData = LuaGetPlayerDataByName(playerName,g_localfilepath)
			local UniqueID = playerData.playerUniqueID
			--重置玩家的 keyChain 值
			for i = 1,#hVar.ConstItemIDList do
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName..tostring(hVar.ConstItemIDList[i]),0)
			end
			
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."SkillCardCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."WishingCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(UniqueID)..playerName.."ResolveBFSkillCount",0)
			
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.FOG)
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)
			
			--设置当前玩家为创建新用户
			--LuaSetPlayerList(i,"__TEXT_CreateNewPlayer","local")
			if Save_PlayerData then 
				Save_PlayerData = {}
				Save_PlayerData = nil
			end
			
			if Save_PlayerLog then
				Save_PlayerLog = {}
				Save_PlayerLog = nil
			end
		end
	end
	
	--删除playerlist
	xlDeleteFileWithFullPath(g_localfilepath..hVar.SAVE_DATA_PATH.PLAYER_LIST, "full")
	
	if hGlobal.WORLD.LastWorldMap then
		hGlobal.WORLD.LastWorldMap:del()
		hGlobal.WORLD.LastWorldMap = nil
		
		hApi.clearCurrentWorldScene()
	end
	
	--xlLG("fuckcucu","g_SyncDataTicketNum = "..g_SyncDataTicketNum.."\n")
	--[[
	hGlobal.UI.MsgBox("orderid=" .. tostring(orderid) .. ", type=" .. type(orderid),{
		font = hVar.FONTC,
		ok = function()
			--
		end,
	})
	]]
	if (type(orderid) == "number") then
		--SendCmdFunc["setWormHoleState"](orderid,2)
		SendCmdFunc["check_out_state"](2,0)
	end
	xlPlayer_SetUID(0)
	return 0
end

--在存档迁移之后调用的接口，用来清理一些游戏数据
LuaAfterMigrateSaveFile = function(dataStr,isGm,newRoldID)
	dataStr = string.gsub(dataStr,"playerUniqueID=([%d]+),","playerUniqueID=0,")		--修改本设备的唯一id
	dataStr = string.gsub(dataStr,"forgedcount=([%d]+),","forgedcount=0,")			--修改锻造信息
	dataStr = string.gsub(dataStr,"wishingcount=([%d]+),","wishingcount=0,")		--修改红装许愿
	dataStr = string.gsub(dataStr,"BFSkillCardCount=([%d]+),","BFSkillCardCount=0,")	--修改获得战术技能卡count
	dataStr = string.gsub(dataStr,"resolvebfskillcount=([%d]+),","resolvebfskillcount=0,")	--修改删除战术啊卡牌count
	dataStr = string.gsub(dataStr,"useDepletion=([%d]+),","useDepletion=0,")		--存档中使用过的宝箱数量
	dataStr = string.gsub(dataStr,"wisingCount=([%d]+),","wisingCount=0,")			--许愿次数
	dataStr = string.gsub(dataStr,"forgeCount=([%d]+),","forgeCount=0,")			--新的锻造次数

	local uid = xlPlayer_GetUID()
	dataStr = string.gsub(dataStr,"userID=([%d]+),","userID="..tostring(uid)..",")					--修改userid

	if isGm == 1 then	-- isGm 为 1 时 做清除 RoldID 的逻辑 
		dataStr = string.gsub(dataStr,"playerDataID=([%d]+),","playerDataID="..tostring(newRoldID or 0)..",")		--修改角色ID
	end
	--xlLG("savefile2",dataStr)

	return dataStr
end

--根据唯一id删除或替换装备
LuaDeletePlayerDataRedEquip = function(dbid, newEquip)
	if Save_PlayerData then
		
		--玩家背包道具类型计数
		if Save_PlayerData.bag then
			for i = 1,#Save_PlayerData.bag do
				if type(Save_PlayerData.bag[i]) == "table" then
					local item = Save_PlayerData.bag[i]
					local itemId = item[hVar.ITEM_DATA_INDEX.ID]
					local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
					--判定道具typeid是否一致
					--if itemId == itemTypeID then
						--判定dbid是否一致
						if (type(fromInfo) == "table") then
							for n = 1, #fromInfo do
								local from = fromInfo[n]
								if (type(from) == "table") then
									if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET and from[2] == dbid then
										if newEquip then
											Save_PlayerData.bag[i] = newEquip
										else
											Save_PlayerData.bag[i] = 0
										end
										return true
									end
								end
							end
						end
					--end
				end
			end
		end
		--玩家卡片道具清理
		--玩家卡片道具清理
		if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
			for i = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[i]
				if type(hero) == "table" then
					--道具栏
					if type(hero.equipment) == "table" then
						for j = 1,#hero.equipment do
							if type(hero.equipment[j]) == "table" then
								local item = hero.equipment[j]
								local itemId = item[hVar.ITEM_DATA_INDEX.ID]
								local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
								--判定道具typeid是否一致
								--if itemId == itemTypeID then
									--判定dbid是否一致
									if (type(fromInfo) == "table") then
										for n = 1, #fromInfo do
											local from = fromInfo[n]
											if (type(from) == "table") then
												if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET and from[2] == dbid then
													if newEquip then
														hero.equipment[j] = newEquip
													else
														hero.equipment[j] = 0
													end
													return true
												end
											end
										end
									end
								--end
							end
						end
					end
				end
			end
		end
	end
	return false
end

--获取需要转换的红装道具
LuaPlayerDataOldRedEquipInfo = function()

	local ret = ""
	local retNum = 0
	
	--玩家背包道具类型计数
	if Save_PlayerData.bag then
		for i = 1,#Save_PlayerData.bag do
			if type(Save_PlayerData.bag[i]) == "table" then
				local item = Save_PlayerData.bag[i]
				local itemId = item[hVar.ITEM_DATA_INDEX.ID]
				local itemSlot = item[hVar.ITEM_DATA_INDEX.SLOT]
				local itemUnique = item[hVar.ITEM_DATA_INDEX.UNIQUE]
				--[[
				if itemId == 11007 or itemId == 11082 then
					--有扩展属性的装备才能计算原有属性数量
					if itemSlot and type(itemSlot) == "table" then
						local attrNum = 0
						local attrInfo = ""
						--遍历已有孔里的属性，计算实际属性数并将属性置入排除属性列表
						for i = 1, math.min(#itemSlot, 4) do
							local attr = itemSlot[i]
							if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
								attrInfo = attrInfo .. attr .. ":"
								attrNum = attrNum + 1
							end
						end

						ret = ret .. itemId .. "|" .. itemUnique .. "|" .. attrNum .. "|" .. attrInfo .. ";"
						retNum = retNum + 1
					else
						ret = ret .. itemId .. "|" .. itemUnique .. "|" .. 0 .. "|" .. "" .. ";"
						retNum = retNum + 1
					end
				end
				--]]
			end
		end
	end
	--玩家装备信息清理
	if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
		for i = 1,#Save_PlayerData.herocard do
			local hero = Save_PlayerData.herocard[i]
			if type(hero) == "table" then
				--道具栏
				if type(hero.equipment) == "table" then
					for j = 1,#hero.equipment do
						if type(hero.equipment[j]) == "table" then
							local item = hero.equipment[j]
							local itemId = item[hVar.ITEM_DATA_INDEX.ID]
							local itemSlot = item[hVar.ITEM_DATA_INDEX.SLOT]
							local itemUnique = item[hVar.ITEM_DATA_INDEX.UNIQUE]
							--[[
							if itemId == 11007 or itemId == 11082 then
								--有扩展属性的装备才能计算原有属性数量
								if itemSlot and type(itemSlot) == "table" then
									local attrNum = 0
									local attrInfo = ""
									--遍历已有孔里的属性，计算实际属性数并将属性置入排除属性列表
									for i = 1, math.min(#itemSlot, 4) do
										local attr = itemSlot[i]
										if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
											attrInfo = attrInfo .. attr .. ":"
											attrNum = attrNum + 1
										end
									end

									ret = ret .. itemId .. "|" .. itemUnique .. "|" .. attrNum .. "|" .. attrInfo .. ";"
									retNum = retNum + 1
								else
									ret = ret .. itemId .. "|" .. itemUnique .. "|" .. 0 .. "|" .. "" .. ";"
									retNum = retNum + 1
								end
							end
							--]]
						end
					end
				end
			end
		end
	end

	ret = retNum .. ";" .. ret
	return ret
end

--同步红装
LuaSyncPlayerDataRedEquip = function(redEquipDic)
	--print("LuaSyncPlayerDataRedEquip", redEquipDic)
	local syncOkDic = {}
	local syncOkDicEquip = {}
	if Save_PlayerData then
		
		--玩家背包道具类型计数
		if Save_PlayerData.bag then
			for i = 1,#Save_PlayerData.bag do
				if type(Save_PlayerData.bag[i]) == "table" then
					local item = Save_PlayerData.bag[i]
					local itemId = item[hVar.ITEM_DATA_INDEX.ID]
					local itemUniqId = item[hVar.ITEM_DATA_INDEX.UNIQUE]
					local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
					local tabI = hVar.tab_item[itemId]
					if tabI then
						local itemLv = tabI.itemLv
						local isArtifact = tabI.isArtifact or 0
						--if itemLv == hVar.ITEM_QUALITY.ORANGE and isArtifact == 1 then
						--if itemLv == hVar.ITEM_QUALITY.ORANGE then --战车不限红装
							local findEquip
							--判定dbid是否一致
							if (type(fromInfo) == "table") then
								for n = 1, #fromInfo do
									local from = fromInfo[n]
									if (type(from) == "table") then
										if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET then
											findEquip = redEquipDic[from[2]]
											if findEquip then
												from[3] = findEquip.slotNum
											end
										end
									end
								end
							end
							
							--如果找到了，比较是否一致，否则删除当前道具
							if findEquip and not syncOkDic[findEquip.dbid] then
								item[hVar.ITEM_DATA_INDEX.ID] = findEquip.typeId
								item[hVar.ITEM_DATA_INDEX.SLOT] = findEquip.attr
								item[hVar.ITEM_DATA_INDEX.QUALITY] = findEquip.quality
								item[hVar.ITEM_DATA_INDEX.RAND_IDX1] = findEquip.randIdx1 --随机属性索引1
								item[hVar.ITEM_DATA_INDEX.RAND_VAL1] = findEquip.randVal1 --随机属性值1
								item[hVar.ITEM_DATA_INDEX.RAND_IDX2] = findEquip.randIdx2 --随机属性索引2
								item[hVar.ITEM_DATA_INDEX.RAND_VAL2] = findEquip.randVal2 --随机属性值2
								item[hVar.ITEM_DATA_INDEX.RAND_IDX3] = findEquip.randIdx3 --随机属性索引3
								item[hVar.ITEM_DATA_INDEX.RAND_VAL3] = findEquip.randVal3 --随机属性值3
								item[hVar.ITEM_DATA_INDEX.RAND_IDX4] = findEquip.randIdx4 --随机属性索引4
								item[hVar.ITEM_DATA_INDEX.RAND_VAL4] = findEquip.randVal4 --随机属性值4
								item[hVar.ITEM_DATA_INDEX.RAND_IDX5] = findEquip.randIdx5 --随机属性索引5
								item[hVar.ITEM_DATA_INDEX.RAND_VAL5] = findEquip.randVal5 --随机属性值5
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX1] = findEquip.randSkillIdx1 --随机技能索引1
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV1] = findEquip.randSkillLv1 --随机技能等级1
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX2] = findEquip.randSkillIdx2 --随机技能索引2
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV2] = findEquip.randSkillLv2 --随机技能等级2
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX3] = findEquip.randSkillIdx3 --随机技能索引3
								item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV3] = findEquip.randSkillLv3 --随机技能等级3
								
								syncOkDic[findEquip.dbid] = true
								print("找到了背包", findEquip.dbid, findEquip.typeId)
							else
								--Save_PlayerData.bag[i] = 0
								LuaDeleteEquip(itemUniqId)
								LuaRecordEquipPosInfo(itemUniqId)
							end
						--elseif itemId == 11007 or itemId == 11082 then
						--	Save_PlayerData.bag[i] = 0
						--end
					else
						--不存在的道具id
						--Save_PlayerData.bag[i] = 0
						LuaDeleteEquip(itemUniqId)
						LuaRecordEquipPosInfo(itemUniqId)
					end
				end
			end
		end
		
		--玩家卡片道具清理
		if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
			for i = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[i]
				if type(hero) == "table" then
					--装备栏
					if type(hero.equipment) == "table" then
						for j = 1,#hero.equipment do
							local item = nil
							if type(hero.equipment[j]) == "table" then --旧格式
								item = hero.equipment[j]
								--print("装备栏"..j, item)
							elseif type(hero.equipment[j]) == "number" then --新格式
								local _, item_j = LuaFindEquipByUniqueId(hero.equipment[j])
								item = item_j
								--print("装备栏"..j, hero.equipment[j])
							end
							--print("item", item)
							if type(item) == "table" then
								--local item = hero.equipment[j]
								local itemId = item[hVar.ITEM_DATA_INDEX.ID]
								local itemUniqId = item[hVar.ITEM_DATA_INDEX.UNIQUE]
								local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
								local tabI = hVar.tab_item[itemId]
								if tabI then
									local itemLv = tabI.itemLv
									local isArtifact = tabI.isArtifact or 0
									--if itemLv == hVar.ITEM_QUALITY.ORANGE and isArtifact == 1 then
									--if itemLv == hVar.ITEM_QUALITY.ORANGE then --战车不限红装
										local findEquip
										--判定dbid是否一致
										if (type(fromInfo) == "table") then
											for n = 1, #fromInfo do
												local from = fromInfo[n]
												if (type(from) == "table") then
													if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET then
														findEquip = redEquipDic[from[2]]
														if findEquip then
															from[3] = findEquip.slotNum
														end
													end
												end
											end
										end
										
										--如果找到了，比较是否一致，否则删除当前道具
										--geyachao: 战车新格式，装备存的uniqieId也存储在背包里
										if findEquip and not syncOkDicEquip[findEquip.dbid]then
										--if findEquip and not syncOkDic[findEquip.dbid]then
											item[hVar.ITEM_DATA_INDEX.ID] = findEquip.typeId
											item[hVar.ITEM_DATA_INDEX.SLOT] = findEquip.attr
											item[hVar.ITEM_DATA_INDEX.QUALITY] = findEquip.quality
											item[hVar.ITEM_DATA_INDEX.RAND_IDX1] = findEquip.randIdx1 --随机属性索引1
											item[hVar.ITEM_DATA_INDEX.RAND_VAL1] = findEquip.randVal1 --随机属性值1
											item[hVar.ITEM_DATA_INDEX.RAND_IDX2] = findEquip.randIdx2 --随机属性索引2
											item[hVar.ITEM_DATA_INDEX.RAND_VAL2] = findEquip.randVal2 --随机属性值2
											item[hVar.ITEM_DATA_INDEX.RAND_IDX3] = findEquip.randIdx3 --随机属性索引3
											item[hVar.ITEM_DATA_INDEX.RAND_VAL3] = findEquip.randVal3 --随机属性值3
											item[hVar.ITEM_DATA_INDEX.RAND_IDX4] = findEquip.randIdx4 --随机属性索引4
											item[hVar.ITEM_DATA_INDEX.RAND_VAL4] = findEquip.randVal4 --随机属性值4
											item[hVar.ITEM_DATA_INDEX.RAND_IDX5] = findEquip.randIdx5 --随机属性索引5
											item[hVar.ITEM_DATA_INDEX.RAND_VAL5] = findEquip.randVal5 --随机属性值5
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX1] = findEquip.randSkillIdx1 --随机技能索引1
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV1] = findEquip.randSkillLv1 --随机技能等级1
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX2] = findEquip.randSkillIdx2 --随机技能索引2
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV2] = findEquip.randSkillLv2 --随机技能等级2
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLIDX3] = findEquip.randSkillIdx3 --随机技能索引3
											item[hVar.ITEM_DATA_INDEX.RAND_SKILLLV3] = findEquip.randSkillLv3 --随机技能等级3
											
											syncOkDic[findEquip.dbid] = true
											syncOkDicEquip[findEquip.dbid] = true
											print("找到了装备", findEquip.dbid, findEquip.typeId)
										else
											hero.equipment[j] = 0
										end
									--elseif itemId == 11007 or itemId == 11082 then
									--	hero.equipment[j] = 0
									--end
								else
									--不存在的道具id
									hero.equipment[j] = 0
								end
							else
								hero.equipment[j] = 0
							end
						end
					end
				end
			end
		end
		
		--将没有同步到的红装，添加到背包
		for dbid, equip in pairs(redEquipDic) do
			if not syncOkDic[equip.dbid] then
				if (LuaCheckPlayerBagCanUse() ~= 0) then
					local _,_,oItem = LuaAddItemToPlayerBag(equip.typeId,nil,nil,nil,equip,equip.quality)
					print("未找到", equip.dbid)
					
					--统一塞到仓库里
					LuaGainNewEquip(oItem)
				else
					--提示
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_BagItemIsFull_Net1"], {
						font = hVar.FONTC,
						ok = function()
						end,
					})
					break
				end
			end
		end
	end
end

--根据唯一id获取红装
LuaGetPlayerDataRedEquip = function(dbid)
	
	if Save_PlayerData then
		
		--玩家背包道具类型计数
		if Save_PlayerData.bag then
			for i = 1,#Save_PlayerData.bag do
				if type(Save_PlayerData.bag[i]) == "table" then
					local item = Save_PlayerData.bag[i]
					local itemId = item[hVar.ITEM_DATA_INDEX.ID]
					local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
					--判定道具typeid是否一致
					--if itemId == itemTypeID then
						--判定dbid是否一致
						if (type(fromInfo) == "table") then
							for n = 1, #fromInfo do
								local from = fromInfo[n]
								if (type(from) == "table") then
									if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET and from[2] == dbid then
										return true, 0, item, i
									end
								end
							end
						end
					--end
				end
			end
		end
		
		--玩家卡片道具清理
		if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
			for i = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[i]
				if type(hero) == "table" then
					--道具栏
					if type(hero.equipment) == "table" then
						for j = 1,#hero.equipment do
							local item = nil
							if type(hero.equipment[j]) == "table" then --旧格式
								item = hero.equipment[j]
							elseif type(hero.equipment[j]) == "number" then --新格式
								local _, item_j = LuaFindEquipByUniqueId(hero.equipment[j])
								item = item_j
							end
							if type(item) == "table" then
								--local item = hero.equipment[j]
								local itemId = item[hVar.ITEM_DATA_INDEX.ID]
								local fromInfo = item[hVar.ITEM_DATA_INDEX.FROM]
								--判定道具typeid是否一致
								--if itemId == itemTypeID then
								if (type(fromInfo) == "table") then
									--判定dbid是否一致
									for n = 1, #fromInfo do
										local from = fromInfo[n]
										if (type(from) == "table") then
											if from[1] == hVar.ITEM_FROMWHAT_TYPE.NET and from[2] == dbid then
												return true, hero.id, item, j
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return false, 0, nil,nil
end

--返回参数玩家名存档中所有英雄卡片，仓库背包中各道具 id 以及个数
LuaGetPlayerDataItemCount = function(tab)
	local ReT = tab or {}
	if Save_PlayerData then
		--玩家背包道具类型计数
		if Save_PlayerData.bag then
			for i = 1,#Save_PlayerData.bag do
				if type(Save_PlayerData.bag[i]) == "table" then
					local item = Save_PlayerData.bag[i]
					if ReT[item[1]] == nil then
						ReT[item[1]] = 1
					else
						ReT[item[1]] = ReT[item[1]] + 1
					end
				end
			end
		end
		--玩家卡片道具清理
		--玩家卡片道具清理
		if Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
			for i = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[i]
				if type(hero) == "table" then
					--道具栏
					if type(hero.equipment) == "table" then
						for j = 1,#hero.equipment do
							if type(hero.equipment[j]) == "table" then
								local item = hero.equipment[j]
								if ReT[item[1]] == nil then
									ReT[item[1]] = 1
								else
									ReT[item[1]] = ReT[item[1]] + 1
								end
							end
						end
					end
					--背包栏
					if type(hero.item) == "table" then
						for j = 1,#hero.item do
							if type(hero.item[j]) == "table" then
								local item = hero.item[j]
								if ReT[item[1]] == nil then
									ReT[item[1]] = 1
								else
									ReT[item[1]] = ReT[item[1]] + 1
								end
							end
						end
					end
				end
			end
		end
	end
	return ReT
end

--本地是否曾经建立过新账号
LuaCheckPlayerListRid = function()
	if Save_playerList then
		for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
			local playerInfo = Save_playerList[i]
			if playerInfo and type(playerInfo.roleID) == "number" and  playerInfo.roleID > 0 then
				return 0
			end
		end
		return 1
	end
	return 2
end

--判断本地数据是否是需要自动恢复存档的 判断依据 Save_PlayerList 表中的数据 都是 rid 为0 则返回1 代表需要 自动恢复流程
LuaCheckPlayerListNeedAutoBack = function()
	--当数据表存在时 进行判断 当前玩家表最大长度是 3
	if g_cur_net_state == -1 then return 0  end
	if Save_playerList then
		for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
			local playerInfo = Save_playerList[i]
			if playerInfo and type(playerInfo.roleID) == "number" and  playerInfo.roleID > 0 then
				return 0
			end
		end

		--设备判断 根据不同设备判断 是否有可用自动恢复存档的流程
		local backState,backRid = 0,Save_playerList.SaveBackRid
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		
		--IOS
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			backState = xlGetIntFromKeyChain("xlSaveFileBackState")

		--windows
		else
			backState = CCUserDefault:sharedUserDefault():getIntegerForKey("xlSaveFileBackState")
		end
		--当当前设备并未进入自动恢复存档状态时 且 有可用RID 时 开启自动恢复存档流程
		if backState == 0 and backRid > 0 then
			return backRid
		end
		return 1
	end
	return 2
end

--zhenkira old 检测DLC是否可用的脚本接口，只针对于，存档数据中有过关的记录，但是DLC中没有相应的数据的用户
--LuaCheckDLCFunc = function()
--	if Save_PlayerData and Save_PlayerData.dlc then
--		--章节地图的入口 如果是通关的，那么就查询是否有DLC，如果没有DLC 则发送查询
--		for i = 1,#hVar.MAP_BAG_EX do
--			if LuaGetPlayerMapAchi(hVar.MAP_BAG_EX[i],hVar.ACHIEVEMENT_TYPE.LEVEL)  == 1 then
--				local itemID = hVar.MAP_INFO[hVar.MAP_BAG_EX[i]].itemID
--				if type(itemID) == "number" then
--					local mapName = hVar.tab_item[itemID].bagName
--					if LuaCheckPlayerDLCMap(mapName) ~=1 then
--						SendCmdFunc["check_DLC"](0,0,itemID)
--					end
--				end
--			end
--		end
--	end
--end
--zhenkira new 检测DLC是否可用的脚本接口，只针对于，存档数据中有过关的记录，但是DLC中没有相应的数据的用户
LuaCheckDLCFunc = function()
	if Save_PlayerData and Save_PlayerData.dlc then
		
		--遍历dlc购买配置
		for n = 1, #hVar.NET_SHOP_MAP_DLC, 1 do
			--获取dlcshopitemid
			local dlcShopId = hVar.NET_SHOP_MAP_DLC[n]
			--如果shopitemid合法
			if dlcShopId and hVar.tab_shopitem[dlcShopId] and hVar.tab_shopitem[dlcShopId].itemID then
				--shopitem对应的itemid
				local itemID = hVar.tab_shopitem[dlcShopId].itemID
				--如果itemid合法
				if itemID and hVar.tab_item[itemID] and hVar.tab_item[itemID].bagName then
					--dlc地图包名
					local dlcMap = hVar.tab_item[itemID].bagName
					local tabM = hVar.MAP_INFO[dlcMap]
					local flag = false
					
					--dlc地图包如果合法，查询地图包地图的入口 如果是通关的，那么就查询是否有DLC，如果没有DLC 则发送查询
					if tabM and tabM.dlc and tabM.childMap and tabM.childMap[1] then
						for i = 1, #tabM.childMap, 1 do
							if (LuaGetPlayerMapAchi(tabM.childMap[i], hVar.ACHIEVEMENT_TYPE.LEVEL) == 1) then
								flag = true
								break
							end
						end
					end
					
					--geyachao: 如果吕布传第一关没打，再检测一次，第一关的前置地图是否打过
					if (not flag) then
						if tabM and tabM.dlc and tabM.childMap and tabM.childMap[1] then
							local tabMChild = hVar.MAP_INFO[tabM.childMap[1]]
							if tabMChild then
								local unLock = tabMChild.unLock
								if unLock and (type(unLock) == "table") then
									local prefixMap = unLock[1]
									if prefixMap then --第一关的前置地图
										--print("prefixMap", prefixMap)
										if (LuaGetPlayerMapAchi(prefixMap, hVar.ACHIEVEMENT_TYPE.LEVEL) == 1) then
											flag = true
										end
									end
								end
							end
						end
					end
					
					if flag then
						if (LuaCheckPlayerDLCMap(tabM.childMap) ~= 1) then
							SendCmdFunc["check_DLC"](0, 0, itemID)
						end
					end
				end
			end
		end
	end
end

--检测一个道具是2全才还是3全才
local _checkItemHole_32 = function(item)
	local tempN = 0
	for i = 2,#item[3] do
		if item[3][i] == 32 then
			tempN = tempN + 1
		end
	end
	return tempN
end

--返回玩家数据表中 2孔全才和3孔全才的个数 格式：2:n;3:n; 
LuaGetPlayerItemExInfo = function()
	local Hole_3,Hole_2 = 0,0
	if Save_PlayerData then
		--检测仓库
		if Save_PlayerData.bag then
			for j = 1,#Save_PlayerData.bag do
				local item = Save_PlayerData.bag[j]
				if type(item) == "table" and type(item[3]) == "table" then
					if _checkItemHole_32(item) == 2 then
						Hole_2 = Hole_2 + 1
					elseif _checkItemHole_32(item) == 3 then
						Hole_3 = Hole_3 + 1
					end
				end
			end
		end
		--检测英雄令
		if type(Save_PlayerData.herocard) == "table" then
			for j = 1,#Save_PlayerData.herocard do
				local hero = Save_PlayerData.herocard[j]
				--装备栏
				if hero and type(hero) == "table" and hero.equipment and type(hero.equipment) == "table" then
					for k = 1,#hero.equipment do
						local item = hero.equipment[k]
						if type(item) == "table" and type(item[3]) == "table" then
							if _checkItemHole_32(item) == 2 then
								Hole_2 = Hole_2 + 1
							elseif _checkItemHole_32(item) == 3 then
								Hole_3 = Hole_3 + 1
							end
						end
					end
				end
				--道具栏
				if hero and type(hero) == "table" and hero.item and type(hero.item) == "table" then
					for k = 1,#hero.item do
						local item = hero.item[k]
						--针对限时道具红装祭坛出来的装备进行清理
						if type(item) == "table" and type(item[3]) == "table" then
							if _checkItemHole_32(item) == 2 then
								Hole_2 = Hole_2 + 1
							elseif _checkItemHole_32(item) == 3 then
								Hole_3 = Hole_3 + 1
							end
						end
					end
				end
			end
		end
	end
	return "2:"..Hole_2..";3:"..Hole_3..";"
end

--计算英雄战斗力
LuaCaculatePlayerHeroPower = function()
	--战斗力=所有你拥有的英雄战斗力之和
	--单个英雄战斗力=（英雄等级*100+英雄技能等级*30+英雄装备价值）
	local power = 0
	if Save_PlayerData and Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
		for j = 1,#Save_PlayerData.herocard do
			local hero = Save_PlayerData.herocard[j]
			if hero and type(hero) == "table" then
				--英雄等级
				local lv = hero.attr.level or 1
				power = power + lv * 100
				
				--英雄技能
				local talent = hero.talent
				if talent then
					for i = 1, #talent do
						local skillObj = talent[i]
						if skillObj and skillObj.id and skillObj.id > 0 then
							local sLv = skillObj.lv or 0
							power = power + sLv * 30
						end
					end
				end

				--英雄战术技能
				local tactic = hero.tactic
				if tactic then
					for i = 1, #tactic do
						local skillObj = tactic[i]
						if skillObj and skillObj.id and skillObj.id > 0 then
							local sLv = skillObj.lv or 0
							power = power + sLv * 30
						end
					end
				end

				--英雄装备
				local equipment = hero.equipment
				if hero.equipment and type(hero.equipment) == "table" then
					for k = 1,#hero.equipment do
						local oItem = hero.equipment[k]
						if type(oItem) == "table" then
							power = power + hApi.CaculateItemValue(oItem)
						end
					end
				end
			end
		end
	end

	return power
end

--计算战术等级榜
LuaCaculatePlayerTacticPower = function()
	
	--战术等级榜 = 所有塔的碎片总和*3+战术卡碎片总和
	local power = 0

	local tTactics = LuaGetPlayerSkillBook()
	--不存在战术技能卡，返回不能升级
	if (not tTactics) then
		return power
	end
	
	--遍历所有的战术技能卡
	for i = 1, #tTactics, 1 do
		if (type(tTactics[i]) == "table") then
			local id, lv, num = unpack(tTactics[i])
			--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
			
			--存在表项
			if hVar.tab_tactics[id] then
				local type = hVar.tab_tactics[id].type --战术技能卡类型
				if (type == hVar.TACTICS_TYPE.OTHER) or (type == hVar.TACTICS_TYPE.TOWER) or (type == hVar.TACTICS_TYPE.SPECIAL) then --只处理塔类战术技能卡、一般战术技能卡、特殊塔
					--升级战术技能卡需要的碎片数量
					local tacticLv = lv --战术技能卡的等级
					local nowDebris = num --当前的碎片数量
					
					local toDebris = 0
					local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
					if tacticLvUpInfo then
						toDebris = tacticLvUpInfo.toDebris or 0
					end
					
					local multiple = 1
					if (type == hVar.TACTICS_TYPE.TOWER) then
						multiple = 3
					elseif (type == hVar.TACTICS_TYPE.SPECIAL) then
						multiple = 6
					end
					power = power + (nowDebris + toDebris) * multiple
					
				end
			end
		end
	end

	return power
end

--计算富豪榜
LuaCaculatePlayerWealth = function()
	
	--我给你个公式。把所有资产折算成金币。然后加上当前剩余金币和积分。算一个总金币价值
	--英雄=300+等级*10
	--道具=基础价值/2+附加价值*2
	--战术卡每个碎片=2
	--塔每个碎片=5
	--积分200=1
	--所有加起来等于财富值
	--金币1比1
	
	--财富值 = 当前金币 + (当前积分/200) + (300 + 英雄等级 * 100) * 英雄数量 + (基础价值 / 2 + 附加价值 * 2) * 道具数量 + (战术卡碎片 * 2) * 战术卡数量 + (塔碎片 * 5) * 塔数量
	--单个英雄战斗力=（英雄等级*100+英雄技能等级*30+英雄装备价值）
	local power = hVar.ROLE_PLAYER_GOLD + math.ceil(LuaGetPlayerScore() / 200)
	
	if Save_PlayerData and Save_PlayerData.herocard and type(Save_PlayerData.herocard) == "table" then
		--英雄价值转金币
		for j = 1,#Save_PlayerData.herocard do
			local hero = Save_PlayerData.herocard[j]
			if hero and type(hero) == "table" then
				--英雄等级
				local lv = hero.attr.level or 1
				power = power + 300 + lv * 100

				--英雄装备
				local equipment = hero.equipment
				if hero.equipment and type(hero.equipment) == "table" then
					for k = 1,#hero.equipment do
						local oItem = hero.equipment[k]
						if type(oItem) == "table" then
							power = power + hApi.CaculateItemValueToGold(oItem)
						end
					end
				end
			end
		end

		--背包道具价值转金币
		for i = 1,#Save_PlayerData.bag do
			local oItem = Save_PlayerData.bag[i]
			if oItem and type(oItem) == "table" then
				power = power + hApi.CaculateItemValueToGold(oItem)
			end
		end
		
		
		--战术卡价值转金币
		local tTactics = LuaGetPlayerSkillBook()
		--不存在战术技能卡，返回不能升级
		if (not tTactics) then
			return power
		end
		
		--遍历所有的战术技能卡
		for i = 1, #tTactics, 1 do
			if (type(tTactics[i]) == "table") then
				local id, lv, num = unpack(tTactics[i])
				--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
				
				--存在表项
				if hVar.tab_tactics[id] then
					local type = hVar.tab_tactics[id].type --战术技能卡类型
					if (type == hVar.TACTICS_TYPE.OTHER) or (type == hVar.TACTICS_TYPE.TOWER) or (type == hVar.TACTICS_TYPE.SPECIAL) then --只处理塔类战术技能卡、一般战术技能卡、特殊战术技能卡
						--升级战术技能卡需要的碎片数量
						local tacticLv = lv --战术技能卡的等级
						local nowDebris = num --当前的碎片数量
						
						local toDebris = 0
						local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
						if tacticLvUpInfo then
							toDebris = tacticLvUpInfo.toDebris or 0
						end
						
						local multiple = 2
						if (type == hVar.TACTICS_TYPE.TOWER) then --塔
							multiple = 5
						elseif (type == hVar.TACTICS_TYPE.SPECIAL) then --特殊塔
							multiple = 10
						end
						power = power + (nowDebris + toDebris) * multiple
						
					end
				end
			end
		end
	end

	return power
end

function hApi.SeeYou()
	local _w,_h = 700,480
	local _frm  = hUI.frame:new({
	x = hVar.SCREEN.w/2 - _w/2,
	y = hVar.SCREEN.h/2 + _h/2,
	w = _w,
	h = _h,
	dragable = 2,
	show = 0,
	})

	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--title
	_childUI["title"] = hUI.label:new({
	parent = _parent,
	size = 34,
	text = "Data Error",
	align = "MC",
	border = 1,
	x = _w/2,
	y = -30,
	})

	--顶部分界线
	_childUI["apartline_back"] = hUI.image:new({
	parent = _parent,
	model = "UI:panel_part_09",
	x = _w/2,
	y = -60,
	w = _w,
	h = 8,
	})


	--玩家表信息
	_childUI["playerList_infoText"] = hUI.label:new({
	parent = _parent,
	size = 26,
	text = "Save_playerList :",
	align = "LT",
	border = 1,
	x = 30,
	y = -76,
	width = _w - 40,
	RGB = {0,255,0},
	})

	if type(Save_playerList) == "table" and 
	type(Save_playerList[1]) == "table" and 
	type(Save_playerList[2]) == "table" and 
	type(Save_playerList[3]) == "table" then
	for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
		local name = Save_playerList[i].name
		if string.sub(name,3,6) == "TEXT" then
			name = "Null"
		end
		--name
		_childUI["playerList_infoText_name_"..i] = hUI.label:new({
			parent = _parent,
			size = 24,
			text = "Name "..i.." :  "..tostring(name),
			align = "LT",
			border = 1,
			x = 50,
			y = -110 - (i-1) * 30,
			width = _w - 40,
		})
		--rid
		_childUI["playerList_infoText_rid_"..i] = hUI.label:new({
			parent = _parent,
			size = 24,
			text = "RID :  "..tostring(Save_playerList[i].roleID),
			align = "LT",
			border = 1,
			x = 270,
			y = -110 - (i-1) * 30,
			width = _w - 40,
		})
		--map
		local mapTitle = Save_playerList[i].LocalSaveInfo
		if type(mapTitle) == "table" then 
			local mapN,mapD = hVar.MAP_INFO[mapTitle[1]].uniqueID,mapTitle[2]
			_childUI["playerList_infoText_map_"..i] = hUI.label:new({
				parent = _parent,
				size = 24,
				text = "MAP :  Uid-"..tostring(mapN).." Day-"..tostring(mapD),
				align = "LT",
				border = 1,
				x = 470,
				y = -110 - (i-1) * 30,
				width = _w - 40,
			})
		end
	end
	else
	_childUI["playerList_infoText"]:setText("Save_playerList: Null")
	end

	--玩家数据信息
	_childUI["playerDate_infoText"] = hUI.label:new({
	parent = _parent,
	--font = hVar.FONTC,
	size = 26,
	text = "Save_PlayerData : ",
	align = "LT",
	border = 1,
	x = 30,
	y = -210,
	width = _w - 40,
	RGB = {0,255,0},
	})

	if type(Save_PlayerData) == "table" then
	--当前主公
	_childUI["playerDate_curPlayerName"] = hUI.label:new({
		parent = _parent,
		size = 24,
		text = "CM: "..tostring(g_curPlayerName),
		align = "LT",
		border = 1,
		x = 50,
		y = -250,
		width = _w - 40,
	})
	--英雄卡牌数量
	_childUI["playerDate_curPlayerName"] = hUI.label:new({
		parent = _parent,
		size = 24,
		text = "HeroNum: "..tostring(#Save_PlayerData.herocard),
		align = "LT",
		border = 1,
		x = 350,
		y = -250,
		width = _w - 40,
	})
	else
	_childUI["playerDate_infoText"]:setText("Save_PlayerData: Null")
	end

	--data文件检测
	--玩家数据信息
	_childUI["playerDate_file_error"] = hUI.label:new({
	parent = _parent,
	--font = hVar.FONTC,
	size = 26,
	text = "File :",
	align = "LT",
	border = 1,
	x = 30,
	y = -290,
	width = _w - 40,
	RGB = {0,255,0},
	})
	--3个数据表检测
	for i = 1, hVar.OPTIONS.MAX_PLAYER_NUM do
	_childUI["playerDate_file_"..i] = hUI.label:new({
		parent = _parent,
		size = 24,
		text = "file "..i,
		align = "LT",
		border = 1,
		x = 50,
		y = -330 - (i-1) * 30,
		width = _w - 40,
	})
	local fileName = Save_playerList[i].name
	local model = ""
	if hApi.FileExists(g_localfilepath..fileName..hVar.SAVE_DATA_PATH.PLAYER_DATA,"full") then
		LuaLoadSavedGameData(g_localfilepath..fileName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
		if type(Save_PlayerData) == "table" then
			model = "UI:finish"
		else
			model = "UI:close"
		end
	else
		model = "UI:close"
	end

	_childUI["playerDate_file_"..i] = hUI.image:new({
		parent = _parent,
		model = model,
		x = 140,
		y = -340 - (i-1) * 30,
		w = 40,
		h = 40,
	})
	end

	--最后的提示
	_childUI["woyebuzhidaoshuoshenme_"] = hUI.label:new({
	parent = _parent,
	size = 28,
	text = hVar.tab_string["__TEXT_DateErrorInfo"],
	align = "LT",
	border = 1,
	x = 300,
	y = -340,
	width = _w - 40,
	})

	--确定按钮
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_ExitGame"],
		x = _w/2,
		y = 30 -_h,
		w = 200,
		
		scaleT = 0.9,
		code = function(self)
			--xlExit()
			_frm:del()
		end,
	})
	_frm:show(1)
	_frm:active()

end

--设置玩家礼包信息
LuaSetPlayerGiftInfo = function(nIndex,nState)
	if Save_PlayerData then
		if Save_PlayerData.giftInfo == nil then
			Save_PlayerData.giftInfo = {}
		end
		Save_PlayerData.giftInfo[nIndex] = nState
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--获取玩家礼包信息
LuaGetPlayerGiftInfo = function(nIndex)
	local nState = 0
	if Save_PlayerData and Save_PlayerData.giftInfo then
		nState = Save_PlayerData.giftInfo[nIndex] or 0
	end
	return nState
end

LuaSetPlayerStartNewGame = function(playerName,state)
	local playlist = LuaGetPlayerByName(playerName)
	if playlist  then
		playlist.StartNewGame = state
	end
end

LuaGetPlayerStartNewGame = function(playerName)
	local state = 0
	local playlist = LuaGetPlayerByName(playerName)
	if playlist and type(playlist.StartNewGame) == "number" then
		state = playlist.StartNewGame
	end
	print("LuaGetPlayerStartNewGame",state)
	return state
end



------------------------------------------------------------------------------------------------------
--获得宝物表
LuaGetTreasureBook = function()
	if Save_PlayerData then
		local treasurebook = nil
		if Save_PlayerData.treasurebook then
			treasurebook = Save_PlayerData.treasurebook
		else
			treasurebook = {}
			Save_PlayerData.treasurebook = treasurebook
		end
		
		return treasurebook
	end
end

--设置宝物表
LuaSetTreasureBook = function(id, lv, num, notSaveFlag)
	if Save_PlayerData then
		local treasurebook = nil
		if Save_PlayerData.treasurebook then
			treasurebook = Save_PlayerData.treasurebook
		else
			treasurebook = {}
			Save_PlayerData.treasurebook = treasurebook
		end
		
		--查找是否已存在
		local bFind = false
		for i = 1, #treasurebook, 1 do
			if (treasurebook[i][1] == id) then --找到了
				bFind = true
				
				treasurebook[i][2] = lv
				treasurebook[i][3] = num
				break
			end
		end
		
		--插入末尾
		if (not bFind) then
			treasurebook[#treasurebook+1] = {id, lv, num,}
		end
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--清空宝物表
LuaClearTreasureBook = function(notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.treasurebook = {}
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

------------------------------------------------------------------------------------------------------
--获得宝物全部属性位值列表
LuaGetTreasureAttrList = function()
	local attr = {}
	
	if Save_PlayerData then
		if Save_PlayerData.treasureattr then
			attr = Save_PlayerData.treasureattr or {}
		end
		
		return attr
	end
end

--获得宝物属性位值
LuaGetTreasureAttr = function(attrType)
	local attrValue = 0
	
	if Save_PlayerData then
		if Save_PlayerData.treasureattr then
			attrValue = Save_PlayerData.treasureattr[attrType] or 0
		end
		
		return attrValue
	end
end

--设置宝物属性位值
LuaSetTreasureAttr = function(attrType, attrValue, notSaveFlag)
	if Save_PlayerData then
		local treasureattr = nil
		if Save_PlayerData.treasureattr then
			treasureattr = Save_PlayerData.treasureattr
		else
			treasureattr = {}
			Save_PlayerData.treasureattr = treasureattr
		end
		
		Save_PlayerData.treasureattr[attrType] = attrValue
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--清空宝物属性位值表
LuaClearTreasureAttr = function(notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.treasureattr = {}
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

------------------------------------------------------------------------------------------------------
--获得天赋树表
LuaGetTalentTree = function()
	if Save_PlayerData then
		local talenttree = nil
		if Save_PlayerData.talenttree then
			talenttree = Save_PlayerData.talenttree
		else
			talenttree = {}
			Save_PlayerData.talenttree = talenttree
		end
		
		return talenttree
	end
end

--设置天赋树表
LuaSetTalentTree = function(id, lv, notSaveFlag)
	if Save_PlayerData then
		local talenttree = nil
		if Save_PlayerData.talenttree then
			talenttree = Save_PlayerData.talenttree
		else
			talenttree = {}
			Save_PlayerData.talenttree = talenttree
		end
		
		--查找是否已存在
		local bFind = false
		for i = 1, #talenttree, 1 do
			if (talenttree[i][1] == id) then --找到了
				bFind = true
				
				talenttree[i][2] = lv
				break
			end
		end
		
		--插入末尾
		if (not bFind) then
			talenttree[#talenttree+1] = {id, lv,}
		end
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

--清空天赋树表
LuaClearTalentTree = function(notSaveFlag)
	if Save_PlayerData then
		Save_PlayerData.talenttree = {}
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

LuaGetChariotTalentTab = function(tankid)
	local showtab = {}
	local tabU = hVar.tab_unit[tankid]
	if tabU then
		local tab = tabU.talent_tree
		if tabU.showTalent == nil then
			tabU.showTalent = {}
			local tempType = {}
			for i = 1,#tab do
				local talentid = tab[i]
				local tabCT = hVar.tab_chariottalent[talentid] or {}
				if tabCT then
					local talenttype = tabCT.talenttype
					if talenttype then
						local index = 0
						if tempType[talenttype] == nil then
							tempType.num = 1 + (tempType.num or 0)
							tempType[talenttype] = tempType.num
						end
						index = tempType[talenttype]
						if tabU.showTalent[index] == nil then
							tabU.showTalent[index] = {
								talenttype = talenttype,
								talentid = {},
							}
						end
						tabU.showTalent[index].talentid[#tabU.showTalent[index].talentid+1] = talentid
					end
				else
					print("talentid",talentid)
				end
			end
		end
		showtab = tabU.showTalent
		table_print(tabU.showTalent)
	end
	return showtab
end

LuaGetHaveBeginnerAward = function()
	local state = 0
	if Save_PlayerLog and Save_PlayerLog.haveBeginnerAward then
		state = Save_PlayerLog.haveBeginnerAward or 0
	end
	return state
end

LuaSetHaveBeginnerAward = function(state)
	if Save_PlayerLog then
		Save_PlayerLog.haveBeginnerAward = state
	end
end

--获取对象名字总接口 1.id号 2.类型(1 unit 2 item) 3.强制使用tab_string[id]
LuaGetObjectName = function(nId,nType,usestring)
	nType = nType or 1
	--print("LuaGetObjectName",nId,nType,usestring)
	local sname = ""
	if nType == 1 then
		local tabU = hVar.tab_unit[nId]
		if tabU and tabU.txt then
			sname = hVar.tab_string[tabU.txt]
		end
		if (sname == "" or usestring == 1) and hVar.tab_stringU[nId] then
			sname = hVar.tab_stringU[nId][1]
		end
		if sname == "" then
			sname = "unknown_unit_"..nId
		end
	elseif nType == 2 then
		local tabI = hVar.tab_item[nId]
		if tabI and tabI.txt then
			sname = hVar.tab_string[tabI.txt]
		end
		if (sname == "" or usestring == 1) and hVar.tab_stringI[nId] then
			sname = hVar.tab_stringI[nId][1]
		end
		if sname == "" then
			sname = "unknown_item_"..nId
		end
	end
	--print("sname",sname)
	return sname

end

---------------------------------------------------------------------------------------------------
--读取新玩家14日签到活动完成进度表
LuaGetActivitySignInList = function(playerName)
	local activity_signin_list = {}
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		activity_signin_list = player.activity_signin_list or {} --新玩家14日签到活动完成进度
	end
	
	return activity_signin_list
end

--设置新玩家14日签到活动已完成的进度
LuaSetActivitySignInProgress = function(playerName, progress, progressMax)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local activity_signin_list = player.activity_signin_list or {} --新玩家14日签到活动完成进度
		
		activity_signin_list.progress = progress
		activity_signin_list.progressMax = progressMax
		
		--本地存档
		player.activity_signin_list = activity_signin_list --新玩家14日签到活动完成进度
		LuaSavePlayerList()
	end
end

--设置新玩家14日签到活动的今日可签到记录
LuaSetActivitySignInRecord = function(playerName, signInDay)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local activity_signin_list = player.activity_signin_list or {} --新玩家14日签到活动完成进度
		
		activity_signin_list.signInDay = signInDay
		
		--本地存档
		player.activity_signin_list = activity_signin_list --新玩家14日签到活动完成进度
		LuaSavePlayerList()
	end
end

--设置新玩家14日签到活动的特惠礼包购买记录表
LuaSetActivitySignInGiftBuy = function(playerName, tBuy)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local activity_signin_list = player.activity_signin_list or {} --新玩家14日签到活动完成进度
		
		activity_signin_list.giftBuyList = tBuy
		
		--本地存档
		player.activity_signin_list = activity_signin_list --新玩家14日签到活动完成进度
		LuaSavePlayerList()
	end
end

--清空新玩家14日签到活动完成进度
LuaClearActivitySignInList = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.activity_signin_list = {} --新玩家14日签到活动完成进度
		
		--本地存档
		LuaSavePlayerList()
	end
end

---------------------------------------------------------------------------------------------------
--读取玩家已处理的军团邀请函id列表
LuaGetInviteGroupIdList = function(playerName)
	local chat_invite_group_id_list = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_invite_group_id_list = player.chat_invite_group_id_list or "" --已处理的军团邀请函id列表
	end
	
	--转为一维数组表
	local t = hApi.String2Array(chat_invite_group_id_list)
	return t
end

--添加玩家已处理的军团邀请函id
LuaAddInviteGroupId = function(playerName, id)
	local chat_invite_group_id_list = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_invite_group_id_list = player.chat_invite_group_id_list or "" --已处理的军团邀请函id列表
	
		--转为一维数组表
		local t = hApi.String2Array(chat_invite_group_id_list)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的aid是否已存在
		for i = 1, #t, 1 do
			if (t[i] == id) then
				--直接返回
				return
			end
		end
		
		--插入一条数据
		table.insert(t, id)
		
		--转化为字符串
		chat_invite_group_id_list = hApi.Array2String(t)
		player.chat_invite_group_id_list = chat_invite_group_id_list --已处理的军团邀请函id列表
		
		--本地存档
		LuaSavePlayerList()
	end
end

--移除玩家已处理的军团邀请函id
LuaRemoveInviteGroupId = function(playerName, id)
	local chat_invite_group_id_list = ""
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_invite_group_id_list = player.chat_invite_group_id_list or "" --已处理的军团邀请函id列表
	
		--转为一维数组表
		local t = hApi.String2Array(chat_invite_group_id_list)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的aid是否已存在
		for i = 1, #t, 1 do
			if (t[i] == id) then --找到了
				table.remove(t, i)
				break
			end
		end
		
		--转化为字符串
		chat_invite_group_id_list = hApi.Array2String(t)
		player.chat_invite_group_id_list = chat_invite_group_id_list --已处理的军团邀请函id列表
		
		--本地存档
		LuaSavePlayerList()
	end
end

--清空玩家已处理的军团邀请函id列表
LuaClearInviteGroupIdList = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.chat_invite_group_id_list = "" --已处理的军团邀请函id列表
		
		--本地存档
		LuaSavePlayerList()
	end
end

---------------------------------------------------------------------------------------------------
--读取玩家的最近聊天信息表（防刷屏）
LuaGetRecentChatList = function(playerName)
	local chat_msg_recent_list = nil
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_msg_recent_list = player.chat_msg_recent_list or {} --玩家的最近聊天信息表（防刷屏）
	end
	
	return chat_msg_recent_list
end

--添加一条玩家最近聊天信息表（防刷屏）
LuaAddtRecentChatMsg = function(playerName, chatType, message)
	local chat_msg_recent_list = nil
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_msg_recent_list = player.chat_msg_recent_list or {} --玩家的最近聊天信息表（防刷屏）
		
		if (chat_msg_recent_list[chatType] == nil) then
			chat_msg_recent_list[chatType] = {}
		end
		
		--获得当前时间(北京时区)
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hosttime = hosttime - delteZone * 3600 --GMT+8时区
		
		--检测原先的数据是否有过期
		for i = #chat_msg_recent_list[chatType], 1, -1 do
			local time_i = chat_msg_recent_list[chatType][i].time
			local deltatime = clienttime - time_i
			if (deltatime > hVar.CHAT_ANTI_FLOODSCREEN_TIME) then
				table.remove(chat_msg_recent_list[chatType], i)
			end
		end
		
		--插入一条数据
		table.insert(chat_msg_recent_list[chatType], {message = message, time = hosttime,})
		
		player.chat_msg_recent_list = chat_msg_recent_list --玩家的最近聊天信息表（防刷屏）
		
		--本地存档
		LuaSavePlayerList()
	end
end

--清空玩家最近聊天信息表（防刷屏）
LuaClearRecentChatMsg = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.chat_msg_recent_list = {} --玩家的最近聊天信息表（防刷屏）
		
		--本地存档
		LuaSavePlayerList()
	end
end

--检测发送的聊天内容是否构成刷屏
LuaCheckChatMessageIsFloodScreen = function(playerName, chatType, message)
	local ret = 0
	
	local chat_msg_recent_list = nil
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_msg_recent_list = player.chat_msg_recent_list or {} --玩家的最近聊天信息表（防刷屏）
		
		if chat_msg_recent_list[chatType]then
			--重复的次数
			local count = 0
			
			--获得当前时间(北京时区)
			local clienttime = os.time()
			local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			hosttime = hosttime - delteZone * 3600 --GMT+8时区
			
			--检测10分钟内重复聊天次数
			for i = 1, #chat_msg_recent_list[chatType], 1 do
				local message_i = chat_msg_recent_list[chatType][i].message
				local time_i = chat_msg_recent_list[chatType][i].time
				local deltatime = clienttime - time_i
				if (deltatime <= hVar.CHAT_ANTI_FLOODSCREEN_TIME) then
					if (message_i == message) then
						count = count + 1
					end
				end
			end
			
			if (count >= hVar.CHAT_ANTI_FLOODSCREEN_COUNT) then
				ret = 1
			end
		end
	end
	
	return ret
end

--检测发送的聊天速度是否太快
LuaCheckChatMessageIsTooFast = function(playerName, chatType, message)
	local ret = 0
	
	local chat_msg_recent_list = nil
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		chat_msg_recent_list = player.chat_msg_recent_list or {} --玩家的最近聊天信息表（防刷屏）
		
		if chat_msg_recent_list[chatType]then
			--1分钟内聊天的次数
			local count = 0
			
			--获得当前时间(北京时区)
			local clienttime = os.time()
			local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			hosttime = hosttime - delteZone * 3600 --GMT+8时区
			
			--检测1分钟内的聊天次数
			local FAST_TIME = 60
			for i = 1, #chat_msg_recent_list[chatType], 1 do
				local message_i = chat_msg_recent_list[chatType][i].message
				local time_i = chat_msg_recent_list[chatType][i].time
				local deltatime = clienttime - time_i
				if (deltatime <= FAST_TIME) then
					if (message ~= "") then
						count = count + 1
					end
				end
			end
			
			if (count >= hVar.CHAT_ONEMINUTE_MAXNUM) then
				ret = 1
			end
		end
	end
	
	return ret
end

---------------------------------------------------------------------------------------------------
--获得世界聊天的新收到的消息id
LuaGetChatWorldReceiveMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local world = chat_notice_log.world --世界聊天频道
			if world then
				--新收到的消息id
				local receive_msgid = world.receive_msgid or 0
				return receive_msgid
			end
		end
	end
	
	return 0
end

--设置世界聊天的新收到的消息id
LuaSetChatWorldReceiveMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local world = chat_notice_log.world or {} --世界聊天频道
		
		--设置新收到的消息id
		if (world.receive_msgid ~= msgId) then --不重复设置
			world.receive_msgid = msgId
			
			--本地存档
			chat_notice_log.world = world
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

--获得世界聊天的已阅读的消息id
LuaGetChatWorldReadMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local world = chat_notice_log.world --世界聊天频道
			if world then
				--已阅读的消息id
				local read_msgid = world.read_msgid or 0
				return read_msgid
			end
		end
	end
	
	return 0
end

--设置世界聊天的已阅读的消息id
LuaSetChatWorldReadMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local world = chat_notice_log.world or {} --世界聊天频道
		
		--设置已阅读的消息id
		if (world.read_msgid ~= msgId) then --不重复设置
			world.read_msgid = msgId
			
			--本地存档
			chat_notice_log.world = world
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

-------------------------------------------------------
--获得邀请聊天的新收到的消息id
LuaGetChatInviteReceiveMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local invite = chat_notice_log.invite --邀请聊天频道
			if invite then
				--新收到的消息id
				local receive_msgid = invite.receive_msgid or 0
				return receive_msgid
			end
		end
	end
	
	return 0
end

--设置邀请聊天的新收到的消息id
LuaSetChatInviteReceiveMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local invite = chat_notice_log.invite or {} --邀请聊天频道
		
		--设置新收到的消息id
		if (invite.receive_msgid ~= msgId) then --不重复设置
			invite.receive_msgid = msgId
			
			--本地存档
			chat_notice_log.invite = invite
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

-------------------------------------------------------
--获得组队副本邀请未查看的消息id
LuaGetBattleInviteMsgIdList = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local battle = chat_notice_log.battle or "" --组队副本邀请聊天频道
		
		--转为一维数组表
		local t = hApi.String2Array(battle)
		return t
	end
end

--新增组队副本邀请未查看的消息id
LuaAddBattleInviteMsgId = function(playerName, msgId, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local battle = chat_notice_log.battle or "" --组队副本邀请聊天频道
		
		--转为一维数组表
		local t = hApi.String2Array(battle)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的msgId是否已存在
		for i = 1, #t, 1 do
			if (t[i] == msgId) or (t[i] == -msgId) then
				--直接返回
				return
			end
		end
		
		--插入一条数据
		table.insert(t, msgId)
		
		--转化为字符串
		battle = hApi.Array2String(t)
		
		--本地存档
		chat_notice_log.battle = battle
		player.chat_notice_log = chat_notice_log --聊天的提示记录
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--标记组队副本邀请消息id已读
LuaSetBattleInviteMsgIdRead = function(playerName, msgId, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local battle = chat_notice_log.battle or "" --组队副本邀请聊天频道
		
		--转为一维数组表
		local t = hApi.String2Array(battle)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的msgId是否已存在
		local bFind = false
		for i = 1, #t, 1 do
			if (t[i] == -msgId) then --已经标记过已读了
				--直接返回
				return
			end
			
			if (t[i] == msgId) then --找到了
				bFind = true
				t[i] = -msgId
				break
			end
		end
		
		if (not bFind) then
			--插入一条数据
			--已读
			table.insert(t, -msgId)
		end
		
		--转化为字符串
		battle = hApi.Array2String(t)
		
		--本地存档
		chat_notice_log.battle = battle
		player.chat_notice_log = chat_notice_log --聊天的提示记录
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--移除组队副本邀请未查看的消息id
LuaRemoveBattleInviteMsgId = function(playerName, msgId, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local battle = chat_notice_log.battle or "" --组队副本邀请聊天频道
		
		--转为一维数组表
		local t = hApi.String2Array(battle)
		
		--如果该表过长（大于60条，删除前30条）
		local mex_len = 60
		if (#t >= mex_len) then
			for i = 1, mex_len / 2, 1 do
				table.remove(t, 1)
			end
		end
		
		--检测本次的msgId是否已存在
		for i = 1, #t, 1 do
			if (t[i] == msgId) or (t[i] == -msgId) then --找到了
				table.remove(t, i)
				break
			end
		end
		
		--转化为字符串
		battle = hApi.Array2String(t)
		
		--本地存档
		chat_notice_log.battle = battle
		player.chat_notice_log = chat_notice_log --聊天的提示记录
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--移除组队副本邀请全部未查看的消息id
LuaRemoveBattleInviteMsgAll = function(playerName, notSaveFlag)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		--local battle = chat_notice_log.battle or "" --组队副本邀请聊天频道
		
		--本地存档
		chat_notice_log.battle = ""
		player.chat_notice_log = chat_notice_log --聊天的提示记录
		
		--存档
		if (not notSaveFlag) then
			LuaSavePlayerList()
		end
	end
end

--读取私聊好友列表
LuaGetChatPrivateFriendList = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local private = chat_notice_log.private --私聊频道
			if private then
				return private
			end
		end
	end
	
	return {}
end

--设置私聊好友列表
LuaSetChatPrivateFriendList = function(playerName, tFriendList)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local old_private = chat_notice_log.private or {} --上一次的私聊频道
		local private = {} --私聊频道
		
		--存储每一个私聊好友uid和私聊好友的最近一次消息id
		for i = 1, #tFriendList, 1 do
			local tFriend = tFriendList[i]
			local touid = tFriend.touid --好友uid
			local receive_msgid = tFriend.lastMsgId --最近一次私聊消息id
			local read_msgid = old_private[touid] and old_private[touid].read_msgid or 0 --已阅读的私聊消息id
			
			--存储此私聊好友的私聊提示信息
			private[touid] =
			{
				receive_msgid = receive_msgid,
				read_msgid = read_msgid,
			}
		end
		
		--本地存档
		chat_notice_log.private = private
		player.chat_notice_log = chat_notice_log --聊天的提示记录
		LuaSavePlayerList()
	end
end

--读取单个私聊好友的新收到消息id
LuaGetChatPrivateFriendReceiveMsgId = function(playerName, touid)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local private = chat_notice_log.private --私聊频道
			if private then
				if private[touid] then
					--私聊好友新收到消息id
					local receive_msgid = private[touid].receive_msgid or 0
					return receive_msgid
				end
			end
		end
	end
	
	return 0
end

--设置单个私聊好友新收到消息id
LuaSetChatPrivateFriendReceiveMsgId = function(playerName, touid, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local private = chat_notice_log.private or {} --上一次的私聊频道
		
		--存储私聊好友新收到消息id
		private[touid] = private[touid] or {}
		
		if (private[touid].receive_msgid ~= msgId) then --不重复设置
			private[touid].receive_msgid = msgId
			
			--本地存档
			chat_notice_log.private = private
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

--读取单个私聊好友的已阅读消息id
LuaGetChatPrivateFriendReadMsgId = function(playerName, touid)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local private = chat_notice_log.private --私聊频道
			if private then
				if private[touid] then
					--私聊好友已阅读的消息id
					local read_msgid = private[touid].read_msgid or 0
					return read_msgid
				end
			end
		end
	end
	
	return 0
end

--设置单个私聊好友的已阅读消息id
LuaSetChatPrivateFriendReadMsgId = function(playerName, touid, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local private = chat_notice_log.private or {} --上一次的私聊频道
		
		--存储每一个私聊好友uid和私聊好友的最近一次消息id
		private[touid] = private[touid] or {}
		
		if (private[touid].read_msgid ~= msgId) then --不重复设置
			private[touid].read_msgid = msgId
			
			--本地存档
			chat_notice_log.private = private
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

-------------------------------------------------------
--获得军团聊天的新收到的消息id
LuaGetChatGroupReceiveMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local group = chat_notice_log.group --军团聊天频道
			if group then
				--新收到的消息id
				local receive_msgid = group.receive_msgid or 0
				return receive_msgid
			end
		end
	end
	
	return 0
end

--设置军团聊天的新收到的消息id
LuaSetChatGroupReceiveMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local group = chat_notice_log.group or {} --军团聊天频道
		
		--设置新收到的消息id
		if (group.receive_msgid ~= msgId) then --不重复设置
			group.receive_msgid = msgId
			
			--本地存档
			chat_notice_log.group = group
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

--获得军团聊天的已阅读的消息id
LuaGetChatGroupReadMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local group = chat_notice_log.group --军团聊天频道
			if group then
				--已阅读的消息id
				local read_msgid = group.read_msgid or 0
				return read_msgid
			end
		end
	end
	
	return 0
end

--设置军团聊天的已阅读的消息id
LuaSetChatGroupReadMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local group = chat_notice_log.group or {} --军团聊天频道
		
		--设置已阅读的消息id
		if (group.read_msgid ~= msgId) then --不重复设置
			group.read_msgid = msgId
			
			--本地存档
			chat_notice_log.group = group
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

-------------------------------------------------------
--获得组队聊天的新收到的消息id
LuaGetChatCoupleReceiveMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local couple = chat_notice_log.couple --组队聊天频道
			if couple then
				--新收到的消息id
				local receive_msgid = couple.receive_msgid or 0
				return receive_msgid
			end
		end
	end
	
	return 0
end


--设置组队聊天的新收到的消息id
LuaSetChatCoupleReceiveMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local couple = chat_notice_log.couple or {} --组队聊天频道
		
		--设置新收到的消息id
		if (couple.receive_msgid ~= msgId) then --不重复设置
			couple.receive_msgid = msgId
			
			--本地存档
			chat_notice_log.couple = couple
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

--获得组队聊天的已阅读的消息id
LuaGetChatCoupleReadMsgId = function(playerName)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			local couple = chat_notice_log.couple --组队聊天频道
			if couple then
				--已阅读的消息id
				local read_msgid = couple.read_msgid or 0
				return read_msgid
			end
		end
	end
	
	return 0
end

--设置组队聊天的已阅读的消息id
LuaSetChatCoupleReadMsgId = function(playerName, msgId)
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log or {} --聊天的提示记录
		local couple = chat_notice_log.couple or {} --组队聊天频道
		
		--设置已阅读的消息id
		if (couple.read_msgid ~= msgId) then --不重复设置
			couple.read_msgid = msgId
			
			--本地存档
			chat_notice_log.couple = couple
			player.chat_notice_log = chat_notice_log --聊天的提示记录
			LuaSavePlayerList()
		end
	end
end

-------------------------------------------------------
--读取聊天是否需要提示
LuaGetChatWorldNoticeFlag = function(playerName)
	local noticeFlag = 0 --是否需要提示聊天叹号
	
	local player = LuaGetPlayerByName(playerName)
	--local player = LuaGetPlayerData()
	
	if player then
		local chat_notice_log = player.chat_notice_log --聊天的提示记录
		if chat_notice_log then
			--世界聊天频道
			local world = chat_notice_log.world
			if world then
				local receive_msgid = world.receive_msgid or 0 --世界聊天新收到的消息id
				local read_msgid = world.read_msgid or 0 --世界聊天已阅读的消息id
				--有新收到的消息未阅读，需要提示
				if (receive_msgid > read_msgid) then
					noticeFlag = 1
				end
			end
			
			--邀请聊天频道
			local invite = chat_notice_log.invite
			if invite then
				local receive_msgid = invite.receive_msgid or 0 --邀请聊天新收到的消息id
				if (receive_msgid > 0) then
					--邀请频道，只有有一条消息未处理，都需要叹号
					local bNoticeInvite = true
					local read_msgid_list = LuaGetInviteGroupIdList(g_curPlayerName)
					--print(receive_msgid, read_msgid_list)
					for r = 1, #read_msgid_list, 1 do
						if (read_msgid_list[r] == receive_msgid) then
							bNoticeInvite = false
						end
					end
					if bNoticeInvite then
						noticeFlag = 1
					end
				end
			end
			
			--组队副本邀请消息
			local battle = LuaGetBattleInviteMsgIdList(g_curPlayerName)
			if battle then
				for t = 1, #battle, 1 do
					local msgId = battle[t]
					--正消息是未读的
					if (msgId > 0) then
						noticeFlag = 1
					end
				end
			end
			
			--私聊频道
			local private = chat_notice_log.private
			if private then
				for touid, tt in pairs(private) do
					local receive_msgid = tt.receive_msgid or 0 --私聊新收到的消息id
					local read_msgid = tt.read_msgid or 0 --私聊已阅读的消息id
					--有新收到的消息未阅读，需要提示
					if (receive_msgid > read_msgid) then
						noticeFlag = 1
					end
				end
			end
			
			--军团聊天频道
			local group = chat_notice_log.group
			if group then
				local receive_msgid = group.receive_msgid or 0 --军团聊天新收到的消息id
				local read_msgid = group.read_msgid or 0 --军团聊天已阅读的消息id
				--有新收到的消息未阅读，需要提示
				if (receive_msgid > read_msgid) then
					noticeFlag = 1
				end
			end
			
			--组队聊天频道
			local couple = chat_notice_log.couple
			if couple then
				local receive_msgid = couple.receive_msgid or 0 --组队聊天新收到的消息id
				local read_msgid = couple.read_msgid or 0 --组队聊天已阅读的消息id
				--有新收到的消息未阅读，需要提示
				if (receive_msgid > read_msgid) then
					noticeFlag = 1
				end
			end
		end
	end
	
	return noticeFlag
end

--清空聊天提示标
LuaClearChatNotice = function(playerName)
	local playerInfo = LuaGetPlayerByName(playerName)
	if playerInfo then
		playerInfo.chat_notice_log = {} --聊天的提示记录
		
		--本地存档
		LuaSavePlayerList()
	end
end
-------------------------------------------------------
