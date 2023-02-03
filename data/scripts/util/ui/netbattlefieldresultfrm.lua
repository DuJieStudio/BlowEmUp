-------------------------------
--�����սս���������
-------------------------------
hGlobal.UI.InitNetBattlefieldResultFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowNetBattlefieldResultFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end

	local _CODE_CloseResultFrm = hApi.DoNothing
	local _CODE_L2CShowResult = hApi.DoNothing

	local _frm
	local _childUI

	local _w,_h = 652,548
	hGlobal.UI.NetBattlefieldResultFrm  = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		dragable = 2,
		show = 0,
		w = _w,
		h = _h,
		codeOnTouch = function()
			if not(g_NetManager:isConnected()) then
				_childUI["ok"].data.code()
			end
		end,
	})

	_frm = hGlobal.UI.NetBattlefieldResultFrm
	_childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--�ֽ���
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 325,
		y = -155,
		w = _w + 20,
		h = 8,
	})
	
	local _RemoveList = {}
	local _rs_lab_list = {}
	local _RemoveFunc = function()
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i]) 
		end
		_RemoveList = {}

		for i = 1,#_rs_lab_list do
			hApi.safeRemoveT(_childUI,_rs_lab_list[i]) 
		end
		_rs_lab_list = {}
	end

	--�˳���ť
	_childUI["ok"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ConfimBtn1",
		x = _w - 80,
		y = -_h + 60,
		scaleT = 0.9,
		code = function()
			_CODE_CloseResultFrm()
			hApi.EnterWorld()
		end,
	})
	_childUI["ok"]:setstate(-1)

	--Title
	_childUI["labelBattleResult"] = hUI.label:new({
		parent = _parent,
		x = _w/2,
		y = -70,
		align = "MC",
		text = "",
		font = hVar.FONTC,
		size = 34,
		border = 1,
	})

	--power info
	--_childUI["powerinfo"] = hUI.label:new({
		--parent = _parent,
		--x = 40,
		--y = -428,
		--align = "LC",
		--text = hVar.tab_string["__TEXT__PVP_RS_info1"],
		--font = hVar.FONTC,
		--size = 24,
		--border = 1,
		--width = 600,
	--})
	--_childUI["powerinfo"].handle._n:setVisible(false)
	
	local __AddUnitGrid = function(x,y,units,name,text,slot)
		local _IWH,_GWH = 60,64
		local _fontSize = 28
		local grid = {}
		for i = 1,#units do
			grid[#grid+1] = 0
		end
		
		_childUI["label"..name] = hUI.label:new({
			parent = _parent,
			x = x+50,
			y = y,
			text = text,
			size = _fontSize,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
		})
		_RemoveList[#_RemoveList+1] = "label"..name
		if #grid==0 then
			--grid[1] = 1
			_childUI["perfect"..name] = hUI.label:new({
				parent = _parent,
				x = 380,
				y = y,
				text = hVar.tab_string["__TEXT_perfect"],
				size = _fontSize,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
			})
			_RemoveList[#_RemoveList+1] = "perfect"..name
			return 
		end

		_childUI["image"..name] = hUI.bagGrid:new({
			parent = _parent,
			x = x + 110,--x-_GWH*(#grid-1)/2,
			y = y,
			tab = hVar.tab_unit,
			tabModelKey = "model",
			animation = function(id,model)
				return hApi.animationByFacing(model,"stand",180)
			end,
			iconW = _IWH,
			iconH = _IWH,
			gridW = _GWH,
			gridH = _GWH,
			centerY = -8,
			smartWH = 1,
			num = {font = "numWhite",size = -1,x=-35,y=6},
			slot = slot,
			grid = grid,
			item = units,
		})
		_RemoveList[#_RemoveList+1] = "image"..name
	end

	local __AddLogUI = function(oUnitD,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,Target,isVictory,oDefeatHero)
		local HeroId = 0
		local HeroIcon = ""
		local HeroName = ""
		if oDefeatHero and (Target == 0 or Target == nil or oUnitD == Target) then 
			Target = oDefeatHero 
		end
		local EnemyHeroIcon = hVar.tab_unit[Target.data.id].icon
		local EnemyName = hVar.tab_stringU[Target.data.id][1]
		local panimation = "normal"
		local imageX,imageY = 72,-345
		local pmode = "model"
		local palign = "LT"

		if oUnitD~=nil then
			local oHero = oUnitD:gethero()
			if oHero~=nil then
				HeroId = oHero.data.id
				HeroIcon = oHero.data.icon
				HeroName = hVar.tab_stringU[HeroId][1]
			else
				HeroId = 0
				HeroIcon = hApi.GetTableValue(hVar.tab_unit,oUnitD.data.id).model or ""
				if HeroIcon == "" then
					local thumbPath = hApi.GetImagePath("icon/xlobj/"..oUnitD.handle.xlPath..".png")
					HeroIcon = hApi.FileExists(thumbPath) and thumbPath or hApi.GetFilePath("xlobj/"..oUnitD.handle.xlPath..".png")
					pmode = "file"
					palign = "MC"
				end
				HeroName = hVar.tab_stringU[oUnitD.data.id][1]
			end
		end

		--���ʤ�������ʧ����ȥ��Ӣ��
		if isVictory == 1 then
			local templist = tLostUnits
			for i = 1,#templist do
				if templist[i][1] == HeroId then
					templist[i] = 0
				end
			end
			tLostUnits = {}
			for i = 1,#templist do
				if templist[i] ~= 0 then
					tLostUnits[#tLostUnits+1] = templist[i]
				end
			end
		else
			--������ ����ʧ�б����� ���� �������
			local templist = tLostUnits
			for i = 1,#templist do
				if hVar.tab_unit[templist[i][1]].type == 3 then
					templist[i] = 0
				end
			end
			tLostUnits = {}
			for i = 1,#templist do
				if templist[i] ~= 0 then
					tLostUnits[#tLostUnits+1] = templist[i]
				end
			end

			--����ǹ���ս ����� ���س�Ӣ�۵�team ��Ϊ��ʧ�б�
			local tempT = oUnitD:gettown()
			if tempT then
				local gu = tempT:getunit("guard")
				if gu then
					tLostUnits = {}
					for k,v in pairs(gu.data.team) do
						if type(v) == "table" then
							tLostUnits[#tLostUnits+1] = v
						end
					end
				end
			end
		end

		_childUI["imageHeroIconbg0"] = hUI.image:new({
			parent = _parent,
			model = "UI:slotBig",
			animation = "lightSlim",
			x = 72,
			y = -84,
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIconbg0"

		_childUI["imageHeroIcon"] = hUI.image:new({
			parent = _parent,
			x = 72,
			y = -84,
			w = 72,
			h = 72,
			smartWH = 1,
			model = HeroIcon,
			mode = pmode,
			align = palign,
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIcon"

		--�Լ���Ӣ��ͼ��
		_childUI["imageHeroIconbg"] = hUI.image:new({
			parent = _parent,
			model = "UI:slotBig",
			animation = "lightSlim",
			x = 72,
			y = -231,
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIconbg"

		_childUI["imageHeroIconbig"] = hUI.image:new({
			parent = _parent,
			x = 72,
			y = -231,
			w = 72,
			h = 72,
			smartWH = 1,
			model = HeroIcon,
			mode = pmode,
			align = palign,
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIconbig"

		_childUI["heroNmae"] = hUI.label:new({
			parent = _parent,
			x = 74,
			y = -285,
			text = HeroName,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		_RemoveList[#_RemoveList+1] = "heroNmae"

		--ս���غ���
		_childUI["CombatEvaluation"] = hUI.label:new({
			parent = _parent,
			x = _w/2 + 150,
			y = -110,
			text = hVar.tab_string["__TEXT_Roundcount1"],
			size = 26,
			--align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
		})
		_RemoveList[#_RemoveList+1] = "CombatEvaluation"


			_childUI["GetScore1"] = hUI.label:new({
				parent = _parent,
				x = _w/2 + 250,
				y = -110,
				text = roundcount,
				size = 26,
				--align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 300,
			})
			_RemoveList[#_RemoveList+1] = "GetScore1"

		--��ͨ��λ
		if hVar.tab_unit[Target.data.id].type == 1 then
			EnemyHeroIcon = hVar.tab_unit[Target.data.id].model
			panimation = hApi.animationByFacing(EnemyHeroIcon,"stand",180)
			imageY = -361
			pmode = "model"
			palign = "LT"
		end
		--��Ӣ�� 
		if hVar.tab_unit[Target.data.id].type == 2 then
			if hVar.tab_unit[Target.data.id].icon then
				EnemyHeroIcon = hVar.tab_unit[Target.data.id].icon
				pmode = "model"
				palign = "LT"
				panimation = "normal"
			else
				EnemyHeroIcon = hVar.tab_unit[Target.data.id].model
				imageY = -361
				pmode = "model"
				palign = "LT"
				panimation = hApi.animationByFacing(EnemyHeroIcon,"stand",180)
			end
		end
		--�����佫������ͼ ͷ��
		_childUI["imageHeroIconbg1"] = hUI.image:new({
			parent = _parent,
			model = "UI:slotBig",
			animation = "lightSlim",
			--w = 78,
			--h = 78,
			x = 72,
			y = -341,
			RGB = {255,255,255},
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIconbg1"

		_childUI["imageHeroIconbig1"] = hUI.image:new({
			parent = _parent,
			x = imageX,
			y = imageY+4,
			w = 72,
			h = 72,
			smartWH = 1,
			model = EnemyHeroIcon,
			animation = panimation,
			mode = pmode,
			align = palign,
		})
		_RemoveList[#_RemoveList+1] = "imageHeroIconbig1"

		_childUI["heroNmae1"] = hUI.label:new({
			parent = _parent,
			x = 74,
			y = -397,
			text = EnemyName,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		_RemoveList[#_RemoveList+1] = "heroNmae1"

		__AddUnitGrid(100,-235,tLostUnits,"ArmyLost",hVar.tab_string["__TEXT_ArmyLost"],{model = "UI:slotSmall"})
		__AddUnitGrid(100,-347,tKillUnits,"EnemyKilled",hVar.tab_string["__TEXT_EnemyKilled"],{model = "UI:slotSmall"})
	end

	local __AddTittleUI = function(oUnitC,oUnitV,oUnitD,nStar,nScore)
		if oUnitC==oUnitV then
			--ʤ��
			_childUI["labelBattleResult"]:setText(hVar.tab_string["__NETBATTLEFIELD_VICTORY_TEXT__"])
			_childUI["labelBattleResult"].handle.s:setColor(ccc3(100,255,0))
		elseif oUnitC==oUnitD then
			--ʧ��
			_childUI["labelBattleResult"]:setText(hVar.tab_string["__NETBATTLEFIELD_DEFEATEED_TEXT__"])
			_childUI["labelBattleResult"].handle.s:setColor(ccc3(255,0,0))
		end
	end

	--�ȴ���������Ӧ��״̬ͼ��
	_childUI["Account_waiting"] =hUI.image:new({
		parent = _parent,
		model = "MODEL_EFFECT:waiting",
		x = _w/2,
		y = -_h/2,
		z = 1,
	})
	_childUI["Account_waiting"].handle._n:setVisible(false)

	local _roundcount = 0
	local _CODE_ShowBFResult = function(oWorld,oUnitC,oUnitE,oUnitV,oUnitD)
		local _,tLostUnits,tKillUnits,IsSurrender,roundcount,BattlefieldType,Target,nStar,nScore = hApi.CountKillAndLost(oWorld,hGlobal.LocalPlayer)
		_roundcount = roundcount
		if oUnitC==oUnitV then
			__AddLogUI(oUnitC,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,oUnitE,1,oUnitV)
		else
			__AddLogUI(oUnitC,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,oUnitE,0,oUnitV)
		end
		__AddTittleUI(oUnitC,oUnitV,oUnitD,nStar,nScore)
	end
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(oWorld,oUnitV,oUnitD,nReason)
		--_childUI["powerinfo"].handle._n:setVisible(false)
		_RemoveFunc()
		local oUnitC,oUnitE
		if oUnitV:getowner():allience(hGlobal.LocalPlayer)==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
			--ʧ��
			hApi.PlaySoundBG(g_channel_battle,0)
			hApi.PlaySound("battle_lose")
			oUnitC = oUnitD
			oUnitE = oUnitV
		else
			--ʤ��
			hApi.PlaySoundBG(g_channel_battle,0)
			hApi.PlaySound("battle_win")
			oUnitC = oUnitV
			oUnitE = oUnitD
		end
		local tNetData = oWorld.data.netdata
		if oWorld.data.IsReplay==1 then
			--��¼��
			--¼��Ļ���ֱ�ӿ��Ե�ر�
			_CODE_ShowBFResult(oWorld,oUnitC,oUnitE,oUnitV,oUnitD)
			_childUI["ok"]:setstate(1)
		elseif tNetData.IsPVE==1 then
			if tNetData.IsRank == 1 then							--���ݷ���սǰ����
				--�ϴ�ս��¼��
				if g_PVP_NetSaveData.PVPSwitch.upload_replay==1 then
					hApi.PVPC2lSendReplay(oWorld,oUnitV.data.owner,"npc_rank_king") 
				end
				
				_CODE_ShowBFResult(oWorld,oUnitC,oUnitE,oUnitV,oUnitD)			--��ʾ��ʧ����
				_childUI["Account_waiting"].handle._n:setVisible(true)			--����ȴ�ͼ��
				_childUI["ok"]:setstate(0)						--�趨OK��ť��Ч
				_CODE_L2CShowResult()
			else										--ѵ�������Զ�ս
				--PVEս������
				_CODE_ShowBFResult(oWorld,oUnitC,oUnitE,oUnitV,oUnitD)
				_childUI["ok"]:setstate(1)
				--�ϴ�����Ե�¼��
				if g_PVP_NetSaveData.PVPSwitch.upload_replay==1 then
					hApi.PVPC2lSendReplay(oWorld,oUnitV.data.owner,"npc_replay")
				end
			end
		elseif nReason==0 or nReason == 2 then
			--��ͨ�Ծ�
			hApi.PVPC2LSendResult(oWorld,oUnitV.data.owner)
			if oUnitV.data.owner==hGlobal.LocalPlayer.data.playerId and tNetData.roomid~=0 and g_PVP_NetSaveData.PVPSwitch.upload_replay==1 then
				hApi.PVPC2lSendReplay(oWorld,oUnitV.data.owner,"replay")
			end
			_CODE_ShowBFResult(oWorld,oUnitC,oUnitE,oUnitV,oUnitD)
			--��ͨ�Ծ��ϴ�ս��
			_childUI["Account_waiting"].handle._n:setVisible(true)
			_childUI["ok"]:setstate(0)
			_CODE_L2CShowResult()
		end

		--_childUI["powerinfo"]:setText("")--hVar.tab_string["__TEXT_Get1"]..hVar.tab_string["__TEXT__Account_Strength"].." + "..1000)

		_frm:show(1,"appear")
	end)

	local _nextAction = hApi.DoNothing

	local End_pos = {}

	local _rs_item_num = 0
	local _rs_max_item_num = 0
	local _runActionCallBack = function()
		if _rs_item_num == _rs_max_item_num then
			_childUI["ok"]:setstate(1)
		else
			_nextAction()
		end
	end
	
	_nextAction = function()
		_rs_item_num = _rs_item_num + 1
		_childUI["pvp_result_".._rs_item_num].handle._n:setVisible(true)
		_childUI["pvp_result_".._rs_item_num].handle._n:setPosition(End_pos[_rs_item_num][1] + 1000,End_pos[_rs_item_num][2])
		_childUI["pvp_result_".._rs_item_num].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.5,ccp(End_pos[_rs_item_num][1],End_pos[_rs_item_num][2])),CCCallFunc:create(_runActionCallBack)))
	end
	--����Ľ������
	local _createItem = function(name,type,num,rs)
		_childUI[name] = hUI.node:new({
			parent = _parent,
		})
		_childUI[name].handle._n:setVisible(false)

		--����
		_childUI[name].childUI["bg"] = hUI.image:new({
			parent = _childUI[name].handle._n,
			model = "UI:pvptlbackf",
		})
		--��������ͼ��
		local type_model = hVar.PVP_ResultArt[type][1]
		local type_rs
		if hVar.PVP_ResultInfoLab[rs]~=nil then
			type_rs = hVar.tab_string[hVar.PVP_ResultInfoLab[rs]]
		else
			type_rs = hVar.tab_string[rs]
		end
		
		local tempW,tempH = nil,nil
		if type == "game_score" then
			tempW,tempH = 36,36
		end

		_childUI[name].childUI["icon"] = hUI.image:new({
			parent = _childUI[name].handle._n,
			model = type_model,
			w = tempW,
			h = tempH,
		})
		
		local tempX,tempY = 20,-14
		local align = "RC"
		local font
		if type_rs == "" then
			tempX = 0
			tempY = -34
			align = "MC"
		end
		local sNum = tostring(num)
		if sNum=="0" then
			font = "numWhite"
		elseif string.find(sNum,"-") then
			font = "numRed"
		else
			font = "numGreen"
		end
		--��������
		_childUI[name].childUI["num"] = hUI.label:new({
			parent = _childUI[name].handle._n,
			x = tempX,
			y = tempY,
			align = align,
			font = font,
			text = sNum,
			size = 16,
			border = 1,
		})
		
		
		--����ԭ��
		_childUI[name].childUI["res"] = hUI.label:new({
			parent = _childUI[name].handle._n,
			y = -34,
			font = hVar.FONTC,
			align = "MC",
			text = type_rs,
			size = 22,
			border = 1,
		})
	end

	--���������Ŀ
	local _createResult = function(cmdStr)
		_rs_max_item_num = 0
		_rs_item_num = 0
		for i = 1,#_rs_lab_list do
			hApi.safeRemoveT(_childUI,_rs_lab_list[i]) 
		end
		_rs_lab_list = {}
		End_pos = {}

		--�����������
		local Result_data = {}
		local i = 0
		for str in string.gfind(cmdStr,"([^%;]+);+") do
			i = i + 1
			Result_data[i] = {}
			for str_ditile in string.gfind(str..":","([^%:]+):+") do
				Result_data[i][#Result_data[i]+1] = str_ditile
			end

		end
		_rs_max_item_num = i
		
		local pvp_coin_num = 0
		--�������
		for k,v in pairs(Result_data) do
			local rs_type,rs_num,rs_cause = unpack(v)
			--��������ӻ��������Ϣ ��ֱ�� ���ӻ���
			if rs_type == "game_score" then
				LuaAddPlayerScore(tostring(rs_num))
			end

			if rs_type == "pvp_coin" then
				pvp_coin_num = pvp_coin_num + tonumber(rs_num)
			end

			_createItem("pvp_result_"..k,rs_type,rs_num,rs_cause)
			_rs_lab_list[#_rs_lab_list+1] = "pvp_result_"..k
			End_pos[k] = {64 + (k-1) * 68,-476}
		end

		--local oWorld = hGlobal.NetBattlefield
		--if oWorld then
			--if pvp_coin_num < 20 and oWorld.data.netdata.IsPVE== 0 then
				--_childUI["powerinfo"].handle._n:setVisible(true)
			--else
				--_childUI["powerinfo"].handle._n:setVisible(false)
			--end
		--end

		_nextAction()
	end

	local _temp_L2CResult = {0,""}
	_CODE_L2CShowResult = function()												--��ʾ������
		if _temp_L2CResult[1]>0 and (hApi.gametime()-_temp_L2CResult[1])<=10000 then
			_childUI["Account_waiting"].handle._n:setVisible(false)
			_createResult(_temp_L2CResult[2])										--���������Ŀ
			_temp_L2CResult = {0,""}
			return 1
		else
			return 0
		end
	end

	hGlobal.event:listen("LocalEvent_RecvNetBattlefieldResult","_changeState",function(cmdStr)					--���մӷ������ϴ�������ս����������
		_temp_L2CResult = {hApi.gametime(),cmdStr}
		if _frm.data.show==1 then
			_CODE_L2CShowResult()												--��ʾ������
		end
	end)

	--����ҵ����ˣ����Ҹ����������ʾ����ô����Լ��ص�
	hGlobal.event:listen("LocalEvent_PVPMap","__NBRF__AutoCloseOnDisconnect",function(nState)
		if nState==0 and _frm.data.show==1 then
			_CODE_CloseResultFrm()
		end
	end)

	----------------
	--���ܺ���
	_CODE_CloseResultFrm = function()
		_frm:show(0)
		_RemoveFunc()
	end
end