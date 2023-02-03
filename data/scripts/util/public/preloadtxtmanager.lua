PreloadTxtManager = {}
PreloadTxtManager.tState = {}
PreloadTxtManager.data = {}
PreloadTxtManager.func = {}

--lua中测试输出
local _testluashow = 0

--预加载文字 类型id列表
local _tTypeIdList = {
	3,
	2,
	1,
}

PreloadTxtManager.func.Init = function()
	if PreloadTxtManager.haveInit ~= 1 then
		PreloadTxtManager.haveInit = 1
		PreloadTxtManager.data = {}
		PreloadTxtManager.tState = {}
		PreloadTxtManager.data.cncache = {}
		PreloadTxtManager.data.jpcache = {}
		PreloadTxtManager.data.encache = {}
		PreloadTxtManager.func.AddEvent()
		PreloadTxtManager.func.AutoGetTxt()
	end
end

PreloadTxtManager.func.AddEvent = function()
	hGlobal.event:listen("LocalEvent_GetPreloadTxt","PreloadTxtManager",PreloadTxtManager.func.GetPreloadTxt)
end

PreloadTxtManager.func.ChangeLanguage = function()
	hApi.clearTimer("__AutoGetPreloadTxtStart")
	hApi.clearTimer("__AutoGetPreloadTxt")
	local tCache
	if g_Cur_Language < 3 then
		tCache = PreloadTxtManager.data.cncache
	elseif g_Cur_Language == 3 then
		tCache = PreloadTxtManager.data.encache
	elseif g_Cur_Language == 4 then
		tCache = PreloadTxtManager.data.jpcache
	end
	if tCache then
		for key,tString in pairs(tCache) do
			local stringtab
			if key == "tab_string" then
				stringtab = hVar.tab_string
			elseif key == "tab_stringI" then
				stringtab = hVar.tab_stringI
			elseif key == "tab_stringU" then
				stringtab = hVar.tab_stringU
			elseif key == "tab_stringT" then
				stringtab = hVar.tab_stringT
			elseif key == "tab_stringM" then
				stringtab = hVar.tab_stringM
			elseif key == "tab_stringME" then
				stringtab = hVar.tab_stringME
			elseif key == "tab_stringA" then
				stringtab = hVar.tab_stringA
			end
			if stringtab then
				for strkey in pairs(tString) do
					--print(strkey,tString[strkey])
					stringtab[strkey] = tString[strkey]
				end
			end
		end
	end
end

PreloadTxtManager.func.CheckNext = function()
	print("PreloadTxtManager.func.CheckNext")
	local tState = PreloadTxtManager.tState
	if tState.cn == nil then
		tState.cn = {}
		tState.cn.info = {}
		if #_tTypeIdList > 0 then
			tState.cn.curidx = 1
			tState.cn.info[1] = {_tTypeIdList[1],0,0}
		else
			tState.cn.curidx = 0
		end
	end
	local t = tState.cn
	if t.curidx > 0 then
		local tInfo = t.info[t.curidx]
		if tInfo then
			--已拿完
			 if tInfo[3] == 99 then
			 	--拿下一条
				if t.curidx < #_tTypeIdList then
					local idx = t.curidx + 1
					t.curidx = idx
					t.info[idx] = {_tTypeIdList[idx],0,0}
				else
					t.curidx = 0
				end
			 end
		end
	end
end

PreloadTxtManager.func.RequireTxt = function()
	--print("PreloadTxtManager.func.RequireTxt")
	PreloadTxtManager.func.CheckNext()
	if PreloadTxtManager.data.cnInfo == nil then
		PreloadTxtManager.data.cnInfo = {}
		PreloadTxtManager.data.cnInfo.nType = hVar.CommentTargetTypeDefine.PROLOADTEXT
		--PreloadTxtManager.data.cnInfo.nTypeID = 1
		--PreloadTxtManager.data.cnInfo.nStartIndex = 0
	end
	local tState = PreloadTxtManager.tState
	if tState.cn then
		local tCnInfo = PreloadTxtManager.data.cnInfo
		local t = tState.cn
		if t.curidx > 0 then
			local tInfo = tState.cn.info[t.curidx]
			tCnInfo.nTypeID = tInfo[1]
			tCnInfo.nStartIndex = tInfo[2]
			SendCmdFunc["comment_system_query_barrage"](tCnInfo.nType,tCnInfo.nTypeID,tCnInfo.nStartIndex)
		else
			hApi.clearTimer("__AutoGetPreloadTxt")
		end
	end
end

PreloadTxtManager.func.AutoGetTxt = function()
	hApi.addTimerOnce("__AutoGetPreloadTxtStart",100,function()
		PreloadTxtManager.func.RequireTxt()
		hApi.addTimerForever("__AutoGetPreloadTxt",hVar.TIMER_MODE.GAMETIME,1000,function()
			PreloadTxtManager.func.RequireTxt()
		end)
	end)
	if g_lua_src == 1 and _testluashow == 1 then
		if PreloadTxtManager.data and PreloadTxtManager.data.cncache then
			table_print(PreloadTxtManager.data.cncache)
		end
	end
end

PreloadTxtManager.func.AnalyzeString = function(nTypeID,key,content)
	if g_lua_src == 1 and _testluashow == 1 then
		print("PreloadTxtManager.func.AnalyzeString",nTypeID,key,content)
	end
	local keystr = hApi.Split(key,"##")
	local resultStrList = hApi.Split(content,"##")
	--print("#resultStrList",content)
	if #keystr > 0 and keystr[1] ~= "" then
		--table_print(keystr)
		--table_print(resultStrList)
		local tCache
		local shouldLoad = false
		if nTypeID < 10000 then
			tCache = PreloadTxtManager.data.cncache
			if g_Cur_Language < 3 then
				shouldLoad = true
			end
		elseif nTypeID < 20000 then
			tCache = PreloadTxtManager.data.encache
			if g_Cur_Language == 3 then
				shouldLoad = true
			end
		elseif nTypeID < 30000 then
			tCache = PreloadTxtManager.data.jpcache
			if g_Cur_Language == 4 then
				shouldLoad = true
			end
		end
		strType = keystr[1]
		if strType == "string" then
			if tCache.tab_string == nil then
				tCache.tab_string = {}
			end
			key = keystr[2]
			if key then
				value = string.gsub(resultStrList[1],"|n","\n")
				tCache.tab_string[key] = value
				if shouldLoad then
					hVar.tab_string[key] = tCache.tab_string[key]
				end
			end
		elseif strType == "stringI" or strType == "stringU" or strType == "stringT" or  
			strType == "stringM" or strType == "stringME" or strType == "stringA" then
			local stringtab
			local cachetab
			if strType == "stringI" then
				stringtab = hVar.tab_stringI
				if tCache.tab_stringI == nil then
					tCache.tab_stringI = {}
				end
				cachetab = tCache.tab_stringI
			elseif strType == "stringU" then
				stringtab = hVar.tab_stringU
				if tCache.tab_stringU == nil then
					tCache.tab_stringU = {}
				end
				cachetab = tCache.tab_stringU
			elseif strType == "stringT" then
				stringtab = hVar.tab_stringT
				if tCache.tab_stringT == nil then
					tCache.tab_stringT = {}
				end
				cachetab = tCache.tab_stringT
			elseif strType == "stringM" then
				stringtab = hVar.tab_stringM
				if tCache.tab_stringM == nil then
					tCache.tab_stringM = {}
				end
				cachetab = tCache.tab_stringM
			elseif strType == "stringME" then
				stringtab = hVar.tab_stringME
				if tCache.tab_stringME == nil then
					tCache.tab_stringME = {}
				end
				cachetab = tCache.tab_stringME
			elseif strType == "stringA" then
				stringtab = hVar.tab_stringA
				if tCache.tab_stringA == nil then
					tCache.tab_stringA = {}
				end
				cachetab = tCache.tab_stringA
			end
			if stringtab and cachetab then
				local key = keystr[2]
				if strType ~= "stringM" then
					key = tonumber(keystr[2])
				end
				if key then
					cachetab[key] = {}
					for i = 1,#resultStrList do
						local value = string.gsub(resultStrList[1],"\\n","\n")
						if value == "null" then
							value = ""
						end
						cachetab[key][i] = value
					end
					if shouldLoad then
						stringtab[key] = cachetab[key]
					end
				end
			end
		end
	end
	--table_print(PreloadTxtManager.data.cncache)
end

PreloadTxtManager.func.GetPreloadTxt = function(beginIndex,nType,nTypeID,dataCount,tData)
	if beginIndex == -1 then
		hApi.clearTimer("__AutoGetPreloadTxt")
		return
	end
	local tInfo
	local tStateInfo
	if nTypeID < 10000 then
		tInfo = PreloadTxtManager.data.cnInfo
		local tState = PreloadTxtManager.tState
		if tState.cn then
			local t = tState.cn
			tStateInfo = tState.cn.info[t.curidx]
		end
	elseif nTypeID < 20000 then
		
	elseif nTypeID < 30000 then
		
	end
	if tInfo == nil then
		return
	end
	--旧数据直接抛弃
	if beginIndex < tInfo.nStartIndex then
		return
	end
	hApi.clearTimer("__AutoGetPreloadTxt")
	if type(tData) == "table" then
		for i = 1,#tData do
			local v = tData[i]
			local content = v.content
			local key = v.key
			PreloadTxtManager.func.AnalyzeString(nTypeID,key,content)
		end
	end
	tInfo.nStartIndex = tInfo.nStartIndex + dataCount
	if tStateInfo then
		tStateInfo[2] = tInfo.nStartIndex
	end
	--一次性获取弹幕数量为30
	if dataCount < 30 then --若小于30则说明取完了
		--不再需要获取当前
		if tStateInfo then
			tStateInfo[3] = 99
		end
		--获取下一个typeid
		PreloadTxtManager.func.AutoGetTxt()
	else --否则说明还有数据
		PreloadTxtManager.func.AutoGetTxt()
	end
end