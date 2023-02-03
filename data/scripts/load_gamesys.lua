hSaveData = {}			--游戏同步使用的存储表(存档)
hClass = {}			--存放游戏类的域
hGlobal = {}			--游戏变量使用的域
hResource = {}			--存放游戏资源指针，模型
hDefine = {}			--常量定义
hVar = {}			--数据表
hUI = {}			--存放UI类
hGlobal.UI = {}			--游戏中的UI对象存放在这里
hGlobal.WORLD_SCENE = {}	--游戏中的世界Scene存放在这里,{world,town,battlefield}
hGlobal.WORLD_LAYER = {}	--游戏中的世界Layer存放在这里,{world,town,battlefield}
hGlobal.Heros = {}		--(已废弃)游戏中的英雄都存放在这里
hGlobal.LocalHeroSlot = {}	--(已废弃)本地英雄存放在这里
hGlobal.CastAI = {}		--释放技能的AI
hGlobal.LastFocusSwitch = 0	--0:未聚焦到任何,1:聚焦到world,2:聚焦到map
hGlobal.LastFocusMap = {}	--记录最后聚焦的map(无逻辑处理的世界)
hGlobal.LastFocusWorld = {}	--记录最后聚焦的world(带逻辑的世界,会被存盘)
hGlobal.InitLocalVar = function()
	hGlobal.WORLD = {}		--游戏世界存放在这里
	hGlobal.LOCAL_CHA = {}		--不加入unit管理系统的cha都在这里放着
	hGlobal.LOCAL_DEAD_ILLUSION = {}--如果本地玩家在战场中时，大地图上的单位被杀死，则创造一个本地死亡镜像，以供UI显示{id = unitId,s = sprite,tgrData = triggerData,__manager = "lua"}
end
hGlobal.InitLocalVar()
hHandler = {}			--服务器脚本系统协议接收相关（程序3003号协议） by zhenkira 2016.04.11

if nil == math.mod then
math.mod = math.fmod
end
if nil == string.gfind then
string.gfind = string.gmatch
end
if nil == math.atan2 then
math.atan2 = math.atan
end

-----------------------------------------
--这是。。。防止重载重新创建莫名其妙的Layer
if type(g__LastCreatedLayer)~="table" then
	g__LastCreatedLayer = {}
end
hUI.InitLayer = function(LayerName,initFunc)
	local pLayer
	if type(g__LastCreatedLayer)=="table" then
		pLayer = g__LastCreatedLayer[LayerName]
	else
		g__LastCreatedLayer = {}
	end
	if pLayer==nil then
		local v = CCLayer:create()
		v:retain()
		g__LastCreatedLayer[LayerName] = v
		if type(initFunc)=="function" then
			initFunc(v)
		end
		return v
	else
		if pLayer:getParent()~=nil then
			pLayer:getParent():removeChild(pLayer,false)
		end
		return pLayer
	end
end
------------------
-- debug函数
local __LG = xlLG or function()end
G_Lua_Error_Msg = 0			--用来记录 lua 脚本是否有弹过框的 全局变量 如果有出错过 则标记为1
hGlobal.__TRACKBACK__ = function(msg)
	if G_Lua_Error_Msg == 1 then return end
	print("----------------------------------------")
	print("LUA ERROR: " .. tostring(msg) .. "\n")
	__LG("lua_error",tostring(msg))
	local text = debug.traceback()
	--local s,e = string.find(text,"/load_gamesys.lua:14>")
	--if e then
		--print("--[LUA STACK]---------------------------")
		--text = tostring(string.sub(text,e+2))
		--print(text)
		--print("----------------------------------------")
	--else
		--print(text)
		--print("----------------------------------------")
	--end
	print(text)
	print("----------------------------------------")
	__LG("log_err",tostring(text))
	G_Lua_Error_Msg = 1
	return hGlobal.event:event("LocalEvent_ErroFram","LUA ERROR: " .. tostring(msg) .. "\n")
end

function xlError_CFunc(msg)
	return hGlobal.__TRACKBACK__(msg)
end

--最大支持20个参数
local __ret1,__ret2,__ret3,__ret4,__ret5
local __code,__p1,__p2,__p3,__p4,__p5,__p6,__p7,__p8,__p9,__p10,__p11,__p12,__p13,__p14,__p15,__p16,__p17,__p18,__p19,__p20
local __EVENT_CALL_P20 = function()
	return __code(__p1,__p2,__p3,__p4,__p5,__p6,__p7,__p8,__p9,__p10,__p11,__p12,__p13,__p14,__p15,__p16,__p17,__p18,__p19,__p20)
end
local __EVENT_CALL_P20_R5 = function()
	__ret1,__ret2,__ret3,__ret4,__ret5 = __code(__p1,__p2,__p3,__p4,__p5,__p6,__p7,__p8,__p9,__p10,__p11,__p12,__p13,__p14,__p15,__p16,__p17,__p18,__p19,__p20)
	return __ret1,__ret2,__ret3,__ret4,__ret5
end
hpcall = function(code,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
	__code,__p1,__p2,__p3,__p4,__p5,__p6,__p7,__p8,__p9,__p10,__p11,__p12,__p13,__p14,__p15,__p16,__p17,__p18,__p19,__p20 = code,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20
	return xpcall(__EVENT_CALL_P20,hGlobal.__TRACKBACK__)
end
rpcall = function(code,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
	__ret1,__ret2,__ret3,__ret4,__ret5 = nil,nil,nil,nil,nil
	__code,__p1,__p2,__p3,__p4,__p5,__p6,__p7,__p8,__p9,__p10,__p11,__p12,__p13,__p14,__p15,__p16,__p17,__p18,__p19,__p20 = code,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20
	xpcall(__EVENT_CALL_P20_R5,hGlobal.__TRACKBACK__)
	return __ret1,__ret2,__ret3,__ret4,__ret5
end
local __EVENT_Table = {}
local __EVENT_ListenerTable = {}
local __EVENT_NEED_SORT = {}
local __EVENT_QUICK_INDEX = {}
--游戏的事件
hGlobal.event = {
	rcall = function(self,name,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
		if __EVENT_Table[name]~=nil then
			local sus,r1,r2,r3,r4,r5 = pcall(__EVENT_Table[name],p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
			if sus then
				return r1,r2,r3,r4,r5
			else
				return hGlobal.__TRACKBACK__(r1)
			end
		end
	end,
	call = function(self,name,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
		if __EVENT_Table[name]~=nil then
			return hpcall(__EVENT_Table[name],p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
		end
	end,
	event = function(self,name,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
		--event请不要超过20个参数
		--print("event:",name)
		local eL_List = __EVENT_ListenerTable[name]
		if eL_List~=nil then
			eL_List.lock = 1
			for i = 1,eL_List.n,1 do
				if eL_List[i]~=0 then
					--hpcall(eL_List[i][1],...)
					hpcall(eL_List[i][1],p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
				end
			end
			eL_List.lock = 0
		end
	end,
	listen = function(self,name,listenerName,code)
		__EVENT_ListenerTable[name] = __EVENT_ListenerTable[name] or {n=0,lock=0}
		__EVENT_QUICK_INDEX[name] = __EVENT_QUICK_INDEX[name] or {}
		local eL_List = __EVENT_ListenerTable[name]	--{code,name}
		local el_Index = __EVENT_QUICK_INDEX[name]
		local iLast,fIndex
		local isCode = type(code)=="function"
		if __EVENT_NEED_SORT[name]==1 and eL_List.lock~=1 then
			for i = 1,eL_List.n do
				if eL_List[i]==0 then
					iLast = iLast or i
				else
					local k = i
					if iLast~=nil then
						k = iLast
						iLast = iLast + 1
						eL_List[k] = eL_List[i]
						eL_List[i] = 0
						el_Index[eL_List[k][2]] = k
					end
					if fIndex==nil and eL_List[k][2]==listenerName then
						fIndex = k
					end
				end
			end
			__EVENT_NEED_SORT[name] = 0
		end
		if el_Index[listenerName]~=nil and el_Index[listenerName]~=0 then
			fIndex = el_Index[listenerName]
		end
		if iLast~=nil then
			eL_List.n = iLast - 1
		end
		if isCode then
			--print("eventListenAppend:",name)
			if fIndex~=nil then
				eL_List[fIndex][1] = code
			else
				eL_List.n = eL_List.n + 1
				eL_List[eL_List.n] = {code,listenerName}
				el_Index[listenerName] = eL_List.n
			end
		else
			--print("eventListenCancel:",name,fIndex)
			if fIndex~=nil then
				eL_List[fIndex] = 0
				el_Index[listenerName] = 0
				__EVENT_NEED_SORT[name] = 1
			end
		end
	end,
	getfunc = function(self,name,listenerName)
		if __EVENT_ListenerTable[name] and __EVENT_QUICK_INDEX[name] then
			local nIndex = __EVENT_QUICK_INDEX[name][listenerName]
			if nIndex and nIndex~=0 and type(__EVENT_ListenerTable[name][nIndex])=="table" then
				return __EVENT_ListenerTable[name][nIndex][1]
			end
		end
	end,
}
setmetatable(hGlobal.event,{
	__index = function(t,k)
		return __EVENT_Table[k]
	end,
	__newindex = function(t,k,v)
		__EVENT_Table[k] = v
	end,
})
setmetatable(hClass,{
	__newindex = function(t,k,v)
		if type(v)=="table" then
			rawset(v,"classname",k)
			rawset(t,k,v)
		else
			print("将非法类["..tostring(k).."]:"..tostring(v).."加入hClass!")
		end
	end
})
--游戏中的UI类
setmetatable(hUI,{
	__newindex = function(t,k,v)
		--是eClass
		if type(v)=="table" and type(rawget(v,"init"))=="function" and type(rawget(v,"destroy"))=="function" and type(rawget(v,"meta"))=="table" then
			rawset(v,"classname",k)
		end
		return rawset(t,k,v)
	end,
})
--=============================================================
-- hApi
--=============================================================
hApi = {}
hApi.DoNothing = function()end	--什么也不做的借口
hGlobal.__Path = "data/"	--windows开发用这个
--hGlobal.__Path = "image/"	--苹果设备用这个
hApi.GetFilePath = function(f)
	return (hGlobal.__Path or "")..f
end

hApi.GetImagePath = function(f)
	return (hGlobal.__Path or "").."image/"..f
end

hApi.GetMapPath = function(f)
	return (hGlobal.__Path or "").."map/"..f
end

--加载lua文件，以scripts为基础目录
hApi.LoadLua = function(f)
	return xlDoFile(hApi.GetFilePath(f..".lua"))
end

local function __LoadMapScript(map)
	xlDoFile(hApi.GetMapPath(map..".lua"))
end

local function __LoadMapDat(map)
	
	--大于程序版本3的程序 读取加密地图 否则 只Dofile
	if g_vs_number > 3 then
		--只能读取加密的地图
		xlLoadGameData(hApi.GetMapPath(map..".dat"))
	else
		xlDoFile(hApi.GetMapPath(map..".dat"))
	end
	
	
end

local isNumberInTable = function(n,t)
	local h = 0
	for i = 1,#t do
		if n == t[i] then
			h = i
			break
		end
	end
	return h
end
--加载地图文件，以map为基础目录
hApi.LoadMap = function(map,template)
	hGlobal.LastLoadedMap = nil
	map_background = nil
	units_list = nil
	units_data = nil
	map = tostring(map)
	--如果有现成的地图模板
	if hVar.MAPS[map]~=nil then
		_DEBUG_MSG("	- [dat]存在模板地图，读取 -> ["..map.."] 成功")
		return hVar.MAPS[map].background,hVar.MAPS[map].unitlist,hVar.MAPS[map].triggerdata
	end
	__LoadMapDat(map)
	local mapBackground = map_background
	local unitsList = units_list

	--从地图data中读取玩家阵营信息

	if unitsList~=nil or mapBackground~=nil then
		_DEBUG_MSG("	- [dat]读取单位 -> ["..map.."] 成功")
		local unitsData = units_data
		--print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^g_WDLD_RB, hApi.Is_WDLD_Map(mapBackground):",g_WDLD_RB, hApi.Is_WDLD_Map(mapBackground))
		--if g_WDLD_RB == 1 and hApi.Is_WDLD_Map(mapBackground) ~= -1 then
		--	local res_b = {}
		--	local res_b_rok = {}
		--	local town_b = {}
		--	local h_c = {}
		--	for i = 1,#unitsList do
		--		if unitsList[i] and unitsList[i][2] then
		--			for j = 1,#hVar.WDLD_RResB do
		--				if unitsList[i][2] == hVar.WDLD_RResB[j] then
		--					res_b[#res_b + 1] = {0,0}
		--					res_b_rok[#res_b_rok + 1] = {0,0}
		--					res_b[#res_b][1] = i
		--					res_b[#res_b][2] = unitsList[i][2]
		--					h_c[#h_c + 1] = 0
		--				end
		--			end
		--
		--			--for j = 1,#hVar.WDLD_RTownB do
		--				--if unitsList[i][2] == hVar.WDLD_RTownB[j] then
		--					--town_b[#town_b + 1] = {0,0}
		--					--town_b[#town_b][1] = i
		--					--town_b[#town_b][2] = unitsList[i][2]
		--				--end
		--			--end
		--		end
		--	end
		--
		--	--for i = 1,#town_b do
		--		--town_b[i][2] = hVar.WDLD_RTownB[hApi.random(1,#hVar.WDLD_RTownB)]
		--		--unitsList[town_b[i][1]][2] = town_b[i][2]
		--	--end
		--	for i = 1,#h_c do
		--		local nindex = hApi.random(1,#h_c)
		--		while isNumberInTable(nindex,h_c) ~= 0 do
		--			nindex = hApi.random(1,#h_c)
		--		end
		--		h_c[i] = nindex
		--	end
		--	for i = 1,#res_b_rok do
		--		res_b_rok[i][1] = res_b[i][1]
		--		res_b_rok[i][2] = res_b[h_c[i]][2]
		--		unitsList[res_b_rok[i][1]][2] = res_b_rok[i][2]
		--	end
		--end
		g_WDLD_RB = 0
		return mapBackground,unitsList,unitsData
	elseif template~=nil and template~=0 then
		_DEBUG_MSG("	- 读取单位 -> ["..map.."] 失败，读取模板 -> ["..template.."]")
		return hApi.LoadMap(tostring(template),0)
	else
		_DEBUG_MSG("	- 读取单位 -> ["..map.."] 失败，无可用模板")
		--_DEBUG_MSG("	- 读取单位->["..template.."]依然失败 (╯°口°)╯...")
	end
end

xlIsFileExist = xlIsFileExist or function() return 1 end
--测试用工具函数
hApi.FileExists = function(filePath,mode)
	--默认所有文件存在，等程序开接口
	if mode == nil then
		return xlIsFileExist(filePath)==1
	else
		return xlIsFullPathFileExist(filePath) == 1
	end
end

hGlobal.mapData = {}		--地图信息（程序回调用）
hApi.LoadMapData = function(key,d)
	local md = hGlobal.mapData
	if md[key] and md[key].gridW and md[key].gridH and md[key].w and md[key].h and md[key].borderW and md[key].borderH then
		d.gridW = md[key].gridW
		d.gridH = md[key].gridH
		d.w = md[key].w
		d.h = md[key].h
		d.borderW = md[key].borderW
		d.borderH = md[key].borderH
	end
end

------------------
-- 所有待加载的脚本:加载函数
hApi.LoadScripts = function(dPath,scriptTab)
	_DEBUG_MSG("\n")
	local error_msg = {}
	for i = 1,#scriptTab do
		local t = scriptTab[i]
		local path,code
		if type(t)=="function" then
			t()
		else
			local path = tostring(t)
			hApi.LoadLua(dPath..path)
			_DEBUG_MSG("加载脚本:    "..dPath..path..".lua")
		end
	end
	if #error_msg>0 then
		_DEBUG_MSG("\n\nerrors:")
		for i = 1,#error_msg do
			_DEBUG_MSG(error_msg[i])
		end
		_DEBUG_MSG("\n")
	end
end

--调试用打印函数，必须有
_DEBUG_MSG = function(...) if hGlobal.DEBUG~=0 then print(...)end end
if LANGUAG_SITTING == nil then
	LANGUAG_SITTING = 1				--语言设置 1按照默认 2简体(强制) 3繁体(强制) 4英语(强制)
end
if VIP_AND_FIRSTTOP_COIN_OR_MONEY == nil then
	VIP_AND_FIRSTTOP_COIN_OR_MONEY = 0		--vip和首冲以游戏币还是钱来统计	0钱(人民币) 1 游戏币
end

if language_config == nil then
	language_config = {}
	--geyachao: 暂时去掉繁体选择
	--[[
	language_config[1] = {"默认", "DEFAULT", "default", "coh_2018"}
	language_config[2] = {"简体中文", "SC", "chjt", "coh_2018"}
	language_config[3] = {"繁体中文", "TC","chft", "Arial"}
	language_config[4] = {"英语", "EN", "en", "Arial"}
	]]
	--geyachao: 暂时去掉繁体选择，改为下面的都是中文
	language_config[1] = {"默认", "DEFAULT", "default", "coh_2018"}
	language_config[2] = {"简体中文", "DEFAULT", "default", "coh_2018"}
	language_config[3] = {"繁体中文", "DEFAULT", "default", "coh_2018"}
	language_config[4] = {"英语", "EN", "en", "coh_2018"}
	language_config[5] = {"日语", "JP", "jp", "coh_2018"}
end

--g_language_setting = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_language")
--if g_language_setting == 0 then
	--local sys_lang = CCApplication:sharedApplication():getCurrentLanguage()
	--if sys_lang ~= 8 then
		--g_language_setting = 2
	--else
		--g_language_setting = 3
	--end
--end
if g_lua_src == 1 then
	g_language_setting = 1
end
if LANGUAG_SITTING == 1 then
	--xlDoFile("data/"..language_config[g_language_setting][3]..".lan")
	if g_language_setting == nil then
		g_language_setting = 1
	end
	g_langauge_ver = language_config[g_language_setting][3]
	
	if g_language_setting == 1 or g_language_setting == 2 then
		g_Cur_Language = 1
	elseif g_language_setting == 3 then
		g_Cur_Language = 2
	elseif g_language_setting == 4 then
		g_Cur_Language = 3
	elseif g_language_setting == 5 then
		g_Cur_Language = 4
	end
else
	--xlDoFile("data/"..language_config[LANGUAG_SITTING][3]..".lan")
	g_langauge_ver = language_config[LANGUAG_SITTING][3]
	if LANGUAG_SITTING == 2 then
		g_Cur_Language = 1
	elseif LANGUAG_SITTING == 3 then
		g_Cur_Language = 2
	elseif LANGUAG_SITTING == 4 then
		g_Cur_Language = 3
	elseif LANGUAG_SITTING == 5 then
		g_Cur_Language = 4
		--hVar.FONTC = "Arial"
	end
end

g_CurScreenMode = 1
g_CurViewMode = 1

g_Background_vertical = {
	[1] = "other/logintv",
	[2] = "other/logintv2",
	[3] = "other/logintv3",
}

--如果是.o的打包读取模式，在这里直接返回不加载下面的脚本
if __xlLoadMode=="O" then
	__xlEditorMode = 0
	return
else

end
if __xlEditorMode==1 then
	--编辑器模式(__xlEditorMode==1)
	_DEBUG_MSG("以编辑器模式加载纯数据文件")
	xlDoFile = dofile
	--=============================================================
	hApi.LoadLua("scripts/zdefine")			--加载界面Z值定义
	hApi.LoadLua("scripts/var")			--加载枚举定义
	--=============================================================
	--=============================================================
	-- 所有待加载的脚本
	--=============================================================
	hDefine.LocalString = {
	}
	-- 表资源
	hDefine.Tabs = {
		--加载文本
		--"tab_string",					--文本表(UTF-8)格式
		--加载资源
		"model/tab_model",				--基本模型表
		"model/tab_model_unit",				--单位模型表
		"model/tab_model_effect",			--特效模型表
		"model/tab_model_sceobj",			--场景物件模型表
		"model/tab_model_ui",				--UI模型表
		"model/tab_model_icon",				--UI图标表
		function()return hVar.tab_model.init()end,	--初始化模型表
		"tab_effect",					--特效信息
		"tab_skill",					--技能表
		"tab_unit",					--单位信息
		"tab_map",					--地图信息表
		"tab_chapter",					--章节信息表
		"tab_randmap",					--随机地图表
		"tab_sceneobj",
		"tab_treasure",					--宝物表
		"tab_filtertext",				--屏蔽字库表
		"tab_chest",					--客户端宝箱表
		"tab_task",					--任务表（新）
		"tab_aura",					--光环
		"tab_chariottalent",				--战车天赋
		"tab_roleicon",					--头像表
		"tab_roleborder",				--角色边框
		"tab_rolechampion",				--角色称号
		"tab_avater",					--战车皮肤表
		"tab_mapbehavior",				--地图行为统计
	}
	
	hDefine.Scripts = {
	}
	--加载所有脚本
	hApi.LoadScripts("tabs/",hDefine.Tabs)
	--hApi.LoadScripts("scripts/",hDefine.Scripts)
else
	--开发方式加载游戏
	_DEBUG_MSG("以源代码方式加载游戏系统")
	--=============================================================
	hApi.LoadLua("scripts/zdefine")				--加载界面Z值定义
	hApi.LoadLua("scripts/var")					--加载枚举定义
	--=============================================================
	hApi.LoadLua("scripts/util/eClass")			--加载公用类库
	eClassInit(function()return hSaveData end)		--公用类库初始化
	hApi.LoadLua("scripts/util/public/hApi")	--加载公用函数文件
	hApi.LoadLua("scripts/gamemsg")				--加载程序回调文件
	hApi.LoadLua("scripts/callback")			--加载程序回调文件
	hApi.LoadLua("scripts/androidfunc")				--加载安卓版特有文件
	
	--=============================================================
	-- 所有待加载的脚本
	--=============================================================
	-- 字符串
	hDefine.LocalString = {
		--加载本地化字符串,使用g_langauge_ver作为索引,(UTF-8)格式
		["default"] = {
			--默认：简体中文
			"tab_string",
		},
		--["chjt"] = {
			----简体中文
			----"tab_string_sc", --geyachao: 暂时去掉繁体选择
			--"tab_string",
		--},
		--["chft"] = {
			----繁体中文
			----"tab_string_tc", --geyachao: 暂时去掉繁体选择
			--"tab_string",
		--},
		["en"] = {
			--英文
			"tab_string_en",
		},
		["jp"] = {
			--日文
			"tab_string_jp",
		},
	}
	-- 表资源
	hDefine.Tabs = {
		--加载资源
		"model/tab_model",				--基本模型表
		"model/tab_model_unit",				--单位模型表
		"model/tab_model_effect",			--特效模型表
		"model/tab_model_sceobj",			--场景物件模型表
		"model/tab_model_ui",				--UI模型表
		"model/tab_model_icon",				--UI图标表
		
		"tab_effect",					--特效信息
		"tab_slash",					--刀光信息
		"tab_skill",					--技能表
		"tab_unit",					--单位信息
		"tab_tactics",					--战术技能
		"tab_army",					--pvp兵种卡片表
		"tab_item",					--道具表
		"tab_enhance",					--物品强化表
		"tab_drop",					--掉落信息
		"tab_shopitem",
		"tab_medal",					--勋章表
		"tab_pvpset",					--pvp配置表
		"tab_bfenv",					--战场随机障碍表
		"tab_map",					--地图信息表
		"tab_chapter",					--地图信息表
		"tab_randmap",					--随机地图表
		"tab_shop",					--商城配置表
		"tab_sceneobj",
		"tab_treasure",					--宝物表
		"tab_filtertext",				--屏蔽字库表
		"tab_chest",					--客户端宝箱表
		"tab_task",					--任务表（新）
		"tab_aura",					--光环
		"tab_chariottalent",				--战车天赋
		"tab_roleicon",					--头像表
		"tab_roleborder",				--角色边框
		"tab_rolechampion",				--角色称号
		"tab_avater",					--战车皮肤表
		"tab_mapbehavior",				--地图行为统计
		
		function()					--章节信息表
			hVar.tab_model.init()
			hVar.tab_drop.init()
		end,
	}
	
	------------------
	-- 代码
	-- 可以为字符串或表形式，如果为表，则加载表中第一个参数，若存在第二个参数，则以函数方式执行
	hDefine.Scripts = {
		--加载util
		
		--加载功能类，跨平台中间件
		--"util/public/timer",				--计时器
		
		--加载基本类

		--工具代码
		"util/public/luatools",				--工具类代码
		"util/public/functions",				--工具类代码
		"util/public/randommap",
		"util/public/randmaproom_config",		--随机地图房间配置表
		"util/public/randmapenemy_config",		--随机地图出怪配置表
		"util/public/randmapenemy",			--随机地图出怪
		
		--"util/core/game/game",				--游戏局
		"util/ui/ui",					--加载UI模块(如果不先加载这里死了你负责)
		"util/public/event",			--事件,所有特殊逻辑处理依赖此模块
		"util/public/server",			--服务器,require All
		--"util/public/netcmd",			--服务器的回调函数
		"util/public/luanetcmddef",		--服务器的回调函数
		"util/public/luasendnetcmd",		--服务器的回调函数
		"util/public/luaonnetcmd",		--服务器的回调函数
		--"util/public/json",			--加载json 格式转换文件
		--"util/public/console",		--控制台， 需要调试可以自己打开，等ios 兼容以后 可以取消注解
		"util/public/command",			--指令操作
		--"util/public/filterText",		--屏蔽字库
		"util/extern",
		"util/public/VitrualController",
		"util/public/randnameprocess",		--随机姓名流程
		"util/public/preloadtxtmanager",	--预加载文字管理
		
		--加载场景基础类
		"util/core/world",				--世界
		"util/core/town",				--主城
		"util/core/map",				--游戏中的非逻辑场景类（选择关卡界面）
		
		--加载物件基础类
		"util/core/action",				--行为,基于单位,地图和物件
		"util/core/sceobj",				--场景物件
		"util/core/unit",				--单位
		"util/core/hero",				--英雄,require 单位
		"util/core/effect",				--特效,require 单位
		"util/core/player",				--玩家,require 英雄
		"util/core/round",				--回合，战场专用
		"util/core/item",				--游戏中的道具类
		"util/core/connect",				--游戏中的网络连接类
		
		--加载游戏信息管理类
		--"ai/game_info",					--
		--"ai/GameInfo/game_info_worldmap",			--
		
		--加载游戏代理和core
		--"logic/game_core",
		--"logic/game_core_cmd",
		--"logic/game_agent",
		
		--加载AI类
		--"ai/game_ai",					--游戏AI
		--"ai/game_ai_city",				--城市内政AI
		--"ai/game_ai_player",				--玩家AI
		"ai/ai_calculate",				--各种AI计算
		
		--加载AI任务类
		--"ai/Task/game_hero_task",			--英雄任务
		--"ai/Explore/game_hero_explore",
		
		--加载AI行为树类
		--"ai/BehaviorTree/bt",				--行为树基类
		--"ai/BehaviorTree/bt_hero/bt_player",		--玩家行为树基类
		--"ai/BehaviorTree/bt_hero/bt_hero",		--英雄行为树基类
		--"ai/BehaviorTree/bt_hero/bt_hero_actionnode",	--英雄行为树Action节点
		--"ai/BehaviorTree/bt_hero/bt_hero_conditionnode",--英雄行为树Condition节点
		
		
		--"logic/game_rule",				--游戏规则
		--"logic/game_zone",				--游戏领地
		"logic/skill_API",				--技能接口
		--"logic/skill_AI",				--战场内施放技能的AI
		
		-- pvp
		--"net/NetDefine",
		--"net/NetManager",
		--"net/NetBattlefield",
		--"net/NetHandler",
		--"net/NetCmd",

		"iap/iap",
		"gameserver/gameserver",
		"gameserver/luaonnetcmd",
		"gameserver/luasendnetcmd",
		"gameserver/review",
		"gameserver/autologin",

		"actiontree/actiontreemanager",
		"actiontree/blackdragon",
		"actiontree/roboticarm",

		"gamemanager",
		
		-- zhenkira 新pvp
		"pvpserver/luaonnetcmd",
		"pvpserver/luasendnetcmd",
		"pvpserver/pvpserver",
		
		--工会服务器
		"groupserver/var_define",
		"groupserver/luaonnetcmd",
		"groupserver/luasendnetcmd",
		"groupserver/groupserver",
		
		"util/public/hotfix",				--动态更新，研发用
		"util/public/recordgamedata",			--统计各项数据
		"util/public/unlock_manager",			--解锁管理
		"util/public/move_equip",			--移动装备
		
		"util/ui/uiGame",				--加载游戏集成UI
		"util/ui/uiTemplate",				--通用UI模板
		"util/ui/uiSkill",				--加载技能UI
		"util/ui/uiCreate",				--所有写完不会再动的UI
		
		--初始化UI函数：UI_Init()
		"util/ui/uiInit",				--UI初始化函数
		--战场操作UI
		"util/ui/battlefieldoprfrm",
		--英雄UI
		"util/ui/uiHero",				--英雄基本UI
		--载入对话框模块
		"util/ui/talkfrm",
		--载入世界排行榜文件
		"util/ui/worldrank",			
		--载入英雄卡片UI面板	
		"util/ui/herocardfrm",		
		--载入 系统菜单面板
		"util/ui/sysmenu",
		--载入 系统菜单面板(主基地)
		"util/ui/systmenu_mainbase",

		--载入 系统弹幕管理
		"util/ui/system_commentmanage",

		--载入 行为统计
		"util/ui/system_behaviorstatistics",	

		"util/ui/privacyandprotocol",

		--载入脚本UI错误框
		"util/ui/errorfram",
		--载入 玩家卡片列表
		"util/ui/playercard",
		--载入 雇佣面板
		--"util/ui/hirefram",
		--载入 网络商店
		--"util/ui/netshop",
		--载入 主城科技升级面板
		--"util/ui/Technology",
		--载入 道具提示面板UI
		"util/ui/itemitp",
		--载入 游戏提示面板
		"util/ui/msgtipfrm",
		--载入 翰林院学习技能面板
		--"util/ui/academy",
		--战斗奖励随机面板
		"util/ui/rewardfrm",
		"util/ui/rewardfrmex",
		--击杀单位掉落面板
		--"util/ui/lootfrm",
		--兵种操作面板
		--"util/ui/ctrlfrm",
		--分兵界面
		--"util/ui/partarmyfrm",
		--兵种升级界面
		--"util/ui/upgradearmyfrm",
		--使用道具界面
		--"util/ui/useitemfrm",
		--选择卡片界面
		"util/ui/selectedhero",
		--载入我的领地界面
		--"util/ui/mycityzoneui",
		--购买英雄界面
		"util/ui/buyherocardfrm",
		--载入地图任务界面
		--"util/ui/questfrm",
		--战场中漂浮文字的处理
		"util/ui/floatnumberBF",
		--载入玩家卡片上的英雄卡片，成就，玩家勋章等界面
		"util/ui/playercardherofrm",
		--加载购买失败
		"util/ui/buyitemfailfrm",
		--领奖界面
		"util/ui/giftfrm",
		--领奖界面
		--"util/ui/vipfrm",
		--"util/ui/vipgetfrm",
		--我的领地界面
		--"util/ui/wdldattackfrm",
		--"util/ui/wdldattackfbfrm",
		--"util/ui/wdldAttackOtherPlayerfrm",
		--"util/ui/wdldendfrm",
		--"util/ui/wdldInfofrm",
		--"util/ui/wdldCloseFrm",
		--"util/ui/wdldNoHeroFrm",
		--"util/ui/wdldofficalfrm",
		--燃烧的远征相关界面
		--"util/ui/rsdyzInfoFrm",
		--"util/ui/rsdyzAttackFrm",
		--"util/ui/rsdyzCloseFrm",
		"util/ui/lua_inputfrm",
		--针对快捷支付用户的 提示框
		"util/ui/InAppPurchaseTipFrm",
		"util/ui/InAppPurchaseTipFrm_Diablo",
		"util/ui/InAppPurchaseTipFrm_Gift",
		"util/ui/InAppPurchaseTipFrm_Equip",
		--新手提示
		--"util/ui/noobhelpfrm",
		--载入对话触发解释器,请把这个东西写在最后面
		"util/ui/uiTgrTalk",
		--战术技能书
		"util/ui/battlefieldskillbook",
		--玩家礼品背包面板
		"util/ui/playergiftbagfrm",
		--重铸面板
		--"util/ui/recastFrm",
		--升级
		"util/ui/levelupfrm",
		--分享
		"util/ui/recommendfrm",
		--每周的星将提示面板
		"util/ui/weekstarhero",
		--加载进入地图面板
		--"util/ui/entermapfrm",
		
		--反卡片界面
		--"util/ui/reversecardfrm",
		--调试面板
		"util/ui/debugfrm",
		--购买符石的面板
		"util/ui/buyfustone",
		--购买礼包成功的界面,
		"util/ui/buygiftitemfrm",
		
		--新的资源条UI
		--"util/ui/resourcebar",
		--新的任务面板
		--"util/ui/questExfrm",
		--PVP战斗结束面板
		--"util/ui/netbattlefieldresultfrm",
		
		--PVP 查看其他玩家界面
		--"util/ui/netbattleplayerinfofrm",
		
		--游戏币金和积分的显示面板
		"util/ui/gamecoinfrm",
		--手机代码
		--手机版主大厅界面
		"util/ui/phone_main_menu",
		"util/ui/phone_selectemap",
		"util/ui/phone_selectemapdragon",
		"util/ui/phone_selectmap_new",
		"util/ui/phone_selectmap_new_temp", --临时选关卡界面
		"util/ui/phone_totalsettlement",
		
		"util/ui/phone_maindotafrm", --新主界面
		"util/ui/phone_mygift",
		"util/ui/phone_myherocardfrm", --英雄令、图鉴界面
		"util/ui/phone_myherocardfrm_guide", --英雄令、图鉴界面新手引导
		"util/ui/phone_mymedal",
		--"util/ui/phone_battlefieldskillbook_game",
		--"util/ui/phone_tacticcardfrm", --战术技能卡界面
		"util/ui/phone_tacticcardfrm_guide", --战术技能卡界面新手引导
		"util/ui/phone_battlefieldoprfrm",
		"util/ui/phone_itemfrm", --道具界面
		"util/ui/phone_itemfrm_RedEquip", --红装神器界面
		"util/ui/phone_itemfrm_Mini", --道具迷你界面（洗炼）
		"util/ui/phone_itemfrm_Mini_RedEquip", --红装神器迷你界面（洗炼）
		"util/ui/phone_taskfrm", --任务界面
		"util/ui/phone_signinfrm", --签到界面
		"util/ui/phone_activityfrm", --活动界面
		"util/ui/phone_achievementfrm", --成就界面
		"util/ui/phone_taskfrm_guide", --成就、任务、活动界面新手引导
		"util/ui/phone_dlcmapfrm", --DLC地图包界面
		"util/ui/phone_dragontalkfrm", --黑龙对话界面
		"util/ui/phone_pvpfrm", --PVP对战界面
		"util/ui/phone_pvpfrm_endless", --PVP无尽联机对战界面
		"util/ui/phone_rankboardfrm", --无尽地图排行榜界面
		"util/ui/phone_rankboardfrm_randommap", --随机迷宫排行榜界面
		"util/ui/phone_pvpfrm_rankboard", --竞技场排行榜界面
		"util/ui/phone_pvpfrm_endless_rankboard", --铜雀台排行榜界面
		"util/ui/phone_toothergamefrm", --推广其他游戏界面
		"util/ui/phone_recommandfrm", --推荐评论界面
		"util/ui/phone_pvparmycardfrm", --竞技场兵种卡洗属性界面
		"util/ui/phone_battlerewardfrm", --铜雀台战斗结束抽奖界面
		"util/ui/phone_savedatafrm", --战车存档记录界面
		"util/ui/phone_systemmailfrm", --系统邮件（新）界面
		"util/ui/phone_randommapfrm", --随机迷宫界面
		"util/ui/phone_announcementfrm",--公告
		"util/ui/phone_chatmessage_frm", --聊天界面
		"util/ui/phone_myvip_1211",
		"util/ui/phone_playerlistfrm",
		"util/ui/phone_mapinfofrm",
		"util/ui/phone_netshopex",
		"util/ui/phone_netshopfrm", --新限时商店界面
		"util/ui/phone_selectedhero",
		--"util/ui/phone_myvip_question",
		"util/ui/phone_selectlevel_question",
		"util/ui/phone_webviewnews",
		"util/ui/phone_playcardfrm",
		"util/ui/tanktipfrm",
		"util/ui/tacticstipfrm",
		--"util/ui/phone_vipmap",
		--PVP相关界面
		--"util/ui/pvpmap",
		--"util/ui/pvpmymark",
		--"util/ui/pvptimeoutfrm",
		--"util/ui/pvparmycardfrm",
		
		"util/ui/phone_worldrank",
		
		"util/ui/sysmenunew",
		--同步数据界面
		"util/ui/syncdatafrm",
		--输入数字界面
		"util/ui/inputfrm",
		--奖励预览界面
		--"util/ui/rewardpreviewfrm",

		--游戏临时背包
		"util/ui/phone_gametempbag",
		
		--英雄装备界面	added by pangyong 2015/3/19
		--"util/ui/phone_heroequip",
		--李宁要的东西
		"util/ui/screenfloatnumber",
		
		--英雄卡介绍界面 added by pangyong 2015/4/14
		"util/ui/phone_herocardinfofrm",
		
		"util/ui/phone_skillupfrm", --大菠萝技能升级界面
		"util/ui/phone_skillupfrminmap",	--地图中大菠萝技能升级界面
		"util/ui/phone_levelupfrm", --大菠萝战车升级界面
		
		"util/ui/phone_tankbillboardfrm", --战车排行榜界面
		"util/ui/achievementmanager",	--成就

		"util/ui/endingaction",		--ending动画

		"util/ui/pop_up_frm",		--弹出式界面

		"util/ui/rewardpreviewfrm",

		"util/ui/chariotconfigfrm",	--战车配置界面
		
		"util/ui/phone_treasure_frm",		--宝物界面
		
		--loading条特效
		"util/ui/loadingeffectfrm",
		
		"util/ui/reviewloginfrm",

		"util/ui/continuouskillingsystem",

		"util/ui/sharefrm",		--分享界面

		"util/ui/aurafrm",		--光环

		"util/ui/blackdragonfrm",	--黑龙商店
		"util/ui/phone_chestfrm",	--宝箱界面
		"util/ui/phone_userdefmapfrm",	--用户自定义地图界面
		"util/ui/phone_userdefmapfrm_vert", --用户自定义地图界面（竖屏）
		"util/ui/phone_tankavaterfrm", --战车皮肤界面

		--GM作弊管理
		"util/ui/gmcheatmanager",
		"util/ui/behaviorstatisticsfrm",

		--小游戏
		"game_gopher",
		
		--系统消息通告解锁某些娱乐地图的面板
		"util/ui/amulockfrm",
		--游戏开始,请把这个东西写在最后面
		"dealwith_unit_event",
		"game_start",
		"game_start_special_event",

		--弹幕界面
		"util/ui/barragefrm",	--弹幕界面
		--评论界面
		"util/ui/commentfrm",	--评论界面

	}
	
	math.randomseed(os.time())
	--加载所有脚本
	if g_langauge_ver and hDefine.LocalString[g_langauge_ver] and #hDefine.LocalString[g_langauge_ver]>0 then
		hApi.LoadScripts("tabs/",hDefine.LocalString[g_langauge_ver])
	else
		hApi.LoadScripts("tabs/",hDefine.LocalString["default"])
	end
	hApi.LoadScripts("tabs/",hDefine.LocalString)
	hApi.LoadScripts("tabs/",hDefine.Tabs)
	hApi.LoadScripts("scripts/",hDefine.Scripts)
	for k,v in pairs(hClass)do
		if type(rawget(v,"sync"))=="function" then
			v:sync("save",k)
		end
	end
end

--====================================================
-- 编辑器加载专用，表格数据处理
if __xlEditorMode==1 then
	--处理表项数据，使其能被程序识别
	local FormatTable = function(t,vType)
		for k,v in pairs(t)do
			if type(v)~="table" then
				t[k] = nil
			else
				v.look = {
					icon = v.icon or "",
					model = v.model,
					name = v.name,
					box = v.box or hVar.DefaultBox[vType] or {0,0,40,40},
					scale = v.scale or 1,
				}
			end
		end
	end
	FormatTable(hVar.tab_unit,"UNIT")
	FormatTable(hVar.tab_effect,"EFFECT")
	--处理模型数据
	for k,v in pairs(hVar.tab_model) do
		if type(v)~="table" then
			hVar.tab_model[k] = nil
		elseif k=="index" then
			--index，什么都不做
		else
			v.modelmode = v.modelmode or "DIRECTIONx2"
			for i=1,#v.animation do
				local ani = v[v.animation[i]]
				ani.image = ani.image or v.image
				ani.interval = ani.interval or 1000
				ani.anchor = ani.anchor or {0.5,0.5}
				ani.flipX = ani.flipX or 0
				ani.flipY = ani.flipY or 0
			end
		end
	end
end