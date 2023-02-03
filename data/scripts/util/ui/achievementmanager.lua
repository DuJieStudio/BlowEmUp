hGlobal.UI.InitAchievementSummaryFrm_Diablo = function(mode)
	local tInitEventName = {"LocalEvent_ShowAchievementSummaryFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _MoveW = 500
	--local _FrmWidth = 640
	--local _FrmHeight = 420
	local _FrmWidth = 1120
	local _FrmHeight = 640
	local _imageOffx = 5
	local _imageOffy = -26
	local _AchBgWidth = 920
	local _AchBgHeight = 500
	local _bCanCreate = true
	local iPhoneX_WIDTH = hVar.SCREEN.offx
	local current_is_in_action = true

	local _frm
	local _parent
	local _childUI

	local _boardScale = 1
	if g_phone_mode == 2 then
		_boardScale = 0.9
	elseif g_phone_mode == 1 then
		_boardScale = 0.76
	elseif g_phone_mode == 0 then
		_boardScale = 0.85
	end
	_FrmWidth = math.floor(_FrmWidth * _boardScale)
	_FrmHeight = math.floor(_FrmHeight * _boardScale)
	_AchBgWidth = math.floor(_AchBgWidth * _boardScale)
	_AchBgHeight = math.floor(_AchBgHeight * _boardScale)

	local OnCreateAchievementSummaryFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local OnMoveFrmAction = hApi.DoNothing
	local OnClickAchievementInfo = hApi.DoNothing

	local _achBtnList = {
		[1] = {
			--图片按钮
			model = "misc/achievements/ach1.png",	--图片
			offx = - _AchBgWidth/4 + 24 * _boardScale,	--x偏移
			offy = _AchBgHeight/4 - 18 * _boardScale,		--y偏移
			width = 464 * _boardScale,			--宽
			height = 246 * _boardScale,			--高
			code = function()			--按钮函数
				OnLeaveFunc()
				hGlobal.event:event("LocalEvent_Phone_ShowBillboardInfoFrm")
			end,
			--图片长条
			bartext = "clearance",	--文字
			bar = "misc/achievements/ach1_bar.png",	--条图片
			baroffx = -32,				--条x偏移
			baroffy = 24,				--条y偏移
			medaloffx = - 68,			--勋章x偏移
		},
		[2] = {
			model = "misc/achievements/ach2.png",
			offx = _AchBgWidth/4 - 24 * _boardScale,
			offy = _AchBgHeight/4 - 18 * _boardScale,
			width = 474 * _boardScale,
			height = 246 * _boardScale,
			code = function()
				OnLeaveFunc()
				hGlobal.event:event("LocalEvent_ShowAchievementRankFrm")
			end,
			bartext = "batter",
			bar = "misc/achievements/ach2_bar.png",
			baroffx = 1,
			baroffy = 24,
		},
		[3] = {
			model = "misc/achievements/ach3.png",
			offx = - _AchBgWidth/4 - 54 * _boardScale,
			offy = -_AchBgHeight/4 - 3 * _boardScale,
			width = 308 * _boardScale,
			height = 200 * _boardScale,
			code = function()
				hGlobal.event:event("LocalEvent_ShowAchievementInfoByType",hVar.AchievementType.MAXPET)
				--OnClickAchievementInfo(hVar.AchievementType.MAXPET)
			end,
			bartext = "pet",
			bar = "misc/achievements/ach3_bar.png",
			baroffx = -25,
			baroffy = 22,
			medaloffx = - 54,
		},
		[4] = {
			model = "misc/achievements/ach4.png",
			offx = -10 * _boardScale,
			offy = -_AchBgHeight/4 - 3 * _boardScale,
			width = 340 * _boardScale,
			height = 200 * _boardScale,
			code = function()
				hGlobal.event:event("LocalEvent_ShowAchievementInfoByType",hVar.AchievementType.ROLLING)
				--OnClickAchievementInfo(hVar.AchievementType.ROLLING)
			end,
			bartext = "rolling",
			bar = "misc/achievements/ach4_bar.png",
			baroffx = -23,
			baroffy = 22,
			medaloffx = - 54,
		},
		[5] = {
			model = "misc/achievements/ach5.png",
			offx = _AchBgWidth/4 + 48 * _boardScale,
			offy = -_AchBgHeight/4 - 3 * _boardScale,
			width = 332 * _boardScale,
			height = 200 * _boardScale,
			code = function()
				hGlobal.event:event("LocalEvent_ShowAchievementInfoByType",hVar.AchievementType.ONEPASS)
				--OnClickAchievementInfo(hVar.AchievementType.ONEPASS)
			end,
			bartext = "onepass",
			bar = "misc/achievements/ach5_bar.png",
			baroffx = 1,
			baroffy = 22,
		},
	}

	OnClickAchievementInfo = function(nAchievementType)
		--local tRatingCriteria = hVar.AchievementRatingCriteria[nAchievementType]
		--if type(tRatingCriteria) == "table" then
			--local tBtnData = _achBtnList[nAchievementType]
			--local offX = hVar.SCREEN.w/2
			--local offY = hVar.SCREEN.h/2
			--local offScale = 1
			--_childUI["btn_ach_info"..nAchievementType] = hUI.button:new({
				--parent = _parent,
				--dragbox = _childUI["dragBox"],
				--model = tBtnData.model,
				--x = offX + _imageOffx + tBtnData.offx,
				--y = offY + _imageOffy + tBtnData.offy,
				--w = tBtnData.width * offScale,
				--h = tBtnData.height * offScale,
				--code = function()
					--hApi.safeRemoveT(_childUI,"btn_ach_info"..nAchievementType)
				--end,
			--})
			--_childUI["btn_ach_info"..nAchievementType].handle.s:setColor(ccc3(30,30,30))

			--local tCriteria = tRatingCriteria.criteria
			--if type(tCriteria) == "table" then
				--local nodeChild = _childUI["btn_ach_info"..nAchievementType].childUI
				--local nodeParent = _childUI["btn_ach_info"..nAchievementType].handle._n

				--local deltaH = 60
				--for i = 1,#tCriteria do
					--nodeChild["img_medal_bg"..i]= hUI.image:new({
						--parent = nodeParent,
						--x = - tBtnData.width/2 + 30, 
						--y = -tBtnData.height/2 + 40 + deltaH * (i - 1),
						--model = "misc/achievements/medal_bg.png",
						--align = "MC",
						----scale = 0.9,
					--})
					----nodeChild["img_medal_bg"..i].handle._n:setPercentage(50)

					--nodeChild["img_medal"..i] = hUI.image:new({
						--parent = nodeParent,
						--x = - tBtnData.width/2 + 30, 
						--y = -tBtnData.height/2 + 40 + deltaH * (i - 1),
						--model = hApi.GetRatingModel(nAchievementType,i),
						--align = "MC",
						----scale = 0.9,
					--})

					--nodeChild["lab_criteria"..i] = hUI.label:new({
						--parent = nodeParent,
						--x = - tBtnData.width/2 + 70, 
						--y = -tBtnData.height/2 + 40 + deltaH * (i - 1) + 2,
						--align = "LC",
						--size = 20,
						--border = 0,
						--font = hVar.FONTC,
						--text = (tCriteria[i] or {})[1],
					--})
					
				--end
				----
			--end
		--end
	end

	OnMoveFrmAction = function(nMoveX,nDeltyTime)
		if _frm then
			local newX,nexY =_frm.data.x + nMoveX,_frm.data.y
			local moveto = CCMoveTo:create(nDeltyTime,ccp(newX,nexY))
			local callback = CCCallFunc:create(function()
				current_is_in_action = false
				_frm:setXY(newX,nexY)
			end)
			local a = CCArray:create()
			a:addObject(moveto)
			a:addObject(callback)
			local sequence = CCSequence:create(a)
			_frm.handle._n:runAction(sequence)
		end
	end

	OnCreateAchievementSummaryFrm = function()
		if hGlobal.UI.AchievementSummaryFrm then
			hGlobal.UI.AchievementSummaryFrm:del()
			hGlobal.UI.AchievementSummaryFrm = nil
		end
		hGlobal.UI.AchievementSummaryFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.AchievementSummaryFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI


		--local offX = hVar.SCREEN.w - _FrmWidth/2 - 6 - iPhoneX_WIDTH
		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2

		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/billboard/msgbox5.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = _FrmWidth,
			h = _FrmHeight,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		_childUI["Btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _FrmWidth/2 - math.floor(48* _boardScale),
			y = offY + _FrmHeight/2 - math.floor(46 * _boardScale),
			scale = 1.2* _boardScale,
			scaleT = 0.95,
			code = function()
				OnLeaveFunc()
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n

		--"data/image/misc/achievements/ach_bg.png"
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", _imageOffx, _imageOffy, _AchBgWidth, _AchBgHeight, _childUI["ItemBG_1"])

		btnChild["lab_name"] = hUI.label:new({
			parent = btnParent,
			x = 0,
			y = _FrmHeight/2 - 48,
			align = "MC",
			size = 32,
			border = 0,
			font = hVar.FONTC,
			text = hVar.tab_string["achievement"],
		})

		local offScale = 1
		for i = 1,#_achBtnList do
			local tBtnData = _achBtnList[i]
			_childUI["btn_ach"..i] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = tBtnData.model,
				x = offX + _imageOffx + tBtnData.offx,
				y = offY + _imageOffy + tBtnData.offy,
				w = tBtnData.width * offScale,
				h = tBtnData.height * offScale,
				scaleT = 0.98,
				code = tBtnData.code,
			})

			_childUI["btn_ach"..i].childUI["bar"] = hUI.image:new({
				parent = _childUI["btn_ach"..i].handle._n,
				model = tBtnData.bar,
				scale = offScale * _boardScale,
				x = 0 + (tBtnData.baroffx or 0) * _boardScale,
				y = -tBtnData.height/2 * offScale + (tBtnData.baroffy or 0) * _boardScale,
			})
			--_childUI["btn_ach"..i].childUI["bar"].handle.s:setColor(ccc3(100,100,100))

			local textSize = 22
			if g_Cur_Language == 3 then
				textSize = 18
			elseif g_Cur_Language == 4 then
				textSize = 24
			end

			_childUI["btn_ach"..i].childUI["text"] = hUI.label:new({
				parent = _childUI["btn_ach"..i].handle._n,
				x = -tBtnData.width/2 * offScale + 24,
				y = -tBtnData.height/2 * offScale + (tBtnData.baroffy or 0) * _boardScale + 3,
				align = "LC",
				size = math.floor(textSize * offScale * _boardScale),
				border = 0,
				font = hVar.FONTC,
				text = hVar.tab_string[tBtnData.bartext],
			})

			local medaltab = {
				[1] = "misc/achievements/medal_gold.png",
				[2] = "misc/achievements/medal_silver.png",
				[3] = "misc/achievements/medal_copper.png",
			}

			for j = 1,3 do
				_childUI["btn_ach"..i].childUI["medal_bg"..j] = hUI.image:new({
					parent = _childUI["btn_ach"..i].handle._n,
					model = "misc/achievements/medal_bg.png",
					scale = offScale * _boardScale,
					x = tBtnData.width/2 * offScale - 28 * _boardScale + (tBtnData.medaloffx or 0) - (j -1) * 36 * offScale * _boardScale,
					y = -tBtnData.height/2 * offScale + (tBtnData.baroffy or 0) * _boardScale,
				})

				_childUI["btn_ach"..i].childUI["medal"..j] = hUI.image:new({
					parent = _childUI["btn_ach"..i].handle._n,
					model = medaltab[j],
					scale = offScale * _boardScale,
					x = tBtnData.width/2 * offScale - 28 * _boardScale + (tBtnData.medaloffx or 0) - (j -1) * 36 * offScale * _boardScale,
					y = -tBtnData.height/2 * offScale + (tBtnData.baroffy or 0) * _boardScale,
				})
			end

			

			--local num = math.random(1,4)
			--if medaltab[num] then
				--_childUI["btn_ach"..i].childUI["medal"] = hUI.image:new({
					--parent = _childUI["btn_ach"..i].handle._n,
					--model = medaltab[num],
					--x = tBtnData.width/2 - 24  + (tBtnData.baroffx or 0) * 2,
					--y = -tBtnData.height/2 + 16,
				--})
			--end
			--_childUI["btn_ach"..i].handle._n:setScale(_boardScale)
		end

		--_frm:setXY(_frm.data.x + _MoveW,_frm.data.y)

		_frm:show(1)
		_frm:active()
		--OnMoveFrmAction(-_MoveW,0.5)
	end

	OnLeaveFunc = function()
		if hGlobal.UI.AchievementSummaryFrm then
			hGlobal.UI.AchievementSummaryFrm:del()
			hGlobal.UI.AchievementSummaryFrm = nil
		end
		_bCanCreate = true
		current_is_in_action = true

		_frm = nil
		_parent = nil
		_childUI = nil
	end

	hGlobal.event:listen("HideAchievementSummaryFrm","clearfrm",function(show)
		if _frm then
			_frm:show(show)
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		OnLeaveFunc()
		--界面未打开 可创建
		if _bCanCreate then
			_bCanCreate = false
			OnCreateAchievementSummaryFrm()
		end
	end)
end

hGlobal.UI.InitAchievementRank_Diablo = function(mode)
	local tInitEventName = {"LocalEvent_ShowAchievementRankFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _frm,_parent,_childUI
	local _clipNode
	local _boardScale = 1
	local _boardW,_boardH = 1200,660
	local _rankInfoW,_rankInfoH = 1040,100
	--最多显示50个(即就算排行榜300 但界面上只显示50个 等拖动后判断 快到边缘时 删除部分控件 然后重新创建)
	local _maxshowLine = 50
	--刷新限制为10 即如果向一个方向拖动 若存在的控件少于该数  那么就算达到边缘
	local _refreshLimit = 10
	local _frmScale = 1
	if g_phone_mode == 2 then
		_frmScale = 0.9
	end
	local _gridWH = {_rankInfoW,_rankInfoH+2}
	local _cliprect = {(hVar.SCREEN.w - _rankInfoW)/2,-132,_rankInfoW + 10,510,0}
	local _gridrect = {}

	local _asyncCreateList = {}
	local _canDrag = false

	local _boardScale = 1
	local _clipScale = 1
	if g_phone_mode == 2 then
		_boardScale = 0.9
		_clipScale = 0.9
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-112,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	elseif g_phone_mode == 1 then
		_boardScale = 0.76
		_clipScale = 0.75
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-148,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	elseif g_phone_mode == 0 then
		_boardScale = 0.85
		_clipScale = 0.85
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-188,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	end

	local _CODE_CreateAchievementRankFrm = hApi.DoNothing
	local _CODE_ChangePage = hApi.DoNothing				--切换分页
	local _CODE_CreatePageInfo = hApi.DoNothing
	local _CODE_CreateRankInfo = hApi.DoNothing			--创建排行信息
	local _CODE_CreateMyRankInfo = hApi.DoNothing			--创建我的排名信息
	local _CODE_ClearFunc = hApi.DoNothing				--清理函数

	local _CODE_AutoLign = hApi.DoNothing				--自动对齐
	local _CODE_OnPageDrag = hApi.DoNothing				--拖动事件
	local _CODE_OnInfoUp = hApi.DoNothing				--放开事件

	local on_receive_billobard_info_Back = hApi.DoNothing
	local refresh_async_paint_billboard_loop = hApi.DoNothing
	local refresh_query_billboard_timeout_timer = hApi.DoNothing

	_CODE_ClearFunc = function()
		--去除事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_TankBillboardData", "__getAchievementRankData", nil)
		hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		hApi.clearTimer("__TANK_BILLBOARD_ASYNC__")
		if hGlobal.UI.PhoneAchievementRankFrm then
			hGlobal.UI.PhoneAchievementRankFrm:del()
			hGlobal.UI.PhoneAchievementRankFrm = nil
		end
		_frm = nil
		_parent = nil
		_childUI = nil
		_clipNode = nil
		_canDrag = false
		_gridrect = {}
		_asyncCreateList = {}
		
		--释放png, plist的纹理缓存
		hApi.ReleasePngTextureCache()
	end

	_CODE_CreateAchievementRankFrm = function()
		if hGlobal.UI.PhoneAchievementRankFrm then
			hGlobal.UI.PhoneAchievementRankFrm:del()
			hGlobal.UI.PhoneAchievementRankFrm = nil
		end
		hGlobal.UI.PhoneAchievementRankFrm = hUI.frame:new(
		{
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			dragable = 2,
			show = 0, --一开始不显示
			border = -1,
			background = -1,
			autoactive = 0,
			
			--点击事件
			codeOnTouch = function(self, x, y, sus)
				if _canDrag then
					if hApi.IsInBox(x, y, _cliprect) then
						local pama = {state = 0}
						self:pick("clipnode",_dragrect,tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama},1)
					end
				end
			end,
		})

		_frm = hGlobal.UI.PhoneAchievementRankFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["Img_rankboard_bg"] = hUI.button:new({
			parent = _parent,
			model = "misc/billboard/msgbox5.png",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = _boardW,
			h = _boardH,
			--scale = _boardScale,
		})

		_childUI["Btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = hVar.SCREEN.w/2 + _boardW/2 - math.floor(48* _boardScale),
			y = -hVar.SCREEN.h/2 + _boardH/2 - math.floor(46 * _boardScale),
			scale = 1.2* _boardScale,
			scaleT = 0.95,
			code = function()
				_CODE_ClearFunc()
				hGlobal.event:event("LocalEvent_ShowAchievementSummaryFrm")
			end,
		})

		local titleX = (hVar.SCREEN.w - _boardW) / 2 + 140
		local titleY = -hVar.SCREEN.h/2 + _boardH/2 - math.floor(61 * _boardScale)
		
		--标题-我的排名
		_childUI["DLCMapInfoTitle_MyRank"] = hUI.label:new({
			parent = _parent,
			x = titleX, 
			y = titleY + 2,
			font = hVar.FONTC,
			size = math.floor(26),
			align = "LC",
			text = hVar.tab_string["rank"],
			border = 1,
			RGB = {212, 255, 212,},
		})

		--底框
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", _cliprect[1] + _cliprect[3]/2, _cliprect[2] -_cliprect[4]/2, _cliprect[3]+6, _cliprect[4]+6, _frm)
		
		--创建文本，提示连接超时
		_childUI["lab_ConnectTimeOut"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2 - 20,
			font = hVar.FONTC,
			size = math.floor(28 * _boardScale),
			align = "MC",
			text = "CONNECT TIME OUT !",
			--border = 1,
			RGB = {192, 192, 192,},
		})
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(false)

		_clipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])

		_frm:show(1)
		_frm:active()
	end

	_CODE_ChangePage = function(nIndex)
		hApi.safeRemoveT(_childUI,"clipnode")
		_CODE_CreatePageInfo()
		local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_CONTINOUSKILL --连杀排行榜
		local diff = nIndex - 1
		SendCmdFunc["query_tank_billboard"](bId, diff)

		--添加查询超时一次性timer
		hApi.addTimerOnce("__TANK_QUERY_TIMEOUNT_TIMER__", 5000, refresh_query_billboard_timeout_timer)

		hApi.addTimerForever("__TANK_BILLBOARD_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_billboard_loop)
	end

	_CODE_CreatePageInfo = function()
		_childUI["clipnode"] = hUI.node:new({
			parent = _clipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		
		_childUI["clipnode"].handle._n:setScale(_clipScale)
		--local _NodeParent = _childUI["clipnode"].handle._n
		--local _NodeChild =  _childUI["clipnode"].childUI
	end

	--创建排行信息
	_CODE_CreateRankInfo = function(billboard, index, rankMe)
		local rank = billboard.rank or index --排名
		local name = billboard.name or "USER" --玩家名
		local stage = billboard.stage or 0 --关卡进度
		local tankId = billboard.tankId or 6000 --坦克id
		local weaponId = billboard.weaponId or 6013 --武器id
		local gametime = billboard.gametime or 0 --通关时间
		local scientistNum = billboard.scientistNum or 0 --科学家数量
		local goldNum = billboard.goldNum or 0 --金币数量
		local killNum = billboard.killNum or 0  --连杀
		
		local offY = 0
		
		hApi.safeRemoveT(_childUI["clipnode"].childUI,"node"..index)
		_childUI["clipnode"].childUI["node"..index] = hUI.button:new({
			parent = _childUI["clipnode"].handle._n,
			model = "misc/button_null.png",
			x = 0,
			y = (- _rankInfoH  - 2) * (index - 0.5),
		})
		
		local _NodeParent = _childUI["clipnode"].childUI["node"..index].handle._n
		local _NodeChild =  _childUI["clipnode"].childUI["node"..index].childUI
		
		--[[
		--背景
		_NodeChild["Img_rankbg_" .. index] = hUI.image:new({
			parent = _NodeParent,
			model = "misc/billboard/kuang8.png",
			x = _rankInfoW/2 + 5,
			y = offY,
			z = 1,
			w = _rankInfoW,
			h = _rankInfoH - 4,
		})
		]]
		
		
		--排行的字体大小
		local rankFontSize = 24
		if (rank == 1) then --第1名
			rankFontSize = 32
		elseif (rank == 2) then --第2名
			rankFontSize = 30
		elseif (rank == 3) then --第3名
			rankFontSize = 28
		elseif (rank >= 4) and (rank <= 9) then --第4-9名
			rankFontSize = 26
		elseif (rank >= 10) and (rank <= 99) then --第10-99名
			rankFontSize = 24
		elseif (rank >= 100) then --第100+名
			rankFontSize = 20
		end
		
		--排名值
		_NodeChild["lab_rankNO" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 52,
			y = offY - 2,
			font = "num",
			size = rankFontSize,
			align = "MC",
			text = tostring(rank),
			border = 1,
		})
		
		--玩家名字
		_NodeChild["lab_playername" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 214,
			y = offY - 2,
			font = hVar.FONTC,
			size = 24,
			align = "MC",
			text = name,
			border = 1,
			RGB = {255, 255, 212,},
		})
		
		--进度条
		_NodeChild["img_process_bg" .. index] = hUI.image:new({
			parent = _NodeParent,
			x = 554,
			y = offY - 10,
			model = "misc/totalsettlement/process_light.png",
			align = "MC",
			scale = 0.36,
		})
		
		--进度的敌人BOSS图标
		local processW = _NodeChild["img_process_bg" .. index].data.w
		local processX = _NodeChild["img_process_bg" .. index].data.x
		--for i = 1, stage, 1 do
			--local sModel = string.format("icon/hero/boss_%02d.png", i)
			--_NodeChild["img_boss_" .. index.."|"..i]= hUI.image:new({
				--parent = _NodeParent,
				--x = processX - processW / 2 + i/6 * processW - 2,
				--y =  offY + 25,
				--model = sModel,
				--align = "MC",
				--scale = 0.36,
			--})
		--end

		local sModel = string.format("icon/hero/boss_%02d.png", stage)
		_NodeChild["img_boss_" .. index.."|"..stage]= hUI.image:new({
			parent = _NodeParent,
			x = processX - processW / 2 + stage/6 * processW - 2,
			y =  offY + 25,
			model = sModel,
			align = "MC",
			scale = 0.36,
		})
		
		local tankScale = 0.32
		local tankX = processX - processW / 2 + stage/6 * processW - 2
		local tankY = offY -20
		--进度条战车图标
		_NodeChild["img_tank" .. index] = hUI.thumbImage:new({
			parent = _NodeParent,
			x = tankX,
			y = tankY,
			id = tankId,
			facing = 0,
			align = "MC",
			scale = tankScale * 1,
		})
		
		--进度条战车轮子图标
		_NodeChild["img_tankwheel" .. index] = hUI.thumbImage:new({
			parent = _NodeParent,
			x = tankX,
			y = tankY,
			id = hVar.tab_unit[tankId].bind_wheel,
			facing = 0,
			align = "MC",
			scale = tankScale,
		})
		
		--背景图
		local bgModel = nil
		local lineModel = nil
		if (index % 2 == 0) then
			bgModel = "misc/mask_white.png"
		else
			bgModel = "misc/mask_white.png"
		end
		
		--线条图
		local lineModel = nil --"ui/pvp/td_mui_blbar.png"
		if (rank == 1) then --第1名
			lineModel = "misc/mask_white.png" --"UI:vipline"
		elseif (rank == 2) then --第2名
			lineModel = "misc/mask_white.png"
		elseif (rank == 3) then --第3名
			lineModel = "misc/mask_white.png"
		else --其他名次
			lineModel = "misc/mask_white.png"
		end
		
		--线条颜色
		local lineColor = nil
		if (rank == 1) then --第1名
			--金色
			lineColor = hVar.RANKBOARD_COLOR.GOLD
		elseif (rank == 2) then --第2名
			--银色
			lineColor = hVar.RANKBOARD_COLOR.SILVER
		elseif (rank == 3) then --第3名
			--铜色
			lineColor = hVar.RANKBOARD_COLOR.COPPER
		else --其他名次
			--灰黑色
			lineColor = hVar.RANKBOARD_COLOR.DARKGRAY
		end
		
		--下边界线
		_NodeChild["imageBG_lineD"] = hUI.image:new({
			parent = _NodeParent,
			model = lineModel,
			x = _rankInfoW / 2 + 8,
			y = -_rankInfoH / 2 + 1,
			w = _rankInfoW + 16, --宽
			h = 1,
		})
		_NodeChild["imageBG_lineD"].handle.s:setColor(lineColor) --线条的颜色
		--_NodeChild["imageBG_lineD"].handle.s:setRotation(180+180)
		
		local tabU = hVar.tab_unit[weaponId]
		if tabU then
			if tabU.model then
				--进度条战车武器图标
				_NodeChild["img_tankweapon" .. index] = hUI.thumbImage:new({
					parent = _NodeParent,
					x = tankX,
					y = tankY,
					id = weaponId,
					facing = 0,
					align = "MC",
					scale = tankScale,
				})
			end
			if tabU.effect then
				for i = 1,#tabU.effect do
					local effect = tabU.effect[i]
					local effectId = effect[1]
					local effX = effect[2] or 0
					local effY = effect[3] or 0
					local effScale = effect[4] or 1.0
					--print(effectId, cardId)
					local effModel = effectId
					if (type(effectId) == "number") then
						effModel = hVar.tab_effect[effectId].model
					end
					if effModel then
						_NodeChild["img_tankEffModel" .. index.."|"..i] = hUI.image:new({
							parent = _NodeParent,
							model = effModel,
							align = "MC",
							x = tankX + effX * tankScale,
							y = tankY + effY * tankScale,
							scale = 1.2 * effScale * tankScale,
							z = effect[4] or -1,
						})
						
						local tabM = hApi.GetModelByName(effModel)
						if tabM then
							local tRelease = {}
							local path = tabM.image
							tRelease[path] = 1
							hResource.model:releasePlist(tRelease)
							
							--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
							--[[
							local pngPath = "data/image/"..(tabM.image)
							local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
							
							if texture then
								CCTextureCache:sharedTextureCache():removeTexture(texture)
							end
							]]
						end
					end
				end
			end
		end
		
		_NodeChild["node_bestCK" .. index] = hUI.node:new({
			parent = _NodeParent,
			x = 936 - 60,
			y = offY - 2,
		})
		
		_NodeChild["node_bestCK" .. index].childUI["img_kill"] = hUI.image:new({
			parent = _NodeChild["node_bestCK" .. index].handle._n,
			x =  0,
			y = 24,
			model = "misc/continuouskilling/kill.png",
		})
		
		--连杀加号"+"
		_NodeChild["node_bestCK" .. index].childUI["img_add"] = hUI.image:new({
			parent = _NodeChild["node_bestCK" .. index].handle._n,
			x = - 20,
			y = - 18,
			model = "UI:CKSystemNum",
			scale = 0.8,
			animation = "ADD",
		})
		
		--连杀值
		local sNum = tostring(killNum)
		local length = #sNum
		for j = 1,length do
			local n = math.floor(killNum / (10^(length-j)))% 10
			_NodeChild["node_bestCK" .. index].childUI["lab_n"..j] = hUI.image:new({
				parent = _NodeChild["node_bestCK" .. index].handle._n,
				model = "UI:CKSystemNum",
				animation = "N"..n,
				x = 45 * j * 0.8 - 10,
				y = - 18,
				scale = 0.8,
			})
		end
		_NodeChild["node_bestCK" .. index].handle._n:setScale(0.6)

		--根据连杀数killNum 添加金银铜勋章
		local nRating = hApi.GetAchievementRating(hVar.AchievementType.BATTER,billboard)
		local medalModel = hApi.GetRatingModel(hVar.AchievementType.BATTER,nRating)
		if type(medalModel) == "string" and medalModel ~= "" then
			_NodeChild["img_medal_bg" .. index] = hUI.image:new({
				parent = _NodeParent,
				x = 1010,
				y = offY,
				model = "misc/achievements/medal_bg.png",
				align = "MC",
				--scale = 0.9,
			})

			_NodeChild["img_medal" .. index] = hUI.image:new({
				parent = _NodeParent,
				x = 1010,
				y = offY,
				model = medalModel,
				align = "MC",
				--scale = 0.9,
			})
		end

		--本条是我
		if (rank == rankMe) then
			--标识我的箭头
			_NodeChild["imageBG_RankMe"] = hUI.image:new({
				parent = _NodeParent,
				model = "effect/select_triangle.png",
				x = 18,
				y = offY - 2,
				scale = 1.0,
			})
			_NodeChild["imageBG_RankMe"].handle.s:setRotation(270)
			--动画
			local act1 = CCMoveBy:create(0.2, ccp(4, 0))
			local act2 = CCMoveBy:create(0.2, ccp(-4, 0))
			local act3 = CCMoveBy:create(0.2, ccp(4, 0))
			local act4 = CCMoveBy:create(0.2, ccp(-4, 0))
			local act5 = CCDelayTime:create(1.0)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			local sequence = CCSequence:create(a)
			_NodeChild["imageBG_RankMe"].handle.s:runAction(CCRepeatForever:create(sequence))
			
			--我的名字绿色
			_NodeChild["lab_playername" .. index].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的连杀加号"+"绿色
			_NodeChild["node_bestCK" .. index].childUI["img_add"].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的击杀绿色
			for j = 1,length do
				_NodeChild["node_bestCK" .. index].childUI["lab_n"..j].handle.s:setColor(ccc3(0, 255, 0))
			end
		end
		
	end
	
	--创建我的排名信息
	_CODE_CreateMyRankInfo = function(nIndex,billobardT)
		hApi.safeRemoveT(_childUI,"lab_RankMe")
		local font = "num" --hVar.FONTC
		local text = "--"
		if nIndex > 0 then
			font = "num"
			text = tostring(nIndex)
		end
		local x = (hVar.SCREEN.w - _boardW) / 2 + 250
		local y =  -hVar.SCREEN.h/2 + _boardH/2 - math.floor(61 * _boardScale) - 2

		if g_Cur_Language == 4 then
			x = x + 30
		end
		
		--我的名次文字
		_childUI["lab_RankMe"] = hUI.label:new({
			parent = _parent,
			x = x, 
			y = y,
			font = font,
			size = math.floor(26*_boardScale),
			align = "MC",
			text = text,
			border = 1,
		})

		local nRating = hApi.GetAchievementRating(hVar.AchievementType.CLEARANCE,billobardT[nIndex])
		local medalModel = hApi.GetRatingModel(hVar.AchievementType.CLEARANCE,nRating)
		if type(medalModel) == "string" and medalModel ~= "" then
			_childUI["img_mymedal_bg"] = hUI.image:new({
				parent = _parent,
				x = x + 80, 
				y = y,
				model = "misc/achievements/medal_bg.png",
				align = "MC",
				--scale = 0.9,
			})

			_childUI["img_mymedal"] = hUI.image:new({
				parent = _parent,
				x = x + 80,
				y = y,
				model = medalModel,
				align = "MC",
				--scale = 0.9,
			})
		end
	end

	_CODE_AutoLign = function(offy)
		local Node =_childUI["clipnode"]
		local waittime = 0.2
		Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(_cliprect[1],offy)))
		hApi.addTimerOnce("LegionInfoAutoAlign",waittime*1000+1,function()
			hUI.uiSetXY(Node, _cliprect[1],offy)
			_canDrag = true
		end)
	end

	_CODE_OnPageDrag = function(self,tTempPos,tPickParam)
		--print("_CODE_OnPageDrag")
		if 0 == tPickParam.state then
			if (tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
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
		elseif 1 == tPickParam.state then
			local offy = tTempPos.y-tTempPos.ty
		end
	end

	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)
		if 1 == tPickParam.state then
			local offy = tTempPos.y-tTempPos.ty + tTempPos.oy - _cliprect[2]
			local finaly = offy
			print(offy)
			if offy > _dragrect[4] then
				_canDrag = false
				finaly = _cliprect[2]+_dragrect[4]
			elseif offy < 0 then
				finaly = _cliprect[2]
			else
				return
			end
			_canDrag = false
			--print("finaly",finaly)
			_CODE_AutoLign(finaly)
		elseif 0 == tPickParam.state then

		end
	end

	refresh_query_billboard_timeout_timer = function()
		_currentPage = 0
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(true)
	end
	
	refresh_async_paint_billboard_loop = function()
		if #_asyncCreateList > 0 then
			local data, rank, rankMe = unpack(_asyncCreateList[1])
			_CODE_CreateRankInfo(data, rank, rankMe)
			table.remove(_asyncCreateList,1)
		end
	end

	on_receive_billobard_info_Back = function(result, bId, diff, billobardT)
		if bId ~= hVar.TANK_BILLBOARD_RANK_TYPE.RANK_CONTINOUSKILL then
			return
		end
		print("on_receive_billobard_info_Back",bId)
		--清除计时器
		hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(false)
		
		--我的排名
		local rankMe = billobardT.rankMe
		_CODE_CreateMyRankInfo(rankMe,billobardT)
		
		--local num = math.min(#billobardT,_maxshowLine)
		local num = #billobardT
		for i = 1,num do
			local billboard = billobardT[i]
			_asyncCreateList[#_asyncCreateList+1] = {billboard, billboard.rank, rankMe,}
			--_CODE_CreateRankInfo(billboard, billboard.rank, rankMe)
		end
		local gh = math.max(0,num*_gridWH[2] - _cliprect[4])
		_dragrect = {_cliprect[1], _cliprect[2]+gh, 0, math.max(1, gh)}
		_canDrag = true
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()

		--添加事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_TankBillboardData", "__getAchievementRankData", on_receive_billobard_info_Back)
		
		_CODE_CreateAchievementRankFrm()

		_CODE_ChangePage(1)
	end)
end

hGlobal.UI.InitAchievementInfoByType = function(mode)
	local tInitEventName = {"LocalEvent_ShowAchievementInfoByType","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _frm
	local _parent
	local _childUI

	local _Width = 520
	local _Height = 400

	local _tAchievementKey = {
		[hVar.AchievementType.MAXPET] = "maxtocarry_pet",
		[hVar.AchievementType.ROLLING] = "totalrolling",
		[hVar.AchievementType.ONEPASS] = "onepass_stage"
	} 

	local OnCreateAchievementInfoFrm = hApi.DoNothing
	local OnCreateAchievementCriteria = hApi.DoNothing
	local OnGetAchievementAward = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing

	OnLeaveFunc = function()
		if hGlobal.UI.AchievementInfoFrm then
			hGlobal.UI.AchievementInfoFrm:del()
			hGlobal.UI.AchievementInfoFrm = nil
		end
		_frm = nil
		_parent = nil
		_childUI = nil
	end

	OnCreateAchievementInfoFrm = function()
		hGlobal.UI.AchievementInfoFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})

		_frm = hGlobal.UI.AchievementInfoFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		local offx = hVar.SCREEN.w/2
		local offy = hVar.SCREEN.h/2

		_childUI["black_bg"] = hUI.button:new({
			parent = _parent,
			model = "misc/bar_remould_bg.png", --"UI:playerBagD"
			dragbox = _childUI["dragBox"],
			x = offx,
			y = offy,
			z = -1,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			code = function()
				OnLeaveFunc()
			end,
		})
		_childUI["black_bg"].handle.s:setOpacity(200)
		_childUI["black_bg"].handle.s:setColor(ccc3(0, 0, 0))

		--local btnChild = _childUI["ItemBG_1"].childUI
		--local btnParent = _childUI["ItemBG_1"].handle._n

		_frm:active()
		_frm:show(1)
	end

	local _GetShowAchievementState = function(nAchievementType,nIndex)
		local nShowState = 0	-- 0 未达标 1 可领取 2 已领取
		local nState = LuaGetAchievementState(nAchievementType,nIndex)	--1 领过 0 未领取
		if nState == 1 then
			nShowState = 2
		elseif _tAchievementKey[nAchievementType] then
			local tRatingCriteria = hVar.AchievementRatingCriteria[nAchievementType]
			local tCriteria = tRatingCriteria.criteria
			local Data = LuaGetRandMapSingleBestRecord(_tAchievementKey[nAchievementType])
			if type(Data) == "number" then
				local value = (tCriteria[nIndex] or {})[1] or 0
				print(Data,value)
				if Data >= value then
					nShowState = 1
				end
			end
		end
		return nShowState
	end

	local createGetScoreFloat = function(nScore)
		local text = "+ "..nScore.." "
		local num = #text
		local offx = 90+40*num/2
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 + offx/2 -25,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "RC", 0, 0,nil,offx)

		hUI.floatNumber:new({
			font = "numGreen",
			text = "",
			size = 16,
			x = hVar.SCREEN.w / 2 - 40*num/4 + 12,
			y = hVar.SCREEN.h / 2 - 4,
			align = "LC",
			icon = "misc/skillup/mu_coin.png",
			iconWH = 36,
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		})
	end

	OnCreateAchievementCriteria = function(nAchievementType)
		hApi.safeRemoveT(_childUI,"ItemBG_1")

		local offx = hVar.SCREEN.w/2
		local offy = hVar.SCREEN.h/2
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offx,
			y = offy,
			w = _Width,
			h = _Height,
			code = function()
				--print("技能tip图片背景")
			end,
		})

		local tRatingCriteria = hVar.AchievementRatingCriteria[nAchievementType]
		local tCriteria = tRatingCriteria.criteria
		local tAward = tRatingCriteria.award or {}
		if type(tCriteria) == "table" then
			local nodeChild = _childUI["ItemBG_1"].childUI
			local nodeParent = _childUI["ItemBG_1"].handle._n

			local startY = _Height/2 - 78
			local deltaH = - 76
			local textsize = 22
			if g_Cur_Language == 3 then
				textSize = 16
			elseif g_Cur_Language == 4 then
				textSize = 22
			end 

			local tCanGet = {}
			local notGet = #tCriteria
			for i = 1,#tCriteria do
				local showStage = _GetShowAchievementState(nAchievementType,i)
				nodeChild["img_medal_bg"..i]= hUI.image:new({
					parent = nodeParent,
					x = - _Width/2 + 76, 
					y = startY + deltaH * (i - 1),
					model = "misc/achievements/medal_bg.png",
					align = "MC",
					--scale = 0.9,
				})

				nodeChild["img_medal"..i] = hUI.image:new({
					parent = nodeParent,
					x = - _Width/2 + 76, 
					y = startY + deltaH * (i - 1),
					model = hApi.GetRatingModel(nAchievementType,i),
					align = "MC",
					--scale = 0.9,
				})

				local value = (tCriteria[i] or {})[1] or 0
				local text = string.gsub(hVar.tab_string[tRatingCriteria.text or ""],"#NUM",value)
				local rgb = {140,140,140}
				if showStage > 0 then
					rgb = {255,255,255}
				end
				nodeChild["lab_criteria"..i] = hUI.label:new({
					parent = nodeParent,
					x = - _Width/2 + 120, 
					y = startY + deltaH * (i - 1) + 2,
					align = "LC",
					size = textSize,
					width = 210,
					height = 56,
					border = 0,
					font = hVar.FONTC,
					text = text,
					RGB = rgb,
				})

				nodeChild["img_score"..i] = hUI.image:new({
					parent = nodeParent,
					x = - _Width/2 + 374, 
					y = startY + deltaH * (i - 1),
					model = "misc/skillup/mu_coin.png",
					align = "MC",
					--scale = 0.9,
				})

				if showStage == 2 then
					nodeChild["isGet"] = hUI.image:new({
						parent = nodeParent,
						model = "misc/ok.png",
						x = - _Width/2 + 480,
						y = startY + deltaH * (i - 1),
						w = 28,
						h = 28,
					})
					notGet = notGet - 1
				elseif showStage == 1 then
					tCanGet[#tCanGet+1] = i
				end

				local num = tAward[i] or 0
				nodeChild["lab_score"..i] = hUI.label:new({
					parent = nodeParent,
					x = - _Width/2 + 404,
					y = startY + deltaH * (i - 1) + 2,
					align = "LC",
					size = 20,
					border = 0,
					font = hVar.FONTC,
					text = num,
					RGB = rgb,
				})

				
			end

			local text = hVar.tab_string["receive"]
			if notGet == 0 then
				text = hVar.tab_string["haveget"]
			end
			_childUI["btn_yes"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				scaleT = 0.95,
				x = offx,
				y = offy - 124,
				scale = 0.74,
				--w = 124,
				--h = 52,
				code = function(self)
					if #tCanGet > 0 then
						self:setstate(0)
						OnGetAchievementAward(nAchievementType,tCanGet)
					end
				end,
			})
			if #tCanGet == 0 then
				hApi.AddShader(_childUI["btn_yes"].handle.s, "gray")
			end
		end
	end

	OnGetAchievementAward = function(nAchievementType,tCanGet)
		print("OnGetAchievementAward")
		local count = 0
		for i = 1,#tCanGet do
			local index = tCanGet[i]
			local tRatingCriteria = hVar.AchievementRatingCriteria[nAchievementType]
			local tCriteria = tRatingCriteria.criteria
			local tAward = tRatingCriteria.award or {}
			if tAward[index] and LuaGetAchievementState(nAchievementType,index) == 0 then
				--设置领取标记
				LuaSetAchievementState(nAchievementType,index,1)
				--给奖励
				LuaAddPlayerScoreByWay(tAward[index],hVar.GET_SCORE_WAY.ACHIEVEMENT)

				--漂浮文字
				local ntime = count * 1000
				hApi.addTimerOnce("achievementAward"..i,ntime,function()
					createGetScoreFloat(tAward[index])
				end)
				count = count + 1
			end
		end
		local keyList = {"material",}
		LuaSavePlayerData_Android_Upload(keyList, "成就奖励")
		--界面重置
		OnCreateAchievementCriteria(nAchievementType)
		--刷新积分
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nAchievementType)
		OnLeaveFunc()
		if type(hVar.AchievementRatingCriteria[nAchievementType]) == "table" then
			OnCreateAchievementInfoFrm()
			OnCreateAchievementCriteria(nAchievementType)
		end
	end)
end