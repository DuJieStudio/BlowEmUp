
g_ReviewTestInfo = {
	idcard = "310104200303030033",			--填""为默认流程  填数据为了方便测后续流程
	name = "soldier",				--填""为默认流程  填数据为了方便测后续流程
	logintotalday = 0,		--填0 进入实名流程  填天数 则认为已经实名过了 直接获取累计时间判断
	bindtotalday = math.floor(365*19),		--实名时自动上传得存活天数  不跟着身份证走
	todayTime = 105,				--今日累计游戏时间
	serverdate = "2022-08-16-14-59-30"		--服务器时间  方便判断是否到了22点还能进入游戏
}


g_ReviewInfo = {
	name = "",			--姓名
	idcard = "",			--身份证
}

hApi.IsReviewMode = function()
	--内网测试
	if g_lua_src == 1 and hVar.ReviewMode == 1 then
		return true
	end
	return false
end

local code_CalculayeAge = function(nTotalDay)
	return math.floor(nTotalDay/365)
end

if type(xlRealNameCheckId) ~= "function" then
	xlRealNameCheckId = function(_,_,_,op)
		if op == 1 then
			xlLuaEvent_RealName_CheckId(1,2)
			--xlLuaEvent_RealName_CheckId(1,1)
			--xlLuaEvent_RealName_CheckId(1,0,"11111111111111111111111111111111111111")
		else
			--                              0         1         2         3
			xlLuaEvent_RealName_CheckId(0,0,"11111111111111111111111111111111111111")
			--xlLuaEvent_RealName_CheckId(0,1010,"111111111111111111111111111111")
			--xlLuaEvent_RealName_CheckId(0,999)
		end
	end
end

local monthcheck = {
	[1] = 31,
	[2] = 28,
	[3] = 31,
	[4] = 30,
	[5] = 31,
	[6] = 30,
	[7] = 31,
	[8] = 31,
	[9] = 30,
	[10] = 31,
	[11] = 30,
	[12] = 31,
}

xlLuaEvent_CheckPlayerYear = function(idcard)
	local errorcode = 0

	if string.len(idcard) ~= 18 then
		errorcode = 2
	else
		local startyear = 2020--防止越界
		local sbirthday = string.sub(idcard,7,14)
		local nowTime = os.time()
		local year = string.sub(sbirthday,1,4)
		local month = string.sub(sbirthday,5,6)
		local day = string.sub(sbirthday,7,8)
		local birthTime = os.time({year = startyear,month = month,day = day,})
		--print(birthTime,nowTime,math.ceil((nowTime-birthTime)/(60 * 60 * 24))+(startyear-tonumber(year)) * 365,365 * 18)
		if tonumber(year) > 2005 then
			errorcode = 1	--未成年
		elseif tonumber(year) > 1920 and monthcheck[tonumber(month)] and 
		       (tonumber(day) <= monthcheck[tonumber(month)] or (tonumber(month) == 2 and tonumber(year)%4==0 and tonumber(day) == monthcheck[tonumber(month)] + 1)) then
			local totalday = math.ceil((nowTime-birthTime)/(60 * 60 * 24))+(startyear-tonumber(year)) * 365
			print(idcard,totalday,365 * 18,math.ceil((nowTime-birthTime)/(60 * 60 * 24)),(startyear-tonumber(year))* 365)
			if totalday < 365 * 18 then
				errorcode = 1	--未成年
			end
		else
			errorcode = 2	--身份证错误
		end
	end
	if errorcode == 2 then
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2500,
			fadeout = -550,
			--moveY = 32,
		}):addtext(hVar.tab_string["realnamecheck_err20010"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
	elseif errorcode == 1 then
		hGlobal.UI.MsgBox(hVar.tab_string["realname_4"],{
			font = hVar.FONTC,
			textAlign = "LC",
			ok = {hVar.tab_string["Exit_Now"],function()
				xlExit()
			end},
		})
	elseif errorcode == 99 then
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2500,
			fadeout = -550,
			--moveY = 32,
		}):addtext(hVar.tab_string["realnamecheck_err2001"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
	end
	return errorcode
end

xlLuaEvent_RealName_CheckId = function(op,err,spi)
	if op == 0 then
		hUI.NetDisable(0)
		hGlobal.event:event("LocalEvent_RealNameCheckId_cb",err)
		local text = hVar.tab_string["realnamecheck_err"..err]
		if err == 0 or err == 1 then
			--从身份证信息获取出年月日 截取出生年月日 发给服务器绑定
			local sbirthday = ""
			if string.len(g_ReviewInfo.idcard) == 18 then
				sbirthday = string.sub(g_ReviewInfo.idcard,7,14)
			end

			LuaAddBehaviorID(hVar.PlayerBehaviorList[20002])
			hUI.NetDisable(10000)
			if hVar.RealNameMode == 1 then
				print(g_ReviewTestInfo.bindtotalday)
				GluaNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO_RES](0,0,g_ReviewTestInfo.bindtotalday)
			else
				print("hVar.ONLINECMD.BIND_REALNAMEINFO",g_ReviewInfo.idcard,g_ReviewInfo.name,sbirthday)
				GluaSendNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO](tonumber(sbirthday),g_ReviewInfo.idcard,g_ReviewInfo.name,spi)
			end
		elseif err == 1010 then
			hGlobal.UI.MsgBox(hVar.tab_string["realnamecheck_errcode"]..err,{
				font = hVar.FONTC,
				ok = function()
					--记录本地标记 下次不弹框
					--判断设备
					local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
					--IOS
					if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
						xlSaveIntToKeyChain("realname1010",1)
					--windows
					else
						CCUserDefault:sharedUserDefault():setIntegerForKey("realname1010",1)
						CCUserDefault:sharedUserDefault():flush()
					end
					
					hGlobal.event:event("LocalEvent_CloseRealNameFrm")
					hGlobal.event:event("LocalEvent_OnReviewlogin")
				end,
			})
			return
		elseif err == 2001 then
			--弹漂浮文字
		else
			--其余的直接弹框 显示错误码
			hGlobal.UI.MsgBox(hVar.tab_string["realnamecheck_errcode"]..err,{
				font = hVar.FONTC,
				ok = function()
					
				end,
			})
			return
		end
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2500,
			fadeout = -550,
			--moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "MC", 0, 0,nil,1)
	elseif op == 1 then
		--依旧审核中
		if err == 1 then
			--审核模式的登陆回调
			local nResult = hApi.CheckPlayerAge(g_ReviewInfo.totalday)
			--如果检测为1 说明不受限制 直接登录
			if nResult == 1 then
				--审核模式的登陆回调
				hGlobal.event:event("LocalEvent_OnReviewlogin")
			end
		--审核通过
		elseif err == 0 then
			local sbirthday = ""
			if string.len(g_ReviewInfo.idcard) == 18 then
				sbirthday = string.sub(g_ReviewInfo.idcard,7,14)
			end
			GluaSendNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO](tonumber(sbirthday),g_ReviewInfo.idcard,g_ReviewInfo.name,spi)
		--审核失败
		else
			--重置实名
			GluaSendNetCmd[hVar.ONLINECMD.REQUEST_CLEARREALNAME]()
			hGlobal.UI.MsgBox(hVar.tab_string["realnamecheck_errcode"]..err,{
				font = hVar.FONTC,
				ok = function()
					--实名界面
					hGlobal.event:event("LocalEvent_ShowFillInRealNameFrm")
				end,
			})
		end
	end
end

--检测玩家年龄
hApi.CheckPlayerAge = function(nTotalDay)
	local nResult = 1
	--实名验证
	hGlobal.event:event("LocalEvent_CloseRealNameFrm")
	local age = code_CalculayeAge(nTotalDay)
	print("age",age)
	if age >= 18 then
		--成年人
		nResult = 1
	else
		nResult = 0
		--未成年(统一最低标准)
		--获取当日游戏总时长
		--[[
		if hVar.RealNameMode == 1 then
			GluaNetCmd[hVar.ONLINECMD.REQUEST_PLAYTIME_RES](0,0,0,g_ReviewTestInfo.todayTime,g_ReviewTestInfo.serverdate)
		else
			GluaSendNetCmd[hVar.ONLINECMD.REQUEST_PLAYTIME]()
		end
		--]]
		--新规后 禁止未成年人游玩
		hGlobal.UI.MsgBox(hVar.tab_string["realname_4"],{
			font = hVar.FONTC,
			textAlign = "LC",
			ok = {hVar.tab_string["Exit_Now"],function()
				xlExit()
			end},
		})
	end
	return nResult
end

hApi.CheckPlayerRealNameStage = function(uid,nTotalDay,nPi_state,sId_card,sId_name)
	local nResult = 1
	--判断是否进入实名审核
	if xlRealNameCheckMode() then
		--未实名
		if nTotalDay == 0 then
			local realname1010 = 0
			--判断设备
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
				realname1010 = xlGetIntFromKeyChain("realname1010")
			--windows
			else
				realname1010 = CCUserDefault:sharedUserDefault():getIntegerForKey("realname1010")
			end
			if realname1010 == 1 then
				--1010特殊处理
			else
				nResult = 0
				--如果获得的数据等于0  那用户还未进行实名需要弹出实名界面
				hGlobal.event:event("LocalEvent_ShowFillInRealNameFrm")
			end
		--审核中
		elseif nPi_state == 0 then
			nResult = 0
			g_ReviewInfo.name = sId_name
			g_ReviewInfo.idcard = sId_card
			g_ReviewInfo.totalday = nTotalDay
			--需要查询
			xlRealNameCheckId(sId_card,sId_name,uid,1)
		--实名完成
		else
			--通过实名 进入检测年龄阶段
			nResult = hApi.CheckPlayerAge(nTotalDay)
		end
	end
	return nResult
end

hApi.ShowTimeLimitFrm = function()
	if hGlobal.UI.TimeLimitFrmFrm then
		hGlobal.UI.TimeLimitFrmFrm:del()
		hGlobal.UI.TimeLimitFrmFrm = nil
	end
	local WIDTH = 640
	local HEIGHT = 440
	hGlobal.UI.TimeLimitFrmFrm = hUI.frame:new({
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

	local _frm = hGlobal.UI.TimeLimitFrmFrm
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

	_childUI["lab_title"] = hUI.label:new({
		parent = _parent,
		x = offX - WIDTH / 2 + 48,
		y = offY+ HEIGHT / 2 - 60,
		width = WIDTH - 40 * 2,
		align = "LT",
		size = 26,
		border = 0,
		font = hVar.FONTC,
		text = hVar.tab_string["realname_2"],
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
			xlExit()
		end,
	})

	_frm:show(1)
	_frm:active()
end

hGlobal.event:listen("LocalEvent_OnReviewlogin","_OnReviewlogin", function()
	hGlobal.event:event("LocalEvent_EnterGame")
end)