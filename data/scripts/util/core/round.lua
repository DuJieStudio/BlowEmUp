-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的游戏局类
--@玩家需要在游戏局中参与游戏
hClass.round = eClass:new("static")
local _hrd = hClass.round

local __DefaultParam = {
	cardUI = 0,		--如果指定了cardUI,那么对此列表的改变将操作此UI
	--world = nil,		--锁定的世界，必须有
	--worldID = 0,
	--world__ID = 0,
	roundCur = 0,				--当前回合
	roundMax = 0,				--最多排序到几回合
	length = 1,				--最少需要有几个单位
	auto = 0,
	cur = 0,
	operator = 0,
	operatecount = 0,			--每当一个单位开始行动，此值都会+1
	uniqueCount = 0,
	assistLog = 0,				--在一个auto轮次中，如果此表中记录有某些特殊id那么会跳过assist检测
	LockFrameCount = 0,			--因为某些原因，会将回合锁住，自动跳过必须此数值==0时才会被跳过
	NeedSort = 0,				--如果队列中的任何单位出手速度发生了改变，此值会被设置为1
	IsEnd = 0,				--是否结束了(任何一方取得胜利)
	AssistUnit = 0,				--协同攻击的单位
	codeOnRoundEnd = 0,			--每一轮结束之前执行的代码，如果有设置就会被执行一次
	codeActionLoop = 0,			--如果此值不为0，则会被在每一帧循环执行(顺序1)
	codeRoundLoop = 0,			--如果此值不为0，则会被在每一帧循环执行(顺序2)
	autoActionList = 0,			--用于处理自动激活技能的临时保存池
	--PlayerSort = {LastMovePlayerId,playerId,...},	--回合中的单位会根据此表格内指定的拥有者进行排序,0:默认排序,1:交替排序
	--ActivedUnit = {0,0,0},
	--wAction = {				--等待条件执行的技能/buff
		--这里存放的都是object
		--对应action中的激活条件
						--{
						--	"RoundStart",
						--	"UnitActive",
						--}
		--RoundStart = {},		--等待在回合开始时继续的action
		--UnitActive = {},		--等待在附着单位开始行动时继续的action
	--},
}

_hrd.init = function(self,p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.list = {}
	self.order = {i=0}
	local d = self.data
	if p==nil or p.world==nil then
		_DEBUG_MSG("[LUA WARNING] round must bind a world")
		return
	end
	local w = p.world
	d.worldID = w.ID
	d.world__ID = w.__ID
	w.data.roundID = self.ID
	d.wAction = {
		RoundEnd = {},			--等待在回合结束时继续的action
		RoundStart = {},		--等待在回合开始时继续的action
		UnitActive = {},		--等待在附着单位开始行动时继续的action
		UnitArrive = {},		--等待在单位发起移动后继续执行的action
		UnitDead = {},			--等待在单位死后继续执行的action
		UnitHpLower = {count={}},	--等待在单位hp降低到一定程度后执行的action
	}
	d.AssistUnit = {key={},flag={},index={}}	--协同攻击单位
	d.ActivedUnit = {0,0,0}
	d.PlayerSort = {0}			--加入单位时会根据此表排序
	if type(p.PlayerSort)=="table" and #p.PlayerSort>0 then
		for i = 1,#p.PlayerSort do
			d.PlayerSort[#d.PlayerSort+1] = p.PlayerSort[i]
		end
	else
		d.PlayerSort[#d.PlayerSort+1] = w.data.attackPlayerId
	end
	self:__loadbylength()
end

_hrd.destroy = function(self)
	local d = self.data
	local w = hClass.world.find(d.worldID)
	if w and w.data.roundID==self.ID then
		w.data.roundID = 0
	end
	--内存清理:移除不需要的表格
	d.AssistUnit = 0
	--内存清理:移除不需要的函数
	d.codeOnRoundEnd = 0
end
------------------------------------------------------------
-- 数据定义
------------------------------------------------------------
local __ROUND_ACTIVE_MODE = {
	NONE = 0,
	NORMAL = 1,
	ALL = 2,
}
local __ROUND_SORT_MODE = {
	NONE = 0,
	NORMAL = 1,
	INSERT = 2,
	APPEND = 3,
	WAIT = 4,
}
local __ROUND_DATA_INDEX = {
	oUnit = 1,
	nRound = 2,
	nActivity = 3,
	nActivityEx = 4,
	nActiveMode = 5,
	nSortMode = 6,
	nUnique = 7,
}
hVar.ROUND_DEFINE = {
	ACTIVE_MODE = __ROUND_ACTIVE_MODE,
	SORT_MODE = __ROUND_SORT_MODE,
	DATA_INDEX = __ROUND_DATA_INDEX,
}
local __oRoundTokenUnit = {ID=0,data={id="round",owner=0},attr={activity=99999}}
local __RD__AddRoundData = function(oRound,oUnit,nRound,nActivityEx,nActiveMode,nSortMode)
	oRound.data.uniqueCount = oRound.data.uniqueCount + 1
	local nUnique = oRound.data.uniqueCount
	nActivityEx = nActivityEx or 0
	nActiveMode = nActiveMode or __ROUND_ACTIVE_MODE.NONE
	nSortMode = nSortMode or __ROUND_SORT_MODE.NONE
	if oUnit=="round" then
		oUnit = __oRoundTokenUnit
		return {oUnit,nRound,oUnit.attr.activity,nActivityEx,nActiveMode,nSortMode,nUnique}
	else
		return {oUnit,nRound,oUnit.attr.activity,nActivityEx,nActiveMode,nSortMode,nUnique}
	end
end
-------------------------------------------------------------------

_hrd.setassist = function(self,oUnit,idx,key,allienceU,allienceT,id,delay,rMin,rMax)
	--{key={},index={},{unit = u,{2001,"CombatDamage","ALLY",28,1,1,200},...},...}
	local AssistTab = self.data.AssistUnit
	local i = AssistTab.index[oUnit.ID]
	local o
	if i~=nil then
		o = AssistTab[i]
	else
		i = #AssistTab+1
		o = {unit=oUnit}
		AssistTab[i] = o
		AssistTab.index[oUnit.ID] = i
	end
	if type(rMin)=="number" and type(rMax)=="number" then
		rMax = math.max(rMin,rMax)
	else
		rMax = -1
		rMin = -1
	end
	delay = delay or 200
	o[#o+1] = {idx,key,allienceU,allienceT,id,delay,rMin,rMax}
	AssistTab.key[key] = (AssistTab.key[key] or 0)+1
	AssistTab.flag[key] = AssistTab.flag[key] or 0
end

_hrd.removeassist = function(self,oUnit,idx,key,id)
	--{key={},index={},{unit = u,{2001,"CombatDamage","ALLY",28,1,1,200},...},...}
	local AssistTab = self.data.AssistUnit
	local i = AssistTab.index[oUnit.ID]
	local o
	if i~=nil then
		o = AssistTab[i]
	end
	if o~=nil then
		local rCount = 0
		for i = 1,#o do
			if o[i]~=0 and o[i][1]==idx and o[i][2]==key and o[i][5]==id then
				o[i] = 0
				rCount = rCount + 1
				AssistTab.key[key] = (AssistTab.key[key] or 0)-1
			end
		end
		if rCount==#o then
			AssistTab.index[oUnit.ID] = nil
			AssistTab[i] = nil
			--if AssistTab.key[key]==0 then
				--AssistTab.flag[key] = nil
				--AssistTab.key[key] = nil
			--end
		elseif rCount>0 then
			hApi.SortTableI(o,1)
			--if AssistTab.key[key]==0 then
				--AssistTab.flag[key] = nil
				--AssistTab.key[key] = nil
			--end
		end
	end
end

local __CheckAllienceByKey = function(k,u,t,cast)
	local key,buffName
	if type(k)=="table" then
		key = k[1]
		buffName = k[2]
	else
		key = k
	end
	if key=="TARGET" and not((t or 0)~=0 and cast==hVar.CAST_TYPE.SKILL_TO_UNIT) then
		return false
	end
	if (t or 0)==0 then
		return true
	else
		local sus = false
		if key=="ANY" then
			sus = true
		elseif key=="TARGET" then
			sus = true
		elseif key=="SELF" then
			sus = u==t
		elseif key=="ALLY" then
			if u~=t then
				sus = u.data.owner==t.data.owner
			end
		elseif key=="SELF_OR_ALLY" then
			sus = u.data.owner==t.data.owner
		elseif key=="ENEMY" then
			sus = u.data.owner~=t.data.owner
		end
		if sus and buffName then
			sus = t:getbuff(buffName)~=nil
		end
		return sus
	end
end

local __AssistOrderTemp = {}
_hrd.checkassist = function(self,oUnit,oTarget,tAssistFlag,nAssistSkillId,nCastX,nCastY)
	local AssistTab = self.data.AssistUnit
	if AssistUnit==0 or #AssistTab<=0 then
		return
	end
	local oWorld = self:getworld()
	if not(oWorld and oWorld.ID~=0) then
		return
	end
	if oUnit==nil then
		return
	end
	local IsSkillToGrid = 0
	if oTarget==nil then
		IsSkillToGrid = 1
	end
	if type(oTarget)~="table" then
		oTarget = nil
	end
	if tAssistFlag==nil then
		tAssistFlag = AssistTab.flag
	end
	--清理order排序表
	for i = 1,10 do
		if not(__AssistOrderTemp[i] and #__AssistOrderTemp[i]==0) then
			__AssistOrderTemp[i] = {}
		end
	end
	local nManaCost = 0
	local nCastType = 0
	local nIsUnique = 0
	if nAssistSkillId~=0 and hVar.tab_skill[nAssistSkillId] then
		nCastType = hVar.tab_skill[nAssistSkillId].cast_type or 0
		nManaCost = hVar.tab_skill[nAssistSkillId].manacost or 0
		nIsUnique = hVar.tab_skill[nAssistSkillId].unique or 0
	end
	--{key={},index={},{unit = u,{"CombatDamage","ALLY",28,1,1},...},...}
	for n = 1,#AssistTab do
		local oAssistUnit
		if AssistTab[n]~=0 and type(AssistTab[n])=="table" then
			oAssistUnit = AssistTab[n].unit
		end
		if oAssistUnit and oAssistUnit.data.IsDead~=1 then
			local tRoundAssistLog = self.data.assistLog
			local tCurAssistLog = {}
			for i = 1,#AssistTab[n] do
				local idx,key,allienceU,allienceT,vAssistData,delay,rMin,rMax = unpack(AssistTab[n][i])
				if tCurAssistLog[vAssistData]~=1 and tAssistFlag[key]==1 and __CheckAllienceByKey(allienceU,oAssistUnit,oUnit,nCastType) then
					local AssistMode = 0
					if IsSkillToGrid==1 then
						if allienceT=="GROUND" then
							AssistMode = 1
						elseif allienceT=="ANY" then
							if vAssistData=="copy_cast" then
								--允许复制区域技能
								AssistMode = 1
							elseif type(vAssistData)=="number" and hVar.tab_skill[vAssistData]~=nil then
								local tabS = hVar.tab_skill[vAssistData]
								if tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
									if nCastType==hVar.CAST_TYPE.SKILL_TO_GRID then
										AssistMode = 1
									end
								elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
									AssistMode = 1
								end
							end
						end
					elseif __CheckAllienceByKey(allienceT,oAssistUnit,oTarget,nCastType) then
						AssistMode = 2
					end
					if AssistMode~=0 then
						tCurAssistLog[vAssistData] = 1
						local skillId = 0
						local nOrderType
						local case = type(vAssistData)
						if key=="#CAST_MANA" and nManaCost<=0 then
							--如果指定需要消耗魔法的技能，并且此次施展不消耗魔法就不触发
						elseif case=="number" then
							skillId = vAssistData
						elseif vAssistData=="attack" then
							local id = hApi.GetDefaultSkill(oAssistUnit)
							local tabS = hVar.tab_skill[id]
							if id~=0 and tabS and tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
								skillId = id
								rMin,rMax = hApi.GetSkillRange(id,oAssistUnit)
							end
						elseif vAssistData=="copy_cast" then
							--复制施法(仅自身施法有效，必须为合法技能)
							local tabAS = hVar.tab_skill[idx]
							if tabAS==nil then
								--未知来源技能
							elseif nIsUnique~=0 then
								--不可复制唯一技能
							elseif (tabAS.manalimit or 9999)<nManaCost then
								--如果法力限制高于复制法力需求，那么不可复制技能
							else
								local tData = oUnit:getskill(nAssistSkillId)
								if oAssistUnit==oUnit and tData then
									skillId = nAssistSkillId
									nOrderType = hVar.ORDER_TYPE.COPY_CAST
								end
							end
						end
						local tabS = hVar.tab_skill[skillId]
						if tabS and skillId~=0 then
							local cast = tabS.cast_type
							local aTemp = __AssistOrderTemp[(tabS.cast_sort or 1)] or __AssistOrderTemp[1]
							if nOrderType==nil then
								if key=="#COUNTER" then
									nOrderType = hVar.ORDER_TYPE.AFTER_COUNTER
								elseif tabS.trigger_mode==1 then
									nOrderType = hVar.ORDER_TYPE.SYSTEM
								else
									nOrderType = hVar.ORDER_TYPE.ASSIST
								end
							end
							if tabS.unique==1 and tRoundAssistLog~=0 then
								if tRoundAssistLog[oAssistUnit.ID.."|"..skillId]==1 then
									cast = hVar.CAST_TYPE.NONE
								else
									tRoundAssistLog[oAssistUnit.ID.."|"..skillId] = 1
								end
							end
							if cast==hVar.CAST_TYPE.SKILL_TO_UNIT then
								local oTargetX = oTarget or oUnit
								if rMax>=0 then
									--需要检查射程
									aTemp[#aTemp+1] = {delay,oAssistUnit,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oTargetX,skillId,rMin,rMax}
								else
									--无视射程发动
									aTemp[#aTemp+1] = {delay,oAssistUnit,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oTargetX,skillId}
								end
							elseif cast==hVar.CAST_TYPE.IMMEDIATE then
								local sus = 1
								if rMax>=0 then
									if allienceT=="SELF" then
										local dis = oWorld:distanceU(oAssistUnit,oUnit,1)
										if not(dis>=rMin and dis<=rMax) then
											sus = 0
										end
									else
										local oTargetX = oTarget or oUnit
										local dis = oWorld:distanceU(oAssistUnit,oTargetX,1)
										if not(dis>=rMin and dis<=rMax) then
											sus = 0
										end
									end
								end
								if sus==1 then
									aTemp[#aTemp+1] = {delay,oAssistUnit,nOrderType,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,skillId}
								end
							elseif cast==hVar.CAST_TYPE.SKILL_TO_GRID then
								if nCastX==nil and nCastY==nil and oTarget~=nil then
									aTemp[#aTemp+1] = {delay,oAssistUnit,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_GRID,skillId,oTarget.data.gridX,oTarget.data.gridY}
								else
									aTemp[#aTemp+1] = {delay,oAssistUnit,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_GRID,skillId,nCastX,nCastY}
								end
							end
						end
					end
				end
			end
		end
	end
	for n = #__AssistOrderTemp,1,-1 do
		local v = __AssistOrderTemp[n]
		if #v>0 then
			for i = 1,#v do
				self:autoorder(unpack(v[i]))
			end
			__AssistOrderTemp[n] = {}
		end
	end
end


local __CODE__ActiveAction = function(self,nFrameCount)
	local d = self.data
	local tActionList = d.autoActionList
	local oWorld = self:getworld()
	if oWorld==nil or type(tActionList)~="table" then
		d.codeActionLoop = 0
		return
	end
	--如果还有正在执行的技能，那么等待一会
	local oActionL = d.autoActionList.cur
	local oAction = hApi.GetObject(oActionL)
	if oAction and (oAction.data.processTag~="wait" or oWorld.data.actioncount>0) then
		return
	end
	--找到一个可以执行的技能
	local actions
	for i = #tActionList,1,-1 do
		if type(tActionList[i])=="table" then
			actions = tActionList[i]
			break
		end
	end
	if actions==nil then
		d.codeActionLoop = 0
	else
		while(actions.idx<=#actions)do
			local oAction = actions[actions.idx]
			actions.idx = actions.idx + 1
			if oAction.ID~=0 then
				hApi.SetObject(oActionL,oAction)
				oAction:go("continue",1)
				if hApi.GetObject(oActionL) then
					if oAction.data.processTag~="wait" or oWorld.data.actioncount>0 then
						return
					else
						hApi.SetObject(oActionL,nil)
					end
				end
			end
		end
		if actions.idx>#actions and oWorld.data.actioncount<=0 then
			--战场已结束
			if type(d.codeOnRoundEnd)=="function" then
				local pCodeE = d.codeOnRoundEnd
				d.codeOnRoundEnd = 0
				return hpcall(pCodeE)
			end
			for i = 1,#tActionList do
				if tActionList[i]==actions then
					tActionList[i] = 0
					break
				end
			end
			--判断是否还有剩余的可激活技能
			local IsEnd = 1
			for i = 1,#tActionList do
				if tActionList[i]~=0 then
					IsEnd = 0
					break
				end
			end
			if IsEnd==1 then
				d.codeOnRoundEnd = 0
				d.autoActionList = 0
			end
			--执行退出函数
			if type(actions.exitcode)=="function" then
				return actions.exitcode()
			end
		end
	end
end

_hrd.activeaction = function(self,aTab,oUnit,nActiveMode,exitCode)
	local n = #aTab
	if n>0 then
		local d = self.data
		local actions = {}
		if oUnit=="all" then
			for i = 1,n do
				local t = aTab[i]
				if t and t~=0 then
					aTab[i] = 0
					local oAction = hClass.action:find(t[1])
					if oAction and oAction.__ID==t[2] then
						actions[#actions+1] = oAction
					end
				end
			end
			hApi.SortTableI(aTab)
		else
			local nRound = d.roundCur
			--单位激活的话，每轮最多激活一次
			for i = 1,n do
				local t = aTab[i]
				if t and t~=0 then
					local oAction = hClass.action:find(t[1])
					if oAction and oAction.__ID==t[2] then
						if oAction.ID~=0 then
							local CanActive = 0
							if nActiveMode==__ROUND_ACTIVE_MODE.ALL then
								--无限制激活方式
								CanActive = 1
							elseif nActiveMode==__ROUND_ACTIVE_MODE.NONE then
								--非常规激活方式
								if oAction.data.LastActiveRound==-2 then
									CanActive = 1
								end
							elseif nActiveMode==__ROUND_ACTIVE_MODE.NORMAL then
								--常规激活方式
								if nRound~=oAction.data.LastActiveRound then
									CanActive = 1
								end
							end
							if CanActive==1 then
								if oAction.data.bindU[1]~=0 then
									--buff附着对象检测
									if oAction.data.bindU[1]~=oUnit.ID then
										CanActive = 0
									end
								elseif oAction.data.cast==hVar.OPERATE_TYPE.SKILL_TO_UNIT then
									--目标释放技能对象检测
									if oUnit~=oAction.data.target then
										CanActive = 0
									end
								else
									--其他技能对象检测
									if oAction.data.unit~=oUnit then
										CanActive = 0
									end
								end
							end
							if CanActive==1 then
								if oAction.data.LastActiveRound>=0 then
									oAction.data.LastActiveRound = nRound
								end
								aTab[i] = 0
								actions[#actions+1] = oAction
							end
						end
					else
						aTab[i] = 0
					end
				end
			end
			hApi.SortTableI(aTab)
		end
		local oWorld = self:getworld()
		if oWorld then
			if oWorld.data.IsQuickBattlefield==1 then
				--快速战场的自动战斗流程和这里略微不一样
				local index = 1
				while(index<=#actions)do
					local oAction = actions[index]
					index = index + 1
					if oAction.ID~=0 then
						oAction:go("continue",1)
					end
				end
				--战场已结束
				if type(d.codeOnRoundEnd)=="function" then
					local pCodeE = d.codeOnRoundEnd
					d.codeOnRoundEnd = 0
					return hpcall(pCodeE)
				end
				if type(exitCode)=="function" then
					return exitCode()
				end
			else
				--插入到执行队列中
				actions.idx = 1
				actions.exitcode = exitCode
				--actions.mode = nActiveMode
				if d.autoActionList==0 then
					d.autoActionList = {cur={},actions}
				else
					--local nInsertI
					--for i = #d.autoActionList,1,-1 do
						--local v = d.autoActionList[i]
						--if type(v)=="table" and v.mode>nActiveMode then
							--nInsertI = i
						--end
					--end
					--if nInsertI then
						--for i = #d.autoActionList,nInsertI,-1 do
							--d.autoActionList[i+1] = d.autoActionList[i]
						--end
						--d.autoActionList[nInsertI] = actions
					--else
						--d.autoActionList[#d.autoActionList+1] = actions
					--end
					d.autoActionList[#d.autoActionList+1] = actions
				end
				d.codeActionLoop = __CODE__ActiveAction
			end
		end
	else
		if type(exitCode)=="function" then
			return exitCode()
		end
	end
end

_hrd.onUnitHpLower = function(self,oUnit,nHpPec)
	local tActions = self.data.wAction.UnitHpLower
	if (tActions.count[oUnit.ID] or 0)>0 then
		local tActionCur = {}
		local nCount = 0
		for i = 1,#tActions do
			local t = tActions[i]
			local oAction = hClass.action:find(t[1])
			if oAction and oAction.__ID==t[2] and oAction.data.bindU[1]==oUnit.ID and oAction.data.bindU[2]==oUnit.__ID then
				nCount = nCount + 1
				if nHpPec<=t[3] then
					tActions[i] = 0
					tActionCur[#tActionCur+1] = oAction
				end
			end
		end
		tActions.count[oUnit.ID] = nCount - #tActionCur
		if #tActionCur>0 then
			hApi.SortTableI(tActions)
			for i = 1,#tActionCur do
				tActionCur[i]:go("continue",1)
			end
		end
	end
end

_hrd.getworld = function(self)
	local d = self.data
	local w = hClass.world:find(d.worldID)
	if w and w.data.roundID==self.ID and w.__ID==d.world__ID then
		return w
	end
end

--------------------------------------------
-- 行动堆叠:
-- 每回合转换行动优先权时，将以当前单位创建一个堆叠
-- 所有单位的新加入行动将加入这个堆叠，按顺序依次执行
-- 当堆叠中无可继续执行的动作时，进入下一轮
--------------------------------------------
_hrd.enableorder = function(self,oUnit,nOperate,id)
	local o = self.order
	if oUnit~=nil then
		o.i = o.i + 1
		o[o.i] = {0,hVar.ROUND_ORDER_TYPE.AVAILABLE,oUnit.ID,oUnit.__ID,nOperate,{id}}
	end
end

_hrd.autoorder = function(self,delay,oUnit,nCastOrder,nOperate,p1,p2,p3,p4,p5,p6,p7,p8,p9)
	local o = self.order
	local d = self.data
	if oUnit~=nil then
		if nCastOrder==hVar.ORDER_TYPE.SYSTEM or nCastOrder==hVar.ORDER_TYPE.SYSTEM_FIRST_ROUND then
			--这俩命令不判断眩晕
		elseif oUnit.attr.stun>0 then
			_DEBUG_MSG("unit"..oUnit.data.id.." is stuned")
			return
		end
		if type(delay)~="number" then
			delay = 0
		end
		if delay>0 then
			local w = self:getworld()
			if w and w.data.IsQuickBattlefield==1 then
				delay = 0
			end
		end
		local insertI = 0
		if delay<0 then
			delay = 0
			--插入模式
			insertI = math.max(1,d.cur)
			for i = o.i,insertI,-1 do
				o[i+1] = o[i]
			end
			o.i = o.i + 1
		else
			insertI = o.i + 1
			o.i = o.i + 1
		end
		o[insertI] = {delay,hVar.ROUND_ORDER_TYPE.AUTO,oUnit.ID,oUnit.__ID,nCastOrder,nOperate,{p1,p2,p3,p4,p5,p6,p7,p8,p9}}
	end
end
local __AUTO_DEFINE = {
	nDelay = 1,
	nState = 2,
	nUnitID = 3,
	nUnit__ID = 4,
	nCastOrder = 5,
	nOperate = 6,
	tParam = 7,
}
local _nAnyOrder = hVar.ROUND_ORDER_TYPE.AVAILABLE
local _IsOrderAuto = hVar.ROUND_ORDER_TYPE.AUTO
local _IsOrderFinished = hVar.ROUND_ORDER_TYPE.FINISHED
_hrd.auto = function(self,oUnit,oAction)
	local d = self.data
	local o = self.order
	if d.auto~=0 then
		--回合已经处于自动运行状态下不自动执行
		return
	else
		d.auto = 1
		d.cur = 1
		local exitCode
		local oWorld = self:getworld()
		local currentU = hApi.SetObject({},oUnit)
		local currentW = hApi.SetObject({},oWorld)
		local currentA = {}
		local case = type(oAction)
		if case=="function" then
			hApi.SetObject(currentA,nil)
			local pCode = oAction
			exitCode = function()
				d.auto = 0
				d.cur = 0
				o.i = 0
				if type(d.codeOnRoundEnd)=="function" then
					local pCodeE = d.codeOnRoundEnd
					d.codeOnRoundEnd = 0
					hpcall(pCodeE)
				end
				local oWorld = self:getworld()
				if oWorld and oWorld.data.PausedByWhat~="Victory" then
					return hpcall(pCode)
				end
			end
		else
			if case=="table" then
				hApi.SetObject(currentA,oAction)
			else
				hApi.SetObject(currentA,nil)
			end
			exitCode = function()
				d.auto = 0
				d.cur = 0
				o.i = 0
				if type(d.codeOnRoundEnd)=="function" then
					local pCodeE = d.codeOnRoundEnd
					d.codeOnRoundEnd = 0
					hpcall(pCodeE)
				end
				local oWorld = self:getworld()
				if oWorld and oWorld.data.PausedByWhat~="Victory" then
					--自动执行跳过回合的操作
					local p = hGlobal.player[self.data.operator]
					if p and oWorld then
						return hGlobal.event:call("Event_BattlefieldUnitSkip",oWorld,self,oUnit)
					end
				end
			end
		end
		local commonDelay = 0
		d.LockFrameCount = math.max(d.LockFrameCount,hApi.GetFrameCountByTick(200))		--每回合至少锁定200ms禁止跳过
		local CheckActionByArrive = 0
		local IsArrived = 0
		if oAction=="move" then
			CheckActionByArrive = 1
			local FinalMoveI = 0
			for i = 1,o.i do
				local v = o[i]
				if v[__AUTO_DEFINE.nOperate]==hVar.OPERATE_TYPE.UNIT_MOVE and v[__AUTO_DEFINE.nState]==_IsOrderAuto then
					FinalMoveI = i
				end
			end
			if FinalMoveI>0 then
				o[FinalMoveI].IsFinalMove = 1
				CheckActionByArrive = 0
			end
		end
		local self__ID = self.__ID
		local processCode = function(nPastTick)
			--如果自己已经完蛋，不做任何操作直接返回
			if self.ID==0 or self.__ID~=self__ID then
				return false
			end
			local oWorld = self:getworld()
			if oWorld==nil then
				return false
			end
			--尝试检测移动到达效果
			if CheckActionByArrive~=0 then
				if IsArrived==0 then
					IsArrived = 1
					self:activeaction(self.data.wAction.UnitArrive,oUnit,hVar.ROUND_DEFINE.ACTIVE_MODE.ALL,function()
						CheckActionByArrive = 0
					end)
				end
				if CheckActionByArrive~=0 then
					return true,oUnit
				end
			end
			--还有技能在飞呢，等会吧
			if oWorld.data.actioncount>0 then
				if oWorld.data.IsQuickBattlefield==1 then
					--这是啥情况，QuickBattlefield里面应该没有东西在等待才对
				else
					return true
				end
			end
			--正常流程
			if o.i>0 then
				while(d.cur<=o.i)do
					local i = d.cur
					local v = o[i]
					--延迟模式
					if nPastTick and v[__AUTO_DEFINE.nDelay]>0 then
						v[__AUTO_DEFINE.nDelay] = v[__AUTO_DEFINE.nDelay] - nPastTick
						return true
					end
					local nOperate = v[__AUTO_DEFINE.nOperate]
					local nCastOrder = v[__AUTO_DEFINE.nCastOrder]
					d.cur = i+1
					if v[__AUTO_DEFINE.nState]==_IsOrderAuto then
						local u = hClass.unit:find(v[__AUTO_DEFINE.nUnitID])
						--光环命令一定可以执行，即使单位死了
						if u and u.__ID==v[__AUTO_DEFINE.nUnit__ID] and (u.data.IsDead~=1 or nOperate==hVar.OPERATE_TYPE.AURA_TO_UNIT) then
							local p = u:getowner()
							local tParam = v[__AUTO_DEFINE.tParam]
							if nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT then
								local oTarget = tParam[1]
								local nSkillId = tParam[2]
								local rMin = tParam[3]
								local rMax = tParam[4]
								local gridX = tParam[5] or oTarget.data.gridX
								local gridY = tParam[6] or oTarget.data.gridY
								if oTarget.ID~=0 and oTarget.data.IsDead~=1 then
									local sus = 1
									if rMin and rMax and rMax>0 then
										local w = oTarget:getworld()
										local dis = w:distanceU(u,oTarget,1)
										if not(dis>=rMin and dis<=rMax) then
											sus = 0
										end
									end
									if sus==1 then
										--local _,action = p:operate(oTarget:getworld(),nOperate,u,nSkillId,oTarget,oTarget.data.gridX,oTarget.data.gridY)
										local sus,action = hGlobal.event:rcall("Event_UnitStartCast",oWorld,1,nCastOrder,nOperate,u,nSkillId,oTarget,gridX,gridY)
										return true,u,action
									end
								end
							elseif nOperate==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
								local nSkillId = tParam[1]
								local gridX = tParam[2] or u.data.gridX
								local gridY = tParam[3] or u.data.gridY
								local sus,action = hGlobal.event:rcall("Event_UnitStartCast",oWorld,1,nCastOrder,nOperate,u,nSkillId,nil,gridX,gridY)
								return true,u,action
							elseif nOperate==hVar.OPERATE_TYPE.SKILL_TO_GRID then
								local nSkillId = tParam[1]
								local gridX = tParam[2] or u.data.gridX
								local gridY = tParam[3] or u.data.gridY
								local sus,action = hGlobal.event:rcall("Event_UnitStartCast",oWorld,1,nCastOrder,nOperate,u,nSkillId,nil,gridX,gridY)
								return true,u,action
							elseif nOperate==hVar.OPERATE_TYPE.SKILL_AUTO then
								local nSkillId =tParam[1]
								local nSkillLv = 1
								local action
								local tabS = hVar.tab_skill[nSkillId]
								if tabS then
									action = hClass.action:new({
										mode = "skill",
										CastOrder = nCastOrder,
										cast = hVar.OPERATE_TYPE.SKILL_IMMEDIATE,
										damageType = tabS.damage_type,
										skillId = nSkillId,
										skillLv = nSkillLv,
										manacost = tabS.manacost,
										unit = u,
										gridX = u.data.gridX,
										gridY = u.data.gridY,
										IsNoTrigger = 1,
									})
								end
								return true,u,action
							elseif nOperate==hVar.OPERATE_TYPE.AURA_TO_UNIT then
								local oTarget = tParam[1]
								local nSkillId = tParam[2]
								local nAuraUnique = tParam[3]
								local vBuffName = tParam[4]
								if hApi.IsUnitAlive(oTarget) then
									if vBuffName==nil or oTarget:getbuff(vBuffName)==nil then
										local nSkillLv = 1
										local action
										local tabS = hVar.tab_skill[nSkillId]
										if tabS then
											action = hClass.action:new({
												mode = "skill",
												CastOrder = nCastOrder,
												cast = hVar.OPERATE_TYPE.SKILL_TO_UNIT,
												IsNoTrigger = 1,
												damageType = tabS.damage_type,
												skillId = nSkillId,
												skillLv = nSkillLv,
												manacost = tabS.manacost,
												unit = u,
												gridX = oTarget.data.gridX,
												gridY = oTarget.data.gridY,
												target = oTarget,
												targetC = oTarget,
												IsFacingTo = 0,		--光环技能无需面向目标施放
												IsAuraBuff = nAuraUnique,--技能是光环类型的技能
											})
										end
										return true,u,action
									end
								end
							elseif nOperate==hVar.OPERATE_TYPE.UNIT_MOVE then
								local gridX = tParam[1]
								local gridY = tParam[2]
								local oOperatingTarget = tParam[3]
								local nOperate = tParam[4]
								local vOrderId = tParam[5]
								u:movetogrid(gridX,gridY,oOperatingTarget,nOperate,vOrderId)
								if v.IsFinalMove==1 then
									CheckActionByArrive = 1
								end
								return true,u
							elseif nOperate==hVar.OPERATE_TYPE.OPEN_GATE then
								local oPlayer = tParam[1]
								oWorld:opengate(oPlayer,1,"stand_opened")
								return true,u
							elseif nOperate==hVar.OPERATE_TYPE.CLOSE_GATE then
								local oPlayer = tParam[1]
								oWorld:opengate(oPlayer,0,"stand")
								return true,u
							end
						end
					end
				end
			end
			return false
		end
		if oWorld then
			if oWorld.data.IsQuickBattlefield==1 then
				--快速战斗直接执行代码不生成timer
				for i = 1,999 do
					if not(processCode()) then
						return exitCode()
					end
				end
				return exitCode()
			else
				--回合循环
				local self__ID = self.__ID
				local nPastTick = math.ceil(1000/hApi.GetFrameCountByTick(1000))
				self.data.codeRoundLoop = function(nFrameCount)
					local d = self.data
					if self.ID==0 or self.__ID~=self__ID then
						d.codeRoundLoop = 0
						return
					end
					local cW = hApi.GetObject(currentW)
					if cW then
						--有任何技能在执行的情况下不自动执行
						if (cW.data.actioncount>0 or cW.data.unitcountM>0) then
							return
						end
						local cU = hApi.GetObject(currentU)
						if cU and cU.handle.UnitInMove==1 then
							--单位移动状态下不自动执行
							return
						end
						--执行代码是否成功
						local sus,u,action = processCode(nPastTick)
						if sus then
							if action and action.ID~=0 then
								hApi.SetObject(currentU,u)
								hApi.SetObject(currentA,action)
							else
								hApi.SetObject(currentU,nil)
								hApi.SetObject(currentA,nil)
							end
							return
						end
					end
					if d.LockFrameCount<=0 then
						d.codeRoundLoop = 0
						--如果世界结束了，那么不做任何操作
						if self.ID==0 or self.__ID~=self__ID then
							return
						end
						return exitCode()
					end
				end
			end
		else
			return exitCode()
		end
		
	end
end

_hrd.checkorder = function(self,oUnit,nOperate,IsWithFinish)
	local o = self.order
	--尝试解析为标准
	for i = 1,o.i,1 do
		local v = o[i]
		if v[__AUTO_DEFINE.nState]~=_IsOrderFinished and v[__AUTO_DEFINE.nUnitID]==oUnit.ID and v[__AUTO_DEFINE.nUnit__ID]==oUnit.__ID and v[__AUTO_DEFINE.nOperate]==nOperate then
			nFind = i
			break
		end
	end
	if nFind==nil then
		--尝试解析为任意命令
		for i = 1,o.i,1 do
			local v = o[i]
			if v[__AUTO_DEFINE.nState]~=nAnyOrder and v[__AUTO_DEFINE.nUnitID]==oUnit.ID and v[__AUTO_DEFINE.nUnit__ID]==oUnit.__ID then
				nFind = i
				break
			end
		end
	end
	if nFind~=nil then
		local oOrder = o[nFind]
		if IsWithFinish and oOrder then
			oOrder[__AUTO_DEFINE.nState] = hVar.ROUND_ORDER_TYPE.FINISHED
			oOrder[__AUTO_DEFINE.nOperate] = nOperate
		end
		return oOrder,nFind
	end
end

_hrd.closeallorder = function(self)
	if self.data.auto==1 then
		return
	end
	local o = self.order
	for i = 1,o.i,1 do
		if o[i][__AUTO_DEFINE.nState]==0 then
			o[i][__AUTO_DEFINE.nState] = 1
		end
	end
end


-----------------------------------------------
-- 单位行动排序:功能函数
-----------------------------------------------
-- 功能函数
local __RD__ShowList = function(tList,nStart,nEnd)
	nStart = nStart or 1
	nEnd = nEnd or #tList
	for i = nStart,nEnd do
		local v = tList[i]
		local t = {"["..string.format("%03d",v[__ROUND_DATA_INDEX.nUnique]).."]"..string.format("%06d",v[__ROUND_DATA_INDEX.oUnit].data.id),
			"act="..v[__ROUND_DATA_INDEX.nActivity]+v[__ROUND_DATA_INDEX.nActivityEx],
			"owner="..v[__ROUND_DATA_INDEX.oUnit].data.owner,
			"sort="..v[__ROUND_DATA_INDEX.nSortMode],
			"mode="..v[__ROUND_DATA_INDEX.nActiveMode],
		}
		print(unpack(t))
	end
end
local __RD__GetLimitIndex = function(tList,tRoundData,nCur,nMax)
	local s,e,p
	if nMax<0 then
		s,e,p = nCur-1,1,-1
	else
		s,e,p = nCur+1,math.min(#tList,nMax),1
	end
	local nIndex = nCur
	local nActivityC = tRoundData[__ROUND_DATA_INDEX.nActivity] + tRoundData[__ROUND_DATA_INDEX.nActivityEx]
	for i = s,e,p do
		local v = tList[i]
		if v==nil then
			break
		elseif v[__ROUND_DATA_INDEX.oUnit].data.id=="round" then
			break
		elseif nActivityC~=(v[__ROUND_DATA_INDEX.nActivity] + v[__ROUND_DATA_INDEX.nActivityEx]) then
			break
		else
			nIndex = i
		end
	end
	return nIndex
end
local __RD__tPlayerSort = {
	index = {},
	update = function(self,tPlayerSort)
		for i = -1,hVar.MAX_PLAYER_NUM,1 do
			self.index[i] = 0
		end
		for i = 2,#tPlayerSort do
			self.index[tPlayerSort[i]] = #tPlayerSort-i+1
		end
		return self.index
	end,
}
local __RD__GetInsertIndex = function(tList,tPlayerSort,tRoundData,nCur,nMax)
	local tPlayerSortI = __RD__tPlayerSort:update(tPlayerSort)
	local nStart = __RD__GetLimitIndex(tList,tRoundData,nCur,-1)
	local nEnd = __RD__GetLimitIndex(tList,tRoundData,nCur,nMax)
	local nLastSort
	for i = nStart-1,1,-1 do
		local v = tList[i]
		if v[__ROUND_DATA_INDEX.oUnit].data.id=="round" then
			nLastSort = 0
			break
		elseif v[__ROUND_DATA_INDEX.nActivityEx]==0 then
			nLastSort = tPlayerSortI[v[__ROUND_DATA_INDEX.oUnit].data.owner] or 0
			break
		end
	end
	if nLastSort==nil then
		nLastSort = tPlayerSortI[tPlayerSort[1]] or 0
	end
	local nInsertSort = tPlayerSortI[tRoundData[__ROUND_DATA_INDEX.oUnit].data.owner] or 0
	local CanInsert = 0
	for i = nStart,nEnd do
		local v = tList[i]
		local nCurSort = tPlayerSortI[v[__ROUND_DATA_INDEX.oUnit].data.owner] or 0
		if v[__ROUND_DATA_INDEX.nSortMode]==__ROUND_SORT_MODE.NORMAL then
			local nCurSortX = nCurSort
			if nCurSort==nLastSort and nInsertSort~=nCurSort then
				nCurSortX = -1
			end
			if nLastSort>nCurSort then
				--完整队列，必须插入排序
				if nInsertSort>nCurSortX and nInsertSort<nLastSort then
					return i
				end
			else
				--非完整队列，只要大于就可插入
				if nInsertSort>nCurSortX then
					return i
				end
			end
			if v[__ROUND_DATA_INDEX.nActivityEx]==0 then
				nLastSort = nCurSort
			end
		end
	end
	return nEnd+1
end
local __RD__InsertRoundData = function(tList,tPlayerSort,tRoundData,nUniqueCur)
	local nRound = tRoundData[__ROUND_DATA_INDEX.nRound]
	local nStart,nEnd
	for i = 1,#tList do
		local v = tList[i]
		if nRound==v[__ROUND_DATA_INDEX.nRound] then
			nStart = nStart or i
		elseif nRound<v[__ROUND_DATA_INDEX.nRound] then
			nEnd = nEnd or i-1
		end
		if nStart and nEnd then
			break
		end
	end
	nStart = nStart or 1
	nEnd = nEnd or #tList
	local nFirst = nStart
	local nInsert = nEnd+1
	local nInsertMax = nEnd+1
	if tList[nStart]~=nil then
		--不能重新排序当前已经激活的单位
		if tList[nStart][__ROUND_DATA_INDEX.nUnique]==nUniqueCur or tList[nStart][__ROUND_DATA_INDEX.oUnit].data.id=="round" then
			nStart = nStart + 1
		end
		local nActivityC = tRoundData[__ROUND_DATA_INDEX.nActivity] + tRoundData[__ROUND_DATA_INDEX.nActivityEx]
		local nInsertMode = tRoundData[__ROUND_DATA_INDEX.nSortMode]
		--跟随排序模式
		if nInsertMode==__ROUND_SORT_MODE.APPEND then
			local nFind
			for i = nFirst,nEnd do
				local v = tList[i]
				local nActivityT = v[__ROUND_DATA_INDEX.nActivity] + v[__ROUND_DATA_INDEX.nActivityEx]
				if nActivityC>nActivityT and i>=nStart then
					nFind = i-1
					break
				elseif v[__ROUND_DATA_INDEX.oUnit]==tRoundData[__ROUND_DATA_INDEX.oUnit] then
					nFind = i
				elseif nFind~=nil then
					local vF = tList[nFind]
					if vF[__ROUND_DATA_INDEX.nUnique]~=nUniqueCur then
						tRoundData[__ROUND_DATA_INDEX.nActivity] = vF[__ROUND_DATA_INDEX.nActivity]
						tRoundData[__ROUND_DATA_INDEX.nActivityEx] = vF[__ROUND_DATA_INDEX.nActivityEx]
					end
					break
				end
			end
			if nFind then
				nInsert = nFind+1
				return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
			end
		end
		--普通排序模式
		for i = nStart,nEnd do
			local v = tList[i]
			local nActivityT = v[__ROUND_DATA_INDEX.nActivity] + v[__ROUND_DATA_INDEX.nActivityEx]
			if nActivityC>nActivityT then
				nInsert = i
				for n = nStart,i,1 do
					local v = tList[n]
					local nActivityV = v[__ROUND_DATA_INDEX.nActivity] + v[__ROUND_DATA_INDEX.nActivityEx]
					if nActivityC>nActivityV then
						nInsert = n
						break
					elseif nActivityC==nActivityV then
						nInsert = __RD__GetInsertIndex(tList,tPlayerSort,tRoundData,n,nEnd)
						break
					end
				end
				return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
			elseif nActivityC==nActivityT then
				if nInsertMode==__ROUND_SORT_MODE.INSERT then
					nInsert = i
					return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
				elseif nInsertMode==__ROUND_SORT_MODE.WAIT then
					nInsert = __RD__GetLimitIndex(tList,tRoundData,i,nEnd)+1
					return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
				end
				nInsert = __RD__GetInsertIndex(tList,tPlayerSort,tRoundData,i,nEnd)
				return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
			end
		end
	end
	return hApi.InsertValueIntoTab(tList,nInsert,tRoundData,nInsertMax)
end

-----------------------------------------------
-- 单位行动排序
-----------------------------------------------
_hrd.__AddRoundData = function(self,oUnit,nRound,nActivityEx,nActiveMode,nSortMode)
	return __RD__AddRoundData(self,oUnit,nRound,nActivityEx,nActiveMode,nSortMode)
end

local __SortTab,__SortID,__Sort__ID
_hrd.__PlayerSort = function(self,nRound)
	local oWorld = self:getworld()
	local tPlayerSort = self.data.PlayerSort
	if oWorld and oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
		--网络战场交替排序
		if math.mod(nRound,2)==0 then
			if __SortID==self.ID and __Sort__ID==self.__ID and type(__SortTab)=="table" then
				__SortTab[1] = tPlayerSort[1]
				tPlayerSort = __SortTab
			else
				__SortTab = {tPlayerSort[1]}
				for i = #tPlayerSort,2,-1 do
					__SortTab[#__SortTab+1] = tPlayerSort[i]
				end
				tPlayerSort = __SortTab
			end
		end
	end
	return tPlayerSort
end
local __RD__PushRoundDataWithSort = function(tList,tRoundData)
	local nInsert = #tList+1
	local nActivityC = tRoundData[__ROUND_DATA_INDEX.nActivity] + tRoundData[__ROUND_DATA_INDEX.nActivityEx]
	for i = 1,#tList do
		local v = tList[i]
		local nActivityT = v[__ROUND_DATA_INDEX.nActivity] + v[__ROUND_DATA_INDEX.nActivityEx]
		if nActivityC>nActivityT then
			nInsert = i
			break
		end
	end
	hApi.InsertValueIntoTab(tList,nInsert,tRoundData)
end
local __CODE__GetUnitFromBattlefield = function(oUnit,tUnit)
	if oUnit.attr.passive>0 then
		return
	end
	if oUnit.data.IsDead~=1 and (oUnit.data.type==hVar.UNIT_TYPE.UNIT or oUnit.data.type==hVar.UNIT_TYPE.HERO) then
		tUnit[#tUnit+1] = oUnit
	end
end
_hrd.__loadbylength = function(self)
	local oWorld = self:getworld()
	if oWorld==nil then
		return
	end
	local d = self.data
	local tList = self.list
	if #tList>=d.length then
		return
	end
	local tUnit = {}
	oWorld:enumunit(__CODE__GetUnitFromBattlefield,tUnit)
	if #tUnit>0 then
		while(#tList<d.length)do
			d.roundMax = d.roundMax + 1
			local nRound = d.roundMax
			tList[#tList+1] = self:__AddRoundData("round",nRound)
			local tSort = {}
			for i = 1,#tUnit do
				local tRoundData = self:__AddRoundData(tUnit[i],nRound,0,__ROUND_ACTIVE_MODE.NORMAL,__ROUND_SORT_MODE.NORMAL)
				__RD__PushRoundDataWithSort(tSort,tRoundData)
			end
			local tPlayerSort = self:__PlayerSort(nRound)
			for i = 1,#tSort do
				__RD__InsertRoundData(tList,tPlayerSort,tSort[i],0)
			end
		end
	end
end

_hrd.newunit = function(self,oUnit)
	if oUnit.attr.passive>0 then
		return
	end
	local d = self.data
	local tList = self.list
	for nRound = math.max(1,d.roundCur),d.roundMax do
		local tPlayerSort = self:__PlayerSort(nRound)
		local tRoundData = self:__AddRoundData(oUnit,nRound,0,__ROUND_ACTIVE_MODE.NORMAL,__ROUND_SORT_MODE.NORMAL)
		__RD__InsertRoundData(tList,tPlayerSort,tRoundData,d.ActivedUnit[3])
	end
	self:sortunitall()
end

_hrd.sort = function(self,nRound,IsShowSort)
	local d = self.data
	local tList = self.list
	local nStart,nEnd
	for i = 1,#tList do
		local v = tList[i]
		local nRoundC = v[__ROUND_DATA_INDEX.nRound]
		if nRound==nRoundC then
			nStart = nStart or i
			nEnd = i
		elseif nRound<nRoundC then
			break
		end
	end
	--不对已经激活的单位排序
	if nStart==1 and tList[nStart] and tList[nStart][__ROUND_DATA_INDEX.nUnique]==d.ActivedUnit[3] then
		nStart = 2
	end
	if nStart and nEnd and nStart<nEnd then
		if IsShowSort then
			print("------------Round"..nRound.."--------------")
			__RD__ShowList(tList,nStart,nEnd)
		end
		local tPlayerSort = self:__PlayerSort(nRound)
		for i = nStart,nEnd do
			tList[i][__ROUND_DATA_INDEX.nActivity] = tList[i][__ROUND_DATA_INDEX.oUnit].attr.activity
		end
		local tSort = {}
		for i = nStart,nEnd do
			__RD__PushRoundDataWithSort(tSort,tList[i])
		end
		local tTemp = {}
		for i = 1,#tSort do
			__RD__InsertRoundData(tTemp,tPlayerSort,tSort[i],d.ActivedUnit[3])
		end
		for i = 1,#tTemp do
			tList[nStart+i-1] = tTemp[i]
		end
		if IsShowSort then
			print("------------Temp--------------")
			__RD__ShowList(tTemp)
			print("------------Sort--------------")
			__RD__ShowList(tSort)
			print("------------AfterSort--------------")
			__RD__ShowList(tList,nStart,nEnd)
		end
	end
end

_hrd.sortunitall = function(self)
	local d = self.data
	for nRound = d.roundCur,d.roundMax do
		--self:sort(nRound,nRound==d.roundCur)
		self:sort(nRound)
	end
end

_hrd.insertunit = function(self,oUnit,nRound,nActivity,nActiveMode,nSortMode)
	if oUnit.attr.passive>0 then
		return
	end
	local d = self.data
	local tList = self.list
	if oUnit~=nil then
		nRound = nRound or d.roundCur
		local tPlayerSort = self:__PlayerSort(nRound)
		local tRoundData = self:__AddRoundData(oUnit,nRound,nActivity,nActiveMode,nSortMode)
		__RD__InsertRoundData(tList,tPlayerSort,tRoundData,d.ActivedUnit[3])
		return self:sort(nRound)
	end
end

_hrd.removeunit = function(self,oUnit,nRound)
	local tList = self.list
	if oUnit~=nil and oUnit.data.id~="round" then
		for i = 1,#tList do
			local v = tList[i]
			if v~=0 and v[__ROUND_DATA_INDEX.oUnit]==oUnit and (nRound or v[__ROUND_DATA_INDEX.nRound])==v[__ROUND_DATA_INDEX.nRound] then
				tList[i] = 0
			end
		end
		hApi.CompressNumTab(tList)
	end
end

_hrd.top = function(self,n,k)
	local tList = self.list
	local tRoundData
	if n==nil then
		--如果没指定索引，那么必须返回一个单位！
		for i = 1,#tList do
			if tList[i][__ROUND_DATA_INDEX.oUnit].data.id~="round" then
				tRoundData = tList[i]
				break
			end
		end
	else
		if type(self.list[n])=="table" then
			tRoundData = self.list[n]
		end
	end
	if tRoundData then
		if k=="all" then
			return unpack(tRoundData)
		elseif k~=nil then
			return tRoundData[k]
		else
			return tRoundData
		end
	end
end

_hrd.pop = function(self,oUnit)
	local oWorld = self:getworld()
	if oWorld==nil then
		return
	end
	local d = self.data
	local tList = self.list
	local tRoundData = tList[1]
	if type(tRoundData)=="table" then
		if oUnit~=nil then
			if tRoundData[__ROUND_DATA_INDEX.oUnit]~=oUnit then
				--如果与传入单位不匹配，那么就不做pop操作
				return
			elseif oUnit.data.id=="round" then
				--回合都允许pop!
			elseif tRoundData[__ROUND_DATA_INDEX.nUnique]~=d.ActivedUnit[3] then
				--如果激活顺序有问题，那么就不做pop操作
				return
			end
		end
		if tRoundData[__ROUND_DATA_INDEX.oUnit].data.id=="round" then
			d.roundCur = tRoundData[__ROUND_DATA_INDEX.nRound]
			d.PlayerSort[1] = 0
		end
		tList[1] = 0
		hApi.CompressNumTab(tList)
		self:__loadbylength()
		return unpack(tRoundData)
	end
end

_hrd.activeunit = function(self,oUnit)
	local d = self.data
	d.assistLog = {}
	if oUnit and oUnit.ID and oUnit.ID>0 and oUnit.data.id~="round" then
		local tRoundData = self.list[1]
		if tRoundData and tRoundData[1]==oUnit then
			local oPlayer = oUnit:getcontroller()
			if oPlayer then
				oPlayer.localdata.LastOperateUnique = tRoundData[__ROUND_DATA_INDEX.nUnique]
			end
			d.operator = oUnit.data.control
			d.ActivedUnit[1] = oUnit.ID
			d.ActivedUnit[2] = oUnit.__ID
			d.ActivedUnit[3] = tRoundData[__ROUND_DATA_INDEX.nUnique]
			if tRoundData[__ROUND_DATA_INDEX.nSortMode]==__ROUND_SORT_MODE.NORMAL then
				d.PlayerSort[1] = oUnit.data.owner
			end
			oUnit:setroundstate(hVar.UNIT_ROUND_STATE.ROUND_START)
		else
			_DEBUG_MSG("[ROUND ERROR]:active error"..tostring(oUnit.data.id))
		end
	else
		d.operator = 0
		d.ActivedUnit[1] = 0
		d.ActivedUnit[2] = 0
		d.ActivedUnit[3] = 0
	end
end