hGlobal.UI.InitQuestExFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowQuestExFrm","__QuestExFrm"}
	--if mode~="include" then
		--return tInitEventName
	--end
	local _w,_h = 730,530	-- frm 的宽高
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 30	-- frm 的x y
	local _frm_off_Y = 86		-- frm 要移动到的位置
	local _MoveActionPosY = {_frm_off_Y,_y}		-- 根据移动类型 判断移动的坐标
	
	local questInfoX,questInfoY = 340,-46

	local _runAction = hApi.DoNothing
	local _moveType = 1		--移动动画的类型

	local _frm = nil
	local _parent = nil
	local _childUI = nil

	--退出时 删除临时创建的任务列表
	local _removelist = {}
	local _exitFunc = function()
		for i = 1,#_removelist do
			hApi.safeRemoveT(_childUI,_removelist[i]) 
		end
		_removelist = {}
	end

	hGlobal.UI.QuestExFrm = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		--changed by pangyong 2015/3/5 
		--dragable = 2,
		dragable = 3,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		background = "UI:tip_item",
		closebtnX = _w - 10,
		closebtnY = -14,
		border = 1,
		autoactive = 0,
		child = {
			--任务目标图标
			
			{	--任务奖励 lab
				__UI = "label",
				__NAME = "__target__",
				font = hVar.FONTC,
				align = "LT",
				size = 28,
				width = 400,
				RGB = {0,255,0},
				x = questInfoX + 12,
				y = questInfoY,
				text = hVar.tab_string["__target__"],
				border = 1,
			},

			{	--任务目标 背景
				__UI = "image",
				__NAME = "TargetSlot",
				x = questInfoX + 44,
				y = questInfoY + -72,
				w = 64,
				h = 64,
				model = "UI_frm:slot",
				animation = "lightSlim",
			},
			{	--任务目标 icon
				__UI = "image",
				__NAME = "TargetIcon",
				x = questInfoX + 44,
				y = questInfoY + -92,
				w = 92,
				h = 92,
				smartWH = 1,
				model = "MODEL:Default",
			},
			{	--任务目标名字
				__UI = "label",
				__NAME = "TargetName",
				font = hVar.FONTC,
				align = "MC",
				size = 24,
				x = questInfoX + 44,
				y = questInfoY + -119,
				text = "unknown",
				border = 1,
			},
			{	--任务细节 lab
				__UI = "label",
				__NAME = "QuestDetial",
				font = hVar.FONTC,
				align = "LT",
				size = 24,
				width = 300,
				x = questInfoX + 90,
				y = questInfoY + -44,
				text = "unknown",
				border = 1,
			},
			{	--任务奖励 lab
				__UI = "label",
				__NAME = "Quest_Reward",
				font = hVar.FONTC,
				align = "LT",
				size = 24,
				width = 400,
				x = questInfoX,
				y = questInfoY + -380,
				text = hVar.tab_string["__TEXT_Quest_Reward"],
				border = 1,
			},

			{	--任务奖励 lab
				__UI = "label",
				__NAME = "Quest_Reward_title",
				font = hVar.FONTC,
				align = "LT",
				size = 28,
				width = 400,
				x = questInfoX + 10,
				y = questInfoY + -276,
				text = hVar.tab_string["__Reward__"],
				RGB = {0,255,0},
				border = 1,
			},
			
		},

		codeOnTouch = function(self,x,y)
			if _moveType == 1 then
				_runAction({})
			end

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

		codeOnClose = function(self)
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			if g_phone_mode ~= 0 then
				hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",0)
			else
				hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",0)
			end
		end,
	})

	_frm = hGlobal.UI.QuestExFrm
	_parent = _frm.handle._n
	_childUI = _frm.childUI

	--中界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2 - 44,
		y = -_h/2,
		w = _h - 8,
		h = 8,
	})
	_childUI["apartline_back"].handle.s:setRotation(-90)

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
	
	--创建任务目标详细内容，部分代码 参考李宁的 questfrm
	local _creatQuestItemInfo = function(QuestItem)
		local icon = 0
		local sRewardType = "ITEM"
		if type(QuestItem[4])=="table" then
			sRewardType = QuestItem[4][6] or "ITEM"
		end
		if sRewardType=="TACTIC_CARD" then
			--奖励模式为战术技能卡
			local tacticId = QuestItem[6]
			if tacticId~=0 and hVar.tab_tactics[tacticId] then
				icon = hVar.tab_tactics[tacticId].icon or 0
			end
		else
			--奖励模式为物品
			local itemId = QuestItem[6]
			if itemId~=0 and hVar.tab_item[itemId] then
				icon = hVar.tab_item[itemId].icon or 0
			end
		end

		--任务细节
		local HintDetail = hApi.ConvertMapString(QuestItem[5],2)
		if HintDetail then
			_childUI["QuestDetial"].handle._n:setVisible(true)
			_childUI["QuestDetial"]:setText(HintDetail)
		else
			_childUI["QuestDetial"].handle._n:setVisible(false)
		end

		-- 任务目标半身像创建
		local unitId = QuestItem[4]
		local CanFocus = -1
		if type(QuestItem[4])=="table" and hGlobal.WORLD.LastWorldMap~=nil then
			CanFocus = 0
			unitId = QuestItem[4][3]
			--兼容旧存档，待修改
			local u
			local tgrID = QuestItem[4][4]
			if tgrID~=nil then
				u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tgrID)
			else
				u = hClass.unit:find(QuestItem[4][1])
				if u and u.__ID~=QuestItem[4][2] then
					u = nil
				end
			end
			if u~=nil then
				CanFocus = 1
				if QuestItem[4][3]==nil then
					QuestItem[4][3] = u.data.id
					unitId = u.data.id
				end
			end
		end
		if unitId and hVar.tab_unit[unitId] then
			local model = hVar.tab_unit[unitId].model or "MODEL:Default"
			
			local name
			if hVar.tab_stringU[unitId] then
				name = hVar.tab_stringU[unitId][1]
			else
				name = "unit_"..unitId
			end
			_childUI["TargetIcon"].handle._n:setVisible(true)
			_childUI["TargetName"].handle._n:setVisible(true)
			local imgW,imgH = hApi.GetUnitImageWH(unitId,92,92)
			imgW = math.min(imgW,92)
			imgH = math.min(imgH,92)

			_childUI["TargetIcon"].handle._n:setPosition(questInfoX + 44,questInfoY + -92)

			if hVar.tab_unit[unitId].questIcon == 1 then
				model =  hVar.tab_unit[unitId].icon
				imgW = 62
				imgH = 62

				_childUI["TargetIcon"].handle._n:setPosition(questInfoX + 44,questInfoY + -72)
			end
			_childUI["TargetIcon"]:setmodel(model,"stand",180,imgW,imgH)
			_childUI["TargetName"]:setText(name)
		else
			_childUI["TargetIcon"].handle._n:setVisible(false)
			_childUI["TargetName"].handle._n:setVisible(false)
		end
		
		--任务奖励
		hApi.safeRemoveT(_childUI,"RewardGrid")
		local tItemGrid = {}
		for i = 6,#QuestItem do
			tItemGrid[#tItemGrid+1] = QuestItem[i]
		end
		if #tItemGrid>0 then
			local slotW = 64
			
			local tItemDataTab,sItemIconKey = _GetRewardItemIconTab(sRewardType)
			local HintText = _GetRewardItemHint(tItemGrid,sRewardType)
			_childUI["Quest_Reward"]:setText(HintText)
			_childUI["RewardGrid"] = hUI.grid:new({
				parent = _parent,
				x = questInfoX + 40,
				y = questInfoY + -340,
				tab = tItemDataTab,
				tabModelKey = sItemIconKey,
				grid = tItemGrid,
				iconW = 52,
				iconH = 52,
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

	--分界线
	--_childUI["apartline_back"] = hUI.image:new({
		--parent = _parent,
		--model = "UI:panel_part_09",
		--x = _w/2,
		--y = -80,
		--w = _w+20,
		--h = 8,
	--})
	
	

	_childUI["apartline_back2"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = questInfoX + 180,
		y = questInfoY - 244,
		w = 400,
		h = 8,
	})

	--地图大任务面板 tip
	_childUI["frmTip"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 160,
		y = -32,
		width = 800,
		text = hVar.tab_string["__TEXT_Map_Quest"],
	})
	
	--任务的选择框
	_childUI["Selectedbox"] = hUI.image:new({
		parent = _parent,
		model = "UI:wk",
		align = "MC",
		z = 2,
		x = 166,
		y = -104,
	})

	local _lastQuestItem = {}
	
	local _moveFuncBack = function()
		if _lastQuestItem~=nil and type(_lastQuestItem[4])=="table" and hGlobal.WORLD.LastWorldMap~=nil then
			--兼容旧存档，待修改
			local u
			local tgrID = _lastQuestItem[4][4]
			if tgrID~=nil then
				u = hGlobal.WORLD.LastWorldMap:tgrid2unit(tgrID)
			else
				u = hClass.unit:find(_lastQuestItem[4][1])
				if u and u.__ID~=_lastQuestItem[4][2] then
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

		_frm:setXY(_x,_MoveActionPosY[_moveType])
		_childUI["dragBox"]:sortbutton()
	end

	--任务面板的下降动画
	_runAction = function(questItem)
		_lastQuestItem = questItem

		--为1 时 是上升动画
		if _moveType == 1 then
			_moveType = 2
		--为2 时 是下降动画
		elseif _moveType == 2 then
			_moveType = 1
		end
		_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(_x,_MoveActionPosY[_moveType])),CCCallFunc:create(_moveFuncBack)))
	end
	
	local _cur_quest = nil
	local nQuestCount = 0
	local tQuestList = {}		--是否有必要保留
	--添加每一条任务	--部分代码来自 李宁的 questfrm 中对每条任务数据的 解析
	local _btnX,_btnY,_btnOffX,_btnOffY = 166,-104,430,76
	local _btnW,_btnH = 306,68
	local _AddQuestItem = function(QuestItem)
		nQuestCount = nQuestCount + 1

		if nQuestCount == 1 then
			_creatQuestItemInfo(QuestItem)
			_cur_quest = QuestItem
		end
		tQuestList[nQuestCount] = QuestItem
		local nodeX,nodeY = _btnX + (nQuestCount-1)%1*_btnOffX,_btnY - math.ceil((nQuestCount-1)/1)*_btnOffY
		local text = hApi.ConvertMapString(QuestItem[5],1) or "unknown"
		local icon = 0
		local sRewardType = "ITEM"
		if type(QuestItem[4])=="table" then
			sRewardType = QuestItem[4][6] or "ITEM"
		end
		if sRewardType=="TACTIC_CARD" then
			--奖励模式为战术技能卡
			local tacticId = QuestItem[6]
			if tacticId~=0 and hVar.tab_tactics[tacticId] then
				icon = hVar.tab_tactics[tacticId].icon or 0
			end
		else
			--奖励模式为物品
			local itemId = QuestItem[6]
			if itemId~=0 and hVar.tab_item[itemId] then
				icon = hVar.tab_item[itemId].icon or 0
			end
		end
		local nMin = QuestItem[2]		--任务的最大完成数
		local nMax = QuestItem[3]		--任务当前完成数

		--一般任务	
		local RGB		--任务名称的 文字颜色， 唯一颜色 是黄色， 重复任务 是绿色
		--唯一任务
		if type(QuestItem[4])=="table" and (QuestItem[4][5] or 0)~=0 then
			RGB = {255,200,0}
		else
			RGB = {128,255,0}
		end

		--创建任务条目的背景底图
		_childUI["QuestBG_"..nQuestCount] = hUI.image:new({
			parent = _parent,
			model = "UI:MADEL_BANNER",
			x = nodeX + 2,
			y = nodeY,
		})
		_removelist[#_removelist+1] = "QuestBG_"..nQuestCount
		
		--每个任务的奖励图片
		_childUI["QuestTitleImg_"..nQuestCount] = hUI.image:new({
			parent = _parent,
			model =  "ICON:Imperial_Academy",
			x = nodeX - 120,
			y = nodeY + 6,
			w = 50,
			h = 50,
		})
		_removelist[#_removelist+1] = "QuestTitleImg_"..nQuestCount

		--每个任务的奖励图片
		_childUI["QuestItem_"..nQuestCount] = hUI.image:new({
			parent = _parent,
			model = icon,
			x = nodeX + 100,
			y = nodeY+2,
			w = 48,
			h = 48,
		})
		_removelist[#_removelist+1] = "QuestItem_"..nQuestCount
		
		local tmp_size = 28
		if LANGUAG_SITTING and LANGUAG_SITTING == 4 then
			tmp_size = 24
		end
		--任务名称
		_childUI["QuestName_"..nQuestCount] = hUI.label:new({
			parent = _parent,
			size = tmp_size,
			align = "LT",
			font = hVar.FONTC,
			border = 1,
			x = nodeX - 80,
			y = nodeY + 14,
			width = 800,
			text = text,
			RGB = RGB,
		})
		_removelist[#_removelist+1] = "QuestName_"..nQuestCount
		
		--创建任务条目的详细信息面板
		_childUI["QuestInfoBtn_"..nQuestCount] = hUI.button:new({
			parent = _parent,
			model = -1,
			dragbox = _childUI["dragBox"],
			x = nodeX,
			y = nodeY,
			w = _btnW,
			h = _btnH,
			code = function(self)
				--hGlobal.event:event("LocalEvent_ShowQuestExInfoFrm",QuestItem)
				_cur_quest = QuestItem
				_creatQuestItemInfo(QuestItem)
				_childUI["Selectedbox"].handle._n:setPosition(self.data.x,self.data.y)
			end,
		})
		_removelist[#_removelist+1] = "QuestInfoBtn_"..nQuestCount

		_childUI["QuestBtn_finish_"..nQuestCount] = hUI.image:new({
			parent = _parent,
			model = "UI:finish",
			x = nodeX + 130,
			y = nodeY - 8,
			z = 2,
			scale = 0.7,
		})
		_childUI["QuestBtn_finish_"..nQuestCount].handle._n:setVisible(false)
		_removelist[#_removelist+1] = "QuestBtn_finish_"..nQuestCount
	end

	--创建任务条目的提醒按钮
	_childUI["QuestBtn_info_pos"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack2",
		dragbox = _childUI["dragBox"],
		label = {
			text = hVar.tab_string["__LOOK_AT__"],
			font = hVar.FONTC,
			size = 26,
			border = 1,
		},
		x = questInfoX + 300,
		y = questInfoY - 210,
		scale = 0.9,
		scaleT = 0.95,
		code = function(self)
			_runAction(_cur_quest)
		end,
	})
	_removelist[#_removelist+1] = "QuestBtn_"..nQuestCount

	--创建传入世界的任务列表
	local _createMapQuest = function(QuestList)
		--从世界中 获取任务
		local UniqueQuest = {}	--唯一任务列表
		local NormalQuest = {}	--一般任务列表
		for i = 1,#QuestList do
			local v = QuestList[i]
			if type(v)=="table" and type(v[4])=="table" and (v[4][5] or 0)~=0 then
				UniqueQuest[#UniqueQuest+1] = v
			else
				NormalQuest[#NormalQuest+1] = v
			end
		end
		
		--创建唯一任务
		for k,v in pairs(UniqueQuest) do
			_AddQuestItem(v)
		end

		--创建一般任务
		for k,v in pairs(NormalQuest) do
			_AddQuestItem(v)
		end

		if nQuestCount == 0 then
			hGlobal.event:event("LocalEvent_SetQuestBtnShow",-1)
		else
			hGlobal.event:event("LocalEvent_SetQuestBtnShow",1)
		end

		_childUI["Selectedbox"].handle._n:setPosition(166,-104)
	end
	
	--地图变量显示
	_childUI["MapVarTip"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 20,
		y = -_h + 60,
		width = 800,
		text = "",
	})
	
	local _tempStr = ""
	_childUI["MapVarTip_Tip"] = hUI.button:new({
		parent = _frm,
		x = 50,
		y = -_h + 50,
		w = 100,
		h = 50,
		model = -1,
		codeOnTouch = function()
			hGlobal.event:event("LocalEvent_showAttributeInfoFrm",400,360,"mapVar",hVar.tab_string[_tempStr][1],hVar.tab_string[_tempStr][2])
		end,
		code = function()
			hGlobal.event:event("LocalEvent_closeAttributeInfoFrm")
		end,
		codeOnDrag = function(self,x,y,sus)
			if sus ~= 1 then
				hGlobal.event:event("LocalEvent_closeAttributeInfoFrm")
			end
		end,
	})
	
	--刷新任务
	local _UpdateAllQuest = function()
		for i = 1,nQuestCount do
			local tQuest = tQuestList[i]
			local nMin,nMax = tQuest[2],tQuest[3]
			--任务已完成 
			if tQuest[1]>1 or nMin>=nMax then
				_childUI["QuestBtn_finish_"..i].handle._n:setVisible(true)
			else

			end

		end
	end

	hGlobal.event:listen("Event_WorldCreated","__CreatQuestExItem",function(oWorld,IsCreatedFromLoad)
		if oWorld.data.type=="worldmap" then
			if oWorld and type(oWorld.data.QuestList) == "table" then 
				_exitFunc()
				nQuestCount = 0
				_createMapQuest(oWorld.data.QuestList)
				_UpdateAllQuest()
			else

			end
		end
	end)
	

	--刷新任务
	hGlobal.event:listen("LocalEvent_UpdateMapQuest","__UpdateWorldQuesExtList",function(oWorld)
		_UpdateAllQuest()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_moveType = 2
		_frm:setXY(_x,_MoveActionPosY[_moveType])
		_childUI["dragBox"]:sortbutton()

		--创建地图变量显示
		local oWorld = hGlobal.WORLD.LastWorldMap
		local mapdata = oWorld:getmapdata(1)
		if type(mapdata) == "table" and type(mapdata["MapVarTip"]) == "table" then
			local tipText,uid,labKey = unpack(mapdata["MapVarTip"])
			_tempStr = tipText
			local unit = hApi.UniqueID2UnitByWorld(uid)
			if unit then
				local oHero = unit:gethero()
				if oHero then
					_childUI["MapVarTip"]:setText(tostring(hVar.tab_string[_tempStr][1]).." : "..tostring(oHero:getGameVar(labKey)))
				end
			end
		else
			_tempStr = ""
			_childUI["MapVarTip"]:setText("")
		end

		_frm:show(1)
		_frm:active()
	end)
end