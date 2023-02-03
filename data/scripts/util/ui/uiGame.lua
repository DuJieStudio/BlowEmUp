hApi.safeRemoveT = function(t,k)
	if t[k] then
		local o = t[k]
		o:del()
		o = nil
		t[k] = nil
	end
end
--=============================================
-- 单位卡片
--=============================================
hUI.gameUnitCard = eClass:new("static")
local _guc = hUI.gameUnitCard
local __DefaultParam = {
	parent = 0,	--hUI.__static.uiLayer
	userdata = 0,
	id = 0,
	-------------------------
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	-------------------------
	withCloseButton = 1,
}
_guc.destroy = function(self)
	local _frm = self.handle.__FrameUI
	if _frm~=nil then
		h._n = nil
		hUI.destroyDefault(self)
		_frm:del()
	else
		hUI.destroyDefault(self)
	end
end

_guc.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	local d = self.data
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local h = self.handle
	local _childUI = self.childUI

	--changed by pangyong 2015/3/31 
	local _ws, _hs   = 544, 462
	local _xs, _ys	= hVar.SCREEN.w/2 - _ws/2, hVar.SCREEN.h/2+ _hs/2 + 34				--提取屏幕数值设置参数
	local _frm = hUI.frame:new({
		--x = d.x,
		--y = d.y,
		x = _xs,
		y = _ys,
		--background = "UI:PANEL_INFO_S",
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 534,
		closebtnY = -15,
		--dragable = 2,
		dragable = 3,
		show = 0,
		w = _ws,
		h = _hs,
		--child = {
			--{
				----槽子
				--__UI = "image",
				--mode = "batchImage",
				--model = "UI_frm:slot",
				--animation = "light",
				--align = "MC",
				--x = 52,
				--y = -55,
				--w = 85,
				--h = 85,
			--},
		--},
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			--_childUI["armyGrid"]:selectitem(relTouchX,relTouchY,relTouchX+self.data.x,relTouchY+self.data.y)
		end,
	})

	_frm.childUI["apartline_back"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:panel_part_09",
		x = 270,
		y = -150,
		w = 544,
		h = 8,
	})

	d.parent = _frm.handle._n
	h._n = _frm.handle._n
	self.handle.__FrameUI = _frm

	local _parent = h._n

	d.IsShow = 1

	d.chaX = 80
	d.chaY = -82
	d.infoX = 130
	d.infoY = -46
	d.infoW = 300
	d.skillX = 70
	d.skillY = - 188
	d.heroInfoX = -8
	d.heroInfoY = - 230

	local xs,ys = d.heroInfoX,d.heroInfoY

	local _conf_Icon = hApi.CreateConf("image","icon_","MT",d.heroInfoX,d.heroInfoY,90,0)
	local _conf_Label = hApi.CreateConf("label","aLabel_","MT",d.heroInfoX,d.heroInfoY-44,90,0)
	local _conf_Val = hApi.CreateConf("label","attr_","MT",d.heroInfoX,d.heroInfoY-74,90,0)

	local _HeroLabel = {
		hApi._add_Label("LabelHp",hVar.tab_string["__Attr_Hint_Hp"],130,-108),
		hApi._add_Bar("barHp",200,-106,"red"),
		hApi._add_Val("attrHp","numGreen",246,-106),
		hApi._add_Label("LabelMp",hVar.tab_string["__Attr_Hint_Mp"],130,-134),
		hApi._add_Bar("barMp",200,-132,"blue"),
		hApi._add_Val("attrMp","numBlue",246,-132),

		hApi._add_Icon("iconExp","ICON:ATTR_exp","normal",320,-126),
		hApi._add_Label("LabelLevel",hVar.tab_string["__Attr_Hint_Lev"],390,-108),
		hApi._add_Val("attrLevel","num",436,-105,"1","LC"),
		hApi._add_Bar("barExp",350,-132,"green",126),
		hApi._add_Val("attrExp","numWhite",420,-132),
	}

	for i = 1,#hVar.HeroAttrNeedShow do
		local v = hVar.HeroAttrNeedShow[i]
		local attr = v.attr
		_HeroLabel[#_HeroLabel+1] = _conf_Val(attr,{text = "1",size = 20,font = v.font})
		_HeroLabel[#_HeroLabel+1] = _conf_Label(attr,{text = hVar.tab_string[v.text],size = 26,font = hVar.FONTC})
		_HeroLabel[#_HeroLabel+1] = _conf_Icon(attr,{model = v.model[1],animation = v.model[2]})
	end

	_childUI["heroAttr"] = hUI.node:new({
		parent = _parent,
		child = _HeroLabel,
	})

	local id = d.id
	d.id = -1

	_childUI["heroAttr"].handle._n:setVisible(false)

	self:reload(id)		--创建模型和说明
	
end

_guc.show = function(self,show,time)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	if self.handle.__FrameUI~=nil then
		d.IsShow = show
		return self.handle.__FrameUI:show(show,"appear")
	end
end

local HireGridlist = {}
_guc.reload = function(self,unitId,targetU)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	local _parent = h._n
	local r = hVar.RESULT_FAIL
	local _tabU,id = hApi.GetTableValue(hVar.tab_unit,unitId)

	for i = 1,#HireGridlist do
		hApi.safeRemoveT(_childUI,HireGridlist[i])
	end
	HireGridlist = {}

	local hero
	if targetU then
		hero = targetU:gethero()
		local team = targetU.data.team
		-- 当单位有队伍时
		if team~=0 and _tabU.noteamimg == nil then
			local _teamV = {}
			for i = 1,#team do
				local v = team[i]
				if v~=0 and hVar.tab_unit[v[1]] then
					if hVar.tab_unit[v[1]].type ~= hVar.UNIT_TYPE.HERO then
						_teamV[v[1]] = (_teamV[v[1]] or 0)+v[2]
					elseif v[1] ~= targetU.data.id then
						_teamV[v[1]] = (_teamV[v[1]] or 0)+v[2]
					end
				end

				
			end
			local _team,_grid = {},{}
			for k,v in pairs(_teamV)do
				_team[#_team+1] = {k,v}
				_grid[#_grid+1] = 0
			end
			if #_team>0 then
				_childUI["armyGrid"] = hUI.bagGrid:new({
					parent = _parent,
					tab = hVar.tab_unit,
					tabModelKey = "model",
					animation = function(id,model,gridX,gridY)
						return hApi.animationByFacing(model,"stand",0)
					end,
					align = "MC",
					grid = _grid,
					item = _team,
					slot = {model = "UI_frm:slot",animation = "normal",},
					x = 78,
					y = -380,
					--itemName = {x = 0,y = -38,size = 14,},
					gridW = 68,
					gridH = 68,
					iconW = 64,
					iconH = 64,
					smartWH = 1,
					codeOnItemDrop = function(self,item,relX,relY,screenX,screenY,Sprite)
						--print(self,item,relX,relY,screenX,screenY,Sprite,"ddd")
					end,
				})
				HireGridlist[#HireGridlist+1] = "armyGrid"
			end
		end
		--如果单位有可雇佣列表，则显示一些雇佣单位的信息
		local hire = targetU.data.hireList or 0
		if hire ~= 0 and type(hire) == "table" and #hire > 0 then
			for i = 1,#hire do
			-- 单位名字
			_childUI["nameint_"..i] = hUI.label:new({
				parent = _parent,
				size = 22,
				align = "MC",
				font = hVar.FONTC,
				x = 74+(i-1)*110,
				y = -260,
				width = 248,
				text = hVar.tab_stringU[hire[i][1]][1],
				border = 1,
				RGB = {255,255,0},
			})
			HireGridlist[#HireGridlist+1] = "nameint_"..i
			_childUI["slot_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI_frm:slot",
				animation = "lightSlim",
				w = 60,
				h = 54,
				x = 74+(i-1)*110,
				y = -220,
			})
			HireGridlist[#HireGridlist+1] = "slot_"..i
			local uModel = hVar.tab_unit[hire[i][1]].model or "MODEL:Default"
			_childUI["hirebutton_"..i] = hUI.button:new({
				dragbox = self.handle.__FrameUI.childUI["dragBox"],
				parent = _parent,
				model = uModel,
				w = 64,
				h = 64,
				x = 74+(i-1)*110,
				y = -240,
				animation = hApi.animationByFacing(uModel,"stand",180),
				codeOnTouch = function(self,x,y,sus)
					hGlobal.event:event("LocalEvent_ShowUnitInfoFram",nil,hire[i][1],380,550)
				end,
			})
			HireGridlist[#HireGridlist+1] = "hirebutton_"..i
			end
			
		end
		local TownData = targetU:gettown()
		--如果单位是一座城镇 切有守备英雄时
		if TownData then
			local gU = hApi.GetObjectUnit(TownData.data.guard)
			if gU then
				_childUI["GuardInfo"] = hUI.label:new({
					parent = _parent,
					text = hVar.tab_string["__TEXT_GuardHero"],
					size = 26,
					align = "LT",
					x = d.infoX-80,
					y = d.infoY-180,
					width = 372,
					border = 1,
					font = hVar.FONTC,
				})
				HireGridlist[#HireGridlist+1] = "GuardInfo"

				_childUI["GuardName"] = hUI.label:new({
					parent = _parent,
					text = hVar.tab_stringU[gU.data.id][1],
					size = 28,
					align = "MC",
					x = d.infoX + 110,
					y = d.infoY-260,
					width = 372,
					border = 1,
					font = hVar.FONTC,
				})
				HireGridlist[#HireGridlist+1] = "GuardName"
				_childUI["GuardInfoText"] = hUI.label:new({
					parent = _parent,
					text = "",
					size = 26,
					align = "LT",
					x = d.infoX + 175,
					y = d.infoY-145,
					width = 200,
					border = 1,
					font = hVar.FONTC,
				})
				HireGridlist[#HireGridlist+1] = "GuardInfoText"
				_childUI["guardinfoImagenBG"] = hUI.image:new({
					parent = _parent,
					model = "UI_frm:slot",
					animation = "lightSlim",
					w = 90,
					h = 90,
					x =  d.infoX + 110,
					y = d.infoY-195,
				})
				HireGridlist[#HireGridlist+1] = "guardinfoImagenBG"
				_childUI["GuardinfoImage"] = hUI.thumbImage:new({
					parent = _parent,
					model = hVar.tab_unit[gU.data.id].icon,
					facing = 0,
					x = d.infoX + 110,
					y = d.infoY-195,
					w = 82,
					h = 82,
				})
				HireGridlist[#HireGridlist+1] = "GuardinfoImage"
				team = gU.data.team
				if team~=0 then
					
					local _teamV = {}
					for i = 1,#team do
						local v = team[i]
						if v~=0 and hVar.tab_unit[v[1]] then
							if hVar.tab_unit[v[1]].type ~= hVar.UNIT_TYPE.HERO then
								_teamV[v[1]] = (_teamV[v[1]] or 0)+v[2]
							elseif v[1] ~= gU.data.id then
								_teamV[v[1]] = (_teamV[v[1]] or 0)+v[2]
							end
						end
						
					end
					local _team,_grid = {},{}
					for k,v in pairs(_teamV)do
						_team[#_team+1] = {k,v}
						_grid[#_grid+1] = 0
					end
					if #_team>0 then
						_childUI["TeamGrid"] = hUI.bagGrid:new({
							parent = _parent,
							tab = hVar.tab_unit,
							tabModelKey = "model",
							animation = function(id,model,gridX,gridY)
								return hApi.animationByFacing(model,"stand",0)
							end,
							align = "MC",
							grid = _grid,
							item = _team,
							slot = {model = "UI_frm:slot",animation = "normal",},
							x = 78,
							y = -380,
							--itemName = {x = 0,y = -38,size = 14,},
							gridW = 68,
							gridH = 68,
							iconW = 64,
							iconH = 64,
							smartWH = 1,
						})
						HireGridlist[#HireGridlist+1] = "TeamGrid"
					end
				end
			end
		end
		
		--在不是英雄的情况下 如果此单位有EXP 则显示一个 经验符号
		if hero == nil then
			--如果此单位有积分相关信息
			if targetU.data.mapScorePec > 0 then
				_childUI["expImage"] = hUI.image:new({
					parent = _parent,
					model = "UI:score",
					x = 544 - 60,
					y = -462 + 70,
					w = 44,
					h = 44,
				})
				HireGridlist[#HireGridlist+1] = "expImage"
			end
		end
	end
	if hero then
		_childUI["heroAttr"].handle._n:setVisible(true)
		local ha = hero.attr
		local aUI = _childUI["heroAttr"]
		
			aUI.childUI["attrHp"]:setText(tostring(ha.hp.."/"..ha.mxhp))
			aUI.childUI["barHp"]:setV(ha.hp,ha.mxhp)
			aUI.childUI["attrMp"]:setText(tostring(ha.mp.."/"..ha.mxmp))
			aUI.childUI["barMp"]:setV(ha.mp,ha.mxmp)
			aUI.childUI["attrLevel"]:setText(tostring(ha.level))
	

		local _,CExp,MExp = hero:getexp()

		aUI.childUI["attrExp"]:setText(tostring(CExp.."/"..MExp))
		aUI.childUI["barExp"]:setV(CExp,MExp)

		for i = 1,#hVar.HeroAttrNeedShow do
			local v = hVar.HeroAttrNeedShow[i]
			local attr = v.attr
			if ha[attr] then
				if _tabU.IsElite and _tabU.IsElite == 1 then
					aUI.childUI["attr_"..attr]:setText(tostring("???"))
				else
					aUI.childUI["attr_"..attr]:setText(tostring(ha[attr]))
				end
			end
		end

		_childUI["heroInfoLab"] = hUI.label:new({
			parent = _parent,
			text = hVar.tab_stringU[hero.data.id][2],
			size = 22,
			align = "LT",
			x = d.chaX+50,
			y = d.chaY+40,
			width =360,
			border = 1,
			RGB = {255,240,200},
			font = hVar.FONTC,
		})
		HireGridlist[#HireGridlist+1] = "heroInfoLab"

	else
		_childUI["heroAttr"].handle._n:setVisible(false)
	end

	if unitId then
		d.id = unitId

		if unitId==0 then
			
		else
			local uName,uHint = hApi.GetUnitName(targetU)
			--定义过收益率
			if hGlobal.WORLD.LastWorldMap and type(hGlobal.WORLD.LastWorldMap.data.ProvidePec) == "number" then
				local uTab = targetU:gettab()
				if uTab.provide then
					local nCount = uTab.provide[1][2]
					nCount = math.floor(nCount * hGlobal.WORLD.LastWorldMap.data.ProvidePec / 100 )
					if uHint then
						uHint = string.gsub(uHint,"%%(%w+)%%",nCount)
					end
				end
			end
			--背景底图
			_childUI["unitImageBG"] = hUI.image:new({
				parent = _parent,
				model = "UI_frm:slot",
				animation = "lightSlim",
				w = 78,
				h = 78,
				x = d.chaX,
				y = d.chaY,
			})
			HireGridlist[#HireGridlist+1] = "unitImageBG"

			local tempY,tempW=  d.chaY-20,82
			if hVar.tab_unit[unitId].type == hVar.UNIT_TYPE.BUILDING then
				if hVar.tab_stringU[unitId] and hVar.tab_stringU[unitId][6] then
					local tempres = {"res",hVar.tab_unit[unitId].provide[1][1]}
					_childUI["BUILDING_ima"] = hUI.image:new({
						parent = _parent,
						model = hApi.GetLootModel(tempres),
						w = 50,
						h = 50,
						x = 80,
						y = -190,
					})
					HireGridlist[#HireGridlist+1] = "BUILDING_ima"

					_childUI["buildingInfo"] = hUI.label:new({
						parent = _parent,
						text = hVar.tab_stringU[unitId][6],
						size = 26,
						align = "LT",
						x = 40,
						y = -220,
						width = 460,
						border = 1,
						font = hVar.FONTC,
					})
					HireGridlist[#HireGridlist+1] = "buildingInfo"
				end
				tempY = tempY+20
			elseif hVar.tab_unit[unitId].type == hVar.UNIT_TYPE.RESOURCE then
				tempW = 40
				tempY = tempY+20
			end
			
			--如果是英雄则画头像
			if hVar.tab_unit[unitId].type == 2 then
				_childUI["unitImage"] = hUI.image:new({
					parent = _parent,
					model = hVar.tab_unit[unitId].icon,
					x = d.chaX,
					y = tempY + 20,
					w = tempW - 8,
					h = tempW - 8,
				})
			else
				_childUI["unitImage"] = hUI.thumbImage:new({
					parent = _parent,
					id = unitId,
					facing = 0,
					x = d.chaX,
					y = tempY,
					w = tempW,
					h = tempW,
					smartWH = 2,
				})
				
			end
			HireGridlist[#HireGridlist+1] = "unitImage"
			
			local textlen = math.ceil(string.len(tostring(uHint))/26) 

			--如果单位是普通单位，则显示单位信息
			if targetU and targetU.data.type ~= 2 then
				_childUI["InfoLabel"] = hUI.label:new({
					parent = _parent,
					text = uHint,
					size = 26,
					align = "LT",
					x = d.infoX,
					y = -76 + textlen*10,
					width = 360,
					border = 1,
					font = hVar.FONTC,
					--RGB = {255,255,0},
				})
				HireGridlist[#HireGridlist+1] = "InfoLabel"
			end
			local _align = "MC"
			local _x = d.infoX - 50
			--if string.len(uName) > 6 then
				--_align = "LC"
				--_x = d.chaX-39
			--end
			_childUI["unitNameLabel"] = hUI.label:new({
				parent = _parent,
				text = uName,
				size = 22,
				align = _align,
				x =  _x,
				y =  d.infoY - 90,
				width = d.infoW,
				RGB = {255,205,55},
				border = 1,
				font = hVar.FONTC,
			})
			HireGridlist[#HireGridlist+1] = "unitNameLabel"
			--获取当前选中的单位
			local unit = hGlobal.LocalPlayer:getfocusunit()
			--如果单位是建筑单位，则显示单位冷却信息
			if targetU and unit and type(targetU:gettab().visit) == "table" then
				local text = hVar.tab_string["__TEXT_HeroVisited"]
				if targetU:iscooldown(unit) then 
					text = hVar.tab_string["__TEXT_YourHero"]..hVar.tab_stringU[unit.data.id][1]..hVar.tab_string["__TEXT_HeroNotVisit"]
				end

				_childUI["VisitorInfo"] = hUI.label:new({
					parent = _parent,
					text = text,
					size = 26,
					align = "LT",
					x = d.infoX-80,
					y = d.infoY-130,
					width = 430,
					font = hVar.FONTC,
					border = 1,
				})
				HireGridlist[#HireGridlist+1] = "VisitorInfo"
			end
		end
		r = hVar.RESULT_SUCESS
	end

	return r
end
--=============================================
-- 英雄信息
--=============================================
--hUI.gameHeroList = eClass:new("static")
--local _ghl =hUI.gameHeroList


--=============================================
-- 队伍信息
--=============================================
--hUI.gameUnitList = eClass:new("static")
--local _gul =hUI.gameUnitList
--local __DefaultParam = {
	--parent = 0,--hUI.__static.uiLayer,
	--x = 0,
	--y = 0,
	--w = 0,
	--h = 0,
--}
--_gul.destroy = hUI.destroyDefault
--_gul.init = function(self,p)
	--self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	--local d = self.data
	--self.handle = hApi.clearTable(0,self.handle)
	--self.childUI = hApi.clearTable(0,self.childUI)
	--local h = self.handle
	--local _childUI = self.childUI
	--_childUI["bar"] = hUI.bar:new({
		--model = "UI:BAR_TaskBG",
		--align = "LB",
		--x = d.x,
		--y = d.y,
		--w = 320,
		--h = 96,
	--})
--end

--=============================================
-- 目标操作面板
--=============================================
hUI.targetPanel = eClass:new("static")
local _gtp = hUI.targetPanel
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	userdata = 0,
	id = 0,
	world = 0,
	target = 0,
	orderUnit = 0,
	-------------------------
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	infoOnly = 0,
	opr = 1,
	--bindU = 0,
	--bindTag = 0,
}

hApi.ClassAutoReleaseByTick(hUI.targetPanel,"gametime","tick")
_gtp.destroy = hUI.destroyDefaultU
_gtp.bindWithUnit = hUI.bindWithUnit
_gtp.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	
	d.lastSelection = 0
	d.tick = 0
	d.bindU = 0
	d.bindTag = "targetPanel"
	d.grid = {}
	
	local _oUnit = hApi.GetObjectFromParam(d.orderUnit)
	local _oTarget = hApi.GetObjectFromParam(d.target)
	if _oTarget==nil then
		return self:del()
	end
	
	--创建node
	h._n = CCNode:create()
	if _oTarget.handle._tn~=nil then
		d.parent = _oTarget.handle._tn or hUI.__static.uiLayer
	else
		d.parent = _oTarget.handle._n or hUI.__static.uiLayer
	end
	
	
	d.parent:addChild(h._n)
	local _parent = h._n
	self:bindWithUnit(_oTarget)
	
	--action数据
	local gridWH = 50
	local iconWH = 46
	
	if g_phone_mode ~= 0 then
		gridWH = 64
		iconWH = 60
	end
	
	local tab = hVar.INTERACTION_ART
	local grid = {}
	local cTab = {build = {}, skill = {}, cskill = {},}
	local buttonLabel = {}
	local buttonState = {}
	d.grid = grid
	--{"ICON:action_attack","ICON:action_info","ICON:action_info","ICON:action_info","ICON:action_info"}
	local w = _oTarget:getworld()
	local skip_move = 0
	local skip_detail = 0
	local skip_interaction = 0
	
	local world = hGlobal.LocalPlayer:getfocusworld()
	local mapname = world.data.map
	
	--设置双击的默认操作为接下来创建的第一个按钮
	d.opr = #grid+1
	local tabU = hVar.tab_unit[_oTarget.data.id]
	if tabU==nil then
		--居然没有这个单位，去死
	elseif tabU.IsTGR==1 then
		--TGR单位只能查看，不能打
	
	--elseif tabU.isTower == 1 then
	elseif (_oTarget.data.type == hVar.UNIT_TYPE.TOWER) or (_oTarget.data.type == hVar.UNIT_TYPE.BUILDING) or (_oTarget.data.type == hVar.UNIT_TYPE.NPC_TALK) or (_oTarget.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --geyachao: 已修改塔类型的读取方式
		--塔防中的塔单位，显示建造按钮
		--local td_upgrade = tabU.td_upgrade
		local td_upgrade = _oTarget.td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
		local td_upgrade_me
		local targetPos = _oTarget:getowner():getpos()
		local playerMe = world:GetPlayerMe()
		if playerMe and playerMe:getgod() and playerMe:getgod().td_upgrade then
			td_upgrade_me = playerMe:getgod().td_upgrade[_oTarget.data.id]
		end
		--print("塔防中的塔单位，显示建造按钮", td_upgrade)
		
		--如果是蜀国或者魏国的塔基，并且我的属方和当前塔基属方相同
		local changeTdUpgrade = hApi.CheckChangeTDUpgrade(world, _oTarget)
		
		--print("_oTarget.data.type == hVar.UNIT_TYPE.TOWER" ,td_upgrade,type(td_upgrade))
		if td_upgrade and type(td_upgrade) == "table" then
			local remould = td_upgrade.remould
			local upgradeSkill = td_upgrade.upgradeSkill
			local castSkill = td_upgrade.castSkill
			if changeTdUpgrade and td_upgrade_me then
				remould = td_upgrade_me.remould
				castSkill = td_upgrade_me.castSkill
			end
			--print("remould", remould and (#remould.order))
			if remould then
				if remould.order and type(remould.order) == "table" then
					--geyachao: 特殊类型的塔，补齐所有的塔
					local bIsSpecifcalTower = false --是否是特殊的塔（高级塔）
					local typeId = _oTarget.data.id --单位类型id
					local specifyTypeIds = {10002, 10202, 10102} --中级箭塔、中级法术塔、中级炮塔
					local tacticArchys = {hVar.TACTIC_UPDATE_JIANTA, hVar.TACTIC_UPDATE_FASHUTA, hVar.TACTIC_UPDATE_PAOTA} --每种类型塔的升级战术技能列表
					for t = 1, #specifyTypeIds, 1 do
						if (typeId == specifyTypeIds[t]) then --中级箭塔/法术塔/炮塔
							bIsSpecifcalTower = true --是特殊的塔
							local unlock = {}
							
							--检测哪些战术技能卡是已经解锁的，用于绘制塔的改造分支图标
							--local tTactics = world:gettactics(hGlobal.LocalPlayer.data.playerId)
							local tTactics = world:gettactics(world:GetPlayerMe():getpos())
							if (type(tTactics) == "table") then
								for n = 1, #tTactics, 1 do
									if (tTactics[n] ~= 0) then
										local id, lv = tTactics[n][1], tTactics[n][2]
										for i = 1, #tacticArchys[t], 1 do
											if (tacticArchys[t][i] == id) then
												unlock[id] = true
											end
										end
									end
								end
							end
							
							--依次继续绘每个高级塔
							for u = 1, #tacticArchys[t], 1 do
								local tacticId = tacticArchys[t][u] --应该绘制的战术技能卡id
								local remouldUnlock = hVar.tab_tactics[tacticId].remouldUnlock --战术技能卡可以解锁的塔列表（从1级到10级）
								
								--print(tacticId, unlock[tacticId])
								if (not unlock[tacticId]) then --未解锁的塔（战术卡）
									local unitTypeId = remouldUnlock[1][1]
									--print(unitTypeId)
									grid[#grid+1] = unitTypeId
									tab[unitTypeId] = {icon = hVar.tab_tactics[tacticId].icon}
									--cTab.skill[skillId] = {maxSkillLv = 0, costs = costs
									buttonState[#grid] = -1
								else --已解锁的塔（战术卡）
									for i = 1, #remould.order, 1 do
										local buildId = remould.order[i]
										local buildInfo = remould[buildId]
										--print("i=" .. i .. ", buildId=" .. buildId, "isUnlock=", buildInfo and buildInfo.isUnlock)
										
										--如果unlock是false该则不创建按钮(带了对应的塔卡，会标记对应等级的isUnlock为true)
										if buildInfo and buildInfo.isUnlock then
											--检测是否为该战术技能卡能解锁的塔
											local bIsUnlockedTower = false
											for s = 1, #remouldUnlock, 1 do
												local tid = remouldUnlock[s][1]
												--print("tid=" .. tid)
												if (tid == buildId) then
													bIsUnlockedTower = true
													break
												end
											end
											
											if bIsUnlockedTower then
												--print("buildId=", buildId)
												grid[#grid+1] = buildId
												tab[buildId] = {icon = buildInfo.icon}
												cTab.build[buildId] = {cost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0),unlockCondition = buildInfo.unlockCondition}
											end
										end
									end
								end
							end
						end
					end
					
					--print("bIsSpecifcalTower", bIsSpecifcalTower)
					--非特殊的塔
					if (not bIsSpecifcalTower) then
						for i = 1, #remould.order do
							local buildId = remould.order[i]
							local buildInfo = remould[buildId]
							--如果没有解锁则不创建按钮
							if buildInfo and buildInfo.isUnlock then
								grid[#grid+1] = buildId
								tab[buildId] = {icon = buildInfo.icon}
								cTab.build[buildId] = {cost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0),unlockCondition = buildInfo.unlockCondition}
							end
						end
					end
				else
					for buildId, buildInfo in pairs(remould) do
						if buildId ~= "order" then
							--如果没有解锁则不创建按钮
							if buildInfo.isUnlock then
								grid[#grid+1] = buildId
								tab[buildId] = {icon = buildInfo.icon}
								cTab.build[buildId] = {cost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0),unlockCondition = buildInfo.unlockCondition}
							end
						end
					end
				end
			elseif upgradeSkill then
				
				--local createFlag = false
				local createFlag = true --geyachao: 满级也绘制（查看当前升到什么程度）
				--检测是否所有技能已经升满级，升满级不创建
				for skillId, skillInfo in pairs(upgradeSkill) do
					if skillId ~= "order" then
						--如果没有解锁则不创建按钮
						if skillInfo.isUnlock then
							local maxSkillLv = skillInfo.maxLv or 1
							local skillLv = 0
							local skillObj = _oTarget:getskill(skillId)
							if skillObj then
								skillLv = skillObj[2] or 0
							end
							if skillLv < maxSkillLv then
								createFlag = true
								break
							end
						end
					end
				end
				
				--print("createFlag", createFlag)
				if createFlag then
					if upgradeSkill.order and type(upgradeSkill.order) == "table" then
						for i = 1, #upgradeSkill.order do
							local skillId = upgradeSkill.order[i]
							local skillInfo = upgradeSkill[skillId]
							--如果没有解锁则不创建按钮
							if skillInfo and skillInfo.isUnlock then
								local maxSkillLv = hApi.GetTowerSkillMaxLv(w,_oTarget:getowner(),skillInfo)
								
								grid[#grid+1] = skillId
								tab[skillId] = {icon = skillInfo.icon}
								
								--资金消耗需要加上战术技能卡的修改值
								local costs = {}
								if not skillInfo.costAdd or type(skillInfo.costAdd) ~= "table" then
									skillInfo.costAdd = {}
								end
								for i = 1, #skillInfo.cost do
									local cost = (skillInfo.cost[i] or 0) + (skillInfo.costAdd[i] or 0)
									table.insert(costs, cost)
								end
								cTab.skill[skillId] = {maxSkillLv = maxSkillLv, costs = costs }
								
								local skillObj = _oTarget:getskill(skillId)
								local skillLvNow = 0
								if skillObj then
									skillLvNow = skillObj[2]
								end
								
								buttonLabel[#grid] = tostring(skillLvNow) .. "/" .. tostring(maxSkillLv)
								
								if skillLvNow >= maxSkillLv then
									buttonState[#grid] = -1
								end
							--geyachao: 不能升级的技能也显示出来，在UI上显示未解锁的图标
							else --该塔单位未开放的技能
								grid[#grid+1] = skillId
								tab[skillId] = {icon = hVar.tab_skill[skillId].icon}
								--cTab.skill[skillId] = {maxSkillLv = 0, costs = costs
								buttonState[#grid] = -1
							end
						end
					else
						for skillId, skillInfo in pairs(upgradeSkill) do
							if skillId ~= "order" then
								--如果没有解锁则不创建按钮
								if skillInfo.isUnlock then
									local maxSkillLv = hApi.GetTowerSkillMaxLv(w,_oTarget:getowner(),skillInfo)
									grid[#grid+1] = skillId
									tab[skillId] = {icon = skillInfo.icon}
									
									--资金消耗需要加上战术技能卡的修改值
									local costs = {}
									if not skillInfo.costAdd or type(skillInfo.costAdd) ~= "table" then
										skillInfo.costAdd = {}
									end
									for i = 1, #skillInfo.cost do
										local cost = (skillInfo.cost[i] or 0) + (skillInfo.costAdd[i] or 0)
										table.insert(costs, cost)
									end
									cTab.skill[skillId] = {maxSkillLv = maxSkillLv, costs = costs }
									
									local skillObj = _oTarget:getskill(skillId)
									local skillLvNow = 0
									if skillObj then
										skillLvNow = skillObj[2]
									end
									
									buttonLabel[#grid] = tostring(skillLvNow) .. "/" .. tostring(maxSkillLv)
									
									if skillLvNow >= maxSkillLv then
										buttonState[#grid] = -1
									end
								end
							end
						end
					end
				end
			elseif castSkill then
				if castSkill.order and type(castSkill.order) == "table" then
					for i = 1, #castSkill.order do
						local skillId = castSkill.order[i]
						local skillInfo = castSkill[skillId]
						--如果没有解锁则不创建按钮
						if skillInfo and skillInfo.isUnlock then
							local casttype = skillInfo.casttype or hVar.CAST_TYPE.IMMEDIATE
							grid[#grid+1] = skillId
							tab[skillId] = {icon = skillInfo.icon}
							
							cTab.cskill[skillId] = {casttype = casttype, cost = (skillInfo.cost or 0) + (skillInfo.costAdd or 0)}
						end
					end
				else
					for skillId, skillInfo in pairs(castSkill) do
						if skillId ~= "order" then
							--如果没有解锁则不创建按钮
							if skillInfo.isUnlock then
								local casttype = skillInfo.casttype or hVar.CAST_TYPE.IMMEDIATE
								grid[#grid+1] = skillId
								tab[skillId] = {icon = skillInfo.icon}
								--local cost = skillInfo.cost or 0
								cTab.cskill[skillId] = {casttype = casttype, cost = (skillInfo.cost or 0) + (skillInfo.costAdd or 0)}
							end
						end
					end
				end
			end
			
			--拆塔
			--判断是否需要创建拆除按钮，如果是无尽模式，并且不是塔基
			if w then
				local mapInfo = w.data.tdMapInfo
				if mapInfo and (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
					local uId = _oTarget.data.id
					local tabU = hVar.tab_unit[uId]
					if tabU then
						local tagT = tabU.tag
						if tagT then
							for k, v in pairs (hVar.UNIT_TAG_TYPE.TOWER) do
								if tagT[v] then
									grid[#grid+1] = hVar.INTERACTION_TYPE.TD_SELL_TOWER
									tab[hVar.INTERACTION_TYPE.TD_SELL_TOWER] = {icon = hVar.INTERACTION_ART[hVar.INTERACTION_TYPE.TD_SELL_TOWER].icon}
									break
								end
							end
						end
					end
				end
			end
		end

	elseif w.data.type=="worldmap" and _oUnit==nil then
		
		local oTown = _oTarget:gettown() 
		if oTown and hGlobal.LocalPlayer:allience(_oTarget:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
			local gu = oTown:getunit("guard")
			if gu then
				grid[#grid+1] = hVar.INTERACTION_TYPE.LEAVETOWN
			end
		end
		if _oTarget.data.townID~=0 and hGlobal.LocalPlayer:allience(_oTarget:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
			grid[#grid+1] = hVar.INTERACTION_TYPE.LOOK
		end
		skip_move = 1

	elseif _oTarget==_oUnit or d.infoOnly==1 then
		--grid[#grid+1] = hVar.INTERACTION_TYPE.DETAIL
		skip_move = 1
		skip_detail = 1
	else
		local allience = hVar.PLAYER_ALLIENCE_TYPE.NONE
		if _oUnit~=nil then
			if _oTarget.data.type==hVar.UNIT_TYPE.UNIT or _oTarget.data.type==hVar.UNIT_TYPE.HERO then
				allience = _oUnit:getowner():allience(_oTarget:getowner())
				if allience==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
					if _oTarget.data.team~=0 then
						grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
						skip_interaction = 1
						skip_move = 1
					end
				elseif allience==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
					grid[#grid+1] = hVar.INTERACTION_TYPE.JOIN
					skip_move = 1
				elseif allience==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
					
				else
					if _oTarget.data.team~=0 then
						grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
						skip_move = 1
					end
				end
			elseif _oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
				allience = _oUnit:getowner():allience(_oTarget:getowner())
				local oTown = _oTarget:gettown()
				if allience==hVar.PLAYER_ALLIENCE_TYPE.NEUTRAL then
					if w.data.type=="worldmap" then
						if oTown~=nil then
							local tTeam = _oTarget.data.team
							local NeedAttack = 1
							if type(tTeam)=="table" then
								NeedAttack = 0
								for i = 1,#tTeam do
									if tTeam[i]~=0 and type(tTeam[i])=="table" and tTeam[i][1]~=0 and tTeam[i][2]~=0 then
										NeedAttack = 1
										break
									end
								end
							else
								NeedAttack = 0
							end
							if NeedAttack==1 then
								--攻打城市
								grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
								skip_move = 1
								skip_interaction = 1
							else
								--占领城市
								grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
								skip_move = 1
								skip_interaction = 1
							end
						elseif tabU.seizable==1 then
							--矿洞或者资源也可以占领
							grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
							skip_move = 1
							skip_interaction = 1
						elseif _oTarget.data.team~=0 then
							grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
							skip_move = 1
							skip_interaction = 1
						end
					end
				elseif allience==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
					skip_interaction = 1
					if oTown~=nil then
						grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
						skip_move = 1
					elseif tabU.seizable==1 and _oTarget.data.team==0 then
						if hApi.Is_WDLD_Map(hGlobal.WORLD.LastWorldMap.data.map) ~= -1 then
							local td = _oTarget:gettriggerdata()
							if td ~= nil then
								if td.guard ~= nil then
									if td.guard[1] ~=nil and td.guard[1] == 0 then
										grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
									end
								else
									grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
								end
							else
								grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
							end
						else
							grid[#grid+1] = hVar.INTERACTION_TYPE.OCCUPY
						end
						skip_move = 1
					else
						grid[#grid+1] = hVar.INTERACTION_TYPE.ATTACK
						skip_move = 1
					end
				elseif allience==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
					if w.data.type=="worldmap" then
						if _oTarget:gettown()~=nil then
							grid[#grid+1] = hVar.INTERACTION_TYPE.ENTER
							grid[#grid+1] = hVar.INTERACTION_TYPE.LOOK
							skip_move = 1
						end
					end
				end
			else
				--skip_detail = 1
			end
			if skip_interaction~=1 and tabU.interaction~=nil then
				--有特殊交互的单位
				for i = 1,#tabU.interaction do
					local v = tabU.interaction[i]
					if v==hVar.INTERACTION_TYPE.OCCUPY then
						
					elseif v==hVar.INTERACTION_TYPE.ENTER then

					elseif v==hVar.INTERACTION_TYPE.DETAIL then
						skip_detail = 1
					else
						if v==hVar.INTERACTION_TYPE.LOOT or hVar.INTERACTION_TYPE.PICK  or hVar.INTERACTION_TYPE.HIRE or hVar.INTERACTION_TYPE.SHOP then
							skip_move = 1
						end
						grid[#grid+1] = v
					end
				end
			end
			if w.data.type=="worldmap" and skip_move==0 and allience==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
				grid[#grid+1] = hVar.INTERACTION_TYPE.JOIN
				skip_move = 1
			end
		end
		
		--判断是否具有谈话
		if _oTarget.data.talkTag~=-1 and (allience==hVar.PLAYER_ALLIENCE_TYPE.ALLY or (allience~=hVar.PLAYER_ALLIENCE_TYPE.ENEMY and _oTarget.data.team==0)) then
			local tTalk = _oTarget:gettalk()
			if tTalk then
				local CanTalk = 0
				for i = 1,#tTalk do
					if tTalk[i][1]=="talk" then
						CanTalk = 1
					end
				end
				if CanTalk==1 then
					grid[#grid+1] = hVar.INTERACTION_TYPE.TALK
					skip_move = 1
				end
			end
		end
		
		--根据 townData 表中的 upgrade 数据项 添加 grid 操作按钮 陶晶 2013-4-12
		if w.data.type=="town" and _oTarget.data.indexOfCreate~=0 then
			local oBuilding = w:getlordU("building")
			if oBuilding then
				local oTown = oBuilding:gettown()
				if oTown then
					local upgradelist = oTown.data.upgrade
					if upgradelist~= nil and upgradelist ~= 0 then
						for i = 1, #upgradelist do
							if upgradelist[i].indexOfCreate == _oTarget.data.indexOfCreate and upgradelist[i].upgradelist[1] == 0 then
								grid = {}
								grid[#grid+1] = hVar.INTERACTION_TYPE.UPGRADE
							elseif upgradelist[i].indexOfCreate == _oTarget.data.indexOfCreate and upgradelist[i].upgradelist[1] == 1 and upgradelist[i].upgradelist[2] ~= 0 then						
								grid[#grid+1] = hVar.INTERACTION_TYPE.UPGRADE
							end
						end
					end
					
				end
			end
		end
	end
	--if w.data.type=="worldmap" and skip_move==0 then
		--grid[#grid+1] = hVar.INTERACTION_TYPE.MOVETO
	--end
	if skip_detail~=1 then
		--grid[#grid+1] = hVar.INTERACTION_TYPE.DETAIL
	end
	local px,py = -16,-36
	local offset = 10
	px = -1*hApi.getint((#grid-1)*(gridWH + offset)/2)
	local bx,by,bw,bh = hApi.SpriteGetBoundingBox(_oTarget.handle)
	if bx then
		py = hApi.getint(-by+gridWH/2)
		if w.data.type=="town" then
			local cx,cy = _oTarget:getXY()
			local vX,vY = hApi.world2view(cx-px,cy-py)
			local nY = hVar.SCREEN.h - vY
			local offsetY = math.floor(gridWH/2+10)
			if nY<offsetY then
				py = py + nY - offsetY
			end

			if vX < 130 then
				px  = px + 50
			end

			if g_phone_mode == 2 then
				if vX < 220 then
					px  = px + 40
				end
			end

		end
	end
	local spreadFrom
	if px~=0 then
		spreadFrom = {-1*px,0,250}
	end
	
	--操作面板背景条
	_childUI["actionBar"] = hUI.bar:new({
		parent = _parent,
		--model = "UI:BAR_talk_bg",
		model = "UI:BAR_remould_bg",
		align = "LC",
		x = px-hApi.getint((gridWH + offset)/2),
		y = py + offset / 2,
		w = (gridWH + offset)*#grid,
		h = gridWH + offset,
		alpha = 0, --geyacgao: 战车不显示背景图
	})
	_childUI["actionBar"].handle.sC:setOpacity(0) --geyacgao: 战车不显示背景图
	_childUI["actionBar"].handle.sL:setOpacity(0) --geyacgao: 战车不显示背景图
	_childUI["actionBar"].handle.sR:setOpacity(0) --geyacgao: 战车不显示背景图
	
	--[[
	 --geyacgao: 战车不显示背景图
	--if tabU and tabU.isTower == 1 then
	if tabU and ((tabU.type == hVar.UNIT_TYPE.TOWER) or (tabU.type == hVar.UNIT_TYPE.BUILDING) or (tabU.type == hVar.UNIT_TYPE.NPC_TALK)) or (tabU.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --geyachao: 已修改塔类型的读取方式
		_childUI["actionBar"].childUI["imgArror"]  = hUI.image:new({
			parent = _childUI["actionBar"].handle._n,
			model = "UI:td_remould_bar_bottom",
			x = ((gridWH + offset)*#grid) * 0.5,
			y = -(gridWH + offset * 1.6) * 0.5,
			scale = 0.6,
		})
	end
	]]
	
	local clickIndex = -1 --当前点击按钮
	--创建提示信息面板
	_childUI["actionTip"] = hUI.bar:new({
		parent = _parent,
		model = "UI:BAR_talk_bg",
		align = "LC",
		x = (-1*hApi.getint(3*gridWH/2))-hApi.getint(gridWH/2),
		y = py + gridWH * 1.5,
		w = gridWH*4,
		h = gridWH * 2,
	})
	
	_childUI["tipName"] = hUI.label:new({
		parent = _parent,
		size = 16,
		text = "",
		align = "MC",
		border = 1,
		x = (-1*hApi.getint(3*gridWH/2))+hApi.getint(gridWH * 1.5),
		y = py + hApi.getint(gridWH * 2.1),
	})
	
	_childUI["tipInfo"] = hUI.label:new({
		parent = _parent,
		size = 16,
		text = "",
		align = "MC",
		border = 1,
		x = (-1*hApi.getint(3*gridWH/2))+hApi.getint(gridWH * 1.5),
		y = py + hApi.getint(gridWH * 1.5),
	})
	
	_childUI["confirmTip"] = hUI.label:new({
		parent = _parent,
		size = 16,
		text = hVar.tab_string["__TEXT_TDConfirmTip"],
		RGB = {0,255,0},
		align = "MC",
		border = 1,
		x = (-1*hApi.getint(3*gridWH/2))+hApi.getint(gridWH * 1.5),
		y = py + hApi.getint(gridWH * 0.9),
	})
	
	local function _showHint(_oTarget,font,text)
		hUI.floatNumber:new({
			unit = _oTarget,
			font = font,
			size = 18,
			text = text,
			lifetime = 1500,
			fadeout = -250,
			y = 32,
			moveY = 4,
			jumpH = 10,
		})
	end
	
	local function _showTip(idType, nTabId, nTabLv)
		if _childUI["actionTip"] then
			_childUI["actionTip"].handle._n:setVisible(true)
		end
		
		if _childUI["tipName"] then
			_childUI["tipName"].handle._n:setVisible(true)
		end
		
		if _childUI["tipInfo"] then
			_childUI["tipInfo"].handle._n:setVisible(true)
		end
		
		if _childUI["confirmTip"] then
			_childUI["confirmTip"].handle._n:setVisible(true)
		end
		
		local _idType = 0 --默认为建筑
		if idType then
			_idType = idType
		end
		
		local tabS = {}
		--建筑
		if _idType == 0 then
			tabS = hVar.tab_stringU[nTabId] or {}
		else --技能
			tabS = hVar.tab_stringS[nTabId] or {}
			--tabS = hVar.SKILL_INFO_PARAM[nTabId] or {}
		end
		
		local nmae = tabS[1] or "lab_name"
		local info = tabS[2] or "lab_info"
		if _idType == 1 then
			info = tabS[(nTabLv or 1) + 1] or "lab_info"
		end
		
		if _childUI["tipName"] then
			_childUI["tipName"]:setText(tostring(nmae))
		end
		
		if _childUI["tipInfo"] then
			_childUI["tipInfo"]:setText(tostring(info))
		end
	end
	
	local function _closeTip()
		if _childUI["actionTip"] then
			_childUI["actionTip"].handle._n:setVisible(false)
		end
		
		if _childUI["tipName"] then
			_childUI["tipName"].handle._n:setVisible(false)
		end
		
		if _childUI["tipInfo"] then
			_childUI["tipInfo"].handle._n:setVisible(false)
		end
		
		if _childUI["confirmTip"] then
			_childUI["confirmTip"].handle._n:setVisible(false)
		end
	end
	
	--初始化不显示Tip
	_closeTip()
	
	_childUI["dragBox"] = hUI.dragBox:new({
		worldnode = _oTarget.handle._n,
		x = d.x,
		y = d.y,
	})
	
	local _InfoUnit = {}
	
	--print(debug.traceback())
	
	--创建操作面板
	_childUI["actions"] = hUI.grid:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _childUI["dragBox"],
		x = px,
		y = py + offset * 0.9,
		iconW = iconWH,
		iconH = iconWH,
		gridW = gridWH + offset,
		gridH = gridWH,
		tab = tab,
		customTab = cTab,
		tabModelKey = "icon",
		grid = grid,
		spreadFrom = spreadFrom,
		buttonState = buttonState,
		code = function(opr,btn,userdata,gx,gy,customTab)
			local p = hGlobal.LocalPlayer
			--local w = _oTarget:getworld()
			if w==nil then
				return
			end
			local gridX,gridY = _oTarget.data.gridX,_oTarget.data.gridY
			d.lastSelection = opr
			hGlobal.event:event("LocalEvent_HideHeroTeamList")
			if opr==hVar.INTERACTION_TYPE.DETAIL then
				self:settick(250)
				--print(">>>>>>>> self:settick(250) 1")
				local hero = _oTarget:gethero()
				if hero and _oTarget:getowner() ==  p  then
					local mapbag = w.data.mapbag or 0
					if type(mapbag) == "table" then
						mapbag = 1
					end
					return hGlobal.event:event("LocalEvent_showHeroCardFrm",hero,nil,mapbag)
				end
				
				local item = _oTarget:getitem() 
				if item then
					return  hGlobal.event:event("LocalEvent_ShowItemInfoFrm",item.data.id)
				end
				local uCard = hGlobal.O["UI_HEROCARD"]
				if uCard==nil then return end
				--显示详细信息
				local x,y = hApi.world2view(w:grid2xy(gridX,gridY))
				x = x + 32
				y = y - 54
				local _u = hApi.GetObject(_InfoUnit)
				hApi.SetObject(_InfoUnit,_oTarget)
				
				uCard:reload(_oTarget.data.id,_oTarget)
				if _u==_oTarget then
					local IsShow = uCard.data.IsShow
					if uCard.handle.__FrameUI~=nil then
						local _frm = uCard.handle.__FrameUI
						IsShow = _frm.data.show
						if IsShow==0 then
							uCard:show(1,0.5)
						elseif IsShow==1 then
							uCard:show(0,0.5)
							_frm:onscreen(64)
						end
					else
						if IsShow==0 then
							uCard:show(1,0.5)
						elseif IsShow==1 then
							uCard:show(0,0.5)
						end
					end
				else
					uCard:show(1,0.5)
				end
				
			elseif opr == hVar.INTERACTION_TYPE.TD_SELL_TOWER then
				--mapInfo.gold = mapInfo.gold - goldCost
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
				--hGlobal.event:event("Event_TowerUpgradeCostRefresh")
				
				--geyachao: 改为发送指令-卖塔
				--print("改为发送指令-卖塔")
				hApi.AddCommand(hVar.Operation.SellTower, _oTarget:getworldI(), _oTarget:getworldC())
				
				clickIndex = -1
			else
				if w.data.type=="worldmap" then
					if customTab and type(customTab) == "table" then
						
						if customTab.build[opr] then --建筑
							
							clickIndex = gx --zhenkira,去掉提示面板， 2015.11.17
							if clickIndex == -1 or clickIndex ~= gx then --第一次点击
								clickIndex = gx
								_showTip(0, opr)
							elseif clickIndex == gx then --确认点击
								local buildId = opr
								local goldCost = customTab.build[opr].cost
								
								if _oTarget then
									local unlockCondition = customTab.build[opr].unlockCondition
									--print("opr:",opr, unlockCondition)
									if unlockCondition then
										local tacticId = unlockCondition[1]
										local buildNum = unlockCondition[2]
										local buildIdList = unlockCondition[3] or {}
										--取当前造了多少个指定的塔
										local buildNumNow = hApi.GetBuildTowerNum(w, _oTarget:getowner():getpos(), buildIdList)
										
										--print("buildNumNow:",tacticId,buildNum,buildIdList[1],buildNumNow)
										
										if (buildNumNow < buildNum) then
											--冒字
											--oUnit, text, color, offsetX, offsetY, fontSize, showTime, modelTable
											--"拥有3个火焰塔才能建造"
											local str = hVar.tab_string["__TEXT_HAVE"] .. buildNum .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_stringT[tacticId][1] .. hVar.tab_string["__TEXT_CANBUILD"]
											hApi.ShowLabelBubble(_oTarget, str, ccc3(255, 255, 0), 0, 65, nil, 2000, {model = "UI:AttrBg", x = 1, y = 1, z = -1, w = 240, h = 32,})
											
											return
										end
									end
									
									--geyachao: 改为发送指令-建造塔
									--print("改为发送指令-建造塔")
									--print(_oTarget:getworldI(), _oTarget.data.id, buildId, goldCost)
									hApi.AddCommand(hVar.Operation.BuildTower, _oTarget:getworldI(), _oTarget:getworldC(), buildId, goldCost)
									
									clickIndex = -1
									
									--触发事件: 操作面板关闭
									hGlobal.event:event("LocalEvent_OperationPanelClosed", "build_tower")
								end
							end
							
							return
						elseif customTab.skill[opr] then --技能
							clickIndex = gx --zhenkira,去掉提示面板， 2015.11.17
							if clickIndex == -1 or clickIndex ~= gx then --第一次点击
								clickIndex = gx
								local skillLv
								if _oTarget then
									local skillObj = _oTarget:getskill(opr)
									if skillObj then
										--角色技能升级
										skillLv= skillObj[2] + 1
									end
								end
								_showTip(1, opr, skillLv)
							elseif clickIndex == gx then --确认点击
								
								local skillId = opr
								local skillLvNow = 0 --geyachao: 提炼出技能升级后等级
								local maxSkillLv = customTab.skill[opr].maxSkillLv or 1
								local mapInfo = w.data.tdMapInfo
								--local goldNow = mapInfo.gold or 0
								local goldNow = 0
								local goldCost = 0 --geyachao: 提炼出扣钱
								
								if (_oTarget ~= nil) then
									--local targetP = _oTarget:getowner()
									local targetP = w:GetPlayerMe()
									if targetP then
										goldNow = targetP:getresource(hVar.RESOURCE_TYPE.GOLD)
									end
									local skillObj = _oTarget:getskill(skillId)
									if skillObj then
										--if (skillObj[2] < maxSkillLv) and (hVar.InProcessingUpgrateTowerSkill == 0) then --geyachao: 一次只能处理一个升级
										if (skillObj[2] < maxSkillLv) then
											--角色技能升级
											skillLvNow = skillObj[2] + 1
											goldCost = customTab.skill[opr].costs[skillLvNow] or 0
											
											if (goldNow >= goldCost) then
												--geyachao: 改为发送指令-升级塔科技
												--print("改为发送指令-升级塔科技2")
												--hVar.InProcessingUpgrateTowerSkill = 1 --是否正在处理升级塔的技能中
												hApi.AddCommand(hVar.Operation.UpgrateTowerSkill, _oTarget:getworldI(), _oTarget:getworldC(), skillId, skillLvNow, goldCost)
												
												--[[
												mapInfo.gold = mapInfo.gold - goldCost
												hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
												hGlobal.event:event("Event_TowerUpgradeCostRefresh")
												
												--累加建造花费
												_oTarget.data.allBuildCost = (_oTarget.data.allBuildCost or 0) + goldCost
												
												_oTarget:learnSkill(skillId, skillLvNow)
												
												--播放音效
												hApi.PlaySound("level_up")
												local unitData = _oTarget.data
												w:addeffect(194,1,nil,unitData.worldX,unitData.worldY)
												]]
												
												if btn.childUI then
													if btn.childUI["cost"] then
														if (skillLvNow < maxSkillLv) then
															local nextCost = customTab.skill[opr].costs[skillLvNow + 1] or "-"
															
															if (nextCost > 999) then
																btn.childUI["cost"]:setText("")
															elseif (nextCost > 0) then
																btn.childUI["cost"]:setText(tostring(nextCost))
															else
																btn.childUI["cost"]:setText("")
															end
														else
															btn.childUI["cost"]:setText(tostring("N/A"))
														end
													end
													
													--此处是塔拥有某个技能，更新技能界面的地方
													local _btnChildUI = btn.childUI
													if (_btnChildUI["skillLv"] ~= nil) then
														_btnChildUI["skillLv"]:del()
														_btnChildUI["skillLv"] = nil
													end
													
													--geyachao: 显示技能等级的小点点
													local point_y = 34
													if (g_phone_mode ~= 0) then --非电脑、平板模式
														point_y = 42
													end
													_btnChildUI["skillLv"] = hUI.button:new({
														parent = btn.handle._n,
														model = "UI:skill_point",
														x = 0,
														y = point_y,
														w = 1,
														h = 1,
													})
													_btnChildUI["skillLv"].handle.s:setOpacity(0)
													local ch = _btnChildUI["skillLv"] --子父控件
													
													--角色学习技能
													--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
													if not mapInfo.skillLvupToMax then
														--绘制每一个小点点
														local edge = 14 --边长
														local offset_x = 3 --x间距
														if (maxSkillLv == 4) then --数量过多，只能压缩间距
															offset_x = -1 --x间距
														elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
															offset_x = -3 --x间距
														end
														if (g_phone_mode ~= 0) then --非电脑、平板模式
															edge = 16
															offset_x = 3
															if (maxSkillLv == 4) then --数量过多，只能压缩间距
																offset_x = -1 --x间距
															elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
																offset_x = -3 --x间距
															end
														end
														local left_x = -math.floor(maxSkillLv / 2) * (edge + offset_x)
														if ((maxSkillLv % 2) == 0) then --偶数往右移半格
															left_x = left_x + (edge + offset_x) / 2
														end
														--skillLvNow) .. "/" .. tostring(maxSkillLv
														--底纹
														for i = 1, maxSkillLv, 1 do
															ch.childUI["point_bg" .. i] = hUI.image:new({
																parent = ch.handle._n,
																model = "UI:skill_point_slot",
																x = left_x + (i - 1) * (edge + offset_x),
																y = 0,
																w = edge,
																h = edge,
															})
														end
														--已获得的技能等级
														for i = 1, skillLvNow, 1 do
															ch.childUI["point" .. i] = hUI.image:new({
																parent = ch.handle._n,
																model = "UI:skill_point",
																x = left_x + (i - 1) * (edge + offset_x),
																y = 0,
																w = edge,
																h = edge,
															})
														end
													end
													
													--zhenkira: 2015.11.20 不显示等级文字了
													--[[
													if btn.childUI["skillLv"] then
														btn.childUI["skillLv"]:setText(tostring(skillLvNow) .. "/" .. tostring(maxSkillLv))
													end
													--]]
												end
												
												--如果已经满级，则设置按钮不可用
												if (skillLvNow >= maxSkillLv) then
													--print("btn:setstate(0)     1")
													btn:setstate(0)
												else
													--计算下一级消耗，如果当前的钱不足则设置为不可用
													local nextCost = customTab.skill[opr].costs[skillLvNow + 1]
													--if (type(nextCost) ~= "number") or (mapInfo.gold < nextCost) then
													if (type(nextCost) ~= "number") or (targetP:getresource(hVar.RESOURCE_TYPE.GOLD) < nextCost) then
														--print("btn:setstate(0)     2")
														btn:setstate(0)
													end
												end
												
												--[[
												--刷新技能范围
												hGlobal.event:event("Event_TDUnitActived", w, 1, _oTarget)
												
												--统计科技升级
												LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildS)
												LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildS)
												
												--存档
												--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
												]]
											end
										end
									else
										--角色学习技能
										--if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										if mapInfo.skillLvupToMax then
											skillLvNow = maxSkillLv
											for i = 1, maxSkillLv do
												goldCost = goldCost + customTab.skill[opr].costs[i] or 0
											end
										else
											skillLvNow = 1
											goldCost = customTab.skill[opr].costs[skillLvNow] or 0
										end
										
										--if (goldNow >= goldCost) and (hVar.InProcessingUpgrateTowerSkill == 0) then --geyachao: 一次只能处理一个升级
										if (goldNow >= goldCost) then
											--geyachao: 改为发送指令-升级塔科技
											--print("改为发送指令-升级塔科技1")
											--hVar.InProcessingUpgrateTowerSkill = 1 --是否正在处理升级塔的技能中
											hApi.AddCommand(hVar.Operation.UpgrateTowerSkill, _oTarget:getworldI(), _oTarget:getworldC(), skillId, skillLvNow, goldCost)
											
											--[[
											mapInfo.gold = mapInfo.gold - goldCost
											hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
											hGlobal.event:event("Event_TowerUpgradeCostRefresh")
											
											--累加建造花费
											_oTarget.data.allBuildCost = (_oTarget.data.allBuildCost or 0) + goldCost
											
											_oTarget:learnSkill(skillId, skillLvNow)
											
											--播放音效
											hApi.PlaySound("level_up")
											local unitData = _oTarget.data
											w:addeffect(194,1,nil,unitData.worldX,unitData.worldY)
											]]
											
											if btn.childUI then
												if btn.childUI["cost"] then 
													if (skillLvNow < maxSkillLv) then
														local nextCost = customTab.skill[opr].costs[skillLvNow + 1] or "-"
														--print("nextCost", nextCost)
														if (nextCost > 999) then
															btn.childUI["cost"]:setText("")
														elseif (nextCost > 0) then
															btn.childUI["cost"]:setText(tostring(nextCost))
														else
															btn.childUI["cost"]:setText("")
														end
													else
														btn.childUI["cost"]:setText(tostring("N/A"))
													end
												end
												
												--此处是塔还没某个技能，更新技能界面的地方
												local _btnChildUI = btn.childUI
												if (_btnChildUI["skillLv"] ~= nil) then
													_btnChildUI["skillLv"]:del()
													_btnChildUI["skillLv"] = nil
												end
												
												--geyachao: 显示技能等级的小点点
												local point_y = 34
												if (g_phone_mode ~= 0) then --非电脑、平板模式
													point_y = 42
												end
												_btnChildUI["skillLv"] = hUI.button:new({
													parent = btn.handle._n,
													model = "UI:skill_point",
													x = 0,
													y = point_y,
													w = 1,
													h = 1,
												})
												_btnChildUI["skillLv"].handle.s:setOpacity(0)
												local ch = _btnChildUI["skillLv"] --子父控件
												
												--角色学习技能
												--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
												if not mapInfo.skillLvupToMax then
													--绘制每一个小点点
													local edge = 14 --边长
													local offset_x = 3 --x间距
													if (maxSkillLv == 4) then --数量过多，只能压缩间距
														offset_x = -1 --x间距
													elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
														offset_x = -3 --x间距
													end
													if (g_phone_mode ~= 0) then --非电脑、平板模式
														edge = 16
														offset_x = 3
														if (maxSkillLv == 4) then --数量过多，只能压缩间距
															offset_x = -1 --x间距
														elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
															offset_x = -3 --x间距
														end
													end
													local left_x = -math.floor(maxSkillLv / 2) * (edge + offset_x)
													if ((maxSkillLv % 2) == 0) then --偶数往右移半格
														left_x = left_x + (edge + offset_x) / 2
													end
													
													--skillLvNow) .. "/" .. tostring(maxSkillLv
													--底纹
													for i = 1, maxSkillLv, 1 do
														ch.childUI["point_bg" .. i] = hUI.image:new({
															parent = ch.handle._n,
															model = "UI:skill_point_slot",
															x = left_x + (i - 1) * (edge + offset_x),
															y = 0,
															w = edge,
															h = edge,
														})
													end
													--已获得的技能等级
													for i = 1, skillLvNow, 1 do
														ch.childUI["point" .. i] = hUI.image:new({
															parent = ch.handle._n,
															model = "UI:skill_point",
															x = left_x + (i - 1) * (edge + offset_x),
															y = 0,
															w = edge,
															h = edge,
														})
													end
												end
												--zhenkira: 2015.11.20 不显示等级文字了
												--[[
												if btn.childUI["skillLv"] then
													btn.childUI["skillLv"]:setText(tostring(skillLvNow) .. "/" .. tostring(maxSkillLv))
												end
												]]
											end
											
											--如果已经满级，则设置按钮不可用
											if (skillLvNow >= maxSkillLv) then
												--print("btn:setstate(0)     3")
												btn:setstate(0)
											else
												--计算下一级消耗，如果当前的钱不足则设置为不可用
												local nextCost = customTab.skill[opr].costs[skillLvNow + 1]
												
												--if (type(nextCost) ~= "number") or (mapInfo.gold < nextCost) then
												if (type(nextCost) ~= "number") or (targetP:getresource(hVar.RESOURCE_TYPE.GOLD) < nextCost) then
													--print("btn:setstate(0)     4")
													btn:setstate(0)
												end
											end
											
											--[[
											--刷新技能范围
											hGlobal.event:event("Event_TDUnitActived", w, 1, _oTarget)
											]]
										end
									end
									
									clickIndex = -1
									_closeTip()
									
									--优化：塔如果没有能升级的技能、或者没钱升级技能，那么自动隐藏塔升级操作面板
									local createFlag = false
									local td_upgrade = _oTarget.td_upgrade
									if td_upgrade and (type(td_upgrade) == "table") then
										local upgradeSkill = td_upgrade.upgradeSkill
										if upgradeSkill then
											for skillIdi, skillInfo in pairs(upgradeSkill) do
												--如果没有解锁则不创建按钮
												if skillInfo.isUnlock then
													local maxSkillLv = skillInfo.maxLv or 1
													local skillLv = 0
													local skillObj = _oTarget:getskill(skillIdi)
													if skillObj then
														skillLv = skillObj[2] or 0
													end
													if (skillIdi == skillId) then --geyachao: 因为是发送指令，此刻技能还没升级，改为读缓存的值
														skillLv = skillLvNow
													end
													--print("skillIdi=", skillIdi, "skillLv=", skillLv, "maxSkillLv=", maxSkillLv, "原skillId=", skillId)
													if (skillLv < maxSkillLv) then
														--计算下一级消耗，如果当前的钱不足则设置为不可用
														--local nextCost = customTab.skill[opr].costs[skillLv + 1] or 0
														local nextCost = customTab.skill[skillIdi].costs[skillLv + 1] or 0
														--print("nextCost=", nextCost, "mapInfo.gold - goldCost=", mapInfo.gold - goldCost)
														--if ((mapInfo.gold - goldCost) >= nextCost) then --geyachao: 因为是发送指令，此刻还没有扣钱，改为计算预扣后是否足够钱
														if ((targetP:getresource(hVar.RESOURCE_TYPE.GOLD) - goldCost) >= nextCost) then --geyachao: 因为是发送指令，此刻还没有扣钱，改为计算预扣后是否足够钱
															--btn:setstate(0)
															createFlag = true
															break
														end
													end
												end
											end
										end
									end
									--print("createFlag=", createFlag)
									--塔如果没有能升级的技能、或者没钱升级技能，那么自动隐藏塔升级操作面板
									if (not createFlag) then
										self:settick(250)
										--print(">>>>>>>> self:settick(250) 11")
										
										--取消对之前选中单位的选中
										hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
										hGlobal.event:event("LocalEvent_HitOnTarget", world, nil, 0, 0)
										hGlobal.event:event("Event_TDUnitActived", world, 1, nil)
										hGlobal.O:replace("__WM__TargetOperatePanel", nil)
										hGlobal.O:replace("__WM__MoveOperatePanel", nil)
										
										--触发事件: 操作面板关闭
										hGlobal.event:event("LocalEvent_OperationPanelClosed", "no_skill_to_op")
									end
								end
								
							end
							return
						elseif customTab.cskill[opr] then --直接释放技能
							clickIndex = gx --zhenkira,去掉提示面板， 2015.11.17
							if clickIndex == -1 or clickIndex ~= gx then --第一次点击
								clickIndex = gx
								local skillLv
								if _oTarget then
									local skillObj = _oTarget:getskill(opr)
									if skillObj then
										--角色技能升级
										skillLv= skillObj[2]
									end
								end
								_showTip(1, opr, skillLv)
							elseif clickIndex == gx then --确认点击
								local skillId = opr
								if _oTarget~=nil then
									--建造单位
									--添加新角色
									local mapInfo = w.data.tdMapInfo
									--local goldNow = mapInfo.gold
									local goldNow = 0
									--local targetP = _oTarget:getowner()
									local targetP = w:GetPlayerMe()
									if targetP then
										goldNow = targetP:getresource(hVar.RESOURCE_TYPE.GOLD)
									end
									
									local goldCost = customTab.cskill[opr].cost
									
									--取消对之前选中单位的选中
									hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
									hGlobal.event:event("LocalEvent_HitOnTarget", world, nil, 0, 0)
									hGlobal.event:event("Event_TDUnitActived", world, 1, nil)
									hGlobal.O:replace("__WM__TargetOperatePanel", nil)
									hGlobal.O:replace("__WM__MoveOperatePanel", nil)
									
									if (mapInfo.wave > 0) then
										local skillObj = _oTarget:getskill(skillId)
										if skillObj then
											local lv = skillObj[2]
											local count = skillObj[4]
											local cd = skillObj[5]
											local lasttime = skillObj[6]
											local timenow = hApi.gametime()
											local casttype = customTab.cskill[opr].casttype
											if (goldNow >= goldCost) and ((lasttime > 0 and lasttime + cd <= timenow) or lasttime <= 0) and (lv > 0) then
												--不限次数和有次数限制
												--if ((count < 0) or (count > 0)) and (hVar.InProcessingCastBuildingSkill == 0) then --geyachao: 一次只能使用一个技能
												if ((count < 0) or (count > 0)) then
													--geyachao: 改为发送指令-使用建筑的技能
													--print("改为发送指令-使用建筑的技能")
													--hVar.InProcessingCastBuildingSkill = 1 --是否正在处理使用建筑的技能中
													if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
														hApi.AddCommand(hVar.Operation.CastBuildingSkill, _oTarget:getworldI(), _oTarget:getworldC(), skillId, casttype, goldCost)
													else
														--最后一个参数是兵符消耗的token，只有pvp有，单机默认填-1
														hApi.AddCommand(hVar.Operation.CastBuildingSkill, _oTarget:getworldI(), _oTarget:getworldC(), skillId, casttype, goldCost, -1)
													end
													
													--[[
													mapInfo.gold = mapInfo.gold - goldCost
													hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
													hGlobal.event:event("Event_TowerUpgradeCostRefresh")
													
													--释放技能
													--_oTarget:learnSkill(skillId, skillLvNow)
													local tCastParam = {level = lv,}
													local worldX, worldY = _oTarget.data.defend_x, _oTarget.data.defend_y --以后会使用守备点的坐标
													local gridX, gridY = world:xy2grid(worldX, worldY)
													if (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND) then
														hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
													elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面坐标
														hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
													elseif (casttype == hVar.CAST_TYPE.IMMEDIATE) then --点击直接生效类型
														hApi.CastSkill(_oTarget, skillId, 0, nil, _oTarget, nil, nil, tCastParam)
													elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --geyachao: 新加的施法类型，移动到射程内对地面释放
														--移动到达
														--...
													elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --geyachao: 新加的施法类型，移动到射程内有效点对地面释放
														--移动到达
														--...
													elseif (casttype == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then --geyachao: 新加的施法类型，对周围随机单位施法
														--...
													elseif (casttype == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then --geyachao: 新加的施法类型，移动到射程内对周围随机单位施法
														--...
													end
													
													--重新设置技能属性
													if count > 0 then
														skillObj[4] = skillObj[4] - 1		--次数
													end
													skillObj[6] = hApi.gametime()		--施法时间
													]]
													
													--刷新界面
													if btn.childUI then
														if btn.childUI["cost"] then
															local leftTimes = skillObj[4] - 1
															if (leftTimes > 999) then
																btn.childUI["cost"]:setText("")
															elseif (leftTimes > 0) then
																btn.childUI["cost"]:setText(tostring(leftTimes))
															else
																btn.childUI["cost"]:setText("")
															end
														end
													end
													
													--如果已经满级，则设置按钮不可用
													if (count == 0) or (cd > 0) or (lv <= 0) then
														--print("btn:setstate(0)     5")
														btn:setstate(0)
													end
													
													self:settick(250)
													--print(">>>>>>>> self:settick(250) 10")
													
													--触发事件: 操作面板关闭
													hGlobal.event:event("LocalEvent_OperationPanelClosed", "lv_max")
												end
											end
										end
									else
										local strText = hVar.tab_string["BattleCanUse"]
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
									
									clickIndex = -1
									_closeTip()
								end
							end
							return
						end
					else
						self:settick(250)
						--print(">>>>>>>> self:settick(250) 9")
						
						--触发事件: 操作面板关闭
						hGlobal.event:event("LocalEvent_OperationPanelClosed", "close")
					end
				elseif w.data.type=="town" then
					--town里面的建筑是本地存在的！需要以world绑定的目标建筑为准
					--城里的建筑点击命令后头顶按钮不消失
					if _oUnit==nil then
						_DEBUG_MSG("未选择合法英雄不能发出购买命令")
						return
					end
					local _oBuilding = w:getlordU("building")
					if _oBuilding==nil then
						_DEBUG_MSG("该城镇尚未初始化，无购买数据")
					else
						local uIndex = _oTarget.data.indexOfTown
						if opr==hVar.INTERACTION_TYPE.HIRE then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 8")
							--雇用单位
							return p:order(w,hVar.OPERATE_TYPE.UNIT_HIRE,_oUnit,uIndex,_oBuilding,gridX,gridY)
						elseif opr==hVar.INTERACTION_TYPE.SHOP then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 7")
							--购买物品
							return p:order(w,hVar.OPERATE_TYPE.UNIT_SHOP,_oUnit,uIndex,_oBuilding,gridX,gridY)
						elseif opr==hVar.INTERACTION_TYPE.MARKET then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 6")
							--市场
							return p:order(w,hVar.OPERATE_TYPE.UNIT_MARKET,_oUnit,uIndex,_oBuilding,gridX,gridY)
						elseif opr == hVar.INTERACTION_TYPE.UPGRADE then
							self:settick(250)	--建造后要把自己这个UI删掉，以便刷新
							--print(">>>>>>>> self:settick(250) 5")
							-- 建造建筑物 陶晶 2013-4-12
							hGlobal.event:event("LocalEvent_ShowBuildingUpgrade",opr,w,_oUnit,_oBuilding,_oTarget)
						elseif opr == hVar.INTERACTION_TYPE.TECHNOLOGY then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 4")
							hGlobal.event:event("LocalEvent_TechnologyUpgrade",opr,w,_oUnit,_oBuilding,_oTarget)
						elseif opr == hVar.INTERACTION_TYPE.ACADEMY then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 3")
							hGlobal.event:event("LocalEvent_ShowImperialAcademy",opr,w,_oUnit,_oBuilding,_oTarget)
						elseif opr == hVar.INTERACTION_TYPE.REVIVE then
							self:settick(250)
							--print(">>>>>>>> self:settick(250) 2")
							hGlobal.event:event("LocalEvent_PlayerReviveHero",opr,w,_oUnit,_oBuilding,_oTarget)
						end
					end
				end
			end
		end,
		codeOnButtonCreate = function(self,opr,btn,gx,gy)
			if opr == hVar.INTERACTION_TYPE.DETAIL then
			elseif opr == hVar.INTERACTION_TYPE.TD_SELL_TOWER then
			else
				if w.data.type=="worldmap" then
					if (g_editor == 1) then --geyachao: 编辑器模式，不显示建造的技能按钮
						--print("btn:setstate(0)     6")
						btn:setstate(0)
					else
						local mapInfo = w.data.tdMapInfo
						
						if (mapInfo) then
							local customTab = self.data.customTab
							if customTab and type(customTab) == "table" then
								
								local listenType = 0 --默认建筑
								
								--升级及改造消耗
								local bIsUnlock = false --是否是未解锁的技能或建筑
								local skillLvNow = 0
								--print("codeOnButtonCreate", opr, customTab.build[opr], customTab.skill[opr], customTab.cskill[opr])
								local cost = 0
								local goldNow = 0
								--local targetP = _oTarget:getowner()
								local targetP = w:GetPlayerMe()
								if targetP then
									goldNow = targetP:getresource(hVar.RESOURCE_TYPE.GOLD)
								end
								--print("targetP:",targetP,goldNow)
								if customTab.build[opr] then --建筑
									cost = customTab.build[opr].cost or 0
									--if (mapInfo.gold < cost) then
									if (goldNow < cost) then
										--print("btn:setstate(0)     7")
										btn:setstate(0)
									end
									
									--geyachao: 为了让玩家可以点击，知道需要几个塔能造，这里不加判定
									--[[
									local unlockCondition = customTab.build[opr].unlockCondition
									--print("opr:",opr, unlockCondition)
									if unlockCondition then
										local tacticId = unlockCondition[1]
										local buildNum = unlockCondition[2]
										local buildIdList = unlockCondition[3] or {}
										--取当前造了多少个指定的塔
										local buildNumNow = hApi.GetBuildTowerNum(w, _oTarget:getowner():getpos(), buildIdList)
										
										--print("buildNumNow:",tacticId,buildNum,buildIdList[1],buildNumNow)
										
										if buildNumNow < buildNum then
											btn:setstate(0)
										end
									end
									]]
								elseif customTab.skill[opr] then --技能
									local skillLvMax = customTab.skill[opr].maxSkillLv or 1
									--print("skillLvMax", skillLvMax)
									local skillObj = _oTarget:getskill(opr)
									if skillObj then
										skillLvNow = skillObj[2]
									end
									if (skillLvMax == 0) then
										cost = "-"
										--print("btn:setstate(0)     8")
										btn:setstate(0)
									elseif skillLvNow < skillLvMax then
										--角色学习技能
										--if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										if mapInfo.skillLvupToMax then
											for i = 1, skillLvMax do
												cost = cost + customTab.skill[opr].costs[i] or 0
											end
										else
											cost = customTab.skill[opr].costs[skillLvNow + 1] or 0
										end
										
										--if mapInfo.gold < cost then
										if goldNow < cost then
											--print("btn:setstate(0)     9")
											btn:setstate(0)
										end
									else
										cost = "N/A"
										--print("btn:setstate(0)     10")
										btn:setstate(0)
									end
									listenType = 1 --技能
								elseif customTab.cskill[opr] then --直接释放的技能
									
									local skillObj = _oTarget:getskill(opr)
									--local timeNow = hApi.gametime()
									local timeNow = w:gametime()
									local lasttime = 0
									local cd = 0
									cost = customTab.cskill[opr].cost or 0
									--if (mapInfo.gold < cost) then
									if (goldNow < cost) then
										--print("btn:setstate(0)     11")
										btn:setstate(0)
									else
										local count = -1
										if skillObj then
											lasttime = skillObj[6]	--上一次释放时间
											count = skillObj[4]	--剩余释放次数
											cd = skillObj[5]
										end
										
										if count == 0 or (lasttime > 0 and lasttime + cd > timeNow) then
											--print("btn:setstate(0)     12")
											btn:setstate(0)
										else
											--print("btn:setstate(1)     13")
											btn:setstate(1)
										end
									end
									
									listenType = 2 --直接释放的技能
								else --无效的技能或者建筑
									cost = "-"
									bIsUnlock = true --未解锁的技能或建筑
								end
								
								local h = btn.handle
								local d = btn.data
								
								local _btnChildUI = btn.childUI
								if _btnChildUI["costBg"]~=nil then
									_btnChildUI["costBg"]:del()
									_btnChildUI["costBg"] = nil
								end
								
								if (cost > 0) then
									_btnChildUI["costBg"]  = hUI.image:new({
										parent = h._n,
										model = "UI:td_cost_bg",
										x = 0,
										y = -30,
										w = 46,
										h = 14,
									})
								else
									--不消耗金币，不需要创建
								end
								
								if _btnChildUI["cost"]~=nil then
									_btnChildUI["cost"]:del()
									_btnChildUI["cost"] = nil
								end
								
								local tLabel
								local sFont = "num"
								
								if (cost > 0) then
									if (cost > 999) then
										tLabel = {text = "",font = sFont, size = 10, border = 1, RGB = {255,255,0},}
									else
										tLabel = {text = tostring(tostring(cost)),font = sFont, size = 10, border = 1, RGB = {255,255,0},}
									end
								else
									tLabel = {text = "",font = sFont, size = 10, border = 1, RGB = {255,255,0},}
								end
								tLabel.parent = h._n
								local tx,ty = btn:getTLXY()
								--tLabel.x = (tLabel.x or 0) + hApi.getint((d.w + d.labelX)/2) + tx - d.x
								--tLabel.y = (tLabel.y or 0) - hApi.getint(d.h/2) + ty - d.y
								tLabel.x = 0
								tLabel.y = -30
								tLabel.align = tLabel.align or "MC"
								_btnChildUI["cost"] = hUI.label:new(tLabel)
								
								---------------------------------------------------------------------------------
								
								--geyachao: 不能升级的技能或建筑也显示出来，显示未解锁的图标
								--未解锁的技能标识
								if _btnChildUI["unlock"] ~= nil then
									_btnChildUI["unlock"]:del()
									_btnChildUI["unlock"] = nil
								end
								if bIsUnlock then
									_btnChildUI["unlock"] = hUI.image:new({
										parent = h._n,
										model = "UI:LOCK",
										x = 13,
										y = -10,
										w = 24,
										h = 24,
									})
								end
								
								if listenType == 2 then
									if _btnChildUI["cd"] ~= nil then
										_btnChildUI["cd"]:del()
										_btnChildUI["cd"] = nil
									end
									_btnChildUI["cd"] = hUI.label:new({
										parent = h._n,
										size = 26,
										align = "MC",
										font = "numWhite",
										x = 0,
										y = 0,
										text = "",
									})
									
									--技能可使用的次数背景图
									if _btnChildUI["count_BG"] ~= nil then
										_btnChildUI["count_BG"]:del()
										_btnChildUI["count_BG"] = nil
									end
									_btnChildUI["count_BG"] = hUI.image:new({
										parent = h._n,
										model = "UI:td_sui_tactic_num_bg",
										align = "MC",
										x = 16,
										y = 16,
										w = 28,
										h = 28,
									})
									_btnChildUI["count_BG"].handle.s:setOpacity(0) --战车不显示背景图了
									
									--技能可使用的次数
									if _btnChildUI["count"] ~= nil then
										_btnChildUI["count"]:del()
										_btnChildUI["count"] = nil
									end
									_btnChildUI["count"] = hUI.label:new({
										parent = h._n,
										size = 20,
										align = "MC",
										font = "numWhite",
										x = 16,
										y = 16,
										text = "",
									})
									
									local lv = 0
									local cd = 0
									local count = 0
									local lasttime = 0
									
									local skillObj = _oTarget:getskill(opr)
									if skillObj then
										lv = skillObj[2]
										cd = skillObj[5]
										count = skillObj[4]
										lasttime = skillObj[6]
									end
									
									--技能可使用的次数背景图
									if btn.childUI["count_BG"] then
										if (count < 0) then --负数表示无限次使用
											btn.childUI["count_BG"]:del()
											btn.childUI["count_BG"] = nil
										elseif (count == 1) then --1次也不显示
											btn.childUI["count_BG"]:del()
											btn.childUI["count_BG"] = nil
										else
											--
										end
									end
									
									--技能可使用的次数
									if btn.childUI["count"] then
										if (count < 0) then --负数表示无限次使用
											btn.childUI["count"]:setText(tostring(""))
										elseif (count == 1) then --1次也不显示
											btn.childUI["count"]:setText(tostring(""))
										else
											local scale = 0.8
											if (count >= 10) then
												scale = 0.5
											end
											btn.childUI["count"].handle._n:setScale(scale)
											btn.childUI["count"]:setText(tostring(count))
											
											--使用次数超过999次就不显示数字了
											if (count > 999) then
												btn.childUI["count"]:setText(tostring(""))
											end
										end
									end
									
									--local timeNow = hApi.gametime()
									local timeNow = w:gametime()
									if lv > 0 and count > 0 and ((lasttime > 0 and lasttime + cd <= timeNow) or lasttime <= 0) then
										if btn.childUI["cd"] then
											btn.childUI["cd"]:setText("")
										end
									else
										if btn.childUI["cd"] and lasttime > 0 then
											local cd = math.max(math.floor((lasttime + cd - timeNow) / 1000), 0)
											if cd > 0 then
												btn.childUI["cd"]:setText(tostring(cd))
											else
												btn.childUI["cd"]:setText("")
											end
										end
									end
								end
								
								local __addlistener = function()
									local listenerName = tostring(_oTarget.__ID).."_".. tostring(opr).."_".. tostring(listenType)
									
									self:addlisten("LocalEvent_TD_GOLD_CHANGE", listenerName, function()
										
										local cost = 0
										local gNow = 0
										--local tP = _oTarget:getowner()
										local tP = w:GetPlayerMe()
										if tP then
											gNow = tP:getresource(hVar.RESOURCE_TYPE.GOLD)
										end
										--todo:判断是否设置成可点击状态
										if customTab.build[opr] then --建筑
											
											cost = customTab.build[opr].cost or 0
											--if  (mapInfo.gold >= cost) then
											if  (gNow >= cost) then
												--print("btn:setstate(1)     14")
												btn:setstate(1)
											else
												--print("btn:setstate(1)     15")
												btn:setstate(0)
											end
											
											--geyachao: 为了让玩家可以点击，知道需要几个塔能造，这里不加判定
											--[[
											local unlockCondition = customTab.build[opr].unlockCondition
											--print("opr:",opr, unlockCondition)
											if unlockCondition then
												local tacticId = unlockCondition[1]
												local buildNum = unlockCondition[2]
												local buildIdList = unlockCondition[3] or {}
												--取当前造了多少个指定的塔
												local buildNumNow = hApi.GetBuildTowerNum(w, _oTarget:getowner():getpos(), buildIdList)
												
												--print("buildNumNow:",tacticId,buildNum,buildIdList[1],buildNumNow)
												
												if buildNumNow < buildNum then
													btn:setstate(0)
												end
											end
											]]
										elseif customTab.skill[opr] then --技能
											local skillLvNow = 0
											local skillLvMax = customTab.skill[opr].maxSkillLv or 1
											
											local skillObj = _oTarget:getskill(opr)
											if skillObj then
												skillLvNow = skillObj[2]
											end
											
											if (skillLvNow < skillLvMax) then
												--角色学习技能
												--if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
												if mapInfo.skillLvupToMax then
													for i = 1, skillLvMax do
														cost = cost + customTab.skill[opr].costs[i] or 0
													end
												else
													cost = customTab.skill[opr].costs[skillLvNow + 1] or 0
												end
												--if  (mapInfo.gold >= cost) then
												if  (gNow >= cost) then
													--print("btn:setstate(1)     16")
													btn:setstate(1)
												else
													--print("btn:setstate(1)     17")
													btn:setstate(0)
												end
											end
										end
									end)
								end
								
								local __addlistener1 = function()
									local listenerName = tostring(_oTarget.__ID).."_".. tostring(opr).."_".. tostring(listenType)
									
									self:addlisten("LocalEvent_TD_CHECK_TOWER_CAST_SKILL", listenerName, function()
										local cost = 0
										local gNow = 0
										--local tP = _oTarget:getowner()
										local tP = w:GetPlayerMe()
										if tP then
											gNow = tP:getresource(hVar.RESOURCE_TYPE.GOLD)
										end
										--todo:判断是否设置成可点击状态
										if customTab.cskill[opr] then --技能
											cost = customTab.cskill[opr].cost or 0
											
											local lv = 0
											local cd = 0
											local count = 0
											local lasttime = 0
											
											local skillObj = _oTarget:getskill(opr)
											if skillObj then
												lv = skillObj[2]
												cd = skillObj[5]
												count = skillObj[4]
												lasttime = skillObj[6]
											end
											
											
											--local timeNow = hApi.gametime()
											local timeNow = w:gametime()
											
											--技能可使用的次数背景图
											if btn.childUI["count_BG"] then
												if (count < 0) then --负数表示无限次使用
													btn.childUI["count_BG"]:del()
													btn.childUI["count_BG"] = nil
												elseif (count == 1) then --1次也不显示
													btn.childUI["count_BG"]:del()
													btn.childUI["count_BG"] = nil
												else
													--
												end
											end
											
											--技能可使用的次数
											if btn.childUI["count"] then
												if (count < 0) then --负数表示无限次使用
													btn.childUI["count"]:setText(tostring(""))
												elseif (count == 1) then --1次也不显示
													btn.childUI["count"]:setText(tostring(""))
												else
													local scale = 0.8
													if (count >= 10) then
														scale = 0.5
													end
													btn.childUI["count"].handle._n:setScale(scale)
													btn.childUI["count"]:setText(tostring(count))
													
													--使用次数超过999次就不显示数字了
													if (count > 999) then
														btn.childUI["count"]:setText(tostring(""))
													end
												end
											end
											
											if lv > 0 and ((lasttime > 0 and lasttime + cd <= timeNow) or lasttime <= 0) then
												--if (mapInfo.gold < cost) or count == 0 
												if (gNow < cost) or count == 0 then
													--print("btn:setstate(0)     18")
													btn:setstate(0)
												else
													--print("btn:setstate(1)     19")
													btn:setstate(1)
												end
												if btn.childUI["cd"] then
													btn.childUI["cd"]:setText("")
												end
											else
												--print("btn:setstate(0)     20")
												btn:setstate(0)
												if btn.childUI["cd"] and lasttime > 0 then
													local cd = math.max(math.floor((lasttime + cd - timeNow) / 1000), 0)
													if cd > 0 then
														btn.childUI["cd"]:setText(tostring(cd))
													else
														btn.childUI["cd"]:setText("")
													end
												end
											end
										end
									end)
								end
								
								--升级的技能等级
								if customTab.build[opr] then
									__addlistener()
								elseif customTab.skill[opr] then --技能
									local maxSkillLv = customTab.skill[opr].maxSkillLv or 1
									
									--此处是点击塔，弹出显示技能界面的地方
									local _btnChildUI = btn.childUI
									if (_btnChildUI["skillLv"] ~= nil) then
										_btnChildUI["skillLv"]:del()
										_btnChildUI["skillLv"] = nil
									end
									
									--角色学习技能
									--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
									if not mapInfo.skillLvupToMax then
										--geyachao: 显示技能等级的小点点
										local point_y = 34
										if (g_phone_mode ~= 0) then --非电脑、平板模式
											point_y = 42
										end
										_btnChildUI["skillLv"] = hUI.button:new({
											parent = h._n,
											model = "UI:skill_point",
											x = 0,
											y = point_y,
											w = 1,
											h = 1,
										})
										_btnChildUI["skillLv"].handle.s:setOpacity(0)
										local ch = _btnChildUI["skillLv"] --子父控件
										
										--绘制每一个小点点
										local edge = 14 --边长
										local offset_x = 3 --x间距
										if (maxSkillLv == 4) then --数量过多，只能压缩间距
											offset_x = -1 --x间距
										elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
											offset_x = -3 --x间距
										end
										if (g_phone_mode ~= 0) then --非电脑、平板模式
											edge = 16
											offset_x = 3
											if (maxSkillLv == 4) then --数量过多，只能压缩间距
												offset_x = -1 --x间距
											elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
												offset_x = -3 --x间距
											end
										end
										local left_x = -math.floor(maxSkillLv / 2) * (edge + offset_x)
										if ((maxSkillLv % 2) == 0) then --偶数往右移半格
											left_x = left_x + (edge + offset_x) / 2
										end
										--print("offset_x", offset_x, maxSkillLv)
										--skillLvNow) .. "/" .. tostring(maxSkillLv
										--底纹
										for i = 1, maxSkillLv, 1 do
											ch.childUI["point_bg" .. i] = hUI.image:new({
												parent = ch.handle._n,
												model = "UI:skill_point_slot",
												x = left_x + (i - 1) * (edge + offset_x),
												y = 0,
												w = edge,
												h = edge,
											})
										end
										--已获得的技能等级
										for i = 1, skillLvNow, 1 do
											ch.childUI["point" .. i] = hUI.image:new({
												parent = ch.handle._n,
												model = "UI:skill_point",
												x = left_x + (i - 1) * (edge + offset_x),
												y = 0,
												w = edge,
												h = edge,
											})
										end
									end
									
									--zhenkira: 2015.11.20 不显示等级文字了
									--[[
									local tLabel
									tLabel = {text = tostring(tostring(skillLvNow) .. "/" .. tostring(maxSkillLv)),font = d.font, size = 16, border = 1, RGB = {255,255,255},}
									tLabel.parent = h._n
									local tx,ty = btn:getTLXY()
									tLabel.x = (tLabel.x or 0) + hApi.getint((d.w + d.labelX)/2) + tx - d.x
									tLabel.y = (tLabel.y or 0) - hApi.getint(d.h/2) + ty - d.y
									tLabel.align = tLabel.align or "RB"
									_btnChildUI["skillLv"] = hUI.label:new(tLabel)
									_btnChildUI["skillLv"].handle.s:setVisible(false)
									]]
									__addlistener()
									
								elseif customTab.cskill[opr] then
									__addlistener1()
								end
								
							end
						end
					end
				end
			end
		end,
	})
end

_gtp.select = function(self,i,lifeTime)
	self.childUI["actions"]:select(i)
	if lifeTime and lifeTime>0 and self.data.lastSelection~=hVar.INTERACTION_TYPE.DETAIL then
		self:settick(lifeTime)
	end
end

--=============================================
-- 可拖拽的grid
--=============================================
local __DefaultParam = {
	--继承自grid的属性
	parent = 0,--hUI.__static.uiLayer,
	userdata = 0,
	-------------------------
	x = 0,
	y = 0,
	-------------------------
	mode = "image",	--["image"]
	tab = 0,
	tabModelKey = "icon",
	animation = 0,			--[string][{"normal","selected","disable"}][function(id,model,gridX,gridY)]
	grid = {},			--[{1,2,3,4}][{{1,2,3,4},{5,6,7,8}}]
	gridPos = 0,			--如果此值不为0，那么此grid将可能使用非方格特殊位置作为自己的坐标，必须是二维表
	offsetX = {},			--格式为{x0,x1,x2}
	align = 0,
	count = 0,
	scaleT = 0.8,
	centerX = 0,
	centerY = 0,
	iconW = -1,
	iconH = -1,
	gridW = 34,
	gridH = 34,
	smartWH = 0,
	buttonNum = 0,			--将在创建grid后记录数量
	spreadFrom = 0,			--如果定义了此值，则按钮创建时将从指定的位置展开
	dragbox = 0,
	code = 0,			--按钮按下时会调用此值,function(id,btn,d.userdata,gx,gy)
	codeOnTouch = 0,		--仅["imageButton"]模式有效
	codeOnButtonCreate = 0,		--function(self,id,btn,gx,gy)按钮创建时会被调用此值
	codeOnImageCreate = 0,		--function(self,id,sprite,gx,gy)图像创建时会被调用此值
	codeOnAutoRelease = 0,		--function(self,IsForceToRelease)内存警告时可能被调用self:updateitem({})方法，如果此值~=0那么走到清理流程，如果此值为function那么会先调用函数随后清理
	-------------------------
	slot = {model = "UI_frm:slot",animation = "lightSlim",x = 0,y = 0,w=nil,h=nil},
	iconBGKey = 0,			--如果此项为字符串，那么在updateItem的同时，若发现物品已消失或被替换，则会尝试删除名为key..gridX.."|"..gridY的子ui
	num = {font = "numWhite",size = -1,align = "RB",x=0,y=0,},
	numX = 0,
	numY = 0,
	--itemName = 0,
	--item = {},			--[{id,num}]
	uiExtra = 0,			--{tag1,tag2,...}	在删除道具UI时将一并将tag..gx.."|"..gy的标签删除
	animationSelect = 0,
	codeOnItemSelect = 0,		--function(self,item,relX,relY,gridX,gridY)被选择时将触发此函数，如果此函数返回任意UI，则此UI将被黏在鼠标上，并且会在丢弃时收到codeOnItemDrop函数
	codeOnItemDrop = 0,		--function(self,item,relX,relY,screenX,screenY)鼠标上粘着了任意UI时，touchUP将抛出此函数
	codeOnUpdate = 0,		--function(self,tItemList,nIndex,sLabelName)
	pickX = 0,			--选中某个item时候，创建PickItemSprite的偏移(仅codeOnItemSelect==0或无返回值时有效)
	pickY = 0,
}

hUI.bagGrid = eClass:new("static",hUI.grid)	--继承自grid,拥有grid所有的方法(单纯将函数复制过来使用)
local _ubgr = hUI.bagGrid
local __init = _ubgr.init
_ubgr.destroy = function(self)
	local d = self.data
	--内存清理:移除不需要的函数
	d.code = 0
	d.codeOnTouch = 0
	d.codeOnButtonCreate = 0
	d.codeOnImageCreate = 0
	d.codeOnItemSelect = 0
	d.codeOnItemDrop = 0
	d.codeOnUpdate = 0
	d.codeOnAutoRelease = 0
	--内存清理:移除不需要的表格
	d.slot = 0
	return hUI.destroyDefault(self)
end
local __ENUM__CreateSlot = function(id,gx,gy,_,self,param)
	self.handle["slot"..gx.."|"..gy] = self:addimage(self.data.slot.model,gx,gy,param)
end
local __ENUM__CreateIndex = function(id,gx,gy,_,self)
	local d = self.data
	d.count = d.count + 1
	local vx,vy = self:grid2xy(gx,gy)
	d.gIndex[d.count] = {gx,gy,d.count,vx,vy}
	d.gIndex[gx.."|"..gy] = d.count
	d.item[d.count] = 0
end
_ubgr.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable("H",self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI

	d.mode = "image"		--不支持其他类型
	d.item = {}
	d.gIndex = {}

	--创建node
	h._n = CCNode:create()
	h._n:setPosition(d.x,d.y)
	d.parent:addChild(h._n)

	if #d.grid==0 and type(p.item)=="table" then
		d.grid = {}
		for i = 1,#p.item do
			d.grid[i] = 0
		end
	end
	d.buttonNum = 0
	d.count = 0
	hApi.EnumTable2V(d.grid,__ENUM__CreateIndex,self)
	if d.count>0 then
		d.count = 0
		--创建背景槽子
		if d.slot~=0 then
			local tempAnimation = d.animation
			local tempTab = d.tab
			d.mode = "batchImage"
			d.tab = 0
			d.animation = d.slot.animation
			local slotModel = d.slot.model
			hApi.SpriteInitBatchNode(h,slotModel)
			h._n:addChild(h._bn)
			p.align = "MC"
			local slotW,slotH = d.iconW,d.iconH
			local slotX = d.slot.x or 0
			local slotY = d.slot.y or 0
			local smartWH = d.smartWH
			if d.slot.w and d.slot.h then
				slotW,slotH = d.slot.w,d.slot.h
				smartWH = 0
			end
			local param = {unrecord=1,size = {slotW,slotH,slotX,slotY},smartWH=smartWH}
			--添加slot
			hApi.EnumTable2V(d.grid,__ENUM__CreateSlot,self,param)
			d.mode = "image"
			d.tab = tempTab
			d.animation = tempAnimation
		end
		if d.num~=0 then
			d.num.size = d.num.size or -1
			d.numX = math.floor(d.iconW/2)-2+(d.num.x or 0)
			d.numY = -1*math.floor(d.iconH/2)+(d.num.y or 0)
		end
		if d.codeOnAutoRelease~=0 then
			h.__IsTemp = hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE
			hUI.SYSAutoReleaseUI.Grid[self.ID] = self.__ID
		end
		if type(p.item)=="table" then
			self:updateitem(p.item)
		end
	end
end

_ubgr.getmodel = function(self,id)
	local d = self.data
	if d.tab~=0 then
		if id and d.tab[id] then
			return d.tab[id][d.tabModelKey] or 0
		else
			return 1
		end
	else
		return id
	end
end

_ubgr.grid2xy = function(self,gx,gy,mode)
	local d = self.data
	if d.gridPos~=0 then
		if d.gridPos[gy+1]~=nil and type(d.gridPos[gy+1][gx+1])=="table" then
			return unpack(d.gridPos[gy+1][gx+1])
		end
	end
	local offsetX = d.offsetX[gy+1] or 0
	local nx,ny = offsetX+gx*d.gridW,-1*gy*d.gridH
	return nx,ny
end

local __TempGridEx = {}
_ubgr.xy2grid = function(self,x,y,mode)
	local d = self.data
	local h = self.handle
	if mode==nil then
		x,y = x,hVar.SCREEN.h-y
	elseif mode==1 then
		--不作处理
	else--if mode=="frm" or mode=="parent" then
		x,y = x-d.x,y-d.y
	end
	if d.grid~=0 then
		local tempG = __TempGridEx
		local sus
		local gx,gy
		--特殊位置转换
		if d.gridPos~=0 then
			tempG = {}
			local px,py = math.floor(d.gridW/2),math.floor(d.gridH/2)
			for _gy,v in pairs(d.gridPos)do
				for _gx,pos in pairs(v)do
					tempG[(_gx-1).."|"..(_gy-1)] = 1
					local ox,oy = unpack(pos)
					if x>=ox-px and x<=ox+px and y<=oy+py and y>=oy-py then
						gx = _gx-1
						gy = _gy-1
						break
					end
				end
				if gx~=nil then
					break
				end
			end
		end
		if gx==nil then
			x = x+math.floor(d.gridW/2)
			y = -1*y+math.floor(d.gridH/2)
			gy = math.floor(y/d.gridH)
			local offsetX = d.offsetX[gy+1] or 0
			gx = math.floor((x-offsetX)/d.gridW)
			if d.gridPos~=0 and tempG[gx.."|"..gy]~=nil then
				return
			end
		end
		if type(d.grid[1])=="table" then
			if d.grid[gy+1]~=nil and d.grid[gy+1][gx+1]~=nil then
				return gx,gy,d.item[(d.gIndex[gx.."|"..gy] or 0)],h["s_x"..gx.."y"..gy]
			end
		elseif gy==0 and d.grid[gx+1]~=nil then
			return gx,gy,d.item[(d.gIndex[gx.."|"..gy] or 0)],h["s_x"..gx.."y"..gy]
		end
	end
end

_ubgr.shift = function(self,x,y,tx,ty)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	if d.mode=="image" and not(x==tx and y==ty) and self:IsSafeGrid(x,y) and self:IsSafeGrid(tx,ty) then
		local g = d.grid
		local spr,tspr = "s_x"..x.."y"..y,"s_x"..tx.."y"..ty
		local num,tnum = "num"..x.."|"..y,"num"..tx.."|"..ty
		local i,ti = d.gIndex[x.."|"..y],d.gIndex[tx.."|"..ty]
		h[spr],h[tspr] = h[tspr],h[spr]
		_childUI[num],_childUI[tnum] = _childUI[tnum],_childUI[num]
		d.item[i],d.item[ti] = d.item[ti],d.item[i]
		if d.item[i]~=0 then
			d.item[i][3] = i
		end
		if d.item[ti]~=0 then
			d.item[ti][3] = ti
		end
		if h[spr]~=nil then
			local posX,posY = self:grid2xy(x,y,"ex")
			h[spr]:setPosition(posX,posY)
			if _childUI[num] then
				_childUI[num].handle.s:setPosition(posX+d.numX,posY+d.numY)
			end
		end
		if h[tspr]~=nil then
			local posX,posY = self:grid2xy(tx,ty,"ex")
			h[tspr]:setPosition(posX,posY)
			if _childUI[tnum] then
				_childUI[tnum].handle.s:setPosition(posX+d.numX,posY+d.numY)
			end
		end
		return hVar.RESULT_SUCESS
	end
	return hVar.RESULT_FAIL
end

local __SpriteFadeIn = function(s,time)
	if s then
		--s:setOpacity(0)
		s:runAction(CCFadeIn:create(time))
	end
end

_ubgr.fadein = function(self,time,fromX,fromY)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	time = time or 0.25
	fromX = fromX or 0
	fromY = fromY or 0
	for i = 1,#d.gIndex do
		local v = d.gIndex[i]
		local gx,gy = v[1],v[2]
		__SpriteFadeIn(h["s_x"..gx.."y"..gy],time)
		if d.slot~=0 then
			__SpriteFadeIn(h["slot"..gx.."|"..gy],time)
		end
		if _childUI["num"..gx.."|"..gy]~=nil then
			__SpriteFadeIn(_childUI["num"..gx.."|"..gy].handle.s,time)
		end
	end
	h._n:setPosition(d.x+fromX,d.y+fromY)
	h._n:runAction(CCMoveTo:create(time,ccp(d.x,d.y)))
end

_ubgr.removeitem = function(self,id,count,index)
	local gIndex = self.data.gIndex
	if type(gIndex[index])=="table" then
		local gx,gy = unpack(gIndex[index])
		local s = self:getimage(gx,gy,1)
		if s then
			s:getParent():removeChild(s,true)
		end
	end
end

local function _SetChildSpriteColor(_iSprite)
	if _iSprite then
		_iSprite:setColor(ccc3(150,150,150))
		--遍历精灵的所有子，并作同样的内容
		local childArr = _iSprite:getChildren()
		if childArr then
			local n = childArr:count()
			for i = 0,n do
				local o = childArr:objectAtIndex(i)
				if o then
					o:setColor(ccc3(150,150,150))
				end
			end
		end
	end
end

_ubgr.selectitem = function(self,relX,relY,screenX,screenY)
	local d = self.data
	local h = self.handle
	local childUI = self.childUI
	local gridX,gridY,item,_iSprite = self:xy2grid(relX,relY,"parent")
	local LastNumUI
	local dSprite,dUI
	local NotCreateDragItem = 0
	local NotDeleteOnDrop = 0
	local IsDefaultPSprite = 1	--是否默认的pSprite
	if item and item~=0 then
		--改变所有绑定在精灵上的子精灵的颜色
		--_SetChildSpriteColor(_iSprite)
		LastNumUI = childUI["num"..gridX.."|"..gridY]
		if LastNumUI then
			LastNumUI.handle.s:setColor(ccc3(150,150,150))
		end
		if type(d.codeOnItemSelect)=="function" then
			local cur_time = os.time()
			local vRetObject,_NotDeleteOnDrop = d.codeOnItemSelect(self,item,relX,relY,gridX,gridY,cur_time)
			local typ = type(vRetObject)
			if typ=="userdata" then
				--返回了一个sprite
				dSprite = vRetObject
				if _NotDeleteOnDrop==1 then
					NotDeleteOnDrop = 1
				end
				IsDefaultPSprite = 0
			elseif typ=="table" and vRetObject.ID and vRetObject.ID~=0 then
				--返回了一个UI
				--注意这个UI的父节点必须是hUI.__static.uiLayer
				dUI = vRetObject
				if dUI.data.parent~=hUI.__static.uiLayer then
					_DEBUG_MSG("[LUA WARNING] 可拖拽item控件的父节点必须是 hUI.__static.uiLayer")
				end
				if _NotDeleteOnDrop==1 then
					NotDeleteOnDrop = 1
				end
				IsDefaultPSprite = 0
			elseif vRetObject==-1 then
				--返回-1就不创建拖拽的物件
				NotCreateDragItem = 1
				IsDefaultPSprite = 0
			end
		end

		if NotCreateDragItem~=1 and dSprite==nil then
			dSprite = self:addimage(item[1],gridX,gridY,{unrecord=1,animation = d.animationSelect})
			if dSprite then
				h._n:removeChild(dSprite,false)
			else
				dSprite = CCSprite:create()
			end
		end

		if type(screenX)~="number" or type(screenY)~="number" then
			screenX = nil
			screenY = nil
		end

		if dSprite and screenX and screenY then
			if IsDefaultPSprite==1 and (d.pickX~=0 or d.pickY~=0) then
				--仅默认sprite会走到这里
				local offNode = CCNode:create()
				offNode:addChild(dSprite)
				offNode:setPosition(screenX,screenY)
				dSprite:setPosition(d.pickX,d.pickY)
				dSprite = offNode
			else
				dSprite:setPosition(screenX,screenY)
			end
		end

		childUI["dragedItem"] = hUI.dragBox:new({
			node = dSprite,
			top = 1,
			x = screenX,
			y = screenY,
			autorelease = 1,
			codeOnDrop = function(relX,relY,screenX,screenY)
				self.childUI["dragedItem"] = nil
				local iSprite = self:getimage(gridX,gridY)
				if iSprite and iSprite==_iSprite then
					iSprite:setColor(ccc3(255,255,255))
				end
				local CurNumUI = childUI["num"..gridX.."|"..gridY]
				if CurNumUI and CurNumUI==LastNumUI then
					CurNumUI.handle.s:setColor(ccc3(255,255,255))
				end
				if NotDeleteOnDrop~=1 then
					if dUI then
						dUI:del()
					elseif dSprite then
						dSprite:getParent():removeChild(dSprite,true)
					end
				end
				if type(d.codeOnItemDrop)=="function" then
					local cur_time = os.time()
					return d.codeOnItemDrop(self,item,relX,relY,screenX,screenY,_iSprite,cur_time)
				end
			end,
		}):select()

		return item,dSprite,gridX,gridY,d.gIndex[gridX.."|"..gridY]
	end
end

local __CODE__GetBagItemNumFont = function(self)
	local d = self.data
	if d.num~=0 then
		local nFontSize = d.num.size
		if nFontSize<=0 then
			nFontSize = math.floor(d.iconW/5)
		end
		return d.num.font,nFontSize,d.num.align,d.num.border
	end
end

local __ENUM__UpdateBagItem = function(_,gx,gy,_,self,tItem)
	local d = self.data
	d.count = d.count + 1
	local _childUI = self.childUI
	local count = d.count
	local sItemName = "num"..gx.."|"..gy
	if tItem and type(tItem[count])=="table" then										--如果军队中没有兵则不进行以下操作
		local oItem = tItem[count]
		local oItemC = d.item[count]
		if oItemC~=0 then
			local _,x,y

			--调换位置(oItemC[1]:本框之前存放的兵种，oItemC[1]:本框现在要移进来的兵种)
			if oItemC[hVar.ITEM_DATA_INDEX.ID]~=oItem[hVar.ITEM_DATA_INDEX.ID] then										--oItemC[1]:兵种ID
				self:removeimage(gx,gy)
				oItemC[hVar.ITEM_DATA_INDEX.ID] = oItem[hVar.ITEM_DATA_INDEX.ID]
				_,x,y = self:addimage(oItemC[hVar.ITEM_DATA_INDEX.ID],gx,gy)
			end

			--调换位置或分兵以后，对应的框中的数量会改变
			if d.num~=0 and oItemC[hVar.ITEM_DATA_INDEX.NUM]~=oItem[hVar.ITEM_DATA_INDEX.NUM] then--and type(oItemC[2]) == "number" and type(oItem[2]) == "number" then
				oItemC[hVar.ITEM_DATA_INDEX.NUM] = oItem[hVar.ITEM_DATA_INDEX.NUM]										--oItemC[2]:	某个兵种的人数
				if oItem[hVar.ITEM_DATA_INDEX.NUM]=="" and _childUI[sItemName]==nil then
					--什么都不做
				elseif _childUI[sItemName] then
					_childUI[sItemName]:setText(tostring(oItemC[hVar.ITEM_DATA_INDEX.NUM]))
				elseif x and y then
					local font,fontSize,fontAlign,fontBorder = __CODE__GetBagItemNumFont(self)
					_childUI[sItemName] = hUI.label:new({
						parent = self.handle._n,
						font = font,
						size = fontSize,
						text = tostring(oItemC[hVar.ITEM_DATA_INDEX.NUM]),
						align = fontAlign,
						border = fontBorder,
						x = x+d.numX,
						y = y+d.numY,
						z = 1,
					})
				end
			end

			if d.codeOnUpdate ~= 0 and type(d.codeOnUpdate) == "function" then

				--changed by pangyong 2015/4/7 
				--d.codeOnUpdate(self,tItem,count,sItemName)
				d.codeOnUpdate(self,tItem,count,sItemName,gx, gy)
			end
		else
			d.item[count] = {oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.NUM],count}
			oItemC = d.item[count]
			local _,x,y = self:addimage(oItemC[hVar.ITEM_DATA_INDEX.ID],gx,gy)
			if d.num~=0 then
				local font,fontSize,fontAlign,fontBorder = __CODE__GetBagItemNumFont(self)
				hApi.safeRemoveT(_childUI,sItemName)
				if d.num.depletion == 1 then
					--当物品是 消耗类道具时 创建个数lab 
					local itemType = hApi.GetItemTypeByID(oItemC[hVar.ITEM_DATA_INDEX.ID])
					if itemType == hVar.ITEM_TYPE.DEPLETION then
						_childUI[sItemName] = hUI.label:new({
							parent = self.handle._n,
							font = font,
							size = fontSize,
							text = tostring(oItemC[hVar.ITEM_DATA_INDEX.NUM]),
							align = fontAlign,
							border = fontBorder,
							x = x+d.numX,
							y = y+d.numY,
							z = 1,
						})
					end
				--以前的流程 只要有num 就创建 lab 
				else
					_childUI[sItemName] = hUI.label:new({
						parent = self.handle._n,
						font = font,
						size = fontSize,
						text = tostring(oItemC[hVar.ITEM_DATA_INDEX.NUM]),
						align = fontAlign,
						border = fontBorder,
						x = x+d.numX,
						y = y+d.numY,
						z = 1,
					})
				end
			end
			if d.codeOnUpdate ~= 0 and type(d.codeOnUpdate) == "function" then
				--changed by pangyong 2015/4/7
				d.codeOnUpdate(self,tItem,count,sItemName, gx, gy)
			end
		end
	else																--当框内无兵时（清空之前创造的内容）
		d.item[count] = 0
		self:removeimage(gx,gy)
		hApi.safeRemoveT(_childUI,sItemName)
		if d.uiExtra~=0 then
			for i = 1,#d.uiExtra do
				hApi.safeRemoveT(_childUI,d.uiExtra[i]..gx.."|"..gy)
			end
		end
	end
end

_ubgr.updateitem = function(self,tItem)
	--print("updateitem", tItem)
	--for k, v in pairs(tItem) do
	--	print(k, v)
	--end
	local d = self.data
	local _childUI = self.childUI
	hApi.safeRemoveT(_childUI,"dragedItem")
	if d.grid~=0 then
		if type(tItem)~="table" then
			tItem = nil
		end
		d.count = 0
		hApi.EnumTable2V(d.grid,__ENUM__UpdateBagItem,self,tItem)
	end
end

_ubgr.removeimage = function(self,gx,gy)
	local k = "s_x"..gx.."y"..gy
	local s = self.handle[k]
	if type(s)=="userdata" and s:getParent()~=nil then
		self.handle[k] = nil
		s:getParent():removeChild(s,true)
	end
	if self.data.iconBGKey~=0 and type(self.data.iconBGKey)=="string" then
		hApi.safeRemoveT(self.childUI,self.data.iconBGKey..gx.."|"..gy)
	end
end
--=============================================
-- 单位头像
--=============================================
local __GetFilePath = function(tPath,fileName)
	if #tPath>0 then
		for i = 1,#tPath do
			local r = tPath[i]..fileName
			if hApi.FileExists(r) then
				return r
			end
		end
		return tPath[#tPath]..fileName
	else
		return fileName
	end
end

local __xlThumbPath = {
	hApi.GetImagePath("icon/xlobj/"),
	hApi.GetFilePath("xlobj/"),
}

hApi.GetXLImagePath = function(sPath)
	return __GetFilePath(__xlThumbPath,sPath..".png")
end
hUI.thumbImage = {
	new = function(_,p)
		p.smartWH = p.smartWH or 1
		p.facing = p.facing or 180
		p.animation = p.animation or "stand"
		p.mask = 0
		if p.unit then
			p.id = p.unit.data.id
		end
		if p.mode=="portrait" then
			if p.id and p.id~=0 and hVar.tab_unit[p.id]~=nil then
				local tabU = hVar.tab_unit[p.id]
				if tabU.portrait~=nil then
					p.model = tabU.portrait
					if p.align==nil then
						p.align = "MC"
					end
					hUI.SYSAutoReleaseUI:addModel("portrait",p.model)
				elseif tabU.model then
					--老的读取图片的方式
					local m = tabU.model
					p.mode = "file"
					if p.align==nil then
						p.align = "MC"
					end
					local s = string.find(m,":")
					if s then
						p.model = hApi.GetImagePath("icon/portrait/"..tostring(string.sub(m,s+1))..".png")
					else
						p.model = hApi.GetImagePath("icon/portrait/"..m..".png")
					end
					if hApi.FileExists(p.model) then
					else
						p.mode = nil
						p.model = nil
					end
				end
			end
		else
			if (p.id or 0)>0 then
				local tabU = hVar.tab_unit[p.id]
				if tabU and tabU.thumb then
					if type(tabU.thumb)=="table" then
						local v = tabU.thumb
						if (v[1] or 0)~=0 then
							p.model = v[1]
						end
						if (v[2] or 1)~=1 then
							p.scale = (p.scale or 1)*v[2]
						end
						if type(v[3])=="table" then
							p.anchor = v[3]
						end
					else
						p.model = tabU.thumb
					end
				end
			end
			if p.model==nil and p.unit then
				local u = p.unit
				p.id = u.data.id
				if u.handle.__manager=="lua" then
					if hVar.tab_model[u.handle.modelIndex] then
						p.model = hVar.tab_model[u.handle.modelIndex].name
						p._animation = p.animation
					end
				elseif u.handle.__manager=="xlobj" then
					p.mode = "file"
					p.model = __GetFilePath(__xlThumbPath,u.handle.xlPath..".png")
					p.align = "MC"
				end
			end
		end
		if p.model==nil and p.id and p.id~=0 and hVar.tab_unit[p.id]~=nil then
			local tabU = hVar.tab_unit[p.id]
			if tabU.model~=nil then
				p.model = tabU.model
				p._animation = p.animation
				if tabU.type==hVar.UNIT_TYPE.HERO then
					hUI.SYSAutoReleaseUI:addModel("hero",p.model,p.animation)
				end
			elseif type(tabU.xlobj)=="string" then
				p.mode = "file"
				p.model = __GetFilePath(__xlThumbPath,tabU.xlobj..".png")
				if p.align==nil then
					p.align = "MC"
				end
				--增加 mask 组成 image 仅对 file 模式 生效
				if type(tabU.mask) == "string" then
					p.mask = __GetFilePath(__xlThumbPath,tabU.mask..".png")
				end
			end
			
		end
		return hUI.image:new(p)
	end,
}


--=============================================
-- 单位列表
--=============================================

hUI.cardList = eClass:new("static")
local _gcl =hUI.cardList
local __DefaultParam = {
	grid = 0,
	movetime = 300,
	cardNum = 9,
	cardMax = 20,
	--offsetX = {0},--{0,0,0,  0,  0, 22},
	--offsetY = {0},--{0,0,0,  0,-10,-26},
	--define =  {0},--{0,0,0,"s","o","o"},
}
_gcl.destroy = function(self)
	local d = self.data
	d.define = {}
	d.grid = 0
	rawset(self,"insert",nil)
	self:__removeAll()
end
local __define = {0}
_gcl.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.delT =hApi.clearTable("H",rawget(self,"delT"))
	self.card = hApi.clearTable("H",rawget(self,"card"))
	local d = self.data
	d.offsetX = {0}
	d.offsetY = {0}
	d.define = {0}
	if p~=nil then
		if p.define~=nil then
			for i = 2,#p.define,1 do
				d.define[i] = p.define[i]
				d.offsetX[i] = p.offsetX and p.offsetX[i] or 0
				d.offsetY[i] = p.offsetY and p.offsetY[i] or 0
			end
		end
		if type(p.insert)=="function" then
			rawset(self,"insert",p.insert)
		end
	end
end

_gcl.enumS = function(self,index,code,param)	--code(ObjectOrSprite,param,index,offsetX,offsetY)
	local d = self.data
	local c = self.card
	if c[index]~=nil then
		local f = d.define
		local v = c[index]
		local ox,oy = d.offsetX,d.offsetY
		for i = 1,#f do
			if f[i]~=0 and v[i]~=0 and v[i]~=nil then
				if f[i]=="o" then
					code(v[i].handle.s,param,i,ox[i],oy[i])
				elseif f[i]=="s" then
					code(v[i],param,i,ox[i],oy[i])
				end
			end
		end
	end
end

local __grid,__index,__time
local __setXY = function(s,_,_,ox,oy)
	local x,_ = __grid:grid2xy(__index-1,0)
	x = x + __grid.data.x
	local _x,y = s:getPosition()
	if x-_x+ox~=0 then
		s:runAction(CCMoveBy:create(__time,ccp(x-_x+ox,0)))
	end
end
_gcl.setXY = function(self,index,MoveTime)
	local d = self.data
	local c = self.card
	if d.grid==0 then
		--只有设置了grid才能调用这个函数
		_DEBUG_MSG("[LUA HINT] d.grid==0 的 cardList 无法执行 setXY")
		return
	end
	if c[index]~=nil and #c[index]==#d.define then
		__grid,__index,__time = d.grid,index,(MoveTime or d.movetime)/1000
		self:enumS(index,__setXY)
	end
end

_gcl.count = function(self)
	local d = self.data
	local c = self.card
	local count,iLast = 0,0
	for i = 1,d.cardMax do
		if c[i]~=nil then
			count = count + 1
			iLast = i
		end
	end
	return count,iLast
end

-----------------------------------------------
-- 删除sprite
-----------------------------------------------
local __cardList__RemoveSprite = function(self,v)
	local f = self.data.define
	for i = 1,#f do
		if f[i]~=0 and v[i]~=0 and v[i]~=nil then
			if f[i]=="o" then
				v[i]:del()
			elseif f[i]=="s" then
				v[i]:getParent():removeChild(v[i],true)
			end
			v[i] = 0
		end
	end
end
-----------------------------------------------
-- 延迟删除
-----------------------------------------------
local __forceToDel = 0
local __tick
local __cardList__RemoveGarbage = function(self)
	local f = __forceToDel
	__forceToDel = 0
	local t = self.delT
	local count = 0
	for i = 1,#t,1 do
		if t[i]~=0 then
			count = count + 1
			if f==1 or t[i][1]<=__tick then
				local v = t[i]
				t[i] = 0
				__cardList__RemoveSprite(self,v)
			end
		end
	end
	if count==0 and #t>0 then
		for i = #t,1 do
			t[i] = nil
		end
	end
end
local __cardList__TimerLoop = function()
	_gcl:enum(__cardList__RemoveGarbage)
end

hApi.addTimerForever("__RemoveTempSprite",hVar.TIMER_MODE.GAMETIME,1,function(tick)
	__tick = tick
	xpcall(__cardList__TimerLoop,hGlobal.__TRACKBACK__)
end,1)
-----------------------------------------------
_gcl.__removeAll = function(self)
	for k in pairs(self.card)do
		self:__removeInTime(k,0)
	end
	__forceToDel = 1
	__cardList__RemoveGarbage(self)
end
_gcl.__removeInTime = function(self,index,time)
	local d = self.data
	local c = self.card
	if c[index]~=nil then
		if #c[index]==#d.define then
			local v = c[index]
			c[index] = nil
			if time<=0 then
				__cardList__RemoveSprite(self,v)
			else
				v[1] = hApi.gametime() + time
				self.delT[#self.delT+1] = v
			end
		else
			c[index] = nil
		end
	end
end
-----------------------------------------------
local __self,__time
local __removeFunc = {
	["dead"] = function(s)
		s:runAction(CCFadeOut:create(__time))
		s:runAction(CCJumpBy:create(__time,ccp(0,-100),50,1))
	end,
	["fadeX"] = function(s)
		s:runAction(CCFadeOut:create(__time))
		s:runAction(CCScaleBy:create(__time*5/8,1.5,1.5))
	end,
	["fadeF"] = function(s)
		s:runAction(CCFadeOut:create(__time/2))
	end,
	["fade"] = function(s)
		s:runAction(CCFadeOut:create(__time))
	end,
}
_gcl.remove = function(self,index,style)
	if index=="all" then
		return self:__removeAll()
	end
	local d = self.data
	local c = self.card
	if c[index]~=nil then
		if #c[index]==#self.data.define then
			local _timeR = d.movetime
			if style~=nil and __removeFunc[style]~=nil then
				__self = self
				__time = d.movetime/1000
				self:enumS(index,__removeFunc[style])
				self:__removeInTime(index,_timeR+100)
			else
				self:__removeInTime(index,-1)
			end
		else
			c[index] = nil
		end
	end
end

_gcl.sort = function(self,style)
	local d = self.data
	local c = self.card
	local vLen = #d.define
	local iLast
	local count = 0

	for i = 1,d.cardMax+1,1 do
		local v = c[i]
		count = count + (c[i] and 1 or 0)
		if style=="setXY" then
			if v~=nil then
				iLast = i
				self:setXY(iLast,d.movetime)
			end
		else
			if v~=nil then
				if iLast~=nil then
					c[iLast] = v
					c[i] = nil
					self:setXY(iLast,d.movetime)
					iLast = iLast + 1
				end
			elseif iLast==nil then
				iLast = i
			end
		end
	end
	iLast = iLast or (d.cardMax + 1)
	if count>0 and iLast>d.cardNum then
		iLast = d.cardNum+1
		for i = d.cardNum+1,d.cardMax,1 do
			self:remove(i,"fade")
		end
		return iLast
	end
	return iLast
end

local __self,__time
local __insertFunc = {
	["insert"] = function(s,_,i)
		local d = __self.data
		local plusY = (d.grid~=0 and d.grid.data.iconH or 64) + 10
		local x,y = s:getPosition()
		if i~=4 then
			s:setOpacity(0)	--设置透明度(必须不是insert的第4个，因为这个是plist模式的)
		end
		s:runAction(CCFadeIn:create(__time/4))
		s:setPosition(x,y+plusY)
		s:runAction(CCMoveBy:create(__time,ccp(0,-1*plusY)))
	end,
	["fade"] = function(s,_,i)
		if i~=4 then
			--s:setOpacity(0)	--设置透明度(必须不是insert的第4个，因为这个是plist模式的)
		end
		s:runAction(CCFadeIn:create(__time))
	end,
}
_gcl.insert = function(self,index,tab_object,style)
	self:remove(index,"dead")
	local d = self.data
	local c = self.card
	if #tab_object~=#d.define then
		_DEBUG_MSG("[LUA ALERT] 尝试向 cardList 中插入非法的 object")
		return
	end
	tab_object[1] = 0
	c[index] = tab_object
	local time = d.movetime/1000
	if style~=nil and __insertFunc[style]~=nil then
		__self = self
		__time = d.movetime/1000
		self:enumS(index,__insertFunc[style])
	end
end


-------------------
local __AddStringToTab = function(t,s,sLog,i)
	local n = #t+1
	t[n] = s
	if t.log then
		t.log[n] = sLog..":"..i
	end
end
local __LoadConvertedMapString = function(vTalk,s,defaultS)
	--$+xxxx为替换对应tab_stringM中对应的字符串
	if type(hVar.tab_stringM[s])=="table" then
		local t = hVar.tab_stringM[s]
		for i = 1,#t do
			__AddStringToTab(vTalk,t[i],s,i)
		end
		return 1
	elseif defaultS then
		__AddStringToTab(vTalk,defaultS,defaultS,0)
		return 1
	end
end
local __AddIdToTab = function(t,v,s,e)
	local n = string.sub(v,s,e)
	if n then
		local id = tonumber(n)
		if id and id~=0 then
			t[id] = 1
		end
	end
end
local __LoadIdFromString = function(t,v)
	if v==nil or v=="" then
		return t
	end
	local s = string.find(v,",")
	local n = string.len(v)
	local p = 1
	while(s)do
		if p<=s-1 then
			__AddIdToTab(t,v,p,s-1)
		end
		p = s+1
		if p<n then
			s = string.find(v,",",p)
		else
			break
		end
	end
	if p<=n then
		__AddIdToTab(t,v,p,n)
	end
	return t
end
hApi.LoadConvertedMapString = __LoadConvertedMapString
hApi.LoadIdFromString = __LoadIdFromString
hApi.AddIdToTab = __AddIdToTab
-------------------

--常乾辰专用表解析
dealNumberRelT = function(str,t1,t2)-->= <= > < =  1,2,3,4,5
	if t1 == nil or t2 == nil then
		return
	end
	local numStartPos = string.find(str,":")
	if numStartPos == nil then
		return
	else
		numStartPos = numStartPos + 1
	end
	local num = tonumber(string.sub(str,numStartPos))
	if string.find(str,">=") ~= nil then
		t1[#t1+1] = 1
	elseif string.find(str,"<=") ~= nil then
		t1[#t1+1] = 2
	elseif string.find(str,">") ~= nil then
		t1[#t1+1] = 3
	elseif string.find(str,"<") ~= nil then
		t1[#t1+1] = 4
	elseif string.find(str,"=") ~= nil then
		t1[#t1+1] = 5
	end
	t2[#t2+1] = num
end
--常乾辰专用比较大小
bigSmallEqual = function(a,b,rel)
	if rel == 1 then-->=
		if a >= b then
			return 1
		else
			return 0
		end
	elseif rel == 2 then--<=
		if a <= b then
			return 1
		else
			return 0
		end
	elseif rel == 3 then-->
		if a > b then
			return 1
		else
			return 0
		end
	elseif rel == 4 then--<
		if a < b then
			return 1
		else
			return 0
		end
	elseif rel == 5 then--=
		if a == b then
			return 1
		else
			return 0
		end
	end
end

--对话解析
local __CODE__AnalyzeTgrTalk = function(oUnit,oTarget,nCurIndex,tTalk,tConvert,tTemp,tAppend)
	nCurIndex = nCurIndex + 1
	local v = tTalk[nCurIndex]
	if v==nil then
		return 0
	elseif string.sub(v,1,1)=="$" then
		if tConvert~=nil then
			for i = 1,#tConvert do
				if string.find(v,tConvert[i][1]) then
					local vx = string.gsub(v,tConvert[i][1],tConvert[i][2])
					if hVar.tab_stringM[vx] then
						v = vx
					end
					break
				end
			end
		end
		--需要进行字符串转换
		__LoadConvertedMapString(tTemp,v,v)
	else
		local s,e = string.find(v,"@(.-)@")
		if s==1 then
			local tI = string.find(v,":")
			local TagToDo,TagData,TagParam
			if tI==nil then
				TagToDo = string.sub(v,1,e-1) or ""
				TagData = ""
				TagParam = ""
			else
				TagToDo = string.sub(v,1,tI)
				local tII = string.find(v,":",tI+1)
				if tII==nil then
					TagData = string.sub(v,tI+1,e-1) or ""
					TagParam = ""
				else
					TagData = string.sub(v,tI+1,tII-1) or ""
					TagParam = string.sub(v,tII+1,e-1) or ""
				end
			end
			if TagToDo=="@random:" then
				--只能取随机的文字，不支持表达式解析
				local nSelect = tonumber(TagData) or 0
				if nSelect>0 then
					local text = tTalk[nCurIndex+hApi.localrandom(1,nSelect)]
					nCurIndex = nCurIndex + nSelect
					if text~=nil then
						__LoadConvertedMapString(tTemp,text,text)
					end
				end
			else
				local oTargetX
				local IsSubTalkString = 1
				if string.sub(TagToDo,1,2)=="@[" then
					local tarID = 0
					--需要发生生效单位转换
					local n = string.find(TagToDo,"%]")
					if n then
						if n>3 then
							local k = string.sub(TagToDo,3,n-1)
							if k=="u" then
								oTargetX = oUnit
							elseif k=="t" then
								oTargetX = oTarget
							else
								tarID = tonumber(k)
								oTargetX = hGlobal.WORLD.LastWorldMap:tgrid2unit(tarID)
							end
						end
						TagToDo = "@"..string.sub(v,n+1,tI)
					end
				else
					oTargetX = oTarget
				end
				if oTargetX then
					local code = hVar.TGR_CODE_IN_TALK[TagToDo]
					if code and type(code)=="function" then
						local nGoNext,sText,vAppend = code(TagData,TagParam,oUnit,oTarget,oTargetX,tTalk,nCurIndex,tTemp)
						--如果拥有此值，会将其加到最后一句后面
						if type(vAppend)=="table" then
							tAppend.n = tAppend.n + 1
							tAppend[nCurIndex+vAppend[1]] = vAppend[2]
						end
						if nGoNext and type(nGoNext)=="number" then
							if nGoNext>0 then
								nCurIndex = nCurIndex + nGoNext
							elseif nGoNext<0 then
								--小于0则退出循环
								nCurIndex = #tTalk + 1
								v = nil
								IsSubTalkString = 0
							end
						end
						if sText then
							IsSubTalkString = 0
							if type(sText)=="string" then
								v = sText
							else
								v = nil
							end
						end
					else
						IsSubTalkString = 0
					end
				else
					IsSubTalkString = 0
				end
				if IsSubTalkString==1 and v~=nil then
					if string.len(v)>e then
						v = string.sub(v,e+1)
					else
						v = nil
					end
				end
			end
		end
		if v then
			tTemp[#tTemp+1] = v
		end
	end
	return nCurIndex,v
end
local __CODE__InsertToTalk = function(nType,vInsert,tTalk)
	if nType==-2 then
		--插入到最后一个字符串前面
		local nInsertI
		for i = #tTalk,1,-1 do
			if type(tTalk[i])=="string" then
				nInsertI = i
				break
			end
		end
		if nInsertI~=nil then
			for i = #tTalk,nInsertI,-1 do
				tTalk[i+1] = tTalk[i]
			end
			tTalk[nInsertI] = vInsert
			return
		end
	elseif nType==-1 then
		--插入到最后一个字符串后面
		local nInsertI
		for i = #tTalk,1,-1 do
			if type(tTalk[i])=="string" then
				nInsertI = i
				break
			end
		end
		if nInsertI~=nil and nInsertI<#tTalk then
			for i = #tTalk,nInsertI+1,-1 do
				tTalk[i+1] = tTalk[i]
			end
			tTalk[nInsertI] = vInsert
			return
		end
	end
	--插入到最后面
	tTalk[#tTalk+1] = vInsert
end
hApi.AnalyzeTalk = function(oUnit,oTarget,selectedTalk,vTalk)
	if g_editor == 1 then return end
	if vTalk and selectedTalk and #selectedTalk>=2 then
		local tConvert
		if hGlobal.WORLD.LastWorldMap and type(oUnit)=="table" and type(oUnit.getworld)=="function" and oUnit:getworld()==hGlobal.WORLD.LastWorldMap then
			local tgrDataP = hGlobal.WORLD.LastWorldMap:getmapdata(1)
			if tgrDataP and type(tgrDataP.TalkConvert)=="table" then
				tConvert = tgrDataP.TalkConvert
				for i = 1,#tConvert do
					if not(type(tConvert[i]=="table") and type(tConvert[i][1])=="string" and type(tConvert[i][2])=="string") then
						tConvert = nil
						break
					end
				end
			end
		end
		local tAppend = {c=1,n=0}
		local nCurIndex = 1
		local IsExit = 0
		while(IsExit==0)do
			local idx,str = __CODE__AnalyzeTgrTalk(oUnit,oTarget,nCurIndex,selectedTalk,tConvert,vTalk,tAppend)
			nCurIndex = idx
			if nCurIndex==0 or nCurIndex>#selectedTalk then
				IsExit = 1
			end
			if tAppend.n>0 and (str~=nil or IsExit==1) then
				for i = tAppend.c,nCurIndex,1 do
					local v = tAppend[i]
					if v~=nil then
						tAppend.c = i
						tAppend[i] = nil
						tAppend.n = tAppend.n - 1
						local nType,vInsert
						if type(v)=="table" then
							nType = v[1]
							vInsert = v[2]
						else
							nType = 0
							vInsert = v
						end
						__CODE__InsertToTalk(nType,vInsert,vTalk)
					end
				end
			end
		end
		--print("--talk-----------------")
		--for i = 1,#vTalk do
			--print("	-"..i..tostring(vTalk[i]))
		--end
	end
	return vTalk
end

hApi.InitUnitTalk = function(oUnit,oTarget,tTalk,talkTagCommon,tBattleLog)
	--print("对话内容:",talkTagCommon)
	local talkTag = 0
	local uId,tId = 0,0
	if type(oUnit)=="table" then
		uId = oUnit.data.id
	end
	if type(oTarget)=="table" then
		tId = oTarget.data.id
		if talkTagCommon=="talk" then
			talkTag = oTarget.data.talkTag
			if talkTag==-1 then
				return
			end
		elseif oTarget.data.talkTag==-1 then
			return
		end
		--如果这是个合法的单位，并且是英雄
		if oTarget.ID and oTarget.__ID and type(oTarget.gethero)=="function" then
			--如果英雄已经忽视这个对话标签了，那么就禁止创建这个对话
			local oHero = oTarget:gethero()
			if oHero and type(oHero.data.IgnoredTalk)=="table" then
				for i = 1,#oHero.data.IgnoredTalk do
					if talkTagCommon==oHero.data.IgnoredTalk[i] then
						return
					end
				end
			end
		end
	end

	if tTalk==nil then
		local t
		if type(oTarget)=="table" then
			t = oTarget
		else
			t = oUnit
		end
		if t~=nil then
			if t.gettriggerdata then --防止弹框
				local tTgrData = t:gettriggerdata()
				if tTgrData then
					tTalk = tTgrData.talk
				end
			end
		end
	end

	if type(tTalk)~="table" then
		return
	end

	local tempTalk = {}
	local selectedTalk
	for i = 1,#tTalk do
		if talkTagCommon=="talk" then
			if talkTag==0 then
				if tTalk[i][1]==talkTagCommon then
					tempTalk[#tempTalk+1] = tTalk[i]
				end
			else
				if tTalk[i][1]==talkTag then
					tempTalk[#tempTalk+1] = tTalk[i]
				end
			end
		else
			if tTalk[i][1]==talkTagCommon then
				tempTalk[#tempTalk+1] = tTalk[i]
			end
		end
	end

	if selectedTalk==nil then
		if #tempTalk==1 then
			selectedTalk = tempTalk[1]
		elseif #tempTalk>0 then
			selectedTalk = tempTalk[hApi.random(1,#tempTalk)]
		end
	end

	if selectedTalk and #selectedTalk>=2 then
		local vTalk = {id = {tId,uId},tBattleLog = tBattleLog,log={}}
		hApi.AnalyzeTalk(oUnit,oTarget,selectedTalk,vTalk)
		if #vTalk>0 then
			return vTalk
		end
	end
end

hApi.CreateUnitTalk = function(tTalk,codeOnExit)
	if hGlobal.UI.CreateUnitTalk then
		return hGlobal.UI.CreateUnitTalk(tTalk,codeOnExit)
	elseif type(codeOnExit)=="function" then
		return codeOnExit()
	end
end

hApi.CreateMultiUnitTalk = function(tTalkList)
	--{unit,tTalk,vTalkTag,codeAfterTalk}
	local tIndex = 0
	local _CodeAfterTalk
	_CodeAfterTalk = function()
		tIndex = tIndex + 1
		if tIndex>#tTalkList or hGlobal.UI.CreateUnitTalk==nil then
			if type(tTalkList.ExitCode)=="function" then
				return tTalkList.ExitCode()
			else
				return
			end
		end
		local oUnit = tTalkList[tIndex][1]
		local tTalk = tTalkList[tIndex][2]
		local vTalkTag = tTalkList[tIndex][3]
		local codeAfterTalk = tTalkList[tIndex][4]
		if type(codeAfterTalk)~="function" then
			codeAfterTalk = nil
		end
		local vTalk
		if type(vTalkTag)=="table" and #vTalkTag>0 then
			vTalk = vTalkTag
		else
			vTalk = hApi.InitUnitTalk(oUnit,oUnit,tTalk,vTalkTag)
		end
		if vTalk then
			local IsFuncOnly = 1
			for i = 1,#vTalk do
				if type(vTalk[i])~="function" then
					IsFuncOnly = 0
					break
				end
			end
			if IsFuncOnly==1 then
				for i = 1,#vTalk do
					vTalk[i]()
				end
				return _CodeAfterTalk()
			else
				local tEffect = {}
				if type(oUnit)=="table" and hClass.unit:find(oUnit.ID)==oUnit then
					local x,y = oUnit:getXY()
					local ox,oy = oUnit:getbox()
					local w = oUnit:getworld()
					if x and y and oy and w~=nil and hGlobal.LocalPlayer:getfocusworld()==w then
						xlClearFogByPoint(x,y)
						hApi.setViewNodeFocus(x,y)
						hApi.SetObjectEx(tEffect,w:addeffect(2,0,{hVar.EFFECT_TYPE.UNIT,"EmTalk",oUnit},0,-1*oy+8))
					end
				end
				return hGlobal.UI.CreateUnitTalk(vTalk,function()
					local e = hApi.GetObjectEx(hClass.effect,tEffect)
					if e then
						e:del()
					end
					hUI.Disable(550,"单位对话")
					hApi.addTimerOnce("__COMMON__NextMultiTalk",450,function()
						return _CodeAfterTalk()
					end)
					if codeAfterTalk then
						return xpcall(codeAfterTalk,hGlobal.__TRACKBACK__)
					end
				end)
			end
		else
			return _CodeAfterTalk()
		end
	end
	return _CodeAfterTalk()
end