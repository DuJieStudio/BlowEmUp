g_SyncDataTicketNum = 0		--本地内存里的转移存档订单号
g_SyncDataState = 0		--本地内存里的转移存档订单状态
hGlobal.UI.InitMangerFram = function()
	local _w,_h = 580,430
	hGlobal.UI.MangerFram_guest = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
	})

	local _guestfrm = hGlobal.UI.MangerFram_guest
	local _guestparent = _guestfrm.handle._n
	local _guestchildUI = _guestfrm.childUI

	--title
	_guestchildUI["title"] = hUI.label:new({
		parent = _guestparent,
		--font = hVar.FONTC,
		size = 34,
		text = hVar.tab_string["__TEXT_ShiftData0"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -30,
	})

	--顶部分界线
	_guestchildUI["apartline_back"] = hUI.image:new({
		parent = _guestparent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -70,
		w = _w,
		h = 8,
	})

	_guestchildUI["infoText4"] = hUI.label:new({
		parent = _guestparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTip41"],
		align = "LT",
		border = 1,
		x = 130,
		y = -82,
		width = _w - 40,
	})

	_guestchildUI["id_self"] = hUI.label:new({
		parent = _guestparent,
		--font = hVar.FONTC,
		size = 26,
		text =hVar.tab_string["guest"],
		align = "LT",
		border = 1,
		x = 330,
		y = -82,
		width = _w - 40,
		RGB = {230,180,50},
	})

	_guestchildUI["info"] = hUI.label:new({
		parent = _guestparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["guest_info"],
		align = "LT",
		border = 1,
		width = 400,
		x = 30,
		y = -150,
		width = _w - 40,
	})

	_guestchildUI["info2"] = hUI.label:new({
		parent = _guestparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["guest_info1"],
		align = "LC",
		border = 1,
		width = 400,
		x = 30,
		y = -300,
		width = _w - 40,
	})

	_guestchildUI["check_in"] = hUI.button:new({
		parent = _guestparent,
		model = "UI:ButtonBack",
		icon = "ui/password.png",
		iconWH = 30,
		label = {text = hVar.tab_string["guest_check_in"],size = 20,font = hVar.FONTC,border = 1},
		dragbox = _guestfrm.childUI["dragBox"],
		x = _w/2,
		y = -360,
		scaleT = 0.9,
		code = function()
			hGlobal.event:event("LocalEvent_ShowCheckIn",1)
		end,
	})
	
	hGlobal.event:listen("LocalEvent_ShowMangerGuestFram","ShowMangerFram",function()
		_guestfrm:show(1)
		_guestfrm:active()
	end)
	
	hGlobal.event:listen("LocalEvent_CloseMangerGuestFram","ShowMangerFram",function()
		_guestfrm:show(0)
	end)
	
	hGlobal.UI.MangerFram = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
	})
	
	local _frm = hGlobal.UI.MangerFram
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	--title
	_childUI["title"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 34,
		text = hVar.tab_string["__TEXT_ShiftData0"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -30,
	})
	
	--顶部分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -70,
		w = _w,
		h = 8,
	})
	
	--游戏账号
	_childUI["infoText4"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTip4_0"],
		align = "LT",
		border = 1,
		x = 130,
		y = -82,
		width = _w - 40,
	})
	
	_childUI["id_self"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "LT",
		border = 1,
		x = 330,
		y = -82,
		width = _w - 40,
		RGB = {255,0,0},
	})
	
	_childUI["id_self"]:setText(xlPlayer_GetUID())
		hGlobal.event:listen("renewuid","ShowMangerFram",function()
		_childUI["id_self"]:setText(xlPlayer_GetUID())
	end)
	
	--设置密码
	_childUI["password"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/password.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_SetPassWord"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = -160,
		scaleT = 0.9,
		code = function()
			hGlobal.event:event("LocalEvent_ShowInputFrm",1,1)
		end,
	})
	
--	_childUI["setphoto"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/password.png",
--		iconWH = 30,
--		label = {text = hVar.tab_string["set_photo"],size = 28,font = hVar.FONTC,border = 1},
--		dragbox = _frm.childUI["dragBox"],
--		x = _w/2,
--		y = -200,
--		scaleT = 0.9,
--		code = function()
--			hGlobal.event:event("LocalEvent_showphotofrm",1)
--		end,
--	})
	--"数据迁移"文字
	_childUI["change"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/bimage_bbs.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_ShiftDataC"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = -240,
		scaleT = 0.9,
		code = function()
			--hGlobal.event:event("LocalEvent_ShowSyncDataFrm")
			
			--[[
			--geyachao: 该功能有bug，暂时关闭
			--local strText = "该功能正在修复中，即将恢复开放" --language
			local strText = hVar.tab_string["__TEXT_ShiftDataBugClosed"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
			]]
			
			if (LuaGetPlayerMapAchi("world/td_004_tyjy" ,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1) then
				--SendCmdFunc["ask_7_days"]()
				--_frm:show(0)
				hGlobal.event:event("LocalEvent_ShowSyncDataFrm")
			else
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_inform_archiLock"])
			end
			
		end,
	})
	
	_childUI["check_in"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		icon = "ui/bimage_bbs.png",
		iconWH = 30,
		label = {text = hVar.tab_string["__TEXT_ShiftDataCheckIn"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _frm.childUI["dragBox"],
		x = _w/2,
		y = -320,
		scaleT = 0.9,
		code = function()
			hGlobal.event:event("LocalEvent_ShowCheckIn",1)
		end,
	})
	
	_childUI["infoText1"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 22,
		text = hVar.tab_string["__TEXT_ShiftDataTip10"],
		align = "LT",
		border = 1,
		x = 20,
		y = -360,
		width = _w - 40,
	})
	
	hGlobal.event:listen("LocalEvent_ShowMangerFram","ShowMangerFram",function()
		_frm:show(1)
		_frm:active()
		--print("LocalEvent_ShowMangerFram")
		
		--geyachao: 动态刷新一下账号id
		local playerId = xlPlayer_GetUID()
		_childUI["id_self"]:setText(playerId)
	end)

	hGlobal.event:listen("LocalEvent_CloseMangerFram","ShowMangerFram",function()
		_frm:show(0)
	end)
end
hGlobal.UI.InitSyncDataFram = function()
	local _w,_h = 580,430
	
	local ci_oid = ""
	local ci_opass = ""
	local ci_oid_len = 0
	local ci_opass_len = 0
	local ci_oid_len_need = 8
	local ci_opass_len_need = 6
	local ci_ocoin = ""
	local ci_oscore = "123"
	local ci_ocoin_len = 0
	local ci_oscore_len = 3

	hGlobal.UI.CheckInFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
	})

	local _cifrm = hGlobal.UI.CheckInFrm
	local _ciparent = _cifrm.handle._n
	local _cichildUI = _cifrm.childUI

	--顶部分界线
	_cichildUI["apartline_back"] = hUI.image:new({
		parent = _ciparent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -60,
		w = _w,
		h = 8,
	})

	--title
	_cichildUI["title"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 30,
		text = hVar.tab_string["__TEXT_ShiftDataCheckIn_INFO"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -28,
	})

	_cichildUI["text1"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["old_id"]..":",
		align = "LT",
		border = 1,
		x = 70,
		y = -72,
		width = _w - 40,
	})

	_cichildUI["text1_button"] = hUI.button:new({
		parent = _ciparent,
		dragbox = _cichildUI["dragBox"],
		--label = hVar.tab_string["Exit_Ack"],
		model = "ui/tfback.png",
		x = 440,
		y = -90,
		w = 130,
		h = 36,
		--scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"text1_button",1,ci_oid_len_need,ci_oid_len)
		end,
	})

	_cichildUI["text1_num"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "MT",
		border = 1,
		x = 440,
		y = -76,
		width = _w - 40,
	})


	_cichildUI["text2"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["old_pass"]..":",
		align = "LT",
		border = 1,
		x = 70,
		y = -112,
		width = _w - 40,
	})
	
	_cichildUI["text2_button"] = hUI.button:new({
		parent = _ciparent,
		dragbox = _cichildUI["dragBox"],
		--label = hVar.tab_string["Exit_Ack"],
		model = "ui/tfback.png",
		x = 440,
		y = -130,
		w = 130,
		h = 36,
		--scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"text2_button",1,ci_opass_len_need,ci_opass_len)
		end,
	})
	
	_cichildUI["text2_num"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "MT",
		border = 1,
		x = 440,
		y = -116,
		width = _w - 40,
	})

	_cichildUI["title2"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 30,
		text = hVar.tab_string["oldidcheck"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -178,
	})

	_cichildUI["text3"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["old_coin"]..":",
		align = "LT",
		border = 1,
		x = 70,
		y = -212,
		width = _w - 40,
	})
	
	_cichildUI["text3_button"] = hUI.button:new({
		parent = _ciparent,
		dragbox = _cichildUI["dragBox"],
		--label = hVar.tab_string["Exit_Ack"],
		model = "ui/tfback.png",
		x = 440,
		y = -230,
		w = 130,
		h = 36,
		--scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"text3_button",1)
		end,
	})
	
	_cichildUI["text3_num"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "MT",
		border = 1,
		x = 440,
		y = -216,
		width = _w - 40,
	})


	_cichildUI["info1"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 22,
		text = "1."..hVar.tab_string["check_in_info1"],
		align = "LC",
		border = 1,
		width = 500,
		x = 30,
		y = -290,
	})

	_cichildUI["info2"] = hUI.label:new({
		parent = _ciparent,
		--font = hVar.FONTC,
		size = 22,
		text = "2."..hVar.tab_string["check_in_info2"],
		align = "LC",
		border = 1,
		width = 500,
		x = 30,
		y = -350,
	})

	--确定按钮
	_cichildUI["btnOK"] = hUI.button:new({
		parent = _ciparent,
		dragbox = _cichildUI["dragBox"],
		label = hVar.tab_string["confirm_checkin"],
		model = "UI:ButtonBack2",
		x = _w/2,
		y = 30 -_h,
		scaleT = 0.9,
		w = 114,
		h = 40,
		code = function(self)
			SendCmdFunc["check_in_1"](tonumber(ci_oid),ci_opass,tonumber(ci_ocoin),0)
		end,
	})

	_cichildUI["btnOK"]:setstate(0)

	--_cichildUI["ask"] = hUI.button:new({
		--parent = _ciparent,
		--model = "ICON:action_info",
		--h = 38,
		--w = 38,
		--dragbox = _cichildUI["dragBox"],
		--x = _w/2 + 120,
		--y = 30 -_h,
		--scaleT = 0.9,
		--code = function()

		--end,
	--})
	
	hGlobal.event:listen("LocalEvent_ShowCheckIn","showCheckInfrm",function(isShow)
		_cifrm:show(isShow)
		if isShow == 1 then
			_cifrm:active()
			ci_oid = ""
			ci_opass = ""
			ci_ocoin = ""
			ci_oid_len = 0
			ci_opass_len = 0
			ci_ocoin_len = 0
			_cichildUI["text1_num"]:setText(ci_oid)
			_cichildUI["text2_num"]:setText(ci_opass)
			_cichildUI["text3_num"]:setText(ci_ocoin)
		end
	end)

	hGlobal.UI.SyncDataFram = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
	})

	local _frm = hGlobal.UI.SyncDataFram
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	local new_uid = ""
	local new_password = ""
	local new_uid_len = 0
	local new_password_len = 0
	local new_uid_len_need = 8
	local new_password_len_need = 6
	local coin_str = ""
	local coin_str_len = 0
	
	--顶部分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -60,
		w = _w,
		h = 8,
	})

	--title
	_childUI["title"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 30,
		text = hVar.tab_string["__TEXT_ShiftData"],
		align = "MC",
		border = 1,
		x = _w/2,
		y = -28,
	})
	
	--转档声明
	_childUI["infoText8"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 22,
		text = hVar.tab_string["__TEXT_ShiftDataTip8"],
		align = "LT",
		border = 1,
		x = 20,
		y = -230,
		width = _w - 40,
	})

	--_childUI["infoText"] = hUI.label:new({
		--parent = _parent,
		----font = hVar.FONTC,
		--size = 26,
		--text = hVar.tab_string["__TEXT_ShiftDataTip"],
		--align = "LT",
		--border = 1,
		--x = 30,
		--y = -76,
		--width = _w - 40,
	--})
	_childUI["infoText1"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 20,
		text = "1."..hVar.tab_string["__TEXT_ShiftDataTip1"],
		align = "LT",
		border = 1,
		x = 20,
		y = -256,
		width = _w - 40,
	})

	_childUI["infoText2"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 20,
		text = "2."..hVar.tab_string["__TEXT_ShiftDataTip2"],
		align = "LT",
		border = 1,
		x = 20,
		y = -286,
		width = _w - 40,
	})

	_childUI["infoText3"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 20,
		text = "3."..hVar.tab_string["__TEXT_ShiftDataTip7"],
		align = "LT",
		border = 1,
		x = 20,
		y = -316,
		width = _w - 40,
	})

	_childUI["infoText7"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 20,
		text = "4."..hVar.tab_string["__TEXT_ShiftDataTip3"],
		align = "LT",
		border = 1,
		x = 20,
		y = -346,
		width = _w - 40,
	})
	
	local name = ""
	
	
	_childUI["infoText8"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 20,
		text = "",
		align = "LT",
		border = 1,
		x = 20,
		y = -346,
		width = _w - 40,
		RGB = {255,0,0},
	})
	
	--待迁出游戏账号
	_childUI["infoText4"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTip4"],
		align = "LT",
		border = 1,
		x = 70,
		y = -72,
		width = _w - 40,
	})
	
	--_childUI["infoText5"] = hUI.label:new({
		--parent = _parent,
		----font = hVar.FONTC,
		--size = 26,
		--text = hVar.tab_string["__TEXT_ShiftDataTip5"],
		--align = "LT",
		--border = 1,
		--x = 70,
		--y = -120,
		--width = _w - 40,
	--})
	
	_childUI["infoText6"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTip6"],
		align = "LT",
		border = 1,
		x = 70,
		y = -120,
		width = _w - 40,
	})
	
	_childUI["id_self"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "LT",
		border = 1,
		x = 300,
		y = -72,
		width = _w - 40,
		RGB = {255,0,0},
	})
	
	_childUI["id_self"]:setText(xlPlayer_GetUID())
	_childUI["coin"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTipCoin"],
		align = "LT",
		border = 1,
		x = 70,
		y = -160,
		width = _w - 40,
	})
	_childUI["coin_button"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		--label = hVar.tab_string["Exit_Ack"],
		model = "ui/tfback.png",
		x = 356,
		y = -176,
		w = 130,
		h = 36,
		--scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"coin_button",1)
		end,
	})
	_childUI["coin_info"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",--hVar.tab_string["__TEXT_ShiftDataTip42"],
		align = "LT",
		border = 1,
		x = 300,
		y = -162,
		width = _w - 40,
	})
	
	_childUI["name"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["__TEXT_ShiftDataTip42"],
		align = "LT",
		border = 1,
		x = 70,
		y = -200,
		width = _w - 40,
	})
	_childUI["name_info"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",--hVar.tab_string["__TEXT_ShiftDataTip42"],
		align = "LT",
		border = 1,
		x = 300,
		y = -200,
		width = _w - 40,
	})

	--_childUI["id_new_button"] = hUI.button:new({
	--	parent = _parent,
	--	dragbox = _childUI["dragBox"],
	--	--label = hVar.tab_string["Exit_Ack"],
	--	model = "ui/tfback.png",
	--	x = 356,
	--	y = -130,
	--	w = 130,
	--	h = 36,
	--	--scaleT = 0.9,
	--	code = function(self)
	--		hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"id_new_button",1,new_uid_len_need,new_uid_len)
	--	end,
	--})
	
	_childUI["pass_new_button"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		--label = hVar.tab_string["Exit_Ack"],
		model = "ui/tfback.png",
		x = 356,
		y = -130,
		w = 130,
		h = 36,
		--scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showLuaInputFrm",1,"pass_new_button",1,new_password_len_need,new_password_len)
		end,
	})
	
	_childUI["id_new"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "LT",
		border = 1,
		x = 300,
		y = -116,
		width = _w - 40,
		RGB = {255,0,0},
	})
	
	--_childUI["id_new"]:setText("12345678")
	
	_childUI["pass_new"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 26,
		text = "",
		align = "LT",
		border = 1,
		x = 310,
		y = -116,
		width = _w - 40,
		RGB = {255,0,0},
	})
	
	--_childUI["pass_new"]:setText("123456")
	
	--确定按钮
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_ShiftDataTip9"],
		model = "UI:ButtonBack2",
		x = _w/2,
		y = 30 -_h,
		scaleT = 0.9,
		w = 114,
		h = 40,
		code = function(self)
			--self:setstate(0)
			--Lua_SendPlayerData(99)
			--if new_uid ~= "" and new_password ~= "" then
				local isFinish = LuaGetPlayerMapAchi("world/td_004_tyjy",hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if isFinish == 0 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataMapLimitTip"],{
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
				else
					--SendCmdFunc["SyncData_Begin"](tonumber(new_uid),new_password)
					print("new_password:",new_password,coin_str)
					SendCmdFunc["check_out_1"](new_password,tonumber(coin_str),0)
					self:setstate(0)
				end
			--end
		end,
	})

	_childUI["btnOK"]:setstate(0)
	
	--取消按钮
	--_childUI["btnCancel"] = hUI.button:new({
		--parent = _parent,
		--dragbox = _childUI["dragBox"],
		--label = hVar.tab_string["__TEXT_Cancel"],
		--model = "UI:ButtonBack2",
		--x = _w/2 - 150,
		--y = 30 -_h,
		--scaleT = 0.9,
		--w = 114,
		--h = 40,
		--code = function()
			--_frm:show(0)
		--end,
	--})
	
	--hGlobal.event:listen("LocalEvent_GetWormHoleState","setg",function(orderid,status)
		--g_SyncDataTicketNum = orderid
		--g_SyncDataState = status
	--end)
	
	hGlobal.event:listen("LocalEvent_ShowSyncDataFrm","showthisfrm",function()
		_frm:show(1)
		_frm:active()
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)	
		if playerInfo and playerInfo.showName and playerInfo.showName ~= "" then
			name = playerInfo.showName
		else
			name = g_curPlayerName
		end
		_childUI["infoText8"]:setText("")

		_childUI["id_self"]:setText(xlPlayer_GetUID().."  ".."["..name.."]")
		_childUI["name_info"]:setText(name)

		_childUI["pass_new"]:setText("")
		_childUI["coin_info"]:setText("")
		new_password = ""
		coin_str = ""
		new_password_len = 0
		coin_str_len = 0
	end)
	
	hGlobal.event:listen("LocalEvent_set_UGID_PASSWORD","fix_password",function(ui_name,text)
		if ui_name == "id_new_button" then
			if new_uid_len <= new_uid_len_need - 1 then
				new_uid = new_uid..text
				new_uid_len = new_uid_len + 1
				_childUI["id_new"]:setText(new_uid)
				if new_uid_len >= new_uid_len_need  then
					hGlobal.event:event("LocalEvent_set_OKbtnState",1)
				end
			end
		elseif ui_name == "pass_new_button" then
			if new_password_len <= new_password_len_need - 1 then
				new_password = new_password..text
				new_password_len = new_password_len + 1
				_childUI["pass_new"]:setText(new_password)
				if new_password_len >= new_password_len_need  then
					hGlobal.event:event("LocalEvent_set_OKbtnState",1)
					if coin_str_len >= 1 then
						_childUI["btnOK"]:setstate(1)
					else
						_childUI["btnOK"]:setstate(0)
					end
					
				else
					hGlobal.event:event("LocalEvent_set_OKbtnState",0)
				end
			end
		elseif ui_name == "send_id_button" then
			hGlobal.event:event("LocalEvent_sent2uidChange",ui_name,text)

		elseif ui_name == "text1_button" then
			if ci_oid_len <= ci_oid_len_need - 1 then
				ci_oid = ci_oid..text
				ci_oid_len = ci_oid_len + 1
				_cichildUI["text1_num"]:setText(ci_oid)
				if ci_oid_len >= ci_oid_len_need  then
					hGlobal.event:event("LocalEvent_set_OKbtnState",1)
				end
				if ci_oid_len >= ci_oid_len_need and ci_opass_len >= ci_opass_len_need and ci_ocoin ~= "" and ci_oscore ~= "" then
					_cichildUI["btnOK"]:setstate(1)
				end
			end
		elseif ui_name == "text2_button" then
			if ci_opass_len <= ci_opass_len_need - 1 then
				ci_opass = ci_opass..text
				ci_opass_len = ci_opass_len + 1
				_cichildUI["text2_num"]:setText(ci_opass)
				if ci_opass_len >= ci_opass_len_need  then
					hGlobal.event:event("LocalEvent_set_OKbtnState",1)
				end
				if ci_oid_len >= ci_oid_len_need and ci_opass_len >= ci_opass_len_need and ci_ocoin ~= "" and ci_oscore ~= "" then
					_cichildUI["btnOK"]:setstate(1)
				end
			end
		elseif ui_name == "text3_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			ci_ocoin_len = ci_ocoin_len + 1
			ci_ocoin = ci_ocoin..text
			_cichildUI["text3_num"]:setText(ci_ocoin)
			if ci_oid_len >= ci_oid_len_need and ci_opass_len >= ci_opass_len_need and ci_ocoin ~= "" and ci_oscore ~= "" then
				_cichildUI["btnOK"]:setstate(1)
			end
		elseif ui_name == "text4_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			ci_oscore_len = ci_oscore_len + 1
			ci_oscore = ci_oscore..text
			_cichildUI["text4_num"]:setText(ci_oscore)
			if ci_oid_len >= ci_oid_len_need and ci_opass_len >= ci_opass_len_need and ci_ocoin ~= "" and ci_oscore ~= "" then
				_cichildUI["btnOK"]:setstate(1)
			end
		elseif ui_name == "coin_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			coin_str_len = coin_str_len + 1
			coin_str = coin_str..text
			_childUI["coin_info"]:setText(coin_str)
			if new_password_len >= new_password_len_need and  coin_str_len >= 1 then
				_childUI["btnOK"]:setstate(1)
			else
				_childUI["btnOK"]:setstate(0)
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_BackSpace","fix_password",function(ui_name)
		if ui_name == "id_new_button" then
			if new_uid_len >= 1 then
				new_uid_len = new_uid_len - 1
				hGlobal.event:event("LocalEvent_set_OKbtnState",0)
				new_uid = string.sub(new_uid,1,new_uid_len)
				_childUI["id_new"]:setText(new_uid)
			end
		elseif ui_name == "pass_new_button" then
			if new_password_len >= 1 then
				new_password_len = new_password_len - 1
				hGlobal.event:event("LocalEvent_set_OKbtnState",0)
				new_password = string.sub(new_password,1,new_password_len)
				_childUI["pass_new"]:setText(new_password)
				_childUI["btnOK"]:setstate(0)
			end
		elseif ui_name == "send_id_button" then
			hGlobal.event:event("LocalEvent_sent2uidChange",ui_name,-1)
		elseif ui_name == "text1_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",0)
			if ci_oid_len >= 1 then
				ci_oid_len = ci_oid_len - 1
				ci_oid = string.sub(ci_oid,1,ci_oid_len)
				_cichildUI["text1_num"]:setText(ci_oid)
			end
			_cichildUI["btnOK"]:setstate(0)
		elseif ui_name == "text2_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",0)
			if ci_opass_len >= 1 then
				ci_opass_len = ci_opass_len - 1
				ci_opass = string.sub(ci_opass,1,ci_opass_len)
				_cichildUI["text2_num"]:setText(ci_opass)
			end
			_cichildUI["btnOK"]:setstate(0)
		elseif ui_name == "text4_button" then
			ci_oscore_len = ci_oscore_len - 1
			ci_oscore = string.sub(ci_oscore,1,ci_oscore_len)
			if ci_oscore_len >= 1 then
				hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			else
				hGlobal.event:event("LocalEvent_set_OKbtnState",0)
			end
			_cichildUI["text4_num"]:setText(ci_oscore)
			_cichildUI["btnOK"]:setstate(0)
		elseif ui_name == "text3_button" then
			ci_ocoin_len = ci_ocoin_len - 1
			ci_ocoin = string.sub(ci_ocoin,1,ci_ocoin_len)
			if ci_ocoin_len >= 1 then
				hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			else
				hGlobal.event:event("LocalEvent_set_OKbtnState",0)
			end
			_cichildUI["text3_num"]:setText(ci_ocoin)
			_cichildUI["btnOK"]:setstate(0)
		elseif ui_name == "coin_button" then
			hGlobal.event:event("LocalEvent_set_OKbtnState",1)
			coin_str_len = coin_str_len - 1
			coin_str = string.sub(coin_str,1,coin_str_len)
			_childUI["coin_info"]:setText(coin_str)
			if coin_str_len >= 1 then
				hGlobal.event:event("LocalEvent_set_OKbtnState",1)
				if new_password_len >= new_password_len_need  then
					_childUI["btnOK"]:setstate(1)
				else
					_childUI["btnOK"]:setstate(0)
				end
			else
				hGlobal.event:event("LocalEvent_set_OKbtnState",0)
				_childUI["btnOK"]:setstate(0)
			end
		end
	end)
end

--申请自动回复存档
hGlobal.UI.InitGetAutoSaveFileFrm = function()
	local _w,_h = 660,460
	
	hGlobal.UI.GetAutoSaveFileFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
	})
	
	local _frm = hGlobal.UI.GetAutoSaveFileFrm
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
	
	--title
	_childUI["title"] = hUI.label:new({
		parent = _parent,
		size = 30,
		text = hVar.tab_string["__TEXT_FileRestore"],
		align = "MC",
		border = 1,
		x = _w/2 - 100,
		y = -40,
	})
	
	_childUI["programm_Uid"] = hUI.label:new({
		parent = _parent,
		size = 28,
		text = tostring(hVar.tab_string["["].."ID:"..tostring(xlPlayer_GetUID())..hVar.tab_string["]"]),
		align = "MC",
		border = 1,
		RGB = {0,255,0},
		x = _w/2 + 100,
		y = -40,
	})
	
	--存档名
	_childUI["s_name_title"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = hVar.tab_string["__TEXT_LastPlayMaster"],
		align = "LT",
		border = 1,
		x = 30,
		y = -78,
	})
	
	--上传时间
	_childUI["s_time_title"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = hVar.tab_string["__TEXT_UpdateTime"],
		align = "LT",
		border = 1,
		x = 30,
		y = -110,
	})
	
	--剩余积分
	_childUI["s_game_score_num"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = hVar.tab_string["__TEXT_PlayOverplusScore"],
		align = "LT",
		border = 1,
		x = 30,
		y = -142,
	})
	
	--存档名 和 更新时间列表
	--存档名称
	_childUI["s_name_1"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = "",
		align = "LT",
		border = 1,
		x = _w/2 + 70,
		y = -80,
	})
	--更新时间
	_childUI["s_time_1"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = "",
		align = "LT",
		border = 1,
		x = 210,
		y = -110,
	})
	
	_childUI["s_game_score_num_val"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = "",
		align = "LT",
		border = 1,
		x = 160,
		y = -142,
	})
	_childUI["infoText"] = hUI.label:new({
		parent = _parent,
		size = 26,
		text = hVar.tab_string["__TEXT_FileRestoreTip"],
		align = "LT",
		border = 1,
		x = 30,
		y = -90,
		width = _w - 40,
	})
	
	--恢复规则
	_childUI["rule_title"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = hVar.tab_string["__TEXT_FileRestoreRuleTitleTip"],
		align = "LT",
		border = 1,
		x = 30,
		y = -300,
		width = _w - 40,
		RGB = {0,255,0},
	})
	
	_childUI["rule_infoText"] = hUI.label:new({
		parent = _parent,
		size = 25,
		text = hVar.tab_string["__TEXT_FileRestoreRuleTip"],
		align = "LT",
		border = 1,
		x = 30,
		y = -330,
		width = _w - 40,
		RGB = {0,255,0},
	})
	
	local _dataList = {}
	local _log_id = 0
	local _log_dic = 0
	local _frmState,_tempRid = 0,0
	local _showFrm = function(mode,modeEx,log_time)
		--print("_showFrm", mode,modeEx,log_time)
		_childUI["rule_title"].handle._n:setVisible(false)
		_childUI["rule_infoText"].handle._n:setVisible(false)
		_childUI["btnOK"]:setstate(-1)
		_childUI["btnCancel"]:setstate(-1)
		_childUI["btnOK_end"]:setstate(-1)
		_childUI["btnOK_2"]:setstate(-1)
		_childUI["s_name_title"].handle._n:setVisible(false)
		_childUI["s_time_title"].handle._n:setVisible(false)
		_childUI["infoText"].handle._n:setVisible(false)
		_childUI["s_name_1"].handle._n:setVisible(false)
		_childUI["s_time_1"].handle._n:setVisible(false)
		_childUI["s_game_score_num"].handle._n:setVisible(false)
		_childUI["s_game_score_num_val"].handle._n:setVisible(false)
		_frmState = mode
		if mode == 1 then
			_childUI["btnOK"]:setstate(1)
			_childUI["btnCancel"]:setstate(1)
			if modeEx == nil then
				_childUI["infoText"]:setText(hVar.tab_string["__TEXT_FileRestoreTipFirst"])
				_childUI["infoText"].handle._n:setVisible(true)
			else
				_tempRid = modeEx
				_childUI["infoText"]:setText(hVar.tab_string["__TEXT_FileRestoreTipFirstCheck"])
				_childUI["infoText"].handle._n:setVisible(true)
				_childUI["rule_title"].handle._n:setVisible(true)
				_childUI["rule_infoText"]:setText(hVar.tab_string["__TEXT_FileRestoreRuleTip"])
				_childUI["rule_infoText"].handle._n:setVisible(true)
			end
			
		elseif mode == 2 then
			_childUI["btnOK_2"]:setstate(1)
			_childUI["btnOK_end"]:setText(hVar.tab_string["__Text_GiveUp"])
			_childUI["btnOK_end"]:setstate(1)
			_childUI["s_name_title"].handle._n:setVisible(true)
			_childUI["s_time_title"].handle._n:setVisible(true)
			_childUI["s_game_score_num"].handle._n:setVisible(true)
			_childUI["s_name_1"].handle._n:setVisible(true)
			_childUI["s_time_1"].handle._n:setVisible(true)
			_childUI["s_game_score_num_val"].handle._n:setVisible(true)
			if modeEx ~= nil then
				_tempRid = modeEx
			end
		elseif mode == 3 then
			_childUI["btnOK_end"]:setText(hVar.tab_string["__Text_Exit"])
			_childUI["btnOK_end"]:setstate(1)
			_childUI["infoText"]:setText(hVar.tab_string["__TEXT_FileRestoreTipEnd"])
			_childUI["infoText"].handle._n:setVisible(true)
		elseif mode == 4 then
			_childUI["btnOK_end"]:setText(hVar.tab_string["__Text_Exit"])
			_childUI["btnOK_end"]:setstate(1)
			_childUI["infoText"]:setText(hVar.tab_string["__TEXT_FileRestoreTipEnd1"])
			_childUI["infoText"].handle._n:setVisible(true)
		end
	end
	
	--申请在此设备上恢复数据
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_SendSaveFileBack"],
		x = _w/2,
		y = -_h/2 + 30,
		w = 480,
		h = 50,
		scaleT = 0.95,
		model = -1,
		code = function(self)
			--检测本地版本是否是最新
			--...
			
			self:setstate(0)
			local rid = luaGetplayerDataID()
			if _tempRid ~= 0 then
				rid = _tempRid
			end
			
			if _frmState == 1 then
				SendCmdFunc["make_autoSave_log"](rid)
			end
		end,
	})
	_childUI["btnOK"].childUI["Selectedbox"] = hUI.bar:new({
		parent = _childUI["btnOK"].handle._n,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 420,
		h = 50,
		z = 1,
	})
	
	--不用了,谢谢
	_childUI["btnCancel"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_SendSaveFileBackNo"],
		x = _w/2 - 10,
		y = -_h/2 - 40,
		w = 280,
		h = 50,
		scaleT = 0.95,
		model = -1,
		code = function()
			_frm:show(0)
			
			if (g_curPlayerName == nil) then
				--xlSetPlayerInfo(1)
				hApi.xlSetPlayerInfo(1)
			end
		end,
	})
	_childUI["btnCancel"].childUI["Selectedbox"] = hUI.bar:new({
		parent = _childUI["btnCancel"].handle._n,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 220,
		h = 50,
		z = 1,
	})
	
	--放弃 或者 离开 
	_childUI["btnOK_end"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__Text_Exit"],
		x = _w/2 - 6,
		y = -_h/2 - 100,
		w = 160,
		h = 50,
		scaleT = 0.95,
		model = -1,
		code = function(self)
			self:setstate(0)
			_frm:show(0)
			if _frmState == 2 then
				SendCmdFunc["set_autoSave_status"](_log_id,3)
			end
			
			if g_curPlayerName == nil then
				hApi.xlSetPlayerInfo(1)
			end
		end,
	})
	
	_childUI["btnOK_end"].childUI["Selectedbox"] = hUI.bar:new({
		parent = _childUI["btnOK_end"].handle._n,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 140,
		h = 50,
		z = 1,
	})
	
	--确认恢复
	_childUI["btnOK_2"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__Text_SaveFileBackOK"],
		x = _w/2 - 6,
		y = -_h/2 - 20,
		w = 160,
		h = 50,
		scaleT = 0.95,
		model = -1,
		code = function(self)
			self:setstate(0)
			_frm:show(0)
			
			if _frmState == 2 then
				SendCmdFunc["set_autoSave_status"](_log_id,2)
				SendCmdFunc["get_DBSaveFileByRid"](luaGetplayerDataID(),nil,_log_id,_log_dic)
				hUI.NetDisable(3000)
				
				--冒字
				local strText = "正在恢复存档中..." --language
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
			end
		end,
	})
	
	_childUI["btnOK_2"].childUI["Selectedbox"] = hUI.bar:new({
		parent = _childUI["btnOK_2"].handle._n,
		model = "UI:PHOTO_FRAME_BAR",
		align = "MC",
		w = 140,
		h = 50,
		z = 1,
	})
	
	
	hGlobal.event:listen("LocalEvent_Get_Auto_Save_File","setBtnState",function(log_state,log_id,roleid,log_time)
		_frm:show(1)
		_frm:active()
		
		--紧接着发起最近存档列表的查询
		_log_id = log_id
		if log_state == 0 then
			--SendCmdFunc["get_DBSaveFileList"](roleid,log_id)
			if Save_playerList then
				_childUI["s_name_1"]:setText(Save_playerList.SaveBackName)
				_childUI["s_time_1"]:setText(Save_playerList.SaveBackTime)
				_childUI["s_game_score_num_val"]:setText(Save_playerList.SaveBackGameScore)
				hGlobal.event:event("LocalEvent_SetAutoSaveFileList",file_list,itag,roleid)
				_log_dic = Save_playerList.SaveBackRid
				_showFrm(2,Save_playerList.SaveBackRid)
			end
		elseif log_state == -1 then
			_frm:show(0)
			hGlobal.UI.MsgBox("DB haven't save file",{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif log_state == 4 then
			_showFrm(3,nil,log_time)
		elseif log_state == 5 then
			_showFrm(4)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_ShowGetAutoSaveFileFrm","showthisfrm",function(modeEx)
		_log_dic = 0
		_log_id = 0
		_dataList = {}
		_tempRid = 0
		_showFrm(1,modeEx)
		_frm:show(1)
		_frm:active()
		LuaSetLastSaveBackFrmTime(tonumber(os.date("%m%d%H%M%S")))
	end)
	
	--hGlobal.event:listen("LocalEvent_ShowGetAutoSaveFileFrmEx","showthisfrm",function(mode,modeEx)
		--_log_dic = 0
		--_log_id = 0
		--_dataList = {}
		--_tempRid = 0
		--_showFrm(mode,modeEx)
		--_frm:show(1)
		--_frm:active()
	--end)

	hGlobal.event:listen("LocalEvent_CloseGetAutoSaveFileFrmEx","showthisfrm",function()
		_frm:show(0)
	end)

	local photoPath = g_localfilepath
	local photoPathFromDocuments = "save/local"
	local getPhotoPath = ""
	local griffin_test = nil
	local s1,v1,s2,v2 = nil,nil,nil,nil
	
	local photofrmW,photofrmH = 460,330
	
	hGlobal.UI.photofrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - photofrmW/2,
		y = hVar.SCREEN.h/2 + photofrmH/2,
		w = photofrmW,
		h = photofrmH,
		dragable = 2,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = photofrmW - 14,
		closebtnY = -14,
	})
	
	local _photofrm = hGlobal.UI.photofrm
	local _photoparent = _photofrm.handle._n
	local _photochildUI = _photofrm.childUI
	local post_photo_time = 60000
	local post_photo_index = 3
	local n_post_photo_time = -60000
	local n_post_photo_index = 0
	
	hGlobal.event:listen("LocalEvent_showphotofrm","__photofrm",function(isShow)
		_photofrm:show(isShow)
		if isShow == 1 then
			_photofrm:active()
			if s1 == nil then
				local svfp = photoPath.."sv.data"
				if hApi.FileExists(svfp,"full") then
					local f = io.open(svfp,"r")
					if f then
						s1 = 0
						v1 = tonumber(f:read("*l"))
						s2 = 0
						v2 = tonumber(f:read("*l"))
						f:close()
					else
						s1 = 0
						v1 = 0
						s2 = 0
						v2 = 0
						f = io.open(svfp,"w")
						f:write("0\n0")
						f:close()
					end
				else
					s1 = 0
					v1 = 0
					s2 = 0
					v2 = 0
					f = io.open(svfp,"w")
					f:write("0\n0")
					f:close()
				end
				
				local tpp = photoPath..xlPlayer_GetUID().."_photo_temp.png"
				
				if hApi.FileExists(tpp,"full") then
					if griffin_test ~= nil then
						local texture2 = griffin_test:getTexture()
						CCTextureCache:sharedTextureCache():removeTexture(texture2)
						local texture1 = CCTextureCache:sharedTextureCache():addImage(tpp)
						griffin_test:setTexture(texture1)
					else
						griffin_test = CCSprite:create(tpp)
						local sSize = griffin_test:getContentSize()
						griffin_test:setScaleX(128/sSize.width)
						griffin_test:setScaleY(128/sSize.height)
						griffin_test:setPosition(ccp(110,-110))
						_photofrm.handle._n:addChild(griffin_test)
					end
				end
			end
			SendCmdFunc["get_photo_state"](0,{xlPlayer_GetUID()})
			
			--hGlobal.UI.MsgBox(string.format("get_photo_state:%d",xlPlayer_GetUID()),{
			--		font = hVar.FONTC,
			--		ok = function()
			--		end,
			--	})
		end
	end)
	
	
	hGlobal.event:event("LocalEvent_showphotofrm",0)
	
	_photochildUI["headbg"] = hUI.image:new({
		parent = _photoparent,
		model = "UI:Photo_back",
		x = 110,
		y = -110,
		--w = 130,
		--h = 130,
	})

	_photochildUI["not_ready"] = hUI.label:new({
		parent = _photoparent,
		size = 24,
		text = "",
		align = "LT",
		border = 1,
		x = 80,
		y = -190,
	})

	--_photochildUI["not_ready1"] = hUI.label:new({
		--parent = _photoparent,
		--size = 24,
		--text = hVar.tab_string["Auditing"],
		--align = "LT",
		--border = 1,
		--x = 80,
		--y = -190,
	--})

	_photochildUI["info"] = hUI.label:new({
		parent = _photoparent,
		size = 20,
		text = hVar.tab_string["Auditing_Info"],
		align = "LT",
		border = 1,
		width = 400,
		x = 30,
		y = -240,
		RGB = {0,255,0},
		font = hVar.FONTC,
	})

	_photochildUI["fromLocal"] = hUI.button:new({
		parent = _photoparent,
		model = "UI:ButtonBack",
		icon = "UI:LocalPhoto",
		iconWH = 30,
		label = {text = hVar.tab_string["local_photo"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _photofrm.childUI["dragBox"],
		x = 320,
		y = -64,
		scaleT = 0.9,
		code = function()
			--hGlobal.event:event("LocalEvent_showphotofrm",1)
			if xlOpenLocalPhoto then
				local ct = hApi.gametime()
				if ct - n_post_photo_time >= post_photo_time then
					n_post_photo_index = 0
					xlOpenLocalPhoto(xlPlayer_GetUID().."_photo_send",128,128,photoPathFromDocuments)
					--n_post_photo_time = ct
				else
					if n_post_photo_index >= post_photo_index then
						hGlobal.UI.MsgBox(hVar.tab_string["photo2usual"],{
							font = hVar.FONTC,
							ok = function()
							end,
						})
					else
						xlOpenLocalPhoto(xlPlayer_GetUID().."_photo_send",128,128,photoPathFromDocuments)
						--n_post_photo_time = ct
					end
				end
			end
		end,
	})

	_photochildUI["fromCamera"] = hUI.button:new({
		parent = _photoparent,
		model = "UI:ButtonBack",
		icon = "UI:TakePhoto",
		iconWH = 30,
		label = {text = hVar.tab_string["camera_photo"],size = 28,font = hVar.FONTC,border = 1},
		dragbox = _photofrm.childUI["dragBox"],
		x = 320,
		y = -156,
		scaleT = 0.9,
		code = function()
			--hGlobal.event:event("LocalEvent_showphotofrm",1)
			if xlOpenCamera then
				local ct = hApi.gametime()
				if ct - n_post_photo_time >= post_photo_time then
					n_post_photo_index = 0
					xlOpenCamera(xlPlayer_GetUID().."_photo_send",128,128,photoPathFromDocuments)
					--n_post_photo_time = ct
				else
					if n_post_photo_index >= post_photo_index then
						hGlobal.UI.MsgBox(hVar.tab_string["photo2usual"],{
							font = hVar.FONTC,
							ok = function()
							end,
						})
					else
						xlOpenCamera(xlPlayer_GetUID().."_photo_send",128,128,photoPathFromDocuments)
						--n_post_photo_time = ct
					end
				end
			end
		end,
	})
	
	hGlobal.event:listen("LocalEvent_getSelfPhotoStateAndVersion","__photofrm",function(ss1,vv1,ss2,vv2)
		
		--hGlobal.UI.MsgBox(string.format("LocalEvent_getSelfPhotoStateAndVersion:%d,%d,%d,%d",ss1,vv1,ss2,vv2),{
		--			font = hVar.FONTC,
		--			ok = function()
		--			end,
		--		})
		
		
		s1 = ss1
		s2 = ss2
		if s1 == 1 then
			_photochildUI["not_ready"]:setText(hVar.tab_string["Auditing"])
		else
			_photochildUI["not_ready"]:setText("")
		end
		
		local svfp = photoPath.."sv.data"
		local f = io.open(svfp,"w")
		f:write(""..vv1.."\n"..vv2)
		f:close()
		
		hGlobal.UI.MsgBox(string.format("check can get photo:%d,%s",vv1,tostring(v1)),{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				
		if vv1 > v1 then
			--请求最新的图片
			SendCmdFunc["HTTP_get_photo"](xlPlayer_GetUID(),1)
		end
		v1 = vv1
		v2 = vv2
	end)
	
	local sendPath = nil
	--相机或相册处理完的必须回掉 把图片保存的绝对路径通知到脚本
	hGlobal.event:listen("LocalEvent_PhotoOK","PhotoOK",function(str1,str2)
		--hGlobal.UI.MsgBox(string.format("LocalEvent_PhotoOK str1:%s str2:%s ",str1,str2),{
		--			font = hVar.FONTC,
		--			ok = function()
		--			end,
		--		})
		--print(str)
		--xlLG("photo",str)
		photoPath = str1
		local filePath = str1.."/"..str2
		sendPath = filePath
		str2 = string.gsub(str2,"send","temp")
		SendCmdFunc["HTTP_post_photo"](xlPlayer_GetUID(),1,sendPath)
		getPhotoPath = str1.."/"..str2 
		n_post_photo_index = n_post_photo_index + 1
		local ct = hApi.gametime()
		n_post_photo_time = ct
	end)

	function callback_httpresponse(sTag,iCode,sError,sData,iDataLen)
		print("callback_httpresponse",sTag)
		--hGlobal.UI.MsgBox(string.format("callback_httpresponse tag:%s code:%d error:%s datalen:%d",sTag,iCode,sError,iDataLen),{
		--			font = hVar.FONTC,
		--			ok = function()
		--			end,
		--		})
		--print(string.format("callback_httpresponse tag:%s code:%d error:%s datalen:%d",sTag,iCode,sError,iDataLen))
		if sTag == "post_head" then
			
			--xlHttpClient_Get(sGetUrl,"get_head")
			if sendPath then
				local f = io.open(sendPath,"r")
				local photo = nil
				if f then
					photo = f:read("*a")
					f:close()
				else
					return
				end
				if photo then
					f = io.open(getPhotoPath,"wb")
					if f then
					    f:write(tostring(photo))
					    f:close()
					else
						return
					end
				else
					return
				end
			else
				return
			end
			
			_photochildUI["not_ready"]:setText(hVar.tab_string["Auditing"])
			
			if griffin_test ~= nil then
				local texture2 = griffin_test:getTexture()
				CCTextureCache:sharedTextureCache():removeTexture(texture2)
				local texture1 = CCTextureCache:sharedTextureCache():addImage(getPhotoPath)
				griffin_test:setTexture(texture1)
			else
				griffin_test = CCSprite:create(getPhotoPath)
				local sSize = griffin_test:getContentSize()
				griffin_test:setScaleX(128/sSize.width)
				griffin_test:setScaleY(128/sSize.height)
				griffin_test:setPosition(ccp(110,-110))
				_photofrm.handle._n:addChild(griffin_test)
			end
			SendCmdFunc["get_photo_state"](0,{xlPlayer_GetUID()})
		elseif sTag == "get_head" then
			if "ok" == sError and 0 < iDataLen then
				local path = photoPath..xlPlayer_GetUID().."_photo_temp.png"
				local f = io.open(path,"wb")
				if f then
				    f:write(sData,iDataLen)
				    f:close()
				end
				
				if griffin_test ~= nil then
					local texture2 = griffin_test:getTexture()
					CCTextureCache:sharedTextureCache():removeTexture(texture2)
					local texture1 = CCTextureCache:sharedTextureCache():addImage(path)
					griffin_test:setTexture(texture1)
				else
					griffin_test = CCSprite:create(path)
					local sSize = griffin_test:getContentSize()
					griffin_test:setScaleX(128/sSize.width)
					griffin_test:setScaleY(128/sSize.height)
					griffin_test:setPosition(ccp(110,-110))
					_photofrm.handle._n:addChild(griffin_test)
				end
			end
		elseif sTag == "phone" then
			local tab = hApi.json2table(sData)
			local str = "sData:"..type(tab)
			if type(tab) == "table" then
				table_print(tab)
				local errcode = tonumber(tab.code)
				local value = tostring(tab.pn)
				str = str .. " errcode:"..tostring(errcode).." value:"..tostring(value)
				print(type(errcode))
				print(type(value),string.len(value))
				if errcode == 0 then
					hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","phone","uid",value)
				end
			end
			--[[
			hGlobal.UI.MsgBox(str, {
				font = hVar.FONTC,
				ok = function()
					
				end,
			})
			--]]
		elseif sTag == "announcement" then
			--print("11111",iCode,sError,sData)
			if "number" == type(iCode) and 200 == iCode and "string" == type(sError) and "ok" == sError and "string" == type(sData) then
				--先清理
				g_AnnouncementConfig = nil
				--print(sData)
				local f = loadstring(sData)
				--print(type(f))
				if type(f) == "function" then
					--print("function")
					f()
				end

				if g_AnnouncementTest == 1 then
					--GM测试公告流程
					if type(g_AnnouncementConfig) == "table" and type(g_AnnouncementConfig.info) == "table" then
						hGlobal.event:event("LocalEvent_showAnnouncementFrm",g_AnnouncementConfig.info)
					else
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2 + 20,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext("Announcement Err", hVar.FONTC, 32, "MC", 0, 0,nil,1)
					end
				else
					--登录前公告流程
					--清理自动获取公告计时器
					hApi.clearTimer("AutoRequestAnnouncement")
					hGlobal.event:event("LocalEvent_CheckShowAnnouncementFrm")
				end
			end
		end
	end
end

--存档转出提示信息
hGlobal.UI.InitSaveDataCheckOutOkFrm = function()
	--窗口
	hGlobal.UI.SaveDataCheckOutOkFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 290,
		y = hVar.SCREEN.h/2 + 220,
		z = 100001,
		dragable = 2,
		w = 580,
		h = 430,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		border = 1,
		autoactive = 0,
	})

	local _frm = hGlobal.UI.SaveDataCheckOutOkFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local gamecoin = 0

	--title
	_childUI["title"] =  hUI.label:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = -34,
		text = hVar.tab_string["__TEXT_Player_DeleteAllTitle"],
		--text = title,
		RGB = {0,255,0},
		size = 34,
		--width = tipFrm.data.w-64,
		width = _frm.data.w,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	--提示文字1
	_childUI["tipLab"] =  hUI.label:new({
		parent = _parent,
		x = 30,
		y = -80,
		text = hVar.tab_string["__TEXT_Player_DeleteAll"],
		size = 26,
		width = _frm.data.w-55,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})

	--提示文字2
	_childUI["tipLab1"] =  hUI.label:new({
		parent = _parent,
		x = 30,
		y = -160,
		text = hVar.tab_string["__TEXT_Player_DeleteAll1"],
		size = 26,
		width = _frm.data.w-55,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})

	--提示文字2
	_childUI["tipLab2"] =  hUI.label:new({
		parent = _parent,
		x = 30,
		y = -210,
		text = hVar.tab_string["old_id"].. ":" .. xlPlayer_GetUID(),
		size = 26,
		width = _frm.data.w-55,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})

	--提示文字3
	_childUI["tipLab3"] =  hUI.label:new({
		parent = _parent,
		x = 30,
		y = -240,
		text = hVar.tab_string["__TEXT_ShiftDataTipCoin"].. tostring(gamecoin),
		size = 26,
		width = _frm.data.w-55,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	
	
	--确定按钮
	_childUI["confirmBtn"] =  hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		label = hVar.tab_string["Exit_Ack"],
		x = _frm.data.w/2,
		y = -_frm.data.h + 90,
		scaleT = 0.9,
		code = function(self)
			--保存当前屏幕信息
			if xlCaptureScreenAlbum then
				xlCaptureScreenAlbum()
			end
			
			self:setstate(0)
						
			--等待后几帧再截屏
			hApi.addTimerOnce("xlCaptureScreenAlbum",1000,function()
				--保存当前屏幕信息
				--if xlCaptureScreenAlbum then
				--	xlCaptureScreenAlbum()
				--end
				_frm:show(0)
				--退出游戏
				xlExit()
			end)
		end,
	})

	--提示文字4
	_childUI["tipLab4"] =  hUI.label:new({
		parent = _parent,
		x = _frm.data.w * 0.5,
		y = -_frm.data.h + 40,
		text = hVar.tab_string["__TEXT_Player_DeleteAll2"],
		RGB = {255,255,0},
		size = 26,
		width = _frm.data.w-55,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	--刷新游戏币
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","CheckOutInfoFrmCurGameCoin",function(cur_rmb)
		_childUI["tipLab3"]:setText(hVar.tab_string["__TEXT_ShiftDataTipCoin"].. tostring(cur_rmb))
	end)
	
	hGlobal.event:listen("LocalEvent_ShowCheckOutOkFrm","showthisfrm",function()
		_frm:show(1)
		_frm:active()
	end)
end