--heroGameAI = {}
--function heroGameAI.LogAi(info,parm1,parm2,parm3,parm4)
--	if hVar.OPTIONS.AI_LOG==1 then
--		xlLG("ai",info)
--	end
--end
--
--
--local function initNewDay(p)
--	if p then
--		--p:addresource(hVar.RESOURCE_TYPE.GOLD,2000)
--	end
--end
--
--function heroGameAI.Run(p)
--	--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx gold:" .. p.data.resource[hVar.RESOURCE_TYPE.GOLD])
--	initNewDay(p)
--	heroGameAI.currentPlayer = p
--	heroGameAI.cityAI.Run(p)
--	heroGameAI.playerAI.Run(p)
--end