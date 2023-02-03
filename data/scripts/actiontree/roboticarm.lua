local interval = 130 --130������һ��
local sleeptime = 2000
local leaveLength = 260
local wakeLength = 200
local tParam = {
	leavetime = 0,
	lasttime = 0,
}

local _tList = {}

local _Code_ChangeAction = function(target1,target2,dif)
	if target2 then
		local animation = target1:getanimation()
		local ux,uy = target1:getXY()
		local toX,toY = target2:getXY()
		local dx = ux - toX
		local dy = uy - toY
		local dis = math.sqrt(dx * dx + dy * dy)
		if dis < wakeLength then
			_tList[target1.ID].leavetime = 0
		elseif dis > leaveLength then
			_tList[target1.ID].leavetime = _tList[target1.ID].leavetime + dif
		end
		--print(animation,dis,leaveLength)
		--stand ˯��״̬
		--stand2 ��������
		--wakeup ���� ���̶���
		--lie    ���� ���̶���
		--ֻ����stand״̬��  �Żᴥ������ stand2 �ڼ��Ȳ����̶��� ����
		--ֻ����stand2״̬�� �Żᴥ������ stand  �ڼ��Ȳ����̶��� ����
		if animation == "stand" and dis < wakeLength then
			target1:setanimation({"up","stand2"})
		elseif animation == "stand2" and _tList[target1.ID].leavetime > sleeptime then
			target1:setanimation({"down","stand"})
		end
	end
end

hGlobal.event:listen("ActionEvent_ChangeAction_RoboticArm","changeaction",function(target1,target2)
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

hGlobal.event:listen("LocalEvent_ManagerRoboticArmAction","managerAction",function(target1,target2)
	_tList[target1.ID] = hApi.ReadParamWithDepth(tParam,nil,{},3)
	_tList[target1.ID].lasttime = os.clock()
	g_ActionTreeManager.RegisterListener("roboticarm","ActionEvent_ChangeAction_RoboticArm")
	g_ActionTreeManager.RegisterMonitoring("roboticarm",target1,target2)
end)

hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "clearblackdragon",function(sSceneType,oWorld,oMap)
	_tList = {}
end)