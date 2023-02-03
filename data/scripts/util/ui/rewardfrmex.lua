hGlobal.UI.InitRewardExFrm = function()
	local _x,_y,_w,_h = hVar.SCREEN.w/2,hVar.SCREEN.h/2,600,600

	hGlobal.UI.RewardFrmEx = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		autoactive = 0,
		codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
		end,
	})
	
	local _frm = hGlobal.UI.RewardFrmEx
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	

	--底图
	_childUI["bg_d"] = hUI.image:new({
		parent = _parent,
		model = "UI:item_slot_big",
		align = "MC",
		x = _w/2,
		y = -_h/2 + 60,
	})
	
	--网络状态1
	_childUI["connect_result1"] = hUI.image:new({
		parent = _parent,
		model = "UI:wifi",
		z = 2,
		x = 80,
		y = -46,
	})
	_childUI["connect_result1"].handle._n:setVisible(false)
	----网络状态2
	--_childUI["connect_result2"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/gamebbs.png",
		--z = 2,
		--x = 100,
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

	local _animiX,_animiY = _w/2, -_h + 560
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



	--位置列表
	local _poslistX = {}
	local _poslistY = {}
	_poslistX[1] = 90
	_poslistX[2] = 90 * 2
	_poslistX[3] = _w/2
	_poslistX[4] = _w - 90 * 2
	_poslistX[5] = _w - 90
	_poslistX[6] = _poslistX[4]
	_poslistX[7] = _w/2
	_poslistX[8] = _poslistX[2]

	_poslistY[1] = -240
	_poslistY[2] = -140
	_poslistY[3] = -70
	_poslistY[4] = -140
	_poslistY[5] = -240
	_poslistY[6] = -340
	_poslistY[7] = -410
	_poslistY[8] = -340

	for i = 1,8 do
		--_poslistX[i] = 160*math.cos((203-i*45)*3.1415926/180) + _w/2
		--_poslistY[i] = 160*math.sin((203-i*45)*3.1415926/180) + _h/2 - _h+10
		_childUI["item_solt_bg_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:item_slot",
			x = _poslistX[i],
			y = _poslistY[i],
		})
	end
	
	local _switch_baseline = 0	--保底机制开关
	local _cur_state = 0
	local _currentpos = 0
	local _restVal = 0
	local _canRest = 0
	local _chest_id = 0
	local _tradeid = 0

	local _last_res_select = {}
	local _last_resX = {}
	local _last_resY = {}
	local _cur_rmb = 0
	
	local _createLastResBtn
	local _temprewardTable = nil

	--选框按顺时针旋转的坐标
	local _posindex = {1,2,3,4,5,6,7,8}
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

	--全部动画回调
	local _ActionOverCallBack = function()
		local _,id,_,_,itemRewardEx = unpack(_temprewardTable[_currentpos])
		if #_last_res_select > 0 then
			_createLastResBtn(id,itemRewardEx)
		end
		
		if _canRest ~=  0 then
			if (_cur_rmb >= _restVal and _cur_rmb > 0  ) or ( LuaGetPlayerVipLv() > 3  ) then
				_childUI["btnReset"]:setstate(1)
			end
		else
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0)
			end
		end

		_childUI["btnOK"]:setstate(1)
		--_frm:active() --geyachao: 有可能网络断开，此时会弹一个连接超时的框，会被此控件挡在后面
		_cur_state = 0
		SendCmdFunc["gamecoin"]()
	end

	--每次转动的动画回调，用来改变中心的道具图标
	local _ActionIndex = 1
	local _RunActionCallBack = function()
		hApi.PlaySound("blink")
		_ActionIndex = _nextpos(_ActionIndex)
		for i = 1,8 do
			_childUI["Centrality"..i].handle._n:setVisible(false)
		end
		_childUI["Centrality".._ActionIndex].handle._n:setVisible(true)
	end

	local _selectN = nil
	_createremove = function(endPos,Time,count)
		_cur_state = 1
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

	--确认按钮
	local removeList = {}
	_childUI["btnOK"] = hUI.button:new({
		parent = _frm,
		model = "UI:ButtonBack2",
		border = 1,
		label = hVar.tab_string["__TEXT_Confirm"],
		font = hVar.FONTC,
		scaleT = 0.9,
		x = _w/2 + 160,
		y = -_h + 40,
		scale = 0.9,
		code = function(self)
			self:setstate(0)
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0)
			end
			
			local itemTyp,itemID,itemName,_,itemRewardEx = unpack(_temprewardTable[_currentpos])
			
			--判断是否是装备，如果是则产生随机孔数
			if itemTyp == "item" and hApi.CheckItemIsEquip(itemID) then
				local itemLv = hVar.tab_item[itemID].itemLv or 1
				local oItem = hApi.CreateItemObjectByID(itemID,itemRewardEx,nil,{hVar.ITEM_FROMWHAT_TYPE.TREASURE,_chest_id,_canRest})
				for i = 1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()) do
					if Save_PlayerData.bag[i] == 0 then
						Save_PlayerData.bag[i] = oItem
						if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
							LuaAddItemStatisticsLog(itemID,"A")
						end
						
						----保底机制数据
						--if _switch_baseline == 1 then
						--	if itemLv == 4 then
						--		LuaSetRollBaseLine(0)
						--	else
						--		LuaSetRollBaseLine(LuaGetRollBaseLine()+1)
						--	end
						--end

						LuaAddGetItemCount(itemLv,1)
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						hGlobal.event:event("Local_EventReflashPlayerBag")
						break
					end
				end
			end
			_frm:show(0,"appear")
			--SendCmdFunc["send_forged_finish"](luaGetplayerDataID(),2,_tradeid,tostring(itemID),4)
			SendCmdFunc["order_update"](_tradeid,2,tostring(itemID))
			_tradeid = 0
			for i = 1,#removeList do 
				hApi.safeRemoveT(_childUI,removeList[i])
			end
			removeList = {} 
			_selectN:setVisible(false)
			for i = 1,#_last_res_select do
				hApi.safeRemoveT(_childUI,_last_res_select[i][1])
				if _childUI["last_res_labe"..i] then
					_childUI["last_res_labe"..i]:setText("")
				end
			end
			_last_res_select = {}
			hApi.safeRemoveT(_childUI,"strengthen_eff")
			hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
			_childUI["dragBox"]:sortbutton()
			hGlobal.SceneEvent:continue(300)
		end,
	})
	
	
	--上次转得的道具
	for i = 1,2 do
		_last_resX[i] = _w/2+10 + i*100
		_last_resY[i] = -480

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
	_createLastResBtn = function(itemID, itemRewardEx)
		local index = #_last_res_select+1
		_childUI["last_res_btn_"..index] = hUI.button:new({
			parent = _parent,
			model = hApi.GetLootModel(_temprewardTable[_currentpos]),
			dragbox = _childUI["dragBox"],
			animation = hApi.GetLootAnimation(_temprewardTable[_currentpos]),
			x = _poslistX[_currentpos],
			y = _poslistY[_currentpos],
			w = 45,
			h = 45,
			code = function(self)
				if hVar.tab_item[itemID] and _cur_state == 0 then
					--_showRes(_last_res_select[index][3],8)
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

					
					hGlobal.event:event("LocalEvent_ShowItemTipFram",{{itemID,1,itemRewardEx}},nil,1)
				end
			end,
		})

		_last_res_select[index] = {"last_res_btn_"..index,itemID,_currentpos}
		local array = CCArray:create()

		if type(_last_resX[index]) == "number" and type(_last_resY[index]) == "number" then
			array:addObject(CCMoveTo:create(0.2,ccp(_last_resX[index], _last_resY[index])))
			array:addObject(CCCallFunc:create(_ActionOverOnLastRes)) 
			_childUI["last_res_btn_"..index].handle._n:runAction(CCSequence:create(array))
		end
	end

	--重转按钮
	_childUI["btnReset"] = hUI.button:new({
		parent = _frm,
		model = "UI:ButtonBack2",
		border = 1,
		label = hVar.tab_string["__TEXT_RestConfirm"],
		font = hVar.FONTC,
		scaleT = 0.9,
		scale = 0.9,
		x = _w/2 - 150,
		y = -_h + 40,
		code = function(self)
			self:setstate(0)
			_childUI["btnOK"]:setstate(0)
			if _canRest > 0 then
				_canRest = _canRest - 1
			end

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
			end

			--SendCmdFunc["buy_shopitem"](shopid,_restVal,name,0)
			SendCmdFunc["order_begin"](6,shopid,_restVal,1,name,0,0,nil)
		end,
	})

	hGlobal.event:listen("LocalEvent_BuyResetSucceed","__newEXFrmSucceed",function(order_id)
		
		if _frm.data.show == 0 then return end
		local _,id,_,_,itemRewardEx = unpack(_temprewardTable[_currentpos])
		if type(id) == "number" then
			if xlAppAnalysis then
				xlAppAnalysis("shop_golden_treasure_renew",0,1,"clientID",tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")))
			end
			_createLastResBtn(id,itemRewardEx)
		end

		if type(_createremove) == "function" then
			local r = hApi.random(1,8)
			_ActionIndex = _currentpos
			local is_show_Animation = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_Animation")
			if is_show_Animation == 1 or is_show_Animation == 0 then
				_createremove(r,0.08,4)
			else
				_createremove(r,0.05,1)
			end
		end
		SendCmdFunc["order_update"](_tradeid,2,tostring(id))
		_tradeid = order_id
	end)
	
	--创建道具表
	local _createRewardlist = function(rewardTable)
		for i = 1,#removeList do 
			hApi.safeRemoveT(_childUI,removeList[i])
		end
		removeList = {} 
		_temprewardTable = rewardTable
		for i = 1,8 do
			local typ,id,num,sHintEx,itemRewardEx = unpack(_temprewardTable[i])
			local itemLv = (hVar.tab_item[id].itemLv or 1)
			local bgmodel = hVar.ITEMLEVEL[itemLv].BACKMODEL
			local RGBValue = {0,0,0}
			if itemLv == 0 or itemLv == 1 then
				RGBValue = {255,255,255}
			elseif itemLv == 2 then
				RGBValue = {117,141,240}
			elseif itemLv == 3 then
				RGBValue = {213,173,65}
			elseif itemLv == 4 then
				RGBValue = {255,0,0}
			end
			--道具名字
			_childUI["Name"..i] = hUI.label:new({
				parent = _parent,
				text = "",
				x = _poslistX[i],
				y = _poslistY[i]-54,
				width = 400,
				align = "MC",
				size = 24,
				RGB = RGBValue,
				font = hVar.FONTC,
				border = 1,
			})
			removeList[#removeList+1] = "Name"..i
			if type(sHintEx)=="string" then
				_childUI["Name"..i]:setText(tostring(sHintEx))
			else
				_childUI["Name"..i]:setText(tostring(num))
			end

			--获取奖励类型资源或者是道具，奖励的具体类型，奖励的数值多少
			_childUI["res_"..i] = hUI.button:new({
				parent = _parent,
				model = hApi.GetLootModel(_temprewardTable[i]),
				dragbox = _childUI["dragBox"],
				animation = hApi.GetLootAnimation(_temprewardTable[i]),
				x = _poslistX[i],
				y = _poslistY[i],
				w = 45,
				h = 45,
				code = function(self)
					--显示道具提示
					if typ=="item" then
						local tempX = 0
						--在左边显示
						if math.ceil(i/3) % 2 == 0 then
							tempX = _x - 470
						--在右边显示
						elseif math.ceil(i/3) % 2 == 1 then
							tempX = _x + 200
						end
						if hVar.tab_item[id] then
							hGlobal.event:event("LocalEvent_ShowItemTipFram",{{id,1,itemRewardEx}},nil,1,tempX,_y+300)
						end
					end
				end,
			})
			removeList[#removeList+1] = "res_"..i

			--在中间的位置创建8个图片，实现滚动显示效果
			_childUI["Centrality"..i] = hUI.image:new({
				parent = _parent,
				model = hApi.GetLootModel(_temprewardTable[i]),
				align = "MC",
				x = _w/2,
				y = -_h/2 + 60,
			})

			--背景
			hUI.deleteUIObject(hUI.image:new({
				parent = _childUI["Centrality"..i].handle._n,
				model = bgmodel,
				w = 64,
				h = 64,
				x = 32,
				y = 31,
				z = -1,
				alpha = 100,
			}))

			_childUI["Centrality"..i].handle._n:setVisible(false)
			_childUI["Centrality1"].handle._n:setVisible(true)
			removeList[#removeList+1] = "Centrality"..i
		end
	end
	
	--选中框
	_childUI["SelectBorder"]= hUI.image:new({
		parent = _parent,
		mode = "image",
		model = "UI:Button_SelectBorder",
		align = "MC",
		w = 60,
		x = _poslistX[1],
		y = _poslistY[1],
	})
	_selectN = _childUI["SelectBorder"].handle._n
	_childUI["SelectBorder"].handle.s:setOpacity(0)
	_selectN:setVisible(false)
	
	local nnn = nil
	local decal,count = 11,0
	local r,g,b,parent = 150,128,64,_selectN
	local offsetX,offsetY,duration,scale = 35,36,0.7,1.1
	nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
	nnn:setScale(3.4)

	--vip相关
	for i = 1,8 do
		_childUI["vip_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:vip"..i,
			x = 150,
			y = -500,
			scale = 0.8,
		})
		_childUI["vip_"..i].handle._n:setVisible(false)
	end
	
	--游戏币图标
	_childUI["game_coins_image"] = hUI.image:new({
		parent = _parent,
		model = "UI:game_coins",
		x = 100,
		y = -500,
		scale = 0.9,
	})

	--游戏币lab
	_childUI["Account_Balance2"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 135,
		y = -500,
		width = 500,
		border = 1,
		text = "",
	})
	
	_childUI["game_coins_image_info"] = hUI.image:new({
		parent = _parent,
		model = "UI:game_coins",
		x = 240,
		y = -558,
		scale = 0.8,
	})

	--重转消耗游戏币的提示
	_childUI["Account_Balance_info"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "LT",
		x = 265,
		y = -552,
		width = 500,
		border = 1,
		text = "",
	})

	hGlobal.event:listen("localEvent_ShowRewardExFrm","showfrm",function(rewardTable,Resetcount,ResetVal,chest_id,tradeid)
		_canRest = Resetcount
		_chest_id = chest_id
		_tradeid = tradeid
		_cur_rmb = 0
		--------------------------------------------------------------------------------------------------------------------------
		for i = 1,8 do
			_childUI["vip_"..i].handle._n:setVisible(false)
		end

		if  LuaGetPlayerVipLv() > 3 then
			_restVal = 0
			_childUI["vip_"..LuaGetPlayerVipLv()].handle._n:setVisible(true)
		else
			_restVal = ResetVal
		end
		_childUI["Account_Balance_info"]:setText(tostring("x ".._restVal))



		--------------------------------------------------------------------------------------------------------------------------
		local tempTable = {}
		for i = 1,#rewardTable do
			local itemTyp = rewardTable[i][1]
			local itemID = rewardTable[i][2]
			local itemName = rewardTable[i][3]
			local sHintEx = rewardTable[i][4]
			local exValueRatio = rewardTable[i][5] or 0
			local rewardEx

			--生成道具扩展属性
			local tabI = hVar.tab_item[itemID]
			local itemLv = tabI.itemLv or hVar.ITEM_QUALITY.WHITE
			local itemValue = tabI.itemValue or 1

			if exValueRatio and exValueRatio > 0 and tabI.type >= hVar.ITEM_TYPE.HEAD and tabI.type <= hVar.ITEM_TYPE.FOOT then
				rewardEx = hApi.CreateItemAttrEx(itemLv, itemValue, exValueRatio or 0)
			end
			
			--转换积分数据项
			tempTable[i] = {rewardTable[i][1],rewardTable[i][2],rewardTable[i][3],rewardTable[i][4],rewardEx}
			if rewardTable[i][1] == "score" and rewardTable[i][2] == "random" and type(rewardTable[i][3]) == "table" then
				--产生随机积分
				local r = hApi.random(rewardTable[i][3][1],rewardTable[i][3][2])
				tempTable[i]  = {"score","random",r}
			end
		end
		
		_createRewardlist(tempTable)
		--------------------------------------------------------------------------------------------------------------------------
		
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
			_childUI["btnOK"]:setXY(_w/2,-_h + 40)
			_childUI["btnReset"]:setstate(-1)
		else
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
			_childUI["btnOK"]:setXY(_w/2 + 160,-_h + 40)
			_childUI["btnReset"]:setstate(0)
		end
		_childUI["btnOK"]:setstate(0)
		
		local r = hApi.random(1,8)
		---- 保底机制
		--local baseline = LuaGetRollBaseLine()
		--if baseline > 50 then
		--	local rlist = {}
		--	local resType,resTypeEx,resValue
		--	for i = 1,#rewardTable do
		--		resType,resTypeEx,resValue = unpack(rewardTable[i])
		--		if resType == "item" and hVar.tab_item[resTypeEx].itemLv == 4 then
		--			rlist[#rlist+1] = i
		--			LuaSetRollBaseLine(0)
		--		end
		--	end
		--	if #rlist > 0 then
		--		r = rlist[hApi.random(1,#rlist)]
		--	end
		--else
		--	if _switch_baseline == 1 and baseline == 40 then
		--		--如果保底技术达到40则 上传一次记录
		--		xlAppAnalysis("baseline_reward",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."name:"..tostring(g_curPlayerName).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--	end
		--end

		--根据网络状态显示不同的标记
		if g_cur_net_state == 1 then
			--_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result2"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText("..")
			_childUI["connect_result1"].handle._n:setVisible(true)
		elseif g_cur_net_state == -1 then
			--_childUI["connect_result2"].handle._n:setVisible(false)
			--_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText(".")
			_childUI["connect_result1"].handle._n:setVisible(false)
		end
		
		
		if _currentpos == 0 then
			_currentpos = 1
		end
		_ActionIndex = _currentpos

		local is_show_Animation = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_Animation")
		if is_show_Animation == 1 or is_show_Animation == 0 then
			_childUI["selectbox_finish"].handle._n:setVisible(false)
			_createremove(r,0.08,4)
		else
			_childUI["selectbox_finish"].handle._n:setVisible(true)
			_createremove(r,0.05,1)
		end

		_frm:show(1)
		_frm:active()
	end)

	--根据网络状态设置网络状态 图标
	hGlobal.event:listen("LocalEvent_Set_activity_refresh","setconnectstate2",function(connect_state)
		if connect_state == 1 then
			--_childUI["connect_result1"].handle._n:setVisible(false)
			--_childUI["connect_result2"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText("..")
			_childUI["connect_result1"].handle._n:setVisible(true)
		elseif connect_state == -1 then
			--_childUI["connect_result2"].handle._n:setVisible(false)
			--_childUI["connect_result1"].handle._n:setVisible(true)
			--_childUI["connect_result_lab"]:setText(".")
			_childUI["connect_result1"].handle._n:setVisible(false)
		end
	end)

	hGlobal.event:listen("LocalEvent_SetCurGameCoin","newsetgamecoin3",function(cur_rmb)
		--只有当前界面打开时 才能进行判断
		if type(cur_rmb) == "number" then
			_cur_rmb = cur_rmb
			if _cur_rmb >= _restVal and _cur_rmb > 0 and _canRest ~= 0 and _cur_state == 0 then
				_childUI["btnReset"]:setstate(1) 
			end
		else
			if _childUI["btnReset"].data.state ~= -1 then
				_childUI["btnReset"]:setstate(0) 
			end
		end
		_childUI["Account_Balance2"]:setText(tostring(cur_rmb))
	end)
	
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","mewPhone_setcurgamecoin_991",function(cur_rmb) 
		--只有当前界面打开时 才能进行判断
		if type(cur_rmb) == "number" then
			_cur_rmb = cur_rmb
			if _cur_rmb >= _restVal and _cur_rmb > 0 and _canRest ~= 0 and _cur_state == 0 then
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