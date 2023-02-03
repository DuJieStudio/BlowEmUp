--------------------------------
-- 战场UI(Iphone)
--------------------------------
--操作条功能函数
local __CODE__InitSkillOprFunc = function(tOptionList)
	local tFunc = {}
	local _tBtnXY2I = {}
	local _tOptionKey = {}
	local _GetBtnName = function(oGrid,gx,gy,nSkillId)
		return _tBtnXY2I[gx.."|"..gy] or 0
	end
	for i = 1,#tOptionList do
		if tOptionList[i][2]==0 then
			_tOptionKey[#_tOptionKey+1] = tOptionList[i][1]
		end
	end
	local __TAB__tOptionCode = {
		["codeOpr"] = {
			code = function(self,nSkillId)
				local oUnit = hApi.BF_GetOprUnit()
				if oUnit and (nSkillId==hVar.GUARD_SKILL_ID or nSkillId==hVar.WAIT_SKILL_ID) then
					local oWorld = oUnit:getworld()
					if oWorld then
						local AIPlayer = oUnit:getowner()
						if oUnit.attr.stun>0 then
							return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
						elseif nSkillId==hVar.GUARD_SKILL_ID then
							hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,hVar.GUARD_SKILL_ID,nil)
							hApi.BF_ConfirmSkillOpr(nil,nSkillId)
							return hApi.BF_ConfirmSkillOpr(nil,nSkillId)
						elseif nSkillId==hVar.WAIT_SKILL_ID then
							return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_WAIT,oUnit,hVar.ZERO,nil,oUnit.data.gridX,oUnit.data.gridY)
						end
					end
				end
			end,
		},
		["btnOption"] = {
			code = function(self)
				local frm = hGlobal.UI.BF_OptionPanel
				local IsShow = -1
				for i = 1,#_tOptionKey do
					if frm.childUI[_tOptionKey[i]].data.state==-1 then
						IsShow = 1
						break
					end
				end
				tFunc.ShowOptionBtn(IsShow)
			end,
		},
		["btnOprPanel"] = {
			code = function(self)
				if hGlobal.UI.BF_OperatePanel.data.show==0 then
					self:setstate(-1)
					hGlobal.UI.BF_OperatePanel:show(1,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
				else
					hGlobal.UI.BF_OperatePanel:show(0,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
				end
			end,
		},
		["btnSurrender"] = {
			code = function()
				local oWorld = hGlobal.LocalPlayer:getfocusworld()
				if not(oWorld and oWorld.data.type=="battlefield") then
					return
				end
				tFunc.ShowOptionBtn(0)
				return hApi.BFSurrender(oWorld)
			end,
		},
		["btnGrid"] = {
			code = function(oBtn)
				local oWorld = hGlobal.LocalPlayer:getfocusworld()
				if not(oWorld and oWorld.data.type=="battlefield") then
					return
				end
				if hVar.OPTIONS.IS_DRAW_GRID==1 then
					hVar.OPTIONS.IS_DRAW_GRID = 0
					oBtn.handle.s:setColor(ccc3(255,255,255))
				else
					hVar.OPTIONS.IS_DRAW_GRID = 1
					oBtn.handle.s:setColor(ccc3(100,255,0))
				end
				hApi.SaveGameOptions()
				return hApi.DrawMoveGrid()
			end,
			setColor = function(oBtn)
				if hVar.OPTIONS.IS_DRAW_GRID==1 then
					oBtn.handle.s:setColor(ccc3(100,255,0))
				else
					oBtn.handle.s:setColor(ccc3(255,255,255))
				end
			end,
		},
		["btnActionList"] = {
			code = function()
				tFunc.ShowOptionBtn(0)
				hGlobal.event:event("LocalEvent_BFShowUnitActionList")
				hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","hide",nil,nil,0)
			end,
		},
	}
	tFunc.GetOptionCode = function(sCodeName,ex)
		if (ex or 0)~=0 then
			return __TAB__tOptionCode[sCodeName][ex]
		else
			return __TAB__tOptionCode[sCodeName].code
		end
	end
	tFunc.UpdateOprUnitSkill = function(oUnit)	--空函数
	end
	tFunc.UpdateGridUI = function(oUnit,tSkill,tGridDetail)
		_tBtnXY2I = {}
		local frm = hGlobal.UI.BF_OperatePanel
		hApi.safeRemoveT(frm.childUI,"SkillGrid")
		frm.childUI["dragBox"]:sortbutton()
		if oUnit~=nil then
			local nAttackId = hApi.GetDefaultSkill(oUnit)
			local oBtnDefault
			local oGrid = hUI.grid:new({
				parent = frm.handle._n,
				x = tGridDetail[1],
				y = tGridDetail[2],
				iconW = tGridDetail[3],
				iconH = tGridDetail[4],
				gridW = tGridDetail[5],
				gridH = tGridDetail[6],
				smartWH = 1,
				mode = "button",
				animation = function(id,model,gx,gy)
					return hUI.GetItemSkillAnimation(id)
				end,
				--spreadFrom = {0,0,250},
				grid = tSkill,
				--dragbox = frm.childUI["dragBox"],
				code = function(nSkillId,oBtn)
					--防御和等待按钮特殊处理
					return tFunc.GetOptionCode("codeOpr")(oBtn,nSkillId)
				end,
				codeOnButtonCreate = function(self,nSkillId,oBtn,gx,gy)
					--防御和等待按钮特殊处理
					if nSkillId==hVar.GUARD_SKILL_ID then
						frm.childUI["dragBox"]:addbutton(oBtn,self.data.x,self.data.y)
					elseif nSkillId==hVar.WAIT_SKILL_ID then
						frm.childUI["dragBox"]:addbutton(oBtn,self.data.x,self.data.y)
					else
						local btnName = "btn_"..self.data.buttonNum
						_tBtnXY2I[gx.."|"..gy] = btnName
						tFunc.UpdateBtnUI(oUnit,nSkillId,oBtn)
						if oBtn.data.userdata>0 then
							if nSkillId==nAttackId and oBtnDefault==nil then
								oBtnDefault = oBtn
							end
						end
					end
				end,
			})
			frm.childUI["SkillGrid"] = oGrid
			if oBtnDefault~=nil then
				tFunc.ChooseOprBtn(oGrid,oBtnDefault)
			end
		end
	end
	tFunc.UpdateBtnUI = function(oUnit,nSkillId,oBtn)
		local tabS = hVar.tab_skill[nSkillId]
		if tabS then
			local CanNotCast = 0
			local nCastCount = -1
			local nCastLimit = -1
			local nManaCost = tabS.manacost or 0
			if nManaCost>0 then
				--耗魔技能
				if oUnit.attr.mp>=tabS.manacost then
					--可以使用几次 
					nCastCount = math.floor(oUnit.attr.mp/nManaCost)
				else
					nCastCount = 0
				end
			end
			local sData = oUnit:getskill(nSkillId)
			local nCooldown = 0
			if sData then
				nCooldown = sData[3]
				if sData[4]==0 then
					--无限制使用的技能
				elseif sData[4]>0 then
					nCastLimit = sData[4]
				else
					nCastLimit = 0
				end
			end
			if nCastLimit==0 then
				CanNotCast = 1
			elseif nCooldown>0 then
				CanNotCast = 2
			elseif nCastCount==0 then
				CanNotCast = 3
			elseif oUnit.attr.stun>0 then
				CanNotCast = 4
			elseif hApi.IsSkillDisabled(oUnit,id)==1 then
				CanNotCast = 5
			end
			hApi.safeRemoveT(oBtn.childUI,"cooldown")
			hApi.safeRemoveT(oBtn.childUI,"label")
			if nCooldown>0 then
				oBtn.childUI["cooldown"] = hUI.label:new({
					parent = oBtn.handle._n,
					text = tostring(nCooldown),
					font = "numGreen",
					size = math.floor(oBtn.data.w*0.75),
					align = "MC",
				})
			end
			if nCastLimit>=0 then
				if nCastLimit>0 then
					local size = math.floor(oBtn.data.w/3)
					oBtn.childUI["castcount"] = hUI.label:new({
						parent = oBtn.handle._n,
						text = nCastLimit,
						x = math.floor(size*1.3),
						y = -1*math.floor(size*1.5),
						font = "numRed",
						size = size,
						align = "RB",
					})
				end
			elseif nCastCount>=0 then
				if nCastCount>0 then
					local size = math.floor(oBtn.data.w/3)
					oBtn.childUI["castcount"] = hUI.label:new({
						parent = oBtn.handle._n,
						text = nCastCount,
						x = math.floor(size*1.3),
						y = -1*math.floor(size*1.5),
						font = "numBlue",
						size = size,
						align = "RB",
					})
				end
			end
			if CanNotCast~=0 then
				oBtn.data.userdata = -1*CanNotCast
				oBtn.handle.s:setColor(ccc3(128,128,128))
			else
				oBtn.data.userdata = nSkillId
			end
			return CanCast
		end
	end
	tFunc.ShowOptionBtn = function(IsShow)
		local frm = hGlobal.UI.BF_OptionPanel
		if IsShow==1 then
			for i = 1,#_tOptionKey do
				if frm.childUI[_tOptionKey[i]] then
					frm.childUI[_tOptionKey[i]]:setstate(1)
				end
			end
		else
			for i = 1,#_tOptionKey do
				if frm.childUI[_tOptionKey[i]] then
					frm.childUI[_tOptionKey[i]]:setstate(-1)
				end
			end
		end
	end
	tFunc.ChooseOprBtn = function(oGrid,oBtn)
		local NeedAddHint = 1
		if oBtn.data.userdata<0 then
			print("不能施展此技能,"..(-1*oBtn.data.userdata))
			return 0
		end
		for i = 1,oGrid.data.buttonNum do
			local oBtnCur = oGrid.childUI["btn_"..i]
			if oBtnCur and oBtnCur.childUI["HintChoosed"] then
				if oBtn==oBtnCur then
					NeedAddHint = 0
					return 2
				end
			end
		end
		if NeedAddHint==1 then
			for i = 1,oGrid.data.buttonNum do
				local oBtnCur = oGrid.childUI["btn_"..i]
				if oBtnCur then
					hApi.safeRemoveT(oBtnCur.childUI,"HintChoosed")
					if oBtn==oBtnCur then
						oBtnCur.childUI["HintChoosed"] = hUI.image:new({
							parent = oBtnCur.handle._n,
							model = "UI:BTN_SkillSelector",
							w = oBtnCur.data.w,
							h = oBtnCur.data.h,
						})
					end
				end
			end
		end
		return 1
	end
	tFunc.DisableOprBtn = function()
		local oGrid = hGlobal.UI.BF_OperatePanel.childUI["SkillGrid"]
		if oGrid then
			for i = 1,oGrid.data.buttonNum do
				local oBtn = oGrid.childUI["btn_"..i]
				if oBtn then
					oBtn:setstate(0)
				end
			end
		end
	end
	tFunc.GetOprData = function(x,y)
		local oGrid = hGlobal.UI.BF_OperatePanel.childUI["SkillGrid"]
		local oUnit = hApi.BF_GetOprUnit()
		if oGrid and oUnit and oUnit.data.IsDead~=1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
			local gx,gy,nSkillId = oGrid:xy2grid(x,y,"parent")
			if nSkillId and nSkillId~=0 and hVar.tab_skill[nSkillId] and nSkillId~=hVar.GUARD_SKILL_ID and nSkillId~=hVar.WAIT_SKILL_ID then
				local oBtn = oGrid.childUI[_GetBtnName(oGrid,gx,gy,nSkillId)]
				if oBtn then
					local oWorld = oUnit:getworld()
					if oWorld then
						local oRound = oWorld:getround()
						if oRound and oRound.data.auto==0 and oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)==oUnit then
							return nSkillId,oUnit,oWorld,oGrid,oBtn
						end
					end
				end
			end
		end
	end
	tFunc.InitOptionUI = function(tOption)
		local tChild = {}
		for i = 1,#tOption do
			local v = tOption[i]
			local btnCode = {}
			if __TAB__tOptionCode[v[1]] then
				btnCode = __TAB__tOptionCode[v[1]]
			end
			tChild[#tChild+1] = {
				__UI = "button",
				__NAME = v[1],
				x = v[3][1],
				y = v[3][2],
				w = v[3][3],
				h = v[3][4],
				sizeW = v[3][5],
				sizeH = v[3][6],
				scaleT = 0.8,
				model = v[4][1],
				animation = v[4][2],
				code = btnCode.code,
				codeOnTouch = btnCode.codeOnTouch,
				codeOnDrag = btnCode.codeOnDrag,
			}
		end
		return tChild
	end
	return tFunc
end

--------------------------------
-- 战场动作条(Iphone5)
hGlobal.UI.InitBattlefieldActionList_IP5 = function()
	local _tFrmPos
	if g_phone_mode==2 then
		--IP5
	else
		return
	end
	local _tFrmPos = {160,628,710,90}
	if g_phone_mode==1 then
		_tFrmPos = {120,628,710,90}
	elseif g_phone_mode==2 then
		_tFrmPos = {160,628,710,90}
	end
	
	local _BF_TempUnit = {}
	local _gridX,_gridY = 48,-42
	local _gridW,_gridH,_iconW,_iconH = 77,77,74,74
	local _cardNum = 9
	local _slot = {}
	for i = 1,_cardNum do
		_slot[i] = 0
	end
	local _FrmDragStartY = 0
	local _FrmDragLastY = 0
	local _FrmIsShow = hVar.OPTIONS.IS_SHOW_ACTION_LIST
	local _frm,_grid
	local _oPlayerJustice		--正义的玩家!
	local _ListMoveY = {
		limit = {0,100,180},
		state = {{-9999,1},{40,1},{9999,0}},
	}
	hGlobal.UI.UnitActionList = hUI.frame:new({
		x = _tFrmPos[1],
		y = _tFrmPos[2],
		w = _tFrmPos[3],
		h = _tFrmPos[4],
		titlebar = 0,
		autoactive = 0,
		dragable = 2,
		buttononly = 1,
		background = -1,
		--background = "MODEL:Default",
		show = 0,
		child = {
			{
				__UI = "button",
				__NAME = "btnControl",
				mode = "imageButton",
				x = 0,
				y = 30,
				w = 710,
				h = 130,
				model = -1,
				align = "LT",
				failcall = 1,
				codeOnTouch = function(self,x,y)
					local cx,cy = _frm.handle._n:getPosition()
					if _FrmIsShow==0 then
						_IsFirstTouch = 1
						local tLimit = _ListMoveY.limit
						local curY = math.min(tLimit[2],math.max(tLimit[1],y+10))
						local tx,ty = _frm.data.x,_frm.data.y
						if tLimit[3]<tLimit[1] then
							--藏在了下面
							_FrmDragStartY = curY - 10
						else
							--藏在了上面
							_FrmDragStartY = curY + 10 - _iconH
						end
						local vy = y - _FrmDragStartY
						if vy<=tLimit[1] then
							vy = tLimit[1]
						elseif y>=tLimit[2] then
							vy = tLimit[2]
						else
							vy = y - _FrmDragStartY
						end
						_frm.handle._n:stopAllActions()
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty+vy)))
					else
						_FrmDragStartY = y
						if _grid then
							local index = _grid:xy2grid(x,y,"ex")
							if index then
								local tX = _frm.childUI["cardList"].card[index+1]
								if tX and tX[2] and tX[2].ID~=0 and hClass.unit:find(tX[2].ID)==tX[2] then
									return hGlobal.event:event("LocalEvent_TouchOnActionList",tX[2],tX[3])
								elseif tX then
									return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,tX[3])
								else
									return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,0)
								end
							end
						end
					end
				end,
				code = function(self,x,y,sus)
					local tLimit = _ListMoveY.limit
					local tState = _ListMoveY.state
					local curY = y-_FrmDragStartY
					local nShowFlag = 0
					for i = 1,#tState do
						nShowFlag = tState[i][2]
						if curY<=tState[i][1] then
							break
						end
					end
					local cx,cy = _frm.handle._n:getPosition()
					if nShowFlag==1 then
						_FrmIsShow = 1
						local tx,ty = _frm.data.x,_frm.data.y
						_frm.handle._n:stopAllActions()
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty)))
						return hGlobal.event:event("LocalEvent_UpdateActionList")
					else
						_FrmIsShow = 0
						local tx,ty = _frm.data.x,_frm.data.y+tLimit[3]
						_frm.handle._n:stopAllActions()
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty)))
						return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,-1)
					end
				end,
				codeOnDrag = function(self,x,y)
					local vy = y-_FrmDragStartY
					local tLimit = _ListMoveY.limit
					if vy>=tLimit[1] and vy<=tLimit[2] then
						_frm.handle._n:setPosition(_frm.data.x,_frm.data.y+vy)
					end
				end,
			},
			{
				__UI = "grid",
				__NAME = "slot",
				--mode = "batchImage",
				animation = "lightSlim",
				gridW = _gridW,
				gridH = _gridH,
				iconH = _iconH,
				x = _gridX,
				y = _gridY,
				grid = _slot,
			},
		},
	})
	_grid = hGlobal.UI.UnitActionList.childUI["slot"]
	_frm = hGlobal.UI.UnitActionList
	--_frm.childUI["btnControl"].handle.s:setVisible(false)
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _InitInsertTab = function(v)
		local u = v[_UNIT]
		if u.data.id=="round" then
			return {v[_UNIQUE],v[_ROUND],u}
		else
			return {v[_UNIQUE],v[_ROUND],u}--{u.ID,u.data.id,u.data.owner,u.attr.stack}}
		end
	end
	_frm.childUI["dragBox"].data.autoactive = 0
	_frm.childUI["cardList"] = hUI.cardList:new({
		grid = hGlobal.UI.UnitActionList.childUI["slot"],
		movetime = 300,
		cardNum = 9,
		cardMax = (_cardNum+1)*2,
		offsetX = {0,0,0,  0,-1*_grid.data.x, 22},
		offsetY = {0,0,0,  0,            -10,-26},
		define =  {0,0,0,"o","s","o",},--"o"},
		insert = function(self,index,_,style,tInsert)
			local nUnique,nRoundCount,oUnit = tInsert[1],tInsert[2],tInsert[3]
			local oImg,pSlot,oLabel = hGlobal.BFOprUIFunc.AddUIForActionList(tInsert,_frm,_grid,index-1,0)
			self:remove(index)
			hUI.cardList.insert(self,index,{[0] = nUnique,0,oUnit,nRoundCount,oImg,pSlot,oLabel},style)
		end,
	})

	---------------------------------
	-- 玩家离开了战场
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","HideUI_All",function(oPlayer)
		if oPlayer==hGlobal.LocalPlayer then
			--出战场移除布置界面
			hGlobal.O:del("BF_Frame_PlaceStep")
			hGlobal.UI.UnitActionList.childUI["cardList"]:remove("all")
			hGlobal.UI.UnitActionList:show(0)
			hApi.clearTimer("__BF__UnitList_Update_AfterRemove")
			hApi.clearTimer("__BF__UnitList_Update_AfterRemoveEx")
		end
	end)

	local _cardUI = hGlobal.UI.UnitActionList.childUI["cardList"]
	---------------------------------
	-- 战场开始，创建行动队列
	hGlobal.event:listen("LocalEvent_UnitListCreated","__BF__UnitList_Show",function(oWorld,oRound)
		for i = -1,hVar.MAX_PLAYER_NUM,1 do
			if oWorld.data.lords[i] and hGlobal.player[i] then
				if hGlobal.player[i]==hGlobal.LocalPlayer then
					_oPlayerJustice = hGlobal.LocalPlayer
				elseif _oPlayerJustice==nil then
					_oPlayerJustice = hGlobal.player[i]
				end
			end
		end
		--创建一遍行动力条子上的单位
		local list = oRound.list
		_frm:show(1)
		_cardUI:remove("all")
		for i = 1,#list do
			if i>_cardUI.data.cardNum then
				return
			end
			_cardUI:insert(i,nil,nil,_InitInsertTab(list[i]))
		end
		if _FrmIsShow~=1 then
			_frm.handle._n:setPosition(_frm.data.x,_frm.data.y+_ListMoveY.limit[3])
		else
			_frm.handle._n:setPosition(_frm.data.x,_frm.data.y)
		end
	end)

	---------------------------------
	-- 任意单位激活时刷新行动队列中生物的数量
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__UnitList_NumChange",function(oWorld,oRound,oUnit)
		if oWorld.data.type=="battlefield" then
			local card = _cardUI.card
			for i = 1,#card do
				--第2个是单位，第5个是number
				local v = card[i]
				if v and v[_cUNIT] and v[_cUNIT].ID~=0 then
					v[6]:setText(v[2].attr.stack)
					--v[7].childUI["valbar"]:setV(v[2].attr.hp,v[2].attr.mxhp)
				end
			end
		end
	end)

	local _CreateTempList = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local TempList = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				TempList[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				local c = TempList[uKey]
				if c==nil then
					c = {}
					TempList[uKey] = c
				end
				c[#c+1] = i
			end
		end
		return TempList
	end

	local _CreateListIndex = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local tIndex = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				tIndex[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				if tIndex[uKey]==nil then
					tIndex[uKey] = {}
				end
				tIndex[uKey][#tIndex[uKey]+1] = i
			end
		end
		return tIndex
	end

	local _CountCardNum = function()
		local nNum,nLast = 0,0
		for i = 1,_cardUI.data.cardMax do
			if _cardUI.card[i] then
				nNum = nNum + 1
				nLast = i
			end
		end
		return nNum,nLast
	end

	---------------------------------
	-- 行动队列产生了变更
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _LastActiveTick = 0
	local _LoadActionList = function(oWorld,oRound)
		local tUnitListIndex = _CreateListIndex(oRound.list,#oRound.list,_UNIQUE,_UNIT,_ROUND)
		local tCardListIndex = _CreateListIndex(_cardUI.card,_cardUI.data.cardMax,_cUNIQUE,_cUNIT,_cROUND)
		local tCardRemove = {n=0}
		local tCardShift = {n=0}
		local tCardInsert = {n=0}
		for i = 1,_cardUI.data.cardMax do
			tCardInsert[i] = 0
			tCardRemove[i] = 0
			tCardShift[i] = 0
		end

		--判断是否需要移除单位
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if v~=nil and tUnitListIndex[v[_cUNIQUE]]==nil then
				tCardRemove.n = tCardRemove.n + 1
				tCardRemove[i] = 1
			end
		end

		--判断是否第一个单位进行了等待
		if tCardRemove[1]==1 and _cardUI.card[1][_cUNIT].ID~=0 then
			local v = _cardUI.card[1]
			local uKey = v[_cUNIT].ID.."_"..v[_cROUND]
			local o = tCardListIndex[uKey]
			if type(o)=="table" and #o>1 then
				--首先判断这个单位是否移动到了本轮行动的后面
				for i = 1,#o do
					local n = o[i]
					local v = oRound.list[n]
					local c = _cardUI.card[1]
					if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
						o[i] = 0
						tCardRemove[1] = 0
						tCardRemove.n = tCardRemove.n - 1
						tCardListIndex[c[_cUNIQUE]] = nil
						c[_cUNIQUE] = v[_UNIQUE]
						tCardListIndex[c[_cUNIQUE]] = 1
						break
					end
				end
			end
		end

		--判断是否需要进行交换位置
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if tCardRemove[i]~=0 then
				--如果需要移除此卡片，那么不管它
			elseif v~=nil then
				local n = tUnitListIndex[v[_cUNIQUE]]
				if n==nil then
					--这是咋回事？不是判断过移除了么
					tCardRemove[i] = 1
				else
					if n~=i then
						--移动到指定位置
						tCardShift.n = tCardShift.n + 1
						tCardShift[i] = n
					end
				end
			end
		end

		--判断是否需要插入卡片
		for i = 1,_cardUI.data.cardNum do
			local v = oRound.list[i]
			if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
				tCardInsert.n = tCardInsert.n + 1
				tCardInsert[i] = _InitInsertTab(v)
			end
		end

		if tCardRemove.n>0 or tCardShift.n>0 or tCardInsert.n>0 then
			--判断是否可以移除第一个单位
			if tCardRemove[1]~=0 then
				_cardUI:remove(1,"fadeX")
				tCardRemove.n = tCardRemove.n - 1
			end
			hApi.addTimerForever("__BF__UnitList_Update",hVar.TIMER_MODE.GAMETIME,300,function()
				if tCardRemove.n>0 then
					tCardRemove.n = 0
					local NeedWait = 0
					for i = 1,_cardUI.data.cardMax do
						local v = _cardUI.card[i]
						if v~=nil then
							if tCardRemove[i]==1 then
								_cardUI:remove(i,"dead")
								NeedWait = 1
							end
						end
					end
					--移除任何单位后，等待300ms
					if NeedWait>0 then
						return
					end
				end
				if tCardShift.n>0 then
					tCardShift.n = 0
					local _,nCardLastOld = _CountCardNum()
					local NeedWait = 0
					local CardTemp = {}
					--移动现有的卡片
					for i = 1,_cardUI.data.cardMax do
						if tCardShift[i]~=0 and tCardShift[i]~=i then
							CardTemp[tCardShift[i]] = _cardUI.card[i]
							_cardUI.card[i] = nil
						end
					end
					for i = 1,_cardUI.data.cardMax do
						if CardTemp[i]~=nil then
							if _cardUI.card[i]~=nil then
								--奇怪，出错了才会走到这里
								_cardUI:remove(i,"fade")
							end
							_cardUI.card[i] = CardTemp[i]
							NeedWait = 1
						end
					end
					--顺带判断一下是否有新的卡片加入
					--跟在队伍后面的视为特殊加入
					if tCardInsert.n>0 and nCardLastOld>0 then
						local _,nLast = _CountCardNum()
						for i = nLast+1,_cardUI.data.cardNum,1 do
							if tCardInsert[i]~=0 then
								local v = tCardInsert[i]
								tCardInsert[i] = 0
								tCardInsert.n = tCardInsert.n - 1
								local nInsertIndex = nCardLastOld + (i-nLast)
								_cardUI:insert(nInsertIndex,nil,"fade",v)
								if _cardUI.card[i]~=nil then
									--奇怪，出错了才会走到这里
									_cardUI:remove(i,"fade")
								end
								_cardUI.card[i] = _cardUI.card[nInsertIndex]
								_cardUI.card[nInsertIndex] = nil
							end
						end
					end
					_cardUI:sort("setXY")
					for i = _cardUI.data.cardNum+1,_cardUI.data.cardMax,1 do
						if _cardUI.card[i]~=nil then
							_cardUI:remove(i,"fade")
							NeedWait = 1
						end
					end
					if NeedWait==1 then
						return
					end
				end
				if tCardInsert.n>0 then
					for i = 1,_cardUI.data.cardNum do
						if tCardInsert[i]~=0 and _cardUI.card[i]==nil then
							if i==1 then
								_cardUI:insert(i,nil,nil,tCardInsert[i])
							else
								_cardUI:insert(i,nil,"insert",tCardInsert[i])
							end
						end
					end
				end
				hApi.clearTimer("__BF__UnitList_Update")
			end)
		end
	end
	hGlobal.event:listen("LocalEvent_RoundChanged","__BF__UnitList_Update",function(oWorld,oRound)
		if _frm.data.show==0 or _FrmIsShow==0 then
			return
		end
		_LoadActionList(oWorld,oRound)
	end)

	hGlobal.event:listen("LocalEvent_UpdateActionList","__BF__UpdateActionList",function()
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.data.type=="battlefield" and oWorld:getround() then
			_LoadActionList(oWorld,oWorld:getround())
		end
	end)
end

-----------------------------------------------------------
--战场操作UI(Iphone5)
hGlobal.UI.InitBattlefieldOperateUI_IP5 = function()
	if g_phone_mode==2 then
		--IP5
	else
		return
	end
	local _BF_DefaultViewPos = nil
	local _OPR_BtnWH = 82
	local _OPR_GridShow = 6
	local _OPR_GridWH = math.floor(hVar.SCREEN.h/_OPR_GridShow)
	local _OPR_GridXYWH = {56,-56,110,_OPR_GridWH}
	local _OPR_PanelPosX = hVar.SCREEN.w-112
	local _OPR_PanelBG = 1
	local _OPR_OptionBtn = {
		{"btnOption",1,{40,hVar.SCREEN.h-40,140,110,64,64},{"ui/set.png"}},
		{"btnGrid",0,{hVar.SCREEN.w/2-72,hVar.SCREEN.h/2,96,96},{"UI:BTN_ControlButton","grid"}},
		{"btnSurrender",0,{hVar.SCREEN.w/2+72,hVar.SCREEN.h/2,96,96},{"UI:BTN_ControlButton","surrender"}},
	}
	local _OPR_LastHitTick = 0
	local _OPR_LastReleaseTick = 0
	local _OPR_EnableOpr = 0
	local _BF_LastOprUnit = {}
	local _BF_LastOprWorld = {}
	local tFunc = __CODE__InitSkillOprFunc(_OPR_OptionBtn)
	tFunc.UpdateOprUnitSkill = function(oUnit)
		print("UpdateOprUnitSkill", 1)
		local frm = hGlobal.UI.BF_OperatePanel
		local tSkill = {}
		tSkill[#tSkill+1] = {hVar.GUARD_SKILL_ID}
		--允许尚未等待过的单位发动等待行为
		local oWorld = oUnit:getworld()
		if oWorld then
			local oRound = oWorld:getround()
			if oRound then
				local oUnitCur = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
				local nActivityEx = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx)
				if oUnitCur==oUnit and (nActivityEx or 0)>-5000 then
					tSkill[#tSkill+1] = {hVar.WAIT_SKILL_ID}
				end
			end
		end
		local nAttackId = hApi.GetDefaultSkill(oUnit)
		if nAttackId~=0 then
			tSkill[#tSkill+1] = {nAttackId}
		end
		oUnit:enumskill(function(sData)
			local id,lv,cd,count = unpack(sData)
			local tabS = hVar.tab_skill[id]
			if tabS and id>0 and count>=0 and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT) then
				tSkill[#tSkill+1] = {id}
			end
		end)
		if #tSkill==0 then
			tSkill[#tSkill+1] = {hVar.MOVE_SKILL_ID}
		end
		local moveH = math.max(0,#tSkill*_OPR_GridWH-hVar.SCREEN.h)
		frm:setXY(_OPR_PanelPosX,hVar.SCREEN.h,nil,{0,20+moveH,0,moveH+20})
		tFunc.UpdateGridUI(oUnit,tSkill,{_OPR_GridXYWH[1],_OPR_GridXYWH[2],_OPR_BtnWH,_OPR_BtnWH,_OPR_GridXYWH[3],_OPR_GridXYWH[4]})
	end
	local tChild = tFunc.InitOptionUI(_OPR_OptionBtn)
	hGlobal.UI.BF_OperatePanel = hUI.frame:new({
		x = _OPR_PanelPosX,
		y = hVar.SCREEN.h,
		z = -1,
		w = 280,
		h = 4096,
		dragable = {0,0,0,0},
		autoalign = {"V","SkillGrid",60,0,0},
		autoactive = 0,
		closebtn = 0,
		background = _OPR_PanelBG,
		border = 0,
		show = 0,
		codeOnTouch = function(self,x,y)
			local d = self.data
			if _OPR_EnableOpr==0 then
				_OPR_LastHitTick = 0
			else
				_OPR_LastHitTick = hApi.gametime()
				if _OPR_LastReleaseTick==0 then
					_OPR_LastReleaseTick = 1
				end
				local nLastReleaseTick = _OPR_LastReleaseTick
				local nSkillId,_,_,_,oBtn = tFunc.GetOprData(x,y)
				if nSkillId and hVar.tab_stringS[nSkillId]~=nil and hVar.tab_stringS[nSkillId][1] then
					local oldY = d.y
					hApi.addTimerOnce("__BF__ShowSkillHint",600,function()
						if _OPR_LastReleaseTick==nLastReleaseTick and self.handle._n~=nil then
							local ox,oy,tx,ty = hUI.dragBox:currentXY()
							if ox==nil then
								return
							elseif (ox-tx+self.data.x)^2+(oy-ty+self.data.y)^2>1024 then
								return
							end
							local curX,curY = self.handle._n:getPosition()
							if math.abs(curY-oldY)<60 then
								local oUnit = hApi.BF_GetOprUnit()
								if oUnit then
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram",oUnit.data.id,nSkillId,150,600)
								end
							end
						end
					end)
				end
			end
		end,
		codeOnDrop = function(self,x,y,tTempPos)
			local d = self.data
			if math.abs(d.y-tTempPos.y)>=60 or math.abs(tTempPos.ty-tTempPos.dy)>=60 then
				_OPR_LastHitTick = 0
				_OPR_LastReleaseTick = 0
			else
				if _OPR_EnableOpr~=0 and hApi.gametime()-_OPR_LastHitTick<=350 then
					local nCurTick = hApi.gametime()
					_OPR_LastReleaseTick = nCurTick
					local nSkillId,oUnit,oWorld,oGrid,oBtn = tFunc.GetOprData(x-d.x,y-d.y)
					if nSkillId then
						if oUnit.attr.stun>0 and nCurTick-_OPR_LastReleaseTick<=500 then
							--眩晕状态特殊处理(双击跳过操作)
							hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
						elseif nSkillId==hVar.WAIT_SKILL_ID then
							--特殊处理等待命令
							local case = tFunc.ChooseOprBtn(oGrid,oBtn)
							if case==1 then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,hVar.WAIT_SKILL_ID,nil)
							elseif case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
								hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_WAIT,oUnit,hVar.ZERO,nil,oUnit.data.gridX,oUnit.data.gridY)
							end
						else
							local tabS = hVar.tab_skill[nSkillId]
							local case = tFunc.ChooseOprBtn(oGrid,oBtn)
							local nAttackId = hApi.GetDefaultSkill(oUnit)
							if case==0 then
								--无法释放什么都不做
							elseif nSkillId==hVar.MOVE_SKILL_ID or nSkillId==nAttackId then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
							elseif case==1 then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
							elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
								--自我施放类技能的特殊操作
								if case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
									hApi.BF_ConfirmSkillOpr(nil,nSkillId)
								end
							end
						end
					end
				end
			end
		end,
	})
	hGlobal.UI.BF_OptionPanel = hUI.frame:new({
		x = 0,
		y = 0,
		dragable = 2,
		autoactive = 0,
		background = -1,
		buttononly = 1,
		child = tChild,
		show = 0,
	})
	local _Frm = hGlobal.UI.BF_OperatePanel
	local _FrmO = hGlobal.UI.BF_OptionPanel
	_Frm.childUI["siderBar"] = hUI.image:new({
		parent = _Frm.handle._n,
		model = "panel/panel_part_09.png",
		y = -50,
		w = _Frm.data.h+100,
		h = 16,
	})
	_Frm.childUI["siderBar"].handle.s:setRotation(-90)
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__BF__HideUnitSkillBook1",function(sSceneType,oWorld,oMap)
		if sSceneType=="battlefield" then
			if _BF_DefaultViewPos then
				hApi.setViewNodeFocus(_BF_DefaultViewPos[1],_BF_DefaultViewPos[2])
			end
		else
			_Frm:show(0)
			_FrmO:show(0)
		end
	end)

	--进战场显示操作面板，设置数据
	hGlobal.event:listen("Event_BattlefieldStart","__BF__ShowLocalOprUI",function(oWorld)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		tFunc.UpdateGridUI()
		_FrmO:show(1)
		if _FrmO.childUI["btnOprPanel"]==nil then
			_Frm:show(1)
		end
		local tOption = _OPR_OptionBtn
		for i = 1,#tOption do
			if tOption[i][2]==0 then
				_FrmO.childUI[tOption[i][1]]:setstate(-1)
			end
		end
		hApi.SetObjectEx(_BF_LastOprWorld,oWorld)
	end)

	--出战场隐藏操作面板，清理数据
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__HideLocalOprUI",function(oPlayer)
		hApi.SetObjectEx(_BF_LastOprUnit,nil)
		hApi.SetObjectEx(_BF_LastOprWorld,nil)
		tFunc.UpdateGridUI()
	end)

	--激活单位时设置数据
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__SetLocalOprTarget",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		if oUnit:getcontroller()==hGlobal.LocalPlayer then
			hApi.SetObjectEx(_BF_LastOprUnit,oUnit)
			tFunc.UpdateOprUnitSkill(oUnit)
			_OPR_EnableOpr = 1
		else
			_OPR_EnableOpr = 0
			hApi.SetObjectEx(_BF_LastOprUnit,nil)
			tFunc.UpdateGridUI()
		end
	end)

	--如果转换为移动操作，需要调整BF_OperateBar
	hGlobal.event:listen("LocalEvent_PlayerSwitchOprBF","__BF__SwitchSkillPanelOprUI",function(oWorld,nSkillId)
		local oGrid = _Frm.childUI["SkillGrid"]
		if oGrid and oGrid.data.buttonNum>0 then
			for i = 1,oGrid.data.buttonNum do
				local oBtn = oGrid.childUI["btn_"..i]
				if oBtn and oBtn.data.userdata==nSkillId then
					tFunc.ChooseOprBtn(oGrid,oBtn)
				end
			end
		end
	end)

	--操作后隐藏技能条子
	hGlobal.event:listen("LocalEvent_PlayerConfirmOperateBF","__BF__HideOprGrid",function(oWorld,oUnit,nSkillId,oTarget,gridX,gridY)
		--清理技能施放条子
		local oRound = oWorld:getround()
		if oRound and oRound.data.auto==0 then
			return
		end
		_OPR_EnableOpr = 0
		tFunc.DisableOprBtn()
		if hGlobal.UI.BF_OperatePanel.data.show==1 and _FrmO.childUI["btnOprPanel"]~=nil then
			_FrmO.childUI["btnOprPanel"]:setstate(1)
			hGlobal.UI.BF_OperatePanel:show(0,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
		end
	end)

	--点到世界上的话，隐藏技能条子
	hGlobal.event:listen("LocalEvent_TouchDown_BF","__BF__HideSkillBar",function(oWorld,gridX,gridY,worldX,worldY)
		tFunc.ShowOptionBtn(0)
		if hGlobal.UI.BF_OperatePanel.data.show==1 and _FrmO.childUI["btnOprPanel"]~=nil then
			_FrmO.childUI["btnOprPanel"]:setstate(1)
			hGlobal.UI.BF_OperatePanel:show(0,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
		end
	end)
end


--------------------------------
-- 战场动作条(Iphone4)
hGlobal.UI.InitBattlefieldActionList_IP4 = function()
	--IP4专用
	if g_phone_mode~=1 then
		return
	end
	local _tFrmPos = {100,200,710,90}

	local _BF_TempUnit = {}
	local _gridX,_gridY = 48,-42
	local _gridW,_gridH,_iconW,_iconH = 77,77,74,74
	local _cardNum = 9
	local _slot = {}
	for i = 1,_cardNum do
		_slot[i] = 0
	end
	local _FrmDragStartY = 0
	local _FrmDragLastY = 0
	local _FrmIsShow = hVar.OPTIONS.IS_SHOW_ACTION_LIST
	local _frm,_grid
	local _oPlayerJustice		--正义的玩家!
	local _ListMoveY = {
		limit = {0,100,180},
		state = {{-9999,1},{40,1},{9999,0}},
	}
	hGlobal.UI.UnitActionList = hUI.frame:new({
		x = _tFrmPos[1],
		y = _tFrmPos[2],
		w = _tFrmPos[3],
		h = _tFrmPos[4],
		titlebar = 0,
		autoactive = 0,
		dragable = 2,
		buttononly = 1,
		background = -1,
		--background = "MODEL:Default",
		show = 0,
		child = {
			{
				__UI = "button",
				__NAME = "btnControl",
				mode = "imageButton",
				x = 0,
				y = 30,
				w = 710,
				h = 130,
				model = -1,
				align = "LT",
				failcall = 1,
				codeOnTouch = function(self,x,y)
					if _grid then
						local index = _grid:xy2grid(x,y,"ex")
						if index then
							local tX = _frm.childUI["cardList"].card[index+1]
							if tX and tX[2] and tX[2].ID~=0 and hClass.unit:find(tX[2].ID)==tX[2] then
								return hGlobal.event:event("LocalEvent_TouchOnActionList",tX[2],tX[3])
							elseif tX then
								return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,tX[3])
							else
								return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,0)
							end
						end
					end
				end,
			},
			{
				__UI = "grid",
				__NAME = "slot",
				--mode = "batchImage",
				animation = "lightSlim",
				gridW = _gridW,
				gridH = _gridH,
				iconH = _iconH,
				x = _gridX,
				y = _gridY,
				grid = _slot,
			},
		},
	})
	_grid = hGlobal.UI.UnitActionList.childUI["slot"]
	_frm = hGlobal.UI.UnitActionList
	--_frm.childUI["btnControl"].handle.s:setVisible(false)
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _InitInsertTab = function(v)
		local u = v[_UNIT]
		if u.data.id=="round" then
			return {v[_UNIQUE],v[_ROUND],u}
		else
			return {v[_UNIQUE],v[_ROUND],u}--{u.ID,u.data.id,u.data.owner,u.attr.stack}}
		end
	end
	_frm.childUI["dragBox"].data.autoactive = 0
	_frm.childUI["cardList"] = hUI.cardList:new({
		grid = hGlobal.UI.UnitActionList.childUI["slot"],
		movetime = 300,
		cardNum = 9,
		cardMax = (_cardNum+1)*2,
		offsetX = {0,0,0,  0,-1*_grid.data.x, 22},
		offsetY = {0,0,0,  0,            -10,-26},
		define =  {0,0,0,"o","s","o",},--"o"},
		insert = function(self,index,_,style,tInsert)
			local nUnique,nRoundCount,oUnit = tInsert[1],tInsert[2],tInsert[3]
			local oImg,pSlot,oLabel = hGlobal.BFOprUIFunc.AddUIForActionList(tInsert,_frm,_grid,index-1,0)
			self:remove(index)
			hUI.cardList.insert(self,index,{[0] = nUnique,0,oUnit,nRoundCount,oImg,pSlot,oLabel},style)
		end,
	})

	---------------------------------
	-- 玩家离开了战场
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","HideUI_All",function(oPlayer)
		if oPlayer==hGlobal.LocalPlayer then
			--出战场移除布置界面
			hGlobal.O:del("BF_Frame_PlaceStep")
			hGlobal.UI.UnitActionList.childUI["cardList"]:remove("all")
			hGlobal.UI.UnitActionList:show(0)
			hApi.clearTimer("__BF__UnitList_Update_AfterRemove")
			hApi.clearTimer("__BF__UnitList_Update_AfterRemoveEx")
		end
	end)

	local _cardUI = hGlobal.UI.UnitActionList.childUI["cardList"]
	---------------------------------
	-- 战场开始，创建行动队列
	hGlobal.event:listen("LocalEvent_UnitListCreated","__BF__UnitList_Show",function(oWorld,oRound)
		for i = -1,hVar.MAX_PLAYER_NUM,1 do
			if oWorld.data.lords[i] and hGlobal.player[i] then
				if hGlobal.player[i]==hGlobal.LocalPlayer then
					_oPlayerJustice = hGlobal.LocalPlayer
				elseif _oPlayerJustice==nil then
					_oPlayerJustice = hGlobal.player[i]
				end
			end
		end
		--创建一遍行动力条子上的单位
		local list = oRound.list
		--_frm:show(1)
		_cardUI:remove("all")
		for i = 1,#list do
			if i>_cardUI.data.cardNum then
				return
			end
			_cardUI:insert(i,nil,nil,_InitInsertTab(list[i]))
		end
		--if _FrmIsShow~=1 then
			--_frm.handle._n:setPosition(_frm.data.x,_frm.data.y+_ListMoveY.limit[3])
		--else
			--_frm.handle._n:setPosition(_frm.data.x,_frm.data.y)
		--end
	end)

	hGlobal.event:listen("LocalEvent_BFShowUnitActionList","__BF__UnitList_Show",function(IsShow)
		if IsShow==nil then
			if _frm.data.show==1 then
				IsShow = 0
			else
				IsShow = 1
			end
		end
		if IsShow==1 then
			_FrmIsShow = 1
			_frm:show(1)
			return hGlobal.event:event("LocalEvent_UpdateActionList")
		else
			_FrmIsShow = 0
			_frm:show(0)
		end
	end)

	---------------------------------
	-- 任意单位激活时刷新行动队列中生物的数量
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__UnitList_NumChange",function(oWorld,oRound,oUnit)
		if oWorld.data.type=="battlefield" then
			local card = _cardUI.card
			for i = 1,#card do
				--第2个是单位，第5个是number
				local v = card[i]
				if v and v[_cUNIT] and v[_cUNIT].ID~=0 then
					v[6]:setText(v[2].attr.stack)
					--v[7].childUI["valbar"]:setV(v[2].attr.hp,v[2].attr.mxhp)
				end
			end
		end
	end)

	local _CreateTempList = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local TempList = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				TempList[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				local c = TempList[uKey]
				if c==nil then
					c = {}
					TempList[uKey] = c
				end
				c[#c+1] = i
			end
		end
		return TempList
	end

	local _CreateListIndex = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local tIndex = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				tIndex[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				if tIndex[uKey]==nil then
					tIndex[uKey] = {}
				end
				tIndex[uKey][#tIndex[uKey]+1] = i
			end
		end
		return tIndex
	end

	local _CountCardNum = function()
		local nNum,nLast = 0,0
		for i = 1,_cardUI.data.cardMax do
			if _cardUI.card[i] then
				nNum = nNum + 1
				nLast = i
			end
		end
		return nNum,nLast
	end

	---------------------------------
	-- 行动队列产生了变更
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _LastActiveTick = 0
	local _LoadActionList = function(oWorld,oRound)
		local tUnitListIndex = _CreateListIndex(oRound.list,#oRound.list,_UNIQUE,_UNIT,_ROUND)
		local tCardListIndex = _CreateListIndex(_cardUI.card,_cardUI.data.cardMax,_cUNIQUE,_cUNIT,_cROUND)
		local tCardRemove = {n=0}
		local tCardShift = {n=0}
		local tCardInsert = {n=0}
		for i = 1,_cardUI.data.cardMax do
			tCardInsert[i] = 0
			tCardRemove[i] = 0
			tCardShift[i] = 0
		end

		--判断是否需要移除单位
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if v~=nil and tUnitListIndex[v[_cUNIQUE]]==nil then
				tCardRemove.n = tCardRemove.n + 1
				tCardRemove[i] = 1
			end
		end

		--判断是否第一个单位进行了等待
		if tCardRemove[1]==1 and _cardUI.card[1][_cUNIT].ID~=0 then
			local v = _cardUI.card[1]
			local uKey = v[_cUNIT].ID.."_"..v[_cROUND]
			local o = tCardListIndex[uKey]
			if type(o)=="table" and #o>1 then
				--首先判断这个单位是否移动到了本轮行动的后面
				for i = 1,#o do
					local n = o[i]
					local v = oRound.list[n]
					local c = _cardUI.card[1]
					if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
						o[i] = 0
						tCardRemove[1] = 0
						tCardRemove.n = tCardRemove.n - 1
						tCardListIndex[c[_cUNIQUE]] = nil
						c[_cUNIQUE] = v[_UNIQUE]
						tCardListIndex[c[_cUNIQUE]] = 1
						break
					end
				end
			end
		end

		--判断是否需要进行交换位置
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if tCardRemove[i]~=0 then
				--如果需要移除此卡片，那么不管它
			elseif v~=nil then
				local n = tUnitListIndex[v[_cUNIQUE]]
				if n==nil then
					--这是咋回事？不是判断过移除了么
					tCardRemove[i] = 1
				else
					if n~=i then
						--移动到指定位置
						tCardShift.n = tCardShift.n + 1
						tCardShift[i] = n
					end
				end
			end
		end

		--判断是否需要插入卡片
		for i = 1,_cardUI.data.cardNum do
			local v = oRound.list[i]
			if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
				tCardInsert.n = tCardInsert.n + 1
				tCardInsert[i] = _InitInsertTab(v)
			end
		end

		if tCardRemove.n>0 or tCardShift.n>0 or tCardInsert.n>0 then
			--判断是否可以移除第一个单位
			if tCardRemove[1]~=0 then
				_cardUI:remove(1,"fadeX")
				tCardRemove.n = tCardRemove.n - 1
			end
			hApi.addTimerForever("__BF__UnitList_Update",hVar.TIMER_MODE.GAMETIME,300,function()
				if tCardRemove.n>0 then
					tCardRemove.n = 0
					local NeedWait = 0
					for i = 1,_cardUI.data.cardMax do
						local v = _cardUI.card[i]
						if v~=nil then
							if tCardRemove[i]==1 then
								_cardUI:remove(i,"dead")
								NeedWait = 1
							end
						end
					end
					--移除任何单位后，等待300ms
					if NeedWait>0 then
						return
					end
				end
				if tCardShift.n>0 then
					tCardShift.n = 0
					local _,nCardLastOld = _CountCardNum()
					local NeedWait = 0
					local CardTemp = {}
					--移动现有的卡片
					for i = 1,_cardUI.data.cardMax do
						if tCardShift[i]~=0 and tCardShift[i]~=i then
							CardTemp[tCardShift[i]] = _cardUI.card[i]
							_cardUI.card[i] = nil
						end
					end
					for i = 1,_cardUI.data.cardMax do
						if CardTemp[i]~=nil then
							if _cardUI.card[i]~=nil then
								--奇怪，出错了才会走到这里
								_cardUI:remove(i,"fade")
							end
							_cardUI.card[i] = CardTemp[i]
							NeedWait = 1
						end
					end
					--顺带判断一下是否有新的卡片加入
					--跟在队伍后面的视为特殊加入
					if tCardInsert.n>0 and nCardLastOld>0 then
						local _,nLast = _CountCardNum()
						for i = nLast+1,_cardUI.data.cardNum,1 do
							if tCardInsert[i]~=0 then
								local v = tCardInsert[i]
								tCardInsert[i] = 0
								tCardInsert.n = tCardInsert.n - 1
								local nInsertIndex = nCardLastOld + (i-nLast)
								_cardUI:insert(nInsertIndex,nil,"fade",v)
								if _cardUI.card[i]~=nil then
									--奇怪，出错了才会走到这里
									_cardUI:remove(i,"fade")
								end
								_cardUI.card[i] = _cardUI.card[nInsertIndex]
								_cardUI.card[nInsertIndex] = nil
							end
						end
					end
					_cardUI:sort("setXY")
					for i = _cardUI.data.cardNum+1,_cardUI.data.cardMax,1 do
						if _cardUI.card[i]~=nil then
							_cardUI:remove(i,"fade")
							NeedWait = 1
						end
					end
					if NeedWait==1 then
						return
					end
				end
				if tCardInsert.n>0 then
					for i = 1,_cardUI.data.cardNum do
						if tCardInsert[i]~=0 and _cardUI.card[i]==nil then
							if i==1 then
								_cardUI:insert(i,nil,nil,tCardInsert[i])
							else
								_cardUI:insert(i,nil,"insert",tCardInsert[i])
							end
						end
					end
				end
				hApi.clearTimer("__BF__UnitList_Update")
			end)
		end
	end
	hGlobal.event:listen("LocalEvent_RoundChanged","__BF__UnitList_Update",function(oWorld,oRound)
		if _frm.data.show==0 or _FrmIsShow==0 then
			return
		end
		_LoadActionList(oWorld,oRound)
	end)

	hGlobal.event:listen("LocalEvent_UpdateActionList","__BF__UpdateActionList",function()
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.data.type=="battlefield" and oWorld:getround() then
			_LoadActionList(oWorld,oWorld:getround())
		end
	end)
end

-----------------------------------------------------------
--战场操作UI(Iphone4)
hGlobal.UI.InitBattlefieldOperateUI_IP4 = function()
	--IP4专用
	if g_phone_mode~=1 then
		return
	end
	local _BF_DefaultViewPos = {hVar.SCREEN.w/2+34,hVar.SCREEN.h/2+60}
	local _OPR_BtnWH = 72
	local _OPR_GridShow = 10
	local _OPR_GridWH = math.floor((hVar.SCREEN.w)/_OPR_GridShow)
	local _OPR_GridXYWH = {56,-1*(10+_OPR_BtnWH/2),_OPR_GridWH,_OPR_GridWH}
	local _OPR_PanelPosX = hVar.SCREEN.w-112
	local _OPR_PanelPosY = 100
	local _OPR_PanelClipper = {180,_OPR_PanelPosY,hVar.SCREEN.w,128}
	local _OPR_PanelBG = -1--"MODEL:Default"
	local _OPR_OptionBtn = {
		{"btnOption",1,{40,_OPR_PanelPosY-50,64,64},{"ui/set.png"}},
		{"btnActionList",1,{128,_OPR_PanelPosY-50,64,64},{"ui/attr_defense.png"}},
		{"btnGrid",0,{hVar.SCREEN.w/2-96,hVar.SCREEN.h/2+100,96,96},{"UI:BTN_ControlButton","grid"}},
		{"btnSurrender",0,{hVar.SCREEN.w/2+96,hVar.SCREEN.h/2+100,96,96},{"UI:BTN_ControlButton","surrender"}},
	}
	local _OPR_LastHitTick = 0
	local _OPR_LastReleaseTick = 0
	local _OPR_EnableOpr = 0
	local _BF_LastOprUnit = {}
	local _BF_LastOprWorld = {}
	local tFunc = __CODE__InitSkillOprFunc(_OPR_OptionBtn)
	tFunc.UpdateOprUnitSkill = function(oUnit)
		print("UpdateOprUnitSkill", 3)
		local frm = hGlobal.UI.BF_OperatePanel
		local tSkill = {}
		local tSkillTemp = {}
		local nAttackId = hApi.GetDefaultSkill(oUnit)
		tSkillTemp[#tSkillTemp+1] = hVar.GUARD_SKILL_ID
		--允许尚未等待过的单位发动等待行为
		local oWorld = oUnit:getworld()
		if oWorld then
			local oRound = oWorld:getround()
			if oRound then
				local oUnitCur = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
				local nActivityEx = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx)
				if oUnitCur==oUnit and (nActivityEx or 0)>-5000 then
					tSkillTemp[#tSkillTemp+1] = hVar.WAIT_SKILL_ID
				end
			end
		end
		if nAttackId~=0 then
			tSkillTemp[#tSkillTemp+1] = nAttackId
		end
		oUnit:enumskill(function(sData)
			local id,lv,cd,count = unpack(sData)
			local tabS = hVar.tab_skill[id]
			if tabS and id>0 and count>=0 and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT) then
				tSkillTemp[#tSkillTemp+1] = id
			end
		end)
		if #tSkillTemp==0 then
			tSkillTemp[#tSkillTemp+1] = hVar.MOVE_SKILL_ID
		end
		for i = #tSkillTemp,1,-1 do
			tSkill[#tSkill+1] = tSkillTemp[i]
		end
		local plusW = 0
		if type(frm.data.clipper)=="table" then
			plusW = frm.data.clipper[1]
		end
		local moveW = math.max(0,#tSkill*_OPR_GridWH-hVar.SCREEN.w+plusW)
		frm:setXY(_OPR_PanelPosX-(#tSkill-1)*_OPR_GridWH,_OPR_PanelPosY,nil,{-20,0,moveW+40,0})
		tFunc.UpdateGridUI(oUnit,tSkill,{_OPR_GridXYWH[1],_OPR_GridXYWH[2],_OPR_BtnWH,_OPR_BtnWH,_OPR_GridXYWH[3],_OPR_GridXYWH[4]})
	end
	local tChild = tFunc.InitOptionUI(_OPR_OptionBtn)
	hGlobal.UI.BF_OperatePanel = hUI.frame:new({
		x = _OPR_PanelPosX,
		y = _OPR_PanelPosY,
		z = -1,
		w = 4096,
		h = _OPR_BtnWH+20,
		clipper = _OPR_PanelClipper,
		dragable = {0,0,0,0},
		autoalign = {"H","SkillGrid",60,0,0},
		autoactive = 0,
		closebtn = 0,
		background = _OPR_PanelBG,
		border = 0,
		show = 0,
		codeOnTouch = function(self,x,y)
			local d = self.data
			if _OPR_EnableOpr==0 then
				_OPR_LastHitTick = 0
			else
				_OPR_LastHitTick = hApi.gametime()
				if _OPR_LastReleaseTick==0 then
					_OPR_LastReleaseTick = 1
				end
				local nLastReleaseTick = _OPR_LastReleaseTick
				local nSkillId,_,_,_,oBtn = tFunc.GetOprData(x,y)
				if nSkillId and hVar.tab_stringS[nSkillId]~=nil and hVar.tab_stringS[nSkillId][1] then
					local oldX = d.x
					hApi.addTimerOnce("__BF__ShowSkillHint",600,function()
						if _OPR_LastReleaseTick==nLastReleaseTick and self.handle._n~=nil then
							local ox,oy,tx,ty = hUI.dragBox:currentXY()
							if ox==nil then
								return
							elseif (ox-tx+self.data.x)^2+(oy-ty+self.data.y)^2>1024 then
								return
							end
							local curX,curY = self.handle._n:getPosition()
							if math.abs(curX-oldX)<60 then
								local oUnit = hApi.BF_GetOprUnit()
								if oUnit then
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram",oUnit.data.id,nSkillId,150,600)
								end
							end
						end
					end)
				end
			end
		end,
		codeOnDrop = function(self,x,y,tTempPos)
			local d = self.data
			if math.abs(d.x-tTempPos.x)>=60 or math.abs(tTempPos.ty-tTempPos.dy)>=60 then
				_OPR_LastHitTick = 0
				_OPR_LastReleaseTick = 0
			else
				if _OPR_EnableOpr~=0 and hApi.gametime()-_OPR_LastHitTick<=350 then
					local nCurTick = hApi.gametime()
					_OPR_LastReleaseTick = nCurTick
					local nSkillId,oUnit,oWorld,oGrid,oBtn = tFunc.GetOprData(x-d.x,y-d.y)
					if nSkillId then
						if oUnit.attr.stun>0 and nCurTick-_OPR_LastReleaseTick<=500 then
							--眩晕状态特殊处理(双击跳过操作)
							hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
						elseif nSkillId==hVar.WAIT_SKILL_ID then
							--特殊处理等待命令
							local case = tFunc.ChooseOprBtn(oGrid,oBtn)
							if case==1 then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,hVar.WAIT_SKILL_ID,nil)
							elseif case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
								hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_WAIT,oUnit,hVar.ZERO,nil,oUnit.data.gridX,oUnit.data.gridY)
							end
						else
							local tabS = hVar.tab_skill[nSkillId]
							local case = tFunc.ChooseOprBtn(oGrid,oBtn)
							local nAttackId = hApi.GetDefaultSkill(oUnit)
							if case==0 then
								--无法释放什么都不做
							elseif nSkillId==hVar.MOVE_SKILL_ID or nSkillId==nAttackId then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
							elseif case==1 then
								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
							elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
								--自我施放类技能的特殊操作
								if case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
									hApi.BF_ConfirmSkillOpr(nil,nSkillId)
								end
							end
						end
					end
				end
			end
		end,
	})
	hGlobal.UI.BF_OptionPanel = hUI.frame:new({
		x = 0,
		y = 0,
		dragable = 2,
		autoactive = 0,
		background = -1,
		buttononly = 1,
		child = tChild,
		show = 0,
	})
	local _Frm = hGlobal.UI.BF_OperatePanel
	local _FrmO = hGlobal.UI.BF_OptionPanel
	--切地图隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__BF__HideUnitSkillBook",function(sSceneType,oWorld,oMap)
		if sSceneType=="battlefield" then
			if _BF_DefaultViewPos then
				hApi.setViewNodeFocus(_BF_DefaultViewPos[1],_BF_DefaultViewPos[2])
			end
		else
			_Frm:show(0)
			_FrmO:show(0)
		end
	end)

	--进战场显示操作面板，设置数据
	hGlobal.event:listen("Event_BattlefieldStart","__BF__ShowLocalOprUI",function(oWorld)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		tFunc.UpdateGridUI()
		_FrmO:show(1)
		if _FrmO.childUI["btnOprPanel"]==nil then
			_Frm:show(1)
		end
		local tOption = _OPR_OptionBtn
		for i = 1,#tOption do
			if tOption[i][2]==0 then
				_FrmO.childUI[tOption[i][1]]:setstate(-1)
			end
		end
		hApi.SetObjectEx(_BF_LastOprWorld,oWorld)
	end)

	--出战场隐藏操作面板，清理数据
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__HideLocalOprUI",function(oPlayer)
		hApi.SetObjectEx(_BF_LastOprUnit,nil)
		hApi.SetObjectEx(_BF_LastOprWorld,nil)
		tFunc.UpdateGridUI()
	end)

	--激活单位时设置数据
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__SetLocalOprTarget",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		if oUnit:getcontroller()==hGlobal.LocalPlayer then
			hApi.SetObjectEx(_BF_LastOprUnit,oUnit)
			tFunc.UpdateOprUnitSkill(oUnit)
			_OPR_EnableOpr = 1
		else
			_OPR_EnableOpr = 0
			hApi.SetObjectEx(_BF_LastOprUnit,nil)
			tFunc.UpdateGridUI()
		end
	end)

	--如果转换为移动操作，需要调整BF_OperateBar
	hGlobal.event:listen("LocalEvent_PlayerSwitchOprBF","__BF__SwitchSkillPanelOprUI",function(oWorld,nSkillId)
		local oGrid = _Frm.childUI["SkillGrid"]
		if oGrid and oGrid.data.buttonNum>0 then
			for i = 1,oGrid.data.buttonNum do
				local oBtn = oGrid.childUI["btn_"..i]
				if oBtn and oBtn.data.userdata==nSkillId then
					tFunc.ChooseOprBtn(oGrid,oBtn)
				end
			end
		end
	end)

	--操作后隐藏技能条子
	hGlobal.event:listen("LocalEvent_PlayerConfirmOperateBF","__BF__HideOprGrid",function(oWorld,oUnit,nSkillId,oTarget,gridX,gridY)
		--清理技能施放条子
		local oRound = oWorld:getround()
		if oRound and oRound.data.auto==0 then
			return
		end
		_OPR_EnableOpr = 0
		tFunc.DisableOprBtn()
		if hGlobal.UI.BF_OperatePanel.data.show==1 and _FrmO.childUI["btnOprPanel"]~=nil then
			_FrmO.childUI["btnOprPanel"]:setstate(1)
			hGlobal.UI.BF_OperatePanel:show(0,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
		end
	end)

	--点到世界上的话，隐藏技能条子
	hGlobal.event:listen("LocalEvent_TouchDown_BF","__BF__HideSkillBar",function(oWorld,gridX,gridY,worldX,worldY)
		tFunc.ShowOptionBtn(0)
		if hGlobal.UI.BF_OperatePanel.data.show==1 and _FrmO.childUI["btnOprPanel"]~=nil then
			_FrmO.childUI["btnOprPanel"]:setstate(1)
			hGlobal.UI.BF_OperatePanel:show(0,"appear",{x=hGlobal.UI.BF_OperatePanel.data.x+280,y=hVar.SCREEN.h})
		end
	end)
end

--战场内单位血条(Iphone4特殊处理)
hGlobal.UI.InitBattlefieldUnitHp_IP4 = function()
	--IP4专用
	if g_phone_mode~=1 then
		return
	end
	--显示单位的数量和血量
	--hGlobal.event:listen("Event_UnitBorn","__BF__InitUnitHpUI",function(oUnit)
	--	local u = oUnit
	--	local w = u:getworld()
	--	if w~=nil and w.data.type=="battlefield" and oUnit.attr.hp>0 and w.data.IsQuickBattlefield~=1 then
	--		local d = u.data
	--		local x = -17
	--		local y = -20
	--		local _parent = u.handle._n
	--		if oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
	--			_parent = u.handle._tn
	--			y = 64
	--		end
	--		local tabU = hVar.tab_unit[u.data.id]
	--		if tabU and type(tabU.hpXY)=="table" then
	--			x = tabU.hpXY[1] + x
	--			y = tabU.hpXY[2] + y
	--		end
	--		local nType = hApi.BFGetUnitControlType(oUnit)
	--		if nType~=0 then
	--			local sBarColor
	--			if nType==1 then
	--				--我军血条
	--				sBarColor = "green"
	--			else
	--				--友军血条
	--				sBarColor = "blue"
	--			end
	--			--友军血条
	--			u.chaUI["hp"] = hUI.valbar:new({
	--				parent = _parent,
	--				x = x,
	--				y = y,
	--				w = 34,
	--				h = 4,
	--				align = "LC",
	--				back = {model = "UI:BAR_ValueBar_BG",x = -2},
	--				model = "UI:IMG_ValueBar",
	--				animation = sBarColor,
	--				v = u.attr.hp,
	--				max = u.attr.mxhp,
	--			})
	--			if oUnit.data.type~=hVar.UNIT_TYPE.BUILDING then
	--				u.chaUI["number"] = hUI.label:new({
	--					parent = _parent,
	--					font = "numWhite",
	--					text = tostring(u.attr.stack),
	--					size = 16,
	--					align = "MC",
	--					x = 0,
	--					y = -6,
	--				})
	--			end
	--		else
	--			--敌军血条
	--			u.chaUI["hp"] = hUI.valbar:new({
	--				parent = _parent,
	--				x = x,
	--				y = y,
	--				w = 34,
	--				h = 4,
	--				align = "LC",
	--				back = {model = "UI:BAR_ValueBar_BG",x = -2},
	--				model = "UI:IMG_ValueBar",
	--				animation = "red",
	--				v = u.attr.hp,
	--				max = u.attr.mxhp,
	--			})
	--			if oUnit.data.type~=hVar.UNIT_TYPE.BUILDING then
	--				u.chaUI["number"] = hUI.label:new({
	--					parent = _parent,
	--					font = "numWhite",
	--					text = tostring(u.attr.stack),
	--					size = 16,
	--					align = "MC",
	--					x = 0,
	--					y = -6,
	--				})
	--			end
	--		end
	--	end
	--end)
end


--------------------------------
-- 战场出手顺序条(安卓)
--------------------------------
hGlobal.UI.InitBattlefieldActionList_IPA = function()
	local _BAL_FrmXYWH
	local _BAL_ActionCardNum = 9
	if g_phone_mode==3 then
		--安卓
		_BAL_FrmXYWH = {146,80,710,100}
	else
		return
	end
	local _BF_TempUnit = {}
	local _gridX,_gridY = 48,-42
	local _gridW,_gridH,_iconW,_iconH = 77,77,74,74
	local _slot = {}
	for i = 1,_BAL_ActionCardNum do
		_slot[i] = 0
	end
	local _FrmDragStartY = 0
	local _FrmDragLastY = 0
	local _FrmIsShow = hVar.OPTIONS.IS_SHOW_ACTION_LIST
	local _frm,_grid
	local _oPlayerJustice		--正义的玩家!
	hGlobal.UI.UnitActionList = hUI.frame:new({
		x = _BAL_FrmXYWH[1],
		y = _BAL_FrmXYWH[2],
		w = _BAL_FrmXYWH[3],
		h = _BAL_FrmXYWH[4],
		titlebar = 0,
		autoactive = 0,
		dragable = 2,
		buttononly = 1,
		background = -1,
		show = 0,
		child = {
			{
				__UI = "button",
				__NAME = "btnControl",
				mode = "imageButton",
				x = 0,
				y = 0,
				w = 710,
				h = 100,
				model = -1,
				align = "LT",
				failcall = 1,
				codeOnTouch = function(self,x,y)
					local cx,cy = _frm.handle._n:getPosition()
					if _FrmIsShow==0 then
						_FrmDragStartY = -10
						local tx,ty = _frm.data.x,_frm.data.y+y+10
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty)))
					else
						_FrmDragStartY = y
						if _grid then
							local index = _grid:xy2grid(x,y,"ex")
							if index then
								local tX = _frm.childUI["cardList"].card[index+1]
								if tX and tX[2] and tX[2].ID~=0 and hClass.unit:find(tX[2].ID)==tX[2] then
									return hGlobal.event:event("LocalEvent_TouchOnActionList",tX[2],tX[3])
								elseif tX then
									return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,tX[3])
								else
									return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,0)
								end
							end
						end
					end
				end,
				code = function(self,x,y,sus)
					local cx,cy = _frm.handle._n:getPosition()
					if y>-65 then
						_FrmIsShow = 1
						local tx,ty = _frm.data.x,_frm.data.y
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty)))
						return hGlobal.event:event("LocalEvent_UpdateActionList")
					else
						_FrmIsShow = 0
						local tx,ty = _frm.data.x,_frm.data.y-120
						_frm.handle._n:runAction(CCMoveTo:create(math.abs(cy-ty)/700,ccp(tx,ty)))
						return hGlobal.event:event("LocalEvent_TouchOnActionList",nil,-1)
					end
				end,
				codeOnDrag = function(self,x,y)
					local vy = y-_FrmDragStartY
					if vy<=0 and vy>=-100 then
						local plusX =_frm.data.x
						local plusY =_frm.data.y
						_frm.handle._n:setPosition(plusX,plusY+vy)
					end
				end,
			},
			{
				__UI = "grid",
				__NAME = "slot",
				--mode = "batchImage",
				animation = "lightSlim",
				gridW = _gridW,
				gridH = _gridH,
				iconH = _iconH,
				x = _gridX,
				y = _gridY,
				grid = _slot,
			},
		},
	})
	_grid = hGlobal.UI.UnitActionList.childUI["slot"]
	_frm = hGlobal.UI.UnitActionList
	--_frm.childUI["btnControl"].handle.s:setVisible(false)
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _InitInsertTab = function(v)
		local u = v[_UNIT]
		if u.data.id=="round" then
			return {v[_UNIQUE],v[_ROUND],u}
		else
			return {v[_UNIQUE],v[_ROUND],u}--{u.ID,u.data.id,u.data.owner,u.attr.stack}}
		end
	end
	_frm.childUI["dragBox"].data.autoactive = 0
	_frm.childUI["cardList"] = hUI.cardList:new({
		grid = hGlobal.UI.UnitActionList.childUI["slot"],
		movetime = 300,
		cardNum = _BAL_ActionCardNum,
		cardMax = (_BAL_ActionCardNum+1)*2,
		offsetX = {0,0,0,  0,-1*_grid.data.x, 22},
		offsetY = {0,0,0,  0,            -10,-26},
		define =  {0,0,0,"o","s","o",},--"o"},
		insert = function(self,index,_,style,tInsert)
			local nUnique,nRoundCount,oUnit = tInsert[1],tInsert[2],tInsert[3]
			local oImg,pSlot,oLabel = hGlobal.BFOprUIFunc.AddUIForActionList(tInsert,_frm,_grid,index-1,0)
			self:remove(index)
			hUI.cardList.insert(self,index,{[0] = nUnique,0,oUnit,nRoundCount,oImg,pSlot,oLabel},style)
		end,
	})

	---------------------------------
	-- 玩家离开了战场
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","HideUI_All",function(oPlayer)
		if oPlayer==hGlobal.LocalPlayer then
			--出战场移除布置界面
			hGlobal.O:del("BF_Frame_PlaceStep")
			hGlobal.UI.UnitActionList.childUI["cardList"]:remove("all")
			hGlobal.UI.UnitActionList:show(0)
			hApi.clearTimer("__BF__UnitList_Update_AfterRemove")
			hApi.clearTimer("__BF__UnitList_Update_AfterRemoveEx")
		end
	end)

	local _cardUI = hGlobal.UI.UnitActionList.childUI["cardList"]
	---------------------------------
	-- 战场开始，创建行动队列
	hGlobal.event:listen("LocalEvent_UnitListCreated","__BF__UnitList_Show",function(oWorld,oRound)
		for i = -1,hVar.MAX_PLAYER_NUM,1 do
			if oWorld.data.lords[i] and hGlobal.player[i] then
				if hGlobal.player[i]==hGlobal.LocalPlayer then
					_oPlayerJustice = hGlobal.LocalPlayer
				elseif _oPlayerJustice==nil then
					_oPlayerJustice = hGlobal.player[i]
				end
			end
		end
		--创建一遍行动力条子上的单位
		local list = oRound.list
		_frm:show(1)
		_cardUI:remove("all")
		for i = 1,#list do
			if i>_cardUI.data.cardNum then
				return
			end
			_cardUI:insert(i,nil,nil,_InitInsertTab(list[i]))
		end
		if _FrmIsShow~=1 then
			_frm.handle._n:setPosition(_frm.data.x,_frm.data.y-120)
		else
			_frm.handle._n:setPosition(_frm.data.x,_frm.data.y)
		end
	end)

	---------------------------------
	-- 任意单位激活时刷新行动队列中生物的数量
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__UnitList_NumChange",function(oWorld,oRound,oUnit)
		if oWorld.data.type=="battlefield" then
			local card = _cardUI.card
			for i = 1,#card do
				--第2个是单位，第5个是number
				local v = card[i]
				if v and v[_cUNIT] and v[_cUNIT].ID~=0 then
					v[6]:setText(v[2].attr.stack)
					--v[7].childUI["valbar"]:setV(v[2].attr.hp,v[2].attr.mxhp)
				end
			end
		end
	end)

	local _CreateTempList = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local TempList = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				TempList[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				local c = TempList[uKey]
				if c==nil then
					c = {}
					TempList[uKey] = c
				end
				c[#c+1] = i
			end
		end
		return TempList
	end

	local _CreateListIndex = function(UnitList,iMax,nUNIQUE,nUNIT,nROUND)
		local tIndex = {}
		for i = 1,iMax do
			local v = UnitList[i]
			if v~=nil then
				tIndex[v[nUNIQUE]] = i
				local uKey = v[nUNIT].ID.."_"..v[nROUND]
				if tIndex[uKey]==nil then
					tIndex[uKey] = {}
				end
				tIndex[uKey][#tIndex[uKey]+1] = i
			end
		end
		return tIndex
	end

	local _CountCardNum = function()
		local nNum,nLast = 0,0
		for i = 1,_cardUI.data.cardMax do
			if _cardUI.card[i] then
				nNum = nNum + 1
				nLast = i
			end
		end
		return nNum,nLast
	end

	---------------------------------
	-- 行动队列产生了变更
	local _UNIQUE,_UNIT,_ROUND,_ACTIVITY,_ACTIVITY_EX = hVar.ROUND_DEFINE.DATA_INDEX.nUnique,hVar.ROUND_DEFINE.DATA_INDEX.oUnit,hVar.ROUND_DEFINE.DATA_INDEX.nRound,hVar.ROUND_DEFINE.DATA_INDEX.nActivity,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx
	local _cUNIQUE,_cUNIT,_cROUND = 0,2,3
	local _LastActiveTick = 0
	local _LoadActionList = function(oWorld,oRound)
		local tUnitListIndex = _CreateListIndex(oRound.list,#oRound.list,_UNIQUE,_UNIT,_ROUND)
		local tCardListIndex = _CreateListIndex(_cardUI.card,_cardUI.data.cardMax,_cUNIQUE,_cUNIT,_cROUND)
		local tCardRemove = {n=0}
		local tCardShift = {n=0}
		local tCardInsert = {n=0}
		for i = 1,_cardUI.data.cardMax do
			tCardInsert[i] = 0
			tCardRemove[i] = 0
			tCardShift[i] = 0
		end

		--判断是否需要移除单位
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if v~=nil and tUnitListIndex[v[_cUNIQUE]]==nil then
				tCardRemove.n = tCardRemove.n + 1
				tCardRemove[i] = 1
			end
		end

		--判断是否第一个单位进行了等待
		if tCardRemove[1]==1 and _cardUI.card[1][_cUNIT].ID~=0 then
			local v = _cardUI.card[1]
			local uKey = v[_cUNIT].ID.."_"..v[_cROUND]
			local o = tCardListIndex[uKey]
			if type(o)=="table" and #o>1 then
				--首先判断这个单位是否移动到了本轮行动的后面
				for i = 1,#o do
					local n = o[i]
					local v = oRound.list[n]
					local c = _cardUI.card[1]
					if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
						o[i] = 0
						tCardRemove[1] = 0
						tCardRemove.n = tCardRemove.n - 1
						tCardListIndex[c[_cUNIQUE]] = nil
						c[_cUNIQUE] = v[_UNIQUE]
						tCardListIndex[c[_cUNIQUE]] = 1
						break
					end
				end
			end
		end

		--判断是否需要进行交换位置
		for i = 1,_cardUI.data.cardMax do
			local v = _cardUI.card[i]
			if tCardRemove[i]~=0 then
				--如果需要移除此卡片，那么不管它
			elseif v~=nil then
				local n = tUnitListIndex[v[_cUNIQUE]]
				if n==nil then
					--这是咋回事？不是判断过移除了么
					tCardRemove[i] = 1
				else
					if n~=i then
						--移动到指定位置
						tCardShift.n = tCardShift.n + 1
						tCardShift[i] = n
					end
				end
			end
		end

		--判断是否需要插入卡片
		for i = 1,_cardUI.data.cardNum do
			local v = oRound.list[i]
			if v~=nil and tCardListIndex[v[_UNIQUE]]==nil then
				tCardInsert.n = tCardInsert.n + 1
				tCardInsert[i] = _InitInsertTab(v)
			end
		end

		if tCardRemove.n>0 or tCardShift.n>0 or tCardInsert.n>0 then
			--判断是否可以移除第一个单位
			if tCardRemove[1]~=0 then
				_cardUI:remove(1,"fadeX")
				tCardRemove.n = tCardRemove.n - 1
			end
			hApi.addTimerForever("__BF__UnitList_Update",hVar.TIMER_MODE.GAMETIME,300,function()
				if tCardRemove.n>0 then
					tCardRemove.n = 0
					local NeedWait = 0
					for i = 1,_cardUI.data.cardMax do
						local v = _cardUI.card[i]
						if v~=nil then
							if tCardRemove[i]==1 then
								_cardUI:remove(i,"dead")
								NeedWait = 1
							end
						end
					end
					--移除任何单位后，等待300ms
					if NeedWait>0 then
						return
					end
				end
				if tCardShift.n>0 then
					tCardShift.n = 0
					local _,nCardLastOld = _CountCardNum()
					local NeedWait = 0
					local CardTemp = {}
					--移动现有的卡片
					for i = 1,_cardUI.data.cardMax do
						if tCardShift[i]~=0 and tCardShift[i]~=i then
							CardTemp[tCardShift[i]] = _cardUI.card[i]
							_cardUI.card[i] = nil
						end
					end
					for i = 1,_cardUI.data.cardMax do
						if CardTemp[i]~=nil then
							if _cardUI.card[i]~=nil then
								--奇怪，出错了才会走到这里
								_cardUI:remove(i,"fade")
							end
							_cardUI.card[i] = CardTemp[i]
							NeedWait = 1
						end
					end
					--顺带判断一下是否有新的卡片加入
					--跟在队伍后面的视为特殊加入
					if tCardInsert.n>0 and nCardLastOld>0 then
						local _,nLast = _CountCardNum()
						for i = nLast+1,_cardUI.data.cardNum,1 do
							if tCardInsert[i]~=0 then
								local v = tCardInsert[i]
								tCardInsert[i] = 0
								tCardInsert.n = tCardInsert.n - 1
								local nInsertIndex = nCardLastOld + (i-nLast)
								_cardUI:insert(nInsertIndex,nil,"fade",v)
								if _cardUI.card[i]~=nil then
									--奇怪，出错了才会走到这里
									_cardUI:remove(i,"fade")
								end
								_cardUI.card[i] = _cardUI.card[nInsertIndex]
								_cardUI.card[nInsertIndex] = nil
							end
						end
					end
					_cardUI:sort("setXY")
					for i = _cardUI.data.cardNum+1,_cardUI.data.cardMax,1 do
						if _cardUI.card[i]~=nil then
							_cardUI:remove(i,"fade")
							NeedWait = 1
						end
					end
					if NeedWait==1 then
						return
					end
				end
				if tCardInsert.n>0 then
					for i = 1,_cardUI.data.cardNum do
						if tCardInsert[i]~=0 and _cardUI.card[i]==nil then
							if i==1 then
								_cardUI:insert(i,nil,nil,tCardInsert[i])
							else
								_cardUI:insert(i,nil,"insert",tCardInsert[i])
							end
						end
					end
				end
				hApi.clearTimer("__BF__UnitList_Update")
			end)
		end
	end
	hGlobal.event:listen("LocalEvent_RoundChanged","__BF__UnitList_Update",function(oWorld,oRound)
		if _frm.data.show==0 or _FrmIsShow==0 then
			return
		end
		_LoadActionList(oWorld,oRound)
	end)

	hGlobal.event:listen("LocalEvent_UpdateActionList","__BF__UpdateActionList",function()
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.data.type=="battlefield" and oWorld:getround() then
			_LoadActionList(oWorld,oWorld:getround())
		end
	end)
end

-----------------------------------------------------------
--战场操作UI(安卓)
hGlobal.UI.InitBattlefieldOperateUI_IPA = function()
	if g_phone_mode==3 then
		--安卓
	else
		return
	end

	local _CODE_DragOprGrid = hApi.DoNothing
	local _CODE_DropOprGrid = hApi.DoNothing

	local _BF_DefaultViewPos = nil
	local _OPR_DragRect = {0,0,0,0}
	local _OPR_AutoAlign = {"V","SkillGrid",0,30,-30}
	local _OPR_BtnWH = 82
	local _OPR_GridShow = 6
	local _OPR_GridXYWH = {56,-56,110,math.floor(hVar.SCREEN.h/_OPR_GridShow)}
	local _OPR_FrmXYWH = {hVar.SCREEN.w-112,hVar.SCREEN.h,120,960}
	local _OPR_FrmExXYWH = {0,hVar.SCREEN.h,140,960}
	local _OPR_OptionBtn = {
	}
	local _OPR_LastHitTick = 0
	local _OPR_LastReleaseTick = 0
	local _OPR_EnableOpr = 0
	local _BF_LastOprUnit = {}
	local _BF_LastOprWorld = {}
	
	local tFunc
	local _FrmBG
	local _childUI
	local _FrmEx

	hGlobal.UI.BF_OperatePanel = hUI.frame:new({
		x = _OPR_FrmXYWH[1],
		y = _OPR_FrmXYWH[2],
		z = -1,
		w = _OPR_FrmXYWH[3],
		h = _OPR_FrmXYWH[4],
		dragable = 0,
		autoactive = 0,
		closebtn = 0,
		background = 1,
		border = 0,
		show = 0,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			local tState = {state=0}
			local x = tTempPos.tx - self.data.x
			local y = tTempPos.ty - self.data.y
			local nSkillId,oUnit,oWorld,oGrid,oBtn = tFunc.GetOprData(x,y)
			if nSkillId then
				local nUnitId = oUnit.data.id
				hApi.addTimerOnce("__BF__ShowSkillHint",600,function()
					if tState.state==0 then
						tState.state = 2
						hGlobal.event:event("LocalEvent_ShowSkillInfoFram",nUnitId,nSkillId,150,600)
					end
				end)
			end
			return self:pick("SkillGrid",_OPR_DragRect,tTempPos,{_CODE_DragOprGrid,_CODE_DropOprGrid,tState})
		end,
	})
	tFunc = __CODE__InitSkillOprFunc(_OPR_OptionBtn)
	_FrmBG = hGlobal.UI.BF_OperatePanel
	_childUI = _FrmBG.childUI
	--创建子ui
	do
		_FrmBG.childUI["siderBar"] = hUI.image:new({
			parent = _FrmBG.handle._n,
			model = "panel/panel_part_09.png",
			y = -1*(_FrmBG.data.h/2),
			w = _FrmBG.data.h+100,
			h = 16,
		})
		_FrmBG.childUI["siderBar"].handle.s:setRotation(-90)

		_FrmEx = hUI.frame:new({
			x = _OPR_FrmExXYWH[1],
			y = _OPR_FrmExXYWH[2],
			z = -1,
			w = _OPR_FrmExXYWH[3],
			h = _OPR_FrmExXYWH[4],
			dragable = 2,
			autoactive = 0,
			closebtn = 0,
			background = 1,
			border = 0,
			show = 0,
			buttononly = 1,
		})
		_childUI["FrmEx"] = _FrmEx
		
		_FrmEx.childUI["siderBar"] = hUI.image:new({
			parent = _FrmEx.handle._n,
			model = "panel/panel_part_09.png",
			x = _FrmEx.data.w,
			y = -1*(_FrmEx.data.h/2),
			w = _FrmEx.data.h+100,
			h = 16,
		})
		_FrmEx.childUI["siderBar"].handle.s:setRotation(90)

		local tUIHandle = {}
		local tUIList = {
			{"button","btnGuard",{{"UI:BTN_ControlButton","guard"}},{-48,48,-1,-1,0.8,1},function(self) tFunc.GetOptionCode("codeOpr")(self,hVar.GUARD_SKILL_ID) end},
			{"button","btnWait",{{"UI:BTN_ControlButton","wait"}},{-128,48,-1,-1,0.8,1},function(self) tFunc.GetOptionCode("codeOpr")(self,hVar.WAIT_SKILL_ID) end},
			{"button","btnGrid",{{"UI:BTN_ControlButton","grid"}},{-200,34,-1,-1,0.8,1},function(self) tFunc.GetOptionCode("btnGrid")(self) end},
			{"button","btnSurrender",{{"UI:BTN_ControlButton","surrender"}},{-264,34,-1,-1,0.8,1},function(self) tFunc.GetOptionCode("btnSurrender")(self) end},
		}
		hUI.CreateMultiUIByParam(_FrmEx,_FrmEx.data.w+1024,-1*hVar.SCREEN.h,tUIList,tUIHandle,hUI.MultiUIParamByFrm(_FrmEx))
	end
	--出战场隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__BF__HideBFOprFrm",function(sSceneType,oWorld,oMap)
		if sSceneType=="battlefield" then
			if _BF_DefaultViewPos then
				hApi.setViewNodeFocus(_BF_DefaultViewPos[1],_BF_DefaultViewPos[2])
			end
		else
			_FrmEx:show(0)
			_FrmBG:show(0)
		end
	end)
	--进战场显示操作面板
	hGlobal.event:listen("Event_BattlefieldStart","__BF__ShowBFOprFrm",function(oWorld)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		tFunc.UpdateGridUI()
		_FrmEx:show(1)
		_FrmBG:show(1)
		hApi.SetObjectEx(_BF_LastOprWorld,oWorld)
		if _FrmEx.childUI["btnGrid"] then
			tFunc.GetOptionCode("btnGrid","setColor")(_FrmEx.childUI["btnGrid"])
		end
	end)

	--出战场隐藏操作面板，清理数据
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__HideBFOprFrm",function(oPlayer)
		hApi.SetObjectEx(_BF_LastOprUnit,nil)
		hApi.SetObjectEx(_BF_LastOprWorld,nil)
		tFunc.UpdateGridUI()
	end)

	--激活单位时设置数据
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__SetLocalOprTarget",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		if oUnit:getcontroller()==hGlobal.LocalPlayer then
			hApi.SetObjectEx(_BF_LastOprUnit,oUnit)
			tFunc.UpdateOprUnitSkill(oUnit)
			_OPR_EnableOpr = 1
		else
			_OPR_EnableOpr = 0
			hApi.SetObjectEx(_BF_LastOprUnit,nil)
			tFunc.UpdateGridUI()
		end
	end)
	--如果转换为移动操作，需要调整BF_OperateBar
	hGlobal.event:listen("LocalEvent_PlayerSwitchOprBF","__BF__SwitchBFOprFrmUI",function(oWorld,nSkillId)
		local oGrid = _childUI["SkillGrid"]
		if oGrid and oGrid.data.buttonNum>0 then
			for i = 1,oGrid.data.buttonNum do
				local oBtn = oGrid.childUI["btn_"..i]
				if oBtn and oBtn.data.userdata==nSkillId then
					tFunc.ChooseOprBtn(oGrid,oBtn)
				end
			end
		end
	end)
	--------------------------------------
	-- 功能函数
	tFunc.UpdateOprUnitSkill = function(oUnit)
		print("UpdateOprUnitSkill", 2)
		local tSkill = {}
		local nAttackId = hApi.GetDefaultSkill(oUnit)
		if nAttackId~=0 then
			tSkill[#tSkill+1] = {nAttackId}
		end
		oUnit:enumskill(function(sData)
			local id,lv,cd,count = unpack(sData)
			local tabS = hVar.tab_skill[id]
			if tabS and id>0 and count>=0 and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT) then
				tSkill[#tSkill+1] = {id}
			end
		end)
		if #tSkill==0 then
			tSkill[#tSkill+1] = {hVar.MOVE_SKILL_ID}
		end
		local moveH = math.max(0,#tSkill*_OPR_GridXYWH[4]-hVar.SCREEN.h)
		local nScroll = _OPR_AutoAlign[4]
		_OPR_DragRect[1] = _OPR_GridXYWH[1]
		_OPR_DragRect[2] = _OPR_GridXYWH[2] + nScroll + moveH
		_OPR_DragRect[4] = moveH + 2*nScroll
		tFunc.UpdateGridUI(oUnit,tSkill,{_OPR_GridXYWH[1],_OPR_GridXYWH[2],_OPR_BtnWH,_OPR_BtnWH,_OPR_GridXYWH[3],_OPR_GridXYWH[4]})
	end

	_CODE_DragOprGrid = function(self,tTempPos,tPickParam)
		if tPickParam.state==1 then
		elseif tPickParam.state==2 then
			return 0
		elseif (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>574 then
			tTempPos.tx = tTempPos.x
			tTempPos.ty = tTempPos.y
			tPickParam.state = 1
		else
			return 0
		end
	end

	_CODE_DropOprGrid = function(self,tTempPos,tPickParam)
		local nState = tPickParam.state
		tPickParam.state = -1
		if nState==1 then
			self:aligngrid(_OPR_AutoAlign,_OPR_DragRect,tTempPos)
		elseif nState==2 then
			--已经显示了提示，什么都不做
		elseif _OPR_EnableOpr==1 then
			local nCurTick = hApi.gametime()
			local oGrid = _childUI["SkillGrid"]
			if oGrid then
				local x = tTempPos.tx - _FrmBG.data.x
				local y = tTempPos.ty - _FrmBG.data.y
				local nSkillId,oUnit,oWorld,oGrid,oBtn = tFunc.GetOprData(x,y)
				if nSkillId then
					if oUnit.attr.stun>0 and nCurTick-_OPR_LastReleaseTick<=500 then
						--眩晕状态特殊处理(双击跳过操作)
						hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
					elseif nSkillId==hVar.WAIT_SKILL_ID then
						--特殊处理等待命令
						local case = tFunc.ChooseOprBtn(oGrid,oBtn)
						if case==1 then
							hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,hVar.WAIT_SKILL_ID,nil)
						elseif case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
							hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_WAIT,oUnit,hVar.ZERO,nil,oUnit.data.gridX,oUnit.data.gridY)
						end
					else
						local tabS = hVar.tab_skill[nSkillId]
						local case = tFunc.ChooseOprBtn(oGrid,oBtn)
						local nAttackId = hApi.GetDefaultSkill(oUnit)
						if case==0 then
							--无法释放什么都不做
						elseif case==1 or (nSkillId==hVar.MOVE_SKILL_ID or nSkillId==nAttackId) then
							oBtn:setstate(2)
							hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
						elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
							--自我施放类技能的特殊操作
							oBtn:setstate(2)
							if case==2 and nCurTick-_OPR_LastReleaseTick<=500 then
								hApi.BF_ConfirmSkillOpr(nil,nSkillId)
							end
						end
					end
				end
			end
			_OPR_LastReleaseTick = nCurTick
		end
	end
end
