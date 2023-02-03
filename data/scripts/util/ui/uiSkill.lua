--local __DrawMoveGrid = function(oWorld,oUnit,oTarget,gridX,gridY)
	--local vBlock = hVar.UNIT_BLOCK[oUnit.attr.block]
	--local tMove = {}
	--if vBlock==nil or vBlock==0 then
		--vBlock = 1
	--end
	--hApi.enumNearGrid(gridX,gridY,vBlock,function(gx,gy)
		--tMove[#tMove+1] = {x=gx,y=gy}
	--end)
	--oWorld:drawgrid("MoveGridHint","blue",tMove,"unrecord")
	--if oUnit~=nil and oTarget~=nil then
		--local ox,oy = oWorld:grid2xy(gridX,gridY)
		--ox = ox + oUnit.data.standX
		--oy = oy + oUnit.data.standY
		--local x,y,w,h = oUnit:getbox()
		--ox = ox + x + w/2
		--oy = oy + y + h/2
		--local tx,ty = oTarget:getXY()
		--local x,y,w,h = oUnit:getbox()
		--tx = tx + x + w/2
		--ty = ty + y + h/2
		--local ex,ey = hApi.getint((tx+ox)/2),hApi.getint((ty+oy)/2)
		--local n = hApi.calAngleD("DIRECTIONx8",hApi.angleBetweenPoints(tx,ty,ex,ey))
		--local e = hGlobal.O:replace("BF_MoveAttackHintArrow",oWorld:addeffect(3,0,"stand_"..n,tx,ty,0,75))
		----hApi.SpriteRollAsMissile(e.handle,tx,ty,ox,oy,tx,ty)
	--end
--end

local __CalculateSkillDamage
__CalculateSkillDamage = function(oUnit,nSkillId,nDepth)
	nDepth = nDepth or 0
	--第4层以后就不参与计算了
	if nDepth>3 then
		return 0,0
	end
	local dMin,dMax = 0,0
	local aMin,aMax = 0,0
	local hMin,hMax = 0,0
	local vTemp = {}
	local tabS = hVar.tab_skill[nSkillId]
	if tabS then
		if tabS.uiAttackPec then
			if type(tabS.uiAttackPec)=="number" then
				--如果给定了伤害比例
				local pec = tabS.uiAttackPec
				aMin = aMin + hApi.getint(oUnit.attr.attack[4]*pec/100)
				aMax = aMax + hApi.getint(oUnit.attr.attack[5]*pec/100)
			elseif type(tabS.uiAttackPec)=="table" then
				local oHero = oUnit:gethero()
				local tAP = tabS.uiAttackPec
				for i = 1,#tAP do
					if type(tAP[i])=="number" then
						local pec = tAP[i]
						aMin = aMin + hApi.getint(oUnit.attr.attack[4]*pec/100)
						aMax = aMax + hApi.getint(oUnit.attr.attack[5]*pec/100)
					elseif type(tAP[i])=="table" then
						local pec = tAP[i][2]
						if oHero and type(oHero.attr[tAP[i][1]])=="number" then
							local v = hApi.getint(oHero.attr[tAP[i][1]]*pec/100)
							aMin = aMin + v
							aMax = aMax + v
						end
					end
				end
			end
			dMin,dMax = aMin,aMax
		elseif tabS.action then
			local attackID
			local actions = tabS.action
			for i = 1,#actions do
				local a = actions[i]
				local k = a[1]
				if k=="AutoOrder" then
					if a[5]=="attack" then
						--攻击命令
						if attackID==nil then
							attackID = hApi.GetDefaultSkill(oUnit) or 0
						end
						if attackID~=0 and hVar.tab_skill[attackID] then
							local dMn,dMx,hMn,hMx = __CalculateSkillDamage(oUnit,attackID,nDepth)
							dMin = dMin + (dMn or 0)
							dMax = dMax + (dMx or 0)
							hMin = hMin + (hMn or 0)
							hMax = hMax + (hMx or 0)
						end
					end
				elseif k=="LoadAttack" then
					local pec = hApi.AnalyzeValueExpr("number",nil,vTemp,a[2],nSkillId)
					aMin = aMin + hApi.getint(oUnit.attr.attack[4]*pec/100)
					aMax = aMax + hApi.getint(oUnit.attr.attack[5]*pec/100)
				elseif k=="LoadHeroAttr" then
					local attrName = a[2]
					local pec = hApi.AnalyzeValueExpr("number",nil,vTemp,a[3] or 100,nSkillId)
					local oHero = oUnit:gethero()
					if oHero and type(oHero.attr[attrName])=="number" then
						aMin = aMin + hApi.getint(oHero.attr[attrName]*pec/100)
						aMax = aMax + hApi.getint(oHero.attr[attrName]*pec/100)
					end
				elseif k=="Damage" or k=="CombatDamage" or k=="MeleeDamage" or k=="ShootDamage" or k=="DamageArea" then
					dMin = dMin + aMin + (a[3] or 0)
					dMax = dMax + aMax + (a[4] or 0)
				elseif k=="Heal" or k=="HealArea" then
					hMin = hMin + aMin + (a[3] or 0)
					hMax = hMax + aMax + (a[4] or 0)
				elseif k=="ClearDamage" then
					aMin = 0
					aMax = 0
				elseif k=="ReadValue" then
					local toParamVar,valueType,valueParam = a[2],a[3],a[4]
					hApi.ReadUnitValue(vTemp,toParamVar,oUnit,valueType,valueParam)
				elseif k=="CastSkill" then
					if nDepth<2 then
						local m,n = __CalculateSkillDamage(oUnit,a[2],nDepth+1)
						dMin = dMin + m
						dMax = dMax + n
					end
				elseif k=="Loop" then
					--请不要把立刻伤害写在Loop后面
					break
				end
			end
		end
	end
	return dMin,dMax,hMin,hMax
end

--计算技能伤害
hApi.CalculateSkillDamage = function(oUnit,nSkillId)
	return __CalculateSkillDamage(oUnit,nSkillId)
end
-----------------------------------
local __Last_S_tGrid
local __Last_S_uBlock
local __Last_T_Temp
local __ClearTemp = function()
	__Last_S_tGrid = nil
	__Last_S_uBlock = nil
	__Last_T_Temp = nil
end
-----------------------------------
local __nX,__nY,__sus
local __TempCode = function(gx,gy,r,i)
	if __sus==0 and gx==__nX and gy==__nY then
		__sus = 1
		r[i] = 1
	end
end
local __CalculateAvailableGrid = function(tGrid,uBlock,nX,nY,rTab)
	for i = 1,#tGrid do
		__sus,__nX,__nY = 0,tGrid[i].x,tGrid[i].y
		rTab[i] = 0
		hApi.enumNearGrid(__nX,__nY,uBlock,__TempCode,rTab,i)
	end
end
-----------------------------------
local __TempXY = {sus=0,x=0,y=0}
local __TempCode = function(gx,gy)
	if __TempXY.x==gx and __TempXY.y==gy then
		__TempXY.sus = 1
	end
end
local __CheckTempGrid = function(uBlock,cx,cy,nX,nY)
	local sus = 0
	__TempXY.sus = 0
	__TempXY.x = nX
	__TempXY.y = nY
	hApi.enumNearGrid(cx,cy,uBlock,__TempCode)
	if __TempXY.sus==1 then
		return nX,nY
	end
end
-------------------------------------
--hApi.AnalyzeHitOnTarget = function(oUnit,oTarget,MoveData,codeWhenHitBtn)
	--local oWorld = oUnit:getworld()
	--local tGrid,id
	--local gridI
	--local nSkillId
	--local ConfirmFunc
	--local MoveTemp = {id=hVar.MOVE_SKILL_ID,x=0,y=0,reloadXY = hApi.DoNothing}
	--oWorld:drawgrid("default","show")
	--if oTarget==nil then
		--if type(MoveData)=="table" and MoveData.x and MoveData.y then
			--local lX,lY = MoveData.lastX,MoveData.lastY
			--local tX,tY = MoveData.x,MoveData.y
			--MoveTemp.id = hVar.MOVE_SKILL_ID
			--__DrawMoveGrid(oWorld,oUnit,nil,tX,tY)
			--MoveTemp.x,MoveTemp.y = tX,tY
			--id = hVar.MOVE_SKILL_ID
			--nSkillId = id
			--ConfirmFunc = function(gridX,gridY)
				--if gridX~=nil and gridY~=nil then
				--else
					--gridX = MoveTemp.x
					--gridY = MoveTemp.y
				--end
				--oWorld:drawgrid("MoveGridHint","clear")
				--return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,MoveTemp.x,MoveTemp.y)
			--end
		--end
	--else
		--if type(MoveData)=="table" and MoveData.Target[oTarget.ID] then
			--tGrid = MoveData.Target[oTarget.ID]
			--id = MoveData.nSkillId
			--MoveTemp.id = id
			--gridI = MoveData._MoveGrid.gridI
		--end
	--end
	--if tGrid~=nil then
		--if tGrid.type=="Attack" then
			--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
			--MoveTemp.x,MoveTemp.y = MoveData.x,MoveData.y
			--nSkillId = id
			--ConfirmFunc = function(gridX,gridY)
				--if gridX~=nil and gridY~=nil then
				--else
					--gridX = oTarget.data.gridX
					--gridY = oTarget.data.gridY
				--end
				--oWorld:drawgrid("MoveGridHint","clear")
				--return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,nSkillId,oTarget,gridX,gridY)
			--end
		--elseif tGrid.type=="MoveAndAttack" then
			--local moveV,moveI
			--for i = 1,#tGrid do
				--if moveV==nil or tGrid[i].move<moveV then
					--moveV = tGrid[i].move
					--moveI = i
				--end
			--end
			--if moveI then
				--local tX,tY = tGrid[moveI].x,tGrid[moveI].y
				--__DrawMoveGrid(oWorld,oUnit,oTarget,tX,tY)
				--__ClearTemp()
				--MoveTemp.x,MoveTemp.y = tX,tY
				--local standX,standY = oUnit.data.standX,oUnit.data.standY
				--local uBlock = hVar.UNIT_BLOCK[oUnit.attr.block]
				--if uBlock==0 or uBlock==nil then
					--uBlock = 1
				--end
				--local _nX,_nY
				--local _aGrid = {}
				--MoveTemp.reloadXY = function(oUnit,oTarget,worldX,worldY)
					----此函数慎用，可能导致严重的内存峰值上涨
					--local nX,nY = oWorld:xy2grid(worldX,worldY)
					--local temp = tGrid
					--if nX==_nX and nY==_nY then
						----无需重新计算可用方格
					--else
						----重新计算可用方格
						--_nX,_nY = nX,nY
						--__CalculateAvailableGrid(tGrid,uBlock,nX,nY,_aGrid)
					--end
					--local dis,cx,cy
					--for i = 1,#temp do
						--if _aGrid[i]==1 then
							--local x,y = oWorld:grid2xy(temp[i].x,temp[i].y)
							--local v = (x+standX-worldX)^2+(y+standY-worldY)^2
							--if dis==nil or dis>v then
								--dis = v
								--cx,cy = temp[i].x,temp[i].y
							--end
						--end
					--end
					--local rX,rY
					--if cx and cy then
						--if cx~=MoveTemp.x or cy~=MoveTemp.y then
							--__DrawMoveGrid(oWorld,oUnit,oTarget,cx,cy)
							--MoveTemp.x,MoveTemp.y = cx,cy
						--end
						--rX,rY = __CheckTempGrid(uBlock,cx,cy,nX,nY)
					--end
					--return true,rX,rY
				--end
				--nSkillId = id
				--ConfirmFunc = function(gridX,gridY)
					--if gridX~=nil and gridY~=nil then
					--else
						--gridX = MoveTemp.x
						--gridY = MoveTemp.y
					--end
					--oWorld:drawgrid("MoveGridHint","clear")
					--return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.SKILL_TO_UNIT_WITH_MOVE,oUnit,nSkillId,oTarget,gridX,gridY)
				--end
			--end
		--elseif tGrid.type=="Move" then
			--local moveX,moveY
			--if #tGrid<=0 or oUnit.attr.IsFlyer>0 then
				----寻找一个距离目标最近的落脚点
				--local moveV
				--local mGrid = MoveData.MoveGrid
				--for i = 1,#mGrid do
					--local move = oWorld:distanceG(mGrid[i].x,mGrid[i].y,oTarget.data.gridX,oTarget.data.gridY,1) or 0
					--if moveV==nil or moveV>move then
						--moveV = move
						--moveX,moveY = mGrid[i].x,mGrid[i].y
					--end
				--end
			--else
				--local moveV
				--for i = 1,#tGrid do
					--if moveV==nil or moveV>(tGrid[i].move or 0) then
						--moveV = tGrid[i].move or 0
						--moveX,moveY = tGrid[i].x,tGrid[i].y
					--end
				--end
			--end
			--if moveX and moveY then
				--local wp = {}
				--if oWorld:findunitwayto(wp,oUnit,moveX,moveY)>0 then
					--local tX,tY
					--for i = 1,#wp do
						--local x,y = oWorld:n2grid(wp[i])
						--local v = gridI[x.."|"..y]
						--if v==nil or v<0 then
							--break
						--else
							--tX,tY = x,y
						--end
					--end
					--if tX and tY then
						--__DrawMoveGrid(oWorld,oUnit,nil,tX,tY)
						--MoveTemp.x,MoveTemp.y = tX,tY
						--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
						--nSkillId = hVar.MOVE_SKILL_ID
						--ConfirmFunc = function(gridX,gridY)
							--if gridX~=nil and gridY~=nil then
							--else
								--gridX = MoveTemp.x
								--gridY = MoveTemp.y
							--end
							--oWorld:drawgrid("MoveGridHint","clear")
							--return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,gridX,gridY)
						--end
					--end
				--end
			--end
		--end
	--end
	--if type(ConfirmFunc)=="function" then
		--local tOperateConfirm = {MoveTemp = MoveTemp,codeOnConfirm = hApi.DoNothing}
		--if type(codeWhenHitBtn)=="function" then
			--tOperateConfirm.codeOnConfirm = function(gridX,gridY)
				--codeWhenHitBtn()
				--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
				--return ConfirmFunc(gridX,gridY)
			--end
			--tOperateConfirm.codeOnCancel = function()
				--codeWhenHitBtn()
				--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
				--return oWorld:drawgrid("MoveGridHint","clear")
			--end
		--else
			--tOperateConfirm.codeOnConfirm = function(gridX,gridY)
				--codeWhenHitBtn()
				--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
				--return ConfirmFunc(gridX,gridY)
			--end
			--tOperateConfirm.codeOnCancel = function()
				--codeWhenHitBtn()
				--hGlobal.O:replace("BF_MoveAttackHintArrow",nil)
				--return oWorld:drawgrid("MoveGridHint","clear")
			--end
		--end
		--return tOperateConfirm
	--end
--end

local __MoveT = {x=0,y=0}
hApi.FindUnitMoveGrid = function(oUnit,moveX,moveY)
	local oWorld = oUnit:getworld()
	local v = oUnit.attr.move
	if v>0 then
		if oUnit.attr.IsFlyer>0 then
			--飞行单位寻路
			if oUnit.attr.move>0 then
				local wp = {}
				oWorld:gridinunitreach(wp,oUnit,oUnit.attr.move,1)
				local disI
				local selectI = 0
				local wx,wy = oWorld:grid2xy(moveX,moveY)
				__MoveT.x = moveX
				__MoveT.y = moveY
				for i = 1,#wp do
					local v = wp[i]
					local dis = oWorld:distanceU(oUnit,__MoveT,1,v.x,v.y)
					if disI==nil or disI>dis then
						disI = dis
						selectI = i
					end
				end
				if wp[selectI] then
					return wp[selectI].x,wp[selectI].y
				end
			end
		else
			local wp = {}
			--地面单位寻路
			if oWorld:findunitwayto(wp,oUnit,moveX,moveY)>0 then
				local tX,tY
				for i = 1,#wp do
					if i>v or (tX==nil and tY==nil and i==#wp) then
						tX,tY = oWorld:n2grid(wp[i])
						break
					end
				end
				return tX,tY
			end
		end
	end
end

--hApi.ReloadHitOnTarget = function(oUnit,oTarget,MoveData,oPanel)
	--if oPanel==nil then
		--return
	--end
	--local oWorld = oUnit:getworld()
	--local tGrid,id
	--local gridI
	--local nSkillId
	--local ConfirmFunc
	--oWorld:drawgrid("default","show")
	--if oTarget==nil then
		--if type(MoveData)=="table" and MoveData.x and MoveData.y then
			--local tX,tY = MoveData.x,MoveData.y
			--__DrawMoveGrid(oWorld,oUnit,nil,tX,tY)
			--nSkillId = hVar.MOVE_SKILL_ID
			--ConfirmFunc = function()
				--return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_MOVE,oUnit,hVar.ZERO,nil,tX,tY)
			--end
		--end
	--else
		--if type(MoveData)=="table" and MoveData.Target[oTarget.ID] then
			--tGrid = MoveData.Target[oTarget.ID]
			--id = MoveData.nSkillId
			--gridI = MoveData._MoveGrid.gridI
		--end
	--end
--end

hApi.ShowDamageOnLabel = function(oUnit,nSkillId,oTarget,frm,uiName,x,y,align,size)
	if oUnit==nil or oTarget==nil then
		return
	end
	local dMin,dMax,hMin,hMax = 0,0,0,0
	local a = oUnit.attr
	local IsAttack = 0
	local nDmgMode = 0
	local AttackId = hApi.GetDefaultSkill(oUnit)
	if nSkillId==1 or nSkillId==hVar.MOVE_SKILL_ID then
		nSkillId = AttackId
	end
	if nSkillId>0 and hApi.IsSafeTarget(oUnit,nSkillId,oTarget) then
		dMin,dMax,hMin,hMax = hApi.CalculateSkillDamage(oUnit,nSkillId)
		if AttackId==nSkillId then
			IsAttack = 1
		end
		local vMin,vMax = 0,0
		local vFont = "numRed"
		if hMin~=0 or hMax~=0 then
			vFont = "numGreen"
			local a,b = oUnit:calculate("HealDamage",oTarget,hMin,hMax,100,nSkillId,nDmgMode)
			local att = oTarget.attr
			local mxHeal = att.mxhp*att.__stack - att.hp - att.mxhp*(att.stack-1)
			if mxHeal<a then
				b = b
			elseif mxHeal<b then
				b = mxHeal
			end
			vMin = a
			vMax = b
		else
			vFont = "numRed"
			local a,b = oUnit:calculate("CombatDamage",oTarget,dMin,dMax,100,nSkillId,nDmgMode,IsAttack)
			vMin = a
			vMax = b
		end
		--奇怪的"-0"bug
		if vMin==0 then
			vMin = "0"
		end
		if vMax==0 then
			vMax = "0"
		end
		if frm.childUI[uiName] and frm.childUI[uiName].data.font==vFont then
			frm.childUI[uiName]:setText(vMin.." - "..vMax)
		else
			if frm.childUI[uiName] then
				frm.childUI[uiName]:del()
				frm.childUI[uiName] = nil
			end
			frm.childUI[uiName] = hUI.label:new({
				parent = frm.handle._n,
				x = x,
				y = y,
				size = size,
				align = align,
				font = vFont,
				text = vMin.." - "..vMax,
			})
		end
	else
		if frm.childUI[uiName] then
			frm.childUI[uiName]:del()
			frm.childUI[uiName] = nil
		end
	end
end