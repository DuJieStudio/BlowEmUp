-------------------------------
--战术技能书面板
-------------------------------
--获得战术技能卡类型
local __TacticsArt = {
	[hVar.TACTICS_TYPE.FIGHTER] = "UI:ico_tactics_fighter",
	[hVar.TACTICS_TYPE.SHOOTER] = "UI:ico_tactics_shooter",
	[hVar.TACTICS_TYPE.RIDER] = "UI:ico_tactics_rider",
	[hVar.TACTICS_TYPE.WIZARD] = "UI:ico_tactics_wizard",
	[hVar.TACTICS_TYPE.LEGEND] = "UI:ico_tactics_legend",
	[hVar.TACTICS_TYPE.MACHINE] = "UI:ico_tactics_machine",
	[hVar.TACTICS_TYPE.OTHER] = "UI:ico_tactics_other",
	[hVar.TACTICS_TYPE.TOWER] = "UI:ico_tactics_other", --塔
	[hVar.TACTICS_TYPE.SPECIAL] = "UI:ico_tactics_other", --特殊塔
}
hApi.GetTacticsCardTypeIcon = function(id,mode)
	--print(debug.traceback())
	local tabT = hVar.tab_tactics[id]
	if tabT then
		if mode=="model" then
			if __TacticsArt[tabT.type or 0] then
				return __TacticsArt[tabT.type]
			else
				return __TacticsArt[hVar.TACTICS_TYPE.OTHER]
			end
		end
	else
		return 0
	end
end
--获得战术技能卡片的背景图片
hApi.GetTacticsCardGB = function(maxLv,lv)
	local tLv = hVar.BFSKILL_QUALITY[maxLv]
	if tLv then
		return "UI:tactic_card_"..(tLv[lv] or tLv[#tLv])
	else
		return "UI:tactic_card_1"
	end
end

--获得战术技能卡的质量
hApi.GetTacticsCardQA = function(id,lv)
	local tabT = hVar.tab_tactics[id]
	if tabT and tabT.level then
		local tLv = hVar.BFSKILL_QUALITY[(tabT.level or 1)]
		if tLv then
			return tLv[math.max(1,lv)] or tLv[#tLv]
		else
			return 1
		end
	end
end

--
--hGlobal.UI.InitBattlefieldSkillBook = function()
--	local _x,_y,_w,_h= 352,460,648,366
--	local _chaidGrid = {}
--	local _frm = nil
--	local _childUI = nil
--	local _parent = nil
--	
--	hGlobal.UI.BattlefieldSkillBook = hUI.frame:new({
--		x = _x,
--		y = _y,
--		dragable = 0,
--		w = _w,
--		h = _h,
--		titlebar = 0,
--		show = 0,
--		bgMode = "tile",
--		background = "UI:tip_item",
--		autoactive = 0,
--		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
--		
--		end,
--	})
--	
--	_frm = hGlobal.UI.BattlefieldSkillBook
--	_childUI = _frm.childUI
--	_parent = _frm.handle._n
--	
--	local _BorderFrm = hUI.frame:new({
--		x = _x-5,
--		y = _y+60,
--		dragable = 2,
--		w = _w+10,
--		h = _h+280,
--		titlebar = 0,
--		show = 0,
--		bgMode = "tile",
--		background = "UI:tip_item",
--		autoactive = 0,
--		z = -1,
--		border = 1,
--	})
--	
--	--标题
--	_childUI["BattlefieldSkillBook_Titel"] = hUI.label:new({
--		parent = _parent,
--		size = 34,
--		align = "MC",
--		font = hVar.FONTC,
--		x = _w/2+30,
--		y = 30,
--		width = 450,
--		text = hVar.tab_string["__MAStERYBOOK"],
--		border = 1,
--	})
--	
--	_childUI["BattlefieldSkillBook_Titel_Used"] = hUI.label:new({
--		parent = _parent,
--		size = 28,
--		align = "MC",
--		font = hVar.FONTC,
--		x = _w - 130,
--		y = 30,
--		width = 450,
--		RGB = {50,255,50},
--		text = hVar.tab_string["__UsedSkillBook"],
--		border = 1,
--	})
--	_childUI["BattlefieldSkillBook_Titel_Used"].handle._n:setVisible(false)
--	
--	--战术技能书的图片
--	_childUI["UI_skillbook_open"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:skillbook_open",
--		x = 190,
--		y = 34,
--	})
--	_childUI["UI_skillbook_open"].handle._n:setVisible(false)
--	
--	_childUI["UI_Card_UnitUpGrade"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:UI_Arrow",
--		x = 120,
--		y = 34,
--	})
--	_childUI["UI_Card_UnitUpGrade"].handle._n:setRotation(-90)
--	_childUI["UI_Card_UnitUpGrade"].handle._n:setVisible(false)
--	
--	
--	--按钮选中框
--	_childUI["Selectedbox"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:PHOTO_FRAME_BAR",
--		align = "MC",
--		w = 74,
--		h = 40,
--		z = 1,
--	})
--	_childUI["Selectedbox"].handle._n:setVisible(false)
--	
--	--分界线
--	_childUI["apartline_back"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:panel_part_09",
--		x = _w/2,
--		y = 0,
--		w = _w+20,
--		h = 8,
--	})
--	
--	_childUI["apartline_back1"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:panel_part_09",
--		x = _w/2,
--		y = -_h-2,
--		w = _w+20,
--		h = 8,
--	})
--	
--	--升级技能的 管理表
--	local _upgradeSkillList = {}
--	--标签翻页效果逻辑 
--	local _Btnlist = {}
--	local _skillbooklist = {}
--	local _skillbookslot = {}
--	local _btnX,_btnY = 612,-347
--	local _skillX,_skillY = 65,-80
--	local _lenN = 5
--	local _MaxN = 9
--	local _setBtnState = function(btn)
--		for i = 1,#_Btnlist do
--			if btn ~= _childUI[_Btnlist[i]] then
--				_childUI[_Btnlist[i]]:setstate(1)
--				_childUI[_Btnlist[i]].handle._n:runAction(CCScaleTo:create(0.01,1,0.9))
--				_childUI[_Btnlist[i]]:setXY(_childUI[_Btnlist[i]].data.x,_btnY-3)
--			else
--				btn:setstate(0)
--				btn.handle._n:runAction(CCScaleTo:create(0.01,1,1))
--				btn:setXY(btn.data.x,_btnY+2)
--				btn.handle.s:setColor(ccc3(255,255,255))
--				btn.childUI["label"].handle.s:setColor(ccc3(255,255,255))
--				_childUI["Selectedbox"].handle._n:setPosition(btn.data.x,_btnY+2)
--				_childUI["Selectedbox"].handle._n:setVisible(true)
--			end
--		end
--	end
--	
--	local _getIndexSkillList = function(skill_type,page_index,conditionMaxLevel,conditionLv,excludeID)
--		local tab = {}
--		local Rtab = {}
--		local maxNum = 1
--		local playerSkillBook = LuaGetPlayerSkillBook()
--		
--		for i = 1 ,#playerSkillBook do
--			if hVar.tab_tactics[playerSkillBook[i][1]].type == skill_type then
--				tab[#tab+1] = {playerSkillBook[i][1],playerSkillBook[i][2],playerSkillBook[i][3]}
--			end
--		end
--		
--		local conTab = {}
--		if conditionMaxLevel > 0 and conditionLv > 0 then
--			for i = 1,#tab do
--				if type(tab[i]) == "table" and hVar.tab_tactics[tab[i][1]].level == conditionMaxLevel and tab[i][2] == conditionLv and hVar.tab_tactics[tab[i][1]].unique ~= 1 then--and excludeID ~= tab[i][1] then
--					if (tab[i][3]-1) > 0 then
--					
--						conTab[#conTab+1] = {tab[i][1],tab[i][2],(tab[i][3]-1)}
--					end
--				end
--			end
--			tab = {}
--			tab = conTab
--		end
--		
--		local begin = (page_index * _MaxN - _MaxN)+1
--		local endLen = page_index * _MaxN
--		for i = begin,endLen do
--			if type(tab[i]) == "table" then
--				Rtab[#Rtab+1] = {tab[i][1],tab[i][2],tab[i][3]}
--			end
--		end
--		
--		return Rtab , math.ceil(#tab/_MaxN)
--	end
--	
--	--面板的退出方法
--	local _skillID = 0
--	local _conMaxLv,_conLv = 0,0
--	
--	local _exitFunc = function()
--		hApi.safeRemoveT(_BorderFrm.childUI,"card_forge")
--		--卡片列表
--		for i = 1,#_skillbooklist do
--			hApi.safeRemoveT(_childUI,_skillbooklist[i])
--		end
--		_skillbooklist = {}
--		--激活的卡片列表
--		for i = 1,#_skillbookslot do
--			hApi.safeRemoveT(_childUI,_skillbookslot[i])
--		end
--		_skillbookslot = {}
--		--升级的卡片列表
--		for i = 1,#_upgradeSkillList do
--			hApi.safeRemoveT(_childUI,_upgradeSkillList[i])
--		end
--		_upgradeSkillList = {}
--		
--		_childUI["UI_skillbook_open"].handle._n:setVisible(false)
--		_childUI["UI_Card_UnitUpGrade"].handle._n:setVisible(false)
--		_conMaxLv,_conLv = 0,0
--		_skillID = 0
--	end
--	
--	local _skillbookbtnstate = {}
--	local _skillbookslotpos = {}
--	
--	local _mode = ""
--	local _offx,_offy = 130,160
--	--设置当前面板的状态，1时 打开战术技能设置面板， 2 的时候 是 战术技能卡片升级界面
--	local _frmState = 1
--	local _upgradeSkillSlotList = {}	--升级卡片时用的本地数据表
--	local _checkUpgradeSkill = function(num,lv)
--		if type(_upgradeSkillSlotList) ~= "table" then
--			print("_checkUpgradeSkill have erro")
--			return 0
--		end
--		for i = 1,num do
--			if not(type(_upgradeSkillSlotList[i])=="table" and _upgradeSkillSlotList[i][2]==lv) then
--				return 0
--			end
--		end
--		return 1
--	end
--	local _deductType = 0 -- 扣费方式 1 为扣除积分，2 为发送服务器 扣除游戏币
--	
--	local _setFrmState = function(state)
--		_deductType = 0
--		_skillbookslotpos = {}
--		_frmState = state
--		_conMaxLv,_conLv = 0,0
--		_childUI["selectbox_finish"].handle._n:setVisible(false)
--		_childUI["deleteGrid"].handle._n:setVisible(true)
--		--_BorderFrm.childUI["card_forge"].handle._n:setVisible(false)
--		hApi.safeRemoveT(_BorderFrm.childUI,"card_forge")
--		_childUI["UI_Card_UnitUpGrade"].handle._n:setVisible(false)
--		_childUI["btnConfirm"]:setstate(0)
--		if state == 1 then
--			_childUI["UI_skillbook_open"].handle._n:setVisible(true)
--			_childUI["BattlefieldSkillBook_Titel"]:setText(hVar.tab_string["__MAStERYBOOK"])
--			
--			--判断是否有激活过的技能
--			local result = LuaGetUsedBookState(g_curPlayerName)
--			if result == 0 then
--				_childUI["BattlefieldSkillBook_Titel_Used"].handle._n:setVisible(false)
--			else
--				_childUI["BattlefieldSkillBook_Titel_Used"].handle._n:setVisible(true)
--			end
--			
--			_childUI["PlayScore_btn"]:setstate(-1)
--			_childUI["playScore"].handle._n:setVisible(false)
--			_childUI["game_coins_btn"]:setstate(-1)
--			_childUI["game_coins"].handle._n:setVisible(false)
--			
--			_childUI["game_coins_image"].handle._n:setVisible(false)
--			_childUI["PlayScore_image"].handle._n:setVisible(false)
--			_childUI["playScore_selectbox"].handle._n:setVisible(false)
--			_childUI["game_coins_selectbox"].handle._n:setVisible(false)
--			_childUI["closebtn"]:setstate(1)
--		elseif state == 2 then
--			_childUI["UI_Card_UnitUpGrade"].handle._n:setVisible(true)
--			_childUI["deleteGrid"].handle._n:setVisible(false)
--			_childUI["UI_skillbook_open"].handle._n:setVisible(false)
--			_childUI["BattlefieldSkillBook_Titel"]:setText(hVar.tab_string["__UPGRADEBFSKILL"])
--			_childUI["BattlefieldSkillBook_Titel_Used"].handle._n:setVisible(false)
--			
--			_childUI["PlayScore_btn"]:setstate(1)
--			_childUI["playScore"].handle._n:setVisible(true)
--			_childUI["game_coins_btn"]:setstate(1)
--			_childUI["game_coins"].handle._n:setVisible(true)
--			
--			_childUI["game_coins_image"].handle._n:setVisible(true)
--			_childUI["PlayScore_image"].handle._n:setVisible(true)
--			_childUI["playScore_selectbox"].handle._n:setVisible(true)
--			_childUI["game_coins_selectbox"].handle._n:setVisible(true)
--			
--			_childUI["PlayScore_btn"].handle._n:setVisible(false)
--			_childUI["game_coins_btn"].handle._n:setVisible(false)
--			_childUI["closebtn"]:setstate(1)
--			--合成卡片的底
--			_BorderFrm.childUI["card_forge"] = hUI.image:new({
--				parent = _BorderFrm.handle._n,
--				model = "UI:card_forge",
--				x = 329,
--				y = -543,
--				z = -1,
--			})
--		else
--			_childUI["btnConfirm"]:setstate(-1)
--			_childUI["PlayScore_btn"]:setstate(-1)
--			_childUI["playScore"].handle._n:setVisible(false)
--			_childUI["game_coins_btn"]:setstate(-1)
--			_childUI["game_coins"].handle._n:setVisible(false)
--			_childUI["game_coins_image"].handle._n:setVisible(false)
--			_childUI["PlayScore_image"].handle._n:setVisible(false)
--			_childUI["playScore_selectbox"].handle._n:setVisible(false)
--			_childUI["game_coins_selectbox"].handle._n:setVisible(false)
--			_childUI["closebtn"]:setstate(-1)
--		end
--		
--	end
--	
--	--创建技能node
--	local _createSkillBookNode = function(name,x,y,skillID,skillLV,num,tab,scale,blink)
--		hApi.safeRemoveT(_childUI,name)
--		if hVar.tab_tactics[skillID] == nil then
--			return print("this tactics skill ID is not available")
--		end
--		local tempMaxLevel = hVar.tab_tactics[skillID].level
--		
--		_childUI[name] = hUI.node:new({
--			parent = _parent,
--			x = x,
--			y = y,
--		})
--		tab[#tab+1] = name
--		
--		--底板
--		_childUI[name].childUI["bg"]= hUI.image:new({
--			parent = _childUI[name].handle._n,
--			model = hApi.GetTacticsCardGB(tempMaxLevel,skillLV),
--			--w = 110,
--			--h = 116.
--		})
--		
--		--类型图标
--		_childUI[name].childUI["typeicon"]= hUI.image:new({
--			parent = _childUI[name].handle._n,
--			model = hApi.GetTacticsCardTypeIcon(skillID,"model"),
--			x = -3,
--			y = 57,
--		})
--		
--		--icon
--		_childUI[name].childUI["icon"]= hUI.image:new({
--			parent = _childUI[name].handle._n,
--			model = hVar.tab_tactics[skillID].icon,
--			y = -10,
--			w = 50,
--			h = 50,
--		})
--		
--		--名字
--		_childUI[name].childUI["info"] = hUI.label:new({
--			parent =_childUI[name].handle._n,
--			y = 28,
--			size = 18,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 400,
--			text = hVar.tab_stringT[skillID][1],
--		})
--		
--		--个数
--		if num then
--			_childUI[name].childUI["num"] = hUI.label:new({
--			parent =_childUI[name].handle._n,
--			x = 40,
--			y = -30,
--			size = 18,
--			align = "MC",
--			border = 1,
--			font = "numWhite",
--			width = 400,
--			text = num,
--		})
--		end
--		
--		--根据 此技能的 最大技能上限 修改 显示技能星星的 坐标样式
--		
--		if tempMaxLevel >= 5 then
--			-- 常规 排列，技能Lv 大于等于5
--			for i = 1,tempMaxLevel do
--				_childUI[name].childUI["Level_star_slot"..i] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (i-1)% 5 * 16,
--					y = -47 - math.ceil((i-5)/5)*16,
--				})
--				_childUI[name].childUI["Level_star_slot"..i].handle.s:setOpacity(100)
--			end
--			
--			for i = 1,skillLV do
--				_childUI[name].childUI["Level_star"..i] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (i-1)% 5 * 16,
--					y = -47 - math.ceil((i-5)/5)*16,
--				})
--				
--				--升级时用的闪烁星星
--				if blink == i then
--					local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.5,1.4,1.4),CCScaleTo:create(0.5,0.8,0.8))
--					local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
--					_childUI[name].childUI["Level_star"..i].handle._n:runAction(forever)
--				end
--			end
--		else
--			local tempStartX = -1* (tempMaxLevel-1)*8
--			--居中显示
--			for i = 1,tempMaxLevel do
--				_childUI[name].childUI["Level_star_slot"..i] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(i-1)*16,
--					y = -47,
--				})
--				_childUI[name].childUI["Level_star_slot"..i].handle.s:setOpacity(100)
--			end
--			
--			for i = 1,skillLV do
--				_childUI[name].childUI["Level_star"..i] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(i-1)*16,
--					y = -47,
--				})
--				
--				--升级时用的闪烁星星
--				if blink == i then
--					local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.5,1.4,1.4),CCScaleTo:create(0.5,0.8,0.8))
--					local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
--					_childUI[name].childUI["Level_star"..i].handle._n:runAction(forever)
--				end
--			end
--		end
--		
--		if scale then 
--			_childUI[name].handle._n:setScale(scale)
--		end
--	end
--	
--	--分解槽子
--	local deleteX,deleteY = 585,-240
--	_childUI["deleteGrid"] = hUI.node:new({
--		parent = _parent,
--		x = deleteX,
--		y = deleteY,
--	})
--	
--	--分解槽图标
--	_childUI["deleteGrid"].childUI["icon"]= hUI.image:new({
--		parent = _childUI["deleteGrid"].handle._n,
--		model = "UI:card2score",
--		y = -22,
--		
--	})
--	
--	--分解文字
--	_childUI["deleteGrid"].childUI["info"] = hUI.label:new({
--		parent =_childUI["deleteGrid"].handle._n,
--		y = -65,
--		size = 20,
--		align = "MC",
--		border = 1,
--		font = hVar.FONTC,
--		width = 400,
--		text = hVar.tab_string["__TEXT_DeleteBFSCard"],
--	})
--	
--	local _IsInDeleteGrid = function(x,y)
--		if deleteX-60<=x and deleteX+60>=x and deleteY+75>=y and deleteY-75<=y then
--			return 1
--		end
--		return 0
--	end
--	local _GetSlotIndexByXY = function(x,y)
--		for i = 1,#_skillbookslotpos do
--			local v = _skillbookslotpos[i]
--			if v.l<=x and v.r>=x and v.t>=y and v.d<=y then
--				--(LuaGetUsedBookState(g_curPlayerName) == 0 or _frmState == 2)
--				return i
--			end
--		end
--		return 0
--	end
--	local _CreateDragImage = function(id,lv,x,y)
--		local maxLv = hVar.tab_tactics[id].level or 1
--		local oImage = hUI.image:new({
--			model = hApi.GetTacticsCardGB(maxLv,lv),
--			align = "MC",
--			mode = "image",
--			x = x,
--			y = y,
--		})
--		hUI.deleteUIObject(hUI.label:new({
--			parent = oImage.handle._n,
--			font = hVar.FONTC,
--			text = hVar.tab_stringT[id][1],
--			align = "MC",
--			x = oImage.data.w/2,
--			y = oImage.data.h/2+26,
--			border = 1,
--		}))
--		hUI.deleteUIObject(hUI.image:new({
--			parent = oImage.handle._n,
--			model = hVar.tab_tactics[id].icon,
--			mode = "image",
--			align = "MC",
--			x = oImage.data.w/2,
--			y = oImage.data.h/2-14,
--			scale = 0.8,
--		}))
--		oImage.handle.s:setScale(0.75)
--		return oImage
--	end
--	local _CreateDragImageA = function(id,lv,nIndex)
--		local x = _skillX + (nIndex-1)%_lenN*_offx
--		local y = _skillY - math.ceil((nIndex-_lenN)/_lenN)*_offy
--		return _CreateDragImage(id,lv,x,y)
--	end
--	
--	--根据服务器 返回的 游戏币值 来设置闭包环境内的 游戏币值
--	local _cur_rmb = 0
--	local _cur_index_page = 1
--	local _max_index_page = 1
--	local _cur_skill_type = 0
--	local _ShowBFSkillInfo = function(id,lv)
--		local x,y = 410,520
--		if g_current_scene == g_world then
--			x,y = 230,500
--		end
--		return hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",id,lv,x,y,1,1,_cur_skill_type)
--	end
--	--用来做选择技能的空按钮
--	for i = 1,_MaxN do
--		_skillbookbtnstate[i] = {0,0,0,0}
--		local btnX = _skillX + (i-1)%_lenN*_offx
--		local btnY = _skillY - math.ceil((i-_lenN)/_lenN)*_offy
--		local hitX,hitY = 0,0
--		local showFlag = 0
--		local lockTick = 0
--		_childUI["skill_book_btn_"..i] = hUI.button:new({
--			parent = _parent,
--			model = -1,
--			w = 120,
--			h = 150,
--			x = btnX,
--			y = btnY,
--			dragbox = _childUI["dragBox"],
--			codeOnTouch = function(self,x,y)
--				hitX = x
--				hitY = y
--				showFlag = 1
--				lockTick = hApi.gametime()+350
--			end,
--			code = function(self)
--				if showFlag==1 then
--					local id,lv = _skillbookbtnstate[i][2],_skillbookbtnstate[i][3]
--					_ShowBFSkillInfo(id,lv)
--				end
--			end,
--			codeOnDrag = function(self,x,y,sus)
--				if showFlag==0 then
--					return
--				elseif lockTick>hApi.gametime() and (x-hitX)^2+(y-hitY)^2<=512 then
--					return
--				end
--				showFlag = 0
--				local curI = i
--				local curS = _skillbookbtnstate[curI]
--				local id,lv,num = curS[2],curS[3],curS[4]
--				if curS[1] == 1 and hVar.tab_tactics[id]~=nil then
--					if _mode=="game" then
--						--游戏中判断这些
--						if _frmState == 1 then
--							--设置战术技能卡片(没设置过才允许这样做)
--							local oImage = _CreateDragImageA(id,lv,i)
--							return hUI.dragBox:new({
--								node = oImage.handle._n,
--								autorelease = 1,
--								codeOnDrop = function(x,y,screenX,screenY)
--									oImage:del()
--									local absX,absY = x-_frm.data.x,y-_frm.data.y
--									local nIndex = _GetSlotIndexByXY(absX,absY)
--									if nIndex>0 then
--										if LuaGetUsedBookState(g_curPlayerName)==0 then
--											hGlobal.LocalPlayer:order(hGlobal.LocalPlayer:getfocusworld(),hVar.OPERATE_TYPE.PLAYER_SETSKILLBOOK,nil,{nIndex,id,lv},nil)
--										end
--									elseif _IsInDeleteGrid(absX,absY)==1 then
--										hGlobal.event:event("LocalEvent_ShowDeleteBFSkillCardFrm",id,lv,i)
--									end
--								end,
--							}):select()
--						elseif _frmState == 2 then
--							--拖拽至升级
--							local oImage = _CreateDragImageA(id,lv,i)
--							return hUI.dragBox:new({
--								node = oImage.handle._n,
--								autorelease = 1,
--								codeOnDrop = function(x,y,screenX,screenY)
--									oImage:del()
--									local absX,absY = x-_frm.data.x,y-_frm.data.y
--									local nIndex = _GetSlotIndexByXY(absX,absY)
--									if nIndex>0 then
--										local count = num
--										if _skillID==id then
--											count = count - 1
--										end
--										for n = 1,#_upgradeSkillSlotList do
--											if _upgradeSkillSlotList[n]~=0 and _upgradeSkillSlotList[n][1]==id then
--												count = count - 1
--											end
--										end
--										if count<=0 then
--											print("你没有那么多相同的卡片")
--											return
--										else
--											_upgradeSkillSlotList[nIndex] = {id,lv}
--											----当本地记录的 技能ID 为合法值时
--											if hVar.tab_tactics[_skillID] then
--												local maxLv = hVar.tab_tactics[_skillID].level
--												local require = hVar.BFSKILL_UPGRADE[maxLv][_conLv]
--												local slotnum,score,gamecoin = require[1],require[2],require[3]
--												--判断付费方式 是 积分 还是 游戏币
--												if _deductType == 1 then
--													if score <= LuaGetPlayerScore() and _checkUpgradeSkill(slotnum,_conLv) == 1 then
--														_childUI["btnConfirm"]:setstate(1)
--													end
--												elseif _deductType == 2 then
--													if type(_cur_rmb) == "number" and gamecoin <= _cur_rmb and _checkUpgradeSkill(slotnum,_conLv) == 1 then
--														_childUI["btnConfirm"]:setstate(1)
--													end
--												end
--											end
--											return hGlobal.event:event("LocalEvent_afterSetSkillBook",nIndex,id,lv,1)
--										end
--									end
--								end,
--							}):select()
--						end
--					else
--						--尝试删除操作
--						local oImage = _CreateDragImageA(id,lv,i)
--						return hUI.dragBox:new({
--							node = oImage.handle._n,
--							autorelease = 1,
--							codeOnDrop = function(x,y,screenX,screenY)
--								oImage:del()
--								local absX,absY = x-_frm.data.x,y-_frm.data.y
--								if _IsInDeleteGrid(absX,absY)==1 then
--									local unique = hVar.tab_tactics[id].unique
--									if unique == 1 then
--										hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tDeleteBFSCard"],{
--											font = hVar.FONTC,
--											ok = 1,
--										})
--									else
--
--										hGlobal.event:event("LocalEvent_ShowDeleteBFSkillCardFrm",id,lv,i)
--									end
--								end
--							end,
--						}):select()
--					end
--				end
--			end,
--		})
--		
--	end
--	
--	--根据当前页数显示战术技能
--	local _showpageskill = function(curIndx,maxIndex,skillList)
--		for i = 1,#_skillbooklist do
--			hApi.safeRemoveT(_childUI,_skillbooklist[i])
--		end
--		_skillbooklist = {}
--		
--		for i = 1,_MaxN do
--			_skillbookbtnstate[i] = {0,0,0,0}
--		end
--		--设置当前页数
--		_childUI["Page_Label"]:setText(curIndx.."/"..maxIndex)
--		
--		--根据当前页数显示是否继续显示下一页或者上一页
--		_childUI["Page_Up"]:setstate(1)
--		_childUI["Page_Down"]:setstate(1)
--
--		if 1 == maxIndex or 0 == maxIndex then
--			_childUI["Page_Up"]:setstate(0)
--			_childUI["Page_Down"]:setstate(0)
--		elseif curIndx == 1 then
--			_childUI["Page_Up"]:setstate(0)
--		elseif curIndx == maxIndex then
--			_childUI["Page_Down"]:setstate(0)
--		end
--
--		for i = 1,#skillList do
--			if type(skillList[i])=="table" then
--				_skillbookbtnstate[i][1] = 1
--				_skillbookbtnstate[i][2] = skillList[i][1]
--				_skillbookbtnstate[i][3] = skillList[i][2]
--				_skillbookbtnstate[i][4] = skillList[i][3]
--				_createSkillBookNode("node_item_"..i,_skillX + (i-1)%_lenN*_offx,_skillY - math.ceil((i-_lenN)/_lenN)*_offy,skillList[i][1],skillList[i][2],skillList[i][3],_skillbooklist)
--			else
--				_skillbookbtnstate[i][1] = 0
--				_skillbookbtnstate[i][2] = 0
--				_skillbookbtnstate[i][3] = 0
--				_skillbookbtnstate[i][4] = 0
--			end
--		end
--	end
--	
--	--根据技能类型筛选当前需要显示的技能
--	local _showindexskill = function(index)
--		_cur_skill_type = index
--		_cur_index_page ,_max_index_page = 1
--		_childUI["Page_Up"]:setstate(1)
--		_childUI["Page_Down"]:setstate(1)
--		local skillList ,max_index_page = _getIndexSkillList(_cur_skill_type,_cur_index_page,_conMaxLv,_conLv,_skillID)
--		_max_index_page = max_index_page
--		_showpageskill(_cur_index_page,_max_index_page,skillList)
--		_setBtnState(_childUI["soldier_style_".._cur_skill_type])
--	end
--	
--	--技能种类标签页
--	--一共#hVar.SOLDIERLABTXT个分类
--	local btnNum = #hVar.SOLDIERLABTXT
--	for i = 1,btnNum do
--		_childUI["soldier_style_"..i] = hUI.button:new({
--			parent = _parent,
--			--model = "UI:button_back",
--			w = 75,
--			h = 40,
--			dragbox = _childUI["dragBox"],
--			label = hVar.tab_string[hVar.SOLDIERLABTXT[i]],
--			font = hVar.FONTC,
--			border = 1,
--			x = _btnX - (btnNum-i) * 75,
--			y = _btnY,
--			code = function(self)
--				_showindexskill(i)
--			end,
--		})
--		_Btnlist[#_Btnlist+1] = "soldier_style_"..i
--	end
--	
--	--当前的页数显示
--	_childUI["Page_Label"] = hUI.label:new({
--		parent = _parent,
--		size = 26,
--		align = "MC",
--		font = hVar.FONTC,
--		x = 60,
--		y = _btnY,
--		size = 20,
--		width = 450,
--		text = "1/1",
--		border = 1,
--	})
--	
--	--左右翻页按钮
--	_childUI["Page_Up"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:button_resumeL",
--		dragbox = _childUI["dragBox"],
--		x = 25,
--		y = _btnY+4,
--		scaleT = 0.9,
--		scale = 0.8,
--		code = function(self)
--			if _cur_index_page == 1 then return end
--			_cur_index_page = _cur_index_page - 1
--			local skillList ,_ = _getIndexSkillList(_cur_skill_type,_cur_index_page,_conMaxLv,_conLv)
--			_showpageskill(_cur_index_page,_max_index_page,skillList)
--		end,
--	})
--	
--	_childUI["Page_Down"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:button_resumeR",
--		dragbox = _childUI["dragBox"],
--		x = 99,
--		y = _btnY+4,
--		scaleT = 0.9,
--		scale = 0.8,
--		code = function(self)
--			if _cur_index_page == _max_index_page then return end
--			_cur_index_page = _cur_index_page + 1
--			local skillList ,_ = _getIndexSkillList(_cur_skill_type,_cur_index_page,_conMaxLv,_conLv)
--			_showpageskill(_cur_index_page,_max_index_page,skillList)
--		end,
--	})
--	
--	local _showOtherItem = function(bool)
--		_childUI["apartline_back"].handle._n:setVisible(bool)
--		_childUI["apartline_back1"].handle._n:setVisible(bool)
--		_childUI["BattlefieldSkillBook_Titel"].handle._n:setVisible(bool)
--	end
--	
--	--根据参数创建槽子
--	local _cur_solt_state = 0
--	local _createSkillSolt = function(num,px,py,scale,offx,dragCode,hitCode)
--		for i = 1,#_skillbookslot do
--			hApi.safeRemoveT(_childUI,_skillbookslot[i])
--		end
--		_skillbookslot = {}
--		for i = 1,num do
--			local xx,yy = px -num *offx/2 + (i-1)*offx,-(py +90)
--			_skillbookslot[i] = "node_item_btn_"..i
--			_skillbookslotpos[i] = {l = xx - 55,t = yy + 58,r = xx + 55,d = yy - 58,x = xx,y = yy}
--			local codeOnTouch
--			local codeOnRelease
--			local codeOnDrag
--			if type(dragCode)=="function" then
--				local hitX,hitY = 0,0
--				local showFlag = 0
--				local lockTick = 0
--				codeOnTouch = function(self,x,y)
--					hitX = x
--					hitY = y
--					showFlag = 1
--					lockTick = hApi.gametime()+350
--				end
--				codeOnDrag = function(self,x,y,sus)
--					if showFlag==0 then
--						return
--					elseif lockTick>hApi.gametime() and (x-hitX)^2+(y-hitY)^2<=512 then
--						return
--					end
--					showFlag = 0
--					return dragCode(self)
--				end
--				if type(hitCode)=="function" then
--					codeOnRelease = function(self,x,y,sus)
--						if showFlag==1 then
--							return hitCode(self)
--						end
--					end
--				end
--			elseif type(hitCode)=="function" then
--				codeOnTouch = hitCode
--			end
--			_childUI["node_item_btn_"..i] = hUI.button:new({
--				parent = _parent,
--				model = "UI:tactic_slot",
--				userdata = i,
--				x = xx,
--				y = yy,
--				scale = scale or 1,
--				dragbox = _childUI["dragBox"],
--				code = codeOnRelease,
--				codeOnTouch = codeOnTouch,
--				codeOnDrag = codeOnDrag,
--			})
--		end
--		
--		local activeskill = LuaGetActiveBattlefieldSkill()
--		if type(activeskill) == "table" and _frmState == 1 then
--			for i = 1,#activeskill do
--				local xx,yy = px -num *offx/2 + (i-1)*offx,-(py +90)
--				if type(activeskill[i]) == "table" then
--					_createSkillBookNode("play_skill_"..i,xx,yy,activeskill[i][1],activeskill[i][2],nil,_skillbookslot)
--				end
--			end
--		end
--	end
--
----------------------------------------------------------------------------------
--	--检测已激活的战术技能 是否为可以 使用 确定按钮的状态
--	local _checkSkillBookSlotState = function()
--		--取激活技能表长度 对当前技能槽进行判断
--		local activeskill = LuaGetActiveBattlefieldSkill()
--		local rs = 0
--		if type(activeskill) == "table" and _frmState == 1 then
--			for i = 1,#activeskill do
--				if type(activeskill[i]) == "table" then
--					rs = rs + 1
--				end
--			end
--		end
--		--如果有激活的技能则返回1 否则返回0
--		if rs > 0 then
--			return 1
--		else
--			return 0
--		end
--	end
--	--设置完成后的监听
--	hGlobal.event:listen("LocalEvent_afterSetSkillBook","_aftersetskillbook",function(index,skillID,skillLv,scale)
--		--当只有在 卡片设置界面时候
--		if _frmState == 1 then
--			--如果有激活技能
--			if _checkSkillBookSlotState() == 1 then
--				_childUI["btnConfirm"]:setstate(1)
--			else
--				_childUI["btnConfirm"]:setstate(0)
--			end
--		end
--
--		if type(_skillbookslot[index])=="string" and _frm.data.show==1 then
--			if skillID==0 then
--				hApi.safeRemoveT(_childUI,"play_skill_"..index)
--			else
--				local x,y = _childUI[_skillbookslot[index]].data.x,_childUI[_skillbookslot[index]].data.y
--				_createSkillBookNode("play_skill_"..index,x,y,skillID,skillLv,nil,_skillbookslot,scale)
--			end
--		end
--		
--		
--	end)
-------------------------------------------------------------------------------------------------------------------------------
--	hGlobal.event:listen("LocalEvent_SetCurGameCoin","setcurgamecoin4",function(cur_rmb) 
--		_cur_rmb = cur_rmb
--		if hVar.tab_tactics[_skillID] and _conLv ~= 0 then
--			local maxLv = hVar.tab_tactics[_skillID].level
--			local require = hVar.BFSKILL_UPGRADE[maxLv][_conLv]
--			if type(require) == "table" then
--				local slotnum,score,gamecoin = unpack(require)
--				
--				if type(_cur_rmb) == "number" and gamecoin > _cur_rmb then
--					_childUI["game_coins"].handle.s:setColor(ccc3(255,0,0))
--				else
--					_childUI["game_coins"].handle.s:setColor(ccc3(255,255,255))
--				end
--			end
--		end
--	end)
--	--关闭当前激活的技能槽子 和 技能
--	local _CloseActiveSkill = function()
--		for i = 1,#_skillbookslot do
--			hApi.safeRemoveT(_childUI,_skillbookslot[i])
--			hApi.safeRemoveT(_childUI,"play_skill_"..i)
--		end
--		_skillbookslot = {}
--		
--		for i = 1,#_upgradeSkillList do
--			hApi.safeRemoveT(_childUI,_upgradeSkillList[i])
--		end
--		_upgradeSkillList = {}
--	end
--	
--	
--	local _upSkillX,_upSkillY = 91,-471
--	local _upSkillInfoX,_upSkillInfoY = 470,360
--	
--	local _scoreLabX,_scoreLabY = 200,-510
--	--积分图片
--	_childUI["PlayScore_image"] = hUI.image:new({
--		model = "UI:score",
--		parent = _parent,
--		x = _scoreLabX + 35,
--		y = _scoreLabY - 45,
--		scale = 0.5,
--	})
--	
--	_childUI["PlayScore_btn"] = hUI.button:new({
--		parent = _parent,
--		--model = -1,
--		x = _scoreLabX + 45,
--		y = _scoreLabY - 45,
--		w = 180,
--		dragbox = _childUI["dragBox"],
--		code = function(self)
--			local require = hVar.BFSKILL_UPGRADE[_conMaxLv][_conLv]
--			local slotnum,score,gamecoin = unpack(require)
--			_deductType = 1
--			if score <= LuaGetPlayerScore() and _checkUpgradeSkill(slotnum,_conLv) == 1 then
--				_childUI["btnConfirm"]:setstate(1)
--			else
--				_childUI["btnConfirm"]:setstate(0)
--			end
--			
--			_childUI["selectbox_finish"].handle._n:setPosition(self.data.x-55,self.data.y)
--			_childUI["selectbox_finish"].handle._n:setVisible(true)
--			_childUI["selectbox_finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.6,0.6),CCScaleTo:create(0.05,0.9,0.9)))
--		end,
--	})
--	
--	--玩家积分lab
--	_childUI["playScore"] = hUI.label:new({
--		parent = _parent,
--		size = 26,
--		align = "LT",
--		font = hVar.FONTC,
--		x = _scoreLabX + 65,
--		y = _scoreLabY - 32,
--		width = 540,
--		text = "",
--	})
--	
--	--积分的选择框
--	_childUI["playScore_selectbox"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:Button_SelectBorder",
--		x = _scoreLabX - 10,
--		y = _scoreLabY - 45,
--		scale = 0.4,
--		
--	})
--	
--	--游戏币图片
--	_childUI["game_coins_image"] = hUI.image:new({
--		model = "UI:game_coins",
--		parent = _parent,
--		x = _scoreLabX + 215,
--		y = _scoreLabY - 45,
--		scale = 0.8,
--	})
--	
--	_childUI["game_coins_btn"] = hUI.button:new({
--		parent = _parent,
--		--model = -1,
--		x = _scoreLabX + 225,
--		y = _scoreLabY - 45,
--		w = 180,
--		dragbox = _childUI["dragBox"],
--		code = function(self)
--			local require = hVar.BFSKILL_UPGRADE[_conMaxLv][_conLv]
--			local slotnum,score,gamecoin = unpack(require)
--			_deductType = 2
--			if type(_cur_rmb) == "number" and gamecoin <= _cur_rmb and _checkUpgradeSkill(slotnum,_conLv) == 1 then
--				_childUI["btnConfirm"]:setstate(1)
--			else
--				_childUI["btnConfirm"]:setstate(0)
--			end
--			
--			_childUI["selectbox_finish"].handle._n:setPosition(self.data.x-55,self.data.y)
--			_childUI["selectbox_finish"].handle._n:setVisible(true)
--			_childUI["selectbox_finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.6,0.6),CCScaleTo:create(0.05,0.9,0.9)))
--		end,
--	})
--	
--	--游戏币的选择框
--	_childUI["game_coins_selectbox"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:Button_SelectBorder",
--		x = _scoreLabX + 170,
--		y = _scoreLabY - 45,
--		scale = 0.4,
--	})
--	
--	--选中的特效
--	_childUI["selectbox_finish"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:finish",
--		scale = 0.9,
--	})
--	_childUI["selectbox_finish"].handle._n:setVisible(false)
--	
--	
--	--积分和余额信息
--	_childUI["game_coins"] = hUI.label:new({
--		parent = _parent,
--		size = 26,
--		align = "LT",
--		font = hVar.FONTC,
--		x = _scoreLabX + 245,
--		y = _scoreLabY - 32,
--		width = 400,
--		text = "",
--	})
--	
--	--升级的卡片查看信息
--	_childUI["upgrade_skillInfo_btn"] = hUI.button:new({
--		parent = _parent,
--		model = -1,
--		x = _upSkillX,
--		y = _upSkillY,
--		w = 125,
--		h = 150,
--		dragbox = _childUI["dragBox"],
--		code = function(self)
--			if hVar.tab_tactics[_skillID] == nil or _conLv == 0 then return end
--			hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",_skillID,_conLv+1,300,600,1,0)
--		end,
--	})
--	
--	local _CodeOfDragUpgradeBFSkill = function(self)
--		local id,lv = 0,0
--		local curS = _upgradeSkillSlotList[self.data.userdata]
--		if type(curS)=="table" then
--			id = curS[1]
--			lv = curS[2]
--		end
--		if id>0 and lv>0 then
--			local oImage = _CreateDragImage(id,lv,curS.x,curS.y)
--			return hUI.dragBox:new({
--				node = oImage.handle._n,
--				autorelease = 1,
--				codeOnDrop = function(x,y,screenX,screenY)
--					oImage:del()
--					local absX,absY = x-_frm.data.x,y-_frm.data.y
--					local nIndex = _GetSlotIndexByXY(absX,absY)
--					if nIndex~=self.data.userdata then
--						_upgradeSkillSlotList[self.data.userdata] = 0
--						_childUI["btnConfirm"]:setstate(0)
--						return hGlobal.event:event("LocalEvent_afterSetSkillBook",self.data.userdata,0,0,1)
--					end
--				end,
--			}):select()
--		end
--	end
--	local _CodeOfShowUpgradeBFSkill = function(self,x,y)
--		local id,lv = 0,0
--		local curS = _upgradeSkillSlotList[self.data.userdata]
--		if type(curS)=="table" then
--			id = curS[1]
--			lv = curS[2]
--		end
--		if id>0 and lv>0 then
--			_ShowBFSkillInfo(id,lv)
--		end
--	end
--	
--	local _createUpgradeSkillInfo = function(skillID,skillLv)
--		if hVar.tab_tactics[skillID] == nil then return end -- 数据合法检测 
--		local maxLv = hVar.tab_tactics[skillID].level
--		local require = hVar.BFSKILL_UPGRADE[maxLv][skillLv]
--		if type(require) ~= "table" then print("hVar.BFSKILL_UPGRADE haven't "..tostring(skillID).." info") return end
--		_childUI["upgrade_skillInfo_btn"]:setstate(1)
--		local slotnum,score,gamecoin = unpack(require)
--		_conMaxLv,_conLv = maxLv,skillLv
--		_skillID = skillID
--		--首先是创建需要升级的信息
--		_createSkillBookNode("upgrade_skill_info",_upSkillX,_upSkillY,skillID,skillLv+1,nil,_upgradeSkillList,nil,skillLv+1)
--		
--		_childUI["playScore"]:setText(tostring(score))
--		_childUI["game_coins"]:setText(tostring(gamecoin))
--		
--		--创建槽子
--		_createSkillSolt(slotnum,_upSkillInfoX,_upSkillInfoY,1,_offx,_CodeOfDragUpgradeBFSkill,_CodeOfShowUpgradeBFSkill)
--		
--		--余额判断 不足 则显示红色
--		if score > LuaGetPlayerScore() then
--			_childUI["playScore"].handle.s:setColor(ccc3(255,0,0))
--		else
--			_childUI["playScore"].handle.s:setColor(ccc3(255,255,255))
--		end
--		
--		if type(_cur_rmb) ~= "number" or gamecoin > _cur_rmb then
--			_childUI["game_coins"].handle.s:setColor(ccc3(255,0,0))
--		else
--			_childUI["game_coins"].handle.s:setColor(ccc3(255,255,255))
--		end
--	end
--	
--	local _after_up_skill_type = 0
--	--显示升级面板
--	hGlobal.event:listen("localEvent_ShowBFSkillCardUpgradeFrm","closeActiveSkillFrm",function(skillID,skillLv,skill_type)
--		_childUI["playScore"]:setText("")
--		_childUI["game_coins"]:setText("")
--		
--		local curPage = _cur_skill_type
--		if curPage<=0 then
--			curPage = 1
--		end
--		_after_up_skill_type = skill_type
--		--清空升级战术技能的卡片信息表
--		_upgradeSkillSlotList = {} 
--		
--		--清空激活技能信息
--		_CloseActiveSkill()
--		
--		--修改界面显示
--		_setFrmState(2)
--		
--		--创建升级技能信息
--		_createUpgradeSkillInfo(skillID,skillLv)
--		
--		--创建删选过的卡片
--		_showindexskill(curPage)
--	end)
--	
--	--确定按钮
--	_childUI["btnConfirm"] = hUI.button:new({
--		parent = _parent,
--		--model = "UI:ConfimBtn",
--		label = hVar.tab_string["__TEXT_Confirm"],
--		dragbox = _frm.childUI["dragBox"],
--		x = _w - 80,
--		y = -_h - 185,
--		scaleT = 0.9,
--		scale = 0.9,
--		code = function(self)
--			--如果当前面板状态为设置战术技能 
--			self:setstate(0)
--			if _frmState == 1 then
--				if LuaGetUsedBookState(g_curPlayerName) == 0 then
--					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BattlefieldSkill_Confirm"],{
--						font = hVar.FONTC,
--						ok = function()
--							_frm:show(0)
--							_BorderFrm:show(0)
--							_exitFunc()
--							LuaSetUsedBookState(g_curPlayerName,1)
--							LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--							hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",0)
--							hGlobal.event:event("LocalEvent_ReloadTacticsCard",1)
--						end,
--						cancel = hVar.tab_string["__TEXT_Cancel"],
--					})
--				else
--					_frm:show(0)
--					_BorderFrm:show(0)
--					_exitFunc()
--				end
--				
--			--升级卡片
--			elseif _frmState == 2 then
--				local require = hVar.BFSKILL_UPGRADE[_conMaxLv][_conLv]
--				local slotnum,score,gamecoin,shopID = unpack(require)
--				
--				
--				if _deductType == 1 then
--					local tagStr = "id:".._skillID..";ml:".._conMaxLv..";lv:".._conLv..";sc:"..score..";"
--					--SendCmdFunc["buy_shopitem"](11,0,hVar.tab_string["__TEXT_SynthesisOfCard"],score,tagStr)
--					SendCmdFunc["order_begin"](6,11,gamecoin,1,hVar.tab_string["__TEXT_SynthesisOfCard"],score,0,tagStr)
--				else
--					local tagStr = "id:".._skillID..";ml:".._conMaxLv..";lv:".._conLv..";sc:0;"
--					--SendCmdFunc["buy_shopitem"](shopID,gamecoin,hVar.tab_string["__TEXT_SynthesisOfCard"],0,tagStr)
--					SendCmdFunc["order_begin"](6,shopID,gamecoin,1,hVar.tab_string["__TEXT_SynthesisOfCard"],0,0,tagStr)
--				end
--			end
--		end,
--	})
--	
--	_childUI["closebtn"] = hUI.button:new({
--		parent = _parent,
--		model = "BTN:PANEL_CLOSE",
--		dragbox = _frm.childUI["dragBox"],
--		x = _w,
--		y = 60,
--		scaleT = 0.9,
--		code = function(self)
--			_frm:show(0)
--			_BorderFrm:show(0)
--			_exitFunc()
--			if LuaGetUsedBookState(g_curPlayerName) == 0 then
--				LuaClearActiveBattlefieldSkill()
--			end
--		end,
--	})
--
--------------------------------------------------------------------------------------------------------------------------------
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","closeBattlefieldSkillBook",function(sSceneType,oWorld,oMap)
--		_frm:show(0)
--		_BorderFrm:show(0)
--		_exitFunc()
--	end)
--	
--	local _GetActivedBFSkillID = function(nIndex)
--		if type(nIndex)=="number" and nIndex>0 and Save_PlayerData and Save_PlayerData.activebattlefieldskill and type(Save_PlayerData.activebattlefieldskill[nIndex])=="table" then
--			local id = Save_PlayerData.activebattlefieldskill[nIndex][1]
--			local lv = Save_PlayerData.activebattlefieldskill[nIndex][2]
--			return id,lv
--		end
--		return 0,0
--	end
--	
--	local _CodeOfDragActivedBFSkill = function(self)
--		local id,lv = _GetActivedBFSkillID(self.data.userdata)
--		local curS = _skillbookbtnstate[self.data.userdata]
--		if id>0 and lv>0 and curS then
--			local oImage = _CreateDragImage(id,lv,curS.x,curS.y)
--			return hUI.dragBox:new({
--				node = oImage.handle._n,
--				autorelease = 1,
--				codeOnDrop = function(x,y,screenX,screenY)
--					oImage:del()
--					local absX,absY = x-_frm.data.x,y-_frm.data.y
--					local nIndex = _GetSlotIndexByXY(absX,absY)
--					if nIndex>0 then
--						hGlobal.LocalPlayer:order(hGlobal.LocalPlayer:getfocusworld(),hVar.OPERATE_TYPE.PLAYER_SETSKILLBOOK,nil,{nIndex,id,lv},nil)
--					else
--						hGlobal.LocalPlayer:order(hGlobal.LocalPlayer:getfocusworld(),hVar.OPERATE_TYPE.PLAYER_SETSKILLBOOK,nil,{self.data.userdata,0,0},nil)
--					end
--				end,
--			}):select()
--		end
--	end
--	local _CodeOfShowActivedBFSkill = function(self,x,y)
--		local id,lv = _GetActivedBFSkillID(self.data.userdata)
--		if id>0 and lv>0 then
--			_ShowBFSkillInfo(id,lv)
--		end
--	end
--	local _showActivedBFSkill = function()
--		local soltnum = hVar.PLAYER_ACTIVED_BFSKILL_NUM
--		if LuaGetUsedBookState(g_curPlayerName) == 0 then
--			_createSkillSolt(soltnum,350,_h+20,1,_offx,_CodeOfDragActivedBFSkill,_CodeOfShowActivedBFSkill)
--		else
--			_createSkillSolt(soltnum,350,_h+20,1,_offx,nil,_CodeOfShowActivedBFSkill)
--		end
--	end
--	
--	--打开技能书界面
--	hGlobal.event:listen("localEvent_ShowBattlefieldSkillBook","showBattlefieldSkillBook",function(isshow,mode,x,y)
--		_childUI["BattlefieldSkillBook_Titel_Used"].handle._n:setVisible(false)
--		_mode = mode
--		_childUI["closebtn"]:setstate(-1)
--		_childUI["upgrade_skillInfo_btn"]:setstate(-1)
--		_frm:show(isshow)
--		if isshow == 1 then
--			--打开默认的技能表
--			_frm:setXY(x or _x,y or _y)
--			if mode == "playerCard" then
--				_setFrmState(0)
--				--分界线
--				_showOtherItem(false)
--				_frm:active(1)
--			elseif mode == "game" then
--				_setFrmState(1)
--				_showActivedBFSkill()
--				_BorderFrm:setXY((x or _x) - 5,(y or _y)+70)
--				_BorderFrm:show(1)
--				_showOtherItem(true)
--				_frm:active(2)
--			end
--			_showindexskill(1)
--		end
--	end)
--	
--	--分解卡片后的监听 主要用来播放一个 短暂的特效
--	local break_down_eff_list = {}
--	hGlobal.event:listen("localEvent_afterDeleteBFSkillCard","afterDeleteBFSkillCard_Synthesis",function(index,soltNum,tagStr)
--		for i = 1,#break_down_eff_list do
--			hApi.safeRemoveT(_childUI,break_down_eff_list[i])
--		end
--		break_down_eff_list = {}
--		
--		local maxLv,curLv,skillID = _conMaxLv,_conLv,_skillID
--		
--		--保留字符串 如果存在 则进行解析 这块功能必须要等外网服务器更新以后才能生效
--		if type(tagStr) == "string" and string.find(tagStr,"id:") and string.find(tagStr,"ml:") and string.find(tagStr,"lv:") and string.find(tagStr,"sc:") then
--			local tempStr = {}
--			for tagStr in string.gfind(tagStr,"([^%;]+);+") do
--				tempStr[#tempStr+1] = tagStr
--			end
--			--技能id
--			skillID = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"id:")+3,string.len(tempStr[1])))
--			
--			--最大技能等级
--			maxLv = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"ml:")+3,string.len(tempStr[2])))
--			--当前技能等级
--			curLv = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"lv:")+3,string.len(tempStr[3])))
--		end
--		
--		
--		local tempX,tempY = {},{}
--		local num = 1
--		if type(index) == "number" then
--			tempX[1],tempY[1] = _skillX + (index-1)%_lenN*_offx,_skillY - math.ceil((index-_lenN)/_lenN)*_offy
--		elseif index == nil and type(soltNum) == "number" then
--			--这里要写一段 邪恶的代码， 因为 购买流程不能添加过多的参数，导致 11号 被判断为合成卡片付费，于是乎 用本闭包全局 技能id 来判断需要那几张卡..
--			--上面这段注释 已经是过去式了... 因为购买东西 增加了 一个 tag string 以后 需要的 参数 都是脚本自己传自己 解析了 
--			if soltNum == 11 then
--				local require = hVar.BFSKILL_UPGRADE[maxLv][curLv]
--				local slotnum,score,gamecoin = unpack(require)
--				num = slotnum
--			else
--				num = soltNum
--			end
--			
--			for i = 1,num do
--				tempX[i],tempY[i] = _childUI[_skillbookslot[i]].data.x,_childUI[_skillbookslot[i]].data.y
--			end
--		end
--		
--		for i = 1,num do
--			_childUI["break_down_eff_"..i] =hUI.image:new({
--				parent = _parent,
--				model = "MODEL_EFFECT:break_down",
--				x = tempX[i],
--				y = tempY[i],
--				w = 180,
--				h = 180,
--			})
--			break_down_eff_list[#break_down_eff_list+1] = "break_down_eff_"..i
--		end
--		
--		hApi.addTimerOnce("break_down_eff",550,function()
--			for i = 1,#break_down_eff_list do
--				hApi.safeRemoveT(_childUI,break_down_eff_list[i])
--			end
--			break_down_eff_list = {}
--			_showindexskill(_cur_skill_type)
--			
--			--升级的动画， 需要通过事件回调做 卡片删除和 添加
--			if index == nil and type(soltNum) == "number" then
--				hGlobal.event:event("localEvent_afterUpgradeBFSkillCard",skillID,curLv)
--			end
--		end)
--		
--		if g_current_scene == g_playerlist then
--			hGlobal.event:event("LocalEvent_SetCurGameScore")
--		end
--	end)
--	
--	--在升级以后 处理获得卡片 以及删除卡片的事
--	
--	hGlobal.event:listen("localEvent_afterUpgradeBFSkillCard","afterUpgradeBFSkillCard",function(skillID,skillLv)
--		local maxLv = hVar.tab_tactics[skillID].level
--		local require = hVar.BFSKILL_UPGRADE[maxLv][skillLv]
--		local slotnum,score,gamecoin = require[1],require[2],require[3]
--		--合法的升级
--		if skillLv+1<= maxLv then
--			local UpgradeSus = 1
--			local tCardDel = {}
--			for i = 1,slotnum do
--				if type(_upgradeSkillSlotList[i])=="table" and _upgradeSkillSlotList[i][2]==skillLv then
--					tCardDel[#tCardDel+1] = _upgradeSkillSlotList[i]
--					if LuaResolveBFSkillCount(_upgradeSkillSlotList[i][1],_upgradeSkillSlotList[i][2],1)==0 then
--						UpgradeSus = 0
--						break
--					else
--						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					end
--				else
--					UpgradeSus = 0
--					break
--				end
--			end
--			if UpgradeSus==1 then
--				--成功升级
--				LuaResolveBFSkillCount(skillID,skillLv,1)
--				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--				hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{skillID,skillLv+1}},nil,nil,1)
--			else
--				--升级失败了，把卡片在加回去
--				--先不加
--			end
--		end
--		--删除创建的升级卡片
--		_CloseActiveSkill()
--		_setFrmState(1)
--		_showActivedBFSkill()
--		if _after_up_skill_type == 0 then
--			_after_up_skill_type = 1
--		end
--		_showindexskill(_after_up_skill_type)
--	end)
--end

--
----分解卡片的提示面板
--hGlobal.UI.InitDeleteBattlefieldSkillFrm = function()
--	local _x,_y,_h,_w = 250,550,370,520
--	hGlobal.UI.DeleteBattlefieldSkillFrm = hUI.frame:new({
--		x = _x,
--		y = _y,
--		dragable = 2,
--		w = _w,
--		h = _h,
--		titlebar = 0,
--		show = 0,
--		bgAlpha = 0,
--		bgMode = "tile",
--		background = "UI:tip_item",
--		border = 1,
--		autoactive = 0,
--	})
--	
--	local _frm = hGlobal.UI.DeleteBattlefieldSkillFrm
--	local _parent = _frm.handle._n
--	local _childUI = _frm.childUI
--	
--	local _NNUM,_NMAX = 1,2
--	local _uNum = {0,0}
--	local _bar,_num
--	
--	local _exitFun = function()
--		_frm:show(0)
--		hApi.safeRemoveT(_childUI,"node_item")
--	end
--	
--	--创建战术技能信息
--	local _createBattlefieldSkillInfo = function(skillID,skillLv)
--		_childUI["node_item"] = hUI.node:new({
--			parent = _parent,
--			x = 140,
--			y = -140,
--		})
--		
--		local maxLevel = hVar.tab_tactics[skillID].level or 1
--		--底板
--		_childUI["node_item"].childUI["bg"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hApi.GetTacticsCardGB(maxLevel,skillLv),
--			--w = 110,
--			--h = 116.
--		})
--		
--		--类型图标
--		_childUI["node_item"].childUI["typeicon"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hApi.GetTacticsCardTypeIcon(skillID,"model"),
--			x = -3,
--			y = 57,
--		})
--		
--		--icon
--		_childUI["node_item"].childUI["icon"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hVar.tab_tactics[skillID].icon,
--			y = -10,
--			w = 50,
--			h = 50,
--		})
--		
--		--名字
--		_childUI["node_item"].childUI["info"] = hUI.label:new({
--			parent =_childUI["node_item"].handle._n,
--			y = 28,
--			size = 18,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 400,
--			text = hVar.tab_stringT[skillID][1],
--		})
--		
--		
--		for i = 1,maxLevel do
--			_childUI["node_item"].childUI["Level_star_slot"..i] = hUI.image:new({
--				parent = _childUI["node_item"].handle._n,
--				model = "UI:HERO_STAR",
--				x = -32 + (i-1)% 5 * 16,
--				y = -47 - math.ceil((i-5)/5)*16,
--			})
--			_childUI["node_item"].childUI["Level_star_slot"..i].handle.s:setOpacity(100)
--		end
--		
--		--等级
--		for i = 1,skillLv do
--			_childUI["node_item"].childUI["Level_star"..i] = hUI.image:new({
--				parent = _childUI["node_item"].handle._n,
--				model = "UI:HERO_STAR",
--				x = -32 + (i-1)% 5 * 16,
--				y = -47 - math.ceil((i-5)/5)*16,
--			})
--		end
--	end
--	
--	--转化箭头
--	_childUI["deleteArrow"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:UI_Arrow",
--		x = _w/2+10,
--		y = -140,
--	})
--	
--	--积分图标
--	_childUI["scoreImg"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:score",
--		x = _w - 140,
--		y = -120,
--		scale = 0.8,
--	})
--	
--	--分解可得的积分信息
--	_childUI["2ScoreInfo"] =  hUI.label:new({
--		parent = _parent,
--		x = _w - 145,
--		y = -180,
--		text = "",
--		size = 30,
--		width = _w-64,
--		font = hVar.FONTC,
--		align = "MC",
--		border = 1,
--	})
--	
--	--拖拽条
--	_childUI["delete_bar"] = hUI.valbar:new({
--		parent = _parent,
--		model = "UI:ValueBar",
--		back = {model = "UI:ValueBar_Back",x=0,y=0,w=360,h=36},
--		w = 360,
--		h = 36,
--		x = 80,
--		y = -240,
--		align = "LT",
--	})
--	_bar = _childUI["delete_bar"]
--	_bar:setV(160,360)
--	
--	_childUI["scrollBtn"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:scrollBtn",
--	})
--	
--	--拖拽条上显示的数字
--	_childUI["delete_labNum"] = hUI.label:new({
--		parent = _parent,
--		font = "numWhite",
--		size = 18,
--		text = "",
--		align = "MC",
--		x = _bar.data.x+_bar.data.w/2,
--		y = _bar.data.y-_bar.data.h/2,
--	})
--	_num = _childUI["delete_labNum"]
--	
--	local _skillID,_skillLv,_index = 0,0,0
--	local _set2ScoreInfo = function()
--		local skillMaxLv = hVar.tab_tactics[_skillID].level or 1
--		local score = hVar.BFSKILL2SOCRE[skillMaxLv][_skillLv]
--		_childUI["2ScoreInfo"]:setText(tostring(score*_uNum[_NNUM]))
--	end
--	
--	--缩放条操作时的函数
--	local _barOffX,_barOffY = _bar.data.x + 5,_bar.data.y -11
--	local _scorllFunc = function(self,x)
--		x = math.min(360,math.max(0,x-self.data.x))
--		_bar:setV(x,360)
--		local tempX = x
--		if tempX > 350 then tempX = 350 end
--		_childUI["scrollBtn"].handle._n:setPosition(tempX+_barOffX,_barOffY)
--		_uNum[_NNUM] = math.ceil(_uNum[_NMAX]*x/_bar.data.w)
--		if _uNum[_NNUM] < 1 then
--			_uNum[_NNUM] = 1
--		end
--		_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
--		_set2ScoreInfo()
--	end
--	
--	
--	_childUI["delete_btnScorll"] = hUI.button:new({
--		parent = _parent,
--		mode = "imageButton",
--		dragbox = _frm.childUI["dragBox"],
--		model = "MODEL:Default",
--		w = _bar.data.w,
--		h = 32,
--		x = _bar.data.x,
--		y = _bar.data.y,
--		align = "LT",
--		failcall = 1,
--		codeOnTouch = function(self,x,y,sus)
--			if _uNum[_NNUM]>0 then
--				_scorllFunc(self,x)
--			end
--		end,
--		codeOnDrag = function(self,x,y,sus)
--			if _uNum[_NNUM]>0 then
--				_scorllFunc(self,x)
--			end
--		end,
--	})
--	_childUI["delete_btnScorll"].handle.s:setVisible(false)
--	
--	--拖拽条左箭头
--	_childUI["delete__btnMinus"] = hUI.button:new({
--		parent = _parent,
--		mode = "imageButton",
--		dragbox = _frm.childUI["dragBox"],
--		model = "UI:btnMinus",
--		animation = "L",
--		w = 32,
--		h = 32,
--		x = _bar.data.x-20,
--		y = _bar.data.y-16,
--		scaleT = 0.75,
--		codeOnTouch = function(self,x,y,sus)
--			if _uNum[_NNUM]>0 then
--				_uNum[_NNUM] = _uNum[_NNUM] - 1
--				if _uNum[_NNUM] < 1 then
--					_uNum[_NNUM] = 1
--				end
--				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
--				_childUI["scrollBtn"].handle._n:setPosition(_bar.data.rect.w -_bar.data.curW+_barOffX,_barOffY)
--				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
--				_set2ScoreInfo()
--			end
--		end,
--	})
--	--拖拽条右箭头
--	_childUI["delete__btnPlus"] = hUI.button:new({
--		parent = _parent,
--		mode = "imageButton",
--		dragbox = _frm.childUI["dragBox"],
--		model = "UI:btnPlus",
--		animation = "R",
--		w = 32,
--		h = 32,
--		x = _bar.data.x+_bar.data.w+20,
--		y = _bar.data.y-16,
--		scaleT = 0.75,
--		codeOnTouch = function(self,x,y,sus)
--			if _uNum[_NNUM]<_uNum[_NMAX] then
--				_uNum[_NNUM] = _uNum[_NNUM] + 1
--				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
--				local tempX = _bar.data.rect.w -_bar.data.curW
--				if tempX>350 then tempX = 350 end
--				_childUI["scrollBtn"].handle._n:setPosition(tempX+_barOffX,_barOffY)
--				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
--				
--				_set2ScoreInfo()
--			end
--		end,
--	})
--	
--	--面板标题
--	_childUI["tipLab"] =  hUI.label:new({
--		parent = _parent,
--		x = _w/2,
--		y = -40,
--		text = hVar.tab_string["__TEXT_DeleteBFSCard"],
--		size = 30,
--		width = _w-64,
--		font = hVar.FONTC,
--		align = "MC",
--		border = 1,
--	})
--	
--	--确定按钮
--	_childUI["confirmBtn"] =  hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:confirmbut",
--		x = _w/2+110,
--		y = -_h + 30,
--		scaleT = 0.9,
--		code = function()
--			local skillMaxLv = hVar.tab_tactics[_skillID].level or 1
--			if LuaResolveBFSkillCount(_skillID,_skillLv,_uNum[_NNUM]) == 1 then
--				local score = hVar.BFSKILL2SOCRE[skillMaxLv][_skillLv]
--				LuaAddPlayerScore(tonumber(score*_uNum[_NNUM]))
--				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--				hGlobal.event:event("localEvent_afterDeleteBFSkillCard",_index)
--			else
--				print("PLAYER_DELETEBFSKILLCARD ERRO ...")
--			end
--			_exitFun()
--		end,
--	})
--	
--	--取消按钮
--	_childUI["MaxBtn"] =  hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:maxbutton",
--		animation = "R",
--		x = _w/2-110,
--		y = -_h + 30,
--		scaleT = 0.9,
--		code = function()
--			if _uNum[_NNUM]<_uNum[_NMAX] then
--				 _uNum[_NNUM] = _uNum[_NMAX]
--				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
--				local tempX = _bar.data.rect.w -_bar.data.curW
--				if tempX>350 then tempX = 350 end
--				_childUI["scrollBtn"].handle._n:setPosition(tempX+_barOffX,_barOffY)
--				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
--				_set2ScoreInfo()
--			end
--			
--		end,
--	})
--	
--	--关闭按钮
--	_childUI["closeBtn"] =  hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "BTN:PANEL_CLOSE",
--		x = _w,
--		y = -10,
--		scaleT = 0.9,
--		code = function()
--			_exitFun()
--		end,
--	})
--	
--	
--	hGlobal.event:listen("LocalEvent_ShowDeleteBFSkillCardFrm","ShowDeleteBFSkillCardFrm",function(skillID,skillLv,index) 
--		_createBattlefieldSkillInfo(skillID,skillLv)
--		_skillID,_skillLv,_index = skillID,skillLv,index
--		
--		_uNum[_NMAX] = LuaGetBFSkillCount(skillID,skillLv,1)
--		if _uNum[_NMAX] >= 1 then
--			_uNum[_NNUM] = 1
--		else
--			_uNum[_NNUM] = 0
--		end
--		_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
--		local tempX = _bar.data.rect.w -_bar.data.curW
--		if tempX>350 then tempX = 350 end
--		_childUI["scrollBtn"].handle._n:setPosition(tempX+_barOffX,_barOffY)
--		_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
--		_set2ScoreInfo()
--		
--		_frm:show(1)
--		_frm:active()
--	end)
--end
--

--获得战术技能时的提示界面
hGlobal.UI.InitBattlefieldSkillFrm = function()
	local _h,_w = 260,420
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2
	local _frm,_parent,_childUI = nil,nil,nil
	local removeList = {}
	
	local removeFunc = function()
		for i = 1,#removeList do
			hApi.safeRemoveT(_childUI,removeList[i]) 
		end
		removeList = {} 
	end
	hGlobal.UI.BattlefieldSkillFrm = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 2,
		show = 0,
		codeOnClose = function(self)
			removeFunc()
		end,
		w = _w,
		h = _h,
	})
	
	_frm = hGlobal.UI.BattlefieldSkillFrm
	_parent = _frm.handle._n
	_childUI = _frm.childUI
	
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = _w-5,
		y = -12,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		z = 2,
		code = function()
			_frm:show(0)
		end,
	})
	
	_childUI["frmTitle"] = hUI.label:new({
		parent = _parent,
		x = _w/2,
		y = - 35,
		text = hVar.tab_string["__TEXT_GetBattlefieldSkill"], --language
		--text = "获得战术技能卡", --language
		size = 30,
		font = hVar.FONTC,
		align = "MC",
		width = 300 ,
		RGB = {255,205,55},
		border = 1,
	})
	
	--创建战术技能信息
	local _createBattlefieldSkillInfo = function(name, skillID, skillLV, num, skillDebris, x, y)
		_childUI[name] = hUI.node:new({
			parent = _parent,
			x = x,
			y = y,
		})
		removeList[#removeList+1] = name
		
		local maxLevel = hVar.tab_tactics[skillID].level or 1
		local qLv = math.min((hVar.tab_tactics[skillID].quality or 1), 4)
		--底板
		_childUI[name].childUI["bg"]= hUI.image:new({
			parent = _childUI[name].handle._n,
			--model = hApi.GetTacticsCardGB(maxLevel,skillLV),
			model = "UI:tactic_card_"..qLv,
			--w = 110,
			--h = 116.
		})
		
		--类型图标
		_childUI[name].childUI["typeicon"]= hUI.image:new({
			parent = _childUI[name].handle._n,
			model = hApi.GetTacticsCardTypeIcon(skillID,"model"),
			x = -3,
			y = 57,
		})
		
		--icon
		_childUI[name].childUI["icon"]= hUI.image:new({
			parent = _childUI[name].handle._n,
			model = hVar.tab_tactics[skillID].icon,
			y = -10,
			w = 50,
			h = 50,
		})
		
		--名字
		_childUI[name].childUI["info"] = hUI.label:new({
			parent =_childUI[name].handle._n,
			y = 28,
			size = 20,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 400,
			text = hVar.tab_stringT[skillID][1],
		})
		
		local txt_num = "x"..(num or 1)
		
		local oTactic = LuaGetPlayerTacticById(skillID)
		if oTactic or (num == 0) then
			--实际增加卡牌的流程
			local tLv = skillLV or 0
			if tLv > hVar.TACTIC_LVUP_INFO.maxTacticLv then
				tLv = hVar.TACTIC_LVUP_INFO.maxTacticLv
			end
			local toDebris = 0
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tLv]
			if tacticLvUpInfo then
				toDebris = tacticLvUpInfo.toDebris or 0
			end
			
			local debris = (num or 1) * toDebris + skillDebris --碎片的数量
			--txt_num = "碎片" .." x"..debris --language
			txt_num = hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"] .." x"..debris --language
		end
		
		--if txt_num > 1 then
			_childUI[name].childUI["num"] = hUI.label:new({
				parent =_childUI[name].handle._n,
				x = 0,
				y = -90,
				size = 20,
				align = "MC",
				border = 1,
				--font = hVar.FONTC,
				width = 400,
				text = txt_num,
			})
		--end
		
		
		--根据 此技能的 最大技能上限 修改 显示技能星星的 坐标样式
		if maxLevel >= 5 then
			-- 常规 排列，技能Lv 大于等于5
			for i = 1,maxLevel do
				_childUI[name].childUI["Level_star_slot"..i] = hUI.image:new({
					parent = _childUI[name].handle._n,
					model = "UI:HERO_STAR",
					x = -32 + (i-1)% 5 * 16,
					y = -47 - math.ceil((i-5)/5)*16,
				})
				_childUI[name].childUI["Level_star_slot"..i].handle.s:setOpacity(120)
			end
			
			for i = 1,skillLV do
				_childUI[name].childUI["Level_star"..i] = hUI.image:new({
					parent = _childUI[name].handle._n,
					model = "UI:HERO_STAR",
					x = -32 + (i-1)% 5 * 16,
					y = -47 - math.ceil((i-5)/5)*16,
				})
			end
		else
			local tempStartX = -1* (maxLevel-1)*8
			--居中显示
			for i = 1,maxLevel do
				_childUI[name].childUI["Level_star_slot"..i] = hUI.image:new({
					parent = _childUI[name].handle._n,
					model = "UI:HERO_STAR",
					x = tempStartX+(i-1)*16,
					y = -47,
				})
				_childUI[name].childUI["Level_star_slot"..i].handle.s:setOpacity(120)
			end
			
			for i = 1,skillLV do
				_childUI[name].childUI["Level_star"..i] = hUI.image:new({
					parent = _childUI[name].handle._n,
					model = "UI:HERO_STAR",
					x = tempStartX+(i-1)*16,
					y = -47,
				})
			end
		end
		
	
	end
	
	--显示函数  
	local _ActionCallBack = function()
		_frm:active()
	end
	hGlobal.event:listen("localEvent_ShowBattlefieldSkillFrm","showBattlefieldSkillBook",function(cardList,x,y,mode,isActive,prizeid)
		removeFunc()
		
		local num = #cardList
		for i = 1,num do
			local x,y = math.floor((_w/2+60) -num *125/2 + (i-1)*125),-140
			_createBattlefieldSkillInfo("node_item_"..i,cardList[i][1],cardList[i][2],cardList[i][3], cardList[i][4] or 0, x,y)
		end
		
		_frm:setXY(x or _x,y or _y)
		_frm:show(1)
		mode = mode or 0
		isActive = isActive or 1
		if isActive == 1 then
			_frm.childUI["dragBox"].data.buttononly = 0
			_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(_frm.data.x,_frm.data.y),5,1),CCCallFunc:create(_ActionCallBack)))
		else
			_frm.childUI["dragBox"].data.buttononly = 1
		end
		
		if (mode == 0) then
			_childUI["frmTitle"]:setText(hVar.tab_string["__TEXT_GetBattlefieldSkill"]) --"获得战术技能卡"
		elseif (mode == 1) then
			_childUI["frmTitle"]:setText(hVar.tab_string["__TEXT_GetBattlefieldSkill"]) --"获得战术技能卡"
			
			--判断战术技能卡计数器 是否正常
			--if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then return end
			for i = 1,num do
				local skillID,skillLv,num  = cardList[i][1],cardList[i][2],(cardList[i][3] or 1)
				if LuaAddPlayerSkillBook(skillID,skillLv,num) == 1 then
					
					
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					----local skill = LuaGetPlayerSkillBook()
					----判断是否有激活过的技能
					--local tacticsList = LuaGetActiveBattlefieldSkill()
					--local result = 0
					--if type(tacticsList) == "table" then
					--	local v = nil
					--	for i = 1,#tacticsList do
					--		v = tacticsList[i]
					--		if type(v) == "table" and hVar.tab_tactics[v[1]] then
					--			result = 1
					--		end
					--	end
					--end
					----是否 使用过
					--local useState = LuaGetUsedBookState(g_curPlayerName)
					--if type(skill) == "table" and #skill > 0 and result == 0 and useState == 0 then
					--	LuaClearActiveBattlefieldSkill()
					--	if hGlobal.UI.SystemMenuBar then --geyachao: 这个控件已经不存在了
					--		hGlobal.UI.SystemMenuBar.childUI["BattlefieldSkillbtn"]:setstate(1)
					--	end
					--	hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",1)
					--end
				else
					print("get bfskillCard fail")
				end
			end
		elseif (mode == 2) then --获得兵符
			_childUI["frmTitle"]:setText(hVar.tab_string["__TEXT_GetBattlefieldBingFu"]) --"获得兵符"
		end
		
		--播放音效
		hApi.PlaySound("getcard")
		
		if prizeid and type(prizeid) == "number" then
			SendCmdFunc["confirm_prize_list"](prizeid)
		end
	end)
end

--
----战术技能卡片的 信息显示面板
--hGlobal.UI.InitBattlefieldSkillInfoFrm = function()
--	local _x,_y,_h,_w = 410,520,300,420
--	local _frm,_parent,_childUI = nil,nil,nil
--	local removeList = {}
--	
--	hGlobal.UI.BattlefieldSkillInfoFrm = hUI.frame:new({
--		x = _x,
--		y = _y,
--		z = 505,
--		dragable = 3,
--		show = 0,
--		h = _h,
--		w = _w,
--		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
--			if IsInside == 0 then
--				self:show(0)
--			end
--		end,
--	})
--	
--	_frm = hGlobal.UI.BattlefieldSkillInfoFrm
--	_parent = _frm.handle._n
--	_childUI = _frm.childUI
--	
--	_childUI["skillName"] = hUI.label:new({
--		parent = _parent,
--		x = _w/2,
--		y = - 30,
--		text = "",
--		size = 32,
--		font = hVar.FONTC,
--		align = "MC",
--		width = 400,
--		border = 1,
--		RGB = {255,205,55},
--	})
--	
--	
--	_childUI["skillInfo"] = hUI.label:new({
--		parent = _parent,
--		x = _x-260,
--		y = -70,
--		text = "",
--		size = 24,
--		font = hVar.FONTC,
--		align = "LT",
--		width = 250,
--		border = 1,
--	})
--	
--	_childUI["closeBtn"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _frm.childUI["dragBox"],
--		model = "BTN:PANEL_CLOSE",
--		x = _w-15,
--		y = -15,
--		--w = hVar.CloseButtonWH[1],
--		--h = hVar.CloseButtonWH[2],
--		scaleT = 0.9,
--		z = 2,
--		code = function()
--			_frm:show(0)
--		end,
--	})
--	
--	--升级按钮
--	local _skillID,_skillLv
--	local _cur_skill_type = 0
--	_childUI["upgradeBtn"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _frm.childUI["dragBox"],
--		x = _x-340,
--		y = _h-540,
--		w = 100,
--		label = hVar.tab_string["__UPGRADE"],
--		font = hVar.FONTC,
--		border = 1,
--		scaleT = 0.9,
--		scale = 0.9,
--		code = function()
--			if g_cur_net_state == 1 then
--				_frm:show(0)
--				hGlobal.event:event("localEvent_ShowBFSkillCardUpgradeFrm",_skillID,_skillLv,_cur_skill_type)
--			else
--				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_MakeCardNeedNet"],{
--					font = hVar.FONTC,
--					ok = 1,
--				})
--			end
--		end,
--	})
--	_childUI["upgradeBtn"].childUI["UI_Arrow"]= hUI.image:new({
--		parent = _childUI["upgradeBtn"].handle._n,
--		model = "UI:UI_Arrow",
--		scale = 0.7,
--		roll = 90,
--		x = 60,
--	})
--	
--	_childUI["upgradeBtn"].childUI["UI_Arrow"].handle._n:setRotation(-90)
--	
--	--创建战术技能信息
--	local _createBattlefieldSkillInfo = function(skillID,skillLV)
--		_childUI["node_item"] = hUI.node:new({
--			parent = _parent,
--			x = 80,
--			y = -120,
--		})
--		
--		local tempMaxLevel = hVar.tab_tactics[skillID].level
--		--底板
--		_childUI["node_item"].childUI["bg"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hApi.GetTacticsCardGB(tempMaxLevel,skillLV),
--			--w = 110,
--			--h = 116.
--		})
--		
--		--类型图标
--		_childUI["node_item"].childUI["typeicon"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hApi.GetTacticsCardTypeIcon(skillID,"model"),
--			x = -3,
--			y = 57,
--		})
--
--		--icon
--		_childUI["node_item"].childUI["icon"]= hUI.image:new({
--			parent = _childUI["node_item"].handle._n,
--			model = hVar.tab_tactics[skillID].icon,
--			y = -10,
--			w = 50,
--			h = 50,
--		})
--		
--		--名字
--		_childUI["node_item"].childUI["info"] = hUI.label:new({
--			parent =_childUI["node_item"].handle._n,
--			y = 28,
--			size = 18,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 400,
--			text = hVar.tab_stringT[skillID][1],
--		})
--		
--		--根据 此技能的 最大技能上限 修改 显示技能星星的 坐标样式
--		
--		if tempMaxLevel >= 5 then
--			-- 常规 排列，技能Lv 大于等于5
--			for i = 1,tempMaxLevel do
--				_childUI["node_item"].childUI["Level_star_slot"..i] = hUI.image:new({
--					parent = _childUI["node_item"].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (i-1)% 5 * 16,
--					y = -47 - math.ceil((i-5)/5)*16,
--				})
--				_childUI["node_item"].childUI["Level_star_slot"..i].handle.s:setOpacity(100)
--			end
--			
--			for i = 1,skillLV do
--				_childUI["node_item"].childUI["Level_star"..i] = hUI.image:new({
--					parent = _childUI["node_item"].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (i-1)% 5 * 16,
--					y = -47 - math.ceil((i-5)/5)*16,
--				})
--			end
--		else
--			local tempStartX = -1* (tempMaxLevel-1)*8
--			--居中显示
--			for i = 1,tempMaxLevel do
--				_childUI["node_item"].childUI["Level_star_slot"..i] = hUI.image:new({
--					parent = _childUI["node_item"].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(i-1)*16,
--					y = -47,
--				})
--				_childUI["node_item"].childUI["Level_star_slot"..i].handle.s:setOpacity(100)
--			end
--			
--			for i = 1,skillLV do
--				_childUI["node_item"].childUI["Level_star"..i] = hUI.image:new({
--					parent = _childUI["node_item"].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(i-1)*16,
--					y = -47,
--				})
--			end
--		end
--
--		_childUI["skillName"]:setText(hVar.tab_stringT[skillID][1])
--		_childUI["skillInfo"]:setText(hVar.tab_stringT[skillID][1+skillLV])
--		
--		local size = _childUI["skillInfo"].handle.s:getContentSize()
--		if size.height > 144 then
--			local offY = math.ceil((size.height - 144) /24)
--			_frm:setWH(_w,_h+offY*24)
--		else
--			_frm:setWH(_w,_h)
--		end
--
--		_frm.handle._n:reorderChild(_childUI["closeBtn"].handle._n,1)
--	end
--	
--	_childUI["can_not_upgrade_lab"] = hUI.label:new({
--		parent = _parent,
--		x = _x-340,
--		y = _h-520,
--		text = "",
--		size = 24,
--		font = hVar.FONTC,
--		align = "LT",
--		width = 300,
--		border = 1,
--		RGB = {255,255,0},
--	})
--	
--	--无响应模式下直接隐藏
--	hGlobal.event:listen("LocalEvent_UITouchBegin","__AutoHideTacticsInfoFrm",function()
--		if _frm.data.show==1 and _childUI["closeBtn"].data.state==-1 then
--			_frm:show(0)
--		end
--	end)
--	
--	--旧版显示战术卡相信信息界面
--	hGlobal.event:listen("localEvent_ShowBattlefieldSkillInfoFrm","showBattlefieldSkillBook",function(skillID,skillLv,x,y,CanGetMsg,mode,skill_type)
--		if skillID<=0 then
--			_frm:show(0)
--			return
--		end
--		
--		_cur_skill_type = skill_type
--		_childUI["upgradeBtn"]:setstate(-1)
--		_childUI["can_not_upgrade_lab"]:setText("")
--		if g_current_scene == g_world and mode == 1 then
--			
--			local maxLv = hVar.tab_tactics[skillID].level
--			local require = hVar.BFSKILL_UPGRADE[maxLv][skillLv]
--			
--			--升级条件为表时 才可以点击升级按钮
--			_childUI["upgradeBtn"]:setstate(1)
--			--[[
--			if type(require) == "table" and skillID >100 then
--				_childUI["upgradeBtn"]:setstate(1)
--			else
--				if skillID < 100 then
--					_childUI["can_not_upgrade_lab"]:setText( hVar.tab_string["__UPGRADEBFSKILL_CANT"])
--				--如果是数字则寻找 可以升级的项
--				elseif maxLv > skillLv then
--					local canUpLv = 0
--					for i = 1,#hVar.BFSKILL_UPGRADE[maxLv] do
--						if type(hVar.BFSKILL_UPGRADE[maxLv][i]) == "table" then
--							canUpLv = i
--							break
--						end
--					end
--					_childUI["can_not_upgrade_lab"]:setText(hVar.tab_string["__UPGRADEBFSKILL_REQUIRELV"].." "..tostring(canUpLv).." "..hVar.tab_string["__UPGRADEBFSKILL_REQUIRELV2"])
--				end
--			end
--			]]
--		end
--		 _skillID,_skillLv = skillID,skillLv
--		
--		hApi.safeRemoveT(_childUI,"node_item")
--		_createBattlefieldSkillInfo(skillID,skillLv)
--		
--		if CanGetMsg==0 then
--			_childUI["closeBtn"]:setstate(-1)
--			_childUI["dragBox"].data.buttononly = 1
--		else
--			_childUI["closeBtn"]:setstate(1)
--			_childUI["dragBox"].data.buttononly = 0
--		end
--		
--		_frm:setXY(x or _x, y or _y)
--		_frm:show(1)
--		_frm:active()
--	end)
--end

--显示战术卡详细信息界面
hGlobal.event:listen("localEvent_ShowBattlefieldSkillInfoFrm","showBattlefieldSkillBook",function(skillID,skillLv,x,y,CanGetMsg,mode,skill_type)
	if (skillID <= 0) then
		return
	end
	
	--显示新版tip
	hApi.ShowTacticCardTip(2, skillID, skillLv)
end)