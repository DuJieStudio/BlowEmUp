--------------------------------
-- 购买英雄卡片界面
--------------------------------
hGlobal.UI.InitBuyHeroCardFrm = function()
	
	--购买界面
	local _x,_y,_w,_h = hVar.SCREEN.w/2 -230,hVar.SCREEN.h/2 +170,460,340
	hGlobal.UI.BuyHeroCardFrm =hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 4,
		h = _h,
		w = _w,
		show = 0,
		--added by pangyong 2015/4/13									（实现 购买英雄卡片界面窗口跳动）
		--codeOnTouch = function(self,x,y,sus)
			--if sus == 0 then									--sus == 0:点击窗口以外的位置，sus == 1:点击窗口以内的位置
				--self.handle._n:runAction(CCJumpBy:create(0.15,ccp(0,0),10,1))			--实现窗口跳动
			--end
		--end
	})
	local _frm = hGlobal.UI.BuyHeroCardFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	local _x,_y = 100,-130
	
	--标题
	_childUI["BuyHeroCardTitle"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = _frm.data.w/2-10,
		y = -30,
		width = 540,
		text = hVar.tab_string["__TEXT_buy_herocard"],
		border = 1,
	})
	
	--卡片介绍
	_childUI["HeroCardInfo"]  = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 180,
		y = -60,
		width = 270,
		text = "",
		border = 1,
	})
	
	--技能
	_childUI["SkillInfo"]  = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 180,
		y = -150,
		width = 270,
		text = hVar.tab_string["__Attr_Skill"].." :",
		RGB = {0,255,0},
		border = 1,
	})
	
	--价格
	_childUI["BuyHeroCardPrice"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -250,
		width = 540,
		text = hVar.tab_string["__TEXT_buy_herocard_price"],
		border = 1,
	})
	
	--积分图标
	_childUI["Score_image"] = hUI.image:new({
		parent = _parent,
		model = "UI:score",
		x = 210,
		y = -260,
		w = 26,
	})

	--积分数据
	_childUI["Score_labe"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 250,
		y = -250 + 1,
		width = 500,
		text = "",
		border = 1,
	})
	
	--游戏币图标
	_childUI["itemRMB_image"] = hUI.image:new({
		parent = _parent,
		model = "UI:game_coins",
		x = 330,
		y = -260,
		w = 40,
	})
	
	--游戏币数据
	_childUI["itemRMB_labe"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 370,
		y = -250 + 1,
		width = 500,
		text = "",
		border = 1,
	})
	
	--断网或者游戏币不足时的提示
	_childUI["net_and_rmb_labe"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "MC",
		font = hVar.FONTC,
		x = _w/2,
		y = -360,
		width = 500,
		text = "",
		border = 1,
	})
	
	local _shopID = 0
	local _oHero = {}
	local _off = 0
	local _HeroID = 0
	local _removeList = {}
	local _skillListCount = {}
	local _exitFun = function()
		hApi.SetObject(_oHero,nil)
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		for i = 1,#_skillListCount do
			hApi.safeRemoveT(_childUI,_skillListCount[i])
		end
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		_removeList = {}
		
		_shopID = 0
		_off = 0
		_HeroID = 0
		Score,itemRMB = 0,0
	end
	
	--确定面板
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Confirm"],
		x = _frm.data.w/2+100,
		y = -310,
		scaleT = 0.9,
		code = function()
			
			local lockMap = hVar.NET_SHOP_ITEM_LIMIT[_shopID]
			local lockFlag = false
			if lockMap and type(lockMap) == "string" and LuaGetPlayerMapAchi(lockMap,hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then
				--锁定英雄令的购买
				lockFlag = true
			end
			
			if lockFlag then									--未通关响应关卡，锁定英雄令
				local strMsg = hVar.tab_string["__TEXT_inform_herocard1"]..hVar.tab_stringM[lockMap][1]..hVar.tab_string["__TEXT_inform_herocard2"]
				hGlobal.UI.MsgBox(strMsg,{				--弹出message（）
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
			
			local h = hApi.GetObject(_oHero,oHero)
			local Score,itemRMB,itemName = 0,0,""
			if hVar.tab_shopitem[_shopID] then
				Score,itemRMB = math.ceil(hVar.tab_shopitem[_shopID].score*_off),math.ceil(hVar.tab_shopitem[_shopID].rmb*_off)
				itemName = hVar.tab_stringI[hVar.tab_shopitem[_shopID].itemID][1]
			end
			
			if hApi.IsHaveHeroCard(_HeroID) == false then
				if g_vs_number <= 4 then
					if xlUseGameCoinNum(itemRMB) > 0 then
						if xlUseGameCoinCommitToServer then
							xlUseGameCoinCommitToServer(itemRMB, hVar.tab_stringI[hVar.tab_shopitem[_shopID].itemID][1])
						end
						LuaAddPlayerScore(-Score)
						LuaSaveHeroCard()
						hApi.PlaySound("pay_gold")
						if xlAppAnalysis then
							xlAppAnalysis("buyhero_in_game",0,2,"clientID",tostring(xlPlayer_GetUID()),"heroID",_HeroID)
						end
						
						--if g_phone_mode ~= 0 then
							--hGlobal.event:event("LocalEvent_Phone_reflashrmblab")
						--else
							hGlobal.event:event("LocalEvent_reflashrmblab")
						--end
					end
				else -- 新的购买卡片流程
					--SendCmdFunc["buy_shopitem"](hVar.tab_shopitem[_shopID].itemID,itemRMB,itemName,Score)
					SendCmdFunc["order_begin"](6,hVar.tab_shopitem[_shopID].itemID,itemRMB,1,itemName,Score,0,nil)
				end
			else
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_can't_buy_herocard_tip"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			end
			
			if g_vs_number <= 4 then
				if h ~= nil then
					h:setowner(hGlobal.LocalPlayer.data.playerId)
					hGlobal.event:call("LocalEvent_GetHeroCard",h)
				else
					h = hClass.hero:new({
						name = hVar.tab_stringU[_HeroID][1],
						id = _HeroID,
						owner = 1,
						unit = nil,
					})
					hGlobal.event:call("LocalEvent_GetHeroCard",h)
					h:del()
				end
			end
			
			_frm:show(0,"normal")
			_exitFun()
		end,
	})
	
	hGlobal.event:listen("LocalEvent_BuyHeroCardSucceed","__Succeed",function(heroID, star, lv, prizeid)
		local hLv = lv or 1
		local hExp = hApi.GetLevelMinExp(hLv) or 0
		local hStar = star or 1
		local oHero = hClass.hero:new({
			name = hVar.tab_stringU[heroID][1],
			id = heroID,
			owner = 1,
			unit = nil,
			star = hStar,
			exp = hExp,
			level = hLv,
		})
		hGlobal.event:call("LocalEvent_GetHeroCard",oHero,"BuyHeroCard",prizeid)
		oHero:del()
	end)
	
	--取消面板
	_childUI["btnCancel"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Cancel"],
		x = _frm.data.w/2-100,
		y = -310,
		scaleT = 0.9,
		code = function()
			_frm:show(0,"normal")
			_exitFun()
		end,
	})
	
	--技能按钮
	local _createSkillBtn = function(activeskillList, talentskillList, heroID)
		for i = 1,#_skillListCount do
			hApi.safeRemoveT(_childUI,_skillListCount[i])
		end
		
		_skillListCount = {}
		
		local skillindex = 0
		
		--战术技能
		if (#activeskillList > 0) then
			for i = 1, #activeskillList, 1 do
				skillindex = skillindex + 1
				
				--背景图
				_childUI["HeroSkillImg_BG_"..skillindex] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = "UI:TacticImgBG",
					w = 58,
					h = 58,
					x = 208 + (skillindex-1)*58,
					y = -210,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_BG_"..skillindex
				
				_childUI["HeroSkillImg_"..skillindex] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = hVar.tab_skill[activeskillList[i]].icon , --hVar.tab_unit[5000].icon,
					dragbox = _childUI["dragBox"],
					w = 48,
					h = 48,
					x = 208 + (skillindex-1)*58,
					y = -210,
					scaleT = 0.95,
					code = function(self,x,y,sus)
						hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroID,activeskillList[i],150,600)
					end,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_"..skillindex
			end
		end
		
		--天赋技能
		if (#talentskillList > 0) then
			for i = 1, #talentskillList, 1 do
				skillindex = skillindex + 1
				
				_childUI["HeroSkillImg_"..skillindex] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = hVar.tab_skill[talentskillList[i]].icon , --hVar.tab_unit[5000].icon,
					dragbox = _childUI["dragBox"],
					w = 48,
					h = 48,
					x = 208 + (skillindex-1)*58,
					y = -210,
					scaleT = 0.95,
					code = function(self,x,y,sus)
						hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroID,talentskillList[i],150,600)
					end,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_"..skillindex
			end
		end
	end
	
	--打折图片
	_childUI["25%off"] = hUI.image:new({
		parent = _parent,
		model = "UI:discount_01_en",
		x = _x-35,
		y = _y+53,
		scale = 0.7,
		z = 2,
	})
	_childUI["25%off"].handle._n:setVisible(false)
	
	local Score,itemRMB = 0,0
	hGlobal.event:listen("LocalEvent_ShowBuyHeroCardFrm","__ShowBuyHeroCardFrm",function(oHero,shopID,off,heroID, star, lv)
		local lockMap = hVar.NET_SHOP_ITEM_LIMIT[shopID]
		local lockFlag = false
		if lockMap and type(lockMap) == "string" and LuaGetPlayerMapAchi(lockMap,hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then
			--锁定英雄令的购买
			lockFlag = true
		end
		
		if lockFlag then									--未通关响应关卡，锁定英雄令
			--local strMsg = hVar.tab_string["__TEXT_inform_herocard1"]..hVar.tab_stringM[lockMap][1]..hVar.tab_string["__TEXT_inform_herocard2"]
			--hGlobal.UI.MsgBox(strMsg,{				--弹出message（）
			--	font = hVar.FONTC,
			--	ok = function()
			--	end,
			--})
			--return
		end
		
		_off = off or 1
		if _off < 1 then
			_childUI["25%off"].handle._n:setVisible(true)
		else
			_childUI["25%off"].handle._n:setVisible(false)
		end
		_HeroID = 0
		if oHero then
			_HeroID = oHero.data.id
		else
			_HeroID = heroID
		end
		
		_shopID = shopID
		if hApi.IsHaveHeroCard(_HeroID) == true and oHero then
			print("you have this card! ".._HeroID)
			--oHero:setowner(hGlobal.LocalPlayer.data.playerId) 
			--if oHero:LoadHeroFromCard("hire") then
				--oHero.data.HeroCard = 1
			--end
			return 
		end
		_childUI["btnOK"]:setstate(0)
		hApi.SetObject(_oHero,oHero)
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		_removeList = {}
		_childUI["HeroCard"] = hUI.image:new({
			parent = _parent,
			model = hVar.tab_unit[_HeroID].portrait,
			x = _x-7,
			y = _y+8,
			w = 128,
			h = 128,
			z = 1,
		})
		_removeList[#_removeList+1] = "HeroCard"
		_childUI["bg"] = hUI.image:new({
			parent = _parent,
			model = "UI:PANEL_CARD_01",
			x = _x-8,
			y = _y-14,
		})
		_removeList[#_removeList+1] = "bg"
		
		--英雄等级前缀
		_childUI["heroLvPostfix"] = hUI.label:new({
			parent = _parent,
			x = _x - 39,
			y = _y - 90 + 1,
			--text = "级", --language
			text = hVar.tab_string["__TEXT_ji"], --language
			size = 18,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
			width = 200,
		})
		_childUI["heroLvPostfix"].handle.s:setColor(ccc3(255, 255, 128))--黄色
		_removeList[#_removeList+1] = "heroLvPostfix"
		
		_childUI["heroLv"] = hUI.label:new({
			parent = _parent,
			x = _x -56,
			y = _y -90,
			text = tostring(lv or 1),
			size = 16,
			font = "num",
			align = "MC",
			width = 200,
		})
		_removeList[#_removeList+1] = "heroLv"
		_childUI["heroName"] = hUI.label:new({
			parent = _parent,
			x = _x+7,
			y = _y-90,
			text = hVar.tab_stringU[_HeroID][1],
			size = 24,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		_removeList[#_removeList+1] = "heroName"
		for i = 1, (star or 5), 1 do
			_childUI["HERO_STAR"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:HERO_STAR",
				x = _x - 47 + (i-1)*16,
				y = _y -67,
			})
			_removeList[#_removeList+1] = "HERO_STAR"..i
		end
		
		local talent = hVar.tab_unit[_HeroID].talent
		local tactics = hVar.tab_unit[_HeroID].tactics
		local activeskillList = {}
		local talentskillList = {}
		
		--战术技能
		if tactics and type(tactics) == "table" then
			for i = 1,#tactics do
				local tacticsId = tactics[i]
				local skillId = 0
				if hVar.tab_tactics[tacticsId].activeSkill and type(hVar.tab_tactics[tacticsId].activeSkill) == "table" then 
					skillId = hVar.tab_tactics[tacticsId].activeSkill.id or 0
				end
				if skillId > 0 and hVar.tab_skill[skillId] then
					activeskillList[#activeskillList+1] = skillId
				end
			end
		end
		
		--天赋技能
		if type(talent) == "table" then
			for i = 1, #talent, 1 do
				talentskillList[#talentskillList+1] = talent[i][1]
			end
		end
		
		--显示价格
		if hVar.tab_shopitem[shopID] then
			Score,itemRMB =  math.ceil(hVar.tab_shopitem[shopID].score*_off), math.ceil(hVar.tab_shopitem[shopID].rmb*_off)
		end
		_childUI["Score_labe"]:setText(tostring(Score))
		_childUI["itemRMB_labe"]:setText(tostring(itemRMB))
		_childUI["HeroCardInfo"]:setText(hVar.tab_stringU[_HeroID][2])
		
		--如果消耗的经验值为0，则将游戏币左移。将值为0的项隐藏	added by pangyong 2015/4/28
		if 0 == Score then
			_childUI["itemRMB_image"]:setXY(225, -260)
			_childUI["itemRMB_labe"]:setXY(250, -250 + 1)
			
			_childUI["Score_image"].handle._n:setVisible(false)
			_childUI["Score_labe"].handle._n:setVisible(false)
		elseif 0 == itemRMB then
			_childUI["itemRMB_image"].handle._n:setVisible(false)
			_childUI["itemRMB_labe"].handle._n:setVisible(false)
		end
		
		--创建本英雄令的技能按钮
		_createSkillBtn(activeskillList, talentskillList, _HeroID)
		
		--如果钱不足 则不显示确定按钮
		local cur_score = LuaGetPlayerScore()
		local cur_RMB = 0
		
		if g_vs_number <= 4 then
			cur_RMB = (xlGetGameCoinNum() or 0)
		else
			--发送获取游戏币信令
			SendCmdFunc["gamecoin"]()
		end
		
		if cur_RMB >= itemRMB and cur_score >= Score and hApi.IsHaveHeroCard(_HeroID) == false and not lockFlag then
			_childUI["btnOK"]:setstate(1)
		end
		
		if g_cur_net_state == -1 then
			_frm:setWH(_w,_h+40)
			_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["ios_err_network_cannot_conn2"])
		elseif g_cur_net_state == 1 then
			_childUI["net_and_rmb_labe"]:setText("")
			_frm:setWH(_w,_h)
		end
		_frm:show(1)			--显示英雄卡购买框
		_frm:active()			--使购买英雄框置顶显示
	end)

	--通过服务器请求获得游戏币数据 以及相关判断
	hGlobal.event:listen("LocalEvent_SetCurGameCoin","setcurgamecoin1",function(cur_rmb) 
		--当界面打开时 判断当前游戏币 是否可以显示确定按钮
		if _frm.data.show == 1 then
			if hApi.IsHaveHeroCard(_HeroID) == hVar.RESULT_SUCESS then
				_frm:setWH(_w,_h+40)
				_childUI["btnOK"]:setstate(0)
				_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["__TEXT_can't_buy_herocard_tip"])
			else--没有此英雄令的时候
				local cur_score = LuaGetPlayerScore()
				if type(cur_rmb) == "number" then
					if cur_rmb >= itemRMB and cur_score >= Score then
						_frm:setWH(_w,_h)
						_childUI["net_and_rmb_labe"]:setText("")
						_childUI["btnOK"]:setstate(1)
					else
						_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["__TEXT_not_enough_money"])
						_frm:setWH(_w,_h+40)
					end
				else
					_frm:setWH(_w,_h+40)
					_childUI["btnOK"]:setstate(0)
					_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["ios_err_network_cannot_conn2"])
				end
			end
		end
	end)

	--通过服务器请求获得游戏币数据 以及相关判断
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","Phone_setcurgamecoin11",function(cur_rmb) 
		--当界面打开时 判断当前游戏币 是否可以显示确定按钮
		if _frm.data.show == 1 then
			--拥有英雄令的时候
			if hApi.IsHaveHeroCard(_HeroID) == hVar.RESULT_SUCESS then
				_frm:setWH(_w,_h+40)
				_childUI["btnOK"]:setstate(0)
				_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["__TEXT_can't_buy_herocard_tip"])
			else--没有此英雄令的时候
				local cur_score = LuaGetPlayerScore()
				if type(cur_rmb) == "number" then
					if cur_rmb >= itemRMB and cur_score >= Score then
						_frm:setWH(_w,_h)
						_childUI["net_and_rmb_labe"]:setText("")
						_childUI["btnOK"]:setstate(1)
					else
						_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["__TEXT_not_enough_money"])
						_frm:setWH(_w,_h+40)
					end
				else
					_frm:setWH(_w,_h+40)
					_childUI["btnOK"]:setstate(0)
					_childUI["net_and_rmb_labe"]:setText(hVar.tab_string["ios_err_network_cannot_conn2"])
				end
			end
		end
	end)

end