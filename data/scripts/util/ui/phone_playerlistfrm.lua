--手机版的玩家列表界面
hGlobal.UI.InitPlayerListFrm = function()
	local _x , _y = 20 , hVar.SCREEN.h - 30
	local _runActionOffX = -400
	local _relX,_relY = 0,0
	local _frmbtn = nil
	local _frm = nil
	
	local runActionCallBack_exit = function()
		--print("runActionCallBack_exit")
		_frm:show(0)
	end
	
	if g_phone_mode == 0 then
		_y = _y - 84
	end
	
	hGlobal.UI.Phone_PlayerListFrm  = hUI.frame:new({
		x = _x,
		y = _y,
		w = 280,
		h = 600,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = 1,
		dragable = 2,
		show = 0,
		codeOnDragEx = function(touchX,touchY,touchMode)
			_relX,_relY = touchX - hGlobal.UI.Phone_PlayerListFrm.data.x, touchY - hGlobal.UI.Phone_PlayerListFrm.data.y
			_frmbtn = hGlobal.UI.Phone_PlayerListFrm.childUI["dragBox"]:getbutton(_relX,_relY)
			if touchMode == 2 and (touchX > _frm.data.w or touchY > _frm.data.y )then
				--hGlobal.UI.PlayerCardHeroFrm:active()
				_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_runActionOffX,_y)),CCCallFunc:create(runActionCallBack_exit)))
				--_frm:show(0)
			end
		end,
	})
	
	_frm = hGlobal.UI.Phone_PlayerListFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--当前版本的地图长度
	local MaxLen = {}
	for k,v in pairs(hVar.MAP_INFO) do
		if v.level and v.level > 0 then
			MaxLen[v.level] = k
		end
	end
	
	--删除玩家方法 要在这里清空所有的成就相关数据
	local function _DeletePlayer(curPlayer,index)
		if Save_playerList then
			Save_playerList.LastSwitchPlayer = 1
		end
		
		xlAppAnalysis("delete_savefile",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-name:"..tostring(curPlayer).."-localuID:"..tostring(luaGetplayerUniqueID()).."-T:"..os.date("%m%d%H%M%S"))
		--清除掉全部的成就信息
		LuaDeletePlayerAutoSave(curPlayer)
		LuaClearLootFromUnit(curPlayer)
		LuaClearSelectConfig(curPlayer) --清空本地选人配置
		LuaClearSystemMailTitle(curPlayer) --清空玩家最近一次已阅读的系统邮件的标题
		LuaClearTaskFinishFlag(curPlayer) --清除玩家是否有已完成的任务标记
		LuaClearTaskPVPFreeChestFlag(curPlayer) --清除玩家夺塔奇兵免费锦囊今日是否可免费
		LuaClearActivityAidList(curPlayer)--清空玩家已查看的活动aid列表
		LuaClearPVPUserInfo(curPlayer) --清空pvp玩家本局对战的对手信息
		LuaClearPVPIsShowGuide(curPlayer)--清空玩家pvp是否显示引导
		LuaClearPlayerBillBoard(curPlayer) --清空玩家今日本地排行榜的数据
		LuaClearTodayShopItemLimitCount(curPlayer) --清空玩家锁孔洗炼购买次数数据
		LuaClearTodayNetShopGoods(curPlayer) --清空玩家的今日商城商品列表
		LuaClearIsMonthCardState(curPlayer) --清空月卡状态
		LuaClearRandommapInfo(curPlayer) --清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
		LuaSetPlayerListMapUniqueID(curPlayer, 0)
		LuaClearGuiderecodeList(curPlayer)
		LuaClearRidByName(curPlayer)
		
		LuaSavePlayerList()
		
		--重置玩家的 keyChain 值
		for i = 1,#hVar.ConstItemIDList do
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer..tostring(hVar.ConstItemIDList[i]),0)
		end
		
		xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."SkillCardCount",0)
		xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."WishingCount",0)
		xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."ResolveBFSkillCount",0)

		xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.MAP_SAVE)
		xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.FOG)
		xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_DATA)
		xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_LOG)
		
		--设置当前玩家为创建新用户
		LuaSetPlayerList(index,"__TEXT_CreateNewPlayer","local")
		if Save_PlayerData then 
			Save_PlayerData = {}
			Save_PlayerData = nil
		end
		
		if Save_PlayerLog then
			Save_PlayerLog = {}
			Save_PlayerLog = nil
		end

		--重新选择
		if index>1 then
			hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",index-1)
		elseif index == 1 then
			_childUI["Selectedbox"].handle._n:setVisible(false)
			_childUI["DragableHint"].handle._n:setVisible(false)
			_childUI["Selectedbox"].handle._n:setPosition(0,_childUI["playerinfo_1"].data.y+46)
			_childUI["Selectedbox"].handle._n:setVisible(true)
			_childUI["DragableHint"].handle._n:setPosition(284,_childUI["playerinfo_1"].data.y+6)
			_childUI["DragableHint"].handle._n:setVisible(true)
			
			g_curPlayerName = nil
			hGlobal.event:event("LocalEvent_PhoneShowPlayerCardFrm",g_curPlayerName)
			hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",index)
		end
		
		if hGlobal.WORLD.LastWorldMap then
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
			
			hApi.clearCurrentWorldScene()
		end
		
		--清除积分信息
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--IOS
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			xlSaveIntToKeyChain("xl_"..curPlayer.."_playerScore",0)
		--windows
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..curPlayer.."_playerScore",0)
			CCUserDefault:sharedUserDefault():flush()
		end
	end
	
	_childUI["Playertitle"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 90,
		y = -60,
		width = 400,
		text = hVar.tab_string["__TEXT_PlayerList"],
	})

	--分界线1
	for i = 1, 5, 1 do 
		_childUI["apartline_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:panel_part_09",
			x = 140,
			y = -102 - (i-1)*75,
			w = 286,
			h = 8,
		})
	end
	--选中框
	_childUI["Selectedbox"] = hUI.bar:new({
		parent = _parent,
		model = "UI:PHOTO_FRAME_BAR",
		align = "LT",
		w = 275,
		h = 78,
	})
	_childUI["Selectedbox"].handle._n:setVisible(false)
	
	_childUI["DragableHint"] = hUI.image:new({
		parent = _parent,
		model = "UI:BTN_DragableHint",
		animation = "R",
		h = 78,
	})
	_childUI["DragableHint"].handle._n:setVisible(false)
	
	--改名
	_childUI["BtnRename"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/bimage_replay.png",
		iconWH = 36,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Rename"], --"改名"
		font = hVar.FONTC,
		border = 1,
		x = 140,
		y = -572 + 90,
		scaleT = 0.9,
		code = function(self)
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
				local _,index = LuaGetPlayerByName(g_curPlayerName)
				if index and (type(index) == "number") then
					--创建角色改起名字的界面
					hApi.CreateModifyInputBox(index)
				end
			--else
			--	hGlobal.UI.MsgBox("您没有权限进行此操作！",{
			--		font = hVar.FONTC,
			--		ok = function()
			--			--xlExit()
			--		end,
			--	})
			--end
			
		end,
	})
	_childUI["BtnRename"]:setstate(0)
	--非管理员模式，不显示改名按钮
	--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
	--	--
	--else
	--	_childUI["BtnRename"]:setstate(-1)
	--end
	--[[
	--源代码模式、测试员、管理员，显示星星
	--显示星星
	if (g_is_account_test == 1) then --测试员
		--1颗星
		_childUI["BtnRename"].childUI["star1"] = hUI.image:new({
			parent = _childUI["BtnRename"].handle._n,
			x = 85 + 30,
			y = 0,
			model = "misc/weekstar.png",
			dragbox = _frm.childUI["dragBox"],
			w = 36,
			h = 36,
		})
	else
		--2颗星
		_childUI["BtnRename"].childUI["star1"] = hUI.image:new({
			parent = _childUI["BtnRename"].handle._n,
			x = 85 + 0,
			y = 0,
			model = "misc/weekstar.png",
			w = 36,
			h = 36,
		})
		_childUI["BtnRename"].childUI["star2"] = hUI.image:new({
			parent = _childUI["BtnRename"].handle._n,
			x = 85 + 30,
			y = 0,
			model = "misc/weekstar.png",
			w = 36,
			h = 36,
		})
	end
	]]
	
	if (IAPServerIP == g_lrc_Ip) then --内网
		--删除
		_childUI["BtnDelete"] = hUI.button:new({
			parent = _parent,
			model = "UI:ButtonBack2",
			icon = "ui/bimage_del.png",
			iconWH = 36,
			dragbox = _childUI["dragBox"],
			label = hVar.tab_string["__TEXT_Delete"], --"删除"
			font = hVar.FONTC,
			border = 1,
			x = 140,
			y = -572 + 10,
			scaleT = 0.9,
			code = function(self)
				local _,index = LuaGetPlayerByName(g_curPlayerName)
				if Save_PlayerData and type(Save_PlayerData.herocard) == "table" and #Save_PlayerData.herocard == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DeletePlayer_Pre"].."\n"..tostring(g_curPlayerName).."\n"..hVar.tab_string["__TEXT_DeletePlayer_Back"],{
					font = hVar.FONTC,
					ok = function()
						if type(Save_PlayerData.playerDataID) == "number" and Save_PlayerData.playerDataID == 0 then
							_DeletePlayer(g_curPlayerName,index)
						elseif type(Save_PlayerData.playerDataID) == "number" and Save_PlayerData.playerDataID ~= 0 then
							SendCmdFunc["delete_cha_rid"](Save_PlayerData.playerDataID,index)
						end
					end,
					cancel = hVar.tab_string["__TEXT_Cancel"],
					})
				else
					if g_lua_src == 1 then
						hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DeletePlayer_Pre"].."\n"..tostring(g_curPlayerName).."\n"..hVar.tab_string["__TEXT_DeletePlayer_Back"],{
							font = hVar.FONTC,
							ok = function()
								hGlobal.event:event("LocalEvent_Phone_DeletePlayer",PlayerName,index)
							end,
							cancel = hVar.tab_string["__TEXT_Cancel"],
						})
					else
						hGlobal.event:event("LocalEvent_ShowInputFrm",1,2,g_curPlayerName,index)
					end
				end
				
				
			end,
		})
		_childUI["BtnDelete"]:setstate(-1)
	end
	
	--设置头像
	_childUI["setphoto"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/password.png",
		iconWH = 36,
		label = {text = hVar.tab_string["set_photo"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _frm.childUI["dragBox"],
		x = 140,
		y = -572 + 10,
		scaleT = 0.9,
		code = function()
			hGlobal.event:event("LocalEvent_showphotofrm",1)
		end,
	})
	_childUI["setphoto"]:setstate(-1)
	
	--创建玩家列表上的透明按钮
	for i = 1, 4, 1 do
		_childUI["playerinfo_"..i] = hUI.button:new({
			parent = _parent,
			model = -1,
			dragbox = _childUI["dragBox"],
			w = 280,
			h = 72,
			x = 150,
			y = -145 - (i-1)* 75,
			scaleT = 0.9,
			codeOnTouch = function(self)
				--changed by pangyong 2015/3/10
				--hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",i)       --发出“切换玩家”事件
				if LuaGetPlayerByIndex(i).name ~= g_curPlayerName then				--只有当玩家改变了，才能切换玩家
					hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",i)       --发出“切换玩家”事件
				end
				
			end,
		})
		_childUI["playerinfo_"..i]:setstate(-1)
		
		--名字和说明
		_childUI["PlayerInfonameLab_"..i] = hUI.label:new({
			parent = _parent,
			size = 28,
			align = "LT",
			font = hVar.FONTC,
			x = 70,
			y = -130- (i-1)* 75,
			width = 400,
			text = "",
		})
	end

	--切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__Hidephone_PlayerListFrm",function(sSceneType,oWorld,oMap)
		_frm:show(0)
	end)
	
	--显示动作的回调接口
	local runActionCallBack_open = function()
		--print("runActionCallBack_open")
		_frm:setXY(_x,_y)
		if (IAPServerIP == g_lrc_Ip) then --内网
			_frm:show(1)
			_frm:active()
		end
		_frm.childUI["dragBox"]:sortbutton()
	end
	
	local runActionCallBack_close = function()
		--print("runActionCallBack_close")
		_frm:setXY(_runActionOffX,_y)
		_frm:show(0)
		_frm.childUI["dragBox"]:sortbutton()
	end
	
	--启动时候检测是否有恢复存档的小面板
	local tipFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 210,
		y = hVar.SCREEN.h/2 + 155,
		z = 10000,
		dragable = 2,
		w = 420,
		h = 270,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		border = 1,
		child = {
			{
				__UI = "label",
				__NAME = "LabText",
				align = "MC",
				size = 30,
				x = 210,
				y = -115,
				text = hVar.tab_string["__TEXT_NetWaiting"],
				border = 1,
			},
			
		},
	})
	
	--当正确切换过玩家后 设置选择框的位置
	hGlobal.event:listen("LocalEvent_afterShowPhone_PlayerCardFram","__UI__setselectboxpos",function(index)
		--print("\n\n\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ PlayerCardFram $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$", index, "\n\n\n")
		--print("LocalEvent_afterShowPhone_PlayerCardFram", index)
		local playerinfo = LuaGetPlayerByIndex(index)
		if (playerinfo == nil or playerinfo.name == "__TEXT_CreateNewPlayer") and index <= hVar.OPTIONS.MAX_PLAYER_NUM then
			--没存档
			--print("分支1")
			_childUI["BtnRename"]:setstate(0)
			if _childUI["BtnDelete"] then
				_childUI["BtnDelete"]:setstate(0)
			end
			--非管理员模式，不显示改名按钮
			--[[
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
				--
			else
				_childUI["BtnRename"]:setstate(-1)
			end
			]]
			--玩家将输入一个名字，随后重载玩家列表
			if LuaCheckPlayerListRid() == 1 then --本地是否曾经建立过新账号
				--当游戏启动时，uid为0 且存档中没有 rid 那么就开启新建用户流程
				--geyachao: 大菠萝不检测重复id
				--if xlPlayer_GetUID() == 0 then
				--大菠萝。任何时候都新建存档
				if true then
					hApi.xlSetPlayerInfo(index)
					_childUI["playerinfo_"..index]:setstate(1)
					if _frm.data.show == 0 then
						_childUI["PlayerInfonameLab_"..index]:setText(hVar.tab_string["__TEXT_CreateNewPlayer"])
						_frm:show(1)
						_frm:setXY(_runActionOffX,_y)
						_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_x,_y)),CCCallFunc:create(runActionCallBack_open)))
					end
					
					return
				--当游戏启动时 ， uid 不为0，新设备，但是当前存档里没有角色id，那么就开启一个计时器，等待服务器连接，最后判断是否开启自动恢复流程
				else
					--判断是否需要开启自动恢复存档流程 函数返回 1 需要但是没有有效 rid， 2 数据表不完整 0 不需要
					tipFrm:show(1)
					tipFrm:active()
					hUI.NetDisable(7000)
					hApi.addTimerOnce("tipAction", 7000, function()
						hUI.NetDisable(0)
						tipFrm:show(0)
						local backRid =  LuaCheckPlayerListNeedAutoBack()
						--print("backRid111111111", backRid, LuaGetLastSaveBackFrmTime())
						if backRid > 2 and (tonumber(os.date("%m%d%H%M%S")) - LuaGetLastSaveBackFrmTime()) > 1800 then
							--print("backRid222222", backRid, LuaGetLastSaveBackFrmTime())
							_frm:show(0)
							hGlobal.event:event("LocalEvent_ShowGetAutoSaveFileFrm",backRid)
						else
							hApi.xlSetPlayerInfo(index)
							_childUI["playerinfo_"..index]:setstate(1)
							if _frm.data.show == 0 then
								_childUI["PlayerInfonameLab_"..index]:setText(hVar.tab_string["__TEXT_CreateNewPlayer"])
								_frm:show(1)
								_frm:setXY(_runActionOffX,_y)
								_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_x,_y)),CCCallFunc:create(runActionCallBack_open)))
							end
							
							if ((tonumber(os.date("%m%d%H%M%S")) - LuaGetLastSaveBackFrmTime()) <= 1800) then
								hGlobal.UI.MsgBox("您在30分钟内已经恢复过存档，请在30分钟后重试！", {
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
							elseif (backRid == 1) then --1 需要但是没有有效
								--需要但是没有有效 rid
								hGlobal.UI.MsgBox("[游客]没有可恢复的游戏数据，即将开始全新游戏！", {
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
							elseif (backRid == 2) then --2 数据表不完整
								hGlobal.UI.MsgBox("数据表不完整", {
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
							else
								--未联网
								--网络连接超时，恢复存档失败
								hGlobal.UI.MsgBox("网络连接超时，恢复存档失败！", {
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
							end
						end
					end)
					
					--print("\n 开启自动恢复存档流程")
				end
			else
				--没建立过新账号
				--新用户起名字
				hApi.xlSetPlayerInfo(index)
				_childUI["playerinfo_"..index]:setstate(1)
				if _frm.data.show == 0 then
					_childUI["PlayerInfonameLab_"..index]:setText(hVar.tab_string["__TEXT_CreateNewPlayer"])
					if (IAPServerIP == "192.168.1.30") then --内网_frm:show(1)_frm:show(1)
						_frm:setXY(_runActionOffX,_y)
						_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_x,_y)),CCCallFunc:create(runActionCallBack_open)))
					end
				end
				
				--print("\n 起名字1111111")
				return
			end
		else --有其他存档
			--print("分支2")
			_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_runActionOffX,_y)),CCCallFunc:create(runActionCallBack_close)))
			--只有联网时才能删除角色
			if g_cur_net_state == 1 then
				_childUI["BtnRename"]:setstate(1)
				if _childUI["BtnDelete"] then
					_childUI["BtnDelete"]:setstate(1)
				end
				--[[
				--非管理员模式，不显示改名按钮
				if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
					--
				else
					_childUI["BtnRename"]:setstate(-1)
				end
				]]
			else
				_childUI["BtnRename"]:setstate(0)
				if _childUI["BtnDelete"] then
					_childUI["BtnDelete"]:setstate(0)
				end
				--[[
				--非管理员模式，不显示改名按钮
				if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
					--
				else
					_childUI["BtnRename"]:setstate(-1)
				end
				]]
			end
			LuaSetLastSwitchPlayer(index)							--保存最后一次选中玩家的值（即 此时的玩家
			_childUI["Selectedbox"].handle._n:setPosition(0,_childUI["playerinfo_"..index].data.y+46)	--设置选择焦点
			_childUI["Selectedbox"].handle._n:setVisible(true)
			_childUI["DragableHint"].handle._n:setPosition(284,_childUI["playerinfo_"..index].data.y+6)	--设置列表右边的三角形
			_childUI["DragableHint"].handle._n:setVisible(true)
			LuaSwitchPlayer(playerinfo)							--切换玩家，更改玩家信息
			
			hGlobal.event:event("LocalEvent_PhoneShowPlayerCardFrm",playerinfo.name)	--刷新对应玩家地图
			hGlobal.event:event("LocalEvent_new_mainmenu_frm", 0) --切换存档，刷新新主界面
			hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1) --切换存档，刷新新主界面
			--print("\n 切换存档，刷新新主界面")
			
			--触发引导: 新主界面
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINDOTA, nil, "maindota")
		end
	end)
	
	
	--监听
	hGlobal.event:listen("LocalEvent_ShowPhone_PlayerListFram","__show_Phone_playerListFram",function(playerList,game_mode,online_name)
		if g_cur_net_state == 1 then
			_childUI["BtnRename"]:setstate(1)
			if _childUI["BtnDelete"] then
				_childUI["BtnDelete"]:setstate(1)
			end
			--[[
			--非管理员模式，不显示改名按钮
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
				--
			else
				_childUI["BtnRename"]:setstate(-1)
			end
			]]
		else
			_childUI["BtnRename"]:setstate(0)
			if _childUI["BtnDelete"] then
				_childUI["BtnDelete"]:setstate(0)
			end
			--[[
			--非管理员模式，不显示改名按钮
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
				--
			else
				_childUI["BtnRename"]:setstate(-1)
			end
			]]
		end
		
		_frm:active()
		local userID = xlPlayer_GetUID()
		local playerCardUid = LuaGetPlayerCardUid()
		if userID ~= playerCardUid and userID ~= 0 and playerCardUid ~= 0 then
			xlAppAnalysis("cheat_playercard",0,1,"info",tostring(userID).."-"..tostring(playerCardUid).."-T:"..tostring(os.date("%m%d%H%M%S")))
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenOtherPlayerList"].."\n-["..playerCardUid.."]-".."\n-["..userID.."]-",{
				font = hVar.FONTC,
				ok = function()
					--geyachao: 大菠萝不检测重复id
					--xlExit()
				end,
			})
			return
		end
		
		--隐藏4个按钮
		for i = 1, 4, 1 do
			_childUI["playerinfo_"..i]:setstate(-1)
			_childUI["PlayerInfonameLab_"..i]:setText("")
		end
		if game_mode == "local" then
			local playerinfo = nil
			if #playerList > 0 then
				for i = 1,#playerList do
					local playerinfo = playerList[i]
					local playername = playerinfo.name
					
					if playername == "__TEXT_CreateNewPlayer" then
						playername = hVar.tab_string["__TEXT_CreateNewPlayer"]
					end
					
					if playername == hVar.tab_string["__TEXT_CreateNewPlayer"] and i > hVar.OPTIONS.MAX_PLAYER_NUM then
						break 
					end
					
					if playerinfo.showName and playerinfo.showName ~= "" then
						_childUI["PlayerInfonameLab_"..i]:setText(playerinfo.showName)
					else
						_childUI["PlayerInfonameLab_"..i]:setText(playername)
					end
					--_childUI["PlayerInfonameLab_"..i]:setText(playername)
					_childUI["playerinfo_"..i]:setstate(1)
					
					--显示默认的
					if playername == hVar.tab_string["__TEXT_CreateNewPlayer"] then
						if i == 1 then
							_childUI["Selectedbox"].handle._n:setPosition(0,_childUI["playerinfo_"..1].data.y+46)
							_childUI["Selectedbox"].handle._n:setVisible(true)
							_childUI["DragableHint"].handle._n:setPosition(284,_childUI["playerinfo_"..1].data.y+6)
							_childUI["DragableHint"].handle._n:setVisible(true)
							local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
							local FirstEnter = xlGetIntFromKeyChain("ISFirstEnter")
							if FirstEnter == 0 and  g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
								xlSaveIntToKeyChain("ISFirstEnter",1)
							end
							_childUI["BtnRename"]:setstate(0)
							if _childUI["BtnDelete"] then
								_childUI["BtnDelete"]:setstate(0)
							end
							--[[
							--非管理员模式，不显示改名按钮
							if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
								--
							else
								_childUI["BtnRename"]:setstate(-1)
							end
							]]
							hApi.xlSetPlayerInfo(i)
						end
						break
					end
					
				end
			end
		elseif game_mode == "online" then
			--hGlobal.event:event("LocalEvent_ShowPlayerCardFram",1,online_name)
		end
		
		if _frm.data.show == 0 then
			_frm:show(1)
			_frm:setXY(_runActionOffX,_y)
			_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_x,_y)),CCCallFunc:create(runActionCallBack_open)))
		else
			
		end
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_DeletePlayer","__Phone_Delete_DeletePlayer",function(palyerName,index)
		if palyerName == nil then
			local playinfo = LuaGetPlayerByIndex(index)
			palyerName = playinfo.name
		end
		
		--print(palyerName,index)
		_DeletePlayer(palyerName,index)
	end)
	
	
end