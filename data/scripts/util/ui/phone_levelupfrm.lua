--大菠萝升级界面
OnCreateDiabloLevelUpFrame = function(nUnitId,nExpAdd,nLevel,nExp)
	if hGlobal.UI.DiabloLevelUpFrame then
		return
	end

	local canClose = false
	local addexp = nExpAdd
	local _nCurrent_unit_id = nUnitId
	local scaleTank = 0.8
	local tabU = hVar.tab_unit[_nCurrent_unit_id]
	if type(tabU) ~= "table" then
		return
	end
	local getPoint = 0
	local heroLv = nLevel --英雄等级
	local heroExp = nExp --英雄该等级的经验值
	local heroExpMax = 1 --英雄该等级的总经验值
	local tHeroCard = hApi.GetHeroCardById(_nCurrent_unit_id)
	local currentStar = 0
	local heroMaxLv = 0
	if tHeroCard then
		if heroLv == nil then
			heroLv = tHeroCard.attr.level
		end
		if heroExp == nil then
			heroExp = tHeroCard.attr.exp - hVar.HERO_EXP[heroLv].minExp
		end
		heroExpMax = hVar.HERO_EXP[heroLv].nextExp or 0
		currentStar = tHeroCard and tHeroCard.attr.star or 1
		heroMaxLv = hVar.HERO_STAR_INFO[_nCurrent_unit_id][currentStar]["maxLv"]
	else
		return
	end

	--不够升级 或者已经满级 不显示
	if heroExp + addexp < heroExpMax or heroLv == heroMaxLv then
		return
	end
	
	--创建技能说明面板
	hGlobal.UI.DiabloLevelUpFrame = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		z = 100,
		show = 1,
		dragable = 2, --点击后消失
		autoactive = 0,
		failcall = 1, --出按钮区域抬起也会响应事件
		background = -1, --无底图
		border = 0, --无边框
	})
	hGlobal.UI.DiabloLevelUpFrame:active()

	local _frm = hGlobal.UI.DiabloLevelUpFrame
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--创建技能tip图片背景
	_childUI["ItemBG_1"] = hUI.button:new({
		parent = _parent,
		--model = "UI_frm:slot",
		--animation = "normal",
		model = "misc/skillup/msgbox4.png",
		dragbox = _childUI["dragBox"],
		x = hVar.SCREEN.w/2,
		y = hVar.SCREEN.h/2,
		w = 512,
		h = 480,
		code = function()
			--print("技能tip图片背景")
		end,
	})

	local offX = hVar.SCREEN.w/2
	local offY = hVar.SCREEN.h/2

	--关闭按钮区域
	_childUI["closebtn"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png", --"UI:playerBagD"
		dragbox = _childUI["dragBox"],
		x = 0,
		y = 0,
		z = -1,
		w = hVar.SCREEN.w * 2,
		h = hVar.SCREEN.h * 2,
		scaleT = 1.0,
		code = function(self, screenX, screenY, isInside)
			if canClose then
				hApi.clearTimer("_TankLevelUp")
				
				--删除本界面
				if hGlobal.UI.DiabloLevelUpFrame then
					hGlobal.UI.DiabloLevelUpFrame:del()
					hGlobal.UI.DiabloLevelUpFrame = nil
				end
				
				--播放音效，关闭界面
				hApi.PlaySound("Button2")
				
				--释放png, plist的纹理缓存（这里不清理也可以）
				--hApi.ReleasePngTextureCache()
			end
		end,
	})
	_childUI["closebtn"].handle.s:setOpacity(168)
	_childUI["closebtn"].handle.s:setColor(ccc3(0, 0, 0))

	--取消按钮
	--_childUI["btn_No"] = hUI.button:new({
		--parent = _parent,
		--model = "misc/skillup/btn_close.png",
		--dragbox =  _childUI["dragBox"],
		----scaleT = 0.95,
		--x = offX + 512/2 - 34,
		--y = offY + 480/2 - 34,
		--scale = 0.9,
		----w = 40,
		----h = 32,
		--code = function()
			--if canClose then
				--hApi.clearTimer("_TankLevelUp")

				----删除本界面
				--if hGlobal.UI.DiabloLevelUpFrame then
					--hGlobal.UI.DiabloLevelUpFrame:del()
					--hGlobal.UI.DiabloLevelUpFrame = nil
				--end
				
				----播放音效，关闭界面
				--hApi.PlaySound("Button2")
			--end
		--end,
	--})

	_childUI["img_upgrade"] = hUI.image:new({
		parent = _parent,
		x = hVar.SCREEN.w/2 + 60,
		y = hVar.SCREEN.h/2 + 115,
		model = "misc/skillup/upgrade.png",
	})

	_childUI["TankModel"] = hUI.button:new({
		parent = _parent,
		model = tabU.model,
		x = offX - 75,
		y = offY + 113,
		scale = 1.0 * scaleTank,
		dragbox = _frm.childUI["dragBox"],
	})
	
	--坦克的轮子
	local bind_wheel = tabU.bind_wheel or 0
	if (bind_wheel > 0) then
		_childUI["TankModel"].childUI["wheel"] = hUI.image:new({
			parent = _childUI["TankModel"].handle._n,
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
				_childUI["TankModel"].childUI["weapon"] = hUI.image:new({
					parent = _childUI["TankModel"].handle._n,
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
						_childUI["TankModel"].childUI["UnitEffModel" .. i] = hUI.image:new({
							parent = _childUI["TankModel"].handle._n,
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
	_childUI["bar_TankExp"] = hUI.valbar:new({
		parent = _parent,
		x = offX - 140,
		y = offY + 10,
		w = 280,
		h = 22,
		align = "LC",
		back = {model = "misc/skillup/expbar_bg.png", x = 0, y = 0, w = 280, h = 18},
		model = "misc/skillup/expbar.png",
		--model = "misc/progress.png",
		v = heroExp/heroExpMax*100,
		--v = heroExpMax, --测试 --test
		max = 100,
	})
	
	--坦克经验进度文字
	_childUI["lab_TankExp"] = hUI.label:new({
		parent = _parent,
		x = offX,
		y = offY+10,
		width = 300,
		align = "MC",
		size = 20,
		border = 1,
		font = "numWhite",
		text = heroExp .. "/" .. heroExpMax,
	})

	_childUI["lab_TankLv"] = hUI.label:new({
		parent = _parent,
		x = offX - 80,
		y = offY- 55,
		align = "MT",
		size = 24,
		border = 1,
		font = "num",
		text = "lv"..heroLv,
	})
	_childUI["lab_TankLv"].handle.s:setOpacity(0)
	_childUI["lab_TankLv"].handle._n:setVisible(false)

	_childUI["img_arrow"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/upgrade_arrow.png",
		x = offX,
		y = offY-70,
		scale = 1.0,
	})
	_childUI["img_arrow"].handle._n:setOpacity(0)

	_childUI["lab_TankNextLv"] = hUI.label:new({
		parent = _parent,
		x = offX + 80,
		y = offY - 55,
		align = "MT",
		size = 24,
		border = 1,
		font = "num",
		text = "lv"..heroLv,
	})
	_childUI["lab_TankNextLv"].handle.s:setOpacity(0)
	_childUI["lab_TankNextLv"].handle._n:setVisible(false)

	_childUI["img_Point"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/skillpoint.png",
		x = offX - 80,
		y = offY - 144,
		--scale = 1,
	})
	_childUI["img_Point"].handle._n:setOpacity(0)

	_childUI["lab_PointAdd"] = hUI.label:new({
		parent = _parent,
		x = offX,
		y = offY - 125,
		align = "MT",
		size = 30,
		border = 1,
		font = "num",
		text = "+",
	})
	_childUI["lab_PointAdd"].handle.s:setOpacity(0)
	_childUI["lab_PointAdd"].handle._n:setVisible(false)

	_childUI["lab_PointAddNum"] = hUI.label:new({
		parent = _parent,
		x = offX + 80,
		y = offY - 128,
		align = "MT",
		size = 24,
		border = 1,
		font = "num",
		text = getPoint,
	})
	_childUI["lab_PointAddNum"].handle.s:setOpacity(0)
	_childUI["lab_PointAddNum"].handle._n:setVisible(false)

	local showBarEffect = function()
		if _childUI["bar_TankExp"].childUI["effect_upgrade"] then
			hApi.safeRemoveT(_childUI["bar_TankExp"].childUI,"effect_upgrade")
		end
		_childUI["bar_TankExp"].childUI["effect_upgrade"] = hUI.image:new({
			parent = _childUI["bar_TankExp"].handle._n,
			model = "misc/skillup/upgrade_effect.png",
			x = 140,
			--y = offY,
			scale = 1.0,
			z = -1,
		})
		local delay = CCDelayTime:create(0.25)
		local fadein = CCFadeIn:create(0.2)
		local fadeout = CCFadeOut:create(0.2)
		local callback1 = CCCallFunc:create(function()
			if _childUI["bar_TankExp"].childUI["effect_upgrade"] then
				hApi.safeRemoveT(_childUI["bar_TankExp"].childUI,"effect_upgrade")
			end
		end)
		if addexp ~= 0 then
			local a = CCArray:create()
			a:addObject(fadein)
			a:addObject(delay)
			a:addObject(fadeout)
			a:addObject(callback1)
			local sequence = CCSequence:create(a)
			_childUI["bar_TankExp"].childUI["effect_upgrade"].handle.s:runAction(CCRepeatForever:create(sequence))
		else
			_childUI["bar_TankExp"].childUI["effect_upgrade"].handle.s:runAction(fadein)
		end
	end

	local action_state = 0
	local showList = {
		{"label","lab_TankLv",0},
		{"image","img_arrow",0.2},
		{"label","lab_TankNextLv",0.5,0.3},
		{"image","img_Point",0},
		{"label","lab_PointAdd",0.2},
		{"label","lab_PointAddNum",0.5,0.3},
	}

	local showAction = function()
		local currentIdx = 0
		for i = 1,#showList do
			local v = showList[i]
			if v then
				local uiname = v[2]
				local delay = CCDelayTime:create(v[3])
				local fadein = CCFadeIn:create(v[4] or 0.2)
				if v[1] == "image" then
					local a = CCArray:create()
					a:addObject(delay)
					a:addObject(fadein)
					local sequence = CCSequence:create(a)
					_childUI[uiname].handle.s:runAction(sequence)
				elseif v[1] == "label" then
					local callback1 = CCCallFunc:create(function()
						if _childUI[uiname] then
							_childUI[uiname].handle._n:setVisible(true)
						end
					end)
					local a = CCArray:create()
					a:addObject(delay)
					a:addObject(callback1)
					a:addObject(fadein)
					local sequence = CCSequence:create(a)
					_childUI[uiname].handle.s:runAction(sequence)
				end
			end
		end
	end

	local showBigger = function()
		local biggerList = {"lab_TankNextLv","lab_PointAddNum"}
		for i = 1,#biggerList do
			if _childUI[biggerList[i]] then
				local act1 = CCScaleTo:create(0.25, 1.2)
				local act2 = CCScaleTo:create(0.25, 1)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				_childUI[biggerList[i]].handle.s:runAction(sequence)
			end
		end
	end

	hApi.addTimerForever("_TankLevelUp",hVar.TIMER_MODE.GAMETIME,1,function()
		if action_state % 2 == 0 then
			if addexp > 400 then
				addexp = addexp - 24
				heroExp = heroExp + 24
			elseif addexp > 100 then
				addexp = addexp - 11
				heroExp = heroExp + 11
			elseif addexp > 40 then
				addexp = addexp - 5
				heroExp = heroExp + 5
			elseif addexp > 10 then
				addexp = addexp - 2
				heroExp = heroExp + 2
			elseif addexp > 0 then
				addexp = addexp - 1
				heroExp = heroExp + 1
			end
		end
		if heroExp >= heroExpMax then
			if action_state % 2 == 0 then
				action_state = action_state + 1
				hApi.PlaySound("skill_upgrade_success_blue")
				_childUI["lab_TankExp"]:setText(heroExpMax .. "/" .. heroExpMax)
				_childUI["bar_TankExp"]:setV(heroExpMax/heroExpMax*100)
				_childUI["lab_TankNextLv"]:setText("lv"..heroLv+1)
				_childUI["lab_PointAddNum"]:setText(getPoint+1)
				showBarEffect()
				if action_state == 1 then
					showAction()
				elseif action_state % 2 == 1 then
					showBigger()
				end
				hApi.addTimerOnce("_TankLevelUpContinue",500,function()
					heroLv = heroLv + 1
					getPoint = getPoint + 1
					heroExp = heroExp - heroExpMax
					heroExpMax = hVar.HERO_EXP[heroLv].nextExp or 0
					action_state = action_state + 1
					if heroLv == heroMaxLv then
						_childUI["lab_TankExp"]:setText(0 .. "/" .. 0)
						_childUI["bar_TankExp"]:setV(1)
						hApi.clearTimer("_TankLevelUp")
						canClose = true
					end
				end)
			end
		else
			_childUI["lab_TankExp"]:setText(heroExp .. "/" .. heroExpMax)
			_childUI["bar_TankExp"]:setV(heroExp/heroExpMax*100)
		end
		if addexp <= 0 then
			hApi.clearTimer("_TankLevelUp")
			canClose = true
		end
	end)
end