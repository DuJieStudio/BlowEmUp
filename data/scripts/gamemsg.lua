-- 底层事件处理类
print("load gamemsg.lua")

-- 事件回调函数表
g_gamemsg_handler = {}
-- 事件队列
g_gamemsg_queue	  = 
{
	-- 测试事件
  	[1] = { msg = "gmsg_test", param1 = 0, param2 = 3, param3 = "abbc", param4 = 0}
}

-- 添加事件入队[底层也会调用]
function xlGameMsg(msg, param1, param2, param3, param4)
	
	local msg_count = table.maxn(g_gamemsg_queue)
	
	local msg_data  = {}
	msg_data.msg = msg

	if param1==nil then param1 = 0 end
	if param2==nil then param2 = 0 end
	if param3==nil then param3 = 0 end
	if param4==nil then param4 = 0 end
	
	msg_data.param1 = param1
	msg_data.param2 = param2
	msg_data.param3 = param3
	msg_data.param4 = param4
	
	g_gamemsg_queue[msg_count + 1] = msg_data
	
	xlLG("gamemsg", "Add gamemsg [%s]\n", msg_data.msg)
	
end


-- 事件处理循环[底层调用]
function xlGameMsgLoop()
	
	local msg_count = table.maxn(g_gamemsg_queue)
	
	if msg_count > 0  then 
	   xlLG("gamemsg", "game msg_count = %d\n", msg_count) 
	end
	
	for i=1, msg_count do  
		local msg_data = g_gamemsg_queue[i]
		
		if msg_data~=nil then
			
			xlLG("gamemsg", "handle gamemsg [%s]\n", msg_data.msg)
			--print("param[1 2 3 4] = ")
			--print(msg_data.param1)
			--print(msg_data.param2)
			--print(msg_data.param3)
			--print(msg_data.param4)
			
			local func = g_gamemsg_handler[msg_data.msg]
			if func then
				func(msg_data.param1, msg_data.param2, msg_data.param3, msg_data.param4)
			else
				--print("error, undefined gmsg func = "..func)
				xlLG("error", "undefined gmsg[%s] func ", msg_data.msg)
			end
			g_gamemsg_queue[i] = nil
			
		end
	end 
	
	--local msg_count = table.maxn(g_gamemsg_queue)
	
	--local msg_left = 0
	--for i=1, msg_count do  
		--local msg_data = g_gamemsg_queue[i]
		--if msg_data~=-1 then
		 -- msg_left = msg_left + 1
		--end
	--end
	
	--if msg_left==0 then
	  -- g_gamemsg_queue = {}
	  --if msg_count > 0 then 
	   --  xlLG("gamemsg", "last msg count = %d, clear gamemsg queue!\n", msg_count)
	  --end
	--end
end

-- 事件回调函数定义
-- ===================================================================================================================
g_gamemsg_handler["gmsg_test"] = function(param1, param2, param3, param4)
	
	xlLG("gamemsg", "handle testmsg %d %d [%s] %d!\n", param1, param2, param3, param4)
end


g_gamemsg_handler["gmsg_endday"] = function(param1, param2, param3, param4)
	
	local w = hGlobal.WORLD.LastWorldMap
	if w==nil then
		--世界不存在，禁止结束一天
		return
	elseif w.data.IsPaused==1 then
		--世界暂停中，禁止结束一天
		return
	end
	local CanNotGoNextDay = 0
	hClass.hero:enum(function(oHero)
		local u = oHero:getunit()
		if u and u.handle.UnitInMove==1 and u:getworld()==hGlobal.WORLD.LastWorldMap then
			CanNotGoNextDay = 1
		end
	end)
	if CanNotGoNextDay==1 then
		--还有单位在移动，禁止进入下一天
		return
	end
	local day_count = param1
	
	xlLG("gamemsg", "request end a day, day_count = %d\n", param1)
	if hVar.OPTIONS.IS_NO_AI==1 then
		--禁止AI的话，直接结束一天
		return hGlobal.event:call("Event_EndDay", day_count)
	elseif hApi.AIRoundStart(day_count) then
		--尝试移交操作权给AI,由AI发起结束一天的事件
		return
	else
		--如果失败的话直接结束一天
		return hGlobal.event:call("Event_EndDay", day_count)
	end
end

g_gamemsg_handler["gmsg_cha_arrived_target"] = function(param1, param2, param3, param4)
	
	--print("param1 = "..param1)
	
	local x, y = xlCha_GetPos(param1)
	
	xlLG("gamemsg", "cha arrived, pos [%d %d]\n", x, y)
	
	xlLuaEvent_cha_arrived(param1, param2, param3, param4)
end

g_gamemsg_handler["gmsg_button_click"] = function(param1, param2, param3, param4)
   g_buttons_handle[param1](param2)
end
-- ===================================================================================================================