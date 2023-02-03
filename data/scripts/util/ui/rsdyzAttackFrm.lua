--其实现在是我的领地里按game start后的面板 懒得svn上改名字
hGlobal.UI.InitRsdyzAttackFrm_RSDYZ = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	
	local _x,_y,_w,_h = 50,740,940,715
	local x,y,w,h = _x,_y,_w,_h
	local _tGridClipper = {40,-110,_w-80,_h-355}--裁剪范围
	local _tGrid_DragRect = {120,170,0,_h-345}--拖拽范围
	local _tAlignData = {"V","_gridTemp",40,0,0}--自动回弹
	local changeUid = 0

	if g_phone_mode == 1 then
		_x = 30
		_y = 620
		_w = 900
		_h = 600
		_tGridClipper = {20,-65,_w-50,_h-242}
		_tGrid_DragRect = {100,215,0,_h-230}
	elseif g_phone_mode == 2 then
		_x = 100
		_y = 620
		_w = 900
		_h = 600
		_tGridClipper = {20,-65,_w-50,_h-242}
		_tGrid_DragRect = {100,215,0,_h-230}
	end

	local gxgyID = {}
	local numInALine = 6--一行6个
	local choiceHero = {}--第一个是主将
	local returnPos = {}--返回位置
	local isForDef = 0--是否用于防守的 1表示是防守时
	local maxHero = 3
	local nowHero = 0
	local choiceIndex = 0
	local cancelChoiceIndex = 0
	local flySprite = {}
	local lx,ly = 0,0
	local ctid = 0
	local inUseList = {}--在用英雄 并且活着的英雄
	local deadList = {}--已阵亡英雄
	local gridSpriteTab = {}
	for i = 1,maxHero do
		choiceHero[i] = 0
		flySprite[i] = 0
		returnPos[i] = {}
		returnPos[i][1] = -1
		returnPos[i][2] = -1
		inUseList[i] = 0
	end

	local changeUnit = nil
	
	local gridParent = nil
	local gpx,gpy = 0,0--grid父节点的坐标
	local inAction = 0--0能操作 1在动画播放中不能操作
	local beAdd = 0--添加模式
	local addT = {}--添加的表
	local leadHero = nil--带头大哥
	local goMap = 0

	local isDead = function(heroID)
		local index = 0
		for i = 1,#deadList do
			if deadList[i] == heroID then
				index = i
				break
			end
		end
		return index
	end

	local canBeChoice = function(heroID)--是否能选择 0不能选择
		local has = 0
		for i = 1,maxHero do
			if choiceHero[i] == heroID then
				has = 1
				break
			end
		end
		if has == 0 and nowHero < maxHero then
			for i = 1,maxHero do
				if choiceHero[i] == 0 then
					return i
				end
			end
		end
		return 0
	end
	
	local canCancel = function(index)
		cancelChoiceIndex = index
		return choiceHero[index]
	end
	
	local moveDown = nil--往下飞
	local moveDownFinish = nil--往下飞到达
	local moveUp = nil
	local moveUpFinish = nil
	local renewOKBtn = nil
	
	local dy_cp = 0
	if g_phone_mode == 1 then
		dy_cp = 90
	elseif 	g_phone_mode == 2 then
		dy_cp = 90
	end
	
	local choicePos = {
		{260,-600 + dy_cp},
		{540,-600 + dy_cp},
		{680,-600 + dy_cp},
	}
	
	RSDYZ_DEF_LIST = {}--地图上单位和取到别的玩家数据的关联
	local aaa = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		dragable = 2,
		show = 0,
		--background = "UI:tip_item",
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
		border = 1,
		autoactive = 0,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			self:pick("_gridTemp",_tGrid_DragRect,tTempPos,{30,function(self,tTempPos,tParam)--最小拖动30px后state变成1
				if tParam.state == 0 then
					if hApi.gametime()-tTempPos.tick<=350 then
						if inAction ~= 0 then
							return
						end
						local oGrid = self.childUI["_gridTemp"]
						local d = self.data
						local cx = tTempPos.tx-d.x
						local cy = tTempPos.ty-d.y
						if cy < - 470 then
							
						else
							local gx,gy,tPick,pSprite = oGrid:xy2grid(cx,cy,"parent")
							if tPick and tPick~=0 then
								--print(cx,cy)
								--print(hVar.tab_unit[gxgyID[""..gx..""..gy]].name)
								local touchID = gxgyID[gx..""..gy]
								if isDead(touchID) == 0 then
									local has = 0
									choiceIndex = canBeChoice(touchID)

									if choiceIndex > 0 then
										choiceHero[choiceIndex] = touchID
										flySprite[choiceIndex] =  pSprite
										moveDown(pSprite,choiceIndex)
									end
								end
							end
						end
						renewOKBtn()
					end
				else
					self:aligngrid(_tAlignData,_tGrid_DragRect,tTempPos)
				end
			end,{state=0}})
		end,
		codeOnClose = function(self)
			self.childUI["_gridTemp"]:updateitem({})
		end
	})
	

	local _frm = aaa
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local createMyHeros = nil
	local leadAddHero = nil

	moveDown = function(sprite,index)--往下飞
		inAction = 1
		gridParent = sprite:getParent()
		gpx,gpy = gridParent:getPosition()
		returnPos[index][1],returnPos[index][2] = sprite:getPosition()
		hApi.ReloadParent(sprite,_parent)
		sprite:setPosition(returnPos[index][1] + gpx,returnPos[index][2] + gpy)
		sprite:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(choicePos[index][1],choicePos[index][2])),CCCallFunc:create(moveDownFinish)))
	end

	moveDownFinish = function()
		inAction = 0
		nowHero = nowHero + 1
	end

	moveUp = function(sprite,index)
		inAction = 1
		gpx,gpy = gridParent:getPosition()
		sprite:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(returnPos[index][1] + gpx,returnPos[index][2] + gpy)),CCCallFunc:create(moveUpFinish)))
	end

	moveUpFinish = function()
		inAction = 0
		nowHero = nowHero - 1
		hApi.ReloadParent(flySprite[cancelChoiceIndex],gridParent)
		gpx,gpy = gridParent:getPosition()
		flySprite[cancelChoiceIndex]:setPosition(returnPos[cancelChoiceIndex][1],returnPos[cancelChoiceIndex][2])
		returnPos[cancelChoiceIndex][1] = -1
		returnPos[cancelChoiceIndex][2] = -1
		flySprite[cancelChoiceIndex] = 0
	end

	_childUI["ok"] = nil

	_childUI["SelectedHeroTitle"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		x = w/2,
		y = -35,
		width = 300,
		text = hVar.tab_string["__TEXT_SelectedHeroTitle"],
		border = 1,
	})
	
	local dx_ab = 0
	local dy_ab = 0
	if g_phone_mode == 1 then
		dx_ab = 22
		dy_ab = 52
	elseif 	g_phone_mode == 2 then
		dx_ab = 22
		dy_ab = 52
	end
	--分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 470 - dx_ab,
		y = -480 + dy_ab,
		w = w+20,
		h = 8,
	})
	if g_phone_mode == 1 or g_phone_mode == 2 then
		_childUI["apartline_back"].handle._n:setVisible(false)
	end
	
	local dy_ab1 = 0
	local dx_ab1 = 0
	if g_phone_mode == 1 then
		dy_ab1 = 36
		dx_ab1 = 20
	elseif 	g_phone_mode == 2 then
		dy_ab1 = 36
		dx_ab1 = 20
	end
	_childUI["apartline_back1"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 470 - dx_ab1,
		y = -98 + dy_ab1,
		w = w+20,
		h = 8,
	})
	
	local dy_JIAN_label = 0
	if g_phone_mode == 1 then
		dy_JIAN_label = 70
	elseif 	g_phone_mode == 2 then
		dy_JIAN_label = 70
	end

	_childUI["ZHU_JIAN"] = hUI.label:new({
		parent = _parent,
		x = 130,
		y = -510 + dy_JIAN_label,
		size = 38,
		border = 1,
		align = "MC",
		font = hVar.FONTC,
		text = hVar.tab_string["ZHU_JIAN"],
		width = 400,
		RGB = {230,180,50},
	})

	_childUI["FU_JIAN"] = hUI.label:new({
		parent = _parent,
		x = 410,
		y = -510 + dy_JIAN_label,
		size = 38,
		border = 1,
		align = "MC",
		font = hVar.FONTC,
		text = hVar.tab_string["FU_JIAN"],
		width = 400,
		RGB = {230,180,50},
	})

	for i = 1,maxHero do
		_childUI["delete_img_"..i] = nil
		_childUI["delete_bg_"..i] = nil
		_childUI["delete_lv_"..i] = nil
		_childUI["delete_name_"..i] = nil
		for j = 1,5 do
			_childUI["delete_stars_"..i..j] = nil
		end
	end

	local deletLastChoiceHero = function()
		for i = 1,maxHero do
			hApi.safeRemoveT(_childUI,"delete_img_"..i) 
			hApi.safeRemoveT(_childUI,"delete_bg_"..i)
			hApi.safeRemoveT(_childUI,"delete_lv_"..i)
			hApi.safeRemoveT(_childUI,"delete_name_"..i)
			for j = 1,5 do
				hApi.safeRemoveT(_childUI,"delete_stars_"..i..j)
			end
		end
	end

	local dy_JIAN_button = 0
	if g_phone_mode == 1 then
		dy_JIAN_button = 90
	elseif 	g_phone_mode == 2 then
		dy_JIAN_button = 90
	end

	_childUI["jiang_bg_1"] = hUI.button:new({
		parent = _parent,
		model = "UI:Card_slot",
		dragbox = _frm.childUI["dragBox"],
		x = 260,
		y = -600 + dy_JIAN_button,
		w = 140,
		h = 180,
		code = function(self)
			if inAction ~= 0 then
				return
			end
			if canCancel(1) ~= 0 then
				choiceHero[1] = 0
				moveUp(flySprite[1],1)
			end
			renewOKBtn()
		end,
	})

	_childUI["jiang_bg_2"] = hUI.button:new({
		parent = _parent,
		model = "UI:Card_slot",
		dragbox = _frm.childUI["dragBox"],
		x = 540,
		y = -600 + dy_JIAN_button,
		w = 140,
		h = 180,
		code = function(self)
			if inAction ~= 0 then
				return
			end
			if canCancel(2) ~= 0 then
				choiceHero[2] = 0
				moveUp(flySprite[2],2)
			end
			renewOKBtn()
		end,
	})

	_childUI["jiang_bg_3"] = hUI.button:new({
		parent = _parent,
		model = "UI:Card_slot",
		dragbox = _frm.childUI["dragBox"],
		x = 680,
		y = -600 + dy_JIAN_button,
		w = 140,
		h = 180,
		code = function(self)
			if inAction ~= 0 then
				return
			end
			if canCancel(3) ~= 0 then
				choiceHero[3] = 0
				moveUp(flySprite[3],3)
			end
			renewOKBtn()
		end,
	})

	_childUI["ok"] = nil
	hGlobal.event:listen("LocalEvent_RSDYZ_CAN_BATTLE_BEGIN","Griffin_showWdldAttackFrm",function()
		if inAction ~= 0 then
			return
		end
		if isForDef == 0 then
			if g_current_scene == g_world then
				if hGlobal.WORLD.LastWorldMap == nil or hApi.Is_RSYZ_Map(hGlobal.WORLD.LastWorldMap.data.map) == -1 then--在选地图界面
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetDBInfo,luaGetplayerDataID(),2,RSDYZ_NEED_PLAYER_LEN})
					_childUI["ok"]:setstate(0)
				else--在燃烧远征地图里面
					if beAdd == 0 then
						createMyHeros()
					elseif beAdd == 1 then
						leadAddHero()
					end
					beAdd = 0
					hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm",0)
				end
			else
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetDBInfo,luaGetplayerDataID(),2,RSDYZ_NEED_PLAYER_LEN})
				_childUI["ok"]:setstate(0)
			end
		elseif isForDef == 1 then
			str = ""
			for i = 1,maxHero do
				str = str..string.format("%05d",choiceHero[i])..";"
			end
			SendCmdFunc["send_DefHero_RSDYZ"](str)
			SendCmdFunc["send_GetHeroCardData"](luaGetplayerDataID(),100)
			hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm_Def",0)
			hGlobal.event:event("LocalEvent_SetMyDef",choiceHero)
			for i = 1,maxHero do
				choiceHero[i] = 0
			end
		end
	end)

	_childUI["ok"] = hUI.button:new({
		parent = _parent,
		model = "UI:ConfimBtn1",
		dragbox = _frm.childUI["dragBox"],
		x = 850,
		y = -530,
		scaleT = 0.9,
		code = function(self)
			if isForDef == 0 then
				if hGlobal.WORLD.LastWorldMap == nil or hApi.Is_RSYZ_Map(hGlobal.WORLD.LastWorldMap.data.map) == -1 then
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleBegin_Fire,luaGetplayerDataID(),0})
				else
					hGlobal.event:event("LocalEvent_RSDYZ_CAN_BATTLE_BEGIN")
				end
			elseif isForDef == 1 then
				hGlobal.event:event("LocalEvent_RSDYZ_CAN_BATTLE_BEGIN")
			end
			goMap = 1
		end,
	})

	renewOKBtn = function()
		_childUI["ok"]:setstate(0)
		if isForDef == 0 then
			if choiceHero[1] ~= 0 then
				_childUI["ok"]:setstate(1)
			end
		elseif isForDef == 1 then
			local emp = 0
			for i = 1,maxHero do
				if choiceHero[i] == 0 then
					emp = 1
					break
				end
			end
			if emp == 0 then
				_childUI["ok"]:setstate(1)
			end
		end
		if goMap == 1 then
			_childUI["ok"]:setstate(0)
		end
	end

	local gridHeroImg = {}

	local _createQuestItem = function(self,id,sprite)-- 创建精灵
		hUI.deleteUIObject(hUI.image:new({
			parent = sprite,
			model =  "UI:PANEL_CARD_01",
			x = 0,
			y = 0,
			z = -1,
			w = 140,
			h = 180,
		}))

		hUI.deleteUIObject(hUI.image:new({
			parent = sprite,
			model =  hVar.tab_unit[id].portrait,
			x = 0,
			y = 18,
			z = -1,
			w = 126,
			h = 128,
		}))
		gridHeroImg["id"..id] = sprite

		hUI.deleteUIObject(hUI.label:new({
			parent = sprite,
			x = -38,
			y = -77,
			text = hApi.GetHeroCardById(id).attr.level,
			size = 16,
			font = "num",
			align = "MC",
			width = 200,
			scale = 0.8,
		}))

		hUI.deleteUIObject(hUI.label:new({
			parent = sprite,
			x = 25,
			y = -79,
			text = hVar.tab_stringU[id][1],
			size = 24,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
			scale = 0.8,
		}))

		for j = 1,5 do
			hUI.deleteUIObject(hUI.image:new({
				parent = sprite,
				model = "UI:HERO_STAR",
				x = -48 + (j-1)*15.5,
				y = -53,
				--scale = 0.8,
			}))
		end

		--gridHeroImg["id"..id] = hUI.image:new({
			--parent = sprite,
			--model =  hVar.tab_unit[id].portrait,
			--x = 0,
			--y = 18,
			--z = -1,
			--w = 126,
			--h = 128,
		--})

		--local x,y = sprite:getPosition()
		--sprite:setPosition(x - 320,y)
		--sprite:setScale(0.8)

		--创建任务名字
		--hUI.deleteUIObject(hUI.label:new({
			--parent = sprite,
			--x = self.data.x-10,
			--y = self.data.y + 220,
			--size = 38,
			--border = 1,
			--align = "MC",
			--font = hVar.FONTC,
			--text = hVar.tab_stringU[id][1],
			--width = 400,
			--RGB = {230,180,50},
		--}))
	end

	local _gridTemp = {{}}--槽子
	local heros = nil
	local hangNum = 0

	local openThisFrm = function()
		local tempC = {}
		_childUI["ok"]:setstate(0)
		for i = 1,maxHero do
			tempC[i] = choiceHero[i]
			choiceHero[i] = 0
			if flySprite[i] ~= 0 then
				_parent:removeChild(flySprite[i],true)
				flySprite[i] = 0
			end
		end
		nowHero = 0
		_frm:active()
		
		_gridTemp = {{}}
		heros = Save_PlayerData.herocard
		hangNum = math.floor((#heros)/numInALine)

		for i = 1,hangNum do
			_gridTemp[i] = {}
			for j = 1,numInALine do
				_gridTemp[i][j] = 1
			end
		end

		if #heros - numInALine*hangNum > 0 then
			_gridTemp[hangNum + 1] = {}
			for i = 1,#heros - numInALine*hangNum do
				_gridTemp[hangNum + 1][i] = 1
			end
		end

		--for i = 1,#heros do
			--if gridHeroImg["id"..heros[i].id] ~= nil then
				--hApi.safeRemoveT(gridHeroImg,"id"..heros[i].id)
			--end
		--end

		if _childUI["_gridTemp"] ~= nil then
			hApi.safeRemoveT(_childUI,"_gridTemp")
		end

		local dx_gt = 0
		local dy_gt = 0
		if g_phone_mode == 1 then
			dx_gt = 20
			dy_gt = 46
		elseif g_phone_mode == 2 then
			dx_gt = 20
			dy_gt = 46
		end

		_childUI["_gridTemp"] = hUI.bagGrid:new({
			parent = hApi.CreateClippingNode(_frm,_tGridClipper,0,_tGridClipper[5]),
			tab = hVar.tab_unit,
			tabModelKey = "icon",
			animation = function(id,model,gridX,gridY)
				return 0--创建了一个空的精灵
			end,
			align = "MC",
			grid = _gridTemp,
			x = 120 - dx_gt,
			y = -200 + dy_gt,
			z = 1,
			item = {},
			slot = 0,--{model = "UI:PANEL_CARD_01",animation = "normal"},
			num = 0,
			gridW = 140,
			gridH = 180,
			iconW = 140,
			iconH = 180,
			smartWH = 1,
			codeOnImageCreate = function(self,id,sprite,gx,gy)
				gxgyID[""..gx..""..gy] = id
				_createQuestItem(self,id,sprite)
				gridSpriteTab[#gridSpriteTab + 1] = {}
				gridSpriteTab[#gridSpriteTab][1] = id
				gridSpriteTab[#gridSpriteTab][2] = self
			end
		})

		local list = {}
		for i = 1,#heros do
			list[#list+1] = {}
			list[#list][1] = heros[i].id
		end
		_childUI["_gridTemp"]:updateitem(list)

		if isForDef == 0 then
			_childUI["SelectedHeroTitle"]:setText(hVar.tab_string["RSDYZ_Choice_Atk"])
		elseif isForDef == 1 then
			_childUI["SelectedHeroTitle"]:setText(hVar.tab_string["RSDYZ_Choice_Def"])
		end
	end

	local blackANode = function(node)
		local childArr = node:getChildren()
		if childArr then
			local n = childArr:count()
			for i = 0,1 do--英雄和背景
				local o = childArr:objectAtIndex(i)
				if o then
					o:setColor(ccc3(128,128,128))
				end
			end
		end
	end

	local lockInUseAndDeadHero = function()--锁定死亡和用了的英雄
		local ix = {260,540,680}
		for i = 1,maxHero do
			for j = 1,#gridSpriteTab do
				if choiceHero[i] == gridSpriteTab[j][1] then
					blackANode(gridHeroImg["id"..choiceHero[i]])
				end
			end
			if choiceHero[i] ~= 0 then
				_childUI["delete_bg_"..i] = hUI.image:new({
					parent = _parent,
					model =  "UI:PANEL_CARD_01",
					x = ix[i],
					y = -600 + dy_cp,
					z = -1,
					w = 140,
					h = 180,
					border = 0,
				})
				_childUI["delete_bg_"..i].handle.s:setColor(ccc3(128,128,128))
				_childUI["delete_img_"..i] = hUI.image:new({
					parent = _parent,
					model = hVar.tab_unit[choiceHero[i]].portrait,
					x = ix[i],
					y = -580 + dy_cp,
					w = 126,
					h = 128,
				})
				_childUI["delete_img_"..i].handle.s:setColor(ccc3(128,128,128))

				_childUI["delete_lv_"..i] = hUI.label:new({
					parent = _parent,
					x = ix[i] - 36,
					y = -600 - 78 + dy_cp,
					text = hApi.GetHeroCardById(choiceHero[i]).attr.level,
					size = 16,
					font = "num",
					align = "MC",
					width = 200,
					scale = 0.8,
				})

				_childUI["delete_name_"..i] = hUI.label:new({
					parent = _parent,
					x = ix[i] + 63 - 36,
					y = -600 - 78 + dy_cp,
					text = hVar.tab_stringU[choiceHero[i]][1],
					size = 24,
					font = hVar.FONTC,
					align = "MC",
					border = 1,
					scale = 0.8,
				})

				for j = 1,5 do
					_childUI["delete_stars_"..i..j] = hUI.image:new({
						parent =  _parent,
						model = "UI:HERO_STAR",
						x = ix[i] + (j-1)*16 - 50,
						y = -600 - 54 + dy_cp,
						--scale = 0.8,
					})
				end
			end
		end
		for j = 1,#deadList do
			blackANode(gridHeroImg["id"..deadList[j]])
		end
	end

	hGlobal.event:listen("LocalEvent_ShowRsdyzAttackFrm","Griffin_showWdldAttackFrm",function(isShow,oUnit)--进入
		_frm:show(isShow)
		isForDef = 0
		changeUnit = oUnit or nil
		--for i = 1,maxHero do
			--if choiceHero[i] ~= 0 then
				--deadList[#deadList + 1] = choiceHero[i]
			--end
		--end
		if isShow == 1 then
			deletLastChoiceHero()
			_frm:active()
			openThisFrm()
			lockInUseAndDeadHero()
			_childUI["jiang_bg_1"]:setstate(1)
			_childUI["jiang_bg_2"]:setstate(1)
			_childUI["jiang_bg_3"]:setstate(1)
		end
		goMap = 0
	end)

	hGlobal.event:listen("LocalEvent_ShowRsdyzAttackFrm_2","Griffin_showWdldAttackFrm",function(isShow,ox,oy,tid)--团扑s
		for i = 1,maxHero do
			if choiceHero[i] ~= 0 then
				deadList[#deadList + 1] = choiceHero[i]
			end
		end
		if #deadList >= #heros then --全死光，闯关结束
			--hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_All_DEAD"],0)
			hGlobal.event:event("LocalEvent_ShowRsdyzEndFrm",1,0)
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetBattleSummary_Fire,luaGetplayerDataID(),1})
		else
			_frm:show(isShow)
			changeUnit = nil
			isForDef = 0
			lx = ox
			ly = oy
			ctid = tid
			
			if isShow == 1 then
				deletLastChoiceHero()
				_frm:active()
				openThisFrm()
				lockInUseAndDeadHero()
				_childUI["jiang_bg_1"]:setstate(1)
				_childUI["jiang_bg_2"]:setstate(1)
				_childUI["jiang_bg_3"]:setstate(1)
			end
		end
		goMap = 0
	end)

	hGlobal.event:listen("LocalEvent_ShowRsdyzAttackFrm_3","Griffin_showWdldAttackFrm",function(isShow)--团扑
		_frm:show(isShow)
		changeUnit = nil
		isForDef = 0
		for i = 1,maxHero do
			if choiceHero[i] ~= 0 then
				deadList[#deadList + 1] = choiceHero[i]
			end
		end
		if isShow == 1 then
			deletLastChoiceHero()
			_frm:active()
			openThisFrm()
			lockInUseAndDeadHero()
			_childUI["jiang_bg_1"]:setstate(1)
			_childUI["jiang_bg_2"]:setstate(1)
			_childUI["jiang_bg_3"]:setstate(1)
		end
		goMap = 0
	end)

	--显示攻防title
	hGlobal.event:listen("LocalEvent_PlayerEnterBattlefield","RSYZBF",function(oWorld,oUnit,oTarget)--u 进攻 t 防守
		if hApi.Is_RSYZ_Map(hGlobal.WORLD.LastWorldMap.data.map) ~= -1 then
			local index = 0
			local ot = oTarget:gettown()
			local t = nil
			if ot then
				t = ot:getunit("guard")
			else
				t = oTarget
			end
			oduTid = t.data.triggerID
			for i = 1,#RSDYZ_DEF_LIST do
				if RSDYZ_DEF_LIST[i][1] == oduTid then
					index = i
					break
				end
			end
			if index ~= 0 then
				oWorld.data.BFTeamName = {}
				oWorld.data.BFTeamName[1] = g_curPlayerName
				oWorld.data.BFTeamName[-1] = RSDYZ_DEF_LIST[index][3] 
				hGlobal.event:event("LocalEvent_ShowBFTeamNameFrm",oWorld)
			end
		end
	end)
	
	-- zhenkira delete 2016.7.12
	--hGlobal.event:listen("Event_UnitBorn","RSDYZ_DEF_ATTR",function(oUnit)
	--	local w = oUnit:getworld()
	--	if w~=nil and w.data.type=="battlefield" then
	--		if hApi.Is_RSYZ_Map(hGlobal.WORLD.LastWorldMap.data.map) ~= -1 then
	--			if oUnit:getowner() ~= hGlobal.LocalPlayer then
	--				local lu = hApi.GetBFLeader(oUnit)
	--				local pos = lu:gettriggerdata().numFlag or 0
	--				if pos ~= 0 then
	--					pos = math.floor((pos - 1)/4)
	--				end
	--				oUnit.attr.lea = oUnit.attr.lea + pos*5
	--				oUnit.attr.led = oUnit.attr.led + pos*5
	--			end
	--		end
	--	end
	--end)

	hGlobal.event:listen("LocalEvent_ShowRsdyzAttackFrm_Def","Griffin_showWdldAttackFrm",function(isShow)--防守
		_frm:show(isShow)
		isForDef = 1
		if isShow == 1 then
			deletLastChoiceHero()
			_frm:active()
			openThisFrm()
		end
		goMap = 0
	end)

	hGlobal.event:listen("LocalEvent_RSDYZ_CreateMine","Griffin_showWdldAttackFrm",function()
		createMyHeros()
	end)

	hGlobal.event:listen("LocalEvent_RSDYZ_SetDefData","Griffin_showWdldAttackFrm",function(tid,rid,name)
		RSDYZ_DEF_LIST[#RSDYZ_DEF_LIST + 1] = {tid,rid,name}
	end)

	hGlobal.event:listen("LocalEvent_RSDYZ_ClearDefData","Griffin_showWdldAttackFrm",function()
		RSDYZ_DEF_LIST = nil
		RSDYZ_DEF_LIST = {}
	end)

	hGlobal.event:listen("LocalEvent_AddHero","Griffin_showWdldAttackFrm",function(oHeroL,indexTab)--加英雄
		deletLastChoiceHero()
		local tempC = {}
		beAdd = 1
		for i = 1,maxHero do
			if indexTab[i] ~= nil then
				if choiceHero[indexTab[i]] ~= 0 then
					deadList[#deadList + 1] = choiceHero[indexTab[i]]
					choiceHero[indexTab[i]] = 0
					nowHero = nowHero - 1
				end
				tempC[i] = choiceHero[i]
			end
		end
		_frm:show(1)
		_frm:active()
		_childUI["jiang_bg_1"]:setstate(1)
		_childUI["jiang_bg_2"]:setstate(1)
		_childUI["jiang_bg_3"]:setstate(1)
		openThisFrm()
		for i = 1,maxHero do
			choiceHero[i] = tempC[i]
			if choiceHero[i] ~= 0 then
				nowHero = nowHero + 1
				_childUI["jiang_bg_"..i]:setstate(0)
			end
		end
		lockInUseAndDeadHero()
	end)

	hGlobal.event:listen("LocalEvent_HitOnDefeatExHero","Griffin_showWdldAttackFrm",function(oHero,oHeroL)
		local at = {}
		leadHero = oHeroL
		if oHeroL:getunit() then
			for i = 1,#oHeroL:getunit().data.team do
				if type(oHeroL:getunit().data.team[i]) == "number" and oHeroL:getunit().data.team[i] == 0 then
					at[#at + 1] = i
				end
			end
			addT = at
			return hGlobal.event:event("LocalEvent_AddHero",oHeroL,at)
		end
	end)

	hGlobal.event:listen("LocalEvent_RSDYZ_CleanAll","Griffin_showWdldAttackFrm",function()
		nowHero = 0
		choiceIndex = 0
		cancelChoiceIndex = 0
		lx,ly = 0,0
		ctid = 0
		inUseList = {}--在用英雄 并且活着的英雄
		deadList = {}--已阵亡英雄
		gridSpriteTab = {}
		for i = 1,maxHero do
			choiceHero[i] = 0
			inUseList[i] = 0
		end
	end)

	leadAddHero = function()
		for i = 2,maxHero do
			for j = 1,#addT do
				if i == addT[j] then
					if choiceHero[i] ~= 0 then
						hid = choiceHero[i]
						c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,hGlobal.LocalPlayer.data.playerId,hid,wx,wy,225,nil)
						u = hApi.findUnitByCha(c)

						local nHero = hClass.hero:new({
							name = hVar.tab_stringU[hid][1],
							id = hid,
							unit = u,
							owner = hGlobal.LocalPlayer.data.playerId,
						})
						nHero:LoadHeroFromCard("newgame")
						leadHero:teamaddmember(nHero,i)
					end
				end
			end
		end

		leadHero:enumteam(function(oHeroC)
			if oHeroC.data.IsDefeated ~= 0 then
				oHeroC:setowner(hGlobal.LocalPlayer.data.playerId + 1)
				--oHeroC.data.HeroCard = 0
			end
		end)
	end

	createMyHeros = function()
		inUseList[1] = choiceHero[1]
		local hid = choiceHero[1]
		local wx,wy
		local tuid

		if changeUnit ~= nil then
			wx,wy = changeUnit:getXY()
			tuid = changeUnit.data.triggerID or 0
		else
			wx,wy = lx,ly
			tuid = ctid
		end
		
		if changeUid == 0 then
			changeUid = tuid
		end

		local c,u
		c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,hGlobal.LocalPlayer.data.playerId,hid,wx,wy,225,nil)
		u = hApi.findUnitByCha(c)

		local oHero = hClass.hero:new({
			name = hVar.tab_stringU[hid][1],
			id = hid,
			unit = u,
			owner = hGlobal.LocalPlayer.data.playerId,
		})
		oHero:LoadHeroFromCard("newgame")
		if leadHero == nil then
			leadHero = oHero
		end
					
		u:settriggerdata(nil,changeUid)
		if changeUnit ~= nil then
			changeUnit:sethide(1)
		end
		for i = 2,maxHero do
			if choiceHero[i] ~= 0 then
				inUseList[i] = choiceHero[i]
				hid = choiceHero[i]
				c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,hGlobal.LocalPlayer.data.playerId,hid,wx,wy,225,nil)
				u = hApi.findUnitByCha(c)

				local nHero = hClass.hero:new({
					name = hVar.tab_stringU[hid][1],
					id = hid,
					unit = u,
					owner = hGlobal.LocalPlayer.data.playerId,
				})
				nHero:LoadHeroFromCard("newgame")
				oHero:teamaddmember(nHero,i)
			end
		end
		
		--去掉挂了的头像
		for i = 1,#hGlobal.LocalPlayer.heros do
			local dh = hGlobal.LocalPlayer.heros[i]
			if type(dh) == "table" and dh.data.id > 0 and dh.data.IsDefeated ~= 0 then
				--dh:setowner(hGlobal.LocalPlayer.data.playerId + 1)
				--dh.data.HeroCard = 0
				dh.data.IsDefeated = 2
				--print("oHero.data.IsDefeated = 2C")
			end
		end
		hGlobal.event:event("LocalEvent_UpdateAllHeroIcon")
		--去掉挂了的头像
		
		leadHero = oHero
		
		oHero:enumteam(function(oHeroC)
			if oHeroC.data.IsDefeated ~= 0 then
				oHeroC:setowner(hGlobal.LocalPlayer.data.playerId + 1)
				--oHeroC.data.HeroCard = 0
			end
		end)
		
		--hGlobal.LocalPlayer:focusunit(oHero:getunit(),"worldmap")
		hGlobal.event:event("LocalEvent_PlayerChooseHero",oHero)
	end
end