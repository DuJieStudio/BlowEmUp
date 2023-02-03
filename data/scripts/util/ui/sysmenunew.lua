

--[=[
----游戏内的弹出暂停的菜单
--hGlobal.UI.InitSystemMenuNewFram = function()
--	local _y,_interval = -120,75
--	hGlobal.UI.SystemMenuNewFram = hUI.frame:new({
--		x = hVar.SCREEN.w/2 - 240,
--		y = hVar.SCREEN.h/2 + 200,
--		w = 512,
--		h = 368,
--		dragable = 2,
--		--closebtn = "BTN:PANEL_CLOSE",
--		--closebtnX = 470,
--		--closebtnY = -14,
--		show = 0,
--		border = 0,
--		background = -1,
--		codeOnTouch = function(self,x,y,sus)
--			if sus == 0 then
--				hGlobal.event:event("Event_StartPauseSwitch", false)
--				self:show(0)
--			end
--		end,
--	})
--	
--	local _frm = hGlobal.UI.SystemMenuNewFram
--	local _parent = _frm.handle._n
--	local _childUI = _frm.childUI
--	
--	_childUI["apartline_back"] = hUI.image:new({
--		parent = _parent,
--		model = "misc/addition/menu_bg.png",
--		x = _frm.data.w/2,
--		y = -_frm.data.h/2,
--		w = 512,
--		h = 368,
--	})
--	
--	--仅允许在大地图上打开此界面
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideSystemMenuNewFrm",function(sSceneType,oWorld,oMap)
--		if sSceneType~="worldmap" then
--			if _frm~=nil then
--				_frm:show(0)
--			end
--		end
--	end)
--	
--	--加载3个按钮
--	--重玩本关
--	_childUI["playerList"] = hUI.button:new({
--		parent = _parent,
--		model = "misc/addition/menu_btn_reply.png",
--		--icon = "ui/bimage_replay.png",
--		--iconWH = 36,
--		--label = hVar.tab_string["__TEXT_ResetLevel"],
--		--font = hVar.FONTC,
--		--border = 1,
--		dragbox = _frm.childUI["dragBox"],
--		x = _frm.data.w/2 - 60,
--		y = _y-_interval*0 + 5,
--		--w = 200,
--		scaleT = 0.95,
--		code = function(self)
--			--如果是无尽模式，那么不允许重玩本关
--			local w = hGlobal.WORLD.LastWorldMap
--			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
--				hGlobal.event:event("Event_StartPauseSwitch", false)
--				_frm:show(0)
--				
--				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ENDLESS_DISBALE_REPLY"],{
--					font = hVar.FONTC,
--					ok = function()
--						--
--					end,
--				})
--				
--				return
--			end
--			
--			--如果是pvp模式，那么不允许重玩本关
--			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
--				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_DISBALE_REPLY"],{
--					font = hVar.FONTC,
--					ok = function()
--						--
--					end,
--				})
--				
--				return
--			end
--			
--			--hGlobal.event:event("LocalEvent_NextDayBreathe",0)
--			_frm:show(0)
--			--print("游戏内点菜单重玩1")
--			
--			--[[
--			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ResetGameTip"],{
--				font = hVar.FONTC,
--				ok = function()
--					--geyachao: 先存档
--					--存档
--					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					
--					--关闭同步日志文件
--					hApi.SyncLogClose()
--					--关闭非同步日志文件
--					hApi.AsyncLogClose()
--					
--					local mapname = hGlobal.WORLD.LastWorldMap.data.map
--					local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
--					local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--					
--					if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
--						
--						hGlobal.WORLD.LastWorldMap:del()
--						hGlobal.WORLD.LastWorldMap = nil
--						
--						hGlobal.LocalPlayer:setfocusworld(nil)
--						hApi.clearCurrentWorldScene()
--					end
--					
--					xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
--				end,
--				--cancel = 1,
--				cancel = function()
--					hGlobal.event:event("Event_StartPauseSwitch", false)
--					_frm:show(0)
--				end,
--			})
--			]]
--			--geyachao: 先存档
--			--大菠萝，不用弹框提示，直接重玩本关
--			--存档
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--			
--			--关闭同步日志文件
--			hApi.SyncLogClose()
--			--关闭非同步日志文件
--			hApi.AsyncLogClose()
--			
--			local mapname = hGlobal.WORLD.LastWorldMap.data.map
--			local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
--			local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--			
--			if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
--				
--				hGlobal.WORLD.LastWorldMap:del()
--				hGlobal.WORLD.LastWorldMap = nil
--				
--				hGlobal.LocalPlayer:setfocusworld(nil)
--				hApi.clearCurrentWorldScene()
--			end
--			
--			--大菠萝数据初始化
--			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
--			
--			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
--		end,
--	})
--	--_childUI["playerList"].childUI["label"].handle._n:setPosition(-45,15)
--	--_childUI["playerList"].childUI["icon"].handle._n:setPosition(-65,1)
--	
--	--返回游戏大厅
--	_childUI["selectedlevel"] = hUI.button:new({
--		parent = _parent,
--		model = "misc/addition/menu_btn_return.png",
--		--icon = "ui/hall.png",
--		--iconWH = 31,
--		--label = hVar.tab_string["__TEXT_GameHall"],
--		--font = hVar.FONTC,
--		--border = 1,
--		dragbox = _frm.childUI["dragBox"],
--		x = _frm.data.w/2 - 83,
--		y = _y-_interval*1 - 50,
--		--w = 200,
--		scaleT = 0.95,
--		code = function()
--			--geyachao: 先存档
--			--存档
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--			
--			--关闭同步日志文件
--			hApi.SyncLogClose()
--			--关闭非同步日志文件
--			hApi.AsyncLogClose()
--			
--			--隐藏可能的选人界面
--			if hGlobal.UI.PhoneSelectedHeroFrm2 then
--				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
--				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
--				hApi.clearTimer("__SELECT_HERO_UPDATE__")
--				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
--				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
--			end
--			
--			local w = hGlobal.WORLD.LastWorldMap
--			local map = w.data.map
--			local tabM = hVar.MAP_INFO[map]
--			local chapterId = 1
--			if tabM then
--				chapterId = tabM.chapter or 1
--			end
--			--todo zhenkira 这里以后要读取当前地图所在章节进行切换
--			
--			--zhenkira 注释
--			--if g_vs_number > 4 and g_lua_src == 1 then
--			--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
--			--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
--			--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
--			--	end
--			--end
--			
--			--if hGlobal.WORLD.LastTown~=nil then
--			--	hGlobal.WORLD.LastTown:del()
--			--end
--			
--			--zhenkira 注释
--			local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
--			if (hGlobal.WORLD.LastWorldMap ~= nil) then
--				--存储地图模式
--				currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
--				
--				local mapname = hGlobal.WORLD.LastWorldMap.data.map
--				--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
--				--	print(".."..nil)
--				--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
--				--end
--				hGlobal.WORLD.LastWorldMap:del()
--				
--				hGlobal.LocalPlayer:setfocusworld(nil)
--				hApi.clearCurrentWorldScene()
--			end
--			
--			--[[
--			--无尽地图、pvp，返回新主界面
--			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
--				--切换到新主界面事件
--				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--			else
--				--zhenkira 注释
--				--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--				--zhenkira 新增
--				--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
--				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
--				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
--				
--				--大菠萝
--				--切换到新主界面事件
--				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--			end
--			]]
--			
--			--大菠萝数据初始化
--			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
--			
--			--切换到配置坦克地图
--			local mapname = hVar.MainBase
--			local MapDifficulty = 0
--			local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
--			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
--			
--			_frm:show(0)
--		end,
--	})
--	--_childUI["selectedlevel"].childUI["label"].handle._n:setPosition(-45,15)
--	--_childUI["selectedlevel"].childUI["icon"].handle._n:setPosition(-65,1)
--	
--	--返回按钮
--	--_childUI["returngame"] = hUI.button:new({
--		--parent = _parent,
--		--model = "misc/addition/menu_btn_back.png",
--		----icon = "ui/hall.png",
--		----iconWH = 31,
--		----label = hVar.tab_string["__TEXT_Back"],
--		----font = hVar.FONTC,
--		----border = 1,
--		--dragbox = _frm.childUI["dragBox"],
--		--x = _frm.data.w/2 - 105,
--		--y = _y-_interval*3 + 68,
--		----w = 200,
--		--scaleT = 0.95,
--		--code = function()
--			--hGlobal.event:event("Event_StartPauseSwitch", false)
--			--_frm:show(0)
--		--end,
--	--})
--	--_childUI["returngame"].childUI["label"].handle._n:setPosition(-25,15)
--	--_childUI["returngame"].childUI["icon"].handle._n:setPosition(-65,1)
--	
--	local _CODE_SwitchSoundEnable = function(IsSwitch)
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
--			if _childUI["soundenable"] then
--				_childUI["soundenable"]:loadsprite("UI:horn_open")
--			end
--		else
--			if _childUI["soundenable"] then
--				_childUI["soundenable"]:loadsprite("UI:horn_close")
--			end
--		end
--	end
--	
--	--[[
--	_childUI["soundenable"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:horn_open",
--		--icon = "UI:shopitemxg",
--		--iconWH = 68,
--		dragbox = _frm.childUI["dragBox"],
--		x = _frm.data.w-48,
--		y = -1*_frm.data.h+48,
--		scaleT = 0.9,
--		code = function(self)
--			_CODE_SwitchSoundEnable(1)
--		end,
--	})
--	]]
--	
--	--只在内网有效
--	--if (IAPServerIP == g_lrc_Ip) then --内网
--		--geyachao: 测试flag
--		_childUI["openflag"] = hUI.button:new({
--			parent = _parent,
--			model = "ui/giftkey.png",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48 - 5,
--			y = -1*_frm.data.h+48 + 110 * 2 + 15,
--			label = {x = 0, y = -38, text = "调试", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 58,
--			h = 58,
--			scaleT = 0.95,
--			code = function(self)
--				OpenFlag()
--				
--				if (self.data.nIsShowDebug == 0) then
--					--打开调试
--					self.data.nIsShowDebug = 1
--					
--					self.childUI["label"]:setText("调试(开)")
--					self.childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
--					
--					_childUI["opensuccess"]:setstate(1)
--					_childUI["playaction"]:setstate(1)
--				else
--					--关闭调试
--					self.data.nIsShowDebug = 0
--					
--					self.childUI["label"]:setText("调试(关)")
--					self.childUI["label"].handle.s:setColor(ccc3(255, 0, 0))
--					
--					_childUI["opensuccess"]:setstate(-1)
--					_childUI["playaction"]:setstate(-1)
--				end
--			end,
--		})
--		_childUI["openflag"].data.nIsShowDebug = 0
--		_childUI["openflag"]:setstate(-1) --默认不显示
--		
--		--直接胜利
--		_childUI["opensuccess"] = hUI.button:new({
--			parent = _parent,
--			model = "ui/icon01_x14y3.png",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48 - 5 + 90,
--			y = -1*_frm.data.h+48 + 110 * 2 + 15,
--			label = {x = 0, y = -38, text = "通关", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 52,
--			h = 52,
--			scaleT = 0.95,
--			code = function(self)
--				--隐藏菜单
--				hGlobal.event:event("Event_StartPauseSwitch", false)
--				_frm:show(0)
--				
--				--冒字
--				local strText = "直接通关！"
--				hUI.floatNumber:new({
--					x = hVar.SCREEN.w / 2,
--					y = hVar.SCREEN.h / 2,
--					align = "MC",
--					text = "",
--					lifetime = 1000,
--					fadeout = -550,
--					moveY = 32,
--				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
--				
--				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
--					--快速游戏结束
--					local w = hGlobal.WORLD.LastWorldMap
--					
--					--如果游戏暂停，直接跳出循环
--					if w then
--						if (w.data.IsPaused == 1) then
--							return
--						end
--						
--						hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
--						
--						--直接胜利
--						local mapInfo = w.data.tdMapInfo
--						if mapInfo then
--							--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
--							mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
--						end
--						
--						--给英雄加经验值
--						if Save_PlayerData and Save_PlayerData.herocard then
--							for i = 1, #Save_PlayerData.herocard, 1 do
--								local id = Save_PlayerData.herocard[i].id
--								--LuaAddHeroExp(id, 100000)
--							end
--						end
--						
--						--加积分
--						--LuaAddPlayerScore(100000)
--						
--						--存档
--						LuaSaveHeroCard()
--					end
--				end)
--			end,
--		})
--		_childUI["opensuccess"]:setstate(-1) --默认不显示
--		
--		--演示动画
--		_childUI["playaction"] = hUI.button:new({
--			parent = _parent,
--			model = "ui/button_resume.png",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48 - 5 + 90 | 90,
--			y = -1*_frm.data.h+48 + 110 * 2 + 15,
--			label = {x = 0, y = -38, text = "动画", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 52,
--			h = 52,
--			scaleT = 0.95,
--			code = function(self)
--				--隐藏菜单
--				hGlobal.event:event("Event_StartPauseSwitch", false)
--				_frm:show(0)
--				
--				local oWorld = hGlobal.WORLD.LastWorldMap
--				oWorld:removetimer("__TD__Camera_Follow_")
--				
--				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
--					hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
--					
--					--开场动画
--					local oUnit = oWorld:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
--					
--					--释放技能
--					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
--					local gridX, gridY = oWorld:xy2grid(targetX, targetY)
--					local skillId = 16004 --开场动画技能
--					local skillLv = 1
--					local tCastParam = {level = skillLv,}
--					hApi.CastSkill(oUnit, skillId, 0, nil, nil, gridX, gridY, tCastParam)
--				end)
--			end,
--		})
--		_childUI["playaction"]:setstate(-1) --默认不显示
--		
--		--[[
--		--geyachao: 测试直接通关
--		_childUI["successBtn"] = hUI.button:new({
--			parent = _parent,
--			model = "ui/ok.png",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48,
--			y = -1*_frm.data.h+48 + 110 * 1,
--			label = {x = 0, y = -38, text = "通关", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 64,
--			h = 64,
--			scaleT = 0.9,
--			code = function(self)
--				--隐藏菜单
--				hGlobal.event:event("Event_StartPauseSwitch", false)
--				_frm:show(0)
--				
--				--冒字
--				local strText = "直接通关！"
--				hUI.floatNumber:new({
--					x = hVar.SCREEN.w / 2,
--					y = hVar.SCREEN.h / 2,
--					align = "MC",
--					text = "",
--					lifetime = 1000,
--					fadeout = -550,
--					moveY = 32,
--				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
--				
--				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
--					--快速游戏结束
--					local w = hGlobal.WORLD.LastWorldMap
--					
--					--如果游戏暂停，直接跳出循环
--					if w then
--						if (w.data.IsPaused == 1) then
--							return
--						end
--						
--						hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
--						
--						--直接胜利
--						local mapInfo = w.data.tdMapInfo
--						if mapInfo then
--							--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
--							mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
--						end
--						
--						--给英雄加经验值
--						if Save_PlayerData and Save_PlayerData.herocard then
--							for i = 1, #Save_PlayerData.herocard, 1 do
--								local id = Save_PlayerData.herocard[i].id
--								LuaAddHeroExp(id, 100000)
--							end
--						end
--						
--						--加积分
--						LuaAddPlayerScore(100000)
--						
--						--存档
--						LuaSaveHeroCard()
--					end
--				end)
--				
--			end,
--		})
--		]]
--		
--		--[[
--		--geyachao: 测试镜头跟随
--		local CAMERA_FOLLOW_HERO_STATE = 0
--		_childUI["cameraFollowBtn"] = hUI.button:new({
--			parent = _parent,
--			model = "misc/mask.png",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48 - 380,
--			y = -1*_frm.data.h+48 + 110 * 2,
--			label = {x = 0, y = -38, text = "镜头", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 64,
--			h = 64,
--			scaleT = 0.9,
--			code = function(self)
--				--切换
--				if (CAMERA_FOLLOW_HERO_STATE == 1) then
--					--镜头不跟随英雄
--					CAMERA_FOLLOW_HERO_STATE = 0
--					
--					_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/close.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
--					
--					--取消设置镜头
--					local world = hGlobal.WORLD.LastWorldMap
--					if world then
--						world:removetimer("__TD__Camera_Follow_")
--					end
--				else
--					--镜头跟随英雄
--					CAMERA_FOLLOW_HERO_STATE = 1
--					
--					_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/ok.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
--					
--					--设置镜头
--					local world = hGlobal.WORLD.LastWorldMap
--					if world then
--						world:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
--							local oHero = world:GetPlayerMe().heros[1]
--							if oHero then
--								local oUnit = oHero:getunit()
--								if oUnit then
--									local px, py = hApi.chaGetPos(oUnit.handle)
--									--聚焦
--									hApi.setViewNodeFocus(px, py)
--								end
--							end
--						end)
--					end
--				end
--			end,
--		})
--		_childUI["cameraFollowBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
--		_childUI["cameraFollowBtn"].childUI["icon"] = hUI.image:new({ --图标
--			parent = _childUI["cameraFollowBtn"].handle._n,
--			model = "ICON:skill_icon_x14y9",
--			x = 0,
--			y = 0,
--			w = 54,
--			h = 54,
--		})
--		_childUI["cameraFollowBtn"].childUI["state"] = hUI.image:new({ --状态
--			parent = _childUI["cameraFollowBtn"].handle._n,
--			model = "misc/close.png",
--			x = 12,
--			y = -12,
--			w = 24,
--			h = 24,
--		})
--		if (CAMERA_FOLLOW_HERO_STATE == 1) then
--			_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/ok.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
--		else
--			_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/close.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
--		end
--		]]
--		
--		--[[
--		--geyachao: 测试自杀
--		_childUI["suicideBtn"] = hUI.button:new({
--			parent = _parent,
--			model = "ICON:skill_icon_x1y7",
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = _frm.data.w-48 - 380,
--			y = -1*_frm.data.h+48 + 110 * 1,
--			label = {x = 0, y = -38, text = "自杀", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
--			w = 56,
--			h = 56,
--			scaleT = 0.9,
--			code = function(self)
--				local world = hGlobal.WORLD.LastWorldMap
--				if world then
--					--隐藏菜单
--					hGlobal.event:event("Event_StartPauseSwitch", false)
--					_frm:show(0)
--					
--					--加钱
--					local gold = 10000
--					--world.data.tdMapInfo.gold = world.data.tdMapInfo.gold + gold
--					world:GetPlayerMe():addresource(hVar.RESOURCE_TYPE.GOLD, gold)
--					
--					--加漏怪次数
--					local life = 1000
--					local force = world:GetPlayerMe():getforce()
--					local forcePlayer = world:GetForce(force)
--					forcePlayer:addresource(hVar.RESOURCE_TYPE.LIFE, life)
--					hGlobal.event:event("Event_TdLifeChangeRefresh")
--					--world.data.tdMapInfo.life = world.data.tdMapInfo.life + life
--					--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.LIFE, life)
--					
--					hApi.addTimerOnce("suicideBtn", 200, function()
--						--自杀
--						local heros = world:GetPlayerMe().heros
--						for i = 1, #heros, 1 do
--							local oUnit = heros[i]:getunit()
--							if oUnit then
--								--特效
--								--544 546
--								local worldX, worldY = hApi.chaGetPos(oUnit.handle)
--								local effect_id = 448 --特效id 402 414 442
--								local eff = world:addeffect(effect_id, 1.5 ,nil, worldX, worldY) --56
--								
--								--死亡
--								oUnit:dead()
--								
--							end
--						end
--						
--						if (#heros > 0) then
--							--雷劈音效
--							hApi.PlaySound("hit_lightning")
--							
--							--死亡音效
--							hApi.addTimerOnce("suicideBtn_dead", 250, function()
--								--音效
--								hApi.PlaySound("mansroar1")
--							end)
--						end
--						
--						--冒字
--						local strText = "您因为装b，被雷劈死了！"
--						hUI.floatNumber:new({
--							x = hVar.SCREEN.w / 2,
--							y = hVar.SCREEN.h / 2,
--							align = "MC",
--							text = "",
--							lifetime = 1000,
--							fadeout = -550,
--							moveY = 32,
--						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
--					end)
--				end
--			end,
--		})
--		]]
--	--end
--	
--	--[[
--	--程序版本号
--	_childUI["programm_version"] = hUI.label:new({
--		parent = _parent,
--		font = hVar.FONTC,
--		size = 32,
--		text = hVar.tab_string["__TEXT_GamePause"],
--		align = "MC",
--		border = 1,
--		x = _frm.data.w/2,
--		y = -35,
--	})
--	]]
--	
--	hGlobal.event:listen("localEvent_ShowNewSysFrm", "showthisfrm", function()
--		--print("localEvent_ShowNewSysFrm")
--		--zhenkira
--		
--		_childUI["dragBox"]:sortbutton()
--		_CODE_SwitchSoundEnable()
--		
--		_childUI["playerList"]:setstate(1)
--		_childUI["selectedlevel"]:setstate(1)
--		--_childUI["returngame"]:setstate(1)
--		
--		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
--			_childUI["openflag"]:setstate(1) --调试按钮
--			_childUI["openflag"].data.nIsShowDebug = 0
--		else
--			_childUI["openflag"]:setstate(-1) --调试按钮
--			
--			
--			--调试模式，都能看
--			--测试 --test
--			_childUI["openflag"]:setstate(1) --调试按钮
--			_childUI["openflag"].data.nIsShowDebug = 0
--			
--		end
--		
--		_frm:show(1)
--		_frm:active()
--		
--		hGlobal.event:event("Event_StartPauseSwitch", true)
--		
--		--[[
--		--geyachao: 调试代码专用弹框
--		--测试 --test
--		--local texture_ui = CCTextureCache:sharedTextureCache():textureForKey("data/image/ui.png")
--		local texture_pvp = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/pvp.pvr.ccz")
--		local sprite_res_money = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("data/image/ui/pvp/res_money.png")
--		
--		local strText = "sprite_res_money=" .. tostring(sprite_res_money) .. ",count=" .. tostring((sprite_res_money and sprite_res_money:retainCount())) .. "\n" .. "texture_pvp=" .. tostring(texture_pvp) .. ",count=" .. tostring((texture_pvp and texture_pvp:retainCount()))
--		hGlobal.UI.MsgBox(strText,{
--			font = hVar.FONTC,
--			ok = function()
--				xlLoadResourceFromPList("data/image/misc/pvp.plist")
--			end,
--		})
--		]]
--	end)
--end
]=]
--游戏内的弹出暂停的菜单
hGlobal.UI.InitSystemMenuNewFram = function()
	local _y,_interval = -120,75
	hGlobal.UI.SystemMenuNewFram = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 240,
		y = hVar.SCREEN.h/2 + 200,
		w = 512,
		h = 368,
		dragable = 2,
		--closebtn = "BTN:PANEL_CLOSE",
		--closebtnX = 470,
		--closebtnY = -14,
		show = 0,
		border = 0,
		background = -1,
		codeOnTouch = function(self,x,y,sus)
			if sus == 0 then
				hGlobal.event:event("Event_StartPauseSwitch", false)
				self:show(0)
			end
		end,
	})
	
	local _frm = hGlobal.UI.SystemMenuNewFram
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--[[
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "misc/addition/menu_bg.png",
		x = _frm.data.w/2,
		y = -_frm.data.h/2,
		w = 512,
		h = 368,
	})
	]]
	hApi.CCScale9SpriteCreate("data/image/misc/skillup/msgbox4.png", _frm.data.w/2, -_frm.data.h/2, 512, 620, _frm)
	
	--仅允许在大地图上打开此界面
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideSystemMenuNewFrm",function(sSceneType,oWorld,oMap)
		if sSceneType~="worldmap" then
			if _frm~=nil then
				_frm:show(0)
			end
		end
	end)
	
	--加载3个按钮
	--重玩本关
	_childUI["playerList"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/menu_btn_reply.png",
		--icon = "ui/bimage_replay.png",
		--iconWH = 36,
		--label = hVar.tab_string["__TEXT_ResetLevel"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 60,
		y = _y-_interval*0 + 5 + 150,
		--w = 200,
		scaleT = 0.95,
		code = function(self)
			--如果是无尽模式，那么不允许重玩本关
			local w = hGlobal.WORLD.LastWorldMap
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_frm:show(0)
				
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ENDLESS_DISBALE_REPLY"],{
					font = hVar.FONTC,
					ok = function()
						--
					end,
				})
				
				return
			end
			
			--如果是pvp模式，那么不允许重玩本关
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_DISBALE_REPLY"],{
					font = hVar.FONTC,
					ok = function()
						--
					end,
				})
				
				return
			end
			
			--hGlobal.event:event("LocalEvent_NextDayBreathe",0)
			_frm:show(0)
			--print("游戏内点菜单重玩1")
			
			--[[
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ResetGameTip"],{
				font = hVar.FONTC,
				ok = function()
					--geyachao: 先存档
					--存档
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					
					--关闭同步日志文件
					hApi.SyncLogClose()
					--关闭非同步日志文件
					hApi.AsyncLogClose()
					
					local mapname = hGlobal.WORLD.LastWorldMap.data.map
					local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
					local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
					
					if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
						
						hGlobal.WORLD.LastWorldMap:del()
						hGlobal.WORLD.LastWorldMap = nil
						
						hGlobal.LocalPlayer:setfocusworld(nil)
						hApi.clearCurrentWorldScene()
					end
					
					xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
				end,
				--cancel = 1,
				cancel = function()
					hGlobal.event:event("Event_StartPauseSwitch", false)
					_frm:show(0)
				end,
			})
			]]
			--geyachao: 先存档
			--大菠萝，不用弹框提示，直接重玩本关
			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()

			local diablodata = hGlobal.LocalPlayer.data.diablodata
			if diablodata and type(diablodata.randMap) == "table" then
				local nRandMapId = 1
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				--阶段1不存储信息
				if tInfo.id then
					nRandMapId = tInfo.id or nRandMapId
				end
				LuaClearPlayerRandMapInfo(g_curPlayerName)
				if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
					
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
					hGlobal.LocalPlayer:setfocusworld(nil)
					hApi.clearCurrentWorldScene()
				end
				hGlobal.event:event("LocalEvent_EnterRandMap",nRandMapId,1)
			else
			
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
				local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
				
				if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
					
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
					hGlobal.LocalPlayer:setfocusworld(nil)
					hApi.clearCurrentWorldScene()
				end
				
				--大菠萝数据初始化
				hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
				
				xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
			end
		end,
	})
	--_childUI["playerList"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["playerList"].childUI["icon"].handle._n:setPosition(-65,1)
	
	--返回游戏大厅
	_childUI["selectedlevel"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/menu_btn_return.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 83,
		y = _y-_interval*1 - 50 + 190,
		--w = 200,
		scaleT = 0.95,
		code = function()
			local diablodata = hGlobal.LocalPlayer.data.diablodata
			if diablodata and type(diablodata.randMap) == "table" then
				_frm:show(0)

				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				
				--关闭同步日志文件
				hApi.SyncLogClose()
				--关闭非同步日志文件
				hApi.AsyncLogClose()
				
				--隐藏可能的选人界面
				if hGlobal.UI.PhoneSelectedHeroFrm2 then
					hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
					hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
					hApi.clearTimer("__SELECT_HERO_UPDATE__")
					hApi.clearTimer("__SELECT_TOWER_UPDATE__")
					hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
				end

				local tInfos = {
					{"lifecount",0},
				}
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)

				local bResult = false
				TD_OnGameOver_Diablo(bResult)
				
				--大菠萝游戏结束,刷新界面
				local nResult = 0
				hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
				return
			end
			--geyachao: 先存档
			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			
			--隐藏可能的选人界面
			if hGlobal.UI.PhoneSelectedHeroFrm2 then
				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
				hApi.clearTimer("__SELECT_HERO_UPDATE__")
				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
			end
			
			local w = hGlobal.WORLD.LastWorldMap
			local map = w.data.map
			local tabM = hVar.MAP_INFO[map]
			local chapterId = 1
			if tabM then
				chapterId = tabM.chapter or 1
			end
			--todo zhenkira 这里以后要读取当前地图所在章节进行切换
			
			--zhenkira 注释
			--if g_vs_number > 4 and g_lua_src == 1 then
			--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
			--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
			--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
			--	end
			--end
			
			--if hGlobal.WORLD.LastTown~=nil then
			--	hGlobal.WORLD.LastTown:del()
			--end
			
			--zhenkira 注释
			local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				--存储地图模式
				currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
				
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
				--	print(".."..nil)
				--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				--end
				hGlobal.WORLD.LastWorldMap:del()
				
				hGlobal.LocalPlayer:setfocusworld(nil)
				hApi.clearCurrentWorldScene()
			end
			
			--[[
			--无尽地图、pvp，返回新主界面
			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
				--切换到新主界面事件
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			else
				--zhenkira 注释
				--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				--zhenkira 新增
				--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
				
				--大菠萝
				--切换到新主界面事件
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			end
			]]
			
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			--切换到配置坦克地图
			local mapname = hVar.MainBase
			local MapDifficulty = 0
			local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
			
			_frm:show(0)
		end,
	})
	--_childUI["selectedlevel"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["selectedlevel"].childUI["icon"].handle._n:setPosition(-65,1)
	
	--返回按钮
	--_childUI["returngame"] = hUI.button:new({
		--parent = _parent,
		--model = "misc/addition/menu_btn_back.png",
		----icon = "ui/hall.png",
		----iconWH = 31,
		----label = hVar.tab_string["__TEXT_Back"],
		----font = hVar.FONTC,
		----border = 1,
		--dragbox = _frm.childUI["dragBox"],
		--x = _frm.data.w/2 - 105,
		--y = _y-_interval*3 + 68,
		----w = 200,
		--scaleT = 0.95,
		--code = function()
			--hGlobal.event:event("Event_StartPauseSwitch", false)
			--_frm:show(0)
		--end,
	--})
	--_childUI["returngame"].childUI["label"].handle._n:setPosition(-25,15)
	--_childUI["returngame"].childUI["icon"].handle._n:setPosition(-65,1)
	
	local _CODE_SwitchSoundEnable = function(IsSwitch)
		if IsSwitch==1 then
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hVar.OPTIONS.PLAY_SOUND = 0
				hVar.OPTIONS.PLAY_SOUND_BG = 0
			else
				hVar.OPTIONS.PLAY_SOUND = 1
				hVar.OPTIONS.PLAY_SOUND_BG = 1
			end
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hApi.EnableSoundBG(1)
				hApi.PlaySound("button")
			else
				hApi.EnableSoundBG(0)
			end
			hApi.SaveGameOptions()
		end
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("UI:horn_open")
			end
		else
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("UI:horn_close")
			end
		end
	end
	
	--[[
	_childUI["soundenable"] = hUI.button:new({
		parent = _parent,
		model = "UI:horn_open",
		--icon = "UI:shopitemxg",
		--iconWH = 68,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w-48,
		y = -1*_frm.data.h+48,
		scaleT = 0.9,
		code = function(self)
			_CODE_SwitchSoundEnable(1)
		end,
	})
	]]
	
	--只在内网有效
	--if (IAPServerIP == g_lrc_Ip) then --内网
		--geyachao: 测试flag
		_childUI["openflag"] = hUI.button:new({
			parent = _parent,
			model = "ui/giftkey.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5,
			y = -1*_frm.data.h+48 + 110 * 2 + 15,
			label = {x = 0, y = -38, text = "调试", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 58,
			h = 58,
			scaleT = 0.95,
			code = function(self)
				if (self.data.nIsShowDebug == 0) then
					--打开调试
					self.data.nIsShowDebug = 1
					
					OpenFlag()
					
					self.childUI["label"]:setText("调试(开)")
					self.childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
					
					_childUI["opensuccess"]:setstate(1)
					_childUI["playaction"]:setstate(1)
					_childUI["selectmap"]:setstate(1)
					_childUI["camerascroll_add"]:setstate(1)
					_childUI["camerascroll_minus"]:setstate(1)
					--_childUI["lowconfigmode"]:setstate(1)
					--_childUI["map1"]:setstate(1)
					--_childUI["map2"]:setstate(1)
					--_childUI["map3"]:setstate(1)
					--_childUI["map4"]:setstate(1)
					--_childUI["map5"]:setstate(1)
					--_childUI["map6"]:setstate(1)
				else
					--关闭调试
					self.data.nIsShowDebug = 0
					
					CloseFlag()
					
					self.childUI["label"]:setText("调试(关)")
					self.childUI["label"].handle.s:setColor(ccc3(255, 0, 0))
					
					_childUI["opensuccess"]:setstate(-1)
					_childUI["playaction"]:setstate(-1)
					_childUI["selectmap"]:setstate(-1)
					_childUI["camerascroll_add"]:setstate(-1)
					_childUI["camerascroll_minus"]:setstate(-1)
					--_childUI["lowconfigmode"]:setstate(-1)
					--_childUI["map1"]:setstate(-1)
					--_childUI["map2"]:setstate(-1)
					--_childUI["map3"]:setstate(-1)
					--_childUI["map4"]:setstate(-1)
					--_childUI["map5"]:setstate(-1)
					--_childUI["map6"]:setstate(-1)
				end
			end,
		})
		_childUI["openflag"].data.nIsShowDebug = 0
		_childUI["openflag"]:setstate(-1) --默认不显示
		
		--直接胜利
		_childUI["opensuccess"] = hUI.button:new({
			parent = _parent,
			model = "ui/icon01_x14y3.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5 + 90,
			y = -1*_frm.data.h+48 + 110 * 2 + 15,
			label = {x = 0, y = -38, text = "通关", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 52,
			h = 52,
			scaleT = 0.95,
			code = function(self)
				--隐藏菜单
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_frm:show(0)
				
				--冒字
				local strText = "直接通关！"
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				
				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
					--快速游戏结束
					local w = hGlobal.WORLD.LastWorldMap
					
					--如果游戏暂停，直接跳出循环
					if w then
						if (w.data.IsPaused == 1) then
							return
						end
						
						hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
						
						--新手引导图，弹出黑龙对话框
						--print("w.data.map=", w.data.map)
						if (w.data.map == hVar.GuideMap) then
							--弹出二选一的操作界面
							hApi.ShowSelectMsgBox(2, {text = hVar.tab_string["__TEXT_BLACK_DRAGON_4"], size = 28, tomap = "world/yxys_spider_01", tomapmode = hVar.MAP_TD_TYPE.NORMAL,}, {text = hVar.tab_string["__TEXT_BLACK_DRAGON_5"], size = 28, tomap = hVar.MainBase, tomapmode = hVar.MAP_TD_TYPE.TANKCONFIG,})
						else
							--直接胜利
							local mapInfo = w.data.tdMapInfo
							if mapInfo then
								--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
								mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
							end
							
							--给英雄加经验值
							if Save_PlayerData and Save_PlayerData.herocard then
								for i = 1, #Save_PlayerData.herocard, 1 do
									local id = Save_PlayerData.herocard[i].id
									--LuaAddHeroExp(id, 100000)
								end
							end
							
							--加积分
							--LuaAddPlayerScore(100000)
							
							--存档
							LuaSaveHeroCard()
						end
					end
				end)
			end,
		})
		_childUI["opensuccess"]:setstate(-1) --默认不显示
		
		--演示动画
		_childUI["playaction"] = hUI.button:new({
			parent = _parent,
			model = "ui/button_resume.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5 + 90 * 2,
			y = -1*_frm.data.h+48 + 110 * 2 + 15,
			label = {x = 0, y = -38, text = "动画", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 52,
			h = 52,
			scaleT = 0.95,
			code = function(self)
				--隐藏菜单
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_frm:show(0)
				
				local oWorld = hGlobal.WORLD.LastWorldMap
				oWorld:removetimer("__TD__Camera_Follow_")
				
				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
					hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
					
					--开场动画
					local oUnit = oWorld:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
					
					--释放技能
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = oWorld:xy2grid(targetX, targetY)
					local skillId = 16004 --开场动画技能
					local skillLv = 1
					local tCastParam = {level = skillLv,}
					hApi.CastSkill(oUnit, skillId, 0, nil, nil, gridX, gridY, tCastParam)
				end)
			end,
		})
		_childUI["playaction"]:setstate(-1) --默认不显示
		
		--镜头+
		local m_fScale = 1.0
		_childUI["camerascroll_add"] = hUI.button:new({
			parent = _parent,
			model = "ui/button_resume.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5 + 90 * 0,
			y = -1*_frm.data.h+48 + 110 * 2 - 89 - 89,
			label = {x = 0, y = -38, text = "镜头+", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 52,
			h = 52,
			scaleT = 0.95,
			code = function(self)
				m_fScale = m_fScale + 0.1
				xlView_SetScale(m_fScale)
			end,
		})
		_childUI["camerascroll_add"]:setstate(-1) --默认不显示
		
		--镜头-
		_childUI["camerascroll_minus"] = hUI.button:new({
			parent = _parent,
			model = "ui/button_resume.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5 + 90 * 1,
			y = -1*_frm.data.h+48 + 110 * 2 - 89 - 89,
			label = {x = 0, y = -38, text = "镜头-", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 52,
			h = 52,
			scaleT = 0.95,
			code = function(self)
				if (m_fScale > 0) then
					m_fScale = m_fScale - 0.1
					xlView_SetScale(m_fScale)
				end
			end,
		})
		_childUI["camerascroll_minus"]:setstate(-1) --默认不显示
		
		_childUI["selectmap"] = hUI.button:new({
			parent = _parent,
			model = "ui/vip_1.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5,
			y = -1*_frm.data.h+48 + 110 * 2 + 15 - 96,
			label = {x = 0, y = -38, text = "作弊管理", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 58,
			h = 58,
			scaleT = 0.95,
			code = function(self)
				--hGlobal.event:event("LocalEvent_ShowSelectMapFrm")
				hGlobal.event:event("LocalEvent_ShowCheatManagerFrm")
			end
		})
		_childUI["selectmap"]:setstate(-1)
		
		--[[
		--低配模式
		_childUI["lowconfigmode"] = hUI.button:new({
			parent = _parent,
			model = "ui/vip_1.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 5 + 90,
			y = -1*_frm.data.h+48 + 110 * 2 + 15 - 89,
			label = {x = 0, y = -38, text = "低配模式", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 58,
			h = 58,
			scaleT = 0.95,
			code = function(self)
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_frm:show(0)
				
				hVar.TICK_TIME = 48
				hVar.CLIENT_FPS = 20
				xlSetFPSInterval(hVar.CLIENT_FPS)
				
				--重玩本关
				--大菠萝，不用弹框提示，直接重玩本关
			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()

			local diablodata = hGlobal.LocalPlayer.data.diablodata
			if diablodata and type(diablodata.randMap) == "table" then
				local nRandMapId = 1
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				--阶段1不存储信息
				if tInfo.id then
					nRandMapId = tInfo.id or nRandMapId
				end
				LuaClearPlayerRandMapInfo(g_curPlayerName)
				if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
					
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
					hGlobal.LocalPlayer:setfocusworld(nil)
					hApi.clearCurrentWorldScene()
				end
				hGlobal.event:event("LocalEvent_EnterRandMap",nRandMapId,1)
			else
			
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
				local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
				
				if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
					
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
					hGlobal.LocalPlayer:setfocusworld(nil)
					hApi.clearCurrentWorldScene()
				end
				
				--大菠萝数据初始化
				hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
				
				xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
			end
				
			end
		})
		_childUI["lowconfigmode"]:setstate(-1)
		]]
		
		--[[
		--geyachao: 测试直接通关
		_childUI["successBtn"] = hUI.button:new({
			parent = _parent,
			model = "ui/ok.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48,
			y = -1*_frm.data.h+48 + 110 * 1,
			label = {x = 0, y = -38, text = "通关", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 64,
			h = 64,
			scaleT = 0.9,
			code = function(self)
				--隐藏菜单
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_frm:show(0)
				
				--冒字
				local strText = "直接通关！"
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				
				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
					--快速游戏结束
					local w = hGlobal.WORLD.LastWorldMap
					
					--如果游戏暂停，直接跳出循环
					if w then
						if (w.data.IsPaused == 1) then
							return
						end
						
						hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
						
						--直接胜利
						local mapInfo = w.data.tdMapInfo
						if mapInfo then
							--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
							mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
						end
						
						--给英雄加经验值
						if Save_PlayerData and Save_PlayerData.herocard then
							for i = 1, #Save_PlayerData.herocard, 1 do
								local id = Save_PlayerData.herocard[i].id
								LuaAddHeroExp(id, 100000)
							end
						end
						
						--加积分
						LuaAddPlayerScore(100000)
						
						--存档
						LuaSaveHeroCard()
					end
				end)
				
			end,
		})
		]]
		
		--[[
		--geyachao: 测试镜头跟随
		local CAMERA_FOLLOW_HERO_STATE = 0
		_childUI["cameraFollowBtn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 380,
			y = -1*_frm.data.h+48 + 110 * 2,
			label = {x = 0, y = -38, text = "镜头", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 64,
			h = 64,
			scaleT = 0.9,
			code = function(self)
				--切换
				if (CAMERA_FOLLOW_HERO_STATE == 1) then
					--镜头不跟随英雄
					CAMERA_FOLLOW_HERO_STATE = 0
					
					_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/close.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
					
					--取消设置镜头
					local world = hGlobal.WORLD.LastWorldMap
					if world then
						world:removetimer("__TD__Camera_Follow_")
					end
				else
					--镜头跟随英雄
					CAMERA_FOLLOW_HERO_STATE = 1
					
					_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/ok.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
					
					--设置镜头
					local world = hGlobal.WORLD.LastWorldMap
					if world then
						world:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
							local oHero = world:GetPlayerMe().heros[1]
							if oHero then
								local oUnit = oHero:getunit()
								if oUnit then
									local px, py = hApi.chaGetPos(oUnit.handle)
									--聚焦
									hApi.setViewNodeFocus(px, py)
								end
							end
						end)
					end
				end
			end,
		})
		_childUI["cameraFollowBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
		_childUI["cameraFollowBtn"].childUI["icon"] = hUI.image:new({ --图标
			parent = _childUI["cameraFollowBtn"].handle._n,
			model = "ICON:skill_icon_x14y9",
			x = 0,
			y = 0,
			w = 54,
			h = 54,
		})
		_childUI["cameraFollowBtn"].childUI["state"] = hUI.image:new({ --状态
			parent = _childUI["cameraFollowBtn"].handle._n,
			model = "misc/close.png",
			x = 12,
			y = -12,
			w = 24,
			h = 24,
		})
		if (CAMERA_FOLLOW_HERO_STATE == 1) then
			_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/ok.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
		else
			_childUI["cameraFollowBtn"].childUI["state"]:setmodel("misc/close.png", nil, nil, _childUI["cameraFollowBtn"].childUI["state"].data.w, _childUI["cameraFollowBtn"].childUI["state"].data.h)
		end
		]]
		
		--[[
		--geyachao: 测试自杀
		_childUI["suicideBtn"] = hUI.button:new({
			parent = _parent,
			model = "ICON:skill_icon_x1y7",
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = _frm.data.w-48 - 380,
			y = -1*_frm.data.h+48 + 110 * 1,
			label = {x = 0, y = -38, text = "自杀", size = 20, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
			w = 56,
			h = 56,
			scaleT = 0.9,
			code = function(self)
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					--隐藏菜单
					hGlobal.event:event("Event_StartPauseSwitch", false)
					_frm:show(0)
					
					--加钱
					local gold = 10000
					--world.data.tdMapInfo.gold = world.data.tdMapInfo.gold + gold
					world:GetPlayerMe():addresource(hVar.RESOURCE_TYPE.GOLD, gold)
					
					--加漏怪次数
					local life = 1000
					local force = world:GetPlayerMe():getforce()
					local forcePlayer = world:GetForce(force)
					forcePlayer:addresource(hVar.RESOURCE_TYPE.LIFE, life)
					hGlobal.event:event("Event_TdLifeChangeRefresh")
					--world.data.tdMapInfo.life = world.data.tdMapInfo.life + life
					--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.LIFE, life)
					
					hApi.addTimerOnce("suicideBtn", 200, function()
						--自杀
						local heros = world:GetPlayerMe().heros
						for i = 1, #heros, 1 do
							local oUnit = heros[i]:getunit()
							if oUnit then
								--特效
								--544 546
								local worldX, worldY = hApi.chaGetPos(oUnit.handle)
								local effect_id = 448 --特效id 402 414 442
								local eff = world:addeffect(effect_id, 1.5 ,nil, worldX, worldY) --56
								
								--死亡
								oUnit:dead()
								
							end
						end
						
						if (#heros > 0) then
							--雷劈音效
							hApi.PlaySound("hit_lightning")
							
							--死亡音效
							hApi.addTimerOnce("suicideBtn_dead", 250, function()
								--音效
								hApi.PlaySound("mansroar1")
							end)
						end
						
						--冒字
						local strText = "您因为装b，被雷劈死了！"
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
					end)
				end
			end,
		})
		]]
	--end
	
	--[[
	--程序版本号
	_childUI["programm_version"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 32,
		text = hVar.tab_string["__TEXT_GamePause"],
		align = "MC",
		border = 1,
		x = _frm.data.w/2,
		y = -35,
	})
	]]
	
	--直接通关按钮
	_childUI["btnSuccess"] = hUI.button:new({
		parent = _parent,
		model = "misc/skillup/goldnum_bg.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 83 + 13,
		y = _y-_interval*1 - 50 + 100,
		label = {x = -50, y = 2, align = "LC", text = "Clear", size = 46, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},},
		--w = 200,
		scaleT = 0.98,
		w = 280,
		h = 66,
		code = function()
			--隐藏菜单
			hGlobal.event:event("Event_StartPauseSwitch", false)
			_frm:show(0)
			
			--冒字
			local strText = "直接通关！"
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
				--快速游戏结束
				local w = hGlobal.WORLD.LastWorldMap
				
				--如果游戏暂停，直接跳出循环
				if w then
					if (w.data.IsPaused == 1) then
						return
					end
					
					hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
					
					--直接胜利
					local mapInfo = w.data.tdMapInfo
					if mapInfo then
						--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
						mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
					end
					
					--给英雄加经验值
					if Save_PlayerData and Save_PlayerData.herocard then
						for i = 1, #Save_PlayerData.herocard, 1 do
							local id = Save_PlayerData.herocard[i].id
							--LuaAddHeroExp(id, 100000)
						end
					end
					
					--加积分
					--LuaAddPlayerScore(100000)
					
					--存档
					LuaSaveHeroCard()
				end
			end)
		end,
	})
	
	--故事按钮
	_childUI["btnStory"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 83 + 13,
		y = _y-_interval*1 - 50 + 10,
		label = {x = -50, y = 2, align = "LC", text = "Story", size = 42, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},},
		--w = 200,
		scaleT = 0.98,
		w = 280,
		h = 66,
		code = function()
			if (hVar.OPTIONS.TEST_MODE == 1) then
				hVar.OPTIONS.TEST_MODE = 0
				_childUI["btnStory"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
			else
				hVar.OPTIONS.TEST_MODE = 1
				_childUI["btnStory"].childUI["check"].handle._n:setVisible(true) --打开勾勾
			end
		end,
	})
	_childUI["btnStory"].handle.s:setOpacity(0) --只响应事件，不显示
	--故事按钮框框
	_childUI["btnStory"].childUI["select_box"] = hUI.image:new({
		parent = _childUI["btnStory"].handle._n,
		x = -92,
		y = 0,
		model = "UI:NewKuang",
		w = 48,
		h = 48,
	})
	--故事按钮打勾
	_childUI["btnStory"].childUI["check"] = hUI.image:new({
		parent = _childUI["btnStory"].handle._n,
		x = -92,
		y = 0,
		model = "UI:finish",
		scale = 1.1,
	})
	if (hVar.OPTIONS.TEST_MODE == 0) then
		_childUI["btnStory"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
	end
	
	--加血按钮
	_childUI["btnHpUp"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 83 + 13,
		y = _y-_interval*1 - 50 - 80,
		label = {x = -50, y = 2, align = "LC", text = "Hp Add", size = 42, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},},
		--w = 200,
		scaleT = 0.98,
		w = 280,
		h = 66,
		code = function()
			if (hVar.OPTIONS.HPADD_MODE == 1) then
				hVar.OPTIONS.HPADD_MODE = 0
				_childUI["btnHpUp"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
				
				--取消战车加血
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				if oUnit then
					if (oUnit.data.IsDead ~= 1) then --活着的单位
						local skill_id = 15998
						local oBuff = oUnit:getBuffById(skill_id)
						if oBuff then --目标身上已有此buff
							--删除buff
							oBuff:del_buff()
						end
					end
				end
			else
				hVar.OPTIONS.HPADD_MODE = 1
				_childUI["btnHpUp"].childUI["check"].handle._n:setVisible(true) --打开勾勾
				
				--战车加血
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				if oUnit then
					if (oUnit.data.IsDead ~= 1) then --活着的单位
						local skill_id = 15997
						local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
						local gridX, gridY = world:xy2grid(targetX, targetY)
						local tCastParam =
						{
							level = 1, --等级
						}
						hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
					end
				end
			end
		end,
	})
	_childUI["btnHpUp"].handle.s:setOpacity(0) --只响应事件，不显示
	--加血按钮框框
	_childUI["btnHpUp"].childUI["select_box"] = hUI.image:new({
		parent = _childUI["btnHpUp"].handle._n,
		x = -92,
		y = 0,
		model = "UI:NewKuang",
		w = 48,
		h = 48,
	})
	--加血按钮打勾
	_childUI["btnHpUp"].childUI["check"] = hUI.image:new({
		parent = _childUI["btnHpUp"].handle._n,
		x = -92,
		y = 0,
		model = "UI:finish",
		scale = 1.1,
	})
	if (hVar.OPTIONS.HPADD_MODE == 0) then
		_childUI["btnHpUp"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
	end
	
	--加速度按钮
	_childUI["btnSpeedUp"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 83 + 13,
		y = _y-_interval*1 - 50 - 160,
		label = {x = -50, y = 2, align = "LC", text = "Speed Add", size = 42, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},},
		--w = 200,
		scaleT = 0.98,
		w = 280,
		h = 66,
		code = function()
			if (hVar.OPTIONS.SPEEDADD_MODE == 1) then
				hVar.OPTIONS.SPEEDADD_MODE = 0
				_childUI["btnSpeedUp"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
				
				--取消战车加速度
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				if oUnit then
					if (oUnit.data.IsDead ~= 1) then --活着的单位
						local skill_id = 16000
						local oBuff = oUnit:getBuffById(skill_id)
						if oBuff then --目标身上已有此buff
							--删除buff
							oBuff:del_buff()
						end
					end
				end
			else
				hVar.OPTIONS.SPEEDADD_MODE = 1
				_childUI["btnSpeedUp"].childUI["check"].handle._n:setVisible(true) --打开勾勾
				
				--战车加速度
				local world = hGlobal.WORLD.LastWorldMap
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				if oUnit then
					if (oUnit.data.IsDead ~= 1) then --活着的单位
						local skill_id = 15999
						local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
						local gridX, gridY = world:xy2grid(targetX, targetY)
						local tCastParam =
						{
							level = 1, --等级
						}
						hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加速度技能
					end
				end
			end
		end,
	})
	_childUI["btnSpeedUp"].handle.s:setOpacity(0) --只响应事件，不显示
	--加速度按钮框框
	_childUI["btnSpeedUp"].childUI["select_box"] = hUI.image:new({
		parent = _childUI["btnSpeedUp"].handle._n,
		x = -92,
		y = 0,
		model = "UI:NewKuang",
		w = 48,
		h = 48,
	})
	--加速度按钮打勾
	_childUI["btnSpeedUp"].childUI["check"] = hUI.image:new({
		parent = _childUI["btnSpeedUp"].handle._n,
		x = -92,
		y = 0,
		model = "UI:finish",
		scale = 1.1,
	})
	if (hVar.OPTIONS.SPEEDADD_MODE == 0) then
		_childUI["btnSpeedUp"].childUI["check"].handle._n:setVisible(false) --关闭勾勾
	end
	
	--管理员专用弹出框
	hGlobal.event:listen("localEvent_ShowNewSysFrm", "showthisfrm", function()
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--print("localEvent_ShowNewSysFrm")
			--zhenkira
			
			_childUI["dragBox"]:sortbutton()
			_CODE_SwitchSoundEnable()
			
			_childUI["playerList"]:setstate(1)
			_childUI["selectedlevel"]:setstate(1)
			--_childUI["returngame"]:setstate(1)
			
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				_childUI["openflag"]:setstate(1) --调试按钮
				_childUI["openflag"].data.nIsShowDebug = 0
			else
				_childUI["openflag"]:setstate(-1) --调试按钮
				
				
				--调试模式，都能看
				--测试 --test
				_childUI["openflag"]:setstate(1) --调试按钮
				_childUI["openflag"].data.nIsShowDebug = 0
				
			end
			
			_frm:show(1)
			_frm:active()
			
			hGlobal.event:event("Event_StartPauseSwitch", true)
		else
			--
		end
	end)
end
--[[
--测试 --test
if hGlobal.UI.SystemMenuNewFram then
	hGlobal.UI.SystemMenuNewFram:del()
	hGlobal.UI.SystemMenuNewFram = nil
end
hGlobal.UI.InitSystemMenuNewFram()
hGlobal.event:event("localEvent_ShowNewSysFrm", 1)
]]









--游戏内的弹出暂停的菜单2
hGlobal.UI.InitSystemMenuNewFram2 = function()
	local _y,_interval = -120,75
	hGlobal.UI.SystemMenuNewFram2 = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 240,
		y = hVar.SCREEN.h/2 + 200,
		w = 512,
		h = 368,
		dragable = 2,
		--closebtn = "BTN:PANEL_CLOSE",
		--closebtnX = 470,
		--closebtnY = -14,
		show = 0,
		border = 0,
		background = -1,
		codeOnTouch = function(self,x,y,sus)
			if sus == 0 then
				hGlobal.event:event("Event_StartPauseSwitch", false)
				self:show(0)
			end
		end,
	})
	
	local _frm = hGlobal.UI.SystemMenuNewFram2
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--[[
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "misc/addition/menu_bg.png",
		x = _frm.data.w/2,
		y = -_frm.data.h/2,
		w = 512,
		h = 368,
	})
	]]
	hApi.CCScale9SpriteCreate("data/image/misc/skillup/msgbox4.png", _frm.data.w/2, -_frm.data.h/2, 512, 420, _frm)
	
	--仅允许在大地图上打开此界面
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideSystemMenuNewFrm",function(sSceneType,oWorld,oMap)
		if sSceneType~="worldmap" then
			if _frm~=nil then
				_frm:show(0)
			end
		end
	end)
	
	--加载3个按钮
	--返回游戏大厅
	_childUI["selectedlevel"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/menu_btn_exitgame.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 + 10,
		y = _y-_interval*0 + 5,
		--w = 200,
		scaleT = 0.98,
		code = function()
			local diablodata = hGlobal.LocalPlayer.data.diablodata
			if diablodata and type(diablodata.randMap) == "table" then
				_frm:show(0)

				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				
				--关闭同步日志文件
				hApi.SyncLogClose()
				--关闭非同步日志文件
				hApi.AsyncLogClose()
				
				--隐藏可能的选人界面
				if hGlobal.UI.PhoneSelectedHeroFrm2 then
					hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
					hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
					hApi.clearTimer("__SELECT_HERO_UPDATE__")
					hApi.clearTimer("__SELECT_TOWER_UPDATE__")
					hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
				end

				local tInfos = {
					{"lifecount",0},
				}
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)

				local bResult = false
				TD_OnGameOver_Diablo(bResult)
				
				--大菠萝游戏结束,刷新界面
				local nResult = 0
				hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
				return
			end
			--geyachao: 先存档
			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			
			--隐藏可能的选人界面
			if hGlobal.UI.PhoneSelectedHeroFrm2 then
				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
				hApi.clearTimer("__SELECT_HERO_UPDATE__")
				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
			end
			
			local w = hGlobal.WORLD.LastWorldMap
			local map = w.data.map
			local tabM = hVar.MAP_INFO[map]
			local chapterId = 1
			if tabM then
				chapterId = tabM.chapter or 1
			end
			--todo zhenkira 这里以后要读取当前地图所在章节进行切换
			
			--zhenkira 注释
			--if g_vs_number > 4 and g_lua_src == 1 then
			--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
			--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
			--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
			--	end
			--end
			
			--if hGlobal.WORLD.LastTown~=nil then
			--	hGlobal.WORLD.LastTown:del()
			--end
			
			--zhenkira 注释
			local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				--存储地图模式
				currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
				
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
				--	print(".."..nil)
				--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				--end
				hGlobal.WORLD.LastWorldMap:del()
				
				hGlobal.LocalPlayer:setfocusworld(nil)
				hApi.clearCurrentWorldScene()
			end
			
			--[[
			--无尽地图、pvp，返回新主界面
			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
				--切换到新主界面事件
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			else
				--zhenkira 注释
				--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				--zhenkira 新增
				--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
				
				--大菠萝
				--切换到新主界面事件
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			end
			]]
			
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			--切换到配置坦克地图
			local mapname = hVar.MainBase
			local MapDifficulty = 0
			local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
			
			_frm:show(0)
		end,
	})
	
	--声音开关
	local _CODE_SwitchSoundEnable = function(IsSwitch)
		if IsSwitch==1 then
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hVar.OPTIONS.PLAY_SOUND = 0
				hVar.OPTIONS.PLAY_SOUND_BG = 0
			else
				hVar.OPTIONS.PLAY_SOUND = 1
				hVar.OPTIONS.PLAY_SOUND_BG = 1
			end
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hApi.EnableSoundBG(1)
				hApi.PlaySound("button")
			else
				hApi.EnableSoundBG(0)
			end
			hApi.SaveGameOptions()
		end
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_on.png")
			end
		else
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_off.png")
			end
		end
	end
	
	--声音按钮
	_childUI["soundcontrol"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/menu_btn_music.png",
		--icon = "ui/hall.png",
		--iconWH = 31,
		--label = hVar.tab_string["__TEXT_GameHall"],
		--font = hVar.FONTC,
		--border = 1,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 52,
		y = _y-_interval*1 - 50 + 10,
		--w = 200,
		--scale = 0.95,
		scaleT = 0.98,
		code = function()
			_CODE_SwitchSoundEnable(1)
		end,
	})
	--_childUI["selectedlevel"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["selectedlevel"].childUI["icon"].handle._n:setPosition(-65,1)
	
	--返回按钮
	--_childUI["returngame"] = hUI.button:new({
		--parent = _parent,
		--model = "misc/addition/menu_btn_back.png",
		----icon = "ui/hall.png",
		----iconWH = 31,
		----label = hVar.tab_string["__TEXT_Back"],
		----font = hVar.FONTC,
		----border = 1,
		--dragbox = _frm.childUI["dragBox"],
		--x = _frm.data.w/2 - 105,
		--y = _y-_interval*3 + 68,
		----w = 200,
		--scaleT = 0.95,
		--code = function()
			--hGlobal.event:event("Event_StartPauseSwitch", false)
			--_frm:show(0)
		--end,
	--})
	--_childUI["returngame"].childUI["label"].handle._n:setPosition(-25,15)
	--_childUI["returngame"].childUI["icon"].handle._n:setPosition(-65,1)
	
	--声音图标
	_childUI["soundenable"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/sound_on.png",
		--icon = "UI:shopitemxg",
		--iconWH = 68,
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w-140,
		y = -1*_frm.data.h+126,
		scaleT = 0.98,
		code = function(self)
			_CODE_SwitchSoundEnable(1)
		end,
	})
	
	--非管理员的弹出框
	hGlobal.event:listen("localEvent_ShowNewSysFrm2", "showthisfrm2", function()
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--
		else
			--print("localEvent_ShowNewSysFrm")
			--zhenkira
			
			_childUI["dragBox"]:sortbutton()
			_CODE_SwitchSoundEnable()
			
			--_childUI["playerList"]:setstate(1)
			--_childUI["selectedlevel"]:setstate(1)
			--_childUI["returngame"]:setstate(1)
			
			_frm:show(1)
			_frm:active()
			
			hGlobal.event:event("Event_StartPauseSwitch", true)
		end
	end)
end
--[[
--测试 --test
if hGlobal.UI.SystemMenuNewFram2 then
	hGlobal.UI.SystemMenuNewFram2:del()
	hGlobal.UI.SystemMenuNewFram2 = nil
end
hGlobal.UI.InitSystemMenuNewFram2()
hGlobal.event:event("localEvent_ShowNewSysFrm2", 1)
]]





--大厅界面的游戏选项面板
hGlobal.UI.InitSystemMenuExFram = function()
	local _y,_interval = -140,80
	local _x,_w,_h = 60,580,430
	hGlobal.UI.SystemMenuNewExFram = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
		show = 0,
		
	})
	
	local _frm = hGlobal.UI.SystemMenuNewExFram
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--顶部分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -70,
		w = _w,
		h = 8,
	})
	
	--底部分界线
	_childUI["apartline_back1"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -_h + 60,
		w = _w,
		h = 8,
	})
	
	_childUI["programm_version0"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 34,
		--text = "游戏选项", --language
		text = hVar.tab_string["__TEXT_GameOptional"], --language
		align = "MC",
		border = 1,
		x = _w/2,
		y = -40,
	})
	
	--程序版本号
	_childUI["programm_versionTip"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 28,
		text = hVar.tab_string["Version_Local_Label"],
		align = "LT",
		border = 1,
		x = 48,
		y = -_h + 40,
	})
	
	local curVer = ""
	local SOverInfo = hVar.CURRENT_ITEM_VERSION
	local PverInfo = tostring(xlGetExeVersion())
	if type(PverInfo) == "string" then
		curVer = curVer..string.sub(PverInfo,1,4)
	end
	if type(SOverInfo) == "string" then
		curVer = curVer..string.sub(SOverInfo,4,string.len(SOverInfo))
	end
		_childUI["programm_version"] = hUI.label:new({
			parent = _parent,
			size = 24,
			text = curVer,
			align = "LT",
			border = 1,
			x = 204,
			y = -_h + 41,
		})
	
	--Uid
	--_childUI["programm_Uid"] = hUI.label:new({
	--	parent = _parent,
	--	size = 24,
	--	text = tostring(hVar.tab_string["["].."ID:"..tostring(xlPlayer_GetUID())..hVar.tab_string["]"]),
	--	align = "LT",
	--	border = 1,
	--	RGB = {0,255,0},
	--	x = _w-220,
	--	y = -26,
	--})
	
	local _scoreLabX,_scoreLabY = 120,-320
	
	--[[
	--geyachao: 暂时去掉繁体选择
	--语言选择
	_childUI["programm_versionTip1"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 28,
		text = hVar.tab_string["LanguageSetting"],
		align = "LT",
		border = 1,
		x = _scoreLabX,
		y = _scoreLabY,
	})
	
	--简体语言图片
	_childUI["language_sc_image"] = hUI.image:new({
		model = "misc/lan_sc.png",
		parent = _parent,
		x = _scoreLabX + 220,
		y = _scoreLabY - 20,
	})
	
	_childUI["language_sc_selectbox"] = hUI.image:new({
		parent = _parent,
		model = "UI:Button_SelectBorder",
		x = _scoreLabX + 180,
		y = _scoreLabY - 8,
		scale = 0.4,
	})
	
	--繁体版图片
	_childUI["language_tc_image"] = hUI.image:new({
		model = "misc/lan_tc.png",
		parent = _parent,
		x = _scoreLabX + 320,
		y = _scoreLabY - 20,
	})
	
	--繁体版的选择框
	_childUI["language_tc_selectbox"] = hUI.image:new({
		parent = _parent,
		model = "UI:Button_SelectBorder",
		x = _scoreLabX + 276,
		y = _scoreLabY - 8,
		scale = 0.4,
	})

	--选中的特效
	_childUI["selectbox_finish"] = hUI.image:new({
		parent = _parent,
		model = "UI:finish",
		scale = 0.9,
	})
	_childUI["selectbox_finish"].handle._n:setVisible(false)
	
	_childUI["language_sc_btn"] = hUI.button:new({
		parent = _frm,
		model = -1,
		x = _scoreLabX + 200,
		y = _scoreLabY - 4,
		w = 100,
		h = 50,
		code = function(self)
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_childUI["selectbox_finish"].handle._n:setPosition(self.data.x-22,self.data.y - 2)
			_childUI["selectbox_finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.6,0.6),CCScaleTo:create(0.05,0.9,0.9)))
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",2)
			CCUserDefault:sharedUserDefault():flush()
			
			hGlobal.UI.MsgBox(hVar.tab_string["GameSettingInfo"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end,
	})
	
	_childUI["language_tc_btn"] = hUI.button:new({
		parent = _frm,
		model = -1,
		x = _scoreLabX + 300,
		y = _scoreLabY - 4,
		w = 100,
		h = 50,
		code = function(self)
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_childUI["selectbox_finish"].handle._n:setPosition(self.data.x-24,self.data.y - 2)
			_childUI["selectbox_finish"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.05,0.6,0.6),CCScaleTo:create(0.05,0.9,0.9)))
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",3)
			CCUserDefault:sharedUserDefault():flush()
			
			hGlobal.UI.MsgBox(hVar.tab_string["GameSettingInfo"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
		end,
	})
	
	if LANGUAG_SITTING and LANGUAG_SITTING == 4 then
		_childUI["programm_versionTip1"].handle._n:setVisible(false)
		_childUI["language_sc_image"].handle._n:setVisible(false)
		_childUI["language_sc_selectbox"].handle._n:setVisible(false)
		_childUI["language_tc_image"].handle._n:setVisible(false)
		_childUI["language_tc_selectbox"].handle._n:setVisible(false)
		_childUI["selectbox_finish"].handle._n:setVisible(false)
		_childUI["language_sc_btn"]:setstate(-1)
		_childUI["language_tc_btn"]:setstate(-1)
	end
	]]
	
	local sysbtnlist = {}
	
	--显示当前系统菜单中的按钮
	local _showsysbtn = function(closeindex,offy,y)
		local tempindex = 0
		for i = 1,#sysbtnlist do
			if i ~= closeindex then
				--geyachao: 暂时去掉繁体选择，改为位置下调80距离
				--_childUI[sysbtnlist[i]]:setXY(_w/2,y-offy*tempindex)
				_childUI[sysbtnlist[i]]:setXY(_w/2,y-offy*tempindex - 80 + 80)
				_childUI[sysbtnlist[i]]:setstate(1)
				tempindex = tempindex+1
			end
		end
		if _childUI[sysbtnlist[closeindex]] then
			_childUI[sysbtnlist[closeindex]]:setstate(-1)
		end
	end
	
	local _btnY,_btnInterval = -100,-75
	--推荐好友
	_childUI["share"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/bimage_bbs.png",
		iconWH = 36,
		label = {text = hVar.tab_string["__TEXT_share"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = _btnY+_btnInterval*0,
		scaleT = 0.9,
		code = function()
			hGlobal.event:event("LocalEvent_showRecommendFrm",1)
		end,
	})
	--_childUI["share"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["share"].childUI["icon"].handle._n:setPosition(-65,1)
	
	sysbtnlist[#sysbtnlist+1] = "share"
	
	--账号管理
	_childUI["password"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/password.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_manger"],size = 28,font = hVar.FONTC,border = 1}, --"账号管理"
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = _btnY+_btnInterval*1,
		scaleT = 0.9,
		code = function()
			--hGlobal.event:event("LocalEvent_ShowInputFrm",1,1)
			_frm:show(0)
			
			--是否通关第一章
			local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap9 == 0) then --游客
				hGlobal.event:event("LocalEvent_ShowMangerGuestFram")
			else
				hGlobal.event:event("LocalEvent_ShowMangerFram")
			end
		end,
	})
	--_childUI["password"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["password"].childUI["icon"].handle._n:setPosition(-65,1)
	sysbtnlist[#sysbtnlist+1] = "password"
	
	--geyachao: 暂时去掉繁体选择
	--[[
	_childUI["bbs"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "misc/gamebbs.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_BBS"],size = 28,font = hVar.FONTC,border = 1}, --"游戏论坛"
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = _btnY+_btnInterval*2,
		scaleT = 0.9,
		code = function()
			if update_ui_show_gamebbs_scene then
				update_ui_show_gamebbs_scene()
			end
		end,
	})
	--_childUI["bbs"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["bbs"].childUI["icon"].handle._n:setPosition(-65,1)
	sysbtnlist[#sysbtnlist+1] = "bbs"
	]]
	_childUI["bbs"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "misc/gamebbs.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_Rename"],size = 28,font = hVar.FONTC,border = 1}, --"改名"
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = _btnY+_btnInterval*2,
		scaleT = 0.9,
		code = function()
			local _,index = LuaGetPlayerByName(g_curPlayerName)
			if index and (type(index) == "number") then
				--创建角色改起名字的界面
				hApi.CreateModifyInputBox(index)
			end
		end,
	})
	--_childUI["bbs"].childUI["label"].handle._n:setPosition(-45,15)
	--_childUI["bbs"].childUI["icon"].handle._n:setPosition(-65,1)
	sysbtnlist[#sysbtnlist+1] = "bbs"
	
	if g_vs_number > g_last_vs_number then
		_showsysbtn(1,120,_y + 40)
	else
		_showsysbtn(0,_interval,_y + 26)
	end
	
	--测试员标记
	_childUI["xl_account_test"] = hUI.image:new({
		parent = _parent,
		model = "misc/weekstar.png",
		x = 45,
		y = -36,
		z = 2,
		scale = 0.8,
	})
	_childUI["xl_account_test"].handle._n:setVisible(false)
	
	--管理员标记
	_childUI["xl_account_admin"] = hUI.image:new({
		parent = _parent,
		model = "misc/weekstar.png",
		x = 70,
		y = -36,
		z = 2,
		scale = 0.8,
	})
	_childUI["xl_account_admin"].handle._n:setVisible(false)
	
	local shareState = -1
	hGlobal.event:listen("LocalEvent_Setbtn_compensate","__ShowshareBtn2",function(state)
		if g_vs_number > 7 then
			shareState = state
		end
		--_childUI["compensate"]:setstate(state) --geyachao: 离屏码不显示了
	end)
	
	--geyachao: 离屏码不显示了
	--补偿按钮 gift
	_childUI["compensate"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "UI:giftkey",
		x = _w-160,
		y = -_h + 28,
		scale = 0.7,
		scaleT = 0.9,
		code = function()
			xlShowWithdrawGift()
		end,
	})
	_childUI["compensate"]:setstate(-1) --默认不显示
	--管理员标记1
	_childUI["compensate"].childUI["admin1"] = hUI.image:new({
		parent = _childUI["compensate"].handle._n,
		model = "misc/weekstar.png",
		x = -20,
		y = -10,
		z = 2,
		scale = 0.5,
	})
	--管理员标记2
	_childUI["compensate"].childUI["admin2"] = hUI.image:new({
		parent = _childUI["compensate"].handle._n,
		model = "misc/weekstar.png",
		x = -20 - 15,
		y = -10,
		z = 1,
		scale = 0.5,
	})
	
	--转移设备
	--_childUI["shiftDataBtn"] = hUI.button:new({
		--parent = _parent,
		--model = "UI:shift_m",
		--dragbox = _frm.childUI["dragBox"],
		--x = 60,
		--y = -120,
		--scaleT = 0.9,
		--code = function()
			--_frm:show(0)
			--hGlobal.event:event("LocalEvent_ShowSyncDataFrm")
		--end,
	--})
	
	--申请回复存档
	local _log_id=0
	_childUI["Auto_GetSaveFile_btn"] = hUI.button:new({
		parent = _parent,
		model = "UI:shift_m",
		dragbox = _frm.childUI["dragBox"],
		x = 60,
		y = -180,
		scaleT = 0.9,
		code = function()
			_frm:show(0)
			hGlobal.event:event("LocalEvent_ShowGetAutoSaveFileFrm")
		end,
	})
	
	--根据服务器返回值判断是否开启自动回复存档流程
	hGlobal.event:listen("LocalEvent_Set_Auto_Save_File_btn","setBtnState",function(show)
		if show == 1 then
			_childUI["Auto_GetSaveFile_btn"]:setstate(1)
		elseif show == 0 then
			_childUI["Auto_GetSaveFile_btn"]:setstate(-1)
		end
		
	end)
	
	
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","activity_refresh_new",function(connect_state)
		if connect_state == 1 then
			
		else
			--_childUI["compensate"]:setstate(-1) --geyachao: 离屏码不显示了
		end
		
	end)

	--设置声音
	local _CODE_SwitchSoundEnable = function(IsSwitch)
		if IsSwitch==1 then
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hVar.OPTIONS.PLAY_SOUND = 0
				hVar.OPTIONS.PLAY_SOUND_BG = 0
			else
				hVar.OPTIONS.PLAY_SOUND = 1
				hVar.OPTIONS.PLAY_SOUND_BG = 1
			end
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hApi.EnableSoundBG(1)
				hApi.PlaySound("button")
			else
				hApi.EnableSoundBG(0)
			end
			hApi.SaveGameOptions()
		end
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			_childUI["soundenable"]:loadsprite("UI:horn_open")
			_childUI["soundenable"].handle.s:setScale(0.86)
		else
			_childUI["soundenable"]:loadsprite("UI:horn_close")
			_childUI["soundenable"].handle.s:setScale(0.86)
		end
	end

	--【声音按钮】
	_childUI["soundenable"] = hUI.button:new({
		parent = _parent,
		model = "UI:horn_open",
		dragbox = _frm.childUI["dragBox"],
		x = _w-80,
		y = -_h + 30,
		scaleT = 0.9,
		code = function(self)
			_CODE_SwitchSoundEnable(1)
		end,
	})
	_childUI["soundenable"].handle.s:setScale(0.86)

	--网络状态1
	_childUI["connect_result1"] = hUI.image:new({
		parent = _parent,
		model = "UI:wifi",
		z = 2,
		x = 100,
		y = -36,
	})
	_childUI["connect_result1"].handle._n:setVisible(false)
	--网络状态2
	--_childUI["connect_result2"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/gamebbs.png",
		--z = 2,
		--x = 100,
		--y = -36,
	--})
	--_childUI["connect_result2"].handle._n:setVisible(false)
	
	hGlobal.event:listen("localEvent_ShowNewExSysFrm", "showthisfrm", function()
		--geyachao: 暂时去掉繁体选择
		--[[
		if g_language_setting == 2 then
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_childUI["selectbox_finish"].handle._n:setPosition(_childUI["language_sc_btn"].data.x-28,_childUI["language_sc_btn"].data.y)
		elseif g_language_setting == 3 then
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_childUI["selectbox_finish"].handle._n:setPosition(_childUI["language_tc_btn"].data.x-28,_childUI["language_tc_btn"].data.y)
		end
		]]
		
		if (g_cur_net_state == 1) then
			_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result2"].handle._n:setVisible(true)
		elseif g_cur_net_state == -1 then
			_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result2"].handle._n:setVisible(false)
		end
		
		--是否是测试员
		local is_account_test =  CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
		if (is_account_test == 2) then
			_childUI["xl_account_test"].handle._n:setVisible(true)
			_childUI["xl_account_admin"].handle._n:setVisible(true)
		elseif (is_account_test == 1) then
			_childUI["xl_account_test"].handle._n:setVisible(true)
			_childUI["xl_account_admin"].handle._n:setVisible(false)
		else
			_childUI["xl_account_test"].handle._n:setVisible(false)
			_childUI["xl_account_admin"].handle._n:setVisible(false)
		end
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			_childUI["compensate"]:setstate(1) --显示离屏码
		else
			_childUI["compensate"]:setstate(-1) --不显示离屏码
		end
		
		--显示推荐
		--if (shareState == -1 and g_vs_number > g_last_vs_number) or g_cur_net_state == -1 then
		--不显示推荐 --菜单不显示
		if (g_vs_number > g_last_vs_number) or g_cur_net_state == -1 then
			_showsysbtn(1,100,_y)
		else
			_showsysbtn(0,_interval,_y + 26)
			
		end
		if shareState == -1 then
			--_childUI["compensate"]:setstate(-1) --geyachao: 离屏码不显示了
		elseif shareState == 1 then
			--_childUI["compensate"]:setstate(1) --geyachao: 离屏码不显示了
		end
		_CODE_SwitchSoundEnable()
		
		--_childUI["programm_Uid"]:setText(hVar.tab_string["["].."ID:"..tostring(xlPlayer_GetUID())..hVar.tab_string["]"],1)
		
		--_childUI["shiftDataBtn"]:setstate(-1)
		_childUI["Auto_GetSaveFile_btn"]:setstate(-1)
		--SendCmdFunc["getWormHoleState"]()
		SendCmdFunc["get_autoSave_status"]()
		
		_frm:show(1)
		_frm:active()
	end)
	
	--设置转移存档按钮是否显示
	--hGlobal.event:listen("LocalEvent_GetWormHoleState","showIF",function(orderid,status)
		--if status == 0 then
			--_childUI["shiftDataBtn"]:setstate(1)
		--else
			----_childUI["shiftDataBtn"]:setstate(-1)
		--end
		--Lua_SendPlayerData(99)
	--end)
	
	
	--仅允许在大地图上打开此界面
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideSystemMenuNewFrm",function(sSceneType,oWorld,oMap)
		if sSceneType~="worldmap" then
			if hGlobal.UI.SystemMenuNewExFram~=nil then
				hGlobal.UI.SystemMenuNewExFram:show(0)
			end
		end
	end)
end