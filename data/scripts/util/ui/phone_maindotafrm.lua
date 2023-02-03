hGlobal.UI.InitDiabloLoginFrm = function()
	--是否第一次显示本界面（优化：第一次进游戏，不需要看到动画）
	local _IS_FIRST_ENTER = true

	local _frm,_parent,_childUI
	local _nBtnStartX = 180 + hVar.SCREEN.offx
	local _nBtnStartY = - hVar.SCREEN.h + 50
	local _nBtnDeltaH = 130

	local _tChannelAnswer = {}

	local _nLoginBtn = {
		[1] = {"Phone"},		--手机号
		[2] = {"QQ"},		--QQ
		[3] = {"WeChat"},	--微信
	}

	local _Code_ClearFunc = hApi.DoNothing
	local _Code_CreateLoginFrm = hApi.DoNothing
	local _Code_CreateLoginUi = hApi.DoNothing
	local _Code_CreateLoginButton = hApi.DoNothing
	local _Code_CreateChannelLoginButton = hApi.DoNothing
	local _Code_ChannelLoginFunc = hApi.DoNothing
	local _Code_FirstGame = hApi.DoNothing

	hGlobal.UI.Phone_MainPanelFrm = hUI.frame:new({
		x = 0,
		y = hVar.SCREEN.h,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		background = -1,
		dragable = 2,
		show = 0,
		autoactive = 1,
	})

	_Code_FirstGame = function(index)
		local userID = xlPlayer_GetUID()
		local guestPrefix = hVar.tab_string["guest"] --"游客"
		if (g_lua_src == 1) then --内网源代码模式下，用英文名
			guestPrefix = "User"
		end
		
		local rgName = guestPrefix
		if (userID > 0) then
			rgName = guestPrefix .. userID
		end
		
		--切换(创建)存档
		LuaSwitchPlayer({name = rgName,})
		
		LuaSetPlayerList(index, rgName, "normal")

		--hApi.ShowGameBeginAmin()

		--LuaAddPlayerScore(-LuaGetPlayerScore(notSaveFlag) + 1500)

		--hGlobal.event:event("LocalEvent_EnterGame")
	end

	_Code_ClearFunc = function()
		if hGlobal.UI.DiabloLoginFrm then
			hGlobal.UI.DiabloLoginFrm:del()
			hGlobal.UI.DiabloLoginFrm = nil
		end
		_frm = nil
		_parent = nil
		_childUI = nil
		hGlobal.event:event("LocalEvent_ClearVerticalLoginFrm")
	end

	_Code_CreateLoginFrm = function()
		print("_Code_CreateLoginFrm")
		hGlobal.UI.DiabloLoginFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 2,
			show = 0,
			autoactive = 1,
		})
		_frm = hGlobal.UI.DiabloLoginFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_Code_CreateLoginUi()

		local iChannelId = getChannelInfo()
		--print("iChannelId",iChannelId)
		if iChannelId ~= 106 and iChannelId ~= 1002 and iChannelId ~= 1 and g_lua_src ~= 1 then
			_Code_CreateChannelLoginButton()
		else
			for i = 1,#_nLoginBtn do
				_Code_CreateLoginButton(i,_nLoginBtn[i][1])
			end
			--if g_lua_src == 1 then
				_Code_CreateLoginButton(#_nLoginBtn+1,"Guest")
			--end
		end

		_frm:show(1)
		_frm:active()
	end

	_Code_CreateLoginUi = function()
		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "UI:LOGIN_BG",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
		})

		local img91 = hApi.CCScale9SpriteCreate("data/image/panel/9sprite_bg_1.png",hVar.SCREEN.w/2,-hVar.SCREEN.h + 40,hVar.SCREEN.w,80,_frm,-10)
		img91:setOpacity(100)
		
		_childUI["lab_eightMantra"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h + 52,
			text = hVar.tab_string["eightMantra1"]..hVar.tab_string["eightMantra2"]..hVar.tab_string["eightMantra3"]..hVar.tab_string["eightMantra4"],
			size = 16,
			font = hVar.FONTC,
			align = "MC",
			--RGB = {180,180,180},
		})

		_childUI["lab_copyright"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h + 26,
			text = hVar.tab_string["copyright"],
			size = 16,
			font = hVar.FONTC,
			align = "MC",
			--RGB = {180,180,180},
		})

		_childUI["img_age"] = hUI.image:new({
			parent = _frm.handle._n,
			model = "misc/age12+.png",
			x = hVar.SCREEN.w - 80,
			y = -hVar.SCREEN.h + 40,
		})
	end

	--渠道登陆按钮
	_Code_CreateChannelLoginButton = function()
		local width = 400
		local height = 160
		_childUI["btn_login"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = width/2,
			y = -hVar.SCREEN.h + 80 + height/2,
			w = width,
			h = height,
			scaleT = 0.95,
			code = function()
				--_Code_ClearFunc()
				_Code_ChannelLoginFunc()
			end,
		})

		_childUI["btn_login"].childUI["bg"] = hUI.image:new({
			parent = _childUI["btn_login"].handle._n,
			model = "misc/addition/cg.png",
			scale = 0.96,
		})

		local model = "/misc/addition/cg_label_sc.png"
		if g_Cur_Language >= 3 then
			model = "/misc/addition/cg_label_en.png"
		end

		_childUI["btn_login"].childUI["img_label"] = hUI.image:new({
			parent = _childUI["btn_login"].handle._n,
			model = model,
			x = 0,
			y = 0,
			--scale = 0.9,
		})

		local lab = _childUI["btn_login"].childUI["img_label"]
		local aArray = CCArray:create()
		aArray:addObject(CCScaleTo:create(600/1000,0.96))
		aArray:addObject(CCScaleTo:create(600/1000,1.0))
		local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
		lab.handle._n:runAction(CCRepeatForever:create(seq))

		--呼吸灯效果（白色）
		local pBlink = xlAddGroundEffect(0,-1,0,0,600/1000,0.6,255,255,255,1)
		_childUI["btn_login"].handle._nBlink = pBlink
		pBlink:getParent():removeChild(pBlink,false)
		pBlink:setScaleX(8.5)
		pBlink:setScaleY(2.6)
		_childUI["btn_login"].handle._n:addChild(pBlink)
	end

	--渠道登陆函数
	_Code_ChannelLoginFunc = function()
		g_loadServerSaveData = 1
		hGlobal.event:event("LocalEvent_autologin")

		--[[
		if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
			local iChannelId = getChannelInfo()
			
		end
		--]]
	end

	--官服登陆按钮
	_Code_CreateLoginButton = function(index,key)
		local fCode
		if key == "WeChat" then
			fCode = function()
				if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
					xlEnterGameFromOtherPlantforms("weixin")
				end
				--hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","weixin","unionid","sdasdasdasdas934fdsk8fd9s")
			end
		elseif key == "QQ" then
			fCode = function()
				if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
					xlEnterGameFromOtherPlantforms("qq")
				end
			end
		elseif key == "Phone" then
			fCode = function()
				if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
					xlEnterGameFromOtherPlantforms("phone")
				end
			end
		elseif key == "Guest" then
			fCode = function()
				g_loadServerSaveData = 1
				--hGlobal.event:event("LocalEvent_autologin")
				hGlobal.event:event("LocalEvent_NewGuestLogin")
			end
		end

		_childUI["btn_login"..index] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = key,size = 24,font = hVar.FONTC,y = 2},
			scale = 0.96,
			scaleT = 0.95,
			x = _nBtnStartX,
			y = _nBtnStartY + index * _nBtnDeltaH,
			code = fCode,
		})
	end

	hGlobal.event:listen("LocalEvent_getAnswerFromOtherPlantformError","error",function(pname,nError)
		--ResetLoginBtn()
		hGlobal.event:event("LocalEvent_ResetVerticalLoginBtn",pname,nError)
	end)

	hGlobal.event:listen("LocalEvent_getAnswerFromOtherPlantform","getAnswerFromOtherPlantform",function(pname,k,v)
		local pltNum = 0
		if pname == "weixin" then
			pltNum = 1
			hApi.RecordLoginInfo("wx",v)
		elseif pname == "qq" then
			pltNum = 2
			hApi.RecordLoginInfo("qq",v)
		elseif pname == "hw" then
			pltNum = 4
		elseif pname == "appleid" then
			pltNum = 40
			hApi.RecordIosLoginInfo(v)
		elseif pname == "phone" then
			pltNum = 44
			hApi.RecordPhoneLoginInfo(v)
		elseif pname == "guest" then
			pltNum = 55
		end
		_tChannelAnswer[k] = v
		local strText = "LocalEvent_getAnswerFromOtherPlantform pname "..tostring(pname).." , k "..tostring(k).." , v "..tostring(v).." , pltNum "..pltNum.." , g_cur_net_state "..tostring(g_cur_net_state)
		hApi.addTimerOnce("LocalEvent_getAnswerFromOtherPlantform",100,function()
			--[[
			local frm = hGlobal.UI.MsgBox("", {
				font = hVar.FONTC,
				ok = function()
					
				end,
			})
			frm.childUI["tip"] = hUI.label:new({
				parent = frm.handle._n,
				text = strText,
				size = 22,
				border = 1,
				font = hVar.FONTC,
				align = "LC",
				width = 600,
				x = 0,
				y = -148,
			})
			]]
			hApi.RecordLastLoginType(pname)
			GluaSendNetCmd[hVar.ONLINECMD.PLANTFORM_ASK](pltNum,_tChannelAnswer[k])
		end)
		
	end)

	hGlobal.event:listen("LocalEvent_newRegisterForOtherPlant","newRegister",function(plantform_type)
		local str = ""
		if plantform_type == 1 then
			str = _tChannelAnswer["unionid"]
		else
			str = _tChannelAnswer["uid"]
		end
		GluaSendNetCmd[hVar.ONLINECMD.NEW_REGISTER](plantform_type,str," "," ")
	end)

	hGlobal.event:listen("LocalEvent_NewOtherPlantForm","NewOtherPlantForm",function(t_type,uid)
		g_lastPid = hVar.ONLINECMD.NEW_LOGIN
		g_lastPtable = {t_type,uid," ",nil,g_isReconnection}
		g_guest_uid = uid
		GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](t_type,uid," ",nil,g_isReconnection)
	end)

	hGlobal.event:listen("LocalEvent_EnterGame","EnterGame",function()
		hApi.clearTimer("RecoverBtn_VerticalLoginFrm")
		_Code_ClearFunc()
		--hApi.RotateScreen(3)
		--大菠萝数据初始化
		hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		
		--读取第一关是否已通关
		--local chapterId = 1
		--local tabCh = hVar.tab_chapter[chapterId]
		--local firstmap = tabCh.firstmap --第一关
		local firstmap = hVar.GuideMap --第0关
		local isFinishFirstMap = LuaGetPlayerMapAchi(firstmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第0关
		if (isFinishFirstMap == 1) then --已通关第一关
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			--异常退出
			--table_print(tInfo)
			if tInfo.id and (tInfo.stage ~= 1 or tInfo.isguide == 1) and type(tInfo.lifecount) == "number" and tInfo.lifecount > 0 and tInfo.isclear ~= 1 and tInfo.istest ~= 1 then
				if hGlobal.WORLD.LastWorldMap then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
				end
				
				local nRandId = tInfo.id or 1
				hGlobal.event:event("LocalEvent_EnterRandMap",nRandId)
			else
				if hGlobal.WORLD.LastWorldMap then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					
				end
				
				--进入坦克配置界面
				local mapname = hVar.MainBase
				local MapDifficulty = 0
				local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
				xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
			end
		else
			GameManager.GameStart(hVar.GameType.BEGINNER)
		end
	end)

	hGlobal.event:listen("LocalEvent_Clearmainmenufrm","clearfrm",function()
		_Code_ClearFunc()
	end)
	
	--打开新主界面
	--hGlobal.event:listen("LocalEvent_xxxxxxx_frm","showmainmenu", function(nIsShow, bIsSetName, index)
	hGlobal.event:listen("LocalEvent_new_mainmenu_frm","showmainmenu", function(nIsShow, bIsSetName, index, nmode)
		print("LocalEvent_new_mainmenu_frm",nIsShow, bIsSetName, index)
		if Game_Server then
			Game_Server.Connect()
		end
		--_Code_ClearFunc()
		--起名字的流程
		if bIsSetName then
			_Code_FirstGame(index)
			--return
		end
		if nIsShow == 1 then
			print(hVar.SCREEN.w,hVar.SCREEN.h)
			if _IS_FIRST_ENTER then
				--标记不是第一次启动游戏
				_IS_FIRST_ENTER = false
				hApi.addTimerOnce("GetOBConfig",1000,function()
					GluaSendNetCmd[hVar.ONLINECMD.GET_INFO_AFTER_LOGIN]()
				end)
			end
			if hVar.SCREEN.w > hVar.SCREEN.h then
				if g_lua_src == 1 then
					_Code_CreateLoginFrm()
				else
					--不可旋转
					g_canSpinScreen = 0
					--返回登录
					g_backToLogin = 1
					--锁竖屏
					g_CurScreenMode = 2
					hApi.ChangeScreenMode()
				end
			else
				hGlobal.event:event("LocalEvent_ShowVerticalLoginFrm",nmode)
			end
		end
	end)
end

--渠道id设定
--99是ios的测试渠道id
--渠道id 100以下（不包括100）是ios
--999是安卓的测试渠道
hGlobal.UI.InitVerticalLogin = function(mode)
	local tInitEventName = {"LocalEvent_ShowVerticalLoginFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _tLoginBtn = {
		[1] = {"phone","misc/login_phone.png"},
		[2] = {"weixin","misc/login_wx.png"},
		[3] = {"qq","misc/login_qq.png"},
	}

	local _tIosLoginBtn = {
		[1] = {"appleid","misc/login_ios.png"},
		[2] = {"phone","misc/login_phone.png"},
		--[3] = {"weixin","misc/login_wx.png"},
		[3] = {"qq","misc/login_qq.png"},
	}

	local _tChannelMode = {
		[1004] = {"hw"},	--华为
	}

	local _frmW,_frmH
	_frmH = hVar.SCREEN.vh
	_frmW = hVar.SCREEN.vw

	local _frm,_parent,_childUI = nil,nil,nil
	local _boardW,_boardH = 380,420
	local _tUiList = {}
	local _tLoginButtonList = {}
	local _nHaveInit = -1
	local _nGetTimes = 0
	local _bCanClick = true
	local _nHaveShowAnnouncement = 0
	local _shouldGetConfig = 1
	local _showLoginBtn = 0
	local _testShowAnnouncement = 0

	local _useIosMode = 0
	local _AnnouncementConfig = {}
	local _FirstWaitAnnouncement = nil

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateStartBtn = hApi.DoNothing
	local _CODE_CreateLoginBtn = hApi.DoNothing
	local _CODE_CreateLoginBtnList = hApi.DoNothing
	local _CODE_AutoLoginFunc = hApi.DoNothing
	local _CODE_LoginFunc = hApi.DoNothing
	local _CODE_CheckAuthorization = hApi.DoNothing
	local _CODE_CheckHaveShowAnnouncement = hApi.DoNothing
	local _CODE_Floatnumber = hApi.DoNothing
	local _CODE_ClickAllow = hApi.DoNothing
	local _CODE_UpdateGou = hApi.DoNothing
	local _CODE_GetLocalAnnouncement = hApi.DoNothing
	local _CODE_ShowAnnouncement = hApi.DoNothing
	local _CODE_ResetBtnEffect = hApi.DoNothing
	local _CODE_ResetLoginBtn = hApi.DoNothing

	local _CODE_DelAccount = hApi.DoNothing

	local _CODE_IosMode = hApi.DoNothing
	local _CODE_ChannelMode = hApi.DoNothing

	_CODE_IosMode = function()
		local iosmode = 0
		local iChannelId = xlGetChannelId()
		if iChannelId <= 98 and _useIosMode == 1 then
		--if _useIosMode == 1 then
			iosmode = 1
		end
		return iosmode
	end

	_CODE_ChannelMode = function()
		local channelmode = 0
		local iChannelId = xlGetChannelId()
		if _tChannelMode[iChannelId] then
			channelmode = 1
		end
		return channelmode
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.VerticalLoginFrm then
			hGlobal.UI.VerticalLoginFrm:del()
			hGlobal.UI.VerticalLoginFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tUiList = {}
		_tLoginButtonList = {}
		_bCanClick = true
	end

	_CODE_AutoLoginFunc = function()
		local key = g_AccountAutoLogin.key
		_CODE_LoginFunc(key)
	end

	_CODE_CheckClickBtn = function()
		local result = 0
		if _bCanClick == true then
			_bCanClick = false
			result = 1
			hApi.addTimerOnce("RecoverBtn_VerticalLoginFrm",10000,function()
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 2500,
					fadeout = -550,
					--moveY = 32,
				}):addtext(hVar.tab_string["try_again_later"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
				_CODE_ResetLoginBtn()
				_CODE_ResetBtnEffect()
				_bCanClick = true
			end)
		end
		return result
	end

	_CODE_CheckAuthorization = function(bDoPermission)
		if g_lua_src == 1 then
			return true
		end
		local iChannelId = getChannelInfo()
		if _CODE_ChannelMode() == 1 then 
			if type(xlQueryPermission) == "function" then
				local shouldquery = xlQueryPermission(444)
				if shouldquery == 0 then
					if g_AllowPrivacy == 1 then
						return true
					else
						return false
					end
				else
					local res = xlQueryPermission(0)
					if res == 1 then
						return true
					else
						if bDoPermission then
							if type(xlGrantPermission) == "function" then
								xlGrantPermission(0)
							end
						end
						return false
					end
				end
			else
				return true
			end
		elseif iChannelId == 100 or iChannelId == 1002 or iChannelId == 999 then
			if type(xlQueryPermission) == "function" then
				local res = xlQueryPermission(0)
				if res == 1 then
					return true
				else
					if bDoPermission then
						if type(xlGrantPermission) == "function" then
							xlGrantPermission(0)
						end
					end
					return false
				end
			else
				return true
			end
		else
			return true
		end
	end

	_CODE_CheckHaveShowAnnouncement = function(key)
		if g_lua_src == 1 and _testShowAnnouncement ~= 1 then
			return true
		end
		if _nHaveShowAnnouncement == 0 then
			if _FirstWaitAnnouncement == nil then
				_FirstWaitAnnouncement = {
					key = key,
				}
				hUI.NetDisable(2000)
				--自动给进
				hApi.addTimerOnce("WaitAnnouncementCheck",1950,function()
					_nHaveShowAnnouncement = 1
					if _FirstWaitAnnouncement then
						_CODE_LoginFunc(_FirstWaitAnnouncement.key)
					end
					_FirstWaitAnnouncement = nil
				end)
			end
			--获取公告内容中，请稍后再试
--			hUI.floatNumber:new({
--				x = hVar.SCREEN.w / 2,
--				y = hVar.SCREEN.h / 2,
--				align = "MC",
--				text = "",
--				lifetime = 2500,
--				fadeout = -550,
--				--moveY = 32,
--			}):addtext(hVar.tab_string["waitannounce"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
			return false
		else
			return true
		end
	end

	_CODE_LoginFunc = function(key)
		--LuaAddBehaviorID(hVar.PlayerBehaviorList[20001])
		if _CODE_IosMode() ~= 1 then
			if _CODE_CheckAuthorization(true) == false then
				return
			end
			if g_AllowPrivacy == 0 then
				_CODE_Floatnumber()
				hGlobal.event:event("LocalEvent_ResetVerticalLoginBtn")
				if _showLoginBtn == 0 then
					_nCanCloseLoginUI = 1
					if _childUI["img_redbtn_frame1"] then
						_childUI["img_redbtn_frame1"].handle._n:setVisible(false)
					end
					if _childUI["img_redbtn_frame2"] then
						_childUI["img_redbtn_frame2"].handle._n:setVisible(true)
					end
					if _childUI["btn_manage"] then
						_childUI["btn_manage"].data.code()
					end
				end
				return
			end
		end
		--隐私之后判断是否弹过公告
		if _CODE_CheckHaveShowAnnouncement(key) == false then
			hGlobal.event:event("LocalEvent_ResetVerticalLoginBtn")
			return
		end
		g_loadServerSaveData = 1
		if key == "weixin" then
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("weixin")
				--local value = "testPCWEIXINoMjcXuHQcUxAj"
				--hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","weixin","unionid",value)
			end
		elseif key == "qq" then
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("qq")
			end
			--if g_lua_src == 1 then
			--	hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","qq","uid","20221222QQtest00001")
			--end
		elseif key == "phone" then
			if type(g_phonelogin) == "table" then
				local value = g_phonelogin.md5
				hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","phone","uid",value)
				return
			end
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("phone")
			end
		elseif key == "hw" then
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("hw")
			end
		elseif key == "appleid" then
			if type(g_ioslogin) == "table" then
				local value = g_ioslogin.md5
				hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","appleid","uid",value)
				return
			end
			if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
				xlEnterGameFromOtherPlantforms("appleid")
			end
		elseif key == "guest" then
			--hGlobal.event:event("LocalEvent_autologin")
			hGlobal.event:event("LocalEvent_NewGuestLogin")
		end
	end

	_CODE_ResetBtnEffect = function()
		if _childUI then
			if _childUI["img_redbtn_frame1"] then
				_childUI["img_redbtn_frame1"].handle._n:setVisible(true)
			end
			if _childUI["img_redbtn_frame2"] then
				_childUI["img_redbtn_frame2"].handle._n:setVisible(false)
			end
			if _childUI["btn_login"] then
				local node = _childUI["btn_login"].childUI["effect"]
				if node then
					local pBlink = node.handle._nBlink 
					pBlink:getParent():removeChild(pBlink,true)
				end
				hApi.safeRemoveT(_childUI["btn_login"].childUI,"effect")
			end
			if _childUI["img_pressstart"] then
				_childUI["img_pressstart"].handle._n:setVisible(true)
			end
			if _childUI["img_start"] then
				_childUI["img_start"].handle._n:setVisible(false)
			end
			_CODE_ResetLoginBtn()
		end
	end

	_CODE_ResetLoginBtn = function()
		for i = 1,#_tLoginButtonList do
			local uiname = _tLoginButtonList[i]
			if _childUI[uiname] then
				_childUI[uiname].childUI["img_bigIcon"].handle._n:setVisible(false)
			end
		end
	end

	_CODE_CreateLoginBtnList = function()
		local nodex = _childUI["node"].data.x
		local nodey = _childUI["node"].data.y

		local btnstartX = 90
		local btnoffY = 54
		local btnoffW = 100
		local nScale = 0.8

		local loginbtn = {}
		local iChannelId = getChannelInfo()
		if iChannelId >= 100 then
			loginbtn = _tLoginBtn
		elseif iChannelId == 99 then
			loginbtn = _tLoginBtn
		else
			loginbtn = _tIosLoginBtn
			--btnstartX = 64
			--btnoffW = 84
			--nScale = 0.7
		end

		_tLoginButtonList = {}
		for i = 1,#loginbtn do
			local uiname,icon = unpack(loginbtn[i])
			_childUI["btn_"..uiname] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = icon,
				--label = {text = "本机号码一键登录",size = 28,font = hVar.FONTC,y = 4,},
				x = nodex - _boardW/2 + btnstartX + btnoffW * (i-1),
				y = nodey + btnoffY,
				scale = nScale,
				scaleT = 0.95,
				code = function(self)
					if _CODE_CheckClickBtn() == 1 then
						print("uiname",uiname)
						_CODE_LoginFunc(uiname)
						self.childUI["img_bigIcon"].handle._n:setVisible(true)
					end
				end,
			})
			_tLoginButtonList[#_tLoginButtonList + 1] = "btn_"..uiname
			_childUI["btn_"..uiname].childUI["img_bigIcon"] = hUI.button:new({
				parent = _childUI["btn_"..uiname].handle._n,
				model = icon,
				scale = 1,
			})
			_childUI["btn_"..uiname].childUI["img_bigIcon"].handle._n:setVisible(false)
			_tUiList[#_tUiList+1] = "btn_"..uiname
		end

		--只有内网 GM 或者苹果才能看到游客登录
		if (g_lua_src == 1) or (g_is_account_test == 2) or iChannelId == 99 or iChannelId == 999 then
			local guestbtn_offy =  - 430
			if g_Background_Index == 2 then
				guestbtn_offy =  - 590
			end
			_childUI["btn_guest"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/button_null.png",
				model = "misc/addition/cg.png",
				label = {text = "GUEST",size = 26,font = hVar.FONTC,y = 4,},
				x = nodex,
				y = nodey + guestbtn_offy,
				w = 180,
				h = 60,
				scaleT = 0.95,
				code = function()
					if _CODE_CheckClickBtn() == 1 then
						print("guest")
						_CODE_LoginFunc("guest")
					end
				end,
			})
			_tUiList[#_tUiList+1] = "btn_guest"
		end
	end

	_CODE_CreateLoginBtn = function()
		_showLoginBtn = 1
		--预加载
		hGlobal.event:event("LocalEvent_CreatePrivacyAgreementFrm_async")
		hGlobal.event:event("LocalEvent_CreateProtocolAgreementFrm_async")
		_childUI["back"] = hUI.button:new({
			parent = _parent,
			x = _frmW/2,
			y = -_frmH/2,
			w = _frmW,
			h = _frmH,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			code = function()
				--print(type(g_AccountAutoLogin),_nCanCloseLoginUI)
				if g_AllowPrivacy == 0 then
					_CODE_Floatnumber()
					return
				end
				if type(g_AccountAutoLogin) ~= "table" then
					hUI.floatNumber:new({
						text = "",
						font = "numRed",
						moveY = 64,
					}):addtext(hVar.tab_string["pleace_choose_logintype"],hVar.FONTC,36,"MC",hVar.SCREEN.w/2,hVar.SCREEN.h/2,nil,1)
					return
				end
				for i = 1,#_tUiList do
					hApi.safeRemoveT(_childUI,_tUiList[i])
				end
				_tUiList = {}
				_showLoginBtn = 0
			
				_CODE_CreateStartBtn()
				_CODE_ResetBtnEffect()
			end,
		})
		_tUiList[#_tUiList+1] = "back"

		_childUI["node"] = hUI.button:new({
			parent = _parent,
			x = _frmW/2 - 3,
			y = -_frmH + (_frmH - 1280)/2 + 767 + 81,
			scale = 0.7,
			dragbox = _childUI["dragBox"],
			model = "misc/login_border.png",
		})
		_tUiList[#_tUiList+1] = "node"

		local nodex = _childUI["node"].data.x
		local nodey = _childUI["node"].data.y

		local btnstartX = 90
		local btnoffY = 54
		local btnoffW = 100

		_childUI["img_logintype"] = hUI.image:new({
			parent = _parent,
			model = "misc/login_options.png",
			x = nodex,
			y = nodey + 144,
			scale = 0.8,
		})
		_tUiList[#_tUiList+1] = "img_logintype"

		_CODE_CreateLoginBtnList()

		_childUI["lab_GamePrivacy"] = hUI.label:new({
			parent = _parent,
			x = nodex - 140,
			y = nodey - 28,
			text = hVar.tab_string["__TEXT_Game_Privacy"],
			size = 28,
			width = 540,
			font = hVar.FONTC,
			align = "LC",
			border = 1,
			--RGB = {180,180,180},
		})
		_tUiList[#_tUiList+1] = "lab_GamePrivacy"

		_childUI["btn_AllowPrivacy"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/aaaaaa.png",
			x = nodex,
			y = nodey - 88,
			w = 340,
			h = 54,
			--scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				local x = screenX - (self.data.x - self.data.w/2)
				if x <= 100 then
					--print("gou")
					_CODE_ClickAllow()
				else
					hGlobal.event:event("LocalEvent_ShowPrivacyAgreementFrm")
				end
			end,
		})
		_tUiList[#_tUiList+1] = "btn_AllowPrivacy"

		local privacychild = _childUI["btn_AllowPrivacy"].childUI
		local privacyparent = _childUI["btn_AllowPrivacy"].handle._n
		privacychild["kuang"] = hUI.image:new({
			parent = privacyparent,
			model = "UI:Button_SelectBorder",
			x = - 120,
			scale = 0.5,
		})

		privacychild["gou"] = hUI.image:new({
			parent = privacyparent,
			model = "misc/gopherboom/gou.png",
			x = - 120 + 4,
			--scale = 0.9,
		})
		privacychild["gou"].handle._n:setVisible(false)

		privacychild["text"] = hUI.label:new({
			parent = privacyparent,
			x = - 60,
			text = hVar.tab_string["__TEXT_Privacy"],
			size = 28,
			font = hVar.FONTC,
			align = "LC",
			border = 1,
			RGB = {221,187,61},
		})

		_childUI["btn_AllowProtocol"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/aaaaaa.png",
			x = nodex,
			y = nodey - 146,
			w = 340,
			h = 54,
			--scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				local x = screenX - (self.data.x - self.data.w/2)
				if x <= 100 then
					--print("gou")
					_CODE_ClickAllow()
				else
					hGlobal.event:event("LocalEvent_ShowProtocolAgreementFrm")
				end
			end,
		})
		_tUiList[#_tUiList+1] = "btn_AllowProtocol"

		local protocolchild = _childUI["btn_AllowProtocol"].childUI
		local protocolparent = _childUI["btn_AllowProtocol"].handle._n
		protocolchild["kuang"] = hUI.image:new({
			parent = protocolparent,
			model = "UI:Button_SelectBorder",
			x = - 120,
			scale = 0.5,
		})

		protocolchild["gou"] = hUI.image:new({
			parent = protocolparent,
			model = "misc/gopherboom/gou.png",
			x = - 120 + 4,
			--scale = 0.9,
		})
		protocolchild["gou"].handle._n:setVisible(false)

		protocolchild["text"] = hUI.label:new({
			parent = protocolparent,
			x = - 60,
			text = hVar.tab_string["__TEXT_Protocol"],
			size = 28,
			font = hVar.FONTC,
			align = "LC",
			border = 1,
			RGB = {221,187,61},
		})

		_CODE_UpdateGou()

		local iChannelId = xlGetChannelId()
		_childUI["btn_del"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/tb.png",
			x = nodex + 120,
			y = nodey + 144,
			scale = 0.8,
			scaleT = 0.7,
			code = function()
				_CODE_DelAccount()
			end,
		})
		_tUiList[#_tUiList+1] = "btn_del"
		if g_OBSwitch.delAccount == 1 and type(g_AccountAutoLogin) == "table" then
			_childUI["btn_del"]:setstate(1)
		else
			_childUI["btn_del"]:setstate(-1)
		end
	end

	_CODE_CreateStartBtn = function()
		local width = 320
		local height = 160
		_childUI["btn_login"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = _frmW/2 + 180,
			y = -_frmH + (_frmH - 1280)/2 + 540,
			w = width,
			h = height,
			scaleT = 0.95,
			failcall = 1,
			codeOnTouch = function(self,x,y,sus)
				hApi.PlaySound("button_1")
				if _childUI["img_redbtn_frame1"] then
					_childUI["img_redbtn_frame1"].handle._n:setVisible(false)
				end
				if _childUI["img_redbtn_frame2"] then
					_childUI["img_redbtn_frame2"].handle._n:setVisible(true)
				end
				if _childUI["img_pressstart"] then
					_childUI["img_pressstart"].handle._n:setVisible(false)
				end
				if _childUI["img_start"] then
					_childUI["img_start"].handle._n:setVisible(true)
				end
				if self.childUI["effect"] == nil then
					self.childUI["effect"] = hUI.node:new({
						parent = self.handle._n,
						x = - 70,
						y = - 6,
					})
					local node = self.childUI["effect"]
					local pBlink = xlAddGroundEffect(0,-1,0,0,500/1000,0.6,255,100,50,1)
					node.handle._nBlink = pBlink
					--pBlink:getParent():removeChild(pBlink,false)
					pBlink:setScaleX(9)
					pBlink:setScaleY(7)
					node.handle._n:addChild(pBlink)
				end
			end,
			code = function(self,x,y,sus)
				--print("AAAAAAAAAAAAAAAAAAAAAAAAAAA")
				--[[
				if hGlobal.WORLD.LastWorldMap then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
					--hGlobal.LocalPlayer:setfocusworld(nil)
					--hApi.clearCurrentWorldScene()
				end
				]]
				if sus then
					if _CODE_IosMode() == 1 then
						if _CODE_CheckClickBtn() == 1 then
							_CODE_LoginFunc("guest")
						end
					elseif _CODE_ChannelMode() == 1 then
						local iChannelId = xlGetChannelId()
						local t = _tChannelMode[iChannelId]
						if t then
							_CODE_LoginFunc(t[1])
						end
					else
						if _CODE_CheckClickBtn() == 1 then
							_CODE_AutoLoginFunc()
						end
					end
				else
					_CODE_ResetBtnEffect()
				end
			end,
		})
		_tUiList[#_tUiList+1] = "btn_login"

		_childUI["btn_login2"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = _frmW/2 - 4,
			y = -_frmH + (_frmH - 1280)/2 + 732,
			w = 400,
			h = 200,
			scaleT = 0.95,
			failcall = 1,
			code = function(self,x,y,sus)
				if _childUI["btn_login"] then
					_childUI["btn_login"].data.code(nil,0,0,sus)
				end
			end,
		})
		_tUiList[#_tUiList+1] = "btn_login2"


		_childUI["img_oneplayer"] = hUI.image:new({
			parent = _parent,
			model = "misc/login_oneplayer.png",
			x = _frmW/2 - 6,
			y = -_frmH + (_frmH - 1280)/2 + 732,
			scale = 0.6,
		})
		_tUiList[#_tUiList+1] = "img_oneplayer"

		_childUI["img_start"] = hUI.image:new({
			parent = _parent,
			model = "misc/login_start.png",
			x = _frmW/2 - 4,
			y = -_frmH + (_frmH - 1280)/2 + 732,
			scale = 0.6,
		})
		_childUI["img_start"].handle._n:setVisible(false)

		_childUI["img_pressstart"] = hUI.image:new({
			parent = _parent,
			model = "misc/login_pressstart.png",
			x = _frmW/2 - 4,
			y = -_frmH + (_frmH - 1280)/2 + 732,
			scale = 0.6,
		})
		local a = CCArray:create()
		a:addObject(CCFadeOut:create(0.8))
		a:addObject(CCDelayTime:create(0.1))
		a:addObject(CCFadeIn:create(0.8))
		a:addObject(CCDelayTime:create(0.1))
		_childUI["img_pressstart"].handle.s:runAction(CCRepeatForever:create(CCSequence:create(a)))
		_tUiList[#_tUiList+1] = "img_pressstart"

		local managey = - (_frmH - 1280)/2 - 83
		local iChannelId = xlGetChannelId()
		
		--if iChannelId == 100 then
			_childUI["btn_manage"] = hUI.button:new({
				parent = _parent,
				model = "ICON:ACCOUNT_SET",
				--model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				--label = {text = "管理",size = 26,y = 4,},
				x = _frmW - 50,
				y = managey,
				--w = 100,
				--h = 50,
				scaleT = 0.9,
				code = function()
					if _CODE_IosMode() == 1 then
						return
					end
					if _CODE_ChannelMode() == 1 then
						return
					end
					for i = 1,#_tUiList do
						hApi.safeRemoveT(_childUI,_tUiList[i])
					end
					_tUiList = {}
					_CODE_CreateLoginBtn()
				end,
			})
			_tUiList[#_tUiList+1] = "btn_manage"
		--end	
	end

	_CODE_DelAccount = function()
		if g_OBSwitch.delAccount == 1 then
			if type(g_AccountAutoLogin) == "table" then
				local pltNum = 0
				local key = g_AccountAutoLogin.key
				local typestr = ""
				local account = ""

				if key == "weixin" then
					pltNum = 1
					typestr = hVar.tab_string["logintype_wx"]
					if g_wxlogin then
						account = g_wxlogin.md5
					end
				elseif key == "qq" then
					pltNum = 2
					typestr = hVar.tab_string["logintype_qq"]
					if g_qqlogin then
						account = g_qqlogin.md5
					end
				elseif key == "phone" then
					pltNum = 44
					typestr = hVar.tab_string["logintype_phone"]
					if g_phonelogin then
						account = g_phonelogin.md5
					end
				elseif key == "appleid" then
					pltNum = 40
					typestr = hVar.tab_string["logintype_ios"]
					if g_ioslogin then
						account = g_ioslogin.md5
					end
				elseif key == "guest" then
					pltNum = 55
					typestr = "guest"
					account = g_guest_key
				end

				if pltNum ~= 0 and type(account) == "string" and account~= "" then
					local showstr1 = string.gsub(hVar.tab_string["del_account1"],"#NAME",typestr)
					local showstr2 = hVar.tab_string["del_account2"]
					local showinfo = showstr1.."\n \n"..showstr2
					hGlobal.UI.MsgBox(showinfo, {
						font = hVar.FONTC,
						style = "normal2",
						ok = function()
							hUI.NetDisable(5000)
							GluaSendNetCmd[hVar.ONLINECMD.UNBIND_PLANTFORM](0,pltNum,account)
						end,
						cancel = {hVar.tab_string["__TEXT_Cancel"],function()
						end},
					})
				end
			end
		end
	end

	_CODE_CreateUI = function(nMode)
		--赋值
		if type(g_AccountAutoLogin) == "table" and nMode  ~= 99 then
			table_print(g_AccountAutoLogin)
			_CODE_CreateStartBtn()
			return
		end
		--local iChannelId = xlGetChannelId()
		--if iChannelId == 100 then
			--_CODE_CreateLoginBtn()
		--else
			--_CODE_LoginFunc("guest")
		--end
		if _CODE_IosMode() == 1 then
			_CODE_CreateStartBtn()
		elseif _CODE_ChannelMode() == 1 then
			_CODE_CreateStartBtn()
		else
			_CODE_CreateLoginBtn()
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.VerticalLoginFrm  = hUI.frame:new({
			x = 0,
			y = _frmH,
			w = _frmW,
			h = _frmH,
			--background = -1,
			background = "misc/mask_white.png",
			autoactive = 0,
			dragable = 0,
			show = 0,
			z = 50000,
		})
		_frm = hGlobal.UI.VerticalLoginFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_frm.handle.s:setColor(ccc3(0,0,0))

		_childUI["img_tv"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parent,
			model = -1,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			z = 0,
		})
		local texture = nil
		if (g_Background_Index == 1) then
			texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/map/other/logintv.png")
				print("加载 logintv")
			end
		elseif (g_Background_Index == 2) then
			texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv2.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/map/other/logintv2.png")
				print("加载 logintv2")
			end
		elseif (g_Background_Index == 3) then
			texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv3.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/map/other/logintv3.png")
				print("加载 logintv3")
			end
		end
		if texture then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			--pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
			--pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
			_childUI["img_tv"].data.pSprite = pSprite
			_childUI["img_tv"].handle._n:addChild(pSprite)
		end
		if (g_Background_Index == 1) then
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv.png")
			if texture then
				print("释放 logintv")
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
		elseif (g_Background_Index == 2) then
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv2.png")
			if texture then
				print("释放 logintv2")
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
		elseif (g_Background_Index == 3) then
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/map/other/logintv3.png")
			if texture then
				print("释放 logintv3")
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
		end
		
		local btnoffx = 0
		local btnoffy = 0
		if g_Background_Index == 2 then
			btnoffx = -1
			btnoffy = -4
		elseif g_Background_Index == 3 then
			btnoffy = -12
		end
		
		local btn_index = g_Background_Index
		
		_childUI["img_redbtn_frame1"] = hUI.image:new({
			parent = _parent,
			model = "misc/redbtn" .. btn_index .. "_1.png",
			x = _frmW/2 + 115 + btnoffx,
			y = -_frmH + (_frmH - 1280)/2 + 538 + btnoffy,
		})
		_childUI["img_redbtn_frame2"] = hUI.image:new({
			parent = _parent,
			model = "misc/redbtn" .. btn_index .. "_2.png",
			x = _frmW/2 + 115 + btnoffx,
			y = -_frmH + (_frmH - 1280)/2 + 538 + btnoffy,
		})
		_childUI["img_redbtn_frame2"].handle._n:setVisible(false)

		local height = 580
		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = _frmW/2,
			y = -_frmH + height/2,
			w = _frmW,
			h = height,
			z = -1,
		})
		_childUI["_blackpanel"].handle.s:setOpacity(60)
		
		_frm:show(1)
		_frm:active()
	end

	_CODE_Floatnumber = function()
		local text = hVar.tab_string["__TEXT_Game_Privacy"]..hVar.tab_string["douhao"]..hVar.tab_string["__TEXT_Privacy"]..hVar.tab_string["__TEXT_And"]..hVar.tab_string["__TEXT_Protocol"]
		hUI.floatNumber:new({
			text = "",
			font = "numRed",
			moveY = 64,
		}):addtext(text,hVar.FONTC,36,"MC",hVar.SCREEN.w/2,hVar.SCREEN.h/2,nil,1)
	end
	
	_CODE_EnterGame = function()
		hApi.addTimerOnce("GameStartLoadLoginMap", 1, function()
			local __MAPDIFF = 0
			local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
			local mapName = hVar.LoginMap --"world/csys_ex_002_randommap"
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
		end)
	end
	
	_CODE_ClickAllow = function()
		--geyachao: 应王总要求，苹果版本，默认都是开隐藏勾勾狂启勾选，并且选中框，点了也没反应
		local iChannelId = getChannelInfo()
		if (iChannelId == 1) then
			return
		end
		
		if g_AllowPrivacy == 1 then
			g_AllowPrivacy = 0
		else
			g_AllowPrivacy = 1
		end
		local str = "g_AllowPrivacy = "..g_AllowPrivacy
		xlSaveGameData(g_localfilepath.."allowprivacy.cfg",str)
		_CODE_UpdateGou()
	end

	_CODE_UpdateGou = function()
		--print("g_AllowPrivacy",g_AllowPrivacy)
		if g_AllowPrivacy == 1 then
			if _childUI["btn_AllowPrivacy"] then
				_childUI["btn_AllowPrivacy"].childUI["gou"].handle._n:setVisible(true)
			end
			if _childUI["btn_AllowProtocol"] then
				_childUI["btn_AllowProtocol"].childUI["gou"].handle._n:setVisible(true)
			end
		else
			if _childUI["btn_AllowPrivacy"] then
				_childUI["btn_AllowPrivacy"].childUI["gou"].handle._n:setVisible(false)
			end
			if _childUI["btn_AllowProtocol"] then
				_childUI["btn_AllowProtocol"].childUI["gou"].handle._n:setVisible(false)
			end
		end
		
		--geyachao: 应王总要求，苹果版本，默认都是开隐藏勾勾狂启勾选，并且选中框，点了也没反应
		local iChannelId = getChannelInfo()
		if (iChannelId == 1) then
			if _childUI["lab_GamePrivacy"] then
				_childUI["lab_GamePrivacy"].handle._n:setVisible(false)
			end
			if _childUI["btn_AllowPrivacy"] then
				_childUI["btn_AllowPrivacy"].childUI["kuang"].handle._n:setVisible(false)
				_childUI["btn_AllowPrivacy"].childUI["gou"].handle._n:setVisible(false)
				_childUI["btn_AllowPrivacy"].childUI["text"].handle._n:setVisible(false)
			end
			if _childUI["btn_AllowProtocol"] then
				_childUI["btn_AllowProtocol"].childUI["kuang"].handle._n:setVisible(false)
				_childUI["btn_AllowProtocol"].childUI["gou"].handle._n:setVisible(false)
				_childUI["btn_AllowProtocol"].childUI["text"].handle._n:setVisible(false)
			end
		end
	end

	_CODE_GetLocalAnnouncement = function()
		_AnnouncementConfig.info = {}	--公告信息
		_AnnouncementConfig.info.boardw = 700
		_AnnouncementConfig.info.boardh = 700
		_AnnouncementConfig.info.boardbg = -1
		_AnnouncementConfig.info.labw = 600

		_AnnouncementConfig.info.label = {}
		_AnnouncementConfig.info.label[#_AnnouncementConfig.info.label+1] = {
			x = _AnnouncementConfig.info.boardw/2,
			y = -72,
			text = hVar.tab_string["Official_Announcement"],
			align = "MC",
			border = 1,
			size = 38,
			RGB={255,165,0},
		}
	end

	_CODE_ShowAnnouncement = function()
		print("_CODE_ShowAnnouncement")
		if type(g_AnnouncementConfig) == "table" then
			local shouldshow = true
			if g_AnnouncementConfig.showmode == 0 then
				shouldshow = false
			else
				if g_AnnouncementConfig.showmode == 1 then
					--全显示
				elseif g_AnnouncementConfig.showmode == 2 then
					--仅玩家显示
					local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
					if (IsTester == 1) or (IsTester == 2) then
						shouldshow = false
					else
						shouldshow = true
					end
				elseif g_AnnouncementConfig.showmode == 3 then
					--仅GM显示
					local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
					if (IsTester == 1) or (IsTester == 2) then
						shouldshow = true
					else
						shouldshow = false
					end
				end
			end
			if shouldshow then
				hApi.clearTimer("WaitAnnouncementCheck")
				hUI.NetDisable(0)
				if type(g_AnnouncementConfig.info) == "table" then
					if _CODE_IosMode() == 1 then
						hGlobal.event:event("LocalEvent_showAnnouncementFrm",g_AnnouncementConfig.info)
					elseif _CODE_CheckAuthorization() == true then
						hGlobal.event:event("LocalEvent_showAnnouncementFrm",g_AnnouncementConfig.info)
					end
				end
			else
				_nHaveShowAnnouncement = 1
			end
		else
			if _nGetTimes == 0 then
				hApi.RequestAnnouncement()
			end
			_nGetTimes = _nGetTimes + 1
			hApi.addTimerForever("AutoRequestAnnouncement",hVar.TIMER_MODE.GAMETIME,5000,function()
				hApi.RequestAnnouncement()
			end)
		end
	end

	hGlobal.event:listen("LocalEvent_ResetVerticalLoginBtn","VerticalLoginBtn",function(pname,nError)
		_bCanClick = true
		hApi.clearTimer("RecoverBtn_VerticalLoginFrm")
		_CODE_ResetLoginBtn()
		if pname == "phone" then
			local strText = hVar.tab_string["__TEXT_GetPhoneIDError"]..nError
			hUI.floatNumber:new({
				text = "",
				font = "numRed",
				moveY = 64,
			}):addtext(strText,hVar.FONTC,36,"MC",hVar.SCREEN.w/2,hVar.SCREEN.h/2,nil,1)
		end
	end)

	hGlobal.event:listen("LocalEvent_DeleteAccountSuccess","deleteAccount",function()
		_CODE_ResetBtnEffect()
		if _childUI["btn_del"] then
			_childUI["btn_del"]:setstate(-1)
		end
		if _childUI["btn_manage"] then
			_childUI["btn_manage"].data.code()
		end
	end)
	
	hGlobal.event:listen("LocalEvent_ClearVerticalLoginFrm","clearfrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_allowGamePrivacy","allowGamePrivacy",function()
		g_AllowPrivacy = 1
		local str = "g_AllowPrivacy = 1"
		xlSaveGameData(g_localfilepath.."allowprivacy.cfg",str)
		_CODE_UpdateGou()
	end)

	hGlobal.event:listen("LocalEvent_UndateUIafterOBConfig","updateui",function()
		if g_lua_src == 1 then
			--hGlobal.event:event("LocalEvent_PrivacyAuthorizationFrm")
			--return
		elseif type(xlQueryPermission) == "function" then
			local iChannelId = getChannelInfo()
			--询问授权
			local shouldDo = true
			--渠道模式需要特殊处理
			if _CODE_ChannelMode() == 1 then
				local shouldquery = xlQueryPermission(444)
				if shouldquery == 0 then	--0代表不需要授权
					shouldDo = false
					if iChannelId == 1004 then
						if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
							xlEnterGameFromOtherPlantforms("init")
						end
					end
					--如果没有同意就弹框
					if g_AllowPrivacy == nil or g_AllowPrivacy == 0 then
						hApi.RecordNoQueryPermissionProcess(0)
						hGlobal.event:event("LocalEvent_PrivacyAuthorizationFrm")
					end
				end
			end
			if shouldDo then
				local res = xlQueryPermission(0)
				if res == 0 then
					hGlobal.event:event("LocalEvent_PrivacyAuthorizationFrm")
					return
				else
					if iChannelId == 1002 or iChannelId == 100 or iChannelId == 999 then
						if xlEnterGameFromOtherPlantforms and type(xlEnterGameFromOtherPlantforms) == "function" then
							xlEnterGameFromOtherPlantforms("init")
						end
					end
					
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_TD_CreateLoginButton", "VerticalLoginFrm",function(sSceneType,oWorld,oMap)
		print("LocalEvent_TD_CreateLoginButton")
		if _nHaveInit == 0 and _frm then
			_nHaveInit = 1
			hGlobal.event:event("LocalEvent_ShowControlBtn",0)
			_frm.handle.s:setColor(ccc3(255,255,255))
			_frm.handle.s:setOpacity(0)
			_CODE_CreateUI()
		end
	end)

	hGlobal.event:listen("LocalEvent_CheckShowAnnouncementFrm","VerticalLogin",function()
		if g_lua_src == 1 and _testShowAnnouncement ~= 1 then
			return
		end
		--ios暂时跳过公告
		--local iChannelId = xlGetChannelId()
		--if iChannelId <= 98 then
			--return
		--end
		_CODE_ShowAnnouncement()
	end)

	hGlobal.event:listen("LocalEvent_HaveShowAnnouncementFrm","VerticalLogin",function()
		_nHaveShowAnnouncement = 1
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nMode)
		_CODE_ClearFunc()
		_nHaveInit = 0
		if _shouldGetConfig == 1 then
			_shouldGetConfig = 0
			hApi.addTimerOnce("GetOBConfig",1000,function()
				GluaSendNetCmd[hVar.ONLINECMD.GET_INFO_AFTER_LOGIN]()
			end)
			--如果是ios 因为没有权限流程 所有提权弹一个公告界面 挡住后续操作
			local iChannelId = xlGetChannelId()
			if iChannelId <= 98 then
				if g_lua_src == 1 and _testShowAnnouncement ~= 1 then
				else
					--ios暂时跳过公告
					--_nHaveShowAnnouncement = 1
					--如果是ios版本  不弹权限界面  直接用公告框拦住
					--_CODE_GetLocalAnnouncement()
					--hGlobal.event:event("LocalEvent_showAnnouncementFrm",_AnnouncementConfig.info)
				end
			end
			--显示公告
			hGlobal.event:event("LocalEvent_CheckShowAnnouncementFrm")
		end
		hGlobal.event:event("LocalEvent_Clearmainmenufrm")
		--hApi.RotateScreen(1)
		if nMode == 99 then
			_CODE_CreateFrm()
			_CODE_CreateUI(nMode)
		else
			if type(g_AccountAutoLogin) == "table" then
				_CODE_EnterGame()
				_CODE_CreateFrm()
			else
				_nHaveInit = 1
				hGlobal.event:event("LocalEvent_ShowControlBtn",0)
				_CODE_CreateFrm()
				_CODE_CreateUI()
			end
		end
	end)
end

--游戏过程中 网络中断后 需要弹出的提示界面
hGlobal.UI.InitAndroidNetAlreadyFrm = function()
	local _frm,_childUI,_parent = nil,nil,nil
	local _bIsWait = 0
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_ClearFrm = hApi.DoNothing
	local _CODE_GetHeartPacket = hApi.DoNothing
	local _lastState = 0

	_CODE_ClearFrm = function()
		if hGlobal.UI.AndroidNetAlreadyFrm then
			hGlobal.UI.AndroidNetAlreadyFrm:del()
			hGlobal.UI.AndroidNetAlreadyFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_bIsWait = 0
		_lastState = 0
		hGlobal.event:listen("localEvent_GetHeartPacket","NetAlreadyFrm",nil)
		hApi.clearTimer("CheckShouldReLogin")
	end

	_CODE_CreateFrm = function()
		local _w,_h = 520,330
		local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2

		hGlobal.UI.AndroidNetAlreadyFrm = hUI.frame:new({
			x = _x,
			y = _y,
			dragable = 4,
			w = _w,
			h = _h,
			show = 0,
			background = "misc/skillup/msgbox4.png",
			failcall = 1,
			z = 999999,
			codeOnTouch = function(self,x,y,sus)
				if sus == 0 then
				end
			end,
		})
		
		_frm = hGlobal.UI.AndroidNetAlreadyFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n
		
		--提示信息
		_childUI["PromptInfo"]  = hUI.label:new({
			parent = _parent,
			size = 32,
			align = "MC",
			x = _w/2,
			y = 40-_h/2,
			font = hVar.FONTC,
			width = 540,
			text = hVar.tab_string["ios_err_network_cannot_conn2"],
		})

		--[[
		--返回登陆界面
		_childUI["bt1"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_Back_Login"],size = 24,border = 1,font = hVar.FONTC,y = 2},
			x = _w/2 - 120,
			y = 80 -_h,
			w = 140,
			h = 60,
			model = "misc/addition/cg.png",
			scaleT = 0.9,
			code = function(self)
				_frm:show(0)
				hGlobal.event:event("LocalEvent_new_mainmenu_frm",1)
			end,
		})
		--]]

		--尝试从连
		_childUI["bt2"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["Exit_Ack"],size = 26,border = 1,font = hVar.FONTC,y = 2},
			x = _w/2,
			y = 80 -_h,
			w = 140,
			h = 60,
			model = "misc/addition/cg.png",
			scaleT = 0.95,
			code = function(self)
				--if _bIsWait == 0 then --会导致一直消不掉？
					hUI.NetDisable(5000)
					--self:setstate(0)
					--已经没有4000了  全走3902
					--如果登陆过才需要自动重连
					if g_lastPid == 3902 then
						local t_type,uid,pass,itag,reconnection = unpack(g_lastPtable)
						print(g_lastPid,t_type,uid,pass,itag,reconnection)
						--GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](t_type,uid,pass,itag,g_isReconnection)
						GluaSendNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN](t_type,uid,pass,itag,g_isReconnection) --游戏内重连
					else
						--都没登录 不需要弹
						hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
					end
				--end
			end,
		})
	
		--网络连接提示
		_childUI["Account_waiting"] =hUI.image:new({
			parent = _parent,
			model = "MODEL_EFFECT:waiting",
			x = _w/2,
			y = -_h/2,
			z = 1,
			scale = 0.6,
		})
		_childUI["Account_waiting"].handle._n:setVisible(false)

		_frm:show(1)
		_frm:active()
	end

	_CODE_GetHeartPacket = function()
		print("_CODE_GetHeartPacket")
		--如果获取到心跳包  说明连接正常 不需要重连 直接关界面
		hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
	end

	hGlobal.event:listen("LocalEvent_SetCurAccountState","SetCurAccountState2",function()
		--根据网络状态显示 连接提示
		if _frm and _frm.data.show == 1 then
			if g_cur_net_state ~= _lastState then
				_lastState = g_cur_net_state
			else
				return
			end
			if g_cur_net_state == -1 then
				_bIsWait = 1
				_childUI["Account_waiting"].handle._n:setVisible(true)
				
				hApi.AddShader(_childUI["bt2"].handle.s, "gray")
			elseif g_cur_net_state == 1 then
				--取消挡操作
				hUI.NetDisable(0)
				
				_bIsWait = 0
				_childUI["Account_waiting"].handle._n:setVisible(false)
				
				hApi.AddShader(_childUI["bt2"].handle.s, "normal")
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_CheckShouldReLogin","CheckShouldReLogin",function()
		--hGlobal.event:listen("localEvent_GetHeartPacket","NetAlreadyFrm",_CODE_GetHeartPacket)
		--hApi.addTimerOnce("CheckShouldReLogin",3000,function()
			if _frm and _frm.data.show == 1 then
				if _childUI["bt2"] then
					_childUI["bt2"].data.code()
				end
			end
		--end)
	end)


	hGlobal.event:listen("LocalEvent_SpinScreen","AndroidNetAlreadyFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFrm()
			_CODE_CreateFrm()
			hGlobal.event:event("LocalEvent_SetCurAccountState")
		end
	end)

	hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm","showluaregisteredFrm",function(isShow)
		if g_DisableShowNetAlreadyFrm == 1 then
			_CODE_ClearFrm()
			return
		end
		if isShow == 1 then
			if _frm and _frm.data.show == 1 then
				return
			end
			_CODE_ClearFrm()
			_bIsWait = 1
			g_DisableShowOption = 1
			hGlobal.event:event("CloseSystemMenuIntegrateFrm")
			hGlobal.event:event("Event_StartPauseSwitch", true)
			_CODE_CreateFrm()
			hGlobal.event:event("LocalEvent_SetCurAccountState")
		else
			_CODE_ClearFrm()
			hUI.NetDisable(0)
			g_DisableShowOption = 0
			hGlobal.event:event("Event_StartPauseSwitch", false)
		end
	end)
end

if true then
	return
end



--新主界面
hGlobal.UI.InitDotaMainMenu = function()
	local BOARD_WIDTH = 1280 --PVP房间面板的宽度
	local BOARD_HEIGHT = 768 --PVP房间面板的高度
	
	--函数部分
	local OnCreateMainFrame_New = hApi.DoNothing --创建新主界面
	local ShowMainFrameButtonAction = hApi.DoNothing --显示主界面按钮动画
	local HideMainFrameButtonAction = hApi.DoNothing --隐藏主界面按钮动画
	local ShowSetNameUIAction = hApi.DoNothing --显示起名字界面动画
	local HideSetNameUIAction = hApi.DoNothing --隐藏起名字界面动画
	--local __showTop = hApi.DoNothing
	--local __hideTop = hApi.DoNothing
	local __switchChapter = hApi.DoNothing --章节切换
	local __refreshTacticSkillTaskNotes = hApi.DoNothing --刷新按钮是否有最新动态（提示升级、更新，等等）
	local _refreshMainFrm = hApi.DoNothing --刷新选择界面的按钮
	local __DynamicAddRes = hApi.DoNothing --动态加载资源
	local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
	local _CheckRestoreSaveData = hApi.DoNothing --检测恢复存档
	
	--界面整体缩放比例
	local _ScaleW = hVar.SCREEN.w / 1280
	local _ScaleH = hVar.SCREEN.h / 768
	
	--是否第一次显示本界面（优化：第一次进游戏，不需要看到动画）
	local _IS_FIRST_ENTER = true
	
	--当前是否显示状态（避免重复操作）
	local _nIsShowState = 0
	local _enterNameEditBox = nil
	local _removeFrmList = {}
	
	--是否打开了某个按钮的面板
	local __isOpenSubFrm = false
	
	--主界面【主框】
	hGlobal.UI.Phone_MainPanelFrm = hUI.frame:new({
		x = 0,
		y = hVar.SCREEN.h,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		background = -1,
		dragable = 2,
		show = 0,
		autoactive = 1,
	})
	
	--创建新主界面
	local _frm = hGlobal.UI.Phone_MainPanelFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--主界面黑色背景图
	_childUI["panel_bg"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png",
		x = hVar.SCREEN.w / 2,
		y = -hVar.SCREEN.h / 2,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
	})
	_childUI["panel_bg"].handle.s:setOpacity(0) --为了挂载动态图
	
	--[[
	--升级按钮
	_childUI["skill_up"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png",
		x = 200 * _ScaleW,
		y = - 100 * _ScaleH,
		dragbox = _childUI["dragBox"],
		scaleT = 0.95,
		w = 150,
		h = 160,
		code = function()
			local unitId = hVar.MY_TANK_ID
			hGlobal.event:event("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm", unitId)
		end,
	})
	_childUI["skill_up"].handle.s:setOpacity(0) --为了挂载动态图
	--背景图
	_childUI["skill_up"].childUI["imgBG"] = hUI.image:new({
		parent = _childUI["skill_up"].handle._n,
		model = "misc/addition/tank_bg.png",
		x = 0,
		y = -65,
		w = 124,
		h = 28,
	})
	--坦克图片
	_childUI["skill_up"].childUI["imgTank"] = hUI.image:new({
		parent = _childUI["skill_up"].handle._n,
		model = "misc/addition/tank.png",
		x = 0,
		y = 0,
		w = 114,
		h = 94,
	})
	--坦克文字
	_childUI["skill_up"].childUI["tankName"] = hUI.label:new({
		parent = _childUI["skill_up"].handle._n,
		x = 0,
		y = -65,
		width = 500,
		align = "MC",
		size = 24,
		border = 1,
		font = hVar.FONTC,
		text = "TANK",
	})
	]]
	
	
	--选择关卡按钮
	--_childUI["select_map"] = hUI.button:new({
		--parent = _frm.handle._n,
		--model = "misc/mask.png",
		--x = 400 * _ScaleW,
		--y = - 100 * _ScaleH,
		--dragbox = _childUI["dragBox"],
		--scaleT = 0.95,
		--w = 150,
		--h = 160,
		--code = function()
			----local chapterId = 1
			----hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
			
			----大菠萝数据初始化
			--hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			----local mapname = hVar.MainBase
			----local MapDifficulty = 0
			----local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
			
			--local mapname = "world/endless_001"
			--local MapDifficulty = 0
			--local MapMode = hVar.MAP_TD_TYPE.ENDLESS --无尽模式
			
			--xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
		--end,
	--})
	--_childUI["select_map"].handle.s:setOpacity(0) --为了挂载动态图
	----背景图
	--_childUI["select_map"].childUI["imgBG"] = hUI.image:new({
		--parent = _childUI["select_map"].handle._n,
		--model = "misc/addition/tank_bg.png",
		--x = 0,
		--y = -65,
		--w = 124,
		--h = 28,
	--})
	----坦克图片
	--_childUI["select_map"].childUI["imgTank"] = hUI.image:new({
		--parent = _childUI["select_map"].handle._n,
		--model = "misc/addition/tank.png",
		--x = 0,
		--y = 0,
		--w = 114,
		--h = 94,
	--})
	----坦克文字
	--_childUI["select_map"].childUI["tankName"] = hUI.label:new({
		--parent = _childUI["select_map"].handle._n,
		--x = 0,
		--y = -65,
		--width = 500,
		--align = "MC",
		--size = 24,
		--border = 1,
		--font = hVar.FONTC,
		--text = "无尽地图",
	--})
	
	--内网测试为iPhoneX加黑边、白底
	if (g_phone_mode == 4) then --iPhoneX
		--主界面【主框】
		hGlobal.UI.Phone_MainPanelFrm_iPhoneX = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			z = 99999,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 2,
			show = 1,
			autoactive = 1,
			buttononly = 1, --穿透
		})
		
		local _frmX = hGlobal.UI.Phone_MainPanelFrm_iPhoneX
		
		--[[
		--iPhoneX黑边-左
		_frmX.childUI["iPhoneX_Black_Left"] = hUI.image:new({
			parent = _frmX.handle._n,
			model = "UI:BLACK_BORDER",
			x = 60,
			y = -hVar.SCREEN.h / 2,
			z = 99999,
			w = 120,
			h = 720,
		})
		_frmX.childUI["iPhoneX_Black_Left"].handle.s:setRotation(180)
		
		--iPhoneX黑边-右
		_frmX.childUI["iPhoneX_Black_Right"] = hUI.image:new({
			parent = _frmX.handle._n,
			model = "UI:BLACK_BORDER",
			x = hVar.SCREEN.w - 60,
			y = -hVar.SCREEN.h / 2,
			z = 99999,
			w = 120,
			h = 720,
		})
		]]
		
		--只在内网有效
		if (IAPServerIP == g_lrc_Ip) then --内网--iPhoneX底部白条
			--_frmX.childUI["iPhoneX_White_Image"] = hUI.image:new({
				--parent = _frmX.handle._n,
				--model = "misc/cloud_item.png",
				--x = hVar.SCREEN.w / 2,
				--y = -hVar.SCREEN.h + 20,
				--z = 99999,
				--w = 420,
				--h = 10,
			--})
			
			----iPhoneX右侧刘海
			--hApi.CCScale9SpriteCreate("data/image/misc/bar_remould_bg.png", hVar.SCREEN.w - 80/2, -hVar.SCREEN.h / 2, 80, 380, _frmX, 99999)
		end
	end
	
	--主界面黑色背景图logo1
	local logo1_x = 200 * _ScaleW
	local logo1_y = -hVar.SCREEN.h + 150 * _ScaleH
	if (g_phone_mode == 1) then --iPhone4
		--logo1_y = -hVar.SCREEN.h + 160 * _ScaleH
	elseif (g_phone_mode == 2) then --iPhone5
		--
	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
		--
	elseif (g_phone_mode == 4) then --iPhoneX
		--
	end
	_childUI["panel_bg_logo1"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png",
		x = logo1_x,
		y = logo1_y,
		w = 631 * 1.0,
		h = 396 * 1.0,
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		code = function()
			hApi.PlaySound("Button2")
			
			--打第一关
			if (g_curPlayerName == nil) then--没有账号
				return
			end
			
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			--读取第一关是否已通关
			--local chapterId = 1
			--local tabCh = hVar.tab_chapter[chapterId]
			--local firstmap = tabCh.firstmap --第一关
			local firstmap = hVar.GuideMap --第0关
			local isFinishFirstMap = LuaGetPlayerMapAchi(firstmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第0关
			print("firstmap"..3,isFinishFirstMap)
			if (isFinishFirstMap == 1) then --已通关第一关
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				--异常退出
				--table_print(tInfo)
				if tInfo.id and (tInfo.stage ~= 1 or tInfo.isguide == 1) and type(tInfo.lifecount) == "number" and tInfo.lifecount > 0 and tInfo.isclear ~= 1 and tInfo.istest ~= 1 then
					local nRandId = tInfo.id or 1
					hGlobal.event:event("LocalEvent_EnterRandMap",nRandId)
				else
					--进入坦克配置界面
					local mapname = hVar.MainBase
					local MapDifficulty = 0
					local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
					xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
				end
			else
				GameManager.GameStart(hVar.GameType.BEGINNER)
			end
		end,
	})
	_childUI["panel_bg_logo1"].handle.s:setOpacity(0) --为了挂载动态图

	local img91 = hApi.CCScale9SpriteCreate("data/image/panel/9sprite_bg_1.png",hVar.SCREEN.w/2,-hVar.SCREEN.h + 40,hVar.SCREEN.w,80,_frm,-10)
	img91:setOpacity(100)

	_childUI["lab_eightMantra"] = hUI.label:new({
		parent = _parent,
		x = hVar.SCREEN.w/2,
		y = -hVar.SCREEN.h + 52,
		text = hVar.tab_string["eightMantra1"]..hVar.tab_string["eightMantra2"]..hVar.tab_string["eightMantra3"]..hVar.tab_string["eightMantra4"],
		size = 16,
		font = hVar.FONTC,
		align = "MC",
		--RGB = {180,180,180},
	})

	_childUI["lab_copyright"] = hUI.label:new({
		parent = _parent,
		x = hVar.SCREEN.w/2,
		y = -hVar.SCREEN.h + 26,
		text = hVar.tab_string["copyright"],
		size = 16,
		font = hVar.FONTC,
		align = "MC",
		--RGB = {180,180,180},
	})

	_childUI["img_age"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "misc/age12+.png",
		x = hVar.SCREEN.w - 80,
		y = -hVar.SCREEN.h + 40,
	})
	
	--主界面黑色背景图logo2
	local logo2_x = hVar.SCREEN.w - 650 * _ScaleW
	local logo2_y = -hVar.SCREEN.h + 330 * _ScaleH
	if (g_phone_mode ~= 0) then --手机模式
		--iphone5
		logo2_x = hVar.SCREEN.w - 610 * _ScaleW
		logo2_y = -hVar.SCREEN.h + 410 * _ScaleH
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			--参数配置
			--iPhone4
		end
		
		--iphoneX
		if (hVar.SCREEN.w >= 1560) then
			logo2_x = hVar.SCREEN.w - 540 * _ScaleW
			logo2_y = -hVar.SCREEN.h + 410 * _ScaleH
		end
	end
	_childUI["panel_bg_logo2"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png",
		x = logo2_x,
		y = logo2_y,
		w = 631,
		h = 396,
		--[[
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		code = function()
			--打第一关
			--跳转
			local __MAPDIFF = 0
			local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
			local mapName = "world/yqzc_001"
			xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
		end,
		]]
	})
	_childUI["panel_bg_logo2"].handle.s:setOpacity(0) --为了挂载动态图
	
	--主界面顶部栏
	_childUI["menu_top"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "UI:PANEL_MENU_NEW_TOP",
		x = hVar.SCREEN.w / 2,
		y = -100 * _ScaleH / 2,
		w = hVar.SCREEN.w,
		h = 100 * _ScaleH,
	})
	
	--主界面底部栏
	_childUI["menu_bottom"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "UI:PANEL_MENU_NEW_BOTTOM",
		x = hVar.SCREEN.w / 2,
		y = -hVar.SCREEN.h + 125 * _ScaleH / 2,
		w = hVar.SCREEN.w,
		h = 125 * _ScaleH,
	})
	--print(_ScaleH)
	
	---------------------------------------------------
	--剧情
	--local minScale = (_ScaleW < _ScaleH) and (_ScaleW) or (_ScaleH)
	local minScale = (g_phone_mode ~= 0) and (0.9) or (0.86) --手机/平板
	local minDeltaY = (g_phone_mode ~= 0) and (10 * _ScaleH) or (6 * _ScaleH) --手机/平板
	_childUI["menu_plot"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png", --"UI:menu_image_plot",
		--align = "MC",
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		x = hVar.SCREEN.w / 2 - 321 * minScale,
		y = -hVar.SCREEN.h / 2 + minDeltaY,
		--smartWH = 1,
		w = 563 * minScale,
		h = 557 * minScale,
		code = function()
			--打开面板后不响应
			if __isOpenSubFrm then
				return
			end
			
			--没有账号，不能进入剧情
			if (g_curPlayerName == nil) then
				--冒字
				--local strText = "当前没有存档，无法进入战役！" --language
				local strText = hVar.tab_string["__TEXT_NoPlayerDisabelEnter"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				
				return
			end
			
			--播完动画再显示
			HideMainFrameButtonAction(function()
				--标记状态
				_nIsShowState = 0
				
				--__hideTop()
				--ShowMainFrameButtonAction()
				--隐藏本界面
				hGlobal.UI.Phone_MainPanelFrm:show(0)
				
				--动态删除资源
				__DynamicRemoveRes()
				
				--删除英雄例会资源
				--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
				--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
				local tRelease = {}
				local tPng = hUI.SYSAutoReleaseUI.png
				for i = 1, #tPng, 1 do
					local path = tPng[i]
					tRelease[path] = 1
				end
				hResource.model:releasePng(tRelease)
				hUI.SYSAutoReleaseUI.png = {idx = {}}
				
				--释放png, plist的纹理缓存（这里不清理也可以）
				--hApi.ReleasePngTextureCache()
				
				--回收lua内存
				collectgarbage()
				
				--检测要返回哪一章
				local chapterId = 1
				if (type(__g_chapterId) == "number") and (__g_chapterId > 0) and (__g_chapterId <= #hVar.tab_chapter) then
					if (__g_chapterId > 1) then
						--检测是否通关上章最后一关
						local tabCh = hVar.tab_chapter[__g_chapterId - 1]
						local lastmap = tabCh.lastmap --最后一关
						local isFinishLastMap = LuaGetPlayerMapAchi(lastmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关最后一关
						if (isFinishLastMap == 1) then --已通关上章最后一关
							chapterId = __g_chapterId
						end
					end
				end
				
				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
			end)
		end,
	})
	_childUI["menu_plot"].handle.s:setOpacity(0) --为了挂载动态图
	--剧情"锁"
	_childUI["menu_plot"].childUI["lock"] = hUI.image:new({
		parent = _childUI["menu_plot"].handle._n,
		model = "UI:LockLine",
		x = -20 * minScale,
		y = -226 * minScale,
		z = 1,
		w = 494 * minScale,
		h = 66 * minScale,
	})
	
	--无尽挑战
	_childUI["menu_endless"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png", --UI:menu_image_challenge",
		align = "MC",
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		x = hVar.SCREEN.w / 2 + 73 * minScale,
		y = -hVar.SCREEN.h / 2 - 138 * minScale + minDeltaY,
		w = 430 * minScale,
		h = 295 * minScale,
		code = function()
			--打开面板后不响应
			if __isOpenSubFrm then
				return
			end
			
			--检测是否已经分段更新完成
			if (not (hApi.IsUpdate2Done())) then
				return
			end
			
			--是否通关"剿灭黄巾"
			local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap9 == 0) then
				--冒字
				--local strText = "通关【黄巾之乱】后，才能解锁无尽地图！" --language
				local strText = hVar.tab_string["__TEXT_ENDLESS_archiLock"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			else
				--触发事件：通知显示无尽地图界面
				hGlobal.event:event("LocalEvent_Phone_ShowEndlessMapInfoFrm", "world/td_wj_001")
				
				--打开了面板
				--__isOpenSubFrm = true
			end
		end,
	})
	_childUI["menu_endless"].handle.s:setOpacity(0) --为了挂载动态图
	--无尽挑战"锁"
	_childUI["menu_endless"].childUI["lock"] = hUI.image:new({
		parent = _childUI["menu_endless"].handle._n,
		model = "UI:LockLine",
		x = -20 * minScale,
		y = -88 * minScale,
		z = 1,
		w = 494 * minScale,
		h = 66 * minScale,
	})
	
	--夺塔奇兵
	_childUI["menu_pvp"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png", --"UI:menu_image_pvp",
		align = "MC",
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		x = hVar.SCREEN.w / 2 + 262 * minScale,
		y = -hVar.SCREEN.h / 2 + 138 * minScale + minDeltaY,
		w = 694 * minScale,
		h = 282 * minScale,
		code = function()
			--打开面板后不响应
			if __isOpenSubFrm then
				return
			end
			
			--检测是否已经分段更新完成
			if (not (hApi.IsUpdate2Done())) then
				return
			end
			
			--是否通关"剿灭黄巾"
			local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap9 == 0) then
				--冒字
				--local strText = "通关【黄巾之乱】后，才能解锁竞技场！" --language
				local strText = hVar.tab_string["__TEXT_PVP_archiLock"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			else
				--触发事件：通知显示pvp界面
				hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm")
				
				--打开了面板
				--__isOpenSubFrm = true
			end
		end,
	})
	_childUI["menu_pvp"].handle.s:setOpacity(0) --为了挂载动态图
	--夺塔奇兵"锁"
	_childUI["menu_pvp"].childUI["lock"] = hUI.image:new({
		parent = _childUI["menu_pvp"].handle._n,
		model = "UI:LockLine",
		x = -15 * minScale,
		y = -92 * minScale,
		z = 1,
		w = 494 * minScale,
		h = 66 * minScale,
	})
	--夺塔奇兵叹号
	_childUI["menu_pvp"].childUI["tanhao"] = hUI.image:new({
		parent = _childUI["menu_pvp"].handle._n,
		model = "UI:TaskTanHao",
		x = -150 * minScale,
		y = -92 * minScale + 1,
		z = 1,
		w = 52 * minScale,
		h = 52 * minScale,
	})
	local act1 = CCMoveBy:create(0.2, ccp(0, 6))
	local act2 = CCMoveBy:create(0.2, ccp(0, -6))
	local act3 = CCMoveBy:create(0.2, ccp(0, 6))
	local act4 = CCMoveBy:create(0.2, ccp(0, -6))
	local act5 = CCDelayTime:create(0.6)
	local act6 = CCRotateBy:create(0.1, 10)
	local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
	local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
	local act9 = CCRotateBy:create(0.1, -10)
	local act10 = CCDelayTime:create(0.8)
	local a = CCArray:create()
	a:addObject(act1)
	a:addObject(act2)
	a:addObject(act3)
	a:addObject(act4)
	a:addObject(act5)
	a:addObject(act6)
	a:addObject(act7)
	a:addObject(act8)
	a:addObject(act9)
	a:addObject(act10)
	local sequence = CCSequence:create(a)
	_childUI["menu_pvp"].childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
	_childUI["menu_pvp"].childUI["tanhao"].handle._n:setVisible(false) --默认隐藏
	
	--夺塔奇兵升级提示
	_childUI["menu_pvp"].childUI["lvup"] = hUI.image:new({
	parent = _childUI["menu_pvp"].handle._n,
		model = "ICON:image_jiantouV",
		x = -150 * minScale,
		y = -92 * minScale + 1 + 1,
		z = 1,
		w = 48 * minScale,
		h = 48 * minScale,
	})
	_childUI["menu_pvp"].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
	
	--铜雀台
	_childUI["menu_tongquetai"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask.png", --"UI:menu_image_multifb",
		dragbox = _childUI["dragBox"],
		scaleT = 0.99,
		x = hVar.SCREEN.w / 2 + 421 * minScale,
		y = -hVar.SCREEN.h / 2 - 138 * minScale + minDeltaY,
		w = 388 * minScale,
		h = 289 * minScale,
		code = function()
			--打开面板后不响应
			if __isOpenSubFrm then
				return
			end
			
			--触发事件：通知显示pvp铜雀台界面
			--hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm_Endless")
			
			--检测是否已经分段更新完成
			if (not (hApi.IsUpdate2Done())) then
				return
			end
			
			--是否通关"剿灭黄巾"
			local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap9 == 0) then
				--冒字
				--local strText = "通关【黄巾之乱】后，才能解锁多人副本！" --language
				local strText = hVar.tab_string["__TEXT_TONGQUETAI_archiLock"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			else
				--触发事件：通知显示pvp铜雀台界面
				hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm_Endless")
				
				--打开了面板
				--__isOpenSubFrm = true
			end
		end,
	})
	_childUI["menu_tongquetai"].handle.s:setOpacity(0) --为了挂载动态图
	--铜雀台"锁"
	_childUI["menu_tongquetai"].childUI["lock"] = hUI.image:new({
		parent = _childUI["menu_tongquetai"].handle._n,
		model = "UI:LockLine",
		x = 25 * minScale,
		y = -88 * minScale,
		z = 1,
		w = 494 * minScale,
		h = 66 * minScale,
	})
	---------------------------------------------------
	
	--当前操作的地图对象
	local __oMap
	
	--局部函数
	------------------------------------------------------------底部条------------------------------------------------------------
	local bottomMenuName = {"btnHero", "btnTatic", "btnMission", "btnChallenge", "btnItem", "btnPVP", "btnMail",}
	local bottomMenuNum = #bottomMenuName
	local bottomMenuText = {"__TEXT_MAINUI_BTN_HERO", "__TEXT_MAINUI_BTN_TACITC", "__TEXT_MAINUI_BTN_MISSION", "__TEXT_MAINUI_BTN_CHALLENGE", "__TEXT_MAINUI_BTN_ITEM", "__TEXT_MAINUI_BTN_PVP", "__TEXT_MAINUI_BTN_MAIL",}
	local bottomMenuTipType = {1, 1, 2, 0, 0, 2, 2} --(0:无 / 1:箭头 / 2:感叹号 / 3:倒计时日期)
	local bottomMenuModel = {
		[1] = {"icon/item/item_treasure02.png", 0, 5, 1.0}, --点将台
		[2] = {"icon/item/card_lv2.png", 0, 5, 1.0}, --战术卡
		[3] = {"icon/item/item_book01.png", 0, 8, 1.0}, --任务活动
		[4] = {"icon/item/item_treasure01.png", 0, 5, 1.0}, --挑战
		[5] = {"icon/item/item_weapon19.png", 0, 5, 1.0}, --道具
		[6] = {"UI:JJC", 0, 7, 0.9}, --PVP对战
		[7] = {"ui/xf.png", 0, 5, 1.0}, --邮件
		
	}
	local bottomMenuCode = {
		--点将台
		[1] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				--geyachao: 触发引导事件：点到了点将台按钮
				hGlobal.event:event("LocalEvent_Click_Guide_HeroButton")
				
				return
			end
			
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			--print("播完动画再显示", debug.traceback())
			--播完动画再显示
			HideMainFrameButtonAction(function()
				--标记状态
				_nIsShowState = 0
				
				hGlobal.event:event("LocalEvent_Phone_ShowMyHerocard")
				--__hideTop()
				--ShowMainFrameButtonAction()
			end)
		end,
		
		--战术卡
		[2] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				--geyachao: 触发引导事件：点到了战术技能卡按钮
				hGlobal.event:event("LocalEvent_Click_Guide_TacticButton")
				
				return
			end
			
			--print("bottomMenuCode[2]")
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			--触发事件：通知显示战术技能卡界面
			hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook",1,"playerCard")
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--任务成就
		[3] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				--geyachao: 触发引导事件：点到了战术技能卡按钮
				hGlobal.event:event("LocalEvent_Click_Guide_TaskButton")
				
				return
			end
			
			--print("bottomMenuCode[3]")
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			--geyachao: 触发事件: 打开任务面板
			--hGlobal.event:event("LocalEvent_Phone_ShowMyMedal")
			hGlobal.event:event("LocalEvent_Phone_ShowMyTask")
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--挑战关卡
		[4] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				return
			end
			
			--print("bottomMenuCode[4]")
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			hGlobal.event:event("LocalEvent_Phone_ShowChallengeMapInfoFrm", __oMap.data.chapterId)
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--道具按钮
		[5] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				return
			end
			
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			--触发事件：通知显示道具界面
			hGlobal.event:event("localEvent_ShowPhone_ItemFrame", nil, nil, nil, nil, nil)
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--竞技场对战
		[6] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				
				return
			end
			
			--print("bottomMenuCode[2]")
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName, LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			--触发事件：通知显示pvp界面
			hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm")
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--邮件按钮
		[7] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				return
			end
			
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName, LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			hGlobal.event:event("LocalEvent_ShowWebViewNews", 1) --公告
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
	}
	local bottomMenuUnlock = 
	{
		--{解锁类型（0自动解锁 1通关关卡解锁）,解锁判断（nil, 地图名）}
		[1] = {1, "world/td_001_lsc"}, --点将台按钮
		[2] = {-1, "world/td_002_zjtj"}, --战术按钮
		[3] = {1, "world/td_001_lsc"}, --任务按钮
		[4] = {-1, "world/td_001_lsc"}, --挑战按钮
		[5] = {-1, "world/td_002_zjtj"}, --道具按钮
		[6] = {1, "world/td_002_zjtj"}, --PVP对战按钮 --geyachao: 出外网版本暂时关闭
		[7] = {1, "world/td_002_zjtj"}, --邮件按钮
	}
	
	------------------------------------------------------------顶部条------------------------------------------------------------
	local topMenuNum = 2
	local topMenuName = {"btnShop", "btnGift",}
	local topMenuText = {"__TEXT_NetShopTitle", "__Reward__",}
	local topMenuTipType = {2, 2} --(0:无 / 1:箭头 / 2:感叹号 / 3:倒计时日期)
	local topMenuModel = {
		[1] = "ui/shop.png",
		[2] = "UI:GIFT",
	}
	local topMenuCode = {
		--商店
		[1] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				--geyachao: 触发引导事件：点到了商店按钮
				hGlobal.event:event("LocalEvent_Click_Guide_ShopButton")
			
				return
			end
			
			if __isOpenSubFrm then
				return
			end
			
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			--没有网络时无法打开商店
			if (g_cur_net_state ~= 1) then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tSendNetShop"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			if Save_PlayerData and Save_PlayerData.herocard and #Save_PlayerData.herocard > 0 then
				hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx","hall")
			else
				--add by pangyong 2015/3/25(没有英雄将不能打开商店，已经在主menu中设置了，所以此处没有用了，相应的文件phone_noheroopenshop.lua已删除)
				--hGlobal.event:event("localEvent_OpenNoHeroOpenShopFrm")
			end
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
		
		--奖励按钮
		[2] = function(self)
			--geyachao: 在引导中，不能打开该界面
			if (hVar.IS_IN_GUIDE_STATE == 1) then
				
				return
			end
			
			--print("bottomMenuCode[2]")
			if __isOpenSubFrm then
				return
			end
			
			--是否新建账号
			if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
					font = hVar.FONTC,
					ok = function()
						hApi.xlSetPlayerInfo(1)
					end,
				})
				return
			end
			
			--没有网络时无法打开商店
			if g_cur_net_state ~= 1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tReceiveGift"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
			
			if g_curPlayerName then
				local pId = luaGetplayerDataID()
				--if not pId or pId == 0 then
					SendCmdFunc["send_RoleData"](g_curPlayerName,LuaGetPlayerScore())
					--SendCmdFunc["send_DepletionItemInfo"](g_curPlayerName,9006)
				--end
			end
			
			--打开奖励面板
			hGlobal.event:event("LocalEvent_Phone_ShowMyGift") 
			hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--打开了面板
			--__isOpenSubFrm = true
		end,
	}
	
	local topMenuUnlock = 
	{
		--{解锁类型（0自动解锁 1通关关卡解锁）,解锁判断（nil, 地图名）}
		[1] = {1, "world/td_002_zjtj"}, --商店按钮
		[2] = {1, "world/td_002_zjtj"}, --奖励按钮
	}
	
	--创建顶部各种信息
	--_childUI["btnPlayerBg"] = hUI.image:new({
	--	parent = _parent,
	--	model = "UI_frm:slot",
	--	animation = "lightSlim",
	--	x = 60,
	--	y = hVar.SCREEN.h-60,
	--	w = 100,
	--	h = 100,
	--})
	--_childUI["btnPlayer"] = hUI.button:new({
	--	parent = _parent,
	--	--model = model = hVar.tab_unit[heroList[i].id].portrait,
	--	model = "icon/portrait/hero_diaochan_s.png",
	--	x = 60,
	--	y = hVar.SCREEN.h-60,
	--	w = 90,
	--	h = 90,
	--	scaleT = 0.9,
	--	font = hVar.FONTC,
	--	border = 1,
	--	code = function()
	--		--todo：切换玩家读取存档
	--	end,
	--})
		
	----创建顶部章节信息
	--_childUI["chapterName"] = hUI.node:new({
	--	parent = _parent,
	--	--x = 215,
	--	x = 100,
	--	y = hVar.SCREEN.h-30,
	--})
	--_childUI["chapterName"].childUI["img"] = hUI.image:new({
	--	parent = _childUI["chapterName"].handle._n,
	--	--model = "UI:MedalDarkImg",
	--	model = "UI:selectbg2",
	--	x = 0,
	--	y = 0,
	--	w = 250,
	--	h = 40,
	--})
	--_childUI["chapterName"].childUI["lab"] = hUI.label:new({
	--	parent = _childUI["chapterName"].handle._n,
	--	x = 0,
	--	y = 0,
	--	text = "",
	--	size = 28,
	--	font = hVar.FONTC,
	--	align = "MC",
	--	--RGB = {255,205,55},
	--})
	
	
	--创建底部按钮集
	local bottomMenuSet = {}
	local bottomMenuBgSet = {}
	local bottomMenuBgEffSet = {}
	for i = 1, bottomMenuNum, 1 do
		if bottomMenuName[i] then
			local func = bottomMenuCode[i]
			if (not func) then
				func = hApi.DoNothing
			end
			
			local callfun = function()
				--检测作弊
				local cheatflag = xlGetIntFromKeyChain("cheatflag")
				local userID = xlPlayer_GetUID()
				if (cheatflag == 1) then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
						font = hVar.FONTC,
						ok = function()
							xlExit()
						end,
					})
					return
				end
				
				func()
			end
			
			--背景特效
			--_childUI[bottomMenuName[i].."_bgEff"] = hUI.image:new({
			--	parent = _frm.handle._n,
			--	model = "UI:BeginBattleBgLight",
			--	x = hVar.SCREEN.w - 60 - (i - 1) * 110,
			--	y = 85,
			--	z = -1,
			--	scale = 0.38,
			--	--color = {233,150,122},
			--})
			--bottomMenuBgEffSet[i] = _childUI[bottomMenuName[i].."_bgEff"]
			--bottomMenuBgEffSet[i].handle._n:setVisible(true)
			
			--local a = CCScaleBy:create(1.8,1.1,1.15)
			--local aR = a:reverse()
			--local seqA = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
			--bottomMenuBgEffSet[i].handle._n:runAction(CCRepeatForever:create(seqA))
			
			local scaleB = 1.0
			if (i == 1) then
				scaleB = 1.2
			end
			_childUI[bottomMenuName[i].."_bg"] = hUI.button:new({
				parent = _frm.handle._n,
				model = "UI:mainmenu_slot",
				x = hVar.SCREEN.w - 60 - (i - 1) * 110,
				y = -hVar.SCREEN.h + 60 * _ScaleH, --统一调整底部条y坐标
				scale = scaleB,
			})
			bottomMenuBgSet[i] = _childUI[bottomMenuName[i].."_bg"]
			bottomMenuBgSet[i].handle._n:setVisible(true)
			
			--bottomMenuBgSet[i].childUI["img"] = hUI.image:new({
			--	parent = bottomMenuBgSet[i].handle._n,
			--	--model = "UI:BTN_ButtonRed",
			--	model = "misc/selectbg.png",
			--	x = 52,
			--	y = 14,
			--	scale = 0.75,
			--})
			bottomMenuBgSet[i].childUI["lab"] = hUI.label:new({
				parent = bottomMenuBgSet[i].handle._n,
				x = 0,
				y = -40,
				text = hVar.tab_string[bottomMenuText[i]] or "btn:".. tostring(i),
				size = 22,
				font = hVar.FONTC,
				border = 1,
				align = "MC",
			})
			
			--底部按钮（只用于响应事件，不显示）
			_childUI[bottomMenuName[i]] = hUI.button:new({
				parent = _frm,
				model = "misc/mask.png",
				--x = 50 + (i - 1) * 90,
				x = hVar.SCREEN.w - 60 - (i - 1) * 110,
				y = -hVar.SCREEN.h + 60 * _ScaleH, --统一调整底部条y坐标
				w = 109,
				h = 110,
				scaleT = 0.95,
				font = hVar.FONTC,
				border = 1,
				code = callfun,
			})
			bottomMenuSet[i] = _childUI[bottomMenuName[i]]
			bottomMenuSet[i]:setstate(1)
			_childUI[bottomMenuName[i]].handle.s:setOpacity(0) --只用于响应事件，不显示
			
			--底部图片
			_childUI[bottomMenuName[i]].childUI["image"] = hUI.button:new({
				parent = _childUI[bottomMenuName[i]].handle._n,
				model = bottomMenuModel[i] and bottomMenuModel[i][1],
				x = bottomMenuModel[i] and bottomMenuModel[i][2] or 0,
				y = bottomMenuModel[i] and bottomMenuModel[i][3] or 0,
				scale = bottomMenuModel[i] and bottomMenuModel[i][4] * scaleB or 1.0,
			})
			
			--底部特效
			--(无)
			
			--提示有可以升级的操作
			local tipType = bottomMenuTipType[i] or 0
			if (tipType == 1) then --箭头
				_childUI[bottomMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[bottomMenuName[i]].handle._n,
					model = "ICON:image_jiantouV",
					x = 25,
					y = 20,
					scale = 1.0,
				})
				_childUI[bottomMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			elseif (tipType == 2) then --叹号
				_childUI[bottomMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[bottomMenuName[i]].handle._n,
					model = "UI:TaskTanHao",
					x = 25,
					y = 25,
					scale = 1.0,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 6))
				local act2 = CCMoveBy:create(0.2, ccp(0, -6))
				local act3 = CCMoveBy:create(0.2, ccp(0, 6))
				local act4 = CCMoveBy:create(0.2, ccp(0, -6))
				local act5 = CCDelayTime:create(0.6)
				local act6 = CCRotateBy:create(0.1, 10)
				local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
				local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
				local act9 = CCRotateBy:create(0.1, -10)
				local act10 = CCDelayTime:create(0.8)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				a:addObject(act10)
				local sequence = CCSequence:create(a)
				_childUI[bottomMenuName[i]].childUI["lvup"].handle.s:runAction(CCRepeatForever:create(sequence))
				_childUI[bottomMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			elseif (tipType == 3) then --倒计时
				--竞技场测试期间
				--g_pvp_room_closetime
				--[=[
				_childUI[bottomMenuName[i]].childUI["lvup"] = hUI.label:new({
					parent = _childUI[bottomMenuName[i]].handle._n,
					size = 16,
					font = "numWhite",
					x = 50,
					y = 35,
					width = 200,
					align = "RC",
					--text = "--:--:--",
					text = "",
				})
				_childUI[bottomMenuName[i]].childUI["lvup"].handle.s:setColor(ccc3(0, 255, 0))
				]=]
				
				_childUI[bottomMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[bottomMenuName[i]].handle._n,
					model = "UI:TaskTanHao",
					x = 25,
					y = 25,
					scale = 1.0,
				})
				local act1 = CCScaleTo:create(1.5, 1.08)
				local act2 = CCScaleTo:create(1.5, 0.92)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				_childUI[bottomMenuName[i]].childUI["lvup"].handle.s:runAction(CCRepeatForever:create(sequence))
				_childUI[bottomMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			end
		end
	end
	
	--创建顶按钮集
	local topMenuSet = {}
	local topMenuBgSet = {}
	local topMenuBgEffSet = {}
	for i = 1, topMenuNum, 1 do
		if topMenuName[i] then
			local func = topMenuCode[i]
			if (not func) then
				func = hApi.DoNothing
			end
			
			local callfun = function()
				--检测作弊
				local cheatflag = xlGetIntFromKeyChain("cheatflag")
				local userID = xlPlayer_GetUID()
				if (cheatflag == 1) then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
						font = hVar.FONTC,
						ok = function()
							xlExit()
						end,
					})
					return
				end
				
				func()
			end
			
			--背景特效
			_childUI[topMenuName[i].."_bgEff"] = hUI.image:new({
				parent = _frm.handle._n,
				model = "UI:BeginBattleBgLight",
				x = hVar.SCREEN.w - 60 - (i - 1) * 110,
				y = -60 * _ScaleH,
				z = -1,
				scale = 0.38,
				--color = {233,150,122},
			})
			topMenuBgEffSet[i] = _childUI[topMenuName[i].."_bgEff"]
			topMenuBgEffSet[i].handle._n:setVisible(true)
			
			local a = CCScaleBy:create(1.8,1.1,1.15)
			local aR = a:reverse()
			local seqA = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
			topMenuBgEffSet[i].handle._n:runAction(CCRepeatForever:create(seqA))
			
			_childUI[topMenuName[i].."_bg"] = hUI.button:new({
				parent = _frm.handle._n,
				model = "UI:mainmenu_slot",
				x = hVar.SCREEN.w - 60 - (i - 1) * 110,
				--y = 85,
				y = -60 * _ScaleH,
			})
			topMenuBgSet[i] = _childUI[topMenuName[i].."_bg"]
			topMenuBgSet[i].handle._n:setVisible(true)
			
			--topMenuBgSet[i].childUI["img"] = hUI.image:new({
			--	parent = topMenuBgSet[i].handle._n,
			--	--model = "UI:BTN_ButtonRed",
			--	model = "misc/selectbg.png",
			--	x = 52,
			--	y = 14,
			--	scale = 0.75,
			--})
			topMenuBgSet[i].childUI["lab"] = hUI.label:new({
				parent = topMenuBgSet[i].handle._n,
				x = 0,
				y = -40,
				text = hVar.tab_string[topMenuText[i]] or "btn:".. tostring(i),
				size = 22,
				font = hVar.FONTC,
				border = 1,
				align = "MC",
			})
			
			--顶部按钮（只用于响应事件，不显示）
			_childUI[topMenuName[i]] = hUI.button:new({
				parent = _frm,
				model = "misc/mask.png",
				--x = 50 + (i - 1) * 90,
				x = hVar.SCREEN.w - 60 - (i - 1) * 110,
				--y = 93,
				y = -60 * _ScaleH,
				w = 109,
				h = 110,
				scaleT = 0.95,
				font = hVar.FONTC,
				border = 1,
				code = callfun,
			})
			topMenuSet[i] = _childUI[topMenuName[i]]
			topMenuSet[i]:setstate(1)
			_childUI[topMenuName[i]].handle.s:setOpacity(0) --只用于响应事件，不显示
			
			--顶部图片
			_childUI[topMenuName[i]].childUI["image"] = hUI.image:new({
				parent = _childUI[topMenuName[i]].handle._n,
				model = topMenuModel[i] or "",
				x = 0,
				y = 0,
				scale = 1.0,
			})
			
			local b = CCScaleBy:create(0.6,1.1,1.1)
			local bR = b:reverse()
			local seqB = tolua.cast(CCSequence:createWithTwoActions(b,bR),"CCActionInterval")
			_childUI[topMenuName[i]].childUI["image"].handle._n:runAction(CCRepeatForever:create(seqB))
			
			--提示有可以升级的操作
			local tipType = topMenuTipType[i] or 0
			if (tipType == 1) then --箭头
				_childUI[topMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[topMenuName[i]].handle._n,
					model = "ICON:image_jiantouV",
					x = 25,
					y = 20 - 5,
					scale = 1.0,
				})
				_childUI[topMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			elseif (tipType == 2) then --叹号
				_childUI[topMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[topMenuName[i]].handle._n,
					model = "UI:TaskTanHao",
					x = 25,
					y = 25 - 5,
					scale = 1.0,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 6))
				local act2 = CCMoveBy:create(0.2, ccp(0, -6))
				local act3 = CCMoveBy:create(0.2, ccp(0, 6))
				local act4 = CCMoveBy:create(0.2, ccp(0, -6))
				local act5 = CCDelayTime:create(0.6)
				local act6 = CCRotateBy:create(0.1, 10)
				local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
				local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
				local act9 = CCRotateBy:create(0.1, -10)
				local act10 = CCDelayTime:create(0.8)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				a:addObject(act10)
				local sequence = CCSequence:create(a)
				_childUI[topMenuName[i]].childUI["lvup"].handle.s:runAction(CCRepeatForever:create(sequence))
				_childUI[topMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			elseif (tipType == 3) then --倒计时
				--竞技场测试期间
				--g_pvp_room_closetime
				--[=[
				_childUI[topMenuName[i]].childUI["lvup"] = hUI.label:new({
					parent = _childUI[topMenuName[i]].handle._n,
					size = 16,
					font = "numWhite",
					x = 50,
					y = 35 - 15,
					width = 200,
					align = "RC",
					--text = "--:--:--",
					text = "",
				})
				_childUI[topMenuName[i]].childUI["lvup"].handle.s:setColor(ccc3(0, 255, 0))
				]=]
				
				_childUI[topMenuName[i]].childUI["lvup"] = hUI.image:new({
					parent = _childUI[topMenuName[i]].handle._n,
					model = "UI:TaskTanHao",
					x = 25,
					y = 25 - 5,
					scale = 1.0,
				})
				local act1 = CCScaleTo:create(1.5, 1.08)
				local act2 = CCScaleTo:create(1.5, 0.92)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				_childUI[topMenuName[i]].childUI["lvup"].handle.s:runAction(CCRepeatForever:create(sequence))
				_childUI[topMenuName[i]].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			end
		end
	end
	
	--函数：显示主界面按钮动画
	ShowMainFrameButtonAction = function()
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--标记在打开面板中
		__isOpenSubFrm = true
		
		--大菠萝模式，就绘制一个开始游戏的按钮
		if (hVar.IS_DIABOLO_APP == 1) then
			--设置初始坐标
			--剧情战役
			_childUI["menu_plot"]:setXY(hVar.SCREEN.w / 2 - 321 * minScale - (hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2), -hVar.SCREEN.h / 2 + minDeltaY)
			--铜雀台
			_childUI["menu_tongquetai"]:setXY(hVar.SCREEN.w / 2 + 421 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
			--夺塔奇兵
			_childUI["menu_pvp"]:setXY(hVar.SCREEN.w / 2 + 262 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2), -hVar.SCREEN.h / 2 + 137 * minScale + minDeltaY)
			--无尽挑战
			_childUI["menu_endless"]:setXY(hVar.SCREEN.w / 2 + 73 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
			--顶部栏
			_childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, -100 * _ScaleH / 2 + (100 * _ScaleH))
			--底部栏
			_childUI["menu_bottom"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h + 125 * _ScaleH / 2 - (125 * _ScaleH))
			
			--底部条
			for i = 1, bottomMenuNum, 1 do
				local btnMenu = bottomMenuSet[i]
				local btnMenuBg = bottomMenuBgSet[i]
				local btnMenuBgEff = bottomMenuBgEffSet[i]
				
				if btnMenu then
					local px, py = btnMenu.data.x, btnMenu.data.y
					btnMenu:setXY(px, py + (-150 * _ScaleH))
				end
				if btnMenuBg then
					local px, py = btnMenuBg.data.x, btnMenuBg.data.y
					btnMenuBg:setXY(px, py + (-150 * _ScaleH))
				end
				if btnMenuBgEff then
					local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
					btnMenuBgEff:setXY(px, py + (-150 * _ScaleH))
				end
			end
			--顶部条
			for i = 1, bottomMenuNum, 1 do
				local btnMenu = topMenuSet[i]
				local btnMenuBg = topMenuBgSet[i]
				local btnMenuBgEff = topMenuBgEffSet[i]
				
				if btnMenu then
					local px, py = btnMenu.data.x, btnMenu.data.y
					btnMenu:setXY(px, py + (150 * _ScaleH))
				end
				if btnMenuBg then
					local px, py = btnMenuBg.data.x, btnMenuBg.data.y
					btnMenuBg:setXY(px, py + (150 * _ScaleH))
				end
				if btnMenuBgEff then
					local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
					btnMenuBgEff:setXY(px, py + (150 * _ScaleH))
				end
			end
			
			local firstmap1 = hVar.tab_chapter[1].firstmap --第一关
			local isFinishFirstMap1 = LuaGetPlayerMapAchi(firstmap1, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第一关
			--print(isFinishFirstMap1)
			
			--[[
			if (isFinishFirstMap1 == 1) then --已有存档
				hApi.safeRemoveT(_childUI, "startDiablo")
				
				--继续游戏的按钮
				if (not _childUI["contiueDiablo"]) then
					_childUI["contiueDiablo"] = hUI.button:new({
						parent = _frm.handle._n,
						model = "UI:BTN_ButtonRed",
						x = hVar.SCREEN.w / 2,
						y = -hVar.SCREEN.h / 2 - 60 - 200,
						dragbox = _childUI["dragBox"],
						label = {text = "继续游戏", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
						w = 240,
						h = 80,
						scaleT = 0.95,
						code = function(self)
							--启动打过的最后一关
							local lastMapName = nil
							local maxChapter = 0
							if hVar.tab_chapter then
								maxChapter = #hVar.tab_chapter
							end
							for chapterId = maxChapter, 1, -1 do
								local tabCh = hVar.tab_chapter[chapterId]
								local firstmap = tabCh.firstmap --本章的第一关
								local lastmap = tabCh.lastmap --本章的最后一关
								local isFinishFirstMap = LuaGetPlayerMapAchi(firstmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关本章第一关
								if (isFinishFirstMap == 1) then
									local currentmap = firstmap
									while true do
										--地图是否有效
										if (currentmap == nil) then
											break
										end
										
										--地图表
										local tabM = hVar.MAP_INFO[currentmap]
										
										--地图是否存在
										if (tabM == nil) then
											break
										end
										
										--是否通关本关
										local isFinishCurrentMap = LuaGetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关本关
										if (isFinishCurrentMap == 1) then
											--继续
											local nextmap = tabM.nextmap[1] --下一张图
											--print("nextmap", nextmap)
											
											--是否到最后一个地图
											if (currentmap == lastmap) then
												break
											end
											
											--是否和本关重复
											if (currentmap == nextmap) then
												break
											end
											
											--通过
											currentmap = nextmap
										else
											--未通关
											break
										end
									end
									
									lastMapName = currentmap
									
									break
								end
							end
							
							--新玩游戏
							if (lastMapName == nil) then
								lastMapName = hVar.tab_chapter[1].firstmap
							end
							
							--跳转
							local __MAPDIFF = 0
							local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
							xlScene_LoadMap(g_world, lastMapName,__MAPDIFF,__MAPMODE)
						end,
					})
				end
				
				--重新开始游戏的按钮
				if (not _childUI["beginDiablo"]) then
					_childUI["beginDiablo"] = hUI.button:new({
						parent = _frm.handle._n,
						model = "UI:BTN_ButtonRed",
						x = hVar.SCREEN.w / 2,
						y = -hVar.SCREEN.h / 2 + 60 - 200,
						dragbox = _childUI["dragBox"],
						label = {text = "重新开始", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
						w = 240,
						h = 80,
						scaleT = 0.95,
						code = function(self)
							--打第一关
							--跳转
							local __MAPDIFF = 0
							local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
							xlScene_LoadMap(g_world, firstmap1,__MAPDIFF,__MAPMODE)
						end,
					})
				end
				
				--血腥大地的按钮
				if (not _childUI["exDiablo"]) then
					_childUI["exDiablo"] = hUI.button:new({
						parent = _frm.handle._n,
						model = "UI:BTN_ButtonRed",
						x = hVar.SCREEN.w / 2,
						y = -hVar.SCREEN.h / 2 + 60 + 200,
						dragbox = _childUI["dragBox"],
						label = {text = "血腥大地", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
						w = 240,
						h = 80,
						scaleT = 0.95,
						code = function(self)
							--打第一关
							--跳转
							local __MAPDIFF = 0
							local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
							local mapName = "world/yqzc_001"
							xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
						end,
					})
				end
			else --新玩家
				hApi.safeRemoveT(_childUI, "contiueDiablo")
				hApi.safeRemoveT(_childUI, "beginDiablo")
				
				--重新开始游戏的按钮
				if (not _childUI["startDiablo"]) then
					_childUI["startDiablo"] = hUI.button:new({
						parent = _frm.handle._n,
						model = "UI:BTN_ButtonRed",
						x = hVar.SCREEN.w / 2,
						y = -hVar.SCREEN.h / 2 - 200,
						dragbox = _childUI["dragBox"],
						label = {text = "开始游戏", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
						w = 240,
						h = 80,
						scaleT = 0.95,
						code = function(self)
							--打第一关
							--跳转
							local __MAPDIFF = 0
							local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
							xlScene_LoadMap(g_world, firstmap1,__MAPDIFF,__MAPMODE)
						end,
					})
				end
			end
			]]
			
			--[[
			--血腥大地的按钮
			if (not _childUI["exDiablo"]) then
				_childUI["exDiablo"] = hUI.button:new({
					parent = _frm.handle._n,
					model = "ui/pvp/pvptimeoutbg2.png",
					x = 120 + 40,
					y = -hVar.SCREEN.h + 20 + 40,
					dragbox = _childUI["dragBox"],
					--label = {text = "血腥大地", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
					label = {text = "开始游戏", x = 0, y = -2, size = 36,font = hVar.FONTC,border = 1,}, --"开始对战"
					w = 240,
					h = 60,
					scaleT = 0.95,
					code = function(self)
						--打第一关
						--跳转
						local __MAPDIFF = 0
						local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
						local mapName = "world/yqzc_001"
						xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
					end,
				})
			end
			]]
			
			return
		end
		
		--创建新主界面
		_refreshMainFrm()
		
		--第一次启动游戏，直接显示界面，不需要动画
		if _IS_FIRST_ENTER then
			--标记不是第一次启动游戏
			_IS_FIRST_ENTER = false
			
			--触发回调前，显示菜单栏
			local _frm = hGlobal.UI.Phone_MainPanelFrm
			local _childUI = _frm.childUI
			--_childUI["newVer_btn"]:setstate(-1)
			--hApi.safeRemoveT(_childUI, "newVer")
			
			--大菠萝，不显示齿轮
			if _childUI["optional"] then
				_childUI["optional"]:setstate(-1)
			end
			
			--显示主公
			if _childUI["playerNameLab"] then
				--_childUI["apartline_back1"].handle._n:setVisible(true) --背景底纹1
				--_childUI["apartline_back2"].handle._n:setVisible(true) --背景底纹2
				--_childUI["BtnContinue"].handle._n:setVisible(true)
				_childUI["playerNameLab"].handle._n:setVisible(false) --玩家名lable --大菠萝隐藏
				_childUI["playerName"].handle._n:setVisible(false) --玩家名字 --大菠萝隐藏
				_childUI["playerNamePlayDay"].handle._n:setVisible(true) --您在
				_childUI["playerList"]:setstate(1) --玩家列表
			end
			
			--标记不在打开面板中
			__isOpenSubFrm = false
			
			if callback then
				callback()
			end
			
			return
		end
		
		--设置初始坐标
		--剧情战役
		_childUI["menu_plot"]:setXY(hVar.SCREEN.w / 2 - 321 * minScale - (hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2), -hVar.SCREEN.h / 2 + minDeltaY)
		--铜雀台
		_childUI["menu_tongquetai"]:setXY(hVar.SCREEN.w / 2 + 421 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--夺塔奇兵
		_childUI["menu_pvp"]:setXY(hVar.SCREEN.w / 2 + 262 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2), -hVar.SCREEN.h / 2 + 137 * minScale + minDeltaY)
		--无尽挑战
		_childUI["menu_endless"]:setXY(hVar.SCREEN.w / 2 + 73 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--顶部栏
		_childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, -100 * _ScaleH / 2 + (100 * _ScaleH))
		--底部栏
		_childUI["menu_bottom"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h + 125 * _ScaleH / 2 - (125 * _ScaleH))
		--底部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py + (-150 * _ScaleH))
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py + (-150 * _ScaleH))
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py + (-150 * _ScaleH))
			end
		end
		--顶部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py + (150 * _ScaleH))
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py + (150 * _ScaleH))
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py + (150 * _ScaleH))
			end
		end
		
		--剧情战役
		--往右做运动
		local px, py = _childUI["menu_plot"].data.x, _childUI["menu_plot"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_plot"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.01)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.2, ccp(px + hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2 + 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.05, ccp(px + hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_plot"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2
			_childUI["menu_plot"]:setXY(px + hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_plot"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_plot"].handle._n:runAction(sequence)
		
		--铜雀台
		--往左做运动
		local px, py = _childUI["menu_tongquetai"].data.x, _childUI["menu_tongquetai"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_tongquetai"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_tongquetai"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.04)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_tongquetai"].data.w/2 - 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_tongquetai"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_tongquetai"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_tongquetai"].data.w/2
			_childUI["menu_tongquetai"]:setXY(px - hVar.SCREEN.w/2 - _childUI["menu_tongquetai"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_tongquetai"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_tongquetai"].handle._n:runAction(sequence)
		
		--夺塔奇兵
		--往左做运动
		local px, py = _childUI["menu_pvp"].data.x, _childUI["menu_pvp"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_pvp"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_pvp"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.08)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_pvp"].data.w/2 - 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_pvp"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_pvp"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_pvp"].data.w/2
			_childUI["menu_pvp"]:setXY(px - hVar.SCREEN.w/2 - _childUI["menu_pvp"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_pvp"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_pvp"].handle._n:runAction(sequence)
		
		--无尽挑战
		--往左做运动
		local px, py = _childUI["menu_endless"].data.x, _childUI["menu_endless"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_endless"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_endless"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.12)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_endless"].data.w/2 - 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_endless"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_endless"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_endless"].data.w/2
			_childUI["menu_endless"]:setXY(px - hVar.SCREEN.w/2 - _childUI["menu_endless"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_endless"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_endless"].handle._n:runAction(sequence)
		
		--顶部栏
		--往下做运动
		local px, py = _childUI["menu_top"].data.x, _childUI["menu_top"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_top"].data.y = py - 100 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.16)
		--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.16, ccp(px, py - 100 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["menu_top"]:setXY(px, py - 100 * _ScaleH)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_top"].handle._n:runAction(sequence)
		
		--底部栏
		--往上做运动
		local px, py = _childUI["menu_bottom"].data.x, _childUI["menu_bottom"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_bottom"].data.y = py + 125 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.16)
		--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py - 10)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.16, ccp(px, py + 125 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_bottom"].data.y = py + 125 * _ScaleH
			_childUI["menu_bottom"]:setXY(px, py + 125 * _ScaleH)
		end)
		local act5 = CCDelayTime:create(0.08)
		local act6 = CCCallFunc:create(function()
			--触发回调前，显示菜单栏
			local _frm = hGlobal.UI.Phone_MainPanelFrm
			local _childUI = _frm.childUI
			--_childUI["newVer_btn"]:setstate(-1)
			--hApi.safeRemoveT(_childUI, "newVer")
			
			--大菠萝，不显示齿轮
			if _childUI["optional"] then
				_childUI["optional"]:setstate(-1)
			end
			
			--显示主公
			if _childUI["playerNameLab"] then
				--_childUI["apartline_back1"].handle._n:setVisible(true) --背景底纹1
				--_childUI["apartline_back2"].handle._n:setVisible(true) --背景底纹2
				--_childUI["BtnContinue"].handle._n:setVisible(true)
				_childUI["playerNameLab"].handle._n:setVisible(false) --玩家名lable --大菠萝隐藏
				_childUI["playerName"].handle._n:setVisible(false) --玩家名字 --大菠萝隐藏
				_childUI["playerNamePlayDay"].handle._n:setVisible(true) --您在
				_childUI["playerList"]:setstate(1) --玩家列表
			end
			
			--标记不在打开面板中
			__isOpenSubFrm = false
			
			if callback then
				callback()
			end
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		local sequence = CCSequence:create(a)
		_childUI["menu_bottom"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_bottom"].handle._n:runAction(sequence)
		
		--底部条动画
		local bottomRevY = 30
		local bottomDY = 150 * _ScaleH
		local bottomDelay = 0.16 + 0.04
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				
				--往上做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenu.data.y = py + bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + bottomDY + bottomRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenu.data.y = py + bottomDY
					btnMenu:setXY(px, py + bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenu.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenu.handle._n:runAction(sequence)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				
				--往上做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBg.data.y = py + bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + bottomDY + bottomRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBg.data.y = py + bottomDY
					btnMenuBg:setXY(px, py + bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBg.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBg.handle._n:runAction(sequence)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				
				--往上做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBgEff.data.y = py + bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + bottomDY + bottomRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBgEff.data.y = py + bottomDY
					btnMenuBgEff:setXY(px, py + bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBgEff.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBgEff.handle._n:runAction(sequence)
			end
		end
		
		--顶部条动画
		local topRevY = -30
		local topDY = -150 * _ScaleH
		local topDelay = 0.16 + 0.02
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenu.data.y = py + topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + topDY + topRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenu.data.y = py + topDY
					btnMenu:setXY(px, py + topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenu.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenu.handle._n:runAction(sequence)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBg.data.y = py + topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + topDY + topRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBg.data.y = py + topDY
					btnMenuBg:setXY(px, py + topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBg.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBg.handle._n:runAction(sequence)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBgEff.data.y = py + topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + topDY + topRevY)))
				local act3 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBgEff.data.y = py + topDY
					btnMenuBgEff:setXY(px, py + topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBgEff.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBgEff.handle._n:runAction(sequence)
			end
		end
	end
	
	--函数：隐藏主界面按钮动画
	HideMainFrameButtonAction = function(callback)
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--标记打开了面板
		__isOpenSubFrm = true
		
		--创建新主界面
		_refreshMainFrm()
		
		--立即隐藏菜单栏
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _childUI = _frm.childUI
		if _childUI["newVer_btn"] then
			_childUI["newVer_btn"]:setstate(-1)
		end
		hApi.safeRemoveT(_childUI, "newVer")
		
		--隐藏齿轮
		if _childUI["optional"] then
			_childUI["optional"]:setstate(-1)
		end
		
		--隐藏主公
		if _childUI["playerNameLab"] then
			--_childUI["apartline_back1"].handle._n:setVisible(false) --立即背景底纹1
			--_childUI["apartline_back2"].handle._n:setVisible(false) --背景底纹2
			--_childUI["BtnContinue"].handle._n:setVisible(false)
			_childUI["playerNameLab"].handle._n:setVisible(false) --玩家名lable
			_childUI["playerName"].handle._n:setVisible(false) --玩家名字
			_childUI["playerNamePlayDay"].handle._n:setVisible(false) --您在
			_childUI["playerList"]:setstate(-1) --玩家列表
		end
		
		--设置初始坐标
		--剧情战役
		_childUI["menu_plot"]:setXY(hVar.SCREEN.w / 2 - 321 * minScale, -hVar.SCREEN.h / 2 + minDeltaY)
		--铜雀台
		_childUI["menu_tongquetai"]:setXY(hVar.SCREEN.w / 2 + 421 * minScale, -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--夺塔奇兵
		_childUI["menu_pvp"]:setXY(hVar.SCREEN.w / 2 + 262 * minScale, -hVar.SCREEN.h / 2 + 137 * minScale + minDeltaY)
		--无尽挑战
		_childUI["menu_endless"]:setXY(hVar.SCREEN.w / 2 + 73 * minScale, -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--顶部栏
		_childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, -100 * _ScaleH / 2)
		--底部栏
		_childUI["menu_bottom"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h + 125 * _ScaleH / 2)
		--底部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py)
			end
		end
		--顶部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py)
			end
		end
		
		--剧情
		--往左做运动
		local px, py = _childUI["menu_plot"].data.x, _childUI["menu_plot"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_plot"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_plot"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.01)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px + 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w/2 - _childUI["menu_plot"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_plot"].data.x = px - hVar.SCREEN.w/2 - _childUI["menu_plot"].data.w/2
			_childUI["menu_plot"]:setXY(px - hVar.SCREEN.w/2 - _childUI["menu_plot"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_plot"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_plot"].handle._n:runAction(sequence)
		
		--铜雀台
		--往右做运动
		local px, py = _childUI["menu_tongquetai"].data.x, _childUI["menu_tongquetai"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_tongquetai"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.04)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px + hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_tongquetai"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2
			_childUI["menu_tongquetai"]:setXY(px + hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_tongquetai"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_tongquetai"].handle._n:runAction(sequence)
		
		--夺塔奇兵
		--往右做运动
		local px, py = _childUI["menu_pvp"].data.x, _childUI["menu_pvp"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_pvp"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.08)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px + hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_pvp"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2
			_childUI["menu_pvp"]:setXY(px + hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_pvp"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_pvp"].handle._n:runAction(sequence)
		
		--无尽挑战
		--往右做运动
		local px, py = _childUI["menu_endless"].data.x, _childUI["menu_endless"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_endless"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2
		end)
		local act1 = CCDelayTime:create(0.12)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px - 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px + hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_endless"].data.x = px + hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2
			_childUI["menu_endless"]:setXY(px + hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_endless"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_endless"].handle._n:runAction(sequence)
		
		--顶部栏
		--往上做运动
		local px, py = _childUI["menu_top"].data.x, _childUI["menu_top"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_top"].data.y = py + 100 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.16)
		--local act2 = CCEaseSineIn:create(CCMoveTo:create(0.05, ccp(px, py - 10)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + 100 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py + 100 * _ScaleH
			_childUI["menu_top"]:setXY(px, py + 100 * _ScaleH)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_top"].handle._n:runAction(sequence)
		
		--底部栏
		--往下做运动
		local px, py = _childUI["menu_bottom"].data.x, _childUI["menu_bottom"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_bottom"].data.y = py - 125 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.16)
		--local act2 = CCEaseSineIn:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - 125 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_bottom"].data.y = py - 125 * _ScaleH
			_childUI["menu_bottom"]:setXY(px, py - 125 * _ScaleH)
		end)
		local act5 = CCDelayTime:create(0.12)
		local act6 = CCCallFunc:create(function()
			--标记不在打开面板中
			--__isOpenSubFrm = false
			
			if callback then
				callback()
			end
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		local sequence = CCSequence:create(a)
		_childUI["menu_bottom"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_bottom"].handle._n:runAction(sequence)
		
		--底部条动画
		local bottomRevY = 30
		local bottomDY = 150 * _ScaleH
		local bottomDelay = 0.16 + 0.04
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenu.data.y = py - bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenu.data.y = py - bottomDY
					btnMenu:setXY(px, py - bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenu.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenu.handle._n:runAction(sequence)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBg.data.y = py - bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBg.data.y = py - bottomDY
					btnMenuBg:setXY(px, py - bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBg.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBg.handle._n:runAction(sequence)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBgEff.data.y = py - bottomDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + bottomDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + bottomRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - bottomDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBgEff.data.y = py - bottomDY
					btnMenuBgEff:setXY(px, py - bottomDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBgEff.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBgEff.handle._n:runAction(sequence)
			end
		end
		
		--顶部条动画
		local topRevY = -30
		local topDY = -150 * _ScaleH
		local topDelay = 0.16 + 0.02
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenu.data.y = py - topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenu.data.y = py - topDY
					btnMenu:setXY(px, py - topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenu.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenu.handle._n:runAction(sequence)
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBg.data.y = py - topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBg.data.y = py - topDY
					btnMenuBg:setXY(px, py - topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBg.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBg.handle._n:runAction(sequence)
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				
				--往下做运动
				local act0 = CCCallFunc:create(function()
					--立即设置逻辑坐标
					btnMenuBgEff.data.y = py - topDY
				end)
				local act1 = CCDelayTime:create(0.01 * i + topDelay)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.04, ccp(px, py + topRevY)))
				local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - topDY)))
				local act4 = CCCallFunc:create(function()
					--btnMenuBgEff.data.y = py - topDY
					btnMenuBgEff:setXY(px, py - topDY)
				end)
				local a = CCArray:create()
				a:addObject(act0)
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				btnMenuBgEff.handle._n:stopAllActions() --先停掉之前可能的动画
				btnMenuBgEff.handle._n:runAction(sequence)
			end
		end
	end
	
	--函数：显示起名字界面动画
	ShowSetNameUIAction = function(index, callback)
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--标记在打开面板中
		__isOpenSubFrm = true
		
		--标记不是第一次启动
		_IS_FIRST_ENTER = false
		
		--创建新主界面
		_refreshMainFrm()
		
		--立即隐藏菜单栏
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _childUI = _frm.childUI
		if _childUI["newVer_btn"] then
			_childUI["newVer_btn"]:setstate(-1)
		end
		hApi.safeRemoveT(_childUI, "newVer")
		
		--隐藏齿轮
		if _childUI["optional"] then
			_childUI["optional"]:setstate(-1)
		end
		
		--隐藏主公
		if _childUI["playerNameLab"] then
			--_childUI["apartline_back1"].handle._n:setVisible(false) --立即背景底纹1
			--_childUI["apartline_back2"].handle._n:setVisible(false) --背景底纹2
			--_childUI["BtnContinue"].handle._n:setVisible(false)
			_childUI["playerNameLab"].handle._n:setVisible(false) --玩家名lable
			_childUI["playerName"].handle._n:setVisible(false) --玩家名字
			_childUI["playerNamePlayDay"].handle._n:setVisible(false) --您在
			_childUI["playerList"]:setstate(-1) --玩家列表
		end
		
		--设置初始坐标
		--剧情战役
		_childUI["menu_plot"]:setXY(hVar.SCREEN.w / 2 - 321 * minScale - (hVar.SCREEN.w/2 + _childUI["menu_plot"].data.w/2), -hVar.SCREEN.h / 2 + minDeltaY)
		--铜雀台
		_childUI["menu_tongquetai"]:setXY(hVar.SCREEN.w / 2 + 421 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_tongquetai"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--夺塔奇兵
		_childUI["menu_pvp"]:setXY(hVar.SCREEN.w / 2 + 262 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_pvp"].data.w/2), -hVar.SCREEN.h / 2 + 137 * minScale + minDeltaY)
		--无尽挑战
		_childUI["menu_endless"]:setXY(hVar.SCREEN.w / 2 + 73 * minScale + (hVar.SCREEN.w/2 + _childUI["menu_endless"].data.w/2), -hVar.SCREEN.h / 2 - 140 * minScale + minDeltaY)
		--顶部栏
		_childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, -100 * _ScaleH / 2 + (100 * _ScaleH))
		--底部栏
		_childUI["menu_bottom"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h + 125 * _ScaleH / 2 - (125 * _ScaleH))
		--底部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py + (-150 * _ScaleH))
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py + (-150 * _ScaleH))
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py + (-150 * _ScaleH))
			end
		end
		--顶部条
		for i = 1, bottomMenuNum, 1 do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			
			if btnMenu then
				local px, py = btnMenu.data.x, btnMenu.data.y
				btnMenu:setXY(px, py + (150 * _ScaleH))
			end
			if btnMenuBg then
				local px, py = btnMenuBg.data.x, btnMenuBg.data.y
				btnMenuBg:setXY(px, py + (150 * _ScaleH))
			end
			if btnMenuBgEff then
				local px, py = btnMenuBgEff.data.x, btnMenuBgEff.data.y
				btnMenuBgEff:setXY(px, py + (150 * _ScaleH))
			end
		end
		
		--------------------------------------------------------
		--先清除可能的上一次起名字控件
		--删除起名字的控件
		for i = 1, #_removeFrmList, 1 do
			hApi.safeRemoveT(_childUI, _removeFrmList[i])
		end
		_removeFrmList = {}
		
		--删除输入框
		if _enterNameEditBox then
			_parent:removeChild(_enterNameEditBox, true)
			_enterNameEditBox = nil
		end
		
		local MODEL_X = 360 --图片x
		local MODEL_Y = -50 --图片y
		local MODEL_WH = 468 --图片大小
		if (g_phone_mode ~= 0) then --手机模式
			MODEL_X = 360 --图片x
			MODEL_Y = -30 --图片y
			MODEL_WH = 468 --图片大小
		end
		
		--绘制起名字界面-左图
		_childUI["name_asset_l"] = hUI.image:new({
			parent = _parent,
			model = "misc/mask.png",
			x = MODEL_X * minScale / 2,
			y = -hVar.SCREEN.h / 2 + MODEL_Y * minScale,
			--smartWH = 1,
			w = MODEL_WH * minScale,
			h = MODEL_WH * minScale,
			
		})
		_removeFrmList[#_removeFrmList+1] = "name_asset_l"
		
		--绘制起名字界面-右图
		_childUI["name_asset_r"] = hUI.image:new({
			parent = _parent,
			model = "misc/mask.png",
			x = hVar.SCREEN.w - MODEL_X * minScale / 2,
			y = -hVar.SCREEN.h / 2 + MODEL_Y * minScale,
			--smartWH = 1,
			w = MODEL_WH * minScale,
			h = MODEL_WH * minScale,
			
		})
		_removeFrmList[#_removeFrmList+1] = "name_asset_r"
		
		--标题
		local OFFSETX = hVar.SCREEN.w / 2
		local OFFSETY = -hVar.SCREEN.h / 2 - 50 * _ScaleH
		local titleY = OFFSETY + 260 * _ScaleH
		if (g_phone_mode ~= 0) then --手机模式
			OFFSETX = hVar.SCREEN.w / 2
			OFFSETY = -hVar.SCREEN.h / 2
			titleY = -88 * _ScaleH / 2
		end
		--标题
		_childUI["name_TitleLbael"] = hUI.label:new({
			parent = _parent,
			x = OFFSETX,
			y = titleY,
			size = 42,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 1200,
			--text = "欢迎来到策马守天关", --language
			text = hVar.tab_string["welcome_cow1"], --language
		})
		_childUI["name_TitleLbael"].handle.s:setColor(ccc3(255, 255, 224))
		_removeFrmList[#_removeFrmList+1] = "name_TitleLbael"
		if (hVar.SYS_IS_NEWTD_APP == 1) then --新塔防app程序
			--_childUI["name_TitleLbael"]:setText("欢迎来到夺塔奇兵") --language
			_childUI["name_TitleLbael"]:setText(hVar.tab_string["welcome_cow1_newtd"]) --language
		end
		
		--提示输入文字
		_childUI["name_NoteInputLbael"] = hUI.label:new({
			parent = _parent,
			x = OFFSETX,
			y = OFFSETY + 80 * _ScaleH,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 500,
			--text = "为您的主公起个名字", --language
			text = hVar.tab_string["welcome_cow2"], --language
		})
		_removeFrmList[#_removeFrmList+1] = "name_NoteInputLbael"
		
		--关闭按钮
		if (index > 1) then
			_childUI["name_closeBtn"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
				model = "UI:return",
				x = 56 * _ScaleW,
				y = -hVar.SCREEN.h + 42 * _ScaleH,
				scaleT = 0.95,
				code = function()
					--打开面板后不响应
					if __isOpenSubFrm then
						return
					end
					
					--隐藏（删除）名字界面后，显示主界面
					HideSetNameUIAction(ShowMainFrameButtonAction)
				end,
			})
			_removeFrmList[#_removeFrmList+1] = "name_closeBtn"
		end
		
		--[[
		--输入框的底图
		IputBoxFrm.childUI["inputboxImg"] = hUI.image:new({
			parent = _parent,
			x = OFFSETX,
			y = OFFSETY - 15,
			w = 290,
			h = 36,
			model = "misc/tfback.png",
		})
		]]
		
		--输入框
		local rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			
			if (strEventName == "began") then
				--
			elseif (strEventName == "changed") then --改变事件
				--
			elseif (strEventName == "ended") then
				rgName = _enterNameEditBox:getText()
			elseif (strEventName == "return") then
				--
			end
			
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end
		
		_enterNameEditBox = CCEditBox:create(CCSizeMake(290, 46), CCScale9Sprite:create("data/image/misc/tfback.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		_enterNameEditBox:setPosition(ccp(OFFSETX + 0, OFFSETY + 25 * _ScaleH))
		--_enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		_enterNameEditBox:setFontSize(28)
		_enterNameEditBox:setFontColor(ccc3(255, 255, 255))
		_enterNameEditBox:setPlaceHolder("")--hVar.tab_string["enter_name_7_15"]
		_enterNameEditBox:setPlaceholderFontColor(ccc3(255, 122, 16))
		_enterNameEditBox:setMaxLength(128)
		_enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		_enterNameEditBox:setTouchPriority(0)
		_enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		_parent:addChild(_enterNameEditBox)
		
		--确定按钮
		--背景图
		_childUI["name_okButton"] = hUI.button:new({
			parent = _parent,
			--model = "misc/button_back.png",
			x = OFFSETX,
			y = OFFSETY - 100 * _ScaleH,
			scale = 1.2,
			scaleT = 0.95,
			dragbox = _childUI["dragBox"],
			code = function()
				--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
				local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
				if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
					rgName = _enterNameEditBox:getText()
				end
				
				--模拟发协议，转菊花
				--挡操作
				hUI.NetDisable(30000)
				
				local act1 = CCDelayTime:create(0.1)
				local act2 = CCCallFunc:create(function()
					--取消挡操作
					hUI.NetDisable(0)
					
					--验证名字是否有效
					rgName = string.lower(rgName) --转小写
					local answer, errInfo = LuaCheckPlayerName(rgName)
					--print(rgName, answer)
					if (answer == hVar.STRING_TRIM_MODE.SUCCEED) then
						--IputBoxFrm:del()
						--隐藏（删除）名字界面后，显示主界面
						HideSetNameUIAction(function()
							--设置新存档
							LuaSetPlayerList(index, rgName, "normal")
							Lua_UIShow_PlayerInfoFram(index)
						end)
					else
						--error
						--errInfo = "同的名"
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2 - 30,
							y = hVar.SCREEN.h / 2 - 40,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(errInfo, hVar.FONTC, 40, "LC", 0, 0,nil,1)
					end
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				local sequence = CCSequence:create(a)
				_parent:runAction(sequence)
			end,
		})
		_removeFrmList[#_removeFrmList+1] = "name_okButton"
		_childUI["name_okButton"].childUI["label"] = hUI.label:new({
			parent = _childUI["name_okButton"].handle._n,
			x = 0,
			y = -2,
			--text = "确定", --language
			align = "MC",
			size = 32,
			text = hVar.tab_string["Exit_Ack"], --language
			font = hVar.FONTC,
			border = 1,
		})
		
		--[[
		--顶部栏
		--往下做运动
		local px, py = _childUI["menu_top"].data.x, _childUI["menu_top"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_top"].data.y = py - 100 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.01)
		--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.16, ccp(px, py - 100 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["menu_top"]:setXY(px, py - 100 * _ScaleH)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_top"].handle._n:runAction(sequence)
		
		--底部栏
		--往上做运动
		local px, py = _childUI["menu_bottom"].data.x, _childUI["menu_bottom"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_bottom"].data.y = py + 125 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.01)
		--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py - 10)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.16, ccp(px, py + 125 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_bottom"].data.y = py + 125 * _ScaleH
			_childUI["menu_bottom"]:setXY(px, py + 125 * _ScaleH)
		end)
		local act5 = CCDelayTime:create(0.16)
		local act6 = CCCallFunc:create(function()
			--标记不在打开面板中
			__isOpenSubFrm = false
			
			if callback then
				callback()
			end
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		local sequence = CCSequence:create(a)
		_childUI["menu_bottom"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_bottom"].handle._n:runAction(sequence)
		]]
		
		--输入框的初始位置
		local px, py = _childUI["name_asset_l"].data.x, _childUI["name_asset_l"].data.y --l
		_childUI["name_asset_l"]:setXY(px - hVar.SCREEN.w / 2, py)
		local px, py = _childUI["name_asset_r"].data.x, _childUI["name_asset_r"].data.y --r
		_childUI["name_asset_r"]:setXY(px + hVar.SCREEN.w / 2, py)
		local px, py = _childUI["name_TitleLbael"].data.x, _childUI["name_TitleLbael"].data.y --标题
		_childUI["name_TitleLbael"]:setXY(px, py + hVar.SCREEN.h)
		local px, py = _childUI["name_NoteInputLbael"].data.x, _childUI["name_NoteInputLbael"].data.y --提示输入文字
		_childUI["name_NoteInputLbael"]:setXY(px, py - hVar.SCREEN.h)
		local px, py = _enterNameEditBox:getPosition() --输入框
		_enterNameEditBox:setPosition(ccp(px, py - hVar.SCREEN.h))
		local px, py = _childUI["name_okButton"].data.x, _childUI["name_okButton"].data.y --确定按钮
		_childUI["name_okButton"]:setXY(px, py - hVar.SCREEN.h)
		if (_childUI["name_closeBtn"]) then --关闭按钮
			local px, py = _childUI["name_closeBtn"].data.x, _childUI["name_closeBtn"].data.y --关闭按钮
			_childUI["name_closeBtn"]:setXY(px - 100 * _ScaleW, py)
		end
		
		--[[
		--l向右运动
		local px, py = _childUI["name_asset_l"].data.x, _childUI["name_asset_l"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_asset_l"].data.x = px + hVar.SCREEN.w / 2
		end)
		local act1 = CCDelayTime:create(0.08)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px + hVar.SCREEN.w / 2 + 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.08, ccp(px + hVar.SCREEN.w / 2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_asset_l"]:setXY(px + hVar.SCREEN.w / 2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_asset_l"].handle._n:runAction(sequence)
		
		--r向左运动
		local px, py = _childUI["name_asset_r"].data.x, _childUI["name_asset_r"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_asset_r"].data.x = px - hVar.SCREEN.w / 2
		end)
		local act1 = CCDelayTime:create(0.08)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w / 2 - 30, py)))
		local act3 = CCEaseSineIn:create(CCMoveTo:create(0.08, ccp(px - hVar.SCREEN.w / 2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_asset_r"]:setXY(px - hVar.SCREEN.w / 2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_asset_r"].handle._n:runAction(sequence)
		]]
		
		--标题往下
		local px, py = _childUI["name_TitleLbael"].data.x, _childUI["name_TitleLbael"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_TitleLbael"].data.y = py - hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.16)
		local act2 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, -hVar.SCREEN.h - 20)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, 20)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_TitleLbael"]:setXY(px, py - hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_TitleLbael"].handle._n:runAction(sequence)
		
		--正文往上
		local px, py = _childUI["name_NoteInputLbael"].data.x, _childUI["name_NoteInputLbael"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_NoteInputLbael"].data.y = py + hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.24)
		local act2 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, hVar.SCREEN.h + 20)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, -20)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_NoteInputLbael"]:setXY(px, py + hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_NoteInputLbael"].handle._n:runAction(sequence)
		
		--输入框往上
		local px, py = _enterNameEditBox:getPosition()
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			--_childUI["name_NoteInputLbael"].data.y = py + hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.24)
		local act2 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, hVar.SCREEN.h + 20)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, -20)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_enterNameEditBox:setPosition(ccp(px, py + hVar.SCREEN.h))
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_enterNameEditBox:runAction(sequence)
		
		--确定按钮往上
		local px, py = _childUI["name_okButton"].data.x, _childUI["name_okButton"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_okButton"].data.y = py + hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.24)
		local act2 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, hVar.SCREEN.h + 20)))
		local act3 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, -20)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_okButton"]:setXY(px, py + hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_okButton"].handle._n:runAction(sequence)
		
		if (_childUI["name_closeBtn"]) then
			--关闭按钮往右
			local px, py = _childUI["name_closeBtn"].data.x, _childUI["name_closeBtn"].data.y
			local act0 = CCCallFunc:create(function()
				--立即设置逻辑坐标
				_childUI["name_closeBtn"].data.x = px + 100 * _ScaleW
			end)
			local act1 = CCDelayTime:create(0.24)
			--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
			local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(100 * _ScaleW, 0)))
			local act4 = CCCallFunc:create(function()
				--_childUI["menu_top"].data.y = py - 100 * _ScaleH
				_childUI["name_closeBtn"]:setXY(px + 100 * _ScaleW, py)
			end)
			local a = CCArray:create()
			a:addObject(act0)
			a:addObject(act1)
			--a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_childUI["name_closeBtn"].handle._n:runAction(sequence)
		end
	end
	
	--函数：隐藏起名字界面动画
	HideSetNameUIAction = function(callback)
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--标记打开了面板
		__isOpenSubFrm = true
		
		--设置初始坐标
		--顶部栏
		_childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, -100 * _ScaleH / 2)
		--底部栏
		_childUI["menu_bottom"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h + 125 * _ScaleH / 2)
		
		--顶部栏
		--往上做运动
		local px, py = _childUI["menu_top"].data.x, _childUI["menu_top"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_top"].data.y = py + 100 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.01)
		--local act2 = CCEaseSineIn:create(CCMoveTo:create(0.05, ccp(px, py - 10)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py + 100 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py + 100 * _ScaleH
			_childUI["menu_top"]:setXY(px, py + 100 * _ScaleH)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_top"].handle._n:runAction(sequence)
		
		--底部栏
		--往下做运动
		local px, py = _childUI["menu_bottom"].data.x, _childUI["menu_bottom"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["menu_bottom"].data.y = py - 125 * _ScaleH
		end)
		local act1 = CCDelayTime:create(0.01)
		--local act2 = CCEaseSineIn:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, py - 125 * _ScaleH)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_bottom"].data.y = py - 125 * _ScaleH
			_childUI["menu_bottom"]:setXY(px, py - 125 * _ScaleH)
		end)
		local act5 = CCDelayTime:create(0.31)
		local act6 = CCCallFunc:create(function()
			--删除起名字的控件
			for i = 1, #_removeFrmList, 1 do
				hApi.safeRemoveT(_childUI, _removeFrmList[i])
			end
			_removeFrmList = {}
			
			--删除输入框
			if _enterNameEditBox then
				_parent:removeChild(_enterNameEditBox, true)
				_enterNameEditBox = nil
			end
			
			--标记不在打开面板中
			__isOpenSubFrm = false
			
			if callback then
				callback()
			end
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		--a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		local sequence = CCSequence:create(a)
		_childUI["menu_bottom"].handle._n:stopAllActions() --先停掉之前可能的动画
		_childUI["menu_bottom"].handle._n:runAction(sequence)
		
		--l向左运动
		local px, py = _childUI["name_asset_l"].data.x, _childUI["name_asset_l"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_asset_l"].data.x = px - hVar.SCREEN.w / 2
		end)
		local act1 = CCDelayTime:create(0.24)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.08, ccp(px + 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px - hVar.SCREEN.w / 2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_asset_l"]:setXY(px - hVar.SCREEN.w / 2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_asset_l"].handle._n:runAction(sequence)
		
		--r向右运动
		local px, py = _childUI["name_asset_r"].data.x, _childUI["name_asset_r"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_asset_r"].data.x = px + hVar.SCREEN.w / 2
		end)
		local act1 = CCDelayTime:create(0.24)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.08, ccp(px - 30, py)))
		local act3 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px + hVar.SCREEN.w / 2, py)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_asset_r"]:setXY(px + hVar.SCREEN.w / 2, py)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_asset_r"].handle._n:runAction(sequence)
		
		--标题往上
		local px, py = _childUI["name_TitleLbael"].data.x, _childUI["name_TitleLbael"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_TitleLbael"].data.y = py + hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.08)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, -20)))
		local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, 20 + hVar.SCREEN.h)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_TitleLbael"]:setXY(px, py + hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_TitleLbael"].handle._n:runAction(sequence)
		
		--正文往下
		local px, py = _childUI["name_NoteInputLbael"].data.x, _childUI["name_NoteInputLbael"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_NoteInputLbael"].data.y = py - hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.16)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, 20)))
		local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, -20 - hVar.SCREEN.h)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_NoteInputLbael"]:setXY(px, py - hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_NoteInputLbael"].handle._n:runAction(sequence)
		
		--输入框往下
		local px, py = _enterNameEditBox:getPosition()
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			--_childUI["name_NoteInputLbael"].data.y = py + hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.16)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, 20)))
		local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, -20 - hVar.SCREEN.h)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_enterNameEditBox:setPosition(ccp(px, py - hVar.SCREEN.h))
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_enterNameEditBox:runAction(sequence)
		
		--确定按钮往下
		local px, py = _childUI["name_okButton"].data.x, _childUI["name_okButton"].data.y
		local act0 = CCCallFunc:create(function()
			--立即设置逻辑坐标
			_childUI["name_okButton"].data.y = py - hVar.SCREEN.h
		end)
		local act1 = CCDelayTime:create(0.16)
		local act2 = CCEaseSineIn:create(CCMoveBy:create(0.04, ccp(0, 20)))
		local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(0, -20 - hVar.SCREEN.h)))
		local act4 = CCCallFunc:create(function()
			--_childUI["menu_top"].data.y = py - 100 * _ScaleH
			_childUI["name_okButton"]:setXY(px, py - hVar.SCREEN.h)
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["name_okButton"].handle._n:runAction(sequence)
		
		if (_childUI["name_closeBtn"]) then
			--关闭按钮往左
			local px, py = _childUI["name_closeBtn"].data.x, _childUI["name_closeBtn"].data.y
			local act0 = CCCallFunc:create(function()
				--立即设置逻辑坐标
				_childUI["name_closeBtn"].data.x = px - 100 * _ScaleW
			end)
			local act1 = CCDelayTime:create(0.16)
			--local act2 = CCEaseSineOut:create(CCMoveTo:create(0.05, ccp(px, py + 10)))
			local act3 = CCEaseSineOut:create(CCMoveBy:create(0.16, ccp(-100 * _ScaleW, 0)))
			local act4 = CCCallFunc:create(function()
				--_childUI["menu_top"].data.y = py - 100 * _ScaleH
				_childUI["name_closeBtn"]:setXY(px - 100 * _ScaleW, py)
			end)
			local a = CCArray:create()
			a:addObject(act0)
			a:addObject(act1)
			--a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_childUI["name_closeBtn"].handle._n:runAction(sequence)
		end
	end
	
	--刷新新主界面的按钮
	_refreshMainFrm = function()
		--剧情"锁"
		if (g_curPlayerName == nil) then--没有账号
			_childUI["menu_plot"].childUI["lock"].handle.s:setVisible(true)
		else
			_childUI["menu_plot"].childUI["lock"].handle.s:setVisible(false)
		end
		
		--刷新中央按钮的解锁状态
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			--无尽挑战"锁"
			_childUI["menu_endless"].childUI["lock"].handle.s:setVisible(true)
			
			--夺塔奇兵"锁"
			_childUI["menu_pvp"].childUI["lock"].handle.s:setVisible(true)
			
			--铜雀台"锁"
			_childUI["menu_tongquetai"].childUI["lock"].handle.s:setVisible(true)
		else
			--无尽挑战"锁"
			_childUI["menu_endless"].childUI["lock"].handle.s:setVisible(false)
			
			--夺塔奇兵"锁"
			_childUI["menu_pvp"].childUI["lock"].handle.s:setVisible(false)
			
			--铜雀台"锁"
			_childUI["menu_tongquetai"].childUI["lock"].handle.s:setVisible(false)
		end
		
		
		--刷新底部菜单条
		local unlockMenuIdx = 1
		for i = 1, bottomMenuNum do
			local btnMenu = bottomMenuSet[i]
			local btnMenuBg = bottomMenuBgSet[i]
			local btnMenuBgEff = bottomMenuBgEffSet[i]
			local unlockInfo = bottomMenuUnlock[i] or {}
			local unlockType = unlockInfo[1] or -1
			--按钮解锁类型
			if (unlockType == 0) then --直接解锁
				if btnMenu then
					btnMenu:setstate(1)
					local py = -hVar.SCREEN.h + 60 * _ScaleH
					btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
				end
				
				if btnMenuBg then
					btnMenuBg.handle._n:setVisible(true)
					local py = -hVar.SCREEN.h + 60 * _ScaleH
					btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
				end
				
				if btnMenuBgEff then
					btnMenuBgEff.handle._n:setVisible(true)
					local py = -hVar.SCREEN.h + 60 * _ScaleH
					btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
				end
				
				unlockMenuIdx = unlockMenuIdx + 1
			elseif unlockType == 1 then  --地图通关解锁
				local unlockMap = unlockInfo[2] or ""
				local haveLevel = (LuaGetPlayerMapAchi(unlockMap,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0) --地图通关信息
				if (haveLevel > 0) then --地图通关后才能解锁按钮
					--[[
					if btnMenu then
						btnMenu:setstate(1)
						local py = -hVar.SCREEN.h + 60 * _ScaleH
						btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
					end
					
					if btnMenuBg then
						btnMenuBg.handle._n:setVisible(true)
						local py = -hVar.SCREEN.h + 60 * _ScaleH
						btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
					end
					
					if btnMenuBgEff then
						btnMenuBgEff.handle._n:setVisible(true)
						local py = -hVar.SCREEN.h + 60 * _ScaleH
						btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
					end
					
					unlockMenuIdx = unlockMenuIdx + 1
					]]
					
					--此处是测试期间的代码，注释掉上面的代码
					--竞技场测试期间，竞技场关闭的服务器时间戳
					--g_pvp_room_closetime
					if (i == 6) then --竞技场
						if (g_pvp_button_open == 1) then
							if btnMenu then
								btnMenu:setstate(1)
								local py = -hVar.SCREEN.h + 60 * _ScaleH
								btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
							end
							
							if btnMenuBg then
								btnMenuBg.handle._n:setVisible(true)
								local py = -hVar.SCREEN.h + 60 * _ScaleH
								btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
							end
							
							if btnMenuBgEff then
								btnMenuBgEff.handle._n:setVisible(true)
								local py = -hVar.SCREEN.h + 60 * _ScaleH
								btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
							end
							
							unlockMenuIdx = unlockMenuIdx + 1
						else
							if btnMenu then
								btnMenu:setstate(-1)
							end
							if btnMenuBg then
								btnMenuBg.handle._n:setVisible(false)
							end
							if btnMenuBgEff then
								btnMenuBgEff.handle._n:setVisible(false)
							end
						end
					else
						if btnMenu then
							btnMenu:setstate(1)
							local py = -hVar.SCREEN.h + 60 * _ScaleH
							btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
						end
						
						if btnMenuBg then
							btnMenuBg.handle._n:setVisible(true)
							local py = -hVar.SCREEN.h + 60 * _ScaleH
							btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
						end
						
						if btnMenuBgEff then
							btnMenuBgEff.handle._n:setVisible(true)
							local py = -hVar.SCREEN.h + 60 * _ScaleH
							btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py) --统一调整底部条y坐标
						end
						
						unlockMenuIdx = unlockMenuIdx + 1
					end
					--g_pvp_room_closetime end!
				else --未解锁
					if btnMenu then
						btnMenu:setstate(-1)
					end
					if btnMenuBg then
						btnMenuBg.handle._n:setVisible(false)
					end
					if btnMenuBgEff then
						btnMenuBgEff.handle._n:setVisible(false)
					end
				end
			else
				if btnMenu then
					btnMenu:setstate(-1)
				end
				if btnMenuBg then
					btnMenuBg.handle._n:setVisible(false)
				end
				if btnMenuBgEff then
					btnMenuBgEff.handle._n:setVisible(false)
				end
			end
		end
		
		-------------------------------------------------------------------------------
		
		--刷新顶部菜单条
		unlockMenuIdx = 1
		for i = 1, topMenuNum do
			local btnMenu = topMenuSet[i]
			local btnMenuBg = topMenuBgSet[i]
			local btnMenuBgEff = topMenuBgEffSet[i]
			local unlockInfo = topMenuUnlock[i] or {}
			local unlockType = unlockInfo[1] or -1
			--按钮解锁类型
			if unlockType == 0 then --直接解锁
				if btnMenu then
					btnMenu:setstate(1)
					local py = -60 * _ScaleH
					btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
				end
				
				if btnMenuBg then
					btnMenuBg.handle._n:setVisible(true)
					local py = -60 * _ScaleH
					btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
				end
				
				if btnMenuBgEff then
					btnMenuBgEff.handle._n:setVisible(true)
					local py = -60 * _ScaleH
					btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
				end
				
				unlockMenuIdx = unlockMenuIdx + 1
			elseif unlockType == 1 then  --地图通关解锁
				local unlockMap = unlockInfo[2] or ""
				local haveLevel = (LuaGetPlayerMapAchi(unlockMap,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0) --地图通关信息
				if (haveLevel > 0) then --地图通关后才能解锁按钮
					--print("hVar.SHOW_PURCHASE_HOST", hVar.SHOW_PURCHASE_HOST, "hVar.SHOW_PURCHASE_CLIENT", hVar.SHOW_PURCHASE_CLIENT)
					
					--[[
					if (hVar.SHOW_PURCHASE_HOST == 1) and (hVar.SHOW_PURCHASE_CLIENT == 1) then
					]]
						if btnMenu then
							btnMenu:setstate(1)
							local py = -60 * _ScaleH
							btnMenu:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
						end
						
						if btnMenuBg then
							btnMenuBg.handle._n:setVisible(true)
							local py = -60 * _ScaleH
							btnMenuBg:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
						end
						
						if btnMenuBgEff then
							btnMenuBgEff.handle._n:setVisible(true)
							local py = -60 * _ScaleH
							btnMenuBgEff:setXY(hVar.SCREEN.w - 60 - (unlockMenuIdx - 1) * 110, py)
						end
						
						unlockMenuIdx = unlockMenuIdx + 1
					--[[
					else --服务器或客户端配置关闭
						if btnMenu then
							btnMenu:setstate(-1)
						end
						if btnMenuBg then
							btnMenuBg.handle._n:setVisible(false)
						end
						if btnMenuBgEff then
							btnMenuBgEff.handle._n:setVisible(false)
						end
					end
					]]
				else --未通关指定地图
					if btnMenu then
						btnMenu:setstate(-1)
					end
					if btnMenuBg then
						btnMenuBg.handle._n:setVisible(false)
					end
					if btnMenuBgEff then
						btnMenuBgEff.handle._n:setVisible(false)
					end
				end
			else
				if btnMenu then
					btnMenu:setstate(-1)
				end
				if btnMenuBg then
					btnMenuBg.handle._n:setVisible(false)
				end
				if btnMenuBgEff then
					btnMenuBgEff.handle._n:setVisible(false)
				end
			end
		end
		
		--geyachao: 刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		__refreshTacticSkillTaskNotes()
	end
	
	--局部函数
	--geyachao: 刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	__refreshTacticSkillTaskNotes = function()
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		
		--没创建新主界面，直接返回
		if (not _frm) then
			return
		end
		
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		----------------------------------------------------------------------------
		--检测是否有可以升级的英雄技能、塔、战术技能卡
		local enableSkillUpdate = hApi.IsEnableUpgrateHeroSkill()
		local enableTacticUpdate = hApi.IsEnableUpgrateTacticCard()
		_childUI[bottomMenuName[1]].childUI["lvup"].handle._n:setVisible(enableSkillUpdate or enableTacticUpdate)
		
		----------------------------------------------------------------------------
		--检测是否存在可以升级的战术技能卡和塔
		--local enableTacticUpdate = hApi.IsEnableUpgrateTacticCard()
		--_childUI[bottomMenuName[2]].childUI["lvup"].handle._n:setVisible(enableTacticUpdate)
		
		----------------------------------------------------------------------------
		--检测是否存在可以领取的成就、任务、活动
		local enableAchievementFinish = hApi.CheckMadel()
		local enableTaskFinish = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
		local enableActivityNew = hApi.CheckNewActivity()
		--print("enableTaskFinish", enableTaskFinish)
		_childUI[bottomMenuName[3]].childUI["lvup"].handle._n:setVisible(enableTaskFinish or enableAchievementFinish or enableActivityNew)
		
		----------------------------------------------------------------------------
		--刷新pvp的测试期间的倒计时
		--竞技场测试期间
		--g_pvp_room_closetime
		--更新pvp是否有锦囊开启
		local enableArenaChestOpen = (g_myPvP_BaseInfo.arenachest > 0) --是否有擂台锦囊
		local enablePvpChestOpen = hApi.IsEnablePvpChestOpen() --是否有竞技场锦囊
		local enableChestOpen = (enableArenaChestOpen or enablePvpChestOpen)
		local enableHeroStarUp = hApi.IsEnableUpgrateHeroStar() --是否有英雄升星
		local enableArmyCardLvUp = hApi.IsEnableUpgrateArmyCard() --是否有兵种卡升级
		local enablePVPCardUp = (enableHeroStarUp or enableArmyCardLvUp)
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableChestOpen = false
			enablePVPCardUp = false
		end
		--_childUI[bottomMenuName[6]].childUI["lvup"].handle._n:setVisible(enableArenaChestOpen or enablePvpChestOpen)
		if enablePVPCardUp then
			_childUI["menu_pvp"].childUI["tanhao"].handle._n:setVisible(false)
			_childUI["menu_pvp"].childUI["lvup"].handle._n:setVisible(true)
		elseif enableChestOpen then
			_childUI["menu_pvp"].childUI["tanhao"].handle._n:setVisible(true)
			_childUI["menu_pvp"].childUI["lvup"].handle._n:setVisible(false)
		else
			_childUI["menu_pvp"].childUI["tanhao"].handle._n:setVisible(false)
			_childUI["menu_pvp"].childUI["lvup"].handle._n:setVisible(false)
		end
		----------------------------------------------------------------------------
		--检测是否到第二天刷新了商城出售的道具
		local enableQueryShop = true
		--读取存档里的今日商城商品列表数据
		local shopId = 1
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--客户端的时间
			local localTime = os.time()
				
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			--客户端上次获取的时间
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime > 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		--是否通关"剿灭黄巾"
		local isFinishMap9 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
		if (isFinishMap9 == 0) then
			enableQueryShop = false
		end
		
		--检测VIP今日奖励是否领取
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		_childUI[topMenuName[1]].childUI["lvup"].handle._n:setVisible(enableQueryShop or enableVIPDaliyReward)
		
		----------------------------------------------------------------------------
		--检测评价奖励是否完成
		--评价开关打开，没评价过，已通关"救援青州"
		local enableRateOpen = ((g_MyVip_Param.enable == 1) and (LuaGetPlayerGiftstate(3) == 0) and (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) > 0))
		--print(g_MyVip_Param.enable, LuaGetPlayerGiftstate(3), LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL))
		_childUI[topMenuName[2]].childUI["lvup"].handle._n:setVisible(enableRateOpen)
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function(bIsSetName)
		--print("动态加载资源")
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--加载资源
		--动态加载背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/morizhanche.jpg")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/morizhanche.jpg")
			print("加载黑色背景大图！")
		end
		--print(tostring(texture))
		if (_childUI["panel_bg"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			--ipad
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			pSprite:setPosition(128, 0)
			--[[
			local scale = math.max(hVar.SCREEN.w / tSize.width, hVar.SCREEN.h / tSize.height)
			if (g_phone_mode ~= 0) then --手机模式
				scale = math.max(hVar.SCREEN.w / tSize.width, hVar.SCREEN.h / tSize.height) + 0.00221
				pSprite:setPosition(0, 6)
			end
			pSprite:setScaleX(scale)
			pSprite:setScaleY(scale)
			]]
			--不同分辨率下的缩放和坐标
			local tParam = hVar.DEVICE_PARAM[g_phone_mode]
			local ox,oy = 0,0
			local fScale = 1
			if tParam.loading_view then
				ox,oy,fScale = unpack(tParam.loading_view)
			end
			if (g_phone_mode == 1) then --iPhone4
				pSprite:setScaleX(0.75)
				pSprite:setScaleY(0.89)
				pSprite:setPosition(0, 1.1 - 1.1)
			elseif (g_phone_mode == 2) then --iPhone5
				pSprite:setScaleX(0.89)
				pSprite:setScaleY(0.89)
				pSprite:setPosition(-0.2, 6.1 - 6.1)
			elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
				pSprite:setScaleX(1.0)
				pSprite:setScaleY(1.0)
				pSprite:setPosition(0, 6.1 - 6.1)
			elseif (g_phone_mode == 4) then --iPhoneX
				pSprite:setScaleX(1.0)
				pSprite:setScaleY(1.0)
				pSprite:setPosition(0, -24+24)
			end
			_childUI["panel_bg"].data.pSprite = pSprite
			_childUI["panel_bg"].handle._n:addChild(pSprite)
		end
		
		--加载资源
		--动态加载背景图logo1
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/cg.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/cg.png")
			print("加载黑色背景大图logo1！")
		end
		--[[
		local textureText = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/cgms.png")
		if (not textureText) then
			textureText = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/cgms.png")
			print("加载黑色背景大图logo1文字！")
		end
		]]
		--print(tostring(texture))
		if (_childUI["panel_bg_logo1"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			local scale = math.min(_ScaleW, _ScaleH)
			pSprite:setScaleX(scale)
			pSprite:setScaleY(scale)
			_childUI["panel_bg_logo1"].data.pSprite = pSprite
			_childUI["panel_bg_logo1"].handle._n:addChild(pSprite)

			local model = "/misc/addition/cg_label_sc.png"
			if g_Cur_Language >= 3 then
				model = "/misc/addition/cg_label_en.png"
			end

			_childUI["panel_bg_logo1"].childUI["img_label"] = hUI.image:new({
				parent = _childUI["panel_bg_logo1"].handle._n,
				model = model,
				x = 0,
				y = 0,
				--scale = 0.9,
			})
			
			_childUI["panel_bg_logo1"]:setstate(-1)
			--_childUI["panel_bg_logo1"].childUI["img_label"] = hUI.label:new({
				--parent = _childUI["panel_bg_logo1"].handle._n,
				--x = 0,
				--y = 4,
				--align = "MC",
				--size = 32,
				--width = 300,
				--height = 36,
				--font = hVar.FONTC,
				--text = hVar.tab_string["start"],
			--})
			local lab = _childUI["panel_bg_logo1"].childUI["img_label"]
			local aArray = CCArray:create()
			aArray:addObject(CCScaleTo:create(600/1000,0.96))
			aArray:addObject(CCScaleTo:create(600/1000,1.0))
			local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
			lab.handle._n:runAction(CCRepeatForever:create(seq))

			--呼吸灯效果（白色）
			local pBlink = xlAddGroundEffect(0,-1,0,0,600/1000,0.6,255,255,255,1)
			_childUI["panel_bg_logo1"].handle._nBlink = pBlink
			pBlink:getParent():removeChild(pBlink,false)
			pBlink:setScaleX(8.5)
			pBlink:setScaleY(2.6)
			_childUI["panel_bg_logo1"].handle._n:addChild(pBlink)

			local text = ""
			local iChannelId = xlGetChannelId()
			local ip = "nil"
			local port = "nil"
			if Game_Server and Game_Server.Data then
				ip = Game_Server.Data.ip
				port = Game_Server.Data.port
			end
			--text = "ip:"..ip.." port:"..port.." ChannelId:"..iChannelId
			
			_childUI["lab_text"] = hUI.label:new({
				parent = _parent,
				x = logo1_x + 250,
				y = logo1_y - 60,
				--text = "确定", --language
				align = "MC",
				size = 32,
				text = text, --language
				font = hVar.FONTC,
				border = 1,
			})
		end
		--[[
		if (_childUI["panel_bg_logo1"].data.pSpriteText == nil) then
			local tSize = texture:getContentSize()
			local tSizeText = textureText:getContentSize()
			
			local pSpriteText = CCSprite:createWithTexture(textureText, CCRectMake(0, 0, tSizeText.width, tSizeText.height))
			pSpriteText:setAnchorPoint(ccp(0, 1))
			local scale = math.min(_ScaleW, _ScaleH)
			pSpriteText:setPosition(tSizeText.width / 2, -tSize.height * scale)
			pSpriteText:setScaleX(scale)
			pSpriteText:setScaleY(scale)
			_childUI["panel_bg_logo1"].data.pSpriteText = pSpriteText
			_childUI["panel_bg_logo1"].handle._n:addChild(pSpriteText)
		end
		]]
		
		--加载资源
		--动态加载背景图logo2
		--local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/wj.png")
		--if (not texture) then
			--texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/wj.png")
			--print("加载黑色背景大图logo2！")
		--end
		--local textureText = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/wjms.png")
		--if (not textureText) then
			--textureText = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/wjms.png")
			--print("加载黑色背景大图logo2文字！")
		--end
		--[[
		--print(tostring(texture))
		if (_childUI["panel_bg_logo2"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0, 1))
			local scale = math.min(_ScaleW, _ScaleH)
			if (g_phone_mode ~= 0) then --手机模式
				--
			end
			pSprite:setScaleX(scale)
			pSprite:setScaleY(scale)
			_childUI["panel_bg_logo2"].data.pSprite = pSprite
			_childUI["panel_bg_logo2"].handle._n:addChild(pSprite)
		end
		if (_childUI["panel_bg_logo2"].data.pSpriteText == nil) then
			local tSize = texture:getContentSize()
			local tSizeText = textureText:getContentSize()
			local pSpriteText = CCSprite:createWithTexture(textureText, CCRectMake(0, 0, tSizeText.width, tSizeText.height))
			pSpriteText:setAnchorPoint(ccp(0, 0))
			local scale = math.min(_ScaleW, _ScaleH)
			pSpriteText:setPosition(tSizeText.width / 2, 0)
			pSpriteText:setScaleX(scale)
			pSpriteText:setScaleY(scale)
			_childUI["panel_bg_logo2"].data.pSpriteText = pSpriteText
			_childUI["panel_bg_logo2"].handle._n:addChild(pSpriteText)
		end
		]]
		
		--动态加载战役大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/mask.png")
			print("加载战役大图！")
		end
		--print(tostring(texture))
		if (_childUI["menu_plot"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			--pSprite:setContentSize(tSize.width * minScale, tSize.height * minScale)
			pSprite:setScale(minScale)
			_childUI["menu_plot"].data.pSprite = pSprite
			_childUI["menu_plot"].handle._n:addChild(pSprite)
		end
		
		--动态加载夺塔奇兵大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/mask.png")
			print("加载夺塔奇兵大图！")
		end
		--print(tostring(texture))
		if (_childUI["menu_pvp"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			--pSprite:setContentSize(tSize.width * minScale, tSize.height * minScale)
			pSprite:setScale(minScale)
			_childUI["menu_pvp"].data.pSprite = pSprite
			_childUI["menu_pvp"].handle._n:addChild(pSprite)
		end
		
		--动态加载无尽地图大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/mask.png")
			print("加载无尽大图！")
		end
		--print(tostring(texture))
		if (_childUI["menu_endless"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			--pSprite:setContentSize(tSize.width * minScale, tSize.height * minScale)
			pSprite:setScale(minScale)
			_childUI["menu_endless"].data.pSprite = pSprite
			_childUI["menu_endless"].handle._n:addChild(pSprite)
		end
		
		--动态加载铜雀台大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/mask.png")
			print("加载铜雀台大图！")
		end
		--print(tostring(texture))
		if (_childUI["menu_tongquetai"].data.pSprite == nil) then
			local tSize = texture:getContentSize()
			local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
			pSprite:setPosition(0, 0)
			pSprite:setAnchorPoint(ccp(0.5, 0.5))
			--pSprite:setContentSize(tSize.width * minScale, tSize.height * minScale)
			pSprite:setScale(minScale)
			_childUI["menu_tongquetai"].data.pSprite = pSprite
			_childUI["menu_tongquetai"].handle._n:addChild(pSprite)
		end
	end

	--函数: 检测恢复存档
	_CheckRestoreSaveData = function()
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			--读取cfg  如果没有 且keychain有UID说明游戏删了重装  此时走恢复存档流程

			--有账号  不处理 走自动登录
			if hApi.FileExists(g_localfilepath.."new_guest.cfg","full") then
				
			else
				--暂时外网不弹
				--if g_lua_src == 1 then
					local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
					if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
						--keychain有值 且不等于0 弹框
						if xlGetIntFromKeyChain("xl_guest_uid") ~= 0 and LuaGetPlayerStartNewGame(g_curPlayerName) == 0 then
							hApi.CreateRestoreSaveDataFrm()
							return
						end
					end
				--end
			end
		end
		if g_lua_src == 1 then
			if hApi.FileExists(g_localfilepath.."new_guest.cfg","full") then
			
			else
				--内网检测
				if xlPlayer_GetUID() ~= 0 and LuaGetPlayerStartNewGame(g_curPlayerName) == 0 then
					hApi.CreateRestoreSaveDataFrm()
					return
				end
			end
		end
		_childUI["panel_bg_logo1"]:setstate(1)
		hGlobal.event:event("LocalEvent_autologin")
	end
	
	--函数: 动态删除资源
	__DynamicRemoveRes = function()
		local _frm = hGlobal.UI.Phone_MainPanelFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		_childUI["panel_bg"].data.pSprite = nil
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/morizhanche.jpg")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空黑色背景大图！")
		end
		
		--删除资源
		--删除背景图logo1
		_childUI["panel_bg_logo1"].handle._n:removeChild(_childUI["panel_bg_logo1"].data.pSprite, true)
		_childUI["panel_bg_logo1"].data.pSprite = nil
		--[[
		_childUI["panel_bg_logo1"].handle._n:removeChild(_childUI["panel_bg_logo1"].data.pSpriteText, true)
		_childUI["panel_bg_logo1"].data.pSpriteText = nil
		]]
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/cg.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空黑色背景大图logo1！")
		end
		--[[
		local textureText = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/cgms.png")
		if textureText then
			CCTextureCache:sharedTextureCache():removeTexture(textureText)
			print("清空黑色背景大图logo1文字！")
		end
		]]
		
		--[[
		--删除资源
		--删除背景图logo2
		_childUI["panel_bg_logo2"].handle._n:removeChild(_childUI["panel_bg_logo2"].data.pSprite, true)
		_childUI["panel_bg_logo2"].data.pSprite = nil
		_childUI["panel_bg_logo2"].handle._n:removeChild(_childUI["panel_bg_logo2"].data.pSpriteText, true)
		_childUI["panel_bg_logo2"].data.pSpriteText = nil
		--local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/wj.png")
		--if texture then
			--CCTextureCache:sharedTextureCache():removeTexture(texture)
			--print("清空黑色背景大图logo2！")
		--end
		--local textureText = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/wjms.png")
		--if textureText then
			--CCTextureCache:sharedTextureCache():removeTexture(textureText)
			--print("清空黑色背景大图logo2文字！")
		--end
		]]
		
		--删除战役大图
		_childUI["menu_plot"].handle._n:removeChild(_childUI["menu_plot"].data.pSprite, true)
		_childUI["menu_plot"].data.pSprite = nil
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空战役大图！")
		end
		
		--删除夺塔奇兵大图
		_childUI["menu_pvp"].handle._n:removeChild(_childUI["menu_pvp"].data.pSprite, true)
		_childUI["menu_pvp"].data.pSprite = nil
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/menu_image_pvp.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空夺塔奇兵大图！")
		end
		
		--删除无尽大图
		_childUI["menu_endless"].handle._n:removeChild(_childUI["menu_endless"].data.pSprite, true)
		_childUI["menu_endless"].data.pSprite = nil
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空无尽大图！")
		end
		
		--删除铜雀台大图
		_childUI["menu_tongquetai"].handle._n:removeChild(_childUI["menu_tongquetai"].data.pSprite, true)
		_childUI["menu_tongquetai"].data.pSprite = nil
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/mask.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空铜雀台大图！")
		end
	end
	
	--监听积分改变事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_SetCurGameScore", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听金币改变事件，刷新战术技能卡合成按钮、点将台按钮是否有变化需要提示
	hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听金币改变（手机版）事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听获得战术技能卡（碎片）事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Event_PlayerGetTacticCard", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听英雄技能升级返回事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听道具出售事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Local_Event_ItemSell_Result", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听道具合成事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Local_Event_ItemMerge_Result", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听道具洗炼事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Local_Event_ItemXiLian_Result", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听道具重铸事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("Local_Event_ItemRebuild_Result", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听获得活动事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("localEvent_UpdateActivityInfo", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听获得VIP等级和领取状态事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_GetVipState_New", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听获得VIP领取状态事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听PVP竞技场英雄解锁事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Pvp_Hero_Unlock_Ok", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听PVP竞技场英雄升星事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Pvp_Hero_StarLvup_Ok", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	--监听PVP竞技场兵种卡升级事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_Pvp_Army_Lvup_Ok", "__CheckTacticSkillTaskRefresh__", __refreshTacticSkillTaskNotes)
	
	--监听邮件变化判断，显示/隐藏邮件叹号
	hGlobal.event:listen("LocalEvent_NewWebAction", "__CheckNewWebActionRefresh__", function(data_s, mode)
		--print("监听邮件变化判断", data_s, mode, debug.traceback())
		local uiCtrl = _childUI[bottomMenuName[7]].childUI["lvup"]
		if (mode == nil) then
			if (LuaGetWebViewN() ~= data_s) then
				g_cur_webnum = data_s
				if uiCtrl then
					uiCtrl.handle._n:setVisible(true)
				end
			else
				if uiCtrl then
					uiCtrl.handle._n:setVisible(false)
				end
			end
		elseif (mode == 1) then
			if uiCtrl then
				uiCtrl.handle._n:setVisible(true)
			end
		elseif (mode == 0) then
			if uiCtrl then
				uiCtrl.handle._n:setVisible(false)
			end
		end
	end)
	
	--切换场景，把自己隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__SwitchGame_mainfrm", function()
		--print("切换场景，把自己隐藏", _nIsShowState)
		if (_nIsShowState ~= 0) then --不重复设置
			--标记状态
			_nIsShowState = 0
			
			hGlobal.UI.Phone_MainPanelFrm:show(0)
			
			--动态删除资源
			__DynamicRemoveRes()
			
			--删除英雄例会资源
			--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
			--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
			local tRelease = {}
			local tPng = hUI.SYSAutoReleaseUI.png
			for i = 1, #tPng, 1 do
				local path = tPng[i]
				tRelease[path] = 1
			end
			hResource.model:releasePng(tRelease)
			hUI.SYSAutoReleaseUI.png = {idx = {}}
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--回收lua内存
			collectgarbage()
		end
	end)
	
	--PVP切换场景，把自己隐藏
	hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__SwitchGame_mainfrm", function()
		--print("PVP切换场景，把自己隐藏")
		if (_nIsShowState ~= 0) then --不重复设置
			--标记状态
			_nIsShowState = 0
			
			hGlobal.UI.Phone_MainPanelFrm:show(0)
			
			--动态删除资源
			__DynamicRemoveRes()
			
			--删除英雄例会资源
			--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
			--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
			local tRelease = {}
			local tPng = hUI.SYSAutoReleaseUI.png
			for i = 1, #tPng, 1 do
				local path = tPng[i]
				tRelease[path] = 1
			end
			hResource.model:releasePng(tRelease)
			hUI.SYSAutoReleaseUI.png = {idx = {}}
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--回收lua内存
			collectgarbage()
		end
	end)
	
	--打开新主界面
	hGlobal.event:listen("LocalEvent_new_mainmenu_frm","showmainmenu", function(nIsShow, bIsSetName, index)
		--起名字的流程
		if bIsSetName then
			--[[
			--标记状态
			_nIsShowState = 1
			
			--动态加载资源
			__DynamicAddRes(bIsSetName)
			
			hGlobal.UI.Phone_MainPanelFrm:show(1)
			hGlobal.UI.Phone_MainPanelFrm:active()
			
			--起名字界面
			ShowSetNameUIAction(index)
			]]
			--------------------------------------------
			--设置名字为"游客XXXXXXXX"
			--设置新存档
			local userID = xlPlayer_GetUID()
			local guestPrefix = hVar.tab_string["guest"] --"游客"
			if (g_lua_src == 1) then --内网源代码模式下，用英文名
				guestPrefix = "User"
			end
			
			local rgName = guestPrefix
			if (userID > 0) then
				rgName = guestPrefix .. userID
			end
			
			--切换(创建)存档
			LuaSwitchPlayer({name = rgName,})
			
			LuaSetPlayerList(index, rgName, "normal")
			--Lua_UIShow_PlayerInfoFram(index)
			
			--------------------------------------------
			--标记状态
			_nIsShowState = 0
			
			hGlobal.UI.Phone_MainPanelFrm:show(0)
			
			--动态删除资源
			__DynamicRemoveRes()
			
			--删除英雄例会资源
			--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
			--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
			local tRelease = {}
			local tPng = hUI.SYSAutoReleaseUI.png
			for i = 1, #tPng, 1 do
				local path = tPng[i]
				tRelease[path] = 1
			end
			hResource.model:releasePng(tRelease)
			hUI.SYSAutoReleaseUI.png = {idx = {}}
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--回收lua内存
			collectgarbage()
			
			--------------------------------------------
			--开始引导新手地图
			--显示游戏新手地图开场动画
			hApi.ShowGameBeginAmin()

			LuaAddPlayerScore(-LuaGetPlayerScore(notSaveFlag) + 1500)
			return
		end
		
		--一般显示/隐藏新主界面的流程
		if (nIsShow == 1) then
			if (_nIsShowState ~= 1) then --不重复设置
				--标记状态
				_nIsShowState = 1
				
				--动态加载资源
				__DynamicAddRes(bIsSetName)
				
				hGlobal.UI.Phone_MainPanelFrm:show(1)
				hGlobal.UI.Phone_MainPanelFrm:active()
				
				--连接pvp服务器
				if (Pvp_Server:GetState() ~= 1) then --未连接
					Pvp_Server:Connect()
				elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
					Pvp_Server:UserLogin()
				end
				
				--动画进入
				ShowMainFrameButtonAction()

				--判断是否是审核模式
				if hApi.IsReviewMode() then
					hVar.IS_SHOW_HIT_EFFECT_FLAG = 0
					hVar.MainBase = "world/start_001_ex"
					hVar.CAN_BUY_LIFE_NUM = 9999
					_childUI["panel_bg_logo1"]:setstate(-1)
					hGlobal.event:event("LocalEvent_ShowLoginFrm_Review",1)
				else
					--非审核模式依旧走单机模式 不强制联网
					--检查恢复存档
					_CheckRestoreSaveData()
				end
			end
		else
			if (_nIsShowState ~= 0) then --不重复设置
				--标记状态
				_nIsShowState = 0
				
				hGlobal.UI.Phone_MainPanelFrm:show(0)
				
				--动态删除资源
				__DynamicRemoveRes()
				
				--删除英雄例会资源
				--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
				--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
				local tRelease = {}
				local tPng = hUI.SYSAutoReleaseUI.png
				for i = 1, #tPng, 1 do
					local path = tPng[i]
					tRelease[path] = 1
				end
				hResource.model:releasePng(tRelease)
				hUI.SYSAutoReleaseUI.png = {idx = {}}
				
				--释放png, plist的纹理缓存（这里不清理也可以）
				--hApi.ReleasePngTextureCache()
				
				--回收lua内存
				collectgarbage()
			end
		end

		--连接安卓服务器
		if Game_Server then
			Game_Server.Connect()
		end
	end)
end
--[[
--测试 --test
if hGlobal.UI.Phone_MainPanelFrm then
	hGlobal.UI.Phone_MainPanelFrm:del()
	hGlobal.UI.Phone_MainPanelFrm = nil
end
--hVar.SYS_IS_NEWTD_APP = 1 --新塔防app程序
hGlobal.UI.InitDotaMainMenu()
hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1, false, 2)
--LuaAddPlayerScore(100) --测试加积分
]]


