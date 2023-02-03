---------------------------------------------
--UI模板
---------------------------------------------
g_ui_temlate = {}
local __TokenTemplate = {{},function()end}
hUI.GetUITemplate = function(key)
	if g_ui_temlate[key] then
		return g_ui_temlate[key]
	else
		return __TokenTemplate
	end
end
hUI.SetUITemplate = function(key,tTemplate)
	g_ui_temlate[key] = tTemplate
end
----------------------------------------------------------------
--战术卡片模板
----------------------------------------------------------------
do
	local __DarkRGB = {255,255,255,50}
	local __TC__Param = {
		ModelFunc = function(self,tData)
			local v = self.tactics
			return tData[1](v[1],v[2],tData[2],tData[3])
		end,
	}
	local __TC__UIFunc = {
		GetParam = function(tactics)
			local tParam = __TC__Param
			if tParam then
				tParam.IsEnd = 0
				tParam.tactics = tactics
				return tParam
			end
		end,
		GetIcon = function(nTacticsID,nTacticsLv,sIconMode)
			if nTacticsID==1 then
				if sIconMode=="bg" then
					return "UI:tactic_slot"
				else
					return 0
				end
			end
			local tabT = hVar.tab_tactics[nTacticsID]
			if tabT then
				if sIconMode=="bg" then
					if tabT.level then
						return hApi.GetTacticsCardGB(tabT.level,nTacticsLv)
					else
						return hApi.GetTacticsCardGB(10,1)
					end
				elseif sIconMode=="type" then
					return hApi.GetTacticsCardTypeIcon(nTacticsID,"model")
				else
					return tabT.icon
				end
			else
				return 0
			end
		end,
		GetName = function(nTacticsID,nTacticsLv)
			if nTacticsID==1 then
				return 0
			end
			local tabS = hVar.tab_stringT[nTacticsID]
			if tabS then
				return tabS[1]
			else
				return tostring(nTacticsID)
			end
		end,
		GetStar = function(nTacticsID,nTacticsLv,nCurStar,tDarkRGB)
			if nTacticsID==1 then
				return 0
			end
			local tabT = hVar.tab_tactics[nTacticsID]
			if tabT then
				local nMaxLv = tabT.level or 1
				if nCurStar>nMaxLv then
					return 0
				else
					local sModelName = "UI:HERO_STAR"
					local x,y,w,h = 0,0,12,12
					if nMaxLv==1 then
						x = 0
						y = -52
					elseif nMaxLv==3 then
						x = 16*(nCurStar-1)-16*1
						y = -52
					elseif nMaxLv==5 then
						x = 16*(nCurStar-1)-16*2
						y = -52
					elseif nMaxLv==10 then
						x = 16*math.mod(nCurStar-1,5)-16*2
						y = -48-12*math.floor((nCurStar-1)/5)
					end
					if nCurStar<=nTacticsLv then
						return "UI:HERO_STAR",x,y,w,h
					else
						return "UI:HERO_STAR",x,y,w,h,nil,__DarkRGB
					end
				end
			else
				return 0
			end
		end,
	}
	local __TC__UIList = {
		--背景槽
		{"image","_itemBG",{__TC__UIFunc.GetIcon,"bg"},{0,14,-1,-1}},
		--类型
		{"image","_itemType",{__TC__UIFunc.GetIcon,"type"},{-2,72,-1,-1}},
		--图标
		{"image","_itemIcon",{__TC__UIFunc.GetIcon,"icon"},{0,0,52,52}},
		--卡片名字
		{"label","_itemName",{__TC__UIFunc.GetName},{0,40,22,1,"MC",hVar.FONTC}},
		--星星1~10
		{"image","_star1",{__TC__UIFunc.GetStar,1},{0,14,-1,-1}},
		{"image","_star2",{__TC__UIFunc.GetStar,2},{0,14,-1,-1}},
		{"image","_star3",{__TC__UIFunc.GetStar,3},{0,14,-1,-1}},
		{"image","_star4",{__TC__UIFunc.GetStar,4},{0,14,-1,-1}},
		{"image","_star5",{__TC__UIFunc.GetStar,5},{0,14,-1,-1}},
		{"image","_star6",{__TC__UIFunc.GetStar,6},{0,14,-1,-1}},
		{"image","_star7",{__TC__UIFunc.GetStar,7},{0,14,-1,-1}},
		{"image","_star8",{__TC__UIFunc.GetStar,8},{0,14,-1,-1}},
		{"image","_star9",{__TC__UIFunc.GetStar,9},{0,14,-1,-1}},
		{"image","_star10",{__TC__UIFunc.GetStar,10},{0,14,-1,-1}},
	}
	hUI.SetUITemplate("tacticscard",{__TC__UIList,__TC__UIFunc})
end
----------------------------------------------------------------
--英雄卡片模板
----------------------------------------------------------------
do
	local __tParam = {
		IsEnd = 0,
		tCard = 0,
		ModelFunc = function(self,tData)
			local v = self.tCard
			return tData[1](v[2],v[3],v[4],tData[2],tData[3])
		end,
	}
	local __HC__UIFunc = {
		GetParam = function(tCard)
			__tParam.IsEnd = 0
			__tParam.tCard = tCard
			return __tParam
		end,
		GetStar = function(id,lv,ex,nCurStar)
			local x = 16*(nCurStar-1)-16*1
			local y = 0
			local w = 12
			local h = 12
			return "UI:HERO_STAR",x,y,w,h
		end,
		GetWeekStar = function(id,lv)
			if g_HeroWeekStar then
				for i = 1,#g_HeroWeekStar do
					if g_HeroWeekStar[i][1]==id then
						return "ICON:WeekStar"
					end
				end
			end
			return 0
		end,
		GetHeroPortrait = function(id,lv,ex)
			local tabU = hVar.tab_unit[id]
			if tabU and tabU.portrait then
				hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
				return tabU.portrait
			else
				return 0
			end
		end,
	}
	local __HC__UIList = {
		{"image","imgCardBG","UI:PANEL_CARD_01",{0,-22,140,180}},
		{"image","imgPortrait",{__HC__UIFunc.GetHeroPortrait},{0,0,128,128}},
		{"image","imgWeekStar",{__HC__UIFunc.GetWeekStar},{44,46,48,48,3}},
		{"label","labLv",{function(id,lv,ex)if lv<=0 then return "*" else return "lv"..tostring(lv) end end},{-36,-97,16,0,"MC","num"}},
		{"labelS","labName",{function(id,lv,ex)return hVar.tab_stringU[id][1]end},{18,-96,16,1,"MC",hVar.FONTC,{255,255,255}}},
		{"image","_star1",{__HC__UIFunc.GetStar,1},{-33,-75,-1,-1}},
		{"image","_star2",{__HC__UIFunc.GetStar,2},{-33,-75,-1,-1}},
		{"image","_star3",{__HC__UIFunc.GetStar,3},{-33,-75,-1,-1}},
		{"image","_star4",{__HC__UIFunc.GetStar,4},{-33,-75,-1,-1}},
		{"image","_star5",{__HC__UIFunc.GetStar,5},{-33,-75,-1,-1}},
	}
	hUI.SetUITemplate("herocard",{__HC__UIList,__HC__UIFunc})
end
----------------------------------------------------------------
--兵种卡片模板
----------------------------------------------------------------
do
	local __UC__UIFunc = {
		IsUnlocked = function(id,num,cid,lv,param)
			if type(num)=="number" and num>0 then
				return param[1]
			else
				return param[2]
			end
		end,
		GetNum = function(id,num,cid,lv,param)
			if type(num)=="number" and num>0 then
				return tostring(num)
			else
				return 0
			end
		end,
		GetCardBG = function(id,num,cid,lv,param)
			if lv<=0 then
				local tabA = hVar.tab_army[cid]
				if tabA and (tabA.unlock_coin or 0)>0 then
					return "ui/pvp/cardbg1.png"
				else
					return "ui/pvp/cardbg0.png"
				end
			else
				return "ui/pvp/pvpprivatesb"..math.floor(hApi.NumBetween(lv,1,4))..".png"
			end
		end,
		GetCardUnitModel = function(id,num,cid,lv,tRGB)
			if type(num)=="number" and num>0 then
				return hVar.tab_unit[id].model
			else
				return hVar.tab_unit[id].model,nil,nil,nil,nil,nil,tRGB
			end
		end,
		GetCardUnlockCost = function(id,num,cid,lv,param)
			if lv<=0 then
				local tabA = hVar.tab_army[cid]
				if tabA and (tabA.unlock_coin or 0)>0 then
					if param then
						return param[2]
					else
						return tostring(tabA.unlock_coin)
					end
				else
					if param then
						return param[1]
					else
						return 0
					end
				end
			else
				return 0
			end
		end,
	}
	local __UC__UIList = {
		{"image","imgCardBG",{__UC__UIFunc.GetCardBG},{0,-22,140,180}},
		{"image","imgLock",{__UC__UIFunc.IsUnlocked,{0,"UI:Lock"}},{0,-22,-1,-1,9}},
		{"image","imgIcon",{__UC__UIFunc.GetCardUnitModel,{128,128,128}},{0,-36,96,96}},
		{"label","labLv",{__UC__UIFunc.GetNum},{8,-76,16,0,"MC","numWhite"}},
		{"label","labName",{function(id)return hVar.tab_stringU[id][1]end},{0,36,24,1,"MC",hVar.FONTC,{255,255,255}}},
		{"image","imgCoinCost",{__UC__UIFunc.GetCardUnlockCost,{0,"UI:game_coins"}},{-24,-84,36,-1,9}},
		{"label","labCoinCost",{__UC__UIFunc.GetCardUnlockCost},{-12,-84,24,1,"LC",hVar.FONTC,{255,255,255}}},
	}
	hUI.SetUITemplate("unitcard",{__UC__UIList,__UC__UIFunc})
end
----------------------------------------------------------------
--房间模板
----------------------------------------------------------------
do
	local __RM__UIFunc = {
		GetRoomPlayerInfo = function(tRoom,nMyID,tPlayerList,IsHost,mode,paramEx)
			local nID
			if IsHost==1 then
				nID = tRoom[hVar.PVP_ROOM_DATA.HOST]
			else
				nID = tRoom[hVar.PVP_ROOM_DATA.GUEST]
			end
			if nID~=0 and tPlayerList.index[nID] then
				local tPlayer = tPlayerList[tPlayerList.index[nID]]
				if mode=="icon" then
					local tRGB
					if tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.BUSY and tRoom[hVar.PVP_ROOM_DATA.HOST]>=0 and tRoom[hVar.PVP_ROOM_DATA.GUEST]>=0 then
						tRGB = paramEx
					end
					local id = hApi.ReadNumberFromFormatString(tPlayer[hVar.PVP_PLAYER_DATA.PARAM],"icon")
					if id==nil or id==0 then
						--tRGB = paramEx
						return "ui/revivehero.png",nil,nil,nil,nil,nil,tRGB
						--return "ui/pvp/nohero.png",nil,nil,nil,nil,nil,tRGB
					elseif hVar.tab_unit[id] then
						return hVar.tab_unit[id].icon,nil,nil,nil,nil,nil,tRGB
					else
						return "MODEL:Default",nil,nil,nil,nil,nil,tRGB
					end
				elseif mode=="name" then
					if tPlayer[hVar.PVP_PLAYER_DATA.ID]==nMyID then						--为本地玩家
						return tostring(tPlayer[hVar.PVP_PLAYER_DATA.NAME]),paramEx
					else
						return tostring(tPlayer[hVar.PVP_PLAYER_DATA.NAME])
					end
				else
					return 0
				end
			else
				return 0
			end
		end,
	}
	local __RM__UIList = {
		{"image","imgBG",{function(tRoom,nMyID)
			if nMyID==tRoom[hVar.PVP_ROOM_DATA.HOST] or nMyID==tRoom[hVar.PVP_ROOM_DATA.GUEST] then
				return "UI:pvproom2"
			else
				return "UI:pvproom1"
			end
		end},{0,0,-1,-1}},
		{"image","imgHostSlot","UI_frm:slot",{-66,2,68,68}},
		{"image","imgHostIcon",{__RM__UIFunc.GetRoomPlayerInfo,1,"icon",{128,128,128}},{-66,2,64,64,2}},
		{"label","labHostName",{__RM__UIFunc.GetRoomPlayerInfo,1,"name",{0,255,0}},{-66,50,22,1,"MC",hVar.FONTC,nil,100,22}},
		{"image","imgGuestSlot","UI_frm:slot",{66,2,68,68}},
		{"image","imgGuestIcon",{__RM__UIFunc.GetRoomPlayerInfo,2,"icon",{128,128,128}},{66,2,64,64,2}},
		{"label","labGuestName",{__RM__UIFunc.GetRoomPlayerInfo,2,"name",{0,255,0}},{66,50,22,1,"MC",hVar.FONTC,nil,100,22}},
	}
	hUI.SetUITemplate("roomcard",{__RM__UIList,__RM__UIFunc})
end
----------------------------------------------------------------
--精英挑战房间模板
----------------------------------------------------------------
do
	local __RM__UIFunc = {
		GetRoomPlayerInfo = function(tRoom,nMyID,tPlayerList,IsHost,mode,paramEx)
			local nID = tRoom[hVar.PVP_ROOM_DATA.HOST]
			if nID~=0 and tPlayerList.index[nID] then
				local tPlayer = tPlayerList[tPlayerList.index[nID]]
				local tExtra = tPlayer[hVar.PVP_PLAYER_DATA.EXTRA]
				if tExtra==0 then
				elseif mode=="icon" then
					local id = hApi.ReadNumberFromFormatString(tPlayer[hVar.PVP_PLAYER_DATA.PARAM],"icon")
					if id==nil or id==0 then
						return "ui/revivehero.png",nil,nil,nil,nil,nil,nil
					elseif hVar.tab_unit[id] then
						return hVar.tab_unit[id].icon,nil,nil,nil,nil,nil,nil
					else
						return "MODEL:Default",nil,nil,nil,nil,nil,nil
					end
				else
					local nRank = tExtra[2]					--排名：1,2,3
					if mode=="name" then
						local sRank = string.gsub(hVar.tab_string["__TEXT_ChallengeRank"],"#RANK#",tostring(nRank))
						return sRank..tostring(tPlayer[hVar.PVP_PLAYER_DATA.NAME])
					elseif mode=="bordureiconL" then
						--根据等级，为房间嵌入不同颜色的包边
						if nRank==1 then
							return "UI:pvpfirstleft",nil,nil,nil,nil,nil,nil
						elseif nRank==2 then
							return "UI:pvpsecondleft",nil,nil,nil,nil,nil,nil
						elseif nRank==3 then
							return "UI:pvpthirdleft",nil,nil,nil,nil,nil,nil
						end
					elseif mode=="bordureiconR" then
						if nRank==1 then
							return "UI:pvpfirstright",nil,nil,nil,nil,nil,nil
						elseif nRank==2 then
							return "UI:pvpsecondright",nil,nil,nil,nil,nil,nil
						elseif nRank==3 then
							return "UI:pvpthirdright",nil,nil,nil,nil,nil,nil
						end
					end
				end
			end
			return 0
		end,
	}
	local __RM__UIList = {
		{"image","imgBG","UI:pvproom1",{0,0,-1,-1}},									--背景
		{"image","imgHostSlot","UI_frm:slot",{0 ,2,68,68}},								--背景槽
		{"image","imgHostIcon",{__RM__UIFunc.GetRoomPlayerInfo,1,"icon"},{0,2,64,64,2}},				--头像
		{"label","labHostName",{__RM__UIFunc.GetRoomPlayerInfo,1,"name"},{0,50,22,1,"MC",hVar.FONTC,nil,218,22}},	--名字
		{"image","imgBordureLeftIcon",{__RM__UIFunc.GetRoomPlayerInfo,1,"bordureiconL"},{-83,-9,0,0,2}},		--左嵌边
		{"image","imgBordureRightIcon",{__RM__UIFunc.GetRoomPlayerInfo,1,"bordureiconR"},{83,-9,0,0,2}},		--右嵌边
	}
	hUI.SetUITemplate("roomcardrank",{__RM__UIList,__RM__UIFunc})
end
----------------------------------------------------------------
--兵种卡片信息模板(pvp网络对战)
----------------------------------------------------------------
do
	local __AC__UINumList = {
		{
			{
				{"image","imgHp",{"ICON:HeroAttr","hp_pec"},		{0,0,32,32}},
				{"label","tipHp",hVar.tab_string["__Attr_Hint_Hp:"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","num_hp","375",				{108,0,16,1,"LC","numRed"}},
				{"labelX","numPlus_hp","+0",				{188,0,16,1,"LC","numRed"}},
			},
			{
				{"image","imgAtk","ICON:action_attack",			{0,0,32,32}},
				{"label","tipAtk",hVar.tab_string["__Attr_Atk"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","numAtk","100~100",				{108,0,16,1,"LC","num"}},
				{"labelX","numPlus_atk","+0",				{188,0,16,1,"LC","num"}},
			},
			{
				{"image","imgDef","ICON:DETICON",			{0,0,32,32}},
				{"label","tipDef",hVar.tab_string["__Attr_Def"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","num_def","10",				{108,0,16,1,"LC","num"}},
				{"labelX","numPlus_def","+0",				{188,0,16,1,"LC","num"}},
			},
			{
				{"image","imgToughness","ICON:icon01_x1y1",			{0,0,32,32}},
				{"label","tipToughness",hVar.tab_string["__Attr_Toughness"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","num_toughness","0",					{108,0,16,1,"LC","num"}},
				{"labelX","numPlus_toughness","+0",				{188,0,16,1,"LC","num"}},
			},
			--{
				--{"image","imgBlock","ICON:icon01_x2y4",			{0,0,32,32}},
				--{"label","tipBlock",hVar.tab_string["__Attr_Block"],	{28,0,22,1,"LC",hVar.FONTC}},
				--{"labelX","num_block","1",				{108,0,16,1,"LC","num"}},
			--},
		},
		{
			{
				{"image","imgLv","ICON:ATTR_exp",			{0,0,32,32}},
				{"label","tipLv",hVar.tab_string["__Attr_Hint_Lev"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"valbar","barExp",{"UI:IMG_ValueBar","green",{model="UI:BAR_ValueBar_BG",x=-2,w=132,h=12}},{90,0,128,8,0,100,100}},
				{"labelX","num_lv","lv0",				{148,0,16,1,"MC","numGreen"}},
			},
			{
				{"image","imgAtkTyp","ICON:icon01_x1y10",		{0,0,32,32}},
				{"label","tipAtkTyp",hVar.tab_string["__Attr_Strtype"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","numAtkTyp",hVar.tab_string["__Attr_ATTACKMODE_28"],{136,0,22,1,"LC",hVar.FONTC}},
			},
			{
				{"image","imgActivity","ICON:MOVESPEED",		{0,0,32,32}},
				{"label","tipActivity",hVar.tab_string["__Attr_Speed"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","num_activity","1",				{136,0,16,1,"LC","num"}},
				{"labelX","numPlus_activity","+0",			{188,0,16,1,"LC","num"}},
			},
			{
				{"image","imgMove","ICON:MOVERANGE",			{0,0,32,32}},
				{"label","tipMove",hVar.tab_string["__Attr_MoveRange"],	{28,0,22,1,"LC",hVar.FONTC}},
				{"labelX","num_move","10",				{136,0,16,1,"LC","num"}},
				{"labelX","numPlus_move","+0",				{188,0,16,1,"LC","num"}},
			},
		},
	}
	local __AC__TokenTab = {}
	local __AC__AttrTab = {
		attr = {attack={0,0,0},lv="lv0",hp=0,mp=0,def=0,activity=0,move=0,block=0,toughness=0},
		attrP = {hp=0,atk=0,activity=0,def=0,move=0,toughness=0},
		load = function(self,id)
			local a = self.attr
			local tAttr
			local tabU = hVar.tab_unit[id]
			if tabU and tabU.attr then
				tAttr = tabU.attr
			else
				tAttr = __AC__TokenTab
			end
			a.attack[1] = 0
			a.attack[2] = 0
			local _,sAttackType = hApi.GetUnitAttackTypeById(id)
			a.attack[3] = sAttackType
			if tAttr.attack then
				a.attack[1] = a.attack[1] + tAttr.attack[4]
				a.attack[2] = a.attack[2] + tAttr.attack[5]
			end
			for k,v in pairs(a)do
				if type(v)=="number" then
					a[k] = 0
					if type(tAttr[k])=="number" then
						a[k] = a[k] + tAttr[k]
					end
				end
			end
		end,
	}
	local __AC__UIFunc = {
		LoadNumUI = function(tUIList,tGridList,x,y)
			local px = {x,260,0}
			local py = {y,-36,0}
			for col = 1,#tGridList do
				px[3] = px[1]
				py[3] = py[1]
				for row = 1,#tGridList[col] do
					local v = tGridList[col][row]
					for i = 1,#v do
						v[i][4][1] = v[i][4][1]+px[3]
						v[i][4][2] = v[i][4][2]+py[3]
						tUIList[#tUIList+1] = v[i]
					end
					py[3] = py[3]+py[2]
				end
				px[1] = px[1] + px[2]
			end
		end,
		UpdateByCard = function(tHandle,tCard,NeedJump)
			local nCardID,nCardLv,nCardExp = unpack(tCard)
			if hVar.tab_army[nCardID]==nil then
				return
			end
			local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,math.max(1,nCardLv),nCardExp)
			__AC__AttrTab:load(nUnitID)
			local nCardLvMax = (hVar.tab_army[nCardID].level or 1)
			if nCardLv>=nCardLvMax then
				__AC__AttrTab.attr.lv = "lv "..nCardLvMax
				tHandle["barExp"]:setV(0,100000)
			else
				__AC__AttrTab.attr.lv = "lv "..nCardLv
				tHandle["barExp"]:setV(nCardExp,100000)
			end
			if hVar.tab_unit[nUnitID] then
				local sModelName = hVar.tab_unit[nUnitID].model or "ui/revivehero.png"
				if tHandle["imgUnitIcon"].data.model~=sModelName then
					tHandle["imgUnitIcon"]:setmodel(sModelName)
				end
			end
			if type(nUnitNum)=="number" and nUnitNum>0 then
				__AC__AttrTab.attr["numUnitNum"] = nUnitNum
			else
				__AC__AttrTab.attr["numUnitNum"] = ""
			end
			__AC__AttrTab.attr["numAtk"] = __AC__AttrTab.attr.attack[1].."~"..__AC__AttrTab.attr.attack[2]
			__AC__AttrTab.attr["numAtkTyp"] = __AC__AttrTab.attr.attack[3]
			if hVar.tab_stringU[nUnitID] then
				__AC__AttrTab.attr["tipUnitName"] = hVar.tab_stringU[nUnitID][1] or "unit"..nUnitID
				__AC__AttrTab.attr["tipUnitInfo"] = hVar.tab_stringU[nUnitID][2] or ""
			end
			for sAttrName,v in pairs(__AC__AttrTab.attr)do
				local case = type(v)
				if case=="string" or case=="number" then
					local sAttr = tostring(v)
					local oLabel
					if type(tHandle[sAttrName])=="table" then
						oLabel = tHandle[sAttrName]
					elseif type(tHandle["num_"..sAttrName])=="table" then
						oLabel = tHandle["num_"..sAttrName]
					end
					if oLabel and oLabel.data.text~=sAttr then
						oLabel:setText(sAttr,1)
					end
				end
			end
			local tAttrP = __AC__AttrTab.attrP
			local tAttrC = hVar.tab_army[nCardID].attr
			for sAttrName,v in pairs(tAttrP)do
				tAttrP[sAttrName] = 0
				if type(tAttrC)=="table" then
					for i = 1,#tAttrC do
						if i<=nCardLv and type(tAttrC[i])=="table" and type(tAttrC[i][sAttrName])=="number" then
							tAttrP[sAttrName] = tAttrP[sAttrName] + tAttrC[i][sAttrName]
						end
					end
				end
				local oLabel = tHandle["numPlus_"..sAttrName]
				if tAttrP[sAttrName]>0 then
					oLabel.handle._n:setVisible(true)
					local sAttr = "+"..tostring(tAttrP[sAttrName])
					if oLabel.data.text~=sAttr then
						oLabel:setText(sAttr,1)
						if NeedJump==1 then
							local scaleA = oLabel.data.scaleB*1.3
							local scaleR = oLabel.data.scaleB
							local a = CCScaleTo:create(0.1,scaleA,scaleA)
							local aR = CCScaleTo:create(0.1,scaleR,scaleR)
							oLabel.handle._n:runAction(CCSequence:createWithTwoActions(a,aR))
						end
					end
				else
					oLabel.handle._n:setVisible(false)
				end
			end
		end,
	}
	local __AC__UIList = {
		{"image","imgCut","UI:panel_part_09",{560/2,-136,560,4}},
		{"image","imgSlot","UI:slotBig",{64,-64,-1,-1}},
		{"imageX","imgUnitIcon","UI:Default",{64,-64-18,96,96}},
		{"labelX","numUnitNum","0",{96,-88,16,1,"RC","numWhite"}},
		{"labelX","tipUnitName","Name",{280,-24,36,1,"MC",hVar.FONTC,{255,200,0}}},
		{"labelX","tipUnitInfo","hint",{168,-48,28,1,"LT",hVar.FONTC,0,560-168-20}},
	}
	__AC__UIFunc.LoadNumUI(__AC__UIList,__AC__UINumList,64,-164)
	hUI.SetUITemplate("armycard",{__AC__UIList,__AC__UIFunc})
end

----------------------------------------------------------------
--Rank排行榜模板(pvp网络对战)
----------------------------------------------------------------
do
	local __RKI__UIFunc = {
		GetRank = function(tRankData,mode)
			local nRank = tRankData[1]
			if mode=="top" then
				if nRank>=1 and nRank<=3 then
					return "UI:rank_n_"..nRank
				end
			else
				if nRank>3 then
					return tostring(nRank)
				end
			end
			return 0
		end,
		GetString = function(tRankData,nIndex)
			if type(nIndex)=="number" then
				return tostring(tRankData[nIndex])
			elseif type(nIndex)=="table" then
				local tIndex = nIndex
				local t = {}
				for i = 1,#tIndex do
					if type(tIndex[i])=="number" then
						t[#t+1] = tostring(tRankData[tIndex[i]])
					else
						t[#t+1] = tostring(tIndex[i])
					end
				end
				if #t>0 then
					return table.concat(t)
				end
			else
				return 0
			end
		end,
		GetPowerIcon = function(tRankData,i)
			if hVar.PVPRankUIEx[tRankData[8]] then
				return hVar.PVPRankUIEx[tRankData[8]][i]
			elseif hVar.PVPRankUI[tRankData[9]] then
				return hVar.PVPRankUI[tRankData[9]][i]
			else
				return hVar.PVPRankUI[1][i]
			end
		end,
		FormatRankData = function(tRankList,rTab)
			rTab = rTab or {}
			local tFormat = {0,0,0,1,0,0,0,0}
			--nRank,roldID,uID,name,elo,winstreak,power,medal
			--nPowerLv
			for n = 1,#tRankList do
				rTab[n] = {}
				local c = tRankList[n]
				local v = rTab[n]
				for i = 1,#tFormat do
					if tFormat[i]==0 then
						v[i] = tonumber(c[i]) or 0
					else
						v[i] = tostring(c[i])
					end
				end
				v[9] = hApi.GetLvByPower(v[7])
			end
			return rTab
		end,
	}
	--nRank,roldID,uID,name,elo,winstreak,power
	--nPowerLv
	local __RKI__UIList = {
		{"image","imgTopRank",{__RKI__UIFunc.GetRank,"top"},{-74,-8,-1,-1}},
		{"label","labRank",{__RKI__UIFunc.GetRank},{-74,-8,20,0,"MC","numWhite"}},
		{"label","labName",{__RKI__UIFunc.GetString,4},{88,-8,24,0,"MC",hVar.FONTC}},
		{"label","labElo",{__RKI__UIFunc.GetString,5},{260,-8,22,0,"MC"}},
		{"label","labPower",{__RKI__UIFunc.GetString,{"Lv ",9}},{352,-8,22,0,"LC"}},
		{"image","imgPowerBG","UI:cjkk",{526,-9,-1,50}},
		{"image","imgPower",{__RKI__UIFunc.GetPowerIcon,1},{484,-8,-1,38}},
		{"image","imgPowerStar",{__RKI__UIFunc.GetPowerIcon,2},{484,-7,-1,20}},
		{"image","imgPowerTip",{__RKI__UIFunc.GetPowerIcon,3},{548,-7,-1,22}},
	}
	hUI.SetUITemplate("rankitem",{__RKI__UIList,__RKI__UIFunc})
end

----------------------------------------------------------------
--任务面板
----------------------------------------------------------------
do
	local tColorGreen = {0,255,0}
	local _code_SetPVPQuestConfirmBtn = function(oBtn,nEnable)
		if nEnable~=1 then
			oBtn:setstate(0)
		end
		if (nEnable or 0)>=2 then
			oBtn.data.userdata = 1
			hUI.deleteUIObject(hUI.image:new({
				parent = oBtn.handle._n,
				model = "UI:ok",
				w = 36,
				h = -1,
			}))
		end
		return oBtn
	end
	local _tParam = {
		ModelFunc=function(self,param)
			return param[1](self.quest,param[2],param[3])
		end
	}
	local __QST__UIFunc = {
		GetParam = function(tQuest)
			_tParam.quest=tQuest
			return _tParam
		end,
		GetQuestNameBG = function(tQuest)
			if tQuest[hVar.PVP_QUEST_DATA.TYPE]==1 then
				return "UI:QuestTipBG1"
			else
				return "UI:QuestTipBG2"
			end
		end,
		GetQuestString = function(tQuest,nIndex)
			if nIndex==hVar.PVP_QUEST_DATA.TIP and tQuest[hVar.PVP_QUEST_DATA.STATE]~=0 then
				return tostring(tQuest[nIndex]),tColorGreen
			else
				return tostring(tQuest[nIndex])
			end
		end,
		GetRewardImage = function(tQuest,sModel,sAnimation)
			local tReward = tQuest[hVar.PVP_QUEST_DATA.REWARD]
			if type(tReward)=="table" and #tReward>0 then
				return sModel,nil,nil,nil,nil,nil,nil,sAnimation
			else
				return 0
			end
		end,
		AddRewardBtn = function(oFrm,oGrid,x,y,tQuest,tParam,pExitFunc)
			if type(pExitFunc)~="function" then
				return
			end
			return _code_SetPVPQuestConfirmBtn(hUI.button:new({
				parent = oGrid.handle._n,
				dragbox = oFrm.childUI["dragBox"],
				model = "UI:button_tiny",
				label = {
					text = hVar.tab_string["__Get__"],
					size = 24,
					border = 1,
					font = hVar.FONTC,
					y = 2,
					x = 2,
				},
				scaleT = 0.9,
				ox = oGrid.data.x,
				oy = oGrid.data.y,
				x = x-10,
				y = y+2,
				w = 78,
				h = 78,
				sizeW = -1,
				sizeH = -1,
				smartWH = 1,
				code = function(self)
					_code_SetPVPQuestConfirmBtn(self,2)
					return pExitFunc(tParam)
				end,
			}),tQuest[hVar.PVP_QUEST_DATA.STATE])
		end,
	}
	local __QST__UIList = {
		{"image","imgBG","UI:QuestBG",{370,-70,-1,-1}},
		{"label","labRw",{__QST__UIFunc.GetRewardImage,hVar.tab_string["__Reward__"]},{572,-32,20,1,"MC",hVar.FONTC}},
		{"image","imgRwBGL",{__QST__UIFunc.GetRewardImage,"UI:QuestTipBGLR2","L"},{542,-32,-1,-1,10}},
		{"image","imgRwBGR",{__QST__UIFunc.GetRewardImage,"UI:QuestTipBGLR2","R"},{604,-32,-1,-1,10}},
		{"image","imgNameBG",{__QST__UIFunc.GetQuestNameBG},{132,-28,-1,-1}},
		{"image","imgNameBGL",{"UI:QuestTipBGLR","L"},{32,-28,-1,-1,10}},
		{"image","imgNameBGR",{"UI:QuestTipBGLR","R"},{224,-28,-1,-1,10}},
		--{"label","labTip",{__QST__UIFunc.GetQuestString,hVar.PVP_QUEST_DATA.TIP},{678,-28,20,1,"MC","Arial"}},
		--{"label","labIntro",{__QST__UIFunc.GetQuestString,hVar.PVP_QUEST_DATA.INTRO},{32,-76,22,1,"LC",hVar.FONTC,0,460}},
		--{"label","labName",{__QST__UIFunc.GetQuestString,hVar.PVP_QUEST_DATA.NAME},{128,-28,28,1,"MC",hVar.FONTC}},
	}
	hUI.SetUITemplate("questitem",{__QST__UIList,__QST__UIFunc})
end

----------------------------------------------------------------
--装备模板
----------------------------------------------------------------
do
	local _tParam = {
		param = 0,
		item = 0,
		ModelFunc = function(self,tData)
			return tData[1](self.item,self.param,tData[2],tData[3],tData[4])
		end,
	}
	local _tParamShow = {tip=1}
	--显示物品详细信息的位置(模式1,模式2)
	local __IT__ItemTipPos = {
		it = {{180,640},{68,hVar.SCREEN.h/2+280}},
		tc = {{220,520},{68,hVar.SCREEN.h/2+280}},
	}
	local __IT__UIFunc = {
		GetParam = function(tItem,tParam)
			if type(tItem)=="table" then
				_tParam.item = tItem
			else
				_tParam.item = {"it",1,0}
			end
			if type(tParam)=="table" then
				_tParam.param = tParam
			elseif tParam==1 then
				_tParam.param = _tParamShow
			else
				_tParam.param = 0
			end
			return _tParam
		end,
		GetIcon = function(tItem,tParam,sDrawMode)
			if sDrawMode=="bg" then
				if tParam~=0 and tParam.bg==0 then
					return 0
				elseif tItem[1]=="it" or tItem[1]=="ix" then
					local tabI = hVar.tab_item[tItem[2]]
					if tabI and tabI.itemLv and hVar.ITEMLEVEL[tabI.itemLv] then
						return hVar.ITEMLEVEL[tabI.itemLv].BACKMODEL
					else
						return hVar.ITEMLEVEL[1].BACKMODEL
					end
				elseif tItem[1]=="tc" then
					local nQuality = hApi.GetTacticsCardQA(tItem[2],tItem[3])
					if hVar.ITEMLEVEL[nQuality] then
						return hVar.ITEMLEVEL[nQuality].BACKMODEL
					else
						return hVar.ITEMLEVEL[1].BACKMODEL
					end
				elseif tItem[1]=="cn" then
					return hVar.ITEMLEVEL[3].BACKMODEL
				elseif tItem[1]=="sc" then
					return hVar.ITEMLEVEL[1].BACKMODEL
				elseif tItem[1]=="pc" then
					return hVar.ITEMLEVEL[2].BACKMODEL
				end
			else
				if tItem[1]=="it" or tItem[1]=="ix" then
					local tabI = hVar.tab_item[tItem[2]]
					if tabI then
						if tabI.uiXYWH~=nil then
							local x,y,w,h = unpack(tabI.uiXYWH)
							return tabI.icon,x,y,w,h
						elseif tParam~=0 and (tParam.w or tParam.h) then
							local x,y,w,h = 0,0,tParam.w or -1,tParam.h or -1
							return tabI.icon,x,y,w,h
						else
							return tabI.icon
						end
					else
						return "UI:default"
					end
				elseif tItem[1]=="tc" then
					local tabT = hVar.tab_tactics[tItem[2]]
					if tabT then
						return tabT.icon
					else
						return "UI:default"
					end
				elseif tItem[1]=="cn" then
					return "UI:game_coins"
				elseif tItem[1]=="sc" then
					return "UI:score"
				elseif tItem[1]=="pc" then
					return "UI:pvptoken",0,0,-1,-1
				end
			end
			return 0
		end,
		GetItemLabel = function(tItem,tParam)
			if not(type(tParam)=="table" and (tParam.tip or 0)~=0) then
				return 0
			end
			local v,p
			if tItem[1]=="it" or tItem[1]=="ix" then
				v = tItem[3]
				local tabI = hVar.tab_item[tItem[2]]
				if tabI then 
					if tabI.numUI then
						p = tabI.numUI
					end
					if tParam.tip==2 then
						--显示完整名字
						if hVar.tab_stringI[tItem[2]] then
							return tostring(hVar.tab_stringI[tItem[2]][1]),0,0,-28,hVar.FONTC,24,1
						else
							return "item_"..tostring(tItem[2]),0,0,-28,hVar.FONTC,24,1
						end
					end
				end
			elseif tItem[1]=="tc" then
				if type(tItem[3])=="number" then
					return "lv"..tItem[3]
				end
			elseif tItem[1]=="cn" or tItem[1]=="sc" or tItem[1]=="pc" then
				v = tItem[2]
			end
			if type(v)=="number" and v>0 then
				if p then
					return tostring(p)..v
				elseif v<=999 then
					return "x"..v
				else
					return tostring(v)
				end
			end
			return 0
		end,
		GetItemByCmd = function(s)
			if string.find(s,",") then
				local t = hApi.SplitN(s,",")
				local r = {}
				for i = 1,3 do
					r[i] = t[i] or 0
				end
				return r
			else
				local id = tonumber(s)
				if (id or 0)==0 then
					return 0
				else
					return {"it",id,0}
				end
			end
		end,
		ShowItemTip = function(tItem,nStyle,ex)
			if type(tItem)~="table" then
				return
			else
				local tPos
				if tItem[1]=="tc" then
					tPos = __IT__ItemTipPos.tc[nStyle or 1] or __IT__ItemTipPos.tc[1]
				else
					tPos = __IT__ItemTipPos.it[nStyle or 1] or __IT__ItemTipPos.it[1]
				end
				if tItem[1]=="it" or tItem[1]=="ix" then
					local id = tItem[2]
					local tabI = hVar.tab_item[id]
					local tSlot
					if type(ex)=="number" and tabI and hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]==1 then
						tSlot = hApi.NumTable(ex+1)
						tSlot[1] = ex
					else
						tSlot = "mx"
					end
					local oItem = hApi.CreateItemObjectByID(id,tSlot,nil,-1)
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{oItem},nil,1,tPos[1],tPos[2])
				elseif tItem[1]=="tc" then
					local id = tItem[2]
					local lv = tItem[3]
					hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",id,lv,tPos[1],tPos[2],0,0)
				elseif tItem[1]=="sc" then
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{{25}},nil,1,tPos[1],tPos[2])
				elseif tItem[1]=="cn" then
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{{27}},nil,1,tPos[1],tPos[2])
				elseif tItem[1]=="pc" then
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{{26}},nil,1,tPos[1],tPos[2])
				end
			end
		end,
		GetName = function(tItem)
			if type(tItem)~="table" then
			elseif tItem[1]=="it" or tItem[1]=="ix" then
				local id = tItem[2]
				local tabI = hVar.tab_item[id]
				local sMyName,tRGB
				if tabI then
					if hVar.ITEMLEVEL[tabI.itemLv or 1] then
						tRGB = hVar.ITEMLEVEL[tabI.itemLv or 1].NAMERGB
					end
					if hVar.ITEM_ELITE_LEVEL[tabI.elite or 0] then
						tRGB = hVar.ITEM_ELITE_LEVEL[tabI.elite or 0].NAMERGB
					end
				end
				if hVar.tab_stringI[id] then
					sMyName = tostring(hVar.tab_stringI[id][1])
				end
				return sMyName,tRGB
			end
			return "none",nil
		end,
	}
	local __IT__UIList = {
		--背景槽
		{"image","_itemBG",{__IT__UIFunc.GetIcon,"bg"},{0,0,52,52}},
		--图标
		{"image","_itemIcon",{__IT__UIFunc.GetIcon},{0,0,48,48}},
		--标题
		{"label","_itemLabel",{__IT__UIFunc.GetItemLabel},{0,-22,16,0,"MC","numWhite"}},
	}
	hUI.SetUITemplate("bagitem",{__IT__UIList,__IT__UIFunc})
end
