--------------------------------
-- 战场UI(Ipad)
--------------------------------
--操作条功能函数
local __CODE__InitSkillOprFunc = function()
	local tFunc = {}
	local _tBtnXY2I = {}
	local _tOptionKey = {}

	local _GetBtnName = function(oGrid,gx,gy,nSkillId)
		return _tBtnXY2I[gx.."|"..gy] or 0
	end

	tFunc.UpdateOprUnitSkill = function(oUnit)	--空函数
	end

	tFunc.UpdateGridUI = function(oUnit,tSkill,tGridDetail,tSpreadFrom)
		
		_tBtnXY2I = {}
		local frm = hGlobal.UI.BF_OperatePanel
		hApi.safeRemoveT(frm.childUI,"SkillGrid")
		frm.childUI["dragBox"]:sortbutton()
		if oUnit~=nil then
			print("UpdateGridUI", oUnit.data.name)
			
			local nAttackId = hApi.GetDefaultSkill(oUnit)
			local oBtnDefault
			local nLastChooseId = 0
			local nLastHitTick = 0
			local nLastHitState = 0
			local nHitCount = 0
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
				scaleT = 0.9,
				spreadFrom = tSpreadFrom,
				grid = tSkill,
				dragbox = frm.childUI["dragBox"],
				codeOnTouch = function(nSkillId,oBtn)
					print("codeOnTouch(), nLastHitState = " .. nLastHitState) --geyachao 点击技能按钮
					if nLastChooseId==nSkillId and hApi.gametime()-nLastHitTick<=300 then
						nHitCount = nHitCount + 1
					else
						nHitCount = 0
					end
					nLastHitState = 0
					nLastHitTick = hApi.gametime()
					if hVar.tab_stringS[nSkillId] and hVar.tab_stringS[nSkillId][1] then
						local nTick = nLastHitTick
						local oBtn__ID = oBtn.__ID
						hApi.addTimerOnce("__BF__ShowSkillHint",600,function()
							if nLastHitTick==nTick and nLastHitState==0 and oBtn.__ID==oBtn__ID and oBtn.data.state==2 then
								nLastHitState = 2
								hGlobal.event:event("LocalEvent_ShowSkillInfoFram",oUnit.data.id,nSkillId,150,600)
							end
						end)
					end
				end,
				code = function(nSkillId,oBtn)
					print("code(), nLastHitState = " .. nLastHitState)
					if nLastHitState==2 then
						nLastHitState = 1
						return
					else
						nLastHitState = 1
					end
					local nChooseType = tFunc.ChooseOprBtn(frm.childUI["SkillGrid"],oBtn)
					if nChooseType>0 then
						nLastChooseId = nSkillId
						print("code(), nSkillId = " .. nSkillId)
						local oUnit,oWorld = tFunc.GetOprData()
						print("code(), oUnit = " .. (oUnit and oUnit.data.name or tostring(oUnit)))
						if oUnit and hVar.tab_skill[nSkillId] then
							--print("if oUnit and hVar.tab_skill[nSkillId] then:".. tostring(hApi.gametime()- nLastHitTick).. ",".. tostring(nHitCount))
							--zhenkira 重写，单击释放技能
--							if hVar.tab_skill[nSkillId].cast_type==hVar.CAST_TYPE.IMMEDIATE and hApi.gametime()- nLastHitTick<=300 and nHitCount>=1 then
--								hApi.BF_ConfirmSkillOpr(nil,nSkillId)
--								hApi.BF_ConfirmSkillOpr(nil,nSkillId)
--							else
--								hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
--							end

							local castType = hVar.tab_skill[nSkillId].cast_type
							if castType==hVar.CAST_TYPE.IMMEDIATE or castType==hVar.CAST_TYPE.AUTO then
								--hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,nSkillId,nil,nil,nil)
								hApi.CastSkill(oUnit,nSkillId,-1,nil,nil,nil,nil,nil)
							elseif castType==hVar.CAST_TYPE.SKILL_TO_GRID or castType==hVar.CAST_TYPE.SKILL_TO_UNIT or castType==hVar.CAST_TYPE.BUFF_TO_GRID or castType==hVar.CAST_TYPE.BUFF_TO_UNIT then
								--zhenkira: todo 设置某种状态
							end
						end
					end
				end,
				codeOnButtonCreate = function(self,nSkillId,oBtn,gx,gy)
					local btnName = "btn_"..self.data.buttonNum
					_tBtnXY2I[gx.."|"..gy] = btnName
					tFunc.UpdateBtnUI(oUnit,nSkillId,oBtn)
					if oBtn.data.userdata>0 then
						if nSkillId==nAttackId and oBtnDefault==nil then
							oBtnDefault = oBtn
						end
					end
				end,
				
				show = 1,
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
				print("耗魔技能", oUnit.attr.mp, nManaCost)
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

			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!hApi.CastSkill = ".. tostring(nCastLimit))
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
	tFunc.ChooseOprBtn = function(oGrid,oBtn)
		print("ChooseOprBtn :".. tostring(oBtn.data.userdata))
		local NeedAddHint = 1
		if oBtn.data.userdata < 0 then --geyachao:为何不能大地图施法？
			print("不能施展此技能," .. oBtn.data.userdata)
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
	tFunc.GetOprData = function()
		local oUnit = hApi.BF_GetOprUnit()
		print("tFunc.GetOprData:".. tostring(oUnit))
		if oUnit and oUnit.data.IsDead~=1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
			local oWorld = oUnit:getworld()
			if oWorld then
				return oUnit,oWorld
				--zhenkira td不需要判断round
--				local oRound = oWorld:getround()
--				if oRound and oRound.data.auto==0 and oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)==oUnit then
--					return oUnit,oWorld
--				end
			end
		end
	end
	return tFunc
end

--BFOprUI函数
hGlobal.BFOprUIFunc = {
	AddUIForActionList = function(tInsert,oFrm,oGrid,gx,gy)
		local nUnique,nRoundCount,oUnit = tInsert[1],tInsert[2],tInsert[3]
		local x,y = oGrid:grid2xy(gx,gy)
		x = x + oGrid.data.x
		y = y + oGrid.data.y
		local tx,ty = x+22,y-26
		local text
		local oImg,pSlot,oLabel
		if oUnit.data.id=="round" then
			pSlot = oGrid:addimage("MODEL:Default",gx,gy)
			pSlot:setVisible(false)
			oImg = hUI.image:new({
				parent = oFrm.handle._n,
				model = "ui/next_day.png",
				x = x,
				y = y,
				z = -1,
				w = 68,
				h = 68,
				smartWH = 1,
			})
			oLabel = hUI.label:new({
				parent = oFrm.handle._n,
				x = tx,
				y = ty,
				text = tostring(nRoundCount),
				font = "num",
				size = 16,
				align = "MC",
			})
		else
			text = tostring(oUnit.attr.stack)
			local w,h = hApi.GetUnitImageWH(oUnit.data.id,74,74)
			pSlot = oGrid:addimage("UI:army_tray",gx,gy)
			local nType = hApi.BFGetUnitControlType(oUnit)
			if nType==0 then
				--敌人
				pSlot:setColor(ccc3(183,72,72))
			elseif nType==1 then
				--主控方
			elseif nType==2 then
				--友军
				pSlot:setColor(ccc3(0,182,255))
			end
			oImg = hUI.thumbImage:new({
				parent = oFrm.handle._n,
				x = x,
				y = y-10,
				id = oUnit.data.id,
				facing = 180,
				w = w,
				h = h,
				smartWH = 1,
			})
			oLabel = hUI.label:new({
				parent = oFrm.handle._n,
				x = tx,
				y = ty,
				text = tostring(oUnit.attr.stack),
				font = "numWhite",
				size = 16,
				align = "MC",
			})
		end
		return oImg,pSlot,oLabel
	end,
}

--战场内基本操作
hGlobal.UI.InitBattlefieldOperate = function()
	--当前激活数据
	local _BF_LastActiveUnit = {}	--当前激活的单位
	--local _TD_LastActiveHero = {}	--上一次选中的英雄
	local _BF_oPlayerI			--1号玩家
	local _BF_oPlayerII		--2号玩家
	local _BF_oWorld			--当前战场
	local _BF_MoveDataList

	--临时操作数据
	local _BF_LastSkillId = 0
	local _BF_LastMoveMode = 0		--执行当前操作时，是否允许处理移动命令
	local _BF_LastMoveData
	local _BF_TouchGridX
	local _BF_TouchGridY
	local _BF_LastGridX
	local _BF_LastGridY
	local _BF_SelectedGridX
	local _BF_SelectedGridY
	local _BF_LastOperateMode
	local _BF_LastOperateUnit = {}
	local _BF_LastTarget = {}
	local _BF_InfoFrameTarget = {}
	local _BF_TokenMoveGrid = {}

	--双击处理
	local _BF_DoubleClickTick = 0
	local _BF_DoubleClickCount= 0
	local _IsConfirmClick = function()
		if _BF_DoubleClickCount>0 then
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end
	local _CountConfirmClick = function(sSelectMode,gridX,gridY)
		local tick = hApi.gametime()
		if sSelectMode=="drag" then
			if not(gridX==_BF_TouchGridX and gridY==_BF_TouchGridY) then
				_BF_TouchGridX = gridX
				_BF_TouchGridY = gridY
				_BF_DoubleClickTick = 0
				_BF_DoubleClickCount = 0
			end
		else
			_BF_TouchGridX = gridX
			_BF_TouchGridY = gridY
			if _BF_DoubleClickTick<tick then
				_BF_DoubleClickTick = tick + 500
				_BF_DoubleClickCount = 0
			else
				_BF_DoubleClickCount = _BF_DoubleClickCount + 1
				_BF_DoubleClickTick = tick + 250
			end
		end
	end
	--清理确认操作
	local _ResetConfirmClick = function()
		_BF_DoubleClickTick = 0
		_BF_DoubleClickCount= 0
	end

	--清理当前技能操作
	local _ClearOprTempData = function()
		_BF_LastSkillId = 0
		_BF_LastMoveMode = 0
		_BF_LastMoveData = nil
		_BF_LastGridX = nil
		_BF_LastGridY = nil
		_BF_SelectedGridX = nil
		_BF_SelectedGridY = nil
		_BF_LastOperateMode = nil
		_BF_TokenMoveGrid.grid = nil
		_BF_TokenMoveGrid.gridI = nil
		_BF_TokenMoveGrid.gridEx = nil
		hApi.SetObjectEx(_BF_LastTarget,nil)
		if _BF_oWorld~=nil and _BF_oWorld.ID~=0 and _BF_oWorld.data.type=="battlefield" then
			hApi.safeRemoveT(_BF_oWorld.worldUI,"__BF__TargetHint")
			_BF_oWorld:drawgrid("MoveGridHint","clear")
		end
	end

	--清理当前单位操作数据
	local _ClearOprSkillData = function()
		_BF_MoveDataList = nil
		hApi.SetObjectEx(_BF_LastOperateUnit,nil)
		hApi.SetObject(_BF_InfoFrameTarget,nil)
		_ClearOprTempData()
		_ResetConfirmClick()
	end

	--清理所有数据
	local _ClearAllData = function()
		hApi.SetObjectEx(_BF_LastActiveUnit,nil)
		hApi.SetObjectEx(_BF_LastActiveHero,nil)
		_BF_oPlayerI = nil
		_BF_oPlayerII = nil
		_BF_oWorld = nil
		_ClearOprSkillData()
	end

	--单位激活的时候显示选择圈
	local _ShowSelectCircle = function(oUnit)
		local oUnitLast = hApi.GetObjectEx(hClass.unit,_BF_LastActiveUnit)
		if oUnitLast~=oUnit then
			if oUnitLast~=nil then
				hApi.safeRemoveT(oUnitLast.chaUI,"BF_SelectCircle")
			end
			local _,_,w,h = oUnit:getbox()
			w = math.min(128,w)
			local nType = hApi.BFGetUnitControlType(oUnit)
			if nType~=0 then
				--1号玩家显示为蓝色
				oUnit.chaUI["BF_SelectCircle"] = hUI.image:new({
					parent = oUnit.handle._n,
					model = "MODEL_EFFECT:SelectCircle",
					animation = "blue",
					z = -255,
					w = w,
				})
			else
				--2号玩家显示为红色
				oUnit.chaUI["BF_SelectCircle"] = hUI.image:new({
					parent = oUnit.handle._n,
					model = "MODEL_EFFECT:SelectCircle",
					animation = "red",
					z = -255,
					w = w,
				})
			end
			local scale = math.min(0.98, (w - 4) / w)
			local a = CCScaleBy:create(1, scale, scale)
			local aR = a:reverse()
			local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
			oUnit.chaUI["BF_SelectCircle"].handle._n:runAction(CCRepeatForever:create(seq))
		end
	end
	
	--单位激活时显示攻击范围圈
	local _ShowTDAttackRange = function(oUnit)
		local oUnitLast = hApi.GetObjectEx(hClass.unit,_BF_LastActiveUnit)
		--local oUnitLast = hGlobal.LocalPlayer:getfocusunit()
		
		--if oUnitLast == oUnit and oUnit and oUnit.chaUI["TD_AtkRange"] then
		--	return
		--end
		
		if oUnitLast~=nil then
			hApi.safeRemoveT(oUnitLast.chaUI, "TD_AtkRange")
			--hApi.safeRemoveT(oUnitLast.chaUI,"TD_AtkRange1")
		end
		
		if not oUnit or not oUnit.attr.attack then
			return
		end
		
		--最大攻击范围
		local atkRange = oUnit:GetAtkRange()
		if (atkRange > 0) then
			--local tabU = oUnit:gettab()
			--local isTower = tabU.isTower or 0
			--if (isTower == 1) then
			if (oUnit.data.type == hVar.UNIT_TYPE.TOWER) then --geyachao: 已修改塔类型的读取方式
				local eu_bx, eu_by, eu_bw, eu_bh = oUnit:getbox() --包围盒
				local eu_dx = eu_bx + eu_bw / 2 --中心点偏移x位置
				local eu_dy = eu_by + eu_bh / 2 --中心点偏移y位置
				--如果是塔显示攻击范围
				oUnit.chaUI["TD_AtkRange"] = hUI.image:new({
					parent = oUnit.handle._n,
					x = eu_dx,
					y = eu_dy,
					model = "MODEL_EFFECT:SelectCircle",
					animation = "range",
					z = -255,
					w = atkRange * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
					--color = {128, 255, 128},
					--alpha = 48,
				})
				
				local scale = math.min(0.98, (atkRange - 4) / atkRange)
				local a = CCScaleBy:create(0.75, scale, scale)
				local aR = a:reverse()
				local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
				oUnit.chaUI["TD_AtkRange"].handle._n:runAction(CCRepeatForever:create(seq))
				
				local program = nil
				if (oUnit:getowner() == oUnit:getworld():GetPlayerMe()) then --我操控的塔，显示绿色
					--显示最小攻击范围
					local atkRangeMin = oUnit:GetAtkRangeMin()
					if (atkRangeMin < 0) then
						atkRangeMin = 0
					end
						
					local scale = atkRangeMin / atkRange / 1.11
					--print("scale=", scale)
					
					program = hApi.getShader("atkrange1", 1, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
					local resolution = program:glGetUniformLocation("resolution")
					program:setUniformLocationWithFloats(resolution,66,66)
					
					local rr = program:glGetUniformLocation("rr")
					local gg = program:glGetUniformLocation("gg")
					local bb = program:glGetUniformLocation("bb")
					program:setUniformLocationWithFloats(rr, 0.2)
					program:setUniformLocationWithFloats(gg, 0.67)
					program:setUniformLocationWithFloats(bb, 0.5)
					
					--显示最小攻击范围
					local inner_r = program:glGetUniformLocation("inner_r")
					program:setUniformLocationWithFloats(inner_r, scale)
				elseif (oUnit:getowner():getforce() == oUnit:getworld():GetPlayerMe():getforce()) then --友军，显示黄色
					--显示最小攻击范围
					local atkRangeMin = oUnit:GetAtkRangeMin()
					if (atkRangeMin < 0) then
						atkRangeMin = 0
					end
						
					local scale = atkRangeMin / atkRange / 1.11
					--print("scale=", scale)
					
					program = hApi.getShader("atkrange1", 2, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
					local resolution = program:glGetUniformLocation("resolution")
					program:setUniformLocationWithFloats(resolution,66,66)
				
					local rr = program:glGetUniformLocation("rr")
					local gg = program:glGetUniformLocation("gg")
					local bb = program:glGetUniformLocation("bb")
					program:setUniformLocationWithFloats(rr, 1.0)
					program:setUniformLocationWithFloats(gg, 1.0)
					program:setUniformLocationWithFloats(bb, 0.0)
					
					--显示最小攻击范围
					--hApi.clearShader("atkrange1", 1)
					--program:glluaAddTempUniform(0,scale,"inner_r") --动态刷shader
					--第一参 目前能传0-4 相当于lua能用5个可逐帧刷新的shader变量
					--第二参 是具体value（float）
					--第三参 是shader里用到的那个变量名
					local inner_r = program:glGetUniformLocation("inner_r")
					program:setUniformLocationWithFloats(inner_r, scale)
				else --敌方塔，显示红色
					--显示最小攻击范围
					local atkRangeMin = oUnit:GetAtkRangeMin()
					if (atkRangeMin < 0) then
						atkRangeMin = 0
					end
						
					local scale = atkRangeMin / atkRange / 1.11
					--print("scale=", scale)
					
					program = hApi.getShader("atkrange1", 3, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
					local resolution = program:glGetUniformLocation("resolution")
					program:setUniformLocationWithFloats(resolution,66,66)
					
					local rr = program:glGetUniformLocation("rr")
					local gg = program:glGetUniformLocation("gg")
					local bb = program:glGetUniformLocation("bb")
					program:setUniformLocationWithFloats(rr, 1.0)
					program:setUniformLocationWithFloats(gg, 0.0)
					program:setUniformLocationWithFloats(bb, 0.0)
					
					--显示最小攻击范围
					local inner_r = program:glGetUniformLocation("inner_r")
					program:setUniformLocationWithFloats(inner_r, scale)
				end
				
				oUnit.chaUI["TD_AtkRange"].handle.s:setShaderProgram(program)
				--[[
				oUnit.chaUI["TD_AtkRange1"] = hUI.image:new({
					parent = oUnit.handle._n,
					model = "MODEL_EFFECT:SelectCircle",
					animation = "range",
					x = 2,
					y = 3,
					z = -256,
					w = atkRange * 1.95,
					color = {128, 255, 128},
					alpha = 48,
				})
				--]]
			end
		end
	end
	
	--geyachao: 选中圈
	local _ShowHeroSelected = function(oUnit)
		--geyachao: 取消上次选中单位
		--local oHeroLast = hApi.GetObjectEx(hClass.hero, _TD_LastActiveHero)
		--if oHeroLast and (oHeroLast ~= 0) then
		--	local oUnitLast = oHeroLast:getunit()
		--	if oUnitLast then
		--		hApi.safeRemoveT(oUnitLast.chaUI, "TD_SelectHero")
		--	end
		--end
		local oUnitLast = hApi.GetObjectEx(hClass.unit, _BF_LastActiveUnit)
		if oUnitLast then
			hApi.safeRemoveT(oUnitLast.chaUI, "TD_SelectHero")
			hApi.safeRemoveT(oUnitLast.chaUI, "TD_ThisUnit") --取消显示上次次单位的标识
			hApi.safeRemoveT(oUnitLast.chaUI, "TD_ThisUnit2") --取消显示上次次单位的标识2
		end
		
		--geyachao: 选中本次单位
		if (oUnit) and (oUnit ~= 0) then
			--local oHero = oUnit:gethero()
			local tabU = oUnit:gettab()
			local unitType = oUnit.data.type --类型
			
			if (unitType == hVar.UNIT_TYPE.HERO) or (unitType == hVar.UNIT_TYPE.BUILDING) then --英雄或者塔，显示盒子
				local _, _, w ,h = oUnit:getbox()
				w = math.min(128,w)
				local nType = hApi.BFGetUnitControlType(oUnit)
				--if nType~=0 then
				if (unitType == hVar.UNIT_TYPE.HERO) then
					--[[
					--大菠萝不显示
					--1号玩家显示为蓝色
					oUnit.chaUI["TD_SelectHero"] = hUI.image:new({
						parent = oUnit.handle._n,
						model = "MODEL_EFFECT:SelectCircle",
						animation = "blue",
						z = -255,
						w = w,
					})
					]]
					
					--显示本次英雄单位的标识
					--oUnit.chaUI["TD_ThisUnit"] = hUI.image:new({
					--	parent = oUnit.handle._n,
					--	model = "UI:STAR_YELLOW",
					--	z = 100,
					--	--w = 22,
					--	--h = 22,
					--	scale = 0.3,
					--	x = -41,
					--	y = 78,
					--})
					
					--[[
					oUnit.chaUI["TD_ThisUnit"] = hUI.image:new({
						parent = oUnit.handle._n,
						model = "ICON:HeroAttr_leadship",
						z = 100,
						--w = 22,
						--h = 22,
						scale = 0.4,
						x = -42,
						y = 74,
					})
					
					--显示本次英雄单位的标识2
					local dx = -17
					local dy = 65
					local eu_bx, eu_by, eu_bw, eu_bh = oUnit:getbox()
					oUnit.chaUI["TD_ThisUnit2"] = hUI.label:new({
						parent = oUnit.handle._n,
						x = dx + 15, --英雄略大
						y = eu_bh + 23, --英雄略大
						w = 300, --英雄略大
						font = hVar.FONTC,
						size = 18,
						align = "MC",
						text = oUnit.data.name,
						border = 1,
					})
					oUnit.chaUI["TD_ThisUnit2"].handle.s:setColor(ccc3(255, 168, 0))
					]]
				elseif (unitType == hVar.UNIT_TYPE.BUILDING) then
					--建筑显示为绿色
					oUnit.chaUI["TD_SelectHero"] = hUI.image:new({
						parent = oUnit.handle._n,
						model = "MODEL_EFFECT:SelectCircle",
						animation = "red",
						z = -255,
						w = w,
					})
				end
				local scale = math.min(0.98, (w - 4) / w)
				local a = CCScaleBy:create(1, scale, scale)
				local aR = a:reverse()
				local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
				if oUnit.chaUI["TD_SelectHero"] then
					oUnit.chaUI["TD_SelectHero"].handle._n:runAction(CCRepeatForever:create(seq))
				end
			end
		end
	end
	
	--here
	local _ShowSelectUnit = function(oUnit)
		--_ShowSelectCircle(oUnit)
		_ShowTDAttackRange(oUnit)
		_ShowHeroSelected(oUnit)
	end

	--获得战场内城门数量
	local __ENUM__GetGate = function(t,Gate,p)
		if t.data.IsGate==1 and t.data.IsDead~=1 and t.data.owner==p.data.playerId then
			Gate[#Gate+1] = t
		end
	end

	--触摸世界合法性检测
	local _TouchCondition = function(oWorld)
		local oRound = oWorld:getround()
		if _BF_LastOperateMode~="End" and _BF_LastMoveData~=nil and oRound~=nil and oRound.data.auto==0 and oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)==hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit) then
			return hVar.RESULT_SUCESS
		end
		return hVar.RESULT_FAIL
	end

	--画提示格
	local _DrawGridT = {n=0,recycle=1}
	local _TempGridT = {n=0,recycle=1}
	local _TempGridTX = {n=0,recycle=1}
	local _DrawHintGrid = function(mode,oWorld,oUnit,gridX,gridY)
		if mode=="ground" then
			mode = _BF_LastMoveData.GridShape or "ground"
		end
		if mode=="unit" then
			_DrawGridT.n = 0
			oUnit:getgrid(_DrawGridT,gridX,gridY)
			oWorld:drawgrid("MoveGridHint","blue",_DrawGridT,"unrecord",2)
		elseif mode=="target" then
			local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastTarget) or oUnit
			_DrawGridT.n = 0
			oTarget:getgrid(_DrawGridT,gridX,gridY)
			oWorld:drawgrid("MoveGridHint","blue",_DrawGridT,"unrecord",2)
		elseif mode=="wall" then
			_DrawGridT.n = 0
			hApi.GetWallGrid(oWorld,oUnit,gridX,gridY,_DrawGridT)
			oWorld:drawgrid("MoveGridHint","red",_DrawGridT,"unrecord",2)
		elseif mode=="alltarget" then
			_TempGridT.n = 0
			_TempGridTX.n = 0
			if _BF_LastMoveData and _BF_LastMoveData.Target and oUnit~=nil then
				for ID,tGrid in pairs(_BF_LastMoveData.Target)do
					local oTarget = hClass.unit:find(ID)
					if tGrid.type=="Move" or tGrid.type=="OutOfRange" then
						oTarget:getgrid(_TempGridTX)
					else
						oTarget:getgrid(_TempGridT)
					end
				end
			end
			if _TempGridT.n>0 then
				oWorld:drawgrid("TargetGridHint","red",_TempGridT,nil,3)
			else
				oWorld:drawgrid("TargetGridHint","clear")
			end
			if _TempGridTX.n>0 then
				oWorld:drawgrid("TargetGridHintX","gray_red",_TempGridTX,nil,3)
			else
				oWorld:drawgrid("TargetGridHintX","clear")
			end
		else
			_DrawGridT.n = 0
			local rMin,rMax = 0,0
			if _BF_LastMoveData.area then
				rMin = _BF_LastMoveData.area[1]
				rMax = _BF_LastMoveData.area[2]
			end
			oWorld:gridinrange(_DrawGridT,gridX,gridY,rMin,rMax)
			oWorld:drawgrid("MoveGridHint","red",_DrawGridT,"unrecord",2)
		end
	end
	--获得一个最近的移动格子
	local _GetGridToGo = function(oWorld,oUnit,oTarget,tGrid,tMoveData)
		if tGrid.GridToGo~=nil then
			return tGrid.GridToGo
		end
		tGrid.GridToGo = {x=oUnit.data.gridX,y=oUnit.data.gridY}
		local tMoveGrid = tMoveData.gridEx
		if #tMoveGrid>0 then
			local nDis = 9999
			local nDisY = 9999
			local nIndex = 0
			for i = 1,#tMoveGrid do
				local v = tMoveGrid[i]
				v.dis = oWorld:distanceU(oTarget,nil,1,v.x,v.y)
				if v.dis<nDis then
					nDis = v.dis
				end
			end
			for i = 1,#tMoveGrid do
				local v = tMoveGrid[i]
				if v.dis==nDis then
					local nAbsY = math.abs(oUnit.data.gridY-v.y)
					if nAbsY<nDisY then
						nDisY = nAbsY
						nIndex = i
					end
				end
			end
			if nIndex>0 then
				local v = tMoveGrid[nIndex]
				tGrid.GridToGo.x = v.x
				tGrid.GridToGo.y = v.y
				if v.link then
					tGrid.GridToGo.link = {x=v.link.x,y=v.link.y}
				end
			end
		end
		return tGrid.GridToGo
	end

	--选择一个格子，不同技能的选择类型在这里定义
	local _ConfirmSelectGrid = function(oWorld,oUnit,tMoveXY)
		local gridX,gridY = tMoveXY.x,tMoveXY.y
		if _BF_LastGridX==gridX and _BF_LastGridY==gridY then
			return 0
		end
		if not(oWorld:IsSafeGrid(gridX,gridY) and oUnit and _BF_LastMoveData) then
			return -1
		end
		_BF_LastGridX = gridX
		_BF_LastGridY = gridY
		if tMoveXY.link then
			_BF_SelectedGridX = tMoveXY.link.x
			_BF_SelectedGridY = tMoveXY.link.y
		else
			_BF_SelectedGridX = gridX
			_BF_SelectedGridY = gridY
		end
		return 1
	end
	local _tTokenXY = {x=0,y=0}
	local _TrySelectGrid = function(sHintMode,tMoveGrid,oWorld,oUnit,gridX,gridY,worldX,worldY)
		if not(_BF_LastMoveData and oUnit) then
			return -1
		end
		local tMoveXY
		if tMoveGrid~=nil then
			--有限制的选择
			local MustSelectOne = 0
			if tMoveGrid.gridI~=nil and tMoveGrid.gridEx~=nil then
				local nIndex = tMoveGrid.gridI[gridX.."|"..gridY]
				if _BF_LastGridX==gridX and _BF_LastGridY==gridY and nIndex~=nil then
					return 1
				end
				if nIndex~=nil then
					tMoveXY = tMoveGrid.gridEx[nIndex]
				else
					MustSelectOne = 1
				end
			else
				MustSelectOne = 1
				local mGrid = tMoveGrid.gridEx or tMoveGrid.grid
				for i = 1,#mGrid do
					local v = mGrid[i]
					if v.x==gridX and v.y==gridY then
						tMoveXY = v
						break
					end
				end
			end
			if MustSelectOne==1 and tMoveXY==nil and worldX and worldY then
				local mGrid = tMoveGrid.gridEx or tMoveGrid.grid
				local fDis = 9999
				--local cX,cY = oUnit:getstandXY()
				for i = 1,#mGrid do
					local v = mGrid[i]
					local x,y = oWorld:grid2xy(v.x,v.y)
					--x = x + cX
					--y = y + cY
					local dis = math.sqrt((worldX-x)^2+(worldY-y)^2)
					if dis<fDis then
						fDis = dis
						tMoveXY = v
					end
				end
			end
		else
			--可任意选择格子
			if oWorld:IsSafeGrid(gridX,gridY) then
				_tTokenXY.x = gridX
				_tTokenXY.y = gridY
				tMoveXY = _tTokenXY
			end
		end
		if tMoveXY then
			local sus = _ConfirmSelectGrid(oWorld,oUnit,tMoveXY)
			if sus==1 then
				local v = tMoveXY
				if v.link then
					_DrawHintGrid(sHintMode,oWorld,oUnit,v.link.x,v.link.y)
				else
					_DrawHintGrid(sHintMode,oWorld,oUnit,v.x,v.y)
				end
				oWorld:drawgrid("default","show","unclear")
			end
			return sus
		else
			return -1
		end
	end
	--测试是否点击在单位选择范围内
	local _TestTargetBox = function(oWorld,oTarget,worldX,worldY)
		local x,y,w,h = oTarget:getbox()
		local wx,wy = oTarget:getXY()
		local tx = wx+x
		local ty = wy+y
		local bx = wx+x+w
		local by = wy+y+h
		if worldX>=tx and worldX<=bx and worldY>=ty and worldY<=by then
			return 1
		end
		return 0
	end
	local _LastMoveGrid
	local _DrawMoveGrid = function(oWorld,tGrid)
		if tGrid~=nil then
			_LastMoveGrid = tGrid
			if hVar.OPTIONS.IS_DRAW_GRID==1 then --0不显示, 1显示
				oWorld.data.IsDrawGrid = 1
				oWorld:drawgrid("MoveGrid","green",tGrid)
				oWorld:drawgrid("default","gray","unclear")
			else
				oWorld.data.IsDrawGrid = 0
				oWorld:drawgrid("MoveGrid","gray_green",tGrid)
				oWorld:drawgrid("default","hide")
			end
		else
			if hVar.OPTIONS.IS_DRAW_GRID==1 then --0不显示, 1显示
				oWorld.data.IsDrawGrid = 1
				oWorld:drawgrid("MoveGrid","clear")
				oWorld:drawgrid("default","gray","unclear")
			else
				oWorld.data.IsDrawGrid = 0
				oWorld:drawgrid("MoveGrid","clear")
				oWorld:drawgrid("default","hide")
			end
		end
	end
	--显示移动网格
	hApi.DrawMoveGrid = function()
		local oWorld = _BF_oWorld
		if oWorld~=nil and oWorld==hGlobal.LocalPlayer:getfocusworld() and oWorld.data.type=="battlefield" and oWorld.ID~=0 and _LastMoveGrid~=nil then
			_DrawMoveGrid(oWorld,_LastMoveGrid)
		end
	end
	--显示已选定目标单位的提示UI
	local _ArrowMotion = {{0,-5,0.3},{0,0,0.3}}
	local _ShowTargetHintUI = function(sOperateMode,oWorld,oUnit,oTarget)
		if not(_BF_LastGridX and _BF_LastGridY) then
			_BF_LastGridX = oUnit.data.gridX
			_BF_LastGridY = oUnit.data.gridY
		end
		if sOperateMode=="MoveAndAttack" then
			if not(_BF_SelectedGridX and _BF_SelectedGridY) then
				_BF_SelectedGridX = oUnit.data.gridX
				_BF_SelectedGridY = oUnit.data.gridY
			end
			local wx,wy = oTarget:getXY()
			local cx,cy = oUnit:getXYByPos(_BF_SelectedGridX,_BF_SelectedGridY)
			local sAnimation = "stand_"..hApi.calAngleD("DIRECTIONx8",hApi.angleBetweenPoints(wx,wy,cx,cy))
			local cx,cy,cw,ch = oTarget:getbox()
			hApi.BF_CreateHintImage(oWorld,"MODEL:pSword",sAnimation,wx,wy,196,196,nil,-1*(cy + ch/2))
		elseif sOperateMode=="Attack" then
			local wx,wy = oTarget:getXY()
			hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
			oWorld:drawgrid("MoveGridHint","clear")
		elseif sOperateMode=="Move" then
			local gridX,gridY = _BF_LastGridX,_BF_LastGridY
			local wx,wy = oWorld:grid2xy(gridX,gridY)
			hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
		elseif sOperateMode=="MoveT" then
			local wx,wy = oTarget:getXY()
			hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
		elseif sOperateMode=="Ground" then
			local gridX,gridY = _BF_LastGridX,_BF_LastGridY
			local wx,wy = oWorld:grid2xy(gridX,gridY)
			hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
		end
	end
	--选择一个攻击移动格子
	local _nSelectLock = 0
	local _nSelectType = 0
	local _TrySelectAttackGrid = function(sSelectMode,oWorld,oUnit,gridX,gridY,worldX,worldY)
		local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
		if oTarget and _BF_LastMoveData.Target[oTarget.ID] then
			if sSelectMode=="drag" then
				local IsInBox = 0
				if worldX and worldY and _nSelectLock==1 then
					IsInBox = _TestTargetBox(oWorld,oTarget,worldX,worldY)
				end
				if _nSelectLock==1 and IsInBox==1 then
					return 1
				else
					_nSelectLock = 0
					if _BF_TokenMoveGrid.grid~=_BF_LastMoveData.Target[oTarget.ID] then
						_BF_TokenMoveGrid.grid = _BF_LastMoveData.Target[oTarget.ID]
						_BF_TokenMoveGrid.gridI = nil
						_BF_TokenMoveGrid.gridEx = nil
					end
				end
			elseif sSelectMode=="down_unit" then
				_nSelectLock = 1
				_nSelectType = 1
				if worldX and worldY then
					gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
					worldX,worldY = oUnit:getXY()
				end
				if _BF_TokenMoveGrid.grid~=_BF_LastMoveData.Target[oTarget.ID] then
					local gridEx,gridI = oUnit:__GetExMoveGrid(_BF_LastMoveData.Target[oTarget.ID])
					_BF_TokenMoveGrid.grid = _BF_LastMoveData.Target[oTarget.ID]
					_BF_TokenMoveGrid.gridEx = gridEx
					_BF_TokenMoveGrid.gridI = gridI
				end
			elseif sSelectMode=="down" then
				_nSelectType = 0
				_nSelectLock = 0
				if _BF_TokenMoveGrid.grid~=_BF_LastMoveData.Target[oTarget.ID] then
					_BF_TokenMoveGrid.grid = _BF_LastMoveData.Target[oTarget.ID]
					_BF_TokenMoveGrid.gridI = nil
					_BF_TokenMoveGrid.gridEx = nil
				end
			else
				_BF_TokenMoveGrid.grid = nil
				_BF_TokenMoveGrid.gridI = nil
				_BF_TokenMoveGrid.gridEx = nil
			end
			if _BF_TokenMoveGrid.grid~=nil then
				local r = _TrySelectGrid("unit",_BF_TokenMoveGrid,oWorld,oUnit,gridX,gridY,worldX,worldY)
				if r==1 then
					_ShowTargetHintUI("MoveAndAttack",oWorld,oUnit,oTarget)
				end
				if sSelectMode=="down_unit" then
					_CountConfirmClick(sSelectMode,gridX,gridY)
				else
					if _BF_TokenMoveGrid.gridI~=nil and _BF_TokenMoveGrid.gridI[gridX.."|"..gridY]~=nil then
						_CountConfirmClick(sSelectMode,gridX,gridY)
					else
						_ResetConfirmClick()
					end
				end
				if r>=0 then
					return 1
				end
			end
		end
	end
	--选择一个移动格子
	local _TrySelectMoveGrid = function(sSelectMode,oWorld,oUnit,gridX,gridY,worldX,worldY,touchGridX,touchGridY)
		local r = _TrySelectGrid("unit",_BF_LastMoveData._MoveGrid,oWorld,oUnit,gridX,gridY,worldX,worldY)
		_CountConfirmClick(sSelectMode,touchGridX,touchGridY)
		if r==1 then
			if sSelectMode=="down_unit" then
				local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
				if oTarget then
					_ShowTargetHintUI("MoveT",oWorld,oUnit,oTarget)
				else
					_ShowTargetHintUI("Move",oWorld,oUnit,oUnit)
				end
			else
				_ShowTargetHintUI("Move",oWorld,oUnit,oUnit)
			end
		end
		if r>=0 then
			return 1
		end
	end
	--选择一个地面格子
	local _TrySelectGroundGrid = function(sSelectMode,oWorld,oUnit,gridX,gridY,worldX,worldY)
		--点到了非法的格子的话，并且是按下模式，不触发任何操作
		if sSelectMode=="down" and not(oWorld:IsSafeGrid(gridX,gridY)) then
			return 0
		end
		local r = _TrySelectGrid("ground",_BF_LastMoveData.AvailableGrid,oWorld,oUnit,gridX,gridY,worldX,worldY)
		_CountConfirmClick(sSelectMode,gridX,gridY)
		--if hApi.GetObjectEx(hClass.unit,_BF_LastTarget)==nil then
		if (_BF_LastTarget[1] or 0)==0 then
			_ShowTargetHintUI("Ground",oWorld,oUnit,oUnit)
		end
		if r>=0 then
			return 1
		end
	end
	--选择一个目标单位
	local _TrySelectAttackTarget = function(sSelectMode,oWorld,oUnit,oTarget)
		_CountConfirmClick(sSelectMode,oTarget.data.gridX,oTarget.data.gridY)
		_ShowTargetHintUI("Attack",oWorld,oUnit,oTarget)
		return 1
	end
	--初始化传送的格子
	local _CODE_ChooseTeleportTarget = function(sSelectMode,oWorld,oUnit,oTarget)
		local tGrid = _BF_LastMoveData.Target[oTarget.ID]
		if tGrid.AvailableGrid==nil then
			local _,tAvailableGrid = oTarget:getmovegrid(999,1)
			tGrid.AvailableGrid = tAvailableGrid
		end
		hApi.SetObjectEx(_BF_LastTarget,oTarget)
		_BF_LastMoveData.AvailableGrid = tGrid.AvailableGrid
		_BF_LastOperateMode = "Ground"
		if sSelectMode=="down_unit" or sSelectMode=="up_unit" then
			--按下时选择目标单位才重画格子
			_DrawHintGrid("alltarget",oWorld,nil)
			oWorld:drawgrid("default","reset")
		end
		_ShowTargetHintUI("Attack",oWorld,oUnit,oTarget)
		_DrawMoveGrid(oWorld,_BF_LastMoveData.AvailableGrid.gridEx)
	end
	--EFF 清理内存 2013/8/15
	--进战场重置数据
	hGlobal.event:listen("Event_BattlefieldStart","__BF__ReseOprData",function(oWorld)
		if oWorld.data.IsQuickBattlefield~=1 and hGlobal.LocalPlayer:getfocusworld()==oWorld then
			_ClearAllData()
			_BF_oWorld = oWorld
			for i = -1,hVar.MAX_PLAYER_NUM,1 do
				if oWorld.data.lords[i] and hGlobal.player[i]==hGlobal.LocalPlayer then
					_BF_oPlayerI = hGlobal.player[i]
					break
				end
			end
			if _BF_oPlayerI==nil then
				for i = -1,hVar.MAX_PLAYER_NUM,1 do
					if oWorld.data.lords[i] and hGlobal.player[i]~=nil then
						_BF_oPlayerI = hGlobal.player[i]
						break
					end
				end
			end
			for i = -1,hVar.MAX_PLAYER_NUM,1 do
				if oWorld.data.lords[i] and hGlobal.player[i]~=nil and hGlobal.player[i]~=_BF_oPlayerI then
					_BF_oPlayerII = hGlobal.player[i]
					break
				end
			end
		end
	end)
	--出战场重置数据
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__ReseOprData",function()
		_ClearAllData()
	end)

	local _enum_ShowStunImmunity = function(u)
		if (u.data.type==hVar.UNIT_TYPE.UNIT or u.data.type==hVar.UNIT_TYPE.HERO) and u.attr.passive==0 and u.handle._n then
			if u.attr.stunimmunity>0 then
				if u.chaUI["BuffImgStunImmunity"]==nil then
					u.chaUI["BuffImgStunImmunity"] = hUI.image:new({
						parent = u.handle._n,
						model = "ICON:icon01_x1y1",
						w = 26,
						h = 26,
						y = -2,
					})
				end
			else
				if u.chaUI["BuffImgStunImmunity"]~=nil then
					u.chaUI["BuffImgStunImmunity"]:del()
					u.chaUI["BuffImgStunImmunity"] = nil
				end
			end
		end
	end
	local _code_ShowStunImmunity = function(oWorld)
		oWorld:enumunit(_enum_ShowStunImmunity)
	end
	--显示单位额外信息
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__ShowAllUnitsDetail",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield~=1 and oWorld==hGlobal.LocalPlayer:getfocusworld() then
			--刷新单位选择圈
			_ShowSelectCircle(oUnit)
			hApi.SetObjectEx(_BF_LastActiveUnit,oUnit)
			--显示免控UI
			_code_ShowStunImmunity(oWorld)
		end
	end)

	--显示单位额外信息
	hGlobal.event:listen("Event_TDUnitActived","__BF__ShowAllUnitsDetail",function(oWorld,oRound,oUnit)
		if oWorld==hGlobal.LocalPlayer:getfocusworld() then
			--print("Event_TDUnitActived", oUnit and oUnit.data.name)
			--刷新单位选择圈
			--_ShowSelectCircle(oUnit)	--zhenkira
			_ShowSelectUnit(oUnit) --zhenkira
			hApi.SetObjectEx(_BF_LastActiveUnit ,oUnit)
			
			if oUnit then
				if (oUnit.data.type == hVar.UNIT_TYPE.HERO) then
					--hApi.SetObjectEx(_TD_LastActiveHero,oUnit:gethero())
				end
				
				--显示免控UI
				_code_ShowStunImmunity(oWorld)
			end
		end
	end)

	--录像单位显示额外信息
	hGlobal.event:listen("Event_ReplayUnitActived","__BF__ShowMoveGrid",function(oWorld,oRound,oUnit)
		oWorld:drawgrid("default","draw")
		local _,tMoveGrid = oUnit:getmovegrid()
		_DrawMoveGrid(oWorld,tMoveGrid.gridEx)
		--显示免控UI
		_code_ShowStunImmunity(oWorld)
	end)
	--当前可控制单位激活
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__InitMoveParam",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		_ClearOprSkillData()
		oWorld:drawgrid("MoveGridHint","clear")
		oWorld:drawgrid("TargetGridHint","clear")
		oWorld:drawgrid("default","reset")
		_DrawMoveGrid(oWorld,nil)
		--oWorld:drawgrid("default","gray")
		local oPlayer = oUnit:getowner()
		
		--if oUnit.data.control==hGlobal.LocalPlayer.data.playerId then --geyachao:注释掉
			--如果是本地玩家的单位，那么允许操作
			hApi.SetObjectEx(_BF_LastOperateUnit,oUnit)
			oPlayer:focusunit(oUnit)
			--打开技能操作面板
			hGlobal.event:event("LocalEvent_ShowBFOperateFrame",oWorld,oRound,oUnit,1)
			--计算单位的默认技能
			local nAttackId = hApi.GetDefaultSkill(oUnit)
			--计算单位可移动的范围
			local MoveGrid,MoveGridEx
			local tGate = {}
			if oUnit.attr.move>0 then
				--统计可操控城门的数量
				--[=[
				oWorld:enumunit(__ENUM__GetGate,tGate,oPlayer)
				if #tGate>0 then
					_,MoveGrid = oUnit:getmovegrid(nil,nil,tGate)
					_,MoveGridEx = oUnit:getmovegrid(999)
				else
					_,MoveGrid = oUnit:getmovegrid()
					_,MoveGridEx = oUnit:getmovegrid(999)
				end
			else
				_,MoveGrid = oUnit:getmovegrid()
				_,MoveGridEx = oUnit:getmovegrid()
				]=]
			end
			
			--保存计算出的临时移动参数
			_BF_MoveDataList = {
				tGate = tGate,
				nAttackId = nAttackId,
				MoveGrid = MoveGrid,
				MoveGridEx = MoveGridEx,
				MoveGridById = {},
				MoveTarget = {},
				--[1] = hApi.CalculateMovePath(oUnit,nAttackId,MoveGrid,MoveGridEx),
			}
		--end --geyachao:注释掉
	end)
	local _code_GetMoveGridById = function(oUnit,nSkillId)
		local tabS = hVar.tab_skill[nSkillId]
		if tabS~=nil then
			local tData = _BF_MoveDataList.MoveGridById[nSkillId]
			if tData then
				return tData.MoveGrid,tData.MoveGridEx
			elseif tabS.selectXY=="flyer" then
				local tData = _BF_MoveDataList.MoveGridById.flyer
				if tData==nil then
					if oUnit.attr.IsFlyer>0 then
						tData = {
							MoveGrid = _BF_MoveDataList.MoveGrid,
							MoveGridEx = _BF_MoveDataList.MoveGridEx,
						}
					else
						local _,tGrid = oUnit:getmovegrid(oUnit.attr.move,1)
						--local _,tGridEx = oUnit:getmovegrid(999,1)
						tData = {
							MoveGrid = tGrid,
							MoveGridEx = tGrid,
						}
					end
					_BF_MoveDataList.MoveGridById.flyer = tData
				end
				_BF_MoveDataList.MoveGridById[nSkillId] = tData
				return tData.MoveGrid,tData.MoveGridEx,_BF_MoveDataList.MoveGrid
			end
		end
		return _BF_MoveDataList.MoveGrid,_BF_MoveDataList.MoveGridEx,_BF_MoveDataList.MoveGrid
	end
	--记录触摸临时变量
	local _bfopr_TouchTemp = {
		mode=0,
		x=0,
		y=0,
		upx = 0,
		upy = 0,
		downtick=0,
		uptick=0,
		groundlock=0,
		moved=0,
	}
	_bfopr_TouchTemp.CODE = {
		GetDownTarget = function(oWorld,oUnit,worldX,worldY)
			if _bfopr_TouchTemp.groundlock==1 then
				--地面锁定模式
			else
				--普通点击模式
				local oTarget = oWorld:hit2unit(worldX,worldY,"battlefield_down",oUnit,_BF_LastMoveData.nSkillId)
				if oTarget and _BF_LastMoveData.Target[oTarget.ID] then
					return oTarget
				end
			end
		end,
		OnReset = function()
			_bfopr_TouchTemp.x = 0
			_bfopr_TouchTemp.y = 0
			_bfopr_TouchTemp.upx = 0
			_bfopr_TouchTemp.upy = 0
			_bfopr_TouchTemp.mode = 0
			_bfopr_TouchTemp.downtick = 0
			_bfopr_TouchTemp.uptick = 0
			_bfopr_TouchTemp.moved = 0
			_bfopr_TouchTemp.groundlock = 0
		end,
		OnTouchDown = function(worldX,worldY)
			_bfopr_TouchTemp.x = worldX
			_bfopr_TouchTemp.y = worldY
			_bfopr_TouchTemp.downtick = hApi.gametime()
			local IsLocked = 0
			--新增，滑动一段距离到目标区域后，1.5秒内连点进入地面锁定模式，点击地面时不选择单位，如果点击一个较远的坐标会取消地点锁定模式
			if _bfopr_TouchTemp.downtick-_bfopr_TouchTemp.uptick<=1500 and _bfopr_TouchTemp.moved>=80 and _bfopr_TouchTemp.mode=="Move" then
				local w = math.abs(_bfopr_TouchTemp.upx-worldX)
				local h = math.abs(_bfopr_TouchTemp.upy-worldY)
				local r = 48
				if w<=r and h<=r then
					IsLocked = 1
				end
			end
			if IsLocked==1 then
				_bfopr_TouchTemp.groundlock = 1
			else
				_bfopr_TouchTemp.moved = 0
				_bfopr_TouchTemp.groundlock = 0
			end
		end,
		OnTouchMove = function(worldX,worldY)
			_bfopr_TouchTemp.moved = _bfopr_TouchTemp.moved + math.abs(_bfopr_TouchTemp.x-worldX) + math.abs(_bfopr_TouchTemp.y-worldY)
			_bfopr_TouchTemp.x = worldX
			_bfopr_TouchTemp.y = worldY
		end,
		OnTouchUp = function(worldX,worldY)
			_bfopr_TouchTemp.mode = _BF_LastOperateMode or 0
			_bfopr_TouchTemp.uptick = hApi.gametime()
			_bfopr_TouchTemp.upx = worldX
			_bfopr_TouchTemp.upy = worldY
		end,
	}
	--显示当前行动预处理
	hGlobal.event:listen("LocalEvent_ShowBFOperatePreview","__BF__ShowBFOperatePreview",function(oWorld,oUnit,nSkillId,oTarget)
		--geyachao:add
		print("LocalEvent_ShowBFOperatePreview()", "oUnit=" .. oUnit.data.name)
		print("_BF_MoveDataList = ", _BF_MoveDataList)
		if _BF_MoveDataList==nil then
			return
		end
		_bfopr_TouchTemp.CODE.OnReset()
		local MustShowMoveGrid = 0
		_ClearOprTempData()
		if nSkillId==0 or nSkillId==1 or nSkillId==hVar.MOVE_SKILL_ID or nSkillId==_BF_MoveDataList.nAttackId then
			_BF_LastSkillId = _BF_MoveDataList.nAttackId
			_BF_LastMoveData = _BF_MoveDataList[1]
			_BF_LastMoveMode = 1
		elseif type(nSkillId)=="number" and hVar.tab_skill[nSkillId] then
			--如果此技能未初始化，那么初始化一次
			if _BF_MoveDataList[nSkillId]==nil then
				local MoveGrid,MoveGridEx,MoveGridU = _code_GetMoveGridById(oUnit,nSkillId)
				_BF_MoveDataList[nSkillId] = hApi.CalculateMovePath(oUnit,nSkillId,MoveGrid,MoveGridEx,MoveGridU)
			end
			_BF_LastSkillId = nSkillId
			_BF_LastMoveData = _BF_MoveDataList[nSkillId]
			_BF_LastMoveMode = 0
			--近战单体技能,需要显示移动方格
			local tabS = hVar.tab_skill[nSkillId]
			if tabS and tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT and tabS.template~="RangeAttack" then
				MustShowMoveGrid = 1
			end
		else
			_BF_LastSkillId = 0
			_BF_LastMoveData = nil
			_BF_LastMoveMode = 0
		end

		if _BF_LastMoveData~=nil then
			local nSpecialOprMode = 0		--特殊初始化
			local tabS = hVar.tab_skill[_BF_LastMoveData.nSkillId]
			--尝试对该技能进行一次额外操作初始化
			if _BF_LastMoveData.__INIT__~=1 then
				_BF_LastMoveData.__INIT__ = 1
				--一些在选择方格时需要特殊处理的技能
				if tabS and tabS.selectXY then
					if tabS.selectXY=="charge" then
						_BF_LastMoveData.oprEx = "charge"
						local grid = hApi.GetChargeGrid(oUnit,nSkillId,1)
						local gridEx,gridI = oUnit:__GetExMoveGrid(grid)
						_BF_LastMoveData.AvailableGrid = {grid=grid,gridEx=gridEx,gridI=gridI}
						_BF_LastMoveData.GridShape = "unit"
					elseif tabS.selectXY=="wall" then
						_BF_LastMoveData.oprEx = "wall"
						_BF_LastMoveData.GridShape = "wall"
					elseif tabS.selectXY=="teleport" then
						_BF_LastMoveData.oprEx = "teleport"
						_BF_LastMoveData.GridShape = "target"
					elseif tabS.selectXY=="flyer" then
						local _,MoveGridEx,_ = _code_GetMoveGridById(oUnit,nSkillId)
						_BF_LastMoveData.ShowGrid = {grid=MoveGridEx.grid,gridEx=MoveGridEx.gridEx,gridI=MoveGridEx.gridI}
					end
				end
			end
			--自身传送特殊处理
			if tabS and tabS.selectXY=="teleport" then
				if tabS.target and tabS.target[1]=="SELF" then
					nSpecialOprMode = 1
				end
			end

			--清理一下"teleport"类型技能的临时传送限制方格(每次选择传送目标都需要清理)
			if _BF_LastMoveData.oprEx=="teleport" then
				_BF_LastMoveData.AvailableGrid = nil
			end

			--显示可释放方格的技能禁止处理移动，请注意
			local tMoveGridShow
			if _BF_LastMoveData.ShowGrid~=nil then
				tMoveGridShow = _BF_LastMoveData.ShowGrid.gridEx
				_BF_LastMoveMode = 0
			elseif _BF_LastMoveData.AvailableGrid~=nil then
				tMoveGridShow = _BF_LastMoveData.AvailableGrid.gridEx
				_BF_LastMoveMode = 0
			elseif _BF_LastMoveMode==1 or MustShowMoveGrid==1 then
				tMoveGridShow = _BF_LastMoveData._MoveGrid.gridEx
			end
			if nSpecialOprMode==1 then
				--传送技能，并且目标指定仅自己有效的话不显示选择目标流程
				_BF_LastOperateMode = "Ground"
				_DrawHintGrid("alltarget",oWorld,oUnit)
				_CODE_ChooseTeleportTarget("down_self",oWorld,oUnit,oUnit)
			else
				--清理所有临时格子
				oWorld:drawgrid("default","reset")
				--画地板格子
				_DrawMoveGrid(oWorld,tMoveGridShow)
				--显示可攻击单位
				if _BF_LastMoveData.Target then
					_DrawHintGrid("alltarget",oWorld,oUnit)
				end
			end
		end
	end)

	--触摸到世界的处理
	hGlobal.event:listen("LocalEvent_TouchDown_BF","__BF__DownOperate",function(oWorld,gridX,gridY,worldX,worldY)
		_bfopr_TouchTemp.CODE.OnTouchDown(worldX,worldY)
		if _TouchCondition(oWorld)==hVar.RESULT_SUCESS then
			--当前操作单位
			local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
			local CheckMoveOpr = 0
			local SwithOpr = 0
			if _BF_LastMoveData.opr=="Move" then	--移动指令
				CheckMoveOpr = 1
			elseif _BF_LastMoveData.opr=="MoveAndAttack" then	--单体近战技能
				local oTargetLast = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
				local oTarget = _bfopr_TouchTemp.CODE.GetDownTarget(oWorld,oUnit,worldX,worldY)
				if oTargetLast~=nil and oTarget==nil then
					--存在当前锁定目标，并且没有点到任何可转换目标，转换移动方格
					_BF_LastOperateMode = "MoveAndAttack"
					_TrySelectAttackGrid("down",oWorld,oUnit,gridX,gridY,worldX,worldY)
				elseif oTarget~=nil then
					--点到了合法目标
					local tGrid = _BF_LastMoveData.Target[oTarget.ID]
					if tGrid.type=="Move" or tGrid.type=="OutOfRange" then
						--移动到目标最近的格子
						SwithOpr = 1
						_BF_LastOperateMode = "Move"
						local v = _GetGridToGo(oWorld,oUnit,oTarget,tGrid,_BF_LastMoveData._MoveGrid)
						_TrySelectMoveGrid("down_unit",oWorld,oUnit,v.x,v.y,nil,nil,gridX,gridY)
					else--if tGrid.type=="MoveAndAttack" then
						--点到了可以攻击的敌人,并且在射程内,设置当前处理为技能攻击
						if _BF_LastMoveMode==1 then
							_BF_LastMoveMode = 0
							SwithOpr = 1
						end
						hApi.SetObjectEx(_BF_LastTarget,oTarget)
						_BF_LastOperateMode = "MoveAndAttack"
						if oTargetLast==oTarget then
							if not(_BF_LastGridX and _BF_LastGridY) then
								local g = _BF_LastMoveData.Target[oTarget.ID]
								if #g>0 then
									local v = g[hApi.random(1,#g)]
									_BF_LastGridX,_BF_LastGridY = v.x,v.y
								end
							end
							if _BF_LastGridX and _BF_LastGridY then
								_TrySelectAttackGrid("down_unit",oWorld,oUnit,_BF_LastGridX,_BF_LastGridY)
							end
						else
							--重置双击count
							_ResetConfirmClick()
							_TrySelectAttackGrid("down_unit",oWorld,oUnit,gridX,gridY,worldX,worldY)
						end
					end
				else
					if _BF_LastMoveMode==1 then
						CheckMoveOpr = 1
					end
				end
			elseif _BF_LastMoveData.opr=="Attack" then	--单体远程技能
				local oTargetLast = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
				--传送特殊处理
				if _BF_LastMoveData.oprEx=="teleport" then
					if oTargetLast~=nil then
						--已经选择过目标，选择格子
						_TrySelectGroundGrid("down",oWorld,oUnit,gridX,gridY)
						_BF_LastOperateMode = "Ground"
						if _BF_LastMoveMode==1 then
							CheckMoveOpr = 1
						end
					else
						--尚未选择目标，尝试选择单位
						local oTarget = _bfopr_TouchTemp.CODE.GetDownTarget(oWorld,oUnit,worldX,worldY)
						if oTarget~=nil then
							_BF_LastOperateMode = "ChooseTeleportTarget"
							_ResetConfirmClick()
							hApi.SetObjectEx(_BF_LastTarget,oTarget)
						end
					end
				else
					local oTarget = _bfopr_TouchTemp.CODE.GetDownTarget(oWorld,oUnit,worldX,worldY)
					if oTarget~=nil then
						--重置双击count
						if oTarget~=oTargetLast then
							_ResetConfirmClick()
						end
						hApi.SetObjectEx(_BF_LastTarget,oTarget)
						_BF_LastOperateMode = "Attack"
						_TrySelectAttackTarget("down_unit",oWorld,oUnit,oTarget)
					else
						if _BF_LastMoveMode==1 then
							CheckMoveOpr = 1
						end
					end
				end
			elseif _BF_LastMoveData.opr=="Ground" then	--地面操作模式
				local SelectGround = 1
				if _BF_LastOperateMode=="Ground" then
					_BF_LastOperateMode = "Ground"
					_TrySelectGroundGrid("down",oWorld,oUnit,gridX,gridY,worldX,worldY)
				else
					local oTarget = _bfopr_TouchTemp.CODE.GetDownTarget(oWorld,oUnit,worldX,worldY)
					if oTarget==nil and _BF_LastMoveMode==1 and _BF_LastMoveData._MoveGrid.gridI[gridX.."|"..gridY] then
						CheckMoveOpr = 1
					else
						_BF_LastOperateMode = "Ground"
						_TrySelectGroundGrid("down",oWorld,oUnit,gridX,gridY,worldX,worldY)
					end
				end
			elseif _BF_LastMoveData.opr=="Self" then	--自身施放模式
				_BF_LastOperateMode = "Self"
				_CountConfirmClick("down",gridX,gridY)
			end
			if CheckMoveOpr==1 then
				if _BF_LastMoveData._MoveGrid.gridI[gridX.."|"..gridY] then
					--否则点击到可移动方格时处理为移动
					SwithOpr = 1
					_BF_LastOperateMode = "Move"
					_TrySelectMoveGrid("down",oWorld,oUnit,gridX,gridY,nil,nil,gridX,gridY)
				else
					_BF_LastOperateMode = nil
				end
			end
			if SwithOpr==1 then
				if _BF_LastOperateMode=="Move" then
					hGlobal.event:event("LocalEvent_PlayerSwitchOprBF",oWorld,hVar.MOVE_SKILL_ID)		--玩家转换为移动操作
				elseif _BF_LastOperateMode~=nil and _BF_LastSkillId~=0 then
					hGlobal.event:event("LocalEvent_PlayerSwitchOprBF",oWorld,_BF_LastSkillId)		--玩家转换为施放一般技能操作
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_TouchMove_BF","__BF__MoveOperate",function(oWorld,gridX,gridY,worldX,worldY)
		_bfopr_TouchTemp.CODE.OnTouchMove(worldX,worldY)
		if _TouchCondition(oWorld)==hVar.RESULT_SUCESS then
			local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
			if _BF_LastOperateMode=="Move" then
				_TrySelectMoveGrid("drag",oWorld,oUnit,gridX,gridY,worldX,worldY,gridX,gridY)
			elseif _BF_LastOperateMode=="Ground" then
				_TrySelectGroundGrid("drag",oWorld,oUnit,gridX,gridY,worldX,worldY)
			elseif _BF_LastOperateMode=="MoveAndAttack" then
				--已锁定单位，尝试转换移动方格
				_TrySelectAttackGrid("drag",oWorld,oUnit,gridX,gridY,worldX,worldY)
			end
		end
	end)
	local _ConfirmSkillOpr = function(oWorld)
		if _IsConfirmClick() then
			local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
			if not(oUnit~=nil and oUnit:getcontroller()==hGlobal.LocalPlayer) then
				return
			end
			_ResetConfirmClick()
			local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
			if _BF_SelectedGridX==nil or _BF_SelectedGridY==nil then
				if oTarget then
					_BF_SelectedGridX = oTarget.data.gridX
					_BF_SelectedGridY = oTarget.data.gridY
				elseif oUnit then
					_BF_SelectedGridX = oUnit.data.gridX
					_BF_SelectedGridY = oUnit.data.gridY
				else
					_BF_SelectedGridX = 0
					_BF_SelectedGridY = 0
				end
			end
			hApi.safeRemoveT(oWorld.worldUI,"__BF__TargetHint")
			if _BF_LastOperateMode=="Move" then
				_BF_LastOperateMode = "End"
				oWorld:drawgrid("TargetGridHint","clear")
				oWorld:drawgrid("TargetGridHintX","clear")
				return hGlobal.event:event("LocalEvent_PlayerConfirmOperateBF",oWorld,oUnit,hVar.MOVE_SKILL_ID,nil,_BF_SelectedGridX,_BF_SelectedGridY)
			elseif _BF_LastOperateMode=="Guard" then
				_BF_LastOperateMode = "End"
				oWorld:drawgrid("TargetGridHint","clear")
				oWorld:drawgrid("TargetGridHintX","clear")
				return hGlobal.event:event("LocalEvent_PlayerConfirmOperateBF",oWorld,oUnit,hVar.GUARD_SKILL_ID,nil,_BF_SelectedGridX,_BF_SelectedGridY)
			else
				_BF_LastOperateMode = "End"
				if _BF_LastMoveData.opr=="MoveAndAttack" then
					if oTarget and _BF_LastMoveData.Target[oTarget.ID] and #_BF_LastMoveData.Target[oTarget.ID]>0 then
						local sus = 0
						local tGrid = _BF_LastMoveData.Target[oTarget.ID]
						for i = 1,#tGrid do
							local v = tGrid[i]
							if v.x==_BF_SelectedGridX and v.y==_BF_SelectedGridY then
								sus = 1
								break
							end
						end
						if sus==0 then
							local v = tGrid[hApi.random(1,#tGrid)]
							_BF_SelectedGridX = v.x
							_BF_SelectedGridY = v.y
						end
						return hGlobal.event:event("LocalEvent_PlayerConfirmOperateBF",oWorld,oUnit,_BF_LastSkillId,oTarget,_BF_SelectedGridX,_BF_SelectedGridY)
					end
				else
					return hGlobal.event:event("LocalEvent_PlayerConfirmOperateBF",oWorld,oUnit,_BF_LastSkillId,oTarget,_BF_SelectedGridX,_BF_SelectedGridY)
				end
			end
		end
	end
	hGlobal.event:listen("LocalEvent_TouchUp_BF","__BF__UpOperate",function(oWorld,gridX,gridY,worldX,worldY)
		if g_phone_mode==3 then
			hGlobal.event:event("LocalEvent_BFTouchLog","touchUP:"..tostring(_BF_LastOperateMode))
		end
		_bfopr_TouchTemp.CODE.OnTouchUp(worldX,worldY)
		if _TouchCondition(oWorld)==hVar.RESULT_SUCESS and _BF_LastOperateMode~=nil and _BF_LastMoveData~=nil then
			if _BF_LastOperateMode=="ChooseTeleportTarget" then
				local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
				local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
				if oTarget~=nil and oTarget==oWorld:hit4unit(worldX,worldY,"up_unit",oTarget) then
					return _CODE_ChooseTeleportTarget("up_unit",oWorld,oUnit,oTarget)
				else
					_BF_LastOperateMode = nil
					hApi.SetObjectEx(_BF_LastTarget,nil)
				end
			end
			if _IsConfirmClick() then
				return _ConfirmSkillOpr(oWorld)
			end
		end
	end)

	--点到了世界地图上，创建一个移动按钮
	hGlobal.event:listen("LocalEvent_TouchOnWorld","__BF__CommonOperate",function(oWorld,worldX,worldY)
		if oWorld==hGlobal.LocalPlayer:getfocusworld() then
			--取消上一个角色的攻击范围显示
			_ShowTDAttackRange(nil)
		end
	end)
	--获得当前操作的技能
	hApi.BF_GetOprSkill = function()
		return _BF_LastSkillId,_BF_MoveDataList,_BF_LastOperateMode
	end
	hApi.BF_GetOprUnit = function()
		return hGlobal.LocalPlayer:getfocusunit() --当前旋中的角色
		--return hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
	end
	hApi.BF_GetOprTarget = function()
		return hApi.GetObjectEx(hClass.unit,_BF_LastTarget)
	end
	--从可到达方格中选择一个
	local _ChooseXYFromGrid = function(oUnit,tGrid,oTarget,modeEx)
		local oWorld = oUnit:getworld()
		if oWorld==nil then
			return -1
		end
		if tGrid~=nil and tGrid.type=="MoveAndAttack" and #tGrid>0 then
			local NeedSelectXY = 1
			if NeedSelectXY==1 then
				for i = 1,#tGrid do
					local v = tGrid[i]
					if v.x==_BF_SelectedGridX and v.y==_BF_SelectedGridY then
						NeedSelectXY = 0
						break
					end
				end
			end
			if NeedSelectXY==1 then
				for i = 1,#tGrid do
					local v = tGrid[i]
					if v.x==oUnit.data.gridX and v.y==oUnit.data.gridY then
						NeedSelectXY = 0
						break
					end
				end
			end
			if NeedSelectXY==1 then
				local v = tGrid[hApi.random(1,#tGrid)]
				_BF_SelectedGridX = v.x
				_BF_SelectedGridY = v.y
			end
			if not(_BF_SelectedGridX and _BF_SelectedGridY) then
				_BF_SelectedGridX = oUnit.data.gridX
				_BF_SelectedGridY = oUnit.data.gridY
			end
			return 1
		elseif modeEx=="Move" then
			if tGrid==nil then
				if _BF_MoveDataList.MoveTarget[oTarget.ID]==nil then
					_BF_MoveDataList.MoveTarget[oTarget.ID] = {}
				end
				tGrid = _BF_MoveDataList.MoveTarget[oTarget.ID]
			end
			local v = _GetGridToGo(oWorld,oUnit,oTarget,tGrid,_BF_LastMoveData._MoveGrid)
			if v.link then
				_BF_SelectedGridX = v.link.x
				_BF_SelectedGridY = v.link.y
			else
				_BF_SelectedGridX = v.x
				_BF_SelectedGridY = v.y
			end
			return 0
		else
			return -1
		end
	end
	--确认施放技能
	hApi.BF_ConfirmSkillOpr = function(oTarget,nSkillId)
		if _BF_LastOperateMode=="End" then
			return
		end
		local oWorld = _BF_oWorld
		if not(oWorld and oWorld.ID~=0) then
			return
		end
		local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOperateUnit)
		if _TouchCondition(oWorld)==hVar.RESULT_SUCESS and _BF_LastMoveData.oprEx==nil and oUnit~=nil and oUnit:getcontroller()==hGlobal.LocalPlayer then
			if oTarget~=nil and oTarget.data.IsDead~=1 then
				local tGrid = _BF_LastMoveData.Target[oTarget.ID]
				if nSkillId==hVar.MOVE_SKILL_ID then
					--必然成功
					_BF_LastOperateMode = "Move"
					if oTarget==oUnit then
						--移动到自己视为防御指令
						_BF_LastOperateMode = "Guard"
					elseif _ChooseXYFromGrid(oUnit,tGrid,oTarget,"Move")>=0 then
						_BF_LastOperateMode = "Move"
						_DrawHintGrid("unit",oWorld,oUnit,_BF_SelectedGridX,_BF_SelectedGridY)
					end
				elseif nSkillId==_BF_MoveDataList.nAttackId and oUnit==oTarget and tGrid==nil then
					--点到了自己
					_BF_LastOperateMode = "Guard"
				elseif tGrid~=nil then
					hApi.SetObjectEx(_BF_LastTarget,oTarget)
					if _BF_LastMoveData.opr=="MoveAndAttack" and _ChooseXYFromGrid(oUnit,tGrid,oTarget,"Move")==0 then
						_BF_LastOperateMode = "Move"
						_DrawHintGrid("unit",oWorld,oUnit,_BF_SelectedGridX,_BF_SelectedGridY)
					end
				else
					return
				end
			end
			_CountConfirmClick("down",0,0)
			return _ConfirmSkillOpr(oWorld)
		end
	end
	--创建目标提示图标
	hApi.BF_CreateHintImage = function(oWorld,model,animation,wx,wy,w,h,ix,iy,motion)
		local oPanel = oWorld.worldUI["__BF__TargetHint"]
		if oPanel then
			local img = oPanel.childUI["img"]
			if img and img.data.model==model then
				if animation and img.data.animation~=animation then
					img:setmodel(model,animation,nil,w,h)
				end
				if not(oPanel.data.x==wx and oPanel.data.y==wx) then
					oPanel:setXY(wx,wy)
				end
				return
			end
		end
		hUI.panel:new({
			bindTag = "__BF__TargetHint",
			world = oWorld,
			x = wx,
			y = wy,
			z = 9999,
			child = {
				{
					__UI = "image",
					__NAME = "img",
					model = model,
					animation = animation,
					x = ix,
					y = iy,
					w = w,
					h = h,
					motion = motion,
					IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_BF,
				},
			},
		})
	end
end

--战场内战术布局
hGlobal.UI.InitBattlefieldReadyUI = function()
	local _gCode = function(x,y,p)
		p[#p+1] = {x=x,y=y}
		p[#p+1] = {x=x,y=y}
		p[#p+1] = {x=x,y=y}
	end
	----------------------------
	--战场创建,创建布置界面
	hGlobal.event:listen("LocalEvent_PlayerEnterBattlefield","__BF__RoundPlaceStep",function(oWorld,oUnit,oTarget)
		local _frame
		local w = oWorld
		local placeable_node = {}
		local placeable_grid = {}
		local _PlaceCols = {0,0}
		local oHero = oUnit:gethero()
		local tactics = 0
		if oHero~=nil and oUnit:getowner()==hGlobal.LocalPlayer then
			--如果英雄具有战术等级，则可放置的格子距离将加上战术等级
			tactics = oHero.attr.tactics
		end
		--tactics = 3
		--只有具有战术等级的英雄才能布置单位
		--并且非PVP模式才能布置单位
		if tactics>0 and oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.NORMAL then
			for i = 1,oWorld.__LOG.i do
				local v = oWorld.__LOG[i]
				if v.key=="EnterBattle" then
					if v.unit.owner==hGlobal.LocalPlayer.data.playerId then
						oWorld:gettacticalgrid(v.teamId,math.min(tactics,3),placeable_grid,placeable_node)
						break
					end
				end
			end
		else
			--否则直接进战斗
			return hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.PLAYER_ROUND_READY)
		end
		w:drawgrid("placeable_grid","green",placeable_grid)

		local safeX,safeY
		local function _SetSafePlaceableGrid(gx,gy,w,t)
			safeX,safeY = gx,gy
			w:drawgrid("default","draw","unclear")
			local showGrid = {}
			if hApi.enumNearGrid(safeX,safeY,t:getblock(),_gCode,showGrid)~=hVar.RESULT_SUCESS then	--EFF BLOCK
				gCode(safeX,safeY,showGrid)
			end
			w:drawgrid("place_gridU","green",showGrid,"unrecord")
		end

		local function _CalSafePlaceableGrid(gx,gy,w,t)
			local _PlaceMaxW = tactics
			local _PlaceMaxH = w.data.h-1
			if gy>=0 and gy<=_PlaceMaxH and (gx<0 or gx>_PlaceMaxW) then
				local sX,eX,pX = _PlaceMaxW,0,-1
				if gx<0 then
					sX,eX,pX = 0,_PlaceMaxW,1
				end
				for gx = sX,eX,pX do
					if w:safeGridU(t,gx,gy,placeable_node)==hVar.RESULT_SUCESS then
						return gx,gy
					end
				end
			elseif gx>=0 and gx<=_PlaceMaxW and (gy<0 or gy>_PlaceMaxH) then
				--如果不合法的话自动选择一个
				local sY,eY,pY = _PlaceMaxH,0,-1
				if gy<0 then
					sY,eY,pY = 0,_PlaceMaxH,1
				end
				for gy = sY,eY,pY do
					if w:safeGridU(t,gx,gy,placeable_node)==hVar.RESULT_SUCESS then
						return gx,gy
					end
				end
			end
		end

		local _enum_NearGrid = function(gx,gy,tTemp)
			tTemp[#tTemp+1] = {x=gx,y=gy}
		end

		local _enum_GetUnitBlock = function(oUnit,oWorld,tTemp)
			local gx,gy = oUnit.data.gridX,oUnit.data.gridY
			if placeable_node[oWorld:grid2n(gx,gy)]==1 then
				hApi.enumNearGrid(gx,gy,oUnit:getblock(),_enum_NearGrid,tTemp)
			end
		end

		_frame = hGlobal.O:replace("BF_Frame_PlaceStep",hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			autoactive = 0,
			dragable = 2,
			batchmodel = "NONE",
			codeOnTouch = function(self,ux,uy,IsInside)
				--这里以左上角为基准
				local wx,wy = hApi.view2world(ux,-1*uy)
				local gx,gy = w:xy2grid(wx,wy)
				local _gx,_gy = w:safeGrid(gx,gy)
				local t = w:hit2unit(wx,wy,"battlefield_place")
				if t~=nil and t.data.indexOfTeam~=0 and t.data.owner==hGlobal.LocalPlayer.data.playerId then
					local pSprite,handleTable = t:copyimage(hUI.__static.uiLayer)
					hApi.SpriteSetAnimation(handleTable,"walk")
					pSprite:runAction(CCFadeTo:create(0,180))
					pSprite:setPosition(-512,-512)
					local tTemp = {}
					w:enumunit(_enum_GetUnitBlock,w,tTemp)
					w:drawgrid("place_blockU","gray",tTemp)
					local cx,cy
					_SetSafePlaceableGrid(t.data.gridX,t.data.gridY,w,t)
					hUI.dragBox:new({
						node = 0,
						autorelease = 1,
						codeOnDrag = function(x,y,ux,uy)
							pSprite:setPosition(ux,uy)
							local wx,wy = hApi.ui2world(ux,uy)
							local gx,gy = w:xy2grid(wx-t.data.standX,wy-t.data.standY)
							if cx~=gx or cy~=gy then
								cx,cy = gx,gy
								if w:safeGridU(t,gx,gy,placeable_node)==hVar.RESULT_SUCESS then
									_SetSafePlaceableGrid(gx,gy,w,t)
								else
									local nx,ny = _CalSafePlaceableGrid(gx,gy,w,t)
									if nx and ny then
										_SetSafePlaceableGrid(nx,ny,w,t)
									end
								end
							end
						end,
						codeOnDrop = function(x,y,screenX,screenY)
							pSprite:getParent():removeChild(pSprite,true)
							w:drawgrid("place_gridU","clear")
							w:drawgrid("place_blockU","clear")
							w:drawgrid("default","draw","unclear")
							if safeX~=nil and safeY~=nil and not(safeX==t.data.gridX and safeY==t.data.gridY) then
								hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.PLACE_TO,t,hVar.ZERO,nil,safeX,safeY)
							end
						end,
					}):select()
				end
			end,
			child = {
				{
					__UI = "label",
					__NAME = "stepHint",
					text = hVar.tab_string["__TEXT_PlaceStep"],
					size = 48,
					align = "MC",
					RGB = {255,205,55},
					x = hVar.SCREEN.w/2,
					y = -1*math.floor(hVar.SCREEN.h*0.38),
					font = hVar.FONTC,
					border = 1,
				},
				{
					__UI = "button",
					__NAME = "exit",
					mode = "imageButton",
					model = "UI:ButtonBack2",
					label = hVar.tab_string["Exit_Ack"],
					align = "MC",
					border = 1,
					scaleT = 0.9,
					font = hVar.FONTC,
					border = 1,
					x = hVar.SCREEN.w/2,
					y = 98-hVar.SCREEN.h,
					code = function()
						hGlobal.O:del("BF_Frame_PlaceStep")
						w:drawgrid("default","draw")
						hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.PLAYER_ROUND_READY)
					end,
				},
			},
		}))
	end)
end

--战场内单位血条和漂浮文字 zhenkira delete 2016.7.12
hGlobal.UI.InitBattlefieldUnitHpBarAndText = function()
	--显示单位的数量和血量
	--hGlobal.event:listen("Event_UnitBorn","__BF__InitUnitHpUI",function(oUnit)
	--	local u = oUnit
	--	local w = u:getworld()
	--	if w~=nil and w.data.type=="battlefield" and oUnit.attr.hp>0 and w.data.IsQuickBattlefield~=1 then
	--		local d = u.data
	--		local y = -20
	--		local x = -17
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
	--					align = "RC",
	--					x = x+17-20,
	--					y = y,
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
	--					align = "LC",
	--					x = x+17+20,
	--					y = y,
	--				})
	--			end
	--		end
	--	end
	--end)

	--hGlobal.event:listen("Event_UnitHealed","__BF__ShowChaHealed",function(oUnit,nSkillId,nDmgMode,nHeal,nRevive,oAttacker)
	--	local w = oUnit:getworld()
	--	if w~=nil and w.data.type=="battlefield" and w.data.IsQuickBattlefield~=1 then
	--		local moveY = 8
	--		local jumpH = 10
	--		local floatMode = "boom"
	--		local floatScale = 1.3
	--		local floatSize = 14
	--		hUI.floatNumber:new({
	--			unit = oUnit,
	--			font = "numGreen",
	--			mode = floatMode,
	--			scale = floatScale,
	--			size = floatSize,
	--			text = "+"..tostring(nHeal),
	--			lifetime = 1500,
	--			fadeout = -500,
	--			y = 32,
	--			moveY = moveY,
	--			jumpH = jumpH,
	--		})
	--		if nRevive>0 then
	--			hUI.floatNumber:new({
	--				unit = oUnit,
	--				font = "numWhite",
	--				size = 18,
	--				text = "+"..tostring(math.abs(nRevive)),
	--				lifetime = 1500,
	--				fadeout = -500,
	--				y = 0,
	--				icon = "ICON:icon01_x14y3",
	--				iconScale = 0.25,
	--				moveY = 4,
	--				jumpH = 10,
	--			})
	--		end
	--		if nRevive~=0 and oUnit.chaUI["number"] then
	--			oUnit.chaUI["number"]:setText(tostring(oUnit.attr.stack))
	--		end
	--		if oUnit.chaUI["hp"] then
	--			oUnit.chaUI["hp"]:setV(oUnit.attr.hp,oUnit.attr.mxhp)
	--		end
	--	end
	--end)
end

--------------------------------
-- 战场出手顺序条(pad)
--------------------------------
hGlobal.UI.InitBattlefieldActionList = function()
	local _BAL_FrmXYWH
	local _BAL_ActionCardNum = 9
	if g_phone_mode==0 then
		--PAD可用
		_BAL_FrmXYWH = {8,81,710,100}
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

--目标信息面板
hGlobal.UI.InitBattlefieldTargetInfoFrm = function()
	local _BTP_FrmXYWH = {0,0,hVar.SCREEN.w,96}
	if g_phone_mode==1 then
		--IP4
		_BTP_FrmXYWH[2] = 310
	elseif g_phone_mode==2 then
		--IP5
		_BTP_FrmXYWH[2] = 96
	elseif g_phone_mode==3 then
		--安卓
		_BTP_FrmXYWH[1] = 140
		_BTP_FrmXYWH[2] = 280
		_BTP_FrmXYWH[3] = 1024
	else
		--IPAD
		_BTP_FrmXYWH[2] = 280
	end
	local _IconX = function(i)
		return 250+150*(i-1)
	end
	local _ValueX = function(i)
		return 266+150*(i-1)
	end
	local _LineY = function(i)
		return -30-23*(i-1)
	end
	local _LineW = 110

	local _UnitId = 0
	local _BF_LastActivedUnit = {}
	local _BF_LastLockTarget = {}
	local _BF_LastOprId = 0

	local _InitChildBtn = function(tLabelList)
		local tChild = {
			{
				__UI = "label",
				__NAME = "TargetName",
				x = 160,
				y = -92,
				z = 2,
				font = hVar.FONTC,
				text = "NAME",
				align = "MB",
				border = 1,
			},
			--预处理伤害数字
			{
				__UI = "label",
				__NAME = "DmgNum",
				x = 12,
				y = -72,
				z = 2,
				size = 16,
				font = "numWhite",
				text = "100~200",
				align = "LC",
			},
			--显示选定的技能
			{
				__UI = "button",
				__NAME = "BtnCast",
				x = 48,
				y = -28,
				w = 48,
				h = 48,
				z = 2,
				model = "MODEL:Default",
				scaleT = 0.9,
				codeOnTouch = function(self,x,y)
					local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget)
					if oTarget~=nil then
						return hApi.BF_ConfirmSkillOpr(oTarget,_BF_LastOprId)
					end
				end,
			},
		}
		for i = 1,#tLabelList do
			local v = tLabelList[i]
			local key = v[2]
			local gx,gy = v[3][1],v[3][2]
			tChild[#tChild+1] = {
				__UI = "image",
				__NAME = key.."Icon",
				x = _IconX(gx),
				y = _LineY(gy),
				w = 22,
				h = 22,
				model = v[4][1],
				animation = v[4][2],
			}
			if v[1]=="bar" then
				tChild[#tChild+1] = {
					__UI = "valbar",
					__NAME = key.."Bar",
					x = _ValueX(gx),
					y = _LineY(gy),
					w = _LineW,
					h = 8,
					align = "LC",
					model = v[4][4],
					animation = v[4][5],
					back = {model = v[4][6],x = -2,h=10,w=_LineW+4},
					v = 100,
					max = 100,
				}
				tChild[#tChild+1] = {
					__UI = "label",
					__NAME = key.."Num",
					x = _ValueX(gx)+_LineW/2,
					y = _LineY(gy),
					size = 12,
					font = v[4][3] or "numWhite",
					text = "*",
					align = "MC",
				}
			elseif v[1]=="val" or v[1]=="valX" then
				tChild[#tChild+1] = {
					__UI = "label",
					__NAME = key.."Num",
					x = _ValueX(gx),
					y = _LineY(gy),
					size = 12,
					font = v[4][3] or "numWhite",
					text = "*",
					align = "LC",
				}
				if v[1]=="valX" then
					tChild[#tChild+1] = {
						__UI = "label",
						__NAME = "AtkPecNum",
						x = _ValueX(gx)+68,
						y = _LineY(gy),
						size = 12,
						font = "numWhite",
						text = "*",
						align = "LC",
					}
				end
			end
		end
		return tChild
	end
	local tLabelList = {
		{"bar","Hp",{1,1},{"ICON:HeroAttr","hp_pec","numGreen","UI:IMG_ValueBar","green","UI:BAR_ValueBar_BG"}}, --血量
		{"bar","Mp",{1,2},{"ICON:HeroAttr","mp_pec","numBlue","UI:IMG_ValueBar","green","UI:BAR_ValueBar_BG"}}, --法力水晶
		{"valX","Atk",{2,1},{"ICON:action_attack"}},
		{"val","Stack",{1,2},{"ICON:PartArmy"}}, --三个人图标
		{"val","Toughness",{1,3},{"ICON:icon01_x1y1"}}, --法防图标
		{"val","Def",{2,2},{"ICON:DETICON"}}, --物防图标
		{"val","CastPow",{3,1},{"ICON:icon01_x2y9"}}, --魔法瓶图标
		{"val","HealPow",{3,2},{"ICON:skill_icon_x1y1"}},
		{"val","Mov",{2,3},{"ICON:MOVERANGE"}}, --三个格子图标
		{"val","Spd",{3,3},{"ICON:MOVESPEED"}},
	}
	hGlobal.UI.BF_TargetInfoFrm = hUI.frame:new({
		x = _BTP_FrmXYWH[1],
		y = _BTP_FrmXYWH[2],
		w = _BTP_FrmXYWH[3],
		h = _BTP_FrmXYWH[4],
		z = -1,
		dragable = 2,
		buttononly = 1,
		closebtn = 0,
		background = "misc/selectbg.png",
		show = 0,
		codeOnTouch = function()
			print("Hit!")
		end,
		child = _InitChildBtn(tLabelList),
	})

	local _FrmT = hGlobal.UI.BF_TargetInfoFrm
	_FrmT.childUI["BtnCast"].data.w = _BTP_FrmXYWH[3]
	_FrmT.childUI["BtnCast"].data.h = _BTP_FrmXYWH[4]
	_FrmT.childUI["BtnCast"].data.ox = _BTP_FrmXYWH[3]/2
	_FrmT.childUI["BtnCast"].data.oy = -1*_BTP_FrmXYWH[4]/2
	_FrmT.childUI["BtnCast"]:setXY(0,0)
	_FrmT.childUI["BtnCast"].data.w = 48
	_FrmT.childUI["BtnCast"].data.h = 48
	_FrmT.childUI["BtnCast"].data.ox = 0
	_FrmT.childUI["BtnCast"].data.oy = 0
	_FrmT.childUI["BtnCast"].handle._n:setPosition(48,-28)
	_FrmT.childUI["BtnCast"]:setstate(-1)
	local _nBuffCount = 0
	local _tBuffData = {0,0,0,0,0,0}
	for i = 1,#_tBuffData do
		_tBuffData[i] = {0,0,0,0,0}		--sIcon,nNeedUpdate,nType,id,lv
		_FrmT.childUI["BtnBuffIcon_"..i] = hUI.button:new({
			parent = _FrmT,
			x = 588 + 60*i,
			y = -96/2,
			w = 48,
			h = 48,
			z = 3,
			model = "MODEL:Default",
			scaleT = 0.9,
			codeOnTouch = function()
				hGlobal.event:event("LocalEvent_BFShowBuffInfoFrm",_tBuffData[i])
			end,
		})
		_FrmT.childUI["BtnBuffIcon_"..i]:setstate(-1)
	end
	local _CODE_SetBuffIconData = function(nCount,nType,sIcon,id,lv,dur,param)
		local v = _tBuffData[nCount]
		if v~=nil then
			if v[1]~=sIcon then
				v[1] = sIcon
				v[2] = 1
			end
			v[3] = nType
			v[4] = id
			v[5] = lv
			v[6] = dur
			v[7] = param
		end
		return nCount
	end
	local _CODE_AppendBuffIconData = function(nType,sIcon,id,lv,dur,param)
		if nType=="reset" then
			_nBuffCount = 0
			for i = 1,#_tBuffData do
				for n = 2,#_tBuffData[i] do
					_tBuffData[i][n] = 0
				end
			end
		else
			_nBuffCount = _nBuffCount + 1
			_CODE_SetBuffIconData(_nBuffCount,nType,sIcon,id,lv,dur,param or 0)
		end
	end
	local _CODE_UpdateBuffIcon = function()
		for i = 1,#_tBuffData do
			if _tBuffData[i][3]~=0 then
				if _tBuffData[i][2]~=0 then
					_FrmT.childUI["BtnBuffIcon_"..i]:loadsprite(_tBuffData[i][1])
				end
				_FrmT.childUI["BtnBuffIcon_"..i]:setstate(1)
			else
				_FrmT.childUI["BtnBuffIcon_"..i]:setstate(-1)
			end
		end
	end
	_CODE_TargetInfoFrmShiftOpr = function(oUnit,nSkillId,oTarget)
		if oUnit and oUnit.ID>0 and oUnit:getcontroller()==hGlobal.LocalPlayer and nSkillId and oTarget and oTarget.ID~=0 then
			local AttackId = hApi.GetDefaultSkill(oUnit)
			local IsAttack = nSkillId==AttackId and 1 or 0
			if IsAttack==1 and oUnit==oTarget and hApi.IsSafeTarget(oUnit,nSkillId,oTarget)~=hVar.RESULT_SUCESS then
				_FrmT.childUI["BtnCast"]:loadsprite("ui/cmd_defend.png")
				_FrmT.childUI["BtnCast"].handle.s:setColor(ccc3(255,255,255))
				_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
				return
			else
				local tabS = hVar.tab_skill[nSkillId]
				if tabS then
					_FrmT.childUI["BtnCast"]:loadsprite(tabS.icon or "MODEL:Default")
					_FrmT.childUI["BtnCast"].handle.s:setColor(ccc3(255,255,255))
					if nSkillId==hVar.MOVE_SKILL_ID then
						--移动技能不计算任何东西
						_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
						return
					elseif hApi.IsSafeTarget(oUnit,nSkillId,oTarget) then
						--是合法目标的话计算预处理伤害
						local nDmgMode = 0
						local sDmgValue
						local dMin,dMax,hMin,hMax = hApi.CalculateSkillDamage(oUnit,nSkillId)
						if hMax>0 then
							local a,b = oUnit:calculate("HealDamage",oTarget,hMin,hMax,100,nSkillId,nDmgMode)
							local att = oTarget.attr
							local mxHeal = att.mxhp*att.__stack - att.hp - att.mxhp*(att.stack-1)
							if mxHeal<a then
								b = b
							elseif mxHeal<b then
								b = mxHeal
							end
							if a==b then
								sDmgValue = "+"..a
							else
								sDmgValue = "+"..a.."~"..b
							end
							_FrmT.childUI["DmgNum"].handle.s:setColor(ccc3(0,255,0))
						elseif dMax>0 then
							local a,b = oUnit:calculate("CombatDamage",oTarget,dMin,dMax,100,nSkillId,nDmgMode,IsAttack)
							if a==b then
								sDmgValue = a
							else
								if b>9999 then
									sDmgValue = a.."\n ~"..b
								else
									sDmgValue = a.."~"..b
								end
							end
							_FrmT.childUI["DmgNum"].handle.s:setColor(ccc3(255,0,0))
						end
						if sDmgValue then
							_FrmT.childUI["DmgNum"].handle._n:setVisible(true)
							_FrmT.childUI["DmgNum"]:setText(sDmgValue)
						else
							_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
						end
						return
					end
				end
			end
		end
		_FrmT.childUI["BtnCast"].handle.s:setColor(ccc3(128,128,128))
		_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
	end
	local _SetLableNum = function(sLabelName,nMode,nVal,nBaseVal)
		local oLabel = _FrmT.childUI[sLabelName]
		if oLabel then
			local v = nVal - (nBaseVal or 0)
			local sTail = ""
			local sPre = ""
			local sDefalut = "0"
			local R,G,B = 255,255,255
			local dR,dG,dB = 255,0,0
			if nMode==1 then
				--百分比模式,正数为绿色
				sTail = "%"
				sPre = "+"
				R,G,B = 0,255,0
				sDefalut = "*"
			end
			if v>0 then
				oLabel:setText(sPre..v..sTail)
				oLabel.handle.s:setColor(ccc3(R,G,B))
			elseif v<0 then
				oLabel:setText(v..sTail)
				oLabel.handle.s:setColor(ccc3(dR,dG,dB))
			else
				oLabel:setText(sDefalut)
				oLabel.handle.s:setColor(ccc3(255,255,255))
			end
		end
	end
	local _CODE_ClearTargetInfoFrm = function(mode)
		if mode=="clear" then
			_UnitId = 0
			hApi.safeRemoveT(_FrmT.childUI,"TargetThumb")
		end
		_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
		_FrmT.childUI["BtnCast"]:setstate(-1)
		hApi.SetObjectEx(_BF_LastLockTarget,nil)
		_FrmT:show(0)
	end
	--显示信息面板
	hGlobal.event:listen("LocalEvent_BFShowTargetInfoFrm","__show",function(sTriggerMode,oTarget,oUnit,nSkillId)
		if oTarget==nil then
			--隐藏
			return _CODE_ClearTargetInfoFrm(sTriggerMode)
		end
		if _UnitId~=oTarget.data.id then
			_UnitId = oTarget.data.id
			hApi.safeRemoveT(_FrmT.childUI,"TargetThumb")
			if hVar.tab_stringU[oTarget.data.id][1]~=nil then
				_FrmT.childUI["TargetName"]:setText(hVar.tab_stringU[oTarget.data.id][1])
			else
				_FrmT.childUI["TargetName"]:setText("")
			end
			local tabU = hVar.tab_unit[_UnitId]
			if tabU then
				if tabU.type==hVar.UNIT_TYPE.HERO and tabU.portrait~=nil then
					_FrmT.childUI["TargetThumb"] = hUI.thumbImage:new({
						parent = _FrmT.handle._n,
						x = 160,
						y = 128/2-96,
						w = 128,
						h = 128,
						id = _UnitId,
						facing = 180,
						mode = "portrait",
					})
				else
					local w,h = hApi.GetUnitImageWH(oTarget.data.id,128,128)
					_FrmT.childUI["TargetThumb"] = hUI.thumbImage:new({
						parent = _FrmT.handle._n,
						x = 160,
						y = 128/2-96-24,
						w = w,
						h = h,
						unit = oTarget,
						facing = 180,
					})
				end
			end
		end
		if hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget)~=oTarget then
			hApi.SetObjectEx(_BF_LastLockTarget,oTarget)
		end
		--刷新属性
		local a = oTarget.attr
		_FrmT.childUI["AtkNum"]:setText(a.attack[4].."~"..a.attack[5])
		if a.power==100 then
			_FrmT.childUI["AtkPecNum"].handle._n:setVisible(false)
		else
			_FrmT.childUI["AtkPecNum"].handle._n:setVisible(true)
			if a.power>100 then
				_FrmT.childUI["AtkPecNum"]:setText("+"..(a.power-100).."%")
				_FrmT.childUI["AtkPecNum"].handle.s:setColor(ccc3(0,255,0))
			else
				_FrmT.childUI["AtkPecNum"]:setText((a.power-100).."%")
				_FrmT.childUI["AtkPecNum"].handle.s:setColor(ccc3(255,0,0))
			end
			local px,py = _FrmT.childUI["AtkNum"]:getWH()
			_FrmT.childUI["AtkPecNum"]:setXY(_FrmT.childUI["AtkNum"].data.x+2+px/2,_FrmT.childUI["AtkPecNum"].data.y)
		end
		_SetLableNum("DefNum",0,a.def)
		_FrmT.childUI["SpdNum"]:setText(a.activity)
		_FrmT.childUI["MovNum"]:setText(math.min(99,math.max(0,a.move)))
		_SetLableNum("HealPowNum",1,a.healpower)
		_SetLableNum("CastPowNum",1,a.castpower)
		_FrmT.childUI["ToughnessNum"]:setText(a.stunimmunity.."("..a.toughness..")")
		if a.mxhp==-1 then
			--生命未知的单位
			_FrmT.childUI["HpBar"]:setV(100,100)
			_FrmT.childUI["HpNum"]:setText("???/???")
		else
			--普通单位
			_FrmT.childUI["HpBar"]:setV(a.hp,a.mxhp)
			if a.exhp>0 then
				_FrmT.childUI["HpNum"]:setText(a.hp.."(+"..a.exhp..")/"..a.mxhp)
			else
				_FrmT.childUI["HpNum"]:setText(a.hp.."/"..a.mxhp)
			end
		end
		if oTarget:gethero()~=nil then
			_FrmT.childUI["MpBar"]:setV(a.mp,a.mxmp)
			_FrmT.childUI["MpNum"]:setText(a.mp.."/"..a.mxmp)
			_FrmT.childUI["MpBar"].handle._n:setVisible(true)
			_FrmT.childUI["MpNum"].handle._n:setVisible(true)
			_FrmT.childUI["MpIcon"].handle._n:setVisible(true)
			_FrmT.childUI["StackIcon"].handle._n:setVisible(false)
			_FrmT.childUI["StackNum"].handle._n:setVisible(false)
		else
			_FrmT.childUI["StackNum"]:setText(a.stack.."("..math.min(0,a.stack-a.__stack)..")")
			_FrmT.childUI["MpBar"].handle._n:setVisible(false)
			_FrmT.childUI["MpNum"].handle._n:setVisible(false)
			_FrmT.childUI["MpIcon"].handle._n:setVisible(false)
			_FrmT.childUI["StackIcon"].handle._n:setVisible(true)
			_FrmT.childUI["StackNum"].handle._n:setVisible(true)
		end
		if nSkillId==0 then
			_FrmT.childUI["BtnCast"]:setstate(-1)
			_FrmT.childUI["DmgNum"].handle._n:setVisible(false)
		else
			_FrmT.childUI["BtnCast"]:setstate(1)
			_CODE_TargetInfoFrmShiftOpr(oUnit,nSkillId,oTarget)
		end
		_CODE_AppendBuffIconData("reset")
		local oWorld = oTarget:getworld()
		if oWorld then
			--显示城墙减免
			if oTarget.data.IsCovered==1 then
				local nPec = math.max(0,100-oWorld.data.cover.pec)
				if nPec>0 then
					local id = 41
					local tabS = hVar.tab_skill[id]
					if tabS then
						local sIcon = tabS.icon or 0
						_CODE_AppendBuffIconData(1,sIcon,id,1,0,{nPec})	--城墙减免
					end
				end
			end
			--显示战术技能(召唤生物不受战术卡片加成)
			if oWorld.data.tactics~=0 and oWorld.data.tactics[oTarget.data.owner] and oTarget.data.IsSummoned==0 then
				local tacticsList = oWorld.data.tactics[oTarget.data.owner]
				for i = 1,#tacticsList do
					if type(tacticsList[i])=="table" then
						local id = tacticsList[i][1]
						local lv = tacticsList[i][2]
						local tabT = hVar.tab_tactics[id]
						if tabT and tabT.skillId and tabT.skillId~=0 then
							local tabS = hVar.tab_skill[tabT.skillId]
							if tabS and type(tabS.targetEx)=="table" and hApi.CheckUnitTypeEx(oTarget,tabS.targetEx) then
								local sIcon = hVar.tab_tactics[id].icon or 0
								if (tabT.duration or 0)>0 then
									local dur = tabT.duration-oWorld.data.roundcount
									if dur>0 then
										_CODE_AppendBuffIconData(2,sIcon,id,lv,dur,0)	--有持续时间的战术技能
									end
								else
									_CODE_AppendBuffIconData(2,sIcon,id,lv,0,0)	--战术技能
								end
							end
						end
					end
				end
			end
			--本地玩家才显示的翰林院技能
			if oTarget:getowner()==hGlobal.LocalPlayer then
				--显示翰林院技能
				local oUnitH = oWorld:getlordU(hGlobal.LocalPlayer.data.playerId)
				if oUnitH then
					local oHeroL = oUnitH:gethero()
					if oHeroL and oHeroL.data.academySkill[1]~=0 then
						local id = oHeroL.data.academySkill[1][1]
						local lv = 1
						local tabS = hVar.tab_skill[id]
						if tabS and type(tabS.targetEx)=="table" and hApi.CheckUnitTypeEx(oTarget,tabS.targetEx) then
							local sIcon = hVar.tab_skill[id].icon or 0
							_CODE_AppendBuffIconData(1,sIcon,id,lv,0,0)	--翰林院技能
						end
					end
				end
			end
			--显示buff信息
			if oTarget.attr.BuffHint~=0 and #oTarget.attr.BuffHint>0 then
				local tBuff = oTarget.attr.BuffHint
				for i = 1,#tBuff do
					if tBuff[i]~=0 and tBuff[i][1]~=0 then
						local id = tBuff[i][1]
						local lv = tBuff[i][2]
						local dur = tBuff[i][3]
						local param = tBuff[i][4]
						local tabS = hVar.tab_skill[id]
						if tabS then
							local sIcon = hVar.tab_skill[id].icon or 0
							_CODE_AppendBuffIconData(1,sIcon,id,lv,dur,param)	--单位BUFF
						end
					end
				end
			end
			local tabU = hVar.tab_unit[oTarget.data.id]
			if tabU then
				--显示单位被动技能
				if tabU.attr and tabU.attr.skill then
					for i = 1,#tabU.attr.skill do
						local id = tabU.attr.skill[i][1]
						local lv = 1
						local tabS = hVar.tab_skill[id]
						if tabS and tabS.uiHide~=1 and tabS.cast_type~=hVar.CAST_TYPE.SKILL_TO_UNIT and tabS.cast_type~=hVar.CAST_TYPE.SKILL_TO_GRID and tabS.cast_type~=hVar.CAST_TYPE.IMMEDIATE then
							if hVar.tab_stringS[id] and hVar.tab_stringS[id][1] and hVar.tab_stringS[id][2] then
								local sIcon = tabS.icon or 0
								if (tabS.duration or 0)>0 then
									local dur = tabS.duration-oWorld.data.roundcount
									if dur>0 then
										_CODE_AppendBuffIconData(1,sIcon,id,lv,dur,0)	--有持续时间的单位被动技能
									end
								else
									_CODE_AppendBuffIconData(1,sIcon,id,lv,0,0)	--单位被动技能
								end
							end
						end
					end
				end
				--显示英雄被动技能
				local oHero = oTarget:gethero()
				if oHero and tabU.talent then
					for i = 1,#tabU.talent do
						if tabU.talent[i][1] and oHero.attr.level>=(hVar.HERO_SKILL_REQUIRE[i] or 0) then
							local id = tabU.talent[i][1][1]
							local lv = 1
							local tabS = hVar.tab_skill[id]
							if tabS and tabS.uiHide~=1 and tabS.cast_type~=hVar.CAST_TYPE.SKILL_TO_UNIT and tabS.cast_type~=hVar.CAST_TYPE.SKILL_TO_GRID and tabS.cast_type~=hVar.CAST_TYPE.IMMEDIATE then
								if hVar.tab_stringS[id] and hVar.tab_stringS[id][1] and hVar.tab_stringS[id][2] then
									local sIcon = hVar.tab_skill[id].icon or 0
									_CODE_AppendBuffIconData(1,sIcon,id,lv,0,0)	--英雄被动技能
								end
							end
						end
					end
				end
			end
		end
		_CODE_UpdateBuffIcon()
		_FrmT:show(1)
	end)

	--出战场清理面板
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__ReseOprData",function()
		--hApi.BF_ClearTargetInfoFrame
		return _CODE_ClearTargetInfoFrm("clear")
	end)

	--本地玩家可控制单位激活,创建操作技能面板
	local _ArrowMotion = {{0,-5,0.3},{0,0,0.3}}
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__ShowLocalOprUI",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		_BF_LastOprId = 0
		hApi.SetObjectEx(_BF_LastActivedUnit,nil)
		if oUnit:getcontroller()==hGlobal.LocalPlayer then
			hApi.SetObjectEx(_BF_LastActivedUnit,oUnit)
			local _,tMoveDataList = hApi.BF_GetOprSkill()
			if tMoveDataList~=nil then
				local nSkillId
				local nAttackId = hApi.GetDefaultSkill(oUnit)
				if nAttackId>0 then
					nSkillId = nAttackId
				else
					nSkillId = hVar.MOVE_SKILL_ID
				end
				hGlobal.event:event("LocalEvent_ShowBFOperatePreview",oWorld,oUnit,nSkillId,nil)
			end
		end
		if _FrmT.data.show==1 then
			local nSkillId = hApi.BF_GetOprSkill()
			local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget)
			if oTarget and oTarget.data.IsDead~=1 then
				if oUnit:getcontroller()==hGlobal.LocalPlayer then
					local wx,wy = oTarget:getXY()
					hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
				end
				hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","actived",oTarget,nil,0)
			else
				hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","hide",nil,nil,0)
			end
		end
	end)

	--如果转换为移动操作，需要调整BF_OperateBar
	hGlobal.event:listen("LocalEvent_PlayerSwitchOprBF","__BF__SwitchLocalOprUI",function(oWorld,nSkillId)
		_BF_LastOprId = nSkillId
		if _FrmT.data.show==1 then
			local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget)
			local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastActivedUnit)
			if oUnit and oUnit.data.IsDead~=1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
				_CODE_TargetInfoFrmShiftOpr(oUnit,nSkillId,oTarget)
			end
		end
	end)

	--显示操作预览时刷新目标信息条
	hGlobal.event:listen("LocalEvent_ShowBFOperatePreview","__BF__ReseTargetInfo",function(oWorld,oUnit,nSkillId,oTarget)
		_BF_LastOprId = nSkillId
		if _FrmT.data.show==1 then
			local oTarget = hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget)
			local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastActivedUnit)
			if oUnit and oUnit.data.IsDead~=1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
				_CODE_TargetInfoFrmShiftOpr(oUnit,nSkillId,oTarget)
			end
		end
	end)

	--确认施放技能
	hGlobal.event:listen("LocalEvent_PlayerConfirmOperateBF","__BF__ConfirmOperate",function(oWorld,oUnit,nSkillId,oTarget,gridX,gridY)
		--清理技能施放条子
		--确认施放技能
		if nSkillId==hVar.MOVE_SKILL_ID then
			if gridX==oUnit.data.gridX and gridY==oUnit.data.gridY then
				return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
			else
				return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,gridX,gridY)
			end
		else
			local tabS = hVar.tab_skill[nSkillId]
			if tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
				if oTarget~=nil then
					if tabS.template=="RangeAttack" then
						return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,nSkillId,oTarget,gridX,gridY)
					else
						if gridX==oUnit.data.gridX and gridY==oUnit.data.gridY then
							return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,nSkillId,oTarget,gridX,gridY)
						else
							return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT_WITH_MOVE,oUnit,nSkillId,oTarget,gridX,gridY)
						end
					end
				end
			elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
				return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_GRID,oUnit,nSkillId,nil,gridX,gridY)
			elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
				return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,nSkillId,nil,gridX,gridY)
			end
		end
	end)

	--修改目标信息提示面板的锁定单位
	hGlobal.event:listen("LocalEvent_TouchDown_BF","__BF__RefreshTargetInfoFrame",function(oWorld,gridX,gridY,worldX,worldY)
		if _FrmT.data.show==1 then
			local nSkillId,_,LastOprMode = hApi.BF_GetOprSkill()
			if LastOprMode=="MoveAndAttack" then
				local oUnit = hApi.BF_GetOprUnit()
				local oTarget = hApi.BF_GetOprTarget()
				if oTarget and oTarget~=hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget) then
					hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","touch_list",oTarget,oUnit,nSkillId)
				end
			else
				local oTarget = oWorld:hit2unit(worldX,worldY,"battlefield_down")
				if oTarget~=nil and (oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO) then
					local oUnit = hApi.BF_GetOprUnit()
					hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","touch_list",oTarget,oUnit,nSkillId)
				else
					_FrmT:show(0)
				end
			end
		end
	end)

	--点击行动条子上的单位时,锁定单位
	local _ArrowMotion = {{0,-5,0.3},{0,0,0.3}}
	hGlobal.event:listen("LocalEvent_TouchOnActionList","__BF__ShowTargetInfoFrame",function(oTarget,nRoundCount,mode)
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.data.type=="battlefield" then
			if oTarget~=nil then
				if oTarget==hApi.GetObjectEx(hClass.unit,_BF_LastLockTarget) then
					if _FrmT.data.show==1 then
						hApi.BF_ConfirmSkillOpr(oTarget,_BF_LastOprId)
					end
				else
					local wx,wy = oTarget:getXY()
					hApi.BF_CreateHintImage(oWorld,"effect/way_arrow.png","normal",wx,wy,32,32,nil,20,_ArrowMotion)
				end
				local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastActivedUnit)
				if oUnit and oUnit.data.IsDead~=1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
					hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","touch_list",oTarget,oUnit,_BF_LastOprId)
				else
					hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","touch_list",oTarget,nil,0)
				end
			else
				hGlobal.event:event("LocalEvent_BFShowTargetInfoFrm","hide",nil,nil,0)
			end
		end
	end)
end

----------------------------------------------------------
--退出战场操作
hApi.BFSurrender = function(oWorld)
	if type(oWorld.data.codeOnExit)=="function" then
		--有特殊的退出函数
		return oWorld:exit("surrender")
	elseif oWorld.data.IsPaused==1 and oWorld.data.PausedByWhat=="Victory" then
		return hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_LeaveBattlefield"].."?",{
			ok = function()
				hApi.EnterWorld()
			end,
			cancel = 1,
		})
	else
		local tNetData = oWorld.data.netdata
		if type(tNetData)=="table" and tNetData.roomid~=0 then
			--网络战场
			if oWorld.data.roundcount<=1 then
				--2回合内禁止投降
				local oFrm = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVPSurrenderDisable"],{
					textY = -22,
					--font = hVar.FONTC,
					ok = 1,
					icon = {"UI:tip","*","*",64,-1},
				})
				return oFrm
			else
				--投降加提示，duang
				local textY
				local sTipEx = rawget(hVar.tab_string,"__TEXT_PVPSurrenderTip_"..tNetData.roomid)
				if sTipEx~=nil then
					textY = 50
				end
				local oFrm = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SurrenderConfirm"],{
					textY = textY,
					font = hVar.FONTC,
					ok = {hVar.tab_string["__TEXT_Surrender"],function()
						hUI.Disable(500,"SurrenderConfirm")
						hApi.addTimerOnce("__BF__SurrenderConfirm",300,function()
							hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SURRENDER)
						end)
					end},
					cancel = hVar.tab_string["__TEXT_Cancel"],
				})
				if sTipEx~=nil then
					oFrm.childUI["tip"] = hUI.label:new({
						parent = oFrm.handle._n,
						text = hVar.tab_string["__TEXT_PVPSurrenderTip_"..tNetData.roomid],
						size = 22,
						border = 1,
						font = hVar.FONTC,
						width = 376,
						align = "MC",
						x = oFrm.data.w/2,
						y = -140,
					})
				end
				return oFrm
			end
		else
			return hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SurrenderConfirm"],{
				ok = {hVar.tab_string["__TEXT_Surrender"],function()
					hUI.Disable(500,"SurrenderConfirm")
					hApi.addTimerOnce("__BF__SurrenderConfirm",300,function()
						hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SURRENDER)
					end)
				end},
				cancel = 1,
			})
		end
	end
end

-----------------------------------------------------------
--战场操作UI(Pad)
hGlobal.UI.InitBattlefieldOperateUI = function()
	if g_phone_mode==0 then
		--PAD可用
	else
		return
	end
	local _BF_LastOprUnit = {}
	local _BF_LastOprWorld = {}
	local _DisableTick = 0
	local _BF_GetOprParam = function()
		local tick = hApi.gametime()
		if _DisableTick>tick then
			return
		end
		local p = hGlobal.LocalPlayer
		local oWorld = hApi.GetObjectEx(hClass.world,_BF_LastOprWorld)
		local oUnit = hApi.GetObjectEx(hClass.unit,_BF_LastOprUnit)
		if oUnit and oWorld and oWorld.data.type=="battlefield" then
			local oRound = oWorld:getround()
			if oRound and oRound.data.auto==0 and oRound.data.operator==hGlobal.LocalPlayer.data.playerId and oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)==oUnit then
				_DisableTick = tick + 350
				return oWorld,oUnit
			end
		else
			return oWorld
		end
	end
	local _BF_ControlOprCode = function(mode,oBtn)
		local oWorld,oUnit = _BF_GetOprParam()
		if oWorld and oWorld.data.type=="battlefield" then
			if mode=="guard" then
				if oUnit~=nil then
					return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,hVar.GUARD_SKILL_ID,nil,oUnit.data.gridX,oUnit.data.gridY)
				end
			elseif mode=="wait" then
				if oUnit~=nil then
					return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_WAIT,oUnit,hVar.ZERO,nil,oUnit.data.gridX,oUnit.data.gridY)
				end
			elseif mode=="surrender" then
				return hApi.BFSurrender(oWorld)
			end
		end
	end
	local _CODE_ShowGrid = function(oBtn)
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
		return hApi.DrawMoveGrid()
	end
	local _CODE_GridBtnSetColor = function(oBtn)
		if hVar.OPTIONS.IS_DRAW_GRID==1 then
			oBtn.handle.s:setColor(ccc3(100,255,0))
		else
			oBtn.handle.s:setColor(ccc3(255,255,255))
		end
	end
	local tBtnChild = {}
	--IPAD模式
	--zhenkira td不需要
	--local tBtnOption = {{"guard",{-48,48}},{"wait",{-128,48}},{"grid",{-200,34},_CODE_ShowGrid},{"surrender",{-264,34}},}
--	for i = 1,#tBtnOption do
--		local sBtnMode = tBtnOption[i][1]
--		local x,y = tBtnOption[i][2][1],tBtnOption[i][2][2]
--		local fCode = tBtnOption[i][3]
--		if fCode==nil then
--			fCode = function(self)
--				return _BF_ControlOprCode(sBtnMode,self)
--			end
--		end
--		tBtnChild[#tBtnChild+1] = {
--			__UI = "button",
--			__NAME = "btn"..sBtnMode,
--			model = "UI:BTN_ControlButton",
--			animation = sBtnMode,
--			x = x,
--			y = y,
--			scaleT = 0.8,
--			code = fCode,
--		}
--	end
	hGlobal.UI.BF_OperatePanel = hUI.frame:new({
		x = hVar.SCREEN.w,
		y = 0,
		z = -1,
		dragable = 2,
		buttononly = 1,
		closebtn = 0,
		background = -1,
		child = tBtnChild,
		show = 0,
	})
	local _FrmO = hGlobal.UI.BF_OperatePanel
	local tFunc = __CODE__InitSkillOprFunc()
	tFunc.UpdateOprUnitSkill = function(oUnit)
		print("UpdateOprUnitSkill", oUnit.data.name) ---geyachao: add print
		
		local tSkill = {}
		local nAttackId = hApi.GetDefaultSkill(oUnit)
		oUnit:enumskill(function(sData)
			local id,lv,cd,count = unpack(sData)
			local tabS = hVar.tab_skill[id]
			if tabS and id>0 and id~=nAttackId and count>=0 and (tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT) then
				tSkill[#tSkill+1] = id
				
				print("skill_id = " .. id)
			end
		end)
		if nAttackId~=0 and nAttackId then
			tSkill[#tSkill+1] = nAttackId
			
			print("nAttackId = " .. nAttackId)
		end
		if #tSkill==0 then
			tSkill[#tSkill+1] = hVar.MOVE_SKILL_ID
			
			print("MOVE_SKILL_ID = " .. hVar.MOVE_SKILL_ID)
		end
		local nGridW = 86
		local nPanelW = nGridW*#tSkill
		tFunc.UpdateGridUI(oUnit,tSkill,{-1*nPanelW-20,128,64,64,nGridW,nGridW},{nGridW*(#tSkill-1),0,150})
	end
	
	--进入大战场显示操作面板，设置数据 zhenkira
	hGlobal.event:listen("Event_TDBattlefieldStart","__BF__ShowLocalOprUI",function(oWorld)
		if oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		tFunc.UpdateGridUI()
		_FrmO:show(1)
		--_CODE_GridBtnSetColor(_FrmO.childUI["btngrid"])
		--hApi.SetObjectEx(_BF_LastOprWorld,oWorld)
	end)

	--进战场显示操作面板，设置数据
	hGlobal.event:listen("Event_BattlefieldStart","__BF__ShowLocalOprUI",function(oWorld)
		if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end
		--zhenkira td不需要
		tFunc.UpdateGridUI()
		_FrmO:show(1)
		_CODE_GridBtnSetColor(_FrmO.childUI["btngrid"])
		hApi.SetObjectEx(_BF_LastOprWorld,oWorld)
	end)

	--出战场隐藏操作面板，清理数据
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__BF__HideLocalOprUI",function(oPlayer)
		_FrmO:show(0)
		tFunc.UpdateGridUI()
		hApi.SetObjectEx(_BF_LastOprUnit,nil)
		hApi.SetObjectEx(_BF_LastOprWorld,nil)
	end)

	--激活单位时设置数据
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__SetLocalOprTarget",function(oWorld,oRound,oUnit)
		--print("Event_BattlefieldUnitActived", oUnit.data.name)
		
		if oWorld~=hGlobal.LocalPlayer:getfocusworld() then
			return
		end

		--if oUnit:getcontroller()==hGlobal.LocalPlayer then
			hApi.SetObjectEx(_BF_LastOprUnit,oUnit)
			tFunc.UpdateOprUnitSkill(oUnit)
		--else
		--	hApi.SetObjectEx(_BF_LastOprUnit,nil)
		--	tFunc.UpdateGridUI()
		--end
	end)

--	--激活单位时设置数据
--	hGlobal.event:listen("Event_TDUnitActived","__BF__SetLocalOprTarget",function(oWorld,oRound,oUnit)
--		--print("Event_BattlefieldUnitActived", oUnit.data.name)
--		
--		if oWorld~=hGlobal.LocalPlayer:getfocusworld() then
--			return
--		end
--		--if oUnit:getcontroller()==hGlobal.LocalPlayer then
--			hApi.SetObjectEx(_BF_LastOprUnit,oUnit)
--			tFunc.UpdateOprUnitSkill(oUnit)
--		--else
--		--	hApi.SetObjectEx(_BF_LastOprUnit,nil)
--		--	tFunc.UpdateGridUI()
--		--end
--	end)	--操作后隐藏技能条子
	hGlobal.event:listen("LocalEvent_PlayerConfirmOperateBF","__BF__HideSkillBar",function(oWorld,oUnit,nSkillId,oTarget,gridX,gridY)
		--清理技能施放条子
		tFunc.DisableOprBtn()
	end)
end

hVar.SKILL_INFO_PARAM = {
	[1] = {{28,24,24},0},	--默认
	[41] = {0,{255,0,0}},	--城墙减伤
	[624] = {{24,22},0},	--无双妖姬
	[441] = {{24,22},0},	--霸王之躯
	[442] = {{24,22},0},	--烈风斩
	[443] = {{20,22},0},	--霸王号令
}
-----------------------------------------------------------
--战场辅助UI(FJC写的)
hGlobal.UI.InitBattlefieldBuffTipFrm = function()
	hGlobal.UI.BF_BuffTipFrm = hUI.frame:new({
		x = 230,
		y = 460,
		dragable = 3,
		show = 0,
		h = 300,
		w = 420,
	})
	local _BBT_InfoXYWH = {100,-65,300,0}
	local _BBT_InfoSize = {
		["skillInfo"] = 28,
		["skillInfoEx"] = 24,
		["skillInfoDur"] = 24,
	}
	local _Frm = hGlobal.UI.BF_BuffTipFrm
	local _childUI = _Frm.childUI
	_childUI["skillName"] = hUI.label:new({
		parent = _Frm.handle._n,
		x = 210,
		y = -30,
		text = "",
		size = 32,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
		RGB = {255,205,55},
	})
	_childUI["closeBtn"] = hUI.button:new({
		parent = _Frm.handle._n,
		dragbox = _childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = 400,
		y = -15,
		scaleT = 0.9,
		z = 2,
		code = function()
			_Frm:show(0)
		end,
	})
	for k,nSize in pairs(_BBT_InfoSize)do
		_childUI[k] = hUI.label:new({
			parent = _Frm.handle._n,
			x = _BBT_InfoXYWH[1],
			y = _BBT_InfoXYWH[2],
			width = _BBT_InfoXYWH[3],
			text = "",
			size = nSize,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
		})
	end

	local _CODE_SetFrmLabel = function(k,v,nSize,nPosY)
		local oUI = _childUI[k]
		nPosY = nPosY or oUI.data.y
		if (nSize or 0)==0 then
			nSize = _BBT_InfoSize[k]
		end
		if v then
			if nSize~=oUI.data.size then
				oUI:del()
				_childUI[k] = hUI.label:new({
					parent = _Frm.handle._n,
					x = _BBT_InfoXYWH[1],
					y = _BBT_InfoXYWH[2],
					width = _BBT_InfoXYWH[3],
					text = "",
					size = nSize,
					font = hVar.FONTC,
					align = "LT",
					border = 1,
				})
				oUI = _childUI[k]
			end
			oUI.handle._n:setVisible(true)
			oUI:setText(v)
			if oUI.data.y~=nPosY then
				oUI:setXY(oUI.data.x,nPosY)
			end
			local _,h = oUI:getWH()
			return nPosY - h - 16
		else
			oUI.handle._n:setVisible(false)
			return nPosY
		end
	end

	hGlobal.event:listen("LocalEvent_BFShowBuffInfoFrm","__showFrm",function(tBuffData)
		local sIcon = tBuffData[1]
		local nType = tBuffData[3]
		local id = tBuffData[4]
		local lv = tBuffData[5]
		local dur = tBuffData[6]
		local param = tBuffData[7]
		if id>0 and lv>0 then
			if nType==1 then
				hApi.safeRemoveT(_childUI,"SkillIcon")
				_childUI["SkillIcon"]= hUI.image:new({
					parent = _Frm.handle._n,
					model = sIcon,
					x = 50,
					y = -90,
				})
				--技能
				local tabS = hVar.tab_skill[id]
				local tabStr = hVar.tab_stringS[id]
				if tabS and tabStr then
					local sSkillName = tabStr[1] or "skill_"..id
					local sSkillInfo = tabStr[2] or ""
					local sSkillInfoEx = tabStr[3]
					local sSkillDur
					if dur>0 then
						sSkillDur = hVar.tab_string["__TEXT_Duration"]..": "..dur.." "..hVar.tab_string["__TEXT_Round"]
					end
					if string.sub(sSkillInfo,1,5)=="@size" then
						local l = string.len(sSkillInfo)
						local e = string.find(sSkillInfo,"@",6)
						if e and e>6 then
							--nSize = tonumber(string.sub(sSkillInfo,6,e-1))
							sSkillInfo = string.sub(sSkillInfo,e+1,l)
						end
					end
					if type(param)=="table" and #param>0 then
						for i = 1,#param do
							if string.find(sSkillInfo,"%[p"..i.."%]") then
								sSkillInfo = string.gsub(sSkillInfo,"%[p"..i.."%]",tostring(param[i]))
							elseif string.find(sSkillInfo,"%[s"..i.."%]") then
								if hVar.tab_stringS[param[i]] then
									sSkillInfo = string.gsub(sSkillInfo,"%[s"..i.."%]",tostring(hVar.tab_stringS[param[i]][1]))
								end
							end
						end
					end
					_childUI["skillName"]:setText(sSkillName)
					local tSize
					if hVar.SKILL_INFO_PARAM[id] and hVar.SKILL_INFO_PARAM[id][1]~=0 then
						tSize = hVar.SKILL_INFO_PARAM[id][1]
					else
						tSize = {}
					end
					local nPosY = _CODE_SetFrmLabel("skillInfo",sSkillInfo,tSize[1],nil)
					nPosY = _CODE_SetFrmLabel("skillInfoEx",sSkillInfoEx,tSize[2],nPosY)
					nPosY = _CODE_SetFrmLabel("skillInfoDur",sSkillDur,tSize[3],nPosY)
					--如果要改说明的颜色
					if hVar.SKILL_INFO_PARAM[id] and hVar.SKILL_INFO_PARAM[id][2]~=0 then
						_childUI["skillInfo"].handle.s:setColor(ccc3(unpack(hVar.SKILL_INFO_PARAM[id][2])))
					else
						_childUI["skillInfo"].handle.s:setColor(ccc3(255,255,255))
					end
				else
					_childUI["skillName"]:setText("skill_"..id)
					_CODE_SetFrmLabel("skillInfo")
					_CODE_SetFrmLabel("skillInfoEx")
					_CODE_SetFrmLabel("skillInfoDur")
				end
				_Frm:show(1)
			elseif nType==2 then
				--战术技能
				local lv = tBuffData[5]
				hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",id,lv,230,460)
			end
		end
	end)
end

--安卓测试代码
--if g_phone_mode==3 then
	--hGlobal.UI.InitLogUI = function()
		--hGlobal.UI.BFLogUI = hUI.frame:new({
			--dragable = 0,
			--show = 0,
			--x = 10,
			--y = hVar.SCREEN.h,
			--background = -1,
			--border = 0,
		--})
		--local _FrmBG = hGlobal.UI.BFLogUI
		--local _childUI = hGlobal.UI.BFLogUI.childUI
		--hGlobal.event:listen("Event_BattlefieldStart","__BF__ShowLogUI",function(oWorld)
			--if oWorld.data.IsQuickBattlefield==1 or oWorld~=hGlobal.LocalPlayer:getfocusworld() then
				--return
			--end
			--_FrmBG:show(1)
		--end)
		--local nCount = 0
		--local _CODE_Log = function(sCmd)
			--nCount = nCount + 1
			--_childUI["text"..nCount] = hUI.label:new({
				--parent = _FrmBG.handle._n,
				--x = 30,
				--y = -20-32*nCount,
				--size = 24,
				--text = sCmd,
				--RGB = {255,180,0},
			--})
		--end
		--hGlobal.event:listen("LocalEvent_Hit2Unit","__ooo",function(oWorld,worldX,worldY,tUnitList)
			--if oWorld.data.type~="battlefield" then
				--return
			--end
			--_CODE_Log(string.format("touch=(%d,%d),unit=%d",worldX,worldY,#tUnitList))
		--end)
		--hGlobal.event:listen("LocalEvent_BFTouchLog","_oooooooooooooo",function(sCmd)
			--_CODE_Log(sCmd)
		--end)
		--hGlobal.event:listen("LocalEvent_ShowBFOperatePreview","__oooooooooooooooooo",function()
			--for i = 1,nCount,1 do
				--hApi.safeRemoveT(_childUI,"text"..i)
			--end
			--nCount = 0
		--end)
	--end
--end