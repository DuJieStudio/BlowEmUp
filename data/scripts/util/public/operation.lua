--[[

--指令转字符串
hVar.Cmd2StringFunc = {}

--移动指令
hVar.Cmd2StringFunc[hVar.Operation.Move] = function(cha_worldI, cha_typeId, worldX, worldY, t_worldI, t_worldC)
	local result = string.format("%d_%d_%d_%d_%d_%d_%d;", hVar.Operation.Move, cha_worldI, cha_typeId, worldX, worldY, t_worldI, t_worldC)
	return result
end

--使用战术卡指令
hVar.Cmd2StringFunc[hVar.Operation.UseTacticCard] = function(tacticId, itemId, worldX, worldY)
	local result = string.format("%d_%d_%d_%d_%d;", hVar.Operation.UseTacticCard, tacticId, itemId, worldX, worldY)
	return result
end

--建造塔指令
hVar.Cmd2StringFunc[hVar.Operation.BuildTower] = function(t_worldI, t_worldC, buildId, goldCost)
	local result = string.format("%d_%d_%d_%d_%d;", hVar.Operation.BuildTower, t_worldI, t_worldC, buildId, goldCost)
	return result
end

--升级塔科技指令
hVar.Cmd2StringFunc[hVar.Operation.UpgrateTowerSkill] = function(t_worldI, t_worldC, skillId, skillLvNow, goldCost)
	local result = string.format("%d_%d_%d_%d_%d_%d;", hVar.Operation.UpgrateTowerSkill, t_worldI, t_worldC, skillId, skillLvNow, goldCost)
	return result
end

--卖塔指令
hVar.Cmd2StringFunc[hVar.Operation.SellTower] = function(t_worldI, t_worldC)
	local result = string.format("%d_%d_%d;", hVar.Operation.SellTower, t_worldI, t_worldC)
	return result
end

--使用建筑的技能指令
hVar.Cmd2StringFunc[hVar.Operation.CastBuildingSkill] = function(t_worldI, t_worldC, skillId, casttype, goldCost)
	local result = string.format("%d_%d_%d_%d_%d_%d;", hVar.Operation.CastBuildingSkill, t_worldI, t_worldC, skillId, casttype, goldCost)
	return result
end

--将指令转为字符串
hVar.Cmd2StringStr = ""
hApi.Command2String = function(cmd_type, ...)
	if hVar.Cmd2StringFunc[cmd_type] then
		local result = hVar.Cmd2StringFunc[cmd_type](...)
		hVar.Cmd2StringStr = hVar.Cmd2StringStr .. result
	end
	
	return hVar.Cmd2StringStr
end
]]