


-----------------------------------------------------------
--function:	VIP界面（新界面）
--Writer:	pangyong 2016/10/11
-----------------------------------------------------------
hGlobal.UI.InitMyVIPFrame = function(mode)
	local tInitEventName = {"localEvent_ShowMyVIPFrm", "__ShowMyVIPFrm"}
	if mode~="include" then
		return tInitEventName
	end
	
	--Frame参数
	local _MV_FrmWH = {880, 544}
	local _MV_FrmXY = {hVar.SCREEN.w/2-_MV_FrmWH[1]/2, hVar.SCREEN.h/2+_MV_FrmWH[2]/2 - 20}
	local _MV_Frame
	local _parent
	local _childUI
	local _CurrentPage = 1								--当前VIP页标
	local _nMaxVIP = #hVar.VipRmb						--最高VIP等级（策马这边用的是死数值）
	
	--Grid参数
	local _nMaxLines = 10									--Grid最大行数
	local _nLine, _nColumn = 10, 1							--一页显示的 行数 列数
	local _tCliprect = {108, -196 + 80, 650, 238 + 90, 0}	--遮罩区域
	local _tGrid = {}								--Grid布局
	local _nGridx = _tCliprect[1] + math.ceil(_tCliprect[3]/(_nColumn*2)) - 60
	local _nGridy = _tCliprect[2] - math.ceil((_tCliprect[4]-10)/(_nLine*2)) - 5
	local _nGridw, _nGridh = math.ceil(_tCliprect[3]/_nColumn), math.ceil((358 + 62 - 10)/_nLine)
	local _tAutoAlign = {"V", "baggrid_ItemList", math.ceil(_nGridh/3), 0, -math.ceil(_nGridh/3)}	--纵向对其，grid名字，……， ……，回弹距离
	local _tDragRect = {0,0,0,0}							--拖拽范围

	--函数
	local _CODE_CreateItem = hApi.DoNothing						--创建Boss列表
	local _CODE_CutVIPPage = hApi.DoNothing						--切换VIP显示
	local _CODE_HitPage = hApi.DoNothing						--拾取
	local _CODE_DragPage = hApi.DoNothing						--拖拽
	local _CODE_DropPage = hApi.DoNothing						--抬起
	
	--参数
	--local _dailyRewardFlag = 0 --是否领取今日奖励
	
	--主框
	hGlobal.UI.MyVIPFrame = hUI.frame:new({
		x = _MV_FrmXY[1],
		y = _MV_FrmXY[2],
		w = _MV_FrmWH[1],
		h = _MV_FrmWH[2],
		dragable = 2,			--点击窗外关闭窗口
		border = 1,
		background = "UI:tip_item",
		show = 0,
		codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
			local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
			if tPickParam~=nil then
				--点击Grid
				return self:pick(tPickParam.sGridName,_tDragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tPickParam})
			end
		end,
	})
	_MV_Frame = hGlobal.UI.MyVIPFrame
	_parent = _MV_Frame.handle._n
	_childUI = _MV_Frame.childUI
	--print("InitMyVIPFrame 主框")
	-------------------------------------------------------------------------------------------UI
	----遮布
	--_childUI["image_BackPanel"] = hUI.image:new({
		--parent = _parent,
		--model = "UI:frame_back",
		--x = hVar.SCREEN.w/2 - _MV_FrmXY[1],
		--y = hVar.SCREEN.h/2 - _MV_FrmXY[2],
		--w = hVar.SCREEN.w,
		--h = hVar.SCREEN.h,
		--z = -20,
	--})
	
	--关闭按钮
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
	
	--背景图
	_childUI["rmbBg"] = hUI.image:new({
		parent = _parent,
		model = "UI:selectbg3",
		x = _MV_FrmWH[1]/2,
		y = -62,
		w = _MV_FrmWH[1]-100,
		h = 72,
	})
	
	--VIP图标
	_childUI["image_VIP"]= hUI.image:new({
		parent = _parent,
		model = "UI:vip1",
		x = _childUI["rmbBg"].data.x - 302,
		y = _childUI["rmbBg"].data.y,
		w = 70,
		h = 70,
	})
	
	--“需充值”
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
	
	--需充值数值
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
	
	--已充值
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
	
	--单位转换按钮（游戏币 和 钱）
	_childUI["button_ShowCoinOrMoney"]= hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		dragbox = _childUI["dragBox"],
		x = _childUI["rmbBg"].data.x-76,
		y = _childUI["rmbBg"].data.y,
		w = 600,
		h = 80,
		code = function(self)
			--判断设备
			local showMoneyOrCoin = 0 --显示方式（游戏币/元）
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
				--已充值（人民币）
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCount())..hVar.tab_string["Rmb"])
				
				--充值累计金额：
				_childUI["vipRmbNeedLabel"]:setText((hVar.Vip_Conifg.condition.rmb[_CurrentPage] or "").." "..hVar.tab_string["Rmb"])
				
				--隐藏充值提示按钮
				--_childUI["button_VipTip"]:setstate(-1)
			elseif (showMoneyOrCoin == 0) then
				showMoneyOrCoin = 1
				--已充值（游戏币）
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCoinCount())..hVar.tab_string["__TEXT_Account_Balance"])
				
				--充值累计金额：
				_childUI["vipRmbNeedLabel"]:setText((hVar.Vip_Conifg.condition.coin[_CurrentPage] or "").." "..hVar.tab_string["__TEXT_Account_Balance"])
				
				--显示充值提示按钮
				--_childUI["button_VipTip"]:setstate(1)
			end
			
			--保存标志
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
	_childUI["button_ShowCoinOrMoney"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--"去充值"按钮
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
			--购买游戏币
			hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
		end,
	})
	_childUI["button_GoToBuy"].handle.s:setOpacity(0) --只响应事件，不显示
	--按钮图标
	_childUI["button_GoToBuy"].childUI["btnImage"] = hUI.image:new({
		parent = _childUI["button_GoToBuy"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = 0,
		w = 120,
		h = 48,
	})
	--按钮文字
	_childUI["button_GoToBuy"].childUI["btnLabel"] = hUI.label:new({
		parent = _childUI["button_GoToBuy"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = -2,
		text = hVar.tab_string["__TEXT_GoToRecharge"], --"去充值"
		font = hVar.FONTC,
		size = 26,
		align = "MC",
		border = 1,
		RGB = {254, 192, 35,},
	})
	
	--[[
	--充值提示按钮
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
	
	--上一等级翻页按钮（只响应事件，不显示）
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
	_childUI["button_LastVIP"].handle.s:setOpacity(0) --只响应事件，不显示
	_childUI["button_LastVIP"]:setstate(-1) --geyachao: 隐藏翻页按钮
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
	
	--下一等级翻页按钮（只响应事件，不显示）
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
	_childUI["button_NextVIP"].handle.s:setOpacity(0) --只响应事件，不显示
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
	_childUI["button_NextVIP"]:setstate(-1) --geyachao: 隐藏翻页按钮
	
	--[[
	--VIP描述信息 背景
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
	--VIP描述信息 背景（九宫格）
	--local img91bg1 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/tipslot.png", _MV_FrmWH[1]/2, -_MV_FrmWH[2] + 191 + 68, 664, 312, _MV_Frame)
		
	local nBaseX, nBaseY = _MV_FrmWH[1] - 160, -_MV_FrmWH[2] + 191 + 28 + 191
	
	--"领取"按钮
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
			if (LuaGetDailyReward() == 0) then --未领取
				--网络检查
				if (g_cur_net_state ~= 1) then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_VIPFrm_Net"],{ --"必须联网才能使用会员功能"
						font = hVar.FONTC,
						ok = function()
							--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
						end,
					})
					return 
				end
				
				--打开界面
				_MV_Frame:show(1)
				_MV_Frame:active()
				
				--触发事件：获得VIP等级和领取状态
				--hGlobal.event:listen("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
				
				--挡操作
				hUI.NetDisable(30000)
				
				--领取VIP每日奖励
				SendCmdFunc["get_VIP_dailyReward"]()
				
				--浮动文字
				--冒字
				--local strText = "每日奖励已发放到邮箱！" --language
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
			else --已领取
				--冒字
				--local strText = "已领取今日奖励！" --language
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
	_childUI["button_GetPrize"].handle.s:setOpacity(0) --只响应事件，不显示
	--按钮图标
	_childUI["button_GetPrize"].childUI["btnImage"] = hUI.image:new({
		parent = _childUI["button_GetPrize"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = 0,
		w = 120,
		h = 48,
	})
	--按钮文字
	_childUI["button_GetPrize"].childUI["btnLabel"] = hUI.label:new({
		parent = _childUI["button_GetPrize"].handle._n,
		model = "UI:BTN_ButtonRed",
		x = 0,
		y = -2,
		text = hVar.tab_string["__Get__"], --"领取"
		font = hVar.FONTC,
		size = 26,
		align = "MC",
		border = 1,
		RGB = {254, 192, 35,},
	})
	--vip按钮的叹号
	_childUI["button_GetPrize"].childUI["PageTanHao"] = hUI.image:new({
		parent = _childUI["button_GetPrize"].handle._n,
		x = 30,
		y = 20,
		model = "UI:TaskTanHao",
		w = 36,
		h = 36,
	})
	--_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --一开始不显示领取按钮的叹号
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
	
	--绘制vip1-6的6档
	for i = 1, _nMaxVIP, 1 do
		--VIPi按钮
		--只响应事件，不显示
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
				if (_CurrentPage ~= i) then --不重复点击
					--print("_CODE_CutVIPPage", i)
					_CurrentPage = i
					_CODE_CutVIPPage(_CurrentPage)
				end
			end,
		})
		_childUI["button_VIP" .. i].handle.s:setOpacity(0) --只响应事件，不显示
		
		--VIPi图标
		_childUI["button_VIP" .. i].childUI["icon"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:vip" .. i,
			x = 0,
			y = 0,
			w = 70,
			h = 70,
		})
		hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "gray") --默认灰掉
		
		--VIPi选中勾勾
		_childUI["button_VIP" .. i].childUI["check"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:finish",
			x = 20,
			y = -20,
			w = 43,
			h = 30,
		})
		_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(false) --默认隐藏
		
		--VIPi线条
		if (i < _nMaxVIP) then
			_childUI["button_VIP" .. i].childUI["line"] = hUI.image:new({
				parent = _childUI["button_VIP" .. i].handle._n,
				model = "UI:vipline",
				x = 70,
				y = -1,
				w = 70,
				h = 4,
			})
			hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "gray") --默认灰掉
		end
		
		--VIPi选中框
		_childUI["button_VIP" .. i].childUI["selectbox"] = hUI.image:new({
			parent = _childUI["button_VIP" .. i].handle._n,
			model = "UI:skillup2",
			x = 6,
			y = 4,
			w = 86,
			h = 82,
		})
		_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
	end
	
	----------------------------------------------------Grid
	--[创建遮罩]
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
		parent = pClipNode,								--父节点为遮罩节点
		grid = _tGrid,									--grid布局以及行列数
		x = _nGridx,
		y = _nGridy,
		gridW = _nGridw,								--每个grid的大小
		gridH = _nGridh,
		align = "MC",									--Item精灵相对于grid中心的对其方式
		num = 0,
		animation = -1,									--防止Grid自动创建Item
		uiExtra = {"node"},								--再刷新Grid时可以自动删除的UI名字的前缀
		slot = 0, --{model = "UI:tacticbg",animation = "lightSlim",x = 0,y = 0,w=_nGridw-10,h=_nGridh-10},--在画面中能够被看见的背景槽（和Item图片的大小一致）
		codeOnImageCreate = function(self,id,sprite,gx,gy)
			_CODE_CreateItem(self,id,sprite,gx,gy)
		end,
	})
	-------------------------------------------------------------------------------------------函数
	--创建对应vip等级的奖励装备
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
		
		--创建图标
		local sModel = hVar.VipInfo.icon[nIndex]
		
		--特殊处理: 高等级显示高级战术卡图标
		if (_CurrentPage >= 4) and (nIndex == 3) then
			sModel = "icon/item/card_lv2.png"
		end
		--特殊处理: 积分图标小一点点
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
		
		--创建label
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
	
	--切换VIP显示
	_CODE_CutVIPPage = function(nVipPage)
		--[[
		--设置切页按钮
		_childUI["button_LastVIP"]:setstate(1)
		_childUI["button_NextVIP"]:setstate(1)
		
		if (nVipPage <= 1) then
			_childUI["button_LastVIP"]:setstate(0)
		elseif (nVipPage >= _nMaxVIP) then
			_childUI["button_NextVIP"]:setstate(0)
		end
		]]
		_childUI["button_LastVIP"]:setstate(-1) --geyachao: 隐藏翻页按钮
		_childUI["button_NextVIP"]:setstate(-1) --geyachao: 隐藏翻页按钮
		
		--刷新下方1-6档选中状态
		for i = 1, _nMaxVIP, 1 do
			--选中框
			if (nVipPage == i) then
				_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(true)
			else
				_childUI["button_VIP" .. i].childUI["selectbox"].handle.s:setVisible(false)
			end
			
			--vip图标状态
			if (i <= LuaGetPlayerVipLv()) then
				hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "normal") --高亮
			else
				hApi.AddShader(_childUI["button_VIP" .. i].childUI["icon"].handle.s, "gray") --灰掉
			end
			
			--vip勾勾
			if (LuaGetPlayerVipLv() == i) then
				_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(true)
			else
				_childUI["button_VIP" .. i].childUI["check"].handle.s:setVisible(false)
			end
			
			--vip线条状态
			if (i < LuaGetPlayerVipLv()) then
				if _childUI["button_VIP" .. i].childUI["line"] then
					hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "normal") --高亮
				end
			else
				if _childUI["button_VIP" .. i].childUI["line"] then
					hApi.AddShader(_childUI["button_VIP" .. i].childUI["line"].handle.s, "gray") --灰掉
				end
			end
		end
		
		--设置当前等级
		_childUI["image_VIP"]:setmodel("UI:vip" .. nVipPage)
		
		--累计充值
		local showMoneyOrCoin = 0 --获取显示方式（游戏币/元）
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		--IOS
		if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
			showMoneyOrCoin = xlGetIntFromKeyChain("xlShowMoneyOrCoin")
		--windows
		else
			showMoneyOrCoin = CCUserDefault:sharedUserDefault():getIntegerForKey("xlShowMoneyOrCoin")
		end
		if (showMoneyOrCoin == 0) then
			--元
			_childUI["vipRmbNeedLabel"]:setText((hVar.VipRmb[nVipPage] or "").." "..hVar.tab_string["Rmb"])	--累计充值数值
			
			--隐藏充值提示按钮
			--_childUI["button_VipTip"]:setstate(-1)
		elseif showMoneyOrCoin == 1 then
			--金币
			_childUI["vipRmbNeedLabel"]:setText((hVar.VipCoin[nVipPage] or "").." "..hVar.tab_string["__TEXT_Account_Balance"])
			
			--显示充值提示按钮
			--_childUI["button_VipTip"]:setstate(1)
		end
		
		--设置领取按钮
		if (nVipPage == LuaGetPlayerVipLv()) then --当前vip档
			_childUI["button_GetPrize"]:setstate(1)
			--_childUI["button_GetPrize"].childUI["label"].handle.s:setColor(ccc3(254, 192, 35))
			--print(LuaGetDailyReward())
			if (LuaGetDailyReward() == 1) then --已领取
				hApi.AddShader(_childUI["button_GetPrize"].childUI["btnImage"].handle.s, "gray") --灰掉
				_childUI["button_GetPrize"].childUI["btnLabel"]:setText(hVar.tab_string["__HaveToken"]) --"已领取"
				_childUI["button_GetPrize"].childUI["btnLabel"].handle.s:setColor(ccc3(192, 192, 192)) --灰掉
				_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --不显示领取按钮的叹号
			else --未领取
				hApi.AddShader(_childUI["button_GetPrize"].childUI["btnImage"].handle.s, "normal") --高亮
				_childUI["button_GetPrize"].childUI["btnLabel"]:setText(hVar.tab_string["__Get__"]) --"领取"
				_childUI["button_GetPrize"].childUI["btnLabel"].handle.s:setColor(ccc3(254, 192, 35)) --高亮
				_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(true) --显示领取按钮的叹号
			end
		else
			_childUI["button_GetPrize"]:setstate(-1)
			_childUI["button_GetPrize"].childUI["PageTanHao"].handle._n:setVisible(false) --不显示领取按钮的叹号
		end
		
		--【刷新Grid】
		local tVIPIndex = {}
		for i = 1, #hVar.VipInfo[nVipPage] do
			tVIPIndex[i] = {i}
		end		
		_childUI["baggrid_ItemList"]:updateitem({})
		_childUI["baggrid_ItemList"]:updateitem(tVIPIndex)
		--设置拖拽区域
		local gh = math.max(0,math.ceil(#tVIPIndex/_nColumn)-_nLine)*_nGridh			--界面下隐藏的高度; （ _nColumn：一行显示的个数 _nLine:一页能够显示的行数）
		_tDragRect = {_nGridx, _nGridy+gh+math.ceil(_nGridh/3), 0, gh+math.ceil(_nGridh/3)*2}	--_nGridh/3：缓冲值
		--初始化位置
		hUI.uiSetXY(_childUI["baggrid_ItemList"], _nGridx, _nGridy)
	end
	
	-------------------------------------------------------触摸函数
	--拾取
	_CODE_HitPage = function(self,tTempPos,x,y)
		local oGrid = _childUI["baggrid_ItemList"]
		if hApi.IsInBox(x, y, _tCliprect) then				--【判断是否在设定的可点击区域】
			local tPickParam = {sGridName = "baggrid_ItemList", nPickI=0, tCard=0, state=0, nDelay=0, code=0}
			local gx,gy,oItemInfo = oGrid:xy2grid(x,y,"parent")	--【oItemInfo:  oItemInfo[1]:创建物品时的ID，oItemInfo[2]:数量，oItemInfo[3]: 点击的是第几个格子】
			if oItemInfo and oItemInfo~=0 then
				tPickParam.nPickI = oItemInfo[1]
			end
			return tPickParam
		end
	end
	
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
				if tPickParam.code and tPickParam.code~=0 then			--如果存在拖拉函数，则处理拖拉函数
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1					--设置状态：进入拖拉状态
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
	
	--抬起
	_CODE_DropPage = function(self,tTempPos,tPickParam)
		--【点击】
		if 0 == tPickParam.state then
			if tPickParam.nPickI and tPickParam.nPickI ~= 0 then
				
			end
		--【拖拉】
		elseif 1 == tPickParam.state then
			--调整显示内容位置对其顶部
			self:aligngrid(_tAutoAlign,_tDragRect,tTempPos)
		end
	end
	
	
	-------------------------------------------------------------------------------------------监听
	--打开界面
	--nRefreshCurrentPage:刷新界面（不切页）
	hGlobal.event:listen("localEvent_ShowMyVIPFrm", "__ShowMyVIPFrm", function(nRefreshCurrentPage)
		--网络检查
		if (g_cur_net_state ~= 1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_VIPFrm_Net"],{ --"必须联网才能使用会员功能"
				font = hVar.FONTC,
				ok = function()
					--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end,
			})
			return 
		end
		
		--打开界面
		_MV_Frame:show(1)
		_MV_Frame:active()
		
		--触发事件：获得VIP等级和领取状态
		--hGlobal.event:listen("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		
		if (nRefreshCurrentPage == 1) then -- 只刷新，不切页
			--

		else
			--切页到当前VIP的页
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
		end
		_CODE_CutVIPPage(_CurrentPage)
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--查询VIP等级和领取状态
		SendCmdFunc["get_VIP_Lv_New"]()
	end)
	
	--监听事件：获得VIP等级和领取状态
	hGlobal.event:listen("LocalEvent_GetVipState_New", "_GetVipState_New", function(vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		--print("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag)
		
		--取消挡操作
		--hUI.NetDisable(0)
		
		--存储是否领取今日奖励
		--_dailyRewardFlag = dailyRewardFlag
		
		--界面打开状态下刷新UI
		if (_MV_Frame.data.show == 1) then
			--切页到当前VIP的页
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
			_CODE_CutVIPPage(_CurrentPage)
			
			--已经充值
			local showMoneyOrCoin = 0 --获取显示方式（游戏币/元）
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			--IOS
			if (g_tTargetPlatform.kTargetWindows ~= TargetPlatform) then
				showMoneyOrCoin = xlGetIntFromKeyChain("xlShowMoneyOrCoin")
			--windows
			else
				showMoneyOrCoin = CCUserDefault:sharedUserDefault():getIntegerForKey("xlShowMoneyOrCoin")
			end
			if showMoneyOrCoin == 0 then
				--元
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCount())..hVar.tab_string["Rmb"]) --已充值
			elseif showMoneyOrCoin == 1 then
				--金币
				_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"].."  "..tostring(LuaGetTopupCoinCount())..hVar.tab_string["__TEXT_Account_Balance"])
			end
			
			--获得VIP领取状态
			--SendCmdFunc["get_VIP_REC_State"]()
			
			--print("_MV_Frame:show(1)")
		end
	end)
	
	--监听事件：获得VIP领取状态
	hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "_GetVipDailyRewardFlag", function(dailyRewardFlag)
		--print("LocalEvent_GetVipDailyRewardFlag", dailyRewardFlag)
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--存储是否领取今日奖励
		--_dailyRewardFlag = dailyRewardFlag
		
		--界面打开状态下刷新UI
		if (_MV_Frame.data.show == 1) then
			--切页到当前VIP的页
			_CurrentPage = (LuaGetPlayerVipLv() == 0) and 1 or LuaGetPlayerVipLv()
			_CODE_CutVIPPage(_CurrentPage)
		end
	end)
	
	--充值完成后回调
	hGlobal.event:listen("LocalEvent_Purchase_Back", "_update_VIPFrame", function()
		--界面打开状态下刷新UI
		if (_MV_Frame.data.show == 1) then
			--刷新界（只刷新正在看的页面）
			hGlobal.event:event("localEvent_ShowMyVIPFrm", 1)
		end
	end)
	
	--[[
	-------------------------------------------------------------------------------------------
	--充值提示面板
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
	--关闭
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
	
	--提示
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
	
	--"额外赠送的游戏币不计入累计充值"
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
	
	--切换场景，隐藏vip界面
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","close_MyVIPFrame",function(sSceneType, oWorld, oMap)
		--界面打开状态下刷新UI
		if (_MV_Frame.data.show == 1) then
			_CurrentPage = 1
			_MV_Frame:show(0)
		end
	end)
	
	--[[
	--开关 充值提示界面
	hGlobal.event:listen("LocalEvent_Phone_ShowCoinInfoFrm", "ShowCoinInfoFrm",function()
		_cifrm:show(1)
		_cifrm:active()
	end)
	]]
end
--[[
--测试 -test
if hGlobal.UI.MyVIPFrame then --删除上一次的
	hGlobal.UI.MyVIPFrame:del()
	hGlobal.UI.MyVIPFrame = nil
end
hGlobal.UI.InitMyVIPFrame("include") --创建VIP界面
hGlobal.event:event("localEvent_ShowMyVIPFrm", 0)
]]
