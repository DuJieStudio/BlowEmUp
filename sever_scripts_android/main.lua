local printFlag = true


if not loadstring then
	loadstring = load
end
if nil == math.mod then
math.mod = math.fmod
end
if nil == string.gfind then
string.gfind = string.gmatch
end
if nil == math.atan2 then
math.atan2 = math.atan
end
if not xlDb_Execute then
	xlDb_Execute = red.xlDb_Execute
end
if not xlDb_Query then
	xlDb_Query = red.xlDb_Query
end
if not xlDb_QueryEx then
	xlDb_QueryEx = red.xlDb_QueryEx
end
if not xlNet_Send then
	xlNet_Send = red.xlNet_Send
end
if not xlNet_KickOut then
	xlNet_KickOut = red.xlNet_KickOut
end
if not xlLog_SetLevel then
	xlLog_SetLevel = red.xlLog_SetLevel
end
if not xlLog_Log then
	xlLog_Log = red.xlLog_Log
end
if not xlConfig_GetString then
	xlConfig_GetString = red.xlConfig_GetString
end
_print = print
print = function(...)
	if printFlag then
		_print(...)
	end
end

function main()
	dofile("scripts/var.lua")	
end

main()