--手机版的玩家信息面板
hGlobal.UI.InitGameCoinFrm = function()
	local _x, _y = hVar.SCREEN.w - 450, hVar.SCREEN.h
	hGlobal.UI.GameCoinFrm  = hUI.frame:new({
		x = _x,
		y = _y,
		w = 365,
		h = 46,
		background = -1,
		dragable = 0,
		show = 0,
		z = 500,
	})
	
	local _frm = hGlobal.UI.GameCoinFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	local _energy = 0
	
	local _GameCoinOffX = -140
	local _GameCoinOffY = 0
	if (g_phone_mode ~= 0) then --手机模式
		_GameCoinOffX = -140
		_GameCoinOffY = 5
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			_GameCoinOffX = -140
			_GameCoinOffY = 5
		end
	end
	
	--底纹背景
	_childUI["selectbg"] = hUI.bar:new({
		parent = _parent,
		model = "UI:selectbg2",
		x = 215 + _GameCoinOffX,
		y = -28 + _GameCoinOffY,
		--w = 410,
		w = 480,
		h = 38,
	})
	
	--游戏币图片
	_childUI["game_coins_image"] = hUI.image:new({
		model = "UI:game_coins",
		parent = _parent,
		x = 20 + _GameCoinOffX,
		y = -28 + _GameCoinOffY,
		scale = 0.8,
	})
	_childUI["game_coins_Lab"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		x = 40 + _GameCoinOffX,
		y = -13 + _GameCoinOffY,
		width = 540,
		text = "0",
		border = 1,
	})
	
	--玩家积分
	_childUI["PlayScore_image"] = hUI.image:new({
		model = "UI:score",
		parent = _parent,
		x = 170 + _GameCoinOffX,
		y = -28 + _GameCoinOffY,
		scale = 0.5,
	})
	_childUI["PlayScore_Lab"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		x = 200 + _GameCoinOffX,
		y = -13 + _GameCoinOffY,
		width = 540,
		text = "0",
		border = 1,
	})

--	--符石
--	_childUI["FstoneIcon_image"] = hUI.image:new({
--		--model = "UI:rsdyz_point",
--		model = "UI:ach_lightning",
--		parent = _parent,
--		x = 310,
--		y = -28,
--		scale = 0.65,
--	})
--	_childUI["FstoneIcon_Lab"] = hUI.label:new({
--		parent = _parent,
--		size = 28,
--		align = "LT",
--		x = 330,
--		y = -13,
--		width = 540,
--		text = tostring(_energy),
--		border = 1,
--	})
	
	
	--刷新游戏币
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","__GameCoinFrm__UpdateGameCoin",function(cur_rmb) 
		--从服务器获得游戏币后 显示
		if type(cur_rmb) == "number" then
			local s = tostring(cur_rmb)
			if _childUI["game_coins_Lab"].data.text~=s then
				_childUI["game_coins_Lab"]:setText(s,1)
				if _frm.data.show==1 then
					_childUI["game_coins_image"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
				end
			end
		else
			_childUI["game_coins_Lab"]:setText("...",1)
		end
	end)

	--刷新积分
	hGlobal.event:listen("LocalEvent_SetCurGameScore","__GameCoinFrm__UpdateGameScore",function()
		local s = tostring(LuaGetPlayerScore())
		if s~=_childUI["PlayScore_Lab"].data.text then
			_childUI["PlayScore_Lab"]:setText(s,1)
			if _frm.data.show==1 then
				_childUI["PlayScore_image"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,0.8,0.8),CCScaleTo:create(0.08,0.5,0.5)))
			end
		end
	end)

	--刷新符石
	--hGlobal.event:event("LocalEvent_SetCurFstoneNum",cur_num)
	--hGlobal.event:listen("LocalEvent_SetCurFstoneNum","__GameCoinFrm__UpdateGameCoin",function(cur_num) 
		----从服务器获得游戏币后 显示
		--if type(cur_num) == "number" then
			--local s = tostring(cur_num)
			--if _childUI["FstoneIcon_Lab"].data.text~=s then
				--_childUI["FstoneIcon_Lab"]:setText(s,1)
				--if _frm.data.show==1 then
					--_childUI["FstoneIcon_image"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
				--end
			--end
		--else
			--_childUI["FstoneIcon_Lab"]:setText("...",1)
		--end
	--end)

--	--获取当前key回调
--	hGlobal.event:listen("LocalEvent_GetEnergy_Success", "__GameCoinFrm_get_energy", function(cur_num)
--		----从服务器获得游戏币后 显示
--		if type(cur_num) == "number" then
--			if _energy~=cur_num then
--				_childUI["FstoneIcon_Lab"]:setText(cur_num,1)
--				_energy = cur_num
--				if _frm.data.show==1 then
--					_childUI["FstoneIcon_image"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
--				end
--			end
--		else
--			_childUI["FstoneIcon_Lab"]:setText("...",1)
--			_energy = 0
--		end
--	end)
--
--	--设置key回调
--	hGlobal.event:listen("LocalEvent_SetEnergy_Return", "__GameCoinFrm_set_energy", function(iErrCode, key)
--		if iErrCode == 0 and key == "energy" then
--			if _energy > 0 then
--				_energy = _energy - 1
--				_childUI["FstoneIcon_Lab"]:setText(_energy,1)
--				if _frm.data.show==1 then
--					_childUI["FstoneIcon_image"].handle._n:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.08,1.2,1.2),CCScaleTo:create(0.08,0.9,0.9)))
--				end
--			end
--		end
--	end)
	
	hGlobal.event:listen("LocalEvent_ShowGameCoinFrm","__ShowGameCoinFrm",function(mode)
		SendCmdFunc["gamecoin"]()
		_childUI["PlayScore_Lab"]:setText(tostring(LuaGetPlayerScore()),1)
		_childUI["selectbg"].handle.s:setVisible(true) --显示背景
		
		if mode == "lobby" or mode == nil then
			--_childUI["selectbg"].handle._n:setVisible(true)
			_frm:setXY(_x,_y)
		elseif mode == "game" then
			--_childUI["selectbg"].handle._n:setVisible(false)
			if g_phone_mode == 0 then
				_frm:setXY(_x-90,_y-154)
			elseif g_phone_mode == 2 then
				_frm:setXY(_x-150,_y-90)
			elseif g_phone_mode == 1 then
				_frm:setXY(_x-110,_y-90)
			elseif g_phone_mode == 3 then
				_frm:setXY(_x-210,_y-130)
			end
		elseif (mode == "gameherocard") then
			--_childUI["selectbg"].handle._n:setVisible(true)
			_frm:setXY(140,_y)
		elseif (mode == "fullscreen") then
			_childUI["selectbg"].handle.s:setVisible(false) --隐藏背景
			_frm:setXY(_x + 210, _y)
		end
		--_frm:show(1)
	end)

	hGlobal.event:listen("LocalEvent_CloseGameCoinFrm","__ShowGameCoinFrm",function()
		_frm:show(0)
	end)
	
	--有切换场景 就隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideGameCoinFrm",function(sSceneType,oWorld,oMap)
		_frm:show(0)
	end)
end