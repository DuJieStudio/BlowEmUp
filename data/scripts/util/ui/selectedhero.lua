--------------------------------------------
-- ѡӢ�ۿ�Ƭ����
-- ѡ��Ӣ�ۿ�Ƭ������Ϸ�Ľ��� ÿ�ν�����Ϸʱ�ᵯ�� �������ѡ�����е� ��Ƭ�ϵ�Ӣ�۽�����Ϸ
--------------------------------------------
hGlobal.UI._InitSelectedHeroFrm = function()
	local x,y,w,h = 50,740,940,715

	local _frm = nil
	local _parent = nil
	local _childUI = nil
	local _CardList = {}		--Ӣ�ۿ�ƬUI����ľֲ�����
	local _CardSoltList = {}	--��ͼ�����ӵı�
	local _legionBtnList = {}	--����ѡ�����
	local _time = 300/1000
	local _touchX,_touchY = 0,0
	local btnPosX = {}
	local btnPosY = {}
	
	--Ӣ�ۿ�Ƭ�� �ƶ�����Ŀ��
	local _heroCardBegPosX = {}	--��ʼ����XY
	local _heroCardBegPosY = {}
	local _heroCardEndPosX = {}	--�յ�����XY
	local _heroCardEndPosY = {}
	local _heroCardSatae = {}	--Ӣ�ۿ�Ƭ��״̬

	local _HeroNum = 0		--����ͼ��ѡ��Ӣ�۸���
	local _tempNheroNum = 0		--�Ѿ�ѡ�˵ļ�����
	local _curBtn = {}		--�����ƶ��İ�ť����ص�����״̬
	local _curBtnIndex = 0		--��ǰ�����ƶ��Ŀ�Ƭ��ť����
	local _cardGridState = {}	--��ѡӢ�۲���״̬

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
			----����
			--if touchMode == 0 then
				--_touchX,_touchY = touchX,touchY
				--for i = 1,#_CardList do
					--local node = _childUI[_CardList[i]]
					--btnPosX[i] = node.data.x
					--btnPosY[i] = node.data.y
				--end
				----contentPosX,contentPosY = content:getPosition()
			----����
			--elseif touchMode == 1 then
				--if math.abs(touchX-_touchX) > 50 and (touchX-_touchX) > 0 and math.abs(touchY-_touchY) < 80 then
					----_touchX,_touchY = touchX,touchY
					----print("��")
				--elseif math.abs(touchX-_touchX) > 50 and (touchX-_touchX) < 0 and math.abs(touchY-_touchY) < 80 then
					----_touchX,_touchY = touchX,touchY
					----print("��")
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
			----̧��
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
	
	--�ֽ���
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
	

	--�������˳�����
	local _exitFunc = function()
		--����֮ǰ������
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
	--����һ�ű����Ӣ��
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

	--�滻���ѡ�õ�Ӣ��
	--�������õ�ͼ����
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
--		--��ȡ��Ӫ����
--		local map_legion = hVar.MAP_LEGION[hGlobal.WORLD.LastWorldMap.data.map]
--		if type(map_legion)=="table" then
--			--��ȡ���п���ѡ��Ӣ�۵���Ӫ(δѡ�����Ӫ��ʹ�����Ӣ��)
--			for i = 1,#map_legion do
--				if map_legion[i][1]==hVar.PLAYER.NEUTRAL_PASSIVE then
--					--����������Ҳ��û�
--				elseif map_legion[i][3] and type(map_legion[i][3])=="table" then
--					local nPlayer = map_legion[i][1]
--					local tAvailableHero = map_legion[i][3]
--					local tUnitCreateParam = {}
--					local tSelectedHero = {}
--					tLegionList[#tLegionList+1] = {nPlayer,tAvailableHero,tUnitCreateParam,tSelectedHero}	--legion��Ϣ:��Ӫid,�������Ӣ��,�滻λ�ò���,��Ҫ������Ӣ�۲���
--				end
--			end
--		end
--
--		--������Ƕ�����,���滻�Լ��ĵ�λ
--		if #tLegionList==0 then
--			local nPlayer = hGlobal.LocalPlayer.data.playerId
--			local tAvailableHero = {}
--			tLegionList[#tLegionList+1] = {nPlayer,tAvailableHero,{},{}}
--		end
--
--		--ȷ��һ���滻����
--		local nReplacedLegion = tHeroList[1][2]
--		local tSelectedLegion
--		for i = 1,#tLegionList do
--			if tLegionList[i][1]==nReplacedLegion then
--				tSelectedLegion = tLegionList[i]
--				break
--			end
--		end
--
--		--�Ƴ�������Ҫ�滻��Ӫ��Ӣ��
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
--		--�滻Ŀ����Ӫ��Ӣ��
--		if tSelectedLegion then
--			----����������Ϣ
--			--�ƶ�����0�쿪ʼ��ʱ��
--			--if xlMap_ResetFog then
--				--xlMap_ResetFog()
--			--end
--			local nOwnPlayer = hGlobal.LocalPlayer.data.playerId
--			local tAvailableHero = tSelectedLegion[2]
--			local tUnitCreateParam = tSelectedLegion[3]
--			local tSelectedHero = tSelectedLegion[4]
--			local tHeroListX = {}
--			--�Դ�����б����һ�����򣬱�֤index
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
--			--����������ȥ
--			for i = 1,#tUnitCreateParam do
--				if tHeroListX[i] then
--					local _,_,worldX,worldY,facing,triggerID,editorID,curTown = unpack(tUnitCreateParam[i])
--					local id = tHeroListX[i][1]
--					local owner = nOwnPlayer
--					if tSelectedHeroId[id]==1 then
--						_DEBUG_MSG("[LUA WARINIG]�Ѿ�ѡ���Ӣ��("..id..")�ˣ����ڸ�Ц��")
--					else
--						tSelectedHeroId[id] = 1
--						tSelectedHero[#tSelectedHero+1] = {id,owner,worldX,worldY,facing,triggerID,editorID,curTown}
--					end
--				end
--			end
--		else
--			_DEBUG_MSG("[LUA WARINIG]�Ҳ��������滻�ľ�����Ϣ��")
--		end
--
--		--�����滻����������ҵĿ�Ӫ��Ӣ��
--		--����Ӣ�۱�����ֱ�ӶԻ����룬���ҶԻ��д���"@func:join"��"@func:jointeam@"�ַ���
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
--								--�ж��Ƿ�Ӫ��Ӣ��
--								local v = tgrDataU.talk[n]
--								local CanReplace = 0
--								for o = 2,#v do
--									if v[o]=="@func:join@" or v[o]=="@func:jointeam@" then
--										CanReplace = 1
--										break
--									end
--								end
--								--��Ӫ��Ӣ�ۣ����滻
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
--		--��������������滻��������ôҲ����켸����λ������
--		for n = 1,#tLegionList do
--			local nOwnPlayer = tLegionList[n][1]
--			local tAvailableHero = tLegionList[n][2]
--			local tUnitCreateParam = tLegionList[n][3]
--			local tSelectedHero = tLegionList[n][4]
--			if tLegionList[n]~=tSelectedLegion and #tAvailableHero>0 and #tUnitCreateParam>0 then
--				--�����������滻����������ҵĵ�λ����ô��Ŀ������滻��������ҵĵ�λ
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
--		--���´���������ҵ�Ӣ��
--		if #tLegionList>0 then
--			local tempTown = {}
--			local tempWorldParam = {}
--			local IsViewFocused = 0
--			local worldScene = oWorld.handle.worldScene
--			for n = 1,#tLegionList do
--				--˵��������������е�λ��Ҫ����
--				local tDataX = tLegionList[n][4]
--				if #tDataX>0 then
--					for i = 1,#tDataX do
--						local id,owner,worldX,worldY,facing,triggerID,editorID,curTown = unpack(tDataX[i])
--						local tgrDataD,tgrDataU
--						--��ȡtrigger��Ϣ
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
--							--ˢ����������Ұ���Զ��۽�
--							--Ų����һ�����
--							--if owner==hGlobal.LocalPlayer.data.playerId then
--								--if IsViewFocused==0 then
--									--IsViewFocused = 1
--									--hApi.setViewNodeFocus(worldX,worldY)
--								--end
--								--xlClearFogByPoint(worldX,worldY)
--							--end
--							local team
--							--���ش���������
--							if tgrDataU~=nil then
--								--���õ�λ������ID
--								if worldScene then
--									hApi.chaSetUniqueID(oUnit.handle,triggerID,worldScene)
--								end
--								--�����λ��ʼ�����صģ���ô������
--								if tgrDataU.IsHide==1 then
--									oUnit:sethide(1)
--								end
--								--�����Ӣ�۶�ȡ����������
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

	--ȷ����ť
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

	--��ť��ȥ�Ժ���¼��ص�
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
		_heroCardSatae[_curBtnIndex][1] = 1		--���øÿ�ƬΪ����
		_heroCardSatae[_curBtnIndex][4] = SelectedIndex	--���������
		for i = 1,#_CardList do
			if _heroCardSatae[i][1] ~= -1 then
				_childUI[_CardList[i]]:setstate(1)
			end
		end
		if _tempNheroNum ==_HeroNum then
			_childUI["btnConfirm"]:setstate(1)
		end
	end

	--��ť������֮����¼��ص�
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

	--������ƶ�����
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
		--�����ƶ�
		if mode == 0 then
			_cardGridState[gridIndex][1] = _curBtnIndex
			_cardGridState[gridIndex][2] = 1
			node:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_heroCardEndPosX[gridIndex],_heroCardEndPosY[gridIndex])),CCCallFunc:create(_afterActionDown)))
			--node:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.3,1.28),CCCallFunc:create(_afterActionDown)))
		--�����ƶ�
		else
			_cardGridState[gridIndex][1] = 0
			_cardGridState[gridIndex][2] = 0
			node:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_heroCardBegPosX[_curBtnIndex],_heroCardBegPosY[_curBtnIndex])),CCCallFunc:create(_afterActionUp)))
			--node:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.3,1),CCCallFunc:create(_afterActionUp)))
		end
	end
	
	--���ؿ���ѡӢ�۵Ĳ��Ӹ���
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
	--��ʾӢ�ۿ�Ƭ
	local _showherocard = function(herolist,unHero,owner)
		--����֮ǰ������
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

		--Ӣ�ۿ�Ƭ�б�
		local tempX,tempY = 0,0
		local id = 0
		for i = 1,#herolist do
		--for i = 1,18 do
			--��������п�Ƭ����ʼλ��
			_heroCardBegPosX[i] = _cardX + tempX * 125
			_heroCardBegPosY[i] = _cardY - tempY * 145

			id = herolist[i].id
			--id = herolist[1].id
			_heroCardSatae[i] = {0,id,owner,0}	--״̬��id��ӵ���ߣ�LocalIndex
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
					
					--����������ѡ��Ƭλ������ �򵯻�ȥ
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

			--���б��
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
				--text = (heroList[i].cardLv or 1), --geyachao: ���浵��ĵȼ� --herolist[i].attr.level,
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
	
	--��ȡ������ѡӢ��
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
	
	--������Ϣ
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

	--��ťѡ�п�
	_childUI["Selectedbox"] = hUI.bar:new({
		parent = _parent,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 134,
		h = 44,
		z = 1,
	})
	_childUI["Selectedbox"].handle._n:setVisible(false)

	--��ť�б�
	--ֻ�򿪲�����ť ������ťȫ�������� ����ǩҳ�л�Ч��
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

	--���������յĿ�Ƭ����
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
		--�����������ѡ����Ӫ�� ����������� ��ȡ ���������� �ʹ�Ӣ�ۿ�Ƭ�ж�ȡ����
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
