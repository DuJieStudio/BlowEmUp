g_ActionTreeManager = {}

local _tListener = {}
local _tManager = {}

local monitoring_turnon = false
g_ActionTreeManager.StartMonitoring = function()
	if monitoring_turnon == false then
		monitoring_turnon = true
		hApi.addTimerForever("ActionTreeManager",hVar.TIMER_MODE.GAMETIME,10,function()
			g_ActionTreeManager.Run()
		end)
	end
end

g_ActionTreeManager.StopMonitoring = function()
	monitoring_turnon = false
	hApi.clearTimer("ActionTreeManager")
end

g_ActionTreeManager.Clear = function()
	_tManager = {}
	_tListener = {}
end

g_ActionTreeManager.Run = function()
	if monitoring_turnon then
		for key,tList in pairs(_tManager) do
			for _,tTarget in pairs(tList) do
				local target1,target2 = unpack(tTarget)
				if _tListener[key] then
					hGlobal.event:event(_tListener[key],target1,target2)
				end
			end
		end
	end
end

g_ActionTreeManager.RegisterListener = function(key,sListener)
	_tListener[key] = sListener
end

g_ActionTreeManager.RegisterMonitoring = function(key,target1,target2)
	if _tManager[key] == nil then
		_tManager[key] = {}
	end
	_tManager[key][target1.ID] = {target1,target2}
end

hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "clearactiontreemanager",function(sSceneType,oWorld,oMap)
	--如果是从基地切换到黑龙，或者黑龙切换到基地，不处理
	if (hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR == 1) then
		--
	else
		g_ActionTreeManager.StopMonitoring()
		g_ActionTreeManager.Clear()
	end
end)