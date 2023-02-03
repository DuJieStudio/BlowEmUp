--*************************************************************
-- Copyright (c) 2013, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏领地模块
---------------------------------------------------------------
-- xlLoginRedAnswer(errorcode) 常
-- 0	操作成功 关闭窗口
-- 1	连接失败
-- 2	用户名不存在(论坛没注册)
-- 3	用户名或密码错误
-- 4	创建游戏里的名字界面
-- 好吧以上接口流程废弃了再也不会有了...




-- Game_Zone_OnGameEvent(nEvent,param1,param2,param3,param4) red

-- Game_Zone_OnGameEventCallBack(nEvent,nErrorCode,p3,p4,p5) king
-- 0	成功
-- +	失败

-- errorcode = xlZoneEvent() red
-- 0	成功
-- +	失败

-- xlLuaEvent_ZoneEvent(nEvent,nErrorCode) red
-- 0	成功
-- +	失败
--[[
g_WDLD_BeginATK = 0
g_WDLD_Attr = 0 -- 0新玩家或者重进我的领地  -1准备完毕 其他自然数：玩到第N天建设中的档
g_WDLD_OtherLv = 0 --别的玩家的领地等级
g_WDLD_OtherOutHero = ""
g_WDLD_RB = 0--按规则随机我的领地的建筑
g_WDLD_ADD_RES = 1
g_WDLD_RESTART_MAP_NAME = "level_wdld"

g_RSDYZ_BattleID = 0
g_RSDYZ_LastCom = nil

g_zone_enable = (1 == g_lua_src) or true

g_BuildingCitySave = 0
g_ReadyCitySave = 1
zone_battle_summary = {}
WDLD_Init_Data = {
	LV = 0,
	EXP = 0,
	IRON = 0,
	WOOD = 0,
	FOOD = 0,
	GOLD = 0,
	STONE = 0,
	CRYSTAL = 0,
}

WDLD_HERO_OFFICAL_EXP_STR = {}--英雄的功勋
WDLD_HERO_OFFICAL_SET = ""--英雄的官阶

rsdyz_player_len = 0
RSDYZ_NEED_PLAYER_LEN = 20
rsdyz_playerIdAndName = {}
rsdyzPlayerHeroSaveList = {}

WDLD_Next_Data = {
	LV = 0,
	EXP = 0,
	IRON = 0,
	WOOD = 0,
	FOOD = 0,
	GOLD = 0,
	STONE = 0,
	CRYSTAL = 0,
}

test_role_id = 9998

g_Game_Zone				=	{}
g_Game_Zone.ZoneTemplate = nil
g_Game_Zone.Functions	=	{}
local f_zone			=	g_Game_Zone.Functions
--*************************************************************
-- 常量枚举类型定义
---------------------------------------------------------------
GC3_TypeDef = {
	YES			= 0,
	ING			= 1,
	NO			= 2,
}
local yes = GC3_TypeDef.YES
local no = GC3_TypeDef.NO
local ing = GC3_TypeDef.ING

local ServerNoConn = -4078
local NoNetWork = -4073

GZone_Event_TypeDef = {
	Nil			= -1,
	Run			= 0,
	--Login		= 1,
	Connect		= 2,
	Close		= 3,
	--Create		= 4,
	Enter		= 5,
	Leave		= 6,
	Load		= 7,
	Save		= 8,

	Lua			= 44,

	-- 以下开始为脚本自己定义的协议的ID 注意新协议只能往下增加
	GetZoneData	= 60, -- 发起请求的roleid 目标roleid
	GetZoneList	= 61, -- 取列表

	BattleBegin	= 62, -- 通知服务器开始一局战斗
	BattleEnd	= 63, -- 通知服务器当前战斗局结束

	BattleLog	= 64, -- 没场小战役的战报
	WDLDRestart	= 65, -- 重新我的领地

	GetBattleSummary	= 66, -- 取战斗记录
	GetZoneTemplate = 67, -- 取模版数据
	Ex_SetGrjx		= 68, -- 存放官阶分配信息
	GetNotice		=	69, -- 获取公告
	GetHeroInfo		=	70, -- 获取英雄数据

	GetHeroData		= 199, -- 临时解决方案每次取5个角色的3个英雄
	GetDBInfo	= 200,		-- 统一的接口获取db数据

	BattleLog_Fire = 201,	-- 燃烧的远征战报
	BattleBegin_Fire = 202, -- 燃烧的远征战斗开始
	BattleEnd_Fire = 203,	-- 燃烧的远征战斗结束

	GetBattleSummary_Fire = 204, -- 燃烧的远征战斗记录
	GetBattleSummary_Fire_defence = 205, -- 燃烧的远征战斗记录(防守)

	Shop			= 206,	-- 消费相关流程

	ServerScript	= 250,	-- 服务器脚本 这是最后的id了
}
GZone_Event_DataDef = {
	ROLE = 1,
	WHICHROLE = 2,
	LV = 3,
	EXP = 4,
	GOLD = 5,
	FOOD = 6,
	WOOD = 7,
	STONE = 8,
	IRON = 9,
	CRYSTAL = 10,
	MAP_NAME = 11,
	OFFICAL_STR = 12,
	OFFICAL_SET = 13,
	REST_TIMES = 14,
	RSDYZ_COIN = 15,
	RSDYZ_BATTLE_GONG_XIAN = 16,
}

GZone_Event_ReStart = {
	LV = 1,
	EXP = 2,
	GOLD = 3,
	FOOD = 4,
	WOOD = 5,
	STONE = 6,
	IRON = 7,
	CRYSTAL = 8,
}

GZone_WDLD_Attack_Get = {
	GOLD = 3,
	FOOD = 4,
	WOOD = 5,
	STONE = 6,
	IRON = 7,
	CRYSTAL = 8,
	EXP = 9,
	TIME = 10,
}
local t_nil		=	GZone_Event_TypeDef.Nil
local t_run		=	GZone_Event_TypeDef.Run
--local t_login	=	GZone_Event_TypeDef.Login
local t_connect	=	GZone_Event_TypeDef.Connect
local t_close	=	GZone_Event_TypeDef.Close
--local t_create	=	GZone_Event_TypeDef.Create
local t_enter	=	GZone_Event_TypeDef.Enter
local t_leave	=	GZone_Event_TypeDef.Leave
local t_load	=	GZone_Event_TypeDef.Load
local t_save	=	GZone_Event_TypeDef.Save
local t_lua		=	GZone_Event_TypeDef.Lua




--*************************************************************
-- 错误类型定义
---------------------------------------------------------------
GZone_Error_TypeDef = {
	EC_SUCCEED			= 0,

	EC_PA_NOACCOUNT = 1,
	EC_PA_MOREACCOUNT = 2,
	EC_PA_ERRORPASSWORD = 3,
	EC_PA_ONEMORELOGIN = 4,

	EC_NOLOGIN = 5,

	EC_ZONE_NOACCOUNT = 100,
	EC_ZONE_MOREACCOUNT = 101,
	EC_ZONE_ERRORACCOUNT = 102,

	EC_ZONE_NODATA = 103,
	EC_ZONE_MOREDATA = 104,
	EC_ZONE_ERRORDATA = 105,

	EC_ZONE_BATTLE_REBEGIN = 106,
	EC_ZONE_BATTLE_NOBEGIN = 107,
	EC_ZONE_BATTLE_PROTECT = 108,
	EC_ZONE_BATTLE_INVALID = 109,
	EC_ZONE_NO_POINT = 110,

	EC_DBERROR			= 800,

	EC_SHOP_NOMONEY = 801,

	Zone		= 4440,
	Error_Id	= 4441,
	Error_Event	= 4442,
	Error_State	= 4443,
	Error_Lua	= 4444,
}
local e_id		= GZone_Error_TypeDef.Error_Id
local e_event	= GZone_Error_TypeDef.Error_Event
local e_state	= GZone_Error_TypeDef.Error_State
local e_lua		= GZone_Error_TypeDef.Error_Lua


--*************************************************************
-- 内部状态数据
---------------------------------------------------------------
g_Game_Zone.State 						= 	{}

g_Game_Zone.State.Log					= 	{}
local	s_log							=	g_Game_Zone.State.Log
s_log.enable							=	true

g_Game_Zone.State.NetWork				=	{}
local	s_net							=	g_Game_Zone.State.NetWork
s_net.ip								=	"115.29.161.160"--"10.211.55.3"
s_net.port								=	9940
s_net.state								=	no -- 网络状态

g_Game_Zone.State.Login					=	{}
local	s_login							=	g_Game_Zone.State.Login
s_login.email							=	""
s_login.password						=	""
s_login.roleid							=	-1

g_Game_Zone.State.Game					=	{}
local	s_game							=	g_Game_Zone.State.Game
s_game.id								=	-1	-- -1未登录 其他值表示roleid
s_game.event							=	t_nil -- 当前游戏事件
s_game.event_tick						=	0

g_Game_Zone.State.Load					=	{}
local	s_load							=	g_Game_Zone.State.Load
s_load.rid								=	-1
s_load.whichrole						=	-1
s_load.whichone							=	0
s_load.fullpath							=	""

g_Game_Zone.State.Save					=	{}
local	s_save							=	g_Game_Zone.State.Save
s_save.rid								=	-1
s_save.whichone							=	0
s_save.fullpath							=	""



--*************************************************************
-- 程序内部接口
---------------------------------------------------------------
f_zone.Log			=					function(msg)
	if true == s_log.enable then
		xlLG("game_zone",msg)
	end
end

f_zone.EventName	=					function(event)
	if t_nil == event then
		return "nil"
	elseif t_run == event then
		return "run"
	elseif t_connect == event then
		return "connect"
	elseif t_close == event then
		return "close"
	elseif t_enter == event then
		return "enter"
	elseif t_leave == event then
		return "leave"
	elseif t_load == event then
		return "load"
	elseif t_save == event then
		return "save"
	elseif t_lua == event then
		return "lua"
	else
		return "unknow:" .. tostring(event)
	end
end

f_zone.SetEvent	=						function(event)
	s_game.event = event
	s_game.event_tick = hApi.gametime()
end

f_zone.DoConnect	=					function()
	if no == s_net.state then -- 未连接
		s_net.state = ing
		if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
			s_net.ip = g_lrc_Ip
		end
		local res = xlZoneEvent(t_connect,s_net.ip,s_net.port)
		f_zone.Log(string.format("xlZoneEvent Connect ip:%s port:%d res:%d \n",s_net.ip,s_net.port,res))
		if 0 == res then
		else	
			xlLuaEvent_ZoneEvent(t_connect,res)
		end
	else
		Game_Zone_OnGameEventCallBack(t_connect,e_state)
	end
end

f_zone.DoLogin		=					function(email,password)
	if t_nil == s_game.event then -- 当前没事件在执行中
		if -1 == s_game.id then -- 未登录
			f_zone.SetEvent(t_login)
			s_login.email = email
			s_login.password = password
			if yes == s_net.state then -- 已连接
				local res = xlZoneEvent(t_login,email,password)
				f_zone.Log("xlZoneEvent Login res:" .. res .. "\n")
				if 0 == res then
				else
					f_zone.SetEvent(t_nil)
					xlLoginRedAnswer(1)
				end
			elseif no == s_net.state then -- 未连接
				f_zone.DoConnect()
			end			
		else
			f_zone.Log("DoLogin error state id:" .. s_game.id .. "\n")
		end
	else
		f_zone.Log("DoLogin error other event:" .. s_game.event .. "\n")
	end
end

f_zone.DoCreate = function(name)
	if t_nil == s_game.event then -- 当前没事件在执行中
		if 0 == s_game.id then -- 已登录
			f_zone.SetEvent(t_create)
			local res = xlZoneEvent(t_create,name)
			f_zone.Log("xlZoneEvent Create res:" .. res .. "\n")
			if 0 == res then
			else
				f_zone.SetEvent(t_nil)
				xlLoginRedAnswer(1)
			end
		else
			f_zone.Log("DoCreate error state id:" .. s_game.id .. "\n")
		end
	else
		f_zone.Log("DoCreate error other event:" .. s_game.event .. "\n")
	end
end

f_zone.DoEnter = function(roleid)
	if t_nil == s_game.event then -- 当前没事件在执行中
		--if -1 == s_game.id then -- 未登录
			f_zone.SetEvent(t_enter)
			s_login.roleid = roleid
			if yes == s_net.state then -- 已连接
				local res = xlZoneEvent(t_enter,roleid)
				f_zone.Log(string.format("xlZoneEvent Enter roleid:%d res:%d luaGetplayerDataID:%d\n",roleid,res,luaGetplayerDataID()))
				if 0 == res then
				else
					xlLuaEvent_ZoneEvent(t_enter,res)
				end
			elseif no == s_net.state then -- 未连接
				s_login.roleid = roleid
				f_zone.DoConnect()
			end
		--else
		--	xlLuaEvent_ZoneEvent(t_enter,e_id)
		--end
	else
		Game_Zone_OnGameEventCallBack(t_enter,e_event)
	end
end

f_zone.DoLeave = function(roleid)
	if s_game.id > 0 then -- 领地
		f_zone.SetEvent(t_leave)
		s_game.id = -1
		local res = xlZoneEvent(t_leave,roleid)
		if 0 == res then
		else
			xlLuaEvent_ZoneEvent(t_leave,res)
		end
	else
		s_game.id = -1
		s_game.event = t_nil
	end
end

-- whichone 0(ing) 1(ed)
f_zone.DoLoad = function(roleid,whichrole,whichone,fullpath)
	if t_nil == s_game.event then -- 当前没事件在执行中
		if -1 < s_game.id then -- 领地
			f_zone.SetEvent(t_load)
			s_load.rid = roleid
			s_load.whichrole = whichrole
			s_load.whichone = whichone
			s_load.fullpath = fullpath
			local res = xlZoneEvent(t_load,roleid,whichrole,whichone,fullpath)
			f_zone.Log(string.format("xlZoneEvent rid%d Load rid:%d whichrole:%d whichone:%d path:%s res:%d \n",s_game.id,roleid,whichrole,whichone,fullpath,res))
			if 0 == res then
			else
				xlLuaEvent_ZoneEvent(t_load,res)
			end			
		else
			xlLuaEvent_ZoneEvent(t_load,e_id)
		end
	else
		Game_Zone_OnGameEventCallBack(t_load,e_event,roleid,whichrole,whichone,fullpath)
	end
end

f_zone.DoSave = function(roleid,whichone,fullpath)
	if t_nil == s_game.event then -- 当前没事件在执行中
		if -1 < s_game.id then -- 领地
			f_zone.SetEvent(t_save)
			s_save.rid = roleid
			s_save.whichone = whichone
			s_save.fullpath = fullpath
			local res = xlZoneEvent(t_save,roleid,whichone,fullpath)
			f_zone.Log(string.format("xlZoneEvent rid:%d Save rid:%d whichone:%d path:%s res:%d \n",s_game.id,roleid,whichone,fullpath,res))
			if 0 == res then
			else
				xlLuaEvent_ZoneEvent(t_save,res)
			end			
		else
			xlLuaEvent_ZoneEvent(t_save,e_id)
		end
	else
		Game_Zone_OnGameEventCallBack(t_save,e_event,roleid,whichone,fullpath)
	end
end

f_zone.DoLua = function(param_table)
	if type(param_table) == "table" and (#param_table >0) then
		local id = param_table[1]
		if t_nil == s_game.event then -- 当前没事件在执行中
			if -1 < s_game.id then -- 领地
				f_zone.SetEvent(t_lua)
				local res = xlZoneEvent(t_lua,#param_table,param_table)
				f_zone.Log(string.format("xlZoneEvent DoLua id:%d res:%d \n",id,res))
				if 0 == res then
				else
					xlLuaEvent_ZoneEvent(t_lua,res,id)
				end
			else
				xlLuaEvent_ZoneEvent(t_lua,e_id,id)
			end
		else
			Game_Zone_OnGameEventCallBack(t_lua,e_event,id)
		end
	else
		Game_Zone_OnGameEventCallBack(t_lua,e_lua)
	end
end




--*************************************************************
-- 程序内部事件回调
---------------------------------------------------------------
-- t_lua类型回调
function xlLuaEvent_LuaEvent(param_table)
	if t_lua == s_game.event or t_nil == s_game.event then
		f_zone.SetEvent(t_nil)
		if type(param_table) == "table" and #param_table >=3 then
			local nEvent = param_table[1]
			local id = param_table[2]
			local errcode = param_table[3]
			local params = {}
			f_zone.Log("xlLuaEvent_LuaEvent id:" .. id .. " errcode:" .. errcode .. "\n")
			for i = 4,#param_table do
				params[i-3] = param_table[i]
				--f_zone.Log("xlLuaEvent_LuaEvent param_table i:" .. i .. " v:" .. tostring(param_table[i]) .. "\n")
			end
			Game_Zone_OnGameEventCallBack(t_lua,errcode,id,params)
		else
			f_zone.Log("xlLuaEvent_LuaEvent param_table error")
		end
	else
		f_zone.Log(string.format("xlLuaEvent_ZoneEvent t_lua error event:%s \n",f_zone.EventName(s_game.event)))
	end
end
-- 程序事件统一回调
function xlLuaEvent_ZoneEvent_Table(paramTable)
	if type(paramTable) == "table" and #paramTable > 2 then
		local nEvent = paramTable[1]
		local nErrorCode = paramTable[2]
		local params = {}
		for i = 3,#paramTable do
			params[i-2] = paramTable[i]
			f_zone.Log("xlLuaEvent_ZoneEvent_Table paramTable i:" .. i .. " v:" .. tostring(paramTable[i]) .. "\n")
		end
		xlLuaEvent_ZoneEvent(nEvent,nErrorCode,params)
	else
		f_zone.Log("xlLuaEvent_ZoneEvent_Table error params\n")
	end
end
function xlLuaEvent_ZoneEvent(nEvent,nErrorCode,param1)
	f_zone.Log(string.format("xlLuaEvent_ZoneEvent event:%s errorcode:%d \n",f_zone.EventName(nEvent),nErrorCode))
	if t_connect == nEvent then -- 连接上了
		if 0 == nErrorCode then
			s_net.state = yes
			if t_enter == s_game.event then -- 登陆流程中
				f_zone.SetEvent(t_nil)
				f_zone.DoEnter(s_login.roleid)
			end
		else
			s_net.state = no
			Game_Zone_OnGameEventCallBack(t_close,nErrorCode)
		end
	elseif t_close == nEvent then -- 断开连接
		local gid = s_game.id
		s_net.state = no
		s_game.id = -1
		f_zone.SetEvent(t_nil)
		--if gid > 0 then
			Game_Zone_OnGameEventCallBack(t_close,nErrorCode)
		--end
	elseif t_enter == nEvent then -- 服务器进入领地回应
		if t_enter == s_game.event then
			f_zone.SetEvent(t_nil)
			local res = nil
			if 9 <= nErrorCode and 100 > nErrorCode then
				s_game.id = s_login.roleid
				res = nErrorCode - 10
				nErrorCode = 0
				f_zone.Log(string.format("xlLuaEvent_ZoneEvent enter ok rid: %d \n",s_game.id))
			end
				if type(param1) == "table" then
					f_zone.Log(string.format("xlLuaEvent_ZoneEvent enter ok ex_param num: %d\n",#param1))
					for i = 1,#param1 do
						f_zone.Log(string.format("xlLuaEvent_ZoneEvent enter ok ex_param index(%d):%s \n",i,tostring(param1[i])))
					end
				end
			Game_Zone_OnGameEventCallBack(t_enter,nErrorCode,res,param1)
		else
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent enter error event:%s \n",f_zone.EventName(s_game.event)))
		end
	elseif t_leave == nEvent then -- 服务器离开领地回应
		if t_leave == s_game.event then
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent leave ok rid: %d \n",s_game.id))
			f_zone.SetEvent(t_nil)
			s_game.id = -1
			Game_Zone_OnGameEventCallBack(t_leave,nErrorCode)
		else
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent leave error event:%s \n",f_zone.EventName(s_game.event)))
		end
	elseif t_load == nEvent then -- 服务器读档回应
		if t_load == s_game.event then
			f_zone.SetEvent(t_nil)
			Game_Zone_OnGameEventCallBack(t_load,nErrorCode,s_load.rid,s_load.whichrole,s_load.whichone,s_load.fullpath)
			s_load.rid = -1
			s_load.whichrole = -1
			s_load.whichone = 0
			s_load.fullpath = ""
		else
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent load error event:%s \n",f_zone.EventName(s_game.event)))
		end
	elseif t_save == nEvent then -- 服务器写档回应
		if t_save == s_game.event then
			f_zone.SetEvent(t_nil)
			local res = nil
			if 9 <= nErrorCode and 100 > nErrorCode then
				res = nErrorCode - 10
				nErrorCode = 0
			end
			Game_Zone_OnGameEventCallBack(t_save,nErrorCode,s_save.rid,s_save.whichone,s_save.fullpath,res)
			s_save.rid = -1
			s_save.whichone = 0
			s_save.fullpath = ""
		else
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent save error event:%s \n",f_zone.EventName(s_game.event)))
		end
	elseif t_lua == nEvent then -- lua自定义事件
		if t_lua == s_game.event then
			f_zone.SetEvent(t_nil)
			Game_Zone_OnGameEventCallBack(t_lua,nErrorCode,param1)
		else
			f_zone.Log(string.format("xlLuaEvent_ZoneEvent lua error event:%s \n",f_zone.EventName(s_game.event)))
		end
	end
end




--*************************************************************
-- 程序外部接口
---------------------------------------------------------------
-- 所有事件触发入口
function Game_Zone_OnGameEvent(nEvent,param1,param2,param3,param4)
	if true == g_zone_enable then
		if t_run == nEvent then
			local res = xlZoneEvent(t_run)
			return
		end
		
		f_zone.Log(string.format("Game_Zone_OnGameEvent event:%s oldevent:%s \n",f_zone.EventName(nEvent),f_zone.EventName(s_game.event)))
		
		if t_login == nEvent then
			--f_zone.DoLogin(param1,param2)
		elseif t_connect == nEvent then
		elseif t_close == nEvent then
		elseif t_create == nEvent then
			--f_zone.DoCreate(param1)
		elseif t_enter == nEvent then
			f_zone.DoEnter(param1)
		elseif t_leave == nEvent then
			f_zone.DoLeave(param1)
		elseif t_load == nEvent then
			f_zone.DoLoad(param1,param2,param3,param4)
		elseif t_save == nEvent then
			f_zone.DoSave(param1,param2,param3)
		elseif t_lua == nEvent then
			f_zone.DoLua(param1)
		end
	end
end

-- 回调外部模块
function Game_Zone_OnGameEventCallBack(nEvent,nErrorCode,param1,param2,param3,param4)
	if nErrorCode == GZone_Error_TypeDef.Error_Event then
		if nEvent == GZone_Event_TypeDef.Lua then
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,3,hVar.tab_string["RSDYZ_WAIT1"]..param1..hVar.tab_string["RSDYZ_WAIT2"])
		else
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,3,hVar.tab_string["RSDYZ_WAIT1"]..nEvent..hVar.tab_string["RSDYZ_WAIT2"])
		end
		return
	end
	
	if nEvent == GZone_Event_TypeDef.Load then
	--print(nEvent,nErrorCode,param1,param2,param3,param4)
		if hGlobal.UI.SelectedLevelFram then
			hGlobal.UI.SelectedLevelFram:show(0)
		end

		if hGlobal.WORLD.LastWorldMap then
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
		end
		hApi.clearCurrentWorldScene()
		if nErrorCode == 0 then
			if WdldRoleId ~= luaGetplayerDataID() then
				xlLoadGame(xlSetSavePath("online"), tostring(WdldRoleId),hVar.SAVE_DATA_PATH.MY_CITY,hVar.PLAY_MODE.OTHER_LAND)
			else
				xlLoadGame(xlSetSavePath("online"),g_curPlayerName,hVar.SAVE_DATA_PATH.MY_CITY)
			end
		else
			--xlScene_LoadMap(g_world,"world/level_wdld",3)
		end
		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
		--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
	elseif nEvent == GZone_Event_TypeDef.Close then
		if nErrorCode == 0 then
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,2,hVar.tab_string["RSDYZ_ERROR"]..hVar.tab_string["RSDYZ_NO_NETWORK"])
		elseif nErrorCode == 1 then
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_NO_NETWORK2"],0)
		elseif nErrorCode == ServerNoConn then
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_NO_NETWORK2"],0)
		elseif nErrorCode == NoNetWork then
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_NO_NETWORK1"],0)
		else
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_NO_NETWORK2"],0) -- other net error
		end
	elseif nEvent == GZone_Event_TypeDef.Save then
		--local w = hGlobal.WORLD.LastWorldMap
		--if w.data.roundcount==0 then
			--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
		--end
		if nErrorCode == 0 then
			g_WDLD_Attr = param4
			print("!!!!",g_WDLD_Attr)
			if g_WDLD_Attr == -1 then
				hGlobal.event:event("LocalEvent_WDLD_prepared_ok",0)
			else
				hGlobal.event:event("LocalEvent_WDLD_prepared_ok",1)
			end
		end
	elseif nEvent == GZone_Event_TypeDef.Enter then
		if nErrorCode == 0 then
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetHeroInfo,luaGetplayerDataID()})
		else
			print("REGEHEHRRRRRRT")
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_ERROR"]..hVar.tab_string["RSDYZ_ErrorCode"..nErrorCode].."-"..nErrorCode)
		end
	elseif nEvent == GZone_Event_TypeDef.Lua then
		if nErrorCode == 0 then
			local id = param1
			local param_table = param2
			if id == GZone_Event_TypeDef.GetZoneData then
				local points = 0
				local coins = 0
				local battle_gongxian = 0
				for i = 1,#param_table do
					print("***1231231231****",i,param_table[i],"\n")
					--f_zone.Log(string.format("Game_Zone_OnGameEventCallBack GetZoneData i:%d v:%d\n",i,param_table[i]))
					if i == GZone_Event_DataDef.IRON then
						--WDLD_Init_Data.IRON = param_table[i]
					--elseif i == GZone_Event_DataDef.WOOD then
						--WDLD_Init_Data.WOOD = param_table[i]
					--elseif i == GZone_Event_DataDef.FOOD then
						--WDLD_Init_Data.FOOD = param_table[i]
					--elseif i == GZone_Event_DataDef.GOLD then
						--WDLD_Init_Data.GOLD = param_table[i]
					--elseif i == GZone_Event_DataDef.STONE then
						--WDLD_Init_Data.STONE = param_table[i]
					--elseif i == GZone_Event_DataDef.CRYSTAL then
						--WDLD_Init_Data.CRYSTAL = param_table[i]
					--elseif i == GZone_Event_DataDef.LV then
						--WDLD_Init_Data.LV = param_table[i]
					--elseif i == GZone_Event_DataDef.EXP then
						--WDLD_Init_Data.EXP = param_table[i]
					--elseif i == GZone_Event_DataDef.MAP_NAME then
						--g_WDLD_RESTART_MAP_NAME = param_table[i]
					--elseif i == GZone_Event_DataDef.OFFICAL_STR then
						--WDLD_HERO_OFFICAL_EXP_STR = {}
						--local strt = hApi.Split(param_table[i],";")
						--for i = 1,#strt do
							--local id = tostring(tonumber(string.sub(strt[i],1,5)))
							--local sor = tonumber(string.sub(strt[i],6,10))
							--WDLD_HERO_OFFICAL_EXP_STR[id] = sor
						--end
						----for k,v in pairs(WDLD_HERO_OFFICAL_EXP_STR) do
							----print(k,v)
						----end
					--elseif i == GZone_Event_DataDef.OFFICAL_SET then
						--WDLD_HERO_OFFICAL_SET = param_table[i]
					elseif i == GZone_Event_DataDef.REST_TIMES then
						points = param_table[i]
					elseif i == GZone_Event_DataDef.RSDYZ_COIN then
						coins = param_table[i]
					elseif i == GZone_Event_DataDef.RSDYZ_BATTLE_GONG_XIAN then
						battle_gongxian = param_table[i]
						--print("battle gx",battle_gongxian)
					end
				end	
				hGlobal.event:event("LocalEvent_SetRsdyzPointsAndCoin",points,coins,battle_gongxian)
				local num = 4
				if g_phone_mode == 1 or g_phone_mode == 2 then
					num = 3
				end
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetBattleSummary_Fire,luaGetplayerDataID(),num})
			elseif id == GZone_Event_TypeDef.GetHeroInfo then
				local t = param_table
				--print("1111",#param_table)
				for i = 1,#param_table-1,2 do
					print(param_table[i],param_table[i+1],"griiiiiii","\n")
					hGlobal.event:event("LocalEvent_RsdyzDefExp",param_table[i],param_table[i+1])
				end
				
				if g_RSDYZ_BattleID == 0 then
					--g_WDLD_Attr = param1
					
					--if g_Game_Zone.ZoneTemplate == nil then
						--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneTemplate,luaGetplayerDataID()})
					--else
						--if g_WDLD_Attr == -1 then
							--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),luaGetplayerDataID(),g_ReadyCitySave,xlSetSavePath("online")..g_curPlayerName..hVar.SAVE_DATA_PATH.MY_CITY)
						--elseif g_WDLD_Attr == 0 then
							--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.WDLDRestart,luaGetplayerDataID(),g_WDLD_RESTART_MAP_NAME})
						--else
							--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),luaGetplayerDataID(),g_BuildingCitySave,xlSetSavePath("online")..g_curPlayerName..hVar.SAVE_DATA_PATH.MY_CITY)
						--end
					--end

					--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetBattleSummary_Fire,luaGetplayerDataID(),5})
					--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetBattleSummary_Fire_defence,15,5})
					hGlobal.event:event("LocalEvent_ShowRsdyzInfoFrm",1)
					hGlobal.event:event("LocalEvent_RSDYZ_CleanAll")
					hGlobal.event:event("LocalEvent_ShowMapAllUI",false)
					--hGlobal.event:event("LocalEvent_SetGGZJInfo",param1[1])
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetNotice})
				else
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleBegin_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				end
			elseif id == GZone_Event_TypeDef.ServerScript then
				for i = 1,#param_table do
					print("ServerScript: p[" .. i .. "]=" .. tostring(param_table[i]))
				end
			elseif id == GZone_Event_TypeDef.WDLDRestart then
				g_WDLD_Attr = 0
				g_WDLD_RB = 1
				g_WDLD_ADD_RES = 0
				for i = 1,#param_table do
					--print("**",i,param_table[i])
					--f_zone.Log(string.format("Game_Zone_OnGameEventCallBack GetZoneData i:%d v:%d",i,param_table[i]))
					if i == GZone_Event_ReStart.IRON then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.IRON,param_table[i])
						WDLD_Init_Data.IRON = param_table[i]
					elseif i == GZone_Event_ReStart.WOOD then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.WOOD,param_table[i])
						WDLD_Init_Data.WOOD = param_table[i]
					elseif i == GZone_Event_ReStart.FOOD then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.FOOD,param_table[i])
						WDLD_Init_Data.FOOD = param_table[i]
					elseif i == GZone_Event_ReStart.GOLD then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD,param_table[i])
						WDLD_Init_Data.GOLD = param_table[i]
					elseif i == GZone_Event_ReStart.STONE then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.STONE,param_table[i])
						WDLD_Init_Data.STONE = param_table[i]
					elseif i == GZone_Event_ReStart.CRYSTAL then
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.CRYSTAL,param_table[i])
						WDLD_Init_Data.CRYSTAL = param_table[i]
					elseif i == GZone_Event_ReStart.LV then
						WDLD_Init_Data.LV = param_table[i]
					elseif i == GZone_Event_ReStart.EXP then
						WDLD_Init_Data.EXP = param_table[i]
					end
				end
				if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then

					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
				end
				xlScene_LoadMap(g_world, "world/"..g_WDLD_RESTART_MAP_NAME,3)
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
			elseif id == GZone_Event_TypeDef.BattleBegin then
				g_WDLD_BeginATK = 1
				for i = 1,#param_table do
					--print(",,,,,,,",param_table[i])
					if type(param_table[i]) == "string" then
						g_WDLD_OtherOutHero = param_table[i]
						break
					end
				end
				hGlobal.event:event("LocalEvent_BattleBeginOk")
			elseif id == GZone_Event_TypeDef.BattleLog then
			elseif id == GZone_Event_TypeDef.BattleEnd then
				g_WDLD_BeginATK = 0
				for i = 1,#param_table do
					if i == GZone_WDLD_Attack_Get.WOOD then
						WDLD_ATC_GET.WOOD = param_table[i]
					elseif i == GZone_WDLD_Attack_Get.FOOD then
						WDLD_ATC_GET.FOOD = param_table[i]						
					elseif i == GZone_WDLD_Attack_Get.STONE then
						WDLD_ATC_GET.STONE = param_table[i]
					elseif i == GZone_WDLD_Attack_Get.IRON then
						WDLD_ATC_GET.IRON = param_table[i]
					elseif i == GZone_WDLD_Attack_Get.CRYSTAL then
						WDLD_ATC_GET.CRYSTAL = param_table[i]
					elseif i == GZone_WDLD_Attack_Get.GOLD then
						WDLD_ATC_GET.GOLD = param_table[i]
					elseif i == GZone_WDLD_Attack_Get.EXP then
						WDLD_ATC_GET.EXP = param_table[i]
						WDLD_Init_Data.EXP = WDLD_Init_Data.EXP + WDLD_ATC_GET.EXP
					elseif i == GZone_WDLD_Attack_Get.TIME then
						WDLD_ATC_GET.TIME = param_table[i]
					end
				end
				local oWorld = hGlobal.LocalPlayer:getfocusworld()
				if oWorld and oWorld.data.type ~= "battlefield" then
					hGlobal.event:event("LocalEvent_ShowWDLDEndFrm",1)
				else
					SHOW_WDLD_END = 1
				end
			elseif id == GZone_Event_TypeDef.GetZoneList then
				local infonum = 11
				local param_table = param2
				local listnum = #param_table / infonum
				local zonelist = {}
				local zoneindex = {}		-- 索引表通过roleid获取自己数据
				print(".......................... listnum: " .. listnum .. "\n")
				for i = 1,listnum do
					local index = (i - 1) * infonum
					local rid = param_table[index + 1]
					if (rid == s_game.id) then
						--print("xxxxxxxxxxxxxxx paichu : uid:" .. rid .. " \n")
					else
						local z = {}
						z.roleid		= param_table[index + 1]
						z.rolename	= param_table[index + 2]

						z.lv			= param_table[index + 3]
						z.exp			= param_table[index + 4]

						z.gold		= param_table[index + 5]
						z.food		= param_table[index + 6]
						z.wood		= param_table[index + 7]
						z.stone		= param_table[index + 8]
						z.iron		= param_table[index + 9]
						z.crystal	= param_table[index + 10]
						z.state_defence		= param_table[index + 11]

						zonelist[#zonelist + 1] = z
						zoneindex[z.roleid] = #zonelist
						f_zone.Log(string.format("Game_Zone_OnGameEventCallBack GetZoneList listindex:%d roleid:%d rolename:%s lv:%d exp:%d iron:%d wood:%d food:%d gold:%d stone:%d crystal:%d \n",i,z.roleid,z.rolename,z.lv,z.exp,z.iron,z.wood,z.food,z.gold,z.stone,z.crystal))
					end
				end
				g_Game_Zone.ZoneList = zonelist
				g_Game_Zone.ZoneIndex = zoneindex
				hGlobal.event:event("LocalEvent_SetPlayerRankFrame",g_Game_Zone.ZoneList,listnum)
			elseif id == GZone_Event_TypeDef.GetNotice then
				local t = param2
				hGlobal.event:event("LocalEvent_SetGGZJInfo",param2[1])
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
			elseif id == GZone_Event_TypeDef.GetHeroData then
				local param_table = param2
				local iTag = param_table[1]
				local heroList = {}
				heroList[#heroList+1] = json.decode(param_table[2])
				heroList[#heroList+1] = json.decode(param_table[4])
				heroList[#heroList+1] = json.decode(param_table[6])
				print("hero gx",param_table[3],param_table[5],param_table[7])

				hGlobal.event:event("LocalEvent_GetHeroCardData",heroList,iTag)
			elseif id == GZone_Event_TypeDef.GetDBInfo then
				rsdyzPlayerHeroSaveList = nil
				rsdyzPlayerHeroSaveList = {}
				rsdyz_playerIdAndName = nil
				rsdyz_playerIdAndName = {}
				local infonum = 3
				local param_table = param2
				local listnum = #param_table / infonum
				local zonelist = {}
				local zoneindex = {}		-- 索引表通过roleid获取自己数据

				for i = 1,listnum do
					local index = (i - 1) * infonum
					local rid = param_table[index + 1]
					local z = {}
					z.roleid		= param_table[index + 1]--luaGetplayerDataID()
					z.rolename	= param_table[index + 2]
					z.str		= param_table[index + 3]
					--print(z.roleid,z.rolename,"|||",z.str,"hhhhhhhhhhhhhh")
					zonelist[#zonelist + 1] = z
					zoneindex[z.roleid] = #zonelist
				end
				
				rsdyz_playerIdAndName = zonelist
				rsdyz_player_len = #zonelist
				if rsdyz_player_len > RSDYZ_NEED_PLAYER_LEN then
					rsdyz_player_len = RSDYZ_NEED_PLAYER_LEN
				end
				local idsT = hApi.Split(rsdyz_playerIdAndName[1].str,";")
				SendCmdFunc["send_GetHeroCardData_RSDYZ"](rsdyz_playerIdAndName[1].roleid,1,tonumber(idsT[1]),tonumber(idsT[2]),tonumber(idsT[3]))
				--end
		

			elseif id == GZone_Event_TypeDef.GetBattleSummary then
				local infonum = 13
				local param_table = param2
				local listnum = #param_table / infonum
				zone_battle_summary = {}
				for i = 1,listnum do
					local index = (i - 1) * infonum
					local z = {}
					z.offense_id	=	param_table[index + 1]
					z.offense_name	=	param_table[index + 2]
					z.defence_id	=	param_table[index + 3]
					z.defence_name	=	param_table[index + 4]
					z.round			=	param_table[index + 5]
					z.gold			=	param_table[index + 6]
					z.food			=	param_table[index + 7]
					z.wood			=	param_table[index + 8]
					z.stone			=	param_table[index + 9]
					z.iron			=	param_table[index + 10]
					z.crystal		=	param_table[index + 11]
					z.exp			=	param_table[index + 12]
					z.time_begin	=	param_table[index + 13]

					zone_battle_summary[#zone_battle_summary + 1] = z
				end
				hGlobal.event:event("LocalEvent_ShowBattleLog",1)

			elseif id == GZone_Event_TypeDef.GetZoneTemplate then
				g_Game_Zone.ZoneTemplate = nil
				local infonum = 9
				local param_table = param2
				local listnum = #param_table / infonum
				--print(".......................... zonetemplatenum: " .. listnum .. "\n")
				zone_template = {}
				for i = 1,listnum do
					local index = (i - 1) * infonum
					local z = {}
					z.exp		=	param_table[index + 1]
					z.gold		=	param_table[index + 2]
					z.food		=	param_table[index + 3]
					z.wood		=	param_table[index + 4]
					z.stone		=	param_table[index + 5]
					z.iron		=	param_table[index + 6]
					z.crystal	=	param_table[index + 7]
					z.day		=	param_table[index + 8]
					z.maplist	=	param_table[index + 9]
					zone_template[#zone_template + 1] = z
					--f_zone.Log(string.format("Game_Zone_OnGameEventCallBack GetZoneTemplate lv:%d exp:%d wood%d food:%d stone:%d iron:%d crystal:%d gold:%d day:%d maplist:%s\n",i,z.exp,z.wood,z.food,z.stone,z.iron,z.crystal,z.gold,z.day,z.maplist))
				end
				if(#zone_template > 0 and #zone_template == listnum) then
					g_Game_Zone.ZoneTemplate = zone_template
				end
				--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
				if g_WDLD_Attr == -1 then
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),luaGetplayerDataID(),g_ReadyCitySave,xlSetSavePath("online")..g_curPlayerName..hVar.SAVE_DATA_PATH.MY_CITY)
				elseif g_WDLD_Attr == 0 then
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.WDLDRestart,luaGetplayerDataID(),g_WDLD_RESTART_MAP_NAME})
				else
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),luaGetplayerDataID(),g_BuildingCitySave,xlSetSavePath("online")..g_curPlayerName..hVar.SAVE_DATA_PATH.MY_CITY)
				end
			elseif id == GZone_Event_TypeDef.BattleBegin_Fire then
				local cont = 0
				if g_RSDYZ_BattleID == 0 then
					cont = 0
				else
					cont = 1
				end
				for i = 1,#param_table do
					if i == 2 then
						g_RSDYZ_BattleID = param_table[i]
						print("get g_RSDYZ_BattleID = "..g_RSDYZ_BattleID)
					end
				end
				if cont == 1 then
					if g_RSDYZ_LastCom ~= nil then
						Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,g_RSDYZ_LastCom)
					end
				elseif cont == 0 then
					hGlobal.event:event("LocalEvent_RSDYZ_CAN_BATTLE_BEGIN")
				end
			elseif id == GZone_Event_TypeDef.BattleEnd_Fire then
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
				g_RSDYZ_BattleID = 0
			elseif id == GZone_Event_TypeDef.BattleLog_Fire then
				g_RSDYZ_LastCom = nil
			elseif id == GZone_Event_TypeDef.GetBattleSummary_Fire then
				local infonum = 11
				local param_table = param2
				local listnum = #param_table / infonum
				local act_index = 0
				for i = 1,listnum do
					act_index = act_index + 1
					local index = (i - 1) * infonum
					local z = {}
					z.battleid	=	param_table[index + 1]
					z.round	=	param_table[index + 2]
					z.offense_id	=	param_table[index + 3]
					z.offense_name	=	param_table[index + 4]
					z.defence_id			=	param_table[index + 5]
					z.defence_name			=	param_table[index + 6]
					z.time_begin			=	param_table[index + 7]
					z.type			=	param_table[index + 8]
					z.result			=	param_table[index + 9]
					z.ext			=	param_table[index + 10]
					z.getcoin		=	param_table[index + 11]
					hGlobal.event:event("LocalEvent_SetRSDYZActInfo",z,act_index)
				end
				hGlobal.event:event("LocalEvent_SetRSDYZActInfoLast")
				--hGlobal.event:event("LocalEvent_ShowBattleLog",1)
			elseif id == GZone_Event_TypeDef.GetBattleSummary_Fire_defence then
				local infonum = 11
				local param_table = param2
				local listnum = #param_table / infonum
				--fire_battle_summary_def = {}
				local def_index = 0
				for i = 1,listnum do
					def_index = def_index + 1
					local index = (i - 1) * infonum
					local z = {}
					z.battleid	=	param_table[index + 1]
					z.round	=	param_table[index + 2]
					z.offense_id	=	param_table[index + 3]
					z.offense_name	=	param_table[index + 4]
					z.defence_id			=	param_table[index + 5]
					z.defence_name			=	param_table[index + 6]
					z.time_begin			=	param_table[index + 7]
					z.type			=	param_table[index + 8]
					z.result			=	param_table[index + 9]
					z.ext			=	param_table[index + 10]
					z.getcoin		=	param_table[index + 11]
					hGlobal.event:event("LocalEvent_SetRSDYZDefInfo",z,def_index)
				end
			elseif id == GZone_Event_TypeDef.Shop then
				hGlobal.event:event("LocalEvent_CleanRsdyzPointsAndCoin")
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
			end
		else
			local id = param1
			if id == GZone_Event_TypeDef.GetBattleSummary_Fire or id == GZone_Event_TypeDef.GetBattleSummary_Fire_defence then
				if nErrorCode == 103 then
					hGlobal.event:event("LocalEvent_ShowBattleLog",0)
				end
			else
				if nEvent == GZone_Event_TypeDef.Lua then
					hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_ERROR"]..hVar.tab_string["RSDYZ_ErrorCode"..nErrorCode].."-"..nErrorCode.."-"..param1)
				else
					hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_ERROR"]..hVar.tab_string["RSDYZ_ErrorCode"..nErrorCode].."-"..nErrorCode.."-"..nEvent)
				end
			end
		end
	end
end

hGlobal.event:listen("LocalEvent_GetHeroCardData","Griffin_GetHeroCardData",function(heroList,tg)
	rsdyzPlayerHeroSaveList[#rsdyzPlayerHeroSaveList + 1] = heroList
			
	if tg >= rsdyz_player_len then
		if hGlobal.WORLD.LastWorldMap then
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
		end
				--_childUI["world/level_hdmj"]:setstate(1)
		hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm",0)
		hGlobal.event:event("LocalEvent_ShowRsdyzInfoFrm",0)
		xlScene_LoadMap(g_world, "world/level_hdmj",3)

				--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
	else
		--SendCmdFunc["send_GetHeroCardData"](rsdyz_playerIdAndName[tg+1].roleid,tg+1)
		local idsT = hApi.Split(rsdyz_playerIdAndName[tg+1].str,";")
		SendCmdFunc["send_GetHeroCardData_RSDYZ"](rsdyz_playerIdAndName[tg+1].roleid,(tg+1),tonumber(idsT[1]),tonumber(idsT[2]),tonumber(idsT[3]))
	end
end)
]]