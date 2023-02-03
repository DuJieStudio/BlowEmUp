hGlobal.UI.InitDiabloSkillUpInfoFrm_InMap = function(mode)
	local _nSourceStartX = (hVar.SCREEN.w - 360)/2 + 40		--��ԴX������ʼλ��
	local _nSourceStartY = -60				--��ԴY������ʼλ��
	local _nCloseBtnX = 110					--�رհ�ťX����

	local _tRemoveUIList = {}				--��Ҫ�����UI�б�
	local _tSkillTreeUIData = {				--ս���츳����
		--ԭ��
		--[6000] = {
			--["skillUI"] = {
				--{-388,-18,60},
				--{-14,185,300},
				----{124,210,240},
				--{172,194,180},
				--{-309,-150,60},
				----{131,-201,60},
				--{92,-210,120},
			--}
		--},
		--0.8��
		[6000] = {
			["skillUI"] = {
				{-390,-10,60},
				{-26,178,300},
				{184,188,180},
				{-308,-132,60},
				{104,-204,120},
			}
		},
	}
	local _SkillEnermyUIRotate = {-60,0,60,120,180,240}
	local _SkillEnermyUIData = {
		{-1,1,-60},
		{1,2,0},
		{1,0,60},
		{0,-1,120},
		{-1,0,180},
		{-2,0,240},
	}

	local _nSkillTreeScale = 1			--ս���츳���ű���
	local _nRightAreaOffX = 0			--�ұ�����Xƫ��(ս���츳��)
	local _nRightAreaOffY = -30			--�ұ�����Yƫ��(ս���츳��)
	local _nCurrent_unit_id = 0			--��ǰս��id
	local _tSkillTreeData = {}			--�츳������
	local current_is_in_action = false		--�������б�־
	local _bShowPoint = false			--����ʾ���ܵ�
	local _tempSkillUpList = {}
	local _tCallback				--�����¼��ص�
	local _nIsGuide = 0

	local _Code_ClearFunc = hApi.DoNothing		--������
	local _Code_CreateSkillTree = hApi.DoNothing	--�����츳��
	local _Code_GetSkillTreeData = hApi.DoNothing	--��ȡ�츳������
	local OnCreateSkillUpTip = hApi.DoNothing	--������������
	local OnClickUpgrateSkillBtn = hApi.DoNothing
	local _Code_UpdateTacticsSkill = hApi.DoNothing	--����ս���������
	local _Code_DoCallBack = hApi.DoNothing

	--�������ܼ����������
	hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap = hUI.frame:new({
		x = 0,
		y = hVar.SCREEN.h,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		dragable = 2,
		show = 0, --һ��ʼ����ʾ
		border = 0, --��ʾframe�߿�
		background = "misc/skillup/background.png",
		autoactive = 0,
	})

	local _frm = hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--���������ͼ
	_childUI["GoldNumBG"] = hUI.image:new({
		parent = _parent,
		model = "UI:selectbg",
		x = _nSourceStartX + 100,
		y = _nSourceStartY,
		w = 240,
		h = 36,
	})

	_childUI["img_score"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/mu_coin.png",
		x = _nSourceStartX,
		y = _nSourceStartY,
		scale = 1.0,
	})

	_childUI["lab_score"] = hUI.label:new({
		parent = _parent,
		x = _nSourceStartX + 60,
		y = _nSourceStartY - 1,
		width = 200,
		align = "LC",
		font = "num",
		border = 0,
		size = 22,
		text = "0",
	})

	_childUI["buycoin"] = hUI.button:new({
		parent = _parent,
		model = "misc/button_null.png",
		--model = "misc/skillup/addtimes.png",
		dragbox = _frm.childUI["dragBox"],
		x = _nSourceStartX + 200,
		y = _nSourceStartY - 1,
		w = 80,
		h = 80,
		scaleT = 0.95,
		code = function(self, screenX, screenY, isInside)
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				oWorld.data.keypadEnabled = false
				hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm_new")
			end
		end
	})
	
	_childUI["buycoin"].childUI["img"] = hUI.button:new({
		parent = _childUI["buycoin"].handle._n,
		model = "misc/skillup/addtimes.png",
	})
	
	_childUI["img_man"] = hUI.image:new({
		parent = _parent,
		model = "misc/gameover/icon_man.png",
		align = "MC",
		scale = 0.7,
		x = _nSourceStartX + 300,
		y = _nSourceStartY,
	})
	
	_childUI["lab_man"] = hUI.label:new({
		parent = _parent,
		x = _nSourceStartX + 350,
		y = _nSourceStartY - 1,
		width = 500,
		align = "LC",
		font = "num",
		border = 0,
		size = 22,
		text = "0",
	})
	
	_childUI["img_point"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/skillpoint.png",
		x = _nSourceStartX + 220,
		y = _nSourceStartY,
		scale = 1.0,
	})
	_childUI["img_point"].handle._n:setVisible(_bShowPoint)

	_childUI["lab_point"] = hUI.label:new({
		parent = _parent,
		x = _nSourceStartX + 280,
		y = _nSourceStartY - 1,
		width = 500,
		align = "LC",
		font = "numWhite",
		border = 0,
		size = 22,
		text = "0",
	})
	_childUI["lab_point"].handle._n:setVisible(_bShowPoint)
	
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/skillup/back.png",
		x = _nCloseBtnX,
		y = _nSourceStartY,
		scaleT = 0.95,
		code = function()
			--�ڶ����н�ֹ���
			if current_is_in_action then
				return
			end
			_frm:show(0)
			_Code_UpdateTacticsSkill()
			_Code_DoCallBack()
			_Code_ClearFunc()
			hGlobal.event:event("LocalEvent_RefreshCurGameScore")
			
			--�ͷ�png, plist�������棨���ﲻ����Ҳ���ԣ�
			--hApi.ReleasePngTextureCache()
		end,
	})
	
	_childUI["lab_point2"] = hUI.label:new({
		parent = _parent,
		x = _nSourceStartX + 440,
		y = _nSourceStartY + 1,
		width = 500,
		height = 40,
		align = "LC",
		font = hVar.FONTC,
		border = 1,
		size = 24,
		text = hVar.tab_string["options_left"] .. " : 0",
	})
	
	_Code_ClearFunc = function()
		for i = 1,#_tRemoveUIList do
			hApi.safeRemoveT(_childUI,_tRemoveUIList[i])
		end
		_tRemoveUIList = {}
		_nCurrent_unit_id = 0			--��ǰս��id
		_tCallback = nil
		_tSkillTreeData = {}
		_tempSkillUpList = {}
	end

	_Code_DoCallBack = function()
		if type(_tCallback) == "table" then
			local talentPointNum = LuaGetHeroMapTalentPoint()
			local haveNoPoint = 0
			if talentPointNum == 0 then
				haveNoPoint = 1
			end
			hGlobal.event:event(_tCallback[1],_tCallback[2],haveNoPoint)
		end
	end

	--����UI
	_Code_UpdateUI = function()
		local curScore = LuaGetPlayerScore() --��ǰ����
		local talentPointNum = LuaGetHeroMapTalentPoint()
		_childUI["lab_score"]:setText(curScore)
		_childUI["lab_point"]:setText(talentPointNum)
		_childUI["lab_point2"]:setText(hVar.tab_string["options_left"] .. " : "..talentPointNum)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local mannumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		_childUI["lab_man"]:setText(mannumber)
	end

	--��ȡ�츳������
	_Code_GetSkillTreeData = function()
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --��λ�츳���ܱ�
		for i = 1,#talent_tree do
			local ttree = talent_tree[i] or {}
			local tacticId = ttree.tacticId or 0 --ս������id
			local tabT = hVar.tab_tactics[tacticId] or {}
			local lv = LuaGetHeroMapTalentSkillLv(i)
			_tSkillTreeData[i] = {
				model = tabT.icon,
				attrPointMaxLv = ttree.attrPointMaxLv,
				attrPointUpgrade = ttree.attrPointUpgrade,
				attrPointRestore = ttree.attrPointRestore,
				--��ǰ�ȼ����������ͼ��
				--attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id,i),
				attrPointLv = lv,
				tacticId = tacticId,
			}
			if lv > 0 then 
				_tempSkillUpList[tacticId] = {lv,i,lv}
			end
		end
	end

	--�����츳��
	_Code_CreateSkillTree = function()
		local nodeXY = {hVar.SCREEN.w/2 + _nRightAreaOffX,-hVar.SCREEN.h/2 + _nRightAreaOffY}
		--ս���츳�ڵ�
		_childUI["skilltreenode"] = hUI.node:new({
			parent = _parent,
			x = nodeXY[1],
			y = nodeXY[2],
		})
		_tRemoveUIList[#_tRemoveUIList+1]="skilltreenode"
		local nodeChildUI = _childUI["skilltreenode"].childUI
		local nodeParent = _childUI["skilltreenode"].handle._n
		_childUI["skilltreenode"].handle._n:setScale(_nSkillTreeScale)

		nodeChildUI["bg"] = hUI.image:new({
			parent = nodeParent,
			model = "misc/skillup/skilltreebg_"..tostring(_nCurrent_unit_id)..".png",
		})

		local tUiData = _tSkillTreeUIData[_nCurrent_unit_id]
		for i = 1,#tUiData.skillUI do
			local v = tUiData.skillUI[i]
			local tSkillData = _tSkillTreeData[i]
			local scale = 0.8
			--���ܱ���ͼ
			nodeChildUI["skillbg"..i] = hUI.image:new({
				parent = nodeParent,
				model = "misc/skillup/skillbg.png",
				x = v[1],
				y = v[2],
			})
			nodeChildUI["skillbg"..i].handle._n:setRotation(v[3])
			nodeChildUI["skillbg"..i].handle._n:setScale(scale)

			--���ܰ�ť
			_childUI["button"..i] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = tSkillData.model,
				x = nodeXY[1] + v[1]*_nSkillTreeScale,
				y = nodeXY[2] + (v[2]-1)*_nSkillTreeScale,
				scaleT = 0.95,
				scale = _nSkillTreeScale*scale,
				code = function()
					print("i",i)
					OnCreateSkillUpTip(i)
				end,
			})
			_tRemoveUIList[#_tRemoveUIList+1]="button"..i

			_Code_UpdateSkillState(i)
		end
	end

	--�����츳״̬
	_Code_UpdateSkillState = function(nCurrentSkillIdx)
		if type(_tSkillTreeData) == "table" and type(_tSkillTreeData[nCurrentSkillIdx]) == "table" then
			local tSkillData = _tSkillTreeData[nCurrentSkillIdx]
			local attrPointLv = tSkillData.attrPointLv		--��ǰ�ȼ�
			local attrPointMaxLv = tSkillData.attrPointMaxLv	--��ߵȼ�
			local attrPointUpgrade = tSkillData.attrPointUpgrade	--��������
			local nShowNumByOne = 1/attrPointMaxLv*6		--1����Ҫ��ʾ������
			local nShowNum = attrPointLv/attrPointMaxLv*6		--��Ҫ��ʾ������
			local nShowActionNum = nShowNum				--��Ҫ��˸������
			if attrPointLv == 0 then
				_childUI["button"..nCurrentSkillIdx].handle.s:setColor(ccc3(128,128,128))
			else
				_childUI["button"..nCurrentSkillIdx].handle.s:setColor(ccc3(255,255,255))
			end
			if attrPointLv < attrPointMaxLv then
				local requireAttrPoint = attrPointUpgrade.requireAttrPoint or 0
				local requireScore = attrPointUpgrade.requireScore or 0
				local curScore = LuaGetPlayerScore() --��ǰ����
				local talentPointNum = LuaGetHeroMapTalentPoint()
				if curScore >= requireScore and talentPointNum >= requireAttrPoint then
					nShowActionNum = nShowNum + nShowNumByOne
				end
			end
			if _nIsGuide == 1 and tSkillData.tacticId ~= 3003 then
				return
			end
			for j = 1,6 do
				if _childUI["button"..nCurrentSkillIdx].childUI["energy"..j] then
					hApi.safeRemoveT(_childUI["button"..nCurrentSkillIdx].childUI,"energy"..j)
				end
				if j <= nShowActionNum then
					local data = _SkillEnermyUIData[j]
					_childUI["button"..nCurrentSkillIdx].childUI["energy"..j] = hUI.image:new({
						parent = _childUI["button"..nCurrentSkillIdx].handle._n,
						model = "misc/skillup/skill_energy.png",
						x = 0 + data[1],
						y = 0 + data[2],
						z = -1,
						scale = _nSkillTreeScale * 0.8,
					})
					_childUI["button"..nCurrentSkillIdx].childUI["energy"..j].handle._n:setRotation(data[3])
					if j > nShowNum then
						local act1 = CCFadeIn:create(0.8) --����
						local actDelay1 = CCDelayTime:create(0.05)
						local act2 = CCFadeOut:create(0.8)
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(actDelay1)
						a:addObject(act2)
						a:addObject(actDelay1)
						local sequence = CCSequence:create(a)
						_childUI["button"..nCurrentSkillIdx].childUI["energy"..j].handle.s:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
		end
	end

	_Code_UpdateTacticsSkill = function()
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			local tUpdateTactics = {}
			local tTactics = {}
			for tacticsId,info in pairs(_tempSkillUpList) do
				local nNewlv = info[1]
				local index = info[2]
				local nOldlv = info[3]
				if nOldlv > 0 then
					tUpdateTactics[tacticsId] = nOldlv
				end
				if nNewlv > 0 then
					tTactics[#tTactics+1]={tacticsId,nNewlv}
				end
			end
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --�ҵ���Ҷ���
			local oUnit
			if type(oPlayerMe.heros) == "table" then
				local oHero = oPlayerMe.heros[1]
				if oHero then
					oUnit = oHero:getunit()
				end
			end
			--table_print(tTactics)
			--table_print(tUpdateTactics)
			if oUnit then
				for tacticId,lv in pairs(tUpdateTactics) do
					--oWorld:enumunit(function(u)
						--oPlayerMe:tacticsRemoveEffect(oWorld,u,tacticId,lv)
					--end)
					oPlayerMe:tacticsRemoveEffect(oWorld,oUnit,tacticId,lv)
					oPlayerMe:removetactics(tUpdateTactics)
				end
				if #tTactics > 0 then
					oWorld:settactics(oPlayerMe, tTactics)
					--oWorld:enumunit(function(u)
						--oPlayerMe:tacticsTakeEffect(oWorld,u,true)
					--end)
					oPlayerMe:tacticsTakeEffect(oWorld,oUnit,true)
					
				end
				hGlobal.event:event("Event_UpdatePassiveTactics")
				hGlobal.event:event("Event_UpdateActiveTactics")
			end
		end
			
	end

	--�������������ܼ�������tip���
	OnCreateSkillUpTip = function(skillIdx)
		--�������һ�εļ���˵�����
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
		
		--��ȡ��λ����
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --��λ�츳���ܱ�
		local talentPointNum = LuaGetHeroMapTalentPoint() --��λ���츳����
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --ս������id

		if tacticId ~= 3003 and _nIsGuide == 1 then
			return
		end
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --�츳�ȼ�����
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --�츳�������ϱ�
		local attrPointRestore = ttree.attrPointRestore or {} --�츳���ò��ϱ�
		--local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --���ܵ�ǰ�ȼ�
		local attrPointLv = LuaGetHeroMapTalentSkillLv(skillIdx)
		local requireAttrPoint = 0 --������Ҫ�ļ��ܵ���
		local requireScore = 0 --������Ҫ�Ļ���
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --��ǰ����
		local oWorld = hGlobal.WORLD.LastWorldMap
		local requireMan = 3	--������Ҫ�Ĺ���ʦ
		local curManNumber = 0
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end

		if (talentPointNum < requireAttrPoint and _bShowPoint == false) then
			return
		end

		--��������˵�����
		hGlobal.UI.GameCoinTipFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 1,
			--dragable = 2,
			dragable = 2, --�������ʧ
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --����ť����̧��Ҳ����Ӧ�¼�
			background = -1, --�޵�ͼ
			border = 0, --�ޱ߿�
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		local _SkillParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _SkillChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2

		--�رհ�ť����
		_SkillChildUI["closebtn"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/mask_white.png", --"UI:playerBagD"
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			x = 0,
			y = 0,
			z = -1,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			scaleT = 1.0,
			code = function(self, screenX, screenY, isInside)
				--�ڶ����н�ֹ���
				if current_is_in_action then
					return
				end
				
				--ɾ��������
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
				
				hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
				
				--������Ч���رռ�����������
				--hApi.PlaySound("common_close_popup_window")
				hApi.PlaySound("Button2")
			end,
		})
		_SkillChildUI["closebtn"].handle.s:setOpacity(88)
		_SkillChildUI["closebtn"].handle.s:setColor(ccc3(0, 0, 0))
		
		--��������tipͼƬ����
		_SkillChildUI["ItemBG_1"] = hUI.button:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			x = _offX + 100,
			y = _offY,
			--w = 512,
			--h = 416,
			code = function()
				--print("����tipͼƬ����")
			end,
		})

		local nShowY = _offY + 110
		if (attrPointLv >= attrPointMaxLv) then
			nShowY = _offY + 5
		end
		--���ܱ���ͼ
		_SkillChildUI["skillbg"] = hUI.image:new({
			parent = _SkillParent,
			model = "misc/skillup/skillbg.png",
			x = _offX - 65,
			y = nShowY,
			scale = 0.9,
		})
		_SkillChildUI["skillbg"].handle._n:setRotation(60)

		local nShowNumByOne = 1/attrPointMaxLv*6		--1����Ҫ��ʾ������
		local nShowNum = attrPointLv/attrPointMaxLv*6		--��Ҫ��ʾ������
		local nShowActionNum = nShowNum + nShowNumByOne
			
		for j = 1,#_SkillEnermyUIData do
			if j <= nShowActionNum then
				local data = _SkillEnermyUIData[j]
				_SkillChildUI["energy"..j] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skill_energy.png",
					x = _offX - 65 + data[1],
					y = nShowY + data[2],
					scale = 0.9,
				})
				_SkillChildUI["energy"..j].handle._n:setRotation(data[3])
				if j > nShowNum then
					local act1 = CCFadeIn:create(0.8) --����
					local actDelay1 = CCDelayTime:create(0.05)
					local act2 = CCFadeOut:create(0.8)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(actDelay1)
					a:addObject(act2)
					a:addObject(actDelay1)
					local sequence = CCSequence:create(a)	
					_SkillChildUI["energy"..j].handle.s:runAction(CCRepeatForever:create(sequence))
				end
			end
		end
		
		--��������tip-����ͼ��
		--print(hVar.tab_skill[skillId].icon)
		_SkillChildUI["SkillIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = tabT.icon,
			x = _offX - 65,
			y = nShowY,
			scale = 0.9,
		})
		
		--��������tip-���ܽ���
		local showAttrPointLv = attrPointLv
		if (showAttrPointLv == 0) then
			showAttrPointLv = 1
		end
		_SkillChildUI["SkillIntro"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX + 170,
			y = nShowY,
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showAttrPointLv + 1] or ("unknown" .. tacticId),
			border = 1,
		})
		if (attrPointLv <= 0) then --��δ��ü���
			_SkillChildUI["SkillIntro"].handle.s:setColor(ccc3(166, 166, 166))
		end
		
		--���ܵȼ�δ������������
		if (attrPointLv < attrPointMaxLv) then
			--�ָ���1
			_SkillChildUI["SkillSeparateLine1"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/line.png",
				x = _offX + 100,
				y = _offY + 40,
				w = 436,
				h = 8,
			})
			
			--�ָ���2
			_SkillChildUI["SkillSeparateLine2"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/line.png",
				x = _offX + 100,
				y = _offY - 60,
				w = 436,
				h = 8,
			})

			local tlist = {}
			tlist[#tlist+1] = "man"
			if (requireAttrPoint > 0 and _bShowPoint == true) then
				tlist[#tlist+1] = "point"
			end
			if (requireScore > 0) then
				tlist[#tlist+1] = "score"
			end

			local width = 150
			local shownum = #tlist
			for i = 1,shownum do
				if tlist[i] == "point" then
					--�츳�����
					_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 90,
						h = 40,
					})
					
					--�츳��ͼ��
					_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 15,
						y = _offY - 11,
						w = 40,
						h = 50,
					})
					
					--��Ҫ���츳����
					_SkillChildUI["SkillAttrPointValue"] = hUI.label:new({
						parent = _SkillParent,
						x = _offX + 100 - width*(i - (shownum+1)/2) + 35,
						y = _offY - 11 - 1,
						width = 300,
						align = "RC",
						size = 28,
						font = "numWhite",
						border = 0,
						text = requireAttrPoint,
					})
					--�����ǰ�츳�㲻�㣬���ֺ�ɫ
					if (talentPointNum < requireAttrPoint) then
						_SkillChildUI["SkillAttrPointValue"].handle.s:setColor(ccc3(255, 0, 0))
					end
				elseif tlist[i] == "score" then
					--���ֵ���
					_SkillChildUI["SkillScoreBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 120,
						h = 40,
					})
					
					--����ͼ��
					_SkillChildUI["SkillScoreIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/mu_coin.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 35,
						y = _offY - 11,
						w = 42,
						h = 42,
					})
					
					--��Ҫ�Ļ���ֵ
					_SkillChildUI["SkillScoreValue"] = hUI.label:new({
						parent = _SkillParent,
						x = _offX + 100 - width*(i - (shownum+1)/2) + 4,
						y = _offY - 11 - 1,
						width = 300,
						align = "LC",
						size = 22,
						font = "num",
						border = 0,
						text = requireScore,
					})
					--�����ǰ���ֲ��㣬���ֺ�ɫ
					if (curScore < requireScore) then
						_SkillChildUI["SkillScoreValue"].handle.s:setColor(ccc3(255, 0, 0))
					end
				elseif tlist[i] == "man" then
					--�츳�����
					_SkillChildUI["SkillManBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 90,
						h = 40,
					})
					
					--�츳��ͼ��
					_SkillChildUI["SkillManIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/gameover/icon_man.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 15,
						y = _offY - 11,
						scale = 0.7,
					})
					
					--��Ҫ���츳����
					_SkillChildUI["SkillManValue"] = hUI.label:new({
						parent = _SkillParent,
						x = _offX + 100 - width*(i - (shownum+1)/2) + 35,
						y = _offY - 11 - 1,
						width = 300,
						align = "RC",
						size = 22,
						font = "numWhite",
						border = 0,
						text = requireMan,
					})
					if curManNumber < requireMan then
						_SkillChildUI["SkillManValue"].handle.s:setColor(ccc3(255, 0, 0))
					end
				end
			end
			
			--������Ҫ�ļ��ܵ����ͻ���
			--if (requireScore <= 0) then --����Ҫ����
				
			--else --��Ҫ����
				----�츳�����
				--_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
					--parent = _SkillParent,
					--model = "misc/skillup/skillpoint_bg.png",
					--x = _offX + 5,
					--y = _offY - 11,
					--w = 90,
					--h = 40,
				--})
				
				----�츳��ͼ��
				--_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
					--parent = _SkillParent,
					--model = "misc/skillup/skillpoint.png",
					--x = _offX + 5 - 25,
					--y = _offY - 11,
					--w = 40,
					--h = 50,
				--})
				
				----��Ҫ���츳����
				--_SkillChildUI["SkillAttrPointValue"] = hUI.label:new({
					--parent = _SkillParent,
					--model = "misc/skillup/skillpoint.png",
					--x = _offX + 5 + 35,
					--y = _offY - 11 - 1,
					--width = 300,
					--align = "RC",
					--size = 28,
					--font = "numWhite",
					--border = 0,
					--text = requireAttrPoint,
				--})
				
				
			--end
			
			--ȷ����ť
			_SkillChildUI["SkillYesBtn"] = hUI.button:new({
				parent = _SkillParent,
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				scaleT = 0.95,
				x = _offX + 100,
				y = _offY - 128,
				scale = 0.74,
				--w = 124,
				--h = 52,
				code = function()
					--�ڶ����н�ֹ���
					if current_is_in_action then
						return
					end
					
					--�������ܵȼ��߼�
					OnClickUpgrateSkillBtn(skillIdx)
				end,
			})
			--�����ǰ�츳�㲻�㣬ȷ����ť�ҵ�
			if (talentPointNum < requireAttrPoint) then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end
			--�����ǰ���ֲ��㣬ȷ����ť�ҵ�
			if (curScore < requireScore) then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end

			--�����ǰ���ֲ��㣬ȷ����ť�ҵ�
			if curManNumber < requireMan then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end
			
			--ȡ����ť
			_SkillChildUI["SkillNoBtn"] = hUI.button:new({
				parent = _SkillParent,
				model = "misc/skillup/btn_close.png",
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				--scaleT = 0.95,
				x = _offX + 636/2 + 62,
				y = _offY + 416/2 - 38,
				code = function()
					--�ڶ����н�ֹ���
					if current_is_in_action then
						return
					end
					
					--��������
					if hGlobal.UI.GameCoinTipFrame then
						hGlobal.UI.GameCoinTipFrame:del()
						hGlobal.UI.GameCoinTipFrame = nil
					end
					
					hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
					
					--������Ч���رռ�����������
					--hApi.PlaySound("common_close_popup_window")
					hApi.PlaySound("Button2")
				end,
			})
		end
		
		--���ܵȼ�������ֻ��ʾ�رհ�ť
		if (attrPointLv >= attrPointMaxLv) then
			--���ж���
			_SkillChildUI["SkillIntro"]:setXY(_offX + 190, _offY + 5)
			_SkillChildUI["SkillIcon"]:setXY(_offX - 65, _offY + 5)
		end
	end

	--�������������ܵȼ��߼�
	OnClickUpgrateSkillBtn = function(skillIdx)
		--��ȡ��λ����
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --��λ�츳���ܱ�
		local talentPointNum = LuaGetHeroMapTalentPoint() --��λ���츳����
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --ս������id
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --�츳�ȼ�����
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --�츳�������ϱ�
		local attrPointRestore = ttree.attrPointRestore or {} --�츳���ò��ϱ�
		--local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --���ܵ�ǰ�ȼ�
		local attrPointLv = LuaGetHeroMapTalentSkillLv(skillIdx)
		local requireAttrPoint = 0 --������Ҫ�ļ��ܵ���
		local requireScore = 0 --������Ҫ�Ļ���
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --��ǰ����
		local requireMan = 3	--������Ҫ�Ĺ���ʦ
		local curManNumber = 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end

		--�����ѵ�����
		if (attrPointLv >= attrPointMaxLv) then
			local strText = "���������ȼ���"
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
		
		--�츳��������
		if (talentPointNum < requireAttrPoint) then
			hApi.NotEnoughResource("skillpoint")
			
			return
		end
		
		--���ֲ���
		if (curScore < requireScore) then
			hApi.NotEnoughResource("coin")
			
			return
		end

		if curManNumber < requireMan then
			hApi.NotEnoughResource("man")
			return
		end
		
		--��������
		--����ڶ����У���ֹ����
		current_is_in_action = true
		
		--�۳����ܵ�ͻ��֣��������ܵȼ�
		local newTalentPointNum = talentPointNum - requireAttrPoint
		local newScore = curScore - requireScore
		local newAttrPointLv = attrPointLv + 1
		--LuaSetHeroTalentPoint(_nCurrent_unit_id, newTalentPointNum)
		LuaSetHeroMapTalentPoint(newTalentPointNum)
		--�޸���ӻ��ֵ�ͬʱ������Դ�Ա�ͳ��
		LuaAddPlayerScoreByWay(-requireScore,hVar.GET_SCORE_WAY.UPGRADETACTICS)
		--LuaAddPlayerScore(-requireScore)
		--LuaSetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx, newAttrPointLv)
		LuaSetHeroMapTalentSkillLv(skillIdx, newAttrPointLv)
		_tSkillTreeData[skillIdx]["attrPointLv"] = newAttrPointLv
		
		--��������1
		local ACTTIME = 0.3
		local _frm2 = hGlobal.UI.GameCoinTipFrame
		if (requireAttrPoint > 0 and _bShowPoint == true) then --��Ҫ����
			local fromX = _frm.data.x + _childUI["img_point"].data.x
			local fromY = _frm.data.y + _childUI["img_point"].data.y
			local toX = _frm2.data.x + _frm2.childUI["SkillIcon"].data.x
			local toY = _frm2.data.y + _frm2.childUI["SkillIcon"].data.y

			print(fromX, fromY, toX, toY)

			local angle1 = GetLineAngle(fromX, fromY, toX, toY) --�Ƕ���
			local ctrl1 = hUI.image:new({
				parent = nil,
				x = fromX,
				y = fromY,
				z = 10000,
				model = "MODEL_EFFECT:shixue2",
				align = "MC",
				scale = 1.0,
			})
			ctrl1.handle.s:setRotation(angle1)
			
			local config = ccBezierConfig:new()
			config.controlPoint_1 = ccp(fromX, fromY)     
			config.controlPoint_2 = ccp(fromX - (fromX - toX) / 1.5, fromY + (fromY - toY) / 2)
			config.endPosition = ccp(toX, toY)
			local moveto = CCBezierTo:create(ACTTIME, config)
			--local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
			local callback = CCCallFunc:create(function()
				ctrl1:del()
			end)
			ctrl1.handle._n:runAction(CCSequence:createWithTwoActions(moveto, callback))
		end
		
		--��������2
		if (requireScore > 0) then --��Ҫ����
			local fromX = _frm.data.x + _childUI["img_score"].data.x
			local fromY = _frm.data.y + _childUI["img_score"].data.y
			local toX = _frm2.data.x + _frm2.childUI["SkillIcon"].data.x
			local toY = _frm2.data.y + _frm2.childUI["SkillIcon"].data.y
			local angle2 = GetLineAngle(fromX, fromY, toX, toY) --�Ƕ���
			local ctrl2 = hUI.image:new({
				parent = nil,
				x = fromX,
				y = fromY,
				z = 10000,
				model = "MODEL_EFFECT:shixue",
				align = "MC",
				scale = 1.0,
			})
			ctrl2.handle.s:setRotation(angle2)
			
			local config = ccBezierConfig:new()
			config.controlPoint_1 = ccp(fromX, fromY)     
			config.controlPoint_2 = ccp(fromX + (toX - fromX) / 1.5, fromY + (fromY - toY) / 2)
			config.endPosition = ccp(toX, toY)
			local moveto = CCBezierTo:create(ACTTIME, config)
			--local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
			local callback = CCCallFunc:create(function()
				ctrl2:del()
			end)
			ctrl2.handle._n:runAction(CCSequence:createWithTwoActions(moveto, callback))
		end
		
		--����������
		if (requireScore > 0) then
			local delay = CCDelayTime:create(ACTTIME)
			local callback1 = CCCallFunc:create(function()
				_childUI["lab_score"]:setText(newScore)
			end)
			local scaleBig = CCScaleTo:create(0.1, 1.5)
			local scaleSmall = CCScaleTo:create(0.1, 22/26)
			local a = CCArray:create()
			a:addObject(delay)
			a:addObject(callback1)
			a:addObject(scaleBig)
			a:addObject(scaleSmall)
			local sequence = CCSequence:create(a)
			_childUI["lab_score"].handle._n:runAction(sequence)
		end

		if (requireMan > 0) then
			local delay = CCDelayTime:create(ACTTIME)
			local callback1 = CCCallFunc:create(function()
				if oWorld then
					oWorld.data.statistics_rescue_costnum = oWorld.data.statistics_rescue_costnum + requireMan
					local mannumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
					_childUI["lab_man"]:setText(mannumber)
					hGlobal.event:event("Event_ResetRescuedPerson",oWorld)
					
				end
			end)
			local scaleBig = CCScaleTo:create(0.1, 1.5)
			local scaleSmall = CCScaleTo:create(0.1, 22/26)
			local a = CCArray:create()
			a:addObject(delay)
			a:addObject(callback1)
			a:addObject(scaleBig)
			a:addObject(scaleSmall)
			local sequence = CCSequence:create(a)
			_childUI["lab_man"].handle._n:runAction(sequence)
		end
		
		--�츳��������
		local delay = CCDelayTime:create(ACTTIME)
		local callback1 = CCCallFunc:create(function()
			_childUI["lab_point"]:setText(newTalentPointNum)
			_childUI["lab_point2"]:setText(hVar.tab_string["options_left"] .. " : "..newTalentPointNum)
			for j = 1,#_tSkillTreeData do
				_Code_UpdateSkillState(j)
			end
		end)
		local scaleBig = CCScaleTo:create(0.1, 2.0)
		local scaleSmall = CCScaleTo:create(0.1, 26/26)
		local callback2 = CCCallFunc:create(function()
			print("cccc")
			--��ǲ��ڶ����У����Բ���
			current_is_in_action = false

			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --�ҵ���Ҷ���
			--oWorld:settactics(oPlayerMe,{{tacticId,newAttrPointLv,0}})
			----ս�����ܿ��Ե�ͼ���н�ɫ��Ч
			--oWorld:enumunit(function(u)
				--oWorld:tacticsTakeEffect(u)
			--end)
			if _tempSkillUpList[tacticId] then
				local oldLv = _tempSkillUpList[tacticId][3] or 0
				_tempSkillUpList[tacticId] = {newAttrPointLv,skillIdx,oldLv}
			else
				_tempSkillUpList[tacticId] = {newAttrPointLv,skillIdx,attrPointLv}
			end
			--if attrPointLv > 0 then
				--local oUnit
				--if type(oPlayerMe.heros) == "table" then
					--local oHero = oPlayerMe.heros[1]
					--if oHero then
						--oUnit = oHero:getunit()
					--end
				--end
				--oPlayerMe:tacticsRemoveEffect(oWorld,oUnit,tacticId,attrPointLv)
			--end
			
			--ˢ�¼������
			OnCreateSkillUpTip(skillIdx)
		end)
		local a = CCArray:create()
		a:addObject(delay)
		a:addObject(callback1)
		a:addObject(scaleBig)
		a:addObject(scaleSmall)
		a:addObject(callback2)
		local sequence = CCSequence:create(a)
		_childUI["lab_point"].handle._n:runAction(sequence)
		
		--������Ч����������
		hApi.PlaySound("common_hero_lvlup")
	end

	hGlobal.event:listen("LocalEvent_GetSystemMailScoreAward","getaward2",function(score)
		if _frm and _frm.data.show == 1 then
			_Code_UpdateUI()
		end
	end)

	hGlobal.event:listen("LocalEvent_SetCurGameScore","__UpdateScore_bySkillupfrm",function()
		if _frm and _frm.data.show == 1 then
			_Code_UpdateUI()
		end
	end)

	--�����򿪴��ܼ�����������֪ͨ�¼�
	hGlobal.event:listen("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm_inMap", "__ShowDLCMapFrm", function(unitId,tCallback)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and oWorld.data.map == hVar.GuideMap then
			_nIsGuide = 1
		else
			_nIsGuide = 0
		end
		--��ʾ���ܼ�����������
		_frm:show(1)
		_frm:active()
		
		--�洢��λid
		_nCurrent_unit_id = unitId
		_tCallback = tCallback
		_Code_UpdateUI()
		_Code_GetSkillTreeData()
		_Code_CreateSkillTree()

		if hApi.IsReviewMode() then
			--���ģʽȫ����ʾ
			_childUI["buycoin"]:setstate(-1)
		else
			local iChannelId = xlGetChannelId()
			if iChannelId >= 100 and _childUI["buycoin"] then
				_childUI["buycoin"]:setstate(-1)
			end
		end
	end)
end

--��ȡӢ�������ͼ�츳���ܵȼ�
--function LuaGetHeroMapTalentSkillLv(skillIdx)
	--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	----local nHeroId = tInfo.tankid or hVar.MY_TANK_ID
	--local tTalentSkill = tInfo.talentskill or {}
	--return tTalentSkill[skillIdx] or 0
--end

--����Ӣ�������ͼ�츳���ܵȼ�
--function LuaSetHeroMapTalentSkillLv(skillIdx,lv)
	--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	--if tInfo.talentskill == nil then
		--tInfo.talentskill = {}
	--end
	--tInfo.talentskill[skillIdx] = lv
	--LuaSavePlayerList()
--end

--��ȡӢ�������ͼ�е��츳��
function LuaGetHeroMapTalentPoint()
	local talentPoint = 0
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		talentPoint = diablodata.randMap.talentpoint or talentPoint
	end
	return talentPoint
end

--����Ӣ�������ͼ�е��츳��
function LuaSetHeroMapTalentPoint(talentPoint)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		diablodata.randMap.talentpoint = talentPoint
	end
end

--����Ӣ�������ͼ�е��츳����
function LuaSetHeroMapTalentSkillLv(nSkillIdx, nLv)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		if diablodata.randMap.talentskill then
			diablodata.randMap.talentskill[nSkillIdx] = nLv
		end
	end
end

--��ȡӢ�������ͼ�е��츳�ȼ�
function LuaGetHeroMapTalentSkillLv(nSkillIdx)
	local lv = 0
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		if diablodata.randMap.talentskill then
			lv = diablodata.randMap.talentskill[nSkillIdx] or 0
		end
	end
	return lv
end

--if hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap then
	--hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap:del()
	--hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap = nil
--end
--hGlobal.UI.InitDiabloSkillUpInfoFrm_InMap()
--hGlobal.event:event("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm_inMap",6000)