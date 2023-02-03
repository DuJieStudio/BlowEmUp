for k,v in pairs(hClass)do
	if type(rawget(v,"sync"))=="function" then
		v:sync("save",k)
	end
end