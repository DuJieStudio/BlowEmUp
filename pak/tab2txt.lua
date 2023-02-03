local last_txt = ""

function string2br(s)
	if 0 == string.len(s) then return '<nil>' end
	return string.gsub(s,"\n","<br>")
end

function tab2string(t,name,k)
	local s = name .. '\t' .. tostring(k)
	for i = 1,#t do
		s = s .. '\t' .. string2br(tostring(t[i])) .. '\t<translation>'
	end
	s = s .. '\n'
	return s
end

function get_key_list(t)
	local tk = {}
	if type(t) == "table" then
		for k,_ in pairs(t) do  
			table.insert(tk,k)  
		end 
		table.sort(tk)
	end

	return tk
end

function tab2txtAS(t,name)
	print(name,"aaa","begin")
	local tt = get_key_list(t)
	local iCount = 0
	local txt = ""
	if 0 < #tt then
		iCount = iCount + #tt
		for i = 1,#tt do
			print(tt[i])
			txt = txt .. 'as\t' .. name .. '\t' .. tt[i] .. '\t' .. string2br(t[tt[i]]) .. '\t<translation>\n'
		end
	end
	if 0 < iCount then last_txt = last_txt .. txt end
	print(txt)
	print(name,iCount,"end")
end

function tab2txtAT(t,name)
	print(name,"BBB","begin")
	local tt = get_key_list(t)
	local iCount = 0
	local txt = ""
	if 0 < #tt then
		iCount = iCount + #tt
		for i = 1,#tt do
			if type(t[tt[i]]) == "table" and 0 < #t[tt[i]] then
				txt = txt .. 'at\t' .. tab2string(t[tt[i]],name,tt[i])
			end
			--txt = txt .. name .. '\t' .. tt[i] .. '\t' .. string2br(t[tt[i]]) .. '\n'
		end
	end
	if 0 < iCount then last_txt = last_txt .. txt end
	print(txt)
	print(name,iCount,"end")
end

function tab2txtIS(t,name)
	print(name,tonumber(#t),table.maxn(t),"begin")
	local iCount = 0
	if type(t) == "table" then
		local txt = ""
		for i = 1,table.maxn(t) do
			iCount = iCount + 1
			txt = txt .. 'is\t' .. name .. '\t' .. tostring(i) .. '\t' .. string2br(t[i]) .. '\t<translation>\n'
		end
		if 0 < iCount then last_txt = last_txt .. txt end
		print(txt)
	end
	print(name,iCount,"end")
end

function tab2txtIT(t,name)
	print(name,tonumber(#t),table.maxn(t),"begin")
	local iCount = 0
	if type(t) == "table" then
		local txt = ""
		for i = 1,table.maxn(t) do
			if type(t[i]) == "table" and 0 < #(t[i]) then
				iCount = iCount + 1
				txt = txt .. 'it\t' .. tab2string(t[i],name,i)
			end
		end
		if 0 < iCount then last_txt = last_txt .. txt end
		print(txt)
	end
	print(name,iCount,"end")
end

function write2txt(name)
	if 0 < string.len(last_txt) then
		local f = io.open(name,"w")
		if f then
			f:write(last_txt)
			f:close()
		end
	end
end

function main()
	tab2txtAS(g_string.tab_string,'_tab_string')		-- 这个表比较特殊 不是数字key而是字符串的key 同时内容不是约定的 {"info1","info2","info3",...}
								-- 同时里面的内容包含'\n' 这个会导致txt里自动换行了。。。

	tab2txtAT(g_string.tab_stringM,'_tab_stringM')		--tab2txtAT表示[k:string v:table]
---[[
	tab2txtIT(g_string.tab_stringU,'_tab_stringU')			--tab2txtIT表示[k:int v:table]
	tab2txtIT(g_string.tab_stringH,'_tab_stringH')
	tab2txtIT(g_string.tab_stringS,'_tab_stringS')
	tab2txtIT(g_string.tab_stringSH,'_tab_stringSH')
	tab2txtIT(g_string.tab_stringI,'_tab_stringI')
	tab2txtIT(g_string.tab_stringIE,'_tab_stringIE')
	tab2txtIT(g_string.tab_stringME,'_tab_stringME')
	tab2txtIT(g_string.tab_stringGIFT,'_tab_stringGIFT')
	tab2txtIT(g_string.tab_stringT,'_tab_stringT')
	tab2txtIT(g_string.tab_stringQ,'_tab_stringQ')
	tab2txtIT(g_string.tab_stringR,'_tab_stringR')
	tab2txtIT(g_string.tab_stringCH,'_tab_stringCH')
	tab2txtIT(g_string.tab_stringTR,'_tab_stringTR')
	tab2txtIT(g_string.tab_stringTF,'_tab_stringTF')
	--tab2txtIT(g_string.tab_stringA,'_tab_stringA')
--	]]
									
	tab2txtIS(g_fail_hint_info_map01,'g_fail_hint_info_map01')	--tab2txtIS表示[k:int v:string]	
	tab2txtIS(g_fail_hint_info_map02,'g_fail_hint_info_map02')
	tab2txtIS(g_fail_hint_info_map03,'g_fail_hint_info_map03')
	tab2txtIS(g_fail_hint_info,'g_fail_hint_info')
	tab2txtIS(g_fail_hint_info_map_yyz1,'g_fail_hint_info_map_yyz1')
	tab2txtIS(g_fail_hint_info_map_yyz2,'g_fail_hint_info_map_yyz2')
	tab2txtIS(g_fail_hint_info_map_yyz3,'g_fail_hint_info_map_yyz3')
	tab2txtIS(g_fail_hint_info_map_yyz4,'g_fail_hint_info_map_yyz4')
	tab2txtIS(g_fail_hint_info_map_ssxz1,'g_fail_hint_info_map_ssxz1')
	tab2txtIS(g_fail_hint_info_map_ssxz2,'g_fail_hint_info_map_ssxz2')

	write2txt("tab_string.txt")
end

main()