--------------------------------------------------------------------
--工具文件 

-- 工具1
--用来把lua的表全部打印 包括元表
local function _list_table(tb, table_list, level)
	local ret = ""
	local indent = string.rep(" ", level*4)

	for k, v in pairs(tb) do
		local quo = type(k) == "string" and "\"" or ""
		ret = ret .. indent .. "[" .. quo .. tostring(k) .. quo .. "] = "

		if type(v) == "table" then
			local t_name = table_list[v]
			if t_name then
				ret = ret .. tostring(v) .. " -- > [\"" .. t_name .. "\"]\n"
			else
				table_list[v] = tostring(k)
				ret = ret .. "{\n"
				ret = ret .. _list_table(v, table_list, level+1)
				ret = ret .. indent .. "}\n"
			end
		elseif type(v) == "string" then
			ret = ret .. "\"" .. tostring(v) .. "\"\n"
		else
			ret = ret .. tostring(v) .. "\n"
		end
	end

	local mt = getmetatable(tb)
	if mt then 
		ret = ret .. "\n"
		local t_name = table_list[mt]
		ret = ret .. indent .. "<metatable> = "

		if t_name then
			ret = ret .. tostring(mt) .. " -- > [\"" .. t_name .. "\"]\n"
		else
			ret = ret .. "{\n"
			ret = ret .. _list_table(mt, table_list, level+1)
			ret = ret .. indent .. "}\n"
		end
	end
	return ret
end

function table_tostring(tb)
	if type(tb) ~= "table" then
		error("Sorry, it's not table, it is " .. type(tb) .. ".")
		print(debug.traceback())
		return
	end

	local ret = " = {\n"
	local table_list = {}
	table_list[tb] = "root table"
	ret = ret .. _list_table(tb, table_list, 1)
	ret = ret .. "}"
	return ret
end


function table_print(tb)
	print(tostring(tb) .. table_tostring(tb))
end

StringToTable = function(str)
	local tTable = {}
	if type(str) == "string" then
		local sFunc = "function GetTableFromString() return " .. str .. " end"
		local f = loadstring(sFunc)
		if type(f) == "function" then
			f()
		end
		if type(GetTableFromString) == "function" then
			local tTemp = GetTableFromString()
			if type(tTemp) == "table" then
				tTable = tTemp
			end
		end
		GetTableFromString = API.DoNothing
	end
	return tTable
end

--table转字符串
TableToString = function(t,mode)
	if "table" == type(t) then
		local sString = "{"
		for k,v in pairs(t) do
			if "number" == type(k) then
				sString = sString .. "[" .. tonumber(k) .. "]="
			else
				sString = sString .. tostring(k) .. "="
			end
    
			if "number" == type(v) then
				sString = sString .. tostring(v) .. ","
			elseif "string" == type(v) then
				if mode == 1 then
					sString = sString .. "[==[" .. tostring(v) .. "]==],"
				else
					sString = sString .. "\"" .. tostring(v) .. "\","
				end
			elseif "table" == type(v) then
				sString = sString .. TableToString(v) .. ","
			end
		end
		return sString .. "}"
	else
		return "nil"
	end
end

-- for test 测试用代码
--local test_table_2 = {
	--print,
--}

--local test_table_1 = {
	--12, 22.5, true, 
	--info = {
		--name = "Jack", 
		--age = 26,
		--lifeexp = {
			--["1986"] = "Both",
			--["2013"] = "Work in Tencent",
			--["2015"] = "Get married"
		--}, 
		--wife = "Lucy"
	--},
	--"Hello test",
	--recu_table = test_table_2,
	--["2"] = 13
--}

--test_table_2.recu_table = test_table_1

--local metatable = {
	--__index = test_table_2,    
	--__add = function(a, b) return 0 end
--}

--setmetatable(test_table_1, metatable)

--function table_lib_test()
	--table_print(test_table_1)
--end

--table_lib_test()