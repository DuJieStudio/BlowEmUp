--require "data/scripts/util/extern"


VitrualController = class("VitrualController", function()
	return CCLayer:create()
end)

VitrualController.__index = VitrualController
--VitrualController.DOUBLECLICKTIME = 250 --双击判定时间（毫秒）
VitrualController.DOUBLECLICKTIME = 200 --双击判定时间（毫秒）

VitrualController.MAX_DISTANCE_IDLE = 40 --固定摇杆最大出圈距离
VitrualController.MAX_DISTANCE_MOVE = 80 --跟随摇杆最大出圈距离

function VitrualController:create()
	local vc = VitrualController.new()
	if vc.onCreate then
		vc:onCreate()
	end
	
	return vc
end

function VitrualController:onCreate()
	--【左边摇杆】
	--内圈
	self.joystick = CCSprite:create("data/image/misc/Joystick_04.png") --Joystick_02
	self.joystick:setScale(0.8)
	--self.joystick:setScale(1.3)
	--self.joystick:setColor(ccc3(200,200,200))
	self.joystick:setOpacity(128)
	
	--外圈
	self.joystick_bg = CCSprite:create("data/image/misc/Joystick_05.png") --Joystick_03
	--self.joystick_bg = CCScale9Sprite:create("data/image/misc/Joystick_05.png") --Joystick_03
	self.joystick_bg:setScale(1.4)
	--self.joystick_bg:setContentSize(CCSizeMake(356, 526))
	self.joystick_bg:setOpacity(128)
	self:addChild(self.joystick_bg)
	self:addChild(self.joystick)
	self._directioX = 0
	self._directioY = 0
	self._inner_distance = 18 --响应的最小距离
	self._valid = false
	self._touchIndex = -1
	--【右边按钮】
	self._rightvalid = false
	self._righttouchIndex = -1
	
	--双击判定
	self._clickbegaintime = 0 --上次按下的时间
	self._clickendtime = 0 --上次抬起的时间
	self._doubleclickcount = 0 --双击次数
	
	--local listener = cc.EventListenerTouchAllAtOnce:create()  
	
	--listener:registerScriptHandler(function(...) self:onTouchesBegan(...) end,cc.Handler.EVENT_TOUCHES_BEGAN  )  
	--listener:registerScriptHandler(function(...) self:onTouchesEnded(...) end,cc.Handler.EVENT_TOUCHES_ENDED  )  
	--listener:registerScriptHandler(function(...) self:onTouchesMove(...) end,cc.Handler.EVENT_TOUCHES_MOVED  )  
	--local eventDispatcher = self:getEventDispatcher()  
	--eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	
	--touch事件
	self:setTouchEnabled(true)
	
	--int 	nHandler,
	--bool 	bIsMultiTouches = false,
	--int 	nPriority = INT_MIN,
	--bool 	bSwallowsTouches = false
	--print("touch事件 registerScriptTouchHandler")
	self:registerScriptTouchHandler(function(event,...)
		return self:onTouchCode(event,...)
	end,true,0,false) --true 挡
	
	--键盘事件
	--self:setKeypadEnabled(true)
	--self:registerScriptKeypadHandler(function(keyCode, event)
	--	print(keyCode, event)
	--end)
	
	self:_deactive()
end  
  
function VitrualController:_active(pos,touchIndex)
	self.joystick:setPosition(pos)  
	self.joystick_bg:setPosition(pos)  
	self.joystick:setVisible(true)  
	self.joystick_bg:setVisible(true)  
	self._directioX = 0
	self._directioY = 0
	self._valid = true
	self._touchIndex = touchIndex
end  
  
function VitrualController:_deactive(touchIndex)
	if touchIndex == nil or self._touchIndex == touchIndex then
		self.joystick:setVisible(false)
		self.joystick_bg:setVisible(false)
		self._directioX = 0
		self._directioY = 0
		self._valid = false
		self._touchIndex = -1
	end
end

--右边操控
function VitrualController:_rightactuve(touchIndex)
	self._rightvalid = true
	self._righttouchIndex = touchIndex
end

function VitrualController:_rightdeactive(touchIndex)
	if touchIndex == nil or self._righttouchIndex == touchIndex then
		self._rightvalid = false
		self._righttouchIndex = -1
	end
end

function VitrualController:onTouchCode(event,...)
	--print(debug.traceback())
	--  ...本身就是一个table  存放着多个触控点 列如{x1,y1,index1,x2,y2,index2} 每三个参数是一个坐标点信息
	local touch_list = ...
	local touch_group = {}
	for i = 1, math.ceil(#touch_list/3) do
		touch_group[i]={touch_list[i*3-2],touch_list[i*3-1],touch_list[i*3]}
	end
	--print("touch_group=", #touch_group)
	for i = 1,#touch_group do
		local touchPoint = touch_group[i]
		if event == 'began' then
			--print("began",touchX,touchY)
			return self:onTouchesBegan(touchPoint)
		end
		
		if event == 'moved' then
			--print("moved")
			self:onTouchesMove(touchPoint)
		elseif event == 'ended' then
			--print("ended")
			self:onTouchesEnded(touchPoint)
		end
	end
end

--function VitrualController:onTouchesBegan(touchX, touchY)
function VitrualController:onTouchesBegan(touch)
	local bIsInsideTacticCard = false
	
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
		for i = 1, #tacticCardCtrls, 1 do
			local cardi = tacticCardCtrls[i]
			if cardi and (cardi ~= 0) then
				if (cardi.data.selected == 1) then --战术技能卡是选中状态
					--print("onTouchesBegan selected")
					if (world.data.keypadWASD ~= "----") then
						self._valid = false
						return false
					end
				end
			end
		end
		
		--避开操作按钮
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏模式
			if (world.data.map ~= hVar.MainBase) then --基地无需避开
				--模拟点击
				for i = 1, #tacticCardCtrls, 1 do
					local cardi = tacticCardCtrls[i]
					if cardi and (cardi ~= 0) then
						local btn_x = cardi.data.x
						local btn_y = cardi.data.y
						local btn_w = cardi.data.w
						local btn_h = cardi.data.h
						local btn_left = btn_x - btn_w / 2
						local btn_right = btn_x + btn_w / 2
						local btn_top = btn_y - btn_h / 2
						local btn_bottom = btn_y + btn_h / 2
						
						local screenX = touch[1]
						local screenY = touch[2]
						--print(screenX, screenY)
						--print(i)
						--print(btn_left, btn_right)
						--print(btn_top, btn_bottom)
						--print()
						if (screenX >= btn_left) and (screenX <= btn_right) and (screenY >= btn_top) and (screenY <= btn_bottom) then
							--print("hit", i)
							
							cardi.data.codeOnTouch(cardi)
							
							--return true
							if (i == hVar.NORMALATK_IDX) then
								bIsInsideTacticCard = true
							else
								return
							end
						end
					end
				end
			end
		end
	end
	
	--在屏幕右下区域，不响应摇杆
	--if (touch[1] > hVar.SCREEN.w/2) and (touch[2] < hVar.SCREEN.h/2) then
		--return
	--end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--存在黑龙scene，不处理
	if (__G_SelectMapWorld ~= nil) then
		return
	end
	
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		if (touch[1] < hVar.SCREEN.w/2) then
			--if self._valid then
				--return
			--end
			self.start_pos = ccp(touch[1],touch[2])  
			self:_active(self.start_pos,touch[3])
			
			--触发事件
			hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "begin", self, 0, 0, 0)
			--print("VitrualController udpate", "begin")
			
			return true
		else
			local tParam = {}
			hGlobal.event:event("Event_BeginAutoAttack",touch,tParam)
			if tParam[1] == hVar.RESULT_SUCESS then
				self:_rightactuve(touch[3])
			end
		end
	elseif (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏模式
		--竖屏界面左右侧边界不响应的范围
		local INGORE_EDIGE = 20
	--	if (touch[1] > INGORE_EDIGE) and (touch[1] < (hVar.SCREEN.w - INGORE_EDIGE)) and (touch[2] < hVar.SCREEN.h/2) and (touch[1] < hVar.SCREEN.w/2) then
		if (touch[1] > INGORE_EDIGE) and (touch[1] < (hVar.SCREEN.w - INGORE_EDIGE)) --x
		and (touch[2] < hVar.SCREEN.h*0.7) and (touch[2] > 50) then --y
			--print("bIsInsideTacticCard=", bIsInsideTacticCard)
			if (not bIsInsideTacticCard) then
				--if self._valid then
					--return
				--end
				self.start_pos = ccp(touch[1],touch[2])  
				self:_active(self.start_pos,touch[3])
				
				--双击判定
				self._clickbegaintime = os.clock() * 1000 --上次按下的时间（毫秒）
				--print("按下", self._clickbegaintime)
				
				local deltatime = self._clickbegaintime - self._clickendtime
				--print("deltatime", deltatime)
				if (deltatime <= VitrualController.DOUBLECLICKTIME) then
					--
				else
					self._doubleclickcount = 0 --双击次数
				end
				
				--触发事件
				hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "begin", self, 0, 0, 0)
				--print("VitrualController udpate", "begin")
				
				--改成按下时doubleclick
				if self._valid and touch[3] == self._touchIndex then
					--双击判定
					self._clickendtime = os.clock() * 1000 --上次按下的时间（毫秒）
					--print("抬起", self._clickendtime)
					local deltatime = self._clickendtime - self._clickbegaintime
					--print("deltatime", deltatime)
					
					if (deltatime <= VitrualController.DOUBLECLICKTIME) then
						self._doubleclickcount = self._doubleclickcount + 1 --双击次数
						--双击事件
						if (self._doubleclickcount >= 2) then
							--虚拟摇杆双击事件
							hGlobal.event:event("LocalEvent_VitrualControllerTouchDoubleClick")
							--print("虚拟摇杆双击事件")
							self._doubleclickcount = 0
						end
					end
				end
				
				--0.25秒后触发按下事件（跟双击区分）
				if (VitrualController.DOUBLECLICKTIME == 0) then
					--虚拟摇杆按下事件
					hGlobal.event:event("LocalEvent_VitrualControllerTouchBegin", touch[1], touch[2])
				else
					hApi.addTimerOnce("__Timer_Virtual__Began__", VitrualController.DOUBLECLICKTIME, function()
						--虚拟摇杆按下事件
						hGlobal.event:event("LocalEvent_VitrualControllerTouchBegin", touch[1], touch[2])
						print("虚拟摇杆按下事件")
					end)
				end
				
				--geyacao: 竖屏可以重叠
				--return true
			end
		end
		
		--geyacao: 竖屏可以重叠
		local tParam = {}
		hGlobal.event:event("Event_BeginAutoAttack",touch,tParam)
		if tParam[1] == hVar.RESULT_SUCESS then
			self:_rightactuve(touch[3])
		end
	end
end

function VitrualController:onTouchesEnded(touch)
	--print("VitrualController:onTouchesEnded", touch)
	--移除按下事件timer
	hApi.clearTimer("__Timer_Virtual__Began__")
	
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
		for i = 1, #tacticCardCtrls, 1 do
			local cardi = tacticCardCtrls[i]
			if cardi and (cardi ~= 0) then
				if (cardi.data.selected == 1) then --战术技能卡是选中状态
					--print("onTouchesEnded selected")
					if (world.data.keypadWASD ~= "----") then
						--print("战术技能卡是选中状态 return false")
						return false
					end
				end
			end
		end
		
		--避开操作按钮
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏模式
			--模拟点击
			for i = 1, #tacticCardCtrls, 1 do
				local cardi = tacticCardCtrls[i]
				if cardi and (cardi ~= 0) then
					local btn_x = cardi.data.x
					local btn_y = cardi.data.y
					local btn_w = cardi.data.w
					local btn_h = cardi.data.h
					local btn_left = btn_x - btn_w / 2
					local btn_right = btn_x + btn_w / 2
					local btn_top = btn_y - btn_h / 2
					local btn_bottom = btn_y + btn_h / 2
					
					local screenX = touch[1]
					local screenY = touch[2]
					--print(screenX, screenY)
					--print(i)
					--print(btn_left, btn_right)
					--print(btn_top, btn_bottom)
					--print()
					if (screenX >= btn_left) and (screenX <= btn_right) and (screenY >= btn_top) and (screenY <= btn_bottom) then
						--print("hit", i)
						cardi.data.code(cardi)
						
						--取消可能的其他按钮的选中状态
						for j = 1, #tacticCardCtrls, 1 do
							local btnj = tacticCardCtrls[j]
							if btnj and (btnj ~= 0) then
								if (btnj ~= cardi) then --不是自己
									if (btnj.data.selected == 1) then
										hApi.safeRemoveT(btnj.childUI, "selectbox") --删除选中特效
										btnj.data.selected = 0
										
										--针对TD对地面有效的非障碍点地方，靠近能量圈附近，取消能量塔的能量圈
										if (btnj.data.skillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then
											local tabS = hVar.tab_skill[btnj.data.skillId]
											local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
											local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
											--print(energy_unit_id, energy_build_radius)
											if (energy_unit_id > 0) then
												--显示地图上全部充能塔的建造半径
												local world = hGlobal.WORLD.LastWorldMap
												world:enumunit(function(eu)
													local typeId = eu.data.id --类型id
													if (typeId == energy_unit_id) then
														hApi.safeRemoveT(eu.chaUI, "TD_AtkRange")
													end
												end)
											end
										end
									end
								end
							end
						end
						
						--print("模拟点击 return true")
						--return true
					end
				end
			end
		end
		
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏
			--
		else
			--world.data.weapon_attack_state = 0
		end
	end
	
	if self._valid and touch[3] == self._touchIndex then
		--双击判定
		self._clickendtime = os.clock() * 1000 --上次按下的时间（毫秒）
		--print("抬起", self._clickendtime)
		local deltatime = self._clickendtime - self._clickbegaintime
		--print("deltatime", deltatime)
		
		--[[
		if (deltatime <= VitrualController.DOUBLECLICKTIME) then
			self._doubleclickcount = self._doubleclickcount + 1 --双击次数
			
			--双击事件
			if (self._doubleclickcount >= 2) then
				--虚拟摇杆双击事件
				hGlobal.event:event("LocalEvent_VitrualControllerTouchDoubleClick")
				--print("虚拟摇杆双击事件")
				
				self._doubleclickcount = 0
			end
		else
			self._doubleclickcount = 0 --双击次数
			
			--虚拟摇杆单击事件
			hGlobal.event:event("LocalEvent_VitrualControllerTouchClick")
		end
		]]
		--虚拟摇杆单击事件
		hGlobal.event:event("LocalEvent_VitrualControllerTouchClick")
		
		
		
		
		--print("双击次数", self._doubleclickcount)
		
		self:_deactive(touch[3])
		
		--触发事件
		hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "end", self, 0, 0, 0)
		--print("VitrualController udpate", "end")
	elseif self._rightvalid and touch[3] == self._righttouchIndex then
		self:_rightdeactive(touch[3])
		hGlobal.event:event("Event_CloseAutoAttack")
	end
end

function VitrualController:onTouchesMove(touch)
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
		for i = 1, #tacticCardCtrls, 1 do
			local cardi = tacticCardCtrls[i]
			if cardi and (cardi ~= 0) then
				if (cardi.data.selected == 1) then --战术技能卡是选中状态
					--print("onTouchesMove selected")
					if (world.data.keypadWASD ~= "----") then
						return false
					end
				end
			end
		end
	end
	
	if self._valid and touch[3] == self._touchIndex then
		local pos = ccp(touch[1], touch[2])
		local distance = ccpDistance(self.start_pos, pos)
		local direction = ccpNormalize(ccpSub(pos,self.start_pos))
		self:_update(direction, distance)
		
		--触发事件
		if (distance >= self._inner_distance) then
			--print("滑动")
			--清空双击判定
			self._clickbegaintime = 0 --上次按下的时间
			self._clickendtime = 0 --上次抬起的时间
			self._doubleclickcount = 0 --双击次数
			
			hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "move", self, direction.x, direction.y, distance)
			--主基地监控对话事件
			--hGlobal.event:event("Event_CheckMainBaseTalkEvent")
		else
			hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "end", self, direction.x, direction.y, distance)
		end
		--print("VitrualController udpate", "move", direction.x, direction.y, distance)
	elseif self._rightvalid and touch[3] == self._righttouchIndex then
		local tParam = {}
		hGlobal.event:event("Event_CheckAutoAttack",touch,tParam)
	end
end  



function VitrualController:_update(direction, distance)
	self._directioX = direction.x
	self._directioY = direction.y
	
	local start = self.start_pos
	
	local MAX_DISTANCE = 0
	if (hVar.OPTIONS.VIRTUAL_CONTROL_MOVE == 1) then --跟随摇杆
		MAX_DISTANCE = VitrualController.MAX_DISTANCE_MOVE
	else --固定摇杆
		MAX_DISTANCE = VitrualController.MAX_DISTANCE_IDLE
	end
	
	local STRENGTH = 0.9 --倍率
	distance = distance * STRENGTH
	
	if (distance < MAX_DISTANCE) then
		self.joystick:setPosition(ccpAdd(start, (ccpMult(direction, distance))))
	else
		if (hVar.OPTIONS.VIRTUAL_CONTROL_MOVE == 1) then --跟随摇杆
			--self.joystick:setPosition(ccpAdd(start , (ccpMult(direction, MAX_DISTANCE))))
			local deltaDis = distance - MAX_DISTANCE
			start = ccpAdd(start, (ccpMult(direction, deltaDis)))
			self.start_pos = start
			self.joystick_bg:setPosition(start)
			self.joystick:setPosition(ccpAdd(start, (ccpMult(direction, distance))))
			
		else --固定摇杆
			self.joystick:setPosition(ccpAdd(start , (ccpMult(direction, MAX_DISTANCE))))
		end
	end 
end

--删除
function VitrualController:destroy()
	--print(debug.traceback())
	self:getParent():removeChild(self, true)
end

--未处理的抬起事件
function xlLuaEvent_TouchMoveUp()
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local vc = hGlobal.WORLD.VitrualController
		if vc then
			local touch = {0,0,}
			--print("未处理的抬起事件")
			vc:onTouchesEnded(touch)
		end
	end
end