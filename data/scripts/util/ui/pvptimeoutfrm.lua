hGlobal.UI.InitBFTeamNameFrm = function(mode)
	if mode~="include" then
		hGlobal.event:listen("Event_BattlefieldStart","__LNF__ShowBFTeamName",function(oWorld)
			if oWorld.data.IsQuickBattlefield~=1 and type(oWorld.data.BFTeamName)=="table" then
				hGlobal.event:listen("Event_BattlefieldStart","__LNF__ShowBFTeamName",nil)
				hGlobal.event:listen("LocalEvent_ShowBFTeamNameFrm","__LNF__ShowBFTeamName",nil)
				hGlobal.UI.include("InitBFTeamNameFrm")
				local pFunc = hGlobal.event:getfunc("Event_BattlefieldStart","__LNF__ShowBFTeamName")
				if type(pFunc)=="function" then
					return pFunc(oWorld)
				end
			end
		end)
		hGlobal.event:listen("LocalEvent_ShowBFTeamNameFrm","__LNF__ShowBFTeamName",function(oWorld)
			if oWorld.data.IsQuickBattlefield~=1 and type(oWorld.data.BFTeamName)=="table" then
				hGlobal.event:listen("Event_BattlefieldStart","__LNF__ShowBFTeamName",nil)
				hGlobal.event:listen("LocalEvent_ShowBFTeamNameFrm","__LNF__ShowBFTeamName",nil)
				hGlobal.UI.include("InitBFTeamNameFrm")
				local pFunc = hGlobal.event:getfunc("LocalEvent_ShowBFTeamNameFrm","__LNF__ShowBFTeamName")
				if type(pFunc)=="function" then
					return pFunc(oWorld)
				end
			end
		end)
		return hVar.RESULT_FAIL
	end

	local _LNF_TimeLeft = 0
	local _LNF_UIHandle = {}
	local _LNF_UIList = {
		{"image","myBG","ui/pvp/pvptimeoutbg1.png",{0,0,-1,-1}},
		{"image","oppBG","ui/pvp/pvptimeoutbg2.png",{0,0,-1,-1}},
		{"labelX","labTimeOut","0",{0,-52,24,0,"MC","numWhite"}},
		{"labelX","labName","",{0,-16,28,1,"MC",hVar.FONTC}},
	}
	hGlobal.UI.BFTeamNameFrm = hUI.frame:new({
		dragable = -1,
		background = -1,
		x = hVar.SCREEN.w/2,
		y = hVar.SCREEN.h,
		w = 0,
		h = 0,
		show = 0,
	})
	local _FrmBG = hGlobal.UI.BFTeamNameFrm
	local _childUI = _FrmBG.childUI
	hUI.CreateMultiUIByParam(_FrmBG.handle._n,0,0,_LNF_UIList,_LNF_UIHandle)
	for i = 1,#_LNF_UIList do
		local k = _LNF_UIList[i][2]
		if type(_LNF_UIHandle[k])=="table" then
			_childUI[k] = _LNF_UIHandle[k]
		end
	end
	_LNF_UIHandle["myBG"]:setAnchorPoint(ccp(0.5,1))
	_LNF_UIHandle["oppBG"]:setAnchorPoint(ccp(0.5,1))
	local _TimeOutErrCount = 0
	local _loop_UpdateTimeOut = function()
		_LNF_TimeLeft = _LNF_TimeLeft - 1
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.data.IsPaused==0 and _LNF_TimeLeft>=0 then
			_TimeOutErrCount = 2
			_LNF_UIHandle["labTimeOut"]:setText(tostring(_LNF_TimeLeft),2)
			if _LNF_TimeLeft==9 then
				_LNF_UIHandle["labTimeOut"].handle.s:setColor(ccc3(230,0,0))
			end
			if _LNF_TimeLeft<=9 then
				_LNF_UIHandle["labTimeOut"].handle._n:runAction(CCJumpTo:create(0.1,ccp(0,-56),3,1))
			end
		else
			local oWorld = hGlobal.LocalPlayer:getfocusworld()
			if oWorld and oWorld.data.PausedByWhat==0 and type(oWorld.data.netdata)=="table" and type(oWorld.data.netdata.netstate)=="table" then
				if _LNF_TimeLeft<=-5 then
					local sTip
					local tMyState = oWorld.data.netdata.netstate[1]
					local tOppState = oWorld.data.netdata.netstate[2]
					if #tMyState>=5 and #tOppState>=5 then
						--在线的情况
						_TimeOutErrCount = _TimeOutErrCount - 1
						sTip = string.format("%d/%d - %d/%d",tMyState[5],tMyState[4],tOppState[5],tOppState[4])
						if _TimeOutErrCount==1 then
							hGlobal.O:replace("NBFTimeOutErrMsgBox",hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_NetBFTimeoutError"],{
								font = hVar.FONTC,
								ok = {hVar.tab_string["__TEXT_Exit"],function()
									if oWorld:c2llog("sync_error","@ORDER_ERROR@")==hVar.RESULT_SUCESS then
										g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD, "@ORDER_ERROR@")
										g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_GAME_RESULT,2,"error")
										oWorld:pause(1,"Disconnected")
										hApi.EnterWorld()
										--g_NetManager:disconnectFromGameServer()
									end
								end},
								cancel = {hVar.tab_string["__TEXT_Wait"],function()
									_TimeOutErrCount = 10
								end},
							}))
						end
					end
					if sTip~=nil then
						_LNF_UIHandle["labTimeOut"]:setText(sTip,2)
					end
				end
			else
				hApi.clearTimer("__LNF__TimeOutUI")
			end
		end
	end
	local _code_ShowLeaderName = function(style,tick,sPlayerName)
		_LNF_UIHandle["labTimeOut"].handle.s:setColor(ccc3(255,255,255))
		if style==1 then
			_LNF_UIHandle["myBG"]:setVisible(true)
			_LNF_UIHandle["oppBG"]:setVisible(false)
		else
			_LNF_UIHandle["myBG"]:setVisible(false)
			_LNF_UIHandle["oppBG"]:setVisible(true)
		end
		_LNF_UIHandle["labName"]:setText(tostring(sPlayerName))
		if tick>0 then
			_LNF_TimeLeft = tick + 1
			hApi.addTimerForever("__LNF__TimeOutUI",hVar.TIMER_MODE.GAMETIME,1000,_loop_UpdateTimeOut)
			_loop_UpdateTimeOut()
		else
			_LNF_UIHandle["labTimeOut"]:setText("",2)
			hApi.clearTimer("__LNF__TimeOutUI")
		end
		_FrmBG:show(1)
	end
	local _code_ShowUnitOwnerName = function(oWorld,oUnit)
		if oWorld.data.IsQuickBattlefield~=1 and type(oWorld.data.BFTeamName)=="table" and oWorld.data.IsPaused==0 then
			local tLeaderName = oWorld.data.BFTeamName
			local nTimeOut = tLeaderName.timeout or 0
			local sPlayerName = tLeaderName[oUnit.data.owner]
			if type(sPlayerName)=="string" then
				local nStyle
				if oUnit.data.owner==(tLeaderName.my or hGlobal.LocalPlayer.data.playerId) then
					nStyle = 1
				else
					nStyle = 2
				end
				if oWorld.data.IsReplay==1 then
					nTimeOut = 0
				end
				_code_ShowLeaderName(nStyle,nTimeOut,sPlayerName)
			end
		end
	end
	----------------------------------------
	--显示名字
	hGlobal.event:listen("Event_BattlefieldUnitActived","__LNF__ShowLeaderName",function(oWorld,oRound,oUnit)
		_code_ShowUnitOwnerName(oWorld,oUnit)
	end)
	----------------------------------------
	--显示名字
	hGlobal.event:listen("Event_ReplayUnitActived","__LNF__ShowLeaderName",function(oWorld,oRound,oUnit)
		_code_ShowUnitOwnerName(oWorld,oUnit)
	end)
	----------------------------------------
	--显示第一个行动者的名字
	hGlobal.event:listen("LocalEvent_ShowBFTeamNameFrm","__LNF__ShowBFTeamName",function(oWorld)
		local oRound = oWorld:getround()
		if oRound then
			for i = 1,20 do
				local oUnit = oRound:top(i,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
				if oUnit and (oUnit.ID or 0)>0 then
					--是一个合法单位
					return _code_ShowUnitOwnerName(oWorld,oUnit)
				end
			end
		end
	end)

	----------------------------------------
	--隐藏超时timer
	hGlobal.event:listen("LocalEvent_PlayerLeaveBattlefield","__LNF__HideTimeOutUI",function()
		_FrmBG:show(0)
		hApi.clearTimer("__LNF__TimeOutUI")
	end)
end