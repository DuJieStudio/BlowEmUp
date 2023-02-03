---------------------------------------
----解析表达式的函数
--local __ControlChar = {"%+","%-","%*","/","%^",">","<","=","%(","%)","%.","%%"}
--local __ControlString = ""
--for i = 1,#__ControlChar do
--	__ControlString = __ControlString.."^"..__ControlChar[i]
--end
--local __ParamFilter = "[^%d"..__ControlString.."]+["..__ControlString.."]*"
--hApi.AnalyzeValueExpr = function(mode,oWorld,tValue,v,nSkillId)
--	--print("hApi.AnalyzeValueExpr", mode, oWorld, tValue,v,nSkillId)
--	if v==0 then
--		return 0
--	end
--	local typ = type(v)
--	if typ=="number" then
--		return v
--	elseif typ=="string" then
--		local _v = v
--		local vlen = string.len(v)
--		local s,e = string.find(v,__ParamFilter,1)
--		if s~=nil then
--			if s==1 then
--				_v = ""
--			else
--				_v = string.sub(v,1,s-1)
--			end
--			while s~=nil do
--				local c = tValue[string.sub(v,s,e)]
--				if c==nil then
--					_v = _v.."0"
--				else
--					local case = type(c)
--					if case=="number" then
--						_v = _v..c
--					elseif case=="table" then
--						if c[1] and c[2] then
--							if oWorld and oWorld~=0 then
--								if oWorld.ID~=0 then
--									_v = _v..(oWorld:random(c[1],c[2],"analyze") or 0)
--								else
--									_v = _v..c[1]
--								end
--							else
--								_v = _v..(hApi.random(c[1],c[2]) or 0)
--							end
--						else
--							_v = _v.."0"
--						end
--					else
--						_v = _v.."0"
--					end
--				end
--				if e>=vlen then
--					break
--				else
--					local n = e + 1
--					s,e = string.find(v,__ParamFilter,n)
--					if s~=nil then
--						--继续找下一个
--						if s>n then
--							_v = _v..string.sub(v,n,s-1)
--						end
--					else
--						_v = _v..string.sub(v,n,vlen)
--						break
--					end
--				end
--			end
--		end
--		--for k,v in pairs(tValue)do
--			--_v = string.gsub(_v,k,v)
--		--end
--		--_v = string.gsub(_v,"[%a]","")
--		if type(_v)=="string" then
--			local r = 0
--			hGlobal.__tempVal = 0
--			--print("========== loadstring ==============")
--			local str = "hGlobal.__tempVal=".._v
--			--if (__LOAD_STRING_NUM__) and (__LOAD_STRING_SIZE__) then
--			--	__LOAD_STRING_NUM__ = __LOAD_STRING_NUM__ + 1
--			--	__LOAD_STRING_SIZE__ = __LOAD_STRING_SIZE__ + #str
--			--end
--			
--			local func = loadstring(str)
--			if func~=nil and xpcall(func,hGlobal.__TRACKBACK__) then
--				if mode=="number" then
--					if type(hGlobal.__tempVal)=="number" then
--						--r = hApi.floor(tonumber(hGlobal.__tempVal)) --geyachao: 暂时不加floor
--						r = tonumber(hGlobal.__tempVal)
--					else
--						_DEBUG_MSG("[LUA WARNING]技能["..tostring(nSkillId).."]的计算表达式填写错误[1],期望(number):",v)
--					end
--				else
--					r = hGlobal.__tempVal
--				end
--			else
--				_DEBUG_MSG("[LUA WARNING]技能["..tostring(nSkillId).."]的计算表达式填写错误[2]:",v)
--			end
--			return r
--		else
--			_DEBUG_MSG("[LUA WARNING]技能["..tostring(nSkillId).."]的计算表达式填写错误[3]:",v)
--			return 0
--		end
--	elseif mode=="number" then
--		return 0
--	else
--		return v
--	end
--end






--运算符优先级
local op_priority = function(value)
	local priority = 0
	if (value == "(") then
		priority = 0
	elseif (value == "+") then
		priority = 1
	elseif (value == "-") then
		priority = 1
	elseif (value == "*") then
		priority = 2
	elseif (value == "/") then
		priority = 2
	elseif (value == "%") then
		priority = 2
	elseif (value == ">") then
		priority = 3
	elseif (value == ">=") then
		priority = 3
	elseif (value == "<") then
		priority = 3
	elseif (value == "<=") then
		priority = 3
	elseif (value == "==") then
		priority = 3
	end
	
	return priority
end

--https://www.cnblogs.com/journal-of-xjx/p/5940030.html
--一、 将中缀表达式转换成后缀表达式算法：
--　　1、从左至右扫描一中缀表达式。
--　　2、若读取的是操作数，则判断该操作数的类型，并将该操作数存入操作数堆栈
--　　3、若读取的是运算符
--　　　　(1) 该运算符为左括号"("，则直接存入运算符堆栈。
--　　　　(2) 该运算符为右括号")"，则输出运算符堆栈中的运算符到操作数堆栈，直到遇到左括号为止。
--　　　　(3) 该运算符为非括号运算符：
--　　　　　　(a) 若运算符堆栈栈顶的运算符为括号（只可能是左括号），则直接存入运算符堆栈。
--　　　　　　(b) 若比运算符堆栈栈顶的运算符优先级高，则直接存入运算符堆栈。
--　　　　　　(c) 若比运算符堆栈栈顶的运算符优先级低或相等，则不断输出栈顶运算符到操作数堆栈，直到栈顶没有运算符的优先级大于或者等于当前预算符
--                （即栈顶存在运算符的话，优先级一定是小于当前运算符），最后将当前运算符压入运算符堆栈。            
--　　4、当表达式读取完成后运算符堆栈中尚有运算符时，则依序取出运算符到操作数堆栈，直到运算符堆栈为空。
--转逆波兰表达式
local tOperatorStack = {} --操作栈
local tExpressStack = {} --表达式栈
--返回值是一个表
--如果不传入tList，会默认生成一个新表（优化内存，每次传入tList避免重复创建表）
local niloban_express = function(expression, tList)
	--迭代器
	local it = 0
	
	while (it < #expression) do
		it = it + 1
		
		local buff = string.sub(expression, it, it)
		--print(it, buff)
		
		if (buff == "(") then
			--进op栈
			tOperatorStack[#tOperatorStack+1] = buff
		elseif (buff == "+") or (buff == "*") or (buff == "/") or (buff == "%") then
			--比较操作符栈顶元素的大小
			if (#tOperatorStack == 0) then
				--buff进op栈
				tOperatorStack[#tOperatorStack+1] = buff
			else
				local topbuff = tOperatorStack[#tOperatorStack]
				if (op_priority(buff) > op_priority(topbuff)) then --操作符更大，压入栈
					--buff进op栈
					tOperatorStack[#tOperatorStack+1] = buff
				else
					--持续检测将原栈顶元素，直至栈顶的运算符小于buff运算符
					while (op_priority(buff) <= op_priority(topbuff)) do
						--原栈顶出op栈
						tOperatorStack[#tOperatorStack] = nil
						--原栈顶进express栈
						tExpressStack[#tExpressStack+1] = topbuff
						
						--继续检测栈顶
						if (#tOperatorStack == 0) then
							break
						else
							topbuff = tOperatorStack[#tOperatorStack]
						end
					end
					
					--buff进op栈
					tOperatorStack[#tOperatorStack+1] = buff
				end
			end
		elseif  (buff == "-") then
			--减号有特别的含义，也可被认为是负数的首字符
			if (#tExpressStack == 0) or (string.sub(expression, it - 1, it - 1) == "(") then
				--认为是负号
				--检测后续数字的持续个数
				local pivot = it
				while true do
					pivot = pivot + 1
					if (pivot <= #expression) then
						local pivorbuff = string.sub(expression, pivot, pivot)
						if ((pivorbuff >= "0") and (pivorbuff <= "9")) or ((pivorbuff >= "A") and (pivorbuff <= "Z")) or ((pivorbuff >= "a") and (pivorbuff <= "z")) or (pivorbuff == "@") or (pivorbuff == ".") or (pivorbuff == "_") then --是数字
							--有效
						else
							pivot = pivot - 1
							break
						end
					else
						pivot = pivot - 1
						break
					end
				end
				
				--buff进express栈
				--print("实际：", string.sub(expression, it, pivot))
				tExpressStack[#tExpressStack+1] = string.sub(expression, it, pivot)
				
				it = pivot
			else
				--比较操作符栈顶元素的大小
				if (#tOperatorStack == 0) then
					--buff进op栈
					tOperatorStack[#tOperatorStack+1] = buff
				else
					local topbuff = tOperatorStack[#tOperatorStack]
					if (op_priority(buff) > op_priority(topbuff)) then --操作符更大，压入栈
						--buff进op栈
						tOperatorStack[#tOperatorStack+1] = buff
					else
						--持续检测将原栈顶元素，直至栈顶的运算符小于buff运算符
						while (op_priority(buff) <= op_priority(topbuff)) do
							--原栈顶出op栈
							tOperatorStack[#tOperatorStack] = nil
							--原栈顶进express栈
							tExpressStack[#tExpressStack+1] = topbuff
							
							--继续检测栈顶
							if (#tOperatorStack == 0) then
								break
							else
								topbuff = tOperatorStack[#tOperatorStack]
							end
						end
						
						--buff进op栈
						tOperatorStack[#tOperatorStack+1] = buff
					end
				end
			end
		elseif (buff == ">") or (buff == "<") or (buff == "=") then
			--检测右边一位是否为"="，连成操作符
			local buff2 = string.sub(expression, it + 1, it + 1)
			if (buff2 == "=") then
				buff = string.sub(expression, it, it + 1)
				it = it + 1
				--print("实际：", buff)
			end
			
			--比较操作符栈顶元素的大小
			if (#tOperatorStack == 0) then
				--buff进op栈
				tOperatorStack[#tOperatorStack+1] = buff
			else
				local topbuff = tOperatorStack[#tOperatorStack]
				if (op_priority(buff) > op_priority(topbuff)) then --操作符更大，压入栈
					--buff进op栈
					tOperatorStack[#tOperatorStack+1] = buff
				else
					--原栈顶出op栈
					tOperatorStack[#tOperatorStack] = nil
					--原栈顶进express栈
					tExpressStack[#tExpressStack+1] = topbuff
					
					--buff进op栈
					tOperatorStack[#tOperatorStack+1] = buff
				end
			end
		elseif (buff == ")") then
			--持续出op栈，直到匹配"("
			local topbuff = ""
			while true do
				topbuff = tOperatorStack[#tOperatorStack]
				
				--原栈顶出op栈
				tOperatorStack[#tOperatorStack] = nil
				
				if (topbuff == "(") then --已匹配
					break
				else
					--原栈顶进express栈
					tExpressStack[#tExpressStack+1] = topbuff
				end
			end
		elseif ((buff >= "0") and (buff <= "9")) or ((buff >= "A") and (buff <= "Z")) or ((buff >= "a") and (buff <= "z")) or (buff == "@") or (buff == ".") or (buff == "_") then --是数字
			--检测后续数字的持续个数
			local pivot = it
			while true do
				pivot = pivot + 1
				if (pivot <= #expression) then
					local pivorbuff = string.sub(expression, pivot, pivot)
					if ((pivorbuff >= "0") and (pivorbuff <= "9")) or ((pivorbuff >= "A") and (pivorbuff <= "Z")) or ((pivorbuff >= "a") and (pivorbuff <= "z")) or (pivorbuff == "@") or (pivorbuff == ".") or (pivorbuff == "_") then --是数字
						--有效
					else
						pivot = pivot - 1
						break
					end
				else
					pivot = pivot - 1
					break
				end
			end
			
			--buff进express栈
			--print("实际：", string.sub(expression, it, pivot))
			tExpressStack[#tExpressStack+1] = string.sub(expression, it, pivot)
			
			it = pivot
		elseif (buff == " ") then --空格
			--不处理
			--...
		else
			local strText = string.format("表达式 \"%s\" 中有无效的字符 \"%s\" ！", expression, buff)
			print(strText)
			
			--弹框
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、管理员、测试员
				hGlobal.UI.MsgBox(strText, {
					font = hVar.FONTC,
					ok = function()
					end,
				})
			end
		end
	end
	
	--将操作符栈的元素都压如表达式栈
	while (#tOperatorStack > 0) do
		local topbuff = tOperatorStack[#tOperatorStack]
		
		--原栈顶出op栈
		tOperatorStack[#tOperatorStack] = nil
		--原栈顶进express栈
		tExpressStack[#tExpressStack+1] = topbuff
	end
	
	--print("finish!")
	
	--表达式栈逆序
	tList = tList or {}
	while (#tExpressStack > 0) do
		local topbuff = tExpressStack[#tExpressStack]
		
		--原栈顶出op栈
		tExpressStack[#tExpressStack] = nil
		tList[#tList+1] = topbuff
	end
	
	--[[
	--测试 --test
	--输出
	local str = ""
	for i = #tList, 1, -1 do
		str = str .. tList[i] .. " "
	end
	print(str)
	]]
	
	return tList
end

--https://www.cnblogs.com/journal-of-xjx/p/5940030.html
--二、逆波兰表达式求值算法：
--　　1、从左到右依次扫描语法单元的项目。
--　　2、如果扫描的项目是操作数，则将其压入操作数堆栈，并扫描下一个项目。
--　　3、如果扫描的项目是一个二元运算符，则对栈的顶上两个操作数执行该运算。
--　　4、如果扫描的项目是一个一元运算符，则对栈的最顶上操作数执行该运算。
--　　5、将运算结果重新压入堆栈。
--　　6、重复步骤2-5，堆栈中即为结果值。
--计算逆波兰表达式结果
local tExpression = {} --操作结果栈
local cal_niloban_express = function(tList)
	while (#tList > 0) do
		local topbuff = tList[#tList]
		--print(topbuff)
		tList[#tList] = nil
		
		if (topbuff == "+") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 + val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "-")  then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 - val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "*")  then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 * val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "/") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 / val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "%") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 % val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == ">") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 > val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == ">=") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 >= val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "<") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 < val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "<=") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 <= val2)
			tExpression[#tExpression+1] = result
		elseif (topbuff == "==") then
			local val2 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local val1 = tExpression[#tExpression]
			tExpression[#tExpression] = nil
			local result = (val1 == val2)
			tExpression[#tExpression+1] = result
		else
			local intVal = tonumber(topbuff)
			tExpression[#tExpression+1] = intVal
		end
		
		--[[
		--输出
		local str = ""
		for i = 1, #tExpression, 1 do
			str = str .. tostring(tExpression[i]) .. " "
		end
		print(str)
		]]
	end
	
	--[[
	--测试 --test
	--输出
	local str = ""
	for i = #tExpression, 1, -1 do
		str = str .. tostring(tExpression[i]) .. " "
	end
	print(str)
	]]
	
	--错误检测，最后应该只剩一项
	if (#tExpression > 1) then
		--清空表
		tExpression = {}
		tExpression[1] = 0
		
		--弹框
		local strText = "解析表达式遇到异常错误！"
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
	
	--运算结果为堆栈中的唯一元素
	local result = tExpression[1]
	tExpression[1] = nil
	
	return result
end

--计算表达式结果
local tList = {}
hApi.AnalyzeValueExpr = function(mode, oWorld, tValue, v, nSkillId)
	if (type(v) == "number") then
		return v
	elseif (type(v) == "string") then
		--转逆波兰表达式
		--print(v) --测试 --test
		tList = niloban_express(v, tList)
		
		--将表达式转成数字
		for i = 1, #tList, 1 do
			local element = tList[i]
			if (element == "+") or (element == "-") or (element == "*") or (element == "/") or (element == "%") or (element == ">") or (element == ">=") or (element == "<") or (element == "<=") or (element == "==") then --运算符
				--
			else --表达式
				local numVal = tonumber(element)
				if (type(numVal) == "number") then
					tList[i] = numVal
				else
					--变量
					if (tValue[element] ~= nil) then
						tList[i] = tValue[element]
					elseif (string.sub(element, 1, 1) == "-") then --"-@param"这种格式
						tList[i] = -tValue[string.sub(element, 2, #element)] or 0
					else
						tList[i] = 0
						
						local strText = string.format("技能[%d]中有无效的变量 \"%s\" ！", nSkillId, element)
						print(strText, debug.traceback())
						
						--弹框
						if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、管理员、测试员
							hGlobal.UI.MsgBox(strText, {
								font = hVar.FONTC,
								ok = function()
								end,
							})
						end
					end
				end
			end
		end
		
		return cal_niloban_express(tList)
	else
		return 0
	end
end

hApi.IsSkillDisabled = function(oUnit,id)
	local tabS = hVar.tab_skill[id]
	if tabS and tabS.disable then
		local dCond = tabS.disable
		for i = 1,#dCond do
			if dCond[i]=="encounter" then
				if oUnit.data.IsEncountered>0 then
					return 1,hVar.tab_string["__NEED_ESCAPE__"]
				end
			end
		end
	end
	return 0,""
end
---------------------------------------
--解析表达式的函数
local __tSkillDataIndex = {
	["SkillLv"] = {2,0},		--技能等级
	["SkillCooldown"] = {3,-1},	--技能冷却
	["SkillCount"] = {4,-1},	--技能使用次数
}
hApi.ReadUnitValue = function(tValue,toParamVar,oUnit,valueType,valueParam)
	local v = 0
	if __tSkillDataIndex[valueType] then
		local s = oUnit:getskill(valueParam)
		if s then
			v = s[__tSkillDataIndex[valueType][1]] or 0
		else
			v = __tSkillDataIndex[valueType][2]
		end
	elseif (valueType == "Attr") then
		if (valueParam == "MinAtk") or (valueParam == "atk_min") then --最小攻击力
			v = oUnit.attr.attack[4] + oUnit.attr.atk_item + oUnit.attr.atk_buff + oUnit.attr.atk_aura + oUnit.attr.atk_tactic
		elseif (valueParam=="MaxAtk") or (valueParam == "atk_max") then --最大攻击力
			v = oUnit.attr.attack[5] + oUnit.attr.atk_item + oUnit.attr.atk_buff + oUnit.attr.atk_aura + oUnit.attr.atk_tactic
		elseif (valueParam == "hp_max") or (valueParam == "mxhp") then --最大生命值
			v = oUnit:GetHpMax()
		elseif (valueParam == "atk") then --攻击力
			v = oUnit:GetAtk()
		elseif (valueParam == "atk_interval") then --攻击间隔（毫秒）
			v = oUnit:GetAtkInterval()
		elseif (valueParam == "atk_speed") then --攻击速度（去百分号后的值）
			v = oUnit:GetAtkInterval()
		elseif (valueParam == "move_speed") then --移动速度
			v = oUnit:GetMoveSpeed()
		elseif (valueParam == "atk_radius") then --攻击范围
			v = oUnit:GetAtkRange()
		elseif (valueParam == "atk_radius_min") then --攻击范围最小值
			v = oUnit:GetAtkRangeMin()
		elseif (valueParam == "def_physic") then --物防
			v = oUnit:GetPhysicDef()
		elseif (valueParam == "def_magic") then --法防
			v = oUnit:GetMagicDef()
		elseif (valueParam == "dodge_rate") then --闪避几率（去百分号后的值）
			v = oUnit:GetDodgeRate()
		elseif (valueParam == "hit_rate") then --命中几率（去百分号后的值）
			v = oUnit:GetHitRate()
		elseif (valueParam == "crit_rate") then --暴击几率（去百分号后的值）
			v = oUnit:GetCritRate()
		elseif (valueParam == "crit_value") then --暴击倍数（支持小数）
			v = oUnit:GetCritValue()
		elseif (valueParam == "kill_gold") then --击杀获得的金币
			v = oUnit:GetKillGold()
		elseif (valueParam == "escape_punish") then --击杀获得的金币
			v = oUnit:GetEscapePunish()
		elseif (valueParam == "hp_restore") then --回血速度（每秒）（支持小数）
			v = oUnit:GetHpRestore()
		elseif (valueParam == "rebirth_time") then --复活时间（毫秒）
			v = oUnit:GetRebirthTime()
		elseif (valueParam == "suck_blood_rate") then --吸血率（去百分号后的值）
			v = oUnit:GetSuckBloodRate()
		elseif (valueParam == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
			v = oUnit:GetActiveSkillCDDelta()
		elseif (valueParam == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
			v = oUnit:GetPassiveSkillCDDelta()
		elseif (valueParam == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
			v = oUnit:GetActiveSkillCDDeltaRate()
		elseif (valueParam == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
			v = oUnit:GetPassiveSkillCDDeltaRate()
		elseif (valueParam == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
			v = oUnit:GetAIAttribute()
		elseif (valueParam == "atk_ice") then --冰攻击力
			v = oUnit:GetIceAtk()
		elseif (valueParam == "atk_thunder") then --雷攻击力
			v = oUnit:GetThunderAtk()
		elseif (valueParam == "atk_fire") then --火攻击力
			v = oUnit:GetFireAtk()
		elseif (valueParam == "atk_poison") then --毒攻击力
			v = oUnit:GetPoisonAtk()
		elseif (valueParam == "atk_bullet") then --子弹攻击力
			v = oUnit:GetBulletAtk()
		elseif (valueParam == "atk_bomb") then --爆炸攻击力
			v = oUnit:GetBombAtk()
		elseif (valueParam == "atk_chuanci") then --穿刺攻击力
			v = oUnit:GetChuanciAtk()
		elseif (valueParam == "def_ice") then --冰防御
			v = oUnit:GetIceDef()
		elseif (valueParam == "def_thunder") then --雷防御
			v = oUnit:GetThunderDef()
		elseif (valueParam == "def_fire") then --火防御
			v = oUnit:GetFireDef()
		elseif (valueParam == "def_poison") then --毒防御
			v = oUnit:GetPoisonDef()
		elseif (valueParam == "def_bullet") then --子弹防御
			v = oUnit:GetBulletDef()
		elseif (valueParam == "def_bomb") then --爆炸防御
			v = oUnit:GetBombDef()
		elseif (valueParam == "def_chuanci") then --穿刺防御
			v = oUnit:GetChuanciDef()
		elseif (valueParam == "bullet_capacity") then --携弹数量
			v = oUnit:GetBulletCapacity()
		elseif (valueParam == "grenade_capacity") then --手雷数量
			v = oUnit:GetGrenadeCapacity()
		elseif (valueParam == "grenade_child") then --子母雷数量
			v = oUnit:GetGrenadeChild()
		elseif (valueParam == "grenade_fire") then --手雷爆炸火焰
			v = oUnit:GetGrenadeFire()
		elseif (valueParam == "grenade_dis") then --手雷投弹距离
			v = oUnit:GetGrenadeDis()
		elseif (valueParam == "grenade_cd") then --手雷冷却时间（单位：毫秒）
			v = oUnit:GetGrenadeCD()
		elseif (valueParam == "grenade_crit") then --手雷暴击
			v = oUnit:GetGrenadeCrit()
		elseif (valueParam == "grenade_multiply") then --手雷冷却前使用次数
			v = oUnit:GetGrenadeMultiply()
		elseif (valueParam == "inertia") then --惯性
			v = oUnit:GetInertia()
		elseif (valueParam == "crystal_rate") then --水晶收益率（去百分号后的值）
			v = oUnit:GetCrystalRate()
		elseif (valueParam == "melee_bounce") then --近战弹开
			v = oUnit:GetMeleeBounce()
		elseif (valueParam == "melee_fight") then --近战反击
			v = oUnit:GetMeleeFight()
		elseif (valueParam == "melee_stone") then --近战碎石
			v = oUnit:GetMeleeStone()
		elseif (valueParam == "pet_hp_restore") then --宠物回血
			v = oUnit:GetPetHpRestore()
		elseif (valueParam == "pet_hp") then --宠物生命
			v = oUnit:GetPetHp()
		elseif (valueParam == "pet_atk") then --宠物攻击
			v = oUnit:GetPetAtk()
		elseif (valueParam == "pet_atk_speed") then --宠物攻速
			v = oUnit:GetPetAtkSpeed()
		elseif (valueParam == "pet_capacity") then --宠物携带数量
			v = oUnit:GetPetCapacity()
		elseif (valueParam == "trap_ground") then --陷阱时间（单位：毫秒）
			v = oUnit:GetTrapGround()
		elseif (valueParam == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
			v = oUnit:GetTrapGroundCD()
		elseif (valueParam == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
			v = oUnit:GetTrapGroundEnemy()
		elseif (valueParam == "trap_fly") then --天网时间（单位：毫秒）
			v = oUnit:GetTrapFly()
		elseif (valueParam == "trap_flycd") then --天网施法间隔（单位：毫秒）
			v = oUnit:GetTrapFlyCD()
		elseif (valueParam == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
			v = oUnit:GetTrapFlyEnemy()
		elseif (valueParam == "puzzle") then --迷惑几率（去百分号后的值）
			v = oUnit:GetPuzzle()
		elseif (valueParam == "weapon_crit_shoot") then --射击暴击
			v = oUnit:GetWeaponCritShoot()
		elseif (valueParam == "weapon_crit_frozen") then --冰冻暴击
			v = oUnit:GetWeaponCritFrozen()
		elseif (valueParam == "weapon_crit_fire") then --火焰暴击
			v = oUnit:GetWeaponCritFire()
		elseif (valueParam == "weapon_crit_equip") then --装备暴击
			v = oUnit:GetWeaponCritEquip()
		elseif (valueParam == "weapon_crit_hit") then --击退暴击
			v = oUnit:GetWeaponCritHit()
		elseif (valueParam == "weapon_crit_blow") then --吹风暴击
			v = oUnit:GetWeaponCritBlow()
		elseif (valueParam == "weapon_crit_poison") then --毒液暴击
			v = oUnit:GetWeaponCritPoison()
		elseif (valueParam == "space_type") then --空间类型
			v = oUnit:GetSpaceType()
		elseif( type(oUnit.attr[valueParam]) == "number") then
			v = oUnit.attr[valueParam]
		end
	elseif valueType=="TabAttr" then
		local tabU = hVar.tab_unit[oUnit.data.id]
		if tabU and tabU.attr and type(tabU.attr[valueParam])=="number" then
			v = tabU.attr[valueParam]
		end
	elseif valueType=="HeroAttr" then
		local oHero = oUnit:gethero()
		if oHero~=nil and type(oHero.attr[valueParam])=="number" then
			v = oHero.attr[valueParam]
		end
	end
	if type(toParamVar)=="string" then
		tValue[toParamVar] = v
	end
end
--------------------------------------------------------------
-- 技能buff状态解析
local __InitIndexTab = function(t)
	t.index = {}
	for i = 1,#t do
		if type(t[i])=="table" then
			t.index[t[i][1]] = 1
		else
			t.index[t[i]] = 1
		end
	end
	return t
end
local __PARALYZE__Key = __InitIndexTab({"frozen","paralyzed","stone"})
local __STATECOLOR__Key = __InitIndexTab({
	{"frozen",128,128,255},
	{"paralyzed",128,128,128},
})
local __STATEALPHA__Key = __InitIndexTab({
	{"stealth",128},
})
hApi.AddBuffStateForAction = function(self,tState,IsAddState,IfShow)
	if tState==0 then
		return 0
	end
	local oUnit = self.data.unit
	local oTarget
	if tState[1]=="unit" then
		oTarget = self.data.unit
	elseif tState[1]=="target" then
		oTarget = self.data.target
	end
	if type(oTarget)~="table" then
		return 0
	end
	local plus = 1
	if IsAddState~=1 then
		plus = -1
	end
	local k = tState[2]
	local StateName
	local StateVal
	local NeedChangeColor = 0
	local NeedChangeAlpha = 0
	if k=="immobilize" then
		--定身
		if plus>0 then
			oTarget.attr.move = oTarget.attr.move - 999
			StateName = "__IMMOBILIZE__"
		else
			oTarget.attr.move = oTarget.attr.move + 999
			if oTarget.attr.move>=0 then
				StateName = "__REMOVE_IMMOBILIZE__"
			end
		end
	elseif k=="damagelink" then
		--转移伤害
		oTarget.attr.DamageLink = oTarget.attr.DamageLink + plus
	elseif k=="stealth" then
		--潜行
		oTarget.attr.stealth = oTarget.attr.stealth + plus
		NeedChangeAlpha = 1
	elseif k=="shield" then
		--护盾
		if type(self.data.tempValue["@exhp"])=="number" then
			oTarget.attr.exhp = oTarget.attr.exhp + plus*self.data.tempValue["@exhp"]
		end
	elseif k=="flee" then
		--闪避
		oTarget.attr.flee = oTarget.attr.flee + plus
	elseif k=="stun" or __PARALYZE__Key.index[k] then
		--完整控制效果
		if plus>0 then
			if oTarget.attr.stunimmunity>0 then
				self.data.IsBuff = -1
				return 0
			elseif oUnit.attr.smash>0 and oTarget.attr.heroic==0 then
				--拥有破击效果的单位攻击非英雄单位时，不触发韧性
			else
				local nResist = oTarget.attr.toughness
				if nResist>0 then
					local nChance = math.mod(nResist,5)
					local nTurn = hApi.floor((nResist - nChance)/5)
					if nChance>0 and self.data.world~=0 and self.data.world:random(1,5,"toughness")<=nChance then
						nTurn = nTurn + 1
					end
					if nTurn>0 then
						oTarget.attr.stunimmunity = nTurn + 1
					end
				end
			end
		end
		if k=="stun" then
			--眩晕
			oTarget.attr.stun = oTarget.attr.stun + plus
			if plus>0 then
				StateName = "__STUN__"
			elseif oTarget.attr.stun<=0 then
				StateName = "__REMOVE_STUN__"
			end
		elseif __PARALYZE__Key.index[k] then
			--瘫痪/冻结/石化
			oTarget.attr.stun = oTarget.attr.stun + plus
			if oTarget.attr[k] then
				oTarget.attr[k] = oTarget.attr[k] + plus
			end
			if k=="stone" then
				NeedChangeColor = 1
				oTarget.attr.IsBuilding = oTarget.attr.IsBuilding + plus
				oTarget.attr.paralyzed = oTarget.attr.paralyzed + plus
				if plus>0 then
					StateName = "__STONE__"
				elseif oTarget.attr.IsBuilding<=0 then
					StateName = "__REMOVE_STONE__"
				end
			else
				if plus>0 then
					StateName = "__STUN__"
				elseif oTarget.attr.stun<=0 then
					StateName = "__REMOVE_STUN__"
				end
			end
			if oTarget.data.IsDead~=1 and oTarget.handle.__manager=="lua" and oTarget.handle.s then
				if plus>0 then
					oTarget:playanimation("hit",1)
				else
					local nParalyzeCount = 0
					for i = 1,#__PARALYZE__Key do
						local v = __PARALYZE__Key[i]
						if (oTarget.attr[v] or 0)>0 then
							nParalyzeCount = nParalyzeCount + 1
						end
					end
					if nParalyzeCount<=0 then
						oTarget:setanimation("stand",1)
					end
				end
			end
		end
	else
		return 0
	end
	--有sprite的单位
	if oTarget.data.IsDead~=1 and oTarget.handle.__manager=="lua" and oTarget.handle.s then
		--如果需要计算颜色
		if NeedChangeColor==1 or __STATECOLOR__Key.index[k] then
			--角色原色
			local R,G,B = 255,255,255
			if oTarget.data.color and type(oTarget.data.color) == "table" then
				R = oTarget.data.color[1] or 255
				G = oTarget.data.color[2] or 255
				B = oTarget.data.color[3] or 255
			end
			--属性叠加
			local nColorCount = 0
			for i = 1,#__STATECOLOR__Key do
				local a = __STATECOLOR__Key[i][1]
				if oTarget.attr[a]>0 then
					nColorCount = nColorCount + 1
					local v = __STATECOLOR__Key[i]
					local cR,cG,cB = v[2],v[3],v[4]
					R = hApi.floor(R*cR/255)
					G = hApi.floor(G*cG/255)
					B = hApi.floor(B*cB/255)
				end
			end
			oTarget.handle.s:setColor(ccc3(R,G,B))
			--if nColorCount>0 then
			--	oTarget.handle.s:setColor(ccc3(R,G,B))
			--elseif plus==-1 then
			--	oTarget.handle.s:setColor(ccc3(255,255,255))
			--end
		end
		--如果需要计算alpha
		if NeedChangeAlpha==1 or __STATEALPHA__Key.index[k] then
			local A = 255
			if oTarget.data.alpha and oTarget.data.alpha > 0 then
				A = oTarget.data.alpha
			end
			local nAlphaCount = 0
			for i = 1,#__STATEALPHA__Key do
				local a = __STATEALPHA__Key[i][1]
				if oTarget.attr[a]>0 then
					nAlphaCount = nAlphaCount + 1
					local v = __STATEALPHA__Key[i]
					local cA = v[2]
					A = hApi.floor(A*cA/255)
				end
			end
			oTarget.handle.s:setOpacity(math.min(A,255))
			--if nAlphaCount>0 then
			--	oTarget.handle.s:setOpacity(math.min(A,255))
			--elseif plus==-1 then
			--	oTarget.handle.s:setOpacity(255)
			--end
		end
	end
	if oTarget.data.IsDead~=1 and IfShow and StateName then
		hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,oTarget,StateName,StateVal)
	end
	return 1
end




--附加竞技场自己的兵种卡的强化属性
local __Append_Tactic_Attr_PVP = function(oUnit, tacticId, tempValueT)
	--print("__Append_Tactic_Attr_PVP", oUnit.data.name, oUnit:getowner():getpos())
	
	--获得自己携带的此战术卡的数据
	local world = oUnit:getworld()
	local tTacticAttrAdd = {}
	local tTactics = world:gettactics(oUnit:getowner():getpos()) --本局所有的战术技能卡
	if (tTactics ~= nil) then
		for i = 1, #tTactics, 1 do
			if (tTactics[i] ~= 0) then
				local id, lv, typeId, addonesIdx, attr1, attr2, attr3 = tTactics[i][1], tTactics[i][2], tTactics[i][3], tTactics[i][4], tTactics[i][5], tTactics[i][6], tTactics[i][7] --geyachao: 该战术技能卡是哪个英雄的
				local tabT = hVar.tab_tactics[id]
				local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
				if tabT then
					if (typeT == hVar.TACTICS_TYPE.ARMY) then --兵种类战术技能卡
						--print(i, tabT.name, typeId, addonesIdx, attr1, attr2, attr3)
						if (tacticId == id) then --找到了
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr1
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr2
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr3
							
							break
						end
					end
				end
			end
		end
	end
	
	local a = oUnit.attr
	
	--该单位附加兵种卡属性
	for k = 1, #tTacticAttrAdd, 1 do
		local strAttr = tTacticAttrAdd[k] --属性字符串
		if (type(strAttr) == "string") and hVar.ITEM_ATTR_VAL[strAttr] then
			local attrVal = hVar.ITEM_ATTR_VAL[strAttr] --兵种卡的属性表
			local attrAdd = attrVal.attrAdd --属性类型
			local num = attrVal.value1 --属性值1
			local value2 = attrVal.value2 --属性值2
			--print("单位附加属性:", hVar.tab_tactics[tacticId].name, oUnit.data.name, attrAdd, num)
			
			if (attrAdd == "hp_max_rate") then --血量+5％
				local value = math.floor(a.hp_max_basic * num / 100)
				a.hp_max_tactic = a.hp_max_tactic + value
				
				--刷新单位的血条
				oUnit.attr.hp = oUnit:GetHpMax()
				
				--更新血条控件
				if oUnit.chaUI["hpBar"] then
					oUnit.chaUI["hpBar"]:setV(oUnit.attr.hp, oUnit:GetHpMax())
				end
				if oUnit.chaUI["numberBar"] then
					oUnit.chaUI["numberBar"]:setText(oUnit.attr.hp .. "/" .. oUnit:GetHpMax())
				end
			elseif (attrAdd == "atk_rate") then --攻击+5％
				local value = math.floor(a.atk_basic * num / 100)
				a.atk_tactic = a.atk_tactic + value
			elseif (attrAdd == "atk_radius") then --射程+50
				a.atk_radius_tactic = a.atk_radius_tactic + num
			elseif (attrAdd == "army_damage") then --伤害+5％
				local value = math.floor(a.atk_basic * num / 100)
				a.atk_tactic = a.atk_tactic + value
			elseif (attrAdd == "def_physic") then --物防+5
				a.def_physic_tactic = a.def_physic_tactic + num
			elseif (attrAdd == "def_magic") then --法防+5
				a.def_magic_tactic = a.def_magic_tactic + num
			elseif (attrAdd == "dodge_rate") then --闪避+5％
				a.dodge_rate_tactic = a.dodge_rate_tactic + num
			elseif (attrAdd == "hit_rate") then --命中+5％
				a.hit_rate_tactic = a.hit_rate_tactic + num
			elseif (attrAdd == "crit_rate") then --暴率+5％
				a.crit_rate_tactic = a.crit_rate_tactic + num
			elseif (attrAdd == "crit_value") then --暴倍+0.5
				a.crit_value_tactic = a.crit_value_tactic + num
			elseif (attrAdd == "hp_restore") then --回血+5
				a.hp_restore_tactic = a.hp_restore_tactic + num
			elseif (attrAdd == "atk_speed") then --攻速+5％
				a.atk_speed_tactic = a.atk_speed_tactic + num
			elseif (attrAdd == "move_speed") then --移速+5％
				local value = math.floor(a.move_speed_basic * num / 100)
				a.move_speed_tactic = a.move_speed_tactic + value
			elseif (attrAdd == "suck_blood_rate") then --吸血+5％
				a.suck_blood_rate_tactic = a.suck_blood_rate_tactic + num
			elseif (attrAdd == "live_time") then --存活+5％
				local livetime = oUnit.data.livetime --原始生存时间（毫秒）
				local value = math.floor(livetime * num / 100)
				oUnit.data.livetimeMax = oUnit.data.livetimeMax + value --geyachao: 新加数据 生存时间最大值（毫秒）
			elseif (attrAdd == "army_discount") then --价格-5％
				--
			elseif (attrAdd == "army_cooldown") then --冷却-1秒
				--
			elseif (attrAdd == "skill_cooldown") then --技能冷却-1秒
				--
			elseif (attrAdd == "skill_damage") then --技能伤害+5％
				--
			elseif (attrAdd == "skill_range") then --技能范围+5％
				--
			elseif (attrAdd == "skill_chaos") then --技能混乱+1秒
				--
			elseif (attrAdd == "skill_num") then --技能数量+5％
				--
			elseif (attrAdd == "skill_poison") then --技能中毒+1层
				--
			elseif (attrAdd == "skill_lasttime") then --技能持续时间+1秒
				--
			end
		end
	end
end

--读取竞技场自己的兵种卡技能附加强化属性，并存到tempValue表中
local __Read_Tactic_Attr_PVP = function(oUnit, tacticId, tempValueT)
	--print("__Read_Tactic_Attr_PVP", oUnit.data.name, oUnit:getowner():getpos())
	
	--获得自己携带的此战术卡的数据
	local world = oUnit:getworld()
	local tTacticAttrAdd = {}
	local tTactics = world:gettactics(oUnit:getowner():getpos()) --本局所有的战术技能卡
	if (tTactics ~= nil) then
		for i = 1, #tTactics, 1 do
			if (tTactics[i] ~= 0) then
				local id, lv, typeId, addonesIdx, attr1, attr2, attr3 = tTactics[i][1], tTactics[i][2], tTactics[i][3], tTactics[i][4], tTactics[i][5], tTactics[i][6], tTactics[i][7] --geyachao: 该战术技能卡是哪个英雄的
				local tabT = hVar.tab_tactics[id]
				local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
				if tabT then
					if (typeT == hVar.TACTICS_TYPE.ARMY) then --兵种类战术技能卡
						--print(i, tabT.name, typeId, addonesIdx, attr1, attr2, attr3)
						if (tacticId == id) then --找到了
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr1
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr2
							tTacticAttrAdd[#tTacticAttrAdd+1] = attr3
							
							break
						end
					end
				end
			end
		end
	end
	
	local a = oUnit.attr
	
	--初始化数值
	tempValueT["@tactic_pvp_skill_damage"] = tempValueT["@tactic_pvp_skill_damage"] or 0 --技能伤害+5％
	tempValueT["@tactic_pvp_skill_range"] = tempValueT["@tactic_pvp_skill_range"] or 0 --技能范围+5％
	tempValueT["@tactic_pvp_skill_chaos"] = tempValueT["@tactic_pvp_skill_chaos"] or 0 --技能混乱+1秒
	tempValueT["@tactic_pvp_skill_num"] = tempValueT["@tactic_pvp_skill_num"] or 0 --技能数量+5％
	tempValueT["@tactic_pvp_skill_poison"] = tempValueT["@tactic_pvp_skill_poison"] or 0 --技能中毒+1层
	tempValueT["@tactic_pvp_skill_lasttime"] = tempValueT["@tactic_pvp_skill_lasttime"] or 0 --技能持续时间+1秒
	
	--该单位附加兵种卡属性
	for k = 1, #tTacticAttrAdd, 1 do
		local strAttr = tTacticAttrAdd[k] --属性字符串
		if (type(strAttr) == "string") and hVar.ITEM_ATTR_VAL[strAttr] then
			local attrVal = hVar.ITEM_ATTR_VAL[strAttr] --兵种卡的属性表
			local attrAdd = attrVal.attrAdd --属性类型
			local num = attrVal.value1 --属性值1
			local value2 = attrVal.value2 --属性值2
			--print("技能附加属性:", hVar.tab_tactics[tacticId].name, oUnit.data.name, attrAdd, num)
			
			if (attrAdd == "hp_max_rate") then --血量+5％
				--
			elseif (attrAdd == "atk_rate") then --攻击+5％
				--
			elseif (attrAdd == "army_damage") then --伤害+5％
				--
			elseif (attrAdd == "def_physic") then --物防+5
				--
			elseif (attrAdd == "def_magic") then --法防+5
				--
			elseif (attrAdd == "dodge_rate") then --闪避+5％
				--
			elseif (attrAdd == "hit_rate") then --命中+5％
				--
			elseif (attrAdd == "crit_rate") then --暴率+5％
				--
			elseif (attrAdd == "crit_value") then --暴倍+0.5
				--
			elseif (attrAdd == "hp_restore") then --回血+5
				--
			elseif (attrAdd == "atk_speed") then --攻速+5％
				--
			elseif (attrAdd == "move_speed") then --移速+5％
				--
			elseif (attrAdd == "suck_blood_rate") then --吸血+5％
				--
			elseif (attrAdd == "live_time") then --存活+5％
				--
			elseif (attrAdd == "army_discount") then --价格-5％
				--
			elseif (attrAdd == "army_cooldown") then --冷却-1秒
				--
			elseif (attrAdd == "skill_cooldown") then --技能冷却-1秒
				--
			elseif (attrAdd == "skill_damage") then --技能伤害+5％
				tempValueT["@tactic_pvp_skill_damage"] = tempValueT["@tactic_pvp_skill_damage"] + num --技能伤害+5％
			elseif (attrAdd == "skill_range") then --技能范围+5％
				tempValueT["@tactic_pvp_skill_range"] = tempValueT["@tactic_pvp_skill_range"] + num --技能范围+5％
			elseif (attrAdd == "skill_chaos") then --技能混乱+1秒
				tempValueT["@tactic_pvp_skill_chaos"] = tempValueT["@tactic_pvp_skill_chaos"] + num --技能混乱+1秒
			elseif (attrAdd == "skill_num") then --技能数量+5％
				tempValueT["@tactic_pvp_skill_num"] = tempValueT["@tactic_pvp_skill_num"] + num --技能数量+5％
			elseif (attrAdd == "skill_poison") then --技能中毒+1层
				tempValueT["@tactic_pvp_skill_poison"] = tempValueT["@tactic_pvp_skill_poison"] + num --技能中毒+1层
			elseif (attrAdd == "skill_lasttime") then --技能持续时间+1秒
				tempValueT["@tactic_pvp_skill_lasttime"] = tempValueT["@tactic_pvp_skill_lasttime"] + num --技能持续时间+1秒
			end
		end
	end
end

-----------------------------------------------------
-- 技能表中的action解析方法全部写在这里
local __aCodeList = hClass.action.__static.actionCodeList
local __aFailToProcess = hClass.action.__static.failToProcess
--local __AnalyzeValueExpr = function(self,u,v,mode)
	--if v==0 then
		--return 0
	--end
	--return hApi.AnalyzeValueExpr(mode,self.data.world,self.data.tempValue,v,self.data.skillId)
--end
local __AnalyzeValueExpr = function(self,u,v,mode,modeEx)
	if modeEx=="local" then
		return hApi.AnalyzeValueExpr(mode,nil,self.data.tempValue,v,self.data.skillId)
	else
		return hApi.AnalyzeValueExpr(mode,self.data.world,self.data.tempValue,v,self.data.skillId)
	end
end

__aCodeList["LoadPower"] = function(self,mode)
	local d = self.data
	local u = d.unit
	local v = 0
	if u and u~=0 then
		if mode=="cast" then
			d.power = u.attr.power + u.attr.castpower
		else
			d.power = u.attr.power
		end
	end
	return self:doNextAction()
end

local __CODE__ReadValue = function(self,oUnitCur,toParamVar,valueType,valueParam)
	local d = self.data
	if oUnitCur and oUnitCur~=0 then
		if valueType=="TargetEx" then
			local t = d.target
			local nVal = 0
			if type(t)~="table" then
				d.tempValue[toParamVar] = 0
			elseif valueParam=="IsAlly" then
				if t.data.owner==oUnitCur.data.owner then
					nVal = 1
				end
			elseif valueParam=="IsSelf" then
				if t==oUnitCur then
					nVal = 1
				end
			elseif valueParam=="CanCounter" then
				if oUnitCur.attr.fearful>0 then
				elseif oUnitCur.attr.stealth>0 then
				elseif t.data.IsDead==0 and t.attr.stun<=0 and t.attr.counter>0 then
					local nSkillId = hApi.GetDefaultSkill(t,"counter")
					if nSkillId~=0 and hApi.IsSafeTarget(t,nSkillId,d.unit)==hVar.RESULT_SUCESS then
						nVal = 1
					end
				end
			elseif valueParam=="IsHero" then
				if t.data.type==hVar.UNIT_TYPE.HERO then
					nVal = 1
				end
			end
			
			--设置目标值
			d.tempValue[toParamVar] = nVal
		elseif valueType=="BasicAttr" then
			local tabU = hVar.tab_unit[oUnitCur.data.id]
			if tabU and tabU.attr and type(tabU.attr[valueParam])=="number" then
				d.tempValue[toParamVar] = tabU.attr[valueParam]
			else
				d.tempValue[toParamVar] = 0
			end
		elseif valueType=="AttackID" then
			local nAttackId = hApi.GetDefaultSkill(oUnitCur)
			d.tempValue[toParamVar] = AttackID
		elseif (valueType == "BasicAttackID") or (valueType == "NormalAttackID") then --读取普通攻击id
			d.tempValue[toParamVar] = oUnitCur.attr.attack[1]
		elseif valueType=="CurrentPower" then
			d.tempValue[toParamVar] = math.max(0,d.power)
		elseif valueType=="RoundCount" then
			d.tempValue[toParamVar] = d.world.data.roundcount
		elseif valueType=="SkillData" then
			if valueParam=="base_power" then
				local tabS = hVar.tab_skill[d.castId]
				if tabS and type(tabS.base_power)=="number" then
					d.tempValue[toParamVar] = math.floor(tabS.base_power*d.power/100)
				else
					d.tempValue[toParamVar] = d.power
				end
			elseif type(d[valueParam])=="number" then
				d.tempValue[toParamVar] = d[valueParam]
			else
				d.tempValue[toParamVar] = 0
			end
		else
			hApi.ReadUnitValue(d.tempValue,toParamVar,oUnitCur,valueType,valueParam)
		end
	else
		d.tempValue[toParamVar] = 0
	end
end

--{"ReadValue","@num1@","slv",2004}
__aCodeList["ReadValue"] = function(self,_,toParamVar,valueType,valueParam)
	__CODE__ReadValue(self,self.data.unit,toParamVar,valueType,valueParam)
	--print("ReadValue", toParamVar, self.data.tempValue[toParamVar])
	return self:doNextAction()
end

__aCodeList["ReadValueT"] = function(self,_,toParamVar,valueType,valueParam)
	__CODE__ReadValue(self,self.data.target,toParamVar,valueType,valueParam)
	--print("ReadValueT", toParamVar, self.data.tempValue[toParamVar])
	return self:doNextAction()
end

local _enum_GetUnitById = function(t,tParam)
	if tParam.target==nil then
		if tParam.typ=="ENEMY" then
			if t.data.id==tParam.id and t.data.owner~=tParam.owner then
				tParam.target = t
			end
		elseif tParam.typ=="ALLY" then
			if t.data.id==tParam.id and t.data.owner==tParam.owner then
				tParam.target = t
			end
		elseif tParam.typ=="PART" then
			if t.data.partID==tParam.id and t.data.owner==tParam.owner then
				tParam.target = t
			end
		end
	end
end

__aCodeList["ReadValueById"] = function(self,_,sAlly,nUnitId,toParamVar,valueType,valueParam)
	local d = self.data
	local oWorld = d.world
	local id = __AnalyzeValueExpr(self,d.unit,nUnitId,"number")
	local tParam = {id=id,owner=d.unit.data.owner,typ=sAlly}
	oWorld:enumunit(_enum_GetUnitById,tParam)
	if tParam.target~=nil then
		__CODE__ReadValue(self,tParam.target,toParamVar,valueType,valueParam)
	end
	return self:doNextAction()
end

__aCodeList["ReadSkillValue"] = function(self,_,toParamVar,skillId,valueParam)
	local d = self.data
	local u = d.unit
	local v = 0
	if u and u~=0 then
		local id = 0
		if skillId=="attack" then
			id = hApi.GetDefaultSkill(u)
		elseif skillId=="counter" then
			id = hApi.GetDefaultSkill(u,"counter")
		else
			id = __AnalyzeValueExpr(self,u,skillId,"number")
		end
		if id and id~=0 and hVar.tab_skill[id] and type(hVar.tab_skill[id][valueParam])=="number" then
			d.tempValue[toParamVar] = hVar.tab_skill[id][valueParam]
		else
			d.tempValue[toParamVar] = 0
		end
	end
	return self:doNextAction()
end

--geyachao:读取竞技场指定兵种卡的技能属性加成，并存到tempValue表中
__aCodeList["ReadValue_Tactic_PVP"] = function(self, _, tacticId)
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着,zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		__Read_Tactic_Attr_PVP(oUnit, tacticId, d.tempValue)
	end
	
	return self:doNextAction()
end

__aCodeList["CopyPower"] = function(self,_,fromWhichUnit,fromWhichBuff)
	local d = self.data
	local u
	if fromWhitchUnit=="unit" then
		u = d.unit
	else
		u = d.target
	end
	if fromWhichBuff and (u and u~=0 and u.ID~=0 and u.data.IsDead~=1) then
		local oBuff = u:getbuff(fromWhichBuff)
		if oBuff then
			d.power = oBuff.data.power
		end
	end
	return self:doNextAction()
end

__aCodeList["SetCaster"] = function(self,_,fromWhichUnit,fromWhichBuff)
	local d = self.data
	local u
	if fromWhitchUnit=="unit" then
		u = d.unit
	else
		u = d.target
	end
	if fromWhichBuff and (u and u~=0 and u.ID~=0 and u.data.IsDead~=1) then
		local oBuff = u:getbuff(fromWhichBuff)
		if oBuff then
			u = oBuff.data.unit
		end
	end
	if u and u~=0 and u.ID~=0 and u.data.IsDead~=1 then
		d.unit = u
		return self:doNextAction()
	else
		d.IsBuff = -1
		d.IsPaused = 0
		return self:doNextAction()
	end
end

__aCodeList["SetTarget"] = function(self,_,fromWhichUnit,fromWhichBuff)
	local d = self.data
	local u
	if fromWhichUnit=="unit" then
		u = d.unit
	elseif fromWhichUnit=="target" then
		u = d.targetC
	elseif fromWhichUnit==0 then
		d.target = 0
		return self:doNextAction()
	elseif fromWhichUnit==-1 then
		d.target = 0
		d.targetC = 0
		return self:doNextAction()
	else
		u = d.target
	end
	if fromWhichBuff and (u and u~=0 and u.ID~=0 and u.data.IsDead~=1) then
		local oBuff = u:getbuff(fromWhichBuff)
		if oBuff then
			u = oBuff.data.unit
		end
	end
	if u and u~=0 and u.ID~=0 then
		d.target = u
		return self:doNextAction()
	else
		d.IsBuff = -1
		d.IsPaused = 0
		return self:doNextAction()
	end
end

__aCodeList["CheckValue"] = function(self,_,toParamVar,nMin,nMax,vDefault)
	local d = self.data
	if type(d.tempValue[toParamVar])=="number" then
		local v = d.tempValue[toParamVar]
		nMin = nMin or v
		nMax = math.max(nMin,nMax or v)
		d.tempValue[toParamVar] = math.min(math.max(v,nMin),nMax)
	elseif type(vDefault)=="number" then
		d.tempValue[toParamVar] = vDefault
	end
	return self:doNextAction()
end

--设置值
__aCodeList["SetValue"] = function(self, _, toParamVar, expr)
	local d = self.data
	local tValue = d.tempValue
	local v = __AnalyzeValueExpr(self, d.unit, expr, "number")
	tValue[toParamVar] = math.floor(v * 1000) / 1000 --保留3位有效数字，用于同步
	--print("SetValue", toParamVar, tValue[toParamVar])
	
	--geyachao: 特殊处理，如果设置的是普通攻击的技能释放次数，那么也修改人身上的次数
	if (toParamVar == "@skillTimes") then
		d.skillTimes = tValue[toParamVar]
		d.unit.data.atkTimes = tValue[toParamVar] --施法者的普通攻击的次数
	end
	
	return self:doNextAction()
end

--设置值（向上取整）
__aCodeList["SetValue_IntUpper"] = function(self, _, toParamVar, expr)
	local d = self.data
	local tValue = d.tempValue
	local v = __AnalyzeValueExpr(self, d.unit, expr, "number")
	tValue[toParamVar] = math.ceil(v)
	--print("SetValue_IntUpper", toParamVar, tValue[toParamVar])
	
	--geyachao: 特殊处理，如果设置的是普通攻击的技能释放次数，那么也修改人身上的次数
	if (toParamVar == "@skillTimes") then
		d.skillTimes = tValue[toParamVar]
		d.unit.data.atkTimes = tValue[toParamVar] --施法者的普通攻击的次数
	end
	
	return self:doNextAction()
end

--设置值（向下取整）
__aCodeList["SetValue_IntLower"] = function(self, _, toParamVar, expr)
	local d = self.data
	local tValue = d.tempValue
	local v = __AnalyzeValueExpr(self, d.unit, expr, "number")
	tValue[toParamVar] = math.floor(v)
	--print("SetValue_IntLower", toParamVar, tValue[toParamVar])
	
	--geyachao: 特殊处理，如果设置的是普通攻击的技能释放次数，那么也修改人身上的次数
	if (toParamVar == "@skillTimes") then
		d.skillTimes = tValue[toParamVar]
		d.unit.data.atkTimes = tValue[toParamVar] --施法者的普通攻击的次数
	end
	
	return self:doNextAction()
end

--Print
__aCodeList["Print"] = function(self, _, ...)
	local d = self.data
	
	--源代码模式下可用
	if (g_lua_src == 1) then
		local tValue = d.tempValue
		local arg = {...}
		
		local str = ""
		for i = 1, #arg, 1 do
			local toParamVar = arg[i]
			local v = tValue[toParamVar]
			if (i == 1) then
				if v then
					str = tostring(v)
				else
					str = tostring(toParamVar)
				end
			else
				if v then
					str = str .. ", " .. tostring(v)
				else
					str = str .. ", " .. tostring(toParamVar)
				end
			end
		end
		
		print(str)
	end
	
	return self:doNextAction()
end

--{"RandomParam",{{"@x",-24,24},{"@y",-24,24},}},
__aCodeList["RandomParam"] = function(self,_,toParamVar,nMin,nMax)
	local d = self.data
	local w = d.world
	local tValue = d.tempValue
	local case = type(toParamVar)
	if case=="string" then
		if (nMax or nMin)~=nMin then
			tValue[toParamVar] = w:random(nMin, nMax) --{nMin,nMax}
		else
			tValue[toParamVar] = nMin
		end
	elseif case=="table" then
		for i = 1,#toParamVar do
			if type(toParamVar[i])=="table" and type(toParamVar[i][1])=="string" then
				local key,nMin,nMax = unpack(toParamVar[i])
				if (nMax or nMin)~=nMin then
					tValue[key] = w:random(nMin, nMax) --{nMin,nMax}
				else
					tValue[key] = nMin
				end
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["RandomValue"] = function(self,_, toParamVar, nMin, nMax)
	local d = self.data
	local tValue = d.tempValue
	local case = type(toParamVar)
	if type(nMin)~="number" then
		nMin = __AnalyzeValueExpr(self,d.unit,nMin,"number")
	end
	if type(nMax)~="number" then
		nMax = __AnalyzeValueExpr(self,d.unit,nMax,"number")
	end
	local oWorld = d.unit:getworld()
	if oWorld~=nil then
		if case=="string" then
			--local tTemp = hApi.randomEx(oWorld,nMin,nMax,1,"randomvalueI")
			--tValue[toParamVar] = (tTemp[1] or 0)
			local tTemp = oWorld:random(nMin, nMax)
			tValue[toParamVar] = tTemp
			--print("RandomValue", toParamVar, tValue[toParamVar])
			
			--geyachao: 特殊处理，如果设置的是普通攻击的技能释放次数，那么也修改人身上的次数
			if (toParamVar == "@skillTimes") then
				d.skillTimes = tValue[toParamVar]
				d.unit.data.atkTimes = tValue[toParamVar] --施法者的普通攻击的次数
			end
		elseif case=="table" then
			--多个参数取随机，且结果并不相同
			--local tTemp = hApi.randomEx(oWorld,nMin,nMax,#toParamVar,"randomvalueII")
			--for i = 1,#toParamVar do
			--	tValue[toParamVar[i]] = (tTemp[i] or 0)
			--end
			for i = 1,#toParamVar do
				local tTempi = oWorld:random(nMin, nMax)
				tValue[toParamVar[i]] = tTempi
				
				if (toParamVar[i] == "@skillTimes") then
					d.skillTimes = tValue[toParamVar[i]]
					d.unit.data.atkTimes = tValue[toParamVar[i]] --施法者的普通攻击的次数
				end
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["GetPartIsDead"] = function(self,_,toParamVar,partid)--获得一个part的血量 仅能用于boss船战
	local d = self.data
	local tValue = d.tempValue
	local oWorld = d.unit:getworld()
	if oWorld~=nil then
		oWorld:enumunit(function(eu)
			if eu.data.partID == partid then
				if eu.data.IsDead then
					tValue[toParamVar] = eu.data.IsDead
				end
			end
		end)
	end
	return self:doNextAction()
end

__aCodeList["SetCooldown"] = function(self,_,id,vCool,vCoolMax,sIdName)
	local d = self.data
	local u = d.unit
	local nCool = hApi.AnalyzeValueExpr("number",nil,d.tempValue,vCool,d.skillId)
	local nCoolMax
	if vCoolMax~=nil then
		nCoolMax = hApi.AnalyzeValueExpr("number",nil,d.tempValue,vCoolMax,d.skillId)
	end
	--复制施法不会改变冷却
	if d.CastOrder==hVar.ORDER_TYPE.COPY_CAST then
		return self:doNextAction()
	end
	if id=="all" then
		local v = u.attr.skill
		if type(v)=="table" then
			for i = 1,v.i do
				local s = v[i]
				if type(s)=="table" then
					if nCoolMax and nCool>0 then
						if s[3]<nCoolMax then
							s[3] = math.min(nCoolMax,math.max(0,s[3] + nCool))
						end
					else
						s[3] = math.max(0,s[3] + nCool)
					end
				end
			end
		end
	elseif id=="random" then
		local v = u.attr.skill
		if type(v)=="table" then
			local t = {}
			for i = 1,v.i do
				local s = v[i]
				if type(s)=="table" and s[1]>0 and s[2]>0 and s[4]>=0 and hVar.tab_skill[s[1]]~=nil then
					local tabS = hVar.tab_skill[s[1]]
					if tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID or tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
						if nCool>0 then
							if s[3]<(nCoolMax or s[3]+1) then
								t[#t+1] = s
							end
						elseif nCool<0 then
							if s[3]>math.max(0,nCoolMax or 0) then
								t[#t+1] = s
							end
						end
					end
				end
			end
			local nId = 0
			if #t>0 then
				local s = t[d.world:random(1,#t)]
				s[3] = math.max(0,s[3] + nCool)
				nId = s[1]
			end
			if type(sIdName)=="string" then
				d.tempValue[sIdName] = nId
			end
		end
	elseif type(id)=="number" then
		if id<=0 then
			id = self.data.skillId
		end
		local s = u:getskill(id)
		if s then
			if nCoolMax and nCool>0 then
				if s[3]<nCoolMax then
					s[3] = math.min(nCoolMax,math.max(0,s[3] + nCool))
				end
			else
				s[3] = math.max(0,s[3] + nCool)
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["CalculateLineGrid"] = function(self,_,saveParam,width,rMin,rMax)
	local d = self.data
	local tValue = d.tempValue
	local tabS = hVar.tab_skill[d.skillId]
	local tX,tY = d.gridX,d.gridY
	if rMax==nil then
		rMax = rMin
	end
	local g = d.world:gridInUnitRange({},d.unit,rMin,rMax)
	
	return self:doNextAction()
end

__aCodeList["ReDirectTargetGrid"] = function(self,_,mode)
	local d = self.data
	local t = d.target
	if t and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		local ux,uy = d.unit:getXY(1)
		d.gridX,d.gridY = hApi.GetGridByUnitAndXY(t,mode,ux,uy)
	end
	return self:doNextAction()
end

--击退目标
local __KnockBack = function(oTarget,IgnoreGrid,width,cx,cy,tx,ty)
	local w = oTarget:getworld()
	local g
	if IgnoreGrid then
		w:addblockT(IgnoreGrid)
		g = oTarget:getmovegrid(1,1)
		w:removeblockT(IgnoreGrid)
	else
		g = oTarget:getmovegrid(1,1)
	end
	if #g>0 then
		local ux,uy = oTarget:getXY(1)
		----可计算角度的情况下
		--if cx~=ux and cy~=uy then
			--local c = math.atan((cy-uy)/(cx-ux))
			--local px,py = oTarget:getstandXY()
			--local mx,my = ux+math.cos(c)*width-px,uy+math.sin(c)*width-py
			--local gx,gy = w:xy2grid(mx,my)
			--for i = 1,#g do
				--if g[i].x==gx and g[i].y==gy then
					--return oTarget:setgrid(gx,gy,hVar.OPERATE_TYPE.UNIT_TELEPORT)
				--end
			--end
		--end
		local k,p,c = hApi.CalLineParam(cx,cy,tx,ty)
		local cs = k*ux+p*uy+c
		local disF = (ux-cx)^2+(uy-cy)^2
		local selectI = 0
		for i = 1,#g do
			local x,y = oTarget:getXYByPos(g[i].x,g[i].y)
			local us = k*x+p*y+c
			if us*cs>=0 then
				local v = (x-cx)^2+(y-cy)^2
				if disF<v then
					disF = v
					selectI = i
				end
			end
		end
		if g[selectI] then
			return oTarget:setgrid(g[selectI].x,g[selectI].y,hVar.OPERATE_TYPE.UNIT_TELEPORT)
		end
	end
end

__aCodeList["KnockBack"] = function(self)
	local d = self.data
	local u = d.unit
	local t = d.target
	if u and u~=0 and u.ID~=0 and t and t~=0 and t.ID~=0 and t.data.IsDead~=1 and not(t.attr.passive>0 or t.data.partID~=0 or (d.IsFlee==1 and t.attr.fleecount>0)) then
		local tx,ty = t:getXY(1)
		__KnockBack(t,nil,1,d.castX,d.castY,tx,ty)
	end
	return self:doNextAction()
end

--直线选取目标
local __rTab,__cTab,__u,__id,__t,__cx,__cy,__tx,__ty,__k,__p,__c,__m,__width
local __ENUM__SelectTargetByLine = function(oTarget)
	if __cTab and __cTab[oTarget.ID]==1 then
		return
	end
	if oTarget.data.IsDead~=1 and hApi.IsSafeTarget(__u,__id,oTarget,__t)==hVar.RESULT_SUCESS then
		local x,y = oTarget:getXY(1)
		--同方向
		if oTarget==__t then
			local dis = hApi.floor(math.sqrt((__cx-x)^2+(__cy-y)^2))
			__rTab[#__rTab+1] = {oTarget,dis,0}
			if __cTab then
				__cTab[oTarget.ID] = 1
			end
		elseif ((x-__cx)*(__tx-__cx) + (y-__cy)*(__ty-__cy))>=0 and ((x-__tx)*(__cx-__tx) + (y-__ty)*(__cy-__ty))>=0 then
			local cw = math.abs(__k*x+__p*y+__c)/__m
			if cw<=__width then
				local dis = hApi.floor(math.sqrt((__cx-x)^2+(__cy-y)^2))
				__rTab[#__rTab+1] = {oTarget,dis,0}
				if __cTab then
					__cTab[oTarget.ID] = 1
				end
			end
		end
	end
end

local __SelectTargetByLine = function(oWorld,oUnit,id,oTarget,width,cx,cy,tx,ty,rTab,cTab)
	__u = oUnit
	__id = id
	__t = oTarget
	__cx,__cy,__tx,__ty = cx,cy,tx,ty
	--几乎就是一个点的话，不引起任何变化
	if math.abs(cx-tx)<=1 and math.abs(cy-ty)<=1 then
		return
	end
	__k,__p,__c,__m = hApi.CalLineParam(cx,cy,tx,ty)
	__width = width
	__rTab = rTab
	__cTab = cTab
	oWorld:enumunit(__ENUM__SelectTargetByLine)
end

local __CallToDoCode = function(self,ToDo)
	if type(ToDo)=="table" then
		if type(ToDo[1])=="string" and __aCodeList[ToDo[1]] and __aFailToProcess[ToDo[1]]~=1 then
			__aCodeList[ToDo[1]](self,unpack(ToDo))
		elseif #ToDo>0 then
			for i = 1,#ToDo do
				local v = ToDo[i]
				if type(v)=="table" and type(v[1])=="string" and __aCodeList[v[1]] and __aFailToProcess[v[1]]~=1 then
					__aCodeList[v[1]](self,unpack(v))
				end
			end
		end
	end
end

--穿透技能
__aFailToProcess["DoActionToTargetWithLine"] = 1
__aCodeList["DoActionToTargetWithLine"] = function(self,_,speed,length,width,ToDo,MainTargetToDo)
	--千万不要尝试改这个函数
	--永远不要研究穿透的机制
	--只能使用在目标类技能上
	local d = self.data
	local w = d.world
	local tGroup = d.group
	if tGroup==0 then
		tGroup = {}
		--第一次调用，开始初始化
		local tabS = hVar.tab_skill[d.skillId]
		local tX,tY = d.gridX,d.gridY
		local u = d.unit
		local t = d.target
		local ux,uy = d.castX,d.castY
		local tGridX,tGridY
		local oTargetC
		if d.cast==hVar.OPERATE_TYPE.SKILL_TO_UNIT and t and t~=0 then
			oTargetC = t
			tGridX,tGridY = hApi.GetGridByUnitAndXY(t,"near",ux,uy)
		else
			oTargetC = d.targetC
			tGridX,tGridY = d.gridX,d.gridY
		end
		local tx,ty = w:grid2xy(tGridX,tGridY)
		local uGridX,uGridY = hApi.GetGridByUnitAndXY(u,"near",tx,ty)
		local cx,cy = w:grid2xy(uGridX,uGridY)
		local fWidth = math.min(w.data.gridW,w.data.gridH)
		if width>0 then
			fWidth = width*fWidth
		end
		__SelectTargetByLine(w,u,d.skillId,oTargetC,fWidth,cx,cy,tx,ty,tGroup)
		speed = math.max(speed,100)
		if #tGroup>0 then
			table.sort(tGroup,function(a,b)
				return a[2]>b[2]
			end)
			d.group = tGroup
			for i = 1,#tGroup do
				local v = tGroup[i]
				v[3] = math.max(0,hApi.floor(1000*v[2]/speed))
			end
			tGroup[#tGroup+1] = {0,0,0}
		end
		tGroup.n = #tGroup
	end
	if type(tGroup)=="table" and tGroup.n>0 then
		local vCur = tGroup[tGroup.n]
		local nTimeUsed = 0
		if vCur~=nil then
			tGroup.n = tGroup.n - 1
			local oTarget,nDis,nTick = unpack(vCur)
			nTimeUsed = nTick
			if oTarget~=0 and oTarget.ID~=1 and oTarget.data.IsDead~=1 then
				local oldT = d.target
				d.IsPaused = 1
				d.target = oTarget
				if oTarget==oldT and type(MainTargetToDo)=="table" then
					__CallToDoCode(self,MainTargetToDo)
				else
					__CallToDoCode(self,ToDo)
				end
				d.IsPaused = 0
				d.target = oldT
			end
		end
		if tGroup.n>0 then
			d.actionIndex = d.actionIndex-1
			local tick = tGroup[tGroup.n][3]-nTimeUsed
			--print("return sleep,tick    1")
			return "sleep",tick
		end
	end
	return self:doNextAction()
end

--直线技能
__aFailToProcess["DoActionToTargetWithDirection"] = 1
__aCodeList["DoActionToTargetWithDirection"] = function(self,_,speed,length,width,ToDo)
	--只能使用在地点释放的技能上
	local d = self.data
	local w = d.world
	local tGroup = d.group
	if tGroup==0 then
		tGroup = {}
		--第一次调用，开始初始化
		local tabS = hVar.tab_skill[d.skillId]
		local tX,tY = d.gridX,d.gridY
		local u = d.unit
		local t = d.target
		local cx,cy = d.castX,d.castY
		local fWidth = math.min(w.data.gridW,w.data.gridH)
		local tx,ty
		local dx,dy
		if d.targetC~=0 then
			dx,dy = d.targetC:getXY(1)
		else
			dx,dy = w:grid2xy(d.gridX,d.gridY)
		end
		if cx==dx and cy==dy then
			dx = cx + 100*math.cos(math.rad(d.castFacing))
			dy = cy + 100*math.sin(math.rad(d.castFacing))
		end
		if length<=0 then
			--使用目标地点模式
			--tx,ty = w:grid2xy(d.gridX,d.gridY)
			tx,ty = hApi.GetXYByRadial(cx,cy,dx,dy,math.floor(math.sqrt((cx-dx)^2+(cy-dy)^2)+width*fWidth/2))
			tGroup.nArriveTick = hApi.floor(1000*math.sqrt((cx-dx)^2+(cy-dy)^2)/speed)
		else
			--使用朝向模式
			tx,ty = hApi.GetXYByRadial(cx,cy,dx,dy,length*fWidth)
			tGroup.nArriveTick = hApi.floor(1000*math.sqrt((cx-tx)^2+(cy-ty)^2)/speed)
		end
		if width>0 then
			fWidth = width*fWidth
		end
		__SelectTargetByLine(w,u,d.skillId,d.targetC,fWidth,cx,cy,tx,ty,tGroup)
		speed = math.max(speed,100)
		if #tGroup>0 then
			table.sort(tGroup,function(a,b)
				return a[2]>b[2]
			end)
			d.group = tGroup
			for i = 1,#tGroup do
				local v = tGroup[i]
				v[3] = math.max(0,hApi.floor(1000*v[2]/speed))
			end
			tGroup[#tGroup+1] = {0,0,0}
		end
		tGroup.n = #tGroup
	end
	if type(tGroup)=="table" then
		local nTimeUsed = 0
		if tGroup.n>0 then
			local vCur = tGroup[tGroup.n]
			if vCur~=nil then
				tGroup.n = tGroup.n - 1
				local oTarget,nDis,nTick = unpack(vCur)
				nTimeUsed = nTick
				if oTarget~=0 and oTarget.ID~=1 and oTarget.data.IsDead~=1 then
					local oldT = d.target
					d.IsPaused = 1
					d.target = oTarget
					__CallToDoCode(self,ToDo)
					d.IsPaused = 0
					d.target = oldT
				end
			end
			if tGroup.n>0 then
				d.actionIndex = d.actionIndex-1
				local tick = tGroup[tGroup.n][3]-nTimeUsed
				--print("return sleep,tick    2")
				return "sleep",tick
			end
		end
		--最后
		local tick = tGroup.nArriveTick-nTimeUsed
		if tick>0 then
			--print("return sleep,tick    3")
			return "sleep",tick
		end
	end
	return self:doNextAction()
end

--穿透技能
__aFailToProcess["ChargeTo"] = 1
__aCodeList["ChargeTo"] = function(self,_,speed,width,ToDo)
	--千万不要尝试改这个函数
	--永远不要研究穿透的机制
	--只能使用在非目标冲锋类技能上
	local d = self.data
	local w = d.world
	local u = d.unit
	local tGroup = d.group
	if tGroup==0 then
		if d.gridX==u.data.gridX and d.gridY==u.data.gridY then
			tGroup = {n=0,arrive=1,}
			d.group = tGroup
		else
			d.group = {}
			tGroup = d.group
			--命中模式变为自身范围
			d.areaMode = 1
			d.worldX,d.worldY = u:getXYByPos(d.gridX,d.gridY)
			local cx,cy = d.castX,d.castY
			local tx,ty = d.worldX,d.worldY
			tGroup.OriginPos = {cx,cy,tx,ty}
			tGroup.FinalGrid = u:getgrid({},d.gridX,d.gridY)
			--冲刺到目标地点
			if u.ID>0 and u.data.IsDead~=1 then
				if w.data.IsQuickBattlefield==1 then
					u:setgrid(d.gridX,d.gridY,hVar.OPERATE_TYPE.UNIT_TELEPORT)
					tGroup.arrive = 1
				else
					u.attr.IsFlyer = u.attr.IsFlyer + 1
					u.data.chargeID = self.ID
					if speed>0 and u.handle._c then
						local movespeed = hApi.getint(speed*(w.data.movespeed or 100)/100)
						hApi.chaSetMoveSpeed(u.handle,movespeed)
					end
					u:movetogrid(d.gridX,d.gridY)
					u.attr.IsFlyer = u.attr.IsFlyer - 1
				end
			else
				return self:doNextAction()
			end
			if type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				--第一次调用，开始初始化
				local fWidth = math.min(w.data.gridW,w.data.gridH)
				if width>0 then
					fWidth = width*fWidth
				end
				if u.attr.block==hVar.UNIT_BLOCK_MODE.RIDER then
					--两格单位,选择两条线
					local cTab = {}
					local cx,cy = w:grid2xy(u.data.gridX,u.data.gridY)
					local tx,ty = w:grid2xy(d.gridX,d.gridY)
					__SelectTargetByLine(w,u,d.skillId,0,fWidth,cx,cy,tx,ty,tGroup,cTab)
					local cx,cy = w:grid2xy(u.data.gridX+1,u.data.gridY)
					local tx,ty = w:grid2xy(d.gridX+1,d.gridY)
					__SelectTargetByLine(w,u,d.skillId,0,fWidth,cx,cy,tx,ty,tGroup,cTab)
				else
					--一格单位
					local cx,cy = w:grid2xy(u.data.gridX,u.data.gridY)
					local tx,ty = w:grid2xy(d.gridX,d.gridY)
					__SelectTargetByLine(w,u,d.skillId,0,fWidth,cx,cy,tx,ty,tGroup,cTab)
				end
				local tabU = hVar.tab_unit[u.data.id]
				local speed = hApi.getint(tabU.movespeed or hVar.UNIT_DEFAULT_SPEED)
				if #tGroup>0 then
					table.sort(tGroup,function(a,b)
						return a[2]>b[2]
					end)
					for i = 1,#tGroup do
						local v = tGroup[i]
						v[3] = math.max(0,hApi.floor(1000*v[2]/speed))
					end
					tGroup[#tGroup+1] = {0,0,0}
				end
			end
			tGroup.n = #tGroup
		end
	end
	if type(tGroup)=="table" then
		local nTimeUsed = 0
		if tGroup.n>0 then
			local vCur = tGroup[tGroup.n]
			if vCur~=nil then
				tGroup.n = tGroup.n - 1
				local oTarget,nDis,nTick = unpack(vCur)
				nTimeUsed = nTick
				if oTarget~=0 and oTarget.ID~=1 and oTarget.data.IsDead~=1 then
					local oldT = d.target
					d.IsPaused = 1
					d.target = oTarget
					--附带击退效果
					if hVar.tab_skill[d.skillId].knockback==1 then
						__KnockBack(oTarget,tGroup.FinalGrid,math.min(w.data.gridW,w.data.gridH)*1.2,unpack(tGroup.OriginPos))
					end
					__CallToDoCode(self,ToDo)
					d.IsPaused = 0
					d.target = oldT
				end
			end
		end
		if tGroup.n>0 then
			d.actionIndex = d.actionIndex-1
			local tick = tGroup[tGroup.n][3]-nTimeUsed
			--print("return sleep,tick    4")
			return "sleep",tick
		elseif tGroup.arrive~=1 then
			tGroup.arrive = 0
			--需要等待到达
			return "wait",0
		end
	else
		_DEBUG_MSG("[LOGIC ERROR 1]冲锋技能["..d.skillId.."]出现错误")
		u.data.chargeID = -1
	end
	return self:doNextAction()
end

local __CheckCond = function(self,u,expr)
	local r = __AnalyzeValueExpr(self,u,expr,"all")
	if type(r)=="number" then
		if r>0 then
			return true
		end
	elseif r==true then
		return true
	end
	return false
end

local __CheckAllCond = function(self,expr)
	local u = self.data.unit
	if expr==nil then
		return true
	elseif type(expr)=="table" then
		if expr.mode=="or" then
			for i = 1,#expr do
				if __CheckCond(self,u,expr[i]) then
					return true
				end
			end
		else
			for i = 1,#expr do
				if not(__CheckCond(self,u,expr[i])) then
					return false
				end
			end
			return true
		end
	else
		if __CheckCond(self,u,expr) then
			return true
		end
	end
	return false
end

__aFailToProcess["If"] = 1
__aCodeList["If"] = function(self,_,expr,ToDo,ElseToDo)
	if __CheckAllCond(self,expr) then
		--print("通过")
		if type(ToDo)=="table" and ToDo[1]~=nil and __aCodeList[ToDo[1]] then
			return __aCodeList[ToDo[1]](self,unpack(ToDo, 1, table.maxn(ToDo)))
		end
	else
		--print("拒绝")
		if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aCodeList[ElseToDo[1]] then
			return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo, 1, table.maxn(ElseToDo)))
		end
	end
	return self:doNextAction()
end

local __tokenT = {}
__aCodeList["CheckBuff"] = function(self,_,mode,tBuffName,ToDo,ElseToDo)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 then
		local HaveAllBuff = 1
		if type(tBuffName)~="table" then
			__tokenT[1] = tBuffName
			tBuffName = __tokenT
		end
		for i = 1,#tBuffName do
			if t:getbuff(tBuffName[i])==nil then
				HaveAllBuff = 0
				break
			end
		end
		if HaveAllBuff==1 then
			if type(ToDo)=="table" and ToDo[1]~=nil and __aCodeList[ToDo[1]] then
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aCodeList[ElseToDo[1]] then
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["CheckSkill"] = function(self,_,mode,nSkillId,nMinLv,ToDo,ElseToDo)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 then
		local HaveSkill = 0
		local lv = __AnalyzeValueExpr(self,d.unit,nMinLv,"number")
		local s = t:getskill(nSkillId)
		if s and s[2]>=lv then
			HaveSkill = 1
		end
		if HaveSkill==1 then
			if type(ToDo)=="table" and ToDo[1]~=nil and __aCodeList[ToDo[1]] then
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aCodeList[ElseToDo[1]] then
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["GetDistacne"] = function(self,_,valueParam)
	local d = self.data
	local w = d.world
	local u = d.unit
	d.tempValue[valueParam] = 0
	local tabS = hVar.tab_skill[d.skillId]
	if tabS then
		if tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
			local t = d.target
			if t~=0 and t.ID~=0 and t.data.IsDead~=1 then
				d.tempValue[valueParam] = w:distanceU(u,t,1)
			end
		elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
			if u.data.IsDead~=1 then
				d.tempValue[valueParam] = w:distanceU(u,nil,1,d.gridX,d.gridY)
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["Exit"] = function(self,_,expr)
	if __CheckAllCond(self,expr) then
		return "release",1
	else
		return self:doNextAction()
	end
end

--角色播放动作，并且以"stand结尾"
__aCodeList["print"] = function(self,_,...)
	--print(...)
	return self:doNextAction()
end

__aCodeList["printV"] = function(self,_,...)
	local t = {...}
	for i = 1,#t do
		t[i] = __AnalyzeValueExpr(self,self.data.unit,t[i],"number")
	end
	print(unpack(t))
	return self:doNextAction()
end

__aCodeList["printD"] = function(self,_,...)
	local t = {...}
	local d = self.data
	for i = 1,#t do
		local v = d[t[i]]
		if type(v)=="number" then
			t[i] = v
		else
			t[i] = tostring(v)
		end
	end
	print(unpack(t))
	return self:doNextAction()
end

__aCodeList["Slash"] = function(self,_,slashPose,slashName,delay)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit
	if slashName and hVar.SLASH_PATH[slashName] and xlAddKnifeLightWithAngle then
		local sTab = hVar.tab_slash[u.data.id]
		if sTab and type(sTab[slashPose])=="table" then
			local tx,ty,uw,uh = u:getbox()
			local cx,cy = u:getXY()
			local aTag = hApi.calAngleS(u.handle.modelmode,u.data.facing)
			local param = sTab[slashPose][aTag]
			if param then
				local baseWH = (sTab.r or 128)*0.5
				local path = hVar.SLASH_PATH[slashName]
				delay = delay or 0
				if type(path)=="table" then
					path = path[param.model] or path[1]
				end
				if type(path)=="string" then
					local width = param.width
					local r = param.r*baseWH/192
					local roll = param.roll
					local facing = param.facing
					local nShape = param.shape*baseWH/192
					local x = cx+param.x*baseWH/200+tx+uw/2+450
					local y = cy+param.y*baseWH/200+ty+uh/2
					local fadeIn = param.fadeIn/100
					local fadeOut = param.fadeOut/100
					local fDelay = delay+param.delay/100
					local fDelayEx = param.delayEx/100
					local fCycleShape = param.cycleShape/100
					--texturePath,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape
					local ps = xlAddKnifeLightWithAngle(path,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape)
					--ps:setScale(0.2)
				end
			end
		end
	end
	return self:doNextAction()
end

--角色播放动作，并且以"stand结尾"
__aCodeList["Pose"] = function(self,_,pose,slashName,slashPose,nSpeedUp)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(pose)~="string" then
		pose = "stand"
	end
	local d = self.data
	local u = d.unit
	
	--单位死亡，不播动作
	if (u.data.IsDead ~= 1) and (u.attr.hp > 0) then
		if type(nSpeedUp)=="number" then
			local speed = u.handle.__speed
			u.handle.__speed = nSpeedUp
			u:setanimation({pose,"stand"})
			u.handle.__speed = speed
		else
			u:setanimation({pose,"stand"})
		end
		if (slashName or 0)~=0 and hVar.SLASH_PATH[slashName] and xlAddKnifeLightWithAngle then
			slashPose = slashPose or pose
			local sTab = hVar.tab_slash[u.data.id]
			if sTab and type(sTab[slashPose])=="table" then
				local tx,ty,uw,uh = u:getbox()
				local cx,cy = u:getXY()
				local aTag = hApi.calAngleS(u.handle.modelmode,u.data.facing)
				local param = sTab[slashPose][aTag]
				if param then
					local baseWH = sTab.r or 128
					local path = hVar.SLASH_PATH[slashName]
					local delay = 0
					if type(path)=="table" then
						path = path[param.model] or path[1]
					end
					if type(path)=="string" then
						local width = param.width
						local r = param.r*baseWH/192
						local roll = param.roll
						local facing = param.facing
						local nShape = param.shape*baseWH/192
						local x = cx+param.x*baseWH/200+tx+uw/2
						local y = cy+param.y*baseWH/200+ty+uh/2
						local fadeIn = param.fadeIn/100
						local fadeOut = param.fadeOut/100
						local fDelay = delay+param.delay/100
						local fDelayEx = param.delayEx/100
						local fCycleShape = param.cycleShape/100
						--texturePath,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape
						xlAddKnifeLightWithAngle(path,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--角色播放动作，只播放一次
__aCodeList["PoseOnce"] = function(self,_,pose)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(pose)~="string" then
		pose = "stand"
	end
	local d = self.data
	local u = d.unit
	u:playanimation(pose)
	return self:doNextAction()
end

--TD 完成造塔
__aCodeList["FinishTowerGrow_TD"] = function(self)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--生长动画参数
	local growParam = u.data.growParam
	if (type(growParam) == "table") then
		local buildId = growParam.buildId
		local oPlayer = growParam.oPlayer
		--local _oTarget = growParam.oTarget
		local allBuildCost = growParam.allBuildCost
		local baseTower = growParam.baseTower
		local owner = growParam.owner
		local worldX = growParam.worldX
		local worldY = growParam.worldY
		local triggerID = growParam.triggerID
		local growFacing = growParam.growFacing
		
		local oPlayerMe = w:GetPlayerMe()
		local mapInfo = w.data.tdMapInfo
		--local unitData = _oTarget.data
		
		--unitData.facing
		local facing = -45 --默认-45度
		--print("growFacing=", growFacing)
		if growFacing then
			facing = growFacing
		end
		local nu = w:addunit(buildId, owner, nil, nil, facing, worldX, worldY,nil, {triggerID = triggerID,})
		
		nu.handle._n:setPosition(ccp(worldX,-worldY)) --精准位置
		
		if nu then
			--塔顶尘土特效
			--w:addeffect(3090, 1, nil, worldX, worldY - 20) --y:负数往上
			
			--累加建造花费
			nu.data.allBuildCost = allBuildCost
			nu.data.baseTower = baseTower
			
			--记录塔基所属的pos
			nu.data.baseTOwner = owner
			
			--拷贝路点
			--nu:copyRoadPoint(_oTarget)
			
			--绑定triggerID
			if worldScene then
				hApi.chaSetUniqueID(nu.handle, triggerID, worldScene)
			end
			
			--zhenkira 角色出生事件
			hGlobal.event:call("Event_UnitBorn", nu)
			
			--hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nu,"worldmap")
			
			--塔随机转一个角度
			if growFacing then
				--有生长动画，不能随机转
				--...
			else
				local randAngle = w:random(0, 16) * 22.5
				hApi.ChaSetFacing(nu.handle, randAngle) --转向
				nu.data.facing = randAngle
			end
			
			--[[
			if _oTarget~=nil then
				--删除原角色
				_oTarget:del()
			end
			]]
			
			--clickIndex = -1
			--self:settick(250)
			--print(">>>>>>>> self:settick(250) 12")
			
			--[[
			--播放特效及音效
			w:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
			if (oPlayer == oPlayerMe) then
				hApi.PlaySound("button")
			end
			]]
			
			--刷新技能范围
			--hGlobal.event:event("Event_TDUnitActived", w, 1, nu)
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--统计建造塔
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildT)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildT)
				--统计建造塔的总数
				local tabBuild = hVar.tab_unit[buildId]
				--print("buildId", buildId)
				for tagK,v in pairs(hVar.UNIT_TAG_TYPE.TOWER) do
					if tabBuild.tag and tabBuild.tag[v] then
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildTT, v)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildTT, v)
					end
				end
				
				--新手地图，玩家行为统计
				if (mapInfo) and (mapInfo.mapMode == hVar.MAP_TD_TYPE.NEWGUIDE) then --新手地图模式
					--【玩家行为统计】
					--[12] 第四层: 建造任意塔1次
					local id = hVar.PlayerBehaviorList[12] --id: 800000012
					LuaAddBehaviorID(id)
				end
				
				--存档
				--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
			
			--标记是我方单位
			local nForceMe = oPlayerMe:getforce() --我的势力
			if (nForceMe == oPlayer:getforce()) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL_ENEMY) then
				w.data.rpgunits[nu] = nu:getworldC() --标记是我方单位
				--print("标记是我方单位")
			end
			
			--pvp模式，塔有生存时间、血量翻倍、所有塔技能自动升满
			if (mapInfo) then
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					--设置生存时间
					--[[
					local currenttime = w:gametime()
					nu.data.livetimeBegin = currenttime --生存时间开始值（毫秒）
					nu.data.livetime = 60000 * 10 --生存时间（毫秒）
					nu.data.livetimeMax = currenttime + 60000 * 10 --生存时间（毫秒）
					]]
					
					--[[
					--血量翻倍
					nu.attr.hp_max_basic = nu.attr.hp_max_basic * 20 --pvp模式血量超高
					local hp_max = nu:GetHpMax() --最大血量
					nu.attr.hp = hp_max --当前血量
					]]
					
					--[[
					--更新血条控件
					if nu.chaUI["hpBar"] then
						nu.chaUI["hpBar"]:setV(hp_max, hp_max)
						--print("oUnit.chaUI5()", new_hp, hp_max)
					end
					if nu.chaUI["numberBar"] then
						nu.chaUI["numberBar"]:setText(hp_max .. "/" .. hp_max)
					end
					]]
					
					--[[
					--所有塔的技能自动升满
					local td_upgrade = nu.td_upgrade
					if td_upgrade and type(td_upgrade) == "table" then
						local upgradeSkill = td_upgrade.upgradeSkill
						if upgradeSkill then
							if upgradeSkill.order and type(upgradeSkill.order) == "table" then
								for i = 1, #upgradeSkill.order do
									local skillId = upgradeSkill.order[i]
									local skillInfo = upgradeSkill[skillId]
									--如果没有解锁则不创建按钮
									if skillInfo and skillInfo.isUnlock then
										local maxSkillLv = skillInfo.maxLv or 1
										nu:learnSkill(skillId, maxSkillLv)
									end
								end
							else
								for skillId, skillInfo in pairs(upgradeSkill) do
									if skillId ~= "order" then
										--如果没有解锁则不创建按钮
										if skillInfo.isUnlock then
											local maxSkillLv = skillInfo.maxLv or 1
											nu:learnSkill(skillId, maxSkillLv)
										end
									end
								end
							end
						end
					end
					]]
				end
			end
			
			--触发事件: 造塔完成
			--安全执行
			if On_BuildTower_Special_Event then
				hpcall(On_BuildTower_Special_Event, oPlayer, nu)
			end
		end
	end
	
	return self:doNextAction()
end

--TD 造塔
__aCodeList["BuildTower_TD"] = function(self, _, buildId)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--取要建造的塔是否有生长动画
	--如果塔有生长动画，播放生长动画
	local growUnitID = 0
	local tGrowUnitID = hVar.tab_unit[buildId].growUnitID
	if (type(tGrowUnitID) == "table") then
		growUnitID = tGrowUnitID.id or 0
	end
	
	local _oTarget = u
	local unitData = _oTarget.data
	local growUnitDx = tGrowUnitID.dx or 0
	local growUnitDy = tGrowUnitID.dy or 0
	local growFacing = tGrowUnitID.facing or nil
	
	local owner = unitData.owner
	
	local gu = w:addunit(growUnitID, owner, nil, nil, -45, d.worldX+growUnitDx,d.worldY+growUnitDy)
	gu.handle._n:setPosition(ccp(d.worldX+growUnitDx,-(d.worldY+growUnitDy))) --精准位置
	
	w.data.rpgunits[gu] = gu:getworldC() --标记是我方单位
	
	--历史上所有建造的价格
	local allBuildCost = _oTarget.data.allBuildCost or 0
	
	local baseTower = 0
	local oPlayer = _oTarget:getowner()
	
	gu.data.growParam = {buildId = buildId, oPlayer = oPlayer, allBuildCost = allBuildCost, baseTower = baseTower, owner = owner, worldX = d.worldX, worldY = d.worldY, triggerID = _oTarget.data.triggerID, growFacing = growFacing,} --生长动画参数
	
	--zhenkira 角色出生事件
	hGlobal.event:call("Event_UnitBorn", gu)
	
	--播放特效及音效
	w:addeffect(96, 1, nil, d.worldX, d.worldY)
	if (oPlayer == oPlayerMe) then
		hApi.PlaySound("button")
	end
	
	return self:doNextAction()
end

--播放声音
--sound2:连射时播放
__aCodeList["Sound"] = function(self, _, sound, sound2)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	local playsound = sound
	
	--读取当前是否连射状态
	local weapon_attack_state = w.data.weapon_attack_state
	if (weapon_attack_state == 2) then --连射状态
		if sound2 then
			playsound = sound2
		end
	end
	
	--播放音效
	hApi.PlaySound(playsound)
	
	return self:doNextAction()
end

--延迟一段时间
__aCodeList["Delay"] = function(self, _, tick, default)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if (type(tick) == "string") then
		tick = self.data.tempValue[tick]
	end
	
	if type(tick)~="number" then
		local u = self.data.unit
		if tick=="attack" then
			local tabU
			if u and u~=0 then
				tabU = hVar.tab_unit[u.data.id]
			end
			if tabU then
				tick = tabU.attackDelay or default or 300
			else
				tick = default or 300
			end
		else
			tick = 1
		end
	end
	--print("return sleep,tick    5")
	return "sleep",tick
end

__aCodeList["SkillWaitTime"] = function(self, _, tick)
	return self:doNextAction()
end

--角色播放动作，并且以"stand结尾"
__aCodeList["Shake"] = function(self,_,tick)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	--屏幕震动
	if type(tick)~="number" then
		tick = 1
	end
	xlView_Shake()
	if tick<=0 then
		return self:doNextAction()
	else
		--print("return sleep,tick    6")
		return "sleep",1	--shake
	end
end

--跟着角色震动
__aCodeList["ShakeWithPlayer"] = function(self,_,tick,nocover,range)
	print("ShakeWithPlayer",tick)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	--屏幕震动
	if type(tick)~="number" then
		tick = 1
	end
	--xlView_Shake()
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	--print("nocover",type(nocover),d.unit.data.id)
	if nocover == 1 and w.data.shaketick > 0 then
		--print(nocover,w.data.shaketick)
	else
		w.data.shaketick = tick/1000
		w.data.shakestarttime = 0
		if type(range)=="number" then
			w.data.shakerange = range
		else
			w.data.shakerange = nil
		end
	end

	return self:doNextAction()
end

__aCodeList["RemoveAllEffect"] = function(self)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	self:removeAllControlEffect()
	return self:doNextAction()
end

--创建随身特效
__aCodeList["EffectOnTarget"] = function(self,_,mode,effectId,loop,offsetX,offsetY,offsetZ,dummy,rot)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local t
	local oAction = self
	if mode=="unit" then
		t = d.unit
		
		--geyachao: 检测角色是否还是原来的(防止目标死亡后被复用)
		if (t ~= 0) and (t:getworldC() ~= d.unit_worldC) then --不是同一个角色了
			--return "release", 1
			return self:doNextAction()
		end
	elseif mode=="target" then
		t = d.target
		
		--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
		if (t) and (t ~= 0) and (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
			--return "release", 1
			return self:doNextAction()
		end
	elseif type(mode)=="table" then
		--如果是指定角色身上的某一个buff来添加特效的话
		if mode[1]=="unit" then
			t = d.unit
		else--if mode[1]=="target" then
			t = d.target
		end
		if t then
			oAction = t:getbuff(mode[2])
			--如果无法找到buff，那么就不添加了
			if oAction==nil then
				t = nil
			end
		end
	else
		t = d.target
	end
	
	if (type(rot) == "string") then
		--rot = d.tempValue[rot]
		rot = __AnalyzeValueExpr(self, u, rot, "number")
	end
	
	if w and t~=0 and t~=nil then
		--if (hVar.IS_SHOW_HIT_EFFECT_FLAG == 1) then --开关控制
			offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
			offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
			if dummy~=nil and type(dummy)=="string" then
				--local tabU = hVar.tab_unit[t.data.id]
				--if tabU and tabU.boxB then
				--	--拥有战场碰撞盒的单位，永远显示在正中间
				--elseif dummy=="overhead" then
				if dummy=="overhead" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy
				elseif dummy=="origin" then
					offsetX = 0
					offsetY = 0
				elseif dummy=="foot" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy-ch
				elseif dummy=="center" or dummy=="chest" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-math.floor(ch/2+cy)
				else
					offsetX = 0
					offsetY = 0
				end
			end
			
			local angle = t.data.facing --角色面向的角度
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
			end
			
			if (angle < 0) then
				angle = angle + 360
			end
			
			if (angle > 360) then
				angle = angle - 360
			end
			
			--print("szPartAngle=" .. szPartAngle, "t=" .. t.data.name, t.data.id)
			--local tabU = hVar.tab_unit[t.data.id]
			local bullet = t.attr.bullet
			
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				if (bullet[szPartAngle] == nil) then
					--错误弹框
					local strText = "单位[" .. tostring(t.data.id) .. "]的子弹角度[" .. tostring(szPartAngle) .. "]未定义！"
					hGlobal.UI.MsgBox(strText, {
						font = hVar.FONTC,
						ok = function()
						end,
					})
				end
				
				local dx = bullet[szPartAngle].offsetX or 0
				local dy = bullet[szPartAngle].offsetY or 0
				
				offsetX = offsetX + dx
				offsetY = offsetY + dy
			end
			
			if (t.data.bind_unit_owner ~= 0) then
				local angle = t.data.bind_unit_owner.data.facing --角色面向的角度
				--print("szPartAngle=" .. szPartAngle, "t.data.bind_unit_owner=" .. t.data.bind_unit_owner.data.name, t.data.bind_unit_owner.data.id)
				--local tabU = hVar.tab_unit[t.data.id]
				local bulletTank = t.attr.bulletTank
				
				if bulletTank and (bulletTank ~= 0) then
					local NNN = bulletTank.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					
					local dx = bulletTank[szPartAngle].offsetX
					local dy = bulletTank[szPartAngle].offsetY
					
					offsetX = offsetX + dx
					offsetY = offsetY + dy
				end
			end
			
			if (t.data.bind_weapon_owner ~= 0) then
				local angle = t.data.bind_weapon_owner.data.facing --角色面向的角度
				--print("szPartAngle=" .. szPartAngle, "t.data.bind_weapon_owner=" .. t.data.bind_weapon_owner.data.name, t.data.bind_weapon_owner.data.id)
				--local tabU = hVar.tab_unit[t.data.id]
				local bulletTank = t.attr.bulletTank
				
				if bulletTank and (bulletTank ~= 0) then
					local NNN = bulletTank.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					--print(szPartAngle)
					local dx = bulletTank[szPartAngle].offsetX
					local dy = bulletTank[szPartAngle].offsetY
					
					offsetX = offsetX + dx
					offsetY = offsetY + dy
				end
			end
			
			if loop<=0 then
				--print("oAction:addControlEffect")
				local eff = w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
				oAction:addControlEffect(eff)
				
				if rot then
					eff.handle._n:setRotation(rot)
				end
			else
				local eff = w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
				if rot then
					eff.handle._n:setRotation(rot)
				end
			end
		--end
	end
	return self:doNextAction()
end

--创建随身特效（不随子弹偏移）
__aCodeList["EffectOnTarget_NoAdjust"] = function(self,_,mode,effectId,loop,offsetX,offsetY,offsetZ,dummy)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local t
	local oAction = self
	if mode=="unit" then
		t = d.unit
		
		--geyachao: 检测角色是否还是原来的(防止目标死亡后被复用)
		if (t ~= 0) and (t:getworldC() ~= d.unit_worldC) then --不是同一个角色了
			return "release", 1
		end
	elseif mode=="target" then
		t = d.target
		
		--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
		if (t) and (t ~= 0) and (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
			return "release", 1
		end
	elseif type(mode)=="table" then
		--如果是指定角色身上的某一个buff来添加特效的话
		if mode[1]=="unit" then
			t = d.unit
		else--if mode[1]=="target" then
			t = d.target
		end
		if t then
			oAction = t:getbuff(mode[2])
			--如果无法找到buff，那么就不添加了
			if oAction==nil then
				t = nil
			end
		end
	else
		t = d.target
	end
	if w and t~=0 and t~=nil then
		--if (hVar.IS_SHOW_HIT_EFFECT_FLAG == 1) then --开关控制
			offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
			offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
			if dummy~=nil and type(dummy)=="string" then
				local tabU = hVar.tab_unit[t.data.id]
				if tabU and tabU.boxB then
					--拥有战场碰撞盒的单位，永远显示在正中间
				elseif dummy=="overhead" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy
				elseif dummy=="origin" then
					offsetX = 0
					offsetY = 0
				elseif dummy=="foot" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy-ch
				elseif dummy=="center" or dummy=="chest" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-math.floor(ch/2+cy)
				else
					offsetX = 0
					offsetY = 0
				end
			end
			
			if loop<=0 then
				--print("oAction:addControlEffect")
				oAction:addControlEffect(w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY))
			else
				w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
			end
		--end
	end
	return self:doNextAction()
end

--创建随身特效（随子弹偏移）
__aCodeList["EffectOnTarget_Adjust"] = function(self,_,mode,effectId,loop,offsetX,offsetY,offsetZ,dummy,rot)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local t
	local oAction = self
	if mode=="unit" then
		t = d.unit
		
		--geyachao: 检测角色是否还是原来的(防止目标死亡后被复用)
		if (t ~= 0) and (t:getworldC() ~= d.unit_worldC) then --不是同一个角色了
			--return "release", 1
			return self:doNextAction()
		end
	elseif mode=="target" then
		t = d.target
		
		--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
		if (t) and (t ~= 0) and (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
			--return "release", 1
			return self:doNextAction()
		end
	elseif type(mode)=="table" then
		--如果是指定角色身上的某一个buff来添加特效的话
		if mode[1]=="unit" then
			t = d.unit
		else--if mode[1]=="target" then
			t = d.target
		end
		if t then
			oAction = t:getbuff(mode[2])
			--如果无法找到buff，那么就不添加了
			if oAction==nil then
				t = nil
			end
		end
	else
		t = d.target
	end
	
	if (type(rot) == "string") then
		--rot = d.tempValue[rot]
		rot = __AnalyzeValueExpr(self, u, rot, "number")
	end
	
	if w and t~=0 and t~=nil then
		--if (hVar.IS_SHOW_HIT_EFFECT_FLAG == 1) then --开关控制
			offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
			offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
			if dummy~=nil and type(dummy)=="string" then
				--local tabU = hVar.tab_unit[t.data.id]
				--if tabU and tabU.boxB then
				--	--拥有战场碰撞盒的单位，永远显示在正中间
				--elseif dummy=="overhead" then
				if dummy=="overhead" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy
				elseif dummy=="origin" then
					offsetX = 0
					offsetY = 0
				elseif dummy=="foot" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-cy-ch
				elseif dummy=="center" or dummy=="chest" then
					local cx,cy,cw,ch = t:getbox()
					offsetX = offsetX+math.floor(cx+cw/2)
					offsetY = offsetY-math.floor(ch/2+cy)
				else
					offsetX = 0
					offsetY = 0
				end
			end
			
			local angle = t.data.facing --角色面向的角度
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
			end
			
			--print("szPartAngle=" .. szPartAngle, "t=" .. t.data.name, t.data.id)
			--local tabU = hVar.tab_unit[t.data.id]
			local bullet = t.attr.bullet
			
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				if (bullet[szPartAngle] == nil) then
					--错误弹框
					local strText = "单位[" .. tostring(t.data.id) .. "]的子弹角度[" .. tostring(szPartAngle) .. "]未定义！"
					hGlobal.UI.MsgBox(strText, {
						font = hVar.FONTC,
						ok = function()
						end,
					})
				end
				
				local dx = bullet[szPartAngle].offsetX or 0
				local dy = bullet[szPartAngle].offsetY or 0
				
				offsetX = offsetX + dx
				offsetY = offsetY + dy
				
				--print("partAngle=" .. partAngle, "dx=" .. dx, "dy=" .. dy)
			end
			
			local bulletTank = t.attr.bulletTank
			
			if bulletTank and (bulletTank ~= 0) then
				local NNN = bulletTank.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bulletTank[szPartAngle].offsetX
				local dy = bulletTank[szPartAngle].offsetY
				
				offsetX = offsetX + dx
				offsetY = offsetY + dy
			end
			
			if loop<=0 then
				--print("oAction:addControlEffect")
				local eff = w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
				oAction:addControlEffect(eff)
				
				if rot then
					eff.handle._n:setRotation(rot)
				end
			else
				local eff = w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
				--print("addeffect 1", offsetX,offsetY)
				if rot then
					eff.handle._n:setRotation(rot)
				end
			end
		--end
	end
	return self:doNextAction()
end

--播放特效
__aCodeList["EffectOnGrid"] = function(self,_,effectId,loop,posX,posY)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	if w then
		offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
		offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
		local x,y = 0,0
		if posMode=="world" then
			--地面特效，指定worldXY
		elseif posMode=="origin" then
			x,y = u:getXY()
		else
			if posMode=="ground" and not(d.gridX==u.data.gridX and d.gridY==u.data.gridY) then
				x,y = w:grid2xy(d.gridX,d.gridY)
			else
				--x,y = d.worldX,d.worldY
				--geyachao: 目标的位置
				if (type(d.target) == "table") then
					if (d.target.data.IsDead ~= 1) then --目标活着
						x, y = hApi.chaGetPos(d.target.handle) --目标的位置
					else --目标已死亡
						x,y = d.worldX,d.worldY
					end
				else
					x, y = hApi.chaGetPos(u.handle) --施法者的位置
				end
			end
		end
		if loop<=0 then
			self:addControlEffect(w:addeffect(effectId,0,nil,x+offsetX,y+offsetY))
		else
			w:addeffect(effectId,loop,nil,x+offsetX,y+offsetY,u.data.facing,100,animation)
		end
	end
	return self:doNextAction()
end

--geyachao: 直接播放一个地面特效
__aCodeList["EffectOnGround_TD"] = function(self, _, effectId,loop,posX,posY,rot)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	if w then
		if (type(effectId) == "string") then
			effectId = __AnalyzeValueExpr(self,u,effectId,"number")
		end
		
		if (type(loop) == "string") then
			loop = __AnalyzeValueExpr(self,u,loop,"number")
		end
		
		if (type(posX) == "string") then
			posX = __AnalyzeValueExpr(self,u,posX,"number")
		end
		
		if (type(posY) == "string") then
			posY = __AnalyzeValueExpr(self,u,posY,"number")
		end
		
		if (type(rot) == "string") then
			rot = __AnalyzeValueExpr(self,u,rot,"number")
		end
		
		--特效
		local eff = w:addeffect(effectId, loop, nil, posX, posY) --56
		if rot then
			eff.handle._n:setRotation(rot)
		end
	end
	
	return self:doNextAction()
end

--geyachao: TD角色停止移动
__aCodeList["ChaStop_ID"] = function(self, _, targetType)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if unit then
		--停下来
		hApi.UnitStop_TD(unit)
		--print("ChaStop_ID", unit.data.name)
		
		--取消锁定的目标
		local lockTarget = unit.data.lockTarget
		--unit.data.lockTarget = 0
		--unit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
		hApi.UnitTryToLockTarget(unit, 0, 0)
		
		local px, py = hApi.chaGetPos(unit.handle) --位置
		unit.data.defend_x = px
		unit.data.defend_y =  py --中立无路点单位的守卫坐标
		
		--设置ai状态为闲置
		unit:setAIState(hVar.UNIT_AI_STATE.IDLE)
	end
	
	return self:doNextAction()
end

--geyachao: TD新加对角色/目标起始位置放特效
--播放特效
__aCodeList["EffectOnGrid_TD"] = function(self,_, effectId, loop, offsetX, offsetY,posMode,animation, offsetZ)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	if w then
		if (type(effectId) == "string") then
			effectId = d.tempValue[effectId]
		end
		
		offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
		offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
		local x,y = 0,0
		if posMode=="world" then
			--地面特效，指定worldXY
		elseif posMode=="origin" then
			--x,y = u:getXY()
			x,y = hApi.chaGetPos(u.handle) --目标的位置
		elseif posMode=="center" then
			x,y = hApi.chaGetPos(u.handle) --目标的位置
			local cx,cy,cw,ch = u:getbox()
			x = x+math.floor(cx+cw/2)
			y = y+math.floor(ch/2+cy)
		else
			if posMode=="ground" and not(d.gridX==u.data.gridX and d.gridY==u.data.gridY) then
				x,y = w:grid2xy(d.gridX,d.gridY)
			else
				--x,y = d.worldX,d.worldY
				--geyachao: 目标的位置
				if (type(d.target) == "table") then
					if (d.target.data.IsDead ~= 1) then --目标活着
						x, y = hApi.chaGetPos(d.target.handle) --目标的位置
					else --目标已死亡
						x,y = d.worldX,d.worldY
					end
				else
					x, y = hApi.chaGetPos(u.handle) --施法者的位置
				end
			end
		end
		if loop<=0 then
			local e = w:addeffect(effectId,0,nil,x+offsetX,y+offsetY)
			
			--重置z值
			if offsetZ then
				e.handle._n:getParent():reorderChild(e.handle._n, 0)
			end
			
			self:addControlEffect(e)
		else
			--print(d.worldX, d.worldY, offsetX, offsetY)
			if (d.worldX == nil) then
				local x, y = w:grid2xy(d.gridX,d.gridY)
				d.worldX = x
				d.worldY = y
			end
			local e = w:addeffect(effectId,loop,nil,d.worldX+offsetX,d.worldY+offsetY,u.data.facing,100,animation) --todo: 下面才是正确的写法
			--w:addeffect(effectId,loop,nil,x+offsetX,y+offsetY,u.data.facing,100,animation)
			
			--重置z值
			if offsetZ then
				e.handle._n:getParent():reorderChild(e.handle._n, 0)
			end
		end
	end
	return self:doNextAction()
end


--geyachao: TD新加对角色/目标起始位置放特效
--播放特效
__aCodeList["EffectOnGrid_Adjust_TD"] = function(self,_, effectId, loop, offsetX, offsetY,posMode,animation, offsetZ, rot)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	if w then
		if (type(effectId) == "string") then
			effectId = d.tempValue[effectId]
		end
		
		offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
		offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
		
		if (type(rot) == "string") then
			rot = __AnalyzeValueExpr(self,u,rot,"number")
		end
		
		local x,y = 0,0
		if posMode=="world" then
			--地面特效，指定worldXY
		elseif posMode=="origin" then
			--x,y = u:getXY()
			x,y = hApi.chaGetPos(u.handle) --目标的位置
		elseif posMode=="center" then
			x,y = hApi.chaGetPos(u.handle) --目标的位置
			local cx,cy,cw,ch = u:getbox()
			offsetX = offsetX+math.floor(cx+cw/2)
			offsetY = offsetY+math.floor(ch/2+cy)
		else
			if posMode=="ground" and not(d.gridX==u.data.gridX and d.gridY==u.data.gridY) then
				x,y = w:grid2xy(d.gridX,d.gridY)
			else
				--x,y = d.worldX,d.worldY
				--geyachao: 目标的位置
				if (type(d.target) == "table") then
					if (d.target.data.IsDead ~= 1) then --目标活着
						x, y = hApi.chaGetPos(d.target.handle) --目标的位置
					else --目标已死亡
						x,y = d.worldX,d.worldY
					end
				else
					x, y = hApi.chaGetPos(u.handle) --施法者的位置
				end
			end
		end
		
		--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
		local angle = u.data.facing --角色面向的角度
		
		if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		if (tostring(angle) == "nan") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		
		local bullet = u.attr.bullet
		
		--if tabU and tabU.bullet then
		if bullet and (bullet ~= 0) then
			local NNN = bullet.num
			local a1 = 360 / 2 / NNN
			local a2 = a1 * 2
			local degree = math.floor((angle + a1) / a2)
			if (degree == NNN) then
				degree = 0
			end
			local partAngle = degree * a2
			local szPartAngle = tostring(partAngle)
			
			local dx = bullet[szPartAngle].offsetX
			local dy = bullet[szPartAngle].offsetY
			
			offsetX = offsetX + dx
			offsetY = offsetY - dy --geyachao: 地面特效这里是相反的
			--print("partAngle=" .. partAngle, "dx=" .. dx, "dy=" .. dy)
		end
		
		if loop<=0 then
			local e = w:addeffect(effectId,0,nil,x+offsetX,y+offsetY)
			
			--重置z值
			if offsetZ then
				e.handle._n:getParent():reorderChild(e.handle._n, offsetZ)
			end
			
			if rot then
				e.handle._n:setRotation(rot)
			end
			
			self:addControlEffect(e)
		else
			--print(d.worldX, d.worldY, offsetX, offsetY)
			local e = w:addeffect(effectId,loop,nil,x+offsetX,y+offsetY,u.data.facing,100,animation) --todo: 下面才是正确的写法
			--w:addeffect(effectId,loop,nil,x+offsetX,y+offsetY,u.data.facing,100,animation)
			--print("addeffect 2", offsetX,offsetY)
			
			--重置z值
			if offsetZ then
				e.handle._n:getParent():reorderChild(e.handle._n, offsetZ)
			end
			
			if rot then
				e.handle._n:setRotation(rot)
			end
		end
	end
	return self:doNextAction()
end


__aCodeList["EffectOnGridT"] = function(self,_,effectId,loop,offsetX,offsetY)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	if t==0 then
		t = u
	end
	local w = u:getworld()
	if w then
		offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
		offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
		local x,y = d.worldX,d.worldY
		if t~=0 and t.ID>0 then
			x,y = t:getXY()
		end
		if loop<=0 then
			self:addControlEffect(w:addeffect(effectId,0,nil,x+offsetX,y-offsetY))
		else
			w:addeffect(effectId,loop,nil,x+offsetX,y-offsetY)
		end
	end
	return self:doNextAction()
end

--大菠萝加魔法
__aCodeList["Diabo_AddMana"] = function(self, _, addMana)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(addMana) == "string") then
		--print("addMana", addMana)
		addMana = d.tempValue[addMana]
		--print("addMana", addMana)
	end
	
	local w = u:getworld()
	if w then
		local mana = hGlobal.LocalPlayer:getmana()
		hGlobal.LocalPlayer:setmana(mana + addMana)
		
		--冒字
		hApi.ShowLabelBubble(u, "+" .. addMana, ccc3(0, 255, 255), 15, 20, nil, 1500, {model = "effect/shuijing.png", x = -32, y = 2, w = 26, h = 26,})
	end
	
	return self:doNextAction()
end

--闪电链特效
__aCodeList["ChainLighting"] = function(self)
	--geyachao: TD禁止调用此接口
	print(nil .. nil)
	
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	--print("ChainLighting, u=", u and u.data.name or tostring(u), ", t=", t and t.data.name or tostring(t)) 
	if d.pLightingEffect==0 then
		--初始化闪电
		d.pLightingEffect = xlCreateChainEffect(0,1.2,6.0,2)
		if u.handle._n then
			xlChainEffect_AddLink(d.pLightingEffect,u.handle._n,0,30)
		end
		--if t.handle._n then
			--xlChainEffect_AddLink(d.pLightingEffect,t.handle._n)
		--end
		--if t.handle._n then
			--xlChainEffect_AddLink(d.pLightingEffect,t.handle._n)
		--end
	end
	if type(d.pLightingEffect)=="userdata" then
		if t.handle._n then
			xlChainEffect_AddLink(d.pLightingEffect,t.handle._n,0,30)
		end
	end
	
	--print("    闪电链特效", u and u.data.name or u, "--->", t and t.data.name or t) --geyachao print
	
	return self:doNextAction()
end

--geyachao: 新加秒杀目标的效果
__aCodeList["KillTarget"] = function(self)
	local unit = self.data.unit --施法者
	local target = self.data.target --目标
	local target_hp = target.attr.hp --目标的血量
	local skill_id = self.data.skillId --技能id
	if (target_hp > 0) then
		target.attr.hp = 0
		target:dead(hVar.OPERATE_TYPE.SKILL_TO_UNIT, unit, skill_id, target_hp, unit:getowner():getforce(), unit:getowner():getpos())
		--hGlobal.event:event("Event_UnitDamaged", target, nil, nil, "秒杀", 0, unit, 0) --模拟触发事件
		--print(unit.data.name, target.data.name,target_hp, skill_id)
	end
	
	return self:doNextAction()
end

--TD闪电链特效
--geyachao: TD闪电链的发起者重新用变量存储
__aCodeList["ChainLighting_TD"] = function(self,_,offsetX, offsetY, img1, img2)
	offsetX = offsetX or 0 --偏移值x
	offsetY = offsetY or 0 --偏移值y
	
	--print("ChainLighting_TD", hApi.gametime())
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit --闪电链的施法者
	local ChainLastTarget = d.ChainLastTarget --闪电链最近一次的目标
	local target = d.target --闪电链的当前目标
	local fromUint = ChainLastTarget --闪电链链接特效的起始角色
	if (not ChainLastTarget) or (ChainLastTarget == 0) then
		fromUint = u
	end
	
	if d.pLightingEffect == 0 then
		--初始化闪电
		
		if img1 and img2 then
			xlSetChainEffectImage("data/image/" .. img1, "data/image/" .. img2)
		else
			xlSetChainEffectImage("data/image/effect/chain_001.png", "data/image/effect/chain_002.png")
		end
		
		d.pLightingEffect = xlCreateChainEffect(0, 1.2, 6.0, 2)
		if fromUint.handle._n then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bulletEffect = u.attr.bulletEffect
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bulletEffect then
			if bulletEffect and (bulletEffect ~= 0) then
				local NNN = bulletEffect.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bulletEffect[szPartAngle].offsetX
				local dy = bulletEffect[szPartAngle].offsetY
				
				offsetX = offsetX + dx
				offsetY = offsetY + dy
				--print("partAngle=" .. partAngle, "offsetX=" .. offsetX, "offsetY=" .. offsetY)
			--elseif tabU and tabU.bullet then
			elseif bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				offsetX = offsetX + dx
				offsetY = offsetY + dy
				--print("partAngle=" .. partAngle, "offsetX=" .. offsetX, "offsetY=" .. offsetY)
			end
			
			xlChainEffect_AddLink(d.pLightingEffect, fromUint.handle._n, offsetX, offsetY)
		end
	end

	if type(d.pLightingEffect)=="userdata" then
		if target.handle._n then
			xlChainEffect_AddLink(d.pLightingEffect, target.handle._n, offsetX, offsetY)
		end
	end
	
	return self:doNextAction()
end

--转向
__aCodeList["FacingTo"] = function(self,_,mode)
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	if mode=="target" then
		if u~=0 and t~=0 then
			local tx,ty = t:getXY()
			u:facetoXY(tx,ty,1)
		end
	elseif mode=="unit" then
		if u~=0 and t~=0 then
			local cx,cy = u:getXY()
			t:facetoXY(cx,cy,1)
		end
	elseif mode=="grid" then
		if u~=0 then
			u:facetoXY(d.wolrdX,d.worldY,1)
		end
	end
	return self:doNextAction()
end

--geyachao: 新加TD buff改变目标的属性
__aCodeList["AddAttr_Buff"] = function(self, _, attrType, value, bIsPercent)
	local d = self.data
	local tValue = d.tempValue --存储的临时变量表
	local toParamVar = "" --变量名
	local target = d.target --目标
	local w = target:getworld()
	
	--print("添加buff", target.__ID)
	
	--解析表达式
	--local tryValue = tonumber(value)
	--print("tryValue=", tryValue)
	--if tryValue then --填的为整数值或者字符串格式的值(n, "n")
	--	value = tryValue
	--else --填的为表达式
		value = __AnalyzeValueExpr(self, d.unit, value, "number")
	--end
	--print("value=" .. value)
	local orinParamVar = "" --基础索引
	local orinParamVar2 = "" --基础索引2
	
	if (attrType == "hp_max") then --血量
		orinParamVar = "hp_max_basic"
		orinParamVar2 = "hp_max_item"
		toParamVar = "hp_max_buff"
	elseif (attrType == "atk") then --攻击力
		orinParamVar = "atk_basic"
		orinParamVar2 = "atk_item"
		toParamVar = "atk_buff"
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		orinParamVar = "atk_interval_basic"
		orinParamVar2 = "atk_interval_item"
		toParamVar = "atk_interval_buff"
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		orinParamVar = "atk_speed_basic"
		orinParamVar2 = "atk_speed_item"
		toParamVar = "atk_speed_buff"
	elseif (attrType == "move_speed") then --移动速度
		orinParamVar = "move_speed_basic"
		orinParamVar2 = "move_speed_item"
		toParamVar = "move_speed_buff"
	elseif (attrType == "atk_radius") then --攻击范围
		orinParamVar = "atk_radius_basic"
		orinParamVar2 = "atk_radius_item"
		toParamVar = "atk_radius_buff"
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		orinParamVar = "atk_radius_min_basic"
		orinParamVar2 = "atk_radius_min_item"
		toParamVar = "atk_radius_min_buff"
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
	--	orinParamVar = "atk_search_radius_basic"
	--	orinParamVar2 = "atk_search_radius_item"
	--	toParamVar = "atk_search_radius_buff"
	elseif (attrType == "def_physic") then --物防
		orinParamVar = "def_physic_basic"
		orinParamVar2 = "def_physic_item"
		toParamVar = "def_physic_buff"
	elseif (attrType == "def_magic") then --法防
		orinParamVar = "def_magic_basic"
		orinParamVar2 = "def_magic_item"
		toParamVar = "def_magic_buff"
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		orinParamVar = "dodge_rate_basic"
		orinParamVar2 = "dodge_rate_item"
		toParamVar = "dodge_rate_buff"
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		orinParamVar = "hit_rate_basic"
		orinParamVar2 = "hit_rate_item"
		toParamVar = "hit_rate_buff"
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		orinParamVar = "crit_rate_basic"
		orinParamVar2 = "crit_rate_item"
		toParamVar = "crit_rate_buff"
	elseif (attrType == "crit_value") then --暴击倍数（支持小数）
		orinParamVar = "crit_value_basic"
		orinParamVar2 = "crit_value_item"
		toParamVar = "crit_value_buff"
	elseif (attrType == "kill_gold") then --击杀获得的金币
		orinParamVar = "kill_gold_basic"
		orinParamVar2 = "kill_gold_item"
		toParamVar = "kill_gold_buff"
	elseif (attrType == "escape_punish") then --逃怪惩罚
		orinParamVar = "escape_punish_basic"
		orinParamVar2 = "escape_punish_item"
		toParamVar = "escape_punish_buff"
	elseif (attrType == "hp_restore") then --回血速度（支持小数）
		orinParamVar = "hp_restore_basic"
		orinParamVar2 = "hp_restore_item"
		toParamVar = "hp_restore_buff"
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		orinParamVar = "rebirth_time_basic"
		orinParamVar2 = "rebirth_time_item"
		toParamVar = "rebirth_time_buff"
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		orinParamVar = "suck_blood_rate_basic"
		orinParamVar2 = "suck_blood_rate_item"
		toParamVar = "suck_blood_rate_buff"
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		orinParamVar = "active_skill_cd_delta_basic"
		orinParamVar2 = "active_skill_cd_delta_item"
		toParamVar = "active_skill_cd_delta_buff"
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		orinParamVar = "passive_skill_cd_delta_basic"
		orinParamVar2 = "passive_skill_cd_delta_item"
		toParamVar = "passive_skill_cd_delta_buff"
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "active_skill_cd_delta_rate_basic"
		orinParamVar2 = "active_skill_cd_delta_rate_item"
		toParamVar = "active_skill_cd_delta_rate_buff"
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "passive_skill_cd_delta_rate_basic"
		orinParamVar2 = "passive_skill_cd_delta_rate_item"
		toParamVar = "passive_skill_cd_delta_rate_buff"
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		orinParamVar = "AI_attribute_basic"
		orinParamVar2 = "AI_attribute_item"
		toParamVar = "AI_attribute_buff"
	elseif (attrType == "rebirth_wudi_time") then --复活后无敌时间（毫秒）
		orinParamVar = "rebirth_wudi_time_basic"
		orinParamVar2 = "rebirth_wudi_time_item"
		toParamVar = "rebirth_wudi_time_buff"
	elseif (attrType == "basic_weapon_level") then --基础武器等级
		orinParamVar = "basic_weapon_level_basic"
		orinParamVar2 = "basic_weapon_level_item"
		toParamVar = "basic_weapon_level_buff"
	elseif (attrType == "basic_skill_level") then --基础技能等级
		orinParamVar = "basic_skill_level_basic"
		orinParamVar2 = "basic_skill_level_item"
		toParamVar = "basic_skill_level_buff"
	elseif (attrType == "basic_skill_usecount") then --基础技能使用次数
		orinParamVar = "basic_skill_usecount_basic"
		orinParamVar2 = "basic_skill_usecount_item"
		toParamVar = "basic_skill_usecount_buff"
	elseif (attrType == "atk_ice") then --冰攻击力
		orinParamVar = "atk_ice_basic"
		orinParamVar2 = "atk_ice_item"
		toParamVar = "atk_ice_buff"
	elseif (attrType == "atk_thunder") then --雷攻击力
		orinParamVar = "atk_thunder_basic"
		orinParamVar2 = "atk_thunder_item"
		toParamVar = "atk_thunder_buff"
	elseif (attrType == "atk_fire") then --火攻击力
		orinParamVar = "atk_fire_basic"
		orinParamVar2 = "atk_fire_item"
		toParamVar = "atk_fire_buff"
	elseif (attrType == "atk_poison") then --毒攻击力
		orinParamVar = "atk_poison_basic"
		orinParamVar2 = "atk_poison_item"
		toParamVar = "atk_poison_buff"
	elseif (attrType == "atk_bullet") then --子弹攻击力
		orinParamVar = "atk_bullet_basic"
		orinParamVar2 = "atk_bullet_item"
		toParamVar = "atk_bullet_buff"
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		orinParamVar = "atk_bomb_basic"
		orinParamVar2 = "atk_bomb_item"
		toParamVar = "atk_bomb_buff"
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		orinParamVar = "atk_chuanci_basic"
		orinParamVar2 = "atk_chuanci_item"
		toParamVar = "atk_chuanci_buff"
	elseif (attrType == "def_ice") then --冰防御
		orinParamVar = "def_ice_basic"
		orinParamVar2 = "def_ice_item"
		toParamVar = "def_ice_buff"
	elseif (attrType == "def_thunder") then --雷防御
		orinParamVar = "def_thunder_basic"
		orinParamVar2 = "def_thunder_item"
		toParamVar = "def_thunder_buff"
	elseif (attrType == "def_fire") then --火防御
		orinParamVar = "def_fire_basic"
		orinParamVar2 = "def_fire_item"
		toParamVar = "def_fire_buff"
	elseif (attrType == "def_poison") then --毒防御
		orinParamVar = "def_poison_basic"
		orinParamVar2 = "def_poison_item"
		toParamVar = "def_poison_buff"
	elseif (attrType == "def_bullet") then --子弹防御
		orinParamVar = "def_bullet_basic"
		orinParamVar2 = "def_bullet_item"
		toParamVar = "def_bullet_buff"
	elseif (attrType == "def_bomb") then --爆炸防御
		orinParamVar = "def_bomb_basic"
		orinParamVar2 = "def_bomb_item"
		toParamVar = "def_bomb_buff"
	elseif (attrType == "def_chuanci") then --穿刺防御
		orinParamVar = "def_chuanci_basic"
		orinParamVar2 = "def_chuanci_item"
		toParamVar = "def_chuanci_buff"
	elseif (attrType == "bullet_capacity") then --携弹数量
		orinParamVar = "bullet_capacity_basic"
		orinParamVar2 = "bullet_capacity_item"
		toParamVar = "bullet_capacity_buff"
	elseif (attrType == "grenade_capacity") then --手雷数量
		orinParamVar = "grenade_capacity_basic"
		orinParamVar2 = "grenade_capacity_item"
		toParamVar = "grenade_capacity_buff"
	elseif (attrType == "grenade_child") then --子母雷数量
		orinParamVar = "grenade_child_basic"
		orinParamVar2 = "grenade_child_item"
		toParamVar = "grenade_child_buff"
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		orinParamVar = "grenade_fire_basic"
		orinParamVar2 = "grenade_fire_item"
		toParamVar = "grenade_fire_buff"
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		orinParamVar = "grenade_dis_basic"
		orinParamVar2 = "grenade_dis_item"
		toParamVar = "grenade_dis_buff"
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		orinParamVar = "grenade_cd_basic"
		orinParamVar2 = "grenade_cd_item"
		toParamVar = "grenade_cd_buff"
	elseif (attrType == "grenade_crit") then --手雷暴击
		orinParamVar = "grenade_crit_basic"
		orinParamVar2 = "grenade_crit_item"
		toParamVar = "grenade_crit_buff"
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		orinParamVar = "grenade_multiply_basic"
		orinParamVar2 = "grenade_multiply_item"
		toParamVar = "grenade_multiply_buff"
	elseif (attrType == "inertia") then --惯性
		orinParamVar = "inertia_basic"
		orinParamVar2 = "inertia_item"
		toParamVar = "inertia_buff"
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		orinParamVar = "crystal_rate_basic"
		orinParamVar2 = "crystal_rate_item"
		toParamVar = "crystal_rate_buff"
	elseif (attrType == "melee_bounce") then --近战弹开
		orinParamVar = "melee_bounce_basic"
		orinParamVar2 = "melee_bounce_item"
		toParamVar = "melee_bounce_buff"
	elseif (attrType == "melee_fight") then --近战反击
		orinParamVar = "melee_fight_basic"
		orinParamVar2 = "melee_fight_item"
		toParamVar = "melee_fight_buff"
	elseif (attrType == "melee_stone") then --近战碎石
		orinParamVar = "melee_stone_basic"
		orinParamVar2 = "melee_stone_item"
		toParamVar = "melee_stone_buff"
	elseif (attrType == "pet_hp_restore") then --宠物回血
		orinParamVar = "pet_hp_restore_basic"
		orinParamVar2 = "pet_hp_restore_item"
		toParamVar = "pet_hp_restore_buff"
	elseif (attrType == "pet_hp") then --宠物生命
		orinParamVar = "pet_hp_basic"
		orinParamVar2 = "pet_hp_item"
		toParamVar = "pet_hp_buff"
	elseif (attrType == "pet_atk") then --宠物攻击
		orinParamVar = "pet_atk_basic"
		orinParamVar2 = "pet_atk_item"
		toParamVar = "pet_atk_buff"
	elseif (attrType == "pet_atk_speed") then --宠物攻速
		orinParamVar = "pet_atk_speed_basic"
		orinParamVar2 = "pet_atk_speed_item"
		toParamVar = "pet_atk_speed_buff"
	elseif (attrType == "pet_capacity") then --宠物携带数量
		orinParamVar = "pet_capacity_basic"
		orinParamVar2 = "pet_capacity_item"
		toParamVar = "pet_capacity_buff"
	elseif (attrType == "trap_ground") then --陷阱时间（单位：毫秒）
		orinParamVar = "trap_ground_basic"
		orinParamVar2 = "trap_ground_item"
		toParamVar = "trap_ground_buff"
	elseif (attrType == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
		orinParamVar = "trap_groundcd_basic"
		orinParamVar2 = "trap_groundcd_item"
		toParamVar = "trap_groundcd_buff"
	elseif (attrType == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
		orinParamVar = "trap_groundenemy_basic"
		orinParamVar2 = "trap_groundenemy_item"
		toParamVar = "trap_groundenemy_buff"
	elseif (attrType == "trap_fly") then --天网时间（单位：毫秒）
		orinParamVar = "trap_fly_basic"
		orinParamVar2 = "trap_fly_item"
		toParamVar = "trap_fly_buff"
	elseif (attrType == "trap_flycd") then --天网施法间隔（单位：毫秒）
		orinParamVar = "trap_flycd_basic"
		orinParamVar2 = "trap_flycd_item"
		toParamVar = "trap_flycd_buff"
	elseif (attrType == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
		orinParamVar = "trap_flyenemy_basic"
		orinParamVar2 = "trap_flyenemy_item"
		toParamVar = "trap_flyenemy_buff"
	elseif (attrType == "puzzle") then --迷惑几率（去百分号后的值）
		orinParamVar = "puzzle_basic"
		orinParamVar2 = "puzzle_item"
		toParamVar = "puzzle_buff"
	elseif (attrType == "weapon_crit_shoot") then --射击暴击
		orinParamVar = "weapon_crit_shoot_basic"
		orinParamVar2 = "weapon_crit_shoot_item"
		toParamVar = "weapon_crit_shoot_buff"
	elseif (attrType == "weapon_crit_frozen") then --冰冻暴击
		orinParamVar = "weapon_crit_frozen_basic"
		orinParamVar2 = "weapon_crit_frozen_item"
		toParamVar = "weapon_crit_frozen_buff"
	elseif (attrType == "weapon_crit_fire") then --火焰暴击
		orinParamVar = "weapon_crit_fire_basic"
		orinParamVar2 = "weapon_crit_fire_item"
		toParamVar = "weapon_crit_fire_buff"
	elseif (attrType == "weapon_crit_equip") then --装备暴击
		orinParamVar = "weapon_crit_equip_basic"
		orinParamVar2 = "weapon_crit_equip_item"
		toParamVar = "weapon_crit_equip_buff"
	elseif (attrType == "weapon_crit_hit") then --击退暴击
		orinParamVar = "weapon_crit_hit_basic"
		orinParamVar2 = "weapon_crit_hit_item"
		toParamVar = "weapon_crit_hit_buff"
	elseif (attrType == "weapon_crit_blow") then --吹风暴击
		orinParamVar = "weapon_crit_blow_basic"
		orinParamVar2 = "weapon_crit_blow_item"
		toParamVar = "weapon_crit_blow_buff"
	elseif (attrType == "weapon_crit_poison") then --毒液暴击
		orinParamVar = "weapon_crit_poison_basic"
		orinParamVar2 = "weapon_crit_poison_item"
		toParamVar = "weapon_crit_poison_buff"
	end
	
	--检测是否为百分值
	--print("value=",value, target.data.name, orinParamVar .. "=" .. target.attr[orinParamVar], orinParamVar2 .. "=" .. target.attr[orinParamVar2])
	if (bIsPercent == true) or (bIsPercent == 1) then
		value = hApi.floor((target.attr[orinParamVar] + target.attr[orinParamVar2]) * value / 100)
	end
	
	--属性变化后额外的处理
	if (attrType == "hp_max") then --血量
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--修改当前血量
		local olpHp = target.attr.hp
		local oldHpMax = target:GetHpMax()
		local oldPrecent = olpHp / oldHpMax
		local newHpMax = oldHpMax + value
		if (newHpMax <= 0) then
			newHpMax = 1
		end
		
		--修改当前血量
		local newHp = hApi.floor(newHpMax * oldPrecent)
		if (newHp <= 0) and (oldPrecent > 0) then --例如原来为 1/1 的血，加buff变成 1001/1001, 被打成 500/1001之后还原, 应该至少保留1点血
			newHp = 1
		end
		target.attr.hp = newHp
		
		--更新血条控件
		if target.chaUI["hpBar"] then
			target.chaUI["hpBar"]:setV(newHp, newHpMax)
			--print("oUnit.chaUI2()", newHp, newHpMax)
		end
		if target.chaUI["numberBar"] then
			target.chaUI["numberBar"]:setText(newHp .. "/" .. newHpMax)
		end
	elseif (attrType == "atk") then --攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "move_speed") then --移动速度
		--更新移动速度
		hApi.chaAddMoveSpeed(target.handle)
		
		--如果目标是无敌、免控、免疫负面属性，那么减速buff不能加上
		if (target.attr.immue_wudi_stack > 0) or (target.attr.immue_control_stack > 0) or (target.attr.immue_debuff_stack > 0) then --目标是无敌、免控状态、免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
	elseif (attrType == "atk_radius") then --攻击范围
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
		--
	elseif (attrType == "def_physic") then --物防
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_magic") then --法防
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "crit_value") then --暴击倍数
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "kill_gold") then --击杀获得的金币
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "escape_punish") then --逃怪惩罚
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "hp_restore") then --回血速度
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() + value --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
		end
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() + value --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
			--print("+buff: 如果单位绑定了英雄，那么修改英雄数据的主动技能的cd", "value=", value, "activeSkillCD=", activeSkillCD)
		end
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		--
	elseif (attrType == "atk_ice") then --冰攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_thunder") then --雷攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_fire") then --火攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_poison") then --毒攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_bullet") then --子弹攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_ice") then --冰防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_thunder") then --雷防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_fire") then --火防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_poison") then --毒防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_bullet") then --子弹防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_bomb") then --爆炸防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "def_chuanci") then --穿刺防御
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "bullet_capacity") then --携弹数量
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_capacity") then --手雷数量
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_child") then --子母雷数量
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_crit") then --手雷暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
		--大菠萝，设置技能使用次数
		if (target.data.bind_weapon ~= 0) then
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
			if btn2 then
				local grenade_multiply = target:GetGrenadeMultiply() + value
				--手雷使用次数上限
				if (grenade_multiply > hVar.ROLE_GRENADE_MULTIPLY_MAX) then
					grenade_multiply = hVar.ROLE_GRENADE_MULTIPLY_MAX
				end
				if (grenade_multiply > 1) then
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false) --改为都不显示次数了
					btn2.childUI["labSkillUseCount"]:setText(grenade_multiply)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
				else
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
				end
			end
		end
	elseif (attrType == "inertia") then --惯性
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "melee_bounce") then --近战弹开
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "melee_fight") then --近战反击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "melee_stone") then --近战碎石
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "pet_hp_restore") then --宠物回血
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "pet_hp") then --宠物生命
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "pet_atk") then --宠物攻击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "pet_atk_speed") then --宠物攻速
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_shoot") then --射击暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_frozen") then --冰冻暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "pet_capacity") then --宠物携带数量
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_ground") then --陷阱时间（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_fly") then --天网时间（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_flycd") then --天网施法间隔（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value > 0) then --反的
				value = 0
			end
		end
		
		--
	elseif (attrType == "puzzle") then --迷惑几率（去百分号后的值）
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_fire") then --火焰暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_equip") then --装备暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_hit") then --击退暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_blow") then --吹风暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	elseif (attrType == "weapon_crit_poison") then --毒液暴击
		--如果目标是免疫负面属性，那么debuff不能加上
		if (target.attr.immue_debuff_stack > 0) then --目标免疫负面属性
			if (value < 0) then
				value = 0
			end
		end
		
		--
	end
	
	--属性增加
	target.attr[toParamVar] = target.attr[toParamVar] + value
	
	--存储改变的值
	if (not tValue[toParamVar]) then
		tValue[toParamVar] = 0
	end
	tValue[toParamVar] = tValue[toParamVar] + value
	--print("    toParamVar=", tostring(toParamVar) .. ", value=" .. tostring(value) .. ", buff_sum=" .. tostring(target.attr[toParamVar]))
	
	return self:doNextAction()
end

--geyachao: 新加TD 战术技能卡改变目标的属性
__aCodeList["AddAttr_Tactic"] = function(self, _, attrType, t, lv)
	local d = self.data
	lv = lv or "@lv"
	if (type(lv) == "string") then
		lv = d.tempValue[lv]
	end
	
	--print("AddAttr_Tactic", self.data.target.data.name)
	local tValue = d.tempValue --存储的临时变量表
	local toParamVar = "" --变量名
	local target = d.target --目标
	local w = target:getworld()
	local t = t[lv] or {} --对应等级的表
	local value = t.value or 0 --固定值
	local per = t.per or 0 --比例值
	--print("添加tactic", target.__ID)
	
	local orinParamVar = "" --基础索引
	local orinParamVar2 = "" --基础索引2
	
	if (attrType == "hp_max") then --血量
		orinParamVar = "hp_max_basic"
		orinParamVar2 = "hp_max_item"
		toParamVar = "hp_max_tactic"
	elseif (attrType == "atk") then --攻击力
		orinParamVar = "atk_basic"
		orinParamVar2 = "atk_item"
		toParamVar = "atk_tactic"
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		orinParamVar = "atk_interval_basic"
		orinParamVar2 = "atk_interval_item"
		toParamVar = "atk_interval_tactic"
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		orinParamVar = "atk_speed_basic"
		orinParamVar2 = "atk_speed_item"
		toParamVar = "atk_speed_tactic"
	elseif (attrType == "move_speed") then --移动速度
		orinParamVar = "move_speed_basic"
		orinParamVar2 = "move_speed_item"
		toParamVar = "move_speed_tactic"
	elseif (attrType == "atk_radius") then --攻击范围
		orinParamVar = "atk_radius_basic"
		orinParamVar2 = "atk_radius_item"
		toParamVar = "atk_radius_tactic"
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		orinParamVar = "atk_radius_min_basic"
		orinParamVar2 = "atk_radius_min_item"
		toParamVar = "atk_radius_min_tactic"
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
	--	orinParamVar = "atk_search_radius_basic"
	--	orinParamVar2 = "atk_search_radius_item"
	--	toParamVar = "atk_search_radius_tactic"
	elseif (attrType == "def_physic") then --物防
		orinParamVar = "def_physic_basic"
		orinParamVar2 = "def_physic_item"
		toParamVar = "def_physic_tactic"
	elseif (attrType == "def_magic") then --法防
		orinParamVar = "def_magic_basic"
		orinParamVar2 = "def_magic_item"
		toParamVar = "def_magic_tactic"
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		orinParamVar = "dodge_rate_basic"
		orinParamVar2 = "dodge_rate_item"
		toParamVar = "dodge_rate_tactic"
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		orinParamVar = "hit_rate_basic"
		orinParamVar2 = "hit_rate_item"
		toParamVar = "hit_rate_tactic"
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		orinParamVar = "crit_rate_basic"
		orinParamVar2 = "crit_rate_item"
		toParamVar = "crit_rate_tactic"
	elseif (attrType == "crit_value") then --暴击倍数
		orinParamVar = "crit_value_basic"
		orinParamVar2 = "crit_value_item"
		toParamVar = "crit_value_tactic"
	elseif (attrType == "kill_gold") then --击杀获得的金币
		orinParamVar = "kill_gold_basic"
		orinParamVar2 = "kill_gold_item"
		toParamVar = "kill_gold_tactic"
	elseif (attrType == "escape_punish") then --逃怪惩罚
		orinParamVar = "escape_punish_basic"
		orinParamVar2 = "escape_punish_item"
		toParamVar = "escape_punish_tactic"
	elseif (attrType == "hp_restore") then --回血速度
		orinParamVar = "hp_restore_basic"
		orinParamVar2 = "hp_restore_item"
		toParamVar = "hp_restore_tactic"
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		orinParamVar = "rebirth_time_basic"
		orinParamVar2 = "rebirth_time_item"
		toParamVar = "rebirth_time_tactic"
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		orinParamVar = "suck_blood_rate_basic"
		orinParamVar2 = "suck_blood_rate_item"
		toParamVar = "suck_blood_rate_tactic"
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		orinParamVar = "active_skill_cd_delta_basic"
		orinParamVar2 = "active_skill_cd_delta_item"
		toParamVar = "active_skill_cd_delta_tactic"
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		orinParamVar = "passive_skill_cd_delta_basic"
		orinParamVar2 = "passive_skill_cd_delta_item"
		toParamVar = "passive_skill_cd_delta_tactic"
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "active_skill_cd_delta_rate_basic"
		orinParamVar2 = "active_skill_cd_delta_rate_item"
		toParamVar = "active_skill_cd_delta_rate_tactic"
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "passive_skill_cd_delta_rate_basic"
		orinParamVar2 = "passive_skill_cd_delta_rate_item"
		toParamVar = "passive_skill_cd_delta_rate_tactic"
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		orinParamVar = "AI_attribute_basic"
		orinParamVar2 = "AI_attribute_item"
		toParamVar = "AI_attribute_tactic"
	elseif (attrType == "rebirth_wudi_time") then --复活后无敌时间（毫秒）
		orinParamVar = "rebirth_wudi_time_basic"
		orinParamVar2 = "rebirth_wudi_time_item"
		toParamVar = "rebirth_wudi_time_tactic"
	elseif (attrType == "basic_weapon_level") then --基础武器等级
		orinParamVar = "basic_weapon_level_basic"
		orinParamVar2 = "basic_weapon_level_item"
		toParamVar = "basic_weapon_level_tactic"
	elseif (attrType == "basic_skill_level") then --基础技能等级
		orinParamVar = "basic_skill_level_basic"
		orinParamVar2 = "basic_skill_level_item"
		toParamVar = "basic_skill_level_tactic"
	elseif (attrType == "basic_skill_usecount") then --基础技能使用次数
		orinParamVar = "basic_skill_usecount_basic"
		orinParamVar2 = "basic_skill_usecount_item"
		toParamVar = "basic_skill_usecount_tactic"
	elseif (attrType == "atk_ice") then --冰攻击力
		orinParamVar = "atk_ice_basic"
		orinParamVar2 = "atk_ice_item"
		toParamVar = "atk_ice_tactic"
	elseif (attrType == "atk_thunder") then --雷攻击力
		orinParamVar = "atk_thunder_basic"
		orinParamVar2 = "atk_thunder_item"
		toParamVar = "atk_thunder_tactic"
	elseif (attrType == "atk_fire") then --火攻击力
		orinParamVar = "atk_fire_basic"
		orinParamVar2 = "atk_fire_item"
		toParamVar = "atk_fire_tactic"
	elseif (attrType == "atk_poison") then --毒攻击力
		orinParamVar = "atk_poison_basic"
		orinParamVar2 = "atk_poison_item"
		toParamVar = "atk_poison_tactic"
	elseif (attrType == "atk_bullet") then --子弹攻击力
		orinParamVar = "atk_bullet_basic"
		orinParamVar2 = "atk_bullet_item"
		toParamVar = "atk_bullet_tactic"
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		orinParamVar = "atk_bomb_basic"
		orinParamVar2 = "atk_bomb_item"
		toParamVar = "atk_bomb_tactic"
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		orinParamVar = "atk_chuanci_basic"
		orinParamVar2 = "atk_chuanci_item"
		toParamVar = "atk_chuanci_tactic"
	elseif (attrType == "def_ice") then --冰防御
		orinParamVar = "def_ice_basic"
		orinParamVar2 = "def_ice_item"
		toParamVar = "def_ice_tactic"
	elseif (attrType == "def_thunder") then --雷防御
		orinParamVar = "def_thunder_basic"
		orinParamVar2 = "def_thunder_item"
		toParamVar = "def_thunder_tactic"
	elseif (attrType == "def_fire") then --火防御
		orinParamVar = "def_fire_basic"
		orinParamVar2 = "def_fire_item"
		toParamVar = "def_fire_tactic"
	elseif (attrType == "def_poison") then --毒防御
		orinParamVar = "def_poison_basic"
		orinParamVar2 = "def_poison_item"
		toParamVar = "def_poison_tactic"
	elseif (attrType == "def_bullet") then --子弹防御
		orinParamVar = "def_bullet_basic"
		orinParamVar2 = "def_bullet_item"
		toParamVar = "def_bullet_tactic"
	elseif (attrType == "def_bomb") then --爆炸防御
		orinParamVar = "def_bomb_basic"
		orinParamVar2 = "def_bomb_item"
		toParamVar = "def_bomb_tactic"
	elseif (attrType == "def_chuanci") then --穿刺防御
		orinParamVar = "def_chuanci_basic"
		orinParamVar2 = "def_chuanci_item"
		toParamVar = "def_chuanci_tactic"
	elseif (attrType == "bullet_capacity") then --携弹数量
		orinParamVar = "bullet_capacity_basic"
		orinParamVar2 = "bullet_capacity_item"
		toParamVar = "bullet_capacity_tactic"
	elseif (attrType == "grenade_capacity") then --手雷数量
		orinParamVar = "grenade_capacity_basic"
		orinParamVar2 = "grenade_capacity_item"
		toParamVar = "grenade_capacity_tactic"
	elseif (attrType == "grenade_child") then --子母雷数量
		orinParamVar = "grenade_child_basic"
		orinParamVar2 = "grenade_child_item"
		toParamVar = "grenade_child_tactic"
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		orinParamVar = "grenade_fire_basic"
		orinParamVar2 = "grenade_fire_item"
		toParamVar = "grenade_fire_tactic"
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		orinParamVar = "grenade_dis_basic"
		orinParamVar2 = "grenade_dis_item"
		toParamVar = "grenade_dis_tactic"
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		orinParamVar = "grenade_cd_basic"
		orinParamVar2 = "grenade_cd_item"
		toParamVar = "grenade_cd_tactic"
	elseif (attrType == "grenade_crit") then --手雷暴击
		orinParamVar = "grenade_crit_basic"
		orinParamVar2 = "grenade_crit_item"
		toParamVar = "grenade_crit_tactic"
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		orinParamVar = "grenade_multiply_basic"
		orinParamVar2 = "grenade_multiply_item"
		toParamVar = "grenade_multiply_tactic"
	elseif (attrType == "inertia") then --惯性
		orinParamVar = "inertia_basic"
		orinParamVar2 = "inertia_item"
		toParamVar = "inertia_tactic"
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		orinParamVar = "crystal_rate_basic"
		orinParamVar2 = "crystal_rate_item"
		toParamVar = "crystal_rate_tactic"
	elseif (attrType == "melee_bounce") then --近战弹开
		orinParamVar = "melee_bounce_basic"
		orinParamVar2 = "melee_bounce_item"
		toParamVar = "melee_bounce_tactic"
	elseif (attrType == "melee_fight") then --近战反击
		orinParamVar = "melee_fight_basic"
		orinParamVar2 = "melee_fight_item"
		toParamVar = "melee_fight_tactic"
	elseif (attrType == "melee_stone") then --近战碎石
		orinParamVar = "melee_stone_basic"
		orinParamVar2 = "melee_stone_item"
		toParamVar = "melee_stone_tactic"
	elseif (attrType == "pet_hp_restore") then --宠物回血
		orinParamVar = "pet_hp_restore_basic"
		orinParamVar2 = "pet_hp_restore_item"
		toParamVar = "pet_hp_restore_tactic"
	elseif (attrType == "pet_hp") then --宠物生命
		orinParamVar = "pet_hp_basic"
		orinParamVar2 = "pet_hp_item"
		toParamVar = "pet_hp_tactic"
	elseif (attrType == "pet_atk") then --宠物攻击
		orinParamVar = "pet_atk_basic"
		orinParamVar2 = "pet_atk_item"
		toParamVar = "pet_atk_tactic"
	elseif (attrType == "pet_atk_speed") then --宠物攻速
		orinParamVar = "pet_atk_speed_basic"
		orinParamVar2 = "pet_atk_speed_item"
		toParamVar = "pet_atk_speed_tactic"
	elseif (attrType == "pet_capacity") then --宠物携带数量
		orinParamVar = "pet_capacity_basic"
		orinParamVar2 = "pet_capacity_item"
		toParamVar = "pet_capacity_tactic"
	elseif (attrType == "trap_ground") then --陷阱时间（单位：毫秒）
		orinParamVar = "trap_ground_basic"
		orinParamVar2 = "trap_ground_item"
		toParamVar = "trap_ground_tactic"
	elseif (attrType == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
		orinParamVar = "trap_groundcd_basic"
		orinParamVar2 = "trap_groundcd_item"
		toParamVar = "trap_groundcd_tactic"
	elseif (attrType == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
		orinParamVar = "trap_groundenemy_basic"
		orinParamVar2 = "trap_groundenemy_item"
		toParamVar = "trap_groundenemy_tactic"
	elseif (attrType == "trap_fly") then --天网时间（单位：毫秒）
		orinParamVar = "trap_fly_basic"
		orinParamVar2 = "trap_fly_item"
		toParamVar = "trap_fly_tactic"
	elseif (attrType == "trap_flycd") then --天网施法间隔（单位：毫秒）
		orinParamVar = "trap_flycd_basic"
		orinParamVar2 = "trap_flycd_item"
		toParamVar = "trap_flycd_tactic"
	elseif (attrType == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
		orinParamVar = "trap_flyenemy_basic"
		orinParamVar2 = "trap_flyenemy_item"
		toParamVar = "trap_flyenemy_tactic"
	elseif (attrType == "puzzle") then --迷惑几率（去百分号后的值）
		orinParamVar = "puzzle_basic"
		orinParamVar2 = "puzzle_item"
		toParamVar = "puzzle_tactic"
	elseif (attrType == "weapon_crit_shoot") then --射击暴击
		orinParamVar = "weapon_crit_shoot_basic"
		orinParamVar2 = "weapon_crit_shoot_item"
		toParamVar = "weapon_crit_shoot_tactic"
	elseif (attrType == "weapon_crit_frozen") then --冰冻暴击
		orinParamVar = "weapon_crit_frozen_basic"
		orinParamVar2 = "weapon_crit_frozen_item"
		toParamVar = "weapon_crit_frozen_tactic"
	elseif (attrType == "weapon_crit_fire") then --火焰暴击
		orinParamVar = "weapon_crit_fire_basic"
		orinParamVar2 = "weapon_crit_fire_item"
		toParamVar = "weapon_crit_fire_tactic"
	elseif (attrType == "weapon_crit_equip") then --装备暴击
		orinParamVar = "weapon_crit_equip_basic"
		orinParamVar2 = "weapon_crit_equip_item"
		toParamVar = "weapon_crit_equip_tactic"
	elseif (attrType == "weapon_crit_hit") then --击退暴击
		orinParamVar = "weapon_crit_hit_basic"
		orinParamVar2 = "weapon_crit_hit_item"
		toParamVar = "weapon_crit_hit_tactic"
	elseif (attrType == "weapon_crit_blow") then --吹风暴击
		orinParamVar = "weapon_crit_blow_basic"
		orinParamVar2 = "weapon_crit_blow_item"
		toParamVar = "weapon_crit_blow_tactic"
	elseif (attrType == "weapon_crit_poison") then --毒液暴击
		orinParamVar = "weapon_crit_poison_basic"
		orinParamVar2 = "weapon_crit_poison_item"
		toParamVar = "weapon_crit_poison_tactic"
	end
	
	--计算value的最终值
	local value_final = 0
	
	--先加上固定值
	value_final = value_final + value
	
	--再加上百分值
	value_final = value_final + hApi.floor((target.attr[orinParamVar] + target.attr[orinParamVar2]) * per / 100)
	--print("value_final", orinParamVar, orinParamVar2, value_final)
	
	--属性变化后额外的处理
	if (attrType == "hp_max") then --血量
		--修改当前血量
		local olpHp = target.attr.hp
		local oldHpMax = target:GetHpMax()
		local oldPrecent = olpHp / oldHpMax
		local newHpMax = oldHpMax + value_final
		if (newHpMax <= 0) then
			newHpMax = 1
		end
		
		--修改当前血量
		local newHp = hApi.floor(newHpMax * oldPrecent)
		if (newHp <= 0) and (oldPrecent > 0) then --例如原来为 1/1 的血，加buff变成 1001/1001, 被打成 500/1001之后还原, 应该至少保留1点血
			newHp = 1
		end
		target.attr.hp = newHp
		
		--更新血条控件
		if target.chaUI["hpBar"] then
			target.chaUI["hpBar"]:setV(newHp, newHpMax)
			--print("oUnit.chaUI3()", newHp, newHpMax)
		end
		if target.chaUI["numberBar"] then
			target.chaUI["numberBar"]:setText(newHp .. "/" .. newHpMax)
		end
	elseif (attrType == "atk") then --攻击力
		--
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		--
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		--
	elseif (attrType == "move_speed") then --移动速度
		--更新移动速度
		hApi.chaAddMoveSpeed(target.handle)
	elseif (attrType == "atk_radius") then --攻击范围
		--
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		--
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
		--
	elseif (attrType == "def_physic") then --物防
		--
	elseif (attrType == "def_magic") then --法防
		--
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		--
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		--
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		--
	elseif (attrType == "crit_value") then --暴击倍数
		--
	elseif (attrType == "kill_gold") then --击杀获得的金币
		--
	elseif (attrType == "escape_punish") then --逃怪惩罚
		--
	elseif (attrType == "hp_restore") then --回血速度
		--
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		--
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		--
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() + value_final --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
		end
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		--
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() + value_final --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
			--print("+tactic: 如果单位绑定了英雄，那么修改英雄数据的主动技能的cd", "value=", value_final, "activeSkillCD=", activeSkillCD)
		end
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		--
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		--
	elseif (attrType == "atk_ice") then --冰攻击力
		--
	elseif (attrType == "atk_thunder") then --雷攻击力
		--
	elseif (attrType == "atk_fire") then --火攻击力
		--
	elseif (attrType == "atk_poison") then --毒攻击力
		--
	elseif (attrType == "atk_bullet") then --子弹攻击力
		--
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		--
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		--
	elseif (attrType == "def_ice") then --冰防御
		--
	elseif (attrType == "def_thunder") then --雷防御
		--
	elseif (attrType == "def_fire") then --火防御
		--
	elseif (attrType == "def_poison") then --毒防御
		--
	elseif (attrType == "def_bullet") then --子弹防御
		--
	elseif (attrType == "def_bomb") then --爆炸防御
		--
	elseif (attrType == "def_chuanci") then --穿刺防御
		--
	elseif (attrType == "bullet_capacity") then --携弹数量
		--
	elseif (attrType == "grenade_capacity") then --手雷数量
		--
	elseif (attrType == "grenade_child") then --子母雷数量
		--
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		--
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		--
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		--
	elseif (attrType == "grenade_crit") then --手雷暴击
		--
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		--大菠萝，设置技能使用次数
		if (target.data.bind_weapon ~= 0) then
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
			if btn2 then
				local grenade_multiply = target:GetGrenadeMultiply() + value_final
				--手雷使用次数上限
				if (grenade_multiply > hVar.ROLE_GRENADE_MULTIPLY_MAX) then
					grenade_multiply = hVar.ROLE_GRENADE_MULTIPLY_MAX
				end
				if (grenade_multiply > 1) then
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false) --改为都不显示次数了
					btn2.childUI["labSkillUseCount"]:setText(grenade_multiply)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
				else
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
				end
			end
		end
	elseif (attrType == "inertia") then --惯性
		--
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		--
	elseif (attrType == "melee_bounce") then --近战弹开
		--
	elseif (attrType == "melee_fight") then --近战反击
		--
	elseif (attrType == "melee_stone") then --近战碎石
		--
	elseif (attrType == "pet_hp_restore") then --宠物回血
		--
	elseif (attrType == "pet_hp") then --宠物生命
		--
	elseif (attrType == "pet_atk") then --宠物攻击
		--
	elseif (attrType == "pet_atk_speed") then --宠物攻速
		--
	elseif (attrType == "pet_capacity") then --宠物携带数量
		--
	elseif (attrType == "trap_ground") then --陷阱时间（单位：毫秒）
		--
	elseif (attrType == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
		--
	elseif (attrType == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
		--
	elseif (attrType == "trap_fly") then --天网时间（单位：毫秒）
		--
	elseif (attrType == "trap_flycd") then --天网施法间隔（单位：毫秒）
		--
	elseif (attrType == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
		--
	elseif (attrType == "puzzle") then --迷惑几率（去百分号后的值）
		--
	elseif (attrType == "weapon_crit_shoot") then --射击暴击
		--
	elseif (attrType == "weapon_crit_frozen") then --冰冻暴击
		--
	elseif (attrType == "weapon_crit_fire") then --火焰暴击
		--
	elseif (attrType == "weapon_crit_equip") then --装备暴击
		--
	elseif (attrType == "weapon_crit_hit") then --击退暴击
		--
	elseif (attrType == "weapon_crit_blow") then --吹风暴击
		--
	elseif (attrType == "weapon_crit_poison") then --毒液暴击
		--
	end
	
	--属性增加
	target.attr[toParamVar] = target.attr[toParamVar] + value_final
	
	--print("    toParamVar=", tostring(toParamVar) .. ", value_final=" .. tostring(value_final) .. ", tactic_sum=" .. tostring(target.attr[toParamVar]))
	
	return self:doNextAction()
end

--geyachao: 新加TD 光环卡改变目标的属性
__aCodeList["AddAttr_Aura"] = function(self, _, attrType, t, lv)
	local d = self.data
	lv = lv or "@lv"
	if (type(lv) == "string") then
		lv = d.tempValue[lv]
	end
	
	--print("AddAttr_Aura", self.data.target.data.name)
	local tValue = d.tempValue --存储的临时变量表
	local toParamVar = "" --变量名
	local target = d.target --目标
	local w = target:getworld()
	local t = t[lv] --对应等级的表
	local value = t.value --固定值
	local per = t.per --比例值
	--print("添加aura", target.__ID)
	
	local orinParamVar = "" --基础索引
	local orinParamVar2 = "" --基础索引2
	
	if (attrType == "hp_max") then --血量
		orinParamVar = "hp_max_basic"
		orinParamVar2 = "hp_max_item"
		toParamVar = "hp_max_aura"
	elseif (attrType == "atk") then --攻击力
		orinParamVar = "atk_basic"
		orinParamVar2 = "atk_item"
		toParamVar = "atk_aura"
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		orinParamVar = "atk_interval_basic"
		orinParamVar2 = "atk_interval_item"
		toParamVar = "atk_interval_aura"
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		orinParamVar = "atk_speed_basic"
		orinParamVar2 = "atk_speed_item"
		toParamVar = "atk_speed_aura"
	elseif (attrType == "move_speed") then --移动速度
		orinParamVar = "move_speed_basic"
		orinParamVar2 = "move_speed_item"
		toParamVar = "move_speed_aura"
	elseif (attrType == "atk_radius") then --攻击范围
		orinParamVar = "atk_radius_basic"
		orinParamVar2 = "atk_radius_item"
		toParamVar = "atk_radius_aura"
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		orinParamVar = "atk_radius_min_basic"
		orinParamVar2 = "atk_radius_min_item"
		toParamVar = "atk_radius_min_aura"
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
	--	orinParamVar = "atk_search_radius_basic"
	--	orinParamVar2 = "atk_search_radius_item"
	--	toParamVar = "atk_search_radius_aura"
	elseif (attrType == "def_physic") then --物防
		orinParamVar = "def_physic_basic"
		orinParamVar2 = "def_physic_item"
		toParamVar = "def_physic_aura"
	elseif (attrType == "def_magic") then --法防
		orinParamVar = "def_magic_basic"
		orinParamVar2 = "def_magic_item"
		toParamVar = "def_magic_aura"
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		orinParamVar = "dodge_rate_basic"
		orinParamVar2 = "dodge_rate_item"
		toParamVar = "dodge_rate_aura"
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		orinParamVar = "hit_rate_basic"
		orinParamVar2 = "hit_rate_item"
		toParamVar = "hit_rate_aura"
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		orinParamVar = "crit_rate_basic"
		orinParamVar2 = "crit_rate_item"
		toParamVar = "crit_rate_aura"
	elseif (attrType == "crit_value") then --暴击倍数
		orinParamVar = "crit_value_basic"
		orinParamVar2 = "crit_value_item"
		toParamVar = "crit_value_aura"
	elseif (attrType == "kill_gold") then --击杀获得的金币
		orinParamVar = "kill_gold_basic"
		orinParamVar2 = "kill_gold_item"
		toParamVar = "kill_gold_aura"
	elseif (attrType == "escape_punish") then --逃怪惩罚
		orinParamVar = "escape_punish_basic"
		orinParamVar2 = "escape_punish_item"
		toParamVar = "escape_punish_aura"
	elseif (attrType == "hp_restore") then --回血速度
		orinParamVar = "hp_restore_basic"
		orinParamVar2 = "hp_restore_item"
		toParamVar = "hp_restore_aura"
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		orinParamVar = "rebirth_time_basic"
		orinParamVar2 = "rebirth_time_item"
		toParamVar = "rebirth_time_aura"
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		orinParamVar = "suck_blood_rate_basic"
		orinParamVar2 = "suck_blood_rate_item"
		toParamVar = "suck_blood_rate_aura"
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		orinParamVar = "active_skill_cd_delta_basic"
		orinParamVar2 = "active_skill_cd_delta_item"
		toParamVar = "active_skill_cd_delta_aura"
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		orinParamVar = "passive_skill_cd_delta_basic"
		orinParamVar2 = "passive_skill_cd_delta_item"
		toParamVar = "passive_skill_cd_delta_aura"
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "active_skill_cd_delta_rate_basic"
		orinParamVar2 = "active_skill_cd_delta_rate_item"
		toParamVar = "active_skill_cd_delta_rate_aura"
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		orinParamVar = "passive_skill_cd_delta_rate_basic"
		orinParamVar2 = "passive_skill_cd_delta_rate_item"
		toParamVar = "passive_skill_cd_delta_rate_aura"
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		orinParamVar = "AI_attribute_basic"
		orinParamVar2 = "AI_attribute_item"
		toParamVar = "AI_attribute_aura"
	elseif (attrType == "rebirth_wudi_time") then --复活后无敌时间（毫秒）
		orinParamVar = "rebirth_wudi_time_basic"
		orinParamVar2 = "rebirth_wudi_time_item"
		toParamVar = "rebirth_wudi_time_aura"
	elseif (attrType == "basic_weapon_level") then --基础武器等级
		orinParamVar = "basic_weapon_level_basic"
		orinParamVar2 = "basic_weapon_level_item"
		toParamVar = "basic_weapon_level_aura"
	elseif (attrType == "basic_skill_level") then --基础技能等级
		orinParamVar = "basic_skill_level_basic"
		orinParamVar2 = "basic_skill_level_item"
		toParamVar = "basic_skill_level_aura"
	elseif (attrType == "basic_skill_usecount") then --基础技能使用次数
		orinParamVar = "basic_skill_usecount_basic"
		orinParamVar2 = "basic_skill_usecount_item"
		toParamVar = "basic_skill_usecount_aura"
	elseif (attrType == "atk_ice") then --冰攻击力
		orinParamVar = "atk_ice_basic"
		orinParamVar2 = "atk_ice_item"
		toParamVar = "atk_ice_aura"
	elseif (attrType == "atk_thunder") then --雷攻击力
		orinParamVar = "atk_thunder_basic"
		orinParamVar2 = "atk_thunder_item"
		toParamVar = "atk_thunder_aura"
	elseif (attrType == "atk_fire") then --火攻击力
		orinParamVar = "atk_fire_basic"
		orinParamVar2 = "atk_fire_item"
		toParamVar = "atk_fire_aura"
	elseif (attrType == "atk_poison") then --毒攻击力
		orinParamVar = "atk_poison_basic"
		orinParamVar2 = "atk_poison_item"
		toParamVar = "atk_poison_aura"
	elseif (attrType == "atk_bullet") then --子弹攻击力
		orinParamVar = "atk_bullet_basic"
		orinParamVar2 = "atk_bullet_item"
		toParamVar = "atk_bullet_aura"
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		orinParamVar = "atk_bomb_basic"
		orinParamVar2 = "atk_bomb_item"
		toParamVar = "atk_bomb_aura"
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		orinParamVar = "atk_chuanci_basic"
		orinParamVar2 = "atk_chuanci_item"
		toParamVar = "atk_chuanci_aura"
	elseif (attrType == "def_ice") then --冰防御
		orinParamVar = "def_ice_basic"
		orinParamVar2 = "def_ice_item"
		toParamVar = "def_ice_aura"
	elseif (attrType == "def_thunder") then --雷防御
		orinParamVar = "def_thunder_basic"
		orinParamVar2 = "def_thunder_item"
		toParamVar = "def_thunder_aura"
	elseif (attrType == "def_fire") then --火防御
		orinParamVar = "def_fire_basic"
		orinParamVar2 = "def_fire_item"
		toParamVar = "def_fire_aura"
	elseif (attrType == "def_poison") then --毒防御
		orinParamVar = "def_poison_basic"
		orinParamVar2 = "def_poison_item"
		toParamVar = "def_poison_aura"
	elseif (attrType == "def_bullet") then --子弹防御
		orinParamVar = "def_bullet_basic"
		orinParamVar2 = "def_bullet_item"
		toParamVar = "def_bullet_aura"
	elseif (attrType == "def_bomb") then --爆炸防御
		orinParamVar = "def_bomb_basic"
		orinParamVar2 = "def_bomb_item"
		toParamVar = "def_bomb_aura"
	elseif (attrType == "def_chuanci") then --穿刺防御
		orinParamVar = "def_chuanci_basic"
		orinParamVar2 = "def_chuanci_item"
		toParamVar = "def_chuanci_aura"
	elseif (attrType == "bullet_capacity") then --携弹数量
		orinParamVar = "bullet_capacity_basic"
		orinParamVar2 = "bullet_capacity_item"
		toParamVar = "bullet_capacity_aura"
	elseif (attrType == "grenade_capacity") then --手雷数量
		orinParamVar = "grenade_capacity_basic"
		orinParamVar2 = "grenade_capacity_item"
		toParamVar = "grenade_capacity_aura"
	elseif (attrType == "grenade_child") then --子母雷数量
		orinParamVar = "grenade_child_basic"
		orinParamVar2 = "grenade_child_item"
		toParamVar = "grenade_child_aura"
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		orinParamVar = "grenade_fire_basic"
		orinParamVar2 = "grenade_fire_item"
		toParamVar = "grenade_fire_aura"
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		orinParamVar = "grenade_dis_basic"
		orinParamVar2 = "grenade_dis_item"
		toParamVar = "grenade_dis_aura"
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		orinParamVar = "grenade_cd_basic"
		orinParamVar2 = "grenade_cd_item"
		toParamVar = "grenade_cd_aura"
	elseif (attrType == "grenade_crit") then --手雷暴击
		orinParamVar = "grenade_crit_basic"
		orinParamVar2 = "grenade_crit_item"
		toParamVar = "grenade_crit_aura"
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		orinParamVar = "grenade_multiply_basic"
		orinParamVar2 = "grenade_multiply_item"
		toParamVar = "grenade_multiply_aura"
	elseif (attrType == "inertia") then --惯性
		orinParamVar = "inertia_basic"
		orinParamVar2 = "inertia_item"
		toParamVar = "inertia_aura"
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		orinParamVar = "crystal_rate_basic"
		orinParamVar2 = "crystal_rate_item"
		toParamVar = "crystal_rate_aura"
	elseif (attrType == "melee_bounce") then --近战弹开
		orinParamVar = "melee_bounce_basic"
		orinParamVar2 = "melee_bounce_item"
		toParamVar = "melee_bounce_aura"
	elseif (attrType == "melee_fight") then --近战反击
		orinParamVar = "melee_fight_basic"
		orinParamVar2 = "melee_fight_item"
		toParamVar = "melee_fight_aura"
	elseif (attrType == "melee_stone") then --近战碎石
		orinParamVar = "melee_stone_basic"
		orinParamVar2 = "melee_stone_item"
		toParamVar = "melee_stone_aura"
	elseif (attrType == "pet_hp_restore") then --宠物回血
		orinParamVar = "pet_hp_restore_basic"
		orinParamVar2 = "pet_hp_restore_item"
		toParamVar = "pet_hp_restore_aura"
	elseif (attrType == "pet_hp") then --宠物生命
		orinParamVar = "pet_hp_basic"
		orinParamVar2 = "pet_hp_item"
		toParamVar = "pet_hp_aura"
	elseif (attrType == "pet_atk") then --宠物攻击
		orinParamVar = "pet_atk_basic"
		orinParamVar2 = "pet_atk_item"
		toParamVar = "pet_atk_aura"
	elseif (attrType == "pet_atk_speed") then --宠物攻速
		orinParamVar = "pet_atk_speed_basic"
		orinParamVar2 = "pet_atk_speed_item"
		toParamVar = "pet_atk_speed_aura"
	elseif (attrType == "pet_capacity") then --宠物携带数量
		orinParamVar = "pet_capacity_basic"
		orinParamVar2 = "pet_capacity_item"
		toParamVar = "pet_capacity_aura"
	elseif (attrType == "trap_ground") then --陷阱时间（单位：毫秒）
		orinParamVar = "trap_ground_basic"
		orinParamVar2 = "trap_ground_item"
		toParamVar = "trap_ground_aura"
	elseif (attrType == "trap_groundcd") then --陷阱施法间隔（单位：毫秒）
		orinParamVar = "trap_groundcd_basic"
		orinParamVar2 = "trap_groundcd_item"
		toParamVar = "trap_groundcd_aura"
	elseif (attrType == "trap_groundenemy") then --陷阱困敌时间（单位：毫秒）
		orinParamVar = "trap_groundenemy_basic"
		orinParamVar2 = "trap_groundenemy_item"
		toParamVar = "trap_groundenemy_aura"
	elseif (attrType == "trap_fly") then --天网时间（单位：毫秒）
		orinParamVar = "trap_fly_basic"
		orinParamVar2 = "trap_fly_item"
		toParamVar = "trap_fly_aura"
	elseif (attrType == "trap_flycd") then --天网施法间隔（单位：毫秒）
		orinParamVar = "trap_flycd_basic"
		orinParamVar2 = "trap_flycd_item"
		toParamVar = "trap_flycd_aura"
	elseif (attrType == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
		orinParamVar = "trap_flyenemy_basic"
		orinParamVar2 = "trap_flyenemy_item"
		toParamVar = "trap_flyenemy_aura"
	elseif (attrType == "puzzle") then --迷惑几率（去百分号后的值）
		orinParamVar = "puzzle_basic"
		orinParamVar2 = "puzzle_item"
		toParamVar = "puzzle_aura"
	elseif (attrType == "weapon_crit_shoot") then --射击暴击
		orinParamVar = "weapon_crit_shoot_basic"
		orinParamVar2 = "weapon_crit_shoot_item"
		toParamVar = "weapon_crit_shoot_aura"
	elseif (attrType == "weapon_crit_frozen") then --冰冻暴击
		orinParamVar = "weapon_crit_frozen_basic"
		orinParamVar2 = "weapon_crit_frozen_item"
		toParamVar = "weapon_crit_frozen_aura"
	elseif (attrType == "weapon_crit_fire") then --火焰暴击
		orinParamVar = "weapon_crit_fire_basic"
		orinParamVar2 = "weapon_crit_fire_item"
		toParamVar = "weapon_crit_fire_aura"
	elseif (attrType == "weapon_crit_equip") then --装备暴击
		orinParamVar = "weapon_crit_equip_basic"
		orinParamVar2 = "weapon_crit_equip_item"
		toParamVar = "weapon_crit_equip_aura"
	elseif (attrType == "weapon_crit_hit") then --击退暴击
		orinParamVar = "weapon_crit_hit_basic"
		orinParamVar2 = "weapon_crit_hit_item"
		toParamVar = "weapon_crit_hit_aura"
	elseif (attrType == "weapon_crit_blow") then --吹风暴击
		orinParamVar = "weapon_crit_blow_basic"
		orinParamVar2 = "weapon_crit_blow_item"
		toParamVar = "weapon_crit_blow_aura"
	elseif (attrType == "weapon_crit_poison") then --毒液暴击
		orinParamVar = "weapon_crit_poison_basic"
		orinParamVar2 = "weapon_crit_poison_item"
		toParamVar = "weapon_crit_poison_aura"
	end
	
	--计算value的最终值
	local value_final = 0
	
	--先加上固定值
	value_final = value_final + value
	
	--再加上百分值
	value_final = value_final + hApi.floor((target.attr[orinParamVar] + target.attr[orinParamVar2]) * per / 100)
	--print("value_final", orinParamVar, orinParamVar2, value_final)
	
	--属性变化后额外的处理
	if (attrType == "hp_max") then --血量
		--修改当前血量
		local olpHp = target.attr.hp
		local oldHpMax = target:GetHpMax()
		local oldPrecent = olpHp / oldHpMax
		
		--[[
		local newHpMax = oldHpMax + value_final
		if (newHpMax <= 0) then
			newHpMax = 1
		end
		
		--修改当前血量
		local newHp = hApi.floor(newHpMax * oldPrecent)
		if (newHp <= 0) and (oldPrecent > 0) then --例如原来为 1/1 的血，加buff变成 1001/1001, 被打成 500/1001之后还原, 应该至少保留1点血
			newHp = 1
		end
		target.attr.hp = newHp
		]]
		--geyachao: 战车加血上限，不改变当前血量了
		local newHpMax = oldHpMax + value_final
		if (newHpMax <= 0) then
			newHpMax = 1
		end
		if (olpHp > newHpMax) then
			target.attr.hp = newHpMax
		end
		local newHp = target.attr.hp
		
		--更新血条控件
		if target.chaUI["hpBar"] then
			target.chaUI["hpBar"]:setV(newHp, newHpMax)
			--print("oUnit.chaUI3()", newHp, newHpMax)
		end
		if target.chaUI["numberBar"] then
			target.chaUI["numberBar"]:setText(newHp .. "/" .. newHpMax)
		end
		
		--设置大菠萝的血条
		local oHero = target:gethero()
		if oHero then
			SetHeroHpBarPercent(oHero, newHp, newHpMax)
		end
	elseif (attrType == "atk") then --攻击力
		--
	elseif (attrType == "atk_interval") then --攻击间隔（毫秒）
		--
	elseif (attrType == "atk_speed") then --攻击速度（去百分号后的值）
		--
	elseif (attrType == "move_speed") then --移动速度
		--更新移动速度
		hApi.chaAddMoveSpeed(target.handle)
	elseif (attrType == "atk_radius") then --攻击范围
		--
	elseif (attrType == "atk_radius_min") then --攻击范围最小值
		--
	--elseif (attrType == "atk_search_radius") then --攻击搜敌范围
		--
	elseif (attrType == "def_physic") then --物防
		--
	elseif (attrType == "def_magic") then --法防
		--
	elseif (attrType == "dodge_rate") then --闪避几率（去百分号后的值）
		--
	elseif (attrType == "hit_rate") then --命中几率（去百分号后的值）
		--
	elseif (attrType == "crit_rate") then --暴击几率（去百分号后的值）
		--
	elseif (attrType == "crit_value") then --暴击倍数
		--
	elseif (attrType == "kill_gold") then --击杀获得的金币
		--
	elseif (attrType == "escape_punish") then --逃怪惩罚
		--
	elseif (attrType == "hp_restore") then --回血速度
		--
	elseif (attrType == "rebirth_time") then --复活时间（毫秒）
		--
	elseif (attrType == "suck_blood_rate") then --吸血率（去百分号后的值）
		--
	elseif (attrType == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() + value_final --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
		end
	elseif (attrType == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
		--
	elseif (attrType == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
		--如果单位绑定了英雄，那么修改英雄数据的主动技能的cd
		local oHero = target:gethero()
		if oHero then
			local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
			local activeSkillCDMul = activeSkillCDOrigin * 1000
			local active_skill_cd_delta = target:GetActiveSkillCDDelta() --geyachao: cd附加改变值
			local active_skill_cd_delta_rate = target:GetActiveSkillCDDeltaRate() + value_final --geyachao: cd附加改变比例值
			local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
			activeSkillCDMul = activeSkillCDMul + delta
			local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
			
			--d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
			oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
			--print("+aura: 如果单位绑定了英雄，那么修改英雄数据的主动技能的cd", "value=", value_final, "activeSkillCD=", activeSkillCD)
		end
	elseif (attrType == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
		--
	elseif (attrType == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
		--
	elseif (attrType == "atk_ice") then --冰攻击力
		--
	elseif (attrType == "atk_thunder") then --雷攻击力
		--
	elseif (attrType == "atk_fire") then --火攻击力
		--
	elseif (attrType == "atk_poison") then --毒攻击力
		--
	elseif (attrType == "atk_bullet") then --子弹攻击力
		--
	elseif (attrType == "atk_bomb") then --爆炸攻击力
		--
	elseif (attrType == "atk_chuanci") then --穿刺攻击力
		--
	elseif (attrType == "def_ice") then --冰防御
		--
	elseif (attrType == "def_thunder") then --雷防御
		--
	elseif (attrType == "def_fire") then --火防御
		--
	elseif (attrType == "def_poison") then --毒防御
		--
	elseif (attrType == "def_bullet") then --子弹防御
		--
	elseif (attrType == "def_bomb") then --爆炸防御
		--
	elseif (attrType == "def_chuanci") then --穿刺防御
		--
	elseif (attrType == "bullet_capacity") then --携弹数量
		--
	elseif (attrType == "grenade_capacity") then --手雷数量
		--
	elseif (attrType == "grenade_child") then --子母雷数量
		--
	elseif (attrType == "grenade_fire") then --手雷爆炸火焰
		--
	elseif (attrType == "grenade_dis") then --手雷投弹距离
		--
	elseif (attrType == "grenade_cd") then --手雷冷却时间（单位：毫秒）
		--
	elseif (attrType == "grenade_crit") then --手雷暴击
		--
	elseif (attrType == "grenade_multiply") then --手雷冷却前使用次数
		--大菠萝，设置技能使用次数
		if (target.data.bind_weapon ~= 0) then
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
			if btn2 then
				local grenade_multiply = target:GetGrenadeMultiply() + value_final
				--手雷使用次数上限
				if (grenade_multiply > hVar.ROLE_GRENADE_MULTIPLY_MAX) then
					grenade_multiply = hVar.ROLE_GRENADE_MULTIPLY_MAX
				end
				if (grenade_multiply > 1) then
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false) --改为都不显示次数了
					btn2.childUI["labSkillUseCount"]:setText(grenade_multiply)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
				else
					btn2.data.useCountMax = grenade_multiply
					btn2.data.useCount = grenade_multiply
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
				end
			end
		end
	elseif (attrType == "inertia") then --惯性
		--
	elseif (attrType == "crystal_rate") then --水晶收益率（去百分号后的值）
		--
	elseif (attrType == "melee_bounce") then --近战弹开
		--
	elseif (attrType == "melee_fight") then --近战反击
		--
	elseif (attrType == "melee_stone") then --近战碎石
		--
	end
	
	--属性增加
	target.attr[toParamVar] = target.attr[toParamVar] + value_final
	
	--print("    toParamVar=", tostring(toParamVar) .. ", value_final=" .. tostring(value_final) .. ", aura_sum=" .. tostring(target.attr[toParamVar]))
	
	return self:doNextAction()
end

--geyachao: 计算两点之间的距离
__aCodeList["CalTowPointDistance"] = function(self, _, param, x1, y1, x2, y2)
	local d = self.data
	
	if (type(x1) == "string") then
		x1 = d.tempValue[x1]
	end
	
	if (type(y1) == "string") then
		y1 = d.tempValue[y1]
	end
	
	if (type(x2) == "string") then
		x2 = d.tempValue[x2]
	end
	
	if (type(y2) == "string") then
		y2 = d.tempValue[y2]
	end
	
	local dx = x2 - x1
	local dy = y2 - y1
	local distance = math.sqrt(dx * dx + dy * dy) --距离
	distance = hApi.floor(distance) --向下取整
	
	d.tempValue[param] = distance
	
	return self:doNextAction()
end

__aCodeList["SetMissileConvert"] = function(self,_,mode,skillId,effectId,effectConvertId,flySpeed,flyAngle,rollSpeed)
	local d = self.data
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local u = d.target
	if mode=="unit" then
		u = d.unit
	end
	if u~=0 and effectId and effectId>0 and effectConvertId>0 then
		if u.handle.__tEffectConvert==nil then
			u.handle.__tEffectConvert = {}
		end
		u.handle.__tEffectConvert[#u.handle.__tEffectConvert+1] = {skillId,effectId,effectConvertId,flySpeed,flyAngle,rollSpeed}
	end
	return self:doNextAction()
end

--发射箭矢
__aCodeList["MissileToTarget"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	if t==0 or t.ID==0 or t.data.IsDead==1 then
		return "release",1
	end
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if w then
		local oUnitShootFrom = u
		local nShootUnitID = d.tempValue["@shootFrom"]
		if nShootUnitID~=0 and type(nShootUnitID)=="number" then
			oUnitShootFrom = hClass.unit:find(nShootUnitID)
			if not(oUnitShootFrom and oUnitShootFrom:getworld()==w) then
				return "release",1
			end
		end
		local tabU = hVar.tab_unit[u.data.id] or hVar.tab_unit[1]
		local tabS = hVar.tab_skill[d.skillId] or hVar.tab_skill[1]
		local tabS_C = hVar.tab_skill[d.castId] or hVar.tab_skill[1]
		if tabS.IsShoot==1 then
			if tabU.shoot then
				local v = tabU.shoot
				if v[1]~=0 then
					effectId = v[1]
				end
				flySpeed = v[2] or flySpeed
				flyAngle = v[3] or flyAngle
				shootX = v[4] or shootX
				shootY = v[5] or shootY
			end
			shootX = (shootX or 0) + (tabS_C.shootX or 0)
			shootY = (shootY or 24) + (tabS_C.shootY or 0)
		else
			shootX = shootX or 0
			shootY = shootY or 24
		end
		local worldX,worldY = w:grid2xy(t.data.gridX,t.data.gridY)
		worldX = worldX+t.data.standX
		worldY = worldY+t.data.standY-10
		local HitZ = 0 --解决船怪高点被射击(修复了ccc的bug)
		local tabU_T = hVar.tab_unit[t.data.id]
		if tabU_T and tabU_T.HitZ then
			HitZ = tabU_T.HitZ
		end
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,t,targetX,"number")
		targetY = __AnalyzeValueExpr(self,t,targetY,"number")
		--print("t=" .. tostring(t))
		if tabU.position~=nil then
			--城防类的单位弹道不会旋转
		else
			--这种特效会随着单位角度翻转
			if effectId>=0 then
				--print(u.data.name, u.data.facing)
				--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
				local angle = u.data.facing --角色面向的角度
				
				if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				if (tostring(angle) == "nan") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				
				--local tabU = hVar.tab_unit[u.data.id]
				local bullet = u.attr.bullet
				
				--if tabU and tabU.bullet then
				if bullet and (bullet ~= 0) then
					local NNN = bullet.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					
					local dx = bullet[szPartAngle].offsetX
					local dy = bullet[szPartAngle].offsetY
					
					shootX = dx
					shootY = dy
					--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
				else
					--[[
					local fangle = angle * math.pi / 180 --弧度制
					local dx = shootX * math.cos(fangle) --随机偏移值x
					local dy = shootX * math.sin(fangle) --随机偏移值y
				
					shootX = shootX + dx
					shootY = shootY - dy
					]]
					if u.data.facing>90 and u.data.facing<=270 then
						shootX = -1*shootX
					end
				end
				
				if t.data.facing>90 and t.data.facing<=270 then
					targetX = -1*targetX
				end
			else
				effectId = math.abs(effectId)
			end
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		local tConvert = u.handle.__tEffectConvert
		if type(tConvert)=="table" then
			for i = 1,#tConvert do
				local v = tConvert[i]
				if (v[1]==0 or v[1]==d.skillId) and v[2]==eid and type(v[3])=="number" then
					eid = v[3]
					flySpeed = v[4] or flySpeed
					flyAngle = v[5] or flyAngle
					rollSpeed = v[6] or rollSpeed
				end
			end
		end
		--print("param", eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, t)
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, nil, nil, nil, nil)
		if e then
			if (flyPercent or 1)==1 then
				--该特效拥有死亡动画
				local tabE = hVar.tab_model[e.handle.modelIndex]
				if tabE and tabE.dead then
					e.data.deadAnimation = "dead"
				end
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    7")
			return "sleep",e.data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--发射追踪类箭矢
--geyachao: 添加追踪类飞行特效（直线型）
__aCodeList["MissileToTarget_FollowLine"] = function(self, _, effectId, flySpeed, flyAngle, shootX,shootY,targetX,targetY,rollSpeed,flyPercent)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 目标不存在了，直接结束技能释放整个流程
	if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if w then
		local oUnitShootFrom = u
		local nShootUnitID = d.tempValue["@shootFrom"]
		if nShootUnitID~=0 and type(nShootUnitID)=="number" then
			oUnitShootFrom = hClass.unit:find(nShootUnitID)
			if not(oUnitShootFrom and oUnitShootFrom:getworld()==w) then
				return "release",1
			end
		end
		local tabU = hVar.tab_unit[u.data.id] or hVar.tab_unit[1]
		--local tabS = hVar.tab_skill[d.skillId] or hVar.tab_skill[1]
		local tabS_C = hVar.tab_skill[d.castId] or hVar.tab_skill[1]
		local worldX,worldY = w:grid2xy(t.data.gridX,t.data.gridY)
		worldX = worldX+t.data.standX
		worldY = worldY+t.data.standY-10
		local HitZ = 0 --解决船怪高点被射击(修复了ccc的bug)
		local tabU_T = hVar.tab_unit[t.data.id]
		if tabU_T and tabU_T.HitZ then
			HitZ = tabU_T.HitZ
		end
		
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,t,targetX,"number")
		targetY = __AnalyzeValueExpr(self,t,targetY,"number")
		
		--飞行速度支持字符串
		if (type(flySpeed) == "string") then
			flySpeed = d.tempValue[flySpeed]
		end
		
		--飞行速度支持变速的表结构
		--flySpeed = {{flySpeed = 500, flyTime = 1000,}, {flySpeed = 600, flyTime = 1000,}, {flySpeed = 700, flyTime = 1000,}, ...}
		local flySpeedV = flySpeed
		if (type(flySpeed) == "table") then
			--复制一份出来
			flySpeedV = {}
			for i = 1, #flySpeedV, 1 do
				local flySpeed_i = flySpeed[i].flySpeed
				local flyTime_i = flySpeed[i].flyTime
				
				if (type(flySpeed_i) == "string") then
					flySpeed_i = d.tempValue[flySpeed_i]
				end
				
				if (type(flyTime_i) == "string") then
					flyTime_i = d.tempValue[flyTime_i]
				end
				
				flySpeedV[i] = {flySpeed = flySpeed_i, flyTime = flyTime_i,}
			end
			
			flySpeed = flySpeed[1].flySpeed
		end
		
		--print("t=" .. tostring(t))
		if tabU.position~=nil then
			--城防类的单位弹道不会旋转
		else
			--这种特效会随着单位角度翻转
			if effectId>=0 then
				--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
				local angle = u.data.facing --角色面向的角度
				
				if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				if (tostring(angle) == "nan") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				
				--local tabU = hVar.tab_unit[u.data.id]
				local bullet = u.attr.bullet
				local bulletEffect = u.attr.bulletEffect
				
				--if tabU and tabU.bullet then
				if bullet and (bullet ~= 0) then
					local NNN = bullet.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					
					local dx = bullet[szPartAngle].offsetX
					local dy = bullet[szPartAngle].offsetY
					
					shootX = shootX + dx
					shootY = shootY + dy
				--elseif tabU and tabU.bulletEffect and tabU.bulletEffect[szPartAngle] then
				elseif bulletEffect and (bulletEffect ~= 0) then
					local dx = bulletEffect[szPartAngle].offsetX
					local dy = bulletEffect[szPartAngle].offsetY
					
					shootX = shootX + dx
					shootY = shootY + dy
					--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
				else
					--[[
					local fangle = angle * math.pi / 180 --弧度制
					local dx = shootX * math.cos(fangle) --随机偏移值x
					local dy = shootX * math.sin(fangle) --随机偏移值y
				
					shootX = shootX + dx
					shootY = shootY - dy
					]]
					if u.data.facing>90 and u.data.facing<=270 then
						shootX = -1*shootX
					end
				end
				
				if t.data.facing>90 and t.data.facing<=270 then
					targetX = -1*targetX
				end
			else
				effectId = math.abs(effectId)
			end
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		local tConvert = u.handle.__tEffectConvert
		if type(tConvert)=="table" then
			for i = 1,#tConvert do
				local v = tConvert[i]
				if (v[1]==0 or v[1]==d.skillId) and v[2]==eid and type(v[3])=="number" then
					eid = v[3]
					flySpeed = v[4] or flySpeed
					flyAngle = v[5] or flyAngle
					rollSpeed = v[6] or rollSpeed
				end
			end
		end
		
		--print("param", eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, t)
		local lineParam = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, w:gametime(), flySpeedV} --碰撞相关的参数
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, nil, nil, nil, t, self, "line", 0, lineParam) --geyachao: 添加参数: 目标, action, szType, collision, param
		if e then
			if (flyPercent or 1)==1 then
				--该特效拥有死亡动画
				local tabE = hVar.tab_model[e.handle.modelIndex]
				if tabE and tabE.dead then
					e.data.deadAnimation = "dead"
				end
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
			
			--存储飞行特效集
			d.FLYEFFECTS = {e,}
		end
		if e and (e.data.playtime > 0) then
			--print("return sleep,tick    8")
			return "sleep", e.data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--发射追踪类箭矢
--geyachao: 添加追踪类飞行特效（抛物线型）
__aCodeList["MissileToTarget_FollowParabola"] = function(self, _, effectId, flySpeed, flyAngle, shootX,shootY,targetX,targetY,rollSpeed,flyPercent)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 目标不存在了，直接结束技能释放整个流程
	if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if w then
		local oUnitShootFrom = u
		local nShootUnitID = d.tempValue["@shootFrom"]
		if nShootUnitID~=0 and type(nShootUnitID)=="number" then
			oUnitShootFrom = hClass.unit:find(nShootUnitID)
			if not(oUnitShootFrom and oUnitShootFrom:getworld()==w) then
				return "release",1
			end
		end
		local tabU = hVar.tab_unit[u.data.id] or hVar.tab_unit[1]
		--local tabS = hVar.tab_skill[d.skillId] or hVar.tab_skill[1]
		local tabS_C = hVar.tab_skill[d.castId] or hVar.tab_skill[1]
		local worldX,worldY = w:grid2xy(t.data.gridX,t.data.gridY)
		worldX = worldX+t.data.standX
		worldY = worldY+t.data.standY-10
		local HitZ = 0 --解决船怪高点被射击(修复了ccc的bug)
		local tabU_T = hVar.tab_unit[t.data.id]
		if tabU_T and tabU_T.HitZ then
			HitZ = tabU_T.HitZ
		end
		
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,t,targetX,"number")
		targetY = __AnalyzeValueExpr(self,t,targetY,"number")
		
		--print("t=" .. tostring(t))
		if tabU.position~=nil then
			--城防类的单位弹道不会旋转
		else
			--这种特效会随着单位角度翻转
			if effectId>=0 then
				--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
				local angle = u.data.facing --角色面向的角度
				
				if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				if (tostring(angle) == "nan") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				
				--local tabU = hVar.tab_unit[u.data.id]
				local bullet = u.attr.bullet
				local bulletEffect = u.attr.bulletEffect
				
				--if tabU and tabU.bullet then
				if bullet and (bullet ~= 0) then
					local NNN = bullet.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					
					local dx = bullet[szPartAngle].offsetX
					local dy = bullet[szPartAngle].offsetY
					
					shootX = shootX + dx
					shootY = shootY + dy
				--elseif tabU and tabU.bulletEffect and tabU.bulletEffect[szPartAngle] then
				elseif bulletEffect and (bulletEffect ~= 0) then
					local dx = bulletEffect[szPartAngle].offsetX
					local dy = bulletEffect[szPartAngle].offsetY
					
					shootX = shootX + dx
					shootY = shootY + dy
					--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
				else
					--[[
					local fangle = angle * math.pi / 180 --弧度制
					local dx = shootX * math.cos(fangle) --随机偏移值x
					local dy = shootX * math.sin(fangle) --随机偏移值y
				
					shootX = shootX + dx
					shootY = shootY - dy
					]]
					if u.data.facing>90 and u.data.facing<=270 then
						shootX = -1*shootX
					end
				end
				
				if t.data.facing>90 and t.data.facing<=270 then
					targetX = -1*targetX
				end
			else
				effectId = math.abs(effectId)
			end
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		local tConvert = u.handle.__tEffectConvert
		if type(tConvert)=="table" then
			for i = 1,#tConvert do
				local v = tConvert[i]
				if (v[1]==0 or v[1]==d.skillId) and v[2]==eid and type(v[3])=="number" then
					eid = v[3]
					flySpeed = v[4] or flySpeed
					flyAngle = v[5] or flyAngle
					rollSpeed = v[6] or rollSpeed
				end
			end
		end
		--print("param", eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, t)
		local lineParam = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, w:gametime(), flySpeedV} --碰撞相关的参数
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, nil, nil, nil, t, self, "parabola", 0, lineParam) --geyachao: 添加参数: 目标, action, type
		if e then
			if (flyPercent or 1)==1 then
				--该特效拥有死亡动画
				local tabE = hVar.tab_model[e.handle.modelIndex]
				if tabE and tabE.dead then
					e.data.deadAnimation = "dead"
				end
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
			
			--存储飞行特效集
			d.FLYEFFECTS = {e,}
		end
		if e and (e.data.playtime > 0) then
			--print("return sleep,tick    9")
			return "sleep",e.data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--发射追踪类箭矢
--geyachao: 添加追踪类飞行特效（追踪导弹型）
--没有目标也能发射
__aCodeList["MissileToTarget_FollowTracing"] = function(self, _, effectId, flySpeed, flyAngle, shootX,shootY,targetX,targetY,rollSpeed,flyPercent,livetime,flyeffectId,nIsHideTail,boomeffectId)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--飞行特效生存时间
	if (type(livetime) == "string") then
		--livetime = d.tempValue[livetime]
		livetime = __AnalyzeValueExpr(self, u, livetime, "number")
	end
	
	--飞行特效生存时间默认值
	if (livetime == nil) then
		livetime = -1
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	--修改目标，为上帝（后续会改为敌人）
	t = u:getowner():getgod()
	
	--上帝不存在，恢复目标
	if (t == nil) then
		t = d.target
	end
	
	--防止弹框
	if (t == nil) then
		return "release", 1
	end
	
	d.target = t
	d.target_worldC = t:getworldC()
	
	--geyachao: 目标不存在了，直接结束技能释放整个流程
	if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if w then
		local oUnitShootFrom = u
		local nShootUnitID = d.tempValue["@shootFrom"]
		if nShootUnitID~=0 and type(nShootUnitID)=="number" then
			oUnitShootFrom = hClass.unit:find(nShootUnitID)
			if not(oUnitShootFrom and oUnitShootFrom:getworld()==w) then
				return "release",1
			end
		end
		local tabU = hVar.tab_unit[u.data.id] or hVar.tab_unit[1]
		--local tabS = hVar.tab_skill[d.skillId] or hVar.tab_skill[1]
		local tabS_C = hVar.tab_skill[d.castId] or hVar.tab_skill[1]
		local worldX,worldY = w:grid2xy(t.data.gridX,t.data.gridY)
		worldX = worldX+t.data.standX
		worldY = worldY+t.data.standY-10
		local HitZ = 0 --解决船怪高点被射击(修复了ccc的bug)
		local tabU_T = hVar.tab_unit[t.data.id]
		if tabU_T and tabU_T.HitZ then
			HitZ = tabU_T.HitZ
		end
		
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,t,targetX,"number")
		targetY = __AnalyzeValueExpr(self,t,targetY,"number")
		
		flyeffectId = __AnalyzeValueExpr(self,t,flyeffectId,"number")
		if (flyeffectId == nil) or (flyeffectId == 0) then
			flyeffectId = effectId - 1
		end
		
		boomeffectId = __AnalyzeValueExpr(self,t,boomeffectId,"number")
		if (boomeffectId == nil) or (boomeffectId == 0) then
			boomeffectId = 3097
		end
		
		--print("flyeffectId=", flyeffectId)
		--print("boomeffectId=", boomeffectId)
		
		--print("t=" .. tostring(t))
		if tabU.position~=nil then
			--城防类的单位弹道不会旋转
		else
			--这种特效会随着单位角度翻转
			if effectId>=0 then
				--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
				local angle = u.data.facing --角色面向的角度
				
				if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				if (tostring(angle) == "nan") then --防止一些异常值进来
					angle = 0
					u.data.angle = 0
				end
				
				if (angle < 0) then
					angle = 0
				end
				if (angle > 360) then
					angle = 360
				end
				
				--local tabU = hVar.tab_unit[u.data.id]
				local bullet = u.attr.bullet
				local bulletEffect = u.attr.bulletEffect
				
				--if tabU and tabU.bullet then
				if bullet and (bullet ~= 0) then
					local NNN = bullet.num
					local a1 = 360 / 2 / NNN
					local a2 = a1 * 2
					local degree = math.floor((angle + a1) / a2)
					if (degree == NNN) then
						degree = 0
					end
					local partAngle = degree * a2
					local szPartAngle = tostring(partAngle)
					
					--print("angle=", angle, "NNN=", NNN, "u.data.id=", u.data.id, "szPartAngle=", szPartAngle)
					--[[
					local dx = bullet[szPartAngle].offsetX
					local dy = bullet[szPartAngle].offsetY
					]]
					local dx = 0
					local dy = 0
					
					shootX = shootX + dx
					shootY = shootY + dy
				--elseif tabU and tabU.bulletEffect and tabU.bulletEffect[szPartAngle] then
				elseif bulletEffect and (bulletEffect ~= 0) then
					--[[
					local dx = bulletEffect[szPartAngle].offsetX
					local dy = bulletEffect[szPartAngle].offsetY
					]]
					local dx = 0
					local dy = 0
					
					shootX = shootX + dx
					shootY = shootY + dy
					--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
				else
					--[[
					local fangle = angle * math.pi / 180 --弧度制
					local dx = shootX * math.cos(fangle) --随机偏移值x
					local dy = shootX * math.sin(fangle) --随机偏移值y
				
					shootX = shootX + dx
					shootY = shootY - dy
					]]
					if u.data.facing>90 and u.data.facing<=270 then
						shootX = -1*shootX
					end
				end
				
				if t.data.facing>90 and t.data.facing<=270 then
					targetX = -1*targetX
				end
			else
				effectId = math.abs(effectId)
			end
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		local tConvert = u.handle.__tEffectConvert
		if type(tConvert)=="table" then
			for i = 1,#tConvert do
				local v = tConvert[i]
				if (v[1]==0 or v[1]==d.skillId) and v[2]==eid and type(v[3])=="number" then
					eid = v[3]
					flySpeed = v[4] or flySpeed
					flyAngle = v[5] or flyAngle
					rollSpeed = v[6] or rollSpeed
				end
			end
		end
		--print("param", eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, t)
		--{isRotEff, targetType, dmg, dmgMode, castskillId, castskillLv, angle, fly_begin_x, fly_begin_y, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, flyTime, flyBeginTime, flySpeedV, blockWallSound, daodanFlyEffectId, daodanIsHideTail, daodanBoomEffectId, nFlyUnitOnly,}
		local lineParam = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, livetime, w:gametime(), flySpeedV, nil, flyeffectId, nIsHideTail, boomeffectId, nil,} --碰撞相关的参数
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,oUnitShootFrom,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent,HitZ},worldX+targetX,worldY+targetY, nil, nil, nil, t, self, "tracing", 0, lineParam) --geyachao: 添加参数: 目标, action, type
		if e then
			if (flyPercent or 1)==1 then
				--该特效拥有死亡动画
				local tabE = hVar.tab_model[e.handle.modelIndex]
				if tabE and tabE.dead then
					e.data.deadAnimation = "dead"
				end
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
			
			--存储飞行特效集
			d.FLYEFFECTS = {e,}
		end
		if e and (e.data.playtime > 0) then
			--print("return sleep,tick    10")
			return "sleep",e.data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--角色朝着目标(点)方向，发射碰撞特效，飞行指定的时间后消失，对碰到的有效单位造成伤害，并对其释放技能(如果角色还活着)
--（也触发碰撞回调，可在 OnFlyeff_Collision_Unit_Event 函数里面特殊处理）
--geyachao: 添加碰撞特效飞行特效
__aCodeList["MissileToTarget_Collision"] = function(self, _, effectId, effNum, originAngle, angleEach, flySpeed, flyTime, isRotEff, rollSpeed, targetType, dmg, dmgMode, castskillId, castskillLv, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, blockWallSound, nFlyUnitOnly)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("MissileToTarget_Collision", eu_x, eu_y, d.worldX, d.worldY)
	
	--避免没传 targetType
	targetType = targetType or "ALL"
	
	--避免没传 dmg
	dmg = dmg or 0
	
	--避免没传 dmgMode
	dmgMode = dmgMode or 0
	
	--避免没传 castskillId
	castskillId = castskillId or 0
	
	--避免没传 castskillLv
	castskillLv = castskillLv or 0
	
	--避免没传 tansheWallCount
	tansheWallCount = tansheWallCount or 0
	
	--飞行特效数量支持字符串
	if (type(effNum) == "string") then
		effNum = d.tempValue[effNum]
	end
	
	--飞行起始偏移角度支持字符串
	if (type(originAngle) == "string") then
		originAngle = d.tempValue[originAngle]
	end
	
	--飞行夹角支持字符串
	if (type(angleEach) == "string") then
		angleEach = d.tempValue[angleEach]
	end
	
	--飞行速度支持字符串
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	--飞行速度支持变速的表结构
	--flySpeed = {{flySpeed = 500, flyTime = 1000,}, {flySpeed = 600, flyTime = 1000,}, {flySpeed = 700, flyTime = 1000,}, ...}
	local flySpeedV = flySpeed
	if (type(flySpeed) == "table") then
		--复制一份出来
		flySpeedV = {}
		for i = 1, #flySpeedV, 1 do
			local flySpeed_i = flySpeed[i].flySpeed
			local flyTime_i = flySpeed[i].flyTime
			
			if (type(flySpeed_i) == "string") then
				flySpeed_i = d.tempValue[flySpeed_i]
			end
			
			if (type(flyTime_i) == "string") then
				flyTime_i = d.tempValue[flyTime_i]
			end
			
			flySpeedV[i] = {flySpeed = flySpeed_i, flyTime = flyTime_i,}
		end
		
		flySpeed = flySpeed[1].flySpeed
	end
	
	--读取地图的难度模式，是否需要给敌人增加飞行速度
	local world = self.data.world
	if world then
		local mapInfo = world.data.tdMapInfo
		if mapInfo then
			local diff = mapInfo.mapDifficulty
			if (diff > 0) then --难度模式
				local speedRate = hVar.ROLE_FLYSEPPD_DIFF_ADDRATE * diff
				
				--施法者是敌人才加飞行速度
				local nCasterForce = u:getowner():getforce()
				if (nCasterForce ~= world:GetPlayerMe():getforce()) then
					--
				end
			end
		end
	end
	
	--飞行时间支持字符串
	if (type(flyTime) == "string") then
		flyTime = d.tempValue[flyTime]
	end
	
	--旋转速率支持字符串
	if (type(rollSpeed) == "string") then
		rollSpeed = d.tempValue[rollSpeed]
	end
	
	--伤害值支持字符串
	if (type(dmg) == "string") then
		dmg = d.tempValue[dmg]
	end
	
	--技能等级支持字符串
	if (type(castskillLv) == "string") then
		castskillLv = d.tempValue[castskillLv]
	end
	
	--撞墙弹射次数
	if (type(tansheWallCount) == "string") then
		--tansheWallCount = d.tempValue[tansheWallCount]
		tansheWallCount = __AnalyzeValueExpr(self, u, tansheWallCount, "number")
	end
	
	--如果特效数量为0，直接结束流程
	if (effNum <= 0) then
		return self:doNextAction()
	end
	
	--如果特效速度过慢，直接结束流程
	if (flySpeed < 1) then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return self:doNextAction()
	end
	
	--[[
	--geyachao: 目标不存在了，直接结束技能释放整个流程
	if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
		return self:doNextAction()
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return self:doNextAction()
	end
	]]
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if w then
		local skillId = self.data.skillId --本技能id
		local skillType = hVar.tab_skill[skillId].cast_type --技能释放类型
		
		local shootX = 0 --发射起始的偏移x
		local shootY = 0 --发射起始的偏移y
		
		--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
		local angle = u.data.facing --角色面向的角度
		if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		if (tostring(angle) == "nan") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		
		--local tabU = hVar.tab_unit[u.data.id]
		local bulletEffect = u.attr.bulletEffect
		local bullet = u.attr.bullet
		
		--if tabU and tabU.bulletEffect then
		if bulletEffect and (bulletEffect ~= 0) then
			local NNN = bulletEffect.num
			local a1 = 360 / 2 / NNN
			local a2 = a1 * 2
			local degree = math.floor((angle + a1) / a2)
			if (degree == NNN) then
				degree = 0
			end
			local partAngle = degree * a2
			local szPartAngle = tostring(partAngle)
			
			local dx = bulletEffect[szPartAngle].offsetX
			local dy = bulletEffect[szPartAngle].offsetY
			
			shootX = shootX + dx
			shootY = shootY + dy
			--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
		--elseif tabU and tabU.bullet then
		elseif bullet and (bullet ~= 0) then
			local NNN = bullet.num
			local a1 = 360 / 2 / NNN
			local a2 = a1 * 2
			local degree = math.floor((angle + a1) / a2)
			if (degree == NNN) then
				degree = 0
			end
			local partAngle = degree * a2
			local szPartAngle = tostring(partAngle)
			
			local dx = bullet[szPartAngle].offsetX
			local dy = bullet[szPartAngle].offsetY
			
			shootX = shootX + dx
			shootY = shootY + dy
			--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
		end
		
		--角色的中心点坐标
		local unit_x, unit_y = hApi.chaGetPos(u.handle) --角色的坐标
		--local unit_bx, unit_by, unit_bw, unit_bh = u:getbox() --角色的包围盒
		--local unit_center_x = unit_x + (unit_bx + unit_bw / 2) --角色的中心点x位置
		--local unit_center_y = unit_y + (unit_by + unit_bh / 2) --角色的中心点y位置
		local unit_center_x = unit_x --角色的中心点x位置(还是决定取脚底板坐标)
		local unit_center_y = unit_y --角色的中心点y位置(还是决定取脚底板坐标)
		
		--取角色到目标点连线角度
		local angle = 0 --角度制
		--print(skillType)
		if (skillType == hVar.CAST_TYPE.SKILL_TO_UNIT) then --对目标施法
			--geyachao: 目标不存在了，直接结束技能释放整个流程
			if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
				return self:doNextAction()
			end
			
			--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
			if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
				return self:doNextAction()
			end
			
			--目标的中心点坐标
			local target_x, target_y = hApi.chaGetPos(t.handle) --目标的坐标
			local target_bx, target_by, target_bw, target_bh = t:getbox() --目标的包围盒
			local target_center_x = target_x + (target_bx + target_bw / 2) --目标的中心点x位置
			local target_center_y = target_y + (target_by + target_bh / 2) --目标的中心点y位置
			--local target_center_x = target_x --目标的中心点x位置(还是决定取脚底板坐标)
			--local target_center_y = target_y --目标的中心点y位置(还是决定取脚底板坐标)
			--print("对目标施法", shootX, shootY)
			
			angle = GetLineAngle(unit_center_x + shootX, unit_center_y - shootY, target_center_x, target_center_y) --角度制
			--print("angle=" .. angle, "target_center_x=" .. target_center_x, "target_center_y=" ..  target_center_y)
		elseif (skillType == hVar.CAST_TYPE.IMMEDIATE) or (skillType == hVar.CAST_TYPE.AUTO) then --立即释放
			--取施法者的当前面向
			angle = u.data.facing
		else --对目标点施法
			local to_x = d.worldX --目标点x位置
			local to_y = d.worldY --目标点y位置
			
			angle = GetLineAngle(unit_center_x, unit_center_y, to_x, to_y) --角度制
		end
		
		--飞行总路程
		local distance = flySpeed * flyTime / 1000 --单位: 毫秒
		--飞行速度支持变速的表结构，重新计算飞行总路程
		if (type(flySpeedV) == "table") then
			distance = 0
			local timeLeft = flyTime --剩余时间
			
			for i = 1, #flySpeedV, 1 do
				local flySpeed = flySpeedV[i].flySpeed
				local flyTime = flySpeedV[i].flyTime
				
				if (timeLeft >= flyTime) then --剩余时间足够跑完这段区间
					distance = distance + flySpeed * flyTime / 1000 --单位: 毫秒
					timeLeft = timeLeft - flyTime
				else --只能在这段区间跑部分距离
					distance = distance + flySpeed * timeLeft / 1000 --单位: 毫秒
					timeLeft = 0
					
					break
				end
			end
			
			--如果全部都跑完，还有剩余时间，那么按最后一段的速度跑剩下的路程
			if (timeLeft > 0) then
				local flySpeed = flySpeedV[#flySpeedV].flySpeed
				distance = distance + flySpeed * timeLeft / 1000 --单位: 毫秒
				timeLeft = 0
			end
		end
		
		local ANGLES = {} --所有的角度列表
		if (effNum % 2 == 1) then --奇数
			table.insert(ANGLES, angle + originAngle) --0度角的
			
			for i = 1, (effNum - 1) / 2, 1 do
				table.insert(ANGLES, angle + i * angleEach + originAngle) --正向角度的
				table.insert(ANGLES, angle - i * angleEach + originAngle) --负向角度的
			end
		else --偶数
			for i = 1, effNum / 2, 1 do
				table.insert(ANGLES, angle + angleEach / 2 + (i - 1) * angleEach + originAngle) --正向角度的
				table.insert(ANGLES, angle - angleEach / 2 - (i - 1) * angleEach + originAngle) --负向角度的
			end
		end
		
		--依次创建飞行特效
		local EFFECTS = {}
		for i = 1, #ANGLES, 1 do
			--计算总飞行距离
			local anglei = ANGLES[i]
			local fanglei = anglei * math.pi / 180 --弧度制
			local tdxi = distance * math.cos(fanglei) --本地移动的x距离
			local tdyi = distance * math.sin(fanglei) --本地移动的y距离
			--print("tdxi=", tdxi, "tdyi=", tdyi)
			
			--计算终点的坐标
			local end_xi = unit_center_x + shootX + tdxi
			local end_yi = unit_center_y - shootY + tdyi
			
			--创建碰撞类飞行特效
			local eid = effectId
			local oUnitShootFrom = u
			
			local flyAngle = -1 --默认不旋转特效
			if (isRotEff == true) or (isRotEff == 1) then
				isRotEff = 1
				flyAngle = 0
			end
			--local rollSpeed = 0
			local flyPercent = 100
			local HitZ = nil
			local tansheWallCountNow = 0
			--{isRotEff, targetType, dmg, dmgMode, castskillId, castskillLv, angle, fly_begin_x, fly_begin_y, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, flyTime, flyBeginTime, flySpeedV, blockWallSound, daodanFlyEffectId, daodanIsHideTail, daodanBoomEffectId, nFlyUnitOnly,}
			local collParam = {isRotEff, targetType, dmg, dmgMode, castskillId, castskillLv, anglei, unit_center_x + 0, unit_center_y + 0, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, flyTime, w:gametime(), flySpeedV, blockWallSound, nil, nil, nil, nFlyUnitOnly,} --碰撞相关的参数
			local effParam = {hVar.EFFECT_TYPE.MISSILE, oUnitShootFrom, shootX, shootY, flyAngle, flySpeed, rollSpeed, flyPercent, HitZ}
			--if (d.skillId == 14017) then
			--print("MissileToTarget_Collision")
			--end
			local e = w:addeffect(eid, 0, effParam, end_xi, end_yi, nil, nil, nil, nil, self, "line", 1, collParam) --geyachao: 添加参数: 目标, action, szType, collision, collParam
			table.insert(EFFECTS, e)
		end
		
		--存储飞行特效集
		d.FLYEFFECTS = EFFECTS
		
		if EFFECTS[0] and (EFFECTS[0].data.playtime > 0) then
			--print("return sleep,tick    8")
			return "sleep", EFFECTS[0].data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--从指定起始位置发出，沿着指定角度发射碰撞特效，飞行指定的时间后消失，对碰到的有效单位造成伤害，并对其释放技能(如果角色还活着)
--（也触发碰撞回调，可在 OnFlyeff_Collision_Unit_Event 函数里面特殊处理）
--geyachao: 添加碰撞特效飞行特效
__aCodeList["MissilePointToAngle_Collision"] = function(self, _, fromX, fromY, fromAngle, effectId, effNum, angleEach, flySpeed, flyTime, isRotEff, rollSpeed, targetType, dmg, dmgMode, castskillId, castskillLv, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, blockWallSound, nFlyUnitOnly)
	--print(fromX, fromY, fromAngle, effectId, effNum, angleEach, flySpeed, flyTime, isRotEff, rollSpeed, targetType, dmg, dmgMode, castskillId, castskillLv, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, blockWallSound, nFlyUnitOnly)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--避免没传 fromAngle
	fromAngle = fromAngle or 0
	
	--避免没传 targetType
	targetType = targetType or "ALL"
	
	--避免没传 dmg
	dmg = dmg or 0
	
	--避免没传 dmgMode
	dmgMode = dmgMode or 0
	
	--避免没传 castskillId
	castskillId = castskillId or 0
	
	--避免没传 castskillLv
	castskillLv = castskillLv or 0
	
	--避免没传 tansheWallCount
	tansheWallCount = tansheWallCount or 0
	
	--飞行发出x坐标支持字符串
	if (type(fromX) == "string") then
		--fromX = d.tempValue[fromX]
		fromX = __AnalyzeValueExpr(self, u, fromX, "number")
	end
	
	--飞行发出y坐标支持字符串
	if (type(fromY) == "string") then
		--fromY = d.tempValue[fromY]
		fromY = __AnalyzeValueExpr(self, u, fromY, "number")
	end
	
	--撞墙弹射次数
	if (type(tansheWallCount) == "string") then
		--tansheWallCount = d.tempValue[tansheWallCount]
		tansheWallCount = __AnalyzeValueExpr(self, u, tansheWallCount, "number")
	end
	
	if (fromX == 0) then
		fromX = d.worldX
	end
	if (fromY == 0) then
		fromY = d.worldY
	end
	
	--飞行起始角度支持字符串
	if (type(fromAngle) == "string") then
		--fromAngle = d.tempValue[fromAngle]
		fromAngle = __AnalyzeValueExpr(self, u, fromAngle, "number")
	end
	
	--飞行特效数量支持字符串
	if (type(effNum) == "string") then
		--effNum = d.tempValue[effNum]
		effNum = __AnalyzeValueExpr(self, u, effNum, "number")
	end
	
	--飞行夹角支持字符串
	if (type(angleEach) == "string") then
		--angleEach = d.tempValue[angleEach]
		angleEach = __AnalyzeValueExpr(self, u, angleEach, "number")
	end
	
	--飞行速度支持字符串
	if (type(flySpeed) == "string") then
		--flySpeed = d.tempValue[flySpeed]
		flySpeed = __AnalyzeValueExpr(self, u, flySpeed, "number")
	end
	
	--飞行速度支持变速的表结构
	--flySpeed = {{flySpeed = 500, flyTime = 1000,}, {flySpeed = 600, flyTime = 1000,}, {flySpeed = 700, flyTime = 1000,}, ...}
	local flySpeedV = flySpeed
	if (type(flySpeed) == "table") then
		--复制一份出来
		flySpeedV = {}
		for i = 1, #flySpeed, 1 do
			local flySpeed_i = flySpeed[i].flySpeed
			local flyTime_i = flySpeed[i].flyTime
			
			if (type(flySpeed_i) == "string") then
				flySpeed_i = d.tempValue[flySpeed_i]
			end
			
			if (type(flyTime_i) == "string") then
				flyTime_i = d.tempValue[flyTime_i]
			end
			
			flySpeedV[i] = {flySpeed = flySpeed_i, flyTime = flyTime_i,}
		end
		
		flySpeed = flySpeed[1].flySpeed
	end
	
	--飞行时间支持字符串
	if (type(flyTime) == "string") then
		--flyTime = d.tempValue[flyTime]
		flyTime = __AnalyzeValueExpr(self, u, flyTime, "number")
	end
	
	--旋转速率支持字符串
	if (type(rollSpeed) == "string") then
		--rollSpeed = d.tempValue[rollSpeed]
		rollSpeed = __AnalyzeValueExpr(self, u, rollSpeed, "number")
	end
	
	--伤害值支持字符串
	if (type(dmg) == "string") then
		--dmg = d.tempValue[dmg]
		dmg = __AnalyzeValueExpr(self, u, dmg, "number")
	end
	
	--技能等级支持字符串
	if (type(castskillLv) == "string") then
		--castskillLv = d.tempValue[castskillLv]
		castskillLv = __AnalyzeValueExpr(self, u, castskillLv, "number")
	end
	
	--如果特效数量为0，直接结束流程
	if (effNum <= 0) then
		return self:doNextAction()
	end
	
	--如果特效速度过慢，直接结束流程
	if (flySpeed < 1) then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	--[[
	--geyachao: 目标不存在了，直接结束技能释放整个流程
	if (t == 0) or (t.ID == 0) or (t.data.IsDead == 1) then
		return "release", 1
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	]]
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if w then
		local skillId = self.data.skillId --本技能id
		local skillType = hVar.tab_skill[skillId].cast_type --技能释放类型
		
		--角色的中心点坐标
		local unit_x, unit_y = hApi.chaGetPos(u.handle) --角色的坐标
		local unit_bx, unit_by, unit_bw, unit_bh = u:getbox() --角色的包围盒
		local unit_center_x = unit_x + (unit_bx + unit_bw / 2) --角色的中心点x位置
		local unit_center_y = unit_y + (unit_by + unit_bh / 2) --角色的中心点y位置
		
		local shootX = fromX - unit_center_x --发射起始的偏移x
		local shootY = -(fromY - unit_center_y) --发射起始的偏移y
		
		--geyachao: 炮塔支持32方向的偏移值，所以这里优先读表的偏移值
		local angle = u.data.facing --角色面向的角度
		
		if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		if (tostring(angle) == "nan") then --防止一些异常值进来
			angle = 0
			u.data.angle = 0
		end
		
		--local tabU = hVar.tab_unit[u.data.id]
		local bulletEffect = u.attr.bulletEffect
		local bullet = u.attr.bullet
		
		--if tabU and tabU.bulletEffect then
		if bulletEffect and (bulletEffect ~= 0) then
			local NNN = bulletEffect.num
			local a1 = 360 / 2 / NNN
			local a2 = a1 * 2
			local degree = math.floor((angle + a1) / a2)
			if (degree == NNN) then
				degree = 0
			end
			local partAngle = degree * a2
			local szPartAngle = tostring(partAngle)
			
			local dx = bulletEffect[szPartAngle].offsetX
			local dy = bulletEffect[szPartAngle].offsetY
			
			shootX = shootX + dx
			shootY = shootY + dy
			--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
		--elseif tabU and tabU.bullet then
		elseif bullet and (bullet ~= 0) then
			local NNN = bullet.num
			local a1 = 360 / 2 / NNN
			local a2 = a1 * 2
			local degree = math.floor((angle + a1) / a2)
			if (degree == NNN) then
				degree = 0
			end
			local partAngle = degree * a2
			local szPartAngle = tostring(partAngle)
			
			local dx = bullet[szPartAngle].offsetX
			local dy = bullet[szPartAngle].offsetY
			
			shootX = shootX + dx
			shootY = shootY + dy
			--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
		end
		
		--发出的初始角度
		local angle = fromAngle --角度制
		
		--print("发出的初始角度=", angle)
		
		--飞行总路程
		local distance = flySpeed * flyTime / 1000 --单位: 毫秒
		--飞行速度支持变速的表结构，重新计算飞行总路程
		if (type(flySpeedV) == "table") then
			distance = 0
			local timeLeft = flyTime --剩余时间
			
			for i = 1, #flySpeedV, 1 do
				local flySpeed = flySpeedV[i].flySpeed
				local flyTime = flySpeedV[i].flyTime
				
				if (timeLeft >= flyTime) then --剩余时间足够跑完这段区间
					distance = distance + flySpeed * flyTime / 1000 --单位: 毫秒
					timeLeft = timeLeft - flyTime
				else --只能在这段区间跑部分距离
					distance = distance + flySpeed * timeLeft / 1000 --单位: 毫秒
					timeLeft = 0
					
					break
				end
			end
			
			--如果全部都跑完，还有剩余时间，那么按最后一段的速度跑剩下的路程
			if (timeLeft > 0) then
				local flySpeed = flySpeedV[#flySpeedV].flySpeed
				distance = distance + flySpeed * timeLeft / 1000 --单位: 毫秒
				timeLeft = 0
			end
		end
		--print("distance=", distance, "flyTime=", flyTime)
		
		local ANGLES = {} --所有的角度列表
		if (effNum % 2 == 1) then --奇数
			table.insert(ANGLES, angle) --0度角的
			
			for i = 1, (effNum - 1) / 2, 1 do
				table.insert(ANGLES, angle + i * angleEach) --正向角度的
				table.insert(ANGLES, angle - i * angleEach) --负向角度的
			end
		else --偶数
			for i = 1, effNum / 2, 1 do
				table.insert(ANGLES, angle + angleEach / 2 + (i - 1) * angleEach) --正向角度的
				table.insert(ANGLES, angle - angleEach / 2 - (i - 1) * angleEach) --负向角度的
			end
		end
		
		--依次创建飞行特效
		local EFFECTS = {}
		for i = 1, #ANGLES, 1 do
			--计算总飞行距离
			local anglei = ANGLES[i]
			local fanglei = anglei * math.pi / 180 --弧度制
			fanglei = math.floor(fanglei * 100) / 100  --保留2位有效数字，用于同步
			local tdxi = distance * math.cos(fanglei) --本地移动的x距离
			local tdyi = distance * math.sin(fanglei) --本地移动的y距离
			tdxi = math.floor(tdxi * 100) / 100  --保留2位有效数字，用于同步
			tdyi = math.floor(tdyi * 100) / 100  --保留2位有效数字，用于同步
			
			--计算终点的坐标
			local end_xi = fromX + tdxi-- + shootX
			local end_yi = fromY - tdyi-- - shootY
			
			--创建碰撞类飞行特效
			local eid = effectId
			local oUnitShootFrom = u
			
			local flyAngle = -1 --默认不旋转特效
			if (isRotEff == true) or (isRotEff == 1) then
				isRotEff = 1
				flyAngle = 0
			end
			--local rollSpeed = 0
			local flyPercent = 100
			local HitZ = nil
			local tansheWallCountNow = 0
			--{isRotEff, targetType, dmg, dmgMode, castskillId, castskillLv, angle, fly_begin_x, fly_begin_y, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, flyTime, flyBeginTime, flySpeedV, blockWallSound, daodanFlyEffectId, daodanIsHideTail, daodanBoomEffectId, nFlyUnitOnly,}
			local collParam = {isRotEff, targetType, dmg, dmgMode, castskillId, castskillLv, anglei, fromX, fromY, bBlockWallRemove, blockWallEffectId, bBlockUnitRemove, blockUnitEffectId, tansheWallCount, tansheWallCountNow, flyTime, w:gametime(), flySpeedV, blockWallSound, nil, nil, nil, nFlyUnitOnly,} --碰撞相关的参数
			local e = w:addeffect(eid, 0, {hVar.EFFECT_TYPE.MISSILE, oUnitShootFrom, shootX, shootY, flyAngle, flySpeed, rollSpeed, flyPercent, HitZ}, end_xi, end_yi, nil, nil, nil, nil, self, "line", 1, collParam) --geyachao: 添加参数: 目标, action, szType, collision, collParam
			table.insert(EFFECTS, e)
		end
		
		--存储飞行特效集
		d.FLYEFFECTS = EFFECTS
		
		if EFFECTS[0] and (EFFECTS[0].data.playtime > 0) then
			--print("return sleep,tick    8")
			return "sleep", EFFECTS[0].data.playtime
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--碰撞类飞行特效的拖尾效果
__aCodeList["MissileStreakEffect_Collision"] = function(self, _, effectId, red, green, blue, scale, faldeTime, pieceLength)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	local EFFECTS = d.FLYEFFECTS
	
	red = red or 255
	green = green or 255
	blue = blue or 255
	scale = scale or 1.0
	faldeTime = faldeTime or 1000 --单位：毫秒
	pieceLength = pieceLength or 10
	
	if EFFECTS and (EFFECTS ~= 0) then
		for i = 1, #EFFECTS, 1 do
			local oEffect = EFFECTS[i]
			if oEffect then
				local handleTable = oEffect.handle
				local sprite = handleTable._n
				
				--存在特效
				if sprite and (sprite ~= 0) then
					local modelKey = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].model
					--print(modelKey)
					if modelKey then
						local modelData,modelIndex = hApi.GetSafeModelByKey(modelKey)
						local md = hVar.tab_model[modelIndex]
						if md then
							local image = md.image
							local iamgePath = "data/image/" .. image 
							local eff_x, eff_y = sprite:getPosition() --特效的位置
							local width = 100
							local stand = md.animation[1]
							if stand then
								local w = md[stand][1] and md[stand][1][3]
								local h = md[stand][1] and md[stand][1][4]
								if w and h then
									local wh = math.min(w, h)
									width = wh * hVar.tab_effect[effectId].scale * scale
									--print("width", width)
								end
							end
							
							--第一个参数是间隐的时间，
							--第二个参数是间隐片断的大小，
							--第三个参数是贴图的宽高，
							--第四个参数是颜色值RGB，
							--第五个参数是贴图的路径或者贴图对象
							local streak = CCMotionStreak:create(faldeTime / 1000, pieceLength, width, ccc3(red, green, blue), iamgePath)
							streak:setPosition(ccp(eff_x, eff_y))
							sprite:getParent():addChild(streak, 10000)
							
							handleTable._pStreak = streak
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--箭雨 --geyachao: 新加功能
__aCodeList["JianYu"] = function(self, _, effectId, angle, speed, radius)
	return "sleep", math.huge
end

--PVP-将对方的粮仓或者基地设定为目标
__aCodeList["PVP_SetTargetToEndmyTown"] = function(self, _)
	local d = self.data
	local u = d.unit
	local world = u:getworld()
	--local t = d.target
	
	--读取施法者的势力
	local nCasterForce = u:getowner():getforce()
	
	--敌方势力
	local nEnemyForce = 3 - nCasterForce
	--print(nCasterForce)
	
	--找到敌方势力的粮仓或基地
	--蜀国主城: 11000
	--魏国主城: 11005
	--粮仓:11006
	local oLiangCang = nil
	local oZhuCheng = nil
	world:enumunit(function(eu)
		if (nEnemyForce == 1) then --找蜀国
			--蜀国粮仓
			if (eu.data.id == 11006) then
				if (eu:getowner():getforce() == nEnemyForce) then
					oLiangCang = eu
				end
			end
			
			--蜀国主城
			if (eu.data.id == 11000) then
				if (eu:getowner():getforce() == nEnemyForce) then
					oZhuCheng = eu
				end
			end
		elseif (nEnemyForce == 2) then --找魏国
			--魏国粮仓
			if (eu.data.id == 11006) then
				if (eu:getowner():getforce() == nEnemyForce) then
					oLiangCang = eu
				end
			end
			
			--魏国主城
			if (eu.data.id == 11005) then
				if (eu:getowner():getforce() == nEnemyForce) then
					oZhuCheng = eu
				end
			end
		end
	end)
	
	local oTarget = nil
	if oLiangCang then
		oTarget = oLiangCang
	elseif oZhuCheng then
		oTarget = oZhuCheng
	end
	
	--存在目标
	if oTarget then
		local worldX, worldY = hApi.chaGetPos(oTarget.handle) --目标的位置
		local gridX, gridY = world:xy2grid(worldX, worldY)
		
		d.worldX = worldX
		d.worldY = worldY
		d.gridX = gridX
		d.gridY = gridY
		
		d.target = oTarget
		d.target_worldC = oTarget:getworldC() --标记新的目标唯一id
		--print("PVP_SetTargetToEndmyTown", u.data.name, u.data.id, d.target.data.name, d.target.data.id)
	end
	
	return self:doNextAction()
end

--geyachao: 显示技能预施法圈
--PVP-将对方的粮仓或者基地设定为目标
__aCodeList["ShowSkillWarningCircle"] = function(self, _, range, redRate, greenRate, blueRate, nTime)
	local d = self.data
	local u = d.unit
	local t = d.target
	local skillId = d.skillId
	
	if (type(range) == "string") then
		range = d.tempValue[range]
	end
	
	--显示预施法范围
	t.chaUI["TD_PreCastSkill" .. skillId] = hUI.image:new({
		parent = t.handle._n,
		x = 0,
		y = 0,
		model = "MODEL_EFFECT:SelectCircle",
		animation = "range",
		z = -255,
		w = range * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
		--color = {128, 255, 128},
		--alpha = 48,
	})
	
	local scale = 0.9
	local a = CCScaleBy:create(0.6, scale, scale)
	local aR = a:reverse()
	local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR), "CCActionInterval")
	t.chaUI["TD_PreCastSkill" .. skillId].handle._n:runAction(CCRepeatForever:create(seq))
	
	local scale_inner = 0.0
	local program = hApi.getShader("atkrange1", 4, scale_inner) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
	local resolution = program:glGetUniformLocation("resolution")
	program:setUniformLocationWithFloats(resolution,66,66)
	
	local rr = program:glGetUniformLocation("rr")
	local gg = program:glGetUniformLocation("gg")
	local bb = program:glGetUniformLocation("bb")
	program:setUniformLocationWithFloats(rr, redRate)
	program:setUniformLocationWithFloats(gg, greenRate)
	program:setUniformLocationWithFloats(bb, blueRate)
	
	--显示最小攻击范围
	--hApi.clearShader("atkrange1", 1)
	--program:glluaAddTempUniform(0,scale,"inner_r") --动态刷shader
	--第一参 目前能传0-4 相当于lua能用5个可逐帧刷新的shader变量
	--第二参 是具体value（float）
	--第三参 是shader里用到的那个变量名
	local inner_r = program:glGetUniformLocation("inner_r")
	program:setUniformLocationWithFloats(inner_r, scale_inner)
	
	t.chaUI["TD_PreCastSkill" .. skillId].handle.s:setShaderProgram(program)
	
	--一段时间后消失
	local delay = CCDelayTime:create(nTime / 1000)
	local callback = CCCallFunc:create(function(ctrl)
		hApi.safeRemoveT(t.chaUI, "TD_PreCastSkill" .. skillId)
	end)
	t.chaUI["TD_PreCastSkill" .. skillId].handle.s:runAction(CCSequence:createWithTwoActions(delay, callback))
	
	return self:doNextAction()
end

--geyachao: 取角色或目标的子类型，并存到变量中
__aCodeList["GetChaSubType_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local subType = unit.data.type
		if param then
			d.tempValue[param] = subType
		end
	end
	
	--print("GetChaSubType_TD", targetType, param, param and d.tempValue[param])
	
	return self:doNextAction()
end

--geyachao: 取角色或目标的角度，并存到变量中
__aCodeList["GetChaFacing_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local facing = unit.data.facing
		if param then
			d.tempValue[param] = facing
		end
	end
	
	--print("GetChaFacing_TD", targetType, param, param and d.tempValue[param])
	
	return self:doNextAction()
end

__aCodeList["SetSkillToAnglePoint_TD"] = function(self,_, distance, angle)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if (type(distance) == "string") then
		distance = __AnalyzeValueExpr(self, d.unit, distance, "number")
	end
	
	angle = angle or 0
	if (type(angle) == "string") then
		angle = __AnalyzeValueExpr(self, d.unit, angle, "number")
	end
	
	local ux, uy = hApi.chaGetPos(u.handle) --目标的位置
	local facing = u.data.facing --角色面向的角度
	--print(facing)
	local fangle = (angle + facing) * math.pi / 180 --弧度制
	fangle = math.floor(fangle * 100) / 100 --保留2位有效数字，用于同步
	local tox = ux + distance * math.cos(fangle) --随机偏移值x
	local toy = uy - distance * math.sin(fangle) --随机偏移值y
	tox = math.floor(tox * 100) / 100 --保留2位有效数字，用于同步
	toy = math.floor(toy * 100) / 100 --保留2位有效数字，用于同步
	
	d.worldX, d.worldY = tox, toy
	d.gridX, d.gridY = w:xy2grid(tox, toy)
	
	return self:doNextAction()
end

--geyachao: 战车变身
__aCodeList["ChangeUnit_Diablo"] = function(self, _, targetType, unitId, livetime)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--geyachao: 支持传入参数
	if (type(unitId) == "string") then
		unitId = self.data.tempValue[unitId] --读temp表里的值
	end
	
	--geyachao: 支持传入参数
	if (type(livetime) == "string") then
		livetime = self.data.tempValue[livetime]
	end
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if unit and (unit ~= 0) then
		--战车变身
		hApi.TankChangeUnit(unit, unitId, livetime)
	end
	
	return self:doNextAction()
end

--geyachao: 将宠物召唤到战车身边
__aCodeList["TransportPet_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local me = w:GetPlayerMe()
	if me then
		local heros = me.heros
		local oHero = heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				local transport_px, transport_py = hApi.chaGetPos(oUnit.handle)
				
				--宠物也传送过来
				local rpgunits = w.data.rpgunits
				for u, u_worldC in pairs(rpgunits) do
					for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
						if (u.data.id == walle_id) then
							u:setPos(transport_px, transport_py, nil, bForceSetPos)
							--print("randommap宠物也传送:", u.data.name, walle_id, transport_px, transport_py)
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 获得随机迷宫boss房的坐标 xl, yt, xr, yb
__aCodeList["GetBossRoomRangePosition_Diablo"] = function(self, _, paramX1, paramY1, paramX2, paramY2)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--获得boss房的坐标
	local x1, y1, x2, y2 = hApi.GetBossRoomPosition()
	d.tempValue[paramX1] = x1
	d.tempValue[paramY1] = y1
	d.tempValue[paramX2] = x2
	d.tempValue[paramY2] = y2
	
	return self:doNextAction()
end

--抛物线轨道
--参数 minimise: 是否越来越小
__aCodeList["MissileToGrid"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, minimise)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	--print("effectId=", effectId)
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度=
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				shootX = dx
				shootY = dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		if e then
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
			
			--越来越小
			if (minimise == 1) then
				local t = e.data.playtime / 1000
				local scale0 = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].scale or 1
				local s1 = CCEaseSineIn:create(CCScaleTo:create(t/3, scale0 * 1.1))
				local s2 = CCEaseSineOut:create(CCScaleTo:create(t/3*2, 0.01))
				local sequence = CCSequence:createWithTwoActions(s1, s2)
				e.handle.s:runAction(sequence)
			end
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--抛物线（异步回调）
__aCodeList["MissileToGrid_Async"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, callbackSkillId, callbackSkillLv)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	
	if (type(callbackSkillId) == "string") then
		callbackSkillId = d.tempValue[callbackSkillId]
	end
	
	if (type(callbackSkillLv) == "string") then
		callbackSkillLv = d.tempValue[callbackSkillLv]
	end
	
	--print("effectId=", effectId)
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度=
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				shootX = dx
				shootY = dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		if e then
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			e.handle.collision_caster_unsafe = u --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			e.handle.collision_caster_worldC = u:getworldC() --碰撞类型飞行特效，施法者的唯一id
			e.handle.collision_caster_skillId = callbackSkillId --碰撞类型飞行特效，施法者释放的技能id
			e.handle.collision_caster_skillLv = callbackSkillLv --碰撞类型飞行特效，施法者释放的技能等级
			e.handle.collision_fly_begin_x = worldX+targetX --碰撞类型飞行特效，特效起始发出的x坐标
			e.handle.collision_fly_begin_y = worldY+targetY --碰撞类型飞行特效，特效起始发出的y坐标
			
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--拖尾的抛物线
--参数 minimise: 是否越来越小
__aCodeList["MissileToGrid_Streak"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, minimise)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	--print("effectId=", effectId)
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度=
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				shootX = dx
				shootY = dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		--print("w:addeffect", "eid=", eid, "self=", self)
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		if e then
			e.handle.MissleStreak = 1 --抛物线拖尾类型
			--d.FLYEFFECTS = {e}
			
			--越来越小
			if (minimise == 1) then
				local t = e.data.playtime / 1000
				local scale0 = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].scale or 1
				local s1 = CCEaseSineIn:create(CCScaleTo:create(t/3, scale0 * 1.1))
				local s2 = CCEaseSineOut:create(CCScaleTo:create(t/3*2, 0.01))
				local sequence = CCSequence:createWithTwoActions(s1, s2)
				e.handle.s:runAction(sequence)
			end
			
			local oEffect = e
			if oEffect then
				local handleTable = oEffect.handle
				local sprite = handleTable._n
				
				--存在特效
				if sprite and (sprite ~= 0) then
					local effectId = 591
					local modelKey = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].model
					--local modelKey = "MODEL_EFFECT:zhadan"
					--print(modelKey)
					if modelKey then
						local modelData,modelIndex = hApi.GetSafeModelByKey(modelKey)
						local md = hVar.tab_model[modelIndex]
						if md then
							local image = md.image
							local iamgePath = "data/image/" .. image 
							local eff_x, eff_y = sprite:getPosition() --特效的位置
							local width = 100
							local stand = md.animation[1]
							local scale = 0.1
							if stand then
								local w = md[stand][1] and md[stand][1][3]
								local h = md[stand][1] and md[stand][1][4]
								if w and h then
									local wh = math.min(w, h)
									width = wh * hVar.tab_effect[effectId].scale * scale
									--print("width", width)
								end
							end
							
							--第一个参数是间隐的时间，
							--第二个参数是间隐片断的大小，
							--第三个参数是贴图的宽高，
							--第四个参数是颜色值RGB，
							--第五个参数是贴图的路径或者贴图对象
							local streak = CCMotionStreak:create(0.1, 8, width, ccc3(255, 255, 255), iamgePath)
							streak:setPosition(ccp(eff_x, eff_y))
							sprite:getParent():addChild(streak, 10000)
							
							handleTable._pStreak = streak
							--print("handleTable._pStreak", handleTable._pStreak)
						end
					end
				end
			end
			
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--拖尾的抛物线（异步回调）
__aCodeList["MissileToGrid_Streak_Async"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, callbackSkillId, callbackSkillLv)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	if (type(callbackSkillId) == "string") then
		callbackSkillId = d.tempValue[callbackSkillId]
	end
	
	if (type(callbackSkillLv) == "string") then
		callbackSkillLv = d.tempValue[callbackSkillLv]
	end
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				--if u.data.facing>90 and u.data.facing<=270 then
				--	shootX = -1*shootX
				--end
				
				shootX = shootX + dx
				shootY = -shootY + dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		--print("w:addeffect", "eid=", eid, "self=", self)
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		--print(shootX, shootY)
		--print(worldX+targetX, worldY+targetY)
		if e then
			e.handle.MissleStreak = 1 --抛物线拖尾类型
			--d.FLYEFFECTS = {e}
			
			local oEffect = e
			if oEffect then
				local handleTable = oEffect.handle
				local sprite = handleTable._n
				
				--存在特效
				if sprite and (sprite ~= 0) then
					local effectId = 591
					local modelKey = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].model
					--print(modelKey)
					if modelKey then
						local modelData,modelIndex = hApi.GetSafeModelByKey(modelKey)
						local md = hVar.tab_model[modelIndex]
						if md then
							local image = md.image
							local iamgePath = "data/image/" .. image 
							local eff_x, eff_y = sprite:getPosition() --特效的位置
							local width = 100
							local stand = md.animation[1]
							local scale = 0.1
							if stand then
								local w = md[stand][1] and md[stand][1][3]
								local h = md[stand][1] and md[stand][1][4]
								if w and h then
									local wh = math.min(w, h)
									width = wh * hVar.tab_effect[effectId].scale * scale
									--print("width", width)
								end
							end
							
							--第一个参数是间隐的时间，
							--第二个参数是间隐片断的大小，
							--第三个参数是贴图的宽高，
							--第四个参数是颜色值RGB，
							--第五个参数是贴图的路径或者贴图对象
							local streak = CCMotionStreak:create(0.2, 8, width, ccc3(255, 255, 255), iamgePath)
							streak:setPosition(ccp(eff_x, eff_y))
							sprite:getParent():addChild(streak, 10000)
							
							handleTable._pStreak = streak
							--print("handleTable._pStreak", handleTable._pStreak)
						end
					end
				end
			end
			
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			e.handle.collision_caster_unsafe = u --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			e.handle.collision_caster_worldC = u:getworldC() --碰撞类型飞行特效，施法者的唯一id
			e.handle.collision_caster_skillId = callbackSkillId --碰撞类型飞行特效，施法者释放的技能id
			e.handle.collision_caster_skillLv = callbackSkillLv --碰撞类型飞行特效，施法者释放的技能等级
			e.handle.collision_fly_begin_x = worldX+targetX --碰撞类型飞行特效，特效起始发出的x坐标
			e.handle.collision_fly_begin_y = worldY+targetY --碰撞类型飞行特效，特效起始发出的y坐标
			
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--拖尾的抛物线
--参数 minimise: 是否越来越小
__aCodeList["MissileToGrid_LongStreak"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, minimise)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	--print("effectId=", effectId)
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度=
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				shootX = dx
				shootY = dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		--print("w:addeffect", "eid=", eid, "self=", self)
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		if e then
			e.handle.MissleStreak = 1 --抛物线拖尾类型
			--d.FLYEFFECTS = {e}
			
			--越来越小
			if (minimise == 1) then
				local t = e.data.playtime / 1000
				local scale0 = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].scale or 1
				local s1 = CCEaseSineIn:create(CCScaleTo:create(t/3, scale0 * 1.1))
				local s2 = CCEaseSineOut:create(CCScaleTo:create(t/3*2, 0.01))
				local sequence = CCSequence:createWithTwoActions(s1, s2)
				e.handle.s:runAction(sequence)
			end
			
			local oEffect = e
			if oEffect then
				local handleTable = oEffect.handle
				local sprite = handleTable._n
				
				--存在特效
				if sprite and (sprite ~= 0) then
					local effectId = 591
					local modelKey = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].model
					--local modelKey = "MODEL_EFFECT:zhadan"
					--print(modelKey)
					if modelKey then
						local modelData,modelIndex = hApi.GetSafeModelByKey(modelKey)
						local md = hVar.tab_model[modelIndex]
						if md then
							local image = md.image
							local iamgePath = "data/image/" .. image 
							local eff_x, eff_y = sprite:getPosition() --特效的位置
							local width = 100
							local stand = md.animation[1]
							local scale = 0.4
							if stand then
								local w = md[stand][1] and md[stand][1][3]
								local h = md[stand][1] and md[stand][1][4]
								if w and h then
									local wh = math.min(w, h)
									width = wh * hVar.tab_effect[effectId].scale * scale
									--print("width", width)
								end
							end
							
							--第一个参数是间隐的时间，
							--第二个参数是间隐片断的大小，
							--第三个参数是贴图的宽高，
							--第四个参数是颜色值RGB，
							--第五个参数是贴图的路径或者贴图对象
							local streak = CCMotionStreak:create(0.6, 8, width, ccc3(255, 255, 0), iamgePath)
							streak:setPosition(ccp(eff_x, eff_y))
							sprite:getParent():addChild(streak, 10000)
							
							handleTable._pStreak = streak
							--print("handleTable._pStreak", handleTable._pStreak)
						end
					end
				end
			end
			
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--长拖尾的抛物线（异步回调）
__aCodeList["MissileToGrid_LongStreak_Async"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent, callbackSkillId, callbackSkillLv)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	--geyachao: 角色不存在了，直接结束技能释放整个流程
	if (u == 0) or (u.ID == 0) or (u.data.IsDead == 1) then
		return "release", 1
	end
	
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	
	if (type(flySpeed) == "string") then
		flySpeed = d.tempValue[flySpeed]
	end
	
	if (type(callbackSkillId) == "string") then
		callbackSkillId = d.tempValue[callbackSkillId]
	end
	
	if (type(callbackSkillLv) == "string") then
		callbackSkillLv = d.tempValue[callbackSkillLv]
	end
	
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX or 0, d.worldY or 0
		shootX = __AnalyzeValueExpr(self,u,shootX,"number")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number")
		--这种特效会随着单位角度翻转
		if (effectId >= 0) then
			--geyachao: 炮塔支持16方向的偏移值，所以这里优先读表的偏移值
			local angle = u.data.facing --角色面向的角度
			
			if (tostring(angle) == "-1.#IND") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			if (tostring(angle) == "nan") then --防止一些异常值进来
				angle = 0
				u.data.angle = 0
			end
			
			--local tabU = hVar.tab_unit[u.data.id]
			local bullet = u.attr.bullet
			
			--if tabU and tabU.bullet then
			if bullet and (bullet ~= 0) then
				local NNN = bullet.num
				local a1 = 360 / 2 / NNN
				local a2 = a1 * 2
				local degree = math.floor((angle + a1) / a2)
				if (degree == NNN) then
					degree = 0
				end
				local partAngle = degree * a2
				local szPartAngle = tostring(partAngle)
				
				local dx = bullet[szPartAngle].offsetX
				local dy = bullet[szPartAngle].offsetY
				
				--if u.data.facing>90 and u.data.facing<=270 then
				--	shootX = -1*shootX
				--end
				
				shootX = shootX + dx
				shootY = -shootY + dy
				--print("partAngle=" .. partAngle, "shootX=" .. shootX, "shootY=" .. shootY)
			else
				--[[
				local fangle = angle * math.pi / 180 --弧度制
				local dx = shootX * math.cos(fangle) --随机偏移值x
				local dy = shootX * math.sin(fangle) --随机偏移值y
			
				shootX = shootX + dx
				shootY = shootY - dy
				]]
				if u.data.facing>90 and u.data.facing<=270 then
					shootX = -1*shootX
				end
			end
		else
			effectId = math.abs(effectId)
		end
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		local eid = effectId
		--print(worldX+targetX,worldY+targetY)
		--print(worldX, worldY)
		local eParam = {hVar.EFFECT_TYPE.MISSILE, u, shootX, shootY, flyAngle, flySpeed, rollSpeed,flyPercent}
		--print("w:addeffect", "eid=", eid, "self=", self)
		local e = w:addeffect(eid,0,eParam,worldX+targetX,worldY+targetY, nil, nil, nil, nil, self)
		--print(shootX, shootY)
		--print(worldX+targetX, worldY+targetY)
		if e then
			e.handle.MissleStreak = 1 --抛物线拖尾类型
			--d.FLYEFFECTS = {e}
			
			local oEffect = e
			if oEffect then
				local handleTable = oEffect.handle
				local sprite = handleTable._n
				
				--存在特效
				if sprite and (sprite ~= 0) then
					local effectId = 3123 --长拖尾
					local modelKey = hVar.tab_effect[effectId] and hVar.tab_effect[effectId].model
					--print(modelKey)
					if modelKey then
						local modelData,modelIndex = hApi.GetSafeModelByKey(modelKey)
						local md = hVar.tab_model[modelIndex]
						if md then
							local image = md.image
							local iamgePath = "data/image/" .. image 
							local eff_x, eff_y = sprite:getPosition() --特效的位置
							local width = 100
							local stand = md.animation[1]
							local scale = 0.4
							if stand then
								local w = md[stand][1] and md[stand][1][3]
								local h = md[stand][1] and md[stand][1][4]
								if w and h then
									local wh = math.min(w, h)
									width = wh * hVar.tab_effect[effectId].scale * scale
									--print("width", width)
								end
							end
							
							--第一个参数是间隐的时间，
							--第二个参数是间隐片断的大小，
							--第三个参数是贴图的宽高，
							--第四个参数是颜色值RGB，
							--第五个参数是贴图的路径或者贴图对象
							local streak = CCMotionStreak:create(0.6, 8, width, ccc3(255, 255, 0), iamgePath)
							streak:setPosition(ccp(eff_x, eff_y))
							sprite:getParent():addChild(streak, 10000)
							
							handleTable._pStreak = streak
							--print("handleTable._pStreak", handleTable._pStreak)
						end
					end
				end
			end
			
			--print("抛物线拖尾类型")
			if (flyPercent or 1)==1 then
				e.data.deadAnimation = "dead"
			end
			d.tempValue["@missileX"] = e.data.vx
			d.tempValue["@missileY"] = e.data.vy
		end
		if e and e.data.playtime>0 then
			--print("return sleep,tick    10")
			--return "sleep",e.data.playtime
			e.handle.collision_caster_unsafe = u --碰撞类型飞行特效，施法者（可能已死亡或被复用）
			e.handle.collision_caster_worldC = u:getworldC() --碰撞类型飞行特效，施法者的唯一id
			e.handle.collision_caster_skillId = callbackSkillId --碰撞类型飞行特效，施法者释放的技能id
			e.handle.collision_caster_skillLv = callbackSkillLv --碰撞类型飞行特效，施法者释放的技能等级
			e.handle.collision_fly_begin_x = worldX+targetX --碰撞类型飞行特效，特效起始发出的x坐标
			e.handle.collision_fly_begin_y = worldY+targetY --碰撞类型飞行特效，特效起始发出的y坐标
			
			return "sleep", math.huge --大菠萝，改为action回调继续后续流程
		else
			return self:doNextAction()
		end
	else
		return self:doNextAction()
	end
end

--纯表现用箭矢
__aCodeList["MissileEffectToGrid"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	if w then
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = d.worldX,d.worldY
		shootX = __AnalyzeValueExpr(self,u,shootX,"number","local")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number","local")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number","local")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number","local")
		--这种特效会随着单位角度翻转
		if effectId>=0 then
			if u.data.facing>90 and u.data.facing<=270 then
				shootX = -1*shootX
			end
		else
			effectId = math.abs(effectId)
		end
		local eid = effectId
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,u,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent},worldX+targetX,worldY+targetY)
		if (flyPercent or 1)==1 then
			e.data.deadAnimation = "dead"
		end
	end
	return self:doNextAction()
end

--纯表现用箭矢
__aCodeList["MissileEffectToTarget"] = function(self,_,effectId,flySpeed,flyAngle,shootX,shootY,targetX,targetY,rollSpeed,flyPercent)
	if type(flyAngle)~="number" then
		flyAngle = 0
	end
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	if w and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		local tabS = hVar.tab_skill[d.skillId]
		local tabU = hVar.tab_unit[u.data.id]
		if tabS and tabS.IsShoot==1 and tabU and tabU.shoot then
			local v = tabU.shoot
			if v[1]~=0 then
				effectId = v[1]
			end
			flySpeed = v[2] or flySpeed
			flyAngle = v[3] or flyAngle
			shootX = v[4] or shootX
			shootY = v[5] or shootY
		end
		shootX = shootX or 0
		shootY = shootY or 24
		local worldX,worldY = w:grid2xy(t.data.gridX,t.data.gridY)
		worldX = worldX+t.data.standX
		worldY = worldY+t.data.standY-10
		--local worldX,worldY = d.worldX,d.worldY
		shootX = __AnalyzeValueExpr(self,u,shootX,"number","local")
		shootY = __AnalyzeValueExpr(self,u,shootY,"number","local")
		targetX = __AnalyzeValueExpr(self,u,targetX,"number","local")
		targetY = __AnalyzeValueExpr(self,u,targetY,"number","local")
		--特效随角色动画发生偏移，可能引起不同步
		if u.handle.s~=nil then
			--local cx,cy = u.handle.s:getPosition() --geyachao: 可能引起内存泄露，这里基本上值为0，0
			local cx, cy = 0, 0
			shootX = shootX + cx
			shootY = shootY + cy
		end
		--这种特效会随着单位角度翻转
		if effectId>=0 then
			if u.data.facing>90 and u.data.facing<=270 then
				shootX = -1*shootX
			end
		else
			effectId = math.abs(effectId)
		end
		local eid = effectId
		local e = w:addeffect(eid,0,{hVar.EFFECT_TYPE.MISSILE,u,shootX,shootY,flyAngle,flySpeed,rollSpeed,flyPercent},worldX+targetX,worldY+targetY)
		if (flyPercent or 1)==1 then
			e.data.deadAnimation = "dead"
		end
	end
	return self:doNextAction()
end

--播放镭射特效(以自身为圆心发射出)
__aCodeList["LaserEffectToGrid"] = function(self,_,mode,nLaserId,offsetX,offsetY,offsetZ,tAnchor,tScale)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local w = d.world
	local t = d.unit
	if mode=="target" or mode=="groundT" then
		if d.targetC==0 then
			return self:doNextAction()
		else
			t = d.targetC
		end
	end
	if w~=0 and w.ID~=0 and t and t~=0 and t.ID~=0 then
		local ex,ey = 0,0
		local tEffectParam = 0
		if mode=="ground" then
			--在角色脚底
			ex,ey = d.unit:getXY(1)
			offsetY = -1*offsetY
		elseif mode=="groundT" then
			--在目标角色脚底
			ex,ey = t:getXY(1)
			offsetY = -1*offsetY
		else
			tEffectParam = {hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ}
		end
		local e = w:addeffect(nLaserId,1,tEffectParam,ex+offsetX,ey+offsetY)
		if e then
			local cx,cy = d.unit:getXY(1)
			local tx,ty
			if d.targetC~=0 then
				tx,ty = d.targetC:getXY(1)
			else
				tx,ty = w:grid2xy(d.gridX,d.gridY)
			end
			if type(tAnchor)=="table" then
				local rLaunch = 0
				if mode=="unit" then
					rLaunch = hApi.calArrowFacingXY(cx,cy,tx,ty,0)
				end
				
				local angle1 = tAnchor[1]
				if (type(angle1) == "string") then
					angle1 = d.tempValue[angle1]
				end
				
				e.handle.roll = rLaunch - 180 + angle1
				hApi.SpriteLoadFacing(e.handle)
				e.handle.s:setAnchorPoint(ccp(tAnchor[2],tAnchor[3]))
			else
				e.handle.s:setAnchorPoint(ccp(0,0.5))
				hApi.SpriteRollAsMissile(e.handle,cx,cy,tx,ty)
			end
			local array = CCArray:create()
			local nDur = 1
			for i = 1,#tScale do
				local t,w,h = tScale[i][1],tScale[i][2],tScale[i][3]
				nDur = nDur + math.floor(t*1000)
				if type(w)=="number" and type(h)=="number" then
					array:addObject(CCScaleBy:create(t,w,h))
				end
			end
			e.handle.s:runAction(CCSequence:create(array))
			hApi.RemoveEffectInTime(e.handle,nDur)
		end
	end
	
	return self:doNextAction()
end


--播放镭射特效(以自身为圆心发射出，朝指定角度射)
__aCodeList["LaserEffectToAngle_TD"] = function(self,_,mode,nLaserId, angle, offsetX, offsetY, offsetZ, tAnchor,tScale)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local w = d.world
	local t = d.unit
	
	if (type(angle) == "string") then
		--angle = d.tempValue[angle]
		angle = __AnalyzeValueExpr(self, u, angle, "number")
	end
	
	if (type(offsetX) == "string") then
		--offsetX = d.tempValue[offsetX]
		offsetX = __AnalyzeValueExpr(self, u, offsetX, "number")
	end
	
	if (type(offsetY) == "string") then
		--offsetY = d.tempValue[offsetY]
		offsetY = __AnalyzeValueExpr(self, u, offsetY, "number")
	end
	
	if (type(offsetZ) == "string") then
		--offsetZ = d.tempValue[offsetZ]
		offsetZ = __AnalyzeValueExpr(self, u, offsetZ, "number")
	end
	
	if mode=="target" or mode=="groundT" then
		if d.targetC==0 then
			return self:doNextAction()
		else
			t = d.targetC
		end
	end
	if w~=0 and w.ID~=0 and t and t~=0 and t.ID~=0 then
		local ex,ey = 0,0
		local tEffectParam = 0
		if mode=="ground" then
			--在角色脚底
			--ex,ey = d.unit:getXY(1)
			local eu_x, eu_y = hApi.chaGetPos(d.unit.handle)
			local eu_bx, eu_by, eu_bw, eu_bh = d.unit:getbox() --包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
			ex = eu_center_x
			ey = eu_center_y
			
			offsetY = offsetY
		elseif mode=="groundT" then
			--在目标角色脚底
			ex,ey = t:getXY(1)
			offsetY = -1*offsetY
		else
			local eu_x, eu_y = hApi.chaGetPos(d.unit.handle)
			local eu_bx, eu_by, eu_bw, eu_bh = d.unit:getbox() --包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
			offsetX = offsetX + (eu_center_x - eu_x) --发射起始的偏移x
			offsetY = -offsetY - (eu_center_y - eu_y) --发射起始的偏移y
			
			tEffectParam = {hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ}
		end
		local e = w:addeffect(nLaserId,1,tEffectParam,ex+offsetX,ey+offsetY)
		if e then
			local cx,cy = d.unit:getXY(1)
			local tx,ty
			if d.targetC~=0 then
				tx,ty = d.targetC:getXY(1)
			else
				tx,ty = w:grid2xy(d.gridX,d.gridY)
			end
			if type(tAnchor)=="table" then
				local rLaunch = 0
				if (mode =="ground") then
					--rLaunch = hApi.calArrowFacingXY(cx,cy,tx,ty,0)
					rLaunch = angle + 90
				elseif (mode =="unit") then
					--rLaunch = hApi.calArrowFacingXY(cx,cy,tx,ty,0)
					rLaunch = angle + 90
				end
				e.handle.roll = rLaunch - 180 + tAnchor[1]
				hApi.SpriteLoadFacing(e.handle)
				e.handle.s:setAnchorPoint(ccp(tAnchor[2],tAnchor[3]))
			else
				e.handle.s:setAnchorPoint(ccp(0,0.5))
				hApi.SpriteRollAsMissile(e.handle,cx,cy,tx,ty)
			end
			local array = CCArray:create()
			local nDur = 1
			for i = 1,#tScale do
				local t,w,h = tScale[i][1],tScale[i][2],tScale[i][3]
				nDur = nDur + math.floor(t*1000)
				if type(w)=="number" and type(h)=="number" then
					array:addObject(CCScaleBy:create(t,w,h))
				end
			end
			e.handle.s:runAction(CCSequence:create(array))
			hApi.RemoveEffectInTime(e.handle,nDur)
		end
	end
	return self:doNextAction()
end

------------------------------------------------
--逻辑操作
------------------------------------------------
local __ENUM__AddUnitToTemp = function(t,tempT,tCount)
	if tCount~=nil and (tCount[t.ID] or 0)>=tCount.n then
		return
	else
		if type(tempT.IgnoreBuff)=="table" then
			for i = 1,#tempT.IgnoreBuff do
				if tempT.IgnoreBuff[i]=="OTHER" then
					if t==tempT.t then
						return
					end
				elseif t:getbuff(tempT.IgnoreBuff[i]) then
					return
				end
			end
		end
		if tempT.tTabEx and hApi.CheckUnitTypeEx(t,tempT.tTabEx)==hVar.RESULT_FAIL then
			return
		end
		if hApi.IsSafeTarget(tempT.u,tempT.tTab,t)==hVar.RESULT_SUCESS then
			tempT[#tempT+1] = t
		end
	end
end

local __CODE__SortRandomTemp = function(oUnit,nGridX,nGridY,tTemp,tSort)
	if type(tSort)~="table" then
		return tTemp
	end
	--治疗者
	if tSort.HEAL==1 then
		local r = {}
		for i = 1,#tTemp do
			local v = tTemp[i]
			if not(v.attr.stack>=v.attr.__stack and v.attr.hp>=v.attr.mxhp) then
				r[#r+1] = tTemp[i]
			end
		end
		if #r>0 then
			tTemp = r
		end
	end
	--距离较近/远
	if tSort.NEAR==1 or tSort.FAR==1 then
		local r = {}
		local oWorld = oUnit:getworld()
		local nMin,nMax = 99,0
		for i = 1,#tTemp do
			local v = tTemp[i]
			local n = oWorld:distanceU(v,nil,1,nGridX,nGridY)
			if r[n]==nil then
				r[n] = {v}
			else
				r[n][#r[n]+1] = v
			end
			if n<nMin then
				nMin = n
			end
			if n>nMax then
				nMax = n
			end
		end
		if tSort.NEAR==1 then
			if r[nMin] then
				tTemp = r[nMin]
			end
		elseif tSort.FAR==1 then
			if r[nMax] then
				tTemp = r[nMax]
			end
		end
	end
	return tTemp
end

--选择随机目标(基于自身)
--__aFailToProcess["RandomTarget"] = 1
__aCodeList["RandomTarget"] = function(self,_,tTab,rMin,rMax,ToDo,ElseToDo,IgnoreBuff,tSort)
	--print("RandomTarget", self,_,tTab,rMin,rMax,ToDo,ElseToDo,IgnoreBuff,tSort) --geyachao
	
	local d = self.data
	local u = d.unit
	local t = d.target
	d.target = 0
	if u~=0 and u:getworld() then
		local w = u:getworld()
		local tTabEx
		if type(tTab)=="number" then
			if tTab==0 then
				tTab = d.skillId
				tTabEx = hVar.tab_skill[d.skillId].targetEx
			else
				tTabEx = hVar.tab_skill[tTab].targetEx
			end
		elseif tTab=="attack" then
			local nAttackId = hApi.GetDefaultSkill(u)
			tTab = nAttackId
			if rMin==-1 or rMax==-1 then
				local mn,mx = hApi.GetSkillRange(nAttackId,u)
				if rMin==-1 then
					rMin = mn
				end
				if rMax==-1 then
					rMax = mx
				end
			end
		end
		local tempT = {u = u,t = t,tTab = tTab,tTabEx = tTabEx,IgnoreBuff = IgnoreBuff}
		d.target = 0
		local tCount
		if type(d.targetCount)=="table" then
			tCount = d.targetCount
		end
		if rMax>=0 then
			w:enumunitUR(u,rMin,rMax,__ENUM__AddUnitToTemp,tempT,tCount)
		else
			w:enumunit(__ENUM__AddUnitToTemp,tempT,tCount)
		end
		tempT.u = 0
		if #tempT>0 then
			local r = __CODE__SortRandomTemp(u,u.data.gridX,u.data.gridY,tempT,tSort)
			local oTarget
			d.target = r[w:random(1,#r,"randomTarget")]
			if tCount~=nil then
				tCount[d.target.ID] = (tCount[d.target.ID] or 0) + 1
			end
			if ToDo==0 then
				d.target = 0
			elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
				d.target = t
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	return self:doNextAction()
end

--选择随机目标(基于自身)
--__aFailToProcess["RandomTarget"] = 1
__aCodeList["RandomTarget"] = function(self,_,tTab,rMin,rMax,ToDo,ElseToDo,IgnoreBuff,tSort)
	--print("RandomTarget", self,_,tTab,rMin,rMax,ToDo,ElseToDo,IgnoreBuff,tSort) --geyachao
	
	local d = self.data
	local u = d.unit
	local t = d.target
	d.target = 0
	if u~=0 and u:getworld() then
		local w = u:getworld()
		local tTabEx
		if type(tTab)=="number" then
			if tTab==0 then
				tTab = d.skillId
				tTabEx = hVar.tab_skill[d.skillId].targetEx
			else
				tTabEx = hVar.tab_skill[tTab].targetEx
			end
		elseif tTab=="attack" then
			local nAttackId = hApi.GetDefaultSkill(u)
			tTab = nAttackId
			if rMin==-1 or rMax==-1 then
				local mn,mx = hApi.GetSkillRange(nAttackId,u)
				if rMin==-1 then
					rMin = mn
				end
				if rMax==-1 then
					rMax = mx
				end
			end
		end
		local tempT = {u = u,t = t,tTab = tTab,tTabEx = tTabEx,IgnoreBuff = IgnoreBuff}
		d.target = 0
		local tCount
		if type(d.targetCount)=="table" then
			tCount = d.targetCount
		end
		if rMax>=0 then
			w:enumunitUR(u,rMin,rMax,__ENUM__AddUnitToTemp,tempT,tCount)
		else
			w:enumunit(__ENUM__AddUnitToTemp,tempT,tCount)
		end
		tempT.u = 0
		if #tempT>0 then
			local r = __CODE__SortRandomTemp(u,u.data.gridX,u.data.gridY,tempT,tSort)
			local oTarget
			d.target = r[w:random(1,#r,"randomTarget")]
			if tCount~=nil then
				tCount[d.target.ID] = (tCount[d.target.ID] or 0) + 1
			end
			if ToDo==0 then
				d.target = 0
			elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
				d.target = t
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	return self:doNextAction()
end

--geyachao: 新加类型, TD闪电链，标记开始
--选择下一个随机目标
__aCodeList["RandomChain_Begin"] = function(self, _)
	local d = self.data
	local t = d.target
	--local tpos_x, tpos_y = hApi.chaGetPos(t.handle) --目标的位置
	d.ChainLastTarget = 0 --闪电链最近一次的目标
	
	--将当前目标添加到闪电目标列表中
	if (d.ChainTargetList == 0) then
		d.ChainTargetList = {}
	end
	
	if t and (t ~= 0) then
		table.insert(d.ChainTargetList, t:getworldC())
	end
	--print("RandomChain_Begin")
	
	return self:doNextAction()
end

--geyachao: 新加类型, TD寻找下一个目标(基于施法者)
--选择下一个随机目标
__aCodeList["RandomTargetU_TD"] = function(self, _, search_radius, ToDo, ElseToDo)
	--print("RandomNextChainTarget", tTab, radius, ToDo, ElseToDo, IgnoreBuff, tSort)
	--print("RandomNextChainTarget_TD", hApi.gametime())
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(search_radius) == "string") then
		search_radius = d.tempValue[search_radius]
	end
	
	--print("RandomTarget_TD, u=", u and u.data.name or tostring(u), ", t=", t and (t.data.name .. "_" .. tostring(t)) or tostring(t)) --geyachao print
	
	if u and (u ~= 0) then
		local world = u:getworld()
		
		search_radius = search_radius or u:GetAtkRange() --默认为攻击半径
		
		--遍历所有的角色
		local nearestUint = nil --最近的目标
		local targetList = nil --所有可以攻击的目标列表
		
		--local isTower = hVar.tab_unit[u.data.id].isTower or 0 --施法者是否为塔
		if (u.data.type == hVar.UNIT_TYPE.TOWER) then
			--AI塔普通攻击寻找一个有效的目标（塔是按角色的box大小判定的，比角色的判定要大很多）
			_, targetList =  AI_tower_search_attack_target(u)
		else
			--_, targetList =  AI_search_attack_target(u) --普通单位搜敌
			_, targetList = AI_search_attack_shoot_target(u, search_radius) --普通单位搜敌（精确搜集）
		end
		
		--随机找一个
		if (targetList.num > 0) then
			local randIdx = world:random(1, targetList.num)
			nearestUint = targetList[randIdx].unit
		end
		
		--print(" 找到下一个目标 nearestUint=", nearestUint and nearestUint.data.name or nearestUint, tostring(nearestUint)) --geyachao print
		
		if nearestUint and (nearestUint ~= 0) then --存在下一个目标
			if (not ToDo) or (ToDo == 0) then
				d.target = nearestUint
				d.target_worldC = nearestUint:getworldC() --标记新的目标唯一id
				--print("  ToDo==0 d.target = 0") --geyachao print
			elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				d.target = nearestUint
				d.target_worldC = nearestUint:getworldC() --标记新的目标唯一id
				--print(" d.target = ", tostring(nearestUint)) --geyachao print
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
				d.target = 0
				d.target_worldC = 0 --标记新的目标唯一id
				--print(" d.target2 = 0") --geyachao print
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加类型, TD寻找下一个目标(基于目标)（常用于闪电链）
--选择下一个随机目标
__aCodeList["RandomTargetT_TD"] = function(self, _, search_radius, bEnableSameUnit, ToDo, ElseToDo)
	--print("RandomNextChainTarget", tTab, radius, ToDo, ElseToDo, IgnoreBuff, tSort)
	--print("RandomNextChainTarget_TD", hApi.gametime())
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	local tpos_x, tpos_y = 0, 0 --目标的位置
	
	if (type(search_radius) == "string") then
		search_radius = d.tempValue[search_radius]
	end
	
	--如果目标已经死亡或者不存在了，那么取目标上一次的位置
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (not t) or (t == 0) or (t.data.IsDead == 1) or (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
		tpos_x = d.worldX
		tpos_y = d.worldY
	else
		tpos_x, tpos_y = hApi.chaGetPos(t.handle) --目标的位置
	end
	
	--print("RandomNextChainTarget, u=", u and u.data.name or tostring(u), ", t=", t and (t.data.name .. "_" .. tostring(t)) or tostring(t)) --geyachao print
	
	--找到最近的下一个目标
	--遍历所有的角色
	local nearestUint = nil --最近的目标
	local allchas = {} --所有可以工具的目标列表
	--w:enumunit(function(eu)
	--w:enumunitArea(tpos_x, tpos_y, search_radius, function(eu)
	w:enumunitAreaEnemy(u:getowner():getforce(), tpos_x, tpos_y, search_radius, function(eu)
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		--if (eu:getowner():getforce() ~= u:getowner():getforce()) --跟目标相同的阵营
			if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) then --非塔、非建筑
				if bEnableSameUnit or (eu ~= t) then --非当前目标
					--非建筑、替换物、出生点、路点
					local subType = eu.data.type --子类型
					local cast_target_type = hVar.tab_skill[d.skillId].cast_target_type --技能可生效的目标的类型
					--if (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eu.data.type ~= hVar.UNIT_TYPE.PLAYER_INFO) and (eu.data.type ~= hVar.UNIT_TYPE.WAY_POINT) then
					if cast_target_type[subType] then
						if (eu.data.IsDead ~= 1) then --活着的角色
							--检测是否在范围内
							local ex, ey = hApi.chaGetPos(eu.handle)
							local dx = ex - tpos_x
							local dy = ey - tpos_y
							local distance = math.sqrt(dx * dx + dy * dy) --距离
							--print(eu.data.name, tostring(eu), dx, dy, distance)
							
							--在射程范围内
							if (distance <= search_radius) then
								--按照距离，从小到大排列
								local index = 1
								for i = 1, #allchas, 1 do
									local distancei = allchas[i].distance --第i个角色的距离
									if (distance < distancei) then
										index = i
										break
									end
								end
								--print("   找到可能的目标: ", tostring(eu), "distance=" .. distance)
								table.insert(allchas, index, {cha = eu, distance = distance})
							end
						end
					end
				end
			end
		--end
	end)
	
	--优先找未攻击过的目标
	for i = 1, #allchas, 1 do
		local cha = allchas[i].cha
		local bAttacked = false --是否攻击过该目标
		for j = 1, #d.ChainTargetList, 1 do
			if (d.ChainTargetList[j] == cha:getworldC()) then
				bAttacked = true
				break
			end
		end
		
		--未被攻击过的目标，优先设定为该目标
		if (not bAttacked) then
			--print(" 未被攻击过的目标，优先设定为该目标")
			nearestUint = cha
			break
		end
	end
	
	--如果未找到目标，说明所有的目标列表中都被攻击过了
	if (not nearestUint) and (#allchas > 0) then
		if (#allchas == 1) then --如果只有一个可选目标，那么就指定它
			nearestUint = allchas[1].cha
			--print(" 如果只有一个可选目标，那么就指定它")
		else --如果有多个可选目标，优先不攻击最近一次的目标，并随机一个其它的目标
			local ChainLastTarget = d.ChainLastTarget --上一次的目标
			
			--删掉最近一次的目标
			for k = 1, #allchas, 1 do
				if (allchas[k].cha == ChainLastTarget) then
					table.remove(allchas, k)
					break
				end
			end
			
			--随机一个其它的目标
			local randIdx = w:gametime() % #allchas + 1
			nearestUint = allchas[randIdx].cha
			--print(" 如果有多个可选目标，优先不攻击最近一次的目标，并随机一个其它的目标")
		end
	end
	
	--print(" 找到下一个目标 nearestUint=", nearestUint and nearestUint.data.name or nearestUint, tostring(nearestUint)) --geyachao print
	
	if nearestUint then --存在下一个目标
		--标记闪电链最近一次的目标
		d.ChainLastTarget  = t
		
		--标记闪电链当前目标的位置
		d.worldX = tpos_x --标记上一次目标的位置x
		d.worldY = tpos_y --标记上一次目标的位置y
		d.target_worldC = nearestUint:getworldC() --标记新的目标唯一id
		
		--将当前目标添加到闪电目标列表中
		table.insert(d.ChainTargetList, nearestUint:getworldC())
		
		if (not ToDo) or (ToDo== 0) then
			d.target = nearestUint
			--print("  ToDo==0 d.target = 0") --geyachao print
		elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
			d.target = nearestUint
			--print(" d.target = ", tostring(nearestUint)) --geyachao print
			return __aCodeList[ToDo[1]](self,unpack(ToDo))
		end
	else
		if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
			d.target = 0
			d.target_worldC = 0 --标记新的目标唯一id
			--print(" d.target2 = 0") --geyachao print
			return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加类型, TD寻找下一个目标(基于目标)
--选择下一个随机目标
__aCodeList["RandomTargetT_Diablo"] = function(self, _, search_radius, bEnableSameUnit, ToDo, ElseToDo)
	--print("RandomNextChainTarget", tTab, radius, ToDo, ElseToDo, IgnoreBuff, tSort)
	--print("RandomNextChainTarget_TD", hApi.gametime())
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	local tpos_x, tpos_y = 0, 0 --目标的位置
	
	if (type(search_radius) == "string") then
		search_radius = d.tempValue[search_radius]
	end
	
	--如果目标已经死亡或者不存在了，那么取目标上一次的位置
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (not t) or (t == 0) or (t.data.IsDead == 1) or (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
		tpos_x = d.worldX
		tpos_y = d.worldY
	else
		tpos_x, tpos_y = hApi.chaGetPos(t.handle) --目标的位置
	end
	
	--print("RandomNextChainTarget, u=", u and u.data.name or tostring(u), ", t=", t and (t.data.name .. "_" .. tostring(t)) or tostring(t)) --geyachao print
	
	--找到最近的下一个目标
	--遍历所有的角色
	local nearestUint = nil --最近的目标
	local allchas = {} --所有可以工具的目标列表
	--w:enumunit(function(eu)
	--w:enumunitArea(tpos_x, tpos_y, search_radius, function(eu)
	w:enumunitAreaEnemy(u:getowner():getforce(), tpos_x, tpos_y, search_radius, function(eu)
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		--if (eu:getowner():getforce() ~= u:getowner():getforce()) --跟目标相同的阵营
			if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) then --非塔、非建筑
				if bEnableSameUnit or (eu ~= t) then --非当前目标
					--非建筑、替换物、出生点、路点
					local subType = eu.data.type --子类型
					local cast_target_type = hVar.tab_skill[d.skillId].cast_target_type --技能可生效的目标的类型
					--if (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eu.data.type ~= hVar.UNIT_TYPE.PLAYER_INFO) and (eu.data.type ~= hVar.UNIT_TYPE.WAY_POINT) then
					if cast_target_type[subType] then
						if (eu.data.IsDead ~= 1) then --活着的角色
							--检测是否在范围内
							local ex, ey = hApi.chaGetPos(eu.handle)
							local dx = ex - tpos_x
							local dy = ey - tpos_y
							local distance = math.sqrt(dx * dx + dy * dy) --距离
							--print(eu.data.name, tostring(eu), dx, dy, distance)
							
							--在射程范围内
							if (distance <= search_radius) then
								--按照距离，从小到大排列
								local index = 1
								for i = 1, #allchas, 1 do
									local distancei = allchas[i].distance --第i个角色的距离
									if (distance < distancei) then
										index = i
										break
									end
								end
								--print("   找到可能的目标: ", tostring(eu), "distance=" .. distance)
								table.insert(allchas, index, {cha = eu, distance = distance})
							end
						end
					end
				end
			end
		--end
	end)
	
	--如果未找到目标，说明所有的目标列表中都被攻击过了
	if (not nearestUint) and (#allchas > 0) then
		if (#allchas == 1) then --如果只有一个可选目标，那么就指定它
			nearestUint = allchas[1].cha
			--print(" 如果只有一个可选目标，那么就指定它")
		else --如果有多个可选目标，优先不攻击最近一次的目标，并随机一个其它的目标
			local ChainLastTarget = d.ChainLastTarget --上一次的目标
			
			--删掉最近一次的目标
			for k = 1, #allchas, 1 do
				if (allchas[k].cha == ChainLastTarget) then
					table.remove(allchas, k)
					break
				end
			end
			
			--随机一个其它的目标
			local randIdx = w:gametime() % #allchas + 1
			nearestUint = allchas[randIdx].cha
			--print(" 如果有多个可选目标，优先不攻击最近一次的目标，并随机一个其它的目标")
		end
	end
	
	--print(" 找到下一个目标 nearestUint=", nearestUint and nearestUint.data.name or nearestUint, tostring(nearestUint)) --geyachao print
	
	if nearestUint then --存在下一个目标
		--标记闪电链最近一次的目标
		d.ChainLastTarget  = t
		
		--标记闪电链当前目标的位置
		d.worldX = tpos_x --标记上一次目标的位置x
		d.worldY = tpos_y --标记上一次目标的位置y
		d.target_worldC = nearestUint:getworldC() --标记新的目标唯一id
		
		if (not ToDo) or (ToDo== 0) then
			d.target = nearestUint
			--print("  ToDo==0 d.target = 0") --geyachao print
		elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
			d.target = nearestUint
			--print(" d.target = ", tostring(nearestUint)) --geyachao print
			return __aCodeList[ToDo[1]](self,unpack(ToDo))
		end
	else
		if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
			d.target = 0
			d.target_worldC = 0 --标记新的目标唯一id
			--print(" d.target2 = 0") --geyachao print
			return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
		end
	end
	
	return self:doNextAction()
end

--geyachao: 随机地图刷boss房间
__aCodeList["RandomMap_GenerateBossRom_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local regionId = w.data.randommapIdx
	local bGenerateNormal= false
	local bGenerateBoss = true
	hApi.CreateRandMapEnemys(w, regionId, bGenerateNormal, bGenerateBoss)
	
	return self:doNextAction()
end

--geyachao: 获得目标是否在房间外（随机地图）
__aCodeList["GetTargetIsOutRoom_Diablo"] = function(self, _, paramOutRoom)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local nIsOutRoom = hApi.RandomMapIsPointOutRoom(d.worldX, d.worldY)
	
	--储存变量
	if paramOutRoom then
		d.tempValue[paramOutRoom] = nIsOutRoom
	end
	
	return self:doNextAction()
end

--选择随机目标(基于目标)
--__aFailToProcess["RandomTargetT"] = 1
__aCodeList["RandomTargetT"] = function(self,_,tTab,rMin,rMax,ToDo,ElseToDo,IgnoreBuff,tSort)
	local d = self.data
	local u = d.unit
	local t = d.target
	d.target = 0
	if u~=0 and u:getworld() and t~=0 then
		local w = u:getworld()
		local tTabEx
		if type(tTab)=="number" then
			if tTab==0 then
				tTab = d.skillId
				tTabEx = hVar.tab_skill[d.skillId].targetEx
			else
				tTabEx = hVar.tab_skill[tTab].targetEx
			end
		elseif tTab=="attack" then
			tTab = u.attr.attack[1]
		end
		local tempT = {u = u,t = t,tTab = tTab,tTabEx = tTabEx,IgnoreBuff = IgnoreBuff}
		d.target = 0
		local tCount
		if type(d.targetCount)=="table" then
			tCount = d.targetCount
		end
		if rMax>=0 then
			w:enumunitUR(t,rMin,rMax,__ENUM__AddUnitToTemp,tempT,tCount)
		else
			w:enumunit(__ENUM__AddUnitToTemp,tempT,tCount)
		end
		tempT.u = 0
		if #tempT>0 then
			local r = __CODE__SortRandomTemp(u,t.data.gridX,t.data.gridY,tempT,tSort)
			local oTarget
			d.target = r[w:random(1,#r,"randomTarget")]
			if tCount~=nil then
				tCount[d.target.ID] = (tCount[d.target.ID] or 0) + 1
			end
			if ToDo==0 then
				d.target = 0
			elseif type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				return __aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
				d.target = t
				return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
	end
	return self:doNextAction()
end

--geyachao: 查找施法者当前可以攻击的第index个单位, param存储当前搜到的敌人的数量
__aCodeList["SearchAttackTarget_TD"] = function(self, _, index, search_radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(index) == "string") then
		index = d.tempValue[index]
	end
	
	if (type(search_radius) == "string") then
		search_radius = d.tempValue[search_radius]
	end
	
	--先存存初始值
	if param then
		d.tempValue[param] = 0
	end
	--print(u.data.name, search_radius)
	if u and (u ~= 0) then
		local world = u:getworld()
		
		search_radius = search_radius or u:GetAtkRange() --默认为攻击半径
		
		local targetList = nil --有效的目标列表
		
		--local isTower = hVar.tab_unit[u.data.id].isTower or 0 --施法者是否为塔
		if (u.data.type == hVar.UNIT_TYPE.TOWER) then
			--AI塔普通攻击寻找一个有效的目标（塔是按角色的box大小判定的，比角色的判定要大很多）
			_, targetList =  AI_tower_search_attack_target(u)
		else
			_, targetList = AI_search_attack_shoot_target(u, search_radius) --普通单位搜敌（精确搜集）
		end
		--local ui = targetTable[i].unit --单位i
		
		local targetNum = targetList.num --目标的数量
		if (targetNum == 0) then --没有目标
			--
		else --有目标
			local randIdx = 0
			local beginIdx = index
			while (beginIdx > 0) do
				beginIdx = beginIdx - 1
				randIdx = randIdx + 1
				if (randIdx > targetNum) then
					randIdx = 1
				end
			end
			
			--print("targetNum=" .. targetNum .. ", index=" .. index .. ", randIdx=" .. randIdx)
			local target = targetList[randIdx].unit --找到的目标
			
			d.target = target
			d.target_worldC = target:getworldC() --标记新的目标唯一id
		end
		
		--存储搜到的敌人的数量
		if param then
			d.tempValue[param] = targetNum
		end
	end
	--print()
	return self:doNextAction()
end

--geyachao: 查找施法者当前可以攻击的第index个单位, param存储当前搜到的敌人的数量
__aCodeList["SearchAttackTarget_BindUnit_TD"] = function(self, _, index, search_radius, bindType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(index) == "string") then
		index = d.tempValue[index]
	end
	
	if (type(search_radius) == "string") then
		search_radius = d.tempValue[search_radius]
	end
	
	--先存存初始值
	if param then
		d.tempValue[param] = 0
	end
	--print(u.data.name, search_radius)
	if u and (u ~= 0) then
		local world = u:getworld()
		
		--绑定的单位
		bu = u.data[bindType]
		if bu and (bu ~= 0) then
			search_radius = search_radius or bu:GetAtkRange() --默认为攻击半径
			
			local targetList = nil --有效的目标列表
			
			--local isTower = hVar.tab_unit[bu.data.id].isTower or 0 --施法者是否为塔
			if (bu.data.type == hVar.UNIT_TYPE.TOWER) then
				--AI塔普通攻击寻找一个有效的目标（塔是按角色的box大小判定的，比角色的判定要大很多）
				_, targetList =  AI_tower_search_attack_target(bu)
			else
				_, targetList = AI_search_attack_shoot_target(bu, search_radius) --普通单位搜敌（精确搜集）
			end
			--local ui = targetTable[i].unit --单位i
			
			local targetNum = targetList.num --目标的数量
			if (targetNum == 0) then --没有目标
				--
			else --有目标
				local randIdx = 0
				local beginIdx = index
				while (beginIdx > 0) do
					beginIdx = beginIdx - 1
					randIdx = randIdx + 1
					if (randIdx > targetNum) then
						randIdx = 1
					end
				end
				
				--print("targetNum=" .. targetNum .. ", index=" .. index .. ", randIdx=" .. randIdx)
				local target = targetList[randIdx].unit --找到的目标
				
				d.target = target
				d.target_worldC = target:getworldC() --标记新的目标唯一id
			end
			
			--存储搜到的敌人的数量
			if param then
				d.tempValue[param] = targetNum
			end
		end
	end
	
	--print()
	return self:doNextAction()
end

--普通攻击
__aCodeList["NormalAttack_TD"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if u and (u ~= 0) and t and (t ~= 0) then
		--geyachao: 普攻流程
		atttack(u, t)
	end
	
	return self:doNextAction()
end

--绑定的单位普通攻击
__aCodeList["NormalAttack_BindUnit_TD"] = function(self, _, bindType)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if u and (u ~= 0) and t and (t ~= 0) then
		--绑定的单位
		bu = u.data[bindType]
		if bu and (bu ~= 0) then
			--geyachao: 普攻流程
			--atttack(bu, t)
			
			--print("atttack", oUnit.data.name)
			local oUnit = bu
			local oTarget = t
			local skill_id = bu.attr.skill[1] --普攻技能id
			local tabS = hVar.tab_skill[skill_id]
			--print(tostring(oUnit), oUnit.data.name, "skill_id=" .. skill_id)
			local unitX, unitY = hApi.chaGetPos(oUnit.handle) --角色的位置
			local targetX, targetY = hApi.chaGetPos(oTarget.handle) --目标的位置
			local world = oUnit:getworld() --world
			local gridX, gridY = world:xy2grid(targetX, targetY)
			
			--检测技能id的合法性
			if (not tabS) then
				return
			end
			
			--转向
			if (oUnit.data.id ~= 6000) and (oUnit.data.id ~= 6012) and (oUnit.data.id ~= hVar.MY_TANK_ID) then
				if (oUnit.data.type ~= hVar.UNIT_TYPE.BUILDING) then --建筑、图腾，攻击不转向
					local ox, oy = hApi.chaGetPos(oUnit.handle)
					local tx, ty = hApi.chaGetPos(oTarget.handle)
					
					--读取技能表，是否有命中目标碰撞类飞行特效，那么改为目标的中心点
					local bMissileToTargetColl = false
					for i = 1, #tabS.action, 1 do
						local v = tabS.action[i]
						if (v[1] == "MissileToTarget_Collision")then --找到了
							bMissileToTargetColl = true
							break
						end
					end
					if bMissileToTargetColl then
						local t_bx, t_by, t_bw, t_bh = oTarget:getbox() --小兵的包围盒
						tx = tx + (t_bx + t_bw / 2) --中心点x位置
						ty = ty + (t_by + t_bh / 2) --中心点y位置
					end
					
					local facing = GetFaceAngle(ox, oy, tx, ty) --角色的朝向(角度制)
					--print("转向", oUnit.data.name, facing, "oldface=" .. oUnit.data.facing)
					
					--子弹的偏移
					--local tabU = hVar.tab_unit[oUnit.data.id]
					--local bullet = tabU and tabU.bullet
					local bullet = oUnit.attr.bullet
					if bullet and (bullet ~= 0) then
						local b0 = bullet["0"]
						local b90 = bullet["90"]
						local b180 = bullet["180"]
						local b270 = bullet["270"]
						if b0 and b90 and b180 and b270 then
							local x1 = b0.offsetX
							local y1 = b0.offsetY
							local x2 = b180.offsetX
							local y2 = b180.offsetY
							local x3 = b90.offsetX
							local y3 = b90.offsetY
							local x4 = b270.offsetX
							local y4 = b270.offsetY
							
							local x0 = ((y2-y1)*(x4-x3)*x1-(y4-y3)*(x2-x1)*x3)/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
							local y0 = ((x2-x1)*(y4-y3)*y1-(x4-x3)*(y2-y1)*y3)/((x2-x1)*(y4-y3)-(x4-x3)*(y2-y1))
							--print(x0, y0)
							
							facing = GetFaceAngle(ox + x0, oy - y0, tx, ty) --角色的朝向(角度制)
						end
					end
					
					hApi.ChaSetFacing(oUnit.handle, facing) --转向
					oUnit.data.facing = facing
					--print(oUnit.data.name, "转向1", facing)
				end
			end
			
			--释放技能(普通攻击)
			local tCastParam =
			{
				level = oUnit.attr.attack[6], --普通攻击的等级
				skillTimes = oUnit.data.atkTimes, --普通攻击的次数
			}
			hApi.CastSkill(oUnit, skill_id, 0, 100, oTarget, gridX, gridY, tCastParam) --普通攻击
			--print("普通攻击", gridX, gridY, "lv=" .. oUnit.attr.attack[6])
		end
	end
	
	return self:doNextAction()
end

--获得绑定的单位普通攻击的等级
__aCodeList["GetNormalAttackLv_BindUnit_TD"] = function(self, _, bindType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if u and (u ~= 0) then
		--绑定的单位
		bu = u.data[bindType]
		if bu and (bu ~= 0) then
			--geyachao: 普攻流程
			--atttack(bu, t)
			
			--print("GetNormalAttackLv_BindUnit_TD", bu.data.name)
			local oUnit = bu
			
			local lv = oUnit.attr.attack[6] --普通攻击的等级
			
			--存储
			if param then
				d.tempValue[param] = lv
			end
		end
	end
	
	return self:doNextAction()
end

--设置绑定的单位普通攻击的等级
__aCodeList["SetNormalAttackLv_BindUnit_TD"] = function(self, _, bindType, lv)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--等级支持字符串
	if (type(lv) == "string") then
		--lv = d.tempValue[lv]
		lv = __AnalyzeValueExpr(self, u, lv, "number")
	end
	
	--不超过最大普通攻击等级
	if (lv > hVar.ROLE_NORMALATK_MAXLV) then
		lv = hVar.ROLE_NORMALATK_MAXLV
	end
	
	if u and (u ~= 0) then
		--绑定的单位
		bu = u.data[bindType]
		if bu and (bu ~= 0) then
			--geyachao: 普攻流程
			--atttack(bu, t)
			
			--print("atttack", oUnit.data.name)
			local oUnit = bu
			
			oUnit.attr.attack[6] = lv --普通攻击的等级
			
			--同时设置单位的武器等级
			local basic_weapon_level = u:GetBasicWeaponLevel() --基础武器等级
			local deltaLevel = lv - basic_weapon_level
			u.attr.basic_weapon_level_tactic = u.attr.basic_weapon_level_tactic + deltaLevel
			
			--一并刷新界面的等级
			if (bindType == "bind_weapon") then
				local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
				local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				btn1.childUI["labSkillLv"]:setText(lv)
				if lv > 1 then
					btn1.childUI["labSkillLv"].handle._n:setVisible(true)
					btn1.childUI["labSkillMana"].handle._n:setVisible(true)
				else
					btn1.childUI["labSkillLv"].handle._n:setVisible(false)
					btn1.childUI["labSkillMana"].handle._n:setVisible(false)
				end
				
				--local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				--btn2.childUI["labSkillLv"]:setText(lv)
				
				
				--动画表现1
				local world = w
				local oHero = world:GetPlayerMe().heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						local ox, oy = hApi.chaGetPos(oUnit.handle)
						local screenX, screenY = hApi.world2view(ox, oy) --屏幕坐标
						local _frm2 = hGlobal.UI.TDSystemMenuBar
						local _parent = _frm2.handle._n
						local btn2 = _frm2.childUI["btnTactics_4"]
						local fromX = screenX
						local fromY = screenY
						local toX = _frm2.data.x + btn2.data.x
						local toY = _frm2.data.y + btn2.data.y
						
						--print(fromX, fromY, toX, toY)
						
						--local angle1 = GetLineAngle(fromX, fromY, toX, toY) --角度制
						local ctrl1 = hUI.image:new({
							parent = nil,
							x = fromX,
							y = fromY,
							z = 10000,
							model = "effect/lvup_attack.png",
							align = "MC",
							scale = 1.0,
						})
						--ctrl1.handle.s:setRotation(angle1)
						--地上的buff动画
						local ACTTIME = 0.6
						local config = ccBezierConfig:new()
						config.controlPoint_1 = ccp(fromX, fromY)     
						config.controlPoint_2 = ccp(fromX - (fromX - toX) / 1.5, fromY + (fromY - toY) / 2)
						config.endPosition = ccp(toX, toY)
						local moveto = CCEaseSineOut:create(CCBezierTo:create(ACTTIME, config))

						local scaleToSmall = CCScaleTo:create(ACTTIME, 0.2) --变小
						local rot = CCRotateBy:create(ACTTIME, 720) --旋转
						local spawn1 = CCSpawn:createWithTwoActions(scaleToSmall, rot) --同步1
						local spawn2 = CCSpawn:createWithTwoActions(moveto, spawn1) --同步1
						--local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
						local callback = CCCallFunc:create(function()
							ctrl1:del()
						end)
						ctrl1.handle._n:runAction(CCSequence:createWithTwoActions(spawn2, callback))

						--按钮的动画
						local ACTTIME2 = 0.52
						local delay = CCDelayTime:create(ACTTIME2)
						local scaleBig = CCEaseSineOut:create(CCScaleTo:create(ACTTIME - ACTTIME2, 1.2))
						local scaleSmall = CCEaseSineIn:create(CCScaleTo:create(ACTTIME - ACTTIME2, 1.0))
						local a = CCArray:create()
						a:addObject(delay)
						a:addObject(scaleBig)
						a:addObject(scaleSmall)
						local sequence = CCSequence:create(a)
						btn2.handle._n:runAction(sequence)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--获得单位普通攻击的等级
__aCodeList["GetNormalAttackLv_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local oUnit = unit
		--print("GetNormalAttackLv_TD", oUnit.data.name)
		local lv = oUnit.attr.attack[6] --普通攻击的等级
		
		--存储
		if param then
			d.tempValue[param] = lv
		end
	end
	
	return self:doNextAction()
end

--设置单位普通攻击的等级
__aCodeList["SetNormalAttackLv_TD"] = function(self, _, targetType, lv)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--等级支持字符串
	if (type(lv) == "string") then
		--lv = d.tempValue[lv]
		lv = __AnalyzeValueExpr(self, unit, lv, "number")
	end
	
	--不超过最大普通攻击等级
	if (lv > hVar.ROLE_NORMALATK_MAXLV) then
		lv = hVar.ROLE_NORMALATK_MAXLV
	end
	
	if unit and (unit ~= 0) then
		local oUnit = unit
		
		oUnit.attr.attack[6] = lv --普通攻击的等级
		
		--同时设置单位的武器等级
		local basic_weapon_level = oUnit:GetBasicWeaponLevel() --基础武器等级
		local deltaLevel = lv - basic_weapon_level
		oUnit.attr.basic_weapon_level_tactic = oUnit.attr.basic_weapon_level_tactic + deltaLevel
		
		if (oUnit.data.type == hVar.UNIT_TYPE.HERO_TOKEN) then
			--一并刷新界面的等级
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			btn1.childUI["labSkillLv"]:setText(lv)
			if lv > 1 then
				btn1.childUI["labSkillLv"].handle._n:setVisible(true)
				btn1.childUI["labSkillMana"].handle._n:setVisible(true)
			else
				btn1.childUI["labSkillLv"].handle._n:setVisible(false)
				btn1.childUI["labSkillMana"].handle._n:setVisible(false)
			end
			
			--local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
			--btn2.childUI["labSkillLv"]:setText(lv)
		end
	end
	
	return self:doNextAction()
end



--获得绑定的单位技能的等级
__aCodeList["GetNormalSkillLv_BindUnit_TD"] = function(self, _, bindType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if u and (u ~= 0) then
		--print("atttack", oUnit.data.name)
		local oUnit = u
		local oHero = oUnit:gethero()
		if oHero and (oHero ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local k = 1
				local activeItemId = itemSkillT[k].activeItemId --主动技能的id
				local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
				local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
				local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
				--print(activeItemId)
				
				--存储
				if param then
					d.tempValue[param] = activeItemLv
				end
			end
		end
	end
	
	return self:doNextAction()
end

--设置绑定的单位技能的等级
__aCodeList["SetNormalSkillLv_BindUnit_TD"] = function(self, _, bindType, lv)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--等级支持字符串
	if (type(lv) == "string") then
		--lv = d.tempValue[lv]
		lv = __AnalyzeValueExpr(self, u, lv, "number")
	end
	
	--不超过最大普通攻击等级
	if (lv > hVar.ROLE_NORMALATK_MAXLV) then
		lv = hVar.ROLE_NORMALATK_MAXLV
	end
	
	if u and (u ~= 0) then
		--print("atttack", oUnit.data.name)
		local oUnit = u
		local oHero = oUnit:gethero()
		if oHero and (oHero ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local k = 1
				local activeItemId = itemSkillT[k].activeItemId --主动技能的id
				local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
				local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
				local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
				--print(activeItemId)
				
				local tabI = hVar.tab_item[activeItemId]
				
				itemSkillT[k].activeItemLv = lv --坦克技能的等级
				itemSkillT[k].activeItemCD = tabI.activeSkill.cd[lv] or 0 --更新主动技能的CD
				
				--一并刷新界面的等级
				if (bindType == "bind_weapon") then
					local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
					--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
					--btn1.childUI["labSkillLv"]:setText(lv)
					
					local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
					
					btn2.data.tacticCD = itemSkillT[k].activeItemLv
					
					btn2.childUI["labSkillLv"]:setText(lv)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--获得绑定的单位技能的使用次数
__aCodeList["GetNormalSkillUseCount_BindUnit_TD"] = function(self, _, bindType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if u and (u ~= 0) then
		--print("atttack", oUnit.data.name)
		local oUnit = u
		local oHero = oUnit:gethero()
		if oHero and (oHero ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				--一并刷新界面的等级
				if (bindType == "bind_weapon") then
					local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
					--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
					--btn1.childUI["labSkillLv"]:setText(lv)
					
					local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
					local useCountMax = btn2.data.useCountMax
					
					--存储
					if param then
						d.tempValue[param] = useCountMax
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--设置绑定的单位技能的使用次数
__aCodeList["SetNormalSkilllUseCount_BindUnit_TD"] = function(self, _, bindType, useCount)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--等级支持字符串
	if (type(useCount) == "string") then
		--useCount = d.tempValue[useCount]
		useCount = __AnalyzeValueExpr(self, u, useCount, "number")
	end
	
	if u and (u ~= 0) then
		--print("atttack", oUnit.data.name)
		local oUnit = u
		local oHero = oUnit:gethero()
		if oHero and (oHero ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				--刷新界面的等级
				if (bindType == "bind_weapon") then
					local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
					--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
					--btn1.childUI["labSkillLv"]:setText(lv)
					
					local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
					
					local useCountOld = btn2.data.useCount
					local useCountMaxOld = btn2.data.useCountMax
					
					local deltaUseCount = useCount - useCountMaxOld
					if (deltaUseCount > 0) then --新的次数比旧的大
						btn2.data.useCountMax = useCountMaxOld + deltaUseCount
						btn2.data.useCount = useCountOld + deltaUseCount
					elseif (deltaUseCount == 0) then --一样大
						--
					elseif (deltaUseCount < 0) then --新的次数比旧的小
						btn2.data.useCountMax = useCountMaxOld + deltaUseCount
						if (useCountOld > useCount) then
							btn2.data.useCount = useCount
						end
					end
					
					--数字显使用次数
					if btn2.childUI["labSkillUseCount"] then
						local uc = btn2.childUI["labSkillUseCount"].handle._n:getString()
						if (uc ~= "") then
							btn2.childUI["labSkillUseCount"]:setText(btn2.data.useCount)
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--获得单位普通技能的等级
__aCodeList["GetNormalSkillLv_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local oUnit = buNew.data["bind_weapon_owner"]
		if oUnit and (oUnit ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local k = 1
				local activeItemId = itemSkillT[k].activeItemId --主动技能的id
				local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
				local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
				local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
				--print("GetNormalSkillLv_TD", activeItemId)
				
				--存储
				if param then
					d.tempValue[param] = activeItemLv
				end
			end
		end
	end
	
	return self:doNextAction()
end

--设置单位普通技能的等级
__aCodeList["SetNormalSkillLv_TD"] = function(self, _, targetType, lv)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--等级支持字符串
	if (type(lv) == "string") then
		--lv = d.tempValue[lv]
		lv = __AnalyzeValueExpr(self, unit, lv, "number")
	end
	
	--不超过最大普通攻击等级
	if (lv > hVar.ROLE_NORMALATK_MAXLV) then
		lv = hVar.ROLE_NORMALATK_MAXLV
	end
	
	if unit and (unit ~= 0) then
		local oUnit = buNew.data["bind_weapon_owner"]
		if oUnit and (oUnit ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local k = 1
				local activeItemId = itemSkillT[k].activeItemId --主动技能的id
				local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
				local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
				local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
				
				local tabI = hVar.tab_item[activeItemId]
				
				itemSkillT[k].activeItemLv = lv --坦克技能的等级
				itemSkillT[k].activeItemCD = tabI.activeSkill.cd[lv] or 0 --更新主动技能的CD
				
				--一并刷新界面的等级
				local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
				--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				--btn1.childUI["labSkillLv"]:setText(lv)
				
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				
				btn2.data.tacticCD = itemSkillT[k].activeItemLv
				
				btn2.childUI["labSkillLv"]:setText(lv)
			end
		end
	end
	
	return self:doNextAction()
end

--获得单位普通技能的使用次数
__aCodeList["GetNormalSkillUseCount_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local oUnit = buNew.data["bind_weapon_owner"]
		if oUnit and (oUnit ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
				--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				--btn1.childUI["labSkillLv"]:setText(lv)
				
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				local useCountMax = btn2.data.useCountMax
				
				--存储
				if param then
					d.tempValue[param] = useCountMax
				end
			end
		end
	end
	
	return self:doNextAction()
end

--设置单位普通技能的使用次数
__aCodeList["SetNormalSkillUseCount_TD"] = function(self, _, targetType, useCount)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--等级支持字符串
	if (type(useCount) == "string") then
		--useCount = d.tempValue[useCount]
		useCount = __AnalyzeValueExpr(self, unit, useCount, "number")
	end
	
	if unit and (unit ~= 0) then
		local oUnit = buNew.data["bind_weapon_owner"]
		if oUnit and (oUnit ~= 0) then
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
				--local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				--btn1.childUI["labSkillLv"]:setText(lv)
				
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				
				local useCountOld = btn2.data.useCount
				local useCountMaxOld = btn2.data.useCountMax
				
				local deltaUseCount = useCount - useCountMaxOld
				if (deltaUseCount > 0) then --新的次数比旧的大
					btn2.data.useCountMax = useCountMaxOld + deltaUseCount
					btn2.data.useCount = useCountOld + deltaUseCount
				elseif (deltaUseCount == 0) then --一样大
					--
				elseif (deltaUseCount < 0) then --新的次数比旧的小
					btn2.data.useCountMax = useCountMaxOld + deltaUseCount
					if (useCountOld > useCount) then
						btn2.data.useCount = useCount
					end
				end
				
				--数字显使用次数
				if btn2.childUI["labSkillUseCount"] then
					local uc = btn2.childUI["labSkillUseCount"].handle._n:getString()
					if (uc ~= "") then
						btn2.childUI["labSkillUseCount"]:setText(btn2.data.useCount)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--获得单位战车的技能的等级
__aCodeList["GetTankSkillLv_TD"] = function(self, _, targetType, skillId, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		if (unit.data.bind_weapon_owner ~= 0) then
			local skillObj = unit.data.bind_weapon_owner:getskill(skillId)
			if skillObj then
				local skillLv = skillObj[2]
				--print("skillLv=", skillLv)
				d.tempValue[param] = skillLv
			end
		end
	end
	
	return self:doNextAction()
end

--弹出对话
__aCodeList["CreateMapTalk_TD"] = function(self, _, talkType)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--创建大地图对话
	local function __createMapTalk(flag, talkType, _func, ...)
		local arg = {...}
		local oWorld = hClass.world:new({type="none"})
		local oUnit = oWorld:addunit(1,1)
		
		local vTalk = hApi.AnalyzeTalk(oUnit, oUnit, {flag, talkType,}, {id = {nil,nil},})
		if vTalk then
			oWorld:del()
			oUnit:del()
			hApi.CreateUnitTalk(vTalk,function()
				if _func and type(_func) == "function" then
					_func(unpack(arg))
				end
			end)
		else
			if _func and type(_func) == "function" then
				_func(unpack(arg))
			end
		end
	end
	
	--对话结束回调函数
	local OnTalkFinish_Event = function()
		hGlobal.event:event("Event_StartPauseSwitch", false)
	end
	
	--显示对话框
	hGlobal.event:event("Event_StartPauseSwitch", true)
	__createMapTalk("skill", "$_001_jx_01", OnTalkFinish_Event, 0, 0)
	
	return self:doNextAction()
end

--




--geyachao: 返回施法者以自身周围敌人的数量
__aCodeList["GetNearByEnemyNumU_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--角色位置
	local ux, uy = hApi.chaGetPos(u.handle)
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local EnemyNum = 0 --返回值
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(ux, uy, radius, function(eu)
	w:enumunitAreaEnemy(unitSide, ux, uy, radius, function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			
			--不是同一个阵营
			--if (unitSide ~= euSide) then
				EnemyNum = EnemyNum + 1
			--end
		end
	end)
	
	--print("GetNearByEnemyNumU_TD param", d.tempValue[param], EnemyNum)
	d.tempValue[param] = EnemyNum
	return self:doNextAction()
end

--geyachao: 返回施法者以自身周围敌人、敌塔、敌建筑数量
__aCodeList["GetNearByEnemyNumU_Building_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--角色位置
	local ux, uy = hApi.chaGetPos(u.handle)
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local EnemyNum = 0 --返回值
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(ux, uy, radius, function(eu)
	w:enumunitAreaEnemy(unitSide, ux, uy, radius, function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) or (eu.data.type == hVar.UNIT_TYPE.TOWER) then --只处理英雄、小兵、建筑、塔
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			
			--不是同一个阵营
			--if (unitSide ~= euSide) then
				EnemyNum = EnemyNum + 1
			--end
		end
	end)
	
	--print("GetNearByEnemyNumU_TD param", d.tempValue[param], EnemyNum)
	d.tempValue[param] = EnemyNum
	return self:doNextAction()
end

--geyachao: 返回施法者以自身周围友军的数量
__aCodeList["GetNearByAllyNumU_TD"] = function(self, _, radius, param, bIsAddSelf)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--角色位置
	local ux, uy = hApi.chaGetPos(u.handle)
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local AllyNum = 0 --返回值
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(ux, uy, radius, function(eu)
	w:enumunitAreaAlly(unitSide, ux, uy, radius, function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			
			--是同一个阵营
			--if (unitSide == euSide) then
				if (eu == u) then --搜索到施法者
					if (bIsAddSelf == true) or (bIsAddSelf == 1) then
						AllyNum = AllyNum + 1
					end
				else
					AllyNum = AllyNum + 1
				end
			--end
		end
	end)
	
	--print("GetNearByAllyNumU_TD param", d.tempValue[param], AllyNum)
	d.tempValue[param] = AllyNum
	return self:doNextAction()
end

--geyachao: 返回施法者以目标或者目标点为中心，周围敌人的数量
__aCodeList["GetNearByEnemyNumT_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--目标或者目标点的位置
	local tx, ty = 0, 0
	if t then
		tx, ty = hApi.chaGetPos(t.handle)
	else
		tx, ty = d.worldX, d.worldY
	end
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local EnemyNum = 0 --返回值
	--local tabS = hVar.tab_skill[d.skillId]
	--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
	local cast_target_type = d.cast_target_type --技能可生效的目标的类型
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(tx, ty, radius, function(eu)
	w:enumunitAreaEnemy(unitSide, tx, ty, radius, function(eu)
		--if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
		local subType = eu.data.type --子类型
		if cast_target_type[subType] then
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			
			--不是同一个阵营
			--if (unitSide ~= euSide) then
				EnemyNum = EnemyNum + 1
			--end
		end
	end)
	
	--print("GetNearByEnemyNumT_TD param", EnemyNum)
	d.tempValue[param] = EnemyNum
	return self:doNextAction()
end

--geyachao: 返回施法者以目标或目标点为中心周围友军的数量
__aCodeList["GetNearByAllyNumT_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--目标或者目标点的位置
	local tx, ty = 0, 0
	if t then
		tx, ty = hApi.chaGetPos(t.handle)
	else
		tx, ty = d.worldX, d.worldY
	end
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	--local tabS = hVar.tab_skill[d.skillId]
	--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
	local cast_target_type = d.cast_target_type --技能可生效的目标的类型
	local AllyNum = 0 --返回值
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(tx, ty, radius, function(eu)
	w:enumunitAreaAlly(unitSide, tx, ty, radius, function(eu)
		--if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
		local subType = eu.data.type --子类型
		if cast_target_type[subType] then
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			--是同一个阵营
			--if (unitSide == euSide) then
				AllyNum = AllyNum + 1
			--end
			--print("存在友军", eu.data.name, eu.data.id)
		end
	end)
	
	--print("GetNearByAllyNumU_TD param", d.tempValue[param], AllyNum)
	d.tempValue[param] = AllyNum
	return self:doNextAction()
end

--geyachao: 返回施法者以目标或目标点为中心周围友军英雄的数量
__aCodeList["GetNearByAllyHeroNumT_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--目标或者目标点的位置
	local tx, ty = 0, 0
	if t then
		tx, ty = hApi.chaGetPos(t.handle)
	else
		tx, ty = d.worldX, d.worldY
	end
	
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local AllyNum = 0 --返回值
	local w = u:getworld()
	--w:enumunit(function(eu)
	--w:enumunitArea(tx, ty, radius, function(eu)
	w:enumunitAreaAlly(unitSide, tx, ty, radius, function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.HERO) then --只处理英雄
			--local euSide = eu:getowner():getforce() --目标的属方阵营
			
			--是同一个阵营
			--if (unitSide == euSide) then
				AllyNum = AllyNum + 1
			--end
		end
	end)
	
	--print("GetNearByAllyNumU_TD param", d.tempValue[param], AllyNum)
	d.tempValue[param] = AllyNum
	return self:doNextAction()
end

--geyachao: 交换施法者和目标
__aCodeList["SwitchUT_TD"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	if u then
		d.target = u
		d.target_worldC = u:getworldC() --标记新的目标唯一id
	end
	
	if t then
		d.unit = t
		d.unit_worldC = t:getworldC() --标记新的施法者唯一id
	end
	
	return self:doNextAction()
end

--geyachao: 施法者自身周围一个随机小兵为目标(无论敌我)，param存储当前搜到的小兵的数量
__aCodeList["SetRandomUnit_TD"] = function(self, _, radius, param)
	local d = self.data
	local u = d.unit
	--local t = d.target
	local w = u:getworld()
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius]
	end
	
	--半径过小，返回0
	if (radius <= 0) then
		d.tempValue[param] = 0
		return self:doNextAction()
	end
	
	--施法者的位置
	local ux, uy = hApi.chaGetPos(u.handle)
	--local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	local UnitList = {} --返回值(无论敌我)
	--w:enumunit(function(eu)
	--print("施法者的位置", ux, uy, radius, u.data.name)
	--搜索全部单位
	w:enumunitArea(u:getowner():getforce(), ux, uy, radius, function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理小兵
			if (eu ~= u) then
				--print("只处理小兵", eu.data.name)
				UnitList[#UnitList+1] = eu
			end
		end
	end)
	
	--随机一个小兵为目标
	if (#UnitList > 0) then
		local randIdx = w:random(1, #UnitList)
		local target = UnitList[randIdx]
		d.target = target
		d.target_worldC = target:getworldC() --标记新的目标唯一id
	end
	
	--print("GetNearByEnemyNumT_TD param", EnemyNum)
	d.tempValue[param] = #UnitList
	return self:doNextAction()
end

--geyachao: 将单位直接设置到指定坐标（瞬移）
__aCodeList["ChaSetPosU_TD"] = function(self, _, unitType, to_x, to_y, angle)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
		
		--防止单位被复用
		if oUnit and (oUnit ~= 0) and (oUnit:getworldC() == d.unit_worldC) then
			--
		else
			oUnit = nil
		end
	elseif (unitType == "target") then
		oUnit = d.target
		
		--防止目标被复用
		if oUnit and (oUnit ~= 0) and (oUnit:getworldC() == d.target_worldC) then
			--
		else
			oUnit = nil
		end
	end
	
	if (type(to_x) == "string") then
		to_x = d.tempValue[to_x]
	end
	
	if (type(to_y) == "string") then
		to_y = d.tempValue[to_y]
	end
	
	if (type(angle) == "string") then
		angle = d.tempValue[angle]
	end
	
	if oUnit then
		oUnit:setPos(to_x, to_y, angle)
	end
	
	return self:doNextAction()
end

--geyachao: 改变单位的主动战术技能的cd（秒）
__aCodeList["ReduceTacticCD_Current_TD"] = function(self, _, unitType, reduceCD)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(reduceCD) == "string") then
		reduceCD = d.tempValue[reduceCD]
	end
	--print("ReduceTacticCD_Current_TD", oUnit and oUnit.data.name, oUnit.data.id)
	if oUnit and (oUnit ~= 0) then
		--读取单位的英雄对象
		local oHero = oUnit:gethero()
		--print("  ", oHero and oHero.data.name)
		if oHero and (oHero ~= 0) then
			--读取玩家对象
			local oPlayer = oHero:getowner()
			--print("  ", oPlayer and oPlayer.data.name)
			if oPlayer and (oPlayer ~= 0) then
				local tacticId = 0 --战术技能id
				local tTactics = world:gettactics(oPlayer:getpos()) --本局该玩家所有的战术技能卡
				for i = 1, #tTactics, 1 do
					--print(i, "tTactics[i]=", tTactics[i])
					if (tTactics[i] ~= 0) then
						local id = tTactics[i][1]
						local lv = tTactics[i][2]
						local typeId = tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
						--print(id, lv, typeId)
						if (oUnit.data.id == typeId) then --找到了
							tacticId = id
							break
						end
					end
				end
				--print("  ", tacticId)
				--存在战术技能
				if (tacticId > 0) then
					local itemId = 0
					hApi.ReducePlayerTacticCardCD_Current(oPlayer, tacticId, itemId, reduceCD)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 改变单位的当前道具技能的cd（秒）
__aCodeList["ReduceItemCD_Current_TD"] = function(self, _, unitType, itemId, reduceCD)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(reduceCD) == "string") then
		reduceCD = d.tempValue[reduceCD]
	end
	
	--print("ReduceItemCD_Current_TD", oUnit and oUnit.data.name, oUnit.data.id)
	if oUnit and (oUnit ~= 0) then
		--读取单位的英雄对象
		local oHero = oUnit:gethero()
		--print("  ", oHero and oHero.data.name)
		if oHero and (oHero ~= 0) then
			--读取玩家对象
			local oPlayer = oHero:getowner()
			--print("  ", oPlayer and oPlayer.data.name)
			if oPlayer and (oPlayer ~= 0) then
				local tacticId = 0 --战术技能id
				
				--存在道具技能
				if (itemId > 0) then
					hApi.ReducePlayerTacticCardCD_Current(oPlayer, tacticId, itemId, reduceCD)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 改变单位的道具技能的cd上限（秒）
__aCodeList["ReduceItemCD_Max_TD"] = function(self, _, unitType, itemId, reduceCD)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(reduceCD) == "string") then
		reduceCD = d.tempValue[reduceCD]
	end
	
	--print("ReduceItemCD_Max_TD", oUnit and oUnit.data.name, oUnit.data.id)
	if oUnit and (oUnit ~= 0) then
		--读取单位的英雄对象
		local oHero = oUnit:gethero()
		--print("  ", oHero and oHero.data.name)
		if oHero and (oHero ~= 0) then
			--读取玩家对象
			local oPlayer = oHero:getowner()
			--print("  ", oPlayer and oPlayer.data.name)
			if oPlayer and (oPlayer ~= 0) then
				local tacticId = 0 --战术技能id
				
				--存在道具技能
				if (itemId > 0) then
					hApi.ReducePlayerTacticCardCD_Max(oPlayer, tacticId, itemId, reduceCD)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 改变坦克的道具技能的cd上限（秒）
__aCodeList["ReduceTankSkillCD_Diablo"] = function(self, _, unitType, reduceCD)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(reduceCD) == "string") then
		--reduceCD = d.tempValue[reduceCD]
		reduceCD = __AnalyzeValueExpr(self, oUnit, reduceCD, "number")
	end
	
	--print("ReduceItemCD_Max_TD", oUnit and oUnit.data.name, oUnit.data.id)
	if oUnit and (oUnit ~= 0) then
		--读取单位的英雄对象
		local oHero = oUnit:gethero()
		--print("  ", oHero and oHero.data.name)
		if oHero and (oHero ~= 0) then
			--读取玩家对象
			local oPlayer = oHero:getowner()
			--print("  ", oPlayer and oPlayer.data.name)
			if oPlayer and (oPlayer ~= 0) then
				local typeId = oUnit.data.id
				local tacticId = 0 --战术技能id
				local itemId = hVar.tab_unit[typeId].skillItemlId or 0 --道具技能
				
				--存在道具技能
				if (itemId > 0) then
					hApi.ReducePlayerTacticCardCD_Max(oPlayer, tacticId, itemId, reduceCD)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 添加被动战术技能卡
__aCodeList["AddPassiveTacticCard_TD"] = function(self, _, targetType, tacticId, tacticLv, bShowTacticCardUI, bAddtoTop)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(tacticId) == "string") then
		tacticId = d.tempValue[tacticId] --读temp表里的值
	end
	
	if (type(tacticLv) == "string") then
		tacticLv = d.tempValue[tacticLv] --读temp表里的值
	end
	
	if unit then
		local player = unit:getowner()
		if player then
			w:settactics(player, {{tacticId, tacticLv, 1},})
			
			--单个战术卡生效
			--(注意: 此接口仅用于单机地图地上捡到战术卡时调用，其他地方禁止调用)
			player:tacticsTakeEffect_single(tacticId, tacticLv)
			
			--是否显示获得被动战术卡的动画效果
			if bShowTacticCardUI then
				--本阵营
				if (player:getforce() == w:GetPlayerMe():getforce()) then
					hGlobal.event:event("LocalEvent_SinglePassiveTacticsAmin", player, tacticId, tacticLv, bAddtoTop)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 添加主动道具卡
__aCodeList["AddActiveItemCard_TD"] = function(self, _, targetType, itemId, itemLv, itemNum)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(itemId) == "string") then
		itemId = d.tempValue[itemId] --读temp表里的值
	end
	
	if (type(itemLv) == "string") then
		itemLv = d.tempValue[itemLv] --读temp表里的值
	end
	
	if (type(itemNum) == "string") then
		itemNum = d.tempValue[itemNum] --读temp表里的值
	end
	
	if unit then
		local player = unit:getowner()
		if player then
			--添加道具技能
			hGlobal.event:event("Event_AddTacticsActiveSkill", player, itemId, itemLv, itemNum, unit.data.id)
			
			if (itemId) and (itemId ~= 0) then
				local tabI = hVar.tab_item[itemId]
				if tabI then
					local itemType = tabI.type
					--local itemTacticId = tabI.tacticId
					
					--统计使用的战术卡
					if (itemType == hVar.ITEM_TYPE.TACTIC_USE) then
						local tInfo = GameManager.GetGameInfo("tacticInfo")
						local debrisNum = 0
						if tInfo[itemId] then
							debrisNum = tInfo[itemId]
						end
						
						--数量加1
						debrisNum = debrisNum + 1
						print("@@@@@@@@ 统计使用的战术卡", itemId, debrisNum)
						
						--存储
						local tData = {itemId, debrisNum}
						GameManager.SetGameInfo("tacticInfo", {tData,})
						hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					end
					
					--统计武器枪宝箱
					if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then
						local tInfo = GameManager.GetGameInfo("chestInfo")
						local weapongunChestNum = 0
						if tInfo[itemId] then
							weapongunChestNum = tInfo[itemId]
						end
						
						--数量加1
						weapongunChestNum = weapongunChestNum + 1
						print("@@@@@@@@ 统计武器枪宝箱", weapongunChestNum)
						
						--存储
						local tData = {itemId, weapongunChestNum}
						GameManager.SetGameInfo("chestInfo", {tData,})
						hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					end
					
					--统计战术卡宝箱
					if (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then
						local tInfo = GameManager.GetGameInfo("chestInfo")
						local tacticChestNum = 0
						if tInfo[itemId] then
							tacticChestNum = tInfo[itemId]
						end
						
						--数量加1
						tacticChestNum = tacticChestNum + 1
						print("@@@@@@@@ 统计战术卡宝箱", tacticChestNum)
						
						--存储
						local tData = {itemId, tacticChestNum}
						GameManager.SetGameInfo("chestInfo", {tData,})
						hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					end
					
					--统计宠物宝箱
					if (itemType == hVar.ITEM_TYPE.CHEST_PET) then
						local tInfo = GameManager.GetGameInfo("chestInfo")
						local petChestNum = 0
						if tInfo[itemId] then
							petChestNum = tInfo[itemId]
						end
						
						--数量加1
						petChestNum = petChestNum + 1
						print("@@@@@@@@ 统计宠物宝箱", petChestNum)
						
						--存储
						local tData = {itemId, petChestNum}
						GameManager.SetGameInfo("chestInfo", {tData,})
						hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					end
					
					--统计装备宝箱
					if (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then
						local tInfo = GameManager.GetGameInfo("chestInfo")
						local equipChestNum = 0
						if tInfo[itemId] then
							equipChestNum = tInfo[itemId]
						end
						
						--数量加1
						equipChestNum = equipChestNum + 1
						print("@@@@@@@@ 统计装备宝箱", equipChestNum)
						
						--存储
						local tData = {itemId, equipChestNum}
						GameManager.SetGameInfo("chestInfo", {tData,})
						hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 获得玩家主动道具卡的存档等级
__aCodeList["GetPlayerActiveItemCardLv_TD"] = function(self, _, targetType, itemId, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(itemId) == "string") then
		itemId = d.tempValue[itemId] --读temp表里的值
	end
	
	if unit then
		local player = unit:getowner()
		if player then
			local tabI = hVar.tab_item[itemId] or {}
			local tacticId = tabI.tacticId or 0
			local tacticInfo = LuaGetPlayerTacticById(tacticId)
			if tacticInfo then
				local id, lv, num = unpack(tacticInfo)
				
				if param then
					d.tempValue[param] = lv
				end
			end
		end
	end
	
	return self:doNextAction()
end


--大菠萝
--geyachao: 标记战车在播放攻击动作
__aCodeList["TankTagPoseAttack_Diablo"] = function(self, _)
	local d = self.data
	local w = self.data.world
	local u = d.unit
	
	if u then
		u.attr.isInPoseAttack = 1 --是否在播放攻击动作（摇杆时不播走路动作）
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 标记战车取消播放攻击动作
__aCodeList["TankTagCancelPoseAttack_Diablo"] = function(self, _)
	local d = self.data
	local w = self.data.world
	local u = d.unit
	
	if u then
		u.attr.isInPoseAttack = 0 --是否在播放攻击动作（摇杆时不播走路动作）
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 申请用户自定义数据块
__aCodeList["CustomDataCreate_Diablo"] = function(self, _, paramIdx)
	local d = self.data
	local w = self.data.world
	
	--默认存储为0
	d.tempValue[paramIdx] = 0
	
	if w then
		local customData = w.data.customData
		local customDataPivot = w.data.customDataPivot
		
		--分配空间
		customDataPivot = customDataPivot + 1
		w.data.customDataPivot = customDataPivot
		customData[customDataPivot] = {}
		
		d.tempValue[paramIdx] = customDataPivot
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 删除用户自定义数据块
__aCodeList["CustomDataRemove_Diablo"] = function(self, _, pivotIdx)
	local d = self.data
	local w = self.data.world
	
	if (type(pivotIdx) == "string") then
		--pivotIdx = d.tempValue[pivotIdx]
		pivotIdx = __AnalyzeValueExpr(self, oUnit, pivotIdx, "number")
	end
	
	if w then
		local customData = w.data.customData
		local customDataPivot = w.data.customDataPivot
		
		--清除空间
		customData[pivotIdx] = nil
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 读取用户自定义数据块
__aCodeList["CustomDataRead_Diablo"] = function(self, _, pivotIdx, paramKey, paramValue)
	local d = self.data
	local w = self.data.world
	
	if (type(pivotIdx) == "string") then
		--pivotIdx = d.tempValue[pivotIdx]
		pivotIdx = __AnalyzeValueExpr(self, oUnit, pivotIdx, "number")
	end
	
	--默认存储为0
	d.tempValue[paramValue] = 0
	
	if w then
		local customData = w.data.customData
		local customDataPivot = w.data.customDataPivot
		
		if customData[pivotIdx] then
			d.tempValue[paramValue] = customData[pivotIdx][paramKey] or 0
		end
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 设置用户自定义数据块
__aCodeList["CustomDataWrite_Diablo"] = function(self, _, pivotIdx, paramKey, value)
	local d = self.data
	local w = self.data.world
	
	if (type(pivotIdx) == "string") then
		--pivotIdx = d.tempValue[pivotIdx]
		pivotIdx = __AnalyzeValueExpr(self, oUnit, pivotIdx, "number")
	end
	
	if (type(value) == "string") then
		--value = d.tempValue[value]
		value = __AnalyzeValueExpr(self, oUnit, value, "number")
	end
	
	if w then
		local customData = w.data.customData
		local customDataPivot = w.data.customDataPivot
		
		if customData[pivotIdx] then
			customData[pivotIdx][paramKey] = value
		end
	end
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 读取是否为打boss状态
__aCodeList["ReadIsBattleBossMode_Diablo"] = function(self, _, param)
	local d = self.data
	local w = self.data.world
	
	--默认存储为0
	d.tempValue[param] = w.data.tank_bossmode
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 设置是否为打boss状态
__aCodeList["SetIsBattleBossMode_Diablo"] = function(self, _, bossmode)
	local d = self.data
	local w = self.data.world
	local u = d.unit
	
	if (type(bossmode) == "string") then
		--bossmode = d.tempValue[bossmode]
		bossmode = __AnalyzeValueExpr(self, u, bossmode, "number")
	end
	
	--设置
	w.data.tank_bossmode = bossmode
	
	return self:doNextAction()
end

--大菠萝
--geyachao: 添加追踪随身特效
__aCodeList["EffectOnTarget_Tracing"] = function(self,_,mode,effectId,loop,offsetX,offsetY,offsetZ,dummy)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	
	if type(loop)~="number" then
		loop = 1
	end
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local t
	local oAction = self
	if mode=="unit" then
		t = d.unit
		
		--geyachao: 检测角色是否还是原来的(防止目标死亡后被复用)
		if (t ~= 0) and (t:getworldC() ~= d.unit_worldC) then --不是同一个角色了
			return "release", 1
		end
	elseif mode=="target" then
		t = d.target
		
		--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
		if (t) and (t ~= 0) and (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
			return "release", 1
		end
	elseif type(mode)=="table" then
		--如果是指定角色身上的某一个buff来添加特效的话
		if mode[1]=="unit" then
			t = d.unit
		else--if mode[1]=="target" then
			t = d.target
		end
		if t then
			oAction = t:getbuff(mode[2])
			--如果无法找到buff，那么就不添加了
			if oAction==nil then
				t = nil
			end
		end
	else
		t = d.target
	end
	if w and t~=0 and t~=nil then
		offsetX = __AnalyzeValueExpr(self,u,offsetX,"number","local")
		offsetY = __AnalyzeValueExpr(self,u,offsetY,"number","local")
		if dummy~=nil and type(dummy)=="string" then
			local tabU = hVar.tab_unit[t.data.id]
			if tabU and tabU.boxB then
				--拥有战场碰撞盒的单位，永远显示在正中间
			elseif dummy=="overhead" then
				local cx,cy,cw,ch = t:getbox()
				offsetX = offsetX+math.floor(cx+cw/2)
				offsetY = offsetY-cy
			elseif dummy=="origin" then
				offsetX = 0
				offsetY = 0
			elseif dummy=="foot" then
				local cx,cy,cw,ch = t:getbox()
				offsetX = offsetX+math.floor(cx+cw/2)
				offsetY = offsetY-cy-ch
			elseif dummy=="center" or dummy=="chest" then
				local cx,cy,cw,ch = t:getbox()
				offsetX = offsetX+math.floor(cx+cw/2)
				offsetY = offsetY+math.floor(ch/2+cy)
			else
				offsetX = 0
				offsetY = 0
			end
		end
		
		--[[
		if loop<=0 then
			--print("oAction:addControlEffect")
			oAction:addControlEffect(w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY))
		else
			w:addeffect(effectId,loop,{hVar.EFFECT_TYPE.UNIT,d.skillId,t,offsetZ},offsetX,offsetY)
		end
		]]
		local target_x, target_y = hApi.chaGetPos(t.handle) --目标的位置
		local eff = w:addeffect(effectId, 99999, nil, target_x + offsetX, target_y + offsetY) --56
		--local rot = sprite:getRotation()
		--eff.handle._n:setRotation(rot)
		t:AddTacingEffect(eff, target_x + offsetX, target_y + offsetY)
	end
	return self:doNextAction()
end

--大菠萝
--geyachao: 附加战车本关临时数据
__aCodeList["AddCurrentStageInfo_Diablo"] = function(self, _, key, value)
	local d = self.data
	local w = self.data.world
	local u = d.unit
	
	--参数支持字符串类型
	if (type(value) == "string") then
		value = d.tempValue[value]
	end
	
	local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	local nStage = tInfo.stage or 1 --本关id
	if tInfo.stageInfo == nil then
		tInfo.stageInfo = {}
	end
	if tInfo.stageInfo[nStage] == nil then
		tInfo.stageInfo[nStage] = {}
	end
	
	if (tInfo.stageInfo[nStage][key] == nil) then
		tInfo.stageInfo[nStage][key] = 0
	end
	
	--附加值
	tInfo.stageInfo[nStage][key] = tInfo.stageInfo[nStage][key] + value
	print("附加战车本关临时数据:", "nStage="..nStage, "key="..key, "value="..value, "result="..tInfo.stageInfo[nStage][key])
	
	--存档
	LuaSavePlayerList()
	
	return self:doNextAction()
end

--攻击临近目标1格的单位
__aFailToProcess["SweepAttack"] = 1
__aCodeList["SweepAttack"] = function(self,_,nDmgMode,dMin,dMax,ToDo,ElseToDo)
	local d = self.data
	local u = d.unit
	if u~=0 and u:getworld() and d.target~=0 and hVar.tab_skill[d.skillId] then
		d.IsPaused = 1		--禁止在code调用中执行doNextAction
		local SavedTarget = d.target
		local w = u:getworld()
		local tempT = {u = u,tTab = hVar.tab_skill[d.skillId].target}
		local tCount
		if type(d.targetCount)=="table" then
			tCount = d.targetCount
		end
		w:enumunitUR(u,0,1,__ENUM__AddUnitToTemp,tempT,tCount)
		tempT.u = 0
		local count = 0
		if #tempT>0 then
			for i = 1,#tempT do
				if w:distanceU(SavedTarget,tempT[i],1)<=1 then
					count = count + 1
				else
					tempT[i] = 0
				end
			end
		end
		if #tempT>0 and count>0 then
			if dMax>=0 then
				for i = 1,#tempT do
					if tempT[i]~=0 then
						d.target = tempT[i]
						__aCodeList["__DamageTarget"](self,"__DamageTarget",tempT[i],nDmgMode,dMin,dMax)
					end
				end
			end
			if type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
				__aCodeList[ToDo[1]](self,unpack(ToDo))
			end
		else
			if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
				__aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
			end
		end
		d.IsPaused = 0
		d.target = SavedTarget
	end
	return self:doNextAction()
end

--随机目标重复次数限制
__aCodeList["RandomTargetCount"] = function(self,_,nCount,nCurCount)
	local d = self.data
	if type(nCount)=="number" then
		d.targetCount = {n=math.max(1,nCount)}
		if type(nCurCount)=="number" and type(d.target)=="table" then
			d.targetCount[d.target.ID] = (d.targetCount[d.target.ID] or 0) + nCurCount
		end
	end
	return self:doNextAction()
end

__aCodeList["AddTargetCount"] = function(self,_,nCount)
	local d = self.data
	if type(nCount)=="number" and type(d.targetCount)=="table" and type(d.target)=="table" then
		d.targetCount[d.target.ID] = (d.targetCount[d.target.ID] or 0) + nCount
	end
	return self:doNextAction()
end

--变成BUFF
__aCodeList["BecomeBuff"] = function(self,_,mode,key)
	local d = self.data
	local world = hGlobal.WORLD.LastWorldMap
	if d.IsBuff==-1 then
		--已经死亡的技能物体啥也不管
	elseif d.IsBuff~=0 then
		_DEBUG_MSG("[LUA WARNING]尝试将已经是buff的技能物体转换成buff")
	else
		key = tostring(key)
		d.IsBuff = key
		
		local t
		if mode=="unit" then
			t = d.unit
		else--if mode=="target" then
			t = d.target
		end
		
		--print("变成BUFF", key, t.data.name, d.skillId)
		
		if t and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
			local StackNum = 1
			local _,oID = hApi.bind2Object(self,"bindU",t,"buffs",key)
			--print("hApi.bind2Object", "oID=", oID, d.skillId)
			if oID~=nil and oID~=0 then
				local oBuff = hClass.action:find(oID)
				if oBuff then
					StackNum = (tonumber(oBuff.data.tempValue["@stack"]) or 0) + 1
					d.replaceTick = world:gametime()
					hApi.unbind2Object(oBuff,"bindU",t,"buffs")
					--print("hApi.unbind2Object")
					oBuff.data.IsBuff = -1
					oBuff.data.IsPaused = 0
					oBuff:go("continue",1)
				end
			end
			
			--新加的buff，标记角色身上tag
			if (oID == nil) then
				--标记角色身上的tag
				local buff_tags = t.data.buff_tags
				if buff_tags then
					local buffTag = d.buffTag
					if (buffTag ~= 0) then
						if buff_tags[buffTag] then
							buff_tags[buffTag] = buff_tags[buffTag] + 1
						else
							buff_tags[buffTag] = 1
						end
						--print("+", t.data.name .. "_" .. t:getworldC(), buffTag)
					end
				end
			end
			
			self.data.tempValue["@stack"] = StackNum
		else
			d.IsBuff = -1
			return self:doNextAction()
		end
	end
	return self:doNextAction()
end

--移除buff
__aCodeList["RemoveBuff"] = function(self,_,mode,key,toParamVar)
	local d = self.data
	key = tostring(key)
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if t and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		local oBuff = t:getbuff(key)
		if oBuff then
			--if type(toParamVar)=="string" then
				--hApi.ReadUnitValue(d.tempValue,toParamVar,t,"number",1)
			--end
			hApi.unbind2Object(oBuff,"bindU",t,"buffs")
			oBuff.data.IsBuff = -1
			oBuff.data.IsPaused = 0
			if oBuff~=self then
				oBuff:go("continue",1)
			end
		end
	end
	return self:doNextAction()
end

local __ENUM__GetBuffWithState = function(oAction,tStateIdx,tTemp)
	local tState = oAction.data.BuffState
	if type(tState)=="table" then
		for i = 1,#tState do
			if tState[i]~=0 and tStateIdx[tState[i][2]]==1 then
				tTemp[#tTemp+1] = oAction
			end
		end
	end
end

__aCodeList["RemoveBuffWithState"] = function(self,_,mode,tState,noBuffToDo)
	local d = self.data
	key = tostring(key)
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if t and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		local tTemp = {}
		local tStateIdx = {}
		for i = 1,#tState do
			tStateIdx[tState[i]] = 1
		end
		t:enumbuff(__ENUM__GetBuffWithState,tStateIdx,tTemp)
		if #tTemp>0 then
			for i = 1,#tTemp do
				local oBuff = tTemp[i]
				if oBuff and oBuff.ID>0 and oBuff.data.IsBuff~=-1 and oBuff~=self then
					hApi.unbind2Object(oBuff,"bindU",t,"buffs")
					oBuff.data.IsBuff = -1
					oBuff.data.IsPaused = 0
					oBuff:go("continue",1)
				end
			end
		else
			if type(noBuffToDo)=="table" and noBuffToDo[1]~=nil and __aFailToProcess[noBuffToDo[1]]~=1 and __aCodeList[noBuffToDo[1]] then
				return __aCodeList[noBuffToDo[1]](self,unpack(noBuffToDo))
			else
				return self:doNextAction()
			end
		end
	end
	return self:doNextAction()
end

--修改buff，如果存在的话，把buff等级记录到自己的参数中
__aCodeList["SetBuffValue"] = function(self,_,mode,key,toParamVar,expr)
	local d = self.data
	key = tostring(key)
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if t and t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		local oBuff = t:getbuff(key)
		if oBuff and type(toParamVar)=="string" then
			oBuff.data.tempValue[toParamVar] = __AnalyzeValueExpr(self,d.unit,expr,"number")
		end
	end
	return self:doNextAction()
end

__aCodeList["CountBuff"] = function(self,_,mode,toParamVar,buffName)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 and type(toParamVar)=="string" then
		d.tempValue[toParamVar] = t:countbuff(buffName)
	end
	return self:doNextAction()
end

local __TempStack = 0
local __ENUM__CountBuff = function(oAction,buffName)
	if oAction.data.IsBuff==buffName and type(oAction.data.tempValue)=="table" and type(oAction.data.tempValue["@stack"])=="number" then
		__TempStack = math.max(oAction.data.tempValue["@stack"],__TempStack)
		return
	end
end

__aCodeList["ReadBuffStack"] = function(self,_,mode,buffName,toParamVar)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 and type(toParamVar)=="string" and type(buffName)=="string" then
		__TempStack = 0
		t:enumbuff(__ENUM__CountBuff,buffName)
		d.tempValue[toParamVar] = __TempStack
	end
	return self:doNextAction()
end

local __TokenTempB = {}
local __TokenTempV = {}
__aCodeList["CopyValueFromBuff"] = function(self,_,mode,buffName,tParamVar,noBuffToDo)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 and type(buffName)=="string" then
		local tVal = __TokenTempB
		local tKey
		local oBuff = t:getbuff(buffName)
		if oBuff then
			tVal = oBuff.data.tempValue
		else
			--如果没有找到buff的话，走这个流程
			if type(noBuffToDo)=="table" and noBuffToDo[1]~=nil and __aFailToProcess[noBuffToDo[1]]~=1 and __aCodeList[noBuffToDo[1]] then
				return __aCodeList[noBuffToDo[1]](self,unpack(noBuffToDo))
			else
				return self:doNextAction()
			end
		end
		local case = type(tParamVar)
		if case=="string" then
			__TokenTempV[1] = tParamVar
			tKey = __TokenTempV
		elseif case=="table" then
			tKey = tParamVar
		end
		if tKey then
			for i = 1,#tKey do
				local k = tKey[i]
				if type(k)=="string" then
					if k=="$GRID" then
						d.gridX = oBuff.data.gridX
						d.gridY = oBuff.data.gridY
					else
						d.tempValue[k] = tVal[k] or 0
					end
				end
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["CopyValueToBuff"] = function(self,_,mode,buffName,tParamVar)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t and t~=0 and type(buffName)=="string" then
		local tKey
		local case = type(tParamVar)
		if case=="string" then
			__TokenTempV[1] = tParamVar
			tKey = __TokenTempV
		elseif case=="table" then
			tKey = tParamVar
		end
		local oBuff = t:getbuff(buffName)
		if tKey and oBuff then
			for i = 1,#tKey do
				local k = tKey[i]
				if type(k)=="string" then
					oBuff.data.tempValue[k] = d.tempValue[k] or 0
				end
			end
		end
	end
	return self:doNextAction()
end

--wAction = {				--等待条件执行的技能/buff
	--这里存放的都是object
	--RoundStart = {},		--等待在回合开始时继续的action
	--UnitActive = {},		--等待在附着单位开始行动时继续的action
--},

__aCodeList["GoTo"] = function(self,_,sTagName)
	local d = self.data
	if d.action~=0 then
		local nF = 0
		local nA = 0
		for i = 1,#d.action do
			if d.action[i][1]==sTagName then
				if nF==0 then
					nF = i
				end
				if i>d.actionIndex and nA==0 then
					nA = i
				end
			end
			if nA~=0 and nA~=0 then
				break
			end
		end
		local gotoI = 0
		if nA>0 then
			gotoI = nA
		elseif nF>0 then
			local sus = 0
			for i = d.actionIndex,nF,1 do
				local v = d.action[i]
				if v and v[1]=="WaitingFor" then
					sus = 1
					break
				end
			end
			if sus==1 then
				gotoI = nF
			end
		end
		if gotoI>0 and d.actionIndex~=gotoI then
			local n = gotoI-1
			local iMin = math.min(d.actionIndex,n)
			local iMax = math.max(d.actionIndex,n)
			local lp = d.loopcount
			local lpI = d.loopindex
			for i = iMin,iMax,1 do
				local v = d.action[i]
				if v then
					if v[1]=="Loop" then
						local s = #lp+1
						lp[s] = 1
						lpI[s] = i
					elseif v[1]=="LoopEnd" then
						local s = #lp
						lp[s] = nil
						lpI[s] = nil
					end
				end
			end
			d.actionIndex = n
			return self:doNextAction()
		else
			return "release",1
		end
	end
	return self:doNextAction()
end

--循环执行内部的动作
--geyachao: 添加对count为字符串类型的支持
__aCodeList["Loop"] = function(self, _, count)
	local d = self.data
	local lp = d.loopcount
	local lpI = d.loopindex

	if (type(count) == "string") then
		count = d.tempValue[count] or 1
	end

	local n = __AnalyzeValueExpr(self,self.data.unit,count,"number")

	if type(count)~="number" and n<=0 then
		n = 1
	end
	

	
	local index = #lp+1
	lp[index] = type(n)=="number" and n or 1
	if lp[index]==0 then
		--对无限循环的特殊处理，必须判断中间存在"WaitingFor"，否则强制将次数设置为1
		local i = d.actionIndex+1
		local IsEnd = 1
		if d.action~=0 then
			local stack = 0
			while(d.action[i])do
				if d.action[i][1]=="Loop" then
					stack = stack + 1
				elseif d.action[i][1]=="LoopEnd" then
					stack = stack - 1
				elseif stack==0 and d.action[i][1]=="WaitingFor" then
					IsEnd = 0
					break
				end
				if stack<0 then
					break
				end
				i = i + 1
			end
		end
		if IsEnd==1 then
			lp[index] = 1
		end
	end
	lpI[index] = d.actionIndex
	return self:doNextAction()
end

--循环结束符号
__aCodeList["LoopEnd"] = function(self,_)
	local d = self.data
	local lp = d.loopcount
	if type(lp[#lp])=="number" then
		local IsEnd = 0
		if lp[#lp]>0 then
			lp[#lp] = lp[#lp] - 1
			if lp[#lp]<=0 then
				IsEnd = 1
			end
		elseif lp[#lp]<0 then
			IsEnd = 1
		end
		if IsEnd==1 then
			lp[#lp] = nil
		else
			local a = d.action
			if a~=0 then
				local lpI = d.loopindex
				d.actionIndex = lpI[#lpI] or d.actionIndex
			end
		end
	end
	return self:doNextAction()
end

--增加循环次数
__aCodeList["AddLoopCount"] = function(self,_,count,mxcount)
	local d = self.data
	local lp = d.loopcount
	if type(lp[#lp])=="number" and lp[#lp]>0 then
		local v = __AnalyzeValueExpr(self,d.unit,count,"number")
		if (mxcount or 0)~=0 then
			local mx = __AnalyzeValueExpr(self,d.unit,mxcount,"number")
			if lp[#lp]<mx then
				lp[#lp] = math.min(mx,lp[#lp] + v)
			end
		else
			lp[#lp] = lp[#lp] + v
		end
		if lp[#lp]<=0 then
			lp[#lp] = -1
		end
	end
	return self:doNextAction()
end


__aCodeList["RoundSortUnit"] = function(self,_,mode)
	local d = self.data
	local oRound = d.world:getround()
	oRound:sortunitall()
	return self:doNextAction()
end

__aCodeList["AddSkill"] = function(self,_,toWhat,id,lv,count,cd)
	--添加技能
	local d = self.data
	local u = d.unit
	local t = d.unit
	local v = value
	if toWhat=="unit" then
		t = d.unit
	elseif toWhat=="target" then
		t = d.target
	else--if toWhat=="smart" then
		if d.cast==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
			t = d.unit
		elseif d.target~=0 then
			t = d.target
		end
	end
	if t and t~=0 and t.data.IsDead~=1 then
		local nLv,nCount,nCd
		if lv~=nil then
			nLv = math.max(1,__AnalyzeValueExpr(self,u,lv,"number"))
		end
		if count~=nil then
			nCount = __AnalyzeValueExpr(self,u,count,"number")
		else
			local tabS = hVar.tab_skill[id]
			if tabS and tabS.count then
				nCount = tabS.count
			end
		end
		if cd~=nil then
			nCd = __AnalyzeValueExpr(self,u,cd,"number")
		end
		local s = t:getskill(id)
		if s then
			if nLv~=nil and nLv>0 then
				s[2] = math.max(s[2],nLv)
			end
			if nCd~=nil and nCd>0 then
				s[3] = math.max(s[3],nCd)
			end
			if nCount~=nil and nCount>0 and s[4]~=0 then
				s[4] = math.max(1,s[4]+nCount)
			end
		else
			t:addskill(id,nLv,nCount,nCd)
		end
	end
	return self:doNextAction()
end

--geyachao: 增加属性 {toWho, attr, value, IsShow}
__aCodeList["AddAttr"] = function(self, _, toWho, attr, value, IsShow)
	--添加属性
	--但是如果技能被非正常删除
	--会继续执行下面的语句把所有属性加完
	local d = self.data
	local u = d.unit
	local t = d.unit
	local v = value
	
	if toWho=="unit" then
		t = d.unit
	elseif toWho=="target" then
		t = d.target
	else--if toWho=="smart" then
		if (d.cast == hVar.OPERATE_TYPE.SKILL_IMMEDIATE) or (d.cast == hVar.OPERATE_TYPE.AUTO) then
			t = d.unit
		elseif d.target~=0 then
			t = d.target
		end
	end
	
	--geyachao: 如果value填的是表，那么读取该技能的等级
	if (type(value) == "table") then
		local skillId = self.data.skillId --本技能id
		local s = t:getskill(skillId)
		local skillLv = s[2] --本技能的当前等级
		local lvValue = value[skillLv] --当前等级的值
		local prelvValue = 0 --前一个等级的值
		if (skillLv > 1) then
			prelvValue = value[skillLv - 1]
		end
		
		v = lvValue - prelvValue --对应等级的附加
	end
	
	IsShow = IsShow or 1
	if (v ~= nil) then
		v = __AnalyzeValueExpr(self, u, v, "number")
	end
	if t~=0 and t.ID>0 and type(v)=="number" and v~=0 then
		if (attr == "MinAtk") or (attr == "atk_min") then
			t.attr.attack[4] = t.attr.attack[4] + v
		elseif (attr == "MaxAtk") or (attr == "atk_max") then
			t.attr.attack[5] = t.attr.attack[5] + v
		elseif (attr=="Atk") or (attr=="atk") then
			t.attr.attack[4] = t.attr.attack[4] + v
			t.attr.attack[5] = t.attr.attack[5] + v
			--print("         t.attr.attack=" .. tostring(t.attr.attack))
		elseif attr=="AtkRange" then
			t.attr.attack[3] = t.attr.attack[3] + v
		elseif attr=="NormalAttackId" then --geyachao: 修改普通攻击id
			t.attr.attack[1] = v
		elseif attr=="mxhp" then
			local addHp = v
			t.attr.mxhp = t.attr.mxhp + addHp
			t.attr.hp = t.attr.hp + addHp
			local oHero = t:gethero()
			if oHero and type(d.world)=="table" then
				local w,id,nHeal = d.world,d.skillId,addHp
				if w.data.IsQuickBattlefield~=1 then
					hGlobal.event:event("Event_UnitHealed",t,id,0,nHeal,0,u)
				end
				w:log({	--英雄最大生命提升
					key = "hero_mxhp",
					id = id,
					mxhp = addHp,
					unit = {
						objectID = u.ID,
						id = u.data.id,
						name = u.handle.name,
						indexOfTeam = u.data.indexOfTeam,
						owner = u.data.owner,
					},
					target = {
						objectID = t.ID,
						id = t.data.id,
						name = t.handle.name,
						indexOfTeam = t.data.indexOfTeam,
						owner = t.data.owner,
						hero_objectID = oHero.ID,
					},
				})
			end
		elseif attr=="mp" then
			t.attr[attr] = t.attr[attr] - hApi.UnitUseManaByCast(t,d.skillId,-1*v,"skill")
		elseif attr=="activity" then
			local oRound = d.world:getround()
			if oRound then
				oRound.data.NeedSort = 1
			end
			t.attr[attr] = t.attr[attr] + v
		elseif (attr == "hp") then --当前血量
			local hp = t.attr.hp --当前血量
			local hp_max = t:GetHpMax() --最大血量
			
			local new_hp = hp + v
			if (new_hp > hp_max) then
				new_hp = hp_max
			end
			
			--标记新的血量
			t.attr.hp = new_hp
		
			--更新英雄头像的血条
			local oHero = t:gethero()
			if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
				--oHero.heroUI["hpBar"]:setV(new_hp, hp_max)
				local curP = new_hp
				local maxP = hp_max
				local precent = math.ceil(curP / maxP * 100)
				--print("precent=", precent)
				
				--设置大菠萝的血条
				SetHeroHpBarPercent(oHero, curP, maxP, true)
			end
			
			--更新血条控件
			if t.chaUI["hpBar"] then
				if (hp_max <= 0) then
					hp_max = 1
				end
				t.chaUI["hpBar"]:setV(new_hp, hp_max)
				--print("oUnit.chaUI5()", new_hp, hp_max)
			end
			if t.chaUI["numberBar"] then
				if (hp_max <= 0) then
					hp_max = 1
				end
				t.chaUI["numberBar"]:setText(new_hp .. "/" .. hp_max)
			end
		elseif (attr == "atk_interval") then --基础攻击间隔（毫秒）
			t.attr["atk_interval_basic"] = t.attr["atk_interval_basic"] + v --增加属性值
		elseif (attr == "atk_speed") then --基础攻击速度（去百分号后的值）
			t.attr["atk_speed_basic"] = t.attr["atk_speed_basic"] + v --增加属性值
		elseif (attr == "move_speed") then --基础移动速度
			t.attr["move_speed_basic"] = t.attr["move_speed_basic"] + v --增加属性值
		elseif (attr == "atk_radius") then --基础攻击范围
			t.attr["atk_radius_basic"] = t.attr["atk_radius_basic"] + v --增加属性值
		elseif (attr == "atk_radius_min") then --基础攻击范围最小值
			t.attr["atk_radius_min_basic"] = t.attr["atk_radius_min_basic"] + v --增加属性值
		elseif (attr == "def_physic") then --基础物防
			t.attr["def_physic_basic"] = t.attr["def_physic_basic"] + v --增加属性值
		elseif (attr == "def_magic") then --基础法防
			t.attr["def_magic_basic"] = t.attr["def_magic_basic"] + v --增加属性值
		elseif (attr == "dodge_rate") then --基础闪避几率（去百分号后的值）
			t.attr["dodge_rate_basic"] = t.attr["dodge_rate_basic"] + v --增加属性值
		elseif (attr == "crit_rate") then --基础暴击几率（去百分号后的值）
			t.attr["crit_rate_basic"] = t.attr["crit_rate_basic"] + v --增加属性值
		elseif (attr == "crit_value") then --基础暴击倍数（支持小数）
			t.attr["crit_value_basic"] = t.attr["crit_value_basic"] + v --增加属性值
		elseif (attr == "kill_gold") then --基础击杀获得的金币
			t.attr["kill_gold_basic"] = t.attr["kill_gold_basic"] + v --增加属性值
		elseif (attr == "escape_punish") then --基础击杀获得的金币
			t.attr["escape_punish_basic"] = t.attr["escape_punish_basic"] + v --增加属性值
		elseif (attr == "hp_restore") then --基础回血速度（每秒）（支持小数）
			t.attr["hp_restore_basic"] = t.attr["hp_restore_basic"] + v --增加属性值
		elseif (attr == "rebirth_time") then --基础复活时间（毫秒）
			t.attr["rebirth_time_basic"] = t.attr["rebirth_time_basic"] + v --增加属性值
		elseif (attr == "suck_blood_rate") then --吸血率（去百分号后的值）
			t.attr["suck_blood_rate_basic"] = t.attr["suck_blood_rate_basic"] + v --增加属性值
		elseif (attr == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
			t.attr["active_skill_cd_delta_basic"] = t.attr["active_skill_cd_delta_basic"] + v --增加属性值
		elseif (attr == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
			t.attr["passive_skill_cd_delta_basic"] = t.attr["passive_skill_cd_delta_basic"] + v --增加属性值
		elseif (attr == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
			t.attr["active_skill_cd_delta_rate_basic"] = t.attr["active_skill_cd_delta_rate_basic"] + v --增加属性值
		elseif (attr == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
			t.attr["passive_skill_cd_delta_rate_basic"] = t.attr["passive_skill_cd_delta_rate_basic"] + v --增加属性值
		elseif (attr == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
			t.attr["AI_attribute_basic"] = t.attr["AI_attribute_basic"] + v --增加属性值
		elseif (attr == "rebirth_wudi_time") then --复活后无敌时间（毫秒）
			t.attr["rebirth_wudi_time_basic"] = t.attr["rebirth_wudi_time_basic"] + v --增加属性值
		elseif (attr == "basic_weapon_level") then --基础武器等级
			t.attr["basic_weapon_level_basic"] = t.attr["basic_weapon_level_basic"] + v --增加属性值
		elseif (attr == "basic_skill_level") then --基础技能等级
			t.attr["basic_skill_level_basic"] = t.attr["basic_skill_level_basic"] + v --增加属性值
		elseif (attr == "basic_skill_usecount") then --基础技能使用次数
			t.attr["basic_skill_usecount_basic"] = t.attr["basic_skill_usecount_basic"] + v --增加属性值
		elseif (attr == "atk_ice") then --冰攻击力
			t.attr["atk_ice_basic"] = t.attr["atk_ice_basic"] + v --增加属性值
		elseif (attr == "atk_thunder") then --雷攻击力
			t.attr["atk_thunder_basic"] = t.attr["atk_thunder_basic"] + v --增加属性值
		elseif (attr == "atk_fire") then --火攻击力
			t.attr["atk_fire_basic"] = t.attr["atk_fire_basic"] + v --增加属性值
		elseif (attr == "atk_poison") then --毒攻击力
			t.attr["atk_poison_basic"] = t.attr["atk_poison_basic"] + v --增加属性值
		elseif (attr == "atk_bullet") then --子弹攻击力
			t.attr["atk_bullet_basic"] = t.attr["atk_bullet_basic"] + v --增加属性值
		elseif (attr == "atk_bomb") then --爆炸攻击力
			t.attr["atk_bomb_basic"] = t.attr["atk_bomb_basic"] + v --增加属性值
		elseif (attr == "atk_chuanci") then --穿刺攻击力
			t.attr["atk_chuanci_basic"] = t.attr["atk_chuanci_basic"] + v --增加属性值
		elseif (attr == "def_ice") then --冰防御
			t.attr["def_ice_basic"] = t.attr["def_ice_basic"] + v --增加属性值
		elseif (attr == "def_thunder") then --雷防御
			t.attr["def_thunder_basic"] = t.attr["def_thunder_basic"] + v --增加属性值
		elseif (attr == "def_fire") then --火防御
			t.attr["def_fire_basic"] = t.attr["def_fire_basic"] + v --增加属性值
		elseif (attr == "def_poison") then --毒防御
			t.attr["def_poison_basic"] = t.attr["def_poison_basic"] + v --增加属性值
		elseif (attr == "def_bullet") then --子弹防御
			t.attr["def_bullet_basic"] = t.attr["def_bullet_basic"] + v --增加属性值
		elseif (attr == "def_bomb") then --爆炸防御
			t.attr["def_bomb_basic"] = t.attr["def_bomb_basic"] + v --增加属性值
		elseif (attr == "def_chuanci") then --穿刺防御
			t.attr["def_chuanci_basic"] = t.attr["def_chuanci_basic"] + v --增加属性值
		elseif (attr == "bullet_capacity") then --携弹数量
			t.attr["bullet_capacity_basic"] = t.attr["bullet_capacity_basic"] + v --增加属性值
		elseif (attr == "grenade_capacity") then --手雷数量
			t.attr["grenade_capacity_basic"] = t.attr["grenade_capacity_basic"] + v --增加属性值
		elseif (attr == "grenade_child") then --子母雷数量
			t.attr["grenade_child_basic"] = t.attr["grenade_child_basic"] + v --增加属性值
		elseif (attr == "grenade_fire") then --手雷爆炸火焰
			t.attr["grenade_fire_basic"] = t.attr["grenade_fire_basic"] + v --增加属性值
		elseif (attr == "grenade_dis") then --手雷投弹距离
			t.attr["grenade_dis_basic"] = t.attr["grenade_dis_basic"] + v --增加属性值
		elseif (attr == "grenade_cd") then --手雷冷却时间（单位：毫秒）
			t.attr["grenade_cd_basic"] = t.attr["grenade_cd_basic"] + v --增加属性值
		elseif (attr == "grenade_crit") then --手雷暴击
			t.attr["grenade_crit_basic"] = t.attr["grenade_crit_basic"] + v --增加属性值
		elseif (attr == "grenade_multiply") then --手雷冷却前使用次数
			t.attr["grenade_multiply_basic"] = t.attr["grenade_multiply_basic"] + v --增加属性值
		elseif (attr == "inertia") then --惯性
			t.attr["inertia_basic"] = t.attr["inertia_basic"] + v --增加属性值
		elseif (attr == "crystal_rate") then --水晶收益率（去百分号后的值）
			t.attr["crystal_rate_basic"] = t.attr["crystal_rate_basic"] + v --增加属性值
		elseif (attr == "melee_bounce") then --近战弹开
			t.attr["melee_bounce_basic"] = t.attr["melee_bounce_basic"] + v --增加属性值
		elseif (attr == "melee_fight") then --近战反击
			t.attr["melee_fight_basic"] = t.attr["melee_fight_basic"] + v --增加属性值
		elseif (attr == "melee_stone") then --近战碎石
			t.attr["melee_stone_basic"] = t.attr["melee_stone_basic"] + v --增加属性值
		elseif (attr == "pet_hp_restore") then --宠物回血
			t.attr["pet_hp_restore_basic"] = t.attr["pet_hp_restore_basic"] + v --增加属性值
		elseif (attr == "pet_hp") then --宠物生命
			t.attr["pet_hp_basic"] = t.attr["pet_hp_basic"] + v --增加属性值
		elseif (attr == "pet_atk") then --宠物攻击
			t.attr["pet_atk_basic"] = t.attr["pet_atk_basic"] + v --增加属性值
		elseif (attr == "pet_atk_speed") then --宠物攻速
			t.attr["pet_atk_speed"] = t.attr["pet_atk_speed"] + v --增加属性值
		elseif (attr == "pet_capacity") then --宠物携带数量
			t.attr["pet_capacity_basic"] = t.attr["pet_capacity_basic"] + v --增加属性值
		elseif (attr == "trap_ground") then --陷阱时间（单位：毫秒）
			t.attr["trap_ground_basic"] = t.attr["trap_ground_basic"] + v --增加属性值
		elseif (attr == "trap_groundcd") then --陷阱时间（单位：毫秒）
			t.attr["trap_groundcd_basic"] = t.attr["trap_groundcd_basic"] + v --增加属性值
		elseif (attr == "trap_groundenemy") then --陷阱时间（单位：毫秒）
			t.attr["trap_groundenemy_basic"] = t.attr["trap_groundenemy_basic"] + v --增加属性值
		elseif (attr == "trap_fly") then --天网时间（单位：毫秒）
			t.attr["trap_fly_basic"] = t.attr["trap_fly_basic"] + v --增加属性值
		elseif (attr == "trap_flycd") then --天网施法间隔（单位：毫秒）
			t.attr["trap_flycd_basic"] = t.attr["trap_flycd_basic"] + v --增加属性值
		elseif (attr == "trap_flyenemy") then --天网困敌时间（单位：毫秒）
			t.attr["trap_flyenemy_basic"] = t.attr["trap_flyenemy_basic"] + v --增加属性值
		elseif (attr == "puzzle") then --迷惑几率（去百分号后的值）
			t.attr["puzzle_basic"] = t.attr["puzzle_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_shoot") then --射击暴击
			t.attr["weapon_crit_shoot_basic"] = t.attr["weapon_crit_shoot_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_frozen") then --冰冻暴击
			t.attr["weapon_crit_frozen_basic"] = t.attr["weapon_crit_frozen_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_fire") then --火焰暴击
			t.attr["weapon_crit_fire_basic"] = t.attr["weapon_crit_fire_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_equip") then --装备暴击
			t.attr["weapon_crit_equip_basic"] = t.attr["weapon_crit_equip_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_hit") then --击退暴击
			t.attr["weapon_crit_hit_basic"] = t.attr["weapon_crit_hit_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_blow") then --吹风暴击
			t.attr["weapon_crit_blow_basic"] = t.attr["weapon_crit_blow_basic"] + v --增加属性值
		elseif (attr == "weapon_crit_poison") then --毒液暴击
			t.attr["weapon_crit_poison_basic"] = t.attr["weapon_crit_poison_basic"] + v --增加属性值
		elseif (type(t.attr[attr]) == "number") then --其他情况
			t.attr[attr] = t.attr[attr] + v --增加属性值
		end
		
		if IsShow==1 and hGlobal.LocalPlayer:getfocusworld()==d.world then
			hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,attr,v)
		end
	end
	return self:doNextAction()
end

--geyachao: 游戏中加金币，并在单位头上冒字
__aCodeList["AddGold_TD"] = function(self, _, goldNum, maxValue)
	local d = self.data
	local u = d.unit
	
	--geyachao: 支持传入参数
	if (type(goldNum) == "string") then
		goldNum = self.data.tempValue[goldNum]
	end
	
	--geyachao: 支持传入参数
	if (type(maxValue) == "string") then
		maxValue = self.data.tempValue[maxValue]
	end
	
	--最大金钱不能小于0
	if maxValue and (maxValue <= 0) then
		maxValue = nil
	end
	
	--游戏未开始，不能加钱
	local world = self.data.world
	if world then
		local mapInfo = world.data.tdMapInfo
		if mapInfo then
			--第一波及以后才能加钱
			local waveNow = mapInfo.wave
			if (waveNow >= 1) then
				----加钱
				--local w = hGlobal.WORLD.LastWorldMap
				--local mapInfo = w.data.tdMapInfo
				
				--mapInfo.gold = (mapInfo.gold or 0) + goldNum
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, goldNum)
				
				----冒字跳金币动画
				--hApi.ShowGoldBubble(u, goldNum, false)
				
				----更新界面
				--hGlobal.event:event("Event_TdGoldCostRefresh")
				
				--local w = hGlobal.WORLD.LastWorldMap
				--角色存在，没被复用
				--print("u=", u.data.name)
				if u and (u ~= 0) and (u:getworldC() == d.unit_worldC) then
					--不是召唤、分身单位
					--print("is_summon=", u.data.is_summon)
					--print("is_fenshen=", u.data.is_fenshen)
					if (u.data.id == 17010) or (u.data.id == 17011) or (u.data.id == 17012) or (u.data.id == 12239) or ((u.data.is_summon ~= 1) and (u.data.is_fenshen ~= 1)) then
						local owner = u:getowner()
						--print("owner=", owner)
						if owner then
							--加钱
							--resourceType,resourceValue,getMode,fromUnit,byUnit,maxValue)
							owner:addresource(hVar.RESOURCE_TYPE.GOLD, goldNum, nil, nil, nil, maxValue)
							
							--本地冒字得钱
							if (owner == world:GetPlayerMe()) then
								--冒字跳金币动画
								hApi.ShowGoldBubble(u, goldNum, false)
								--更新界面
								hGlobal.event:event("Event_TdGoldCostRefresh")
							end
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

__aCodeList["AddBuffState"] = function(self, _, mode, attr, FailGoTo)
	local d = self.data
	--特殊状态
	if type(attr)=="table" then
		local k = attr[1]
		local v = attr[2]
		attr = k
		if k=="shield" then
			d.tempValue["@exhp"] = __AnalyzeValueExpr(self,d.unit,v,"number")
		elseif k=="flee" then
			d.tempValue["@flee"] = __AnalyzeValueExpr(self,d.unit,v,"number")
		end
	end
	if self:addbuffstate(mode,attr)~=hVar.RESULT_SUCESS then
		if type(FailGoTo)=="string" then
			return __aCodeList["GoTo"](self,"GoTo",FailGoTo)
		end
	end
	return self:doNextAction()
end

__aCodeList["RemoveBuffState"] = function(self,_,mode,attr)
	self:removebuffstate(mode,attr)
	return self:doNextAction()
end

local __ShowIconAttr = {
	["cooldown"] = 1,
	["duration"] = 1,
}
__aCodeList["ShowAddAttr"] = function(self,_,toWhat,attr,value,ex)
	--显示添加属性（仅显示用）
	local d = self.data
	local u = d.unit
	local t = d.unit
	local v = value
	if d.world.data.IsQuickBattlefield~=1 then
		local tPos
		if toWhat=="unit" then
			t = d.unit
		elseif toWhat=="target" then
			t = d.target
		elseif toWhat=="ground" then
			t = d.unit
			tPos = {d.worldX,d.worldY}
		else
			if d.cast==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
				t = d.unit
			elseif d.target~=0 then
				t = d.target
			end
		end
		if v~=nil then
			v = __AnalyzeValueExpr(self,u,v,"number")
		end
		if t~=0 and t.ID>0 and hGlobal.LocalPlayer:getfocusworld()==d.world then
			if __ShowIconAttr[attr]==1 then
				if v and hVar.tab_skill[v] then
					ex = __AnalyzeValueExpr(self,u,ex,"number")
					if ex~=0 then
						local sIcon = hVar.tab_skill[v].icon or "MODEL:Default"
						hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,attr,ex,nil,sIcon,tPos)
					end
				end
			else
				if type(v)=="number" then
					if v~=0 then
						hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,attr,v,nil,sIcon,tPos)
					end
				else
					hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,attr,nil,nil,sIcon,tPos)
				end
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["AddAttrPec"] = function(self,_,toWhat,attr,value,IsShow)
	--添加属性(百分比)
	--但是如果技能被非正常删除
	--会继续执行下面的语句把所有属性加完
	local d = self.data
	local u = d.unit
	local t = d.unit
	local v = value
	if toWhat=="unit" then
		t = d.unit
	elseif toWhat=="target" then
		t = d.target
	else--if toWhat=="smart" then
		if d.cast==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
			t = d.unit
		elseif d.target~=0 then
			t = d.target
		end
	end
	IsShow = IsShow or 1
	if v~=nil then
		v = hApi.getint(__AnalyzeValueExpr(self,u,v,"number"))
	end
	if t~=0 and t.ID>0 and type(v)=="number" and v~=0 then
		if attr=="MinAtk" then
			t.attr.attack[4] = t.attr.attack[4] + hApi.floor(t.attr.attack[4]*v/100)
		elseif attr=="MaxAtk" then
			t.attr.attack[5] = t.attr.attac1k[5] + hApi.floor(t.attr.attack[5]*v/100)
		elseif attr=="Atk" then
			t.attr.attack[4] = t.attr.attack[4] + hApi.floor(t.attr.attack[4]*v/100)
			t.attr.attack[5] = t.attr.attack[5] + hApi.floor(t.attr.attack[5]*v/100)
		elseif attr=="AtkRange" then
			t.attr.attack[3] = t.attr.attack[3] + hApi.floor(t.attr.attack[3]*v/100)
		elseif attr=="mxhp" then
			local addHp = hApi.floor(t.attr.__mxhp*v/100)
			t.attr.hp = t.attr.hp + addHp
			t.attr.mxhp = t.attr.mxhp + addHp
			local oHero = t:gethero()
			if oHero and type(d.world)=="table" then
				local w,id,nHeal = d.world,d.skillId,addHp
				if w.data.IsQuickBattlefield~=1 then
					hGlobal.event:event("Event_UnitHealed",t,id,0,nHeal,0,u)
				end
				w:log({	--英雄最大生命提升
					key = "hero_mxhp",
					id = id,
					mxhp = addHp,
					unit = {
						objectID = u.ID,
						id = u.data.id,
						name = u.handle.name,
						indexOfTeam = u.data.indexOfTeam,
						owner = u.data.owner,
					},
					target = {
						objectID = t.ID,
						id = t.data.id,
						name = t.handle.name,
						indexOfTeam = t.data.indexOfTeam,
						owner = t.data.owner,
						hero_objectID = oHero.ID,
					},
				})
			end
		elseif type(t.attr[attr])=="number" then
			if t.attr[attr]>0 then
				if attr=="activity" then
					local oRound = d.world:getround()
					if oRound then
						oRound.data.NeedSort = 1
					end
				end
				t.attr[attr] = t.attr[attr] + hApi.floor(t.attr[attr]*v/100)
			end
		end
		if IsShow==1 and hGlobal.LocalPlayer:getfocusworld()==t:getworld() then
			hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,attr,v,v.."%")
		end
	end
	return self:doNextAction()
end

--{id,rMin,rMax,dMin,dMax}
__aCodeList["SetAttr"] = function(self,_,mode,attr,value,valueEx)
	--设置属性
	--和上面的不一样，管杀不管埋
	local d = self.data
	local u = d.unit
	local t = d.unit
	local v = value
	if mode=="target" then
		t = d.target
	else
		t = d.unit
	end
	if t~=0 and t.ID>0 and v~=nil then
		v = __AnalyzeValueExpr(self,u,v,"number")
	end
	if t~=0 and t.ID>0 and type(v)=="number" then
		if attr=="BasicAttackID" then
			--基础攻击技能
			if v==-1 then
				if t.attr.BasicAttackID~=0 then
					t.attr.attack[1] = t.attr.BasicAttackID
				else
					local tabU = hVar.tab_unit[t.data.id]
					if tabU and type(tabU.attr)=="table" and type(tabU.attr.attack)=="table" then
						t.attr.attack[1] = tabU.attr.attack[1] or 28
					else
						t.attr.attack[1] = 0
					end
				end
			elseif hVar.tab_skill[v] then
				if d.CastOrder==hVar.ORDER_TYPE.SYSTEM_FIRST_ROUND then
					t.attr.BasicAttackID = v
				end
				t.attr.attack[1] = v
			end
		elseif attr=="attackID" or attr=="counterID" then
			if valueEx then
				if t.attr[attr]==__AnalyzeValueExpr(self,u,valueEx,"number") then
					t.attr[attr] = v
				end
			else
				t.attr[attr] = v
			end
		elseif attr=="BeforeAttackID" then
			local tabA = t.attr.BeforeAttackID
			if type(tabA)=="table" then
				local id = __AnalyzeValueExpr(self,u,value,"number")
				local ex = 0
				if valueEx==-1 then
					for i = 1,#tabA do
						if type(tabA[i])=="table" and tabA[i][1]==id then
							tabA[i] = 0
						end
					end
					hApi.CompressNumTab(tabA)
				else
					if valueEx~=nil then
						ex = __AnalyzeValueExpr(self,u,valueEx,"number")
					end
					for i = 1,#tabA do
						if type(tabA[i])=="table" and tabA[i][1]==id then
							id = 0
							break
						end
					end
					if id~=0 then
						local tabS = hVar.tab_skill[id]
						if tabS then
							local nInsertI
							for i = 1,#tabA do
								if type(tabA[i])=="table" then
									local tabSc = hVar.tab_skill[tabA[i][1]]
									if tabSc and (tabS.cast_sort or 5)>(tabSc.cast_sort or 5) then
										nInsertI = i
										break
									end
								end
							end
							if nInsertI then
								for i = #tabA,nInsertI,-1 do
									tabA[i+1] = tabA[i]
								end
								tabA[nInsertI] = {id,ex}
							else
								tabA[#tabA+1] = {id,ex}
							end
						end
					end
				end
			end
		elseif (attr == "ReplaceAttackID") then --直接替换普通攻击
			t.attr.attack[1] = v
		elseif attr=="passive" then
			--这个值不能被改变！
		elseif type(t.attr[attr])=="number" then
			t.attr[attr] = v
		end
	end
	return self:doNextAction()
end

__aCodeList["SetAttackRange"] = function(self,_,mode,aMin,aMax)
	local d = self.data
	local u = d.unit
	if mode=="unit" then
		u = d.unit
	else
		u = d.target
	end
	if u and u~=0 then
		if aMin then
			u.attr.attack[2] = __AnalyzeValueExpr(self,u,aMin,"number")
		end
		if aMax then
			u.attr.attack[3] = __AnalyzeValueExpr(self,u,aMax,"number")
		end
	end
	return self:doNextAction()
end

--等待直到某个条件被触发
__aCodeList["WaitingFor"] = function(self,_,case,param)
	local d = self.data
	local oRound = d.world:getround()
	if oRound and type(case)=="string" and (case=="forever" or type(oRound.data.wAction[case])=="table") then
		d.released = 1		--脱离施放者
		d.waitingFor = case
		local tActions = oRound.data.wAction[case]
		if tActions then
			local val = param or 0
			if case=="UnitActive" then
				local nBindID = self.data.bindU[1]
				if nBindID~=0 then
				else
					_DEBUG_MSG("[LOGIC ERROR 2]WaitingFor Skill("..d.skillId..") Is Not BUFF")
				end
			elseif case=="UnitHpLower" then
				val = __AnalyzeValueExpr(self,d.unit,param,"number")
				local nBindID = self.data.bindU[1]
				if nBindID~=0 then
					if tActions.count then
						tActions.count[nBindID] = (tActions.count[nBindID] or 0) + 1
					end
				else
					_DEBUG_MSG("[LOGIC ERROR 2]WaitingFor Skill("..d.skillId..") Is Not BUFF")
				end
			elseif case=="RoundStart" or case=="RoundEnd" then
				if d.action~=0 and d.action[1] then
					--毒素BUFF,持续时间可被延长
					if d.action[1][1]=="#POISON" then
						if d.IsBuff~=0 and d.IsBuff~=-1 and d.bindU~=0 then
							local oTargetX = hClass.unit:find(d.bindU[1])
							if oTargetX and oTargetX.__ID==d.bindU[2] and oTargetX.attr.poisoned>0 then
								local nCount = (d.loopcount[#d.loopcount] or 0)
								if nCount>0 then
									d.loopcount[#d.loopcount] = nCount + 1
								end
							end
						end
					end
				end
			end
			tActions[#tActions+1] = {self.ID,self.__ID,val}
		end
		return "wait",0
	else
		return self:doNextAction()
	end
end

__aCodeList["Teleport"] = function(self,_,mode)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else
		t = d.target
	end
	if t~=0 and t.ID~=0 and t.data.IsDead~=1 then
		t:setgrid(d.gridX,d.gridY,hVar.OPERATE_TYPE.UNIT_TELEPORT)
	end
	return self:doNextAction()
end

local __TEMP__IsBuff = {}
local __CODE__CastSkill = function(self, oUnit, nSkillId, nSkillLv, nManaCost, nPower, worldX, worldY, valueToCopy)
	local d = self.data
	local tabS = hVar.tab_skill[nSkillId]
	if tabS==nil then
		_DEBUG_MSG("skill["..tostring(d.skillId).."]CastSkill技能ID错误"..tostring(nSkillId))
		return self:doNextAction()
	end
	--判断该技能是否buff
	if __TEMP__IsBuff[nSkillId]==nil then
		__TEMP__IsBuff[nSkillId] = 0
		if type(tabS.action)=="table" then
			for i = 1,#tabS.action do
				local v = tabS.action[i]
				if (v[1]=="BecomeBuff") and ((v[2]=="target") or (v[2]=="unit")) and (string.sub(v[3],1,5)=="BUFF_") then
					__TEMP__IsBuff[nSkillId] = 1
					break
				end
			end
		end
	end
	--如果被闪避，那么该技能产生的buff将不会生效
	if __TEMP__IsBuff[nSkillId]==1 and d.IsFlee==1 and d.target~=0 and d.target.attr.fleecount>0 then
		return self:doNextAction()
	end
	local tCastParam = {
		castId = d.castId,
		targetC = d.targetC,
		IsAttack = d.IsAttack,
		IsCast = d.IsCast,
		IsFlee = d.IsFlee,
		level = nSkillLv, --geyahcao: 技能等级
	}
	if tabS.target_mode==1 and d.target~=0 then
		tCastParam.targetC = d.target
	end
	if worldX and worldY and not(worldX==0 and worldY==0) then
		tCastParam.worldX = __AnalyzeValueExpr(self,oUnit,worldX,"number")
		tCastParam.worldY = __AnalyzeValueExpr(self,oUnit,worldY,"number")
	end
	if valueToCopy and type(valueToCopy)=="table" then
		local tempValue = {}
		for i = 1,#valueToCopy do
			local key = valueToCopy[i]
			tempValue[key] = d.tempValue[key]
		end
		tCastParam.tempValue = tempValue
	end
	if d.IsShowPlus>0 then
		tCastParam.IsShowPlus = -1
	end
	
	--worldX, worldY = hApi.chaGetPos(d.target.handle)
	
	--local gridX, gridY = world:xy2grid(worldX, worldY)
	
	--print("     hApi.CastSkill", nSkillId, d.gridX,d.gridY)
	
	hApi.CastSkill(oUnit,nSkillId,nManaCost,nPower,d.target,d.gridX,d.gridY,tCastParam)
	--print("hApi.CastSkill(", oUnit.data.name,nSkillId,nManaCost,nPower,d.target and d.target.data.name,d.gridX,d.gridY,tCastParam,")")
	
	return self:doNextAction()
end

--geyachao: 新加流程, 释放buff技能
local __CODE__CastBuff = function(self, oUnit, oTarget, nSkillId, nManaCost, nPower, nBuffLv, nBuffTime)
	--print("__CODE__CastBuff", oUnit.data.name, oTarget.data.name)
	local d = self.data
	local tabS = hVar.tab_skill[nSkillId]
	if tabS==nil then
		_DEBUG_MSG("skill["..tostring(d.skillId).."]CastBuff技能ID错误" .. tostring(nSkillId))
		return self:doNextAction()
	end
	
	if (not nBuffLv) then
		_DEBUG_MSG("CastBuff()错误！未填写buff等级！")
		return self:doNextAction()
	end
	
	--判断该技能是否buff
	local buff_key = nil --该buff的标识
	if __TEMP__IsBuff[nSkillId]==nil then
		__TEMP__IsBuff[nSkillId] = 0
		if type(tabS.action)=="table" then
			for i = 1,#tabS.action do
				local v = tabS.action[i]
				if (v[1]=="BecomeBuff") and ((v[2]=="target") or (v[2]=="unit")) and (string.sub(v[3],1,5)=="BUFF_") then
					__TEMP__IsBuff[nSkillId] = 1
					buff_key = v[3] --该buff的标识
					break
				end
			end
		end
	else
		if type(tabS.action)=="table" then
			for i = 1,#tabS.action do
				local v = tabS.action[i]
				if (v[1]=="BecomeBuff") and ((v[2]=="target") or (v[2]=="unit")) and (string.sub(v[3],1,5)=="BUFF_") then
					buff_key = v[3] --该buff的标识
					break
				end
			end
		end
	end
	
	--如果被闪避，那么该技能产生的buff将不会生效
	if __TEMP__IsBuff[nSkillId]==1 and d.IsFlee==1 and oTarget ~= 0 and (oTarget.attr.fleecount > 0) then
		return self:doNextAction()
	end
	
	--解析该buff的存在时间
	local maxtime = math.huge --最大生存时间
	for i = 1, #tabS.action, 1 do
		local v = tabS.action[i]
		if (v[1] == "LastTime")then --持续时间标识
			maxtime = v[2]
			--print("持续时间标识", d.maxtime)
			break
		end
	end
	
	--buff持续时间优先是传入的值，如果没有填，那么读表中定义的值
	nBuffTime = nBuffTime or maxtime
	if (type(nBuffTime) == "string") then
		nBuffTime = self.data.tempValue[nBuffTime]
	end
	
	--geyachao: 如果填写的为负数，说明是永久的buff
	if (nBuffTime < 0) then
		nBuffTime = 3600 * 24 * 365 * 1000 --1000年
	end
	
	--geyachao: 添加0秒的buff，不处理
	if (nBuffTime == 0) then
		_DEBUG_MSG("CastBuff()错误！nBuffTime=0！")
		return self:doNextAction()
	end

	--解析该buff的tick和tick执行的技能id、技能等级
	local buffTag = 0 --记录buff的标识符(例如: "#ICE")
	local buffTick = -1
	local buffTickDmg = 0
	local buffTickDmgMode = 0
	local buffTickSkillId = 0
	local buffTickSkillId_T = 0
	local buffTickLv = 1
	
	local v1 = tabS.action[1]
	if (string.sub(v1[1], 1, 1) == "#") then
		buffTag = v1[1] --记录buff的标识符(例如: "#ICE")
	end
	
	for i = 1, #tabS.action, 1 do
		local v = tabS.action[i]
		if (v[1] == "BuffEvent_OnBuffTick")then --定义的buff tick事件
			buffTick = v[2] --geyachao: 记录bufftick触发的间隔
			buffTickDmg = v[3] --geyachao: 记录bufftick触发的伤害
			buffTickDmgMode = v[4] --geyachao: 记录bufftick触发的伤害类型
			buffTickSkillId = v[5] --geyachao: 记录bufftick触发的释放技能
			buffTickLv = v[6] --geyachao: 记录bufftick触发的释放技能等级
			
			break
		end
		
		if (v[1] == "BuffEvent_OnBuffTickT")then --定义的buff tick事件
			buffTick = v[2] --geyachao: 记录bufftick触发的间隔
			buffTickDmg = v[3] --geyachao: 记录bufftick触发的伤害
			buffTickDmgMode = v[4] --geyachao: 记录bufftick触发的伤害类型
			buffTickSkillId_T = v[5] --geyachao: 记录bufftick触发的释放技能
			buffTickLv = v[6] --geyachao: 记录bufftick触发的释放技能等级
			
			break
		end
	end
	
	--解析该buff被移除时执行的技能
	local buffRemoveSkillId = 0
	local buffRemoveLv = 1
	for i = 1, #tabS.action, 1 do
		local v = tabS.action[i]
		if (v[1] == "BuffEvent_OnBuffRemove")then --定义的buff移除时触发的事件
			buffRemoveSkillId = v[2] --geyachao: 记录bufftick移除时释放技能
			buffRemoveLv = v[3] --geyachao: 记录bufftick移除时释放技能等级
			
			break
		end
	end
	
	--解析buff添加的特殊状态“眩晕、变大、无敌，等
	local buffState_Stun = 0 --是否眩晕
	local buffState_BianDa = 0 --是否变大
	local buffState_ImmuePhysic = 0 --是否物理免疫
	local buffState_ImmueMagic = 0 --是否法术免疫
	local buffState_ImmueWuDi = 0 --是否无敌
	local buffState_ImmueDamage = 0 --是否伤害免疫
	local buffState_ImmueDamageIce = 0 --是否冰伤害免疫
	local buffState_ImmueDamageThunder = 0 --是否雷伤害免疫
	local buffState_ImmueDamageFire = 0 --是否火伤害免疫
	local buffState_ImmueDamagePoison = 0 --是否毒伤害免疫
	local buffState_ImmueDamageBullet = 0 --是否子弹伤害免疫
	local buffState_ImmueDamageBoom = 0 --是否爆炸伤害免疫
	local buffState_ImmueDamageChuanci = 0 --是否穿刺伤害免疫
	local buffState_ImmueControl = 0 --是否免控
	local buffState_ImmueDebuff = 0 --是否免疫负面属性
	local buffState_SufferChaos = 0 --是否混乱
	local buffState_SufferBlow = 0 --是否吹风
	local buffState_SufferChuanCi = 0 --是否穿刺
	local buffState_SufferSleep = 0 --是否沉睡
	local buffState_SufferChenmo = 0 --是否沉默
	local buffState_SufferJinYan = 0 --是否禁言（不能普通攻击）
	local buffState_Ground = 0 --是否变地面单位
	local buffState_SufferTouMing = 0 --是否透明（不能碰撞）
	for i = 1, #tabS.action, 1 do
		local v = tabS.action[i]
		if (v[1] == "BuffAddState") then --持续时间标识
			if (v[2] == "STUN") then --眩晕状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_Stun = 1 --眩晕
				end
			end
			if (v[2] == "BIG") then --变大状态
				buffState_BianDa = 1 --变大
			end
			if (v[2] == "WUMIAN") then --物理免疫状态
				buffState_ImmuePhysic = 1 --物理免疫
			end
			if (v[2] == "MOMIAN") then --法术免疫状态
				buffState_ImmueMagic = 1 --法术免疫
			end
			if (v[2] == "WUDI") then --无敌状态
				buffState_ImmueWuDi = 1 --无敌
			end
			if (v[2] == "IMMUEDAMAGE") then --免疫伤害状态
				buffState_ImmueDamage = 1 --免疫伤害
			end
			if (v[2] == "IMMUEDAMAGE_ICE") then --免疫冰伤害状态
				buffState_ImmueDamageIce = 1 --免疫冰伤害
			end
			if (v[2] == "IMMUEDAMAGE_THUNDER") then --免疫雷伤害状态
				buffState_ImmueDamageThunder = 1 --免疫雷伤害
			end
			if (v[2] == "IMMUEDAMAGE_FIRE") then --免疫火伤害状态
				buffState_ImmueDamageFire = 1 --免疫火伤害
				--print("免疫火伤害", "IMMUEDAMAGE_FIRE")
			end
			if (v[2] == "IMMUEDAMAGE_PIOSON") then --免疫毒伤害状态
				buffState_ImmueDamagePoison = 1 --免疫毒伤害
			end
			if (v[2] == "IMMUEDAMAGE_BULLET") then --免疫子弹伤害状态
				buffState_ImmueDamageBullet = 1 --免疫子弹伤害
			end
			if (v[2] == "IMMUEDAMAGE_BOOB") then --免疫爆炸伤害状态
				buffState_ImmueDamageBoom = 1 --免疫爆炸伤害
			end
			if (v[2] == "IMMUEDAMAGE_CHUANCI") then --免疫穿刺伤害状态
				buffState_ImmueDamageChuanci = 1 --免疫穿刺伤害
			end
			if (v[2] == "MIANKONG") then --免控状态
				buffState_ImmueControl = 1 --免控
			end
			if (v[2] == "IMMUEDEBUFF") then --免疫负面属性状态
				buffState_ImmueDebuff = 1 --免疫负面属性
			end
			if (v[2] == "CHAOS") then --混乱状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferChaos = 1 --混乱
				end
			end
			if (v[2] == "BLOW") then --吹风状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferBlow = 1 --吹风
				end
			end
			if (v[2] == "CHUANCI") then --穿刺状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferChuanCi = 1 --穿刺
				end
			end
			if (v[2] == "SLEEP") then --沉睡状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferSleep = 1 --沉睡
				end
			end
			if (v[2] == "CHENMO") then --沉默状态
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferChenmo = 1 --沉默
				end
			end
			if (v[2] == "JINYAN") then --禁言状态（不能普通攻击）
				if (oTarget.attr.immue_wudi_stack <= 0) and (oTarget.attr.immue_control_stack <= 0) then --目标不是无敌、免控状态
					buffState_SufferJinYan = 1 --禁言（不能普通攻击）
				end
			end
			if (v[2] == "GROUND") then --变地面单位
				buffState_Ground = 1 --是否变地面单位
			end
			if (v[2] == "TOUMING") then --透明状态（不能碰撞）
				buffState_SufferTouMing = 1 --透明（不能碰撞）
			end
		end
	end
	
	--[[
	if (not maxtime) then
		_DEBUG_MSG("CastBuff()错误！未填写LastTime字段！")
		return self:doNextAction()
	end
	--]]
	
	--检测目标身上是否已有此buff
	local oBuff = oTarget:getbuff(buff_key)
	if oBuff then --目标身上已有此buff
		--print("目标身上已有此buff!!!", oTarget.data.name)
		local oldLv = oBuff.data.level --该buff之前的等级
		
		if (nBuffLv > oldLv) then --更高等级的buff，需要重置效果
			--删除旧的buff
			oBuff:del_buff()
			--print("更高等级的buff，删除旧的buff")
		else --相同等级的buff
			--重置此buff的生存时间，不重复添加此buff
			oBuff.data.stack = oBuff.data.stack + 1 --堆叠层数加1
			oBuff.data.tempValue["@stack"] = oBuff.data.tempValue["@stack"] + 1 --堆叠层数加1（缓存）
			oBuff.data.maxtime = nBuffTime + oBuff.data.past --最大生存时间附加当前已经经过的时间
			--print("重置此buff的生存时间，不重复添加此buff", oBuff.data.stack)
			return self:doNextAction()
		end
	end
	
	--print("添加新buff")
	--如果该技能不是buff，那么不能释放本次buff技能
	if (__TEMP__IsBuff[nSkillId] ~= 1) then
		return self:doNextAction()
	end
	
	local tCastParam =
	{
		castId = d.castId,
		targetC = d.targetC,
		IsAttack = d.IsAttack,
		IsCast = d.IsCast,
		IsFlee = d.IsFlee,
		maxtime = nBuffTime, --geyachao: buff最大生存时间
		buffTag = buffTag, --记录buff的标识符(例如: "#ICE")
		buffTick = buffTick, --geyachao: buff的tick间隔
		buffTickDmg = buffTickDmg, --geyachao: buff的tick释放的伤害
		buffTickDmgMode = buffTickDmgMode, --geyachao: buff的tick释放的伤害类型
		buffTickSkillId = buffTickSkillId, --geyachao: buff的tick释放的技能
		buffTickSkillId_T = buffTickSkillId_T, --geyachao: buff的目标tick释放的技能
		buffTickLv = buffTickLv, --geyachao: buff的tick释放的技能等级
		buffRemoveSkillId = buffRemoveSkillId, --geyachao: buff移除时释放的技能
		buffRemoveLv = buffRemoveLv, --geyachao: buf移除时释放的技能等级
		level = nBuffLv,	--geyachao: buff等级
		buffState_Stun = buffState_Stun, --geyachao: buff是否眩晕
		buffState_BianDa = buffState_BianDa, --geyachao: buff是否变大
		buffState_ImmuePhysic = buffState_ImmuePhysic, --geyachao: buff是否物理免疫
		buffState_ImmueMagic = buffState_ImmueMagic, --geyachao: buff是否法术免疫
		buffState_ImmueWuDi = buffState_ImmueWuDi, --geyachao: buff是否无敌
		buffState_ImmueDamage = buffState_ImmueDamage, --geyachao: buff是否免疫伤害
		buffState_ImmueDamageIce = buffState_ImmueDamageIce, --geyachao: buff是否免疫冰伤害
		buffState_ImmueDamageThunder = buffState_ImmueDamageThunder, --geyachao: buff是否免疫雷伤害
		buffState_ImmueDamageFire = buffState_ImmueDamageFire, --geyachao: buff是否免疫火伤害
		buffState_ImmueDamagePoison = buffState_ImmueDamagePoison, --geyachao: buff是否免疫毒伤害
		buffState_ImmueDamageBullet = buffState_ImmueDamageBullet, --geyachao: buff是否免疫子弹伤害
		buffState_ImmueDamageBoom = buffState_ImmueDamageBoom, --geyachao: buff是否免疫爆炸伤害
		buffState_ImmueDamageChuanci = buffState_ImmueDamageChuanci, --geyachao: buff是否免疫穿刺伤害
		buffState_ImmueControl = buffState_ImmueControl, --geyachao: buff是否免控
		buffState_ImmueDebuff = buffState_ImmueDebuff, --geyachao: buff是否免疫负面属性
		buffState_SufferChaos = buffState_SufferChaos, --geyachao: buff是否混乱
		buffState_SufferBlow = buffState_SufferBlow, --geyachao: buff是否吹风
		buffState_SufferChuanCi = buffState_SufferChuanCi, --geyachao: buff是否穿刺
		buffState_SufferSleep = buffState_SufferSleep, --geyachao: buff是否沉睡
		buffState_SufferChenmo = buffState_SufferChenmo, --geyachao: buff是否沉默
		buffState_SufferJinYan = buffState_SufferJinYan, --geyachao: buff是否禁言（不能普通攻击）
		buffState_Ground = buffState_Ground, --geyachao: buff是否变地面单位
		buffState_SufferTouMing = buffState_SufferTouMing, --geyachao: buff是否透明（不能碰撞）
	}
	
	--print("buffRemoveLv=", buffRemoveLv)
	if tabS.target_mode==1 and oTarget ~=0 then
		tCastParam.targetC = oTarget
	end
	
	if d.IsShowPlus>0 then
		tCastParam.IsShowPlus = -1
	end
	
	--print("hApi.CastSkill", oUnit.data.name, oTarget.data.name, oTarget.data.id, nSkillId)
	hApi.CastSkill(oUnit, nSkillId, nManaCost, nPower, oTarget, d.gridX, d.gridY, tCastParam)
	return self:doNextAction()
end

__aCodeList["CastSkill"] = function(self,_,nSkillId, nSkillLv, worldX,worldY,valueToCopy)
	local d = self.data
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		--print("不是同一个目标了", nSkillId)
		return "release", 1
	end
	
	if (type(nSkillLv) == "string") then
		nSkillLv = self.data.tempValue[nSkillLv] --读temp表里的值
	end

	if (type(worldX) == "string") then
		worldX = self.data.tempValue[worldX] --读temp表里的值
	end

	if (type(worldY) == "string") then
		worldY = self.data.tempValue[worldY] --读temp表里的值
	end
	
	return __CODE__CastSkill(self,d.unit,nSkillId, nSkillLv, -1,d.power,worldX,worldY,valueToCopy)
end

--geyachao: 新加流程，TD释放buff技能
__aCodeList["CastBuff"] = function(self,_, nSkillId, nBuffLv, nBuffTime)
	local d = self.data
	if (type(nBuffLv) == "string") then
		nBuffLv = self.data.tempValue[nBuffLv] --读temp表里的值
	end
	--print("nBuffLv", nBuffLv)
	local target = 0 --buff释放的目标
	
	--如果对自己加buff。那么目标改为自己
	if (hVar.tab_skill[nSkillId] == nil) then
		_DEBUG_MSG("[SKILL ERROR]参数错误，无效的技能id="..nSkillId)
	end
	
	local targetType = hVar.tab_skill[nSkillId].target[1]
	if (targetType == "SELF") then
		target = d.unit
	else
		target = d.target
		
		--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
		if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
			return self:doNextAction()
		end
	end
	return __CODE__CastBuff(self, d.unit, target, nSkillId, -1, d.power, nBuffLv, nBuffTime)
end

local __ENUM__GetPartUnit = function(oUnit,tTemp)
	if oUnit.data.bossID==tTemp.bossID and oUnit.data.partID==tTemp.part then
		tTemp[1] = oUnit
	end
end

__aCodeList["CastSkillByPart"] = function(self,_,nPartId,nSkillId,worldX,worldY,valueToCopy)
	local d = self.data
	local oWorld = d.world
	local oUnit = d.unit
	local nPartID = __AnalyzeValueExpr(self,d.unit,nPartId,"number")
	local tTemp = {bossID=0,part=nPartID}
	if oUnit.data.bossID==-1 then
		--我是本体
		tTemp.bossID = oUnit.ID
	elseif oUnit.data.bossID>0 then
		--我是部件
		tTemp.bossID = oUnit.data.bossID
	end
	if nPartID==0 then
		--命令BOSS放技能
		local oUnitB = hClass.unit:find(tTemp.bossID)
		if oUnitB and oUnitB.data.IsDead==0 and oUnitB:getworld()==d.world then
			tTemp[1] = oUnitB
		end
	else
		oWorld:enumunit(__ENUM__GetPartUnit,tTemp)
	end
	if tTemp[1]==nil then
		return self:doNextAction()
	else
		return __CODE__CastSkill(self,tTemp[1],nSkillId,-1,d.power,worldX,worldY,valueToCopy)
	end
end

__aCodeList["CastSkillCost"] = function(self,_,nSkillId,nManaCost,worldX,worldY,valueToCopy)
	local d = self.data
	local oUnit = d.unit
	local nCost = __AnalyzeValueExpr(self,oUnit,nManaCost,"number")
	if nCost>0 and oUnit.attr.mp<nCost then
		--法力值不足以释放技能
		return self:doNextAction()
	else
		return __CODE__CastSkill(self,d.unit,nSkillId,nCost,d.power,worldX,worldY,valueToCopy)
	end
end

__aCodeList["ShootAttack"] = function(self,_,nAttackPower,nSkillId,worldX,worldY,valueToCopy)
	local d = self.data
	local u = d.unit
	local nPower = math.floor(__AnalyzeValueExpr(self,u,nAttackPower,"number")*d.power/100)
	if u.attr.ShootAttackID~=0 and hVar.tab_skill[u.attr.ShootAttackID] then
		nSkillId = u.attr.ShootAttackID
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return self:doNextAction()
	end
	
	return __CODE__CastSkill(self,d.unit,nSkillId,-1,nPower,worldX,worldY,valueToCopy)
end

__aCodeList["ReActiveTarget"] = function(self,_,mode,nActivityEx,nActiveMode)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	--复制施法不能重新激活自己的行动
	if nActiveMode==0 and d.CastOrder==hVar.ORDER_TYPE.COPY_CAST then
		return self:doNextAction()
	end
	if t~=nil and t~=0 and t.ID~=0 then
		local w = t:getworld()
		if w and w:getround() then
			local oRound = w:getround()
			local tRoundData = oRound:top(1)
			if oRound.data.ActivedUnit[3]==tRoundData[hVar.ROUND_DEFINE.DATA_INDEX.nUnique] then
				local nActivityC = (tRoundData[hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx] or 0)
				if (nActivityEx or 0)<nActivityC then
					nActivityEx = nActivityC
				end
			end
			if nActiveMode==nil then
				nActiveMode = hVar.ROUND_DEFINE.ACTIVE_MODE.NORMAL
			end
			oRound:insertunit(t,oRound.data.roundCur,nActivityEx,nActiveMode,hVar.ROUND_DEFINE.SORT_MODE.APPEND)
			if w.data.IsQuickBattlefield~=1 and hGlobal.LocalPlayer:getfocusworld()==w then
				oRound.data.LockFrameCount = math.max(hApi.GetFrameCountByTick(800),oRound.data.LockFrameCount)
				hApi.addTimerOnce("__BF_ReActiveTarget",1,function()
					return hGlobal.event:event("LocalEvent_RoundChanged",w,oRound)
				end)
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["AddAura"] = function(self,_,mode,nSkillId,rMin,rMax,vBuffName)
	local d = self.data
	local w = d.unit:getworld()
	local tabS = hVar.tab_skill[nSkillId]
	if w~=nil and tabS~=nil then
		if rMin==nil or rMax==nil then
			rMin,rMax = hApi.GetSkillRange(nSkillId,d.unit)
		end
		vBuffName = tostring(vBuffName)
		local oUnit
		if mode=="ground" then
			w:addaura(self,nil,d.gridX,d.gridY,nSkillId,rMin,rMax,vBuffName)
		else
			if mode=="target" then
				oUnit = d.target
			else--if mode=="unit" then
				oUnit = d.unit
			end
			if oUnit~=nil and oUnit~=0 and hApi.IsUnitAlive(oUnit) then
				w:addaura(self,oUnit,oUnit.data.gridX,oUnit.data.gridY,nSkillId,rMin,rMax,vBuffName)
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["RotateBy"] = function(self,_,angle,nDelay)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if self.data.unit.handle._n then
		self.data.unit.handle._n:runAction(CCRotateBy:create(nDelay/1000,angle))
	end
	return self:doNextAction()
end

__aCodeList["SetAnchorPoint"] = function(self,_,x,y)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if self.data.unit.handle.s then
		self.data.unit.handle.s:setAnchorPoint(ccp(x,y))
	end
	return self:doNextAction()
end

--geyachao: 新加，TD的buff设置buff的生存时间
__aCodeList["LastTime"] = function(self, _, lastTime)
	--print("TD的buff设置buff的生存时间")
	return self:doNextAction()
end

--geyachao: 新加，TD的技能僵直时间定义
__aCodeList["StaticTime"] = function(self, _, lastTime)
	--print("TD的技能僵直时间定义")
	return self:doNextAction()
end

--geyachao: 新加，TD的buff设置buff的tick间隔
__aCodeList["BuffEvent_OnBuffTick"] = function(self, _, lastTime)
	--print("TD的技能僵直时间定义")
	return self:doNextAction()
end

--geyachao: 新加，TD的buff设置目标buff的tick间隔
__aCodeList["BuffEvent_OnBuffTickT"] = function(self, _, tick, skillId, skillLv)
	--print("TD的buff设置目标buff的tick间隔")
	return self:doNextAction()
end

--geyachao: 新加，TD的buff设置buff移除时执行的逻辑
__aCodeList["BuffEvent_OnBuffRemove"] = function(self, _, skillId, skillLv)
	--print("TD的buff设置buff移除时执行的逻辑")
	return self:doNextAction()
end

--geyachao: 新加，TD的buff设置特殊状态
__aCodeList["BuffAddState"] = function(self, _, lastTime)
	--print("TD的buff设置特殊状态")
	return self:doNextAction()
end

__aCodeList["MoveBy"] = function(self,_,dx,dy,nDelay)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if self.data.unit.handle._n then
		self.data.unit.handle._n:runAction(CCMoveBy:create(nDelay/1000,ccp(dx, dy)))
	end
	return self:doNextAction()
end

--geyachao: 取角色或目标身上指定buffId的等级（不存在返回0），并存到变量中
__aCodeList["GetBuffLv_TD"] = function(self, _, skillId, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId] --读temp表里的值
	end
	
	--默认存储为0
	d.tempValue[param] = 0
	
	--print("取角色或目标身上指定buffId的等级（不存在返回0），并存到变量中")
	--print("skillId=", skillId)
	--print("unit=", unit and unit.data.name)
	--print("param=", param)
	
	if unit then
		--依次遍历目标是否有此buff
		local oBuff = unit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			local buffLv = oBuff.data.level --该buff的等级
			
			--存储
			d.tempValue[param] = buffLv
		end
	end
	
	--print("GetBuffLv_TD", skillId, unit.data.name, unit.data.id, targetType, param, d.tempValue[param])
	
	return self:doNextAction()
end

--geyachao: 取角色或目标身上指定buffId的堆叠层数（不存在返回0），并存到变量中
__aCodeList["GetBuffStack_TD"] = function(self, _, skillId, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId] --读temp表里的值
	end
	
	--默认存储为0
	d.tempValue[param] = 0
	
	if unit then
		--依次遍历目标是否有此buff
		local oBuff = unit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			local buffStack = oBuff.data.stack --该buff的堆叠层数
			
			--存储
			d.tempValue[param] = buffStack
		end
	end
	
	--print("GetBuffStack_TD", skillId, targetType, param, d.tempValue[param])
	
	return self:doNextAction()
end

--删除指定技能id的buff
__aCodeList["RemoveBuff_TD"] = function(self, _, skillId, targetType, bRemoveTank)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("RemoveBuff_TD", eu_x, eu_y, d.worldX, d.worldY)
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId] --读temp表里的值
	end
	
	if unit then
		--依次遍历目标是否有此buff
		local oBuff = unit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			--删除buff
			oBuff:del_buff()
		end
	end
	
	--移除坦克的炮口部分
	if bRemoveTank then
		local bind_unit = unit.data.bind_unit
		if bind_unit and (bind_unit ~= 0) then
			--依次遍历目标是否有此buff
			local oBuff = bind_unit:getBuffById(skillId)
			if oBuff then --目标身上已有此buff
				--删除buff
				oBuff:del_buff()
			end
		end
		
		local bind_weapon = unit.data.bind_weapon
		if bind_weapon and (bind_weapon ~= 0) then
			--依次遍历目标是否有此buff
			local oBuff = bind_weapon:getBuffById(skillId)
			if oBuff then --目标身上已有此buff
				--删除buff
				oBuff:del_buff()
			end
		end
	end
	
	--print("RemoveBuff_TD", skillId, targetType)
	
	return self:doNextAction()
end

--大菠萝
--ChageUnit
--将单位的子单位替换为新单位
--bindType: "bind_unit","bind_weapon","bind_lamp","bind_light","bind_wheel","bind_shadow","bind_energy",
__aCodeList["ChangeBindUnit_TD"] = function(self, _, targetType, bindType, newTypeId)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("ChangeBindUnit_TD", targetType, bindType, newTypeId)
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--print("unit=", unit.data.name, unit.data.id)
	
	--只作用于坦克
	if (unit.data.id ~= 6000) and (unit.data.id ~= 6012) and (unit.data.id ~= hVar.MY_TANK_ID) then
		return
	end
	
	if unit then
		local bu = 0
		--强制替换自身
		if (newTypeId == "self") then
			newTypeId = 0
			bu = unit.data[bindType]
			if bu and (bu ~= 0) then
				newTypeId = bu.data.id
			end
		else
			bu = unit.data[bindType]
		end
		
		if (newTypeId == 0) then --删除操作
			if bu and (bu ~= 0) then
				--删除旧的绑定单位
				--print("删除旧的绑定单位", typeIdBU)
				bu:dead()
				
				unit.data[bindType] = 0
			end
		else --替换(添加)操作
			if (bu == nil) or (bu == 0) then
				bu = unit
			end
			
			---if (bu.data.id ~= newTypeId) then --不替换相同单位
				--读取原子部件属性
				local typeIdOld = bu.data.id
				local typeIdBU = newTypeId
				local ownerBU = bu.data.owner
				local worldXBU, worldYBU = hApi.chaGetPos(bu.handle)
				local gridXBU, gridYBU = w:xy2grid(worldXBU, worldYBU)
				local facingBU = bu.data.facing
				local lvBU = bu.attr.lv
				local starBU = bu.attr.star
				local basic_weapon_level = bu.attr.attack[6] --原武器强化等级
				
				--先添加新的绑定单位
				--print("添加新的绑定单位", typeIdBU)
				local buNew = w:addunit(typeIdBU, ownerBU, gridXBU, gridYBU, facingBU, worldXBU, worldYBU, nil, nil, lvBU, starBU)
				unit.data[bindType] = buNew
				buNew.data[bindType .. "_owner"] = unit
				--设置坐标
				buNew.data.worldX = worldXBU
				buNew.data.worldX = worldYBU
				buNew.data.gridX, buNew.data.gridY = w:xy2grid(worldXBU, worldYBU)
				buNew.handle.x = worldXBU
				buNew.handle.y = worldYBU
				hApi.chaSetPos(buNew.handle, worldXBU, worldYBU)
				buNew.handle._n:setPosition(worldXBU, -worldYBU) --设置角色的位置
				buNew.attr.attack[6] = basic_weapon_level --新武器强化等级
				
				--再依次遍历原目标身上的buff，赋给新单位
				local tt = bu.data["buffs"]
				if tt.index then
					for buff_key, n in pairs(tt.index) do
						if n and (n ~= 0) then
							local oID = tt[n]
							local oBuff = hClass.action:find(oID)
							if oBuff then --目标身上已有此buff
								local buffId = oBuff.data.skillId --buff的技能id
								local buffLv = oBuff.data.level --buff的等级
								local pasttime = oBuff.data.past --buff的经过时间
								local maxtime = oBuff.data.maxtime --buff的最大时间
								
								--加buff
								local tCastParam =
								{
									castId = oBuff.data.castId,
									targetC = oBuff.data.targetC,
									IsAttack = oBuff.data.IsAttack,
									IsCast = oBuff.data.IsCast,
									IsFlee = oBuff.data.IsFlee,
									maxtime = maxtime - pasttime, --geyachao: buff最大生存时间
									buffTick = oBuff.data.buffTick, --geyachao: buff的tick间隔
									buffTickDmg = oBuff.data.buffTickDmg, --geyachao: buff的tick释放的伤害
									buffTickDmgMode = oBuff.data.buffTickDmgMode, --geyachao: buff的tick释放的伤害类型
									buffTickSkillId = oBuff.data.buffTickSkillId, --geyachao: buff的tick释放的技能
									buffTickSkillId_T = oBuff.data.buffTickSkillId_T, --geyachao: buff的目标tick释放的技能
									buffTickLv = oBuff.data.buffTickLv, --geyachao: buff的tick释放的技能等级
									buffRemoveSkillId = oBuff.data.buffRemoveSkillId, --geyachao: buff移除时释放的技能
									buffRemoveLv = oBuff.data.buffRemoveLv, --geyachao: buf移除时释放的技能等级
									level = buffLv,	--geyachao: buff等级
									buffState_Stun = oBuff.data.buffState_Stun, --geyachao: buff是否眩晕
									buffState_BianDa = oBuff.data.buffState_BianDa, --geyachao: buff是否变大
									buffState_ImmuePhysic = oBuff.data.buffState_ImmuePhysic, --geyachao: buff是否物理免疫
									buffState_ImmueMagic = oBuff.data.buffState_ImmueMagic, --geyachao: buff是否法术免疫
									buffState_ImmueWuDi = oBuff.data.buffState_ImmueWuDi, --geyachao: buff是否无敌
									buffState_ImmueControl = oBuff.data.buffState_ImmueControl, --geyachao: buff是否免控
									buffState_SufferChaos = oBuff.data.buffState_SufferChaos, --geyachao: buff是否混乱
									buffState_SufferBlow = oBuff.data.buffState_SufferBlow, --geyachao: buff是否吹风
									buffState_SufferChuanCi = oBuff.data.buffState_SufferChuanCi, --geyachao: buff是否穿刺
									buffState_SufferSleep = oBuff.data.buffState_SufferSleep, --geyachao: buff是否沉睡
								}
								hApi.CastSkill(oBuff.data.unit, buffId, 0, 100, buNew, oBuff.data.gridX, oBuff.data.gridY, tCastParam)
							end
						end
					end
				end
				
				--删除旧的绑定单位
				if (bu ~= unit) then
					bu:dead()
				end
				
				--替换道具技能
				local tabUNew = hVar.tab_unit[newTypeId]
				local weaponItemId = tabUNew.skillItemlId
				hGlobal.event:event("Event_ResetSingleTactic", hVar.NORMALATK_IDX, 0, weaponItemId, 1, -1, hVar.MY_TANK_ID)
				
				--更新武器等级
				--print(basic_weapon_level)
				local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
				local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				btn1.childUI["labSkillLv"]:setText(basic_weapon_level)
				if (basic_weapon_level > 1) then
					btn1.childUI["labSkillLv"].handle._n:setVisible(true)
					btn1.childUI["labSkillMana"].handle._n:setVisible(true)
				else
					btn1.childUI["labSkillLv"].handle._n:setVisible(false)
					btn1.childUI["labSkillMana"].handle._n:setVisible(false)
				end
				
				--原枪掉落地上
				local tabUOld = hVar.tab_unit[typeIdOld]
				print("原枪掉落地上=", typeIdOld, newTypeId)
				local dropItemId = tabUOld.dropItemId
				if dropItemId then
					--地上添加道具模型
					local tabI = hVar.tab_item[dropItemId]
					local uId = tabI.dropUnit or 20001
					local face = w:random(0, 360)
					local fangle = face * math.pi / 180 --弧度制
					local r = 100
					fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
					local dx = r * math.cos(fangle) --随机偏移值x
					local dy = r * math.sin(fangle) --随机偏移值y
					dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
					dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
					
					local gridX = worldXBU + dx --随机x位置
					local gridY = worldYBU + dy --随机y位置
					gridX, gridY = hApi.Scene_GetSpace(gridX, gridY, 60)
					local oItem = w:addunit(uId, 1,nil,nil,face,gridX,gridY,nil,nil)
					oItem:setitemid(dropItemId)
					
					--武器枪，在地面一直转动
					local DELTTIME = 0.06
					local COUNT = 32
					local ANGLE = 360 / 32
					local a = CCArray:create()
					for n = 1, COUNT, 1 do
						local delayN = CCDelayTime:create(DELTTIME)
						local rotN = CCCallFunc:create(function()
							local facing = face + ANGLE * n
							if (facing >= 360) then
								facing =  facing - 360
							end
							hApi.ChaSetFacing(oItem.handle, facing)
						end)
						
						a:addObject(delayN)
						a:addObject(rotN)
					end
					local sequence = CCSequence:create(a)
					--oItem.handle._n:stopAllActions()
					oItem.handle._n:runAction(CCRepeatForever:create(sequence))
					
					--如果是随机地图，那么将此特效存储起来，切换关卡时待删除
					local regionId = w.data.randommapIdx
					if (regionId > 0) then
						local regionData = w.data.randommapInfo[regionId]
						if regionData then
							local drop_units = regionData.drop_units --掉落道具集
							if drop_units then
								drop_units[oItem] = oItem:getworldC()
								--print("添加 drop_units", oItem.data.name, oItem:getworldC())
							end
						end
					end
				end
			--end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 取角色或目标（点）的坐标，并存到变量中
__aCodeList["GetChaPos_TD"] = function(self, _, targetType, paramX, paramY)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("GetChaPos_TD", eu_x, eu_y, d.worldX, d.worldY)
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	--默认存储为0
	if paramX then
		d.tempValue[paramX] = 0
	end
	if paramY then
		d.tempValue[paramY] = 0
	end
	
	if unit and (unit ~= 0) then
		local eu_x, eu_y = hApi.chaGetPos(unit.handle)
		if paramX then
			d.tempValue[paramX] = eu_x
		end
		if paramY then
			d.tempValue[paramY] = eu_y
		end
	else --不存在单位(或目标)
		if paramX then
			d.tempValue[paramX] = d.worldX
		end
		if paramY then
			d.tempValue[paramY] = d.worldY
		end
	end
	
	--print("GetChaPos_TD", targetType, paramX, paramY, paramX and d.tempValue[paramX], paramY and d.tempValue[paramY])
	
	return self:doNextAction()
end

--geyachao: 取角色或目标（点）的中心坐标，并存到变量中
__aCodeList["GetChaCenterPos_TD"] = function(self, _, targetType, paramX, paramY)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("GetChaPos_TD", eu_x, eu_y, d.worldX, d.worldY)
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	--默认存储为0
	if paramX then
		d.tempValue[paramX] = 0
	end
	if paramY then
		d.tempValue[paramY] = 0
	end
	
	if unit and (unit ~= 0) then
		local eu_x, eu_y = hApi.chaGetPos(unit.handle)
		local eu_bx, eu_by, eu_bw, eu_bh = unit:getbox() --包围盒
		local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
		local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
		if paramX then
			d.tempValue[paramX] = eu_center_x
		end
		if paramY then
			d.tempValue[paramY] = eu_center_y
		end
	else --不存在单位(或目标)
		if paramX then
			d.tempValue[paramX] = d.worldX
		end
		if paramY then
			d.tempValue[paramY] = d.worldY
		end
	end
	
	--print("GetChaPos_TD", targetType, paramX, paramY, paramX and d.tempValue[paramX], paramY and d.tempValue[paramY])
	
	return self:doNextAction()
end

--geyachao: 取角色或目标（点）的角度，并存到变量中
__aCodeList["GetChaFaceAngle_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--local eu_x, eu_y = hApi.chaGetPos(t.handle)
	--print("GetChaPos_TD", eu_x, eu_y, d.worldX, d.worldY)
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	--默认存储为0
	if param then
		d.tempValue[param] = 0
	end
	
	if unit and (unit ~= 0) then
		local facing = unit.data.facing or 0
		
		if (tostring(facing) == "-1.#IND") then --防止一些异常值进来
			facing = 0
			unit.data.facing = 0
		end
		if (tostring(facing) == "nan") then --防止一些异常值进来
			facing = 0
			unit.data.facing = 0
		end
		
		if param then
			d.tempValue[param] = facing
		end
	end
	
	--print("GetChaPos_TD", targetType, paramX, paramY, paramX and d.tempValue[paramX], paramY and d.tempValue[paramY])
	
	return self:doNextAction()
end


--geyachao: 获得从(x1,y1)到(x2,y2)的面向角度
__aCodeList["GetFacingAngle_TD"] = function(self, _, paramX1, paramY1, paramX2, paramY2, paramAngle)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(paramX1) == "string") then
		paramX1 = d.tempValue[paramX1] --读temp表里的值
	end
	
	if (type(paramY1) == "string") then
		paramY1 = d.tempValue[paramY1] --读temp表里的值
	end
	
	if (type(paramX2) == "string") then
		paramX2 = d.tempValue[paramX2] --读temp表里的值
	end
	
	if (type(paramY2) == "string") then
		paramY2 = d.tempValue[paramY2] --读temp表里的值
	end
	
	if paramX1 and paramY1 and paramX2 and paramY2 and paramAngle then
		local facing = GetFaceAngle(paramX1, paramY1, paramX2, paramY2) --角度制
		d.tempValue[paramAngle] = facing
	end
	
	return self:doNextAction()
end

--geyachao: 将单位转向到指定角度
__aCodeList["ChaFaceToAngle_TD"] = function(self, _, targetType, facing)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = d.world
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	if (type(facing) == "string") then
		facing = d.tempValue[facing] --读temp表里的值
	end
	
	if (facing < 0) then
		local N = math.floor(-facing / 360)
		facing = facing + 360 * (N + 1)
	end
	
	if (facing >= 360) then
		facing = facing - 360
	end
	
	--存在单位
	if unit and (unit ~= 0) and (unit:getworldC() == d.unit_worldC) then
		if (unit.data.IsDead ~= 1) and (unit.attr.hp > 0) then
			--单位转向
			hApi.ChaSetFacing(unit.handle, facing) --转向
			unit.data.facing = facing
			
			--绑定的单位也转向
			--tank: 同步更新绑定的单位的位置（炮口）
			if (unit.data.bind_unit ~= 0) then
				local bu = unit.data.bind_unit
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
			
			--tank: 同步更新绑定的单位的位置（大灯光照）
			if (unit.data.bind_light ~= 0) then
				local bu = unit.data.bind_light
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
			
			--tank: 同步更新绑定的单位的位置（大灯轮子）
			if (unit.data.bind_wheel ~= 0) then
				local bu = unit.data.bind_wheel
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
			
			--tank: 同步更新绑定的单位的位置（大灯影子）
			if (unit.data.bind_shadow ~= 0) then
				local bu = unit.data.bind_shadow
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
			
			--tank: 同步更新绑定的单位的位置（大灯能量圈）
			if (unit.data.bind_energy ~= 0) then
				local bu = unit.data.bind_energy
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
			
			--tank: 同步更新绑定的单位的位置（机枪）
			if (unit.data.bind_weapon ~= 0) then
				local bu = unit.data.bind_weapon
				if (bu:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
					--print(world:gametime() - bu.attr.last_attack_time)
					if ((w:gametime() - bu.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
						hApi.ChaSetFacing(bu.handle, facing)
						bu.data.facing = facing
					end
				end
			end
			
			--tank: 同步更新绑定的单位的位置（大灯）
			if (unit.data.bind_lamp ~= 0) then
				local bu = unit.data.bind_lamp
				hApi.ChaSetFacing(bu.handle, facing)
				bu.data.facing = facing
			end
		end
	end
	
	return self:doNextAction()
end

--单位滑行到指定地点
hApi.ChaMoveByTrack = function(oUnit, toX, toY, move_speed, block, callbackSkillId, callbackSkillUnit)
	--存在单位、活着、有效的
	if oUnit and (oUnit ~= 0) and (oUnit.data.IsDead ~= 1) and (oUnit.handle._c ~= nil) then
		--大菠萝，塔、建筑、箱子、汽油桶、可破坏物件、可破坏房子、移动速度为0的，不能被击退
		if (oUnit.data.type ~= hVar.UNIT_TYPE.TOWER) and (oUnit.data.type ~= hVar.UNIT_TYPE.BUILDING)
		and (oUnit.data.type ~= hVar.UNIT_TYPE.UNITBOX) and (oUnit.data.type ~= hVar.UNIT_TYPE.UNITCAN)
		and (oUnit.data.type ~= hVar.UNIT_TYPE.UNITBROKEN) and (oUnit.data.type ~= hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
		and (oUnit.data.type ~= hVar.UNIT_TYPE.UNITDOOR)
		and (oUnit:GetMoveSpeed() > 0) and (oUnit.attr.stun_stack == 0) and (oUnit.attr.immue_wudi_stack <= 0)
		and (oUnit.attr.immue_control_stack <= 0) and (oUnit.attr.immue_debuff_stack <= 0) then --目标是无敌、免控状态、免疫负面属性
			--不在吹风中
			if (oUnit.attr.suffer_blow_stack == 0) then
				--当前不是移动到达
				local aiState = oUnit:getAIState() --角色的AI状态
				if (aiState ~= hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then
					--如果单位正在滑行中，先取消前一次的滑行状态
					if (aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then
						hApi.RemoveStunState(oUnit)
						--print("如果单位正在滑行中，先取消前一次的滑行状态")
					end
					
					--给单位添加眩晕状态
					hApi.AddStunState(oUnit)
					
					--标记单位当前的AI状态为滑行
					oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_BY_TRACK)
					
					--单位移动到指定地点
					toX = math.floor(toX * 100) / 100 --保留2位有效数字，用于同步
					toY = math.floor(toY * 100) / 100 --保留2位有效数字，用于同步
					--print("ChaMoveByTrack", oUnit.data.name, move_speed)
					if (block == 0) then
						hApi.UnitMoveToPoint_TD(oUnit, toX, toY, false, move_speed, true, nil, true, callbackSkillId, callbackSkillUnit)
					else
						hApi.UnitMoveToPoint_TD(oUnit, toX, toY, true, move_speed, true, nil, true, callbackSkillId, callbackSkillUnit)
					end
				end
			end
		end
	end
end

--geyachao: 将单位滑行到指定的坐标
__aCodeList["ChaMoveByTrack_TD"] = function(self, _, targetType, toX, toY, move_speed)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	if (type(toX) == "string") then
		toX = d.tempValue[toX] --读temp表里的值
	end
	
	if (type(toY) == "string") then
		toY = d.tempValue[toY] --读temp表里的值
	end
	
	if (type(move_speed) == "string") then
		move_speed = d.tempValue[move_speed] --读temp表里的值
	end
	
	--存在单位
	if unit and (unit ~= 0) then
		--将单位滑行到指定的坐标
		hApi.ChaMoveByTrack(unit, toX, toY, move_speed)
		
		--设置防守点
		--unit.data.defend_x = toX
		--unit.data.defend_y =  toY
	end
	
	return self:doNextAction()
end


--获得AI状态
__aCodeList["ChaGetAIState_TD"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	if unit then
		local aiState = unit:getAIState() --角色的AI状态
		
		--存储
		if (type(param) == "string") then
			d.tempValue[param] = aiState
		end
	end
	
	return self:doNextAction()
end

--获得战车运动状态（用于扔手雷更远）
__aCodeList["ChaGetRunState_Diablo"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = d.world
	
	local rpgunit_last_x = w.data.rpgunit_last_x
	local rpgunit_last_y = w.data.rpgunit_last_y
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	if unit then
		local ux, uy = hApi.chaGetPos(unit.handle) --角色当前的位置
		local dx = ux - rpgunit_last_x
		local dy = uy - rpgunit_last_y
		
		--存储
		if (type(param) == "string") then
			if (dx ~= 0) or (dy ~= 0) then --有位移，当前为运动状态
				d.tempValue[param] = 1
			else
				d.tempValue[param] = 0
			end
		end
	end
	
	return self:doNextAction()
end

--显示范围伤害的生效范围
__aCodeList["ShowDamageArea_Diablo"] = function(self, _, rMax, showtime)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = d.world
	local worldX = d.worldX
	local worldY = d.worldY
	
	if (type(rMax) == "string") then
		rMax = d.tempValue[rMax] --读temp表里的值
	end
	
	if (type(showtime) == "string") then
		showtime = d.tempValue[showtime] --读temp表里的值
	end
	
	local range = rMax
	local nTime = 1000 + showtime
	local t = w:addunit(12, 1, nil, nil, facing, worldX, worldY)
	
	--显示预施法范围
	t.chaUI["TD_CastSkill"] = hUI.image:new({
		parent = t.handle._n,
		x = 0,
		y = 0,
		model = "MODEL_EFFECT:SelectCircle",
		animation = "range",
		z = -255,
		w = range * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
		--color = {128, 255, 128},
		--alpha = 48,
	})
	
	local scale = 1.0
	local a = CCScaleBy:create(0.6, scale, scale)
	local aR = a:reverse()
	local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR), "CCActionInterval")
	t.chaUI["TD_CastSkill"].handle._n:runAction(CCRepeatForever:create(seq))
	
	local scale_inner = 0.0
	local program = hApi.getShader("atkrange1", 10, scale_inner) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
	local resolution = program:glGetUniformLocation("resolution")
	program:setUniformLocationWithFloats(resolution,66,66)
	
	local rr = program:glGetUniformLocation("rr")
	local gg = program:glGetUniformLocation("gg")
	local bb = program:glGetUniformLocation("bb")
	program:setUniformLocationWithFloats(rr, 0)
	program:setUniformLocationWithFloats(gg, 1)
	program:setUniformLocationWithFloats(bb, 0)
	
	--显示最小攻击范围
	--hApi.clearShader("atkrange1", 1)
	--program:glluaAddTempUniform(0,scale,"inner_r") --动态刷shader
	--第一参 目前能传0-4 相当于lua能用5个可逐帧刷新的shader变量
	--第二参 是具体value（float）
	--第三参 是shader里用到的那个变量名
	local inner_r = program:glGetUniformLocation("inner_r")
	program:setUniformLocationWithFloats(inner_r, scale_inner)
	
	t.chaUI["TD_CastSkill"].handle.s:setShaderProgram(program)
	
	--一段时间后消失
	local delay = CCDelayTime:create(nTime / 1000)
	local callback = CCCallFunc:create(function(ctrl)
		hApi.safeRemoveT(t.chaUI, "TD_CastSkill")
		t:del()
	end)
	t.chaUI["TD_CastSkill"].handle.s:runAction(CCSequence:createWithTwoActions(delay, callback))
	
	return self:doNextAction()
end

--获得vip等级
__aCodeList["GetVipLevel_Diablo"] = function(self, _, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = d.world
	
	--存储
	if (type(param) == "string") then
		d.tempValue[param] = LuaGetPlayerVipLv()
	end
	
	return self:doNextAction()
end

--显示3选1界面
__aCodeList["ShowSelectAuraFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local td_upgrade = u.td_upgrade
	if (type(td_upgrade) == "table") then
		local castSkill = td_upgrade.castSkill
		if (type(castSkill) == "table") then
			local order = castSkill.order
			if (type(order) == "table") then
				local skillId = order[1]
				if (type(skillId) == "number") then
					local skillObj = u:getskill(skillId)
					if skillObj then
						local lv = skillObj[2]
						local count = skillObj[4]
						local cd = skillObj[5]
						local lasttime = skillObj[6]
						local index = skillObj[7] --临时存储
						
						local mapInfo = w.data.tdMapInfo
						local tInfo = mapInfo.eventUnit[index]
						if tInfo then
							--游戏暂停
							--local mapInfo = w.data.tdMapInfo
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
								w:pause(1, "TD_PAUSE")
								mapInfo.mapLastState = mapInfo.mapState
								
								mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
							end
							
							--旧版抽卡界面
							if hVar.UnitAuraGroupDefine[u.data.id] then
								if type(tInfo.list) ~= "table" then
									local id = u.data.id
									local groupindex = hVar.UnitAuraGroupDefine[id] or 1
									tInfo.list = hVar.GetRandAuraList(groupindex)
								end
								local tCallback = {"LocalEvent_UseAuraBack",{index,u}}
								hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
							else
								--改成新的抽卡
								local drawCardWave = 1 --本次抽卡属于哪一波（防止已经领取卡片了再收到回调）
								local oPlayer = u:getowner()
								
								--随机迷宫，取我的势力
								if (w.data.map == hVar.RandomMap) then
									oPlayer = w:GetPlayerMe()
								end
								
								local playerPos = oPlayer:getpos()
								if (w.data.endless_build_tactics[playerPos] == nil) then
									w.data.endless_build_tactics[playerPos] = {}
								end
								local tPlayerInfo = w.data.endless_build_tactics[playerPos]
								if tPlayerInfo.perWave then
									drawCardWave = #tPlayerInfo.perWave+1
								end
								if (tPlayerInfo.perWaveCardList == nil) then
									tPlayerInfo.perWaveCardList = {}
								end
								if (tPlayerInfo.perWaveCardList[drawCardWave] == nil) then
									tPlayerInfo.perWaveCardList[drawCardWave] = {}
								end
								print("显示3选1界面")
								print("playerPos=", playerPos)
								print("drawCardWave=", drawCardWave)
								print("unitId=", u.data.id)
								local tCardList = tPlayerInfo.perWaveCardList[drawCardWave][u.data.id]
								print("tCardList=", tCardList)
								if (tCardList == nil) then
									tCardList = hApi.GenerateSelectCardList(oPlayer, u.data.id)
									
									--统计每波的抽卡信息
									tPlayerInfo.perWaveCardList[drawCardWave][u.data.id] = tCardList
								end
								local tCallback = {"LocalEvent_UseAuraBack",{index,u}}
								hApi.ShowSelectCardTip_RZWD(tCardList, u.data.id, tCallback)
							end
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--显示宠物对话框界面
__aCodeList["ShowSelectPetFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local td_upgrade = u.td_upgrade
	if (type(td_upgrade) == "table") then
		local castSkill = td_upgrade.castSkill
		if (type(castSkill) == "table") then
			local order = castSkill.order
			if (type(order) == "table") then
				local skillId = order[1]
				if (type(skillId) == "number") then
					local skillObj = u:getskill(skillId)
					if skillObj then
						local lv = skillObj[2]
						local count = skillObj[4]
						local cd = skillObj[5]
						local lasttime = skillObj[6]
						local index = skillObj[7] --临时存储
						
						local mapInfo = w.data.tdMapInfo
						local tInfo = mapInfo.eventUnit[index]
						if tInfo then
							--游戏暂停
							--local mapInfo = w.data.tdMapInfo
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
								w:pause(1, "TD_PAUSE")
								mapInfo.mapLastState = mapInfo.mapState
								
								mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
							end
							
							local tCallback = {"LocalEvent_UsePetBack",{index,u}}
							local costScore = 500
							local addUnit = 12217
							hGlobal.event:event("LocalEvent_ShowSelectPetFrm", index, addUnit, costScore,tCallback)
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--显示加血台子对话框界面
__aCodeList["ShowSelectHpRecoverFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local td_upgrade = u.td_upgrade
	if (type(td_upgrade) == "table") then
		local castSkill = td_upgrade.castSkill
		if (type(castSkill) == "table") then
			local order = castSkill.order
			if (type(order) == "table") then
				local skillId = order[1]
				if (type(skillId) == "number") then
					local skillObj = u:getskill(skillId)
					if skillObj then
						local lv = skillObj[2]
						local count = skillObj[4]
						local cd = skillObj[5]
						local lasttime = skillObj[6]
						local index = skillObj[7] --临时存储
						
						local mapInfo = w.data.tdMapInfo
						local tInfo = mapInfo.eventUnit[index]
						if tInfo then
							--游戏暂停
							--local mapInfo = w.data.tdMapInfo
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
								w:pause(1, "TD_PAUSE")
								mapInfo.mapLastState = mapInfo.mapState
								
								mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
							end

							local tCallback = {"LocalEvent_UseHpRecoverBack",{index,u}}
							hGlobal.event:event("LocalEvent_ShowAddPetHpfrm",tCallback)
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--显示存盘点对话框界面
__aCodeList["ShowSelectSettlementFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local td_upgrade = u.td_upgrade
	if (type(td_upgrade) == "table") then
		local castSkill = td_upgrade.castSkill
		if (type(castSkill) == "table") then
			local order = castSkill.order
			if (type(order) == "table") then
				local skillId = order[1]
				if (type(skillId) == "number") then
					local skillObj = u:getskill(skillId)
					if skillObj then
						local lv = skillObj[2]
						local count = skillObj[4]
						local cd = skillObj[5]
						local lasttime = skillObj[6]
						local index = skillObj[7] --临时存储
						
						local mapInfo = w.data.tdMapInfo
						local tInfo = mapInfo.eventUnit[index]
						if tInfo then
							--游戏暂停
							--local mapInfo = w.data.tdMapInfo
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
								w:pause(1, "TD_PAUSE")
								mapInfo.mapLastState = mapInfo.mapState
								
								mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
							end

							local tCallback = {"LocalEvent_SettlementBack",{index,u}}
							hGlobal.event:event("LocalEvent_ShowGameSettlementFrm",index,tCallback)
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--显示基地NPC对话框界面
__aCodeList["ShowSelectBaseNPCFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local td_upgrade = u.td_upgrade
	if (type(td_upgrade) == "table") then
		local castSkill = td_upgrade.castSkill
		if (type(castSkill) == "table") then
			local order = castSkill.order
			if (type(order) == "table") then
				local skillId = order[1]
				if (type(skillId) == "number") then
					local skillObj = u:getskill(skillId)
					if skillObj then
						local lv = skillObj[2]
						local count = skillObj[4]
						local cd = skillObj[5]
						local lasttime = skillObj[6]
						local index = skillObj[7] --临时存储
						
						local mapInfo = w.data.tdMapInfo
						local tInfo = mapInfo.eventUnit[index]
						if tInfo then
							--游戏暂停
							--local mapInfo = w.data.tdMapInfo
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
								w:pause(1, "TD_PAUSE")
								mapInfo.mapLastState = mapInfo.mapState
								
								mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
							end
							
							local tCallback = {"LocalEvent_UseBaseNPCBack",{index,u}}
							--local costScore = 500
							--local addUnit = 12217
							--hGlobal.event:event("LocalEvent_ShowSelectPetFrm", index, addUnit, costScore,tCallback)
							--print("点击NPC", u.data.id)
							hGlobal.event:event(tCallback[1], tCallback[2])
						end
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 单位变身
__aCodeList["ChangeUnit_TD"] = function(self, _, targetType, unitId, unitPos, livetime, lv)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--geyachao: 支持传入参数
	if (type(unitId) == "string") then
		unitId = self.data.tempValue[unitId] --读temp表里的值
	end
	
	--geyachao: 支持传入参数
	if (type(unitPos) == "string") then
		unitPos = self.data.tempValue[unitPos] --读temp表里的值
	end
	
	--geyachao: 支持传入参数
	if (type(livetime) == "string") then
		livetime = self.data.tempValue[livetime]
	end
	
	--geyachao: 支持传入参数
	if (type(lv) == "string") then
		lv = self.data.tempValue[lv]
	end
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if unit and (unit ~= 0) then
		local oPlayer = unit:getowner()
		local oPlayerMe = w:GetPlayerMe()
		
		--原单位绑定的英雄
		local oHero = unit:gethero()
		
		--替换前拷贝路点
		local roadPoint = unit:copyRoadPointInfo()
		
		--替换单位
		--(oUnit, toTypeId, toOwner, effectId, strSound, pathId, delCha, lv)
		local cha = hApi.ChangeUnit(unit, unitId, unitPos, 96, "Thunder4", nil, true, lv)
		if cha then
			--geyachao: 标记该单位是召唤单位
			cha.data.is_summon = 1
			cha.data.summon_worldC = u:getworldC() --召唤者唯一id
			
			--召唤单位的出生波次，和召唤者保持一致
			cha.data.appear_wave = u.data.appear_wave
			
			--如果新目标位置和之前一致，那么继续按原路点走
			if (oPlayer:getpos() == unitPos) then
				--设置目标的路点
				cha:setRoadPointByT(roadPoint)
			end
			
			--如果新目标位置和之前不一致，那么死亡扣生命点为0
			if (oPlayer:getpos() ~= unitPos) then
				cha.attr.escape_punish_basic = 0
			end
			
			--绑定新单位
			if oHero then
				oHero:bind(cha)
			end
			
			--添加单位事件里就是处理生效战术卡，这里不重复添加
			--添加战术技能卡技能
			--w:tacticsTakeEffect(cha)
			
			--设置生存时间
			if (livetime) and (livetime > 0) then
				local currenttime = w:gametime()
				cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
				cha.data.livetime = livetime --新加数据 生存时间（毫秒）
				cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				--cha.data.defend_distance_max = distance_max --最远能到达的守卫距离
			end
			
			--是否为rpgunits
			if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
				if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
					w.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
				end
			end
			
			--将该单位存到召唤单位缓存表中
			self.data.tempValue["SummonUnitList"] = self.data.tempValue["SummonUnitList"] or {}
			self.data.tempValue["SummonUnitList"][(#(self.data.tempValue["SummonUnitList"]))+1] = cha
			
			--触发事件：添加单位
			--geyachao: 在hApi.ChangeUnit()里已触发此事件
			--hGlobal.event:call("Event_UnitBorn", cha)
			
			--重绘英雄头像控件
			if oHero then
				if (oPlayer == oPlayerMe) then
					hGlobal.event:event("LocalEvent_UpdateAllHeroIcon")
				end
			end
		end
	end
	
	return self:doNextAction()
end

--显示起名界面
__aCodeList["ShowSetNameFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--弹出起名界面
	--hApi.CreateModifyInputBox_Diablo(1, 2, self.ID)
	hGlobal.event:event("LocalEvent_ShowModifyPlayerName",1,1, self.ID)
	
	return "sleep", math.huge --大菠萝，改为action回调继续后续流程
	--return self:doNextAction()
end

__aCodeList["ChaMoveByTrack_TD_NoBlock"] = function(self, _, targetType, toX, toY, move_speed, blockCallbackSkillId)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	else
		unit = nil
	end
	
	if (type(toX) == "string") then
		toX = d.tempValue[toX] --读temp表里的值
	end
	
	if (type(toY) == "string") then
		toY = d.tempValue[toY] --读temp表里的值
	end
	
	if (type(move_speed) == "string") then
		move_speed = d.tempValue[move_speed] --读temp表里的值
	end
	
	if (type(blockCallbackSkillId) == "string") then
		blockCallbackSkillId = d.tempValue[blockCallbackSkillId] --读temp表里的值
	end
	
	local callbackSkillId = 0
	
	--存在单位
	if unit and (unit ~= 0) then
		local ux, uy = hApi.chaGetPos(unit.handle) --角色当前的位置
		local dx = ux - toX
		local dy = uy - toY
		local distance = math.sqrt(dx * dx + dy * dy) --距离
		distance = math.floor(distance * 100) / 100  --保留2位有效数字，用于同步
		
		if (distance > 24) then
			--角度
			local angle = GetLineAngle(ux, uy, toX, toY)
			local fangle = angle * math.pi / 180 --弧度制
			fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
			local left_distance = 0 --剩余的长度
			local STEP = 12 --步长
			while (left_distance <= distance) do
				--每次递减距离
				left_distance = left_distance + STEP
				
				local tx = ux + left_distance * math.cos(fangle) --尝试到达的x坐标
				local ty = uy + left_distance * math.sin(fangle) --尝试到达的y坐标
				tx = math.floor(tx * 100) / 100  --保留2位有效数字，用于同步
				ty = math.floor(ty * 100) / 100  --保留2位有效数字，用于同步
				
				local result = xlScene_IsGridBlock(g_world, tx / 24, ty / 24) --某个坐标是否是障碍
				
				--障碍点
				if (result == 0) then
					toX = tx
					toY = ty
				else
					callbackSkillId = blockCallbackSkillId --撞墙了，触发回调
					break
				end
			end
		end
		
		--将单位滑行到指定的坐标
		hApi.ChaMoveByTrack(unit, toX, toY, move_speed, 0, callbackSkillId, u)
		
		--设置防守点
		unit.data.defend_x = toX
		unit.data.defend_y =  toY
	end
	
	return self:doNextAction()
end

--geyachao: 获得距离一个指定坐标最近的传送点单位的坐标
__aCodeList["GetNearestPortalPosition_Diablo"] = function(self, _, posX, posY, paramX, paramY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	if (type(posX) == "string") then
		posX = d.tempValue[posX] --读temp表里的值
	end
	
	if (type(posY) == "string") then
		posY = d.tempValue[posY] --读temp表里的值
	end
	
	local mapInfo = w.data.tdMapInfo
	--传送门
	if mapInfo.portal then
		local portalX = 0
		local portalX = 0
		local portalDistance = math.huge
		
		for i = 1, #mapInfo.portal do
			local portal = mapInfo.portal[i]
			if portal then
				local x = portal.x
				local y = portal.y
				local dx = x - posX
				local dy = y - posY
				local distance = dx * dx + dy * dy
				if (distance < portalDistance) then --找到更近的坐标
					portalX = x
					portalY = y
					portalDistance = distance
				end
			end
		end
		
		d.tempValue[paramX] = portalX
		d.tempValue[paramY] = portalY
	end
	
	return self:doNextAction()
end

--geyachao: 获得当前地图内宠物单位数量
__aCodeList["GetMapPetUnitNum_Diablo"] = function(self, _, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	--统计宠物数量
	local petNum = 0
	
	local rpgunits = w.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		--local oUnit = oHero:getunit()
		local oUnit = u
		--if oUnit and (oUnit ~= 0) then
		--if (oUnit.data.id == hVar.MY_TANK_FOLLOW_ID) then
		for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
			if (oUnit.data.id == walle_id) then
				petNum = petNum + 1
			end
		end
	end
	
	--存储
	d.tempValue[param] = petNum
	
	return self:doNextAction()
end

--geyachao:增加一条命
__aCodeList["AddLife_Diablo"] = function(self, _, targetType, addLife)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
	if diablodata then
		--LuaAddPlayerScore(-hVar.BUY_LIFE_COST)
		--购买生命
		--diablodata.lifecount = diablodata.lifecount + addLife
		diablodata.canbuylife = diablodata.canbuylife + addLife
		if type(diablodata.randMap) == "table" then
			--记录随机地图数据
			local tInfos = {
				{"lifecount",diablodata.lifecount},
				{"canbuylife",diablodata.canbuylife},
			}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
		end
		
	end
	
	return self:doNextAction()
end

__aCodeList["SetVisible"] = function(self,_,bVisible)
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	if self.data.unit.handle._n then
		if bVisible == 1 then
			self.data.unit.handle._n:setVisible(true)
		elseif bVisible == 0 then
			self.data.unit.handle._n:setVisible(false)
		end
	end
	return self:doNextAction()
end

__aCodeList["SetShader"] = function(self,_,mode,shaderName,paramTab)--设置自己的shader
	--快速模式不做任何表现性操作
	if self.data.IsQuickAction==1 then
		return self:doNextAction()
	end
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	elseif mode=="target" then
		t = d.target
	end
	if (t or 0)~=0 and t.handle.s then
		local program = hApi.getShader(shaderName)
		if program ~= 0 then
			if paramTab then
				local tem
				for i = 1,#paramTab do
					tem =  program:glGetUniformLocation(paramTab[i][1])
					if #paramTab[i] == 2 then
						program:setUniformLocationWithFloats(tem,paramTab[i][2])
					elseif #paramTab[i] == 3 then
						program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3])
					elseif #paramTab[i] == 4 then
						program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3],paramTab[i][4])
					elseif #paramTab[i] == 5 then
						program:setUniformLocationWithFloats(tem,paramTab[i][2],paramTab[i][3],paramTab[i][4],paramTab[i][5])
					end
				end	
			end
			t.handle.s:setShaderProgram(program)
			--self.data.unit.handle._n:setShaderProgram(program)
			--self.data.unit.handle._tn:setShaderProgram(program)
			--self.data.unit.handle._sce:setShaderProgram(program)
			--self.data.unit.handle._c:setShaderProgram(program)
		end
	end
	return self:doNextAction()
end

__aCodeList["SetWorldXYBy"] = function(self,_,mode,param)
	local d = self.data
	local u = d.unit
	local t = d.target
	if t==0 then
		t = u
	end
	if mode=="unit" then
		if u~=0 then
			d.worldX,d.worldY = u:getXY(1)
		end
	elseif mode=="target" then
		if t~=0 then
			d.worldX,d.worldY = t:getXY(1)
		end
	elseif mode=="range" then
		local cx,cy = d.castX,d.castY
		local dx,dy = d.world:grid2xy(d.gridX,d.gridY)
		if cx==dx and cy==dy then
			dx = cx + 100*math.cos(math.rad(d.castFacing))
			dy = cy + 100*math.sin(math.rad(d.castFacing))
			dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
			dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
		end
		local nRange = __AnalyzeValueExpr(self,u,param,"number")
		d.worldX,d.worldY = hApi.GetXYByRadial(cx,cy,dx,dy,nRange)
	end
	return self:doNextAction()
end

--设置施法点
__aCodeList["SetWorldXY_Diablo"] = function(self, _, worldX, worldY)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(worldX) == "string") then
		--worldX = d.tempValue[worldX] --读temp表里的值
		worldX = __AnalyzeValueExpr(self,u,worldX,"number")
	end
	
	if (type(worldY) == "string") then
		--worldY = d.tempValue[worldY] --读temp表里的值
		worldY = __AnalyzeValueExpr(self,u,worldY,"number")
	end
	
	d.worldX = worldX
	d.worldY = worldY
	
	return self:doNextAction()
end

--循环执行内部的动作
__aCodeList["SetGridBy"] = function(self,_,mode,param)
	local d = self.data
	local u = d.unit
	local t = d.target
	if t==0 then
		t = u
	end
	if mode=="unit" then
		if u~=0 then
			if type(param)=="table" then
				d.gridX = u.data.gridX + param[1]
				d.gridY = u.data.gridY + param[2]
				d.worldX,d.worldY = d.world:grid2xy(d.gridX,d.gridY)
			else
				d.gridX,d.gridY = u.data.gridX,u.data.gridY
				d.worldX,d.worldY = d.world:grid2xy(d.gridX,d.gridY)
			end
		end
	elseif mode=="target" then
		if t~=0 then
			d.gridX,d.gridY = t.data.gridX,t.data.gridY
			d.worldX,d.worldY = t:getXY(1)
		end
	elseif mode=="world" then
		if type(param)=="table" then
			d.gridX,d.gridY = param[1],param[2]
			d.worldX,d.worldY = d.world:grid2xy(d.gridX,d.gridY)
		end
	--elseif mode=="FacingLR" then
		----只能算出左右两个方向
		--local n = math.max(1,__AnalyzeValueExpr(self,u,param,"number"))
		--local facing
		--if d.gridX==u.data.gridX and d.gridY==u.data.gridY then
			----同一个格子啥都不用做
		--else
			--local cx,cy = u:getXY(1)
			--local tx,ty = d.world:grid2xy(d.gridX,d.gridY)
			--if cx>tx then
				--facing = -1
			--elseif cx<tx then
				--facing = 1
			--end
		--end
		--if facing==nil then
			--if u.data.facing>90 and u.data.facing<=270 then
				--facing = -1
			--else
				--facing = 1
			--end
		--end
		--d.gridX = u.data.gridX + facing*n
		--d.gridY = u.data.gridY
	elseif mode=="MoveDirection" then
		local moveR = u.attr.move
		if param~=nil then
			moveR = math.max(1,__AnalyzeValueExpr(self,u,param,"number"))
		end
		local mGrid = u:getmovegrid(999)
		local mGridF = u:getmovegrid(moveR,1)
		local cGrid = u:getcrossgrid(mGrid,mGridF)
		local gridX,gridY = hApi.SelectMoveGrid(u,cGrid,d.gridX,d.gridY)
		if gridX then
			d.gridX,d.gridY = gridX,gridY
		else
			d.gridX,d.gridY = u.data.gridX,u.data.gridY
		end
	end
	return self:doNextAction()
end

__aCodeList["RoundState"] = function(self,_,state)
	if type(state)=="number" then
		local d = self.data
		local u = d.unit
		u:setroundstate(state)
	else
		_DEBUG_MSG("未知的RoundState",self.data.skillId)
	end
	return self:doNextAction()
end

--清除所有攻击力附加
__aCodeList["ClearDamage"] = function(self,_,percent)
	local d = self.data
	d.dMin = 0
	d.dMax = 0
	return self:doNextAction()
end

__aCodeList["AddDamage"] = function(self,_,dMin,dMax)
	local d = self.data
	local v = hApi.getint(__AnalyzeValueExpr(self,d.unit,dMin,"number"))
	d.dMin = d.dMin + v
	if dMax==nil or dMin==dMax then
		d.dMax = d.dMax + v
	else
		d.dMax = d.dMax + hApi.getint(__AnalyzeValueExpr(self,d.unit,dMax,"number"))
	end
	return self:doNextAction()
end

--读取单位的攻击力
--geyachao: 注释：percent 百分比
__aCodeList["LoadAttack"] = function(self,_, percent, IsShowPlus)
	local d = self.data
	local u = d.unit
	
	--if (type(percent) == "string") then
	--	percent = d.tempValue[percent] --读temp表里的值
	--end
	
	if u~=0 then
		percent = __AnalyzeValueExpr(self,u,percent or 100,"number")
		local _,_,_,dMinU,dMaxU = unpack(u.attr.attack)
		--print(u.data.name, "dMinU", dMinU, "dMaxU", dMaxU)
		--print(u.data.name, "percent", percent)
		--geyachao: 攻击力附加buff的属性
		local atk_item = u.attr.atk_item --道具附加攻击力
		local atk_buff = u.attr.atk_buff --buff附加攻击力
		local atk_aura = u.attr.atk_aura --光环附加攻击力
		local atk_tactic = u.attr.atk_tactic --战术技能卡附加攻击力
		local atk_other_sum = atk_item + atk_buff + atk_aura + atk_tactic --其它攻击力值
		
		--if (self.data.skillId == 12027) then
		--	print(dMinU, dMaxU)
		--	print(atk_item, atk_buff, atk_aura,atk_tactic )
		--end
		
		dMinU = dMinU + atk_other_sum
		dMaxU = dMaxU + atk_other_sum
		if (dMinU < 0) then
			dMinU = 0
		end
		if (dMaxU < 0) then
			dMaxU = 0
		end
		--print(u.data.name, "LoadAttack before", atk_item, atk_buff, atk_aura, atk_tactic)
		d.dMin = d.dMin + hApi.floor(dMinU*percent/100)
		d.dMax = d.dMax + hApi.floor(dMaxU*percent/100)
		--print(u.data.name, "LoadAttack", d.dMin, d.dMax, dMinU, dMaxU)
		--如果单位拥有额外的攻击力计算方式
		if type(u.attr.AttackBounceEx)=="table" and d.skillId~=0 and hVar.tab_skill[d.skillId] then
			local tBounce = u.attr.AttackBounceEx
			local cast_type = hVar.tab_skill[d.skillId].cast_type
			local AttackEx = 0
			for i = 1,#tBounce do
				local v = tBounce[i]
				local NeedCheck = 0
				local BounceKey = v[1]
				local BounceCast = v[2]
				local BounceType = v[3]
				local BounceValue = v[4]
				local BounceMax = v[5] or 999999
				if BounceCast=="Cast" then
					if d.IsAttack==0 then
						NeedCheck = 1
					end
				elseif BounceCast=="Attack" then
					if d.IsAttack==1 then
						NeedCheck = 1
					end
				else
					NeedCheck = 1
				end
				if NeedCheck==1 and type(BounceValue)=="number" then
					if BounceType=="DefMinus" then
						local t = d.target
						--防御差值
						if cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT and t~=0 then
							local n = math.min(BounceMax,hApi.floor(math.abs(u.attr.def-t.attr.def)*BounceValue/100))
							if n>0 then
								AttackEx = AttackEx + n
							end
						end
					elseif BounceType=="CurHp" then
						--当前生命
						local n = math.min(BounceMax,hApi.floor(u.attr.hp*BounceValue/100))
						if n>0 then
							AttackEx = AttackEx + n
						end
					end
				end
			end
			if AttackEx~=0 then
				d.dMin = d.dMin + hApi.floor(AttackEx*percent/100)
				d.dMax = d.dMax + hApi.floor(AttackEx*percent/100)
				if hGlobal.LocalPlayer:getfocusworld()==d.world and d.IsShowPlus>=0 then
					d.IsShowPlus = d.IsShowPlus + 1
					hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,u,"AtkBounce",AttackEx)
				end
			end
		end
	end
	return self:doNextAction()
end

--读取单位的tag属性是否boss
__aCodeList["LoadTag_IsBoss"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local nIsBoss = 0 --是否为boss
	if unit then
		--local tTypeId = unit.data.id --类型id
		local tag = unit.attr.tag
		if tag and (type(tag) == "table") then
			if (tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]) then
				nIsBoss = 1
			end
		end
	end
	
	--存储
	d.tempValue[param] = nIsBoss
	
	--for k, v in pairs(d.tempValue) do
	--	print(k, v)
	--end
	
	return self:doNextAction()
end

--读取单位的tag属性是否精英怪
__aCodeList["LoadTag_IsElite"] = function(self, _, targetType, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local nIsElite = 0 --是否为精英怪
	if unit then
		--local tTypeId = unit.data.id --类型id
		local tag = unit.attr.tag
		if tag and (type(tag) == "table") then
			if (tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_ELITE]) then
				nIsElite = 1
			end
		end
	end
	
	--存储
	d.tempValue[param] = nIsElite
	
	--for k, v in pairs(d.tempValue) do
	--	print(k, v)
	--end
	
	return self:doNextAction()
end

--读取当前战场是否有BOSS存在
__aCodeList["IsBossExist_Diablo"] = function(self, _, param)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = hGlobal.WORLD.LastWorldMap
	
	local nIsBossExist = 0
	
	w:enumunit(function(eu)
		if (eu:getowner():getforce() ~= hVar.FORCE_DEF.SHU) then --不是蜀国
			local tag = eu.attr.tag
			if tag and (type(tag) == "table") then
				if (tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]) then
					nIsBossExist = 1
				end
			end
		end
	end)
	
	--存储
	d.tempValue[param] = nIsBossExist
	
	--for k, v in pairs(d.tempValue) do
	--	print(k, v)
	--end
	
	return self:doNextAction()
end

--设置单位的攻击加成方式{key,cast,type,val,valMax}
__aCodeList["SetAttackBounce"] = function(self,_,mode,tBounceParam)
	local d = self.data
	local u
	if mode=="unit" then
		u = self.data.unit
	elseif mode=="target" then
		u = self.data.target
	end
	if u and u~=0 and type(tBounceParam)=="table" then
		if type(u.attr.AttackBounceEx)~="table" then
			u.attr.AttackBounceEx = {}
		end
		local tBounce = u.attr.AttackBounceEx
		local InsertI = #tBounce+1
		for i = 1,#tBounce do
			if tBounce[i][1]==tBounceParam[1] and tBounce[i][2]==tBounceParam[2] then
				InsertI = i
				break
			end
		end
		u.attr.AttackBounceEx[InsertI] = hApi.ReadParamWithDepth(tBounceParam,nil,{})
	end
	return self:doNextAction()
end

--读取英雄属性
__aCodeList["LoadHeroAttr"] = function(self,_,attrName,percent)
	local d = self.data
	local u = d.unit
	if u~=0 then
		local h = u:gethero()
		if h and type(h.attr[attrName])=="number" then
			percent = __AnalyzeValueExpr(self,u,percent or 100,"number")
			local v = h.attr[attrName]
			d.dMin = d.dMin + hApi.getint(v*percent/100)
			d.dMax = d.dMax + hApi.getint(v*percent/100)
		end
	end
	return self:doNextAction()
end

local __DamageData = {}
local __oTargetCur = nil
local __ENUM__ShiftTarget = function(oAction)
	local id = oAction.data.skillId
	local u = oAction.data.unit
	local tState = oAction.data.BuffState
	if type(tState)=="table" and u~=0 and u.data.IsDead~=1 then
		for i = 1,#tState do
			if tState[i]~=0 and tState[i][2]=="damagelink" then
				__oTargetCur = oAction.data.unit
				return
			end
		end
	end
end

--geyachao: 添加注释
--如果之前调用"LoadAttack"，该伤害也会算进内
__aCodeList["__DamageTarget"] = function(self,_,target, nDmgMode,dMin,dMax,nPowerEx)
	--print("__DamageTarget", nDmgMode,dMin,dMax)
	local d = self.data
	local u = d.unit
	--print("__DamageTarget", u.data.name)
	local w = u:getworld()
	local t = target or d.target
	if (type(dMin) == "string") then
		dMin = d.tempValue[dMin] --读temp表里的值
	end
	if (type(dMax) == "string") then
		dMax = d.tempValue[dMax] --读temp表里的值
	end
	--print(self.data.id, target.data.name, nDmgMode,dMin,dMax,nPowerEx)
	
	if t~=0 and t.data.IsDead~=1 then
		--如果被闪避，那么不造成伤害
		if d.IsFlee==1 and t==d.targetC and t.attr.flee>0 and t.attr.fleecount>0 then
			if t.handle._n then
				local tickMy = t.handle.__IsSpriteMoved or 0
				local tickCur = w:gametime()
				if tickMy==0 or tickCur>tickMy then
					t.handle.__IsSpriteMoved = math.max(tickMy,tickCur + 200)	--有这个变量的单位需要还原.handle.s的位置
					local array = CCArray:create()
					array:addObject(CCMoveBy:create(0.01,ccp(-16,0)))
					array:addObject(CCDelayTime:create(0.06))
					array:addObject(CCMoveBy:create(0.02,ccp(32,0)))
					array:addObject(CCDelayTime:create(0.06))
					array:addObject(CCMoveBy:create(0.02,ccp(-16,0)))
					t.handle.s:runAction(CCSequence:create(array))
				end
			end
			hGlobal.event:event("LocalEvent_UnitAddAttrByAction",self,t,"dodge")
			return
		end
		--[[
		local tabS = hVar.tab_skill[d.skillId]
		if tabS and tabS.static_damage==1 then
			--造成绝对数值的伤害，不计算堆叠
			local _dMin = math.min(d.dMin,d.dMax)
			local _dMax = math.max(d.dMin,d.dMax)
			dMin = dMin+_dMin
			dMax = dMax+_dMax
		else
		]]
			--普通类型的伤害
			local nPower = 100
			if nDmgMode<0 then
				--伤害模式小于0时不计算加成
				--伤害模式小于0时也不受护甲减免
			else
				nPower = d.power
				if nPowerEx and type(nPowerEx)=="number" then
					nPower = hApi.floor(nPower*nPowerEx/100)
				end
			end
			local _dMin = math.min(d.dMin,d.dMax)
			local _dMax = math.max(d.dMin,d.dMax)
			if t.attr.DamageLink>0 then
				__oTargetCur = t
				t:enumbuff(__ENUM__ShiftTarget)
				t = __oTargetCur
			end
			--print("__DamageTarget000", nDmgMode,dMin,dMax, d.dMin,d.dMax)
			dMin,dMax = u:calculate("CombatDamage",t,dMin+_dMin,dMax+_dMax,nPower,d.skillId,nDmgMode,d.IsAttack)
		--[[
		end
		]]
		
		--计算伤害
		local nDmg = 0
		if type(dMin)=="number" and type(dMax)=="number" then
			nDmg = w:random(dMin,dMax,"dmg")
		end
		if type(d.tempValue["@dmgCount"])=="number" then
			local tDamageData = {}
			hGlobal.event:call("Event_UnitDamaged",t,d.skillId,nDmgMode,nDmg,0,u,tDamageData, u:getowner():getforce(), u:getowner():getpos())
			if tDamageData.dmg>0 then
				d.tempValue["@dmgCount"] = d.tempValue["@dmgCount"] + tDamageData.dmg
			end
		else
			hGlobal.event:call("Event_UnitDamaged",t,d.skillId,nDmgMode,nDmg,0,u, nil, u:getowner():getforce(), u:getowner():getpos())
		end
	end
end

__aCodeList["__HealTarget"] = function(self,_,target,nDmgMode,dMin,dMax,nPowerEx)
	local d = self.data
	local u = d.unit
	local t = target or d.target
	local w = u:getworld()
	if t~=0 and t.data.IsDead~=1 then
		--[[
		local tabS = hVar.tab_skill[d.skillId]
		if tabS and tabS.static_damage==1 then
			--造成绝对数值的治疗，不计算堆叠也不受伤害加成或减益
			local _dMin = math.min(d.dMin,d.dMax)
			local _dMax = math.max(d.dMin,d.dMax)
			dMin = dMin+_dMin
			dMax = dMax+_dMax
		else
		]]
			local nPower = 100
			if nDmgMode>=0 then	--伤害模式为小于0时不计算加成
				nPower = d.power
				if nPowerEx and type(nPowerEx)=="number" then
					nPower = hApi.floor(nPower*nPowerEx/100)
				end
			end
			local _dMin,_dMax = d.dMin,math.max(d.dMin,d.dMax)
			dMin,dMax = u:calculate("HealDamage",t,dMin+_dMin,dMax+_dMax,nPower,d.skillId,nDmgMode)
		--[[
		end
		]]
		--计算治疗效果
		local nDmg = 0
		if type(dMin)=="number" and type(dMax)=="number" then
			nDmg = w:random(dMin,dMax,"heal")
		end
		if type(d.tempValue["@healCount"])=="number" then
			local tDamageData = {}
			hGlobal.event:call("Event_UnitHealed",t,d.skillId,nDmgMode,nDmg,0,u,tDamageData)
			if tDamageData.dmg<0 then
				d.tempValue["@healCount"] = d.tempValue["@healCount"] - tDamageData.dmg
			end
		else
			hGlobal.event:call("Event_UnitHealed",t,d.skillId,nDmgMode,nDmg,0,u)
		end
	end
end

--造成伤害
__aCodeList["Damage"] = function(self,_,nDmgMode,dMin,dMax)
	local d = self.data
	local t = self.data.target
	if t==0 then
		t = self.data.unit
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	__aCodeList["__DamageTarget"](self,"__DamageTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

--对自己造成伤害
__aCodeList["DamageSelf"] = function(self,_,nDmgMode,dMin,dMax)
	local t = self.data.unit
	__aCodeList["__DamageTarget"](self,"__DamageTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

--造成治疗
__aCodeList["Heal"] = function(self,_,nDmgMode,dMin,dMax)
	local t = self.data.target
	if t==0 then
		t = self.data.unit
	end
	__aCodeList["__HealTarget"](self,"__HealTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

__aCodeList["HealSelf"] = function(self,_,nDmgMode,dMin,dMax)
	local t = self.data.unit
	__aCodeList["__HealTarget"](self,"__HealTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end
-------------------------------------------------------------------------------
--function:	Spirite跳动(自动回落)
--parameter:	(self, _, 时间，高度)
--writer:	pangyong 2015/5/7
-------------------------------------------------------------------------------
__aCodeList["Jump"] = function(self,_, fTime, nHeight)
	--[快速模式不做任何表现性操作]
	if self.data.IsQuickAction == 1 then
		return self:doNextAction()
	end

	--[获取特效目标unit]
	local t = self.data.target
	if t == 0 or t.ID == self.data.unit.ID then									--如果特效施加在自己身上，则不进行跳动
		return self:doNextAction()
	end
	
	--[设定动作(跳动)]
	local array = CCArray:create()											--创建动作数组
	array:addObject( CCJumpBy:create(fTime, ccp(t.handle.s:getPositionX(), t.handle.s:getPositionY()), nHeight, 1) )--跳动函数（参数：完成时间（单位：s）, 初始位置， 高度， 次数）	
	
	--[执行动作组]
	t.handle.s:runAction(CCSequence:create(array))
	
	return self:doNextAction()
end

--造成战斗伤害
--会遭受反击
__aCodeList["CombatDamage"] = function(self,_,nDmgMode,dMin,dMax)
	local d = self.data
	local t = d.target
	
	--print("造成战斗伤害", self.data.unit.data.name, t.data.name, d.target:getworldC(), d.target_worldC)
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	__aCodeList["__DamageTarget"](self,"__DamageTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

--创建连接特效
__aCodeList["AddLinkEffect_TD"] = function(self, _, param, strEffectFileName, offsetX, offsetY, tdx, tdy, amplitude)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(offsetX) == "string") then
		--offsetX = self.data.tempValue[offsetX]
		offsetX = __AnalyzeValueExpr(self, d.unit, offsetX, "number")
	end
	
	if (type(offsetY) == "string") then
		--offsetY = self.data.tempValue[offsetY]
		offsetY = __AnalyzeValueExpr(self, d.unit, offsetY, "number")
	end
	
	if (type(tdx) == "string") then
		--tdx = self.data.tempValue[tdx]
		tdx = __AnalyzeValueExpr(self, d.unit, tdx, "number")
	end
	
	if (type(tdy) == "string") then
		--tdy = self.data.tempValue[tdy]
		tdy = __AnalyzeValueExpr(self, d.unit, tdy, "number")
	end
	
	if (type(amplitude) == "string") then
		--amplitude = self.data.tempValue[amplitude]
		amplitude = __AnalyzeValueExpr(self, d.unit, amplitude, "number")
	end
	
	--初始化
	d.tempValue[param] = 0
	
	if u and (u ~= 0) and (u.data.IsDead ~= 1) and t and (t ~= 0) and (t.data.IsDead ~= 1) then
		local linkId = w:AddLinkEffect(u, t, strEffectFileName, offsetX, offsetY, tdx, tdy, amplitude)
		d.tempValue[param] = linkId
	end
	
	return self:doNextAction()
end

--创建连接特效（指定单位id）
__aCodeList["AddLinkEffect_Diablo"] = function(self, _, t_worldIA, t_worldIB, param, strEffectFileName, offsetX, offsetY, tdx, tdy, amplitude)
	local w = self.data.world
	local d = self.data
	--local u = d.unit
	--local t = d.target
	
	
	--参数支持字符串类型
	if (type(t_worldIA) == "string") then
		t_worldIA = d.tempValue[t_worldIA]
	end
	
	--参数支持字符串类型
	if (type(t_worldIB) == "string") then
		t_worldIB = d.tempValue[t_worldIB]
	end
	
	if (type(offsetX) == "string") then
		--offsetX = self.data.tempValue[offsetX]
		offsetX = __AnalyzeValueExpr(self, d.unit, offsetX, "number")
	end
	
	if (type(offsetY) == "string") then
		--offsetY = self.data.tempValue[offsetY]
		offsetY = __AnalyzeValueExpr(self, d.unit, offsetY, "number")
	end
	
	if (type(tdx) == "string") then
		--tdx = self.data.tempValue[tdx]
		tdx = __AnalyzeValueExpr(self, d.unit, tdx, "number")
	end
	
	if (type(tdy) == "string") then
		--tdy = self.data.tempValue[tdy]
		tdy = __AnalyzeValueExpr(self, d.unit, tdy, "number")
	end
	
	if (type(amplitude) == "string") then
		--amplitude = self.data.tempValue[amplitude]
		amplitude = __AnalyzeValueExpr(self, d.unit, amplitude, "number")
	end
	
	--初始化
	d.tempValue[param] = 0
	
	local u = hClass.unit:getChaByWorldI(t_worldIA)
	--print("u=", u and u.data.name)
	
	local t = hClass.unit:getChaByWorldI(t_worldIB)
	--print("t=", t and t.data.name)
	
	if u and (u ~= 0) and (u.data.IsDead ~= 1) and t and (t ~= 0) and (t.data.IsDead ~= 1) then
		local linkId = w:AddLinkEffect(u, t, strEffectFileName, offsetX, offsetY, tdx, tdy, amplitude)
		d.tempValue[param] = linkId
	end
	
	return self:doNextAction()
end

--geyachao: 获得单位到目标的角度
__aCodeList["GetLineAngle_TD"] = function(self, _, param, fromX, fromY, toX, toY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	if (type(fromX) == "string") then
		--fromX = d.tempValue[fromX]
		fromX = __AnalyzeValueExpr(self, u, fromX, "number")
	end
	
	if (type(fromY) == "string") then
		--fromY = d.tempValue[fromY]
		fromY = __AnalyzeValueExpr(self, u, fromY, "number")
	end
	
	if (type(toX) == "string") then
		--toX = d.tempValue[toX]
		toX = __AnalyzeValueExpr(self, u, toX, "number")
	end
	
	if (type(toY) == "string") then
		--toY = d.tempValue[toY]
		toY = __AnalyzeValueExpr(self, u, toY, "number")
	end
	
	--print("from", fromX, fromY)
	--print("to", toX, toY)
	
	--默认存储为0
	if param then
		local angle = GetLineAngle(fromX, fromY, toX, toY) --角度制
		d.tempValue[param] = 360 - angle
		--print("angle", 360 - angle)
	end
	
	return self:doNextAction()
end

--创建钩子特效
__aCodeList["AddHookEffect_TD"] = function(self, _, beginAngle, flySpeed, flyTime, offsetX, offsetY, targetType, hitSkillId, hitSkillLv, movetoSkillId, movetoSkillLv)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		--offsetX = self.data.tempValue[offsetX]
		offsetX = __AnalyzeValueExpr(self, d.unit, offsetX, "number")
	end
	
	if (type(offsetY) == "string") then
		--offsetY = self.data.tempValue[offsetY]
		offsetY = __AnalyzeValueExpr(self, d.unit, offsetY, "number")
	end
	
	if (type(beginAngle) == "string") then
		--beginAngle = self.data.tempValue[beginAngle]
		beginAngle = __AnalyzeValueExpr(self, d.unit, beginAngle, "number")
	end
	
	if (type(flySpeed) == "string") then
		--flySpeed = self.data.tempValue[flySpeed]
		flySpeed = __AnalyzeValueExpr(self, d.unit, flySpeed, "number")
	end
	
	if (type(flyTime) == "string") then
		--flyTime = self.data.tempValue[flyTime]
		flyTime = __AnalyzeValueExpr(self, d.unit, flyTime, "number")
	end
	
	if (type(hitSkillId) == "string") then
		--hitSkillId = self.data.tempValue[hitSkillId]
		hitSkillId = __AnalyzeValueExpr(self, d.unit, hitSkillId, "number")
	end
	
	if (type(hitSkillLv) == "string") then
		--hitSkillLv = self.data.tempValue[hitSkillLv]
		hitSkillLv = __AnalyzeValueExpr(self, d.unit, hitSkillLv, "number")
	end
	
	if (type(movetoSkillId) == "string") then
		--movetoSkillId = self.data.tempValue[movetoSkillId]
		movetoSkillId = __AnalyzeValueExpr(self, d.unit, movetoSkillId, "number")
	end
	
	if (type(movetoSkillLv) == "string") then
		--movetoSkillLv = self.data.tempValue[movetoSkillLv]
		movetoSkillLv = __AnalyzeValueExpr(self, d.unit, movetoSkillLv, "number")
	end
	
	if u and (u ~= 0) and (u.data.IsDead ~= 1) then
		--自己的坐标
		local selfX, selfY = hApi.chaGetPos(u.handle)
		w:AddHookEffect(u, d.skillId, selfX + offsetX, selfY + offsetY, beginAngle, flySpeed, flyTime, targetType, hitSkillId, hitSkillLv, movetoSkillId, movetoSkillLv)
	end
	
	return self:doNextAction()
end

--删除连接特效
__aCodeList["RemoveLinkEffect_TD"] = function(self, _, linkId)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	if (type(linkId) == "string") then
		linkId = self.data.tempValue[linkId]
	end
	
	w:RemoveLinkEffect(linkId)
	
	return self:doNextAction()
end
--造成战斗伤害
--不会遭受反击
__aCodeList["MeleeDamage"] = function(self,_,nDmgMode,dMin,dMax)
	local d = self.data
	local t = d.target
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	__aCodeList["__DamageTarget"](self,"__DamageTarget",t,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

--造成远程伤害
--一般不会遭受反击
--geyachao: 添加注释 dMin, dMax 额外的伤害范围
__aCodeList["ShootDamage"] = function(self, _, nDmgMode, dMin, dMax)
	local d = self.data
	
	--print(nDmgMode,dMin,dMax, dd .. dd)
	--geyachao: 支持传入参数
	if (type(dMin) == "string") then
		dMin = self.data.tempValue[dMin]
	end
	if (type(dMax) == "string") then
		dMax = self.data.tempValue[dMax]
	end
	
	--geyachao: 检测目标是否还是原来的(防止目标死亡后被复用)
	if (d.target) and (d.target ~= 0) and (d.target:getworldC() ~= d.target_worldC) then --不是同一个目标了
		return "release", 1
	end
	
	__aCodeList["__DamageTarget"](self,"__DamageTarget",self.data.target,nDmgMode,dMin,dMax)
	return self:doNextAction()
end

--造成范围治疗
local __HealCode = __aCodeList["__HealTarget"]
__aCodeList["HealArea"] = function(self,_,nDmgMode,dMin,dMax,rMin,rMax,tDmgPec)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	if not(rMin and rMax) then
		rMin,rMax = d.rMin,d.rMax
	end
	local p = u:getowner()
	local id = d.skillId
	if tDmgPec and type(tDmgPec)=="table" then
		--需要处理分层伤害
		local IsHitCenter = 0
		if d.areaMode==1 then
			w:enumunitUR(u,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t)==hVar.RESULT_SUCESS then
					if t==d.target then
						IsHitCenter = 1
					elseif #tDmgPec>1 then
						local v = w:distanceU(t,nil,1,d.gridX,d.gridY)
						if v<=0 then
							v = 1
						end
						__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax,tDmgPec[v+1] or tDmgPec[#tDmgPec])
					else
						__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax)
					end
				end
			end)
		else
			w:enumunitR(d.gridX,d.gridY,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t)==hVar.RESULT_SUCESS then
					if t==d.target then
						IsHitCenter = 1
					elseif #tDmgPec>1 then
						local v = w:distanceU(t,nil,1,d.gridX,d.gridY)
						if v<=0 then
							v = 1
						end
						__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax,tDmgPec[v+1] or tDmgPec[#tDmgPec])
					else
						__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax)
					end
				end
			end)
		end
		if IsHitCenter==1 and d.target~=0 and tDmgPec[1]~=0 then
			__HealCode(self,"__HealTarget",d.target,nDmgMode,dMin,dMax,tDmgPec[1])
		end
	else
		if d.areaMode==1 then
			w:enumunitUR(u,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t)==hVar.RESULT_SUCESS then
					__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax)
				end
			end)
		else
			w:enumunitR(d.gridX,d.gridY,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t)==hVar.RESULT_SUCESS then
					__HealCode(self,"__HealTarget",t,nDmgMode,dMin,dMax)
				end
			end)
		end
	end
	return self:doNextAction()
end

--设置技能范围模式
__aCodeList["SetAreaMode"] = function(self,_,nMode)
	local d = self.data
	if type(nMode)=="number" then
		d.areaMode = nMode
	end
	return self:doNextAction()
end

--造成范围伤害
local __DamageCode = __aCodeList["__DamageTarget"]
__aCodeList["DamageArea"] = function(self,_,nDmgMode,dMin,dMax,rMin,rMax,tDmgPec)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local g = {}
	if not(rMin and rMax) then
		rMin,rMax = d.rMin,d.rMax
	end
	local p = u:getowner()
	local id = d.skillId
	local oCenterUnit
	if d.areaMode==1 then
		--以自身为目标释放
		oCenterUnit = d.unit
	elseif d.areaMode==2 then
		--附着在单位身上的，用这种
		if d.targetC~=0 then
			oCenterUnit = d.targetC
		end
	end
	if tDmgPec and type(tDmgPec)=="table" then
		--需要处理分层伤害
		local IsHitCenter = 0
		if oCenterUnit~=nil then
			w:enumunitUR(oCenterUnit,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t,d.targetC)==hVar.RESULT_SUCESS then
					if t==d.target then
						IsHitCenter = 1
					elseif #tDmgPec>1 then
						local v = w:distanceU(t,nil,1,d.gridX,d.gridY)
						if v<=0 then
							v = 1
						end
						__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax,tDmgPec[v+1] or tDmgPec[#tDmgPec])
					else
						__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax)
					end
				end
			end)
		else
			w:enumunitR(d.gridX,d.gridY,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t,d.targetC)==hVar.RESULT_SUCESS then
					if t==d.target then
						IsHitCenter = 1
					elseif #tDmgPec>1 then
						local v = w:distanceU(t,nil,1,d.gridX,d.gridY)
						if v<=0 then
							v = 1
						end
						__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax,tDmgPec[v+1] or tDmgPec[#tDmgPec])
					else
						__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax)
					end
				end
			end)
		end
		if IsHitCenter==1 and d.target~=0 and tDmgPec[1]~=0 then
			__DamageCode(self,"__DamageTarget",d.target,nDmgMode,dMin,dMax,tDmgPec[1])
		end
	else
		--无需处理分层伤害
		if oCenterUnit~=nil then
			w:enumunitUR(oCenterUnit,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t,d.targetC)==hVar.RESULT_SUCESS then
					__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax)
				end
			end)
		else
			w:enumunitR(d.gridX,d.gridY,rMin,rMax,function(t)
				if hApi.IsSafeTarget(u,id,t,d.targetC)==hVar.RESULT_SUCESS then
					__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax)
				end
			end)
		end
	end
	return self:doNextAction()
end

--geyachao: 新加标记目标周围的与目标敌对势力的敌人数量，存储起来
__aCodeList["RecordAreaT_TD"] = function(self,_, rMin, rMax, offsetX, offsetY)
	local d = self.data
	local t = d.target --目标
	local w = t:getworld()
	
	if (not rMin) then
		rMin = d.rMin
	end
	
	if (not rMax) then
		rMax = d.rMax
	end
	
	if (type(rMin) == "string") then
		rMin = self.data.tempValue[rMin]
	end
	
	if (type(rMax) == "string") then
		rMax = self.data.tempValue[rMax]
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = self.data.tempValue[offsetX]
	end
	
	if (type(offsetY) == "string") then
		offsetY = self.data.tempValue[offsetY]
	end
	
	--自己的坐标
	local selfX, selfY = hApi.chaGetPos(t.handle)
	
	--目标的阵营
	local unitSide = t:getowner():getforce() --应该作用的阵营 --目标的属方阵营
	
	--在范围内
	local enemylist = t.data.talkTag
	if (enemylist == nil) or (enemylist == 0) then
		enemylist = {num=0,}
		t.data.talkTag = enemylist
	end
	
	--遍历所有的角色
	local num = 0
	--local world = hGlobal.WORLD.LastWorldMap
	--w:enumunit(function(eu)
	--w:enumunitArea(selfX + offsetX, selfY + offsetY, rMax, function(eu)
	w:enumunitAreaEnemy(unitSide, selfX + offsetX, selfY + offsetY, rMax, function(eu)
		--目标的阵营
		local targetSide = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		local cast_target_type = hVar.tab_skill[d.skillId].cast_target_type --技能可生效的目标的类型
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色、敌方阵营
			if (eu.data.IsDead ~= 1) and (targetSide ~= unitSide) then
				--在范围内
				num = num + 1
				enemylist[num] = eu
				enemylist[-num] = eu:getworldC() --同时存储唯一id，防止角色被复用，检测
				--print("敌人" .. num .. ": " .. eu.data.name)
			end
		end
	end)
	
	enemylist.num = num
	--print("敌人", t.data.name, t.data.talkTag)
	
	return self:doNextAction()
end
--geyachao: 新加对施法位置范围的敌人造成伤害
--造成范围伤害
__aCodeList["DamageArea_Ground"] = function(self,_,nDmgMode, dMin ,dMax, rMin, rMax, offsetX, offsetY)
	--print("DamageArea_Ground", nDmgMode, dMin ,dMax, rMin, rMax, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	if (not rMin) then
		rMin = d.rMin
	end
	
	if (not rMax) then
		rMax = d.rMax
	end
	
	if (type(rMin) == "string") then
		rMin = self.data.tempValue[rMin]
	end
	
	if (type(rMax) == "string") then
		rMax = self.data.tempValue[rMax]
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = self.data.tempValue[offsetX]
	end
	
	if (type(offsetY) == "string") then
		offsetY = self.data.tempValue[offsetY]
	end
	
	if (type(dMin) == "string") then
		dMin = self.data.tempValue[dMin]
	end
	
	if (type(dMax) == "string") then
		dMax = self.data.tempValue[dMax]
	end
	
	--施法者的阵营
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	--加入伤害处理效率优化表
	--w:addDamageAreaPerf(u, d.skillId, nDmgMode, d.dMin + dMin, d.dMax + dMax, rMax, d.worldX + offsetX, d.worldY + offsetY)
	w:enumunitAreaEnemy(unitSide, d.worldX + offsetX, d.worldY + offsetY, rMax, function(eu)
		--目标的阵营
		local targetSide = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色、敌方阵营
			if (eu.data.IsDead ~= 1) and (targetSide ~= unitSide) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					]]
					
					--判断矩形和圆是否相交
					--[[
					if hApi.CircleIntersectRect(selfX + offsetX, selfY + offsetY, rMax, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在范围内
					]]
						--伤害
						__DamageCode(self, "__DamageTarget", eu, nDmgMode, dMin, dMax)
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 新加对施法位置范围的友军造成伤害
--造成范围伤害
__aCodeList["DamageArea_ALLY_Ground"] = function(self,_,nDmgMode, dMin ,dMax, rMin, rMax, offsetX, offsetY, bDamageSelf)
	--print("DamageArea_Ground", nDmgMode, dMin ,dMax, rMin, rMax, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	if (not rMin) then
		rMin = d.rMin
	end
	
	if (not rMax) then
		rMax = d.rMax
	end
	
	if (type(rMin) == "string") then
		rMin = self.data.tempValue[rMin]
	end
	
	if (type(rMax) == "string") then
		rMax = self.data.tempValue[rMax]
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = self.data.tempValue[offsetX]
	end
	
	if (type(offsetY) == "string") then
		offsetY = self.data.tempValue[offsetY]
	end
	
	--施法者的阵营
	local unitSide = u:getowner():getforce() --施法者的属方阵营
	
	--遍历所有的角色
	--w:enumunit(function(eu)
	--w:enumunitArea(d.worldX + offsetX, d.worldY + offsetY, rMax, function(eu)
	w:enumunitAreaAlly(unitSide, d.worldX + offsetX, d.worldY + offsetY, rMax, function(eu)
		--目标的阵营
		local targetSide = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、非NPC、非NPC对话物、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.NPC) and(subType ~= hVar.UNIT_TYPE.NPC_TALK) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色、友方阵营
			if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) and (targetSide == unitSide) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					if hApi.CircleIntersectRect(d.worldX + offsetX, d.worldY + offsetY, rMax, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在范围内
					]]
						--伤害
						if (u == eu) then
							--对自己造成伤害
							if (bDamageSelf) then
								__DamageCode(self, "__DamageTarget", eu, nDmgMode, dMin, dMax)
							end
						else
							__DamageCode(self, "__DamageTarget", eu, nDmgMode, dMin, dMax)
						end
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 新加对施法者周围范围的敌人造成伤害
--造成范围伤害
__aCodeList["DamageAreaU_Ground"] = function(self,_,nDmgMode, dMin ,dMax, rMin, rMax, offsetX, offsetY)
	local d = self.data
	local u = d.unit --施法者
	local w = u:getworld()
	
	if (not rMin) then
		rMin = d.rMin
	end
	
	if (not rMax) then
		rMax = d.rMax
	end
	
	if (type(rMin) == "string") then
		rMin = self.data.tempValue[rMin]
	end
	
	if (type(rMax) == "string") then
		rMax = self.data.tempValue[rMax]
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = self.data.tempValue[offsetX]
	end
	
	if (type(offsetY) == "string") then
		offsetY = self.data.tempValue[offsetY]
	end
	
	--自己的坐标
	local selfX, selfY = hApi.chaGetPos(u.handle)
	
	--施法者的阵营
	local unitSide = u:getowner():getforce() --应该作用的阵营 --施法者的属方阵营
	
	--遍历所有的角色
	--local world = hGlobal.WORLD.LastWorldMap
	--w:enumunit(function(eu)
	--w:enumunitArea(selfX + offsetX, selfY + offsetY, rMax, function(eu)
	w:enumunitAreaEnemy(unitSide, selfX + offsetX, selfY + offsetY, rMax, function(eu)
		--目标的阵营
		local targetSide = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色、敌方阵营
			if (eu.data.IsDead ~= 1) and (targetSide ~= unitSide) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					]]
					
					--判断矩形和圆是否相交
					--[[
					if hApi.CircleIntersectRect(selfX + offsetX, selfY + offsetY, rMax, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在范围内
					]]
						--伤害
						__DamageCode(self, "__DamageTarget", eu, nDmgMode, dMin, dMax)
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 施法者自身和周围加buff
__aCodeList["CastBuffAreaU_TD"] = function(self, _, radius, targetType, buffId, nBuffLv, nBuffTime, bIsAddSelf, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local ownerForce = u:getowner():getforce() --应该作用的阵营
	
	if (targetType == "ALLY") then --友方
		--
	elseif (targetType == "ENEMY") then --敌方
		--ownerForce = 3 - ownerForce
	elseif (targetType == "ALL") then --全部
		--
	else
		_DEBUG_MSG("BuffAreaU_Ground(), targetType = " .. tostring(targetType) .. " 非法！")
		return self:doNextAction()
	end
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius] --读temp表里的值
	end
	if (type(nBuffLv) == "string") then
		nBuffLv = d.tempValue[nBuffLv] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	--遍历所有的角色
	--local world = hGlobal.WORLD.LastWorldMap
	local ox, oy = hApi.chaGetPos(u.handle) --施法者的位置
	--w:enumunit(function(eu)
	
	--阵营是否有效
	local enumunitAreaFunc = nil
	if (targetType == "ALLY") then --友方
		enumunitAreaFunc = w.enumunitAreaAlly
	elseif (targetType == "ENEMY") then --敌方
		enumunitAreaFunc = w.enumunitAreaEnemy
	elseif (targetType == "ALL") then --全部
		enumunitAreaFunc = w.enumunitArea
	end
	
	-- w:enumunitArea(ox + offsetX, oy + offsetY, radius, function(eu)
	enumunitAreaFunc(w, ownerForce, ox + offsetX, oy + offsetY, radius, function(eu)
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			local targetForce = eu:getowner():getforce() --目标的阵营
			
			if (eu.data.IsDead ~= 1) then --活着的角色
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					--是否直接在射程内
					if hApi.CircleIntersectRect(ox + offsetX, oy + offsetY, radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --相交
					--if hApi.CircleIntersectRect(d.worldX, d.worldY, rMax, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在范围内
					]]
					--有效阵营
					--if bSideEnable then
						if (eu == u) then --施法者自身
							if (bIsAddSelf == true) or (bIsAddSelf == 1) then
								__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
							end
						else
							__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
						end
					--end
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 施法者自身和周围释放技能
__aCodeList["CastSkillAreaU_TD"] = function(self, _, radius, targetType, skillId, nSkillLv, bIsAddSelf, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local ownerForce = u:getowner():getforce() --应该作用的阵营
	
	if (targetType == "ALLY") then --友方
		--
	elseif (targetType == "ENEMY") then --敌方
		--ownerForce = 3 - ownerForce
	elseif (targetType == "ALL") then --全部
		--
	else
		_DEBUG_MSG("CastSkillAreaU_TD(), targetType = " .. tostring(targetType) .. " 非法！")
		return self:doNextAction()
	end
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius] --读temp表里的值
	end
	if (type(nSkillLv) == "string") then
		nSkillLv = d.tempValue[nSkillLv] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	--遍历所有的角色
	--local world = hGlobal.WORLD.LastWorldMap
	local ox, oy = hApi.chaGetPos(u.handle) --施法者的位置
	--w:enumunit(function(eu)
	local gridX, gridY = w:xy2grid(ox + offsetX, oy + offsetY)
	local tCastParam = 
	{
		level = nSkillLv, --geyahcao: 技能等级
	}
	
	--阵营是否有效
	local enumunitAreaFunc = nil
	if (targetType == "ALLY") then --友方
		enumunitAreaFunc = w.enumunitAreaAlly
	elseif (targetType == "ENEMY") then --敌方
		enumunitAreaFunc = w.enumunitAreaEnemy
	elseif (targetType == "ALL") then --全部
		enumunitAreaFunc = w.enumunitArea
	end
	
	--w:enumunitArea(ox + offsetX, oy + offsetY, radius, function(eu)
	enumunitAreaFunc(w, ownerForce, ox + offsetX, oy + offsetY, radius, function(eu)
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		local tabS = hVar.tab_skill[skillId]
		local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		--geyachao: 在放技能时已经对targetType做了过滤，这里就不提前处理
		--if cast_target_type[subType] then
			local targetForce = eu:getowner():getforce() --目标的阵营
			
			if (eu.data.IsDead ~= 1) then --活着的角色
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					--是否直接在射程内
					if hApi.CircleIntersectRect(ox + offsetX, oy + offsetY, radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --相交
					--if hApi.CircleIntersectRect(d.worldX, d.worldY, rMax, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在范围内
					]]
					--有效阵营
					--if bSideEnable then
						if (eu == u) then --施法者自身
							if (bIsAddSelf == true) or (bIsAddSelf == 1) then
								hApi.CastSkill(u, skillId, -1, d.power, eu, gridX, gridY, tCastParam)
							end
						else
							hApi.CastSkill(u, skillId, -1, d.power, eu, gridX, gridY, tCastParam)
						end
					--end
					--[[
					end
					]]
				end
			end
		--end
	end)
	
	return self:doNextAction()
end

--geyachao: 目标自身和周围加buff
__aCodeList["CastBuffAreaT_TD"] = function(self, _, radius, targetType, buffId, nBuffLv, nBuffTime, bIsAddTarget, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local ownerForce = u:getowner():getforce() --应该作用的阵营
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius] --读temp表里的值
	end
	if (type(nBuffLv) == "string") then
		nBuffLv = d.tempValue[nBuffLv] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	if (targetType == "ALLY") then --友方
		--
	elseif (targetType == "ENEMY") then --敌方
		--ownerForce = 3 - ownerForce
	elseif (targetType == "ALL") then --全部
		--
	else
		_DEBUG_MSG("CastBuffAreaT_TD(), targetType = " .. tostring(targetType) .. " 非法！")
		return self:doNextAction()
	end
	
	--遍历所有的角色
	local tx, ty = hApi.chaGetPos(t.handle) --目标的位置
	--local world = hGlobal.WORLD.LastWorldMap
	
	--阵营是否有效
	local enumunitAreaFunc = nil
	if (targetType == "ALLY") then --友方
		enumunitAreaFunc = w.enumunitAreaAlly
	elseif (targetType == "ENEMY") then --敌方
		enumunitAreaFunc = w.enumunitAreaEnemy
	elseif (targetType == "ALL") then --全部
		enumunitAreaFunc = w.enumunitArea
	end
	
	--w:enumunit(function(eu)
	--w:enumunitArea(tx + offsetX, ty + offsetY, radius, function(eu)
	enumunitAreaFunc(w, ownerForce, tx + offsetX, ty + offsetY, radius, function(eu)
		--目标的阵营
		local targetForce = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色
			if (eu.data.IsDead ~= 1) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--local ex, ey = hApi.chaGetPos(eu.handle)
					--local tx, ty = hApi.chaGetPos(eu.handle)
					--local dx = tx - d.worldX
					--local dy = ty - d.worldY
					--local distance = math.sqrt(dx * dx + dy * dy) --距离
					
					--[[
					--if (distance <= radius) then --在范围内
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					--是否直接在射程内
					if hApi.CircleIntersectRect(tx + offsetX, ty + offsetY, radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --相交
					--if hApi.CircleIntersectRect(tx, ty, radius, ex, ey, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE) then --相交
					]]
					--有效阵营
					--if bSideEnable then
						if (eu == u) then --目标自身
							if (bIsAddTarget == true) or (bIsAddTarget == 1) then
								__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
							end
						else
							__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
						end
					--end
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 目标自身和周围释放技能
__aCodeList["CastSkillAreaT_TD"] = function(self, _, radius, targetType, skillId, nSkillLv, bIsAddTarget, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local ownerForce = u:getowner():getforce() --应该作用的阵营
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius] --读temp表里的值
	end
	if (type(nSkillLv) == "string") then
		nSkillLv = d.tempValue[nSkillLv] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	if (targetType == "ALLY") then --友方
		--
	elseif (targetType == "ENEMY") then --敌方
		--ownerForce = 3 - ownerForce
	elseif (targetType == "ALL") then --全部
		--
	else
		_DEBUG_MSG("CastSkillAreaT_TD(), targetType = " .. tostring(targetType) .. " 非法！")
		return self:doNextAction()
	end
	
	--遍历所有的角色
	local tx, ty = hApi.chaGetPos(t.handle) --目标的位置
	--local world = hGlobal.WORLD.LastWorldMap
	
	--阵营是否有效
	local enumunitAreaFunc = nil
	if (targetType == "ALLY") then --友方
		enumunitAreaFunc = w.enumunitAreaAlly
	elseif (targetType == "ENEMY") then --敌方
		enumunitAreaFunc = w.enumunitAreaEnemy
	elseif (targetType == "ALL") then --全部
		enumunitAreaFunc = w.enumunitArea
	end
	
	local gridX, gridY = w:xy2grid(tx + offsetX, ty + offsetY)
	local tCastParam = 
	{
		level = nSkillLv, --geyahcao: 技能等级
	}
	
	--w:enumunit(function(eu)
	--w:enumunitArea(tx + offsetX, ty + offsetY, radius, function(eu)
	enumunitAreaFunc(w, ownerForce, tx + offsetX, ty + offsetY, radius, function(eu)
		--目标的阵营
		local targetForce = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色
			if (eu.data.IsDead ~= 1) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--local ex, ey = hApi.chaGetPos(eu.handle)
					--local tx, ty = hApi.chaGetPos(eu.handle)
					--local dx = tx - d.worldX
					--local dy = ty - d.worldY
					--local distance = math.sqrt(dx * dx + dy * dy) --距离
					
					--[[
					--if (distance <= radius) then --在范围内
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					--是否直接在射程内
					if hApi.CircleIntersectRect(tx + offsetX, ty + offsetY, radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --相交
					--if hApi.CircleIntersectRect(tx, ty, radius, ex, ey, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE) then --相交
					]]
					--有效阵营
					--if bSideEnable then
						if (eu == u) then --目标自身
							if (bIsAddTarget == true) or (bIsAddTarget == 1) then
								hApi.CastSkill(u, skillId, -1, d.power, eu, gridX, gridY, tCastParam)
							end
						else
							hApi.CastSkill(u, skillId, -1, d.power, eu, gridX, gridY, tCastParam)
						end
					--end
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: TD在施法点周围加buff
__aCodeList["CastBuffAreaP_TD"] = function(self, _, radius, targetType, buffId, nBuffLv, nBuffTime, bIsAddSelf, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = u:getworld()
	
	local ownerForce = u:getowner():getforce() --应该作用的阵营
	
	if (type(radius) == "string") then
		radius = d.tempValue[radius] --读temp表里的值
	end
	if (type(nBuffLv) == "string") then
		nBuffLv = d.tempValue[nBuffLv] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	if (targetType == "ALLY") then --友方
		--
	elseif (targetType == "ENEMY") then --敌方
		--ownerForce = 3 - ownerForce
	elseif (targetType == "ALL") then --全部
		--
	else
		_DEBUG_MSG("CastBuffAreaP_TD(), targetType = " .. tostring(targetType) .. " 非法！")
		return self:doNextAction()
	end
	
	--遍历所有的角色
	--local wx, wy = d.worldX, d.worldY --施法点坐标
	--local world = hGlobal.WORLD.LastWorldMap
	
	--阵营是否有效
	local enumunitAreaFunc = nil
	if (targetType == "ALLY") then --友方
		enumunitAreaFunc = w.enumunitAreaAlly
	elseif (targetType == "ENEMY") then --敌方
		enumunitAreaFunc = w.enumunitAreaEnemy
	elseif (targetType == "ALL") then --全部
		enumunitAreaFunc = w.enumunitArea
	end
	
	--w:enumunit(function(eu)
	--w:enumunitArea(d.worldX + offsetX, d.worldY + offsetY, radius, function(eu)
	enumunitAreaFunc(w, ownerForce, d.worldX + offsetX, d.worldY + offsetY, radius, function(eu)
		--目标的阵营
		local targetForce = eu:getowner():getforce() --目标的属方阵营
		
		--目标是否为塔
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		local subType = eu.data.type --子类型
		--local tabS = hVar.tab_skill[d.skillId]
		--local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
		--local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
		local cast_target_type = d.cast_target_type --技能可生效的目标的类型
		local cast_target_space_type = d.cast_target_space_type --技能可生效的目标的空间类型
		
		--非塔、非建筑、替换物、出生点、路点
		--if (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (subType ~= hVar.UNIT_TYPE.BUILDING) and (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) and (subType ~= hVar.UNIT_TYPE.PLAYER_INFO) and (subType ~= hVar.UNIT_TYPE.WAY_POINT) then --非塔、非建筑、替换物、出生点、路点
		if cast_target_type[subType] then
			--活着的角色
			if (eu.data.IsDead ~= 1) then
				--目标与技能的空间类型一致
				--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
				if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
				or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
				then
					--检测是否在可攻击范围内
					--local ex, ey = hApi.chaGetPos(eu.handle)
					--local tx, ty = hApi.chaGetPos(eu.handle)
					--local dx = tx - d.worldX
					--local dy = ty - d.worldY
					--local distance = math.sqrt(dx * dx + dy * dy) --距离
					
					--if (distance <= radius) then --在范围内
					--[[
					local eu_x, eu_y = hApi.chaGetPos(eu.handle)
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
					local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --中心点x位置
					local eu_center_y = eu_y + (eu_by + eu_bh / 2) --中心点y位置
					
					--判断矩形和圆是否相交
					--是否直接在射程内
					if hApi.CircleIntersectRect(d.worldX + offsetX, d.worldY + offsetY, radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --相交
					--if hApi.CircleIntersectRect(wx, wy, radius, ex, ey, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE) then --相交
					]]
					--有效阵营
					--if bSideEnable then
						if (eu == u) then --施法者自身
							if (bIsAddSelf == true) or (bIsAddSelf == 1) then
								__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
							end
						else
							__CODE__CastBuff(self, u, eu, buffId, -1, d.power, nBuffLv, nBuffTime)
						end
					--end
					--[[
					end
					]]
				end
			end
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 角色头顶冒字
-- showTime（单位: 毫秒）
__aCodeList["BubbleText_TD"] = function(self, _, targetType, red, green, blue, tab_string_text, offsetX, offsetY, fontSize, showTime, modelTable, offsetZ, strFlag)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	red = red or 255
	green = green or 255
	blue = blue or 255
	
	if (type(offsetX) == "string") then
		offsetX = d.tempValue[offsetX] --读temp表里的值
	end
	
	if (type(offsetY) == "string") then
		offsetY = d.tempValue[offsetY] --读temp表里的值
	end
	
	if (type(offsetZ) == "string") then
		offsetZ = d.tempValue[offsetZ] --读temp表里的值
	end
	
	if (type(tab_string_text) == "table") then
		local strText = ""
		
		for i = 1, #tab_string_text, 1 do
			local text = tab_string_text[i]
			if (string.sub(text, 1, 1) == "@") then
				text = self.data.tempValue[text] --读temp表里的值
			elseif (hVar.tab_string[text] ~= nil) then --tab_string中有定义
				text = hVar.tab_string[text]
			end
			
			strText = strText .. text
		end
		
		tab_string_text = strText
	elseif (type(tab_string_text) == "string") then
		if (string.sub(tab_string_text, 1, 1) == "@") then
			tab_string_text = self.data.tempValue[tab_string_text] --读temp表里的值
		elseif (hVar.tab_string[tab_string_text] ~= nil) then --tab_string中有定义
			tab_string_text = hVar.tab_string[tab_string_text]
		end
	end
	
	if (type(showTime) == "string") then
		showTime = d.tempValue[showTime] --读temp表里的值
	end
	
	--oUnit, text, color, offsetX, offsetY, fontSize, showTime, modelTable, offsetZ, strFlag
	if (tab_string_text ~= nil) then
		hApi.ShowLabelBubble(unit, tab_string_text, ccc3(red, green, blue), offsetX, offsetY, fontSize, showTime, modelTable, offsetZ, strFlag)
	else
		hApi.ShowLabelBubble(unit, nil, nil, offsetX, offsetY, fontSize, showTime, modelTable, offsetZ, strFlag)
	end
	
	return self:doNextAction()
end

--geyachao: 角色变色
__aCodeList["SetUnitRGBA_TD"] = function(self, _, targetType, red, green, blue, alpha)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = nil --要读取的目标
	if (targetType == "unit") then
		unit = u
		
		--检测是否被复用
		if (not u) or (u == 0) or (u.data.IsDead == 1) or (u:getworldC() ~= d.unit_worldC) then --不是同一个目标了
			unit = nil
		end
	elseif (targetType == "target") then
		unit = t
		
		--检测是否被复用
		if (not t) or (t == 0) or (t.data.IsDead == 1) or (t:getworldC() ~= d.target_worldC) then --不是同一个目标了
			unit = nil
		end
	end
	
	red = red or 255
	green = green or 255
	blue = blue or 255
	alpha = alpha or 255
	
	--255不生效？？？
	if (alpha == 255) then
		alpha = 254
	end
	
	if unit then
		--设置颜色
		unit.data.color = {red, green, blue,}
		unit.data.color_origin = {red, green, blue,}
		unit.handle.s:setColor(ccc3(red, green, blue))
		
		--设置透明度
		unit.data.alpha = alpha
		unit.handle.s:setOpacity(alpha)
	end
	
	return self:doNextAction()
end

--geyachao: 设置角色身上buff的等级
__aCodeList["SetBuffLv_TD"] = function(self, _, skillId, targetType, buffLevel)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId] --读temp表里的值
	end
	
	if (type(buffLevel)=="string") then
		buffLevel = d.tempValue[buffLevel] --读temp表里的值
	end
	
	if unit then
		local oBuff = unit:getBuffById(skillId)
		if oBuff then --目标身上已有此buff
			local buffLv = oBuff.data.level --该buff的原等级
			
			--重新设置buff等级
			oBuff.data.level = buffLevel
			oBuff.data.tempValue["@lv"] = buffLevel
		end
	end
	
	return self:doNextAction()
end

--geyachao: 改变施法者
__aCodeList["SetUnitCaster_TD"] = function(self, _, targetType)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if unit then
		d.unit = unit
		d.unit_worldC = unit:getworldC()
	end
	
	return self:doNextAction()
end

--冲锋结束的范围伤害，造成范围伤害，并且忽略在group中的单位
--local __DamageCode = __aCodeList["__DamageTarget"]
__aCodeList["DamageAreaByCharge"] = function(self,_,nDmgMode,dMin,dMax,rMin,rMax)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local g = {}
	if not(rMin and rMax) then
		rMin,rMax = d.rMin,d.rMax
	end
	local p = u:getowner()
	local id = d.skillId
	if type(d.group)=="table" and d.group.OriginPos and d.group.FinalGrid then
		local fTab = {}
		local tGroup = d.group
		for i = 1,#d.group do
			if d.group[i][1]~=0 then
				fTab[d.group[i][1].ID] = 1
			end
		end
		w:enumunitUR(u,rMin,rMax,function(t)
			if fTab[t.ID]~=1 and hApi.IsSafeTarget(u,id,t,d.targetC)==hVar.RESULT_SUCESS then
				--附带击退效果
				if tGroup~=nil and hVar.tab_skill[id].knockback==1 then
					__KnockBack(t,tGroup.FinalGrid,math.min(w.data.gridW,w.data.gridH)*1.2,unpack(tGroup.OriginPos))
				end
				__DamageCode(self,"__DamageTarget",t,nDmgMode,dMin,dMax)
			end
		end)
	end
	return self:doNextAction()
end

local __ENUM__TargetArea = function(t,oAction,tParam)
	local d = oAction.data
	if hApi.IsSafeTarget(d.unit,d.skillId,t,tParam.oTargetC)==hVar.RESULT_SUCESS then
		d.target = t
		for i = 1,#tParam.ToDoList do
			local v = tParam.ToDoList[i]
			__aCodeList[v[1]](oAction,unpack(v))
		end
	end
end

__aCodeList["TargetArea"] = function(self,_,ToDoList)
	local d = self.data
	local oWorld = d.world
	if type(ToDoList)=="table" and #ToDoList>0 and hVar.tab_skill[d.skillId] then
		for i = 1,#ToDoList do
			if type(ToDoList[i])~="table" then
				_DEBUG_MSG("[SKILL ERROR]TargetArea参数错误,id="..d.skillId)
				return self:doNextAction()
			end
		end
		local oTargetOld = d.target
		d.IsPaused = 1
		local tParam = {
			oTargetC = d.targetC,
			ToDoList = ToDoList,
		}
		local oCenterUnit
		if d.areaMode==1 then
			oCenterUnit = d.unit
		elseif d.areaMode==2 then
			if d.target~=0 and d.target.data.IsDead==0 then
				oCenterUnit = d.target
			end
		end
		if oCenterUnit~=nil then
			oWorld:enumunitUR(oCenterUnit,d.rMin,d.rMax,__ENUM__TargetArea,self,tParam)
		else
			oWorld:enumunitR(d.gridX,d.gridY,d.rMin,d.rMax,__ENUM__TargetArea,self,tParam)
		end
		d.IsPaused = 0
		d.target = oTargetOld
	end
	return self:doNextAction()
end









--==========================================================================================
--------------------------------------------------------------------------------------------

--禁止/允许游戏内的点击事件
--bIngoreAction: 是否跳过动画
hApi.SetTouchEnable_Diablo = function(nIsEnable, bIngoreAction)
	local w = hGlobal.WORLD.LastWorldMap
	local nOffX = 0
	local nOffY = 640

	local nMoveH = 100
	
	--竖屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
		nOffX = -320
		nOffY = 0
		nMoveH = 150
	end
	
	hGlobal.event:event("LocalEvent_MoveSystemMenuFrm", nIsEnable, bIngoreAction, nOffX, nOffY)
	
	if (nIsEnable == 1) or (nIsEnable == true) then --允许响应事件
		--不重复允许
		if (w.data.keypadEnabled ~= true) then
			--允许响应事件
			w.data.keypadEnabled = true
			
			--游戏内的齿轮按钮下移
			local _frm = hGlobal.UI.TDSystemMenuBar
			local btn = _frm.childUI["SysMenu"]
			local bx, by = btn.data.x, btn.data.y
			local timeAction = 0.8
			local commentbtn = _frm.childUI["Comment"]
			local cbx, cby = commentbtn.data.x, commentbtn.data.y
			
			--跳过动画
			if bIngoreAction then
				btn:setXY(bx, by - nMoveH)
				commentbtn:setXY(cbx, cby - nMoveH - 100)
				_frm.childUI["TopBar"].handle._n:setVisible(true)
				_frm.childUI["bag"].handle._n:setVisible(true)
				hGlobal.event:event("LocalEvent_HideTacticsBuffIconFrm",true)
				local btnPerson = _frm.childUI["btn_RescuedPerson"]
				if btnPerson then
					btnPerson.handle._n:setVisible(true)
				end
				local labPerson = _frm.childUI["Lab_RescuedPerson"]
				if labPerson then
					labPerson.handle._n:setVisible(true)
				end
			else
				local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, -nMoveH)))
				local act2 = CCCallFunc:create(function(ctrl)
					btn:setXY(bx, by - nMoveH)
					commentbtn:setXY(cbx, cby - nMoveH - 100)
					_frm.childUI["TopBar"].handle._n:setVisible(true)
					_frm.childUI["bag"].handle._n:setVisible(true)
					hGlobal.event:event("LocalEvent_HideTacticsBuffIconFrm",true)
					local btnPerson = _frm.childUI["btn_RescuedPerson"]
					if btnPerson then
						btnPerson.handle._n:setVisible(true)
					end
					local labPerson = _frm.childUI["Lab_RescuedPerson"]
					if labPerson then
						labPerson.handle._n:setVisible(true)
					end
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				btn.handle._n:runAction(sequence)
			end
			
			--战车血条上移
			local _frm = hGlobal.UI.HeroFrame
			local hx, hy = _frm.data.x, _frm.data.y
			
			--跳过动画
			if bIngoreAction then
				_frm:setXY(hx, hy + nMoveH)
				
				--横竖屏解锁锁定
				hApi.ChangeScreenMode()
			else
				local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, nMoveH)))
				local act2 = CCCallFunc:create(function(ctrl)
					_frm:setXY(hx, hy + nMoveH)
					
					--横竖屏解锁锁定
					hApi.ChangeScreenMode()
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				_frm.handle._n:runAction(sequence)
			end
			
			----技能1按钮上移
			--local _frm = hGlobal.UI.TDSystemMenuBar
			--local ctrl1 = _frm.childUI["btnTactics_4"] --btnTacticsMask_4
			--local cx1, cy1 = ctrl1.data.x, ctrl1.data.y
			
			--local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, 300)))
			--local act2 = CCCallFunc:create(function(ctrl)
				--ctrl1:setXY(cx1, cy1 + 300)
			--end)
			--local a = CCArray:create()
			--a:addObject(act1)
			--a:addObject(act2)
			--local sequence = CCSequence:create(a)
			--ctrl1.handle._n:runAction(sequence)
			
			----技能2按钮上移
			--local ctrl2 = _frm.childUI["btnTactics_3"] --btnTacticsMask_3
			--local cx2, cy2 = ctrl2.data.x, ctrl2.data.y
			
			--local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, 300)))
			--local act3 = CCDelayTime:create(0.5)
			--local act4 = CCCallFunc:create(function(ctrl)
				--ctrl2:setXY(cx2, cy2 + 300)
				
				----开始发兵
				--hGlobal.event:event("LocalEvent_TD_NextWave", true)
				
				----镜头自动跟随
				--w:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
					--if (w.data.keypadEnabled == true) or (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --允许响应事件
						--local oHero = w:GetPlayerMe().heros[1]
						--if oHero then
							--local oUnit = oHero:getunit()
							--if oUnit then
								--local px, py = hApi.chaGetPos(oUnit.handle)
								----聚焦
								--hApi.setViewNodeFocus(px, py)
							--end
						--end
					--end
				--end)
			--end)
			--local a = CCArray:create()
			--a:addObject(act1)
			--a:addObject(act3)
			--a:addObject(act4)
			--local sequence = CCSequence:create(a)
			--ctrl2.handle._n:runAction(sequence)
			
			local _frm = hGlobal.UI.TDSystemMenuBar
			for i = 18, 3, -1 do
				local ctrl = _frm.childUI["btnTactics_"..i]
				if ctrl then
					local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(nOffX, nOffY)))
					local a = CCArray:create()
					a:addObject(act1)
					if i > 3 then
						local act2 = CCCallFunc:create(function()
							local cx1, cy1 = ctrl.data.x, ctrl.data.y
							ctrl:setXY(cx1 + nOffX, cy1 + nOffY)
						end)
						a:addObject(act2)
						
						--
						local mapInfo = w.data.tdMapInfo
						local waveNow = mapInfo.wave
						if (waveNow < 1) then
							--开始发兵
							hGlobal.event:event("LocalEvent_TD_NextWave", true)
						end
					else
						local act3 = CCDelayTime:create(0.5)
						local act4 = CCCallFunc:create(function()
							local cx2, cy2 = ctrl.data.x, ctrl.data.y
							ctrl:setXY(cx2 + nOffX, cy2 + nOffY)
							
							--开始发兵
							hGlobal.event:event("LocalEvent_TD_NextWave", true)
							
							--镜头自动跟随
							hApi.TD__Camera_Follow(w)
							--w:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
								--if (w.data.keypadEnabled == true) or (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --允许响应事件
									--local oHero = w:GetPlayerMe().heros[1]
									--if oHero then
										--local oUnit = oHero:getunit()
										--if oUnit then
											--local px, py = hApi.chaGetPos(oUnit.handle)
											----聚焦
											--hApi.setViewNodeFocus(px, py)
										--end
									--end
								--end
							--end)
						end)
						a:addObject(act3)
						a:addObject(act4)
					end
					local sequence = CCSequence:create(a)
					ctrl.handle._n:runAction(sequence)
				end
			end
			for i = 1, 18, 1 do
				local ctrl = _frm.childUI["imgPassiveTactics_"..i]
				if ctrl then
					local hx, hy = ctrl.data.x, ctrl.data.y
					local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, nMoveH)))
					local act2 = CCCallFunc:create(function()
						ctrl:setXY(hx, hy + nMoveH)
					end)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(act2)
					local sequence = CCSequence:create(a)
					ctrl.handle._n:runAction(sequence)
				end
			end
		end
	elseif (nIsEnable == 0) or (nIsEnable == false) then --禁止响应事件
		--不重复禁止
		if (w.data.keypadEnabled ~= false) then
			--禁止响应事件
			w.data.keypadEnabled = false
			
			--游戏内的齿轮按钮上移
			local _frm = hGlobal.UI.TDSystemMenuBar
			local btn = _frm.childUI["SysMenu"]
			local bx, by = btn.data.x, btn.data.y
			btn:setXY(bx, by + nMoveH)
			local commentbtn = _frm.childUI["Comment"]
			local cbx, cby = commentbtn.data.x, commentbtn.data.y
			commentbtn:setXY(cbx, cby + nMoveH + 100)
			
			--隐藏开战按钮
			local _frm = hGlobal.UI.TDSystemMenuBar
			_frm.childUI["NextWave"]:setstate(-1)
			_frm.childUI["NextWaveBg"].handle._n:setVisible(false)
			_frm.childUI["NextWaveProgress"].handle._n:setVisible(false)
			_frm.childUI["TopBar"].handle._n:setVisible(false)
			_frm.childUI["bag"].handle._n:setVisible(false)
			
			--隐藏手雷绑定的小图标
			hGlobal.event:event("LocalEvent_HideTacticsBuffIconFrm",false)
			
			--锁定视角及屏幕
			--print("锁定视角及屏幕")
			if type(xlGetScreenRotation) == "function" and type(xlRotateScreen) == "function" then
				--不可旋转
				local orientation, lock_flag = xlGetScreenRotation()
				--if lock_flag == 0 then
					xlRotateScreen(orientation,  1)               --设置屏幕朝向以及是否锁定
				--end
				
			end
			
			--战车血条下移
			local _frm = hGlobal.UI.HeroFrame
			local hx, hy = _frm.data.x, _frm.data.y
			_frm:setXY(hx, hy - nMoveH)
			
			--技能按钮下移
			--local _frm = hGlobal.UI.TDSystemMenuBar
			--local ctrl1 = _frm.childUI["btnTactics_4"] --btnTacticsMask_4
			--local cx1, cy1 = ctrl1.data.x, ctrl1.data.y
			--ctrl1:setXY(cx1, cy1 - 300)
			
			--local ctrl2 = _frm.childUI["btnTactics_3"] --btnTacticsMask_3
			--local cx2, cy2 = ctrl2.data.x, ctrl2.data.y
			--ctrl2:setXY(cx2, cy2 - 300)
			
			local _frm = hGlobal.UI.TDSystemMenuBar
			for i = 3, 18, 1 do
				local ctrl = _frm.childUI["btnTactics_"..i]
				if ctrl then
					cx, cy = ctrl.data.x, ctrl.data.y
					ctrl:setXY(cx - nOffX, cy - nOffY)
				end
			end
			
			for i = 1, 18, 1 do
				local ctrl = _frm.childUI["imgPassiveTactics_"..i]
				if ctrl then
					cx, cy = ctrl.data.x, ctrl.data.y
					ctrl:setXY(cx, cy - nMoveH)
				end
			end
			
			local btnPerson = _frm.childUI["btn_RescuedPerson"]
			if btnPerson then
				btnPerson.handle._n:setVisible(false)
			end
			local labPerson = _frm.childUI["Lab_RescuedPerson"]
			if labPerson then
				labPerson.handle._n:setVisible(false)
			end
		end
	end
end

--geyachao: 改变施法者
__aCodeList["SetUnit_TD"] = function(self, _, targetType)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	if unit then
		d.unit = unit
		d.unit_worldC = unit:getworldC()
	end
	
	return self:doNextAction()
end

--geyachao: 禁止/允许游戏内的点击事件
__aCodeList["SetTouchEnable_Diablo"] = function(self, _, nIsEnable)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(nIsEnable) == "string") then
		nIsEnable = d.tempValue[nIsEnable]
	end
	
	--禁止/允许游戏内的点击事件
	hApi.SetTouchEnable_Diablo(nIsEnable)
	
	return self:doNextAction()
end

--geyachao: 显示新手引导弹出框
__aCodeList["ShowGuideControlFrm_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--[[
	--geyachao: 不要引导了
	hGlobal.event:event("LocalEvent_ShowGuideControlFrm")
	]]
	
	return self:doNextAction()
end

--geyachao: 加载texture
__aCodeList["AddTexture_Diablo"] = function(self, _, imgFileName)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
	if (not texture) then
		texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
		print("加载贴图" .. imgFileName .. "！")
	end
	
	return self:doNextAction()
end

--geyachao: 释放texture
__aCodeList["RemoveTexture_Diablo"] = function(self, _, imgFileName)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
	if (texture) then
		CCTextureCache:sharedTextureCache():removeTexture(texture)
		print("释放贴图" .. imgFileName .. "！")
	end
	
	return self:doNextAction()
end

--geyachao: 获得屏幕的分辨率
__aCodeList["GetScreenWH_Diablo"] = function(self, _, paramW, paramH)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--存储
	if (type(paramW) == "string") then
		d.tempValue[paramW] = hVar.SCREEN.w
	end
	
	--存储
	if (type(paramH) == "string") then
		d.tempValue[paramH] = hVar.SCREEN.h
	end
	
	return self:doNextAction()
end

--geyachao: 获得当前地图的长宽
__aCodeList["GetMapCurrentWH_Diablo"] = function(self, _, paramMapW, paramMapH)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--存储
	if (type(paramMapW) == "string") then
		d.tempValue[paramMapW] = w.data.sizeW
	end
	
	--存储
	if (type(paramMapH) == "string") then
		d.tempValue[paramMapH] = w.data.sizeH
	end
	
	return self:doNextAction()
end

--geyachao: 获得当前镜头的坐标
__aCodeList["GetViewNodeFocus_Diablo"] = function(self, _, paramX, paramY)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	local camX, camY = xlGetViewNodeFocus()
	
	--存储
	if (type(paramX) == "string") then
		d.tempValue[paramX] = camX
	end
	
	--存储
	if (type(paramY) == "string") then
		d.tempValue[paramY] = camY
	end
	
	return self:doNextAction()
end

--geyachao: 获得我的英雄的唯一id
__aCodeList["GetMyTankUniqueID_Diablo"] = function(self, _, paramI)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--存储
	if (type(paramI) == "string") then
		local oHero = w:GetPlayerMe().heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				d.tempValue[paramI] = oUnit:getworldI()
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 设置镜头的坐标
__aCodeList["SetViewNodeFocus_Diablo"] = function(self, _, view_x, view_y)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(view_x) == "string") then
		view_x = d.tempValue[view_x]
	end
	
	--参数支持字符串类型
	if (type(view_y) == "string") then
		view_y = d.tempValue[view_y]
	end
	
	--设置镜头坐标
	--hApi.setViewNodeFocus(view_x, view_y)
	xlSetViewNodeFocus(view_x, view_y)
	
	return self:doNextAction()
end

--geyachao: 将地图里的某个指定单位(t_worldI)移动到指定坐标
__aCodeList["UnitMoveToPoint_Diablo"] = function(self, _, t_worldI, toX, toY, speed, bNoPlayMoveAmin, bNoFacing)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(toX) == "string") then
		toX = d.tempValue[toX]
	end
	
	--参数支持字符串类型
	if (type(toY) == "string") then
		toY = d.tempValue[toY]
	end
	
	--参数支持字符串类型
	if (type(speed) == "string") then
		speed = d.tempValue[speed]
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	--检测单位的有效性
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local unitPosX, unitPosY = hApi.chaGetPos(oTarget.handle) --角色的位置
		local dx = unitPosX - toX
		local dy = unitPosY - toY
		local dis = math.sqrt(dx * dx + dy * dy)
		local angle = GetFaceAngle(unitPosX, unitPosY, toX, toY) --角度制
		local moveSpeed = speed or oTarget:GetMoveSpeed()
		local t = speed / dis * 1000
		--oTarget:setPos(unitPosX, unitPosY, angle)
		
		--转向
		if (not bNoFacing) then
			hApi.ChaSetFacing(oTarget.handle, angle) --转向
			oTarget.data.facing = angle
		end
		
		--设置AI状态
		oTarget:setAIState(hVar.UNIT_AI_STATE.MOVE)
		
		hApi.UnitMoveToPoint_TD(oTarget, toX, toY, false, moveSpeed, bNoPlayMoveAmin)
	end
	
	return self:doNextAction()
end

--geyachao: 将地图里的某个指定单位(t_worldI)移动到指定坐标，并等待单位移动到达后才继续执行后续流程
__aCodeList["UnitMoveToPoint_Wait_Diablo"] = function(self, _, t_worldI, toX, toY, speed, bNoPlayMoveAmin, bNoFacing)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(toX) == "string") then
		toX = d.tempValue[toX]
	end
	
	--参数支持字符串类型
	if (type(toY) == "string") then
		toY = d.tempValue[toY]
	end
	
	--参数支持字符串类型
	if (type(speed) == "string") then
		speed = d.tempValue[speed]
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	--检测单位的有效性
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local unitPosX, unitPosY = hApi.chaGetPos(oTarget.handle) --角色的位置
		local dx = unitPosX - toX
		local dy = unitPosY - toY
		local dis = math.sqrt(dx * dx + dy * dy)
		local angle = GetFaceAngle(unitPosX, unitPosY, toX, toY) --角度制
		local moveSpeed = speed or oTarget:GetMoveSpeed()
		local t = speed / dis * 1000
		--oTarget:setPos(unitPosX, unitPosY, angle)
		
		--转向
		if (not bNoFacing) then
			hApi.ChaSetFacing(oTarget.handle, angle) --转向
			oTarget.data.facing = angle
		end
		
		--设置状态为移动到达目标点后继续释放技能
		oTarget:setAIState(hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL)
		
		oTarget.data.op_state = 1 --是否有缓存的操作
		oTarget.data.op_target = 0 --等待操作的移动到达的目标
		oTarget.data.op_target_worldC = 0 --等待操作的移动到达的目标唯一id
		oTarget.data.op_point_x = toX --等待操作的移动到达的目标点x
		oTarget.data.op_point_y = toY --等待操作的移动到达的目标点y
		oTarget.data.op_tacticId = 0 --等待操作的移动到达目标点后释放的战术技能id
		oTarget.data.op_itemId = 0 --等待操作的移动到达目标点后释放的道具技能id
		oTarget.data.op_tacticX = 0 --等待操作的移动到达目标点后战术技能x坐标
		oTarget.data.op_tacticY = 0 --等待操作的移动到达目标点后战术技能y坐标
		oTarget.data.op_t_worldI = 0 --等待操作的移动到达目标点后战术技能目标worldI
		oTarget.data.op_t_worldC = 0 --等待操作的移动到达目标点后战术技能目标worldC
		oTarget.data.op_skillAction = self --等待操作的移动到达目标点后释放的技能id
		
		hApi.UnitMoveToPoint_TD(oTarget, toX, toY, false, moveSpeed, bNoPlayMoveAmin)
	end
	
	return "sleep", math.huge --大菠萝，改为action回调继续后续流程
	--return self:doNextAction()
end

--geyachao: 将目标移动到指定坐标
__aCodeList["UnitMoveToPoint_TD"] = function(self, _, targetType, toX, toY, speed, bNoPlayMoveAmin)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	local oTarget = u --要读取的目标
	if (targetType == "unit") then
		oTarget = u
	elseif (targetType == "target") then
		oTarget = t
	end
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(toX) == "string") then
		toX = d.tempValue[toX]
	end
	
	--参数支持字符串类型
	if (type(toY) == "string") then
		toY = d.tempValue[toY]
	end
	
	--参数支持字符串类型
	if (type(speed) == "string") then
		speed = d.tempValue[speed]
	end
	
	--local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	--检测单位的有效性
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local unitPosX, unitPosY = hApi.chaGetPos(oTarget.handle) --角色的位置
		local dx = unitPosX - toX
		local dy = unitPosY - toY
		local dis = math.sqrt(dx * dx + dy * dy)
		local angle = GetFaceAngle(unitPosX, unitPosY, toX, toY) --角度制
		local moveSpeed = speed or oTarget:GetMoveSpeed()
		local t = speed / dis * 1000
		--oTarget:setPos(unitPosX, unitPosY, angle)
		
		--转向
		hApi.ChaSetFacing(oTarget.handle, angle) --转向
		oTarget.data.facing = angle
		
		hApi.UnitMoveToPoint_TD(oTarget, toX, toY, false, moveSpeed, bNoPlayMoveAmin)
	end
	
	return self:doNextAction()
end

--geyachao: 将镜头移动到指定位置（方法1，强制设置镜头）
__aCodeList["SetCameraToPoint_Diablo"] = function(self, _, fromX, fromY, toX, toY, speed)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(fromX) == "string") then
		fromX = d.tempValue[fromX]
	end
	
	--参数支持字符串类型
	if (type(fromY) == "string") then
		fromY = d.tempValue[fromY]
	end
	
	--参数支持字符串类型
	if (type(toX) == "string") then
		toX = d.tempValue[toX]
	end
	
	--参数支持字符串类型
	if (type(toY) == "string") then
		toY = d.tempValue[toY]
	end
	
	--参数支持字符串类型
	if (type(speed) == "string") then
		speed = d.tempValue[speed]
	end
	
	local dx = toX - fromX
	local dy = toY - fromY
	local DIS = math.sqrt(dx * dx + dy * dy)
	local angle = GetLineAngle(fromX, fromY, toX, toY) --角度制
	local fangle = angle * math.pi / 180 --弧度制
	
	--镜头自动跟随
	local camX = fromX
	local camY = fromY
	local disLeft = DIS --剩余路程
	w:addtimer("__TD__SetCameraToPoint_Diablo__", 1, function(deltaTime)
		local dis = speed * deltaTime / 1000
		if (dis >= disLeft) then --本次足以到达目标点
			camX = toX
			camY = toY
			disLeft = 0
			w:removetimer("__TD__SetCameraToPoint_Diablo__")
		else
			camX = camX + dis * math.cos(fangle)
			camY = camY + dis * math.sin(fangle)
			disLeft = disLeft - dis
		end
		
		--设置镜头坐标
		--hApi.setViewNodeFocus(camX, camY)
		xlSetViewNodeFocus(camX, camY)
		--print("xlSetViewNodeFocus", camX, camY)
	end)
	
	return self:doNextAction()
end

--geyachao: 将镜头移动到指定位置（方法2，远景渐移）
__aCodeList["SetCameraToPoint_FarScene_Diablo"] = function(self, _, fromX, fromY, toX, toY, speed)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(fromX) == "string") then
		fromX = d.tempValue[fromX]
	end
	
	--参数支持字符串类型
	if (type(fromY) == "string") then
		fromY = d.tempValue[fromY]
	end
	
	--参数支持字符串类型
	if (type(toX) == "string") then
		toX = d.tempValue[toX]
	end
	
	--参数支持字符串类型
	if (type(toY) == "string") then
		toY = d.tempValue[toY]
	end
	
	--参数支持字符串类型
	if (type(speed) == "string") then
		speed = d.tempValue[speed]
	end
	
	local dx = toX - fromX
	local dy = toY - fromY
	local DIS = math.sqrt(dx * dx + dy * dy)
	local angle = GetLineAngle(fromX, fromY, toX, toY) --角度制
	local fangle = angle * math.pi / 180 --弧度制
	
	--镜头自动跟随
	local camX = fromX
	local camY = fromY
	local disLeft = DIS --剩余路程
	w:addtimer("__TD__SetCameraToPoint_Diablo__", 1, function(deltaTime)
		local dis = speed * deltaTime / 1000
		if (dis >= disLeft) then --本次足以到达目标点
			camX = toX
			camY = toY
			disLeft = 0
			w:removetimer("__TD__SetCameraToPoint_Diablo__")
		else
			camX = camX + dis * math.cos(fangle)
			camY = camY + dis * math.sin(fangle)
			disLeft = disLeft - dis
		end
		
		--设置镜头坐标
		hApi.setViewNodeFocus(camX, camY)
		--xlSetViewNodeFocus(camX, camY)
		--print("xlSetViewNodeFocus", camX, camY)
	end)
	
	return self:doNextAction()
end

--geyachao: 在指定位置召唤一个单位，该单位有渐入效果
__aCodeList["SummonUnit_Diablo"] = function(self, _, typeId, posX, posY, force, facing, lv, star, paramI, livetime)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--角色活着,zhenkira
	local oUnit = u
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		--local facing = oUnit.data.facing --角色的朝向
		local world = self.data.world
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		
		if (type(typeId) == "string") then
			typeId = self.data.tempValue[typeId] --读temp表里的值
		end
		if (type(posX) == "string") then
			posX = self.data.tempValue[posX] --读temp表里的值
		end
		if (type(posY) == "string") then
			posY = self.data.tempValue[posY] --读temp表里的值
		end
		if (type(lv) == "string") then
			lv = self.data.tempValue[lv] --读temp表里的值
		end
		if (type(star) == "string") then
			star = self.data.tempValue[star] --读temp表里的值
		end
		if (type(force) == "string") then
			force = self.data.tempValue[force] --读temp表里的值
		end
		
		--参数支持字符串类型
		if (type(livetime) == "string") then
			livetime = d.tempValue[livetime]
		end
		
		--出生点坐标
		local randPosX, randPosY = posX, posY
		
		--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star
		local tabU = hVar.tab_unit[typeId]
		local cha = nil
		
		--场景物件
		if (tabU.xlobj ~= nil) then
			hApi.setEditorID(typeId)
			cha = world:addsceobj(typeId,nil,nil,tabU.xlobj,"xlobj",tabU.scale,facing,randPosX,randPosY,tabU.zOrder)
		else
			cha = world:addunit(typeId, force, nil, nil, facing, randPosX, randPosY, nil, nil, lv, star)
		end
		
		--print("SummonUnit_Nearby:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
		if cha then
			--设置目标AI状态
			--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
			
			--场景物件类型，设置指定z值
			--[[
			if tabU then
				--场景物件
				print("场景物件", tabU.type, tabU.zOrder)
				if (tabU.type == hVar.UNIT_TYPE.SCEOBJ) then
					if tabU.zOrder and type(tabU.zOrder)=="number" then
						zOrder = tabU.zOrder
					end
					if cha.handle._c and (zOrder ~= 0) then
						xlChaSetZOrderOffset(cha.handle._c, zOrder - randPosY)
						print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
					end
				end
			end
			]]
			
			--场景物件
			if (tabU.xlobj ~= nil) then
				--
			else
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置目标的路点
				cha:copyRoadPoint(oUnit)
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					cha.data.livetime = livetime --新加数据 生存时间（毫秒）
					cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				
				--触发事件：添加单位
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				self.data.tempValue["SummonUnitList"] = self.data.tempValue["SummonUnitList"] or {}
				self.data.tempValue["SummonUnitList"][(#(self.data.tempValue["SummonUnitList"]))+1] = cha
				
				--存储变量
				if (type(paramI) == "string") then
					d.tempValue[paramI] = cha:getworldI()
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位释放skill技能
__aCodeList["CastSkill_Diablo"] = function(self,_, u_worldI, t_worldI, nSkillId, nSkillLv)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(u_worldI) == "string") then
		u_worldI = d.tempValue[u_worldI]
	end
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(nSkillId) == "string") then
		nSkillId = d.tempValue[nSkillId]
	end
	
	--参数支持字符串类型
	if (type(nSkillLv) == "string") then
		nSkillLv = d.tempValue[nSkillLv]
	end
	
	local oCaster = hClass.unit:getChaByWorldI(u_worldI)
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oCaster=", oCaster and oCaster.data.name)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	--检测单位的有效性
	if (oCaster) and (oCaster ~= 0) and (oCaster.data.IsDead ~= 1) and (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		--释放技能
		local tCastParam =
		{
			level = nSkillLv, --geyahcao: 技能等级
		}
		hApi.CastSkill(oCaster, nSkillId, -1, d.power, oTarget, d.gridX, d.gridY,tCastParam)
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位释放buff技能
__aCodeList["CastBuff_Diablo"] = function(self,_, u_worldI, t_worldI, nSkillId, nBuffLv, nBuffTime)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(u_worldI) == "string") then
		u_worldI = d.tempValue[u_worldI]
	end
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(nSkillId) == "string") then
		nSkillId = d.tempValue[nSkillId]
	end
	
	--参数支持字符串类型
	if (type(nBuffLv) == "string") then
		nBuffLv = d.tempValue[nBuffLv]
	end
	
	--参数支持字符串类型
	if (type(nBuffTime) == "string") then
		nBuffTime = d.tempValue[nBuffTime]
	end
	
	local oCaster = hClass.unit:getChaByWorldI(u_worldI)
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	--检测单位的有效性
	if (oCaster) and (oCaster ~= 0) and (oCaster.data.IsDead ~= 1) and (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		return __CODE__CastBuff(self, oCaster, oTarget, nSkillId, -1, d.power, nBuffLv, nBuffTime)
	else
		return self:doNextAction()
	end
end

--geyachao: 指定单位(t_worldI)转向到指定角度
__aCodeList["ChaFaceToAngle_Diablo"] = function(self, _, t_worldI, facing)
	local d = self.data
	local u = d.unit
	local t = d.target
	local w = d.world
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	
	if (type(facing) == "string") then
		facing = d.tempValue[facing] --读temp表里的值
	end
	
	if (facing < 0) then
		local N = math.floor(-facing / 360)
		facing = facing + 360 * (N + 1)
	end
	
	if (facing >= 360) then
		facing = facing - 360
	end
	
	local unit = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", unit and unit.data.name)
	
	--检测单位的有效性
	if (unit) and (unit ~= 0) and (unit.data.IsDead ~= 1) and (unit.attr.hp > 0) then
		--单位转向
		hApi.ChaSetFacing(unit.handle, facing) --转向
		unit.data.facing = facing
		
		--绑定的单位也转向
		--tank: 同步更新绑定的单位的位置（炮口）
		if (unit.data.bind_unit ~= 0) then
			local bu = unit.data.bind_unit
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯光照）
		if (unit.data.bind_light ~= 0) then
			local bu = unit.data.bind_light
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯轮子）
		if (unit.data.bind_wheel ~= 0) then
			local bu = unit.data.bind_wheel
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯影子）
		if (unit.data.bind_shadow ~= 0) then
			local bu = unit.data.bind_shadow
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（大灯能量圈）
		if (unit.data.bind_energy ~= 0) then
			local bu = unit.data.bind_energy
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
		
		--tank: 同步更新绑定的单位的位置（机枪）
		if (unit.data.bind_weapon ~= 0) then
			local bu = unit.data.bind_weapon
			if (bu:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
				--print(world:gametime() - bu.attr.last_attack_time)
				if ((w:gametime() - bu.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
					hApi.ChaSetFacing(bu.handle, facing)
					bu.data.facing = facing
				end
			end
		end
		
		--tank: 同步更新绑定的单位的位置（大灯）
		if (unit.data.bind_lamp ~= 0) then
			local bu = unit.data.bind_lamp
			hApi.ChaSetFacing(bu.handle, facing)
			bu.data.facing = facing
		end
	end
	
	return self:doNextAction()
end

--geyachao: 移除指定单位
__aCodeList["RemoveUnit_Diablo"] = function(self, _, t_worldI)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(u_worldI) == "string") then
		u_worldI = d.tempValue[u_worldI]
	end
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		--清除单位死亡后事件
		--清除世界检测
		local cha_worldC = oTarget:getworldC()
		w.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
		
		--删除角色
		oTarget.attr.hp = 0
		oTarget.data.IsDead = 1
		oTarget:del()
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位沿路线走路
__aCodeList["UnitMoveRoadPoint_Diablo"] = function(self, _, t_worldI, pathIdx, formation)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	--参数支持字符串类型
	if (type(pathIdx) == "string") then
		pathIdx = d.tempValue[pathIdx]
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local dType = hVar.TD_DEPLOY_TYPE
		local f = dType.ONE_SAME_DISTANCE
		--local f = dType.ONE_RANDOM_DISTANCE
		if formation and formation >= dType.ONE_POINT_CENTER and formation <= dType.ONE_RANDOM_DISTANCE then
			f = formation
		end
		
		--设置角色的路点
		oTarget:setRoadPoint(pathIdx, f, 1)
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位将路点设置到下一个
__aCodeList["UnitSetRoadPointNext_Diablo"] = function(self, _, t_worldI)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		--将路点设置到下一个
		oTarget:setRoadPointNext()
		--print("将路点设置到下一个", oTarget.data.name)
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位播放动作
__aCodeList["Pose_Diablo"] = function(self, _, t_worldI, pose, slashName,slashPose,nSpeedUp)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(u_worldI) == "string") then
		u_worldI = d.tempValue[u_worldI]
	end
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	if (type(pose) ~= "string") then
		pose = "stand"
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local u = oTarget
		if type(nSpeedUp)=="number" then
			local speed = u.handle.__speed
			u.handle.__speed = nSpeedUp
			u:setanimation({pose,"stand"})
			u.handle.__speed = speed
		else
			u:setanimation({pose,"stand"})
			--u:setanimation(pose)
		end
		if (slashName or 0)~=0 and hVar.SLASH_PATH[slashName] and xlAddKnifeLightWithAngle then
			slashPose = slashPose or pose
			local sTab = hVar.tab_slash[u.data.id]
			if sTab and type(sTab[slashPose])=="table" then
				local tx,ty,uw,uh = u:getbox()
				local cx,cy = u:getXY()
				local aTag = hApi.calAngleS(u.handle.modelmode,u.data.facing)
				local param = sTab[slashPose][aTag]
				if param then
					local baseWH = sTab.r or 128
					local path = hVar.SLASH_PATH[slashName]
					local delay = 0
					if type(path)=="table" then
						path = path[param.model] or path[1]
					end
					if type(path)=="string" then
						local width = param.width
						local r = param.r*baseWH/192
						local roll = param.roll
						local facing = param.facing
						local nShape = param.shape*baseWH/192
						local x = cx+param.x*baseWH/200+tx+uw/2
						local y = cy+param.y*baseWH/200+ty+uh/2
						local fadeIn = param.fadeIn/100
						local fadeOut = param.fadeOut/100
						local fDelay = delay+param.delay/100
						local fDelayEx = param.delayEx/100
						local fCycleShape = param.cycleShape/100
						--texturePath,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape
						xlAddKnifeLightWithAngle(path,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 指定单位播放2个动作
__aCodeList["Pose2_Diablo"] = function(self, _, t_worldI, pose, pose2, slashName,slashPose,nSpeedUp)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(t_worldI) == "string") then
		t_worldI = d.tempValue[t_worldI]
	end
	
	if (type(pose) ~= "string") then
		pose = "stand"
	end
	
	if (type(pose2) ~= "string") then
		pose2 = "stand"
	end
	
	local oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print("oTarget=", oTarget and oTarget.data.name)
	
	if (oTarget) and (oTarget ~= 0) and (oTarget.data.IsDead ~= 1) then
		local u = oTarget
		if type(nSpeedUp)=="number" then
			local speed = u.handle.__speed
			u.handle.__speed = nSpeedUp
			u:setanimation({pose,pose2})
			u.handle.__speed = speed
		else
			u:setanimation({pose,pose2})
			--u:setanimation(pose)
		end
		if (slashName or 0)~=0 and hVar.SLASH_PATH[slashName] and xlAddKnifeLightWithAngle then
			slashPose = slashPose or pose
			local sTab = hVar.tab_slash[u.data.id]
			if sTab and type(sTab[slashPose])=="table" then
				local tx,ty,uw,uh = u:getbox()
				local cx,cy = u:getXY()
				local aTag = hApi.calAngleS(u.handle.modelmode,u.data.facing)
				local param = sTab[slashPose][aTag]
				if param then
					local baseWH = sTab.r or 128
					local path = hVar.SLASH_PATH[slashName]
					local delay = 0
					if type(path)=="table" then
						path = path[param.model] or path[1]
					end
					if type(path)=="string" then
						local width = param.width
						local r = param.r*baseWH/192
						local roll = param.roll
						local facing = param.facing
						local nShape = param.shape*baseWH/192
						local x = cx+param.x*baseWH/200+tx+uw/2
						local y = cy+param.y*baseWH/200+ty+uh/2
						local fadeIn = param.fadeIn/100
						local fadeOut = param.fadeOut/100
						local fDelay = delay+param.delay/100
						local fDelayEx = param.delayEx/100
						local fCycleShape = param.cycleShape/100
						--texturePath,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape
						xlAddKnifeLightWithAngle(path,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 找到地图上指定id的第index个单位的唯一id
__aCodeList["FindUnitByTypeId_Diablo"] = function(self, _, param_t_worldI, typeId, index)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--参数支持字符串类型
	if (type(typeId) == "string") then
		typeId = d.tempValue[typeId]
	end
	
	--参数支持字符串类型
	if (type(index) == "string") then
		index = d.tempValue[index]
	end
	
	local tUnitList = {}
	
	--遍历全部单位
	w:enumunit(function(eu)
		if (eu.data.id == typeId) then
			tUnitList[#tUnitList+1] = eu
		end
	end)
	
	--存储
	if (type(param_t_worldI) == "string") then
		d.tempValue[param_t_worldI] = 0
	end
	
	if (#tUnitList > 0) then
		if (index <= 0) then
			index = 1
		end
		
		local idx = #tUnitList % index
		if (idx == 0) then
			idx = #tUnitList
		end
		
		--存储
		if (type(param_t_worldI) == "string") then
			d.tempValue[param_t_worldI] = tUnitList[idx]:getworldI()
		end
	end
	
	return self:doNextAction()
end

--geyachao: 获得单位的唯一id
__aCodeList["GetTargetUniqueID_Diablo"] = function(self, _, targetType, paramI)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--存储
	if (type(paramI) == "string") then
		if unit then
			d.tempValue[paramI] = unit:getworldI()
		end
	end
	
	return self:doNextAction()
end

--geyachao: 某个坐标点是否为障碍
__aCodeList["IsGridBlock_Diablo"] = function(self, _, worldX, worldY, paramBlock)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--参数支持字符串类型
	if (type(worldX) == "string") then
		worldX = d.tempValue[worldX]
	end
	
	--参数支持字符串类型
	if (type(worldY) == "string") then
		worldY = d.tempValue[worldY]
	end
	
	local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
	if (result == 1) or (hApi.IsPosInWater(g_world, worldX) == 1) then --寻路失败，或者在水里
		--存储
		if (type(paramBlock) == "string") then
			d.tempValue[paramBlock] = 1
		end
	else
		--存储
		if (type(paramBlock) == "string") then
			d.tempValue[paramBlock] = 0
		end
	end
	
	return self:doNextAction()
end

--geyachao: 创建穿越区域
--livetime:毫秒
__aCodeList["AddPassThroughArea_Diablo"] = function(self, _, effectId, worldX, worldY, range, distance, livetime)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--参数支持字符串类型
	if (type(effectId) == "string") then
		effectId = d.tempValue[effectId]
	end
	
	--参数支持字符串类型
	if (type(worldX) == "string") then
		worldX = d.tempValue[worldX]
	end
	
	--参数支持字符串类型
	if (type(worldY) == "string") then
		worldY = d.tempValue[worldY]
	end
	
	--参数支持字符串类型
	if (type(range) == "string") then
		range = d.tempValue[range]
	end
	
	--参数支持字符串类型
	if (type(distance) == "string") then
		distance = d.tempValue[distance]
	end
	
	--参数支持字符串类型
	if (type(livetime) == "string") then
		livetime = d.tempValue[livetime]
	end
	
	--生成随机开始点坐标
	local beginPosX = 0
	local beginPosY = 0
	local beginAngle = w:random(0, 359)
	while true do
		local fangle = beginAngle * math.pi / 180 --弧度制
		fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
		local dx = (range + 100) * math.cos(fangle) --随机偏移值x
		local dy = (range + 100) * math.sin(fangle) --随机偏移值y
		dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
		dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
		beginPosX = worldX + dx --随机x位置
		beginPosY = worldY + dy --随机y位置
		
		--如果此点非障碍，并且可直线到达，那么可生成此穿越点
		local result = xlScene_IsGridBlock(g_world, beginPosX / 24, beginPosY / 24) --某个坐标是否是障碍
		if (result == 0) then
			local waypoint = xlCha_MoveToGrid(u.handle._c, beginPosX / 24, beginPosY / 24, 0, nil)
			if (waypoint[0] > 0) then --寻路成功
				--生成完成
				break
			end
		end
		
		--角度自增
		beginAngle = beginAngle + 1
	end
	
	--生成另一个随机穿越点的坐标
	local randPosX = 0
	local randPosY = 0
	local beginAngle = w:random(0, 359)
	local beginAngleTurn = beginAngle --一圈的起始值
	local beginDistance = distance
	while true do
		local fangle = beginAngle * math.pi / 180 --弧度制
		fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
		local dx = beginDistance * math.cos(fangle) --随机偏移值x
		local dy = beginDistance * math.sin(fangle) --随机偏移值y
		dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
		dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
		randPosX = worldX + dx --随机x位置
		randPosY = worldY + dy --随机y位置
		
		--如果此点非障碍，并且可直线到达，那么可生成此穿越点
		local result = xlScene_IsGridBlock(g_world, randPosX / 24, randPosY / 24) --某个坐标是否是障碍
		if (result == 0) then
			local waypoint = xlCha_MoveToGrid(u.handle._c, randPosX / 24, randPosY / 24, 0, nil)
			if (waypoint[0] > 0) then --寻路成功
				--生成完成
				break
			end
		end
		
		--角度自增
		beginAngle = beginAngle + 1
		if (beginAngle >= 360) then
			beginAngle = 0
		end
		if (beginAngle == beginAngleTurn) then --已转一圈，缩小距离继续查找
			beginDistance = beginDistance - 100
		end
	end
	
	local mapInfo = w.data.tdMapInfo
	
	--创建穿越特效1
	local eff1 = w:addeffect(effectId, -1, nil, beginPosX, beginPosY)
	eff1.handle._n:getParent():reorderChild(eff1.handle._n, beginPosY - 50)
	local passthrough1 = {}
	passthrough1.passthroughRadius = range --穿越触发半径
	passthrough1.passthroughWorldX = beginPosX --穿越点坐标x
	passthrough1.passthroughWorldY = beginPosY --穿越点坐标y
	passthrough1.passthroughEffect = eff1 --穿越点特效
	passthrough1.passthroughBeginTime = w:gametime() --穿越点开始时间
	passthrough1.passthroughLastTime = livetime --穿越点持续时间
	passthrough1.passthroughToX = randPosX --穿越点到达坐标x
	passthrough1.passthroughToY = randPosY --穿越点到达坐标y
	passthrough1.passthroughFinishState = false --当前状态(true:在区域里 /false:不在区域里)
	mapInfo.passthrough[#mapInfo.passthrough+1] = passthrough1
	
	--创建穿越特效2
	local eff2 = w:addeffect(effectId, -1, nil, randPosX, randPosY)
	eff2.handle._n:getParent():reorderChild(eff2.handle._n, randPosY - 50)
	local passthrough2 = {}
	passthrough2.passthroughRadius = range --穿越触发半径
	passthrough2.passthroughWorldX = randPosX --穿越点坐标x
	passthrough2.passthroughWorldY = randPosY --穿越点坐标y
	passthrough2.passthroughEffect = eff2 --穿越点特效
	passthrough2.passthroughBeginTime = w:gametime() --穿越点开始时间
	passthrough2.passthroughLastTime = livetime --穿越点持续时间
	passthrough2.passthroughToX = beginPosX --穿越点到达坐标x
	passthrough2.passthroughToY = beginPosY --穿越点到达坐标y
	passthrough2.passthroughFinishState = false --当前状态(true:在区域里 /false:不在区域里)
	mapInfo.passthrough[#mapInfo.passthrough+1] = passthrough2
	
	return self:doNextAction()
end

--geyachao: 对全体有指定buff的目标释放技能
__aCodeList["CastSkillOnBuff_Diablo"] = function(self, _, buffId, skillId, skillLv)
	local d = self.data
	local u = d.unit --角色
	local w = u:getworld()
	
	--参数支持字符串类型
	if (type(buffId) == "string") then
		buffId = d.tempValue[buffId]
	end
	
	--参数支持字符串类型
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId]
	end
	
	--参数支持字符串类型
	if (type(skillLv) == "string") then
		skillLv = d.tempValue[skillLv]
	end
	
	--遍历全部单位
	w:enumunit(function(eu)
		--遍历该单位身上存在的所有buff，移除沉睡标记
		local oBuff = eu:getBuffById(buffId)
		if oBuff then --目标身上已有此buff
			--print("buffId_eu", buffId_eu, u.data.name, eu.data.name, skillId)
			local tCastParam =
			{
				level = skillLv, --技能等级
			}
			local gridX, gridY = d.gridX, d.gridY
			hApi.CastSkill(u, skillId, 0, 100, eu, gridX, gridY, tCastParam) --释放技能
		end
	end)
	
	return self:doNextAction()
end

--geyachao: 标记本关通关
__aCodeList["FinishMap_Diablo"] = function(self, _, num, ...)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local currentmap = w.data.map
	
	local oldfinishstate = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.LEVEL)
	LuaSetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.LEVEL, 1, true)
	
	--更新通关信息及星级信息
	local starV = 3
	local star = (LuaGetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
	
	--如果存档中的星级小于当前获得的星级，则需要刷新数据
	if star < starV then
		LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.MAPSTAR, starV,true)
		
		if starV >= 3 then
			LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.Map_Difficult,1,true)
			LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
		end
		
		--统计普通关卡得星
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.starCount, starV - star)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.starCount, starV - star)
	end
	
	--统计开始
	if starV >= 3 then
		--统计关卡满星通关次数
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStar)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStar)
		
		--统计普通关卡满星通关次数
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStarNormal)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStarNormal)
	end
	
	--通关统计
	LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
	LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--上传存档
	local keyList = {"skill", "card", "map", "bag", "material", "log",}
	LuaSavePlayerData_Android_Upload(keyList, "标记本关通关")
	
	return self:doNextAction()
end

--geyachao: 弹出二选一的操作界面
__aCodeList["ShowSelectMsgBox_Diablo"] = function(self, _, num, ...)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local arg = {...}
	
	--转译字符串
	for i = 1, num, 1 do
		local tParam = arg[i] or {}
		local text = tParam.text or ""
		if (text ~= "") then
			text = hVar.tab_string[text] or text
			tParam.text = text
		end
	end
	
	g_DisableShowOption = 1
	
	--弹出二选一的操作界面
	hApi.ShowSelectMsgBox(num, unpack(arg))
	
	return self:doNextAction()
end

--geyachao: 弹出引导装备操作的界面
__aCodeList["ShowChariotEquipFrm_Diablo"] = function(self, _)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local callback = function()
		--print("self:doNextAction()")
		--self:doNextAction()
		--继续后续流程
		self.data.tick = 16
	end
	--弹出装备按钮
	hGlobal.event:event("LocalEvent_ShowChariotEquipFrm", callback)
	
	hApi.addTimerOnce("tipActionEquip", 100,function()
		--引导装备闪烁的动画
		hGlobal.event:event("LocalEvent_ShowChariotEquipGuide")
	end)
	
	--return self:doNextAction()
	return "sleep", math.huge --大菠萝，改为action回调继续后续流程
end

--geyachao: 引导图请求发红装
__aCodeList["GuideAddRedEquip_Diablo"] = function(self, _, num, ...)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	--发红装
	SendCmdFunc["guide_add_redequip"]()
	
	return self:doNextAction()
end

--geyachao: 战车宠物挖矿初始化
__aCodeList["TankPetWaKuangInit_Diablo"] = function(self, _)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local oPlayerMe = w:GetPlayerMe() --我的玩家对象
	local oHero = oPlayerMe.heros[1]
	--print(oHero)
	if oHero then
		local oUnit = oHero:getunit()
		--print(oUnit)
		if oUnit then
			local tankId = oUnit.data.id
			local tPet = hVar.tab_unit[tankId].pet_unit
			for petIdx = 1, #tPet, 1 do
				local unitId = tPet[petIdx].unitId --主基地单位
				local wakuangUnit = tPet[petIdx].wakuangUnit
				local directWaKuangSkill = tPet[petIdx].directWaKuangSkill
				local watiliUnit = tPet[petIdx].watiliUnit
				local directWaTiLiSkill = tPet[petIdx].directWaTiLiSkill
				
				local wakuang = LuaGetHeroPetInWaKuang(tankId, petIdx)
				local watili = LuaGetHeroPetInWaTiLi(tankId, petIdx)
				
				--直接派遣挖矿/挖体力
				if (wakuang == 1) then --在挖矿
					--释放技能
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = w:xy2grid(targetX, targetY)
					local skillId = directWaKuangSkill --技能
					local skillLv = 1
					local tCastParam = {level = wakuangUnit,}
					hApi.CastSkill(oUnit, skillId, nil, nil, oUnit, gridX, gridY, tCastParam)
					
					--隐藏主基地单位
					--遍历全部单位
					w:enumunit(function(eu)
						if (eu.data.id == unitId) then
							eu:sethide(1)
						end
					end)
				elseif (watili == 1) then --在挖体力
					--释放技能
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = w:xy2grid(targetX, targetY)
					local skillId = directWaTiLiSkill --技能
					local skillLv = 1
					local tCastParam = {level = watiliUnit,}
					hApi.CastSkill(oUnit, skillId, nil, nil, oUnit, gridX, gridY, tCastParam)
					
					--隐藏主基地单位
					--遍历全部单位
					w:enumunit(function(eu)
						if (eu.data.id == unitId) then
							eu:sethide(1)
						end
					end)
				end
			end
		end
	end
	
	return self:doNextAction()
end

--wangcheng: 完成引导
__aCodeList["CompleteGuide"] = function(self)
	--print("CompleteGuide")
	LuaSetPlayerMapAchi(hVar.GuideMap, hVar.ACHIEVEMENT_TYPE.LEVEL,1)
	
	return self:doNextAction()
end

--wangcheng: 设置技能天赋点
__aCodeList["SetTalentPoint"] = function(self,_,num)
	LuaSetHeroMapTalentPoint(num)
	return self:doNextAction()
end

--wangcheng: 统计随机地图击杀的小bossid
__aCodeList["CountBossId"] = function(self)
	print("CountBossId")
	local d = self.data
	local oUnit = d.unit --BOSS

	--只有随机地图才记录小BOSSID
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(diablodata.randMap) == "table" then
		local tInfos = {
			{"bossid_l",oUnit.data.id},
		}
		LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
		--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	end

	return self:doNextAction()
end

--单位模型变大
__aCodeList["SetUnitModelScale_Diablo"] = function(self, _, targetType, scale)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	--存储
	if (type(scale) == "string") then
		scale = __AnalyzeValueExpr(self, unit, scale, "number")
	end
	
	if (scale < 0.0001) then
		scale = 0.0001
	end
	
	if unit then
		if unit.handle._n then
			local typeId = unit.data.id
			--local scale0 = hVar.tab_unit[typeId].scale or 1.0
			--print(hVar.tab_unit[typeId].name, scale0, scale)
			--unit.handle._n:setScale(scale * scale0)
			unit.handle._n:setScale(scale)
		end
	end
	
	return self:doNextAction()
end




--------------------------------------------------------------------------------------------
--==========================================================================================










__aCodeList["SetPower"] = function(self,_,value)
	local d = self.data
	d.power = __AnalyzeValueExpr(self,d.unit,value,"number")
	return self:doNextAction()
end

__aCodeList["SetPowerMultiply"] = function(self,_,value)
	local d = self.data
	if d.power~=0 then
		local v = __AnalyzeValueExpr(self,d.unit,value,"number")
		d.power = hApi.getint(d.power*v/100)
	end
	return self:doNextAction()
end

--__aCodeList["DragTarget"] = function(self,_,dis)
--	local d = self.data
--	local u = d.unit
--	local t = d.target
--	if t and t~=0 and t.ID>0 and t.data.IsDead~=1 and not(t.attr.passive>0 or t.data.partID~=0 or (d.IsFlee==1 and t.attr.fleecount>0)) then
--		local w = u:getworld()
--		local g = t:getmovegrid(dis,1)
--		local dis = {}
--		local disMin = 999
--		for i = 1,#g do
--			dis[i] = w:distanceU(t,u,1,g[i].x,g[i].y)
--			disMin = math.min(dis[i],disMin)
--		end
--		local rand = {}
--		for i = 1,#dis do
--			if dis[i]==disMin then
--				rand[#rand+1] = i
--			end
--		end
--		if #rand>0 then
--			local p = g[rand[w:random(1,#rand,"dragTarget")]]
--			t:setgrid(p.x,p.y,hVar.OPERATE_TYPE.UNIT_TELEPORT)
--		end
--	end
--	return self:doNextAction()
--end

__aCodeList["SetAssist"] = function(self,_,mode,key,allienceU,allienceT,id,delay,rMin,rMax)
	local w = self.data.world
	local oRound = w:getround()
	local u
	if mode=="unit" then
		u = self.data.unit
	elseif mode=="target" then
		u = self.data.target
	end
	if oRound and u and u~=0 and u.ID>0 and u.data.IsDead~=1 then
		local idx = self.data.skillId
		oRound:setassist(u,idx,key,allienceU,allienceT,id,delay,rMin,rMax)
	end
	return self:doNextAction()
end

__aCodeList["RemoveAssist"] = function(self,_,mode,key,id,idx)
	local w = self.data.world
	local oRound = w:getround()
	local u
	if mode=="unit" then
		u = self.data.unit
	elseif mode=="target" then
		u = self.data.target
	end
	if oRound and u and u~=0 and u.ID>0 then
		if idx==nil then
			idx = self.data.skillId
		end
		oRound:removeassist(u,idx,key,id)
	end
	return self:doNextAction()
end

--复位本回合开始时的朝向
__aCodeList["ResetFacing"] = function(self,_,mode)
	local w = self.data.world
	local oRound = w:getround()
	local u
	if mode=="unit" then
		u = self.data.unit
	elseif mode=="target" then
		u = self.data.target
	end
	if oRound and u and u~=0 and u.ID>0 then
		u:facingto(u.data.rfacing)
	end
	return self:doNextAction()
end

__aCodeList["AutoOrder"] = function(self,_,nOrderDelay,nOrderType,sOrderUnit,sOrder,sOrderTarget,ToDo,ElseToDo)
	local w = self.data.world
	local oRound = w:getround()
	local d = self.data
	local u
	local t
	local sus = 0
	if sOrderUnit=="unit" then
		u = d.unit
	elseif sOrderUnit=="target" then
		u = d.target
	end
	if sOrderTarget=="unit" then
		t = d.unit
	elseif sOrderTarget=="target" then
		t = d.target
	elseif type(sOrderTarget)=="string" then
		--随机攻击
		if string.sub(sOrderTarget,1,6)=="random" then
			local id,rMin,rMax
			if type(sOrder)=="number" and hVar.tab_skill[sOrder] then
				id = sOrder
				if hVar.tab_skill[sOrder].template=="RangeAttack" then
					rMin = -1
					rMax = -1
				elseif hVar.tab_skill[sOrder].range then
					rMin = hVar.tab_skill[sOrder].range[1]
					rMax = hVar.tab_skill[sOrder].range[2]
				else
					rMin = u.attr.attack[2]
					rMax = u.attr.attack[3]
				end
			elseif sOrder=="attack" then
				id = hApi.GetDefaultSkill(u)
				if id~=0 then
					if id==d.skillId then
						--什么一个技能触发了攻击，而且id还等于自己？
						--使用普通攻击吧骚年
						id = 28
					end
					rMin,rMax = hApi.GetSkillRange(id,u)
				end
			end
			if id and id~=0 and rMin and rMax then
				local nLen = string.len(sOrderTarget)
				local nAnyAllience = 0
				if nLen>6 then
					local sOrderEx = string.sub(sOrderTarget,7,nLen)
					if string.find(sOrderEx,"F") then
						nAnyAllience = 1
					end
					if string.find(sOrderEx,"N") then
						if rMax<0 or (rMin<=1 and rMax>=1) then
							rMin = 1
							rMax = 1
						else
							id = 0
						end
					end
				end
				if id and id~=0 and rMin and rMax then
					local tTab = {}
					w:enumunitUR(u,rMin,rMax,function(oTarget)
						if hApi.IsSafeTarget(u,id,oTarget,nil,nAnyAllience) then
							tTab[#tTab+1] = oTarget
						end
					end)
					if #tTab>0 then
						t = tTab[w:random(1,#tTab,"AutoOrder")]
					end
				end
			end
		end
	end
	if oRound and u and u~=0 and u.ID>0 and u.data.IsDead~=1 then
		if t and t~=0 then
			if nOrderType==0 then
				nOrderType = hVar.ORDER_TYPE.SYSTEM
			end
			--目标指向命令
			if t.ID>0 and t.data.IsDead~=1 then
				local id = 0
				if sOrder=="attack" then
					id = hApi.GetDefaultSkill(u)
				elseif type(sOrder)=="number" then
					id = sOrder
				end
				local tabS = hVar.tab_skill[id]
				if id~=0 and tabS and tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
					local rMin,rMax = hApi.GetSkillRange(id,u)
					if rMax<0 then
						--远程攻击
						sus = 1
						oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,t,id)
					else
						--近战攻击
						local dis = w:distanceU(u,t,1)
						if dis>=rMin and dis<=rMax then
							sus = 1
							oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,t,id,rMin,rMax)
						end
					end
				end
			end
		else
			--无目标的命令
			if sOrder=="moveback" then
				sus = 1
				--必须是系统命令，不然会多次触发黑王
				nOrderType = hVar.ORDER_TYPE.SYSTEM
				--返回
				local gridX,gridY = u.data.rgridX,u.data.rgridY
				oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.UNIT_MOVE,gridX,gridY)
			elseif sOrder=="move" then
				sus = 1
				--必须是系统命令，不然会多次触发黑王
				nOrderType = hVar.ORDER_TYPE.SYSTEM
				--移动到目标
				local gridX,gridY = d.gridX,d.gridY
				oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.UNIT_MOVE,gridX,gridY)
			elseif type(sOrder)=="number" and hVar.tab_skill[sOrder] then
				local id = sOrder
				if nOrderType==0 then
					nOrderType = hVar.ORDER_TYPE.SYSTEM
				end
				if hVar.tab_skill[sOrder].cast_type==hVar.CAST_TYPE.IMMEDIATE then
					sus = 1
					local gridX,gridY
					if sOrderTarget=="origin" then
						gridX,gridY = u.data.gridX,u.data.gridY
					elseif sOrderTarget=="back" then
						gridX,gridY = u.data.rgridX,u.data.rgridY
					else
						gridX,gridY = d.gridX,d.gridY
					end
					oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,id,gridX,gridY)
				elseif hVar.tab_skill[sOrder].cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
					sus = 1
					local gridX,gridY
					if sOrderTarget=="origin" then
						gridX,gridY = u.data.gridX,u.data.gridY
					elseif sOrderTarget=="back" then
						gridX,gridY = u.data.rgridX,u.data.rgridY
					else
						gridX,gridY = d.gridX,d.gridY
					end
					oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_GRID,id,gridX,gridY)
				elseif hVar.tab_skill[sOrder].cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
					if t and t~=0 and t.ID>0 and t.data.IsDead~=1 then
						sus = 1
						oRound:autoorder(nOrderDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,t,id)
					end
				end
			end
		end
	end
	if sus==1 then
		if type(ToDo)=="table" and ToDo[1]~=nil and __aFailToProcess[ToDo[1]]~=1 and __aCodeList[ToDo[1]] then
			return __aCodeList[ToDo[1]](self,unpack(ToDo))
		end
	else
		if type(ElseToDo)=="table" and ElseToDo[1]~=nil and __aFailToProcess[ElseToDo[1]]~=1 and __aCodeList[ElseToDo[1]] then
			return __aCodeList[ElseToDo[1]](self,unpack(ElseToDo))
		end
	end
	return self:doNextAction()
end

local __ENUM__GetUnitById = function(oUnit,tParam)
	if tParam.idx[oUnit.data.id]==1 and oUnit.data.IsDead==0 then
		if tParam.typ=="ALLY" then
			if oUnit.data.owner==tParam.owner then
				tParam.count = tParam.count + 1
			end
		elseif tParam.typ=="ENEMY" then
			if oUnit.data.owner~=tParam.owner then
				tParam.count = tParam.count + 1
			end
		elseif tParam.typ=="ALL" then
			tParam.count = tParam.count + 1
		end
	end
end

__aCodeList["CountUnit"] = function(self,_,toParamVar,sAlly,tId)
	local d = self.data
	local tParam = {idx={},owner = d.unit.data.owner,typ=sAlly,count=0}
	if type(tId)=="table" then
		for i = 1,#tId do
			tParam.idx[tId[i]] = 1
		end
	else
		tParam.idx[tId] = 1
	end
	d.world:enumunit(__ENUM__GetUnitById,tParam)
	if type(sAlly)=="string" then
		d.tempValue[toParamVar] = tParam.count
	end
	return self:doNextAction()
end

--
--__aCodeList["SummonUnit"] = function(self,_,id,stack,ToDo)
--	local d = self.data
--	local w = d.world
--	local oRound = w:getround()
--	local u = d.unit
--	if w.ID~=0 and oRound~=nil and hVar.tab_unit[id] then
--		local scale = hApi.getint((hVar.tab_unit[id].scaleB or 1)*100)
--		local num = __AnalyzeValueExpr(self,u,stack,"number")
--		local nOwner = u.data.owner
--		--召唤生物如果为建筑，那么改变属方为中立，任何玩家均可摧毁
--		if hVar.tab_unit[id] and hVar.tab_unit[id].type==hVar.UNIT_TYPE.BUILDING then
--			nOwner = 0
--		end
--		local tGridSelectMode
--		local tabS = hVar.tab_skill[d.skillId]
--		if tabS and tabS.summon_mode==1 then
--			--固定位置召唤
--		else
--			tGridSelectMode = {x=d.worldX,y=d.worldY}
--		end
--		local c = w:addunit(id,nOwner,d.gridX,d.gridY,u.data.facing,nil,nil,{stack=num},{IsSummoned=1,scale=scale,GridSelectMode=tGridSelectMode})
--		if c~=nil then
--			self:addControlUnit(c)
--			if c.data.type==hVar.UNIT_TYPE.HERO or c.data.type==hVar.UNIT_TYPE.UNIT then
--				local oriTarget = d.target
--				d.IsPaused = 1
--				d.target = c
--				if type(ToDo)=="table" and ToDo[1]~=nil and __aCodeList[ToDo[1]] then
--					__aCodeList[ToDo[1]](self,unpack(ToDo))
--				end
--				if c.data.IsDead==0 then
--					--召唤生物攻击加成
--					if u.attr.summonpower>0 then
--						__aCodeList["AddAttrPec"](self,"AddAttrPec","target","Atk",u.attr.summonpower,0)
--					end
--					--召唤生物生命加成
--					if u.attr.summonhp>0 then
--						__aCodeList["AddAttrPec"](self,"AddAttrPec","target","mxhp",u.attr.summonhp,0)
--					end
--					oRound:newunit(c)
--					hGlobal.event:call("Event_UnitBorn",c)
--					local tAutoList = w:newunitBF(c)
--					w:autoorderBF(tAutoList)
--				end
--				d.IsPaused = 0
--				d.target = oriTarget
--			end
--		end
--	end
--	return self:doNextAction()
--end

--geyachao: 读取当前地图配置的难度和等级
__aCodeList["GetMapDifficulty"] = function(self, _, paramDiff, paramLv)
	local d = self.data
	local world = self.data.world
	
	if world then
		local mapInfo = world.data.tdMapInfo
		local lv = 1
		local diff = world.data.MapDifficulty
		if mapInfo.isMapDiffEnemyLv then
			lv = mapInfo.mapDiffEnemyLv[diff] or 1
			--print("TD_Invasion_Loop lv:",diff,lv)
		end
		
		--存储地图难度
		if paramDiff then
			d.tempValue[paramDiff] = diff
		end
		
		--存储地图等级
		if paramLv then
			d.tempValue[paramLv] = lv
		end
	end
	
	return self:doNextAction()
end

--geyachao: 读取当前层数
__aCodeList["GetMapCurrentStage"] = function(self, _, paramStage)
	local d = self.data
	local world = self.data.world
	
	if world then
		local stage = world.data.pvp_round or 1
		
		--存储地图当前层数
		if paramStage then
			d.tempValue[paramStage] = stage
		end
	end
	
	return self:doNextAction()
end

--geyachao: 单位学习技能
__aCodeList["ChaLearnSkill_TD"] = function(self, _, unitType, skillId, skillLv, cooldown)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId]
	end
	
	if (type(skillLv) == "string") then
		skillLv = d.tempValue[skillLv]
	end
	
	if (type(cooldown) == "string") then
		cooldown = d.tempValue[cooldown]
	end
	
	cooldown = cooldown or math.huge
	
	if oUnit then
		--学习技能
		oUnit:addskill(skillId, skillLv, nil, nil, nil, cooldown, 0)
	end
	
	return self:doNextAction()
end

--单位遗忘技能
__aCodeList["ForgottenSkill_TD"] = function(self, _, unitType, skillId)
	local d = self.data
	local world = self.data.world
	local oUnit = nil
	if (unitType == "unit") then
		oUnit = d.unit
	elseif (unitType == "target") then
		oUnit = d.target
	end
	
	if (type(skillId) == "string") then
		skillId = d.tempValue[skillId]
	end

	if oUnit then
		--遗忘技能
		oUnit:removeskill(skillId)
	end
	
	return self:doNextAction()
end

--geyachao: 新加 获得单位的typeID
__aCodeList["GetUnitTypeID_TD"] = function(self, _, targetType, param)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local typeID = 0
	
	if unit and (unit ~= 0) then
		typeID = unit.data.id
	end
	
	d.tempValue[param] = typeID
	
	return self:doNextAction()
end

--geyachao: 新加 获得单位的玩家位置
__aCodeList["GetUnitPlayerPos_TD"] = function(self, _, targetType, param)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local unitPos = 0
	
	if unit then
		unitPos = unit:getowner():getpos()
	end
	
	d.tempValue[param] = unitPos
	
	return self:doNextAction()
end

--geyachao: 新加 获得单位的玩家名字
__aCodeList["GetUnitPlayerName_TD"] = function(self, _, targetType, param)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local unitName = ""
	
	if unit then
		local player = unit:getowner()
		if player then
			unitName = player.data.name
		end
	end
	
	d.tempValue[param] = unitName
	
	return self:doNextAction()
end

--geyachao: 新加 获得单位的性别
__aCodeList["GetUnitSex_TD"] = function(self, _, targetType, param)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local unitSex = 0
	
	if unit then
		--local typeId = unit.data.id
		--unitSex = hVar.tab_unit[typeId].role_sex or hVar.ROLE_SEX.NONE
		unitSex = unit.attr.role_sex
	end
	
	d.tempValue[param] = unitSex
	
	return self:doNextAction()
end

--geyachao: 游戏胜利前设置战车无敌
__aCodeList["SetTankWUDI_TD"] = function(self, _)
	print("SetTankWUDI_TD")
	
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	--游戏胜利前设置战车无敌
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			local me = w:GetPlayerMe()
			if me then
				local heros = me.heros
				local oHero = heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						--标记单位沉睡
						oUnit.attr.suffer_sleep_stack = oUnit.attr.suffer_sleep_stack + 1
						
						local nSkillId = 16045
						local nBuffLv = 1
						local nBuffTime = -1
						__CODE__CastBuff(self, oUnit, oUnit, nSkillId, -1, d.power, nBuffLv, nBuffTime)
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 直接设置游戏结束
__aCodeList["SetGameEnd_TD"] = function(self, _, gameResult)
	print("SetGameEnd_TD", gameResult)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	if (type(gameResult) == "string") then
		gameResult = self.data.tempValue[gameResult] --读temp表里的值
	end
	
	local result = hVar.MAP_TD_STATE.SENDARMY
	if (gameResult == 1) then
		result = hVar.MAP_TD_STATE.SUCCESS
	elseif (gameResult == 0) then
		result = hVar.MAP_TD_STATE.FAILED
	end
	
	--快速游戏结束
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			--保存随机地图的通关BOSS
			local nBossID = u.data.id
			local diablo = hGlobal.LocalPlayer.data.diablodata
			if diablo and type(diablo.randMap) == "table" then
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				local nStage = tInfo.stage or 1
				if tInfo.stageInfo == nil then
					tInfo.stageInfo = {}
				end
				--记录bossid
				tInfo.stageInfo[nStage] = tInfo.stageInfo[nStage] or {}
				tInfo.stageInfo[nStage].bossid = nBossID
				LuaSavePlayerList()
			end
			mapInfo.mapState = result
		end
	end
	
	return self:doNextAction()
end

--geyachao: 随机地图击杀boss事件
__aCodeList["RandomMap_KillBoss_Diablo"] = function(self, _)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	local regionId = w.data.randommapIdx
	
	if (regionId > 0) then
		--5秒后开启下一关
		w:addtimer("__Randommap_KillBoss_Timer", 5000, function(deltaTime)
			w:removetimer("__Randommap_KillBoss_Timer")
			
			--音效
			hApi.PlaySound("magic12")
			
			--击杀boss后开启下一区域
			hApi.RandMapKillBoss(w, regionId, u)
		end)
	end
	
	return self:doNextAction()
end

--geyachao: 获得当前波次
__aCodeList["GetMapCurrentWave"] = function(self, _, paramWave)
	local d = self.data
	local world = self.data.world
	
	--默认值
	if paramWave then
		d.tempValue[paramWave] = 0
	end
	
	if world then
		local mapInfo = world.data.tdMapInfo
		if mapInfo then
			--当前波次
			local waveNow = mapInfo.wave
			
			--存储地图当前波次
			if paramWave then
				d.tempValue[paramWave] = waveNow
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 获得最大波次
__aCodeList["GetMapTotalWave"] = function(self, _, paramTotalWave)
	local d = self.data
	local world = self.data.world
	
	--默认值
	if paramTotalWave then
		d.tempValue[paramTotalWave] = 0
	end
	
	if world then
		local mapInfo = world.data.tdMapInfo
		if mapInfo then
			--最大波次
			local totalWave = mapInfo.totalWave
			
			--存储地图当前波次
			if paramTotalWave then
				d.tempValue[paramTotalWave] = totalWave
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 设置地图的当前波次
__aCodeList["SetMapCurrentWave"] = function(self, _, wave)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	if (type(wave) == "string") then
		wave = __AnalyzeValueExpr(self,u,wave,"number")
	end
	
	--设置当前波次
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			--设置的波次不同时，清理缓存
			if (mapInfo.wave ~= wave) then
				--释放png, plist的纹理缓存
				hApi.ReleasePngTextureCache()
			end
			
			--当前波次
			mapInfo.wave = wave
			
			--触发事件：设置波次发生变化
			hGlobal.event:event("LocalEvent_SetWaveChanged")
			
			--geyachao: 波次改变特殊处理函数
			if OnGameWaveChanged_Special_Event then
				--安全执行
				hpcall(OnGameWaveChanged_Special_Event, wave)
				--OnGameWaveChanged_Special_Event(wave)
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 设置地图的最大波次
__aCodeList["SetMapTotalWave"] = function(self, _, maxWave)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	
	if (type(maxWave) == "string") then
		maxWave = __AnalyzeValueExpr(self,u,maxWave,"number")
	end
	
	--设置当前波次
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			--最大波次
			mapInfo.totalWave = maxWave
			
			--触发事件：设置波次发生变化
			hGlobal.event:event("LocalEvent_SetWaveChanged")
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加在施法者身边召唤多个单位（与施法者的阵营一致，同施法者路点相似）
__aCodeList["SummonUnit_Nearby"] = function(self, _, typeId, num, radius, lv, star)
	local oUnit = self.data.unit --角色
	
	--角色活着,zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local world = self.data.world
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		if (type(num) == "string") then
			num = self.data.tempValue[num] --读temp表里的值
		end
		if (type(lv) == "string") then
			lv = self.data.tempValue[lv] --读temp表里的值
		end
		if (type(star) == "string") then
			star = self.data.tempValue[star] --读temp表里的值
		end
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		for i = 1, num, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local randPosX, randPosY = 0, 0
			local dx, dy = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
				dx, dy = 0, 0
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				dx = r * math.cos(fangle) --随机偏移值x
				dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star
			local cha = world:addunit(typeId, oUnit:getowner():getpos(), nil, nil, facing, randPosX, randPosY, nil, nil, lv, star)
			--print("SummonUnit_Nearby:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
			if cha then
				--设置目标AI状态
				--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置目标的路点
				cha:copyRoadPoint(oUnit)
				
				--触发事件：添加单位
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				self.data.tempValue["SummonUnitList"] = self.data.tempValue["SummonUnitList"] or {}
				self.data.tempValue["SummonUnitList"][(#(self.data.tempValue["SummonUnitList"]))+1] = cha
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加在施法者身边召唤多个单位（中立或敌人，按指定路点走）
--参数formation 阵型: hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE, hVar.TD_DEPLOY_TYPE.ONE_RANDOM_DISTANCE 默认：hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE
__aCodeList["SummonUnit_Nearby_RoadPoint"] = function(self, _, typeIdList, radius, lv, star, pathIdx, offsetX, offsetY, formation, livetime, force)
	--print(typeIdList, radius, lv, star, pathIdx, offsetX, offsetY, formation, livetime)
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着,zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local world = self.data.world
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		--local wayPoint = oUnit:getRoadPoint() --角色的路点
		if (type(num) == "string") then
			num = self.data.tempValue[num] --读temp表里的值
		end
		if (type(lv) == "string") then
			lv = self.data.tempValue[lv] --读temp表里的值
		end
		if (type(star) == "string") then
			star = self.data.tempValue[star] --读temp表里的值
		end
		offsetX = offsetX or 0
		offsetY = offsetY or 0
		if (type(offsetX) == "string") then
			offsetX = self.data.tempValue[offsetX] --读temp表里的值
		end
		if (type(offsetY) == "string") then
			offsetY = self.data.tempValue[offsetY] --读temp表里的值
		end
		if (type(livetime) == "string") then
			livetime = d.tempValue[livetime] --读temp表里的值
		end
		if (type(force) == "string") then
			force = d.tempValue[force] --读temp表里的值
		end
		
		--有一定的偏移值
		unitPosX = unitPosX + offsetX
		unitPosY = unitPosY + offsetY
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		local num = #typeIdList --数量
		for i = 1, num, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local typeId = typeIdList[i]
			local randPosX, randPosY = 0, 0
			local dx, dy = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
				dx, dy = 0, 0
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				dx = r * math.cos(fangle) --随机偏移值x
				dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			local mapInfo = world.data.tdMapInfo
			
			local dType = hVar.TD_DEPLOY_TYPE
			local f = dType.ONE_SAME_DISTANCE
			--local f = dType.ONE_RANDOM_DISTANCE
			if formation and formation >= dType.ONE_POINT_CENTER and formation <= dType.ONE_RANDOM_DISTANCE then
				f = formation
			end
			--出单个怪
			
			--计算小兵起始点及路点
			local beginPos = {x = randPosX, y = randPosY, faceTo = facing,isHide = 0}
			local wayPoint = mapInfo.pathList[pathIdx]
			--local beginPoint, movePoint = mapInfo.CalculateMovePoint(beginPos, wayPoint, f)
			
			--添加角色
			local unitOwner = oUnit:getowner()
			if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
				if (unitOwner == world:GetPlayerMe()) then
					unitOwner = world:GetForce(world:GetPlayerMe():getforce())
				end
			end
			--print("SummonUnit_Nearby_RoadPoint", oUnit.data.name, typeId, unitOwner:getpos(), nil, nil, beginPos.faceTo, beginPos.x, beginPos.y, nil, nil, lv, star)
			local nOwner = unitOwner:getpos()
			--如果传入阵营，按传入的来
			if force then
				if (force == hVar.FORCE_DEF.GOD) then --神
					nOwner = 1
				elseif (force == hVar.FORCE_DEF.SHU) then --蜀国
					nOwner = 21
				elseif (force == hVar.FORCE_DEF.WEI) then --魏国
					nOwner = 22
				elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意
					nOwner = 23
				elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意
					nOwner = 24
				end
			end
			local cha = world:addunit(typeId, nOwner, nil, nil, beginPos.faceTo, beginPos.x, beginPos.y, nil, nil, lv, star)
			--print(cha.data.name, cha.data.facing)
			if cha then
				--设置隐身
				if beginPos.isHide and beginPos.isHide > 0 then
					cha:SetYinShenState(1)
				end
				
				--设置角色AI状态
				--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置角色的路点
				cha:setRoadPoint(pathIdx, f, 1)
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					cha.data.livetime = livetime --新加数据 生存时间（毫秒）
					cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				
				--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
				d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = cha
				
				--是否为rpgunits
				if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
					if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
						world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end


--geyachao: 新加竞技场PVP在施法者身边召唤多个单位（中立或敌人，按指定路点走），该单位会获得自己携带的指定兵种卡的属性加成
--参数formation 阵型: hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE, hVar.TD_DEPLOY_TYPE.ONE_RANDOM_DISTANCE 默认：hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE
__aCodeList["SummonUnit_Nearby_RoadPoint_Tactic_PVP"] = function(self, _, tacticId, typeIdList, radius, lv, star, pathIdx, offsetX, offsetY, formation, livetime)
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着,zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local world = self.data.world
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		--local wayPoint = oUnit:getRoadPoint() --角色的路点
		if (type(num) == "string") then
			num = self.data.tempValue[num] --读temp表里的值
		end
		if (type(lv) == "string") then
			lv = self.data.tempValue[lv] --读temp表里的值
		end
		if (type(star) == "string") then
			star = self.data.tempValue[star] --读temp表里的值
		end
		offsetX = offsetX or 0
		offsetY = offsetY or 0
		if (type(offsetX) == "string") then
			offsetX = self.data.tempValue[offsetX] --读temp表里的值
		end
		if (type(offsetY) == "string") then
			offsetY = self.data.tempValue[offsetY] --读temp表里的值
		end
		if (type(livetime) == "string") then
			livetime = d.tempValue[livetime] --读temp表里的值
		end
		
		--有一定的偏移值
		unitPosX = unitPosX + offsetX
		unitPosY = unitPosY + offsetY
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		local num = #typeIdList --数量
		for i = 1, num, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local typeId = typeIdList[i]
			local randPosX, randPosY = 0, 0
			local dx, dy = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
				dx, dy = 0, 0
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				dx = r * math.cos(fangle) --随机偏移值x
				dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			local mapInfo = world.data.tdMapInfo
			
			local dType = hVar.TD_DEPLOY_TYPE
			local f = dType.ONE_SAME_DISTANCE
			--local f = dType.ONE_RANDOM_DISTANCE
			if formation and formation >= dType.ONE_POINT_CENTER and formation <= dType.ONE_RANDOM_DISTANCE then
				f = formation
			end
			--出单个怪
			
			--计算小兵起始点及路点
			local beginPos = {x = randPosX, y = randPosY, faceTo = facing,isHide = 0}
			local wayPoint = mapInfo.pathList[pathIdx]
			--local beginPoint, movePoint = mapInfo.CalculateMovePoint(beginPos, wayPoint, f)
			
			--添加角色
			local unitOwner = oUnit:getowner()
			if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
				if (unitOwner == world:GetPlayerMe()) then
					unitOwner = world:GetForce(world:GetPlayerMe():getforce())
				end
			end
			--print("SummonUnit_Nearby_RoadPoint", oUnit.data.name, typeId, unitOwner:getpos(), nil, nil, beginPos.faceTo, beginPos.x, beginPos.y, nil, nil, lv, star)
			local cha = world:addunit(typeId, unitOwner:getpos(), nil, nil, beginPos.faceTo, beginPos.x, beginPos.y, nil, nil, lv, star)
			--print(cha.data.name, cha.data.facing)
			if cha then
				--设置隐身
				if beginPos.isHide and beginPos.isHide > 0 then
					cha:SetYinShenState(1)
				end
				
				--设置角色AI状态
				--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置角色的路点
				cha:setRoadPoint(pathIdx, f, 1)
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					cha.data.livetime = livetime --新加数据 生存时间（毫秒）
					cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				
				--geyachao: 附加兵种卡的强化属性
				__Append_Tactic_Attr_PVP(cha, tacticId, d.tempValue)
				
				--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
				d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = cha
				
				--是否为rpgunits
				if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
					if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
						world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加在施法者阵营身边召唤多个目标（无路点）（目标有生存时间）
__aCodeList["SummonUnit_NearbyHero"] = function(self, _, typeId, unitLv, unitStar, num, radius, livetime)
	--print("SummonUnit_NearbyHero, 新加在我方英雄身边召唤多个目标（目标有生存时间）")
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着 zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local summonNum = num --召唤目标的数量
		local world = oUnit:getworld()
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		if (type(num) == "string") then
			summonNum = self.data.tempValue[num] --读temp表里的值
		end
		if (type(unitLv) == "string") then
			unitLv = self.data.tempValue[unitLv] --读temp表里的值
		end
		if (type(unitStar) == "string") then
			unitStar = self.data.tempValue[unitStar] --读temp表里的值
		end
		if (type(livetime) == "string") then
			livetime = self.data.tempValue[livetime] --读temp表里的值
		end
		--print("summonNum=" .. summonNum)
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		for i = 1, summonNum, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local randPosX, randPosY = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				local dx = r * math.cos(fangle) --随机偏移值x
				local dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star
			local cha = world:addunit(typeId, oUnit.data.owner, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
			--print("SummonUnit_NearbyHero", cha.data.name, typeId, cha.data.owner, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
			--print(cha.data.name, cha.data.facing)
			--print("SummonUnit_NearbyHero:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
			if cha then
				--设置目标AI状态
				--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					cha.data.livetime = livetime --新加数据 生存时间（毫秒）
					cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				--cha.data.defend_distance_max = distance_max --最远能到达的守卫距离
				
				--触发事件：创建单位
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
				d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = cha
				
				--是否为rpgunits
				if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
					if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
						world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加竞技场PVP在施法者阵营身边召唤多个目标（无路点）（目标有生存时间），该单位会获得自己携带的指定兵种卡的属性加成
__aCodeList["SummonUnit_NearbyHero_Tactic_PVP"] = function(self, _, tacticId, typeId, unitLv, unitStar, num, radius, livetime)
	--print("SummonUnit_NearbyHero, 新加在我方英雄身边召唤多个目标（目标有生存时间）")
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着 zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local summonNum = num --召唤目标的数量
		local world = oUnit:getworld()
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		if (type(num) == "string") then
			summonNum = self.data.tempValue[num] --读temp表里的值
		end
		if (type(unitLv) == "string") then
			unitLv = self.data.tempValue[unitLv] --读temp表里的值
		end
		if (type(unitStar) == "string") then
			unitStar = self.data.tempValue[unitStar] --读temp表里的值
		end
		if (type(livetime) == "string") then
			livetime = self.data.tempValue[livetime] --读temp表里的值
		end
		--print("summonNum=" .. summonNum)
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		for i = 1, summonNum, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local randPosX, randPosY = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				local dx = r * math.cos(fangle) --随机偏移值x
				local dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star
			local cha = world:addunit(typeId, oUnit.data.owner, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
			--print("SummonUnit_NearbyHero", cha.data.name, typeId, cha.data.owner, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
			--print(cha.data.name, cha.data.facing)
			--print("SummonUnit_NearbyHero:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
			if cha then
				--设置目标AI状态
				--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				cha.data.is_summon = 1
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					cha.data.livetime = livetime --新加数据 生存时间（毫秒）
					cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				--cha.data.defend_distance_max = distance_max --最远能到达的守卫距离
				
				--geyachao: 附加兵种卡的强化属性
				__Append_Tactic_Attr_PVP(cha, tacticId, d.tempValue)
				
				--触发事件：创建单位
				hGlobal.event:call("Event_UnitBorn", cha)
				
				--将该单位存到召唤单位缓存表中
				d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
				d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = cha
				
				--是否为rpgunits
				if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
					if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
						world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加在指定地点附近召唤与施法者阵营一样的单位（无路点）（目标有生存时间）
__aCodeList["SummonUnit_Point"] = function(self, _, typeId, unitLv, unitStar, num, radius, livetime, offsetX, offsetY, force)
	--print("SummonUnit_Point")
	local d = self.data
	local oUnit = d.unit --角色
	
	local facing = hVar.UNIT_DEFAULT_FACING --角色的朝向
	local summonNum = num --召唤目标的数量
	local world = hGlobal.WORLD.LastWorldMap
	local unitPosX, unitPosY = world:grid2xy(d.gridX, d.gridY) --点击的位置转化为大地图上的坐标
	
	if (type(typeId) == "string") then
		typeId = d.tempValue[typeId] --读temp表里的值
	end
	if (type(unitLv) == "string") then
		unitLv = d.tempValue[unitLv] --读temp表里的值
	end
	if (type(unitStar) == "string") then
		unitStar = d.tempValue[unitStar] --读temp表里的值
	end
	if (type(num) == "string") then
		summonNum = d.tempValue[num] --读temp表里的值
	end
	if (type(livetime) == "string") then
		livetime = d.tempValue[livetime] --读temp表里的值
	end
	
	if (type(force) == "string") then
		force = d.tempValue[force] --读temp表里的值
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	if (type(offsetX) == "string") then
		--offsetX = self.data.tempValue[offsetX] --读temp表里的值
		offsetX = __AnalyzeValueExpr(self, d.unit, offsetX, "number")
	end
	if (type(offsetY) == "string") then
		--offsetY = self.data.tempValue[offsetY] --读temp表里的值
		offsetY = __AnalyzeValueExpr(self, d.unit, offsetY, "number")
	end
	--print("summonNum=" .. summonNum)
	local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
	local targetAngle = {} --目标的坐标偏移角度列表
	
	--依次添加目标
	for i = 1, summonNum, 1 do
		if (#targetAngle == 0) then --避免随不到
			for i = 1, #targetAngleOrigin, 1 do
				table.insert(targetAngle, targetAngleOrigin[i])
			end
		end
		
		--出生点坐标
		local randPosX, randPosY = 0, 0
		if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
			randPosX, randPosY = unitPosX + offsetX, unitPosY + offsetY
		else --取随机位置
			local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
			local angle = targetAngle[randAngleIdx] --随机角度
			table.remove(targetAngle, randAngleIdx)
			local r = world:random(30, radius) --随机偏移半径
			local fangle = angle * math.pi / 180 --弧度制
			local dx = r * math.cos(fangle) --随机偏移值x
			local dy = r * math.sin(fangle) --随机偏移值y
			randPosX = unitPosX + offsetX + dx --随机x位置
			randPosY = unitPosY + offsetY + dy --随机y位置
			randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			--print(randAngleIdx, angle, r, dx, dy, randPosX, randPosY)
		end
		--randPosX, randPosY = world:grid2xy(d.gridX, d.gridY)
		--randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
		--geyahao: print
		--print("unitLv", unitLv)
		--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star
		
		--添加角色
		local unitForce = force or oUnit:getowner():getpos()
		local cha = world:addunit(typeId, unitForce, nil, nil, facing, randPosX, randPosY, nil, nil, unitLv, unitStar)
		--print("SummonUnit_Point:".. tostring(cha.data.name)..",hp =".. tostring(cha.attr.hp)..",sommonunit = ".. tostring(cha.__ID))
		if cha then
			--设置目标AI状态
			--cha:setAIState(hVar.UNIT_AI_STATE.IDLE)
			
			--geyachao: 标记该单位是召唤单位
			cha.data.is_summon = 1
			
			--设置生存时间
			if (livetime) and (livetime > 0) then
				local currenttime = world:gametime()
				
				cha.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
				oUnit.data.livetime = livetime --新加数据 生存时间（毫秒）
				cha.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
			end
			--cha.data.defend_distance_max = distance_max --最远能到达的守卫距离
			
			hGlobal.event:call("Event_UnitBorn", cha)
			
			--将该单位存到召唤单位缓存表中
			d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
			d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = cha
			
			--是否为rpgunits
			if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
				if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
					world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加施法者发兵 主城发兵
--参数skills: 单位初始可以被动释放的技能{{id, lv, cd(毫秒)}, ...}
--参数formation 阵型: hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE, hVar.TD_DEPLOY_TYPE.ONE_RANDOM_DISTANCE 默认：hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE
__aCodeList["SummonUnit_SendArmy"] = function(self, _, typeIdList, radius, lv, star, offsetX, offsetY, skills, formation, livetime)
	local d = self.data
	local oUnit = self.data.unit --角色
	
	--角色活着,zhenkira
	--if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) and oUnit.attr.hp > 0 then
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (self.data.unit_worldC == oUnit:getworldC()) then
		--print(oUnit.data.name)
		local facing = oUnit.data.facing --角色的朝向
		local world = self.data.world
		local unitPosX, unitPosY = hApi.chaGetPos(oUnit.handle) --角色的位置
		--local wayPoint = oUnit:getRoadPoint() --角色的路点
		if (type(num) == "string") then
			num = self.data.tempValue[num] --读temp表里的值
		end
		if (type(lv) == "string") then
			lv = self.data.tempValue[lv] --读temp表里的值
		end
		if (type(star) == "string") then
			star = self.data.tempValue[star] --读temp表里的值
		end
		offsetX = offsetX or 0
		offsetY = offsetY or 0
		if (type(offsetX) == "string") then
			offsetX = self.data.tempValue[offsetX] --读temp表里的值
		end
		if (type(offsetY) == "string") then
			offsetY = self.data.tempValue[offsetY] --读temp表里的值
		end
		if (type(livetime) == "string") then
			livetime = d.tempValue[livetime] --读temp表里的值
		end
		
		--有一定的偏移值
		unitPosX = unitPosX + offsetX
		unitPosY = unitPosY + offsetY
		
		local targetAngleOrigin = {50, 100, 150, 200, 250, 300} --目标的坐标偏移角度列表（用于随机位置）
		local targetAngle = {} --目标的坐标偏移角度列表
		
		--依次添加目标
		local num = #typeIdList --数量
		for i = 1, num, 1 do
			if (#targetAngle == 0) then --避免随不到
				for i = 1, #targetAngleOrigin, 1 do
					table.insert(targetAngle, targetAngleOrigin[i])
				end
			end
			
			--出生点坐标
			local typeId = typeIdList[i]
			local randPosX, randPosY = 0, 0
			local dx, dy = 0, 0
			if (radius == 0) then --如果填的随机半径为0，说明是精确摆放在该位置
				randPosX, randPosY = unitPosX, unitPosY
				dx, dy = 0, 0
			else --取随机位置
				local randAngleIdx = world:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local r = world:random(30, radius) --随机偏移半径
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				dx = r * math.cos(fangle) --随机偏移值x
				dy = r * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				randPosX = unitPosX + dx --随机x位置
				randPosY = unitPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 60)
			end
			
			local mapInfo = world.data.tdMapInfo
			
			local dType = hVar.TD_DEPLOY_TYPE
			local f = dType.ONE_SAME_DISTANCE
			--local f = dType.ONE_RANDOM_DISTANCE
			if formation and formation >= dType.ONE_POINT_CENTER and formation <= dType.ONE_RANDOM_DISTANCE then
				f = formation
			end
			--出单个怪
			
			--计算小兵起始点及路点
			local beginPos = {x = randPosX, y = randPosY, faceTo = facing,isHide = 0}
			local tPathInfo = oUnit:copyRoadPointInfo()
			--local beginPoint, movePoint = mapInfo.CalculateMovePoint(beginPos, wayPoint, f)
			
			--添加角色
			local unitOwner = oUnit:getowner()
			if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then --非pvp模式
				if (unitOwner == world:GetPlayerMe()) then
					unitOwner = world:GetForce(world:GetPlayerMe():getforce())
				end
			end
			
			--print("lv=" , lv, "star=", star)
			local oUnit = world:addunit(typeId, unitOwner:getpos(), nil, nil, beginPos.faceTo, beginPos.x, beginPos.y, nil, nil, lv, star)
			
			if oUnit then
				--设置隐身
				if beginPos.isHide and beginPos.isHide > 0 then
					oUnit:SetYinShenState(1)
				end
				
				--设置角色AI状态
				--oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
				
				--geyachao: 标记该单位是召唤单位
				oUnit.data.is_summon = 1
				
				--设置角色的路点
				if type(tPathInfo) == "table" then
					oUnit:setRoadPoint(tPathInfo[1], f, 1)
				elseif type(tPathInfo) == "number" then
					oUnit:setRoadPoint(tPathInfo, f, 1)
				end
				
				--如果单位有初始的技能，为单位赋予技能
				if skills then
					for s = 1, #skills, 1 do
						local skillId = skills[s][1]
						if (type(skillId) == "string") then
							skillId = self.data.tempValue[skillId] --读temp表里的值
						end
						
						local skillLv = skills[s][2]
						if (type(skillLv) == "string") then
							skillLv = self.data.tempValue[skillLv] --读temp表里的值
						end
						
						local skillCD = skills[s][3] --（单位；毫秒）
						if (type(skillCD) == "string") then
							skillCD = self.data.tempValue[skillCD] --读temp表里的值
						end
						
						--学习技能
						oUnit:addskill(skillId, skillLv, nil, nil, nil, skillCD, 0)
					end
				end
				
				--设置生存时间
				if (livetime) and (livetime > 0) then
					local currenttime = world:gametime()
					
					oUnit.data.livetimeBegin = currenttime --geyachao: 新加数据 生存时间开始值（毫秒）
					oUnit.data.livetime = livetime --新加数据 生存时间（毫秒）
					oUnit.data.livetimeMax = currenttime + livetime --geyachao: 新加数据 生存时间最大值（毫秒）
				end
				
				--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
				hGlobal.event:call("Event_UnitBorn", oUnit)
				
				--将该单位存到召唤单位缓存表中
				d.tempValue["SummonUnitList"] = d.tempValue["SummonUnitList"] or {}
				d.tempValue["SummonUnitList"][(#(d.tempValue["SummonUnitList"]))+1] = oUnit
				
				--是否为rpgunits
				if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
					if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
						world.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
					end
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 给之前全部召唤的单位加上倒计时和文字（只有同一阵营才会看到文字）
__aCodeList["SummonUnit_AddTimerLabel"] = function(self, _, strText, offsetX, offsetY)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local tList = d.tempValue["SummonUnitList"]
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if tList then
		local owner = u:getowner()
		local forceMe = w:GetPlayerMe():getforce() --我的的势力
		
		for i = 1, #tList, 1 do
			local eu = tList[i]
			local force = eu:getowner():getforce() --施法者的势力
			
			--我和该召唤单位在同一阵营
			if (forceMe == force) then
				--print("SummonUnit_AddTimerLabel", eu.data.name)
				
				local dx = -17
				local dy = 65
				local eu_x, eu_y = hApi.chaGetPos(eu.handle)
				local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --单位的包围盒
				--local eu_center_y = (eu_by / 2 + eu_bh / 2) + eu_bh --单位的中心点y位置
				local eu_center_y = (-eu_by) + 15--单位的中心点y位置
				if eu.chaUI["tempLabel"] then
					eu.chaUI["tempLabel"]:del()
				end
				eu.chaUI["tempLabel"] = hUI.label:new({
					parent = eu.handle._n,
					font = hVar.FONTC,
					size = 21,
					align = "LC",
					x = offsetX + dx,
					y = offsetY + eu_bh + 3 + 12 - 1, --英雄略大
					text = strText,
					border = 1,
				})
				
				--倒计时的动画
				if eu.chaUI["tempTimeAmin"] then
					eu.chaUI["tempTimeAmin"]:del()
				end
				eu.chaUI["tempTimeAmin"] = hUI.image:new({
					parent = eu.handle._n,
					x = offsetX + dx + 15 - 32,
					y = offsetY + eu_bh + 3 + 12, --英雄略大
					model = "UI:next_day",
					w = 26,
					h = 26,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 4))
				local act2 = CCMoveBy:create(0.2, ccp(0, -4))
				local act12 = CCSequence:createWithTwoActions(act1, act2)
				local act3 = CCRotateBy:create(0.4, 180)
				local act123 = CCSpawn:createWithTwoActions(act12, act3)
				local act4 = CCDelayTime:create(1.0)
				local a = CCArray:create()
				a:addObject(act123)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				eu.chaUI["tempTimeAmin"].handle.s:runAction(CCRepeatForever:create(sequence))
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 给之前全部召唤的单位加上隐身（只有同一阵营才会看到）
__aCodeList["SummonUnit_AddYinShen"] = function(self, _)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local tList = d.tempValue["SummonUnitList"]
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	
	if tList then
		local owner = u:getowner()
		local forceMe = w:GetPlayerMe():getforce() --我的的势力
		
		for i = 1, #tList, 1 do
			local eu = tList[i]
			local force = eu:getowner():getforce() --施法者的势力
			
			--我和该召唤单位在同一阵营
			if (forceMe == force) then
			else
				--设置隐身的透明度
				eu.handle.s:setOpacity(0)
				eu.handle._n:setVisible(false)
				
				--设置单位特效
				for i = 1, #eu.data.effectsOnCreate, 1 do
					eu.data.effectsOnCreate[i].handle._n:setVisible(false)
				end
				
				--隐身的单位不显示血条和数字显血文字
				if eu.chaUI["hpBar"] then
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				if eu.chaUI["numberBar"] then
					eu.chaUI["numberBar"].handle._n:setVisible(false)
				end
				
				--隐藏倒计时条
				if (eu.chaUI["liveTime"] == 0) then
					--
				elseif eu.chaUI["liveTime"] then
					eu.chaUI["liveTime"].handle._n:setVisible(false)
				else
					eu.chaUI["liveTime"] = 0
				end
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 给之前全部召唤的单位设置生命值比例（去掉百分号后的值）
__aCodeList["SummonUnit_SetHpRate"] = function(self, _, hpRate)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local tList = d.tempValue["SummonUnitList"]
	
	if (type(hpRate) == "string") then
		hpRate = self.data.tempValue[hpRate] --读temp表里的值
	end
	
	if tList then
		for i = 1, #tList, 1 do
			local eu = tList[i]
			
			--刷新单位的血条
			eu.attr.hp = math.floor(eu:GetHpMax() * hpRate / 100)
			
			--更新血条控件
			if eu.chaUI["hpBar"] then
				eu.chaUI["hpBar"]:setV(eu.attr.hp, eu:GetHpMax())
			end
			if eu.chaUI["numberBar"] then
				eu.chaUI["numberBar"]:setText(eu.attr.hp .. "/" .. eu:GetHpMax())
			end
		end
	end
	
	return self:doNextAction()
end

--geyachao: 给之前全部召唤的单位释放技能
__aCodeList["SummonUnit_CastSkill"] = function(self, _, skillId, skillLv)
	local d = self.data
	local u = d.unit
	local w = u:getworld()
	local tList = d.tempValue["SummonUnitList"]
	
	if (type(skillId) == "string") then
		skillId = self.data.tempValue[skillId] --读temp表里的值
	end
	
	if (type(skillLv) == "string") then
		skillLv = self.data.tempValue[skillLv] --读temp表里的值
	end
	
	if tList then
		for i = 1, #tList, 1 do
			local eu = tList[i]
			
			local selfX, selfY = hApi.chaGetPos(eu.handle) --当前坐标
			local gridX, gridY = w:xy2grid(selfX, selfY)
			--释放技能
			local tCastParam =
			{
				level = skillLv, --技能等级
			}
			--print("给之前全部召唤的单位释放技能", eu.data.name, skillId)
			hApi.CastSkill(eu, skillId, 0, 100, eu, gridX, gridY, tCastParam)
		end
	end
	
	return self:doNextAction()
end

--geyachao: 新加 移除施法者
__aCodeList["RemoveUnit_TD"] = function(self, _, unitType)
	local w = self.data.world
	local oUnit = self.data.unit --角色
	local worldC = self.data.unit_worldC
	
	if (unitType == "target") then
		oUnit = self.data.target --目标
		worldC = self.data.target_worldC
	end
	
	--角色活着
	if oUnit and (oUnit ~= 0) and (oUnit.ID ~= 0) and (oUnit.data.IsDead ~= 1) and (worldC == oUnit:getworldC()) and (oUnit.attr.hp > 0) then
		--获得单位所属波次(目前只有发兵需要检测)
		local wave = oUnit:getWaveBelong()
		--设置波次角色被消灭或漏怪
		hApi.SetUnitInWaveKilled(wave)
		
		--清除世界检测
		local cha_worldC = oUnit:getworldC()
		w.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
		
		--删除角色
		oUnit.attr.hp = 0
		oUnit.data.IsDead = 1
		oUnit:del()
	end
	
	return self:doNextAction()
end

--geyachao: 新加 pvp发送表情包
__aCodeList["ShowEmoji_TD"] = function(self, _, emoji_index)
	local w = self.data.world
	local oUnit = self.data.unit --角色
	
	local forceMe = oUnit:getowner():getforce() --施法者的势力
	
	--发表情
	hApi.ShowEmoji(forceMe, emoji_index)
	
	return self:doNextAction()
end

--geyachao: 新加 获得单位的阵营
__aCodeList["GetUnitForce_TD"] = function(self, _, targetType, param)
	local w = self.data.world
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (targetType == "unit") then
		unit = u
	elseif (targetType == "target") then
		unit = t
	end
	
	local force = 0
	
	if unit then
		force = unit:getowner():getforce()
	end
	
	d.tempValue[param] = force
	
	return self:doNextAction()
end

__aCodeList["SummonDuration"] = function(self,_,nRound)
	local d = self.data
	if #d.summons>0 then
		local n = __AnalyzeValueExpr(self,d.unit,nRound,"number")
		for i = 1,#d.summons do
			local su = hApi.GetObjectEx(hClass.unit,d.summons[i])
			if su then
				su.attr.duration = n
			end
		end
	end
	return self:doNextAction()
end

--清理掉自身和召唤生物的关系
__aCodeList["SummonRelease"] = function(self,_)
	self.data.summons = {}
	return self:doNextAction()
end

local __InsertXYToGrid = function(w,x,y,g)
	if w:IsSafeGrid(x,y) then
		g.n = g.n + 1
		local p = g[g.n] or {}
		g[g.n] = p
		p.x = x
		p.y = y
	end
end

hApi.GetWallGrid = function(oWorld,oUnit,gridX,gridY,rGrid)
	if rGrid==nil then
		rGrid = {n=0}
	end
	local mode = 0
	if oUnit.data.gridX==gridX then
		if oUnit.data.facing>=90 and oUnit.data.facing<270 then
			mode = 1
		end
	elseif oUnit.data.gridX>gridX then
		mode = 1
	end
	--Ax6o专用
	if mode==0 then
		if gridX==oWorld.data.block.w-1 then
			gridX = gridX - 1
		end
		__InsertXYToGrid(oWorld,gridX,gridY,rGrid)
		for i = 1,99 do
			local sus = 0
			local x1,y1 = gridX,gridY+i
			local x2,y2 = gridX,gridY-i
			if oWorld:IsSafeGrid(x1,y1) then
				sus = 1
				__InsertXYToGrid(oWorld,x1,y1,rGrid)
			end
			if oWorld:IsSafeGrid(x2,y2) then
				sus = 1
				__InsertXYToGrid(oWorld,x2,y2,rGrid)
			end
			if sus==0 then
				break
			end
		end
	else
		if gridX==0 and math.mod(gridY,2)==0 then
			gridX = gridX + 1
		end
		local eq,ev = 1,-1
		if math.mod(gridY,2)==1 then
			eq = 0
			ev = 1
		end
		__InsertXYToGrid(oWorld,gridX,gridY,rGrid)
		for i = 1,99 do
			local sus = 0
			local x1,y1 = gridX,gridY+i
			local x2,y2 = gridX,gridY-i
			if math.mod(y1,2)==eq then
				x1 = x1 + ev
			end
			if math.mod(y2,2)==eq then
				x2 = x2 + ev
			end
			if oWorld:IsSafeGrid(x1,y1) then
				sus = 1
				__InsertXYToGrid(oWorld,x1,y1,rGrid)
			end
			if oWorld:IsSafeGrid(x2,y2) then
				sus = 1
				__InsertXYToGrid(oWorld,x2,y2,rGrid)
			end
			if sus==0 then
				break
			end
		end
	end
	return rGrid
end

do
	local __ENUM__GetRandomSkillWithCount = function(sData,tTempId)
		local id = sData[1]
		local nCurNum = math.max(0,sData[4])
		local tabS = hVar.tab_skill[id]
		if id~=tTempId.id and tabS and sData[4]~=0 then
			if tTempId.num>0 then
				--初始数量小于0的技能如果不存在，则不能补充
				if (tabS.count or 0)<=0 and nCurNum<=0 then
					return
				end
				local maxNum = tabS.maxcount or tabS.count or 999
				if nCurNum<maxNum then
					tTempId[#tTempId+1] = id
				end
			elseif tTempId.num<0 then
				if nCurNum>0 then
					tTempId[#tTempId+1] = id
				end
			end
		end
	end
	
	__aCodeList["AddSkillCount"] = function(self,_,id,num,maxNum)
		local d = self.data
		local u = d.unit
		if u~=0 and u.ID~=0 and u.data.IsDead~=1 then
			local num = __AnalyzeValueExpr(self,u,num,"number")
			if num~=0 then
				if id=="random" then
					local tTempId = {num=num,id=d.skillId}
					u:enumskill(__ENUM__GetRandomSkillWithCount,tTempId)
					if #tTempId>0 then
						id = tTempId[d.world:random(1,#tTempId)]
					end
				end
				local s = u:getskill(id)
				if s and s[4]~=0 then
					local nCurNum = math.max(s[4],0)
					if num>0 then
						local tabS = hVar.tab_skill[id]
						if type(maxNum)~="number" then
							maxNum = tabS.maxcount or tabS.count or 999
						end
						if nCurNum<maxNum then
							s[4] = math.min(maxNum,nCurNum + num)
						else
							--已经超过最大上限了就什么都不做
						end
					elseif num<0 then
						s[4] = nCurNum + num
						if s[4]<=0 then
							s[4] = -1
						end
					end
				end
			end
		end
		return self:doNextAction()
	end
end

__aCodeList["AddSkillCountT"] = function(self,_,id,num)
	local d = self.data
	local u = d.target
	if u~=0 and u.ID~=0 and u.data.IsDead~=1 then
		local s = u:getskill(id)
		if s and s[4]~=0 then
			local num = __AnalyzeValueExpr(self,u,num,"number")
			if num~=0 then
				s[4] = math.max(s[4],0) + num
				if s[4]==0 then
					s[4] = -1
				end
			end
		end
	end
	return self:doNextAction()
end

__aCodeList["IceWall"] = function(self,_,nUnitHp,effectId)
	local d = self.data
	local w = d.world
	local u = d.unit
	local nHp = __AnalyzeValueExpr(self,u,nUnitHp,"number")
	if w.ID~=0 then
		nHp = math.max(nHp,1)
		if d.group==0 then
			d.group = hApi.GetWallGrid(w,u,d.gridX,d.gridY,{block=0,n=0})
			local g = d.group
			for i = 1,#g do
				local oUnit = w:addunit(16,0,g[i].x,g[i].y,nil,nil,nil,{hp=nHp,block=hVar.UNIT_BLOCK_MODE.NORMAL,EvadeArea=1},{model="MODEL_EFFECT:ice_shell201",animation = "stand_"..w:random(1,8,"iceWall")})
				self:addControlUnit(oUnit)
			end
		end
		if d.group~=0 and type(effectId)=="number" then
			local g = d.group
			for i = 1,#g do
				local x,y = w:grid2xy(g[i].x,g[i].y)
				w:addeffect(effectId,1,nil,x,y)
			end
		end
	end
	return self:doNextAction()
end

--单位承受来自其他类型的单位伤害发生改变
__aCodeList["SetDamageFrom"] = function(self,_,mode,tType,param,dur)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if t and t~=0 and t.ID~=0 then
		local v = __AnalyzeValueExpr(self,d.unit,param,"number")
		if v~=0 then
			local nDur = __AnalyzeValueExpr(self,d.unit,dur,"number")
			if nDur>0 then
				nDur = nDur + d.world.data.roundcount - 1
			else
				nDur = 0
			end
			t:setpowerex("from",tType,v,nDur)
		end
	end
	return self:doNextAction()
end

--单位对其他类型的单位造成伤害发生改变
__aCodeList["SetDamageTo"] = function(self,_,mode,tType,param,dur)
	local d = self.data
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if t and t~=0 and t.ID~=0 then
		local v = __AnalyzeValueExpr(self,d.unit,param,"number")
		if v~=0 then
			local nDur = __AnalyzeValueExpr(self,d.unit,dur,"number")
			if nDur>0 then
				nDur = nDur + d.world.data.roundcount
			else
				nDur = 0
			end
			local tData = hApi.ReadParamWithDepth(tType,nil,{},3)
			t:setpowerex("to",tData,v,nDur)
		end
	end
	return self:doNextAction()
end

--战斗结束后，如果目标未全灭，那么减少目标单位承受的损失
__aCodeList["SaveTarget"] = function(self,_,mode,param)
	local d = self.data
	local w = d.world
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if w~=0 and w.ID~=0 and t and t~=0 and t.ID~=0 and t.data.indexOfTeam~=0 then
		local v = hApi.floor(__AnalyzeValueExpr(self,d.unit,param,"number")*t.attr.__stack/100)
		if v>0 then
			w:log({
				key = "unit_save",
				save = v,
				target = {
					objectID = t.ID,
					id = t.data.id,
					name = t.handle.name,
					indexOfTeam = t.data.indexOfTeam,
					owner = t.data.owner,
				},
			})
		end
	end
	return self:doNextAction()
end

--替换技能
__aCodeList["SetReplaceID"] = function(self,_,mode,sMatchKey,sReplaceKey,nReplaceID,tRplaceOrder)
	local d = self.data
	local w = d.world
	local t
	if mode=="unit" then
		t = d.unit
	else--if mode=="target" then
		t = d.target
	end
	if w~=0 and w.ID~=0 and t and t~=0 and t.ID~=0 then
		--{sMatchKey,sReplaceKey,nReplaceID,tRplaceOrder}
		local tReplaceID = t.attr.replaceID
		if sReplaceKey and nReplaceID and nReplaceID~=0 and hVar.tab_skill[nReplaceID] then
			hApi.SortTableI(tReplaceID,1)
			tReplaceID[#tReplaceID+1] = {sMatchKey,sReplaceKey,nReplaceID,tRplaceOrder or 0}
		else
			for i = 1,#tReplaceID do
				if tReplaceID[i]~=0 and sMatchKey==tReplaceID[i][1] then
					tReplaceID[i] = 0
				end
			end
			hApi.SortTableI(tReplaceID,1)
		end
	end
	return self:doNextAction()
end

--geyachao: 新加有几率替换普通攻击ID
__aCodeList["SetReplaceNormalAtkID"] = function(self, _, unitType, skill_id, probability)
	--print("SetReplaceNormalAtkID", unitType, skill_id, probability)
	local d = self.data
	local u = d.unit
	local t = d.target
	
	local unit = u --要读取的目标
	if (unitType == "unit") then
		unit = u
	elseif (unitType == "target") then
		unit = t
	end
	
	local replaceNormalAtkID = unit.attr.replaceNormalAtkID --几率替换普通攻击的列表
	
	--检测是否为重复的技能id
	local bHaveSame = false -- 是否是已存在的技能id
	for i = 1, #replaceNormalAtkID, 1 do
		local content = replaceNormalAtkID[i]
		local skillIdi = content.skill_id
		local probabilityi = content.probability
		
		--如果重复，只修改几率
		if (skill_id == skillIdi) then
			content.probability = probability
			bHaveSame = true
			break
		end
	end
	
	--如果是不存在的技能id，新插入
	if (not bHaveSame) then
		table.insert(replaceNormalAtkID, {skill_id = skill_id, probability = probability})
	end
	
	--继续下一个动作
	return self:doNextAction()
end


local __CODE__CheckTargetForCast = function(oWorld,oUnit,id,tTargetData)
	local tabS = hVar.tab_skill[id]
	if tabS==nil then
	elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
		--必然可以释放
		local tCast = {id,{}}
		return tCast
	elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT or tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
		local tCast = {id,{}}
		local rMin,rMax = -1,-1
		if tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT and tabS.range then
			rMin,rMax = unpack(tabS.range)
		end
		for i = 1,#tTargetData do
			local v = tTargetData[i]
			local oTarget = v[1]
			local r = v[2]
			if (rMax==-1 or (r>=rMin and r<=rMax)) then
				if hApi.IsSafeTarget(oUnit,id,oTarget)==hVar.RESULT_SUCESS then
					tCast[2][#tCast[2]+1] = oTarget
				end
			end
		end
		if #tCast[2]>0 then
			return tCast
		end
	end
end

----疯魔
--__aCodeList["MadnessCast"] = function(self,_)
--	local d = self.data
--	local w = d.world
--	local u = d.unit
--	if w~=0 and w.ID~=0 and type(w.__LOG)=="table" and u.data.IsDead==0 and hVar.tab_skill[d.skillId]~=nil then
--		local nManaLimit = hVar.tab_skill[d.skillId].manalimit or 9999
--		local tCast = {}
--		local tIdx = {[d.skillId]=1}	--不能施展自己
--		local tTargetData = {}
--		w:enumunit(function(t)
--			if t and t.data.IsDead~=1 then
--				local r = w:distanceU(u,t,1)
--				tTargetData[#tTargetData+1] = {t,r}
--			end
--		end)
--		local tLog = w.__LOG
--		for i = 1,#tLog do
--			local v = tLog[i]
--			if v.key=="cast_skill" and v.IsCast==1 and v.CastOrder==hVar.ORDER_TYPE.NORMAL and v.unit.objectID==u.ID then
--				local tabS = hVar.tab_skill[v.id]
--				if tIdx[v.id]==1 then
--					--已经记录过此技能
--				elseif tabS.unique==1 then
--					--唯一技能不受疯魔影响
--				elseif (tabS._manacost or tabS.manacost or 0)>nManaLimit then
--					--超过法力限制的技能不受影响
--				else
--					tIdx[v.id] = 1
--					tCast[#tCast+1] = __CODE__CheckTargetForCast(w,u,v.id,tTargetData)
--				end
--			end
--		end
--		local oRound = w:getround()
--		if oRound and #tCast>0 then
--			local tData = tCast[w:random(1,#tCast)]
--			local id = tData[1]
--			local nOrderType = hVar.ORDER_TYPE.COPY_CAST
--			local nDelay = 1
--			local tabS = hVar.tab_skill[id]
--			if tabS==nil then
--			elseif tabS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
--				local gridX,gridY = u.data.gridX,u.data.gridY
--				oRound:autoorder(nDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,id,gridX,gridY)
--			elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_GRID then
--				local t = tData[2][w:random(1,#tData[2])]
--				local gridX,gridY = hApi.GetGridByUnitAndXY(t,"near",u.data.gridX,u.data.gridY)
--				oRound:autoorder(nDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_GRID,id,gridX,gridY)
--			elseif tabS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
--				local t = tData[2][w:random(1,#tData[2])]
--				oRound:autoorder(nDelay,u,nOrderType,hVar.OPERATE_TYPE.SKILL_TO_UNIT,t,id)
--			end
--		end
--	end
--	return self:doNextAction()
--end