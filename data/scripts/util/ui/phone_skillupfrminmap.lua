hGlobal.UI.InitDiabloSkillUpInfoFrm_InMap = function(mode)
	local _nSourceStartX = (hVar.SCREEN.w - 360)/2 + 40		--资源X坐标起始位置
	local _nSourceStartY = -60				--资源Y坐标起始位置
	local _nCloseBtnX = 110					--关闭按钮X坐标

	local _tRemoveUIList = {}				--需要清理的UI列表
	local _tSkillTreeUIData = {				--战车天赋数据
		--原大
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
		--0.8倍
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

	local _nSkillTreeScale = 1			--战车天赋缩放比列
	local _nRightAreaOffX = 0			--右边区域X偏移(战车天赋树)
	local _nRightAreaOffY = -30			--右边区域Y偏移(战车天赋树)
	local _nCurrent_unit_id = 0			--当前战车id
	local _tSkillTreeData = {}			--天赋树数据
	local current_is_in_action = false		--动画进行标志
	local _bShowPoint = false			--不显示技能点
	local _tempSkillUpList = {}
	local _tCallback				--用于事件回调
	local _nIsGuide = 0

	local _Code_ClearFunc = hApi.DoNothing		--清理函数
	local _Code_CreateSkillTree = hApi.DoNothing	--创建天赋树
	local _Code_GetSkillTreeData = hApi.DoNothing	--获取天赋树数据
	local OnCreateSkillUpTip = hApi.DoNothing	--创建技能升级
	local OnClickUpgrateSkillBtn = hApi.DoNothing
	local _Code_UpdateTacticsSkill = hApi.DoNothing	--更新战术卡金额能
	local _Code_DoCallBack = hApi.DoNothing

	--创建大菠萝技能升级面板
	hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap = hUI.frame:new({
		x = 0,
		y = hVar.SCREEN.h,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = "misc/skillup/background.png",
		autoactive = 0,
	})

	local _frm = hGlobal.UI.PhoneDiabloSkillUpInfoFrm_InMap
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--金币数量底图
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
			--在动画中禁止点击
			if current_is_in_action then
				return
			end
			_frm:show(0)
			_Code_UpdateTacticsSkill()
			_Code_DoCallBack()
			_Code_ClearFunc()
			hGlobal.event:event("LocalEvent_RefreshCurGameScore")
			
			--释放png, plist的纹理缓存（这里不清理也可以）
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
		_nCurrent_unit_id = 0			--当前战车id
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

	--更新UI
	_Code_UpdateUI = function()
		local curScore = LuaGetPlayerScore() --当前积分
		local talentPointNum = LuaGetHeroMapTalentPoint()
		_childUI["lab_score"]:setText(curScore)
		_childUI["lab_point"]:setText(talentPointNum)
		_childUI["lab_point2"]:setText(hVar.tab_string["options_left"] .. " : "..talentPointNum)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local mannumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		_childUI["lab_man"]:setText(mannumber)
	end

	--获取天赋树数据
	_Code_GetSkillTreeData = function()
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		for i = 1,#talent_tree do
			local ttree = talent_tree[i] or {}
			local tacticId = ttree.tacticId or 0 --战术技能id
			local tabT = hVar.tab_tactics[tacticId] or {}
			local lv = LuaGetHeroMapTalentSkillLv(i)
			_tSkillTreeData[i] = {
				model = tabT.icon,
				attrPointMaxLv = ttree.attrPointMaxLv,
				attrPointUpgrade = ttree.attrPointUpgrade,
				attrPointRestore = ttree.attrPointRestore,
				--当前等级跟着随机地图走
				--attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id,i),
				attrPointLv = lv,
				tacticId = tacticId,
			}
			if lv > 0 then 
				_tempSkillUpList[tacticId] = {lv,i,lv}
			end
		end
	end

	--创建天赋树
	_Code_CreateSkillTree = function()
		local nodeXY = {hVar.SCREEN.w/2 + _nRightAreaOffX,-hVar.SCREEN.h/2 + _nRightAreaOffY}
		--战车天赋节点
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
			--技能背景图
			nodeChildUI["skillbg"..i] = hUI.image:new({
				parent = nodeParent,
				model = "misc/skillup/skillbg.png",
				x = v[1],
				y = v[2],
			})
			nodeChildUI["skillbg"..i].handle._n:setRotation(v[3])
			nodeChildUI["skillbg"..i].handle._n:setScale(scale)

			--技能按钮
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

	--更新天赋状态
	_Code_UpdateSkillState = function(nCurrentSkillIdx)
		if type(_tSkillTreeData) == "table" and type(_tSkillTreeData[nCurrentSkillIdx]) == "table" then
			local tSkillData = _tSkillTreeData[nCurrentSkillIdx]
			local attrPointLv = tSkillData.attrPointLv		--当前等级
			local attrPointMaxLv = tSkillData.attrPointMaxLv	--最高等级
			local attrPointUpgrade = tSkillData.attrPointUpgrade	--升级所需
			local nShowNumByOne = 1/attrPointMaxLv*6		--1级需要显示的数量
			local nShowNum = attrPointLv/attrPointMaxLv*6		--需要显示的数量
			local nShowActionNum = nShowNum				--需要闪烁的数量
			if attrPointLv == 0 then
				_childUI["button"..nCurrentSkillIdx].handle.s:setColor(ccc3(128,128,128))
			else
				_childUI["button"..nCurrentSkillIdx].handle.s:setColor(ccc3(255,255,255))
			end
			if attrPointLv < attrPointMaxLv then
				local requireAttrPoint = attrPointUpgrade.requireAttrPoint or 0
				local requireScore = attrPointUpgrade.requireScore or 0
				local curScore = LuaGetPlayerScore() --当前积分
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
						local act1 = CCFadeIn:create(0.8) --淡入
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
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
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

	--函数：创建大菠萝技能升级tip面板
	OnCreateSkillUpTip = function(skillIdx)
		--先清除上一次的技能说明面板
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
		
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroMapTalentPoint() --单位总天赋点数
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --战术技能id

		if tacticId ~= 3003 and _nIsGuide == 1 then
			return
		end
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
		local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
		--local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
		local attrPointLv = LuaGetHeroMapTalentSkillLv(skillIdx)
		local requireAttrPoint = 0 --升级需要的技能点数
		local requireScore = 0 --升级需要的积分
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --当前积分
		local oWorld = hGlobal.WORLD.LastWorldMap
		local requireMan = 3	--升级需要的工程师
		local curManNumber = 0
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end

		if (talentPointNum < requireAttrPoint and _bShowPoint == false) then
			return
		end

		--创建技能说明面板
		hGlobal.UI.GameCoinTipFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 1,
			--dragable = 2,
			dragable = 2, --点击后消失
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		local _SkillParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _SkillChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2

		--关闭按钮区域
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
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--删除本界面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
				
				hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
				
				--播放音效，关闭技能升级界面
				--hApi.PlaySound("common_close_popup_window")
				hApi.PlaySound("Button2")
			end,
		})
		_SkillChildUI["closebtn"].handle.s:setOpacity(88)
		_SkillChildUI["closebtn"].handle.s:setColor(ccc3(0, 0, 0))
		
		--创建技能tip图片背景
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
				--print("技能tip图片背景")
			end,
		})

		local nShowY = _offY + 110
		if (attrPointLv >= attrPointMaxLv) then
			nShowY = _offY + 5
		end
		--技能背景图
		_SkillChildUI["skillbg"] = hUI.image:new({
			parent = _SkillParent,
			model = "misc/skillup/skillbg.png",
			x = _offX - 65,
			y = nShowY,
			scale = 0.9,
		})
		_SkillChildUI["skillbg"].handle._n:setRotation(60)

		local nShowNumByOne = 1/attrPointMaxLv*6		--1级需要显示的数量
		local nShowNum = attrPointLv/attrPointMaxLv*6		--需要显示的数量
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
					local act1 = CCFadeIn:create(0.8) --淡入
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
		
		--创建技能tip-技能图标
		--print(hVar.tab_skill[skillId].icon)
		_SkillChildUI["SkillIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = tabT.icon,
			x = _offX - 65,
			y = nShowY,
			scale = 0.9,
		})
		
		--创建技能tip-技能介绍
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
		if (attrPointLv <= 0) then --还未获得技能
			_SkillChildUI["SkillIntro"].handle.s:setColor(ccc3(166, 166, 166))
		end
		
		--技能等级未满，才能升级
		if (attrPointLv < attrPointMaxLv) then
			--分割线1
			_SkillChildUI["SkillSeparateLine1"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/line.png",
				x = _offX + 100,
				y = _offY + 40,
				w = 436,
				h = 8,
			})
			
			--分割线2
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
					--天赋点底纹
					_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 90,
						h = 40,
					})
					
					--天赋点图标
					_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 15,
						y = _offY - 11,
						w = 40,
						h = 50,
					})
					
					--需要的天赋点数
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
					--如果当前天赋点不足，文字红色
					if (talentPointNum < requireAttrPoint) then
						_SkillChildUI["SkillAttrPointValue"].handle.s:setColor(ccc3(255, 0, 0))
					end
				elseif tlist[i] == "score" then
					--积分底纹
					_SkillChildUI["SkillScoreBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 120,
						h = 40,
					})
					
					--积分图标
					_SkillChildUI["SkillScoreIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/mu_coin.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 35,
						y = _offY - 11,
						w = 42,
						h = 42,
					})
					
					--需要的积分值
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
					--如果当前积分不足，文字红色
					if (curScore < requireScore) then
						_SkillChildUI["SkillScoreValue"].handle.s:setColor(ccc3(255, 0, 0))
					end
				elseif tlist[i] == "man" then
					--天赋点底纹
					_SkillChildUI["SkillManBG"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/skillup/skillpoint_bg.png",
						x = _offX + 100 - width*(i - (shownum+1)/2),
						y = _offY - 11,
						w = 90,
						h = 40,
					})
					
					--天赋点图标
					_SkillChildUI["SkillManIcon"] = hUI.image:new({
						parent = _SkillParent,
						model = "misc/gameover/icon_man.png",
						x = _offX + 100 - width*(i - (shownum+1)/2) - 15,
						y = _offY - 11,
						scale = 0.7,
					})
					
					--需要的天赋点数
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
			
			--绘制需要的技能点数和积分
			--if (requireScore <= 0) then --不需要积分
				
			--else --需要积分
				----天赋点底纹
				--_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
					--parent = _SkillParent,
					--model = "misc/skillup/skillpoint_bg.png",
					--x = _offX + 5,
					--y = _offY - 11,
					--w = 90,
					--h = 40,
				--})
				
				----天赋点图标
				--_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
					--parent = _SkillParent,
					--model = "misc/skillup/skillpoint.png",
					--x = _offX + 5 - 25,
					--y = _offY - 11,
					--w = 40,
					--h = 50,
				--})
				
				----需要的天赋点数
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
			
			--确定按钮
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
					--在动画中禁止点击
					if current_is_in_action then
						return
					end
					
					--升级技能等级逻辑
					OnClickUpgrateSkillBtn(skillIdx)
				end,
			})
			--如果当前天赋点不足，确定按钮灰掉
			if (talentPointNum < requireAttrPoint) then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end
			--如果当前积分不足，确定按钮灰掉
			if (curScore < requireScore) then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end

			--如果当前积分不足，确定按钮灰掉
			if curManNumber < requireMan then
				hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
			end
			
			--取消按钮
			_SkillChildUI["SkillNoBtn"] = hUI.button:new({
				parent = _SkillParent,
				model = "misc/skillup/btn_close.png",
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				--scaleT = 0.95,
				x = _offX + 636/2 + 62,
				y = _offY + 416/2 - 38,
				code = function()
					--在动画中禁止点击
					if current_is_in_action then
						return
					end
					
					--清除本面板
					if hGlobal.UI.GameCoinTipFrame then
						hGlobal.UI.GameCoinTipFrame:del()
						hGlobal.UI.GameCoinTipFrame = nil
					end
					
					hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
					
					--播放音效，关闭技能升级界面
					--hApi.PlaySound("common_close_popup_window")
					hApi.PlaySound("Button2")
				end,
			})
		end
		
		--技能等级已满，只显示关闭按钮
		if (attrPointLv >= attrPointMaxLv) then
			--居中对齐
			_SkillChildUI["SkillIntro"]:setXY(_offX + 190, _offY + 5)
			_SkillChildUI["SkillIcon"]:setXY(_offX - 65, _offY + 5)
		end
	end

	--函数：升级技能等级逻辑
	OnClickUpgrateSkillBtn = function(skillIdx)
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroMapTalentPoint() --单位总天赋点数
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --战术技能id
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
		local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
		--local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
		local attrPointLv = LuaGetHeroMapTalentSkillLv(skillIdx)
		local requireAttrPoint = 0 --升级需要的技能点数
		local requireScore = 0 --升级需要的积分
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --当前积分
		local requireMan = 3	--升级需要的工程师
		local curManNumber = 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end

		--技能已到顶级
		if (attrPointLv >= attrPointMaxLv) then
			local strText = "已升到最大等级！"
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
		
		--天赋点数不足
		if (talentPointNum < requireAttrPoint) then
			hApi.NotEnoughResource("skillpoint")
			
			return
		end
		
		--积分不足
		if (curScore < requireScore) then
			hApi.NotEnoughResource("coin")
			
			return
		end

		if curManNumber < requireMan then
			hApi.NotEnoughResource("man")
			return
		end
		
		--可以升级
		--标记在动画中，禁止操作
		current_is_in_action = true
		
		--扣除技能点和积分，升级技能等级
		local newTalentPointNum = talentPointNum - requireAttrPoint
		local newScore = curScore - requireScore
		local newAttrPointLv = attrPointLv + 1
		--LuaSetHeroTalentPoint(_nCurrent_unit_id, newTalentPointNum)
		LuaSetHeroMapTalentPoint(newTalentPointNum)
		--修改添加积分的同时加上来源以便统计
		LuaAddPlayerScoreByWay(-requireScore,hVar.GET_SCORE_WAY.UPGRADETACTICS)
		--LuaAddPlayerScore(-requireScore)
		--LuaSetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx, newAttrPointLv)
		LuaSetHeroMapTalentSkillLv(skillIdx, newAttrPointLv)
		_tSkillTreeData[skillIdx]["attrPointLv"] = newAttrPointLv
		
		--动画表现1
		local ACTTIME = 0.3
		local _frm2 = hGlobal.UI.GameCoinTipFrame
		if (requireAttrPoint > 0 and _bShowPoint == true) then --需要积分
			local fromX = _frm.data.x + _childUI["img_point"].data.x
			local fromY = _frm.data.y + _childUI["img_point"].data.y
			local toX = _frm2.data.x + _frm2.childUI["SkillIcon"].data.x
			local toY = _frm2.data.y + _frm2.childUI["SkillIcon"].data.y

			print(fromX, fromY, toX, toY)

			local angle1 = GetLineAngle(fromX, fromY, toX, toY) --角度制
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
		
		--动画表现2
		if (requireScore > 0) then --需要积分
			local fromX = _frm.data.x + _childUI["img_score"].data.x
			local fromY = _frm.data.y + _childUI["img_score"].data.y
			local toX = _frm2.data.x + _frm2.childUI["SkillIcon"].data.x
			local toY = _frm2.data.y + _frm2.childUI["SkillIcon"].data.y
			local angle2 = GetLineAngle(fromX, fromY, toX, toY) --角度制
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
		
		--积分做动画
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
		
		--天赋点做动画
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
			--标记不在动画中，可以操作
			current_is_in_action = false

			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			--oWorld:settactics(oPlayerMe,{{tacticId,newAttrPointLv,0}})
			----战术技能卡对地图已有角色生效
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
			
			--刷新技能面板
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
		
		--播放音效，升级技能
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

	--监听打开大菠萝技能升级界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm_inMap", "__ShowDLCMapFrm", function(unitId,tCallback)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and oWorld.data.map == hVar.GuideMap then
			_nIsGuide = 1
		else
			_nIsGuide = 0
		end
		--显示大菠萝技能升级界面
		_frm:show(1)
		_frm:active()
		
		--存储单位id
		_nCurrent_unit_id = unitId
		_tCallback = tCallback
		_Code_UpdateUI()
		_Code_GetSkillTreeData()
		_Code_CreateSkillTree()

		if hApi.IsReviewMode() then
			--审核模式全不显示
			_childUI["buycoin"]:setstate(-1)
		else
			local iChannelId = xlGetChannelId()
			if iChannelId >= 100 and _childUI["buycoin"] then
				_childUI["buycoin"]:setstate(-1)
			end
		end
	end)
end

--获取英雄随机地图天赋技能等级
--function LuaGetHeroMapTalentSkillLv(skillIdx)
	--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	----local nHeroId = tInfo.tankid or hVar.MY_TANK_ID
	--local tTalentSkill = tInfo.talentskill or {}
	--return tTalentSkill[skillIdx] or 0
--end

--设置英雄随机地图天赋技能等级
--function LuaSetHeroMapTalentSkillLv(skillIdx,lv)
	--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	--if tInfo.talentskill == nil then
		--tInfo.talentskill = {}
	--end
	--tInfo.talentskill[skillIdx] = lv
	--LuaSavePlayerList()
--end

--获取英雄随机地图中的天赋点
function LuaGetHeroMapTalentPoint()
	local talentPoint = 0
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		talentPoint = diablodata.randMap.talentpoint or talentPoint
	end
	return talentPoint
end

--设置英雄随机地图中的天赋点
function LuaSetHeroMapTalentPoint(talentPoint)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		diablodata.randMap.talentpoint = talentPoint
	end
end

--设置英雄随机地图中的天赋技能
function LuaSetHeroMapTalentSkillLv(nSkillIdx, nLv)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		if diablodata.randMap.talentskill then
			diablodata.randMap.talentskill[nSkillIdx] = nLv
		end
	end
end

--获取英雄随机地图中的天赋等级
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