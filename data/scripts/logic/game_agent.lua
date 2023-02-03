----*************************************************************
---- Copyright (c) 2013, XinLine Co.,Ltd
---- Author: Red
---- Detail: 游戏代理模块 所有的CMD都经该模块转给CORE
-----------------------------------------------------------------
--
--
--
--
--g_Game_Agent = {}
----*************************************************************
---- 常量枚举类型定义
-----------------------------------------------------------------
--
--
--
--
----*************************************************************
---- 内部状态数据
-----------------------------------------------------------------
--g_Game_Agent.State 						= 	{}
--g_Game_Agent.State.Mode 				= 	g_Game_Core.Mode_TypeDef.None
--g_Game_Agent.State.Log					=	false--(1 == g_lua_src)
--g_Game_Agent.State.OpId					=	nil
--g_Game_Agent.State.OpAckInfo			=	nil
--
--
--
--
----*************************************************************
---- 程序内部接口
-----------------------------------------------------------------
--function g_Game_Agent.log(msg)
--	if true == g_Game_Agent.State.Log then
--		xlLG("game_agent",msg)
--	end
--end
--
--function g_Game_Agent.checkoperate(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	if g_Game_Core.Mode_TypeDef.Remote == g_Game_Agent.State.Mode then
--		return g_Game_Core.checkoperate(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	elseif g_Game_Core.Mode_TypeDef.Local == g_Game_Agent.State.Mode then
--
--		return g_Game_Core.checkoperate(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	else
--		return false
--	end
--end
--function g_Game_Agent.operate(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	if g_Game_Core.Mode_TypeDef.None == g_Game_Agent.State.Mode then
--		g_Game_Agent.log("GA error mode on operate\n")
--	else
--		local res = g_Game_Agent.checkoperate(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--		if true == res then
--			g_Game_Agent.State.OpId = nOperate
--			g_Game_Agent.sendcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--		elseif nil == res then
--			g_Game_Agent.sendcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--		end
--	end
--end
--
--
--
--
----*************************************************************
---- 程序外部接口
-----------------------------------------------------------------
--function g_Game_Agent.init(mode)
--	g_Game_Agent.State.OpId = nil
--	g_Game_Agent.State.OpAckInfo = nil
--	
--	if mode == g_Game_Core.Mode_TypeDef.Remote or mode == g_Game_Core.Mode_TypeDef.Local then
--		g_Game_Agent.State.Mode = mode
--	else
--		g_Game_Agent.State.Mode = g_Game_Core.Mode_TypeDef.None
--	end
--	
--	g_Game_Core.init(g_Game_Agent.State.Mode)
--	g_Game_Agent.log("g_Game_Agent.init mode:" .. g_Game_Agent.State.Mode .. "\n")
--end
--
--function g_Game_Agent.order(self,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
--	if g_Game_Core.Mode_TypeDef.None == g_Game_Agent.State.Mode then
--		g_Game_Agent.log("GA error mode on order\n")
--	else
--		if nil == g_Game_Agent.State.OpId then
--			g_Game_Agent.operate(self,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
--		else
--			g_Game_Agent.log("GA error op:" .. nOrder .. " lastop:" .. g_Game_Agent.State.OpId .. " not finish\n")
--		end
--	end
--end
--
--function g_Game_Agent.sendcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	g_Game_Agent.log("g_Game_Agent.sendcmd cid:" .. nOperate .. " \n")
--	if g_Game_Core.Mode_TypeDef.Local == g_Game_Agent.State.Mode then
--		g_Game_Core.recvcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	elseif g_Game_Core.Mode_TypeDef.Remote == g_Game_Agent.State.Mode then
--		--TODO 
--	end
--end
--
--function g_Game_Agent.recvcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY,bRes)
--	g_Game_Agent.log("g_Game_Agent.recvcmd cid:" .. nOperate .. " \n")
--	if g_Game_Core.Mode_TypeDef.Local == g_Game_Agent.State.Mode then
--		if true == bRes then
--			g_Game_Agent.State.OpAckInfo 					= 	{}
--			g_Game_Agent.State.OpAckInfo.self 				= 	self
--			g_Game_Agent.State.OpAckInfo.oWorld 			= 	oWorld
--			g_Game_Agent.State.OpAckInfo.nOperate 			= 	nOperate
--			g_Game_Agent.State.OpAckInfo.oOperatingUnit 	= 	oOperatingUnit
--			g_Game_Agent.State.OpAckInfo.vOrderId 			= 	vOrderId
--			g_Game_Agent.State.OpAckInfo.oOperatingTarget 	= 	oOperatingTarget
--			g_Game_Agent.State.OpAckInfo.gridX 				= 	gridX
--			g_Game_Agent.State.OpAckInfo.gridY 				= 	gridY
--			g_Game_Agent.State.OpAckInfo.worldX 			= 	worldX
--			g_Game_Agent.State.OpAckInfo.worldY 			= 	worldY
--			
--			--g_Game_Agent.run()
--		else
--			g_Game_Agent.State.OpId	= nil
--		end
--	elseif g_Game_Core.Mode_TypeDef.Remote == g_Game_Agent.State.Mode then
--		
--	end	
--end
--
--function g_Game_Agent.removecmd()
--	g_Game_Agent.State.OpId	= nil
--	g_Game_Agent.State.OpAckInfo = nil
--end
--
--function g_Game_Agent.runcmd(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	if type(g_Game_Core.CmdOp[nOperate].runcall) == "function" then
--		g_Game_Core.CmdOp[nOperate].runcall(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
--	end
--end
--
--function g_Game_Agent.run(scene,frame_count)
--	g_current_frame_count = frame_count
--
--	if type(UpdateRunCallBack) == "function" then
--		UpdateRunCallBack(frame_count)
--	end
--	
--	if type(Game_Zone_OnGameEvent) == "function" then
--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Run)
--	end
--	
--	if g_Game_Core.Mode_TypeDef.Local == g_Game_Agent.State.Mode then
--		if type(g_Game_Agent.State.OpAckInfo) == "table" then
--			local cmd = g_Game_Agent.State.OpAckInfo
--			g_Game_Agent.runcmd(cmd.self,cmd.oWorld,cmd.nOperate,cmd.oOperatingUnit,cmd.vOrderId,cmd.oOperatingTarget,cmd.gridX,cmd.gridY,cmd.worldX,cmd.worldY)
--			g_Game_Agent.State.OpId	= nil
--			g_Game_Agent.State.OpAckInfo = nil
--		end
--	end 
--	
--	if scene == g_world then
--		--hGlobal.event:call("Event_UpdateGame", frame_count)
--		--heroGameRule.OnGameEvent(heroGameRule.gameEvent_TypeDef.UPDATE)
--	end
--end