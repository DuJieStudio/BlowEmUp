-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的场景物件类
--@处在场景中的各种可交互或不可交互的物件
hClass.sceobj = eClass:new("static enum")
--hClass.sceobj:sync("local",{"handle",})		--设置这些表项下面的数据为本地数据，无需保存

local _hso = hClass.sceobj
_hso.__static = {}
_hso.__static.objIdByCha = {}
hApi.findSceobjByCha = function(cha)
	return _hso:find(_hso.__static.objIdByCha[cha] or 0)
end
local __DefaultParam = {
	userdata = 0,
	id = 0,
	scale = 100,
	standX = 0,
	standY = 0,
	gridX = 0,
	gridY = 0,
	worldX = 0,
	worldY = 0,
	height = 0,
	facing = 0,
	bindW = 0,
	worldI = 0,
}
--初始化
_hso.init = function(self,p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,rawget(self,"handle") or {})
	hApi.bindObjectWithParent("sceobjs","worldI",hClass.world:find(self.data.bindW),self)

	local d = self.data
	d.effectsOnCreate = {}
	d.effectS = hApi.clearTable("I",d.effectS)	--单位随身特效
	d.IsHide = nil
	local model = p~=nil and p.model or hVar.tab_model[1].name
	local aniKey = p~=nil and type(p.animation)=="string" and p.animation or "stand"
	local w = hClass.world:find(d.bindW)
	if p.gridX and p.gridY then
		d.worldX,d.worldY = w:grid2xy(d.gridX,d.gridY)
	else
		d.gridX,d.gridY = w:xy2grid(d.worldX,d.worldY)
	end
	local xlPath = model
	if aniKey=="xlobj" and hVar.tab_model.index[xlPath]==nil then
		--print('if aniKey=="xlobj" and hVar.tab_model.index[xlPath]==nil then')
		self.handle.name = xlPath
		hApi.CreateSceobjB(self.handle,w.handle.worldScene,xlPath,d.worldX+d.standX,d.worldY+d.standY,d.height,d.facing)
		_hso.__static.objIdByCha[self.handle._c] = self.ID
		--河流的sprite在第一帧用完以后就完蛋了，所以这里只初始化一次选择区域，直接丢弃sprite
		--hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",100)
		if d.scale>0 and d.scale~=100 then
			--print("hApi.SpriteLoadBoundingBox 8")
			hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",d.scale, xlPath)
			self.handle.s:setScale(d.scale/100)
		else
			--print("hApi.SpriteLoadBoundingBox 7")
			hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",100, xlPath)
		end
		self.handle.s = nil
		self:enableselect()
	else
		--print('self.handle.name = model')
		self.handle.name = model
		--非源代码模式下看不到这个
		if g_editor==1 then
			--self.handle.__box = {-16,-16,32,32}
		else
			if model=="MODEL:default" then
				model = nil
			end
		end
		hApi.CreateSceobj(self.handle,w.handle.worldScene,model,d.scale/100,d.worldX+d.standX,d.worldY+d.standY,d.height,d.facing,aniKey)
		_hso.__static.objIdByCha[self.handle._c] = self.ID
		self:enableselect()
	end
	--附加特效
	local tabU = hVar.tab_unit[d.id]
	--print("--附加特效 local tabU = hVar.tab_unit[d.id] l",d.id)
	if self.handle._c and tabU then
		if tabU.motion then
			hUI.setMotion(self.handle.s,0,0,tabU.motion)
		end
		if tabU.effect then
			for i = 1,#tabU.effect do
				local v = tabU.effect[i]
				local m,x,y,scale,facing,z = unpack(v)
				z = z or hVar.ZERO
				if type(m)=="number" and hVar.tab_effect[m] then
					m = hVar.tab_effect[m].model
				end
				if type(m)=="string" then
					local e = {handle={}}
					facing = facing or d.facing
					x = x or 0
					y = y or 0
					scale = scale or 1
					if d.facing>=90 and d.facing<270 then
						x = -1*x
					end
					hApi.CreateEffectU(e,self,"none",m,scale,x,y,0,0,hApi.animationByFacing(m,"stand",facing),z)
					d.effectsOnCreate[#d.effectsOnCreate+1] = e --单位创建的时候，身上的特效
				end
			end
		elseif tabU.effectS then
			for i = 1,#tabU.effectS do
				local v = tabU.effectS[i]
				local model,x,y,scale,facing = unpack(v)
				--x = x + d.worldX
				--y = y + d.worldY
				local e = w:addeffect(model,0,{hVar.EFFECT_TYPE.SCEOBJ,"EFF_"..i,self,0,1},x,y,facing,(scale or 1)*100)
			end
		end
	end
	local tTab_EventUnit = hVar.EventUnitDefine[d.id]
	if type(tTab_EventUnit) == "table" then
		w.data.tdMapInfo.eventUnit[#w.data.tdMapInfo.eventUnit + 1] = {d.id,self,tTab_EventUnit.count}
		print("d.id",d.id)
	end
end

_hso.destroy = function(self)
	local d = self.data
	hApi.enumByClass(self,hClass.effect,d.effectS,hApi.removeObject)	--清除所有随身特效
	hApi.unbindObjectWithParent("sceobjs","worldI",hClass.world:find(d.bindW),self)
	hApi.RemoveSceobj(self.handle)
end

local __EnableSelect = function(self)
	if self.handle._c~=nil then
		--print("hApi.SpriteLoadBoundingBox 6")
		hApi.SpriteLoadBoundingBox(self.handle,nil,"xlobj",66)
	end
end
local __DisableSelect = function(self)
	if self.handle._c~=nil then
		--geyachao: 同步日志: 设置场景物件障碍大小2
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "xlChaSetBoundingBoxInfo2: c=" .. type(self.handle._c) .. ",x=" .. tostring(0) .. ",y=" .. tostring(0) .. ",w=" .. tostring(0) .. ",h=" .. tostring(0)
			hApi.SyncLog(msg)
		end
		hApi.ChaLoadBoundingBox(self.handle._c,0,0,0,0)
		--hApi.SpriteLoadBoundingBox(self.handle,nil,"NONE",100)
	end
end
_hso.enableselect = function(self,enable)
	enable = enable or hVar.SCEOBJ_SELECTABLE
	local code
	if enable==0 then
		code = __DisableSelect
	else
		code = __EnableSelect
	end
	if self==hClass.sceobj then
		hClass.sceobj:enum(code)
	elseif self.ID~=0 and self.handle._c~=nil then
		code(self)
	end
end

_hso.sethide = function(self,hide)
	if hide == 0 then
		if self.data.IsHide~=0 then
			self.data.IsHide = 0
			if self.handle._c~=nil then
				--self:initmodel()
				xlCha_Hide(self.handle._c,0)
				self.handle._n:setVisible(true)
				if self.handle._tn then
					self.handle._tn:setVisible(true)
				end
			end
		end
	else
		if self.data.IsHide~=1 or hide==2 then
			self.data.IsHide = 1
			if self.handle._c~=nil then
				xlCha_Hide(self.handle._c,1)
				self.handle._n:setVisible(false)
				if self.handle._tn then
					self.handle._tn:setVisible(false)
				end
			end
		end
	end
end