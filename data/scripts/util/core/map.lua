hClass.map = eClass:new("static enum")
local _hm = hClass.map
--类似world,能读取map,但是不会被保存,也不存在单位实体

local __DefaultParam = {
	map = 0,		--地图名称(仅仅记录用)
	background = 0,		--地形路径，如果存在就会读取
	type = "none",		--世界类型，将锁定某个layer
	scenetype = 0,		--世界scene字符串，如果填了此值将忽视type，加载到目标scene上
	w = 0,
	h = 0,
	sizeW = 0,
	sizeH = 0,
	IsTemp = 0,		--移除texture标签
	--chaHandle = {index={}},--角色handle
	codeOnChaCreate = 0,	--function(oMap,tChaHandle,id,owner,worldX,worldY,facing)
	codeOnAllCreate = 0,	--function(oMap)
	codeOnTouchDown = 0,	--function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
	codeOnTouchUp = 0,	--function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
	codeOnTouchMove = 0,
	chapterId = 0,		--zhenkira，章节id
}
local __EmptyParam = {}
_hm.init = function(self,p)
	p = p or __EmptyParam
	--INIT START--
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = {}
	self.worldUI = {}

	local d = self.data
	d.chaHandle = {index={},indextgr={}}
	--自动设置scenetype
	if d.scenetype==0 then
		if d.type=="worldmap" then
			d.scenetype = "worldmap"
		elseif d.type=="town" then
			d.scenetype = "town"
		elseif d.type=="battlefield" then
			d.scenetype = "battlefield"
		else
			d.scenetype = "worldmap"
		end
	end
	
	--加载地形
	self:loadmap()
	self:loadunit()
	
	if d.codeOnAllCreate and type(d.codeOnAllCreate) == "function" then
		d.codeOnAllCreate(self, self.data.chaHandle)
	end
	
	--加载ui(herocardfrm.png)
	--if d.map == hVar.PHONE_SELECTLEVEL or d.map == hVar.PHONE_SELECTLEVEL_3 then
	--print("$$$$$$$$$$$$$$$$$$$$$$$$$hApi.CheckMapIsChapter 1")
	if hApi.CheckMapIsChapter(d.map) then
		if not hGlobal.UI.HeroCardNewFrm then
			hGlobal.UI.InitHeroCardNewFrm()
		end
	end
	
end

_hm.destroy = function(self)
	local d = self.data
	if g_map_on_scene[d.scenetype]==self then
		g_map_on_scene[d.scenetype] = nil
	end
	for k,v in pairs(self.worldUI)do
		v:del()
	end
	for i = 1,#d.chaHandle do
		local v = d.chaHandle[i]
		if type(v)=="table" then
			v.s = nil
		end
	end
	local pWorldScene = self.handle.worldScene
	d.chaHandle = {index={}}
	self.handle = {}
	self.worldUI = {}

	if pWorldScene~=nil then
		
		--if d.map == hVar.PHONE_SELECTLEVEL or d.map == hVar.PHONE_SELECTLEVEL_3 then
		if hApi.CheckMapIsChapter(d.map) then
			--print("$$$$$$$$$$$$$$$$$$$$$$$$$hApi.CheckMapIsChapter 2")
			--hApi.addTimerOnce("SYSReleaseUICache",1,function()
				--print("$$$$$$$$$$$$$$$$$$$$$$$$$hApi.CheckMapIsChapter 3")
				--删除herocardfrm.png,目前方法比较暴力 zhenkira
				hGlobal.event:event("LocalEvent_Phone_HeroCardNewFrm_ClearListener")
				
				--geyachao: 这里弹框了，因为没创建控件？
				if hGlobal.UI.HeroCardNewFrm then
					hGlobal.UI.HeroCardNewFrm:del()
					hGlobal.UI.HeroCardNewFrm = nil
				end
				hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_IMAGE_AUTO_RELEASE)
			--end)
			
			collectgarbage()
		end
		
		xlScene_ClearAll(pWorldScene)
	end
end

_hm.show = function(self)
	hGlobal.LocalPlayer:setfocusworld(self)
	hApi.EnableWorldLayer(self.handle,1)
end

--读取地形
_hm.loadmap = function(self)
	local d = self.data
	local handleTable = self.handle
	if d.scenetype~=-1 then
		if g_map_on_scene[d.scenetype] and g_map_on_scene[d.scenetype]~=self then
			xlEvent_BeforeLayerClear(d.scenetype)
		end
		g_map_on_scene[d.scenetype] = self
	end
	hApi.LoadWorldLayer(self.handle,d.scenetype)					--加载世界layer
	d.w,d.h,d.sizeW,d.sizeH = hApi.CreateWorldMapXL(handleTable,d.map,d.background,"town4")
end

--隐藏map上所有的UI
_hm.hideUI = function(self,bool)
	for k,v in pairs(self.worldUI)do
		if v.handle._n then
			v.handle._n:setVisible(bool)
		end
	end
end

local __self,__unitList,__triggerData,__codeOnCreate
local __LoadAllChaOnMap = function()
	local self = __self
	local unitList = __unitList
	local triggerData = type(__triggerData)=="table" and __triggerData or nil
	local codeOnCreate = type(__codeOnCreate)=="function" and __codeOnCreate or nil
	if type(self)~="table" or self.ID==0 or type(unitList)~="table" then
		return
	end
	local worldScene
	if self.handle and type(self.handle.worldScene)=="userdata" then
		worldScene = self.handle.worldScene
		--清除地图上单位使用的编辑器ID
		xlScene_ClearUniqueID(worldScene)
	end
	local tTgrData = {}
	if triggerData~=nil then
		for k,v in pairs(triggerData)do
			if v.uniqueID~=nil then
				tTgrData[v.uniqueID] = v
			end
		end
	end
	local d = self.data
	if unitList~=nil then
		for i = 1,#unitList do
			local unitType,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			if unitType==hVar.UNIT_TYPE.PLAYER_INFO then
				--玩家参数专用单位单位不创建
			else
				local nFacing = hApi.RyanAngleToLeeAngle(facing)
				local tChaHandle = {
					__IsTemp = d.IsTemp,
				}
				local pCha = hApi.CreateChaById(worldScene,tChaHandle,id,owner,worldX,worldY,nFacing)
				if pCha then
					if (unitType == hVar.UNIT_TYPE.UNIT) or (unitType == hVar.UNIT_TYPE.HERO)
						or (unitType == hVar.UNIT_TYPE.BUILDING) or (unitType == hVar.UNIT_TYPE.WAY_POINT)
						or (unitType == hVar.UNIT_TYPE.NPC) or (unitType == hVar.UNIT_TYPE.NPC_TALK) then
						local nInsert = #d.chaHandle+1
						tChaHandle.data = {id=id,type=unitType,owner=owner,worldX=worldX,worldY=worldY,facing=nFacing,triggerID=(tTgrData[triggerID] or 0)}
						if not d.chaHandle.index[id] then
							d.chaHandle.index[id] = {}
						end
						table.insert(d.chaHandle.index[id], nInsert)
						d.chaHandle.index[pCha] = nInsert
						if triggerID and triggerID > 0 then
							d.chaHandle.indextgr[triggerID] = nInsert
						end
						d.chaHandle[nInsert] = tChaHandle
						
						if codeOnCreate then
							codeOnCreate(self,tChaHandle,id,owner,worldX,worldY,nFacing)
						end
					end
				end
			end
		end
	end
end

--读取所有单位
_hm.loadunit = function(self)
	local d = self.data
	if self.handle.worldScene==nil then
		return
	end
	--读取地图
	local _,unitList,triggerData = hApi.LoadMap(d.map)
	__unitList,__triggerData = unitList,triggerData
	__self = self
	__codeOnCreate = d.codeOnChaCreate
	xpcall(__LoadAllChaOnMap,hGlobal.__TRACKBACK__)
end

local __SelectChaFromList = function(worldX,worldY,tChaList)
	local selectC
	local selectV
	if #tChaList>0 then
		for i = 1,#tChaList do
			local c = tChaList[i]
			if c~=0 then
				local cx,cy = xlCha_GetPos(c)
				local w,h = math.abs(cx-worldX),math.abs(cy-worldY)
				local v = w*w+h*h
				if selectV==nil then
					selectC = c
					selectV = v
				elseif v<selectV then
					selectC = c
					selectV = v
				end
			end
		end
	end
	return selectC
end

_hm.hit2cha = function(self,worldX,worldY)
	local tChaList = {hApi.GetWorldChaByHit(self.data.scenetype,worldX,worldY)}
	local selectC
	local tIndex = self.data.chaHandle.index
	if #tChaList>0 then
		for i = 1,#tChaList do
			local c = tChaList[i]
			if tIndex[c]==nil then
				tChaList[i] = 0
			end
		end
		selectC = __SelectChaFromList(worldX,worldY,tChaList)
	end
	if selectC then
		return self.data.chaHandle[tIndex[selectC]]
	end
end

_hm.id2cha = function(self,id)
	local tIndex = self.data.chaHandle.index
	if type(tIndex[id])=="number" then
		return self.data.chaHandle[tIndex[id]]
	elseif type(tIndex[id])=="table" then
		return self.data.chaHandle[tIndex[id][1]]
	end
end

_hm.tgrid2cha = function(self, id)
	local tIndex = self.data.chaHandle.indextgr
	if type(tIndex[id])=="number" then
		return self.data.chaHandle[tIndex[id]]
	end
end

--创建绑定单位cha
hApi.CreateChaById = function(worldScene,handleTable,id,owner,worldX,worldY,facing)
	local tabU = hVar.tab_unit[id]
	if tabU==nil then
		return
	end
	local xlPath = tabU.xlobj
	local modelName = tabU.model
	if xlPath=="gres_mask" and type(modelName)=="string" then
		xlPath = nil
	end
	handleTable.__appear=1
	local nUnitType = tabU.type or hVar.UNIT_TYPE.UNIT
	if xlPath~=nil then
		local zOrder = 0
		if tabU.zOrder and type(tabU.zOrder)=="number" then
			zOrder = tabU.zOrder
		end
		hApi.CreateUnitB(handleTable,worldScene,xlPath,worldX,worldY,facing,zOrder,nUnitType)
		if handleTable._c then
			handleTable.modelmode = 0
			local cFacing = facing + 180
			if cFacing>360 then
				cFacing = cFacing - 360
			end
			hApi.ObjectSetFacing(handleTable,cFacing)
			if nUnitType==hVar.UNIT_TYPE.SCEOBJ then
				--geyachao: 同步日志: 设置场景物件障碍大小4
				if (hVar.IS_SYNC_LOG == 1) then
					local msg = "xlChaSetBoundingBoxInfo4: c=" .. type(handleTable._c) .. ",x=" .. tostring(0) .. ",y=" .. tostring(0) .. ",w=" .. tostring(0) .. ",h=" .. tostring(0)
					hApi.SyncLog(msg)
				end
				hApi.ChaLoadBoundingBox(handleTable._c,0,0,0,0)
			else
				--hApi.SpriteLoadBoundingBox(handleTable,nil,"xlobj",100)
			end
			return handleTable._c,handleTable
		else
			_DEBUG_MSG("[MAP]添加建筑失败！",modelName)
		end
	else
		local nScale = math.floor((tabU.scale or 1)*100)
		local zOrder = 0
		if tabU.zOrder and type(tabU.zOrder)=="number" then
			zOrder = tabU.zOrder
		end
		if tabU.facing and type(tabU.facing)=="number" then
			--强制设置朝向
			facing = tabU.facing
		end
		hApi.CreateUnit(handleTable,worldScene,modelName,nScale/100,worldX,worldY,zOrder,facing,"stand")
		if handleTable._c~=nil then
			--hApi.ObjectSetFacing(handleTable,facing)
			if nUnitType~=0 then
				xlCha_SetType(handleTable._c,nUnitType)
			end
			if tabU.block==0 then
				xlChaSetBlockRadious(handleTable._c,0)
			else
				xlChaSetBlockRadious(handleTable._c,1)
			end
			--设置绑定盒子
			if nUnitType==hVar.UNIT_TYPE.SCEOBJ then
				--geyachao: 同步日志: 设置场景物件障碍大小3
				if (hVar.IS_SYNC_LOG == 1) then
					local msg = "xlChaSetBoundingBoxInfo3: c=" .. type(handleTable._c) .. ",x=" .. tostring(0) .. ",y=" .. tostring(0) .. ",w=" .. tostring(0) .. ",h=" .. tostring(0)
					hApi.SyncLog(msg)
				end
				hApi.ChaLoadBoundingBox(handleTable._c,0,0,0,0)
			else
				--print("hApi.SpriteLoadBoundingBox 9")
				hApi.SpriteLoadBoundingBox(handleTable,tabU.box,"UNIT",nScale, xlPath)
			end
		end
		return handleTable._c,handleTable
	end
end


hGlobal.event["LocalEvent_PlayerTouchOnMap"] = function(oMap,screenX, screenY, worldX, worldY,rParam)
	local code = oMap.data.codeOnTouchDown
	if type(code)=="function" then
		rParam[1] = code(oMap,worldX,worldY,screenX, screenY)
	end
	
end


hGlobal.event["LocalEvent_PlayerTouchUpFromMap"] = function(oMap,screenX, screenY, worldX, worldY)
	local code = oMap.data.codeOnTouchUp
	if type(code)=="function" then
		return code(oMap,worldX,worldY,screenX, screenY)
	end
end

hGlobal.event["LocalEvent_PlayerTouchMoveFromMap"] = function(oMap,screenX, screenY)
	local code = oMap.data.codeOnTouchMove
	if type(code)=="function" then
		return code(oMap,screenX, screenY)
	end
end
