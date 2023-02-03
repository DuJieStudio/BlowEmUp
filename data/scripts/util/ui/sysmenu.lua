--------------------------------
-- 系统菜单 包括

--[ 读取最近的存档 ]   -> 直接读取当前玩家上一次的存档

--[ 返回玩家选择   ]   -> 返回玩家列表选择

--界面底部， 显示fps和当前内存占用

--增加显示程序版本号 和 脚本 版本号
--------------------------------
--hGlobal.UI.InitSystemMenuFram = function()
--	local sysbtnlist = {}
--	local _childUI
--	local _y,_interval = -80,80
--	local _CODE_SwitchSoundEnable = hApi.DoNothing
--	if xlShowRecommendDialog then
--		_interval = 60
--	end
--
--	hGlobal.UI.SystemMenuFram = hUI.frame:new({
--		x = hVar.SCREEN.w/2 - 240,
--		y = hVar.SCREEN.h/2 + 220,
--		w = 480,
--		h = 440,
--		dragable = 2,
--		closebtn = "BTN:PANEL_CLOSE",
--		closebtnX = 470,
--		closebtnY = -14,
--		show = 0,
--
--	})
--
--	local _fram = hGlobal.UI.SystemMenuFram
--	local _parent = _fram.handle._n
--	_childUI = _fram.childUI
--
--	--切世界隐藏
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideSystemMenuFrm",function(sSceneType,oWorld,oMap)
--		_fram:show(0)
--	end)
--
--	--加载5个按钮
--	--读取最近一次的存档
--	_childUI["loadLastbtn"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/back1.png",
--		iconWH = 30,
--		label = hVar.tab_string["__TEXT_LastSave"],
--		font = hVar.FONTC,
--		border = 1,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w/2-10,
--		y = _y,
--		--w = 200,
--		scaleT = 0.9,
--		code = function(self)
--			hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--			_fram:show(0)
--			hGlobal.WORLD.LastWorldMap:del()
--			hGlobal.WORLD.LastWorldMap = nil
--			
--			hApi.clearCurrentWorldScene()
--			xlLoadGame(g_localfilepath,g_curPlayerName,hVar.SAVE_DATA_PATH.MAP_SAVE)
--			if hVar.OPTIONS.AUTO_COLLECTGARBAGE==1 then
--				collectgarbage()
--			end
--		end,
--	})
--	sysbtnlist[#sysbtnlist+1] = "loadLastbtn"
--	_childUI["loadLastbtn"].childUI["label"].handle._n:setPosition(-45,15)
--	_childUI["loadLastbtn"].childUI["icon"].handle._n:setPosition(-65,1)
--
--	--前三天的存档
--	_childUI["loadLast3daybtn"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/back3.png",
--		iconWH = 30,
--		label = hVar.tab_string["__TEXT_Last3DaysSave"],
--		font = hVar.FONTC,
--		border = 1,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w/2-10,
--		y = _y-_interval,
--		--w = 200,
--		scaleT = 0.9,
--		code = function(self)
--			hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--			if hGlobal.WORLD.LastWorldMap~=nil then
--				local daycount = hGlobal.WORLD.LastWorldMap.data.roundcount
--				if hApi.FileExists(g_localfilepath..g_curPlayerName.."autosave"..(daycount-3)..".sav","full") and hApi.FileExists(g_localfilepath..g_curPlayerName.."autosave"..(daycount-3)..".fog","full") then
--					_fram:show(0)
--					hGlobal.WORLD.LastWorldMap:del()
--					hGlobal.WORLD.LastWorldMap = nil
--					
--					hApi.clearCurrentWorldScene()
--					xlLoadGame(g_localfilepath,g_curPlayerName,"autosave"..(daycount-3)..".sav")
--					if hVar.OPTIONS.AUTO_COLLECTGARBAGE==1 then
--						collectgarbage()
--					end
--				end
--			end
--		end,
--	})
--	_childUI["loadLast3daybtn"]:setstate(-1)
--	sysbtnlist[#sysbtnlist+1] = "loadLast3daybtn"
--	_childUI["loadLastbtn"].childUI["label"].handle._n:setPosition(-45,15)
--	_childUI["loadLastbtn"].childUI["icon"].handle._n:setPosition(-65,1)
--
--
--	--重玩本关卡
--	_childUI["playerList"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/bimage_replay.png",
--		iconWH = 36,
--		label = hVar.tab_string["__TEXT_ResetLevel"],
--		font = hVar.FONTC,
--		border = 1,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w/2-10,
--		y = _y-_interval*2,
--		--w = 200,
--		scaleT = 0.9,
--		code = function(self)
--			hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--			_fram:show(0)
--			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ResetGameTip"],{
--				font = hVar.FONTC,
--				ok = function()
--					local mapname = hGlobal.WORLD.LastWorldMap.data.map
--					local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
--					
--					if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
--						
--						hGlobal.WORLD.LastWorldMap:del()
--						hGlobal.WORLD.LastWorldMap = nil
--						
--					end
--					xlScene_LoadMap(g_world, mapname,MapDifficulty)
--				end,
--				cancel = 1,
--			})
--		end,
--	})
--	sysbtnlist[#sysbtnlist+1] = "playerList"
--	_childUI["playerList"].childUI["label"].handle._n:setPosition(-45,15)
--	_childUI["playerList"].childUI["icon"].handle._n:setPosition(-65,1)
--
--	--选择关卡
--	_childUI["selectedlevel"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/hall.png",
--		iconWH = 31,
--		label = " "..hVar.tab_string["__TEXT_MainInterface"],
--		font = hVar.FONTC,
--		border = 1,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w/2-10,
--		y = _y-_interval*3,
--		--w = 200,
--		scaleT = 0.9,
--		code = function()
--			if g_vs_number > 4 and g_lua_src == 1 then
--				local mapname = hGlobal.WORLD.LastWorldMap.data.map
--				if hApi.Is_WDLD_Map(mapname) ~= -1 then
--					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
--				end
--			end
--			
--			hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--			--xlScene_Switch(g_playerlist)
--			--hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
--			
--			_fram:show(0)
--			local mapname = hGlobal.WORLD.LastWorldMap.data.map
--			if hApi.Is_RSYZ_Map(mapname) ~= -1 then
--				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
--			end
--		end,
--	})
--	_childUI["selectedlevel"].childUI["label"].handle._n:setPosition(-45,15)
--	_childUI["selectedlevel"].childUI["icon"].handle._n:setPosition(-65,1)
--
--	sysbtnlist[#sysbtnlist+1] = "selectedlevel"
--
--	_childUI["soundenable"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:horn_open",
--		--icon = "UI:shopitemxg",
--		--iconWH = 68,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w-48,
--		y = -1*_fram.data.h+48,
--		scaleT = 0.9,
--		code = function(self)
--			_CODE_SwitchSoundEnable(1)
--		end,
--	})
--
--	if xlShowRecommendDialog then
--		--推荐好友
--		_childUI["share"] = hUI.button:new({
--			parent = _parent,
--			model = "UI:ButtonBack",
--			icon = "ui/bimage_bbs.png",
--			iconWH = 36,
--			label = hVar.tab_string["__TEXT_share"],
--			font = hVar.FONTC,
--			border = 1,
--			dragbox = _fram.childUI["dragBox"],
--			x = _fram.data.w/2-10,
--			y = _y-_interval*4,
--			--w = 200,
--			scaleT = 0.9,
--			code = function()
--				if xlShowRecommendDialog then
--					xlShowRecommendDialog()
--				end
--			end,
--		})
--		sysbtnlist[#sysbtnlist+1] = "share"
--		_childUI["share"].childUI["label"].handle._n:setPosition(-45,15)
--		_childUI["share"].childUI["icon"].handle._n:setPosition(-65,1)
--	end
--	
--	--设置密码
--	_childUI["password"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/password.png",
--		iconWH = 30,
--		label = hVar.tab_string["__TEXT_SetPassWord"],
--		font = hVar.FONTC,
--		border = 1,
--		dragbox = _fram.childUI["dragBox"],
--		x = _fram.data.w/2-10,
--		y = _y-_interval*5,
--		--w = 200,
--		scaleT = 0.9,
--		code = function()
--			hGlobal.event:event("LocalEvent_ShowInputFrm",1,1)
--		end,
--	})
--	sysbtnlist[#sysbtnlist+1] = "password"
--	_childUI["password"].childUI["label"].handle._n:setPosition(-45,15)
--	_childUI["password"].childUI["icon"].handle._n:setPosition(-65,1)
--
--	--_childUI["bbs"] = hUI.button:new({
--		--parent = _parent,
--		--model = "misc/button_back_l.png",
--		--icon = "ui/bimage_bbs.png",
--		--iconWH = 36,
--		--label = hVar.tab_string["__TEXT_BBS"],
--		--font = hVar.FONTC,
--		--border = 1,
--		--dragbox = _fram.childUI["dragBox"],
--		--x = _fram.data.w/2-10,
--		--y = _y-_interval*6,
--		--w = 200,
--		--scaleT = 0.9,
--		--code = function()
--			--if update_ui_show_gamebbs_scene then
--				--update_ui_show_gamebbs_scene()
--			--end
--		--end,
--	--})
--	--sysbtnlist[#sysbtnlist+1] = "bbs"
--
--	--总内存
--	_childUI["MemoryInfo1"] = hUI.label:new({
--		parent = _parent,
--		--font = hVar.FONTC,
--		size = 22,
--		text = "",
--		align = "LT",
--		border = 1,
--		x = 30,
--		y = -_fram.data.h + 50,
--	})
--	_childUI["MemoryInfo1"].handle._n:setVisible(false)
--	--空闲内存
--	_childUI["MemoryInfo2"] = hUI.label:new({
--		parent = _parent,
--		--font = hVar.FONTC,
--		size = 22,
--		text = "",
--		align = "LT",
--		border = 1,
--		x = _fram.data.w/2-70,
--		y = -_fram.data.h + 50,
--	})
--	_childUI["MemoryInfo2"].handle._n:setVisible(false)
--	--自己使用的内存
--	_childUI["MemoryInfo3"] = hUI.label:new({
--		parent = _parent,
--		--font = hVar.FONTC,
--		size = 22,
--		text = "",
--		align = "LT",
--		border = 1,
--		x = 310,
--		y = -_fram.data.h + 50,
--	})
--	_childUI["MemoryInfo3"].handle._n:setVisible(false)
--	
--	--程序版本号
--	_childUI["programm_version"] = hUI.label:new({
--		parent = _parent,
--		--font = hVar.FONTC,
--		size = 22,
--		text = "",
--		align = "LT",
--		border = 1,
--		x = 35,
--		y = -15,
--	})
--
--	--显示当前系统菜单中的按钮
--	local _showsysbtn = function(closeindex,offy,y)
--		local tempindex = 0
--		for i = 1,#sysbtnlist do
--			if i ~= closeindex then
--				_childUI[sysbtnlist[i]]:setXY(_fram.data.w/2-10,y-offy*tempindex)
--				_childUI[sysbtnlist[i]]:setstate(1)
--				tempindex = tempindex+1
--			end
--		end
--		if _childUI[sysbtnlist[closeindex]] then
--			_childUI[sysbtnlist[closeindex]]:setstate(-1)
--		end
--	end
--	
--	local shareState = -1
--	hGlobal.event:listen("LocalEvent_Setbtn_compensate","__ShowshareBtn",function(state)
--		if g_vs_number > 7 then
--			shareState = state
--		end
--	end)
--
--	hGlobal.event:listen("localEvent_ShowSysFrm","showthisfrm",function(version)
--		_childUI["programm_version"]:setText(version)
--		local tempy = _y
--		--有网络和没有网络的情况下
--		if g_cur_net_state == 1 then
--			--如果允许好友分享
--			if shareState == -1 and g_vs_number > g_next_vs_number then
--				_showsysbtn(5,76,tempy)
--			else
--				_showsysbtn(0,63,tempy)
--			end
--		else
--			_showsysbtn(0,100,tempy)
--			
--			if _childUI["share"] then
--				_childUI["share"]:setstate(-1)
--			end
--			
--			if _childUI["password"] then
--				_childUI["password"]:setstate(-1)
--			end
--		end
--		
--		--在锁定模式下是否激活最近3天按钮
--		if hGlobal.WORLD.LastWorldMap~=nil and g_editor ~= 1 then
--			local daycount = hGlobal.WORLD.LastWorldMap.data.roundcount
--			if hApi.FileExists(g_localfilepath..g_curPlayerName.."autosave"..(daycount-3)..".sav","full") and hApi.FileExists(g_localfilepath..g_curPlayerName.."autosave"..(daycount-3)..".fog","full") then
--				_childUI["loadLast3daybtn"]:setstate(1)
--			else
--				_childUI["loadLast3daybtn"]:setstate(0)
--			end
--		end
--		
--		_CODE_SwitchSoundEnable()
--		_childUI["dragBox"]:sortbutton()
--		_fram:show(1)
--		
--		_childUI["loadLastbtn"]:setstate(1)
--		--_childUI["loadLast3daybtn"]:setstate(1)
--		_childUI["playerList"]:setstate(1)
--		if hApi.Is_RSYZ_Map(hGlobal.WORLD.LastWorldMap.data.map) ~= -1 then
--			--if WdldRoleId ~= luaGetplayerDataID() then
--			_childUI["loadLastbtn"]:setstate(0)
--			_childUI["loadLast3daybtn"]:setstate(0)
--			_childUI["playerList"]:setstate(0)
--			--end
--		end
--	end)
--
--	--FPS显示
--	--_childUI["FPS_show"] = hUI.button:new({
--		--parent = _parent,
--		--model = "UI:button_back",
--		--label = "FPS",
--		--font = hVar.FONTC,
--		--border = 1,
--		--dragbox = _fram.childUI["dragBox"],
--		--x = _fram.data.w/2-10,
--		--y = -240,
--		--scaleT = 0.9,
--		--code = function(self)
--			--if g_FPSUI_show == 0 then
--				--xlShowFPS(1)
--				--g_FPSUI_show = 1
--				--heroGameInfo.worldMap.ShowUnitsCombatScore(true)
--				--local total,free,usedByMe = xlGetMemoryInfo()
--				--hGlobal.UI.SystemMenuFram.childUI["MemoryInfo1"]:setText("used  "..math.ceil(usedByMe/1024).." M")
--				--hGlobal.UI.SystemMenuFram.childUI["MemoryInfo2"]:setText("free  "..math.ceil(free/1024).." M")
--				--hGlobal.UI.SystemMenuFram.childUI["MemoryInfo3"]:setText("total  "..math.ceil(total/1024).." M")
--				
--				--_childUI["MemoryInfo1"].handle._n:setVisible(true)
--				--_childUI["MemoryInfo2"].handle._n:setVisible(true)
--				--_childUI["MemoryInfo3"].handle._n:setVisible(true)
--			--else
--				--xlShowFPS(0)
--				--g_FPSUI_show = 0
--				--heroGameInfo.worldMap.ShowUnitsCombatScore(false)
--				--_childUI["MemoryInfo1"].handle._n:setVisible(false)
--				--_childUI["MemoryInfo2"].handle._n:setVisible(false)
--				--_childUI["MemoryInfo3"].handle._n:setVisible(false)
--			--end
--		--end,
--	--})
--	
--	_CODE_SwitchSoundEnable = function(IsSwitch)
--		if IsSwitch==1 then
--			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
--				hVar.OPTIONS.PLAY_SOUND = 0
--				hVar.OPTIONS.PLAY_SOUND_BG = 0
--			else
--				hVar.OPTIONS.PLAY_SOUND = 1
--				hVar.OPTIONS.PLAY_SOUND_BG = 1
--			end
--			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
--				hApi.EnableSoundBG(1)
--				hApi.PlaySound("button")
--			else
--				hApi.EnableSoundBG(0)
--			end
--			hApi.SaveGameOptions()
--		end
--		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
--			--_childUI["soundenable"].childUI["icon"].handle._n:setVisible(false)
--			--_childUI["soundenable"].handle.s:setColor(ccc3(255,255,255))
--			_childUI["soundenable"]:loadsprite("UI:horn_open")
--		else
--			_childUI["soundenable"]:loadsprite("UI:horn_close")
--			--_childUI["soundenable"].childUI["icon"].handle._n:setVisible(true)
--			--_childUI["soundenable"].handle.s:setColor(ccc3(128,128,128))
--		end
--	end
--
--end
	
--系统操作条
--hGlobal.UI.InitSystemMenuBar = function()
--
--	if hGlobal.UI.SystemMenuBar~=nil then
--		hGlobal.UI.SystemMenuBar:del()
--	end
--	local x,y = hVar.SCREEN.w-486,hVar.SCREEN.h-5
--
--	local btnScale = 1 
--	if g_phone_mode ~= 0 then
--		btnScale = 1.2
--	end
--	hGlobal.UI.SystemMenuBar = hUI.frame:new({
--		x = x,
--		y = y,
--		--w = w,
--		--h = h,
--		background = "misc/datebar_back.png",
--		--background = -1,
--		z = -1,
--		show = 0,
--		dragable = 2,
--		buttononly = 1,
--		autoactive = 0,
--		child = {
--			{
--				__UI = "button",
--				__NAME = "NextDay",
--				model = "UI:next_day",
--				x = 442,
--				y = -47,
--				scaleT = 0.9,
--				code = function()
--					local w = hGlobal.WORLD.LastWorldMap
--					if g_editor ~= 1 then
--						local b_prepared = g_WDLD_Attr
--						if hApi.Is_WDLD_Map(w.data.map) ~= -1 and WdldRoleId == luaGetplayerDataID() then
--							if b_prepared == -1 then
--								return
--							else
--								local dayO = g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].day
--								--local dayO = 15
--								if w.data.roundcount >= dayO then
--									hUI.floatNumber:new({
--										unit = oUnit,
--										text = "",
--										x = 120,
--										font = "numRed",
--										moveY = 64,
--									}):addtext(hVar.tab_string["wdld_day_deadline"],hVar.FONTC,36,"MC",512,384):setColor(ccc3(255,255,255))
--									return
--								end
--							end
--						end
--					end
--					--战术技能卡 防刷计数器
--					--if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then return end
--
--					
--					--地图胜利/失败的状态下点不到这些按钮
--					if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
--						return
--					end
--					local CanNotGoNextDay = 0
--					hClass.hero:enum(function(oHero)
--						local u = oHero:getunit()
--						if u and u.handle.UnitInMove==1 and u:getworld()==hGlobal.WORLD.LastWorldMap then
--							CanNotGoNextDay = 1
--						end
--					end)
--					if CanNotGoNextDay==1 then
--						--还有单位在移动，禁止进入下一天
--						return
--					end
--					local buildingRet,movepointRet = CheckPlayerEndDay()
--					if buildingRet == 1 or movepointRet == 1 then
--						hGlobal.event:call("LocalEvent_SystemMsgBox",buildingRet,movepointRet)
--					else
--						hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--						local ret = xlLuaEvent_EndDay(g_game_days)
--						if ret==1 then
--							g_game_days = g_game_days + 1
--							hApi.UpdataDate(g_game_days)
--						end
--					end
--				end,
--			},
--			{
--				__UI = "button",
--				__NAME = "SysMenu",
--				model = "ui/set.png",
--				scale = btnScale,
--				x = 399,
--				y = -24,
--				scaleT = 0.85,
--				scale = 1.2,
--				code = function()
--					--地图胜利/失败的状态下点不到这些按钮
--					local w = hGlobal.WORLD.LastWorldMap
--					if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
--						return
--					end
--
--					if hGlobal.UI.SystemMenuNewFram then
--						hGlobal.event:event("localEvent_ShowNewSysFrm")
--					end
--
--				end,
--			},
--			{
--				__UI = "button",
--				__NAME = "NetShop",
--				model = "ui/shop.png",
--				scale = btnScale,
--				x = -80,
--				y = -28,
--				scaleT = 0.9,
--				code = function()
--					--地图胜利/失败的状态下点不到这些按钮
--					local w = hGlobal.WORLD.LastWorldMap
--					if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
--						return
--					end
--					
--					hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx","game")
--
--				end,
--			},
--			{
--				__UI = "button",
--				__NAME = "giftbtn",
--				model = "Action:button_gift",
--				animation = "UPDOWN",
--				x = -80,
--				y = -90,
--				scaleT = 0.9,
--				code = function()
--					hGlobal.event:event("localEvent_ShowPlayerGiftBagFrm",LuaGetPlayerGiftBag())
--				end,
--			},
--
--			{
--				__UI = "button",
--				__NAME = "BattlefieldSkillbtn",
--				model = "UI:skillbook_close",
--				scale = btnScale,
--				x = -24,
--				y = -28,
--				scaleT = 0.9,
--				code = function(self)
--					hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",0)
--					--在游戏中弹出战术技能卡界面
--					hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook_Game")
--
--				end,
--			},
--
--			{
--				__UI = "button",
--				__NAME = "MapName",
--				model = -1,
--				x = 112,
--				y = -30,
--				w = 210,
--				h = 60,
--				align = "MC",
--				label = {
--					text = "MapName",
--					font = hVar.FONTC,
--					--border = 1,
--					size = 30,
--				},
--				scaleT = 0.95,
--				code = function()
--					--地图胜利/失败的状态下点不到这些按钮
--					local w = hGlobal.WORLD.LastWorldMap
--					if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
--						return
--					end
--					--  点击地图名字 显示势力排行榜
--					if hApi.Is_WDLD_Map(w.data.map) ~= -1 then
--						if WdldRoleId and luaGetplayerDataID() == WdldRoleId then
--							hGlobal.event:event("LocalEvent_ShowWDLDInfoFrm",1)
--						end
--					elseif hApi.Is_RSYZ_Map(w.data.map) ~= -1 then
--						hGlobal.event:event("LocalEvent_ShowRsdyzInfoFrm",1,1)
--					else
--						hGlobal.event:event("LocalEvent_Phone_ShowWorldRank")
--					end
--				end,
--			},
--
--			{
--				__UI = "button",
--				__NAME = "MapQuest",
--				model =  "ICON:Imperial_Academy",
--				x = -30,
--				y = -28,
--				align = "MC",
--				label = {
--					text = "",
--					font = hVar.FONTC,
--					--border = 1,
--					size = 30,
--				},
--				scaleT = 0.95,
--				code = function()
--					local oWorld = hGlobal.LocalPlayer:getfocusworld()
--					hGlobal.event:event("LocalEvent_ShowQuestExFrm",oWorld)
--				end,
--			},
--		},
--	})
--	
--	local _frm = hGlobal.UI.SystemMenuBar
--
--	--精英地图标记
--	_frm.childUI["Elite_mode_img"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:elite_mode",
--		x = x + 206,
--		y = y - 28,
--	})
--	_frm.childUI["Elite_mode_img"].handle._n:setVisible(false)
--
--
--	_frm.childUI["SysMenu"]:setXY(-_frm.data.x + 28,-360)
--	_frm.childUI["NetShop"]:setXY(-_frm.data.x + 30,-360 - 80)
--	_frm.childUI["NetShop"]:setstate(-1)
--	_frm.childUI["BattlefieldSkillbtn"]:setXY(-_frm.data.x + 30,-360 - 160)
--
--
--	--设置任务按钮是否显示
--	hGlobal.event:listen("LocalEvent_SetQuestBtnShow","setbtnstate",function(sishow)
--		_frm.childUI["MapQuest"]:setstate(sishow)
--	end)
--	--增加一个 永久的使用技能书的 提示动画
--	--系统条在大地图显示
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__SHOW__SystemMenuBar",function(sSceneType,oWorld,oMap)
--		--有问题待查(已查)2014/7/11
--		--if g_phone_mode~=0 then
--			--return _frm:show(0)
--		--end
--
--		_frm.childUI["Elite_mode_img"].handle._n:setVisible(false)
--		if oWorld and sSceneType=="worldmap" then
--
--			if type(hVar.MAP_INFO[oWorld.data.map]) == "table" and  hVar.MAP_INFO[oWorld.data.map].mapType == 4 then
--				return _frm:show(0)
--			end
--			
--			_frm:show(1)
--			--if WDLD_NEED_HIDE_SYS_MENU == 1 then
--				--_frm:show(0)
--				--WDLD_NEED_HIDE_SYS_MENU = 0
--			--end
--			if LuaCheckGiftBag() == 1 then
--				_frm.childUI["giftbtn"]:setstate(1)
--			else
--				_frm.childUI["giftbtn"]:setstate(-1)
--			end
--			
--			--判断是否有激活过的技能
--			local tacticsList = LuaGetActiveBattlefieldSkill()
--			local result = 0
--			if type(tacticsList) == "table" then
--				local v = nil
--				for i = 1,#tacticsList do
--					v = tacticsList[i]
--					if type(v) == "table" and hVar.tab_tactics[v[1]] then
--						result = 1
--					end
--				end
--			end
--
--			--根据结果设置是否开启提示
--			local playerSkillBook = LuaGetPlayerSkillBook()
--
--			if type(playerSkillBook) == "table" then
--				if #playerSkillBook > 0  then
--					_frm.childUI["BattlefieldSkillbtn"]:setstate(1)
--				else
--					_frm.childUI["BattlefieldSkillbtn"]:setstate(-1)
--				end
--
--				if result == 0 and #playerSkillBook > 0 then
--					hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",1)
--				else
--					hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",0)
--				end
--			end
--
--			--编辑器模式不可见
--			if g_editor == 1 then
--				_frm.childUI["BattlefieldSkillbtn"]:setstate(-1)
--			end
--			
--			--群英阁地图关闭商店按钮
--			if oWorld.data.map == "world/level_qyg" then
--				_frm.childUI["NetShop"]:setstate(-1)
--			else
--				if g_cur_net_state == 1 and LuaGetPlayerMapAchi("world/level_tyjy",hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
--					_frm.childUI["NetShop"]:setstate(1)
--				else
--					_frm.childUI["NetShop"]:setstate(-1)
--				end
--			end
--			if type(hVar.MAP_INFO[oWorld.data.map]) == "table" and  hVar.MAP_INFO[oWorld.data.map].Normal_mode then
--				_frm.childUI["Elite_mode_img"].handle._n:setVisible(true)
--			end
--		else
--			_frm:show(0)
--		end
--	end)
--	
--	--给end_day 增加一个 提示动画
--	local _End_DayTip = nil
--	hGlobal.event:listen("LocalEvent_NextDayBreathe","__SHOW__NextDayBreathe",function(isshow)
--		if _End_DayTip then
--			_End_DayTip:getParent():removeChild(_End_DayTip,true)
--			_End_DayTip = nil
--		end
--
--		if isshow == 1 then
--			local decal,count = 11,0
--			local r,g,b,parent = 150,128,64,_frm.childUI["NextDay"].handle._n
--			local offsetX,offsetY,duration,scale = 0,0,0.7,1.1
--			_End_DayTip = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
--			_End_DayTip:setScale(2.5)
--		end
--	end)
--
--	hGlobal.event:listen("Event_NewDay","setBattlefieldSkillbtn",function(dayNum)
--		if dayNum == 0 then
--			local skill = LuaGetPlayerSkillBook()
--			if type(skill) == "table" and #skill > 0 then
--				LuaClearActiveBattlefieldSkill()
--				hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",1)
--			end
--		end
--	end)
--
--	local _ActionCallback = function()
--		hApi.addTimerOnce("UseBookTip",5000,function()
--			hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",1)
--		end)
--	end
--
--	hGlobal.event:listen("LocalEvent_ShowBattlefieldSkillBookBreathe","__SHOW__BattlefieldSkillBookBreathe",function(isshow,mode,x,y)
--		_frm.childUI["BattlefieldSkillbtn"]:setXY(-_frm.data.x + 30,-360 - 160)
--
--		if isshow == 1 then
--			_frm.childUI["BattlefieldSkillbtn"].handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(_frm.childUI["BattlefieldSkillbtn"].data.x,_frm.childUI["BattlefieldSkillbtn"].data.y),8,1),CCCallFunc:create(_ActionCallback)))
--		else
--			hApi.clearTimer("UseBookTip")
--		end
--		
--	end)
--
--	--通过网络是否连接来做商店按钮的是否显示
--	hGlobal.event:listen("LocalEvent_Set_activity_refresh","NetShopBtnISshow",function(connect_state)
--		if g_current_scene == g_world then
--			if hGlobal.WORLD.LastWorldMap then
--				local mapname = hGlobal.WORLD.LastWorldMap.data.map
--				if mapname ~= "world/level_qyg" then
--					if connect_state == 1 and LuaGetPlayerMapAchi("world/level_tyjy",hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
--						_frm.childUI["NetShop"]:setstate(1)
--					else
--						_frm.childUI["NetShop"]:setstate(-1)
--					end
--				end
--			end
--		end
--	end)
--
--	_frm.childUI["DateWeek"] = hUI.label:new({
--		parent = _frm.handle._n,
--		text = " "..tostring(0).." ",
--		font = hVar.FONTC,
--		align = "MC",
--		size = 30,
--		x = 274,
--		y = -28,
--	})
--
--	_frm.childUI["DateDay"] = hUI.label:new({
--		parent = _frm.handle._n,
--		text = " "..tostring(0).." ",
--		font = hVar.FONTC,
--		align = "MC",
--		size = 30,
--		x = 362,
--		y = -28,
--	})
--
--	--刷新日期的函数放在这里
--	hApi.UpdataDate = function(nDayCount)
--		local day = math.mod(nDayCount,7)
--		local week = math.floor((nDayCount-day)/7)
--		_frm.childUI["DateWeek"]:setText(" "..(week+1).." ")
--		_frm.childUI["DateDay"]:setText(" "..(day+1).." ")
--	end
--
--	--刷新地图名称的函数在这里
--	hApi.UpdateMapName = function(mapname)
--		_frm.childUI["MapName"].childUI.label:setText(tostring(mapname))
--	end
--
--end

--TD系统操作条
hGlobal.UI.InitTDSystemMenuBar = function()
	local iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then --iPhoneX
		iPhoneX_WIDTH = 110
	end
	
	--清除上一次界面
	if hGlobal.UI.TDSystemMenuBar ~= nil then
		hGlobal.UI.TDSystemMenuBar:del()
		hGlobal.UI.TDSystemMenuBar = nil
	end
	
	--清除监听事件
	--增加一个 永久的使用技能书的 提示动画
	--系统条在大地图显示
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__SHOW__TDSystemMenuBar", nil)
	--横竖屏切换
	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFrm", nil)
	hGlobal.event:listen("LocalEvent_TD_SelectHeroOk","__TD_SelectedHeroOk", nil)
	--NextWave刷新
	hGlobal.event:listen("LocalEvent_TD_NextWave","__TD_NextWave", nil)
	--显示NextWave按钮
	hGlobal.event:listen("LocalEvent_TD_ShowNextWave","__TD_NextWave", nil)
	--角色到达路点终点刷新
	hGlobal.event:listen("LocalEvent_TD_UnitReached","__TD_UnitReached", nil)
	--角色死亡刷新金币
	hGlobal.event:listen("Event_UnitDead","__TD_UnitDefeated", nil)
	--建造刷新
	hGlobal.event:listen("Event_TowerUpgradeCostRefresh","__TD_TowerUpgrade", nil)
	--释放技能刷新
	hGlobal.event:listen("Event_TacticCastCostRefresh","__TD_TacticCast", nil)
	--金钱变化界面刷新
	hGlobal.event:listen("Event_TdGoldCostRefresh","__TD_TdGoldCost", nil)
	--生命点数变化界面刷新
	hGlobal.event:listen("Event_TdLifeChangeRefresh","__TD_TdLifeChange", nil)
	--设置战术技能卡的主动技能界面
	hGlobal.event:listen("Event_TacticsInit", "__TD_MainTaticsSkillRefresh", nil)
	--设置单个被动战术技能卡的动画
	--bAddtoTop: 是否跳到顶部展示小图标
	hGlobal.event:listen("LocalEvent_SinglePassiveTacticsAmin", "__TD_SinglePassiveTaticsSkillAmin", nil)
	--开始按键攻击按钮
	hGlobal.event:listen("Event_BeginAutoAttack", "__TD_MainTaticsSkillRefresh", nil)
	--攻击按钮的touch滑动事件
	hGlobal.event:listen("Event_CheckAutoAttack", "__TD_MainTaticsSkillRefresh", nil)
	--[调试] 长按攻击按钮
	hGlobal.event:listen("Event_OpenAutoAttack", "__TD_MainTaticsSkillRefresh", nil)
	--取消按键攻击按钮
	hGlobal.event:listen("Event_CloseAutoAttack", "__TD_MainTaticsSkillRefresh", nil)
	hGlobal.event:listen("Event_ClickTankSkill", "__TD_MainTaticsSkillRefresh", nil)
	hGlobal.event:listen("Event_ClickTacticsBtn","_ClickTacticsBtn", nil)
	--更新战术技能卡的被动技能界面
	hGlobal.event:listen("Event_UpdatePassiveTactics", "__TD_MainTaticsSkillRefresh", nil)
	--更新战术技能卡的主动技能
	hGlobal.event:listen("Event_UpdateActiveTactics", "__TD_MainTaticsSkillRefresh", nil)
	--初始化营救人员个数
	hGlobal.event:listen("Event_InitRescuedPerson", "__TD_InitRescuedPerson", nil)
	--更新被营救人员
	hGlobal.event:listen("Event_UpdateRescuedPerson", "__TD_RescuedPersonRefresh", nil)
	--重置被营救人员
	hGlobal.event:listen("Event_ResetRescuedPerson", "__TD_RescuedPersonRefresh", nil)
	hGlobal.event:listen("Event_UpdateTankNum", "__TD_TankNumRefresh", nil)
	--添加玩家单个主动道具卡的主动技能界面
	hGlobal.event:listen("Event_AddTacticsActiveSkill", "__TD_AddTacticsActiveSkillRefresh", nil)
	--移除玩家单个主动道具卡的主动技能界面
	hGlobal.event:listen("Event_RemoveTacticsActiveSkill", "__TD_RemoveTacticsActiveSkillRefresh", nil)
	hGlobal.event:listen("Event_SetNewTacticsActiveSkill","__TD_SetNewTacticsActiveSkillRefresh", nil)
	--提前点击下一波按钮事件
	hGlobal.event:listen("Event_ClickNextWaveButtonInAdvance","__TD_MainTaticsSkillRefreshCd", nil)
	--重置单个位置的主动战术(道具)技能卡的主动技能界面
	hGlobal.event:listen("Event_ResetSingleTactic", "__TD_ResetSingleTatic", nil)
	--暂停菜单点击返回
	hGlobal.event:listen("Event_StartPauseSwitch", "__TD_PauseUIReturn", nil)
	--设置游戏的层数
	hGlobal.event:listen("Event_UpdateGameRound", "__TD_UpdateGameRound", nil)
	--显示游戏的波次等信息
	hGlobal.event:listen("LocalEvent_ShowWaveUI", "__TD_ShowWaveUI", nil)
	hGlobal.event:listen("LocalEvent_RefreshCurGameScore","TDSystemMenu__UpdateGameScore", nil)
	
	--聊天相关
	--监听收到聊天模块初始化事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__SysMenuChatBtnNoticeRefresh__", nil)
	--监听收到单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SysMenuChatBtnNoticeRefresh__", nil)
	--监听收到删除单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__SysMenuChatBtnNoticeRefresh__", nil)
	--监听收到增加单个私聊好友
	hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__SysMenuChatBtnNoticeRefresh__", nil)
	--监听收到删除单个私聊好友
	hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__SysMenuChatBtnNoticeRefresh__", nil)
	--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__SysMenuChatBtnNoticeRefresh__", nil)

	--清除timer
	hApi.clearTimer("__UI_RefreshTacticsState")
	hApi.clearTimer("__UI_RefreshBeginPointTip")
	hApi.clearTimer("__UI_RefreshTacticsCDLab")
	
	local x,y = hVar.SCREEN.w-486,hVar.SCREEN.h-5
	
	local btnScale = 1 
	if g_phone_mode ~= 0 then
		btnScale = 1.2
	end
	
	local nSpeedUpRate = 1			--加速的倍率
	local isCountdown = false		--是否倒计时状态
	local pauseFlag = -1			--弹出界面暂停控制
	local _showBagState = -1
	--如果当前游戏是暂停状态
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
			pauseFlag = 0
		end
	end
	
	local _frm				--父容器
	local _topBar				--顶部条
	local _bottomBar			--底部条
	
	--测试战术技能卡技能
	local selected_skill_id = 0 --选中的技能id
	local focus_ctrl = nil --焦点按钮
	--local bValidBlock = false --是否是有效的位置（对有效的地面点击才会判断）
	local __activeSkillNum = 0 --当前创建了多少个战术技能卡按钮
	local passiveSkillNum = 0 --被动战术技能卡数量
	local hoveredTower = nil  --选中的塔基
	local lastoUnit = nil --上一次拾取在鼠标上的塔
	local tankLiftNum = 0 --坦克数量
	
	local __CODE_ClickSpeedUpResume = hApi.DoNothing
	local __CODE_ClickStartPause = hApi.DoNothing
	local __CODE_ClickNextWave = hApi.Donothing
	local __updataWave = hApi.DoNothing
	local __updataLife = hApi.DoNothing
	local __updateGold2 = hApi.DoNothing
	local __updataCrystal = hApi.DoNothing
	local __updataLayer = hApi.DoNothing
	local __CODE_UnitReached = hApi.DoNothing
	local __CODE_UnitDefeated = hApi.DoNothing
	local __reduceTacticCD = hApi.DoNothing
	local __clearActiveTactic = hApi.DoNothing
	local __refreshTacticCDLab = hApi.DoNothing
	local __ShowTDAttackRange = hApi.DoNothing
	local __refreshTacticState = hApi.DoNothing
	local __CreateSingleActiveTacticCtrl = hApi.DoNothing
	local __UpdateSingleActiveTacticCtrl = hApi.DoNothing
	local __RemoveSingleActiveItemCtrl_logic = hApi.DoNothing
	local __RemoveSingleActiveItemCtrl = hApi.DoNothing
	local __createActiveTactics = hApi.DoNothing
	
	local on_refresh_chatbtn_notice = hApi.DoNothing --刷新聊天叹号提示
	local on_refresh_medal_state_ui = hApi.DoNothing

	local __popText = function(strText)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w/2,
			y = hVar.SCREEN.h/2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -500,
			moveY = 32,
		}):addtext(strText,hVar.FONTC,40,"MC",32,0)
	end

	--zhenkira pvpui pvp倒计时
	----刷新顶部剩余时间显示
	--local __refreshTopGameLastTime = function()
	--	local w = hGlobal.WORLD.LastWorldMap
	--	if w then
	--		local mapInfo = w.data.tdMapInfo
	--		
	--		--游戏暂停或结束，直接退出
	--		if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
	--			return
	--		end
	--		
	--		--地图信息存在
	--		if mapInfo then
	--			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式和挑战难度模式
	--				_frm.childUI["gameLastTime"].handle._n:setVisible(false)
	--			elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
	--				local lastTime = 0
	--				if mapInfo.gameTimeLimit > 0 then
	--					lastTime = math.floor((mapInfo.gameTimeLimit - w:gametime()) / 1000)
	--					if lastTime < 0 then
	--						lastTime = 0
	--					end
	--				end
	--				
	--				local min = math.floor(lastTime / 60)
	--				local sec = math.mod(lastTime, 60)
	--				
	--				_frm.childUI["gameLastTime"]:setText(tostring(min or 0) .. ":".. tostring(sec or 0))
	--				_frm.childUI["gameLastTime"].handle._n:setVisible(true)
	--			end
	--		end
	--	end
	--end
	
	
	--清除起点提示信息
	local __clearBeginPointTip = function()
		
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local mapInfo = w.data.tdMapInfo
			--地图信息存在
			if mapInfo then
				for tgrId, bpInfo in pairs(mapInfo.beginPointList) do
					hApi.safeRemoveT(_frm.childUI, "beginFlag_"..tgrId)
				end
			end
		end
		
	end
	
	--刷新出兵提示
	local __refreshBeginPointTip = function()
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		--地图信息存在
		if mapInfo then
			local totalWave = mapInfo.totalWave
			local wave = mapInfo.wave
			--波次
			if (wave + 1 <= totalWave) then
				local showFlagInfo = mapInfo.showFlagInfo[wave + 1]
				--遍历当前波次下所有起点
				for tgrId, num in pairs(showFlagInfo) do
					local beginPoint = mapInfo.beginPointList[tgrId]
					local uiName = "beginFlag_"..tgrId
					
					if wave == 0 then
						if num > 0 then
							beginPoint.showUnit:sethide(0)
						else
							beginPoint.showUnit:sethide(1)
						end
					else
						if isCountdown then
							--如果当前起点需要发兵，则创建ui
							if num > 0 then
								beginPoint.showUnit:sethide(0)
									
								
								--if not _frm.childUI[uiName] then
								--	_frm.childUI[uiName] = hUI.image:new({
								--		parent = _frm.handle._n,
								--		model = "ICON:BeginPoint",
								--		scale = 0.6,
								--		x = 0,
								--		y = 0,
								--		z = 0,
								--	})
								--	_frm.childUI[uiName].isHide = 1
								--	_frm.childUI[uiName].sideMark = nil
								--	_frm.childUI[uiName].handle._n:setVisible(false)
								--else
								--	--坐标移动
								--	local screenx, screeny = hApi.world2view(beginPoint.showPos.x, beginPoint.showPos.y) --大地图坐标转屏幕坐标
								--	
								--	--如果出兵点在屏幕内，则设置为隐藏
								--	if screenx > 0 and screenx < hVar.SCREEN.w and screeny > 0 and screeny < hVar.SCREEN.h then
								--		if _frm.childUI[uiName].isHide == 0 then
								--			_frm.childUI[uiName].isHide = 1
								--			_frm.childUI[uiName].sideMark = nil
								--			_frm.childUI[uiName].handle._n:setVisible(false)
								--		end
								--	else
								--		if (screenx < 50) then
								--			screenx = 50
								--			sideMark = -1
								--		elseif (screenx > (hVar.SCREEN.w - 50)) then
								--			screenx = hVar.SCREEN.w - 50
								--			sideMark = 1
								--		end
								--		
								--		if (screeny < 50) then
								--			screeny = 50
								--			sideMark = -2
								--		elseif (screeny > (hVar.SCREEN.h - 100)) then
								--			screeny = hVar.SCREEN.h - 100
								--			sideMark = -2
								--		end
										
								--		if _frm.childUI[uiName].isHide == 1 then
								--			_frm.childUI[uiName].isHide = 0
								--			_frm.childUI[uiName].handle._n:setVisible(true)
								--		end
										
								--		--不在一条边上, 动作幅度较大, 直接设置位置
								--		if not _frm.childUI[uiName].sideMark or (_frm.childUI[uiName].sideMark and _frm.childUI[uiName].sideMark ~= sideMark) then
								--			--直接设置
								--			_frm.childUI[uiName].sideMark = sideMark
								--			
								--			--设置角度
								--			--G_Tab.UI_NOTICE.Frame:setRotation(-angle)
								--			--设置位置
								--			_frm.childUI[uiName]:setXY(screenx, screeny)
										
								--		elseif (_frm.childUI[uiName].sideMark and _frm.childUI[uiName].sideMark == sideMark) then
								--			--做动画
								--			_frm.childUI[uiName].handle._n:stopAllActions()
								--			
								--			--改为旋转到达
								--			--G_Tab.UI_NOTICE.Frame:setRotation(-angle)
								--			--local rotTo = CCRotateTo:create(0.5, -angle) --time, angle
								--			--G_Tab.UI_NOTICE.Frame:runAction(rotTo)
								--			
								--			--改为移动到达
								--			local moveTo = CCMoveTo:create(0.5, ccp(screenx, screeny)) --time, count
								--			_frm.childUI[uiName].handle._n:runAction(moveTo)
								--		end
								--		
								--	end
								--end
							else
								beginPoint.showUnit:sethide(1)
								--if _frm.childUI[uiName] then
								--	if _frm.childUI[uiName].isHide == 0 then
								--		_frm.childUI[uiName].isHide = 1
								--		_frm.childUI[uiName].sideMark = nil
								--		_frm.childUI[uiName].handle._n:setVisible(false)
								--	end
								--end
							end
						else	
							beginPoint.showUnit:sethide(1)
							--if _frm.childUI[uiName] then
							--	if _frm.childUI[uiName].isHide == 0 then
							--		_frm.childUI[uiName].isHide = 1
							--		_frm.childUI[uiName].sideMark = nil
							--		_frm.childUI[uiName].handle._n:setVisible(false)
							--	end
							--end
						end
					end
				end
			
			else
				for tgrId, bpInfo in pairs(mapInfo.beginPointList) do
					if bpInfo.showUnit then
						bpInfo.showUnit:sethide(1)
					end
					--local uiName = "beginFlag_"..tgrId
					--if _frm.childUI[uiName] then
					--	if _frm.childUI[uiName].isHide == 0 then
					--		_frm.childUI[uiName].isHide = 1
					--		_frm.childUI[uiName].sideMark = nil
					--		_frm.childUI[uiName].handle._n:setVisible(false)
					--	end
					--end
				end
			end
		end
	end
	
	--创建剩余生命显示面板
	local __createUILife = function (parentFrm)
		local _parentN = parentFrm.handle._n
		
		--剩余生命
		parentFrm.childUI["nodLife"] = hUI.node:new({
			parent = _parentN,
			x = 50 - 200, --大菠萝不显示
			y = -5,
			child = {
				--{
				--	__UI = "image",
				--	__NAME = "imgBg",
				--	model = "UI:td_mui_toptxtbg",
				--	x = 0,
				--	y = 0,
				--	w = 100,
				--	h = 40,
				--	z = 0,
				--},
				{
					__UI = "image",
					__NAME = "imgflag",
					--model = "UI:td_mui_life",
					--model = "UI:Attr_Hp",
					model = "ui/Attr_Hp.png",
					x = -20,
					y = 0,
					z = 1,
					scale = 0.6,
				},
				{
					__UI = "label",
					__NAME = "labLife",
					align = "MC",
					size = 22,
					x = 10,
					y = 0,
					border = 1,
					z = 2,
					--color = {128, 255, 128},
					text = " "..tostring(0).." ",
				},
			},
		})
		local nodLife = parentFrm.childUI["nodLife"]
		
		--todo:去掉
		--hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/td_mui_toptxtbg.png", 1, 0, 100, 40, nodLife)
		
		--nodLife.childUI["hpBar"] = hUI.valbar:new({
		--	parent = nodLife.handle._n,
		--	x = 0,
		--	y = 0,
		--	z = 0,
		--	w = 69,
		--	h = 30,
		--	align = "LC",
		--	back = {model = "UI:td_mui_toptxtbg",x=-5,y=0,w=79,h=41},
		--	model = "UI:td_mui_rdbar",
		--	v = 100,
		--	max = 100,
		--})
		
		return nodLife.childUI["labLife"]--, nodLife.childUI["hpBar"]
	end
	
	--创建剩余金钱显示面板2
	local __createUIGold2 = function (parentFrm)
		local _parentN = parentFrm.handle._n
		
		local ox = hVar.SCREEN.offx + 150
		local oy = -16
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			ox = 150
			oy = -50-16
		end
		--剩余金钱
		parentFrm.childUI["nodGold"] = hUI.node:new({
			parent = _parentN,
			x = ox - 20,
			y = oy,
			child = {
				{
					__UI = "image",
					__NAME = "bg",
					model = "UI:selectbg",
					x = 0,
					y = 0,
					z = 1,
					w = 200,
					h = 36,
				},
				{
					__UI = "image",
					__NAME = "imgflag",
					--model = "UI:td_mui_gold",
					--model = "UI:ICON_main_frm_ResourceGold",
					model = "misc/skillup/mu_coin.png",
					x = -70,
					y = 0,
					z = 1,
					scale = 0.9,
				},
				{
					__UI = "label",
					__NAME = "labGold",
					align = "LC",
					size = 22,
					font = "numWhite",
					x = -30,
					y = 0,
					z = 2,
					border = 1,
					text = 0,
				},
			},
		})
		
		local nodGold = parentFrm.childUI["nodGold"]
		nodGold.childUI["labGold"].handle.s:setColor(ccc3(0, 255, 255))
		
		--hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/td_mui_toptxtbg.png", 0, 0, 100, 40, nodGold)
		
		return nodGold.childUI["labGold"]
	end
	
	--创建剩余水晶显示面板
	local __createUICrystal = function (parentFrm)
		local _parentN = parentFrm.handle._n
		local oy = 0
		local ox = hVar.SCREEN.offx
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			oy = -50
			ox = 0
		end
		parentFrm.childUI["nodCrystal"] = hUI.node:new({
			parent = _parentN,
			x = 150 + ox,
			y = - 16 + oy,
			child = {
				{
					__UI = "image",
					__NAME = "bg",
					model = "UI:selectbg",
					x = 0,
					y = 0,
					z = 1,
					w = 200,
					h = 36,
				},
				{
					__UI = "image",
					__NAME = "imgflag",
					model = "misc/skillup/mu_coin.png",
					x = -90,
					y = 0,
					z = 1,
				},
				{
					__UI = "label",
					__NAME = "labCrystal",
					align = "LC",
					size = 22,
					font = "num",
					x = -30,
					y = 0,
					z = 2,
					border = 1,
					text = "",
				},
			},
		})
		return parentFrm.childUI["nodCrystal"].childUI["labCrystal"]
	end

	local _showUIComment = function(parentFrm)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld == nil then
			return
		end
		local mapInfo = oWorld.data.tdMapInfo
		if (not mapInfo) then
			return
		end

		if parentFrm.childUI["Comment"] then
			if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) then
					if oWorld.data.map ~= hVar.GuideMap then
						parentFrm.childUI["Comment"]:setstate(1)
						return
					end
				end
			end
			parentFrm.childUI["Comment"]:setstate(-1)
		end
	end
	
	local _createUIBag = function(parentFrm)
		local oy = 0
		local ox = hVar.SCREEN.offx
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			oy = -50
			ox = 0 
		end
		local _parentN = parentFrm.handle._n
		parentFrm.childUI["bag"] = hUI.button:new({
			parent = _parentN,
			dragbox = parentFrm.childUI["dragBox"],
			model = "misc/tempbag/iconbag.png",
			x = 70 + ox,
			y = hVar.SCREEN.h - 190 + oy,
			scaleT = 0.95,
			code = function()
				hGlobal.event:event("localEvent_ShowGameTempBagFrm")
			end,
		})
		parentFrm.childUI["bag"]:setstate(-1)
	end
	
	local __createUILayer = function(parentFrm)
		local _parentN = parentFrm.handle._n
		local oy = 0
		local ox = hVar.SCREEN.w / 2
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			oy = -50
			ox = hVar.SCREEN.w / 2
		end
		
		parentFrm.childUI["nodLayer"] = hUI.node:new({
			parent = _parentN,
			x = ox,
			y = - 16 + oy,
			child = {
				{
					__UI = "label",
					__NAME = "labLayer",
					align = "MC",
					size = 30,
					font = "num",
					x = 0,
					y = 0,
					z = 2,
					border = 1,
					text = "",
				},
			},
		})
		return parentFrm.childUI["nodLayer"].childUI["labLayer"]
	end
	
	--创建剩余mana显示面板(波次)
	local __createUIMana = function (parentFrm)
		local _parentN = parentFrm.handle._n
		
		--local ox = hVar.SCREEN.offx + 150
		--local oy = 30
		local ox = hVar.SCREEN.offx + 150 + 200 --横板
		local oy = -70 + 54
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			ox = 150  + 200 --竖版
			oy = -50+30 - 46 -- - 90
		end
		--剩余mana(波次)
		parentFrm.childUI["nodMana"] = hUI.node:new({
			parent = _parentN,
			x = ox,
			y = oy,
			child = {
				{
					__UI = "image",
					__NAME = "bg",
					model = "UI:selectbg",
					x = 0,
					y = 0,
					z = 1,
					w = 200,
					h = 36,
				},
				{
					__UI = "label",
					__NAME = "labManaTip",
					align = "RC",
					size = 26,
					x = -50,
					y = 0,
					z = 2,
					font = hVar.FONTC,
					border = 1,
					--text = "波次", --language
					--text = hVar.tab_string["__ATTR__Wave"], --language
					text = "", --language
				},
				{
					__UI = "image",
					__NAME = "imgflag",
					model = "misc/wave_icon.png",
					x = -70,
					y = 0,
					z = 1,
				},
				{
					__UI = "label",
					__NAME = "labMana",
					align = "LC",
					size = 22,
					x = -30,
					y = 0,
					z = 2,
					border = 1,
					font = "numWhite",
					text = "",
				},
			},
		})
		local nodMana = parentFrm.childUI["nodMana"]
		
		--[[
		hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/td_mui_toptxtbg.png", 0, 0, 193, 40, nodMana)
		]]
		
		--nodMana.childUI["manaBar"] = hUI.valbar:new({
		--	parent = nodMana.handle._n,
		--	x = 0,
		--	y = 0,
		--	z = 0,
		--	w = 69,
		--	h = 30,
		--	align = "LC",
		--	back = {model = "UI:td_mui_toptxtbg",x=-5,y=0,w=79,h=41},
		--	model = "UI:td_mui_ldbar",
		--	v = 100,
		--	max = 100,
		--})
		
		return nodMana.childUI["labMana"]--, nodMana.childUI["manaBar"] 
	end
	
	--[[
	--创建游戏得分面板
	local __createUIScore = function (parentFrm)
		local _parentN = parentFrm.handle._n
		
		--游戏得分
		parentFrm.childUI["nodScore"] = hUI.node:new({
			parent = _parentN,
			x = 98 + 193,
			y = -38,
			child = {
				--{
				--	__UI = "image",
				--	__NAME = "imgBg",
				--	model = "UI:td_mui_toptxtbg",
				--	x = 0,
				--	y = 0,
				--	w = 183,
				--	h = 40,
				--	z = 0,
				--},
				{
					__UI = "image",
					__NAME = "imgflag",
					--model = "UI:td_mui_mana",
					--model = "ICON:HeroAttr_leadship",
					model = "ui/pvp/attr_leadship.png",
					x = -55,
					y = -1,
					z = 1,
					scale = 0.4,
				},
				{
					__UI = "label",
					__NAME = "labScoreTip",
					align = "LC",
					size = 24,
					x = -38,
					y = -2,
					z = 2,
					font = hVar.FONTC,
					border = 1,
					--text = "波次", --language
					text = hVar.tab_string["__ATTR__Wave"], --language
				},
				{
					__UI = "label",
					__NAME = "labScore",
					align = "LC",
					size = 22,
					x = 20,
					y = 0,
					z = 2,
					border = 1,
					text = " "..tostring(0).." ",
				},
			},
		})
		local nodScore = parentFrm.childUI["nodScore"]
		
		hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/td_mui_toptxtbg.png", 0, 0, 193, 40, nodScore)
		
		--nodScore.childUI["manaBar"] = hUI.valbar:new({
		--	parent = nodScore.handle._n,
		--	x = 0,
		--	y = 0,
		--	z = 0,
		--	w = 69,
		--	h = 30,
		--	align = "LC",
		--	back = {model = "UI:td_mui_toptxtbg",x=-5,y=0,w=79,h=41},
		--	model = "UI:td_mui_ldbar",
		--	v = 100,
		--	max = 100,
		--})
		
		return nodScore.childUI["labScore"] 
	end
	]]
	
	--寻找塔基
	local __SearchTowerBase = function(towerBaseId)
		local units = {} --塔基集
		local effects = {} --特效集
		
		--遍地地图上的所有单位
		local world = hGlobal.WORLD.LastWorldMap
		world:enumunit(function(eu)
			local typeId = eu.data.id --类型id
			if (typeId == towerBaseId) then --塔基
				--插入塔基集表
				table.insert(units, eu)
				
				local eu_x, eu_y = hApi.chaGetPos(eu.handle)
				local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --塔基的包围盒
				local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --塔基的中心点x位置
				local eu_center_y = eu_y + (eu_by + eu_bh / 2) --塔基的中心点y位置
					
				--高亮特效
				local effect_id1 = 7 --特效id
				local eff1 = world:addeffect(effect_id1, 0 ,nil, eu_center_x, eu_center_y) --56
				table.insert(effects, eff1)
				
				--[[
				--光照特效
				local effect_id2 = 142 --特效id2
				local eff2 = world:addeffect(effect_id2, 0 ,nil, eu_center_x, eu_center_y) --56
				table.insert(effects, eff2)
				]]
			end
		end)
		
		return units, effects
	end
	
	--寻找一个塔基
	local __SearchFirstTowerBase = function(towerBaseId)
		--遍地地图上的所有单位
		local world = hGlobal.WORLD.LastWorldMap
		local oUnit = nil
		world:enumunit(function(eu)
			local typeId = eu.data.id --类型id
			if (typeId == towerBaseId) then --塔基
				oUnit = eu
				return
			end
		end)
		return oUnit
	end
	
	--单位激活时显示攻击范围圈
	__ShowTDAttackRange = function(oUnit, atkRange, atkRangeMin)
		--print("__ShowTDAttackRange 2")
		--不重复创建
		if oUnit and oUnit.chaUI["TD_AtkRange"] then
			--print("不重复创建")
			return
		end
		
		--传入nil表示清空
		if (not oUnit) then
			if lastoUnit then
				hApi.safeRemoveT(lastoUnit.chaUI, "TD_AtkRange")
			end
		end
		
		--传入不同的角色，清除上一次的
		if oUnit and  lastoUnit and (oUnit ~= lastoUnit) then
			hApi.safeRemoveT(lastoUnit.chaUI, "TD_AtkRange")
		end
		
		--空角色
		if (not oUnit) or (not atkRange) or (atkRange <= 0) then
			--print("空角色", oUnit, atkRange)
			return
		end
		
		--如果是塔显示攻击范围
		local eu_bx, eu_by, eu_bw, eu_bh = oUnit:getbox() --包围盒
		local eu_dx = eu_bx + eu_bw / 2 --中心点偏移x位置
		local eu_dy = eu_by + eu_bh / 2 --中心点偏移y位置
		oUnit.chaUI["TD_AtkRange"] = hUI.image:new({
			parent = oUnit.handle._n,
			model = "MODEL_EFFECT:SelectCircle",
			animation = "range",
			x = eu_dx,
			y = eu_dy,
			z = -255,
			w = atkRange * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
			color = {128, 255, 128},
			alpha = 48,
		})
		
		local scale = math.min(0.98, (atkRange - 4) / atkRange)
		local a = CCScaleBy:create(1, scale, scale)
		local aR = a:reverse()
		local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR), "CCActionInterval")
		oUnit.chaUI["TD_AtkRange"].handle._n:runAction(CCRepeatForever:create(seq))
		
		local program = nil
		if (oUnit:getowner() == oUnit:getworld():GetPlayerMe()) then --我操控的塔，显示绿色
			--显示最小攻击范围
			local atkRangeMin = oUnit:GetAtkRangeMin()
			if (atkRangeMin < 0) then
				atkRangeMin = 0
			end
				
			local scale = atkRangeMin / atkRange / 1.11
			
			program = hApi.getShader("atkrange1", 3) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
			local resolution = program:glGetUniformLocation("resolution")
			program:setUniformLocationWithFloats(resolution,66,66)
			
			local rr = program:glGetUniformLocation("rr")
			local gg = program:glGetUniformLocation("gg")
			local bb = program:glGetUniformLocation("bb")
			program:setUniformLocationWithFloats(rr, 0.2)
			program:setUniformLocationWithFloats(gg, 0.67)
			program:setUniformLocationWithFloats(bb, 0.5)
			
			--显示最小攻击范围
			--print("scale=", scale)
			local inner_r = program:glGetUniformLocation("inner_r")
			program:setUniformLocationWithFloats(inner_r, scale)
		elseif (oUnit:getowner():getforce() == oUnit:getworld():GetPlayerMe():getforce()) then --友军塔，显示黄色
			--显示最小攻击范围
			local atkRangeMin = oUnit:GetAtkRangeMin()
			if (atkRangeMin < 0) then
				atkRangeMin = 0
			end
			
			local scale = atkRangeMin / atkRange / 1.11
			
			program = hApi.getShader("atkrange1", 2, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
			local resolution = program:glGetUniformLocation("resolution")
			program:setUniformLocationWithFloats(resolution,66,66)
			
			local rr = program:glGetUniformLocation("rr")
			local gg = program:glGetUniformLocation("gg")
			local bb = program:glGetUniformLocation("bb")
			program:setUniformLocationWithFloats(rr, 1.0)
			program:setUniformLocationWithFloats(gg, 1.0)
			program:setUniformLocationWithFloats(bb, 0.0)
			
			--显示最小攻击范围
			--print("scale=", scale)
			local inner_r = program:glGetUniformLocation("inner_r")
			program:setUniformLocationWithFloats(inner_r, scale)
		else --敌方塔，显示红色
			--显示最小攻击范围
			local atkRangeMin = oUnit:GetAtkRangeMin()
			if (atkRangeMin < 0) then
				atkRangeMin = 0
			end
				
			local scale = atkRangeMin / atkRange / 1.11
			
			program = hApi.getShader("atkrange1", 3) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
			local resolution = program:glGetUniformLocation("resolution")
			program:setUniformLocationWithFloats(resolution,66,66)
			
			local rr = program:glGetUniformLocation("rr")
			local gg = program:glGetUniformLocation("gg")
			local bb = program:glGetUniformLocation("bb")
			program:setUniformLocationWithFloats(rr, 1.0)
			program:setUniformLocationWithFloats(gg, 0.0)
			program:setUniformLocationWithFloats(bb, 0.0)
			
			--显示最小攻击范围
			--print("scale=", scale)
			local inner_r = program:glGetUniformLocation("inner_r")
			program:setUniformLocationWithFloats(inner_r, scale)
		end
		
		oUnit.chaUI["TD_AtkRange"].handle.s:setShaderProgram(program)
		
		
		
		lastoUnit = oUnit --存储
		--print("lastoUnit = oUnit --存储")
	end
	
	--刷新战术技能卡cd
	__refreshTacticCDLab = function()
		--print("__refreshTacticCDLab")
		local parentFrm = _frm
		local cddown = 0.1
		
		local __activeSkillNum = __activeSkillNum --只读
		for i = 1, __activeSkillNum, 1 do
			local btn = parentFrm.childUI["btnTactics_"..i]
			if btn then
				local cd = btn.data.tacticCD
				local labCD = btn.data.labCD or 0
				if (labCD > 0) then
					btn.data.labCD = btn.data.labCD - cddown
					
					--更新数字显cd文字
					if btn.childUI["labCd"] then
						local cdnow = labCD - cddown
						cdnow = math.floor(cdnow * 10) / 10 --保留1位有效数字
						if (cdnow < 0) then
							cdnow = 0
						end
						
						if (cdnow > 0) then
							cdnow = string.format("%.1f", cdnow)
						end
						
						btn.childUI["labCd"]:setText(cdnow)
					end
					if btn.childUI["cd"] then
						local per = 0
						if cd > 0 then
							per = 100 - ((labCD - cddown) / cd) * 100
						end
						btn.childUI["cd"]:setPercentage(per)
					end
					if btn.childUI["cd_bolder"] then
						local per = 0
						if cd > 0 then
							per = 100 - ((labCD - cddown) / cd) * 100
						end
						btn.childUI["cd_bolder"]:setPercentage(per)
					end
				else
					if btn.data.tacticCastTime and (btn.data.tacticCastTime > 0) then
						btn.data.tacticCastTime = 0
						
						--if btn.childUI["cd"] then
						--	btn.childUI["cd"].handle.s:setColor(ccc3(255, 255, 255))
						--end
						
						if btn.childUI["cd_bolder"] then
							btn.childUI["cd_bolder"].handle._n:setVisible(false)
						end
						if btn.childUI["cd_ok"] then
							btn.childUI["cd_ok"].handle._n:setVisible(true)
							--print("cd_ok false 12")
						end
						
						--数字显使用次数
						if btn.childUI["labSkillUseCount"] then
							btn.childUI["labSkillUseCount"]:setText(btn.data.useCount)
						end
						
						btn.handle._n:setScale(1.0)
					end
					--btn.data.tacticCD = activeSkillCD
				end
			end
		end
	end
	
	--刷新战术技能卡按钮状态
	__refreshTacticState = function()
		local world = hGlobal.WORLD.LastWorldMap
		local parentFrm = _frm
		local timeNow = world:gametime()
		local goldNow = 0
		--if world then
		--	local mapInfo = world.data.tdMapInfo
		--	if mapInfo then
		--		goldNow = mapInfo.gold or 0
		--	end
		--end
		local me = world:GetPlayerMe()
		if me then
			goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
		end
		local __activeSkillNum = __activeSkillNum --只读
		--print("刷新战术技能卡按钮状态", __activeSkillNum)
		for i = 1, __activeSkillNum do
			local btn = parentFrm.childUI["btnTactics_"..i]
			if btn then
				local castTime = btn.data.tacticCastTime
				local cd = btn.data.tacticCD
				local cost = btn.data.cost or 0
				local state = btn.data.laststate or 1
				local useLimit = btn.data.useLimit or -1
				--print("i = " .. i,castTime, cd, cost, state, useLimit)
				
				--print("____________________________refreshTacticState:".. tostring(castTime).. "," .. tostring(goldNow).. ",".. tostring(useLimit).. ",".. tostring(state))
				if (not castTime or castTime == 0) and goldNow >= cost and (useLimit == -1 or useLimit >= 0) then
					--if btn.data.state ~= 1 then --zhenkira测试用，每次点下都会触发特效
					if state ~= 1 then
						btn:setstate(1)
						btn.data.laststate = 1
						
						if btn.childUI["icon"] then
							hApi.AddShader(btn.childUI["icon"].handle.s,"normal")
						end
						
						if btn.childUI["tacticType"] then
							hApi.AddShader(btn.childUI["tacticType"].handle.s,"normal")
						end
						
						if btn.childUI["useLimitBg"] then
							--hApi.AddShader(btn.childUI["useLimitBg"].handle.s,"normal")
							btn.childUI["useLimitBg"].handle.s:setColor(ccc3(255, 255, 255))
						end
						
						--更新数字显cd文字
						if btn.childUI["labCd"] then
							btn.childUI["labCd"]:setText("0")
							btn.childUI["labCd"].handle._n:setVisible(false)
						end
						
						if btn.childUI["cd"] then
							btn.childUI["cd"]:setPercentage(100)
						end
						if btn.childUI["cd_bolder"] then
							btn.childUI["cd_bolder"].handle._n:setVisible(false)
						end
						if btn.childUI["cd_ok"] then
							btn.childUI["cd_ok"].handle._n:setVisible(true)
							--print("cd_ok true 1")
						end
						
						--print("手雷的双雷图标替换")
						--手雷的双雷图标替换
						if btn.childUI["labSkillUseMultiply"] then
							if (btn.data.useCount > 1) then
								--手雷图标
								btn.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
							else
								--手雷图标
								btn.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
							end
						end
						
						--print(useLimit)
						--大菠萝数量为0时灰掉
						if (useLimit == 0) then
							if btn.childUI["icon"] then
								hApi.AddShader(btn.childUI["icon"].handle.s,"gray")
							end
							if btn.childUI["cd"] then
								btn.childUI["cd"]:setPercentage(0)
							end
							if btn.childUI["cd_bolder"] then
								btn.childUI["cd_bolder"].handle._n:setVisible(true)
							end
							if btn.childUI["cd_ok"] then
								btn.childUI["cd_ok"].handle._n:setVisible(false)
								--print("cd_ok false 2")
							end
						end
						
						--pad的尺寸
						local scale = 2.8
						
						if g_phone_mode ~= 0 then
							scale = 3.4
						end
						
						--创建一个一次性特效
						--[[
						--大菠萝不要了
						local time = world:gametime()
						local btnName = "cardOutline_"..tostring(time).."_".. tostring(i)
						btn.childUI[btnName] = hUI.image:new({
							parent = btn.handle._n,
							model = "MODEL_EFFECT:strengthen",
							x = 0,
							y = 0,
							z = 2,
							w = 64,
							h = 64,
							scale = scale,
						})
						local timerName = "OutLine_btnTactics_"..tostring(time).."_".. tostring(i)
						hApi.addTimerOnce(timerName,950,function()
							hApi.safeRemoveT(btn.childUI,btnName)
						end)
						]]
					end
				else
					if state ~= 0 then
						btn:setstate(0)
						btn.data.laststate = 0
						btn.data.temp_scale = btn.data.scale
						
						--geyachao: 战车手雷技能不能缩放，会缩放异常？
						if (i ~= hVar.TANKSKILL_IDX) then
							btn.handle._n:setScale(btn.data.scale * 0.83)
						end
						
						if btn.childUI["icon"] then
							hApi.AddShader(btn.childUI["icon"].handle.s,"gray")
						end
						if btn.childUI["tacticType"] then
							hApi.AddShader(btn.childUI["tacticType"].handle.s,"gray")
						end
						
						if btn.childUI["useLimitBg"] then
							--hApi.AddShader(btn.childUI["useLimitBg"].handle.s,"gray")
							btn.childUI["useLimitBg"].handle.s:setColor(ccc3(128, 128, 128))
						end
						
						--更新数字显cd文字
						if btn.childUI["labCd"] then
							btn.childUI["labCd"]:setText(tostring(cd))
							btn.childUI["labCd"].handle._n:setVisible(true)
						end
						
						if btn.childUI["cd"] then
							btn.childUI["cd"]:setPercentage(0)
						end
						if btn.childUI["cd_bolder"] then
							btn.childUI["cd_bolder"].handle._n:setVisible(true)
						end
						if btn.childUI["cd_ok"] then
							btn.childUI["cd_ok"].handle._n:setVisible(false)
							--print("cd_ok false 3")
						end
					end
				end
			end
		end
	end
	
	--重置战术技能卡cd
	__reduceTacticCD = function(reduceTime)
		local parentFrm = _frm
		local world = hGlobal.WORLD.LastWorldMap
		local timeNow = world:gametime()
		local __activeSkillNum = __activeSkillNum --只读
		for i = 1, __activeSkillNum do
			local btn = parentFrm.childUI["btnTactics_"..i]
			if btn then
				local castTime = btn.data.tacticCastTime
				local cd = btn.data.tacticCD
				if castTime and cd and castTime > 0 then
					local pastTimePercent = (timeNow - castTime) / (cd * 1000) --已经经过的时间占cd的百分比
					local reducePercent = reduceTime / (cd * 1000) --减少的时间占cd的百分比
					local leftPercent = (pastTimePercent + reducePercent) * 100 --剩余还需要的时间占cd的百分比
					local lefttime = ((cd  * 1000) - ((timeNow - castTime) + reduceTime)) / 1000 --剩余还需要的时间
					
					--print("__reduceTacticCD:".. tostring(pastTimePercent).. tostring(reducePercent).. tostring(leftPercent).. tostring(lefttime))
					--如果剩余百分比大于100，则为100
					if (leftPercent > 100) then
						leftPercent = 100
					elseif (leftPercent < 0) then
						leftPercent = 0
					end
					if (lefttime < 0) then
						lefttime = 0
					elseif (lefttime > cd) then
						lefttime = cd
					end
					
					--重新设置起始释放时间 --zhenkira 2015.12.4,不需要重置
					--btn.data.tacticCastTime = btn.data.tacticCastTime + reduceTime
					
					--print("__reduceTacticCD final:".. tostring(leftPercent).. tostring(lefttime))
					if btn.childUI["cd"] then
						btn.childUI["cd"]:start(lefttime, leftPercent, 100)
					end
				end
			end
		end
	end
	
	--清除主动战术技能卡
	__clearActiveTactic = function(parentFrm)
		--print("__clearActiveTactic:"..__activeSkillNum)
		selected_skill_id = 0
		focus_ctrl = nil
		--bValidBlock = false --是否是有效的位置（对有效的地面点击才会判断）
		
		--local __activeSkillNum = __activeSkillNum
		for i = 1, __activeSkillNum do
			hApi.safeRemoveT(parentFrm.childUI, "btnTactics_"..i)
			hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_"..i)
		end
		__activeSkillNum = 0
	end
	
	--玩家使用战术(道具)技能卡（同步）
	function hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, worldX, worldY, t_worldI, t_worldC, iTag)
		--print("hApi.UsePlayerTacticCard", tacticId, itemId, worldX, worldY, t_worldI, t_worldC, iTag)
		
		--防止弹框
		if (not oPlayer) then
			return
		end
		
		--无效的oPlayer
		if (not oPlayer.getpos) then
			return
		end
		
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		
		--参数
		local activeIndex = 0 --位置索引值
		local selected_skill_id = 0
		local activeSkillLv = 0 --等级
		local activeSkillNum = 0 --使用次数
		local activeSkillType = 0
		local activeSkillRange = 0
		local activeSkillCD = 0 --原始CD（单位:秒）
		local activeSkillCostMana = 0
		local activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
		local activeSkillDeadUnUse = 0 --此战术技能卡在英雄死后是否禁用
		local activeSkillLastCastTime = -math.huge --上次施法时间（单位:毫秒）
		local activeItemSkillT = nil --道具技能表
		
		if (tacticId) and (tacticId ~= 0) then --战术技能卡
			local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
			local tabT = nil --战术技能表
			local lv = 0
			local typeId = 0
			
			for i = 1, #tTactics, 1 do
				--print(i, "tTactics[i]=", tTactics[i])
				if (tTactics[i] ~= 0) then
					local id = tTactics[i][1]--geyachao: 该战术技能卡是哪个英雄的
					lv = tTactics[i][2] --geyachao: 该战术技能卡是哪个英雄的
					typeId = tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
					
					if (id == tacticId) then
						tabT = hVar.tab_tactics[id]
						break
					end
				end
			end
			
			--无效的战术技能卡id
			if (tabT == nil) then
				return
			end
			
			activeIndex = 0 --位置索引值
			selected_skill_id = tabT.activeSkill.id
			activeSkillLv = lv --等级
			activeSkillNum = tabT.activeSkill.count or -1 --使用次数
			activeSkillType = tabT.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
			activeSkillRange = tabT.activeSkill.effectRange[lv] or 0
			activeSkillCD = tabT.activeSkill.cd[lv] or 0 --原始CD（单位:秒）
			activeSkillCostMana = tabT.activeSkill.costMana[lv] or 0
			activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
			activeSkillDeadUnUse = tabT.activeSkill.deadUnUse or 0 --此战术技能卡在英雄死后是否禁用
			
			--读取英雄身上的减cd
			--print("typeId=", typeId)
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				if (oHero.data.id == typeId) then
					activeIndex = j
					activeSkillBindHero = oHero
					activeSkillCD = activeSkillBindHero.data.activeSkillCD
					activeSkillLastCastTime = oHero.data.activeSkillLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					
					--print("activeSkillCD=", activeSkillCD)
					local tactics = activeSkillBindHero:gettactics()
					for k = 1, #tactics, 1 do
						local tactic = tactics[k]
						if tactic then
							local tacticIdk = tactic.id or 0
							local tacticLvk = tactic.lv or 1
							if (tacticId == tacticIdk) then
								activeSkillLv = tacticLvk --读取英雄的等级
								--print("读取英雄的等级=", activeSkillLv)
								break
							end
						end
					end
					
					break
				end
			end
			--print("activeSkillLv=", activeSkillLv)
			
			--如果该战术卡不属于英雄
			if (activeIndex == 0) then
				local idx = 0
				for i = 1, #tTactics, 1 do
					if (tTactics[i] ~= 0) then
						local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
						local tabT = hVar.tab_tactics[id]
						local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
						if tabT then
							--local name = tabT.name --战术技能卡的名字
							--print(i, name, typeId)
							if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
								local activeSkill = tabT.activeSkill
								local passiveSkill = tabT.skillId
								if activeSkill and (type(activeSkill) == "table") then
									idx = idx + 1
									if (id == tacticId) then
										break
									end
								end
							end
						end
					end
				end
				activeIndex = idx + hVar.TANKSKILL_EMPTY
			end
		elseif (itemId) and (itemId ~= 0) then --道具技能卡
			local tabI = hVar.tab_item[itemId]
			--LuaAddItemToPlayerBag(itemId,nil,nil,0)
			
			--无效的道具技能卡id
			if (tabI == nil) then
				return
			end
			
			local nItemPivot = 0
			
			--遍历该玩家的全部英雄，找到此道具技能属于哪个英雄
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					for k = 1, #itemSkillT, 1 do
						--位置加1
						nItemPivot = nItemPivot + 1
						
						local activeItemId = itemSkillT[k].activeItemId --主动技能的id
						local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
						local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
						local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
						local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
						
						--如果该技能是手雷，读取坦克的手雷cd
						--print(oHero.data.id)
						if (oHero.data.id == hVar.MY_TANK_ID) then --我的坦克
							local oUnit = oHero:getunit()
							if oUnit then
								local tankItemId = hVar.tab_unit[hVar.MY_TANK_ID].skillItemlId
								if (tankItemId == activeItemId) then --找到了
									local cd = oUnit:GetGrenadeCD()
									--print("cd=", cd)
									activeItemCD = cd / 1000 --更新主动技能的CD
								end
							end
						end
						
						if (activeItemId == itemId) then --找到了
							local TacticTotalNum = 0
							local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
							for i = 1, #tTactics, 1 do
								if (tTactics[i] ~= 0) then
									local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
									local tabT = hVar.tab_tactics[id]
									local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
									if tabT then
										--local name = tabT.name --战术技能卡的名字
										--print(i, name, typeId)
										if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
											local activeSkill = tabT.activeSkill
											local passiveSkill = tabT.skillId
											if activeSkill and (type(activeSkill) == "table") then
												TacticTotalNum = TacticTotalNum + 1
											end
										end
									end
								end
							end
							
							activeIndex = TacticTotalNum + nItemPivot + hVar.TANKSKILL_EMPTY --位置索引值
							selected_skill_id = tabI.activeSkill.id
							activeSkillLv = activeItemLv --等级
							activeSkillNum = activeItemNum --使用次数
							activeSkillType = tabI.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
							activeSkillRange = tabI.activeSkill.effectRange[activeItemLv] or 0
							activeSkillCD = activeItemCD or 0 --原始CD（单位:秒）
							activeSkillCostMana = tabI.activeSkill.costMana[activeItemLv] or 0
							activeSkillBindHero = oHero --此道具技能卡绑定的英雄对象
							activeSkillDeadUnUse = tabI.activeSkill.deadUnUse or 0 --此道具技能卡在英雄死后是否禁用
							activeSkillLastCastTime = activeItemLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							activeItemSkillT = itemSkillT[k]
							
							break
						end
					end
				end
			end
			
			--不存在的道具卡id
			if (activeIndex == 0) then
				return
			end
		end
		
		hGlobal.event:event("Event_UnitUseItem",itemId)
		--print("activeIndex=", activeIndex, "activeSkillBindHero=", activeSkillBindHero)
		
		--战术技能卡控件(本地)
		local card = nil
		if me and (me == oPlayer) then
			local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
			card = tacticCardCtrls[activeIndex]
		end
		
		--取施法者
		--local oUnit = mapInfo.godUnit --默认是上帝施法
		local oUnit = oPlayer:getgod() --默认是上帝施法
		--geyachao: 如果该战术技能绑定的英雄，并且是只有死后禁用类型的，才取英雄的单位，以他作为施法者
		if (activeSkillDeadUnUse == 1) then
			if activeSkillBindHero and (activeSkillBindHero ~= 0) then
				local unit = activeSkillBindHero:getunit()
				if unit and (unit ~= 0) and (unit.data.IsDead ~= 1) then
					oUnit = unit
				else --绑定英雄释放的战术卡，英雄对应的单位死了，那么不能施法
					--print("绑定英雄释放的战术卡，英雄对应的单位死了，那么不能施法")
					return
				end
			else --绑定英雄释放的战术卡，没有英雄，那么不能施法
				--print("绑定英雄释放的战术卡，没有英雄，那么不能施法")
				return
			end
		end
		
		--如果施法者被沉默，不能使用战术技能
		if (oUnit.attr.suffer_chenmo_stack > 0) then
			--print("如果施法者被沉默，不能使用战术技能")
			return
		end
		
		--如果英雄身上存cd，cd未到，不能施法
		if activeSkillBindHero and (activeSkillBindHero ~= 0) then
			--local activeSkillLastCastTime = activeSkillBindHero.data.activeSkillLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
			--print(activeSkillCD, activeSkillCD * 1000 + activeSkillLastCastTime, world:gametime())
			if (world:gametime() < (activeSkillCD * 1000 + activeSkillLastCastTime)) then
				--print("xxxx 技能未cd")
				return
			else
				--print("xxxx 技能释放成功！")
			end
		end

		--统计战术卡使用次数
		if card then
			hGlobal.event:event("Event_UseTactics",itemId,activeSkillLv,activeSkillType)
		end
		
		--print("释放")
		--如果对地释放类技能才能拖放
		if (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND) then
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and selected_skill_id > 0 then
				--技能释放相关参数
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				local gridX, gridY = world:xy2grid(worldX, worldY)
				local skill_id = selected_skill_id --选中的技能id
				--释放技能
				local tCastParam = {level = activeSkillLv, runState = iTag,}
				hApi.CastSkill(oUnit, skill_id, 0, nil, nil, gridX, gridY, tCastParam)
				
				--[[
				--英雄也存储上次释放的时间
				if activeSkillBindHero and (activeSkillBindHero ~= 0) then
					if (tacticId) and (tacticId ~= 0) then --战术技能卡
						activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					elseif (itemId) and (itemId ~= 0) then --道具技能卡
						activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
					end
				end
				]]
				
				if me and (me == oPlayer) then
					--刷新CD界面
					--card.childUI["cd"]:start(activeSkillCD)
					--使用次数减1
					card.data.useCount = card.data.useCount - 1
					
					--数字显使用次数
					if card.childUI["labSkillUseCount"] then
						card.childUI["labSkillUseCount"]:setText(card.data.useCount)
					end
					
					if (card.data.useCount == 0) then
						--正在cd，使用次数在cd完前，不显示
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText("")
						end
						
						card.data.useCount = card.data.useCountMax
						
						--释放后数据存储
						card.data.tacticCastTime = world:gametime()
						card.data.tacticCD = activeSkillCD
						card.data.labCD = activeSkillCD
						
						if card.childUI["cd"] then
							--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
							card.childUI["cd"]:setPercentage(0)
						end
						if card.childUI["cd_bolder"] then
							card.childUI["cd_bolder"].handle._n:setVisible(true)
						end
						if card.childUI["cd_ok"] then
							card.childUI["cd_ok"].handle._n:setVisible(false)
							--print("cd_ok false 4")
						end
						
						--英雄也存储上次释放的时间
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
							end
						end
					end
					
					--刷新使用次数
					if (card.data.useLimit > 0) then
						card.data.useLimit = card.data.useLimit - 1
					end
					--英雄也存储使用次数
					if (activeSkillNum > 0) then
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								--
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemNum = activeSkillNum - 1
							end
						end
					end
					
					--刷新使用次数界面
					if card.childUI["useLimit"] then
						card.childUI["useLimit"]:setText(card.data.useLimit)
						--geyachao: 战车1次也不显示了
						if (card.data.useLimit == 1) then
							card.childUI["useLimit"]:setText("")
						end
						if (card.data.useLimit < 10) then
							card.childUI["useLimit"].handle._n:setScale(1.0)
						else
							card.childUI["useLimit"].handle._n:setScale(0.8)
						end
					end
					--card:setstate(0)
					
					--如果使用次数为0，删除该战术卡
					if (card.data.useLimit == 0) then
						--发送指令-丢弃道具
						--大菠萝不消掉
						hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
					end
					
					--删除选中特效
					hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
					card.data.selected = 0
				end
				
				--使用战术(道具)技能特殊事件
				if On_UseTacticCard_Special_Event then
					--安全执行
					hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
				end
				
				--刷新消耗
				--mapInfo.gold = mapInfo.gold - activeSkillCostMana
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				--hGlobal.event:event("Event_TacticCastCostRefresh")
				oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				
				if me and (me == oPlayer) then
					hGlobal.event:event("Event_TacticCastCostRefresh")
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面坐标
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and selected_skill_id > 0 then
				--技能释放相关参数
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				local gridX, gridY = world:xy2grid(worldX, worldY)
				local skill_id = selected_skill_id --选中的技能id
				--释放技能
				local tCastParam = {level = activeSkillLv, runState = iTag,}
				hApi.CastSkill(oUnit, skill_id, 0, nil, nil, gridX, gridY, tCastParam)
				
				--[[
				--英雄也存储上次释放的时间
				if activeSkillBindHero and (activeSkillBindHero ~= 0) then
					if (tacticId) and (tacticId ~= 0) then --战术技能卡
						activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					elseif (itemId) and (itemId ~= 0) then --道具技能卡
						activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
					end
				end
				]]
				
				if me and (me == oPlayer) then
					--刷新CD界面
					--card.childUI["cd"]:start(activeSkillCD)
					
					--使用次数减1
					card.data.useCount = card.data.useCount - 1
					
					--数字显使用次数
					if card.childUI["labSkillUseCount"] then
						card.childUI["labSkillUseCount"]:setText(card.data.useCount)
					end
					
					if (card.data.useCount == 0) then
						--正在cd，使用次数在cd完前，不显示
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText("")
						end
						
						card.data.useCount = card.data.useCountMax
						
						--释放后数据存储
						card.data.tacticCastTime = world:gametime()
						card.data.tacticCD = activeSkillCD
						card.data.labCD = activeSkillCD
						
						if card.childUI["cd"] then
							--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
							card.childUI["cd"]:setPercentage(0)
						end
						if card.childUI["cd_bolder"] then
							card.childUI["cd_bolder"].handle._n:setVisible(true)
						end
						if card.childUI["cd_ok"] then
							card.childUI["cd_ok"].handle._n:setVisible(false)
							--print("cd_ok false 5")
						end
						
						--英雄也存储上次释放的时间
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
							end
						end
					end
					
					--刷新使用次数
					if card.data.useLimit > 0 then
						card.data.useLimit = card.data.useLimit - 1
					end
					--英雄也存储使用次数
					if (activeSkillNum > 0) then
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								--
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemNum = activeSkillNum - 1
							end
						end
					end
					
					--刷新使用次数界面
					if card.childUI["useLimit"] then
						card.childUI["useLimit"]:setText(card.data.useLimit)
						--geyachao: 战车1次也不显示了
						if (card.data.useLimit == 1) then
							card.childUI["useLimit"]:setText("")
						end
						if (card.data.useLimit < 10) then
							card.childUI["useLimit"].handle._n:setScale(1.0)
						else
							card.childUI["useLimit"].handle._n:setScale(0.8)
						end
					end
					--card:setstate(0)
					
					--如果使用次数为0，删除该战术卡
					if (card.data.useLimit == 0) then
						--发送指令-丢弃道具
						--大菠萝不消掉
						hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
					end
					
					--创建施法点的特效
					local groundEffect = world:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
					groundEffect.handle.s:setColor(ccc3(128, 255, 128))
					--0.3秒后删除自身
					local delay = CCDelayTime:create(0.3)
					local node = groundEffect.handle._n --cocos对象
					local actCall = CCCallFunc:create(function(ctrl)
						groundEffect:del()
					end)
					local actSeq = CCSequence:createWithTwoActions(delay, actCall)
					node:runAction(actSeq)
					
					--删除选中特效
					hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
					card.data.selected = 0
				end
				
				--刷新消耗
				--mapInfo.gold = mapInfo.gold - activeSkillCostMana
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				--hGlobal.event:event("Event_TacticCastCostRefresh")
				oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				
				--使用战术(道具)技能特殊事件
				if On_UseTacticCard_Special_Event then
					--安全执行
					hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
				end
				
				if me and (me == oPlayer) then
					hGlobal.event:event("Event_TacticCastCostRefresh")
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.IMMEDIATE) then --点击直接生效类型
			--如果是直接释放技能，判断当前正在释放技能
			--local oUnit = world.data.tdMapInfo.godUnit
			if oUnit then
				--技能释放相关参数
				local skill_id = selected_skill_id --选中的技能id
				--释放技能
				local tCastParam = {level = activeSkillLv, runState = iTag,}
				hApi.CastSkill(oUnit, skill_id, 0, nil, nil, nil, nil, tCastParam)
				--print("如果是直接释放技能，判断当前正在释放技能",skill_id,activeSkillLv)
				
				--[[
				--英雄也存储上次释放的时间
				if activeSkillBindHero and (activeSkillBindHero ~= 0) then
					if (tacticId) and (tacticId ~= 0) then --战术技能卡
						activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					elseif (itemId) and (itemId ~= 0) then --道具技能卡
						activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
					end
				end
				]]
				
				if me and (me == oPlayer) then
					--刷新CD界面
					--card.childUI["cd"]:start(activeSkillCD)
					if card and (card ~= 0) then
						--使用次数减1
						card.data.useCount = card.data.useCount - 1
						
						--数字显使用次数
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText(card.data.useCount)
						end
						
						--手雷的双雷图标替换
						if (card.data.useCount == 1) then
							if card.childUI["labSkillUseMultiply"] then
								--手雷图标
								card.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
							end
						end
						
						if (card.data.useCount == 0) then
							--正在cd，使用次数在cd完前，不显示
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText("")
							end
							
							card.data.useCount = card.data.useCountMax
							
							--释放后数据存储
							card.data.tacticCastTime = world:gametime()
							card.data.tacticCD = activeSkillCD
							card.data.labCD = activeSkillCD
							
							if card.childUI["cd"] then
								--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
								card.childUI["cd"]:setPercentage(0)
							end
							if card.childUI["cd_bolder"] then
								card.childUI["cd_bolder"].handle._n:setVisible(true)
							end
							if card.childUI["cd_ok"] then
								card.childUI["cd_ok"].handle._n:setVisible(false)
								--print("cd_ok false 6")
							end
							
							--英雄也存储上次释放的时间
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
								end
							end
						end
						
						--刷新使用次数
						if card.data.useLimit > 0 then
							card.data.useLimit = card.data.useLimit - 1
						end
						--英雄也存储使用次数
						--print("英雄也存储使用次数", activeSkillNum)
						if (activeSkillNum > 0) then
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									--
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemNum = activeSkillNum - 1
									--print("activeItemSkillT.activeItemNum = activeSkillNum - 1", activeSkillNum)
								end
							end
						end
						
						--刷新使用次数界面
						if card.childUI["useLimit"] then
							card.childUI["useLimit"]:setText(card.data.useLimit)
							--geyachao: 战车1次也不显示了
							if (card.data.useLimit == 1) then
								card.childUI["useLimit"]:setText("")
							end
							if (card.data.useLimit < 10) then
								card.childUI["useLimit"].handle._n:setScale(1.0)
							else
								card.childUI["useLimit"].handle._n:setScale(0.8)
							end
						end
						--card:setstate(0)
						
						--如果使用次数为0，删除该战术卡
						if (card.data.useLimit == 0) then
							--发送指令-丢弃道具
							--大菠萝不消掉
							hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
						end
						
						--0.5秒后删除选中特效
						local delay = CCDelayTime:create(0.5)
						local node = card.handle._n --cocos对象
						local actCall = CCCallFunc:create(function(ctrl)
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
						end)
						local actSeq = CCSequence:createWithTwoActions(delay, actCall)
						node:runAction(actSeq)
					end
				end
				
				--刷新消耗
				--mapInfo.gold = mapInfo.gold - activeSkillCostMana
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				--hGlobal.event:event("Event_TacticCastCostRefresh")
				oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				
				--使用战术(道具)技能特殊事件
				if On_UseTacticCard_Special_Event then
					--安全执行
					hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
				end
				
				if me and (me == oPlayer) then
					hGlobal.event:event("Event_TacticCastCostRefresh")
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --移动到达目标点后再对地面释放
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and (selected_skill_id > 0) then
				--检测单位与目标点的举例
				local u_x, u_y = hApi.chaGetPos(oUnit.handle)
				local dx = worldX - u_x
				local dy = worldY - u_y
				local dis = math.sqrt(dx * dx + dy * dy) --距离
				dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
				local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
				--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
				
				if (dis <= range) then --在射程内
					--停下来
					hApi.UnitStop_TD(oUnit)
					
					--取消锁定的目标
					local lockTarget = oUnit.data.lockTarget
					--oUnit.data.lockTarget = 0
					--print("lockTarget = 0 12", oUnit.__ID)
					--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(oUnit, 0, 0)
					--print("lockType 51", oUnit.data.name, 0)
					
					--检测目标是否也解除对其的锁定
					if (lockTarget ~= 0) then
						if (lockTarget.data.lockTarget == oUnit) then
							if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								if (oUnit.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
									--lockTarget.data.lockTarget = 0
									--print("lockTarget = 0 11", lockTarget.__ID)
									--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(lockTarget, 0, 0)
									--print("lockType 52", lockTarget.data.name, 0)
								end
							end
						end
					end
					
					--标记AI状态为闲置
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--重设守备点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
					oUnit.data.defend_x = u_x
					oUnit.data.defend_y = u_y
					
					--技能释放相关参数
					--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
					local gridX, gridY = world:xy2grid(worldX, worldY)
					--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
					local skill_id = selected_skill_id --选中的技能id
					--释放技能
					local tCastParam = {level = activeSkillLv, runState = iTag,}
					hApi.CastSkill(oUnit, skill_id, 0, nil, nil, gridX, gridY, tCastParam)
					
					--[[
					--英雄也存储上次释放的时间
					if activeSkillBindHero and (activeSkillBindHero ~= 0) then
						if (tacticId) and (tacticId ~= 0) then --战术技能卡
							activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
						elseif (itemId) and (itemId ~= 0) then --道具技能卡
							activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
						end
					end
					]]
					
					--本地才执行的
					if me and (me == oPlayer) then
						--刷新CD界面
						--card.childUI["cd"]:start(activeSkillCD)
						--使用次数减1
						card.data.useCount = card.data.useCount - 1
						
						--数字显使用次数
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText(card.data.useCount)
						end
						
						if (card.data.useCount == 0) then
							--正在cd，使用次数在cd完前，不显示
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText("")
							end
							
							card.data.useCount = card.data.useCountMax
							
							--释放后数据存储
							card.data.tacticCastTime = world:gametime()
							card.data.tacticCD = activeSkillCD
							card.data.labCD = activeSkillCD
							
							if card.childUI["cd"] then
								--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
								card.childUI["cd"]:setPercentage(0)
							end
							if card.childUI["cd_bolder"] then
								card.childUI["cd_bolder"].handle._n:setVisible(true)
							end
							if card.childUI["cd_ok"] then
								card.childUI["cd_ok"].handle._n:setVisible(false)
								--print("cd_ok false 7")
							end
							
							--英雄也存储上次释放的时间
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
								end
							end
						end
						
						--刷新使用次数
						if card.data.useLimit > 0 then
							card.data.useLimit = card.data.useLimit - 1
						end
						--英雄也存储使用次数
						if (activeSkillNum > 0) then
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									--
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemNum = activeSkillNum - 1
								end
							end
						end
						
						--刷新使用次数界面
						if card.childUI["useLimit"] then
							card.childUI["useLimit"]:setText(card.data.useLimit)
							--geyachao: 战车1次也不显示了
							if (card.data.useLimit == 1) then
								card.childUI["useLimit"]:setText("")
							end
							if (card.data.useLimit < 10) then
								card.childUI["useLimit"].handle._n:setScale(1.0)
							else
								card.childUI["useLimit"].handle._n:setScale(0.8)
							end
						end
						--card:setstate(0)
						
						--如果使用次数为0，删除该战术卡
						if (card.data.useLimit == 0) then
							--发送指令-丢弃道具
							--大菠萝不消掉
							hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
						end
						
						--删除选中特效
						hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
						card.data.selected = 0
						
						--播放目标点动画特效
						--local effect_id = 1 --特效id
						--world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
					end
					
					--刷新消耗
					--mapInfo.gold = mapInfo.gold - activeSkillCostMana
					--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					--hGlobal.event:event("Event_TacticCastCostRefresh")
					oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					
					--使用战术(道具)技能特殊事件
					if On_UseTacticCard_Special_Event then
						--安全执行
						hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
						--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					end
					
					if me and (me == oPlayer) then
						hGlobal.event:event("Event_TacticCastCostRefresh")
					end
				else --不在射程内
					if me and (me == oPlayer) then
						--发起移动请求（本地）
						--到达射程内的最近点
						local toX = worldX - (range - hVar.MOVE_EXTRA_DISTANCE) * dx / dis
						local toY = worldY - (range - hVar.MOVE_EXTRA_DISTANCE) * dy / dis
						toX = math.floor(toX * 100) / 100 --保留2位有效数字，用于同步
						toY = math.floor(toY * 100) / 100 --保留2位有效数字，用于同步
						
						--检测此点是否能到达
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, toX / 24, toY / 24, 0, nil)
						if (waypoint[0] == 0) then --不能到达，寻找最近的可以到达的点
							--寻找最近的可以到达的点
							toX, toY = hApi.GetReachedPoint(oUnit, worldX, worldY)
						end
						
						--有效的本次到达的点，是否距离终点，在施法范围内
						local dxtt = worldX - toX
						local dytt = worldY - toY
						local dist = math.sqrt(dxtt * dxtt + dytt * dytt) --距离
						dist = math.floor(dist * 100) / 100 --保留2位有效数字，用于同步
						local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
						--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
						
						if (dist <= range) then --到达后在施法范围内，发起寻路
							--这种延时生效的，先本地预操作，删除特效
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放目标点动画特效
							local effect_id = 1 --特效id
							local eff = world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
							eff.handle.s:setColor(ccc3(0, 255, 0))
							
							--print("改为发送指令-移动到目标")
							--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), toX, toY, 0, 0, tacticId, itemId, worldX, worldY)
						else --没有办法移动到达施法范围内
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放禁用特效
							local effect_id = 418 --特效id
							world:addeffect(effect_id, 3.0 ,nil, worldX, worldY)
							
							--播放禁用音效
							hApi.PlaySound("button")
						end
					end
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --移动到达有效目标点后再对地面释放
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and (selected_skill_id > 0) then
				--检测单位与目标点的举例
				local u_x, u_y = hApi.chaGetPos(oUnit.handle)
				local dx = worldX - u_x
				local dy = worldY - u_y
				local dis = math.sqrt(dx * dx + dy * dy) --距离
				dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
				local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
				--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
				
				if (dis <= range) then --在射程内
					--停下来
					hApi.UnitStop_TD(oUnit)
					
					--取消锁定的目标
					local lockTarget = oUnit.data.lockTarget
					--oUnit.data.lockTarget = 0
					--print("lockTarget = 0 12", oUnit.__ID)
					--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(oUnit, 0, 0)
					--print("lockType 51", oUnit.data.name, 0)
					
					--检测目标是否也解除对其的锁定
					if (lockTarget ~= 0) then
						if (lockTarget.data.lockTarget == oUnit) then
							if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								if (oUnit.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
									--lockTarget.data.lockTarget = 0
									--print("lockTarget = 0 11", lockTarget.__ID)
									--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(lockTarget, 0, 0)
									--print("lockType 52", lockTarget.data.name, 0)
								end
							end
						end
					end
					
					--标记AI状态为闲置
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--重设守备点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
					oUnit.data.defend_x = u_x
					oUnit.data.defend_y = u_y
					
					--技能释放相关参数
					--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
					local gridX, gridY = world:xy2grid(worldX, worldY)
					--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
					local skill_id = selected_skill_id --选中的技能id
					--释放技能
					local tCastParam = {level = activeSkillLv, runState = iTag,}
					hApi.CastSkill(oUnit, skill_id, 0, nil, nil, gridX, gridY, tCastParam)
					
					--[[
					--英雄也存储上次释放的时间
					if activeSkillBindHero and (activeSkillBindHero ~= 0) then
						if (tacticId) and (tacticId ~= 0) then --战术技能卡
							activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
						elseif (itemId) and (itemId ~= 0) then --道具技能卡
							activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
						end
					end
					]]
					
					--本地才执行的
					if me and (me == oPlayer) then
						--刷新CD界面
						--card.childUI["cd"]:start(activeSkillCD)
						--使用次数减1
						card.data.useCount = card.data.useCount - 1
						
						--数字显使用次数
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText(card.data.useCount)
						end
						
						if (card.data.useCount == 0) then
							--正在cd，使用次数在cd完前，不显示
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText("")
							end
							
							card.data.useCount = card.data.useCountMax
							
							--释放后数据存储
							card.data.tacticCastTime = world:gametime()
							card.data.tacticCD = activeSkillCD
							card.data.labCD = activeSkillCD
							
							if card.childUI["cd"] then
								--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
								card.childUI["cd"]:setPercentage(0)
							end
							if card.childUI["cd_bolder"] then
								card.childUI["cd_bolder"].handle._n:setVisible(true)
							end
							if card.childUI["cd_ok"] then
								card.childUI["cd_ok"].handle._n:setVisible(false)
								--print("cd_ok false 8")
							end
							
							--英雄也存储上次释放的时间
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
								end
							end
						end
						
						--刷新使用次数
						if card.data.useLimit > 0 then
							card.data.useLimit = card.data.useLimit - 1
						end
						--英雄也存储使用次数
						if (activeSkillNum > 0) then
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									--
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemNum = activeSkillNum - 1
								end
							end
						end
						
						--刷新使用次数界面
						if card.childUI["useLimit"] then
							card.childUI["useLimit"]:setText(card.data.useLimit)
							--geyachao: 战车1次也不显示了
							if (card.data.useLimit == 1) then
								card.childUI["useLimit"]:setText("")
							end
							if (card.data.useLimit < 10) then
								card.childUI["useLimit"].handle._n:setScale(1.0)
							else
								card.childUI["useLimit"].handle._n:setScale(0.8)
							end
						end
						--card:setstate(0)
						
						--如果使用次数为0，删除该战术卡
						if (card.data.useLimit == 0) then
							--发送指令-丢弃道具
							--大菠萝不消掉
							hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
						end
						
						--删除选中特效
						hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
						card.data.selected = 0
						
						--播放目标点动画特效
						--local effect_id = 1 --特效id
						--world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
					end
					
					--刷新消耗
					--mapInfo.gold = mapInfo.gold - activeSkillCostMana
					--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					--hGlobal.event:event("Event_TacticCastCostRefresh")
					oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					
					--使用战术(道具)技能特殊事件
					if On_UseTacticCard_Special_Event then
						--安全执行
						hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
						--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					end
					
					if me and (me == oPlayer) then
						hGlobal.event:event("Event_TacticCastCostRefresh")
					end
				else --不在射程内
					if me and (me == oPlayer) then
						--发起移动请求（本地）
						--到达射程内的最近点
						local toX = worldX - (range - hVar.MOVE_EXTRA_DISTANCE) * dx / dis
						local toY = worldY - (range - hVar.MOVE_EXTRA_DISTANCE) * dy / dis
						toX = math.floor(toX * 100) / 100 --保留2位有效数字，用于同步
						toY = math.floor(toY * 100) / 100 --保留2位有效数字，用于同步
						
						--检测此点是否能到达
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, toX / 24, toY / 24, 0, nil)
						if (waypoint[0] == 0) then --不能到达，寻找最近的可以到达的点
							--寻找最近的可以到达的点
							toX, toY = hApi.GetReachedPoint(oUnit, worldX, worldY)
						end
						
						--有效的本次到达的点，是否距离终点，在施法范围内
						local dxtt = worldX - toX
						local dytt = worldY - toY
						local dist = math.sqrt(dxtt * dxtt + dytt * dytt) --距离
						dist = math.floor(dist * 100) / 100 --保留2位有效数字，用于同步
						local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
						--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
						
						if (dist <= range) then --到达后在施法范围内，发起寻路
							--这种延时生效的，先本地预操作，删除特效
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放目标点动画特效
							local effect_id = 1 --特效id
							local eff = world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
							eff.handle.s:setColor(ccc3(0, 255, 0))
							
							--print("改为发送指令-移动到目标")
							--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), toX, toY, 0, 0, tacticId, itemId, worldX, worldY)
						else --没有办法移动到达施法范围内
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放禁用特效
							local effect_id = 418 --特效id
							world:addeffect(effect_id, 3.0 ,nil, worldX, worldY)
							
							--播放禁用音效
							hApi.PlaySound("button")
						end
					end
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT) then --对目标释放
			--print("对目标释放")
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and (selected_skill_id > 0) then
				--检测单位与目标的距离
				local u_x, u_y = hApi.chaGetPos(oUnit.handle)
				local t = hClass.unit:getChaByWorldI(t_worldI)
				if (t) and (t:getworldC() ~= t_worldC) then
					t = nil
				end
				if t and (hApi.IsSkillTargetValid(oUnit, t, selected_skill_id) == hVar.RESULT_SUCESS) then
					local t_x, t_y = hApi.chaGetPos(t.handle)
					local dx = t_x - u_x
					local dy = t_y - u_y
					local dis = math.sqrt(dx * dx + dy * dy) --距离
					dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
					local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
					--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
					
					if (dis <= range) then --在射程内
						--停下来
						hApi.UnitStop_TD(oUnit)
						
						--取消锁定的目标
						local lockTarget = oUnit.data.lockTarget
						--oUnit.data.lockTarget = 0
						--print("lockTarget = 0 12", oUnit.__ID)
						--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(oUnit, 0, 0)
						--print("lockType 51", oUnit.data.name, 0)
						
						--检测目标是否也解除对其的锁定
						if (lockTarget ~= 0) then
							if (lockTarget.data.lockTarget == oUnit) then
								if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
									if (oUnit.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
										--lockTarget.data.lockTarget = 0
										--print("lockTarget = 0 11", lockTarget.__ID)
										--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										hApi.UnitTryToLockTarget(lockTarget, 0, 0)
										--print("lockType 52", lockTarget.data.name, 0)
									end
								end
							end
						end
						
						--标记AI状态为闲置
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
						
						--重设守备点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
						oUnit.data.defend_x = u_x
						oUnit.data.defend_y = u_y
						
						--技能释放相关参数
						--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
						local gridX, gridY = world:xy2grid(worldX, worldY)
						--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
						local skill_id = selected_skill_id --选中的技能id
						--释放技能
						local tCastParam = {level = activeSkillLv, runState = iTag,}
						hApi.CastSkill(oUnit, skill_id, 0, nil, t, nil, nil, tCastParam)
						
						--[[
						--英雄也存储上次释放的时间
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
							end
						end
						]]
						
						--本地才执行的
						if me and (me == oPlayer) then
							--刷新CD界面
							--card.childUI["cd"]:start(activeSkillCD)
							--使用次数减1
							card.data.useCount = card.data.useCount - 1
							
							--数字显使用次数
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText(card.data.useCount)
							end
							
							if (card.data.useCount == 0) then
								--正在cd，使用次数在cd完前，不显示
								if card.childUI["labSkillUseCount"] then
									card.childUI["labSkillUseCount"]:setText("")
								end
								
								card.data.useCount = card.data.useCountMax
								
								--释放后数据存储
								card.data.tacticCastTime = world:gametime()
								card.data.tacticCD = activeSkillCD
								card.data.labCD = activeSkillCD
								
								if card.childUI["cd"] then
									--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
									card.childUI["cd"]:setPercentage(0)
								end
								if card.childUI["cd_bolder"] then
									card.childUI["cd_bolder"].handle._n:setVisible(true)
								end
								if card.childUI["cd_ok"] then
									card.childUI["cd_ok"].handle._n:setVisible(false)
									--print("cd_ok false 9")
								end
								
								--英雄也存储上次释放的时间
								if activeSkillBindHero and (activeSkillBindHero ~= 0) then
									if (tacticId) and (tacticId ~= 0) then --战术技能卡
										activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
									elseif (itemId) and (itemId ~= 0) then --道具技能卡
										activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
									end
								end
							end
							
							--刷新使用次数
							if card.data.useLimit > 0 then
								card.data.useLimit = card.data.useLimit - 1
							end
							--英雄也存储使用次数
							if (activeSkillNum > 0) then
								if activeSkillBindHero and (activeSkillBindHero ~= 0) then
									if (tacticId) and (tacticId ~= 0) then --战术技能卡
										--
									elseif (itemId) and (itemId ~= 0) then --道具技能卡
										activeItemSkillT.activeItemNum = activeSkillNum - 1
									end
								end
							end
							
							--刷新使用次数界面
							if card.childUI["useLimit"] then
								card.childUI["useLimit"]:setText(tostring(card.data.useLimit))
									--geyachao: 战车1次也不显示了
								if (card.data.useLimit == 1) then
									card.childUI["useLimit"]:setText("")
								end
							end
							--card:setstate(0)
							
							--如果使用次数为0，删除该战术卡
							if (card.data.useLimit == 0) then
								--发送指令-丢弃道具
								hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
							end
							
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放目标点动画特效
							--local effect_id = 1 --特效id
							--world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
						end
						
						--刷新消耗
						--mapInfo.gold = mapInfo.gold - activeSkillCostMana
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
						--hGlobal.event:event("Event_TacticCastCostRefresh")
						oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
						
						--使用战术(道具)技能特殊事件
						if On_UseTacticCard_Special_Event then
							--安全执行
							hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, t, activeSkillBindHero, activeIndex)
							--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, t, activeSkillBindHero, activeIndex)
						end
						
						if me and (me == oPlayer) then
							hGlobal.event:event("Event_TacticCastCostRefresh")
						end
					else --不在射程内
						if me and (me == oPlayer) then
							--发起移动请求（本地）
							--到达目标
							local toX = t_x - (range - hVar.MOVE_EXTRA_DISTANCE) * dx / dis
							local toY = t_y - (range - hVar.MOVE_EXTRA_DISTANCE) * dy / dis
							toX = math.floor(toX * 100) / 100 --保留2位有效数字，用于同步
							toY = math.floor(toY * 100) / 100 --保留2位有效数字，用于同步
							
							--检测此点是否能到达
							local waypoint = xlCha_MoveToGrid(oUnit.handle._c, toX / 24, toY / 24, 0, nil)
							if (waypoint[0] == 0) then --不能到达，寻找最近的可以到达的点
								--寻找最近的可以到达的点
								toX, toY = hApi.GetReachedPoint(oUnit, t_x, t_y)
							end
							
							--有效的本次到达的点，是否距离终点，在施法范围内
							local dxtt = t_x - toX
							local dytt = t_y - toY
							local dist = math.sqrt(dxtt * dxtt + dytt * dytt) --距离
							dist = math.floor(dist * 100) / 100 --保留2位有效数字，用于同步
							local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
							--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
							
							if (dist <= range) then --到达后在施法范围内，发起寻路
								--这种延时生效的，先本地预操作，删除特效
								--删除选中特效
								hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
								card.data.selected = 0
								
								--播放目标点动画特效
								local effect_id = 613 --特效id
								local eff = world:addeffect(effect_id, 2.0 ,nil, t_x, t_y - 90)
								eff.handle.s:setColor(ccc3(0, 255, 0))
								
								--print("改为发送指令-移动到目标")
								--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
								hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), toX, toY, t_worldI, t_worldC, tacticId, itemId, 0, 0)
							else --没有办法移动到达施法范围内
								--删除选中特效
								hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
								card.data.selected = 0
							end
						end
					end
				else --目标不存在，或者目标不合法
					--删除选中特效
					hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
					card.data.selected = 0
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then --对自身周围的随机单位释放
			--如果是直接释放技能，判断当前正在释放技能
			--local oUnit = world.data.tdMapInfo.godUnit
			if oUnit and selected_skill_id and (selected_skill_id > 0) then
				local u_x, u_y = hApi.chaGetPos(oUnit.handle)
				
				--技能释放相关参数
				local skill_id = selected_skill_id --选中的技能id
				local tabS = hVar.tab_skill[skill_id]
				
				local validTarget = AI_search_skill_target(oUnit, skill_id)
				if validTarget and (validTarget ~= 0) then
					--停下来
					if (tabS.IsInterrupt ~= 0) then
						hApi.UnitStop_TD(oUnit)
					end
					
					--取消锁定的目标
					local lockTarget = oUnit.data.lockTarget
					--oUnit.data.lockTarget = 0
					--print("lockTarget = 0 12", oUnit.__ID)
					--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(oUnit, 0, 0)
					--print("lockType 51", oUnit.data.name, 0)
					
					--检测目标是否也解除对其的锁定
					if (lockTarget ~= 0) then
						if (lockTarget.data.lockTarget == oUnit) then
							if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								if (oUnit.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
									--lockTarget.data.lockTarget = 0
									--print("lockTarget = 0 11", lockTarget.__ID)
									--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(lockTarget, 0, 0)
									--print("lockType 52", lockTarget.data.name, 0)
								end
							end
						end
					end
					
					--标记AI状态为闲置
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--重设守备点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
					oUnit.data.defend_x = u_x
					oUnit.data.defend_y = u_y
					
					--技能释放相关参数
					--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
					local gridX, gridY = world:xy2grid(worldX, worldY)
					--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
					
					--释放技能
					local tCastParam = {level = activeSkillLv, runState = iTag,}
					hApi.CastSkill(oUnit, skill_id, 0, nil, validTarget, nil, nil, tCastParam)
					
					--[[
					--英雄也存储上次释放的时间
					if activeSkillBindHero and (activeSkillBindHero ~= 0) then
						if (tacticId) and (tacticId ~= 0) then --战术技能卡
							activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
						elseif (itemId) and (itemId ~= 0) then --道具技能卡
							activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
						end
					end
					]]
					
					--本地执行
					if me and (me == oPlayer) then
						--刷新CD界面
						--card.childUI["cd"]:start(activeSkillCD)
						--使用次数减1
						card.data.useCount = card.data.useCount - 1
						
						--数字显使用次数
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText(card.data.useCount)
						end
						
						if (card.data.useCount == 0) then
							--正在cd，使用次数在cd完前，不显示
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText("")
							end
							
							card.data.useCount = card.data.useCountMax
							
							--释放后数据存储
							card.data.tacticCastTime = world:gametime()
							card.data.tacticCD = activeSkillCD
							card.data.labCD = activeSkillCD
							
							if card.childUI["cd"] then
								--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
								card.childUI["cd"]:setPercentage(0)
							end
							if card.childUI["cd_bolder"] then
								card.childUI["cd_bolder"].handle._n:setVisible(true)
							end
							if card.childUI["cd_ok"] then
								card.childUI["cd_ok"].handle._n:setVisible(false)
								--print("cd_ok false 10")
							end
							
							--英雄也存储上次释放的时间
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
								end
							end
						end
						
						--刷新使用次数
						if card.data.useLimit > 0 then
							card.data.useLimit = card.data.useLimit - 1
						end
						--英雄也存储使用次数
						if (activeSkillNum > 0) then
							if activeSkillBindHero and (activeSkillBindHero ~= 0) then
								if (tacticId) and (tacticId ~= 0) then --战术技能卡
									--
								elseif (itemId) and (itemId ~= 0) then --道具技能卡
									activeItemSkillT.activeItemNum = activeSkillNum - 1
								end
							end
						end
						
						--刷新使用次数界面
						if card.childUI["useLimit"] then
							card.childUI["useLimit"]:setText(tostring(card.data.useLimit))
							--geyachao: 战车1次也不显示了
							if (card.data.useLimit == 1) then
								card.childUI["useLimit"]:setText("")
							end
						end
						--card:setstate(0)
						
						--如果使用次数为0，删除该战术卡
						if (card.data.useLimit == 0) then
							--发送指令-丢弃道具
							hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
						end
						
						--0.5秒后删除选中特效
						local delay = CCDelayTime:create(0.5)
						local node = card.handle._n --cocos对象
						local actCall = CCCallFunc:create(function(ctrl)
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
						end)
						local actSeq = CCSequence:createWithTwoActions(delay, actCall)
						node:runAction(actSeq)
					end
					
					--刷新消耗
					--mapInfo.gold = mapInfo.gold - activeSkillCostMana
					--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					--hGlobal.event:event("Event_TacticCastCostRefresh")
					oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
					
					--使用战术(道具)技能特殊事件
					if On_UseTacticCard_Special_Event then
						--安全执行
						hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, validTarget, activeSkillBindHero, activeIndex)
						--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, validTarget, activeSkillBindHero, activeIndex)
					end
					
					if me and (me == oPlayer) then
						hGlobal.event:event("Event_TacticCastCostRefresh")
					end
				else
					--本地执行
					if me and (me == oPlayer) then
						local strText = "没有目标可释放技能" --language
						--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						--施法失败，取消选中
						hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
						card.data.selected = 0
					end
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then --移动到目标点后再目标点周围随机单位释放
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and (selected_skill_id > 0) then
				--检测单位与目标点的距离
				local u_x, u_y = hApi.chaGetPos(oUnit.handle)
				local dx = worldX - u_x
				local dy = worldY - u_y
				local dis = math.sqrt(dx * dx + dy * dy) --距离
				dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
				local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
				--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
				
				if (dis <= range) then --在射程内
					--寻找目标点周围的一个随机目标
					--技能释放相关参数
					local skill_id = selected_skill_id --选中的技能id
					local validTarget = AI_search_skill_target(oUnit, skill_id, worldX, worldY)
					--print("寻找目标点周围的一个随机目标", oUnit.data.name, skill_id, worldX, worldY, validTarget)
					if validTarget and (validTarget ~= 0) then
						--停下来
						hApi.UnitStop_TD(oUnit)
						
						--取消锁定的目标
						local lockTarget = oUnit.data.lockTarget
						--oUnit.data.lockTarget = 0
						--print("lockTarget = 0 12", oUnit.__ID)
						--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(oUnit, 0, 0)
						--print("lockType 51", oUnit.data.name, 0)
						
						--检测目标是否也解除对其的锁定
						if (lockTarget ~= 0) then
							if (lockTarget.data.lockTarget == oUnit) then
								if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
									if (oUnit.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
										--lockTarget.data.lockTarget = 0
										--print("lockTarget = 0 11", lockTarget.__ID)
										--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										hApi.UnitTryToLockTarget(lockTarget, 0, 0)
										--print("lockType 52", lockTarget.data.name, 0)
									end
								end
							end
						end
						
						--标记AI状态为闲置
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
						
						--重设守备点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
						oUnit.data.defend_x = u_x
						oUnit.data.defend_y = u_y
						
						--技能释放相关参数
						--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
						local gridX, gridY = world:xy2grid(worldX, worldY)
						--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
						
						--释放技能
						local tCastParam = {level = activeSkillLv, runState = iTag,}
						hApi.CastSkill(oUnit, skill_id, 0, nil, validTarget, nil, nil, tCastParam)
						
						--[[
						--英雄也存储上次释放的时间
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
							end
						end
						]]
						
						--本地才执行的
						if me and (me == oPlayer) then
							--刷新CD界面
							--card.childUI["cd"]:start(activeSkillCD)
							--使用次数减1
							card.data.useCount = card.data.useCount - 1
							
							--数字显使用次数
							if card.childUI["labSkillUseCount"] then
								card.childUI["labSkillUseCount"]:setText(card.data.useCount)
							end
							
							if (card.data.useCount == 0) then
								--正在cd，使用次数在cd完前，不显示
								if card.childUI["labSkillUseCount"] then
									card.childUI["labSkillUseCount"]:setText("")
								end
								
								card.data.useCount = card.data.useCountMax
								
								--释放后数据存储
								card.data.tacticCastTime = world:gametime()
								card.data.tacticCD = activeSkillCD
								card.data.labCD = activeSkillCD
								
								if card.childUI["cd"] then
									--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
									card.childUI["cd"]:setPercentage(0)
								end
								if card.childUI["cd_bolder"] then
									card.childUI["cd_bolder"].handle._n:setVisible(true)
								end
								if card.childUI["cd_ok"] then
									card.childUI["cd_ok"].handle._n:setVisible(false)
									--print("cd_ok false 11")
								end
								
								--英雄也存储上次释放的时间
								if activeSkillBindHero and (activeSkillBindHero ~= 0) then
									if (tacticId) and (tacticId ~= 0) then --战术技能卡
										activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
									elseif (itemId) and (itemId ~= 0) then --道具技能卡
										activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
									end
								end
							end
							
							--刷新使用次数
							if card.data.useLimit > 0 then
								card.data.useLimit = card.data.useLimit - 1
							end
							--英雄也存储使用次数
							if (activeSkillNum > 0) then
								if activeSkillBindHero and (activeSkillBindHero ~= 0) then
									if (tacticId) and (tacticId ~= 0) then --战术技能卡
										--
									elseif (itemId) and (itemId ~= 0) then --道具技能卡
										activeItemSkillT.activeItemNum = activeSkillNum - 1
									end
								end
							end
							
							--刷新使用次数界面
							if card.childUI["useLimit"] then
								card.childUI["useLimit"]:setText(tostring(card.data.useLimit))
								--geyachao: 战车1次也不显示了
								if (card.data.useLimit == 1) then
									card.childUI["useLimit"]:setText("")
								end
							end
							--card:setstate(0)
							
							--如果使用次数为0，删除该战术卡
							if (card.data.useLimit == 0) then
								--发送指令-丢弃道具
								hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
							end
							
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放目标点动画特效
							--local effect_id = 1 --特效id
							--world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
						end
						
						--刷新消耗
						--mapInfo.gold = mapInfo.gold - activeSkillCostMana
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
						--hGlobal.event:event("Event_TacticCastCostRefresh")
						oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
						
						--使用战术(道具)技能特殊事件
						if On_UseTacticCard_Special_Event then
							--安全执行
							hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, validTarget, activeSkillBindHero, activeIndex)
							--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, validTarget, activeSkillBindHero, activeIndex)
						end
						
						if me and (me == oPlayer) then
							hGlobal.event:event("Event_TacticCastCostRefresh")
						end
					else --周围没有目标
						--本地执行
						if me and (me == oPlayer) then
							local strText = "没有目标可释放技能" --language
							--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							
							--施法失败，取消选中
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
						end
					end
				else --不在射程内
					if me and (me == oPlayer) then
						--发起移动请求（本地）
						--到达射程内的最近点
						local toX = worldX - (range - hVar.MOVE_EXTRA_DISTANCE) * dx / dis
						local toY = worldY - (range - hVar.MOVE_EXTRA_DISTANCE) * dy / dis
						toX = math.floor(toX * 100) / 100 --保留2位有效数字，用于同步
						toY = math.floor(toY * 100) / 100 --保留2位有效数字，用于同步
						
						--检测此点是否能到达
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, toX / 24, toY / 24, 0, nil)
						if (waypoint[0] == 0) then --不能到达，寻找最近的可以到达的点
							--寻找最近的可以到达的点
							toX, toY = hApi.GetReachedPoint(oUnit, worldX, worldY)
						end
						
						--有效的本次到达的点，是否距离终点，在施法范围内
						local dxtt = worldX - toX
						local dytt = worldY - toY
						local dist = math.sqrt(dxtt * dxtt + dytt * dytt) --距离
						dist = math.floor(dist * 100) / 100 --保留2位有效数字，用于同步
						local range = hVar.tab_skill[selected_skill_id].AI_search_radius --AI自动释放技能时，搜敌半径(非普通攻击)
						--print("移动到达目标点后再对地面释放 dis=", dis, "range=", range)
						
						if (dist <= range) then --到达后在施法范围内，发起寻路
							--这种延时生效的，先本地预操作，删除特效
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放目标点动画特效
							local effect_id = 1 --特效id
							local eff = world:addeffect(effect_id, 2.0 ,nil, worldX, worldY)
							eff.handle.s:setColor(ccc3(0, 255, 0))
							
							--print("改为发送指令-移动到目标")
							--print("hApi.CastSkill, worldX, worldY", worldX, worldY)
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), toX, toY, 0, 0, tacticId, itemId, worldX, worldY)
						else --没有办法移动到达施法范围内
							--删除选中特效
							hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
							card.data.selected = 0
							
							--播放禁用特效
							local effect_id = 418 --特效id
							world:addeffect(effect_id, 3.0 ,nil, worldX, worldY)
							
							--播放禁用音效
							hApi.PlaySound("button")
						end
					end
				end
			end
		elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then --TD对地面有效的非障碍点地方，靠近能量圈附近
			--local oUnit = mapInfo.godUnit
			if oUnit and selected_skill_id and selected_skill_id > 0 then
				--技能释放相关参数
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				local gridX, gridY = world:xy2grid(worldX, worldY)
				local skill_id = selected_skill_id --选中的技能id
				--释放技能
				local tCastParam = {level = activeSkillLv, runState = iTag,}
				hApi.CastSkill(oUnit, skill_id, 0, nil, nil, gridX, gridY, tCastParam)
				
				--[[
				--英雄也存储上次释放的时间
				if activeSkillBindHero and (activeSkillBindHero ~= 0) then
					if (tacticId) and (tacticId ~= 0) then --战术技能卡
						activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					elseif (itemId) and (itemId ~= 0) then --道具技能卡
						activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
					end
				end
				]]
				
				if me and (me == oPlayer) then
					--刷新CD界面
					--card.childUI["cd"]:start(activeSkillCD)
					
					--使用次数减1
					card.data.useCount = card.data.useCount - 1
					
					--数字显使用次数
					if card.childUI["labSkillUseCount"] then
						card.childUI["labSkillUseCount"]:setText(card.data.useCount)
					end
					
					if (card.data.useCount == 0) then
						--正在cd，使用次数在cd完前，不显示
						if card.childUI["labSkillUseCount"] then
							card.childUI["labSkillUseCount"]:setText("")
						end
						
						card.data.useCount = card.data.useCountMax
						
						--释放后数据存储
						card.data.tacticCastTime = world:gametime()
						card.data.tacticCD = activeSkillCD
						card.data.labCD = activeSkillCD
						
						if card.childUI["cd"] then
							--card.childUI["cd"].handle.s:setColor(ccc3(168, 168, 168))
							card.childUI["cd"]:setPercentage(0)
						end
						if card.childUI["cd_bolder"] then
							card.childUI["cd_bolder"].handle._n:setVisible(true)
						end
						if card.childUI["cd_ok"] then
							card.childUI["cd_ok"].handle._n:setVisible(false)
							--print("cd_ok false 12")
						end
						
						--英雄也存储上次释放的时间
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								activeSkillBindHero.data.activeSkillLastCastTime = world:gametime() --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemLastCastTime = world:gametime() --主动技能的上次释放的时间（单位:毫秒）
							end
						end
					end
					
					--刷新使用次数
					if card.data.useLimit > 0 then
						card.data.useLimit = card.data.useLimit - 1
					end
					--英雄也存储使用次数
					if (activeSkillNum > 0) then
						if activeSkillBindHero and (activeSkillBindHero ~= 0) then
							if (tacticId) and (tacticId ~= 0) then --战术技能卡
								--
							elseif (itemId) and (itemId ~= 0) then --道具技能卡
								activeItemSkillT.activeItemNum = activeSkillNum - 1
							end
						end
					end
					
					--刷新使用次数界面
					if card.childUI["useLimit"] then
						card.childUI["useLimit"]:setText(card.data.useLimit)
						--geyachao: 战车1次也不显示了
						if (card.data.useLimit == 1) then
							card.childUI["useLimit"]:setText("")
						end
						if (card.data.useLimit < 10) then
							card.childUI["useLimit"].handle._n:setScale(1.0)
						else
							card.childUI["useLimit"].handle._n:setScale(0.8)
						end
					end
					--card:setstate(0)
					
					--如果使用次数为0，删除该战术卡
					if (card.data.useLimit == 0) then
						--发送指令-丢弃道具
						--大菠萝不消掉
						hApi.AddCommand(hVar.Operation.DropOutItem, card.data.tacticId, card.data.itemId)
					end
					
					--创建施法点的特效
					local groundEffect = world:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
					groundEffect.handle.s:setColor(ccc3(128, 255, 128))
					--0.3秒后删除自身
					local delay = CCDelayTime:create(0.3)
					local node = groundEffect.handle._n --cocos对象
					local actCall = CCCallFunc:create(function(ctrl)
						groundEffect:del()
					end)
					local actSeq = CCSequence:createWithTwoActions(delay, actCall)
					node:runAction(actSeq)
					
					--删除选中特效
					hApi.safeRemoveT(card.childUI, "selectbox") --删除选中特效
					card.data.selected = 0
					
					--针对TD对地面有效的非障碍点地方，靠近能量圈附近，取消能量塔的能量圈
					local tabS = hVar.tab_skill[skill_id]
					local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
					local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
					--print(energy_unit_id, energy_build_radius)
					if (energy_unit_id > 0) then
						--显示地图上全部充能塔的建造半径
						local world = hGlobal.WORLD.LastWorldMap
						world:enumunit(function(eu)
							local typeId = eu.data.id --类型id
							if (typeId == energy_unit_id) then
								hApi.safeRemoveT(eu.chaUI, "TD_AtkRange")
							end
						end)
					end
				end
				
				--刷新消耗
				--mapInfo.gold = mapInfo.gold - activeSkillCostMana
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				--hGlobal.event:event("Event_TacticCastCostRefresh")
				oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -activeSkillCostMana)
				
				--使用战术(道具)技能特殊事件
				if On_UseTacticCard_Special_Event then
					--安全执行
					hpcall(On_UseTacticCard_Special_Event, oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
					--On_UseTacticCard_Special_Event(oPlayer, tacticId, itemId, worldX, worldY, oUnit, nil, activeSkillBindHero, activeIndex)
				end
				
				if me and (me == oPlayer) then
					hGlobal.event:event("Event_TacticCastCostRefresh")
				end
			end
		end
	end
	
	--玩家增加或减少战术(道具)技能卡的当前冷却时间（同步）
	--单位: 秒
	function hApi.ReducePlayerTacticCardCD_Current(oPlayer, tacticId, itemId, reduceCD)
		--防止弹框
		if (not oPlayer) then
			return
		end
		
		--无效的oPlayer
		if (not oPlayer.getpos) then
			return
		end
		
		--取整数
		if (reduceCD >= 0) then --增加cd(1.5秒 -> 2秒)
			reduceCD = math.ceil(reduceCD)
		else --减少cd(-1.5秒 -> -2秒)
			reduceCD = math.floor(reduceCD)
		end
		
		--geyachao: 同步日志: 改变战术卡cd
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "ReduceTacticCD: oPlayer=" .. oPlayer:getpos() .. ",tacticId=" .. tostring(tacticId) .. ",itemId=" .. tostring(itemId) .. ",reduceCD=" .. tostring(reduceCD)
			hApi.SyncLog(msg)
		end
		
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		
		--参数
		local activeIndex = 0 --位置索引值
		local selected_skill_id = 0
		local activeSkillLv = 0 --等级
		local activeSkillType = 0
		local activeSkillRange = 0
		local activeSkillCD = 0 --原始CD（单位:秒）
		local activeSkillCostMana = 0
		local activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
		local activeSkillDeadUnUse = 0 --此战术技能卡在英雄死后是否禁用
		local activeSkillLastCastTime = -math.huge --上次施法时间（单位:毫秒）
		local activeItemSkillT = nil --道具技能表
		
		if (tacticId) and (tacticId ~= 0) then --战术技能卡
			local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
			local tabT = nil --战术技能表
			local lv = 0
			local typeId = 0
			
			for i = 1, #tTactics, 1 do
				--print(i, "tTactics[i]=", tTactics[i])
				if (tTactics[i] ~= 0) then
					local id = tTactics[i][1]--geyachao: 该战术技能卡是哪个英雄的
					lv = tTactics[i][2] --geyachao: 该战术技能卡是哪个英雄的
					typeId = tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
					
					if (id == tacticId) then
						tabT = hVar.tab_tactics[id]
						break
					end
				end
			end
			
			--无效的战术技能卡id
			if (tabT == nil) then
				return
			end
			
			activeIndex = 0 --位置索引值
			selected_skill_id = tabT.activeSkill.id
			activeSkillLv = lv --等级
			activeSkillType = tabT.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
			activeSkillRange = tabT.activeSkill.effectRange[lv] or 0
			activeSkillCD = tabT.activeSkill.cd[lv] or 0 --原始CD（单位:秒）
			activeSkillCostMana = tabT.activeSkill.costMana[lv] or 0
			activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
			activeSkillDeadUnUse = tabT.activeSkill.deadUnUse or 0 --此战术技能卡在英雄死后是否禁用
			
			--读取英雄身上的减cd
			--print("typeId=", typeId)
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				if (oHero.data.id == typeId) then
					activeIndex = j
					activeSkillBindHero = oHero
					activeSkillCD = activeSkillBindHero.data.activeSkillCD
					activeSkillLastCastTime = oHero.data.activeSkillLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					
					--print("activeSkillCD=", activeSkillCD)
					local tactics = activeSkillBindHero:gettactics()
					for k = 1, #tactics, 1 do
						local tactic = tactics[k]
						if tactic then
							local tacticIdk = tactic.id or 0
							local tacticLvk = tactic.lv or 1
							if (tacticId == tacticIdk) then
								activeSkillLv = tacticLvk --读取英雄的等级
								--print("读取英雄的等级=", activeSkillLv)
								break
							end
						end
					end
					
					break
				end
			end
			--print("activeSkillLv=", activeSkillLv)
			
			--如果该战术卡不属于英雄
			if (activeIndex == 0) then
				local idx = 0
				for i = 1, #tTactics, 1 do
					if (tTactics[i] ~= 0) then
						local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
						local tabT = hVar.tab_tactics[id]
						local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
						if tabT then
							--local name = tabT.name --战术技能卡的名字
							--print(i, name, typeId)
							if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
								local activeSkill = tabT.activeSkill
								local passiveSkill = tabT.skillId
								if activeSkill and (type(activeSkill) == "table") then
									idx = idx + 1
									if (id == tacticId) then
										break
									end
								end
							end
						end
					end
				end
				activeIndex = idx
			end
		elseif (itemId) and (itemId ~= 0) then --道具技能卡
			local tabI = hVar.tab_item[itemId]
			
			--无效的道具技能卡id
			if (tabI == nil) then
				return
			end
			
			local nItemPivot = 0
			
			--遍历该玩家的全部英雄，找到此道具技能属于哪个英雄
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					for k = 1, #itemSkillT, 1 do
						--位置加1
						nItemPivot = nItemPivot + 1
						
						local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
						local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
						local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
						local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
						local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
						
						if (activeItemId == itemId) then --找到了
							local TacticTotalNum = 0
							local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
							for i = 1, #tTactics, 1 do
								if (tTactics[i] ~= 0) then
									local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
									local tabT = hVar.tab_tactics[id]
									local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
									if tabT then
										--local name = tabT.name --战术技能卡的名字
										--print(i, name, typeId)
										if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
											local activeSkill = tabT.activeSkill
											local passiveSkill = tabT.skillId
											if activeSkill and (type(activeSkill) == "table") then
												TacticTotalNum = TacticTotalNum + 1
											end
										end
									end
								end
							end
							
							activeIndex = TacticTotalNum + nItemPivot --位置索引值
							selected_skill_id = tabI.activeSkill.id
							activeSkillLv = activeItemLv --等级
							activeSkillType = tabI.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
							activeSkillRange = tabI.activeSkill.effectRange[activeItemLv] or 0
							activeSkillCD = activeItemCD or 0 --原始CD（单位:秒）
							activeSkillCostMana = tabI.activeSkill.costMana[activeItemLv] or 0
							activeSkillBindHero = oHero --此道具技能卡绑定的英雄对象
							activeSkillDeadUnUse = tabI.activeSkill.deadUnUse or 0 --此道具技能卡在英雄死后是否禁用
							activeSkillLastCastTime = activeItemLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							activeItemSkillT = itemSkillT[k]
							
							break
						end
					end
				end
			end
			
			--不存在的道具卡id
			if (activeIndex == 0) then
				return
			end
		end
		
		--print("activeIndex=", activeIndex, "activeSkillBindHero=", activeSkillBindHero and activeSkillBindHero.data.name)
		
		--战术技能卡控件(本地)
		local card = nil
		local currenttime = world:gametime() --当前时间
		if me and (me == oPlayer) then
			local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
			card = tacticCardCtrls[activeIndex]
			
			local btn = card
			local cd = btn.data.tacticCD
			local labCD = btn.data.labCD or 0
			if (labCD > 0) then --在cd中
				local labCdNew =  labCD + reduceCD
				if (labCdNew < 0) then
					labCdNew = 0
				end
				
				--if (labCdNew > cd) then
				--	labCdNew = cd
				--end
				
				--数据存储
				btn.data.tacticCastTime = activeSkillLastCastTime + reduceCD * 1000
				--if (btn.data.tacticCastTime > currenttime) then
				--	btn.data.tacticCastTime = currenttime
				--end
				btn.data.tacticCD = labCdNew
				btn.data.labCD = labCdNew
				
				--更新数字显cd文字
				if btn.childUI["labCd"] then
					btn.childUI["labCd"]:setText(labCdNew)
				end
				
				if btn.childUI["cd"] then
					local per = 0
					if cd > 0 then
						per = 100 - (labCdNew / cd) * 100
					end
					btn.childUI["cd"]:setPercentage(per)
				end
			end
			
			if (labCD <= 0) then --不在cd中
				if (reduceCD > 0) then --只处理加cd
					local labCdNew =  labCD + reduceCD
					if (labCdNew < 0) then
						labCdNew = 0
					end
					
					--if (labCdNew > cd) then
					--	labCdNew = cd
					--end
					
					--数据存储
					btn.data.tacticCastTime = activeSkillLastCastTime + reduceCD * 1000
					--if (btn.data.tacticCastTime > currenttime) then
					--	btn.data.tacticCastTime = currenttime
					--end
					btn.data.tacticCD = labCdNew
					btn.data.labCD = labCdNew
					
					--更新数字显cd文字
					if btn.childUI["labCd"] then
						btn.childUI["labCd"]:setText(labCdNew)
					end
					
					if btn.childUI["cd"] then
						local per = 0
						if cd > 0 then
							per = 100 - (labCdNew / cd) * 100
						end
						btn.childUI["cd"]:setPercentage(per)
					end
				end
			end
			
			--冒字
			local x = card.data.x
			local y = card.data.y
			local BubbleDx = -35
			if (g_phone_mode ~= 0) then
				BubbleDx = -50
			end
			if (reduceCD >= 0) then --加cd
				local ctrl = hUI.floatNumber:new({
					x = x + BubbleDx,
					y = y - 10,
					align = "RC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				--}):addtext("当前冷却-xx秒", hVar.FONTC, 32, "RC", 0, 0)
				}):addtext(hVar.tab_string["__Attr_Hint_cd_delta_rate_current"] .. "+" .. reduceCD .. hVar.tab_string["__Second"], hVar.FONTC, 28, "RC", 0, 0, {255, 0, 0})
			else --减cd
				local ctrl = hUI.floatNumber:new({
					x = x + BubbleDx,
					y = y - 10,
					align = "RC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				--}):addtext("当前冷却-xx秒", hVar.FONTC, 32, "RC", 0, 0)
				}):addtext(hVar.tab_string["__Attr_Hint_cd_delta_rate_current"] .. "-" .. (-reduceCD) .. hVar.tab_string["__Second"], hVar.FONTC, 28, "RC", 0, 0, {0, 255, 0})
			end
		end
		
		--[[
		--英雄也存储上次释放的时间（同步）
		if activeSkillBindHero and (activeSkillBindHero ~= 0) then
			if (tacticId) and (tacticId ~= 0) then --战术技能卡
				activeSkillBindHero.data.activeSkillLastCastTime = activeSkillLastCastTime + reduceCD * 1000 --geyachao: 主动技能的上次释放的时间（单位:毫秒）
				--if (activeSkillBindHero.data.activeSkillLastCastTime > currenttime) then
				--	activeSkillBindHero.data.activeSkillLastCastTime = currenttime
				--end
			elseif (itemId) and (itemId ~= 0) then --道具技能卡
				activeItemSkillT.activeItemLastCastTime = activeSkillLastCastTime + reduceCD * 1000 --主动技能的上次释放的时间（单位:毫秒）
				--if (activeItemSkillT.activeItemLastCastTime > currenttime) then
				--	activeItemSkillT.activeItemLastCastTime = currenttime
				--end
			end
		end
		]]
	end
	
	--玩家增加或减少战术(道具)技能卡的冷却时间上限（同步）
	--单位: 秒
	function hApi.ReducePlayerTacticCardCD_Max(oPlayer, tacticId, itemId, reduceCD)
		--print("hApi.ReducePlayerTacticCardCD_Max", oPlayer, tacticId, itemId, reduceCD)
		--防止弹框
		if (not oPlayer) then
			return
		end
		
		--无效的oPlayer
		if (not oPlayer.getpos) then
			return
		end
		
		--保留1位有效数字
		if (reduceCD >= 0) then --增加cd(1.5秒 -> 2秒)
			reduceCD = math.ceil(reduceCD * 10) / 10
		else --减少cd(-1.5秒 -> -2秒)
			reduceCD = math.floor(reduceCD * 10) / 10
		end
		
		--geyachao: 同步日志: 改变战术卡cd上限
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "ReduceTacticCD_Max: oPlayer=" .. oPlayer:getpos() .. ",tacticId=" .. tostring(tacticId) .. ",itemId=" .. tostring(itemId) .. ",reduceCD=" .. tostring(reduceCD)
			hApi.SyncLog(msg)
		end
		
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		
		--参数
		local activeIndex = 0 --位置索引值
		local selected_skill_id = 0
		local activeSkillLv = 0 --等级
		local activeSkillType = 0
		local activeSkillRange = 0
		local activeSkillCD = 0 --原始CD（单位:秒）
		local activeSkillCostMana = 0
		local activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
		local activeSkillDeadUnUse = 0 --此战术技能卡在英雄死后是否禁用
		local activeSkillLastCastTime = -math.huge --上次施法时间（单位:毫秒）
		local activeItemSkillT = nil --道具技能表
		
		if (tacticId) and (tacticId ~= 0) then --战术技能卡
			local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
			local tabT = nil --战术技能表
			local lv = 0
			local typeId = 0
			
			for i = 1, #tTactics, 1 do
				--print(i, "tTactics[i]=", tTactics[i])
				if (tTactics[i] ~= 0) then
					local id = tTactics[i][1]--geyachao: 该战术技能卡是哪个英雄的
					lv = tTactics[i][2] --geyachao: 该战术技能卡是哪个英雄的
					typeId = tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
					
					if (id == tacticId) then
						tabT = hVar.tab_tactics[id]
						break
					end
				end
			end
			
			--无效的战术技能卡id
			if (tabT == nil) then
				return
			end
			
			activeIndex = 0 --位置索引值
			selected_skill_id = tabT.activeSkill.id
			activeSkillLv = lv --等级
			activeSkillType = tabT.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
			activeSkillRange = tabT.activeSkill.effectRange[lv] or 0
			activeSkillCD = tabT.activeSkill.cd[lv] or 0 --原始CD（单位:秒）
			activeSkillCostMana = tabT.activeSkill.costMana[lv] or 0
			activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
			activeSkillDeadUnUse = tabT.activeSkill.deadUnUse or 0 --此战术技能卡在英雄死后是否禁用
			
			--读取英雄身上的减cd
			--print("typeId=", typeId)
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				if (oHero.data.id == typeId) then
					activeIndex = j
					activeSkillBindHero = oHero
					activeSkillCD = activeSkillBindHero.data.activeSkillCD
					activeSkillLastCastTime = oHero.data.activeSkillLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
					
					--print("activeSkillCD=", activeSkillCD)
					local tactics = activeSkillBindHero:gettactics()
					for k = 1, #tactics, 1 do
						local tactic = tactics[k]
						if tactic then
							local tacticIdk = tactic.id or 0
							local tacticLvk = tactic.lv or 1
							if (tacticId == tacticIdk) then
								activeSkillLv = tacticLvk --读取英雄的等级
								--print("读取英雄的等级=", activeSkillLv)
								break
							end
						end
					end
					
					break
				end
			end
			--print("activeSkillLv=", activeSkillLv)
			
			--如果该战术卡不属于英雄
			if (activeIndex == 0) then
				local idx = 0
				for i = 1, #tTactics, 1 do
					if (tTactics[i] ~= 0) then
						local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
						local tabT = hVar.tab_tactics[id]
						local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
						if tabT then
							--local name = tabT.name --战术技能卡的名字
							--print(i, name, typeId)
							if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
								local activeSkill = tabT.activeSkill
								local passiveSkill = tabT.skillId
								if activeSkill and (type(activeSkill) == "table") then
									idx = idx + 1
									if (id == tacticId) then
										break
									end
								end
							end
						end
					end
				end
				activeIndex = idx
			end
		elseif (itemId) and (itemId ~= 0) then --道具技能卡
			local tabI = hVar.tab_item[itemId]
			
			--无效的道具技能卡id
			if (tabI == nil) then
				return
			end
			
			local nItemPivot = 0
			
			--遍历该玩家的全部英雄，找到此道具技能属于哪个英雄
			--print("遍历该玩家的全部英雄，找到此道具技能属于哪个英雄")
			for j = 1, #oPlayer.heros, 1 do
				local oHero = oPlayer.heros[j]
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					for k = 1, #itemSkillT, 1 do
						--位置加1
						nItemPivot = nItemPivot + 1
						
						local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
						local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
						local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
						local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
						local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
						--print(k, activeItemId, activeItemLv, activeItemCD, activeItemLastCastTime)
						if (activeItemId == itemId) then --找到了
							local TacticTotalNum = 0
							local tTactics = world:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
							for i = 1, #tTactics, 1 do
								if (tTactics[i] ~= 0) then
									local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
									local tabT = hVar.tab_tactics[id]
									local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
									if tabT then
										--local name = tabT.name --战术技能卡的名字
										--print(i, name, typeId)
										if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
											local activeSkill = tabT.activeSkill
											local passiveSkill = tabT.skillId
											if activeSkill and (type(activeSkill) == "table") then
												TacticTotalNum = TacticTotalNum + 1
											end
										end
									end
								end
							end
							
							activeIndex = TacticTotalNum + nItemPivot --位置索引值
							selected_skill_id = tabI.activeSkill.id
							activeSkillLv = activeItemLv --等级
							activeSkillType = tabI.activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
							activeSkillRange = tabI.activeSkill.effectRange[activeItemLv] or 0
							activeSkillCD = activeItemCD or 0 --原始CD（单位:秒）
							activeSkillCostMana = tabI.activeSkill.costMana[activeItemLv] or 0
							activeSkillBindHero = oHero --此道具技能卡绑定的英雄对象
							activeSkillDeadUnUse = tabI.activeSkill.deadUnUse or 0 --此道具技能卡在英雄死后是否禁用
							activeSkillLastCastTime = activeItemLastCastTime --geyachao: 主动技能的上次释放的时间（单位:毫秒）
							activeItemSkillT = itemSkillT[k]
							
							break
						end
					end
				end
			end
			
			--不存在的道具卡id
			if (activeIndex == 0) then
				--加入缓存
				local oHero = oPlayer.heros[1]
				if oHero then
					local itemSkillTCache = oHero.data.itemSkillTCache
					local bFind = false --是否找到
					for jt = 1, #itemSkillTCache, 1 do
						local itemId_jt = itemSkillTCache[jt].itemId
						local itemCd_jt = itemSkillTCache[jt].itemCd
						if (itemId_jt == itemId) then --找到缓存了
							itemSkillTCache[jt].itemCd = itemSkillTCache[jt].itemCd + reduceCD
							--print("叠加缓存cd", itemId, reduceCD)
							bFind = true
							break
						end
					end
					
					--未找到就新插入缓存
					if (not bFind) then
						--print("新加缓存cd", itemId, reduceCD)
						itemSkillTCache[#itemSkillTCache+1] = {itemId = itemId, itemCd = reduceCD,}
					end
				end
				
				return
			end
		end
		
		--print("activeIndex=", activeIndex, "activeSkillBindHero=", activeSkillBindHero and activeSkillBindHero.data.name)
		
		--cd减到0.5秒，不会再减
		if ((activeSkillCD + reduceCD) <= 0.5) then
			reduceCD = 0.5 - activeSkillCD
		end
		
		--战术技能卡控件(本地)
		local card = nil
		local currenttime = world:gametime() --当前时间
		if me and (me == oPlayer) then
			local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
			card = tacticCardCtrls[activeIndex]
			
			local btn = card
			btn.data.tacticCD = btn.data.tacticCD + reduceCD
			
			local cd = btn.data.tacticCD
			local labCD = btn.data.labCD or 0
			if (labCD > 0) then --在cd中
				local labCdNew = labCD + reduceCD
				if (labCdNew < 0) then
					labCdNew = 0
				end
				
				--if (labCdNew > cd) then
				--	labCdNew = cd
				--end
				
				--数据存储
				btn.data.tacticCastTime = activeSkillLastCastTime + reduceCD * 1000
				--if (btn.data.tacticCastTime > currenttime) then
				--	btn.data.tacticCastTime = currenttime
				--end
				btn.data.tacticCD = labCdNew
				btn.data.labCD = labCdNew
				
				--更新数字显cd文字
				if btn.childUI["labCd"] then
					btn.childUI["labCd"]:setText(labCdNew)
				end
				
				if btn.childUI["cd"] then
					local per = 0
					if cd > 0 then
						per = 100 - (labCdNew / cd) * 100
					end
					btn.childUI["cd"]:setPercentage(per)
				end
			end
			
			if (labCD <= 0) then --不在cd中
				if (reduceCD > 0) then --只处理加cd
					local labCdNew =  labCD + reduceCD
					if (labCdNew < 0) then
						labCdNew = 0
					end
					
					--if (labCdNew > cd) then
					--	labCdNew = cd
					--end
					
					--数据存储
					btn.data.tacticCastTime = activeSkillLastCastTime + reduceCD * 1000
					--if (btn.data.tacticCastTime > currenttime) then
					--	btn.data.tacticCastTime = currenttime
					--end
					btn.data.tacticCD = labCdNew
					btn.data.labCD = labCdNew
					
					if btn.childUI["labCd"] then
						btn.childUI["labCd"]:setText(labCdNew)
					end
					
					if btn.childUI["cd"] then
						local per = 0
						if cd > 0 then
							per = 100 - (labCdNew / cd) * 100
						end
						btn.childUI["cd"]:setPercentage(per)
					end
				end
			end
			
			--冒字
			local x = card.data.x
			local y = card.data.y
			local BubbleDx = -35
			if (g_phone_mode ~= 0) then
				BubbleDx = -50
			end
			--if (reduceCD >= 0) then --加cd
				--local ctrl = hUI.floatNumber:new({
					--x = x + BubbleDx,
					--y = y - 10,
					--align = "RC",
					--text = "",
					--lifetime = 1000,
					--fadeout = -550,
					--moveY = 32,
				----}):addtext("冷却-xx秒", hVar.FONTC, 32, "RC", 0, 0)
				--}):addtext(hVar.tab_string["__Attr_Hint_cd_delta_rate"] .. "+" .. reduceCD .. hVar.tab_string["__Second"], hVar.FONTC, 28, "RC", 0, 0, {255, 0, 0})
			--else --减cd
				--local ctrl = hUI.floatNumber:new({
					--x = x + BubbleDx,
					--y = y - 10,
					--align = "RC",
					--text = "",
					--lifetime = 1000,
					--fadeout = -550,
					--moveY = 32,
				----}):addtext("冷却-xx秒", hVar.FONTC, 32, "RC", 0, 0)
				--}):addtext(hVar.tab_string["__Attr_Hint_cd_delta_rate"] .. "-" .. (-reduceCD) .. hVar.tab_string["__Second"], hVar.FONTC, 28, "RC", 0, 0, {0, 255, 0})
			--end
		end
		
		--英雄也存储cd改变（同步）
		if activeSkillBindHero and (activeSkillBindHero ~= 0) then
			if (tacticId) and (tacticId ~= 0) then --战术技能卡
				activeSkillBindHero.data.activeSkillCD = activeSkillCD + reduceCD --geyachao: 主动技能的上次释放的时间（单位:秒）
				--if (activeSkillBindHero.data.activeSkillLastCastTime > currenttime) then
				--	activeSkillBindHero.data.activeSkillLastCastTime = currenttime
				--end
			elseif (itemId) and (itemId ~= 0) then --activeItemCD
				activeItemSkillT.activeItemCD = activeSkillCD + reduceCD --主动技能的上次释放的时间（单位:毫秒）
				--if (activeItemSkillT.activeItemLastCastTime > currenttime) then
				--	activeItemSkillT.activeItemLastCastTime = currenttime
				--end
			end
		end
	end
	
	--创建单个主动战术(道具)技能卡的主动技能界面
	--参数: paramActiveSkillNum:指定要添加的位置
	__CreateSingleActiveTacticCtrl = function(parentFrm, tacticId, itemId, lv, num, typeId, paramActiveSkillNum)
		--print("__CreateSingleActiveTacticCtrl", tacticId, itemId, lv, typeId)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local typeT = nil --类型
		local activeSkill  = nil --主动技能表
		local remouldUnlock  = nil --解锁技能表
		if tacticId and (tacticId ~= 0) then
			local tabT = hVar.tab_tactics[tacticId]
			id = tacticId
			typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
			activeSkill = tabT.activeSkill
			remouldUnlock = tabT.remouldUnlock
		elseif itemId and (itemId ~= 0) then
			local tabI = hVar.tab_item[itemId]
			id = itemId
			typeT = hVar.TACTICS_TYPE.OTHER
			activeSkill = tabI.activeSkill
			remouldUnlock = nil
		end
		
		--技能释放
		if (typeT == hVar.TACTICS_TYPE.OTHER) and activeSkill then
			local activeSkillId = activeSkill.id
			local activeSkillLv = lv
			local activeSkillType = activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
			local activeSkillRange = activeSkill.effectRange[lv] or 0
			local activeSkillCD = activeSkill.cd[lv] or 0 --原始CD（单位:秒）
			local activeSkillCostMana = activeSkill.costMana[lv] or 0
			local activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
			local activeSkillDeadUnUse = activeSkill.deadUnUse or 0 --此战术技能卡在英雄死后是否禁用
			local activeSkillUseCount = activeSkill.useCount or 1 --此战术技能卡使用几次后转cd
			local activeSkillIsBuildTower = activeSkill.isBuildTower or 0 --是否建造塔（战术卡界面放左边）
			
			if activeSkillId and (activeSkillId > 0) and (hVar.tab_skill[activeSkillId]) then
				--参数: paramActiveSkillNum:指定要添加的位置
				if paramActiveSkillNum then
					local old___activeSkillNum = __activeSkillNum
					__activeSkillNum = paramActiveSkillNum
					paramActiveSkillNum = old___activeSkillNum
				else
					__activeSkillNum = __activeSkillNum + 1
				end
				
				--先删除原先的此位置的卡牌界面
				hApi.safeRemoveT(parentFrm.childUI, "btnTactics_" .. __activeSkillNum)
				hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_" .. __activeSkillNum)
				hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_YYZ_" .. __activeSkillNum)
				
				--读取单位身上技能基础技能等级
				--local basic_skill_level = 0
				--if (itemId == xxx) then
				--end
				
				--local activeSkillIcon = hVar.tab_skill[activeSkillId].icon
				local useLimit = num or -1
				
				--pad的尺寸
				local x = hVar.SCREEN.w - 50 --技能1-x
				if (__activeSkillNum == 2) then --技能2-x
					x = hVar.SCREEN.w - 50 - 90
				end
				if (__activeSkillNum == 4) then --技能3-x
					x = hVar.SCREEN.w - 50 - 20
				end
				if (__activeSkillNum == 3) then --技能4-x
					--x = hVar.SCREEN.w - 50 - 180
					x = hVar.SCREEN.w - 50 - 165
				end
				if (__activeSkillNum >= 5) and (__activeSkillNum <= 8) then --技能5~8-x
					x = hVar.SCREEN.w - 50 - 20
				end
				if (__activeSkillNum >= 9) then --技能9-x
					x = hVar.SCREEN.w + 50 + 20
				end
				
				--pad的尺寸
				local y =  150 - 75 * (__activeSkillNum - 1) - 60 --技能1-y
				if (__activeSkillNum == 2) then --技能2-y
					y = 150 - 60
				end
				if (__activeSkillNum == 4) then --技能3-y
					y = 150 - 60 + 30
				end
				if (__activeSkillNum == 3) then --技能4-y
					--y = 120 - 60
					y = 150 - 60
				end
				if (__activeSkillNum >= 5) and (__activeSkillNum <= 8) then --技能5~8-y
					y = 150 - 60 + 30 + 140 + (__activeSkillNum - 5) * 128
				end
				if (__activeSkillNum >= 9) then --技能9-y
					y = 150 - 60 + 30 + 140 + (__activeSkillNum - 5) * 128
				end
				
				--[[
				--pad的尺寸
				local scale = 1.3 --底图缩放
				local scale1 = 1.3 --图标缩放
				]]
				--pad的尺寸
				local scale = 1.2 --底图缩放
				local scale1 = 1.2 --图标缩放
				
				if (g_phone_mode ~= 0) then --手机模式
					--iphone尺寸
					x = hVar.SCREEN.w - 50 --技能1-x
					if (__activeSkillNum == 2) then
						x = hVar.SCREEN.w - 50 - 100 --技能2-x
					end
					if (__activeSkillNum == 4) then
						x = hVar.SCREEN.w - 70 --技能3-x
					end
					if (__activeSkillNum == 3) then
						--x = hVar.SCREEN.w - 50 - 200 --技能4-x
						x = hVar.SCREEN.w - 50 - 145 --技能3-x
					end
					if (__activeSkillNum == 5) then
						x = hVar.SCREEN.w - 70 --技能5-x
					end
					if (__activeSkillNum == 6) then
						x = hVar.SCREEN.w - 70 --技能6-x
					end
					if (__activeSkillNum == 7) then
						x = hVar.SCREEN.w - 70 --技能7-x
					end
					if (__activeSkillNum == 8) then
						x = hVar.SCREEN.w - 70 - 100 --技能8-x
					end
					if (__activeSkillNum == 9) then
						x = hVar.SCREEN.w - 70 - 100 --技能9-x
					end
					if (__activeSkillNum == 10) then
						x = hVar.SCREEN.w - 70 - 100 --技能10-x
					end
					if (__activeSkillNum >= 11) then
						x = hVar.SCREEN.w - 70 - 100 --技能11~N-x
					end
					
					--iphone尺寸
					y = 150 - 95 * (__activeSkillNum - 1) - 90 --技能1-y
					if (__activeSkillNum == 2) then --技能2-y
						y = 150 - 90
					end
					if (__activeSkillNum == 4) then --技能3-y
						y = 150 - 90 + 80
					end
					if (__activeSkillNum == 3) then --技能4-y
						--y = 150 - 90
						y = 150 - 90
					end
					if (__activeSkillNum == 5) then --技能5-y
						y = 150 - 90 + 80 + 160 + 140 * 0
					end
					if (__activeSkillNum == 6) then --技能6-y
						y = 150 - 90 + 80 + 160 + 140 * 1
					end
					if (__activeSkillNum == 7) then --技能7-y
						y = 150 - 90 + 80 + 160 + 140 * 2
					end
					if (__activeSkillNum == 8) then --技能8-y
						y = 150 - 90 + 80 + 160 + 140 * 0
					end
					if (__activeSkillNum == 9) then --技能9-y
						y = 150 - 90 + 80 + 160 + 140 * 1
					end
					if (__activeSkillNum == 10) then --技能10-y
						y = 150 - 90 + 80 + 160 + 140 * 2
					end
					if (__activeSkillNum >= 11) then --技能11~N-y
						y = 150 - 90 + 80 + 160 + 140 * (__activeSkillNum - 8)
					end
					--[[
					--iphone尺寸
					scale = 1.4
					scale1 = 1.4
					]]
					--iphone尺寸
					scale = 1.2
					scale1 = 1.2
				end
				
				if (g_phone_mode == 3) then --iphone6
					--iphone6尺寸
					x = hVar.SCREEN.w - 75 - 0 --技能1-x
					if (__activeSkillNum == 2) then
						x = hVar.SCREEN.w - 75 - 165 - 0 --技能2-x
					end
					if (__activeSkillNum == 4) then
						x = hVar.SCREEN.w - 75 - 5 - 0 --技能3-x
					end
					if (__activeSkillNum == 3) then
						x = hVar.SCREEN.w - 75 - 165  - 0 --技能4-x
					end
					if (__activeSkillNum == 5) then
						x = hVar.SCREEN.w - 75 - 5 --技能5-x
					end
					if (__activeSkillNum == 6) then
						x = hVar.SCREEN.w - 75 - 5 --技能6-x
					end
					if (__activeSkillNum == 7) then
						x = hVar.SCREEN.w - 75 - 5 --技能7-x
					end
					if (__activeSkillNum == 8) then
						x = hVar.SCREEN.w - 75 - 5 - 165 --技能8-x
					end
					if (__activeSkillNum == 9) then
						x = hVar.SCREEN.w - 75 - 5 - 165 --技能9-x
					end
					if (__activeSkillNum == 10) then
						x = hVar.SCREEN.w - 75 - 5 - 165 --技能10-x
					end
					if (__activeSkillNum >= 11) then
						x = hVar.SCREEN.w - 75 - 5 - 165 --技能11~N-x
					end
					
					--iphone6尺寸
					y = 150 - 95 * (__activeSkillNum - 1) - 60 --技能1-y
					if (__activeSkillNum == 2) then --技能2-y
						y = 150 - 60
					end
					if (__activeSkillNum == 4) then --技能3-y
						y = 150 - 60 + 5 + 80
					end
					if (__activeSkillNum == 3) then --技能4-y
						--y = 150 - 60
						y = 150 - 60 + 5
					end
					if (__activeSkillNum == 5) then --技能5-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 0
					end
					if (__activeSkillNum == 6) then --技能6-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 1
					end
					if (__activeSkillNum == 7) then --技能7-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 2
					end
					if (__activeSkillNum == 8) then --技能8-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 0
					end
					if (__activeSkillNum == 9) then --技能9-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 1
					end
					if (__activeSkillNum == 10) then --技能10-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 2
					end
					if (__activeSkillNum >= 11) then --技能11~N-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * (__activeSkillNum - 8) + 130
					end
					--[[
					--iphoneX尺寸
					scale = 1.8
					scale1 = 1.8
					]]
					--iphoneX尺寸
					scale = 1.2
					scale1 = 1.2
				end
				
				if (g_phone_mode == 4) then --iphoneX
					--iphoneX尺寸
					x = hVar.SCREEN.w - 75 - 110 --技能1-x
					if (__activeSkillNum == 2) then
						x = hVar.SCREEN.w - 75 - 165 - 110 --技能2-x
					end
					if (__activeSkillNum == 4) then
						x = hVar.SCREEN.w - 75 - 5 - 110 --技能3-x
					end
					if (__activeSkillNum == 3) then
						x = hVar.SCREEN.w - 75 - 165  - 110 --技能4-x
					end
					if (__activeSkillNum == 5) then
						x = hVar.SCREEN.w - 75 - 5 - 110 --技能5-x
					end
					if (__activeSkillNum == 6) then
						x = hVar.SCREEN.w - 75 - 5 - 110 --技能6-x
					end
					if (__activeSkillNum == 7) then
						x = hVar.SCREEN.w - 75 - 5 - 110 --技能7-x
					end
					if (__activeSkillNum == 8) then
						x = hVar.SCREEN.w - 75 - 5 - 110 - 165 --技能8-x
					end
					if (__activeSkillNum == 9) then
						x = hVar.SCREEN.w - 75 - 5 - 110 - 165 --技能9-x
					end
					if (__activeSkillNum == 10) then
						x = hVar.SCREEN.w - 75 - 5 - 110 - 165 --技能10-x
					end
					if (__activeSkillNum >= 11) then
						x = hVar.SCREEN.w - 75 - 5 - 110 - 165 --技能11~N-x
					end
					
					--iphoneX尺寸
					y = 150 - 95 * (__activeSkillNum - 1) - 60 --技能1-y
					if (__activeSkillNum == 2) then --技能2-y
						y = 150 - 60
					end
					if (__activeSkillNum == 4) then --技能3-y
						y = 150 - 60 + 5 + 80
					end
					if (__activeSkillNum == 3) then --技能4-y
						y = 150 - 60 + 5
					end
					if (__activeSkillNum == 5) then --技能5-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 0
					end
					if (__activeSkillNum == 6) then --技能6-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 1
					end
					if (__activeSkillNum == 7) then --技能7-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 2
					end
					if (__activeSkillNum == 8) then --技能8-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 0
					end
					if (__activeSkillNum == 9) then --技能9-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 1
					end
					if (__activeSkillNum == 10) then --技能10-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * 2
					end
					if (__activeSkillNum >= 11) then --技能11~N-y
						y = 150 - 60 + 5 + 80 + 140 + 130 * (__activeSkillNum - 8) + 130
					end
					--[[
					--iphoneX尺寸
					scale = 1.8
					scale1 = 1.8
					]]
					--iphoneX尺寸
					scale = 1.2
					scale1 = 1.2
				end
				
				--geyachao: 竞技场，战术卡按钮往下挪一点点
				--if (hGlobal.WORLD.LastWorldMap) and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				--	y = y - 30
				--end
				
				scale = 1.2
				scale1 = 1.2
				
				--战术技能卡按钮
				local activeSkillIcon = hVar.tab_skill[activeSkillId].icon
				if tacticId and (tacticId ~= 0) then
					activeSkillIcon = hVar.tab_tactics[tacticId].icon
				end
				if itemId and (itemId ~= 0) then
					activeSkillIcon = hVar.tab_item[itemId].icon
				end
				local activeSkillCastType = hVar.tab_skill[activeSkillId].cast_type
				if tacticId and (tacticId ~= 0) then
					activeSkillCastType = hVar.tab_tactics[tacticId].activeSkill.type
				end
				--print("btnTacticsMask_"..tostring(__activeSkillNum))
				if __activeSkillNum == 3 then
					scale = 1.6
					scale1 = 1.6
				end
				
				if (activeSkillIsBuildTower == 1) then --建造塔类战术卡
					activeSkillIcon = "icon/item/towergun_normal.png"
				end
				
				local icon = activeSkillIcon
				local btnW = -1
				local btnH = -1
				--因为点击区域的问题  加了这些参数
				if __activeSkillNum > 4 then
					icon = "misc/button_null.png"
					--icon = "misc/mask_white.png"
					btnW = 96 * scale
					btnH = 72 * scale
				end
				
				--横屏
				if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
					--geyachao: 王总说左边放造枪塔，右边放战术技能卡
					local leftSkillNum = 0
					local rightSkillNum = 0
					--分别统计左右侧战术卡的数量
					for i = 1, __activeSkillNum - 1, 1 do
						local btni = parentFrm.childUI["btnTactics_" .. i]
						if btni and (btni ~= 0) then
							local activeSkillIsBuildTower = btni.data.activeSkillIsBuildTower or 0 --是否建造塔（战术卡界面放左边）
							if (activeSkillIsBuildTower == 1) then
								leftSkillNum = leftSkillNum + 1
							else
								rightSkillNum = rightSkillNum + 1
							end
						else
							rightSkillNum = rightSkillNum + 1
						end
					end
					
					--横屏
					--本次是建造塔（战术卡界面放左边）
					if (activeSkillIsBuildTower == 1) then
						leftSkillNum = leftSkillNum + 1
						
						if (leftSkillNum >= 1) then --技能1~6-xy
							x = 56 + iPhoneX_WIDTH --技能5-x
							y = 150 - 60 + 5 + 80 + 120 + (leftSkillNum - 1) * 110 --技能5-y
						end
					else --放右边
						rightSkillNum = rightSkillNum + 1
						
						if (rightSkillNum >= 5) then --技能5~8-xy
							x = hVar.SCREEN.w - 64 - iPhoneX_WIDTH --技能5-x
							y = 150 - 60 + 5 + 80 + 120 + (rightSkillNum - 5) * 100 --技能5-y
						end
						
						if (rightSkillNum >= 9) then --技能9~12-xy
							x = hVar.SCREEN.w - 64 - iPhoneX_WIDTH - 130 --技能9-x
							y = 150 - 60 + 5 + 80 + 120 + (rightSkillNum - 9) * 100 --技能9-y
						end
						
						if (rightSkillNum >= 13) then --技能13~N-xy
							x = hVar.SCREEN.w - 64 - iPhoneX_WIDTH - 130 --技能13-x
							y = 150 - 60 + 5 + 80 + 120 + (rightSkillNum - 9) * 100 + 100 --技能13-y
						end
					end
					
					scale = 1.2
					scale1 = 1.2
				end
				
				--竖屏
				if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
					--geyachao: 王总说左边放造枪塔，右边放战术技能卡
					local leftSkillNum = 0
					local rightSkillNum = 0
					local verticalOffY = hVar.SCREEN.battleUI_offy
					--分别统计左右侧战术卡的数量
					for i = 1, __activeSkillNum - 1, 1 do
						local btni = parentFrm.childUI["btnTactics_" .. i]
						if btni and (btni ~= 0) then
							local activeSkillIsBuildTower = btni.data.activeSkillIsBuildTower or 0 --是否建造塔（战术卡界面放左边）
							if (activeSkillIsBuildTower == 1) then
								leftSkillNum = leftSkillNum + 1
							else
								rightSkillNum = rightSkillNum + 1
							end
						else
							rightSkillNum = rightSkillNum + 1
						end
					end
					
					if hVar.CONTROL_MODE == hVar.CONTROL_MODE_DEFINE.LOCAL_LEFT then --锁左边
						if (__activeSkillNum == 4) then --技能3-y
							x = hVar.SCREEN.w - 75 - 30
							y = 250 - 60 + 5 + 150 + verticalOffY
						end
						if (__activeSkillNum == 3) then --技能4-y
							x = hVar.SCREEN.w - 75 - 150
							y = 250 - 60 + 5 + 10 + verticalOffY
						end
					elseif hVar.CONTROL_MODE == hVar.CONTROL_MODE_DEFINE.LOCAL_NO then --无锁
						if hVar.CONTROL_NOW == 0 then
							if (__activeSkillNum == 4) then --技能4-y
								x = hVar.SCREEN.w - 75 - 30
								y = 250 - 60 + 5 + 150 + 100 + verticalOffY
							end
							if (__activeSkillNum == 3) then --技能3-y
								x = hVar.SCREEN.w - 75 - 150 + 90
								y = 250 - 60 + 5 + 30 + verticalOffY
							end
						else
							if (__activeSkillNum == 4) then --技能4-y
								x = 75 + 30
								y = 250 - 60 + 5 + 150 + verticalOffY
							end
							if (__activeSkillNum == 3) then --技能3-y
								x = 75 + 150
								y = 250 - 60 + 5 + 10 + verticalOffY
							end
						end
					else --锁右边
						if (__activeSkillNum == 4) then --技能3-y
							x = 75 + 30
							y = 250 - 60 + 5 + 150 + verticalOffY
						end
						if (__activeSkillNum == 3) then --技能4-y
							x = 75 + 150
							y = 250 - 60 + 5 + 10 + verticalOffY
						end
					end
					
					--竖屏
					--本次是建造塔（战术卡界面放左边）
					if (activeSkillIsBuildTower == 1) then
						leftSkillNum = leftSkillNum + 1
						
						if (leftSkillNum >= 1) then --技能1~6-xy
							x = 75 - 18 --技能5-x
							y = 250 - 60 + 5 + 150 + 150 + (leftSkillNum - 1) * 110 + verticalOffY --技能5-y
						end
						
						if (leftSkillNum >= 7) then --技能7~N-xy
							x = 75 - 18 --技能7~N-x
							y = 250 - 60 + 5 + 150 + 160 + (leftSkillNum - 1) * 120 + 110 + verticalOffY --技能11~N-y
							
						end
					else --放右边
						rightSkillNum = rightSkillNum + 1
						
						if (rightSkillNum >= 5) then --技能5~10-xy
							x = hVar.SCREEN.w - 75 - 8 --技能5-x
							y = 250 - 60 + 5 + 150 + 150 + (rightSkillNum - 5) * 120 + 100 + verticalOffY --技能5-y
							
							if (g_phone_mode == 4) then --iphoneX
								x = hVar.SCREEN.w - 75 - 10 --技能5-x
								y = 250 - 60 + 5 + 150 + 150 + (rightSkillNum - 5) * 120 + 100 + verticalOffY --技能5-y
							end
						end
						
						--iphone6/iphone7/iphone8
						if (rightSkillNum == 10) then --技能110-xy
							if (g_phone_mode == 3) then --iphone6/iphone7/iphone8
								x = hVar.SCREEN.w - 75 - 8 - 120 --技能11~N-x
								y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 11) * 120 + 130 - 60 + 100 + verticalOffY --技能11~N-y
							end
							
						end
						
						if (rightSkillNum == 11) then --技能11-xy
							x = hVar.SCREEN.w - 75 - 8 - 120 --技能11~N-x
							y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 12) * 120 + 130 - 60 + 100 + verticalOffY --技能11~N-y
							
							if (g_phone_mode == 4) then --iphoneX
								x = hVar.SCREEN.w - 75 - 10 - 120 --技能11~N-x
								y = 250 - 60 + 5 + 150*1 + 180 + (rightSkillNum - 11) * 120 - 60 + 130 + verticalOffY --技能11~N-y
							end
							
							if (g_phone_mode == 3) then --iphone6/iphone7/iphone8
								x = hVar.SCREEN.w - 75 - 8  - 180 --技能12~N-x
								y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 12) * 120 + 130 - 170 + 100 + verticalOffY --技能12~N-y
							end
						end
						
						if (rightSkillNum == 12) then --技能12-xy
							x = hVar.SCREEN.w - 75 - 8  - 180 --技能12~N-x
							y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 13) * 120 + 130 - 170 + 100 + verticalOffY --技能12~N-y
							
							if (g_phone_mode == 4) then --iphoneX
								x = hVar.SCREEN.w - 75 - 10 - 180 --技能12~N-x
								y = 250 - 60 + 5 + 150*1 + 180 + (rightSkillNum - 12) * 120 - 170 + 100 + verticalOffY --技能12~N-y
							end
							
							if (g_phone_mode == 3) then --iphone6/iphone7/iphone8
								x = hVar.SCREEN.w - 75 - 8 --技能11~N-x
								y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 7) * 120 + 130 + 100 + verticalOffY --技能13~N-y
							end
						end
						
						if (rightSkillNum >= 13) then --技能13~N-xy
							x = hVar.SCREEN.w - 75 - 8 --技能11~N-x
							y = 250 - 60 + 5 + 150*1 + 160 + (rightSkillNum - 7) * 120 + 130 + 100 + verticalOffY --技能13~N-y
							
							if (g_phone_mode == 4) then --iphoneX
								x = hVar.SCREEN.w - 75 - 10 --技能11~N-x
								y = 250 - 60 + 5 + 150*1 + 180 + (rightSkillNum - 7) * 120 + 380 + 100 + verticalOffY --技能13~N-y
							end
							
						end
					end
					
					--scale = 1.2
					--scale1 = 1.2
				end
				
				parentFrm.childUI["btnTacticsMask_"..tostring(__activeSkillNum)] = hUI.button:new({  
					parent = parentFrm,
					x = x,
					y = y,
					z = -1,
					dragbox = _frm.childUI["dragBox"],
					--model = activeSkillIcon,
					model = "misc/mask.png",
					animation = "light",
					label = "", --文字
					scaleT = 1.0, --按下的缩放值
					--scale = scale,
					w = 128 * scale * 1,
					h = 128 * scale * 1,
					code = function()
						--print("点击了背景")
					end,
				})
				parentFrm.childUI["btnTacticsMask_"..tostring(__activeSkillNum)].handle.s:setOpacity(0) --不显示，只响应事件
				
				local scaleT = 0.9
				if (__activeSkillNum == 4) then
					--scaleT = 1.0
					scaleT = 0.9
				end
				local skillNum = __activeSkillNum
				--用于cd时显示
				parentFrm.childUI["btnTactics_"..tostring(__activeSkillNum)] = hUI.button:new({
					parent = parentFrm,
					--zhenkira 底部位置 2015.12.9
					--x = towerOffset + 60 + 88 * (__activeSkillNum - 1),
					--y = 80,
					x = x,
					y = y,
					dragbox = _frm.childUI["dragBox"],
					scale = scale,
					--zhenkira 以下注释无视
					w = btnW,
					h = btnH,
					--model = "UI:tactic_card_1",
					model = icon, --"misc/mask.png", --icon,
					animation = "light",
					label = "", --文字
					--scaleT = scaleT, --按下的缩放值
					scaleT = 1.0, --按下的缩放值
					--failcall = 1, --出按钮区域抬起也会响应事件 --geyachao: 只处理里面点击
					
					--[[
					--按下事件
					codeOnTouch = function(self, screenX, screenY, isInside)
						
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						if activeSkillCostMana > mapInfo.gold then
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							return
						end
						
						--标记当前选中的技能
						selected_skill_id = activeSkillId
					end,
					
					--滑动事件
					codeOnDrag = function(self, screenX, screenY, isInside)
						screenY = screenY + OFFSET_Y --手机上往上移一点
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						if activeSkillCostMana > mapInfo.gold then
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							return
						end
						
						--如果对地释放类技能才能拖放
						if (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND) then
							if (isInside == 1) then --在控件内部
								--删除焦点控件
								if focus_ctrl then
									focus_ctrl:del()
									focus_ctrl = nil
								end
							else --在控件外部
								--创建焦点控件
								if (not focus_ctrl) then
									if (activeSkillRange > 0) then
										focus_ctrl = hUI.image:new({
											parent = nil,
											model = "MODEL_EFFECT:SelectCircle",
											animation = "range",
											color = {30, 144, 255},
											alpha = 48,
											z = -255,
											w = activeSkillRange * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
										})
										
										--shader
										local program = hApi.getShader("atkrange")
										local resolution = program:glGetUniformLocation("resolution")
										program:setUniformLocationWithFloats(resolution,66,66)
										focus_ctrl.handle.s:setShaderProgram(program)
									end
								end
								
								--设置焦点控件的位置
								focus_ctrl:setXY(screenX, screenY)
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面坐标
							if (isInside == 1) then --在控件内部
								--删除焦点控件
								if focus_ctrl then
									focus_ctrl:del()
									focus_ctrl = nil
								end
								
								--标记有效地面的位置，当前是无效的
								--bValidBlock = false --是否是有效的位置（对有效的地面点击才会判断）
							else --在控件外部
								--检测当前的位置是否是有效
								--
								--创建焦点控件
								if (not focus_ctrl) then
									focus_ctrl = hUI.button:new(
									{
										parent = nil,
										model = "MODEL_EFFECT:Hand", --BTN:PANEL_CLOSE
										x = screenX,
										y = screenY,
										scale = 0.9, --缩放比例
									})
									--focus_ctrl.handle.s:setColor(ccc3(255, 0, 0))
								end
								
								--设置焦点控件的位置
								focus_ctrl:setXY(screenX, screenY)
							end
						elseif (activeSkillType == hVar.CAST_TYPE.IMMEDIATE) then
							--如果是直接释放技能，当移动到按钮外面则不释放
							if isInside ~= 1 then
								selected_skill_id = 0
							end
						end
					end,
					]]
					
					--按下事件
					codeOnTouch = function(self, screenX, screenY, isInside)
						print("按下事件", screenX, screenY, isInside)
						--if hGlobal.WORLD.VitrualController then
						--	hGlobal.WORLD.VitrualController:onTouchesEnded(0, 0)
						--end
						
						--如果当前禁止响应事件，不处理
						if (oWorld.data.keypadEnabled ~= true) then
							return
						end
						
						--该控件在动画中，禁止点击
						if (self.data.disabled == true) then
							return
						end
						
						--点击了攻击按钮
						if (self.data.index == 4) then
							local oWorld = hGlobal.WORLD.LastWorldMap
							if oWorld then
								local mapInfo = oWorld.data.tdMapInfo
								if mapInfo then
									--第一波及以后才能加钱
									local waveNow = mapInfo.wave
									if (waveNow < 1) then
										--冒字文字提示
										local BubbleDx = -35
										if (g_phone_mode ~= 0) then
											BubbleDx = -50
										end
										hUI.floatNumber:new({
											x = x + BubbleDx,
											y = y - 10,
											align = "RC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										--}):addtext("开战后才能使用", hVar.FONTC, 32, "RC", 0, 0)
										}):addtext(hVar.tab_string["BattleCanUse"], hVar.FONTC, 32, "RC", 0, 0)
										
										return
									end
								end
								local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
								if oUnit and (oUnit ~= 0) then --单位活着
									--if (oWorld.data.weapon_attack_state == 0) then --非攻击状态
										----标记为攻击
										--oWorld.data.weapon_attack_state = 1
										----self.childUI["icon"]:setmodel("misc/skill4-hit.png", nil, nil, 90, 90)
										
										----添加timer，检测是否长按
										--hApi.addTimerOnce("__Check_LongClick_Diablo__", 1500, function()
											----标记自动攻击
											--oWorld.data.weapon_attack_state = 2
											
											----删除timer
											--hApi.clearTimer("__Check_LongClick_Diablo__")
											
											----显示自动攻击图标
											--self.childUI["labSkillAutoCast"].handle._n:setVisible(true)
										--end)
									--elseif (oWorld.data.weapon_attack_state == 1) then --攻击状态
										----标记非攻击
										--oWorld.data.weapon_attack_state = 0
										
										----删除timer
										--hApi.clearTimer("__Check_LongClick_Diablo__")
										
										----隐藏自动攻击图标
										--self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
									--if (oWorld.data.weapon_attack_state == 0) then
										----标记非攻击
										--oWorld.data.weapon_attack_state = 2
										
										----隐藏自动攻击图标
										--self.childUI["labSkillAutoCast"].handle._n:setVisible(true)
									--elseif (oWorld.data.weapon_attack_state == 2) then --自动攻击状态
										----标记非攻击
										--oWorld.data.weapon_attack_state = 0
										
										----删除timer
										----hApi.clearTimer("__Check_LongClick_Diablo__")
										
										----隐藏自动攻击图标
										--self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
									--end
									--标记为自动攻击
									oWorld.data.weapon_attack_state = 2
									
									if self.childUI["labSkillAutoCast"] then
										--显示自动攻击图标
										self.childUI["labSkillAutoCast"].handle._n:setVisible(true)
									end
									
									--立即触发一次
									tank_weapon_attack_loop()
								end
							end
							
							return
						end
						--没有在内部点击
						if (isInside ~= 1) then
							return
						end
						
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						local me = world:GetPlayerMe()
						local goldNow = 0
						if me then
							goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
						end
						--if activeSkillCostMana > mapInfo.gold then
						if activeSkillCostMana > goldNow then
							__popText(hVar.tab_string["ios_not_enough_game_coin"])
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							--__popText(hVar.tab_string["__NEED_MANA__"])
							return
						end
						
						--点击了自身的按钮
						--取消其他按钮的选中状态
						local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
						for i = 1, #tacticCardCtrls, 1 do
							local btni = tacticCardCtrls[i]
							if btni and (btni ~= 0) then
								if (btni ~= self) then --不是自己
									if (btni.data.selected == 1) then
										hApi.safeRemoveT(btni.childUI, "selectbox") --删除选中特效
										btni.data.selected = 0
										
										--针对TD对地面有效的非障碍点地方，靠近能量圈附近，取消能量塔的能量圈
										if (btni.data.skillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then
											local tabS = hVar.tab_skill[btni.data.skillId]
											local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
											local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
											--print(energy_unit_id, energy_build_radius)
											if (energy_unit_id > 0) then
												--显示地图上全部充能塔的建造半径
												local world = hGlobal.WORLD.LastWorldMap
												world:enumunit(function(eu)
													local typeId = eu.data.id --类型id
													if (typeId == energy_unit_id) then
														hApi.safeRemoveT(eu.chaUI, "TD_AtkRange")
													end
												end)
											end
										end
									end
								end
							end
						end
						
						--如果当前选中了单位，那么取消对该单位的选中
						if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
							if (hGlobal.WORLD.LastWorldMap:GetPlayerMe():getfocusunit()) then
								hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", oWorld, nil, 0, 0)
								hGlobal.event:event("Event_TDUnitActived", oWorld, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						end
						
						--pvp模式，隐藏可能选中的头像栏的复活按钮
						if (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
							for i = 1, #(hGlobal.WORLD.LastWorldMap:GetPlayerMe().heros), 1 do
								local oHero = hGlobal.WORLD.LastWorldMap:GetPlayerMe().heros[i]
								if oHero then
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
									end
								end
							end
						end
						
						--再处理自己按钮
						if (self.data.selected == 0) then --之前是未选中状态
							--点了发兵之后，才能使用战术卡
							local bCanUseBattleBegin = true --游戏开始后可用
							--游戏未开始，不能加钱
							local world = hGlobal.WORLD.LastWorldMap
							if world then
								local mapInfo = world.data.tdMapInfo
								if mapInfo then
									--第一波及以后才能加钱
									local waveNow = mapInfo.wave
									if (waveNow < 1) then
										bCanUseBattleBegin = false --未开始游戏
									end
								end
							end
							
							--geyachao: 如果该战术卡是标记英雄死后禁止使用，点击该按钮，会提示不能使用
							local bCanUseUnitAlive = true --绑定的英雄对象的战术技能卡，检测是否可用
							if (self.data.deadUnUse == 1) then
								if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
									local oUnit = self.data.bindHero:getunit()
									if (not oUnit) or (oUnit == 0) then
										bCanUseUnitAlive = false --英雄单位已死亡，不能使用
									end
								end
							end
							
							--geyachao: 如果该战术卡是标记英雄死后禁止使用，检测单位是否眩晕
							local bCanUseUnitStun = true --绑定的英雄对象的战术技能卡，检测是否可用
							if (self.data.deadUnUse == 1) then
								if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
									local oUnit = self.data.bindHero:getunit()
									if (oUnit) and (oUnit ~= 0) then
										local stun_stack = oUnit.attr.stun_stack or 0
										if (stun_stack > 0) then
											bCanUseUnitStun = false --英雄单位眩晕中，不能使用
										end
									end
								end
							end
							
							--geyachao: 如果该战术卡是标记英雄死后禁止使用，检测单位是否混乱
							local bCanUseUnitChaos = true --绑定的英雄对象的战术技能卡，检测是否可用
							if (self.data.deadUnUse == 1) then
								if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
									local oUnit = self.data.bindHero:getunit()
									if (oUnit) and (oUnit ~= 0) then
										local suffer_chaos_stack = oUnit.attr.suffer_chaos_stack or 0
										if (suffer_chaos_stack > 0) then
											bCanUseUnitChaos = false --英雄单位混乱中，不能使用
										end
									end
								end
							end
							
							--geyachao: 如果该战术卡是标记英雄死后禁止使用，检测单位是否沉睡
							local bCanUseUnitSleep = true --绑定的英雄对象的战术技能卡，检测是否可用
							if (self.data.deadUnUse == 1) then
								if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
									local oUnit = self.data.bindHero:getunit()
									if (oUnit) and (oUnit ~= 0) then
										local suffer_sleep_stack = oUnit.attr.suffer_sleep_stack or 0
										if (suffer_sleep_stack > 0) then
											bCanUseUnitSleep = false --英雄单位沉睡中，不能使用
										end
									end
								end
							end
							
							--geyachao: 如果该战术卡是标记英雄死后禁止使用，检测单位是否沉默
							--！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
							--沉默是不是死后禁用的类型，只要绑定了英雄，被沉默后都不能施法
							local bCanUseUnitChenmo = true --绑定的英雄对象的战术技能卡，检测是否可用
							--if (self.data.deadUnUse == 1) then
								if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
									local oUnit = self.data.bindHero:getunit()
									if (oUnit) and (oUnit ~= 0) then
										local suffer_chenmo_stack = oUnit.attr.suffer_chenmo_stack or 0
										if (suffer_chenmo_stack > 0) then
											bCanUseUnitChenmo = false --英雄单位沉默中，不能使用
										end
									end
								end
							--end
							
							if bCanUseBattleBegin and bCanUseUnitAlive and bCanUseUnitStun and bCanUseUnitChaos and bCanUseUnitSleep and bCanUseUnitChenmo then --可以使用
								--pad的尺寸
								local scaleA = 2
								
								if g_phone_mode ~= 0 then
									scaleA = 2
								end
								
								if (activeSkillCastType ~= hVar.CAST_TYPE.IMMEDIATE) then
									--大菠萝不要绿色边框
									if (skillNum > hVar.NORMALATK_IDX) then
										if (activeSkillIsBuildTower == 1) then --造塔类技能
											--创建选中特效
											self.childUI["selectbox"] = hUI.image:new({
												parent = self.handle._n,
												model = "icon/item/towergun_selectbox.png",
												x = 0,
												y = 0,
												z = 100,
												w = 69,
												h = 69,
												scale = scaleA,
											})
										else
											--创建选中特效
											self.childUI["selectbox"] = hUI.image:new({
												parent = self.handle._n,
												model = "MODEL_EFFECT:strengthen2",
												x = 0,
												y = 0,
												z = 100,
												w = 64,
												h = 64,
												scale = scaleA,
											})
											self.childUI["selectbox"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
										end
									end
								end
								
								--TD对地面有效的非障碍点地方，靠近能量圈附近，在点击时显示所有能量圈的范围
								--print(activeSkillCastType)
								if (activeSkillCastType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then
									local tabS = hVar.tab_skill[activeSkillId]
									local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
									local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
									--print(energy_unit_id, energy_build_radius)
									if (energy_unit_id > 0) then
										--显示地图上全部充能塔的建造半径
										local world = hGlobal.WORLD.LastWorldMap
										world:enumunit(function(eu)
											local typeId = eu.data.id --类型id
											if (typeId == energy_unit_id) then
												hApi.safeRemoveT(eu.chaUI, "TD_AtkRange")
												
												local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
												local eu_dx = eu_bx + eu_bw / 2 --中心点偏移x位置
												local eu_dy = eu_by + eu_bh / 2 --中心点偏移y位置
												--如果是塔显示攻击范围
												eu.chaUI["TD_AtkRange"] = hUI.image:new({
													parent = eu.handle._n,
													x = eu_dx,
													y = eu_dy,
													model = "MODEL_EFFECT:SelectCircle",
													animation = "range",
													z = -255,
													w = energy_build_radius * 2 * 1.11, --geyachao: 实际的范围是程序的值的1.11倍
													--color = {128, 255, 128},
													--alpha = 48,
												})
												
												local scale = math.min(0.98, (energy_build_radius - 4) / energy_build_radius)
												local a = CCScaleBy:create(0.75, scale, scale)
												local aR = a:reverse()
												local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
												eu.chaUI["TD_AtkRange"].handle._n:runAction(CCRepeatForever:create(seq))
												
												local program = nil
												local atkRangeMin = 0
												local scale = atkRangeMin / energy_build_radius / 1.11
												--print("scale=", scale)
												
												program = hApi.getShader("atkrange1", 4, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
												local resolution = program:glGetUniformLocation("resolution")
												program:setUniformLocationWithFloats(resolution,66,66)
												
												local rr = program:glGetUniformLocation("rr")
												local gg = program:glGetUniformLocation("gg")
												local bb = program:glGetUniformLocation("bb")
												program:setUniformLocationWithFloats(rr, 0.2)
												program:setUniformLocationWithFloats(gg, 0.67)
												program:setUniformLocationWithFloats(bb, 0.5)
												
												--显示最小攻击范围
												local inner_r = program:glGetUniformLocation("inner_r")
												program:setUniformLocationWithFloats(inner_r, scale)
												
												eu.chaUI["TD_AtkRange"].handle.s:setShaderProgram(program)
											end
										end)
									end
								end
								
								self.data.selected = 1
							elseif (not bCanUseBattleBegin) then --游戏开始后可用，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("开战后才能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_string["BattleCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							elseif (not bCanUseUnitAlive) then --绑定的英雄对象的战术技能卡，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("英雄复活后才能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_stringU[self.data.bindHero.data.id][1] .. hVar.tab_string["RebirthCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							elseif (not bCanUseUnitStun) then --英雄眩晕，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("眩晕或冰冻中，不能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_stringU[self.data.bindHero.data.id][1] .. hVar.tab_string["StunFrozenCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							elseif (not bCanUseUnitChaos) then --英雄混乱，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("混乱中，不能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_stringU[self.data.bindHero.data.id][1] .. hVar.tab_string["ChaosCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							elseif (not bCanUseUnitSleep) then --英雄沉睡，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("睡眠中，不能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_stringU[self.data.bindHero.data.id][1] .. hVar.tab_string["SleepCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							elseif (not bCanUseUnitChenmo) then --英雄沉默，禁用
								--冒字文字提示
								local BubbleDx = -35
								if (g_phone_mode ~= 0) then
									BubbleDx = -50
								end
								--[[
								hUI.floatNumber:new({
									x = x + BubbleDx,
									y = y - 10,
									align = "RC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								--}):addtext("沉默中，不能使用", hVar.FONTC, 32, "RC", 0, 0)
								}):addtext(hVar.tab_stringU[self.data.bindHero.data.id][1] .. hVar.tab_string["ChenmoCanUse"], hVar.FONTC, 32, "RC", 0, 0)
								]]
								
								return
							end
						else --之前是已选中状态，再次点击，取消选中
							hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
							self.data.selected = 0
							
							--针对TD对地面有效的非障碍点地方，靠近能量圈附近，取消能量塔的能量圈
							if (activeSkillCastType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then
								local tabS = hVar.tab_skill[activeSkillId]
								local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
								local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
								--print(energy_unit_id, energy_build_radius)
								if (energy_unit_id > 0) then
									--显示地图上全部充能塔的建造半径
									local world = hGlobal.WORLD.LastWorldMap
									world:enumunit(function(eu)
										local typeId = eu.data.id --类型id
										if (typeId == energy_unit_id) then
											hApi.safeRemoveT(eu.chaUI, "TD_AtkRange")
										end
									end)
								end
							end
						end
						
						--print("activeSkillType=", activeSkillType)
						--如果是直接生效类的，那么释放技能（其他类型的等待点击大地图事件）
						if (activeSkillType == hVar.CAST_TYPE.IMMEDIATE) then --点击直接生效类型
							--hApi.UseLocalTacticCard(self, 0, 0)
							--geyachao: 改为发送指令-使用战术卡
							--print("改为发送指令-使用战术卡1")
							hApi.AddCommand(hVar.Operation.UseTacticCard, self.data.tacticId, self.data.itemId, 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前战术技能的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								hApi.addTimerOnce("cancelSelectTacticCard_" .. world:gametime(), 250, function()
									if (self.data.selected == 1) then
										hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
										self.data.selected = 0
									end
								end)
							end
							--hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
							--self.data.selected = 0
						end
						
						--如果是对自身周围的随机单位生效类，那么检测是否有目标，再释放技能（其他类型的等待点击大地图事件）
						if (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then --对自身周围的随机单位生效类型
							local oUnit = nil --施法者
							
							if (self.data.bindHero ~= 0) then --此战术技能卡绑定的英雄对象
								oUnit = self.data.bindHero:getunit()
							end
							
							if oUnit and (oUnit ~= 0) then
								--AI自己找到一个技能合适的目标
								local validTarget = AI_search_skill_target(oUnit, activeSkillId)
								if validTarget and (validTarget ~= 0) then
									--hApi.UseLocalTacticCard(self, 0, 0)
									--geyachao: 改为发送指令-使用战术卡
									--print("改为发送指令-使用战术卡1")
									hApi.AddCommand(hVar.Operation.UseTacticCard, self.data.tacticId, self.data.itemId, 0, 0, 0, 0)
									
									--geyachao: 客户端提前操作，取消对之前战术技能的选中
									if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
										hApi.addTimerOnce("cancelSelectTacticCard_" .. world:gametime(), 250, function()
											if (self.data.selected == 1) then
												hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
												self.data.selected = 0
											end
										end)
									end
								else
									local strText = "没有目标可释放技能" --language
									--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
									hUI.floatNumber:new({
										x = hVar.SCREEN.w / 2,
										y = hVar.SCREEN.h / 2,
										align = "MC",
										text = "",
										lifetime = 1000,
										fadeout = -550,
										moveY = 32,
									}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									
									--施法失败，取消选中
									hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
									self.data.selected = 0
								end
							else
								--无施法者
								local strText = "没有施法者！" --language
								--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
								hUI.floatNumber:new({
									x = hVar.SCREEN.w / 2,
									y = hVar.SCREEN.h / 2,
									align = "MC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
								
								--施法失败，取消选中
								hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
								self.data.selected = 0
							end
							
							--hApi.safeRemoveT(self.childUI, "selectbox") --删除选中特效
							--self.data.selected = 0
						end
					end,
					
					--滑动事件
					codeOnDrag = function(self, screenX, screenY, isInside)
						--print("滑动事件", screenX, screenY, isInside)
						--if (self.data.index == 4) then
							--local oWorld = hGlobal.WORLD.LastWorldMap
							--if oWorld then
								--local mapInfo = oWorld.data.tdMapInfo
								--if mapInfo then
									----第一波及以后才能加钱
									--local waveNow = mapInfo.wave
									--if (waveNow < 1) then
										--return
									--end
								--end
								
								----滑动事件
								--if (isInside == 1) then --在内部滑动
									--local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
									--if oUnit and (oUnit ~= 0) then --单位活着
										--if (oWorld.data.weapon_attack_state == 0) then --非攻击状态
											----标记为攻击
											--oWorld.data.weapon_attack_state = 1
											----self.childUI["icon"]:setmodel("misc/skill4-hit.png", nil, nil, 90, 90)
											
											----添加timer，检测是否长按
											--hApi.addTimerOnce("__Check_LongClick_Diablo__", 1500, function()
												----标记自动攻击
												--oWorld.data.weapon_attack_state = 2
												
												----删除timer
												--hApi.clearTimer("__Check_LongClick_Diablo__")
												
												----显示自动攻击图标
												--self.childUI["labSkillAutoCast"].handle._n:setVisible(true)
											--end)
										--elseif (oWorld.data.weapon_attack_state == 1) then --攻击状态
											----
										--elseif (oWorld.data.weapon_attack_state == 2) then --自动攻击状态
											----
										--end
									--end
								--else --在外部滑动
									--if (oWorld.data.weapon_attack_state == 0) then --非攻击状态
										----
									--elseif (oWorld.data.weapon_attack_state == 1) then --攻击状态
										----标记非攻击
										--oWorld.data.weapon_attack_state = 0
										
										----删除timer
										--hApi.clearTimer("__Check_LongClick_Diablo__")
										
										----隐藏自动攻击图标
										--self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
									--elseif (oWorld.data.weapon_attack_state == 2) then --自动攻击状态
										----
									--end
								--end
							--end
						--end
						if (oWorld.data.keypadEnabled ~= true) then
							return
						end
						
						--点击了攻击按钮
						if (self.data.index == 4) then
							local oWorld = hGlobal.WORLD.LastWorldMap
							if oWorld then
								local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
								if oUnit and (oUnit ~= 0) then --单位活着
									if (isInside == 1) then --在内部滑动
										--标记为自动攻击
										oWorld.data.weapon_attack_state = 2
										
										if self.childUI["labSkillAutoCast"] then
											--显示自动攻击图标
											self.childUI["labSkillAutoCast"].handle._n:setVisible(true)
										end
									else
										--标记非攻击
										oWorld.data.weapon_attack_state = 0
										print("oWorld.data.weapon_attack_state = 0 H")
										
										if self.childUI["labSkillAutoCast"] then
											--隐藏自动攻击图标
											self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
										end
									end
								end
							end
						end
					end,
					
					--抬起事件
					--点击事件（failcall = 1 时，有可能在控件外部点击）
					code = function(self, screenX, screenY, isInside)
						--print("抬起事件", screenX, screenY, isInside)
						--if (self.data.index == 4) then
							--local oWorld = hGlobal.WORLD.LastWorldMap
							--if oWorld then
								--if (oWorld.data.weapon_attack_state == 0) then --非攻击状态
									----
								--elseif (oWorld.data.weapon_attack_state == 1) then --攻击状态
									----标记非攻击
									--oWorld.data.weapon_attack_state = 0
									
									----删除timer
									--hApi.clearTimer("__Check_LongClick_Diablo__")
									
									----隐藏自动攻击图标
									--self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
								--elseif (oWorld.data.weapon_attack_state == 2) then --自动攻击状态
									----
								--end
							--end
							
							--return
						--end
						
						--screenY = screenY + OFFSET_Y --手机上往上移一点 --geyachao: 现在不需要往上移了
						
						--挪到按下事件
						if (oWorld.data.weapon_attack_state ~= 2) then --非长按
							--标记非攻击
							oWorld.data.weapon_attack_state = 0	--原来是0，临时改一下，2022/8/17，X3
							print("oWorld.data.weapon_attack_state = 0 A")
							
							if self.childUI["labSkillAutoCast"] then
								--隐藏自动攻击图标
								self.childUI["labSkillAutoCast"].handle._n:setVisible(false)
							end
						end
					end,
				})
				
				local btn = parentFrm.childUI["btnTactics_"..__activeSkillNum]
				--table.insert(oWorld.data.tacticCardCtrls, btn) --添加到本局的战术技能卡控件集中
				oWorld.data.tacticCardCtrls[__activeSkillNum] = btn --添加到本局的战术技能卡控件集中
				print("__activeSkillNum=", __activeSkillNum)
				
				print("添加到本局的战术技能卡控件集中",__activeSkillNum,btn)
				
				if (activeSkillIsBuildTower == 1) then --建造塔类战术卡
					--cd时背景灰色的图标
					btn.childUI["icon_front"] = hUI.image:new({
						parent = btn.handle._n,
						model = hVar.tab_item[itemId].icon,
						x = 0,
						--y = -12,
						y = 0,
						z = 101,
						scale = scale1+0,
						--alpha = 128,
						--color = {128,128,128},
					})
				end
				
				--战术技能卡图标
				--cd时背景灰色的图标
				btn.childUI["icon"] = hUI.image:new({
					parent = btn.handle._n,
					model = activeSkillIcon,
					x = 0,
					--y = -12,
					y = 0,
					z = 1,
					scale = scale1+0,
					alpha = 128,
					color = {128,128,128},
				})
				
				--战术技能卡类型
				--[[
					btn.childUI["tacticType"] = hUI.image:new({
					parent = btn.handle._n,
					model = "UI:td_sui_tactic_tskill",
					scale = 0.6,
					x = -1,
					y = 39,
					z = 1,
				})
				--]]
				--战术技能卡cd蒙板
				local _callback = function()
					--btn.data.tacticCastTime = 0
					--btn.data.tacticCD = activeSkillCD
				end
				btn.childUI["cd"] = hUI.timerbar:new({
					parent = btn.handle._n,
					model = activeSkillIcon,
					x = 0,
					--y = -12,
					y = 0,
					z = 1,
					scale = scale1,
					--alpha = 128,
					--color = {128,128,128},
					callback = _callback,
				})
				
				if (__activeSkillNum == 3) then
					--战术技能卡cd正常的img
					btn.childUI["cd_ok"] = hUI.timerbar:new({
						parent = btn.handle._n,
						model = "icon/skill/icon4_full.png",
						x = 0,
						--y = -12,
						y = 0,
						z = 1,
						scale = scale1,
					})
					
					--战术技能卡cd边框
					btn.childUI["cd_bolder"] = hUI.timerbar:new({
						parent = btn.handle._n,
						model = "icon/skill/skill_cd.png",
						x = 0,
						--y = -12,
						y = 0,
						z = 1,
						scale = scale1,
						--alpha = 128,
						--color = {128,128,128},
						callback = _callback,
					})
					btn.childUI["cd_bolder"].handle._n:setVisible(false) --一开始隐藏
				end
				
				--本局从未使用一次战术卡，创建战术卡时加个描边特效动画
				if (oWorld.data.tactic_use_state == 0) then
					if (activeSkillIsBuildTower ~= 1) then --非建造塔类战术卡
						if (__activeSkillNum > hVar.NORMALATK_IDX) then
							--战术技能卡cd边框
							btn.childUI["bolder_amin"] = hUI.image:new({
								parent = btn.handle._n,
								model = "MODEL_EFFECT:TacticUsing",
								x = 0,
								y = 0,
								z = 1,
								scale = scale1,
							})
						end
					end
				end
				
				--btn.childUI["costBg"] = hUI.image:new({
				--	parent = btn.handle._n,
				--	model = "UI:td_sui_tactic_cost_bg",
				--	scale = 0.75,
				--	x = 20,
				--	y = -32,
				--	z = 1,
				--})
				----消耗资源
				--btn.childUI["cost"] = hUI.label:new({
				--	parent = btn.handle._n,
				--	--font = hVar.FONTC,
				--	size = 16,
				--	text = tostring(activeSkillCostMana),
				--	align = "RC",
				--	border = 1,
				--	x = 32,
				--	y = -32,
				--	z = 1,
				--})
				
				--数字显CD控件
				local labCdSize = 27 --大菠萝都是同样字体大小
				if (g_phone_mode == 3) then --iphone6
					labCdSize = 34
				end
				if (g_phone_mode == 4) then --iphoneX
					labCdSize = 34
				end
				--[[
				local labCdSize = 30
				if (g_phone_mode ~= 0) then --手机模式
					labCdSize = 32
				end
				if (g_phone_mode == 4) then --iphoneX
					labCdSize = 44
				end
				
				--数字显CD控件3
				if (__activeSkillNum == 3) then --技能3
					labCdSize = 48
					if (g_phone_mode ~= 0) then --手机模式
						labCdSize = 52
					end
					if (g_phone_mode == 4) then --iphoneX
						labCdSize = 70
					end
				end
				]]
				
				--[[
				--geyachao: 大菠萝不显示cd的文字了
				btn.childUI["labCd"] = hUI.label:new({
					parent = btn.handle._n,
					--font = hVar.FONTC,
					size = labCdSize,
					text = tostring(activeSkillCD),
					align = "MC",
					font = "numWhite",
					border = 1,
					x = 0,
					y = 0,
					z = 2,
				})
				btn.childUI["labCd"].handle._n:setVisible(false)
				]]
				
				--技能的等级
				local skillLvPx = 5
				local skillLvPy = -58
				local skillLvFontSize = 20
				if (g_phone_mode == 3) then --iphone6
					skillLvPx = 5
					skillLvPy = -58
					skillLvFontSize = 20
				end
				if (g_phone_mode == 4) then --iphoneX
					skillLvPx = 5
					skillLvPy = -58
					skillLvFontSize = 20
				end
				if (__activeSkillNum == 3) then --技能3 --不显示了
					skillLvPy = skillLvPy - 10000
				end
				
				--技能等级底板
				btn.childUI["labSkillMana"] = hUI.image:new({
					parent = btn.handle._n,
					model = "icon/skill/icon_mana.png",
					x = 0,
					y = skillLvPy + 1,
					z = 1,
					w = 64 * scale1,
					h = 24 * scale1,
				})
				
				--技能等级值
				btn.childUI["labSkillLv"] = hUI.label:new({
					parent = btn.handle._n,
					--font = hVar.FONTC,
					size = skillLvFontSize,
					align = "MC",
					font = "num",
					border = 0,
					x = skillLvPx,
					y = skillLvPy,
					z = 2,
					text = 1,
				})
				
				--战车技能图标
				if (__activeSkillNum == 3) then
					--技能使用次数
					btn.childUI["labSkillUseCount"] = hUI.label:new({
						parent = btn.handle._n,
						--font = hVar.FONTC,
						size = 39,
						x = 0,
						y = 16,
						z = 2,
						align = "MC",
						font = "numWhite",
						border = 0,
						text = activeSkillUseCount,
					})
					--if activeSkillUseCount == 1 then --改为都不显示次数了
						btn.childUI["labSkillUseCount"].handle._n:setVisible(false)
					--end
				end
				
				--战车手雷图标
				if (__activeSkillNum == 3) then
					--技能使用次数
					local imgMultiply = "icon/skill/l4.png"
					if (activeSkillUseCount > 1) then
						imgMultiply = "icon/skill/l5.png"
					end
					btn.childUI["labSkillUseMultiply"] = hUI.image:new({
						parent = btn.handle._n,
						x = 0,
						y = 16,
						z = 1,
						model = imgMultiply,
						align = "MC",
						w = 92*scale,
						h = 74*scale,
					})
				end
				
				--战车攻击图标
				if (__activeSkillNum == 4) then
					--技能自动释放的边框
					btn.childUI["labSkillAutoCast"] = hUI.image:new({
						parent = btn.handle._n,
						x = 0,
						y = 0,
						z = -1,
						model = "MODEL_EFFECT:AutoCast",
						--w = 180 * scale1,
						--h = 180 * scale1,
						scale = 0.8 * scale1,
					})
					local s1 = 0.83 * scale1--210 * scale1 / 64
					local s2 = 0.77 * scale1--180 * scale1 / 64
					local a1 = CCEaseSineOut:create(CCScaleTo:create(0.5, s1))
					local a2 = CCEaseSineIn:create(CCScaleTo:create(0.5, s2))
					local seqA = tolua.cast(CCSequence:createWithTwoActions(a1,a2), "CCActionInterval")
					btn.childUI["labSkillAutoCast"].handle._n:runAction(CCRepeatForever:create(seqA))
					btn.childUI["labSkillAutoCast"].handle._n:setVisible(false) --一开始不显示
					btn.childUI["labSkillLv"].handle._n:setVisible(false) --一开始不显示
					btn.childUI["labSkillMana"].handle._n:setVisible(false) --一开始不显示
					parentFrm.childUI["btnTacticsMask_4"]:setstate(0)
					parentFrm.childUI["btnTactics_4"]:setstate(0)
				end
				
				--[[
				if (__activeSkillNum == 3) then
					--技能使用次数图片版
					btn.childUI["labSkillUseCount1"] = hUI.image:new({
						parent = btn.handle._n,
						model = "effect/td_paota4_bullet.png",
						x = -28,
						y = 20,
						w = 32,
						h = 32,
						z = 1,
					})
				end
				]]
				
				if (useLimit >= 0) then
					if (g_phone_mode == 0) then --平板模式
						--底图
						btn.childUI["useLimitBg"] = hUI.image:new({
							parent = btn.handle._n,
							model = "UI:td_sui_tactic_num_bg",
							--x = -28,
							x = 28, --geyachao: 战车改到右边
							y = 20+8,
							w = 32,
							h = 32,
							z = 1,
							--aplha = 64,
						})
						btn.childUI["useLimitBg"].handle.s:setOpacity(0)
						--次数
						btn.childUI["useLimit"] = hUI.label:new({
							parent = btn.handle._n,
							font = "numWhite",
							size = 22,
							text = tostring(useLimit),
							align = "MC",
							border = 1,
							--x = -28,
							x = 28-8, --geyachao: 战车改到右边
							y = 20+8-50,
							z = 1,
						})
						--geyachao: 战车1次也不显示了
						if (useLimit == 1) then
							btn.childUI["useLimit"]:setText("")
						end
					else --手机模式
						--底图
						btn.childUI["useLimitBg"] = hUI.image:new({
							parent = btn.handle._n,
							model = "UI:td_sui_tactic_num_bg",
							--x = -34,
							x = 34, --geyachao: 战车改到右边
							y = 28+8,
							w = 32,
							h = 32,
							z = 1,
							--aplha = 64,
						})
						btn.childUI["useLimitBg"].handle.s:setOpacity(0)
						--次数
						btn.childUI["useLimit"] = hUI.label:new({
							parent = btn.handle._n,
							font = "numWhite",
							size = 22,
							text = tostring(useLimit),
							align = "MC",
							border = 1,
							--x = -34,
							x = 34-8, --geyachao: 战车改到右边
							y = 28+8-50,
							z = 1,
						})
						--geyachao: 战车1次也不显示了
						if (useLimit == 1) then
							btn.childUI["useLimit"]:setText("")
						end
					end
				end
				
				--禁用此战术卡的控件
				local scaleBan = 1.0 --大菠萝都是1.0
				--pad的尺寸
				--[[
				local scaleBan = 0.8
				if (__activeSkillNum == 3) then --技能3
					scaleBan = 1.2
				end
				
				--禁用此战术卡的控件
				--iphone的尺寸
				if (g_phone_mode ~= 0) then
					scaleBan = 0.95
					if (__activeSkillNum == 3) then --技能3
						scaleBan = 1.5
					end
				end
				
				--禁用此战术卡的控件
				--iphoneX的尺寸
				if (g_phone_mode == 4) then
					scaleBan = 1.1
					if (__activeSkillNum == 3) then --技能3
						scaleBan = 1.8
					end
				end
				]]

				local banx = 4
				if (__activeSkillNum == hVar.TANKSKILL_IDX) then
					banx = 18
				end
				
				btn.childUI["ban"] = hUI.image:new({
					parent = btn.handle._n,
					model = "misc/close.png",
					x = 0,
					--y = -12,
					y = banx,
					z = 3,
					scale = scaleBan,
				})
				btn.childUI["ban"].handle.s:setVisible(false) --一开始隐藏
				
				if (__activeSkillNum == 4) then
					btn.handle.s:setOpacity(0)
					--parentFrm.childUI["btnTacticsMask_" .. "4"].handle._n:setVisible(false)
					--btn.childUI["icon"].handle._n:setVisible(false)
					btn.childUI["icon"].handle.s:setOpacity(255)
					btn.childUI["icon"].handle.s:setColor(ccc3(255, 255, 255))
					btn.childUI["cd"].handle._n:setVisible(false)
				end

				if (__activeSkillNum >= 5) then
					btn.childUI["labSkillLv"].handle._n:setVisible(false)
					btn.childUI["labSkillMana"].handle._n:setVisible(false)
					--if btn.childUI["useLimitBg"] then
					--	btn.childUI["useLimitBg"].handle._n:setVisible(false)
					--end
					--if btn.childUI["useLimit"] then
					--	btn.childUI["useLimit"].handle._n:setVisible(false)
					--end
				end
				
				--找出此战术卡绑定的英雄对象
				if typeId and (typeId ~= 0) then
					for i = 1, #hGlobal.WORLD.LastWorldMap:GetPlayerMe().heros, 1 do
						local oHero = hGlobal.WORLD.LastWorldMap:GetPlayerMe().heros[i]
						if oHero then
							if (oHero.data.id == typeId) then
								--local oUnit = oHero:getunit()
								activeSkillBindHero = oHero --此战术技能卡绑定的英雄对象
								break
							end
						end
					end
				end
				
				--geyachao: pvp模式，战术技能显示等级
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					local mapInfo = world.data.tdMapInfo
					if mapInfo then
						if tacticId and (tacticId ~= 0) then
							if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
								local skillLv = 1 --主动战技能卡等级
								
								--如果是铜雀台地图（world.data.tdMapInfo.pveHeroMode == 1），那么显示pve的等级
								local tTactics = world:gettactics(world:GetPlayerMe():getpos()) --本局所有的战术技能卡
								for i = 1, #tTactics, 1 do
									--print(i, "tTactics[i]=", tTactics[i])
									if tTactics[i]~=0 then
										local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
										--print( id, lv, typeId, activeSkillBindHero.data.id)
										if (typeId == activeSkillBindHero.data.id) then --找到了
											skillLv = lv --技能等级
											--print("技能等级", lv)
											break
										end
									end
								end
								
								--英雄的pvp等级
								if (g_phone_mode == 0) then --平板模式
									--pvp等级背景图
									btn.childUI["pvp_bolder"] = hUI.image:new({
										parent = btn.handle._n,
										model = "ui/pvp/pvpselect.png",
										x = 27,
										y = 28,
										z = 4,
										w = 24,
										h = 24,
									})
									
									--pvp等级文字
									btn.childUI["pvp_label"] = hUI.label:new({
										parent = btn.handle._n,
										font = "numWhite",
										x = 27,
										y = 28 - 1, --数字字体有1像素的偏差
										z = 5,
										width = 200,
										align = "MC",
										size = 18,
										text = skillLv,
									})
								else --手机模式
									--pvp等级背景图
									btn.childUI["pvp_bolder"] = hUI.image:new({
										parent = btn.handle._n,
										model = "ui/pvp/pvpselect.png",
										x = 35,
										y = 36,
										z = 4,
										w = 30,
										h = 30,
									})
									
									--pvp等级文字
									btn.childUI["pvp_label"] = hUI.label:new({
										parent = btn.handle._n,
										font = "numWhite",
										x = 35,
										y = 36 - 1, --数字字体有1像素的偏差
										z = 5,
										width = 200,
										align = "MC",
										size = 22,
										text = skillLv,
									})
								end
								
								local scale = 1.0
								if (g_phone_mode == 0) then --平板模式
									scale = 0.7
									if (skillLv >= 10) then
										scale = 0.48
									end
								else --手机模式
									scale = 0.88
									if (skillLv >= 10) then
										scale = 0.58
									end
								end
								--print("设置主动战术卡的pvp等级", skillLv)
								btn.childUI["pvp_label"]:setText(skillLv)
								btn.childUI["pvp_label"].handle._n:setScale(scale)
							end
						end
					end
				end
				
				--geyachao: 主动类战术技能减cd
				if activeSkillBindHero and (activeSkillBindHero ~= 0) then
					if (tacticId) and (tacticId ~= 0) then --战术技能卡
						activeSkillCD = activeSkillBindHero.data.activeSkillCD
					end
				end
				
				--是变身期间的战车，不需要显示手雷图标了
				--print("activeSkillBindHero=", activeSkillBindHero)
				if (type(activeSkillBindHero) == "table") then
					local oUnit = activeSkillBindHero:getunit()
					if oUnit then
						--print("是变身期间的战车，不需要显示手雷图标了", oUnit.data.is_fenshen)
						if (oUnit.data.is_fenshen == 1) then
							if btn.childUI["labSkillUseMultiply"] then
								btn.childUI["labSkillUseMultiply"].handle._n:setVisible(false)
							end
						end
					end
				end
				
				--print("activeSkillCD=", activeSkillCD)
				
				--存储资源消耗
				btn.data.index = __activeSkillNum --位置索引值
				btn.data.tacticId = tacticId --战术技能卡id
				btn.data.itemId = itemId --道具id
				btn.data.typeId = typeId
				btn.data.skillId = activeSkillId --主动技能id
				btn.data.skillLv = activeSkillLv --主动技能等级
				btn.data.skillType = activeSkillType --技能释放类型
				btn.data.skillRange = activeSkillRange --技能范围
				btn.data.cost = activeSkillCostMana
				btn.data.useLimit = useLimit
				btn.data.laststate = nil
				btn.data.tacticCastTime = nil
				btn.data.tacticCD = activeSkillCD --CD（单位:秒）
				btn.data.selected = 0 --一开始默认是没选中的
				btn.data.labCD = 0
				btn.data.bindHero = activeSkillBindHero --此战术技能卡绑定的英雄对象
				btn.data.deadUnUse = activeSkillDeadUnUse --此战术技能卡在英雄死后是否禁用
				btn.data.useCountMax = activeSkillUseCount --可以使用的最大次数
				btn.data.useCount = activeSkillUseCount --可以使用的当前（如果有多次，在次数为0时转cd）
				btn.data.activeSkillIsBuildTower = activeSkillIsBuildTower --是否建造塔（战术卡界面放左边）
				
				--参数: paramActiveSkillNum:指定要添加的位置
				if paramActiveSkillNum then
					local old___activeSkillNum = __activeSkillNum
					__activeSkillNum = paramActiveSkillNum --还原
					paramActiveSkillNum = old___activeSkillNum
					
					--重绘时id增加
					if (__activeSkillNum < paramActiveSkillNum) then
						__activeSkillNum = paramActiveSkillNum
					end
				else
					--
				end
			end
		--建造
		elseif (typeT == hVar.TACTICS_TYPE.TOWER) and remouldUnlock then
			local baseTowerId = remouldUnlock.baseTowerId or 0
			local remouldIdTab = remouldUnlock[lv] or {}
			local remouldId = remouldIdTab[1] or 0
			local remouldCost = 0
			if baseTowerId > 0 and remouldId > 0 then
				
				__activeSkillNum = __activeSkillNum + 1
				
				--计算需要消耗的金币
				local oTB = __SearchFirstTowerBase(baseTowerId)
				if oTB then
					local td_upgrade = oTB.td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
					if td_upgrade and type(td_upgrade) == "table" then
						local remould = td_upgrade.remould
						if remould then
							local buildInfo = remould[remouldId]
							--如果没有解锁则不创建按钮
							if buildInfo.isUnlock then
								remouldCost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0)
							end
						end
					end
				end
				
				local activeSkillIcon = hVar.tab_skill[activeSkillId].icon
				if tacticId and (tacticId ~= 0) then
					activeSkillIcon = hVar.tab_tactics[tacticId].icon
				end
				if itemId and (itemId ~= 0) then
					activeSkillIcon = hVar.tab_item[itemId].icon
				end
				parentFrm.childUI["btnTactics_"..tostring(__activeSkillNum)] = hUI.button:new({
					parent = parentFrm,
					--x = 60 + 88 * (__activeSkillNum - 1),
					--y = 80,
					--x = hVar.SCREEN.w - 200,
					--y = -200 - 88 * (__activeSkillNum - 1),
					x = hVar.SCREEN.w - 60,
					y = hVar.SCREEN.h - 120 - 75 * (__activeSkillNum - 1),
					scale = 0.84,
					--w = 80,
					--h = 100,
					--model = "UI:tactic_card_3",
					model = "UI_frm:slot",
					animation = "light",
					label = "", --文字
					scaleT = 0.98, --按下的缩放值
					failcall = 1, --出按钮区域抬起也会响应事件
					
					--按下事件
					codeOnTouch = function(self, screenX, screenY, isInside)
						
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						local me = world:GetPlayerMe()
						local goldNow = 0
						if me then
							goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
						end
						
						--if remouldCost > mapInfo.gold then
						if remouldCost > goldNow then
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							return
						end
						
						--标记当前选中的技能
						selected_skill_id = activeSkillId
						self.data.tajiList, self.data.effList = __SearchTowerBase(baseTowerId) --找出所有的塔基
					end,
					
					--滑动事件
					codeOnDrag = function(self, screenX, screenY, isInside)
						
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						local me = world:GetPlayerMe()
						local goldNow = 0
						if me then
							goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
						end
						
						--if remouldCost > mapInfo.gold then
						if remouldCost > goldNow then
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							return
						end
						
						if (isInside == 1) then --在控件内部
							--删除焦点控件
							if focus_ctrl then
								focus_ctrl:del()
								focus_ctrl = nil
							end
							
							--删除可以放置的按钮
							if focus_down_ctrl then
								focus_down_ctrl:del()
								focus_down_ctrl = nil
							end
							
							--标记未选中塔基
							hoveredTower = nil
						else --在控件外部
							--创建焦点控件
							if (not focus_ctrl) then
								focus_ctrl = hUI.button:new(
								{
									parent = nil,
									model = "BTN:PANEL_CLOSE", --"Action:updown" --"BTN:PANEL_CLOSE"
									x = screenX,
									y = screenY,
									scale = 0.5, --缩放比例
								})
							end
							
							--设置焦点控件的位置
							focus_ctrl:setXY(screenX, screenY)
							--focus_down_ctrl:setXY(screenX, screenY)
							
							--检测吸附效果
							local FindXiFuTower = nil --吸附的塔基
							local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
							
							if not self.data.tajiList then
								self.data.tajiList = {}
							end
							
							for i = 1, #self.data.tajiList, 1 do
								local eu = self.data.tajiList[i] --塔基
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --塔基的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --塔基的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --塔基的中心点y位置
								local CHECK_EDGE = 40
								local eu_left = eu_center_x - CHECK_EDGE --最左边
								local eu_right = eu_center_x + CHECK_EDGE --最右边
								local eu_down = eu_center_y - CHECK_EDGE --最下边
								local eu_up = eu_center_y + CHECK_EDGE --最上边
								
								if (worldX >= eu_left) and (worldX <= eu_right) and (worldY >= eu_down) and (worldY <= eu_up) then
									--print("找到" .. eu.data.name .. ", " .. eu.__ID)
									local sx, sy = hApi.world2view(eu_center_x, eu_center_y) --屏幕坐标
									
									--创建可放置的控件（角色）
									if (not focus_down_ctrl) then
										--[[
										focus_down_ctrl = hUI.button:new(
										{
											parent = nil,
											model = hVar.tab_unit[remouldId].model, --"Action:updown" --"BTN:PANEL_CLOSE"
											x = screenX,
											y = screenY,
											scale = 0.8, --缩放比例
										})
										]]
										local unitData = eu.data
										focus_down_ctrl = world:addunit(remouldId, unitData.owner, nil, nil, unitData.facing, unitData.worldX, unitData.worldY, nil, nil)
										focus_down_ctrl.attr.attack[4] = 0 --没有攻击力
										focus_down_ctrl.attr.attack[5] = 0 --没有攻击力
										focus_down_ctrl.attr.skill = {i = 0, num = 0, index = {},} --没有AI
									end
									
									--设置可放置控件的位置
									--focus_down_ctrl:setXY(sx, sy)
									FindXiFuTower = eu --可吸附
									break
								end
							end
							
							--可吸附
							if FindXiFuTower then
								focus_ctrl.handle._n:setVisible(false)
								--focus_down_ctrl.handle._n:setVisible(true)
								
								--选中塔基
								hoveredTower = FindXiFuTower
								
								--显示塔的攻击范围
								__ShowTDAttackRange(hoveredTower, focus_down_ctrl:GetAtkRange(), focus_down_ctrl:GetAtkRangeMin())
							else
								focus_ctrl.handle._n:setVisible(true)
								if focus_down_ctrl then
									focus_down_ctrl:del()
									focus_down_ctrl = nil
								end
								
								--标记未选中塔基
								hoveredTower = nil
								
								--隐藏塔的攻击范围
								__ShowTDAttackRange(nil)
							end
						end
					end,
					
					--点击事件（有可能在控件外部点击）
					code = function(self, screenX, screenY, isInside)
						
						local world = hGlobal.WORLD.LastWorldMap
						if not world then
							return
						end
						local mapInfo = world.data.tdMapInfo
						if not mapInfo then
							return
						end
						
						local me = world:GetPlayerMe()
						local goldNow = 0
						if me then
							goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
						end
						
						--if remouldCost > mapInfo.gold then
						if remouldCost > goldNow then
							__popText(hVar.tab_string["ios_not_enough_game_coin"])
							return
						end
						
						--释放次数不符合退出
						if self.data.useLimit and self.data.useLimit == 0 then
							--__popText(hVar.tab_string["__NEED_MANA__"])
							return
						end
						
						--删除特效
						for k, v in ipairs(self.data.effList) do
							v:del()
						end
						
						if (isInside == 1) then --在控件内部点击
							--取消技能的释放
							selected_skill_id = 0
						else
							--删除焦点控件
							if focus_ctrl then
								focus_ctrl:del()
								focus_ctrl = nil
							end
							
							--删除可放置的控件
							if focus_down_ctrl then
								focus_down_ctrl:del()
								focus_down_ctrl = nil
							end
							
							--添加塔
							if hoveredTower then
								--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
								--local gridX, gridY = world:xy2grid(worldX, worldY)
								local unitData = hoveredTower.data
								local world = hGlobal.WORLD.LastWorldMap
								local nu = world:addunit(remouldId, unitData.owner, nil, nil, unitData.facing, unitData.worldX, unitData.worldY, nil, nil)
								
								if nu then
									--zhenkira 角色出生事件
									hGlobal.event:call("Event_UnitBorn", nu)
									
									--hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nu, "worldmap")
									
									--删除原塔基角色
									hoveredTower:del()
									hoveredTower = nil
									
									--刚造塔完毕，当前选中空
									--geyachao: 操作优化，点击完地面，取消对之前选中英雄的选中
									--hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
									--hGlobal.event:event("LocalEvent_HitOnTarget", world, nil, unitData.worldX, unitData.worldY)
									--hGlobal.event:event("Event_TDUnitActived", world, 1, nil)
								end
								
								--刷新使用次数
								if self.data.useLimit > 0 then
									self.data.useLimit = self.data.useLimit - 1
								end
								--刷新使用次数界面
								if self.childUI["useLimit"] then
									self.childUI["useLimit"]:setText(self.data.useLimit)
									--geyachao: 战车1次也不显示了
									if (self.data.useLimit == 1) then
										self.childUI["useLimit"]:setText("")
									end
									
									if (self.data.useLimit < 10) then
										self.childUI["useLimit"].handle._n:setScale(1.0)
									else
										self.childUI["useLimit"].handle._n:setScale(0.8)
									end
								end
								
								--刷新消耗
								--mapInfo.gold = mapInfo.gold - remouldCost
								--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -remouldCost)
								--hGlobal.event:event("Event_TacticCastCostRefresh")
								
								if me then
									--刷新消耗
									me:addresource(hVar.RESOURCE_TYPE.GOLD, -remouldCost)
									hGlobal.event:event("Event_TacticCastCostRefresh")
								end
							end
						end
					end,
				})
				
				local btn = parentFrm.childUI["btnTactics_"..__activeSkillNum]
				
				--战术技能卡图标
				btn.childUI["icon"] = hUI.image:new({
					parent = btn.handle._n,
					model = activeSkillIcon,
					x = 0,
					y = 0,
					z = 1,
					scale = 1.2,
				})
				--战术技能卡类型
				--[[
				btn.childUI["tacticType"] = hUI.image:new({
					parent = btn.handle._n,
					model = "UI:td_sui_tactic_tTower",
					scale = 0.6,
					x = -1,
					y = 39,
					z = 1,
				})
				--]]
				--btn.childUI["costBg"] = hUI.image:new({
				--	parent = btn.handle._n,
				--	model = "UI:td_sui_tactic_cost_bg",
				--	scale = 0.75,
				--	x = 20,
				--	y = -32,
				--	z = 1,
				--})
				----消耗资源
				--btn.childUI["cost"] = hUI.label:new({
				--	parent = btn.handle._n,
				--	--font = hVar.FONTC,
				--	size = 16,
				--	text = tostring(remouldCost),
				--	align = "RC",
				--	border = 1,
				--	x = 32,
				--	y = -32,
				--	z = 1,
				--})
				if (useLimit >= 0) then
					if (g_phone_mode == 0) then --平板模式
						--底图
						btn.childUI["useLimitBg"] = hUI.image:new({
							parent = btn.handle._n,
							model = "UI:td_sui_tactic_num_bg",
							x = -28,
							y = 20,
							w = 30,
							h = 30,
							z = 1,
						})
						--次数
						btn.childUI["useLimit"] = hUI.label:new({
							parent = btn.handle._n,
							font = "numWhite",
							size = 20,
							text = tostring(useLimit),
							align = "MC",
							border = 1,
							x = -28,
							y = 20,
							z = 1,
						})
					else --手机模式
						--底图
						btn.childUI["useLimitBg"] = hUI.image:new({
							parent = btn.handle._n,
							model = "UI:td_sui_tactic_num_bg",
							x = -34,
							y = 28,
							w = 36,
							h = 36,
							z = 1,
						})
						--次数
						btn.childUI["useLimit"] = hUI.label:new({
							parent = btn.handle._n,
							font = "numWhite",
							size = 23,
							text = tostring(useLimit),
							align = "MC",
							border = 1,
							x = -34,
							y = 28,
							z = 1,
						})
					end
				end
				--存储资源消耗
				btn.data.cost = remouldCost
				btn.data.useLimit = useLimit
				btn.data.laststate = nil
			end
		end
	end
	
	--更新单个主动战术(道具)技能卡的主动技能界面
	__UpdateSingleActiveTacticCtrl = function(parentFrm, tacticId, itemId, lv, num, typeId)
		print("更新单个主动战术(道具)技能卡的主动技能界面 __UpdateSingleActiveTacticCtrl", tacticId, itemId, lv, typeId)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local typeT = nil --类型
		local activeSkill  = nil --主动技能表
		local remouldUnlock  = nil --解锁技能表
		if tacticId and (tacticId ~= 0) then
			local tabT = hVar.tab_tactics[tacticId]
			id = tacticId
			typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
			activeSkill = tabT.activeSkill
			remouldUnlock = tabT.remouldUnlock
		elseif itemId and (itemId ~= 0) then
			local tabI = hVar.tab_item[itemId]
			id = itemId
			typeT = hVar.TACTICS_TYPE.OTHER
			activeSkill = tabI.activeSkill
			remouldUnlock = nil
		end
		
		--技能释放
		if (typeT == hVar.TACTICS_TYPE.OTHER) and activeSkill then
			local activeSkillId = activeSkill.id
			local activeSkillLv = lv
			local activeSkillType = activeSkill.type or hVar.CAST_TYPE.IMMEDIATE
			local activeSkillRange = activeSkill.effectRange[lv] or 0
			local activeSkillCD = activeSkill.cd[lv] or 0 --原始CD（单位:秒）
			local activeSkillCostMana = activeSkill.costMana[lv] or 0
			local activeSkillBindHero = 0 --此战术技能卡绑定的英雄对象
			local activeSkillDeadUnUse = activeSkill.deadUnUse or 0 --此战术技能卡在英雄死后是否禁用
			
			if activeSkillId and (activeSkillId > 0) and (hVar.tab_skill[activeSkillId]) then
				local __activeSkillNum = __activeSkillNum --只读
				for i = 1, __activeSkillNum, 1 do
					if (i > hVar.TANKSKILL_EMPTY) then
						local btn = parentFrm.childUI["btnTactics_"..i]
						--因为没有 1 2技能按钮 导致一旦更新技能道具就会报错 故添加判断
						print("i=", i, "btn=", btn)
						if btn then
							if (tacticId and (tacticId ~= 0) and (tacticId == btn.data.tacticId)) or
								(itemId and (itemId ~= 0) and (itemId == btn.data.itemId)) then --找到了
								local useLimit = num or -1
								if (useLimit > 0) then
									btn.data.useLimit = btn.data.useLimit + useLimit
									
									--刷新使用次数界面
									if btn.childUI["useLimit"] then
										btn.childUI["useLimit"]:setText(btn.data.useLimit)
										--geyachao: 战车1次也不显示了
										if (btn.data.useLimit == 1) then
											btn.childUI["useLimit"]:setText("")
										end
										if (btn.data.useLimit < 10) then
											btn.childUI["useLimit"].handle._n:setScale(1.0)
										else
											btn.childUI["useLimit"].handle._n:setScale(0.8)
										end
									end
									
									if (btn.data.laststate == 1) then
										--大菠萝数量为0时灰掉
										if btn.childUI["icon"] then
											hApi.AddShader(btn.childUI["icon"].handle.s,"normal")
										end
										if btn.childUI["cd"] then
											btn.childUI["cd"]:setPercentage(100)
										end
										if btn.data.temp_scale then
											btn.handle._n:setScale(btn.data.temp_scale * 0.83)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--删除单个主动战术(道具)技能卡的主动技能界面
	__RemoveSingleActiveItemCtrl_logic = function(parentFrm, tacticId, itemId, activeIndex)
		--print("__RemoveSingleActiveItemCtrl", tacticId, itemId, "activeIndex=", activeIndex)
		
		local datas = {}
		
		--依次从末尾删除后面的主动技能卡
		local oWorld = hGlobal.WORLD.LastWorldMap
		local old__activeSkillNum = __activeSkillNum
		for i = old__activeSkillNum, activeIndex, -1 do
			local data = {}
			
			--删除前缓存数据
			local btni = parentFrm.childUI["btnTactics_" .. i]
			if btni and (btni ~= 0) then
				data.index = btni.data.index - 1 --位置索引值
				data.tacticId = btni.data.tacticId --战术技能卡id
				data.itemId = btni.data.itemId --道具id
				data.typeId = btni.data.typeId
				data.skillId = btni.data.skillId --主动技能id
				data.skillLv = btni.data.skillLv --主动技能等级
				data.skillType = btni.data.skillType --技能释放类型
				data.skillRange = btni.data.skillRange --技能范围
				data.cost = btni.data.cost
				data.useLimit = btni.data.useLimit
				data.laststate = btni.data.laststate
				data.tacticCastTime = btni.data.tacticCastTime
				data.tacticCD = btni.data.tacticCD --CD（单位:秒）
				data.selected = btni.data.selected --一开始默认是没选中的
				data.labCD = btni.data.labCD
				data.bindHero = btni.data.bindHero --此战术技能卡绑定的英雄对象
				data.deadUnUse = btni.data.deadUnUse --此战术技能卡在英雄死后是否禁用
				data.useCountMax = btni.data.useCountMax --可以使用的最大次数
				data.useCount = btni.data.useCount --可以使用的当前（如果有多次，在次数为0时转cd）
				data.activeSkillIsBuildTower = btni.data.activeSkillIsBuildTower --是否建造塔（战术卡界面放左边）
			end
			
			--存储数据
			datas[i - 1] = data
			
			--清除控件
			hApi.safeRemoveT(parentFrm.childUI, "btnTactics_" .. i)
			hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_" .. i)
			
			--从本局的战术技能卡控件集中移除
			table.remove(oWorld.data.tacticCardCtrls, i)
			
			--数量减1
			__activeSkillNum = __activeSkillNum - 1
		end
		
		--依次创建后面的战术(道具)卡
		for i = activeIndex, old__activeSkillNum - 1, 1 do
			--依次绘制
			local data = datas[i]
			__CreateSingleActiveTacticCtrl(parentFrm, data.tacticId, data.itemId, data.skillLv, data.useLimit, data.typeId)
			
			--拷贝数据
			local btni = parentFrm.childUI["btnTactics_" .. i]
			if btni and (btni ~= 0) then
				btni.data.index = data.index --位置索引值
				btni.data.tacticId = data.tacticId --战术技能卡id
				btni.data.itemId = data.itemId --道具id
				btni.data.typeId = data.typeId
				btni.data.skillId = data.skillId --主动技能id
				btni.data.skillLv = data.skillLv --主动技能等级
				btni.data.skillType = data.skillType --技能释放类型
				btni.data.skillRange = data.skillRange --技能范围
				btni.data.cost = data.cost
				btni.data.useLimit = data.useLimit
				btni.data.laststate = data.laststate
				btni.data.tacticCastTime = data.tacticCastTime
				btni.data.tacticCD = data.tacticCD --CD（单位:秒）
				btni.data.selected = data.selected --一开始默认是没选中的
				btni.data.labCD = data.labCD
				btni.data.bindHero = data.bindHero --此战术技能卡绑定的英雄对象
				btni.data.deadUnUse = data.deadUnUse --此战术技能卡在英雄死后是否禁用
				btni.data.useCountMax = data.useCountMax --可以使用的最大次数
				btni.data.useCount = data.useCount --可以使用的当前（如果有多次，在次数为0时转cd）
				btni.data.activeSkillIsBuildTower = data.activeSkillIsBuildTower --是否建造塔（战术卡界面放左边）
				
				--标记为1，是为了强制刷新按钮状态
				--geyachao: 按钮有时灰调？是这里调用的原因？
				--btni.data.laststate = 1
				--btni.data.laststate = 1
			end
		end
		
		--立刻刷新战术技能卡cd
		--__refreshTacticCDLab()
		
		--立即刷新战术技能卡状态
		__refreshTacticState()
		
		--更新控件
		for i = activeIndex, old__activeSkillNum - 1, 1 do
			--按钮i
			local btni = parentFrm.childUI["btnTactics_" .. i]
			if btni and (btni ~= 0) then
				--更新使用次数
				if btni.childUI["useLimit"] then
					btni.childUI["useLimit"]:setText(btni.data.useLimit)
					--geyachao: 战车1次也不显示了
					if (btni.data.useLimit == 1) then
						btni.childUI["useLimit"]:setText("")
					end
					if (btni.data.useLimit < 10) then
						btni.childUI["useLimit"].handle._n:setScale(1.0)
					else
						btni.childUI["useLimit"].handle._n:setScale(0.8)
					end
				end
				
				--更新数字显示cd文字
				if btni.childUI["labCd"] then
					btni.childUI["labCd"]:setText(btni.data.labCD)
				end
				
				--更新cd进度
				if btni.childUI["cd"] then
					local per = 0
					if (btni.data.tacticCD > 0) then
						per = 100 - (btni.data.labCD / btni.data.tacticCD) * 100
					end
					btni.childUI["cd"]:setPercentage(per)
				end
			end
		end
		
		--[[
		--重置后面控件的位置
		for i = __activeSkillNum, activeIndex + 1, -1 do
			local px_bg = parentFrm.childUI["btnTacticsMask_" .. (i - 1)].data.x
			local py_bg = parentFrm.childUI["btnTacticsMask_" .. (i - 1)].data.y
			local pox_bg = parentFrm.childUI["btnTacticsMask_" .. (i - 1)].data.ox
			local poy_bg = parentFrm.childUI["btnTacticsMask_" .. (i - 1)].data.oy
			parentFrm.childUI["btnTacticsMask_" .. i].data.x = px_bg
			parentFrm.childUI["btnTacticsMask_" .. i].data.y = py_bg
			parentFrm.childUI["btnTacticsMask_" .. i].data.ox = 0
			parentFrm.childUI["btnTacticsMask_" .. i].data.oy = 0
			parentFrm.childUI["btnTacticsMask_" .. i].data.anchorX = nil
			parentFrm.childUI["btnTacticsMask_" .. i].data.anchorY = nil
			parentFrm.childUI["btnTacticsMask_" .. i]:setXY(px_bg, py_bg)--, 0.1 + i * 0.05)
			--print(i - 1, px_bg, py_bg)
			
			local px = parentFrm.childUI["btnTactics_" .. (i - 1)].data.x
			local py = parentFrm.childUI["btnTactics_" .. (i - 1)].data.y
			local pox = parentFrm.childUI["btnTactics_" .. (i - 1)].data.ox
			local poy = parentFrm.childUI["btnTactics_" .. (i - 1)].data.oy
			parentFrm.childUI["btnTactics_" .. i].data.x = px
			parentFrm.childUI["btnTactics_" .. i].data.y = py
			parentFrm.childUI["btnTactics_" .. i].data.ox = 0
			parentFrm.childUI["btnTactics_" .. i].data.oy = 0
			parentFrm.childUI["btnTactics_" .. i].data.anchorX = nil
			parentFrm.childUI["btnTactics_" .. i].data.anchorY = nil
			--print(px, py, pox, poy)
			parentFrm.childUI["btnTactics_" .. i]:setXY(px, py)--, 0.1 + i * 0.05)
			
			--print(i, parentFrm.childUI["btnTactics_" .. i].data.anchorX, parentFrm.childUI["btnTactics_" .. i].data.anchorY)
		end
		
		--删除控件
		hApi.safeRemoveT(parentFrm.childUI, "btnTactics_" .. activeIndex)
		hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_" .. activeIndex)
		
		--从本局的战术技能卡控件集中移除
		local oWorld = hGlobal.WORLD.LastWorldMap
		table.remove(oWorld.data.tacticCardCtrls, activeIndex)
		
		--重新标记后面的控件存储的索引值
		for i = activeIndex + 1, __activeSkillNum, 1 do
			local btn = parentFrm.childUI["btnTactics_" .. i]
			btn.data.index = i - 1 --位置索引值
		end
		
		--重新标记后面的控件id
		for i = activeIndex + 1, __activeSkillNum, 1 do
			parentFrm.childUI["btnTactics_" .. (i - 1)] = parentFrm.childUI["btnTactics_" .. i]
			parentFrm.childUI["btnTacticsMask_" .. (i - 1)] = parentFrm.childUI["btnTacticsMask_" .. i]
		end
		
		--最后一个控件为空
		parentFrm.childUI["btnTactics_" .. __activeSkillNum] = nil
		parentFrm.childUI["btnTacticsMask_" .. __activeSkillNum] = nil
		
		--数量减1
		__activeSkillNum = __activeSkillNum - 1
		]]
		
		--[[
		--重置后面控件的位置
		for i = activeIndex, __activeSkillNum - 1, 1 do
			local btni = parentFrm.childUI["btnTactics_" .. i]
			local btni_next = parentFrm.childUI["btnTactics_" .. (i + 1)]
			
			--存储资源消耗
			--btni.data.index = btni_next.data.index --位置索引值
			btni.data.tacticId = btni_next.data.tacticId --战术技能卡id
			btni.data.itemId = btni_next.data.itemId --道具id
			btni.data.skillId = btni_next.data.skillId --主动技能id
			btni.data.skillLv = btni_next.data.skillLv --主动技能等级
			btni.data.skillType = btni_next.data.skillType --技能释放类型
			btni.data.skillRange = btni_next.data.skillRange --技能范围
			btni.data.cost = btni_next.data.cost
			btni.data.useLimit = btni_next.data.useLimit
			btni.data.laststate = btni_next.data.laststate
			btni.data.tacticCastTime = btni_next.data.tacticCastTime
			btni.data.tacticCD = btni_next.data.tacticCD --CD（单位:秒）
			btni.data.selected = btni_next.data.selected --一开始默认是没选中的
			btni.data.labCD = btni_next.data.labCD
			btni.data.bindHero = btni_next.data.bindHero --此战术技能卡绑定的英雄对象
			btni.data.deadUnUse = btni_next.data.deadUnUse --此战术技能卡在英雄死后是否禁用
			
			--更新界面
			--战术技能卡按钮
			local activeSkillIcon = hVar.tab_skill[btni.data.skillId].icon
			if btni.data.tacticId and (btni.data.tacticId ~= 0) then
				activeSkillIcon = hVar.tab_tactics[btni.data.tacticId].icon
			end
			btni.childUI["icon"]:setmodel(activeSkillIcon)
			hApi.AddShader(btni.childUI["icon"].handle.s,"normal")
			
			--更新使用次数
			if (btni.data.useLimit >= 0) then
				btni.childUI["useLimit"]:setText(btni.data.useLimit)
				if (btni.data.useLimit < 10) then
					btni.childUI["useLimit"].handle._n:setScale(1.0)
				else
					btni.childUI["useLimit"].handle._n:setScale(0.8)
				end
			end
			
			--更新数字cd
			
			print(i, btni.data.skillId, activeSkillIcon, btni.data.useLimit)
		end
		
		--删除最后一个控件
		hApi.safeRemoveT(parentFrm.childUI, "btnTactics_" .. __activeSkillNum)
		hApi.safeRemoveT(parentFrm.childUI, "btnTacticsMask_" .. __activeSkillNum)
		
		--从本局的战术技能卡控件集中移除
		local oWorld = hGlobal.WORLD.LastWorldMap
		table.remove(oWorld.data.tacticCardCtrls, __activeSkillNum)
		
		--数量减1
		__activeSkillNum = __activeSkillNum - 1
		
		--立刻刷新战术技能卡cd
		__refreshTacticCDLab()
		
		--立即刷新战术技能卡状态
		__refreshTacticState()
		]]
	end
	
	--删除单个主动战术(道具)技能卡的主动技能界面
	__RemoveSingleActiveItemCtrl = function(parentFrm, tacticId, itemId, activeIndex)
		local __activeSkillNum = __activeSkillNum --只读
		if (__activeSkillNum == activeIndex) then --删除的为末尾控件，无需动画
			__RemoveSingleActiveItemCtrl_logic(parentFrm, tacticId, itemId, activeIndex)
		else
			--先隐藏自身
			local btnI = parentFrm.childUI["btnTactics_" .. activeIndex]
			btnI:setstate(-1)
			
			--后面的做运动
			local sendNum = __activeSkillNum - activeIndex
			local receiveNum = 0
			for i = __activeSkillNum, activeIndex + 1, -1 do
				local btni = parentFrm.childUI["btnTactics_" .. i]
				if btni then
					--local btnj = parentFrm.childUI["btnTactics_" .. (i - 1)]
					--geyachao: 因为战术卡分左右，所以本次运动前需要找到左右列的前一个战术卡的索引
					local btnj = btni
					local activeSkillIsBuildTower = btni.data.activeSkillIsBuildTower --是否建造塔（战术卡界面放左边）
					local leftSkillNum = 0
					local rightSkillNum = 0
					--分别统计左右侧战术卡的数量
					for ii = i - 1, 1, -1 do
						local btnii = parentFrm.childUI["btnTactics_" .. ii]
						if btnii and (btnii ~= 0) then
							local activeSkillIsBuildTower_ii = btnii.data.activeSkillIsBuildTower --是否建造塔（战术卡界面放左边）
							if (activeSkillIsBuildTower_ii == activeSkillIsBuildTower) then --找到了
								btnj = btnii
								break
							end
						end
					end
					
					if btnj then
						local toX = btnj.data.x
						local toY = btnj.data.y
						
						btni.data.disabled = true
						
						--local wait = CCDelayTime:create(0.05)
						local move = CCMoveTo:create(0.1, ccp(toX, toY)) --CCEaseSineIn:create()
						local callback = CCCallFunc:create(function()
							--print("end", i)
							btni.data.disabled = nil
							receiveNum = receiveNum + 1
							if (receiveNum == sendNum) then
								__RemoveSingleActiveItemCtrl_logic(parentFrm, tacticId, itemId, activeIndex)
							end
						end)
						
						local array = CCArray:create()
						--array:addObject(wait)
						array:addObject(move)
						array:addObject(callback)
						local sequence = CCSequence:create(array)
						btni.handle._n:runAction(sequence)
					end
				end
			end
		end
	end
	
	--创建主动战术技能卡界面
	local OFFSET_Y = 0
	__createActiveTactics = function(parentFrm, mode)
		if (g_phone_mode == 0) then --0.pad, 1.ip4, 2.ip5, 3.android
			OFFSET_Y = 50
		elseif (g_phone_mode == 1)or (g_phone_mode == 2) then --0.pad, 1.ip4, 2.ip5, 3.android
			OFFSET_Y = 70
		else
			OFFSET_Y = 70
		end
		
		local _parentN = parentFrm.handle._n
		
		__clearActiveTactic(parentFrm)
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			--local tTactics = oWorld:gettactics(hGlobal.LocalPlayer.data.playerId) --本局所有的战术技能卡
			local tTactics = oWorld:gettactics(oWorld:GetPlayerMe():getpos()) --本局所有的战术技能卡
			--print("tTactics=", tTactics, tTactics and #tTactics)
			if (tTactics == nil) then
				return
			end
			
			--按类型重新排列卡
			local activeSkillTactic = {}
			local passiveSkillTactic = {}
			local towerOffset = 0
			for i = 1, #tTactics, 1 do
				--print(i, "tTactics[i]=", tTactics[i])
				if tTactics[i]~=0 then
					local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
					local tabT = hVar.tab_tactics[id]
					local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
					if tabT then
						--local name = tabT.name --战术技能卡的名字
						--print(i, name, typeId)
						if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
							local activeSkill = tabT.activeSkill
							local passiveSkill = tabT.skillId
							if activeSkill and (type(activeSkill) == "table") then
								table.insert(activeSkillTactic, {id, lv, typeId}) --geyachao: 该战术技能卡是哪个英雄的
								--table.insert(passiveSkillTactic, {id, lv, typeId}) --geyachao: 该战术技能卡是哪个英雄的
							end
							--towerOffset = 25
						elseif (typeT == hVar.TACTICS_TYPE.TOWER) then --塔类战术技能卡
							--table.insert(activeSkillTactic, {id, lv, typeId}) --geyachao: 该战术技能卡是哪个英雄的
						end
					end
				end
			end
			
			--[[
			--将英雄的战术技能放在前面
			local heroT = {}
			local tacticT = {}
			for k, v in ipairs(activeSkillTactic) do
				local typeId = v[3] --该战术技能卡是哪个英雄的
				if (typeId) and (typeId > 0) then
					table.insert(heroT, v)
				else
					table.insert(tacticT, v)
				end
			end
			
			--最终的主动战术技能卡列表
			local finalTactic = {}
			for i = 1, #heroT, 1 do
				table.insert(finalTactic, heroT[i])
			end
			for i = 1, #tacticT, 1 do
				table.insert(finalTactic, tacticT[i])
			end
			]]
			
			--创建主动战术技能卡按钮
			local finalTactic = activeSkillTactic
			for n = 1, #finalTactic, 1 do
				if (finalTactic[n] ~= 0) then
					local id, lv, typeId = finalTactic[n][1], finalTactic[n][2], finalTactic[n][3] --geyachao: 该战术技能卡是哪个英雄的
					__CreateSingleActiveTacticCtrl(parentFrm, id, 0, lv, -1, typeId)
				end
			end
			
			--大菠萝
			hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 0, 1, -1, hVar.MY_TANK_ID, true) --无 --纯占位用
			hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 0, 1, -1, hVar.MY_TANK_ID, true) --无 --纯占位用
			
			--坦克的道具技能
			local oHero = oWorld:GetPlayerMe().heros[1]
			local itemSkillT = oHero.data.itemSkillT
			local tankItemId = hVar.tab_unit[hVar.MY_TANK_ID].skillItemlId
			print("tankItemId=", tankItemId)
			if itemSkillT and itemSkillT[hVar.TANKSKILL_IDX-hVar.TANKSKILL_EMPTY] then
				hGlobal.event:event("Event_ResetSingleTactic", hVar.TANKSKILL_IDX, 0, tankItemId, 1, -1, hVar.MY_TANK_ID)
			else
				hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), tankItemId, 1, -1, hVar.MY_TANK_ID, true) --扔手雷
			end
			
			--坦克武器的道具技能
			local weaponIdx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID) --当前选中的武器索引值
			local weaponUnitId = hVar.tab_unit[hVar.MY_TANK_ID].weapon_unit[weaponIdx].unitId
			local weaponItemId = hVar.tab_unit[weaponUnitId].skillItemlId
			if itemSkillT and itemSkillT[hVar.NORMALATK_IDX-hVar.TANKSKILL_EMPTY] then
				hGlobal.event:event("Event_ResetSingleTactic", hVar.NORMALATK_IDX, 0, weaponItemId, 1, -1, hVar.MY_TANK_ID)
			else
				hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), weaponItemId, 1, -1, hVar.MY_TANK_ID, true) --开一枪
			end
			--print("weaponItemId=", weaponItemId)
			
			--坦克的其他道具技能（重绘时需要）
			if itemSkillT then
				for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					--tacticPos, tacticId, itemId, tacticlv, num, unitId
					hGlobal.event:event("Event_ResetSingleTactic", k + hVar.TANKSKILL_EMPTY, 0, activeItemId, activeItemLv, activeItemNum, hVar.MY_TANK_ID)
				end
			end
			
			--坦克武器的基础武器等级
			--local oHero = oWorld:GetPlayerMe().heros[1]
			local diablo = hGlobal.LocalPlayer.data.diablodata
			local oUnit = oHero:getunit()
			if oUnit then
				if (oUnit.data.bind_weapon ~= 0) then
					--local basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
					--local basic_weapon_level = oUnit:GetBasicWeaponLevel() --基础武器等级
					local basic_weapon_level = 1
					local oUnit = oHero:getunit()
					if (oUnit.data.bind_weapon ~= 0) then
						--basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
						basic_weapon_level = oUnit:GetBasicWeaponLevel() --基础武器等级
					end
					
					if (basic_weapon_level > hVar.ROLE_NORMALATK_MAXLV) then
						basic_weapon_level = hVar.ROLE_NORMALATK_MAXLV
					end
					print("basic_weapon_level=", basic_weapon_level, mode)
					--local diablo = hGlobal.LocalPlayer.data.diablodata
					if diablo then
						if (mode == "SpinScreen") then --由横竖屏进来的，不需要读取缓存数据
							--
						else
							if type(diablo.randMap) == "table" then
								local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
								--阶段1不存储信息
								if tInfo.id and (tInfo.stage ~= 1 or tInfo.isguide == 1) then
									basic_weapon_level = tInfo.weaponlevel or basic_weapon_level
								end
							end
							
							if (type(diablo.basic_weapon_level) == "number") then
								basic_weapon_level = diablo.basic_weapon_level
								diablo.basic_weapon_level = nil --一次性加完
							end
						end
					end
					local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
					local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
					if (type(btn1) == "table") then
						btn1.childUI["labSkillLv"]:setText(basic_weapon_level)
						oUnit.data.bind_weapon.attr.attack[6] = basic_weapon_level
						if (basic_weapon_level > 1) then
							btn1.childUI["labSkillLv"].handle._n:setVisible(true)
							btn1.childUI["labSkillMana"].handle._n:setVisible(true)
						else
							btn1.childUI["labSkillLv"].handle._n:setVisible(false)
							btn1.childUI["labSkillMana"].handle._n:setVisible(false)
						end
					end
				end
			end
			
			--坦克的基础技能等级
			if oUnit then
				local basic_skill_level = oUnit:GetBasicSkillLevel()
				local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				btn2.childUI["labSkillLv"]:setText(basic_skill_level)
				
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					local k = 1
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					--print(activeItemId)
					
					--存储
					itemSkillT[k].activeItemLv = basic_skill_level
				end
			end
			
			--坦克的基础使用次数
			if oUnit then
				local basic_skill_usecount = oUnit:GetGrenadeMultiply() --oUnit:GetBasicSkillUseCount()
				--print("basic_skill_usecount=", basic_skill_usecount)
				local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				btn2.data.useCountMax = basic_skill_usecount
				btn2.data.useCount = basic_skill_usecount
				btn2.childUI["labSkillUseCount"]:setText(basic_skill_usecount)
			end
			
			--local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
			if diablo then
				if diablo.heros.itemSkillT then
					oHero.data.itemSkillT = diablo.heros.itemSkillT --战术卡数据
					--print("大菠萝+++道具技能", oHero.data.itemSkillT and #oHero.data.itemSkillT)
					
					--一次性添加完
					diablo.heros.itemSkillT = nil
				end
			end
			
			--坦克的上局存在的宠物
			if oUnit then
				if diablo then
					local follow_pet_units = diablo.follow_pet_units
					if (type(follow_pet_units) == "table") then
						local unitX, unitY = hApi.chaGetPos(oUnit.handle)
						
						--依次添加宠物
						for p = 1, #follow_pet_units, 1 do
							local id = follow_pet_units[p].id
							local lv = follow_pet_units[p].lv
							local star = follow_pet_units[p].star
							local facing = oWorld:random(0, 360)
							local randPosX = unitX + oWorld:random(-12, 12)
							local randPosY = unitY + oWorld:random(-12, 12)
							randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 24)
							
							--添加角色
							local nu = oWorld:addunit(id, 1,nil,nil, facing, randPosX, randPosY,nil,nil, lv, star)
							
							--标记是我方单位
							--print("标记是我方单位", nu.data.id, nu:getworldC())
							oWorld.data.rpgunits[nu] = nu:getworldC() --标记是我方单位
						end
						
						diablo.follow_pet_units = nil --一次性加完
					end
				end
			end
			
			--本局营救的科学家数据
			if diablo then
				local statistics_rescue_count = diablo.statistics_rescue_count --营救的科学家数量(随机关单局数据)
				local statistics_rescue_num = diablo.statistics_rescue_num --营救的科学家数量(随机关累加数据)
				local statistics_rescue_costnum = diablo.statistics_rescue_costnum --营救的科学家消耗数量
				local statistics_crystal_num = diablo.statistics_crystal_num --水晶数量
				local weapon_attack_state = diablo.weapon_attack_state --自动开枪标记
				if (type(statistics_rescue_count) == "number") then
					oWorld.data.statistics_rescue_count = statistics_rescue_count
					diablo.statistics_rescue_count = nil --一次性加完
				end
				if (type(statistics_rescue_num) == "number") then
					oWorld.data.statistics_rescue_num = statistics_rescue_num
					diablo.statistics_rescue_num = nil --一次性加完
				end
				if (type(statistics_rescue_costnum) == "number") then
					oWorld.data.statistics_rescue_costnum = statistics_rescue_costnum
					diablo.statistics_rescue_costnum = nil --一次性加完
				end
				if (type(statistics_crystal_num) == "number") then
					oWorld:GetPlayerMe():addresource(hVar.RESOURCE_TYPE.GOLD, statistics_crystal_num)
					diablo.statistics_crystal_num = nil --一次性加完
					hGlobal.event:event("Event_TacticCastCostRefresh")
				end
				if (type(weapon_attack_state) == "number") then
					if (weapon_attack_state == 2) then
						--触发事件：长按攻击按钮
						hGlobal.event:event("Event_OpenAutoAttack")
					end
					diablo.weapon_attack_state = nil --一次性加完
				end
			end
			
			--坦克的血量百分比
			if diablo then
				local hpRate = diablo.hpRate --生命百分比
				if (type(hpRate) == "number") then
					if oUnit then
						if (hpRate > 100) then
							hpRate = 100
						end
						
						if (hpRate < 1) then
							hpRate = 1
						end
						
						--少血了才需要更新
						if (hpRate < 100) then
							local hpNow = math.floor(oUnit:GetHpMax() * hpRate / 100)
							oUnit.attr.hp = hpNow
							
							--刷新单位的血条
							--更新血条控件
							if oUnit.chaUI["hpBar"] then
								oUnit.chaUI["hpBar"]:setV(oUnit.attr.hp, oUnit:GetHpMax())
							end
							if oUnit.chaUI["numberBar"] then
								oUnit.chaUI["numberBar"]:setText(oUnit.attr.hp .. "/" .. oUnit:GetHpMax())
							end
							
							--更新英雄头像的血条(+)
							local oHero = oUnit:gethero()
							if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
								--oHero.heroUI["hpBar"]:setV(new_hp, hp_max)
								--设置大菠萝的血条
								SetHeroHpBarPercent(oHero, oUnit.attr.hp, oUnit:GetHpMax(), true)
							end
						end
					end
					
					diablo.hpRate = nil --一次性加完
				end
			end
			
			--本局的仓库战术卡数据
			if diablo then
				local tTacticInfo = diablo.tTacticInfo --战术卡信息
				if (type(tTacticInfo) == "table") then
					--存储
					local tDataList = {}
					for k, v in pairs(tTacticInfo) do
						tDataList[#tDataList+1] = {k, v,}
					end
					GameManager.SetGameInfo("tacticInfo", tDataList)
					hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					
					diablo.tTacticInfo = nil --一次性加完
				end
			end
			
			--本局的仓库宝箱数据
			if diablo then
				local tChestInfo = diablo.tChestInfo --宝箱数据
				if (type(tChestInfo) == "table") then
					--存储
					local tDataList = {}
					for k, v in pairs(tChestInfo) do
						tDataList[#tDataList+1] = {k, v,}
					end
					GameManager.SetGameInfo("chestInfo", tDataList)
					hGlobal.event:event("LocalEvent_ShowTempBagBtn")
					
					diablo.tChestInfo = nil --一次性加完
				end
			end
			
			--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
			if (oWorld.data.map == hVar.RandomMap) then
				--进入游戏
				LuaClearRandommapInfo(g_curPlayerName)
			end
		end
	end
	
	--清除被动战术技能卡
	local __clearPassiveTactic = function(parentFrm)
		--print("__clearPassiveTactic:"..passiveSkillNum)
		for i = 1, passiveSkillNum do
			hApi.safeRemoveT(parentFrm.childUI, "imgPassiveTactics_"..i)
		end
		hApi.safeRemoveT(parentFrm.childUI, "imgPassivePopFrmBg")
		passiveSkillNum = 0
	end
	
	--创建被动战术技能卡
	local __createPassiveTactics = function(parentFrm)
		--print("__createPassiveTactics")
		--iPhoneX黑边宽
		local iPhoneX_WIDTH = 0
		if (g_phone_mode == 4) then --iPhoneX
			iPhoneX_WIDTH = hVar.SCREEN.offx
		end
		
		local _parentN = parentFrm.handle._n
		
		__clearPassiveTactic(parentFrm)
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			--geyachao: 特殊处理，如果是随机迷宫，恢复存档进来的，就不展示战术卡了
			if (oWorld.data.map == hVar.RandomMap) then
				local randommapStage = oWorld.data.randommapStage --当前所在随机地图层数
				if (randommapStage > 1) then
					return
				end
			end
			
			--local tTactics = oWorld:gettactics(hGlobal.LocalPlayer.data.playerId)
			--local tTactics = oWorld:GetPlayerGod():gettactics()
			local tTactics = oWorld:gettactics(oWorld:GetPlayerMe():getpos()) or {}
			
			--pvp模式读上帝携带的战术卡
			local mapInfo = oWorld.data.tdMapInfo
			if mapInfo then
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --pvp模式，读上帝的
					local godPlayer = oWorld:GetPlayerGod()
					tTactics = godPlayer:gettactics() or {}
					--print("附加上帝携带的战术卡", tTactics2)
					
					--夺塔奇兵，如果包含新人卡，显示界面
					local tp = oWorld:gettactics(oWorld:GetPlayerMe():getpos()) or {}
					for i = 1, #tp, 1 do
						if (tp[i][1] == 3000) then
							tTactics[#tTactics+1] = tp[i]
						end
					end
				end
			end
			
			--没有携带卡
			if (#tTactics == 0) then
				return
			end
			
			--按类型重新排列卡
			local passiveSkillTactic = {}
			--local offsetX = 260 + iPhoneX_WIDTH
			--local offsetX = hVar.SCREEN.w - 160 - iPhoneX_WIDTH
			--local offsetY = -40
			--x = hVar.SCREEN.w/2 - 215,
			--y = hVar.SCREEN.h - 50,
			local offsetX = hVar.SCREEN.w/2 - 248
			local offsetY = -hVar.SCREEN.h + 56
			local stateW = 35
			for i = 1, #tTactics do
				if tTactics[i]~=0 then
					local id,lv = tTactics[i][1],tTactics[i][2]
					--print("tactic id lv:", id, lv)
					local tabT = hVar.tab_tactics[id]
					local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
					if tabT then
						if typeT == hVar.TACTICS_TYPE.OTHER then
							local activeSkill = tabT.activeSkill
							if activeSkill and type(activeSkill) == "table" then
							else
								local isMapT = oWorld.data.statistics.mapTactic
								if isMapT[id] then
									table.insert(passiveSkillTactic, {id, lv, false})
								else
									table.insert(passiveSkillTactic, {id, lv, true})
								end
							end
							
						end
					end
				end
			end
			
			local mapTacticNum = 0
			local myTacticNum = 0
			for n = 1, #passiveSkillTactic, 1 do
				local id, lv, flag = passiveSkillTactic[n][1], passiveSkillTactic[n][2], passiveSkillTactic[n][3]
				local tabT = hVar.tab_tactics[id]
				local icon = tabT.icon
				local negative = tabT.negative --是否负面效果
				
				passiveSkillNum = passiveSkillNum + 1
				--pad的尺寸
				--local x = offsetX + stateW * (passiveSkillNum - 1)
				local x = offsetX - stateW * (passiveSkillNum - 1)
				local y = hVar.SCREEN.h + offsetY

				--if g_phone_mode == 0 then
					--x = offsetX - stateW * ((passiveSkillNum-1)%4) + 20
					--y = hVar.SCREEN.h + offsetY - math.floor((passiveSkillNum-1)/4)* 40
				--end
				
				--if flag then
				--	myTacticNum = myTacticNum + 1
				--	x = offsetX + stateW * (myTacticNum - 1)
				--	y = hVar.SCREEN.h + offsetY + 5
				--else
				--	mapTacticNum = mapTacticNum + 1
				--	x = offsetX + stateW * (mapTacticNum - 1)
				--	y = hVar.SCREEN.h + offsetY * 2 - 5
				--end
				
				--被动战术技能卡图标
				parentFrm.childUI["imgPassiveTactics_"..passiveSkillNum] = hUI.button:new({
					parent = parentFrm,
					--model = icon,
					model = "misc/mask.png",
					x = x,
					y = y,
					w = 1,
					h = 1,
					--w = 32,
					--h = 32,
					dragbox = 0,
					failcall = 1,
					
					--geyachao: 按下战术技能卡事件，绘制该战术技能卡的说明
					codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
						--图标放入了下方  不再显示介绍
						if true then
							return
						end
						local __parent = parentFrm.childUI["imgPassiveTactics_" .. n]
						local __parentHandle = __parent.handle._n
						--local offset = 215
						local offset = - 350 +stateW * (passiveSkillNum - 1)
						local yOffset = -75
						
						--选中框
						__parent.childUI["box"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:BTN_SkillSelector",
							x = 0,
							y = 0,
							w = stateW,
							h = stateW,
							align = "MC",
						})
						
						--技能背景框
						__parent.childUI["imgBg"] = hUI.button:new({
							parent = __parentHandle,
							model = "misc/mask.png", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 460, --236
							h = 100, --146
							align = "MC",
						})
						__parent.childUI["imgBg"].handle.s:setOpacity(0) --只挂载子控件，不显示
						local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 460, 100, __parent.childUI["imgBg"])
						--img9:setOpacity(128)
						
						__parent.childUI["imgBga"] = hUI.image:new({
							parent = __parentHandle,
							model = "misc/mask_16.png", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 460, --236
							h = 100, --146
							align = "MC",
						})
						--__parent.childUI["imgBg"].handle.s:setOpacity(96)
						
						if (not negative) then
							--frmBg.childUI["imgBga" .. i].handle._n:setColor(ccc3(112, 170, 57))
							--__parent.childUI["imgBg"].handle.s:setOpacity(128)
							img9:setOpacity(128)
							__parent.childUI["imgBga"].handle._n:setColor(ccc3(20,80,180))
						else
							--__parent.childUI["imgBg"].handle.s:setOpacity(150)
							img9:setOpacity(150)
							__parent.childUI["imgBga"].handle._n:setColor(ccc3(255,0,0))
						
						end
						
						--图标
						__parent.childUI["imgIcon"] = hUI.image:new({
							parent = __parentHandle,
							model = icon,
							x = offset - 180,
							y = yOffset - 2,
							w = 75,
							h = 75,
							align = "MC",
						})
						
						--技能名称
						local name = hVar.tab_stringT[id] and hVar.tab_stringT[id][1] or ("未知技能" .. id)
						__parent.childUI["labName"] = hUI.label:new({
							parent = __parentHandle,
							size = 28,
							align = "LT",
							border = 1,
							x = offset - 135,
							y = yOffset + 44,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 210,
							text = name,
						})
						__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 0))
						
						
						--技能等级
						local lvOffsetX = offset - 48 + #name * 9
						__parent.childUI["labLevel"] = hUI.label:new({
							parent = __parentHandle,
							size = 24,
							align = "RT",
							border = 1,
							x = lvOffsetX,
							y = yOffset + 44 - 3,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 210,
							--text = "等级" .. lv, --language
							--text = hVar.tab_string["__Attr_Hint_Lev"] .. lv, --language
							text = "lv" .. lv, --language
						})
						__parent.childUI["labLevel"].handle.s:setColor(ccc3(255, 255, 128))
						
						
						--技能描述
						local fontSize = 26
						local intro = hVar.tab_stringT[id] and hVar.tab_stringT[id][(lv or 0) + 1] or ("未知技能说明" .. id)
						--print(#intro)
						if (#intro >= 96) then --文字太长，字体缩小一点
							fontSize = 17
						elseif (#intro > 78) then --文字太长，字体缩小一点
							fontSize = 20
						elseif (#intro > 69) then --文字太长，字体缩小一点
							fontSize = 22
						elseif (#intro > 60) then
							fontSize = 24
						end
						__parent.childUI["labIntro"] = hUI.label:new({
							parent = __parentHandle,
							size = fontSize,
							align = "LT",
							border = 1,
							x = offset - 133,
							y = yOffset + 12,
							font = hVar.FONTC,
							width = 360,
							text = intro,
						})
					end,
					
					--geyachao: 抬起战术技能卡事件，删除该战术技能卡的说明
					code = function(self)
						local __parent = parentFrm.childUI["imgPassiveTactics_" .. n]
						hApi.safeRemoveT(__parent.childUI, "box") --选中框
						hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgBga") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
						hApi.safeRemoveT(__parent.childUI, "labName") --技能名称
						hApi.safeRemoveT(__parent.childUI, "labLevel") --技能等级
						hApi.safeRemoveT(__parent.childUI, "labIntro") --技能描述
					end,
				})
				
				parentFrm.childUI["imgPassiveTactics_"..passiveSkillNum].handle._n:setVisible(false)
				
				parentFrm.childUI["imgPassiveTactics_"..passiveSkillNum].childUI["icon"] = hUI.image:new({
					parent = parentFrm.childUI["imgPassiveTactics_"..passiveSkillNum].handle._n,
					model = icon,
					x = 0,
					y = 0,
					scale = 0.3,
				})
			end
			
			
			--geyachao: 大菠萝不要飞的动画了
			--绘制弹出面板
			local offset = 0
			local offset1 = 22
			local xOffset = 0.5
			local yOffset = 0.5
			local w = 320
			local h = 320
			parentFrm.childUI["imgPassivePopFrmBg"] = hUI.button:new({ --作为button是为了挂子控件
				parent = _parentN,
				model = -1,
				x = hVar.SCREEN.w * 0.5,
				y = hVar.SCREEN.h * 0.5,
			})
			local frmBg = parentFrm.childUI["imgPassivePopFrmBg"]
			frmBg.handle._n:setVisible(false)
			
			--依次绘制被动战术卡图标
			for i = 1,#passiveSkillTactic do
				local id, lv, flag = passiveSkillTactic[i][1], passiveSkillTactic[i][2], passiveSkillTactic[i][3]
				local tabT = hVar.tab_tactics[id]
				local icon = tabT.icon
				local negative = tabT.negative --是否负面效果
				
				--local kkk = math.floor((passiveSkillNum - 1) / 5) + 1
				--local tmp = math.mod(i, kkk)
				--if tmp == 0 then
				--	tmp = kkk
				--end
				--local abc = math.floor((i - 1) / 5) + 1
				
				
				local xMax = passiveSkillNum
				if passiveSkillNum > 5 then
					xMax = 5
				end
				local xi = xMax - math.mod(i, xMax) + 1
				if xi == xMax + 1 then
					xi = 1
				end
				
				local yi = math.floor((i - 1) / 5) + 1
				local yMax = math.floor((passiveSkillNum - 1) / 5) + 1
				
				--技能背景框
				frmBg.childUI["imgBg" .. i] = hUI.button:new({
					parent = frmBg.handle._n,
					model = "misc/mask.png", --"UI:ExpBG",
					x = offset + (xMax * 0.5 - xi + xOffset) * w,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h,
					w = 300, --236
					h = 300, --146
					align = "MC",
				})
				frmBg.childUI["imgBg" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
				local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 300, 300, frmBg.childUI["imgBg" .. i])
				--img9:setOpacity(128)
				
				--技能背景框
				frmBg.childUI["imgBga" .. i] = hUI.image:new({
					parent = frmBg.handle._n,
					model = "misc/mask_16.png", --"UI:ExpBG",
					x = offset + (xMax * 0.5 - xi + xOffset) * w,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h,
					w = 300, --236
					h = 300, --146
					align = "MC",
				})
				
				if (not negative) then --正面
					--frmBg.childUI["imgBga" .. i].handle._n:setColor(ccc3(112, 170, 57))
					frmBg.childUI["imgBga" .. i].handle._n:setColor(ccc3(20,80,180))
					--frmBg.childUI["imgBg" .. i].handle.s:setOpacity(150)
					img9:setOpacity(150)
				else --负面
					frmBg.childUI["imgBga" .. i].handle._n:setColor(ccc3(255,0,0))
					--frmBg.childUI["imgBg" .. i].handle.s:setOpacity(128)
					img9:setOpacity(128)
				end
				
				--图标
				frmBg.childUI["imgIcon" .. i] = hUI.image:new({
					parent = frmBg.handle._n,
					model = icon,
					x = offset + (xMax * 0.5 - xi + xOffset) * w - 90,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h + 84,
					w = 78,
					h = 78,
					align = "MC",
				})
				
				--[[
				--geyachao: 战车不要显示敌方战术卡的等级
				--小圈圈描绘战术卡等级
				--战术卡等级背景图
				frmBg.childUI["imgIconLvBG" .. i] = hUI.image:new({
					parent = frmBg.handle._n,
					model = "ui/pvp/pvpselect.png",
					x = offset + (xMax * 0.5 - xi + xOffset) * w - 65 + 24,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h + 50 + 22,
					w = 28,
					h = 28,
				})
				
				--战术卡的技能等级
				local fontSize = 20
				if lv and (lv >= 10) then --如果等级是2位数的，那么缩一下文字
					fontSize = 14
				end
				frmBg.childUI["imgIconLv" .. i] = hUI.label:new({
					parent = frmBg.handle._n,
					x = offset + (xMax * 0.5 - xi + xOffset) * w - 65 + 24,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h + 50 + 22 - 1,
					text = lv,
					size = fontSize,
					font = "numWhite",
					align = "MC",
					width = 200,
				})
				]]
				
				--技能名称
				local name = hVar.tab_stringT[id] and hVar.tab_stringT[id][1] or ("未知技能" .. id)
				local fontNameSize = 30
				--if (#name >= 12) then --名字太长，那么缩一下文字
				--	fontNameSize = 26
				--end
				frmBg.childUI["labName" .. i] = hUI.label:new({
					parent = frmBg.handle._n,
					size = fontNameSize,
					align = "MC",
					border = 1,
					x = offset + (xMax * 0.5 - xi + xOffset) * w + 46,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h + 86,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 500,
					text = name,
				})
				frmBg.childUI["labName" .. i].handle.s:setColor(ccc3(255, 255, 0))
				
				--技能描述
				local fontSize = 28
				local intro = hVar.tab_stringT[id] and hVar.tab_stringT[id][(lv or 0) + 1] or ("未知技能说明" .. id)
				--[[
				--print(#intro)
				if (#intro >= 96) then --文字太长，字体缩小一点
					fontSize = 17
				elseif (#intro > 78) then --文字太长，字体缩小一点
					fontSize = 20
				elseif (#intro > 69) then --文字太长，字体缩小一点
					fontSize = 22
				elseif (#intro > 60) then
					fontSize = 24
				end
				]]
				frmBg.childUI["labIntro" .. i] = hUI.label:new({
					parent = frmBg.handle._n,
					size = fontSize,
					align = "LT",
					border = 1,
					x = offset + (xMax * 0.5 - xi + xOffset) * w - 130,
					y = offset1 + (yMax * 0.5 - yi + yOffset) * h + 20,
					font = hVar.FONTC,
					width = 260,
					text = intro,
				})
				
				--位置测试
				--frmBg.childUI["imgBgTestPos" .. i] = hUI.image:new({
				--	parent = frmBg.handle._n,
				--	model = "UI:TacticBG", --"UI:ExpBG",
				--	x = offset + (xMax * 0.5 - xi + xOffset) * w,
				--	y = offset1 + (yMax * 0.5 - yi + yOffset) * h,
				--	w = 10, --236
				--	h = 10, --146
				--	align = "MC",
				--})
				
			end
			
			local passiveTacticInfoActionEnd2 = function()
				if parentFrm.childUI["imgPassivePopFrmBg"] then
					parentFrm.childUI["imgPassivePopFrmBg"].handle._n:setVisible(false)
				end
				for i = 1,passiveSkillNum do
					if parentFrm.childUI["imgPassiveTactics_"..i] then
						--parentFrm.childUI["imgPassiveTactics_"..i].handle._n:setVisible(true)
						parentFrm.childUI["imgPassiveTactics_"..i].handle._n:setVisible(false) --geyachao: 战车不永久显示这个被动技能小图标了
					end
				end
			end
			
			local passiveTacticInfoActionEnd1 = function()
				if parentFrm.childUI["imgPassivePopFrmBg"] then
					local a = CCJumpBy:create(0.2,ccp(0,0),-6,1)
					local aR = a:reverse()
					local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
					parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(seq)
				end
				hApi.addTimerOnce("passiveTacticInfoAction1",3000,function()
					if parentFrm.childUI["imgPassivePopFrmBg"] then
						local time = 0.3
						parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCScaleTo:create(time,0.1))	--缩放
						local x = offsetX + stateW * (passiveSkillNum * 0.5)
						local y = hVar.SCREEN.h + offsetY
						parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(time,ccp(x, y)),CCCallFunc:create(passiveTacticInfoActionEnd2)))
					end
				end)
			end
			
			--被动战术技能卡在屏幕上闪一段时间后，飞到屏幕左上角
			hApi.addTimerOnce("passiveTacticInfoAction1", 200, function()
				if parentFrm.childUI["imgPassivePopFrmBg"] then
					parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCFadeIn:create(0.1))		--淡入
					parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.1,1),CCCallFunc:create(passiveTacticInfoActionEnd1)))
					parentFrm.childUI["imgPassivePopFrmBg"].handle._n:setVisible(true)
				end
			end)
			
			for i = 1,passiveSkillNum do
				if parentFrm.childUI["imgPassiveTactics_"..i] then
					parentFrm.childUI["imgPassiveTactics_"..i].handle._n:setVisible(false)
				end
			end
			
			----依次绘制塔的技能图标
			--for i = 1,#passiveSkillTactic do
			--	local id, lv = passiveSkillTactic[i][1], passiveSkillTactic[i][2]
			--	local tabT = hVar.tab_tactics[id]
			--	local icon = tabT.icon
			--	
			--	--技能背景框
			--	frmBg.childUI["imgBg" .. i] = hUI.image:new({
			--		parent = frmBg.handle._n,
			--		model = "UI:TacticBG", --"UI:ExpBG",
			--		x = offset,
			--		y = offset + (passiveSkillNum * 0.5 - i + yOffset) * h,
			--		w = 460, --236
			--		h = 100, --146
			--		align = "MC",
			--	})
			--	frmBg.childUI["imgBg" .. i].handle.s:setOpacity(96)
			--	
			--	--图标
			--	frmBg.childUI["imgIcon" .. i] = hUI.image:new({
			--		parent = frmBg.handle._n,
			--		model = icon,
			--		x = offset - 180,
			--		y = offset + (passiveSkillNum * 0.5 - i + yOffset) * h - 2,
			--		w = 75,
			--		h = 75,
			--		align = "MC",
			--	})
			--	
			--	--技能名称
			--	local name = hVar.tab_stringT[id] and hVar.tab_stringT[id][1] or ("未知技能" .. id)
			--	frmBg.childUI["labName" .. i] = hUI.label:new({
			--		parent = frmBg.handle._n,
			--		y = 28,
			--		size = 30,
			--		align = "LT",
			--		border = 1,
			--		x = offset - 135,
			--		y = offset + (passiveSkillNum * 0.5 - i + yOffset) * h + 44,
			--		--font = hVar.FONTC,
			--		font = hVar.FONTC,
			--		width = 210,
			--		text = name,
			--	})
			--	frmBg.childUI["labName" .. i].handle.s:setColor(ccc3(255, 255, 0))
			--	
			--	--技能描述
			--	local intro = hVar.tab_stringT[id] and hVar.tab_stringT[id][(lv or 0) + 1] or ("未知技能说明" .. id)
			--	frmBg.childUI["labIntro" .. i] = hUI.label:new({
			--		parent = frmBg.handle._n,
			--		size = 26,
			--		align = "LT",
			--		border = 1,
			--		x = offset - 133,
			--		y = offset + (passiveSkillNum * 0.5 - i + yOffset) * h + 12,
			--		font = hVar.FONTC,
			--		width = 360,
			--		text = intro,
			--	})
			--	
			--end
			--
			--local passiveTacticInfoActionEnd2 = function()
			--	if parentFrm.childUI["imgPassivePopFrmBg"] then
			--		parentFrm.childUI["imgPassivePopFrmBg"].handle._n:setVisible(false)
			--	end
			--	for i = 1,passiveSkillNum do
			--		if parentFrm.childUI["imgPassiveTactics_"..i] then
			--			parentFrm.childUI["imgPassiveTactics_"..i].handle._n:setVisible(true)
			--		end
			--	end
			--end
			--
			--local passiveTacticInfoActionEnd1 = function()
			--	if parentFrm.childUI["imgPassivePopFrmBg"] then
			--		local a = CCJumpBy:create(0.2,ccp(0,0),-6,1)
			--		local aR = a:reverse()
			--		local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
			--		parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(seq)
			--	end
			--	hApi.addTimerOnce("passiveTacticInfoAction1",3000,function()
			--		if parentFrm.childUI["imgPassivePopFrmBg"] then
			--			local time = 0.3
			--			parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCScaleTo:create(time,0.1))	--缩放
			--			local x = offsetX + stateW * (passiveSkillNum * 0.5)
			--			local y = hVar.SCREEN.h + offsetY
			--			parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(time,ccp(x, y)),CCCallFunc:create(passiveTacticInfoActionEnd2)))
			--		end
			--	end)
			--end
			--
			----被动战术技能卡在屏幕上闪一段时间后，飞到屏幕左上角
			--hApi.addTimerOnce("passiveTacticInfoAction1", 200, function()
			--	if parentFrm.childUI["imgPassivePopFrmBg"] then
			--		parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCFadeIn:create(0.1))		--淡入
			--		parentFrm.childUI["imgPassivePopFrmBg"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.1,1),CCCallFunc:create(passiveTacticInfoActionEnd1)))
			--		parentFrm.childUI["imgPassivePopFrmBg"].handle._n:setVisible(true)
			--	end
			--end)
		end
	end
	
	--清理坦克数量图片
	local __clearTankNumImage = function(parentFrm)
		for i = 1,math.max(tankLiftNum - 1,hVar.DEFAULT_LIFT_NUM - 1) do
			hApi.safeRemoveT(parentFrm.childUI, "thumbImage_Tank"..i)
		end
		tankLiftNum = 0
	end
	
	--更新坦克数量
	local __UpdateTankNum = function(parentFrm)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
		if diablodata and oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			local oUnit = oHero:getunit()
			if oUnit then
				local nTankId = oUnit.data.id
				local tabU = hVar.tab_unit[nTankId] or {}
				if tabU then
					local lifecount = diablodata.lifecount or hVar.DEFAULT_LIFT_NUM
					local scaleTank = 0.4
					local y = hVar.SCREEN.h - 40
					for i = 1,math.max(tankLiftNum - 1,hVar.DEFAULT_LIFT_NUM - 1) do
						if i < lifecount then
							if parentFrm.childUI["thumbImage_Tank"..i] == nil then
								parentFrm.childUI["thumbImage_Tank"..i] = hUI.button:new({
									model = tabU.model,
									parent = parentFrm.handle._n,
									x = (i-1)*60 + 50,
									y = y,
									scale = scaleTank,
								})
								local bind_wheel = tabU.bind_wheel or 0
								if (bind_wheel > 0) then
									parentFrm.childUI["thumbImage_Tank"..i].childUI["wheel"] = hUI.image:new({
										parent = parentFrm.childUI["thumbImage_Tank"..i].handle._n,
										model = hVar.tab_unit[bind_wheel].model,
										x = 0,
										y = 0,
										scale = scaleTank,
									})
								end
							end
						else
							if parentFrm.childUI["thumbImage_Tank"..i] then
								hApi.safeRemoveT(parentFrm.childUI, "thumbImage_Tank"..i)
							end
						end
					end
					tankLiftNum = lifecount
				end
			end
		end
	end
	
	local tempRescuedPersonData = {}
	
	--清理被营救人员
	local __clearRescuedPerson = function(parentFrm)
		tempRescuedPersonData = {}
		hApi.safeRemoveT(parentFrm.childUI, "btn_RescuedPerson")
		hApi.safeRemoveT(parentFrm.childUI, "Lab_RescuedPerson")
		parentFrm.childUI["btn_RescuedPerson"] = nil
	end
	
	--播放营救人员的动画
	local __playRescuedPersonAction = function(parentFrm,screenX,screenY)
		if parentFrm.childUI["btn_RescuedPerson"] then
			parentFrm.childUI["btn_RescuedPerson"].handle._n:setVisible(true)
		end
		if parentFrm.childUI["Lab_RescuedPerson"] then
			parentFrm.childUI["Lab_RescuedPerson"].handle._n:setVisible(true)
		end
		local count = tempRescuedPersonData.count or 0
		count = count + 1
		tempRescuedPersonData.count = count
		parentFrm.childUI["Img_RescuedPerson"..count] = hUI.image:new({
			model = "misc/gameover/icon_man.png",
			parent = parentFrm.handle._n,
			x = screenX,
			y = screenY + 54,
		})
		local toX = parentFrm.childUI["btn_RescuedPerson"].data.x
		local toY = parentFrm.childUI["btn_RescuedPerson"].data.y
		local move = CCMoveTo:create(0.5, ccp(toX, toY))
		local callback = CCCallFunc:create(function()
			if count ~= nil then
				hApi.safeRemoveT(parentFrm.childUI, "Img_RescuedPerson"..count)
				parentFrm.childUI["Lab_RescuedPerson"]:setText(" "..count)
			end
		end)
		local towAction = CCSequence:createWithTwoActions(move, callback)
		parentFrm.childUI["Img_RescuedPerson"..count].handle._n:runAction(towAction)
	end
	
	--创建营救人员
	local __CreateRescuedPerson = function(parentFrm,nCount)
		nCount = nCount or tempRescuedPersonData.count
		tempRescuedPersonData.count = nCount or 0
		local oy = 0 
		local ox = hVar.SCREEN.offx

		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			ox = hVar.SCREEN.offx - 60
			oy = -50
		end
		if parentFrm.childUI["btn_RescuedPerson"] == nil then
			parentFrm.childUI["btn_RescuedPerson"] = hUI.button:new({
				model = "misc/mask.png",
				parent = parentFrm,
				x = 64 + ox,
				y = hVar.SCREEN.h - 110 + oy,
				dragbox = 0,
				failcall = 1,
				codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
					local __parent = parentFrm.childUI["btn_RescuedPerson"]
					local __parentHandle = __parent.handle._n
					local offset = 215
					local yOffset = -75
					
					--技能背景框
					__parent.childUI["imgBg"] = hUI.button:new({
						parent = __parentHandle,
						model = "misc/mask.png", --"UI:ExpBG",
						x = offset,
						y = yOffset,
						w = 460, --236
						h = 100, --146
						align = "MC",
					})
					--__parent.childUI["imgBg"].handle.s:setOpacity(200)
					__parent.childUI["imgBg"].handle.s:setColor(ccc3(0, 0, 0))
				end,
				code = function(self)
					local __parent = parentFrm.childUI["btn_RescuedPerson"]
					hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				end,
			})
			parentFrm.childUI["btn_RescuedPerson"].handle.s:setOpacity(0)

			parentFrm.childUI["btn_RescuedPerson"].childUI["img_person"] = hUI.image:new({
				model = "misc/gameover/icon_man.png",
				parent = parentFrm.childUI["btn_RescuedPerson"].handle._n,
				x = 0,
				y = 0,
			})
		end
		if parentFrm.childUI["Lab_RescuedPerson"] == nil then
			parentFrm.childUI["Lab_RescuedPerson"] = hUI.label:new({
				parent = parentFrm.handle._n,
				x = 100 + ox,
				y = hVar.SCREEN.h - 110 + oy,
				align = "LC",
				font = "num",
				border = 0,
				size = 22,
				text = " "..tostring(nCount),
			})
		end

	end
	
	--显示随机地图的进度
	local __CODE_ShowRandMapStage = function(parentFrm)
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				oWorld:pause(1)
				local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
				local nForceMe = oPlayerMe:getforce() --我的势力
				local oHero = oPlayerMe.heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						oUnit:sethide(1)
						if oUnit.data.bind_wheel then
							oUnit.data.bind_wheel:sethide(1)
						end
						if oUnit.data.bind_weapon then
							oUnit.data.bind_weapon:sethide(1)
						end
						if oUnit.data.bind_light then
							oUnit.data.bind_light:sethide(1)
						end
					end
				end
			end
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			local sText = "STAGE " .. tostring(tInfo.stage)
			parentFrm.childUI["stage_node"] = hUI.node:new({
				parent = parentFrm.handle._n,
				x = hVar.SCREEN.w/2,
				y = hVar.SCREEN.h/2,
			})
			local node = parentFrm.childUI["stage_node"]
			--node.childUI["img_stage_bg"] = hUI.image:new({
				--parent = node.handle._n,
				--model = "UI:selectbg",
				--w = 200,
				--h = 50,
			--})
			--node.childUI["lab_stage"] = hUI.label:new({
				--parent = node.handle._n,
				--text = sText,
				--border = 1,
				--size = 36,
				--align = "MC",
				--font = hVar.FONTC,
				--RGB = {255, 200, 50},
			--})
			--312 + 53

			local stageIcon = "misc/addition/stage.png"
			if g_Cur_Language ~= 1 then
				stageIcon = "misc/addition/stage_en.png"
			end

			node.childUI["img_stage_bg"] = hUI.image:new({
				parent = node.handle._n,
				model = stageIcon,
				x = - 80/2,
			})
			node.childUI["img_stage_bg"]:setXY(node.childUI["img_stage_bg"].data.x - hVar.SCREEN.w/2 - 240,0)
			node.childUI["img_stage_bg"].handle._n:runAction(CCMoveTo:create(0.3,ccp(-80/2,0)))

			node.childUI["img_stage_num_bg"] = hUI.image:new({
				parent = node.handle._n,
				model = "UI:StageNum",
				animation = "N"..tostring(tInfo.stage),
				x = 312/2 + 10,
				y = 1,
				scale = 1.32,
			})
			node.childUI["img_stage_num_bg"]:setXY(node.childUI["img_stage_num_bg"].data.x + hVar.SCREEN.w/2  + 240,0)
			node.childUI["img_stage_num_bg"].handle._n:runAction(CCMoveTo:create(0.3,ccp(312/2 + 10,0)))


			parentFrm.childUI["stage_node"].handle._n:setScale(0.8)
			
			local array = CCArray:create()
			local wait = CCDelayTime:create(1.5)
			local callback1 = CCCallFunc:create(function()
				hApi.safeRemoveT(parentFrm.childUI,"stage_node")
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld then
					oWorld:pause(0)
					local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
					local nForceMe = oPlayerMe:getforce() --我的势力
					local oHero = oPlayerMe.heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							oUnit:sethide(0)
							if oUnit.data.bind_wheel then
								oUnit.data.bind_wheel:sethide(0)
							end
							if oUnit.data.bind_weapon then
								oUnit.data.bind_weapon:sethide(0)
							end
							if oUnit.data.bind_light then
								oUnit.data.bind_light:sethide(0)
							end
						end
					end
				end
			end)
			array:addObject(wait)
			array:addObject(callback1)
			local sequence = CCSequence:create(array)
			node.handle._n:runAction(sequence)
		end
		
	end
	
	--创建单个被动战术技能卡
	--bAddtoTop: 是否跳到顶部展示小图标
	local __createSinglePassiveTactics = function(parentFrm, oPlayer, tacticId, tacticLv, bAddtoTop)
		--iPhoneX黑边宽
		local iPhoneX_WIDTH = 0
		if (g_phone_mode == 4) then --iPhoneX
			iPhoneX_WIDTH = 80
		end
		
		local offsetX = 260 + iPhoneX_WIDTH
		local offsetY = -26
		local stateW = 35
		
		local playerPos = oPlayer:getpos()
		local _parentN = parentFrm.handle._n
		
		--__clearPassiveTactic(parentFrm)
		local psNum = -1
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			
			--跳到顶部展示小图标才会增加数量
			if bAddtoTop then
				passiveSkillNum = passiveSkillNum + 1
				psNum = passiveSkillNum
			end
			
			--local n = passiveSkillNum
			
			local tacticFlag = 0
			local id, lv, flag = tacticId, tacticLv, tacticFlag
			local tabT = hVar.tab_tactics[id]
			local icon = tabT.icon
			local negative = tabT.negative --是否负面效果
			local quality = tabT.quality --品质（颜色）
			
			--pad的尺寸
			local x = offsetX + stateW * (passiveSkillNum - 1)
			local y = hVar.SCREEN.h + offsetY
			
			--if flag then
			--	myTacticNum = myTacticNum + 1
			--	x = offsetX + stateW * (myTacticNum - 1)
			--	y = hVar.SCREEN.h + offsetY + 5
			--else
			--	mapTacticNum = mapTacticNum + 1
			--	x = offsetX + stateW * (mapTacticNum - 1)
			--	y = hVar.SCREEN.h + offsetY * 2 - 5
			--end
			
			--被动战术技能卡图标
			parentFrm.childUI["imgPassiveTactics_"..psNum] = hUI.button:new({
				parent = parentFrm,
				model = icon,
				x = x,
				y = y,
				scale = 0.5,
				dragbox = 0,
				failcall = 1,
				
				--geyachao: 按下战术技能卡事件，绘制该战术技能卡的说明
				codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
					local __parent = parentFrm.childUI["imgPassiveTactics_" .. psNum]
					
					--防止弹框
					if (__parent == nil) then
						return
					end
					
					local __parentHandle = __parent.handle._n
					local offset = 215
					local yOffset = -75
					
					--选中框
					__parent.childUI["box"] = hUI.image:new({
						parent = __parentHandle,
						model = "UI:BTN_SkillSelector",
						x = 0,
						y = 0,
						w = stateW,
						h = stateW,
						align = "MC",
					})
					
					--技能背景框
					__parent.childUI["imgBg"] = hUI.button:new({
						parent = __parentHandle,
						model = "misc/mask.png", --"UI:ExpBG",
						x = offset,
						y = yOffset,
						w = 460, --236
						h = 100, --146
						align = "MC",
					})
					__parent.childUI["imgBg"].handle.s:setOpacity(0) --只挂载子控件，不显示
					local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 460, 100, __parent.childUI["imgBg"])
					--img9:setOpacity(128)
					
					__parent.childUI["imgBga"] = hUI.image:new({
						parent = __parentHandle,
						model = "misc/mask_16.png", --"UI:ExpBG",
						x = offset,
						y = yOffset,
						w = 460, --236
						h = 100, --146
						align = "MC",
					})
					--__parent.childUI["imgBg"].handle.s:setOpacity(96)
					
					if (not negative) then
						--frmBg.childUI["imgBga" .. i].handle._n:setColor(ccc3(112, 170, 57))
						--__parent.childUI["imgBg"].handle.s:setOpacity(128)
						img9:setOpacity(128)
						__parent.childUI["imgBga"].handle._n:setColor(ccc3(20,80,180))
					else
						--__parent.childUI["imgBg"].handle.s:setOpacity(150)
						img9:setOpacity(150)
						__parent.childUI["imgBga"].handle._n:setColor(ccc3(255,0,0))
					
					end
					
					--图标
					__parent.childUI["imgIcon"] = hUI.image:new({
						parent = __parentHandle,
						model = icon,
						x = offset - 180,
						y = yOffset - 2,
						w = 75,
						h = 75,
						align = "MC",
					})
					
					--技能名称
					local name = hVar.tab_stringT[id] and hVar.tab_stringT[id][1] or ("未知技能" .. id)
					local fontSize = 28
					if (#name >= 22) then --文字太长，字体缩小一点
						fontSize = 26
					end
					__parent.childUI["labName"] = hUI.label:new({
						parent = __parentHandle,
						size = fontSize,
						align = "LT",
						border = 1,
						x = offset - 135,
						y = yOffset + 44,
						--font = hVar.FONTC,
						font = hVar.FONTC,
						width = 210,
						text = name,
					})
					__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 0))
					
					
					--技能等级
					local lvOffsetX = offset - 48 + #name * 9
					__parent.childUI["labLevel"] = hUI.label:new({
						parent = __parentHandle,
						size = 24,
						align = "RT",
						border = 1,
						x = lvOffsetX,
						y = yOffset + 44 - 3,
						--font = hVar.FONTC,
						font = hVar.FONTC,
						width = 210,
						--text = "等级" .. lv, --language
						text = hVar.tab_string["__Attr_Hint_Lev"] .. lv, --language
					})
					__parent.childUI["labLevel"].handle.s:setColor(ccc3(255, 255, 128))
					
					
					--技能描述
					local fontSize = 26
					local intro = hVar.tab_stringT[id] and hVar.tab_stringT[id][(lv or 0) + 1] or ("未知技能说明" .. id)
					--print(#intro)
					if (#intro >= 96) then --文字太长，字体缩小一点
						fontSize = 17
					elseif (#intro > 78) then --文字太长，字体缩小一点
						fontSize = 20
					elseif (#intro > 69) then --文字太长，字体缩小一点
						fontSize = 22
					elseif (#intro > 60) then
						fontSize = 24
					end
					__parent.childUI["labIntro"] = hUI.label:new({
						parent = __parentHandle,
						size = fontSize,
						align = "LT",
						border = 1,
						x = offset - 133,
						y = yOffset + 12,
						font = hVar.FONTC,
						width = 360,
						text = intro,
					})
				end,
				
				--geyachao: 抬起战术技能卡事件，删除该战术技能卡的说明
				code = function(self)
					local __parent = parentFrm.childUI["imgPassiveTactics_" .. psNum]
					
					--防止弹框
					if (__parent == nil) then
						return
					end
					
					hApi.safeRemoveT(__parent.childUI, "box") --选中框
					hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
					hApi.safeRemoveT(__parent.childUI, "imgBga") --技能背景框
					hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
					hApi.safeRemoveT(__parent.childUI, "labName") --技能名称
					hApi.safeRemoveT(__parent.childUI, "labLevel") --技能等级
					hApi.safeRemoveT(__parent.childUI, "labIntro") --技能描述
				end,
			})
			
			parentFrm.childUI["imgPassiveTactics_"..psNum].handle._n:setVisible(false)
			
			--绘制弹出面板
			local offset = 0
			local offset1 = 22
			local xOffset = 0.5
			local yOffset = 0.5
			local w = 203
			local h = 200
			
			--清除上过一次的
			hApi.safeRemoveT(parentFrm.childUI, "imgPassivePopFrmBg" .. playerPos)
			
			--父空间
			local imgPassivePopFrmBgX = hVar.SCREEN.w * 0.5
			local imgPassivePopFrmBgY = hVar.SCREEN.h * 0.5
			if (oWorld:GetPlayerMe() ~= oPlayer) then --队友
				imgPassivePopFrmBgX = iPhoneX_WIDTH + 120
			end
			parentFrm.childUI["imgPassivePopFrmBg" .. playerPos] = hUI.button:new({ --作为button是为了挂子控件
				parent = _parentN,
				model = -1,
				x = imgPassivePopFrmBgX,
				y = imgPassivePopFrmBgY,
			})
			local frmBg = parentFrm.childUI["imgPassivePopFrmBg" .. playerPos]
			frmBg.handle._n:setVisible(false)
			
			--依次绘制被动战术卡图标
			--local id, lv, flag = passiveSkillTactic[i][1], passiveSkillTactic[i][2], passiveSkillTactic[i][3]
			--local tabT = hVar.tab_tactics[id]
			--local icon = tabT.icon
			--local negative = tabT.negative --是否负面效果
			
			--local kkk = math.floor((passiveSkillNum - 1) / 5) + 1
			--local tmp = math.mod(i, kkk)
			--if tmp == 0 then
			--	tmp = kkk
			--end
			--local abc = math.floor((i - 1) / 5) + 1
			
			local i = passiveSkillNum
			local xMax = passiveSkillNum
			if xMax > 5 then
				xMax = 5
			end
			if xMax < 1 then
				xMax = 1
			end
			local xi = xMax - math.mod(i, xMax) + 1
			if xi == xMax + 1 then
				xi = 1
			end
			
			local yi = math.floor((i - 1) / 5) + 1
			local yMax = math.floor((passiveSkillNum - 1) / 5) + 1
			
			--[[
			--技能背景框
			frmBg.childUI["imgBg" .. i] = hUI.button:new({
				parent = frmBg.handle._n,
				model = "misc/mask.png", --"UI:ExpBG",
				x = offset + 0,
				y = offset1 + 0,
				w = 200, --236
				h = 190, --146
				align = "MC",
			})
			frmBg.childUI["imgBg" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 200, 190, frmBg.childUI["imgBg" .. i])
			--img9:setOpacity(128)
			]]
			
			--技能背景框
			frmBg.childUI["imgBga" .. i] = hUI.button:new({ --作为按钮只是为了挂子控件
				parent = frmBg.handle._n,
				model = -1,
				--model = "misc/mask_white.png", --"UI:ExpBG",
				x = offset + 0,
				y = offset1 + 0,
				w = 200, --236
				h = 190, --146
				align = "MC",
			})
			--frmBg.childUI["imgBg" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--九宫格
			local strModel = ""
			if (quality == hVar.ITEM_QUALITY.WHITE) then
				strModel = "data/image/ui/tactic_card_color1.png"
			elseif (quality == hVar.ITEM_QUALITY.BLUE) then
				strModel = "data/image/ui/tactic_card_color2.png"
			elseif (quality == hVar.ITEM_QUALITY.GOLD) then
				strModel = "data/image/ui/tactic_card_color3.png"
			elseif (quality == hVar.ITEM_QUALITY.RED) then
				strModel = "data/image/ui/tactic_card_color4.png"
			else
				strModel = "data/image/ui/tactic_card_color5.png"
			end
			local s9 = hApi.CCScale9SpriteCreateWithSpriteFrameName(strModel, 0, 0, 200, 190, frmBg.childUI["imgBga" .. i])
			--s9:setOpacity(192)
			s9:setOpacity(128)
			
			--图标
			frmBg.childUI["imgIcon" .. i] = hUI.image:new({
				parent = frmBg.handle._n,
				model = icon,
				x = offset + 0 - 65,
				y = offset1 + 0 + 50,
				w = 56,
				h = 56,
				align = "MC",
			})
			
			--geyachao: 战车不要显示敌方战术卡的等级
			--[[
			--小圈圈描绘战术卡等级
			--战术卡等级背景图
			frmBg.childUI["imgIconLvBG" .. i] = hUI.image:new({
				parent = frmBg.handle._n,
				model = "ui/pvp/pvpselect.png",
				x = offset + 0 - 65 + 24,
				y = offset1 + 0 + 50 + 22,
				w = 28,
				h = 28,
			})
			
			--战术卡的技能等级
			local fontSize = 20
			if lv and (lv >= 10) then --如果等级是2位数的，那么缩一下文字
				fontSize = 14
			end
			frmBg.childUI["imgIconLv" .. i] = hUI.label:new({
				parent = frmBg.handle._n,
				x = offset + 0 - 65 + 24,
				y = offset1 + 0 + 50 + 22 - 1,
				text = lv,
				size = fontSize,
				font = "numWhite",
				align = "MC",
				width = 200,
			})
			]]
			
			--技能名称
			local name = hVar.tab_stringT[id] and hVar.tab_stringT[id][1] or ("未知技能" .. id)
			local fontNameSize = 30
			if (#name >= 12) then --名字太长，那么缩一下文字
				fontNameSize = 28
			end
			frmBg.childUI["labName" .. i] = hUI.label:new({
				parent = frmBg.handle._n,
				size = fontNameSize,
				align = "LT",
				border = 1,
				x = offset + 0 - 20,
				y = offset1 + 0 + 80,
				--font = hVar.FONTC,
				font = hVar.FONTC,
				width = 120,
				text = name,
			})
			frmBg.childUI["labName" .. i].handle.s:setColor(ccc3(255, 255, 0))
			
			--技能描述
			local fontSize = 26
			local intro = hVar.tab_stringT[id] and hVar.tab_stringT[id][(lv or 0) + 1] or ("未知技能说明" .. id)
			--print(#intro)
			if (#intro >= 96) then --文字太长，字体缩小一点
				fontSize = 17
			elseif (#intro > 78) then --文字太长，字体缩小一点
				fontSize = 20
			elseif (#intro > 69) then --文字太长，字体缩小一点
				fontSize = 22
			elseif (#intro > 60) then
				fontSize = 24
			end
			frmBg.childUI["labIntro" .. i] = hUI.label:new({
				parent = frmBg.handle._n,
				size = fontSize,
				align = "LT",
				border = 1,
				x = offset + 0 - 90,
				y = offset1 + 0 + 14,
				font = hVar.FONTC,
				width = 190,
				text = intro,
			})
			
			--位置测试
			--frmBg.childUI["imgBgTestPos" .. i] = hUI.image:new({
			--	parent = frmBg.handle._n,
			--	model = "UI:TacticBG", --"UI:ExpBG",
			--	x = offset + 0,
			--	y = offset1 + 0,
			--	w = 10, --236
			--	h = 10, --146
			--	align = "MC",
			--})
			
		end
		
		local passiveTacticInfoActionEnd2 = function()
			if parentFrm.childUI["imgPassivePopFrmBg" .. playerPos] then
				parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:setVisible(false)
				hApi.safeRemoveT(parentFrm.childUI, "imgPassivePopFrmBg" .. playerPos)
			end
			--跳到顶部展示小图标才会显示
			if bAddtoTop then
				if parentFrm.childUI["imgPassiveTactics_"..psNum] then
					parentFrm.childUI["imgPassiveTactics_"..psNum].handle._n:setVisible(true)
				end
			else
				if parentFrm.childUI["imgPassiveTactics_"..psNum] then
					parentFrm.childUI["imgPassiveTactics_"..psNum].handle._n:setVisible(false)
					hApi.safeRemoveT(parentFrm.childUI, "imgPassiveTactics_"..psNum)
				end
			end
			
		end
		
		local passiveTacticInfoActionEnd1 = function()
			if parentFrm.childUI["imgPassivePopFrmBg" .. playerPos] then
				local a = CCJumpBy:create(0.2,ccp(0,0),-6,1)
				local aR = a:reverse()
				local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
				parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:runAction(seq)
			end
			hApi.addTimerOnce("passiveTacticInfoAction1" .. playerPos,3000,function()
				if parentFrm.childUI["imgPassivePopFrmBg" .. playerPos] then
					local time = 0.3
					parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:runAction(CCScaleTo:create(time,0.1))	--缩放
					local x = offsetX + stateW * (passiveSkillNum * 1.0) - 30 --单个的额外偏移
					local y = hVar.SCREEN.h + offsetY
					parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(time,ccp(x, y)),CCCallFunc:create(passiveTacticInfoActionEnd2)))
				end
			end)
		end
		
		--被动战术技能卡在屏幕上闪一段时间后，飞到屏幕左上角
		hApi.addTimerOnce("passiveTacticInfoAction1" .. playerPos, 200, function()
			if parentFrm.childUI["imgPassivePopFrmBg" .. playerPos] then
				parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:runAction(CCFadeIn:create(0.1))		--淡入
				parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.1,1),CCCallFunc:create(passiveTacticInfoActionEnd1)))
				parentFrm.childUI["imgPassivePopFrmBg" .. playerPos].handle._n:setVisible(true)
			end
		end)
	end
	
	--创建父容器
	hGlobal.UI.TDSystemMenuBar = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		z = -1,
		show = 0,
		dragable = 2,
		buttononly = 1,
		autoactive = 0,
		border = 0,
	})
	_frm = hGlobal.UI.TDSystemMenuBar
	local _parent = _frm.handle._n
	
	-------------------------------------------------------------------------
	
	--创建顶部条
	_frm.childUI["TopBar"] = hUI.node:new({
		parent = _parent,
		--x = hVar.SCREEN.w - 480,
		--y = hVar.SCREEN.h - 50,
		x = 5,
		y = hVar.SCREEN.h - 25,
		z = -1,
	})
	_topBar = _frm.childUI["TopBar"]
	--顶部条控件
	--local labLife, barLife = __createUILife(_topBar) --剩余生命
	local labLife = __createUILife(_topBar) --剩余生命
	--local labMana, barMana = __createUIMana(_topBar) --剩余魔法
	local labGold = __createUIGold2(_topBar) --金钱
	--local labCrystal = __createUICrystal(_topBar) --水晶
	local labMana = __createUIMana(_topBar) --波次
	local labLayer = __createUILayer(_topBar)
	_createUIBag(_frm)
	--local labScore = __createUIScore(_topBar) --游戏得分

	local _nCloseBtnX = hVar.SCREEN.w - hVar.SCREEN.offx - 60				--关闭按钮X坐标
	local _nCloseBtnY = -40

	if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
		_nCloseBtnX = hVar.SCREEN.w - 60
		_nCloseBtnY = - 88
	end
	--if (g_phone_mode == 4) then
		--_nCloseBtnX = 120
	--elseif (g_phone_mode == 0) then
		--_nCloseBtnX = 80
	--elseif (g_phone_mode == 2) then
		--_nCloseBtnX = 100
	--end
	
	--[[
	--pvp的游戏时间
	_frm.childUI["PVP_GameTime"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2,
		y = hVar.SCREEN.h - 27,
		text = "",
		size = 26,
		font = "numWhite",
		align = "MC",
	})
	
	--pvp的网络延时前缀
	_frm.childUI["PVP_PingPrefixLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w - 200,
		y = hVar.SCREEN.h - 27,
		text = "",
		size = 22,
		font = hVar.FONTC,
		border = 1,
		align = "RC",
	})
	
	--pvp的网络延时
	_frm.childUI["PVP_PingLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w - 200 + 5,
		y = hVar.SCREEN.h - 27 - 1, --数字字体有1像素偏差
		text = "",
		size = 18,
		font = "numWhite",
		align = "LC",
	})
	]]
	
	--低配模式提示
	_frm.childUI["LowConfigModeLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2,
		y = hVar.SCREEN.h - 24,
		text = "",
		size = 22,
		font = hVar.FONTC,
		align = "MC",
		RGB = {0, 255, 0,},
	})
	
	--[[
	--无尽地图的得分前缀
	_frm.childUI["Endless_ScorePrefixLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 + 10000, --大菠萝不显示了
		y = hVar.SCREEN.h - 27,
		text = "",
		size = 26,
		font = hVar.FONTC,
		border = 1,
		align = "MC",
	})
	]]
	
	--[[
	--无尽地图的得分
	_frm.childUI["Endless_ScoreLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 + 10000, --大菠萝不显示了
		y = hVar.SCREEN.h - 27 - 1, --数字字体有1像素偏差
		text = "",
		size = 24,
		font = "numWhite",
		align = "MC",
	})
	_frm.childUI["Endless_ScoreLabel"].handle.s:setColor(ccc3(255, 255, 0))
	]]
	
	--小地图的BOSS出现图标背景图
	_frm.childUI["TINYBOSS_ScorePrefixImage"] = hUI.image:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 + 43,
		y = hVar.SCREEN.h - 50,
		model = "misc/addition/tinyboss_label.png",
		scale = 1.2,
		align = "MC",
	})
	_frm.childUI["TINYBOSS_ScorePrefixImage"].handle._n:setVisible(false) --默认隐藏
	
	--[[
	--小地图的BOSS出现图标背景图
	_frm.childUI["TINYBOSS_ScorePrefixCircle"] = hUI.image:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 - 41,
		y = hVar.SCREEN.h - 50,
		model = "misc/addition/tinyboss_circle.png",
		scale = 0.7,
		align = "MC",
	})
	]]
	
	--小地图的BOSS出现
	_frm.childUI["TINYBOSS_ScorePrefixBoss"] = hUI.image:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 - 39,
		y = hVar.SCREEN.h - 50,
		model = hVar.tab_unit[13030].icon,
		w = 64*0.8,
		h = 64*0.8,
		align = "MC",
	})
	_frm.childUI["TINYBOSS_ScorePrefixBoss"].handle._n:setVisible(false) --默认隐藏
	
	--小地图的BOSS出现倒计时
	_frm.childUI["TINYBOSS_ScorePrefixLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w/2 + 43,
		y = hVar.SCREEN.h - 46,
		text = "",
		size = 30,
		font = hVar.FONTC,
		border = 1,
		align = "MC",
	})
	
	--暂停
	_frm.childUI["StartPause"] = hUI.button:new({
		--__UI = "button",
		--__NAME = "StartPause",
		parent = _frm,
		model = "UI:td_mui_pause",
		x = hVar.SCREEN.w - 160,
		y = hVar.SCREEN.h - 30,
		scaleT = 0.9,
		dragbox = 0,
		code = function(self)
			__CODE_ClickStartPause()
		end,
	})
	_frm.childUI["StartPause"]:setstate(-1)
	
	--加速
	_frm.childUI["SpeedUp"] = hUI.button:new({
		--__UI = "button",
		--__NAME = "SpeedUp",
		parent = _frm,
		model = "UI:td_mui_speed1x",
		x = hVar.SCREEN.w - 130 - 2000, --大菠萝不显示
		y = hVar.SCREEN.h - 40,
		w = 70,
		h = 70,
		scaleT = 0.9,
		dragbox = 0,
		code = function(self)
			__CODE_ClickSpeedUpResume()
		end,
	})
	--print("加速按钮")
	
	--加速倍率
	_frm.childUI["SpeedUpLabel"] = hUI.label:new({
		parent = _frm.handle._n,
		x = hVar.SCREEN.w - 130,
		y = hVar.SCREEN.h - 80,
		text = "",
		size = 20,
		font = "numWhite",
		align = "MC",
	})
	
	--[[
	--大菠萝
	--背包按钮
	_frm.childUI["PackageBtn"] = hUI.button:new({
		--__UI = "button",
		--__NAME = "StartPause",
		parent = _frm,
		model = "UI:mainmenu_slot",
		x = 52,
		y = 52,
		scaleT = 0.95,
		dragbox = 0,
		w = 108,
		h = 108,
		code = function(self)
			--有可能英雄界面被删除了
			if not hGlobal.UI.HeroCardNewFrm then
				hGlobal.UI.InitHeroCardNewFrm()
			end
			hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, 6000, 0)
		end,
	})
	_frm.childUI["PackageBtn"].childUI["icon"] = hUI.image:new({
		parent = _frm.childUI["PackageBtn"].handle._n,
		model = "UI:Activity_Box",
		x = 0,
		y = 0,
		w = 64,
		h = 64,
	})
	]]
	
	--挡操作的
	--_frm.childUI["btnTacticsMask_BG"] = hUI.button:new({  
		--parent = parentFrm,
		--x = hVar.SCREEN.w * 3 / 4,
		--y = hVar.SCREEN.h / 2,
		--z = -1,
		--dragbox = _frm.childUI["dragBox"],
		----model = activeSkillIcon,
		----model = "misc/mask.png",
		--model = -1,
		--scaleT = 0.99, --按下的缩放值
		----scale = scale,
		--w = hVar.SCREEN.w / 2,
		--h = hVar.SCREEN.h,
		--code = function()
			----print("点击了背景")
		--end,
	--})
	
	--游戏内齿轮
	--_frm.childUI["SpeedUp"]:setstate(-1)
	_frm.childUI["SysMenu"] = hUI.button:new({
		parent = _frm,
		model = "misc/setting.png", --"ui/set.png",
		--x = hVar.SCREEN.w - iPhoneX_WIDTH - 60,
		--y = hVar.SCREEN.h - 40,
		x = _nCloseBtnX,
		y = hVar.SCREEN.h + _nCloseBtnY,
		w = 64,
		h = 64,
		scaleT = 0.95,
		--scale = 1.0,
		code = function()
			----地图胜利/失败的状态下点不到这些按钮
			--local w = hGlobal.WORLD.LastWorldMap
			--
			--local mapInfo = w.data.tdMapInfo
			----游戏结束点不到按钮
			--if mapInfo and mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
			--	return
			--end
			--
			--if hGlobal.UI.SystemMenuNewFram then
			--	hGlobal.event:event("localEvent_ShowNewSysFrm")
			--end
			
			--__CODE_ClickStartPause()
			local w = hGlobal.WORLD.LastWorldMap
			if w then
				if (w.data.keypadEnabled == true) then --允许响应事件
					local mapInfo = w.data.tdMapInfo
					if mapInfo then
						--游戏已结束，此时需要等待2秒，不能点齿轮
						if (mapInfo.mapState > hVar.MAP_TD_STATE.PAUSE) then
							--
						else
							if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
								hGlobal.event:event("LocalEvent_ShowSystemMenuIntegrateFrm")
							else
								if (w.data.IsPaused == 1) then --暂停状态不能点投降
									return
								else
									--pvp创建玩家投降的对话框
									hApi.ShowPlayerTouXiangFrm()
								end
							end
						end
					end
				end
			end
		end,
	})

	_frm.childUI["Comment"] = hUI.button:new({
		parent = _frm,
		model = "misc/addition/commentbtn.png",
		x = _nCloseBtnX,
		y = hVar.SCREEN.h + _nCloseBtnY - 76,
		scale = 0.7,
		scaleT = 0.95,
		code = function()
			hGlobal.event:event("Event_StartPauseSwitch", true)
			hGlobal.event:event("LocalEvent_SetCommentShieldBoardEnable",true)
			hGlobal.event:event("LocalEvent_DoCommentProcess")
		end,
	})
	_frm.childUI["Comment"]:setstate(-1)
	
	-------------------------------------------------------
	--聊天按钮
	--if (g_OBSwitch and g_OBSwitch.openChat == 1) or g_lua_src == 1 then
	if false then --战斗界面中暂时不生效，聊天按钮
		local iPhoneX_WIDTH_NEW = 0
		local iPhoneX_HEIGHT_NEW = 0
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			iPhoneX_WIDTH_NEW = 0
			if (g_phone_mode == 4) then
				iPhoneX_HEIGHT_NEW = 80
			end
			
		elseif hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			if (g_phone_mode == 4) then
				iPhoneX_WIDTH_NEW = 80
			end
			iPhoneX_HEIGHT_NEW = 0
		end
	
		_frm.childUI["chatBtn"] = hUI.button:new({
			parent = _frm,
			model = "misc/mask.png", --ui/set.png",
			--x = 50,
			--y = -20,
			x = iPhoneX_WIDTH_NEW + 50, --	+ hVar.SCREEN.offx
			y = iPhoneX_HEIGHT_NEW + 50,
			scaleT = 0.95,
			dragbox = _frm.childUI["dragBox"],
			w = 100,
			h = 100,
			z = 10,
			--failcall = 1,
			code = function(self, touchX, touchY, sus)
				--geyachao: 触发引导事件：点到了设置按钮
				--hGlobal.event:event("LocalEvent_Click_Guide_SettingButton")
				
				if (hGlobal.UI.Phone_MyHeroCardFrm_New ~= nil) and 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then					--如果“我的英雄令”界面正在打开则直接返回		added by pangyong 2015/4/21
					return
				end
				
				--没有账号，不能进入设置
				if (g_curPlayerName == nil) then
					return
				end
				
				--打开聊天界面（主界面）
				local tCallback = {
					bEnableBattleInvite = true, --是否允许聊天直接加入房间
					strDisableBattleInviteString = "", --不允许聊天直接加入房间的提示文字
					
					--关闭回调事件
					OnCloseFunc = function()
						--
					end,
					
					--聊天直接加入房间回调事件
					OnBattleInviteEnterFunc = function()
						--
					end,
					
					--聊天直接加入房间返回回调事件
					OnBattleInviteReturnFunc = function()
						--主界面断开pvp服务器的连接
						--Pvp_Server:Close() --!!!! edit by mj 2022.11.15
						--Pvp_Server:Clear() --!!!! edit by mj 2022.11.15
					end,
					
					--聊天直接加入房间进入战斗回调事件
					OnBattleInviteBeginFunc = function()
						--
					end,
				}
				hGlobal.event:event("LocalEvent_Phone_ShowChatDialogue", nil, tCallback)
			end,
		})
		_frm.childUI["chatBtn"].handle.s:setOpacity(0) --只用于控制，不显示
		--聊天图片
		_frm.childUI["chatBtn"].childUI["image"] = hUI.image:new({
			parent = _frm.childUI["chatBtn"].handle._n,
			model = "misc/chat.png",	--"UI:CHAT_N",
			x = 0,
			y = 0,
			scale = 0.75,
		})
		--聊天按钮提示有新消息的叹号
		_frm.childUI["chatBtn"].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["chatBtn"].handle._n,
			model = "UI:TaskTanHao",
			x = 20,
			y = 28,
			z = 3,
			w = 36,
			h = 36,
		})
		local act1 = CCMoveBy:create(0.2, ccp(0, 5))
		local act2 = CCMoveBy:create(0.2, ccp(0, -5))
		local act3 = CCMoveBy:create(0.2, ccp(0, 5))
		local act4 = CCMoveBy:create(0.2, ccp(0, -5))
		local act5 = CCDelayTime:create(2.0)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		local sequence = CCSequence:create(a)
		_frm.childUI["chatBtn"].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frm.childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(false) --一开始不显示
	else
		if _frm.childUI["chatBtn"] then
			_frm.childUI["chatBtn"].handle._n:setVisible(false)
		end
	end

	--局部函数
	--geyachao: 刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	on_refresh_chatbtn_notice = function()
		local _frm = hGlobal.UI.TDSystemMenuBar
		
		--没创建新主界面，直接返回
		if (not _frm) then
			return
		end
		
		local childUI = _frm.childUI
		if not childUI then
			return
		end

		if (g_OBSwitch and g_OBSwitch.openChat == 1) or g_lua_src == 1 then --开启聊天控制
			if not childUI["chatBtn"] or not childUI["chatBtn"].childUI["NoteJianTou"] then
				return
			end

			----------------------------------------------------------------------------
			--检测聊天新消息提示叹号
			local noticeFlag = LuaGetChatWorldNoticeFlag(g_curPlayerName) or 0
			if (noticeFlag == 1) then
				childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(true)
			else
				childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(false)
			end
		end
	end

	on_refresh_chatbtn_notice()

	on_refresh_medal_state_ui = function()
		on_refresh_chatbtn_notice()
	end

	--聊天相关
	--监听收到聊天模块初始化事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__SysMenuChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
	--监听收到单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SysMenuChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
	--监听收到删除单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__SysMenuChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
	--监听收到增加单个私聊好友
	hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__SysMenuChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
	--监听收到删除单个私聊好友
	hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__SysMenuChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
	--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__SysMenuChatBtnNoticeRefresh__", on_refresh_medal_state_ui)
	-------------------------------------------------------

	--zhenkira pvpui pvp倒计时
	--_frm.childUI["gameLastTime"] = hUI.label:new({
	--	parent = _frm.handle._n,
	--	x = hVar.SCREEN.w * 0.5,
	--	y = hVar.SCREEN.h - 45,
	--	text = "",
	--	size = 36,
	--	font = "numRed",
	--	align = "MC",
	--})
	--_frm.childUI["gameLastTime"].handle._n:setVisible(false)
	
	--只在内网有效
	--if (IAPServerIP == g_lrc_Ip) then --内网
		--geyachao: 调试模式1：开/关 包围盒
		_frm.childUI["FLAG_OPEN_BOX"] = hUI.button:new({
			parent = _frm,
			model = "UI:td_sui_tactic_tTower",
			x = 230,
			y = hVar.SCREEN.h - 60,
			w = 24,
			h = 24,
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				hVar.OPTIONS.SHOW_BOX_FLAG = 1 - hVar.OPTIONS.SHOW_BOX_FLAG --geyachao: 是否显示包围盒子的开关
				
				--状态图标
				if (hVar.OPTIONS.SHOW_BOX_FLAG == 1) then --开
					_frm.childUI["FLAG_OPEN_BOX"].childUI["ok"].handle.s:setVisible(true)
					_frm.childUI["FLAG_OPEN_BOX"].childUI["close"].handle.s:setVisible(false)
				elseif (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then --关
					_frm.childUI["FLAG_OPEN_BOX"].childUI["ok"].handle.s:setVisible(false)
					_frm.childUI["FLAG_OPEN_BOX"].childUI["close"].handle.s:setVisible(true)
				end
			end,
		})
		_frm.childUI["FLAG_OPEN_BOX"]:setstate(-1) --默认不可用 --test
		--ok图片
		_frm.childUI["FLAG_OPEN_BOX"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_OPEN_BOX"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_OPEN_BOX"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_OPEN_BOX"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_OPEN_BOX"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_OPEN_BOX"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		
		--geyachao: 调试模式2：开/关 血条和伤害
		_frm.childUI["FLAG_HP_BAR"] = hUI.button:new({
			parent = _frm,
			model = "UI:ItemMergePageIcon",
			x = 270,
			y = hVar.SCREEN.h - 60,
			w = 32,
			h = 32,
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				hVar.OPTIONS.SHOW_HP_BAR_FLAG = 1 - hVar.OPTIONS.SHOW_HP_BAR_FLAG --geyachao: 是否显示血条伤害冒字的开关
				
				--状态图标
				if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --开
					_frm.childUI["FLAG_HP_BAR"].childUI["ok"].handle.s:setVisible(true)
					_frm.childUI["FLAG_HP_BAR"].childUI["close"].handle.s:setVisible(false)
				elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --关
					_frm.childUI["FLAG_HP_BAR"].childUI["ok"].handle.s:setVisible(false)
					_frm.childUI["FLAG_HP_BAR"].childUI["close"].handle.s:setVisible(true)
				end
			end,
		})
		_frm.childUI["FLAG_HP_BAR"]:setstate(-1) --默认不可用 --test
		--ok图片
		_frm.childUI["FLAG_HP_BAR"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_HP_BAR"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_HP_BAR"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_HP_BAR"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_HP_BAR"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_HP_BAR"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		
		--geyachao: 调试模式3：开/关 AI状态显示
		_frm.childUI["FLAG_AI_STATE"] = hUI.button:new({
			parent = _frm,
			model = "UI:td_sui_tactic_tskill",
			x = 310,
			y = hVar.SCREEN.h - 60,
			w = 24,
			h = 24,
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				hVar.OPTIONS.SHOW_AI_UI_FLAG = 1 - hVar.OPTIONS.SHOW_AI_UI_FLAG --geyachao: 是否显示AI状态文字的开关
				
				--状态图标
				if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then --开
					_frm.childUI["FLAG_AI_STATE"].childUI["ok"].handle.s:setVisible(true)
					_frm.childUI["FLAG_AI_STATE"].childUI["close"].handle.s:setVisible(false)
				elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --关
					_frm.childUI["FLAG_AI_STATE"].childUI["ok"].handle.s:setVisible(false)
					_frm.childUI["FLAG_AI_STATE"].childUI["close"].handle.s:setVisible(true)
				end
			end,
		})
		_frm.childUI["FLAG_AI_STATE"]:setstate(-1) --默认不可用 --test
		--ok图片
		_frm.childUI["FLAG_AI_STATE"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_AI_STATE"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_AI_STATE"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_AI_STATE"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_AI_STATE"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_AI_STATE"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		
		--看脚本内存的控件
		_frm.childUI["FLAG_MEMORY"] = hUI.button:new({
			parent = _frm,
			model = "UI:SoulStoneBarBg1",
			x = 490,
			y = hVar.SCREEN.h - 60,
			w = 114,
			h = 24,
		})
		_frm.childUI["FLAG_MEMORY"]:setstate(-1) --默认不可用 --test
		_frm.childUI["FLAG_MEMORY"].childUI["MemLabel"] = hUI.label:new({
			parent = _frm.childUI["FLAG_MEMORY"].handle._n,
			x = 0,
			y = 0,
			align = "MC",
			font = "numWhite",
			size = 22,
			width = 300,
			text = "0.0",
		})
		--geyachao: 调试模式4：开/关 看内存
		_frm.childUI["FLAG_DEBUG_INFO"] = hUI.button:new({
			parent = _frm,
			model = "UI:td_sui_tactic_num_bg",
			x = 350,
			y = hVar.SCREEN.h - 60,
			w = 24,
			h = 24,
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				hVar.OPTIONS.SHOW_DEBUG_INFO_FLAG = 1 - hVar.OPTIONS.SHOW_DEBUG_INFO_FLAG --geyachao: 是否显示看内存的开关
				
				--状态图标
				if (hVar.OPTIONS.SHOW_DEBUG_INFO_FLAG == 1) then --开
					xlShowFPS(1)
					xlUI_ShowMiniBar(1)
					_frm.childUI["FLAG_DEBUG_INFO"].childUI["ok"].handle.s:setVisible(true)
					_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"].handle.s:setVisible(false)
					
					--显示lua内存的
					_frm.childUI["FLAG_MEMORY"]:setstate(1) --可用
					hApi.addTimerForever("__ShowLuaMenTimer__", hVar.TIMER_MODE.GAMETIME, 1000, function()
						local vm = collectgarbage("count")
						local vmM = vm / 1000 --兆
						local showText = ("%d.%d"):format(math.floor(vmM), math.floor((vmM - math.floor(vmM)) * 10)) --保留1位小数
						_frm.childUI["FLAG_MEMORY"].childUI["MemLabel"]:setText(showText)
					end)
				elseif (hVar.OPTIONS.SHOW_DEBUG_INFO_FLAG == 0) then --关
					xlShowFPS(0)
					xlUI_ShowMiniBar(0)
					_frm.childUI["FLAG_DEBUG_INFO"].childUI["ok"].handle.s:setVisible(false)
					_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"].handle.s:setVisible(true)
					
					--关闭lua内存的
					_frm.childUI["FLAG_MEMORY"]:setstate(-1) --不可用
					hApi.clearTimer("__ShowLuaMenTimer__")
				end
			end,
		})
		_frm.childUI["FLAG_DEBUG_INFO"]:setstate(-1) --默认不可用 --test
		--ok图片
		_frm.childUI["FLAG_DEBUG_INFO"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_DEBUG_INFO"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_DEBUG_INFO"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_DEBUG_INFO"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		
		--看伤害和DPS的控件
		_frm.childUI["FLAG_DMG"] = hUI.button:new({
			parent = _frm,
			model = "UI:SoulStoneBarBg1",
			x = 660,
			y = hVar.SCREEN.h - 60 + 28,
			w = 200,
			h = 24,
		})
		_frm.childUI["FLAG_DMG"]:setstate(-1) --默认不可用 --test
		_frm.childUI["FLAG_DMG"].childUI["DmgLabelPrefix"] = hUI.label:new({
			parent = _frm.childUI["FLAG_DMG"].handle._n,
			x = -85,
			y = 0 + 1, --1像素偏差
			align = "LC",
			font = hVar.DEFAULT_FONT,
			size = 22,
			width = 300,
			text = "dmg:",
		})
		_frm.childUI["FLAG_DMG"].childUI["DmgLabel"] = hUI.label:new({
			parent = _frm.childUI["FLAG_DMG"].handle._n,
			x = 85,
			y = 0,
			align = "RC",
			font = "numWhite",
			size = 22,
			width = 300,
			text = "0",
		})
		_frm.childUI["FLAG_DMG"].childUI["DmgLabelPostfix"] = hUI.label:new({
			parent = _frm.childUI["FLAG_DMG"].handle._n,
			x = 85,
			y = 0 + 1, --1像素偏差
			align = "RC",
			font = hVar.DEFAULT_FONT,
			size = 22,
			width = 300,
			text = "",
		})
		_frm.childUI["FLAG_DPS"] = hUI.button:new({
			parent = _frm,
			model = "UI:SoulStoneBarBg1",
			x = 660,
			y = hVar.SCREEN.h - 60,
			w = 200,
			h = 24,
		})
		_frm.childUI["FLAG_DPS"]:setstate(-1) --默认不可用 --test
		_frm.childUI["FLAG_DPS"].childUI["DpsLabelPrefix"] = hUI.label:new({
			parent = _frm.childUI["FLAG_DPS"].handle._n,
			x = -85,
			y = 0 + 1, --1像素偏差
			align = "LC",
			font = hVar.DEFAULT_FONT,
			size = 22,
			width = 300,
			text = "dps:",
		})
		_frm.childUI["FLAG_DPS"].childUI["DpsLabel"] = hUI.label:new({
			parent = _frm.childUI["FLAG_DPS"].handle._n,
			x = 85,
			y = 0,
			align = "RC",
			font = "numWhite",
			size = 22,
			width = 300,
			text = "0",
		})
		--geyachao: 调试模式5：开/关 统计伤害和DPS
		_frm.childUI["FLAG_DMG_DPS"] = hUI.button:new({
			parent = _frm,
			model = "UI:td_sui_tactic_thero",
			x = 390,
			y = hVar.SCREEN.h - 60,
			w = 24,
			h = 24,
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				hVar.OPTIONS.SHOW_DMG_DPS_FLAG = 1 - hVar.OPTIONS.SHOW_DMG_DPS_FLAG --geyachao: 是否显示伤害和DPS的开关
				
				--状态图标
				if (hVar.OPTIONS.SHOW_DMG_DPS_FLAG == 1) then --开
					local w = hGlobal.WORLD.LastWorldMap
					local currenttime = w:gametime() --hApi.gametime() --当前时间
					w.data.statistics_dmg_sum = 0 --初始化统计总有效伤害
					w.data.statistics_dmg_lasttick = currenttime --初始化统计总有效伤害的上次时间
					
					_frm.childUI["FLAG_DMG_DPS"].childUI["ok"].handle.s:setVisible(true)
					_frm.childUI["FLAG_DMG_DPS"].childUI["close"].handle.s:setVisible(false)
					
					--显示伤害和dps
					_frm.childUI["FLAG_DMG"]:setstate(1) --可用
					_frm.childUI["FLAG_DPS"]:setstate(1) --可用
					--hApi.addTimerForever("__ShowDmgDpsTimer__", hVar.TIMER_MODE.GAMETIME, 1000, function()
					w:addtimer("__ShowDmgDpsTimer__", 2000, function()
						local w = hGlobal.WORLD.LastWorldMap
						if w then
							local statistics_dmg_sum = w.data.statistics_dmg_sum --始化统计总有效伤害
							local currenttime = w:gametime() --hApi.gametime() --当前时间
							local statistics_dmg_lasttick = w.data.statistics_dmg_lasttick --初始化统计总有效伤害的上次时间
							local deltatime = currenttime - statistics_dmg_lasttick
							local dps = statistics_dmg_sum / deltatime * 1000
							local showDmg = nil
							local showSign = nil
							--statistics_dmg_sum = 1000000 --测试 --test
							
							if (statistics_dmg_sum >= 100000000) then --1亿
								local value = math.floor(statistics_dmg_sum / 1000000) .. "  "
								showDmg = value --("%d.%d  "):format(math.floor(value), math.floor((value - math.floor(value)) * 100)) --保留0位小数
								showSign = "M"
							elseif (statistics_dmg_sum >= 1000000) then --1百万
								local value = math.floor(statistics_dmg_sum / 1000) .. "  "
								showDmg = value --("%d.%d  "):format(math.floor(value), math.floor((value - math.floor(value)) * 100)) --保留0位小数
								showSign = "K"
							else
								showDmg = statistics_dmg_sum
								showSign = ""
							end
							
							local showDps = ("%.2f"):format(dps) --保留1位小数
							_frm.childUI["FLAG_DMG"].childUI["DmgLabel"]:setText(showDmg)
							_frm.childUI["FLAG_DMG"].childUI["DmgLabelPostfix"]:setText(showSign)
							_frm.childUI["FLAG_DPS"].childUI["DpsLabel"]:setText(showDps)
						end
					end)
					
					--开启障碍
					if xlScene_HideBuildings then
						xlScene_HideBuildings(g_world, 1)
					end
					if xlScene_ShowBlock then
						xlScene_ShowBlock(g_world, 1)
					end
				elseif (hVar.OPTIONS.SHOW_DMG_DPS_FLAG == 0) then --关
					local w = hGlobal.WORLD.LastWorldMap
					w.data.statistics_dmg_sum = 0 --初始化统计总有效伤害
					w.data.statistics_dmg_lasttick = 0 --初始化统计总有效伤害的上次时间
					
					_frm.childUI["FLAG_DMG_DPS"].childUI["ok"].handle.s:setVisible(false)
					_frm.childUI["FLAG_DMG_DPS"].childUI["close"].handle.s:setVisible(true)
					
					--关闭伤害和dps
					_frm.childUI["FLAG_DMG"]:setstate(-1) --不可用
					_frm.childUI["FLAG_DPS"]:setstate(-1) --不可用
					--hApi.clearTimer("__ShowDmgDpsTimer__")
					w:removetimer("__ShowDmgDpsTimer__")
					
					--关闭障碍
					if xlScene_HideBuildings then
						xlScene_HideBuildings(g_world, 0)
					end
					if xlScene_ShowBlock then
						xlScene_ShowBlock(g_world, 0)
					end
				end
			end,
		})
		_frm.childUI["FLAG_DMG_DPS"]:setstate(-1) --默认不可用 --test
		--ok图片
		_frm.childUI["FLAG_DMG_DPS"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_DMG_DPS"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_DMG_DPS"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_DMG_DPS"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_DMG_DPS"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_DMG_DPS"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		
		--geyachao: 调试模式6：存档记录查看
		_frm.childUI["FLAG_SAVEDATA"] = hUI.button:new({
			parent = _frm,
			model = "misc/vip1.png",
			x = 80,
			y = 70,
			scaleT = 0.95,
			dragbox = 0,
			code = function(self)
				--显示存档日志
				hGlobal.event:event("LocalEvent_Phone_ShowSaveDataChangeInfoFrm")
			end,
		})
		_frm.childUI["FLAG_SAVEDATA"]:setstate(-1) --默认不可用 --test
		--星星1
		_frm.childUI["FLAG_SAVEDATA"].childUI["star1"] = hUI.image:new({
			parent = _frm.childUI["FLAG_SAVEDATA"].handle._n,
			model = "ICON:WeekStar",
			x = -11,
			y = 37,
			z = 100,
			w = 24,
			h = 24,
		})
		--星星2
		_frm.childUI["FLAG_SAVEDATA"].childUI["star2"] = hUI.image:new({
			parent = _frm.childUI["FLAG_SAVEDATA"].handle._n,
			model = "ICON:WeekStar",
			x = 11,
			y = 37,
			z = 100,
			w = 24,
			h = 24,
		})

		--wangcheng: 调试模式7 行为统计
		_frm.childUI["FLAG_BehaviorStatistics"] = hUI.button:new({
			parent = _frm,
			model = "misc/mask.png",
			x = 430,
			y = hVar.SCREEN.h - 60,
			w = 24,
			h = 24,
			label = "行",
			scaleT = 0.9,
			dragbox = 0,
			code = function(self)
				if BehaviorStatistics then
					if BehaviorStatistics.ShowTest == 0 then
						self.childUI["ok"].handle.s:setVisible(true)
						self.childUI["close"].handle.s:setVisible(false)
						BehaviorStatistics.ShowEditor()
					else
						self.childUI["ok"].handle.s:setVisible(false)
						self.childUI["close"].handle.s:setVisible(true)
						BehaviorStatistics.CloseEditor()
					end
				end
			end,
		})
		_frm.childUI["FLAG_BehaviorStatistics"]:setstate(-1)
		_frm.childUI["FLAG_BehaviorStatistics"].childUI["ok"] = hUI.image:new({
			parent = _frm.childUI["FLAG_BehaviorStatistics"].handle._n,
			model = "UI:ok",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_BehaviorStatistics"].childUI["ok"].handle.s:setVisible(false) --默认隐藏
		--叉叉图片
		_frm.childUI["FLAG_BehaviorStatistics"].childUI["close"] = hUI.image:new({
			parent = _frm.childUI["FLAG_BehaviorStatistics"].handle._n,
			model = "UI:close",
			x = 6,
			y = -6,
			align = "MC",
			scale = 0.3,
		})
		_frm.childUI["FLAG_BehaviorStatistics"].childUI["close"].handle.s:setVisible(false) --默认隐藏 --test
		-------------------------------------------------------------------------
		
		--打开Flag界面
		function OpenFlag()
			_frm.childUI["FLAG_OPEN_BOX"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_OPEN_BOX"].childUI["close"].handle.s:setVisible(true) --显示 --test
			_frm.childUI["FLAG_HP_BAR"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_HP_BAR"].childUI["close"].handle.s:setVisible(true) --显示 --test
			_frm.childUI["FLAG_AI_STATE"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_AI_STATE"].childUI["close"].handle.s:setVisible(true) --显示 --test
			_frm.childUI["FLAG_DEBUG_INFO"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"].handle.s:setVisible(true) --显示 --test
			_frm.childUI["FLAG_DMG_DPS"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_DMG_DPS"].childUI["close"].handle.s:setVisible(true) --显示 --test
			_frm.childUI["FLAG_SAVEDATA"]:setstate(1) --可用 --test
			_frm.childUI["FLAG_BehaviorStatistics"].childUI["close"].handle.s:setVisible(true)
			_frm.childUI["FLAG_BehaviorStatistics"]:setstate(1)
		end
		
		--关闭Flag界面
		function CloseFlag()
			_frm.childUI["FLAG_OPEN_BOX"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_OPEN_BOX"].childUI["close"].handle.s:setVisible(false) --不显示 --test
			_frm.childUI["FLAG_HP_BAR"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_HP_BAR"].childUI["close"].handle.s:setVisible(false) --不显示 --test
			_frm.childUI["FLAG_AI_STATE"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_AI_STATE"].childUI["close"].handle.s:setVisible(false) --不显示 --test
			_frm.childUI["FLAG_DEBUG_INFO"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_DEBUG_INFO"].childUI["close"].handle.s:setVisible(false) --不显示 --test
			_frm.childUI["FLAG_DMG_DPS"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_DMG_DPS"].childUI["close"].handle.s:setVisible(false) --不显示 --test
			_frm.childUI["FLAG_SAVEDATA"]:setstate(-1) --不可用 --test
			_frm.childUI["FLAG_BehaviorStatistics"].childUI["close"].handle.s:setVisible(false)
			_frm.childUI["FLAG_BehaviorStatistics"]:setstate(-1)
		end
		
		--关闭引导
		function CloseGuide()
			hVar.OPTIONS.IS_SHOW_GUIDE = 0
		end
	--end
	
	--创建底部条
	_frm.childUI["BottomBar"] = hUI.node:new({
		parent = _parent,
		x = 0,
		y = 0,
	})
	_bottomBar = _frm.childUI["BottomBar"]
	
	--下一波背景
	_frm.childUI["NextWaveBg"] = hUI.image:new({
		parent = _parent,
		--model = "UI:next_day",
		model = "UI:BeginBattleBgLight",
		x = hVar.SCREEN.w - 70,
		y = 102,
		z = 0,
		scale = 0.5,
		--color = {233,150,122},
	})
	local a = CCScaleBy:create(1.8,1.1,1.15)
	local aR = a:reverse()
	local seqA = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
	_frm.childUI["NextWaveBg"].handle._n:runAction(CCRepeatForever:create(seqA))
	
	--下一波进度条（游戏内）
	_frm.childUI["NextWaveProgress"] = hUI.timerbar:new({
		parent = _parent,
		--model = "UI:next_day",
		model = "UI:BeginBattleBg",
		x = hVar.SCREEN.w - 70,
		y = 100,
		z = 1,
		--alpha = 128,
		color = {0, 255, 0},
		scale = 0.1,
		callback = function()
			--isCountdown = false
		end,
	})
	
	--下一波按钮（游戏内）
	_frm.childUI["NextWave"] = hUI.button:new({
		--__UI = "button",
		--__NAME = "NextWave",
		parent = _frm,
		--model = "UI:next_day",
		model = "UI:BeginBattleBg",
		x = hVar.SCREEN.w - 70,
		y = 100,
		z = 2,
		scaleT = 0.98,
		scale = 0.6,
		code = function(self)
			--如果是pvp模式，不允许直接点击按钮
			local w = hGlobal.WORLD.LastWorldMap
			if w then
				local mapInfo = w.data.tdMapInfo
				if mapInfo and mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP then
					__CODE_ClickNextWave(true)
				end
			end
		end,
	})
	
	_frm.childUI["NextWave"].childUI["imgRed"] =  hUI.image:new({
		parent = _frm.childUI["NextWave"].handle._n,
		--model = "MODEL_EFFECT:Fire05",
		model = -1,
		x = -5,
		y = 30,
		z = 2,
		scale = 1.3,
		alpha = 128,
	})
	_frm.childUI["NextWave"].childUI["imgRed2"] =  hUI.image:new({
		parent = _frm.childUI["NextWave"].handle._n,
		--model = "MODEL_EFFECT:Fire05",
		model = -1,
		x = -5,
		y = 12,
		z = 2,
		scale = 1.5,
		alpha = 200,
	})
	
	--开战文字
	_frm.childUI["NextWave"].childUI["imgTxt"] =  hUI.image:new({
		parent = _frm.childUI["NextWave"].handle._n,
		model = "UI:BeginBattleTxt",
		x = 0,
		y = 0,
		z = 3,
		scale = 0.6,
	})
	
	--如果当前波次大于0，隐藏开战相关控件
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local wave = w.data.tdMapInfo.wave or 0
		if (wave > 0) then
			_frm.childUI["NextWaveBg"].handle._n:setVisible(false)
			_frm.childUI["NextWaveProgress"].handle._n:setVisible(false)
			_frm.childUI["NextWave"]:setstate(-1)
		end
	end
	
	--刷新波次的函数放在这里
	__updataWave = function(w, labMana)
		--local w = hGlobal.WORLD.LastWorldMap
		if w then
			local totalWave = w.data.tdMapInfo.totalWave or 0
			local wave = w.data.tdMapInfo.wave or 0
			--_frm.childUI["WaveNow"]:setText(wave)
			
			if (totalWave > 100) then --最大次太大，就不显示最大波次了
				labMana:setText(tostring(wave))
			else
				labMana:setText(tostring(wave) .. "/" .. tostring(totalWave))
			end
			
			--barMana:setV(wave,totalWave)
			
			local regionId = w.data.randommapIdx
			if (regionId > 0) then --随机迷宫模式，不显示波次
				local _frm = _frm
				if _frm then
					local _topBar = _frm.childUI["TopBar"]
					if _topBar then
						if _topBar.childUI["nodMana"] then
							_topBar.childUI["nodMana"].handle._n:setVisible(false)
						end
					end
				end
			else
				local _frm = _frm
				if _frm then
					local _topBar = _frm.childUI["TopBar"]
					if _topBar then
						if _topBar.childUI["nodMana"] then
							if (totalWave > 1) then
								_topBar.childUI["nodMana"].handle._n:setVisible(true)
							else
								--最高只有一波就不显示波次了
								_topBar.childUI["nodMana"].handle._n:setVisible(false)
							end
						end
					end
				end
			end
		end
	end
	
	--刷新生命的函数放在这里
	__updataLife = function(w, labLife, bNoAnim)
		--print("刷新生命的函数, __updataLife")
		--print(debug.traceback())
		--local w = hGlobal.WORLD.LastWorldMap
		if w then
			--local life = tostring(w.data.tdMapInfo.life or 0)
			local life = 0
			local me = w:GetPlayerMe()
			if me then
				local force = me:getforce()
				local forcePlayer = w:GetForce(force)
				if forcePlayer then
					life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE) or 0
				end
			end
			
			local totalLife = tostring(w.data.tdMapInfo.totalLife or 0)
			--labLife:setText(life .. "/" .. totalLife)
			labLife:setText(life)
			--barLife:setV(life,totalLife)
		end
	end
	
	--刷新金钱的函数放在这里
	__updateGold2 = function(w, labGold)
		local gold = 0
		local me = w:GetPlayerMe()
		if me then
			gold  = me:getresource(hVar.RESOURCE_TYPE.GOLD) or 0
		end
		
		labGold:setText(gold)
		
		hGlobal.event:event("LocalEvent_TD_GOLD_CHANGE")
	end
	
	--刷新水晶的函数放在这里
	__updataCrystal = function(w, labCrystal)
		if true then
			return
		end
		--local w = hGlobal.WORLD.LastWorldMap
		if w then
			if w.data.map == hVar.MainBase then
				labCrystal:setText(LuaGetPlayerScore())
			else
				--[[
				local scoreingame = 0
				local score = GameManager.GetGameInfo("scoreingame")
				if type(score) == "number" then
					scoreingame = score
				end
				labCrystal:setText(scoreingame)
				]]
				local gold = 0
				local me = w:GetPlayerMe()
				if me then
					gold  = me:getresource(hVar.RESOURCE_TYPE.GOLD) or 0
				end
				
				labCrystal:setText(gold)
				
				hGlobal.event:event("LocalEvent_TD_GOLD_CHANGE")
			end
		end
	end
	
	--刷新随机地图当前层数
	__updataLayer = function(w, labLayer)
		if w then
			local text = ""
			print("__updataLayer",w.data.randommapStage,w.data.randommapIdx)
			if w.data.randommapStage and w.data.randommapStage > 0 then
				text = tostring(w.data.randommapStage).. " - ".. tostring(w.data.randommapIdx)
			end
			labLayer:setText(text)
		end
	end
	
	--点击速度加速-恢复
	__CODE_ClickSpeedUpResume = function()
		
		--_childUI["soundenable"]:loadsprite("UI:horn_open")
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local mapInfo = w.data.tdMapInfo
			if mapInfo and mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP then
				if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then
					return
				end
				
				--每按一次，加倍速度x2（超过最大速度，为1倍速度）
				nSpeedUpRate = nSpeedUpRate * 2
				if (nSpeedUpRate > hVar.OPTIONS.MAX_GAME_SPEED) then --游戏最大加速倍率
					nSpeedUpRate = 1
				end
				
				if (nSpeedUpRate > 1) then --加速
					_frm.childUI["SpeedUp"]:loadsprite("UI:td_mui_speed2x")
					w:speedUp(true)
					--nSpeedUpRate = true
					_frm.childUI["SpeedUpLabel"]:setText("x" .. nSpeedUpRate)
				else --不加速
					_frm.childUI["SpeedUp"]:loadsprite("UI:td_mui_speed1x")
					w:speedUp(false)
					--nSpeedUpRate = false
					_frm.childUI["SpeedUpLabel"]:setText("")
				end
			end
		end
	end
	
	--点击开始暂停
	__CODE_ClickStartPause = function()
		--print("点击开始暂停")
		--如果是加速状态，则设置按钮状态为未加速
		if (nSpeedUpRate > 1) then
			_frm.childUI["SpeedUp"]:loadsprite("UI:td_mui_speed1x")
		end
		
		--_childUI["soundenable"]:loadsprite("UI:horn_open")
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local mapInfo = w.data.tdMapInfo
			if mapInfo and mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP then
				if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
					_frm.childUI["StartPause"]:loadsprite("UI:td_mui_pause")
					w:pause(0)
					mapInfo.mapState = mapInfo.mapLastState
					mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				else
					_frm.childUI["StartPause"]:loadsprite("UI:horn_close")
					w:pause(1, "TD_PAUSE")
					mapInfo.mapLastState = mapInfo.mapState
					mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
					--按暂停时将加速状态设置成初始状态
					_frm.childUI["SpeedUp"]:loadsprite("UI:td_mui_speed1x")
					nSpeedUpRate = 1
					_frm.childUI["SpeedUpLabel"]:setText("")
				end
			end
		end
	end
	
	--点击下一波
	__CODE_ClickNextWave = function(flag)
		--print("点击下一波", flag, debug.traceback())
		local w = hGlobal.WORLD.LastWorldMap
		--地图胜利/失败的状态下点不到这些按钮
		if w then
			local mapInfo = w.data.tdMapInfo
			if mapInfo then
				--print("mapInfo.mapState", mapInfo.mapState,hVar.MAP_TD_STATE.PAUSE)
				if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
					return
				end
				
				local totalWave = mapInfo.totalWave
				local wave = mapInfo.wave
				--print("wave", wave,totalWave)
				
				--geyachao: 切换地图也走进来？报错。。。
				if (totalWave == nil) then
					return
				end
				
				if (totalWave > 100) then --最大次太大，就不增加波次了
					return
				end
				
				if (wave < totalWave) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then
					
					--波次累加
					mapInfo.wave = mapInfo.wave + 1
					
					
					local timeNow = w:gametime()
					--计算下一波出兵的时间,第一波本身是立即发兵。时间累加留给下一帧进行。下一帧累加时间时不自动触发nextwave
					if wave >= 1 then
						
						--如果提前点击了按钮，则触发提前点击下一波事件
						if flag then
							local timeEarly = (mapInfo.nextBeginTime - timeNow)
							if timeEarly > 0 then
								if timeEarly > mapInfo.nextwaveBtnAppearDelay then
									timeEarly = mapInfo.nextwaveBtnAppearDelay
								end
								hGlobal.event:event("Event_ClickNextWaveButtonInAdvance", timeEarly)
							end
							
						end
						
						local beginTimeDelay = mapInfo.beginTimeDelayPerWave or {}
						mapInfo.nextBeginTime = timeNow + (beginTimeDelay[mapInfo.wave + 1] or 0)
					end
					--print("______________________CODE_ClickNextWave["..(wave).."]:".. tostring(mapInfo.nextBeginTime)..",".. tostring(hApi.gametime()))
					
					__updataWave(w, labMana)
					
					--回合更新刷新金钱
					if mapInfo.goldPerWave and mapInfo.goldPerWave[mapInfo.wave] then
						--mapInfo.gold = (mapInfo.gold or 0) + mapInfo.GetGoldPerWaveNow()
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, mapInfo.GetGoldPerWaveNow())
						--所有玩家加钱
						--w:AddAllPlayerResource(hVar.RESOURCE_TYPE.GOLD, mapInfo.GetGoldPerWaveNow())
						--me:addresource(hVar.RESOURCE_TYPE.GOLD, mapInfo.GetGoldPerWaveNow())
						w:AddAllPlayerGoldWave()
					end
					__updateGold2(w, labGold)
					__updataCrystal(w, labCrystal)
					
					
					_frm.childUI["NextWaveBg"].handle._n:setVisible(false)
					_frm.childUI["NextWaveProgress"].handle._n:setVisible(false)
					_frm.childUI["NextWave"]:setstate(-1)
					isCountdown = false
					
					--判断关卡是否通过关
					local isFinish = LuaGetPlayerMapAchi(w.data.map, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
					if isFinish == 0 then
						hGlobal.event:event("LocalEvent_showMonsterInfoFrm")
					end
					
					--geyachao: 波次改变特殊处理函数
					if OnGameWaveChanged_Special_Event then
						--安全执行
						hpcall(OnGameWaveChanged_Special_Event, mapInfo.wave)
						--OnGameWaveChanged_Special_Event(mapInfo.wave)
					end
				else
					_frm.childUI["NextWave"]:setstate(-1)
					--mapInfo.mapState = hVar.MAP_TD_STATE.SENDARMYEND
				end
			end
		end
	end
	
	--敌兵到达
	__CODE_UnitReached = function(unit)
		local w = hGlobal.WORLD.LastWorldMap
		--地图胜利/失败的状态下点不到这些按钮
		if w then
			local mapInfo = w.data.tdMapInfo
			--mapInfo存在，并且地图模式是普通模式或挑战难度模式
			if mapInfo then
				if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
					return
				end
				
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL or mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
				
					local owner = unit:getowner()
					local me = w:GetPlayerMe()
					if owner then
						if me and owner:getforce() ~= me:getforce() then
							local force = me:getforce()
							local forcePlayer = w:GetForce(force)
							if forcePlayer then
								local life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE)
								if (life > 0) then
									local costLife = unit:GetEscapePunish() --漏怪惩罚扣除的点数
									if (costLife < 0) then
										costLife = 0
									end
									forcePlayer:addresource(hVar.RESOURCE_TYPE.LIFE, -costLife)
									
									--如果势力方一样则刷新界面
									_frm.childUI["NextWave"]:setstate(-1)
									__updataLife(w, labLife)
								end
							end
						end
						
						--漏怪直接胜利的检测
						local typeId = unit.data.id
						local force = owner:getforce()
						local escapeWinT = mapInfo.escapeWin and mapInfo.escapeWin[force]
						if escapeWinT then
							if typeId and (typeId > 0) then
								for i = 1, #escapeWinT, 1 do
									if (escapeWinT[i].typeId == typeId) then
										escapeWinT[i].escape = true --逃脱了
										break
									end
								end
							end
						end
					end
				elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
					local owner = unit:getowner()
					if owner then
						local force = owner:getforce()
						local enemyForce
						if force == hVar.FORCE_DEF.SHU then
							enemyForce = hVar.FORCE_DEF.WEI
						elseif force == hVar.FORCE_DEF.WEI then
							enemyForce = hVar.FORCE_DEF.SHU
						end
						
						if enemyForce then
							local enemyForcePlayer = w:GetForce(enemyForce)
							if enemyForcePlayer then
								local life = enemyForcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE)
								if (life > 0) then
									local costLife = unit:GetEscapePunish() --漏怪惩罚扣除的点数
									if (costLife < 0) then
										costLife = 0
									end
									enemyForcePlayer:addresource(hVar.RESOURCE_TYPE.LIFE, -costLife)
									
									--如果势力方一样则刷新界面
									_frm.childUI["NextWave"]:setstate(-1)
									__updataLife(w, labLife)
								end
							end
						end
						
						local escapeWinT = mapInfo.escapeWin and mapInfo.escapeWin[force]
						if escapeWinT then
							if typeId and (typeId > 0) then
								for i = 1, #escapeWinT, 1 do
									if (escapeWinT[i].typeId == typeId) then
										escapeWinT[i].escape = true --逃脱了
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--小兵被击杀
	__CODE_UnitDefeated = function(unit, oKillerUnit, oKillerSide, oKillerPos)
		local w = hGlobal.WORLD.LastWorldMap
		
		--地图胜利/失败的状态下点不到这些按钮
		if w and unit then
			local mapInfo = w.data.tdMapInfo
			if mapInfo then
				
				if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then
					return
				end
				
				--获得击杀该单位奖励的金币
				local owner = unit:getowner()
				local me = w:GetPlayerMe()
				local gold = unit:GetKillGold()
				local pvpexp = gold
				--print("gold=", gold, unit.data.id, unit.data.name)
				
				if (gold >= 0) then
					
					--大菠萝模式
					if hVar.IS_DIABOLO_APP == 1 then
						--（怪物品质*6+怪物等级-人物等级）*6
						--如果怪物与人物等级相差大于6级，则不获得经验。
						
						--怪物品质：
						--普通怪：1；精英怪：3；关底BOSS：6
						local expadd = 0
						
						if oKillerUnit and (oKillerUnit ~= 0) and oKillerUnit.getowner then
							local kOwner = oKillerUnit:getowner()
							if kOwner and kOwner == me and kOwner.getherobyidx then
								local hero = kOwner:getherobyidx(1)
								if hero then
									local heroId = hero.data.id
									local heroLv = hero.attr.level
									
									local expAdd = 0
									
									local id = unit.data.id
									--如果被杀对象的静态表存在
									if id and hVar.tab_unit[id] then
										
										local tabU = hVar.tab_unit[id]
										
										local enemyQuality = 1
										for tag, flag in pairs(tabU.tag or {}) do
											if flag then
												enemyQuality = hVar.UNIT_QUALITY_VALUE[tag] or 1
											end
										end
										
										
										local enemyLv = tabU.expLv or 1
										
										expAdd = math.max(enemyQuality * 6 + enemyLv - heroLv, 0)
										
										--[[
										if LuaAddHeroExp(heroId, expAdd) then
											--重新读取存档中的等级经验信息
											hero:reloadHeroCard()
											oKillerUnit:SetLevel(hero.attr.level)
										end
										]]
									end
								end
								
								--增加积分
								--LuaAddPlayerScore(gold, true)
								
								
								--界面冒字得钱
								--大菠萝注释掉
								--hGlobal.event:event("Event_UnitDead_Bubble", unit, gold, false)
								--__updateGold2(w, labGold)
								--__updataCrystal(w, labCrystal)
								
								--战绩统计
								--召唤单位不计算得分
								--if (unit.data.is_summon == 0) then
									--print("得分", unit.data.name, gold)
									mapInfo.combatEva = mapInfo.combatEva + math.floor(gold / 2.1) + math.floor(mapInfo.wave * 3)
									local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
									diablodata.score = mapInfo.combatEva --得分
									
									--界面显示无尽地图得分
									local _frm = hGlobal.UI.TDSystemMenuBar
									if _frm.childUI["Endless_ScoreLabel"] then
										_frm.childUI["Endless_ScoreLabel"]:setText(mapInfo.combatEva)
									end
									
									--计算经验值
									--BOSS   (6000+生命*0.1+攻击力*20)*0.001
									--小兵   (300+生命*0.1+攻击力*5)*0.001
									local expAdd = 0
									local hpMax = unit:GetHpMax()
									local atk = unit:GetAtk()
									--print("unit.data.type=", unit.data.type)
									if (unit.data.type == hVar.UNIT_TYPE.HERO) then --英雄
										--最大100
										expAdd = math.min(hVar.HeroMaxExp,math.floor((6000+hpMax*0.1+atk*20)*0.001))
									elseif (unit.data.type == hVar.UNIT_TYPE.UNIT) then --小兵
										--最大5
										expAdd = math.min(hVar.UnitMaxExp,math.floor((300+hpMax*0.1+atk*5)*0.001))
									end
									kOwner:addresource(hVar.RESOURCE_TYPE.EXP, expAdd)
									print("AddExp", kOwner:getpos(), expAdd)
								--end
							end
						end
						
						--geyachao: 战车杀怪也得金币
						if oKillerUnit and (oKillerUnit ~= 0) and oKillerUnit.getowner then
							local kOwner = oKillerUnit:getowner()
							if kOwner then
								local kforce = kOwner:getforce()
								--pvp经验值目前与获得的钱相等
								pvpexp = gold
								
								--战车要加上水晶收益率
								local crystalRate = oKillerUnit:GetCrystalRate() --单位水晶收益率（去百分号后的值）
								--print("crystalRate=", crystalRate)
								local goldFinal = math.floor(gold * crystalRate / 100)
								
								--如果是蜀国或魏国势力的单位进行了击杀，则钱平分给玩家本势力的玩家
								if kOwner == w:GetForce(hVar.FORCE_DEF.SHU) or kOwner == w:GetForce(hVar.FORCE_DEF.WEI) then
									local pList = w:GetAllPlayerInForce(kforce)
									local pNum = #pList
									if (pNum > 0) then
										local goldDiv = math.floor(goldFinal / pNum)
										local pvpexpDiv = goldDiv
										for i = 1, pNum do
											pList[i]:addresource(hVar.RESOURCE_TYPE.GOLD, goldDiv)
											if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
												pList[i]:addHeroPvpExp(0, pvpexpDiv)
											end
										end
									end
									kOwner:addresource(hVar.RESOURCE_TYPE.GOLD, goldFinal)
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										kOwner:addHeroPvpExp(0, pvpexp)
									end
								else
									kOwner:addresource(hVar.RESOURCE_TYPE.GOLD, goldFinal)
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										kOwner:addHeroPvpExp(0, pvpexp)
									end
								end
								
								--本地冒字得钱
								if (kOwner == me) then
									--界面冒字得钱
									hGlobal.event:event("Event_UnitDead_Bubble", unit, goldFinal, bIsCritGold)
									
									--积分计算目前先写死。mapInfo.combatEva要改成玩家相关
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
										--战绩统计
										--召唤单位不计算得分
										if (unit.data.is_summon == 0) then
											--print("得分", unit.data.name, gold)
											mapInfo.combatEva = mapInfo.combatEva + math.floor(gold / 2.1) + math.floor(mapInfo.wave * 3)
											local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
											diablodata.score = mapInfo.combatEva --得分
											
											--界面显示无尽地图得分
											local _frm = hGlobal.UI.TDSystemMenuBar
											if _frm.childUI["Endless_ScoreLabel"] then
												_frm.childUI["Endless_ScoreLabel"]:setText(mapInfo.combatEva)
											end
										end
									end
								end
								
								__updateGold2(w, labGold)
								__updataCrystal(w, labCrystal)
							end
						end
					else
						
						--地图模式判定
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
							if unit and oKillerUnit and (unit.data.type == hVar.UNIT_TYPE.HERO) and (oKillerUnit.data.type ~= hVar.UNIT_TYPE.HERO) then
								gold = math.floor(gold * 0.5)
							end
						end
						
						--geyachao: 金币是否暴击
						--有一定的几率获得双倍钱(金钱怪不会暴击得钱，爆钱最低为5金币)
						local bIsGoldUnit = (hVar.tab_unit[unit.data.id].tag and hVar.tab_unit[unit.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_GOLDUNIT])
						local bIsCritGold = false
						if (not bIsGoldUnit) then --金钱怪不爆钱
							if (unit.data.type == hVar.UNIT_TYPE.HERO) or (unit.data.type == hVar.UNIT_TYPE.UNIT) then --打小兵、英雄，才会爆钱
								local rand = w:random(1, 100)
								if (rand <= hVar.UNIT_KILLGOLD_CRIT_RATE) then
									gold = gold * hVar.UNIT_KILLGOLD_CRIT_VALUE
									bIsCritGold = true --暴击
									
									--如果获得的钱过低，获得最低钱
									if (gold < hVar.UNIT_KILLGOLD_GOLD_MIN) then
										gold = hVar.UNIT_KILLGOLD_GOLD_MIN
									end
								end
							end
						end
						
						--mapInfo.gold = mapInfo.gold + gold
						--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
						if oKillerUnit and (oKillerUnit ~= 0) and oKillerUnit.getowner then
							local kOwner = oKillerUnit:getowner()
							if kOwner then
								local kforce = kOwner:getforce()
								--pvp经验值目前与获得的钱相等
								pvpexp = gold
								--如果是蜀国或魏国势力的单位进行了击杀，则钱平分给玩家本势力的玩家
								if kOwner == w:GetForce(hVar.FORCE_DEF.SHU) or kOwner == w:GetForce(hVar.FORCE_DEF.WEI) then
									local pList = w:GetAllPlayerInForce(kforce)
									local pNum = #pList
									if (pNum > 0) then
										local goldDiv = math.floor(gold / pNum)
										local pvpexpDiv = goldDiv
										for i = 1, pNum do
											pList[i]:addresource(hVar.RESOURCE_TYPE.GOLD, goldDiv)
											if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
												pList[i]:addHeroPvpExp(0, pvpexpDiv)
											end
										end
									end
									kOwner:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										kOwner:addHeroPvpExp(0, pvpexp)
									end
								else
									kOwner:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
										kOwner:addHeroPvpExp(0, pvpexp)
									end
								end
								
								--本地冒字得钱
								if (kOwner == me) then
									--界面冒字得钱
									hGlobal.event:event("Event_UnitDead_Bubble", unit, gold, bIsCritGold)
									
									--积分计算目前先写死。mapInfo.combatEva要改成玩家相关
									if (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
										--战绩统计
										--召唤单位不计算得分
										if (unit.data.is_summon == 0) then
											--print("得分", unit.data.name, gold)
											mapInfo.combatEva = mapInfo.combatEva + math.floor(gold / 2.1) + math.floor(mapInfo.wave * 3)
											local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
											diablodata.score = mapInfo.combatEva --得分
											
											--界面显示无尽地图得分
											local _frm = hGlobal.UI.TDSystemMenuBar
											if _frm.childUI["Endless_ScoreLabel"] then
												_frm.childUI["Endless_ScoreLabel"]:setText(mapInfo.combatEva)
											end
										end
									end
								end
								
								__updateGold2(w, labGold)
								__updataCrystal(w, labCrystal)
							end
						end
					
					end
					
				end
				
				--非PVP模式，守卫单位被击杀扣除生命
				--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
					--守卫单位被击杀扣除生命
					local forcePlayer = w:GetForce(owner:getforce())
					if forcePlayer then
						local life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE)
						if (life > 0) then
							local costLife = unit:GetEscapePunish() --漏怪惩罚扣除的点数
							if (costLife < 0) then
								costLife = 0
							end
							forcePlayer:addresource(hVar.RESOURCE_TYPE.LIFE, -costLife)
							
							--如果势力方一样则刷新界面
							__updataLife(w, labLife)
						end
					end
				--end
			end
		end
	end
	
	--大菠萝
	--创建武器界面
	local __CreateWeaponFrame = function()
		local _frm = hGlobal.UI.TDSystemMenuBar
		local _parent = _frm.handle._n
		
		local OFFSET_X = hVar.SCREEN.w - 220 - 10000 --geyachao: 不显示了
		local OFFSET_Y = hVar.SCREEN.h - 410
		local OFFSET_HINTX = OFFSET_X - 30
		local EDGE = 90
		local EDGE_MANA = 52
		
		if (g_phone_mode ~= 0) then --手机模式
			--iphone尺寸
			OFFSET_X = hVar.SCREEN.w - 230 - 10000 --geyachao: 不显示了
			OFFSET_Y = hVar.SCREEN.h - 260
			EDGE = 90
			OFFSET_HINTX = OFFSET_X - 30
			EDGE_MANA = 52
		end
		
		if (g_phone_mode == 4) then --iphoneX
			OFFSET_X = hVar.SCREEN.w - 270 - 10000 --geyachao: 不显示了
			OFFSET_Y = hVar.SCREEN.h - 240
			EDGE = 120
			OFFSET_HINTX = OFFSET_X - 60
			EDGE_MANA = 64
		end
		
		local TACTIC_CARD_WIDTH = 80 --按钮的边长
		
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_Manaicon")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_Progress")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_Progress_Num")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_SkillBtn1")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_SkillBtn2")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_SkillBtn3")
		hApi.safeRemoveT(_frm.childUI, "Diablo_Weapon_SkillBtnHint")
		
		--大菠萝的魔法进度条
		local progreesX = OFFSET_X + 85
		local progreesY = OFFSET_Y - 10
		if (g_phone_mode ~= 0) then --手机模式
			progreesX = OFFSET_X + 85
			progreesY = OFFSET_Y - 10
		end
		if (g_phone_mode == 4) then --iphoneX
			progreesX = OFFSET_X + 70
			progreesY = OFFSET_Y + 10
		end
		_frm.childUI["Diablo_Weapon_Progress"] = hUI.valbar:new({
			parent = _frm.handle._n,
			x = progreesX,
			y = progreesY,
			w = EDGE,
			h = 16,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -3, y = 0, w = EDGE + 5, h = 16 + 2},
			model = "misc/jdt4.png",
			--model = "misc/progress.png",
			v = 100,
			max = 100,
		})
		
		--大菠萝的魔法图标
		_frm.childUI["Diablo_Weapon_Manaicon"] = hUI.image:new({
			parent = _frm.handle._n,
			model = "effect/shuijing.png",
			x = OFFSET_X + 75,
			y = progreesY + 24,
			w = 28,
			h = 28,
		})
		
		--大菠萝的魔法进度文字
		_frm.childUI["Diablo_Weapon_Progress_Num"] = hUI.label:new({
			parent = _frm.handle._n,
			size = 16,
			x = OFFSET_X + 135,
			y = progreesY + 22,
			w = 300,
			align = "MC",
			font = "numWhite",
			text = "200/200",
			border = 0,
		})
		
		--大菠萝当前在使用的技能图标1
		_frm.childUI["Diablo_Weapon_SkillBtn1"] = hUI.button:new({
			parent = _frm.handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 130,
			y = OFFSET_Y - 70,
			w = EDGE,
			h = EDGE,
			model = "misc/addition/q_3.png",
			scaleT = 0.98,
			code = function()
				--切换武器
				hGlobal.LocalPlayer:switchweapon()
			end,
		})
		--技能耗魔
		_frm.childUI["Diablo_Weapon_SkillBtn1"].childUI["manaCostIcon"] = hUI.image:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtn1"].handle._n,
			x = -EDGE/2 + 2,
			y = -EDGE/2 + EDGE_MANA/3,
			w = EDGE_MANA,
			h = EDGE_MANA,
			model = "effect/shuijing.png",
		})
		--技能图标
		_frm.childUI["Diablo_Weapon_SkillBtn1"].childUI["icon"] = hUI.image:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtn1"].handle._n,
			x = 0,
			y = 3,
			w = EDGE-5,
			h = EDGE-5,
			model = "effect/buff000.png",
		})
		--技能耗魔值
		local fontSize = 18
		if (g_phone_mode == 3) then --iphone6
			fontSize = 20
		end
		if (g_phone_mode == 4) then --iphoneX
			fontSize = 20
		end
		_frm.childUI["Diablo_Weapon_SkillBtn1"].childUI["manaCostLabel"] = hUI.label:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtn1"].handle._n,
			x = -EDGE/2 + 2,
			y = -EDGE/2 + EDGE_MANA/3 - 1, --数字字体有1像素的偏差
			w = 300,
			size = fontSize,
			align = "MC",
			font = "numWhite",
			text = "0",
			border = 0,
		})
		--[[
		--技能点击切换文字
		_frm.childUI["Diablo_Weapon_SkillBtn1"].childUI["switchLabel"] = hUI.label:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtn1"].handle._n,
			x = 0,
			y = -60,
			w = 300,
			size = 18,
			align = "MC",
			font = hVar.FONTC,
			text = "点击切换",
			border = 1,
		})
		]]
		
		--大菠萝没在使用的技能图标2-3
		for i = 2, 2, 1 do
			--大菠萝当前在使用的技能图标2-3
			local px = OFFSET_X + EDGE + i * (36 + EDGE/6 + 3)
			local py = OFFSET_Y - EDGE-EDGE/6 + 5
			if (g_phone_mode == 4) then --iphoneX
				px = OFFSET_X + EDGE + i * (36 + EDGE/6 + 3) - 8
				py = OFFSET_Y - EDGE-EDGE/6 + 30
			end
			_frm.childUI["Diablo_Weapon_SkillBtn" .. i] = hUI.button:new({
				parent = _frm.handle._n,
				dragbox = _frm.childUI["dragBox"],
				x = px,
				y = py,
				w = EDGE/3,
				h = EDGE/3,
				model = "misc/addition/q_3.png",
				scaleT = 1.0,
				code = function()
					--print("DD")
				end,
			})
			hApi.AddShader(_frm.childUI["Diablo_Weapon_SkillBtn" .. i].handle.s, "gray")
			
			--技能图标i
			_frm.childUI["Diablo_Weapon_SkillBtn" .. i].childUI["icon"] = hUI.image:new({
				parent = _frm.childUI["Diablo_Weapon_SkillBtn" .. i].handle._n,
				x = 0,
				y = 2,
				w = EDGE/3,
				h = EDGE/3,
				model = "effect/buff001.png",
			})
			_frm.childUI["Diablo_Weapon_SkillBtn" .. i].childUI["icon"].handle._n:setVisible(false) --默认隐藏
		end
		
		--大菠萝提示拣取的技能按钮
		_frm.childUI["Diablo_Weapon_SkillBtnHint"] = hUI.button:new({
			parent = _frm.handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_HINTX,
			y = OFFSET_Y - 70,
			w = EDGE,
			h = EDGE,
			model = "misc/addition/q_2.png",
			scaleT = 0.95,
			code = function()
				--print("click 大菠萝提示拣取的技能按钮")
				--检测道具合法性
				local node = _frm.childUI["Diablo_Weapon_SkillBtnHint"]
				local oItem = node.data.oItem --待拾取的道具
				local oItem_worldC = node.data.oItem_worldC --待拾取的道具的唯一id
				
				if oItem and (oItem ~= 0) and (oItem.data.IsDead ~= 1) and (oItem:getworldC() == oItem_worldC) then
					--拾取武器
					local result = hGlobal.LocalPlayer:addweapon(oItem)
					--print("click addweapon, result=",result)
					if (result == 1) then
						node.data.oItem = nil
						node.data.oItem_worldC = 0
					end
				end
				
				node:setstate(-1)
			end,
		})
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].data.oItem = nil --待拾取的道具
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].data.oItem_worldC = 0 --待拾取的道具的唯一id
		
		--拣取技能耗魔
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["manaCostIcon"] = hUI.image:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtnHint"].handle._n,
			x = -EDGE/2 + 2,
			y = -EDGE/2 + EDGE_MANA/3,
			w = EDGE_MANA,
			h = EDGE_MANA,
			model = "effect/shuijing.png",
		})
		--拣取技能图标
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["icon"] = hUI.image:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtnHint"].handle._n,
			x = 0,
			y = 3,
			w = EDGE-5,
			h = EDGE-5,
			model = "effect/buff001.png",
		})
		--拣取技能耗魔值
		local fontSize = 18
		if (g_phone_mode == 4) then --iphoneX
			fontSize = 20
		end
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["manaCostLabel"] = hUI.label:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtnHint"].handle._n,
			x = -EDGE/2 + 2,
			y = -EDGE/2 + EDGE_MANA/3 - 1, --数字字体有1像素的偏差
			w = 300,
			size = fontSize,
			align = "MC",
			font = "numWhite",
			text = "-",
			border = 0,
		})
		
		--拣取技能点击切换文字
		local tanhaoY = -EDGE_MANA - 10
		if (g_phone_mode == 4) then --iphoneX
			tanhaoY = -EDGE_MANA - 18
		end
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["switchLabel"] = hUI.label:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtnHint"].handle._n,
			x = 0,
			y = tanhaoY,
			w = 300,
			size = 22,
			align = "MC",
			font = hVar.FONTC,
			text = "点击捡取",
			border = 1,
		})
		local fade1 = CCFadeTo:create(1.0, 128)
		local fade2 = CCFadeTo:create(1.0, 255)
		local sequence = CCSequence:createWithTwoActions(fade1, fade2)
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["switchLabel"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--拣取叹号
		local pickX = 60
		local pickY = -EDGE_MANA
		if (g_phone_mode == 4) then --iphoneX
			pickX = 78
			pickY = -EDGE_MANA - 9
		end
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["tanhao"] = hUI.image:new({
			parent = _frm.childUI["Diablo_Weapon_SkillBtnHint"].handle._n,
			x = pickX,
			y = pickY,
			w = 36,
			h = 36,
			model = "UI:TaskTanHao",
		})
		local act1 = CCMoveBy:create(0.2, ccp(0, 5))
		local act2 = CCMoveBy:create(0.2, ccp(0, -5))
		local act3 = CCMoveBy:create(0.2, ccp(0, 5))
		local act4 = CCMoveBy:create(0.2, ccp(0, -5))
		local act5 = CCDelayTime:create(2.0)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		local sequence = CCSequence:create(a)
		_frm.childUI["Diablo_Weapon_SkillBtnHint"].childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--默认不显示捡取技能
		_frm.childUI["Diablo_Weapon_SkillBtnHint"]:setstate(-1)
	end
	
	__CreateWeaponFrame()
	
	local _HideButtonManager = function(state)
		if _frm then
			if state == 0 then
				if _frm.childUI["btn_RescuedPerson"] then
					--_frm.childUI["btn_RescuedPerson"].childUI["img_person"]
					_frm.childUI["btn_RescuedPerson"].handle._n:setVisible(true)
				end
				if _frm.childUI["Lab_RescuedPerson"] then
					_frm.childUI["Lab_RescuedPerson"].handle._n:setVisible(true)
				end
				if _frm.childUI["SysMenu"] then
					_frm.childUI["SysMenu"]:setstate(1)
				end
				if _frm.childUI["btnTactics_4"] then
					_frm.childUI["btnTactics_4"]:setstate(1)
				end
				if _frm.childUI["TopBar"] then
					_frm.childUI["TopBar"].handle._n:setVisible(true)
				end
				if _frm.childUI["chatBtn"] then
					_frm.childUI["chatBtn"]:setstate(1)
				end
				_showUIComment(_frm)
			elseif state == 1 then
				if _frm.childUI["btn_RescuedPerson"] then
					_frm.childUI["btn_RescuedPerson"].handle._n:setVisible(false)
				end
				if _frm.childUI["Lab_RescuedPerson"] then
					_frm.childUI["Lab_RescuedPerson"].handle._n:setVisible(false)
				end
				if _frm.childUI["SysMenu"] then
					_frm.childUI["SysMenu"]:setstate(-1)
				end
				if _frm.childUI["Comment"] then
					_frm.childUI["Comment"]:setstate(-1)
				end
				if _frm.childUI["btnTactics_4"] then
					_frm.childUI["btnTactics_4"]:setstate(-1)
				end
				if _frm.childUI["TopBar"] then
					_frm.childUI["TopBar"].handle._n:setVisible(false)
				end
				if _frm.childUI["chatBtn"] then
					_frm.childUI["chatBtn"]:setstate(-1)
				end
			end
			if _frm.childUI["bag"] then
				_frm.childUI["bag"]:setstate(-1)
			end
		end
	end
	
	hGlobal.event:listen("LocalEvent_ShowControlBtn", "__SHOW__TDSystemMenuBar",function(show)
		print("LocalEvent_ShowControlBtn")
		local _frm = hGlobal.UI.TDSystemMenuBar
		_frm:show(show)
		if show == 1 then
			_HideButtonManager(1)
		else
			_HideButtonManager(0)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_ChangeController","changebtn",function()
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
				local parentFrm = _frm
				local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
				for num = 3,4 do
					local x,y = 0,0
					if hVar.CONTROL_NOW == 0 then
						if (num == 3) then --技能3-y
							x = hVar.SCREEN.w - 75 - 30
							y = 150 - 60 + 5 + 150
						end
						if (num == 4) then --技能4-y
							x = hVar.SCREEN.w - 75 - 150
							y = 150 - 60 + 5 + 10
						end
					else
						if (num == 3) then --技能3-y
							x = 75 + 30
							y = 150 - 60 + 5 + 150
						end
						if (num == 4) then --技能4-y
							x = 75 + 150
							y = 150 - 60 + 5 + 10
						end
					end
					parentFrm.childUI["btnTacticsMask_"..tostring(num)]:setXY(x,y)
					parentFrm.childUI["btnTactics_"..tostring(num)]:setXY(x,y)
				end
				local unitId = hVar.MY_TANK_ID
				local tacticPos = hVar.TANKSKILL_IDX
				local tacticId = 0
				local itemId = hVar.tab_unit[unitId].skillItemlId
				local num = -1
				hGlobal.event:event("Event_ResetSingleTactic", tacticPos, tacticId, itemId, tacticlv, num, unitId)
			end
		end
	end)
	
	local focusworld = function(sSceneType,oWorld,oMap)
		--如果是从基地切换到黑龙，或者黑龙切换到基地，不处理
		if (hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR == 1) then
			return
		end
		
		--print("LocalEvent_PlayerFocusWorld", sSceneType,oWorld,oMap, "g_editor=", g_editor)
		if g_editor == 1 then
			return
		end
		
		--print("oWorld.data=", oWorld and oWorld.data.map)
		
		--处理坦克查看界面的数据初始化
		if oWorld and sSceneType=="worldmap" then
			pauseFlag = -1
		end
		
		--if oWorld and sSceneType=="worldmap" and oWorld.data.map ~= hVar.MainBase then
		--todo: 暂时恢复
		if oWorld and sSceneType=="worldmap" then
			_HideButtonManager(0)
			_frm:show(1)
			if oWorld.data.map == hVar.MainBase then
				_frm:show(0)
			else
				_showUIComment(_frm)
				CommentManage.EnterBattle(oWorld)
				hGlobal.event:event("LocalEvent_ShowTDSystemMenuFrm_Vertical")
			end
			--print("oWorld.data.map=", oWorld.data.map, hVar.MAP_INFO[oWorld.data.map])
			if hVar.MAP_INFO[oWorld.data.map] and type(hVar.MAP_INFO[oWorld.data.map]) == "table" and  hVar.MAP_INFO[oWorld.data.map].mapType == 4 then
				--print("增加一个 永久的使用技能书的 提示动画", pauseFlag, debug.traceback())
				pauseFlag = -1
				
				--每次重新初始化加速按钮状态
				isCountdown = false
				
				_frm.childUI["NextWave"]:setstate(1)
				_frm.childUI["NextWaveProgress"].handle._n:setVisible(false)
				
				__updataWave(oWorld, labMana)
				__updataLife(oWorld, labLife)
				__updateGold2(oWorld, labGold)
				__updataCrystal(oWorld, labCrystal)
				__updataLayer(oWorld, labLayer)
				
				nSpeedUpRate = 1 --初始的倍率为1
				local w = oWorld
				local mapInfo = w.data.tdMapInfo
				if mapInfo and mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP then
					_frm.childUI["SpeedUp"]:setstate(1)
					_frm.childUI["SpeedUp"]:loadsprite("UI:td_mui_speed1x")
					_frm.childUI["SpeedUpLabel"]:setText("") --一开始不加速
				else
					_frm.childUI["SpeedUp"]:setstate(-1)
				end
				
				__clearActiveTactic(_frm)
				__clearPassiveTactic(_frm)
				__clearTankNumImage(_frm)
				__clearRescuedPerson(_frm)
				
				--hApi.addTimerForever("__UI_RefreshTacticsState", hVar.TIMER_MODE.GAMETIME, 100, function(tick)
				oWorld:addtimer("__UI_RefreshTacticsState", 100, function()
					__refreshTacticState()
				end)
				
				--[[
				--geyachao: 大菠萝不要出兵提示了
				--hApi.addTimerForever("__UI_RefreshBeginPointTip", hVar.TIMER_MODE.GAMETIME, 100, function(tick)
				oWorld:addtimer("__UI_RefreshBeginPointTip", 100, function()
					__refreshBeginPointTip()
				end)
				]]
				
				--刷新战术技能卡CDlab
				--hApi.addTimerForever("__UI_RefreshTacticsCDLab", hVar.TIMER_MODE.GAMETIME, 1000, function(tick)
				oWorld:addtimer("__UI_RefreshTacticsCDLab", 100, function()
					__refreshTacticCDLab()
				end)
				
				--zhenkira pvpui pvp倒计时
				----刷新顶部剩余时间
				--hApi.addTimerForever("__UI_RefreshTopGameLastTime", hVar.TIMER_MODE.GAMETIME, 200, function(tick)
				--	__refreshTopGameLastTime()
				--end)
				--新手引导关不弹进度显示
				if oWorld.data.map ~= hVar.GuideMap then
					hApi.addTimerOnce("__UI_ShowRandMapStage",100,function()
						--显示当前随机地图进度
						__CODE_ShowRandMapStage(_frm)
					end)
				end
			end
		else
			__clearBeginPointTip()
			hApi.clearTimer("__UI_RefreshTacticsState")
			hApi.clearTimer("__UI_RefreshBeginPointTip")
			hApi.clearTimer("__UI_RefreshTacticsCDLab")
			--zhenkira pvpui pvp倒计时
			--hApi.clearTimer("__UI_RefreshTopGameLastTime")
			_frm:show(0)
			hGlobal.event:event("LocalEvent_CloseTDSystemMenuFrm_Vertical")
			hGlobal.event:event("LocalEvent_ClearTacticsBuffIcon")
		end
	end
	
	
	--增加一个 永久的使用技能书的 提示动画
	--系统条在大地图显示
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__SHOW__TDSystemMenuBar",function(sSceneType,oWorld,oMap)
		focusworld(sSceneType,oWorld,oMap)
	end)
	
	--直接设置波次发生变化
	hGlobal.event:listen("LocalEvent_SetWaveChanged", "__SHOW__WaveChanged",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			__updataWave(oWorld, labMana)
		end
	end)
	
	--横竖屏切换
	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFrm",function()
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			if w.data.map == hVar.LoginMap then
				return
			end
			
			if w.data.map == hVar.MainBase then
				--主基地需要重新创建，创建后隐藏，不用刷新
				hGlobal.UI.InitTDSystemMenuBar()
				hGlobal.event:event("Event_TacticsInit", "SpinScreen")
				return
			end
			
			--重绘系统条
			--print("重绘系统条", "pauseFlag=", pauseFlag)
			--local _pauseFlag = pauseFlag
			local bagstate = _showBagState
			local labMana, labLife, labGold, labCrystal, labLayer = hGlobal.UI.InitTDSystemMenuBar()
			
			--存储之前的暂停状态
			--pauseFlag = _pauseFlag
			--print("存储之前的暂停状态", "pauseFlag=", pauseFlag)
			--显示
			hGlobal.UI.TDSystemMenuBar:show(1)
			hGlobal.UI.TDSystemMenuBar:active()
			
			__updataWave(w, labMana)
			__updataLife(w, labLife)
			__updateGold2(w, labGold)
			__updataCrystal(w, labCrystal)
			__updataLayer(w, labLayer)
			
			_showUIComment(hGlobal.UI.TDSystemMenuBar)
			--按钮
			hGlobal.event:event("Event_TacticsInit", "SpinScreen")
			hGlobal.event:event("Event_UpdateTankNum")
			hGlobal.event:event("Event_ResetRescuedPerson",w)
			hGlobal.event:event("LocalEvent_ShowTempBagBtn",bagstate)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_TD_SelectHeroOk","__TD_SelectedHeroOk",function()
		--根据结果设置是否开启提示
		local playerSkillBook = LuaGetPlayerSkillBook()
		
		if type(playerSkillBook) == "table" then
			if #playerSkillBook > 0  then
				hGlobal.event:event("LocalEvent_ShowBattlefieldSkillBookBreathe",0)
				--在游戏中弹出战术技能卡界面
				hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook_Game")
			end
		end
	end)
	
	--NextWave刷新
	hGlobal.event:listen("LocalEvent_TD_NextWave","__TD_NextWave",function(bFirstWave)
		__CODE_ClickNextWave(bFirstWave)
	end)
	
	--显示NextWave按钮
	hGlobal.event:listen("LocalEvent_TD_ShowNextWave","__TD_NextWave",function(timer)
		if not isCountdown then
			--zhenkira 2015.12.9 据说又不要这个功能了,不显示右下角按钮
			if hVar.OPTIONS.SHOW_DEBUG_NEXTWAVE_BTN > 0 then
				_frm.childUI["NextWaveBg"].handle._n:setVisible(true)
				_frm.childUI["NextWaveProgress"].handle._n:setVisible(true)
				_frm.childUI["NextWaveProgress"]:start(timer / 1000)
				
				_frm.childUI["NextWave"]:setstate(1)
			end
			
			isCountdown = true
			
			--print("_________LocalEvent_TD_ShowNextWave:".. tostring(hApi.gametime()))
		end
	end)
	
	--角色到达路点终点刷新
	hGlobal.event:listen("LocalEvent_TD_UnitReached","__TD_UnitReached",function(unit)
		__CODE_UnitReached(unit)
	end)
	
	--角色死亡刷新金币
	hGlobal.event:listen("Event_UnitDead","__TD_UnitDefeated",function(unit, operate, oKillerUnit_unsafe, id, param, oKillerSide, oKillerPos)
		__CODE_UnitDefeated(unit, oKillerUnit_unsafe, oKillerSide, oKillerPos)
	
		--更新坦克剩余数量
		hGlobal.event:event("Event_UpdateTankNum")
	end)
	
	--建造刷新
	hGlobal.event:listen("Event_TowerUpgradeCostRefresh","__TD_TowerUpgrade",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updateGold2(w, labGold)
		__updataCrystal(w, labCrystal)
	end)
	
	--释放技能刷新
	hGlobal.event:listen("Event_TacticCastCostRefresh","__TD_TacticCast",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updateGold2(w, labGold)
		__updataCrystal(w, labCrystal)
	end)
	
	--金钱变化界面刷新
	hGlobal.event:listen("Event_TdGoldCostRefresh","__TD_TdGoldCost",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updateGold2(w, labGold)
		__updataCrystal(w, labCrystal)
	end)
	
	--生命点数变化界面刷新
	hGlobal.event:listen("Event_TdLifeChangeRefresh","__TD_TdLifeChange",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updataLife(w, labLife)
	end)
	
	--设置战术技能卡的主动技能界面
	hGlobal.event:listen("Event_TacticsInit", "__TD_MainTaticsSkillRefresh", function(mode)
		print("设置战术技能卡的主动技能界面 Event_TacticsInit")
		--创建主动战术技能卡主动技能界面
		__createActiveTactics(_frm, mode)
		
		--创建被动战术技能卡界面
		__createPassiveTactics(_frm, mode)
		
		hGlobal.event:event("Event_UpdateActiveTactics")
	end)
	
	--设置单个被动战术技能卡的动画
	--bAddtoTop: 是否跳到顶部展示小图标
	hGlobal.event:listen("LocalEvent_SinglePassiveTacticsAmin", "__TD_SinglePassiveTaticsSkillAmin", function(oPlayer, tacticId, tacticLv, bAddtoTop)
		--创建被动战术技能卡界面
		__createSinglePassiveTactics(_frm, oPlayer, tacticId, tacticLv, bAddtoTop)
	end)
	
	--开始按键攻击按钮
	hGlobal.event:listen("Event_BeginAutoAttack", "__TD_MainTaticsSkillRefresh", function(touch,tParam)
		--print("Event_BeginAutoAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				local scale = 1.3
				local btnW,btnH = btn1.data.w * scale,btn1.data.h * scale
				local btnX,btnY = btn1.data.x - btnW/2,btn1.data.y + btnH/2
				
				if hApi.IsInBox(touch[1],touch[2],{btnX,btnY,btnW,btnH}) then
					oWorld.data.weapon_attack_state = 1
					print("oWorld.data.weapon_attack_state = 1 B")
					
					--新增一个长按的timer
					hApi.clearTimer("__AUTOATTACK_LONGTOUCH_TIMER__")
					hApi.addTimerOnce("__AUTOATTACK_LONGTOUCH_TIMER__", hVar.AUTOATTACK_CHECKTIME,function()
						hGlobal.event:event("Event_OpenAutoAttack")
					end)
					
					if btn1.childUI["labSkillAutoCast"] then
						--显示自动攻击图标
						btn1.childUI["labSkillAutoCast"].handle._n:setVisible(true)
					end
					tParam[1] = hVar.RESULT_SUCESS
					
					--坦克朝正前方攻击一次
					local oHero = oWorld:GetPlayerMe().heros[1]
					local u = oHero:getunit()
					if u then
						local eu = u.data.bind_weapon
						if eu and (eu ~= 0) then
							local currenttime = oWorld:gametime()
							local lasttime = eu.attr.lastAttackTime --上次攻击的时间
							local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
							local atk_interval = eu:GetAtkInterval() --小兵的攻击间隔
								
							--过了攻击间隔
							if (deltatime >= atk_interval) then
								--施法前检测魔法是否够
								local mana = hGlobal.LocalPlayer:getmana()
								local weaponItemid = hGlobal.LocalPlayer:getweaponitem()
								local manaCost = hVar.tab_item[weaponItemid].mana or 0
								if (manaCost <= mana) then --魔法够
									--武器和坦克方向保持一致
									local facing = u.data.facing
									hApi.ChaSetFacing(eu.handle, facing) --转向
									eu.data.facing = facing
									
									local lockTarget = 0 --eu.data.lockTarget
									local result = atttack(eu, lockTarget)
									--print("atttack result=", result)
									if (result == hVar.RESULT_SUCESS) then
										hGlobal.LocalPlayer:setmana(mana - manaCost)
										
										--标记攻击时间
										eu.attr.lastAttackTime = currenttime
										
										--[[
										--geyachao: 不要引导了
										--是否需要引导按钮操作
										local mapInfo = oWorld.data.tdMapInfo
										if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.TANKCONFIG) then
											local clickCount = LuaGetTankClickGuideBtnCount()
											--print(clickCount)
											if (clickCount > 20) then
												--
											elseif (clickCount == 20) then
												--增加次数
												LuaSetTankClickGuideBtnCount(clickCount+1)
												
												--禁止游戏内的点击事件
												hApi.SetTouchEnable_Diablo(0)
												
												hGlobal.event:event("LocalEvent_ShowGuideControlFrm")
											else --小于20次
												--增加次数
												LuaSetTankClickGuideBtnCount(clickCount+1)
											end
										end
										]]
									end
								end
							end
						end
					end
				else
					if (oWorld.data.weapon_attack_state ~= 2) then --非长按
						oWorld.data.weapon_attack_state = 0	--原来是0，临时改一下，2022/8/17，X3
						print("oWorld.data.weapon_attack_state = 0 C")
						
						if btn1.childUI["labSkillAutoCast"] then
							--显示自动攻击图标
							btn1.childUI["labSkillAutoCast"].handle._n:setVisible(false)
						end
					end
				end
			end
		end
	end)
	
	--攻击按钮的touch滑动事件
	hGlobal.event:listen("Event_CheckAutoAttack", "__TD_MainTaticsSkillRefresh", function(touch,tParam)
		--print("Event_CheckAutoAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				local scale = 1.3
				local btnW,btnH = btn1.data.w * scale,btn1.data.h * scale
				local btnX,btnY = btn1.data.x - btnW/2,btn1.data.y + btnH/2
				
				if hApi.IsInBox(touch[1],touch[2],{btnX,btnY,btnW,btnH}) then
					if (oWorld.data.weapon_attack_state == 0) then
						oWorld.data.weapon_attack_state = 1
						print("oWorld.data.weapon_attack_state = 1 D")
						
						--新增一个长按的timer
						hApi.clearTimer("__AUTOATTACK_LONGTOUCH_TIMER__")
						hApi.addTimerOnce("__AUTOATTACK_LONGTOUCH_TIMER__", hVar.AUTOATTACK_CHECKTIME,function()
							hGlobal.event:event("Event_OpenAutoAttack")
						end)
					end
					
					if btn1.childUI["labSkillAutoCast"] then
						--显示自动攻击图标
						btn1.childUI["labSkillAutoCast"].handle._n:setVisible(true)
					end
					tParam[1] = hVar.RESULT_SUCESS
				else
					oWorld.data.weapon_attack_state = 0	--原来是0，临时改一下，2022/8/17，X3
					print("oWorld.data.weapon_attack_state = 0 E")
					hApi.clearTimer("__AUTOATTACK_LONGTOUCH_TIMER__")
					
					if btn1.childUI["labSkillAutoCast"] then
						--显示自动攻击图标
						btn1.childUI["labSkillAutoCast"].handle._n:setVisible(false)
					end
				end
			end
		end
	end)
	
	--[调试] 长按攻击按钮
	hGlobal.event:listen("Event_OpenAutoAttack", "__TD_MainTaticsSkillRefresh", function()
		--print("Event_OpenAutoAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				oWorld.data.weapon_attack_state = 2
				print("oWorld.data.weapon_attack_state = 2 F")
				
				if btn1.childUI["labSkillAutoCast"] then
					--显示自动攻击图标
					btn1.childUI["labSkillAutoCast"].handle._n:setVisible(true)
				end
			end
		end
	end)
	
	--取消按键攻击按钮
	hGlobal.event:listen("Event_CloseAutoAttack", "__TD_MainTaticsSkillRefresh", function()
		--print("Event_CloseAutoAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				if (oWorld.data.weapon_attack_state ~= 2) then --非长按
					oWorld.data.weapon_attack_state = 0	--原来是0，临时改一下，2022/8/17，X3
					print("oWorld.data.weapon_attack_state = 0 G")
					
					if btn1.childUI["labSkillAutoCast"] then
						--显示自动攻击图标
						btn1.childUI["labSkillAutoCast"].handle._n:setVisible(false)
					end
					
					--移除检测timer
					hApi.clearTimer("__AUTOATTACK_LONGTOUCH_TIMER__")
				end
			end
		end
	end)
	
	hGlobal.event:listen("Event_ClickTankSkill", "__TD_MainTaticsSkillRefresh", function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			--hVar.TANKSKILL_IDX = 1 --战车技能的图标位置索引值
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.TANKSKILL_IDX]
			if btn1 then
				btn1.data.codeOnTouch(btn1,0,0,1)
			end
		end
	end)
	
	hGlobal.event:listen("Event_ClickTacticsBtn","_ClickTacticsBtn",function(nIndex)
		local __activeSkillNum = __activeSkillNum --只读
		if __activeSkillNum > 4 then
			local parentFrm = _frm
			local index = 4 + nIndex
			local btn = parentFrm.childUI["btnTactics_"..tostring(index)]
			if btn and index > 4 then
				print("index",index)
				btn.data.codeOnTouch(btn,0,0,1)
			end
		end
	end)
	
	
	--更新战术技能卡的被动技能界面
	hGlobal.event:listen("Event_UpdatePassiveTactics", "__TD_MainTaticsSkillRefresh", function()
		--创建被动战术技能卡界面
		--__createPassiveTactics(_frm)
	end)
	
	--更新战术技能卡的主动技能
	hGlobal.event:listen("Event_UpdateActiveTactics", "__TD_MainTaticsSkillRefresh", function()
		--print("更新战术技能卡的主动技能")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oHero = oWorld:GetPlayerMe().heros[1]
			local oUnit = oHero:getunit()
			if oUnit then
				local basic_skill_usecount = oUnit:GetGrenadeMultiply() --GetBasicSkillUseCount()
				local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				btn2.data.useCountMax = basic_skill_usecount
				btn2.data.useCount = basic_skill_usecount
				btn2.childUI["labSkillUseCount"]:setText(basic_skill_usecount)
				if basic_skill_usecount > 1 then
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false) --改为都不显示次数了
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l5.png")
				else
					btn2.childUI["labSkillUseCount"].handle._n:setVisible(false)
					--手雷图标
					btn2.childUI["labSkillUseMultiply"]:setmodel("icon/skill/l4.png")
				end
			end
		end
	end)
	
	--初始化营救人员个数
	hGlobal.event:listen("Event_InitRescuedPerson", "__TD_InitRescuedPerson", function(oWorld)
		if oWorld then
			--[[
			local diablo = hGlobal.LocalPlayer.data.diablodata
			if diablo and type(diablo.randMap) == "table" then
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				if tInfo then
					if type(tInfo.rescuedcount) == "number" and tInfo.rescuedcount > 0 then
						oWorld.data.statistics_rescue_num = tInfo.rescuedcount
					end
					if type(tInfo.rescuedcostcount) == "number" and tInfo.rescuedcostcount > 0 then
						oWorld.data.statistics_rescue_costnum = tInfo.rescuedcostcount
					end
					local num = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
					__CreateRescuedPerson(_frm,num)
				end
			end
			]]
			if (oWorld.data.map == hVar.RandomMap) then
				local num = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
				__CreateRescuedPerson(_frm,num)
			end
		end
	end)
	
	--更新被营救人员
	hGlobal.event:listen("Event_UpdateRescuedPerson", "__TD_RescuedPersonRefresh", function(screenX, screenY)
		__CreateRescuedPerson(_frm)
		print(screenX, screenY)
		__playRescuedPersonAction(_frm,screenX,screenY)
	end)
	
	--重置被营救人员
	hGlobal.event:listen("Event_ResetRescuedPerson", "__TD_RescuedPersonRefresh", function(oWorld)
		if oWorld then
			local count = oWorld.data.statistics_rescue_num - oWorld.data.statistics_rescue_costnum
			tempRescuedPersonData.count = count
			if _frm then
				if _frm.childUI["Lab_RescuedPerson"] then
					_frm.childUI["Lab_RescuedPerson"]:setText(" "..count)
					if count == 0 then
						if _frm.childUI["btn_RescuedPerson"] then
							_frm.childUI["btn_RescuedPerson"].handle._n:setVisible(false)
						end
						_frm.childUI["Lab_RescuedPerson"].handle._n:setVisible(false)
					end
				elseif count > 0 then
					__CreateRescuedPerson(_frm,count)
				end
			end
		end
	end)
	
	hGlobal.event:listen("Event_UpdateTankNum", "__TD_TankNumRefresh", function()
		--更新坦克剩余数量
		__UpdateTankNum(_frm)
	end)

	hGlobal.event:listen("LocalEvent_ShowTempBagBtn","__showbtn",function(state)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _frm and _frm.childUI["bag"] and oWorld then
			if oWorld.data.map == hVar.MainBase then
				return
			end
			_frm.childUI["bag"]:setstate(state or 1)
			_showBagState = state
		end
	end)
	
	--添加玩家单个主动道具卡的主动技能界面
	hGlobal.event:listen("Event_AddTacticsActiveSkill", "__TD_AddTacticsActiveSkillRefresh", function(oPlayer, itemId, lv, num, typeId, bIgnoreAnim)
		print("添加玩家单个主动道具卡的主动技能界面", oPlayer, itemId, lv, num, typeId, bIgnoreAnim)
		--无效的tab_item
		if (not itemId) or (itemId == 0) then
			--纯占位
			__activeSkillNum = __activeSkillNum + 1
			
			local oWorld = hGlobal.WORLD.LastWorldMap
			oWorld.data.tacticCardCtrls[__activeSkillNum] = 0 --添加到本局的战术技能卡控件集中
			
			return
		end
		
		--if __activeSkillNum == 6 then
			--local parentFrm = _frm
			----for i = 5,__activeSkillNum do
				----local btn = parentFrm.childUI["btnTactics_"..tostring(i)]
				----if itemId == btn.data.itemId then
					----return
				----end
			----end
			--local btn = parentFrm.childUI["btnTactics_"..tostring(5)]
			--local tabI = hVar.tab_item[itemId]
			--if tabI.activeSkill then
				--hApi.AddCommand(hVar.Operation.DropOutItem, btn.data.tacticId, btn.data.itemId)
			--end
		--end
		
		--遍历该玩家的全部英雄，找到此道具是否已经在某个英雄身上
		for j = 1, #oPlayer.heros, 1 do
			local oHero = oPlayer.heros[j]
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				for k = 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:毫秒）
					
					if (activeItemId == itemId) then --找到了
						local w = hGlobal.WORLD.LastWorldMap
						local me = w:GetPlayerMe()
						if (me == oPlayer) then
							local tabI = hVar.tab_item[itemId]
							if tabI.activeSkill then
								local tacticId = 0
								__UpdateSingleActiveTacticCtrl(_frm, tacticId, itemId, lv, num, typeId)
								itemSkillT[k].activeItemNum = itemSkillT[k].activeItemNum + num
							end
						end
						
						return
					end
				end
			end
		end
		
		--给指定英雄添加该道具
		for j = 1, #oPlayer.heros, 1 do
			local oHero = oPlayer.heros[j]
			if (oHero.data.id == typeId) then --找到了
				local itemSkillT = oHero.data.itemSkillT
				local tabI = hVar.tab_item[itemId]
				if tabI.activeSkill then
					if (itemSkillT) and (tabI) then
						itemSkillT[#itemSkillT+1] =
						{
							activeItemId = itemId, --主动技能的CD
							activeItemLv = lv, --主动技能的等级
							activeItemNum = num, --主动技能的使用次数
							activeItemCD = tabI.activeSkill.cd[lv] or 0, --主动技能的CD
							activeItemLastCastTime = -math.huge, --主动技能的上次释放的时间（单位:毫秒）
						}
					end
					
					--读取缓存，是否有减cd的
					local itemSkillTCache = oHero.data.itemSkillTCache
					for jt = 1, #itemSkillTCache, 1 do
						local itemId_jt = itemSkillTCache[jt].itemId
						local itemCd_jt = itemSkillTCache[jt].itemCd
						if (itemId_jt == itemId) then --找到缓存了
							itemSkillT[#itemSkillT].activeItemCD = itemSkillT[#itemSkillT].activeItemCD + itemCd_jt
							--print("使用缓存cd", itemId, itemCd_jt)
							table.remove(itemSkillTCache, jt)
							
							break
						end
					end
				end
				--本地添加单个道具卡主动技能的界面
				local w = hGlobal.WORLD.LastWorldMap
				local me = w:GetPlayerMe()
				if (me == oPlayer) then
					if tabI.activeSkill then
						local tacticId = 0
						__CreateSingleActiveTacticCtrl(_frm, tacticId, itemId, lv, num, typeId)
						
						--拾取战术(道具)技能特殊事件
						if On_AddacticCard_Special_Event then
							--安全执行
							hpcall(On_AddacticCard_Special_Event, oPlayer, tacticId, itemId, oHero, __activeSkillNum)
							--On_AddacticCard_Special_Event(oPlayer, tacticId, itemId, oHero, __activeSkillNum)
						end
					end
					
					if tabI.passiveSkill then --存在被动技能，直接使用
						local u = oHero:getunit()
						if u then
							local unitX, unitY = hApi.chaGetPos(u.handle)
							local gridX, gridY = w:xy2grid(unitX, unitY)
							local tCastParam =
							{
								level = 1, --技能的等级
							}
							hApi.CastSkill(u, tabI.passiveSkill, 0, nil, nil, gridX, gridY, tCastParam)
						end
					else
						--获得道具
						--LuaAddItemToPlayerBag(itemId,nil,nil,0)
						--print("获得道具获得道具获得道具获得道具获得道具")
					end
					
					--[[
					--大菠萝不要这段文字
					--冒字
					if (not bIgnoreAnim) then
						local strText = "您获得：" .. (hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知道具" .. itemId)) --language
						--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 2000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0)
					end
					]]
				end
				
				break
			end
		end
		
		--[[
		--如果此道具绑定了战术卡，加战术卡碎片
		local tabI = hVar.tab_item[itemId]
		local itemTacticId = tabI.tacticId
		if itemTacticId and (itemTacticId > 0) then
			--LuaAddPlayerTacticDebris(itemTacticId, 1) --加战术卡碎片
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			local nStage = tInfo.stage or 1 --本关id
			if (tInfo.stageInfo == nil) then
				tInfo.stageInfo = {}
			end
			if (tInfo.stageInfo[nStage] == nil) then
				tInfo.stageInfo[nStage] = {}
			end
			local tacticInfo = tInfo.stageInfo[nStage]["tacticInfo"] or {} --本关地图内捡取的战术卡碎片信息
			local debrisNum = tacticInfo[itemTacticId] or 0
			debrisNum = debrisNum + 1
			
			--存储
			tacticInfo[itemTacticId] = debrisNum
			tInfo.stageInfo[nStage]["tacticInfo"] = tacticInfo --本关地图内捡取的战术卡碎片信息
			LuaSavePlayerList()
		end
		]]
	end)
	
	--移除玩家单个主动道具卡的主动技能界面
	hGlobal.event:listen("Event_RemoveTacticsActiveSkill", "__TD_RemoveTacticsActiveSkillRefresh", function(oPlayer, tacticId, itemId)
		--移除指定英雄身上的道具
		for j = 1, #oPlayer.heros, 1 do
			local oHero = oPlayer.heros[j]
			local typeId = oHero.data.id --英雄类型id
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				for k = 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					
					if (activeItemId == itemId) then --找到了
						--清除本英雄道具的数据
						table.remove(itemSkillT, k)
						
						--本地移除单个道具卡主动技能的界面
						local w = hGlobal.WORLD.LastWorldMap
						local me = w:GetPlayerMe()
						if (me == oPlayer) then
							--[[
							local TacticTotalNum = 0
							local tTactics = w:gettactics(oPlayer:getpos()) --本局所有的战术技能卡
							for i = 1, #tTactics, 1 do
								if (tTactics[i] ~= 0) then
									local id_i, lv_i, typeId_i = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
									local tabT = hVar.tab_tactics[id_i]
									local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
									if tabT then
										--local name = tabT.name --战术技能卡的名字
										--print(i, name, typeId_i)
										if (typeT == hVar.TACTICS_TYPE.OTHER) then --一般类战术技能卡
											local activeSkill = tabT.activeSkill
											local passiveSkill = tabT.skillId
											if activeSkill and (type(activeSkill) == "table") then
												TacticTotalNum = TacticTotalNum + 1
											end
										end
									end
								end
							end
							
							local tacticId = 0
							__RemoveSingleActiveItemCtrl(_frm, tacticId, itemId, TacticTotalNum + k)
							]]
							local TacticTotalNum = 0
							for h = 1, #w.data.tacticCardCtrls, 1 do
								local btn_h = w.data.tacticCardCtrls[h]
								if btn_h and (btn_h ~= 0) then
									local typeId_h = btn_h.data.typeId
									local itemId_h = btn_h.data.itemId --道具id
									if (typeId_h == typeId) and (itemId_h == itemId) then
										TacticTotalNum = h
										break
									end
								end
							end
							
							--print("TacticTotalNum=", TacticTotalNum)
							local tacticId = 0
							__RemoveSingleActiveItemCtrl(_frm, tacticId, itemId, TacticTotalNum)
						end
						
						return
					end
				end
			end
		end
	end)
	
	hGlobal.event:listen("Event_SetNewTacticsActiveSkill","__TD_SetNewTacticsActiveSkillRefresh",function(tList)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			
			for j = 1, #oPlayerMe.heros, 1 do
				local oHero = oPlayerMe.heros[j]
				if oHero then
					local itemSkillT = oHero.data.itemSkillT
					for z = #itemSkillT, hVar.NORMALATK_IDX + 1,-1 do
						if type(itemSkillT[z]) == "table" then
							--table_print(itemSkillT[z])
							local itemid = itemSkillT[z].activeItemId
							print("remove",z,itemid)
							hGlobal.event:event("Event_RemoveTacticsActiveSkill",oPlayerMe,0,itemid)
						end
					end
				end
			end
			
			local tacticId = 0
			for i = 1,#tList do
				local itemId,lv,num = unpack(tList[i])
				print(i,itemId,lv,num)
				hGlobal.event:event("Event_AddTacticsActiveSkill",oPlayerMe,itemId,lv,num,hVar.MY_TANK_ID,true)
				--__CreateSingleActiveTacticCtrl(_frm, tacticId, itemId, lv, hVar.MY_TANK_ID)
			end
		end
	end)
	
	--提前点击下一波按钮事件
	hGlobal.event:listen("Event_ClickNextWaveButtonInAdvance","__TD_MainTaticsSkillRefreshCd",function(earlyTime)
		__reduceTacticCD(earlyTime)
	end)
	
	--重置单个位置的主动战术(道具)技能卡的主动技能界面
	hGlobal.event:listen("Event_ResetSingleTactic", "__TD_ResetSingleTatic", function(activeSkillNum, tacticId, itemId, lv, num, typeId)
		--重置单个位置的主动战术(道具)技能卡的主动技能界面
		--__ResetSingleActiveTacticCtrl(_frm, activeSkillNum, tacticId, itemId, lv, num, typeId)
		
		--重绘
		__CreateSingleActiveTacticCtrl(_frm, tacticId, itemId, lv, num, typeId, activeSkillNum)
		
		--刷新冷却
		--__refreshTacticCDLab()
	end)
	
	--暂停菜单点击返回
	hGlobal.event:listen("Event_StartPauseSwitch", "__TD_PauseUIReturn", function(flag)
		--print("Event_StartPauseSwitch", flag, "pauseFlag=" .. pauseFlag)
		if flag then --暂停
			if (pauseFlag == -1) then --当前未暂停
				__CODE_ClickStartPause()
				pauseFlag = pauseFlag + 1
			end
		else --恢复
			--当前未恢复
			if (pauseFlag == 0) then
				__CODE_ClickStartPause()
				pauseFlag = pauseFlag - 1
			end
		end
	end)
	
	--设置游戏的层数
	hGlobal.event:listen("Event_UpdateGameRound", "__TD_UpdateGameRound", function(round)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			--铜雀台、新手地图的层数
			w.data.pvp_round_ahead = round
			w.data.pvp_round = round
			
			--w.data.tdMapInfo.totalWave = totalWave
			--w.data.tdMapInfo.wave = wave
			
			--设置游戏的层数回调函数
			if On_SetGameRound_Special_Event then
				--安全执行
				hpcall(On_SetGameRound_Special_Event, w, round)
				--On_SetGameRound_Special_Event(w, round)
			end
		end
	end)
	
	--显示游戏的波次等信息
	hGlobal.event:listen("LocalEvent_ShowWaveUI", "__TD_ShowWaveUI", function()
		labManaPrefix.handle._n:setVisible(true)
		labMana.handle._n:setVisible(true)
		labRound.handle._n:setVisible(false)
		labDifficulty.handle._n:setVisible(false)
	end)
	
	hGlobal.event:listen("LocalEvent_RefreshCurGameScore","TDSystemMenu__UpdateGameScore",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updateGold2(w, labGold)
		__updataCrystal(w, labCrystal)
	end)
	
	hGlobal.event:listen("Event_RandomMapRegionChanged","refreshLayerUI",function()
		local w = hGlobal.WORLD.LastWorldMap
		__updataLayer(w, labLayer)
	end)
	
	return labMana, labLife, labGold, labCrystal, labLayer
end

--hGlobal.UI.InitTDSystemMenu_Vertical = function(mode)
--	local tInitEventName = {"LocalEvent_ShowTDSystemMenuFrm_Vertical", "_show",}
--	if (mode ~= "include") then
--		return tInitEventName
--	end
--	
--	print("竖屏血条222222222222222222222222222")
--	
--	--清除监听事件
--	hGlobal.event:listen("LocalEvent_TD_NextWave", "__TD_SystemMenuFrm_Vertical", nil)
--	hGlobal.event:listen("LocalEvent_UpdateTankHp", "__TD_SystemMenuFrm_Vertical", nil)
--	hGlobal.event:listen("LocalEvent_MoveSystemMenuFrm","move", nil)
--	hGlobal.event:listen("LocalEvent_CloseTDSystemMenuFrm_Vertical","closefrm", nil)
--	hGlobal.event:listen("LocalEvent_VitrualControllerTouchBegin","Verticalfrm", nil)
--	--横竖屏切换（血条）
--	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFrm_Vertical", nil)
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],nil)
--	
--	local _frmW,_frmH
--	local _atk = nil
--	_frmH = hVar.SCREEN.vh
--	_frmW = hVar.SCREEN.vw
--	
--	local _frm,_parent,_childUI = nil,nil,nil
--	
--	local _CODE_ClearFunc = hApi.DoNothing
--	local _CODE_CreateFrm = hApi.DoNothing
--	local _CODE_CreateUI = hApi.DoNothing
--	local _CODE_GetControlMode = hApi.DoNothing
--	local _CODE_UpdateTankData = hApi.DoNothing
--	
--	_CODE_ClearFunc = function()
--		if hGlobal.UI.TDSystemMenuFrm_Vertical then
--			hGlobal.UI.TDSystemMenuFrm_Vertical:del()
--			hGlobal.UI.TDSystemMenuFrm_Vertical = nil
--		end
--		_frm,_parent,_childUI = nil,nil,nil
--	end
--	
--	_CODE_CreateFrm = function()
--		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.VERTICAL then
--			return
--		end
--		
--		hGlobal.UI.TDSystemMenuFrm_Vertical = hUI.frame:new({
--			x = 0,
--			y = _frmH,
--			w = _frmW,
--			h = _frmH,
--			background = -1,
--			--background = "misc/mask_white.png",
--			autoactive = 0,
--			dragable = 0,
--			show = 0,
--			z = -2,
--			buttononly = 1,
--		})
--		_frm = hGlobal.UI.TDSystemMenuFrm_Vertical
--		_parent = _frm.handle._n
--		_childUI = _frm.childUI
--		
--		_frm:show(1)
--		_frm:active()
--	end
--	
--	_CODE_CreateUI = function()
--		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.VERTICAL then
--			return
--		end
--		
--		local atktext = ""
--		if _atk then
--			atktext = "ATK  "..tostring(atktext)
--		end
--		local offy = - 120
--		if hVar.CONTROL_NOW == 0 then
--			--[[
--			_childUI["img_board"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/board.png",
--				x = _frmW/2,
--				y = -_frmH + 184 + offy,
--				w = 720,
--				z = -1.
--			})
--
--			_childUI["img_hp"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/icon_hp.png",
--				x = 76,
--				y = -_frmH + 222 + offy,
--			})
--			--]]
--
--			_childUI["vbar_hp"] = hUI.valbar:new({
--				parent = _parent,
--				model = "misc/verticalscreen/hp.png",
--				back = {model = "misc/verticalscreen/hp_bg.png", x=0, y=0, w=284, h=50},
--				x = 70,
--				y = -_frmH + 220 + offy,
--				w = 284,
--				h = 50,
--				align = "LC",
--			})
--
--			--[[
--			_childUI["img_atk"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/icon_atk.png",
--				x = 76,
--				y = -_frmH + 130 + offy,
--			})
--
--			_childUI["lab_atk"] = hUI.label:new({
--				parent = _parent,
--				font = hVar.FONTC,
--				size = 32,
--				text = atktext,
--				align = "LC",
--				width = 200,
--				x = 150,
--				y = -_frmH + 136 + offy,
--			})
--			--]]
--		else
--			local hpoffX = 260
--			local atkoffX = 260
--			--[[
--			_childUI["img_board"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/board.png",
--				x = _frmW/2,
--				y = -_frmH + 184 + offy,
--				w = 720,
--				z = -1.
--			})
--			_childUI["img_board"].handle.s:setFlipX(true)
--			
--			_childUI["img_hp"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/icon_hp.png",
--				x = 90 + hpoffX,
--				y = -_frmH + 222 + offy,
--			})
--			--]]
--
--			_childUI["vbar_hp"] = hUI.valbar:new({
--				parent = _parent,
--				model = "misc/verticalscreen/hp.png",
--				back = {model = "misc/verticalscreen/hp_bg.png", x=0, y=0, w=284, h=50},
--				x = 110 + hpoffX,
--				y = -_frmH + 220 + offy,
--				w = 284,
--				h = 50,
--				align = "LC",
--			})
--
--			--[[
--			_childUI["img_atk"] = hUI.image:new({
--				parent = _parent,
--				model = "misc/verticalscreen/icon_atk.png",
--				x = 90 + atkoffX,
--				y = -_frmH + 130 + offy,
--			})
--
--			_childUI["lab_atk"] = hUI.label:new({
--				parent = _parent,
--				font = hVar.FONTC,
--				size = 32,
--				text = atktext,
--				align = "LC",
--				width = 200,
--				x = 150 + atkoffX,
--				y = -_frmH + 136 + offy,
--			})
--			--]]
--		end
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld and _childUI then
--			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
--			local nForceMe = oPlayerMe:getforce() --我的势力
--			local oHero = oPlayerMe.heros[1]
--			if oHero then
--				hGlobal.event:event("LocalEvent_UpdateTankHp",oHero)
--			end
--		end
--	end
--	
--	_CODE_UpdateTankData = function()
--		print("_CODE_UpdateTankData")
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld and _childUI then
--			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
--			local nForceMe = oPlayerMe:getforce() --我的势力
--			local oHero = oPlayerMe.heros[1]
--			if oHero then
--				local oUnit = oHero:getunit()
--
--				if oUnit then
--					local HeroId = oUnit.data.id
--					local WeaponIdx = LuaGetHeroWeaponIdx(HeroId)
--					local tabU = hVar.tab_unit[HeroId]
--					local weapon_unit = tabU.weapon_unit or {} --单位武器列表
--					local tWeapon = weapon_unit[WeaponIdx] or {}
--					local weaponID = tWeapon.unitId or 0
--
--					local tabW = hVar.tab_unit[weaponID] or {}
--					
--					local attr = tabW.attr or {}
--					local attack = (attr.attack or {})[5] or "nodata"
--					_atk = attack
--
--					--_childUI["lab_atk"]:setText(tostring(attack))
--				end
--			end
--		end
--	end
--	
--	_CODE_GetControlMode = function()
--		if hVar.CONTROL_MODE == hVar.CONTROL_MODE_DEFINE.LOCAL_RIGHT then
--			hVar.CONTROL_NOW = 1
--		else
--			hVar.CONTROL_NOW = 0
--		end
--	end
--	
--	hGlobal.event:listen("LocalEvent_TD_NextWave", "__TD_SystemMenuFrm_Vertical", function()
--		_CODE_UpdateTankData()
--	end)
--	
--	hGlobal.event:listen("LocalEvent_UpdateTankHp", "__TD_SystemMenuFrm_Vertical", function(oHero)
--		if oHero and _childUI then
--			local oUnit = oHero:getunit("worldmap")
--			if oUnit~=nil then
--				local curP = oUnit.attr.hp
--				local maxP = oUnit:GetHpMax()
--				local precent = math.ceil(curP / maxP * 100)
--				_childUI["vbar_hp"]:setV(precent, 100)
--			end
--		end
--	end)
--	
--	hGlobal.event:listen("LocalEvent_MoveSystemMenuFrm","move",function(nIsEnable,bIngoreAction,nOffX,nOffY)
--		local w = hGlobal.WORLD.LastWorldMap
--		if w and _frm then
--			local timeAction = 0.8
--			local hx, hy = _frm.data.x, _frm.data.y
--			if (nIsEnable == 1) or (nIsEnable == true) then --允许响应事件
--				if bIngoreAction then
--					_frm:setXY(hx, hy + nOffY)
--				else
--					local act1 = CCEaseSineInOut:create(CCMoveBy:create(timeAction, ccp(0, nOffY)))
--					local act2 = CCCallFunc:create(function()
--						_frm:setXY(hx, hy + nOffY)
--					end)
--					local a = CCArray:create()
--					a:addObject(act1)
--					a:addObject(act2)
--					local sequence = CCSequence:create(a)
--					_frm.handle._n:runAction(sequence)
--				end
--			elseif (nIsEnable == 0) or (nIsEnable == false) then --禁止响应事件
--				_frm:setXY(hx, hy - nOffY)
--			end
--		end
--	end)
--	
--	hGlobal.event:listen("LocalEvent_CloseTDSystemMenuFrm_Vertical","closefrm",function()
--		_CODE_ClearFunc()
--		_atk = nil
--	end)
--	
--	hGlobal.event:listen("LocalEvent_VitrualControllerTouchBegin","Verticalfrm", function(screenX, screenY)
--		print(screenX, screenY)
--		if _frm and hVar.CONTROL_MODE == hVar.CONTROL_MODE_DEFINE.LOCAL_NO then
--			local newmode = 0
--			if screenX >= hVar.SCREEN.vw/2 then
--				newmode = 1
--			end
--			print(newmode,hVar.CONTROL_NOW)
--			if newmode ~= hVar.CONTROL_NOW then
--				hVar.CONTROL_NOW = newmode
--				_CODE_ClearFunc()
--				_CODE_CreateFrm()
--				_CODE_CreateUI()
--				_CODE_UpdateTankData()
--				hGlobal.event:event("LocalEvent_ChangeController")
--			end
--		end
--	end)
--	
--	--横竖屏切换（血条）
--	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFrm_Vertical", function()
--		local w = hGlobal.WORLD.LastWorldMap
--		if w then
--			if w.data.map == hVar.LoginMap then
--				return
--			end
--			if w.data.map == hVar.MainBase then
--				return
--			end
--		end
--		
--		--重绘界面
--		hGlobal.UI.InitTDSystemMenu_Vertical("include")
--		
--		hGlobal.event:event("LocalEvent_ShowTDSystemMenuFrm_Vertical")
--	end)
--	
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
--		local w = hGlobal.WORLD.LastWorldMap
--		if w then
--			if w.data.map == hVar.LoginMap then
--				return
--			end
--		end
--		--if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.VERTICAL then
--		--	return
--		--end
--		_CODE_ClearFunc()
--		_CODE_GetControlMode()
--		_CODE_CreateFrm()
--		_CODE_CreateUI()
--	end)
--end

--怪物信息提示面板
hGlobal.UI.InitMonsterTipFrm = function()
	local _w,_h = 400, 300
	local _x,_y = hVar.SCREEN.w/2 - _w / 2, hVar.SCREEN.h/2 + _h / 2
	
	local _scoreLabX = 0
	local _scoreLabY = 0
	
	local __monsterIndex = 0
	local __monsters = nil
	local __refreshMonsterInfo = hApi.DoNothing
	local __nextMonster = hApi.DoNothing
	
	local _frm
	hGlobal.UI.MonsterTipFrm = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		dragable = 2,
		show = 0,
		border = 0,
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			if IsInside == 0 then
				if not __nextMonster() then
					self:show(0)
					hGlobal.event:event("Event_StartPauseSwitch", false)
				end
			end
		end,
	})
	
	_frm = hGlobal.UI.MonsterTipFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	_childUI["btnOk"] =  hUI.button:new({
		parent	= _parent,
		dragbox = _frm.childUI["dragBox"],
		--model	= "BTN:PANEL_CLOSE",
		x = _w / 2,
		y = -_h + 45,
		z = 1,
		label = hVar.tab_string["__TEXT_Close"],
		scaleT	= 0.9,
		code = function()
			if not __nextMonster() then
				_frm:show(0)
				
				hGlobal.event:event("Event_StartPauseSwitch", false)
			end
		end,
	})
	
	--通用名称
	_childUI["labName"] = hUI.label:new({
		parent = _parent,
		size = 36,
		align = "MC",
		font = hVar.FONTC,
		x = 240,
		y = -60,
		border = 1,
		text = "name",
	})
	_childUI["labName"].handle.s:setColor(ccc3(255,255,0))
	
	--通用图标
	_childUI["imgIcon"] = hUI.image:new({
		parent = _parent,
		model = "",
		x = 80,
		y = -100,
		scale = 2.5,
	})
	
	
	
	--文字提示
	_childUI["labInfo"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LC",
		font = hVar.FONTC,
		x = 30,
		y = -165,
		width = 360,
		border = 1,
		text = hVar.tab_string["__LvNowAttr"],
	})
	
	__refreshMonsterInfo = function()
		local ret = false
		if __monsterIndex <= 0 or __monsterIndex > #__monsters then
			_childUI["btnOk"]:setText(hVar.tab_string["__TEXT_Close"])
			return ret
		end
		local monsterId = __monsters[__monsterIndex]
		local model = hVar.tab_unit[monsterId].model
		local name = hVar.tab_stringU[monsterId][1]
		local info = hVar.tab_string["TipU"..monsterId]
		
		_childUI["imgIcon"]:setmodel(model)
		_childUI["imgIcon"].handle._n:setScale(1.2)
		_childUI["labInfo"]:setText(info)
		_childUI["labName"]:setText(name)
		
		if __monsterIndex == #__monsters then
			_childUI["btnOk"]:setText(hVar.tab_string["__TEXT_Close"])
		elseif __monsterIndex < #__monsters then
			_childUI["btnOk"]:setText(hVar.tab_string["__TEXT_NextPage"])
		end
		
		ret = true
		return ret
	end
	
	__nextMonster = function()
		__monsterIndex = __monsterIndex + 1
		return __refreshMonsterInfo()
	end
	
	hGlobal.event:listen("LocalEvent_showMonsterInfoFrm","__showMonsterInfoFrm",function()
		
		local w = hGlobal.WORLD.LastWorldMap
		if not w then
			return
		end
		
		local mapInfo = w.data.tdMapInfo
		if not mapInfo then
			return
		end
		
		local monsterTip = mapInfo.monsterTip
		if not monsterTip then
			return
		end
		
		local wave = mapInfo.wave
		
		if monsterTip[wave] and type(monsterTip[wave]) == "table" then
			local showFlag = false
			
			--初始化全局信息
			__monsterIndex = 0
			__monsters = {}
			
			for i = 1, #monsterTip[wave] do
				if monsterTip[wave][i] and hVar.tab_unit[monsterTip[wave][i]] then
					__monsters[#__monsters + 1] = monsterTip[wave][i]
					showFlag = true
				end
			end
			
			if showFlag then
				__monsterIndex = 1
				if __refreshMonsterInfo() then
					_frm:show(1)
					_frm:active()
					hGlobal.event:event("Event_StartPauseSwitch", true)
				end
			end
		end
		
		
		
		
	end)
	
end

----如果在黄巾之乱中击杀过程远志 则进行判断
--function LuaCheckShareBtnState()
--	local state_killboss = LuaGetPlayerMapAchi("world/level_hjzl",hVar.ACHIEVEMENT_TYPE.KILLSMOEBOSS)
--	local state_level = LuaGetPlayerMapAchi("world/level_hjzl",hVar.ACHIEVEMENT_TYPE.LEVEL)
--	if state_killboss == 1 or state_level == 1 then
--		return 1,hVar.tab_string["__TEXT_Can_use_share"]
--	else
--		return 0,hVar.tab_string["__TEXT_Can_not_use_share"]
--	end
--end

hGlobal.UI.InitBossWarningFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowBossWarningFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _showNum = 0
	local _posList = {}
	local _barList = {}
	local _line = 0
	local _offH = 0
	local _showid = 0
	local _showmode = 0
	local _showParam = {}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateWarningBar = hApi.DoNothing
	local _CODE_CreateShowInfo = hApi.DoNothing
	local _CODE_WarningBarManager = hApi.DoNothing

	_CODE_ClearFunc = function()
		hApi.clearTimer("WarningBarManager")
		hApi.clearTimer("ClearWarningBarManager")
		if hGlobal.UI.BossWarningFrm then
			hGlobal.UI.BossWarningFrm:del()
			hGlobal.UI.BossWarningFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_showNum = 0
		_posList = {}
		_barList = {}
		_showid = 0
		_showmode = 0
		_showParam = {}
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.BossWarningFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			--z = -1,
			buttononly = 1,
		})
		_frm = hGlobal.UI.BossWarningFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			RGB = {255,0,0},
			z = -1,
		})
		_childUI["_blackpanel"].handle.s:setOpacity(80)

		_frm:show(1)
		_frm:active()
	end

	_CODE_WarningBarManager = function()
		local starttime = hApi.gametime()
		_line = math.floor(hVar.SCREEN.h/180)
		_offH = math.floor(hVar.SCREEN.h/_line)

		local totaltime = 1800
		local spacetime = 260
		local endtime_ex = 600
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			totaltime = 1500
			spacetime = 150
			endtime_ex = 200
		end

		hApi.PlaySound("warning")
		
		hApi.addTimerForever("WarningBarManager", hVar.TIMER_MODE.GAMETIME, spacetime, function()
			for i = 1,1 do
				local index = #_barList + 1
				local timer = math.random(20,100)/1000
				local movespeed = math.random(2000,3000)/1000
				if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
					timer = math.random(40,90)/1000
					movespeed = math.random(800,2000)/1000
				end
				local node = _CODE_CreateWarningBar(index)
				local curtime = hApi.gametime()
				_barList[index] = node
				local act1 = CCDelayTime:create(timer)
				local act2 = CCMoveTo:create(movespeed, ccp(-400, node.data.y))
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				node.handle._n:runAction(CCRepeatForever:create(sequence))
				--if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
					--if #_posList >= _line*0.75 then
						--table.remove(_posList,1)
					--end
				--else
					if #_posList == _line then
						table.remove(_posList,1)
					end
				--end
				if curtime - starttime > totaltime then
					hApi.clearTimer("WarningBarManager")
					hApi.addTimerOnce("ClearWarningBarManager",totaltime + endtime_ex,function()
						_CODE_ClearFunc()
					end)
				end
			end
		end)
	end

	_CODE_CreateWarningBar = function(index)
		local list = {}
		local nowlist = {}
		for i = 1,#_posList do
			nowlist[_posList[i]] = 1
		end
		for i = 1,_line do
			if nowlist[i] == nil then
				list[#list+1] = i
			end
		end
		local newi = math.random(1,#list)
		_posList[#_posList+1] = list[newi]
		local x = hVar.SCREEN.w + 400
		local y = - (list[newi] - 0.5) * _offH
		_childUI["node"..index] = hUI.node:new({
			parent = _parent,
			x = x,
			y = y,
		})

		local nodeChildUI = _childUI["node"..index].childUI
		local nodeParent = _childUI["node"..index].handle._n

		nodeChildUI["bar"] = hUI.image:new({
			parent = nodeParent,
			model = "misc/addition/warning.png",
			x = 0,
			y = 0,
		})

		_CODE_CreateShowInfo(_childUI["node"..index])
		return _childUI["node"..index]
	end

	_CODE_CreateShowInfo = function(node)
		local nodeChildUI = node.childUI
		local nodeParent = node.handle._n

		if _showmode == "icon" then
			local sModel = "misc/button_null.png"
			if _showid ~= 0 then
				--sModel = string.format("icon/hero/boss_%02d.png", _showid)
				local tabU = hVar.tab_unit[_showid]
				if tabU and tabU.icon then
					sModel = tabU.icon
				end
			end
			nodeChildUI["img_show"] = hUI.image:new({
				parent = nodeParent,
				model = _showParam.model or sModel,
				x = _showParam.x or - 230,
				y = _showParam.y or 0,
				scale = _showParam.scale or 1.5,
			})
			if _showParam.FlipX then
				nodeChildUI["img_show"].handle.s:setFlipX(true)
			end
		elseif _showmode == "name" then
			local unitname = LuaGetObjectName(_showid,1)
			print("unitname",unitname)
			nodeChildUI["lab_show"] = hUI.label:new({
				parent = nodeParent,
				text = _showParam.text or unitname,
				align = _showParam.align or "MC",
				x = _showParam.x or - 230,
				y = _showParam.y or 0,
				size = _showParam.size or 44,
				font = _showParam.font or hVar.FONTC,
				RGB = _showParam.RGB or {255, 255, 255},
			})
		elseif _showmode == "model" then
			local tabU = hVar.tab_unit[_showid]
			if tabU and tabU.model then
				--sModel = tabU.icon
				nodeChildUI["modle_show"] = hUI.thumbImage:new({
					parent = nodeParent,
					id = _showid,
					x = _showParam.x or - 230,
					y = _showParam.y or - 20,
					facing = _showParam.facing or 225,
					scale = _showParam.scale or 1,
				})
			end
			
		end
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","BossWarningFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nshowid,nshowmode,tshowParam)
		_CODE_ClearFunc()
		_showid = nshowid
		_showmode = nshowmode or "model"
		_showParam = tshowParam or {}
		_CODE_CreateFrm()
		_CODE_WarningBarManager()
	end)
end

hGlobal.UI.InitTacticsBuffIconFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowTacticsBuffIconFrm","ShowFrm"}
	if mode ~= "include" then
		--return tInitEventName
	end

	local _herofrm,_heroparent,_herochildUI = nil,nil,nil
	local _frm,_parent,_childUI = nil,nil,nil
	local _oTankUnit = nil

	local _buffdata = {}
	local _defData = {}

	local _tDefUI = {
		[hVar.AuraBuffType.DEF_PHYSICAL] = {"ICON:SKILL_SET02_01",1,nil,"def_physic"},
		[hVar.AuraBuffType.DEF_POISON] = {"ICON:SKILL_SET02_06",3,hVar.DAMAGE_TYPE.POISON,"def_poison"},
		[hVar.AuraBuffType.DEF_FIRE] = {"ICON:SKILL_SET02_05",2,hVar.DAMAGE_TYPE.FIRE,"def_fire"},
		[hVar.AuraBuffType.DEF_THUNDER] = {"ICON:SKILL_SET02_07",4,hVar.DAMAGE_TYPE.THUNDER,"def_thunder"},
		--[hVar.AuraBuffType.DEF_BOMB] = {"icon/skill/def_bomb.png",5},
	}
	
	local _tGrenadeUI = {
		[hVar.AuraBuffType.GRENADE_CHILD] = {"icon/skill/grenade_child.png",{0,-60}},
		--[hVar.AuraBuffType.GRENADE_CRIT] = {"icon/skill/grenade_crit.png",{0,-60}},
		[hVar.AuraBuffType.GRENADE_FIRE] = {"icon/skill/grenade_fire.png",{35,-40}},
		[hVar.AuraBuffType.GRENADE_NUM] ={"icon/skill/grenade_num.png",{-37,-40}},
		--[hVar.AuraBuffType.GRENADE_DIS] ={"icon/skill/grenade_dis.png",{0,0}},
	}
	--竖屏
	if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
		_tGrenadeUI = {
			[hVar.AuraBuffType.GRENADE_CHILD] = {"icon/skill/grenade_child.png",{-1,-78}},
			--[hVar.AuraBuffType.GRENADE_CRIT] = {"icon/skill/grenade_crit.png",{0,-60}},
			[hVar.AuraBuffType.GRENADE_FIRE] = {"icon/skill/grenade_fire.png",{46,-52}},
			[hVar.AuraBuffType.GRENADE_NUM] ={"icon/skill/grenade_num.png",{-48,-53}},
			--[hVar.AuraBuffType.GRENADE_DIS] ={"icon/skill/grenade_dis.png",{0,0}},
		}
	end
	
	local _tUIList = {}
	
	local _CODE_ClearUI = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateHpUI = hApi.DoNothing
	local _CODE_CreateWeaponUI = hApi.DoNothing
	local _CODE_RefreshUI = hApi.DoNothing
	local _CODE_RefreshDef = hApi.DoNothing
	local _CODE_GetData = hApi.DoNothing
	local _CODE_GetDefData = hApi.DoNothing

	local _CODE_UIAction = hApi.DoNothing
	
	_CODE_ClearUI = function()
		for i = 1,#_tUIList do
			hApi.safeRemoveT(_tUIList[i][1],_tUIList[i][2])
		end
		_tUIList = {}
		_buffdata = {}
		_defData = {}
	end

	_CODE_ClearFunc = function()
		hApi.clearTimer("__UI_RefreshHpUIDef")
		_CODE_ClearUI()
		_oTankUnit = nil
		_frm,_parent,_childUI = nil,nil,nil
		_herofrm,_heroparent,_herochildUI = nil,nil,nil
	end

	_CODE_CreateWeaponUI = function()
		if hGlobal.UI.TDSystemMenuBar then
			_frm = hGlobal.UI.TDSystemMenuBar
			_parent = _frm.handle._n
			_childUI = _frm.childUI

			local ctrl = _frm.childUI["btnTactics_"..hVar.TANKSKILL_IDX]
			if ctrl then
				local x = ctrl.data.x
				local y = ctrl.data.y
				local w = ctrl.data.w
				local h = ctrl.data.h
				print(x,y,w,h)

				for typeindex,tab in pairs(_tGrenadeUI) do
					local icon,pos = unpack(tab)
					--hApi.safeRemoveT(_childUI,"img_grenade"..typeindex)
					_childUI["img_grenade"..typeindex] = hUI.image:new({
						parent = _parent,
						x = x + (pos[1] or 0),
						y = y + (pos[2] or 0),
						model = icon,
						scale = 1.2,
					})
					hApi.AddShader(_childUI["img_grenade"..typeindex].handle.s, "gray")
					--_childUI["img_grenade"..typeindex].handle._n:setVisible(false)
					_tUIList[#_tUIList+1] = {_childUI,"img_grenade"..typeindex}
				end
				
			end
		end
	end

	_CODE_CreateHpUI = function()
		if hGlobal.UI.HeroFrame then
			_herofrm = hGlobal.UI.HeroFrame
			_heroparent = _herofrm.handle._n
			_herochildUI = _herofrm.childUI

			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]

			if oHero and oHero.heroUI["hpBar_back"] then
				local x = oHero.heroUI["hpBar_back"].data.x
				local y = oHero.heroUI["hpBar_back"].data.y
				local w = oHero.heroUI["hpBar_back"].data.w
				local h = oHero.heroUI["hpBar_back"].data.h
				--print(x,y,w,h)

				local startX = x - w / 2
				local startY = y + h / 2

				for typeindex,tab in pairs(_tDefUI) do
					local icon,index = unpack(tab)
				--	hApi.safeRemoveT(_herochildUI,"img_def"..index)
					_herochildUI["img_def"..typeindex] = hUI.image:new({
						parent = _heroparent,
						x = startX + index * 96 - 10,
						y = startY - 32,
						model = icon,
						scale = 0.4,
					})
					_tUIList[#_tUIList+1] = {_herochildUI,"img_def"..typeindex}
					--hApi.AddShader(_herochildUI["img_def"..index].handle.s, "gray")

				--	hApi.safeRemoveT(_herochildUI,"lab_def"..index)
					_herochildUI["lab_def"..typeindex] = hUI.label:new({
						parent = _heroparent,
						--text = "x"..math.random(1,15),
						size = 16,
						font = "num",
						align = "LC",
						x = startX + index * 96 + 8,
						y = startY - 30,
						w = 100,
					})
					_tUIList[#_tUIList+1] = {_herochildUI,"lab_def"..typeindex}
				end
			end
		end
	end

	_CODE_CreateUI = function()
		_CODE_CreateHpUI()
		_CODE_CreateWeaponUI()
		_CODE_RefreshUI()
	end

	_CODE_RefreshUI = function()
		local tGrenadeCount = _CODE_GetData()
--		for typeindex,lv in pairs(tDefCount) do
--			local tab = _tDefUI[typeindex]
--			if tab and _herochildUI then
--				
--				local index = tab[2]
--				if _herochildUI["img_def"..index] then
--					hApi.AddShader(_herochildUI["img_def"..index].handle.s, "normal")
--					_herochildUI["lab_def"..index]:setText(tostring(lv))
--				end
--			end
--		end
		for typeindex,lv in pairs(tGrenadeCount) do
			local tab = _tGrenadeUI[typeindex]
			if tab and _childUI and _childUI["img_grenade"..typeindex] then
				hApi.AddShader(_childUI["img_grenade"..typeindex].handle.s, "normal")
			end
		end
		--table_print(tDefCount)
		--table_print(tGrenadeCount)
	end

	_CODE_GetDefData = function()
		--local tattr = hApi.GetUnitAttrsByHeroCard(hVar.MY_TANK_ID)
		for typeindex,tab in pairs(_tDefUI) do
			local attr = tab[4]
			local index = tab[2]
			--local value = tattr[attr] or 0
			local t = {}
			hApi.ReadUnitValue(t,attr,_oTankUnit,"Attr",attr)
			local value = t[attr] or 0
			local showanimtion = false
			if _defData[typeindex] then
				local oldvalue = _defData[typeindex][1]
				if oldvalue ~= value then
					showanimtion = true
				end
			end
			_defData[typeindex] = {value,showanimtion,index}
		end
		return _defData
	end

	_CODE_RefreshDef = function()
		if _herofrm then
			local defData = _CODE_GetDefData()
			for typeindex,tab in pairs(defData) do
				local value,showanimation = unpack(tab)
				if _herochildUI["lab_def"..typeindex] then
					_herochildUI["lab_def"..typeindex]:setText(tostring(value))
				end
				if showanimation then
					_CODE_UIAction(typeindex)
				end
			end
		end
--			local tab = _tDefUI[typeindex]
--			if tab and _herochildUI then
--				
--				local index = tab[2]
--				if _herochildUI["img_def"..index] then
--					hApi.AddShader(_herochildUI["img_def"..index].handle.s, "normal")
--					_herochildUI["lab_def"..index]:setText(tostring(lv))
--				end
--			end
--		end
	end

	_CODE_GetData = function()
		--local tDefCount = {}
		local tGrenadeCount = {}
		local tInfo = GameManager.GetGameInfo("auraInfo")
		for i = 1,#tInfo do
			local id = tInfo[i].id
			local lv = tInfo[i].lv
			
			local tabA = hVar.tab_aura[id]

			if tabA and type(tabA.bufftype) == "number" and tabA.bufftype > 0 then
				--if type(_tDefUI[tabA.bufftype]) == "table" then
					--tDefCount[tabA.bufftype] = lv + (tDefCount[tabA.bufftype] or 0)
					--_buffdata[tabA.bufftype] = tDefCount[tabA.bufftype]
				--end
				if type(_tGrenadeUI[tabA.bufftype]) == "table" then
					tGrenadeCount[tabA.bufftype] = lv + (tGrenadeCount[tabA.bufftype] or 0)
					_buffdata[tabA.bufftype] = tGrenadeCount[tabA.bufftype]
				end
			end
		end
		return tGrenadeCount
	end

	_CODE_UIAction = function(mode)
		local tInfo = _tDefUI[mode]
		if tInfo then
			local icon,index = unpack(tInfo)
			if _herochildUI and _herochildUI["img_def"..mode] then
				hApi.safeRemoveT(_herochildUI,"img_defaction"..mode)
				_herochildUI["img_defaction"..mode] = hUI.image:new({
					parent = _heroparent,
					x = _herochildUI["img_def"..mode].data.x,
					y = _herochildUI["img_def"..mode].data.y,
					model = icon,
					scale = _herochildUI["img_def"..mode].data.scale,
				})
				_tUIList[#_tUIList+1] = {_herochildUI,"img_defaction"..mode}

				_herochildUI["img_defaction"..mode].handle.s:runAction(CCFadeOut:create(0.5))		--淡入
				_herochildUI["img_defaction"..mode].handle.s:runAction(CCScaleTo:create(0.5,0.64))
			end
		end
	end

--	hGlobal.event:listen("Event_UnitDamaged", "TacticsBuffIconFrm", function(oDmgUnit, skillId, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
--		if _herofrm == nil then
--			return
--		end
--		
--		if (oDmgUnit.data.id == hVar.MY_TANK_ID) then
--			for typeindex,tab in pairs(_tDefUI) do
--				local icon,index,typemode = unpack(tab)
--				if typemode and typemode == mode then
--					_CODE_UIAction(typeindex)
--				end
--			end
--		end
--	end)

	hGlobal.event:listen("LocalEvent_HideTacticsBuffIconFrm","hide",function(bool)
		if _childUI then
			for typeindex,tab in pairs(_tGrenadeUI) do
				if _childUI["img_grenade"..typeindex] then
					_childUI["img_grenade"..typeindex].handle._n:setVisible(bool)
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_TDGameBegin","TacticsBuffIconFrm",function()
		hGlobal.event:event("LocalEvent_ShowTacticsBuffIconFrm")
	end)

	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","TacticsBuffIconFrm",function()
		_CODE_ClearFunc()
		hGlobal.event:event("LocalEvent_ShowTacticsBuffIconFrm")
	end)

	hGlobal.event:listen("LocalEvent_ClearTacticsBuffIcon","clear",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_RefreshTacticsBuffIcon","refresh",function()
		_CODE_RefreshUI()
	end)

	hGlobal.event:listen("Event_HeroEnterMap","TacticsBuffIconFrm",function(oHero,oUnit)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld == nil then
			return
		end
		if _frm then
			local me = oWorld:GetPlayerMe()
			if oHero and me and oHero:getowner()==me then
				_oTankUnit = oUnit
			end
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld == nil then
			return
		end
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				_oTankUnit = oUnit
				--_CODE_GetDefData()
				_CODE_CreateUI()
				_CODE_RefreshUI()
				oWorld:addtimer("__UI_RefreshHpUIDef", 100, function()
					_CODE_RefreshDef()
				end)
			end
		end
	end)
end
















