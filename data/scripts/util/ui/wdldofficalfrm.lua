--其实现在是我的领地里按game start后的面板 懒得svn上改名字
hGlobal.UI.InitWdldOfficalFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldOfficalFrm = hUI.frame:new({
		x = 262,
		y = 684,
		--z = -1,
		dragable = 2,
		w = 500,
		h = 600,
		--z = -1,
		show = 0,
		autoactive = 0,
		--background = "UI:TileFrmBack",
	})

	local _frm = hGlobal.UI.WdldOfficalFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	local heros = nil
	local officalID = 0
	local offNh = {}
	for i = 1,#hVar.WDLD_Exploit do
		offNh[#offNh + 1] = 0
	end

	_frm:showBorder(1)

	local offFrm = nil
	local offfx,offfy,offfw,offfh = 275,680,1500,295
	local offcpx,offcpy,offcpw,offcph = 275,680,470,295
	offFrm = hUI.frame:new({
		x = offfx,
		y = offfy,
		dragable = {offcpw-offfw,0,offfw-offcpw,0},
		autoalign = {"H",{138,-48,235,70},100,0,0},
		w = offfw,
		h = offfh,
		clipper = {offcpx,offcpy,offcpw,offcph},
		show = 0,
		autoactive = 0,
		background = -1,
		--background = "UI:tip_item",
		codeOnDragEx = function(touchX,touchY,touchMode)
			--print(touchX,touchY,touchMode)
		end
	})
	local _offfrm = offFrm
	local _offparent = _offfrm.handle._n
	offFrm.childUI["strengthen_eff"] = nil

	local ohFrm = nil
	local ohfx,ohfy,ohfw,ohfh = 275,380,1500,295
	local ohcpx,ohcpy,ohcpw,ohcph = 275,380,470,295
	ohFrm = hUI.frame:new({
		x = ohfx,
		y = ohfy,
		dragable = {ohcpw-ohfw,0,ohfw-ohcpw,0},
		autoalign = {"H",{138,-48,235,70},100,0,0},
		w = ohfw,
		h = ohfh,
		clipper = {ohcpx,ohcpy,ohcpw,ohcph},
		show = 0,
		autoactive = 0,
		background = -1,
		--background = "UI:tip_item",
		codeOnDragEx = function(touchX,touchY,touchMode)
			--print(touchX,touchY,touchMode)
		end
	})
	local _ohfrm = ohFrm
	local _ohparent = _ohfrm.handle._n

	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 490,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldOfficalFrame",0)
			hApi.safeRemoveT(offFrm.childUI,"strengthen_eff")
		end,
	})

	_childUI["apartline_back_w"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 250,
		y = -300,
		w = 528,
		h = 8,
	})

	local PW = 235
	local PH = 50
	local ocPP = 8--每页官职个数
	local hPP = 8--每页英雄个数
	local choseOfficalBar = nil
	local heroGetOffical = nil

	hGlobal.event:listen("LocalEvent_ShowWdldOfficalFrame","Griffin_showWdldAttackFrm",function(isShow)
		_frm:show(isShow)
		offFrm:show(isShow)
		ohFrm:show(isShow)
		if isShow == 1 then
			offFrm.childUI["strengthen_eff"] = hUI.image:new({
				parent = _offparent,
				model = "MODEL_EFFECT:strengthen",
				isTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_UI,
				x = 2000,
				y = 2000,
				w = 88,
				h = 88,
			})
			offFrm:active()
			ohFrm:active()
			officalID = 0
			heros = Save_PlayerData.herocard
			if ohFrm.childUI["hhno"] then
				hApi.safeRemoveT(ohFrm.childUI,"hhno")
			end
			for i = 1,#heros do
				hApi.safeRemoveT(ohFrm.childUI,"hh"..heros[i].id)
				hApi.safeRemoveT(ohFrm.childUI,"hh"..heros[i].id.."B")
				hApi.safeRemoveT(ohFrm.childUI,"hh"..heros[i].id.."L1")
				hApi.safeRemoveT(ohFrm.childUI,"hh"..heros[i].id.."L2")
			end
			local hsn = 0
			for i = 1,#heros do
				hsn = math.floor((i - 1)/hPP) + 1--在第几页
				local hsnindex = i - (hsn - 1)*hPP--在当前页中的哪一个
				if ohFrm.childUI["hh"..heros[i].id.."B"] == nil then
					ohFrm.childUI["hh"..heros[i].id.."B"]= hUI.button:new({
						parent = _ohparent,
						dragbox = ohFrm.childUI["dragBox"],
						model = "UI:MADEL_BANNER",
						x = (hsn - 1)*ohcpw + (hsnindex-1)%2*PW + PW/2,
						y = - math.ceil((hsnindex-2)/2)*PH - PH/2 - 40,
						w = PW,
						h = PH,
						z = -1,
						code = function(self)--点击打开具体勋章说明 和 游戏里弹出的是同一个东西
							heroGetOffical(officalID,heros[i].id)
						end,
					})
					ohFrm.childUI["hh"..heros[i].id] = hUI.image:new({
						parent = _ohparent,
						model = hVar.tab_unit[heros[i].id].icon,
						animation = "normal",
						x = (hsn - 1)*ohcpw + (hsnindex-1)%2*PW + 32,
						y = - math.ceil((hsnindex-2)/2)*PH - PH/2 - 38,
						scaleT = 0.9,
						w = 42,
						h = 42,
					})
					local currS = WDLD_HERO_OFFICAL_EXP_STR[tostring(heros[i].id)] or 0
					ohFrm.childUI["hh"..heros[i].id.."L1"]= hUI.label:new({
						size = 20,
						parent = _ohparent,
						align = "MC",
						font = hVar.FONTC,
						x = (hsn - 1)*ohcpw + (hsnindex-1)%2*PW + 145,
						y = - math.ceil((hsnindex-2)/2)*PH - PH/2 - 27,
						RGB = {255,215,0},
						border = 1,
						width = 200,
						text = hVar.tab_string["wdld_exploit_curr"]..":"..currS,
					})
					ohFrm.childUI["hh"..heros[i].id.."L2"]= hUI.label:new({
						size = 20,
						parent = _ohparent,
						align = "MC",
						font = hVar.FONTC,
						x = (hsn - 1)*ohcpw + (hsnindex-1)%2*PW + 145,
						y = - math.ceil((hsnindex-2)/2)*PH - PH/2 - 50,
						RGB = {255,215,0},
						border = 1,
						width = 200,
						text = "",
					})
				end
			end
			local noi = #heros + 1
			hsn = math.floor((noi - 1)/hPP) + 1
			local hsnindex = noi - (hsn - 1)*hPP--在当前页中的哪一个
			ohFrm.childUI["hhno"] = hUI.button:new({
				parent = _ohparent,
				dragbox = ohFrm.childUI["dragBox"],
				model = "UI:BTN_cancel",
				x = (hsn - 1)*ohcpw + (hsnindex-1)%2*PW + 32,
				y = - math.ceil((hsnindex-2)/2)*PH - PH/2 - 39,
				scaleT = 0.9,
				w = 44,
				h = 44,
				code = function(self)
					heroGetOffical(officalID,0)
				end,
			})
			ohFrm:setXY(ohfx,ohfy,0,{-20-(hsn-1)*ohcpw,0,(hsn-1)*ohcpw+40,0})

			local sn = 0
			for i = 1,#hVar.WDLD_Exploit do
				if hVar.WDLD_Exploit[i][1] <= WDLD_Init_Data.LV then
					if offFrm.childUI["offical"..i] then 
						hApi.safeRemoveT(offFrm.childUI,"offical"..i)
					end
					if offFrm.childUI["offical"..i.."Lab"] then 
						hApi.safeRemoveT(offFrm.childUI,"offical"..i.."Lab")
					end
					if offFrm.childUI["offical"..i.."Img"] then 
						hApi.safeRemoveT(offFrm.childUI,"offical"..i.."Img")
					end
					sn = math.floor((i - 1)/ocPP) + 1--在第几页
					local snindex = i - (sn - 1)*ocPP--在当前页中的哪一个
					offFrm.childUI["offical"..i]= hUI.button:new({
						parent = _offparent,
						dragbox = offFrm.childUI["dragBox"],
						model = "UI:MADEL_BANNER",
						x = (sn - 1)*offcpw + (snindex-1)%2*PW + PW/2,
						y = - math.ceil((snindex-2)/2)*PH - PH/2 - 40,
						w = PW,
						h = PH,
						z = -1,
						code = function(self)--点击打开具体勋章说明 和 游戏里弹出的是同一个东西
							choseOfficalBar(i)
						end,
					})
					--_childUI["offical"..i].handle._n:setVisible(false)
					offFrm.childUI["offical"..i.."Lab"]= hUI.label:new({
						size = 28,
						parent = _offparent,
						align = "MC",
						font = hVar.FONTC,
						x = (sn - 1)*offcpw + (snindex-1)%2*PW + 70,
						y = - math.ceil((snindex-2)/2)*PH - PH/2 - 40,
						RGB = {255,215,0},
						border = 1,
						width = 200,
						text = hVar.tab_string["WDLD_Exploit"..i],
					})
					--_childUI["offical"..i.."Lab"].handle._n:setVisible(false)
					offFrm.childUI["offical"..i.."Img"]= hUI.image:new({
						parent = _offparent,
						model = "UI_frm:slot",
						animation = "normal",
						x = (sn - 1)*offcpw + (snindex-1)%2*PW + 200,
						y = - math.ceil((snindex-2)/2)*PH - PH/2 - 40,
						w = 36,
						h = 36,
					})
					--_childUI["offical"..i.."Img"].handle._n:setVisible(false)
				end
			end
			offFrm:setXY(offfx,offfy,0,{-20-(sn-1)*offcpw,0,(sn-1)*offcpw+40,0})
			local strt = hApi.Split(WDLD_HERO_OFFICAL_SET,";")
			for i = 1,#strt do
				local hid = tonumber(string.sub(strt[i],1,5))
				local officalid = tonumber(string.sub(strt[i],6,7))
				if type(officalid) == "number" and type(hid) == "number" then
					heroGetOffical(officalid,hid)
				end
			end
		else
			local str = ""
			for i = 1,#offNh do
				if offNh[i] > 0 then
					str = str..string.format("%07d",(offNh[i]*100 + i))..";"--数据格式 0英雄id官阶 0xxxxyy 刘备： 0500001
				end
			end
			WDLD_HERO_OFFICAL_SET = str
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.Ex_SetGrjx,luaGetplayerDataID(),WDLD_HERO_OFFICAL_SET})
		end
	end)

	offFrm.childUI["strengthen_eff"] = nil

	choseOfficalBar = function(index)
		local sn = math.floor((index - 1)/ocPP) + 1--在第几页
		local snindex = index - (sn - 1)*ocPP--在当前页中的哪一个
		offFrm.childUI["strengthen_eff"].handle._n:setPosition(200 + (sn - 1)*PW + (snindex-1)%2*PW,-24- math.ceil((snindex-2)/2)*PH - 40)
		officalID = index
		for i = 1,#heros do
			if ohFrm.childUI["hh"..heros[i].id.."L2"] then
				ohFrm.childUI["hh"..heros[i].id.."L2"]:setText(hVar.tab_string["wdld_exploit_need"]..":"..hVar.WDLD_Exploit[officalID][2])
			end
			local currS = WDLD_HERO_OFFICAL_EXP_STR[tostring(heros[i].id)] or 0
			if ohFrm.childUI["hh"..heros[i].id.."B"] then
				if currS >= hVar.WDLD_Exploit[officalID][2] then
					ohFrm.childUI["hh"..heros[i].id.."B"]:setstate(1)
				else
					ohFrm.childUI["hh"..heros[i].id.."B"]:setstate(0)
				end
			end
		end
	end

	heroGetOffical = function(oid,hid)
		if oid == 0 or oid > #offNh then
			return
		end
		if offFrm.childUI["oh"..oid] then
			hApi.safeRemoveT(offFrm.childUI,"oh"..oid)
			offNh[oid] = 0
		end
		if hid == 0 then

		else
			local sn = math.floor((oid - 1)/ocPP) + 1--在第几页
			local snindex = oid - (sn - 1)*ocPP--在当前页中的哪一个
			offFrm.childUI["oh"..oid]= hUI.image:new({
				parent = _offparent,
				model = hVar.tab_unit[hid].icon,
				animation = "normal",
				x = 200+(sn-1)*PW + (snindex-1)%2*PW,
				y = -24 - math.ceil((snindex-2)/2)*PH - 40,
				w = 36,
				h = 36,
				z = 100,
			})
			offNh[oid] = hid

			for i = 1,#offNh do
				if offNh[i] == hid and i ~= oid then
					hApi.safeRemoveT(offFrm.childUI,"oh"..i)
					offNh[oid] = 0
					--break
				end
			end
		end
	end
end