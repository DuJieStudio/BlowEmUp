--大菠萝技能升级面板
hGlobal.UI.InitDiabloSkillUpInfoFrm = function(mode)
	--界面参数
	--local _tSkillTreeWH = {920,560}			--战车天赋所占区域大小
	local iPhoneX_WIDTH = 0
	local _nSkillTreeScale = 1			--战车天赋缩放比列
	local _nRightAreaOffX = 110			--右边区域X偏移(战车天赋树)
	local _nRightAreaOffY = -30			--右边区域Y偏移(战车天赋树)
	local _nLeftAreaOffX = 150			--左边区域X偏移(战车模型)
	local _nLeftAreaOffY = 48			--左边区域Y偏移(战车模型)
	local _nSourceStartX = 326			--资源X坐标起始位置
	local _nSourceStartY = -60			--资源Y坐标起始位置
	local _nCloseBtnX = 110				--关闭按钮X坐标
	local _tRemoveUIList = {}			--需要清理的UI列表
	local _tSkillTreeUIData = {			--战车天赋数据
		--[6000] = {
			--["skillUI"] = {
				--{-388,-18,60},
				--{-177,182,300},
				----{124,210,240},
				--{392,62,300},
				--{-321,-184,60},
				----{131,-201,60},
				--{365,-173,0},
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

	--数据参数
	local _nCurrent_unit_id = 0			--当前战车id
	local _tSkillTreeData = {}			--天赋树数据
	local current_is_in_action = false		--动画进行标志

	local _Code_ClearFunc = hApi.DoNothing		--清理函数
	local _Code_CreateModel = hApi.DoNothing	--创建载具
	local _Code_CreateSkillTree = hApi.DoNothing	--创建天赋树
	local _Code_GetSkillTreeData = hApi.DoNothing	--获取天赋树数据
	local _Code_UpdateSkillState = hApi.DoNothing	--更新天赋状态
	local _Code_UpdateUI = hApi.DoNothing		--更新UI

	local OnCreateSkillUpTip = hApi.DoNothing	--创建技能升级
	local OnCreateWeaponUnlockTipNew = hApi.DoNothing
	local OnCreateSkillRestoreTip = hApi.DoNothing
	local OnClickRestoreSkillBtn = hApi.DoNothing
	local OnClickUpgrateSkillBtn = hApi.DoNothing

	if (g_phone_mode == 4) then
		iPhoneX_WIDTH = hVar.SCREEN.offx
		_nRightAreaOffX = 130
		_nLeftAreaOffX = iPhoneX_WIDTH + 160
		_nSourceStartX = 376 + iPhoneX_WIDTH
		_nCloseBtnX = 120 + iPhoneX_WIDTH
	elseif (g_phone_mode == 0) then
		_nLeftAreaOffX = 120
		_nSkillTreeScale = 0.86
		_nRightAreaOffX = 100
		_nSourceStartX = 256
		_nSourceStartY = - 80
		_nCloseBtnX = 80
	elseif (g_phone_mode == 2) then
		_nLeftAreaOffX = 140
		_nSkillTreeScale = 0.9
		_nSourceStartX = 300
		_nCloseBtnX = 100
	end

	--创建大菠萝技能升级面板
	hGlobal.UI.PhoneDiabloSkillUpInfoFrm = hUI.frame:new({
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

	local _frm = hGlobal.UI.PhoneDiabloSkillUpInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	if (g_phone_mode == 4) then --iPhoneX
		--iPhoneX黑边-左
		_frm.childUI["iPhoneX_Black_Left"] = hUI.image:new({
			parent = _parent,
			model = "UI:BLACK_BORDER",
			x = 60,
			y = -hVar.SCREEN.h / 2,
			z = 1,
			--w = 240,
			h = 720,
			align = "MC"
		})
		_frm.childUI["iPhoneX_Black_Left"].handle.s:setRotation(180)
		
		--iPhoneX黑边-右
		_frm.childUI["iPhoneX_Black_Right"] = hUI.image:new({
			parent = _parent,
			model = "UI:BLACK_BORDER",
			x = hVar.SCREEN.w - 60,
			y = -hVar.SCREEN.h / 2,
			z = 1,
			--w = 240,
			h = 720,
			align = "MC"
		})
		--_frm.childUI["iPhoneX_Black_Right"].handle.s:setRotation(180)
	end

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

	_childUI["img_point"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/skillpoint.png",
		x = _nSourceStartX + 220,
		y = _nSourceStartY,
		scale = 1.0,
	})

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
			_Code_ClearFunc()
			--主基地事件回调
			hGlobal.event:event("LocalEvent_MainBaseEventCB")
		end,
	})

	--重置按钮
	_childUI["DLCMapResetBtn"] = hUI.button:new({
		parent = _parent,
		x = _nLeftAreaOffX,
		y = -hVar.SCREEN.h + 130,
		model = "misc/addition/cg.png",
		label = {text = "reset",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
		dragbox = _frm.childUI["dragBox"],
		align = "MC",
		scaleT = 0.95,
		scale = 0.74,
		code = function()
			--在动画中禁止点击
			if current_is_in_action then
				return
			end
			OnCreateSkillRestoreTip(pageIdx)
			
			--播放音效，打开技能重置界面
			--hApi.PlaySound("common_popup_small")
			hApi.PlaySound("Button2")
		end,
	})

	_Code_ClearFunc = function()
		for i = 1,#_tRemoveUIList do
			hApi.safeRemoveT(_childUI,_tRemoveUIList[i])
		end
		_tRemoveUIList = {}
		_nCurrent_unit_id = 0			--当前战车id
		_tSkillTreeData = {}
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
	end
	
	--更新UI
	_Code_UpdateUI = function()
		local curScore = LuaGetPlayerScore() --当前积分
		local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id)
		_childUI["lab_score"]:setText(curScore)
		_childUI["lab_point"]:setText(talentPointNum)
	end

	_Code_CreateModel = function()
		local scaleTank = 1
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		_childUI["btn_TankModel"] = hUI.button:new({
			parent = _parent,
			model = tabU.model,
			x = _nLeftAreaOffX,
			y = -hVar.SCREEN.h/2 + _nLeftAreaOffY,
			scale = 1.0 * scaleTank,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				OnCreateWeaponUnlockTipNew()
				
				--播放音效，打开武器解锁界面
				hApi.PlaySound("Button2")
			end,
		})
		_tRemoveUIList[#_tRemoveUIList + 1] = "btn_TankModel"
		
		--坦克的轮子
		local bind_wheel = tabU.bind_wheel or 0
		if (bind_wheel > 0) then
			_childUI["btn_TankModel"].childUI["wheel"] = hUI.image:new({
				parent = _childUI["btn_TankModel"].handle._n,
				model = hVar.tab_unit[bind_wheel].model,
				x = 0,
				y = 0,
				scale = 1.0 * scaleTank,
			})
		end
		
		--坦克的武器
		local weaponIdx = LuaGetHeroWeaponIdx(_nCurrent_unit_id) --当前选中的武器索引值
		if (weaponIdx > 0) then
			local weapon_unit = tabU.weapon_unit or {} --单位武器列表
			local tWeapon = weapon_unit[weaponIdx] or {}
			local weaponUnitId = tWeapon.unitId or 0
			local tabU = hVar.tab_unit[weaponUnitId] or {}
			--print("weaponUnitId=", weaponUnitId)
			if tabU then
				if tabU.model then
					_childUI["btn_TankModel"].childUI["weapon"] = hUI.image:new({
						parent = _childUI["btn_TankModel"].handle._n,
						model = tabU.model,
						x = 0,
						y = 0,
						scale = 1.0 * scaleTank,
					})
				end
				if tabU.effect then
					for i = 1,#tabU.effect do
						local effect = tabU.effect[i]
						local effectId = effect[1]
						local effX = effect[2] or 0
						local effY = effect[3] or 0
						local effScale = effect[4] or 1.0
						--print(effectId, cardId)
						local effModel = effectId
						if (type(effectId) == "number") then
							effModel = hVar.tab_effect[effectId].model
						end
						if effModel then
							_childUI["btn_TankModel"].childUI["UnitEffModel" .. i] = hUI.image:new({
								parent = _childUI["btn_TankModel"].handle._n,
								model = effModel,
								align = "MC",
								x = effX,
								y = effY,
								z = effect[4] or -1,
								scale = 1.2 * effScale,
							})
							
							local tabM = hApi.GetModelByName(effModel)
							if tabM then
								local tRelease = {}
								local path = tabM.image
								tRelease[path] = 1
								hResource.model:releasePlist(tRelease)
								
								--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
								--[[
								local pngPath = "data/image/"..(tabM.image)
								local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
								--print("释放特效")
								--print("pngPath=", pngPath)
								--print("texture = ", texture)
								
								if texture then
									CCTextureCache:sharedTextureCache():removeTexture(texture)
								end
								]]
							end
						end
					end
				end
			end
		end

		--更新英雄经验进度条和等级
		local heroLv = 0 --英雄等级
		local heroExp = 0 --英雄该等级的经验值
		local heroExpMax = 1 --英雄该等级的总经验值
		local tHeroCard = hApi.GetHeroCardById(_nCurrent_unit_id)
		if tHeroCard then
			heroLv = tHeroCard.attr.level
			heroExp = tHeroCard.attr.exp - hVar.HERO_EXP[heroLv].minExp
			heroExpMax = hVar.HERO_EXP[heroLv].nextExp or 0
		end

		if heroLv >= 10 then
			_childUI["DLCMapResetBtn"]:setstate(1)
		else
			_childUI["DLCMapResetBtn"]:setstate(-1)
		end
		
		--坦克经验进度条
		_childUI["lab_TankExp"] = hUI.valbar:new({
			parent = _parent,
			x = _nLeftAreaOffX - 66,
			y = -hVar.SCREEN.h/2 + _nLeftAreaOffY - 120,
			w = 120,
			h = 5,
			align = "LC",
			back = {model = "misc/skillup/expbar_bg.png", x = 0, y = 0, w = 120, h = 5},
			model = "misc/skillup/expbar.png",
			--model = "misc/progress.png",
			v = 0,
			max = 100,
		})
		_childUI["lab_TankExp"]:setV(heroExp, heroExpMax)
		_tRemoveUIList[#_tRemoveUIList + 1] = "lab_TankExp"
		
		--坦克等级
		_childUI["lab_TankLevel"] = hUI.label:new({
			parent = _parent,
			x = _nLeftAreaOffX - 6,
			y = -hVar.SCREEN.h/2 + _nLeftAreaOffY - 90,
			width = 500,
			align = "MC",
			font = "numWhite",
			border = 0,
			size = 20,
			text = "lv " .. heroLv,
		})
		_tRemoveUIList[#_tRemoveUIList + 1] = "lab_TankLevel"
	end

	--获取天赋树数据
	_Code_GetSkillTreeData = function()
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		for i = 1,#talent_tree do
			local ttree = talent_tree[i] or {}
			local tacticId = ttree.tacticId or 0 --战术技能id
			local tabT = hVar.tab_tactics[tacticId] or {}
			_tSkillTreeData[i] = {
				model = tabT.icon,
				attrPointMaxLv = ttree.attrPointMaxLv,
				attrPointUpgrade = ttree.attrPointUpgrade,
				attrPointRestore = ttree.attrPointRestore,
				attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id,i),
			}
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
			--技能背景图
			local scale = 0.8
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
				local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id)
				if curScore >= requireScore and talentPointNum >= requireAttrPoint then
					nShowActionNum = nShowNum + nShowNumByOne
				end
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

	--函数：创建大菠萝技能升级tip面板
	OnCreateSkillUpTip = function(skillIdx)
		--先清除上一次的技能说明面板
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
		
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
		
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id) --单位总天赋点数
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --战术技能id
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
		local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
		local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
		local requireAttrPoint = 0 --升级需要的技能点数
		local requireScore = 0 --升级需要的积分
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --当前积分
		
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
			x = _offX - 5,
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
					x = _offX - 5 + data[1],
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
			x = _offX - 5,
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
			x = _offX + 190,
			y = nShowY,
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showAttrPointLv + 1] or ("unknown" .. tacticId),
			border = 1,
		})
		if (attrPointLv <= 0) then --还未获得技能
			_SkillChildUI["SkillIntro"].handle.s:setColor(ccc3(144, 144, 144))
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
			
			--绘制需要的技能点数和积分
			if (requireScore <= 0) then --不需要积分
				--天赋点底纹
				_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint_bg.png",
					x = _offX + 100,
					y = _offY - 11,
					w = 90,
					h = 40,
				})
				
				--天赋点图标
				_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint.png",
					x = _offX + 100 - 25,
					y = _offY - 11,
					w = 40,
					h = 50,
				})
				
				--需要的天赋点数
				_SkillChildUI["SkillAttrPointValue"] = hUI.label:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint.png",
					x = _offX + 100 + 35,
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
			else --需要积分
				--天赋点底纹
				_SkillChildUI["SkillAttrPointBG"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint_bg.png",
					x = _offX + 5,
					y = _offY - 11,
					w = 90,
					h = 40,
				})
				
				--天赋点图标
				_SkillChildUI["SkillAttrPointIcon"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint.png",
					x = _offX + 5 - 25,
					y = _offY - 11,
					w = 40,
					h = 50,
				})
				
				--需要的天赋点数
				_SkillChildUI["SkillAttrPointValue"] = hUI.label:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint.png",
					x = _offX + 5 + 35,
					y = _offY - 11 - 1,
					width = 300,
					align = "RC",
					size = 28,
					font = "numWhite",
					border = 0,
					text = requireAttrPoint,
				})
				
				--积分底纹
				_SkillChildUI["SkillScoreBG"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint_bg.png",
					x = _offX + 195 + 10,
					y = _offY - 11,
					w = 120,
					h = 40,
				})
				
				--积分图标
				_SkillChildUI["SkillScoreIcon"] = hUI.image:new({
					parent = _SkillParent,
					model = "misc/skillup/mu_coin.png",
					x = _offX + 195 - 40,
					y = _offY - 11,
					w = 42,
					h = 42,
				})
				
				--需要的积分值
				_SkillChildUI["SkillScoreValue"] = hUI.label:new({
					parent = _SkillParent,
					model = "misc/skillup/skillpoint.png",
					x = _offX + 195 + 60,
					y = _offY - 11 - 1,
					width = 300,
					align = "RC",
					size = 22,
					font = "num",
					border = 0,
					text = requireScore,
				})
				--如果当前积分不足，文字红色
				if (curScore < requireScore) then
					_SkillChildUI["SkillScoreValue"].handle.s:setColor(ccc3(255, 0, 0))
				end
			end
			
			--确定按钮
			_SkillChildUI["SkillYesBtn"] = hUI.button:new({
				parent = _SkillParent,
				model = "misc/skillup/btn_upgrade.png",
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				scaleT = 0.95,
				x = _offX + 100,
				y = _offY - 128,
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
			_SkillChildUI["SkillIcon"]:setXY(_offX - 5, _offY + 5)
		end
	end

	--函数：创建大菠萝技能重置tip面板
	OnCreateSkillRestoreTip = function()
		--先清除上一次的技能说明面板
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
		
		
		--创建技能说明面板
		hGlobal.UI.GameCoinTipFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 1,
			--dragable = 2,
			dragable = 4, --点击后消失
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.GameCoinTipFrame:del()
					--hGlobal.UI.GameCoinTipFrame = nil
					--print("点击事件（有可能在控件外部点击）")
					--隐藏技能选中框
					--_frmNode.childUI["EnemySkill" .. skillIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id) --单位总天赋点数
		local talentSkillCount = 0 --已学会的技能等级和
		local talentSkillPointCount = 0 --已学会的技能等级点和
		local requireScore = 0 --重置需要的积分
		for skillIdx = 1, #talent_tree, 1 do
			local ttree = talent_tree[skillIdx] or {}
			local tacticId = ttree.tacticId or 0 --战术技能id
			local tabT = hVar.tab_tactics[tacticId] or {}
			local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
			local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
			local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
			local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
			--print(attrPointLv)
			
			--统计技能等级和
			talentSkillCount = talentSkillCount + attrPointLv
			
			--统计重置技能需要的积分
			for i = 1, attrPointLv, 1 do
				--local attrPointUpgradeT = attrPointUpgrade[i] or {}
				local attrPointUpgradeT = attrPointUpgrade
				--local attrPointRestoreT = attrPointRestore[i] or {}
				local attrPointRestoreT = attrPointRestore
				local attrpoint = attrPointUpgradeT.requireAttrPoint or 0
				local score = attrPointRestoreT.requireScore or 0
				talentSkillPointCount = talentSkillPointCount + attrpoint
				requireScore = requireScore + score
			end
		end
		local curScore = LuaGetPlayerScore() --当前积分
		
		local _SkillParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _SkillChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2
		
		--关闭按钮区域
		_SkillChildUI["closebtn"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/mask.png", --"UI:playerBagD"
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
				
				--播放音效，关闭技能重置界面
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
			w = 512,
			h = 416,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--创建技能tip-技能介绍
		_SkillChildUI["SkillIntro"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX + 100,
			y = _offY + 90,
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			text = "RESET ?",
			border = 1,
		})
		--_SkillChildUI["SkillIntro"].handle.s:setColor(ccc3(255, 255, 0))
		
		--分割线2
		_SkillChildUI["SkillSeparateLine2"] = hUI.image:new({
			parent = _SkillParent,
			model = "misc/skillup/line.png",
			x = _offX + 100,
			y = _offY - 70,
			w = 436,
			h = 8,
		})
		
		if requireScore > 0 then
			--积分底纹
			_SkillChildUI["SkillScoreBG"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/skillpoint_bg.png",
				x = _offX + 100 + 10,
				y = _offY - 0,
				w = 120,
				h = 40,
			})
			
			--积分图标
			_SkillChildUI["SkillScoreIcon"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/mu_coin.png",
				x = _offX + 100 - 40,
				y = _offY - 0,
				w = 42,
				h = 42,
			})
			
			--重置需要的积分值
			_SkillChildUI["SkillScoreValue"] = hUI.label:new({
				parent = _SkillParent,
				model = "misc/skillup/skillpoint.png",
				x = _offX + 100 + 60,
				y = _offY - 0 - 1,
				width = 300,
				align = "RC",
				size = 22,
				font = "num",
				border = 0,
				text = requireScore,
			})
			--如果当前积分不足，文字红色
			if (curScore < requireScore) then
				_SkillChildUI["SkillScoreValue"].handle.s:setColor(ccc3(255, 0, 0))
			end
		else
			_SkillChildUI["SkillIntro"]:setXY(_offX + 100,_offY + 45)
		end
		
		--确定按钮
		_SkillChildUI["SkillYesBtn"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/addition/cg.png",
			label = {text = "ok",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			scaleT = 0.95,
			x = _offX + 100 - 80,
			y = _offY - 128,
			w = 124,
			h = 52,
			scale = 0.74,
			code = function()
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--重置技能逻辑
				OnClickRestoreSkillBtn()
			end,
		})
		--如果当前积分不足，确定按钮灰掉
		if (curScore < requireScore) then
			hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
		end
		--如果当前未使用天赋点，确定按钮灰掉
		if (talentSkillPointCount <= 0) then
			hApi.AddShader(_SkillChildUI["SkillYesBtn"].handle.s, "gray")
		end
			
		--取消按钮
		_SkillChildUI["SkillNoBtn"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/addition/cg.png",
			label = {text = "no",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			scaleT = 0.95,
			x = _offX + 100 + 80,
			y = _offY - 128,
			scale = 0.74,
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
				
				--播放音效，关闭技能重置界面
				--hApi.PlaySound("common_close_popup_window")
				hApi.PlaySound("Button2")
			end,
		})
	end
	--函数：创建大菠萝武器解锁新tip
	OnCreateWeaponUnlockTipNew = function()	
		--先清除上一次的技能说明面板
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		hApi.clearTimer("__DLC_WEAPON_LIST_UPDATE__")
		
		--_frmNode.childUI["EnemySkill" .. skillIdx].childUI["selectbox"].handle.s:setVisible(true) --显示
		
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
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.GameCoinTipFrame:del()
					--hGlobal.UI.GameCoinTipFrame = nil
					--print("点击事件（有可能在控件外部点击）")
					--隐藏技能选中框
					--_frmNode.childUI["EnemySkill" .. skillIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local weaponIdx = LuaGetHeroWeaponIdx(_nCurrent_unit_id) --当前选中的武器索引值
		local skillItemlId = tabU.skillItemlId or 0 --道具技能的道具id
		local weapon_unit = tabU.weapon_unit or {} --单位武器列表
		local curScore = LuaGetPlayerScore() --当前积分
		
		local heroLv = 0 --英雄等级
		local heroExp = 0 --英雄该等级的经验值
		local heroExpMax = 1 --英雄该等级的总经验值
		local tHeroCard = hApi.GetHeroCardById(_nCurrent_unit_id)
		local currentStar = 0
		local heroMaxLv = 0
		if tHeroCard then
			heroLv = tHeroCard.attr.level
			heroExp = tHeroCard.attr.exp - hVar.HERO_EXP[heroLv].minExp
			heroExpMax = hVar.HERO_EXP[heroLv].nextExp or 0
			currentStar = tHeroCard and tHeroCard.attr.star or 1
			heroMaxLv = hVar.HERO_STAR_INFO[_nCurrent_unit_id][currentStar]["maxLv"]
		end
		
		print(tHeroCard.attr.exp,hVar.HERO_EXP[heroLv].minExp)
		
		local _SkillParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _SkillChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2
		
		--关闭按钮区域
		_SkillChildUI["closebtn"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/mask.png", --"UI:playerBagD"
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
				
				--播放音效，关闭武器解锁界面
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
			w = 512,
			h = 416,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--坦克模型
		local LEFT_Y = 260
		local scaleTank = 1.0
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		_SkillChildUI["DLCMapTankName"] = hUI.button:new({
			parent = _SkillParent,
			model = tabU.model,
			x = _offX + 100,
			y = _offY + LEFT_Y - 195,
			scale = 1.0 * scaleTank,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--创建武器解锁tip
				--OnCreateWeaponUnlockTip(pageIdx)
				OnCreateWeaponUnlockTipNew()
				
				--播放音效，打开武器解锁界面
				--hApi.PlaySound("common_popup_window")
				hApi.PlaySound("Button2")
			end,
		})
		
		--坦克的轮子
		local bind_wheel = tabU.bind_wheel or 0
		if (bind_wheel > 0) then
			_SkillChildUI["DLCMapTankName"].childUI["wheel"] = hUI.image:new({
				parent = _SkillChildUI["DLCMapTankName"].handle._n,
				model = hVar.tab_unit[bind_wheel].model,
				x = 0,
				y = 0,
				scale = 1.0 * scaleTank,
			})
		end
		
		--坦克的武器
		local weaponIdx = LuaGetHeroWeaponIdx(_nCurrent_unit_id) --当前选中的武器索引值
		if (weaponIdx > 0) then
			local weapon_unit = tabU.weapon_unit or {} --单位武器列表
			local tWeapon = weapon_unit[weaponIdx] or {}
			local weaponUnitId = tWeapon.unitId or 0
			local tabU = hVar.tab_unit[weaponUnitId] or {}
			--print("weaponUnitId=", weaponUnitId)
			if tabU then
				if tabU.model then
					_SkillChildUI["DLCMapTankName"].childUI["weapon"] = hUI.image:new({
						parent = _SkillChildUI["DLCMapTankName"].handle._n,
						model = tabU.model,
						x = 0,
						y = 0,
						scale = 1.0 * scaleTank,
					})
				end
				if tabU.effect then
					for i = 1,#tabU.effect do
						local effect = tabU.effect[i]
						local effectId = effect[1]
						local effX = effect[2] or 0
						local effY = effect[3] or 0
						local effScale = effect[4] or 1.0
						--print(effectId, cardId)
						local effModel = effectId
						if (type(effectId) == "number") then
							effModel = hVar.tab_effect[effectId].model
						end
						if effModel then
							_SkillChildUI["DLCMapTankName"].childUI["UnitEffModel" .. i] = hUI.image:new({
								parent = _SkillChildUI["DLCMapTankName"].handle._n,
								model = effModel,
								align = "MC",
								x = effX,
								y = effY,
								z = effect[4] or -1,
								scale = 1.2 * effScale,
							})
							
							local tabM = hApi.GetModelByName(effModel)
							if tabM then
								local tRelease = {}
								local path = tabM.image
								tRelease[path] = 1
								hResource.model:releasePlist(tRelease)
								
								--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
								--[[
								local pngPath = "data/image/"..(tabM.image)
								local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
								--print("释放特效")
								--print("pngPath=", pngPath)
								--print("texture = ", texture)
								
								if texture then
									CCTextureCache:sharedTextureCache():removeTexture(texture)
								end
								]]
							end
						end
					end
				end
			end
		end
		
		--坦克经验进度条
		_SkillChildUI["DLCMapTankExp"] = hUI.valbar:new({
			parent = _SkillParent,
			x = _offX - 60,
			y = _offY + LEFT_Y - 380,
			w = 320,
			h = 22,
			align = "LC",
			back = {model = "misc/skillup/expbar_bg.png", x = 0, y = 0, w = 320, h = 22},
			model = "misc/skillup/expbar.png",
			--model = "misc/progress.png",
			v = heroExp,
			--v = heroExpMax, --测试 --test
			max = heroExpMax,
		})
		
		local lab_exp = heroExp .. "/" .. heroExpMax
		if heroLv >= heroMaxLv then
			lab_exp = "0/0"
		end
		--坦克经验进度文字
		_SkillChildUI["DLCMapTankExpLabel"] = hUI.label:new({
			parent = _SkillParent,
			x = _offX + 100,
			y = _offY + LEFT_Y - 380 - 1,
			width = 300,
			align = "MC",
			size = 20,
			border = 1,
			font = "numWhite",
			text = lab_exp,
		})
		
		if heroLv < heroMaxLv then
			--坦克等级
			_SkillChildUI["lab_upgrade"] = hUI.label:new({
				parent = _SkillParent,
				x = _offX + 15,
				y = _offY + LEFT_Y - 316,
				width = 500,
				align = "MC",
				font = hVar.FONTC,
				border = 0,
				size = 26,
				text = hVar.tab_string["upgrade"],
			})

			_SkillChildUI["img_arrow"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/upgrade_arrow.png",
				x = _offX + 100,
				y = _offY + LEFT_Y - 316,
				scale = 1.0,
			})

			_SkillChildUI["lab_LevelAward"] = hUI.label:new({
				parent = _SkillParent,
				x = _offX + 215 ,
				y = _offY + LEFT_Y - 316,
				width = 500,
				align = "MC",
				font = "numWhite",
				border = 0,
				size = 26,
				text = "+1",
			})

			_SkillChildUI["img_point"] = hUI.image:new({
				parent = _SkillParent,
				model = "misc/skillup/skillpoint.png",
				x = _offX + 155 ,
				y = _offY + LEFT_Y - 316,
				scale = 1.0,
			})
		else
			--坦克满级
			_SkillChildUI["lab_lvmax"] = hUI.label:new({
				parent = _SkillParent,
				x = _offX + 100,
				y = _offY + LEFT_Y - 316,
				width = 500,
				align = "MC",
				font = hVar.FONTC,
				border = 0,
				size = 26,
				text = "LvMax",
				RGB = {255,200,50},
			})
		end

		--取消按钮
		_SkillChildUI["btn_No"] = hUI.button:new({
			parent = _SkillParent,
			model = "misc/skillup/btn_close.png",
			dragbox =  hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			--scaleT = 0.95,
			x = _offX + 100 + 512/2 - 34,
			y = _offY + 416/2 - 34,
			scale = 0.9,
			--w = 40,
			--h = 32,
			code = function()
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
				
				--播放音效，关闭武器解锁界面
				--hApi.PlaySound("common_close_popup_window")
				hApi.PlaySound("Button2")
			end,
		})
		
		----坦克等级
		--_SkillChildUI["DLCMapTankLevel"] = hUI.label:new({
			--parent = _SkillParent,
			--x = _offX + 90,
			--y = _offY + LEFT_Y - 290,
			--width = 500,
			--align = "MC",
			--font = "numWhite",
			--border = 0,
			--size = 26,
			--text = "lv" .. heroLv,
		--})
	end

	--函数：升级技能等级逻辑
	OnClickUpgrateSkillBtn = function(skillIdx)
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id) --单位总天赋点数
		local ttree = talent_tree[skillIdx] or {}
		local tacticId = ttree.tacticId or 0 --战术技能id
		local tabT = hVar.tab_tactics[tacticId] or {}
		local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
		local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
		local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
		local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
		local requireAttrPoint = 0 --升级需要的技能点数
		local requireScore = 0 --升级需要的积分
		if (attrPointLv < attrPointMaxLv) then
			--local attrPointUpgradeT = attrPointUpgrade[attrPointLv + 1] or {}
			local attrPointUpgradeT = attrPointUpgrade
			requireAttrPoint = attrPointUpgradeT.requireAttrPoint or 0
			requireScore = attrPointUpgradeT.requireScore or 0
		end
		local curScore = LuaGetPlayerScore() --当前积分
		
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
		
		--可以升级
		--标记在动画中，禁止操作
		current_is_in_action = true
		
		--扣除技能点和积分，升级技能等级
		local newTalentPointNum = talentPointNum - requireAttrPoint
		local newScore = curScore - requireScore
		local newAttrPointLv = attrPointLv + 1
		LuaSetHeroTalentPoint(_nCurrent_unit_id, newTalentPointNum)
		LuaAddPlayerScore(-requireScore)
		LuaSetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx, newAttrPointLv)
		_tSkillTreeData[skillIdx]["attrPointLv"] = newAttrPointLv
		
		--动画表现1
		local ACTTIME = 0.3
		local _frm2 = hGlobal.UI.GameCoinTipFrame
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
		
		--天赋点做动画
		local delay = CCDelayTime:create(ACTTIME)
		local callback1 = CCCallFunc:create(function()
			_childUI["lab_point"]:setText(newTalentPointNum)
			for j = 1,#_tSkillTreeData do
				_Code_UpdateSkillState(j)
			end
		end)
		local scaleBig = CCScaleTo:create(0.1, 2.0)
		local scaleSmall = CCScaleTo:create(0.1, 26/26)
		local callback2 = CCCallFunc:create(function()
			--标记不在动画中，可以操作
			current_is_in_action = false
			
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

	--函数：重置技能等级逻辑
	OnClickRestoreSkillBtn = function()
		--读取单位属性
		local tabU = hVar.tab_unit[_nCurrent_unit_id] or {}
		local talent_tree = tabU.talent_tree or {} --单位天赋技能表
		local talentPointNum = LuaGetHeroTalentPoint(_nCurrent_unit_id) --单位总天赋点数
		local talentSkillCount = 0 --已学会的技能等级和
		local talentSkillPointCount = 0 --已学会的技能等级点和
		local requireScore = 0 --重置需要的积分
		for skillIdx = 1, #talent_tree, 1 do
			local ttree = talent_tree[skillIdx] or {}
			local tacticId = ttree.tacticId or 0 --战术技能id
			local tabT = hVar.tab_tactics[tacticId] or {}
			local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
			local attrPointUpgrade = ttree.attrPointUpgrade or {} --天赋升级材料表
			local attrPointRestore = ttree.attrPointRestore or {} --天赋重置材料表
			local attrPointLv = LuaGetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx) --技能当前等级
			--print(attrPointLv)
			
			--统计技能等级和
			talentSkillCount = talentSkillCount + attrPointLv
			
			--统计重置技能需要的积分
			for i = 1, attrPointLv, 1 do
				--local attrPointUpgradeT = attrPointUpgrade[i] or {}
				local attrPointUpgradeT = attrPointUpgrade
				--local attrPointRestoreT = attrPointRestore[i] or {}
				local attrPointRestoreT = attrPointRestore
				local attrpoint = attrPointUpgradeT.requireAttrPoint or 0
				local score = attrPointRestoreT.requireScore or 0
				talentSkillPointCount = talentSkillPointCount + attrpoint
				requireScore = requireScore + score
			end
		end
		local curScore = LuaGetPlayerScore() --当前积分
		
		--未使用天赋点
		if (talentSkillPointCount <= 0) then
			--local strText = "未使用天赋点！"
			--hUI.floatNumber:new({
				--x = hVar.SCREEN.w / 2,
				--y = hVar.SCREEN.h / 2,
				--align = "MC",
				--text = "",
				--lifetime = 1000,
				--fadeout = -550,
				--moveY = 32,
			--}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--积分不足
		if (curScore < requireScore) then
			hApi.NotEnoughResource("coin")
			
			return
		end
		
		
		--可以升级
		--标记在动画中，禁止操作
		current_is_in_action = true
		
		--扣除积分，重置技能等级和总技能点数
		local newTalentPointNum = talentPointNum + talentSkillPointCount
		local newScore = curScore - requireScore
		LuaSetHeroTalentPoint(_nCurrent_unit_id, newTalentPointNum)
		LuaAddPlayerScore(-requireScore)
		for skillIdx = 1, #talent_tree, 1 do
			LuaSetHeroTalentSkillLv(_nCurrent_unit_id, skillIdx, 0)
			_tSkillTreeData[skillIdx]["attrPointLv"] = 0
		end
		
		
			
		local ACTTIME = 0.3
		--if requireScore > 0 then
			----动画表现2
			--local _frm2 = hGlobal.UI.GameCoinTipFrame
			--local fromX = _frm2.data.x + _frm2.childUI["SkillScoreIcon"].data.x
			--local fromY = _frm2.data.y + _frm2.childUI["SkillScoreIcon"].data.y
			--local toX = _frm.data.x + _childUI["img_score"].data.x
			--local toY = _frm.data.y + _childUI["img_score"].data.y
			--local angle2 = GetLineAngle(fromX, fromY, toX, toY) --角度制
			--local ctrl2 = hUI.image:new({
				--parent = nil,
				--x = fromX,
				--y = fromY,
				--z = 1000,
				--model = "MODEL_EFFECT:shixue",
				--align = "MC",
				--scale = 1.0,
			--})
			--ctrl2.handle.s:setRotation(angle2)
			
			--local config = ccBezierConfig:new()
			--config.controlPoint_1 = ccp(fromX, fromY)     
			--config.controlPoint_2 = ccp(fromX + (toX - fromX) / 1.5, fromY + (fromY - toY) / 2)
			--config.endPosition = ccp(toX, toY)
			--local moveto = CCBezierTo:create(ACTTIME, config)
			----local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
			--local callback = CCCallFunc:create(function()
				--ctrl2:del()
			--end)
			--ctrl2.handle._n:runAction(CCSequence:createWithTwoActions(moveto, callback))
			
			----积分做动画
			--local delay = CCDelayTime:create(ACTTIME)
			--local callback1 = CCCallFunc:create(function()
				--_childUI["lab_score"]:setText(newScore)
			--end)
			--local scaleBig = CCScaleTo:create(0.1, 1.5)
			--local scaleSmall = CCScaleTo:create(0.1, 22/26)
			--local a = CCArray:create()
			--a:addObject(delay)
			--a:addObject(callback1)
			--a:addObject(scaleBig)
			--a:addObject(scaleSmall)
			--local sequence = CCSequence:create(a)
			--_childUI["lab_score"].handle._n:runAction(sequence)
		--end
		
		--天赋点做动画(重置)
		local delay = CCDelayTime:create(ACTTIME)
		local callback1 = CCCallFunc:create(function()
			_childUI["lab_point"]:setText(newTalentPointNum)
			for j = 1,#_tSkillTreeData do
				_Code_UpdateSkillState(j)
			end
		end)
		local scaleBig = CCScaleTo:create(0.1, 2.0)
		local scaleSmall = CCScaleTo:create(0.1, 26/26)
		local callback2 = CCCallFunc:create(function()
			--标记不在动画中，可以操作
			current_is_in_action = false
			
			--创建技能重置面板
			--OnCreateSkillRestoreTip()
			if hGlobal.UI.GameCoinTipFrame then
				hGlobal.UI.GameCoinTipFrame:del()
				hGlobal.UI.GameCoinTipFrame = nil
			end
		end)
		local a = CCArray:create()
		a:addObject(delay)
		a:addObject(callback1)
		a:addObject(scaleBig)
		a:addObject(scaleSmall)
		a:addObject(callback2)
		local sequence = CCSequence:create(a)
		_childUI["lab_point"].handle._n:runAction(sequence)
		
		--播放音效，重置天赋点
		hApi.PlaySound("common_shop_refresh_success")
	end

	--监听打开大菠萝技能升级界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm", "__ShowDLCMapFrm", function(unitId)
		--显示大菠萝技能升级界面
		_frm:show(1)
		_frm:active()
		
		--存储单位id
		_nCurrent_unit_id = unitId
		_Code_CreateModel()
		_Code_UpdateUI()
		_Code_GetSkillTreeData()
		_Code_CreateSkillTree()
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneDiabloSkillUpInfoFrm then --删除上一次的大菠萝技能升级界面
	hGlobal.UI.PhoneDiabloSkillUpInfoFrm:del()
	hGlobal.UI.PhoneDiabloSkillUpInfoFrm = nil
end
hGlobal.UI.InitDiabloSkillUpInfoFrm() --测试创建大菠萝技能升级界面
--触发事件，显示大菠萝技能升级界面
local unitId = 6000
--LuaSetHeroTalentPoint(unitId, 10) --加天赋点
--LuaAddPlayerScore(1000000) --加积分
--LuaAddHeroExp(unitId, 10) --加经验
hGlobal.event:event("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm", unitId)
]]



