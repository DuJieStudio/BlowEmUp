local interval = 130 --130毫秒检测一次
local sleeptime = 10000
local leaveLength = 240
local wakeLength = 200
local tParam = {
	leavetime = 0,
	lasttime = 0,
}

local _tList = {}

local _Code_ChangeAction = function(target1,target2,dif)
	--print("_Code_ChangeAction",target1,target2,dif)
	
	if target2 then
		local animation = target1:getanimation()
		local animation2 = target2:getanimation()
		local ux,uy = target1:getXY()
		local toX,toY = target2:getXY()
		local dx = ux - toX
		local dy = uy - toY
		local dis = math.sqrt(dx * dx + dy * dy)
		if dis <= wakeLength then
			--if (animation2 == "stand") then
				_tList[target1.ID].leavetime = 0
				hGlobal.event:event("LocalEvent_showblackdragonshopbtn",1)
			--end
		elseif dis > leaveLength then
			--if (animation2 == "stand") then
				_tList[target1.ID].leavetime = _tList[target1.ID].leavetime + dif
				hGlobal.event:event("LocalEvent_showblackdragonshopbtn",-1)
			--end
		end
		--print(animation,dis,leaveLength)
		--stand 睡觉状态
		--stand2 待机动作
		--wakeup 起身 过程动画
		--lie    躺下 过程动画
		--只有在stand状态下  才会触发进入 stand2 期间先播过程动画 起身
		--只有在stand2状态下 才会触发进入 stand  期间先播过程动画 躺下
		if animation == "stand" and dis < wakeLength then
			target1:setanimation({"wakeup","stand2"})
		elseif animation == "stand2" and _tList[target1.ID].leavetime > sleeptime then
			target1:setanimation({"lie","stand"})
		end
	end
end

hGlobal.event:listen("ActionEvent_ChangeAction_BlackDragon","changeaction",function(target1,target2)
	if target1 and target1.ID and _tList[target1.ID] then
		local localTime = os.clock()
		local last = _tList[target1.ID].lasttime
		local dif = (localTime - last) * 1000
		if dif > interval then
			_tList[target1.ID].lasttime = localTime
			_Code_ChangeAction(target1,target2,dif)
		end
		
	end
end)

hGlobal.event:listen("LocalEvent_ManagerBlackDragonAction","managerAction",function(target1,target2)
	_tList[target1.ID] = hApi.ReadParamWithDepth(tParam,nil,{},3)
	_tList[target1.ID].lasttime = os.clock()
	g_ActionTreeManager.RegisterListener("blackdragon","ActionEvent_ChangeAction_BlackDragon")
	g_ActionTreeManager.RegisterMonitoring("blackdragon",target1,target2)
end)

hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "clearblackdragon",function(sSceneType,oWorld,oMap)
	_tList = {}
end)


