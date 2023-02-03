-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的特效类
--@特效类似箭矢，爆炸之类
hClass.effect = eClass:new("static enum sync")
hClass.effect:sync("local", {"handle",})		--设置这些表项下面的数据为本地数据，无需保存
local _he = hClass.effect
local effect_enum_lasttime = 0 --上次进来的时间 --geyachao
local effect_enum_deltatime = 0
---------------------------------------------
--hVar.EFFECT_TYPE = {
	--NONE = 0,
	--NORMAL = 1,		--随位置偏移
	--OVERHEAD = 2,		--永远在头顶
	--GROUND = 3,		--永远处在地面
	--UNIT = 4,		--{_,bindKey,oUnit}
	--MISSILE = 5,		--{_,oLaunchUnit,launchX,launchX,speed}
	--ARROW = 6,		--{_,worldX,worldY,speed}
--}
---------------------------------------------
--刷新特效动画
local __ENUM__UpdateGameEffect = function(oEffect)
	--print("__ENUM__UpdateGameEffect", oEffect.data.id)
	--非法特效删除
	if not(oEffect.handle and oEffect.handle.removetime) then
		oEffect:del("safe")
		return
	end
	
	if oEffect.handle.NeedShow==1 then
		oEffect.handle.s:setVisible(true)
		oEffect.handle.NeedShow = 0
	end
	
	--过期特效将被删除
	local world = hGlobal.WORLD.LastWorldMap
	local currenttime = 0
	if world then
		currenttime = world:gametime()
	else
		currenttime = hApi.gametime()
	end
	
	if oEffect.handle.removetime~=0 and currenttime>=oEffect.handle.removetime then
		--print("特效死亡的话可能有额外的播放处理", oEffect.data.id)
		if oEffect.data.deadAnimation~=0 then
			local d = oEffect.data
			local aniKey = d.deadAnimation
			oEffect.handle.roll = d.deadAnimationRoll
			d.deadAnimation = 0
			d.deadAnimationRoll = 0
			oEffect.handle.s:setVisible(false)
			oEffect.handle.NeedShow = 1
			--特效死亡的话可能有额外的播放处理
			oEffect.handle.removetime = currenttime + hApi.SpritePlayAnimation(oEffect.handle,aniKey,1,1)
		end
		
		oEffect.data.deadAnimation = 0
		if currenttime>=oEffect.handle.removetime then
			--删除特效前的回调事件
			if (oEffect.handle.oAction_missle ~= nil) then
				--print("oEffect.handle.removetime=" .. oEffect.handle.removetime,oEffect.data.id) --geyachao
				oEffect:OnFlyEffMoveToPoint_Ret(oEffect.handle.oAction_missle)
				oEffect.handle.oAction_missle = nil
			end
			
			return oEffect:del("safe")
		end
	end
	hApi.ObjectUpdateAnimation(oEffect)
end

hApi.UpdateGameEffect = function(dt)
	hClass.effect:enum(__ENUM__UpdateGameEffect)
end

--geyachao: 更新碰撞特效和追踪特效(只在world下生效)
hApi.UpdateCollEffect = function(dt)
	--effect_enum_dt = dt --存储时间间隔 --geyachao
	--更新追踪目标类的飞行特效的位置
	local world = hGlobal.WORLD.LastWorldMap
	local currenttime = world:gametime()
	effect_enum_deltatime = currenttime - effect_enum_lasttime
	--print(effect_enum_lasttime, currenttime)
	effect_enum_lasttime = currenttime
	
	hClass.effect:enum(function(oEffect)
		--更新追踪类、碰撞类飞行特效
		if (oEffect.handle.oTarget) or (oEffect.handle.collision == 1) then
			oEffect:UpdateFollowEff(effect_enum_deltatime)
		end
		
		--更新碰撞类飞行特效
		if (oEffect.handle.collision == 1) then
			oEffect:UpdateCollisionEff(effect_enum_deltatime)
		end
		
		--更新抛物线拖尾
		if (oEffect.handle.MissleStreak == 1) then
			oEffect:UpdateMissleStreakEff(effect_enum_deltatime)
		end
	end)
end



-----------------------------------------------------
--默认参数表
local __DefaultParam = {
	type = hVar.EFFECT_TYPE.NONE,
	userdata = 0,
	userparam = 0,
	deadAnimation = 0,
	deadAnimationRoll = 0,
	playtime = 1,
	id = 0,
	x = 0,
	y = 0,
	height = 0,
	--offsetX = 0, --geyachao: 追踪类初始偏移值x
	--offsetY = 0, --geyachao: 追踪类初始偏移值y
	animation = 0,
	ox = 0,
	oy = 0,
	vx = 0,
	vy = 0,
	facing = 0,
	facingEx = 0,
	scale = 100,
	bindW = 0,
	worldI = 0,
	bindU = 0,
	bindS = 0,
	bindKey = 0,
	bindUID = 0,
	flySpeed = nil, --geyachao: 新加TD飞行特效速度
	ZHeight = nil, --geyachao: 新加TD抛物线Z方向高度
	G = 0, --geyachao: 新加TD抛物线重力加速度
}
local __DefaultSyncData = {
	"type","id","playtime","x","y","height","animation","ox","oy",
	"facing","facingEx","scale","bindW","bindU","bindKey","bindUID","bindS",
}
local __DefaultXLBlink = {image=0,light=1,x=0,y=0,scale = 1.0,dur = 1000,RGB = {255,255,255}, rot = 0,}

--初始化
_he.init = function(self, p)
	--print("_he.init" .. ff)
	--if (self.data) and (self.data.id ~= 0) then
	--	print("异常", self.data.id)
	--end
	
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,rawget(self,"handle") or {})
	hApi.bindObjectWithParent("effects","worldI",hClass.world:find(self.data.bindW),self)
	local d = self.data
	local tabE
	if type(d.id)=="table" then
		tabE = d.id
		d.id = 0
	else
		tabE = hVar.tab_effect[d.id]
		if tabE==nil then
			d.id = 1
		end
		--local name = tabE.name or "unknown"
		--_DEBUG_MSG("	- createEffect:	tab_effect["..d.id.."]	{"..name..","..d.x..","..d.y.."}")
		--self.handle.name = name
	end
	if tabE~=nil then
		d.ox = d.x
		d.oy = d.y
		d.height = tabE.height or 0
	end
	
	self.handle.MissleStreak = nil --抛物线拖尾
	
	--geyachao: 初始化清除一些变量
	self.handle.oTarget = nil --追踪的目标
	self.handle.oAction = nil --追踪的action
	self.handle.oAction_missle = nil --抛物线追踪的action
	self.handle.oAction_missle_toprocess_tag = nil --抛物线追踪的action回调待处理标记
	self.handle.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
	self.handle.customData1 = nil --用户数据1
	self.handle.customData2 = nil --用户数据2
	self.handle.customData3 = nil --用户数据3
	self.handle.collision = nil  --碰撞类型飞行特效的标记
	self.handle._nBlink = nil --清除地面影子
	self.handle._pStreak = nil --清除拖尾效果
	self.handle._nDaodan = nil --清除导弹特效
	self.handle._nDaodanID = nil --清除导弹id
	self.handle._nDaodanDust = nil --清除导弹尘土特效
	self.handle.finish_x = nil --终点x坐标
	self.handle.finish_y = nil --终点y坐标
	
	--self.handle.collParam = nil --碰撞类型飞行特效的相关参数
	self.handle.collision_uidList = nil --碰撞类型飞行特效碰撞过的单位列表
	self.handle.collision_angle = nil --碰撞类型飞行特效碰撞旋转的角度
	self.handle.collision_angle_cosX = nil --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
	self.handle.collision_angle_sinX = nil --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
	self.handle.collision_isRotEff = nil --碰撞类型飞行特效碰撞是否旋转特效
	self.handle.collision_skillId = nil --碰撞类型飞行特效的技能id
	self.handle.collision_caster_unsafe = nil --碰撞类型飞行特效，施法者（可能已死亡或被复用）
	self.handle.collision_caster_worldC = nil --碰撞类型飞行特效，施法者的唯一id
	self.handle.collision_caster_side = nil --碰撞类型飞行特效，施法者的阵营
	self.handle.collision_caster_pos = nil --碰撞类型飞行特效，施法者的位置

	self.handle.collision_caster_typeId = nil --碰撞类型飞行特效，施法者的类型id
	self.handle.collision_caster_targetType = nil --碰撞类型飞行特效，有效目标类型
	self.handle.collision_caster_dmg = nil --碰撞类型飞行特效，施法者造成的伤害
	self.handle.collision_caster_dmgMode = nil --碰撞类型飞行特效，施法者造成的伤害类型
	self.handle.collision_caster_skillId = nil --碰撞类型飞行特效，施法者释放的技能id
	self.handle.collision_caster_skillLv = nil --碰撞类型飞行特效，施法者释放的技能等级
	self.handle.collision_fly_angle = nil --碰撞类型飞行特效飞向的角度
	self.handle.collision_fly_begin_x = nil --碰撞类型飞行特效起始x坐标
	self.handle.collision_fly_begin_y = nil --碰撞类型飞行特效起始y坐标
	self.handle.collision_bBlockWallRemove = nil --碰撞类型飞行特效，特效碰到障碍是否消失
	self.handle.collision_blockWallEffectId = nil --碰撞类型飞行特效，特效碰到障碍消失播放的特效id
	self.handle.collision_bBlockUnitRemove = nil --碰撞类型飞行特效，特效碰到单位是否消失
	self.handle.collision_blockUnitEffectId = nil --碰撞类型飞行特效，特效碰到单位消失播放的特效id
	self.handle.collision_tansheWallCount = nil --碰撞类型飞行特效，特效碰到墙反弹的总次数
	self.handle.collision_tansheWallCountNow = nil --碰撞类型飞行特效，特效碰到墙反弹的当前次数
	self.handle.collision_flytime = nil --碰撞类型飞行特效，特效飞行时间（毫秒）
	self.handle.collision_flytimetick = nil --碰撞类型飞行特效，特效开始飞行的时间
	self.handle.collision_flySpeedV = nil --碰撞类型飞行特效，特效变速速度表
	self.handle.collision_blockWallSound = nil --碰撞类型飞行特效，特效碰到障碍的音效
	self.handle.collision_daodanFlyEffectId = nil --碰撞类型飞行特效，导弹正常状态的特效id
	self.handle.collision_daodanIsHideTail = nil --碰撞类型飞行特效，导弹是否隐藏飞升拖尾特效
	self.handle.collision_daodanBoomEffectId = nil --碰撞类型飞行特效，导弹爆炸特效id
	self.handle.collision_nFlyUnitOnly = nil --碰撞类型飞行特效，特效碰撞是否只检测飞行单位
	self.handle.collision_oActionTempValue = nil --碰撞类型飞行特效temp值表
	self.handle.collision_dMin = nil --碰撞类型飞行特效最小伤害值（LoadAttack）
	self.handle.collision_dMax = nil --碰撞类型飞行特效最大伤害值（LoadAttack）
	
	local eParam = p.playparam
	local oTarget = p.oTarget --geyachao: 新加的参数, oTarget 追踪类飞行特效的追踪目标
	local oAction = p.oAction --geyachao: 新加的参数, action 添加追踪类飞行特效的action
	local szType = p.szType -- geyachao: 新加的参数, szType 追踪类飞行特效的类型（直线型、抛物线型）
	local collision = p.collision -- geyachao: 新加的参数, collision 碰撞类型飞行特效的标记
	local collParam = p.collParam -- geyachao: 新加的参数, collParam 碰撞类型飞行特效的碰撞相关参数
	
	if eParam==nil or eParam==0 then
		--创建xl方式的effect
		--可以和原有流程并行使用
		--目前只支持地面模式特效和箭矢特效
		d.type = hVar.EFFECT_TYPE.NORMAL
		self:addgroundeff(tabE)
	elseif type(eParam)=="table" then
		if eParam[1]==hVar.EFFECT_TYPE.UNIT then
			d.type = hVar.EFFECT_TYPE.UNIT
			--随身特效
			local _,bindKey,oUnit,effectZ,RollByFacing = eParam[1],eParam[2],eParam[3],eParam[4],eParam[5]
			d.height = d.height + (effectZ or 0)
			d.bindU = oUnit.ID
			d.facingEx = RollByFacing==1 and 1 or 0
			d.bindKey = bindKey or 0
			self:adduniteff(tabE)
		elseif eParam[1]==hVar.EFFECT_TYPE.MISSILE then
			d.type = hVar.EFFECT_TYPE.MISSILE
			--d.offsetX = eParam[3] --geyachao: 追踪类初始偏移值x
			--d.offsetY = eParam[4] --geyachao: 追踪类初始偏移值y
			self:addflyeff(tabE, eParam, oTarget, oAction, szType, collision, collParam)
		elseif eParam[1]== hVar.EFFECT_TYPE.SCEOBJ then
			d.type = hVar.EFFECT_TYPE.SCEOBJ
			local _,bindKey,oSceobj,effectZ,RollByFacing = eParam[1],eParam[2],eParam[3],eParam[4],eParam[5]
			d.height = d.height + (effectZ or 0)
			d.bindS = oSceobj.ID
			d.facingEx = RollByFacing==1 and 1 or 0
			d.bindKey = bindKey or 0
			self:addsceobjeff(tabE)
		else
			d.playTime = 0
			hApi.RemoveEffectInTime(self.handle,1)
		end
	end
	if tabE~=nil and self.handle.s then
		if tabE.motion then
			hUI.setMotion(self.handle.s,0,0,tabE.motion)
		end
		if tabE.action and #tabE.action>0 then
			local tAction = tabE.action
			if type(tAction[1][1])=="string" then
				self:playaction(tAction)
			else
				for i = 1,#tAction do
					self:playaction(tAction[i])
				end
			end
		end
	end
	--存储特效的坐标（内存优化，免得调用cosos接口读图片的坐标）
	self.handle.x = d.ox
	self.handle.y = d.oy
end

_he.destroy = function(self)
	local d = self.data
	local h = self.handle
	h.NeedShow = 0
	if d.bindU~=0 then
		hApi.unbindObjectWithParent("effectU","bindUID",hClass.unit:find(d.bindU),self)
		d.bindU = 0
		d.bindUID = 0
	end
	if d.bindS~=0 then
		hApi.unbindObjectWithParent("effectS","bindUID",hClass.sceobj:find(d.bindS),self)
		d.bindS = 0
		d.bindUID = 0
	end
	if h._nBlink~=nil then
		local n = h._nBlink
		h._nBlink = nil
		xlGroundEffect_Remove(n)
		--print("清楚effect")
	end
	
	--清除拖尾效果
	if h._pStreak~=nil then
		local n = h._pStreak
		h._pStreak = nil
		--n:getParent():removeChild(n, true)
		n:removeFromParentAndCleanup(true)
		--print("清楚effect")
	end
	
	--清除导弹特效
	if h._nDaodan~=nil then
		local n = h._nDaodan
		h._nDaodan = nil
		n:del()
		--print("清除导弹特效")
	end
	
	--清除导弹尘土
	if h._nDaodanDust~=nil then
		local n = h._nDaodanDust
		h._nDaodanDust = nil
		n:del()
		--print("清除导弹尘土特效")
	end
	
	--清除导弹id
	if h._nDaodanID~=nil then
		h._nDaodanID = nil
	end
	
	--标记不是碰撞特效了
	h.collision = nil
	
	local w = hClass.world:find(d.bindW)
	if w then
		hApi.unbindObjectWithParent("effects","worldI",w,self)
	end
	h.removetime = 0
	hApi.ObjectReleaseSprite(h)
end

_he.playaction = function(self,tAction)
	if self.handle.s~=nil and type(tAction)=="table" then
		local array = CCArray:create()
		for i = 1,#tAction do
			local v = tAction[i]
			if v[1]=="delay" then
				array:addObject(CCDelayTime:create(v[2]))
			elseif v[1]=="fade" then
				if v[2]>0 then
					array:addObject(CCFadeIn:create(v[2]))
				elseif v[2]<0 then
					array:addObject(CCFadeOut:create(-1*v[2]))
				end
			elseif v[1]=="move" then
				--print("CCMoveBy")
				array:addObject(CCMoveBy:create(v[2],ccp(v[3],v[4])))
			elseif v[1]=="scale" then
				array:addObject(CCScaleBy:create(v[2],ccp(v[3],v[4])))
			end
		end
		self.handle.s:runAction(CCSequence:create(array))
	end
end

_he.settick = function(self,t)
	--print("_he.settick", self.data.id)
	self.handle.removetime = hGlobal.WORLD.LastWorldMap:gametime() + t
end

_he.settemptype = function(self,sType)
	if sType=="worldmap" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.EFFECT_WM
	elseif sType=="battlefield" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_BF
	elseif sType=="town" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_TN
	else
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.NORMAL
	end
end

_he.addextra = function(self,tabE)
	if tabE.RGB and self.handle.s then
		local r,g,b = unpack(tabE.RGB)
		self.handle.s:setColor(ccc3(r,g,b))
	end
	if tabE.extra and self.handle._n then
		local pNode = self.handle._n
		if self.data.type==hVar.EFFECT_TYPE.MISSILE and self.handle.s then
			pNode = self.handle.s
		end
		for i = 1,#tabE.extra do
			local v = tabE.extra[i]
			local tHandle = {s=CCSprite:create(),__manage="lua"}
			pNode:addChild(tHandle.s,i+(v.z or 0))
			hApi.setModel(tHandle,v.model)
			hApi.SpritePlayAnimation(tHandle,v.animation or "stand",self.data.playtime,1)
			if (v.x or 0)~=0 or (v.y or 0)~=0 then
				tHandle.s:setPosition(v.x or 0,v.y or 0)
			end
			if v.scale then
				tHandle.s:setScale(v.scale)
			end
			if v.RGB then
				local r,g,b = unpack(v.RGB)
				tHandle.s:setColor(ccc3(r,g,b))
			end
			if v.roll then
				tHandle.s:setRotation(v.roll)
			end
		end
	end
end

_he.addblink = function(self,tBlink,x,y,IsParement)
	local d = self.data
	local RGB = tBlink.RGB or __DefaultXLBlink.RGB
	local scale = tBlink.scale or __DefaultXLBlink.scale
	local dur = tBlink.dur or __DefaultXLBlink.dur
	local r,g,b = unpack(RGB)
	local x = x+(tBlink.x or __DefaultXLBlink.x)
	local y = y-(tBlink.y or __DefaultXLBlink.y)
	local IsShadow = (tBlink.light or __DefaultXLBlink.light)==1 and 1 or 0
	local imagePath = tBlink.image or __DefaultXLBlink.image
	local rot = tBlink.rot or __DefaultXLBlink.rot
	local pBlink
	if IsParement==1 then
		pBlink = xlAddGroundEffect(imagePath,-1,x,y,dur/1000,scale,r,g,b,IsShadow)
		local pNode = self.handle._n
		if tBlink.dummy==1 then
			pNode = self.handle.s
		end
		if pBlink and pNode then
			self.handle._nBlink = pBlink
			pBlink:getParent():removeChild(pBlink,false)
			pNode:addChild(pBlink)
			pBlink:setRotation(rot)
		end
	elseif IsParement==2 then
		pBlink = xlAddGroundEffect(imagePath,1,x,y,dur/1000,scale,r,g,b,IsShadow)
		pBlink:setRotation(rot)
		self.handle._nBlink = pBlink
	else
		pBlink = xlAddGroundEffect(imagePath,0,x,y,dur/1000,scale,r,g,b,IsShadow)
		pBlink:setRotation(rot)
	end
	if pBlink~=nil and type(tBlink.roll)=="number" then
		pBlink:setRotation(tBlink.roll)
	end
	return pBlink,dur
end

_he.addshader = function(self,shader,x,y,IsParement)
	local d = self.data
	local imgPath = shader.image
	local shaderName = shader.shaderName
	local w = shader.w
	local h = shader.h
	local paramTab = shader.paramTab
	local sprite2
	if imaPath == "" then
		sprite2 = CCSprite:create()
		sprite2:setContentSize(CCSizeMake(w,h))
	else
		sprite2 = CCSprite:create(imgPath,CCRectMake(0,0,w,h))
	end
	local program = hApi.getShader(shaderName)
	if paramTab then
		local tem
		for i = 1,#paramTab do
			tem =  program:glGetUniformLocation(paramTab[i][1])
			if #paramTab[i] == 2 then
				program:setUniformLocationWithFloats(tem,paramTab[i][2])
			elseif #paramTab[i] == 3 then
				program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3])
			elseif #paramTab[i] == 4 then
				program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3],paramTab[i][4])
			elseif #paramTab[i] == 5 then
				program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3],paramTab[i][4],paramTab[i][5])
			end
		end	
	end
	sprite2:setShaderProgram(program)
	self.handle._n:addChild(sprite2)
	sprite2:setPosition(ccp(x,y))
	return sprite2,program
end

_he.addgroundeff = function(self, tabE)
	--geyachao: 不和其它类型混淆
	self.handle.oTarget = nil --清除追踪的目标
	self.handle.oAction = nil --清除追踪的action
	self.handle.oAction_missle = nil --抛物线追踪的action
	self.handle.oAction_missle_toprocess_tag = nil --抛物线追踪的action回调待处理标记
	--self.handle._nBlink = nil --清除地面影子
	
	local d = self.data
	local w = hClass.world:find(d.bindW)
	
	if w and tabE then
		local model = tabE.model
		local blink = tabE.xlblink
		local scale = tabE.scale or 1
		local nDur = 1
		if blink~=nil then
			local s
			s,nDur = self:addblink(blink,d.x,d.y,0)
		end
		--创建地面特效
		if model~=nil then
			local heightEx = 0
			if tabE.type==hVar.EFFECT_TYPE.GROUND then
				heightEx = hVar.ObjectZ.GROUND
			elseif tabE.type==hVar.EFFECT_TYPE.OVERHEAD then
				heightEx = hVar.ObjectZ.OVERHEAD
			else
				heightEx = d.oy
			end
			local case = type(tabE.animation)
			local tAnimation = d.animation
			if tAnimation==0 and (case=="table" or case=="string") then
				tAnimation = tabE.animation
			end
			self:settemptype(w.data.type)
			hApi.CreateEffect("effectG",self.handle,w.handle.worldScene,model,scale*d.scale/100,d.x,d.y,d.height+heightEx,d.facing,tAnimation,d.playtime,tabE.alpha)
			self:addextra(tabE)
			if d.playtime>0 then
				local aTime = math.max(self.handle.animationtime,1)
				hApi.RemoveEffectInTime(self.handle,aTime*d.playtime)
			end
		else
			hApi.RemoveEffectInTime(self.handle,nDur)
		end
	end
end

_he.adduniteff = function(self, tabE)
	--print("随身特效")
	--if true then
	--	return
	--end
	--geyachao: 不和其它类型混淆
	self.handle.oTarget = nil --清除追踪的目标
	self.handle.oAction = nil --清除追踪的action
	self.handle.oAction_missle = nil --抛物线追踪的action
	self.handle.oAction_missle_toprocess_tag = nil --抛物线追踪的action回调待处理标记
	--self.handle._nBlink = nil --清除地面影子
	
	local d = self.data
	local w = hClass.world:find(d.bindW)
	local u = hClass.unit:find(d.bindU)
	if w and tabE and u then
		local model = tabE.model
		local blink = tabE.xlblink
		local scale = tabE.scale or 1
		local shader = tabE.shader
		local ex,ey = d.x,d.y
		if d.facingEx==1 and not(u.data.facing>=90 and u.data.facing<270) then
			ex = -1*ex
		end
		self:settemptype(w.data.type)
		hApi.bindObjectWithParent("effectU","bindUID",u,self)
		hApi.CreateEffectU(self,u,d.bindKey,model,scale*d.scale/100,ex,ey,d.height,d.facing,d.animation,d.playtime)
		self:addextra(tabE)
		if blink~=nil then
			self:addblink(blink,ex,ey,1)
		end
		if d.playtime<=0 then
		else
			local aTime = math.max(self.handle.animationtime,1)
			hApi.RemoveEffectInTime(self.handle,aTime*d.playtime)
		end
		if shader ~= nil then
			local s = self:addshader(shader,ex,ey,1)
			s:setScale(scale)
		end
	end
end

_he.addsceobjeff = function(self,tabE)
	--geyachao: 不和其它类型混淆
	self.handle.oTarget = nil --清除追踪的目标
	self.handle.oAction = nil --清除追踪的action
	self.handle.oAction_missle = nil --抛物线追踪的action
	self.handle.oAction_missle_toprocess_tag = nil --抛物线追踪的action回调待处理标记
	--self.handle._nBlink = nil --清除地面影子
	
	local d = self.data
	local w = hClass.world:find(d.bindW)
	local sce = hClass.sceobj:find(d.bindS)
	if w and tabE and sce then
		local model = tabE.model
		local blink = tabE.xlblink
		local scale = tabE.scale or 1
		local shader = tabE.shader
		local ex,ey = d.x,d.y
		self:settemptype(w.data.type)
		hApi.bindObjectWithParent("effectS","bindUID",sce,self)
		hApi.CreateEffectU(self,sce,d.bindKey,model,scale*d.scale/100,ex,ey,d.height,d.facing,d.animation,d.playtime)
		self:addextra(tabE)
		if blink~=nil then
			self:addblink(blink,ex,0,1)
		end
		if d.playtime<=0 then
		else
			local aTime = math.max(self.handle.animationtime,1)
			hApi.RemoveEffectInTime(self.handle,aTime*d.playtime)
		end
		if shader ~= nil then
			local s = self:addshader(shader,ex,ey,1)
			s:setScale(scale)
		end
	end
end

_he.addflyeff = function(self, tabE, eParam, oTarget, oAction, szType, collision, collParam) --geyachao: 添加参数: oTarget, oAction, szType, collision, collParam
	--print("   -> addflyeff oTarget=" .. tostring(oTarget))
	local d = self.data
	local w = hClass.world:find(d.bindW)
	if w and tabE and eParam then
		local model = tabE.model
		local blink = tabE.xlblink
		local scale = tabE.scale or 1
		local _,oLaunchUnit,launchX,launchY,flyAngle,flySpeed,rollSpeed,flyPercent = eParam[1],eParam[2],eParam[3],eParam[4],eParam[5],eParam[6],eParam[7],eParam[8]
		launchX,launchY,flyAngle,flySpeed,rollSpeed,flyPercent = launchX or 0,launchY or 0,flyAngle or 0,flySpeed or 200,rollSpeed or 0,flyPercent or 0
		local HitZ = 0 --解决船怪高点被射击
		if eParam[9] then
			HitZ = eParam[9]
		end
		local shootAngle = d.facing --发射的角度
		--if eParam[10] then
		--	shootAngle = eParam[10]
		--end
		--print("shootAngle="..shootAngle)
		--print("addflyeff", oLaunchUnit,launchX,launchY,flyAngle,flySpeed,rollSpeed,flyPercent)
		--geyachao: 飞行特效，从角色中心点发出
		--print("launchX, launchY", launchX, launchY)
		local ox, oy = hApi.calArrowLaunchXY(launchX, launchY, oLaunchUnit)
		if oLaunchUnit and (oLaunchUnit ~= 0) then
			local bx, by, bw, bh = oLaunchUnit:getbox() --包围盒
			local bcx = bx + bw / 2 --中心点x位置
			local bcy = by + bh / 2 --中心点y位置
			ox = ox + bcx
			oy = oy + bcy
		end
		d.ox, d.oy = ox, oy --geyachao: 特效发出点
		--print("d.ox, d.oy", d.ox, d.oy, "d.x, d.y", d.x, d.y)
		--炮火特效
		--local heightEx = d.oy + 1
		local heightEx = d.oy + 9999999 --geyachao: 飞行特效一直在最前端显示
		if oLaunchUnit and (oLaunchUnit ~= 0) then
		local tabU = hVar.tab_unit[oLaunchUnit.data.id]
			if tabU and tabU.shootZ then
				heightEx = heightEx + tabU.shootZ
			end
		end
		heightEx = heightEx + HitZ
		self:settemptype(w.data.type)
		--print("d.ox,d.oy", launchX,launchY, d.ox,d.oy)
		--print("shootAngle=", shootAngle)
		hApi.CreateEffect("effectA",self.handle,w.handle.worldScene,model,scale*d.scale/100,d.ox,d.oy,d.height+heightEx, shootAngle,d.animation,hVar.ZERO,tabE.alpha)
		self:addextra(tabE)
		
		self.handle.szType = szType --标记追踪的类型（直线型、抛物线型）
		self.handle.customData1 = nil --用户数据1
		self.handle.customData2 = nil --用户数据2
		self.handle.customData3 = nil --用户数据3
		--print("szType=", szType)
		self.handle.collision = collision --碰撞类型飞行特效的标记
		if (collision == 1) then
			self.handle.collision_uidList = {} --碰撞类型飞行特效碰撞过的单位列表
			self.handle.collision_angle = GetLineAngle(d.ox, d.oy, d.x,d.y) --碰撞类型飞行特效碰撞旋转的角度(角度制)
			--print("self.handle.collision_angle=", self.handle.collision_angle)
			self.handle.collision_isRotEff = collParam[1] --碰撞类型飞行特效碰撞是否旋转特效
			if (self.handle.collision_isRotEff == true) or (self.handle.collision_isRotEff == 1) then --旋转特效
				--local fangle = self.handle.collision_angle * math.pi / 180 --弧度制
				--fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				local cosX = hApi.Math.Cos(self.handle.collision_angle) --math.cos(fangle)
				local sinX = hApi.Math.Sin(self.handle.collision_angle) --math.sin(fangle)
				cosX = math.floor(cosX * 100) / 100  --保留2位有效数字，用于同步
				sinX = math.floor(sinX * 100) / 100  --保留2位有效数字，用于同步
				self.handle.collision_angle_cosX = cosX --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
				self.handle.collision_angle_sinX = sinX --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
			else
				self.handle.collision_angle_cosX = nil --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
				self.handle.collision_angle_sinX = nil --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
			end
			self.handle.collision_skillId = oAction.data.skillId  --碰撞类型飞行特效的技能id
			self.handle.collision_caster_unsafe = oAction.data.unit --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			
			self.handle.collision_caster_worldC = oAction.data.unit:getworldC()  --碰撞类型飞行特效，施法者的唯一id
			self.handle.collision_caster_side = oAction.data.unit:getowner():getforce()  --碰撞类型飞行特效，施法者的阵营
			self.handle.collision_caster_pos = oAction.data.unit:getowner():getpos()  --碰撞类型飞行特效，施法者的位置
			self.handle.collision_caster_typeId = oAction.data.unit.data.id  --碰撞类型飞行特效，施法者的类型id
			self.handle.collision_caster_targetType = collParam[2]  --碰撞类型飞行特效，有效目标类型
			self.handle.collision_caster_dmg = hApi.floor(collParam[3])  --碰撞类型飞行特效，施法者造成的伤害
			self.handle.collision_caster_dmgMode = collParam[4] --碰撞类型飞行特效，施法者造成的伤害类型
			self.handle.collision_caster_skillId = collParam[5] --碰撞类型飞行特效，施法者释放的技能id
			self.handle.collision_caster_skillLv = collParam[6] --碰撞类型飞行特效，施法者释放的技能等级
			self.handle.collision_fly_angle = collParam[7] --碰撞类型飞行特效，特效飞向的角度
			self.handle.collision_fly_begin_x = collParam[8] --碰撞类型飞行特效，特效起始发出的x坐标
			self.handle.collision_fly_begin_y = collParam[9] --碰撞类型飞行特效，特效起始发出的y坐标
			self.handle.collision_bBlockWallRemove = collParam[10] --碰撞类型飞行特效，特效碰到障碍是否消失
			self.handle.collision_blockWallEffectId = collParam[11] --碰撞类型飞行特效，特效碰到障碍消失播放的特效id
			self.handle.collision_bBlockUnitRemove = collParam[12] --碰撞类型飞行特效，特效碰到单位是否消失
			self.handle.collision_blockUnitEffectId = collParam[13] --碰撞类型飞行特效，特效碰到单位消失播放的特效id
			self.handle.collision_tansheWallCount = collParam[14] --碰撞类型飞行特效，特效碰到墙反弹的总次数
			self.handle.collision_tansheWallCountNow = collParam[15] --碰撞类型飞行特效，特效碰到墙反弹的当前次数
			self.handle.collision_flytime = collParam[16] --碰撞类型飞行特效，特效飞行时间（毫秒）
			self.handle.collision_flytimetick = collParam[17] --碰撞类型飞行特效，特效开始飞行的时间
			self.handle.collision_flySpeedV = collParam[18] --碰撞类型飞行特效，特效变速速度表
			self.handle.collision_blockWallSound = collParam[19] --碰撞类型飞行特效，特效碰到障碍的音效
			self.handle.collision_daodanFlyEffectId = collParam[20] --碰撞类型飞行特效，导弹正常状态的特效id
			self.handle.collision_daodanIsHideTail = collParam[21] --碰撞类型飞行特效，导弹是否隐藏飞升拖尾特效
			self.handle.collision_daodanBoomEffectId = collParam[22] --碰撞类型飞行特效，导弹爆炸特效id
			self.handle.collision_nFlyUnitOnly = collParam[23] --碰撞类型飞行特效，特效碰撞是否只检测飞行单位
			self.handle.collision_oActionTempValue = {} --碰撞类型飞行特效temp值表
			--if (oAction.data.skillId == 14017) then
			--	print("addflyeff: oAction=", tostring(oAction))
			--	print("碰撞类型飞行特效temp值表 collision_oActionTempValue = ", tostring(self.handle.collision_oActionTempValue))
			--	--print(debug.traceback())
			--end
			local tempValue = oAction.data.tempValue
			for k, v in pairs(tempValue) do
				self.handle.collision_oActionTempValue[k] = v --geyachao: 防止oAction已被删除，将里面的数据存下来
			end
			self.handle.collision_oActionTempValue.cast_target_type = oAction.data.cast_target_type
			self.handle.collision_oActionTempValue.cast_target_space_type = oAction.data.cast_target_space_type
			--if (oAction.data.skillId == 14017) then
			--	print("oAction.data.cast_target_type = ", oAction.data.cast_target_type)
			--	print("oAction.data.cast_target_space_type = ", oAction.data.cast_target_space_type)
			--end
			local dMin = oAction.data.dMin --技能物体中 LoadAttack 的伤害值min
			local dMax = oAction.data.dMax --技能物体中 LoadAttack 的伤害值max
			local _dMin = math.min(dMin, dMax)
			local _dMax = math.max(dMin, dMax)
			self.handle.collision_dMin = dMin --碰撞类型飞行特效最小伤害值（LoadAttack）
			self.handle.collision_dMax = dMax --碰撞类型飞行特效最大伤害值（LoadAttack）
			
			--print(self.handle.collision_skillId, self.handle.collision_caster_worldC, self.handle.collision_caster_side, self.handle.collision_caster_pos, self.handle.collision_caster_typeId, self.handle.collision_caster_targetType, self.handle.collision_caster_dmg, self.handle.collision_caster_dmgMode, self.handle.collision_caster_skillId, self.handle.collision_caster_skillLv)
		else
			--普通飞行特效、追踪飞行特效
			if collParam then
				self.handle.collision_flytime = collParam[16] --碰撞类型飞行特效，特效飞行时间（毫秒）
				self.handle.collision_flytimetick = collParam[17] --碰撞类型飞行特效，特效开始飞行的时间
				self.handle.collision_flySpeedV = collParam[18] --碰撞类型飞行特效，特效变速速度表
				self.handle.collision_daodanFlyEffectId = collParam[20] --碰撞类型飞行特效，导弹正常状态的特效id
				self.handle.collision_daodanIsHideTail = collParam[21] --碰撞类型飞行特效，导弹是否隐藏飞升拖尾特效
				self.handle.collision_daodanBoomEffectId = collParam[22] --碰撞类型飞行特效，导弹爆炸特效id
				self.handle.collision_nFlyUnitOnly = collParam[23] --碰撞类型飞行特效，特效碰撞是否只检测飞行单位
			end
		end
		
		--todo
		--第一个参数是间隐的时间，第二个参数是间隐片断的大小，第三个参数是贴图的宽高，第四个参数是颜色值RGB，第五个参数是贴图的路径或者贴图对象  
		--self.handle.streak = CCMotionStreak:create(0.8, 10, 10, ccc3(255,0,0), "data/image/effect/arrow_3.png")
		--self.handle.streak:setPosition(ccp(d.ox, d.oy))
		--self.handle._n:getParent():addChild(self.handle.streak)
		
		--geyachao
		--追踪目标、碰撞飞行特效、其他类
		if oTarget then --追踪目标
			self.handle.oTarget = oTarget --标记追踪的目标
			self.handle.oAction = oAction --标记追踪的action
			d.playtime = math.huge
			--[[
			if (szType == "line") then --直线型追踪飞行特效，特效存在的时间不确定
				d.playtime = math.huge
			elseif (szType == "parabola") then --抛物线型追踪飞行特效，特效存在的时间固定
				local target_x, target_y = hApi.chaGetPos(oTarget.handle) --目标的位置
				local speed = flySpeed --特效的速度
				local dx = target_x - d.ox --dx
				local dy = target_y - d.oy --dy
				local distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --距离，保留2位有效数字，用于同步
				local time = distance / speed --移动需要的总时间
				d.playtime = time
				d.playtime = math.huge
			end
			]]
			
			d.flySpeed = flySpeed
			d.ZHeight = rollSpeed
			
			hApi.RemoveEffectInTime(self.handle, d.playtime)
		elseif (collision == 1) then --碰撞飞行特效
			self.handle.oTarget = oTarget --标记追踪的目标
			
			--将oAction中需要的参数拷贝出来
			--self.handle.oAction = oAction --标记追踪的action
			--将oAction要用到的参数拷贝到一个新表里
			local action = {}
			action.data = {}
			action.data.skillId = oAction.data.skillId --碰撞类型飞行特效的技能id
			action.data.unit = oAction.data.unit --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			action.data.dMin = oAction.data.dMin --技能物体中 LoadAttack 的伤害值min
			action.data.dMax = oAction.data.dMax --技能物体中 LoadAttack 的伤害值max
			--action.data.tick = oAction.data.tick
			action.data.target = oAction.data.target
			action.data.target_worldC = oAction.data.target_worldC
			action.data.worldX = oAction.data.worldX
			action.data.worldY = oAction.data.worldY
			action.data.tempValue = {}
			local tempValue = oAction.data.tempValue
				for k, v in pairs(tempValue) do
				action.data.tempValue[k] = v --geyachao: 防止oAction已被删除，将里面的数据存下来
			end
			action.data.cast_target_type = oAction.data.cast_target_type
			action.data.cast_target_space_type = oAction.data.cast_target_space_type
			--拷贝
			self.handle.oAction = action --标记追踪的action
			
			d.playtime = math.huge
			
			d.flySpeed = flySpeed
			d.ZHeight = rollSpeed
			
			self.handle.finish_x = d.x
			self.handle.finish_y = d.y
			
			--如果有滚动，做滚动表现
			if (flyAngle >= 0) then
				if (rollSpeed ~= 0) then
					local moveTime, moveRange = hApi.calMoveTime(d.ox, d.oy, d.x, d.y, flySpeed)
					local t = moveTime / 1000
					if (t > 0) then
						local sign = 1
						if (d.ox > d.x) then
							sign = -1
						end
						t = t*3 --geyachao: 因为逻辑时间总是比实际的时间低，这里时间3倍，让滚动不停止
						self.handle.s:runAction(CCRotateBy:create(t, sign * 360 * t * rollSpeed))
					end
				end
			end
			
			--如果不旋转特效，设置角度为0
			--[[
			if (flyAngle == -1) then
				local rLaunch, rFly = hApi.calArrowFacingXY(d.ox, d.oy, d.x, d.y, flyAngle)
				self.handle.roll = 0
				print("self.handle.roll ", self.handle.roll)
				hApi.SpriteLoadFacing(self.handle)
			end
			]]
			--按直线运动
			--local moveTime, jumpA = hApi.SpriteMoveAsMissile(self.handle, d.ox, d.oy, d.x, d.y, flyAngle, flySpeed, rollSpeed)
			--print("SpriteMoveAsMissile Coll", d.ox,d.oy,d.x,d.y,flyAngle,flySpeed,rollSpeed, "moveTime=" .. moveTime)
			
			--print("碰撞飞行特效", self.handle.finish_x, self.handle.finish_y)
			hApi.RemoveEffectInTime(self.handle, d.playtime)
		else
			self.handle.oTarget = nil --清除追踪的目标
			self.handle.oAction = nil --清除追踪的action
			self.handle.oAction_missle = oAction
			self.handle.oAction_missle_toprocess_tag = 1 --抛物线追踪的action回调待处理标记
			--self.handle._nBlink = nil --清除地面影子
			
			--按直线运动
			local moveTime, jumpA = hApi.SpriteMoveAsMissile(self, d.ox, d.oy, d.x, d.y, flyAngle, flySpeed, rollSpeed, oAction)
			--local moveTime, jumpA = 2200, 1
			
			if flyPercent>0 and flyPercent<1 and moveTime>0 then
				d.playtime = hApi.getint(moveTime*flyPercent)
				hApi.RemoveEffectInTime(self.handle,d.playtime)
				--如果只飞一半，那么计算飞行最终地点
				d.vx = hApi.floor((d.x-d.ox)*flyPercent)
				d.vy = hApi.floor(-1*(d.y-d.oy)*flyPercent + jumpA*4*flyPercent*(1-flyPercent))
			else
				d.playtime = moveTime
				hApi.RemoveEffectInTime(self.handle, d.playtime)
				d.vx = hApi.floor((d.x-d.ox))
				d.vy = hApi.floor(-1*(d.y-d.oy))
			end
		end
		
		--创建xl方式的effect
		--可以和原有流程并行使用
		--目前只支持地面模式特效和箭矢特效
		if blink~=nil then
			local pBlink, nDur = self:addblink(blink,d.ox,d.oy,2) --geyachao: 这里改成了d.ox,d.oy（原来是d.x, d.y，有影响？）
			if pBlink~=nil then
				pBlink:setScaleX(2)
				pBlink:setScaleY(4)
				--print("xlGroundFollowToTarget", pBlink,d.ox,d.oy,d.x,d.y,d.playtime/1000)
				
				--geyachao
				--追踪目标
				if oTarget then
					--self.handle._nBlink = pBlink --标记地面影子
				else
					xlGroundFollowToTarget(pBlink,d.ox,d.oy,d.x,d.y, d.playtime/1000)
				end
			end
		end
	end
end

--------------------------------------------------------------
-- 特殊保存流程,只保存data中的这些数据
_he:sync("hook",function(index,v,rTab)			--保存object之前的检查函数
	if type(v)=="table" then
		local d = v.data
		local _p = {v.ID,v.__ID}
		for i = 1,#__DefaultSyncData do
			local key = __DefaultSyncData[i]
			_p[i+2] = d[key] or 0
		end
		local s = "\n	["..index.."]={_p="..eClass.API.NumberTable2String(_p)..","
		rTab[#rTab+1] = s.."},"
	else
		rTab[#rTab+1] = "\n	["..index.."]="..v..","
	end
	return 1
end)

----------------------------------------------
--特殊读取流程
local __GetV = function(t,k)
	local v = rawget(t,k)
	rawset(t,k,nil)
	return v
end
_he.__RecoverObjectFromSaveData = function(self)
	if rawget(self,"ID")~=nil then
		return
	end
	local _p = __GetV(self,"_p")
	local ID,__ID = _p[1],_p[2]
	local p = {}
	for i = 1,#__DefaultSyncData do
		local key = __DefaultSyncData[i]
		p[key] = _p[i+2]
	end
	self.ID = ID or 0
	self.__ID = __ID or -1
	self.data = hApi.ReadParam(__DefaultParam,p,{})
	self.handle = {removetime=0}
	local d = self.data
	
end

_he.__InitAfterLoaded = function(self)
	self:__RecoverObjectFromSaveData()
	local d = self.data
	local w = hClass.world:find(d.bindW)
	if w and w.data.type~="worldmap" then
		self.handle.__IsTemp = hVar.TEMP_HANDLE_TYPE.NORMAL
		return self:del()
	end
	local tabE = hVar.tab_effect[d.id]
	if d.type==hVar.EFFECT_TYPE.NORMAL then
		self:addgroundeff(tabE)
	elseif d.type==hVar.EFFECT_TYPE.UNIT then
		self:adduniteff(tabE)
	else
		--不知道是干什么的特效，被恢复了!
		xlLG("effect","[LUA ERROR]恢复了未知的特效:["..d.id.."]\n")
	end
end

--飞行特效action到目标点的回调事件
_he.OnFlyEffMoveToPoint_Ret = function(self, oAction)
	local handleTable = self.handle
	--print("OnFlyEffMoveToPoint_Ret", self.data.id, handleTable.oAction_missle_toprocess_tag)
	
	--在逻辑帧回调和动画回调两处，都会触发此回调，只处理一次
	if (handleTable.oAction_missle_toprocess_tag == 1) then --抛物线追踪的action回调待处理标记
		--清除标记
		handleTable.oAction_missle_toprocess_tag = nil
		
		if oAction then
			--都改为回调后继续后续流程
			oAction.data.tick = 16
			
			--回调技能
			local u = handleTable.collision_caster_unsafe --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			local u_worldC = handleTable.collision_caster_worldC --碰撞类型飞行特效，施法者的唯一id
			local callbackSkillId = handleTable.collision_caster_skillId --碰撞类型飞行特效，施法者释放的技能id
			local callbackSkillLv = handleTable.collision_caster_skillLv --碰撞类型飞行特效，施法者释放的技能等级
			local sprite_x = handleTable.collision_fly_begin_x --碰撞类型飞行特效，特效起始发出的x坐标
			local sprite_y = handleTable.collision_fly_begin_y --碰撞类型飞行特效，特效起始发出的y坐标
			--print("oAction=", oAction)
			if callbackSkillId and (callbackSkillId > 0) then
				--print("callbackSkillId=", callbackSkillId)
				--print("callbackSkillId=", callbackSkillId)
				if (u:getworldC() == u_worldC) and (u.data.IsDead ~= 1) and (u.attr.hp > 0) then --施法者没被复用，活着
					local t = u
					local tabS = hVar.tab_skill[callbackSkillId]
					local targetType = tabS.target and tabS.target[1]
					--print("targetType=", targetType)
					if (targetType == "ENEMY") then
						t = nil
					end
					
					--local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的坐标
					local w = u:getworld()
					local gridX, gridY = w:xy2grid(sprite_x, sprite_y)
					local tCastParam =
					{
						level = callbackSkillLv, --技能的等级
					}
					--print("CastSkill=", u.data.name)
					hApi.CastSkill(u, callbackSkillId, 0, nil, t, gridX, gridY, tCastParam)
				end
			end
		end
	end
end

--更新追踪目标类、碰撞类飞行特效的位置
--geyachao
_he.UpdateFollowEff = function(self, dt)
	local handleTable = self.handle
	local szType = handleTable.szType --追踪类飞行特效的类型（直线型、抛物线型）
	
	if (szType == "line") then --直线型
		self:UpdateFollowEff_Line(dt)
	elseif (szType == "parabola") then --抛物线型
		self:UpdateFollowEff_Parabola(dt)
	elseif (szType == "tracing") then --追踪导弹型
		self:UpdateFollowEff_Tracing(dt)
	end
end

--更新抛物线拖尾
_he.UpdateMissleStreakEff = function(self, dt)
	local handleTable = self.handle
	local sprite = handleTable._n
	local spriteE = handleTable.s
	
	local eff_xn, eff_yn = sprite:getPosition() --特效的位置
	local eff_x, eff_y = spriteE:getPosition() --特效的位置
	--local eff_x, eff_y = handleTable.x, handleTable.y --特效的位置
	--local screen_eff_y = -eff_y
	--local screen_eff_y = eff_y
	--print("UpdateMissleStreakEff", eff_x , eff_xn, eff_y , eff_yn)
	
	if handleTable._pStreak then
		--print("handleTable._pStreak")
		handleTable._pStreak:setPosition(eff_x + eff_xn, eff_y + eff_yn)
	end
end

--更新碰撞类飞行特效
--geyachao
local _A1, _A2, _A3, _A4, _B1, _B2, _B3, _B4 = {}, {}, {}, {}, {}, {}, {}, {}
_he.UpdateCollisionEff = function(self, dt)
	local handleTable = self.handle
	local collision = handleTable.collision --碰撞类型飞行特效的标记
	
	if (collision == 1) then
		--[[
		local node_x, node_y = handleTable._n:getPosition()
		node_y = -node_y
		local eff_x, eff_y = handleTable.s:getPosition()
		eff_y = -eff_y
		local sprite_x = node_x + eff_x --特效碰撞的x坐标
		local sprite_y = node_y + eff_y --特效碰撞的y坐标
		]]
		local world = hGlobal.WORLD.LastWorldMap
		local currenttime = world:gametime()
		local sprite_x, sprite_y = handleTable.x, handleTable.y --特效的位置
		local tabE = hVar.tab_effect[self.data.id]
		local box = tabE.box --碰撞盒子
		local LOOPNUM = 1
		if (type(box[1]) == "table") then
			LOOPNUM = #box
		end
		
		for loopNum = 1, LOOPNUM, 1 do
			if (handleTable.removetime > currenttime) then --未被删除
				local bx, by, bw, bh = box[1], box[2], box[3], box[4] --碰撞的x、 y、宽、高
				if (type(box[1]) == "table") then
					bx, by, bw, bh = box[loopNum][1], box[loopNum][2], box[loopNum][3], box[loopNum][4] --碰撞的x、 y、宽、高
				end
				
				local isRotEff = self.handle.collision_isRotEff --碰撞类型是否旋转特效
				local angle = 0 --碰撞类型飞行特效碰撞旋转的角度
				local cosX = 1 --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
				local sinX = 0 --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
				if (isRotEff == true) or (isRotEff == 1) then
					angle = handleTable.collision_angle --碰撞类型飞行特效碰撞旋转的角度
					cosX = handleTable.collision_angle_cosX --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
					sinX = handleTable.collision_angle_sinX --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
				end
				--print("angle=" .. angle, "isRotEff=" .. isRotEff)
				--local fangle = angle * math.pi / 180 --弧度制
				--fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				local coll_x = sprite_x + (bx)* cosX + (-by) * sinX --特效碰撞的中心点x位置
				local coll_y = sprite_y + (bx)* sinX + (by) * cosX --特效碰撞的中心点y位置
				coll_x = math.floor(coll_x * 100) / 100  --保留2位有效数字，用于同步
				coll_y = math.floor(coll_y * 100) / 100  --保留2位有效数字，用于同步
				local dx = bw / 2
				local dy = bh / 2
				local cz = math.sqrt(dx * dx + dy * dy)
				cz = math.floor(cz * 100) / 100  --保留2位有效数字，用于同步
				local lu_x, lu_y = coll_x - bw / 2, coll_y - bh / 2 --左上角坐标
				local ru_x, ru_y = coll_x + bw / 2, coll_y - bh / 2 --右上角坐标
				local ld_x, ld_y = coll_x - bw / 2, coll_y + bh / 2 --左下角坐标
				local rd_x, rd_y = coll_x + bw / 2, coll_y + bh / 2 --右下角坐标
				--对任意点(x,y)，绕一个坐标点(rx0,ry0)逆时针旋转a角度后的新的坐标设为(x0, y0)，有公式：
				--x0= (x - rx0)*cos(a) - (y - ry0)*sin(a) + rx0
				--y0= (x - rx0)*sin(a) + (y - ry0)*cos(a) + ry0
				local lu_x_new = (lu_x - coll_x) * cosX - (lu_y - coll_y) * sinX + coll_x
				local lu_y_new = (lu_x - coll_x) * sinX + (lu_y - coll_y) * cosX + coll_y
				local ru_x_new = (ru_x - coll_x) * cosX - (ru_y - coll_y) * sinX + coll_x
				local ru_y_new = (ru_x - coll_x) * sinX + (ru_y - coll_y) * cosX + coll_y
				local ld_x_new = (ld_x - coll_x) * cosX - (ld_y - coll_y) * sinX + coll_x
				local ld_y_new = (ld_x - coll_x) * sinX + (ld_y - coll_y) * cosX + coll_y
				local rd_x_new = (rd_x - coll_x) * cosX - (rd_y - coll_y) * sinX + coll_x
				local rd_y_new = (rd_x - coll_x) * sinX + (rd_y - coll_y) * cosX + coll_y
				lu_x_new = math.floor(lu_x_new * 100) / 100  --保留2位有效数字，用于同步
				lu_y_new = math.floor(lu_y_new * 100) / 100  --保留2位有效数字，用于同步
				ru_x_new = math.floor(ru_x_new * 100) / 100  --保留2位有效数字，用于同步
				ru_y_new = math.floor(ru_y_new * 100) / 100  --保留2位有效数字，用于同步
				ld_x_new = math.floor(ld_x_new * 100) / 100  --保留2位有效数字，用于同步
				ld_y_new = math.floor(ld_y_new * 100) / 100  --保留2位有效数字，用于同步
				rd_x_new = math.floor(rd_x_new * 100) / 100  --保留2位有效数字，用于同步
				rd_y_new = math.floor(rd_y_new * 100) / 100  --保留2位有效数字，用于同步
				--local csx, csy = hApi.world2view(coll_x, coll_y) --碰撞中心点的屏幕坐标
				
				local skillId = self.handle.collision_skillId --碰撞类型飞行特效的技能id
				local caster_unsafe = self.handle.collision_caster_unsafe --碰撞类型飞行特效，施法者（可能已死亡或被复用）
				local caster_worldC = self.handle.collision_caster_worldC --碰撞类型飞行特效，施法者的唯一id
				local caster_side = self.handle.collision_caster_side --碰撞类型飞行特效，施法者的阵营
				local caster_pos = self.handle.collision_caster_pos --碰撞类型飞行特效，施法者的位置
				local caster_typeId = self.handle.collision_caster_typeId --碰撞类型飞行特效，施法者的类型id
				--local isRotEff = self.handle.collision_isRotEff --碰撞类型是否旋转特效
				local targetType = self.handle.collision_caster_targetType --碰撞类型飞行特效，有效目标类型
				local caster_dmg = self.handle.collision_caster_dmg --碰撞类型飞行特效，施法者造成的伤害
				local caster_dmgMode = self.handle.collision_caster_dmgMode --碰撞类型飞行特效，施法者造成的伤害类型
				local caster_skillId = self.handle.collision_caster_skillId --碰撞类型飞行特效，施法者释放的技能id
				local caster_skillLv = self.handle.collision_caster_skillLv --碰撞类型飞行特效，施法者释放的技能等级
				local fly_angle = self.handle.collision_fly_angle --碰撞类型飞行特效，特效飞向的角度
				local fly_begin_x = self.handle.collision_fly_begin_x --碰撞类型飞行特效，特效起始发出的x坐标
				local fly_begin_y = self.handle.collision_fly_begin_y --碰撞类型飞行特效，特效起始发出的y坐标
				local bBlockWallRemove = self.handle.collision_bBlockWallRemove --碰撞类型飞行特效，特效碰到障碍是否消失
				local blockWallEffectId = self.handle.collision_blockWallEffectId --碰撞类型飞行特效，特效碰到障碍消失播放的特效id
				local bBlockUnitRemove = self.handle.collision_bBlockUnitRemove --碰撞类型飞行特效，特效碰到单位是否消失
				local blockUnitEffectId = self.handle.collision_blockUnitEffectId --碰撞类型飞行特效，特效碰到单位消失播放的特效id
				local tansheWallCount = self.handle.collision_tansheWallCount --碰撞类型飞行特效，特效碰到墙反弹的次数
				local tansheWallCountNow = self.handle.collision_tansheWallCountNow --碰撞类型飞行特效，特效碰到墙反弹的当前次数
				local flytime = self.handle.collision_flytime --碰撞类型飞行特效，特效飞行时间（毫秒）
				local flytimetick = self.handle.collision_flytimetick --碰撞类型飞行特效，特效开始飞行的时间
				local flySpeedV = self.handle.collision_flySpeedV  --碰撞类型飞行特效，特效变速速度表
				local blockWallSound = self.handle.collision_blockWallSound --碰撞类型飞行特效，特效碰到障碍的音效
				local daodanFlyEffectId = self.handle.collision_daodanFlyEffectId --碰撞类型飞行特效，导弹正常状态的特效id
				local daodanIsHideTail = self.handle.collision_daodanIsHideTail --碰撞类型飞行特效，导弹是否隐藏飞升拖尾特效
				local daodanBoomEffectId = self.handle.collision_daodanBoomEffectId --碰撞类型飞行特效，导弹爆炸特效id
				local nFlyUnitOnly = self.handle.collision_nFlyUnitOnly or 0 --碰撞类型飞行特效，特效碰撞是否只检测飞行单位
				local oAction_copy = self.handle.oAction --技能物体(拷贝表)
				local collision_oActionTempValue = self.handle.collision_oActionTempValue --碰撞类型飞行特效temp值表
				local _dMin = self.handle.collision_dMin --碰撞类型飞行特效最小伤害值（LoadAttack）
				local _dMax = self.handle.collision_dMax --碰撞类型飞行特效最大伤害值（LoadAttack）
				
				--local tabS = hVar.tab_skill[skillId] --技能表
				--local cast_target_type = tabS.cast_target_type --有效的目标列表
				local cast_target_type = collision_oActionTempValue.cast_target_type --有效的目标列表
				local cast_target_space_type = collision_oActionTempValue.cast_target_space_type --技能可生效的目标的空间类型
				
				--print("nFlyUnitOnly=", nFlyUnitOnly)
				--if (skillId == 14017) then
				--print("cast_target_type=", cast_target_type, "cast_target_space_type=", cast_target_space_type, "id=", self.data.id, "skillId=", skillId, tostring(collision_oActionTempValue))
				--end
				--if (caster_side == 1) then
				--	print("Logic:", self.data.id, angle,bx, by, bw, bh)
				--end
				
				--geyachao: 检测碰撞特效是否和角色相交
				--local world = hGlobal.WORLD.LastWorldMap
				
				--调用的搜敌函数(用于优化)
				local enumunitAreaFunc = nil
				if (targetType == "ALL") then --全部
					enumunitAreaFunc = world.enumunitArea
				elseif (targetType == "SELF") then --自己
					enumunitAreaFunc = world.enumunitAreaAlly
				elseif (targetType == "OTHER") then --非自己
					enumunitAreaFunc = world.enumunitArea
				elseif (targetType == "ALLY_OTHER") or (targetType == "OTHER_ALLY") then --非自己
					enumunitAreaFunc = world.enumunitArea
				elseif (targetType == "ENEMY") then --敌人
					enumunitAreaFunc = world.enumunitAreaEnemy
				elseif (targetType == "ALLY") then --友方
					enumunitAreaFunc = world.enumunitAreaAlly
				elseif (type(targetType) == "number") then --指定id的角色
					enumunitAreaFunc = world.enumunitArea
				else
					--不合法的参数
				end
				
				--geyachao: 检测碰撞特效是否和角色相交
				--world:enumunit(function(eu)
				--world:enumunitArea(coll_x, coll_y, 300, function(eu)
				enumunitAreaFunc(world, caster_side, coll_x, coll_y, cz * 2 + hVar.AREA_EDGE, function(eu)
					local subType = eu.data.type --角色子类型
					--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
					--if (eu ~= world.data.tdMapInfo.godUnit) then --不是上帝
						--不是替代物、出生点、路点、建筑
						--if (eu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (eu.data.type ~= hVar.UNIT_TYPE.PLAYER_INFO) and (eu.data.type ~= hVar.UNIT_TYPE.WAY_POINT) and (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eu.data.type ~= hVar.UNIT_TYPE.NPC) and (eu.data.type ~= hVar.UNIT_TYPE.NPC_TALK) then
						if cast_target_type[eu.data.type] then
							local eworldC = eu:getworldC() --角色唯一id
							if (eworldC > 0) then --有效的目标
								if (eu.attr.hp > 0) and (eu.data.IsDead ~= 1) then --目标活着
									if (eu.attr.suffer_touming_stack == 0) then --单位不是透明
										local target_space_type = eu:GetSpaceType() --目标的空间类型
										if ((target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) and (nFlyUnitOnly == 0)) or (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
											--不重复检测同一个单位的碰撞
											if (not handleTable.collision_uidList[eworldC]) then
												local hero_x, hero_y = hApi.chaGetPos(eu.handle) --单位的坐标
												hero_x = math.floor(hero_x * 100) / 100 --保留2位有效数字，用于同步
												hero_y = math.floor(hero_y * 100) / 100 --保留2位有效数字，用于同步
												local hero_bx, hero_by, hero_bw, hero_bh = eu:getbox() --单位的包围盒
												local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --单位的中心点x位置
												local hero_center_y = hero_y + (hero_by + hero_bh / 2) --单位中心点y位置
												local eu_left_x = hero_center_x - hero_bw / 2 --左侧x
												local eu_right_x = hero_center_x + hero_bw / 2 --右侧x
												local eu_left_y = hero_center_y + hero_bh / 2 --上侧y
												local eu_right_y = hero_center_y - hero_bh / 2 --下侧y
												
												--检测单位和特效是否相交
												_A1.X = lu_x_new
												_A1.Y = lu_y_new
												_A2.X = ru_x_new
												_A2.Y = ru_y_new
												_A3.X = rd_x_new
												_A3.Y = rd_y_new
												_A4.X = ld_x_new
												_A4.Y = ld_y_new
												
												_B1.X = eu_left_x
												_B1.Y = eu_left_y
												_B2.X = eu_right_x
												_B2.Y = eu_left_y
												_B3.X = eu_right_x
												_B3.Y = eu_right_y
												_B4.X = eu_left_x
												_B4.Y = eu_right_y
												
												--if hApi.RectIntersectRect({X = lu_x_new, Y = lu_y_new}, {X = ru_x_new, Y = ru_y_new}, {X = rd_x_new, Y = rd_y_new}, {X = ld_x_new, Y = ld_y_new}, {X = eu_left_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_right_y}, {X = eu_left_x, Y = eu_right_y}) then
												if hApi.RectIntersectRect(_A1, _A2, _A3, _A4, _B1, _B2, _B3, _B4) then
													--标记碰撞了该单位
													handleTable.collision_uidList[eworldC] = true
													
													local targetSide = 0 --目标的阵营
													local oTargetPlayer = eu:getowner() --目标的玩家对象
													if oTargetPlayer then
														targetSide = oTargetPlayer:getforce() --目标的阵营
													end
													
													--检测目标的阵营是否在可选范围内
													local targetEnabled = false --目标是否有效
													if (targetType == "ALL") then --全部
														targetEnabled = true
													elseif (targetType == "SELF") then --自己
														if (caster_worldC == eworldC) then
															targetEnabled = true
														end
													elseif (targetType == "OTHER") then --非自己
														if (caster_worldC ~= eworldC) then
															targetEnabled = true
														end
													elseif (targetType == "ALLY_OTHER") or (targetType == "OTHER_ALLY") then --友方非自己
														if (caster_side == targetSide) and (caster_worldC ~= eworldC) then
															targetEnabled = true
														end
													elseif (targetType == "ENEMY") then --敌人
														if (caster_side ~= targetSide) then
															targetEnabled = true
														end
													elseif (targetType == "ALLY") then --友方
														if (caster_side == targetSide) then
															targetEnabled = true
														end
													elseif (type(targetType) == "number") then --指定id的角色
														if (eu and (eu.data.id == targetType)) then
															targetEnabled = true
														end
													else
														--不合法的参数
														_DEBUG_MSG("effect.UpdateCollisionEff(), targetType = " .. tostring(targetType) .. " 非法！")
													end
													
													--检测目标的空间类型是否有效
													if (cast_target_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果技能可生效目标的空间的类型不是全部类型都可以的话，再进一步检测
														local target_space_type = eu:GetSpaceType() --目标的空间类型
														
														--技能只能生效地面单位，而目标是空中单位，那么直接返回
														if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
															targetEnabled = false
														end
														
														--技能只能生效空中单位，而目标是地面单位，那么直接返回
														if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
															targetEnabled = false
														end
													end
													
													--有效的目标
													if targetEnabled then
														--造成伤害
														--计算最终的伤害值
														--[[
														local dMin = oAction.data.dMin --技能物体中 LoadAttack 的伤害值min
														local dMax = oAction.data.dMax --技能物体中 LoadAttack 的伤害值max
														local _dMin = math.min(dMin, dMax)
														local _dMax = math.max(dMin, dMax)
														]]
														
														--有效的施法者，传入攻击者
														local oAttacker = nil
														if (caster_unsafe:getworldC() == caster_worldC) and (caster_unsafe.data.IsDead ~= 1) and (caster_unsafe.attr.hp > 0) then --施法者没被复用，活着
															oAttacker = caster_unsafe
														end
														
														--如果施法者还活着，计算闪避、暴击、物防、法防等
														if oAttacker then
															local nPower = 100
															local dmgSumMin, dmgSumMax = oAttacker:calculate("CombatDamage", eu, caster_dmg + _dMin, caster_dmg + _dMax, nPower, skillId, caster_dmgMode, 0)
															local dmgSum = world:random(dmgSumMin, dmgSumMax)
															--print(dmgSum)
															if (dmgSum > 0) then
																--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb)
																hGlobal.event:call("Event_UnitDamaged", eu, skillId, caster_dmgMode, dmgSum, 0, oAttacker, nil, caster_side, caster_pos)
															end
														else --施法者已不存在，改为由施法者的上帝对目标造成伤害，仍然会计算物防、法防等
															local oAttackerGod = world:GetPlayer(caster_pos):getgod()
															if oAttackerGod then
																--local loadAtkDmg = world:random(_dMin, _dMax)
																--local dmgSum = caster_dmg + loadAtkDmg
																local nPower = 100
																local dmgSumMin, dmgSumMax = oAttackerGod:calculate("CombatDamage", eu, caster_dmg + _dMin, caster_dmg + _dMax, nPower, skillId, caster_dmgMode, 0)
																local dmgSum = world:random(dmgSumMin, dmgSumMax)
																--print(dmgSum)
																if (dmgSum > 0) then
																	--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
																	hGlobal.event:call("Event_UnitDamaged", eu, skillId, caster_dmgMode, dmgSum, 0, oAttackerGod, nil, caster_side, caster_pos)
																end
															else
																--上帝都死了。。。。
																local nPower = 100
																local dmgSumMin, dmgSumMax = eu:calculate("CombatDamage", eu, caster_dmg + _dMin, caster_dmg + _dMax, nPower, skillId, caster_dmgMode, 0)
																local dmgSum = world:random(dmgSumMin, dmgSumMax)
																if (dmgSum > 0) then
																	--(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
																	hGlobal.event:call("Event_UnitDamaged", eu, skillId, caster_dmgMode, dmgSum, 0, nil, nil, caster_side, caster_pos)
																end
															end
														end
														
														--对目标释放技能
														if (caster_skillId ~= 0) then
															--有效的施法者
															if (caster_unsafe:getworldC() == caster_worldC) and (caster_unsafe.data.IsDead ~= 1) and (caster_unsafe.attr.hp > 0) then --施法者没被复用，活着
																local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的坐标
																local gridX, gridY = world:xy2grid(targetX, targetY)
																local tCastParam =
																{
																	level = caster_skillLv, --技能的等级
																}
																
																hApi.CastSkill(caster_unsafe, caster_skillId, 0, nil, eu, gridX, gridY, tCastParam)
															end
														end
														
														--飞行特效碰撞回调函数
														if OnFlyeff_Collision_Unit_Event then
															--安全执行
															hpcall(OnFlyeff_Collision_Unit_Event, self.data.id, skillId, coll_x, coll_y, fly_angle, fly_begin_x, fly_begin_y, caster_unsafe, caster_worldC, caster_side, caster_pos, caster_typeId, eu, oAction, collision_oActionTempValue)
															--OnFlyeff_Collision_Unit_Event(self.data.id, skillId, coll_x, coll_y, fly_angle, fly_begin_x, fly_begin_y, caster_unsafe, caster_worldC, caster_side, caster_pos, caster_typeId, eu, oAction, collision_oActionTempValue)
														end
														
														--检测特效是否碰到障碍消失（撞到单位）
														if bBlockUnitRemove then
															--标记特效待删除
															handleTable.removetime = world:gametime()
															
															--播放特效
															if (eu.data.id == 11009) then --箱子
																if blockUnitEffectId and (blockUnitEffectId ~= 0) then
																	local ex, ey = hApi.chaGetPos(eu.handle) --攻击者的坐标
																	local ebx, eby, ebw, ebh = eu:getbox() --攻击者的包围盒
																	local ecenter_x = ex + (ebx + ebw / 2) --攻击者的中心点x位置
																	local ecenter_y = ey + (eby + ebh / 2) --攻击者的中心点y位置
																	local eff = world:addeffect(blockUnitEffectId, 1.0 ,nil, ecenter_x, ecenter_y) --56
																	
																	--重置z值
																	--if eff then
																	--	eff.handle._n:getParent():reorderChild(eff.handle._n, 1000000)
																	--end
																end
															end
															
															if (eu.data.id ~= 11009) then --不是箱子
																if blockUnitEffectId and (blockUnitEffectId ~= 0) then
																	local eff = world:addeffect(blockUnitEffectId, 1.0 ,nil, coll_x, coll_y) --56
																	
																	--重置z值
																	--if eff then
																	--	eff.handle._n:getParent():reorderChild(eff.handle._n, 1000000)
																	--end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					--end
				end)
				
				--检测特效是否碰到障碍消失（撞到墙）
				if bBlockWallRemove then
					local result = xlScene_IsGridBlock(g_world, coll_x / 24, coll_y / 24) --某个坐标是否是障碍
					local result_lu = xlScene_IsGridBlock(g_world, lu_x_new / 24, lu_y_new / 24) --左上角坐标是否是障碍
					local result_ru = xlScene_IsGridBlock(g_world, ru_x_new / 24, ru_y_new / 24) --左下角坐标是否是障碍
					local result_ld = xlScene_IsGridBlock(g_world, ld_x_new / 24, ld_y_new / 24) --右上角坐标是否是障碍
					local result_rd = xlScene_IsGridBlock(g_world, rd_x_new / 24, rd_y_new / 24) --右下角坐标是否是障碍
					
					--排除矮墙
					local key = tostring(math.floor(coll_x / 24)) .. "_" .. tostring(math.floor(coll_y / 24))
					if world.data.box_dynamic_points[key] then
						result = 0
					end
					
					local key_lu = tostring(math.floor(lu_x_new / 24)) .. "_" .. tostring(math.floor(lu_y_new / 24))
					if world.data.box_dynamic_points[key_lu] then
						result_lu = 0
					end
					
					local key_ru = tostring(math.floor(ru_x_new / 24)) .. "_" .. tostring(math.floor(ru_y_new / 24))
					if world.data.box_dynamic_points[key_ru] then
						result_ru = 0
					end
					
					local key_ld = tostring(math.floor(ld_x_new / 24)) .. "_" .. tostring(math.floor(ld_y_new / 24))
					if world.data.box_dynamic_points[key_ld] then
						result_ld = 0
					end
					
					local key_rd = tostring(math.floor(rd_x_new / 24)) .. "_" .. tostring(math.floor(rd_y_new / 24))
					if world.data.box_dynamic_points[key_rd] then
						result_rd = 0
					end
					
					--local result = 0
					--撞墙了
					if (result == 1) or (result_lu == 1) or (result_ru == 1) or (result_ld == 1) or (result_rd == 1) then
						--print("撞墙了", result, result_lu, result_ru, result_ld, result_rd)
						--撞墙反弹次数已到最大次数
						if (tansheWallCountNow >= tansheWallCount) then
							--标记特效待删除
							handleTable.removetime = currenttime
							
							--播放特效
							if blockWallEffectId and (blockWallEffectId ~= 0) then
								world:addeffect(blockWallEffectId, 1.0 ,nil, coll_x, coll_y) --56
							end
							
							--播放音效
							if blockWallSound and (blockWallSound ~= 0) then
								hApi.PlaySound(blockWallSound)
							end
						else
							--撞墙反弹
							--修正反弹的坐标，在检测碰到时可能已经进入障碍有一段距离了
							--取检测障碍的点
							local check_x = 0
							local check_y = 0
							
							--[[
							if (fly_angle <= 45) or (fly_angle >= 315) then -- -45(315)~45度，取右侧边中点
								check_x = (ru_x_new + rd_x_new) / 2
								check_y = (ru_y_new + rd_y_new) / 2
							elseif (fly_angle > 45) and (fly_angle <= 135) then -- 45~135度，取上侧边中点
								check_x = (lu_x_new + ru_x_new) / 2
								check_y = (lu_y_new + ru_y_new) / 2
							elseif (fly_angle > 135) and (fly_angle <= 225) then -- 135~225度，取左侧边中点
								check_x = (lu_x_new + ld_x_new) / 2
								check_y = (lu_y_new + ld_y_new) / 2
							elseif (fly_angle > 225) and (fly_angle <= 315) then -- 225~315度，取下侧边中点
								check_x = (ld_x_new + rd_x_new) / 2
								check_y = (ld_y_new + rd_y_new) / 2
							end
							]]
							check_x = coll_x
							check_y = coll_y
							
							local block_x = check_x --应该的反弹的障碍点x
							local block_y = check_y --应该的反弹的障碍点y
							--[[
							local left_distance = 0
							local STEP = 12
							local fly_fangle = fly_angle * math.pi / 180 --弧度制
							fly_fangle = math.floor(fly_fangle * 100) / 100  --保留2位有效数字，用于同步
							
							while (true) do
								--每次递增距离
								left_distance = left_distance + STEP
								
								block_x = check_x - left_distance * math.cos(fly_fangle) --尝试到达的x坐标
								block_y = check_y - left_distance * math.sin(fly_fangle) --尝试到达的y坐标
								block_x = math.floor(block_x * 100) / 100  --保留2位有效数字，用于同步
								block_y = math.floor(block_y * 100) / 100  --保留2位有效数字，用于同步
								
								--print(fly_angle, block_x, block_y)
								--不非法的坐标
								if (check_x > 0) and (check_y > 0) and (block_x > 0) and (block_y > 0) then
									local result = xlScene_IsGridBlock(g_world, block_x / 24, block_y / 24) --某个坐标是否是障碍
									if (result == 0) then --找到非障碍点了
										break
									end
								end
							end
							]]
							
							--因为此点已经在障碍里，不可用，采用回朔法，取前一帧的坐标
							local flySpeed = self.data.flySpeed
							local distance_previous = flySpeed * dt / 1000 --单位: 毫秒
							--local fly_fangle = fly_angle * math.pi / 180 --弧度制
							--fly_fangle = math.floor(fly_fangle * 100) / 100  --保留2位有效数字，用于同步
							--local tdx_previous = distance_previous * math.cos(fly_fangle) --本地移动的x距离
							--local tdy_previous = distance_previous * math.sin(fly_fangle) --本地移动的y距离
							local tdx_previous = distance_previous * hApi.Math.Cos(fly_angle) --本地移动的x距离
							local tdy_previous = distance_previous * hApi.Math.Sin(fly_angle) --本地移动的y距离
							tdx_previous = math.floor(tdx_previous * 100) / 100  --保留2位有效数字，用于同步
							tdy_previous = math.floor(tdy_previous * 100) / 100  --保留2位有效数字，用于同步
							local TRACECOUNT = 5
							for tc = 1, TRACECOUNT, 1 do
								block_x = block_x - tdx_previous
								block_y = block_y + tdy_previous
								local result = xlScene_IsGridBlock(g_world, block_x / 24, block_y / 24) --某个坐标是否是障碍
								if (result == 0) then
									break
								end
							end
							
							--print("fly_angle=", fly_angle)
							--print("coll_x:", check_x, check_y)
							--print("block_x:", block_x, block_y)
							--计算反射角度(水平)
							local ret_angle_hor = 360 - fly_angle
							--local ret_fangle_hor = ret_angle_hor * math.pi / 180 --弧度制
							--ret_fangle_hor = math.floor(ret_fangle_hor * 100) / 100  --保留2位有效数字，用于同步
							
							--计算反射角度(垂直)
							local ret_angle_vet = 180 - fly_angle
							if (ret_angle_vet < 0) then
								ret_angle_vet = 360 + ret_angle_vet
							end
							--local ret_fangle_vet = ret_angle_vet * math.pi / 180 --弧度制
							--ret_fangle_vet = math.floor(ret_fangle_vet * 100) / 100  --保留2位有效数字，用于同步
							
							--计算反射(水平)方向障碍的数量
							local ret_hor_bnum = 0
							for step = 0, 60, 12 do
								--local bx = block_x + step * math.cos(ret_fangle_hor)
								--local by = block_y - step * math.sin(ret_fangle_hor)
								local bx = block_x + step * hApi.Math.Cos(ret_angle_hor)
								local by = block_y - step * hApi.Math.Sin(ret_angle_hor)
								bx = math.floor(bx * 100) / 100  --保留2位有效数字，用于同步
								by = math.floor(by * 100) / 100  --保留2位有效数字，用于同步
								local result = xlScene_IsGridBlock(g_world, bx / 24, by / 24) --某个坐标是否是障碍
								if (result == 1) then --障碍点
									ret_hor_bnum = ret_hor_bnum + 1
								end
							end
							
							--计算反射(垂直)方向障碍的数量
							local ret_vet_bnum = 0
							for step = 0, 60, 12 do
								--local bx = block_x + step * math.cos(ret_fangle_vet)
								--local by = block_y - step * math.sin(ret_fangle_vet)
								local bx = block_x + step * hApi.Math.Cos(ret_angle_vet)
								local by = block_y - step * hApi.Math.Sin(ret_angle_vet)
								bx = math.floor(bx * 100) / 100  --保留2位有效数字，用于同步
								by = math.floor(by * 100) / 100  --保留2位有效数字，用于同步
								local result = xlScene_IsGridBlock(g_world, bx / 24, by / 24) --某个坐标是否是障碍
								if (result == 1) then --障碍点
									ret_vet_bnum = ret_vet_bnum + 1
								end
							end
							
							--取障碍少的角度
							local ret_angle = 0
							--local ret_fangle = 0
							if (ret_hor_bnum <= ret_vet_bnum) then
								ret_angle = ret_angle_hor
								--ret_fangle = ret_fangle_hor
							else
								ret_angle = ret_angle_vet
								--ret_fangle = ret_fangle_vet
							end
							
							--print("ret_angle=", ret_angle)
							
							--当前弹射次数加1
							tansheWallCountNow = tansheWallCountNow + 1
							
							--计算剩余飞行时间
							--local currenttime = world:gametime()
							local pasttime = currenttime - flytimetick --已飞行的时间
							local lefttime = flytime - pasttime --剩余飞行的时间
							
							--飞行总路程
							local flySpeed = self.data.flySpeed
							local distance = flySpeed * lefttime / 1000 --单位: 毫秒
							
							--计算终点坐标
							--local fret_fangle = math.floor(ret_fangle * 100) / 100  --保留2位有效数字，用于同步
							--local tdx = distance * math.cos(fret_fangle) --本地移动的x距离
							--local tdy = distance * math.sin(fret_fangle) --本地移动的y距离
							local tdx = distance * hApi.Math.Cos(ret_angle) --本地移动的x距离
							local tdy = distance * hApi.Math.Sin(ret_angle) --本地移动的y距离
							tdx = math.floor(tdx * 100) / 100  --保留2位有效数字，用于同步
							tdy = math.floor(tdy * 100) / 100  --保留2位有效数字，用于同步
							
							local end_x = block_x + tdx
							local end_y = block_y - tdy
							--print("end_x:", end_x, end_y)
							--单位超反射方向运动一帧，跳出障碍
							
							--检测施法者是否还活着
							local oAttacker = nil
							if (caster_unsafe:getworldC() == caster_worldC) and (caster_unsafe.data.IsDead ~= 1) and (caster_unsafe.attr.hp > 0) then --施法者没被复用，活着
								oAttacker = caster_unsafe
							else --施法者已不存在，改为由施法者的上帝施法
								oAttacker = world:GetPlayer(caster_pos):getgod()
							end
							
							--geyachao: 弹框了，加个检测？？？
							if oAttacker then
								local unit_x, unit_y = hApi.chaGetPos(oAttacker.handle) --角色的坐标
								local shootX = block_x - unit_x --发射起始的偏移x
								local shootY = -(block_y - unit_y) --发射起始的偏移y
								
								--shootX
								--shootY
								--创建碰撞类飞行特效
								local eid = self.data.id
								local oUnitShootFrom = oAttacker
								
								local rollSpeed = self.data.ZHeight
								local flyAngle = -1 --默认不旋转特效
								if (isRotEff == true) or (isRotEff == 1) then
									isRotEff = 1
									flyAngle = 0
								end
								
								--弹射前特殊处理回调
								if On_Effect_Tanshe_Before_Special_Event then
									eid = On_Effect_Tanshe_Before_Special_Event(eid, oUnitShootFrom, caster_skillId, caster_skillLv, tansheWallCountNow, tansheWallCount)
								end
								
								local flyPercent = 100
								local HitZ = nil
								local collParam = {isRotEff, targetType, caster_dmg, caster_dmgMode, caster_skillId, caster_skillLv, ret_angle, block_x, block_y, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, lefttime, currenttime, flySpeedV, blockWallSound} --碰撞相关的参数
								local effParam = {hVar.EFFECT_TYPE.MISSILE, oUnitShootFrom, shootX, shootY, flyAngle, flySpeed, rollSpeed, flyPercent, HitZ}
								local e = world:addeffect(eid, 0, effParam, end_x, end_y, nil, nil, nil, nil, oAction_copy, "line", 1, collParam) --geyachao: 添加参数: 目标, action, szType, collision, collParam
								--table.insert(EFFECTS, e)
							end
							
							--删除原特效，创建新特效
							--标记特效待删除
							handleTable.removetime = currenttime
							--
						end
					end
				end
			end
		end
	end
end

--更新追踪目标类的飞行特效的位置（直线型）
--geyachao
_he.UpdateFollowEff_Line = function(self, dt)
	local world = hGlobal.WORLD.LastWorldMap
	local handleTable = self.handle
	local sprite = handleTable._n
	local oAction = handleTable.oAction
	local oTarget = handleTable.oTarget
	local _nBlink = handleTable._nBlink --地面影子
	--local eff_x, eff_y = sprite:getPosition() --特效的位置
	local eff_x, eff_y = handleTable.x, handleTable.y --特效的位置
	--local screen_eff_y = -eff_y
	local screen_eff_y = eff_y
	--附加偏移值
	--eff_x = eff_x + self.data.offsetX
	--screen_eff_y = screen_eff_y + self.data.offsetY
	
	--存储默认值
	if (not handleTable.finish_x) then
		if (oTarget) and (oTarget.data.IsDead ~= 1) then --目标未死亡，取目标的位置
			local tx, ty = hApi.chaGetPos(oTarget.handle) --目标的位置
			handleTable.finish_x = tx --终点x坐标
			handleTable.finish_y = ty --终点y坐标
		else --目标已死亡，直接结束
			--删除影子
			if _nBlink then
				--_nBlink:setVisible(false)
				xlGroundEffect_Remove(_nBlink)
			end
			
			--清除拖尾效果
			if handleTable._pStreak~=nil then
				local n = handleTable._pStreak
				handleTable._pStreak = nil
				--n:getParent():removeChild(n, true)
				n:removeFromParentAndCleanup(true)
				--print("清楚effect")
			end
			
			--清除导弹特效
			if handleTable._nDaodan~=nil then
				local n = handleTable._nDaodan
				handleTable._nDaodan = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			--清除导弹尘土特效
			if handleTable._nDaodanDust~=nil then
				local n = handleTable._nDaodanDust
				handleTable._nDaodanDust = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			handleTable.oTarget = nil --清除追踪的目标
			handleTable.oAction = nil --清除追踪的action
			handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
			handleTable.customData1 = nil --用户数据1
			handleTable.customData2 = nil --用户数据2
			handleTable.customData3 = nil --用户数据3
			handleTable.collision = nil  --碰撞类型飞行特效的标记
			handleTable._nBlink = nil --清除地面影子
			handleTable._pStreak = nil --清除拖尾效果
			handleTable._nDaodan = nil --清除导弹特效
			handleTable._nDaodanDust = nil --清除导弹尘土特效
			handleTable._nDaodanID = nil --清除导弹id
			
			handleTable.finish_x = nil --终点x坐标
			handleTable.finish_y = nil --终点y坐标
			
			--标记飞行时间到结束
			--oAction:doNextAction()
			handleTable.removetime = world:gametime()
			oAction.data.tick = 1
			
			return
		end
	end
	
	local target_x, target_y = 0, 0
	
	if (oTarget) and (oTarget.data.IsDead ~= 1) then --目标未死亡，取目标的位置
		target_x, target_y = hApi.chaGetPos(oTarget.handle) --目标的位置
	else --目标已死亡，到上一次的地点
		target_x = handleTable.finish_x or 0 --上一次存储的x坐标
		target_y = handleTable.finish_y or 0 --上一次存储的y坐标
		
		--print("标已死亡，到上一次的地点", target_x, target_y, handleTable.finish_x, handleTable.finish_y)
	end
	
	--首次进入
	if (not handleTable.finish_x) then
		--首次进入就是无效的目标
		if (oTarget) and (oTarget:getworldC() ~= oAction.data.target_worldC) then --不是同一个目标了
			--删除影子
			if _nBlink then
				--_nBlink:setVisible(false)
				xlGroundEffect_Remove(_nBlink)
			end
			
			--清除拖尾效果
			if handleTable._pStreak~=nil then
				local n = handleTable._pStreak
				handleTable._pStreak = nil
				--n:getParent():removeChild(n, true)
				n:removeFromParentAndCleanup(true)
				--print("清楚effect")
			end
			
			--清除导弹特效
			if handleTable._nDaodan~=nil then
				local n = handleTable._nDaodan
				handleTable._nDaodan = nil
				n:del()
				--print("清除导弹特效")
			end
			
			--清除导弹尘土特效
			if handleTable._nDaodanDust~=nil then
				local n = handleTable._nDaodanDust
				handleTable._nDaodanDust = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			handleTable.oTarget = nil --清除追踪的目标
			handleTable.oAction = nil --清除追踪的action
			handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
			handleTable.customData1 = nil --用户数据1
			handleTable.customData2 = nil --用户数据2
			handleTable.customData3 = nil --用户数据3
			handleTable.collision = nil  --碰撞类型飞行特效的标记
			handleTable._nBlink = nil --清除地面影子
			handleTable._pStreak = nil --清除拖尾效果
			handleTable._nDaodan = nil --清除导弹特效
			handleTable._nDaodanDust = nil --清除导弹尘土特效
			handleTable._nDaodanID = nil --清除导弹id
			
			handleTable.finish_x = nil --终点x坐标
			handleTable.finish_y = nil --终点y坐标
			
			--标记飞行时间到结束
			--oAction:doNextAction()
			handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
			oAction.data.tick = 1
			
			return
		end
	end
	
	--无效的目标
	if (oTarget) and (oTarget:getworldC() ~= oAction.data.target_worldC) then --不是同一个目标了
		target_x = handleTable.finish_x --上一次存储的x坐标
		target_y = handleTable.finish_y --上一次存储的y坐标
	end
	
	--存储最新的目标的位置
	if (oTarget) then --追踪类才会设置
		oAction.data.worldX = target_x
		oAction.data.worldY = target_y
	end
	
	--命中目标的正中央
	if (oTarget) then
		local cx, cy, cw, ch = oTarget:getbox()
		local offsetX = math.floor(cx + cw / 2)
		local offsetY = math.floor(cy + ch / 2)
		target_x = target_x + offsetX
		target_y = target_y + offsetY
	end
	
	local speed = self.data.flySpeed --特效的速度
	
	--如果是变速飞行，那么检测当前在哪一段的变速区间
	local flySpeedV = self.handle.collision_flySpeedV
	if (type(flySpeedV) == "table") then
		--print("变速飞行")
		local createtime = self.handle.collision_flytimetick
		local pasttime = world:gametime() - createtime --当前飞行特效已经过的时间
		local timeSum = 0
		for i = 1, #flySpeedV, 1 do
			local flySpeed_i = flySpeedV[i].flySpeed
			local flyTime_i = flySpeedV[i].flyTime
			
			timeSum = timeSum + flyTime_i
			--print("i=" .. i, "flySpeed_i=" .. flySpeed_i, "flyTime_i=" .. flyTime_i)
			--print("pasttime=" .. pasttime, "timeSum=" .. timeSum)
			
			if (pasttime <= timeSum) then
				speed = flySpeed_i
				self.data.flySpeed = flySpeed_i
				--print("speed=" .. speed)
				break
			end
		end
		--print("speed=", speed, "idx=", i)
	end
	
	local dx = eff_x - target_x
	local dy = screen_eff_y - target_y
	local distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --距离，保留2位有效数字，用于同步
	local moves = speed * dt / 1000 --本次移动的距离
	--print("dt=", dt)
	local shadowHeight = 20 --影子高度（直线型）
	
	--速度太小，认为是为了隐藏
	if (self.data.flySpeed == 1) then
		if (sprite:isVisible() == true) then
			sprite:setVisible(false)
		end
	else
		if (sprite:isVisible() == false) then
			sprite:setVisible(true)
		end
	end
	
	--print("eff_x=" .. eff_x .. ", eff_y=" .. eff_y .. " , screen_eff_y=" .. screen_eff_y .. ",    target_x=" .. target_x .. ", target_y=" .. target_y)
	
	if (moves >= distance) then --本次足够移动到目标点
		--设置特效飞到目标点
		sprite:setPosition(target_x, -target_y)
		handleTable.x = target_x
		handleTable.y = target_y
		
		if handleTable._pStreak then
			handleTable._pStreak:setPosition(target_x, -target_y)
		end
		
		--影子
		if _nBlink then
			_nBlink:setPosition(target_x, -target_y - shadowHeight)
		end
		
		--self.data.ox = target_x
		--self.data.oy= target_y
		
		--删除影子
		if _nBlink then
			--_nBlink:setVisible(false)
			--print("_nBlink=" .. tostring(_nBlink))
			xlGroundEffect_Remove(_nBlink)
			--print("_nBlink end =" .. tostring(_nBlink))
			--_nBlink = nil
		end
		
		--清除拖尾效果
		if handleTable._pStreak~=nil then
			local n = handleTable._pStreak
			handleTable._pStreak = nil
			--n:getParent():removeChild(n, true)
			n:removeFromParentAndCleanup(true)
			--print("清楚effect")
		end
		
		--清除导弹特效
		if handleTable._nDaodan~=nil then
			local n = handleTable._nDaodan
			handleTable._nDaodan = nil
			n:del()
			--print("清除导弹特效")
		end
		
		--清除导弹尘土特效
		if handleTable._nDaodanDust~=nil then
			local n = handleTable._nDaodanDust
			handleTable._nDaodanDust = nil
			n:del()
			--print("清除导弹尘土特效")
		end
		
		handleTable.oTarget = nil --清除追踪的目标
		handleTable.oAction = nil --清除追踪的action
		handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
		handleTable.customData1 = nil --用户数据1
		handleTable.customData2 = nil --用户数据2
		handleTable.customData3 = nil --用户数据3
		handleTable.collision = nil  --碰撞类型飞行特效的标记
		handleTable._nBlink = nil --清除地面影子
		handleTable._pStreak = nil --清除拖尾效果
		handleTable._nDaodan = nil --清除导弹特效
		handleTable._nDaodanDust = nil --清除导弹尘土特效
		handleTable._nDaodanID = nil --清除导弹id
		
		handleTable.finish_x = nil --终点x坐标
		handleTable.finish_y = nil --终点y坐标
		
		--标记飞行时间到结束
		--oAction:doNextAction()
		handleTable.removetime = world:gametime()
		oAction.data.tick = 1
	else --未到达目标点，往目标方向向前飞一段距离
		local angle = GetLineAngle(eff_x, screen_eff_y, target_x, target_y) --角度制
		--print("angle=" .. angle)
		--local fangle = angle * math.pi / 180 --弧度制
		--local tdx = moves * math.cos(fangle) --本地移动的x距离
		--local tdy = moves * math.sin(fangle) --本地移动的y距离
		--local to_x = eff_x + tdx
		--local to_y = screen_eff_y + tdy
		local to_x = eff_x + moves * (target_x - eff_x) / distance
		local to_y = screen_eff_y + moves * (target_y - screen_eff_y) / distance
		to_x = math.floor(to_x * 100) / 100 --保留2位有效数字，用于同步
		to_y = math.floor(to_y * 100) / 100 --保留2位有效数字，用于同步
		
		--箭矢
		sprite:setPosition(to_x, -to_y)
		if (oTarget) or (handleTable.collision_isRotEff == 1) then
			sprite:setRotation(angle + 180)
		end
		handleTable.x = to_x
		handleTable.y = to_y
		--self.data.ox = to_x
		--self.data.oy= to_y
		
		--影子
		if _nBlink then
			_nBlink:setPosition(to_x, -to_y - shadowHeight)
			if (oTarget) or (handleTable.collision_isRotEff == 1) then
				_nBlink:setRotation(angle - 90)
			end
		end
		
		--拖尾
		if handleTable._pStreak then
			handleTable._pStreak:setPosition(to_x, -to_y)
			--print("bcd")
		end
	end
end

--更新追踪目标类的飞行特效的位置（抛物线型）
--geyachao
_he.UpdateFollowEff_Parabola = function(self, dt)
	local handleTable = self.handle
	local sprite = handleTable._n
	local oAction = self.handle.oAction
	local oTarget = handleTable.oTarget
	local _nBlink = handleTable._nBlink --地面影子
	--local eff_x, eff_y = sprite:getPosition() --特效的位置
	local eff_x, eff_y = handleTable.x, handleTable.y --特效的位置
	--local screen_eff_y = -eff_y
	local screen_eff_y = eff_y
	local G = self.data.G --重力加速度
	local shadowHeight = 0 --影子高度（抛物线型）
	
	local target_x, target_y = 0, 0
	
	if (oTarget) and (oTarget.data.IsDead ~= 1) and (oTarget:getworldC() == oAction.data.target_worldC) then --目标未死亡，取目标的位置
		target_x, target_y = hApi.chaGetPos(oTarget.handle) --目标的位置
	else --目标已死亡，到上一次的地点
		target_x = handleTable.finish_x or 0 --上一次存储的x坐标
		target_y = handleTable.finish_y or 0 --上一次存储的y坐标
		
		--print("标已死亡，到上一次的地点", target_x, target_y, handleTable.finish_x, handleTable.finish_y)
	end
	
	--首次设置初始速度
	if (not handleTable.vx) then
		handleTable.shadow_x = eff_x --影子x位置
		handleTable.shadow_y = screen_eff_y --影子y位置
		
		--命中目标的正中央
		local cx, cy, cw, ch = oTarget:getbox()
		local offsetX = math.floor(cx + cw / 2)
		local offsetY = math.floor(cy + ch / 2)
		target_x = target_x + offsetX
		target_y = target_y + offsetY
		
		local speed = self.data.flySpeed --特效的速度
		
		--如果是变速飞行，那么检测当前在哪一段的变速区间
		local flySpeedV = self.handle.collision_flySpeedV
		if (type(flySpeedV) == "table") then
			local createtime = self.handle.collision_flytimetick
			local pasttime = world:gametime() - createtime --当前飞行特效已经过的时间
			local timeSum = 0
			for i = 1, #flySpeedV, 1 do
				local flySpeed = flySpeedV[i].flySpeed
				local flyTime = flySpeedV[i].flyTime
				
				timeSum = timeSum + flyTime
				
				if (pasttime >= timeSum) then
					speed = flySpeed
				else
					break
				end
			end
			--print("speed=", speed, "idx=", i)
		end
		
		local dx = target_x - eff_x --dx
		local dy = target_y - screen_eff_y --dy
		local distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --距离，保留2位有效数字，用于同步
		local time = distance / speed --移动需要的总时间
		--print("time=", time)
		if (time < 1) then
			time = 1
			speed = distance
		end
		speed = math.floor(speed * 100) / 100  --保留2位有效数字，用于同步
		local falpha = math.atan(dy / dx) --弧度制
		if (dx >= 0) then
			falpha = math.pi + falpha
		end
		falpha = math.pi + falpha
		falpha = math.floor(falpha * 100) / 100  --保留2位有效数字，用于同步
		handleTable.finish_x = target_x --终点x坐标
		handleTable.finish_y = target_y --终点y坐标
		handleTable.vx = speed * math.cos(falpha) --连线方向的初始x速度
		handleTable.vy = speed * math.sin(falpha) --连线方向的初始y速度
		--handleTable.vx = speed * hApi.Math.Cos(alpha) --连线方向的初始x速度
		--handleTable.vy = speed * hApi.Math.Sin(alpha) --连线方向的初始y速度
		handleTable.vx = math.floor(handleTable.vx * 100) / 100  --保留2位有效数字，用于同步
		handleTable.vy = math.floor(handleTable.vy * 100) / 100  --保留2位有效数字，用于同步
		--计算切线方向
		--[[
		local ftheta = math.pi / 2 + falpha --切线的弧度制
		local theta = 180.0 * ftheta / math.pi --切线的角度制
		if (theta > 180) then
			theta = theta - 360
		end
		if (theta <= -180) then
			theta = theta + 360
		end
		]]
		local theta = 90 --切线的角度制
		
		handleTable.logicTheta = theta --逻辑角度值
		handleTable.ftheta = theta * math.pi / 180 --弧度制
		G = 1 * self.data.ZHeight * 10 / time / time --1/2*a*t*t = S ZHeight放大10倍
		
		self.data.G = G
		handleTable.vcut = -time * G / 2 --切线方向的速度
		
		--设置存在时间
		handleTable.livetime = 0 --当前存在时间
		handleTable.maxtime = time --最大存在时间
		--print("theta=" .. theta)
	end
	
	local FOLLOW_TARGET = 1 --是否追踪目标模式
	
	--追踪目标类型，重新计算速度
	if (FOLLOW_TARGET == 1) then
		local add_dx = target_x - handleTable.finish_x --角色移动带来的额外x距离
		local add_dy = target_y - handleTable.finish_y --角色移动带来的额外y距离
		local leftTime = handleTable.maxtime - handleTable.livetime --剩余存在时间
		local add_speed_x = add_dx / leftTime --额外距离需要的额外x速度
		local add_speed_y = add_dy / leftTime --额外距离需要的额外y速度
		add_speed_x = math.floor(add_speed_x * 100) / 100  --保留2位有效数字，用于同步
		add_speed_y = math.floor(add_speed_y * 100) / 100  --保留2位有效数字，用于同步
		handleTable.vx = handleTable.vx + add_speed_x
		handleTable.vy = handleTable.vy + add_speed_y
		handleTable.finish_x = target_x
		handleTable.finish_y = target_y
	end
	
	--存储最新的目标的位置
	if (oTarget) and (oTarget:getworldC() == oAction.data.target_worldC) then --是同一个目标 --追踪类才会设置
		oAction.data.worldX = target_x
		oAction.data.worldY = target_y
	end
	
	--计算本次位移
	local vx = handleTable.vx --连线方向的x速度
	local vy = handleTable.vy --连线方向的y速度
	--vx = 0 --test
	--vy = 0 --test
	local ftheta = handleTable.ftheta --切线的弧度制
	if (ftheta < 0) then
		ftheta = ftheta + math.pi --为了让箭从上面射出
		ftheta = math.floor(ftheta * 100) / 100  --保留2位有效数字，用于同步
	end
	local vcut = handleTable.vcut --切线方向的速度
	local tdx = vx * dt / 1000 --本次连线方向的x位移
	local tdy = vy * dt / 1000 --本次连线方向的y位移
	local cut_dis = vcut * dt / 1000 - 1/2 * G * dt / 1000 * dt / 1000 --本地切线方向的位移
	local cutdx = cut_dis * math.cos(ftheta) --本次切线方向的x位移
	local cutdy = cut_dis * math.sin(ftheta) --本次切线方向的y位移
	cutdx = math.floor(cutdx * 100) / 100  --保留2位有效数字，用于同步
	cutdy = math.floor(cutdy * 100) / 100  --保留2位有效数字，用于同步
	
	local to_x = eff_x + tdx + cutdx
	local to_y = screen_eff_y + tdy + cutdy
	local new_cutv = vcut + G * dt / 1000 --切线方向的新速度
	handleTable.vcut = new_cutv
	--print("eff_x=" .. eff_x .. ", eff_y=" .. eff_y .. " , screen_eff_y=" .. screen_eff_y .. ",    to_x=" .. to_x .. ", to_y=" .. to_y)
	
	--计算箭矢的角度
	local new_alpha = GetLineAngle(eff_x, screen_eff_y, to_x, to_y) --角度制
	
	--箭矢
	sprite:setPosition(to_x, -to_y)
	sprite:setRotation(new_alpha + 180)
	handleTable.x = to_x
	handleTable.y = to_y
	
	--影子
	if _nBlink then
		local sx, sy = handleTable.shadow_x, handleTable.shadow_y --影子位置
		local btox = sx + tdx
		local btoy = sy + tdy
		handleTable.shadow_x = btox --影子x位置
		handleTable.shadow_y = btoy --影子y位置
		
		--设置影子的坐标
		_nBlink:setPosition(btox, -btoy - shadowHeight)
		
		--设置影子的角度
		--追踪目标类型，重新计算速度
		if (FOLLOW_TARGET == 1) then
			local target_x, target_y = hApi.chaGetPos(oTarget.handle) --目标的位置
			--无效的目标，默认飞到最近一次的目标位置
			if (oTarget:getworldC() ~= oAction.data.target_worldC) then --不是同一个目标了
				target_x = handleTable.finish_x
				target_y = handleTable.finish_y
			end
			
			local dx = target_x - btox --dx
			local dy = target_y - btoy --dy
			local falpha = math.atan(dy / dx) --弧度制
			if (dx > 0) then
				falpha = math.pi + falpha
			end
			falpha = math.pi + falpha
			falpha = math.floor(falpha * 100) / 100  --保留2位有效数字，用于同步
			local ftheta = math.pi / 2 + falpha --切线的弧度制
			local theta = 180.0 * ftheta / math.pi --切线的角度制
			theta = math.floor(theta * 100) / 100  --保留2位有效数字，用于同步
			_nBlink:setRotation(theta + 180)
		else
			_nBlink:setRotation(handleTable.logicTheta + 180) --不追踪就沿固定角度旋转
		end
	end
	
	--叠加存在时间
	handleTable.livetime = handleTable.livetime + dt / 1000
	
	--检测存在时间
	if (handleTable.livetime > handleTable.maxtime) then
		--隐藏影子
		if _nBlink then
			--_nBlink:setVisible(false)
			xlGroundEffect_Remove(_nBlink)
		end
		
		--清空数据
		self.data.flyspeed = nil --飞行速度
		handleTable.shadow_x = nil --特效的逻辑x位置
		handleTable.shadow_y = nil --特效的逻辑y位置
		handleTable.livetime = nil --当前存在时间
		handleTable.maxtime = nil --最大存在时间
		handleTable.finish_x = nil --终点x坐标
		handleTable.finish_y = nil --终点y坐标
		handleTable.vx = nil --连线方向的初始x速度
		handleTable.vy = nil --连线方向的初始y速度
		handleTable.ftheta = nil --弧度制
		handleTable.vcut = nil --切线方向的速度
		handleTable.logicTheta = nil --逻辑角度值
		handleTable.vertical_y_orin = nil
		
		self.handle.oTarget = nil --清除追踪的目标
		self.handle.oAction = nil --清除追踪的action
		self.handle.oAction_missle = nil --抛物线追踪的action
		self.handle.oAction_missle_toprocess_tag = nil --抛物线追踪的action回调待处理标记
		handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
		handleTable.customData1 = nil --用户数据1
		handleTable.customData2 = nil --用户数据2
		handleTable.customData3 = nil --用户数据3
		handleTable.collision = nil  --碰撞类型飞行特效的标记
		--self.handle._nBlink = nil --清除地面影子
		handleTable._pStreak = nil --清除拖尾效果
		handleTable._nDaodan = nil --清除导弹特效
		handleTable._nDaodanDust = nil --清除导弹尘土特效
		handleTable._nDaodanID = nil --清除导弹id
		
		--标记飞行时间到结束
		handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
		oAction.data.tick = 1
		--oAction:doNextAction()
	end
end

--更新追踪目标类的飞行特效的位置（追踪导弹型）
--geyachao
_he.UpdateFollowEff_Tracing = function(self, dt)
	local world = hGlobal.WORLD.LastWorldMap
	local handleTable = self.handle
	local sprite = handleTable._n
	local oAction = handleTable.oAction
	local oTarget = handleTable.oTarget
	local _nBlink = handleTable._nBlink --地面影子
	local begin_x, begin_y = self.data.ox, self.data.oy
	
	local daodanFlyEffectId = handleTable.collision_daodanFlyEffectId --碰撞类型飞行特效，导弹正常状态的特效id
	local daodanIsHideTail = handleTable.collision_daodanIsHideTail --碰撞类型飞行特效，导弹是否隐藏飞升拖尾特效
	local daodanBoomEffectId = handleTable.collision_daodanBoomEffectId --碰撞类型飞行特效，导弹爆炸特效id
	
	--local eff_x, eff_y = sprite:getPosition() --特效的位置
	local eff_x, eff_y = handleTable.x, handleTable.y --特效的位置
	--local screen_eff_y = -eff_y
	local screen_eff_y = eff_y
	--附加偏移值
	--eff_x = eff_x + self.data.offsetX
	--screen_eff_y = screen_eff_y + self.data.offsetY
	
	--先往正上方运动一小段距离，再开始命中目标
	local dbx = eff_x - begin_x
	local dby = screen_eff_y - begin_y
	local dbdistance = math.floor(math.sqrt(dbx * dbx + dby * dby) * 100) / 100 --距离初始点的距离，保留2位有效数字，用于同步
	--print(dbdistance)
	--先往正上方运动
	local DISTANCEUP = 200
	local ANGLEUP = 270
	local AF = 0.05 --追踪的扭转速率
	local SCALEUP = 1.0 --最大缩放值
	local SF = 0.2 --追踪的缩放速率
	if (handleTable.customData1 == nil) then --customData1: 高度误差值
		if (dbdistance < DISTANCEUP) then
			local angle = ANGLEUP
			local speed = self.data.flySpeed --特效的速度
			local moves = speed * dt / 1000 --本次移动的距离
			
			--print("dt=", dt)
			local shadowHeight = 20 --影子高度（直线型）
			
			local to_x = eff_x
			local to_y = screen_eff_y - moves
			to_x = math.floor(to_x * 100) / 100 --保留2位有效数字，用于同步
			to_y = math.floor(to_y * 100) / 100 --保留2位有效数字，用于同步
			
			--设置缩放
			local scale = SCALEUP - ((DISTANCEUP - dbdistance) / DISTANCEUP)  * (SCALEUP - 1.0)
			--customData3: 图片缩放值
			handleTable.customData3 = scale --customData3: 图片缩放值
			sprite:setScale(scale)
			
			--箭矢
			sprite:setPosition(to_x, -to_y)
			if (oTarget) or (handleTable.collision_isRotEff == 1) then
				sprite:setRotation(angle + 180)
			end
			handleTable.x = to_x
			handleTable.y = to_y
			--self.data.ox = to_x
			--self.data.oy= to_y
			
			--首次进入添加导弹尘土模型
			if (not handleTable._nDaodanDust) then
				local effect_id = 3161
				local spriteEffHitId = self.data.id + 1
				if (spriteEffHitId == hVar.TRACING_BIAOQIANG_ID) then --标枪导弹
					effect_id = 3182
				end
				if (daodanIsHideTail ~= 1) and (daodanIsHideTail ~= true) then
					local eff = world:addeffect(effect_id, 99999, nil, eff_x, screen_eff_y) --56
					handleTable._nDaodanDust = eff
					--handleTable.s:setOpacity(0)
				end
			end
			
			--影子
			if _nBlink then
				_nBlink:setPosition(to_x, -to_y - shadowHeight)
				if (oTarget) or (handleTable.collision_isRotEff == 1) then
					_nBlink:setRotation(angle - 90)
				end
			end
			
			--拖尾
			if handleTable._pStreak then
				handleTable._pStreak:setPosition(to_x, -to_y)
				--print("bcd")
			end
			
			--导弹特效
			if handleTable._nDaodan then
				handleTable._nDaodan.handle._n:setRotation(angle + 180)
				handleTable._nDaodan.handle._n:setPosition(to_x, -to_y)
			end
			
			--导弹尘土特效
			if handleTable._nDaodanDust then
				if handleTable._nDaodanDust.handle._n then
					handleTable._nDaodanDust.handle._n:setRotation(angle + 180)
					handleTable._nDaodanDust.handle._n:setPosition(to_x, -to_y - 20) --尘土特效y偏差-20
				end
			end
			
			--重置z值
			if sprite then
				--if fffffffffffffff == nil then
				--	xlChaSetZOrderOffset(handleTable._c, 9999)
				--	fffffffffffffff = true
				--end
				--sprite:getParent():reorderChild(sprite, 9999)
				--local parent = hGlobal.WORLD_LAYER[world.handle.worldScene]
				--if parent then
				--	parent:reorderChild(handleTable._nDaodan.handle._n, 99999)
				--end
				--print("重置z值", 1000000)
			end
			
			return
		end
	end
	
	--存储默认值
	if (not handleTable.finish_x) then
		--如果目标是上帝，改为周围的一个随机敌人
		local unit = oAction.data.unit
		
		--施法者不存在了
		if (unit == 0) or (unit == nil) then
			--删除影子
			if _nBlink then
				--_nBlink:setVisible(false)
				xlGroundEffect_Remove(_nBlink)
			end
			
			--清除拖尾效果
			if handleTable._pStreak~=nil then
				local n = handleTable._pStreak
				handleTable._pStreak = nil
				--n:getParent():removeChild(n, true)
				n:removeFromParentAndCleanup(true)
				--print("清楚effect")
			end
			
			--清除导弹特效
			if handleTable._nDaodan~=nil then
				local n = handleTable._nDaodan
				handleTable._nDaodan = nil
				n:del()
				--print("清除导弹特效")
			end
			
			--清除导弹尘土特效
			if handleTable._nDaodanDust~=nil then
				local n = handleTable._nDaodanDust
				handleTable._nDaodanDust = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			handleTable.oTarget = nil --清除追踪的目标
			handleTable.oAction = nil --清除追踪的action
			handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
			handleTable.customData1 = nil --用户数据1
			handleTable.customData2 = nil --用户数据2
			handleTable.customData3 = nil --用户数据3
			handleTable.collision = nil  --碰撞类型飞行特效的标记
			handleTable._nBlink = nil --清除地面影子
			handleTable._pStreak = nil --清除拖尾效果
			handleTable._nDaodan = nil --清除导弹特效
			handleTable._nDaodanDust = nil --清除导弹尘土特效
			handleTable._nDaodanID = nil --清除导弹id
			
			handleTable.finish_x = nil --终点x坐标
			handleTable.finish_y = nil --终点y坐标
			
			--标记飞行时间到结束
			--oAction:doNextAction()
			handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
			oAction.data.tick = 1
			
			--添加原地爆炸特效 3097
			world:addeffect(daodanBoomEffectId, 1.0 ,nil, eff_x, screen_eff_y) --56
			--print("添加原地爆炸特效 2")
			
			return
		end
		
		if (oTarget == unit:getowner():getgod()) then
			local targetList = {}
			local tabS = hVar.tab_skill[oAction.data.skillId]
			world:enumunitAreaEnemy(unit:getowner():getforce(), eff_x, screen_eff_y, 600, function(eu)
				if tabS.cast_target_type[eu.data.type] then
					targetList[#targetList+1] = {eu = eu, rand = world:random(1, 99999),}
					--print("找到目标:", eu.data.name)
				end
			end)
			
			--随机一个敌人
			--优先找被追踪次数最少的敌人
			if (#targetList > 0) then
				--local randIdx = world:random(1, #targetList)
				--oTarget = targetList[randIdx]
				table.sort(targetList, function(ta, tb)
					if (ta.eu.attr.tracingNum ~= tb.eu.attr.tracingNum) then
						return ta.eu.attr.tracingNum < tb.eu.attr.tracingNum
					else
						return ta.rand < tb.rand
					end
				end)
				oTarget = targetList[1].eu
				
				handleTable.oTarget = oTarget
				oAction.data.target = oTarget
				oAction.data.target_worldC = oTarget:getworldC()
				
				--标记被追踪次数加1
				oTarget.attr.tracingNum = oTarget.attr.tracingNum + 1
			else
				--没找到敌人
				--oTarget = nil
				--handleTable.oTarget = nil
				--oAction.data.target = nil
				oAction.data.target_worldC = 0
			end
		end
		
		--print(oTarget.data.name)
		if (oTarget) and (oTarget.data.IsDead ~= 1) and (oTarget:getworldC() == oAction.data.target_worldC) then --目标未死亡，取目标的位置
			local tx, ty = hApi.chaGetPos(oTarget.handle) --目标的位置
			handleTable.finish_x = tx --终点x坐标
			handleTable.finish_y = ty --终点y坐标
		else --目标已死亡，直接结束
			--删除影子
			if _nBlink then
				--_nBlink:setVisible(false)
				xlGroundEffect_Remove(_nBlink)
			end
			
			--清除拖尾效果
			if handleTable._pStreak~=nil then
				local n = handleTable._pStreak
				handleTable._pStreak = nil
				--n:getParent():removeChild(n, true)
				n:removeFromParentAndCleanup(true)
				--print("清楚effect")
			end
			
			--清除导弹特效
			if handleTable._nDaodan~=nil then
				local n = handleTable._nDaodan
				handleTable._nDaodan = nil
				n:del()
				--print("清除导弹特效")
			end
			
			--清除导弹尘土特效
			if handleTable._nDaodanDust~=nil then
				local n = handleTable._nDaodanDust
				handleTable._nDaodanDust = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			handleTable.oTarget = nil --清除追踪的目标
			handleTable.oAction = nil --清除追踪的action
			handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
			handleTable.customData1 = nil --用户数据1
			handleTable.customData2 = nil --用户数据2
			handleTable.customData3 = nil --用户数据3
			handleTable.collision = nil  --碰撞类型飞行特效的标记
			handleTable._nBlink = nil --清除地面影子
			handleTable._pStreak = nil --清除拖尾效果
			handleTable._nDaodan = nil --清除导弹特效
			handleTable._nDaodanDust = nil --清除导弹尘土特效
			handleTable._nDaodanID = nil --清除导弹id
			
			handleTable.finish_x = nil --终点x坐标
			handleTable.finish_y = nil --终点y坐标
			
			--标记飞行时间到结束
			--oAction:doNextAction()
			handleTable.removetime = world:gametime()
			oAction.data.tick = 1
			
			--添加原地爆炸特效 3097
			world:addeffect(daodanBoomEffectId, 1.0 ,nil, eff_x, screen_eff_y) --56
			--print("添加原地爆炸特效 1")
			
			return
		end
	end
	
	local target_x, target_y = 0, 0
	
	if (oTarget) and (oTarget.data.IsDead ~= 1) and (oTarget:getworldC() == oAction.data.target_worldC) then --目标未死亡，取目标的位置
		target_x, target_y = hApi.chaGetPos(oTarget.handle) --目标的位置
	else --目标已死亡，到上一次的地点
		target_x = handleTable.finish_x or 0 --上一次存储的x坐标
		target_y = handleTable.finish_y or 0 --上一次存储的y坐标
		
		--print("标已死亡，到上一次的地点", target_x, target_y, handleTable.finish_x, handleTable.finish_y)
	end
	
	--首次进入
	if (not handleTable.finish_x) then
		--首次进入就是无效的目标
		if (oTarget) and ((oTarget.data.IsDead == 1) or (oTarget:getworldC() ~= oAction.data.target_worldC)) then --不是同一个目标了
			--删除影子
			if _nBlink then
				--_nBlink:setVisible(false)
				xlGroundEffect_Remove(_nBlink)
			end
			
			--清除拖尾效果
			if handleTable._pStreak~=nil then
				local n = handleTable._pStreak
				handleTable._pStreak = nil
				--n:getParent():removeChild(n, true)
				n:removeFromParentAndCleanup(true)
				--print("清楚effect")
			end
			
			--清除导弹特效
			if handleTable._nDaodan~=nil then
				local n = handleTable._nDaodan
				handleTable._nDaodan = nil
				n:del()
				--print("清除导弹特效")
			end
			
			--清除导弹尘土特效
			if handleTable._nDaodanDust~=nil then
				local n = handleTable._nDaodanDust
				handleTable._nDaodanDust = nil
				n:del()
				--print("清除导弹尘土特效")
			end
			
			handleTable.oTarget = nil --清除追踪的目标
			handleTable.oAction = nil --清除追踪的action
			handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
			handleTable.customData1 = nil --用户数据1
			handleTable.customData2 = nil --用户数据2
			handleTable.customData3 = nil --用户数据3
			handleTable.collision = nil  --碰撞类型飞行特效的标记
			handleTable._nBlink = nil --清除地面影子
			handleTable._pStreak = nil --清除拖尾效果
			handleTable._nDaodan = nil --清除导弹特效
			handleTable._nDaodanDust = nil --清除导弹尘土特效
			handleTable._nDaodanID = nil --清除导弹id
			
			handleTable.finish_x = nil --终点x坐标
			handleTable.finish_y = nil --终点y坐标
			
			--标记飞行时间到结束
			--oAction:doNextAction()
			handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
			oAction.data.tick = 1
			
			--添加原地爆炸特效 3097
			world:addeffect(daodanBoomEffectId, 1.0 ,nil, eff_x, screen_eff_y) --56
			--print("添加原地爆炸特效 2")
			
			return
		end
	end
	
	--首次进入添加导弹模型
	if (not handleTable._nDaodan) then
		local effect_id = daodanFlyEffectId --碰撞类型飞行特效，导弹正常状态的特效id
		local eff = world:addeffect(effect_id, 99999, nil, eff_x, screen_eff_y) --56
		handleTable._nDaodan = eff
		handleTable._nDaodanID = effect_id
		
		--隐藏自身
		handleTable.s:setOpacity(0)
		
		--只清除导弹尘土特效
		if handleTable._nDaodanDust~=nil then
			local n = handleTable._nDaodanDust
			handleTable._nDaodanDust = nil
			n:del()
			--print("清除导弹尘土特效")
		end
	end
	
	--无效的目标
	if (oTarget) and (oTarget:getworldC() ~= oAction.data.target_worldC) then --不是同一个目标了
		target_x = handleTable.finish_x --上一次存储的x坐标
		target_y = handleTable.finish_y --上一次存储的y坐标
	end
	
	--存储最新的目标的位置
	if (oTarget) then --追踪类才会设置
		oAction.data.worldX = target_x
		oAction.data.worldY = target_y
	end
	
	--命中目标的正中央
	if (oTarget) then
		local cx, cy, cw, ch = oTarget:getbox()
		local offsetX = math.floor(cx + cw / 2)
		local offsetY = math.floor(cy + ch / 2)
		target_x = target_x + offsetX
		target_y = target_y + offsetY
	end
	
	local flytime = self.handle.collision_flytime --碰撞类型飞行特效，特效飞行时间（毫秒）
	local flytimetick = self.handle.collision_flytimetick --碰撞类型飞行特效，特效开始飞行的时间
	local speed = self.data.flySpeed --特效的速度
	local dx = eff_x - target_x
	local dy = screen_eff_y - target_y
	local distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --剩余距离，保留2位有效数字，用于同步
	local moves = speed * dt / 1000 --本次移动的距离
	--print("dt=", dt)
	local shadowHeight = 20 --影子高度（直线型）
	
	--print("eff_x=" .. eff_x .. ", eff_y=" .. eff_y .. " , screen_eff_y=" .. screen_eff_y .. ",    target_x=" .. target_x .. ", target_y=" .. target_y)
	
	if (moves >= (distance - hVar.ROLE_COLLISION_EDGE)) then --本次足够移动到目标点
		--设置特效飞到目标点
		sprite:setPosition(target_x, -target_y)
		handleTable.x = target_x
		handleTable.y = target_y
		
		--追踪道道特效id
		local spriteEffId = handleTable._nDaodanID + 2
		
		if (spriteEffId == hVar.TRACING_BIAOQIANG_ID) then --标枪导弹
			if (oTarget) and (oTarget.data.IsDead ~= 1) and (oTarget:getworldC() == oAction.data.target_worldC) then --是同一个目标
				local effX = target_x + world:random(-20, 20)
				local effY = target_y + world:random(-20, 20)
				local eff = world:addeffect(spriteEffId, 99999, nil, effX, effY) --56
				local rot = sprite:getRotation()
				eff.handle._n:setRotation(rot)
				oTarget:AddTacingEffect(eff, effX, effY)
			end
		end
		
		if handleTable._pStreak then
			handleTable._pStreak:setPosition(target_x, -target_y)
		end
		
		--影子
		if _nBlink then
			_nBlink:setPosition(target_x, -target_y - shadowHeight)
		end
		
		--self.data.ox = target_x
		--self.data.oy= target_y
		
		--删除影子
		if _nBlink then
			--_nBlink:setVisible(false)
			--print("_nBlink=" .. tostring(_nBlink))
			xlGroundEffect_Remove(_nBlink)
			--print("_nBlink end =" .. tostring(_nBlink))
			--_nBlink = nil
		end
		
		--清除拖尾效果
		if handleTable._pStreak~=nil then
			local n = handleTable._pStreak
			handleTable._pStreak = nil
			--n:getParent():removeChild(n, true)
			n:removeFromParentAndCleanup(true)
			--print("清楚effect")
		end
		
		--清除导弹特效
		if handleTable._nDaodan~=nil then
			local n = handleTable._nDaodan
			handleTable._nDaodan = nil
			n:del()
			--print("清除导弹特效")
		end
		
		--清除导弹尘土特效
		if handleTable._nDaodanDust~=nil then
			local n = handleTable._nDaodanDust
			handleTable._nDaodanDust = nil
			n:del()
			--print("清除导弹尘土特效")
		end
		
		handleTable.oTarget = nil --清除追踪的目标
		handleTable.oAction = nil --清除追踪的action
		handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
		handleTable.customData1 = nil --用户数据1
		handleTable.customData2 = nil --用户数据2
		handleTable.customData3 = nil --用户数据3
		handleTable.collision = nil  --碰撞类型飞行特效的标记
		handleTable._nBlink = nil --清除地面影子
		handleTable._pStreak = nil --清除拖尾效果
		handleTable._nDaodan = nil --清除导弹特效
		handleTable._nDaodanDust = nil --清除导弹尘土特效
		handleTable._nDaodanID = nil --清除导弹id
		
		handleTable.finish_x = nil --终点x坐标
		handleTable.finish_y = nil --终点y坐标
		
		--标记飞行时间到结束
		--oAction:doNextAction()
		handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
		oAction.data.tick = 1
		
		--添加原地爆炸特效 3097
		--print("添加原地爆炸特效", spriteEffId)
		if (spriteEffId ~= hVar.TRACING_BIAOQIANG_ID) then --非标枪导弹
			world:addeffect(daodanBoomEffectId, 1.0 ,nil, eff_x, screen_eff_y) --56
		end
		--print("添加原地爆炸特效 3")
	else --未到达目标点，往目标方向向前飞一段距离
		local angle = GetLineAngle(eff_x, screen_eff_y, target_x, target_y) --角度制
		--追踪导弹，由垂直方向慢慢偏转转向angle
		--customData1: 高度误差值
		if (handleTable.customData1 == nil) then --customData1: 高度误差值
			handleTable.customData1 = DISTANCEUP
		else
			handleTable.customData1 = handleTable.customData1 - moves
			if (handleTable.customData1 < 0) then
				handleTable.customData1 = 0
			end
		end
		local rate = (dbdistance - handleTable.customData1) / (dbdistance + distance) * 100
		rate = math.floor(rate * 100) / 100 --保留2位有效数字，用于同步
		if (rate < 0) then
			rate = 0
		end
		
		--customData2: 角度误差值
		if (handleTable.customData2 == nil) then --customData2: 角度误差值
			handleTable.customData2 = ANGLEUP - angle
			
			if (angle <= (360 - ANGLEUP)) then
				handleTable.customData2 = ANGLEUP - (angle + 360)
			end
		else
			handleTable.customData2 = handleTable.customData2 * (100 - rate * AF) / 100
		end
		local angleReal = angle + handleTable.customData2
		
		--重新计算本次的位移
		--print("rate=", rate, "angle=", angle, "angleReal=" .. angleReal)
		--local fangleReal = angleReal * math.pi / 180 --弧度制
		--local tdxReal = moves * math.cos(fangleReal) --本地移动的x距离
		--local tdyReal = moves * math.sin(fangleReal) --本地移动的y距离
		local tdxReal = moves * hApi.Math.Cos(angleReal) --本地移动的x距离
		local tdyReal = moves * hApi.Math.Sin(angleReal) --本地移动的y距离
		local to_x = eff_x + tdxReal
		local to_y = screen_eff_y + tdyReal
		--local to_x = eff_x + moves * (target_x - eff_x) / distance
		--local to_y = screen_eff_y + moves * (target_y - screen_eff_y) / distance
		to_x = math.floor(to_x * 100) / 100 --保留2位有效数字，用于同步
		to_y = math.floor(to_y * 100) / 100 --保留2位有效数字，用于同步
		
		--设置缩放值
		local scale = SCALEUP - (rate * SF / 100) * (SCALEUP - 1.0)
		--customData3: 图片缩放值
		handleTable.customData3 = scale --customData3: 图片缩放值
		sprite:setScale(scale)
		
		--箭矢
		sprite:setPosition(to_x, -to_y)
		if (oTarget) or (handleTable.collision_isRotEff == 1) then
			sprite:setRotation(angleReal + 180)
		end
		handleTable.x = to_x
		handleTable.y = to_y
		--self.data.ox = to_x
		--self.data.oy= to_y
		
		--[[
		--重置z值
		if sprite then
			sprite:getParent():reorderChild(sprite, 1000000)
			--print("重置z值", 1000000)
		end
		]]
		
		--影子
		if _nBlink then
			_nBlink:setPosition(to_x, -to_y - shadowHeight)
			if (oTarget) or (handleTable.collision_isRotEff == 1) then
				_nBlink:setRotation(angleReal - 90)
			end
		end
		
		--拖尾
		if handleTable._pStreak then
			handleTable._pStreak:setPosition(to_x, -to_y)
			--print("bcd")
		end
		
		--导弹特效
		if handleTable._nDaodan then
			if handleTable._nDaodan.handle._n then
				handleTable._nDaodan.handle._n:setRotation(angleReal + 180)
				handleTable._nDaodan.handle._n:setPosition(to_x, -to_y)
			end
		end
		
		--如果子弹飞行超过最大生存时间，原地爆炸消失
		if (flytime > 0) then
			--计算剩余飞行时间
			local currenttime = world:gametime()
			local pasttime = currenttime - flytimetick --已飞行的时间
			local lefttime = flytime - pasttime --剩余飞行的时间
			if (lefttime <= 0) then
				--删除影子
				if _nBlink then
					--_nBlink:setVisible(false)
					--print("_nBlink=" .. tostring(_nBlink))
					xlGroundEffect_Remove(_nBlink)
					--print("_nBlink end =" .. tostring(_nBlink))
					--_nBlink = nil
				end
				
				--清除拖尾效果
				if handleTable._pStreak~=nil then
					local n = handleTable._pStreak
					handleTable._pStreak = nil
					--n:getParent():removeChild(n, true)
					n:removeFromParentAndCleanup(true)
					--print("清楚effect")
				end
				
				--清除导弹特效
				if handleTable._nDaodan~=nil then
					local n = handleTable._nDaodan
					handleTable._nDaodan = nil
					n:del()
					--print("清除导弹特效")
				end
				
				--清除导弹尘土特效
				if handleTable._nDaodanDust~=nil then
					local n = handleTable._nDaodanDust
					handleTable._nDaodanDust = nil
					n:del()
					--print("清除导弹尘土特效")
				end
				
				handleTable.oTarget = nil --清除追踪的目标
				handleTable.oAction = nil --清除追踪的action
				handleTable.szType = nil --追踪的类型（直线型、抛物线型、追踪导弹型）
				handleTable.customData1 = nil --用户数据1
				handleTable.customData2 = nil --用户数据2
				handleTable.customData3 = nil --用户数据3
				handleTable.collision = nil  --碰撞类型飞行特效的标记
				handleTable._nBlink = nil --清除地面影子
				handleTable._pStreak = nil --清除拖尾效果
				handleTable._nDaodan = nil --清除导弹特效
				handleTable._nDaodanDust = nil --清除导弹尘土特效
				handleTable._nDaodanID = nil --清除导弹id
				
				handleTable.finish_x = nil --终点x坐标
				handleTable.finish_y = nil --终点y坐标
				
				--标记飞行时间到结束
				--oAction:doNextAction()
				handleTable.removetime = hGlobal.WORLD.LastWorldMap:gametime()
				oAction.data.tick = 1
				
				--删除技能
				oAction:del()
				
				--添加原地爆炸特效 3097
				--print("添加原地爆炸特效", spriteEffId)
				if (spriteEffId ~= hVar.TRACING_BIAOQIANG_ID) then --非标枪导弹
					world:addeffect(daodanBoomEffectId, 1.0 ,nil, eff_x, screen_eff_y) --56
				end
				--print("添加原地爆炸特效 4")
			end
		end
	end
end