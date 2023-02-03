hGlobal.UI.InitLoginFrm_Review = function(mode)
	local tInitEventName = {"LocalEvent_ShowLoginFrm_Review","ShowLoginFrm"}
	if mode~="include" then
		return tInitEventName
	end
	local bgW = 1560
	local bgH = 768
	local bgX = 0
	local bgY = bgH
	if g_phone_mode == 0 then		----pad
		bgX = bgX - 230
	elseif g_phone_mode == 3 then		----安卓
		bgX = bgX - 140
		bgY = bgY - 24
	elseif g_phone_mode == 4 then		----X
		bgY = bgY - 24
	elseif g_phone_mode == 5 then		----刘海屏
		bgX = bgX - 60
		bgY = bgY - 24
	end

	local gt = -1000
	g_AccountRecord = nil

	local _frm,_parent,_childUI
	local _AccountText,_PasswordText
	local enterAccountEditBox
	local enterPasswordEditBox

	local nDeltaTime = 2
	local startTime = os.clock()
	local nMaxShow = 3
	local bShowPassword = false
	local tRemoveUI = {}


	local InitAccountRecord = hApi.DoNothing		--初始化账号记录
	local OnClearFunc = hApi.DoNothing			--界面清理函数
	local OnCreateLoginFrm = hApi.DoNothing			--创建登录界面
	local OnCreateChannelUI = hApi.DoNothing		--创建渠道UI
	local OnCreateRegisteredOrLogin = hApi.DoNothing	--创建注册或登录
	local OnCreateHistoricalAccountFrm = hApi.DoNothing	--创建历史账户界面

	local editAccountBoxTextEventHandle = hApi.DoNothing
	local editPasswordBoxTextEventHandle = hApi.DoNothing

	local OnChooseAccount = hApi.DoNothing			--选择账号
	local OnRefreshPassWord = hApi.DoNothing		--刷新密码显示
	local OnClearAccountUI = hApi.DoNothing

	editAccountBoxTextEventHandle = function(strEventName,pSender)
		_AccountText = enterAccountEditBox:getText()
		print("_AccountText",_AccountText)
		g_guest_uid = tonumber(_AccountText)
	end

	editPasswordBoxTextEventHandle = function()
		_PasswordText = enterPasswordEditBox:getText()
		print("_PasswordText",_PasswordText)
		g_guest_pw = _PasswordText
	end

	OnClearFunc = function()
		if hGlobal.UI.LoginFrm_Review then
			hGlobal.UI.LoginFrm_Review:del()
			hGlobal.UI.LoginFrm_Review = nil
		end
		if hGlobal.UI.HistoricalAccountFrm then
			hGlobal.UI.HistoricalAccountFrm:del()
			hGlobal.UI.HistoricalAccountFrm = nil
		end
		_frm = nil
		_parent = nil
		_childUI = nil

		enterAccountEditBox = nil
		enterPasswordEditBox = nil

		bShowPassword = false
	end

	OnClearAccountUI = function()
		hApi.clearTimer("CreateChannelUI")
		local frm = hGlobal.UI.HistoricalAccountFrm
		if frm then
			for i = 1,#tRemoveUI do
				hApi.safeRemoveT(frm.childUI,#tRemoveUI)
			end
		end
		tRemoveUI = {}
	end

	OnRefreshPassWord = function()
		local text = tostring(_PasswordText)
		if bShowPassword then
			print("ssss")
		else
			print("ccccc")
			text = string.gsub(text,"[%d++%a]","*")
		end
		enterPasswordEditBox:setText(text)
	end

	OnChooseAccount = function(tAccount)
		print("OnChooseAccount")
		enterPasswordEditBox:setVisible(true)
		if type(tAccount) == "table" then
			_AccountText = tAccount[1]
			enterAccountEditBox:setText(_AccountText)
			_PasswordText = tAccount[2]
			g_guest_uid = tonumber(_AccountText)
			g_guest_pw = _PasswordText
			OnRefreshPassWord()
		end
	end

	OnCreateRegisteredOrLogin = function()
		hApi.safeRemoveT(_childUI,"node")

		_childUI["node"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			w = 1,
			h = 1,
			x = bgW/2,
			y = -bgY/2 - 16,
		})

		local nodeChild = _childUI["node"].childUI
		local nodeParent = _childUI["node"].handle._n

		local boardW,boardH = 480,320

		local img91 = hApi.CCScale9SpriteCreate("data/image/panel/9sprite_bg_1.png",0,0,boardW,boardH,_childUI["node"],-1)
		img91:setOpacity(200)

		nodeChild["lab_Account"] = hUI.label:new({
			parent = nodeParent,
			size = 22,
			align = "LC",
			font = hVar.FONTC,
			x = -boardW/2 + 60,
			y =  boardH/2 - 70,
			width = 200,
			border = 1,
			text = hVar.tab_string["__TEXT__Account"],
		})

		hApi.CCScale9SpriteCreate("data/image/misc/ltt.png",40,boardH/2 - 70,260,40,_childUI["node"],-1)
		enterAccountEditBox = CCEditBox:create(CCSizeMake(220, 40), CCScale9Sprite:create("data/image/misc/button_null.png"))
		--enterAccountEditBox = CCEditBox:create(CCSizeMake(200, 40), CCScale9Sprite:create("data/image/misc/mask.png"))
		enterAccountEditBox:setPosition(10,boardH/2 - 70)
		enterAccountEditBox:setPlaceholderFontSize(8)
		enterAccountEditBox:setFontSize(8)
		enterAccountEditBox:setFontColor(ccc3(255,255,255))
		enterAccountEditBox:setPlaceHolder("")
		enterAccountEditBox:setPlaceholderFontColor(ccc3(122,122,122))
		enterAccountEditBox:registerScriptEditBoxHandler(editAccountBoxTextEventHandle)
		--enterAccountEditBox:setMaxLength(10)
		enterAccountEditBox:setTouchPriority(0)
		enterAccountEditBox:setReturnType(kKeyboardReturnTypeDone)
		--enterAccountEditBox:setInputMode(kEditBoxInputModeNumeric)
		nodeParent:addChild(enterAccountEditBox)
		
		_childUI["btn_AccountList"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = bgW/2 + boardW/2 - 102,
			y =  -bgY/2 +boardH/2 - 86,
			w = 60,
			h = 40,
			--[[
			label = {
				font = hVar.FONTC,
				text = hVar.tab_string["__TEXT__sanjiao"],
				size = 16,
				border = 1,
			},
			--]]
			code = function()
				--必须禁用 不然点击的时候会再次弹出
				enterPasswordEditBox:setVisible(false)
				--显示二级界面下拉框
				OnCreateHistoricalAccountFrm()
			end,
		})

		nodeChild["lab_Password"] = hUI.label:new({
			parent = nodeParent,
			size = 22,
			align = "LC",
			font = hVar.FONTC,
			x = -boardW/2 + 60,
			y =  boardH/2 - 150,
			width = 200,
			border = 1,
			text = hVar.tab_string["__TEXT__Password"],
		})
		
		hApi.CCScale9SpriteCreate("data/image/misc/ltt.png",40,boardH/2 - 150,260,40,_childUI["node"],-1)
		enterPasswordEditBox = CCEditBox:create(CCSizeMake(220, 40), CCScale9Sprite:create("data/image/misc/button_null.png"))
		enterPasswordEditBox:setPosition(20,boardH/2 - 150)
		enterPasswordEditBox:setPlaceholderFontSize(8)
		enterPasswordEditBox:setFontSize(8)
		enterPasswordEditBox:setFontColor(ccc3(255,255,255))
		enterPasswordEditBox:setPlaceHolder("")
		enterPasswordEditBox:setPlaceholderFontColor(ccc3(122,122,122))
		enterPasswordEditBox:registerScriptEditBoxHandler(editPasswordBoxTextEventHandle)
		--enterPasswordEditBox:setMaxLength(10)
		enterPasswordEditBox:setTouchPriority(0)
		enterPasswordEditBox:setReturnType(kKeyboardReturnTypeDone)
		--enterPasswordEditBox:setInputMode(kEditBoxInputModeNumeric)
		nodeParent:addChild(enterPasswordEditBox)

		--[[
			_childUI["btn_ShowPassword"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				x = bgW/2 + boardW/2 - 92,
				y =  -bgY/2 +boardH/2 - 166,
				w = 40,
				h = 40,
				code = function()
					--显示二级界面下拉框
					bShowPassword = not(bShowPassword)
					OnRefreshPassWord()
				end,
			})
		--]]

		local btnloginX = bgW/2
		if g_guest_uid == "" then
			_childUI["btn_AutoRegister"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/addition/cg.png",
				x = bgW/2 - 100,
				y = -bgY/2  -boardH/2 + 50,
				w = 140,
				h = 52,
				label = {
					font = hVar.FONTC,
					text = hVar.tab_string["__TEXT__AutoRegister"],
					size = 24,
					y = 2,
					border = 1,
				},
				scaleT = 0.95,
				code = function()
					print("btn_AutoRegister")
					--本地没有登陆账号  直接申请游客登陆 获取账号密码
					GluaSendNetCmd[hVar.ONLINECMD.NEW_REGISTER](0," "," "," ")
				end,
			})
			btnloginX = bgW/2 + 100
			_AccountText = ""
			_PasswordText = ""
		else
			_AccountText = g_guest_uid
			_PasswordText = g_guest_pw
		end
		enterAccountEditBox:setText(tostring(_AccountText))
		OnRefreshPassWord()

		_childUI["btn_Login"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			x = btnloginX,
			y = -bgY/2  -boardH/2 + 50,
			w = 140,
			h = 52,
			label = {
				font = hVar.FONTC,
				text = hVar.tab_string["__TEXT__Login"],
				size = 24,
				y = 2,
				border = 1,
			},
			scaleT = 0.95,
			code = function()
				print("btn_Login")
				local ct = hApi.gametime()
				if ct - gt > 1000 then
					gt = ct
					--账号不符合直接不走登陆
					if type(g_guest_uid) ~= "number" or g_guest_uid< 10000000 then
						hGlobal.UI.MsgBox(hVar.tab_string["admin_err"],{
							font = hVar.FONTC,
							ok = function()
								
							end,
						})
					elseif g_guest_pw == "" or string.len(g_guest_pw) < 6 then
						hGlobal.UI.MsgBox(hVar.tab_string["password_err"],{
							font = hVar.FONTC,
							ok = function()
								
							end,
						})
					else
						g_lastPid = hVar.ONLINECMD.NEW_LOGIN
						g_lastPtable = {0,g_guest_uid,g_guest_pw,nil,g_isReconnection}
						GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](0,g_guest_uid,g_guest_pw,nil,g_isReconnection)
					end
				end
			end,
		})

		--[[setInputMode()设置输入类型，可以包括如下的几种
		kEditBoxInputModeAny: 开启任何文本的输入键盘,包括换行
		kEditBoxInputModeEmailAddr: 开启 邮件地址 输入类型键盘
		kEditBoxInputModeNumeric: 开启 数字符号 输入类型键盘
		kEditBoxInputModePhoneNumber: 开启 电话号码 输入类型键盘
		kEditBoxInputModeUrl: 开启 URL 输入类型键盘
		kEditBoxInputModeDecimal: 开启 数字 输入类型键盘，允许小数点
		kEditBoxInputModeSingleLine: 开启任何文本的输入键盘,不包括换行
		--]]
	end

	OnCreateChannelUI = function()
		--审核模式 显示账号密码 登录 注册
		OnCreateRegisteredOrLogin()
	end

	OnCreateLoginFrm = function()
		hGlobal.UI.LoginFrm_Review = hUI.frame:new({
			x = bgX,
			y = bgY,
			w = bgW,
			h = bgH,
			background = 0,
			--background = "UI:Channel_Login",
			--background = "misc/button_null.png",
			dragable = 2,
			show = 0,
		})

		_frm = hGlobal.UI.LoginFrm_Review
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		local curTime = os.clock()
		local deltaTime = curTime - startTime - nDeltaTime

		if deltaTime > 0 then
			OnCreateChannelUI()
		else
			hApi.addTimerOnce("CreateChannelUI",deltaTime * (-1000),function()
				OnCreateChannelUI()
			end)
		end

		_frm:active()
		_frm:show(1)
	end

	OnCreateHistoricalAccountFrm = function()
		local btnH  = 30
		local frmW,frmH = 260,104
		if hGlobal.UI.HistoricalAccountFrm == nil then
			hGlobal.UI.HistoricalAccountFrm = hUI.frame:new({
				x = hVar.SCREEN.w/2 - frmW/2 + 40,
				y = hVar.SCREEN.h/2 + frmH/2 + 10,
				w = frmW,
				h = frmH,
				show = 0,
				dragable = 3, --点击后消失
				background = -1,
				closeart = "none",
				codeOnClose = function()
					OnChooseAccount()
					OnClearAccountUI()
				end,
			})
		end
		local frm = hGlobal.UI.HistoricalAccountFrm
		local parent = frm.handle._n
		local childUI = frm.childUI

		local img91 = hApi.CCScale9SpriteCreate("data/image/panel/9sprite_bg_1.png",frmW/2,-frmH/2,frmW,frmH,frm,0)
		--img91:setOpacity(220)

		--获取历史账号记录 创建按钮
		local tAccountList = {}
		local tAccount = g_AccountRecord.lastlogin_account
		if type(tAccount) == "table" then
			for uid,lastnum in pairs(tAccount) do
				tAccountList[lastnum] = {uid,g_AccountRecord[uid]}
			end
		end
		--[[
		tAccountList = {
			[1] = {10004001,"ss2dc2"},
			[2] = {10005001,"4s2d1c"},
			[3] = {10006001,"c2dd87"},
		}
		--]]
		local num = math.min(nMaxShow,#tAccountList)
		for i = 1,num do
			childUI["btn_Account"..i] = hUI.button:new({
				parent = parent,
				dragbox = childUI["dragBox"],
				model = "misc/button_null.png",
				x = frmW/2,
				y = -btnH/2 - 6 - (btnH + 2) * (i - 1),
				w = frmW,
				h = btnH,
				label = {
					font = hVar.FONTC,
					text = tAccountList[i][1],
					size = 22,
					x = - frmW/2 + 10,
					border = 1,
					align = "LC",
				},
				code = function()
					OnChooseAccount(tAccountList[i])
					OnClearAccountUI()
					frm:show(0)
				end
			})
			--childUI["btn_Account"..i].handle.s:setOpacity(0)
			tRemoveUI[#tRemoveUI+1] = "btn_Account"..i
		end
		
		frm:show(1)
		frm:active()
	end

	
	InitAccountRecord = function()
		if hApi.FileExists(g_localfilepath.."account_record.cfg","full") then
			xlLoadGameData(g_localfilepath.."account_record.cfg")
			--赋值
			if type(g_AccountRecord.lastlogin_account) == "table" then
				local tAccount = g_AccountRecord.lastlogin_account
				if type(tAccount) == "table" then
					for uid,lastnum in pairs(tAccount) do
						if lastnum == 1 then
							g_guest_uid = uid
							g_guest_pw = g_AccountRecord[uid]
						end
					end
				end
			end
		else
			g_AccountRecord = {}
		end
	end

	hGlobal.event:listen("LocalEvent_getANewGuestRes","getANewGuestRes_Review",function(uid,name,password)
		
	end)

	hGlobal.event:listen("LocalEvent_RecordLastLogin","update_cfg",function()
		OnClearFunc()
	end)
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isshow)
		print("LocalEvent_ShowLoginFrm_Review",isshow)
		OnClearFunc()
		InitAccountRecord()
		if isshow == 1 then
			
			OnCreateLoginFrm()
		end
	end)
end

hGlobal.UI.InitSetFrm_Review = function(mode)
	local tInitEventName = {"LocalEvent_ShowSetFrm_Review","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local OnCreateSetFrm_Review = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local _CODE_BackToLogin = hApi.DoNothing
	local _CODE_SwitchSoundEnable = hApi.DoNothing
	
	OnLeaveFunc = function()
		if hGlobal.UI.SetFrm_Review then
			hGlobal.UI.SetFrm_Review:del()
			hGlobal.UI.SetFrm_Review = nil
		end
		hGlobal.event:event("Event_StartPauseSwitch", false)
	end

	--声音开关
	_CODE_SwitchSoundEnable = function(IsSwitch)
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
		local _frm = hGlobal.UI.SetFrm_Review
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_on.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_on"])
			end
		else
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_off.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_off"])
			end
		end
	end

	_CODE_BackToLogin = function()
		hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
		if hGlobal.WORLD.LastWorldMap then
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
			hGlobal.LocalPlayer:setfocusworld(nil)
			hApi.clearCurrentWorldScene()
		end
		hUI.NetDisable(9999)
		GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_OUT](xlPlayer_GetUID())
		--显示新主界面
		hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
		hGlobal.event:event("CloseYoungPlayerCountDownFrm")
		OnLeaveFunc()
	end

	OnCreateSetFrm_Review = function(nInGame)
		if hGlobal.UI.SetFrm_Review then
			hGlobal.UI.SetFrm_Review:del()
			hGlobal.UI.SetFrm_Review = nil
		end
		hGlobal.UI.SetFrm_Review = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 1000,
			show = 0,
			--dragable = 2,
			dragable = 2, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		local _frm = hGlobal.UI.SetFrm_Review
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 480,
			h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + 240 - 38,
			y = offY + 180 - 38,
			scaleT = 0.9,
			z = 2,
			code = function()
				OnLeaveFunc()
			end,
		})

		--默认数据 是新手引导时弹的
		local startY = 60
		local deltaH = - 120
		local btnIndex = 0

		--声音按钮
		_childUI["btn_music"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["music_on"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY + startY + btnIndex * deltaH,
			w = 240,
			h = 64,
			--scale = 0.95,
			code = function(self)
				_CODE_SwitchSoundEnable(1)
				OnCreateSetFrm_Review(nInGame)
			end,
		})
		
		--声音图标
		_childUI["soundenable"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/sound_on.png",
			dragbox = _childUI["dragBox"],
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = offX + 156,
			y = offY + startY + btnIndex * deltaH,
			code = function(self)
				_CODE_SwitchSoundEnable(1)
				OnCreateSetFrm_Review(nInGame)
			end,
		})
		
		btnIndex = btnIndex + 1


		_childUI["btn_main"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_MainInterface"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY + startY + btnIndex * deltaH,
			w = 240,
			h = 64,
			--scale = 0.95,
			code = function(self)
				_CODE_BackToLogin()
			end,
		})
		btnIndex = btnIndex + 1

		_CODE_SwitchSoundEnable()
		
		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("CloseMainBaseSetFrm","closefrm_review",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nInGame)
		OnLeaveFunc()
		OnCreateSetFrm_Review(nInGame)
		hGlobal.event:event("Event_StartPauseSwitch", true)
	end)
end

hGlobal.UI.InitFillInRealNameFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowFillInRealNameFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local WIDTH = 640
	local HEIGHT = 480

	local enterNameEditBox = nil
	local enterIdCardEditBox = nil

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFillInRealNameFrm = hApi.DoNothing

	local editNameBoxTextEventHandle = hApi.DoNothing
	local editIdCardBoxTextEventHandle = hApi.DoNothing

	editNameBoxTextEventHandle = function(strEventName,pSender)
		g_ReviewInfo.name = tostring(enterNameEditBox:getText())
	end

	editIdCardBoxTextEventHandle = function(strEventName,pSender)
		g_ReviewInfo.idcard = tostring(enterIdCardEditBox:getText())
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.FillInRealNameFrm then
			hGlobal.UI.FillInRealNameFrm:del()
			hGlobal.UI.FillInRealNameFrm = nil
		end
		enterNameEditBox = nil
		enterIdCardEditBox = nil
	end
	
	_CODE_CreateFillInRealNameFrm = function()
		print("_CODE_CreateFillInRealNameFrm")
		hGlobal.UI.FillInRealNameFrm = hUI.frame:new({
			x = hVar.SCREEN.w / 2 - WIDTH / 2,
			y = hVar.SCREEN.h / 2 + HEIGHT / 2, -- - 20,
			w = WIDTH,
			h = HEIGHT,
			z = 50001,
			show = 0,
			--dragable = 2,
			dragable = 4, 
			autoactive = 0,
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		local _frm = hGlobal.UI.FillInRealNameFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		local offX = WIDTH / 2
		local offY = -HEIGHT / 2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = WIDTH,
			h = HEIGHT,
			z = -1,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		if g_OBSwitch.channelcanCloseRealname == 1 then
			_childUI["closeBtn"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/skillup/btn_close.png",
				x = offX + WIDTH / 2 - 38,
				y = offY + HEIGHT / 2 - 38,
				scaleT = 0.9,
				z = 2,
				code = function()
					_CODE_ClearFunc()
					g_canSpinScreen = 1
					hGlobal.event:event("LocalEvent_EnterGame")
				end,
			})
		end

		--[[setInputMode()设置输入类型，可以包括如下的几种
		kEditBoxInputModeAny: 开启任何文本的输入键盘,包括换行
		kEditBoxInputModeEmailAddr: 开启 邮件地址 输入类型键盘
		kEditBoxInputModeNumeric: 开启 数字符号 输入类型键盘
		kEditBoxInputModePhoneNumber: 开启 电话号码 输入类型键盘
		kEditBoxInputModeUrl: 开启 URL 输入类型键盘
		kEditBoxInputModeDecimal: 开启 数字 输入类型键盘，允许小数点
		kEditBoxInputModeSingleLine: 开启任何文本的输入键盘,不包括换行
		--]]

		enterNameEditBox = CCEditBox:create(CCSizeMake(400, 42), CCScale9Sprite:create("data/image/misc/billboard/bg_ng_graywhite.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		enterNameEditBox:setPosition(ccp(offX, offY - 10))
		--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		enterNameEditBox:setFontSize(24)
		enterNameEditBox:setFontColor(ccc3(0, 0, 0))
		enterNameEditBox:setPlaceHolder(hVar.tab_string["enter_realname"])
		enterNameEditBox:setPlaceholderFontColor(ccc3(180, 180, 180))
		enterNameEditBox:setMaxLength(20)
		enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		enterNameEditBox:setTouchPriority(0)
		enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		--enterNameEditBox:setInputMode(kEditBoxInputModeSingleLine)
		_parent:addChild(enterNameEditBox)

		enterIdCardEditBox = CCEditBox:create(CCSizeMake(400, 42), CCScale9Sprite:create("data/image/misc/billboard/bg_ng_graywhite.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		enterIdCardEditBox:setPosition(ccp(offX, offY - 62))
		--enterIdCardEditBox:setFontName("Sketch Rockwell.ttf")
		enterIdCardEditBox:setFontSize(24)
		enterIdCardEditBox:setFontColor(ccc3(0, 0, 0))
		enterIdCardEditBox:setPlaceHolder(hVar.tab_string["enter_idcard"])
		enterIdCardEditBox:setPlaceholderFontColor(ccc3(180, 180, 180))
		enterIdCardEditBox:setMaxLength(18)
		enterIdCardEditBox:registerScriptEditBoxHandler(editIdCardBoxTextEventHandle)
		enterIdCardEditBox:setTouchPriority(0)
		enterIdCardEditBox:setReturnType(kKeyboardReturnTypeDone)
		--enterIdCardEditBox:setInputMode(kEditBoxInputModeNumeric)
		_parent:addChild(enterIdCardEditBox)

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			x = offX - WIDTH / 2 + 48,
			y = offY+ HEIGHT / 2 - 60,
			width = WIDTH - 40 * 2,
			align = "LT",
			size = 26,
			border = 0,
			font = hVar.FONTC,
			text = hVar.tab_string["realname_1"],
		})

		_childUI["btn_yes"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["Exit_Ack"],size = 32,y= 4,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY - HEIGHT / 2 + 80,
			--w = 124,
			--h = 52,
			code = function(self)
				--先判断
				if string.len(g_ReviewInfo.idcard) < 18 then
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2500,
						fadeout = -550,
						--moveY = 32,
					}):addtext(hVar.tab_string["realnamecheck_err20010"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
					return
				end
				local errorcode = xlLuaEvent_CheckPlayerYear(g_ReviewInfo.idcard)
				if errorcode ~= 0 then
					if errorcode == 1 then
						hGlobal.event:event("LocalEvent_CloseRealNameFrm")
					end
					return
				end
				self:setstate(0)
				--屏蔽操作
				hUI.NetDisable(10000)

				hApi.addTimerOnce("try_again_later",10000,function()
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2500,
						fadeout = -550,
						--moveY = 32,
					}):addtext(hVar.tab_string["try_again_later"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
					self:setstate(1)
				end)

				local uid = xlPlayer_GetUID()
				--调用程序接口检测
				xlRealNameCheckId(g_ReviewInfo.idcard,g_ReviewInfo.name,uid,0)
			end,
		})

		if hVar.RealNameMode == 1 then
			g_ReviewInfo.idcard = g_ReviewTestInfo.idcard
			g_ReviewInfo.name = g_ReviewTestInfo.name
			enterNameEditBox:setText(g_ReviewInfo.name)
			enterIdCardEditBox:setText(g_ReviewInfo.idcard)
		end

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_RealNameCheckId_cb","RealNameCheckId_cb",function(err)
		hApi.clearTimer("try_again_later")
		local _frm = hGlobal.UI.FillInRealNameFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		if err ~= 0 then
			_childUI["btn_yes"]:setstate(1)
		else
			enterNameEditBox:setVisible(false)
			enterIdCardEditBox:setVisible(false)
		end
	end)

	hGlobal.event:listen("LocalEvent_CloseRealNameFrm","_CloseRealNameFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFillInRealNameFrm()
	end)
end

hGlobal.UI.InitYoungPlayerCountDownFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowYoungPlayerCountDownFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _frm,_parent,_childUI

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateYoungPlayerCountDownFrm = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.YoungPlayerCountDownFrm then
			hGlobal.UI.YoungPlayerCountDownFrm:del()
			hGlobal.UI.YoungPlayerCountDownFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
	end

	_CODE_CreateYoungPlayerCountDownFrm = function(nTime)
		hGlobal.UI.YoungPlayerCountDownFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 99999,
			show = 0,
			buttononly = 1,
			autoactive = 0,
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.YoungPlayerCountDownFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["lab_refreshtime"] = hUI.label:new({
			parent = _parent,
			size = 24,
			align = "LC",
			font = hVar.FONTC,
			x = hVar.SCREEN.offx + 40,
			y = -hVar.SCREEN.h + 80,
			border = 1,
			text = hVar.tab_string["remaining_time"],
			--RGB = {255,0,0},
		})

		local nAllTime = nTime or 60
		local nTimeLeft = nAllTime
		local nHour,nMin,nSec = hApi.Seconds2HMS(nTimeLeft)
		_childUI["lab_refreshtime"] = hUI.label:new({
			parent = _parent,
			size = 26,
			align = "LC",
			font = hVar.FONTC,
			x = hVar.SCREEN.offx + 40,
			y = -hVar.SCREEN.h + 50,
			border = 1,
			text = nHour..":"..nMin..":"..nSec,
			--RGB = {255,0,0},
		})
		local nSystemTime = hApi.gametime()
		local ChangeTime = function()
			if nTimeLeft >= 0 then
				local nPassSeconds = math.floor((hApi.gametime()-nSystemTime)/1000)
				nTimeLeft = nAllTime - nPassSeconds

				--转换格式
				local nHour, nMin, nSec = hApi.Seconds2HMS(nTimeLeft)
				--显示时间
				_childUI["lab_refreshtime"]:setText(nHour..":"..nMin..":"..nSec)
				
				--倒计时结束
				if 0 == nTimeLeft then
					_CODE_ClearFunc()
					hGlobal.event:event("Event_StartPauseSwitch", true)
					hApi.ShowTimeLimitFrm()
				end
			end
		end
		_childUI["lab_refreshtime"].handle.s:stopAllActions()
		_childUI["lab_refreshtime"].handle.s:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(ChangeTime))))

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("CloseYoungPlayerCountDownFrm","closefrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nTime)
		_CODE_ClearFunc()
		_CODE_CreateYoungPlayerCountDownFrm(nTime)
	end)
end

hGlobal.UI.InitYoungPlayerWarningFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowYoungPlayerWarningFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local WIDTH = 640
	local HEIGHT = 420

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateYoungPlayerWarningFrm = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.YoungPlayerWarningFrm then
			hGlobal.UI.YoungPlayerWarningFrm:del()
			hGlobal.UI.YoungPlayerWarningFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
	end

	_CODE_CreateYoungPlayerWarningFrm = function()
		hGlobal.UI.YoungPlayerWarningFrm = hUI.frame:new({
			x = hVar.SCREEN.w / 2 - WIDTH / 2,
			y = hVar.SCREEN.h / 2 + HEIGHT / 2, -- - 20,
			w = WIDTH,
			h = HEIGHT,
			z = 100,
			show = 0,
			--dragable = 2,
			dragable = 4, 
			autoactive = 0,
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.YoungPlayerWarningFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		local offX = WIDTH / 2
		local offY = -HEIGHT / 2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = WIDTH,
			h = HEIGHT,
			z = -1,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			x = offX - WIDTH / 2 + 42,
			y = offY+ HEIGHT / 2 - 60,
			width = WIDTH - 32 * 2,
			align = "LT",
			size = 26,
			border = 0,
			font = hVar.FONTC,
			text = hVar.tab_string["realname_3"],
		})

		_childUI["btn_yes"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["Exit_Ack"],size = 32,y= 4,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY - HEIGHT / 2 + 80,
			--w = 124,
			--h = 52,
			code = function(self)
				--最后调用审核模式的登陆回调
				hGlobal.event:event("LocalEvent_OnReviewlogin")
				_CODE_ClearFunc()
			end,
		})

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateYoungPlayerWarningFrm()
	end)
end