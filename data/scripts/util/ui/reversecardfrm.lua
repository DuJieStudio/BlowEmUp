--------------------------------------------
----反转卡片界面 
--
----价格         形式     说明                              规则  
--------------------------------------------------------------------------------------
----10游戏币   5张翻1张   有较低概率获得可升级高级卡片     对应等级 2 - 6 的卡
--
----80游戏币   5张翻3张   必然获得可升级的高级卡片         对应等级 5 - 7 的卡(都能升级)
--------------------------------------------
--G_UI_ReverseCardFrmState = 0				--全局变量用来记录当前翻卡面板是否打开
--hGlobal.UI.InitReverseCardFrm = function(mode)
--	local tInitEventName = {"localEvent_ShowReverseCardFrm","ShowReverseCardFrm"}
--	if mode~="include" then
--		return tInitEventName
--	end
--	local _w,_h = 760,430
--	local _x,_y = hVar.SCREEN.w/2 -_w/2 ,hVar.SCREEN.h/2 +_h/2
--	hGlobal.UI.ReverseCardFrm = hUI.frame:new({
--		x = _x,
--		y = _y,
--		w = _w,
--		h = _h,
--		z = 500,
--		dragable = 2,
--		show = 0,
--	})
--
--	local _frm = hGlobal.UI.ReverseCardFrm
--	local _parent = _frm.handle._n
--	local _childUI = _frm.childUI
--
--	--传入一张卡片列表绘制不同的卡片
--	local _slotX,_slotY = _w/2+60,250
--	local _slotOffX = 135
--	local _CardList = {}		--卡片列表
--	local _CardEndList = {}		--卡片最终列表
--	local _CurActionIndex = -1
--	
--	local _reverseCount = 0
--	local _reverseMaxCount = 0
--	local _dealAction = nil
--	local _dealCount
--	
--	local _btnList = {}		--卡片btn逻辑列表
--	
--	--清除一些本地数据表
--	local _clearTab = function(tab)
--		for i = 1,#tab do
--			hApi.safeRemoveT(_childUI,tab[i][1])
--		end
--		tab = {}
--	end
--	--面板的关闭方法
--	local _exitFun = function()
--		_frm:show(0)
--		G_UI_ReverseCardFrmState = 0
--		_clearTab(_CardList)
--		_clearTab(_CardEndList)
--		_clearTab(_btnList)
--
--		_CurActionIndex = -1
--		_dealCount = 0
--		_reverseMaxCount = 0
--		_reverseCount = 0
--		LuaCheckBuyCardList()
--	end
--	
--	--背景图片
--	_childUI["frm_gb"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:card_select_back",
--		align = "LT",
--		w = _w,
--		h = 180,
--		y = -155,
--	})
--	
--	--标题
--	_childUI["Title"] = hUI.label:new({
--		parent = _parent,
--		size = 34,
--		align = "MC",
--		font = hVar.FONTC,
--		x = _w/2 - 10,
--		y = -45,
--		width = 300,
--		text = hVar.tab_string["__TEXT_SelectedReverseCard"],
--		border = 1,
--	})
--
--	--选择卡片规则
--	_childUI["Title1"] = hUI.label:new({
--		parent = _parent,
--		size = 28,
--		align = "MC",
--		font = hVar.FONTC,
--		x = _w/2 - 10,
--		y = -80,
--		width = 460,
--		text = "",
--		border = 1,
--	})
--	
--	--分界线
--	_childUI["apartline_1"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:panel_part_09",
--		x = _w/2,
--		y = -100,
--		w = _w+20,
--		h = 8,
--	})
--	
--	--领取按钮
--	_childUI["closeBtn"] =  hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		label = hVar.tab_string["MadelGiftGet"],
--		x = _w/2-10,
--		y = -_h+40,
--		scaleT = 0.9,
--		code = function()
--			local skillList = {}
--			for i = 1,#_btnList do
--				if _btnList[i][2] == 1 then
--					skillList[#skillList+1] = {_btnList[i][3],_btnList[i][4]}
--				end
--			end
--			
--			--统计一共抽了几张卡
--			LuaAddPlayerCountVal(hVar.MEDAL_TYPE.rollTactic, ((#skillList) or 0))
--			LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.rollTactic, ((#skillList) or 0))
--			
--			--存档
--			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--			
--			hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm", skillList, nil, nil, 1)
--			hGlobal.event:event("localEvent_PreventClick")
--			
--			hApi.PlaySound("button")
--			_exitFun()
--		end,
--	})
--	
--	
--	local _setColor = function(node)
--		if _childUI[node] then
--			for k,v in pairs(_childUI[node].childUI) do
--				v.handle.s:setColor(ccc3(128,128,128))
--			end
--		end
--	end
--
--	local _ActionCallBackEx_2 = function()
--		_childUI["closeBtn"]:setstate(1)
--	end
--	
--	
--	local _ActionCallBackEx_1 = function()
--		for i = 1,#_btnList do
--			if _btnList[i][2] == 0 then
--				local node = _CardList[i]
--				_childUI[node[2]].handle._n:setVisible(false)
--				_childUI[node[1]].handle._n:setVisible(true)
--				_setColor(node[1])
--				_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,-1,0,90,90,0,0),CCCallFunc:create(_ActionCallBackEx_2)))
--			end
--		end
--	end
--
--	local _createNodeActionEx = function()
--		for i = 1,#_btnList do
--			if _btnList[i][2] == 0 then
--				local node = _CardList[i]
--				_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,1,0,0,90,0,0),CCCallFunc:create(_ActionCallBackEx_1)))
--			end
--		end
--	end
--	
--	--移动到空槽子位
--	local _ActionCallBack_3 = function()
--		local node = _CardList[_CurActionIndex]
--		_childUI[node[1]].handle._n:setVisible(false) --把用来移动的卡片 隐藏掉
--		local endNode = _CardEndList[_CurActionIndex]
--		_childUI[endNode[1]].handle._n:setVisible(true)	--显示出 之前绘制好的 不模糊的卡片
--		
--		
--		_reverseCount = _reverseCount + 1
--		if _reverseCount == _reverseMaxCount then
--			
--			_createNodeActionEx(i)
--		end
--		_CurActionIndex = 0
--	end
--	
--	--2次旋转的回调
--	local _ActionCallBack_2 = function()
--		if _reverseCount == _reverseMaxCount then return end
--		local node = _CardList[_CurActionIndex]
--		_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(_CardList[_CurActionIndex][3],_CardList[_CurActionIndex][4]+40)),CCCallFunc:create(_ActionCallBack_3)))
--	end
--	
--	--第二次旋转
--	local _ActionCallBack_1 = function()
--		local node = _CardList[_CurActionIndex]
--		_childUI[node[2]].handle._n:setVisible(false)
--		_childUI[node[1]].handle._n:setVisible(true)
--		_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,-1,0,90,90,0,0),CCCallFunc:create(_ActionCallBack_2)))
--	end
--	
--	--第一次旋转
--	local _createNodeAction = function(index)
--		_CurActionIndex = index
--		local node = _CardList[index]
--		_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,1,0,0,90,0,0),CCCallFunc:create(_ActionCallBack_1)))
--	end
--	
--	--发牌动画回调
--	local _dealActionCallBack = function()
--		hApi.addTimerOnce("ActionTimer",200,function()
--			
--			_dealCount = _dealCount +1
--			_dealAction()
--		end)
--	end
--	
--	--发牌动画
--	_dealAction = function()
--		local node = _CardList[_dealCount]
--		if node then
--			hApi.PlaySound("dealcard")
--			_childUI[node[2]].handle._n:setVisible(true)
--			_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.05,ccp(_CardList[_dealCount][3],_CardList[_dealCount][4])),CCCallFunc:create(_dealActionCallBack)))
--			
--		else
--			hApi.clearTimer("ActionTimer")
--			_CurActionIndex = 0
--			_frm:active()
--		end
--	end
--	
--	local _createCard = function(name,id,lv,maxlv,x,y)
--		--卡片node 
--		_childUI[name] = hUI.node:new({
--			parent = _parent,
--			x = x,
--			y = y,
--		})
--		
--		local qLv = math.min((hVar.tab_tactics[id].quality or 1), 4)
--		--卡片底图
--		_childUI[name].childUI["bg"] = hUI.image:new({
--			parent = _childUI[name].handle._n,
--			--model = hApi.GetTacticsCardGB(maxlv,lv),
--			model = "UI:tactic_card_"..qLv,
--		})
--		
--		--卡片icon
--		_childUI[name].childUI["icon"] = hUI.image:new({
--			parent = _childUI[name].handle._n,
--			model = hVar.tab_tactics[id].icon,
--			y = -10,
--			w = 50,
--			h = 50,
--		})
--		
--		--类型图标
--		_childUI[name].childUI["typeicon"]= hUI.image:new({
--			parent = _childUI[name].handle._n,
--			model = hApi.GetTacticsCardTypeIcon(id,"model"),
--			x = -3,
--			y = 57,
--			--scale = 0.4,
--		})
--		
--		--名字
--		_childUI[name].childUI["info"] = hUI.label:new({
--			parent =_childUI[name].handle._n,
--			y = 28,
--			size = 18,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 400,
--			text = hVar.tab_stringT[id][1],
--		})
--		
--		--根据 此技能的 最大技能上限 修改 显示技能星星的 坐标样式
--		if maxlv >= 5 then
--			-- 常规 排列，技能Lv 大于等于5
--			for j = 1,maxlv do
--				_childUI[name].childUI["Level_star_slot"..j] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (j-1)% 5 * 16,
--					y = -47 - math.ceil((j-5)/5)*16,
--				})
--				_childUI[name].childUI["Level_star_slot"..j].handle.s:setOpacity(120)
--			end
--			
--			for j = 1,lv do
--				_childUI[name].childUI["Level_star"..j] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = -32 + (j-1)% 5 * 16,
--					y = -47 - math.ceil((j-5)/5)*16,
--				})
--			end
--		else
--			local tempStartX = -1* (maxlv-1)*8
--			--居中显示
--			for j = 1,maxlv do
--				_childUI[name].childUI["Level_star_slot"..j] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(j-1)*16,
--					y = -47,
--				})
--				_childUI[name].childUI["Level_star_slot"..j].handle.s:setOpacity(120)
--			end
--			
--			for j = 1,lv do
--				_childUI[name].childUI["Level_star"..j] = hUI.image:new({
--					parent = _childUI[name].handle._n,
--					model = "UI:HERO_STAR",
--					x = tempStartX+(j-1)*16,
--					y = -47,
--				})
--			end
--		end
--	end
--	
--	--创建卡片列表
--	local _createCardList = function(name,px,py,poffx,list,slotNum)
--		_reverseMaxCount = slotNum
--		for i = 1,#_CardList do
--			hApi.safeRemoveT(_childUI,_CardList[i][1])
--			hApi.safeRemoveT(_childUI,_CardList[i][2])
--		end
--		_CardList = {}
--		
--		for i = 1,#_CardEndList do
--			hApi.safeRemoveT(_childUI,_CardEndList[i][1])
--		end
--		_CardEndList = {}
--		
--		for i = 1,#_btnList do
--			hApi.safeRemoveT(_childUI,_btnList[i][1])
--		end
--		_btnList = {}
--		
--		_CurActionIndex = -1
--		local num = #list
--		for i = 1,num do
--			--卡片背景 card_back
--			local x,y =  math.floor(px -num *poffx/2 + (i-1)*poffx),-math.floor(py)
--			local skillID,skillLV = unpack(list[i])
--			if hVar.tab_tactics[skillID] == nil then return end
--			
--			local MaxLv = hVar.tab_tactics[skillID].level
--			--用作旋转动画的卡片
--			_CardList[#_CardList+1] = {name..i,name.."_back_"..i,x,y}
--			_createCard(name..i,skillID,skillLV,MaxLv,x,y)
--			_childUI[name..i].handle._n:setVisible(false)
--			
--			--最后会显示出现的卡片
--			_CardEndList[#_CardEndList + 1] = {name.."end_"..i}
--			_createCard(name.."end_"..i,skillID,skillLV,MaxLv,x,y+40)
--			_childUI[name.."end_"..i].handle._n:setVisible(false)
--			
--			--背景
--			_childUI[name.."_back_"..i] = hUI.node:new({
--				parent = _parent,
--				x = _w-20,
--				y = y,
--			})
--			--卡片背景
--			_childUI[name.."_back_"..i].childUI["back"] = hUI.image:new({
--				parent = _childUI[name.."_back_"..i].handle._n,
--				model = "UI:card_back",
--				
--			})
--			_childUI[name.."_back_"..i].handle._n:setVisible(false)
--			
--			--具体的操作按钮
--			_childUI[name.."_btn_"..i] = hUI.button:new({
--				x = x,
--				y = y,
--				w = 120,
--				h = 150,
--				model = -1,
--				parent = _parent,
--				dragbox = _childUI["dragBox"],
--				code = function(self)
--					if _CurActionIndex == 0 and _reverseMaxCount > _reverseCount and _btnList[i][2] == 0 then
--						_childUI["break_down_eff_"..i] =hUI.image:new({
--							parent = _parent,
--							model = "MODEL_EFFECT:break_down",
--							x = x,
--							y = y,
--							w = 180,
--							h = 180,
--						})
--						hApi.PlaySound("eff_pickup")
--						hApi.addTimerOnce("break_down_eff",250,function()
--							hApi.safeRemoveT(_childUI,"break_down_eff_"..i)
--						end)
--						_btnList[i][2] = 1
--						_createNodeAction(i)
--					elseif _btnList[i][2] == 1 and _CurActionIndex == 0 then
--						if g_phone_mode ~= 0 then
--							hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,hVar.SCREEN.w /2 - 210 ,480,1,0)
--						else
--							hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,300,550,1,0)
--						end
--					end
--				end,
--			})
--			_btnList[#_btnList+1] =  {name.."_btn_"..i,0,skillID,skillLV}
--			
--		end
--		_dealCount = 1
--		_dealAction()
--		--创建槽子数
--		--_createCardSlot(px,py,poffx,slotNum)
--	end
--	CCDirector:sharedDirector():setDepthTest(false)
--	
--	--打开面板的监听
--	local _cardImgX,_cardImgY = 240, -45
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(cardList,dealCount,itemID)
--		G_UI_ReverseCardFrmState = 1
--		_childUI["closeBtn"]:setstate(0)
--		
--		hApi.safeRemoveT(_childUI,"ItemImg")
--		hApi.safeRemoveT(_childUI,"ItemImgBorder")
--		
--		local itemLv = hVar.tab_item[itemID].itemLv or 1
--		local itemModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL
--		_childUI["ItemImgBorder"]= hUI.image:new({
--			parent = _parent,
--			model = itemModel,
--			x = _cardImgX,
--			y = _cardImgY,
--			w = 64,
--			h = 64,
--		})
--		
--		_childUI["ItemImg"]= hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_item[itemID].icon,
--			x = _cardImgX,
--			y = _cardImgY,
--			w = 64,
--			h = 64,
--		})
--		
--		_childUI["Title"]:setText(hVar.tab_stringI[itemID][1])
--		_childUI["Title1"]:setText(hVar.tab_stringI[itemID][4])
--		_createCardList("card_Node_",_slotX,_slotY,_slotOffX,cardList,dealCount)
--		
--		_frm:show(1)
--		_frm:active()
--	end)
--	
--end