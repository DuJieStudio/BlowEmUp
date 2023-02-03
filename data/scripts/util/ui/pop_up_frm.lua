


--武器枪解锁界面
hGlobal.UI.InitUnlockWeaponTip = function(mode)
	local tInitEventName = {"LocalEvent_ShowUnlockWeaponTip","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end
	
	local _frm,_parent,_childUI = nil,nil,nil
	
	local _MoveW = 500
	local _boardw,_boardh = 470,600
	local _nUnitId = 0
	local _nWeaponIdx = 0
	local _tWeaponInfo = {}
	--local _nRequireScore = 0
	--local _nRequireRmb = 0
	--local _tRequireDebris = nil
	local _nWeaponId = 0
	local _facing = 0
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true
	
	local _weaponPos = {
		[6004] = {32,-20},
		[6007] = {32,0},
	}
	
	local noReadyWeapon = {
		[6008] = 1,
		[6009] = 1,
		--[6019] = 1,
		[6020] = 1,
	}
	
	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end
	
	local OnCreateUnlockWeaponTip = hApi.DoNothing
	local UnlockWeaponFunc = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnMoveFrmAction = hApi.DoNothing
	local OnCreateWeapon = hApi.DoNothing
	local OnWeanponStarUpEvent = hApi.DoNothing --武器枪解锁事件结果返回（解锁）
	
	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		if _frm then
			local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
			local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
			local callback = CCCallFunc:create(function()
				current_is_in_action = false
				_frm:setXY(newX,nexY)
			end)
			local a = CCArray:create()
			a:addObject(moveto)
			a:addObject(callback)
			local sequence = CCSequence:create(a)
			_frm.handle._n:runAction(sequence)
		end
	end
	
	OnCreateWeapon = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		local weaponId = _nWeaponId
		--大菠萝获得指定武器id的索引值
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, weaponId)
		local weaponScale = 1.6
		print("_weaponid",_nWeaponId)
		local weapon_offx,weapon_offy = 0,0
		if _weaponPos[weaponId] then
			weapon_offx,weapon_offy = unpack(_weaponPos[weaponId])
		end
		
		btnChild["Image_weapon"] = hUI.thumbImage:new({
			parent = btnParent,
			id = weaponId,
			x = -14 + weapon_offx,
			y = 200 + weapon_offy,
			facing = 0,
			align = "MC",
			scale = weaponScale,
			--z = 1,
		})
		local tab = hVar.tab_unit[weaponId]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_weapon"]
			local _parentNode = btnChild["Image_weapon"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_weapon"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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
					end
				end
			end
		end
		
		hApi.addTimerForever("WeaponRackAddRotateEvent1", hVar.TIMER_MODE.PCTIME, 15, function()
			local facing = (_facing - 11.25/2) % 360
			_facing = facing
			if _frm then
				hApi.ChaSetFacing(btnChild["Image_weapon"].handle, facing)
				btnChild["Image_weapon"].handle._n:setScale(weaponScale)
			end
		end)
	end
	
	_CODE_CreateChangeSkinBtn = function()
		if hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId] then
			local iPhoneX_WIDTH = 0
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				iPhoneX_WIDTH = hVar.SCREEN.offx
			end
			local offX = hVar.SCREEN.w - _boardw/2 - 6 - iPhoneX_WIDTH
			local offY = hVar.SCREEN.h/2
			
			_childUI["btn_next_r"] = hUI.button:new({
				parent = _parent,
				model = "misc/chariotconfig/next_r.png",
				dragbox = _childUI["dragBox"],
				scaleT = 0.92,
				x = offX + 180,
				y = offY + 180,
				w = 63,
				h = 62,
				code = function()
					_CODE_ChangeSkin(true)
				end,
			})
			
			_childUI["btn_next_l"] = hUI.button:new({
				parent = _parent,
				model = "misc/chariotconfig/next_r.png",
				dragbox = _childUI["dragBox"],
				scaleT = 0.92,
				x = offX - 200,
				y = offY + 180,
				w = 63,
				h = 62,
				code = function()
					_CODE_ChangeSkin(false)
				end,
			})
			_childUI["btn_next_l"].handle.s:setFlipX(true)
		end
	end
	
	_CODE_ChangeSkin = function(isRight)
		hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId] = hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId] or 1
		local curIndex = hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId]
		local totalnum = #(hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId])
		if isRight then
			curIndex = curIndex % totalnum + 1
		else
			curIndex = (curIndex-1) % totalnum
			if curIndex == 0 then
				curIndex = totalnum
			end
		end
		--print(hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId],curIndex,#hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId])
		hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId] = curIndex
		local tabU = hVar.tab_unit[_nWeaponId]
		local tempdefine = hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId][curIndex]
		if tempdefine.model then
			tabU.model = tempdefine.model
		end
		if tempdefine.effect then
			tabU.effect = tempdefine.effect
		end
		hApi.safeRemoveT(_childUI["ItemBG_1"].childUI,"Image_weapon")
		OnCreateWeapon()
	end
	
	OnCreateUnlockWeaponTip = function()
		local tHeroCard = hApi.GetHeroCardById(_nUnitId)
		if tHeroCard == nil then
			return		--没有该战车
		end
		local _nWeaponLevel = LuaGetHeroWeaponLv(_nUnitId,_nWeaponIdx)
		if _nWeaponLevel > 0 then
			return		--武器已解锁
		end
		local tabU = hVar.tab_unit[_nUnitId]
		if type(tabU) ~= "table" then
			return		--该单位不存在
		end
		
		--获取数据
		if tabU.weapon_unit and tabU.weapon_unit[_nWeaponIdx] then
			_tWeaponInfo = tabU.weapon_unit[_nWeaponIdx]
			_nWeaponId = _tWeaponInfo.unitId
			--_tRequireDebris = _tWeaponInfo.requireDebris
		else
			return		--该战车没有武器
		end
		
		local curScore = LuaGetPlayerScore() --当前积分
		
		hGlobal.UI.UnlockWeaponTipFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		_frm = hGlobal.UI.UnlockWeaponTipFrame
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local iPhoneX_WIDTH = 0
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			iPhoneX_WIDTH = hVar.SCREEN.offx
		end
		
		local offX = hVar.SCREEN.w - _boardw/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		--用于点击背景关闭的按钮
		_childUI["ItemBG_Close"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				hGlobal.event:event("clearUnlockWeaponTip")
			end,
		})
		_childUI["ItemBG_Close"].handle.s:setOpacity(0)
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = _boardw,
			h = _boardh,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		_childUI["ItemBG_1"].handle.s:setOpacity(0)
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		btnChild["rack"] = hUI.image:new({
			parent = btnParent,
			model = "misc/weaponrack.png",
			x = 0,
			y = 0,
			scale = 0.96,
		})
		
		OnCreateWeapon()
		_CODE_CreateChangeSkinBtn()
		
		local labX = - 124 - 34
		local labstartY = - 56 + 56 + 20
		local labdefH = 40 + 10
		local laboffw = 200
		
		local tabU = hVar.tab_unit[_nWeaponId] or {}
		local attr = tabU.attr or {}
		
		--[[
		--等级文字
		btnChild["lab_weapon_lv"] = hUI.label:new({
			parent = btnParent,
			x = -8,
			y = labstartY + 88,
			width = 300,
			align = "MC",
			size = 30,
			font = "numWhite",
			text = "0",
			RGB = {255,255,0},
		})
		btnChild["lab_weapon_lv"].handle.s:setColor(ccc3(255, 255, 0))
		]]
		
		--[[
		--geyachao: 王总说不要显示武器名字了
		btnChild["lab_weapon_name"] = hUI.label:new({
			parent = btnParent,
			x = - 6,
			y = 0,
			width = 300,
			height = 40,
			align = "MC",
			size = 24,
			font = hVar.FONTC,
			text = LuaGetObjectName(_nWeaponId,1),
			RGB = {255,200,50},
		})
		]]
		
		--[[
		--"未获得"文字
		btnChild["lab_weapon_unlocked"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["CurrentNotGet"], --"未获得"
			font = hVar.FONTC,
			align = "MC",
			x = -8,
			y = labstartY + 152,
			size = 30,
			border = 1,
			RGB = {255, 64, 0,},
		})
		]]
		
		btnChild["lab_damage"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__Attr_Hint_skill_damage"], --"杀伤"
			font = hVar.FONTC,
			align = "LC",
			x = labX,
			y = labstartY,
			size = 26,
			border = 1,
		}) 
		
		local valueattack = (attr.attack or {})[5] or "nodata"
		btnChild["lab_damageValue"] = hUI.label:new({
			parent = btnParent,
			text = valueattack,
			font = "numWhite",
			align = "RC",
			x = labX + laboffw,
			y = labstartY,
			size = 22,
			border = 0,
		}) 
		
		--武器解锁
		--geyachao:如果我的战车携带了加武器枪攻击力的道具，那么后面加绿字显示额外加的攻击力
		local atkBulletAdd = 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				--local atk = oUnit:GetAtk()
				local atk = attr.attack and attr.attack[5] or 0
				local atkBullet = oUnit:GetBulletAtk()
				atkBulletAdd = math.floor(atkBullet * atk / 100)
			end
		end
		if (atkBulletAdd > 0) then
			--额外攻击力
			btnChild["lab_damageValue2"] = hUI.label:new({
				parent = btnParent,
				text = "+" .. atkBulletAdd,
				font = "numGreen",
				align = "LC",
				x = labX + laboffw + 4,
				y = labstartY,
				size = 22,
				border = 0,
				--RGB = {0, 255, 0},
			})
		end
		
		--[[
		btnChild["lab_ctrl"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__Attr_Hint_crit"],
			font = hVar.FONTC,
			align = "LC",
			x = labX,
			y = labstartY - labdefH,
			size = 22,
			border = 1,
		}) 
		
		local valuectrl = attr.crit_rate or "nodata"
		btnChild["lab_ctrlValue"] = hUI.label:new({
			parent = btnParent,
			text = valuectrl,
			font = hVar.FONTC,
			align = "RC",
			x = labX + laboffw,
			y = labstartY - labdefH,
			size = 22,
			border = 1,
		})
		]]
		
		btnChild["lab_atk_interval"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__Attr_Hint_atk_interval"], --"攻击间隔"
			font = hVar.FONTC,
			align = "LC",
			x = labX,
			y = labstartY - labdefH * 1,
			size = 26,
			border = 1,
		})
		
		local atk_interval = attr.atk_interval or "nodata"
		btnChild["lab_atk_intervalValue"] = hUI.label:new({
			parent = btnParent,
			text = atk_interval,
			font = "numWhite",
			align = "RC",
			x = labX + laboffw,
			y = labstartY - labdefH * 1,
			size = 22,
			border = 0,
		})
		
		local uix = -150
		local uiy = -140
		
		--横线
		btnChild["img_line"] = hUI.image:new({
			parent = btnParent,
			model = "misc/title_line.png",
			x = -10,
			y = -140,
			w = 320,
			h = 4,
		})
        
        -- vip条件提示按钮回调
        local BtnVipConditionCallback = nil
        -- vip条件提示按钮
        _frm.childUI["btn_vip_condition"] = hUI.button:new({
            parent = _frm.handle._n,
            model = "misc/button_null.png",
            x = offX - 12,
            y = offY - 220,
            w = 300,
            h = 52,
            dragbox = _frm.childUI["dragBox"],
            scaleT = 0.95,
            z = 100,
            code = function()
                if BtnVipConditionCallback then
                    BtnVipConditionCallback()
                end
            end
        })

		local normalshow = true
		local tCondition = hVar.SpecialWeaponGetCondition[_nWeaponId]
		if tCondition then --特殊武器
			local requireUIy = 0
			local requireUIx = - 12
			if tCondition.vip then
				local vip = LuaGetPlayerVipLv()
				if tCondition.vip > vip then
					normalshow = false
					local showInfo = tCondition.showIconStr
					if type(showInfo) == "table" then
						local ImgInfo = showInfo[1] or {}
						local imgSrc = ImgInfo[1]
						local imgScale = ImgInfo[2]
						local imgoffx = ImgInfo[3] or 0
						local imgoffy = ImgInfo[4] or 0
						local str = showInfo[2] or ""

                        local parent_btn = _frm.childUI["btn_vip_condition"]
						parent_btn.childUI["img_icon"] = hUI.image:new({
							parent = parent_btn.handle._n,
							model = imgSrc,
							align = "MC",
							scale = imgScale,
						})
						local imgw = parent_btn.childUI["img_icon"].data.w

						parent_btn.childUI["lab_str"] = hUI.label:new({
							parent = parent_btn.handle._n,
							font = hVar.FONTC,
							border = 1,
							text = hVar.tab_string[str],
							size = 24,
							align = "MC",
							RGB = {240,50,0}
						})
						local strw = parent_btn.childUI["lab_str"]:getWH()
						--print(str,hVar.tab_string[str],strw,btnNode.data.x)
						local totalW = imgw + 8 + strw
						local offw = 3 + requireUIx
						parent_btn.childUI["img_icon"]:setXY(offw +(imgw - totalW)/2 + imgoffx,imgoffy + requireUIy)
						parent_btn.childUI["lab_str"]:setXY(offw + (totalW- strw)/2,requireUIy)

                        BtnVipConditionCallback = function()
                            --显示VIPTip窗口
                            hApi.ShowGeneralVIPTip(tCondition.vip)
                        end
					end
				end
			end
		end
		if normalshow then
			local requireUIx = -90
			local requireUIy = -170
			local costDebris = 0
			local _nRequireScore = 0
			local _nRequireRmb = 0
			
			--计算解锁武器需要的积分和碎片数量
			local _,costlist = LuaCheckHeroWeaponCanUpgrade(_nUnitId,_nWeaponIdx)
			for i = 1,#costlist do
				local key,value = unpack(costlist[i])
				if key == "score" then
					_nRequireScore = value
				elseif key == "weapondebir" then
					costDebris = value
				elseif key == "rmb" then
					_nRequireRmb = value
				end
			end
			
			if costDebris > 0 then
				--local nDebrisId  = _tRequireDebris[1]
				local nDebrisNum = costDebris
				local curnum = LuaGetHeroWeaponDebrisNum(_nUnitId,_nWeaponIdx)
				
				local tabU = hVar.tab_unit[_nWeaponId]
				
				--需要积分
				if (_nRequireScore > 0) then
					local font = "num"
					if curnum < nDebrisNum then
						font = "numRed"
					end
					
					--积分图标
					btnChild["img_Score"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/mu_coin.png",
						--x = offX - 54,
						--y = offY - 11,
						x = -140,
						y = requireUIy,
						w = 42,
						h = 42,
					})
					
					--需要的积分值
					btnChild["lab_Score"] = hUI.label:new({
						parent = btnParent,
						--x = offX + 36,
						--y = offY - 11 - 1,
						x = -140 + 32,
						y = requireUIy + 1,
						width = 300,
						align = "LC",
						size = 20,
						font = "num",
						border = 0,
						text = _nRequireScore,
					})
				end
				
				--需要游戏币
				if (_nRequireRmb > 0) then
					local font = "num"
					if curnum < nDebrisNum then
						font = "numRed"
					end
					
					--游戏币图标
					btnChild["img_Rmb"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/keshi.png",
						--x = offX - 54,
						--y = offY - 11,
						x = requireUIx,
						y = requireUIy,
						w = 42,
						h = 42,
					})
					
					--需要的游戏币值
					btnChild["lab_Rmb"] = hUI.label:new({
						parent = btnParent,
						--x = offX + 36,
						--y = offY - 11 - 1,
						x = requireUIx + 110,
						y = requireUIy - 2,
						width = 300,
						align = "MC",
						size = 24,
						font = "num",
						border = 0,
						text = _nRequireRmb,
					})
				end
				
				--碎片图标
				btnChild["img_debris"] = hUI.image:new({
					parent = btnParent,
					model = tabU.icon,
					x = requireUIx,
					y = requireUIy - 50,
					w = 64,
					h = 64,
				})

				btnChild["img_debrisicon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/debris.png",
					x = requireUIx + 10,
					y = requireUIy - 50 - 15,
					scale = 0.8,
				})
				
				--碎片进度条
				local progressV = 0
				if (nDebrisNum > 0) then
					progressV = curnum / nDebrisNum * 100 --进度
				end
				btnChild["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = btnParent,
					x = requireUIx + 32 + 4,
					y = requireUIy - 50 - 4,
					w = 160,
					h = 28,
					align = "LC",
					back = {model = "misc/chest/jdd1.png", x = -4, y = 0, w = 160 + 7, h = 34},
					model = "misc/chest/jdt1.png",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				
				--进度条文字
				local labFontSize = 22
				local strFontText = tostring(curnum)
				if (nDebrisNum > 0) then
					strFontText = (tostring(curnum) .. "/" .. tostring(nDebrisNum))
				end
				--strFontText = "0000000/000" --测试 test
				--print(#strFontText)
				if (#strFontText == 9) then
					labFontSize = 20
				elseif (#strFontText == 10) then
					labFontSize = 18
				elseif (#strFontText == 11) then
					labFontSize = 16
				end
				local font = "numWhite"
				if curnum < nDebrisNum then
					font = "numRed"
				end
				btnChild["lab_debris"] = hUI.label:new({
					parent = btnParent,
					x = requireUIx + 116 - 1,
					y = requireUIy - 50 - 2,
					width = 300,
					align = "MC",
					size = labFontSize,
					font = font,
					border = 0,
					text = strFontText,
				})
			end
		end
		
		if noReadyWeapon[_nWeaponId] then --未开放的武器枪
			_childUI["btn_NoReady"] = hUI.button:new({
				parent = _parent,
				model = "misc/weaponrack_btn.png",
				label = {text = hVar.tab_string["not_ready"],size = 24,border = 1,font = hVar.FONTC,y = -2,height= 32,},
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				x = offX - 4,
				y = offY - 306,
				scale = 1.0,
				code = function()
					--
				end,
			})
			--hApi.AddShader(_childUI["btn_NoReady"].handle.s, "gray")
		else
			local text = hVar.tab_string["unlock"]
			_childUI["btn_unlock"] = hUI.button:new({
				parent = _parent,
				model = "misc/weaponrack_btn.png",
				--label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = -2,height= 32,},
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				x = offX - 6,
				y = offY - 306,
				scale = 1.0,
				--w = 124,
				--h = 52,
				code = function()
					print("btn_unlock")
					--在动画中禁止点击
					if current_is_in_action then
						return
					end
					UnlockWeaponFunc()
				end,
			})
			
			_childUI["btn_unlock"].childUI["img"] = hUI.button:new({
				parent = _childUI["btn_unlock"].handle._n,
				model = "misc/skillup/btnicon_unlock.png",
				scale = 0.7,
				y = -4,
			})
		end

		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)

		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
		
		--添加监听事件：武器枪解锁事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponStarUp_Ret", "_WeaponStarUp_Unlock", OnWeanponStarUpEvent)
	end
	
	--点击解锁按钮
	UnlockWeaponFunc = function()
		local tCondition = hVar.SpecialWeaponGetCondition[_nWeaponId]
		if tCondition then --特殊武器
			local requireUIy = - 220
			local requireUIx = - 32
			if tCondition.vip then
				local vip = LuaGetPlayerVipLv()
				if tCondition.vip > vip then
					local showInfo = tCondition.showIconStr
					if type(showInfo) == "table" then
						local str = showInfo[2] or ""
						local strText = hVar.tab_string[str]
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 2000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
						return
					end
				end
			end
		end
		local bFlag = LuaCheckHeroWeaponCanUpgrade(_nUnitId,_nWeaponIdx,1)
		if bFlag then
			--挡操作
			hUI.NetDisable(30000)
			
			--发起请求，武器升星（解锁）
			local tabU = hVar.tab_unit[_nUnitId]
			local tabUW = tabU.weapon_unit
			local weaponId = tabUW[_nWeaponIdx].unitId
			SendCmdFunc["tank_weapon_starup"](weaponId)
		end
	end
	
	--武器枪升星事件结果返回（解锁）
	OnWeanponStarUpEvent = function(result, weaponId, star, num, level, costScore, costDebris, costRmb)
		--print("OnWeanponStarUpEvent", result, weaponId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			local tabU = hVar.tab_unit[_nUnitId]
			local tabUW = tabU.weapon_unit
			local weaponId_i = tabUW[_nWeaponIdx].unitId
			
			--防止别的武器走进来
			if (weaponId == weaponId_i) then
				--冒字，解锁成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_UNLOCK_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"解锁成功！"
				
				--播放出售音效
				hApi.PlaySound("itemupgrade")

				hGlobal.event:event("LocalEvent_refreshWeaponInfo")
				
				--关闭本界面
				OnLeaveFunc()
			end
		end
	end
	
	OnLeaveFunc = function()
		hApi.clearTimer("WeaponRackAddRotateEvent1")
		if hGlobal.UI.UnlockWeaponTipFrame then
			hGlobal.UI.UnlockWeaponTipFrame:del()
			hGlobal.UI.UnlockWeaponTipFrame = nil
		end
		_nUnitId = 0
		_nWeaponIdx = 0
		_tWeaponInfo = {}
		--_nRequireScore = 0
		--_nRequireRmb = 0
		_nWeaponId = 0
		--_tRequireDebris = nil
		_frm,_parent,_childUI = nil,nil,nil
		
		--移除监听事件：武器枪解锁事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponStarUp_Ret", "_WeaponStarUp_Unlock", nil)
	end
	
	hGlobal.event:listen("clearUnlockWeaponTip","clearfrm",function()
		if _nWeaponId and _nWeaponId ~= 0 and hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId] then
			hVar.WEAPON_SKIN_TEMPINDEX[_nWeaponId] = 1
			local tabU = hVar.tab_unit[_nWeaponId]
			local tempdefine = hVar.WEAPON_SKIN_TEMPDEFINE[_nWeaponId][1]
			if tempdefine.model then
				tabU.model = tempdefine.model
			end
			if tempdefine.effect then
				tabU.effect = tempdefine.effect
			end
		end
		OnLeaveFunc()
		_bCanCreate = true
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","UnlockWeaponTip",function()
		if _frm and _frm.data.show == 1 then
			local nUnitId = _nUnitId
			local nWeaponIdx = _nWeaponIdx
			OnLeaveFunc()
			_nUnitId = nUnitId
			_nWeaponIdx = nWeaponIdx
			OnCreateUnlockWeaponTip()
		end
	end)
	
	--"LocalEvent_ShowUnlockWeaponTip"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nUnitId,nWeaponIdx)
		--print(nUnitId,nWeaponIdx)
		if _bCanCreate then
			_bCanCreate = false
			--界面未打开 可创建
			OnLeaveFunc()
			_nUnitId = nUnitId
			_nWeaponIdx = nWeaponIdx
			OnCreateUnlockWeaponTip()
		end
	end)
end
--[[
--测试 --test
--删除上次的界面
if hGlobal.UI.UnlockWeaponTipFrame then
	hGlobal.UI.UnlockWeaponTipFrame:del()
	hGlobal.UI.UnlockWeaponTipFrame = nil
end
hGlobal.UI.InitUnlockWeaponTip("include") --武器枪解锁界面
hGlobal.event:event("LocalEvent_ShowUnlockWeaponTip", 6000, 2)
]]







--武器枪界面2（已废弃？）
--hGlobal.UI.InitWeaponInfoFrm = function(mode)
--	local tInitEventName = {"LocalEvent_ShowWeaponInfoFrm", "_show",}
--	if (mode ~= "include") then
--		return tInitEventName
--	end
--
--	local _frm,_parent,_childUI = nil,nil,nil
--	local _current_is_in_action = true
--	local _boardW,_boardH = 480,360
--	local _MoveW = _boardW + 20
--	local _nWeaponId = 0
--
--	local weaponOff = {
--		[6004] = {-16,0}
--	}
--
--	local _CODE_ClearFunc = hApi.DoNothing
--	local _CODE_CreateFrm = hApi.DoNothing
--	local _CODE_CreateUI = hApi.DoNothing
--	local _CODE_CreateTank = hApi.DoNothing
--	local _CODE_CreateWeaponInfo = hApi.DoNothing
--	local _CODE_CreateWeapon = hApi.DoNothing
--	local _CODE_CreateLv = hApi.DoNothing
--
--	_CODE_ClearFunc = function()
--		if hGlobal.UI.WeaponInfoFrm then
--			hGlobal.UI.WeaponInfoFrm:del()
--			hGlobal.UI.WeaponInfoFrm = nil
--		end
--		_frm,_parent,_childUI = nil,nil,nil
--		_current_is_in_action = true
--		_nWeaponId = 0
--	end
--
--	_CODE_CreateFrm = function()
--		hGlobal.UI.WeaponInfoFrm  = hUI.frame:new({
--			x = 0,
--			y = hVar.SCREEN.h,
--			w = hVar.SCREEN.w,
--			h = hVar.SCREEN.h,
--			background = -1,
--			dragable = 0,
--			show = 0,
--			--z = -1,
--			buttononly = 1,
--		})
--		_frm = hGlobal.UI.WeaponInfoFrm
--		_parent = _frm.handle._n
--		_childUI = _frm.childUI
--
--		local offX = hVar.SCREEN.w/2
--		local offY = -hVar.SCREEN.h/2
--
--		--创建技能tip图片背景
--		_childUI["ItemBG_1"] = hUI.button:new({
--			parent = _parent,
--			--model = "UI_frm:slot",
--			--animation = "normal",
--			model = "misc/skillup/msgbox4.png",
--			dragbox = _childUI["dragBox"],
--			x = offX,
--			y = offY,
--			w = _boardW,
--			h = _boardH,
--			code = function()
--				--print("技能tip图片背景")
--			end,
--		})
--		
--		--关闭按钮
--		_childUI["closeBtn"] = hUI.button:new({
--			parent = _parent,
--			dragbox = _childUI["dragBox"],
--			model = "misc/skillup/btn_close.png",
--			x = offX + _boardW/2 - 38,
--			y = offY + _boardH/2 - 38,
--			scaleT = 0.9,
--			z = 2,
--			code = function()
--				hGlobal.event:event("clearUnlockWeaponTip")
--				--hGlobal.event:event("LocalEvent_ShowWeaponInfoFrm_MainBase")
--			end,
--		})
--		--[[
--		_childUI["btn_use"] = hUI.button:new({
--			parent = _parent,
--			dragbox = _frm.childUI["dragBox"],
--			model = "misc/skillup/select_l.png",
--			scaleT = 0.95,
--			x = offX + _boardW/2 - 140,
--			y = offY - _boardH/2 + 125,
--			--w = 128,
--			--h = 128,
--		})
--		--]]
--
--		_childUI["btn_levelup"] = hUI.button:new({
--			parent = _parent,
--			dragbox = _frm.childUI["dragBox"],
--			model = "misc/skillup/btn_levelup.png",
--			scaleT = 0.95,
--			x = offX + 50 + 40,
--			y = offY - _boardH/2 + 72,
--			scale = 0.8,
--		})
--
--		_frm:show(1)
--		_frm:active()
--	end
--
--	_CODE_CreateUI = function()
--		local weaponX = 210
--		local weaponY = -10
--
--		--_CODE_CreateWeapon(1,_nWeaponId,weaponX,weaponY)
--		--_CODE_CreateWeapon(2,_nWeaponId,weaponX + 40,weaponY + 72)
--		--_CODE_CreateWeapon(2,_nWeaponId,weaponX + 80,weaponY)
--		--_CODE_CreateWeapon(3,_nWeaponId,weaponX + 40,weaponY - 70)
--
--		_CODE_CreateTank()
--		_CODE_CreateWeaponInfo()
--		_CODE_CreateLv()
--	end
--	
--	--武器属性界面
--	_CODE_CreateWeaponInfo = function()
--		local btnChild = _childUI["ItemBG_1"].childUI
--		local btnParent = _childUI["ItemBG_1"].handle._n
--
--		local labX = - 100 + 100
--		local labstartY = 66
--		local labdefH = 44
--
--		local tabU = hVar.tab_unit[_nWeaponId] or {}
--		local attr = tabU.attr or {}
--		
--		--[[
--		--geyachao:王总说不要显示武器名字了
--		btnChild["lab_weapon_name"] = hUI.label:new({
--			parent = btnParent,
--			x =  0,
--			y = 130,
--			width = 300,
--			height = 40,
--			align = "MC",
--			size = 28,
--			font = hVar.FONTC,
--			text = LuaGetObjectName(_nWeaponId,1),
--			RGB = {255,200,50},
--		})
--		]]
--		
--		btnChild["lab_damage"] = hUI.label:new({
--			parent = btnParent,
--			text = "伤害",
--			font = hVar.FONTC,
--			align = "LC",
--			x = labX,
--			y = labstartY,
--			size = 22,
--			border = 1,
--		}) 
--
--		local valueattack = (attr.attack or {})[5] or "nodata"
--		btnChild["lab_damageValue"] = hUI.label:new({
--			parent = btnParent,
--			text = valueattack,
--			font = hVar.FONTC,
--			align = "RC",
--			x = labX + 170,
--			y = labstartY,
--			size = 22,
--			border = 1,
--		})
--		
--		--武器升星（已废弃？）
--		--geyachao:如果我的战车携带了加武器枪攻击力的道具，那么后面加绿字显示额外加的攻击力
--		local atkBulletAdd = 0
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
--		local oHero = oPlayerMe.heros[1]
--		if oHero then
--			local oUnit = oHero:getunit()
--			if oUnit then
--				--local atk = oUnit:GetAtk()
--				local atk = attr.attack and attr.attack[5] or 0
--				local atkBullet = oUnit:GetBulletAtk()
--				atkBulletAdd = math.floor(atkBullet * atk / 100)
--			end
--		end
--		if (atkBulletAdd > 0) then
--			--额外攻击力
--			btnChild["lab_damageValue2"] = hUI.label:new({
--				parent = btnParent,
--				text = "+" .. atkBulletAdd,
--				font = hVar.FONTC,
--				align = "LC",
--				x = labX + 170 + 4,
--				y = labstartY,
--				size = 22,
--				border = 1,
--				RGB = {0, 255, 0},
--			})
--		end
--		
--		btnChild["lab_ctrl"] = hUI.label:new({
--			parent = btnParent,
--			text = "暴击",
--			font = hVar.FONTC,
--			align = "LC",
--			x = labX,
--			y = labstartY - labdefH,
--			size = 22,
--			border = 1,
--		}) 
--
--		local valuectrl = attr.crit_rate or "nodata"
--		btnChild["lab_ctrlValue"] = hUI.label:new({
--			parent = btnParent,
--			text = valuectrl,
--			font = hVar.FONTC,
--			align = "RC",
--			x = labX + 170,
--			y = labstartY - labdefH,
--			size = 22,
--			border = 1,
--		}) 
--
--		btnChild["lab_num"] = hUI.label:new({
--			parent = btnParent,
--			text = "弹药",
--			font = hVar.FONTC,
--			align = "LC",
--			x = labX,
--			y = labstartY - labdefH * 2,
--			size = 22,
--			border = 1,
--		}) 
--
--		local bullet_capacity = attr.bullet_capacity or math.random(200,500)
--		btnChild["lab_numValue"] = hUI.label:new({
--			parent = btnParent,
--			text = bullet_capacity,
--			font = hVar.FONTC,
--			align = "RC",
--			x = labX + 170,
--			y = labstartY - labdefH * 2,
--			size = 22,
--			border = 1,
--		}) 
--
--		--[[
--		btnChild["img_skillbg"] = hUI.image:new({
--			parent = btnParent,
--			model = hVar.tab_item[12019].icon,
--			x =  0,
--			y = -127,
--			--scale = 0.8,
--		})
--		--]]
--	end
--
--	_CODE_CreateWeapon = function(index,weaponId,x,y)
--		print(index,weaponId,x,y)
--		local btnChild = _childUI["ItemBG_1"].childUI
--		local btnParent = _childUI["ItemBG_1"].handle._n
--
--		local weaponOffX,weaponOffY = 0,0
--		if type(weaponOff[weaponId]) == "table" then
--			weaponOffX,weaponOffY = unpack(weaponOff[weaponId])
--		end
--
--		btnChild["Image_weaponbg"..index] = hUI.image:new({
--			parent = btnParent,
--			model = "misc/skillup/skillbg.png",
--			x = x - 16,
--			y = y + 40,
--			scale = 0.8,
--		})
--		btnChild["Image_weaponbg"..index].handle.s:setOpacity(120)
--
--		btnChild["Image_weapon"..index] = hUI.thumbImage:new({
--			parent = btnParent,
--			id = weaponId,
--			x = x + weaponOffX,
--			y = y + weaponOffY + 20,
--			scale = 0.6,
--			--z = 1,
--		})
--		if index ~= 1 then
--			btnChild["Image_weapon"..index].handle.s:setColor(ccc3(120,120,120))
--		end
--
--		local tab = hVar.tab_unit[weaponId]
--		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
--			local _frmNode  = btnChild["Image_weapon"..index]
--			local _parentNode = btnChild["Image_weapon"..index].handle._n
--			local offEffectY = 0 
--			if tab.model == nil then
--				btnChild["Image_weapon"..index].handle.s:setOpacity(0)
--				offEffectY = 20
--			end
--			for i = 1,#tab.effect do
--				local effect = tab.effect[i]
--				local effectId = effect[1]
--				local effX = effect[2] or 0
--				local effY = (effect[3] or 0) + offEffectY
--				local effScale = effect[4] or 1.0
--				--print(effectId, cardId)
--				local effModel = effectId
--				if (type(effectId) == "number") then
--					effModel = hVar.tab_effect[effectId].model
--				end
--				if effModel then
--					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
--						parent = _parentNode,
--						model = effModel,
--						align = "MC",
--						x = effX,
--						y = effY,
--						z = effect[4] or -1,
--						scale = 1.2 * effScale,
--					})
--					
--					local tabM = hApi.GetModelByName(effModel)
--					if tabM then
--						local tRelease = {}
--						local path = tabM.image
--						tRelease[path] = 1
--						hResource.model:releasePlist(tRelease)
--					end
--				end
--			end
--		end
--	end
--
--	_CODE_CreateLv = function()
--		local btnChild = _childUI["ItemBG_1"].childUI
--		local btnParent = _childUI["ItemBG_1"].handle._n
--		local expX = -_boardW/2 + 126
--		local expY = - 108
--
--		local offx = 0
--		if g_Cur_Language == 3 then
--			expX = -_boardW/2 + 152
--			btnChild["lab_txtlv"] = hUI.label:new({
--				parent = btnParent,
--				x = expX,
--				y = expY + 68,
--				--font = hVar.FONTC,
--				size = 22,
--				text = "proficiency",
--				align = "MC",
--				border = 1,
--				RGB = {255,200,50},
--			})
--		else
--			offx = 20
--			btnChild["lab_txtlv"] = hUI.label:new({
--				parent = btnParent,
--				x = expX - 60 + offx,
--				y = expY + 2,
--				font = hVar.FONTC,
--				size = 18,
--				text = "熟练度",
--				width = 30,
--				align = "MC",
--				border = 1,
--				RGB = {255,200,50},
--			})
--		end
--
--		btnChild["img_expbg"] = hUI.image:new({
--			parent = btnParent,
--			model = "misc/chariotconfig/exp_bg.png",
--			x = expX + offx,
--			y = expY,
--			scale = 0.6,
--		})
--
--		btnChild["lab_lv"] = hUI.label:new({
--			parent = btnParent,
--			x = expX + offx,
--			y = expY + 2,
--			font = hVar.FONTC,
--			size = 18,
--			text = "Lv 20",
--			align = "MC",
--			border = 1,
--		})
--
--		btnChild["timebar_exp"] = hUI.timerbar:new({
--			parent = btnParent,
--			model = "misc/chariotconfig/exp_bar.png",
--			x = expX + offx,
--			y = expY,
--			scale = 0.6,
--		})
--		btnChild["timebar_exp"]:setPercentage(45)
--	end
--
--	_CODE_CreateTank = function()
--		local nTankID = 6000
--		local tabU = hVar.tab_unit[nTankID]
--		local nWeaponId = _nWeaponId
--		local nwheel = tabU.bind_wheel
--
--		local btnChild = _childUI["ItemBG_1"].childUI
--		local btnParent = _childUI["ItemBG_1"].handle._n
--
--		local tankX = -_boardW/2 + 136
--
--		local tankY = 24
--		local facing = 235
--
--		local scale = 0.76
--
--		btnChild["Tank"] = hUI.thumbImage:new({
--			parent = btnParent,
--			id = nTankID,
--			scale = scale,
--			facing = facing,
--			x = tankX,
--			y = tankY,
--		})
--		
--		btnChild["Wheel"] = hUI.thumbImage:new({
--			parent = btnParent,
--			id = nwheel,
--			scale = scale,
--			facing = facing,
--			x = tankX,
--			y = tankY,
--		})
--
--		local tab = hVar.tab_unit[nWeaponId]
--		if tab then
--			if tab.model then
--				btnChild["Weapon"] = hUI.thumbImage:new({
--					parent = btnParent,
--					id = nWeaponId,
--					scale = scale,
--					facing = facing,
--					x = tankX,
--					y = tankY,
--				})
--			else
--				btnChild["Weapon"] = hUI.image:new({
--					parent = btnParent,
--					model = "misc/button_null.png",
--					scale = scale,
--					x = tankX,
--					y = tankY,
--				})
--			end
--
--			if type(tab.effect) == "table" and #tab.effect > 0 then
--				local _frmNode  = btnChild["Weapon"]
--				local _parentNode = btnChild["Weapon"].handle._n
--				for i = 1,#tab.effect do
--					local effect = tab.effect[i]
--					local effectId = effect[1]
--					local effX = effect[2] or 0
--					local effY = effect[3] or 0
--					local effScale = effect[4] or 1.0
--					--print(effectId, cardId)
--					local effModel = effectId
--					if (type(effectId) == "number") then
--						effModel = hVar.tab_effect[effectId].model
--					end
--					if effModel then
--						_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
--							parent = _parentNode,
--							model = effModel,
--							align = "MC",
--							x = effX,
--							y = effY,
--							z = effect[4] or -1,
--							scale = 1.2 * effScale,
--						})
--						
--						local tabM = hApi.GetModelByName(effModel)
--						if tabM then
--							local tRelease = {}
--							local path = tabM.image
--							tRelease[path] = 1
--							hResource.model:releasePlist(tRelease)
--						end
--					end
--				end
--			end
--		end
--	end
--
--	hGlobal.event:listen("LocalEvent_SpinScreen","showWeaponInfoFrm",function()
--		if _frm and _frm.data.show == 1 then
--			hGlobal.event:event("LocalEvent_ShowWeaponInfoFrm",_nWeaponId)
--		end
--	end)
--
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(weaponId)
--		_CODE_ClearFunc()
--		_nWeaponId = weaponId
--		_CODE_CreateFrm()
--		_CODE_CreateUI()
--	end)
--end

hGlobal.UI.InitShowGotoPlay = function(mode)
	local tInitEventName = {"LocalEvent_ShowGotoPlay","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _MoveW = 500
	local _boardW = 640
	local _boardH = 480
	local current_is_in_action = true
	local _bCanCreate = true
	local _nChooseDiff = 1

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local OnMoveFrmAction = hApi.DoNothing
	local _CODE_RefreshBtn = hApi.DoNothing
	local _CODE_ClickDiff = hApi.DoNothing
	local _CODE_CheckCanPlay = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.ShowGotoPlayFrm then
			hGlobal.UI.ShowGotoPlayFrm:del()
			hGlobal.UI.ShowGotoPlayFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		current_is_in_action = true
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.ShowGotoPlayFrm  = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})       

		_frm = hGlobal.UI.ShowGotoPlayFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_CODE_CreateUI()

		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)

		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	_CODE_CreateUI = function()
		local offX = hVar.SCREEN.w - _boardW/2 - 6 - hVar.SCREEN.offx
		local offY = hVar.SCREEN.h/2

		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			model = "misc/gophermachine.png",
			dragbox = _childUI["dragBox"],
			x = offX + 60,
			y = hVar.SCREEN.h/2,
			--w = _boardW,
			--h = _boardH,
			--scale = 1.16,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n


		--local btnmode = "misc/mask.png"
		local btnmode = "misc/button_null.png"

		_childUI["btn_lab"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			x = offX + 6 + 10,
			y = offY - _boardH/2 + 80 - 38,
			label = {text = hVar.tab_string["startgame"],x = - 36,size = 40,font = hVar.FONTC},
		})

		_childUI["btn_lab"].childUI["coin2"] = hUI.image:new({
			parent = _childUI["btn_lab"].handle._n,
			model = "misc/coin2.png",
			x = 41,
			y =  - 6,
			--scale = 0.6,
		})

		_childUI["btn_lab"].childUI["num"] = hUI.label:new({
			parent = _childUI["btn_lab"].handle._n,
			text = "",
			font = "numGreen",
			align = "LC",
			size = 28,
			x = 66,
			y =  - 7,
		})
		local pBlink = xlAddGroundEffect(0,-1,0,10,600/1000,0.8,0,0,255,1)
		_childUI["btn_lab"].handle._nBlink = pBlink
		pBlink:getParent():removeChild(pBlink,false)
		pBlink:setScaleX(14)
		pBlink:setScaleY(7)
		_childUI["btn_lab"].handle._n:addChild(pBlink)
		_childUI["btn_lab"].handle._n:setRotation(5.6)
		--[[
		local lab = _childUI["btn_lab"]
		local aArray = CCArray:create()
		aArray:addObject(CCScaleTo:create(600/1000,0.9))
		aArray:addObject(CCScaleTo:create(600/1000,1.0))
		local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
		lab.handle._n:runAction(CCRepeatForever:create(seq))
		--]]

		_childUI["btn_play"] = hUI.button:new({
			parent = _parent,
			model = btnmode,
			dragbox = _childUI["dragBox"],
			x = offX + 6 + 14,
			y = offY - _boardH/2 + 80 - 22,
			w = 300,
			h = 180,
			code = function()
				local bflag = _CODE_CheckCanPlay()
				if bflag then
					hUI.NetDisable(5000)
					SendCmdFunc["require_playgopher"](_nChooseDiff)
				end
				--走服务器
				--hGlobal.event:event("LocalEvent_EnterGopherBoomGame",_nChooseDiff)
			end,
		})

		local height = 46	--76
		local ox = 76
		local oy = 64
		for i = 1,4 do
			_childUI["btn_level"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				--label = {text = hVar.tab_string["__TEXT_Level"].." "..i,size = 28,font = hVar.FONTC,y = 2,x = 0,align = "MC"},
				x = offX + ox + (i-1)*1,
				y = hVar.SCREEN.h/2 + _boardH/2 - height - (i-1) * height + oy,
				w = _boardH,
				h = 70,
				code = function()
					_CODE_ClickDiff(i)
				end,
			})

			local norecord = hVar.tab_string["norecord"]
			local gameinfo = ""
			local hitinfo = ""

			--[[
			local bestinfo = LuaGetGameGopherLog(i)
			--table_print(bestinfo)
			local bestnum = bestinfo[1] or 0
			local hitrate = bestinfo[2] or 0
			local maxnum = bestinfo[3] or 0
			local curmaxnum = LuaGetGameGopherUnitMaxNum(i)
			if curmaxnum ~= maxnum then
				bestnum = 0
				hitrate = 0
				maxnum = 0
			end
			if bestnum > 0 then
				norecord = ""
				gameinfo = tostring(bestnum) .. " / "..tostring(curmaxnum)
				local rate = 0
				if bestnum == maxnum then
					rate = 100 * bestnum / hitrate
				else
					rate = 100 * bestnum / (math.max(curmaxnum,hitrate))
				end
				hitinfo = string.format("%.1f",tostring(rate)).."%"
			end
			--]]

			local bestinfo = LuaGetGameGopherLog2(i)
			local bestScore = bestinfo[1] or 0
			local _,maxscore = LuaGetGameGopherUnitMaxNum(i)
			if bestScore > 0 and bestScore <= maxscore then
				norecord = ""
				gameinfo = tostring(bestScore) .. " / "..tostring(maxscore)
			end

			--print("hitinfo",hitinfo)

			_childUI["btn_level"..i].childUI["img_gopher"] = hUI.image:new({
				parent = _childUI["btn_level"..i].handle._n,
				model = "misc/gopherboom/gopher"..i..".png",
				scale = 0.8,
				x = - 204,
				y = 0,
			})

			_childUI["btn_level"..i].childUI["img_bar"] = hUI.button:new({
				parent = _childUI["btn_level"..i].handle._n,
				model = "misc/gopherboom/bar.png",
				x = 40,
				--y = 4,
			})

			_childUI["btn_level"..i].childUI["lab_norecord"] = hUI.label:new({
				parent = _childUI["btn_level"..i].handle._n,
				text = norecord,
				font = hVar.FONTC,
				align = "MC",
				size = 26,
				y = 2,
			})

			_childUI["btn_level"..i].childUI["lab_record"] = hUI.label:new({
				parent = _childUI["btn_level"..i].handle._n,
				text = gameinfo,
				font = hVar.FONTC,
				align = "MC",
				size = 26,
				--x = - 64,
				y = 4,
			})

			--[[
			_childUI["btn_level"..i].childUI["lab_record"] = hUI.label:new({
				parent = _childUI["btn_level"..i].handle._n,
				text = gameinfo,
				font = hVar.FONTC,
				align = "MC",
				size = 26,
				x = - 64,
				y = 4,
			})

			_childUI["btn_level"..i].childUI["lab_hitrate"] = hUI.label:new({
				parent = _childUI["btn_level"..i].handle._n,
				text = hitinfo,
				font = hVar.FONTC,
				align = "MC",
				size = 26,
				x = 84,
				y = 4,
			})
			--]]

			_childUI["btn_level"..i].childUI["img_choose"] = hUI.image:new({
				parent = _childUI["btn_level"..i].handle._n,
				model = "misc/gopherboom/gou.png",
				x = 196,
				--y = - 2,
			})
			_childUI["btn_level"..i].handle._n:setScale(0.66)
			_childUI["btn_level"..i].handle._n:setRotation(6)

			
		end

		local scale = 1.2
		local scaleT = 0.7
		_childUI["btnb_level1"] = hUI.button:new({
			parent = _parent,
			model = btnmode,
			dragbox = _childUI["dragBox"],
			x = offX - 32,
			y = offY + 22,
			w = 180,
			h = 50,
			scale = scale,
			scaleT = scaleT,
			code = function()
				_CODE_ClickDiff(1)
			end,
		})

		_childUI["btnb_level1"].childUI["image"] = hUI.image:new({
			parent = _childUI["btnb_level1"].handle._n,
			model = "misc/gopherboom/gopher1.png",
			x = 10,
			scale = 0.9,
		})


		_childUI["btnb_level2"] = hUI.button:new({
			parent = _parent,
			model = btnmode,
			dragbox = _childUI["dragBox"],
			x = offX + 164,
			y = offY + 6,
			w = 180,
			h = 50,
			scale = scale,
			scaleT = scaleT,
			code = function()
				_CODE_ClickDiff(2)
			end,
		})

		_childUI["btnb_level2"].childUI["image"] = hUI.image:new({
			parent = _childUI["btnb_level2"].handle._n,
			model = "misc/gopherboom/gopher2.png",
			scale = 0.95,
			x = - 10,
		})

		_childUI["btnb_level3"] = hUI.button:new({
			parent = _parent,
			model = btnmode,
			dragbox = _childUI["dragBox"],
			x = offX - 64,
			y = offY - 32,
			w = 180,
			h = 50,
			scale = scale,
			scaleT = scaleT,
			code = function()
				_CODE_ClickDiff(3)
			end,
		})

		_childUI["btnb_level3"].childUI["image"] = hUI.image:new({
			parent = _childUI["btnb_level3"].handle._n,
			model = "misc/gopherboom/gopher3.png",
			scale = 0.98,
			x = 10,
		})

		_childUI["btnb_level4"] = hUI.button:new({
			parent = _parent,
			model = btnmode,
			dragbox = _childUI["dragBox"],
			x = offX + 130,
			y = offY - 50,
			w = 180,
			h = 50,
			scale = scale,
			scaleT = scaleT,
			code = function()
				_CODE_ClickDiff(4)
			end,
		})

		_childUI["btnb_level4"].childUI["image"] = hUI.image:new({
			parent = _childUI["btnb_level4"].handle._n,
			model = "misc/gopherboom/gopher4.png",
			x = - 10,
		})

		_CODE_ClickDiff(1)
	end

	_CODE_ClickDiff = function(diff)
		_nChooseDiff = diff
		_CODE_RefreshBtn()
		local tDiffDefine = hVar.GameGopherDiffDefine[diff]
		if tDiffDefine then
			local costcoin = tDiffDefine.costcoin
			_childUI["btn_lab"].childUI["num"]:setText(tostring(costcoin))
		end
	end

	_CODE_CheckCanPlay = function()
		local tDiffDefine = hVar.GameGopherDiffDefine[_nChooseDiff]
		if tDiffDefine then
			local disuCoin = LuaGetTankDiShuCoinNum()
			local costcoin = tDiffDefine.costcoin
			if disuCoin >= costcoin then
				return true
			else
				hApi.NotEnoughResource("dishu")
			end
		end
	end

	_CODE_RefreshBtn = function()
		for i = 1,4 do
			if _childUI["btn_level"..i] and _childUI["btn_level"..i].childUI["img_choose"] then
				if _nChooseDiff == i then
					_childUI["btn_level"..i].childUI["img_choose"].handle._n:setVisible(true)
				else
					_childUI["btn_level"..i].childUI["img_choose"].handle._n:setVisible(false)
				end
			end
		end
	end

	hGlobal.event:listen("clearGotoPlayfrm","clearfrm",function()
		_bCanCreate = true
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","showGotoPlay",function()
		if _frm and _frm.data.show == 1 then
			_bCanCreate = true
			_CODE_ClearFunc()
			hGlobal.event:event("LocalEvent_ShowGotoPlay")
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		if _bCanCreate then
			_bCanCreate = false
			_CODE_ClearFunc()
			_CODE_CreateFrm()
		end
		
	end)
end


hGlobal.UI.InitPlayerBestInfo = function(mode)
	local tInitEventName = {"LocalEvent_ShowPlayerBestInfo","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 500
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local OnMoveFrmAction = hApi.DoNothing
	local OnCreatePlayerBestInfo = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.PlayerBestInfoFrame
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	OnCreatePlayerBestInfo = function()
		if hGlobal.UI.PlayerBestInfoFrame then
			hGlobal.UI.PlayerBestInfoFrame:del()
			hGlobal.UI.PlayerBestInfoFrame = nil
		end
		hGlobal.UI.PlayerBestInfoFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		local _frm = hGlobal.UI.PlayerBestInfoFrame
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - 540/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2

		_childUI["img_tv"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/ranktv.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			scale = 0.85,
			code = function()
				--print("技能tip图片背景")
			end,
		})	
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = offX - 18,
			y = hVar.SCREEN.h/2 + 40,
			w = 540,
			h = 400,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		_childUI["btn_changeName"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/pan.png",
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = offX + 196,
			y = offY + 150,
			scale = 0.4,
			code = function()
				--战车
				--角色改起名字的界面
				local index = 1
				hApi.CreateModifyInputBox_Diablo(index)
			end,
		})
		
		local labSize = 24
		local btnText =  hVar.tab_string["rankboard"]
		if hVar.EnableAchievement == 1 then
			btnText = hVar.tab_string["achievement"]
			if g_Cur_Language == 3 then
				labSize = 18
			end
		end
		
		--确定按钮
		_childUI["btn_look"] = hUI.button:new({
			parent = _parent,
			--model = "misc/addition/cg.png",
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			label = {text = btnText, size = labSize, font = hVar.FONTC, x = 0, y = 4, border = 1,},
			scaleT = 0.95,
			x = offX + 6 - 52,
			y = offY - 130 - 64,
			--scale = 0.76,
			--w = 150,
			--h = 52,
			w = 200,
			h = 80,
			code = function()
				if true then
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(hVar.tab_string["not_ready"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
					return
				end
				hGlobal.event:event("HidePlayerBestInfoFrame",0)
				if hVar.EnableAchievement == 1 then
					hGlobal.event:event("LocalEvent_ShowAchievementSummaryFrm")
				else
					hGlobal.event:event("LocalEvent_Phone_ShowBillboardInfoFrm")
				end
			end,
		})
		--呼吸灯效果（白色）
		local pBlink = xlAddGroundEffect(0,-1,0,0,600/1000,0.7,0,0,255,1)
		_childUI["btn_look"].handle._nBlink = pBlink
		pBlink:getParent():removeChild(pBlink,false)
		pBlink:setScaleX(9.5)
		pBlink:setScaleY(4.5)
		pBlink:setOpacity(255)
		_childUI["btn_look"].handle._n:addChild(pBlink)

		_childUI["btn_look"].handle._n:setRotation(10)
		local tRecord =  LuaGetRandMapBestRecord(g_curPlayerName)
		--local tRecord = {
			--stage = clearStage,
			--tankID = nTankID,
			--weaponID = nWeaponId,
			--gametime = nTime,
			--rescueNum = _nRescueNum,
			--score = _nScore,
			--bestCK = nBestCK,
		--}
		local stage = tRecord.stage or 0
		local gametime = tRecord.gametime or 0
		local tankID = tRecord.tankID or 6000
		local weaponID = tRecord.weaponID or 0
		local bestCK = tRecord.bestCK or 0
		if weaponID == 0 then
			local weaponIdx = LuaGetHeroWeaponIdx(tankID)
			local tabU = hVar.tab_unit[tankID]
			local weapon_unit = tabU.weapon_unit or {} --单位武器列表
			local tWeapon = weapon_unit[weaponIdx] or {}
			weaponID = tWeapon.unitId or 0
		end
		local rescueNum = tRecord.rescueNum or 0
		
		--玩家显示名
		local rgName = g_curPlayerName
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and (playerInfo.showName) and playerInfo.showName ~= hVar.tab_string["guest"] then
			rgName = playerInfo.showName.."\n（"..g_curPlayerName.."）"
		end
		--model = "misc/totalsettlement/process_light.png",
		btnChild["lab_name"] = hUI.label:new({
			parent = btnParent,
			x = 0,
			y = 142,
			align = "MC",
			size = 24,
			border = 0,
			font = hVar.FONTC,
			text = rgName,
		})
		
		local offY = 20
		local scale = 0.46
		btnChild["Boss_bar"] = hUI.image:new({
			parent = btnParent,
			model = "misc/totalsettlement/process_light.png",
			x = 6,
			y = offY,
			scale = scale,
			--w = _nLineW,
			--h = 400,
			align = "MC",
		})

		local nY = offY + 45
		local startX = - 228
		local nOffW = math.floor(1004 / 6) * scale
		for i = 1,stage do
			local sModel = string.format("icon/hero/boss_%02d.png",i)
			btnChild["img_boss"..i] = hUI.image:new({
				parent = btnParent,
				model = sModel,
				align = "MC",
				x = startX + i * nOffW,
				y = nY,
				scale = scale * (0.9 +(i-1)*0.02),
			})
		end

		btnChild["MyTank"] = hUI.thumbImage:new({
			parent = btnParent,
			x = startX + stage * nOffW,
			y = nY - 58,
			id = tankID,
			facing = 0,
			align = "MC",
			scale = 0.32 * 1,
		})

		btnChild["MyTankWheel"] = hUI.thumbImage:new({
			parent = btnParent,
			x = startX + stage * nOffW,
			y = nY - 58,
			id = hVar.tab_unit[tankID].bind_wheel,
			facing = 0,
			align = "MC",
			scale = 0.32,
		})

		if stage > 0 then
			btnChild["MyTankWeapon"] = hUI.thumbImage:new({
				parent = btnParent,
				x = startX + stage * nOffW,
				y = nY - 58,
				id = weaponID,
				facing = 0,
				align = "MC",
				scale = 0.32,
			})
			local tabU = hVar.tab_unit[weaponID]
			if tab and type(tab.effect) == "table" and #tab.effect > 0  then
				local _frmNode  = btnChild["MyTankWeapon"]
				local _parentNode = btnChild["MyTankWeapon"].handle._n
				for i = 1,#tab.effect do
					local effect = tab.effect[i]
					local effectId = effect[1]
					local effX = effect[2] or 0
					local effY = (effect[3] or 0) + offEffectY
					local effScale = effect[4] or 1.0
					--print(effectId, cardId)
					local effModel = effectId
					if (type(effectId) == "number") then
						effModel = hVar.tab_effect[effectId].model
					end
					if effModel then
						_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
							parent = _parentNode,
							model = effModel,
							align = "MC",
							x = effX,
							y = effY,
							z = effect[4] or -1,
							scale = 1.2 * effScale,
						})
					end
				end
			end
		end

		--if gametime > 0 then
			btnChild["img_time"] = hUI.image:new({
				parent = btnParent,
				model = "",
				x = - 145,
				y = - 44,
				model = "misc/gameover/icon_time.png",
				align = "MC",
				scale = 0.5,
			})

			--通关时间文本
			local seconds = gametime
			local minute = math.floor(seconds / 60)
			local second = seconds - minute * 60
			local strTime = string.format("%d:%02d",minute,second)
			btnChild["lab_time"] = hUI.label:new({
				parent = btnParent,
				x = - 120,
				y = - 44,
				font = "numWhite",
				align = "LC",
				size = 18,
				border = 0,
				text = strTime,
			})

			btnChild["img_man"] = hUI.image:new({
				parent = btnParent,
				model = "",
				x =  15,
				y = - 44,
				model = "misc/gameover/icon_man.png",
				align = "MC",
				scale = 0.5,
			})

			btnChild["lab_man"] = hUI.label:new({
				parent = btnParent,
				x = 40,
				y = - 44,
				font = "numWhite",
				size = 18,
				align = "LC",
				text = rescueNum,
				border = 1,
			})

			btnChild["node_bestCK"] = hUI.node:new({
				parent = btnParent,
				x =  140,
				y = - 44,
			})

			btnChild["node_bestCK"].childUI["img_kill"] = hUI.image:new({
				parent = btnChild["node_bestCK"].handle._n,
				x =  0,
				y = 26,
				model = "misc/continuouskilling/kill.png",
			})

			btnChild["node_bestCK"].childUI["img_add"] = hUI.image:new({
				parent = btnChild["node_bestCK"].handle._n,
				x = - 20,
				y = - 26,
				model = "UI:CKSystemNum",
				scale = 0.8,
				animation = "ADD",
			})

			local sNum = tostring(bestCK)
			local length = #sNum
			for j = 1,length do
				local n = math.floor(bestCK / (10^(length-j)))% 10
				btnChild["node_bestCK"].childUI["lab_n"..j] = hUI.image:new({
					parent = btnChild["node_bestCK"].handle._n,
					model = "UI:CKSystemNum",
					animation = "N"..n,
					x = 45 * j * 0.8 - 10,
					y = - 26,
					scale = 0.8,
				})
			end
			btnChild["node_bestCK"].handle._n:setScale(0.4)
		--end
		_childUI["ItemBG_1"].handle._n:setRotation(6.4)

		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)

		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	OnLeaveFunc = function()
		if hGlobal.UI.PlayerBestInfoFrame then
			hGlobal.UI.PlayerBestInfoFrame:del()
			hGlobal.UI.PlayerBestInfoFrame = nil
		end
		_bCanCreate = true
		current_is_in_action = true
	end

	hGlobal.event:listen("localEvent_modify_tank_username","refreshfrm",function(result, info, name, gamecoin)
		if result == 1 and hGlobal.UI.PlayerBestInfoFrame then
			local _frm = hGlobal.UI.PlayerBestInfoFrame
			if  _frm.childUI["ItemBG_1"] then
				local btnChild = _frm.childUI["ItemBG_1"].childUI
				if btnChild and btnChild["lab_name"] then
					btnChild["lab_name"]:setText(name)
				end
			end
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
	end)

	hGlobal.event:listen("clearPlayerBestInfoFrame","clearfrm",function()
		OnLeaveFunc()
		
		--删除起名字界面
		if IputBoxFrm then
			IputBoxFrm:del()
			IputBoxFrm = nil
		end
	end)

	hGlobal.event:listen("HidePlayerBestInfoFrame","clearfrm",function(show)
		local _frm = hGlobal.UI.PlayerBestInfoFrame
		if _frm then
			_frm:show(show)
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","ShowPlayerBestInfo",function()
		local _frm = hGlobal.UI.PlayerBestInfoFrame
		if _frm and _frm.data.show == 1 then
			OnLeaveFunc()
			hGlobal.event:event("LocalEvent_ShowPlayerBestInfo")
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		--界面未打开 可创建
		if _bCanCreate then
			_bCanCreate = false
			OnCreatePlayerBestInfo()
		end
	end)
end




--武器枪查看/升级界面
hGlobal.UI.InitUpgradeWeaponFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowUpgradeWeaponFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end
	
	local _MoveW = 500
	local _bCanCreate = true
	local _frm,_parent,_childUI = nil,nil,nil
	local _weaponid = 0
	local _facing = 0
	local _boardw,_boardh = 470,600
	
	local _weaponPos = {
		[6004] = {32,-20},
		[6007] = {32,0},
	}
	
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_MoveFrmAction = hApi.DoNothing
	local _CODE_CreateWeaponImg = hApi.DoNothing
	local _CODE_CreateWeaponInfo = hApi.DoNothing
	local _CODE_CreateBtn = hApi.DoNothing
	local _CODE_CreateUpgradeMaterial = hApi.DoNothing
	local _CODE_CreateChangeSkinBtn = hApi.DoNothing
	local _CODE_ChangeSkin = hApi.DoNothing
	local _CODE_UpgradeWeapon = hApi.DoNothing
	local OnWeanponStarUpEvent = hApi.DoNothing --武器枪升星事件（升星）
	local OnWeanponLevelUpEvent = hApi.DoNothing --武器枪升级事件（升级）
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.ShowWeaponRackFrm then
			hGlobal.UI.ShowWeaponRackFrm:del()
			hGlobal.UI.ShowWeaponRackFrm = nil
		end
		hApi.clearTimer("WeaponRackAddRotateEvent")
		_frm,_parent,_childUI = nil,nil,nil
		_weaponid = 0
		_facing = 0
		
		--移除监听事件：武器枪升星事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponStarUp_Ret", "_WeaponStarUp_Upgrate", nil)
		--移除监听事件：武器枪升级事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponLevelUp_Ret", "_WeaponLevelUp_Upgrate", nil)
	end
	
	_CODE_MoveFrmAction = function(nMoveX,nDeltyTime)
		if _frm then
			local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
			local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
			local callback = CCCallFunc:create(function()
				current_is_in_action = false
				_frm:setXY(newX,nexY)
			end)
			local a = CCArray:create()
			a:addObject(moveto)
			a:addObject(callback)
			local sequence = CCSequence:create(a)
			_frm.handle._n:runAction(sequence)
		end
	end
	
	--点击升星/升级按钮
	_CODE_UpgradeWeapon = function()
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, _weaponid)
		local star = LuaGetHeroWeaponLv(hVar.MY_TANK_ID, weaponIndex) --当前星级
		local level = LuaGetHeroWeaponExp(hVar.MY_TANK_ID, weaponIndex) --当前等级
		
		local bFlag, costlist, sTag = LuaCheckHeroWeaponCanUpgrade(hVar.MY_TANK_ID,weaponIndex, 1)
		if bFlag then
			if (sTag == "starup") then --升星
				--挡操作
				hUI.NetDisable(30000)
				
				--发起请求，武器升星（升星）
				SendCmdFunc["tank_weapon_starup"](_weaponid)
				
			elseif (sTag == "levelup") then --升级
				--挡操作
				hUI.NetDisable(30000)
				
				--发起请求，武器升级（升级）
				SendCmdFunc["tank_weapon_levelup"](_weaponid)
			end
		end
	end
	
	--武器枪升星事件结果返回（升星）
	OnWeanponStarUpEvent = function(result, weaponId, star, num, level, costScore, costDebris, costRmb)
		--print("OnWeanponStarUpEvent", result, weaponId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的武器走进来
			if (weaponId == _weaponid) then
				--冒字，升星成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_STARUP_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"升星成功！"
				
				--播放出售音效
				hApi.PlaySound("itemupgrade")
				
				hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				hGlobal.event:event("clearUpgradeWeaponFrm")
				hGlobal.event:event("LocalEvent_refreshWeaponInfo")
			end
		end
	end
	
	--武器枪升级事件结果返回（升级）
	OnWeanponLevelUpEvent = function(result, weaponId, star, num, level, costScore, costDebris, costRmb)
		--print("OnWeanponLevelUpEvent", result, weaponId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的武器走进来
			if (weaponId == _weaponid) then
				--冒字，升级成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_LEVELUP_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"升级成功！"
				
				--播放出售音效
				hApi.PlaySound("level_up")
				
				hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				hGlobal.event:event("clearUpgradeWeaponFrm")
				hGlobal.event:event("LocalEvent_refreshWeaponInfo")
			end
		end
	end
	
	_CODE_CreateWeaponInfo = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		local labX = - 124 - 34
		local labstartY = -56 + 56 + 20
		local labdefH = 40 + 10
		local laboffw = 200
		
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, _weaponid)
		local star = LuaGetHeroWeaponLv(hVar.MY_TANK_ID, weaponIndex) --当前星级
		local level = LuaGetHeroWeaponExp(hVar.MY_TANK_ID, weaponIndex) --当前等级
		
		local tabU = hVar.tab_unit[_weaponid] or {}
		local attr = tabU.attr or {}
		
		--等级文字
		btnChild["lab_weapon_lv"] = hUI.label:new({
			parent = btnParent,
			x = -8,
			y = labstartY + 88,
			width = 300,
			align = "MC",
			size = 30,
			font = "numWhite",
			text = tostring(level),
			RGB = {255,255,0},
		})
		btnChild["lab_weapon_lv"].handle.s:setColor(ccc3(255, 255, 0))
		
		--[[
		--依次绘制星星的底纹
		for s = 1, hVar.WEAPON_STARUP_INFO.maxWeaponStar, 1 do
			--星级图标
			btnChild["img_weapon_star_bg".. s] = hUI.image:new({
				parent = btnParent,
				x = -62 + (s - 1) * 55,
				y = labstartY + 156,
				model = "misc/chest/star_yellow.png",
				align = "MC",
				w = 53,
				h = 52,
			})
			hApi.AddShader(btnChild["img_weapon_star_bg".. s].handle.s, "gray")
		end
		]]
		
		--绘制已获得的星级
		for s = 1, star - 1, 1 do
			--星级图标
			btnChild["img_weapon_star".. s] = hUI.image:new({
				parent = btnParent,
				x = -62 + (s - 1) * 55,
				y = labstartY + 136,
				model = "misc/chest/star_yellow.png",
				align = "MC",
				w = 53,
				h = 52,
			})
		end

		-- 差一级升星时，星星闪烁
		if level > 0 and star < hVar.WEAPON_STARUP_INFO.maxWeaponStar 
		and level == hVar.WEAPON_STARUP_INFO[star].requireLv then
			local star_idx = star
			btnChild["img_weapon_star".. star_idx] = hUI.image:new({
				parent = btnParent,
				x = -62 + (star_idx - 1) * 55,
				y = labstartY + 136,
				model = "misc/chest/star_yellow.png",
				align = "MC",
				w = 53,
				h = 52,
			})
			local act1 = CCDelayTime:create(1)
			local act2 = CCFadeOut:create(0.4)
			local act3 = CCDelayTime:create(2)
			local act4 = CCFadeIn:create(0.4)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			btnChild["img_weapon_star".. star_idx].handle.s:runAction(CCRepeatForever:create(sequence))
		end
		
		--[[
		--星级图标
		btnChild["lab_weapon_lv"] = hUI.image:new({
			parent = btnParent,
			x = labX + laboffw - 42,
			y = labstartY + 56 + 2,
			model = "misc/weekstar.png",
			align = "MC",
			w = 42,
			h = 42,
		})
		
		--星级文字
		btnChild["lab_weapon_star"] = hUI.label:new({
			parent = btnParent,
			x = labX + laboffw - 18,
			y = labstartY + 56,
			width = 300,
			height = 40,
			align = "LC",
			size = 24,
			font = "numWhite",
			text = tostring(star),
			--RGB = {255,200,50},
		})
		btnChild["lab_weapon_star"].handle.s:setColor(ccc3(255, 255, 0))
		]]
		
		--[[
		btnChild["lab_weapon_name"] = hUI.label:new({
			parent = btnParent,
			x = - 6,
			y = labstartY,
			width = 300,
			height = 40,
			align = "MC",
			size = 24,
			font = hVar.FONTC,
			text = hVar.tab_stringU[_weaponid][2],
			RGB = {255,200,50},
		})
		--]]
		
		btnChild["lab_damage"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__Attr_Hint_skill_damage"], --"杀伤"
			font = hVar.FONTC,
			align = "LC",
			x = labX,
			y = labstartY,
			size = 26,
			border = 1,
		}) 
		
		--计算攻击力
		local valueattack = (attr.attack or {})[5] or 0
		local atk_max_lvup = attr.atk_max_lvup
		local atkfont = "numWhite"
		if (type(atk_max_lvup) == "table") then
			valueattack = valueattack + (level - 1) * (atk_max_lvup[star] or 0)
			--atkfont = "numGreen"
		elseif (type(atk_max_lvup) == "number") then
			valueattack = valueattack + (level - 1) * atk_max_lvup
			--atkfont = "numGreen"
		end
		
		btnChild["lab_damageValue"] = hUI.label:new({
			parent = btnParent,
			text = valueattack,
			font = atkfont,
			align = "RC",
			x = labX + laboffw,
			y = labstartY,
			size = 22,
			border = 0,
		})
		
		--武器升星
		--geyachao:如果我的战车携带了加武器枪攻击力的道具，那么后面加绿字显示额外加的攻击力
		local atkBulletAdd = 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				--local atk = oUnit:GetAtk()
				local atk = attr.attack and attr.attack[5] or 0
				local atkBullet = oUnit:GetBulletAtk()
				atkBulletAdd = math.floor(atkBullet * atk / 100)
			end
		end
		if (atkBulletAdd > 0) then
			--额外攻击力
			btnChild["lab_damageValue2"] = hUI.label:new({
				parent = btnParent,
				text = "+" .. atkBulletAdd,
				font = "numGreen",
				align = "LC",
				x = labX + laboffw + 4,
				y = labstartY,
				size = 22,
				border = 0,
				--RGB = {0, 255, 0},
			})
		end
		
		btnChild["lab_atk_interval"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__Attr_Hint_atk_interval"], --"攻击间隔"
			font = hVar.FONTC,
			align = "LC",
			x = labX,
			y = labstartY - labdefH * 1,
			size = 26,
			border = 1,
		}) 
		
		--计算攻速
		local atk_interval = attr.atk_interval or 0
		local atk_speed_lvup = attr.atk_speed_lvup
		local atk_speedfont = "numWhite"
		if type(atk_speed_lvup) == "table" and type(atk_speed_lvup[1]) == "number" and atk_speed_lvup[1] ~= 0 then
			atk_interval = atk_interval + atk_speed_lvup[1] * level
			atk_speedfont = "numGreen"
		end
		
		btnChild["lab_atk_intervalValue"] = hUI.label:new({
			parent = btnParent,
			text = atk_interval,
			font = atk_speedfont,
			align = "RC",
			x = labX + laboffw,
			y = labstartY - labdefH * 1,
			size = 22,
			border = 1,
		})
		
		--依次遍历武器枪的暴击属性列表，如果有暴击属性大于0，展示在界面
		local crit_idx = 0
		for weapon_crit_attr, v in pairs(hVar.ItemAttrAttackCrit) do
			--print(weapon_crit_attr, v)
			local weapon_crit_attr_add = 0
			local weapon_crit_attr_value = attr[weapon_crit_attr]
			--print(weapon_crit_attr_value)
			if (type(weapon_crit_attr_value) == "table") then
				weapon_crit_attr_add = (weapon_crit_attr_value[star] or 0)
			elseif (type(weapon_crit_attr_value) == "number") then
				weapon_crit_attr_add = weapon_crit_attr_value
			end
			if (weapon_crit_attr_add > 0) then
				--索引加1
				crit_idx = crit_idx + 1
				
				--暴击属性
				btnChild["lab_ctrl" .. crit_idx] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_Hint_"..weapon_crit_attr],
					font = hVar.FONTC,
					align = "LC",
					x = labX,
					y = labstartY - labdefH*(crit_idx+1),
					size = 26,
					border = 1,
				}) 
				
				--暴击属性值
				btnChild["lab_ctrlValue" .. crit_idx] = hUI.label:new({
					parent = btnParent,
					text = weapon_crit_attr_add,
					font = "numWhite",
					align = "RC",
					x = labX + laboffw,
					y = labstartY - labdefH*(crit_idx+1),
					size = 22,
					border = 1,
				})
			end
		end
		
		--添加监听事件：武器枪升星事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponStarUp_Ret", "_WeaponStarUp_Upgrate", OnWeanponStarUpEvent)
		--添加监听事件：武器枪升级事件结果返回
		hGlobal.event:listen("LocalEvent_WeaponLevelUp_Ret", "_WeaponLevelUp_Upgrate", OnWeanponLevelUpEvent)
	end
	
	_CODE_CreateWeaponImg = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		--大菠萝获得指定武器id的索引值
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, _weaponid)
		local weaponScale = 1.6
		print("_weaponid",_weaponid)
		local weapon_offx,weapon_offy = 0,0
		if _weaponPos[_weaponid] then
			weapon_offx,weapon_offy = unpack(_weaponPos[_weaponid])
		end
		
		btnChild["Image_weapon"] = hUI.thumbImage:new({
			parent = btnParent,
			id = _weaponid,
			x = -14 + weapon_offx,
			y = 200 + weapon_offy,
			facing = 0,
			align = "MC",
			scale = weaponScale,
			--z = 1,
		})
		local tab = hVar.tab_unit[_weaponid]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_weapon"]
			local _parentNode = btnChild["Image_weapon"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_weapon"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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
					end
				end
			end
		end
		hApi.addTimerForever("WeaponRackAddRotateEvent", hVar.TIMER_MODE.PCTIME, 15, function()
			local facing = (_facing - 11.25/2) % 360
			_facing = facing
			hApi.ChaSetFacing(btnChild["Image_weapon"].handle, facing)
			btnChild["Image_weapon"].handle._n:setScale(weaponScale)
		end)
	end
	
	--武器枪升级需要的材料
	_CODE_CreateUpgradeMaterial = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, _weaponid)
		local _,costlist = LuaCheckHeroWeaponCanUpgrade(hVar.MY_TANK_ID,weaponIndex)
		
		--横线
		btnChild["img_line"] = hUI.image:new({
			parent = btnParent,
			model = "misc/title_line.png",
			x = -10,
			y = -140,
			w = 320,
			h = 4,
		})
		
		local valid_i = 0
		for i = 1,#costlist do
			valid_i = valid_i + 1
			local uix = -90
			local uiy = -170 - (valid_i - 1) * 50
			local stype,nvalue,font = unpack(costlist[i])
			
			local requireUIy = -200
			local costDebris = 0
			local _nRequireScore = 0
			local _nRequireRmb = 0
			
			if stype == "weapondebir" then
				local tabU = hVar.tab_unit[_weaponid]
				
				--当前碎片数量
				local curnum = LuaGetHeroWeaponDebrisNum(hVar.MY_TANK_ID,weaponIndex)
				
				btnChild["img_debris"] = hUI.image:new({
					parent = btnParent,
					model = tabU.icon,
					x = uix,
					y = uiy,
					w = 64,
					h = 64,
				})
				
				btnChild["img_debrisicon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/debris.png",
					x = uix + 10,
					y = uiy - 15,
					scale = 0.8,
				})
				
				--碎片进度条
				local progressV = 0
				if (nvalue > 0) then
					progressV = curnum / nvalue * 100 --进度
				end
				btnChild["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = btnParent,
					x = uix + 32 + 4,
					y = uiy - 4,
					w = 160,
					h = 28,
					align = "LC",
					back = {model = "misc/chest/jdd1.png", x = -4, y = 0, w = 160 + 7, h = 34},
					model = "misc/chest/jdt1.png",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				
				--进度条文字
				local labFontSize = 22
				local strFontText = tostring(curnum)
				if (nvalue > 0) then
					strFontText = (tostring(curnum) .. "/" .. tostring(nvalue))
				end
				--strFontText = "0000000/000" --测试 test
				--print(#strFontText)
				if (#strFontText == 9) then
					labFontSize = 20
				elseif (#strFontText == 10) then
					labFontSize = 18
				elseif (#strFontText == 11) then
					labFontSize = 16
				end
				btnChild["lab_debris"] = hUI.label:new({
					parent = btnParent,
					x = uix + 116 - 1,
					y = uiy - 2,
					width = 300,
					align = "MC",
					size = labFontSize,
					font = font,
					border = 0,
					text = strFontText,
				})
			elseif stype == "score" then
				if (nvalue > 0) then
					--积分图标
					btnChild["img_Score"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/mu_coin.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的积分值
					btnChild["lab_Score"] = hUI.label:new({
						parent = btnParent,
						x = uix + 32,
						y = uiy + 1,
						width = 300,
						align = "LC",
						size = 20,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			elseif stype == "rmb" then
				if (nvalue > 0) then
					--游戏币图标
					btnChild["img_Rmb"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/keshi.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的游戏币值
					btnChild["lab_Rmb"] = hUI.label:new({
						parent = btnParent,
						x = uix + 110,
						y = uiy - 2,
						width = 300,
						align = "MC",
						size = 24,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			end
		end
	end
	
	_CODE_CreateBtn = function()
		local iPhoneX_WIDTH = 0
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			iPhoneX_WIDTH = hVar.SCREEN.offx
		end
		local offX = hVar.SCREEN.w - _boardw/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, _weaponid)
		local star = LuaGetHeroWeaponLv(hVar.MY_TANK_ID,weaponIndex) --当前星际
		local level = LuaGetHeroWeaponExp(hVar.MY_TANK_ID, weaponIndex) --当前等级
		local curidx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID)
		local showUpgradeBtn = 1
		local btnx = offX
		if weaponIndex ~= curidx then
			_childUI["btn_replace"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				model = "misc/weaponrack_btn.png",
				x = offX - 6 + 68,
				y = offY - 306,
				scale = 1.0,
				z = 1,
				code = function(self, screenX, screenY, isInside)
					hGlobal.event:event("LocalEvent_ChangeModel_MainBase")
					_bCanCreate = true
					_CODE_ClearFunc()
				end
			})
			
			_childUI["btn_replace"].childUI["img"] = hUI.button:new({
				parent = _childUI["btn_replace"].handle._n,
				model = "misc/skillup/btnicon_change.png",
				scale = 0.7,
				y = -4,
			})
			btnx = offX - 6 - 86
		end
		
		--是否到满级
		if (level >= hVar.WEAPON_LVUP_INFO.maxWeaponLv) then
			showUpgradeBtn = 0
		end
		
		--升级按钮
		_childUI["btn_build"] = hUI.button:new({
			parent = _parent,
			x = btnx,
			y = hVar.SCREEN.h/2 - 306,
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			model = "misc/weaponrack_btn.png",
			--model = "misc/mask.png",
			scale = 1.0,
			z = 1,
			code = function(self, screenX, screenY, isInside)
				_CODE_UpgradeWeapon()
			end
		})
		if showUpgradeBtn == 0 then
			hApi.AddShader(_childUI["btn_build"].handle.s, "gray")
		end
		
		_childUI["btn_build"].childUI["img"] = hUI.button:new({
			parent = _childUI["btn_build"].handle._n,
			model = "misc/skillup/btnicon_upgrade.png",
			scale = 0.7,
			y = -4,
		})
		if showFollowBtn == 0 then
			hApi.AddShader(_childUI["btn_build"].childUI["img"].handle.s, "gray")
		end
	end
	
	_CODE_CreateChangeSkinBtn = function()
		if hVar.WEAPON_SKIN_TEMPDEFINE[_weaponid] then
			local iPhoneX_WIDTH = 0
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				iPhoneX_WIDTH = hVar.SCREEN.offx
			end
			local offX = hVar.SCREEN.w - _boardw/2 - 6 - iPhoneX_WIDTH
			local offY = hVar.SCREEN.h/2
			
			_childUI["btn_next_r"] = hUI.button:new({
				parent = _parent,
				model = "misc/chariotconfig/next_r.png",
				dragbox = _childUI["dragBox"],
				scaleT = 0.92,
				x = offX + 180,
				y = offY + 180,
				w = 63,
				h = 62,
				code = function()
					_CODE_ChangeSkin(true)
				end,
			})

			_childUI["btn_next_l"] = hUI.button:new({
				parent = _parent,
				model = "misc/chariotconfig/next_r.png",
				dragbox = _childUI["dragBox"],
				scaleT = 0.92,
				x = offX - 200,
				y = offY + 180,
				w = 63,
				h = 62,
				code = function()
					_CODE_ChangeSkin(false)
				end,
			})
			_childUI["btn_next_l"].handle.s:setFlipX(true)
		end
	end
	
	_CODE_ChangeSkin = function(isRight)
		hVar.WEAPON_SKIN_TEMPINDEX[_weaponid] = hVar.WEAPON_SKIN_TEMPINDEX[_weaponid] or 1
		local curIndex = hVar.WEAPON_SKIN_TEMPINDEX[_weaponid]
		local totalnum = #(hVar.WEAPON_SKIN_TEMPDEFINE[_weaponid])
		if isRight then
			curIndex = curIndex % totalnum + 1
		else
			curIndex = (curIndex-1) % totalnum
			if curIndex == 0 then
				curIndex = totalnum
			end
		end
		--print(hVar.WEAPON_SKIN_TEMPINDEX[_weaponid],curIndex,#hVar.WEAPON_SKIN_TEMPDEFINE[_weaponid])
		hVar.WEAPON_SKIN_TEMPINDEX[_weaponid] = curIndex
		local tabW = hVar.tab_unit[_weaponid]
		local tempdefine = hVar.WEAPON_SKIN_TEMPDEFINE[_weaponid][curIndex]
		if tempdefine.model then
			tabW.model = tempdefine.model
		end
		if tempdefine.effect then
			tabW.effect = tempdefine.effect
		end
		hApi.safeRemoveT(_childUI["ItemBG_1"].childUI,"Image_weapon")
		_CODE_CreateWeaponImg()
		
		local curWeaponIdx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID)
		local tabU = hVar.tab_unit[hVar.MY_TANK_ID]
		if tabU.weapon_unit and tabU.weapon_unit[curWeaponIdx] then
			local tWeaponInfo = tabU.weapon_unit[curWeaponIdx]
			local curWeaponId = tWeaponInfo.unitId
			print(curWeaponId,_weaponid)
			if curWeaponId == _weaponid then
				hGlobal.event:event("LocalEvent_ChangeModel_MainBase",true)
			end
		end
	end
	
	--创建武器枪界面
	_CODE_CreateFrm = function()
		if hGlobal.UI.ShowWeaponRackFrm then
			hGlobal.UI.ShowWeaponRackFrm:del()
			hGlobal.UI.ShowWeaponRackFrm = nil
		end
		hGlobal.UI.ShowWeaponRackFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.ShowWeaponRackFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local iPhoneX_WIDTH = 0
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			iPhoneX_WIDTH = hVar.SCREEN.offx
		end
		
		local offX = hVar.SCREEN.w - _boardw/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		--用于点击背景关闭的按钮
		_childUI["ItemBG_Close"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				hGlobal.event:event("clearUpgradeWeaponFrm")
			end,
		})
		_childUI["ItemBG_Close"].handle.s:setOpacity(0)
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = _boardw,
			h = _boardh,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		_childUI["ItemBG_1"].handle.s:setOpacity(0)

		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n	
		
		btnChild["rack"] = hUI.image:new({
			parent = btnParent,
			model = "misc/weaponrack.png",
			x = 0,
			y = 0,
			scale = 0.96,
		})
		
		_CODE_CreateWeaponImg()
		_CODE_CreateWeaponInfo()
		_CODE_CreateUpgradeMaterial()
		_CODE_CreateBtn()
		_CODE_CreateChangeSkinBtn()
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		_CODE_MoveFrmAction(-_MoveW,0.5)
	end
	
	hGlobal.event:listen("clearUpgradeWeaponFrm","clearfrm",function()
		_bCanCreate = true
		_CODE_ClearFunc()
	end)
	
	hGlobal.event:listen("LocalEvent_SpinScreen","showWeaponRackFrm",function()
		_bCanCreate = true
		_CODE_ClearFunc()
	end)
	
	--"LocalEvent_ShowUpgradeWeaponFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(weaponid)
		--界面未打开 可创建
		if _bCanCreate then
			_bCanCreate = false
			_CODE_ClearFunc()
			_weaponid = weaponid
			_CODE_CreateFrm()
		end
	end)
end
--[[
--测试 --test
--删除上次的界面
if hGlobal.UI.ShowWeaponRackFrm then
	hGlobal.UI.ShowWeaponRackFrm:del()
	hGlobal.UI.ShowWeaponRackFrm = nil
end
hGlobal.UI.InitUpgradeWeaponFrm("include") --武器枪界面
hGlobal.event:event("LocalEvent_ShowUpgradeWeaponFrm", 6004)
-- ]]





--战术卡升级界面
hGlobal.UI.InitUpgradeTacticsFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowUpgradeTacticsFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 600
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true
	
	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end
	
	local _unitId = 0
	local _tacticsId = 0
	local _tIconPos = {
		["missles"] = {0.7,0,0,-6,0},
		["fire"] = {0.6,5,0,-30,0},
		["fireline"] = {0.9,0,0,-2,0},
		["shield"] = {0.7,-10,0,-30,0},
		["time"] = {0.7,-10,0,-30,0},
		["range"] = {0.7,-24,-3,-40,0},
		["gun"] = {0.8,0,0,-10,0},
		["ddta"] = {0.8,-10,0,-30,0},
		["bounce"] = {0.8,-4,0,-20,0},
		["hole"] = {0.9,0,0,-16,0},
		["dmg"] = {0.9,-18,0,-46,0},
	}
	
	local OnMoveFrmAction = hApi.DoNothing
	local OnCreateUpgradeTacticsFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnTacticLevelUpEvent = hApi.DoNothing --战术卡升级事件结果返回
	
	OnLeaveFunc = function()
		if hGlobal.UI.UpgradeTacticsFrm then
			hGlobal.UI.UpgradeTacticsFrm:del()
			hGlobal.UI.UpgradeTacticsFrm = nil
		end
		_unitId = 0
		_tacticsId = 0
		_bCanCreate = true
		current_is_in_action = true
		
		--移除监听事件：战术卡升级事件结果返回
		hGlobal.event:listen("LocalEvent_TacticLevelUp_Ret", "_TacticLevelUp", nil)
	end
	
	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.UpgradeTacticsFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	OnCreateUpgradeTacticsFrm = function()
		if hGlobal.UI.UpgradeTacticsFrm then
			hGlobal.UI.UpgradeTacticsFrm:del()
			hGlobal.UI.UpgradeTacticsFrm = nil
		end
		hGlobal.UI.UpgradeTacticsFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		local _frm = hGlobal.UI.UpgradeTacticsFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - 580/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		--用于点击背景关闭的按钮
		_childUI["ItemBG_Close"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				hGlobal.event:event("clearUpgradeTacticsFrm")
			end,
		})
		_childUI["ItemBG_Close"].handle.s:setOpacity(0)
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			--model = "misc/skillup/msgbox4.png",
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 580,
			h = 600,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		btnChild["img_machine"] = hUI.image:new({
			parent = btnParent,
			model = "misc/tactics_machine.png",
		})
		
		--[[
		--分割线1
		btnChild["SkillSeparateLine1"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY + 40,
			x = 0,
			y = 42 - 10,
			w = 420,
			h = 8,
		})
		
		--分割线2
		btnChild["SkillSeparateLine2"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY - 60,
			x = 0,
			y = - 60 - 10,
			w = 420,
			h = 8,
		})
		--]]
		
		local towerLv = 1
		local costDebris = 0 --需要的碎片数量
		local nowDebris = 0 --当前的碎片数量
		local costScore = 0 --需要的积分
		local nowScore = LuaGetPlayerScore() --当前的积分
		local costRmb = 0
		local nowRmb = LuaGetPlayerRmb() --当前的游戏币
		--local itemId = 0 --商品道具id
		local tacticInfo = LuaGetPlayerTacticById(_tacticsId)
		if tacticInfo then
			local id, lv, num = unpack(tacticInfo)
			nowDebris = num --当前的碎片数量
			towerLv = math.max(lv,1)
		end
		--table_print(tacticInfo)
		
		towerLv = math.min(towerLv,hVar.TACTIC_LVUP_INFO.maxTacticLv)
		
		local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
		costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
		local shopItemId = tacticLvUpInfo.shopItemId or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			costScore = tabShopItem.score or 0 --需要的积分
			--itemId = tabShopItem.itemID or 0 --商品道具id
			costRmb = tabShopItem.rmb or 0 --需要的氪石
		end
		
		--战术卡图片
		--btnChild["Image_tactics"] = hUI.thumbImage:new({
			--parent = btnParent,
			--id = _unitId,
			--x = 16 - 160,
			--y = 114,
			--scale = 1,
			----z = 1,
		--})
		
		--等级
		btnChild["lab_lv"] = hUI.label:new({
			parent = btnParent,
			align = "MC",
			size = 32,
			font = "num",
			border = 0,
			--text = "lv"..(math.min(towerLv+1,hVar.TACTIC_LVUP_INFO.maxTacticLv)),
			text = towerLv,
			x = 0,
			--y = 64,
			y = -186,
		})
		
		local tInfo = hVar.TacticsUpgradeInfo
		local nlv = math.min(towerLv+1,hVar.TACTIC_LVUP_INFO.maxTacticLv)
		local shownum = 0
		local nInfoOffY = -30
		local offy = 166 + 60
		if type(tInfo[_tacticsId]) == "table" and type(tInfo[_tacticsId][nlv]) == "table" then
			shownum = #tInfo[_tacticsId][nlv]
			for i = 1,#tInfo[_tacticsId][nlv] do
				if type(tInfo[_tacticsId][nlv][i]) == "table" then
					local sIcon,stext = unpack(tInfo[_tacticsId][nlv][i])
					local str = ""
					local length = string.len((stext or ""))
					if string.sub(stext,length,length) == "s" then
						str = string.sub(stext,1,length - 1).. hVar.tab_string["second"]
					else
						str = stext
					end
					local scale,iconoffx,iconoffy,stroffx,stroffy = 1,0,0,0,0
					if _tIconPos[sIcon] then
						scale,iconoffx,iconoffy,stroffx,stroffy = unpack(_tIconPos[sIcon])
					end
					if sIcon == "dmg_old" then
						local tempx = -46 + iconoffx
						local tempy = offy - 60 * (i - 1) + nInfoOffY
						local tempoffy = 40
						if g_Cur_Language == 3 then
							tempoffy = 72
						end
						btnChild["lab_icon"..i] = hUI.label:new({
							parent = btnParent,
							align = "MC",
							size = 26,
							font = hVar.FONTC,
							border = 1,
							text = hVar.tab_string["damage"],
							--text = hVar.tab_string["__TEXT_Player_DeleteAll"],
							x = tempx,
							y = tempy,
							RGB = {255,200,50},
						})

						btnChild["lab_info"..i] = hUI.label:new({
							parent = btnParent,
							align = "LC",
							size = 26,
							font = hVar.FONTC,
							border = 1,
							text = str,
							x = tempx + tempoffy,
							y = tempy,
							RGB = {255,200,50},
						})
					else
						local iconName = hVar.TacticsDescribeIcon[sIcon] or ""
						btnChild["img_icon"..i] = hUI.image:new({
							parent = btnParent,
							align = "MC",
							model = iconName,
							x = -30 + iconoffx,
							y = offy - 60 * (i - 1) + nInfoOffY + iconoffy,
							scale = scale,
						})

						btnChild["lab_info"..i] = hUI.label:new({
							parent = btnParent,
							align = "LC",
							size = 26,
							font = hVar.FONTC,
							border = 1,
							text = str,
							x = 42 + stroffx,
							y = offy - 60 * (i - 1) + nInfoOffY + stroffy,
							RGB = {255,200,50},
						})
					end
				end
			end
		end
		
		--btnChild["lab_info"] = hUI.label:new({
			--parent = btnParent,
			--align = "MC",
			--size = 24,
			--font = hVar.FONTC,
			--border = 1,
			--text = hVar.tab_stringT[_tacticsId][(math.min(towerLv+1,hVar.TACTIC_LVUP_INFO.maxTacticLv))],
			----text = hVar.tab_string["__TEXT_Player_DeleteAll"],
			--x = 60,
			--y = 108,
			--width = 280,
			--height= 96,
			--RGB = {255,200,50},
		--})
		
		local debrisoffY = 80
		local debrisoffx = -90
		local debrisoffh = 90 --氪石偏移y
		local tacticoffh = -30 --战术卡偏移y
		--if shownum > 1 then
			--debrisoffY = - 20
		--end
		
		--towerLv = hVar.TACTIC_LVUP_INFO.maxTacticLv
		if towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv then
			--横线
			btnChild["img_line"] = hUI.image:new({
				parent = btnParent,
				model = "misc/title_line.png",
				x = 0,
				y = debrisoffY,
				w = 280,
				h = 4,
			})
			
			local canUpgrade = 1
			
			local debrisFont = "num"
			if nowDebris < costDebris then
				debrisFont = "numRed"
				canUpgrade = 0
			end
			
			--战术卡图标
			btnChild["Image_debris"] = hUI.thumbImage:new({
				parent = btnParent,
				id = _unitId,
				x = debrisoffx,
				y = debrisoffY - 10 + tacticoffh,
				w = 64 * 0.9,
				h = 64 * 0.9,
				--z = 1,
			})
			
			--碎片图标
			btnChild["img_debrisicon"] = hUI.image:new({
				parent = btnParent,
				model = "misc/debris.png",
				x = debrisoffx + 10,
				y = debrisoffY - 10 + tacticoffh - 15,
				scale = 0.8,
			})
			
			--碎片进度条
			local progressV = 0
			if (costDebris > 0) then
				progressV = nowDebris / costDebris * 100 --进度
			end
			btnChild["rightBarSoulStoneExp"] = hUI.valbar:new({
				parent = btnParent,
				x = debrisoffx + 32 + 4,
				y = debrisoffY - 10 + tacticoffh - 4,
				w = 160,
				h = 28,
				align = "LC",
				back = {model = "misc/chest/jdd1.png", x = -4, y = 0, w = 160 + 7, h = 34},
				model = "misc/chest/jdt1.png",
				--model = "misc/progress.png",
				v = progressV,
				max = 100,
			})
			
			--进度条文字
			local labFontSize = 22
			local strFontText = tostring(nowDebris)
			if (costDebris > 0) then
				strFontText = (tostring(nowDebris) .. "/" .. tostring(costDebris))
			end
			--strFontText = "0000000/000" --测试 test
			--print(#strFontText)
			if (#strFontText == 9) then
				labFontSize = 20
			elseif (#strFontText == 10) then
				labFontSize = 18
			elseif (#strFontText == 11) then
				labFontSize = 16
			end
			btnChild["lab_debris"] = hUI.label:new({
				parent = btnParent,
				x = debrisoffx + 116 - 1,
				y = debrisoffY - 10 + tacticoffh - 2,
				width = 300,
				align = "MC",
				size = labFontSize,
				font = "numWhite",
				border = 0,
				text = strFontText,
			})
			
			--氪石图标
			btnChild["img_rmb"] = hUI.image:new({
				parent = btnParent,
				model = "misc/skillup/keshi.png",
				--x = offX - 54,
				--y = offY - 11,
				x = debrisoffx - 5 + 60,
				y = -12 - debrisoffh + debrisoffY,
				w = 42,
				h = 42,
			})
			
			local rmbFont = "num"
			if nowRmb < costRmb then
				rmbFont = "numRed"
				canUpgrade = 0
			end
			
			--需要的积分值
			btnChild["lab_rmb"] = hUI.label:new({
				parent = btnParent,
				--x = offX + 36,
				--y = offY - 11 - 1,
				x = debrisoffx + 30 + 60,
				y = -12 - debrisoffh + debrisoffY - 2,
				width = 300,
				align = "LC",
				size = 24,
				font = rmbFont,
				border = 0,
				text = costRmb,
			})
			
			--不需要氪石
			if (costRmb == 0) then
				btnChild["img_rmb"].handle._n:setVisible(false)
				btnChild["lab_rmb"].handle._n:setVisible(false)
			end
			
			_childUI["btn_upgrade"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				--label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				x = offX,
				y = offY - 262,
				w = 160,
				h = 70,
				--w = 124,
				--h = 52,
				code = function()
					--print("btn_unlock")
					--在动画中禁止点击
					if current_is_in_action then
						return
					end
					
					local towerLv = 1
					local costScore = 0 --需要的积分
					local costRmb = 0 --需要的氪石
					local tacticInfo = LuaGetPlayerTacticById(_tacticsId)
					if tacticInfo then
						local id, lv, num = unpack(tacticInfo)
						towerLv = lv
					end
					
					if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
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
						
						return
					end
					
					local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
					local shopItemId = tacticLvUpInfo.shopItemId or 0
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					if tabShopItem then
						costScore = tabShopItem.score or 0 --需要的积分
						--itemId = tabShopItem.itemID or 0 --商品道具id
						costRmb = tabShopItem.rmb or 0 --需要的氪石
					end
					
					--local nowScore = LuaGetPlayerScore()
					
					--if nowScore < costScore and costScore > 0 then
						--hApi.NotEnoughResource("coin")
						--return
					--end
					
					--todo 后续要走订单 扣游戏币
					local nowRmb = LuaGetPlayerRmb() --当前的游戏币
					if nowRmb < costRmb and costRmb > 0 then
						hApi.NotEnoughResource("keshi")
						return
					end
					
					local tacticInfo = LuaGetPlayerTacticById(_tacticsId)
					local curDebris = 0
					if tacticInfo then
						local id, lv, num = unpack(tacticInfo)
						curDebris = num --当前的碎片数量
					end
					if curDebris < costDebris then
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
						return
					end
					
					--[[
					local retex = LuaLvUpPlayerTactic(_tacticsId)
					--print("retex=", retex)
					if (retex == 1) then
						--扣除积分
						--LuaAddPlayerScore(-costScore)
						LuaAddPlayerScoreByWay(-costScore,hVar.GET_SCORE_WAY.UPGRADEITEMTACTICS)
						hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
						LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
						hGlobal.event:event("LocalEvent_refreshTacticsInfo")

						local keyList = {"skill","material"}
						LuaSavePlayerData_Android_Upload(keyList, "升级战术卡")

						OnLeaveFunc()
					end
					]]
					
					--通过校验，可以升级
					--挡操作
					hUI.NetDisable(30000)
					
					--发起请求，战术卡升级
					local tacticId = _tacticsId
					SendCmdFunc["tank_tactic_levelup"](tacticId)
				end,
			})
			
			_childUI["btn_upgrade"].childUI["img"] = hUI.button:new({
				parent = _childUI["btn_upgrade"].handle._n,
				model = "misc/skillup/btnicon_upgrade.png",
				scale = 0.8,
			})
			
			if canUpgrade == 0 then
				hApi.AddShader(_childUI["btn_upgrade"].handle.s, "gray")
			else
				hApi.AddShader(_childUI["btn_upgrade"].handle.s, "normal")
			end
		else
			--最高等级
			btnChild["lab_maxlv"] = hUI.label:new({
				parent = btnParent,
				--x = offX + 36,
				--y = offY - 11 - 1,
				x = 0,
				y = -256,
				align = "MC",
				size = 28,
				font = hVar.FONTC,
				height = 32,
				border = 0,
				text = hVar.tab_string["max_lv"],
			})
		end
		
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW, 0.5)
		
		--添加监听事件：战术卡升级事件结果返回
		hGlobal.event:listen("LocalEvent_TacticLevelUp_Ret", "_TacticLevelUp", OnTacticLevelUpEvent)
	end
	
	--战术卡升级事件结果返回
	OnTacticLevelUpEvent = function(result, tacticId, level, num, costScore, costDebris, costRmb)
		print("OnTacticLevelUpEvent", result, tacticId, level, num, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的战术卡走进来
			if (_tacticsId == tacticId) then
				--冒字，升级成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_LEVELUP_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"升级成功！"
				
				--播放出售音效
				hApi.PlaySound("itemupgrade")

				hGlobal.event:event("LocalEvent_refreshTacticsInfo")
				
				--关闭本界面
				OnLeaveFunc()
			end
		end
	end
	
	hGlobal.event:listen("clearUpgradeTacticsFrm","clearfrm",function()
		OnLeaveFunc()
	end)
	
	hGlobal.event:listen("LocalEvent_SpinScreen","UpgradeTacticsFrm",function()
		OnLeaveFunc()
	end)
	
	--"LocalEvent_ShowUpgradeTacticsFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(unitId,itemId)
		if _bCanCreate then
			local tabI = hVar.tab_item[itemId]
			if tabI and tabI.tacticId then
				print("tabI.tacticsId",tabI.tacticId)
				local tabT = hVar.tab_tactics[tabI.tacticId]
				if tabT then
					_unitId = unitId
					_tacticsId = tabI.tacticId
					_bCanCreate = false
					OnCreateUpgradeTacticsFrm()
				end
			end
		end
	end)
end
--[[
--测试 --test
--删除上次的界面
if hGlobal.UI.UpgradeTacticsFrm then
	hGlobal.UI.UpgradeTacticsFrm:del()
	hGlobal.UI.UpgradeTacticsFrm = nil
end
hGlobal.UI.InitUpgradeTacticsFrm("include") --武器枪界面
hGlobal.event:event("LocalEvent_ShowUpgradeTacticsFrm", 11025, 12022)
--SendCmdFunc["tank_sync_tactic_info"]()
]]





hGlobal.UI.InitDailyRewardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowDailyRewardFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 500
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local OnMoveFrmAction = hApi.DoNothing
	local OnCreateDailyRewardFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing

	OnLeaveFunc = function()
		if hGlobal.UI.DailyRewardFrm then
			hGlobal.UI.DailyRewardFrm:del()
			hGlobal.UI.DailyRewardFrm = nil
		end
		_bCanCreate = true
		current_is_in_action = true
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.DailyRewardFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	--战车昨日排名奖励领奖界面
	OnCreateDailyRewardFrm = function()
		if hGlobal.UI.DailyRewardFrm then
			hGlobal.UI.DailyRewardFrm:del()
			hGlobal.UI.DailyRewardFrm = nil
		end
		hGlobal.UI.DailyRewardFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		local _frm = hGlobal.UI.DailyRewardFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - 480/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 480,
			h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		--分割线1
		btnChild["SkillSeparateLine1"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY + 40,
			x = 0,
			y = 42,
			w = 420,
			h = 8,
		})
		
		--分割线2
		btnChild["SkillSeparateLine2"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY - 60,
			x = 0,
			y = - 60,
			w = 420,
			h = 8,
		})
		
		--标题
		btnChild["lab_title"] = hUI.label:new({
			parent = btnParent,
			align = "MC",
			font = hVar.FONTC,
			size = 32,
			width = 240,
			height = 36,
			border = 0,
			text = hVar.tab_string["supply_drop"],
			x = 0,
			--y = 64,
			y = 106,
		})
		
		--积分图标
		btnChild["img_Score"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/mu_coin.png",
			--x = offX - 54,
			--y = offY - 11,
			x = -54,
			y = -10,
			w = 42,
			h = 42,
		})
		
		--需要的积分值
		btnChild["lab_Score"] = hUI.label:new({
			parent = btnParent,
			--x = offX + 36,
			--y = offY - 11 - 1,
			x = -54 + 50,
			y = -9,
			width = 300,
			align = "LC",
			size = 24,
			border = 0,
			font = "numWhite",
			--text = g_DailyRewardScore,
			text = 0,
		})
		
		--领取按钮
		_childUI["btn_yes"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["get"],size = 28,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = offX,
			y = offY - 116,
			scale = 0.74,
			--w = 124,
			--h = 52,
			code = function()
				print("btn_unlock")
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--今日奖励未领
				if (LuaGetPlayerGiftstate(1) ~= 1) then
					hUI.NetDisable(10000)
					
					--发起请求，领取战车排名奖励
					SendCmdFunc["reward_yesterday_rank"]()
					--Gift_Function["reward_1"]()
				end
			end,
		})
		
		--_childUI["btn_yes"] = hUI.button:new({
			--parent = _parent,
			--model = "misc/skillup/btn_yes.png",
			--dragbox = _childUI["dragBox"],
			--scaleT = 0.95,
			--x = offX,
			--y = offY - 116,
			----w = 124,
			----h = 52,
			--code = function()
				--print("btn_unlock")
				----在动画中禁止点击
				--if current_is_in_action then
					--return
				--end
				
				--if LuaGetPlayerGiftstate(1) ~= 1 then
					--hUI.NetDisable(10000)
					--Gift_Function["reward_1"]()
				--end
			--end,
		--})
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		--根据昨日排名，显示对应的积分
		local rank = LuaGetTankYesterdayRank() --战车昨日排名名次
		local score = 0
		for i = 1, #hVar.TANK_BILLBOARD_REWARD, 1 do
			local tReward = hVar.TANK_BILLBOARD_REWARD[i]
			if (rank >= tReward.from) and (rank <= tReward.to) then
				score = tReward.score
				break
			end
		end
		btnChild["lab_Score"]:setText(score)
		
		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	hGlobal.event:listen("clearDailyRewardFrm","clearfrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		if _bCanCreate and g_DailyRewardScore then
			_bCanCreate = false
			OnCreateDailyRewardFrm()
		end
	end)
end

hGlobal.UI.InitCommentRewardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowCommentRewardFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 500
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local OnMoveFrmAction = hApi.DoNothing
	local OnCreateCommentRewardFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing

	OnLeaveFunc = function()
		if hGlobal.UI.CommentRewardFrm then
			hGlobal.UI.CommentRewardFrm:del()
			hGlobal.UI.CommentRewardFrm = nil
		end
		current_is_in_action = true
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.CommentRewardFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	OnCreateCommentRewardFrm = function()
		if hGlobal.UI.CommentRewardFrm then
			hGlobal.UI.CommentRewardFrm:del()
			hGlobal.UI.CommentRewardFrm = nil
		end
		hGlobal.UI.CommentRewardFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.CommentRewardFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 480,
			h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + 240 - 38,
			y = offY + 180 - 38,
			scaleT = 0.9,
			z = 2,
			code = function()
				OnLeaveFunc()
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		local titleY = 72
		local btnY = -76
		if LuaGetPlayerGiftstate(3) == 0 then
			titleY = 106
			btnY = -116
			--分割线1
			btnChild["SkillSeparateLine1"] = hUI.image:new({
				parent = btnParent,
				model = "misc/skillup/line.png",
				--x = offX,
				--y = offY + 40,
				x = 0,
				y = 42,
				w = 420,
				h = 8,
			})
			
			--分割线2
			btnChild["SkillSeparateLine2"] = hUI.image:new({
				parent = btnParent,
				model = "misc/skillup/line.png",
				--x = offX,
				--y = offY - 60,
				x = 0,
				y = - 60,
				w = 420,
				h = 8,
			})

			--积分图标
			btnChild["img_Score"] = hUI.image:new({
				parent = btnParent,
				model = "misc/skillup/mu_coin.png",
				--x = offX - 54,
				--y = offY - 11,
				x = -54,
				y = -10,
				w = 42,
				h = 42,
			})

			--需要的积分值
			btnChild["lab_Score"] = hUI.label:new({
				parent = btnParent,
				--x = offX + 36,
				--y = offY - 11 - 1,
				x = -54 + 50,
				y = -9,
				width = 300,
				align = "LC",
				size = 24,
				border = 0,
				font = "numWhite",
				text = 500,
			})
		end
		
		--标题
		btnChild["lab_title"] = hUI.label:new({
			parent = btnParent,
			align = "MC",
			size = 32,
			font = hVar.FONTC,
			border = 0,
			text = hVar.tab_string["rate_game"],
			width = 320,
			x = 0,
			--y = 64,  
			y = titleY,
		})
		
		_childUI["btn_yes"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["to_rate"],size = 32,y= 4,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY + btnY,
			--w = 124,
			--h = 52,
			code = function(self)
				print("btn_unlock")
				--在动画中禁止点击
				if current_is_in_action then
					return
				end

				xlOpenUrl("https://www.taptap.com/app/177559")
				
				self:setstate(-1)
				Gift_Function["reward_3"]()
				hGlobal.event:event("clearCommentRewardFrm")
			end,
		})

		--_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		current_is_in_action = false

		_frm:show(1)
		_frm:active()
		--OnMoveFrmAction(-_MoveW,0.5)
	end

	hGlobal.event:listen("clearCommentRewardFrm","clearfrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		OnCreateCommentRewardFrm()
	end)
end

hGlobal.UI.InitPurchaseGiftFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowPurchaseGiftFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local WIDTH = 560
	local HEIGHT = 480

	local DELTAH = 78
	local YOFFSET = 20

	local _MoveW = 500
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true

	local _nCurrentSelectIndex = 0
	local _nGiftNum = 0
	local _nIapType = 0
	local _nRewardOffX = 0
	local _nGiftList = {}
	local _tRemoveUIList = {}

	local _tUIList = {}

	local _bCanCreate = true
	local _bClickPurchase = false
	local _bCanPurchase = false
	local _bHaveCreateUI = false

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local OnMoveFrmAction = hApi.DoNothing
	local OnInitIapList = hApi.DoNothing
	local OnCreateGiftInfo = hApi.DoNothing
	local OnPurchaseGift = hApi.DoNothing
	local OnReceiveGiftList = hApi.DoNothing
	local OnCreatePurchaseGiftFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnPurchaseGiftBack = hApi.DoNothing
	local OnCreateSellOutImage = hApi.DoNothing
	local OnSaveGiftInfo = hApi.DoNothing
	local OnIapList_Back = hApi.DoNothing
	local OnGetPurchaseState = hApi.DoNothing
	local OnCreateDefaultInfo = hApi.DoNothing
	local OnCreateUI = hApi.DoNothing
	local OnCreateImage = hApi.DoNothing
	local OnClearUI = hApi.DoNothing

	--获取礼包状态
	OnGetPurchaseState = function(productId)
		local canPurchase = false
		local tInfo
		local tIapList = xlLuaEvent_GetIapList()
		if type(tIapList) == "table" then
			--if sProductId ~= "" and 
			for i = 1, #tIapList, 1 do
				local listI = tIapList[i] --第i项
				if (listI) and listI.productId == productId then
					canPurchase = true
					tInfo = listI
					break
				end
			end
		end
		return canPurchase,tInfo
	end

	--获取充值数据的回调
	OnIapList_Back = function()
		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			if hGlobal.UI.PurchaseGiftFrm then
				--界面创建完  但是依然显示不能购买时
				if _bCanPurchase == false and _bHaveCreateUI and _nGiftList[_nCurrentSelectIndex] then
					local sProductId = _nGiftList[_nCurrentSelectIndex].sProductId or ""	--充值条目

					local canPurchase,tInfo = OnGetPurchaseState(sProductId)
					if canPurchase then
						_bCanPurchase = true
						local text = tInfo.productPriceDesc or "------"
						local _frm = hGlobal.UI.PurchaseGiftFrm
						local _childUI = _frm.childUI
						if _childUI and _childUI["btn_yes"] then
							_childUI["btn_yes"]:setText(text)
							hApi.AddShader(_childUI["btn_yes"].handle.s, "normal")
						end
					end
				end
			end
		end
	end

	OnLeaveFunc = function()
		hGlobal.event:listen("GetPurchaseGiftList","_getlist",nil)
		hGlobal.event:listen("localEvent_LimitTimeGiftOrderRet","_purchasegift",nil)
		hGlobal.event:listen("LocalEvent_OnIapList_Back", "PurchaseGift", nil)
		if hGlobal.UI.PurchaseGiftFrm then
			hGlobal.UI.PurchaseGiftFrm:del()
			hGlobal.UI.PurchaseGiftFrm = nil
		end
		current_is_in_action = true
		_nGiftNum = 0
		_nGiftList = {}
		_nCurrentSelectIndex = 0
		_nIapType = 0
		_bCanCreate = true
		_bClickPurchase = false
		_bCanPurchase = false
		_bHaveCreateUI = false
		_tRemoveUIList = {}
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	OnCreatePurchaseGiftFrm = function()
		if hGlobal.UI.PurchaseGiftFrm then
			hGlobal.UI.PurchaseGiftFrm:del()
			hGlobal.UI.PurchaseGiftFrm = nil
		end
		hGlobal.UI.PurchaseGiftFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		if g_Cur_Language == 1 then
			WIDTH = 600
			HEIGHT = 580
			DELTAH = 108
			YOFFSET = 44
		else
			WIDTH = 560
			HEIGHT = 480
			DELTAH = 78
			YOFFSET = 20
		end

		local offX = hVar.SCREEN.w - WIDTH/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = WIDTH,
			h = HEIGHT,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n

		btnChild["lab_title"] = hUI.label:new({
			parent = btnParent,
			--x = offX + 36,
			--y = offY - 11 - 1,
			x = 0,
			y = HEIGHT/2 - 65,
			align = "MC",
			size = 32,
			border = 0,
			font = hVar.FONTC,
			text = "",
			RGB = {255,200,50},
		})

		_childUI["btn_yes"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = "",size = 32,y= 2,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY - HEIGHT/2 + 85,
			--w = 124,
			--h = 52,
			code = function(self)
				print("btn_unlock")
				--在动画中禁止点击
				if current_is_in_action then
					return
				end

				local iChannelId = xlGetChannelId()
				if iChannelId < 100 then
					OnPurchaseGift()
				else
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(hVar.tab_string["AndroidTestTip"], hVar.FONTC, 32, "MC", 0, 0,nil,1)
				end
			end,
		})
		hApi.AddShader(_childUI["btn_yes"].handle.s, "gray")
		--_childUI["btn_yes"]:setstate(0)

		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		current_is_in_action = false

		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	OnPurchaseGift = function()
		if _bCanPurchase then
			local i = _nCurrentSelectIndex
			local iGiftId = _nGiftList[i].iGiftId or 0
			local iGiftMoney = _nGiftList[i].iGiftMoney or 0
			local iCount = _nGiftList[i].iCount or 0 --已购买次数
			if iCount == 0 then
				local _frm = hGlobal.UI.PurchaseGiftFrm
				local _parent = _frm.handle._n
				local _childUI = _frm.childUI
				--_childUI["btn_yes"]:setstate(0)
				hApi.AddShader(_childUI["btn_yes"].handle.s, "gray")
				local iChannelId = xlGetChannelId()
				--一屏蔽操作
				hUI.NetDisable(30000)
				if iChannelId < 100 then
					SendCmdFunc["iap_sale_gift_order_ios"](_nIapType, iGiftId)
				else
					SendCmdFunc["iap_sale_gift_order"](_nIapType, iGiftId)
				end
				--_bClickPurchase = true
				_bCanPurchase = false
			end
		end
	end

	local createWeaponImage = function(index,id)
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local btnChild = _childUI["btn_reward"..index].childUI
		local btnParent = _childUI["btn_reward"..index].handle._n

		local _nWeaponId = id
		btnChild["Image_weapon"] = hUI.thumbImage:new({
			parent = btnParent,
			id = _nWeaponId,
			x = - 124,
			y = -28,
			scale = 0.7,
			--z = 1,
		})
		local tab = hVar.tab_unit[_nWeaponId]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_weapon"]
			local _parentNode = btnChild["Image_weapon"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_weapon"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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

	local createTankImage = function(index,id,scale)
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local btnChild = _childUI["btn_reward"..index].childUI
		local btnParent = _childUI["btn_reward"..index].handle._n

		local tankID = id
		btnChild["MyTank"] = hUI.thumbImage:new({
			parent = btnParent,
			x = - 124,
			--y = 36,
			y = 0,
			id = tankID,
			facing = 0,
			align = "MC",
			scale = scale,
		})

		btnChild["MyTankWheel"] = hUI.thumbImage:new({
			parent = btnParent,
			x = - 124,
			--y = 36,
			y = 0,
			id = hVar.tab_unit[tankID].bind_wheel,
			facing = 0,
			align = "MC",
			scale = scale,
		})
	end

	local createThumbImage = function(index,id,scale)
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local btnChild = _childUI["btn_reward"..index].childUI
		local btnParent = _childUI["btn_reward"..index].handle._n

		btnChild["img_unit"] = hUI.thumbImage:new({
			parent = btnParent,
			x = - 124,
			--y = 36,
			y = 0,
			id = id,
			facing = 0,
			align = "MC",
			scale = scale,
		})
	end

	OnCreateImage = function(index,stype,id,scale,x,y)
		if stype == "weapon" then
			createWeaponImage(index,id,scale)
		elseif stype == "tank" then
			createTankImage(index,id,scale)
		elseif stype == "thumbImage" then
			createThumbImage(index,id,scale)
		else
			
		end
	end

	OnCreateUI = function()
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		for i = 1,#_tUIList do
			local stype,id,scale,sLabNum,sText1,sText2 = unpack(_tUIList[i])

			local _frm = hGlobal.UI.PurchaseGiftFrm
			local _parent = _frm.handle._n
			local _childUI = _frm.childUI

			local offX = hVar.SCREEN.w - WIDTH/2 - 6 - iPhoneX_WIDTH
			local offY = hVar.SCREEN.h/2

			local xoffset = 0
			local yoffset = YOFFSET

			_childUI["btn_reward"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				--model = "",
				x = offX + _nRewardOffX,
				y = offY + yoffset + (math.ceil(#_tUIList / 2) - i) * DELTAH,   --1 -1  2 0  3 1   i - 2 
			})
			_tRemoveUIList[#_tRemoveUIList+1] = {_childUI,"btn_reward"..i}

			OnCreateImage(i,stype,id,scale)

			local btnChild = _childUI["btn_reward"..i].childUI
			local btnParent = _childUI["btn_reward"..i].handle._n

			btnChild["lab_num"] = hUI.label:new({
				parent = btnParent,
				--x = offX + 36,
				--y = offY - 11 - 1,
				x = -70,
				y = 0,
				align = "LC",
				size = 24,
				border = 0,
				font = hVar.FONTC,
				font = "num",
				text = sLabNum,
			})

			btnChild["lab_content1"] = hUI.label:new({
				parent = btnParent,
				--x = offX + 36,
				--y = offY - 11 - 1,
				x = 24,
				--y = 40,
				y = 2,
				align = "LC",
				size = 24,
				border = 0,
				width = 300,
				height = 26,
				font = hVar.FONTC,
				--font = "num",
				text = sText1,
			})

			if g_Cur_Language == 1 then
				btnChild["lab_content2"] = hUI.label:new({
					parent = btnParent,
					--x = offX + 36,
					--y = offY - 11 - 1,
					x = -124 - 16,
					--y = 40,
					y = -40,
					align = "LC",
					size = 20,
					border = 0,
					width = 500,
					height = 26,
					font = hVar.FONTC,
					--font = "num",
					text = sText2,
				})
			end
		end
	end

	OnCreateGiftInfo = function()
		local i = _nCurrentSelectIndex
		if i <= _nGiftNum then
			local iGiftId = _nGiftList[i].iGiftId or 0
			local iGiftMoney = _nGiftList[i].iGiftMoney or 0
			local iCount = _nGiftList[i].iCount or 0 --已购买次数
			local szGiftInfo = _nGiftList[i].szGiftInfo or "" --礼包描述信息
			local szGiftPrize = _nGiftList[i].szGiftPrize or "" --奖励表
			local sProductId = _nGiftList[i].sProductId or ""	--充值条目
			local sCfg = "local tmp = {" .. szGiftPrize .. "} return tmp"
			local tGiftPrizeList = assert(loadstring(sCfg))()
			local first_buy = tGiftPrizeList.first_buy --首次充值的奖励列表
			local reward = {}

			--reward[#reward+1] = {"s",1000,0,0}

			local _frm = hGlobal.UI.PurchaseGiftFrm
			local _parent = _frm.handle._n
			local _childUI = _frm.childUI


			local btnChild = _childUI["ItemBG_1"].childUI
			local btnParent = _childUI["ItemBG_1"].handle._n
			--btnChild["lab_title"]:setText(szGiftInfo)
			
			if iCount == 0 then
				local iChannelId = xlGetChannelId()
				if iChannelId < 100 then
					local canPurchase,tInfo = OnGetPurchaseState(sProductId)
					if canPurchase then
						_bCanPurchase = true
						local text = tInfo.productPriceDesc or "------"
						_childUI["btn_yes"]:setText(text)
						hApi.AddShader(_childUI["btn_yes"].handle.s, "normal")
					end
				else
					_bCanPurchase = true
					_childUI["btn_yes"]:setText(string.format(hVar.tab_string["cmd_40105"],iGiftMoney))
					--_childUI["btn_yes"]:setstate(1)
					hApi.AddShader(_childUI["btn_yes"].handle.s, "normal")
				end
			else
				OnCreateSellOutImage()
				
			end

			_bHaveCreateUI = true
		end
	end

	OnCreateSellOutImage = function()
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		_childUI["btn_yes"]:setText("")
		--_childUI["btn_yes"]:setstate(0)
		hApi.AddShader(_childUI["btn_yes"].handle.s, "gray")

		if _childUI["btn_yes"].childUI["ok"] == nil then
			_childUI["btn_yes"].childUI["ok"] = hUI.image:new({
				parent = _childUI["btn_yes"].handle._n,
				model = "misc/ok.png",
				--x = -40,
				--y = -5,
				--w = 42,
				--h = 42,
			})
			_tRemoveUIList[#_tRemoveUIList+1] = {_childUI["btn_yes"].childUI,"ok"}
		end
				--
	end

	OnCreateDefaultInfo = function()
		_nCurrentSelectIndex = 3
		local _frm = hGlobal.UI.PurchaseGiftFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		btnChild["lab_title"]:setText(hVar.tab_string["premium_supply"])
		for j = 1,#hVar.PurchaseGiftRelatedInfo do
			local tInfo = hVar.PurchaseGiftRelatedInfo[j]
			if type(tInfo) == "table" and tInfo.nGiftIndex ==  _nCurrentSelectIndex then
				if LuaGetPlayerGiftInfo(j) > 0 then
					OnCreateSellOutImage()
				end
			end
		end
		_childUI["btn_yes"]:setText("------")

		OnCreateUI()
	end

	OnClearUI = function()
		for i = 1,#_tRemoveUIList do
			local childUI,uiname = unpack(_tRemoveUIList[i])
			hApi.safeRemoveT(childUI,uiname)
		end
		_tRemoveUIList = {}
	end

	--获得礼包列表
	OnReceiveGiftList = function(iErrCode, iIapType, iUid, iRid, iItemNum, list)
		print("OnReceiveGiftList",iErrCode, iIapType, iUid, iRid, iItemNum, list)
		--table_print(list)
		if (iErrCode == 0) then --0:成功
			--找到1元档商品
			--for i = 1, iItemNum, 1 do
			_nGiftNum = iItemNum
			_nGiftList = list
			_nIapType = iIapType
			_nCurrentSelectIndex = 3
			OnSaveGiftInfo()
			OnCreateGiftInfo()
			--OnCreateSellOutImage()
		else
			
			--end
		end
	end

	OnInitIapList = function()
		local iChannelId = xlGetChannelId()
		local tIapList = xlLuaEvent_GetIapList()
		if iChannelId < 100 and tIapList == nil then
			local current_iType = 0
			if xlRequestIapList then
				if xlGetIapType then
					current_iType = xlGetIapType() --读取支付类型
					
					--默认是用苹果支付
					if (current_iType == 0) then
						current_iType = 1
					end
				end
				xlRequestIapList(current_iType)
			end
			
		end
	end

	OnSaveGiftInfo = function()
		local i = _nCurrentSelectIndex
		if i <= _nGiftNum then
			local iGiftId = _nGiftList[i].iGiftId or 0
			local iGiftMoney = _nGiftList[i].iGiftMoney or 0
			local iCount = _nGiftList[i].iCount or 0 --已购买次数
			--if iCount > 0 then
			for j = 1,#hVar.PurchaseGiftRelatedInfo do
				local tInfo = hVar.PurchaseGiftRelatedInfo[j]
				if type(tInfo) == "table" and tInfo.nGiftIndex ==  _nCurrentSelectIndex then
					--存储礼包信息 j
					LuaSetPlayerGiftInfo(j,iCount)
				end
			end

			hGlobal.event:event("LocalEvent_refreshPurchaseGiftInfo")
			--end
		end
	end

	OnPurchaseGiftBack = function(result)
		--if _bClickPurchase then
		if result == 1 then
			--获取邮箱  从邮箱中
			SendCmdFunc["get_prize_list"]()
			--记录购买次数
			if _nGiftList[_nCurrentSelectIndex] then
				_nGiftList[_nCurrentSelectIndex].iCount = _nGiftList[_nCurrentSelectIndex].iCount + 1
			end
		end
		--end
		OnCreateSellOutImage()
		--OnLeaveFunc()
		OnSaveGiftInfo()
	end

	hGlobal.event:listen("clearPurchaseGiftFrm","clearfrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		if _bCanCreate then
			_tUIList = {
				{"weapon",6006,0.7,"x 1",hVar.tab_stringU[6006][2],hVar.tab_string["gift3_1"]},
				{"tank",6000,0.44,"x 1",hVar.tab_string["rebirth_for_free"],hVar.tab_string["gift3_2"]},
				{"thumbImage",11107,0.8,"x 1",hVar.tab_string["unlock_petarea"],hVar.tab_string["gift3_3"]},
			}
			if g_Cur_Language == 3 then
				_nRewardOffX = - 50
			elseif g_Cur_Language == 1 then
				_nRewardOffX = - 60
			else
				_nRewardOffX = 0
			end
			_bCanCreate = false
			hGlobal.event:listen("GetPurchaseGiftList","_getlist",OnReceiveGiftList)
			hGlobal.event:listen("localEvent_LimitTimeGiftOrderRet","_purchasegift",OnPurchaseGiftBack)
			hGlobal.event:listen("LocalEvent_OnIapList_Back", "PurchaseGift", OnIapList_Back)
			--请求苹果列表
			OnInitIapList()
			--创建基础界面
			OnCreatePurchaseGiftFrm()
			
			OnCreateDefaultInfo()
			SendCmdFunc["iap_sale_gift"]()
		end
	end)
end

hGlobal.UI.InitPlainTextFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowPlainTextFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 500
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local OnMoveFrmAction = hApi.DoNothing
	local OnCreatePlainTextFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing

	OnLeaveFunc = function()
		if hGlobal.UI.PlainTextFrm then
			hGlobal.UI.PlainTextFrm:del()
			hGlobal.UI.PlainTextFrm = nil
		end
		_bCanCreate = true
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.PlainTextFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	OnCreatePlainTextFrm = function(tIconData,tTextData)
		if hGlobal.UI.PlainTextFrm then
			hGlobal.UI.PlainTextFrm:del()
			hGlobal.UI.PlainTextFrm = nil
		end
		hGlobal.UI.PlainTextFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 2, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.PlainTextFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local offX = hVar.SCREEN.w - 480/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 480,
			h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		if tIconData.thumbImageId then
			_childUI["img_icon"] = hUI.thumbImage:new({
				parent = _parent,
				id = tIconData.thumbImageId,
				x = offX + (tIconData.x or 0),
				y = offY + (tIconData.y or 0),
				facing = tIconData.facing,
				scale = tIconData.scale,
			})
		else
			_childUI["img_icon"] = hUI.image:new({
				parent = _parent,
				model = tIconData.icon or "",
				x = offX + (tIconData.x or 0),
				y = offY + (tIconData.y or 0),
				scale = tIconData.scale,
			})
		end

		_childUI["lab_text"] = hUI.label:new({
			parent = _parent,
			x = offX + (tTextData.x or 0),
			--x = offX + 50 - 480/2,
			y = offY + (tTextData.y or 0),--16
			--align = "LT",
			align = tTextData.align or "MT",
			size = tTextData.size or 28,
			border = tTextData.border or 1,
			width = tTextData.width,--480 - 50 * 2,
			height =  tTextData.height,--140
			font = tTextData.font or hVar.FONTC,
			text = tTextData.text or "",
		})

		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)

		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	hGlobal.event:listen("clearPlainTextFrm","clearfrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","PlainTextFrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tIconData,tTextData)
		if _bCanCreate and type(tIconData) == "table" and type(tTextData) == "table" then
			_bCanCreate = false
			OnCreatePlainTextFrm(tIconData,tTextData)
		end
	end)
end

hGlobal.UI.InitGuideControlFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowGuideControlFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local OnCreateGuideControlFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local boardW,boardH = 744,660

	OnLeaveFunc = function()
		if hGlobal.UI.GuideControlFrm then
			hGlobal.UI.GuideControlFrm:del()
			hGlobal.UI.GuideControlFrm = nil
		end
		--hGlobal.event:event("Event_StartPauseSwitch", false)
	end

	OnCreateGuideControlFrm = function()
		if hGlobal.UI.GuideControlFrm then
			hGlobal.UI.GuideControlFrm:del()
			hGlobal.UI.GuideControlFrm = nil
		end
		hGlobal.UI.GuideControlFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 2, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.GuideControlFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2

		local picture = "misc/guidepicture/controlguide.png"
		if g_Cur_Language == 3 then
			picture = "misc/guidepicture/controlguide_en.png"
		end

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = picture,
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			--w = 480,
			--h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--[[
		_childUI["btn_ok"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["ok"],size = 32,y= 4,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY - 250,
			--scale = 0.95,
			code = function(self)
				OnLeaveFunc()
				hApi.SetTouchEnable_Diablo(1)
			end,
		})
		]]
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + boardW/2 - 38,
			y = offY + boardH/2 - 38,
			scaleT = 0.95,
			z = 2,
			code = function()
				OnLeaveFunc()
				hApi.SetTouchEnable_Diablo(1)
			end,
		})
		
		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		OnCreateGuideControlFrm()
		--hGlobal.event:event("Event_StartPauseSwitch", true)
	end)
end



--宠物解锁界面
hGlobal.UI.InitUnlockPetTip = function(mode)
	local tInitEventName = {"LocalEvent_ShowUnlockPetTip","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end
	
	local _MoveW = 600
	local _nUnitId = 0
	local _nPetIdx = 0
	local _tPetInfo = {}
	local _nRequireScore = 0
	local _nRequireRmb = 0
	local _tRequireDebris = nil
	local _nPetId = 0
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true
	
	local boardW,boardH = 640,600
	
	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end
	
	local noReadyPet = {}
	local _tPetOff = {
		[13042] = {0,-8,},
		[13043] = {0,-16,},
	}
	
	local OnCreateUnlockPetTip = hApi.DoNothing
	local UnlockPetFunc = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnMoveFrmAction = hApi.DoNothing
	local OnCreatePetInfo = hApi.DoNothing
	local OnPetStarUpEvent = hApi.DoNothing --宠物升星事件结果返回（解锁）
	
	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.UnlockPetTipFrame
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	OnCreateUnlockPetTip = function()
		print("LocalEvent_ShowUnlockPetTip")
		if hGlobal.UI.UnlockPetTipFrame then
			hGlobal.UI.UnlockPetTipFrame:del()
			hGlobal.UI.UnlockPetTipFrame = nil
		end
		
		local tabU = hVar.tab_unit[_nUnitId]
		if type(tabU) ~= "table" then
			return		--该单位不存在
		end
		
		--local requireIcon = ""
		--获取数据
		if tabU.pet_unit and tabU.pet_unit[_nPetIdx] then
			_tPetInfo = tabU.pet_unit[_nPetIdx]
			_nPetId = _tPetInfo.unitId
			_tRequireDebris = _tPetInfo.requireDebris
		else
			return		--该战车没有武器
		end
		
		--宠物解锁界面
		hGlobal.UI.UnlockPetTipFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		_frm = hGlobal.UI.UnlockPetTipFrame
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - boardW/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
			offX = hVar.SCREEN.w - boardW/2 - 6
		end
		
		--用于点击背景关闭的按钮
		_childUI["ItemBG_Close"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2 + 20,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				hGlobal.event:event("clearUnlockPetTip")
			end,
		})
		_childUI["ItemBG_Close"].handle.s:setOpacity(0)
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/addition/pet_panel.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2 + 20,
			w = boardW,
			h = boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n

		_childUI["btn_comment"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/commentbtn.png",
			dragbox = _childUI["dragBox"],
			scale = 0.8,
			scaleT = 0.8,
			x = offX - 128,
			y = offY + 196,
			code = function()
				hGlobal.event:event("LocalEvent_DoCommentProcess",{_nPetId})
			end,
		})
		
		--[[
		btnChild["lab_pet_name"] = hUI.label:new({
			parent = btnParent,
			x = 0,
			y = 70,
			width = 300,
			height = 40,
			align = "MC",
			size = 24,
			--font = "num",
			font = hVar.FONTC,
			--border = 0,
			text = hVar.tab_stringU[_nPetId][2],
			RGB = {255,200,50},
		})
		--]]
		
		local petOffX,petOffY = 0,0
		if type(_tPetOff[_nPetId]) == "table" then
			petOffX,petOffY = unpack(_tPetOff[_nPetId])
		end
		
		local _,costlist = LuaCheckHeroPetCanUpgrade(_nUnitId, _nPetIdx)
		
		btnChild["Image_pet"] = hUI.thumbImage:new({
			parent = btnParent,
			id = _nPetId,
			facing = 305,
			x = 0 + petOffX,
			y = 150 + petOffY,
			scale = 1.4,
			--z = 1,
		})
		local tab = hVar.tab_unit[_nPetId]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_pet"]
			local _parentNode = btnChild["Image_pet"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_pet"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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
		
		--横线
		btnChild["img_line"] = hUI.image:new({
			parent = btnParent,
			model = "misc/title_line.png",
			x = 30,
			y = -90,
			w = 320,
			h = 4,
		})
		
		local valid_i = 0
		for i = 1,#costlist do
			valid_i = valid_i + 1
			local uix = -90+30
			local uiy = -120 - (valid_i - 1) * 50
			local stype,nvalue,font = unpack(costlist[i])
			
			if stype == "petdebir" then				
				--当前碎片数量
				local curnum = LuaGetHeroPetDebrisNum(_nUnitId, _nPetIdx)
				local nDebrisId  = _tRequireDebris[1]
				local nDebrisNum = _tRequireDebris[2]
				local debris = hVar.tab_item[nDebrisId]
				btnChild["img_debris"] = hUI.image:new({
					parent = btnParent,
					model = debris.icon,
					x = uix,
					y = uiy,
					w = 64,
					h = 64,
				})
				
				btnChild["img_debrisicon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/debris.png",
					x = uix + 10,
					y = uiy - 15,
					scale = 0.8,
				})
				
				--碎片进度条
				local progressV = 0
				if (nvalue > 0) then
					progressV = curnum / nvalue * 100 --进度
				end
				btnChild["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = btnParent,
					x = uix + 32 + 4,
					y = uiy - 4,
					w = 160,
					h = 28,
					align = "LC",
					back = {model = "misc/chest/jdd1.png", x = -4, y = 0, w = 160 + 7, h = 34},
					model = "misc/chest/jdt1.png",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				
				--进度条文字
				local labFontSize = 22
				local strFontText = tostring(curnum)
				if (nvalue > 0) then
					strFontText = (tostring(curnum) .. "/" .. tostring(nvalue))
				end
				--strFontText = "0000000/000" --测试 test
				--print(#strFontText)
				if (#strFontText == 9) then
					labFontSize = 20
				elseif (#strFontText == 10) then
					labFontSize = 18
				elseif (#strFontText == 11) then
					labFontSize = 16
				end
				btnChild["lab_debris"] = hUI.label:new({
					parent = btnParent,
					x = uix + 116 - 1,
					y = uiy - 2,
					width = 300,
					align = "MC",
					size = labFontSize,
					font = font,
					border = 0,
					text = strFontText,
				})
			elseif stype == "score" then
				if (nvalue > 0) then
					--积分图标
					btnChild["img_Score"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/mu_coin.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的积分值
					btnChild["lab_Score"] = hUI.label:new({
						parent = btnParent,
						x = uix + 32,
						y = uiy + 1,
						width = 300,
						align = "LC",
						size = 20,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			elseif stype == "rmb" then
				if (nvalue > 0) then
					--游戏币图标
					btnChild["img_Rmb"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/keshi.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的游戏币值
					btnChild["lab_Rmb"] = hUI.label:new({
						parent = btnParent,
						x = uix + 110,
						y = uiy - 2,
						width = 300,
						align = "MC",
						size = 24,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			end
		end
		
		local text = hVar.tab_string["unlock"]
		_childUI["btn_unlock"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/pettalk_btn.png",
			--model = "misc/mask.png",
			--label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = offX,
			y = offY - 258,
			code = function()
				print("btn_unlock")
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				UnlockPetFunc()
			end,
		})
		
		_childUI["btn_unlock"].childUI["img"] = hUI.button:new({
			parent = _childUI["btn_unlock"].handle._n,
			model = "misc/skillup/btnicon_unlock.png",
			scale = 0.9,
		})
		
		OnCreatePetInfo()
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end
	
	--宠物属性界面（解锁）
	OnCreatePetInfo = function()
		local tabU = hVar.tab_unit[_nUnitId] or {}
		if tabU.pet_unit and type(tabU.pet_unit[_nPetIdx]) then
			local summonUnit = tabU.pet_unit[_nPetIdx].summonUnit
			local tabPet = hVar.tab_unit[summonUnit]
			if tabPet then
				local btnChild = _childUI["ItemBG_1"].childUI
				local btnParent = _childUI["ItemBG_1"].handle._n
				local atk = tabPet.attr.attack[5]
				local hp = tabPet.attr.hp
				local atktype = "近战"
				local income = 0 --挂机收益
				if tabPet.attr.attack[3] > 100 then
					atktype = "远程"
				end
				
				local labx = -boardW/2 + 190
				local laby = 96
				local labdeltaX = 280
				local labdeltaY = -42
				
				btnChild["lab_hp"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__ATTR__hp_max"], --"生命"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 0,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_hpValue"] = hUI.label:new({
					parent = btnParent,
					text = hp,
					font = "numWhite",
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 0,
					size = 22,
				})
				
				btnChild["lab_atk"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_Hint_skill_damage"], --"杀伤"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 1,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_atkValue"] = hUI.label:new({
					parent = btnParent,
					text = atk,
					font = "numWhite",
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 1,
					size = 22,
				})
				
				btnChild["lab_atktype"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_AttackType"], --"攻击方式"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 2,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_atktypeValue"] = hUI.label:new({
					parent = btnParent,
					text = atktype,
					font = hVar.FONTC,
					align = "RC",
					x = labx + labdeltaX,
					y = laby + labdeltaY * 2,
					size = 26,
					border = 1,
				}) 
				
				btnChild["lab_income"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_On-hook_proceeds"], --"挂机收益"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 3,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_incomeValue"] = hUI.label:new({
					parent = btnParent,
					text = income,
					font = "numWhite",
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 3,
					size = 22,
				}) 
			end
			
			--添加监听事件：宠物升星事件结果返回（解锁）
			hGlobal.event:listen("LocalEvent_PetStarUp_Ret", "_PetStarUp_Unlock", OnPetStarUpEvent)
		end
	end
	
	--点击解锁按钮
	UnlockPetFunc = function()
		local bFlag = LuaCheckHeroPetCanUpgrade(_nUnitId, _nPetIdx, 1)
		if bFlag then
			--挡操作
			hUI.NetDisable(30000)
			
			--发起请求，宠物升星（解锁）
			local petId = _nPetId
			SendCmdFunc["tank_pet_starup"](petId)
		end
	end
	
	--宠物升星事件结果返回（解锁）
	OnPetStarUpEvent = function(result, petId, star, num, level, costScore, costDebris, costRmb)
		--print("OnPetStarUpEvent", result, petId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_nPetId == petId) then
				--冒字，解锁成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_UNLOCK_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"解锁成功！"
				
				--播放出售音效
				hApi.PlaySound("itemupgrade")

				hGlobal.event:event("LocalEvent_refreshPetInfo")
				
				--关闭本界面
				OnLeaveFunc()
			end
		end
	end
	
	OnLeaveFunc = function()
		if hGlobal.UI.UnlockPetTipFrame then
			hGlobal.UI.UnlockPetTipFrame:del()
			hGlobal.UI.UnlockPetTipFrame = nil
		end
		_nUnitId = 0
		_nPetIdx = 0
		_tPetInfo = {}
		_tRequireDebris = nil
		_nRequireScore = 0
		_nRequireRmb = 0
		_nPetId = 0
		_bCanCreate = true
		current_is_in_action = true
		
		--移除监听事件：宠物升星事件结果返回（解锁）
		hGlobal.event:listen("LocalEvent_PetStarUp_Ret", "_PetStarUp_Unlock", nil)
	end
	
	hGlobal.event:listen("clearUnlockPetTip","clearfrm",function()
		OnLeaveFunc()
	end)
	
	hGlobal.event:listen("LocalEvent_SpinScreen","UnlockPetTip",function()
		OnLeaveFunc()
	end)
	
	--"LocalEvent_ShowUnlockPetTip"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nUnitId,nPetId)
		--界面未打开 可创建
		if _bCanCreate then
			_bCanCreate = false
			_nUnitId = nUnitId
			_nPetId = nPetId
			_nPetIdx = LuaGetHeroPetIndexById(nUnitId,nPetId)
			OnCreateUnlockPetTip()
		end
	end)
end
--[[
--测试 --test
--删除上次的界面
if hGlobal.UI.UnlockPetTipFrame then
	hGlobal.UI.UnlockPetTipFrame:del()
	hGlobal.UI.UnlockPetTipFrame = nil
end
hGlobal.UI.InitUnlockPetTip("include") --武器枪解锁界面
hGlobal.event:event("LocalEvent_ShowUnlockPetTip", 6000, 13041)
]]




--已废弃？
--hGlobal.UI.InitPetInfoFrm = function(mode)
--	local tInitEventName = {"LocalEvent_ShowPetInfoFrm","ShowFrm"}
--	if mode ~= "include" then
--		return tInitEventName
--	end
--
--	local _nUnitId = 0
--	local _nPetIdx = 0
--	local _nPetId = 0
--
--	local boardW,boardH = 480,400
--	local _frm,_parent,_childUI = nil,nil,nil
--
--	if g_phone_mode == 4 then
--		iPhoneX_WIDTH = hVar.SCREEN.offx
--	end
--
--	local _tPetOff = {
--		[13042] = {0,-8,},
--		[13043] = {0,-16,},
--	}
--
--	local OnCreateFrm = hApi.DoNothing
--	local OnLeaveFunc = hApi.DoNothing
--	local OnCreatePetInfo = hApi.DoNothing
--
--	OnCreateFrm = function()
--		print("LocalEvent_ShowPetInfoFrame")	
--		hGlobal.UI.PetInfoFrame = hUI.frame:new({
--			x = 0,
--			y = 0,
--			w = hVar.SCREEN.w,
--			h = hVar.SCREEN.h,
--			z = hZorder.MainBaseFirstFrm,
--			show = 0,
--			--dragable = 2,
--			dragable = 3, --点击后消失
--			buttononly = 1,
--			autoactive = 0,
--			--background = "UI:PANEL_INFO_MINI",
--			failcall = 1, --出按钮区域抬起也会响应事件
--			background = -1, --无底图
--			border = 0, --无边框
--		})
--
--		_frm = hGlobal.UI.PetInfoFrame
--		_parent = _frm.handle._n
--		_childUI = _frm.childUI
--
--		local offX = hVar.SCREEN.w/2
--		local offY = hVar.SCREEN.h/2
--
--		--创建技能tip图片背景
--		_childUI["ItemBG_1"] = hUI.button:new({
--			parent = _parent,
--			--model = "UI_frm:slot",
--			--animation = "normal",
--			model = "misc/skillup/msgbox4.png",
--			dragbox = _childUI["dragBox"],
--			x = offX,
--			y = hVar.SCREEN.h/2,
--			w = boardW,
--			h = boardH,
--			code = function()
--				--print("技能tip图片背景")
--			end,
--		})
--
--		_childUI["closeBtn"] = hUI.button:new({
--			parent = _parent,
--			dragbox = _childUI["dragBox"],
--			model = "misc/skillup/btn_close.png",
--			x = offX + boardW/2 - 38,
--			y = offY + boardH/2 - 38,
--			scaleT = 0.9,
--			z = 2,
--			code = function()
--				OnLeaveFunc()
--				hGlobal.event:event("clearUnlockPetTip")
--			end,
--		})
--
--		local btnChild = _childUI["ItemBG_1"].childUI
--		local btnParent = _childUI["ItemBG_1"].handle._n
--
--		local petOffX,petOffY = 0,0
--		if type(_tPetOff[_nPetId]) == "table" then
--			petOffX,petOffY = unpack(_tPetOff[_nPetId])
--		end
--
--		btnChild["Image_pet"] = hUI.thumbImage:new({
--			parent = btnParent,
--			id = _nPetId,
--			facing = 270,
--			x = 0 + petOffX,
--			y = 90 + petOffY,
--			scale = 1,
--			--z = 1,
--		})
--		local tab = hVar.tab_unit[_nPetId]
--		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
--			local _frmNode  = btnChild["Image_pet"]
--			local _parentNode = btnChild["Image_pet"].handle._n
--			local offEffectY = 0 
--			if tab.model == nil then
--				btnChild["Image_pet"].handle.s:setOpacity(0)
--				offEffectY = 20
--			end
--			for i = 1,#tab.effect do
--				local effect = tab.effect[i]
--				local effectId = effect[1]
--				local effX = effect[2] or 0
--				local effY = (effect[3] or 0) + offEffectY
--				local effScale = effect[4] or 1.0
--				--print(effectId, cardId)
--				local effModel = effectId
--				if (type(effectId) == "number") then
--					effModel = hVar.tab_effect[effectId].model
--				end
--				if effModel then
--					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
--						parent = _parentNode,
--						model = effModel,
--						align = "MC",
--						x = effX,
--						y = effY,
--						z = effect[4] or -1,
--						scale = 1.2 * effScale,
--					})
--					
--					local tabM = hApi.GetModelByName(effModel)
--					if tabM then
--						local tRelease = {}
--						local path = tabM.image
--						tRelease[path] = 1
--						hResource.model:releasePlist(tRelease)
--						
--						--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
--						--[[
--						local pngPath = "data/image/"..(tabM.image)
--						local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
--						--print("释放特效")
--						--print("pngPath=", pngPath)
--						--print("texture = ", texture)
--						
--						if texture then
--							CCTextureCache:sharedTextureCache():removeTexture(texture)
--						end
--						]]
--					end
--				end
--			end
--		end
--
--		OnCreatePetInfo()
--
--		_frm:show(1)
--		_frm:active()
--	end
--
--	OnCreatePetInfo = function()
--		local tabU = hVar.tab_unit[_nUnitId] or {}
--		if tabU.pet_unit and type(tabU.pet_unit[_nPetIdx]) then
--			local summonUnit = tabU.pet_unit[_nPetIdx].summonUnit
--			local tabPet = hVar.tab_unit[summonUnit]
--			if tabPet then
--				local btnChild = _childUI["ItemBG_1"].childUI
--				local btnParent = _childUI["ItemBG_1"].handle._n
--				local atk = tabPet.attr.attack[5]
--				local hp = tabPet.attr.hp
--				local atktype = "近战"
--				local income = 1000
--				if tabPet.attr.attack[3] > 100 then
--					atktype = "远程"
--				end
--
--				local labx = -boardW/2 + 100
--				local labdeltaX = 160
--				local laby = 20
--				local labdeltaY = -50
--
--				btnChild["lab_atk"] = hUI.label:new({
--					parent = btnParent,
--					text = "伤害",
--					font = hVar.FONTC,
--					align = "LC",
--					x = labx,
--					y = laby,
--					size = 22,
--					border = 1,
--				})
--
--				btnChild["lab_atkValue"] = hUI.label:new({
--					parent = btnParent,
--					text = atk,
--					font = "numWhite",
--					align = "LC",
--					x = labx + labdeltaX,
--					y = laby - 2,
--					size = 18,
--				})
--
--				btnChild["lab_hp"] = hUI.label:new({
--					parent = btnParent,
--					text = "血量",
--					font = hVar.FONTC,
--					align = "LC",
--					x = labx,
--					y = laby + labdeltaY * 1,
--					size = 22,
--					border = 1,
--				})
--
--				btnChild["lab_hpValue"] = hUI.label:new({
--					parent = btnParent,
--					text = hp,
--					font = "numWhite",
--					align = "LC",
--					x = labx + labdeltaX,
--					y = laby - 2 + labdeltaY * 1,
--					size = 18,
--				}) 
--
--				btnChild["lab_atktype"] = hUI.label:new({
--					parent = btnParent,
--					text = "攻击方式",
--					font = hVar.FONTC,
--					align = "LC",
--					x = labx,
--					y = laby + labdeltaY * 2,
--					size = 22,
--					border = 1,
--				})
--
--				btnChild["lab_atktypeValue"] = hUI.label:new({
--					parent = btnParent,
--					text = atktype,
--					font = hVar.FONTC,
--					align = "LC",
--					x = labx + labdeltaX,
--					y = laby + labdeltaY * 2,
--					size = 22,
--					border = 1,
--				}) 
--
--				btnChild["lab_income"] = hUI.label:new({
--					parent = btnParent,
--					text = "挂机收益",
--					font = hVar.FONTC,
--					align = "LC",
--					x = labx,
--					y = laby + labdeltaY * 3,
--					size = 22,
--					border = 1,
--				})
--
--				btnChild["lab_incomeValue"] = hUI.label:new({
--					parent = btnParent,
--					text = income,
--					font = "numWhite",
--					align = "LC",
--					x = labx + labdeltaX,
--					y = laby - 2 + labdeltaY * 3,
--					size = 18,
--				}) 
--			end
--		end
--	end
--
--	OnLeaveFunc = function()
--		if hGlobal.UI.PetInfoFrame then
--			hGlobal.UI.PetInfoFrame:del()
--			hGlobal.UI.PetInfoFrame = nil
--		end
--		_nUnitId = 0
--		_nPetIdx = 0
--		_nPetId = 0
--		_frm,_parent,_childUI = nil,nil,nil
--	end
--
--	hGlobal.event:listen("LocalEvent_SpinScreen","PetInfoFrm",function()
--		hGlobal.event:event("LocalEvent_ShowPetInfoFrm",_nUnitId,_nPetId)
--	end)
--
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nUnitId,nPetId)
--		--界面未打开 可创建
--		OnLeaveFunc()
--		_nUnitId = nUnitId
--		_nPetId = nPetId
--		_nPetIdx = LuaGetHeroPetIndexById(nUnitId,nPetId)
--		OnCreateFrm()
--	end)
--end




--宠物查看/升级界面
hGlobal.UI.InitUpgradePetsFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowUpgradePetsFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end
	
	local _MoveW = 600
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true
	
	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end
	
	local _unitId = 0
	local _petId = 0
	local _petIdx = 0
	local boardW,boardH = 640,600
	local _tPetOff = {
		[13042] = {0,-8,},
		[13043] = {0,-16,},
	}
	
	local _frm,_parent,_childUI = nil,nil,nil
	
	local OnMoveFrmAction = hApi.DoNothing
	local OnCreateUpgradePetsFrm = hApi.DoNothing
	local OnCreateUpgradeRequire = hApi.DoNothing
	local OnCreateUpgradePetData = hApi.DoNothing
	local OnCreatePetSendFrm = hApi.DoNothing --宠物挖矿界面
	local OnCreatePetInfo = hApi.DoNothing
	local OnCreatePetImg = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnClickBtn = hApi.DoNothing
	local OnClickSendWaKuangBtn = hApi.DoNothing --点击派遣挖矿按钮
	local OnClickSendWaTiLiBtn = hApi.DoNothing --点击派遣挖体力按钮
	local OnClickCancelWaKuangBtn = hApi.DoNothing --点击取消挖体力按钮
	local OnClickCancelWaTiLiBtn = hApi.DoNothing --点击取消挖体力按钮
	local OnClickFollowBtn = hApi.DoNothing --宠物跟随
	local OnClickCancelFollowBtn = hApi.DoNothing --宠物取消跟随
	local OnPetStarUpEvent = hApi.DoNothing --宠物升星事件结果返回（升星）
	local OnPetLevelUpEvent = hApi.DoNothing --宠物升级事件结果返回（升级）
	local OnPetSendWaKuangEvent = hApi.DoNothing --派遣宠物挖矿结果返回
	local OnPetSendWaTiLiEvent = hApi.DoNothing --派遣宠物挖体力结果返回
	local OnPetCancelWaKuangEvent = hApi.DoNothing --取消宠物挖矿结果返回
	local OnPetCancelWaTiLiEvent = hApi.DoNothing --取消宠物挖体力结果返回
	
	OnLeaveFunc = function()
		if hGlobal.UI.UpgradePetsFrm then
			hGlobal.UI.UpgradePetsFrm:del()
			hGlobal.UI.UpgradePetsFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_unitId = 0
		_petId = 0
		_petIdx = 0
		--_bCanCreate = true
		current_is_in_action = true
		
		--移除监听事件：宠物升星事件结果返回（升星）
		hGlobal.event:listen("LocalEvent_PetStarUp_Ret", "_PetStarUp_Upgrate", nil)
		--移除监听事件：宠物升级事件结果返回（升级）
		hGlobal.event:listen("LocalEvent_PetLevelUp_Ret", "_PetLevelUp_Upgrate", nil)
		--移除监听事件：派遣宠物挖矿结果返回
		hGlobal.event:listen("LocalEvent_PetSendWaKuang_Ret", "_PetSendWaKuang_Upgrate", nil)
		--移除监听事件：派遣宠物挖体力结果返回
		hGlobal.event:listen("LocalEvent_PetSendWaTiLi_Ret", "PetSendWaTiLi_Upgrate", nil)
		--移除监听事件：取消宠物挖矿结果返回
		hGlobal.event:listen("LocalEvent_PetCancelWaKuang_Ret", "PetCancelWaKuang_Upgrate", nil)
		--移除监听事件：取消宠物挖体力结果返回
		hGlobal.event:listen("LocalEvent_PetCancelWaTiLi_Ret", "PetCancelWaTiLi_Upgrate", nil)
	end
	
	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end
	
	OnCreateUpgradePetData = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		local star = LuaGetHeroPetLv(_unitId, _petIdx) --星级
		local level = LuaGetHeroPetExp(_unitId, _petIdx) --当前等级
		--print("OnCreateUpgradePetData",star,_unitId, _petIdx,level,_petId)
		
		--等级
		btnChild["lab_lv"] = hUI.label:new({
			parent = btnParent,
			align = "MC",
			size = 30,
			font = "numWhite",
			border = 0,
			text = tostring(level),
			x = -208 - 20,
			y = 112 + 30,
		})
		btnChild["lab_lv"].handle.s:setColor(ccc3(255, 255, 0))
		
		local tabU = hVar.tab_unit[_petId] or {}
		local starIcon = tabU.starIcon or {}
		--绘制已获得的星级
		local tShowIcon = {}
		--star = 4
		for s = 1, star - 1, 1 do
			--星级图标
			btnChild["img_pet_star".. s] = hUI.image:new({
				parent = btnParent,
				x = -199 + (s - 1) * 15 - 20,
				y = 7 - (s - 1) * 86 + 30,
				model = "misc/chest/star_yellow.png",
				align = "MC",
				w = 53,
				h = 52,
			})
			if type(starIcon[s]) == "number" and starIcon[s] > 0 then
				local tabM = hVar.tab_model[starIcon[s]]
				if type(tabM) == "table" then
					tShowIcon[#tShowIcon + 1] = tabM.name
				end
			elseif type(starIcon[s]) == "string" then
				tShowIcon[#tShowIcon + 1] = starIcon[s]
				--print(starIcon[s])
			end
		end
		local iconnum = #tShowIcon
		local iconstartx = 150
		if iconnum > 1 then
			iconstartx = 156
		end
		for i = 1,iconnum do
			btnChild["img_starIcon".. i] = hUI.image:new({
				parent = btnParent,
				x = iconstartx + (i - (iconnum + 1)/2) * 70,
				y = 180,
				model = tShowIcon[i],
				align = "MC",
				--w = 53,
				--h = 52,
				scale = 0.7,
			})
		end

		-- 差一级升星时，星星闪烁
		if level > 0 and star < hVar.PET_STAR_INFO_NEW.maxPetStar 
		and level == hVar.PET_STAR_INFO_NEW[star].requireLv then
			local star_idx = star
			btnChild["img_pet_star".. star_idx] = hUI.image:new({
				parent = btnParent,
				x = -199 + (star_idx - 1) * 15 - 20,
				y = 7 - (star_idx - 1) * 86 + 30,
				model = "misc/chest/star_yellow.png",
				align = "MC",
				w = 53,
				h = 52,
			})
			local act1 = CCDelayTime:create(1)
			local act2 = CCFadeOut:create(0.4)
			local act3 = CCDelayTime:create(2)
			local act4 = CCFadeIn:create(0.4)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			btnChild["img_pet_star".. star_idx].handle.s:runAction(CCRepeatForever:create(sequence))
		end
		
		local petOffX,petOffY = 0,0
		if type(_tPetOff[_petId]) == "table" then
			petOffX,petOffY = unpack(_tPetOff[_petId])
		end
		
		btnChild["Image_pet"] = hUI.thumbImage:new({
			parent = btnParent,
			id = _petId,
			facing = 305,
			x = 0 + petOffX,
			y = 150 + petOffY,
			scale = 1.4,
			--z = 1,
		})
		local tab = hVar.tab_unit[_petId]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_pet"]
			local _parentNode = btnChild["Image_pet"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_pet"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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
	
	--宠物挖矿/挖体力界面
	OnCreatePetSendFrm = function()
		local offX = hVar.SCREEN.w - boardW/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
			offX = hVar.SCREEN.w - boardW/2 - 6
		end
		
		local star = LuaGetHeroPetLv(_unitId, _petIdx)
		local debris = LuaGetHeroPetDebrisNum(_unitId, _petIdx)
		local level = LuaGetHeroPetExp(_unitId, _petIdx)
		local wakuang = LuaGetHeroPetInWaKuang(_unitId, _petIdx)
		local watili = LuaGetHeroPetInWaTiLi(_unitId, _petIdx)
		
		--删除上一次的按钮
		hApi.safeRemoveT(_childUI, "btnWaKuang")
		hApi.safeRemoveT(_childUI, "btnWaTiLi")
		hApi.safeRemoveT(_childUI, "btnCancelWaKuang")
		hApi.safeRemoveT(_childUI, "btnCancelWaTiLi")
		
		--print(star, debris, level, wakuang, watili)
		
		--当前跟随的宠物不显示挖矿按钮
		local showFollowBtn = 0
		local currentIdx = LuaGetHeroPetIdx(_unitId)
		local currentIdx2 = LuaGetHeroPetIdx2(_unitId)
		local currentIdx3 = LuaGetHeroPetIdx3(_unitId)
		local currentIdx4 = LuaGetHeroPetIdx4(_unitId)
		--print(currentIdx,_petIdx)
		if (currentIdx ~= _petIdx) and (currentIdx2 ~= _petIdx) and (currentIdx3 ~= _petIdx) and (currentIdx4 ~= _petIdx) then
			showFollowBtn = 1 
		end
		 
		 --未跟随
		if (showFollowBtn == 1) then
			--挖矿
			if (star >= 2) then
				--没有在挖
				if (wakuang == 0) and (watili == 0) then
					--显示跟随按钮
					_childUI["btn_change"]:setstate(1)
					
					--挖矿按钮
					_childUI["btnWaKuang"] = hUI.button:new({
						parent = _parent,
						model = "misc/addition/mining_stone.png",
						--label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
						dragbox = _childUI["dragBox"],
						scaleT = 0.95,
						scale = 0.865,
						x = offX + 250,
						y = offY - 110,
						code = function()
							--点击派遣挖矿按钮
							OnClickSendWaKuangBtn()
						end,
					})
					
					--挖体力按钮
					_childUI["btnWaTiLi"] = hUI.button:new({
						parent = _parent,
						model = "misc/addition/mining_gas.png",
						--label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
						dragbox = _childUI["dragBox"],
						scaleT = 0.95,
						scale = 0.865,
						x = offX + 250,
						y = offY - 220,
						code = function()
							--点击派遣挖体力按钮
							OnClickSendWaTiLiBtn()
						end,
					})
				elseif (wakuang == 1) then --在挖矿
					--隐藏跟随按钮
					_childUI["btn_change"]:setstate(-1)
					
					--取消挖矿按钮
					_childUI["btnCancelWaKuang"] = hUI.button:new({
						parent = _parent,
						model = "misc/addition/mining_return.png",
						--label = {text = hVar.tab_string["__TEXT_Cancel"],size = 32,border = 1,font = hVar.FONTC,x = 0, y = 0,}, --"取消"
						dragbox = _childUI["dragBox"],
						scaleT = 0.95,
						scale = 0.865,
						x = offX + 250,
						y = offY - 110,
						code = function()
							--点击取消挖矿按钮
							OnClickCancelWaKuangBtn()
						end,
					})
				elseif (watili == 1) then --在挖体力
					--隐藏跟随按钮
					_childUI["btn_change"]:setstate(-1)
					
					--取消挖体力按钮
					_childUI["btnCancelWaTiLi"] = hUI.button:new({
						parent = _parent,
						model = "misc/addition/mining_return.png",
						--label = {text = hVar.tab_string["__TEXT_Cancel"],size = 32,border = 1,font = hVar.FONTC,x = 0, y = 0,}, --"取消"
						dragbox = _childUI["dragBox"],
						scaleT = 0.95,
						scale = 0.865,
						x = offX + 250,
						y = offY - 220,
						code = function()
							--点击取消挖体力按钮
							OnClickCancelWaTiLiBtn()
						end,
					})
				end
			end
		end
	end
	
	OnCreateUpgradeRequire = function()
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		--local petLv = LuaGetHeroPetLv(_unitId, _petIdx)
		
		local _,costlist = LuaCheckHeroPetCanUpgrade(_unitId, _petIdx)
		--local tLvupInfo = hVar.PET_LVUP_INFO[_petId] or {}
		local _tRequireDebris = nil
		
		local tabU = hVar.tab_unit[_unitId]
		if (type(tabU) == "table") then
			if tabU.pet_unit and tabU.pet_unit[_petIdx] then
				local _tPetInfo = tabU.pet_unit[_petIdx]
				_tRequireDebris = _tPetInfo.requireDebris
			end
		end
		
		local star = LuaGetHeroPetLv(_unitId, _petIdx) --当前星级
		local level = LuaGetHeroPetExp(_unitId, _petIdx) --当前等级
		
		local showUpgradeBtn = 1
		local showFollowBtn = 0
		--local uix = - 110
		--local uiy = - 120
		
		--横线
		btnChild["img_line"] = hUI.image:new({
			parent = btnParent,
			model = "misc/title_line.png",
			x = 30,
			y = -90,
			w = 320,
			h = 4,
		})
		
		local valid_i = 0
		for i = 1,#costlist do
			valid_i = valid_i + 1
			local uix = -90+30
			local uiy = -120 - (valid_i - 1) * 50
			local stype,nvalue,font = unpack(costlist[i])
			
			if stype == "petdebir" then				
				--当前碎片数量
				local curnum = LuaGetHeroPetDebrisNum(_unitId, _petIdx)
				local nDebrisId  = _tRequireDebris[1]
				local nDebrisNum = _tRequireDebris[2]
				local debris = hVar.tab_item[nDebrisId]
				btnChild["img_debris"] = hUI.image:new({
					parent = btnParent,
					model = debris.icon,
					x = uix,
					y = uiy,
					w = 64,
					h = 64,
				})
				
				btnChild["img_debrisicon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/debris.png",
					x = uix + 10,
					y = uiy - 15,
					scale = 0.8,
				})
				
				--碎片进度条
				local progressV = 0
				if (nvalue > 0) then
					progressV = curnum / nvalue * 100 --进度
				end
				btnChild["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = btnParent,
					x = uix + 32 + 4,
					y = uiy - 4,
					w = 160,
					h = 28,
					align = "LC",
					back = {model = "misc/chest/jdd1.png", x = -4, y = 0, w = 160 + 7, h = 34},
					model = "misc/chest/jdt1.png",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				
				--进度条文字
				local labFontSize = 22
				local strFontText = tostring(curnum)
				if (nvalue > 0) then
					strFontText = (tostring(curnum) .. "/" .. tostring(nvalue))
				end
				--strFontText = "0000000/000" --测试 test
				--print(#strFontText)
				if (#strFontText == 9) then
					labFontSize = 20
				elseif (#strFontText == 10) then
					labFontSize = 18
				elseif (#strFontText == 11) then
					labFontSize = 16
				end
				btnChild["lab_debris"] = hUI.label:new({
					parent = btnParent,
					x = uix + 116 - 1,
					y = uiy - 2,
					width = 300,
					align = "MC",
					size = labFontSize,
					font = font,
					border = 0,
					text = strFontText,
				})
			elseif stype == "score" then
				if (nvalue > 0) then
					--积分图标
					btnChild["img_Score"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/mu_coin.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的积分值
					btnChild["lab_Score"] = hUI.label:new({
						parent = btnParent,
						x = uix + 32,
						y = uiy + 1,
						width = 300,
						align = "LC",
						size = 20,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			elseif stype == "rmb" then
				if (nvalue > 0) then
					--游戏币图标
					btnChild["img_Rmb"] = hUI.image:new({
						parent = btnParent,
						model = "misc/skillup/keshi.png",
						x = uix,
						y = uiy,
						w = 42,
						h = 42,
					})
					
					--需要的游戏币值
					btnChild["lab_Rmb"] = hUI.label:new({
						parent = btnParent,
						x = uix + 110,
						y = uiy - 2,
						width = 300,
						align = "MC",
						size = 24,
						font = font,
						border = 0,
						text = nvalue,
					})
				else
					valid_i = valid_i - 1
				end
			end
		end
		
		local offX = hVar.SCREEN.w - boardW/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
			offX = hVar.SCREEN.w - boardW/2 - 6
		end
		
		local currentIdx = LuaGetHeroPetIdx(_unitId)
		local currentIdx2 = LuaGetHeroPetIdx2(_unitId)
		local currentIdx3 = LuaGetHeroPetIdx3(_unitId)
		local currentIdx4 = LuaGetHeroPetIdx4(_unitId)
		--print(currentIdx,_petIdx)
		if (currentIdx ~= _petIdx) and (currentIdx2 ~= _petIdx) and (currentIdx3 ~= _petIdx) and (currentIdx4 ~= _petIdx) then
			showFollowBtn = 1
		end
		
		--是否到满级
		if (level >= hVar.PET_LVUP_INFO_NEW.maxPetLv) then
			showUpgradeBtn = 0
		end
		
		--print("showUpgradeBtn=", showUpgradeBtn)
		--print("showFollowBtn=", showFollowBtn)
		--升级按钮
		local upgradeBtnx = offX - 90
		_childUI["btn_upgrade"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/pettalk_btn.png",
			--label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			scale = 1.0,
			x = upgradeBtnx,
			y = offY - 258,
			code = function()
				OnClickBtn()
			end,
		})
		if showUpgradeBtn == 0 then
			hApi.AddShader(_childUI["btn_upgrade"].handle.s, "gray")
		end
		
		_childUI["btn_upgrade"].childUI["img"] = hUI.button:new({
			parent = _childUI["btn_upgrade"].handle._n,
			model = "misc/skillup/btnicon_upgrade.png",
			scale = 0.9,
		})
		if showUpgradeBtn == 0 then
			hApi.AddShader(_childUI["btn_upgrade"].handle.s, "gray")
		end
		
		--跟随按钮
		local changeBtnX = offX + 84
		_childUI["btn_change"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/pettalk_mining_fight.png",
			--label = {text = hVar.tab_string["__TEXT_Follow"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			scale = 0.87,
			x = changeBtnX,
			y = offY - 258+2,
			code = function()
				OnClickFollowBtn()
			end,
		})
		if showFollowBtn == 0 then
			hApi.AddShader(_childUI["btn_change"].handle.s, "gray")
			_childUI["btn_change"]:setstate(-1) --跟随中就不显示跟随按钮了
		end
		--[[
		_childUI["btn_change"].childUI["img"] = hUI.button:new({
			parent = _childUI["btn_change"].handle._n,
			model = "misc/skillup/btnicon_change.png",
			scale = 0.9,
		})
		]]
		if showFollowBtn == 0 then
			--hApi.AddShader(_childUI["btn_change"].childUI["img"].handle.s, "gray")
			hApi.AddShader(_childUI["btn_change"].handle.s, "gray")
		end
		
		--取消跟随按钮
		_childUI["btn_cancelchange"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/mining_return.png",
			--label = {text = hVar.tab_string["__TEXT_Follow"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			scale = 0.87,
			x = changeBtnX,
			y = offY - 258+2,
			code = function()
				OnClickCancelFollowBtn()
			end,
		})
		if showFollowBtn == 1 then
			_childUI["btn_cancelchange"]:setstate(-1) --跟随中就不显示跟随按钮了
		end
	end
	
	OnCreatePetInfo = function()
		local tabU = hVar.tab_unit[_unitId] or {}
		if tabU.pet_unit and type(tabU.pet_unit[_petIdx]) then
			local summonUnit = tabU.pet_unit[_petIdx].summonUnit
			local tabPet = hVar.tab_unit[summonUnit]
			if tabPet then
				local btnChild = _childUI["ItemBG_1"].childUI
				local btnParent = _childUI["ItemBG_1"].handle._n
				local atk = tabPet.attr.attack[5]
				local hp = tabPet.attr.hp
				local hp_lvup = tabPet.attr.hp_lvup
				local atk_max_lvup = tabPet.attr.atk_max_lvup
				local attackFont = "numWhite"
				local hpFont = "numWhite"
				local atktype = "近战"
				local income = 0 --挂机收益
				if tabPet.attr.attack[3] > 100 then
					atktype = "远程"
				end
				
				local labx = -boardW/2 + 190
				local laby = 66 + 30
				local labdeltaX = 280
				local labdeltaY = -42
				
				local star = LuaGetHeroPetLv(_unitId, _petIdx) --当前星级
				local level = LuaGetHeroPetExp(_unitId, _petIdx) --当前等级
				
				--计算攻击力
				if (type(atk_max_lvup) == "table") then
					atk = atk + (level - 1) * (atk_max_lvup[star] or 0)
				elseif (type(atk_max_lvup) == "number") then
					atk = atk + (level - 1) * atk_max_lvup
				end
				
				--计算生命值
				if (type(hp_lvup) == "table") then
					hp = hp + (level - 1) * (hp_lvup[star] or 0)
				elseif (type(hp_lvup) == "number") then
					hp = hp + (level - 1) * hp_lvup
				end
				
				--计算挂机收益
				local PET_HOUR_KESHI_NUM = 1 / hVar.PET_WAKUANG_INFO[star].wakuangRequireHour --挖矿速度（每小时）
				income = math.floor(PET_HOUR_KESHI_NUM * 24)
				
				btnChild["lab_hp"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__ATTR__hp_max"], --"生命"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 0,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_hpValue"] = hUI.label:new({
					parent = btnParent,
					text = hp,
					font = hpFont,
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 0,
					size = 22,
				})
				
				btnChild["lab_atk"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_Hint_skill_damage"], --"杀伤"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 1,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_atkValue"] = hUI.label:new({
					parent = btnParent,
					text = atk,
					font = attackFont,
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 1,
					size = 22,
				})
				
				btnChild["lab_atktype"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_AttackType"], --"攻击方式"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 2,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_atktypeValue"] = hUI.label:new({
					parent = btnParent,
					text = atktype,
					font = hVar.FONTC,
					align = "RC",
					x = labx + labdeltaX,
					y = laby + labdeltaY * 2,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_income"] = hUI.label:new({
					parent = btnParent,
					text = hVar.tab_string["__Attr_On-hook_proceeds"], --"挂机收益"
					font = hVar.FONTC,
					align = "LC",
					x = labx,
					y = laby + labdeltaY * 3,
					size = 26,
					border = 1,
				})
				
				btnChild["lab_incomeValue"] = hUI.label:new({
					parent = btnParent,
					text = income,
					font = "numWhite",
					align = "RC",
					x = labx + labdeltaX,
					y = laby - 2 + labdeltaY * 3,
					size = 22,
				}) 
			end
			
			--添加监听事件：宠物升星事件结果返回（升星）
			hGlobal.event:listen("LocalEvent_PetStarUp_Ret", "_PetStarUp_Upgrate", OnPetStarUpEvent)
			--添加监听事件：宠物升级事件结果返回（升级）
			hGlobal.event:listen("LocalEvent_PetLevelUp_Ret", "_PetLevelUp_Upgrate", OnPetLevelUpEvent)
			--添加监听事件：派遣宠物挖矿结果返回
			hGlobal.event:listen("LocalEvent_PetSendWaKuang_Ret", "_PetSendWaKuang_Upgrate", OnPetSendWaKuangEvent)
			--添加监听事件：派遣宠物挖体力结果返回
			hGlobal.event:listen("LocalEvent_PetSendWaTiLi_Ret", "PetSendWaTiLi_Upgrate", OnPetSendWaTiLiEvent)
			--添加监听事件：取消宠物挖矿结果返回
			hGlobal.event:listen("LocalEvent_PetCancelWaKuang_Ret", "PetCancelWaKuang_Upgrate", OnPetCancelWaKuangEvent)
			--添加监听事件：取消宠物挖体力结果返回
			hGlobal.event:listen("LocalEvent_PetCancelWaTiLi_Ret", "PetCancelWaTiLi_Upgrate", OnPetCancelWaTiLiEvent)
		end
	end
	
	OnCreateUpgradePetsFrm = function()
		hGlobal.UI.UpgradePetsFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.UpgradePetsFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w - boardW/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2
		
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
			offX = hVar.SCREEN.w - boardW/2 - 6
		end
		
		--用于点击背景关闭的按钮
		_childUI["ItemBG_Close"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY + 20,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				hGlobal.event:event("clearUpgradePetsFrm")
			end,
		})
		_childUI["ItemBG_Close"].handle.s:setOpacity(0)
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/addition/pet_panel.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY + 20,
			--w = boardW,
			--h = boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n

		_childUI["btn_comment"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/commentbtn.png",
			dragbox = _childUI["dragBox"],
			scale = 0.8,
			scaleT = 0.8,
			x = offX - 128,
			y = offY + 196,
			code = function()
				hGlobal.event:event("LocalEvent_DoCommentProcess",{_petId})
			end,
		})
		
		OnCreatePetImg()
		OnCreateUpgradePetData()
		OnCreatePetInfo()
		OnCreateUpgradeRequire()
		OnCreatePetSendFrm() --挖矿界面
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end
	
	--点击 升级/升星 按钮
	OnClickBtn = function()
		print("btn_upgrade")
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		local bflag, costlist, sTag = LuaCheckHeroPetCanUpgrade(_unitId, _petIdx,1)
		--print("bflag, costlist, sTag", bflag, costlist, sTag)
		if bflag then
			if (sTag == "starup") then --升星
				--挡操作
				hUI.NetDisable(30000)
				
				--发起请求，宠物升星（升星）
				SendCmdFunc["tank_pet_starup"](_petId)
				--SendCmdFunc["tank_pet_levelup"](_petId)
			elseif (sTag == "levelup") then --升级
				--挡操作
				hUI.NetDisable(30000)
				
				--发起请求，宠物升级（升级）
				SendCmdFunc["tank_pet_levelup"](_petId)
				--SendCmdFunc["tank_pet_starup"](_petId)
				--print("发起请求，宠物升级（升级）")
			end
			--[[
			--LuaDeductCost(costlist)
			local petLv = LuaGetHeroPetLv(_unitId, _petIdx)
			local newLv = petLv + 1
			LuaSetHeroPetLv(_unitId, _petIdx, newLv)
			
			local keyList = {"card","material"}
			LuaSavePlayerData_Android_Upload(keyList, "升级宠物")
		
			hGlobal.event:event("clearUpgradePetsFrm")
			
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
			hGlobal.event:event("LocalEvent_refreshPetInfo",2)
			]]
		end
	end
	
	--点击跟随按钮
	OnClickFollowBtn = function()
		local currentIdx = LuaGetHeroPetIdx(_unitId)
		local currentIdx2 = LuaGetHeroPetIdx2(_unitId)
		local currentIdx3 = LuaGetHeroPetIdx3(_unitId)
		local currentIdx4 = LuaGetHeroPetIdx4(_unitId)
		--print(currentIdx,_petIdx)
		
		--当前不在跟随中
		if (currentIdx ~= _petIdx) and (currentIdx2 ~= _petIdx) and (currentIdx3 ~= _petIdx) and (currentIdx4 ~= _petIdx) then
			--已经跟随的宠物的数量
			local currentFollowNum = 0
			if (currentIdx > 0) then
				currentFollowNum = currentFollowNum + 1
			end
			if (currentIdx2 > 0) then
				currentFollowNum = currentFollowNum + 1
			end
			if (currentIdx3 > 0) then
				currentFollowNum = currentFollowNum + 1
			end
			if (currentIdx4 > 0) then
				currentFollowNum = currentFollowNum + 1
			end
			
			--可跟随宠物的最大数量
			local petCapacity = 0
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				local heros = world:GetPlayerMe().heros
				if heros then
					local oHero = heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							petCapacity = oUnit:GetPetCapacity()
							print(petCapacity)
						end
					end
				end
			end
			
			if (currentFollowNum < petCapacity) then
				hGlobal.event:event("LocalEvent_ReplacePet")
				OnLeaveFunc()
				
				hGlobal.event:event("clearUpgradePetsFrm")
				hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			else
				--冒字
				local strText = hVar.tab_string["__TEXT_PetFollowNumMax"] --"当前出战宠物已达上限"
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0,nil,1)
			end
		end
	end
	
	--点击取消跟随按钮
	OnClickCancelFollowBtn = function()
		local currentIdx = LuaGetHeroPetIdx(_unitId)
		local currentIdx2 = LuaGetHeroPetIdx2(_unitId)
		local currentIdx3 = LuaGetHeroPetIdx3(_unitId)
		local currentIdx4 = LuaGetHeroPetIdx4(_unitId)
		--print(currentIdx,_petIdx)
		if (currentIdx == _petIdx) or (currentIdx2 == _petIdx) or (currentIdx3 == _petIdx) or (currentIdx4 == _petIdx) then
			hGlobal.event:event("LocalEvent_CancelFollowPet")
			OnLeaveFunc()
			
			hGlobal.event:event("clearUpgradePetsFrm")
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
			hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
		end
	end
	
	--点击派遣挖矿按钮
	OnClickSendWaKuangBtn = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		--[[
		local star = LuaGetHeroPetLv(_unitId, _petIdx)
		local debris = LuaGetHeroPetDebrisNum(_unitId, _petIdx)
		local level = LuaGetHeroPetExp(_unitId, _petIdx)
		local wakuang = LuaGetHeroPetInWaKuang(_unitId, _petIdx)
		local watili = LuaGetHeroPetInWaTiLi(_unitId, _petIdx)
		]]
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起请求，宠物派遣挖矿
		SendCmdFunc["tank_pet_send_wakuang"](_petId)
	end
	
	--点击派遣挖体力按钮
	OnClickSendWaTiLiBtn = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起请求，宠物派遣挖体力
		SendCmdFunc["tank_pet_send_watili"](_petId)
	end
	
	--点击取消挖矿按钮
	OnClickCancelWaKuangBtn = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起请求，宠物取消挖矿
		SendCmdFunc["tank_pet_send_cancel_wakuang"](_petId)
	end
	
	--点击取消挖体力按钮
	OnClickCancelWaTiLiBtn = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起请求，宠物取消挖体力
		SendCmdFunc["tank_pet_send_cancel_watili"](_petId)
	end
	
	--宠物升星事件结果返回（升星）
	OnPetStarUpEvent = function(result, petId, star, num, level, costScore, costDebris, costRmb)
		--print("OnPetStarUpEvent", result, petId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，解锁成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_STARUP_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"升星成功！"
				
				--播放出售音效
				hApi.PlaySound("itemupgrade")
				
				hGlobal.event:event("clearUpgradePetsFrm")
				hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	--宠物升级事件结果返回（升星）
	OnPetLevelUpEvent = function(result, petId, star, num, level, costScore, costDebris, costRmb)
		--print("OnPetLevelUpEvent", result, petId, star, num, level, costScore, costDebris, costRmb)
		
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，解锁成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_LEVELUP_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"升级成功！"
				
				--播放出售音效
				hApi.PlaySound("level_up")
				
				hGlobal.event:event("clearUpgradePetsFrm")
				hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	--派遣宠物挖矿结果返回
	OnPetSendWaKuangEvent = function(result, petId, wakuang, sendtime)
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，派遣成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_SEND_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"派遣成功！"
				
				--播放音效
				hApi.PlaySound("Feed01")
				
				--更新挖矿/挖体力界面
				--OnCreatePetSendFrm()
				
				--触发事件：主基地派遣宠物挖矿
				hGlobal.event:event("LocalEvent_MainBase_SendPetWaKuang")
				
				--hGlobal.event:event("clearUpgradePetsFrm")
				--hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				--hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	--派遣宠物挖体力结果返回
	OnPetSendWaTiLiEvent = function(result, petId, watili, sendtime)
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，派遣成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_SEND_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"派遣成功！"
				
				--播放音效
				hApi.PlaySound("Feed01")
				
				--更新挖矿/挖体力界面
				--OnCreatePetSendFrm()
				
				--触发事件：主基地派遣宠物挖体力
				hGlobal.event:event("LocalEvent_MainBase_SendPetWaTiLi")
				
				--hGlobal.event:event("clearUpgradePetsFrm")
				--hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				--hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	--取消宠物挖矿结果返回
	OnPetCancelWaKuangEvent = function(result, petId, wakuang)
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，派遣成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_CANCEL_SEND_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"取消成功！"
				
				--播放音效
				hApi.PlaySound("Feed02")
				
				--更新挖矿/挖体力界面
				--OnCreatePetSendFrm()
				
				--触发事件：主基地取消宠物挖矿
				hGlobal.event:event("LocalEvent_MainBase_CancelPetWaKuang")
				
				--hGlobal.event:event("clearUpgradePetsFrm")
				--hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				--hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	--取消宠物挖体力结果返回
	OnPetCancelWaTiLiEvent = function(result, petId, watili)
		if (result == 1) then --操作成功
			--防止别的宠物走进来
			if (_petId == petId) then
				--冒字，派遣成功
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["__TEXT_CANCEL_SEND_SUCCESS"], hVar.FONTC, 40, "MC", 0, 0,nil,1) --"取消成功！"
				
				--播放音效
				hApi.PlaySound("Feed02")
				
				--更新挖矿/挖体力界面
				--OnCreatePetSendFrm()
				
				--触发事件：主基地取消宠物挖体力
				hGlobal.event:event("LocalEvent_MainBase_CancelPetWaTiLi")
				
				--hGlobal.event:event("clearUpgradePetsFrm")
				--hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
				--hGlobal.event:event("LocalEvent_refreshPetInfo",2) --1 解锁 2 升级
			end
		end
	end
	
	hGlobal.event:listen("clearUpgradePetsFrm","clearfrm",function()
		OnLeaveFunc()
		_bCanCreate = true
	end)
	
	hGlobal.event:listen("LocalEvent_SpinScreen","UpgradePetsFrm",function()
		OnLeaveFunc()
		_bCanCreate = true
	end)
	
	--"LocalEvent_ShowUpgradePetsFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(unitId,petId)
		if _bCanCreate then
			local petIdx = LuaGetHeroPetIndexById(unitId,petId)
			if petIdx > 0 then
				_bCanCreate = false
				OnLeaveFunc()
				_unitId = unitId
				_petId = petId
				_petIdx = petIdx
				OnCreateUpgradePetsFrm()
			end
		end
	end)
end
--[[
--测试 --test
--删除上次的界面
if hGlobal.UI.UpgradePetsFrm then
	hGlobal.UI.UpgradePetsFrm:del()
	hGlobal.UI.UpgradePetsFrm = nil
end
hGlobal.UI.InitUpgradePetsFrm("include") --宠物界面
hGlobal.event:event("LocalEvent_ShowUpgradePetsFrm", 6000, 13041)
--]]



--加血台子
hGlobal.UI.InitAddPetHpFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowAddPetHpfrm","ShowFrm"}
	if mode ~= "include" then
		--return tInitEventName
	end

	local _MoveW = 500
	local _bCanCreate = true
	local iPhoneX_WIDTH = 0
	local current_is_in_action = true
	local _boardW,_boardH = 480,360

	local _nPetId = 0
	--local _nPetIdx = 0
	local _tCallback

	if g_phone_mode == 4 then
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end

	local _tPetOff = {
		[13042] = {0,-8,},
		[13043] = {0,-16,},
	}

	local OnCreateAddPetHpFrm = hApi.DoNothing
	local GetPetNum = hApi.DoNothing
	local GetPetMinHPUnit = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnMoveFrmAction = hApi.DoNothing
	local OnClickAddHp = hApi.DoNothing
	local OnClickAddAllHp = hApi.DoNothing

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		local _frm = hGlobal.UI.AddPetHpFrm
		local _childUI = _frm.childUI
		local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
		local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
		local callback = CCCallFunc:create(function()
			current_is_in_action = false
			_frm:setXY(newX,nexY)
		end)
		local a = CCArray:create()
		a:addObject(moveto)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	OnCreateAddPetHpFrm = function()
		if hGlobal.UI.AddPetHpFrm then
			hGlobal.UI.AddPetHpFrm:del()
			hGlobal.UI.AddPetHpFrm = nil
		end

		hGlobal.UI.AddPetHpFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.AddPetHpFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local offX = hVar.SCREEN.w - _boardW/2 - 6 - iPhoneX_WIDTH
		local offY = hVar.SCREEN.h/2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = _boardW,
			h = _boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		--关闭按钮
		--取消按钮
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			model = "misc/skillup/btn_close.png",
			dragbox = _childUI["dragBox"],
			--scaleT = 0.95,
			x = offX + _boardW/2 - 30,
			y = offY + _boardH/2 - 30,
			scale = 0.8,
			--w = 40,
			--h = 32,
			code = function()
				if type(_tCallback) == "table" then
					--print("取消", _tCallback[1], _tCallback[2])
					hGlobal.event:event("LocalEvent_CloseHpRecoverBack", _tCallback[2])
				end
				
				OnLeaveFunc()
			end,
		})
		
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n
		
		--_childUI["lab_Buy"] = hUI.label:new({
			--parent = _parent,
			--x = offX - 66,
			--y = offY + 87,
			--width = 300,
			--align = "MC",
			--size = 36,
			--font = hVar.FONTC,
			--border = 1,
			--text = "Buy",
		--})
		
		--分割线1
		btnChild["SkillSeparateLine1"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY + 40,
			x = 0,
			y = 42,
			w = 420,
			h = 8,
		})
		
		--分割线2
		btnChild["SkillSeparateLine2"] = hUI.image:new({
			parent = btnParent,
			model = "misc/skillup/line.png",
			--x = offX,
			--y = offY - 60,
			x = 0,
			y = - 60,
			w = 420,
			h = 8,
		})

		local petOffX,petOffY = 0,0
		if type(_tPetOff[_nPetId]) == "table" then
			petOffX,petOffY = unpack(_tPetOff[_nPetId])
		end

		--[[
		btnChild["Image_pet"] = hUI.thumbImage:new({
			parent = btnParent,
			id = _nPetId,
			facing = 0,
			x = -80 + petOffX,
			y = 96 + petOffY,
			scale = 1,
			--z = 1,
		})
		local tab = hVar.tab_unit[_nPetId]
		if tab and type(tab.effect) == "table" and #tab.effect > 0  then
			local _frmNode  = btnChild["Image_pet"]
			local _parentNode = btnChild["Image_pet"].handle._n
			local offEffectY = 0 
			if tab.model == nil then
				btnChild["Image_pet"].handle.s:setOpacity(0)
				offEffectY = 20
			end
			for i = 1,#tab.effect do
				local effect = tab.effect[i]
				local effectId = effect[1]
				local effX = effect[2] or 0
				local effY = (effect[3] or 0) + offEffectY
				local effScale = effect[4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
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
					end
				end
			end
		end
		--]]


		btnChild["Image_petbowl"] = hUI.image:new({
			parent = btnParent,
			model = "misc/maintain.png",
			x = 0,
			y = 108,
			scale = 0.8,
		})
		
		_childUI["btn_confirm"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["confirm"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = offX,
			y = offY - 116,
			scale = 0.74,
			code = function()
				--OnClickAddHp()
				OnClickAddAllHp()
			end,
		})
		
		--local curScore = LuaGetPlayerScore() --当前积分
		local curScore = 0
		--[[
		local score = GameManager.GetGameInfo("scoreingame")
		if type(score) == "number" then
			curScore = score
		end
		]]
		local oWorld = hGlobal.WORLD.LastWorldMap
		local me = oWorld:GetPlayerMe()
		curScore = me:getresource(hVar.RESOURCE_TYPE.GOLD)
		
		local requireScore = hVar.AddPetHpCost.requireScore or 0
		local requireMan = hVar.AddPetHpCost.requireMan or 0
		--local oWorld = hGlobal.WORLD.LastWorldMap
		local curManNumber = 0
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end

		local tlist = {}
		if requireScore > 0 then
			tlist[#tlist + 1] = "score"
		end
		if requireMan > 0 then
			tlist[#tlist + 1] = "man"
		end

		local width = 150
		local shownum = #tlist
		local _offX = 0
		for i = 1,shownum do
			if tlist[i] == "score" then
				--积分底纹
				btnChild["ScoreBG"] = hUI.image:new({
					parent = btnParent,
					model = "misc/skillup/skillpoint_bg.png",
					x = _offX + width*(i - (shownum+1)/2),
					y = - 11,
					w = 120,
					h = 40,
				})
				
				--积分图标
				btnChild["ScoreIcon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/skillup/mu_coin.png",
					x = _offX + width*(i - (shownum+1)/2) - 35,
					y = - 11,
					w = 42,
					h = 42,
				})
				
				--需要的积分值
				btnChild["ScoreValue"] = hUI.label:new({
					parent = btnParent,
					x = _offX + width*(i - (shownum+1)/2) + 4,
					y = - 11 - 1,
					width = 300,
					align = "LC",
					size = 22,
					font = "num",
					border = 0,
					text = requireScore,
				})
				--如果当前积分不足，文字红色
				if (curScore < requireScore) then
					btnChild["ScoreValue"].handle.s:setColor(ccc3(255, 0, 0))
					hApi.AddShader(_childUI["btn_confirm"].handle.s, "gray")
				end
			elseif tlist[i] == "man" then
				--天赋点底纹
				btnChild["ManBG"] = hUI.image:new({
					parent = btnParent,
					model = "misc/skillup/skillpoint_bg.png",
					x = _offX + width*(i - (shownum+1)/2),
					y = - 11,
					w = 90,
					h = 40,
				})
				
				--天赋点图标
				btnChild["ManIcon"] = hUI.image:new({
					parent = btnParent,
					model = "misc/gameover/icon_man.png",
					x = _offX + width*(i - (shownum+1)/2) - 15,
					y = - 11,
					scale = 0.7,
				})
				
				--需要的天赋点数
				btnChild["ManValue"] = hUI.label:new({
					parent = btnParent,
					x = _offX + width*(i - (shownum+1)/2) + 35,
					y = - 11 - 1,
					width = 300,
					align = "RC",
					size = 22,
					font = "numWhite",
					border = 0,
					text = requireMan,
				})
				if curManNumber < requireMan then
					btnChild["ManValue"].handle.s:setColor(ccc3(255, 0, 0))
					hApi.AddShader(_childUI["btn_confirm"].handle.s, "gray")
				end
			end
		end
		
		_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)
		
		_frm:show(1)
		_frm:active()
		OnMoveFrmAction(-_MoveW,0.5)
	end

	OnClickAddAllHp = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end
		
		--local curScore = LuaGetPlayerScore() --当前积分
		--[[
		local curScore = 0
		--geyachao: 改为读银币值
		local score = GameManager.GetGameInfo("scoreingame")
		if type(score) == "number" then
			curScore = score
		end
		]]
		local oWorld = hGlobal.WORLD.LastWorldMap
		local me = oWorld:GetPlayerMe()
		local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
		
		local requireScore = hVar.AddPetHpCost.requireScore or 0
		
		--if curScore < requireScore then
		if goldNow < requireScore then
			hApi.NotEnoughResource("coin")
			return
		end
		
		--GameManager.AddGameInfo("scoreingame",-requireScore)
		--扣钻石
		me:addresource(hVar.RESOURCE_TYPE.GOLD, -requireScore, hVar.GET_SCORE_WAY.PETADHP)
		hGlobal.event:event("Event_TacticCastCostRefresh")
		--扣钱扣资源
		--LuaAddPlayerScoreByWay(-requireScore,hVar.GET_SCORE_WAY.PETADHP)
		
		--全宠物加血
		local rpgunits = oWorld.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			local oUnit = u
			for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
				if (oUnit.data.id == walle_id) then
					local hp_max = oUnit:GetHpMax() --最大血量
					oUnit.attr.hp = hp_max
					
					--更新血条控件
					if oUnit.chaUI["hpBar"] then
						oUnit.chaUI["hpBar"]:setV(hp_max, hp_max)
					end
					--更新数字显血
					if oUnit.chaUI["numberBar"] then
						oUnit.chaUI["numberBar"]:setText(hp_max .. "/" .. hp_max)
					end
					
					--特效
					local effect_id = 117 --特效id
					local worldX, worldY = hApi.chaGetPos(oUnit.handle)
					local eff = oWorld:addeffect(effect_id, 1, nil, worldX, worldY) --56
				end
			end
		end
		
		--战车加血
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local nForceMe = oPlayerMe:getforce() --我的势力
		local oHero = oPlayerMe.heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				local hp_max = oUnit:GetHpMax() --最大血量
				oUnit.attr.hp = hp_max
				
				SetHeroHpBarPercent(oHero,hp_max,hp_max)
				
				--特效
				local effect_id = 117 --特效id
				local worldX, worldY = hApi.chaGetPos(oUnit.handle)
				local eff = oWorld:addeffect(effect_id, 1, nil, worldX, worldY) --56
			end
		end
		
		hGlobal.event:event("LocalEvent_RefreshCurGameScore")
		
		if type(_tCallback) == "table" then
			hGlobal.event:event(_tCallback[1],_tCallback[2],1)
		end
		
		OnLeaveFunc()
	end

	OnClickAddHp = function()
		--在动画中禁止点击
		if current_is_in_action then
			return
		end

		local requireScore = hVar.AddPetHpCost.requireScore or 0
		local requireMan = hVar.AddPetHpCost.requireMan or 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		local curManNumber = 0
		if oWorld then
			curManNumber = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
		end
		
		local num = GetPetNum()
		if num == 0 then
			return
		end

		local scoreingame = 0
		local score = GameManager.GetGameInfo("scoreingame")
		if type(score) == "number" then
			scoreingame = score
		end
		
		--积分不足
		if (scoreingame < requireScore) then
			hApi.NotEnoughResource("coin")
			return
		end

		if curManNumber < requireMan then
			hApi.NotEnoughResource("man")
			return
		end

		

		--扣钱扣资源
		--LuaAddPlayerScoreByWay(-requireScore,hVar.GET_SCORE_WAY.PETADHP)
		GameManager.AddGameInfo("scoreingame",-requireScore)
		oWorld.data.statistics_rescue_costnum = oWorld.data.statistics_rescue_costnum + requireMan

		--宠物加血
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if (tInfo.stageInfo == nil) then
			tInfo.stageInfo = {}
		end
		if (tInfo.stageInfo[nStage] == nil) then
			tInfo.stageInfo[nStage] = {}
		end
		
		--本关地图内宠物血量百分比
		if oWorld then
			--宠物单位
			local oUnit = GetPetMinHPUnit() --oWorld.data.follow_pet_unit
			--print(oUnit and oUnit.data.name)
			if oUnit and (oUnit ~= 0) then
				--回满血
				--local hp = oUnit.attr.hp --当前血量
				local hp_max = oUnit:GetHpMax() --最大血量
				--local percent = math.ceil(hp / hp_max * 100)
				oUnit.attr.hp = hp_max
				
				--更新血条控件
				if oUnit.chaUI["hpBar"] then
					oUnit.chaUI["hpBar"]:setV(hp_max, hp_max)
				end
				--更新数字显血
				if oUnit.chaUI["numberBar"] then
					oUnit.chaUI["numberBar"]:setText(hp_max .. "/" .. hp_max)
				end
				
				--本关地图内宠物血量百分比
				if (oWorld.data.follow_pet_unit == oUnit) then
					tInfo.stageInfo[nStage]["petHpPercent"] = 100
				end
				
				--特效
				local effect_id = 117 --特效id
				local worldX, worldY = hApi.chaGetPos(oUnit.handle)
				local eff = oWorld:addeffect(effect_id, 1, nil, worldX, worldY) --56
			end
		end
		
		hGlobal.event:event("LocalEvent_RefreshCurGameScore")

		if type(_tCallback) == "table" then
			hGlobal.event:event(_tCallback[1],_tCallback[2],1)
		end

		OnLeaveFunc()
	end

	OnLeaveFunc = function()
		if hGlobal.UI.AddPetHpFrm then
			hGlobal.UI.AddPetHpFrm:del()
			hGlobal.UI.AddPetHpFrm = nil
		end
		_bCanCreate = true
		current_is_in_action = true

		_nPetId = 0
		--_nPetIdx = 0
		_tCallback = nil
		g_DisableShowOption = 0
	end
	
	--获得地图上宠物数量
	GetPetNum = function()
		--[[
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if (tInfo.stageInfo == nil) then
			tInfo.stageInfo = {}
		end
		if (tInfo.stageInfo[nStage] == nil) then
			tInfo.stageInfo[nStage] = {}
		end
		
		local petHpPercent = tInfo.stageInfo[nStage]["petHpPercent"] or 0 --本关地图内宠物血量百分比
		
		return petHpPercent
		]]
		
		--统计宠物数量
		local petNum = 0
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		local rpgunits = oWorld.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			--local oUnit = oHero:getunit()
			local oUnit = u
			--if oUnit and (oUnit ~= 0) then
			--if (oUnit.data.id == hVar.MY_TANK_FOLLOW_ID) then
			for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
				if (oUnit.data.id == walle_id) then
					petNum = petNum + 1
				end
			end
		end
		
		return petNum
	end
	
	--获得地图上血量最少的宠物单位
	GetPetMinHPUnit = function()
		local petUnit = nil
		local hpPercent = 100
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		local rpgunits = oWorld.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			--local oUnit = oHero:getunit()
			local oUnit = u
			--if oUnit and (oUnit ~= 0) then
			--if (oUnit.data.id == hVar.MY_TANK_FOLLOW_ID) then
			for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
				if (oUnit.data.id == walle_id) then
					local hp = oUnit.attr.hp --当前血量
					local hp_max = oUnit:GetHpMax() --最大血量
					local percent = math.ceil(hp / hp_max * 100)
					--print(oUnit.data.name)
					--print("hp=", hp)
					--print("hp_max=", hp_max)
					--print("percent=", percent)
					if (percent <= hpPercent) then --比例更小
						hpPercent = percent
						petUnit = oUnit
						--print("比例更小 hpPercent=", hpPercent, petUnit.data.name)
						break
					end
				end
			end
		end
		
		return petUnit
	end
	
	hGlobal.event:listen("clearAddPetHpfrm","clearfrm",function()
		--print("clearAddPetHpfrm")
		OnLeaveFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","AddPetHpFrm",function()
		local _frm = hGlobal.UI.AddPetHpFrm
		if _frm and _frm.data.show == 1 then
			OnCreateAddPetHpFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tCallback)
		print(tInitEventName[1])
		--界面未打开 可创建
		if _bCanCreate then
			_bCanCreate = false
			--_nPetIdx = nPetIdx
			--_nPetId = oPetUnit.data.id
			_tCallback = tCallback
			g_DisableShowOption = 1
			
			OnCreateAddPetHpFrm()
		end
	end)
end

--复活弹窗
hGlobal.UI.InitBuyLifeFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowBuyLifeFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end
	local frmW = 400
	local frmH = 300
	local _frm,_childUI,_parent = nil,nil,nil

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.BuyLifeFrm then
			hGlobal.UI.BuyLifeFrm:del()
			hGlobal.UI.BuyLifeFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		g_BuyLifeState = 0
		
		--移除监听事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "BuyLifeFrm", nil)
		hGlobal.event:listen("LocalEvent_OnTankRebirthRet", "TankRebirthRet", nil)
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.BuyLifeFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 1,
			--dragable = 2,
			dragable = 4, --点击后消失
			--buttononly = 1,
			autoactive = 1,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.BuyLifeFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		--黑色背景
		_childUI["img_blackBg"] = hUI.image:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			x = 0,
			y = 0,
			z = -1,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
		})
		_childUI["img_blackBg"].handle.s:setOpacity(168)
		_childUI["img_blackBg"].handle.s:setColor(ccc3(0, 0, 0))

		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2
		
		_childUI["img_frmBg"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/msgbox4.png",
			x = offX,
			y = offY,
			w = frmW,
			h = frmH,
		})

			--分割线1
		_childUI["image_line1"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/line.png",
			x = offX,
			y = offY,
			w = frmW * 0.8,
			h = 8,
		})

		--取消按钮
		_childUI["btn_No"] = hUI.button:new({
			parent = _parent,
			model = "misc/skillup/btn_close.png",
			dragbox = _childUI["dragBox"],
			--scaleT = 0.95,
			x = offX + frmW/2 - 30,
			y = offY + frmH/2 - 30,
			scale = 0.8,
			--w = 40,
			--h = 32,
			code = function()
				_CODE_ClearFunc()

				local world = hGlobal.WORLD.LastWorldMap

				local mapInfo = world.data.tdMapInfo
				mapInfo.mapState = hVar.MAP_TD_STATE.END

				--大菠萝游戏结束结算
				local bResult = false
				TD_OnGameOver_Diablo(bResult)
				
				--大菠萝游戏结束,刷新界面
				local nResult = 0
				hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
			end,
		})

		--[[
		_childUI["lab_content"] = hUI.label:new({
			parent = _parent,
			size = 32,
			x = offX,
			y = offY + 75,
			--width = 300,
			align = "MC",
			font = hVar.FONTC,
			--text = "Continue ?",
			text = hVar.tab_string["rebirth"].." ?",
			border = 1,
		})
		--]]

		--积分图标
		_childUI["img_Score"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/mu_coin.png",
			x = offX - 36 - 70,
			y = offY + 75,
			w = 42,
			h = 42,
		})
		
		--需要的积分值
		_childUI["lab_Score"] = hUI.label:new({
			parent = _parent,
			x = offX + 34 - 70,
			y = offY + 75,
			width = 300,
			align = "MC",
			size = 22,
			font = "num",
			border = 0,
			text = hVar.BUY_LIFE_COST,
		})

		--体力图标
		_childUI["img_Tili"] = hUI.image:new({
			parent = _parent,
			model = "misc/task/tili.png",
			x = offX - 26 + 80,
			y = offY + 75,
			scale = 1.0,
			w = 64 * 1.0,
			h = 64 * 1.0,
		})

		--需要的体力值
		_childUI["lab_Tili"] = hUI.label:new({
			parent = _parent,
			x = offX + 24 + 90,
			y = offY + 75,
			width = 300,
			align = "MC",
			size = 22,
			font = "num",
			border = 0,
			text = "1",
		})
		
		_childUI["btn_relive"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["rebirth"],size = 28,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = offX,
			y = offY - 70,
			scale = 0.74,
			code = function(self)
				--[[
				local scoreingame = 0
				local score = GameManager.GetGameInfo("scoreingame")
				if type(score) == "number" then
					scoreingame = score
				end
				]]
				g_DisableShowOption = 0
				--geyachao: 改为扣金币
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
				if (goldNow >= hVar.BUY_LIFE_COST and hVar.BUY_LIFE_COST > 0) then
					--[[
					_CODE_ClearFunc()
					local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
					if diablodata then
						--修改添加积分的同时加上来源以便统计
						--LuaAddPlayerScoreByWay(-hVar.BUY_LIFE_COST,hVar.GET_SCORE_WAY.REVIVE)
						--GameManager.AddGameInfo("scoreingame",-hVar.BUY_LIFE_COST)
						--hGlobal.event:event("LocalEvent_RefreshCurGameScore")
						--扣金币
						me:addresource(hVar.RESOURCE_TYPE.GOLD, -hVar.BUY_LIFE_COST,hVar.GET_SCORE_WAY.REVIVE)
						hGlobal.event:event("Event_TacticCastCostRefresh")
						
						--LuaAddPlayerScore(-hVar.BUY_LIFE_COST)
						--购买生命
						diablodata.lifecount = diablodata.lifecount + 1
						diablodata.canbuylife = diablodata.canbuylife - 1
						if type(diablodata.randMap) == "table" then
							--记录随机地图数据
							local tInfos = {
								{"lifecount",diablodata.lifecount},
								{"canbuylife",diablodata.canbuylife},
							}
							LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
						end
						if hGlobal.UI.BuyLifeFrame then
							hGlobal.UI.BuyLifeFrame:del()
							hGlobal.UI.BuyLifeFrame = nil
						end
						hGlobal.event:event("Event_StartPauseSwitch", false)
					end
					]]
					--发送指令，请求复活
					local battlecfg_id = 0 --服务器战斗id
					if world.data.banLimitTable then
						battlecfg_id = world.data.banLimitTable.battlecfg_id
					end
					SendCmdFunc["tank_require_rebirth"](battlecfg_id)
				else
					hApi.NotEnoughResource("coin")
				end
			end,
		})
		
		_frm:show(1)
		_frm:active()
		
		--监听事件
		hGlobal.event:listen("LocalEvent_SpinScreen","BuyLifeFrm",function()
			if _frm and _frm.data.show == 1 then
				_CODE_ClearFunc()
				_CODE_CreateFrm()
			end
		end)
		
		--监听事件：玩家战车复活返回结果
		hGlobal.event:listen("LocalEvent_OnTankRebirthRet", "TankRebirthRet", function(result, tiliNow, battlecfg_id, scoreCost, tiliCost)
			print("LocalEvent_OnTankRebirthRet", result, tiliNow, battlecfg_id, scoreCost, tiliCost)
			
			--取消挡操作
			hUI.NetDisable(0)
			
			if (result == 1) then --操作成功
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				
				_CODE_ClearFunc()
				
				local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
				if diablodata then
					--修改添加积分的同时加上来源以便统计
					--LuaAddPlayerScoreByWay(-hVar.BUY_LIFE_COST,hVar.GET_SCORE_WAY.REVIVE)
					--GameManager.AddGameInfo("scoreingame",-hVar.BUY_LIFE_COST)
					--hGlobal.event:event("LocalEvent_RefreshCurGameScore")
					--扣钻石
					me:addresource(hVar.RESOURCE_TYPE.GOLD, -scoreCost,hVar.GET_SCORE_WAY.REVIVE)
					hGlobal.event:event("Event_TacticCastCostRefresh")
					
					--LuaAddPlayerScore(-hVar.BUY_LIFE_COST)
					--购买生命
					diablodata.lifecount = diablodata.lifecount + 1
					diablodata.canbuylife = diablodata.canbuylife - 1
					if type(diablodata.randMap) == "table" then
						--记录随机地图数据
						local tInfos = {
							{"lifecount",diablodata.lifecount},
							{"canbuylife",diablodata.canbuylife},
						}
						LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
					end
					if hGlobal.UI.BuyLifeFrame then
						hGlobal.UI.BuyLifeFrame:del()
						hGlobal.UI.BuyLifeFrame = nil
					end
					hGlobal.event:event("Event_StartPauseSwitch", false)
				end
			end
		end)
		
	end
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		g_DisableShowOption = 1
		g_BuyLifeState = 1
		_CODE_CreateFrm()
	end)
end

hGlobal.UI.InitModifyPlayerNameFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowModifyPlayerName", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _WIDTH = 540 --宽度
	local _HEIGHT = 400 --高度
	local _frameX = 0
	local _dragable = 0
	local _nMode = 0
	local _nID = 0
	local _frm,_parent,_childUI = nil,nil,nil
	local _oEnterNameEditBox = nil
	local _rgName = "" --输入的内容
	local _CODE_EditNameBoxTextEventHandle = hApi.DoNothing
	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_ClearFrm = hApi.DoNothing
	local _CODE_GetUiConfig = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUIbyMode = hApi.DoNothing
	local _CODE_RandName = hApi.DoNothing
	local _CODE_ClickConfirm = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing
	local _CODE_CallBackFunc = hApi.DoNothing
	local _CODE_BeforeGetResult = hApi.DoNothing

	_CODE_ClearFrm = function()
		if _oEnterNameEditBox then
			_oEnterNameEditBox:getParent():removeChild(_oEnterNameEditBox,true)
			_oEnterNameEditBox = nil
		end
		if hGlobal.UI.ModifyPlayerNameFrm then
			hGlobal.UI.ModifyPlayerNameFrm:del()
			hGlobal.UI.ModifyPlayerNameFrm = nil
		end
		_frameX = 0
		_dragable = 0
		_frm,_parent,_childUI = nil,nil,nil
	end

	_CODE_CloseFunc = function()
		--解除锁定
		hApi.RecoverScreenRotation()
		_CODE_CallBackFunc()
		_nMode = 0
		_nID = 0
		_CODE_ClearFrm()
	end

	_CODE_CallBackFunc = function()
		if _nMode == 1 then
			if (type(_nID) == "number") then
				local oAction = hClass.action:find(_nID)
				if oAction then --目标身上已有此buff
					--继续释放技能
					oAction.data.tick = 1
				end
			end
		end
	end

	_CODE_GetUiConfig = function()
		--结算界面自动跳出
		if _nMode == 1 then
			_frameX = hVar.SCREEN.w / 2 - _WIDTH / 2
			_dragable = 4
		else
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				_frameX = hVar.SCREEN.w - _WIDTH - 6 - hVar.SCREEN.offx
			else
				_frameX = hVar.SCREEN.w - _WIDTH - 6
			end
			_dragable = 3
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.ModifyPlayerNameFrm = hUI.frame:new({
			border = -1,
			background = -1,
			x = _frameX,
			y = hVar.SCREEN.h / 2 + _HEIGHT / 2,
			z = hZorder.TankSetName,
			w = _WIDTH,
			h = _HEIGHT,
			dragable = _dragable,
			autoactive = 0,
		})

		_frm = hGlobal.UI.ModifyPlayerNameFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["imgBG"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/msgbox4.png",
			x = _WIDTH/2,
			y = -_HEIGHT/2,
			w = _WIDTH,
			h = _HEIGHT,
			z = -1,
		})

		_CODE_CreateUIbyMode()

		if _nMode == 1 then
			_CODE_RandName()
		end

		_frm:show(1)
		_frm:active()
	end
	
	_CODE_CreateUIbyMode = function()
		--标题
		local boxX = _WIDTH / 2
		local boxY = -_HEIGHT / 2
		if _nMode == 1 then
			boxX = _WIDTH / 2 - 16
			boxY = -_HEIGHT / 2 + 20
			_childUI["lab_title"] = hUI.label:new({
				parent = _parent,
				text = hVar.tab_string["your_name"],
				x = _WIDTH / 2,
				y = - 90,
				size = 26,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				height = 28,
			})
			
			_childUI["btn_randname"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/randsieve.png", --"BTN:PANEL_CLOSE",
				dragbox = _childUI["dragBox"],
				x = _WIDTH - 90,
				y = boxY,
				scaleT = 0.95,
				code = function()
					_CODE_RandName()
				end,
			})
		else
			_childUI["btn_close"] = hUI.button:new({
				parent = _parent,
				model = "misc/skillup/btn_close.png", --"BTN:PANEL_CLOSE",
				dragbox = _childUI["dragBox"],
				x = _WIDTH - 38,
				y = -38,
				scaleT = 0.95,
				code = function()
					_CODE_CloseFunc()
				end,
			})
			
			_childUI["lab_title"] = hUI.label:new({
				parent = _parent,
				text = hVar.tab_string["new_name"],
				x = _WIDTH / 2,
				y = - 90,
				size = 26,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				height = 28,
			})
		end
		
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/bg_ng_graywhite.png", boxX, boxY, 340, 48, _frm)
		
		
		_oEnterNameEditBox = CCEditBox:create(CCSizeMake(290, 40), CCScale9Sprite:create("data/image/misc/button_null.png"))
		_oEnterNameEditBox:setPosition(ccp(boxX, boxY))
		--_oEnterNameEditBox:setFontName("Sketch Rockwell.ttf")
		_oEnterNameEditBox:setFontSize(22)
		_oEnterNameEditBox:setFontColor(ccc3(0, 0, 0))
		_oEnterNameEditBox:setPlaceHolder("")--hVar.tab_string["enter_name_7_15"]
		_oEnterNameEditBox:setPlaceholderFontColor(ccc3(192, 192, 192))
		_oEnterNameEditBox:setMaxLength(128)
		_oEnterNameEditBox:registerScriptEditBoxHandler(_CODE_EditNameBoxTextEventHandle)
		_oEnterNameEditBox:setTouchPriority(0)
		_oEnterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		_parent:addChild(_oEnterNameEditBox)

		_childUI["btn_confirm"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			x = _WIDTH / 2,
			y = -_HEIGHT + 100,
			scaleT = 0.95,
			scale = 0.7,
			dragbox = _childUI["dragBox"],
			--label = "确定", --language
			--label = hVar.tab_string["Exit_Ack"], --language
			label = {text = hVar.tab_string["Exit_Ack"],size = 28, border = 1,font = hVar.FONTC, x = 0, y = 4,width = 200,height = 32, },
			border = 1,
			code = function()
				_CODE_ClickConfirm()
			end,
		})
	end
	
	_CODE_ClickConfirm = function()
		--检测是否联网
		if (g_cur_net_state == -1) then --未联网
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion11_Net"] --"修改名字需要联网"
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2 - 113,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "LC", 0, 0,nil,1)
			
			return
		end

		--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
			_rgName = _oEnterNameEditBox:getText()
		end
		
		--验证名字是否有效
		_rgName = string.lower(_rgName) --转小写
		local answer, errInfo = LuaCheckPlayerName(_rgName)
		
		--print(_rgName, answer, errInfo)
		
		if (answer == hVar.STRING_TRIM_MODE.SUCCEED) then
			--挡操作
			hUI.NetDisable(30000)
			
			if _nMode == 1 then
				local behaviorId = hVar.PlayerBehaviorList[20003]
				print("addbehaviorId",behaviorId)
				LuaAddBehaviorID(behaviorId)
			end
			
			--发起改名请求
			--print("发起改名请求", _rgName)
			SendCmdFunc["modify_tank_username"](_rgName, 0)
			--hGlobal.event:event("localEvent_change_name", 1, -3)
		else
			--error
			--errInfo = "同的名"
			local strText = errInfo
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2 - 113,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "LC", 0, 0,nil,1)
		end
	end

	_CODE_RandName = function()
		if RandNameProcess and type(RandNameProcess.data.NameLibrary) == "table" then
			local r = hApi.random(1,#RandNameProcess.data.NameLibrary)
			local uId = xlPlayer_GetUID()
			local n = uId % 100000
			local sformat = "%s%03d"
			local nlen = string.len(uId)
			local n = string.sub(uId,nlen - 2,nlen)
			_rgName = string.format(sformat,RandNameProcess.data.NameLibrary[r],n)
			
			_oEnterNameEditBox:setText(_rgName)
		end
	end

	_CODE_EditNameBoxTextEventHandle = function(strEventName, pSender)
		--local edit = tolua.cast(pSender, "CCEditBox") 
		
		if (strEventName == "began") then
			--
		elseif (strEventName == "changed") then --改变事件
			--
		elseif (strEventName == "ended") then
			_rgName = _oEnterNameEditBox:getText()
		elseif (strEventName == "return") then
			--
		end
		
		--print("_CODE_EditNameBoxTextEventHandle", strEventName, _rgName)
		--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(_rgName) .. "\n")
	end

	_CODE_BeforeGetResult = function(result, info, name, gamecoin)
		--取消挡操作
		hUI.NetDisable(0)

		--更名结果（1成功 0失败）
		--更名信息 (成功:prizeid 失败:失败原因 -1钱不够 -2重名 -3未知)
		if (result == 1) then
			--修改显示名
			local playerInfo = LuaGetPlayerByName(g_curPlayerName)
			if playerInfo and (playerInfo.showName) then
				playerInfo.showName = name
			end
			
			--保存存档
			LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
			LuaSavePlayerList()

			_CODE_CloseFunc()
		else
			--(失败:失败原因 -1钱不够 -2重名 -3未知)
			local strText = nil
			if (info == -1) then
				--strText = "游戏币不足" --language
				strText = hVar.tab_string["ios_not_enough_game_coin"] --language
			elseif (info == -2) then
				--strText = "您输入的名字与已有玩家重名，请更换名字" --language
				strText = hVar.tab_string["ios_err_rename"] --language
			elseif (info == -3) then
				--strText = "未知错误" --language
				strText = hVar.tab_string["ios_err_unknow"] --language
			else
				strText = "rename_err:"..tostring(info)
			end
			
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2 - 30,
				y = hVar.SCREEN.h / 2 - 40,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "LC", 0, 0,nil,1)
		end
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("localEvent_modify_tank_username", "ModifyPlayerName", _CODE_BeforeGetResult)
	end
	
	_CODE_ClearEvent = function()
		hGlobal.event:listen("localEvent_modify_tank_username", "ModifyPlayerName", nil)
	end
	
	--"LocalEvent_ShowUnlockWeaponTip"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(index,mode,oID)
		--print("LocalEvent_ShowUnlockWeaponTip")
		_CODE_ClearFrm()
		--mode = 1 图内随机取名模式
		_nMode = mode
		_nID = oID
		--起名界面  禁止旋转
		hApi.LockScreenRotation()
		_CODE_GetUiConfig()
		_CODE_CreateFrm()
		_CODE_AddEvent()
	end)
end