hGlobal.UI.InitLevelUpFrm = function(mode)
	local tInitEventName = {"LocalEvent_showLevelUpFrmC","__UI__showLevelUpFrmC"}
	if mode~="include" then
		return tInitEventName
	end
	local loNum = 0
	local doNum = 0
	local aoNum = 0
	local ioNum = 0
	local coNum = 0

	local lnNum = 0
	local dnNum = 0
	local anNum = 0
	local inNum = 0
	local cnNum = 0

	local lA = 0
	local dA = 0
	local aA = 0
	local iA = 0
	local cA = 0

	local skillIndex = 0
	local heroId = 0

	local _ATF_FrmXYWH = {hVar.SCREEN.w/2-600/2,hVar.SCREEN.h/2+478/2,600,478}
	hGlobal.UI.LevelUpFrm = hUI.frame:new({
		x = _ATF_FrmXYWH[1],
		y = _ATF_FrmXYWH[2],
		dragable = 4,
		w = _ATF_FrmXYWH[3],
		h = _ATF_FrmXYWH[4],
		--z = -1,
		border = "UI:TileFrmBasic_thin",
		show = 0,
		--closebtn = "BTN:PANEL_CLOSE",
		--closebtnX = 200,
		--autoactive = 1,
		--background = "UI:tip_item",
	})

	local _frm = hGlobal.UI.LevelUpFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	_childUI["darkBack"] = hUI.bar:new({
		parent = _parent,
		model = "UI:tip_item",
		--animation = "lightSlim",
		w = 614,
		h = 320,
		x = 311,
		y = -226,
	})

	_childUI["closebtn"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "BTN:PANEL_CLOSE",
		dragbox = _frm.childUI["dragBox"],
		--label = hVar.tab_string["__TEXT_Close"],
		--font = hVar.FONTC,
		--border = 1,
		x = _ATF_FrmXYWH[3] - 10,
		y = -16,
		w = 64,
		h = 64,
		code = function(self)
			_frm:show(0,"normal")
			hGlobal.SceneEvent:continue(300)
		end,
	})

	_childUI["t1"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		x = 260,
		y = -34,
		width = 540,
		border = 1,
		text = hVar.tab_string["hero_levelup"],
		RGB = {230,180,50},
	})

	_childUI["t2"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		x = 418,
		y = -34,
		width = 540,
		border = 1,
		text = hVar.tab_string["__TEXT_ji"],
		RGB = {230,180,50},
	})

	_childUI["t3"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		x = 294,
		y = -34,
		width = 540,
		border = 1,
		text = "",
		RGB = {230,180,50},
	})

	_childUI["up"] = hUI.image:new({
		parent = _parent,
		model = "UI:rank_up",
		--animation = "lightSlim",
		w = 8,
		h = 22,
		x = 436,
		y = -34,
	})

	_childUI["sBar1"] = hUI.image:new({
		parent = _parent,
		model = "UI:sBar",
		--animation = "lightSlim",
		w = 224,
		h = 6,
		x = 140,
		y = -348,
	})

	_childUI["skillbtn"] = hUI.button:new({
		parent = _frm.handle._n,
		model = -1,
		dragbox = _frm.childUI["dragBox"],
		--label = hVar.tab_string["__TEXT_Close"],
		--font = hVar.FONTC,
		--border = 1,
		x = 436,
		y = -436,
		w = 64,
		h = 64,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroId,hVar.tab_unit[heroId].talent[skillIndex][1][1],840,168,"RB")
		end,
	})

	_childUI["upgrade_eff_ever"] =hUI.image:new({
		parent = _parent,
		model = "MODEL_EFFECT:upgrade",
		x = 428,
		y = -436,
		w = 78,
		h = 92,
	})
	hApi.addTimerForever("upgrade_eff_ever",hVar.TIMER_MODE.GAMETIME,900,function()
		
	end)

	local tUIHandle = {}
		--{"label","hero_levelup",hVar.tab_string["hero_levelup"],{300,-30,32,1,"MC",hVar.FONTC,{230,180,50}}},
		--{"image","imgCut","UI:panel_part_09",{_ATF_FrmXYWH[3]/2,-72,_ATF_FrmXYWH[3]-24,8}},
	local allMoveDone = function()
		tUIHandle["ln"]:setVisible(true)
		tUIHandle["dn"]:setVisible(true)
		tUIHandle["an"]:setVisible(true)
		tUIHandle["in"]:setVisible(true)
		tUIHandle["cn"]:setVisible(true)


		tUIHandle["arrow1"]:setVisible(true)
		tUIHandle["arrow2"]:setVisible(true)
		tUIHandle["arrow3"]:setVisible(true)
		tUIHandle["arrow4"]:setVisible(true)
		tUIHandle["arrow5"]:setVisible(true)
	end

	local caMove = function()
		if tUIHandle["ca"] then
			tUIHandle["ca"]:setVisible(true)
			tUIHandle["ca"]:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),6,1),CCCallFunc:create(allMoveDone)))
		end
		--tUIHandle["ca"]:runAction(CCJumpBy:create(0.1,ccp(0,0),6,1))
	end

	local iaMove = function()
		if tUIHandle["ia"] then
			tUIHandle["ia"]:setVisible(true)
			tUIHandle["ia"]:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),6,1),CCCallFunc:create(caMove)))
		end
	end

	local aaMove = function()
		if tUIHandle["aa"] then
			tUIHandle["aa"]:setVisible(true)
			tUIHandle["aa"]:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),6,1),CCCallFunc:create(iaMove)))
		end
	end
	
	local daMove = function()
		if tUIHandle["da"] then
			tUIHandle["da"]:setVisible(true)
			tUIHandle["da"]:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),6,1),CCCallFunc:create(aaMove)))
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isShow,id,nowLevel,oldLevel)
		
		if isShow == 1 and hVar.tab_unit[id].hero_attr then
			_frm:show(1)
			_frm:active(2)
			_childUI["up"].handle._n:setVisible(false)
			_childUI["upgrade_eff_ever"].handle._n:setVisible(false)
			heroId = id
			if tUIHandle["all"] then
				_frm.handle._n:removeChild(tUIHandle["all"],false)
				tUIHandle = {}
			end

			loNum = math.floor(hVar.tab_unit[id].hero_attr.lea[1] + (oldLevel - 1)*hVar.tab_unit[id].hero_attr.lea[2])
			doNum = math.floor(hVar.tab_unit[id].hero_attr.led[1] + (oldLevel - 1)*hVar.tab_unit[id].hero_attr.led[2])
			aoNum = math.floor(hVar.tab_unit[id].hero_attr.str[1] + (oldLevel - 1)*hVar.tab_unit[id].hero_attr.str[2])
			ioNum = math.floor(hVar.tab_unit[id].hero_attr.int[1] + (oldLevel - 1)*hVar.tab_unit[id].hero_attr.int[2])
			coNum = math.floor(hVar.tab_unit[id].hero_attr.con[1] + (oldLevel - 1)*hVar.tab_unit[id].hero_attr.con[2])

			lnNum = math.floor(hVar.tab_unit[id].hero_attr.lea[1] + (nowLevel - 1)*hVar.tab_unit[id].hero_attr.lea[2])
			dnNum = math.floor(hVar.tab_unit[id].hero_attr.led[1] + (nowLevel - 1)*hVar.tab_unit[id].hero_attr.led[2])
			anNum = math.floor(hVar.tab_unit[id].hero_attr.str[1] + (nowLevel - 1)*hVar.tab_unit[id].hero_attr.str[2])
			inNum = math.floor(hVar.tab_unit[id].hero_attr.int[1] + (nowLevel - 1)*hVar.tab_unit[id].hero_attr.int[2])
			cnNum = math.floor(hVar.tab_unit[id].hero_attr.con[1] + (nowLevel - 1)*hVar.tab_unit[id].hero_attr.con[2])

			lA = lnNum - loNum
			dA = dnNum - doNum
			aA = anNum - aoNum
			iA = inNum - ioNum
			cA = cnNum - coNum

			local y1,y2,y3,y4,y5 = -110,-165,-220,-275,-330
			local x1,x2,x3,x4,x5 = 330,390,560,430,500
			
			local tUIList = {
				{"node","all",{
					{"label","hero_levelup",nowLevel,{384,-34,24,1,"MC","numGreen"}},
					{"image","heroImg",hVar.tab_unit[id].portrait,{140,-236,220,220}},
					{"label","hero_name",hVar.tab_stringU[id][1],{140,-96,28,1,"MC",hVar.FONTC}},

					{"image","attr_leadship","ICON:HeroAttr_leadship",{x1,y1,44,44}},
					{"image","attr_defense","ICON:HeroAttr_defense",{x1,y2,44,44}},
					{"image","attr_attack","ICON:HeroAttr_str",{x1,y3,44,44}},
					{"image","attr_int","ICON:HeroAttr_int",{x1,y4,44,44}},
					{"image","attr_con","ICON:HeroAttr_con",{x1,y5,44,44}},

					{"label","lo",loNum,{x2,y1,22,1,"MC","numGreen"}},
					{"label","do",doNum,{x2,y2,22,1,"MC","numWhite"}},
					{"label","ao",aoNum,{x2,y3,22,1,"MC","numRed"}},
					{"label","io",ioNum,{x2,y4,22,1,"MC","numBlue"}},
					{"label","co",coNum,{x2,y5,22,1,"MC","num"}},
					

					{"label","ln",lnNum,{x3,y1,22,1,"MC","numGreen"}},
					{"label","dn",dnNum,{x3,y2,22,1,"MC","numWhite"}},
					{"label","an",anNum,{x3,y3,22,1,"MC","numRed"}},
					{"label","in",inNum,{x3,y4,22,1,"MC","numBlue"}},
					{"label","cn",cnNum,{x3,y5,22,1,"MC","num"}},

					{"label","la","+"..lA,{x4,y1,22,1,"MC","numGreen"}},
					{"label","da","+"..dA,{x4,y2,22,1,"MC","numWhite"}},
					{"label","aa","+"..aA,{x4,y3,22,1,"MC","numRed"}},
					{"label","ia","+"..iA,{x4,y4,22,1,"MC","numBlue"}},
					{"label","ca","+"..cA,{x4,y5,22,1,"MC","num"}},

					{"image","arrow1","UI:UI_Arrow",{x5,y1,48,48}},
					{"image","arrow2","UI:UI_Arrow",{x5,y2,48,48}},
					{"image","arrow3","UI:UI_Arrow",{x5,y3,48,48}},
					{"image","arrow4","UI:UI_Arrow",{x5,y4,48,48}},
					{"image","arrow5","UI:UI_Arrow",{x5,y5,48,48}},

				}},
			}
			if hVar.tab_unit[id].talent then
				local temp = tUIList[1][3]
				--print(hVar.tab_unit[id].talent[5][1][1])
				if nowLevel == 12 then
					temp[#temp + 1] = {"label","sTitle",hVar.tab_string["hero_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{230,180,50}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[5][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[5][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[5][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 5
				elseif nowLevel >9 then
					temp[#temp + 1] = {"label","sTitle","12"..hVar.tab_string["hero_level_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{255,255,255}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[5][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[5][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[5][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 5
				elseif nowLevel == 9 then
					temp[#temp + 1] = {"label","sTitle",hVar.tab_string["hero_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{230,180,50}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[4][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[4][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[4][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 4
				elseif nowLevel > 6 then
					temp[#temp + 1] = {"label","sTitle","9"..hVar.tab_string["hero_level_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{255,255,255}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[4][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[4][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[4][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 4
				elseif nowLevel == 6 then
					temp[#temp + 1] = {"label","sTitle",hVar.tab_string["hero_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{230,180,50}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[3][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[3][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[3][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 3
				elseif nowLevel > 3 then
					temp[#temp + 1] = {"label","sTitle","6"..hVar.tab_string["hero_level_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{255,255,255}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[3][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[3][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[3][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 3
				elseif nowLevel == 3 then
					temp[#temp + 1] = {"label","sTitle",hVar.tab_string["hero_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{230,180,50}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[2][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[2][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[2][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 2
				else
					temp[#temp + 1] = {"label","sTitle","3"..hVar.tab_string["hero_level_unlockskill"],{200,-430,30,1,"MC",hVar.FONTC,{255,255,255}}}
					if hVar.tab_skill[hVar.tab_unit[id].talent[2][1][1]] then temp[#temp + 1] = {"image","skillicon",hVar.tab_skill[hVar.tab_unit[id].talent[2][1][1]].icon,{428,-436,64,64}} end
					temp[#temp + 1] = {"label","skillname",hVar.tab_stringS[hVar.tab_unit[id].talent[2][1][1]][1],{428,-390,24,1,"MC",hVar.FONTC,{255,255,255}}}
					skillIndex = 2
				end
			end
	
			hUI.CreateMultiUIByParam(_frm.handle._n,0,0,tUIList,tUIHandle)

			tUIHandle["ln"]:setVisible(false)
			tUIHandle["dn"]:setVisible(false)
			tUIHandle["an"]:setVisible(false)
			tUIHandle["in"]:setVisible(false)
			tUIHandle["cn"]:setVisible(false)

			--tUIHandle["la"]:setVisible(false)
			tUIHandle["da"]:setVisible(false)
			tUIHandle["aa"]:setVisible(false)
			tUIHandle["ia"]:setVisible(false)
			tUIHandle["ca"]:setVisible(false)

			tUIHandle["arrow1"]:setVisible(false)
			tUIHandle["arrow2"]:setVisible(false)
			tUIHandle["arrow3"]:setVisible(false)
			tUIHandle["arrow4"]:setVisible(false)
			tUIHandle["arrow5"]:setVisible(false)

			tUIHandle["la"]:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.1,ccp(0,0),6,1),CCCallFunc:create(daMove)))

			if nowLevel == 12 or nowLevel == 9 or nowLevel == 6 or nowLevel == 3 then
				_childUI["upgrade_eff"] =hUI.image:new({
					parent = _parent,
					model = "MODEL_EFFECT:upgrade",
					x = 430,
					y = -434,
					w = 72,
					h = 84,
				})
				if hVar.tab_unit[id].talent then
					hApi.addTimerOnce("upgrade_eff",600,function()
						hApi.safeRemoveT(_childUI,"upgrade_eff")
					end)
				else
					hApi.safeRemoveT(_childUI,"upgrade_eff")
				end
				_childUI["upgrade_eff_ever"].handle._n:setVisible(true)
			else
				if tUIHandle["skillicon"] then
					tUIHandle["skillicon"]:setColor(ccc3(127,127,127))
					_childUI["upgrade_eff_ever"].handle._n:setVisible(false)
				end
			end

			if nowLevel == 12 then
				--_childUI["up"].handle._n:setVisible(false)
				tUIHandle["hero_levelup"]:setVisible(false)
				_childUI["t1"]:setText("")
				_childUI["t2"]:setText("")
				_childUI["t3"]:setText(hVar.tab_string["hero_levelMax"])
			else
				--_childUI["up"].handle._n:setVisible(true)
				_childUI["t1"]:setText(hVar.tab_string["hero_levelup"])
				_childUI["t2"]:setText(hVar.tab_string["__TEXT_ji"])
				_childUI["t3"]:setText("")
			end

			if hVar.tab_unit[id].talent then
				_childUI["skillbtn"]:setstate(1)
				_childUI["upgrade_eff_ever"].handle._n:setVisible(true)
			else
				_childUI["skillbtn"]:setstate(-1)
				_childUI["upgrade_eff_ever"].handle._n:setVisible(false)
			end
		else
			_frm:show(0)
			hGlobal.SceneEvent:continue(300)
		end
	end)
end