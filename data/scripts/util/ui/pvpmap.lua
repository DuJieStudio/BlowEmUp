local __PVP__UIInitParam
local __PVP__UIFunc
do
	__PVP__UIInitParam = {
		["unitcard"] = {
			IsEnd = 0,
			tCard = 0,
			tDataI = 0,
			ModelFunc = function(self,tData)
				local v = self.tCard
				local nCardId = self.tDataI
				local nCardLv = self.tDataII
				return tData[1](v[2],v[3],nCardId,nCardLv,tData[2],tData[3])
			end,
		},
		["herocard"] = {
			IsEnd = 0,
			tCard = 0,
			ModelFunc = function(self,tData)
				local v = self.tCard
				return tData[1](v[2],v[3],v[4],tData[2],tData[3])
			end,
		},
		["tacticscard"] = {
			IsEnd = 0,
			tCard = 0,
			ModelFunc = function(self,tData)
				local v = self.tCard
				return tData[1](v[2],v[3],tData[2],tData[3])
			end,
		},
		["roomcard"] = {
			IsEnd = 0,
			tCard = 0,
			tDataI = 0,
			tDataII = 0,
			ModelFunc = function(self,tData)
				local tRoom = self.tCard
				local nMyID = self.tDataI
				local tPlayerList = self.tDataII
				return tData[1](tRoom,nMyID,tPlayerList,tData[2],tData[3],tData[4])
			end,
		},
		get = function(self,sType,tCard,tDataI,tDataII)
			local tParam = self[sType]
			if tParam then
				tParam.IsEnd = 0
				tParam.tCard = tCard
				tParam.tDataI = tDataI
				tParam.tDataII = tDataII
				return tParam
			end
		end,
	}
	local _code_DrawCardUI = function(tCard,pNode,x,y)
		local sType,id = tCard[1],tCard[2]
		if sType=="unit" then
			if hVar.tab_unit[id] then
				hUI.CreateMultiUIByParam(pNode,x,y,hUI.GetUITemplate("unitcard")[1],{},__PVP__UIInitParam:get("unitcard",tCard,tCard[4],hApi.PVPGetNetData("ArmyCardLv",tCard[4])))
			end
		elseif sType=="hero" then
			if hVar.tab_unit[id] then
				hUI.CreateMultiUIByParam(pNode,x,y,hUI.GetUITemplate("herocard")[1],{},__PVP__UIInitParam:get("herocard",tCard))
			end
		elseif sType=="tactics" then
			if hVar.tab_tactics[id] then
				hUI.CreateMultiUIByParam(pNode,x,y-32,hUI.GetUITemplate("tacticscard")[1],{},__PVP__UIInitParam:get("tacticscard",tCard))
			end
		end
	end
	__PVP__UIFunc = {
		DrawCardUI = _code_DrawCardUI,
		PickCardUI = function(self,tTempPos,tPickParam)
			local tCard = tPickParam.tCard
			if tCard and tCard~=0 then
				if tPickParam.nDelay and tPickParam.nDelay>0 then
					if hApi.gametime()-tTempPos.tick<=tPickParam.nDelay then
						return
					end
				end
				if type(tCard[3])~="number" then
					--未激活的卡片不能拖拽
				elseif tCard[1]=="unit" or tCard[1]=="hero" then
					tPickParam.state = 2
					tPickParam.oImage = hUI.thumbImage:new({
						id = tCard[2],
						animation = "walk",
						x = tTempPos.x,
						y = tTempPos.y,
						z = 9999,
						w = tPickParam.w,
						h = tPickParam.h,
					})
				elseif tCard[1]=="tactics" then
					tPickParam.state = 2
					tPickParam.oImage = hUI.node:new({
						x = tTempPos.x,
						y = tTempPos.y,
						z = 9999,
					})
					_code_DrawCardUI(tCard,tPickParam.oImage.handle._n,0,32)
				end
			end
		end,
		IsEqual = function(a,b,n)
			if a==b then
				return 1
			elseif type(a)=="table" and type(b)=="table" then
				for i = 1,n do
					if a[i]~=b[i] then
						return 0
					end
				end
				return 1
			else
				return 0
			end
		end,
		IsArmyGrid = function(t,i)
			return t[i]~=0 and t[i][1]>10
		end,
		IsTacticsGrid = function(t,i)
			return t[i]~=0 and t[i][1]>100
		end,
		UpdateUICard = function(tUICard,tCardA,NoRetWhenEqual)
			if tUICard[1]=="unit" then
				local nCardID,nCardLv,nCardExp,nUnitID,nUnitNum = unpack(tCardA)
				--{"unit",nUnitID,nUnitNum,nCardID,nCardLv}
				if nUnitID==tUICard[2] and nUnitNum==tUICard[3] and nCardID==tUICard[4] and nCardLv==tUICard[5] then
					if NoRetWhenEqual==1 then
						return
					else
						return tUICard
					end
				else
					tUICard[2] = nUnitID
					tUICard[3] = nUnitNum
					tUICard[4] = nCardID
					tUICard[5] = nCardLv
					return tUICard
				end
			else
				tUICard[2] = tCardA[1]
				tUICard[3] = tCardA[2]
				tUICard[4] = tCardA[3] or 0
				tUICard[5] = tCardA[4] or 0
				return tUICard
			end
		end,
		CreateCardSlot = function(mode)
			if mode=="hero" then
				--{nHeroID,1,0,0,0,0},
				return {2,"",0,0,0,0}
			elseif mode=="unit" then
				--{nUnitID,nUnitNumShow,nCardID,nCardLv,nUnitNum,nChoosedCount}
				return {1,"",0,0,0,0}
			elseif mode=="tactics" then
				return {1,1}
			end
		end,
		CreateArmyCardSlot = function(t)
			local r = {}
			for i = 1,(t.hero or 0),1 do
				r[#r+1] = __PVP__UIFunc.CreateCardSlot("hero")
			end
			for i = 1,(t.unit or 0),1 do
				r[#r+1] = __PVP__UIFunc.CreateCardSlot("unit")
			end
			return r
		end,
		CreateTacticsCardSlot = function(t)
			local r = {}
			for i = 1,(t.tactics or 0),1 do
				r[#r+1] = __PVP__UIFunc.CreateCardSlot("tactics")
			end
			return r
		end,
	}
end
hGlobal.UI.InitPVPMap_PVP = function(mode)
	local tInitEventName = {"LocalEvent_PVPMap","__PVPMap"}
	if mode~="include" then
		return tInitEventName
	end
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	local _FrmBG
	local _childUI

	local _CODE_UpdateAllCard = hApi.DoNothing
	local _CODE_UpdateAllRoom = hApi.DoNothing
	local _CODE_UpdateAllQuest = hApi.DoNothing
	local _CODE_SwitchPageMode = hApi.DoNothing
	local _CODE_SwitchChooseCardMode = hApi.DoNothing
	local _CODE_UpdateCardItem = hApi.DoNothing
	local _CODE_UpdateRoomItem = hApi.DoNothing
	local _CODE_UpdatePlayerRank = hApi.DoNothing
	local _CODE_UpdatePVPQuest = hApi.DoNothing
	local _CODE_UpdateAllPVPQuestBtn = hApi.DoNothing
	local _CODE_ShowPVPQuestRewardTip = hApi.DoNothing
	local _CODE_GetRoomListWithFilter = hApi.DoNothing
	local _CODE_SwitchRoomListFilter = hApi.DoNothing
	local _CODE_SwitchRoom = hApi.DoNothing
	local _CODE_PlayerEnterRoom = hApi.DoNothing
	local _CODE_ShowCardItemHint = hApi.DoNothing
	local _CODE_EnablePageUI = hApi.DoNothing
	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_UpdateArmyGrid = hApi.DoNothing
	local _CODE_UpdateTacticsGrid = hApi.DoNothing
	local _CODE_UploadMyIcon = hApi.DoNothing
	local _CODE_ChallengeRoom = hApi.DoNothing
	local _CODE_SwitchMyPVPState = hApi.DoNothing
	local _CODE_ExitFromPVP = hApi.DoNothing
	local _CODE_LoadMyDeployment = hApi.DoNothing

	local _PVP_IAgreeRankRule = 0
	local _PVP_LastPlayerList = nil
	local _PVP_MyIcon = nil
	local _PVP_MyRoomID = 0
	local _PVP_NpcUpdated = 0
	local _PVP_RankKing = 0
	local _PVP_MyLastState = nil
	local _PVP_ChooseCardMode = 0
	local _PVP_ChooseMap = "map1"
	local _PVP_ReplayUpdateTick = -999999
	local _PVP_ChooseDefine = {hero=2,unit=4,tactics=hVar.PVP_TACTICS_CARD_LIMIT}			--允许上阵的英雄/单位/兵种卡片数量
	local _PVP_ChooseTactics = __PVP__UIFunc.CreateTacticsCardSlot(_PVP_ChooseDefine)
	local _PVP_ChooseArmy = __PVP__UIFunc.CreateArmyCardSlot(_PVP_ChooseDefine)			--创建默认选择部队的槽子
	local _PVP_ChooseCardGridXYWH = {
		["ArmyGrid"] = {190,-526,122,128},
		["TacticsGrid"] = {306,-531,122,128},
	}
	local _PVP_FrmXYWH = {hVar.SCREEN.w/2-450,hVar.SCREEN.h/2+305,900,640}
	local _PVP_BGzOrder = -1
	local _PVP_FrmUI = {
		--左边栏
		--{"image","bgLeft","UI:PVPFramLeft",{446,-330,-1,-1,_PVP_BGzOrder}},
		--{"image","bgLeft","UI:PVPFramLeft",{75,-330,-1,-1,_PVP_BGzOrder}},                    --版面已合成一个 changed by pangyong 2015/4/27
		--{"image","bgButtom","UI:PVPFramBottom",{504,-609,760,20,_PVP_BGzOrder-10}},		--版面已合成一个
		--{"image","bgRight","UI:PVPFramRight",{881,-331,-1,-1,_PVP_BGzOrder}},			--版面已合成一个
		--{"image","bgTop","UI:PVPFramTop",{446,-22,-1,-1,_PVP_BGzOrder}},			--版面已合成一个
		{"image","bgWoodRank_bg","UI:pvproombg",{496 - 50,-330 + 23,-1,-1,_PVP_BGzOrder}},	--added by pangyong 2015/4/27
		--{"labelX","bgTop_lab",hVar.tab_string["__TEXT_PlayerRank"],{500,-24,24,1,"MC",hVar.FONTC,{255,249,223}}},
		--{"image","imgLion","UI:PVPLion",{73,-95,-1,-1,_PVP_BGzOrder}},
		--左边栏按钮:选兵
		{"button","btnPVPArmy","UI:pvpcj",{66,-140,-1,-1,0.95,_PVP_BGzOrder},function()
			_CODE_SwitchPageMode("ChooseCard")
		end},
		--左边栏按钮:房间列表(新手房)
		{"button","btnPVPRoom2","ui/pvp/pvprm2.png",{66,-220,-1,-1,0.95,_PVP_BGzOrder},function(oBtn)
			if oBtn.data.userdata==1 then
				hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",g_PVP_NetSaveData.activity)
			else
				_CODE_PlayerEnterRoom(2)
			end
		end},
		--左边栏按钮:房间列表(一般房)
		{"button","btnPVPRoom1","UI:pvpmainwarl",{66,-300,-1,-1,0.95,_PVP_BGzOrder},function(oBtn)
			if oBtn.data.userdata==1 then
				--hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",g_PVP_NetSaveData.activity)
				if g_PVP_NetSaveData and g_PVP_NetSaveData.PVPSwitch and  g_PVP_NetSaveData.PVPSwitch.room1_enable then
					if g_PVP_NetSaveData.PVPSwitch.room1_enable == 1 then
						hGlobal.event:event("LocalEvent_ShowPVPReplayFrm")
					elseif g_PVP_NetSaveData.PVPSwitch.room1_enable == 0 then
						if g_PVP_NetSaveData.PVPEnable == 1 then
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_EnterTip"],{
								font = hVar.FONTC,
								ok = function()
									_CODE_PlayerEnterRoom(2)
								end,
							},nil,nil,{"UI:tip",nil,nil,nil,nil,0.8})
						else
							hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",g_PVP_NetSaveData.activity)
						end
					end
				end
			else
				if _PVP_IAgreeRankRule==0 then
					hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",g_PVP_NetSaveData.activity,{
						show = {100,199},		--只显示对决房公告
						ok = function()
							_PVP_IAgreeRankRule = 1
							_CODE_PlayerEnterRoom(1)
						end,
						cancel = 1,
					})
				else
					_CODE_PlayerEnterRoom(1)
				end
			end
		end},
		--左边栏按钮:排行榜查看
		{"button","btnPVPRank","UI:PVPRankBut1",{66,-380,-1,-1,0.95,_PVP_BGzOrder},function(oBtn)
			if oBtn.data.userdata==1 then
				if g_PVP_NetSaveData and g_PVP_NetSaveData.PVPSwitch and  g_PVP_NetSaveData.PVPSwitch.Rank_enable then
					if g_PVP_NetSaveData.PVPSwitch.Rank_enable == 1 then
						--_CODE_SwitchPageMode("PlayerRank")
					elseif g_PVP_NetSaveData.PVPSwitch.Rank_enable == 0 then
						if g_PVP_NetSaveData.PVPEnable == 1 then
							hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_EnterTip"],{
								font = hVar.FONTC,
								ok = function()
									_CODE_PlayerEnterRoom(2)
								end,
							},nil,nil,{"UI:tip",nil,nil,nil,nil,0.8})
						else
							hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",g_PVP_NetSaveData.activity)
						end
					end
				end
			else
				_CODE_SwitchPageMode("PlayerRank")
			end
		end},

		--左边栏按钮:排行榜查看
		{"button","btnPVPQuest","UI:PVPReward",{66,-460,-1,-1,0.95,_PVP_BGzOrder},function(oBtn)
			if oBtn.data.userdata==1 then
				
			else
				_CODE_SwitchPageMode("PVPQuest")
			end
		end},

		--rank背景，都挂在一个node上面
		{"node","bgRank",{
			{"label","bgRank_tip",hVar.tab_string["__TEXT_PVP_LADDER"],{440,-24,26,1,"MC",hVar.FONTC,{255,255,255}}},
			--{"image","bgRank_bg","UI:pvproombg",{496,-330,-1,-1,_PVP_BGzOrder}},						--排行榜顶部 changed by pangyong 2015/4/27
			{"image","bgRank_tab","UI:rank_tab",{496,-72,-1,-1,_PVP_BGzOrder}},
			{"image","bgRank_xiao","UI:PvpDownFloor",{496,-582,754,42,_PVP_BGzOrder}},
			--lab 排名
			{"label","rank_ranknum",hVar.tab_string["__TEXT_RankNum"],{150,-62,24,1,"LT",hVar.FONTC,{230,180,50}}},
			--lab 玩家名
			{"label","rank_playername",hVar.tab_string["__TEXT_PlayerName"],{300,-62,24,1,"LT",hVar.FONTC,{230,180,50}}},
			--lab 天梯分数
			{"label","rank_strength",hVar.tab_string["PVP_Point"],{470,-62,24,1,"LT",hVar.FONTC,{230,180,50}}},
			--lab 战斗等级
			{"label","rank_strengthLv",hVar.tab_string["PVPFightGrade"],{580,-62,24,1,"LT",hVar.FONTC,{230,180,50}}},
			--lab 勋章
			{"label","rank_achi",hVar.tab_string["PVP_CUR_Title"],{730,-62,24,1,"LT",hVar.FONTC,{230,180,50}}},
			
			--分界线
			{"image","apartline_1","UI:sx",{228,-72,-1,-1,_PVP_BGzOrder}},
			{"image","apartline_2","UI:sx",{450,-72,-1,-1,_PVP_BGzOrder}},
			{"image","apartline_3","UI:sx",{570,-72,-1,-1,_PVP_BGzOrder}},
			{"image","apartline_4","UI:sx",{694,-72,-1,-1,_PVP_BGzOrder}},

			{"image","rank_MyRank_lab","UI:wdpm",{304,-584,-1,-1,_PVP_BGzOrder}},
			{"image","rank_MyStrength_lab","UI:zdl",{576,-584,-1,-1,_PVP_BGzOrder}},
			
			--我的排名 和 我的战斗的 底图
			{"image","rank_bottom1","UI:rank_bottom",{400,-584,-1,-1,_PVP_BGzOrder}},
			{"image","rank_bottom2","UI:rank_bottom",{664,-584,-1,-1,_PVP_BGzOrder}},
		}},
		--lab 我的排名
		{"labelX","rank_MyRank","",{400,-584,22,1,"MC"}},
		--lab 我的战斗力
		{"labelX","rank_MyStrength","",{666,-584,22,1,"MC"}},
		
		--排行上升或者下降的 小箭头
		{"imageX","rank_down","UI:rank_down",{464,-584,-1,-1,1}},
		{"imageX","rank_up","UI:rank_up",{464,-584,-1,-1,1}},

		--退出的小门
		{"button","btnPVPLogOut","UI:LEAVETOWNBTN",{68,-554,-1,-1,0.95,_PVP_BGzOrder},function() return _CODE_ExitFromPVP()end},
		--选卡片页面
		{"node","bgCard",{
			--队伍配置界面的底框												changed by pangyong 2015/4/24
			{"label","bgCard_tip",hVar.tab_string["__TEXT_PVP_DEPLOYMENT"],{440,-24,26,1,"MC",hVar.FONTC,{255,255,255}}},	--标题
			--{"image","bgWoodRank_bg","UI:pvproombg",{496 - 50,-330,-1,-1,_PVP_BGzOrder}},					--队伍匹配
			{"image","bgDownRank_bg","UI:PvpDownFloor",{496,-533,749,-1,_PVP_BGzOrder}},					--低面板
			{"image","bgBlackRank_bg","UI:zjdb",{496,-270,754,388,_PVP_BGzOrder}},						--灰色背景
			{"image","bgUpRank_bg","UI:rank_tab",{496,-72,-1,-1,_PVP_BGzOrder}},						--上面板
		}},
		--顶上的pvp币显示
		{"node","imgPVPDeployBG",{
			{"image","imgPVPCoin","UI:pvptoken",{724,-73,-1,-1,2}},
			{"image","imgPVPCoinBG","UI:cjbt",{774,-73,110,24,0}},
			{"labelX","labPVPCoin","0",{746,-73,22,1,"LC"}},
		}},
		--选兵界面:购买牌子的按钮
		{"button","btnPurchasePVPCoin","UI:pvpplus",{850,-73,-1,-1,0.8,1},function() return hGlobal.event:event("LocalEvent_BuyFuStoneFrame") end},
		{"button","btnPurchasePVPCoinEx",-1,{790,-64,160,52,0.8,1},function()
			local actCallBack = function() _childUI["btnPurchasePVPCoin"].handle._n:runAction(CCScaleTo:create(0.06,1,1)) end
			_childUI["btnPurchasePVPCoin"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.06,0.9,0.9),CCCallFunc:create(actCallBack)))
			hGlobal.event:event("LocalEvent_BuyFuStoneFrame") 
		end},
		--选兵界面:战术卡类型说明
		{"button","btnCardClassTip","ICON:action_info",{160,-536,-1,-1,0.9,1},function() hGlobal.event:event("LocalEvent_ShowPVPTip","tactics") end},
		--选兵界面:顶上的三个小按钮
		{"button","btnPVPArmyHero","UI:pvpbxhero",{174,-72,-1,-1,0.9,1},function()_CODE_SwitchChooseCardMode("hero")end},
		{"button","btnPVPArmyUnit","UI:pvpbxbing",{270,-72,-1,-1,0.9,1},function()_CODE_SwitchChooseCardMode("unit")end},
		{"button","btnPVPTactics","UI:pvpbxjn",{366,-72,-1,-1,0.9,1},function()_CODE_SwitchChooseCardMode("tactics")end},
		--房间页面:背景
		{"node","bgRoom",{
			{"label","bgRoom_tip1",hVar.tab_string["__TEXT_PVP_ROOM"],{440,-24,26,1,"MC",hVar.FONTC,{255,255,255}}},
			{"label","bgRoom_tip2",hVar.tab_string["__TEXT_PVP_ROOM2"],{440,-24,26,1,"MC",hVar.FONTC,{255,255,255}}},
			--{"image","bgRoom_bg","UI:pvproombg",{496,-330,-1,-1,_PVP_BGzOrder}},					--天梯房 changed by pangyong 2015/4/27
		}},
		--房间按钮:规则说明和房间操作
		{"button","btnPVPRoomIntro","ICON:HeroAttr_con",{780,-576,-1,48,0.9,1},function() return hGlobal.event:event("LocalEvent_ShowPVPHeroSetFrm",_PVP_ChooseArmy) end},
		{"button","btnPVPRoomOpr","ICON:action_info",{838,-576,-1,48,0.9,1},function() hGlobal.event:event("LocalEvent_ShowPVPTip","room2") end},
		--房间按钮:准备
		{"image","imgPVPReady","ui/pvp/pvpmystate1.png",{172,-578,-1,-1}},
		{"image","imgPVPNotReady","ui/pvp/pvpmystate2.png",{172,-578,-1,-1}},
		{"button","btnPVPReady","misc/buttonred.png",{248,-580,-1,-1,0.95,1},function()return _CODE_SwitchMyPVPState("switch|ready")end},
		{"button","btnPVPRoomFilter",-1,{736,-578,188,42,0.95,1},function()return _CODE_SwitchRoomListFilter()end},
		--播放指定录像功能
		{"button","btnPVPReplay","ui/pvp/video.png",{840,-578,54,54,0.9,1},function() return hGlobal.event:event("LocalEvent_ShowPVPReplayFrm") end},
		--房间按钮:自动匹配
		{"button","btnPVPAutoMatch","UI:PVPMate2",{490,-580,-1,-1,0.9,1},function()return _CODE_SwitchMyPVPState("switch|automatch")end},
		--排行榜按钮:奖励预览(月中)
		{"button","btnPVPRankRewardI","ui/pvp/quest_reward_m.png",{164,-568,-1,-1,0.9,1},function()
			if g_PVP_NetSaveData.PVPRewardDataI~="" then
				return hGlobal.event:event("LocalEvent_ShowRewardPreviewFrm",hVar.tab_string["PVPSesonRewardI"],hVar.tab_string["PVPSesonRewardIntroI"],g_PVP_NetSaveData.PVPRewardDataI)
			end
		end},
		--排行榜按钮:奖励预览(月末)
		{"button","btnPVPRankRewardII","ui/pvp/quest_reward.png",{226,-568,-1,-1,0.9,1},function()
			if g_PVP_NetSaveData.PVPRewardDataII~="" then
				return hGlobal.event:event("LocalEvent_ShowRewardPreviewFrm",hVar.tab_string["PVPSesonRewardII"],hVar.tab_string["PVPSesonRewardIntroII"],g_PVP_NetSaveData.PVPRewardDataII)
			end
		end},
		--任务界面:背景
		{"node","bgQuest",{
			{"label","bgQuest_tip",hVar.tab_string["__TEXT_Quest_Reward"],{440,-24,26,1,"MC",hVar.FONTC,{255,255,255}}},
			--{"image","bgQuest_bg","UI:pvproombg",{496,-330,-1,-1,_PVP_BGzOrder}},						--训练场 changed by pangyong 2015/4/27
		}},
	}
	local _PVP_FrmUIHandle = {}
	local _PVP_PageDefault = "ChooseCard"
	local _PVP_PageMode = 0
	local _PVP_PageUI = {
		["ChooseCard"] = {
			cliprect = {122,-96,746,184*2,0},
			dragable = {0,0,0,0},
			autoalign = {"V","ChooseCardGrid",30,0,-30},
			card = {},
			mode = 0,
			grid = {
				cols = 5,									--列数
				rows = 60,									--函数
				x = 128+144/2,
				y = -84-166/2,
				gridW = 148,									--grid 每一各宽度	changed by pangyong 2015/4/27
				gridH = 184,
				codeOnAutoRelease = function(self,MustRelease)					--内存优化
					if MustRelease~=1 then
						if _FrmBG.data.show==1 and _PVP_PageMode=="ChooseCard" and self.handle._n:isVisible()==true then
							return 0
						end
					end
				end,
			},
			tag = {"btnPVPArmy"},
			btn = {"btnPVPArmyHero","btnPVPArmyUnit","btnPVPTactics","btnPurchasePVPCoin","btnCardClassTip","btnPurchasePVPCoinEx"},
			img = {"bgCard","imgPVPDeployBG"},
			ui = {"ArmyGrid","TacticsGrid"},
			update = function(self,nCardIndex,oGrid,pSprite)
				return _CODE_UpdateCardItem(self,nCardIndex,oGrid,pSprite)
			end,
			cardUI = {},
			cardbox = {
				["unit"] = {-48,48,96,90},
				["hero"] = {-48,54,96,76},
				["tactics"] = {-36,12,72,80},
			},
		},
		["DuelRoom"] = {
			cliprect = {122,-54,744,500,0},
			dragable = {0,0,0,0},
			autoalign = {"V","DuelRoomGrid",30,0,-30},
			myID = 0,
			player = {index={}},
			room = {},
			grid = {
				cols = 3,
				rows = 60,
				x = 122+248/2,
				y = -48-182/2,
				gridW = 248,
				gridH = 166,
			},
			tag = {"btnPVPRoom1","btnPVPRoom2"},
			btn = {"btnPVPReady","btnPVPAutoMatch","btnPVPRoomIntro","btnPVPRoomOpr","btnPVPReplay","btnPVPRoomFilter"},
			img = {"bgRoom","imgPVPReady","imgPVPNotReady"},
			ui = {"DuelRoomGrid"},
			room_btn = {
				[1] = {"btnPVPAutoMatch","btnPVPReplay","btnPVPRoomFilter"},
				[2] = {"btnPVPAutoMatch","btnPVPRoomIntro","btnPVPRoomOpr"},
			},
			update = function(self,nCardIndex,oGrid,pSprite,gx,gy)
				return _CODE_UpdateRoomItem(self,nCardIndex,oGrid,pSprite,gx,gy)
			end,
		},
		--["ChallengeRoom"] = {
			--cliprect = {122,-54,744,500,0},
			--dragable = {0,0,0,0},
			--autoalign = {"V","DuelRoomGrid",30,0,-30},
			--myID = 0,
			--player = {index={}},
			--room = {},
			--grid = {
				--cols = 3,
				--rows = 60,
				--x = 122+248/2,
				--y = -48-182/2,
				--gridW = 248,
				--gridH = 166,
			--},
			----tag = {"btnPVPRoom1","btnPVPRoom2"},
			----btn = {"btnPVPReady","btnPVPAutoMatch","btnPVPRoomIntro","btnPVPRoomOpr"},--"btnPVPRoomFilter",
			----img = {"bgRoom","imgPVPReady","imgPVPNotReady"},
			----ui = {"DuelRoomGrid"},
			----update = function(self,nCardIndex,oGrid,pSprite,gx,gy)
				----return _CODE_UpdateRoomItem(self,nCardIndex,oGrid,pSprite,gx,gy)
			----end,
		--},
		["PlayerRank"] = {
			cliprect = {124,-96,744,464,0},		-- 第五个参数填 1 可以呈现出绿色 clip 区域
			dragable = {0,0,0,0},
			autoalign = {"V","PlayerRankGrid",23,0,-23},	-- 下面会根据 sPageMode.."Grid" 创建一个 grid
			grid = {
				cols = 1,
				rows = 100,
				x = 124 + 248/2,
				y = -90 - 46/2,
				gridW = 248,
				gridH = 46,
			},
			tag = {"btnPVPRank"},
			img = {"bgRank"},
			btn = {"btnPVPRankRewardI","btnPVPRankRewardII"},
			ui = {"PlayerRankGrid","rank_MyRank","rank_MyStrength","rank_down","rank_up"},
			update = function(self,id,oGrid,pSprite,gx,gy)
				return _CODE_UpdatePlayerRank(self,id,oGrid,pSprite,gx,gy)
			end,
		},
		["PVPQuest"] = {
			cliprect = {122,-54,744,548,0},		-- 第五个参数填 1 可以呈现出绿色 clip 区域
			dragable = {0,0,0,0},
			autoalign = {"V","PVPQuestGrid",32,0,-32},	-- 下面会根据 sPageMode.."Grid" 创建一个 grid
			grid = {
				cols = 1,
				rows = 50,
				x = 124 + 740/2,
				y = -52 - 140/2,
				gridW = 740,
				gridH = 140,
				uiExtra = {"btnConfirm"},
				iconXYWH = {
					[1] = {
						{546,-56,48,48},
					},
					[2] = {
						{516,-56,48,48},
						{578,-56,48,48},
					},
					[3] = {
						{454,-56,48,48},
						{516,-56,48,48},
						{578,-56,48,48},
					},
					[4] = {
						{392,-56,48,48},
						{454,-56,48,48},
						{516,-56,48,48},
						{578,-56,48,48},
					},
					[5] = {
						{330,-56,48,48},
						{392,-56,48,48},
						{454,-56,48,48},
						{516,-56,48,48},
						{578,-56,48,48},
					},
				},
			},
			tag = {"btnPVPQuest"},
			img = {"bgQuest"},
			update = function(self,id,oGrid,pSprite,gx,gy)
				return _CODE_UpdatePVPQuest(self,id,oGrid,pSprite,gx,gy)
			end,
		},
	}
	hGlobal.UI.PVPFrm = hUI.frame:new({
		x = _PVP_FrmXYWH[1],
		y = _PVP_FrmXYWH[2],
		--w = _PVP_FrmXYWH[3],
		--h = _PVP_FrmXYWH[4],
		dragable = 2,
		titlebar = 0,
		show = 0,
		background = -1,
		autoactive = 0,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			local tPickParam = _CODE_HitPage(self,tTempPos,x,y)
			if tPickParam~=nil then
				local tDragRect
				if _PVP_PageUI[tPickParam.sPageMode] then
					tDragRect = _PVP_PageUI[tPickParam.sPageMode].dragable
				end
				if tDragRect==nil then
					tDragRect = {0,0,0,0}
				end
				return self:pick(tPickParam.sGridName,tDragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tPickParam})
			end
		end,
	})
	_FrmBG = hGlobal.UI.PVPFrm
	_childUI = _FrmBG.childUI

	----------------------------------------
	--创建页面UI
	----------------------------------------
	do
		local tInitParam = hUI.MultiUIParamByFrm(_FrmBG)
		hUI.CreateMultiUIByParam(_FrmBG,0,0,_PVP_FrmUI,_PVP_FrmUIHandle,tInitParam)
		--for i = 1,#_PVP_FrmUI do
			--local uiType,uiName = _PVP_FrmUI[i][1],_PVP_FrmUI[i][2]
			--if uiType=="button" then
				--_childUI[uiName] = _PVP_FrmUIHandle[uiName]
				--if type(_PVP_FrmUI[i][5])~="function" then
					--_childUI[uiName]:setstate(0)
				--end
			--end
		--end
		_childUI["ArmyGrid"] = hUI.bagGrid:new({
			parent = _FrmBG.handle._n,
			x = _PVP_ChooseCardGridXYWH["ArmyGrid"][1],
			y = _PVP_ChooseCardGridXYWH["ArmyGrid"][2],
			gridW = _PVP_ChooseCardGridXYWH["ArmyGrid"][3],
			gridH = _PVP_ChooseCardGridXYWH["ArmyGrid"][4],
			iconW = 128,
			iconH = 128,
			animation = -1,
			grid = {hApi.NumTable(#_PVP_ChooseArmy)},
			--slot = {model = "UI:army_tray",animation = "normal",w=96,h=96,x=0,y=-16},
			slot = 0,
			num = {font="numWhite",size=22,align="MC",x=-36,y=28},
			codeOnImageCreate = function(oGrid,nUnitId,pSprite,gx,gy)
				local nType = hVar.UNIT_TYPE.UNIT
				if nUnitId<10 then
					if nUnitId==2 then
						nType = hVar.UNIT_TYPE.HERO
					end
				else
					local tabU = hVar.tab_unit[nUnitId]
					if tabU then
						nType = tabU.type
					end
					hUI.deleteUIObject(hUI.thumbImage:new({
						parent = pSprite,
						id = nUnitId,
						w = oGrid.data.iconW,
						h = oGrid.data.iconH,
						y = -24,
						z = 1,
					}))
				end
				if nType==hVar.UNIT_TYPE.HERO then
					hUI.deleteUIObject(hUI.image:new({
						parent = pSprite,
						model = "UI:army_tray2",
						animation = "normal",
						w = 96,
						--h = 96,
						y = -30,
						z = 0,
					}))
				else
					hUI.deleteUIObject(hUI.image:new({
						parent = pSprite,
						model = "UI:army_tray",
						animation = "normal",
						w = 96,
						--h = 96,
						y = -16,
						z = 0,
					}))
				end
				
			end,
			codeOnAutoRelease = function(self,MustRelease)
				if MustRelease~=1 then
					if _FrmBG.data.show==1 and _PVP_PageMode=="ChooseCard" and self.handle._n:isVisible()==true then
						return 0
					end
				end
			end,
		})
		_FrmBG.handle._n:reorderChild(_childUI["ArmyGrid"].handle._n,10)
		_childUI["TacticsGrid"] = hUI.bagGrid:new({
			parent = _FrmBG.handle._n,
			x = _PVP_ChooseCardGridXYWH["TacticsGrid"][1],
			y = _PVP_ChooseCardGridXYWH["TacticsGrid"][2],
			gridW = _PVP_ChooseCardGridXYWH["TacticsGrid"][3],
			gridH = _PVP_ChooseCardGridXYWH["TacticsGrid"][4],
			iconW = 128,
			iconH = 128,
			animation = -1,
			grid = {hApi.NumTable(#_PVP_ChooseTactics)},
			slot = 0,
			num = 0,
			codeOnImageCreate = function(oGrid,nTacticsId,pSprite,gx,gy)
				pSprite:setScale(0.8)
				local tItem = _PVP_ChooseTactics[oGrid.data.count]
				if tItem then
					__PVP__UIFunc.DrawCardUI({"tactics",tItem[1],tItem[2]},pSprite,0,12)
				end
			end,
		})
		_FrmBG.handle._n:reorderChild(_childUI["TacticsGrid"].handle._n,10)
		_childUI["TacticsGrid"]:updateitem(_PVP_ChooseTactics)
		
		for sModeName,tUIList in pairs(_PVP_PageUI) do
			local pNode = _FrmBG.handle._n
			if type(tUIList.cliprect)=="table" then
				local pClipNode,pClipMask,pClipMaskN = hApi.CreateClippingNode(_FrmBG.handle._n,tUIList.cliprect,5,tUIList.cliprect[5])
				tUIList.clipnode = {pClipNode,pClipMask,pClipMaskN}
				pNode = pClipNode
			end
			if type(tUIList.grid)=="table" then
				local tCardGrid = {}
				for i = 1,tUIList.grid.rows do
					tCardGrid[i] = hApi.NumTable(tUIList.grid.cols)
				end
				local sPageMode = sModeName
				local pUpdateFunc = tUIList.update
				if type(pUpdateFunc)~="function" then
					pUpdateFunc = nil
				end
				local uiExtra = {"PlusUI"}
				if tUIList.grid.uiExtra then
					for i = 1,#tUIList.grid.uiExtra do
						uiExtra[#uiExtra+1] = tUIList.grid.uiExtra[i]
					end
				end
				_childUI[sPageMode.."Grid"] = hUI.bagGrid:new(hApi.ReadParam(tUIList.grid,nil,{
					parent = pNode,
					align = "MC",
					grid = tCardGrid,
					animation = -1,
					item = {},
					slot = 0,
					num = 0,
					uiExtra = uiExtra,
					codeOnImageCreate = function(oGrid,nCardIndex,pSprite,gx,gy)
						if pUpdateFunc then
							return pUpdateFunc(tUIList,nCardIndex,oGrid,pSprite,gx,gy)
						end
					end,
					codeOnAutoRelease = tUIList.grid.codeOnAutoRelease,
				}))
			end
		end
		
		_childUI["rank_down"].handle._n:setVisible(false)
		_childUI["rank_up"].handle._n:setVisible(false)
	end
	----------------------------------------
	--初始化监听
	----------------------------------------
	do
		----------------------------------------
		--显示监听
		hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(state)
			if state == 1 then
				--没有网络时无法打开商店
				if hGlobal.WORLD.LastWorldMap and hGlobal.WORLD.LastWorldMap.ID~=0 then
					hGlobal.WORLD.LastWorldMap:del()
					hGlobal.WORLD.LastWorldMap = nil
				end
				--xlScene_LoadMap(g_PVP, "other/loading")
				--xlScene_Switch(g_PVP)
				hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
				_CODE_SwitchPageMode(1)
				_CODE_UpdateAllCard()
				_CODE_SwitchPageMode(_PVP_PageDefault)
				_CODE_LoadMyDeployment()
				_FrmBG:show(1)
				_FrmBG:active()
				--如果开启时未连接服务器，尝试连接
				if not(g_NetManager:isConnected()) then
					_PVP_LastPlayerList = nil
					g_NetManager:connectToGameServer(hVar.PVP_Add, 9023, luaGetplayerDataID())
				end
			elseif state == 0 then
				--_CODE_ExitFromPVP()
				_FrmBG:show(0)
				_CODE_SwitchPageMode(0)
				if hGlobal.NetBattlefield~=nil and hGlobal.LocalPlayer:getfocusworld()==hGlobal.NetBattlefield then
					--在战场内与服务器断开连接
					local oWorld = hGlobal.NetBattlefield
					if oWorld.data.PausedByWhat=="Disconnected" then
						--主动断开的
						hApi.PVPSaveCmdLog(oWorld,"disconnect")
						hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
						hApi.ClearNetBattlefield()
						hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
					else
						--莫名断开
						hApi.PVPSaveCmdLog(oWorld,"drop")
						hGlobal.NetBattlefield:pause(1,"Disconnected")
						
						hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Net_ERRO_2"],{
							font = hVar.FONTC,
							ok = function()
								--删除可能的投降对话框界面
								if hGlobal.UI.PhonePlayerTouXiangFrm then
									hGlobal.UI.PhonePlayerTouXiangFrm:del()
									hGlobal.UI.PhonePlayerTouXiangFrm = nil
								end
								
								--删除可能的pvp等待玩家的界面
								if hGlobal.UI.PhoneDelayPlayerFrm then
									hGlobal.UI.PhoneDelayPlayerFrm:del()
									hGlobal.UI.PhoneDelayPlayerFrm = nil
								end
								
								--删除可能的pvp结束界面
								if hGlobal.UI.__GameOverPanel_pvp then
									hGlobal.UI.__GameOverPanel_pvp:del()
									hGlobal.UI.__GameOverPanel_pvp = nil
								end
								
								--删除可能的响应时间过长框界面
								if hGlobal.UI.PhonePlayerNoHeartFrm then
									hGlobal.UI.PhonePlayerNoHeartFrm:del()
									hGlobal.UI.PhonePlayerNoHeartFrm = nil
								end
								
								hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
								hApi.ClearNetBattlefield()
								hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
							end,
						})
						xlAppAnalysis("pvp_net_erro_2",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-CT:"..tostring(os.date("%m%d%H%M%S")))
					end
				else
					--在战场外面与服务器断开连接
					hApi.ClearNetBattlefield(function(oWorld)
						if hGlobal.LocalPlayer:getfocusworld()==oWorld then
							hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
						end
					end)
					hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end
				--如果10秒内通过点击UI退出，随后收到断线消息，则认为是正常，否则视为异常断线
				--if hApi.gametime()-g_PVP_NetSaveData.MyExitOprTick>10000 then
					--xlAppAnalysis("pvp_net_erro_2",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-CT:"..tostring(os.date("%m%d%H%M%S")))
				--end
				--g_PVP_NetSaveData.MyExitOprTick = 0
				--hApi.ClearNetBattlefield(function(oWorld)
					----如果是从战场里面退出来的，补一个退出战场的事件
					--if hGlobal.LocalPlayer:getfocusworld()==oWorld then
						--hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
					--end
				--end)
				----if g_phone_mode == 0 then
				----	xlScene_Switch(g_playerlist)
				----	hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
				----else
					--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				----end
			end
		end)
		------------------------------------------
		--返回界面
		hGlobal.event:listen("LocalEvent_PlayerLeaveNetBattlefield","__BF__LeaveNetBattlefield",function()
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LEAVE_GAME)
			hGlobal.LocalPlayer:focusworld(nil)
			hApi.ClearNetBattlefield()
			hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_BF)	--脚本清理战场显存
			--xlScene_LoadMap(g_PVP, "other/loading")
			--xlScene_Switch(g_PVP)
			
			hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
			_CODE_UpdateAllCard()
			local oBtn = _childUI["btnPVPRoom1"]
			if oBtn.data.userdata==1 then
				_CODE_SwitchPageMode("DuelRoom")
				_CODE_SwitchRoom(_PVP_MyRoomID)
			else
				_CODE_SwitchPageMode("ChooseCard")
			end
			_FrmBG:show(1)
			_FrmBG:active()
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2LY_PLAYER_LIST)
			if g_current_scene~=g_PVP then
				--hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
				--xlScene_Switch(g_playerlist)
			end
			--if g_phone_mode ~= 0 then
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			--end
		end)
		----------------------------------------
		--允许/禁止pvp --btnPVPRoom1,btnPVPRoom2
		hGlobal.event:listen("LocalEvent_PVPEnable","__NB__Enable",function(nEnable)
			for i = 1,5 do
				local oBtn = _childUI["btnPVPRoom"..i]
				if oBtn then
					local nDisable = 1
					if nEnable~=1 then
						nDisable = 1
					elseif (g_PVP_NetSaveData.PVPSwitch["room"..i.."_enable"] or 0)~=0 then
						nDisable = 0
					end
					oBtn:setCheckBox(nDisable)
				end
			end
			local IsNoQuest = 0
			if #g_PVP_NetSaveData.PVPQuest<=0 then
				IsNoQuest = 1
			end
			_childUI["btnPVPQuest"]:setCheckBox(IsNoQuest)

			--排行榜开关判断
			if g_PVP_NetSaveData.PVPSwitch["Rank_enable"] then
				local nDisable = 1
				if g_PVP_NetSaveData.PVPSwitch["Rank_enable"] == 0 then
					nDisable = 1
				else
					nDisable = 0
				end
				_childUI["btnPVPRank"]:setCheckBox(nDisable)
			end
		end)
		hGlobal.event:listen("LocalEvent_PVPQuestUpdate","__NB__Enable",function()
			local IsNoQuest = 0
			if #g_PVP_NetSaveData.PVPQuest<=0 then
				IsNoQuest = 1
			end
			_childUI["btnPVPQuest"]:setCheckBox(IsNoQuest)
			_CODE_UpdateAllQuest(1)
		end)
		----------------------------------------
		--收到最后一次参战的数据表
		--hGlobal.event:listen("LocalEvent_NetBattleTeamData","__UpdateMyArmyAndTactics",function(tArmyList,tTacticsList)
			
		--end)
		-----------------------------------------
		--登陆成功尝试刷新列表
		local _pvp_TimeOutConnectTick = 0
		--PVP 连接上以后的经过时间
		local _pvp_passing_time = 0
		local _loop_UpdateConnectState = function(tick)
			if tick-_pvp_TimeOutConnectTick>0 then
				print("没有收到服务器的心跳包，掉线了！")
				hApi.clearTimer("__PVP__CheckIfDropped")
				local isConnect = g_NetManager:isConnected()

				_pvp_passing_time = tonumber(os.date("%H%M%S")) - _pvp_passing_time
				xlAppAnalysis("pvp_net_erro_1",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-PT:"..tostring(_pvp_passing_time).."-CT:"..tostring(os.date("%m%d%H%M%S")).."-S:"..tostring(isConnect))

				if isConnect then
					g_NetManager:disconnectFromGameServer()
				end
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Net_ERRO_1"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			end
		end
		local _nC2LUpdateQuestCount = 0		--C2L要求刷新任务(计数器)
		--登陆成功
		hGlobal.event:listen("LocalEvent_PVPLoginState","__NB___PVPLoginStateEx",function(nState)
			if nState==1 then
				_PVP_NpcUpdated = 0
				_PVP_RankKing = 0
				_PVP_ReplayUpdateTick = -99999
				_PVP_PageUI["DuelRoom"].myID = hGlobal.NET_DATA.LocalPlayerId
				_PVP_MyIcon = nil
				_nC2LUpdateQuestCount = 0
				_PVP_IAgreeRankRule = 0
				hGlobal.event:event("LocalEvent_PVPClientOnline")
				hApi.addTimerForever("__PVP__CheckIfDropped",hVar.TIMER_MODE.GAMETIME,1000,_loop_UpdateConnectState)
				_pvp_passing_time = tonumber(os.date("%H%M%S"))
			else
				hApi.clearTimer("__PVP__CheckIfDropped")
				hGlobal.event:event("LocalEvent_PVPMap",0)
			end
		end)
		----------------------------------------
		--收到心跳包,延长掉线时间
		hGlobal.event:listen("LocalEvent_PVPClientOnline","__NB_ClientOnline",function()
			if g_lua_src==1 then
				_pvp_TimeOutConnectTick = hApi.gametime() + 1000000
			else
				_pvp_TimeOutConnectTick = hApi.gametime() + 30000
			end
			_nC2LUpdateQuestCount = _nC2LUpdateQuestCount + 1
			if _FrmBG.data.show==1 and _PVP_PageMode=="PVPQuest" and _nC2LUpdateQuestCount>10 then
				_nC2LUpdateQuestCount = 0
				g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_QUEST,"0")
			end
		end)
		----------------------------------------
		--收到玩家数据时刷新列表(也会触发心跳计时器)
		local nMyAutoMatchTick = 0
		local _loop_UpdateAutoMatchTick = function()
			nMyAutoMatchTick = nMyAutoMatchTick + 1
			if _FrmBG.data.show==1 and _PVP_PageMode=="DuelRoom" then
				local sTick = string.format("%02d:%02d",math.floor(nMyAutoMatchTick/60),math.mod(nMyAutoMatchTick,60))
				_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["tick"]:setText(sTick,2)
			else
				hApi.clearTimer("__PVP__AutoMatchTimer")
				_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["tick"].handle._n:setVisible(false)
				_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["label"].handle._n:setVisible(true)
			end
		end

		hGlobal.event:listen("LocalEvent_PVPRoomPlayerListUpdate","__NB__UpdatePlayerListEx",function(tRoomList,IsEventFromUI)
			if IsEventFromUI~=1 then
				hGlobal.event:event("LocalEvent_PVPClientOnline")
			end
			_PVP_LastPlayerList = tRoomList
			local tTemp = _CODE_GetRoomListWithFilter(tRoomList,IsEventFromUI)
			local tList = {}
			if _PVP_MyRoomID==1 then
				--增加PVP_RANK_KING 上个赛季的竞技场冠军
				hApi.AddReplayToRoomList(hVar.PVP_PLAYER_STATE.RANK_KING,tList)
				--增加录像
				if hVar.OPTIONS.PVP_ROOM_FILTER==1 then
					hApi.AddReplayToRoomList(hVar.PVP_PLAYER_STATE.REPLAY,tList)
				end
			elseif _PVP_MyRoomID==2 then
				--增加可挑战的npc
				hApi.AddReplayToRoomList(hVar.PVP_PLAYER_STATE.NPC,tList)
			end
			for i = 1,#tTemp do
				tList[#tList+1] = tTemp[i]
			end
			_PVP_PageUI["DuelRoom"].player = hApi.ReadParamWithDepth(tList,nil,{index={}},3)
			if _PVP_PageMode=="DuelRoom" then
				_CODE_UpdateAllRoom()
				local nMyState
				for i = 1,#tList do
					if tList[i][hVar.PVP_PLAYER_DATA.ID]==_PVP_PageUI["DuelRoom"].myID then
						nMyState = tList[i][hVar.PVP_PLAYER_DATA.STATE]
					end
				end
				if _FrmBG.data.show==1 then
					local IsHaveArmy = 0
					for i = 1,#_PVP_ChooseArmy do
						if __PVP__UIFunc.IsArmyGrid(_PVP_ChooseArmy,i) then
							IsHaveArmy = 1
							break
						end
					end
					if IsHaveArmy~=1 then
						nMyState = -1
					end
					if nMyState~=_PVP_MyLastState then
						_PVP_MyLastState = nMyState
						if nMyState==hVar.PVP_PLAYER_STATE.AUTOMATCH then
							nMyAutoMatchTick = -1
							_loop_UpdateAutoMatchTick()
							hApi.addTimerForever("__PVP__AutoMatchTimer",hVar.TIMER_MODE.GAMETIME,1000,_loop_UpdateAutoMatchTick)
						else
							hApi.clearTimer("__PVP__AutoMatchTimer")
						end
						local nReadyState = 0
						if nMyState==hVar.PVP_PLAYER_STATE.BUSY then
							nReadyState = 1
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["tick"].handle._n:setVisible(false)
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["label"].handle._n:setVisible(true)
						elseif nMyState==hVar.PVP_PLAYER_STATE.FREE then
							nReadyState = 2
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["tick"].handle._n:setVisible(false)
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["label"].handle._n:setVisible(true)
						elseif nMyState==hVar.PVP_PLAYER_STATE.AUTOMATCH then
							nReadyState = 0
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["tick"].handle._n:setVisible(true)
							_PVP_FrmUIHandle["btnPVPAutoMatch"].childUI["label"].handle._n:setVisible(false)
						else
							nReadyState = 0
						end
						if _PVP_FrmUIHandle["btnPVPReady"].data.state~=-1 then
							if nReadyState==0 then
								_PVP_FrmUIHandle["btnPVPReady"]:setstate(0)
								_PVP_FrmUIHandle["imgPVPReady"]:setVisible(false)
								_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(true)
							elseif nReadyState==1 then
								_PVP_FrmUIHandle["btnPVPReady"]:setstate(1)
								_PVP_FrmUIHandle["imgPVPReady"]:setVisible(false)
								_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(true)
							elseif nReadyState==2 then
								_PVP_FrmUIHandle["btnPVPReady"]:setstate(1)
								_PVP_FrmUIHandle["imgPVPReady"]:setVisible(true)
								_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(false)
							end
						end
					end
				end
			end
		end)
		----------------------------------------
		--房间状态发生转换
		hGlobal.event:listen("LocalEvent_PVPRoomStateChanged","__ChangeState",function(nChallenge,nState,nReason,nMyRoomID)
			if nState==hVar.PVP_CHANLLENGE_STATE.ACTIVE then
				--对战开始，发送参战数据
				hApi.PVPC2CSendMyArmyAndTactics(nMyRoomID,_PVP_ChooseArmy,_PVP_ChooseTactics,g_PVP_NetSaveData.PVPSetChoosed)
				_CODE_SwitchPageMode(0)
				_FrmBG:show(0)
			end
		end)
		----------------------------------------
		--显示PVP面板
		hGlobal.event:listen("LocalEvent_ShowPVPFrm","__NB_ShowFrm",function(IsShow)
			if IsShow==1 then
				if _FrmBG.data.show==0 then
					_CODE_SwitchPageMode(_PVP_PageDefault)
					_FrmBG:show(1)
				end
			else
				if _FrmBG.data.show==1 then
					_CODE_SwitchPageMode(0)
					_FrmBG:show(0)
				end
			end
		end)
		-----------------------------------------
		--获取PVP配置
		hApi.PVPGetMyDeployment = function()
			return hApi.PVPFormatMyDeployment(_PVP_ChooseArmy,_PVP_ChooseTactics)
		end
		-----------------------------------------
		--切换PVP房间
		hApi.PVPSwitchRoom = function(nRoomID)
			if g_NetManager:isConnected() and nRoomID>=0 then
				--local nRoomID_old = _PVP_MyRoomID
				--_CODE_PlayerEnterRoom(nRoomID)
				if _PVP_MyRoomID~=nRoomID then
					_CODE_SwitchPageMode("DuelRoom")
					_CODE_SwitchRoom(nRoomID)
					if type(_PVP_LastPlayerList)=="table" and #_PVP_LastPlayerList==0 then
						hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",_PVP_LastPlayerList,1)
					end
					return 1
				elseif _PVP_PageMode~="DuelRoom" then
					_CODE_SwitchPageMode("DuelRoom")
					_CODE_SwitchRoom(nRoomID)
					if type(_PVP_LastPlayerList)=="table" and #_PVP_LastPlayerList==0 then
						hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",_PVP_LastPlayerList,1)
					end
					return 2
				end
			end
		end
		-----------------------------------------
		--切换PVP状态
		hApi.PVPSwitchMyState = function(sState)
			if g_NetManager:isConnected() and sState~=nil then
				_CODE_SwitchMyPVPState(sState,0)
			end
		end
		-------------------------------------------
		--当刷新所有卡片列表的时候，尝试读取默认配置
		hGlobal.event:listen("LocalEvent_PVPNetSaveOprResult","__PVPLoadMyDeployment",function(nResult,nResultID,nUnique,sData)
			_childUI["labPVPCoin"]:setText(tonumber(g_PVP_NetSaveData.PVPCoin),2)
			if nResultID==hVar.NET_SAVE_OPR_TYPE.L2C_UPDATE_ALL_ARMY_CARD and type(sData)=="string" and string.len(sData)>5 then
				_CODE_LoadMyDeployment()
			end
		end)
		----------------------------------------
		--ArmyCard刷新
		hGlobal.event:listen("Event_PVPNetSaveUpdateArmyCard","__UpdatePVPMap",function()
			local tUpdateI = {}
			local tUpdateID = {}
			local tArmyCardI = {}
			local tArmyCard = g_PVP_NetSaveData.ArmyCard
			local tUICard = _PVP_PageUI["ChooseCard"].card
			--找出不一样的卡片并刷新
			--生成信息看这个函数:_CODE_UpdateAllCard
			for i = 1,#tUICard do
				local v = tUICard[i]
				if v[1]=="unit" then
					local nCardID,nCardLv = v[4],v[5]
					tArmyCardI[nCardID] = i
				end
			end
			for i = 1,#tArmyCard do
				local nCardID = tArmyCard[i][1]
				local nCardI = tArmyCardI[nCardID]
				if nCardI then
					if __PVP__UIFunc.UpdateUICard(tUICard[nCardI],tArmyCard[i],1)~=nil then
						tUpdateI[nCardI] = 0
						tUpdateID[nCardID] = 1
					end
				else
					nCardI = #tUICard+1
					tUICard[nCardI] = __PVP__UIFunc.UpdateUICard({"unit"},tArmyCard[i])
				end
			end
			--刷新选择槽
			local UpdateChooseSlot = 0
			for i = 1,#_PVP_ChooseArmy do
				local v = _PVP_ChooseArmy[i]
				if __PVP__UIFunc.IsArmyGrid(_PVP_ChooseArmy,i) and hVar.tab_unit[v[1]].type==hVar.UNIT_TYPE.UNIT and tUpdateID[v[3] or 0]==1 then
					UpdateChooseSlot = 1
					local tCardA = hApi.PVPGetNetData("ArmyCard",v[3])
					if tCardA then
						local id,lv,xp,nUnitID,nUnitNum = unpack(tCardA)
						if nUnitNum>0 then
							v[1] = nUnitID
							v[2] = hApi.PVPGetArmyNumByCount(nUnitNum,v[4])
							v[5] = nUnitNum
						else
							_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("unit")
						end
					else
						_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("unit")
					end
				end
			end
			if UpdateChooseSlot==1 then
				_childUI["ArmyGrid"]:updateitem(_PVP_ChooseArmy)
			end
			--刷新卡片列表
			if _FrmBG.data.show==1 and _PVP_PageMode=="ChooseCard" then
				if _PVP_ChooseCardMode=="unit" then
					local tUpdate = {}
					for i = 1,#tUICard do
						if tUICard[i][1]=="unit" then
							if tUpdateI[i]==0 then
								local n = #tUpdate+1
								tUpdateI[i] = n
								tUpdate[n] = 0
							else
								tUpdate[#tUpdate+1] = {i}
							end
						end
					end
					local oGrid = _childUI["ChooseCardGrid"]
					oGrid:updateitem(tUpdate)
					for i = 1,#tUICard do
						if tUICard[i][1]=="unit" and tUpdateI[i] and tUpdateI[i]>0 then
							tUpdate[tUpdateI[i]] = {i}
						end
					end
					oGrid:updateitem(tUpdate)
				end
			end
		end)
	end
	----------------------------------------
	--初始化所有函数
	----------------------------------------
	do
		----------------------------------------
		--退出pvp
		_CODE_ExitFromPVP = function()
			if g_NetManager:isConnected() then
				g_PVP_NetSaveData.MyExitOprTick = hApi.gametime()
				g_NetManager:disconnectFromGameServer()
			else
				hGlobal.event:event("LocalEvent_PVPMap",0)
			end
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
		end
		----------------------------------------
		--上传我的头像
		_CODE_UploadMyIcon = function()
			if g_NetManager:isConnected() then
				local MyIcon = "icon:0;"
				for i = 1,#_PVP_ChooseArmy do
					local v = _PVP_ChooseArmy[i]
					if v~=0 then
						local id = v[1]
						local tabU = hVar.tab_unit[id]
						if tabU and tabU.type==hVar.UNIT_TYPE.HERO then
							if g_PVP_NetSaveData.PVPBannedHero[id]==1 then
								--被屏蔽的英雄不能作为头像
							else
								MyIcon = "icon:"..id..";"
								break
							end
						end
					end
				end
				if _PVP_MyIcon~=MyIcon then
					_PVP_MyIcon = MyIcon
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_PARAM,_PVP_MyIcon)
				end
			end
		end
		----------------------------------------
		--刷新玩家卡片信息
		_CODE_UpdateAllCard = function()
			local tUIList = _PVP_PageUI[_PVP_PageDefault]
			tUIList.card = {}
			local tCard = tUIList.card
			if Save_PlayerData and Save_PlayerData.herocard then
				local tHeroCard = Save_PlayerData.herocard
				for i = 1,#tHeroCard do
					local id = tHeroCard[i].id
					local lv = hApi.GetLevelByExp(tHeroCard[i].attr.exp)
					tCard[#tCard+1] = __PVP__UIFunc.UpdateUICard({"hero"},{id,lv})
				end
			end
			if 1==1 then
				local tArmyCard = g_PVP_NetSaveData.ArmyCard
				for i = 1,#tArmyCard do
					tCard[#tCard+1] = __PVP__UIFunc.UpdateUICard({"unit"},tArmyCard[i])
				end
			end
			if 1==1 then
				local tTacticsP = LuaGetPlayerSkillBook()
				if type(tTacticsP)=="table" then
					local tTacticsLv = {}
					for i = 1,#tTacticsP do
						if tTacticsP[i]~=0 then
							local id,lv = tTacticsP[i][1],tTacticsP[i][2]
							tTacticsLv[id] = math.max(tTacticsLv[id] or 0,lv)
						end
					end
					local tTacticsT = {}
					for i = 1,hVar.TACTICS_TYPE.OTHER do
						tTacticsT[i] = {}
					end
					for i = 1,#tTacticsP do
						if tTacticsP[i]~=0 then
							local id,lv = tTacticsP[i][1],tTacticsP[i][2]
							local tabT = hVar.tab_tactics[id]
							if tTacticsLv[id]==lv and tabT and (tabT.pvpshow or 1)==1 then
								local t = tTacticsT[tabT.type] or tTacticsT[#tTacticsT]
								t[#t+1] = {id,lv}
							end
						end
					end
					for i = 1,#tTacticsT do
						local v = tTacticsT[i]
						for j = 1,#v do
							tCard[#tCard+1] = __PVP__UIFunc.UpdateUICard({"tactics"},v[j])
						end
					end
				end
			end
		end
		----------------------------------------
		--刷新房间玩家信息
		local _UpdateOneRoomByPlayer = function(tPlayer,tRoomL,tRoomI)
			local id = tPlayer[hVar.PVP_PLAYER_DATA.ID]
			local param = tPlayer[hVar.PVP_PLAYER_DATA.PARAM]
			local state = tPlayer[hVar.PVP_PLAYER_DATA.STATE]
			local guest = tPlayer[hVar.PVP_PLAYER_DATA.GUEST]
			local host = tPlayer[hVar.PVP_PLAYER_DATA.HOST]
			local tick = tPlayer[hVar.PVP_PLAYER_DATA.TIME]
			local limit = tPlayer[hVar.PVP_PLAYER_DATA.LIMIT]
			local n = #tRoomL+1
			if state==hVar.PVP_PLAYER_STATE.FREE then
				tRoomI[id] = n
				tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
				tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = hVar.PVP_ROOM_STATE.READY
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param
			elseif state==hVar.PVP_PLAYER_STATE.BUSY then
				tRoomI[id] = n
				tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
				tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = hVar.PVP_ROOM_STATE.BUSY
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param
			elseif state==hVar.PVP_PLAYER_STATE.NPC then
				tRoomI[id] = n
				tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
				tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = hVar.PVP_ROOM_STATE.NPC
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param

			--为天梯房中的前三名打上“挑战”的标签	added by pangyong 2015/7/8
			elseif state==hVar.PVP_PLAYER_STATE.RANK_KING then
				tRoomI[id] = n
				tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
				tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = hVar.PVP_ROOM_STATE.NPC_RANK_KING
				tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param

			else
				local nRoomState = hVar.PVP_ROOM_STATE.BATTLE
				if state==hVar.PVP_PLAYER_STATE.REPLAY then
					nRoomState = hVar.PVP_ROOM_STATE.REPLAY
				end
				if tRoomI[host] then
					n = tRoomI[host]
					tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = nRoomState
					tRoomL[n][hVar.PVP_ROOM_DATA.GUEST] = id
					tRoomL[n][hVar.PVP_ROOM_DATA.GUEST_PARAM] = param
					tRoomL[n][hVar.PVP_ROOM_DATA.SERVER_TICK] = tick
				elseif tRoomI[guest] then
					n = tRoomI[guest]
					tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = nRoomState
					tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
					tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param
					tRoomL[n][hVar.PVP_ROOM_DATA.SERVER_TICK] = tick
				elseif guest==id then
					tRoomI[id] = n
					tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
					tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = nRoomState
					tRoomL[n][hVar.PVP_ROOM_DATA.GUEST] = id
					tRoomL[n][hVar.PVP_ROOM_DATA.GUEST_PARAM] = param
					tRoomL[n][hVar.PVP_ROOM_DATA.TICK] = tick
					tRoomL[n][hVar.PVP_ROOM_DATA.SERVER_TICK] = tick
				else
					tRoomI[id] = n
					tRoomL[n] = hApi.NumTable(hVar.PVP_ROOM_DATA.MAX_NUM)
					tRoomL[n][hVar.PVP_ROOM_DATA.STATE] = nRoomState
					tRoomL[n][hVar.PVP_ROOM_DATA.HOST] = id
					tRoomL[n][hVar.PVP_ROOM_DATA.HOST_PARAM] = param
					tRoomL[n][hVar.PVP_ROOM_DATA.TICK] = tick
					tRoomL[n][hVar.PVP_ROOM_DATA.SERVER_TICK] = tick
				end
			end
			tRoomL[n][hVar.PVP_ROOM_DATA.LIMIT] = limit
		end
		----------------------------------------
		--刷新房间显示时间
		local _code_UpdateOneRoomTick = function(nPlus,tRoom,oLabel)
			if not(tRoom[hVar.PVP_ROOM_DATA.HOST]>0 and tRoom[hVar.PVP_ROOM_DATA.GUEST]>0) then
				return
			end
			if tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.BATTLE then
				tRoom[hVar.PVP_ROOM_DATA.PAST] = tRoom[hVar.PVP_ROOM_DATA.PAST] + nPlus
				if tRoom[hVar.PVP_ROOM_DATA.TICK]~=tRoom[hVar.PVP_ROOM_DATA.SERVER_TICK] then
					tRoom[hVar.PVP_ROOM_DATA.PAST] = tRoom[hVar.PVP_ROOM_DATA.TICK]*1000+tRoom[hVar.PVP_ROOM_DATA.PAST]-tRoom[hVar.PVP_ROOM_DATA.SERVER_TICK]*1000
					tRoom[hVar.PVP_ROOM_DATA.TICK] = tRoom[hVar.PVP_ROOM_DATA.SERVER_TICK]
				end
				if oLabel then
					local v = tRoom[hVar.PVP_ROOM_DATA.LIMIT]*1000-(tRoom[hVar.PVP_ROOM_DATA.TICK]*1000+tRoom[hVar.PVP_ROOM_DATA.PAST])
					local sTick
					if v>0 then
						local tick = math.floor(v/1000)
						local mnt = string.format("%02d",math.floor(tick/60))
						local sec = string.format("%02d",math.mod(tick,60))
						sTick = mnt..":"..sec
					else
						sTick = "*"
					end
					if sTick~=oLabel.data.text then
						oLabel:setText(sTick,1)
					end
				end
			end
		end
		--倒计时
		local _code_CreateOneRoomTick = function(oGrid,tRoom,k,x,y)
			local sState,tRGB
			if tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.REPLAY then
				--看录像
				sState = hVar.tab_string["__TEXT_ViewReplay"]
				tRGB = {0,255,0}
			elseif tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.NPC then
				--NPC陪练
				sState = hVar.tab_string["__TEXT_ChallengeNPC"]
				tRGB = {0,255,0}
			elseif tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.NPC_RANK_KING then     --added by pangyong
				--精英挑战
				sState = hVar.tab_string["__TEXT_ChallengeRankKing"]
				tRGB = {0,255,0}
			elseif tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.BATTLE then
				oGrid.childUI[k] = hUI.label:new({
					parent = oGrid.handle._n,
					x = x,
					y = y-54,
					size = 20,
					text = "",
					align = "MC",
					font = "numWhite",
					z = 9,
				})
				_code_UpdateOneRoomTick(0,tRoom,oGrid.childUI[k])
			else
				if tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.READY then
					sState = hVar.tab_string["__TEXT_Waiting"]
					tRGB = {0,255,0}
				else
					--sState = hVar.tab_string["__TEXT_AFK"]
					--tRGB = {128,128,128}
				end
			end
			if sState then
				oGrid.childUI[k] = hUI.label:new({
					parent = oGrid.handle._n,
					x = x,
					y = y-55,
					size = 24,
					text = sState,
					align = "MC",
					font = hVar.FONTC,
					z = 9,
					border = 1,
					RGB = tRGB,
					width = 400,
				})
			end
		end
		local _LastUpdateTick = 0
		local _PlusNum = 0
		local _enum_UpdateOneRoomTick = function(_,gx,gy,_,oGrid,tRoomList)
			oGrid.data.count = oGrid.data.count + 1
			local oItem = oGrid.data.item[oGrid.data.count]
			if oItem and oItem~=0 then
				local tRoom = tRoomList[oItem[hVar.ITEM_DATA_INDEX.ID]]
				if tRoom then
					_code_UpdateOneRoomTick(_PlusNum,tRoom,oGrid.childUI["PlusUI"..gx.."|"..gy])
				end
			end
		end
		local _loop_UpdateAllRoom = function()
			if _FrmBG.data.show~=1 or _PVP_PageMode~="DuelRoom" then
				hApi.clearTimer("__PVP__UpdateRoomTick")
				return
			end
			_PlusNum = hApi.gametime() - _LastUpdateTick
			_LastUpdateTick = hApi.gametime()
			local oGrid = _childUI["DuelRoomGrid"]
			oGrid.data.count = 0
			hApi.EnumTable2V(oGrid.data.grid,_enum_UpdateOneRoomTick,oGrid,_PVP_PageUI["DuelRoom"].room)
			oGrid.data.count = 0
		end
		local _code_SetNPCPlayerID = function(tPlayer,tTemp)
			tTemp.id = tTemp.id - 1
			local nPlayerID = tTemp.id
			tPlayer[hVar.PVP_PLAYER_DATA.ID] = nPlayerID
			local nOwner = tPlayer[hVar.PVP_PLAYER_DATA.NPC]
			local nState = tPlayer[hVar.PVP_PLAYER_DATA.STATE]
			local nReplay = tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE]
			if tTemp[nState]==nil then
				tTemp[nState] = {}
			end
			if tTemp[nState][nReplay]==nil then
				tTemp[nState][nReplay] = {0,0}
			end
			tTemp[nState][nReplay][nOwner] = nPlayerID
		end
		local _code_SetNPCRoomData = function(tPlayer,tTemp)
			local nState = tPlayer[hVar.PVP_PLAYER_DATA.STATE]
			local nReplay = tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE]
			if tTemp[nState][nReplay]~=nil then
				tPlayer[hVar.PVP_PLAYER_DATA.HOST] = tTemp[nState][nReplay][1]
				tPlayer[hVar.PVP_PLAYER_DATA.GUEST] = tTemp[nState][nReplay][2]
			end
		end
		_CODE_UpdateAllRoom = function()
			local tUIList = _PVP_PageUI["DuelRoom"]
			local tPlayer = tUIList.player
			local oGrid = _childUI["DuelRoomGrid"]
			local tRoomI = {}
			local tRoomL = {}
			local tTemp = {id=0}
			local tRoomOld = tUIList.room

			--分析NPC对决
			for i = 1,#tPlayer do
				if tPlayer[i][hVar.PVP_PLAYER_DATA.NPC]~=0 then
					_code_SetNPCPlayerID(tPlayer[i],tTemp)
				end
			end
			--如果发现NPC，那么设置NPC对决房间号
			if tTemp.id~=0 then
				for i = 1,#tPlayer do
					if tPlayer[i][hVar.PVP_PLAYER_DATA.NPC]~=0 then
						_code_SetNPCRoomData(tPlayer[i],tTemp)
					end
				end
			end

			--设置玩家索引
			for i = 1,#tPlayer do
				local nID = tPlayer[i][hVar.PVP_PLAYER_DATA.ID]
				tPlayer.index[nID] = i
			end

			--添加NPC房间(limit大于0的会优先显示)
			if tTemp.id~=0 then
				for i = 1,#tPlayer do
					local v = tPlayer[i]
					if v[hVar.PVP_PLAYER_DATA.NPC]~=0 and v[hVar.PVP_PLAYER_DATA.LIMIT]>0 then
						_UpdateOneRoomByPlayer(v,tRoomL,tRoomI)
					end
				end
			end

			--添加自己的数据
			for i = 1,#tPlayer do
				local v = tPlayer[i]
				if v[hVar.PVP_PLAYER_DATA.ID]==tUIList.myID and v[hVar.PVP_PLAYER_DATA.NPC]==0 then
					_UpdateOneRoomByPlayer(v,tRoomL,tRoomI)
					break
				end
			end

			--添加NPC房间
			if tTemp.id~=0 then
				for i = 1,#tPlayer do
					local v = tPlayer[i]
					if v[hVar.PVP_PLAYER_DATA.NPC]~=0 and v[hVar.PVP_PLAYER_DATA.LIMIT]<=0 then
						_UpdateOneRoomByPlayer(v,tRoomL,tRoomI)
					end
				end
			end

			--显示对决状态的玩家
			for i = 1,#tPlayer do
				local v = tPlayer[i]
				if v[hVar.PVP_PLAYER_DATA.ID]~=tUIList.myID and v[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.IN_BATTLE and v[hVar.PVP_PLAYER_DATA.NPC]==0 then
					_UpdateOneRoomByPlayer(v,tRoomL,tRoomI)
				end
			end

			--显示非对决状态的玩家
			for i = 1,#tPlayer do
				local v = tPlayer[i]
				if v[hVar.PVP_PLAYER_DATA.ID]~=tUIList.myID and v[hVar.PVP_PLAYER_DATA.STATE]~=hVar.PVP_PLAYER_STATE.IN_BATTLE and v[hVar.PVP_PLAYER_DATA.NPC]==0 then
					_UpdateOneRoomByPlayer(v,tRoomL,tRoomI)
				end
			end

			--检查一下，如果房间状态是battle但是有人退出来了，设置为busy
			for i = 1,#tRoomL do
				local v = tRoomL[i]
				if v[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.BATTLE and (v[hVar.PVP_ROOM_DATA.HOST]==0 or v[hVar.PVP_ROOM_DATA.GUEST]==0) then
					v[hVar.PVP_ROOM_DATA.STATE] = hVar.PVP_ROOM_STATE.BUSY
				end
			end

			--开始刷房间
			local tUpdate = {}
			local NeedUpdate = 0
			for i = 1,math.max(#tRoomL,#tRoomOld) do
				if __PVP__UIFunc.IsEqual(tRoomOld[i],tRoomL[i],hVar.PVP_ROOM_DATA.CHECK_NUM)==1 then
					tUpdate[i] = {i}
					if tRoomOld[i]~=0 then
						tRoomOld[i][hVar.PVP_ROOM_DATA.SERVER_TICK] = tRoomL[i][hVar.PVP_ROOM_DATA.SERVER_TICK]
					end
				else
					tUpdate[i] = 0
					NeedUpdate = 1
				end
			end

			if NeedUpdate==1 then
				tUIList.room = tRoomL
				oGrid:updateitem(tUpdate)
				for i = 1,#tRoomL do
					if (tUpdate[i] or 0)==0 then
						tUpdate[i] = {i}
					end
				end
				oGrid:updateitem(tUpdate)
				local x,y = tUIList.grid.x,tUIList.grid.y
				local w,h = tUIList.cliprect[3],tUIList.cliprect[4]
				local ox,oy = 0,tUIList.autoalign[5]
				hUI.SetDragRectForGrid("V",tUIList.dragable,oGrid,x,y,w,h,ox,oy,tUIList.room)
			end
		end
		----------------------------------------
		--创建房间显示
		_CODE_UpdateRoomItem = function(self,nRoomIndex,oGrid,pNode,gx,gy)
			local tRoom = self.room[nRoomIndex]
			if tRoom then
				local nMyID = _PVP_PageUI["DuelRoom"].myID
				local tPlayerList = _PVP_PageUI["DuelRoom"].player	--tPlayerList中包含有一个roomcad表，表的每一项包含12或13（精英中添加了一个排名信息）玩家属性（hVar.PVP_PLAYER_DATA）
				local nPlayerId = tRoom[hVar.PVP_ROOM_DATA.HOST]
				if nPlayerId==0 then
					nPlayerId = tRoom[hVar.PVP_ROOM_DATA.GUEST]
				end
				local tHost = tPlayerList[tPlayerList.index[nPlayerId]]
				local tUITemplate
				if tHost and type(tHost[hVar.PVP_PLAYER_DATA.EXTRA])=="table" then
					tUITemplate = hUI.GetUITemplate(tHost[hVar.PVP_PLAYER_DATA.EXTRA][1])
				end
				if tUITemplate==nil then
					tUITemplate = hUI.GetUITemplate("roomcard")
				end
				hUI.CreateMultiUIByParam(pNode,0,0,tUITemplate[1],{},__PVP__UIInitParam:get("roomcard",tRoom,nMyID,tPlayerList))
				local x,y = pNode:getPosition()
				_code_CreateOneRoomTick(oGrid,tRoom,"PlusUI"..gx.."|"..gy,x,y)
			end
		end
		----------------------------------------
		--刷新任务
		local _code_ConfirmPVPQuest = function(nQuestI)
			g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_QUEST,"qst:"..nQuestI..";")
		end
		_CODE_UpdatePVPQuest = function(self,nQuestI,oGrid,pNode,gx,gy)
			local tQuest = g_PVP_NetSaveData.PVPQuest[nQuestI]
			if tQuest==nil then
				return
			end
			if 1==1 then
				local v = hUI.GetUITemplate("questitem")
				hUI.CreateMultiUIByParam(pNode,-370,70,v[1],{},v[2].GetParam(tQuest))
				local nx,ny = pNode:getPosition()
				oGrid.childUI["btnConfirm"..gx.."|"..gy] = v[2].AddRewardBtn(_FrmBG,oGrid,nx-370+688,ny-16,tQuest,nQuestI,_code_ConfirmPVPQuest)
			end
			local tReward = tQuest[hVar.PVP_QUEST_DATA.REWARD]
			if type(tReward)=="table" and #tReward>0 then
				local tPos = _PVP_PageUI["PVPQuest"].grid.iconXYWH
				local tIconXYWH = tPos[math.min(#tReward,#tPos)]
				if tIconXYWH then
					local v = hUI.GetUITemplate("bagitem")
					for i = 1,#tIconXYWH do
						local x = tIconXYWH[i][1]+tIconXYWH[i][3]/2-oGrid.data.gridW/2
						local y = tIconXYWH[i][2]-tIconXYWH[i][4]/2+oGrid.data.gridH/2
						local oItem = tReward[i]
						if type(oItem)=="table" then
							hUI.CreateMultiUIByParam(pNode,x,y,v[1],{},v[2].GetParam(oItem,1))
						end
					end
				end
			end
		end
		_CODE_UpdateAllPVPQuestBtn = function()
			local oGrid = _childUI["PVPQuestGrid"]
			local tRect = _PVP_PageUI["PVPQuest"].cliprect
			for i = 1,#oGrid.data.item do
				local oBtn = oGrid.childUI["btnConfirm0|"..(i-1)]
				if oBtn then
					oBtn.data.ox = oGrid.data.x
					oBtn.data.oy = oGrid.data.y
					_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
					if oBtn.data.model=="Action:button_gift" then
						if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy,tRect) then
							oBtn.data.state = 1
						else
							oBtn.data.state = 0
						end
					end
				end
			end
		end
		_CODE_ShowPVPQuestRewardTip = function(screenX,screenY)
			local x,y = screenX-_FrmBG.data.x,screenY-_FrmBG.data.y
			local oGrid = _childUI["PVPQuestGrid"]
			local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
			if oItem then
				local tQuest = g_PVP_NetSaveData.PVPQuest[gy + 1]
				if type(tQuest)=="table" then
					local tReward = tQuest[hVar.PVP_QUEST_DATA.REWARD]
					if type(tReward)=="table" and #tReward>0 then
						local tPos = _PVP_PageUI["PVPQuest"].grid.iconXYWH
						local tIconXYWH = tPos[math.min(#tReward,#tPos)]
						if tIconXYWH then
							local nItemI
							local bx,by = oGrid:grid2xy(gx,gy)
							local tx = screenX-_FrmBG.data.x-oGrid.data.x-bx+(oGrid.data.gridW/2)
							local ty = screenY-_FrmBG.data.y-oGrid.data.y-by-(oGrid.data.gridH/2)
							for i = 1,#tIconXYWH do
								if hApi.IsInBox(tx,ty,tIconXYWH[i]) then
									nItemI = i
									break
								end
							end
							if nItemI and type(tReward[nItemI])=="table" then
								hUI.GetUITemplate("bagitem")[2].ShowItemTip(tReward[nItemI])
							end
						end
					end
				end
			end
		end
		----------------------------------------
		local _pvp_RankData = {}
		--网络消息回调的 排行榜数据
		hGlobal.event:listen("LocalEvent_PVPNetRankUpdata","rankUpdata",function(rank_data,self_data)
			--_rank_data = rank_data
			_pvp_RankData = hUI.GetUITemplate("rankitem")[2].FormatRankData(rank_data)

			_childUI["rank_MyRank"]:setText(self_data[1])
			local nMyRank = tonumber(self_data[1])
			local nCurRank = LuaPVP_GetRankNum("curN")
			local nLastRank = LuaPVP_GetRankNum("lastN")
			
			--排名变化
			--if nMyRank~=nCurRank then
				nLastRank = nCurRank
				nCurRank = nMyRank
				LuaPVP_SetRankNum(nCurRank,"curN")
				LuaPVP_SetRankNum(nLastRank,"lastN")
			--end
			
			--天梯值 变化
			local nMyElo = tonumber(self_data[5])
			local nCurElo = LuaPVP_GetRankNum("curE")
			local nLastElo = LuaPVP_GetRankNum("lastE")

			if nMyElo ~= nCurElo then
				nLastElo = nCurElo
				nCurElo = nMyElo
				LuaPVP_SetRankNum(nCurElo,"curE")
				LuaPVP_SetRankNum(nLastElo,"lastE")
			end
			if nLastRank == 0 then
				_childUI["rank_down"].handle._n:setVisible(false)
				_childUI["rank_up"].handle._n:setVisible(true)
			elseif nCurRank > nLastRank then
				_childUI["rank_down"].handle._n:setVisible(true)
				_childUI["rank_up"].handle._n:setVisible(false)
			elseif nCurRank < nLastRank then
				_childUI["rank_down"].handle._n:setVisible(false)
				_childUI["rank_up"].handle._n:setVisible(true)
			elseif nCurRank == nLastRank then
				if nCurElo > nLastElo then
					_childUI["rank_down"].handle._n:setVisible(false)
					_childUI["rank_up"].handle._n:setVisible(true)
				elseif nCurElo < nLastElo then
					_childUI["rank_down"].handle._n:setVisible(true)
					_childUI["rank_up"].handle._n:setVisible(false)
				end
			end

			_childUI["rank_MyStrength"]:setText(self_data[5])
			_childUI["PlayerRankGrid"]:updateitem(rank_data)--{{5000},{5001},{5002},{5003},{5006},{5007},{5008},{5008},{5008},{5008},{5008},{5008},{5008},{5008},{5008},{5008},{5008}})
			
			local tUIList = _PVP_PageUI["PlayerRank"]
			local ggx,ggy = tUIList.grid.x,tUIList.grid.y
			local ggw,ggh = tUIList.cliprect[3],tUIList.cliprect[4]
			local ox,oy = 0,tUIList.autoalign[5]
			hUI.SetDragRectForGrid("V",tUIList.dragable,_childUI["PlayerRankGrid"],ggx,ggy,ggw,ggh,ox,oy,rank_data)
		end)
		
		local _pvp_RankInitParam = {
			RankData = nil,
			ModelFunc = function(self,tData)
				return tData[1](self.RankData,tData[2],tData[3])
			end,
		}
		--刷新排行榜
		_CODE_UpdatePlayerRank = function(self,nIndex,oGrid,pNode,gx,gy)
			if _pvp_RankData[nIndex] then
				_pvp_RankInitParam.RankData = _pvp_RankData[nIndex]
				hUI.CreateMultiUIByParam(pNode,0,0,hUI.GetUITemplate("rankitem")[1],{},_pvp_RankInitParam)
			end
		end
		---------------------------------------
		--读取我上一次使用的兵种配置
		_CODE_LoadMyDeployment = function()
			if type(g_PVP_NetSaveData.PVPDeploy)=="string" and g_PVP_NetSaveData.NetSaveData~="" then
				local sDeployment = g_PVP_NetSaveData.PVPDeploy
				--g_PVP_NetSaveData.PVPDeploy = 0
				_PVP_ChooseArmy = __PVP__UIFunc.CreateArmyCardSlot(_PVP_ChooseDefine)
				_PVP_ChooseTactics = __PVP__UIFunc.CreateTacticsCardSlot(_PVP_ChooseDefine)
				local nHeroCount = 0
				for i,typ,id,ex in string.gfind(sDeployment,"amy:([%d]+):([%d]+):([%d]+):([%d]+);") do
					i = tonumber(i)
					typ = tonumber(typ)
					id = tonumber(id)
					ex = tonumber(ex)
					if i>0 and i<=#_PVP_ChooseArmy then
						if typ==hVar.NET_BF_DATA_TYPE.HERO then
							nHeroCount = nHeroCount + 1
							_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("hero")
							if hApi.GetHeroCardById(id) then
								local v = _PVP_ChooseArmy[i]
								v[1] = id
								v[2] = 1
							end
						elseif typ==hVar.NET_BF_DATA_TYPE.ARMYCARD then
							_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("unit")
							local v = _PVP_ChooseArmy[i]
							local tCardA = hApi.PVPGetNetData("ArmyCard",id)
							if tCardA and tCardA[2]>0 then
								local _,lv,xp,nUnitID,nUnitNum = unpack(tCardA)
								if nUnitNum>0 then
									v[1] = nUnitID
									v[2] = hApi.PVPGetArmyNumByCount(nUnitNum,ex)
									v[3] = id
									v[4] = ex
									v[5] = nUnitNum
								end
							end
						end
					end
				end
				for i = 1,#_PVP_ChooseArmy do
					if _PVP_ChooseArmy[i][1]==2 then
						nHeroCount = nHeroCount + 1
					end
				end
				if nHeroCount>2 then
					for i = 1,#_PVP_ChooseArmy do
						if nHeroCount>2 and _PVP_ChooseArmy[i][1]==2 then
							nHeroCount = nHeroCount - 1
							_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("unit")
						end
					end
				elseif nHeroCount<2 then
					for i = 1,#_PVP_ChooseArmy do
						if nHeroCount<2 and _PVP_ChooseArmy[i][1]==1 then
							nHeroCount = nHeroCount + 1
							_PVP_ChooseArmy[i] = __PVP__UIFunc.CreateCardSlot("hero")
						end
					end
				end
				local tCard = _PVP_PageUI[_PVP_PageDefault].card
				for i,id,_ in string.gfind(sDeployment,"tac:([%d]+):([%d]+):([%d]+);") do
					i = tonumber(i)
					id = tonumber(id)
					if i>0 and i<=#_PVP_ChooseTactics then
						if id>0 then
							for n = 1,#tCard do
								local v = tCard[n]
								if v[1]=="tactics" and v[2]==id then
									_PVP_ChooseTactics[i][1] = v[2]
									_PVP_ChooseTactics[i][2] = v[3]
								end
							end
						end
					end
				end
				_childUI["ArmyGrid"]:updateitem(_PVP_ChooseArmy)
				_childUI["TacticsGrid"]:updateitem(_PVP_ChooseTactics)
			end
		end

		----------------------------------------
		--切换我的pvp状态
		_CODE_SwitchMyPVPState = function(sMyState,IsRequireList)
			if g_NetManager:isConnected() then
				local tUIList = _PVP_PageUI["DuelRoom"]
				local tPlayer = tUIList.player[tUIList.player.index[tUIList.myID] or 0]
				if tPlayer==nil then
					print("没有你这号玩家")
					return
				end
				if sMyState=="switch|ready" then
					if tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.FREE then
						sMyState = "notready"
					elseif tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.BUSY then
						sMyState = "ready"
					else
						print("未知状态,切换至繁忙状态")
					end
				elseif sMyState=="switch|automatch" then
					if tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.AUTOMATCH then
						sMyState = "notready"
					else
						sMyState = "automatch"
					end
				end
				if sMyState=="ready" then
					local tMyDeployment = {army=_PVP_ChooseArmy,tactics=_PVP_ChooseTactics}
					if hApi.PVPCheckMyDeployment(tMyDeployment)==hVar.RESULT_SUCESS then
						g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_STATE,hVar.PVP_PLAYER_STATE.FREE)
					else
						hGlobal.event:event("LocalEvent_PVPShowChallengeFrm",0,{army=_PVP_ChooseArmy,tactics=_PVP_ChooseTactics})
					end
				elseif sMyState=="automatch" then
					local tMyDeployment = {army=_PVP_ChooseArmy,tactics=_PVP_ChooseTactics}
					if hApi.PVPCheckMyDeployment(tMyDeployment)==hVar.RESULT_SUCESS then
						g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_STATE,hVar.PVP_PLAYER_STATE.AUTOMATCH)
					else
						hGlobal.event:event("LocalEvent_PVPShowChallengeFrm",0,{army=_PVP_ChooseArmy,tactics=_PVP_ChooseTactics})
					end
				else
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_STATE,hVar.PVP_PLAYER_STATE.BUSY)
				end
				if IsRequireList~=0 then
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2LY_PLAYER_LIST)
				end
			end
		end
		----------------------------------------
		--创建卡片UI
		_CODE_UpdateCardItem = function(self,nCardIndex,oGrid,pNode)
			local tCard = self.card[nCardIndex]
			if tCard then
				__PVP__UIFunc.DrawCardUI(tCard,pNode,0,0)
			end
		end
		-----------------------------------------
		--显示卡片提示
		_CODE_ShowCardItemHint = function(tCard)
			if tCard[1]=="unit" or tCard[1]=="hero" then
				local nUnitID = tCard[2]
				local tabU = hVar.tab_unit[nUnitID]
				if tabU then
					if tabU.type==hVar.UNIT_TYPE.HERO then
						hGlobal.event:event("LocalEvent_showHeroCardFrm",nil,nUnitID)
					else
						hGlobal.event:event("LocalEvent_ShowPVPArmyCardInfoFrm",tCard[4])
						--hGlobal.event:event("LocalEvent_ShowUnitInfoFram",nil,nUnitID,150,600)
					end
				end
			elseif tCard[1]=="tactics" then
				local nTacticsID = tCard[2]
				local nTacticsLv = tCard[3]
				local tabT = hVar.tab_tactics[nTacticsID]
				if tabT then
					hGlobal.event:event("localEvent_ShowPhoneBattlefieldSkillGameInfoFrm",nTacticsID,nTacticsLv,300,600,1,0)
				end
			end
		end
		----------------------------------------
		--ArmyGrid操作函数
		local _code_ArmyGridShift = function(tArmy,nFrom,nTo)
			if nFrom~=nTo then
				local a = tArmy[nFrom]
				local b = tArmy[nTo]
				tArmy[nFrom] = b
				tArmy[nTo] = a
			end
		end
		local _code_ArmyGridRemoveOne = function(tArmy,nIndex)
			if __PVP__UIFunc.IsArmyGrid(tArmy,nIndex) then
				local nUnitID = tArmy[nIndex][1]
				local tabU = hVar.tab_unit[nUnitID]
				if tabU.type==hVar.UNIT_TYPE.HERO then
					tArmy[nIndex] = __PVP__UIFunc.CreateCardSlot("hero")
				else
					local nCardID = tArmy[nIndex][3]
					local nCount = tArmy[nIndex][4]
					tArmy[nIndex] = __PVP__UIFunc.CreateCardSlot("unit")
					for i = 1,#tArmy do
						if __PVP__UIFunc.IsArmyGrid(tArmy,i) and tArmy[i][3]==nCardID and tArmy[i][4]>nCount then
							tArmy[i][4] = tArmy[i][4]-1
							tArmy[i][2] = hApi.PVPGetArmyNumByCount(tArmy[i][5],tArmy[i][4])
						end
					end
				end
			end
		end
		local _code_ArmyGridRestoreSlot = function(tArmy,nIndex,a,b)
			if tArmy[nIndex]~=0 and tArmy[nIndex][1]==a then
				for i = 1,#tArmy do
					if i~=nIndex and tArmy[i]~=0 and tArmy[i][1]==b then
						tArmy[i][1] = a
						break
					end
				end
			end
		end
		local _code_ArmyGridCheckInsert = function(tArmy,nIndex,nUnitType)
			local nHeroCount = 0
			local nUnitCount = 0
			local nArmyCount = 0
			local nIsSameType = 0
			for i = 1,#tArmy do
				if __PVP__UIFunc.IsArmyGrid(tArmy,i) then
					nArmyCount = nArmyCount + 1
					local tabU = hVar.tab_unit[tArmy[i][1]]
					if tabU.type==hVar.UNIT_TYPE.HERO then
						nHeroCount = nHeroCount + 1
					else
						nUnitCount = nUnitCount + 1
					end
					if i==nIndex and tabU.type==nUnitType then
						nIsSameType = 1
					end
				end
			end
			if nIsSameType==1 then
				--相同类型可以替换
				return 1
			elseif nUnitType==hVar.UNIT_TYPE.HERO then
				if nHeroCount<_PVP_ChooseDefine.hero then
					return 1
				end
			elseif nUnitType==hVar.UNIT_TYPE.UNIT then
				if nUnitCount<_PVP_ChooseDefine.unit then
					return 1
				end
			end
		end
		local _code_ArmyGridInsertHero = function(tArmy,nIndex,id)
			_code_ArmyGridRestoreSlot(tArmy,nIndex,1,2)
			tArmy[nIndex] = {id,1,0,0,0}
		end
		local _code_ArmyGridInsertUnit = function(tArmy,nIndex,id,num,nCardID)
			_code_ArmyGridRestoreSlot(tArmy,nIndex,2,1)
			local nCount = 0
			for i = 1,#tArmy do
				if i~=nIndex and tArmy[i]~=0 and tArmy[i][3]==nCardID then
					nCount = nCount + 1
				end
			end
			tArmy[nIndex] = {id,0,nCardID,nCount,num}
			tArmy[nIndex][2] = hApi.PVPGetArmyNumByCount(tArmy[nIndex][5],tArmy[nIndex][4])
		end
		----------------------------------------
		--刷新选择单位Grid
		_CODE_UpdateArmyGrid = function(tCard,nFrom,nTo)
			local tArmy = _PVP_ChooseArmy
			if nFrom and nTo then
				if nFrom~=0 then
					--交换/丢弃兵种
					if tArmy[nFrom] and tArmy[nFrom]~=0 then
						if nTo~=0 and tArmy[nTo] then
							_code_ArmyGridShift(tArmy,nFrom,nTo)
						else
							_code_ArmyGridRemoveOne(tArmy,nFrom)
						end
					end
				else
					--插入兵种
					if tCard and tCard~=0 and nTo~=0 and tArmy[nTo] then
						local nInsert = nTo
						local typ,id,num,nCardID = tCard[1],tCard[2],tCard[3],tCard[4]
						if typ=="hero" then
							--英雄先要判断是否需要进行交换
							local nShift = 0
							for i = 1,#tArmy do
								if __PVP__UIFunc.IsArmyGrid(tArmy,i) and tArmy[i][1]==id then
									nShift = i
									break
								end
							end
							if nShift~=0 then
								--交换位置模式
								_code_ArmyGridShift(tArmy,nShift,nInsert)
							else
								--替换该格子上的单位
								if __PVP__UIFunc.IsArmyGrid(tArmy,nInsert) and tArmy[nInsert][1]==id then
									--塞同样id的英雄不处理
								elseif _code_ArmyGridCheckInsert(tArmy,nInsert,hVar.UNIT_TYPE.HERO)==1 then
									--被屏蔽的英雄使用时，提示将被强行替换为空位
									if g_PVP_NetSaveData.PVPBannedHero[id]==1 then
										local sHeroName = hVar.tab_stringU[id][1] or "hero_"..id
										hGlobal.UI.MsgBox(string.gsub(hVar.tab_string["__TEXT_PVP_HERO_DISABLED"],"#NAME#",sHeroName))
									end
									_code_ArmyGridRemoveOne(tArmy,nInsert)
									_code_ArmyGridInsertHero(tArmy,nInsert,id)
								end
							end
						elseif typ=="unit" then
							--替换该格子上的单位
							if __PVP__UIFunc.IsArmyGrid(tArmy,nInsert) and tArmy[nInsert][4]==nCardID then
								--塞同样CardID的单位不处理
							elseif _code_ArmyGridCheckInsert(tArmy,nInsert,hVar.UNIT_TYPE.UNIT)==1 then
								_code_ArmyGridRemoveOne(tArmy,nInsert)
								_code_ArmyGridInsertUnit(tArmy,nInsert,id,num,nCardID)
							end
						end
					end
				end
			end
			_childUI["ArmyGrid"]:updateitem(tArmy)
		end
		----------------------------------------
		--刷新选择战术卡Grid
		_CODE_UpdateTacticsGrid = function(tCard,nFrom,nTo)
			local tTactics = _PVP_ChooseTactics
			if nFrom and nTo then
				if nFrom~=0 then
					--交换/丢弃卡片
					if tTactics[nFrom] then
						if nTo~=0 and tTactics[nTo] then
							if nFrom~=nTo then
								local a = tTactics[nFrom]
								local b = tTactics[nTo]
								tTactics[nFrom] = b
								tTactics[nTo] = a
							end
						else
							if tTactics[nFrom]~=0 then
								tTactics[nFrom][1] = 1
								tTactics[nFrom][2] = 0
							end
						end
					end
				else
					if tCard and tCard~=0 and nTo and tTactics[nTo] then
						local nInsert = nTo
						local typ,id,lv = tCard[1],tCard[2],tCard[3]
						--同类卡片限制
						local nMyType = hVar.tab_tactics[id].type
						local nLimitCount = hVar.PVP_TACTICS_CARD_CLASS_LIMIT
						for i = 1,#tTactics do
							if __PVP__UIFunc.IsTacticsGrid(tTactics,i) and i~=nTo then
								local tabT = hVar.tab_tactics[tTactics[i][1]]
								if tabT and tabT.type==nMyType then
									nLimitCount = nLimitCount - 1
								end
								if nLimitCount<=0 then
									return
								end
							end
						end
						if typ=="tactics" then
							local nShift = 0
							for i = 1,#tTactics do
								if __PVP__UIFunc.IsTacticsGrid(tTactics,i) and tTactics[i][1]==id then
									nShift = i
									break
								end
							end
							if nShift~=0 then
								if nShift~=nInsert then
									local a = tTactics[nShift]
									local b = tTactics[nInsert]
									tTactics[nShift] = b
									tTactics[nInsert] = a
								end
							else
								--如果放置在已有单位的槽子上
								if tTactics[nInsert]~=0 then
									tTactics[nInsert][1] = id
									tTactics[nInsert][2] = lv
								end
							end
						end
					end
				end
			end
			_childUI["TacticsGrid"]:updateitem(tTactics)
		end
		----------------------------------------
		--开启/隐藏页面UI
		_CODE_EnablePageUI = function(sPageMode,enable)
			local tUIList = _PVP_PageUI[sPageMode]
			if tUIList then
				local bEnbale,nEnable,cEnable
				if enable==0 then
					bEnbale = false
					nEnable = -1
					cEnable = ccc3(128,128,128)
				else
					bEnbale = true
					nEnable = 1
					cEnable = ccc3(255,255,255)
				end
				_childUI[sPageMode.."Grid"].handle._n:setVisible(bEnbale)
				if type(tUIList.tag)=="table" then
					for i = 1,#tUIList.tag do
						_childUI[tUIList.tag[i]].handle.s:setColor(cEnable)
					end
				end
				if type(tUIList.btn)=="table" then
					for i = 1,#tUIList.btn do
						_PVP_FrmUIHandle[tUIList.btn[i]]:setstate(nEnable)
					end
				end
				if type(tUIList.img)=="table" then
					for i = 1,#tUIList.img do
						_PVP_FrmUIHandle[tUIList.img[i]]:setVisible(bEnbale)
					end
				end
				if type(tUIList.ui)=="table" then
					for i = 1,#tUIList.ui do
						_childUI[tUIList.ui[i]].handle._n:setVisible(bEnbale)
					end
				end
				if type(tUIList.clipnode)=="table" then
					hApi.EnableClipNode(tUIList.clipnode,nEnable)
				end
			end
		end
		----------------------------------------
		--切换显示模式
		local _pvp_ChooseTacticsDefault
		local _pvp_ChooseArmyDefault
		_CODE_SwitchPageMode = function(sPageMode)
			if type(sPageMode)~="string" then
				_PVP_PageMode = 0
				_PVP_MyRoomID = 0
				for sModeName,tUIList in pairs(_PVP_PageUI) do
					_CODE_EnablePageUI(sModeName,0)
				end
				_PVP_PageUI["ChooseCard"].card = {}
				_PVP_PageUI["DuelRoom"].player = {index={}}
				_PVP_PageUI["DuelRoom"].room = {}
				if sPageMode==1 then
					if _pvp_ChooseTacticsDefault==nil then
						_pvp_ChooseTacticsDefault = _PVP_ChooseTactics
					end
					if _pvp_ChooseArmyDefault==nil then
						_pvp_ChooseArmyDefault = _PVP_ChooseArmy
					end
					_PVP_ChooseTactics = hApi.ReadParamWithDepth(_pvp_ChooseTacticsDefault,nil,{})
					_PVP_ChooseArmy = hApi.ReadParamWithDepth(_pvp_ChooseArmyDefault,nil,{})
				end
				_childUI["ArmyGrid"]:updateitem(_PVP_ChooseArmy)
				_childUI["TacticsGrid"]:updateitem(_PVP_ChooseTactics)
				_childUI["DuelRoomGrid"]:updateitem({})
			elseif _PVP_PageMode~=sPageMode then
				_PVP_PageMode = sPageMode or 0
				for sModeName,tUIList in pairs(_PVP_PageUI) do
					if sModeName==_PVP_PageMode then
						_CODE_EnablePageUI(sModeName,1)
					else
						_CODE_EnablePageUI(sModeName,0)
					end
				end
				if _PVP_PageMode~="DuelRoom" then
					_PVP_MyLastState = nil
				end
				if _PVP_PageMode~="DuelRoom" then
					_CODE_SwitchMyPVPState("notready",0)
				end
				if _PVP_PageMode~="PVPQuest" then
					local oGrid = _childUI["PVPQuestGrid"]
					oGrid:updateitem({})
				end
				if _PVP_PageMode=="ChooseCard" then
					_CODE_SwitchChooseCardMode("hero")
					_PVP_PageUI["DuelRoom"].room = {}
					_childUI["DuelRoomGrid"]:updateitem({})
					--连接状态请求发送自己的所有卡片
					if g_NetManager:isConnected() then
						g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE,hVar.NET_SAVE_OPR_TYPE.C2L_UPDATE_ALL_ARMY_CARD,0,"0")
					end
				elseif _PVP_PageMode=="DuelRoom" then
					_CODE_UploadMyIcon()
					_childUI["btnPVPReady"]:setstate(0)
					_PVP_FrmUIHandle["imgPVPReady"]:setVisible(false)
					_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(true)
					_LastUpdateTick = hApi.gametime()

					hApi.addTimerForever("__PVP__UpdateAllRoomTick",hVar.TIMER_MODE.GAMETIME,200,_loop_UpdateAllRoom)
					if g_PVP_NetSaveData.PVPSwitch.automatch~=1 then
						_childUI["btnPVPAutoMatch"]:setstate(-1)
					end
				elseif _PVP_PageMode == "PlayerRank" then
					_childUI["PlayerRankGrid"]:updateitem({})
					_childUI["rank_down"].handle._n:setVisible(false)
					_childUI["rank_up"].handle._n:setVisible(false)
					g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_UPDATE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_RANK_LIST)
				elseif _PVP_PageMode=="PVPQuest" then
					--PVP任务
					_CODE_UpdateAllQuest()
				end
			end
		end
		----------------------------------------
		--切换选择卡片模式
		_CODE_SwitchChooseCardMode = function(sChooseCardMode)
			_PVP_ChooseCardMode = sChooseCardMode
			local tUIList = _PVP_PageUI[_PVP_PageDefault]
			tUIList.mode = sChooseCardMode
			local tCard = tUIList.card
			local tUpdate = {}
			for i = 1,#tCard do
				if tCard[i][1]==sChooseCardMode then
					tUpdate[#tUpdate+1] = {i}
				end
			end
			local oGrid = _childUI["ChooseCardGrid"]
			oGrid:updateitem({})
			oGrid:updateitem(tUpdate)
			local x,y = tUIList.grid.x,tUIList.grid.y
			local w,h = tUIList.cliprect[3],tUIList.cliprect[4]
			local ox,oy = 0,tUIList.autoalign[5]
			hUI.SetDragRectForGrid("V",tUIList.dragable,oGrid,x,y,w,h,ox,oy,tUpdate)
			_FrmBG:aligngrid(tUIList.autoalign,tUIList.dragable,0,1)
			if sChooseCardMode=="tactics" then
				_childUI["ArmyGrid"].handle._n:setVisible(false)
				_childUI["TacticsGrid"].handle._n:setVisible(true)
				_childUI["btnCardClassTip"]:setstate(1)
			else
				_childUI["ArmyGrid"].handle._n:setVisible(true)
				_childUI["TacticsGrid"].handle._n:setVisible(false)
				_childUI["btnCardClassTip"]:setstate(-1)
				--如果清理过，这个grid的第一个物品必然是0
				if _childUI["ArmyGrid"].data.item[1]==0 then
					_childUI["ArmyGrid"]:updateitem(_PVP_ChooseArmy)
				end
			end
			if _PVP_ChooseCardMode == "hero" then
				_childUI["btnPVPArmyHero"].handle.s:setColor(ccc3(255,255,255))
				_childUI["btnPVPArmyUnit"].handle.s:setColor(ccc3(180,180,180))
				_childUI["btnPVPTactics"].handle.s:setColor(ccc3(180,180,180))
			elseif _PVP_ChooseCardMode == "unit" then
				_childUI["btnPVPArmyHero"].handle.s:setColor(ccc3(180,180,180))
				_childUI["btnPVPArmyUnit"].handle.s:setColor(ccc3(255,255,255))
				_childUI["btnPVPTactics"].handle.s:setColor(ccc3(180,180,180))
			elseif _PVP_ChooseCardMode == "tactics" then
				_childUI["btnPVPArmyHero"].handle.s:setColor(ccc3(180,180,180))
				_childUI["btnPVPArmyUnit"].handle.s:setColor(ccc3(180,180,180))
				_childUI["btnPVPTactics"].handle.s:setColor(ccc3(255,255,255))
			end
		end
		----------------------------------------
		--挑战玩家(房间)
		local _code_ExitFromNetBF = function(why,tParam)
			hGlobal.event:event("LocalEvent_PlayerLeaveNetBattlefield")
		end
		_CODE_ChallengeRoom = function(tRoom)
			local tUIList = _PVP_PageUI["DuelRoom"]
			local nPlayerNetID = 0
			local sPlayerName = "no name"
			local nID = tRoom[hVar.PVP_ROOM_DATA.HOST]
			local tPlayer = tUIList.player[tUIList.player.index[nID]]
			local CanChallenge = 0
			if tPlayer then
				sPlayerName = tPlayer[hVar.PVP_PLAYER_DATA.NAME]
				nPlayerNetID = tPlayer[hVar.PVP_PLAYER_DATA.ID]
				if tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.REPLAY then
					--看录像
					local nReplayId = tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE]
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ViewReplay"].."\n ID = "..nReplayId,{
						font = hVar.FONTC,
						ok = function()
							local sReplay = hApi.PVPGetReplayById(hVar.PVP_PLAYER_STATE.REPLAY,nReplayId)
							if sReplay~=nil then
								if hApi.LoadReplay(sReplay,_code_ExitFromNetBF)==hVar.RESULT_SUCESS then
									hApi.PVPSwitchMyState("notready")
									hGlobal.event:event("LocalEvent_ShowPVPFrm",0)
								end
							end
						end,
						cancel = 1,
					})
				elseif tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.NPC then
					--NPC陪练
					local nReplayId = tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE]
					local sTip = string.gsub(hVar.tab_string["__TEXT_PVPNPCTip"],"#NAME#",tostring(tPlayer[hVar.PVP_PLAYER_DATA.NAME]))
					local oFrm = hGlobal.UI.MsgBox(sTip,{
						textY = 20,
						font = hVar.FONTC,
						ok = function()
							if g_NetManager:isConnected() then
								local nMsgId = hUI.NetDisable(10000,"pveduel")
								g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_PVE_GAME,"msg:"..nMsgId..";rep:"..nReplayId..";")
							end
						end,
						cancel = hVar.tab_string["__TEXT_Cancel"],
					})
					oFrm.childUI["tip"] = hUI.label:new({
						parent = oFrm.handle._n,
						text = hVar.tab_string["__TEXT_PVPNPCRule"],
						size = 22,
						border = 1,
						font = hVar.FONTC,
						align = "MC",
						x = oFrm.data.w/2,
						y = -148,
					})
				elseif tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.RANK_KING then
					--竞技场季赛冠军
					local nReplayId = tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE]
					local sTip = string.gsub(hVar.tab_string["__TEXT_PVPNPCTip"],"#NAME#",tostring(tPlayer[hVar.PVP_PLAYER_DATA.NAME]))
					local oFrm = hGlobal.UI.MsgBox(sTip,{
						textY = 20,
						font = hVar.FONTC,
						ok = function()
							if g_NetManager:isConnected() then
								local nMsgId = hUI.NetDisable(10000,"pveduel")
								g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_PVE_RANK_KING,"msg:"..nMsgId..";rep:"..nReplayId..";")
							end
						end,
						cancel = hVar.tab_string["__TEXT_Cancel"],
					})
					oFrm.childUI["tip"] = hUI.label:new({
						parent = oFrm.handle._n,
						text = hVar.tab_string["__TEXT_PVPChallengeTip"],
						size = 22,
						border = 1,
						font = hVar.FONTC,
						align = "MC",
						x = oFrm.data.w/2,
						y = -148,
					})
				else
					if tRoom[hVar.PVP_ROOM_DATA.STATE]==hVar.PVP_ROOM_STATE.READY then
						if tPlayer[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.FREE then
							CanChallenge = 1
						end
						local IsHaveArmy = 0
						for i = 1,#_PVP_ChooseArmy do
							if __PVP__UIFunc.IsArmyGrid(_PVP_ChooseArmy,i) then
								IsHaveArmy = 1
								break
							end
						end
						if IsHaveArmy~=1 then
							nPlayerNetID = 0
						end
					end
					if CanChallenge==1 and nPlayerNetID~=0 and nPlayerNetID~=tUIList.myID then
						print("可以挑战！")
						--显示挑战面板
						hGlobal.event:event("LocalEvent_PVPShowChallengeFrm",tostring(sPlayerName),{army=_PVP_ChooseArmy,tactics=_PVP_ChooseTactics},function()
							g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_REQ_CHALLANGE,nPlayerNetID,_PVP_ChooseMap)
						end)
					else
						print("不能挑战该玩家",tRoom[hVar.PVP_ROOM_DATA.STATE])
					end
				end
			else
				print("无此玩家",tRoom[hVar.PVP_ROOM_DATA.STATE])
			end
		end
		
		----------------------------------------
		--拖拽页面
		local _RoomHostBox = {-98,34,-34,-30}				--房间上 host 玩家的 点击区域
		local _RoomGuestBox = {34,34,98,-30}				--房间上 guest 玩家的 点击区域
		local _GetInfoFromRoomID = function(RoomID,InfoMode)		--通过大厅内玩家临时ID 查找该玩家的 role id
			--本地的全部玩家信息
			local tPlayerList = _PVP_PageUI["DuelRoom"].player
			for i = 1,#tPlayerList do
				if type(tPlayerList[i]) == "table" then
					--遍历整个房间内玩家的 房间ID，如果有匹配的则返回 该玩家的 role id
					if tPlayerList[i][hVar.PVP_PLAYER_DATA.ID] == RoomID then
						return tPlayerList[i][InfoMode]
					end
				end
			end
			return 0
		end
		_CODE_HitPage = function(self,tTempPos,x,y)
			local sPageMode = _PVP_PageMode
			if sPageMode=="ChooseCard" then
				local tUIList = _PVP_PageUI[sPageMode]
				local oGridA = _childUI["ArmyGrid"]
				local w,h = oGridA.data.iconW,oGridA.data.iconH
				if hApi.IsInBox(x,y,tUIList.cliprect) then
					local tPickParam = {sGridName="ChooseCardGrid",sPageMode="ChooseCard",sPickMode="card",nPickI=0,tCard=0,state=0,code=0,w=w,h=h,nDelay=0}
					local oGrid = _childUI["ChooseCardGrid"]
					local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
					if oItem and oItem~=0 and tUIList.card[oItem[hVar.ITEM_DATA_INDEX.ID]] then
						local tCard = tUIList.card[oItem[hVar.ITEM_DATA_INDEX.ID]]
						if tCard and tUIList.cardbox[tCard[1]] then
							if type(tCard[3])=="number" and tCard[3]>0 then
								tPickParam.code = __PVP__UIFunc.PickCardUI
							end
							tPickParam.nPickI = oItem[hVar.ITEM_DATA_INDEX.ID]
							tPickParam.tCard = hApi.ReadParam(tCard,nil,{})
							local vx,vy = oGrid:grid2xy(gx,gy)
							local d = oGrid.data
							if hApi.IsInBox(x-vx-d.x,y-vy-d.y,tUIList.cardbox[tCard[1]]) then
								tPickParam.nDelay = 48
							else
								tPickParam.nDelay = 180
							end
						end
					end
					return tPickParam
				else
					if _PVP_ChooseCardMode=="unit" or _PVP_ChooseCardMode=="hero" then
						local tPickParam
						local oGrid = _childUI["ArmyGrid"]
						local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
						if oItem and oItem~=0 and oItem[hVar.ITEM_DATA_INDEX.ID]>10 then
							local nPickI = gx+1
							local tCard = _PVP_ChooseArmy[nPickI]
							if tCard and tCard~=0 then
								tPickParam = {sGridName="ArmyGrid",sPageMode="ChooseCard",sPickMode="army",nPickI=0,tCard=0,state=0,code=0,w=w,h=h}
								tPickParam.nPickI = nPickI
								local tabU = hVar.tab_unit[tCard[1]]
								if tabU.type==hVar.UNIT_TYPE.HERO then
									tPickParam.tCard = {"hero",tCard[1],tCard[2],tCard[3] or 0,tCard[4] or 0}
									tPickParam.code = __PVP__UIFunc.PickCardUI
								else
									tPickParam.tCard = {"unit",tCard[1],tCard[2],tCard[3] or 0,tCard[4] or 0}
									if type(tCard[3])=="number" and tCard[3]>0 then
										tPickParam.code = __PVP__UIFunc.PickCardUI
									end
								end
							end
						end
						return tPickParam
					elseif _PVP_ChooseCardMode=="tactics" then
						local tPickParam
						local oGrid = _childUI["TacticsGrid"]
						local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
						if oItem and oItem~=0 and oItem[hVar.ITEM_DATA_INDEX.ID]~=1 then
							local nPickI = gx+1
							local tCard = _PVP_ChooseTactics[nPickI]
							if tCard and tCard~=0 then
								tPickParam = {sGridName="TacticsGrid",sPageMode="ChooseCard",sPickMode="tactics",nPickI=0,tCard=0,state=0,code=__PVP__UIFunc.PickCardUI,w=w,h=h}
								tPickParam.nPickI = nPickI
								tPickParam.tCard = {"tactics",tCard[1],tCard[2],tCard[3] or 0,tCard[4] or 0}
							end
						end
						return tPickParam
					end
				end
			elseif sPageMode=="DuelRoom" then
				local oGrid = _childUI["DuelRoomGrid"]
				local tUIList = _PVP_PageUI[sPageMode]
				if hApi.IsInBox(x,y,tUIList.cliprect) then
					local tPickParam = {sGridName="DuelRoomGrid",sPageMode="DuelRoom",sPickMode="room",nPickI=0,tCard=0,state=0,nDelay=0}
					local oGrid = _childUI["DuelRoomGrid"]
					local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
					if oItem and oItem~=0 then
						local relx,rely = oGrid:grid2xy(gx,gy)
						local touchX,touchY = x-(oGrid.data.x+relx),y-(oGrid.data.y+rely)
						local tRoom = _PVP_PageUI["DuelRoom"].room[oItem[hVar.ITEM_DATA_INDEX.ID]]
						--判断是否点击到了 房间列表上的 主机玩家和 挑战者玩家，并发送获取玩家 数据的 命令
						if touchX > _RoomHostBox[1] and touchX < _RoomHostBox[3] and touchY < _RoomHostBox[2] and touchY > _RoomHostBox[4] then
							local host_role_id = _GetInfoFromRoomID(tRoom[hVar.PVP_ROOM_DATA.HOST],hVar.PVP_PLAYER_DATA.ROLE_ID)
							local icon = _GetInfoFromRoomID(tRoom[hVar.PVP_ROOM_DATA.HOST],hVar.PVP_PLAYER_DATA.PARAM) 
							local Iconid = hApi.ReadNumberFromFormatString(icon,"icon")
							if Iconid==nil or Iconid==0 then
								Iconid = 0
							end
							if host_role_id ~=0 then
								--g_NetManager:sendGamePacket(hVar.NET_ROLE_INFO_TYPE.MSG_ID_C2L_ROLEINFO_QUERY,host_role_id,1,Iconid)
								g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE,hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_ROLE_INFO,tostring(host_role_id)..":"..Iconid)
								return
							end
						elseif touchX > _RoomGuestBox[1] and touchX < _RoomGuestBox[3] and touchY < _RoomGuestBox[2] and touchY > _RoomGuestBox[4] then
							local guest_role_id = _GetInfoFromRoomID(tRoom[hVar.PVP_ROOM_DATA.GUEST],hVar.PVP_PLAYER_DATA.ROLE_ID)
							local icon = _GetInfoFromRoomID(tRoom[hVar.PVP_ROOM_DATA.GUEST],hVar.PVP_PLAYER_DATA.PARAM) 
							local Iconid = hApi.ReadNumberFromFormatString(icon,"icon")
							if Iconid==nil or Iconid==0 then
								Iconid = 0
							end
							if guest_role_id~=0 then
								--g_NetManager:sendGamePacket(hVar.NET_ROLE_INFO_TYPE.MSG_ID_C2L_ROLEINFO_QUERY,guest_role_id,1,Iconid)
								g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE,hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_ROLE_INFO,tostring(guest_role_id)..":"..Iconid)
								return 
							end
						end
						tPickParam.nPickI = oItem[hVar.ITEM_DATA_INDEX.ID]
					end
					return tPickParam
				end
			elseif sPageMode == "PlayerRank" then
				local oGrid = _childUI["PlayerRankGrid"]
				local tUIList = _PVP_PageUI[sPageMode]
				if hApi.IsInBox(x,y,tUIList.cliprect) then
					local tPickParam = {sGridName="PlayerRankGrid",sPageMode="PlayerRank",sPickMode="rank",nPickI=0,tCard=0,state=0,nDelay=0}
					local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
					if oItem and oItem~=0 then
						tPickParam.nPickI = oItem[hVar.ITEM_DATA_INDEX.ID]
					end
					return tPickParam
				end
			elseif sPageMode=="PVPQuest" then
				local oGrid = _childUI["PVPQuestGrid"]
				local tUIList = _PVP_PageUI[sPageMode]
				if hApi.IsInBox(x,y,tUIList.cliprect) then
					local tPickParam = {sGridName="PVPQuestGrid",sPageMode="PVPQuest",sPickMode="quest",nPickI=0,tCard=0,state=0,nDelay=0}
					local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
					if oItem and oItem~=0 then
						tPickParam.nPickI = oItem[hVar.ITEM_DATA_INDEX.ID]
					end
					return tPickParam
				end
			end
		end
		local _pvp_DragableGrid = {}
		for k in pairs(_PVP_PageUI)do
			_pvp_DragableGrid[k.."Grid"] = 1
		end
		_CODE_DragPage = function(self,tTempPos,tPickParam)
			if tPickParam.state==0 then
				if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then
					if tPickParam.code and tPickParam.code~=0 then
						local pCode = tPickParam.code
						tPickParam.code = 0
						pCode(self,tTempPos,tPickParam)
					end
					if tPickParam.state==0 then
						tPickParam.state = 1
						tTempPos.tx = tTempPos.x
						tTempPos.ty = tTempPos.y
					else
						return 0
					end
				else
					return 0
				end
			elseif tPickParam.state==2 then
				if tPickParam.oImage then
					tPickParam.oImage.handle._n:setPosition(tTempPos.x,tTempPos.y)
				end
				return 0
			end
			if _pvp_DragableGrid[tPickParam.sGridName]~=1 then
				return 0
			end
		end
		_CODE_DropPage = function(self,tTempPos,tPickParam)
			if tPickParam.state==0 then
				if tPickParam.sPageMode=="ChooseCard" then
					if tPickParam.tCard~=0 and hApi.gametime()-tTempPos.tick<=500 then
						_CODE_ShowCardItemHint(tPickParam.tCard)
					end
				elseif tPickParam.sPageMode=="DuelRoom" then
					if tPickParam.nPickI~=0 then
						local tRoom = _PVP_PageUI["DuelRoom"].room[tPickParam.nPickI]
						if tRoom then
							_CODE_ChallengeRoom(tRoom)
						end
					end
				elseif tPickParam.sPageMode=="PVPQuest" then
					_CODE_ShowPVPQuestRewardTip(tTempPos.tx,tTempPos.ty)
				end
			elseif tPickParam.state==1 then
				if _pvp_DragableGrid[tPickParam.sGridName]==1 then
					local tUIList = _PVP_PageUI[tPickParam.sPageMode]
					if tUIList and tUIList.autoalign then
						self:aligngrid(tUIList.autoalign,tUIList.dragable,tTempPos)
					end
				end
				if tPickParam.sPageMode=="PVPQuest" then
					_CODE_UpdateAllPVPQuestBtn()
				end
			elseif tPickParam.state==2 then
				if tPickParam.oImage then
					tPickParam.oImage:del()
					tPickParam.oImage = nil
				end
				if tPickParam.nPickI==0 then
					return
				end
				if tPickParam.sPageMode=="ChooseCard" then
					if tPickParam.sPickMode=="card" then
						local tCard = _PVP_PageUI[tPickParam.sPageMode].card[tPickParam.nPickI]
						if tCard then
							if tCard[1]=="unit" or tCard[1]=="hero" then
								local oGrid = _childUI["ArmyGrid"]
								local gx = oGrid:xy2grid(tTempPos.dx-_FrmBG.data.x,tTempPos.dy-_FrmBG.data.y,"parent")
								if gx then
									_CODE_UpdateArmyGrid(tCard,0,gx+1)
								end
							elseif tCard[1]=="tactics" then
								local oGrid = _childUI["TacticsGrid"]
								local gx = oGrid:xy2grid(tTempPos.dx-_FrmBG.data.x,tTempPos.dy-_FrmBG.data.y,"parent")
								if gx then
									_CODE_UpdateTacticsGrid(tCard,0,gx+1)
								end
							end
						end
					elseif tPickParam.sPickMode=="army" then
						local gx = _childUI["ArmyGrid"]:xy2grid(tTempPos.dx-_FrmBG.data.x,tTempPos.dy-_FrmBG.data.y,"parent")
						if gx then
							_CODE_UpdateArmyGrid(nil,tPickParam.nPickI,gx+1)
						else
							_CODE_UpdateArmyGrid(nil,tPickParam.nPickI,0)
						end
					elseif tPickParam.sPickMode=="tactics" then
						local gx = _childUI["TacticsGrid"]:xy2grid(tTempPos.dx-_FrmBG.data.x,tTempPos.dy-_FrmBG.data.y,"parent")
						if gx then
							_CODE_UpdateTacticsGrid(nil,tPickParam.nPickI,gx+1)
						else
							_CODE_UpdateTacticsGrid(nil,tPickParam.nPickI,0)
						end
					end
				end
			end
		end
		--房间过滤器
		_CODE_GetRoomListWithFilter = function(tList,IsEventFromUI)
			if type(tList)~="table" then
				return {}
			end
			--房间过滤
			if g_PVP_NetSaveData.PVPSwitch["room"..tostring(_PVP_MyRoomID).."_enable"]==2 then
				--允许挑战的房间才显示所有用户
				return tList
			else
				--非挑战房只显示自己和正在对决的人
				local rTab = {}
				for i = 1,#tList do
					local v = tList[i]
					if v[hVar.PVP_PLAYER_DATA.ID]==hGlobal.NET_DATA.LocalPlayerId then
						--自己必须显示
						rTab[#rTab+1] = v
					elseif v[hVar.PVP_PLAYER_DATA.STATE]==hVar.PVP_PLAYER_STATE.IN_BATTLE then
						--状态等于"战斗中"
						rTab[#rTab+1] = v
					end
				end
				return rTab
			end
		end
		_CODE_SwitchRoom = function(nRoomID)
			if type(nRoomID)~="number" then
				nRoomID = 1
			end
			_PVP_MyRoomID = nRoomID
			local tUIList = _PVP_PageUI["DuelRoom"]
			local sBtnName = "btnPVPRoom"..tostring(nRoomID)
			local cEnable = ccc3(255,255,255)
			local cDisable = ccc3(128,128,128)
			for i = 1,#tUIList.tag do
				local pNode = _PVP_FrmUIHandle["bgRoom_tip"..i]
				if sBtnName==tUIList.tag[i] then
					if pNode~=nil then
						pNode:setVisible(true)
					end
					_childUI[tUIList.tag[i]].handle.s:setColor(cEnable)
				else
					if pNode~=nil then
						pNode:setVisible(false)
					end
					_childUI[tUIList.tag[i]].handle.s:setColor(cDisable)
				end
			end
			for i = 1,#tUIList.btn do
				_childUI[tUIList.btn[i]]:setstate(-1)
			end
			if tUIList.room_btn[nRoomID] then
				for i = 1,#tUIList.room_btn[nRoomID] do
					_childUI[tUIList.room_btn[nRoomID][i]]:setstate(1)
				end
			end
			if g_PVP_NetSaveData.PVPSwitch["room"..tostring(_PVP_MyRoomID).."_enable"]==2 then
				if _PVP_FrmUIHandle["btnPVPReady"].data.state==-1 then
					_PVP_FrmUIHandle["btnPVPReady"]:setstate(1)
					_PVP_FrmUIHandle["imgPVPReady"]:setVisible(false)
					_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(true)
				end
			else
				_PVP_FrmUIHandle["btnPVPReady"]:setstate(-1)
				_PVP_FrmUIHandle["imgPVPReady"]:setVisible(false)
				_PVP_FrmUIHandle["imgPVPNotReady"]:setVisible(false)
			end
			if g_PVP_NetSaveData.PVPSwitch.replay==1 then
				if nRoomID==1 then
					if #_PVP_PageUI["DuelRoom"].player==0 then
						hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",{},1)
					end
				end
			else
				_PVP_FrmUIHandle["btnPVPReplay"]:setstate(-1)
			end
			if g_NetManager:isConnected() then
				g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_SWITCH_ROOM,nRoomID)
				g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2LY_PLAYER_LIST)
				_CODE_UploadMyIcon()
				
				--录像信息
				if g_PVP_NetSaveData.PVPSwitch.replay==1 then
					if nRoomID==1 then
						g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_REPLAY, "my:")
					end
				end

				--电脑数据
				if g_PVP_NetSaveData.PVPSwitch.npc==1 then
					if nRoomID==2 and _PVP_NpcUpdated==0 then
						_PVP_NpcUpdated = 1
						g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_NPC, "vvv")
					end
				end

				--rank king
				if g_PVP_NetSaveData.PVPSwitch.rank_king==1 and hVar.OPTIONS.IS_OPEN_PVP_RANK == 1 then
					if nRoomID==1 and _PVP_RankKing==0 then
						_PVP_RankKing = 1
						g_PVP_NetSaveData.RankKing = {index = {}}				--清除之前服务器传过来的上赛季冠军信息（前三名）
						g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_RANK_KING, "king")
					end
				end

			end
		end
		_CODE_PlayerEnterRoom = function(nRoomID)
			if nRoomID==1 then
				local tArmy,tTactics = hApi.PVPFormatMyDeployment(_PVP_ChooseArmy,_PVP_ChooseTactics)
				hApi.PVPSavePlayerDeployment(tArmy,tTactics)
				_CODE_SwitchPageMode("DuelRoom")
				_CODE_SwitchRoom(1)
				if type(_PVP_LastPlayerList)=="table" and #_PVP_LastPlayerList==0 then
					hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",_PVP_LastPlayerList,1)
				end
			elseif nRoomID==2 then
				local tArmy,tTactics = hApi.PVPFormatMyDeployment(_PVP_ChooseArmy,_PVP_ChooseTactics)
				hApi.PVPSavePlayerDeployment(tArmy,tTactics)
				_CODE_SwitchPageMode("DuelRoom")
				_CODE_SwitchRoom(2)
				if type(_PVP_LastPlayerList)=="table" and #_PVP_LastPlayerList==0 then
					hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",_PVP_LastPlayerList,1)
				end
			end
		end
		_CODE_SwitchRoomListFilter = function(nState)
			_childUI["btnPVPRoomFilter"]:setCheckBox(nState)
			if type(_PVP_LastPlayerList)=="table" then
				--print("aaa")
				hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",_PVP_LastPlayerList,1)
			else
				--print("bb")
				hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",{},1)
			end
		end
		local _tTemp = {}
		_CODE_UpdateAllQuest = function(IsFromEvent)
			if IsFromEvent==1 and _PVP_PageMode~="PVPQuest" then
				return
			end
			local oGrid = _childUI["PVPQuestGrid"]
			local tTemp = {}
			for i = 1,#g_PVP_NetSaveData.PVPQuest do
				local v = g_PVP_NetSaveData.PVPQuest[i]
				tTemp[#tTemp+1] = "qst:"..v[hVar.PVP_QUEST_DATA.TYPE]..":{"..v[hVar.PVP_QUEST_DATA.NAME].."}:{"..v[hVar.PVP_QUEST_DATA.TIP].."};"
			end
			local tUpdateI = {}
			local tUpdateII = {}
			local IsEqual = 1
			for i = 1,#tTemp do
				tUpdateII[i] = {i}
				if tTemp[i]==_tTemp[i] then
					tUpdateI[i] = {i}
					local v = g_PVP_NetSaveData.PVPQuest[i]
					local oBtn = oGrid.childUI["btnConfirm0|"..(i-1)]
					if oBtn and v~=nil then
						if (v[hVar.PVP_QUEST_DATA.STATE]==2 or v[hVar.PVP_QUEST_DATA.STATE]==3) then
							if oBtn.data.userdata~=1 then
								IsEqual = 0
								tUpdateI[i] = 0
							end
						else
							if oBtn.data.userdata==1 then
								IsEqual = 0
								tUpdateI[i] = 0
							end
						end
					end
				else
					IsEqual = 0
					tUpdateI[i] = 0
				end
			end
			if #tTemp~=#_tTemp then
				IsEqual = 0
			end
			if IsFromEvent==1 and IsEqual==1 then
				return
			end
			_tTemp = tTemp
			local tUIList = _PVP_PageUI[_PVP_PageMode]
			oGrid:updateitem(tUpdateI)
			_childUI["dragBox"]:sortbutton()
			if IsFromEvent~=1 then
				local gh = math.max(0,#g_PVP_NetSaveData.PVPQuest-4)*tUIList.grid.gridH
				tUIList.dragable = {tUIList.grid.x,tUIList.grid.y+gh+32,0,gh+64}
				hUI.uiSetXY(oGrid,tUIList.grid.x,tUIList.grid.y)
			end
			oGrid:updateitem(tUpdateII)
		end
	end
	----------------------------------------
	--初始化
	do
		for sModeName in pairs(_PVP_PageUI) do
			_CODE_EnablePageUI(sModeName,0)
		end
		_CODE_UpdateArmyGrid()
		_childUI["btnPVPReady"]:loadlabel({text=hVar.tab_string["__TEXT_ReadyToFight"],font=hVar.FONTC,border=1,y=-1})
		_childUI["btnPVPReady"].data.ox = -18
		_childUI["btnPVPReady"].data.oy = 4
		_childUI["btnPVPReady"].data.w = 186
		_childUI["btnPVPReady"].data.h = 56
		_childUI["btnPVPReady"]:update()
		_childUI["btnPVPAutoMatch"]:loadlabel({text=hVar.tab_string["__TEXT_AutoMatch"],font=hVar.FONTC,border=1})
		_childUI["btnPVPAutoMatch"].childUI["tick"] = hUI.label:new({
			parent = _childUI["btnPVPAutoMatch"].handle._n,
			size = 24,
			font = "numWhite",
			text = "00:00",
			align = "MC",
		})
		_childUI["btnPVPAutoMatch"].childUI["tick"].handle._n:setVisible(false)
		_childUI["btnPVPRoomFilter"]:loadlabel({x=18,text=hVar.tab_string["__TEXT_ShowReplay"],font=hVar.FONTC,border=1})
		_childUI["btnPVPRoomFilter"]:setCheckBox("PVP_ROOM_FILTER")

		_childUI["btnPVPRoom1"]:setCheckBox({0,"UI:Lock",-1,2,0,{-1,-1,-1,-1}})
		_childUI["btnPVPRoom2"]:setCheckBox({0,"UI:Lock",-1,2,0,{-1,-1,-1,-1}})
		_childUI["btnPVPQuest"]:setCheckBox({0,"UI:Lock",-1,2,0,{-1,-1,-1,-1}})
		_childUI["btnPVPRank"]:setCheckBox({0,"UI:Lock",-1,2,0,{-1,-1,-1,-1}})
	end
end

-----------------------
--对决确认面板
hGlobal.UI.InitPVPChallengeFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_PVPShowChallengeFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end

	local _PCF_FrmXYWH = {hVar.SCREEN.w/2-220,hVar.SCREEN.h/2+180,520,360}
	local _PCF_CodeOnConfirm = nil

	local _FrmBG
	local _childUI

	hGlobal.UI.PVPChallengeFrm = hUI.frame:new({
		x = _PCF_FrmXYWH[1],
		y = _PCF_FrmXYWH[2],
		w = _PCF_FrmXYWH[3],
		h = _PCF_FrmXYWH[4],
		border = "UI:TileFrmBasic_thin",
		--bgmode = "tile",
		--background = "panel/panel_bg1.png",
		dragable = 3,
		show = 0,
	})
	_FrmBG = hGlobal.UI.PVPChallengeFrm
	_childUI = _FrmBG.childUI

	_childUI["btnOk"] = hUI.button:new({
		parent = _FrmBG,
		x = _PCF_FrmXYWH[3]/2 + 96,
		y = -1*_PCF_FrmXYWH[4] + 24,
		model = "UI:ButtonBack",
		scaleT = 0.95,
		w = 128,
		h = 36,
		label = {
			text = hVar.tab_string["__TEXT_Confirm"],
			font = hVar.FONTC,
			border = 1,
		},
		code = function()
			_FrmBG:show(0,"fade")
			local pCode = _PCF_CodeOnConfirm
			_PCF_CodeOnConfirm = nil
			if pCode then
				return pCode()
			end
		end,
	})

	_childUI["btnClose"] = hUI.button:new({
		parent = _FrmBG,
		x = _PCF_FrmXYWH[3]/2 - 96,
		y = -1*_PCF_FrmXYWH[4] + 24,
		model = "UI:ButtonBack",
		scaleT = 0.95,
		w = 112,
		h = 36,
		label = {
			text = hVar.tab_string["__TEXT_Cancel"],
			font = hVar.FONTC,
			border = 1,
		},
		code = function()
			_FrmBG:show(0,"fade")
		end,
	})

	local _code_AddRule = function(tUIList,sus,text)
		tUIList.count = tUIList.count + 1
		local labY = tUIList.posY
		local i = tUIList.count
		tUIList[#tUIList+1] = {"label","labRule_"..i,text,{28,labY-(i-1)*48,22,1,"LC",hVar.FONTC}}
		if sus==1 then
			tUIList[#tUIList+1] = {"image","imgRuleFlag_"..i,"UI:ok",{470,labY-(i-1)*48,36,-1}}
		else
			tUIList.enable = 0
			tUIList[#tUIList+1] = {"image","imgRuleFlag_"..i,"UI:close",{470,labY-(i-1)*48,36,-1}}
		end
	end

	--显示挑战面板(追加规则)
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(sOppName,tMyDeployment,pCodeOnConfirm)
		_PCF_CodeOnConfirm = nil
		hApi.safeRemoveT(_childUI,"nodeRule")
		_childUI["nodeRule"] = hUI.node:new({
			parent = _FrmBG.handle._n,
		})
		local tUIHandle = {}
		local tUIList = {posY=0,enable=0,count=0}
		local sPlayerName = "player"
		if type(sOppName)~="string" then
			tUIList.posY = -96
			tUIList[#tUIList+1] = {"label","labTitleII",hVar.tab_string["__TEXT_PVPDuelRule"],{_PCF_FrmXYWH[3]/2,-42,28,1,"MC",hVar.FONTC}}
		else
			tUIList.posY = -154
			tUIList.enable = 1
			sPlayerName = string.gsub(hVar.tab_string["__TEXT_PVPDuelConfim"],"#NAME#",sOppName)
			tUIList[#tUIList+1] = {"label","labTitleII",hVar.tab_string["__TEXT_PVPDuelRule"],{_PCF_FrmXYWH[3]/2,-100,22,1,"MC",hVar.FONTC}}
			tUIList[#tUIList+1] = {"label","labTitle",sPlayerName,{_PCF_FrmXYWH[3]/2,-48,28,1,"MC",hVar.FONTC}}
		end
		hApi.PVPCheckMyDeployment(tMyDeployment,function(IsSucess,sRule)
			_code_AddRule(tUIList,IsSucess,sRule)
		end)
		hUI.CreateMultiUIByParam(_childUI["nodeRule"].handle._n,0,0,tUIList,tUIHandle)
		if tUIList.enable==0 then
			_childUI["btnOk"]:setstate(0)
		else
			_childUI["btnOk"]:setstate(1)
			if type(pCodeOnConfirm)=="function" then
				_PCF_CodeOnConfirm = pCodeOnConfirm
			end
		end
		_FrmBG:show(1)
		_FrmBG:active()
	end)
end

hGlobal.UI.InitPVPActivityFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowPVPActivityFrm","__show"}
	if mode~="include" then
		g_PVP_NetSaveData.activity = ""
		return tInitEventName
	end

	local _ATF_FrmXYWH = {hVar.SCREEN.w/2-590/2,hVar.SCREEN.h/2+480/2,590,480}
	local _ATF_CodeOnConfirm = nil
	local _ATF_CodeOnCancel = nil
	local _ATF_Clipper = nil--{0,-76,590,348,1}
	local _ATF_DragRect = {0,0,0,0}
	
	local _ATF_ArtIcon = {
		[0] = {"UI:close"},
		[1] = {"UI:ok"},
		[2] = 0,
		[3] = {"UI:GIFT"},
		[4] = {"ICON:action_attack"},
		[5] = {"ICON:action_info"},
		[6] = {"ICON:action_loot"},
		[7] = {"ICON:action_move"},
		[8] = {"ICON:action_enter"},
		[9] = {"ICON:action_talk"},
		[10] = {"ICON:action_join"},
		[11] = {"ICON:action_look"},
		[12] = {"ICON:action_occupy"},
	}

	local _FrmBG
	local _childUI
	local _pClipNode = nil

	hGlobal.UI.ActivityFrm = hUI.frame:new({
		x = _ATF_FrmXYWH[1],
		y = _ATF_FrmXYWH[2],
		w = _ATF_FrmXYWH[3],
		h = _ATF_FrmXYWH[4],
		border = "UI:TileFrmBasic_thin",
		--bgmode = "tile",
		--background = "panel/panel_bg1.png",
		dragable = 3,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			if _ATF_Clipper~=nil and _childUI["nodeOfTip"]~=nil then
				return self:pick("nodeOfTip",_ATF_DragRect,tTempPos)
			end
		end,
	})
	_FrmBG = hGlobal.UI.ActivityFrm
	_childUI = _FrmBG.childUI
	do
		if _ATF_Clipper~=nil then
			_pClipNode = hApi.CreateClippingNode(_FrmBG,_ATF_Clipper,5,_ATF_Clipper[5])
		else
			_pClipNode = _FrmBG.handle._n
		end
		_childUI["btnClose"] = hUI.button:new({
			parent = _FrmBG,
			x = _ATF_FrmXYWH[3]/2,
			y = -1*_ATF_FrmXYWH[4] + 36,
			model = "UI:ButtonBack",
			scaleT = 0.95,
			w = 112,
			h = 36,
			label = {
				text = hVar.tab_string["__TEXT_Confirm"],
				font = hVar.FONTC,
				border = 1,
			},
			code = function()
				_FrmBG:show(0,"fade")
				local pCode = _ATF_CodeOnConfirm
				_ATF_CodeOnConfirm = nil
				_ATF_CodeOnCancel = nil
				if pCode then
					return pCode()
				end
			end,
		})

		_childUI["btnConfirm"] = hUI.button:new({
			parent = _FrmBG,
			x = _ATF_FrmXYWH[3]/2+96,
			y = -1*_ATF_FrmXYWH[4] + 36,
			model = "UI:ButtonBack",
			scaleT = 0.95,
			w = 112,
			h = 36,
			label = {
				text = hVar.tab_string["__TEXT_Confirm"],
				font = hVar.FONTC,
				border = 1,
			},
			code = function()
				_FrmBG:show(0,"fade")
				local pCode = _ATF_CodeOnConfirm
				_ATF_CodeOnConfirm = nil
				_ATF_CodeOnCancel = nil
				if pCode then
					return pCode()
				end
			end,
		})

		_childUI["btnCancel"] = hUI.button:new({
			parent = _FrmBG,
			x = _ATF_FrmXYWH[3]/2-96,
			y = -1*_ATF_FrmXYWH[4] + 36,
			model = "UI:ButtonBack",
			scaleT = 0.95,
			w = 112,
			h = 36,
			label = {
				text = hVar.tab_string["__TEXT_Cancel"],
				font = hVar.FONTC,
				border = 1,
			},
			code = function()
				_FrmBG:show(0,"fade")
				local pCode = _ATF_CodeOnCancel
				_ATF_CodeOnCancel = nil
				if pCode then
					return pCode()
				end
			end,
		})

		local tUIHandle = {}
		local tUIList = {
			{"labelX","labTitle1",hVar.tab_string["__TEXT_PVP_ACTIVITY_TITLE"],{_ATF_FrmXYWH[3]/2,-36,28,1,"MC",hVar.FONTC}},
			{"labelX","labTitle2",hVar.tab_string["__TEXT_PVP_ACTIVITY_TITLE_2"],{_ATF_FrmXYWH[3]/2,-36,28,1,"MC",hVar.FONTC}},
			{"image","imgCut","UI:panel_part_09",{_ATF_FrmXYWH[3]/2,-72,_ATF_FrmXYWH[3]-24,8}},
		}
		hUI.CreateMultiUIByParam(_FrmBG,0,0,tUIList,tUIHandle)
	end

	local _code_GetTextByCmdT = function(v)
		local s = tostring(v[1])
		local sText
		if string.sub(s,1,1)=="$" and string.len(s)>1 then
			sText = string.sub(s,2,string.len(s))
		else
			sText = hVar.tab_string["__TEXT_PVP_ACTIVITY_"..s]
		end
		if #v>2 then
			for n = 1,#v-2 do
				sText = string.gsub(sText,"#P"..n.."#",tostring(v[n+2]))
			end
		end
		return sText
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(sCmd,tParam)
		_ATF_CodeOnConfirm = nil
		_ATF_CodeOnCancel = nil
		local nCloseMode = 1
		local nShowMin,nShowMax = 0,99
		local nIconBase = 0
		if type(tParam)=="table" then
			if type(tParam.ok)=="function" then
				_ATF_CodeOnConfirm = tParam.ok
			end
			if tParam.cancel==1 then
				nCloseMode = 2
			elseif type(tParam.cancel)=="function" then
				nCloseMode = 2
				_ATF_CodeOnCancel = tParam.cancel
			end
			if type(tParam.show)=="table" then
				nShowMin,nShowMax = tParam.show[1],tParam.show[2]
				nIconBase = tParam.show[1]
			elseif type(tParam.show)=="number" then
				nShowMin,nShowMax = tParam.show,tParam.show
				nIconBase = 99999
			end
		end
		hApi.safeRemoveT(_childUI,"nodeOfTip")
		_childUI["nodeOfTip"] = hUI.node:new({
			parent = _pClipNode,
		})
		_ATF_DragRect[2] = 0
		_ATF_DragRect[4] = 0
		local nTipCount = 0
		local pNode = _childUI["nodeOfTip"].handle._n
		local tActivity = hApi.GetParamByCmd("act:",sCmd)
		if type(tActivity)=="table" and #tActivity>0 then
			local posY = -96
			for i = 1,#tActivity do
				local v = tActivity[i]
				if v[1] and v[2] then
					local nState = tonumber(v[2])
					if nState>=nShowMin and nState<=nShowMax then
						nTipCount = nTipCount + 1
						local sText = _code_GetTextByCmdT(v)
						local nIconId = nState-nIconBase
						if type(_ATF_ArtIcon[nIconId])=="table" then
							hUI.deleteUIObject(hUI.image:new({
								parent = pNode,
								x = 40,
								y = posY-10,
								model = _ATF_ArtIcon[nIconId][1],
								animation = _ATF_ArtIcon[nIconId][2],
								w = 24,
								h = -1,
							}))
							sText = "      "..sText
						end
						local oLabel = hUI.label:new({
							parent = pNode,
							x = 28,
							y = posY,
							text = sText,
							align = "LT",
							font = hVar.FONTC,
							width = _ATF_FrmXYWH[3]-36,
							size = 22,
							border = 1,
						})
						posY = posY - oLabel.handle.s:getContentSize().height - 16
						hUI.deleteUIObject(oLabel)
					end
				end
			end
			if _ATF_Clipper~=nil then
				_ATF_DragRect[4] = math.max(0,-1*posY-_ATF_Clipper[4])
				_ATF_DragRect[2] = _ATF_DragRect[4] + 16
				_ATF_DragRect[4] = _ATF_DragRect[4] + 32
			end
		end
		if nTipCount>0 then
			if nCloseMode==2 then
				_FrmBG.data.dragable = 4
				_childUI["labTitle1"].handle._n:setVisible(false)
				_childUI["labTitle2"].handle._n:setVisible(true)
				_childUI["btnClose"]:setstate(-1)
				_childUI["btnConfirm"]:setstate(1)
				_childUI["btnCancel"]:setstate(1)
			else--if nCloseMode==1 then
				_childUI["labTitle1"].handle._n:setVisible(true)
				_childUI["labTitle2"].handle._n:setVisible(false)
				_FrmBG.data.dragable = 3
				_childUI["btnClose"]:setstate(1)
				_childUI["btnConfirm"]:setstate(-1)
				_childUI["btnCancel"]:setstate(-1)
			end
			_FrmBG:show(1)
			_FrmBG:active()
		elseif type(_ATF_CodeOnConfirm)=="function" then
			local pCode = _ATF_CodeOnConfirm
			_ATF_CodeOnConfirm = nil
			_ATF_CodeOnCancel = nil
			pCode()
		else
			_ATF_CodeOnConfirm = nil
			_ATF_CodeOnCancel = nil
		end
	end)
end

--显示 卡牌类型的面板
hGlobal.UI.InitPVPTipFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowPVPTip","__show"}
	if mode~="include" then
		return tInitEventName
	end
	local _FrmBG
	local _childUI
	local _FrmXYWH = {hVar.SCREEN.w/2-285,hVar.SCREEN.h/2+200,570,400}
	local _TipMode = {}

	hGlobal.UI.PVPTipFrm = hUI.frame:new({
		x = _FrmXYWH[1],
		y = _FrmXYWH[2],
		w = _FrmXYWH[3],
		h = _FrmXYWH[4],
		border = "UI:TileFrmBasic_thin",
		bgmode = "tile",
		--background = "panel/panel_bg1.png",
		dragable = 3,
		closebtn = {
			x = _FrmXYWH[3]/2,
			y = -1*_FrmXYWH[4] + 26,
			model = "UI:ButtonBack",
			scaleT = 0.95,
			w = 112,
			h = 36,
			label = {
				text = hVar.tab_string["__TEXT_Confirm"],
				font = hVar.FONTC,
				border = 1,
			},
			code = function()
				_FrmBG:show(0,"fade")
			end,
		},
	})
	_FrmBG = hGlobal.UI.PVPTipFrm
	_childUI = _FrmBG.childUI

	do
		--战术卡提示
		_TipMode[#_TipMode+1] = {"tactics","tipTactics"}
		_childUI["tipTactics"] = hUI.node:new({
			parent = _FrmBG.handle._n,
		})
		local pNode = _childUI["tipTactics"].handle._n
		local tUIList = {
			--面板标题
			{"label","tittle",hVar.tab_string["Battlefieldskillbook"],{_FrmXYWH[3]/2,-40,34,1,"MC",hVar.FONTC}},
			{"label","tipEx",hVar.tab_string["__TEXT_TARCTICS_ICON_LAB_END"],{_FrmXYWH[3]/2,-1*_FrmXYWH[4] + 64,22,1,"MC",hVar.FONTC,{230,180,50}}},
		}
		local tTactics = {151,251,301,451,601,503}
		for i = 1,#tTactics do
			local x,y = 36,-88-(i-1)*40
			local sModelName = hApi.GetTacticsCardTypeIcon(tTactics[i],"model")
			tUIList[#tUIList+1] = {"image","icoClass"..i.."BG","UI:pvp_solt",{x,y,-1,-1}}
			tUIList[#tUIList+1] = {"image","icoClass"..i,sModelName,{x,y,-1,-1}}
			tUIList[#tUIList+1] = {"label","tipClass"..i,hVar.tab_string["__TEXT_TARCTICS_ICON_LAB_"..i],{x+26,y,22,1,"LC",hVar.FONTC}}
		end
		hUI.CreateMultiUIByParam(pNode,0,0,tUIList,{})
	end

	do
		--训练房提示(room2)
		_TipMode[#_TipMode+1] = {"room2","tipRoom2"}
		_childUI["tipRoom2"] = hUI.node:new({
			parent = _FrmBG.handle._n,
		})
		local pNode = _childUI["tipRoom2"].handle._n
		local tUIList = {
			--面板标题
			{"label","tittle",hVar.tab_string["__TEXT_PVP_ROOM2"],{_FrmXYWH[3]/2,-40,34,1,"MC",hVar.FONTC}},
			{"label","tipEx",hVar.tab_string["__TEXT_PVP_ROOM2_INTRO"],{32,-72,22,1,"LT",hVar.FONTC,0,_FrmXYWH[3]-64}},
		}
		hUI.CreateMultiUIByParam(pNode,0,0,tUIList,{})
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(sTipName)
		for i = 1,#_TipMode do
			if sTipName==_TipMode[i][1] then
				_childUI[_TipMode[i][2]].handle._n:setVisible(true)
			else
				_childUI[_TipMode[i][2]].handle._n:setVisible(false)
			end
		end
		_FrmBG:show(1)
		_FrmBG:active()
	end)
end

--显示固定装备选择面板
hGlobal.UI.InitPVPHeroSetFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowPVPHeroSetFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end

	local _FrmXYWH = {0,hVar.SCREEN.h/2+110,hVar.SCREEN.w,300}
	local _FrmBG
	local _childUI

	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_RefreshMyChoose = hApi.DoNothing

	local _HSF_PVPHeroSet = {}
	local _HSF_DragRect = {-600,-122,1024,0}
	local _HSF_UIHandle = {}
	local _HSF_UIList = {
		{"image","tittleBG","UI:selectbg2",{_FrmXYWH[3]/2,0,512,32}},
		{"label","tittle",hVar.tab_string["__TEXT_CHOOSE_PVP_SET"],{_FrmXYWH[3]/2,0,28,1,"MC",hVar.FONTC}},
	}

	hGlobal.UI.PVPHeroSetFrm = hUI.frame:new({
		x = _FrmXYWH[1],
		y = _FrmXYWH[2],
		w = _FrmXYWH[3],
		h = _FrmXYWH[4],
		--border = "UI:TileFrmBasic_thin",
		--bgmode = "tile",
		background = "misc/selectbg.png",
		dragable = 2,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			if IsInside~=1 then
				_FrmBG:show(0)
			elseif #_HSF_PVPHeroSet>0 then
				return self:pick("CardGrid",_HSF_DragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,{state=0}})
			end
		end,
	})
	_FrmBG = hGlobal.UI.PVPHeroSetFrm
	_childUI = _FrmBG.childUI
	do
		hUI.CreateMultiUIByParam(_FrmBG,0,0,_HSF_UIList,_HSF_UIHandle,hUI.MultiUIParamByFrm(_FrmBG))

		_childUI["CardGrid"] = hUI.bagGrid:new({
			parent = _FrmBG.handle._n,
			grid = {hApi.NumTable(64)},
			slot = 0,
			animation = -1,
			x = 172,
			y = _HSF_DragRect[2],
			gridW = 172,
			gridH = 360,
			uiExtra = {"chk","chkBG"},
			codeOnImageCreate = function(oGrid,nUnitId,pSprite,gx,gy)
				__PVP__UIFunc.DrawCardUI({"hero",nUnitId,12},pSprite,0,12)
				local x,y = pSprite:getPosition()
				oGrid.childUI["chkBG"..gx.."|"..gy] = hUI.image:new({
					parent = oGrid.handle._n,
					x = x,
					y = y - 128,
					model = "UI:pvp_solt",
				})
				oGrid.childUI["chk"..gx.."|"..gy] = hUI.image:new({
					parent = oGrid.handle._n,
					x = x,
					y = y - 128,
					model = "UI:ok",
					w = 36,
					h = -1,
				})
				local tabS = hVar.tab_pvpset[nUnitId]
				local nIndex = gx+1
				if tabS and tabS[nIndex] and tabS[nIndex].icon then
					hUI.deleteUIObject(hUI.image:new({
						parent = pSprite,
						x = 44,
						y = -32,
						model = tabS[nIndex].icon,
						w = 36,
						h = -1,
						z = 10,
					}))
				end
			end,
		})
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tArmy)
		_FrmBG:show(1)
		_FrmBG:active()
		local tMyHero = {}
		local tHeroSet = {}
		local tUpdate = {}
		for i = 1,#tArmy do
			if type(tArmy[i])=="table" then
				local id = tArmy[i][1]
				if hVar.tab_unit[id] and hVar.tab_unit[id].type==hVar.UNIT_TYPE.HERO then
					tMyHero[id] = 1
				end
			end
		end
		for id in pairs(tMyHero)do
			if hVar.tab_pvpset[id] then
				for i = 1,#hVar.tab_pvpset[id] do
					tHeroSet[#tHeroSet+1] = {id,i}
				end
			else
				tHeroSet[#tHeroSet+1] = {id,0}
			end
		end
		local NeedUpdate = 0
		if #_HSF_PVPHeroSet~=#tHeroSet then
			NeedUpdate = 1
		else
			for i = 1,#_HSF_PVPHeroSet do
				if _HSF_PVPHeroSet[i][1]==tHeroSet[i][1] and _HSF_PVPHeroSet[i][2]==tHeroSet[i][2] then
					tUpdate[i] = _HSF_PVPHeroSet[i]
				else
					NeedUpdate = 1
					tUpdate[i] = 0
				end
			end
		end
		if NeedUpdate==1 then
			_HSF_PVPHeroSet = tHeroSet
			_childUI["CardGrid"]:updateitem(tUpdate)
			_childUI["CardGrid"]:updateitem(_HSF_PVPHeroSet)
			_CODE_RefreshMyChoose()
			local nNum = #_HSF_PVPHeroSet
			if nNum<=6 then
				local x = math.floor(hVar.SCREEN.w/2 - (nNum-1)*_childUI["CardGrid"].data.gridW/2)
				hUI.uiSetXY(_childUI["CardGrid"],x,nil)
				_HSF_DragRect[1] = x
				_HSF_DragRect[3] = 0
			else
				local x = math.floor(hVar.SCREEN.w/2 - (6-1)*_childUI["CardGrid"].data.gridW/2)
				hUI.uiSetXY(_childUI["CardGrid"],x,nil)
				_HSF_DragRect[3] = (nNum-6)*_childUI["CardGrid"].data.gridW + 80
				_HSF_DragRect[1] = x - _HSF_DragRect[3] -30 + math.floor(_childUI["CardGrid"].data.gridW/2)
			end
		end
	end)

	_CODE_RefreshMyChoose = function()
		for i = 1,#_HSF_PVPHeroSet do
			local id,choice = unpack(_HSF_PVPHeroSet[i])
			local oImage = _childUI["CardGrid"].childUI["chk"..(i-1).."|0"]
			if oImage then
				if choice==0 or (g_PVP_NetSaveData.PVPSetChoosed[id] or 1)==choice then
					oImage.handle.s:setVisible(true)
				else
					oImage.handle.s:setVisible(false)
				end
			end
		end
	end

	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then
				if tPickParam.state==0 then
					tPickParam.state = 1
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif tPickParam.state==2 then
			return 0
		end
	end

	_CODE_DropPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			local x = tTempPos.tx-_FrmBG.data.x-_childUI["CardGrid"].data.x
			local y = tTempPos.ty-_FrmBG.data.y-_childUI["CardGrid"].data.y
			local gx,gy,oItem = _childUI["CardGrid"]:xy2grid(x,0,1)
			if type(oItem)=="table" then
				--点到了卡片的下半部分，切换我的选择
				local nUnitID,nMyChoice = unpack(oItem)
				if y>-52 then
					--点到了卡片的上半部分，显示配置
					if hGlobal.WORLD.LastWorldMap==nil then
						local oHero = hGlobal.player[-1].heros[1]
						if type(hGlobal.player[-1].heros[1])=="table" then
							hGlobal.player[-1].heros[1]:del()
						end
						local oHero = hClass.hero:new({
							id = nUnitID,
							owner = -1,
						})
						oHero:levelup(12,0)
						if hVar.tab_pvpset[nUnitID] and hVar.tab_pvpset[nUnitID][nMyChoice] then
							local tSet = hVar.tab_pvpset[nUnitID][nMyChoice].equipment
							for i = 1,#tSet do
								if type(tSet[i])=="table" then
									oHero.data.item[i] = hApi.ReadParamWithDepth(tSet[i],nil,{},5)
								end
							end
							for i = 1,#tSet do
								if type(tSet[i])=="table" then
									oHero:shiftitem("bag",i,"equip",i)
								end
							end
						end
						hGlobal.event:event("LocalEvent_showHeroCardFrm",oHero,nil,0,2)
					end
				else
					if g_PVP_NetSaveData.PVPSetChoosed[nUnitID]~=nMyChoice then
						g_PVP_NetSaveData.PVPSetChoosed[nUnitID] = nMyChoice
						_CODE_RefreshMyChoose()
					end
				end
			end
		elseif tPickParam.state==1 then
			_FrmBG:aligngrid({"H","CardGrid",30,30,0},_HSF_DragRect,tTempPos)
		end
	end
end

hGlobal.UI.InitPVPReplayFrm_PVP = function(mode)
	local tInitEventName = {"LocalEvent_ShowPVPReplayFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end

	local _CODE_ResetChoosedReplayID = hApi.DoNothing
	local _CODE_PVPC2LRequireReplay = hApi.DoNothing
	local _CODE_PVPStartReplay = hApi.DoNothing

	local _RPF_ReplayId = 0

	local _FrmXYWH = {hVar.SCREEN.w/2-516/2,hVar.SCREEN.h/2+420/2,516,420}
	local _FrmBG
	local _childUI

	--hApi.GetMsgBoxXYWH("mini",_FrmXYWH)
	--_FrmXYWH[1] = _FrmXYWH[1] - 48
	--_FrmXYWH[2] = hVar.SCREEN.h/2 + 190
	--_FrmXYWH[3] = _FrmXYWH[3] + 96
	--_FrmXYWH[4] = 380

	hGlobal.UI.PVPReplayFrm = hUI.frame:new({
		x = _FrmXYWH[1],
		y = _FrmXYWH[2],
		w = _FrmXYWH[3],
		h = _FrmXYWH[4],
		border = "UI:TileFrmBasic_thin",
		dragable = 4,
		show = 0,
	})
	_FrmBG = hGlobal.UI.PVPReplayFrm
	_childUI = _FrmBG.childUI
	do
		local tBtn = {
			{{"7"},{"8"},{"9"},{"C"}},
			{{"4"},{"5"},{"6"},{"<<"}},
			{{"1"},{"2"},{"3"},{"0"}},
		}
		local sDefaultTip = hVar.tab_string["__TEXT_please_enter_replay_ID"]
		local nReplayIDLen = 8
		local tIconXYWH = {_FrmXYWH[3]/2-#tBtn[1]*(72+6)/2+48,-138,72,72}
		_childUI["labSelectedNum"] = hUI.image:new({
			parent = _FrmBG.handle._n,
			model = "UI:tip_item",
			x = _FrmXYWH[3]/2,
			y = tIconXYWH[2]+72,
			w = 360,
			h = 42,
		})
		_childUI["labSelectedNum"] = hUI.label:new({
			parent = _FrmBG.handle._n,
			text = sDefaultTip,
			x = _FrmXYWH[3]/2,
			y = tIconXYWH[2]+72,
			align = "MC",
			size = 32,
		})
		local oLab = _childUI["labSelectedNum"]
		local _code_OnNumBtnHit = function(oBtn)
			local tData = oBtn.data.userdata
			if tonumber(tData[1]) then
				if oLab.data.text==sDefaultTip then
					if tData[1]~="0" then
						oLab:setText(tData[1],2)
					end
				elseif string.len(oLab.data.text)<nReplayIDLen then
					oLab:setText(oLab.data.text..tData[1],2)
				end
			elseif tData[1]=="C" then
				oLab:setText(sDefaultTip,2)
			elseif tData[1]=="<<" then
				local nLen = string.len(oLab.data.text)
				if oLab.data.text~=sDefaultTip then
					if nLen>1 then
						oLab:setText(string.sub(oLab.data.text,1,nLen-1),2)
					else
						oLab:setText(sDefaultTip,2)
					end
				end
			end
		end
		_CODE_ResetChoosedReplayID = function()
			_RPF_ReplayId = 0
			oLab:setText(sDefaultTip,2)
		end
		hApi.EnumTable2V(tBtn,function(v,x,y)
			if type(v)=="table" then
				local tData = tBtn[y+1][x+1]
				_childUI["btnNum_"..x.."|"..y] = hUI.button:new({
					parent = _FrmBG,
					x = tIconXYWH[1] + (tIconXYWH[3]+6)*x,
					y = tIconXYWH[2] - (tIconXYWH[4]+6)*y,
					model = "UI:item_slot",
					--animation = "lightSlim",
					w = tIconXYWH[3],
					h = tIconXYWH[4],
					label = {
						size = 32,
						border = 1,
						text = v[1],
					},
					scaleT = 0.9,
					userdata = tData,
					code = _code_OnNumBtnHit,
				})
			end
		end)
		_childUI["btnConfirm"] = hUI.button:new({
			parent = _FrmBG,
			label = hVar.tab_string["__TEXT_Confirm"],
			border = 1,
			font = hVar.FONTC,
			model = "UI:ButtonBack",
			x = _FrmXYWH[3]/2 + 96,
			y = -1*_FrmXYWH[4] + 48,
			w = 128,
			h = 38,
			scaleT = 0.95,
			code = function()
				_CODE_PVPC2LRequireReplay(1)
				_FrmBG:show(0,"fade")
			end,
		})
		_childUI["btnCancel"] = hUI.button:new({
			parent = _FrmBG,
			label = hVar.tab_string["__TEXT_Cancel"],
			border = 1,
			font = hVar.FONTC,
			model = "UI:ButtonBack",
			x = _FrmXYWH[3]/2 - 96,
			y = -1*_FrmXYWH[4] + 48,
			w = 128,
			h = 38,
			scaleT = 0.95,
			code = function()
				_FrmBG:show(0,"fade")
			end,
		})
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tArmy)
		_FrmBG:show(1)
		_FrmBG:active()
		_CODE_ResetChoosedReplayID()
	end)

	hGlobal.event:listen("NetEvent_L2CReplay","__RecvReplay",function(sReplay,nReplayId)
		if _RPF_ReplayId==nReplayId and hApi.getTimer("PVPWaitingForReplay") then
			_CODE_ResetChoosedReplayID()
			hUI.NetDisable(0)
			hApi.clearTimer("PVPWaitingForReplay")
			if sReplay=="0" then
				hGlobal.UI.MsgBox("cannot find replay,id = "..nReplayId,{
					font = hVar.FONTC,
				})
			else
				_CODE_PVPStartReplay(sReplay)
			end
		end
	end)

	local _code_KeepWaiting = function()
		hUI.NetDisable(0)
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ReplayOutOfTime"],{
			font = hVar.FONTC,
			ok = {hVar.tab_string["__TEXT_Wait"],function()
				_CODE_PVPC2LRequireReplay(0)
			end},
			cancel = {hVar.tab_string["__TEXT_Cancel"],function()
				_CODE_ResetChoosedReplayID()
			end},
		})
	end

	_CODE_PVPC2LRequireReplay = function(IfSendCmd)
		local nReplayId = tonumber(_childUI["labSelectedNum"].data.text)
		if nReplayId==nil then
			return
		end
		local sReplay = hApi.PVPGetReplayById(hVar.PVP_PLAYER_STATE.REPLAY,nReplayId)
		if sReplay~=nil then
			_CODE_PVPStartReplay(sReplay)
		elseif IfSendCmd==1 and g_NetManager:isConnected() then
			_RPF_ReplayId = nReplayId
			g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_REPLAY, tostring(nReplayId))
			local nTick = 10000
			hUI.NetDisable(nTick)
			hApi.addTimerOnce("PVPWaitingForReplay",nTick,_code_KeepWaiting)
		else
			local nTick = 10000
			hUI.NetDisable(nTick)
			hApi.addTimerOnce("PVPWaitingForReplay",nTick,_code_KeepWaiting)
		end
	end

	local _code_ExitFromNetBF = function(why,tParam)
		hGlobal.event:event("LocalEvent_PlayerLeaveNetBattlefield")
	end

	_CODE_PVPStartReplay = function(sReplay)
		if hApi.LoadReplay(sReplay,_code_ExitFromNetBF)==hVar.RESULT_SUCESS then
			hApi.PVPSwitchMyState("notready")
			hGlobal.event:event("LocalEvent_ShowPVPFrm",0)
		end
	end
end