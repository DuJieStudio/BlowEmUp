local __so_path_scripts = "game.so"
local __so_path_tabs = "bats.so"
local __so_path_plus = "plus.so"
local __so_path_game_up = "game_up.ss"
local IsFileExist = function(s)
	local f = io.open(s)
	if f then
		f:close()
		return true
	else
		return false
	end
end

xlDoFile = function() end
eClassInit = function() hApi.LoadScripts = function()end end
__print = print
print = function() end
dofile("../data/scripts/load_gamesys.lua")

local sTable = {
	"sys/load_core.lua",
	"../data/scripts/load_gamesys.lua",
	"../data/scripts/var.lua",
	"../data/scripts/zdefine.lua",
	"../data/scripts/util/eClass.lua",
	"sys/load_sync.lua",
	"../data/scripts/util/public/hApi.lua",
	"../data/scripts/gamemsg.lua",
	"../data/scripts/callback.lua",
	"../data/scripts/androidfunc.lua",
	"sys/load_tabs.lua",
}

for i = 1,#hDefine.Scripts do
	if type(hDefine.Scripts[i])=="string" then
		sTable[#sTable+1] = "../data/scripts/"..hDefine.Scripts[i]..".lua"
	else
		__print("warning!读取scripts时碰到执行过程!",i)
	end
end

sTable[#sTable+1] = "sys/load_end.lua"

local f = io.open("sys/package.bat","w")
f:write("@echo off\n")
f:write("luac -o ../data/"..__so_path_scripts)
for i = 1,#sTable do
	f:write(" ^\n"..sTable[i])
end

--打包多语言字符串
for sLangauge,v in pairs(hDefine.LocalString)do
	if #v>0 and type(sLangauge)=="string" then
		f:write("\necho f|xcopy ")
		for i = 1,#v do
			if type(v[i])=="string" then
				f:write("..\\data\\tabs\\"..v[i]..".lua")
			end
		end
		f:write(" ..\\data\\"..sLangauge..".lan /y")
	end
end

--打包表
f:write("\n\nluac -o ../data/"..__so_path_tabs)
for i = 1,#hDefine.Tabs do
	if type(hDefine.Tabs[i])=="string" then
		f:write(" ^\n../data/tabs/"..hDefine.Tabs[i]..".lua")
	end
end
f:write(" ^\nsys/init_tabs.lua")

local PlusPath = "../data/scripts/plus.lua"
if IsFileExist(PlusPath) then
	f:write("\n\nluac -o ../data/"..__so_path_plus.." "..PlusPath)
else
	f:write("\n\nluac -o ../data/"..__so_path_plus.." sys/load_plus.lua")
end

--打包game_up.ss
local SSPath = "../data/game_up.ss"
if IsFileExist(SSPath) then
	f:write("\n\nluac -o ../data/"..__so_path_game_up.." "..SSPath)
end

f:write("\necho 打包.o... ok!\n")
f:close()
