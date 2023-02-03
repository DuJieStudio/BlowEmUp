
local serialize_noline_short = nil
serialize_noline_short = function(obj)
	local lua = ""
	local t = type(obj)
	if (t == "number") then
		lua = lua .. tostring(obj)
	elseif (t == "boolean") then
		lua = lua .. tostring(obj)
	elseif (t == "string") then
		lua = lua .. string.format("%q", obj)
	elseif (t == "table") then
		local bNumber = true
		local nMin = 9999
		local nMax = -9999
		local nCount = 0
		for k, v in pairs(obj) do  
			if (type(k) ~= "number") then
				bNumber = false
				break
			else
				nCount = nCount + 1
				
				if (k < nMin) then
					nMin = k
				end
				
				if (k > nMax) then
					nMax = k
				end
			end
		end
		if bNumber and (nMin == 1) and (nMax == nCount) then
			lua = lua .. "{"
			for i = 1, nCount, 1 do
				lua = lua .. serialize_noline_short(obj[i]) .. ","
			end
			lua = lua .. "}"
		else
			lua = lua .. "{"
			for k, v in pairs(obj) do
				lua = lua .. "[" .. serialize_noline_short(k) .. "]=" .. serialize_noline_short(v) .. ","
			end
			lua = lua .. "}"
		end
	elseif (t == "function") then
		lua = lua .. "\"" .. tostring(obj) .. "\""
	elseif (t == "nil") then
		return nil
	else
		error("can not serialize_noline_short a " .. tostring(t) .. " type.")
	end 
	
	return lua
end

function hApi.serialize_table(obj, bIngoreBrackets)
	local lua = ""
	local t = type(obj)  
	
	if (t == "number") then
		lua = lua .. obj
	elseif (t == "boolean") then
		lua = lua .. tostring(obj)
	elseif (t == "string") then
		lua = lua .. string.format("%q", obj)
	elseif (t == "table") then
		if bIngoreBrackets then
			--
		else
			lua = lua .. "{\n"
		end
		
		local bNumber = true
		local nMin = 9999
		local nMax = -9999
		local nCount = 0
		for k, v in pairs(obj) do  
			if (type(k) ~= "number") then
				bNumber = false
				break
			else
				nCount = nCount + 1
				
				if (k < nMin) then
					nMin = k
				end
				
				if (k > nMax) then
					nMax = k
				end
			end
		end
		if bNumber and (nMin == 1) and (nMax == nCount) then
			for i = 1, nCount, 1 do
				lua = lua .. serialize_noline_short(obj[i]) .. ",\n"
			end
		else
			for k, v in pairs(obj) do
				lua = lua .. "[" .. serialize_noline_short(k) .. "]=" .. serialize_noline_short(v) .. ",\n"
			end
		end
		
		if bIngoreBrackets then
			--
		else
			lua = lua .. "}"
		end
	elseif (t == "function") then
		lua = lua .. "\"" .. tostring(obj) .. "\""
	end
	
	return lua
end


g_xlRsMEditorUnitDataStr = ""
g_xlRsMEditorUnitDataStrSuc = 0

--teleport
local __dealAttrTeleport = function(data)
	local teleports = data.teleport
	if teleports ~= nil then
		for i = 1, #teleports do
			local teleport = teleports[i]
			if #teleport > 1 then
				teleport[1] = teleport[1] + g_xlRsMEditorDx
				teleport[2] = teleport[2] + g_xlRsMEditorDy
				g_xlRsMEditorUnitDataStrSuc = 1
			end
		end
	end
end

--RandPointGroup
local __dealAttrRandPointGroup = function(data)
	local randPointGroups = data.RandPointGroup
	if randPointGroups ~= nil then
		for i = 1, #randPointGroups do
			local randPointGroup = randPointGroups[i]
			if #randPointGroup > 1 then
				for j = 2, #randPointGroup do
					local randPointStrs = hApi.Split(randPointGroup[j], "|")
					randPointStrs[1] = string.gsub(randPointStrs[1], "%(", "")
					local rpx = tonumber(randPointStrs[1]) + g_xlRsMEditorDx
					randPointStrs[2] = string.gsub(randPointStrs[2], "%)", "")
					local rpy = tonumber(randPointStrs[2]) + g_xlRsMEditorDy
					randPointGroup[j] = "(" .. tostring(rpx) .. "|" .. tostring(rpy) .. ")"
					g_xlRsMEditorUnitDataStrSuc = 1
				end
			end
		end
	end
end

--viewReset
local __dealAttrViewReset = function(data)
	local viewResets = data.viewReset
	if viewResets ~= nil then
		if #viewResets > 1 then
			viewResets[1] = viewResets[1] + g_xlRsMEditorDx
			viewResets[2] = viewResets[2] + g_xlRsMEditorDy
			g_xlRsMEditorUnitDataStrSuc = 1
		end
	end
end

--moveToWhere
local __dealAttrMoveToWhere = function(data)
	local moveToWheres = data.moveToWhere
	if moveToWheres ~= nil then
		if #moveToWheres > 1 then
			moveToWheres[1] = moveToWheres[1] + g_xlRsMEditorDx
			moveToWheres[2] = moveToWheres[2] + g_xlRsMEditorDy
			g_xlRsMEditorUnitDataStrSuc = 1
		end
	end
end

local __dealAttrStr1 = function(objs, objId, str, fixStrs)
	for i = 1, #fixStrs do
		local s = string.find(str, fixStrs[i])
		if s ~= nil then
			local newVStr = ""
			local svStrs = hApi.Split(str, ":")
			if #svStrs > 1 then
				newVStr = svStrs[1] .. ":"
				local ns = string.gsub(svStrs[2], "@", "")
				ns = string.gsub(ns, "%)%(", ",")
				ns = string.gsub(ns, "%(", "")
				ns = string.gsub(ns, "%)", "")
				local nStrs = hApi.Split(ns, ",")
				for j = 1, #nStrs, 2 do
					newVStr = newVStr .. "("
					newVStr = newVStr .. tostring(tonumber(nStrs[j]) + g_xlRsMEditorDx)
					newVStr = newVStr .. ","
					newVStr = newVStr .. tostring(tonumber(nStrs[j + 1]) + g_xlRsMEditorDy)
					newVStr = newVStr .. ")"
				end
				newVStr = newVStr .. "@"
				objs[objId] = newVStr
				g_xlRsMEditorUnitDataStrSuc = 1
			end
		end
	end
end

local __dealAttrStr2 = function(objs, objId, str, fixStrs)
	for i = 1, #fixStrs do
		local s = string.find(str, fixStrs[i])
		if s ~= nil then
			local newVStr = ""
			local svStrs = hApi.Split(str, ":")
			if #svStrs > 1 then
				newVStr = svStrs[1] .. ":"
				local ns = string.gsub(svStrs[2], "@", "")
				ns = string.gsub(ns, "%)%(", ",")
				ns = string.gsub(ns, "%(", "")
				ns = string.gsub(ns, "%)", "")
				local nStrs = hApi.Split(ns, ",")
				for j = 1, #nStrs, 5 do
					newVStr = newVStr .. "(" .. nStrs[j]
					newVStr = newVStr .. "," .. nStrs[j + 1]
					newVStr = newVStr .. "," .. tostring(tonumber(nStrs[j + 2]) + g_xlRsMEditorDx)
					newVStr = newVStr .. "," .. tostring(tonumber(nStrs[j + 3]) + g_xlRsMEditorDy)
					newVStr = newVStr .. "," .. nStrs[j + 4] 
					newVStr = newVStr .. ")"
				end
				newVStr = newVStr .. "@"
				objs[objId] = newVStr
				g_xlRsMEditorUnitDataStrSuc = 1
			end
		end
	end
end

local __dealAttrStr3 = function(objs, objId, str, fixStrs)
	for i = 1, #fixStrs do
		local s = string.find(str, fixStrs[i])
		if s ~= nil then
			local newVStr = ""
			local svStrs = hApi.Split(str, ":")
			if #svStrs > 2 then
				newVStr = svStrs[1] .. ":" .. svStrs[2] .. ":"
				local ns = string.gsub(svStrs[3], "@", "")
				local s1 = string.find(svStrs[3], "%)%(")
				if s1 ~= nil then
					ns = string.gsub(ns, "%)%(", ",")
					ns = string.gsub(ns, "%(", "")
					ns = string.gsub(ns, "%)", "")
					local nStrs = hApi.Split(ns, ",")
					for j = 1, #nStrs, 2 do
						newVStr = newVStr .. "("
						newVStr = newVStr .. tostring(tonumber(nStrs[j]) + g_xlRsMEditorDx)
						newVStr = newVStr .. ","
						newVStr = newVStr .. tostring(tonumber(nStrs[j + 1]) + g_xlRsMEditorDy)
						newVStr = newVStr .. ")"
					end
				else
					local nStrs1 = hApi.Split(ns, ",")
					newVStr = newVStr .. tostring(tonumber(nStrs1[1]) + g_xlRsMEditorDx)
					newVStr = newVStr .. ","
					newVStr = newVStr .. tostring(tonumber(nStrs1[2]) + g_xlRsMEditorDx)
				end
				newVStr = newVStr .. "@"
				objs[objId] = newVStr
				g_xlRsMEditorUnitDataStrSuc = 1
			end
		end
	end
end

local __dealAttrStrs = function(data)
	local newVStr = "";
	for k, v in pairs(data) do
		local t = type(v);
		print(k)
		print(t)
		if t == "table" then
			for sk, sv in pairs(v) do
				local st = type(sv);
				if st == "string" then
					__dealAttrStr1(v, sk, sv, {"%]ForceXY:%(", "%]SetXY:%("})
					__dealAttrStr2(v, sk, sv, {"@AddCha:%("})
					__dealAttrStr3(v, sk, sv, {"%]leaveteam:"})
				elseif st == "table" then 
					for ssk, ssv in pairs(sv) do
						local sst = type(ssv);
						if sst == "string" then
							__dealAttrStr1(sv, ssk, ssv, {"%]ForceXY:%(", "%]SetXY:%("})
							__dealAttrStr2(sv, ssk, ssv, {"@AddCha:%("})
							__dealAttrStr3(sv, ssk, ssv, {"%]leaveteam:"})
						end
					end
				end
			end 
		end
	end
end

local __UpdateUnitData = function()
	if units_data == nil then
		return
	end

	for k, v in pairs(units_data) do
		if v ~= nil then 
			__dealAttrTeleport(v)
			__dealAttrRandPointGroup(v)
			__dealAttrViewReset(v)
			__dealAttrMoveToWhere(v)
			__dealAttrStrs(v)
		end
	end

	local unitsDataStr = "units_data = {}\n"
	--print(unitsDataStr)
	for i = 1, #units_data do
		unitsDataStr = unitsDataStr .. "units_data[" .. tostring(i) .."] = "
		--print(unitsDataStr)
		--[[
		local rTab = hApi.SaveTable(units_data[i])
		local data_s = "{"
		if type(rTab) == "table" then
			for j = 1, #rTab do
				data_s = data_s .. rTab[j]
			end
		end
		print(data_s)
		unitsDataStr = unitsDataStr .. data_s .. "\n"
		]]
		local data_s = hApi.serialize_table(units_data[i])
		--print(data_s)
		unitsDataStr = unitsDataStr .. data_s .. "\n"
	end

	g_xlRsMEditorUnitDataStr = unitsDataStr
end

__UpdateUnitData()


