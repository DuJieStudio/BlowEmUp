--------------------------------------------
-- 战斗结束后的随机奖励面板，支持玩家重转
--
--------------------------------------------
hGlobal.UI.InitRewardFrm = function()
	local _w,_h = 600,560
	hGlobal.UI.RewardFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		autoactive = 0,
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
			if hGlobal.UI.ItemInfoFram.data.show == 1 or IsInside == 0 then
				hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			end
		end,
	})

	local _frm = hGlobal.UI.RewardFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	local _createremove = nil
	local _nextpos = nil
	local _currentpos = 0,0,0
	local _cur_rmb = 0

	--网络状态1
	_childUI["connect_result1"] = hUI.image:new({
		parent = _parent,
		model = "UI:wifi",
		z = 2,
		x = 80,
		y = -36,
	})
	_childUI["connect_result1"].handle._n:setVisible(false)

	----网络状态2
	--_childUI["connect_result2"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/gamebbs.png",
		--z = 2,
		--x = 80,
		--y = -36,
	--})
	--_childUI["connect_result2"].handle._n:setVisible(false)
	
	--网络状态1
	--_childUI["connect_result_lab"] = hUI.label:new({
		--parent = _parent,
		--size = 26,
		--text = "",
		--align = "MC",
		--border = 1,
		--x = 40,
		--y = -20,
	--})

	local _animiX,_animiY = _w/2 - 40, -_h + 536
	--开启宝箱动画的标记
	_childUI["programm_versionTip1"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 26,
		text = hVar.tab_string["Text_Animation"],
		align = "LT",
		border = 1,
		x = _animiX + 120,
		y = _animiY,
	})
	
	_childUI["language_sc_selectbox"] = hUI.image:new({
		parent = _parent,
		model = "UI:Button_SelectBorder",
		x = _animiX + 254,
		y = _animiY - 8,
		scale = 0.4,
	})
	
	--选中的特效
	_childUI["selectbox_finish"] = hUI.image:new({
		parent = _parent,
		model = "UI:finish",
		scale = 0.9,
		x = _animiX + 254,
		y = _animiY - 4,
	})
	_childUI["selectbox_finish"].handle._n:setVisible(true)
	
	_childUI["language_sc_btn"] = hUI.button:new({
		parent = _frm,
		model = -1,
		x = _animiX + 270,
		y = _animiY - 4,
		w = 100,
		h = 50,
		code = function(self)
			if _childUI["selectbox_finish"].handle._n:isVisible() then
				_childUI["selectbox_finish"].handle._n:setVisible(false)
				CCUserDefault:sharedUserDefault():setIntegerForKey("xl_Animation",1)
				CCUserDefault:sharedUserDefault():flush()
			else
				_childUI["selectbox_finish"].handle._n:setVisible(true)
				CCUserDefault:sharedUserDefault():setIntegerForKey("xl_Animation",2)
				CCUserDefault:sharedUserDefault():flush()
			end
		end,
	})

	--选框按顺时针旋转的坐标
	local _posindex = {6,7,8,5,3,2,1,4}
	--找到旋转索引的下一个索引坐标
	local _nextpos = function(curpos)
		local nextpos = 0
		for i = 1,#_posindex do
			if curpos == _posindex[i] then
				if _posindex[i+1] then
					nextpos = _posindex[i+1]
				else
					nextpos = _posindex[1]
				end
			end
		end
		return nextpos
	end

	--重转奖励物品的槽子
	local _x,_y,_plusX,_plusY ,_resX,_resY =82,-350,210,100,293,-250
	local _indexX,_indexY = 0,0
	local _poslistX = {}
	local _poslistY = {}
	for i = 1,9 do
		if i ~= 5 then
			_poslistX[#_poslistX+1],_poslistY[#_poslistY+1] = _x+_indexX*_plusX, _y+_indexY*_plusY
		end
		_indexX = _indexX+1
		if math.mod(i,3) == 0 then
			_indexX = 0
			_indexY = _indexY+1
		end
	end
	
	--这里是修改一下 几个道具位置
	local templist = {1,2,3,4,6,7,8}
	local tempposX = {100,0,-100,20,100,0,-100}
	local tempposY = {0,-50,0,0,-0,50,-0}

	for i = 1,#templist do
			_poslistX[templist[i]] = _poslistX[templist[i]]+tempposX[i]
			_poslistY[templist[i]] = _poslistY[templist[i]]+tempposY[i]
	end

	--资源槽子和lab
	for i = 1,8 do
		_childUI["item_solt_bg_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:item_slot",
			x = _poslistX[i],
			y = _poslistY[i],
		})

		_childUI["res_labe_"..i] = hUI.label:new({
			parent = _parent,
			size = 22,
			align = "MC",
			font = hVar.FONTC,
			x = _poslistX[i],
			y = _poslistY[i]-50,
			width = 300,
			border = 1,
			text = "",
		})
	end

	--当前刷出的资源背景框
	_childUI["res1_slot_"] = hUI.image:new({
		parent = _parent,
		model = "UI:item_slot_big",
		x = _resX,
		y = _resY,
	})
	_childUI["res1_labe"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		font = hVar.FONTC,
		x = _resX,
		y = _resY-80,
		width = 300,
		border = 1,
		text = "",
	})

	--创建具体的奖励内容
	local _cur_state = 0
	local removeList = {}
	local temprewardTable = {}
	local r_reslist = {}
	local _createRewardlist = function(rewardTable)
		temprewardTable = rewardTable
		for i = 1,8 do
			--获取奖励类型资源或者是道具，奖励的具体类型，奖励的数值多少
			local typ,id,num,sHintEx = unpack(temprewardTable[i])
			_childUI["res_"..i] = hUI.button:new({
				parent = _parent,
				model = hApi.GetLootModel(temprewardTable[i]),
				dragbox = _childUI["dragBox"],
				animation = hApi.GetLootAnimation(temprewardTable[i]),
				x = _poslistX[i],
				y = _poslistY[i],
				w = 45,
				h = 45,
				code = function(self)
					if _cur_state == 1 then return end
					--显示道具提示
					if typ=="item" then
						if hVar.tab_item[id] then
							hGlobal.event:event("LocalEvent_ShowItemTipFram",{{id}},nil,1)
						end
					end
				end,
			})
			removeList[#removeList+1] = "res_"..i
			if type(sHintEx)=="string" then
				_childUI["res_labe_"..i]:setText(tostring(sHintEx))
			else
				_childUI["res_labe_"..i]:setText(tostring(num))
			end
			if typ == "item" then
				--更改字体颜色
				local itemLv = (hVar.tab_item[id].itemLv or 1)
				local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
				if type(hVar.tab_item[id].elite) == "number" then
					RGB = hVar.ITEM_ELITE_LEVEL[hVar.tab_item[id].elite].NAMERGB
				end
				local R,G,B = unpack(RGB)
				_childUI["res_labe_"..i].handle.s:setColor(ccc3(R,G,B))

			else
				_childUI["res_labe_"..i].handle.s:setColor(ccc3(255,255,255))
			end

			_childUI["res_r"..i] = hUI.image:new({
				parent = _parent,
				model = hApi.GetLootModel(temprewardTable[i]),
				animation = hApi.GetLootAnimation(temprewardTable[i]),
				x = _resX,
				y = _resY,
				w = 64,
			})
			removeList[#removeList+1] = "res_r"..i
			r_reslist[#r_reslist+1] = _childUI["res_r"..i]
		end
	end
	local _showRes = function(resIndex,n)
		for i = 1,n do
			if r_reslist[i] then
				r_reslist[i].handle._n:setVisible(false)
				if resIndex == i then
					r_reslist[i].handle._n:setVisible(true)

					local typ,id,num,sHintEx = unpack(temprewardTable[i])
					if type(sHintEx)=="string" then
						_childUI["res1_labe"]:setText(tostring(sHintEx))
					else
						_childUI["res1_labe"]:setText(tostring(num))
					end

					if typ == "item" then
						local itemLv = (hVar.tab_item[id].itemLv or 1)
						local nameRGB = hVar.ITEMLEVEL[itemLv].NAMERGB
						local r,g,b = unpack(nameRGB)
						_childUI["res1_labe"].handle.s:setColor(ccc3(r,g,b))
					else
						_childUI["res1_labe"].handle.s:setColor(ccc3(255,255,255))
					end
				end
			end
		end
	end

	local _RunActionCallBack = function()
		local n = #temprewardTable
		local r = hApi.random(1,n)
		_showRes(r,n)
		hApi.PlaySound("blink")
	end

	local _last_res_select = {}
	local _last_resX = {}
	local _last_resY = {}
	--上次转得的道具
	for i = 1,2 do
		_last_resX[i] = _resX + i*100
		_last_resY[i] = -445

		_childUI["last_res_labe"..i] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			x = _last_resX[i],
			y = _last_resY[i]-40,
			width = 300,
			border = 1,
			text = "",
		})
	end
	
	local _ActionOverOnLastRes = function()
		hApi.safeRemoveT(_childUI,"strengthen_eff")
		_childUI["strengthen_eff"] =hUI.image:new({
			parent = _parent,
			model = "MODEL_EFFECT:strengthen",
			IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_UI,
			x = 0,
			y = 0,
			w = 110,
			h = 110,
		})
		_childUI["strengthen_eff"].handle._n:setVisible(false)

		for i = 1,#_last_res_select do
			_childUI[_last_res_select[i][1]]:setXY(_last_resX[i],_last_resY[i])
			_childUI["last_res_labe"..i]:setText(hVar.tab_stringI[_last_res_select[i][2]][1])
			local itemLv = (hVar.tab_item[_last_res_select[i][2]].itemLv or 1)
			local nameRGB = hVar.ITEMLEVEL[itemLv].NAMERGB
			local r,g,b = unpack(nameRGB)
			_childUI["last_res_labe"..i].handle.s:setColor(ccc3(r,g,b))


			_childUI["strengthen_eff"].handle._n:setPosition(_last_resX[i],_last_resY[i])
			_childUI["strengthen_eff"].handle._n:setVisible(true)

			
		end
		_childUI["dragBox"]:sortbutton()
	end
	--给_last_res_select 表中增加可选择的道具按钮
	local _createLastResBtn = function(itemID)
		local index = #_last_res_select+1
		_childUI["last_res_btn_"..index] = hUI.button:new({
			parent = _parent,
			model = hApi.GetLootModel(temprewardTable[_currentpos]),
			dragbox = _childUI["dragBox"],
			animation = hApi.GetLootAnimation(temprewardTable[_currentpos]),
			x = _poslistX[_currentpos],
			y = _poslistY[_currentpos],
			w = 45,
			h = 45,
			code = function(self)
				if hVar.tab_item[itemID] and _cur_state == 0 then
					_showRes(_last_res_select[index][3],8)
					_currentpos = _last_res_select[index][3]
					
					if _childUI["strengthen_eff"] then
						_childUI["strengthen_eff"].handle._n:setPosition(_last_resX[index],_last_resY[index])
					else
						_childUI["strengthen_eff"] =hUI.image:new({
							parent = _parent,
							model = "MODEL_EFFECT:strengthen",
							IsTemp = hVar.TEMP_HANDLE_TYPE.OBJECT_UI,
							x = _last_resX[index],
							y = _last_resY[index],
							w = 110,
							h = 110,
						})
					end

					
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{{itemID}},nil,1)
				end
			end,
		})
		_last_res_select[index] = {"last_res_btn_"..index,itemID,_currentpos}
		local array = CCArray:create()

		if type(_last_resX[index]) == "number" and type(_last_resY[index]) == "number" then
			array:addObject(CCMoveTo:create(0.5,ccp(_last_resX[index], _last_resY[index])))
			array:addObject(CCCallFunc:create(_ActionOverOnLastRes)) 
			_childUI["last_res_btn_"..index].handle._n:runAction(CCSequence:create(array))
		end
	end

	local _restVal = 0
	local _canRest = 0
	--动作结束后的回调函数 绘制出当前的资源
	local _ActionOverCallBack = function()
		local n = #temprewardTable
		_showRes(_currentpos,n)

		local _,id,_,_ = unpack(temprewardTable[_currentpos])
		
		if #_last_res_select > 0 then
			_createLastResBtn(id)
		end

		if g_vs_number <= 4 then
			if xlGetGameCoinNum() >= _restVal and _canRest == 1 then
				_childUI["btnReset"]:setstate(1) 
			end
		else
			if _cur_rmb >= _restVal and _canRest ~= 0 then
				_childUI["btnReset"]:setstate(1) 
			end
		end
		
		
		_cur_state = 0
		_childUI["btnOk"]:setstate(1)
		--_frm:active() --geyachao: 有可能网络断开，此时会弹一个连接超时的框，会被此控件挡在后面
	end
	local _selectN = nil
	--重转按钮逻辑 ,起始索引 间隔时间 圈数
	_createremove = function(endPos,Time,count)
		_cur_state = 1
		_childUI["btnOk"]:setstate(0)
		_childUI["res1_labe"]:setText("")
		--首先设置选框的起始位置
		local array = CCArray:create()
		for i = 1,count do
			if i < count - 1 then
				for j = 1,9 do 
					_currentpos = _nextpos(_currentpos)
					array:addObject(CCMoveTo:create(Time,ccp(_poslistX[_currentpos], _poslistY[_currentpos])))
					array:addObject(CCCallFunc:create(_RunActionCallBack)) 
				end
				
			elseif i == count - 1 then
				for j = 1,9 do 
					_currentpos = _nextpos(_currentpos)
					array:addObject(CCMoveTo:create(Time*2,ccp(_poslistX[_currentpos], _poslistY[_currentpos])))
					array:addObject(CCCallFunc:create(_RunActionCallBack))  
				end

			elseif i == count then
			--最后一圈停止动画
				if _currentpos == endPos then
					--需要特殊补一段动画
					if CCUserDefault:sharedUserDefault():getIntegerForKey("xl_Animation") == 2 then
						for j = 1,9 do 
							_currentpos = _nextpos(_currentpos)
							array:addObject(CCMoveTo:create(Time,ccp(_poslistX[_currentpos], _poslistY[_currentpos])))
							array:addObject(CCCallFunc:create(_RunActionCallBack)) 
						end
					end
				else
					while _currentpos ~= endPos do
						_currentpos = _nextpos(_currentpos)
						array:addObject(CCMoveTo:create(Time*3,ccp(_poslistX[_currentpos], _poslistY[_currentpos])))
						array:addObject(CCCallFunc:create(_RunActionCallBack))  
					end
				end
				
			end
		end

		--加入动作完成后的回调函数
		array:addObject(CCCallFunc:create(_ActionOverCallBack))  
		_selectN:runAction(CCSequence:create(array))
		_selectN:setVisible(true)
	end
	
	local _switch_baseline = 0
	local _fromBag = nil
	local _fromBagIndex = nil
	local _getUnit = {}
	local _frmoItem = {}
	local _frmoMap = {}
	local _tradeid = 0

	--重选按钮
	_childUI["btnReset"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		border = 1,
		label = hVar.tab_string["__TEXT_RestConfirm"],
		font = hVar.FONTC,
		scaleT = 0.9,
		scale = 0.9,
		x = 120,
		y = -520,
		code = function(self)
			self:setstate(0)
			if _canRest > 0 then
				_canRest = _canRest - 1
			end

			if g_vs_number <= 4 then
				xlUseGameCoinNum(_restVal)
				_childUI["Account_Balance2"]:setText(tostring(xlGetGameCoinNum()))
				--如果是黄金宝箱则保留上一次的道具
				if _restVal == 10 then
					local _,id,_,_ = unpack(temprewardTable[_currentpos])
					_createLastResBtn(id)
					
				end

				if type(_createremove) == "function" then
					local r = hApi.random(1,8)
					_createremove(r,0.08,4)
				end
			else -- 新版本的发送消耗游戏币
				local shopid = 0
				local name = ""

				if _restVal == 1 then
					shopid = 6000
					name = hVar.tab_string["__TEXT_RestConfirm1"]
				elseif _restVal == 10 then
					shopid = 6001
					name = hVar.tab_string["__TEXT_RestConfirm2"]
				elseif _restVal == 0 then
					shopid = 6002
					name = hVar.tab_string["__TEXT_RestConfirm3"]
				elseif _restVal == -1 then
					return hGlobal.event:event("LocalEvent_BuyResetSucceed",nil)
				end

				--SendCmdFunc["buy_shopitem"](shopid,_restVal,name,0)
				SendCmdFunc["order_begin"](6,shopid,_restVal,1,name,0,0,nil)
			end
		end,
	})

	hGlobal.event:listen("LocalEvent_BuyResetSucceed","__Succeed",function(order_id)
		if _frm.data.show == 0 then return end
		local _,id,_,_ = unpack(temprewardTable[_currentpos])
		if type(id) == "number" then
			if xlAppAnalysis then
				xlAppAnalysis("shop_golden_treasure_renew",0,1,"clientID",tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end

			_createLastResBtn(id)
		end

		if type(_createremove) == "function" then
			local r = hApi.random(1,8)
			local is_show_Animation = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_Animation")
			if is_show_Animation == 1 or is_show_Animation == 0 then
				_createremove(r,0.08,4)
			else
				_createremove(r,0.05,1)
			end
		end
		if type(order_id) == "number" then
			SendCmdFunc["order_update"](_tradeid,2,tostring(id))
			_tradeid = order_id
		end
	end)


	--local _userItemTime = 0
	--确定按钮 
	_childUI["btnOk"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		border = 1,
		label = hVar.tab_string["__TEXT_Confirm"],
		font = hVar.FONTC,
		scaleT = 0.9,
		x = _w - 120,
		y = -520,
		scale = 0.9,
		code = function(self)
			self:setstate(0)
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0)
			end

			local resType,resTypeEx,resValue = unpack(temprewardTable[_currentpos])
			
			--消耗类
			if hVar.tab_item[resTypeEx] and hVar.tab_item[resTypeEx].type == hVar.ITEM_TYPE.PLAYERITEM then
				if resTypeEx == 9007 then
					LuaSetPlayerMaterial(1, LuaGetPlayerMaterial(1) + resValue)
				elseif resTypeEx == 9008 then
					LuaSetPlayerMaterial(2, LuaGetPlayerMaterial(2) + resValue)
				elseif resTypeEx == 9009 then
					LuaSetPlayerMaterial(3, LuaGetPlayerMaterial(3) + resValue)
				end
				LuaSaveHeroCard()
				_frm:show(0,"appear")
				hGlobal.SceneEvent:continue(300)
				return
			end

			if _switch_baseline == 1 and resType == "item" then 
				local itemLv = hVar.tab_item[resTypeEx].itemLv or 1
				LuaAddGetItemCount(itemLv,1)
				if itemLv < 4 then
					LuaSetRollBaseLine(LuaGetRollBaseLine()+1)
				elseif itemLv == 4 then
					LuaSetRollBaseLine(0)
				end

				
			end
			if resType~="treasure" then
				--防止死循环
				if resType=="item" then
					hApi.UnitGetLoot(_getUnit,resType,resTypeEx,resValue,_getUnit,_fromBag,_fromBagIndex,_canRest,_frmoItem,_frmoMap)
				else
					hApi.UnitGetLoot(_getUnit,resType,resTypeEx,resValue,_getUnit)
				end
			end
			
			_frm:show(0,"appear")
			_selectN:setVisible(false)
			--创建奖励者图片
			hApi.safeRemoveT(_childUI,"icon")
			hApi.safeRemoveT(_childUI,"res1_")
			for i = 1,#removeList do 
				hApi.safeRemoveT(_childUI,removeList[i])
			end

			for i = 1,#_last_res_select do
				hApi.safeRemoveT(_childUI,_last_res_select[i][1])
				if _childUI["last_res_labe"..i] then
					_childUI["last_res_labe"..i]:setText("")
				end
			end

			hApi.safeRemoveT(_childUI,"strengthen_eff")
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			removeList = {}
			r_reslist = {}
			_last_res_select = {}
			LuaSaveHeroCard()
			if _tradeid ~= 0 then
				--SendCmdFunc["send_forged_finish"](luaGetplayerDataID(),2,_tradeid,tostring(resTypeEx),4)
				SendCmdFunc["order_update"](_tradeid,2,tostring(resTypeEx))
			end

			_childUI["dragBox"]:sortbutton()
			hGlobal.SceneEvent:continue(300)
		end,
	})

	--选中框
	_childUI["SelectBorder"]= hUI.image:new({
		parent = _parent,
		mode = "image",
		model = "UI:Button_SelectBorder",
		align = "MC",
		w = 60,
		x = _poslistX[1],
		y = _poslistY[1],
		RGB = {0,0,0},
	})
	_selectN = _childUI["SelectBorder"].handle._n
	_childUI["SelectBorder"].handle.s:setOpacity(0)
	_selectN:setVisible(false)
	
	local nnn = nil
	local decal,count = 11,0
	local r,g,b,parent = 150,128,64,_selectN
	local offsetX,offsetY,duration,scale = 37,37,0.7,1.1
	nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
	nnn:setScale(3.5)

	--local p = CCParticleSun:create()
	--p:setTexture(CCTextureCache:sharedTextureCache():addImage(hApi.GetFilePath("image/misc/CloseNormal.png")))
	
	--local node = tolua.cast(p,"CCNode")
	--node:setPosition(ccp(50,50))
	--_childUI["SelectBorder"].handle._n:addChild(node)

	_childUI["game_coins_image"] = hUI.image:new({
		parent = _parent,
		model = "UI:game_coins",
		x = 80,
		y = -473,
		scale = 0.9,
	})

	--vip 显示
	for i = 1,8 do
		_childUI["vip_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:vip"..i,
			x = 120,
			y = -473,
			scale = 0.7,
		})
		_childUI["vip_"..i].handle._n:setVisible(false)
	end

	--游戏币lab
	_childUI["Account_Balance2"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 115,
		y = -468,
		width = 500,
		border = 1,
		text = "",
	})

	_childUI["game_coins_image_info"] = hUI.image:new({
		parent = _parent,
		model = "UI:game_coins",
		x = 200,
		y = -518,
		scale = 0.8,
	})


	--重转消耗游戏币的提示
	_childUI["Account_Balance_info"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "LT",
		--font = hVar.FONTC,
		x = 225,
		y = -512,
		width = 500,
		border = 1,
		text = "",
	})
	

	local _setreward = function(index)
		_selectN:setPosition(self.data.x,self.data.y)
		_selectN:setVisible(true)
		--没选中的不显示
		for j = 1,6 do
			if j == i then
				_childUI["res1_"..j].handle._n:setVisible(true)
			else
				_childUI["res1_"..j].handle._n:setVisible(false)
			end
		end
	end
	
	--可得碎片的提示
	_childUI["chip_info"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = _w - 140,
		y = -476,
		width = 500,
		border = 1,
		text = hVar.tab_string["__TEXT_CHIP_INFO"],
	})
	_childUI["chip_info"].handle._n:setVisible(false)
	
	--碎片数量显示
	_childUI["chip_num_info"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		x = _w - 90,
		y = -508,
		width = 500,
		border = 1,
		text = "x 1",
	})
	_childUI["chip_num_info"].handle._n:setVisible(false)
	
	hGlobal.event:listen("LocalEvent_setChipNum","set_chip_num",function(num)
		_childUI["chip_num_info"]:setText(tostring("x "..num))
	end)
	
	_childUI["monthly_card"] = hUI.image:new({
		parent = _parent,
		model = "misc/monthly_card.png",
		x = _w - 86,
		y = -_h + 120,
		scale = 0.8,
	})
	_childUI["monthly_card"].handle._n:setVisible(false)

	hGlobal.event:listen("localEvent_ShowRewardFrm","showfrm",function(oUnit,rewardTable,Resetcount,ResetVal,fromBag,fromBagIndex,fromItem,frmoMap,tradeid)
		_frmoMap = frmoMap
		_frmoItem = fromItem
		_fromBag = fromBag
		_fromBagIndex = fromBagIndex
		_switch_baseline = 0
		_cur_rmb = 0
		_tradeid = tradeid or 0
		for i = 1,8 do
			_childUI["vip_"..i].handle._n:setVisible(false)
		end

		if LuaGetPlayerVipLv() > 3 then
			_restVal = 0
			--等于1是 重转资源，此处为了区分免费重转宝箱
			if ResetVal == 1 then
				_restVal = -1
			end
			_childUI["vip_"..LuaGetPlayerVipLv()].handle._n:setVisible(true)
		else
			_restVal = ResetVal
		end
		_childUI["Account_Balance_info"]:setText(tostring("x ".._restVal))


		_getUnit = oUnit
		_childUI["btnReset"]:setstate(0)
		_selectN:setVisible(false)
		--创建奖励者图片
		hApi.safeRemoveT(_childUI,"res1_")
		for i = 1,#removeList do 
			hApi.safeRemoveT(_childUI,removeList[i])
		end
		removeList = {}
		r_reslist = {}
		local tempTable = {}
		for i = 1,#rewardTable do
			--转换积分数据项
			tempTable[i] = {rewardTable[i][1],rewardTable[i][2],rewardTable[i][3],rewardTable[i][4],rewardTable[i][5]}
			if rewardTable[i][1] == "score" and rewardTable[i][2] == "random" and type(rewardTable[i][3]) == "table" then
				--产生随机积分
				local r = hApi.random(rewardTable[i][3][1],rewardTable[i][3][2])
				tempTable[i]  = {"score","random",r}
			end
		end

		_createRewardlist(tempTable)

		--设置当前玩家的游戏币
		if g_vs_number <= 4 then
			_childUI["Account_Balance2"]:setText(tostring(xlGetGameCoinNum()))
		else
			--发送获取游戏币信令
			SendCmdFunc["gamecoin"]()
		end

		if Resetcount == 0 then
			for i = 1,8 do
				_childUI["vip_"..i].handle._n:setVisible(false)
			end

			_canRest = 0
			_childUI["btnReset"]:setstate(-1)
			_childUI["game_coins_image"].handle._n:setVisible(false)
			_childUI["Account_Balance2"].handle._n:setVisible(false)
			_childUI["game_coins_image_info"].handle._n:setVisible(false)
			_childUI["Account_Balance_info"].handle._n:setVisible(false)
			_childUI["btnOk"]:setXY(_w/2-10,-520)
		else
			_canRest = Resetcount
			_switch_baseline = 1

			if _restVal > 0 then
				_childUI["game_coins_image"].handle._n:setVisible(true)
				_childUI["Account_Balance2"].handle._n:setVisible(true)
				SendCmdFunc["gamecoin"]()
				_childUI["game_coins_image_info"].handle._n:setVisible(true)
				_childUI["Account_Balance_info"].handle._n:setVisible(true)
			else
				_childUI["game_coins_image"].handle._n:setVisible(false)
				_childUI["Account_Balance2"].handle._n:setVisible(false)
				_childUI["game_coins_image_info"].handle._n:setVisible(false)
				_childUI["Account_Balance_info"].handle._n:setVisible(false)
			end
			_childUI["btnOk"]:setXY(_w - 120,-520)
			

		end
		
		--根据网络状态显示不同的标记
		if g_cur_net_state == 1 then
			--_childUI["connect_result1"].handle._n:setVisible(false)
			_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText("..")
		elseif g_cur_net_state == -1 then
			_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText(".")
		end
		
		--判断是否需要显示碎片
		if type(fromItem) == "table" and type(hVar.tab_item[fromItem[1]].chip) == "string" then
			_childUI["chip_info"].handle._n:setVisible(true)
			_childUI["chip_num_info"].handle._n:setVisible(true)
			_childUI["chip_image"] = hUI.image:new({
				parent = _parent,
				model = hVar.tab_item[fromItem[1]].chip,
				x = _w - 120,
				y = -522,
			})
			removeList[#removeList+1] = "chip_image"
			
			--如果是月卡用户
			if LuaGetPlayerGiftstate(11) == 1 then
				_childUI["monthly_card"].handle._n:setVisible(true)
			end

		else
			_childUI["monthly_card"].handle._n:setVisible(false)
			_childUI["chip_info"].handle._n:setVisible(false)
			_childUI["chip_num_info"].handle._n:setVisible(false)
		end
		_currentpos = 1
		_frm:show(1)
		_frm:active()

		local r = hApi.random(1,8)
		-- 保底机制
		local baseline = LuaGetRollBaseLine()
		if baseline > 50 then
			local rlist = {}
			local resType,resTypeEx,resValue
			for i = 1,#temprewardTable do
				resType,resTypeEx,resValue = unpack(temprewardTable[i])
				if resType == "item" and hVar.tab_item[resTypeEx].itemLv == 4 then
					rlist[#rlist+1] = i
					LuaSetRollBaseLine(0)
				end
			end
			if #rlist > 0 then
				r = rlist[hApi.random(1,#rlist)]
			end
		else
			if _switch_baseline == 1 and baseline == 40 then
				--如果保底技术达到40则 上传一次记录
				xlAppAnalysis("baseline_reward",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."name:"..tostring(g_curPlayerName).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end
		end
		
		local is_show_Animation = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_Animation")
		if is_show_Animation == 1 or is_show_Animation == 0 then
			_childUI["selectbox_finish"].handle._n:setVisible(false)
			_createremove(r,0.08,4)
		else
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_createremove(r,0.05,1)
		end

		_childUI["dragBox"]:sortbutton()

	end)
	
	--根据网络状态设置网络状态 图标
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","setconnectstate",function(connect_state)
		if connect_state == 1 then
			--_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result2"].handle._n:setVisible(true)
			_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText("..")
		elseif connect_state == -1 then
			_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result2"].handle._n:setVisible(false)
			--_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText(".")
		end
	end)

	hGlobal.event:listen("LocalEvent_SetCurGameCoin","setgamecoin3",function(cur_rmb)
		--只有当前界面打开时 才能进行判断
		if type(cur_rmb) == "number" then
			_cur_rmb = cur_rmb
			if _cur_rmb >= _restVal and _canRest ~= 0 and _cur_state == 0 then
				_childUI["btnReset"]:setstate(1) 
			end
		else
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0) 
			end
		end
		_childUI["Account_Balance2"]:setText(tostring(cur_rmb))
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","Phone_setcurgamecoin_991",function(cur_rmb) 
		--只有当前界面打开时 才能进行判断
		if type(cur_rmb) == "number" then
			_cur_rmb = cur_rmb
			if _cur_rmb >= _restVal and _canRest ~= 0 and _cur_state == 0 then
				_childUI["btnReset"]:setstate(1) 
			end
		else
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0) 
			end
		end
		_childUI["Account_Balance2"]:setText(tostring(cur_rmb))
	end)
end
