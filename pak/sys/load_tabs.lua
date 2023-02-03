--hDefine.Tabs = {
	----加载文本
	--"tab_string",					--文本表(UTF-8)格式
	----加载资源
	--"model/tab_model",				--基本模型表
	--"model/tab_model_unit",				--单位模型表
	--"model/tab_model_effect",			--特效模型表
	--"model/tab_model_sceobj",			--场景物件模型表
	--"model/tab_model_ui",				--UI模型表
	--"model/tab_model_icon",				--UI图标表
	--function()return hVar.tab_model.init()end,	--初始化模型表
	--"tab_effect",					--特效信息
	--"tab_skill",					--技能表
	--"tab_unit",					--单位信息
	--"tab_item",					--道具表
--}
--------------------
---- 代码
---- 可以为字符串或表形式，如果为表，则加载表中第一个参数，若存在第二个参数，则以函数方式执行
--hDefine.Scripts = {}
--math.randomseed(os.time())
--hApi.LoadScripts("tabs/",hDefine.Tabs)
xpcall(function()
	if type(g_langauge_ver)=="string" and xlIsFileExist("data/"..g_langauge_ver..".lan") then
		xlDoFile("data/"..g_langauge_ver..".lan")
	else
		xlDoFile("data/default.lan")
	end
	xlDoFile("data/bats.so")
	xlDoFile("data/plus.so")
end,function(msg)
	xlLG("init","[load bat.o]加载表格出现错误:"..tostring(msg).."\n")
end)