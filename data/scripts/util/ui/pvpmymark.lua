----�ҵ�ս��
--hGlobal.UI.InitPVPMyMark_PVP = function()
	--if mode~="include" then
		--return hVar.RESULT_FAIL
	--end
	--local herolist = {}
	--hGlobal.UI.PVPMyMarkFram = hUI.frame:new({
		--x = hVar.SCREEN.w/2 - 345,
		--y = hVar.SCREEN.h/2 + 260,
		--dragable = 0,
		--show = 0,
		--background = "UI:pvpmainx",
		--autoactive = 0,
		--codeOnDragEx = function(touchX,touchY,touchMode)
			
		--end,
	--})
	--local _Markfrm = hGlobal.UI.PVPMyMarkFram
	--local _MarkchildUI = _Markfrm.childUI
	--local _Markparent = _Markfrm.handle._n
	---------------------------------------------------
	----ͷ��
	--_MarkchildUI["Background"] = hUI.button:new({
		--parent = _Markparent,
		--dragbox = _Markfrm.childUI["dragBox"],
		--model = "icon/portrait/hero_zhaoyun_s.png",
		--x = 74,
		--y = -67,
		--w = 82,
		--h = 82,
		--code = function()
			--hGlobal.event:event("LocalEvent_PVPTwoLevel",1)
		--end,
	--})
	
	----����
	--_MarkchildUI["PlayerName"] = hUI.label:new({
		--parent = _Markparent,
		--size = 26,
		--align = "MT",
		--font = hVar.FONTC,
		--x = 200,
		--y = -25,
		--width = 400,
		--text = "SuperMen",
	--})
	
	----����ȼ�
	--_MarkchildUI["PlayerName"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "MT",
		--font = hVar.FONTC,
		--x = 175,
		--y = -67,
		--width = 400,
		--text = hVar.tab_string["PVPExperience"],
	--})
	----����ȼ�������
	--_MarkchildUI["PlayerName"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 220,
		--y = -78,
		--width = 400,
		--text = "12",
	--})
	----Ѫ��
	--_MarkchildUI["Blood"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvpexptt",
		--x = 200,
		--y = -98,
		--w = 140,
		--h = 18,
	--})
	
	----ս���ȼ�
	--_MarkchildUI["FightGradeLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 24,
		--align = "MT",
		--font = hVar.FONTC,
		--x = 670,
		--y = -18,
		--width = 400,
		--text = hVar.tab_string["PVPFightGrade"],
	--})
	
	----Բ��ͼƬ
	--_MarkchildUI["TitleImg"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvptitle",
		--x = 578,
		--y = -65,
	--})
	--_MarkchildUI["TitleImg2"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvptitle",
		--animation = "Image",
		--x = 576,
		--y = -65,
	--})

	----ƴ�ӵ���
	--_MarkchildUI["TitleLab"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvptitle",
		--animation = "word",
		--x = 680,
		--y = -67,
	--})

	----ս����ɾ�TABҳ�л��ĺ���
	--local function FightMarkorAchieve(state)
		--if state == 1 then
			----ս���ؼ�
			--_MarkchildUI["DataStaLab"].handle._n:setVisible(true)
			--_MarkchildUI["DataStaIma"].handle._n:setVisible(true)
			--_MarkchildUI["EnterNumLab"].handle._n:setVisible(true)
			--_MarkchildUI["EnterNumIma"].handle._n:setVisible(true)
			--_MarkchildUI["pvpcutlineIma"].handle._n:setVisible(true)
			--_MarkchildUI["pvpxyyIma"].handle._n:setVisible(true)
			--for i = 1,3 do
				--_MarkchildUI["pvpmedalIma"..i].handle._n:setVisible(true)
			--end
			--for i = 1,5 do
				--_MarkchildUI["pvpenter2Ima"..i].handle._n:setVisible(true)
			--end
			--for i = 1,5 do
				--_MarkchildUI["EnterHeroNameLab"..i].handle._n:setVisible(true)
				--_MarkchildUI["EnterHeroNameEx"..i].handle._n:setVisible(true)
				--_MarkchildUI["EnterBloodeNumberLab"..i].handle._n:setVisible(true)
			--end
			--_MarkchildUI["ArenaLab"].handle._n:setVisible(true)
			
			--_MarkchildUI["WinNumLab"].handle._n:setVisible(true)
			--_MarkchildUI["LoseLab"].handle._n:setVisible(true)
			--_MarkchildUI["LoseNumLab"].handle._n:setVisible(true)
			--_MarkchildUI["FleeLab"].handle._n:setVisible(true)
			--_MarkchildUI["FleeNumLab"].handle._n:setVisible(true)
			--_MarkchildUI["VictoryLab"].handle._n:setVisible(true)
			--_MarkchildUI["VictoryNumLab"].handle._n:setVisible(true)
			--_MarkchildUI["SuccessfullyLab"].handle._n:setVisible(true)
			--_MarkchildUI["SuccessfullyNumber"].handle._n:setVisible(true)
			--_MarkchildUI["WinnRateLab"].handle._n:setVisible(true)
			--_MarkchildUI["WinnRateNumber"].handle._n:setVisible(true)
			--_MarkchildUI["FightGradeLab"].handle._n:setVisible(true)
			--_MarkchildUI["FightGradeImg1"].handle._n:setVisible(true)
			--_MarkchildUI["FightGradeImg2"].handle._n:setVisible(true)

			--_MarkchildUI["FightMarkBtn"]:loadsprite("UI:pvpcxbb")
			--_MarkchildUI["AchieveBtn"]:loadsprite("UI:pvpcxbba")

			----�ɾͿؼ�
			--for i = 1,12 do
				--_MarkchildUI["AchieveBack"..i].handle._n:setVisible(false)
			--end
		--elseif state ==2 then
			----ս���ؼ�
			--_MarkchildUI["DataStaLab"].handle._n:setVisible(false)
			--_MarkchildUI["DataStaIma"].handle._n:setVisible(false)
			--_MarkchildUI["EnterNumLab"].handle._n:setVisible(false)
			--_MarkchildUI["EnterNumIma"].handle._n:setVisible(false)
			--_MarkchildUI["pvpcutlineIma"].handle._n:setVisible(false)
			--_MarkchildUI["pvpxyyIma"].handle._n:setVisible(false)
			--for i = 1,3 do
				--_MarkchildUI["pvpmedalIma"..i].handle._n:setVisible(false)
			--end
			--for i = 1,5 do
				--_MarkchildUI["pvpenter2Ima"..i].handle._n:setVisible(false)
			--end
			--for i = 1,5 do
				--_MarkchildUI["EnterHeroNameLab"..i].handle._n:setVisible(false)
				--_MarkchildUI["EnterHeroNameEx"..i].handle._n:setVisible(false)
				--_MarkchildUI["EnterBloodeNumberLab"..i].handle._n:setVisible(false)
			--end
			--_MarkchildUI["ArenaLab"].handle._n:setVisible(false)
			
			--_MarkchildUI["WinNumLab"].handle._n:setVisible(false)
			--_MarkchildUI["LoseLab"].handle._n:setVisible(false)
			--_MarkchildUI["LoseNumLab"].handle._n:setVisible(false)
			--_MarkchildUI["FleeLab"].handle._n:setVisible(false)
			--_MarkchildUI["FleeNumLab"].handle._n:setVisible(false)
			--_MarkchildUI["VictoryLab"].handle._n:setVisible(false)
			--_MarkchildUI["VictoryNumLab"].handle._n:setVisible(false)
			--_MarkchildUI["SuccessfullyLab"].handle._n:setVisible(false)
			--_MarkchildUI["SuccessfullyNumber"].handle._n:setVisible(false)
			--_MarkchildUI["WinnRateLab"].handle._n:setVisible(false)
			--_MarkchildUI["WinnRateNumber"].handle._n:setVisible(false)
			--_MarkchildUI["FightGradeLab"].handle._n:setVisible(false)
			--_MarkchildUI["FightGradeImg1"].handle._n:setVisible(false)
			--_MarkchildUI["FightGradeImg2"].handle._n:setVisible(false)

			--_MarkchildUI["FightMarkBtn"]:loadsprite("UI:pvpcxbba")
			--_MarkchildUI["AchieveBtn"]:loadsprite("UI:pvpcxbb")

			----�ɾͿؼ�
			--for i = 1,12 do
				--_MarkchildUI["AchieveBack"..i].handle._n:setVisible(true)
			--end
		--end
	--end
	
	----ս��
	--_MarkchildUI["FightMarkBtn"] = hUI.button:new({
		--parent = _Markparent,
		--dragbox = _Markfrm.childUI["dragBox"],
		--model = "UI:pvpcxbba",
		--size = 24,
		--font = hVar.FONTC,
		--x = 67,
		--y = -144,
		--label = hVar.tab_string["PVPFightMark"],
		--code = function()
			--FightMarkorAchieve(1)
		--end,
	--})
	----�ɾ�
	--_MarkchildUI["AchieveBtn"] = hUI.button:new({
		--parent = _Markparent,
		--dragbox = _Markfrm.childUI["dragBox"],
		--model = "UI:pvpcxbba",
		--size = 24,
		--font = hVar.FONTC,
		--x = 154,
		--y = -144,
		--label = hVar.tab_string["__TEXT_Achievement"],
		--code = function()
			--FightMarkorAchieve(2)
		--end,
	--})
	---------------------------------------------------
	----ս���е�ҳ��
	----���ݸſ�
	--_MarkchildUI["DataStaIma"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvpenter1",
		--x = 98,
		--y = -182,
	--})
	--_MarkchildUI["DataStaLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "MT",
		--font = hVar.FONTC,
		--x = 73,
		--y = -172,
		--width = 400,
		--text = hVar.tab_string["PVPDataSta"],
	--})
	----ѫ��
	--for i = 1,3 do
		--_MarkchildUI["pvpmedalIma"..i] = hUI.image:new({
			--parent = _Markparent,
			--model = "UI:pvpmedal",
			--x = 100 + (i-1)*138,
			--y = -350,
		--})
	--end
	
	----��������
	--_MarkchildUI["EnterNumIma"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvpenter1",
		--x = 519,
		--y = -182,
	--})
	--_MarkchildUI["EnterNumLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "MT",
		--font = hVar.FONTC,
		--x = 494,
		--y = -172,
		--width = 400,
		--text = hVar.tab_string["PVPEnterNum"],
	--})

	----Ӣ����Ϣ�װ�
	--for i = 1,5 do
		--_MarkchildUI["pvpenter2Ima"..i] = hUI.image:new({
			--parent = _Markparent,
			--model = "UI:pvpenter2",
			--x = 597,
			--y = -245 - (i-1)*55,
		--})
	--end

	----�ָ���
	--_MarkchildUI["pvpcutlineIma"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvpcutline",
		--x = 450,
		--y = -355,
	--})

	--_MarkchildUI["pvpxyyIma"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvpxyy",
		--x = 240,
		--y = -495,
	--})
	
	----����Ӣ�����ֺ;���
	--for i = 1,5 do
		--_MarkchildUI["EnterHeroNameLab"..i] = hUI.label:new({
			--parent = _Markparent,
			--size = 26,
			--align = "LC",
			--font = hVar.FONTC,
			--x = 460,
			--y = -245 - (i-1)*55,
			--width = 400,
			--text = hVar.tab_string["__TEXT_LvBu"],
		--})

		--_MarkchildUI["EnterHeroNameEx"..i] = hUI.image:new({
			--parent = _Markparent,
			--model = "UI:pvpenterbloode",
			--x = 580,
			--y = -245 - (i-1)*55,
		--})

		--_MarkchildUI["EnterBloodeNumberLab"..i] = hUI.label:new({
			--parent = _Markparent,
			--size = 22,
			--align = "LC",
			--font = hVar.FONTC,
			--x = 650,
			--y = -245 - (i-1)*55,
			--width = 400,
			--RGB = {255,0,0},
			--text = "123",
		--})
	--end

	--local _laby = -495
	
	----ս������
	--_MarkchildUI["VictoryLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 336,
		--x = 65,
		--y = _laby,
		--width = 400,
		--text = hVar.tab_string["__TEXT__Account_Strength"]..":",
	--})
	----ս������������
	--_MarkchildUI["VictoryNumLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 383,
		--x = 133,
		--y = _laby,
		--width = 400,
		--text = "1200",
	--})
	----ʤ��
	--_MarkchildUI["ArenaLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 199,
		--y = _laby,
		--width = 400,
		--text = hVar.tab_string["PVPWin"],
	--})
	----ʤ��������
	--_MarkchildUI["WinNumLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 155,
		--x = 227,
		--y = _laby,
		--width = 400,
		--text = "200",
	--})

	----�ܣ�
	--_MarkchildUI["LoseLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 193,
		--x = 275,
		--y = _laby,
		--width = 400,
		--text = hVar.tab_string["__TEXT_Fail"],
	--})
	----�ܣ�������
	--_MarkchildUI["LoseNumLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 222,
		--x = 303,
		--y = _laby,
		--width = 400,
		--text = "200",
	--})
	----�ӣ�
	--_MarkchildUI["FleeLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 267,
		--x = 351,
		--y = _laby,
		--width = 400,
		--text = hVar.tab_string["PVPFlee"],
	--})
	----�ӣ�������
	--_MarkchildUI["FleeNumLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 20,
		--align = "LC",
		--font = hVar.FONTC,
		----x = 296,
		--x = 378,
		--y = _laby,
		--width = 400,
		--text = "200",
	--})
	--------------------------------------------------------
	----ʤ��
	--_MarkchildUI["SuccessfullyLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 18,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 80,
		--y = -300,
		--border = 1,
		--RGB = {215,167,5},
		--width = 400,
		--text = hVar.tab_string["PVPWin"],
	--})
	----ʤ������
	--_MarkchildUI["SuccessfullyNumber"] = hUI.label:new({
		--parent = _Markparent,
		--size = 34,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 68,
		--y = -345,
		--RGB = {226,223,152},
		--width = 400,
		--text = "1234",
	--})
	----ʤ��
	--_MarkchildUI["WinnRateLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 18,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 218,
		--y = -300,
		--border = 1,
		--RGB = {215,167,5},
		--width = 400,
		--text = hVar.tab_string["PVPWinnRate"],
	--})
	----ʤ������
	--_MarkchildUI["WinnRateNumber"] = hUI.label:new({
		--parent = _Markparent,
		--size = 34,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 210,
		--y = -345,
		--RGB = {226,223,152},
		--width = 400,
		--text = "45%",
	--})
	----ս���ȼ�
	--_MarkchildUI["FightGradeLab"] = hUI.label:new({
		--parent = _Markparent,
		--size = 18,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 340,
		--y = -300,
		--border = 1,
		--RGB = {215,167,5},
		--width = 400,
		--text = hVar.tab_string["PVPFightGrade"],
	--})

	----ս���ȼ���ͼƬ
	--_MarkchildUI["FightGradeImg1"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvptitle",
		--x = 377,
		--y = -345,
	--})
	--_MarkchildUI["FightGradeImg2"] = hUI.image:new({
		--parent = _Markparent,
		--model = "UI:pvptitle",
		--animation = "Image",
		--x = 376,
		--y = -346,
	--})

	---------------------------------------------------
	----�ɾ��е�ҳ��
	--for i = 1,12 do
		--_MarkchildUI["AchieveBack"..i] = hUI.image:new({
			--parent = _Markparent,
			--model = "UI:MADEL_BANNER",
			--x = 153 + (i-1)%3*230,
			--y = -245 - math.floor((i-1)/3)*73,
			--w = 228,
			--h = 60,
		--})
		--_MarkchildUI["AchieveBack"..i].handle._n:setVisible(false)
	--end

	--hGlobal.event:listen("LocalEvent_PVPMyMark","__PVPMyMark",function(state)
		--if state == 1 then
			--_Markfrm:show(1)
			--_Markfrm:active()
			--FightMarkorAchieve(1)
		--elseif state == 0 then
			--_Markfrm:show(0)
		--end
	--end)

	----�л�Ӣ��
	--hGlobal.UI.PVPChangeHeroFram = hUI.frame:new({
		--x = hVar.SCREEN.w/2 - 317,
		--y = hVar.SCREEN.h/2 + 133,
		--dragable = 0,
		--show = 0,
		--h = 400,
		--w = 700,
		--background = -1,--"UI:pvptlback",
		--autoactive = 0,
		--codeOnDragEx = function(touchX,touchY,touchMode)
			
		--end,
	--})
	--local _Changefrm = hGlobal.UI.PVPChangeHeroFram
	--local _ChangechildUI = _Changefrm.childUI
	--local _Changeparent = _Changefrm.handle._n

	--_ChangechildUI["back1"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 128,
		--y = -128,
	--})
	--_ChangechildUI["back2"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 384,
		--y = -128,
	--})
	--_ChangechildUI["back3"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 606,
		--y = -128,
		--h = 256,
		--w = 188,
	--})
	--_ChangechildUI["back4"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 128,
		--y = -328,
		--w = 256,
		--h = 144,
	--})
	--_ChangechildUI["back5"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 384,
		--y = -328,
		--w = 256,
		--h = 144,
	--})
	--_ChangechildUI["back6"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback",
		--x = 606,
		--y = -328,
		--w = 188,
		--h = 144,
	--})
	--_ChangechildUI["back7"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback2",
		--x = 19,
		--y = -19,
	--})
	--_ChangechildUI["back8"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback2",
		--animation = "up",
		--x = 681,
		--y = -19,
	--})
	--_ChangechildUI["back9"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback2",
		--animation = "down",
		--x = 19,
		--y = -381,
	--})
	--_ChangechildUI["back10"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback2",
		--animation = "left",
		--x = 681,
		--y = -381,
	--})
	--_ChangechildUI["back11"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback3",
		--x = 352,
		--y = -4,
		--h = 10,
		--w = 630,
	--})
	--_ChangechildUI["back12"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback3",
		--animation = "down",
		--x = 352,
		--y = -396,
		--h = 10,
		--w = 630,
	--})
	--_ChangechildUI["back13"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback4",
		--x = 4,
		--y = -200,
		--w = 8,
		--h = 330,
	--})
	--_ChangechildUI["back14"] = hUI.image:new({
		--parent = _Changeparent,
		--model = "UI:pvptlback4",
		--animation = "down",
		--x = 696,
		--y = -200,
		--w = 8,
		--h = 330,
	--})

	--for i = 1,24 do
		--_ChangechildUI["head"..i] = hUI.image:new({
			--parent = _Changeparent,
			--model = "UI:pvptlbackf",
			--x = 74 + ((i-1)%6)*110,
			--y = -66 - (math.floor((i-1)/6))*90,
			--scale = 0.9,
			
		--})
	--end

	----�ı�Ӣ��ͷ��
	--hGlobal.event:listen("LocalEvent_PVPChangeHeroHead","__ChangeHeroHead",function(herohead)
		--_MarkchildUI["Background"]:loadsprite(herohead)
	--end)

	--hGlobal.event:listen("LocalEvent_PVPTwoLevel","__PVPTwoLevel",function(state)
		--if state == 1 then
			--_Changefrm:show(1)
			--_Changefrm:active()
			--herolist = {}
			--local HeroCardList = {}
			--local playerinfo = LuaGetPlayerByName(g_curPlayerName)
			--if playerinfo then
				--HeroCardList = LuaSwitchPlayer(playerinfo)
				
				--if HeroCardList~=nil then
					--for i = 1,#HeroCardList do
						--herolist[#herolist+1] = HeroCardList[i]
					--end
				--end
				
				--for i = 1,24 do
					--hApi.safeRemoveT(_ChangechildUI,"herohead"..i)
				--end

				--for i = 1,#herolist do
					--if hVar.tab_unit[herolist[i].id] then
						--_ChangechildUI["herohead"..i] = hUI.button:new({
							--parent = _Changeparent,
							--dragbox = _Changefrm.childUI["dragBox"],
							--model = hVar.tab_unit[herolist[i].id].icon,
							--x = 74 + ((i-1)%6)*110,
							--y = -66 - (math.floor((i-1)/6))*90,
							--scale = 0.77,
							--code = function()
								--hGlobal.event:event("LocalEvent_PVPChangeHeroHead",hVar.tab_unit[herolist[i].id].icon)
								--_Changefrm:show(0)
							--end,
							
						--})
					--end
				--end
			--end
		--elseif state == 0 then
			--_Changefrm:show(0)
		--end
	--end)
--end