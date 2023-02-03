--------------------------------------------
-- 选英雄卡片界面
-- 选择英雄卡片进行游戏的界面 每次进入游戏时会弹出 并让玩家选择已有的 卡片上的英雄进行游戏
--------------------------------------------
hGlobal.UI._InitSelectedHeroFrm = function()
	local x,y,w,h = 50,740,940,715

	local _frm = nil
	local _parent = nil
	local _childUI = nil
	local _CardList = {}		--英雄卡片UI保存的局部变量
	local _CardSoltList = {}	--地图并槽子的表
	local _legionBtnList = {}	--势力选择相关
	local _time = 300/1000
	local _touchX,_touchY = 0,0
	local btnPosX = {}
	local btnPosY = {}
	
	--英雄卡片的 移动到达目标
	local _heroCardBegPosX = {}	--起始坐标XY
	local _heroCardBegPosY = {}
	local _heroCardEndPosX = {}	--终点坐标XY
	local _heroCardEndPosY = {}
	local _heroCardSatae = {}	--英雄卡片的状态

	local _HeroNum = 0		--本地图可选的英雄个数
	local _tempNheroNum = 0		--已经选了的计数器
	local _curBtn = {}		--正在移动的按钮方便回调设置状态
	local _curBtnIndex = 0		--当前正在移动的卡片按钮索引
	local _cardGridState = {}	--可选英雄槽子状态

	--local clipper = nil
	--local content = CCSprite:create("data/image/misc/gift.png")
	--content:setTag(kTagContentNode)
	--content:setAnchorPoint(ccp(0, 0))
	--content:setPosition(ccp(w/2,h/2))

	--local contentPosX,contentPosY = nil,nil
	
	hGlobal.UI.SelectedHeroFrm = hUI.frame:new({
		x = x,
		y = y,
		w = w,
		h = h,
		dragable = 2,
		show = 0,
		autoactive = 0,
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			
		end,
		--codeOnDragEx = function(touchX,touchY,touchMode)
			----按下
			--if touchMode == 0 then
				--_touchX,_touchY = touchX,touchY
				--for i = 1,#_CardList do
					--local node = _childUI[_CardList[i]]
					--btnPosX[i] = node.data.x
					--btnPosY[i] = node.data.y
				--end
				----contentPosX,contentPosY = content:getPosition()
			----滑动
			--elseif touchMode == 1 then
				--if math.abs(touchX-_touchX) > 50 and (touchX-_touchX) > 0 and math.abs(touchY-_touchY) < 80 then
					----_touchX,_touchY = touchX,touchY
					----print("右")
				--elseif math.abs(touchX-_touchX) > 50 and (touchX-_touchX) < 0 and math.abs(touchY-_touchY) < 80 then
					----_touchX,_touchY = touchX,touchY
					----print("左")
				--end

				--for i = 1,#_CardList do
					--local node = _childUI[_CardList[i]]
					--node:setXY(btnPosX[i]+touchX-_touchX,btnPosY[i])
					--if node.data.x < 65 or node.data.x > 800 then
						--node:setstate(-1)
					--else
						--node:setstate(1)
					--end
					----content:setPosition(contentPosX+touchX-_touchX,contentPosY+touchY-_touchY)
				--end
			----抬起
			--elseif touchMode == 2 then
				--btnPosX = {}
				--btnPosY = {}
			--end
		--end,
	})
	
	_frm = hGlobal.UI.SelectedHeroFrm
	_parent = _frm.handle._n
	_childUI = _frm.childUI
	
	--clipper = CCClippingNode:create(_parent)
	--clipper:setTag(kTagClipperNode)
	--clipper:setAnchorPoint(ccp(0, 0))
	--clipper:setPosition(ccp(0,0))
	--hUI.__static.uiLayer:addChild(clipper,100)
	--clipper:addChild(content,101)
	
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
	
	--分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 470,
		y = -545,
		w = w+20,
		h = 8,
	})
	
	_childUI["apartline_back1"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 470,
		y = -98,
		w = w+20,
		h = 8,
	})
	

	--此面板的退出方法
	local _exitFunc = function()
		--清理之前的数据
		for i = 1,#_CardList do
			hApi.safeRemoveT(_childUI,_CardList[i])
		end
		_CardList = {}
		
		for i = 1,#_CardSoltList do
			hApi.safeRemoveT(_childUI,_CardSoltList[i])
		end
		_CardSoltList = {}

		for i = 1,#_legionBtnList do
			hApi.safeRemoveT(_childUI,_legionBtnList[i][1])
		end
		_legionBtnList = {}

		_cardGridState = {}
		_HeroNum = 0
		_tempNheroNum = 0
		_curBtnIndex = 0
		hApi.SetObject(_curBtn,nil)
		_childUI["dragBox"]:sortbutton()
		_heroCardEndPosX = {}
		_heroCardEndPosY = {}
		_heroCardSatae = {}
		_childUI["selectlegionlab"].handle._n:setVisible(false)
	end
	--传入一张表随机英雄
	local _RandomIndex = function(tabNum,indexNum)
		indexNum = indexNum or tabNum
		local t = {}
		local rt = {}
		for i = 1,indexNum do
			local ri = hApi.random(1,tabNum + 1 - i)
			local v = ri
			for j = 1,tabNum do
				if not t[j] then
					ri = ri - 1
					if ri == 0 then
						table.insert(rt,j)
						t[j] = true
					end
				end
			end
		end
		return rt
	end

	--替换玩家选好的英雄
	--重新设置地图势力
--	local _replaceHeroList = function(tHeroList)
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld==nil then
--			return
--		end
--		if #tHeroList==0 then
--			return
--		end
--		
--		local tSelectedHeroId = {}
--		local tLegionList = {}
--		--读取阵营参数
--		local map_legion = hVar.MAP_LEGION[hGlobal.WORLD.LastWorldMap.data.map]
--		if type(map_legion)=="table" then
--			--读取所有可以选择英雄的阵营(未选择的阵营将使用随机英雄)
--			for i = 1,#map_legion do
--				if map_legion[i][1]==hVar.PLAYER.NEUTRAL_PASSIVE then
--					--中立被动玩家不让换
--				elseif map_legion[i][3] and type(map_legion[i][3])=="table" then
--					local nPlayer = map_legion[i][1]
--					local tAvailableHero = map_legion[i][3]
--					local tUnitCreateParam = {}
--					local tSelectedHero = {}
--					tLegionList[#tLegionList+1] = {nPlayer,tAvailableHero,tUnitCreateParam,tSelectedHero}	--legion信息:阵营id,可用随机英雄,替换位置参数,需要创建的英雄参数
--				end
--			end
--		end
--
--		--如果不是多势力,就替换自己的单位
--		if #tLegionList==0 then
--			local nPlayer = hGlobal.LocalPlayer.data.playerId
--			local tAvailableHero = {}
--			tLegionList[#tLegionList+1] = {nPlayer,tAvailableHero,{},{}}
--		end
--
--		--确定一个替换势力
--		local nReplacedLegion = tHeroList[1][2]
--		local tSelectedLegion
--		for i = 1,#tLegionList do
--			if tLegionList[i][1]==nReplacedLegion then
--				tSelectedLegion = tLegionList[i]
--				break
--			end
--		end
--
--		--移除所有需要替换阵营的英雄
--		for n = 1,#tLegionList do
--			local nOwnPlayer = tLegionList[n][1]
--			local tAvailableHero = tLegionList[n][2]
--			local tUnitCreateParam = tLegionList[n][3]
--			local tSelectedHero = tLegionList[n][4]
--			if hGlobal.player[nOwnPlayer] then
--				local oPlayer = hGlobal.player[nOwnPlayer]
--				local tabH = {}
--				for i = 1,#oPlayer.heros do
--					local oHero = oPlayer.heros[i]
--					if type(oHero)=="table" and oHero.ID~=0 then
--						tabH[#tabH+1] = oHero
--					end
--				end
--				for i = 1,#tabH do
--					local oHero = tabH[i]
--					local u = oHero:getunit()
--					if u then
--						local d = u.data
--						tUnitCreateParam[#tUnitCreateParam+1] = {d.id,d.owner,d.worldX,d.worldY,d.facing,d.triggerID,d.editorID,d.curTown}
--						u:del()
--					end
--					oHero:del()
--				end
--			end
--		end
--
--		--替换目标阵营的英雄
--		if tSelectedLegion then
--			----重置迷雾信息
--			--移动到第0天开始的时候
--			--if xlMap_ResetFog then
--				--xlMap_ResetFog()
--			--end
--			local nOwnPlayer = hGlobal.LocalPlayer.data.playerId
--			local tAvailableHero = tSelectedLegion[2]
--			local tUnitCreateParam = tSelectedLegion[3]
--			local tSelectedHero = tSelectedLegion[4]
--			local tHeroListX = {}
--			--对传入的列表进行一次排序，保证index
--			for i = 1,#tHeroList do
--				if tHeroList[i][3]>0 then
--					tHeroListX[#tHeroListX+1] = tHeroList[i]
--				end
--			end
--			if #tHeroList>0 then
--				table.sort(tHeroListX,function(a,b)
--					return a[3]<b[3]
--				end)
--			end
--			for i = 1,#tHeroList do
--				if tHeroList[i][3]<=0 then
--					tHeroListX[#tHeroListX+1] = tHeroList[i]
--				end
--			end
--			--把数据塞进去
--			for i = 1,#tUnitCreateParam do
--				if tHeroListX[i] then
--					local _,_,worldX,worldY,facing,triggerID,editorID,curTown = unpack(tUnitCreateParam[i])
--					local id = tHeroListX[i][1]
--					local owner = nOwnPlayer
--					if tSelectedHeroId[id]==1 then
--						_DEBUG_MSG("[LUA WARINIG]已经选择过英雄("..id..")了！你在搞笑！")
--					else
--						tSelectedHeroId[id] = 1
--						tSelectedHero[#tSelectedHero+1] = {id,owner,worldX,worldY,facing,triggerID,editorID,curTown}
--					end
--				end
--			end
--		else
--			_DEBUG_MSG("[LUA WARINIG]找不到可以替换的军团信息！")
--		end
--
--		--尝试替换中立被动玩家的可营救英雄
--		--这类英雄必须是直接对话加入，并且对话中存在"@func:join"或"@func:jointeam@"字符串
--		if hGlobal.player[hVar.PLAYER.NEUTRAL_PASSIVE] and hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].randhero == 1 then
--			local nOwnPlayer = hVar.PLAYER.NEUTRAL_PASSIVE
--			local tAvailableHero
--			local tUnitCreateParam
--			local tSelectedHero
--			for i = 1,#tLegionList do
--				if tLegionList[i][1]==hVar.PLAYER.NEUTRAL_PASSIVE then
--					tAvailableHero = tLegionList[i][2]
--					tUnitCreateParam = tLegionList[i][3]
--					tSelectedHero = tLegionList[i][4]
--					break
--				end
--			end
--			if tUnitCreateParam==nil then
--				local v = {hVar.PLAYER.NEUTRAL_PASSIVE,{},{},{}}
--				tLegionList[#tLegionList+1] = v
--				tAvailableHero = v[2]
--				tUnitCreateParam = v[3]
--				tSelectedHero = v[4]
--				if Save_PlayerData and Save_PlayerData.herocard then
--					for i = 1,#Save_PlayerData.herocard do
--						tAvailableHero[#tAvailableHero+1] = Save_PlayerData.herocard[i].id
--					end
--				end
--			end
--			if type(tUnitCreateParam)=="table" and type(tAvailableHero)=="table" and #tAvailableHero>0 then
--				local oPlayer = hGlobal.player[hVar.PLAYER.NEUTRAL_PASSIVE]
--				local tabH = {}
--				for i = 1,#oPlayer.heros do
--					local oHero = oPlayer.heros[i]
--					if type(oHero)=="table" and oHero.ID~=0 then
--						tabH[#tabH+1] = oHero
--					end
--				end
--				for i = 1,#tabH do
--					local oHero = tabH[i]
--					local u = oHero:getunit()
--					if u then
--						local tgrDataU = u:gettriggerdata()
--						if tgrDataU and tgrDataU.talk then
--							for n = 1,#tgrDataU.talk do
--								--判断是否营救英雄
--								local v = tgrDataU.talk[n]
--								local CanReplace = 0
--								for o = 2,#v do
--									if v[o]=="@func:join@" or v[o]=="@func:jointeam@" then
--										CanReplace = 1
--										break
--									end
--								end
--								--是营救英雄，可替换
--								if CanReplace==1 then
--									local d = u.data
--									tUnitCreateParam[#tUnitCreateParam+1] = {d.id,d.owner,d.worldX,d.worldY,d.facing,d.triggerID,d.editorID,d.curTown}
--									u:del()
--									oHero:del()
--								end
--							end
--						end
--					end
--				end
--			end
--		end
--
--		--如果存在其他的替换势力，那么也随机造几个单位给他们
--		for n = 1,#tLegionList do
--			local nOwnPlayer = tLegionList[n][1]
--			local tAvailableHero = tLegionList[n][2]
--			local tUnitCreateParam = tLegionList[n][3]
--			local tSelectedHero = tLegionList[n][4]
--			if tLegionList[n]~=tSelectedLegion and #tAvailableHero>0 and #tUnitCreateParam>0 then
--				--如果本地玩家替换掉了其他玩家的单位，那么用目标玩家替换掉本地玩家的单位
--				if nOwnPlayer==hGlobal.LocalPlayer.data.playerId and nReplacedLegion and tSelectedLegion then
--					nOwnPlayer = nReplacedLegion
--				end
--				for i = 1,#tUnitCreateParam do
--					local tRandomHeroId = {}
--					for k = 1,#tAvailableHero do
--						local id = tAvailableHero[k]
--						if tSelectedHeroId[id]~=1 then
--							tRandomHeroId[#tRandomHeroId+1] = id
--						end
--					end
--					if #tRandomHeroId>0 then
--						local _,_,worldX,worldY,facing,triggerID,editorID,curTown = unpack(tUnitCreateParam[i])
--						local id = tRandomHeroId[oWorld:random(1,#tRandomHeroId)]
--						local owner = nOwnPlayer
--						tSelectedHeroId[id] = 1
--						tSelectedHero[#tSelectedHero+1] = {id,owner,worldX,worldY,facing,triggerID,editorID,curTown}
--					end
--				end
--			end
--		end
--
--		--重新创建所有玩家的英雄
--		if #tLegionList>0 then
--			local tempTown = {}
--			local tempWorldParam = {}
--			local IsViewFocused = 0
--			local worldScene = oWorld.handle.worldScene
--			for n = 1,#tLegionList do
--				--说明这个队伍里面有单位需要创建
--				local tDataX = tLegionList[n][4]
--				if #tDataX>0 then
--					for i = 1,#tDataX do
--						local id,owner,worldX,worldY,facing,triggerID,editorID,curTown = unpack(tDataX[i])
--						local tgrDataD,tgrDataU
--						--读取trigger信息
--						if triggerID~=0 then
--							--{0,0,tgrDataU}
--							tgrDataT = oWorld.data.triggerIndex[triggerID]
--							if tgrDataT then
--								tgrDataU = tgrDataT[3]
--							end
--						end
--						local oUnit = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY,nil,{triggerID = triggerID,editorID = editorID})
--						if oUnit then
--							--if tgrDataT then
--								--tgrDataT[1] = oUnit.ID
--								--tgrDataT[2] = oUnit.__ID
--							--end
--							local oHero = hClass.hero:new({
--								name = hVar.tab_stringU[id][1],
--								id = id,
--								owner = owner,
--								unit = oUnit,
--								playmode = oWorld.data.playmode,
--							})
--							--刷迷雾，设置视野，自动聚焦
--							--挪到第一天进行
--							--if owner==hGlobal.LocalPlayer.data.playerId then
--								--if IsViewFocused==0 then
--									--IsViewFocused = 1
--									--hApi.setViewNodeFocus(worldX,worldY)
--								--end
--								--xlClearFogByPoint(worldX,worldY)
--							--end
--							local team
--							--加载触发器数据
--							if tgrDataU~=nil then
--								--设置单位触发器ID
--								if worldScene then
--									hApi.chaSetUniqueID(oUnit.handle,triggerID,worldScene)
--								end
--								--如果单位初始是隐藏的，那么藏起来
--								if tgrDataU.IsHide==1 then
--									oUnit:sethide(1)
--								end
--								--非玩家英雄读取触发器数据
--								if oHero and owner~=hGlobal.LocalPlayer.data.playerId then
--									oHero:loadtriggerdata(tgrDataU)
--								end
--							end
--							hGlobal.event:call("Event_UnitBorn",oUnit)
--						end
--					end
--				end
--			end
--		end
--	end

	--确定按钮
	_childUI["btnConfirm"] = hUI.button:new({
		parent = _parent,
		model = "UI:ConfimBtn1",
		dragbox = _childUI["dragBox"],
		x = w - 70,
		y = -h + 40,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			local tempHL = {}
			for i = 1,#_heroCardSatae do
				if _heroCardSatae[i][1] == 1 then 
					tempHL[#tempHL+1] = {_heroCardSatae[i][2],_heroCardSatae[i][3],_heroCardSatae[i][4]}
				end
			end
			--_replaceHeroList(tempHL)
			--hGlobal.event:call("Event_NewDay",0)
			_exitFunc()
		end,
	})

	--按钮下去以后的事件回调
	local _afterActionDown = function()
		_tempNheroNum = _tempNheroNum+1
		local btn = hApi.GetObject(_curBtn)
		local SelectedIndex = 0
		for i = 1,#_cardGridState do
			if _cardGridState[i][1] == _curBtnIndex and _cardGridState[i][2] == 1 then
				if btn ~= nil then
					btn:setXY(_heroCardEndPosX[i],_heroCardEndPosY[i])
				end
				SelectedIndex = i
				break
			end
		end
		hApi.SetObject(_curBtn,nil)
		_heroCardSatae[_curBtnIndex][1] = 1		--设置该卡片为可用
		_heroCardSatae[_curBtnIndex][4] = SelectedIndex	--是这个格子
		for i = 1,#_CardList do
			if _heroCardSatae[i][1] ~= -1 then
				_childUI[_CardList[i]]:setstate(1)
			end
		end
		if _tempNheroNum ==_HeroNum then
			_childUI["btnConfirm"]:setstate(1)
		end
	end

	--按钮浮上来之后的事件回调
	local _afterActionUp = function()
		_tempNheroNum = _tempNheroNum-1
		local btn = hApi.GetObject(_curBtn)
		if btn ~= nil then
			btn:setXY(_heroCardBegPosX[_curBtnIndex],_heroCardBegPosY[_curBtnIndex])
		end
		hApi.SetObject(_curBtn,nil)
		_heroCardSatae[_curBtnIndex][1] = 0
		for i = 1,#_CardList do
			if _heroCardSatae[i][1] ~= -1 then
				_childUI[_CardList[i]]:setstate(1)
			end
		end
	end

	--具体的移动方法
	local _CardMoveFunc = function(btn,index,mode,gridIndex)
		_childUI["btnConfirm"]:setstate(0)
		for i = 1,#_CardList do
			if _heroCardSatae[i][1] ~= -1 then
				_childUI[_CardList[i]]:setstate(0)
				_childUI[_CardList[i]].handle.s:setColor(ccc3(255,255,255))
			end
		end
		_curBtnIndex = index
		hApi.SetObject(_curBtn,btn)
		local node = btn.handle._n
		--向下移动
		if mode == 0 then
			_cardGridState[gridIndex][1] = _curBtnIndex
			_cardGridState[gridIndex][2] = 1
			node:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_heroCardEndPosX[gridIndex],_heroCardEndPosY[gridIndex])),CCCallFunc:create(_afterActionDown)))
			--node:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.3,1.28),CCCallFunc:create(_afterActionDown)))
		--向上移动
		else
			_cardGridState[gridIndex][1] = 0
			_cardGridState[gridIndex][2] = 0
			node:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_heroCardBegPosX[_curBtnIndex],_heroCardBegPosY[_curBtnIndex])),CCCallFunc:create(_afterActionUp)))
			--node:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.3,1),CCCallFunc:create(_afterActionUp)))
		end
	end
	
	--本关卡可选英雄的槽子个数
	local _createCardSolt = function(Num)
		for i = 1,#_CardSoltList do
			hApi.safeRemoveT(_childUI,_CardSoltList[i])
		end
		_CardSoltList = {}
		_heroCardEndPosX = {}
		_heroCardEndPosY = {}
		for i = 1,Num do
			_childUI["HeroCardBtnslot"..i]= hUI.image:new({
				parent = _parent,
				model = "UI:Card_slot",
				x = 510-Num*72 + (i-1) * 145,
				y = -h+85,
				scale = 0.8,
			})
			_CardSoltList[#_CardSoltList+1] = "HeroCardBtnslot"..i
			_heroCardEndPosX[#_heroCardEndPosX+1] = _childUI["HeroCardBtnslot"..i].data.x
			_heroCardEndPosY[#_heroCardEndPosY+1] = _childUI["HeroCardBtnslot"..i].data.y + 20
		end
	end
	
	local _getCardBGmodel = function(cardLv,mode)

		if mode == 1 then
			return "UI:PANEL_CARD_0"..(cardLv or 1)
		else
			return "UI:PANEL_CARD_0"..(cardLv+1)
		end
	end

	local _cardX,_cardY = 95, -160
	--显示英雄卡片
	local _showherocard = function(herolist,unHero,owner)
		--清理之前的数据
		for i = 1,#_CardList do
			hApi.safeRemoveT(_childUI,_CardList[i])
		end
		_CardList = {}
		_heroCardSatae = {}

		_cardGridState = {}
		for i = 1,_HeroNum do
			_cardGridState[i] = {0,0}
		end
		_childUI["btnConfirm"]:setstate(0)

		--英雄卡片列表
		local tempX,tempY = 0,0
		local id = 0
		for i = 1,#herolist do
		--for i = 1,18 do
			--先算出所有卡片的起始位置
			_heroCardBegPosX[i] = _cardX + tempX * 125
			_heroCardBegPosY[i] = _cardY - tempY * 145

			id = herolist[i].id
			--id = herolist[1].id
			_heroCardSatae[i] = {0,id,owner,0}	--状态，id，拥有者，LocalIndex
			_childUI["HeroCardBtn"..i] = hUI.button:new({
				parent = _parent,
				mode = "imageButton",
				dragbox = _childUI["dragBox"],
				model = hVar.tab_unit[id].portrait,
				x = _heroCardBegPosX[i],
				y = _heroCardBegPosY[i],
				w = 100,
				h = 100,
				scaleT = 0.9,
				failcall = 1,
				code = function(self,x,y)
					local node = self.handle._n
					node:getParent():reorderChild(node,1)
					
					--如果点击的是选择卡片位的令牌 则弹回去
					for k,v in pairs(_heroCardSatae) do
						if v[1] == 1 and k == i then
							for j = 1, #_cardGridState do
								if _cardGridState[j][1] == k then
									return _CardMoveFunc(self,i,1,j)
								end
							end
						end
					end
					if _tempNheroNum~=_HeroNum then
						for j = 1, #_cardGridState do
							if _cardGridState[j][2] == 0 then
								return _CardMoveFunc(self,i,0,j)
							end
						end
					end
				end,
			})
			_CardList[#_CardList+1] = "HeroCardBtn"..i
			for _,v in pairs(unHero) do
				if v == id then
					_childUI["HeroCardBtn"..i]:setstate(0)
					_heroCardSatae[i][1] = -1
				end
			end

			--换行标记
			tempX = tempX + 1
			if tempX > 6 then
				tempX = 0
				tempY = tempY + 1
			end
			
			SaveModifyFunc["herolist_cardLv"](herolist[i])
	
			_childUI["HeroCardBtn"..i].childUI["bg"] = hUI.image:new({
				parent = _childUI["HeroCardBtn"..i].handle._n,
				--zhenkira
				--model = _getCardBGmodel(herolist[i].cardLv,1),
				model = _getCardBGmodel(herolist[i].attr.level,1),
				x = 0,
				y = -17,
				z = -1,
				scale = 0.8,
			})

			_childUI["HeroCardBtn"..i].childUI["heroLv"] = hUI.label:new({
				parent = _childUI["HeroCardBtn"..i].handle._n,
				x = -38,
				y = -77,
				--zhenkira
				--text = (heroList[i].cardLv or 1), --geyachao: 读存档表的等级 --herolist[i].attr.level,
				text = (herolist[i].attr.level or 1),
				size = 16,
				font = "num",
				align = "MC",
				width = 200,
				scale = 0.8,
			})

			_childUI["HeroCardBtn"..i].childUI["heroName"] = hUI.label:new({
				parent = _childUI["HeroCardBtn"..i].handle._n,
				x = 25,
				y = -79,
				text = hVar.tab_stringU[herolist[i].id][1],
				size = 24,
				font = hVar.FONTC,
				align = "MC",
				border = 1,
				scale = 0.8,
			})

			for j = 1,5 do
				_childUI["HeroCardBtn"..i].childUI["HERO_STAR"..j] = hUI.image:new({
					parent = _childUI["HeroCardBtn"..i].handle._n,
					model = "UI:HERO_STAR",
					x = -38 + (j-1)*12.5,
					y = -60,
					scale = 0.8,
				})
			end
			_childUI["dragBox"]:sortbutton()
		end
	end
	
	--获取势力可选英雄
	local _getLegionHeroList = function(cardList,legion)
		local templist = {}
		for i = 1,#cardList do
			if type(legion) == "table" then
				for j = 1,#legion do
					if legion[j] == cardList[i].id then
						templist[#templist+1] = cardList[i]
					end
				end
			end
		end
		return templist
	end
	
	--势力信息
	_childUI["selectlegionlab"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y = -70,
		width = 400,
		--RGB = {255,205,55},
		text = hVar.tab_string["__TEXT_SelectedLegion"],
		border = 1,
	})
	_childUI["selectlegionlab"].handle._n:setVisible(false)

	--按钮选中框
	_childUI["Selectedbox"] = hUI.bar:new({
		parent = _parent,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 134,
		h = 44,
		z = 1,
	})
	_childUI["Selectedbox"].handle._n:setVisible(false)

	--按钮列表
	--只打开参数按钮 其他按钮全部不可用 做标签页切换效果
	local _setBtnState = function(btn)
		for i = 1,#_legionBtnList do
			if btn ~= _childUI[_legionBtnList[i][1]] then
				_childUI[_legionBtnList[i][1]]:setstate(1)
				_childUI[_legionBtnList[i][1]].handle._n:runAction(CCScaleTo:create(0.01,1,0.9))
				_childUI[_legionBtnList[i][1]]:setXY(_childUI[_legionBtnList[i][1]].data.x,-78)
			else
				btn:setstate(0)
				btn.handle._n:runAction(CCScaleTo:create(0.01,1,1))
				btn:setXY(btn.data.x,-75)
				btn.handle.s:setColor(ccc3(255,255,255))
				btn.childUI["label"].handle.s:setColor(ccc3(255,255,255))
				_childUI["Selectedbox"].handle._n:setPosition(btn.data.x,btn.data.y)
				_childUI["Selectedbox"].handle._n:setVisible(true)
			end
		end
	end

	local _createlegionBtn = function(legionlist)
		for i = 1,#_legionBtnList do
			hApi.safeRemoveT(_childUI,_legionBtnList[i][1])
		end
		_legionBtnList = {}
		local index = #_legionBtnList+1
		for i = 1,#legionlist do
			if legionlist[i][3] and type(legionlist[i][3])=="table" then
				_childUI["legion_btn_"..index] = hUI.button:new({
					parent = _parent,
					model = "UI:ButtonBack2",
					--icon = "ui/bimage_bbs.png",
					iconWH = 36,
					dragbox = _childUI["dragBox"],
					label = hVar.tab_string[legionlist[i][2]],
					font = hVar.FONTC,
					border = 1,
					x = 260 + (index-1) * 134,
					y = -120,
					h = 40,
					code = function(self)
						_setBtnState(self)
						for j = 1,#_legionBtnList do
							if _childUI[_legionBtnList[j][1]] == self then
								_tempNheroNum = 0
								hApi.SetObject(_curBtn,nil)
								if type(_heroCardSatae[_curBtnIndex]) == "table" then 
									_heroCardSatae[_curBtnIndex][1] = 0
								end
								
								local legionHerolist = _getLegionHeroList(Save_PlayerData.herocard,legionlist[_legionBtnList[j][2]][3])
								_showherocard(legionHerolist,{},_legionBtnList[j][3])
							end
						end
					end,
				})
				_legionBtnList[index] = {"legion_btn_"..index,i,legionlist[i][1]}
				index = index + 1
			end
		end
		_setBtnState(_childUI["legion_btn_1"])
	end

	--画出背景空的卡片槽子
	hGlobal.event:listen("localEvent_ShowSelectedHeroFrm","showthisfrm",function(cardList,heroNum,unselecthero,legion)
		_HeroNum = heroNum
		_tempNheroNum = 0
		_childUI["Selectedbox"].handle._n:setVisible(false)
		_createCardSolt(heroNum)

		local r,n = 0,0
		for i = 1,#legion do
			if legion[i][3] and type(legion[i][3])=="table" then 
				r,n = 1,i
				break
			end
		end
		--如果填了势力选择阵营表 则从势力表中 读取 并创建否则 就从英雄卡片中读取创建
		if r == 1 then
			_childUI["selectlegionlab"].handle._n:setVisible(true)
			_createlegionBtn(legion)
			local legionHerolist = _getLegionHeroList(cardList,legion[n][3])
			_showherocard(legionHerolist,{},legion[n][1])
		else
			_childUI["selectlegionlab"].handle._n:setVisible(false)
			_showherocard(cardList,unselecthero,1)
		end

		_frm:show(1)
		_frm:active()
	end)

end
