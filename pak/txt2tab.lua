local last_txt = ""

function line_split(l,reps)
	local res = {}
	string.gsub(l,'[^' .. reps .. ']+',function(w)table.insert(res,w)end)
	return res
end

function br2string(s)
	if '<nil>' == s then return '' end
	s = string.gsub(s,'"','');
	return string.gsub(s,"<br>","\\n");
end

function txt2luaAS(t)
	local v = br2string(t[5])
	local txt = string.format('%s[\"%s\"] = \"%s\"\n',t[2],t[3],v)
	return txt
end
function txt2luaAT(t)
	local s = ''
	for i = 5,#t,2 do
		local v = br2string(t[i])
		s = s .. '\t\"' .. v .. '\",\n'
	end
	local txt = string.format('%s[\"%s\"] = {\n%s}\n',t[2],t[3],s)
	return txt
end

function txt2luaIS(t)
	local v = br2string(t[5])
	local txt = string.format('%s[%d] = \"%s\"\n',t[2],tonumber(t[3]),v)
	return txt
end
function txt2luaIT(t)
	local s = ''
	for i = 5,#t,2 do
		local v = br2string(t[i])
		s = s .. '\t\"' .. v .. '\",\n'
	end
	local txt = string.format('%s[%d] = {\n%s}\n',t[2],tonumber(t[3]),s)
	return txt
end

function txt2tab(name)
	local f = io.open(name,r)
	local lua = ""
	for line in f:lines() do
		local t = line_split(line,'\t')
		if 3 < #t then
			if 'as' == t[1] then
				lua = lua .. txt2luaAS(t)
			elseif 'at' == t[1] then
				lua = lua .. txt2luaAT(t)
			elseif 'is' == t[1] then
				lua = lua .. txt2luaIS(t)
			elseif 'it' == t[1] then
				lua = lua .. txt2luaIT(t)
			end
		end
	end
	last_txt = lua
	--print(lua)
end

function write2lua(name)
	if 0 < string.len(last_txt) then
		local f = io.open(name,"w")
		if f then
			f:write(last_txt)
			f:close()
		end
	end
end

function test()
	local f = io.open('tab_string.txt',r)
	print(f:read())
	f:close()
end

function main()
	txt2tab('tab_string.txt')
	write2lua("tab_string.o")
	--test()
end

main()