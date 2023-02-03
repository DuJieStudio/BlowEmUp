--�ֻ���������
--local _LockUID_List = {		--û��ͨ����԰����ʱ ��Ҫ��ס�� ����
--	[1] = 60002,		--ÿ�ս���
--	[2] = 60004,		--VIP
--	[3] = 60000,		--��Ϸ�ɾ�
--	[4] = 60003,		--ս������
--	[5] = 60012,		--�̵�
--	[6] = 60013,		--����ն��
--	[7] = 60016,		--PVP
--	[8] = 60011,		--���ֵ�ͼ�����ֵ�ͼ�����ڱ�������һ������Ӱ�� ��������������
--	[9] = 60014,		--����
--}

--local _LockUID_List = {		--û��ͨ����԰����ʱ ��Ҫ��ס�� ����
--	[1] = 60002,		--ÿ�ս���
--	[2] = 60003,		--ս������
--	[3] = 60012,		--�̵�
--	[4] = 60011,		--���ֵ�ͼ�����ֵ�ͼ�����ڱ�������һ������Ӱ�� ��������������
--}

--zhenkira 2015.11.18
local _unlockList = 
{	
	--���û����Ĭ�Ͻ���
	--{�������ͣ�0�Զ����� 1ͨ�عؿ�������,�����жϣ�nil, ��ͼ����}
	[60001] = {1, "world/td_001_lsc"},	--�㽫̨
	[60003] = {1, "world/td_002_zjtj"},	--ս����
	[60012] = {1, "world/td_002_zjtj"},	--�̵�
	[60011] = {1, "world/td_001_lsc"},	--��ս
}

--zhenkira 2015.11.18
local _unuseList = {
	[60000] = true,
	[60004] = true,
	[60013] = true,
	[60016] = true,
	[60002] = true,
	[60014] = true,
}

g_cur_webnum = 0		--��ǰ�ڴ���Ĺ���汾��Ϣ

if game_update_is_level_loaded == nil then
	game_update_is_level_loaded = function()
		return true
	end
end

hGlobal.UI.InitMainMenu = function()
	--�г������Լ�������
	--local __G_MainMenuWorld = nil
	__G_MainMenuWorld = nil --geyachao: �����Ϊȫ�ֶ��ܻ�ȡ��
	
	local GGZJ_Tick_Time = -2001
	--���˵�����Ľ�����ť
	local _menuFunc = function(opr)
		if g_curPlayerName == nil and opr ~= hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PleaseCreatePlayer"],{
				font = hVar.FONTC,
				ok = function()
					hApi.xlSetPlayerInfo(1)
				end,
			})
			return
		end
		
		--����ս��
		if opr == hVar.INTERACTION_TYPE.PHONE_SELECTLEVEL then
			
			--
			if hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
				local tempTable = LuaGetSaveTitle(g_curPlayerName)
				--�浵���ǵ�ͼ
				if type(hVar.MAP_INFO[tempTable[1]]) == "table" then
					local Chapter = hApi.MapChapterDecide(tempTable[1])
					if Chapter == 0 then
						--���һ��͸�����壬��ӷ��غͼ�����Ϸ��ť Ĭ�ϵ�һ��
						hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
						--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
						hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
					else
						local viewX,viewY = unpack(hVar.CAMERA_VIEW[Chapter])
						--��һ�º͵ڶ���
						if Chapter > 0 and Chapter < 3 then
							hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
							--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
						--������
						elseif Chapter == 3 then
							hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap_3")
							--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1,2)
						end
						hApi.setViewNodeFocus(hVar.SCREEN.w/2+viewX,hVar.SCREEN.h/2+viewY)
					end
				end
			else
				--���һ��͸�����壬��ӷ��غͼ�����Ϸ��ť Ĭ�ϵ�һ��
				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			end
		--���ֵ�ͼѡ��ؿ�
		elseif opr == hVar.INTERACTION_TYPE.PHONE_SELECTLEVEL_AMUSEMENT then
				--hGlobal.event:event("LocalEvent_Phone_ShowPhone_VIPMap")
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1,0)
				hGlobal.event:event("LocalEvent_Phone_ShowChallengeMapInfoFrm", 1) --zhenkira Ŀǰ��ʱѡ���һ��
		--Ӣ�ۿ�Ƭ
		elseif opr == hVar.INTERACTION_TYPE.PHONE_OPENHEROCARD then
			hGlobal.event:event("LocalEvent_Phone_ShowMyHerocard")
			__G_MainMenuWorld:hideUI(false)
		--��Ʒ
		elseif opr == hVar.INTERACTION_TYPE.PHONE_OPENGIFFRM then
			hGlobal.event:event("LocalEvent_Phone_ShowMyGift")
			hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			__G_MainMenuWorld:hideUI(false)
			--hGlobal.event:event("LocalEvent_PVPMap")
		--ս�����ܿ�
		elseif opr == hVar.INTERACTION_TYPE.PHONE_OPENBFSFRM then
			hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook",1,"playerCard")
			--__G_MainMenuWorld:hideUI(false)
		--�ɾ�
		elseif opr == hVar.INTERACTION_TYPE.PHONE_OPENACHI then
			hGlobal.event:event("LocalEvent_Phone_ShowMyMedal")
			__G_MainMenuWorld:hideUI(false)
		--VIP
		elseif opr == hVar.INTERACTION_TYPE.PHONE_VIP then
			--hGlobal.UI.PhoneVipFrm:show(1)
			--hGlobal.UI.PhoneVipFrm:active()
			--local vip = LuaGetPlayerVipLv()
			--if vip == 0 then
				--hGlobal.event:event("LocalEvent_Phone_showVipFrmC",1)
			--else
				--hGlobal.event:event("LocalEvent_Phone_showVipFrmC",vip)
			--end
			SendCmdFunc["get_VIP_REC_State"]()
			hGlobal.event:event("LocalEvent_Phone_ShowMyVIPNew",1)
			__G_MainMenuWorld:hideUI(false)
		--������б�
		elseif opr == hVar.INTERACTION_TYPE.PHONE_PLAYERLIST then
			--hGlobal.event:event("LocalEvent_ShowPhone_PlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
		--�̵�
		elseif opr == hVar.INTERACTION_TYPE.PHONE_SHOP then
			--û������ʱ�޷����̵�
			if g_cur_net_state ~= 1 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tSendNetShop"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
			if Save_PlayerData and Save_PlayerData.herocard and #Save_PlayerData.herocard > 0 then
				hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx","hall")
			else
				--add by pangyong 2015/3/25(û��Ӣ�۽����ܴ��̵꣬�Ѿ�����menu�������ˣ����Դ˴�û�����ˣ���Ӧ���ļ�phone_noheroopenshop.lua��ɾ��)
				--hGlobal.event:event("localEvent_OpenNoHeroOpenShopFrm")
			end
		--����
		elseif opr == hVar.INTERACTION_TYPE.PHONE_GAME_NEWS then
			hGlobal.event:event("LocalEvent_ShowWebViewNews",1)					--����
			__G_MainMenuWorld:hideUI(false)
		--����
		elseif opr == hVar.INTERACTION_TYPE.GAME_SETTING then
			hGlobal.event:event("localEvent_ShowNewExSysFrm")
			__G_MainMenuWorld:hideUI(false)
		--������
		elseif opr == hVar.INTERACTION_TYPE.GAME_PVP then
			--��ʱ��VIP��ͼ���PVP��ͼ
			if Save_PlayerData and Save_PlayerData.herocard then
				if #Save_PlayerData.herocard >= 6 then
					hGlobal.event:event("LocalEvent_PVPMap",1)
					hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
					__G_MainMenuWorld:hideUI(false)
				else
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_NotEnoughHeroCard"],{
						font = hVar.FONTC,
						ok = function()
						end,
					},nil,nil,{"UI:tip",nil,nil,nil,nil,0.8})
				end
			end
		--����ն������δ���ţ�
		elseif opr == hVar.INTERACTION_TYPE.GAME_GGZJ then -- ����ն��

			--local t = hApi.gametime()
			--if t - GGZJ_Tick_Time < 2000 then
				--return
			--else
				--GGZJ_Tick_Time = t
			--end
			
			--local is_account_test =  CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
			
			--if g_lua_src == 1 or is_account_test == 1 then
				--if Save_PlayerData and Save_PlayerData.herocard then
					--if #Save_PlayerData.herocard >= 6 then
						--hGlobal.UI.include("InitRsdyzAttackFrm_RSDYZ")
						--hGlobal.UI.include("InitRsdyzInfoFrm_RSDYZ")
						--hGlobal.UI.include("InitRsdyzCloseFrm_RSDYZ")
						--local rid = luaGetplayerDataID()
						--if rid == 0 then
							--hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,"roid = 0",0)
						--else
							--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Enter,rid)
						--end
						--__G_MainMenuWorld:hideUI(false)
					--else
						--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_NotEnoughHeroCard1"],{
							--font = hVar.FONTC,
							--ok = function()
							--end,
						--},nil,nil,{"UI:tip",nil,nil,nil,nil,0.8})
					--end
				--end
				
			--else
				--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DemoInfo2"],{
					--font = hVar.FONTC,
					--ok = function()
					--end,
				--})
				--return
			--end
			--local is_account_test =  CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
			--���һ��͸�����壬��ӷ��غͼ�����Ϸ��ť
			--if is_account_test == 1 then
				--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap_3")
				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
				--__G_MainMenuWorld:hideUI(false)
			--end
		end
	end

	--����Ƿ�����
	local _checkIsLock = function(id)
		local lock = false
		local condition = _unlockList[id]
		if condition and condition[1] then
			if condition [1] == 1 then
				local mapName = condition[2]
				if mapName and hVar.MAP_INFO[mapName] and LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
					lock = false
				else
					lock = true
				end
			elseif condition [1] == 0 then
				lock = false
			elseif condition[1] == -1 then
				lock = true
			end
		end
		return lock
	end
	
	--�������б��еĽ��������
	local _AddLockFunc = function()
				
		--�Ƿ����
		if _unlockList[id] then
			oMap.worldUI["minilock_"..id] = hUI.image:new({				--������
				parent = tChaHandle._tn,
				x = labX,
				y = labY - 40,
				model = "UI:LOCK",
				scale = 0.8,
			})

			if __G_MainMenuWorld.worldUI["nameLabel"..id] then
				__G_MainMenuWorld.worldUI["nameLabel"..id].handle.s:setColor(ccc3(125,125,125))	--�������ֵ���ɫ
			end
		end

		for id,condition in pairs(_unlockList) do
			
			if _checkIsLock(id) then
				local n = __G_MainMenuWorld:id2cha(id)
				local scale = 1
				local tabU = hVar.tab_unit[id]
				local _,y,_,_ = unpack(tabU.box or {0,0,0,0})
				if tabU and type(tabU.scale)=="number" then
					scale = tabU.scale
				end
				
				local labX,labY = 0,-1*y*scale - 35
				if tabU.labXY then
					labX,labY = tabU.labXY[1],tabU.labXY[2]
				end
				
				__G_MainMenuWorld.worldUI["minilock_"..id] = hUI.image:new({				--������
					parent = n._tn,
					x = labX,
					y = labY - 40,
					model = "UI:LOCK",
					scale = 0.8,
				})

				if __G_MainMenuWorld.worldUI["nameLabel"..id] then
					__G_MainMenuWorld.worldUI["nameLabel"..id].handle.s:setColor(ccc3(125,125,125))	--�������ֵ���ɫ
				end
			end
		end
	end
	
	
	--�������˵�����
	local _tempOmap = nil
	local _createMainMenuWorld = function()
		hApi.clearTimer("shaderOnTouch")
		if __G_MainMenuWorld~=nil then
			__G_MainMenuWorld:del()
			__G_MainMenuWorld = nil
		end
		--xlLoadResourceFromPList("data/xlobj/xlobjs_lobby.plist")
		__G_MainMenuWorld = hClass.map:new({
			map = hVar.PHONE_MAINMENU,
			background = hVar.PHONE_MAINMENU,
			scenetype = "town",
			codeOnChaCreate = function(oMap,tChaHandle,id,owner,worldX,worldY,facing)
			end,
			codeOnTouchDown = function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
			end,
			codeOnTouchUp = function(oMap,nWorldX,nWorldY,nScreenX,nScreenY)
			end
		})
	end
	
	--��������
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__?????",function(sSceneType,oWorld,oMap)
	--print("__________testOrder:1")
		if oMap == nil then
			if __G_MainMenuWorld~=nil then
				__G_MainMenuWorld:del()
				__G_MainMenuWorld = nil
				--xlReleaseResourceFromPList("data/xlobj/xlobjs_lobby.plist")
			end
			return
		else
				if __G_MainMenuWorld~=nil then
					--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
				end
		end
	end)
	
	--��ʵ����UI 
	hGlobal.event:listen("LocalEvent_ShowMapAllUI","showUI",function(bool)
		--print("__________testOrder:2")
		if __G_MainMenuWorld then
			__G_MainMenuWorld:hideUI(bool)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_OpenPhoneMainMenu","creatThisWorld",function()
		--print("__________testOrder:5")
		local userID = xlPlayer_GetUID()
		local playerCardUid = LuaGetPlayerCardUid()
		if userID ~= playerCardUid and userID ~= 0 and playerCardUid ~= 0 then
			xlAppAnalysis("cheat_playercard",0,1,"info",tostring(userID).."-"..tostring(playerCardUid).."-T:"..tostring(os.date("%m%d%H%M%S")))
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenOtherPlayerList"].."\n-["..playerCardUid.."]-".."\n-["..userID.."]-",{
				font = hVar.FONTC,
				ok = function()
					--geyachao: ���ܲ�����ظ�id
					--xlExit()
				end,
			})
			return
		end
		
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
		
		_createMainMenuWorld()
		
		hGlobal.LocalPlayer:focusworld(__G_MainMenuWorld)
		
		local loaded = false
		if g_curPlayerName == nil then
			loaded = true
			hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",LuaGetLastSwitchPlayer())
		else
			hGlobal.event:event("LocalEvent_PhoneShowPlayerCardFrm",g_curPlayerName)
		end
		
		
		hGlobal.event:event("LocalEvent_Phone_CloasePhone_SelecteMap")
		
		if not loaded then
			--��ʾ��������
			hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
		end
		
		--��������: ��������
		hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINDOTA, nil, "maindota")
		
		--���ͻ�ȡ��ǰ��ʾ��Э��
		SendCmdFunc["get_NweVer"]()
		SendCmdFunc["get_NewWebView"]()
	end)

end