--local __ENUM__IsAnyAllyDamaged = function(t,u,temp)
--	--�����Ƿ��ٻ�����Ѿ�����Ż��������
--	if t.data.IsDead~=1 and t.data.owner==u.data.owner and t.data.indexOfTeam~=0 then
--		local a = t.attr
--		if t.data.type==hVar.UNIT_TYPE.UNIT then
--			temp.nAllyCount = temp.nAllyCount + 1
--			--��ͨ��λ����������һֻ�ű���Ϊ�ǿ�����Ŀ��
--			if a.__stack>a.stack then
--				temp.nDamagedAllyCount = temp.nDamagedAllyCount + 1
--			end
--			temp.nHpMax = temp.nHpMax + a.mxhp*a.__stack
--			local nHpLost = (a.__stack-a.stack+1)*a.mxhp-a.hp
--			temp.nHpLost = temp.nHpLost + nHpLost
--			if temp.nHpLostMax<nHpLost then
--				temp.uLostMax = t.ID
--				temp.nHpLostMax = nHpLost
--			end
--		elseif t.data.type==hVar.UNIT_TYPE.HERO then
--			temp.nAllyCount = temp.nAllyCount + 1
--			--Ӣ����ʧ20%��������Żᱻ��Ϊ�ǿ�����Ŀ��
--			if t.attr.hp<=hApi.floor(t.attr.mxhp*4/5) then
--				temp.nDamagedAllyCount = temp.nDamagedAllyCount + 1
--			end
--			temp.nHpMax = temp.nHpMax + a.mxhp*a.__stack
--			local nHpLost = a.mxhp-a.hp
--			temp.nHpLost = temp.nHpLost + nHpLost
--			if temp.nHpLostMax<nHpLost then
--				temp.uLostMax = t.ID
--				temp.nHpLostMax = nHpLost
--			end
--		end
--	end
--end
--
--local __CalHpLost = function(u)
--	local a = u.attr
--	return (a.__stack+1-a.stack)*a.mxhp-a.hp
--end
--
--local __SELECT_HealTarget = function(oUnit,tGrid,id,mode)
--	local dMin,dMax,hMin,hMax = hApi.CalculateSkillDamage(oUnit,id)
--	--ѡ�����Ƽ��ܵ�Ŀ��
--	for ID,v in pairs(tGrid.Target)do
--		if v.type~="OutOfRange" and v.type~="Immune" then
--			--�Ƿ�Ŀ�겻�����ڿ���Ŀ����
--			local t = hClass.unit:find(ID)
--			local a = t.attr
--			local nHeal = oUnit.attr.stack*(hMin+hMax)/2
--			local nHpLost = (a.__stack+1-a.stack)*a.mxhp-a.hp
--			local nHpMax = a.mxhp*a.__stack
--			if nHpLost>0 then
--				if t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO then
--					local pec = nHeal/nHpLost
--					--print(id,nHeal,nHpLost,hVar.tab_unit[t.data.id].name)
--					if pec<=1 then
--						--û�й������Ƶ�����£���ֱ��ѡ��
--						tGrid.TargetList[#tGrid.TargetList+1] = t
--					elseif pec<=2 then
--						if nHpLost/nHpMax>=0.5 then
--							tGrid.TargetList[#tGrid.TargetList+1] = t
--						end
--					else
--						if nHpLost/nHpMax>=0.7 then
--							tGrid.TargetList[#tGrid.TargetList+1] = t
--						end
--					end
--				end
--			end
--		end
--	end
--	tGrid.TargetList.SelectChance = 80
--	tGrid.TargetList.SortCode = function(a,b)
--		return __CalHpLost(a)>__CalHpLost(b)
--	end
--end
--
----hVar.SKILL_AI_TYPE = {
--	--["Default"] = {1,100},
--	--["Damage"] = {4,75},
--	--["Heal"] = {3,75},
--	--["DamageArea"] = {4,50},
--	--["HealArea"] = {2,50},
--	--["Buff"] = {2,50},
--	--["Debuff"] = {2,50},
--	--["BuffArea"] = {3,20},
--	--["DebuffArea"] = {3,20},
----}
--
----hGlobal.CastAI["Heal"] = function(oUnit,temp,id,mode)
----	if temp.nDamagedUnit==nil then
----		temp.nAllyCount = 0
----		temp.nDamagedAllyCount = 0
----		temp.nHpLost = 0
----		temp.nHpMax = 0
----		temp.uLostMax = 0
----		temp.nHpLostMax = 0
----		local w = oUnit:getworld()
----		w:enumunit(__ENUM__IsAnyAllyDamaged,oUnit,temp)
----	end
----	if temp.nDamagedAllyCount==0 then
----		--�������ܵ��˺��ĵ�λ
----		return -1
----	else
----		local nLevel,nChance,tCode
----		if mode=="HealArea" then
----			--�ж�Ⱥ��Ч��
----			if temp.nDamagedAllyCount>=2 and temp.nDamagedAllyCount/temp.nAllyCount>=0.5 then
----				--���˵�λ����һ���ʱ��(����������λ)��
----				--����ʹ��Ⱥ�Ƶ����ȼ������4(ԭ��2)
----				local lostPec = temp.nHpLost/temp.nHpMax
----				if lostPec>=0.8 then
----					--��ʧ��hp������Ѫ��80%��ʱ�����ȼ�������5��ʹ�ü�����ߵ�100%
----					nLevel = 5
----					nChance = 100
----				elseif lostPec>=0.5 then
----					--��ʧ��hp������Ѫ��50%��ʱ�����ȼ�������5��ʹ�ü�����ߵ�75%
----					nLevel = 5
----					nChance = 75
----				end
----			end
----		else
----			--�жϵ���Ч��
----			local pec = temp.nHpLostMax*temp.nAllyCount/temp.nHpMax
----			if pec>=0.7 then
----				--����κ�������ʧ��ƽ��Ѫ����70%���ϣ������ȼ������5��ʹ�ü��������90%
----				nLevel = 5
----				nChance = 90
----			elseif pec>=0.5 then
----				--����κ�������ʧ��ƽ��Ѫ����50%���ϣ������ȼ������5��ʹ�ü��������75%
----				nLevel = 5
----				nChance = 75
----			elseif pec>=0.3 then
----				--����κ�������ʧ��ƽ��Ѫ����30%���ϣ������ȼ������5��ʹ�ü��������50%
----				nLevel = 5
----				nChance = 50
----			end
----		end
----		--print("���Ƽ���",id,mode,nLevel,nChance)
----		tCode = __SELECT_HealTarget
----		--print("�������Ƽ���["..id.."],���ȼ�"..tostring(nLevel).."ʹ�ü���"..tostring(nChance))
----		return nLevel,nChance,tCode
----	end
----end
--
----hGlobal.CastAI["HealArea"] = hGlobal.CastAI["Heal"]
--
--
----hGlobal.CastAI[562] = function()
--	--print("��ʼ�ж�562�ż��ܵ�����ʩ��AI")
--	----��Ȼ�����ͷ�
--	--return 5,100
----end
--
----hGlobal.CastAI[564] = function()
--	--print("��ʼ�ж�564�ż��ܵ�����ʩ��AI")
--	----��Ȼ�����ͷ�
--	--return 5,100
----end
--
--
----�������Ͷǹ
----hGlobal.CastAI[1003] = function(oUnit,temp,id,mode)
----	--print("���Ի�����")
----	--if temp.EnemyMeleeCount==nil then
----		--temp.EnemyMeleeCount = 0
----		--temp.EnemyRangeCount = 0
----		--local w = oUnit:getworld()
----		--w:enumunit(function(t)
----			--if t.data.IsDead~=1 and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----				--if t.data.owner~=oUnit.data.owner then
----					--local id,rMin,rMax = unpack(t.attr.attack)
----					--local tabS = hVar.tab_skill[id]
----					--if tabS then
----						--if rMax>1 or tabS.template=="RangeAttack" then
----							--temp.EnemyRangeCount = temp.EnemyRangeCount + 1
----						--else
----							--temp.EnemyMeleeCount = temp.EnemyMeleeCount + 1
----						--end
----					--end
----				--end
----			--end
----		--end)
----	--end
----	--if temp.NearEnemy==nil then
----		
----	--end
----	--if temp.EnemyMeleeCount<=0 then
----		--return -1
----	--end
----	--return 5,100
----	--�ж��Ƿ���Զ�̵������Լ����ϣ��еĻ���ʹ��Ͷǹ
----	if temp.NearRangeEnemyCount==nil then
----		temp.NearRangeEnemyCount = 0
----		local w = oUnit:getworld()
----		if w then
----			w:enumunitUR(oUnit,0,1,function(t)
----				if t.data.IsDead~=1 and t.data.owner~=oUnit.data.owner and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----					local tabS = hVar.tab_skill[t.attr.attack[1]]
----					if tabS then
----						if tabS.template=="RangeAttack" then
----							temp.NearRangeEnemyCount = temp.NearRangeEnemyCount + 1
----						elseif t.attr.attack[3]>2 then
----							temp.NearRangeEnemyCount = temp.NearRangeEnemyCount + 1
----						end
----					end
----				end
----			end)
----		end
----	end
----	if temp.NearRangeEnemyCount>0 then
----		--���κ�Զ�̵��������ߵ�ʱ�򣬲�ʹ��Ͷǹ
----		return -1
----	else
----		--������50%�ļ���ʹ��
----		return nil,50
----	end
----end
--
--local __AddUnitToTab = function(u,t,aT,eT)
--	if u.data.owner==t.data.owner then
--		aT[#aT+1] = t
--	else
--		eT[#eT+1] = t
--	end
--end
--
--local __GetUnitInTab = function(w,t,chance)
--	for i = 1,#t do
--		if i==#t or hApi.random(1,100)<=chance then
--			return t[i]
--		end
--	end
--end
--
--local __SORT__CodeByHarm = function(a,b)
--	if a.attr.stack*(a.attr.attack[4]+a.attr.attack[5])<b.attr.stack*(b.attr.attack[4]+b.attr.attack[5]) then
--		return true
--	end
--end
--hApi.SortUnitByHarm = function(t)
--	table.sort(t,__SORT__CodeByHarm)
--end
--
--local __SORT__CodeByHp = function(a,b)
--	if (a.attr.stack-1)*a.attr.mxhp+a.attr.hp>(b.attr.stack-1)*b.attr.mxhp+b.attr.hp then
--		return true
--	end
--end
--hApi.SortUnitByHp = function(t)
--	table.sort(t,__SORT__CodeByHp)
--end
--
------�ܲٵĴ���
----hGlobal.CastAI["Teleport"] = function(oUnit,temp,id,mode)
----	if temp.NoTeleport==1 then
----		return -1
----	end
----	local w = oUnit:getworld()
----	local aMelee = {}
----	local eMelee = {}
----	local aRange = {}
----	local eRange = {}
----	--local aMagic = {}
----	--local eMagic = {}
----	w:enumunit(function(t)
----		if t.data.IsDead~=1 and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----			local tabS = hVar.tab_skill[t.attr.attack[1]]
----			if tabS then
----				if tabS.template=="RangeAttack" then
----					__AddUnitToTab(oUnit,t,aRange,eRange)
----				else
----					if t.attr.attack[3]<=2 then
----						__AddUnitToTab(oUnit,t,aMelee,eMelee)
----					--else
----						--__AddUnitToTab(oUnit,t,aMagic,eMagic)
----					end
----				end
----			end
----		end
----	end)
----	--ֻ����Լ��Ľ�ս�������Զ�����ߴ���
----	if #aMelee>0 and #eRange>0 then
----		local uTab = {}
----		local tTab = eRange
----		for i = 1,#aMelee do
----			local NearCount = 0
----			w:enumunitUR(aMelee[i],1,2,function(t)
----				if t.data.IsDead~=1 and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----					if oUnit.data.owner~=t.data.owner then
----						NearCount = NearCount + 1
----					end
----				end
----			end)
----			if NearCount==0 then
----				uTab[#uTab+1] = aMelee[i]
----			end
----		end
----		if #uTab>0 then
----			--���ҷ���ǿ�Ľ�ս���͵���в����Զ�̵о�����
----			hApi.SortUnitByHp(uTab)
----			hApi.SortUnitByHarm(tTab)
----			local u = __GetUnitInTab(w,uTab,50)
----			local _,mGrid = u:getmovegrid(999,1)
----			local tGrid = hApi.CalculateMovePath(u,2,mGrid,mGrid)
----			for i = 1,#tTab do
----				local t = tTab[i]
----				local g = tGrid.Target[t.ID]
----				if g and g.type=="MoveAndAttack" then
----					local v = g[hApi.random(1,#g)]
----					local x,y = v.x,v.y
----					local tCode = function(oUnit,tGrid,id,mode)
----						tGrid.castXY = {x,y}
----						tGrid.TargetList[#tGrid.TargetList+1] = u
----					end
----					return 5,100,tCode
----				end
----			end
----		end
----	end
----	temp.NoTeleport = 1
----	return -1
----end
----
------�ĺ�ĳ��
----hGlobal.CastAI["Charge"] = function(oUnit,temp,id,mode)
----	local oWorld = oUnit:getworld()
----	local tEnemy = {}
----	oWorld:enumunit(function(t)
----		if t.data.IsDead~=1 and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----			if oUnit.data.owner~=t.data.owner and oWorld:distanceU(oUnit,t,1)>1 then
----				tEnemy[#tEnemy+1] = t
----			end
----		end
----	end)
----	if #tEnemy>0 then
----		local tTab = tEnemy
----		local cTab = {{dis=3,chance=100},{dis=0,chance=50}}
----		hApi.SortUnitByHarm(tTab)
----		local mGrid
----		local g = hApi.GetChargeGrid(oUnit,id,1)
----		if #g<=0 then
----			return -1
----		else
----			mGrid = {
----				grid = g,
----				gridI = {},
----				gridEx = {},
----			}
----			oUnit:__GetExMoveGrid(mGrid.grid,mGrid.gridEx,mGrid.gridI)
----			local tGrid = hApi.CalculateMovePath(oUnit,2,mGrid,mGrid)
----			--�Ե��˵ľ�������������ȳ�3������ĵ�λ
----			for i = 1,#tTab do
----				local t = tTab[i]
----				local g = tGrid.Target[t.ID]
----				if g and g.type=="MoveAndAttack" then
----					local dis = oWorld:distanceU(oUnit,t,1)
----					for n = 1,#cTab do
----						if dis>=cTab[n].dis then
----							cTab[n][#cTab[n]+1] = t
----							break
----						end
----					end
----				end
----			end
----			--�ȳ�Զ��,Ȼ��ſ��ǽ�����,����ԽԶ�ļ���Խ��
----			for n = 1,#cTab do
----				for i = 1,#cTab[n] do
----					local t = cTab[n][i]
----					local g = tGrid.Target[t.ID]
----					if (n==#cTab and i==#cTab[n]) or hApi.random(1,100)<=80 then
----						local v = g[hApi.random(1,#g)]
----						local x,y = v.x,v.y
----						local tCode = function(oUnit,tGrid,id,mode)
----							tGrid.castXY = {x,y}
----							tGrid.TargetList[#tGrid.TargetList+1] = t
----						end
----						return 5,cTab[n].chance,tCode
----					end
----				end
----			end
----		end
----	end
----	return -1
----end
----
------����������λ֮��ľ��루����
------u�ǹ��Σ�
----local __CalDisW = function(u,t)
----	local ux = u.data.gridX
----	local tx = t.data.gridX
----	return math.abs(ux-tx)
----end
------��ǽ
----hGlobal.CastAI["IceWall"] = function(oUnit,temp,id,mode)
----	local w = oUnit:getworld()
----	local tEnemy = {}
----	w:enumunit(function(t)
----		if t.data.IsDead~=1 and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----			--�ǽ�ս�ĵ���
----			if oUnit.data.owner~=t.data.owner and t.attr.attack[3]<=2 and __CalDisW(oUnit,t)>=2 then
----				tEnemy[#tEnemy+1] = t
----			end
----		end
----	end)
----	if #tEnemy>0 then
----		local tCode = function(oUnit,tGrid,id,mode)
----			local w = oUnit:getworld()
----			table.sort(tEnemy,function(a,b)
----				return __CalDisW(oUnit,a)<__CalDisW(oUnit,b)
----			end)
----			local t = tEnemy[1]
----			if t.data.gridX<oUnit.data.gridX then
----				--���
----				if t.attr.block==hVar.UNIT_BLOCK_MODE.RIDER then
----					tGrid.castXY = {t.data.gridX+1,t.data.gridY}
----				else
----					tGrid.castXY = {t.data.gridX+1,t.data.gridY}
----				end
----			else
----				--�ұ�
----				if t.attr.block==hVar.UNIT_BLOCK_MODE.RIDER then
----					tGrid.castXY = {t.data.gridX,t.data.gridY}
----				else
----					tGrid.castXY = {t.data.gridX-1,t.data.gridY}
----				end
----			end
----			tGrid.TargetList[#tGrid.TargetList+1] = t
----		end
----		return 5,100,tCode
----	end
----	return -1
----end
----
------�޲�(���ȼ�����)
----hGlobal.CastAI[220] = function(oUnit,temp,id,mode)
----	return 3,50
----end
----
------�ڷ�˫��(����ʱ�͵��弼�����ȼ�һ��)
----hGlobal.CastAI[2038] = function(oUnit,temp,id,mode)
----	return 4,75
----end
----
------������(��ⳡ��<=1��������ʱ���ͷż�����ߣ�==2ʱ���ʽ���,>=3ʱ���ͷ�)
----hGlobal.CastAI[201] = function(oUnit,temp,id,mode)
----	local tabS = hVar.tab_skill[id]
----	if tabS then
----		local oWorld = oUnit:getworld()
----		local nCount = 0
----		local IsAnyEnemyNear = 0
----		oWorld:enumunit(function(t)
----			if t.data.IsDead~=1 then
----				if t.data.owner==oUnit.data.owner and t.data.id==11100 then
----					nCount = nCount + 1
----				end
----				if IsAnyEnemyNear==0 and t.data.owner~=oUnit.data.owner and (t.data.type==hVar.UNIT_TYPE.UNIT or t.data.type==hVar.UNIT_TYPE.HERO) then
----					if oWorld:distanceU(oUnit,t,1)<=8 then
----						IsAnyEnemyNear = 1
----					end
----				end
----			end
----		end)
----		if IsAnyEnemyNear~=1 then
----			return -1
----		elseif tabS.readlv and oUnit:getskill(tabS.readlv)~=nil then
----			if nCount<=1 then
----				return 4,75
----			elseif nCount==2 then
----				return 4,50
----			else
----				return -1
----			end
----		elseif nCount<(tabS.maxcount or tabS.count or 0) then
----			return 4,50
----		else
----			return -1
----		end
----	end
----end
--
----��������˫��ļ���ֻ���ڷ�Χ��ӵ�п���ֱ�Ӵ򵽵ĵ���ʱ�Ż�ʹ��
--local AvatarID = {
--	{123,5,75},		--���𣺷���
--	{164,6,100},		--���ƣ���˫
--	{144,6,100},		--�ŷɣ����Ī��
--	{263,6,100},		--��Τ��ʮ��һɱ
--	{562,5,100},		--ͨ�ã�����ͻ��
--	{564,6,100,"BUFF_564"},	--ͨ�ã�������
--	{541,5,100},		--����������ͻ��
--	{542,5,100},		--��������Ѫ
--	{544,6,100,"BUFF_544"},	--������������
--}
--local AvatarT = {}
--local AvatarSkillCode = function(oUnit,temp,id,mode)
--	if AvatarT[id] then
--		local lv,chance,buffName = unpack(AvatarT[id])
--		--��������buff�Ͳ�����ʹ��
--		if buffName and oUnit:getbuff(buffName) then
--			return -1
--		end
--		if temp.TargetReachableCount==nil then
--			temp.TargetReachableCount = 0
--			local id = hApi.GetDefaultSkill(oUnit)
--			if id and id~=0 and hVar.tab_skill[id] then
--				local tGrid = hApi.CalculateMovePath(oUnit,id)
--				for _,v in pairs(tGrid.Target)do
--					if v.type=="Attack" or v.type=="MoveAndAttack" then
--						temp.TargetReachableCount = temp.TargetReachableCount + 1
--					end
--				end
--			end
--		end
--		if temp.TargetReachableCount==0 then
--			return -1
--		else
--			return lv,chance
--		end
--	end
--end
--for i = 1,#AvatarID do
--	local id,lv,chance,buffName = unpack(AvatarID[i])
--	AvatarT[id] = {lv,chance,buffName}
--	hGlobal.CastAI[id] = AvatarSkillCode
--end