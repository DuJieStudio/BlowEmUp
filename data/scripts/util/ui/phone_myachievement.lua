--hGlobal.UI.InitPhone_MyAchievement = function()
	--local _touchX,_touchY = 0,0
	--local _vectorY,_vectorD= 0,0
	--local _indexY = 0
	--local _HeroCardPosX,_HeroCardPosY,_FrmHeroCardPosX,_FrmHeroCardPosY = 440,410,88,-70
	--local _ShowPosX,_ShowPosY = 0,0
	--local _M_State = 0

	--local _frm
	--local _childUI
	--local _parent

	--local _Achilist = {}			--�ɾ��б�UI����ľֲ�����
	--local _AchievementChild = {}		--�ɾ��б��еĿؼ�ָ�뱣��
	--local _AchievementChild_star = {}	--�ɾ��б��еĿؼ�ָ�뱣��
	--local _AchievementChild_richi = {}	--�ɾ��б��еĿؼ�ָ�뱣��
	--local _AchievementChild_blitz = {}	--�ɾ��б��еĿؼ�ָ�뱣��
	--local _AchievementChild_slot = {}	--�ɾ��б��еĿؼ�ָ�뱣��

	--local _ActionAchievementslotCallback = function()
		--tempIndoexY = _indexY
		--for i = 1,#_AchievementChild do 
			--_ShowPosX,_ShowPosY = 26, _FrmHeroCardPosY + 55 - tempIndoexY * 35
			--_childUI[_AchievementChild[i]].data.x,_childUI[_AchievementChild[i]].data.y = _ShowPosX,_ShowPosY
			--_childUI[_AchievementChild[i]].handle._n:setPosition(_ShowPosX,_ShowPosY)
			--if tempIndoexY < 0 or tempIndoexY > 9 then 
				--_childUI[_AchievementChild[i]].handle._n:setVisible(false)
			--end
			----tempIndoexY = tempIndoexY + 1
			----���°󶨵�frm �Ͽ�����ʾ�㼶 _AchievementChild_richi
			--hApi.ReloadParent(_childUI[_AchievementChild[i]].handle._n,_frm.handle._n)

			--local _star_ShowPosX,_star_ShowPosY = 225, _FrmHeroCardPosY + 45 - tempIndoexY * 35
			--_childUI[_AchievementChild_star[i]]:setXY(_star_ShowPosX,_star_ShowPosY)
			--if tempIndoexY < 0 or tempIndoexY > 9 then 
				--_childUI[_AchievementChild_star[i]].handle._n:setVisible(false)
			--end
			----���°󶨵�frm �Ͽ�����ʾ�㼶_AchievementChild_blitz
			--hApi.ReloadParent(_childUI[_AchievementChild_star[i]].handle._n,_frm.handle._n)

			--local _rich_ShowPosX,_rich_ShowPosY = 380, _FrmHeroCardPosY + 45 - tempIndoexY * 35
			--_childUI[_AchievementChild_richi[i]]:setXY(_rich_ShowPosX,_rich_ShowPosY)
			--if tempIndoexY < 0 or tempIndoexY > 9 then 
				--_childUI[_AchievementChild_richi[i]].handle._n:setVisible(false)
			--end
			----���°󶨵�frm �Ͽ�����ʾ�㼶_AchievementChild_star
			--hApi.ReloadParent(_childUI[_AchievementChild_richi[i]].handle._n,_frm.handle._n)

			--local _blitz_ShowPosX,_blitz_ShowPosY = 440, _FrmHeroCardPosY + 45 - tempIndoexY * 35
			--_childUI[_AchievementChild_blitz[i]]:setXY(_blitz_ShowPosX,_blitz_ShowPosY)
			--if tempIndoexY < 0 or tempIndoexY > 9 then 
				--_childUI[_AchievementChild_blitz[i]].handle._n:setVisible(false)
			--end
			----���°󶨵�frm �Ͽ�����ʾ�㼶 _AchievementChild_slot
			--hApi.ReloadParent(_childUI[_AchievementChild_blitz[i]].handle._n,_frm.handle._n)

			--local _slot_ShowPosX,_slot_ShowPosY = 500, _FrmHeroCardPosY + 45 - tempIndoexY * 35
			--_childUI[_AchievementChild_slot[i]]:setXY(_slot_ShowPosX,_slot_ShowPosY)
			--if tempIndoexY < 0 or tempIndoexY > 9 then 
				--_childUI[_AchievementChild_slot[i]].handle._n:setVisible(false)
			--end
			----���°󶨵�frm �Ͽ�����ʾ�㼶 _AchievementChild_slot
			--hApi.ReloadParent(_childUI[_AchievementChild_slot[i]].handle._n,_frm.handle._n)

			--tempIndoexY = tempIndoexY + 1
		--end
		----BtnFrm:active()
		--_M_State = 0
	--end
	
	----���ÿ�Ƭ����������ĺ���
	--local _Reset_AchievementPos = function(indexY)
		--if _M_State ~= 2 then return end
		--tempIndoexY = indexY
		--for i = 1,#_AchievementChild do 
			--_childUI[_AchievementChild[i]].handle._n:setVisible(true)
			--_ShowPosX,_ShowPosY = 378, _HeroCardPosY + 55 - tempIndoexY * 35
			--_childUI[_AchievementChild[i]].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(_ShowPosX,_ShowPosY)),CCCallFunc:create(_ActionAchievementslotCallback)))
			--tempIndoexY = tempIndoexY + 1
		--end
	--end

	--hGlobal.UI.InitPhone_MyAchievementFrm =hUI.frame:new({
			--x = 20,
			--y = hVar.SCREEN.h - 20,
			--h = hVar.SCREEN.h - 40,
			--w = hVar.SCREEN.w - 40,
			--show = 0,
			--dragable = 2,
			--titlebar = 0,
			--bgAlpha = 0,
			--bgMode = "tile",
			--background = "UI:tip_item",
			--border = 1,
			--autoactive = 0,
			--codeOnDragEx = function(touchX,touchY,touchMode)
				----����
				--if _M_State == 2 then return end
				--if touchMode == 0 then
					--_touchX,_touchY = touchX,touchY
					--_vectorD = touchY
				----����
				--elseif touchMode == 1 then
					--if _M_State == 0 then
						----ֻ�е�ǰҳ����Ӣ�ۿ�Ƭʱ
						--if _m_page_state == 2 then
							--for i = 1,#_AchievementChild do 
								--_childUI[_AchievementChild[i]].handle._n:setVisible(true)
								--hApi.ReloadParent(_childUI[_AchievementChild[i]].handle._n,clipper)
								--hApi.SetItemBeginPos(_childUI[_AchievementChild[i]],352,_HeroCardPosY-_FrmHeroCardPosY)
							--end

							--for i = 1,#_AchievementChild_star do 
								--_childUI[_AchievementChild_star[i]].handle._n:setVisible(true)
								--hApi.ReloadParent(_childUI[_AchievementChild_star[i]].handle._n,clipper)
								--hApi.SetItemBeginPos(_childUI[_AchievementChild_star[i]],352,_HeroCardPosY-_FrmHeroCardPosY)

								--_childUI[_AchievementChild_richi[i]].handle._n:setVisible(true)
								--hApi.ReloadParent(_childUI[_AchievementChild_richi[i]].handle._n,clipper)
								--hApi.SetItemBeginPos(_childUI[_AchievementChild_richi[i]],380,_HeroCardPosY-_FrmHeroCardPosY)

								--_childUI[_AchievementChild_blitz[i]].handle._n:setVisible(true)
								--hApi.ReloadParent(_childUI[_AchievementChild_blitz[i]].handle._n,clipper)
								--hApi.SetItemBeginPos(_childUI[_AchievementChild_blitz[i]],440,_HeroCardPosY-_FrmHeroCardPosY)

								--_childUI[_AchievementChild_slot[i]].handle._n:setVisible(true)
								--hApi.ReloadParent(_childUI[_AchievementChild_slot[i]].handle._n,clipper)
								--hApi.SetItemBeginPos(_childUI[_AchievementChild_slot[i]],380,_HeroCardPosY-_FrmHeroCardPosY)
							--end
						--end

						--_M_State = 1
					--end

					--if _m_page_state == 2 then
						--if math.abs(touchX-_touchX) > 50 and (touchX-_touchX) > 0 and math.abs(touchY-_touchY) < 80 then
							--_touchX,_touchY = touchX,touchY
							----print("��")
						--elseif math.abs(touchX-_touchX) > 50 and (touchX-_touchX) < 0 and math.abs(touchY-_touchY) < 80 then
							--_touchX,_touchY = touchX,touchY
							----print("��")
						--elseif (touchY-_touchY) > 0 and math.abs(touchX-_touchX) < 80 then
							----print("��")
							----��λ�ɾ�ҳ��ʱ
						
							--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild)
							--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_star)
							--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_richi)
							--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_blitz)
							--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_slot)
						
							--_touchX,_touchY = touchX,touchY
							--_vectorY = touchY - _vectorD
						--elseif (touchY-_touchY) < 0 and math.abs(touchX-_touchX) < 80 then
							----print("��")
							--if _m_page_state == 2 then
								--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild)
								--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_star)
								--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_richi)
								--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_blitz)
								--hApi.MoveItemList(nil,touchY-_touchY,_childUI,_AchievementChild_slot)
							--end
							--_touchX,_touchY = touchX,touchY
							--_vectorY = touchY - _vectorD
						--end
					--end
				----̧��
				--elseif touchMode == 2 then
					----if _vectorY > 0  and math.abs(_vectorY) > 100 then
						----_indexY = _indexY - 1
					----elseif _vectorY < 0 and math.abs(_vectorY) > 100 then
						----_indexY = _indexY + 1
					----end
					----_vectorY = 0
					--if _M_State == 1 then
						--_M_State = 2
						----��λ�ɾ�ҳ��ʱ
						--if _m_page_state == 2 then
							--if _vectorY > 0  and math.abs(_vectorY) > 30 then
								--_indexY = _indexY - math.floor(math.abs(_vectorY)/30)
							--elseif _vectorY < 0 and math.abs(_vectorY) > 30 then
								--_indexY = _indexY + math.floor(math.abs(_vectorY)/30)
							--end
							--_vectorY = 0
							----��������
							--if _indexY > 0 then 
								--_indexY = 0 
							--elseif _indexY < _MaxIndexY then 
								--_indexY = _MaxIndexY
							--end

							----���ݵ�ǰ�����������ÿ�Ƭλ�ö���
							--_Reset_AchievementPos(_indexY)
						--end
						
					--end
				--end
			--end,
	--})

	--_frm = hGlobal.UI.InitPhone_MyAchievementFrm
	 --_childUI = _frm.childUI
	--_parent = _frm.handle._n

	----CCClippingNode �Ĵ���
	--clipper = CCClippingNode:create(_parent)
	----clipper:setTag(kTagClipperNode)
	--clipper:setAnchorPoint(ccp(0, 0))
	--clipper:setPosition(ccp(0,0))
	----�󶨵��ü�Layer
	--hUI.__static.uiClippingLayer:addChild(clipper,1)

	----��ǰ�ɾͱ���
	--local MaxLen = {}
	--for k,v in pairs(hVar.MAP_INFO) do
		--if v.mapType and v.mapType == 1 and v.level and v.level > 0 then
			--MaxLen[v.level] = k
		--end
	--end
	
	----�ɾ�˵�����
	--local achiinfofram = nil 
	--achiinfofram = hUI.frame:new({
			--x = 450,
			--y = 450,
			--background = "UI:PANEL_INFO_MINI",
			--dragable = 2,
			--show = 0,
			--titlebar = 0,
			--closebtn = "BTN:PANEL_CLOSE",
	--})
	--local _achichildUI = achiinfofram.childUI

	----�ɾ�����
	--_achichildUI["achiName"] = hUI.label:new({
		--size = 28,
		--parent = achiinfofram.handle._n,
		--align = "MC",
		--font = hVar.FONTC,
		--x = 220,
		--y = -50,
		--width = 270,
		--RGB = {255,215,0},
		--border = 1,
		--text = "",
	--})

	----�ɾ�ͼƬ����
	--_achichildUI["achi_slot"] = hUI.image:new({
		--parent = achiinfofram.handle._n,
		--model = "UI_frm:slot",
		--animation = "lightSlim",
		--x = 70,
		--y = -65,
		--w = 60,
	--})

	----�ɾ���Ϣ
	--_achichildUI["achiInfoLab"] = hUI.label:new({
		--size = 26,
		--parent = achiinfofram.handle._n,
		--align = "LC",
		--font = hVar.FONTC,
		--x = 55,
		--y = -140,
		--width = 300,
		----RGB = {255,215,0},
		--border = 1,
		--text = hVar.tab_string["__TEXT_ThankForPlayer"],
	--})

	----��ʾ �����Ļص�
	--local _showAchiFrmCallBack = function()
		--achiinfofram:active()
	--end

	----���ݵ�ͼlevel ��� ��ͼ����key
	--local getmapnamefromlevel = function(level)
		--for k,v in pairs(hVar.MAP_INFO) do
			--if v.level and v.level == level then
				--return k
			--end
		--end
	--end

	--local getmapscore = function(level)
		--local mapkey = getmapnamefromlevel(level)
		--for k,v in pairs(hVar.MAP_SCORE) do
			--if k == mapkey then
				--return v
			--end
		--end
	--end
	----��ʾ �ɾ���Ϣ��嶯��
	--local _showAchiFrm = function(mode,level)
		--_achichildUI["achiName"]:setText("")
		--_achichildUI["achiInfoLab"]:setText("")
		--hApi.safeRemoveT(_achichildUI,"achi_image")
		--if _m_page_state ~= 2 then return end
		--local model = nil
		--local mapScore = getmapscore(level)
		
		--if mapScore ~= nil then
			----������Ϣ
			--if mode == "star" then
				--local star = mapScore[4][1]
				--_achichildUI["achiName"]:setText(hVar.tab_string["__TEXT_LevelStar"])
				--_achichildUI["achiInfoLab"]:setText(hVar.tab_string["__TEXT_LevelStarInfo1"]..star..hVar.tab_string["__TEXT_LevelStarInfo2"])
				--model = "UI:STAR_YELLOW"
			----���ɵй�
			--elseif mode == "rich" then
				--local gold = mapScore[5] or 0
				--_achichildUI["achiName"]:setText(hVar.tab_string["__TEXT_Achievement"].." : "..hVar.tab_string["__TEXT_LevelRich"])
				--_achichildUI["achiInfoLab"]:setText(hVar.tab_string["__TEXT_LevelRichInfo"]..gold.." "..hVar.tab_stringU[42000][1])
				--model = "UI:ach_weathy"
			----����ս
			--elseif mode == "blitz" then
				--local day = (mapScore[6] or 0) + 1 
				--_achichildUI["achiName"]:setText(hVar.tab_string["__TEXT_Achievement"].." : "..hVar.tab_string["__TEXT_LevelBlitz"])
				--_achichildUI["achiInfoLab"]:setText(day..hVar.tab_string["__TEXT_LevelBlitzInfo"])
				--model = "UI:ach_lightning"
			----�ʹ�
			--elseif mode == "imperial" then
				--_achichildUI["achiName"]:setText(hVar.tab_string["__TEXT_Achievement"].." : "..hVar.tab_string["__TEXT_LevelImperial"])
				--_achichildUI["achiInfoLab"]:setText(hVar.tab_string["__TEXT_LevelImperialInfo"])
				--model = "UI:ach_king"
			--else

			--end
			
			--_achichildUI["achi_image"] = hUI.image:new({
				--parent = achiinfofram.handle._n,
				--model = model,
				--x = 70,
				--y = -65,
				--w = 55,
			--})

			--achiinfofram:show(1)
			--achiinfofram.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(achiinfofram.data.x,achiinfofram.data.y),5,1),CCCallFunc:create(_showAchiFrmCallBack)))

		--end
	--end

	----�ɾ��б� clipper 400,470
	--local _achiX,_achiY,_offx,_offy,_h = 25,-13,520,35,34
	--for i = 1,#MaxLen do
		--_childUI["achilist_"..i] = hUI.label:new({
			--parent =  _parent,
			--size = 24,
			--align = "LT",
			--font = hVar.FONTC,
			--x = _achiX,
			--y = _achiY - (i-1)*_offy,
			--width = 540,
			--text = "fuck fuck",
		--})
		--_childUI["achilist_"..i].handle._n:setVisible(false)
		--_Achilist[#_Achilist+1] = _childUI["achilist_"..i]
		--_AchievementChild[#_AchievementChild+1] = "achilist_"..i

		--_childUI["achilist_finish_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:finish",
			--x = 520,
			--y = -10,
			--w = _h,
		--})
		--_childUI["achilist_finish_"..i].handle._n:setVisible(false)
		----_AchievementChild[#_AchievementChild+1] = "achilist_finish_"..i
		
		----������ʾ�ɾ����ǵĲ���
		--for j = 1,3 do
			--_childUI["star_slot_"..i..j] =hUI.image:new({
				--parent = _childUI["achilist_"..i].handle._n,
				--model = "UI:star_slot",
				--x = 205 + (j-1)*40,
				--y = -10,
				--w = 36,
				--h = 36,
			--})
			--_childUI["star_slot_"..i..j].handle._n:setVisible(false)
			----_AchievementChild[#_AchievementChild+1] = "star_slot_"..i..j
		--end
		
		----����˵�� ��ť
		--_childUI["star_button_"..i] = hUI.button:new({
			--parent = _parent,
			--model = -1,
			--dragbox = _childUI["dragBox"],
			--w = 200,
			--h = _h,
			--x = 225,
			--y = -23-(i-1)*35,
			--code = function()
				----print(_M_State,"aaaaaaaaaaaaaaaaaaaaa")
				--if _M_State == 0 then
					--_showAchiFrm("star",i)
				--end
			--end,
		--})
		--_AchievementChild_star[#_AchievementChild_star+1] = "star_button_"..i

		----���ɵй�����
		--_childUI["achilist_rich_slot_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_weathy_slot",
			--x = _achiX + 330,
			--y = -10,
			--w = _h,
			--h = _h,
		--})
		----_AchievementChild[#_AchievementChild+1] = "achilist_rich_slot_"..i

		--_childUI["achilist_rich_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_weathy",
			--x = _achiX + 330,
			--y = -10,
			--w = _h,
			--h = _h,

		--})
		--_childUI["achilist_rich_"..i].handle._n:setVisible(false)
		----_AchievementChild[#_AchievementChild+1] = "achilist_rich_"..i
		
		--_childUI["achilist_rich_button_"..i] = hUI.button:new({
			--parent = _parent,
			--model = -1,
			--dragbox = _childUI["dragBox"],
			--w = _h,
			--h = _h,
			--x = 380,
			--y = -23-(i-1)*35,
			--code = function()
				--if _M_State == 0 then
					--_showAchiFrm("rich",i)
				--end
			--end,
		--})
		--_AchievementChild_richi[#_AchievementChild_richi+1] = "achilist_rich_button_"..i

		----����ս����
		--_childUI["achilist_blitz_slot_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_lightning_slot",
			--x = _achiX + 390,
			--y = -10,
			--w = _h,
			--h = _h,
		--})
		----_AchievementChild[#_AchievementChild+1] = "achilist_blitz_slot_"..i
		
		--_childUI["achilist_blitz_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_lightning",
			--x = _achiX + 390,
			--y = -10,
			--w = _h,
			--h = _h,
		--})
		--_childUI["achilist_blitz_"..i].handle._n:setVisible(false)
		

		--_childUI["achilist_blitz_button_"..i] = hUI.button:new({
			--parent = _parent,
			--model = -1,
			--dragbox = _childUI["dragBox"],
			--w = _h,
			--h = _h,
			--x = 440,
			--y = -23-(i-1)*35,
			--code = function()
				--if _M_State == 0 then
					--_showAchiFrm("blitz",i)
				--end
			--end,
		--})
		--_AchievementChild_blitz[#_AchievementChild_blitz+1] = "achilist_blitz_button_"..i

		----�ʹ�
		--_childUI["achilist_imperial_slot_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_king_slot",
			--x = _achiX + 450,
			--y = -10,
			--w = _h,
			--h = _h,
		--})
		--_childUI["achilist_imperial_slot_"..i].handle._n:setVisible(false)
		----_AchievementChild[#_AchievementChild+1] = "achilist_imperial_slot_"..i

		--_childUI["achilist_imperial_"..i] =hUI.image:new({
			--parent = _childUI["achilist_"..i].handle._n,
			--model = "UI:ach_king",
			--x = _achiX + 450,
			--y = -10,
			--w = _h,
			--h = _h,
		--})
		--_childUI["achilist_imperial_"..i].handle._n:setVisible(false)
		----_AchievementChild[#_AchievementChild+1] = "achilist_imperial_"..i

		--_childUI["achilist_imperial_button_"..i] = hUI.button:new({
			--parent = _parent,
			--model = -1,
			--dragbox = _childUI["dragBox"],
			--w = _h,
			--h = _h,
			--x = _achiX + 475,
			--y = -23-(i-1)*35,
			--code = function()
				--if _M_State == 0 then
					--_showAchiFrm("imperial",i)
				--end
			--end,
		--})
		--_AchievementChild_slot[#_AchievementChild_slot+1] = "achilist_imperial_button_"..i

	--end

	--local StarList = {}
	----��ʾ�������ɾͽ���
	--local _createAchievementfram = function(curPlayerName)
		--_m_page_state= 2
		--_M_State = 0 
		----���ݵ�ǰ������ֻ�ȡ�ɾ��б�
		----ɾ�������Ǳ�
		--for i = 1,#StarList do
			--hApi.safeRemoveT(_childUI,StarList[i])
		--end
		--StarList = {}

		--local achilist = nil
		--local playerinfo = nil

		--playerinfo = LuaGetPlayerData()
		--if playerinfo then
			--achilist = playerinfo.achievement
		--end
		--local listN = #MaxLen

		--_MaxIndexY = -(listN - 10)

		--for i = 1, listN do
			--_Achilist[i]:setText(hVar.MAP_INFO[MaxLen[i]].name)
			--_Achilist[i].handle._n:setVisible(true)

			--_Achilist[i].handle._n:setPosition(25,-13 - (i-1)*35)
			--_Achilist[i].data.y = -13 - (i-1)*35
			--_Achilist[i].data.x = 25
			
			--_childUI["star_button_"..i]:setstate(1)
			--_childUI["achilist_rich_button_"..i]:setstate(1)
			--_childUI["achilist_blitz_button_"..i]:setstate(1)

			----ͨ����Ϣ
			--if LuaGetPlayerMapAchi(MaxLen[i],hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
				--_childUI["achilist_finish_"..i].handle._n:setVisible(true)
			--end
			
			--_childUI["achilist_rich_slot_"..i].handle._n:setVisible(true)
			----���ɵй�
			--if LuaGetPlayerMapAchi(MaxLen[i],hVar.ACHIEVEMENT_TYPE.RICHMAN) == 1 then
				--_childUI["achilist_rich_"..i].handle._n:setVisible(true)
			--end

			--_childUI["achilist_blitz_slot_"..i].handle._n:setVisible(true)
			----����ս
			--if LuaGetPlayerMapAchi(MaxLen[i],hVar.ACHIEVEMENT_TYPE.BLITZ) == 1 then
				--_childUI["achilist_blitz_"..i].handle._n:setVisible(true)
			--end
			
			----�ʹ�
			--_childUI["achilist_imperial_slot_"..i].handle._n:setVisible(true)
			--if LuaGetPlayerMapAchi(MaxLen[i],hVar.ACHIEVEMENT_TYPE.IMPERIAL) == 1 then
				--_childUI["achilist_imperial_"..i].handle._n:setVisible(true)
			--end

			----��ȫ�������ǲ���
			--for j = 1,3 do
				--_childUI["star_slot_"..i..j].handle._n:setVisible(true)
			--end
			--local nScore = LuaGetPlayerMapAchi(MaxLen[i],hVar.ACHIEVEMENT_TYPE.MAPSTAR)
			--if nScore ~= nil then 
				--local miniSta,maxStar ,starmini,starmax = nScore%2,math.ceil(nScore/2),"UI:star_half","UI:STAR_YELLOW"
				--for j = 1,maxStar do
					----����
					--local model = starmax
					--if miniSta == 1 and j == maxStar then
						--model = starmini
					--end

					--_childUI["star_"..i..j] = hUI.image:new({
						--parent = _childUI["achilist_"..i].handle._n,
						--model = model,
						--w = 36,
						--h = 36,
						--x = _achiX + 180 + (j-1)*40,
						--y = -10,
						--scale = 0.9,
					--})
					--StarList[#StarList+1] = "star_"..i..j
					----_AchievementChild[#_AchievementChild+1] = "star_"..i..j
				--end
			--end
		--end
		--for i = 11,#MaxLen do
			--_Achilist[i].handle._n:setVisible(false)
		--end
	--end

	----���سɾ��б����
	--local _hideAchievenmentfram = function()
		--for i = 1,#MaxLen do
			--_childUI["achilist_"..i].handle._n:setVisible(false)
			--_childUI["achilist_finish_"..i].handle._n:setVisible(false)	--ͨ����Ϣ
			--_childUI["achilist_rich_slot_"..i].handle._n:setVisible(false)	--���ɵй�
			--_childUI["achilist_rich_"..i].handle._n:setVisible(false)
			--_childUI["achilist_blitz_slot_"..i].handle._n:setVisible(false)	--����ս
			--_childUI["achilist_blitz_"..i].handle._n:setVisible(false)
			--_childUI["achilist_imperial_slot_"..i].handle._n:setVisible(false)
			--_childUI["achilist_imperial_"..i].handle._n:setVisible(false)
			--_childUI["star_button_"..i]:setstate(-1)
			--_childUI["achilist_rich_button_"..i]:setstate(-1)
			--_childUI["achilist_blitz_button_"..i]:setstate(-1)

			--for j = 1,3 do
				--_childUI["star_slot_"..i..j].handle._n:setVisible(false)
			--end
		--end

		----ɾ�������Ǳ�
		--for i = 1,#StarList do
			--hApi.safeRemoveT(_childUI,StarList[i])
		--end
		--StarList = {}
	--end
	--_hideAchievenmentfram()

	----�˳���ť
	--_childUI["btnClose1"] = hUI.button:new({
		--parent = _parent,
		--model = "BTN:PANEL_CLOSE",
		--dragbox = _childUI["dragBox"],
		--scaleT = 0.9,
		--x = hVar.SCREEN.w - 50,
		--y = -12,
		--code = function()
			--_frm:show(0)
			----hGlobal.event:event("LocalEvent_Phone_ClosePlayerCardHeroFrm")
		--end,
	--})

	--hGlobal.event:listen("LocalEvent_Phone_ShowMyAchievement","ShowMyAchievement",function()
		--_createAchievementfram(g_curPlayerName)

		--_frm:show(1)
		--_frm:active()
	--end)
--end