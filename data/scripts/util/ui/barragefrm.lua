hGlobal.UI.InitBarrageFrm = function(mode)
	local tInitEventName = {"LocalEvent_OpenBarrage", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _BARRAGEHEIGHT = 72
	local _BARRAGE_ICON_SIZE = 64

	--弹幕播放模式
	local _PLAYBARRAGE_CONFIG = {
		[1] = {
			ShowOrder = "random",	--显示排序 random  随机顺序 normal 时间排序
			MaxShowLine = 3,	--同时显示行数
			StartRandWidth = 100,	--开始的随机距离
			EachBarrageWait = 3000,	--每条弹幕的隔间时间
			PlaySpeed = 1.5,	--播放速度
			PlayRandOffSpeed = 1,	--播放的随机偏移速度
			--1弹幕触碰到底线即可再次使用 
			--2弹幕显示过半即可再次使用
			--3弹幕完全消失即可再次使用
			OrbitMode_horizontal = 1,	--轨道使用模式
			OrbitMode_vertical = 3,	
			useclip_horizontal = 1,		--剪切面板的rect
			useclip_vertical = 2,
		},
	}
	--因横竖屏参数不同 必须动态设置
	local _tClipRectList = {}

	local _tBarrageOrbit = {}
	local _tBarrageList = {}
	local _tPlayHistory = {}
	local _tUpdateList = {}
	local _bPausePlay = false
	local _nBarrageType = 0
	local _nBarrageTypeId = 0
	local _frm,_childUI,_parent = nil,nil,nil
	local _nUseClip = 0
	local _nUseConfigMode = 1
	local _nMoveWidth = hVar.SCREEN.w
	local _sShowMode = "normal"
	local _nMaxOrbitShow = 1
	local _nStartRandWidth = 0
	local _nEachBarrageWait = 100
	local _nBarragePlaySpeed = 1
	local _nBarrageRandPlayOff = 0
	local _nOrbitMode = 1
	local _nLastCreateBarrageTime = 0
	local _oClipNode = nil
	local _tClipNode = nil

	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_ClearFrm = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateBarrageUI = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing
	local _CODE_InitData = hApi.DoNothing
	local _CODE_GetConfig = hApi.DoNothing
	local _CODE_CheckShouldCreateBarrage = hApi.DoNothing
	local _CODE_PlayBarrageMoveAction = hApi.DoNothing
	local _CODE_HideBarrage = hApi.DoNothing
	local _CODE_RecoverBarrage = hApi.DoNothing
	local _CODE_DealWithSpinScreen = hApi.DoNothing
	local _CODE_SpinScreenRecoverBarrage = hApi.DoNothing
	local _CODE_UpdateBarrageInfo = hApi.DoNothing
	local _CODE_UpdateBarrageShow = hApi.DoNothing
	local _CODE_RunTimer = hApi.DoNothing

	_CODE_CloseFunc = function()
		hApi.clearTimer("UpdateBarrageShow")
		_tBarrageOrbit = {}
		_tBarrageList = {}
		_tPlayHistory = {}
		_CODE_ClearEvent()
		_CODE_ClearFrm()
		_bPausePlay = false
		_nBarrageType = 0
		_nBarrageTypeId = 0
		_useConfigMode = 1
		_sShowMode = "normal"
		_nMaxOrbitShow = 1
		_nStartRandWidth = 0
		_nEachBarrageWait = 100
		_nBarragePlaySpeed = 1
		_nBarrageRandPlayOff = 0
		_nOrbitMode = 1
		_nLastCreateBarrageTime = 0
		_nUseConfigMode = 1
	end

	_CODE_ClearFrm = function()
		_nUseClip = 0
		_oClipNode = nil
		_nMoveWidth = hVar.SCREEN.w
		_tClipRectList = {}
		_tUpdateList = {}
		if hGlobal.UI.BarrageFrm then
			hGlobal.UI.BarrageFrm:del()
			hGlobal.UI.BarrageFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
	end

	_CODE_InitData = function(nBarrageType,nBarrageTypeId)
		_nBarrageType = nBarrageType
		_nBarrageTypeId = nBarrageTypeId
		_tPlayHistory = {
			totalnum = 0,
			totalplaynum = 0,
			curplaynum = 0,
			playlist = {},
		}
		_tBarrageOrbit = {}
		_CODE_GetConfig()
	end

	_CODE_GetConfig = function()
		--因横竖屏参数不同 必须动态设置
		_tClipRectList = {
			[1] = {
				0,-80,hVar.SCREEN.w - hVar.SCREEN.offx,hVar.SCREEN.h - 80,
			},
			[2] = {
				0,-160,hVar.SCREEN.w,hVar.SCREEN.h - 400,
			},
		}
		local tConfig = _PLAYBARRAGE_CONFIG[_nUseConfigMode]
		if tConfig then
			_sShowMode = tConfig.ShowOrder
			_nMaxOrbitShow = tConfig.MaxShowLine
			_nStartRandWidth = tConfig.StartRandWidth
			_nEachBarrageWait = tConfig.EachBarrageWait
			_nBarragePlaySpeed = tConfig.PlaySpeed
			_nBarrageRandPlayOff = tConfig.PlayRandOffSpeed
			_nOrbitMode = tConfig.OrbitMode
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				_nUseClip = tConfig.useclip_horizontal or 0
				_nOrbitMode = tConfig.OrbitMode_horizontal or 3
			else
				_nUseClip = tConfig.useclip_vertical or 0
				_nOrbitMode = tConfig.OrbitMode_vertical or 3
			end
		end
		local height = hVar.SCREEN.h
		local width = hVar.SCREEN.w
		if _nUseClip > 0 then
			local rect = _tClipRectList[_nUseClip]
			if rect then
				width = rect[3]
				height = rect[4]
			end
		end
		_nMoveWidth = width
		local n = math.floor(height/_BARRAGEHEIGHT)
		--print("_CODE_GetConfig",n)
		for i = 1,n do
			_tBarrageOrbit[i] = {
				nState = 0,
				x = width,
				y = - (i-0.5) * _BARRAGEHEIGHT,
			}
		end
		
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.BarrageFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,"UI:zhezhao",
			dragable = 0,
			buttononly = 1,
			show = 0,
			z = hZorder.CommentFrm + 2,
		})

		_frm = hGlobal.UI.BarrageFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		if _nUseClip > 0 then
			local rect = _tClipRectList[_nUseClip]
			if type(rect) == "table" then
				local pClipper,pClipperMask,pClipperMaskN = hApi.CreateClippingNode(_frm, rect, 5, 0)
				_oClipNode = pClipper
				_tClipNode = {pClipper,pClipperMask,pClipperMaskN}
				_childUI["node"] = hUI.node:new({
					parent = _oClipNode,
					x = rect[1],
					y = rect[2],
				})
				
			end
		end

		_frm:show(1)
		_frm:active()
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","__Barragefrm",_CODE_DealWithSpinScreen)
		hGlobal.event:listen("LocalEvent_Barrage_Clean","__Barragefrm",_CODE_CloseFunc)
		hGlobal.event:listen("LocalEvent_HideBarrage","__Barragefrm",_CODE_HideBarrage)
		hGlobal.event:listen("LocalEvent_RecoverBarrage","__Barragefrm",_CODE_RecoverBarrage)
		hGlobal.event:listen("LocalEvent_UpdateBarrageInfo","__Barragefrm",_CODE_UpdateBarrageInfo)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","__Barragefrm",nil)
		hGlobal.event:listen("LocalEvent_Barrage_Clean","__Barragefrm",nil)
		hGlobal.event:listen("LocalEvent_HideBarrage","__Barragefrm",nil)
		hGlobal.event:listen("LocalEvent_RecoverBarrage","__Barragefrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateBarrageInfo","__Barragefrm",nil)
	end

	_CODE_HideBarrage = function()
		if _frm then
			_frm:show(0)
			if type(_tClipNode) == "table" then
				hApi.EnableClipNode(_tClipNode,0)
			end
			_bPausePlay = true
		end
	end
	
	_CODE_RecoverBarrage = function()
		if _frm then
			_frm:show(1)
			if type(_tClipNode) == "table" then
				hApi.EnableClipNode(_tClipNode,1)
			end
			_bPausePlay = false
		end
	end

	_CODE_UpdateBarrageInfo = function()
		print("_CODE_UpdateBarrageInfo")
		local tBarrageCache = CommentManage.GetBarrageCache(_nBarrageType,_nBarrageTypeId)
		if tBarrageCache then
			for barrageId,tInfo in pairs(tBarrageCache.Data) do
				if _tBarrageList[barrageId] == nil then
					_tBarrageList[barrageId] = tInfo
					_tPlayHistory.totalnum = _tPlayHistory.totalnum + 1
				end
			end
		end
	end

	_CODE_CreateBarrageUI = function(nBarrageId,nUseOrbit)
		print("_CODE_CreateBarrageUI",nBarrageId,nUseOrbit)
		local barrageOrbit = _tBarrageOrbit[nUseOrbit]
		local tBarrageInfo = _tBarrageList[nBarrageId]
		if barrageOrbit and tBarrageInfo then
			_nLastCreateBarrageTime = math.floor(os.clock() * 1000)
			_tPlayHistory.totalplaynum = _tPlayHistory.totalplaynum + 1
			_tPlayHistory.curplaynum = _tPlayHistory.curplaynum + 1
			_tPlayHistory.playlist[nBarrageId] = {}
			_tPlayHistory.playlist[nBarrageId].useorbit = nUseOrbit
			barrageOrbit.nState = 1	--创建阶段
			local showX = barrageOrbit.x
			local showY = barrageOrbit.y
			local randwidth = 0
			local parent = _parent
			local childUI = _childUI
			if _nUseClip > 0 then
				parent = _childUI["node"].handle._n
				childUI = _childUI["node"].childUI
			end
			if _nStartRandWidth > 0 then
				randwidth = math.random(0,_nStartRandWidth)
				showX = showX + randwidth
			end
			
			hApi.safeRemoveT(childUI,"node_barrage"..nBarrageId)
			childUI["node_barrage"..nBarrageId] = hUI.node:new({
				parent = parent,
				x = showX,
				y = showY,
			})
			local node = childUI["node_barrage"..nBarrageId]
			local nodeChild = node.childUI
			local nodeParent = node.handle._n

			--table_print(tBarrageInfo)
			nodeChild["img_icon"] = hUI.image:new({
				parent = nodeParent,
				model = tBarrageInfo.icon,
				x = _BARRAGE_ICON_SIZE/2,
				w = _BARRAGE_ICON_SIZE,
				h = _BARRAGE_ICON_SIZE,
			})

			nodeChild["lab_barrage"] = hUI.label:new({
				parent = nodeParent,
				align = "LC",
				size = 32,
				font = hVar.FONTC,
				text = tBarrageInfo.str,
				x = _BARRAGE_ICON_SIZE,
			})
			local w = nodeChild["lab_barrage"]:getWH()

			nodeChild["img_labbg"] = hUI.image:new({
				parent = nodeParent,
				model = "misc/selectbg.png",
				x = _BARRAGE_ICON_SIZE + w/2,
				w = w + 180,
				h = _BARRAGE_ICON_SIZE,
				z = -1,
			})
			--print("w",w)

			local playspeed = _nBarragePlaySpeed
			if _nBarrageRandPlayOff > 0 then
				playspeed = playspeed + (math.random(0,_nBarrageRandPlayOff*10)/10)
			end

			_tPlayHistory.playlist[nBarrageId].state = 1
			_tPlayHistory.playlist[nBarrageId].curx = 0
			_tPlayHistory.playlist[nBarrageId].startx = showX
			_tPlayHistory.playlist[nBarrageId].starty = showY
			_tPlayHistory.playlist[nBarrageId].width = w + _BARRAGE_ICON_SIZE
			_tPlayHistory.playlist[nBarrageId].randwidth = randwidth
			_tPlayHistory.playlist[nBarrageId].playspeed = playspeed
			--table_print(tBarrageInfo)
		end
	end

	_CODE_CheckShouldCreateBarrage = function()
		if _tPlayHistory.totalplaynum < _tPlayHistory.totalnum then
			if _tPlayHistory.curplaynum < _nMaxOrbitShow then 
				local curtime = math.floor(os.clock() * 1000)
				if curtime - _nLastCreateBarrageTime > _nEachBarrageWait then
					--寻找可用的轨道
					local tCanShowOrbit = {}
					for i = 1,#_tBarrageOrbit do
						if _tBarrageOrbit[i] and _tBarrageOrbit[i].nState == 0 then
							tCanShowOrbit[#tCanShowOrbit + 1] = i
						end
					end

					if #tCanShowOrbit > 0 then
						if #_tUpdateList > 0 then
							local barrageId = _tUpdateList[1]
							table.remove(_tUpdateList,1)
							local useOrbit = tCanShowOrbit[math.random(1,#tCanShowOrbit)]
							_CODE_CreateBarrageUI(barrageId,useOrbit)
						else
							--乱序
							local tCanShow = {}
							if _sShowMode == "random" then
								--乱序
								for barrageId in pairs(_tBarrageList) do
									if _tPlayHistory.playlist[barrageId] == nil then
										tCanShow[#tCanShow + 1] = barrageId
									end
								end
							else
								--时间顺序
								local tBarrageCache = CommentManage.GetBarrageCache(_nBarrageType,_nBarrageTypeId)
								if tBarrageCache then
									tCanShow = tBarrageCache.tShowIdx
								end
							end
							if #tCanShow > 0 then
								local barrageId = 0
								if _sShowMode == "random" then
									barrageId = tCanShow[math.random(1,#tCanShow)]
								else
									barrageId = tCanShow[1]
								end
								local useOrbit = tCanShowOrbit[math.random(1,#tCanShowOrbit)]
								_CODE_CreateBarrageUI(barrageId,useOrbit)
							end
						end
					end
				end
			end
		end
	end

	_CODE_SpinScreenRecoverBarrage = function()
		--重新赋值
		_tPlayHistory.curplaynum = 0
		_tPlayHistory.totalplaynum = 0
		for i = 1,#_tBarrageOrbit do
			if _tBarrageOrbit[i] then
				_tBarrageOrbit[i].nState = 0
			end
		end
		local playlist = _tPlayHistory.playlist
		local clearlist = {}
		for nBarrageId,tInfo in pairs(playlist) do
			if tInfo.state >= 1 and tInfo.state < 5 then
				if tInfo.state == 4 then
					tInfo.state = 5
				else
					local curx = tInfo.curx

					if tInfo.state == 1 then
						_tUpdateList[#_tUpdateList + 1] = nBarrageId
						clearlist[#clearlist + 1] = nBarrageId
					elseif tInfo.state == 2 then
						if tInfo.haveclear ~= 1 then
							tInfo.haveclear = 1
						end
						tInfo.state = 5
					elseif tInfo.state == 3 then
						if tInfo.haveclear ~= 1 then
							tInfo.haveclear = 1
						end
						tInfo.state = 5
					end
				end
				if tInfo.state == 5 then
					_tPlayHistory.totalplaynum = _tPlayHistory.totalplaynum + 1
				end
			else
				_tPlayHistory.totalplaynum = _tPlayHistory.totalplaynum + 1
			end
		end
		for i = 1,#clearlist do
			local nBarrageId = clearlist[i]
			_tPlayHistory.playlist[nBarrageId] = nil
		end
	end

	_CODE_PlayBarrageMoveAction = function()
		local playlist = _tPlayHistory.playlist
		local parentnode = _parent
		local childUI = _childUI
		if _nUseClip > 0 then
			parentnode = _childUI["node"]
			childUI = parentnode.childUI
		end
		for nBarrageId,tInfo in pairs(playlist) do
			if tInfo.state >= 1 and tInfo.state < 5 then
				local node = childUI["node_barrage"..nBarrageId]
				if node then
					if tInfo.state == 4 then
						hApi.safeRemoveT(childUI,"node_barrage"..nBarrageId)
						tInfo.state = 5
					else
						local playspeed = tInfo.playspeed
						local useorbit = tInfo.useorbit
						hUI.uiSetXY(node,node.data.x - playspeed ,node.data.y)
						tInfo.curx = tInfo.curx + playspeed

						--1弹幕触碰到底线即可再次使用 
						--2弹幕显示过半即可再次使用
						--3弹幕完全消失即可再次使用
						local movehalf = 0
						if tInfo.curx - tInfo.randwidth > _nMoveWidth/2 then
							movehalf = 1
							--print("22222",nBarrageId)
						end
						if tInfo.curx - tInfo.randwidth > _nMoveWidth then
							tInfo.state = 2	--头触碰到底线
							--print("11111",nBarrageId)
						end
						if tInfo.curx - tInfo.randwidth > _nMoveWidth + tInfo.width then
							tInfo.state = 3	--尾触碰到底线
							--print("33333",nBarrageId)
						end
						local shouldclear = 0
						if _nOrbitMode == 1 then
							if tInfo.state == 2 then
								shouldclear = 1
								if _tBarrageOrbit[useorbit] then
									_tBarrageOrbit[useorbit].nState = 0
								end
							end
						elseif _nOrbitMode == 2 then
							if movehalf == 1 then
								shouldclear = 1
								if _tBarrageOrbit[useorbit] then
									_tBarrageOrbit[useorbit].nState = 0
								end
							end
						elseif _nOrbitMode == 3 then
							if tInfo.state == 3 then
								shouldclear = 1
								if _tBarrageOrbit[useorbit] then
									_tBarrageOrbit[useorbit].nState = 0
								end
							end
						end
						if tInfo.state == 3 then
							tInfo.state = 4	--下一帧删除 
						end
						if shouldclear == 1 and tInfo.haveclear ~= 1 then
							tInfo.haveclear = 1
							_tPlayHistory.curplaynum = math.max(0,_tPlayHistory.curplaynum-1)
						end
					end
				end
			end
		end
	end

	_CODE_UpdateBarrageShow = function()
		if _bPausePlay == false then
			_CODE_CheckShouldCreateBarrage()
			_CODE_PlayBarrageMoveAction()
		end
	end

	_CODE_RunTimer = function()
		hApi.addTimerForever("UpdateBarrageShow",hVar.TIMER_MODE.GAMETIME,2,_CODE_UpdateBarrageShow)
	end

	_CODE_DealWithSpinScreen = function()
		hApi.clearTimer("UpdateBarrageShow")
		_nLastCreateBarrageTime = 0
		_CODE_ClearFrm()
		_CODE_GetConfig()
		_CODE_CreateFrm()
		_CODE_SpinScreenRecoverBarrage()
		_CODE_RunTimer()
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nBarrageType,nBarrageTypeId)
		_CODE_ClearFrm()
		_CODE_InitData(nBarrageType,nBarrageTypeId)
		_CODE_CreateFrm()
		_CODE_AddEvent()
		_CODE_RunTimer()
	end)
end
if true then
	return
end
local BOARD_WIDTH = 720 --面板的宽度
local BOARD_HEIGHT = 640 --面板的高度
local BOARD_POS_X = hVar.SCREEN.w * 0.1 - BOARD_WIDTH * 0.1 
local BOARD_POS_Y = hVar.SCREEN.h * 0.9 + BOARD_HEIGHT * 0.1

local BARRAGE_BOARD_Z_ORDER = 9001


local BARRAGE_INFO_MOVE_SPEED = 100					--弹幕每秒移动速度
local BARRAGE_INFO_MOVE_INTERVAL = 30				--弹幕每次移动间隔时间，毫秒
local BARRAGE_TRACK_COUNT = 10						--弹幕轨道数量
local BARRAGE_TRACK_USE_COUNT = 3					--弹幕可使用轨道数量
local BARRAGE_TEXT_SIZE = 30						--弹幕文字大小
local BARRAGE_TEXT_COLOR = {255, 255, 255,}			--弹幕文字颜色
local BARRAGE_INFO_INSERT_DISTANCE = 60				--同一轨道弹幕间隔
local BARRAGE_INFO_CLEAR_DISTANCE = 0				--弹幕消失距离
local BARRAGE_INFO_RANDOM_INSERT_DELAY = 6000		--弹幕插入时的随机延迟

local BARRAGE_ICON_SIZE = 64						--弹幕图标宽度
local BARRAGE_TEXT_OFFSET_X = 32					--弹幕文字偏移
local BARRAGE_TEXT_BACKGOUND = "misc/selectbg.png"	--弹幕文字底图
local BARRAGE_TEXT_BACKGOUND_SIZE = 35


if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then		--竖屏模式
	if (g_phone_mode == 1) then --iPhone4
		--
	elseif (g_phone_mode == 2) then --iPhone5
		--
	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8

	elseif (g_phone_mode == 4) then --iPhoneX

	elseif (g_phone_mode == 5) then --安卓宽屏

	elseif (g_phone_mode == 6) then --平板宽屏

	end
else									--横屏模式
	if (g_phone_mode == 1) then --iPhone4

	elseif (g_phone_mode == 2) then --iPhone5

	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8

	elseif (g_phone_mode == 4) then --iPhoneX

	elseif (g_phone_mode == 5) then --安卓宽屏

	elseif (g_phone_mode == 6) then --平板宽屏

	end
end


local CommentType2String = {
	[1] = "tab_unit",
	[2] = "tab_tactics",
}

local CommentTypeStringName = {
	[1] = "tab_stringU",
	[2] = "tab_stringT",
}


local function IsCommandString(content)
	local resultStrList = hApi.Split(content,"##")
	local isCommand,icon,name,text = false,nil,nil
	if #resultStrList > 2 then
		local itemType = tonumber(resultStrList[2])
		local itemID = tonumber(resultStrList[3])
		if CommentType2String[itemType] and hVar[CommentType2String[itemType]] and hVar[CommentType2String[itemType]][itemID] then
			icon = hVar[CommentType2String[itemType]][itemID].icon
		end
		if CommentTypeStringName[itemType] and hVar[CommentTypeStringName[itemType]] and hVar[CommentTypeStringName[itemType]][itemID] then
			name = hVar[CommentTypeStringName[itemType]][itemID][1]
		else
			name = resultStrList[3]
		end
		text = resultStrList[4]
		--print("IsCommandString")
		isCommand = true
	end
	return isCommand,icon,name,text
end


local CleanSelf = hApi.DoNothing
local PausePlaySelf = hApi.DoNothing
local PauseSelf = hApi.DoNothing
local ShowSelf = hApi.DoNothing

local firstBarrage = true

local isPause = false

hGlobal.event:listen("LocalEvent_SpinScreen","__Barrage",function()
	BOARD_POS_X = hVar.SCREEN.w * 0.1 - BOARD_WIDTH * 0.1 
	BOARD_POS_Y = hVar.SCREEN.h * 0.9 + BOARD_HEIGHT * 0.1
end)

--打开弹幕面板
hGlobal.event:listen("LocalEvent_Barrage_Open", "__BarrageOpen__", function(commentType,tyepID,beginIndex)
	if hGlobal.UI.BarrageFrm == nil then
		hGlobal.UI.InitBarrageFrm()
		SendCmdFunc["comment_system_query_barrage"](commentType,tyepID,beginIndex)
	end
	ShowSelf()
end)

--隐藏/显示弹幕面板
hGlobal.event:listen("LocalEvent_Barrage_PausePlay", "__BarragePausePlay__", function()
	if hGlobal.UI.BarrageFrm ~= nil then
		PausePlaySelf()
	end
end)

--隐藏弹幕面板
hGlobal.event:listen("LocalEvent_Barrage_Pause", "__BarragePause__", function()
	if hGlobal.UI.BarrageFrm ~= nil then
		PauseSelf()
	end
end)

--清理弹幕面板，删除面板资源
hGlobal.event:listen("LocalEvent_Barrage_Clean", "__BarrageClean__", function()
	CleanSelf()
end)

--弹幕面板
hGlobal.UI.InitBarrageFrm = function(mode)
	--系统加载时，不创建
	if mode ~= nil then
		return
	end
	
	--不重复创建弹幕面板
	if hGlobal.UI.BarrageFrm then 
		return
	end
	
	local barrageData = {}
	--	id
	--	content
	--	color
	--	size
	--	speed

	local barrageViewManager = {}
	local barrageChannelInsert = {}
	
	local CreateOneBarrageInfoView = hApi.DoNothing
	local MoveBarrageInfo = hApi.DoNothing
	local AddBarrageInfoToChannel = hApi.DoNothing
	local AddBarrageInfoToVIew = hApi.DoNothing
	local UpdateBarrageView = hApi.DoNothing

	for i = 1, BARRAGE_TRACK_COUNT do
		table.insert(barrageViewManager,{})
	end

	--创建弹幕面板
	hGlobal.UI.BarrageFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = 1,
		h = 1,
		dragable = 0,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = -1,
		autoactive = 0,
		z = BARRAGE_BOARD_Z_ORDER,
		
		--点击事件
		--codeOnTouch = function(self, x, y, sus)
		--end,
	})

	local _frm = hGlobal.UI.BarrageFrm
	local _parent = _frm.handle._n
	
	local barrageFrmClippingRect = {0, 0, BOARD_WIDTH, BOARD_HEIGHT, 0} -- {x, y, w, h, show}
	local barrageFrmClipNode = hApi.CreateClippingNode(_frm, barrageFrmClippingRect, 98, 0, "BarrageFrmClipNode")


	--[[
	--关闭按钮
	local closeDx = -30
	local closeDy = -20
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			CleanSelf()
		end,
	})
	--]]

	CreateOneBarrageInfoView = function(node,barrageText,fontSize,fontColor)
		local floatDataRoot = hUI.button:new({
			parent = node,
			model = -1,
			x = 0,
			y = 0,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT,
		})

		local textSize = fontSize or BARRAGE_TEXT_SIZE

		local isCommand,icon,name,text = IsCommandString(barrageText)
		if isCommand then
			barrageText = text or barrageText
		end

		local textOffsetX = 0
		local length = hApi.GetStringEmojiCNLength(barrageText) --处理表情，中文长度
		local textLength = length * textSize
		if icon then
			textOffsetX = BARRAGE_TEXT_OFFSET_X
		end

		local background =  hUI.image:new({
			parent = floatDataRoot.handle._n,
			model = BARRAGE_TEXT_BACKGOUND,
			x = (textLength + textOffsetX)/2 - 10,
			y = 0,
			align = "LT",
			w = textLength + textOffsetX + 170,
			h = BARRAGE_TEXT_BACKGOUND_SIZE,
		})


		if icon then
			local roleIcon =  hUI.image:new({
				parent = floatDataRoot.handle._n,
				model = icon,
				x = 0,
				y = 0,
				align = "LT",
				w = BARRAGE_ICON_SIZE,
				h = BARRAGE_ICON_SIZE,
			})
		end


		local floatDataText = hUI.label:new({
				parent = floatDataRoot.handle._n,
				x = textOffsetX,
				y = 2,
				font = hVar.FONTC,
				size = textSize,
				align = "LC",
				width = textLength,
				height = BOARD_HEIGHT / BARRAGE_TRACK_COUNT,
				text = barrageText,
				border = 1,
			})

		fontColor = fontColor or BARRAGE_TEXT_COLOR

		floatDataText.handle.s:setColor(ccc3(fontColor[1], fontColor[2], fontColor[3]))

		--[[
		local floatDataButton = hUI.button:new({
			parent = floatDataRoot.handle._n,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = textLength,
			y =  0,
			scaleT = 0.95,
			code = function()
				print("testfloatText")
			end,
		})
		--]]

		return floatDataRoot,textLength + textOffsetX
	end

	MoveBarrageInfo = function(barrageInfo,speed)
		local moveSpeed = speed / 1000 * BARRAGE_INFO_MOVE_INTERVAL
		local x,y,w,h = hUI.uiGetXYWH(barrageInfo) 
		hUI.uiSetXY(barrageInfo,x - moveSpeed ,y)
		return x - moveSpeed ,y
	end

	AddBarrageInfoToChannel = function(channelIndex,insertData)
		local data = insertData.data
		local barrageInfo,textLength = CreateOneBarrageInfoView(barrageFrmClipNode,data.content,data.size,data.color)
		AddBarrageInfoToVIew(channelIndex,barrageInfo)
		table.insert(barrageViewManager[channelIndex],{
			view = barrageInfo,
			speed = data.speed or BARRAGE_INFO_MOVE_SPEED,
			id = data.id,
			length = textLength,
		})
	end

	AddBarrageInfoToVIew = function(channelIndex,barrageInfo)
		local channelHeight = BOARD_HEIGHT / BARRAGE_TRACK_COUNT
		local y = -(channelIndex-1)*channelHeight - channelHeight/2
		hUI.uiSetXY(barrageInfo,BOARD_WIDTH,y)
	end

	UpdateBarrageView = function()
		if isPause then
			return
		end
		local idleChannel = {}
		local delayInserts = {}
		--检查插入管道，插入消息
		for channelIndex,data in pairs(barrageChannelInsert)do
			data.delay = data.delay - BARRAGE_INFO_MOVE_INTERVAL
			if data.delay <0 then
				AddBarrageInfoToChannel(channelIndex,data)
				table.insert(delayInserts,channelIndex)
			end
		end
		--清除插入管道中已插入消息
		for _,channelIndex in ipairs(delayInserts)do
			barrageChannelInsert[channelIndex] = nil
		end

		--检查整个弹幕轨道
		for channelIndex,channelContent in ipairs(barrageViewManager)do
			local isIdleChannel = false
			--检查弹幕轨道中弹幕是否已经可以清除，是否可以插入
			for i = #channelContent,1,-1 do
				local content = channelContent[i]
				local x,y = MoveBarrageInfo(content.view,content.speed)
				--判断当前轨道是否可以插入
				if (x + content.length) < BARRAGE_INFO_INSERT_DISTANCE then
					isIdleChannel = true
				end
				--判断当前轨道弹幕是否可以清除
				if (x + content.length) < BARRAGE_INFO_CLEAR_DISTANCE then
					table.remove(channelContent,i)
					content.view:del()
				end
			end
			--是否已经有需要插入的弹幕
			if barrageChannelInsert[channelIndex] ~= nil then
				isIdleChannel = false
			--如果当前轨道空，可以插入
			elseif #channelContent == 0 then
				isIdleChannel = true
			end
			if isIdleChannel then
				table.insert(idleChannel,channelIndex)
			end
		end
		--有空闲轨道，并且有未处理弹幕数据
		local noUseChannelCount = BARRAGE_TRACK_COUNT - BARRAGE_TRACK_USE_COUNT
		if #idleChannel > noUseChannelCount and #barrageData>0 then
			--随机选取一条空闲轨道
			local idle = hApi.random(1,#idleChannel)
			local channelIndex = idleChannel[idle]
			--弹幕数据放入空闲轨道准备插入
			local delayTime = 0
			if firstBarrage then
				firstBarrage = false
			else
				delayTime = hApi.random(1,BARRAGE_INFO_RANDOM_INSERT_DELAY)
			end
			barrageChannelInsert[channelIndex] = {
				data = barrageData[1],
				delay = delayTime,
			}
			--print("barrageChannelInsert[channelIndex]	" , channelIndex,barrageData[1])
			table.remove(barrageData,1)
		end
	end

	CleanSelf = function()
		if hGlobal.UI.BarrageFrm then --删除界面
			hGlobal.UI.BarrageFrm:del()
			hGlobal.UI.BarrageFrm = nil
			
			hApi.clearTimer("__BARRAGE_VIEW_UPDATE__")
			hGlobal.event:listen("localEvent_Barrage_DataChange", "__BarrageDataChange__",nil)
		end

		--清空数据
		barrageData = nil
		barrageViewManager = nil
		barrageChannelInsert = nil
		firstBarrage = true
		isPause = false
	end

	PausePlaySelf = function()
		if isPause then
			_frm:show(1)
			isPause = false
		else
			_frm:show(0)
			isPause = true
		end
		hGlobal.event:event("LocalEvent_MainMenu_Barrage_On_OFF", not isPause)
	end

	PauseSelf = function()
		_frm:show(0)
		isPause = true
		hGlobal.event:event("LocalEvent_MainMenu_Barrage_On_OFF", not isPause)
	end
	
	ShowSelf = function()
		hGlobal.UI.BarrageFrm:show(1)
		hGlobal.UI.BarrageFrm:active()	

		isPause = false

		hApi.addTimerForever("__BARRAGE_VIEW_UPDATE__", hVar.TIMER_MODE.GAMETIME, BARRAGE_INFO_MOVE_INTERVAL, UpdateBarrageView)
		
		--添加事件监听：收到弹幕数据变化回调
		hGlobal.event:listen("localEvent_Barrage_DataChange", "__BarrageDataChange__", function(data)
			table.insert(barrageData,data)
			--print("__BarrageDataChange__	",data.id,data.content)
			UpdateBarrageView()
		end)
	
	end

end

--test
--[[
--测试代码
if hGlobal.UI.BarrageFrm then --删除上一次的游戏币变化界面
	hGlobal.UI.BarrageFrm:del()
	hGlobal.UI.BarrageFrm = nil
end
hGlobal.UI.InitBarrageFrm() --

hGlobal.event:event("LocalEvent_Barrage_Open")


for i = 1,10 do
	hGlobal.event:event("localEvent_Barrage_DataChange", {
			content = 'abcdfge',
			speed = 50,
			color = {0,255,0},
			id = i,
		})

end

--]]
