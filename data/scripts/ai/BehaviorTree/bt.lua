--BT = {}
--BT.Node_TypeDef = {S="Selector",Se="Sequence",P="Parallel",A="Action",C="Condition"}
--
--function BT.CreateNode(nodetype,nodename,parentnode)
--	if nil == parentnode then
--		--_DEBUG_MSG("BT.CreateNode type:" .. nodetype .. " name:" .. nodename .. " parentnode:nil")
--	else
--		--_DEBUG_MSG("BT.CreateNode type:" .. nodetype .. " name:" .. nodename .. " parentnode:" .. parentnode.nodename)
--	end
--	
--	
--	if nodetype == nil then
--		_DEBUG_MSG("BT.CreateNode error type:" .. nodetype)
--		return nil
--	else
--		local newnode = {}
--		newnode.nodetype = nodetype
--		newnode.nodename = nodename
--		newnode.parentnode = parentnode
--		if parentnode ~= nil then
--			if (parentnode.nodetype == BT.Node_TypeDef.S or parentnode.nodetype == BT.Node_TypeDef.Se or parentnode.nodetype == BT.Node_TypeDef.P) then
--				parentnode[#parentnode + 1] = newnode
--			else
--				_DEBUG_MSG("BT.CreateNode error parentnode type:" .. parentnode.nodetype)
--			end
--		end
--		return newnode
--	end
--end
--
--function BT.Init()
--	--_DEBUG_MSG("BT.Init()")
--	
--	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
--	if TargetPlatform ~= g_tTargetPlatform.kTargetWindows then
--		hVar.OPTIONS.AI_LOG = 0
--	end
--
--	BT.playerBT.Init()
--end