hGlobal.UI.InitPVPArmyCardFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowPVPArmyCardInfoFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end
	
	local _CODE_UpgradeCard = hApi.DoNothing
	local _CODE_UnlockCard = hApi.DoNothing
	local _CODE_UpdateArmyCardShow = hApi.DoNothing
	local _CODE_UpdateArmyCardSkill = hApi.DoNothing

	local _PVPACF_UnlockTip = nil
	local _PVPACF_CurrentCardID = 0
	local _PVPAC_FrmXYWH = {hVar.SCREEN.w/2-560/2+18,hVar.SCREEN.h/2+400/2-18,560,400}
	local _PVPAC_FrmUIHandle = {}
	local _PVPAC_FrmUIBtnLabel = {
		{"btnUpgradeCard",hVar.tab_string["__UPGRADE"]},
		{"btnUnlockCard",hVar.tab_string["__UNLOCK"]},
	}
	local _PVPAC_FrmUIList = {
		{"button","btnUpgradeCard","UI:PVPMate2",{280,-372,-1,-1,0.95},function()return _CODE_UpgradeCard()end},
		{"button","btnUnlockCard","UI:PVPMate2",{280,-372,-1,-1,0.95},function()return _CODE_UnlockCard()end},
		{"labelX","labRequireTip"," ",{280,-372,22,1,"MC",hVar.FONTC}},
		{"image","imgPVPCoinCost","UI:pvptoken",{398,-372,-1,-1}},
		{"labelX","numPVPCoinCost","0",{420,-368,22,1,"LC"}},
		{"image","imgGameCoinCost","UI:game_coins",{398,-368,42,-1}},
		{"labelX","numGameCoinCost","0",{420,-368,22,1,"LC"}},
		--{"image","imgGameCoinCost_xg","UI:shopitemxg",{440,-368,48,18,9}},
		--{"labelX","numGameCoinCost_xg","0",{478,-368,22,1,"LC"}},
	}
	local _FrmBG
	local _childUI
	hGlobal.UI.PVPArmyCardFrm = hUI.frame:new({
		x = _PVPAC_FrmXYWH[1],
		y = _PVPAC_FrmXYWH[2],
		w = _PVPAC_FrmXYWH[3],
		h = _PVPAC_FrmXYWH[4],
		dragable = 3,
		show = 0,
		bgAlpha = 0,
		--bgMode = "tile",
		--background = "UI:tip_item",
		closebtn = {
			model = "BTN:PANEL_CLOSE",
			x = _PVPAC_FrmXYWH[3],
			z = 10,
			code = function(self,IsFromEvent)
				if IsFromEvent==1 then
					_FrmBG:show(0,"fade")
				else
					_FrmBG:show(0,"normal")
				end
			end,
		},
		border = 1,
		autoactive = 0,
		--codeOnTouch = function(self,x,y,IsInside,tTempPos)
			----local tPickParam = _CODE_HitPage(self,tTempPos,x,y)
			----if tPickParam~=nil then
				----local tDragRect
				----if _PVP_PageUI[tPickParam.sPageMode] then
					----tDragRect = _PVP_PageUI[tPickParam.sPageMode].dragable
				----end
				----if tDragRect==nil then
					----tDragRect = {0,0,0,0}
				----end
				----return self:pick(tPickParam.sGridName,tDragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tPickParam})
			----end
		--end,
	})
	_FrmBG = hGlobal.UI.PVPArmyCardFrm
	_childUI = _FrmBG.childUI

	local tInitParam = hUI.MultiUIParamByFrm(_FrmBG)
	hUI.CreateMultiUIByParam(_FrmBG,0,0,hUI.GetUITemplate("armycard")[1],_PVPAC_FrmUIHandle,tInitParam)
	hUI.CreateMultiUIByParam(_FrmBG,0,0,_PVPAC_FrmUIList,_PVPAC_FrmUIHandle,tInitParam)
	for i = 1,#_PVPAC_FrmUIBtnLabel do
		local k,s = _PVPAC_FrmUIBtnLabel[i][1],_PVPAC_FrmUIBtnLabel[i][2]
		if _childUI[k] then
			_childUI[k]:loadlabel({text=s,font=hVar.FONTC,border=1})
		end
	end

	-----------------------------------
	--显示监听
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nCardID)
		if _FrmBG.data.show~=1 then
			_FrmBG:show(1)
			_FrmBG:active()
		end
		_CODE_UpdateArmyCardShow(nCardID)
	end)
	-----------------------------------
	--如果我掉线了，并且该面板正在显示，那么面板自己关掉
	hGlobal.event:listen("LocalEvent_PVPMap","__NBACF__AutoCloseOnDisconnect",function(nState)
		if nState==0 and _FrmBG.data.show==1 then
			_FrmBG:show(0)
		end
	end)
	---------------------------------------
	--网络数据操作回应
	hGlobal.event:listen("LocalEvent_PVPNetSaveOprResult","__UpdateShowCard",function(nResult,nResultID,nUnique,sData)
		if type(sData)~="string" or _FrmBG.data.show~=1 then
			return
		end
		if nResultID==hVar.NET_SAVE_OPR_TYPE.L2C_UPDATE_ONE_ARMY_CARD then
			if string.find(sData,"ac:".._PVPACF_CurrentCardID..":") then
				_CODE_UpdateArmyCardShow(_PVPACF_CurrentCardID,1)
			end
		end
	end)
	-----------------------------------
	--升级当前选择的卡片
	_CODE_UpgradeCard = function()
		local tCardA = hApi.PVPGetNetData("ArmyCard",_PVPACF_CurrentCardID)
		if tCardA==nil then
			return
		end
		local id,lv,xp = unpack(tCardA)
		if lv>0 and lv<=(hVar.tab_army[id].level or 1) then
			hUI.BloatUI(_PVPAC_FrmUIHandle["imgPVPCoinCost"],0.1,1.2,1.0)
			_childUI["btnUpgradeCard"]:setstate(0)
			hApi.PVPSendNetSaveOpr(hVar.NET_SAVE_OPR_TYPE.C2L_UPGRADE_ARMY_CARD,tostring(id))
		else
			print("卡片"..id.."不可升级")
		end
	end

	_CODE_UnlockCard = function()
		local tCardA = hApi.PVPGetNetData("ArmyCard",_PVPACF_CurrentCardID)
		if tCardA==nil then
			return
		end
		local id,lv,xp = unpack(tCardA)
		if lv==0 then
			_childUI["btnUnlockCard"]:setstate(0)
			hApi.PVPSendNetSaveOpr(hVar.NET_SAVE_OPR_TYPE.C2L_UNLOCK_ARMY_CARD,tostring(id))
		else
			print("卡片"..id.."已经解锁")
		end
	end

	------------------------------------
	--刷新面板函数
	local _tRequireKeyConv = {
		lv = "PVPFightGrade",
		elo = "PVP_Point",
	}
	local _code_Req2Str = function(tHint,tRequire)
		if tRequire then
			for i = 1,#tRequire do
				if tRequire[i][1]~="pvp_coin" then
					tHint[#tHint+1] = hVar.tab_string[_tRequireKeyConv[tRequire[i][1]] or tRequire[i][1]]
					tHint[#tHint+1] = " "
					tHint[#tHint+1] = tostring(tRequire[i][2])
					if i~=#tRequire then
						tHint[#tHint+1] = ", "
					end
				end
			end
		end
		return tHint
	end
	local _code_GetReqCoin = function(tRequire)
		if tRequire then
			for i = 1,#tRequire do
				if tRequire[i][1]=="pvp_coin" then
					return tRequire[i][2]
				end
			end
		end
		return 0
	end
	local _code_IsMeetReq = function(tRequire)
		if tRequire then
			for i = 1,#tRequire do
				if tRequire[i][1]~="pvp_coin" and tRequire[i][3]==0 then
					return hVar.RESULT_FAIL
				end
			end
		end
		return hVar.RESULT_SUCESS
	end
	local _code_UpdateCardCost = function(mode,val)
		if mode=="game_coin" then
			_PVPAC_FrmUIHandle["imgPVPCoinCost"]:setVisible(false)
			_PVPAC_FrmUIHandle["numPVPCoinCost"].handle._n:setVisible(false)
			_PVPAC_FrmUIHandle["imgGameCoinCost"]:setVisible(true)
			_PVPAC_FrmUIHandle["numGameCoinCost"].handle._n:setVisible(true)
			_PVPAC_FrmUIHandle["numGameCoinCost"]:setText(tostring(val),2)
		elseif mode=="pvp_coin" then
			_PVPAC_FrmUIHandle["imgPVPCoinCost"]:setVisible(true)
			_PVPAC_FrmUIHandle["numPVPCoinCost"].handle._n:setVisible(true)
			if val>0 then
				_PVPAC_FrmUIHandle["numPVPCoinCost"]:setText(tostring(val),2)
			else
				_PVPAC_FrmUIHandle["numPVPCoinCost"]:setText("-",2)
			end
			_PVPAC_FrmUIHandle["imgGameCoinCost"]:setVisible(false)
			_PVPAC_FrmUIHandle["numGameCoinCost"].handle._n:setVisible(false)
		else
			_PVPAC_FrmUIHandle["imgPVPCoinCost"]:setVisible(false)
			_PVPAC_FrmUIHandle["numPVPCoinCost"].handle._n:setVisible(false)
			_PVPAC_FrmUIHandle["imgGameCoinCost"]:setVisible(false)
			_PVPAC_FrmUIHandle["numGameCoinCost"].handle._n:setVisible(false)
		end
	end
	_CODE_UpdateArmyCardShow = function(nCardID,NeedJump)
		local tCardA = hApi.PVPGetNetData("ArmyCard",nCardID)
		if tCardA then
			_PVPACF_CurrentCardID = nCardID
			hUI.GetUITemplate("armycard")[2].UpdateByCard(_PVPAC_FrmUIHandle,tCardA,NeedJump)
			local id,lv,xp = unpack(tCardA)
			if lv<=0 then
				_childUI["btnUpgradeCard"]:setstate(-1)
			else
				_childUI["btnUnlockCard"]:setstate(-1)
			end
			if lv<=0 then
				--解锁流程
				local sus,tRequire = hApi.PVPCheckArmyCardOpr(nCardID,"unlock")
				local tabA = hVar.tab_army[id]
				if tabA and (tabA.unlock_coin or 0)>0 then
					_code_UpdateCardCost("game_coin",tabA.unlock_coin)
				else
					_code_UpdateCardCost(0,0)
				end
				if _code_IsMeetReq(tRequire)==hVar.RESULT_SUCESS then
					_childUI["labRequireTip"].handle._n:setVisible(false)
					_childUI["btnUnlockCard"]:setstate(sus==hVar.RESULT_SUCESS and 1 or 0)
				else
					local sHint = table.concat(_code_Req2Str({hVar.tab_string["__UNLOCK_REQUIRE"],": "},tRequire))
					_childUI["labRequireTip"]:setText(sHint,2)
					_childUI["labRequireTip"].handle._n:setVisible(true)
					_childUI["btnUnlockCard"]:setstate(-1)
				end
			else
				--升级流程
				local sus,tRequire = hApi.PVPCheckArmyCardOpr(nCardID,"upgrade")
				if _code_IsMeetReq(tRequire)==hVar.RESULT_SUCESS then
					_childUI["labRequireTip"].handle._n:setVisible(false)
					_childUI["btnUpgradeCard"]:setstate(sus==hVar.RESULT_SUCESS and 1 or 0)
					_code_UpdateCardCost("pvp_coin",_code_GetReqCoin(tRequire))
				else
					local sHint = table.concat(_code_Req2Str({hVar.tab_string["__UPGRADE_REQUIRE"],": "},tRequire))
					_childUI["labRequireTip"]:setText(sHint,2)
					_childUI["labRequireTip"].handle._n:setVisible(true)
					_childUI["btnUpgradeCard"]:setstate(-1)
					_code_UpdateCardCost(0,0)
				end
			end
			if g_PVP_NetSaveData.PVPCoin<0 then
				if _childUI["btnUnlockCard"].data.state~=-1 then
					_childUI["btnUnlockCard"]:setstate(0)
				end
				if _childUI["btnUpgradeCard"].data.state~=-1 then
					_childUI["btnUpgradeCard"]:setstate(0)
				end
			end
			_CODE_UpdateArmyCardSkill(id,lv)
		else
			_childUI["btnUnlockCard"]:setstate(-1)
			_childUI["btnUpgradeCard"]:setstate(-1)
			_childUI["btnUnlockCard"]:setstate(-1)
			hUI.GetUITemplate("armycard")[2].UpdateByCard(_PVPAC_FrmUIHandle,{1,0,0})
			_code_UpdateCardCost(0,0)
			_CODE_UpdateArmyCardSkill(0,0)
		end
	end
	--刷新卡片技能
	local _acf_LastChoosedCard = {0,0}
	local _code_AddSkillHint = function(index,id,lv,count,unlock)
		local sHintName = (hVar.tab_stringS[id][1] or "skill_"..tostring(id))
		if (hVar.tab_skill[id].level or 1)>1 then
			sHintName = sHintName.." ("..hVar.tab_string["__Attr_Hint_Lev"].." "..lv..")"
		end
		local sHint = hVar.tab_stringS[id][2] or "..."
		local tUIList = {
			{"image","imgIcon",hVar.tab_skill[id].icon,{16,0,32,32}},
			{"label","labName",sHintName,{42,0,22,1,"LC",hVar.FONTC}},
			{"labelX","labHint",sHint,{0,-26,22,1,"LT",hVar.FONTC,0,160}},
		}
		local tUIHandle = {}

		local y = -12
		local pNodeF = _childUI["tipSkill_"..(index-1)]
		if pNodeF then
			y = pNodeF.data.y - pNodeF.data.h - 24
		end
		local pNode = hUI.node:new({
			parent = _FrmBG.handle._n,
			x = -196,
			y = y,
		})
		_childUI["tipSkill_"..index] = pNode
		hUI.CreateMultiUIByParam(pNode,0,0,tUIList,tUIHandle)
		pNode.data.h = 42 + tUIHandle["labHint"].handle.s:getContentSize().height
		hUI.deleteUIObject(tUIHandle["labHint"])
		hUI.deleteUIObject(hUI.bar:new({
			parent = pNode.handle._n,
			model = "UI:tip_item",
			x = 80,
			y = 12 - math.floor(pNode.data.h/2),
			z = -1,
			w = 180,
			h = pNode.data.h + 18,
		}))
	end
	_CODE_UpdateArmyCardSkill = function(id,lv)
		local nTipMax = 9
		if _acf_LastChoosedCard[1]==id then--and _acf_LastChoosedCard[2]==lv then
			return
		else
			for i = 1,nTipMax do
				hApi.safeRemoveT(_childUI,"tipSkill_"..i)
			end
			_acf_LastChoosedCard[1] = id
			--_acf_LastChoosedCard[2] = lv
		end
		if id<=0 then
			return
		end
		local nUnitId = hApi.GetArmyCardUnit(id,lv,0)
		local tabU = hVar.tab_unit[nUnitId]
		if tabU and tabU.attr and tabU.attr.skill then
			local s = tabU.attr.skill
			local index = 0
			for i = 1,math.min(nTipMax,#s) do
				if type(s[i])=="table" then
					local id = s[i][1]
					if hVar.tab_skill[id] and hVar.tab_stringS[id] then
						local lv = s[i][2] or 1
						local count = s[i][3] or hVar.tab_skill[id].count or 0
						index = index + 1
						_code_AddSkillHint(index,id,lv,count,0)
					end
				end
			end
		end
	end
end