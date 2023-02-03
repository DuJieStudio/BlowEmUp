--手机版的玩家信息面板
hGlobal.UI.InitPlayerCardFrm = function()
	--[[
	hGlobal.UI.PhonePlayerCardFrm  = hUI.frame:new({
		x = 0,
		y = hVar.SCREEN.h,
		w = 500,
		h = 100,
		--background = "UI:selectbg",
		background = -1,
		dragable = 0,
		show = 0,
		z = -1,
		buttononly = 1,
	})
	]]
	--local _frm = hGlobal.UI.PhonePlayerCardFrm
	local _frm =  hGlobal.UI.Phone_MainPanelFrm --geyachao: 新主页面
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--[[
	--背景底纹1
	_childUI["apartline_back1"] = hUI.bar:new({
		parent = _parent,
		model = "UI:selectbg2",
		x = 184,
		y = -24 - 10,
		w = 380,
		h = 38,
	})
	]]
	
	--背景底纹2
	_childUI["apartline_back2"] = hUI.bar:new({
		parent = _parent,
		model = "UI:selectbg2",
		x = 218,
		y = -68 - 10,
		w = 450,
		h = 38,
	})
	_childUI["apartline_back2"].handle._n:setVisible(false) --geyachao: 新主界面，不显示此控件
	
	_childUI["BtnContinue"]= hUI.button:new({
		parent = _frm,
		model = "Action:button_next",
		x = 345,
		y = -68 - 10,
		scaleT = 0.9,
		code = function(self)
			if 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then								--如果“我的英雄令”界面正在打开则直接返回		added by pangyong 2015/4/21
				return
			end
			if hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
				if hGlobal.WORLD.LastWorldMap then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					hApi.clearCurrentWorldScene()
				end
				xlLoadGame(g_localfilepath,g_curPlayerName,hVar.SAVE_DATA_PATH.MAP_SAVE)
			else
				print("您是新玩家，还没有存档")
			end
		end,
	})
	_childUI["BtnContinue"]:setstate(-1) --geyachao: 新主界面，不显示此控件
	
	--玩家名lable
	_childUI["playerNameLab"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y = -10 - 10,
		width = 540,
		--text = hVar.tab_string["__TEXT_MyMaster"]..":", --大菠萝不显示主公
		text = "",
		RGB = {230,180,50},
	})
	
	--玩家名字
	_childUI["playerName"] = hUI.label:new({
		parent = _parent,
		size = 42,
		align = "MC",
		font = hVar.FONTC,
		x = hVar.SCREEN.w/2,
		y = -hVar.SCREEN.h/2 - 50,
		width = 540,
		text = "",
		--RGB = {230,180,50},
		border = 1,
	})
	
	--您在
	_childUI["playerNamePlayDay"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y = -60,
		width = 540,
		text = "",
	})
	
	--玩家列表按钮
	_childUI["playerList"]= hUI.button:new({
		parent = _frm,
		model = -1,
		x = 160,
		y = -24,
		w = 300,
		h = 38,
		code = function(self)
			if 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then								--如果“我的英雄令”界面正在打开则直接返回		added by pangyong 2015/4/21
				return
			end
			if (IAPServerIP == g_lrc_Ip) then --只能内网打开
				--没有账号，不能进入玩家列表
				if (g_curPlayerName == nil) then
					return
				end
				
				hGlobal.event:event("LocalEvent_ShowPhone_PlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
			end
		end,
	})
	
	hGlobal.event:listen("LocalEvent_PhoneShowPlayerCardFrm","__ShowPlayerCardFrm",function(PlayerName)
		local oMap = hGlobal.LocalPlayer:getfocusmap()
		
		if PlayerName == nil then
			_childUI["playerName"]:setText("")
			_frm:show(0)
			return
		end
		
		
		--只在大厅界面显示出来
		--if type(oMap) == "table" and (oMap.data.map == hVar.PHONE_MAINMENU or oMap.data.map == hVar.PHONE_SELECTLEVEL or oMap.data.map == hVar.PHONE_SELECTLEVEL_3) then
		if type(oMap) == "table" and (oMap.data.map == hVar.PHONE_MAINMENU or hApi.CheckMapIsChapter(oMap.data.map)) then
			
			local playerInfo = LuaGetPlayerByName(PlayerName)
			
			if _childUI["playerName"] then
				if playerInfo and playerInfo.showName and playerInfo.showName ~= "" then
					--_childUI["playerName"]:setText("【 " .. playerInfo.showName .. " 】") --大菠萝不显示玩家名
				else
					--_childUI["playerName"]:setText("【 " .. PlayerName .. " 】") --大菠萝不显示玩家名
				end
			end
			
			local isUDaction = 0
			--如果有存档则显示其他信息
			if hApi.FileExists(g_localfilepath..PlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
				local tempTable = LuaGetSavedGameDetail(g_localfilepath..PlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
				if hApi.GetMapUniqueID() > tempTable.mapUniqueID then
					xlAppAnalysis("cheat_mapUniqueID",0,1,"info-","1uID:"..tostring(xlPlayer_GetUID()).."-N:"..tostring(g_curPlayerName).."-T:"..os.date("%m%d%H%M"))
					return hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_GameDataIllegalTip3"],{ok=function() xlExit() end,})
				end
				if tempTable and hVar.MAP_INFO[tempTable.map] then
					local text = hVar.tab_string["__TEXT_Chinese_Day_Index"]..(math.floor(tonumber(tempTable.day)/7)+1)..hVar.tab_string["__TEXT_RankNum_Week"]..hVar.tab_string["__TEXT_Chinese_Day_Index"]..(math.mod(tonumber(tempTable.day),7)+1)..hVar.tab_string["__TEXT_RankNum_Day"]
					_childUI["playerNamePlayDay"]:setText(tostring(hVar.MAP_INFO[tempTable.map].name).."  "..text)
					_childUI["BtnContinue"]:setstate(1)
					_childUI["apartline_back2"].handle._n:setVisible(true)
					isUDaction = 0
				else
					_childUI["apartline_back2"].handle._n:setVisible(false)
					_childUI["BtnContinue"]:setstate(-1)
					_childUI["playerNamePlayDay"]:setText("")
					isUDaction = 1
				end
				
			else
				if _childUI["apartline_back2"] then
					_childUI["apartline_back2"].handle._n:setVisible(false)
				end
				if _childUI["BtnContinue"] then
					_childUI["BtnContinue"]:setstate(-1)
				end
				if _childUI["playerNamePlayDay"] then
					_childUI["playerNamePlayDay"]:setText("")
				end
				isUDaction = 1
			end
			local cur_frmTime = tonumber(os.date("%m%d%H%M%S"))
			local last_frmTime = LuaGetLastSaveBackFrmTime()
			--判断是否需要开启自动恢复存档流程 函数返回 1 需要但是没有有效 rid， 2 数据表不完整 0 不需要
			local backRid =  LuaCheckPlayerListNeedAutoBack()
			if backRid > 2 and (cur_frmTime - last_frmTime) > 1800 then
				_frm:show(0)
				hGlobal.event:event("LocalEvent_ShowGetAutoSaveFileFrm",backRid)
			end
			_frm:show(1)
			hGlobal.event:event("LocalEvent_FreshMapAllUI",isUDaction)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__HidePlayerCardFrm",function(sSceneType,oWorld,oMap)
		if sSceneType == "none" or sSceneType == "online" or oWorld or (oMap and oMap.data.map ~= hVar.PHONE_MAINMENU) then
			_frm:show(0)
		end
	end)
end

--手机版主界面的设置按钮
hGlobal.UI.InitPlayerCardOptionalFrm = function()
	--[[
	local _y = hVar.SCREEN.h - 90
	hGlobal.UI.PhonePlayerCardOptionalFrm  = hUI.frame:new({
		x = 0,
		y = _y,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		background = -1,
		dragable = 0,
		show = 0,
		z = -1,
		buttononly = 1,
	})
	]]
	--local _frm = hGlobal.UI.PhonePlayerCardOptionalFrm
	local _frm =  hGlobal.UI.Phone_MainPanelFrm --geyachao: 新主页面
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--选项按钮(齿轮)
	local _ScaleW = hVar.SCREEN.w / 1280
	local _ScaleH = hVar.SCREEN.h / 768
	_childUI["optional"] = hUI.button:new({
		parent = _frm,
		model = "misc/mask.png", --ui/set.png",
		--x = 50,
		--y = -20,
		x = hVar.SCREEN.w - 60,
		--y = -hVar.SCREEN.h + 40 * _ScaleH,
		y = -40, --大菠萝
		scaleT = 0.95,
		dragbox = _frm.childUI["dragBox"],
		w = 100,
		h = 100,
		z = 10,
		--failcall = 1,
		code = function(self, touchX, touchY, sus)
			if 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then					--如果“我的英雄令”界面正在打开则直接返回		added by pangyong 2015/4/21
				return
			end
			
			--没有账号，不能进入设置
			if (g_curPlayerName == nil) then
				return
			end
			
			hGlobal.event:event("localEvent_ShowNewExSysFrm")
		end,
	})
	_childUI["optional"].handle.s:setOpacity(0) --只用于控制，不显示
	--图片
	_childUI["optional"].childUI["image"] = hUI.image:new({
		parent = _childUI["optional"].handle._n,
		model = "misc/setting.png",
		scale = 1.0,
		x = 0,
		y = 0,
	})
	_childUI["optional"]:setstate(-1) --大菠萝，不显示齿轮
	
	--邮件背包
	_childUI["giftbtn"]= hUI.button:new({
		parent = _frm,
		model = "Action:button_gift",
		x = 50,
		y = -90,
		scaleT = 0.9,
		code = function(self)
			local tBag = LuaGetPlayerGiftBag()
			if tBag and (tBag ~= 0) then
				hGlobal.event:event("localEvent_ShowPlayerGiftBagFrm", tBag)
			end
		end,
	})
	_childUI["giftbtn"]:setstate(-1) --geyachao: 默认一开始是隐藏的
	
	----邮件背包
	--_childUI["testBtn1"]= hUI.button:new({
		--parent = _frm,
		--model = "ui/set.png",
		--x = 580,
		--y = -50,
		--scaleT = 0.9,
		--code = function(self)
			--print("red test 1")
		--end,
	--})

	----邮件背包
	--_childUI["testBtn2"]= hUI.button:new({
		--parent = _frm,
		--model = "ui/set.png",
		--x = 660,
		--y = -50,
		--scaleT = 0.9,
		--code = function(self)
			--print("red test 2")
		--end,
	--})
	
	--phone 显示星将的 逻辑
	hGlobal.event:listen("LocalEvent_showweekstarherofrm","PhonePlayerCardOptionalFrm",function(HeroWeekStar)
		if _frm.data.show == 1 then
			if type(HeroWeekStar) == "table" then
				for i = 1, #HeroWeekStar do
					hGlobal.event:event("LocalEvent_ShowWeekStarHeroFrm",HeroWeekStar[i][1],HeroWeekStar[i][2])
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__HidePlayerOptionalFrm",function(sSceneType,oWorld,oMap)
		if sSceneType == "none" or sSceneType == "online" or oWorld or (oMap and oMap.data.map ~= hVar.PHONE_MAINMENU) then
			hApi.safeRemoveT(_childUI,"newVer")
			_frm:show(0)
		end
	end)
	
	--重启游戏更新版本的提示框
	local _w,_h = 580,430
	hGlobal.UI.upDateTipFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
	})

	local _frmTip = hGlobal.UI.upDateTipFrm
	local _parentTip = _frmTip.handle._n
	local _childUITip = _frmTip.childUI

	--顶部分界线
	_childUITip["apartline_back"] = hUI.image:new({
		parent = _parentTip,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -70,
		w = _w,
		h = 8,
	})

	--title
	_childUITip["title"] = hUI.label:new({
		parent = _parentTip,
		--font = hVar.FONTC,
		size = 34,
		text = hVar.tab_string["__TEXT_UpdateInfoTile"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -34,
	})
	
	--检测到游戏最新版本
	_childUITip["infoText1"] = hUI.label:new({
		parent = _parentTip,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["Confirm_Info_Up_"],
		align = "LT",
		border = 1,
		x = 40,
		y = -100,
		width = _w - 40,
	})
	
	--当前版本
	_childUITip["infoText2"] = hUI.label:new({
		parent = _parentTip,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["Confirm_Info_Down_"],
		align = "LT",
		border = 1,
		x = 40,
		y = -160,
		width = _w - 40,
	})
	
	--重启提示
	_childUITip["infoText3"] = hUI.label:new({
		parent = _parentTip,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_UpdateTipInfo"],
		align = "LT",
		border = 1,
		x = 40,
		y = -280,
		width = _w - 40,
	})
	
	--确定按钮
	_childUITip["btnOK"] = hUI.button:new({
		parent = _parentTip,
		dragbox = _childUITip["dragBox"],
		label = hVar.tab_string["Exit_Ack"],
		x = _w/2 + 150,
		y = 44 -_h,
		scaleT = 0.9,
		code = function(self)
			xlExit()
		end,
	})
	
	--取消按钮
	_childUITip["btnCancel"] = hUI.button:new({
		parent = _parentTip,
		dragbox = _childUITip["dragBox"],
		label = hVar.tab_string["__TEXT_Cancel"],
		x = _w/2 - 150,
		y = 44 -_h,
		scaleT = 0.9,
		code = function()
			_frmTip:show(0)
		end,
	})
	
	--右下角的提示按钮 点击后 弹出告诉玩家怎么更新的面板
	local _ScaleH = hVar.SCREEN.h / 768
	_childUI["newVer_btn"] = hUI.button:new({
		parent = _frm,
		model = -1,
		--x = _frm.data.x + hVar.SCREEN.w - 63,
		--y = -hVar.SCREEN.h + 200,
		x = 70,
		y = -hVar.SCREEN.h + 145 * _ScaleH, --统一调整底部条y坐标
		h = 90,
		w = 130,
		code = function()
			if 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then
				return
			end
			_frmTip:show(1)
			_frmTip:active()
		end,
	})
	_childUI["newVer_btn"]:setstate(-1)
	
	--[[
	--脚本版本号判断
	local _local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION)
	hGlobal.event:listen("LocalEvent_NewVerAction","showUI",function(data_s)
		if (_local_srcVer < data_s) then
			_childUITip["infoText1"]:setText(hVar.tab_string["Confirm_Info_Up_"] .. "      " .. data_s)
			_childUITip["infoText2"]:setText(hVar.tab_string["Confirm_Info_Down_"] .. "      " .. _local_srcVer)
			
			local _frm =  hGlobal.UI.Phone_MainPanelFrm --geyachao: 新主页面
			local _childUI = _frm.childUI
			local _parent = _frm.handle._n
			
			--"提示 游戏有更新"
			if _childUI["newVer_btn"] then
				_childUI["newVer_btn"]:setstate(-1) --大菠萝不提示
			end
			
			--删除上一次的
			hApi.safeRemoveT(_childUI, "newVer")
			local _ScaleH = hVar.SCREEN.h / 768
			_childUI["newVer"] = hUI.image:new({
				parent = _parent,
				model = "UI:tipfrm",
				--x = _frm.data.x + hVar.SCREEN.w - 63,
				--y = -hVar.SCREEN.h + 200,
				x = 70,
				y = -hVar.SCREEN.h + 145 * _ScaleH, --统一调整底部条y坐标
			})
			_childUI["newVer"].handle.s:setScale(1.5)
			_childUI["newVer"].handle.s:runAction(CCFadeIn:create(1)) --淡入
			_childUI["newVer"].handle.s:runAction(CCScaleTo:create(1,1)) --缩放
		end
	end)
	]]
	
	hGlobal.event:listen("LocalEvent_PhoneShowPlayerCardFrm","__ShowPlayerOptionalFrm",function(PlayerName)
		hApi.safeRemoveT(_childUI, "newVer")
		if LuaCheckGiftBag() == 1 then
			if _frm.childUI["giftbtn"] then
				_frm.childUI["giftbtn"]:setstate(1)
			end
		else
			if _frm.childUI["giftbtn"] then
				_frm.childUI["giftbtn"]:setstate(-1)
			end
		end
		local oMap = hGlobal.LocalPlayer:getfocusmap()
		--只在大厅界面显示出来
		if type(oMap) == "table" then
			local flag = hVar.OPTIONS.IS_TD_ENTER
			if (not flag or flag ~= 1) and oMap.data.map == hVar.PHONE_MAINMENU then
				_frm:show(1)
			--elseif (flag and flag == 1) and (oMap.data.map == hVar.PHONE_SELECTLEVEL or oMap.data.map == hVar.PHONE_SELECTLEVEL_3) then
			elseif (flag and flag == 1) and (hApi.CheckMapIsChapter(oMap.data.map)) then
				_frm:show(1)
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_setGiftBtnState","_setBTNstate",function()
		local w = hGlobal.LocalPlayer:getfocusworld()
		if LuaCheckGiftBag() == 1 then
			_frm.childUI["giftbtn"]:setstate(1)
			if w then
				if w.data.type=="worldmap" then
					if hGlobal.UI.SystemMenuBar then
						hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
					end
				end
			end
		else
			_frm.childUI["giftbtn"]:setstate(-1)
			if w then
				if w.data.type=="worldmap" then
					if hGlobal.UI.SystemMenuBar then
						hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(-1)
					end
				end
			end
		end
	end)
end


------------------------------------------------------
--选择关卡的透明窗体，用来显示返回主界面和继续游戏按钮
------------------------------------------------------
hGlobal.UI.InitShowReturnContinueFrm = function()
	hGlobal.UI.ShowReturnContinueFrm  = hUI.frame:new({
		x = 10,
		y = 590 + hVar.SCREEN.h - 640,
		w = hVar.SCREEN.w,
		h = 170,
		background = -1,
		dragable = 0,
		show = 0,
		buttononly = 1,
	})
	
	local _frm = hGlobal.UI.ShowReturnContinueFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	local _chapter = 0
	--返回按钮
	_childUI["BtnRturn"] = hUI.button:new({
		parent = _parent,
		model = "Action:button_return",
		animation = "Action_Up",
		dragbox = _childUI["dragBox"],
		x = 40,
		y = -32,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			if _chapter == 1 or  _chapter == 0 or _chapter == nil then
				hGlobal.LocalPlayer:setfocusworld(nil)
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			elseif _chapter == 2 then
				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap")
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			end
		end,
	})
	
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","_Phone_hideReturnContinue",function(sSceneType,oWorld,oMap)
		_frm:show(0)
	end)
	
	--changed by pangyong 2015/3/19 
	hGlobal.event:listen("LocalEvent_Phone_ShowReturnContinue","_Phone_ShowReturnContinue",function(isShow,chapter)
		_chapter = chapter
		_frm:show(isShow)
	end)
end