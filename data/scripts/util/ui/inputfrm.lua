--设置密码界面
hGlobal.UI.InitInputFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowInputFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.InputFrm =hUI.frame:new({
			x = hVar.SCREEN.w/2 - 265,
			y = hVar.SCREEN.h/2 + 230,
			h = 460,
			w = 530,
			show = 0,
			dragable = 3,
			titlebar = 0,
			bgAlpha = 0,
			bgMode = "tile",
			--background = "UI:tip_item",
			border = "UI:TileFrmBasic_thin",
			autoactive = 0,
	})

	local _frm = hGlobal.UI.InputFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	local _PassWord = ""
	local _GUIDFour = ""
	local _lenN = 6
	--TITILE
	_childUI["TITILE"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		x = _frm.data.w/2 - 6,
		y = -30,
		font = hVar.FONTC,
		width = 540,
		text = hVar.tab_string["__TEXT_SetPassWord"],
	})

	--分界线2
	_childUI["apartline_2"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _frm.data.w/2,
		y = -60,
		w = 510,
		h = 8,
	})

	--输入框
	_childUI["game_coins_image"] = hUI.image:new({
		parent = _parent,
		model = "UI:tip_item",
		x =  _frm.data.w/2,
		y = -100,
		w = 400,
		h = 42
	})

	--提示信息
	_childUI["PromptInfo"]  = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		--font = hVar.FONTC,
		x = _frm.data.w/2-6,
		y = -100,
		RGB = {0,255,0},
		width = 540,
		text = hVar.tab_string["__TEXT_SetPassWordInfo"],
	})

	--玩家输入的数字
	_childUI["PlayerInput"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "LT",
		x = _frm.data.w/2 - 60,
		y = -80,
		width = 540,
		text = "",
	})
	
	--删除玩家输入的数字
	local _DeleteNumber = function()
		_PassWord = ""
		_childUI["PlayerInput"]:setText(_PassWord)
		_childUI["PromptInfo"].handle._n:setVisible(true)
		_childUI["btnOK"]:setstate(0)
	end

	--数字按钮
	local _Number = function(number)
		--local password = ""
		--for i = 1,#_PassWord do
			--password = password.."* "
		--end
		
		if #_PassWord < _lenN then
			_childUI["PromptInfo"].handle._n:setVisible(false)
			_PassWord = _PassWord..number
			--password = password ..number

			--设置当前可见的密码
			_childUI["PlayerInput"]:setText(_PassWord)
			--_childUI["PlayerInput"]:setXY(_frm.data.w/2 - 60,-80)
			--hApi.addTimerOnce("tipActionDelete",700,function()
				--local password = ""
				--for i = 1,#_PassWord do
					--password = password.."* "
				--end
				----再次设置成密文
				--_childUI["PlayerInput"]:setXY(_frm.data.w/2 - 60,-86)
				--_childUI["PlayerInput"]:setText(password)
			--end)
		end

		if #_PassWord == _lenN then
			_childUI["btnOK"]:setstate(1)
		end
		
	end

	--按键lab
	local _BtnLab = {
		"1","2","3","0",
		"4","5","6","<<",
		"7","8","9","C",
	}

	for i = 1,12 do
		_childUI["btn"..i] = hUI.button:new({
			parent = _frm,
			model = "UI:item_slot",
			label = {
				size = 32,
				border = 1,
				text = _BtnLab[i],
			},
			x = 120 + ((i-1) % 4 ) * 100,
			y = -340 + math.floor((i-1)/4) * 80,
			h = 72,
			w = 72,
			scaleT = 0.9,
			code = function()
				if type(tonumber(_BtnLab[i])) == "number" then
					_Number(tonumber(_BtnLab[i]))
				elseif _BtnLab[i] == "C" then
					_DeleteNumber()
				elseif _BtnLab[i] == "<<" then
					_PassWord = string.sub(_PassWord,1,string.len(_PassWord)-1)
					--local password = ""
					--for i = 1,#_PassWord do
						--password = password.."* "
					--end
					--_childUI["PlayerInput"]:setXY(_frm.data.w/2 - 60,-86)
					_childUI["btnOK"]:setstate(0)
					_childUI["PlayerInput"]:setText(_PassWord)

					if #_PassWord == 0 then
						_childUI["PromptInfo"].handle._n:setVisible(true)
					end
				end
				_frm:show(1)
			end,
		})
	end
	
	--确定按钮
	local _palyerName,_index,_mode = "",0,0
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["Exit_Ack"],
		border = 1,
		model = "UI:ButtonBack",
		x = _frm.data.w - 150,
		y = 40 -_frm.data.h,
		font = hVar.FONTC,
		w = 128,
		h = 38,
		scaleT = 0.9,
		code = function(self)
			self:setstate(0)
			--等于1时 是设置密码
			if _mode == 1 then
				SendCmdFunc["send_UidPassWord"](_PassWord)
			--等于2时 是删除玩家
			elseif _mode == 2 then
				if _PassWord == _GUIDFour then
					_childUI["PlayerInput"]:setText("")
					if type(Save_PlayerData.playerDataID) == "number" and Save_PlayerData.playerDataID == 0 then
						hGlobal.event:event("LocalEvent_Phone_DeletePlayer",_palyerName,_index)
					elseif type(Save_PlayerData.playerDataID) == "number" and Save_PlayerData.playerDataID ~= 0 then
						SendCmdFunc["delete_cha_rid"](Save_PlayerData.playerDataID,_index)
					end
					_frm:show(0)
				else
					_childUI["PlayerInput"]:setText("")
					_childUI["PromptInfo"].handle._n:setVisible(true)
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Prompt_Clear"],{})
					_frm:show(1)
				end
			end
		end,
	})

	--取消按钮
	_childUI["btnCancel"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["Exit_Now"],
		model = "UI:ButtonBack",
		x = _frm.data.w/5 + 50,
		y = 40 -_frm.data.h,
		font = hVar.FONTC,
		border = 1,
		w = 128,
		h = 38,
		scaleT = 0.9,
		code = function()
			_PassWord = ""
			_childUI["PlayerInput"]:setText(_PassWord)
			_frm:show(0)
		end,
	})

	--打开此面板
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isShow,mode,pamaA,pamaB)
		_GUIDFour = 0
		_mode = mode or 1
		_childUI["btnOK"]:setstate(0)
		_PassWord = ""
		_childUI["PlayerInput"]:setText(_PassWord)
		_frm:show(isShow)

		--设置面板文字
		if mode == 1 then
			_childUI["TITILE"]:setText(hVar.tab_string["__TEXT_SetPassWord"])
			_childUI["PromptInfo"]:setText(hVar.tab_string["__TEXT_SetPassWordInfo"])
			_childUI["PlayerInput"]:setXY(_frm.data.w/2-60,-80)
			_lenN = 6
		elseif mode == 2 then
			_childUI["TITILE"]:setText(hVar.tab_string["__TEXT_Player_Delete"])
			_childUI["PromptInfo"]:setText(hVar.tab_string["__TEXT_Prompt_GUID1"])
			_childUI["PlayerInput"]:setXY(_frm.data.w/2-36,-80)
			_lenN = 4

			_palyerName,_index = pamaA,pamaB
			
			local uID = xlPlayer_GetUID()
			_GUIDFour = string.sub(uID,-4)
		end

		if isShow == 1 then
			_childUI["PromptInfo"].handle._n:setVisible(true)
			_frm:active()
		end
	end)	

end