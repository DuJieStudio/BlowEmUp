


-----------------------------------------------------------
--function:	VIP���棨�½��棩
--Writer:	pangyong 2016/10/11
-----------------------------------------------------------
hGlobal.UI.InitMyVIPFrame = function(mode)
	local tInitEventName = {"localEvent_ShowMyVIPFrm", "__ShowMyVIPFrm"}
	if mode~="include" then
		return tInitEventName
	end
	
	--Frame����
	local _MV_FrmWH = {880, 544}
	local _MV_FrmXY = {hVar.SCREEN.w/2-_MV_FrmWH[1]/2, hVar.SCREEN.h/2+_MV_FrmWH[2]/2 - 20}
	local _MV_Frame
	local _parent
	local _childUI
	local _CurrentPage = 1								--��ǰVIPҳ��
	local _nMaxVIP = #hVar.VipRmb						--���VIP�ȼ�����������õ�������ֵ��
	
	--Grid����
	local _nMaxLines = 10									--Grid�������
	local _nLine, _nColumn = 10, 1							--һҳ��ʾ�� ���� ����
	local _tCliprect = {108, -196 + 80, 650, 238 + 90, 0}	--��������
	local _tGrid = {}								--Grid����
	local _nGridx = _tCliprect[1] + math.ceil(_tCliprect[3]/(_nColumn*2)) - 60
	local _nGridy = _tCliprect[2] - math.ceil((_tCliprect[4]-10)/(_nLine*2)) - 5
	local _nGridw, _nGridh = math.ceil(_tCliprect[3]/_nColumn), math.ceil((358 + 62 - 10)/_nLine)
	local _tAutoAlign = {"V", "baggrid_ItemList", math.ceil(_nGridh/3), 0, -math.ceil(_nGridh/3)}	--������䣬grid���֣������� �������ص�����
	local _tDragRect = {0,0,0,0}							--��ק��Χ

	--����
	local _CODE_CreateItem = hApi.DoNothing						--����Boss�б�
	local _CODE_CutVIPPage = hApi.DoNothing						--�л�VIP��ʾ
	local _CODE_HitPage = hApi.DoNothing						--ʰȡ
	local _CODE_DragPage = hApi.DoNothing						--��ק
	local _CODE_DropPage = hApi.DoNothing						--̧��
	
	--����
	--local _dailyRewardFlag = 0 --�Ƿ���ȡ���ս���
	
	--����
	hGlobal.UI.MyVIPFrame = hUI.frame:new({
		x = _MV_FrmXY[1],
		y = _MV_FrmXY[2],
		w = _MV_FrmWH[1],
		h = _MV_FrmWH[2],
		dragable = 2,			--�������رմ���
		border = 1,
		background = "UI:tip_item",
		show = 0,
		codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
			local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
			if tPickParam~=nil then
				--���Grid
				return self:pick(tPickParam.sGridName,_tDragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tPickParam})
			end
		end,
	})
	_MV_Frame = hGlobal.UI.MyVIPFrame
	_parent = _MV_Frame.handle._n
	_childUI = _MV_Frame.childUI
	--print("InitMyVIPFrame ����")
	-------------------------------------------------------------------------------------------UI
	----�ڲ�
	--_childUI["image_BackPanel"] = hUI.image:new({
		--parent = _parent,
		--model = "UI:frame_back",
		--x = hVar.SCREEN.w/2 - _MV_FrmXY[1],
		--y = hVar.SCREEN.h/2 - _MV_FrmXY[2],
		--w = hVar.SCREEN.w,
		--h = hVar.SCREEN.h,
		--z = -20,
	--})
	
	--�رհ�ť
	_childUI["button_Close"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "BTN:PANEL_CLOSE",
		x = _MV_FrmWH[1]-4,
		y = -4,
		scaleT = 0.95,
		code = function(self)
			_CurrentPage = 1
			--hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
			_MV_Frame:show(0)
		end,
	})
	
	--����ͼ
	_childUI["rmbBg"] = hUI.image:new({
		parent = _parent,
		model = "UI:selectbg3",
		x = _MV_FrmWH[1]/2,
		y = -62,
		w = _MV_FrmWH[1]-100,
		h = 72,
	})
	
	--VIPͼ��
	_childUI["image_VIP"]= hUI.image:new({
		parent = _parent,
		model = "UI:vip1",
		x = _childUI["rmbBg"].data.x - 302,
		y = _childUI["rmbBg"].data.y,
		w = 70,
		h = 70,
	})
	
	--�����ֵ��
	_childUI["label_CumulativCharge"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		align = "MC",
		border = 1,
		font = hVar.FONTC,
		x = _childUI["rmbBg"].data.x-190,
		y = _childUI["rmbBg"].data.y+14,
		text = hVar.tab_string["Totoltopup"],
		size = 24,
	})
	
	--���ֵ��ֵ
	_childUI["vipRmbNeedLabel"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		font = hVar.FONTC,
		align = "MC",
		border = 1,
		x = _childUI["rmbBg"].data.x-190,
		y = _childUI["rmbBg"].data.y-16,
		text = " ",
		size = 24,
	})
	
	--�ѳ�ֵ
	_childUI["RmbC"]= hUI.label:new({
		parent = _parent,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = _childUI["rmbBg"].data.x+40,
		y = _childUI["rmbBg"].data.y - 4,
		text = hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCount())..hVar.tab_string["Rmb"],
		size = 24,
	})
	
	--��λת����ť����Ϸ�� �� Ǯ��
	_childUI["button_ShowCoinOrMoney"]= hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = _childUI["rmbBg"].data.x-76,
		y = _childUI["rmbBg"].data.y,
		w = 600,
		h = 80,
		code = function(self)
			--�ж��豸
			local showMoneyOrCoin = 0 --��ʾ��ʽ����Ϸ��/Ԫ��
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
				showMoneyOrCoin = xlGetIntFromKeyChain("xlShowMoneyOrCoin")
			--windows
			else
				showMoneyOrCoin = CCUserDefault:sharedUserDefault():getIntegerForKey("xlShowMoneyOrCoin")
			end
			
			if (showMoneyOrCoin == 1) then
				showMoneyOrCoin = 0
				--�ѳ�ֵ������ң�
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCount())..hVar.tab_string["Rmb"])
				
				--��ֵ�ۼƽ�
				_childUI["vipRmbNeedLabel"]:setText((hVar.Vip_Conifg.condition.rmb[_CurrentPage] or "").." "..hVar.tab_string["Rmb"])
				
				--���س�ֵ��ʾ��ť
				--_childUI["button_VipTip"]:setstate(-1)
			elseif (showMoneyOrCoin == 0) then
				showMoneyOrCoin = 1
				--�ѳ�ֵ����Ϸ�ң�
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCoinCount())..hVar.tab_string["__TEXT_Account_Balance"])
				
				--��ֵ�ۼƽ�
				_childUI["vipRmbNeedLabel"]:setText((hVar.Vip_Conifg.condition.coin[_CurrentPage] or "").." "..hVar.tab_string["__TEXT_Account_Balance"])
				
				--��ʾ��ֵ��ʾ��ť
				--_childUI["button_VipTip"]:setstate(1)
			end
			
			--�����־
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
				xlSaveIntToKeyChain("xlShowMoneyOrCoin", showMoneyOrCoin)
			--windows
			else
				CCUserDefault:sharedUserDefault():setIntegerForKey("xlShowMoneyOrCoin", showMoneyOrCoin)
				CCUserDefault:sharedUserDefault():flush()
			end
		end,
	})
	_childUI["button_ShowCoinOrMoney"].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
	
	--"ȥ��ֵ"��ť
	_childUI["button_GoToBuy"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc.mask.png",
		scaleT = 0.95,
		x = _MV_FrmWH[1] - 160,
		y = -62,
		w = 150,
		h = 80,
		scaleT = 0.95,
		code = function(self,x,y,isInside)
			--������Ϸ��
			hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
		end,
	})
	_childUI["button_GoToBuy"].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
	--��ťͼ��
	_childUI["button_GoToBuy"].childUI["btnImage"] = hUI.image:new({
		parent = _childUI["button_GoToBuy"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = 0,
		w = 120,
		h = 48,
	})
	--��ť����
	_childUI["button_GoToBuy"].childUI["btnLabel"] = hUI.label:new({
		parent = _childUI["button_GoToBuy"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = -2,
		text = hVar.tab_string["__TEXT_GoToRecharge"], --"ȥ��ֵ"
		font = hVar.FONTC,
		size = 26,
		align = "MC",
		border = 1,
		RGB = {254, 192, 35,},
	})
	
	--[[
	--��ֵ��ʾ��ť
	_childUI["button_VipTip"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:tip",
		x = _MV_FrmWH[1] - 263,
		y = -62,
		w = 56,
		h = 56,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_Phone_ShowCoinInfoFrm",1)
		end,
	})
	]]
	
	--��һ�ȼ���ҳ��ť��ֻ��Ӧ�¼�������ʾ��
	_childUI["button_LastVIP"] = hUI.button:new({
		parent = _MV_Frame,
		model = "misc/mask.png",
		scaleT = 0.95,
		x = 52,
		y = -_MV_FrmWH[2]/2,
		w = 80,
		h = 120,
		code = function(self,x,y,isInside)
			_CurrentPage = _CurrentPage - 1
			_CODE_CutVIPPage(_CurrentPage)
		end,
	})
	_childUI["button_LastVIP"].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
	_childUI["button_LastVIP"]:setstate(-1) --geyachao: ���ط�ҳ��ť
	_childUI["button_LastVIP"].childUI["icon"] = hUI.image:new({
		parent = _childUI["button_LastVIP"].handle._n,
		model = "UI:PageBtn",
		scaleT = 0.95,
		x = 0,
		y = 0,
		w = 34,
		h = 86,
	})
	--_childUI["button_LastVIP"].childUI["icon"].handle.s:setRotation(0)
	
	--��һ�ȼ���ҳ��ť��ֻ��Ӧ�¼�������ʾ��
	_childUI["button_NextVIP"] = hUI.button:new({
		parent = _MV_Frame,
		model = "misc/mask.png",
		scaleT = 0.95,
		x = _MV_FrmWH[1] - 52,
		y = -_MV_FrmWH[2]/2,
		w = 80,
		h = 120,
		code = function(self,x,y,isInside)
			_CurrentPage = _CurrentPage+1
			_CODE_CutVIPPage(_CurrentPage)
		end,
	})
	_childUI["button_NextVIP"].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
	_childUI["button_NextVIP"].childUI["icon"] = hUI.image:new({
		parent = _childUI["button_NextVIP"].handle._n,
		model = "UI:PageBtn",
		scaleT = 0.95,
		x = 0,
		y = 0,
		w = 34,
		h = 86,
	})
	_childUI["button_NextVIP"].childUI["icon"].handle.s:setRotation(180)
	_childUI["button_NextVIP"]:setstate(-1) --geyachao: ���ط�ҳ��ť
	
	--[[
	--VIP������Ϣ ����
	_childUI["image_VipInfoBGL"] = hUI.image:new({
		parent = _parent,
		model = "UI:vipdescribe_bgL",
		x = _MV_FrmWH[1]/2 - 166,
		y = -_MV_FrmWH[2] + 191 + 28,
		w = 344,
		h = 392,
	})
	_childUI["image_VipInfoBGR"] = hUI.image:new({
		parent = _parent,
		model = "UI:vipdescribe_bgR",
		x = _MV_FrmWH[1]/2 + 166,
		y = -_MV_FrmWH[2] + 191 + 28,
		w = 344,
		h = 392,
	})
	]]
	--VIP������Ϣ �������Ź���
	--local img91bg1 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/tipslot.png", _MV_FrmWH[1]/2, -_MV_FrmWH[2] + 191 + 68, 664, 312, _MV_Frame)
		
	local nBaseX, nBaseY = _MV_FrmWH[1] - 160, -_MV_FrmWH[2] + 191 + 28 + 191
	
	--"��ȡ"��ť
	_childUI["button_GetPrize"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/mask.png",
		scaleT = 0.95,
		x = nBaseX,
		y = nBaseY - 52,
		w = 150,
		h = 80,
		code = function(self,x,y,isInside)
			if (LuaGetDailyReward() == 0) then --δ��ȡ
				--������
				if (g_cur_net_state ~= 1) then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_VIPFrm_Net"],{ --"������������ʹ�û�Ա����"
						font = hVar.FONTC,
						ok = function()
							--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
						end,
					})
					return 
				end
				
				--�򿪽���
				_MV_Frame:show(1)
				_MV_Frame:active()
				
				--�����¼������VIP�ȼ�����ȡ״̬
				--hGlobal.event:listen("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
				
				--������
				hUI.NetDisable(30000)
				
				--��ȡVIPÿ�ս���
				SendCmdFunc["get_VIP_dailyReward"]()
				
				--��������
				--ð��
				--local strText = "ÿ�ս����ѷ��ŵ����䣡" --language
				local strText = hVar.tab_string["ios_tip_prize_reward_everyday_success"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			else --����ȡ
				--ð��
				--local strText = "����ȡ���ս�����" --language
				local strText = hVar.tab_string["HaveGetTodayReward"] --language
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
	_childUI["button_GetPrize"].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
	--��ťͼ��
	_childUI["button_GetPrize"].childUI["btnImage"] = hUI.image:new({
		parent = _childUI["button_GetPrize"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = 0,
		w = 120,
		h = 48,
	})
	--��ť����
	_childUI["button_GetPrize"].childUI["btnLabel"] = hUI.label:new({
		parent = _childUI["button_GetPrize"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = -2,
		text = hVar.tab_string["__Get__"], --"��ȡ"
		font = hVar.FONTC,
		size = 26,
		align = "MC",
		border = 1,
		RGB = {254, 192, 35,},
	})
	--vip��ť��̾��
	_childUI["button_GetPrize"].childUI["PageTanHao"] = hUI.image:new({
		parent = _childUI["button_GetPrize"].handle._n,
		x = 30,
		y = 20,
		model = "UI:TaskTanHao",
		w = 36,
		h = 36,
	})
	--_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --һ��ʼ����ʾ��ȡ��ť��̾��
	local act1 = CCMoveBy:create(0.2, ccp(0, 5))
	local act2 = CCMoveBy:create(0.2, ccp(0, -5))
	local act3 = CCMoveBy:create(0.2, ccp(0, 5))
	local act4 = CCMoveBy:create(0.2, ccp(0, -5))
	local act5 = CCDelayTime:create(2.0)
	local a = CCArray:create()
	a:addObject(act1)
	a:addObject(act2)
	a:addObject(act3)
	a:addObject(act4)
	a:addObject(act5)
	local sequence = CCSequence:create(a)
	_childUI["button_GetPrize"].childUI["PageTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
	
	--����vip1-6��6��
	for i = 1, _nMaxVIP, 1 do
		--VIPi��ť
		--ֻ��Ӧ�¼�������ʾ
		_childUI["button_VIP" .. i] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/mask.png",
			scaleT = 0.95,
			x = _childUI["rmbBg"].data.x - 302 + (i - 1) * 122,
			y = _childUI["rmbBg"].data.y - 430,
			w = 100,
			h = 100,
			scaleT = 0.95,
			code = function(self,x,y,isInside)
				if (_CurrentPage ~= i) then --���ظ����
					--print("_CODE_CutVIPPage", i)
					_CurrentPage = i
					_CODE_CutVIPPage(_CurrentPage)
				end
			end,
		})
		_childUI["button_VIP" .. i].handle.s:setOpacity(0) --ֻ��Ӧ�¼�������ʾ
		
		--VIPiͼ��
		_childUI["button_VIP" .. i].childUI["icon"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:vip" .. i,
			x = 0,
			y = 0,
			w = 70,
			h = 70,
		})
		hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "gray") --Ĭ�ϻҵ�
		
		--VIPiѡ�й���
		_childUI["button_VIP" .. i].childUI["check"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:finish",
			x = 20,
			y = -20,
			w = 43,
			h = 30,
		})
		_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(false) --Ĭ������
		
		--VIPi����
		if (i < _nMaxVIP) then
			_childUI["button_VIP" .. i].childUI["line"] = hUI.image:new({
				parent = _childUI["button_VIP" .. i].handle._n,
				model = "UI:vipline",
				x = 70,
				y = -1,
				w = 70,
				h = 4,
			})
			hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "gray") --Ĭ�ϻҵ�
		end
		
		--VIPiѡ�п�
		_childUI["button_VIP" .. i].childUI["selectbox"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:skillup2",
			x = 6,
			y = 4,
			w = 86,
			h = 82,
		})
		_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(false) --Ĭ������
	end
	
	----------------------------------------------------Grid
	--[��������]
	local pClipNode, _, _ = hApi.CreateClippingNode(_parent, _tCliprect, 0, _tCliprect[5])
	
	--Grid
	local _tGrid = {}
	for i =1, _nMaxLines do
		_tGrid[i] = {}
		for j = 1, _nColumn do
			_tGrid[i][j] = {0}
		end
	end
	_childUI["baggrid_ItemList"] = hUI.bagGrid:new({
		parent = pClipNode,								--���ڵ�Ϊ���ֽڵ�
		grid = _tGrid,									--grid�����Լ�������
		x = _nGridx,
		y = _nGridy,
		gridW = _nGridw,								--ÿ��grid�Ĵ�С
		gridH = _nGridh,
		align = "MC",									--Item���������grid���ĵĶ��䷽ʽ
		num = 0,
		animation = -1,									--��ֹGrid�Զ�����Item
		uiExtra = {"node"},								--��ˢ��Gridʱ�����Զ�ɾ����UI���ֵ�ǰ׺
		slot = 0, --{model = "UI:tacticbg",animation = "lightSlim",x = 0,y = 0,w=_nGridw-10,h=_nGridh-10},--�ڻ������ܹ��������ı����ۣ���ItemͼƬ�Ĵ�Сһ�£�
		codeOnImageCreate = function(self,id,sprite,gx,gy)
			_CODE_CreateItem(self,id,sprite,gx,gy)
		end,
	})
	-------------------------------------------------------------------------------------------����
	--������Ӧvip�ȼ��Ľ���װ��
	_CODE_CreateItem = function(self, nIndex, sprite, gx, gy)
		--print("_CODE_CreateItem", nIndex, tostring(sprite),gx,gy)
		local nX, nY = sprite:getPosition()
		--print(nX, nY)
		--node
		self.childUI["node"..gx.."|"..gy] = hUI.node:new({
			parent = self.handle._n,
			x = nX, 
			y = nY,
		})
		local tNode = self.childUI["node"..gx.."|"..gy]
		
		--����ͼ��
		local sModel = hVar.VipInfo.icon[nIndex]
		
		--���⴦��: �ߵȼ���ʾ�߼�ս����ͼ��
		if (_CurrentPage >= 4) and (nIndex == 3) then
			sModel = "icon/item/card_lv2.png"
		end
		--���⴦��: ����ͼ��Сһ���
		local iconWH = _nGridh - 6
		if (nIndex == 2) then
			iconWH = _nGridh - 10
		end
		
		if type(sModel) == "string" then
			hUI.deleteUIObject(hUI.image:new({
				parent = tNode.handle._n,
				model = sModel,
				x = -200,
				y = 0,
				w = iconWH,
				h = iconWH,
			}))
		elseif type(sModel) == "table" then
			hUI.deleteUIObject(hUI.image:new({
				parent = tNode.handle._n,
				model = sModel[1],
				x = -200,
				y = 0,
				w = _nGridh-6,
				h = _nGridh-6,
			}))
			hUI.deleteUIObject(hUI.image:new({
				parent = tNode.handle._n,
				model = sModel[2],
				x = -200 + sModel[3],
				y = 0 + sModel[4],
				w = sModel[5],
				h = sModel[6],
			}))
		end
		
		--����label
		local sStrIndex = hVar.VipInfo[_CurrentPage][nIndex]
		hUI.deleteUIObject(hUI.label:new({
			parent = tNode.handle._n,
			size = 22,
			font = hVar.FONTC,
			align = "LC",
			text = hVar.tab_string[sStrIndex],
			x = -160,
			y = 0,
			border = 1,
		}))
	end
	
	--�л�VIP��ʾ
	_CODE_CutVIPPage = function(nVipPage)
		--[[
		--������ҳ��ť
		_childUI["button_LastVIP"]:setstate(1)
		_childUI["button_NextVIP"]:setstate(1)
		
		if (nVipPage <= 1) then
			_childUI["button_LastVIP"]:setstate(0)
		elseif (nVipPage >= _nMaxVIP) then
			_childUI["button_NextVIP"]:setstate(0)
		end
		]]
		_childUI["button_LastVIP"]:setstate(-1) --geyachao: ���ط�ҳ��ť
		_childUI["button_NextVIP"]:setstate(-1) --geyachao: ���ط�ҳ��ť
		
		--ˢ���·�1-6��ѡ��״̬
		for i = 1, _nMaxVIP, 1 do
			--ѡ�п�
			if (nVipPage == i) then
				_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(true)
			else
				_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(false)
			end
			
			--vipͼ��״̬
			if (i <= LuaGetPlayerVipLv()) then
				hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "normal") --����
			else
				hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "gray") --�ҵ�
			end
			
			--vip����
			if (LuaGetPlayerVipLv() == i) then
				_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(true)
			else
				_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(false)
			end
			
			--vip����״̬
			if (i < LuaGetPlayerVipLv()) then
				if _childUI["button_VIP" .. i].childUI["line"] then
					hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "normal") --����
				end
			else
				if _childUI["button_VIP" .. i].childUI["line"] then
					hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "gray") --�ҵ�
				end
			end
		end
		
		--���õ�ǰ�ȼ�
		_childUI["image_VIP"]:setmodel("UI:vip" .. nVipPage)
		
		--�ۼƳ�ֵ
		local showMoneyOrCoin = 0 --��ȡ��ʾ��ʽ����Ϸ��/Ԫ��
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--IOS
		if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
			showMoneyOrCoin = xlGetIntFromKeyChain("xlShowMoneyOrCoin")
		--windows
		else
			showMoneyOrCoin = CCUserDefault:sharedUserDefault():getIntegerForKey("xlShowMoneyOrCoin")
		end
		if (showMoneyOrCoin == 0) then
			--Ԫ
			_childUI["vipRmbNeedLabel"]:setText((hVar.VipRmb[nVipPage] or "").." "..hVar.tab_string["Rmb"])	--�ۼƳ�ֵ��ֵ
			
			--���س�ֵ��ʾ��ť
			--_childUI["button_VipTip"]:setstate(-1)
		elseif showMoneyOrCoin == 1 then
			--���
			_childUI["vipRmbNeedLabel"]:setText((hVar.VipCoin[nVipPage] or "").." "..hVar.tab_string["__TEXT_Account_Balance"])
			
			--��ʾ��ֵ��ʾ��ť
			--_childUI["button_VipTip"]:setstate(1)
		end
		
		--������ȡ��ť
		if (nVipPage == LuaGetPlayerVipLv()) then --��ǰvip��
			_childUI["button_GetPrize"]:setstate(1)
			--_childUI["button_GetPrize"].childUI["label"].handle.s:setColor(ccc3(254, 192, 35))
			--print(LuaGetDailyReward())
			if (LuaGetDailyReward() == 1) then --����ȡ
				hApi.AddShader(_childUI["button_GetPrize"].childUI["btnImage"].handle.s, "gray") --�ҵ�
				_childUI["button_GetPrize"].childUI["btnLabel"]:setText(hVar.tab_string["__HaveToken"]) --"����ȡ"
				_childUI["button_GetPrize"].childUI["btnLabel"].handle.s:setColor(ccc3(192, 192, 192)) --�ҵ�
				_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --����ʾ��ȡ��ť��̾��
			else --δ��ȡ
				hApi.AddShader(_childUI["button_GetPrize"].childUI["btnImage"].handle.s, "normal") --����
				_childUI["button_GetPrize"].childUI["btnLabel"]:setText(hVar.tab_string["__Get__"]) --"��ȡ"
				_childUI["button_GetPrize"].childUI["btnLabel"].handle.s:setColor(ccc3(254, 192, 35)) --����
				_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(true) --��ʾ��ȡ��ť��̾��
			end
		else
			_childUI["button_GetPrize"]:setstate(-1)
			_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --����ʾ��ȡ��ť��̾��
		end
		
		--��ˢ��Grid��
		local tVIPIndex = {}
		for i = 1, #hVar.VipInfo[nVipPage] do
			tVIPIndex[i] = {i}
		end		
		_childUI["baggrid_ItemList"]:updateitem({})
		_childUI["baggrid_ItemList"]:updateitem(tVIPIndex)
		--������ק����
		local gh = math.max(0,math.ceil(#tVIPIndex/_nColumn)-_nLine)*_nGridh			--���������صĸ߶�; �� _nColumn��һ����ʾ�ĸ��� _nLine:һҳ�ܹ���ʾ��������
		_tDragRect = {_nGridx, _nGridy+gh+math.ceil(_nGridh/3), 0, gh+math.ceil(_nGridh/3)*2}	--_nGridh/3������ֵ
		--��ʼ��λ��
		hUI.uiSetXY(_childUI["baggrid_ItemList"], _nGridx, _nGridy)
	end
	
	-------------------------------------------------------��������
	--ʰȡ
	_CODE_HitPage = function(self,tTempPos,x,y)
		local oGrid = _childUI["baggrid_ItemList"]
		if hApi.IsInBox(x, y, _tCliprect) then				--���ж��Ƿ����趨�Ŀɵ������
			local tPickParam = {sGridName = "baggrid_ItemList", nPickI=0, tCard=0, state=0, nDelay=0, code=0}
			local gx,gy,oItemInfo = oGrid:xy2grid(x,y,"parent")	--��oItemInfo:  oItemInfo[1]:������Ʒʱ��ID��oItemInfo[2]:������oItemInfo[3]: ������ǵڼ������ӡ�
			if oItemInfo and oItemInfo~=0 then
				tPickParam.nPickI = oItemInfo[1]
			end
			return tPickParam
		end
	end
	
	--��ק
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--�����ƶ����������12�����أ�����Ϊ��������
				if tPickParam.code and tPickParam.code~=0 then			--�����������������������������
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1					--����״̬����������״̬
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		end
	end
	
	--̧��
	_CODE_DropPage = function(self,tTempPos,tPickParam)
		--�������
		if 0 == tPickParam.state then
			if tPickParam.nPickI and tPickParam.nPickI ~= 0 then
				
			end
		--��������
		elseif 1 == tPickParam.state then
			--������ʾ����λ�ö��䶥��
			self:aligngrid(_tAutoAlign,_tDragRect,tTempPos)
		end
	end
	
	
	-------------------------------------------------------------------------------------------����
	--�򿪽���
	--nRefreshCurrentPage:ˢ�½��棨����ҳ��
	hGlobal.event:listen("localEvent_ShowMyVIPFrm", "__ShowMyVIPFrm", function(nRefreshCurrentPage)
		--������
		if (g_cur_net_state ~= 1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_VIPFrm_Net"],{ --"������������ʹ�û�Ա����"
				font = hVar.FONTC,
				ok = function()
					--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end,
			})
			return 
		end
		
		--�򿪽���
		_MV_Frame:show(1)
		_MV_Frame:active()
		
		--�����¼������VIP�ȼ�����ȡ״̬
		--hGlobal.event:listen("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		
		if (nRefreshCurrentPage == 1) then -- ֻˢ�£�����ҳ
			--

		else
			--��ҳ����ǰVIP��ҳ
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
		end
		_CODE_CutVIPPage(_CurrentPage)
		
		--������
		--hUI.NetDisable(30000)
		
		--��ѯVIP�ȼ�����ȡ״̬
		SendCmdFunc["get_VIP_Lv_New"]()
	end)
	
	--�����¼������VIP�ȼ�����ȡ״̬
	hGlobal.event:listen("LocalEvent_GetVipState_New", "_GetVipState_New", function(vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		--print("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		
		--ȡ��������
		--hUI.NetDisable(0)
		
		--�洢�Ƿ���ȡ���ս���
		--_dailyRewardFlag = dailyRewardFlag
		
		--�����״̬��ˢ��UI
		if (_MV_Frame.data.show == 1) then
			--��ҳ����ǰVIP��ҳ
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
			_CODE_CutVIPPage(_CurrentPage)
			
			--�Ѿ���ֵ
			local showMoneyOrCoin = 0 --��ȡ��ʾ��ʽ����Ϸ��/Ԫ��
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
				showMoneyOrCoin = xlGetIntFromKeyChain("xlShowMoneyOrCoin")
			--windows
			else
				showMoneyOrCoin = CCUserDefault:sharedUserDefault():getIntegerForKey("xlShowMoneyOrCoin")
			end
			if showMoneyOrCoin == 0 then
				--Ԫ
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCount())..hVar.tab_string["Rmb"]) --�ѳ�ֵ
			elseif showMoneyOrCoin == 1 then
				--���
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCoinCount())..hVar.tab_string["__TEXT_Account_Balance"])
			end
			
			--���VIP��ȡ״̬
			--SendCmdFunc["get_VIP_REC_State"]()
			
			--print("_MV_Frame:show(1)")
		end
	end)
	
	--�����¼������VIP��ȡ״̬
	hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "_GetVipDailyRewardFlag", function(dailyRewardFlag)
		--print("LocalEvent_GetVipDailyRewardFlag", dailyRewardFlag)
		
		--ȡ��������
		hUI.NetDisable(0)
		
		--�洢�Ƿ���ȡ���ս���
		--_dailyRewardFlag = dailyRewardFlag
		
		--�����״̬��ˢ��UI
		if (_MV_Frame.data.show == 1) then
			--��ҳ����ǰVIP��ҳ
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
			_CODE_CutVIPPage(_CurrentPage)
		end
	end)
	
	--��ֵ��ɺ�ص�
	hGlobal.event:listen("LocalEvent_Purchase_Back", "_update_VIPFrame", function()
		--�����״̬��ˢ��UI
		if (_MV_Frame.data.show == 1) then
			--ˢ�½磨ֻˢ�����ڿ���ҳ�棩
			hGlobal.event:event("localEvent_ShowMyVIPFrm", 1)
		end
	end)
	
	--[[
	-------------------------------------------------------------------------------------------
	--��ֵ��ʾ���
	-------------------------------------------------------------------------------------------
	hGlobal.UI.PhoneCoinInfoFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 300,
		y = hVar.SCREEN.h/2 + 200,
		h = 400,
		w = 660,
		show = 0,
		dragable = 3,
		titlebar = 0,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:TileFrmBack",
		border = "UI:TileFrmBasic_thin",
		autoactive = 0,
	})
	
	local _cifrm = hGlobal.UI.PhoneCoinInfoFrm
	local _ciparent = _cifrm.handle._n
	local _cichildUI = _cifrm.childUI
	--�ر�
	_cichildUI["btnClose1"] = hUI.button:new({
		parent = _ciparent,
		model = "BTN:PANEL_CLOSE",
		dragbox = _cichildUI["dragBox"],
		scaleT = 0.9,
		x = 650,
		y = -12,
		code = function()
			_cifrm:show(0)
		end,
	})
	
	--��ʾ
	local topNum = {6,18,45,68,98,198}
	local exCoin = {0,10,75,160,310,810}
	for i = 1, 6, 1 do
		_childUI["VIpGiftIcon"..i..i] = hUI.image:new({
			parent = _ciparent,
			model = "misc/item_game_coins.png",
			x = 60,
			y = -50 - (i - 1) * 50,
			w = 48,
			h = 48,
		})
		if i == 1 then
			_childUI["vipCoinInfo"..i]= hUI.label:new({
				parent = _ciparent,
				dragbox = _cichildUI["dragBox"],
				font = hVar.FONTC,
				x = 100,
				y = -40 - (i - 1) * 50,
				width = 540,
				text = hVar.tab_string["topup"]..topNum[i].." : "..hVar.tab_string["topupCoin"]..tostring(topNum[i] * 5),
				size = 24,
			})
		else
			_childUI["vipCoinInfo"..i]= hUI.label:new({
				parent = _ciparent,
				dragbox = _cichildUI["dragBox"],
				font = hVar.FONTC,
				x = 100,
				y = -40 - (i - 1) * 50,
				width = 540,
				text = hVar.tab_string["topup"]..topNum[i].." : "..hVar.tab_string["topupCoin"]..tostring(topNum[i] * 5).." , "..hVar.tab_string["exCoin"]..tostring(exCoin[i]),
				size = 24,
			})
		end
	end
	
	--"�������͵���Ϸ�Ҳ������ۼƳ�ֵ"
	_childUI["vipCoinInfoTip"]= hUI.label:new({
		parent = _ciparent,
		dragbox = _cichildUI["dragBox"],
		font = hVar.FONTC,
		x = 130,
		y = -350,
		width = 500,
		text = hVar.tab_string["exCoinTip"],
		size = 24,
		RGB = {0,255,0},
	})
	]]
	
	--�л�����������vip����
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","close_MyVIPFrame",function(sSceneType, oWorld, oMap)
		--�����״̬��ˢ��UI
		if (_MV_Frame.data.show == 1) then
			_CurrentPage = 1
			_MV_Frame:show(0)
		end
	end)
	
	--[[
	--���� ��ֵ��ʾ����
	hGlobal.event:listen("LocalEvent_Phone_ShowCoinInfoFrm", "ShowCoinInfoFrm",function()
		_cifrm:show(1)
		_cifrm:active()
	end)
	]]
end
--[[
--���� -test
if hGlobal.UI.MyVIPFrame then --ɾ����һ�ε�
	hGlobal.UI.MyVIPFrame:del()
	hGlobal.UI.MyVIPFrame = nil
end
hGlobal.UI.InitMyVIPFrame("include") --����VIP����
hGlobal.event:event("localEvent_ShowMyVIPFrm", 0)
]]
