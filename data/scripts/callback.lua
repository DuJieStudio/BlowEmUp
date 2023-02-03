--TD模式寻路
xlEnableTD(1)

g_newui_switch = 1 

-------------------------------------------------
-------------------------------------------------
-- the main entrance of game's callback functions
-------------------------------------------------
g_localfilepath	= nil	--游戏本地路径
g_curPlayerName = nil
g_lastPlayerName = nil

g_channel_world = 0
g_channel_battle = 1
g_channel_town = 1
g_battleBMGCount = 0

g_world			= nil
g_battlefield		= nil
g_town			= nil
g_loading		= nil
g_mainmenu		= nil
g_chooselevel		= nil	--选关界面
--g_playerlist		= nil	--玩家信息查看
--g_PVP			= nil	--PVP的场景

phone_Mainmenu		= nil	--手机版主界面
phone_SelectLevel	= nil	--手机版关卡选择界面


g_game_mode		= nil	--当前的游戏模式 部分UI 按钮逻辑需要

g_startmaptime = 1

g_current_scene		= nil
g_last_scene		= nil
g_map_on_scene		= {}	--记录了scene上的oWorld或oMap

--win_update		= nil  --更新界面

win_date		= nil  --日期界面， 负责显示日期， 结束回合等
win_sys			= nil  --系统菜单
win_selectmap		= nil  --loading界面选地图
win_heroinfo		= nil  --英雄信息查看
win_reward		= nil

win_logo		= nil  --公司logo

win_savegame		= nil
win_loadgame		= nil

g_ai_distance_type = 1  -- 0表示使用直线距离  1使用寻路获得的步数

g_buttons_handle = {}
g_buttons = {}

g_game_days		= 0	--当前游戏局进行天数
g_button_mapname	= nil

g_bCanLogAi		= true

g_newui_switch		= 0	--控制是否使用新UI的开关

g_FPSUI_show		= 0	--控制是否显示FPS

g_phone_mode		= 0	--是否是手机模式

g_WorldMusicMode	= 1	--每次新加载世界地图的时候，将此变量置为1

g_DisableShowOption	= 0	--禁止弹出设置界面 

g_BuyLifeState		= 0	--复活的界面不需要取消暂停

--g_Cur_Language = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_language")
--if g_Cur_Language == 0 then g_Cur_Language = 1 end

g_tTargetPlatform = {kTargetWindows = 0,kTargetLinux = 1,kTargetMacOS = 2,kTargetAndroid = 3,kTargetIphone = 4,kTargetIpad = 5,kTargetBlackBerry = 6}


--测试员、管理员的标记(0:外网玩家 / 1:测试员 / 2:管理员）
g_is_account_test = 0

--服务器时间
g_systime = 0 --zhenkira: 服务器的时间
g_localDeltaTime = 0 --客户端的时间和服务器的时间误差(Local = Host + deltaTime)

--pvp服务器时间
g_systime_pvp = 0 --pvp服务器的时间（字符串）
g_localDeltaTime_pvp = 0 --pvp客户端的时间和服务器的时间误差(Local = Host + deltaTime)
g_lastDelay_pvp = -1 --pvp当前延时

--邮件提醒叹号
g_mailNotice = 0

--pvp我的基础信息
g_myPvP_BaseInfo =
{
	id = 0, --内存id
	dbId = 0, --数据库id
	rId = 0, --当前使用的角色Id
	
	winE = 0, --用户娱乐房胜场
	loseE = 0, --用户娱乐房败场
	drawE = 0, --用户娱乐房平局
	errE = 0, --用户娱乐房异常场
	escapeE = 0, --用户娱乐房逃跑场
	outsyncE = 0, --用户娱乐房不同步场
	evaluateE = 0, --用户娱乐模式累计星星评价
	totalE = 0, --用户娱乐房总场
	total = 0, --用户所有房间总场
	
	winM = 0, --用户匹配房胜场
	loseM = 0, --用户匹配房败场
	drawM = 0, --用户匹配房平局
	errM = 0, --用户匹配房异常场
	escapeM = 0, --用户匹配房逃跑场
	outsyncM = 0, --用户匹配房不同步场
	totalM = 0, --用户匹配房总场
	
	escapePunishTime = 0, --逃跑惩罚时间(单位:秒)
	punishCount = 0, --逃跑惩罚次数累加
	lastPunishTime = 0, --上一次惩罚时间(数值)
	
	--escapePunishTime1 = 0, --投降惩罚时间(单位:秒)
	punishCount1 = 0, --投降惩罚次数累加
	lastPunishTime1 = 0, --上一次投降时间(数值)
	
	coppercount = 0, --开过的铜宝箱总量
	silvercount = 0, --开过的银宝箱总量
	goldcount = 0, --开过的金宝箱总量
	chestexp = 0, --总经验值
	arenachest = 0, --擂台赛锦囊的当前数量
	
	gamecoin = 0, --游戏币
	pvpcoin = 0, --兵符
	pvpcoin_last_gettime = "2016-01-01 00:00:00", --兵符每日领取上一次领取时间
	chestList = {}, --宝箱
	freechest = {}, --免费宝箱
	tacticInfo = {}, --兵符碎片
	heroInfo = {}, --英雄将魂碎片
	
	arenaRecent = {}, --娱乐房最近10场的数据
	matchRecent = {}, --匹配房最近10场的数据
	
	updated = 0, --是否是最新的数据
}

--pvp统计信息
g_pvpStatisticsInfo =
{
	herocard = {}, --最近使用的英雄卡
	towercard = {}, --最近使用的塔卡
	tacticcard = {}, --最近使用的兵种卡
	tokenCost = 0, --总的兵符消耗
	tokenWinnerCost = 0, --总游戏局数
	totalSession = 0,  --总的胜利者兵符消耗
}

--无尽地图开始的时间（字符串）（北京时区）
g_endlessBeginTime = 0

g_dailyQuestInfo = nil --zhenkira:日常任务信息

g_shop_control = 0	--zhenkira: 商店版本号（可以使用商店的最低脚本版本号）
g_version_control = 0	--zhenkira: 客户端脚本控制版本号（可以使用转档的最低脚本版本号）
g_pvp_control = 0 --zhenkira: pvp客户端脚本版本控制（可以使用pvp的最低脚本版本号）

g_loginDays = 0 --服务器存储的登入的天数

--月卡状态和月卡剩余天数
--g_monthcard_state = 0
g_monthcard_leftdays = 0
g_monthcard_freeticetcount = 0 --今日已使用月卡强化免费次数

--竞技场测试期间，竞技场娱乐房关闭的服务器时间戳(300活动)
g_pvp_room_begintime = 0
g_pvp_room_closetime = 0
g_pvp_room_title = "暂无"
g_pvp_room_describe = "暂无"

--竞技场测试期间，竞技场按钮开关的服务器时间戳(301活动)
g_pvp_button_begintime = 0
g_pvp_button_closetime = 0
g_pvp_button_open = 0 --是否开放竞技场按钮
g_pvp_openTime = --PVP各个房间开放时间段(每日可配置多个时间段)
{
	--竞技场
	normal = {
		{beginTime = "12:00:00", endTime = "12:59:59",},
		{beginTime = "19:00:00", endTime = "20:59:59",},
	},
	
	--娱乐房
	arena = {},
}

--藏宝图、高级藏宝图数量
g_cangbaotu_normal_num = 0
g_cangbaotu_high_num = 0

local _vs = tostring(xlGetExeVersion())
g_vs_number = tonumber(string.sub(_vs,2,4))
g_next_vs_number = 14		--更新时为了避免一些问题 在新版本上 关闭部分功能
g_last_vs_number = g_vs_number - 1
if type(language_config)=="table" then
	g_TTF_App = language_config[g_language_setting][4]
else
	g_TTF_App = "coh_2018"
end

function xlUI_AddWindowButton(window, win_x, win_y, button_uid, button_w, button_h, button_image)
	g_buttons[button_uid] = xlUI_CreateButton(button_w, button_h, button_image, 0 ,1)
	xlUI_AddButton(window, g_buttons[button_uid], win_x, win_y)

	return g_buttons[button_uid]
	--eg: xlUI_AddWindowButton(win_sys, 10, 10, "opt_fog", 40, 40, "data/image/fog.png")
end

--中文版背景图
local tempBackground = {
	[1] = "other/loading",
	--[2] = "other/loading2",
}

--英文版背景图
local tempBackground_en = {
	[1] = "other/loading_en",
	--[2] = "other/loading2",
}

local __SCENE__CName2LuaName = {
	["world"] = "worldmap",
}
local __SCENE__LuaName2CName = {
	["worldmap"] = "world",
}

function xlScene_GetLuaName(scene)
	local scene_name = xlScene_GetName(scene)	--为什么要这样写呢，因为程序管脚本的worldmap叫world，似乎已经改不掉了
	return __SCENE__CName2LuaName[scene_name] or scene_name
end

function xlScene_LuaName2CName(scene_name)
	return __SCENE__LuaName2CName[scene_name] or scene_name
end

function xlScene_CreateByLuaName(name, mapPath)
	local switchName = __SCENE__LuaName2CName[name] or name
	local scene = xlScene_Create(switchName)
	hGlobal.WORLD_SCENE[name] = scene
	hGlobal.WORLD_LAYER[name] = xlScene_ToLayer(scene)
	hGlobal.WORLD_LAYER[scene] = hGlobal.WORLD_LAYER[name]
	print("创建scene",switchName,hGlobal.WORLD_SCENE[name],hGlobal.WORLD_LAYER[name])
	return scene
end

if g_lua_src == 1 then
	--xlGetChannelId = function()
		--return 1
	--end
end

--因为并不存在这个接口所以写个脚本的先顶着
function xlReleaseResourceFromPList(sPath)
	if hApi.FileExists(sPath) then
		--[[
		--geyachao: 调试代码专用弹框
		--测试 --test
		local strText = "释放plist: sPath=" .. tostring(sPath)
		hGlobal.UI.MsgBox(strText,{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		]]
		
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(sPath)
	end
end

--创建世界地图的时候调用这个接口加载必要的资源
function xlLoadPlistForWorldMap(sMapName)
	xlLoadResourceFromPList("data/xlobj/xlobjs.plist")
	xlLoadResourceFromPList("data/xlobj/xlobjs_water.plist")
	local tResourceEx = hVar.MAP_RESOURCE_EX[sMapName]
	if type(tResourceEx)=="table" then
		for i = 1,#tResourceEx do
			xlLoadResourceFromPList(tResourceEx[i])
		end
	end
end

--删除世界地图的时候调用这个接口释放必要的资源
function xlReleasePlistForWorldMap(sMapName)
	xlReleaseResourceFromPList("data/xlobj/xlobjs.plist")
	xlReleaseResourceFromPList("data/xlobj/xlobjs_water.plist")
	local tResourceEx = hVar.MAP_RESOURCE_EX[sMapName]
	if type(tResourceEx)=="table" then
		for i = 1,#tResourceEx do
			xlReleaseResourceFromPList(tResourceEx[i])
		end
	end
end

--收到内存警告后，尝试释放一些内存
local __G__MemoryWarningCount = 0
function LowMemoryWarning()
	--geyachao: 战车不释放内存了
	--[[
	xlLG("error", "Get Low Memory Wanring!\n")
	__G__MemoryWarningCount = __G__MemoryWarningCount + 1
	--hGlobal.event:event("LocalEvent_LowMemoryWarning")
	--管他嘞，先释放掉吧,不然就闪退了
	local oWorld = hGlobal.NetBattlefield
	--在PVP战场里面收到这个消息的时候，就直接
	if oWorld~=nil and hGlobal.LocalPlayer:getfocusworld()==oWorld then
		xlReleaseResourceFromPList("data/xlobj/xlobjs.plist")
		xlReleaseResourceFromPList("data/xlobj/xlobjs_water.plist")
		xlReleaseResourceFromPList("data/xlobj/xlobjs_sea_battle.plist")
	end
	hGlobal.event:event("LocalEvent_MemoryWarning",__G__MemoryWarningCount)
	--先释放资源，在打log，不然貌似会提高闪退率
	if oWorld~=nil and hGlobal.LocalPlayer:getfocusworld()==oWorld then
		hApi.PVPSaveCmdLog(oWorld,"mem_warning:"..__G__MemoryWarningCount)
	end
	]]
end

function game_start()
	g_localfilepath = xlSetSavePath("local")	--脚本执行的第一个函数 故在此声明全局存档路径
	if Update_Data_Table == nil then
		Update_Data_Table = {IsDBConnected = 0}
	end
	
	hVar.CURRENT_ITEM_VERSION = xlUpdateGetInfo(2) or "1"
	--如果版本号中 有 \r 那么要排除 避免写文件失败
	if (type(hVar.CURRENT_ITEM_VERSION) == "string") and (string.find(hVar.CURRENT_ITEM_VERSION,"\r")) then
		hVar.CURRENT_ITEM_VERSION = string.sub(hVar.CURRENT_ITEM_VERSION,1,string.len(hVar.CURRENT_ITEM_VERSION)-1)
	end
	
	--测试 --test
	--IAPServerIP
	--version
	if (g_lua_src == 1) then --源代码模式下打开以下开关
		hVar.CURRENT_ITEM_VERSION = "2.2.121302"
	end
	
	xlLG("init", "====== game_start() ====== \n")
	local functions = {}
	local nProgress = 0
	local AppendGameStartFunc = function(pCode)
		local nIndex = #functions + 1
		functions[nIndex] = function()
			pCode()
			return math.floor(100*nIndex/#functions)
		end
	end
	
	AppendGameStartFunc(function()
		xlLoadTerrainResource()
		if (xlLoadResourceFromPList ~= nil) then  --新的005版及以上的程序，支持此接口, 加载xobj资源放入脚本内控制
			--xlobjs使用非pot对齐，但水物件还必须独立出来，保持pot对齐， 所以还是分离成2个xlobjs文件
			--xlLoadResourceFromPList("data/xlobj/xlobjs.plist");			--已经移动到第一次加载地图的地方
			--xlLoadResourceFromPList("data/xlobj/xlobjs_water.plist");		--已经移动到第一次加载地图的地方
			--local sprite_ui = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("data/image/ui/xxxx.png")
			
			--加载 ui.plist
			xlLoadResourceFromPList("data/image/ui.plist")
			--print("加载 ui.plist")
			--[[
			local texture_ui = CCTextureCache:sharedTextureCache():textureForKey("data/image/ui.png")
			if texture_ui then
				texture_ui:retain()
			end
			]]
			
			--[[
			--加载 pvp.plist
			--是否通关"剿灭黄巾"
			local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap9 == 1) then
				xlLoadResourceFromPList("data/image/misc/pvp.plist")
				print("加载 pvp.plist")
			end
			]]

			--[[
			local texture_pvp = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/pvp.pvr.ccz")
			if texture_pvp then
				texture_pvp:retain()
			end
			]]
			
			--if hVar.OPTIONS.SEA_BATTLE and hVar.OPTIONS.SEA_BATTLE == 1 then
				--xlLoadResourceFromPList("data/xlobj/xlobjs_sea_battle.plist");--已移动到第一次加载海战的地方
			--end
			--xlLoadResourceFromPList("data/xlobj/xlobjs_lobby.plist")
		end
		
	end)
	AppendGameStartFunc(function()
		if hClass then
			local tempList = {
				"player",
				"action",
				"effect",
				"hero",
				"item",
				"map",
				"player",
				"round",
				"sceobj",
				"town",
				"unit",
				"world",
			}
			for k,v in pairs(tempList) do
				if hClass[v] == nil then
					local errStr = tostring(xlPlayer_GetUID()).."-"..hVar.CURRENT_ITEM_VERSION.."- game.so init erro".."-"..v
					xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,110).."-T:"..tostring(os.date("%m%d%H%M%S")))
					xlUI_Show(Erro_Frm.Main_Game,1)
					return "erro"
				end
			end
			
		else
			local errStr = tostring(xlPlayer_GetUID()).."-"..hVar.CURRENT_ITEM_VERSION.."- game.so init erro".."-hClass"
			xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,110).."-T:"..tostring(os.date("%m%d%H%M%S")))
			xlUI_Show(Erro_Frm.Main_Game,1)
			return "erro"
		end

		--创建所有玩家
		hGlobal.LocalPlayer = hClass.player:new({
			name = "player_1",
			playerId = 1,
		})
		--[[
		--大菠萝数据初始化
		hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		]]
		
		--hGlobal.LocalPlayer:setlocalplayer(1)
		
		
		----创建所有玩家
		--hClass.player:new({
		--	name = "creature",
		--	playerId = 0,
		--})
		--hClass.player:new({
		--	name = "creature_enemy",
		--	playerId = -1,
		--})
		--for i = 1,hVar.MAX_PLAYER_NUM do
		--	hClass.player:new({
		--		name = "player_"..i,
		--		playerId = i,
		--		IsAIPlayer = 1,
		--	})
		--end
		--hGlobal.NeutralPlayer = hGlobal.player[0]			--中立
		--hGlobal.LocalPlayer = hGlobal.player[1]				--设置为本地player
		--hGlobal.EnemyPlayer = hGlobal.player[2]				--敌方
		--hGlobal.LocalPlayer:setlocalplayer(1)				--开启此玩家为localplayer
		--hGlobal.player[9].data.IsAIPlayer = 0				--不是AI
		--
		----设置基本的盟友关系
		--hGlobal.player[1]:setally(hGlobal.player[8])			--玩家1和8结盟(AI)，这样可以对话
		--for i = 1,8 do
		--	hGlobal.player[9]:setally(hGlobal.player[i])		--玩家9和所有玩家结盟(傻子)，这样可以对话
		--end	
	end)
	AppendGameStartFunc(function()
		g_world				= xlScene_CreateByLuaName("worldmap")
		g_town				= xlScene_CreateByLuaName("town")
		g_battlefield			= xlScene_CreateByLuaName("battlefield")
		g_loading			= xlScene_CreateByLuaName("loading")
		g_mainmenu			= xlScene_CreateByLuaName("mainmenu")
		g_chooselevel			= xlScene_CreateByLuaName("chooselevel")
		--g_playerlist			= xlScene_CreateByLuaName("playerlist")
		g_PVP				= xlScene_CreateByLuaName("pvp")
		
		xlScene_SetViewMovable(g_town,1)
		xlScene_EnableFillScreen(g_mainmenu,1)
		xlScene_SetViewMovable(g_chooselevel,1)
		
		if g_phone_mode == 1 then
			xlScene_EnableFillScreen(g_loading,1)
		end
		
		xlScene_EnableScale(g_world,0)
		
		xlScene_EnableScale(g_chooselevel,0)
		xlScene_EnableScale(g_PVP,0)
		xlScene_EnableScale(g_town,0)
		xlScene_EnableScale(g_battlefield,0)
		
		xlSetGameScenes(g_world, g_battlefield, g_town)
		
		--TD滑屏判定距离
		xlSetTouchOffset(50)
	end)
	AppendGameStartFunc(function()
		hUI.InitUISystem()		--加载脚本UI底层系统	
		init_game_ui()			--加载基于c++的所有游戏ui界面
		--xlLuaEvent_EnableAI(1)
	end)
	local tFunc = UI_Init()		--加载基于脚本系统的所有游戏ui界面, 内部会加载大量美术资源
	if type(tFunc)=="table" then
		for i = 1,#tFunc do
			if type(tFunc[i])=="function" then
				AppendGameStartFunc(tFunc[i])
			end
		end
	elseif type(tFunc)=="function" then
		AppendGameStartFunc(tFunc)
	end
	AppendGameStartFunc(function()
		local list = tempBackground
		if g_Cur_Language >= 3 then
			list = tempBackground_en
		end
		local r = hApi.random(1,#list)
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			list = g_Background_vertical
			r = g_Background_Index
		end
		
		local bgName = list[r]
		--xlScene_LoadMap(g_loading,			bgName)
		--xlScene_LoadMap(g_playerlist,			"other/loading")
		xlScene_SetPathGridSize(24)			--设置寻路格子的大小
	end)
	
	AppendGameStartFunc(function()
		if 1 == g_editor then
			enter_game("editor")
		elseif 1 == g_lua_src then
			enter_game("local")
		end
	end)
	
	if type(Update_Data_Table) == "table" and true == Update_Data_Table.RunGameStart then
		return functions
	else
		for i = 1,#functions do
			functions[i]()
		end
	end
	
end

--按照不同模式进入游戏, 编辑器模式， 单机模式， 联网模式
function enter_game(game_mode, param)
	--print("enter_game mode:" .. game_mode .. " param:" .. tostring(param))
	g_game_mode = game_mode
	--根据当前脚本号对 道具版本号进行初始化，如果返回nil 则赋值1
	
	--断开更新服务器的连接
	xlUpdateEvent(444)
	
	hApi.CheckLanguage()
	hApi.ChangeLanguage()
	hApi.ReadLocalFile()
	
	hApi.addTimerOnce("GameStartBGMusic",1,function()
		hApi.EnableSoundBG(hVar.OPTIONS.PLAY_SOUND_BG)
		--geyachao: 不重复加载同一个背景音乐
		if (hApi.GetPlaySoundBG(g_channel_town) ~= "main_theme") then
			--hApi.PlaySound("eff_bless")
			hApi.PlaySoundBG(g_channel_town, "main_theme")
		end
		--print("main_theme 1")
	end)

	if g_Background_Index == nil then
		math.randomseed(os.time())
		local rand = math.random(1,10000)
		g_Background_Index = rand % #g_Background_vertical + 1
		--g_Background_Index = 2
		print("g_Background_Index",g_Background_Index,#g_Background_vertical,rand)
	end

	if game_mode=="editor" then 
		--为world scene加载地图, 内部会使用进度条并且自动切换到world_scene
		xlScene_LoadMap(g_world, hVar.DEFAULT_EDITOR_WORLDMAP) 
		xlLoadEditorWindow()
		xlScene_SetViewMovable(g_town,1)
		--xlScene_SetBound(g_town,-1500,750,1500,0)
	elseif game_mode=="local" then
		--print("\n\n\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ enter_game $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\n\n")
		--xlScene_Switch(g_playerlist)
		xlLoadPlayerInfo(g_localfilepath,game_mode)
		hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
	elseif game_mode=="online" then
		--g_localfilepath = xlSetSavePath("online")
		--xlScene_Switch(g_playerlist)
		--xlLoadPlayerInfo(g_localfilepath,game_mode,param)
	end 
	
	--新程序会在 执行完 wnter_game 后通知程序
	if g_vs_number > 4 then
		xlSaveIntToKeyChain("DeviceInfoSend", 0) 
		--local iChannelId = xlGetChannelId()
		--if iChannelId < 100 then
			--xlNet_ConnectToServer()
		--end
	end
	--读取玩家自定义配置
	hApi.LoadGameOptions()
	--显示内存占用小窗口
	--ShowDebugWindow(1)
end

--function xlLoadGame(filepath,gameSaverName,savetype,playmode)
--	g_Game_Agent.init(g_Game_Core.Mode_TypeDef.Local)
--	local functions = {}
--	
--	--上传存档数据
--	--Lua_SendPlayerData(gameSaverName)
--					
--	SendCmdFunc["send_RoleData"](gameSaverName,LuaGetPlayerScore())
--	--SendCmdFunc["send_DepletionItemInfo"](gameSaverName,9006)
--	
--	functions[#functions + 1] = function()
--		local rTab = nil
--		rTab = LuaGetSavedGameDetail(filepath..gameSaverName..savetype)
--		local mapname = rTab.mapname or "unknown"
--		
--		if hVar.ReSetBtnLab[mapname] then
--			mapname = hVar.ReSetBtnLab[mapname]
--		end
--		
--		xlUI_SetProgressText("LOADING... " .. mapname) --language
--		xlUI_SetProgressText(hVar.tab_string["__Loading___"] .. mapname) --language

--		hApi.UpdateMapName(mapname)
--		return 5
--	end
--	
--	functions[#functions + 1] = function()
--		--读取存档
--		print("载入世界！")
--		local oldT = __hSaveData
--		LuaLoadSavedGameData(filepath..gameSaverName..savetype)
--		if type(__hSaveData)~="table" or __hSaveData==oldT then
--			hGlobal.UI.MsgBox("加载存档失败！！！请确认存档格式是否有误",{ok=1})
--			return
--		else
--			hSaveData = __hSaveData
--		end
--		
--		return 10
--	end
--	
--	functions[#functions + 1] = function()
--		--重置全局表
--		hGlobal.WORLD = {}
--		hGlobal.player = {}
--		hClass.world:enum(function(w)
--			w:del()
--		end)
--		hResource.model:releaseCache({hVar.TEMP_HANDLE_TYPE.OBJECT_WM,hVar.TEMP_HANDLE_TYPE.UNIT_WM,hVar.TEMP_HANDLE_TYPE.EFFECT_WM})	--读取地图,清理大地图显存
--		return 15
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"player",	--加载玩家资源
--		})
--		return 25
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"world",	--读取世界地图
--		})
--		--禁止正在读取的世界创建各种obj，会引起错乱
--		hGlobal.WORLD.LastWorldMap.data.IsLoading = 2
--		if playmode ~= nil then
--			if playmode == hVar.PLAY_MODE.OTHER_LAND then
--				hGlobal.WORLD.LastWorldMap.data.playmode = hVar.PLAY_MODE.OTHER_LAND
--			end
--		end
--		return 35
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"item",		--回复item表
--		})
--		
--		return 45
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"unit",		--读取单位时重新设置拥有者
--		})
--		
--		return 55
--	end
--
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"town",		--读取城镇时将把驻守和访问英雄重新塞到城里
--		})
--		
--		return 65
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"effect",	--复原各种特效
--		})
--		return 75
--	end
--	
--	functions[#functions + 1] = function()
--		eClass:sync_load({
--		"hero",		--读取英雄时重新和单位关联
--		})
--		
--		return 85
--	end
--	
--	functions[#functions + 1] = function()
--		--读取后关掉地图读状态开关
--		hGlobal.WORLD.LastWorldMap.data.IsLoading = 0
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		oWorld:__ReadGuardFromDatToC()
--		hGlobal.event:call("Event_WorldCreated",oWorld,1)
--		oWorld:enumunit(function(oUnit)
--			local d = oUnit.data
--			if oUnit.handle._c~=nil then
--				if d.type==hVar.UNIT_TYPE.BUILDING then
--					hGlobal.event:event("Event_BuildingCreated",oUnit)
--				elseif d.type==hVar.UNIT_TYPE.UNIT or d.type==hVar.UNIT_TYPE.HERO then
--					hGlobal.event:event("Event_UnitCreated",oUnit)
--				elseif d.type == hVar.UNIT_TYPE.ITEM then
--					local oItem = oUnit:getitem()
--					hGlobal.event:call("Event_ItemCreated",oItem)
--				end
--			end
--		end)
--		LoadGameAIData(filepath,gameSaverName)
--		hApi.UpdataDate(g_game_days)--刷新界面上的时间
--		hGlobal.LocalPlayer:focusworld(oWorld)
--		
--		return 100
--	end
--	xlScene_LoadingProgress(functions)
--end

LuaGetSavedGameDetail = function(path)
	local rTab = {
		day = 1,
		mapname = "",
		save_version = 0,
		mapUniqueID = 0,
		userID = 0,
		map = 0,
	}
	--从存档的头文件中获取 地图名字和 游戏天数
	--不加密
	--local f = io.open(path,"r")
	--local temp1 = f:read("*l")
	--local temp2 = f:read("*l")
	--f:close()
	--local tempName = tostring(string.sub(temp1,3,string.len(temp1)))
	--local tempDay = tonumber(string.sub(temp2,3,string.len(temp2)) or 0)
	--rTab.mapname = hVar.MAP_INFO[tempName].name or tempName
	--rTab.day = tempDay
	
	--从存档的头文件中获取 地图名字和 游戏天数
	--加密
	if hApi.FileExists(path) then
		local s = {xlLoadGameData(path,5,0)}
		if type(s[1])=="string" then
			local tempName = tostring(string.sub(s[1],3,string.len(s[1])))
			tempName = SaveModifyFunc["mapName"](tempName)
			if hVar.MAP_INFO[tempName] then
				rTab.mapname = hVar.MAP_INFO[tempName].name or tempName
			else
				rTab.mapname = tempName
			end
			rTab.map = tempName
		end
		if type(s[2])=="string" then
			local tempDay = tonumber(string.sub(s[2],3,string.len(s[2])) or 0)
			rTab.day = tempDay
		end
		if type(s[3])=="string" then
			local tempversion = tonumber(string.sub(s[3],3,string.len(s[3])) or 0) 
			rTab.save_version = (tempversion or 0)
		end
		if type(s[4])=="string" then
			local mapUniqueID = tonumber(string.sub(s[4],3,string.len(s[4])) or 0) 
			rTab.mapUniqueID = (mapUniqueID or 0)
		end
		if type(s[5])=="string" then
			local userID = tonumber(string.sub(s[5],3,string.len(s[5])) or 0) 
			rTab.userID = (userID or 0)
		end
	end
	
	return rTab
end

LuaSaveGameData = function(path,tab)
	--不加密的存档模式
	--local f = io.open(path,"w")
	--for i = 1,#tab do
		--f:write(tab[i])
	--end
	--f:close()
	
	--加密的存档模式
	local s = table.concat(tab)
	if type(s)=="string" then
		xlSaveGameData(path,s)
	end
end

LuaLoadSavedGameData = function(path)
	--不加密的读档模式
	--dofile(path)
	
	--加密的读档模式
	if hApi.FileExists(path) then
		xlLoadGameData(path)
		collectgarbage()
	end
end

xlScene_SaveMap = function(str,wdldSaveType)
	
	local local_id = xlPlayer_GetUID()
	local save_id = LuaGetPlayerDataUid()
	
	--存档时 进行 uid 效验
	--xlLG("fufucckk","3-local_id = "..local_id.."-save_id = "..save_id.."\n")
	if save_id ~= local_id and save_id ~= 0 and local_id ~= 0  then
		xlAppAnalysis("cheat_savefile",0,1,"info-UID:",tostring(local_id).."-SM_ID:-"..tostring(save_id).."-T:"..tostring(os.date("%m%d%H%M%S")))
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tUseOtherPlayerData"].."\n-["..save_id.."]-".."\n-["..local_id.."]-",{
			font = hVar.FONTC,
			ok = function()
				xlExit()
			end,
		})
		return
	end
	
	local buildOrReady = wdldSaveType or 0
	if str == nil then return end
	local UnitToRemove = {}
	local WorldToRemove = {}
	hClass.unit:enum(function(u)
		if u.data.IsDead==1 then
			UnitToRemove[#UnitToRemove+1] = u
		end
	end)
	hClass.world:enum(function(w)
		if w.data.type~="none" and w.data.type~="worldmap" then
			WorldToRemove[#WorldToRemove+1] = w
		end
	end)
	for i = 1,#UnitToRemove do
		local v = UnitToRemove[i]
		if v.ID>0 then
			v:del()
		end
	end
	for i = 1,#WorldToRemove do
		local v = WorldToRemove[i]
		if v.ID>0 then
			v.map = nil
			v:del()
		end
	end
	UnitToRemove = nil
	WorldToRemove = nil
	
	--保存玩家每天的积分 并把世界中的积分清空掉
	if hGlobal.WORLD.LastWorldMap.data.explock == 0 then
		--local dayscore = hGlobal.WORLD.LastWorldMap.data.dayscore or 0
		--LuaAddPlayerScore(dayscore)
		--hGlobal.WORLD.LastWorldMap.data.dayscore = 0
	else
		--锁定模式不产生积分
		--积分产生后 记录当前玩家在游戏中的积分，方便回到3天前时 重置玩家积分 避免刷 掉落积分的 BOSS
	end
	
	--保存击杀个数表
	--if hGlobal.WORLD.LastWorldMap.data.daykillcount and type(hGlobal.WORLD.LastWorldMap.data.daykillcount) == "table" then
	--	for _,v in pairs(hGlobal.WORLD.LastWorldMap.data.daykillcount) do
	--		LuaAddPlayerCountVal("killunit",v[1],v[2])
	--	end
	--	hGlobal.WORLD.LastWorldMap.data.daykillcount = {}
	--end

	SaveGameAIData(g_localfilepath,str)
	
	local daycount = 0
	if hGlobal.WORLD.LastWorldMap~=nil then
		daycount = hGlobal.WORLD.LastWorldMap.data.roundcount
	end
	
	
	hApi.AddMapUniqueID(g_curPlayerName,g_localfilepath) --地图唯一标识自+1
	local playerinfo = LuaGetPlayerData()
	local mapUniqueID = playerinfo.mapUniqueID or 0
	LuaSetPlayerListMapUniqueID(g_curPlayerName,mapUniqueID)
	local userID = xlPlayer_GetUID()
	local fuck = {
		"--"..hGlobal.WORLD.LastWorldMap.data.map.."\n",
		"--"..daycount.."\n",
		"--"..hVar.CURRENT_SAVE_VERSION.."\n",
		"--"..mapUniqueID.."\n",
		"--"..userID.."\n",
	}
	
	LuaSetSaveTitle(g_curPlayerName,hGlobal.WORLD.LastWorldMap.data.map,daycount,mapUniqueID,userID,hVar.CURRENT_SAVE_VERSION)
	
	local rTab = eClass:sync_save(fuck,"__hSaveData")
	
	LuaSaveGameData(g_localfilepath..str..hVar.SAVE_DATA_PATH.MAP_SAVE,rTab)
	--保存近3天的存档
	LuaSaveGameData(g_localfilepath..str.."autosave"..daycount..".sav",rTab)
	xlSaveFog(g_localfilepath..str.."autosave"..daycount..".fog")
	LuaAddPlayerAutoSaveName(g_curPlayerName,g_localfilepath..str.."autosave"..daycount)
	
	if hApi.FileExists(g_localfilepath..str.."autosave"..(daycount-4)..".sav","full") and hApi.FileExists(g_localfilepath..str.."autosave"..(daycount-4)..".fog","full") then
		xlDeleteFileWithFullPath(g_localfilepath..str.."autosave"..(daycount-4)..".sav")
		xlDeleteFileWithFullPath(g_localfilepath..str.."autosave"..(daycount-4)..".fog")
	end
	
	--保存玩家卡片上的英雄信息
	if hGlobal.WORLD.LastWorldMap.data.map == "world/level_yxwd" then
		LuaSaveHeroCard("YXWD")
	else
		LuaSaveHeroCard("SaveMap")
	end
	
	--垃圾回收
	if hVar.OPTIONS.AUTO_COLLECTGARBAGE==1 then
		collectgarbage()
	end
	--保存玩家表
	LuaSavePlayerList()
end

function init_game_ui()
	
	win_logo = xlUI_CreateWindow(220, 70)
	xlUI_SetImage(win_logo, "data/image/misc/xinline_logo.png")
	xlUI_SetWindowPos(win_logo, 1024 - 235,  768 - 74)
	xlUI_Show(win_logo,0)
	
	
	----日期条界面
	----------------------------------------------------------------------------------
	--有个程序接口在调用这里，所以无法删掉
	win_date = xlUI_CreateWindow(496, 110)
	--xlUI_SetImage(win_date, "data/image/ui/datebar_back.png")
	--xlUI_SetMaskImage(win_date, "data/image/ui/datebar_back.png");
	--xlUI_SetWindowPos(win_date, 1024 - 496, 0)
	xlUI_Show(win_date,0)
	
	-------------------------------------------------------------------------日期条界面
	----------------------------------------------------------------------------------
	
	
	

	
	--系统设置界面
	-----------------------------------------------------------------------------------
	win_sys	   = xlUI_CreateWindow(600, 520, 1, "")
	xlUI_SetWindowPos(win_sys, 220, 150)
	xlUI_EnableDrag(win_sys, 1)
	xlUI_SetOpaque(win_sys, 80)
	
	------------------------------------------------------------------------系统设置界面
	-----------------------------------------------------------------------------------
	
	
-- 主菜单界面
--------------------------------------------------------------------------------------------------
	win_selectmap = xlUI_CreateWindow(540, 480, 0, "")
	xlUI_SetWindowPos(win_selectmap, 270, 160)
	xlUI_SetOpaque(win_selectmap, 80)
	
	
--------------------------------------------------------------------------------------   主菜单界面
--------------------------------------------------------------------------------------------------
	
	
	
	win_update = xlUI_CreateWindow(360, 160)
	xlUI_SetWindowPos(win_update, 320, 280)
	button = xlUI_CreateButton(300, 20, "data/image/misc/s1.png", 0, 1);
	xlUI_AddButton(win_update, button, 50, 90)
	xlUI_EnableTouch(button,0)
	
	--loading 进度条窗口
	win_loading = xlUI_CreateWindow(400, 250, 0, "")
	xlUI_SetWindowPos(win_loading, hVar.SCREEN.w/2 - 200, hVar.SCREEN.h/2 + 85)
	
	--进度条背景
	button = xlUI_CreateButton(700, 82, "data/image/misc/valuebar_back.png", 0, 1);
	g_loading_progress_size = {}
	--g_loading_progress_size.width,g_loading_progress_size.height = xlUI_GetImageRect(button)
	g_loading_progress_size.width, g_loading_progress_size.height = 700, 82
	xlUI_AddButton(win_loading, button, -170, 120) --坐标
	xlUI_EnableTouch(button,0)
	
	--[[
	--文字背景图
	button = xlUI_AddWindowButton(win_loading, -147, 59, "label_bg", 680, 42, "data/image/misc/selectbg.png")
	xlUI_EnableTouch(button, 0)
	]]
	
	--logo
	if (g_phone_mode == 0) then --平板模式
		--470x133
		button = xlUI_AddWindowButton(win_loading, -314, -422, "battle_logo", 476, 138, "data/map/other/loading_logo.png")
		xlUI_EnableTouch(button, 0)
	else --手机模式
		if (g_phone_mode == 4) then --iphoneX
			--470x133
			button = xlUI_AddWindowButton(win_loading, -550, -428, "battle_logo", 476, 138, "data/map/other/loading_logo.png")
			xlUI_EnableTouch(button, 0)
		else
			--470x133
			button = xlUI_AddWindowButton(win_loading, -370, -358, "battle_logo", 476, 138, "data/map/other/loading_logo.png")
			xlUI_EnableTouch(button, 0)
		end
	end
	
	--进度条
	button = xlUI_AddWindowButton(win_loading, -170, 120, "current_progress", 700, 82, "data/image/misc/valuebar.png")
	xlUI_EnableTouch(button,0)


	win_loading_vertical = xlUI_CreateWindow(400, 250, 0, "")
	xlUI_SetWindowPos(win_loading_vertical, hVar.SCREEN.vw/2 - 110, hVar.SCREEN.vh/2 - 160)

	g_LoadingAction = {}
	g_LoadingAction.node = CCNode:create()
	xlUI_AddChild(win_loading_vertical,g_LoadingAction.node)

	--进度条背景
	button = xlUI_CreateButton(360, 82, "data/image/misc/valuebar_back.png", 0, 1);
	--g_loading_progress_size.width,g_loading_progress_size.height = xlUI_GetImageRect(button)
	g_loading_progress_size_vertical = {}
	g_loading_progress_size_vertical.width, g_loading_progress_size_vertical.height = 360, 82
	xlUI_AddButton(win_loading_vertical, button, -80, 84 - 28) --坐标
	xlUI_EnableTouch(button,0)

	--进度条
	button = xlUI_AddWindowButton(win_loading_vertical, -80, 84 - 28, "current_progress_vertical", 360, 82, "data/image/misc/valuebar.png")
	xlUI_EnableTouch(button,0)

	if g_Background_Index == nil then
		math.randomseed(os.time())
		local rand = math.random(1,10000)
		g_Background_Index = rand % #g_Background_vertical + 1
		--g_Background_Index = 3
		print("g_Background_Index",g_Background_Index,#g_Background_vertical,rand)
	end

	local btnoffx = 0
	local btnoffy = 0
	if g_Background_Index == 2 then
		btnoffx = -1
		btnoffy = 5
	elseif g_Background_Index == 3 then
		btnoffy = 12
	end

	--红色按钮
	local imgsrc = "data/image/misc/redbtn".. g_Background_Index .."_2.png"
	print("imgsrc",imgsrc)
	button = xlUI_CreateButton(170, 122, imgsrc, 0, 1);
	xlUI_AddButton(win_loading_vertical, button, 140+btnoffx, 201+btnoffy) --坐标
	xlUI_EnableTouch(button,0)
	
	--AI 行动中窗口
	win_ai_working = xlUI_CreateWindow(360, 200, 0, "data/image/misc/skillup/msgbox4.png")
	if g_phone_mode == 0 then
		xlUI_SetWindowPos(win_ai_working, 360, 550)
	else
		xlUI_SetWindowPos(win_ai_working, 360, 450)
	end
	button = xlUI_AddWindowButton(win_ai_working, 26, 30, "ai_workong_info", 0, 0, "data/image/ui/next_day.png")
	xlUI_SetButtonLabel(button, 80, 22, ("")) 
	
	local button = xlUI_CreateButton(48, 48, "data/image/misc/map_icon.png");
	
	xlUI_SetButtonLabel(button, 60, 10, "["..hVar.BUTTON_BORDER.."]")
	xlUI_AddButton(win_sys, button, 50, 400)
	g_buttons_handle[button] = function()
		hVar.BUTTON_BORDER = hVar.BUTTON_BORDER + 5
		if hVar.BUTTON_BORDER>100 then
			hVar.BUTTON_BORDER = 0
		end
		xlUI_SetButtonLabel(button, 60, 10, "["..hVar.BUTTON_BORDER.."]")
		hUI.dragBox:SetAllButtonBorder(hVar.BUTTON_BORDER)
	end
	
	xlUI_InitWindows_Date_Terrain()
	
	
	xlUI_Show(win_ai_working,	0)
	
	xlUI_Show(win_sys,			0)
	xlUI_Show(win_selectmap,	0)
	xlUI_Show(win_loading,		0)
	xlUI_Show(win_loading_vertical,		0)
	xlUI_Show(win_update,		0)
end

function xlUI_SetProgress(progress)
	--xlUI_SetImageScale(g_buttons["current_progress"], progress/100, 1)
	local lenth = progress/100 * (g_loading_progress_size.width)
	xlUI_SetImageRect(g_buttons["current_progress"],lenth,g_loading_progress_size.height)

	local lenth_vertical = progress/100 * (g_loading_progress_size_vertical.width)
	xlUI_SetImageRect(g_buttons["current_progress_vertical"],lenth,g_loading_progress_size_vertical.height)
	--print(lenth,g_loading_progress_size.height)
end

function xlUI_SetProgressText(text)
	xlUI_SetButtonLabel(g_buttons["current_progress"], -300, -60, (text), 1280, 64, 1, 1) 
end

function xlUI_SetProgressText_vertical(text)
	xlUI_SetButtonLabel(g_buttons["current_progress_vertical"], 0, -40, (text), 600, 64, 1, 1) 
end

function xlUI_CreateLoadingAction()
	g_LoadingAction.texlist = {}

	local farry = CCArray:create()
	
	local texW = 256
	local texH = 277
	for j = 1,20 do
		local pngkey = string.format("data/image/panel/update/000%02d.png",j)
		local tex = CCTextureCache:sharedTextureCache():addImage(pngkey)
		g_LoadingAction.texlist[#g_LoadingAction.texlist+1] = tex
		farry:addObject(CCSpriteFrame:createWithTexture(tex,CCRectMake(0, 0, texW, texH)))
	end
	local animation = CCAnimation:createWithSpriteFrames(farry, 0.1)
	local s = CCSprite:create()
	s:setScaleX(1.5)
	s:setScaleY(1.5)
	s:runAction(CCRepeatForever:create(CCAnimate:create(animation)))
	
	g_LoadingAction.node:addChild(s,1)
	g_LoadingAction.sprite = s
	g_LoadingAction.sprite:setPosition(ccp(100, 60))
	

	hResource.model:releasePngByKey()
end

function xlUI_ClearLoadingAction()
	if g_LoadingAction then
		if g_LoadingAction.texlist then
			for i = 1,#g_LoadingAction.texlist do
				local tex = g_LoadingAction.texlist[i]
				if tex then
					CCTextureCache:sharedTextureCache():removeTexture(tex)
				end
			end
		end
		if g_LoadingAction.sprite then
			local s = g_LoadingAction.sprite
			s:stopAllActions()
			s:getParent():removeChild(s,true)
		end
		g_LoadingAction.sprite = nil
		g_LoadingAction.texlist = nil
	end
end

function xlLoadingEvent_UpdateProgress(scene)
	if nil == g_UpdateProgressDelay then 
		g_UpdateProgressDelay = 0
	end
	if g_ProgressFunctions then
		if g_ProgressStep then
			if g_UpdateProgressDelay == 0 then
				if g_ProgressStep <= #g_ProgressFunctions then
					local curprogress = g_ProgressFunctions[g_ProgressStep]()
					if g_ProgressStep == #g_ProgressFunctions then
						g_ProgressFunctions = nil
						g_UpdateProgressDelay = nil
						if type(ui_show_ip59) == "function" then
							ui_show_ip59(0)
						end
						return
					end
					if type(curprogress) == "number" then
						if 10000 < curprogress and curprogress < 10100 then
							xlUI_SetProgress(curprogress - 10000)
						else
							xlUI_SetProgress(curprogress)
							g_ProgressStep = g_ProgressStep + 1
						end
					else
						local errStr = tostring(xlPlayer_GetUID()).."-"..hVar.CURRENT_ITEM_VERSION.."- game.so init erro".."-UpdateProgress"
						xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,110).."-T:"..tostring(os.date("%m%d%H%M%S")))
						print("出错啦:",curprogress,errStr)
						xlUI_Show(Erro_Frm.Main_Game,1)
						return
					end
				end
				g_UpdateProgressDelay = 1
			else
				g_UpdateProgressDelay = g_UpdateProgressDelay - 1
			end
		end
	end
end

function xlScene_LoadingProgress(functions)
	if type(functions) == "table" and #functions > 0 and nil == g_ProgressFunctions then
		g_ProgressFunctions = functions
		g_ProgressStep = 1
		xlUI_SetProgress(0)
		xlScene_Switch(g_loading)
		if type(ui_show_ip59) == "function" then
			ui_show_ip59(1)
		end
	end
end

--新的loadingmap流程 先把每一步打包然后由loading界面的流程统一执行
local function xlScene_LoadMap_Asynchronous(map_name, mapDiff, mapMode, session, banLimitTable)
	local functions = {}
	functions[#functions + 1] = function()
		if g_canSpinScreen == 1 then
			if type(xlGetScreenRotation) == "function" and type(xlRotateScreen) == "function" then
				--不可旋转
				if g_CurScreenMode == 1 then
					local orientation, lock_flag = xlGetScreenRotation()
					xlRotateScreen(orientation,  1)               --设置屏幕朝向以及是否锁定
				end
			end
		end
		return 1
	end

	functions[#functions + 1] = function()
		local mapname = map_name
		if hVar.MAP_INFO[map_name] then
			mapname = hVar.MAP_INFO[map_name].name
		end
		--xlUI_SetProgressText("LOADING... " .. mapname) --language
		xlUI_SetProgressText("") --language --大菠萝，不显示文字
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			xlUI_CreateLoadingAction()
		end
		--xlUI_SetProgressText_vertical(hVar.tab_string["on_loading"])
		--xlUI_SetProgressText(hVar.tab_string["__Loading___"] .. mapname) --language
		--创建玩家信息的
		--map_setting(map_name)
		print(":::::::::::::::::::::::::::::::::::::::::map_start:::::::::::::::::::::::::::::::::::::::::-2")
		return 5
	end
	
	functions[#functions + 1] = function()
		if hGlobal.WORLD.LastWorldMap~=nil then
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
		end
		--清理显存
		hResource.model:releaseCache({hVar.TEMP_HANDLE_TYPE.OBJECT_WM,hVar.TEMP_HANDLE_TYPE.UNIT_WM,hVar.TEMP_HANDLE_TYPE.EFFECT_WM})	--读取地图,清理大地图显存
		print("\ng_mapname="..map_name)
		
		local pList
		local randomSeed
		local sessionId
		local session_dbId
		local session_cfgId
		local endTurnInterval
		local framePerTurn
		local opExecuteInterval
		local bUseEquip
		local validTime
		local bIsArena
		local pveMultiTacticCfg
		if (mapMode == hVar.MAP_TD_TYPE.PVP) and session then
			pList = session.pList
			sessionId = session.id
			session_dbId = session.dbId
			session_cfgId = session.cfgId
			randomSeed = session.randomSeed
			endTurnInterval = session.endTurnInterval
			framePerTurn = session.framePerTurn
			opExecuteInterval = session.opExecuteInterval
			bUseEquip = session.bUseEquip
			validTime = session.validTime
			bIsArena = session.bIsArena
			pveMultiTacticCfg = session.tacticList
		else
			local me = hGlobal.LocalPlayer
			pList = {
				{
					pid = me.data.playerId,					--玩家id
					dbid = xlPlayer_GetUID(),				--玩家dbid
					rid = luaGetplayerDataID(),				--玩家rid
					name = "playerMe",					--玩家姓名
					utype = 1,						--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
					force = hVar.FORCE_DEF.SHU,				--势力
					pos = 1,
				},
				{
					pid = 11,						--玩家id
					dbid = 11,						--玩家dbid
					rid = 11,						--玩家rid
					name = "playerOther",					--玩家姓名
					utype = 2,						--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
					force = hVar.FORCE_DEF.WEI,						--势力
					pos = 11,
				},
			}
			sessionId = -1
			session_dbId = -1
			session_cfgId = -1
			randomSeed = os.time()
			endTurnInterval = 3
			framePerTurn = 6
			opExecuteInterval = 3
			bUseEquip = true
			validTime = 0
			bIsArena = false
		end
		
		--print("banLimitTable=",banLimitTable)
		
		--new的时候w之后状态为IDLE
		hGlobal.WORLD.LastWorldMap = hClass.world:new({
			map = map_name,
			background = map_name,
			ImmediateLoad = 0,		--此地图不立刻加载地形和所有单位
			type = "worldmap",
			MapMode = mapMode,		--地图类型
			MapDifficulty = mapDiff,	--地图难度
			pList = pList,			--玩家列表
			sessionId = sessionId,		--所属游戏局id
			session_dbId = session_dbId, --所属游戏局唯一id
			session_cfgId = session_cfgId, --竞技场配置id
			randomSeed = randomSeed,	--随机种子
			banLimitTable = banLimitTable, --地图禁用卡牌、卡牌等级限制等信息
			endTurnInterval = endTurnInterval,	--每回合客户端提前多少帧发送结束回合
			framePerTurn = framePerTurn,	--每回合多少帧
			opExecuteInterval = opExecuteInterval,	--每回合执行op的帧数间隔（第一回合的指令执行时间是 第一回合对应帧数+间隔）
			bUseEquip = bUseEquip,
			validTime = validTime,
			bIsArena = bIsArena,
			pveMultiTacticCfg = pveMultiTacticCfg,
		})
		
		--如果传入指定地图名，替换为该名字
		if banLimitTable then
			--print("banLimitTable.mapName=",banLimitTable.mapName)
			if banLimitTable.mapName then
				hGlobal.WORLD.LastWorldMap.data.map = banLimitTable.mapName
			end
		end
		
		--hGlobal.WORLD.LastWorldMap:SetPlayerList(pList)
		print(":::::::::::::::::::::::::::::::::::::::::map_start:::::::::::::::::::::::::::::::::::::::::-1")
		return 20
	end
	
	functions[#functions + 1] = function()
		--世界加载所有数据的流程，如果map==0就会什么都不做
		--这里写出来只是给程序看流程的,load结束之后状态变成init
		local w = hGlobal.WORLD.LastWorldMap
		local mapBackground,unitList,triggerData = hApi.LoadMap(map_name,hVar.DEFAULT_WORLDMAP)
		w:loadMapTile(mapBackground)
		w:loadAllObjects(unitList,triggerData)
		hGlobal.event:call("Event_WorldCreated",w,0)
		
		if mapMode == hVar.MAP_TD_TYPE.PVP and session then
			SendPvpCmdFunc["switch_game"](session.id)
		end
		
		--添加游戏信息文本
		hApi.AppendGameInfo("switch_game", false)
		
		print(":::::::::::::::::::::::::::::::::::::::::map_start:::::::::::::::::::::::::::::::::::::::::0")
		
		return 40
	end
	
	functions[#functions + 1] = function()
		--如果是pvp
		if (mapMode == hVar.MAP_TD_TYPE.PVP) then
			local w = hGlobal.WORLD.LastWorldMap
			local mapInfo = w.data.tdMapInfo
			--如果当前状态是刚初始化，则发送本地角色数据
			if mapInfo.mapState == hVar.MAP_TD_STATE.INIT then
				mapInfo.mapState = hVar.MAP_TD_STATE.WAITING
				local me = w:GetPlayerMe()
				SendPvpCmdFunc["load_game_ok"](session.id)
				
				--添加游戏信息文本
				hApi.AppendGameInfo("load_game_ok")
				
				return 60
			end
			--g_game_days = 0
			--hApi.UpdataDate(g_game_days)
			--return 100
		else
			local w = hGlobal.WORLD.LastWorldMap
			local mapInfo = w.data.tdMapInfo
			--if mapInfo.mapState == hVar.MAP_TD_STATE.INIT then
				mapInfo.mapState = hVar.MAP_TD_STATE.BEGIN
				return 80
			--end
		end
	end
	
	local loadProgress = 100600
	functions[#functions + 1] = function()
		print("loading lastfunction ", loadProgress)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local mapInfo = w.data.tdMapInfo
			--如果仍然处于waiting状态，则进行等待
			if (mapInfo.mapState == hVar.MAP_TD_STATE.WAITING) then
				print("loading ++ ", loadProgress)
				loadProgress = loadProgress + 1
				if loadProgress < 100990 then
					local abc = math.min(math.floor(loadProgress / 10),10099)
					print("loading ++ abc", abc)
					return math.min(math.floor(loadProgress / 10),10099)
				else
					return 10099
				end
				
			--当收到服务器开局消息并设置地图状态后正式进入游戏	
			elseif mapInfo.mapState == hVar.MAP_TD_STATE.BEGIN then
				--print("loading ok ", loadProgress)
				----xlUI_SetProgress(100)
				
				--xlScene_Switch(g_world)
				
				--map_start()
				--todo: 先后顺序？？？观察update loop loading条
				
				return 100
			end
		end
	end
	
	functions[#functions + 1] = function()
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		if (mapInfo.mapState == hVar.MAP_TD_STATE.BEGIN) then
			--print("loading_finish", loadProgress)
			
			--添加游戏信息文本
			hApi.AppendGameInfo("loading_finish")
			hGlobal.event:event("localEvent_ShowLoadingEffectFrm",0)

			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
				xlUI_ClearLoadingAction()
			end
			
			if (mapMode ~= hVar.MAP_TD_TYPE.PVP) then
				xlScene_Switch(g_world)
				map_start()
				hApi.addTimerOnce("UnitEvSetAllMode",50,function()
					if g_canSpinScreen == 1 then
						if g_CurScreenMode == 1 then
							--如果当前游戏状态运行按键
							if w.data.keypadEnabled then
								if type(xlGetScreenRotation) == "function" and type(xlRotateScreen) == "function" then
									--设置可旋转(必须是登录游戏后)
									local orientation, lock_flag = xlGetScreenRotation()
									xlRotateScreen(orientation,  0)               --设置屏幕朝向以及是否锁定
								end
							end
						else
							hApi.ChangeScreenMode()
						end
					end
					
					if (w.data.map ~= hVar.LoginMap) then
						hApi.ResetViewMode()
					end
				end)
				hGlobal.event:event("LocalEvent_TD_CreateLoginButton")
			else
				--xlScene_Switch(g_world)
				--pvp
			end
		end
		return 0
	end
	
	xlScene_LoadingProgress(functions)
end

-- load map for scene
--参数 1程序场景对象 2地图名 3地图难度 4地图模式 5游戏局信息
function xlScene_LoadMap(scene, name, mapDiff, mapMode, session, banLimitTable)
	
	--print("xlScene_LoadMap", scene, name, mapDiff, mapMode, session, banLimitTable)
	local scene_name = xlScene_GetLuaName(scene)
	
	--清除scene里现有的全部内容， 包括map, mapdata, cha, scene layer上挂靠的所有node等等
	xlEvent_BeforeLayerClear(scene_name)
	xlScene_Clear(scene)
	
	xlScene_SetMapName(scene, name)
	
	local map_name = name
	if scene_name=="worldmap" then
		--新开地图时加载xlobjs EFF 2015/4/20
		xlLoadPlistForWorldMap(name)
		xlScene_LoadMap_Asynchronous(map_name, mapDiff or 0, mapMode or 0, session, banLimitTable)
		print(":::::::::::::::::::::::::::::::::::::::::map_start:::::::::::::::::::::::::::::::::::::::::", scene, name, mapDiff, mapMode, session, banLimitTable)
	elseif scene_name=="town" then
		if hGlobal.WORLD.LastTown then
			hGlobal.WORLD.LastTown:del()
			hGlobal.WORLD.LastTown = nil
		end
		local w = hClass.world:new({
			map = map_name,
			--background = map_name,
			type = "town",
			template = "",
		})
	elseif scene_name=="battlefield" then
		--xlScene_LoadBackground(scene, name)
	elseif g_map_on_scene[scene_name]==nil then
		if hVar.OPTIONS.LOW_QUALITY_MODE==0 then
			xlScene_LoadBackground(scene, name)
		end
	end
	
	--xlLG("load", "load map [%s] to scene [%s] ok, w = %d, h = %d\n", name, scene_name, w, h)
end

function xlLuaEvent_ButtonClick(button,tag)
	if type(g_buttons_handle[button]) == "function" then
	
	    xlGameMsg("gmsg_button_click", button, tag)
		-- g_buttons_handle[button](tag)
	end
	
	if type(update_ui_buttonclick) == "function" then
		update_ui_buttonclick(button,tag)
	end
end






------------------
--回调函数
--添加一个测试用角色
--必须在game_start()函数之后调用
--这里创建的(luaObject)unit可以通过hApi.findUnitByCha(c)来找到
function add_test_character()
	return xlLoadChaByID("world",0,1,0,0,0).handle._c
end

function xlSetWorldLayer(key,layer)
	hGlobal.WORLD_LAYER[key] = layer
end

function xlCreateWorld(key,name,gridW,gridH,w,h)
	hApi.safeRemoveT(hGlobal.WORLD,name)
	hGlobal.WORLD[name] = hClass.world:new({
		name = name,
		type = key,
		w = w,
		h = h,
		gridW = gridW,
		gridH = gridH,
	})
end
------------------------------------------------------
function xlAddChaByID_WithData(worldName,owner,id,x,y,facing,AttrOfCreate,DataOfCreate)
	local w
	if type(worldName)=="table" then
		--脚本会直接传个oWorld进来的
		w = worldName
	else
		--程序丢个字符串进来
		--w = g_map_on_scene[xlScene_GetLuaName(g_current_scene)]
		--if 
		if worldName == "g_current_scene" then--为了不让cpp代码里发生变动
			worldName = hGlobal.WORLD.LastWorldMap
		end
		w = hGlobal.WORLD[worldName] or hGlobal.LastCreateWorld
	end
	facing = hApi.RyanAngleToLeeAngle(facing+0)	--这个地方传进来的角度是正上方0度
	--local owner = hGlobal.player[owner]
	local owner = owner
	local worldX,worldY = x,y
	local tabU = hVar.tab_unit[id] or hVar.tab_unit[1]
	local u
	if tabU.type==hVar.UNIT_TYPE.SCEOBJ then
		local e
		if tabU.xlobj~=nil then
			hApi.setEditorID(id)
			e = w:addsceobj(id,nil,nil,tabU.xlobj,"xlobj",tabU.scale,facing,worldX,worldY,tabU.zOrder)
		elseif tabU.model~=nil then
			hApi.setEditorID(id)
			e = w:addsceobj(id,nil,nil,tabU.model,hApi.animationByFacing(tabU.model,"stand",facing),tabU.scale,facing,worldX,worldY,tabU.zOrder)
		end
		if e and e.handle._c then
			return e.handle._c
		else
			if e then
				e:del()
				e = nil
			end
			print("添加场景物件失败！给你一个方块！",id)
			hApi.setEditorID(id)
			return w:addsceobj(id,nil,nil,"MODEL:default","normal",1,facing,worldX,worldY,0).handle._c
		end
	else
		hApi.setEditorID(id)
		u = w:addunit(id,owner,nil,nil,facing,worldX,worldY,AttrOfCreate,DataOfCreate)
		if u and u.handle._c then
			return u.handle._c
		else
			if u then
				u:del()
				u = nil
			end
			print("添加单位失败！给你一个方块！",id)
			hApi.setEditorID(id)
			return w:addunit(1,owner,nil,nil,facing,worldX,worldY,AttrOfCreate,DataOfCreate).handle._c
		end
	end
end

local __xlAddChaByID_WithData = xlAddChaByID_WithData
function xlAddChaByID(worldName,owner,id,x,y,facing)
	return __xlAddChaByID_WithData(worldName,owner,id,x,y,facing,nil,nil)
end
------------------------------------------------------
------------------------------------------------------
function xlAddItemByID(worldName,owner,id,x,y,facing)
	local w
	if type(worldName)=="table" then
		--脚本会直接传个oWorld进来的
		w = worldName
	else
		--程序丢个字符串进来
		w = hGlobal.LocalPlayer:getfocusworld() or hGlobal.LastCreateWorld
	end
	facing = hApi.RyanAngleToLeeAngle(facing+0)	--这个地方传进来的角度是正上方0度
	local owner = hGlobal.player[owner]
	local worldX,worldY = x,y
	local tabI = hVar.tab_item[id] or hVar.tab_item[1]
	if tabI~=nil then
		hApi.setEditorID(id)
		--地图上放的物品都是非法物品！
		local itm = w:additem(id,owner,nil,nil,facing,worldX,worldY,1,nil,hVar.CURRENT_ITEM_VERSION)
		if itm and itm:getunit() then
			hGlobal.event:call("Event_ItemCreated",itm)
			return itm:getunit().handle._c
		else
			print("添加道具失败！给你一个方块！",id)
			hApi.setEditorID(id)
			return w:addunit(hVar.ITEM_UNIT_ID,owner,nil,nil,facing,worldX,worldY).handle._c
		end
	end
end
------------------------------------------------------
--单位到达区域的默认回调
local arriveEventParam = {}
local function __xlLuaEvent_cha_arrived()
	local c,worldX,worldY,arriveTarget,arriveMode = arriveEventParam[1],arriveEventParam[2],arriveEventParam[3],arriveEventParam[4],arriveEventParam[5]
	--print("移动到达回调",c,worldX,worldY,arriveTarget,arriveMode)
	local u = hApi.findUnitByCha(c)
	if u then
		local w = u:getworld()
		if w then
			u.data.worldX,u.data.worldY = worldX,worldY
			local gridX,gridY = w:xy2grid(worldX-u.data.standX,worldY-u.data.standY)
			local oTarget
			if type(arriveTarget)=="userdata" then
				oTarget = hApi.findUnitByCha(arriveTarget)
			end
			hClass.unit.__static.arrive_callback(u,w,gridX,gridY,oTarget,arriveMode)
		else
			_DEBUG_MSG("单位世界错误！！")
		end
	else
		--_DEBUG_MSG("未知单位到达坐标",c)
	end
end

function xlLuaEvent_cha_arrived(c,worldX,worldY,arriveTarget,arriveMode)
	arriveEventParam[1] = c
	arriveEventParam[2] = worldX
	arriveEventParam[3] = worldY
	arriveEventParam[4] = arriveTarget
	arriveEventParam[5] = arriveMode
	xpcall(__xlLuaEvent_cha_arrived,hGlobal.__TRACKBACK__)
end

function xlCMDString(s)
	print(s)
end

--触摸开始的回调
local touchDownEventParam = {}
local rParam = {}
local function __xlLuaEvent_TouchBegan()
	local screenX,screenY,worldX,worldY = unpack(touchDownEventParam)
	touchDownEventParam[5] = 0
	if hGlobal.LocalPlayer then
		if hGlobal.LastFocusSwitch==1 then
			--world
			local oWorld = hGlobal.LocalPlayer:getfocusworld()
			if oWorld then
				local gridX,gridY = oWorld:xy2grid(worldX,worldY)
				local r = hGlobal.LocalPlayer.localoperate:touch(oWorld,hVar.LOCAL_OPERATE_TYPE.TOUCH_DOWN,gridX,gridY,worldX,worldY)
				if r then
					touchDownEventParam[5] = r
				end
			end
		elseif hGlobal.LastFocusSwitch==2 then
			--map
			local oMap = hGlobal.LocalPlayer:getfocusmap()
			if oMap then
				rParam[1] = 0
				hGlobal.event:call("LocalEvent_PlayerTouchOnMap",oMap,screenX, screenY, worldX, worldY,rParam)
				touchDownEventParam[5] = rParam[1]
			end
		end
	end
end

--程序回调函数: touch按下事件
function xlLuaEvent_TouchBegan(screenX, screenY, worldX, worldY)
	--print("xlLuaEvent_TouchBegan", screenX, screenY, worldX, worldY)
	touchDownEventParam[1] = screenX
	touchDownEventParam[2] = screenY
	touchDownEventParam[3] = worldX
	touchDownEventParam[4] = worldY
	touchDownEventParam[5] = 0
	xpcall(__xlLuaEvent_TouchBegan,hGlobal.__TRACKBACK__)
	return touchDownEventParam[5]
end

local touchUpEventParam = {}
local function __xlLuaEvent_TouchUp()
	--print("__xlLuaEvent_TouchUp")
	local screenX, screenY, worldX, worldY = touchUpEventParam[1],touchUpEventParam[2],touchUpEventParam[3],touchUpEventParam[4]
	if hGlobal.LocalPlayer then
		if hGlobal.LastFocusSwitch==1 then
			--world
			local oWorld = hGlobal.LocalPlayer:getfocusworld()
			if oWorld then
				local gridX,gridY = oWorld:xy2grid(worldX,worldY)
				--hGlobal.LocalPlayer.localoperate:touch(oWorld,hVar.LOCAL_OPERATE_TYPE.TOUCH_UP,gridX,gridY,worldX,worldY)
				oWorld:GetPlayerMe().localoperate:touch(oWorld,hVar.LOCAL_OPERATE_TYPE.TOUCH_UP,gridX,gridY,worldX,worldY)
				--print("hGlobal.LocalPlayer.localoperate:touch", hVar.LOCAL_OPERATE_TYPE.TOUCH_UP,gridX,gridY,worldX,worldY)
			end
		elseif hGlobal.LastFocusSwitch==2 then
			--map
			local oMap = hGlobal.LocalPlayer:getfocusmap()
			if oMap then
				hGlobal.event:call("LocalEvent_PlayerTouchUpFromMap",oMap ,screenX, screenY, worldX, worldY)
			end
		end
	end
end

function xlLuaEvent_TouchUp(screenX, screenY, worldX, worldY)
	
	--可以直接测试指定角色移动到目标
	--local target = xlGameLayer_HitTest("world", worldX, worldY)
	--local ai_cha = xlGetAICha(6001)
	--xlCha_MoveToGrid(ai_cha, 0, 0, 1, target)
	
	touchUpEventParam[1] = screenX
	touchUpEventParam[2] = screenY
	touchUpEventParam[3] = worldX
	touchUpEventParam[4] = worldY
	xpcall(__xlLuaEvent_TouchUp,hGlobal.__TRACKBACK__)
end

local changeC,changeA
local function __xlLuaEvent_cha_faceto()
	local u = hApi.findUnitByCha(changeC)
	if u then
		if u.data.reciveFacingEvent==1 then
			u:facingto(hApi.RyanAngleToLeeAngle(changeA))
		end
	elseif hGlobal.LOCAL_CHA[changeC] then
		hApi.ObjectSetFacing(hGlobal.LOCAL_CHA[changeC].handle,hApi.RyanAngleToLeeAngle(changeA))
	end
end

function xlLuaEvent_cha_faceto(c,newAngle)
	changeC,changeA = c,newAngle
	xpcall(__xlLuaEvent_cha_faceto,hGlobal.__TRACKBACK__)
end

--重载地图之前先把之前的世界清掉
function xlEvent_BeforeLayerClear(layerName)
	if g_map_on_scene[layerName]~=nil then
		local oObject = g_map_on_scene[layerName]
		g_map_on_scene[layerName] = nil
		local classname = oObject.classname
		local worldLayer = hGlobal.WORLD_LAYER[worldName]
		xpcall(function()
			--清除世界上的node
			hUI.panel:enum(function(p)
				if p.data.parent==worldLayer then
					p:del()
				end
			end)
			if classname=="world" then
				print("clear world!  "..tostring(layerName))
				for k,v in pairs(hGlobal.WORLD)do
					if oWorld==v then
						hGlobal.WORLD[k] = nil
					end
				end
				oObject:del()
			elseif classname=="map" then
				print("clear map!  "..tostring(layerName))
				oObject:del()
			end
		end,hGlobal.__TRACKBACK__)
	end
end



--界面模块, 程序与脚本互动回调事件处理
--废弃
function xlLuaEvent_SelectHero(hero_slot_loc)
  hApi.PlaySound("button")
  --传入的参数为被点击的英雄槽位置, 数值范围1 ~ 5

   --xlLG("ui", "GameUI_SelectHero %d\n", hero_slot_loc)

   --local main_win = xlGameUI_GetWindow("main") -- 获取游戏主窗口的layer指针

   --print(main_win)  -- 可以操作里面现存的sprite, 或者增加新的sprite
      --hGlobal.LocalPlayer:
	if hGlobal.LocalPlayer==nil then
		return 0
	end
	local hero = hGlobal.LocalHeroSlot[hero_slot_loc]
	if hero and hero~=0 then
		print("选择本地玩家的["..hero_slot_loc.."]号英雄")
		local u = hero:getunit()
		hGlobal.event:event("LocalEvent_HitOnHeroPhoto",u,hero_slot_loc)
		if u then
			hGlobal.LocalPlayer:focusunit(u)
			return u.handle._c
		else
			print("本地玩家的["..hero_slot_loc.."]号英雄还没有进入地图")
		end
	else
		print("本地玩家的["..hero_slot_loc.."]号栏位没有英雄")
		hGlobal.event:event("LocalEvent_HitOnHeroPhoto",nil,hero_slot_loc)
	end
	return 0 -- 1表示选中成功 0失败，程序界面不会刷新
end

--废弃
function xlLuaEvent_DragHeroPhoto(hero_loc)

	--hApi.PlaySound("army")

	--xlLG("ui", "drag hero photo out of the frame [%d]\n", hero_loc)
	
	if hGlobal.LocalPlayer==nil then
		return 0
	end
	local hero = hGlobal.LocalHeroSlot[hero_loc]
	if hero and hero~=0 then
		local u = hero:getunit()
		if u then
			hGlobal.event:event("LocalEvent_DragOutHeroPhoto",u,hero_loc)
		else
			hGlobal.event:event("LocalEvent_DragOutHeroPhoto",nil,hero_loc)
		end
	end
end

--资源条界面的初始化, 传入参数为该界面宽，高
--废弃
function xlLuaEvent_InitGameUI(with, height)
  print("init resource bar:现在已经移到脚本中处理了")

  --res_bar_layer = xlGameUI_GetWindow("resource") -- 获取游戏资源条界面的layer指针
	--res_bar_layer:setVisible(false)
	--res_bar_layer:setPosition(-2000,-2000)
  --print(res_bar_layer)

  --添加资源条界面上各类sprite
	UI_InitShopFrame(xlGameUI_GetWindow("hire"),5,-10)
  return 0

end


--回合日期测试界面点击“结束回合”按钮之后的脚本回调处理
function xlLuaEvent_EndDay(day_count)
	print("######################## xlLuaEvent_EndDay\n")
	
	xlGameMsg("gmsg_endday", day_count)

	print("######################## after xlGameMsg xlLuaEvent_EndDay\n")
	
	return 1 -- 表示可以增加一天了

end



--AI控制结束， 真正结束一个回合
function xlLuaEvent_EndRound(day_count)
	xlLG("game", "AI Control End, Begin End Round! day = %d\n", day_count)
	--hApi.PlaySound("eff_bless")
	-- 检测各种条件是否能够结合当前回合 return 0 表示不要结束
	--hGlobal.player[1]:addresource(hVar.RESOURCE_TYPE.GOLD, 50)
	--相关逻辑移到heroGameRule中处理
	--AI结束一天,提交系统事件
	local focus_unit = hGlobal.LocalPlayer:getfocusunit()
	if focus_unit then
		local focus_cha = focus_unit.handle._c
		local x, y = xlCha_GetPos(focus_cha)
		hApi.setViewNodeFocus(x, y)
		xlSetFocusCha(focus_cha)
		local ret = xlCha_ShowPath(focus_cha, 1) --重新显示路径, 内部会重新寻路刷新箭头显示
		xlLG("game", "刷新focus unit箭头显示, Focus Cha [type:%d] Show Path\n", xlCha_GetType(focus_cha))
	else
		for i = 1 ,#hGlobal.LocalPlayer.data.ownTown do
			TownUnit = hApi.GetObjectUnit(hGlobal.LocalPlayer.data.ownTown[i])
			--只有自己的主城才做判断
			if TownUnit and TownUnit.data.owner == 1 then
				local focus_cha = TownUnit.handle._c
				local x, y = xlCha_GetPos(focus_cha)
				hApi.setViewNodeFocus(x, y)
				xlSetFocusCha(focus_cha)
			end
		end
	end
	return hGlobal.event:call("Event_EndDay",hGlobal.WORLD.LastWorldMap.data.roundcount)
end




--英雄每移动一步的回调
function xlLuaEvent_ChaMoveStep(pCha,worldX,worldY)
	local u = hApi.findUnitByCha(pCha)
	--local x = hGlobal.LocalPlayer:getfocusunit()
	if u then
		local w = u:getworld()
		if w~=nil and w.data.type=="worldmap" then
			u.data.gridX,u.data.gridY = w:xy2grid(worldX,worldY)
			if u.data.reciveMoveStepEvent==1 then
				hGlobal.event:call("Event_UnitStepMove",w,u,worldX,worldY)
			end
		end
	end
	return 1 -- 返回什么都木有意义
end

--离开主城界面按钮脚本回调
function xlLuaEvent_LeaveTown()
	hApi.EnterWorld()
   print("leave town\n")
   return 1 
end

function xlLuaEvent_RemoveChaFromLayer(pCha)
	--只接受由程序发起的此事件，因为脚本xlScene_RemoveCha()触发的此事件不作处理
	--控制者已经不等于lua了,因此ObjectReleaseSprite就不会停掉非法的动画
	local nType = xlCha_GetType(pCha)
	if nType==hVar.UNIT_TYPE.SCEOBJ then
		local s = hApi.findSceobjByCha(pCha)
		if s then
			s.handle.__manager = nil
			s:del("safe")
		end
	else
		local u = hApi.findUnitByCha(pCha)
		if u then
			u.handle.__manager = nil
			u:del("safe")
			--xlLG("RoadPoint", "xlLuaEvent_RemoveChaFromLayer(), unit=" .. tostring(u.data.name) .. "_" ..  tostring(u.__ID) .. "\n")
		end
	end
end


--(废弃)战斗主界面上的指令按钮点击回调
function xlLuaEvent_BattleCmd(cmd, flag)
   return 0
end

--(无用)城镇建筑被选中, 传入为该建筑的table_id以及cha指针
function xlLuaEvent_TownBuildingSelected(tab_id, cha)

   --根据tab_id, 决定可购买的兵种类型和相关数据

   --xlGameUI_ShowHirePanel(10, 2, 15, 2)

   return 0

end

--结束购买回调, 返回购买的数量
--废弃
function xlLuaEvent_EndShopping(...)
	local buyU = hGlobal.O["LocalHireHero"]
	local sellU = hGlobal.O["LocalHire"]
	if buyU==nil then
		print("买东西的家伙已经离开了")
	end
	if buyU~=nil and sellU~=nil and sellU.data.hireList~=0 then
		if buyU.data.team==0 then
			print("这货不是英雄不是英雄不能购买")
		end
		local arg = {...}
		local hireList = sellU.data.hireList
		local buyTeamList,buyCostList = {},{}
		local cost = 0
		for i = 1,#arg do
			local id,num,numMax,price = unpack(hireList[i])
			local buyNum = math.min(num,arg[i])
			if buyNum>0 and hVar.tab_unit[id]~=nil then
				cost = cost + buyNum*price
				local index = #buyTeamList+1
				buyTeamList[index] = {id,buyNum}
				buyCostList[index] = {i,buyNum}
			end
		end
		if #buyTeamList<=0 then
			print("购买数量 = 0")
			return 1
		elseif hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)>=cost then
			if buyU:teamaddunit(buyTeamList)==hVar.RESULT_SUCESS then
				print("-----------------------------")
				print("购买成功，花费金钱:"..tostring(cost))
				for i = 1,#buyTeamList do
					local sellIndex,sellNum = unpack(buyCostList[i])
					local v = hireList[sellIndex]
					v[2] = v[2] - sellNum
				end
				for i = 1,#hireList do
					local id,num,numMax,price = unpack(hireList[i])
					print("库存: unit["..id.."] = "..num)
				end
				hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD,-1*cost)
				return 1
			else
				print("英雄无法携带更多的部队了")
			end
		else
			print("金钱不足无法购买")
		end
	end
   --return 1 --购买成功
   return 0 --购买失败
end


--系统菜单里，调试Bar打开按钮
function xlLuaEvent_ShowInfoBar(selected_flag)
	hApi.ShowControlPanel(selected_flag)
end

--打开或者关闭编辑器窗口的事件
function xlLuaEvent_EditorOpen(selected_flag)
	
end

--for Scene to initialize itself
--[[
function xlLuaEvent_SceneStart(scene)

	if scene==g_loading then
		if g_bSkipLoading then
			return
		end
		
		--local res = xlUpdateEvent(0)
		if 0 == res then
			g_nLoading_state = 1
		else
			g_nLoading_state = -1
		end
	elseif scene==g_world then
		
		xlScene_LoadMap(g_town, "town01")
		map_start()
	end
	
end
--]]

g_hide_ui_flag = 0
function xlScene_ShowGameUI(scene, hide_flag)

	if hide_flag==1 and g_hide_ui_flag==0 then

		xlUI_Show(win_selectmap,0)
		xlUI_Show(win_main,		0)
		
		g_hide_ui_flag = 1
		
		return 1

	end

	g_hide_ui_flag = 0

	print("\nswitch_scene win_logo 0\n")

	xlUI_Show(win_logo,		0)
		
	if scene==g_battlefield then
	
	elseif scene==g_town then
		xlUI_Show(win_logo,		0)
	elseif scene==g_world then
		xlUI_Show(win_selectmap,0)
		xlUI_Show(win_loading,  0)
		xlUI_Show(win_loading_vertical,  0)
		xlUI_Show(win_logo,		0)
	
	else
		--给脚本UI发个命令把自己关掉
		hGlobal.event:call("LocalEvent_PlayerFocusWorld","none",nil,nil)
		if scene==g_mainmenu then

			xlUI_Show(win_selectmap,1)
			xlUI_Show(win_sys,      0)
			xlUI_Show(win_loading,  0)
			xlUI_Show(win_loading_vertical,  0)
			xlUI_Show(win_logo,		1)
		
		elseif scene==g_loading then

			xlUI_Show(win_selectmap,0)
			xlUI_Show(win_sys,      0)
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				xlUI_Show(win_loading,  1)
				xlUI_Show(win_loading_vertical,  0)
				
			else
				xlUI_Show(win_loading,  0)
				xlUI_Show(win_loading_vertical,  1)
			end
			xlUI_Show(win_logo,		0)
		
			print("show loading ui")
		
		elseif scene==g_playerlist then
		
			xlUI_Show(win_selectmap,0)
			xlUI_Show(win_sys,      0)
			xlUI_Show(win_loading,  0)
			xlUI_Show(win_loading_vertical,  0)
			xlUI_Show(win_logo,		0)
		
		end
	end

	return 0
end

--设置镜头，要转移到xlLuaEvent_SwitchScene里去
function TD_ViewSet(viewRange)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if not oWorld then
		return
	end
	
	local mapInfo = oWorld.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	local tParam = hVar.DEVICE_PARAM[g_phone_mode] or {}
	
	local world_scale = tParam.world_scale or 1.0
	
	--编辑器模式固定为1.0缩放
	if (g_editor == 1) then
		world_scale = 1.0
	end
	
	local w,h = oWorld.data.sizeW,oWorld.data.sizeH
	--if not viewRange then
	--	viewRange = mapInfo.viewRange or {}
	--end
	if viewRange then
		mapInfo.viewRange = viewRange
	else
		viewRange = mapInfo.viewRange or {}
	end
	local viewOffset = mapInfo.viewOffset or {}
	local viewOffsetPhone = mapInfo.viewOffsetPhone
	local right = (viewRange[1] or 0)
	local left = (viewRange[2] or 0)
	local up = (viewRange[3] or 0)
	local down = (viewRange[4] or 0)
	local ox = (viewOffset[1] or 0)
	local oy = (viewOffset[2] or 0)
	
	if (g_phone_mode == 1 or g_phone_mode == 2) and viewOffsetPhone and type(viewOffsetPhone) == "table" then
		ox = (viewOffsetPhone[1] or 0)
		oy = (viewOffsetPhone[2] or 0)
	end
	
	local minX = hVar.SCREEN.w - (w - right) * world_scale	--地图左边界坐标最小值
	local maxX = (w - right -left) * world_scale - hVar.SCREEN.w --地图右边界坐标最大值
	local minY = hVar.SCREEN.h + up * world_scale --地图上边界坐标最小值
	local maxY = (h - up - down) * world_scale - hVar.SCREEN.h  --地图上边界坐标最大值

	--镜头对准出生点
	if mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		--local nForceMe = oPlayerMe:getforce() --我的势力
		local godU = oPlayerMe:getgod()
		if godU and godU.handle then
			local px, py = hApi.chaGetPos(godU.handle)
			--聚焦
			hApi.setViewNodeFocus(px, py)
		end
	else
		--聚焦
		hApi.setViewNodeFocus(w/2+ox,h/2+oy)
	end
	
	--设置移动范围
	xlScene_SetBoundNew(g_current_scene, minX, maxX, minY, maxY)
end

--获取镜头
local old_xlGetViewNodeFocus = xlGetViewNodeFocus
function xlGetViewNodeFocus()
	local vx, vy = old_xlGetViewNodeFocus()
	
	local tParam = hVar.DEVICE_PARAM[g_phone_mode] or {}
	
	local world_scale = tParam.world_scale or 1.0
	
	--编辑器模式固定为1.0缩放
	if (g_editor == 1) then
		world_scale = 1.0
	end

	vx = vx / world_scale
	vy = vy / world_scale
	
	return vx, vy
end


--get callback when host switch scenes
function xlLuaEvent_SwitchScene(scene)
	g_last_scene = g_current_scene
	g_current_scene = scene
	local name = xlScene_GetLuaName(g_current_scene)
	
	xlLG("init", "switch scene to [%s]\n", name)
	local lua_mem = collectgarbage("count")
	
	xlLG("init", ">>>>>>>>>>> lua mem : %d MB\n", lua_mem/1024)
	--print("scene=", scene, tostring(scene), tostring(g_chooselevel))
	xlPrintMem("switch scene")
	--hGlobal.LocalPlayer:setfocusworld()--在程序xlLuaEvent_SwitchScene回调中请使用这个不会调用SwitchScene的接口
	
	if scene==g_battlefield then
		xlLuaEvent_Snapshot(1)
		local oWorld = hGlobal.LastCreateWorld
		if oWorld~=nil then
			local bgm = oWorld.data.bgm
			if bgm ~= "" and oWorld.data.type == "battlefield" then
			elseif g_battleBMGCount == 0 then
				bgm = "fight01"
				g_battleBMGCount = 1
			else
				bgm = "fight02"
				g_battleBMGCount = 0
			end
			hApi.PlaySoundBG(g_channel_battle,bgm)
			if g_phone_mode==3 then
				--1280*720
				--安卓
				xlView_SetScale(1.0)
				hApi.setViewNodeFocus(500,360)
			else
				xlView_SetScale(1.0)
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			end
		end
	elseif scene==g_town then
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		local oMap = hGlobal.LocalPlayer:getfocusmap()
		local sMapName = (oWorld and oWorld.data.map) or (oMap and oMap.data.map)
		
		--geyachao: 不重复加载同一个背景音乐
		if (hApi.GetPlaySoundBG(g_channel_town) ~= "main_theme") then
			--hApi.PlaySound("eff_bless")
			hApi.PlaySoundBG(g_channel_town, (hVar.TownMusicList[sMapName] or "main_theme"))
		end
		
		--print("main_theme 2")
		if g_game_mode=="editor" then
			if oMap~=nil then
				hGlobal.LocalPlayer:setfocusworld(oMap,1)
			elseif oWorld~=nil then
				hGlobal.LocalPlayer:setfocusworld(oWorld,1)
			end
		else
			local tParam = hVar.DEVICE_PARAM[g_phone_mode]
			if oMap~=nil then
				local bx,sw,by,sh,ox,oy = 0,0,0,0,0,0
				local w,h = oMap.data.sizeW,oMap.data.sizeH
				if tParam.menu_view then
					bx,sw,by,sh,ox,oy = unpack(tParam.menu_view)
				end
				--是菜单界面
				hApi.setViewNodeFocus(w/2+ox,h/2+oy)
				xlScene_SetBound(g_town,hVar.SCREEN.w-w+bx, w+sw, hVar.SCREEN.h-h+by, h+sh)
			elseif oWorld~=nil then
				--是城市
				local bx,sw,by,sh,ox,oy = 0,0,0,0,0,0
				local w,h = oWorld.data.sizeW,oWorld.data.sizeH
				if tParam.town_view then
					bx,sw,by,sh,ox,oy = unpack(tParam.town_view)
				end
				local vx = hVar.SCREEN.w-w+bx
				local vy = hVar.SCREEN.h-h+by
				--是主城界面
				--强制聚焦新手引导时可能位置和这里设定的不一样
				hApi.setViewNodeFocus(w/2+ox,h/2+oy)
				xlScene_SetBound(g_town,vx, w+sw, vy, h+sh)
			end
			return
		end
	elseif (scene == g_world) then
		--特殊关卡指定背景音乐
		local oWorld = hGlobal.WORLD.LastWorldMap
		local sMapName = (oWorld and oWorld.data.map) or (oMap and oMap.data.map)
		local tMapInfo = hVar.MAP_INFO[sMapName]
		local strBGSound = nil --背景音乐
		
		if tMapInfo and tMapInfo.sound and (tMapInfo.sound ~= 0) then
			if (type(tMapInfo.sound) == "string") then
				strBGSound = tMapInfo.sound
			elseif (type(tMapInfo.sound) == "table") then
				local randIdx = math.random(1, #tMapInfo.sound)
				strBGSound = tMapInfo.sound[randIdx]
			end
		else
			--随机音效列表
			local sound =
			{
				--"main_theme",
				"fight_base_01",
				"fight_base_02",
				"fight_ext_01",
			}
			
			--播放随机的背景音乐
			local randIdx = math.random(1, #sound)
			strBGSound = sound[randIdx]
		end
		
		--print(oWorld, sMapName)
		
		hApi.PlaySoundBG(g_channel_world, strBGSound, g_WorldMusicMode)
		g_WorldMusicMode = 0
		
		local fScale = 1.0
		local tParam = hVar.DEVICE_PARAM[g_phone_mode]
		if tParam and tParam.world_scale then
			fScale = tParam.world_scale
		end
		
		--编辑器模式固定为1.0缩放
		if (g_editor == 1) then
			fScale = 1.0
		end
		
		if g_editor ~= 1 then
			xlView_SetScale(fScale)
			
			TD_ViewSet()
			
			--清除迷雾
			xlMap_EnableFog(0)
		else
			--清除迷雾
			xlMap_EnableFog(0)
		end
		
		hGlobal.LocalPlayer:setfocusworld(hGlobal.WORLD.LastWorldMap, 1)
		
		--geyachao: 检测ui.plist和pvp.plist这两张图的spriteframe是否被释放，如果被释放就恢复
		hApi.Restore_UI_PVP_PLIST()
	else
		hGlobal.LocalPlayer:setfocusworld(g_map_on_scene[name], 1)
		if scene==g_loading then
			hApi.PlaySoundBG(g_channel_world,0)
			local list = tempBackground
			if g_Cur_Language >= 3 then
				list = tempBackground_en
			end
			local r = hApi.random(1,#list)
			xlUI_SetWindowPos(win_loading, hVar.SCREEN.w/2 - 200, hVar.SCREEN.h/2 + 85)
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
				list = g_Background_vertical
				r = g_Background_Index
				--xlUI_SetWindowPos(win_loading, hVar.SCREEN.w/2 - 184, hVar.SCREEN.h - 260)
			end
			local bgName = list[r]
			xlScene_LoadBackground(scene,bgName) --设置该场景背景图
			
			local DEVICE_PARAM_UI = {
				--iPad
				[0] = {
					loading_view = {0,0,1},
				},
				
				--iPhone4
				[1] = {
					loading_view = {0,0,1},
				},
				
				--iPhone5
				[2] = {
					loading_view = {-160,0,0.83},
				},
				
				--iPhone6, iPhone7, iPhone8
				[3] = {
					loading_view = {-160,0,0.94},
				},
				
				--iPhoneX
				[4] = {
					loading_view = {-160,0,0.94},
				},
			}
			local tParam = DEVICE_PARAM_UI[g_phone_mode]
			local fScale = 1
			local ox,oy = 0,0
			if tParam.loading_view then
				ox,oy,fScale = unpack(tParam.loading_view)
			end
			-- loading
			local display_size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
			--print("ox,oy,fScale=", ox,oy,fScale)
			if display_size.width == 960 and display_size.height == 640 then -- ip4(s)
				hApi.setViewNodeFocus(display_size.width/2+0,display_size.height/2+0)
				xlView_SetScale(1.0)
				--xlScene_EnableFillScreen(g_loading,1)
			elseif display_size.width == 1136 and display_size.height == 640 then -- ip5(s)
				hApi.setViewNodeFocus(display_size.width/2 + 2-2,display_size.height/2 + 28 - 28)
				xlView_SetScale(0.8533)
			elseif display_size.width == 1280 and display_size.height == 720 then
				hApi.setViewNodeFocus(display_size.width/2+0,display_size.height/2 + 30-30)
				xlView_SetScale(0.96)
			elseif display_size.width == 1560 and display_size.height == 720 then --iphoneX
				--xlScene_SetBackgroudSpiritScaleX(Update_Ui_Table.Scene,1)
				--xlScene_SetBackgroudSpiritScaleY(Update_Ui_Table.Scene,0.89)
				--xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 - 53,Update_Data_Table.DesignResolutionSize.height/2+15)
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
				--xlView_SetScale(1.21875)
				--xlView_SetScale(0.96)
			elseif display_size.width == 720 and display_size.height == 1560 then --iphoneX
				hApi.setViewNodeFocus(display_size.width/2+24,display_size.height/2)
				xlView_SetScale(1.0)
			elseif display_size.width == 720 and display_size.height == 1280 then --iphoneX
				hApi.setViewNodeFocus(display_size.width/2+24,display_size.height/2 + 140)
				xlView_SetScale(1.0)
			else
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2-0)
				xlView_SetScale(1.0)
			end
			--xlView_SetScale(fScale)
			--hApi.setViewNodeFocus(hVar.SCREEN.w/2/fScale+ox,hVar.SCREEN.h/2/fScale+oy)
			--添加呼吸灯效果
			hGlobal.event:event("localEvent_ShowLoadingEffectFrm",1)
		elseif scene==g_mainmenu then
			hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			--print(nil..nil)
			xlView_SetScale(1.0)
		elseif scene==g_chooselevel then --选择关卡
			--print("yes!!!!!!")
			--print(nil..nil)
			local sMapName = (oWorld and oWorld.data.map) or (oMap and oMap.data.map)
			
			--geyachao: 不重复加载同一个背景音乐
			if (hApi.GetPlaySoundBG(g_channel_town) ~= "main_theme") then
				--hApi.PlaySound("eff_bless")
				hApi.PlaySoundBG(g_channel_town, "main_theme")
				--print("main_theme 3")
			end
			
			local oMap = hGlobal.LocalPlayer:getfocusmap()
			if oMap then
				--if oMap.data.map == hVar.PHONE_SELECTLEVEL or oMap.data.map == hVar.PHONE_VIPMAP then
				--	xlScene_SetBound(g_chooselevel, hVar.SCREEN.w - 2048,2048,hVar.SCREEN.h - 768,768)
				--elseif oMap.data.map == hVar.PHONE_SELECTLEVEL_3 then
				--	xlScene_SetBound(g_chooselevel, hVar.SCREEN.w - 1600,1600,hVar.SCREEN.h - 856,856)
				--end
				--print("yes2222!!!!!!")
				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
				if oMap.data.map == "town/blackdragon_nest" then
					local showW,showH = oMap.data.sizeW,oMap.data.sizeH
					xlScene_SetBound(g_chooselevel, hVar.SCREEN.w - showW,showW,hVar.SCREEN.h - showH,showH)
				end
				
				xlView_SetScale(1.0)
			end
			
			--geyachao: 检测ui.plist和pvp.plist这两张图的spriteframe是否被释放，如果被释放就恢复
			hApi.Restore_UI_PVP_PLIST()
		elseif g_PVP then
			hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			xlView_SetScale(1.0)
			xlScene_SetBound(g_PVP, hVar.SCREEN.w - 2048,2048,hVar.SCREEN.h - 768,768)
		elseif scene == g_playerlist then
			hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			xlView_SetScale(1.0)
		end
	end
	
	xlScene_ShowGameUI(scene, 0)
	--return 0
end

function xlScene_Update(scene, frame_count)
	if scene == g_update then			
		if 3 >= frame_count then
			g_update_state = 0 --0表示开始
		end
		
		if 0 == g_update_state then
			local res = xlUpdateEvent(g_update_state)
			if 0 == res then --初始化成功
				g_update_state = 1
			else
				g_update_state = -1
				print(".................... 初始化失败")
			end
		elseif 1 == g_update_state then
			local res = xlUpdateEvent(g_update_state)
			if 0 == res then
			else
				g_update_state = -1
				print(".................... 连接失败")
			end
		elseif 2 == g_update_state then
			xlScene_Switch(g_mainmenu)
		end
	end
end

--local __CALLBACK_FRAME_LOOP__
--__CALLBACK_FRAME_LOOP__ = function()
	--__CALLBACK_FRAME_LOOP__ = function()
		--return hApi.__callback__FrameLoop()
	--end
	--local _timer = hGlobal.timer
	--local _timerI = hGlobal.timerI
	--local _timerSYS = hGlobal.timerSYS
	--hGlobal.__gametime = xlGetTickCount()
	----第一帧时，对SYS_Timer进行排序
	--local slotI = 1
	--for i = 1,#_timer do
		--local v = _timer[i]
		--if _timerSYS[v[7]]==1 then
			--for k = i,slotI+1,-1 do
				--_timer[k] = _timer[k-1]
				--_timerI[_timer[k][7]] = k
			--end
			--_timer[slotI] = v
			--_timerI[v[7]] = slotI
			--slotI = slotI + 1
		--end
	--end
	--return hApi.__callback__FrameLoop()
--end

function xlLuaEvent_UpdateGame(scene, frame_count)
	--geyachao: td不需要此代码
	--g_Game_Agent.run(scene, frame_count)
	if type(UpdateRunCallBack) == "function" then
		UpdateRunCallBack(frame_count)
	end
	
	if (scene == g_loading) then
		xlLoadingEvent_UpdateProgress(scene)
	elseif (scene == g_battlefield) then --(战场)专用
		if hGlobal and hGlobal.BattleField and hGlobal.BattleField.ID~=0 then
			hGlobal.BattleField:frameloopBF(frame_count)
		end
	elseif (scene == g_world) then --(世界)水花
		hApi.WMEffectLoop(frame_count)
		
		--geyachao: 暂时注释掉
		--hClass.world:__timer_loop(frame_count)
		
		--(系统用)Timer(废弃)
		--if hGlobal.WORLD_INIT_SUCESS==1 then
			----xlLG("update start", "frame_count = : %d\n", frame_count)
			--return __CALLBACK_FRAME_LOOP__()
		--elseif hGlobal.WORLD_INIT_SUCESS~=0 then
			--hGlobal.WORLD_INIT_SUCESS = 0
			--_DEBUG_MSG("--------------------------------------------\n [script load error]	脚本初始化出错！\n--------------------------------------------")
		--end
	end
end

g_show_terrain = 1

function xlLuaEvent_KeyDown(key, ctrl, shift)
	--print("xlLuaEvent_KeyDown", key, ctrl, shift)
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		local keypadState = world.data.keypadState
		if keypadState then
			if (not keypadState[key]) then --防止重复触发同一个按键事件
				keypadState[key] = true
				
				if (key == VK_W) or (key == VK_A) or (key == VK_S) or (key == VK_D) then
					local strW = "-"
					local strA = "-"
					local strS = "-"
					local strD = "-"
					if keypadState[VK_W] then
						strW = "W"
					end
					if keypadState[VK_A] then
						strA = "A"
					end
					if keypadState[VK_S] then
						strS = "S"
					end
					if keypadState[VK_D] then
						strD = "D"
					end
					
					local strKey = strW .. strA .. strS .. strD
					--print(strKey)
					world.data.keypadWASD = strKey --WASD按键值
					
					--触发按键事件
					hGlobal.event:event("LocalEvent_KeypadEvent", strKey)
				end

				if (key == VK_J) then
					--hGlobal.event:event("Event_OpenAutoAttack")
				end

				if (key == VK_K) then
					--hGlobal.event:event("Event_ClickTankSkill")
				end

				if (key == VK_L) then
					--hGlobal.event:event("Event_ClickTacticsBtn",1)
				end

				if (key == VK_I) then
					--hGlobal.event:event("Event_ClickTacticsBtn",2)
				end
			end
		end
	end
end

function xlLuaEvent_KeyUp(key, ctrl, shift)
	--print("xlLuaEvent_KeyUp", key, ctrl, shift)
	--xlLG("key", "key up = %d, ctrl = %d, shift = %d\n", key, ctrl, shift)
	--print("key="..key)
	--print("ctrl="..key)
	hGlobal.event:event("Event_SetHotKey",key)
	
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		local keypadState = world.data.keypadState
		if keypadState then
			if keypadState[key] then
				keypadState[key] = nil
				
				if (key == VK_W) or (key == VK_A) or (key == VK_S) or (key == VK_D) then
					local strW = "-"
					local strA = "-"
					local strS = "-"
					local strD = "-"
					if keypadState[VK_W] then
						strW = "W"
					end
					if keypadState[VK_A] then
						strA = "A"
					end
					if keypadState[VK_S] then
						strS = "S"
					end
					if keypadState[VK_D] then
						strD = "D"
					end
					
					local strKey = strW .. strA .. strS .. strD
					--print(strKey)
					world.data.keypadWASD = strKey --WASD按键值
					
					--触发按键事件
					hGlobal.event:event("LocalEvent_KeypadEvent", strKey)
				end

				if (key == VK_J) then
					--hGlobal.event:event("Event_CloseAutoAttack")
				end
			end
		end
	end
	
	if key==VK_O and ctrl==1 then		--物件禁选的切换
		
		hVar.SCEOBJ_SELECTABLE = 1 - hVar.SCEOBJ_SELECTABLE
		hClass.sceobj:enableselect(hVar.SCEOBJ_SELECTABLE)
		
		xlLG("opt", "设置场景装饰物件能否选中 [%d]\n", hVar.SCEOBJ_SELECTABLE)
		
	elseif key==VK_U and ctrl==1 then   --关闭所有界面显示
		xlScene_ShowGameUI(g_current_scene, 1)
		xlLG("opt", "隐藏当前正在显示的界面[%d]\n")
	elseif key==VK_M and ctrl==1 then
		--xlScene_ShowGameUI(win_selectmap,1)
		--xlLG("opt", "快速弹出切换地图窗口")
	end
	
	if key==VK_5 and ctrl==1 then
	   g_show_terrain = 1 - g_show_terrain
	   xlScene_ShowTerrain(g_world, g_show_terrain)
	end
	
	--if key == VK_S and ctrl == 1 then
		--print("******* capture screen start... *********")
		--local mapName, mapWidth, mapHeight = xlMap_GetMapInfo()
		--print("mapName:", mapName or "")
		--print("mapWidth:", mapWidth or 0)
		--print("mapHeight:", mapHeight or 0)
		--local isVisible = xlMap_ShowFogOfWar(0)
		--print("fog:", isVisible or "0")
		--local offsetX, offsetY = 130, 120;
		--mapWidth = mapWidth + offsetX * 2
		--mapHeight = mapHeight + offsetY * 2
		--if g_current_scene then
			--local tex = CCRenderTexture:create(mapWidth, mapHeight)
			--tex:begin()
			--local layer = xlScene_ToLayer(g_current_scene)
			--local oldPosX, oldPosY = layer:getPosition()
			--layer:setPosition(ccp(0 + offsetX, mapHeight - offsetY))
			--layer:visit()
			--layer:setPosition(ccp(oldPosX, oldPosY))
			--tex:endToLua()
			
			--local lastSlashPos = string.find(mapName, "/")
			--local path = "snapshot/"..string.sub(mapName, lastSlashPos + 1) .. ".png"
			--tex:saveToFile(path)
			--if isVisible then
				--xlMap_ShowFogOfWar(isVisible)
			--end
			--print("snapshot is saved to path:", path)
		--else
			--print("current scene is not exist")
		--end
		--print("******* capture screen end      *********")
	--end
	
end

--角色重新出现在显示范围内的时候，重新加载动画
function xlLuaEvent_cha_appear(cha)
	--local oUnit = hApi.findUnitByCha(cha)
	--if oUnit~=nil and oUnit.handle.__manager=="lua" and oUnit.handle.__appear==0 then
		--oUnit.handle.__appear = 1
		--local handleTable = oUnit.handle
		--if handleTable.modelmode==0 then
			----两方向模型要走这里
			--hApi.SpritePlayAnimation(handleTable,handleTable._animation,nil,1)
			--hApi.ObjectSetFacing(handleTable,oUnit.data.facing,1)
		--else
			--hApi.ObjectSetFacing(handleTable,oUnit.data.facing,1)
		--end
	--end
end

--清除所有脚本物件的函数
function xlLua_ClearAll()
	--xlScene_Switch(g_playerlist)
	hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
	hGlobal.LocalPlayer:focusworld(nil)
	hClass.world:enum(function(oWorld)
		oWorld:del()
	end)
	--这里还需要一个通知程序清理场景的函数
end

function xlLuaEvent_Snapshot(mode)
	if 1 == mode then
		--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xlLuaEvent_Snapshot begin")
		xlLG("luamem","xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xlLuaEvent_Snapshot begin")
		g_luasnapshot_begin = xlLuaSnapshot()
	elseif 2 == mode then
		--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xlLuaEvent_Snapshot end")
		xlLG("luamem","xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xlLuaEvent_Snapshot end")
		g_luasnapshot_end = xlLuaSnapshot()
		for k,v in pairs(g_luasnapshot_end) do
			if g_luasnapshot_begin[k] == nil then
				--print(k,v)
				xlLG("luamem","k:" .. tostring(k) .. " v:" .. tostring(v))
			end
		end
	end
end

-- 清理游戏中已经存在的所有的scene的数据, 包括背景图，角色，场景物件等
function xlGame_ClearAll()  
  
  xlLG("init", "Clear All Game Scene data after update finished!\n")
  
  if g_world~=nil			then 
	
		local scene_name = xlScene_GetLuaName(g_world) 
		xlEvent_BeforeLayerClear(scene_name) --清除scene里现有的全部内容， 包括map, mapdata, cha, scene layer上挂靠的所有node等等
		xlScene_Clear(g_world)			

  end
	
  if g_battlefield~=nil		then 
	
	local scene_name = xlScene_GetLuaName(g_battlefield) 
	xlEvent_BeforeLayerClear(scene_name) --清除scene里现有的全部内容， 包括map, mapdata, cha, scene layer上挂靠的所有node等等
	xlScene_Clear(g_battlefield)	
	
  end
  
  if g_town~=nil then 
	
	local scene_name = xlScene_GetLuaName(g_town) 
	xlEvent_BeforeLayerClear(scene_name) --清除scene里现有的全部内容， 包括map, mapdata, cha, scene layer上挂靠的所有node等等
	xlScene_Clear(g_town)			
	
  end

  if g_loading~=nil		then xlScene_Clear(g_loading)		end
  if g_chooselevel~= nil	then xlScene_Clear(g_chooselevel)	end
  if g_playerlist~= nil		then xlScene_Clear(g_playerlist)	end
  if g_PVP~= nil		then xlScene_Clear(g_PVP)	end

end


--用户点了去评价的回调接口
xlLuaEvent_userRateGame = function()
	
end

xlLuaEvent_SpinScreen = function(w,h)
	if w ~= hVar.SCREEN.w or h ~= hVar.SCREEN.h then
		local oldmode = hVar.SCREEN_MODE
		if w > h then
			hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.HORIZONTAL
			hVar.SCREEN.w = w
			hVar.SCREEN.h = h
		else
			hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.VERTICAL
			hVar.SCREEN.w = w
			hVar.SCREEN.h = h
		end
		if oldmode ~= hVar.SCREEN_MODE then
			hGlobal.event:event("LocalEvent_SpinScreen")
			--因调用先后时机不定 必须放在第二时间的事件
			hGlobal.event:event("LocalEvent_refreshafterSpinScreen")
			if g_backToLogin == 1 then
				g_backToLogin = 0
				hGlobal.event:event("LocalEvent_ShowVerticalLoginFrm")
			end
		end
	end
end


--显示内存占用小窗口

g_show_debug_win = 0
function ShowDebugWindow(show)

	if xlUI_ShowMiniBar~=nil then
	 
	   g_show_debug_win =  xlUI_ShowMiniBar(show)

	end

end

--调试用函数 索引对应 var.lua 中的 hVar.DeBugBtnList , 参数2 是否启用 0,1
function DebugFunc(index,param)
	if index == 1 then
		xlDebugMode("always_update_block", param)
		ShowDebugWindow(param)
	elseif index == 2 then

	else
		print("unknwo debug function")
	end

end

local old_xlNewRemoveUnusedTextures = xlNewRemoveUnusedTextures
xlNewRemoveUnusedTextures = function()
	old_xlNewRemoveUnusedTextures()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
end

--程序进入前景和背景时的回调
---@param flag number 1进入后台|0返回前台
xlLuaEvent_EnterBackground = function(flag)
	--print("程序进入前景和背景时的回调, flag=" .. flag)
	hGlobal.event:event("LocalEvent_AppEnterBackground", flag)
end

function xlGameAiAccelerate()
end

--相册读取图片
xlLuaEvent_OnAlbumSelected = function(t)
	hGlobal.event:event("LocalEvent_OnAlbumSelected", t)
end

--隐私回调
function xlLuaEvent_OnPermissionsResult(id,result)
	if id == 0 and result == 1 then
		--LuaAddBehaviorID(hVar.PlayerBehaviorList[20000])
		local iChannelId = getChannelInfo()
		if iChannelId == 1002 or iChannelId == 100 or iChannelId == 999 then
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("init")
			end
		end
		--弹公告
		hGlobal.event:event("LocalEvent_CheckShowAnnouncementFrm")
	elseif result ~= 1 then
		local str = string.format(hVar.tab_string["NoAgreeAndExit"],hVar.tab_string["__TEXT_Privacy"],hVar.tab_string["__TEXT_Protocol"])
		hGlobal.UI.MsgBox(str, {
			font = hVar.FONTC,
			textAlign = "LC",
			ok = function()
				xlExit()
			end,
		})
		
	end
end