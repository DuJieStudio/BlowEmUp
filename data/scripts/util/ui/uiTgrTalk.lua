local _tgr = hVar.TGR_CODE_IN_TALK
--function(TagData,TagParam,oUnit[�Ի�������],oTarget[�Ի�Ŀ��],oTargetX[������������λ],cTalk[�Ի���],cIndex[��ǰ�Ի�����],vTalk[���ر�])
--	return �����������ļ����Ի�,��Ҫ��ʾ������)
--end
--_tgr["@xxx:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
--end
_tgr["@func:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if TagData~="func:" then
		local code = _tgr["@"..TagData..":"]
		if code then
			return code(TagParam,"",oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
		end
	end
end

--֧�ֺ���
hGlobal.TGR_FUNC = {}
--���һ�����ε�box
hGlobal.TGR_FUNC.GetBoxByCmd = function(sData)
	local tBoxList = {}
	if string.find(sData,"%(") then
		for cmd in string.gfind(sData,"%((.-)%)") do
			local _,_,tx,ty,bx,by = string.find(cmd,"(%--%d+),(%--%d+),(%--%d+),(%--%d+)")
			if tx then
				local x,y,w,h
				local x1,y1= tonumber(tx),tonumber(ty)
				local x2,y2 = tonumber(bx),tonumber(by)
				if x1<=x2 then
					x = x1
					w = x2-x1
				else
					x = x2
					w = x1-x2
				end
				if y1<=y2 then
					y = y2
					h = y2-y1
				else
					y = y1
					h = y1-y2
				end
				tBoxList[#tBoxList+1] = {x,y,w,h}
			end
		end
	end
	return tBoxList
end

--��֧�Ի�
local __TOKEN_tTalk = {}
_tgr["@select:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tNum = tonumber(TagData)
	if type(tNum)=="number" and tNum>0 then
		local nCount = 0
		local ConvertS = hVar.tab_stringM[TagParam] or __TOKEN_tTalk
		local tSelection = {}
		for i = 1,tNum do
			local tTag = cTalk[cIndex+i]
			if tTag then
				nCount = nCount + 1
				local tText = ConvertS[i] or tTag
				tSelection[#tSelection+1] = {tTag,tText,100}
			end
		end
		if (cIndex+tNum)>=#cTalk then
			--ɶ��������һ�仰�ˣ�
			--�Ǿ��ڲ�һ���
			local LastString
			for i = #vTalk,1,-1 do
				if type(vTalk[i])=="string" then
					LastString = vTalk[i]
					break
				end
			end
			vTalk[#vTalk+1] = function(tFunc)
				tFunc.InitSelection(oUnit,oTargetX,tSelection,vTalk.selection)
			end
			if LastString then
				vTalk[#vTalk+1] = LastString
			end
		else
			--һ������
			vTalk[#vTalk+1] = function(tFunc)
				tFunc.InitSelection(oUnit,oTargetX,tSelection,vTalk.selection)
			end
		end
		return tNum
	end
end

--��ȡ�Ի�������Ŀ�굥λ��id
_tgr["@TalkByID:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local id = oTargetX.data.id
	if TagParam=="u" then
		id = oUnit.data.id
	elseif TagParam=="t" then
		id = oTarget.data.id
	else
		id = oTargetX.data.id
	end
	hApi.LoadConvertedMapString(vTalk,TagData.."_"..id,nil)
end

--����Ŀ�굥λ��id��������Ǿ����������n�仰
_tgr["@DoWithID:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nCount = tonumber(TagData)
	if nCount and nCount>0 then
		local TabID = hApi.LoadIdFromString({},TagParam)
		local uId = vTalk.id[2]
		if TabID[uId]~=1 then
			return nCount
		end
	end
end

--�������ɾ�Ի�
_tgr["@Skip:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	return tonumber(TagData)
end

--���öԻ�tag
_tgr["@talk:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local u,uID,u__ID = oTargetX,oTargetX.ID,oTargetX.__ID
	local sTag = TagData
	vTalk[#vTalk+1] = function()
		if u.ID==uID and u.__ID==u__ID then
			if sTag=="0" then
				u.data.talkTag = 0
			elseif sTag=="-1" then
				u.data.talkTag = -1
			elseif sTag then
				--@talk:10(20)@
				local s = string.find(sTag,"%[")
				local e
				if s and s>0 then
					e = string.find(sTag,"%]")
				end
				if s and e and e-s>1 then
					local tarID = tonumber(string.sub(sTag,s+1,e-1))
					local ux = hGlobal.WORLD.LastWorldMap:tgrid2unit(tarID)
					if ux then
						local vTag = string.sub(sTag,1,s-1)
						if vTag=="0" then
							vTag = 0
						elseif vTag=="-1" then
							vTag = -1
						end
						ux.data.talkTag = vTag
					end
				else
					u.data.talkTag = vTag
				end
			end
		end
	end
end

--����
_tgr["@ally:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nAlly = tonumber(TagData)
	if type(oTargetX)=="table" and type(nAlly)=="number" and hGlobal.player[math.abs(nAlly)] then
		local _oTarget = hApi.SetObject({},oTargetX)
		if nAlly>0 then
			vTalk[#vTalk+1] = function()
				local t = hApi.GetObject(_oTarget)
				if t then
					local oPlayer = t:getowner()
					if oPlayer and hGlobal.player[nAlly] and oPlayer~=hGlobal.player[nAlly] then
						print("���["..t.data.owner.."] �� ���["..nAlly.."] ����")
						oPlayer:setally(hGlobal.player[nAlly])
					end
				end
			end
		elseif nAlly<0 then
			nAlly = -1*nAlly
			vTalk[#vTalk+1] = function()
				local t = hApi.GetObject(_oTarget)
				if t then
					local oPlayer = t:getowner()
					if oPlayer and hGlobal.player[nAlly] and oPlayer~=hGlobal.player[nAlly] then
						print("���["..t.data.owner.."] �� ���["..nAlly.."] �ж�")
						oPlayer:setenemy(hGlobal.player[nAlly])
					end
				end
			end
		end
	end
end

--�Ƴ���ͼ�����е�λ������ָ��id��Ŀ��
_tgr["@RemoveUnitInAllTeam:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if TagData~="" then
		local w = hGlobal.WORLD.LastWorldMap
		local w__ID = w.__ID
		local TabID = hApi.LoadIdFromString({},TagData)
		vTalk[#vTalk+1] = function()
			if w.__ID==w__ID then
				w:enumunit(function(t)
					local team = t.data.team
					if team~=0 and type(t.data.team)=="table" then
						local rCount = 0
						for i = 1,#team do
							local v = team[i]
							if v~=0 and type(v)=="table" and TabID[v[1]] then
								team[i] = 0
								rCount = rCount + 1
							end
						end
						if rCount>0 then
							hGlobal.event:call("Event_TeamChange","remove",t)
						end
					end
				end)
			end
		end
	end
end

_tgr["@CheckQuest:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tFindQuest
	local oWorld = hGlobal.WORLD.LastWorldMap
	for i = 1,#oWorld.data.QuestList do
		local v = oWorld.data.QuestList[i]
		--{1,nMin,nMax,{u.ID,u.__ID,u.data.id,triggerID},text,reward}
		if type(v)=="table" and type(v[4])=="table" and v[4][3]==oTargetX.data.id and v[4][4]==oTargetX.data.triggerID then
			tFindQuest = v
			break
		end
	end
	local IsCompleted
	local UniqueQuestID
	local AchievementID
	if tFindQuest~=nil and type(tFindQuest[4])=="table" then
		UniqueQuestID = tFindQuest[4][5] or 0
		if UniqueQuestID~=0 then
			AchievementID = hVar.ACHIEVEMENT_TYPE["UNIQUE_QUEST_"..UniqueQuestID]
			IsCompleted = LuaGetPlayerMapAchi(oWorld.data.map,AchievementID)
			if hVar.OPTIONS.TEST_UNIQUE_QUEST==1 then
				return
			end
		else
			if tFindQuest[1]==1 then
				IsCompleted = 0
			else
				IsCompleted = 1
			end
		end
	end
	local PassNum
	if TagData~="" then
		PassNum = tonumber(TagData)
	end
	if tFindQuest~=nil and IsCompleted==0 then
		PassNum = 0
	end
	if type(PassNum)=="number" and PassNum>0 then
		return PassNum
	end
end

--���ָ����λ������
_tgr["@CompleteQuest:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tFindQuest
	local oWorld = hGlobal.WORLD.LastWorldMap
	for i = 1,#oWorld.data.QuestList do
		local v = oWorld.data.QuestList[i]
		--{1,nMin,nMax,{u.ID,u.__ID,u.data.id,triggerID},text,reward}
		if type(v)=="table" and type(v[4])=="table" and v[4][3]==oTargetX.data.id and v[4][4]==oTargetX.data.triggerID then
			tFindQuest = v
			break
		end
	end
	local IsCompleted
	local UniqueQuestID
	local AchievementID
	if tFindQuest~=nil and type(tFindQuest[4])=="table" then
		UniqueQuestID = tFindQuest[4][5] or 0
		if UniqueQuestID~=0 then
			AchievementID = hVar.ACHIEVEMENT_TYPE["UNIQUE_QUEST_"..UniqueQuestID]
			IsCompleted = LuaGetPlayerMapAchi(oWorld.data.map,AchievementID)
			if hVar.OPTIONS.TEST_UNIQUE_QUEST==1 then
				IsCompleted = 0
			end
		else
			if tFindQuest[1]==1 then
				IsCompleted = 0
			else
				IsCompleted = 1
			end
		end
	end
	local PassNum
	if TagData~="" then
		PassNum = tonumber(TagData)
	end
	if tFindQuest~=nil and IsCompleted==0 then
		--local LastString
		--if type(PassNum)=="number" and PassNum>0 then
			--for i = 1,PassNum do
				--cTalk[cIndex+i] = 1
			--end
		--end
		--PassNum = 0
		local pFunc
		local oWorld__ID = oWorld.__ID
		if AchievementID then
			--Ψһ�������
			local sRewardType = "ITEM"
			if type(tFindQuest[4])=="table" then
				sRewardType = tFindQuest[4][6] or "ITEM"
			end
			local SelectNum = 0
			local tLoot = {}
			for i = 6,#tFindQuest do
				local id = tFindQuest[i]
				if sRewardType=="TACTIC_CARD" then
					SelectNum = 1
					if hVar.tab_tactics[id] then
						tLoot[#tLoot+1] = {"battlefieldskill",id,1,tFindQuest[4][4]}
					end
				else
					if hVar.tab_item[id] then
						tLoot[#tLoot+1] = {"item",id,1,tFindQuest[4][4]}
					end
				end
			end
			if SelectNum>0 then
				local SelectIndex
				--�ཱ��ѡ��
				--ѡһ��
				pFunc = function(tFunc)
					if oWorld.__ID==oWorld__ID and tFindQuest[1]==1 then
						tFunc.ShowLoot(tLoot,SelectNum,function(tSelect)
							if hVar.OPTIONS.TEST_UNIQUE_QUEST==1 then
								return
							end
							if oWorld.__ID==oWorld__ID and tFindQuest[1]==1 and LuaGetPlayerMapAchi(oWorld.data.map,AchievementID)==0 then
								tFindQuest[1] = 3
								hGlobal.event:event("LocalEvent_UpdateMapQuest",oWorld)
								--�Ȱѳɾʹ��ˣ�ʡ�ĳ�����
								LuaSetPlayerMapAchi(oWorld.data.map,AchievementID,1)
								--�������ѡ����Щ����
								local GiveIndex = {}
								local tLootX = {}
								for i = 1,#tSelect do
									local index = tSelect[i]
									if tLoot[index] and GiveIndex[index]~=1 then
										GiveIndex[index] = 1
										tLootX[#tLootX+1] = tLoot[index]
									end
								end
								--����Ʒ�������
								hApi.LocalPlayerGetQuestReward(tLootX,"uquest",UniqueQuestID)
								--���̱����������
								LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
							end
						end)
					end
				end
			else
				--ȫ��
				pFunc = function(tFunc)
					if oWorld.__ID==oWorld__ID and tFindQuest[1]==1 then
						tFunc.ShowLoot(tLoot)
						if hVar.OPTIONS.TEST_UNIQUE_QUEST==1 then
							return
						end
						if LuaGetPlayerMapAchi(oWorld.data.map,AchievementID)==0 then
							tFindQuest[1] = 3
							hGlobal.event:event("LocalEvent_UpdateMapQuest",oWorld)
							--�Ȱѳɾʹ��ˣ�ʡ�ĳ�����
							LuaSetPlayerMapAchi(oWorld.data.map,AchievementID,1)
							--����Ʒ�������
							hApi.LocalPlayerGetQuestReward(tLoot,"uquest",UniqueQuestID)
							--���̱����������
							LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						end
					end
				end
			end
		else
			--һ����������
			pFunc = function(tFunc)
				if oWorld.__ID==oWorld__ID and tFindQuest[1]==1 then
					tFindQuest[1] = 2
					hGlobal.event:event("LocalEvent_UpdateMapQuest",oWorld)
				end
			end
		end
		if type(PassNum)=="number" and PassNum>0 then
			return nil,nil,{1,{-2,pFunc}}
		else
			vTalk[#vTalk+1] = pFunc
		end
	else
		if type(PassNum)=="number" and PassNum>0 then
			return PassNum
		end
	end
end

-------------------------------------
-- "@func:" ��ʼ,TagParam��Ч
-------------------------------------
--�ۿ۹���Ӣ�ۿ�Ƭ
_tgr["@BuyHeroCard:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hApi.IsHaveHeroCard(oTargetX.data.id)~=hVar.RESULT_SUCESS and hApi.IsHeroFree(oTargetX.data.id)~=hVar.RESULT_SUCESS then
		--if hVar.HERO_NEED_BUY[oTargetX.data.id]==1 then
		--�������Ӣ�۲������
		local oHero = oTargetX:gethero()
		if oHero then
			local shopID = 0
				for i = 1,#hVar.tab_shopitem do
				local v = hVar.tab_shopitem[i]
				if type(v)=="table" then
					local tabI = hVar.tab_item[v.itemID]
					if tabI and tabI.type==hVar.ITEM_TYPE.HEROCARD and tabI.heroID==oHero.data.id then
						shopID = i
						break
					end
				end
			end
			if shopID>0 then
				local heroID = oHero.data.id
				local star = oHero.attr.star
				local lv = oHero.attr.level
				vTalk[#vTalk+1] = function()
					hGlobal.event:event("LocalEvent_ShowBuyHeroCardFrm",nil,shopID,0.9,heroID,star,lv)
					return
				end
			end
		end
	else
		if TagData~="" then
			local PassNum = tonumber(TagData)
			if type(PassNum)=="number" and PassNum>0 then
				return PassNum,0
			end
		end
	end
end

--ֱ�ӻ��Ӣ�ۿ�Ƭ
_tgr["@GetHeroCard:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local PassNum
	if TagData~="" then
		PassNum = tonumber(TagData)
	end
	if hApi.IsHaveHeroCard(oTargetX.data.id)~=hVar.RESULT_SUCESS and hApi.IsHeroFree(oTargetX.data.id)==hVar.RESULT_SUCESS then
		local oHero = oTargetX:gethero()
		if oHero then
			local oHero_id = oHero.data.id
			local oHero__ID = oHero.__ID
			local pFunc = function()
				if oHero.__ID==oHero__ID and oHero.data.id==oHero_id then
					hGlobal.event:call("LocalEvent_GetHeroCard",oHero,"ReadGameData")
				end
			end
			if type(PassNum)=="number" and PassNum>0 then
				return nil,nil,{1,{-2,pFunc}}
			else
				vTalk[#vTalk+1] = pFunc
			end
		end
	else
		if type(PassNum)=="number" and PassNum>0 then
			return PassNum,0
		end
	end
end

--�������
_tgr["@ClearFog:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local x,y
	if TagData=="" then
		x,y = oTargetX:getXY()
	else
		local s = string.find(TagData,",")
		local l = string.len(TagData)
		if s and s>1 and s<l then
			x = tonumber(string.sub(TagData,1,s-1))
			y = tonumber(string.sub(TagData,s+1,l))
		end
	end
	if type(x)=="number" and type(y)=="number" then
		vTalk[#vTalk+1] = function()
			xlClearFogByPoint(x,y)
		end
	end
end

--���ӵ��Ӣ�ۿ�Ƭ������x
_tgr["@PassWhenHaveHeroCard:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hApi.IsHaveHeroCard(oTargetX.data.id)==hVar.RESULT_SUCESS and TagData~="" then
		local PassNum = tonumber(TagData)
		if type(PassNum)=="number" and PassNum>0 then
			return PassNum,0
		end
	end
end

--���δӵ��Ӣ�ۿ�Ƭ������x
_tgr["@PassWhenNotHaveHeroCard:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hApi.IsHaveHeroCard(oTargetX.data.id)~=hVar.RESULT_SUCESS and TagData~="" then
		local PassNum = tonumber(TagData)
		if type(PassNum)=="number" and PassNum>0 then
			return PassNum,0
		end
	end
end

--���ӵ��Ӣ�ۿ�Ƭ��ִ�����漸�䣬��������X
_tgr["@IfHaveHeroCard:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hApi.IsHaveHeroCard(oTargetX.data.id)~=hVar.RESULT_SUCESS then
		return tonumber(TagData)
	end
end

--��λ���봦��
local __CodeCheckUnitJoin = function(TagData,oUnit,oTarget,oTargetX)
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local oUnitC
	local playerId
	if TagData~="" then
		local nLen = string.len(TagData)
		if string.sub(TagData,1,1)=="p" and nLen>1 then
			--����ĳ�����
			playerId = tonumber(string.sub(TagData,2,nLen)) or hVar.PLAYER.NEUTRAL_PASSIVE	--��֪�������ĸ���ң��ͼ��������޵���
		else
			--����ĳ����λ
			local tgrID = tonumber(TagData)
			if type(tgrID)=="number" and tgrID>0 then
				local w = oTargetX:getworld()
				if w then
					oUnitC = w:tgrid2unit(tgrID)
				end
			end
		end
	end
	if playerId then
		--����������ȼ����
		nPlayerToJoin = playerId
		oUnitWillJoin = oTargetX
		oUnitToJoin = nil
	elseif oUnitC then
		--����ת����λ
		nPlayerToJoin = oUnitC.data.owner
		oUnitWillJoin = oTargetX
		oUnitToJoin = oUnitC
	else
		--����˵����λ
		nPlayerToJoin = oUnit.data.owner
		oUnitWillJoin = oTargetX
		oUnitToJoin = oUnit
	end
	return nPlayerToJoin,oUnitWillJoin,oUnitToJoin
end
--��λ���봦��
local __CodeUnitJoin = function(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
	--����������λ���룬�����ת����ת��Ϊ������ֵ��Ǹ���λ
	if oUnitWillJoin~=nil and oUnitWillJoin.data.type==hVar.UNIT_TYPE.GROUP then
		local u = hClass.unit:find(oUnitWillJoin.data.nTarget)
		if u and u.data.nTarget==oUnitWillJoin.ID then
			oUnitWillJoin = u
		else
			oUnitWillJoin = nil
		end
	end
	--Ŀ��������
	if oUnitWillJoin~=nil then
		--������������ж�
		if nPlayerToJoin==hGlobal.LocalPlayer.data.playerId and CanGetHeroCard==1 then
			--����������Ӣ�ۣ�����Ҳ���ӵ�д�Ӣ�ۿ�Ƭ�������������ÿ�Ƭ
			--��ʾ���빺��Ƭ����ʹ��Ӣ�ۼ���
			if hApi.IsHeroFree(oUnitWillJoin.data.id)~=1 and hApi.IsHaveHeroCard(oUnitWillJoin.data.id)~=hVar.RESULT_SUCESS then
				--�Ƴ�֮ǰ�����жԻ�
				for i = #vTalk,1,-1 do
					vTalk[i] = nil
				end
				if DiscountForHeroCard==1 then
					local shopID = 0
					for i = 1,#hVar.tab_shopitem do
						local v = hVar.tab_shopitem[i]
						if type(v)=="table" then
							local tabI = hVar.tab_item[v.itemID]
							if tabI and tabI.type==hVar.ITEM_TYPE.HEROCARD and tabI.heroID==oUnitWillJoin.data.id then
								shopID = i
								break
							end
						end
					end
					if shopID>0 then
						vTalk[1] = "@L1:1@"..hVar.tab_string["__TEXT_NeedBuyHeroCard"]
						vTalk[2] = hVar.tab_string["__TEXT_NeedBuyHeroCardWithDiscount25"]
						local heroID = oUnitWillJoin.data.id
						local star = oUnitWillJoin.attr.star
						local lv = oUnitWillJoin.attr.level
						vTalk[3] = function()
							hGlobal.event:event("LocalEvent_ShowBuyHeroCardFrm",nil,shopID,0.9,heroID, star, lv)
						end
					else
						vTalk[1] = "@L1:1@"..hVar.tab_string["__TEXT_NeedBuyHeroCard"]
					end
				else
					vTalk[1] = "@L1:1@"..hVar.tab_string["__TEXT_NeedBuyHeroCard"]
				end
				--����
				return -1,0
			end
		end
		--��Ӣ�ۣ��ǵ�λ���ܼ���������λ
		if oUnitWillJoin.data.type~=hVar.UNIT_TYPE.UNIT and oUnitWillJoin.data.type~=hVar.UNIT_TYPE.HERO then
			oUnitToJoin = nil
		end
		if oUnitToJoin~=nil then
			--����ĳ����λ
			local cU = hApi.SetObject({},oUnitWillJoin)
			local tU = hApi.SetObject({},oUnitToJoin)
			vTalk[#vTalk+1] = function()
				local u = hApi.GetObject(cU)
				local t = hApi.GetObject(tU)
				if u and t then
					local oHero = t:gethero()
					local oHeroWillJoin = u:gethero()
					if oHero and oHeroWillJoin then
						if hGlobal.LocalPlayer:getfocusunit("worldmap")==u then
							local tHero = hGlobal.LocalPlayer.heros
							for i = 1,#tHero do
								if tHero[i] and tHero[i]~=oHeroWillJoin then
									local fu = tHero[i]:getunit()
									if fu then
										hGlobal.LocalPlayer:focusunit(fu,"worldmap")
										break
									end
								end
							end
						end
						--���Ӣ��ͬ����
						local IfWithChangeOwner = 0
						if oHero.data.owner~=oHeroWillJoin.data.owner then
							IfWithChangeOwner = 1
						end
						--����Ƿ�Ai��ң���һ�����Լ���
						local oPlayerJ = t:getowner()
						if oPlayerJ~=hGlobal.LocalPlayer then
							local EmptySlotIndex = 0
							local tTeam = t.data.team
							for i = 1,hVar.TEAM_UNIT_MAX do
								if tTeam[i]==0 then
									EmptySlotIndex = i
									break
								end
							end
							if EmptySlotIndex==0 then
								--û��λ�Ļ���ǿ�а���һ����λ����
								local nHpMax = 0
								for i = 1,hVar.TEAM_UNIT_MAX do
									if type(tTeam[i])=="table" then
										local tabU = hVar.tab_unit[tTeam[i][1]]
										if tabU and tabU.type==hVar.UNIT_TYPE.UNIT and tabU.attr and tabU.attr.hp then
											local chp = tabU.attr.hp*tTeam[i][2]
											if chp>nHpMax then
												nHpMax = chp
												EmptySlotIndex = i
											end
										end
									end
								end
								if EmptySlotIndex>0 then
									tTeam[EmptySlotIndex] = 0
								end
							end
						end
						if oHero:teamaddmember(oHeroWillJoin,nil,IfWithChangeOwner)==hVar.RESULT_SUCESS then
							--������Ҳ��ż�������
							if oPlayerJ==hGlobal.LocalPlayer then
								hApi.PlaySound("army")
							end
							--����ɹ���ת����Ӫ(����������ȡ��Ƭ����ô�Ͳ�ת����Ӫ,��������������������)
							if CanLoadHeroCard==1 then
								oHeroWillJoin:setowner(oHero.data.owner)
							end
							--����ǲ�֪��������Ӣ�ۣ����Զ�ȡ��Ƭ
							--ͬ��ģʽ��֧�ֻ�ÿ�Ƭ������Ϊ���п�Ƭ��Ӣ��
							if CanLoadHeroCard==1 and oHeroWillJoin.data.HeroCard~=1 and hGlobal.LocalPlayer==hGlobal.player[nPlayerToJoin] then
								local tHeroCard,IsHaveCard = oHeroWillJoin:LoadHeroFromCard("join")
								if tHeroCard then
									--oHeroWillJoin.data.HeroCard = 1
								end
								--���û�����Ƭ�Ļ���������Ƭ����¼�
								if IsHaveCard~=1 and CanGetHeroCard==1 then
									hGlobal.event:call("LocalEvent_GetHeroCard",oHeroWillJoin)
								end
							end
						else
							--������ɼ��룬�򲻼���
							local sText = hVar.tab_string["__TEXT_Can'tJoinTeam"]
							local tNname = hVar.tab_stringU[oHeroWillJoin.data.id]
							if tNname and type(tNname[1])=="string" then
								local s = sText
								sText = string.gsub(s,"@name@",tNname[1])
							end
							hGlobal.UI.MsgBox(sText,{style = "mini",ok = hVar.tab_string["__TEXT_Confirm"]})
						end
					elseif oHero==nil and oHeroWillJoin~=nil then
						--Ӣ�ۼ���ʿ���Ķ��飿���ڸ�Ц��
					else
						--ʿ������Ӣ�۵Ķ���
						local teamAdd = {}
						if u.data.team~=0 then
							local tTeam = u.data.team
							for i = 1,#tTeam do
								if type(tTeam[i])=="table" then
									local tabU = hVar.tab_unit[tTeam[i][1]]
									if tabU and tabU.attr and (tabU.attr.hp or 0)>0 then
										teamAdd[#teamAdd+1] = {tTeam[i][1],tTeam[i][2]}
									end
								end
							end
						end
						local JoinSus = 1
						if #teamAdd==0 then
							--_DEBUG_MSG("û�е�λ������")
							u:beforedead(t)
							u:dead()	--����ļ
						elseif t:teamaddunit(teamAdd)==hVar.RESULT_SUCESS then
							--_DEBUG_MSG("��λ�ɹ������˶���")
							u:beforedead(t)
							u:dead()	--����ļ
							hGlobal.event:call("Event_UnitJoinTeam",t,u,teamAdd)
						else
							--_DEBUG_MSG("�������ʧ�ܣ���������")
							JoinSus = 0
						end
						--������Ҳ��ż�������
						if JoinSus==1 and t:getowner()==hGlobal.LocalPlayer then
							hApi.PlaySound("army")
						end
						hApi.RefreshCombatScore(t)
					end
				end
			end
		elseif nPlayerToJoin~=nil and hGlobal.player[nPlayerToJoin]~=nil and oUnitWillJoin:getowner()~=hGlobal.player[nPlayerToJoin] then
			--����ĳ�����
			local cU = hApi.SetObject({},oUnitWillJoin)
			if oUnitWillJoin.data.type==hVar.UNIT_TYPE.HERO then
				--Ӣ�ۼ���
				vTalk[#vTalk+1] = function()
					local u = hApi.GetObject(cU)
					if u and u:gethero() then
						local oHeroWillJoin = u:gethero()
						--������Ҳ��ż�������
						if hGlobal.LocalPlayer==hGlobal.player[nPlayerToJoin] then
							hApi.PlaySound("army")
						end
						--ת������
						_DEBUG_MSG("Ӣ�۳�Ϊ�����"..nPlayerToJoin.."���Ѿ�")
						oHeroWillJoin:setowner(nPlayerToJoin)
						if CanLoadHeroCard==1 and oHeroWillJoin.data.HeroCard~=1 and hGlobal.LocalPlayer==hGlobal.player[nPlayerToJoin] then
							local tHeroCard,IsHaveCard = oHeroWillJoin:LoadHeroFromCard("join")
							if tHeroCard then
								--oHeroWillJoin.data.HeroCard = 1
							end
							--���û�����Ƭ�Ļ���������Ƭ����¼�
							if IsHaveCard~=1 and CanGetHeroCard==1 then
								hGlobal.event:call("LocalEvent_GetHeroCard",oHeroWillJoin)
							end
						end
					end
				end
			elseif oUnitWillJoin.data.type==hVar.UNIT_TYPE.UNIT then
				--��ͨ��λ����
				vTalk[#vTalk+1] = function()
					local u = hApi.GetObject(cU)
					if u then
						--������Ҳ��ż�������
						if hGlobal.LocalPlayer==hGlobal.player[nPlayerToJoin] then
							hApi.PlaySound("army")
						end
						_DEBUG_MSG("��λ��Ϊ�����"..nPlayerToJoin.."���Ѿ�")
						u:setowner(nPlayerToJoin)
					end
				end
			elseif oUnitWillJoin.data.type==hVar.UNIT_TYPE.BUILDING then
				--��������
				vTalk[#vTalk+1] = function()
					local u = hApi.GetObject(cU)
					if u then
						--������Ҳ��ż�������
						if hGlobal.LocalPlayer==hGlobal.player[nPlayerToJoin] then
							hApi.PlaySound("army")
						end
						_DEBUG_MSG("������Ϊ�����"..nPlayerToJoin.."���Ѿ�")
						hGlobal.event:call("Event_PlayerGetBuilding",u:getworld(),hGlobal.player[nPlayerToJoin],u)
					end
				end
			elseif oUnitWillJoin.data.type==hVar.UNIT_TYPE.GROUP then
				--��������
				vTalk[#vTalk+1] = function()
					local u = hApi.GetObject(cU)
					if u then
						_DEBUG_MSG("������Ϊ�����"..nPlayerToJoin.."���Ѿ�")
						u:setowner(nPlayerToJoin)
					end
				end
			end
		end
	end
end

--ֱ�Ӽ���
_tgr["@join:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--Ӣ�۲��ܼ���������λ�Ķ��飡
		--�����ÿ�Ƭ
		if oUnitWillJoin and oUnitWillJoin:gethero()~=nil then
			oUnitToJoin = nil
			CanGetHeroCard = 1
			DiscountForHeroCard = 0
		else
			DiscountForHeroCard = 0
		end
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--ֱ�Ӽ���
_tgr["@joinP:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin = tonumber(TagData)
	local oUnitWillJoin = oTargetX
	local oUnitToJoin = nil
	local CanGetHeroCard = 1
	local DiscountForHeroCard = 0
	if type(nPlayerToJoin)=="number" and hGlobal.player[nPlayerToJoin] then
		return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
	end
end

--���룬���ǲ��ܻ�ÿ�Ƭ
_tgr["@joinU:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin = tonumber(TagData)
	local oUnitWillJoin = oTargetX
	local oUnitToJoin = nil
	local CanGetHeroCard = 0
	local DiscountForHeroCard = 0
	if type(nPlayerToJoin)=="number" and hGlobal.player[nPlayerToJoin] then
		return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
	end
end

--���뵽������
_tgr["@jointeam:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--���ģʽ��Ӣ�ۿ��Լ���������λ�Ķ���
		DiscountForHeroCard = 0
		CanGetHeroCard = 0
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--���뵽������,���Ҽ�鿨Ƭ
_tgr["@jointeamC:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--���ģʽ��Ӣ�ۿ��Լ���������λ�Ķ���
		DiscountForHeroCard = 0
		CanGetHeroCard = 1
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--���뵽������,���Ҽ�鿨Ƭ,���û�п�Ƭ����ۿ۹���
_tgr["@jointeamB:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--���ģʽ��Ӣ�ۿ��Լ���������λ�Ķ���
		DiscountForHeroCard = 1
		CanGetHeroCard = 1
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--���뵽������(�����Ӣ�ۣ���ô����ȡӢ�ۿ�Ƭ)
_tgr["@jointeamU:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 0	--��ͼ�ϵĵ�λ������ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--���ģʽ��Ӣ�ۿ��Լ���������λ�Ķ���
		DiscountForHeroCard = 0
		CanGetHeroCard = 0
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--�뿪����
_tgr["@leaveteam:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nNeedShow = tonumber(TagData) or 1
	local cx,cy
	if TagParam~="" then
		local _,_,x,y = string.find(TagParam,"(%--%d+),(%--%d+)")
		if x then
			cx = tonumber(x)
			cy = tonumber(y)
		end
	end
	local oTargetX__ID = oTargetX.__ID
	local oWorld = oTargetX:getworld()
	local oHero = oTargetX:gethero()
	vTalk[#vTalk+1] = function()
		if oWorld and oWorld.ID~=0 and oHero and oHero.data.HeroTeamLeader~=0 then
			local oHeroL = hClass.hero:find(oHero.data.HeroTeamLeader)
			if oHeroL then
				oHeroL:teamremovemember(oHero)
				--�����λ��Ȼ���
				if oTargetX__ID==oTargetX.__ID then
					if nNeedShow==0 then
						oTargetX:sethide(1)
					else
						oTargetX:sethide(0)
						oTargetX:setmovepoint("newday")
						
						local oTargetL = oHeroL:getunit("worldmap")
						if cx==nil and oTargetL then
							cx,cy = oTargetL:getXY()
						end
						if cx then
							local wx, wy = hApi.Scene_GetSpace(cx, cy, 60)
							local gx, gy = oWorld:xy2grid(wx,wy)
							local moveX,moveY = oWorld:safeGrid(gx,gy)
							oTargetX:setgrid(moveX,moveY)
							oTargetX:movetogrid(moveX,moveY,nil,hVar.OPERATE_TYPE.UNIT_MOVE)
						end
					end
				end
				if oHero.heroUI["movepoint"]~=nil then
					hGlobal.event:event("LocalEvent_HeroMovePointUpdate",oHero)
				end
				if oHero.heroUI["btnIcon"]~=nil then
					hGlobal.event:event("LocalEvent_UpdateAllHeroIcon")
				end
			end
		end
	end
end

--���ۿ۹���Ӣ��
_tgr["@HeroCardJoin:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local CanLoadHeroCard = 1	--���Ӣ�ۿ��Զ�ȡ��ҿ�Ƭ
	local nPlayerToJoin
	local oUnitWillJoin
	local oUnitToJoin
	local CanGetHeroCard
	local DiscountForHeroCard
	if vTalk.id[1]==0 or vTalk.id[2]==0 then
		--�����Ͳ����ںϷ�Ŀ��İ�
	else
		nPlayerToJoin,oUnitWillJoin,oUnitToJoin = __CodeCheckUnitJoin(TagData,oUnit,oTarget,oTargetX)
		--Ӣ�۲��ܼ���������λ�Ķ��飡
		--�����ÿ�Ƭ
		if oUnitWillJoin and oUnitWillJoin:gethero()~=nil then
			oUnitToJoin = nil
			CanGetHeroCard = 1
			DiscountForHeroCard = 1
		else
			DiscountForHeroCard = 1
		end
		--�Լ������Լ���Ҫ������?
		if oUnitToJoin==oUnitWillJoin then
			return
		end
	end
	return __CodeUnitJoin(vTalk,nPlayerToJoin,oUnitWillJoin,oUnitToJoin,CanGetHeroCard,CanLoadHeroCard,DiscountForHeroCard)
end

--ʤ��
_tgr["@Victory:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local _oWorld = hApi.SetObject({},hGlobal.WORLD.LastWorldMap)
	--local LastString
	--for i = #vTalk,1,-1 do
		--if type(vTalk[i])=="string" then
			--LastString = vTalk[i]
			--break
		--end
	--end
	if oUnit:getowner()==hGlobal.LocalPlayer and oTargetX:getowner()~=hGlobal.LocalPlayer and type(vTalk.tBattleLog)=="table" then
		if LuaAddLootRecordFromUnit(g_curPlayerName,"MapFinalBoss","BFSkillCard")==1 then
			local nDayCount = hGlobal.WORLD.LastWorldMap.data.roundcount + 1
			local tLoot = {}
			local nCombatScore = 0
			local tBattleLog = vTalk.tBattleLog
			for i = 1,#tBattleLog do
				local v = tBattleLog[i]
				if v.key=="EnterBattle" and v.unit.owner==oTargetX.data.owner then
					nCombatScore = v.CombatScoreBasic
					break
				end
			end
			if nCombatScore>0 then
				--local nTacticsId,nTacticsLv,cExtra = hApi.RandomTacticsId(oTargetX,hGlobal.WORLD.LastWorldMap,99999)
				--if nTacticsId>0 and nTacticsLv>0 then
					--tLoot[#tLoot+1] = {"battlefieldskill",nTacticsId,nTacticsLv}
				--end
				for i = 1,3 do
					local r = hApi.random(1,100)
					if i==1 or r<=(10+nDayCount*(11-i*3)) then
						local nTacticsId,nTacticsLv,cExtra = hApi.RandomTacticsId(oTargetX,hGlobal.WORLD.LastWorldMap,nCombatScore)
						if nTacticsId>0 and nTacticsLv>0 then
							tLoot[#tLoot+1] = {"battlefieldskill",nTacticsId,nTacticsLv}
						end
					end
				end
			end
			if #tLoot>0 then
				local n = #vTalk
				vTalk[n+1] = 0
				vTalk[n+2] = 0
				for i = n,1,-1 do
					vTalk[i+2] = vTalk[i]
				end
				vTalk[1] = function(tFunc)
					tFunc.ShowLoot(tLoot,1,function(tSelect)
						--local tLootX= {}
						local id,lv = 0,0
						local v = tLoot[tSelect[1]]
						if v then
							id = v[2]
							lv = v[3]
						end
						if id>0 and lv>0 and hVar.tab_tactics[id] then
							lv = math.min((hVar.tab_tactics[id].level or 1),lv)
							hUI.Disable(550,"ʰȡս�����ܿ�")
							hApi.addTimerOnce("__WM__PickBattlefieldSkill",250,function()
								
								hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{id,lv}},nil,nil,1)
								
							end)
						end
					end)
				end
				vTalk[2] = hVar.tab_string["__TEXT_PleaseSelectAReward"]
			end
		end
	end
	vTalk[#vTalk+1] = function()
		local w = hApi.GetObject(_oWorld)
		if w then
			w:pause(1,"Victory")
		end
		hApi.addTimerOnce("__WM__SpecialVictory",500,function()
			local w = hApi.GetObject(_oWorld)
			if w then
				w:pause(1,"Victory")
				heroGameRule.OnGameOver(true)
			end
		end)
	end
end

--����Ӣ��
--_tgr["@CopyUnit:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--local oTargetX__ID = oTargetX.__ID
	--vTalk[#vTalk+1] = function()
		--local w = hGlobal.WORLD.LastWorldMap
		--local uID = tonumber(TagData)
		--if w and oTargetX__ID==oTargetX.__ID and type(uID)=="number" then
			--local oCopyUnit = w:tgrid2unit(uID)
			--if oCopyUnit then
				--local oHero = oTargetX:gethero()
				--local oHeroCopy = oCopyUnit:gethero()
				--if oHero and oHeroCopy then
					----����Ӣ�����ԣ�����װ�������ܵ�
					--local lv = 
				--end
				
			--end
		--end
	--end
--end

--ʧ��
_tgr["@Defeat:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local _oWorld = hApi.SetObject({},hGlobal.WORLD.LastWorldMap)
	vTalk[#vTalk+1] = function()
		local w = hApi.GetObject(_oWorld)
		if w then
			w:pause(1,"Defeat")
		end
		hApi.addTimerOnce("__WM__SpecialVictory",500,function()
			local w = hApi.GetObject(_oWorld)
			if w then
				w:pause(1,"Defeat")
				heroGameRule.OnGameOver(false)
			end
		end)
	end
end

--ʤ��������Ϊ����
_tgr["@DisableVictory:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--��ֹ����ʤ��
	local _oWorld = hApi.SetObject({},hGlobal.WORLD.LastWorldMap)
	vTalk[#vTalk+1] = function()
		local w = hApi.GetObject(_oWorld)
		if w then
			w.data.IsNormalVictory = 0
		end
	end
end

--׷��
_tgr["@Hunter:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero==nil then
		_DEBUG_MSG("[LUA WARNING]�ڴ�������ʹ��Ӣ�۵�λ����׷��"..tostring(oTargetX.data.id))
	else
		vTalk[#vTalk+1] = function()
			oHero.data.AIMode = hVar.AI_MODE.CHASE
			local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if u then
				oHero.data.AIExtData = hApi.SetObjectUnit({},u)
			end
		end
	end
end

_tgr["@RSDYZchoiceHeros:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--print("RRRRRRRRRRRR",TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--local oHero = oTargetX:gethero()
	--if oHero==nil then
		--_DEBUG_MSG("[LUA WARNING]�ڴ�������ʹ��Ӣ�۵�λ����׷��"..tostring(oTargetX.data.id))
	--else
		--vTalk[#vTalk+1] = function()
			--oHero.data.AIMode = hVar.AI_MODE.CHASE
			--local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			--if u then
				--oHero.data.AIExtData = hApi.SetObjectUnit({},u)
			--end
		--end
	--end
	--print(oUnit.data.id,oTarget.data.id)
	local oTarget__ID = oTarget.__ID
	local ox,oy = oTarget:getXY()
	local tid = oTarget.data.triggerID or 0
	vTalk[#vTalk+1] = function()
		if oTarget__ID ~= oTarget.__ID then
			--print("tp1")
			hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm_2",tonumber(TagData),ox,oy,tid)
		else
			--print("tp2")
			hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm",tonumber(TagData),oTarget)
		end
	end
end

--����
_tgr["@Chase:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero==nil then
		_DEBUG_MSG("[LUA WARNING]�ڴ�������ʹ��Ӣ�۵�λ������"..tostring(oTargetX.data.id))
	else
		vTalk[#vTalk+1] = function()
			oHero.data.AIMode = hVar.AI_MODE.DIRECT_CHASE
			local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if u then
				oHero.data.AIExtData = hApi.SetObjectUnit({},u)
			end
		end
	end
end

_tgr["@Policy_Chase:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero==nil then
		_DEBUG_MSG("[LUA WARNING]�ڴ�������ʹ��Ӣ�۵�λ������"..tostring(oTargetX.data.id))
	else
		vTalk[#vTalk+1] = function()
			oHero.data.AIMode = hVar.AI_MODE.POLICY_CHASE
			local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if u then
				oHero.data.AIExtData = hApi.SetObjectUnit({},u)
			end
		end
	end
end

--����
_tgr["@Defense:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero==nil then
		_DEBUG_MSG("[LUA WARNING]�ڴ�������ʹ��Ӣ�۵�λ��������"..tostring(oTargetX.data.id))
	else
		vTalk[#vTalk+1] = function()
			oHero.data.AIMode = hVar.AI_MODE.GUARD_CITY
			local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if u then
				oHero.data.AIExtData = hApi.SetObjectUnit({},u)
			end
		end
	end
end

----���������
--_tgr["@WorldRandomGroup:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
--	if TagData~="" then
--		local SelectTemp = {}
--		local PassNum = tonumber(TagData)
--		if type(PassNum)=="number" and PassNum>0 then
--			for i = 1,PassNum do
--				SelectTemp[#SelectTemp+1] = cTalk[cIndex+i]
--			end
--		else
--			PassNum = nil
--			SelectTemp[#SelectTemp+1] = TagData
--		end
--		if #SelectTemp>0 then
--			local w = hGlobal.WORLD.LastWorldMap
--			local w__ID = w.__ID
--			vTalk[#vTalk+1] = function()
--				if w.__ID==w__ID then
--					w.data.RandomGroupTag = tostring(SelectTemp[w:random(1,#SelectTemp)])
--				end
--			end
--		end
--		return PassNum
--	end
--end

--��ʾ
_tgr["@show:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tarID
	if TagData~="" then
		tarID = tonumber(TagData)
	else
		tarID = oTargetX.data.triggerID
	end
	vTalk[#vTalk+1] = function()
		local u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tarID)
		if u then
			--��ֹ��ʾ����
			local oHero = u:gethero()
			if oHero and oHero.data.HeroTeamLeader~=0 then
				return
			end
			u:sethide(0)
		end
	end
end

--����
_tgr["@hide:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tarID
	if TagData~="" then
		tarID = tonumber(TagData)
	else
		tarID = oTargetX.data.triggerID
	end
	vTalk[#vTalk+1] = function()
		local u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tarID)
		if u then
			u:sethide(1)
		end
	end
end

--��ʾ(ǿ��)
_tgr["@ShowById:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tUnitId = {}
	for id in string.gfind(TagData,"(%d+)") do
		tUnitId[tonumber(id)] = 1
	end
	local tBoxList = hGlobal.TGR_FUNC.GetBoxByCmd(TagParam)
	if #tBoxList>0 then
		vTalk[#vTalk+1] = function()
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				local tUnit = {}
				oWorld:enumunit(function(u)
					if tUnitId[u.data.id]==1 and u.data.IsHide==1 then
						local cx,cy = u:getXY()
						for i = 1,#tBoxList do
							if hApi.IsInBox(cx,cy,tBoxList[i]) then
								tUnit[#tUnit+1] = u
								return
							end
						end
					end
				end)
				for i = 1,#tUnit do
					local u = tUnit[i]
					--��ֹ��ʾ����
					local oHero = u:gethero()
					if oHero and oHero.data.HeroTeamLeader~=0 then
						return
					end
					u:sethide(0)
				end
			end
		end
	end
end

--��ʾ(ǿ��)
_tgr["@HideById:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tUnitId = {}
	for id in string.gfind(TagData,"(%d+)") do
		tUnitId[tonumber(id)] = 1
	end
	local tBoxList = hGlobal.TGR_FUNC.GetBoxByCmd(TagParam)
	if #tBoxList>0 then
		vTalk[#vTalk+1] = function()
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				local tUnit = {}
				oWorld:enumunit(function(u)
					if tUnitId[u.data.id]==1 and u.data.IsHide==0 then
						local cx,cy = u:getXY()
						for i = 1,#tBoxList do
							if hApi.IsInBox(cx,cy,tBoxList[i]) then
								tUnit[#tUnit+1] = u
								return
							end
						end
					end
				end)
				for i = 1,#tUnit do
					local u = tUnit[i]
					u:sethide(1)
				end
			end
		end
	end
end

--��ʾ��������ֻ���ڻ��ܵ��˺���Ч
_tgr["@DeadAnimation:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		hApi.ClearLocalDeadIllusion()
	end
end

--�۽�ĳ����λ
_tgr["@focus:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local t = oTargetX
	local tgrID
	if TagData~="" then
		tgrID = tonumber(TagData)
	end
	if tgrID then
		t = hApi.UniqueID2UnitByWorld(tgrID)
	end
	if t and t.handle._c then
		local x,y = t:getXY()
		vTalk[#vTalk+1] = function()
			if hGlobal.LocalPlayer:getfocusworld()==hGlobal.WORLD.LastWorldMap then
				xlClearFogByPoint(x,y)
				hApi.setViewNodeFocus(x,y)
			end
		end
	end
end

--�ٻ����С���
_tgr["@RecruitDude:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local index = string.find(TagData,"|")
	local p1 = string.sub(TagData,1,index-1)
	local p2 = string.sub(TagData,index+1,string.len(TagData))
	vTalk[#vTalk+1] = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld==nil then
			return
		end
		local u = hApi.UniqueID2UnitByWorld(tonumber(p1))
		local legion = tonumber(p2)
		local mapname = hGlobal.WORLD.LastWorldMap.data.map
		local legionList = hVar.MAP_LEGION[mapname]
		local lt,templ = {},{}
		--��ȡ��ѡ������
		for i = 1,#legionList do
			if legionList[i][1] == legion then
				templ = legionList[i][3] or {}
				break
			end
		end
		--������Լ���Ӣ����ID
		if u then
			for i = 1,#templ do
				if templ[i] ~= u.data.id then
					lt[#lt+1] = templ[i]
				end
			end
		end
		if lt and #lt > 0 then
			local r = hApi.random(1,#lt)
			local id = lt[r]
			
			local wx,wy = u:getstopXY()
			local worldX,worldY = wx+hApi.random(-2,2)*24,wy+hApi.random(-2,2)*24
			local du = oWorld:addunit(id,oTargetX.data.owner,nil,nil,hVar.UNIT_DEFAULT_FACING,worldX,worldY,nil,{name=hVar.tab_stringU[id][1]})
			if du then
				--local c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,3,id,worldX,worldY,hVar.UNIT_DEFAULT_FACING,nil,{name=hVar.tab_stringU[id][1]})
				--local du = hApi.findUnitByCha(c)
				du.data.team = hApi.InitUnitTeam()
				du.data.team[1] = {id}
				local teamAdd = {}
				for k,v in pairs(u.data.team) do
					if type(v) == "table" and hVar.tab_unit[v[1]].type ~= hVar.UNIT_TYPE.HERO then
						teamAdd[#teamAdd+1] = v
					end
				end
				du:teamaddunit(teamAdd)
				local duHero = hClass.hero:new({
					name = hVar.tab_stringU[id][1],
					id = id,
					owner = oTargetX.data.owner,
					unit = du,
					playmode = oWorld.data.playmode,
				})
				local oHero = u:gethero()
				local tgrDataU = u:gettriggerdata()
				if tgrDataU then
					duHero:loadtriggerdata(tgrDataU)
				else
					duHero:levelup(oHero.attr.level,0)
				end
			end
		end
	end
end

--����
_tgr["@LeaveTown:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oUnitToLeave
	local tgrID = tonumber(TagData)
	if tgrID then
		oUnitToLeave = hApi.UniqueID2UnitByWorld(tgrID)
	else
		oUnitToLeave = oTargetX
	end
	if oUnitToLeave then
		local __ID = oUnitToLeave.__ID
		vTalk[#vTalk+1] = function()
			if oUnitToLeave.ID~=0 and oUnitToLeave.__ID==oUnitToLeave.__ID then
				local u = oUnitToLeave
				local t = u.data.curTown
				local oTown = hClass.town:find(t)
				if oTown then
					oTown:setguard(nil)
					oTown:setvisitor(u)
				end
			end
		end
	end
end

--����
_tgr["@EnterTown:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local __ID = oTargetX.__ID
	vTalk[#vTalk+1] = function()
		if oTargetX.ID~=0 and oTargetX.__ID==oTargetX.__ID then
			local oUnitTown = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if oUnitTown then
				local oTown = oUnitTown:gettown()
				if oTown then
					local oUnitGuard = oTown:getunit("guard")
					if oUnitGuard then
						oTown:setguard(nil)
						oTown:setvisitor(oUnitGuard)
					end
					oTown:setguard(oTargetX)
				end
			end
		end
	end
end

--���ʳ�
_tgr["@VisitTown:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local __ID = oTargetX.__ID
	vTalk[#vTalk+1] = function()
		if oTargetX.ID~=0 and oTargetX.__ID==oTargetX.__ID then
			local oUnitTown = hApi.UniqueID2UnitByWorld(tonumber(TagData))
			if oUnitTown then
				local oTown = oUnitTown:gettown()
				if oTown then
					local oUnitVisitor = oTown:getunit("visitor")
					if oUnitVisitor then
						oTown:setvisitor(nil)
					end
					oTown:setvisitor(oTargetX)
				end
			end
		end
	end
end

_tgr["@CreateArmyByGroup:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local pList = {}
	for TagData in string.gfind(TagData,"([^%|]+)|+") do
		pList[#pList+1] = tonumber(TagData)
	end

	local uID = pList[1]		--�����UID
	local ArmyID = pList[2]		--����������ֵı� �� tab.unitID ���� ���ж���� ���ȡarmy ��� ս����
	local owner = pList[3]		--��uID ��owner ���ڴ�ֵʱ ���
	local ArmyScore = 0			--ս����
	local GroupList = {}
	local ArmyList = {}		--������ֱ�

	if hVar.tab_unit[ArmyID] and type(hVar.tab_unit[ArmyID].score) == "table" and type(hVar.tab_unit[ArmyID].group) == "table" then
		GroupList = hVar.tab_unit[ArmyID].group or {}
		local r = hApi.random(1,#GroupList)
		if GroupList[r] then
			ArmyList[#ArmyList+1] = 0
			for i = 2,#GroupList[r] do
				ArmyList[#ArmyList+1] = GroupList[r][i]
			end
		end
		ArmyScore = hApi.random(hVar.tab_unit[ArmyID].score[1],hVar.tab_unit[ArmyID].score[2])
	end

	--������ȷ��ս���� �� ���ӱ�ʱ
	if ArmyScore>0 and #ArmyList > 0 then
		vTalk[#vTalk+1] = function()
			local u = hApi.UniqueID2UnitByWorld(uID)
			if u and u.data.owner == owner then
				 hApi.CreateArmyByGroup(u:getworld(),nil,u,{ArmyList},ArmyScore,u:getworld().data.MonGrowth/1000)
			end
		end
	end

end

--�ڽ�������ʱ������Щ��ǩ�ĶԻ������ᱻ�Զ�����
_tgr["@IgnoreTalk:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" then
		local oHero__ID = oHero.__ID
		vTalk[#vTalk+1] = function()
			if oHero__ID==oHero.__ID then
				if type(oHero.data.IgnoredTalk)~="table" then
					oHero.data.IgnoredTalk = {}
				end
				oHero.data.IgnoredTalk[#oHero.data.IgnoredTalk+1] = TagData
			end
		end
	end
end

--�������û�б�����ң���ô�������µļ����Ի�
_tgr["@IfNoPlayerHeroNearThenPass:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nDis = tonumber(TagData)
	local PassNum = tonumber(TagParam)
	local IsPass = 1
	if type(nDis)=="number" and nDis>0 then
		local tHero = hGlobal.LocalPlayer.heros
		if tHero and #tHero>0 then
			local cx,cy = oTargetX:getXY()
			for i = 1,#tHero do
				local v = tHero[i]
				if type(v)=="table" and v.ID~=0 then
					local u = v:getunit("worldmap")
					if u and u.data.IsDead~=1 and ((u.data.curTown==0 and u.data.IsHide~=1) or (u.data.curTown~=0 and u.data.IsHide==1)) then
						local ux,uy = u:getXY()
						--print(nDis, math.floor(math.sqrt((cx-ux)^2+(cy-uy)^2)),PassNum)
						if math.floor(math.sqrt((cx-ux)^2+(cy-uy)^2))<=nDis then
							IsPass = 0
							break
						end
					end
				end
			end
		end
	end
	if IsPass==1 and type(PassNum)=="number" and PassNum>0 then
		return PassNum
	end
end

--���Ŀ���AIģʽ����������������������ļ����Ի�
--_tgr["@IfNotAIModeThenPass:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--local AIMode = tonumber(TagData)
	--local PassNum = tonumber(TagParam)
	--local IsPass = 0
	----�����ָ���Ķ���AI
	--local oHero = oTarget:gethero()
	--if oHero then
		--if oHero.data.AIEXtDataChangeAIMode~=-1 then
			--if oHero.data.AIEXtDataChangeAIMode~=AIMode then
				--IsPass = 1
			--end
		--else
			--if oHero.data.AIMode~=AIMode then
				--IsPass = 1
			--end
		--end
	--end
	--if IsPass==1 and type(PassNum)=="number" and PassNum>0 then
		--return PassNum
	--end
--end


--�ı�AIģʽ
_tgr["@ChangeAImode:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local u = oTargetX
	local u__ID = oTargetX.__ID
	local nMode = tonumber(TagData) or 0
	vTalk[#vTalk+1] = function()
		if u.__ID==u__ID then
			local oHero = u:gethero()
			if oHero then
				--����ڳ�����������˷��سǵ�AI����ô�ȳ���
				if oHero.data.AIMode==hVar.AI_MODE.GUARD and u.data.curTown~=0 and nMode~=hVar.AI_MODE.GUARD then
					local oTown = hClass.town:find(u.data.curTown)
					if oTown and oTown:getunit("guard")==u then
						oTown:setguard(nil)
						oTown:setvisitor(u)
					end
				end
				oHero.data.AIMode = nMode
				oHero.data.AIEXtDataChangeAIMode = nMode
			end
		end
	end
end

_tgr["@ChangeAImodeByUniqueID:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local pList = {}
		for TagData in string.gfind(TagData,"([^%|]+)|+") do
			pList[#pList+1] = tonumber(TagData)
		end

		local uID = pList[1]
		local nMode = pList[2]

		local u = hApi.UniqueID2UnitByWorld(tonumber(uID))
		if u then
			local oHero = u:gethero()
			if oHero then
				--����ڳ�����������˷��سǵ�AI����ô�ȳ���
				if oHero.data.AIMode==hVar.AI_MODE.GUARD and u.data.curTown~=0 and nMode~=hVar.AI_MODE.GUARD then
					local oTown = hClass.town:find(u.data.curTown)
					if oTown and oTown:getunit("guard")==u then
						oTown:setguard(nil)
						oTown:setvisitor(u)
					end
				end
				oHero.data.AIMode = nMode
				oHero.data.AIEXtDataChangeAIMode = nMode
			end
		end
	end
end

--��ʱ֧����������������ʽ
_tgr["@ChangAImode:"] = _tgr["@ChangeAImode:"]

--�ı䶯��
_tgr["@Animation:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local t = oTargetX
	local t__ID = t.__ID
	local sAnimation = TagData
	local tabU = hVar.tab_unit[t.data.id]
	if tabU then
		vTalk[#vTalk+1] = function()
			if t.ID~=0 and t__ID==t.__ID and t.data.IsDead~=1 then
				if tabU.xlobj~=nil then
					--��xlobjģʽ�ĵ�λ
					if xlCha_ShiftBuildingFrame and t.handle._c~=nil then
						if TagData=="0" then
							t.data.animationTag = 0
							xlCha_ShiftBuildingFrame(t.handle._c,0)
						else
							t.data.animationTag = 1
							xlCha_ShiftBuildingFrame(t.handle._c,1)
						end
					end
				else
					t:setanimation(sAnimation)
				end
			end
		end
	end
end

--���ɾ�(��ǰ��)
local teamT = {}--���ֱ�
local bigOrSmallT = {}--��С��ϵ��
local numberT = {}--������
_tgr["@checkMedal:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--�����н���id
	if TagData=="" then
		return
	end
	local MedalID = tonumber(TagData)--ѫ�º�
	local medal = hVar.tab_medal[MedalID]--ѫ��
	if medal==nil then
		return
	end
	vTalk[#vTalk+1] = function()
		if LuaGetPlayerMedal(hVar.MEDAL_TYPE[MedalID]) < 1 then--��ѫ��û���
			if medal["conditions"] ~= nil then
				local bLight = 0--�Ƿ������ѫ�� �����ۼ� ���ѫ��Ҫ3������ ���bRight == 3�ű�ʾ��Ҫ����
				local bRight = {}--�������ѫ����3������ {0,0,0} ��������{1,1,1}�ű�ʾͨ��
				for i = 1,#medal["conditions"] do
					teamT = {}--����ֱ�
					bigOrSmallT = {}--���С��ϵ��
					numberT = {}--��������
					bRight[#bRight+1] = 0
					local conditionsStr = medal["conditions"][i][1]--��õ���Ҫ��
					if conditionsStr == "noLost" then--����
						local lostTemp = {}
						if vTalk.tBattleLog then
							for j = 1,#vTalk.tBattleLog do
								local v = vTalk.tBattleLog[j]
								if (v.key=="unit_damaged" or v.key=="hero_damaged") and v.target.indexOfTeam~=0 then
									local tabU = hVar.tab_unit[v.target.id]
									if tabU then
										local a = oUnit:getowner():allience(hGlobal.player[v.target.owner])
										if a==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
											if v.lost>0 then
												lostTemp[v.target.id] = (lostTemp[v.target.id] or 0) + v.lost
											end
										end
									end
								end
							end
							for j = 1,#vTalk.tBattleLog do
								local v = vTalk.tBattleLog[j]
								if v.key=="unit_healed" then
									for k,v1 in pairs(lostTemp) do
										if k == v.target.id then
											lostTemp[k] = v1 - v.revive
										end
									end
								end
							end
						end

						local lostUnits = {}
						for k,v in pairs(lostTemp)do
							if v > 0 then
								lostUnits[#lostUnits+1] = {k,v}
							end
						end
						if #lostUnits == 0 then
							bRight[#bRight] = 1
						end
					elseif conditionsStr == "EnterInTeam" then--��ʼս����������
						local conditionNum = #medal["conditions"][i]
						for j = 2,conditionNum do
							if j%2 == 0 then
								teamT[#teamT + 1] = medal["conditions"][i][j]--��Ҫ����Щ����
							elseif j%2 == 1 then
								dealNumberRelT(medal["conditions"][i][j],bigOrSmallT,numberT)--��С��ϵ �ͱȽ�����
							end
						end
						local thisArmyNum = {}
						for j = 1,#teamT do
							thisArmyNum[j] = 0
						end
						if vTalk.tBattleLog then
							for j = 1,#vTalk.tBattleLog do
								local v = vTalk.tBattleLog[j]
								if v.key=="EnterBattle" then
									if v.unit.owner == 1 then -- ���1 �Լ�
										for teamIndex = 1,#v.team do
											if v.team[teamIndex] ~= 0 then
												local teamId = v.team[teamIndex][1]
												local teamNun = v.team[teamIndex][2]
												
												for check = 1,#teamT do
													if teamId == teamT[check] then
														thisArmyNum[check] = thisArmyNum[check] + teamNun
													end
												end
											end
										end
									end
								end
							end
						end

						for j = 1,#thisArmyNum do
							if bigSmallEqual(thisArmyNum[j],numberT[j],bigOrSmallT[j]) == 1 then
								bRight[#bRight] = 1
								break
							end
						end
					elseif conditionsStr == "EnterInTeamOnly" then--��ʼս��������ֻ��
						local conditionNum = #medal["conditions"][i]
						local hasOther = 0--����������
						for j = 2,conditionNum do
							if j%2 == 0 then
								teamT[#teamT + 1] = medal["conditions"][i][j]--��Ҫ����Щ����
							elseif j%2 == 1 then
								dealNumberRelT(medal["conditions"][i][j],bigOrSmallT,numberT)--��С��ϵ �ͱȽ�����
							end
						end
						local thisArmyNum = {}
						for j = 1,#teamT do
							thisArmyNum[j] = 0
						end

						if vTalk.tBattleLog then
							for j = 1,#vTalk.tBattleLog do
								local v = vTalk.tBattleLog[j]
								if v.key=="EnterBattle" then
									if v.unit.owner == 1 then -- ���1 �Լ�
										for teamIndex = 1,#v.team do
											if v.team[teamIndex] ~= 0 then
												local teamId = v.team[teamIndex][1]
												local teamNun = v.team[teamIndex][2]
												
												for check = 1,#teamT do
													if teamId == teamT[check] then
														thisArmyNum[check] = thisArmyNum[check] + teamNun
													end
													local checkOther = 0
													for z = 1,#teamT do
														if teamId == teamT[z] then
															checkOther = checkOther + 1
														end
													end
													if checkOther == 0 then
														if teamId ~= v.unit.leader_id then
															hasOther = 1
														end
													end
												end
											end
										end
									end
								end
							end
						end

						print("!!!"..hasOther)
						for j = 1,#thisArmyNum do
							if bigSmallEqual(thisArmyNum[j],numberT[j],bigOrSmallT[j]) == 1 and hasOther == 0 then
								bRight[#bRight] = 1
								break
							end
						end
					elseif conditionsStr == "LeaveInTeam" then--ս���Ҵ�

					elseif conditionsStr == "LeaveInTeamOnly" then--ս���Ҵ����

					elseif conditionsStr == "diff" then
						local difficultConditionStr = medal["conditions"][i][2]
						dealNumberRelT(difficultConditionStr,bigOrSmallT,numberT)
						bRight[#bRight] = bigSmallEqual(hGlobal.WORLD.LastWorldMap.data.MapDifficulty,numberT[1],bigOrSmallT[1])
					elseif conditionsStr == "day" then
						local dayStr = medal["conditions"][i][2]
						dealNumberRelT(dayStr,bigOrSmallT,numberT)
						bRight[#bRight] = bigSmallEqual(g_game_days,numberT[1],bigOrSmallT[1])
					end
				end
				--print(hGlobal.LastBattleLog == nil)
				for i = 1,#bRight do
					bLight = bLight + bRight[i]
				end
				if bLight == #bRight then--����
					--showBigMedalFrame(MedalID,1,1)
					LuaSetPlayerMedal(hVar.MEDAL_TYPE[MedalID],1)
					hGlobal.event:event("localEvent_TurnOnMedal_1_Griffin",MedalID)
				end
			end
		end
	end
end

--�������һ��Ӣ�� �����뵱ǰӢ��������λ��ͬ
--_tgr["@RandomBirth:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
--	vTalk[#vTalk+1] = function()
--		local id = oTargetX.data.id
--		local RHero = oTargetX:gethero()
--		local heroList = {}
--
--		if Save_PlayerData and Save_PlayerData.herocard then
--			for i = 1,#Save_PlayerData.herocard do
--				heroList[#heroList+1] = Save_PlayerData.herocard[i].id
--			end
--		end
--		
--		--���ݵ�ǰ��ҿ��Ƶ�Ӣ�۽���һ��ɸѡ
--		for _,v in pairs(hGlobal.LocalPlayer.heros) do
--			for i = 1,#heroList do
--				if v.data.id == heroList[i] then
--					heroList[i] = 0
--				end
--			end
--		end
--		
--		--�ٴӵ�ͼ�ļ���ɸѡ �����ֹѡ��Ӣ��
--		if hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].nohero then
--			local nohero = hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].nohero
--			for i = 1,#heroList do
--				for j = 1,#nohero do
--					if nohero[j] == heroList[i] then
--						heroList[i] = 0
--					end
--				end
--			end
--		end
--
--		local rList = {}
--		for i = 1,#heroList do
--			if heroList[i] ~= 0 then
--				rList[#rList+1] =  heroList[i]
--			end
--		end
--
--		local temp = {}
--		hApi.RandomIndex(#rList,#rList,temp)
--		local r = hApi.random(1,#rList)
--		id = rList[temp[r]]
--
--		local tgrDataU = oTargetX:gettriggerdata()
--		local worldX,worldY,facing = oTargetX.data.worldX,oTargetX.data.worldY,oTargetX.data.facing
--		if type(id) ~= "number" then return end
--		local oWorld = oTargetX:getworld()
--		local u = oWorld:addunit(id,oTargetX.data.owner,nil,nil,facing,worldX,worldY,nil,{name=hVar.tab_stringU[id][1],triggerID=oTargetX.data.triggerID })
--		if u then
--			u.data.team = hApi.InitUnitTeam()
--			u.data.team[1] = {id}
--
--			local uHero = hClass.hero:new({
--				name = hVar.tab_stringU[id][1],
--				id = id,
--				owner = oTargetX.data.owner,
--				unit = u,
--				playmode = oWorld.data.playmode,
--			})
--			
--			if tgrDataU then
--				uHero:loadtriggerdata(tgrDataU)
--			else
--				uHero:levelup(oHero.attr.level,0)
--			end
--			oTargetX:del()
--			RHero:del()
--		end
--	end
--end

-- �ı�uniqueID ��λ�����꣬�������ƶ���������
_tgr["@SetUnitPosition:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local pList = {}
		for TagData in string.gfind(TagData,"([^%|]+)|+") do
			pList[#pList+1] = tonumber(TagData)
		end
		local uID = pList[1]
		local worldX,worldY = pList[2],pList[3]
		local actionCount = pList[4]

		if hGlobal.WORLD.LastWorldMap.SetUnitPosList == nil then
			hGlobal.WORLD.LastWorldMap.SetUnitPosList = {}
			hGlobal.WORLD.LastWorldMap.SetUnitPosList[#hGlobal.WORLD.LastWorldMap.SetUnitPosList+1] = {uID,actionCount}
		elseif type(hGlobal.WORLD.LastWorldMap.SetUnitPosList) == "table" then
			local rs = 0
			for i = 1,#hGlobal.WORLD.LastWorldMap.SetUnitPosList do
				if hGlobal.WORLD.LastWorldMap.SetUnitPosList[i][1] == uID then
					rs = 1
				end
			end
			--��ǰ������û�д�����
			if rs == 0 then
				hGlobal.WORLD.LastWorldMap.SetUnitPosList[#hGlobal.WORLD.LastWorldMap.SetUnitPosList+1] = {uID,actionCount}
			end
		end
		
		for _,v in pairs(hGlobal.WORLD.LastWorldMap.SetUnitPosList) do
			if v[1] == uID and v[2] > 0 then
				local u = hApi.UniqueID2UnitByWorld(tonumber(uID))
				if u then
					local oWorld = u:getworld()
					local toX,toY = oWorld:xy2grid(worldX,worldY)
					local moveX,moveY = oWorld:safeGrid(toX,toY)
					u:setgrid(toX,toY)
					u:movetogrid(moveX,moveY,nil,hVar.OPERATE_TYPE.UNIT_MOVE)
					v[2] = v[2] - 1
				end
			end
		end
	end
end

_tgr["@SetXY:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local tPos = {}
	for sPos in string.gfind(TagData,"%(%d+,%d+%)") do
		local n = string.find(sPos,",")
		local mx = string.len(sPos)
		if n and n>2 and n<mx-1 then
			local x = tonumber(string.sub(sPos,2,n-1)) or 0
			local y = tonumber(string.sub(sPos,n+1,mx-1)) or 0
			tPos[#tPos+1] = {x,y}
		end
	end
	local oWorld = oTargetX:getworld()
	local oTargetX__ID = oTargetX.__ID
	vTalk[#vTalk+1] = function()
		if #tPos>0 and oTargetX.__ID==oTargetX__ID then
			local oWorld = oTargetX:getworld()
			if oWorld then
				local v = tPos[hApi.random(1,#tPos)]
				local x,y = v[1],v[2]
				if not(type(x)=="number" and type(y)=="number") then
					x = 0
					y = 0
				end
				local wx, wy = hApi.Scene_GetSpace(x, y, 60)
				local gx, gy = oWorld:xy2grid(wx,wy)
				local moveX,moveY = oWorld:safeGrid(gx,gy)
				oTargetX:setgrid(moveX,moveY)
				oTargetX:movetogrid(moveX,moveY,nil,hVar.OPERATE_TYPE.UNIT_MOVE)
			end
		end
	end
end

--׷��
_tgr["@HunterWithCount:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local pList = {}
		for TagData in string.gfind(TagData,"([^%|]+)|+") do
			pList[#pList+1] = tonumber(TagData)
		end

		local uID = pList[1]
		local tID = pList[2]
		local count = pList[3]

		local u = hApi.UniqueID2UnitByWorld(tonumber(uID))
		local t = hApi.UniqueID2UnitByWorld(tonumber(tID))
		local oHero = nil
		if u and t then 
			oHero = u:gethero()
			if oHero then
				if hGlobal.WORLD.LastWorldMap.HunterWithCount == nil then
					hGlobal.WORLD.LastWorldMap.HunterWithCount = {}
					hGlobal.WORLD.LastWorldMap.HunterWithCount[#hGlobal.WORLD.LastWorldMap.HunterWithCount+1] = {tID,count}
				elseif type(hGlobal.WORLD.LastWorldMap.HunterWithCount) == "table" then
					local rs = 0
					for i = 1,#hGlobal.WORLD.LastWorldMap.HunterWithCount do
						if tID == hGlobal.WORLD.LastWorldMap.HunterWithCount[i][1] then
							rs = 1
						end
					end

					if rs == 0 then
						hGlobal.WORLD.LastWorldMap.HunterWithCount[#hGlobal.WORLD.LastWorldMap.HunterWithCount+1] = {tID,count}
					end
					
				end

				for _,v in pairs(hGlobal.WORLD.LastWorldMap.HunterWithCount) do
					if v[1] == tID and v[2] > 0 then
						oHero.data.AIMode = hVar.AI_MODE.CHASE
						oHero.data.AIExtData = hApi.SetObjectUnit({},t)
						v[2] = v[2] - 1
					end
				end
			end
		end
	end
end

--ɱ��ĳ��λ
_tgr["@KillUnitByUniqueID:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local u = hApi.UniqueID2UnitByWorld(tonumber(TagData))
		if u then
			local sType = u.handle.__manager
			u:del()
			if sType=="xlobj" then
				hApi.SceneRefreshBuildingData(g_world)
			end
		end
	end
end

--ս������
_tgr["@Fightupgrade:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)

	vTalk[#vTalk+1] = function()
		local labX,labY = 470,600
		if g_phone_mode == 1 then
			labX,labY = 470,520
		elseif g_phone_mode == 2 then
			labX,labY = 560,520
		end

		local tip = hUI.image:new({
			--mode = "file",
			model = "UI:card_select_back",
			animation = "normal",
			align = "MC",
			x = labX,
			y = labY,
			h = 64,
			scale = 1.5,
		})

		--ս
		local zhan = hUI.label:new({
			parent = tip.handle._n,
			x = 170,
			y = 50,
			text = hVar.tab_string["__TEXT_zhan"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		zhan.handle._n:setVisible(false)

		local kuang  = hUI.label:new({
			parent = tip.handle._n,
			x = 240,
			y = 50,
			text = hVar.tab_string["__TEXT_kuang"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,

		})
		kuang.handle._n:setVisible(false)

		local sheng  = hUI.label:new({
			parent = tip.handle._n,
			x = 310,
			y = 50,
			text = hVar.tab_string["__TEXT_sheng"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		sheng.handle._n:setVisible(false)

		local ji  = hUI.label:new({
			parent = tip.handle._n,
			x = 380,
			y = 50,
			text = hVar.tab_string["__TEXT_ji"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		ji.handle._n:setVisible(false)

		local _DeleteCallBack = function()

			hApi.addTimerOnce("tipActionDelete",1000,function()
				zhan:del()
				zhan = nil
				kuang:del()
				kuang = nil
				sheng:del()
				sheng = nil
				ji:del()
				ji = nil
				tip:del()
				tip = nil
			end)
		end

		--�رն���
		local _actionCallBack = function()

			hApi.addTimerOnce("tipAction",1000,function()
				tip.handle._n:runAction(CCFadeOut:create(0.3))
				zhan.handle.s:runAction(CCFadeOut:create(0.3))
				kuang.handle.s:runAction(CCFadeOut:create(0.3))
				sheng.handle.s:runAction(CCFadeOut:create(0.3))
				ji.handle.s:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.3),CCCallFunc:create(_DeleteCallBack)))

			end)
		end

		--���ĸ���
		local _textAction_4 = function()
			hApi.addTimerOnce("tipAction4",10,function()
				ji.handle.s:runAction(CCFadeIn:create(0.1))		--����
				ji.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				ji.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_actionCallBack)))
			end)
		end

		--��������
		local _textAction_3 = function()
			hApi.addTimerOnce("tipAction3",10,function()
				sheng.handle.s:runAction(CCFadeIn:create(0.1))		--����
				sheng.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				sheng.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_4)))
			end)
		end

		--�ڶ�����
		local _textAction_2 = function()
			hApi.addTimerOnce("tipAction2",10,function()
				kuang.handle.s:runAction(CCFadeIn:create(0.1))		--����
				kuang.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				kuang.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_3)))
			end)
		end

		--��һ����
		local _textAction_1 = function()
			hApi.addTimerOnce("tipAction1",10,function()
				zhan.handle.s:runAction(CCFadeIn:create(0.1))		--����
				zhan.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				zhan.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_2)))
			end)
		end

		tip.handle._n:setScale(0)
		tip.handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2,1.5),CCCallFunc:create(_textAction_1)))
	end
end

--���һս
_tgr["@Lastattack:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)

	vTalk[#vTalk+1] = function()

		local labX,labY = 470,600
		if g_phone_mode == 1 then
			labX,labY = 470,520
		elseif g_phone_mode == 2 then
			labX,labY = 560,520
		end

		local tip = hUI.image:new({
			--mode = "file",
			model = "UI:card_select_back",
			animation = "normal",
			align = "MC",
			x = labX,
			y = labY,
			h = 64,
			scale = 1.5,
		})

		--ս
		local zhan = hUI.label:new({
			parent = tip.handle._n,
			x = 170,
			y = 50,
			text = hVar.tab_string["__TEXT_zui"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		zhan.handle._n:setVisible(false)

		local kuang  = hUI.label:new({
			parent = tip.handle._n,
			x = 240,
			y = 50,
			text = hVar.tab_string["__TEXT_hou"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,

		})
		kuang.handle._n:setVisible(false)

		local sheng  = hUI.label:new({
			parent = tip.handle._n,
			x = 310,
			y = 50,
			text = hVar.tab_string["__TEXT_yi"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		sheng.handle._n:setVisible(false)

		local ji  = hUI.label:new({
			parent = tip.handle._n,
			x = 380,
			y = 50,
			text = hVar.tab_string["__TEXT_zhan"],
			size = 44,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
		})
		ji.handle._n:setVisible(false)

		local _DeleteCallBack = function()

			hApi.addTimerOnce("tipActionDelete",1000,function()
				zhan:del()
				zhan = nil
				kuang:del()
				kuang = nil
				sheng:del()
				sheng = nil
				ji:del()
				ji = nil
				tip:del()
				tip = nil
			end)
		end

		--�رն���
		local _actionCallBack = function()

			hApi.addTimerOnce("tipAction",1000,function()
				tip.handle._n:runAction(CCFadeOut:create(0.3))
				zhan.handle.s:runAction(CCFadeOut:create(0.3))
				kuang.handle.s:runAction(CCFadeOut:create(0.3))
				sheng.handle.s:runAction(CCFadeOut:create(0.3))
				ji.handle.s:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.3),CCCallFunc:create(_DeleteCallBack)))

			end)
		end

		--���ĸ���
		local _textAction_4 = function()
			hApi.addTimerOnce("tipAction4",10,function()
				ji.handle.s:runAction(CCFadeIn:create(0.1))		--����
				ji.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				ji.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_actionCallBack)))
			end)
		end

		--��������
		local _textAction_3 = function()
			hApi.addTimerOnce("tipAction3",10,function()
				sheng.handle.s:runAction(CCFadeIn:create(0.1))		--����
				sheng.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				sheng.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_4)))
			end)
		end

		--�ڶ�����
		local _textAction_2 = function()
			hApi.addTimerOnce("tipAction2",10,function()
				kuang.handle.s:runAction(CCFadeIn:create(0.1))		--����
				kuang.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				kuang.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_3)))
			end)
		end

		--��һ����
		local _textAction_1 = function()
			hApi.addTimerOnce("tipAction1",10,function()
				zhan.handle.s:runAction(CCFadeIn:create(0.1))		--����
				zhan.handle.s:runAction(CCScaleTo:create(0.1,1))	--����
				zhan.handle._n:setVisible(true)
				tip.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),-6,1),CCCallFunc:create(_textAction_2)))
			end)
		end

		tip.handle._n:setScale(0)
		tip.handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2,1.5),CCCallFunc:create(_textAction_1)))
	end
end

--ΪӢ�����һ������ĳЩ�Ի��ı�ǩ
_tgr["@AddPassTalkTag:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" then
		local oHero__ID = oHero.__ID
		vTalk[#vTalk+1] = function()
			if oHero__ID==oHero.__ID then
				if type(oHero.data.IgnoredTalk)~="table" then
					oHero.data.IgnoredTalk = {TagData}
				else
					for i = 1,#oHero.data.IgnoredTalk do
						if oHero.data.IgnoredTalk[i]==TagData then
							return
						end
					end
					oHero.data.IgnoredTalk[#oHero.data.IgnoredTalk+1] = TagData
				end
			end
		end
	end
end

_tgr["@CheckPassTalkTag:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" and TagParam~="" then
		local PassNum
		if TagParam~="" then
			PassNum = tonumber(TagParam)
		end
		if type(PassNum)~="number" then
			return
		end
		local HaveTag = 0
		if type(oHero.data.IgnoredTalk)=="table" then
			local s = string.find(TagData,"|")
			if s then
				local tabK = {}
				for k in string.gfind(TagData,"([^%|]+)|+") do
					tabK[k] = 1
				end
				if s==1 then
					--&&
					for i = 1,#oHero.data.IgnoredTalk do
						if tabK[oHero.data.IgnoredTalk[i]]~=1 then
							HaveTag = 0
							break
						end
					end
				else
					--||
					for i = 1,#oHero.data.IgnoredTalk do
						if tabK[oHero.data.IgnoredTalk[i]]==1 then
							HaveTag = 1
							break
						end
					end
				end
			else
				for i = 1,#oHero.data.IgnoredTalk do
					if oHero.data.IgnoredTalk[i]==TagData then
						HaveTag = 1
						break
					end
				end
			end
		end
		if PassNum>0 then
			--����о�����
			if HaveTag==1 then
				return PassNum
			end
		elseif PassNum<0 then
			--���û�в�����
			if HaveTag~=1 then
				return PassNum
			end
		end
		
	end
end

-----------------------------------------
--ÿ�촦����ʱ����
-----------------------------------------
do
	local __ENUM__DoWithTempGameVar_Load = function(oHero)
		local tTemp = oHero.data.GameVar
		local oTargetX = oHero:getunit("world")
		if type(tTemp)=="table" then
			if (tTemp["_MOVE"] or 0)~=0 then
				local v = tTemp["_MOVE"]
				tTemp["_MOVE"] = nil
				if oTargetX and oTargetX.handle._c then
					local nMovePoint = hApi.chaGetMovePoint(oTargetX.handle)
					hApi.chaSetMovePoint(oTargetX.handle,math.max(0,nMovePoint+v))
				end
			end
		end
	end

	local __ENUM__DoWithTempGameVar_NewDay = function(oHero)
		local tTemp = oHero.data.GameVar
		local oTargetX = oHero:getunit("world")
		if type(tTemp)=="table" then
			--��һ��Ի����̿�ʼǰ�����Ӣ�۵�λ���ƶ�����
			if (tTemp["_MOVE"] or 0)~=0 then
				tTemp["_MOVE"] = nil
			end
		end
	end

	--��������һ�쿪ʼʱ�������
	hApi.DoWithTempGameVar = function(mode,oWorld)
		if mode=="load" then
			--��ȡ���
			hClass.hero:enum(__ENUM__DoWithTempGameVar_Load)
		elseif mode=="newday" then
			--��һ�쿪ʼʱ����δ��ʼ�����Ի���
			hClass.hero:enum(__ENUM__DoWithTempGameVar_NewDay)
		end
	end
end

----ΪӢ�����һ������,ʹ��+x
--_tgr["@AddGameVar:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
--	local oHero = oTargetX:gethero()
--	if oHero and TagData~="" then
--		local oHero__ID = oHero.__ID
--		vTalk[#vTalk+1] = function()
--			if oHero__ID==oHero.__ID then
--				local n = oHero:getGameVar(TagData)
--				if string.find(TagParam,",") then
--					local _,_,mn,mx = string.find(TagParam,"(%d+),(%d+)")
--					if mn and mx then
--						local v = hApi.localrandom(tonumber(mn,mx))
--						oHero:setGameVar(TagData,n + v)
--						_DEBUG_MSG("[GameVar]id:"..oHero.data.triggerID.."; add:"..TagData.." = "..n.." + "..v.." ("..mn..","..mx..")")
--					end
--				else
--					local v = hApi.AnalyzeValueExpr("number",nil,oHero.data.GameVar,TagParam,99999)
--					oHero:setGameVar(TagData,n + v)
--					_DEBUG_MSG("[GameVar]id:"..oHero.data.triggerID.."; add:"..TagData.." = "..n.." + "..v)
--				end
--			end
--		end
--	end
--end

----�޸�Ӣ�����ϵ�һ������(ĳЩ�ض��������޸ĵ�λ������)
--_tgr["@SetGameVar:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
--	local oHero = oTargetX:gethero()
--	if oHero and TagData~="" then
--		local oHero__ID = oHero.__ID
--		vTalk[#vTalk+1] = function()
--			if oHero__ID==oHero.__ID then
--				if string.find(TagParam,",") then
--					local _,_,mn,mx = string.find(TagParam,"(%d+),(%d+)")
--					if mn and mx then
--						local v = hApi.localrandom(tonumber(mn),tonumber(mx))
--						oHero:setGameVar(TagData,v)
--						_DEBUG_MSG("[GameVar]id:"..oHero.data.triggerID.."; set:"..TagData.." = "..v.." ("..mn..","..mx..")")
--					end
--				else
--					local IsDayEnd = 0
--					local oWorld = hGlobal.WORLD.LastWorldMap
--					if oWorld and oWorld.data.IsPaused==1 and oWorld.data.PausedByWhat=="DayEnd" then
--						IsDayEnd = 1
--					end
--					local tVar = nil
--					if type(oHero.data.GameVar)=="table" then
--						tVar = oHero.data.GameVar
--					else
--						tVar = {}
--					end
--					local v = hApi.AnalyzeValueExpr("number",nil,tVar,TagParam,99999)
--					if TagData=="_MOUNT" then
--						--������/ɾ����
--						oHero:setGameVar(TagData,v)
--						oTargetX:loadmount(v)
--					elseif TagData=="_MOVE" then
--						if IsDayEnd==1 then
--							--�浵ǰ���õĻ����Żᱣ�����ֵ
--							oHero:setGameVar(TagData,v)
--						end
--						--�����ж���
--						local nMovePoint = hApi.chaGetMovePoint(oTargetX.handle)
--						hApi.chaSetMovePoint(oTargetX.handle,math.max(0,nMovePoint+v))
--						--ˢ����ʾ
--						if oHero.heroUI["movepoint"]~=nil then
--							hGlobal.event:event("LocalEvent_HeroMovePointUpdate",oHero)
--						end
--					elseif TagData=="_MAXMOVE" then
--						--��������ж��������豣��
--						oHero.attr.movepoint = math.max(0,oHero.attr.movepoint + v)
--						oTargetX:setmovepoint(oHero.attr.movepoint)
--						--ˢ����ʾ
--						if oHero.heroUI["movepoint"]~=nil then
--							hGlobal.event:event("LocalEvent_HeroMovePointUpdate",oHero)
--						end
--					else
--						oHero:setGameVar(TagData,v)
--					end
--					_DEBUG_MSG("[GameVar]id:"..oHero.data.triggerID.."; set:"..TagData.." = "..v)
--				end
--			end
--		end
--	end
--end

--���Ӣ�����ϵı���
_tgr["@CheckGameVar:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" and type(oHero.data.GameVar)=="table" then
		if hApi.AnalyzeValueExpr("all",nil,oHero.data.GameVar,TagData,9999)==true then
			return
		end
	end
	local PassNum = tonumber(TagParam)
	if type(PassNum)=="number" then
		return PassNum
	end
end

--����Ӣ�۱���
_tgr["@SaveGameVar:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" then
		local oHero__ID = oHero.__ID
		vTalk[#vTalk+1] = function()
			if oHero__ID==oHero.__ID then
				if g_localfilepath~=nil then
					local sSaveName
					if TagData=="map" then
						sSaveName = tostring(hGlobal.WORLD.LastWorldMap.data.map)..TagParam
					else
						sSaveName = TagData
					end
					LuaLoadSavedGameData(g_localfilepath.."gamevar.cfg")
					if type(__TEMP__game_var)~="table" then
						__TEMP__game_var = {}
					end
					if TagParam~="" then
						--ָ��ֻ�����ض����������
						if type(oHero.data.GameVar)=="table" then
							local tKey = hApi.Split(TagParam,",")
							if #tKey>0 then
								local tSave = __TEMP__game_var[sSaveName]
								if type(tSave)~="table" then
									__TEMP__game_var[sSaveName] = {}
									tSave = __TEMP__game_var[sSaveName]
								end
								for i = 1,#tKey do
									local k = tKey[i]
									if oHero.data.GameVar[k] then
										tSave[k] = oHero.data.GameVar[k]
									end
								end
							end
						end
					else
						--ȫ����������
						if type(oHero.data.GameVar)=="table" then
							__TEMP__game_var[sSaveName] = oHero.data.GameVar
						else
							__TEMP__game_var[sSaveName] = {}
						end
					end
					hApi.SaveFile("gamevar.cfg","__TEMP__game_var",__TEMP__game_var)
					__TEMP__game_var = nil
				end
			end
		end
	end
end

--��ȡӢ�۱���
_tgr["@LoadGameVar:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oHero = oTargetX:gethero()
	if oHero and TagData~="" then
		if g_localfilepath~=nil then
			local sSaveName
			if TagData=="map" then
				sSaveName = tostring(hGlobal.WORLD.LastWorldMap.data.map)..TagParam
			else
				sSaveName = TagData
			end
			__TEMP__game_var = nil
			LuaLoadSavedGameData(g_localfilepath.."gamevar.cfg")
			if type(__TEMP__game_var)=="table" and type(__TEMP__game_var[sSaveName])=="table" then
				if TagParam~="" then
					--ָ��ֻ��ȡ�ض����������
					local tKey = hApi.Split(TagParam,",")
					if #tKey>0 then
						for i = 1,#tKey do
							local k = tKey[i]
							local v = __TEMP__game_var[sSaveName][k] or 0
							oHero:setGameVar(tKey[i],v)
						end
					end
				else
					--ȫ����ȡ�����
					oHero.data.GameVar = __TEMP__game_var[sSaveName]
				end
			end
			__TEMP__game_var = nil
		end
	end
end


--��ʾǿ����UI
_tgr["@DisableUI:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nTick = 1
	if TagData~="" then
		nTick = tonumber(TagData)
	end
	if type(nTick)=="number" then
		vTalk[#vTalk+1] = function()
			hUI.Disable(nTick,"̸������")
		end
	end
end

--���ָ���Ƿ��Ѿ����(ͬʱ����ָ����Ϊ���״̬)
_tgr["@CheckGuideRecord:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hVar.OPTIONS.TEST_NOOB_TIP==1 then
		return
	end
	local oWorld = hGlobal.WORLD.LastWorldMap
	local nIndex = tonumber(TagData)
	if oWorld~=nil and type(nIndex)=="number" and nIndex>0 and LuaSetPlayerGuideState(g_curPlayerName,oWorld.data.map,nIndex)==1 then
		return
	else
		return tonumber(TagParam)
	end
end

--���ָ���Ƿ��Ѿ����(������)
_tgr["@CheckGuideRecordII:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if hVar.OPTIONS.TEST_NOOB_TIP==1 then
		return
	end
	local oWorld = hGlobal.WORLD.LastWorldMap
	local nIndex = tonumber(TagData)
	if oWorld~=nil and type(nIndex)=="number" and nIndex>0 and LuaGetPlayerGuideState(g_curPlayerName,oWorld.data.map,nIndex)~=1 then
		return
	else
		return tonumber(TagParam)
	end
end

--��ʾǿ����UI
_tgr["@ShowGuideUI:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	
	local oTargetX__ID = oTargetX.__ID
	local sText = TagData
	if string.sub(TagData,1,1)=="$" then
		sText =  hApi.ConvertMapString(TagData,tonumber(TagParam))
	else
		sText = hVar.tab_string[TagData]
	end
	vTalk[#vTalk+1] = function()
		if oTargetX.__ID==oTargetX__ID then
			--print(oTargetX.data.id,sText)
			hApi.ShowGuideUI(oTargetX,sText)
		end
	end
end


_tgr["@EnterMapByName:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		hGlobal.event:event("LocalEvent_ShowEnterMapFrm",1,TagData)
	end
end

_tgr["@LoadFunc:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	if vTalk.func and type(vTalk.func[TagData])=="function" then
		vTalk[#vTalk+1] = vTalk.func[TagData]
	end
end

_tgr["@AddResource:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	--@func:AddResource:1,GOLD,1000,FOOD,2000@
	local tabR = {}
	for k in string.gfind(TagData,"([^%,]+)")do
		tabR[#tabR+1] = k
	end
	local oPlayer
	if #tabR>=3 then
		if tabR[1]=="0" then
			oPlayer = oTargetX:getowner()
		else
			oPlayer = hGlobal.player[tonumber(tabR[1])]
		end
		if oPlayer then
			vTalk[#vTalk+1] = function()
				for i = 2,#tabR,2 do
					local k = tabR[i]
					local v = tonumber(tabR[i+1] or 0)
					if hVar.RESOURCE_TYPE[k] and v and v~=0 then
						oPlayer:addresource(hVar.RESOURCE_TYPE[k],v)
					end
				end
			end
		end
	end
end

--�ӵ�ͼ�ĵ����б���ѡ��һ�����
_tgr["@RewardItemFrm:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local oUnit__ID = oUnit.__ID
	vTalk[#vTalk+1] = function()
		if oUnit__ID~=oUnit.__ID then
			--ʰȡ��λ����
		elseif oTargetX__ID==oTargetX.__ID then
			--Ŀ�껹���ţ�ֱ����ʾ�������
			hGlobal.event:event("LocalEvent_HeroPickReward",oUnit,oTarget,TagData)
		elseif -1*oTargetX__ID==oTargetX.__ID then
			--Ŀ�걻��ɱ������ʰȡ��Ϣ
			oTargetX.data.loot = TagData
		end
	end
	--local oUnit__ID = oUnit.__ID
	--vTalk[#vTalk+1] = function()
		--if oUnit__ID==oUnit.__ID then
			--local oHero = oUnit:gethero()
			--local oWorld = oUnit:getworld()
			--if oWorld and oHero and oHero.data.HeroCard==0 and oUnit:getowner()==hGlobal.LocalPlayer then
				--local tMapData = oWorld:getmapdata(1)
				--local rewardlist = {}
				--local tempDrop = hVar.TokenRandomItem
				--local mn,mx = 1,#tempDrop
				--local ResetCount = 1
				--local fromBag = nil
				--local fromBagIndex = nil
				--local fromItem = nil

				--if tMapData and type(tMapData.DropItemList)=="table" then
					--for i = 1,#tMapData.DropItemList do
						--local v = tMapData.DropItemList[i]
						--if v[1]==TagData and #v>=2 then
							--tempDrop = v
							--mn = 2
							--mx = #tempDrop
							--break
						--end
					--end
				--end
				----����8������
				--for i = 1,8 do
					--local itemID = tempDrop[hApi.random(mn,mx)]
					--rewardlist[i] = {"item",itemID,hVar.tab_stringI[itemID][1],0,0,0,0} --���ͣ�����ID���������֣����߳��ֵļ��ʣ�3����ѡ����
				--end
				--hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,rewardlist,ResetCount,10,fromBag,fromBagIndex,fromItem)
			--else
				--print("[LUA WARNING]@RewardItemFrm:ֻ�зǿ�ƬӢ������������")
			--end
		--end
	--end
end

--���ѡ��������Ӣ�ۣ�������
_tgr["@DoIfHeroUsed:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nNum = tonumber(TagData)
	local tUnitId = {}
	local tHero = hGlobal.LocalPlayer.heros
	for id in string.gfind(TagParam,"([%d]+);")do
		local nId = tonumber(id)
		if nId>10 then
			tUnitId[nId] = 1
		end
	end
	if string.sub(TagParam,1,1)=="|" then
		--(��ѡ��AҲѡ��B)
		local mode = string.sub(TagParam,2,3)
		if mode=="0;" then
			--û��ͬʱѡ���б��е�Ӣ��
			for i = 1,#tHero do
				local oHero = tHero[i]
				if type(oHero)=="table" and tUnitId[oHero.data.id]==1 then
					tUnitId[oHero.data.id] = 0
				end
			end
			for k,v in pairs(tUnitId)do
				if v~=0 then
					return
				end
			end
			return nNum
		else
			--ͬʱѡ�����б��е�ȫ��Ӣ��
			for i = 1,#tHero do
				local oHero = tHero[i]
				if type(oHero)=="table" then
					tUnitId[oHero.data.id] = 0
				end
			end
			for k,v in pairs(tUnitId)do
				if v~=0 then
					return nNum
				end
			end
			return
		end
	else
		--(ѡ��A��ѡ��B)
		local mode = string.sub(TagParam,1,2)
		if mode=="0;" then
			--û��ѡ������һ���б��е�Ӣ��
			for i = 1,#tHero do
				local oHero = tHero[i]
				if type(oHero)=="table" and tUnitId[oHero.data.id]==1 then
					return nNum
				end
			end
			return
		else
			--����ѡ����һ���б��е�Ӣ��
			for i = 1,#tHero do
				local oHero = tHero[i]
				if type(oHero)=="table" and tUnitId[oHero.data.id]==1 then
					return
				end
			end
			return nNum
		end
	end
end


_tgr["@HeroCardFrmTip:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local focus_unit = hGlobal.LocalPlayer:getfocusunit()
		if focus_unit then
			local oPanel = hGlobal.O:replace("__TN__TargetOperatePanel",hUI.targetPanel:new({
				world = focus_unit:getworld(),
				target = focus_unit,
				orderUnit = focus_unit,
			}))

			oPanel.handle._n:runAction(CCRepeatForever:create(CCJumpBy:create(0.5,ccp(0,0),5,1)))
		end
	end
end

_tgr["@ShowTargetOpr:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local focus_unit = hGlobal.LocalPlayer:getfocusunit()
		if focus_unit then
			local oPanel = hGlobal.O:replace("__TN__TargetOperatePanel",hUI.targetPanel:new({
				world = focus_unit:getworld(),
				target = oTargetX,
				orderUnit = focus_unit,
			}))
			if TagData~="" and TagData~="0" then
				local oGrid = oPanel.childUI["actions"]
				local oBtn = oGrid.childUI["btn_"..(tonumber(TagData) or 0)]
				if oBtn then
					hUI.deleteUIObject(hUI.image:new({
						parent = oGrid.handle._n,
						model = "MODEL_EFFECT:way_arrow",
						x = oBtn.data.x,
						y = oBtn.data.y+32,
						w = 32,
					}))
				end
			else
				oPanel.handle._n:runAction(CCRepeatForever:create(CCJumpBy:create(0.5,ccp(0,0),5,1)))
			end
		end
	end
end

_tgr["@AddUnit:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local cx,cy = oTargetX:getXY()
	local nOwner = tonumber(TagParam) or 0
	local nUnitID = tonumber(TagData)
	vTalk[#vTalk+1] = function()
		if oTargetX__ID==oTargetX.__ID then
			cx,cy = oTargetX:getXY()
		end
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and hVar.tab_unit[nUnitID] then
			oWorld:addunit(nUnitID,nOwner,nil,nil,hVar.UNIT_DEFAULT_FACING,cx,cy)
		end
	end
end

_tgr["@ClearArmy:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local tRemoveID
	if TagData~="" and TagData~="0" then
		tRemoveID = {}
		for id in string.gfind(TagData,"(%d+)")do
			tRemoveID[tonumber(id)] = 1
		end
	end
	vTalk[#vTalk+1] = function()
		if oTargetX__ID==oTargetX.__ID then
			local tTeam = oTargetX.data.team
			if type(tTeam)=="table" then
				for i = 1,#tTeam do
					if type(tTeam[i])=="table" then
						local id = tTeam[i][1]
						if tRemoveID then
							if tRemoveID[id]==1 then
								tTeam[i] = 0
							end
						else
							if hVar.tab_unit[id] and hVar.tab_unit[id].type~=hVar.UNIT_TYPE.HERO then
								tTeam[i] = 0
							end
						end
					end
				end
			end
		end
	end
end

_tgr["@MoveTo:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local oWorld = oTargetX:getworld()
	vTalk[#vTalk+1] = function(tFunc)
		if oWorld and oTargetX__ID==oTargetX.__ID and oTargetX.data.IsHide==0 then
			if TagData=="t" then
				local oMoveTarget = oWorld:tgrid2unit(tonumber(TagParam))
				if oMoveTarget~=nil then
					tFunc.UnitMoveTo(oTargetX,oMoveTarget)--EFF
				end
			end
		end
	end
end

_tgr["@SetMovePoint:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)--�ѷ������Ժ�Ҫ�����
	local oTargetX__ID = oTargetX.__ID
	local nMovePoint = tonumber(TagData)
	if type(nMovePoint)=="number" then
		vTalk[#vTalk+1] = function(tFunc)
			if oTargetX__ID==oTargetX.__ID and oTargetX.handle._c then
				hApi.chaSetMovePoint(oTargetX.handle,nMovePoint)
			end
		end
	end
end

_tgr["@AddSkill:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local nSkillId = tonumber(TagData)
	if type(nSkillId)=="number" and hVar.tab_skill[nSkillId] then
		vTalk[#vTalk+1] = function(tFunc)
			if oTargetX__ID==oTargetX.__ID and oTargetX.handle._c then
				local oHero = oTargetX:gethero()
				if oHero then
					oHero.data.academySkill[1] = {nSkillId,1}
				end
			end
		end
	end
end

--Ϊһ����λ���ӱ���
_tgr["@AddTeam:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local oTargetX__ID = oTargetX.__ID
	local tTeamAdd = {}
	local tValue = {}
	for n in string.gfind(TagData,"(%d+)") do
		tValue[#tValue+1] = tonumber(n)
	end
	for i = 1,math.floor(#tValue/2) do
		local id,num = tValue[(i-1)*2+1],tValue[i*2]
		local tabU = hVar.tab_unit[id]
		if tabU and tabU.type==hVar.UNIT_TYPE.UNIT then
			tTeamAdd[#tTeamAdd+1] = {id,num}
		end
	end
	if #tTeamAdd>0 then
		vTalk[#vTalk+1] = function()
			if oTargetX__ID==oTargetX.__ID then
				oTargetX:teamaddunit(tTeamAdd)
			end
		end
	end
end

--����ȫ��ˮ���ж�������@����:��������:�ٷֱ�@
_tgr["@SetGlobalWaterMovePoint:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	vTalk[#vTalk+1] = function()
		local tgrDataP = hGlobal.WORLD.LastWorldMap:getmapdata(tonumber(TagData))
		if tgrDataP then
			tgrDataP.WaterMovePec = tonumber(TagParam)
		end
	end
end

--��ʾһ�������ʾ��ǰ�ؿ��Ƿ��н������ֵ�ͼ����Ϣ ������״�ͨ�� �Żᵯ��
_tgr["@ShowAmuLockFrm:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local nCount = tonumber(TagParam)
	if nCount and nCount>0 then
		local mapName = hGlobal.WORLD.LastWorldMap.data.map
		if hVar.UnlockAumMapList[mapName] and (LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0)~=0 then
			return nCount
		end
	end
	vTalk[#vTalk+1] = function()
		hGlobal.event:event("LocalEvent_ShowAmuLockFrm")
	end
end

_tgr["@CheckUnitID:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local PassNum = tonumber(TagParam)
	if oTargetX.data.id~=tonumber(TagData) then
		if type(PassNum)=="number" and PassNum>0 then
			return PassNum
		end
	end
end

_tgr["@CheckUnitXY:"] = function(TagData,TagParam,oUnit,oTarget,oTargetX,cTalk,cIndex,vTalk)
	local PassNum = tonumber(TagParam)
	local tBoxList = hGlobal.TGR_FUNC.GetBoxByCmd(TagData)
	if #tBoxList>0 and type(PassNum)=="number" and PassNum>0 then
		local cx,cy = oTargetX:getXY()
		for i = 1,#tBoxList do
			if hApi.IsInBox(cx,cy,tBox) then
				return
			end
		end
		return PassNum
	end
end