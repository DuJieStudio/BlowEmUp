--------------------------------
-- �Ի���ģ��
--------------------------------
hGlobal.UI.InitTalkFrame = function()
	local _frmW = hVar.SCREEN.w - 60
	local _textW = hVar.SCREEN.w - 260
	local _textX = 96
	local _nameX = 48
	local _AnalyzeTalk = hApi.DoNothing
	local _TalkContinue = hApi.DoNothing
	local _LIconX = 0
	local _RIconX = hVar.SCREEN.w-60
	local _HeadIconPos = {
		L = {
			{{_LIconX,16},		{_LIconX+128,48},	0,200,"LB",},
			{{_LIconX-64,16},	{_LIconX+128-64,48},	0,200,"LB",},
			{{_LIconX-64*2,16},	{_LIconX+128-64*2,48},	0,200,"LB",},
		},
		R = {
			{{_RIconX,16},		{_RIconX-128,48},	180,-200,"RB"},
			{{_RIconX+64,16},	{_RIconX-128-64,48},	180,-200,"RB"},
			{{_RIconX+64*2,16},	{_RIconX-128-64*2,48},	180,-200,"RB"},
		},
	}
	hGlobal.UI.TalkFrame = hUI.frame:new({
		x = 30,
		y = 180,
		w = _frmW,
		h = 160,
		dragable = 2,
		show = 0,
		bgAlpha = 220,
		autoactive = 0,
		--batchmodel = "UI:BAR_talk_bg",
		codeOnTouch = function(self,x,y,IsInside)
			local sLog = _TalkContinue(x,y,1)
			--�վ�Ҫ�ĵ���Ի�����
			--print(sLog)
		end,
		child = {
			{
				__UI = "image",
				__NAME = "talkContinue",
				model = "UI:DragHand",
				animation = "hover",
				x = _frmW - 48,
				y = -114,
				h = 36,
			},
			{
				__UI = "label",
				__NAME = "talkName",
				x = _nameX,
				y = -12,
				text = hVar.tab_string["__BLANK__"],
				font = hVar.FONTC,
				size = 28,
				width = 540,
			},
			{
				__UI = "label",
				__NAME = "talk",
				x = _textX,
				y = -42,
				text = hVar.tab_string["__EventLabel_Test"],
				font = hVar.FONTC,
				size = 28,
				width = _textW,
			},
		},
	})

	local _frm = hGlobal.UI.TalkFrame
	local _childUI = _frm.childUI
	local _TempTalk,_TempI,_TempId
	local _uImagePre = "uImage_"
	_frm.handle._in = CCNode:create()	--ר�ŷ�ͷ���_n
	_frm.handle._n:addChild(_frm.handle._in,-2)
	--_frm.handle._bn:getParent():reorderChild(_frm.handle._bn,990)
	_childUI["talk"].handle._n:getParent():reorderChild(_childUI["talk"].handle._n,991)
	_childUI["talkName"].handle._n:getParent():reorderChild(_childUI["talkName"].handle._n,992)
	_childUI["talkContinue"].handle._n:getParent():reorderChild(_childUI["talkContinue"].handle._n,993)

	--�е�ͼ����
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideTalkFrame",function(sSceneType,oWorld,oMap)
		_frm:show(0)
	end)

	--���ܺ���
	local _TF_IsContinue = 1
	local _TF_EnableClick = 1
	local _TF_TempUnitMove = nil
	local _tFunc = {}
	
	setmetatable(_tFunc,{
		__index = function(t,k)
			_DEBUG_MSG("[TalkFunc]�����ں���: "..tostring(k))
			return hApi.DoNothing
		end,
	})
	local _CODE_ProcessTalkCodeOnly = function(talkTable)
		local IsCodeOnly = 1
		for i = 1,#talkTable do
			if type(talkTable[i])~="function" then
				IsCodeOnly = 0
				break
			end
		end
		if IsCodeOnly==1 then
			--ֻ��function��̸������ִ��
			if #talkTable>1 then
				for i = 1,#talkTable-1 do
					if type(talkTable[i])=="function" then
						talkTable[i](_tFunc)
					end
				end
			end
			if type(talkTable[#talkTable])=="function" then
				talkTable[#talkTable](_tFunc)
				return 1
			else
				return 1
			end
		end
	end
	hApi.ProcessTalkCodeOnly = _CODE_ProcessTalkCodeOnly
	local _CODE_CreateUnitTalk = function(talkTable,IsNewTalk)
		local uId = 0
		if type(talkTable.id)=="table" then
			_TempId = talkTable.id
		else
			_TempId = nil
		end
		if IsNewTalk==1 then
			for k,v in pairs(_childUI)do
				if string.sub(k,1,7)==_uImagePre then
					hApi.safeRemoveT(_childUI,k)
				end
			end
		end
		hApi.safeRemoveT(_childUI,"TalkUIEx")
		hApi.safeRemoveT(_childUI,"LootGrid")
		_TempI = 0	--��һ������
		_TempTalk = talkTable
		_childUI["talkContinue"].handle._n:setVisible(true)
		--_frm:show(1,"appear")
		_frm:show(1,0)
		_frm:active()
		_TF_IsContinue = 1
		_TF_EnableClick = 1
		_TF_TempUnitMove = nil
		_tFunc.ClearAllSelection()
		_TalkContinue()
	end
	local _ImageLoadCount = 0
	local _CodeOnExit = nil
	local _LastLogString
	local _LastLogStringC
	local _SaveLogString = function()
		if _TempTalk and _TempTalk.log then
			_LastLogString = _LastLogStringC
			_LastLogStringC = _TempTalk.log[_TempI]
		end
	end
	hGlobal.UI.CreateUnitTalk = function(talkTable,codeOnExit)
		if _CODE_ProcessTalkCodeOnly(talkTable)==1 then
			if type(codeOnExit)=="function" then
				return codeOnExit()
			end
		else
			hGlobal.event:event("LocalEvent_ShowTalkFrm")
			_ImageLoadCount = 0
			_CodeOnExit = codeOnExit
			_LastLogString = nil
			_LastLogStringC = nil
			return _CODE_CreateUnitTalk(talkTable,1)
		end
	end
	local _SelectionNum = 0
	local _SelectionY = 0
	local _PausedByTalk = 0
	local _PauseOnNextString = 0
	_tFunc.ClearAllSelection = function()
		for i = 1,_SelectionNum do
			local btn = _childUI["btnSelection_"..i]
			if btn then
				_childUI["btnSelection_"..i] = nil
				btn:del()
			end
		end
		_SelectionNum = 0
		_SelectionY = 0
		_PausedByTalk = 0
		_PauseOnNextString = 0
		_childUI["dragBox"]:sortbutton()
	end
	_tFunc.GetFrm = function()
		return _frm
	end
	_tFunc.AddUIEx = function(oUI)
		hApi.safeRemoveT(_childUI,"TalkUIEx")
		_childUI["TalkUIEx"] = oUI
		return oUI
	end
	local baseY = math.floor((hVar.SCREEN.h- hGlobal.UI.TalkFrame.data.y)*(1-0.618))
	local _SelectionY = {
		[1] = {baseY},
		[2] = {baseY+35,baseY-35},
		[3] = {baseY+70,baseY,baseY-70},
		[4] = {baseY+105,baseY+35,baseY-35,baseY-105,},
		[5] = {baseY+140,baseY+70,baseY,baseY-70,baseY-140},
	}
	for n = 6,10 do
		_SelectionY[n] = {}
		local nLen = n*70
		for i = 1,n do
			_SelectionY[n][i] = baseY + math.floor(nLen/2) - (i-1)*70
		end
	end
	local _tFuncCode
	local _tFuncProcessCode = function()
		local code = _tFuncCode
		_tFuncCode = nil
		return code(_tFunc)
	end
	_tFunc.InitSelection = function(oUnit,oTarget,tSelection,tCode)
		_tFunc.ClearAllSelection()
		if oUnit and oTarget and tSelection then
			local sPos = _SelectionY[#tSelection]
			for i = 1,#tSelection do
				local TalkTag = tSelection[i][1]
				local TalkText = tSelection[i][2]
				local nDelay = tSelection[i][3]
				_SelectionNum = _SelectionNum + 1
				local btn = hUI.button:new({
					dragbox = _childUI["dragBox"],
					parent = _frm.handle._n,
					label = {
						text = TalkText,
						font = hVar.FONTC,
						size = 28,
						border = 1,
					},
					model = "misc/selectbg.png",
					w = math.floor(hVar.SCREEN.w*4/5),
					h = 48,
					x = math.floor(hVar.SCREEN.w/2),
					y = sPos[i] or (sPos[#sPos]-70*(i-#sPos)),
					scaleT = 0.95,
					code = function(self)
						if _PausedByTalk==1 then
							--print("ѡ����ѡ��")
							_tFunc.ClearAllSelection()
							_PausedByTalk = 2
							local __ID = self.__ID
							hApi.addTimerOnce("__TALK__AutoContinue",(nDelay or 1),function()
								_PausedByTalk = 0
								if __ID~=self.__ID then
									return
								end
								if type(tCode)=="table" then
									--�Զ����������
									if type(tCode[TalkTag])=="function" then
										_tFuncCode = tCode[TalkTag]
										xpcall(_tFuncProcessCode,hGlobal.__TRACKBACK__)
									end
									if _PausedByTalk~=1 then
										return _TalkContinue(0,0,2)
									end
								else
									--��������
									local tgrData = oTarget:gettriggerdata()
									if tgrData and tgrData.talk then
										local vTalk = hApi.InitUnitTalk(oUnit,oTarget,tgrData.talk,TalkTag)
										if vTalk then
											if _CODE_ProcessTalkCodeOnly(vTalk)==1 then
												return _TalkContinue(0,0,2)
											elseif _CODE_CreateUnitTalk(vTalk,0)==1 then
												return _TalkContinue(0,0,2)
											end
										else
											return _TalkContinue(0,0,2)
										end
									else
										return _TalkContinue(0,0,2)
									end
								end
							end)
						end
					end,
				})
				--btn.handle.s:setOpacity(100)
				--btn.handle.s:setColor(ccc3(100,200,255))
				_childUI["btnSelection_"..i] = btn
			end
			_PauseOnNextString = 1
		end
	end
	_tFunc.Keep = function(oUnit,oTarget,selectName,tTalk)
		_TF_IsContinue = 0
		_childUI["talkContinue"].handle._n:setVisible(true)
	end
	hGlobal.event:listen("Event_UnitArrive","__TF__OnUnitArrived",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
		if oWorld.data.type=="worldmap" and oWorld.data.IsPaused==1 then
			if type(_TF_TempUnitMove)=="table" and _TF_TempUnitMove[oUnit.__ID]==1 and _TF_EnableClick==0 then
				_TF_TempUnitMove[oUnit.__ID] = 0
				local MoveSus = 1
				for _,v in pairs(_TF_TempUnitMove)do
					if v==1 then
						MoveSus = 0
					end
				end
				if MoveSus==1 then
					_TF_TempUnitMove = nil
					_TF_IsContinue = 1
					_TF_EnableClick = 1
				end
			end
		end
	end)
	_tFunc.UnitMoveTo = function(oUnit,oTarget)--EFF
		_TF_IsContinue = 0
		_TF_EnableClick = 0
		if type(_TF_TempUnitMove)~="table" then
			_TF_TempUnitMove = {}
		end
		_TF_TempUnitMove[oUnit.__ID] = 1
		hApi.addTimerOnce("__TALK__UnitMove"..oUnit.ID,1,function()
			local oWorld = oUnit:getworld()
			local nWorldX, nWorldY = oTarget:getstopXY()
			local gridX,gridY = oWorld:xy2grid(nWorldX,nWorldY)
			oUnit:getowner():operate(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,oTarget,gridX,gridY)
		end)
	end
	local _SetChoosedItemByIdx = function(nSelectI)
		local oGrid = _childUI["LootGrid"]
		if oGrid~=nil then
			--��ʾ��ѡ����ߵ�UI
			local tLootData = oGrid.data.userdata
			if type(tLootData.select)=="table" then
				local tSelect = tLootData.select
				local tIndex = {}
				for i = 1,#tSelect do
					tIndex[tSelect[i]] = 1
				end
				if tIndex[nSelectI]==1 then
					--��ѡ��ʲô������
				else
					--�����ҵ�ѡ��
					tIndex[tSelect[1]] = 0
					for i = 1,#tSelect-1,1 do
						tSelect[i] = tSelect[i+1]
					end
					tIndex[nSelectI] = 1
					tSelect[#tSelect] = nSelectI
					for i = 1,#tLootData.item do
						local sImageName = "cho_"..i
						if oGrid.childUI[sImageName]==nil and tIndex[i]==1 then
							local ix,iy = oGrid:grid2xy(i-1,0)
							local tBox = tLootData.box[tLootData.item[nSelectI][1]]
							if tBox~=nil then
								ix = ix + math.floor(tBox[1]+tBox[3]/2)
								iy = iy + math.floor(tBox[2]-tBox[4]/2)
							end
							oGrid.childUI[sImageName] = hUI.image:new({
								parent = oGrid.handle._n,
								x = ix,
								y = iy,
								w = 128,
								h = 128,
								model = "MODEL_EFFECT:strengthen",
							})
						elseif oGrid.childUI[sImageName]~=nil and tIndex[i]~=1 then
							hApi.safeRemoveT(oGrid.childUI,sImageName)
						end
					end
				end
			end
		end
	end
	local _CheckHitOnLoot = function(x,y)
		local oGrid = _childUI["LootGrid"]
		if oGrid~=nil then
			hApi.PlaySound("eff_pickup")
			local tLootData = oGrid.data.userdata
			local gx,gy,idx = oGrid:xy2grid(x,y,"parent")
			if idx and idx~=0 and (tLootData.item[idx[1]] or 0)~=0 then
				local tItem = tLootData.item[idx[1]]
				local nSelectI = idx[1]
				local ox,oy = oGrid:grid2xy(gx,gy)
				local tBox = tLootData.box[tItem[1]]
				if tBox~=nil and hApi.IsInBox(x-ox-oGrid.data.x,y-oy-oGrid.data.y,tBox) then
					--it,xxxx,num
					local nSlotNum = 0
					if tItem[1]=="it" or tItem[1]=="ix" then
						nSlotNum = hApi.GetQuestRewardItemSlotNum(tItem[2])
					end
					--�鿴����
					hUI.GetUITemplate("bagitem")[2].ShowItemTip(tItem,2,nSlotNum)
				end
				_SetChoosedItemByIdx(nSelectI)
			end
		end
	end
	_tFunc.ShowLoot = function(tLoot,nSelect,codeOnConfirm)
		hUI.Disable(350,"��ʾ�����Ʒ")
		hApi.safeRemoveT(_childUI,"LootGrid")
		local sTittle
		local tMySelect
		if type(nSelect)=="number" and nSelect>0 then
			tMySelect = hApi.NumTable(nSelect)
			sTittle = string.gsub(hVar.tab_string["__TEXT_SELECT_ITEM_BY_NUM__"],"#NUM#",tostring(nSelect))
		else
			sTittle = hVar.tab_string["__TEXT_GET_ITEM__"]
		end
		local tItemList = {}
		local tLootData = {
			item = {},
			select = tMySelect,
			box = {
				it = {-32,32-2,64,64},
				tc = {-32,32-16,64,64},
			}
		}
		for i = 1,#tLoot do
			if tLoot[i][1]=="item" then
				tItemList[i] = {i}
				tLootData.item[i] = {"it",tLoot[i][2],tLoot[i][3]}
			elseif tLoot[i][1]=="battlefieldskill" then
				tItemList[i] = {i}
				tLootData.item[i] = {"tc",tLoot[i][2],tLoot[i][3]}
			else
				tLootData.item[i] = 0
				tItemList[i] = 0
			end
		end
		local gridXYWH = {_frm.data.w/2 - math.floor((#tLoot-1)*128/2),196,128,192}
		local oGrid = hUI.bagGrid:new({
			parent = _frm.handle._n,
			userdata = tLootData,
			x = gridXYWH[1],
			y = gridXYWH[2],
			gridW = gridXYWH[3],
			gridH = gridXYWH[4],
			itemW = 96,
			itemH = 96,
			grid = {hApi.NumTable(#tLoot)},
			num = 0,
			slot = 0,
			animation = -1,
			codeOnImageCreate = function(self,idx,pNode,gx,gy)
				--��һ���ǵ���
				local oItem = self.data.userdata.item[idx]
				if oItem==nil then
				elseif oItem[hVar.ITEM_DATA_INDEX.ID]=="it" then
					local tTemplate = hUI.GetUITemplate("bagitem")
					hUI.CreateMultiUIByParam(pNode,0,-2,tTemplate[1],{},tTemplate[2].GetParam(oItem))
					hUI.deleteUIObject(hUI.image:new({
						parent = pNode,
						model = "UI:item_slot_big",
						w = 116,
						h = -1,
						y = -2,
						z = -1,
					}))
					--����д�����վ����AV
					hUI.deleteUIObject(hUI.label:new({
						parent = pNode,
						text = hApi.GetItemName(oItem[hVar.ITEM_DATA_INDEX.NUM]),
						font = hVar.FONTC,
						size = 24,
						x = 0,
						y = -64,
						z = 5,
						border = 1,
						align = "MC",
					}))
				elseif oItem[hVar.ITEM_DATA_INDEX.ID]=="tc" then
					local tCard = {oItem[hVar.ITEM_DATA_INDEX.NUM],oItem[hVar.ITEM_DATA_INDEX.SLOT]}
					local tTemplate = hUI.GetUITemplate("tacticscard")
					hUI.CreateMultiUIByParam(pNode,0,-16,tTemplate[1],{},tTemplate[2].GetParam(tCard))
				end
			end,
		})
		oGrid:updateitem(tItemList)
		_childUI["LootGrid"] = oGrid
		--��ѡ��Ĭ�������Ľ���
		if type(tMySelect)=="table" then
			for i = 1,#tMySelect do
				_SetChoosedItemByIdx(i)
			end
		end
		oGrid.childUI["BG"] = hUI.bar:new({
			parent = _frm.handle._n,
			model = "UI:card_select_back",
			x = _frm.data.w/2,
			y = gridXYWH[2]-34,
			z = -200,
			w = hVar.SCREEN.w-256,
			h = 246,
		})
		oGrid.childUI["imgTittleBG"] = hUI.image:new({
			parent = _frm.handle._n,
			x = _frm.data.w/2,
			y = gridXYWH[2]+110,
			model = "misc/selectbg.png",
			w = 256,
			h = 32,
		})
		oGrid.childUI["labTittle"] = hUI.label:new({
			parent = _frm.handle._n,
			x = _frm.data.w/2,
			y = gridXYWH[2]+110,
			text = sTittle,
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			width = 600,
		})
		oGrid.childUI["btnConfirm"] = hUI.button:new({
			parent = _frm.handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w/2,
			y = gridXYWH[2]-128,
			w = 106,
			h = 38,
			model = "UI:ButtonBack2",
			scaleT = 0.95,
			label = {
				text = hVar.tab_string["__TEXT_Confirm"],
				border = 1,
				font = hVar.FONTC,
			},
			code = function()
				local nCount = 0
				if type(tMySelect)=="table" then
					for i = 1,#tMySelect do
						if tMySelect[i]==0 then
							nCount = nCount + 1
						end
					end
				end
				if nCount>0 then
					hUI.floatNumber:new({
						text = "",
						x = hVar.SCREEN.w/2+16,
						y = 480,
						font = "numRed",
						moveY = 64,
					}):addtext(hVar.tab_string["__TEXT_PleaseSelectReward"].."  ("..(#tMySelect-nCount).."/"..#tMySelect..")",hVar.FONTC,36,"MC",0,0):setColor(ccc3(255,255,255))
					return
				end
				hUI.Disable(350,"ѡ��ս��Ʒ")
				hUI.dragBox:unselect()
				hApi.PlaySound("eff_pickup")
				--����д����һ����������δ���Ҳֻ��ִ��һ��
				if type(codeOnConfirm)=="function" and type(tMySelect)=="table" then
					local code = codeOnConfirm
					codeOnConfirm = nil
					code(tMySelect)
				end
				oGrid.handle._n:runAction(CCJumpBy:create(0.25,ccp(0,-48),32,1))
				hApi.addTimerOnce("ConfirmLoot",300,function()
					hApi.safeRemoveT(_childUI,"LootGrid")
					_TalkContinue(0,0)
				end)
			end,
		})
	end
	_TalkContinue = function(x,y,IsFromClick,tSwitch)
		if _TF_EnableClick~=1 and IsFromClick==1 then
			return
		end
		if _TempTalk==nil then
			return
		end
		if _PausedByTalk~=0 then
			return _LastLogString
		end
		if tSwitch==nil then
			tSwitch = {}
			if _childUI["LootGrid"]~=nil then
				tSwitch.lootfrm = 1
			end
		end
		if tSwitch.lootfrm==1 and IsFromClick==1 then
			_CheckHitOnLoot(x,y)
			return _LastLogString
		end
		local tIndex = _TempI + 1
		local tData = _TempTalk[tIndex]
		if tData~=nil then
			_TempI = tIndex
			local v = tData
			local typ = type(v)
			if typ=="function" then
				v(_tFunc)
				if _TF_IsContinue==1 then
					return _TalkContinue(x,y,IsFromClick,tSwitch)
				end
			elseif typ=="string" then
				_TF_IsContinue = 1
				_SaveLogString()
				local IsTalkContinue = false
				for i = _TempI+1,#_TempTalk,1 do
					if type(_TempTalk[i])=="string" then
						IsTalkContinue = true
						break
					end
				end
				_childUI["talkContinue"].handle._n:setVisible(IsTalkContinue)
				if _AnalyzeTalk(v) then
					if IsFromClick==1 or IsFromClick==2 then
						hApi.safeRemoveT(_childUI,"TalkUIEx")
					end
					if _PauseOnNextString==1 then
						_PauseOnNextString = 0
						_PausedByTalk = 1
						_SaveLogString()
					end
					return _LastLogString
				else
					return _TalkContinue(x,y,IsFromClick,tSwitch)
				end
			else
				if IsFromClick==1 or IsFromClick==2 then
					hApi.safeRemoveT(_childUI,"TalkUIEx")
				end
				_TF_IsContinue = 1
				return _TalkContinue(x,y,IsFromClick,tSwitch)
			end
		else
			_SaveLogString()
			--�˳�ǰִ�еĺ���
			if type(_CodeOnExit)=="function" then
				local code = _CodeOnExit
				local tTalk = _TempTalk
				code()
				if tTalk==_TempTalk and _CodeOnExit==code then
					--���û�п�ʼ�µĶԻ��������ߵ�����
					_CodeOnExit = nil
				else
					--˵�������������µĶԻ�����������ֱ�ӷ���
					return _LastLogString
				end
			end
			--_frm:show(0,"appear")
			local _childUI = _frm.childUI
			for k,v in pairs(_childUI)do
				if string.sub(k,1,7)==_uImagePre then
					hApi.safeRemoveT(_childUI,k)
				end
			end
			_TempI = 0
			_TempTalk = nil
			_childUI["talk"]:setText("")
			_childUI["talkName"]:setText("")
			if hGlobal.BattleField~=nil and hGlobal.BattleField.ID>0 then
				--��ս��ǰ�ĶԻ������ͷ���Դ����
			else
				--������ǽ�ս���ĶԻ������ͷ���ʱ���ص�ͼƬ��Դ
				if _ImageLoadCount>0 then
					_ImageLoadCount = 0
					--����Ի�ͼƬ��Դ
					hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_UI)	--�ű�����Ի��Դ�
				end
			end
			
			_frm:show(0,0)
			--zhenkira 2015.11.10
--			local oWorld = hGlobal.LocalPlayer:getfocusworld()
--			if oWorld~=nil and oWorld==hGlobal.WORLD.LastWorldMap then
--				local focus_unit = hGlobal.LocalPlayer:getfocusunit("worldmap")
--				if focus_unit then
--					local focus_cha = focus_unit.handle._c
--					if oWorld.worldUI["GUIDE_UI"]==nil then
--						local x, y = xlCha_GetPos(focus_cha)
--						hApi.setViewNodeFocus(x, y)
--					end
--					xlSetFocusCha(focus_cha)
--					local ret = xlCha_ShowPath(focus_cha, 1) --������ʾ·��, �ڲ�������Ѱ·ˢ�¼�ͷ��ʾ
--					xlLG("game", "ˢ��focus unit��ͷ��ʾ, Focus Cha [type:%d] Show Path\n", xlCha_GetType(focus_cha))
--				else
--					for i = 1 ,#hGlobal.LocalPlayer.data.ownTown do
--						TownUnit = hApi.GetObjectUnit(hGlobal.LocalPlayer.data.ownTown[i])
--						--ֻ���Լ������ǲ����ж�
--						if TownUnit and TownUnit.data.owner == 1 then
--							local focus_cha = TownUnit.handle._c
--							if oWorld.worldUI["GUIDE_UI"]==nil then
--								local x, y = xlCha_GetPos(focus_cha)
--								hApi.setViewNodeFocus(x, y)
--							end
--							xlSetFocusCha(focus_cha)
--						end
--					end
--				end
--			end
		end
		return _LastLogString
	end

	local _AnalyzeIcon = function(t)
		local side,pos,id = 0,1,1
		if t then
			side = string.sub(t,1,1)
			local len = string.len(t)
			local s = string.find(t,":")
			if s then
				id = string.sub(t,s+1,len) or 0
				pos = tonumber(string.sub(t,2,s-1) or 0)
			else
				pos = tonumber(string.sub(t,2,len) or 0)
			end
		end
		return side,pos,id
	end

	local _HighLightIcon = function(side,pos)
		local iName = _uImagePre..side..pos
		local iNameEx = _uImagePre..side
		local len = string.len(_uImagePre)
		local lenEx = string.len(iNameEx)
		for k,v in pairs(_childUI)do
			if string.sub(k,1,lenEx)==iNameEx then
				local s = v.handle._n
				if k==iName then
					s:getParent():reorderChild(s,1)
					s:setColor(ccc3(255,255,255))
				else
					s:getParent():reorderChild(s,0)
					s:setColor(ccc3(180,180,180))
				end
			elseif string.sub(k,1,len)==_uImagePre then
				local s = v.handle._n
				s:setColor(ccc3(180,180,180))
			end
		end
	end

	local _ActiveIcon = function(side,pos,id)
		local posT = _HeadIconPos[side]
		if posT~=nil then
			local iName = _uImagePre..side..pos
			local posXY = posT[pos] or posT[#posT]
			id = _TempId[id] or id or 1
			if id>0 then
				_childUI["talkName"]:setText((hVar.tab_stringU[id][1] or hVar.tab_string["__UNKNOWN__"]))
				if _childUI[iName]~=nil and _childUI[iName].data.child~=id then
					hApi.safeRemoveT(_childUI,iName)
				end
				if _childUI[iName]==nil then
					local x,y
					local posOfPortrait,posOfModel,facing,move,align = unpack(posXY)
					if hVar.tab_unit[id] and hVar.tab_unit[id].portrait then
						--���û������ͼ������Ϊ��ģ��ֻ��model
						--ʹ����ȫ��ͬ���������
						x,y = unpack(posOfPortrait)
						if hVar.tab_unit[id].portraitflip==1 then
							facing = facing + 180
						end
					else
						x,y = unpack(posOfModel)
					end
					if facing>=360 then
						facing = facing - 360
					end
					_childUI[iName] = hUI.thumbImage:new({
						mode = "portrait",
						parent = _frm.handle._in,
						id = id,
						facing = facing,
						x = x - move,
						y = y,
						align = align,
						w = 256,
						h = 256,
						child = id,
						IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_UI,
					})
					if facing==0 and _childUI[iName].data.mode=="portrait" then
						_childUI[iName].handle.s:setFlipX(true)
					end
					_HighLightIcon(side,pos)
					if move~=0 then
						_childUI[iName].handle._n:runAction(CCMoveBy:create(0.15*math.abs(move/400),ccp(move,0)))
					end
				else
					_HighLightIcon(side,pos)
					--_childUI[iName].handle._n:runAction(CCJumpBy:create(0.15,ccp(0,0),10,1))
				end
			else
				hApi.safeRemoveT(_childUI,iName)
				_childUI["talkName"]:setText("")
			end
		end
	end


	--@[L|R][num|n/a]:[id]@balabala...
	_AnalyzeTalk = function(text)
		local s,e = string.find(text,"@(.-)@")
		local iconInfo
		if s==1 and e>=4 then
			local side,pos,id = _AnalyzeIcon(string.sub(text,s+1,e-1))
			if side=="L" or side=="R" then
				if type(id)=="string" then
					local vid = tonumber(id)
					if tostring(vid)==id then
						id = vid
					end
				end
				if type(id)=="number" then
					_ImageLoadCount = _ImageLoadCount + 1
					_ActiveIcon(side,pos,id)
				elseif type(id)=="string" then
					_HighLightIcon(side,pos)
					_frm.childUI["talkName"]:setText(id)
				end
			end
			text = string.sub(text,e+1)
			if text=="" then
				return false
			end
		end
		if type(text)=="string" then
			_frm.childUI["talk"]:setText(text)
			return true
		else
			return false
		end
	end
end