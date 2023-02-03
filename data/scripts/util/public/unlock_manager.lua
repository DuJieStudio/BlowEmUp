--解锁关系管理
local _unlock_manager = {
	_haveinit = 0,
	_typelist = {},
	UnlockFunction = {},
}
local _unlock_type = {
	"petarea",			--宠物区域
	"tacticsarea",			--战术卡区域
	"entertainmentarea",		--娱乐地图区域
	"entertainmentarea2",		--娱乐地图区域2
	"viparea",			--Vip区域
}

local _unlock_condition = {
	["petarea"] = {	
		clearmap = "world/yxys_spider_04",
	},
	["tacticsarea"] = {	
		clearmap = "world/yxys_airship_04",
	},
	["entertainmentarea"] = {
		clearmap = "world/yxys_zerg_004",
	},
	["entertainmentarea2"] = {
		clearmap = "world/yxys_zerg_004",
	},
	["viparea"] = {
		clearmap = "world/yxys_spider_04",
	},
}

_unlock_manager.Init = function()
	for i = 1,#_unlock_type do
		local typename = _unlock_type[i]
		_unlock_manager._typelist[typename] = i
	end
	_unlock_manager._haveinit = 1
end

_unlock_manager.UnlockFunction["clearmap"] = function(mapname)
	local isFinishFirstMap = LuaGetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第0关
	print("clearmap",mapname,isFinishFirstMap)
	return isFinishFirstMap
end

_unlock_manager.IsUnlock = function(typename)
	local nState = 0
	if _unlock_manager._haveinit == 0 then
		_unlock_manager.Init()
	end
	if _unlock_manager._typelist[typename] then
		local unlockCondition = _unlock_condition[typename]
		if type(unlockCondition) == "table" then
			local state = 1
			for funcName,tParam in pairs(unlockCondition) do
				if type(_unlock_manager.UnlockFunction[funcName]) == "function" then
					state = _unlock_manager.UnlockFunction[funcName](tParam)
					if state ~= 1 then
						break
					end
				end
			end
			if state == 1 then
				nState = 1
			end
		end
	end
	print("nState",nState)
	return nState
end

hApi.GetUnlockStateByName = function(typename)
	print("hApi.GetUnlockStateByName",typename)
	return _unlock_manager.IsUnlock(typename)
end