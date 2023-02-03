if g_lua_src == 1 then return end

hGlobal.UI.InitQuestFrm = function()
	--需要英雄头像才能看到
	if hGlobal.UI.HeroFrame==nil then
		return
	end
	local _QF_LabelOffX = {0,0}	--任务文字，数字的X偏移量
	local _QF_iconWH = 24
	local _QF_LabelSize = 18
	local _QF_FrmW = 180
	local _QF_FrmH = 300
	if g_phone_mode==1 then
		--IP4
		_QF_iconWH = 34
		_QF_LabelSize = 22
		_QF_FrmW = 220
		_QF_FrmH = 280
		_QF_LabelOffX[1] = 0
		_QF_LabelOffX[2] = 0
	elseif g_phone_mode==2 then
		--IP5
		_QF_iconWH = 36
		_QF_LabelSize = 24
		_QF_FrmW = 240
		_QF_FrmH = 300
	end
	local frmH = hGlobal.UI.HeroFrame
	local _ShowQuestFrame = hApi.DoNothing
	local _ShowQuestHint = hApi.DoNothing
	local _FocusQuestTarget = hApi.DoNothing
	local _ShowRewardTip = hApi.DoNothing
	if frmH.childUI["QuestBtn"]==nil then
		local btnX,btnY = 6,70
		if g_lua_src ==1 then
			btnX,btnY = -480,140
		end
		frmH.childUI["QuestBtn"] = hUI.button:new({
			parent = frmH.handle._n,
			dragbox = frmH.childUI["dragBox"],
			model = "ICON:Imperial_Academy",
			scaleT = 0.8,
			y = btnY,
			x = btnX,
			code = function()
				if g_lua_src ~= 1 then  
					_ShowQuestFrame()
				else
					local oWorld = hGlobal.LocalPlayer:getfocusworld()
					hGlobal.event:event("LocalEvent_ShowQuestExFrm",oWorld)
				end
			end,
		})
		
	end

	hGlobal.event:listen("Event_NewDay","_ShowQuestFrame",function(nDayCount)
		if nDayCount>0 then
			if hGlobal.UI.QuestFrame.data.show == 1 then
				_ShowQuestFrame()
			end
		end
	end)

	if hGlobal.UI.QuestFrame~=nil then
		hGlobal.UI.QuestFrame:del()
		hGlobal.UI.QuestFrame = nil
	end
	if hGlobal.UI.QuestHint~=nil then
		hGlobal.UI.QuestHint:del()
		hGlobal.UI.QuestHint = nil
	end

	local _frmX,_frmY = hVar.SCREEN.w-780,hVar.SCREEN.h-40
	if g_lua_src ~= 1 then  
		_frmX,_frmY = hVar.SCREEN.w - _QF_FrmW - 96,hVar.SCREEN.h - 96 - _QF_iconWH
	end
	hGlobal.UI.QuestFrame = hUI.frame:new({
		--x = hVar.SCREEN.w - _QF_FrmW - 96,
		--y = hVar.SCREEN.h - 96 - _QF_iconWH,
		x = _frmX,
		y = _frmY,
		w = _QF_FrmW,
		h = _QF_FrmH,
		z = -999,
		autoactive = 0,
		dragable = 2,
		buttononly = 1,
		background = -1,
		show = 0,
		child = {
			{
				__UI = "image",
				__NAME = "titleM",
				model = "misc/selectbg.png",
				x = _QF_FrmW/2,
				y = math.floor(_QF_iconWH*2/3),
				w = _QF_FrmW,
				h = _QF_iconWH,
			},
			{
				__UI = "label",
				__NAME = "titleS",
				text = hVar.tab_string["__ExtraQuest__"],
				border = 1,
				x = _QF_FrmW/2,
				y = math.floor(_QF_iconWH*2/3),
				font = hVar.FONTC,
				size = _QF_LabelSize,
				align = "MC",
			},
		},
	})

	hGlobal.UI.QuestHint = hUI.frame:new({
		x = 325,
		y = 289,
		closebtn = "BTN:PANEL_CLOSE",
		background = "UI:PANEL_INFO_MINI",
		closebtnX = 378,
		closebtnY = -34,
		show = 0,
		dragable = 2,
		codeOnTouch = function(self,x,y)
			local g = self.childUI["RewardGrid"]
			if g~=nil then
				--任务奖励提示
				local gx,gy,id = g:xy2grid(x,y,"parent")
				if id then
					if g.data.tab==hVar.tab_item then
						if hVar.tab_item[id] then
							local TokenItem = {{id,0}}
							local nSlotNum = hApi.GetQuestRewardItemSlotNum(id)
							if nSlotNum>0 then
								TokenItem[1][3] = hApi.NumTable(nSlotNum+1)
								TokenItem[1][3][1] = nSlotNum
							end
							if g_phone_mode ~= 0 then
								hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",0)
							else
								hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",0)
							end
							return hGlobal.event:event("LocalEvent_ShowItemTipFram",TokenItem,nil,1)
						end
					elseif g.data.tab==hVar.tab_tactics then
						if hVar.tab_tactics[id] then
							hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
							if g_phone_mode ~= 0 then
								hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",id,1,550,620,0,0)
							else
								return hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",id,1,550,620,0,0)
							end
						end
					end
				end
				hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
				if g_phone_mode ~= 0 then
					hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",0)
				else
					hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",0)
				end
			end
		end,
		codeOnClose = function()
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			if g_phone_mode ~= 0 then
				hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",0)
			else
				hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",0)
			end
		end,
		child = {
			--任务目标图标
			{
				__UI = "image",
				__NAME = "TargetSlot",
				x = 68,
				y = -68,
				w = 64,
				h = 64,
				model = "UI_frm:slot",
				animation = "lightSlim",
			},
			{
				__UI = "image",
				__NAME = "TargetIcon",
				x = 68,
				y = -88,
				w = 92,
				h = 92,
				smartWH = 1,
				model = "MODEL:Default",
			},
			{
				__UI = "label",
				__NAME = "TargetName",
				font = hVar.FONTC,
				align = "MC",
				size = 24,
				x = 68,
				y = -115,
				text = "unknown",
				border = 1,
			},
			{
				__UI = "button",
				__NAME = "FocusBtn",
				x = 93,
				y = -214,
				w = 118,
				h = 38,
				label = {
					text = hVar.tab_string["__LOOK_AT__"],
					font = hVar.FONTC,
					size = 26,
					border = 1,
				},
				model = "UI:ButtonBack2",
				scaleT = 0.95,
				code = function()
					_FocusQuestTarget()
				end,
			},
			{
				__UI = "label",
				__NAME = "QuestDetial",
				font = hVar.FONTC,
				align = "LT",
				size = 26,
				width = 256,
				x = 116,
				y = -40,
				--text = "sample quest",
				text = "unknown",
				border = 1,
			},
		},
	})
	local frmQ = hGlobal.UI.QuestFrame
	local frmQH = hGlobal.UI.QuestHint
	local nQuestCount = 0
	local tQuestList = {}
	local _LastSelectedQuest
	_ShowQuestFrame = function()
		_LastSelectedQuest = nil
		if frmQ.data.show==1 then
			hVar.OPTIONS.IS_SHOW_QUEST_LIST = 0
			frmQ:show(0)
			frmQH:show(0)
		else
			hVar.OPTIONS.IS_SHOW_QUEST_LIST = 1
			frmQ:show(1)
		end
	end
	_ShowRewardTip = function()
		--if _LastSelectedQuest~=nil and hVar.tab_item[_LastSelectedQuest[6]] then
			--hGlobal.event:event("LocalEvent_ShowItemTipFram",{{_LastSelectedQuest[6]}},nil,1,600,700)
		--end
	end
	--{nState,nMin,nMax,uUnique,text,reward}
	_FocusQuestTarget = function(tQuest)
		local w = hGlobal.WORLD.LastWorldMap
		if tQuest==nil then
			tQuest = _LastSelectedQuest
		end
		if tQuest~=nil and type(tQuest[4])=="table" and hGlobal.WORLD.LastWorldMap~=nil then
			--兼容旧存档，待修改
			local u
			local tgrID = tQuest[4][4]
			if tgrID~=nil then
				u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tgrID)
			else
				u = hClass.unit:find(tQuest[4][1])
				if u and u.__ID~=tQuest[4][2] then
					u = nil
				end
			end
			if u~=nil then
				local Visible = 1
				local vu = u
				if u.data.IsHide==1 then
					Visible = 0
					--是守卫吗？
					if u.data.curTown and u.data.curTown~=0 then
						local oTown = hClass.town:find(u.data.curTown)
						if oTown and oTown:getunit("guard")==vu then
							vu = oTown:getunit()
							Visible = 1
						end
					end
				end
				if vu and Visible==1 then
					local cx,cy = vu:getXY()
					if cx and cy then
						hApi.setViewNodeFocus(cx,cy)
					end
					local w = vu:getworld()
					if w and w.handle.worldLayer and w.worldUI["HintOfQuestTarget"]==nil then
						--local bx,by = vu:getbox()
						local panel = hUI.panel:new({
							world = w,
							bindTag = "HintOfQuestTarget",
							x = cx,
							y = cy,
							tick = 1400,
							child = {
								{
									__UI = "image",
									__NAME = "HintIcon",
									mode = "image",
									model = "ui/pointer.png",
									align = "MB",
									--w = 32,
									--h = 32,
									--y = -1*by+28,
								},
							},
						})
						local a = CCArray:create()
						a:addObject(CCFadeIn:create(0.1))
						a:addObject(CCDelayTime:create(1.0))
						a:addObject(CCFadeOut:create(0.25))
						panel.childUI["HintIcon"].handle.s:runAction(CCSequence:create(a))
					end
				end
			end
		end
	end
	local _ClearAllQuest = function()
		for i = nQuestCount,1,-1 do
			tQuestList[i] = nil
			local btn = frmQ.childUI["QuestBtn_"..i]
			if btn then
				btn:del()
				frmQ.childUI["QuestBtn_"..i] = nil
			end
		end
		_LastSelectedQuest = nil
		nQuestCount = 0
		frmQ.childUI["dragBox"]:sortbutton()
	end
	--{nState,nMin,nMax,uUnique,text,reward}
	local _AddQuestBtn = function(tQuest)
		nQuestCount = nQuestCount + 1
		tQuestList[nQuestCount] = tQuest
		local text = hApi.ConvertMapString(tQuest[5],1) or "unknown"
		local icon = 0
		local sRewardType = "ITEM"
		if type(tQuest[4])=="table" then
			sRewardType = tQuest[4][6] or "ITEM"
		end
		if sRewardType=="TACTIC_CARD" then
			--奖励模式为战术技能卡
			local tacticId = tQuest[6]
			if tacticId~=0 and hVar.tab_tactics[tacticId] then
				icon = hVar.tab_tactics[tacticId].icon or 0
			end
		else
			--奖励模式为物品
			local itemId = tQuest[6]
			if itemId~=0 and hVar.tab_item[itemId] then
				icon = hVar.tab_item[itemId].icon or 0
			end
		end
		local nMin = tQuest[2]
		local nMax = tQuest[3]
		local NextOpr = 0
		local LastClickCount = 0
		local btn = hUI.button:new({
			parent = frmQ.handle._n,
			dragbox = frmQ.childUI["dragBox"],
			x = frmQ.data.w/2+_QF_LabelOffX[1],
			y = -1*_QF_iconWH/2-(nQuestCount-1)*(_QF_iconWH+4),
			w = frmQ.data.w-_QF_LabelOffX[1],
			h = _QF_iconWH+4,
			model = -1,
			codeOnTouch = function()
				local tick = hApi.gametime()
				if frmQH.data.show==1 and _LastSelectedQuest==tQuest then
					--if tick-LastClickCount<=500 then
						--_FocusQuestTarget()
					--end
					--LastClickCount = tick
					_LastSelectedQuest = nil
					frmQH:show(0)
				else
					_LastSelectedQuest = tQuest
					--if tick-LastClickCount<=500 then
						--_FocusQuestTarget()
					--end
					--LastClickCount = tick
					_ShowQuestHint(tQuest,sRewardType)
				end
			end,
		})
		frmQ.childUI["QuestBtn_"..nQuestCount] = btn
		if icon~=0 then
			btn.childUI["icon"] = hUI.image:new({
				parent = btn.handle._n,
				model = icon,
				w = _QF_iconWH,
				h = _QF_iconWH,
				smartWH = 1,
				x = 4+_QF_iconWH/2-frmQ.data.w/2,
			})
		end
		--一般任务
		local RGB
		--唯一任务
		if type(tQuest[4])=="table" and (tQuest[4][5] or 0)~=0 then
			RGB = {255,200,0}
		else
			RGB = {128,255,0}
		end
		btn.childUI["label"] = hUI.label:new({
			parent = btn.handle._n,
			text = text,
			size = _QF_LabelSize,
			RGB = RGB,
			border = 1,
			font = hVar.FONTC,
			align = "LC",
			x = 8+_QF_iconWH-frmQ.data.w/2,
		})
		btn.childUI["num"] = hUI.label:new({
			parent = btn.handle._n,
			text = nMin.."/"..nMax,
			RGB = RGB,
			border = 1,
			size = _QF_LabelSize,
			font = hVar.FONTC,
			--font = "numGreen",
			--size = 12,
			align = "RC",
			x = frmQ.data.w/2-12+_QF_LabelOffX[2],
		})
	end
	--{nState,nMin,nMax,uUnique,text,reward}
	local _UpdateAllQuest = function()
		for i = 1,nQuestCount do
			local btn = frmQ.childUI["QuestBtn_"..i]
			if btn and btn.childUI["num"] then
				local tQuest = tQuestList[i]
				local nMin,nMax = tQuest[2],tQuest[3]
				if tQuest[1]>1 or nMin>=nMax then
					btn.childUI["num"]:del()
					btn.childUI["num"] = nil
					btn.childUI["sus"] = hUI.image:new({
						parent = btn.handle._n,
						x = frmQ.data.w/2-12-9+_QF_LabelOffX[2],
						model = "UI:finish",
						align = "RC",
						h = 18,
					})
				else
					btn.childUI["num"]:setText(nMin.."/"..nMax)
				end
			end
		end
		if nQuestCount>0 then
			frmH.childUI["QuestBtn"]:setstate(1)
		else
			frmH.childUI["QuestBtn"]:setstate(-1)
		end
	end

	--游戏创建时初始化列表
	hGlobal.event:listen("Event_WorldCreated","__InitWorldQuestList",function(oWorld,IsCreatedFromLoad)
		if oWorld.data.type=="worldmap" then
			--frmQ:show(0)
			_ClearAllQuest()
			local UniqueQuest = {}
			local NormalQuest = {}
			if type(oWorld.data.QuestList)=="table" then
				for i = 1,#oWorld.data.QuestList do
					local v = oWorld.data.QuestList[i]
					if type(v)=="table" and type(v[4])=="table" and (v[4][5] or 0)~=0 then
						UniqueQuest[#UniqueQuest+1] = v
					else
						NormalQuest[#NormalQuest+1] = v
					end
				end
				for i = 1,#UniqueQuest do
					if g_lua_src == 1 then return end
					_AddQuestBtn(UniqueQuest[i])
				end
				for i = 1,#NormalQuest do
					if g_lua_src == 1 then return end
					_AddQuestBtn(NormalQuest[i])
				end
			end
			if g_lua_src == 1 then return end
			_UpdateAllQuest()
		end
	end)

	--切地图隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__HideWorldQuestList",function(sSceneType,oWorld,oMap)
		if sSceneType=="worldmap" then
			if nQuestCount>0 and hVar.OPTIONS.IS_SHOW_QUEST_LIST==1 then
				frmQ:show(1)
			end
		else
			frmQ:show(0)
			frmQH:show(0)
		end
	end)

	--刷新任务
	hGlobal.event:listen("LocalEvent_UpdateMapQuest","__UpdateWorldQuestList",function(oWorld)
		if g_lua_src == 1 then return end
		_UpdateAllQuest()
	end)

	hGlobal.event:listen("LocalEvent_HeroInfoFram","__HideWorldQuestHint_OnHeroInfoFram",function()
		frmQH:show(0)
	end)

	hGlobal.event:listen("LocalEvent_ShowTalkFrm","__HideWorldQuestHint_OnHeroInfoFram",function()
		frmQH:show(0)
	end)
	local _GetRewardItemIconTab = function(sRewardType)
		if sRewardType=="TACTIC_CARD" then
			return hVar.tab_tactics,"icon"
		else
			return hVar.tab_item,"icon"
		end
	end
	local _GetRewardItemBG = function(id,sRewardType)
		if sRewardType=="TACTIC_CARD" then
			if hVar.tab_tactics[id] then
				local tacticLv = hVar.tab_tactics[id].level
				if hVar.BFSKILL_QUALITY[tacticLv] then
					local bgLv = hVar.BFSKILL_QUALITY[tacticLv][1] or 1
					return hVar.ITEMLEVEL[bgLv].BACKMODEL or hVar.ITEMLEVEL[1].BACKMODEL
				end
			end
		else
			if hVar.tab_item[id] then
				local itemLv = hVar.tab_item[id].itemLv or 1
				return hVar.ITEMLEVEL[itemLv].BACKMODEL or hVar.ITEMLEVEL[1].BACKMODEL
			end
		end
	end
	local _GetRewardItemHint = function(tItemGrid,sRewardType)
		local HintText = ""
		local itemCount = {}
		for i = 1,#tItemGrid do
			local id = tItemGrid[i]
			itemCount[id] = (itemCount[id] or 0) + 1
		end
		for i = 1,#tItemGrid do
			local id = tItemGrid[i]
			if itemCount[id]~=-1 then
				local itemName
				if sRewardType=="TACTIC_CARD" then
					itemName = (hVar.tab_stringT[id][1] or "tac_"..id).." lv1"
				else
					itemName = hVar.tab_stringI[id][1] or "item_"..id
				end
				if i==1 then
					HintText = HintText..itemName
				else
					HintText = HintText..","..itemName
				end
				if type(itemCount[id])=="number" then
					if itemCount[id]~=1 then
						HintText = HintText.."x"..itemCount[id]
					end
					itemCount[id] = -1
				end
			end
		end
		return HintText
	end
	--{nState,nMin,nMax,uUnique,text,reward}
	local _LastQuest
	_ShowQuestHint = function(tQuest,sRewardType)
		if hVar.tab_stringM[tQuest[5]] then
			frmQH:onscreen(64)
			frmQH:show(1)
			frmQH:active()
			if _LastQuest~=tQuest then
				_LastQuest = tQuest
				hApi.safeRemoveT(frmQH.childUI,"RewardGrid")
				hApi.safeRemoveT(frmQH.childUI,"RewardHint")
				local tItemGrid = {}
				for i = 6,#tQuest do
					tItemGrid[#tItemGrid+1] = tQuest[i]
				end
				if #tItemGrid>0 then
					local slotW = 64
					local plusY = 0
					if #tItemGrid>2 then
						plusY = 22
					end
					local tItemDataTab,sItemIconKey = _GetRewardItemIconTab(sRewardType)
					local HintText = hVar.tab_string["__Reward__"]..":".._GetRewardItemHint(tItemGrid,sRewardType)
					frmQH.childUI["RewardHint"] = hUI.label:new({
						parent = frmQH.handle._n,
						x = 270,
						y = -210+plusY,
						font = hVar.FONTC,
						text = HintText,
						size = 24,
						width = 230,
						border = 1,
						align = "MT",
					})
					frmQH.childUI["RewardGrid"] = hUI.grid:new({
						parent = frmQH.handle._n,
						x = 270-(#tItemGrid-1)*slotW/2,
						y = -180+plusY,
						tab = tItemDataTab,
						tabModelKey = sItemIconKey,
						grid = tItemGrid,
						iconW = 42,
						iconH = 42,
						gridW = slotW,
						gridH = 64,
						codeOnImageCreate = function(self,id,s,gx,gy)
							local bgModel = _GetRewardItemBG(id,sRewardType)
							if bgModel==nil then
								return
							end
							local x,y = s:getPosition()
							self.childUI["slot_"..gx] = hUI.image:new({
								parent = self.handle._n,
								x = x,
								y = y,
								w = self.data.iconW+6,
								h = self.data.iconH+6,
								z = -1,
								model = bgModel,
							})
						end,
					})
				end
			end
			local HintDetail = hApi.ConvertMapString(tQuest[5],2)
			if HintDetail then
				frmQH.childUI["QuestDetial"].handle._n:setVisible(true)
				frmQH.childUI["QuestDetial"]:setText(HintDetail)
			else
				frmQH.childUI["QuestDetial"].handle._n:setVisible(false)
			end
			local unitId = tQuest[4]
			local CanFocus = -1
			if type(tQuest[4])=="table" and hGlobal.WORLD.LastWorldMap~=nil then
				CanFocus = 0
				unitId = tQuest[4][3]
				--兼容旧存档，待修改
				local u
				local tgrID = tQuest[4][4]
				if tgrID~=nil then
					u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tgrID)
				else
					u = hClass.unit:find(tQuest[4][1])
					if u and u.__ID~=tQuest[4][2] then
						u = nil
					end
				end
				if u~=nil then
					CanFocus = 1
					if tQuest[4][3]==nil then
						tQuest[4][3] = u.data.id
						unitId = u.data.id
					end
				end
			end
			frmQH.childUI["FocusBtn"]:setstate(CanFocus)
			if unitId and hVar.tab_unit[unitId] then
				local model = hVar.tab_unit[unitId].model or "MODEL:Default"
				local name
				if hVar.tab_stringU[unitId] then
					name = hVar.tab_stringU[unitId][1]
				else
					name = "unit_"..unitId
				end
				frmQH.childUI["TargetIcon"].handle._n:setVisible(true)
				frmQH.childUI["TargetName"].handle._n:setVisible(true)
				frmQH.childUI["TargetIcon"]:setmodel(model,"stand",180)
				frmQH.childUI["TargetName"]:setText(name)
			else
				frmQH.childUI["TargetIcon"].handle._n:setVisible(false)
				frmQH.childUI["TargetName"].handle._n:setVisible(false)
			end
		end
	end
end