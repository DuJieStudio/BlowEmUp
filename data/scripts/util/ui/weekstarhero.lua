--------------------------------
-- 每周星将的提示面板
--------------------------------
hGlobal.UI.InitWeekStarHeroFrm = function(mode)
	if hVar.OPTIONS.SHOW_WEEK_STAR_HERO~=1 then
		return
	end
	local tInitEventName = {"LocalEvent_ShowWeekStarHeroFrm","__ShowWeekStarHeroFrm"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.WeekStarHeroFrm =hUI.frame:new({
		x = hVar.SCREEN.w/2 - 230,
		y = hVar.SCREEN.h/2 + 170,
		dragable = 4,											--changed by pangyong 2015/4/9
		h = 340,
		w = 460,
		show = 0,
	})
	
	local _frm = hGlobal.UI.WeekStarHeroFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	local _x,_y = 100,-130


	--标题
	_childUI["WeekStarHeroTitle"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = _frm.data.w/2-10,
		y = -30,
		width = 540,
		text = hVar.tab_string["__TEXT_WEEKSTARHERO"],
	})
	
	--卡片介绍
	_childUI["HeroCardInfo"]  = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 180,
		y = -60,
		width = 270,
		text = "",
	})

	--技能
	_childUI["SkillInfo"]  = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 180,
		y = -150,
		width = 270,
		text = hVar.tab_string["__Attr_Skill"].." :",
		RGB = {0,255,0},
	})

	--介绍
	_childUI["WeekStarHeroPrice"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "LT",
		font = hVar.FONTC,
		x = 25,
		y = 85 -_frm.data.h,
		width = 540,
		text = hVar.tab_string["__TEXT_WEEKSTARHEROINFO1"],
	})

	local _HeroID = 0
	local _removeList = {}
	local _skillListCount = {}
	local _exitFun = function()
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		_removeList = {}
		for i = 1,#_skillListCount do
			hApi.safeRemoveT(_childUI,_skillListCount[i])
		end
		_skillListCount = {}
		_HeroID = 0
		Score,itemRMB = 0,0
	end

	--确定按钮
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Confirm"],
		x = _frm.data.w/2,
		y = 30 -_frm.data.h,
		scaleT = 0.9,
		code = function()
			_exitFun()
			_frm:show(0)
		end,
	})

	local _createSkillBtn = function(skillList,heroID)
		for i = 1,#_skillListCount do
			hApi.safeRemoveT(_childUI,_skillListCount[i])
		end
		_skillListCount = {}
		if #skillList > 0 then
			for i = 1, #skillList do
				_childUI["HeroSkillImg_"..i] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = hVar.tab_skill[skillList[i]].icon , --hVar.tab_unit[5000].icon,
					dragbox = _childUI["dragBox"],
					w = 48,
					h = 48,
					x = 200 + (i-1)*56,
					y = -210,
					scaleT = 0.9,
					code = function(self,x,y,sus)
						hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroID,skillList[i],150,600)
					end,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_"..i
			end
		end
	end
	local _showFrmCallBack = function()
		_frm:active()
	end

	local isShow = 0	--次界面只会出现一次 如果出现则不再显示
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(heroID,odds)
		if hVar.tab_unit[heroID] == nil or g_lua_src == 1 then return end
		if LuaGetPlayerMapAchi("world/level_hjzl",hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then return end
		if isShow == 0 then
			isShow = 1
		else
			return
		end
		_HeroID = heroID
		
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		_removeList = {}
		_childUI["HeroCard"] = hUI.image:new({
			parent = _parent,
			model = hVar.tab_unit[_HeroID].portrait,
			x = _x-7,
			y = _y+8,
			w = 128,
			h = 128,
			z = 1,
		})
		_removeList[#_removeList+1] = "HeroCard"
		_childUI["bg"] = hUI.image:new({
			parent = _parent,
			model = "UI:PANEL_CARD_01",
			x = _x-8,
			y = _y-14,
		})
		_removeList[#_removeList+1] = "bg"
		
		_childUI["heroName"] = hUI.label:new({
			parent = _parent,
			x = _x-5,
			y = _y-90,
			text = hVar.tab_stringU[_HeroID][1],
			size = 24,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		_removeList[#_removeList+1] = "heroName"
		for i = 1,5 do
			_childUI["HERO_STAR"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:HERO_STAR",
				x = _x -57+ (i-1)*16,
				y = _y -67,
			})
			_removeList[#_removeList+1] = "HERO_STAR"..i
		end
		
		local talent = hVar.tab_unit[_HeroID].talent
		local skillList = {}
		for i = 1,#talent do
			skillList[#skillList+1] = talent[i][1][1]
		end
		_childUI["HeroCardInfo"]:setText(hVar.tab_stringU[_HeroID][2])

		_childUI["WeekStarHeroPrice"]:setText(hVar.tab_string["__TEXT_WEEKSTARHEROINFO1"]..tostring(odds)..hVar.tab_string["__TEXT_WEEKSTARHEROINFO2"])
		_createSkillBtn(skillList,heroID)


		_frm:show(1)
		_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(_frm.data.x,_frm.data.y),5,1),CCCallFunc:create(_showFrmCallBack)))
		
	end)
end